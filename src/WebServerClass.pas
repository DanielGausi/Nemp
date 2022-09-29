{

    Unit WebServerClass

    - NempWebServer

    The WebServer is called by the Indy-Http-Server through multiple Threads
    (if more than one user try to use it at once)
    The Synchronisation-scheme is as follow:
    - Access to the Playlist is done in the VCL-Thread only. For this:
        - The Server-Thread enter a Critical Section
        - Send query to the main window
        - call "NempWebServer.GetWhatEver" in VCL-Thread
        - store the reply in local variable
        - Leave Critical Section
        - Send Data
    - Access to the Library is done in secondary threads.
      The Webserver uses a copy of the library, so changing the library in local
      Nemp has no effect on Webserver.
        - The Server-Thread enter a CS
        - call "NempWebServer.GetWhatEver" (multiple reading is allowed)
        - store the reply in local variable
        - Leave CS
        - Send Data


    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}
unit WebServerClass;

interface

uses Windows, Classes, Messages, ContNrs, SysUtils,  dialogs,
  IniFiles,  StrUtils, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdCustomHTTPServer, IdHTTPServer, IdContext,
  NempAudioFiles, Hilfsfunktionen, HtmlHelper,
  Playlistclass, PlayerClass, Nemp_ConstantsAndTypes,
  MedienbibliothekClass, BibSearchClass, Votings,
  AudioDisplayUtils;

const
    // Messages für WebServer:
    WM_WebServer = WM_USER + 800;

    WS_QueryPlayer = 10;
    WS_QueryPlayerAdmin = 110;
    WS_QueryPlayerJS = 11;
    WS_QueryPlayerJSAdmin = 111;
    WS_QueryPlaylist = 1;
    WS_QueryPlaylistAdmin = 101;

    WS_QueryPlaylistDetail = 2;
    WS_QueryPlaylistDetailAdmin = 102;

    WS_PlaylistPlayID = 3;

    WS_InsertNext = 4;
    WS_AddToPlaylist = 5;

    WS_PlaylistMoveUp = 7;
    WS_PlaylistMoveUpCheck = 17;
    WS_PlaylistMoveDown = 8;
    WS_PlaylistMoveDownCheck  = 18;

    WS_QueryPlaylistItem = 20;
    WS_QueryPlaylistItemAdmin = 120;

    WS_PlaylistDelete = 9;

    //    WM_QueryPlaylistDownload = 5553;
    WS_PlaylistDownloadID = 6;

    WS_StringLog = 100;

    // Messages for voting.
    // use these only inside the criticalSection "CS_Vote" !!!
    WS_VoteID = 25;                 // Vote for the file with this ID
    WS_VoteFilename = 26;  // Vote for a given Filename (more complicated!!)
    WS_AddAndVoteThisFile = 27;


    WS_IPC_GETPROGRESS = 401;  // for webserver. Values between 0 and 100
    WS_IPC_SETPROGRESS = 402; // for webserver. Values between 0 and 100

    WS_IPC_GETVOLUME = 403;  // for webserver. Values between 0 and 100
    WS_IPC_SETVOLUME = 404;  // for webserver. Values between 0 and 100

    WS_IPC_INCVOLUME = 405;  // for webserver. Increase Volume
    WS_IPC_DECVOLUME = 406;  // for webserver. Decrease Volume





type
  TWebServerSettings = record
    AllowFileDownload,  //   := True;
    AllowLibraryAccess, //= True;
    AllowVotes,         // := True;
    AllowRemoteControl: Boolean;//  := True;
    Port: Word;               //Word; //                := 80;
    Theme,               //:= 'Default';
    UsernameU,          // := '' ;
    PasswordU,          // := '';
    UsernameA,          // := 'master';
    PasswordA: String;//           := 'key';
  end;

const
  cDefaultServerSettings: TWebServerSettings =
  (
    AllowFileDownload : True;
    AllowLibraryAccess: True;
    AllowVotes        : True;
    AllowRemoteControl: True;
    Port: 80;
    Theme     : 'Default';
    UsernameU : '' ;
    PasswordU : '';
    UsernameA : 'master';
    PasswordA : 'key';
  );


type
  TQueryResult = (qrPermit, qrDeny, qrRemoteControlDenied,
                  qrDownloadDenied, qrLibraryAccessDenied,
                  qrFileNotFound, qrInvalidParameter, qrError);

  type TCountedString = class
      private
          fValue: String;
          fSecondValue: String; // used for "artist" at counted strings of type "ALBUM"
          fCount: Integer;
          fCoverID: String;
          fFontSize: Integer;
      public
          property Value: String read fValue;
          property SecondValue: String read fSecondValue;
          property Count: Integer read fCount;
          property CoverID: String read fCoverID;
          property FontSize: Integer read fFontSize;
          constructor Create(aValue: String; c: Integer; aCoverID: String);
          procedure Assign(aCS: tCountedString);
          procedure getSecondValue(SourceList: TStringList);
  end;

  TDoubleString = Array[Boolean] of String;


  TNempWebServer = class
      private
          fMainHandle: DWord;
          fMainWindowHandle: DWord; // Eventually we need 2 handles - Options and mainwindow

          fCurrentMaxID: Integer;

          fWebMedienBib: TAudioFileList;
          fWebDisplay: TAudioDisplay;

          fHTML_Player: UTf8String;
          fHTML_PlaylistView: Utf8String;
          fHTML_PlaylistDetails: UTf8String;
          fQueriedPlaylistFilename: UnicodeString;

          fHTML_MedienbibSearchForPlay: UTf8String;

          fUsernameU: String;
          fPasswordU: String;

          fUsernameA: String;
          fPasswordA: String;

          fTheme : String;

          // fOnlyLAN               : Longbool;
          fAllowPlaylistDownload : Longbool;
          fAllowLibraryAccess    : Longbool;
          fAllowRemoteControl    : Longbool;
          fAllowVotes            : LongBool;
          fPort                  : Word;

          // VCL-Variable
          fActive: Boolean;

          IdHTTPServer1: TIdHTTPServer;
          fLocalFormatSettings: TFormatSettings;
          fLocalDir: UnicodeString;
          fLastErrorString: String;

          PatternBody: TDoubleString;
          // Buttons for Player Control
          PatternPlayerControls: TDoubleString;
          PatternButtonNext : TDoubleString;
          // PatternButtonPlayPause : String;
          PatternButtonPause : TDoubleString;
          PatternButtonPlay : TDoubleString;
          PatternButtonPrev : TDoubleString;
          PatternButtonStop : TDoubleString;
          // Buttons for Files
          PatternButtonFileDownload : TDoubleString;
          PatternButtonFileMoveUp   : TDoubleString;
          PatternButtonFileMoveDown : TDoubleString;
          PatternButtonFileDelete   : TDoubleString;
          PatternButtonFilePlayNow  : TDoubleString;
          PatternButtonFileAdd      : TDoubleString;
          PatternButtonFileAddnext  : TDoubleString;
          PatternButtonFileVote     : TDoubleString;

          PatternMenu : TDoubleString;
          PatternBrowseMenu : TDoubleString;
          PatternPagination : TDoubleString;
          PatternPaginationNext : TDoubleString;
          PatternPaginationPrev : TDoubleString;
          PatternPaginationOther: TDoubleString;
          PatternPaginationMain: TDoubleString;


          PatternPlayerPage: TDoubleString;
          PatternItemPlayer: TDoubleString;   // the item on the PLAYER page

          PatternPlaylistPage: TDoubleString;
          PatternItemPlaylist: TDoubleString;  // one item on the PLAYLIST page

          PatternPlaylistDetailsPage : TDoubleString;
          PatternItemPlaylistDetails : TDoubleString; // the item on the Detail-Page

          PatternSearchPage: TDoubleString;
          //PatternSearchResultPage: TDoubleString;
          PatternItemSearchlist: TDoubleString;  // one item on the SEARCHLIST page

          PatternSearchDetailsPage : TDoubleString;
          PatternItemBrowseArtist  : TDoubleString;
          PatternItemBrowseAlbum   : TDoubleString;
          PatternItemBrowseGenre   : TDoubleString;

          PatternItemSearchDetails : TDoubleString; // the item on the Search-Detail-Page

          PatternNoFilesHint: TDoubleString;
          PatternErrorPage: TDoubleString;

          // Lists for Browsing in the Library
          MainArtists  : Array [0..26] of TObjectList;
          OtherArtists : Array [0..27] of TObjectList;
          Albums       : Array [0..27] of TObjectList;
          Genres       : TObjectList;


          function fGetUsernameU: String;
          procedure fSetUsernameU(Value: String);
          function fGetPasswordU: String;
          procedure fSetPasswordU(Value: String);

          function fGetUsernameA: String;
          procedure fSetUsernameA(Value: String);
          function fGetPasswordA: String;
          procedure fSetPasswordA(Value: String);

          function fGetTheme: String;
          procedure fSetTheme(Value: String);

          //procedure fSetOnlyLAN              (Value: Longbool);
          procedure fSetAllowPlaylistDownload(Value: Longbool);
          procedure fSetAllowLibraryAccess   (Value: Longbool);
          procedure fSetAllowRemoteControl   (Value: Longbool);
          procedure fSetAllowVotes           (Value: Longbool);

          //function fGetOnlyLAN              : Longbool;
          function fGetAllowPlaylistDownload: Longbool;
          function fGetAllowLibraryAccess   : Longbool;
          function fGetAllowRemoteControl   : Longbool;
          function fGetAllowVotes           : Longbool;

          function MainMenu(aPage: Integer; IsAdmin: Boolean): String;
          function BrowseSubMenu(aMode: String; aLetter: Char; aValue: String; IsAdmin: Boolean): String;

          function fGetCount: Integer;

          // replace basic Insert-tags like {{artist}} in a given pattern
          function fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
          // replace InsertTags for Buttons
          function fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer; isAdmin: Boolean; IsPlayingFile: Boolean = False): String;

          function fSetControlButtons(aPattern: String; isPlaying, isAdmin: Boolean): String;

          // The following methods have been methods of a WebServerForm-Class
          // ---->
          procedure logQuery(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; Permit: TQueryResult);
          procedure logQueryAuth(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo);

          function HandleError(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult; isAdmin: Boolean): TQueryResult;
          function GenerateErrorPage(aErrorMessage: String; aPage: Integer; isAdmin: Boolean): String;

          procedure AddNoCacheHeader(AResponseInfo: TIdHTTPResponseInfo);
          function ResponsePlayer (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponsePlayerJS (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseJSPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseClassicPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseCover (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseJSPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseSearchInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseBrowseInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseLibraryDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          procedure IdHTTPServer1CommandGet(AContext: TIdContext;
              ARequestInfo: TIdHTTPRequestInfo;
              AResponseInfo: TIdHTTPResponseInfo);

          // ---->

          procedure SetActive(Value: Boolean);
          procedure LoadTemplates(isAdmin: Boolean);
          procedure TemplateFallback;

          procedure SetFontSizes(aList: TObjectList);
          procedure ClearHelperLists;
          procedure PrepareArtists;
          procedure MergeArtistsIfNecessary;

          procedure PrepareAlbums;
          procedure PrepareGenres;

          function LoadSettingsDeprecated: Boolean;
          procedure LoadDefaultSettings;

      public
          SavePath: UnicodeString;

          // Loglist logs all access to Webserver.
          // Note: Access this list only from VCL-Thread!
          //       IDhttpServer will add strings via SendMessage.
          LogList: TStringList;

          VoteMachine: TVoteMachine;


          property UsernameU: string read fGetUsernameU write fSetUsernameU;
          property PasswordU: string read fGetPasswordU write fSetPasswordU;
          property UsernameA: string read fGetUsernameA write fSetUsernameA;
          property PasswordA: string read fGetPasswordA write fSetPasswordA;
          property Theme : String read fGetTheme  write fSetTheme;
          // property OnlyLAN               : Longbool read fGetOnlyLAN               write fSetOnlyLAN              ;
          property AllowFileDownload     : Longbool read fGetAllowPlaylistDownload write fSetAllowPlaylistDownload;
          property AllowLibraryAccess    : Longbool read fGetAllowLibraryAccess    write fSetAllowLibraryAccess   ;
          property AllowRemoteControl    : Longbool read fGetAllowRemoteControl    write fSetAllowRemoteControl   ;
          property AllowVotes            : Longbool read fGetAllowVotes            write fSetAllowVotes           ;

          property Port : Word    read fPort write fPort;
          property Count: Integer read fGetCount;

          property Active: Boolean read fActive write SetActive;
          property LastErrorString: String read fLastErrorString;

          property HTML_Player: UTf8String read fHTML_Player write fHTML_Player;
          property HTML_PlaylistView: Utf8String read fHTML_PlaylistView write fHTML_PlaylistView;
          property HTML_PlaylistDetails: UTf8String read fHTML_PlaylistDetails write fHTML_PlaylistDetails;
          property QueriedPlaylistFilename: UnicodeString read fQueriedPlaylistFilename write fQueriedPlaylistFilename;

          property HTML_MedienbibSearchForPlay: UTf8String read fHTML_MedienbibSearchForPlay write fHTML_MedienbibSearchForPlay;

          constructor Create(aHandle: DWord);
          destructor Destroy; override;
          procedure LoadSettings;
          procedure SaveSettings;

          procedure GetThemes(dest: TStrings);

          // Im VCL-Thread ausführen, mit CS geschützt
          // d.h. Message an Form Senden, die das dann ausführt

          function ValidIP(aIP, bIP: String): Boolean;

          procedure GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; aPart: Integer; isAdmin: Boolean);
          procedure GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist; isAdmin: Boolean);
          procedure GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer; isAdmin: Boolean);

          function GenerateHTMLfromPlaylistItem(aNempPlayList: TNempPlaylist; aIdx: Integer; isAdmin: Boolean): String;

          // Das kann im Indy-Thread geamcht werden, daher mit Result
          function GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString; Start: Integer; isAdmin: Boolean): UTf8String;
          function GenerateHTMLfromMedienbibSearch_Details(aAudioFile: TAudioFile; isAdmin: Boolean): UTf8String;

          function GenerateHTMLMedienbibBrowseList(aMode: String; aChar: Char; other, isAdmin: Boolean): UTf8String;
          function GenerateHTMLMedienbibBrowseResult(aMode: String; aValue: String; Start: Integer; isAdmin: Boolean): UTf8String;

          procedure Shutdown;
          procedure CopyLibrary(OriginalLib: TMedienBibliothek);
          procedure CopyDisplayHelper;

          procedure SearchLibrary(Keyword: UnicodeString; DestList: TAudioFileList);
          function GetAudioFileFromWebServerID(aID: Integer): TAudioFile;

          procedure EnsureFileHasID(af: tAudioFile);

  end;



// MIMEExtensions and function FileType2MimeType copied from
// http://extpascal.googlecode.com/svn-history/r655/trunk/IdExtHTTPServer.pas
// licensed as http://opensource.org/licenses/BSD-3-Clause
type
    TMimeExtension = record
        Ext: string;
        MimeType: string;
    end;

const
  MIMEExtensions: array[1..176] of TMimeExtension = (
    (Ext: '.gif'; MimeType: 'image/gif'),
    (Ext: '.jpg'; MimeType: 'image/jpeg'),
    (Ext: '.jpeg'; MimeType: 'image/jpeg'),
    (Ext: '.html'; MimeType: 'text/html'),
    (Ext: '.htm'; MimeType: 'text/html'),
    (Ext: '.css'; MimeType: 'text/css'),
    (Ext: '.js'; MimeType: 'text/javascript'),
    (Ext: '.txt'; MimeType: 'text/plain'),
    (Ext: '.xls'; MimeType: 'application/excel'),
    (Ext: '.rtf'; MimeType: 'text/richtext'),
    (Ext: '.wq1'; MimeType: 'application/x-lotus'),
    (Ext: '.wk1'; MimeType: 'application/x-lotus'),
    (Ext: '.raf'; MimeType: 'application/raf'),
    (Ext: '.png'; MimeType: 'image/x-png'),
    (Ext: '.c'; MimeType: 'text/plain'),
    (Ext: '.c++'; MimeType: 'text/plain'),
    (Ext: '.pl'; MimeType: 'text/plain'),
    (Ext: '.cc'; MimeType: 'text/plain'),
    (Ext: '.h'; MimeType: 'text/plain'),
    (Ext: '.talk'; MimeType: 'text/x-speech'),
    (Ext: '.xbm'; MimeType: 'image/x-xbitmap'),
    (Ext: '.xpm'; MimeType: 'image/x-xpixmap'),
    (Ext: '.ief'; MimeType: 'image/ief'),
    (Ext: '.jpe'; MimeType: 'image/jpeg'),
    (Ext: '.tiff'; MimeType: 'image/tiff'),
    (Ext: '.tif'; MimeType: 'image/tiff'),
    (Ext: '.rgb'; MimeType: 'image/rgb'),
    (Ext: '.g3f'; MimeType: 'image/g3fax'),
    (Ext: '.xwd'; MimeType: 'image/x-xwindowdump'),
    (Ext: '.pict'; MimeType: 'image/x-pict'),
    (Ext: '.ppm'; MimeType: 'image/x-portable-pixmap'),
    (Ext: '.pgm'; MimeType: 'image/x-portable-graymap'),
    (Ext: '.pbm'; MimeType: 'image/x-portable-bitmap'),
    (Ext: '.pnm'; MimeType: 'image/x-portable-anymap'),
    (Ext: '.bmp'; MimeType: 'image/x-ms-bmp'),
    (Ext: '.ras'; MimeType: 'image/x-cmu-raster'),
    (Ext: '.pcd'; MimeType: 'image/x-photo-cd'),
    (Ext: '.cgm'; MimeType: 'image/cgm'),
    (Ext: '.mil'; MimeType: 'image/x-cals'),
    (Ext: '.cal'; MimeType: 'image/x-cals'),
    (Ext: '.fif'; MimeType: 'image/fif'),
    (Ext: '.dsf'; MimeType: 'image/x-mgx-dsf'),
    (Ext: '.cmx'; MimeType: 'image/x-cmx'),
    (Ext: '.wi'; MimeType: 'image/wavelet'),
    (Ext: '.dwg'; MimeType: 'image/vnd.dwg'),
    (Ext: '.dxf'; MimeType: 'image/vnd.dxf'),
    (Ext: '.svf'; MimeType: 'image/vnd.svf'),
    (Ext: '.au'; MimeType: 'audio/basic'),
    (Ext: '.snd'; MimeType: 'audio/basic'),
    (Ext: '.aif'; MimeType: 'audio/x-aiff'),
    (Ext: '.aiff'; MimeType: 'audio/x-aiff'),
    (Ext: '.aifc'; MimeType: 'audio/x-aiff'),
    (Ext: '.wav'; MimeType: 'audio/x-wav'),
    (Ext: '.mpa'; MimeType: 'audio/x-mpeg'),
    (Ext: '.abs'; MimeType: 'audio/x-mpeg'),
    (Ext: '.mpega'; MimeType: 'audio/x-mpeg'),
    (Ext: '.mp2a'; MimeType: 'audio/x-mpeg-2'),
    (Ext: '.mpa2'; MimeType: 'audio/x-mpeg-2'),
    (Ext: '.es'; MimeType: 'audio/echospeech'),
    (Ext: '.vox'; MimeType: 'audio/voxware'),
    (Ext: '.lcc'; MimeType: 'application/fastman'),
    (Ext: '.ra'; MimeType: 'application/x-pn-realaudio'),
    (Ext: '.ram'; MimeType: 'application/x-pn-realaudio'),
    (Ext: '.mmid'; MimeType: 'x-music/x-midi'),
    (Ext: '.skp'; MimeType: 'application/vnd.koan'),
    (Ext: '.talk'; MimeType: 'text/x-speech'),
    (Ext: '.mpeg'; MimeType: 'video/mpeg'),
    (Ext: '.mpg'; MimeType: 'video/mpeg'),
    (Ext: '.mpe'; MimeType: 'video/mpeg'),
    (Ext: '.mpv2'; MimeType: 'video/mpeg-2'),
    (Ext: '.mp2v'; MimeType: 'video/mpeg-2'),
    (Ext: '.qt'; MimeType: 'video/quicktime'),
    (Ext: '.mov'; MimeType: 'video/quicktime'),
    (Ext: '.avi'; MimeType: 'video/x-msvideo'),
    (Ext: '.movie'; MimeType: 'video/x-sgi-movie'),
    (Ext: '.vdo'; MimeType: 'video/vdo'),
    (Ext: '.viv'; MimeType: 'video/vnd.vivo'),
    (Ext: '.pac'; MimeType: 'application/x-ns-proxy-autoconfig'),
    (Ext: '.ai'; MimeType: 'application/postscript'),
    (Ext: '.eps'; MimeType: 'application/postscript'),
    (Ext: '.ps'; MimeType: 'application/postscript'),
    (Ext: '.rtf'; MimeType: 'application/rtf'),
    (Ext: '.pdf'; MimeType: 'application/pdf'),
    (Ext: '.mif'; MimeType: 'application/vnd.mif'),
    (Ext: '.t'; MimeType: 'application/x-troff'),
    (Ext: '.tr'; MimeType: 'application/x-troff'),
    (Ext: '.roff'; MimeType: 'application/x-troff'),
    (Ext: '.man'; MimeType: 'application/x-troff-man'),
    (Ext: '.me'; MimeType: 'application/x-troff-me'),
    (Ext: '.ms'; MimeType: 'application/x-troff-ms'),
    (Ext: '.latex'; MimeType: 'application/x-latex'),
    (Ext: '.tex'; MimeType: 'application/x-tex'),
    (Ext: '.texinfo'; MimeType: 'application/x-texinfo'),
    (Ext: '.texi'; MimeType: 'application/x-texinfo'),
    (Ext: '.dvi'; MimeType: 'application/x-dvi'),
    (Ext: '.doc'; MimeType: 'application/msword'),
    (Ext: '.oda'; MimeType: 'application/oda'),
    (Ext: '.evy'; MimeType: 'application/envoy'),
    (Ext: '.gtar'; MimeType: 'application/x-gtar'),
    (Ext: '.tar'; MimeType: 'application/x-tar'),
    (Ext: '.ustar'; MimeType: 'application/x-ustar'),
    (Ext: '.bcpio'; MimeType: 'application/x-bcpio'),
    (Ext: '.cpio'; MimeType: 'application/x-cpio'),
    (Ext: '.shar'; MimeType: 'application/x-shar'),
    (Ext: '.zip'; MimeType: 'application/zip'),
    (Ext: '.hqx'; MimeType: 'application/mac-binhex40'),
    (Ext: '.sit'; MimeType: 'application/x-stuffit'),
    (Ext: '.sea'; MimeType: 'application/x-stuffit'),
    (Ext: '.fif'; MimeType: 'application/fractals'),
    (Ext: '.bin'; MimeType: 'application/octet-stream'),
    (Ext: '.uu'; MimeType: 'application/octet-stream'),
    (Ext: '.exe'; MimeType: 'application/octet-stream'),
    (Ext: '.src'; MimeType: 'application/x-wais-source'),
    (Ext: '.wsrc'; MimeType: 'application/x-wais-source'),
    (Ext: '.hdf'; MimeType: 'application/hdf'),
    (Ext: '.ls'; MimeType: 'text/javascript'),
    (Ext: '.mocha'; MimeType: 'text/javascript'),
    (Ext: '.vbs'; MimeType: 'text/vbscript'),
    (Ext: '.sh'; MimeType: 'application/x-sh'),
    (Ext: '.csh'; MimeType: 'application/x-csh'),
    (Ext: '.pl'; MimeType: 'application/x-perl'),
    (Ext: '.tcl'; MimeType: 'application/x-tcl'),
    (Ext: '.spl'; MimeType: 'application/futuresplash'),
    (Ext: '.mbd'; MimeType: 'application/mbedlet'),
    (Ext: '.swf'; MimeType: 'application/x-director'),
    (Ext: '.pps'; MimeType: 'application/mspowerpoint'),
    (Ext: '.asp'; MimeType: 'application/x-asap'),
    (Ext: '.asn'; MimeType: 'application/astound'),
    (Ext: '.axs'; MimeType: 'application/x-olescript'),
    (Ext: '.ods'; MimeType: 'application/x-oleobject'),
    (Ext: '.opp'; MimeType: 'x-form/x-openscape'),
    (Ext: '.wba'; MimeType: 'application/x-webbasic'),
    (Ext: '.frm'; MimeType: 'application/x-alpha-form'),
    (Ext: '.wfx'; MimeType: 'x-script/x-wfxclient'),
    (Ext: '.pcn'; MimeType: 'application/x-pcn'),
    (Ext: '.ppt'; MimeType: 'application/vnd.ms-powerpoint'),
    (Ext: '.svd'; MimeType: 'application/vnd.svd'),
    (Ext: '.ins'; MimeType: 'application/x-net-install'),
    (Ext: '.ccv'; MimeType: 'application/ccv'),
    (Ext: '.vts'; MimeType: 'workbook/formulaone'),
    (Ext: '.wrl'; MimeType: 'x-world/x-vrml'),
    (Ext: '.vrml'; MimeType: 'x-world/x-vrml'),
    (Ext: '.vrw'; MimeType: 'x-world/x-vream'),
    (Ext: '.p3d'; MimeType: 'application/x-p3d'),
    (Ext: '.svr'; MimeType: 'x-world/x-svr'),
    (Ext: '.wvr'; MimeType: 'x-world/x-wvr'),
    (Ext: '.3dmf'; MimeType: 'x-world/x-3dmf'),
    (Ext: '.ma'; MimeType: 'application/mathematica'),
    (Ext: '.msh'; MimeType: 'x-model/x-mesh'),
    (Ext: '.v5d'; MimeType: 'application/vis5d'),
    (Ext: '.igs'; MimeType: 'application/iges'),
    (Ext: '.dwf'; MimeType: 'drawing/x-dwf'),
    (Ext: '.showcase'; MimeType: 'application/x-showcase'),
    (Ext: '.slides'; MimeType: 'application/x-showcase'),
    (Ext: '.sc'; MimeType: 'application/x-showcase'),
    (Ext: '.sho'; MimeType: 'application/x-showcase'),
    (Ext: '.show'; MimeType: 'application/x-showcase'),
    (Ext: '.ins'; MimeType: 'application/x-insight'),
    (Ext: '.insight'; MimeType: 'application/x-insight'),
    (Ext: '.ano'; MimeType: 'application/x-annotator'),
    (Ext: '.dir'; MimeType: 'application/x-dirview'),
    (Ext: '.lic'; MimeType: 'application/x-enterlicense'),
    (Ext: '.faxmgr'; MimeType: 'application/x-fax-manager'),
    (Ext: '.faxmgrjob'; MimeType: 'application/x-fax-manager-job'),
    (Ext: '.icnbk'; MimeType: 'application/x-iconbook'),
    (Ext: '.wb'; MimeType: 'application/x-inpview'),
    (Ext: '.inst'; MimeType: 'application/x-install'),
    (Ext: '.mail'; MimeType: 'application/x-mailfolder'),
    (Ext: '.pp'; MimeType: 'application/x-ppages'),
    (Ext: '.ppages'; MimeType: 'application/x-ppages'),
    (Ext: '.sgi-lpr'; MimeType: 'application/x-sgi-lpr'),
    (Ext: '.tardist'; MimeType: 'application/x-tardist'),
    (Ext: '.ztardist'; MimeType: 'application/x-ztardist'),
    (Ext: '.wkz'; MimeType: 'application/x-wingz'),
    (Ext: '.xml'; MimeType: 'application/xml'),
    (Ext: '.iv'; MimeType: 'graphics/x-inventor'));

function FileType2MimeType(const AFileName: string): string;


var
    CS_AccessHTMLCode: RTL_CRITICAL_SECTION;
    CS_AccessPlaylistFilename: RTL_CRITICAL_SECTION;
    CS_AccessLibrary: RTL_CRITICAL_SECTION;
    CS_Authentification: RTL_CRITICAL_SECTION;

const
    GoodArtist = 5;
    GoodAlbum  = 3;
    MergeArtistConst = 50;
    MaxCountPerPage = 100;

implementation

uses Nemp_RessourceStrings, AudioFileHelper, StringHelper, CoverHelper;

function FileType2MimeType(const AFileName: string): string;
var
  FileExt: string;
  I: Integer;
begin
  Result := 'text/html';
  FileExt := ExtractFileExt(AFileName);
  for I := Low(MIMEExtensions) to High(MIMEExtensions) do
    if SameText(MIMEExtensions[I].Ext, FileExt) then
    begin
        Result := MIMEExtensions[I].MimeType;
        Break;
    end;
end;


// copied from the den Indys, added '&'
function ParamsEncode(const ASrc: UTF8String): UnicodeString;
var i: Integer;
begin
  Result := '';
  for i := 1 to Length(ASrc) do
  begin
    if (ASrc[i] in ['&', '*','#','%','<','>',' ','[',']'])
       or (not (ASrc[i] in [#33..#127]))
    then
    begin
      Result := Result + '%' + IntToHex(Ord(ASrc[i]), 2);
    end
    else
    begin
      Result := Result + WideChar(ASrc[i]);
    end;
  end;
end;


{ TCountedString }
procedure TCountedString.Assign(aCS: tCountedString);
begin
    fValue    := aCS.fValue;
    fCount    := aCS.fCount;
    fCoverID  := aCS.fCoverID;
    fFontSize := aCS.fFontSize;
    fSecondValue := aCS.fSecondValue;
end;

constructor TCountedString.Create(aValue: String; c: Integer; aCoverID: String);
begin
    if trim(aValue) = '' then
        fValue := 'N/A'
    else
        fValue := aValue;
    fCount := c;
    if trim(aCoverID) = '' then
        fCoverID := '1'
    else
        fCoverID := aCoverID;

    fSecondValue := '';
    fFontSize := 10;
end;


procedure TCountedString.getSecondValue(SourceList: TStringlist);
var fehlstelle: Integer;
begin
    fSecondValue := GetCommonString(SourceList, 0, fehlstelle);
    if fSecondValue = '' then
        fSecondValue := 'Various artists';
end;

constructor TNempWebServer.Create(aHandle: DWord);
var i: Integer;
begin
    inherited create;
    fMainHandle := aHandle;
    fMainWindowHandle := aHandle;
    fCurrentMaxID  := 1;
    Active := False;
    fWebMedienBib := TAudioFileList.Create(False);
    fWebDisplay := TAudioDisplay.Create;
    IdHTTPServer1 := TIdHTTPServer.Create(Nil);
    IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;


    fLocalFormatSettings := TFormatSettings.Create;
    //GetLocaleFormatSettings(LOCALE_USER_DEFAULT, fLocalFormatSettings);
    UsernameU := '';
    PasswordU := '';

    UsernameA := 'master';
    PasswordA := 'key';

    LogList := TStringList.Create;
    VoteMachine := TVoteMachine.Create(aHandle);
    VoteMachine.LibraryList := fWebMedienBib;

    for i := 0 to 26 do
    begin
        MainArtists[i] := TObjectList.Create;
        OtherArtists[i] := TObjectList.Create;
        Albums[i] := TObjectList.Create;
    end;
    Genres := TObjectList.Create;
end;

destructor TNempWebServer.Destroy;
var i: Integer;
begin
    IdHTTPServer1.Active := False;
    EnterCriticalSection(CS_AccessLibrary);
    for i := 0 to 26 do
    begin
        MainArtists[i].Free;
        OtherArtists[i].Free;
        Albums[i].Free;
    end;
    Genres.Free;

    for i := 0 to fWebMedienBib.Count - 1 do
        fWebMedienBib[i].Free;
    fWebDisplay.Free;
    fWebMedienBib.Free;
    LeaveCriticalSection(CS_AccessLibrary);
    IdHTTPServer1.Free;
    VoteMachine.Free;
    LogList.Free;
    inherited;
end;

function TNempWebServer.LoadSettingsDeprecated: Boolean;
var ini: TMemIniFile;
begin
  result := FileExists(NempSettingsManager.SavePath + 'NempWebServer.ini');
  if not result then
    exit;

  ini := TMeminiFile.Create(SavePath + 'NempWebServer.ini', TEncoding.UTF8);
  try
    ini.Encoding := TEncoding.UTF8;
    // aus der Ini lesen
    // OnlyLAN             := True; //Ini.ReadBool('Remote', 'OnlyLAN'               , True);
    AllowFileDownload   := Ini.ReadBool('Remote', 'AllowPlaylistDownload' , cDefaultServerSettings.AllowFileDownload);
    AllowLibraryAccess  := Ini.ReadBool('Remote', 'AllowLibraryAccess'    , cDefaultServerSettings.AllowLibraryAccess);
    AllowVotes          := Ini.ReadBool('Remote', 'AllowVotes'            , cDefaultServerSettings.AllowVotes);
    AllowRemoteControl  := Ini.ReadBool('Remote', 'AllowRemoteControl'    , cDefaultServerSettings.AllowRemoteControl);
    Port                := Ini.ReadInteger('Remote', 'Port', cDefaultServerSettings.Port);
    Theme               := Ini.ReadString('Remote', 'Theme' , cDefaultServerSettings.Theme);
    UsernameU           := Ini.ReadString('Remote', 'UsernameU', cDefaultServerSettings.UsernameU  );
    PasswordU           := Ini.ReadString('Remote', 'PasswordU', cDefaultServerSettings.PasswordU  );
    UsernameA           := Ini.ReadString('Remote', 'UsernameA', cDefaultServerSettings.UsernameA  );
    PasswordA           := Ini.ReadString('Remote', 'PasswordA', cDefaultServerSettings.PasswordA  );
  finally
    ini.Free;
  end;
end;

procedure TNempWebServer.LoadDefaultSettings;
begin
  AllowFileDownload   := cDefaultServerSettings.AllowFileDownload ;
  AllowLibraryAccess  := cDefaultServerSettings.AllowLibraryAccess;
  AllowVotes          := cDefaultServerSettings.AllowVotes        ;
  AllowRemoteControl  := cDefaultServerSettings.AllowRemoteControl;
  Port                := cDefaultServerSettings.Port              ;
  Theme               := cDefaultServerSettings.Theme             ;
  UsernameU           := cDefaultServerSettings.UsernameU         ;
  PasswordU           := cDefaultServerSettings.PasswordU         ;
  UsernameA           := cDefaultServerSettings.UsernameA         ;
  PasswordA           := cDefaultServerSettings.PasswordA         ;
end;

procedure TNempWebServer.LoadSettings;
begin
  if NempSettingsManager.SectionExists('Webserver') then
  begin
    AllowFileDownload   := NempSettingsManager.ReadBool('Webserver', 'AllowPlaylistDownload' , cDefaultServerSettings.AllowFileDownload );
    AllowLibraryAccess  := NempSettingsManager.ReadBool('Webserver', 'AllowLibraryAccess'    , cDefaultServerSettings.AllowLibraryAccess);
    AllowVotes          := NempSettingsManager.ReadBool('Webserver', 'AllowVotes'            , cDefaultServerSettings.AllowVotes        );
    AllowRemoteControl  := NempSettingsManager.ReadBool('Webserver', 'AllowRemoteControl'    , cDefaultServerSettings.AllowRemoteControl);
    Port                := NempSettingsManager.ReadInteger('Webserver', 'Port', cDefaultServerSettings.Port);
    Theme               := NempSettingsManager.ReadString('Webserver', 'Theme'    , cDefaultServerSettings.Theme    );
    UsernameU           := NempSettingsManager.ReadString('Webserver', 'UsernameU', cDefaultServerSettings.UsernameU);
    PasswordU           := NempSettingsManager.ReadString('Webserver', 'PasswordU', cDefaultServerSettings.PasswordU);
    UsernameA           := NempSettingsManager.ReadString('Webserver', 'UsernameA', cDefaultServerSettings.UsernameA);
    PasswordA           := NempSettingsManager.ReadString('Webserver', 'PasswordA', cDefaultServerSettings.PasswordA);
  end else
  begin
    if not LoadSettingsDeprecated then
      LoadDefaultSettings;
  end;
end;

procedure TNempWebServer.SaveSettings;
begin
  NempSettingsManager.WriteBool('Webserver', 'AllowPlaylistDownload' , AllowFileDownload );
  NempSettingsManager.WriteBool('Webserver', 'AllowLibraryAccess'    , AllowLibraryAccess);
  NempSettingsManager.WriteBool('Webserver', 'AllowVotes'            , AllowVotes        );
  NempSettingsManager.WriteBool('Webserver', 'AllowRemoteControl'    , AllowRemoteControl);
  NempSettingsManager.WriteInteger('Webserver', 'Port'               , Port              );
  NempSettingsManager.WriteString('Webserver', 'Theme'               , Theme             );
  NempSettingsManager.WriteString('Webserver', 'UsernameU'           , UsernameU         );
  NempSettingsManager.WriteString('Webserver', 'PasswordU'           , PasswordU         );
  NempSettingsManager.WriteString('Webserver', 'UsernameA'           , UsernameA         );
  NempSettingsManager.WriteString('Webserver', 'PasswordA'           , PasswordA         );

  // delete deprecated .ini (not used any longer)
  if FileExists(NempSettingsManager.SavePath + 'NempWebServer.ini') then
    DeleteFile(NempSettingsManager.SavePath + 'NempWebServer.ini');
end;


function TNempWebServer.fGetUsernameU: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fUsernameU;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetUsernameU(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fUsernameU := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetPasswordU: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fPasswordU;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetPasswordU(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fPasswordU := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetUsernameA: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fUsernameA;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetUsernameA(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fUsernameA := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetPasswordA: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fPasswordA;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetPasswordA(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fPasswordA := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetTheme: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fTheme;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetTheme(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fTheme := Value;
    LeaveCriticalSection(CS_Authentification);
end;

//procedure TNempWebServer.fSetOnlyLAN(Value: Longbool);
//begin
//    InterLockedExchange(Integer(fOnlyLAN), Integer(Value));
//end;
procedure TNempWebServer.fSetAllowPlaylistDownload(Value: Longbool);
begin
    InterLockedExchange(Integer(fAllowPlaylistDownload), Integer(Value));
end;
procedure TNempWebServer.fSetAllowLibraryAccess(Value: Longbool);
begin
    InterLockedExchange(Integer(fAllowLibraryAccess), Integer(Value));
end;
procedure TNempWebServer.fSetAllowRemoteControl(Value: Longbool);
begin
    InterLockedExchange(Integer(fAllowRemoteControl), Integer(Value));
end;
procedure TNempWebServer.fSetAllowVotes(Value: Longbool);
begin
    InterLockedExchange(Integer(fAllowVotes), Integer(Value));
end;

//function TNempWebServer.fGetOnlyLAN: Longbool;
//begin
//  InterLockedExchange(Integer(Result), Integer(fOnlyLAN));
//end;
function TNempWebServer.fGetAllowPlaylistDownload: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fAllowPlaylistDownload));
end;
function TNempWebServer.fGetAllowLibraryAccess: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fAllowLibraryAccess));
end;
function TNempWebServer.fGetAllowRemoteControl: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fAllowRemoteControl));
end;
function TNempWebServer.fGetAllowVotes: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fAllowVotes));
end;

function TNempWebServer.MainMenu(aPage: Integer; IsAdmin: Boolean): String;
begin
    result := PatternMenu[isAdmin];

    if aPage = 0 then
        result := StringReplace(result, '{{PlayerClass}}', 'player active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlayerClass}}', 'player', [rfReplaceAll]);

    if aPage = 1 then
        result := StringReplace(result, '{{PlaylistClass}}', 'playlist active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlaylistClass}}', 'playlist', [rfReplaceAll]);

    if AllowLibraryAccess or IsAdmin then
    begin
        if aPage = 2 then
            result := StringReplace(result, '{{LibraryClass}}', 'library active', [rfReplaceAll])
        else
            result := StringReplace(result, '{{LibraryClass}}', 'library', [rfReplaceAll]);
    end
    else
        result := StringReplace(result, '{{LibraryClass}}', 'hidden', [rfReplaceAll]);
end;

function TNempWebServer.BrowseSubMenu(aMode: String; aLetter: Char; aValue: String; isAdmin: Boolean): String;
var sub: String;
    c: Char;
    letterClass: String;
    idx: Integer;
begin
    result := PatternBrowseMenu[isAdmin];

    if aMode = 'artist' then
        result := StringReplace(result, '{{ArtistClass}}', 'artist active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{ArtistClass}}', 'artist', [rfReplaceAll]);

    if aMode = 'album' then
        result := StringReplace(result, '{{AlbumClass}}', 'album active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{AlbumClass}}', 'album', [rfReplaceAll]);

    if aMode = 'genre' then
        result := StringReplace(result, '{{GenreClass}}', 'genre active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{GenreClass}}', 'genre', [rfReplaceAll]);

    if aMode = '' then // fallback
        sub := '';

    if (aMode = 'genre')then
    begin
        if aValue = '' then
            sub := ''
        else
            sub := '<ul class="charselection"> <li class="genre active">' +  EscapeHTMLChars(aValue) + '</li></ul>';
    end
    else
    begin
        sub := '<ul class="charselection">';

        if aLetter = '0' then
            letterClass := 'other active'
        else
            letterClass := 'other';

        if ((aMode = 'artist') and (MainArtists[0].Count + OtherArtists[0].Count > 0))
          or ((aMode = 'album') and (Albums[0].Count > 0))
        then
            sub := sub +  '<li class="' + letterClass + '"> <a href="browse?mode=' + aMode + '&l=0">0-9</a></li>'#13#10;

        for c := 'A' to 'Z' do
        begin
            if c = aLetter then
                letterClass := c + ' active'
            else
                letterClass := c;

            idx := ord(c) - ord('A') + 1;

            if ((aMode = 'artist') and (MainArtists[idx].Count + OtherArtists[idx].Count > 0))
              or ((aMode = 'album') and (Albums[idx].Count > 0))
            then
                sub := sub + '<li class="' + letterClass +'"> <a href="browse?mode=' + aMode + '&l=' + c + '">' + c + '</a></li>'#13#10;
        end;

        sub := sub + '</ul>'
    end;

    result := StringReplace(result, '{{BrowseSubmenu}}', sub, [rfReplaceAll]);
end;

// von den Indys abgeguckt
function HRefEncode(const ASrc: String): String;
var i: Integer;
begin
    Result := '';
    for i := 1 to Length(ASrc) do
    begin
        if CharInSet(ASrc[i], ['&', '*','#','%','<','>',' ','[',']'])   //(ASrc[i] in ['&', '*','#','%','<','>',' ','[',']'])
          or (not CharInSet(ASrc[i], [#33..#128]) )                     //or (not (ASrc[i] in [#33..#128]))
        then
            Result := Result + '&#' + IntToStr(Ord(ASrc[i])) + ';'
        else
            Result := Result + ASrc[i];
    end;
end;

function TNempWebServer.ValidIP(aIP, bIP: string): Boolean;
//var lastpoint: integer;
    // CommonPart: string;
begin
  //if Not OnlyLAN then
      result := True
  //else
  //begin
  {
      lastpoint := length(aIP);
      repeat
        dec(lastpoint);
      until (lastpoint < 1) or (aIP[lastpoint] = '.');
      CommonPart := copy(aIP, 1, lastpoint);
      result := AnsiStartsStr(CommonPart, bIP);
  }
  //end;
end;


procedure TNempWebServer.EnsureFileHasID(af: tAudioFile);
begin
    // ID generieren/setzen
    if af.WebServerID = 0 then
    begin
        af.WebServerID := fCurrentMaxID;
        inc(fCurrentMaxID);
    end;
end;


function TNempWebServer.fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
var duration, aClass: String;
    quality, filesize, filetype, path: String;
    notfound: Boolean;
begin
    // IDs/Index MUST be replaced befor calling this method
    // (these are specific for playlist/library-view)
    result := aPattern;
    result := StringReplace(result, '{{Index}}'        , '', [rfReplaceAll]);
    result := StringReplace(result, '{{ID}}'           , '', [rfReplaceAll]);

    // Set Duration
    if af.isStream then
        duration := '(inf)'
    else
        duration := SekIntToMinStr(af.Duration);

    // Set Class
    aClass := baseClass;
    case af.AudioType of
        at_Undef  : aClass := aClass + 'unknown';
        at_File   : aClass := aClass + 'file';
        at_Stream : aClass := aClass + 'stream';
        at_CDDA   : aClass := aClass + 'cdda';
        at_CUE    : aClass := aClass + 'cue';
    end;
    notfound := False;
    if Not FileExists(af.Pfad) then
    begin
        case af.AudioType of
            at_File,
            at_Undef,
            at_CDDA   : begin
                  aClass := aClass + ' FileNotFound';
                  notfound := True;
            end;
        end;
    end;

    // Set Quality
    if af.isStream then
        quality := inttostr(af.Bitrate) + ' kbit/s'
    else
    begin // on CDDA these values are set
        if af.vbr then
            quality := inttostr(af.Bitrate) + ' kbit/s (vbr), '
        else
            quality := inttostr(af.Bitrate) + ' kbit/s, ';
        quality := quality + fWebDisplay.TreeSamplerate(af);
    end;

    // Set filesize
    if af.IsFile then
        filesize := (FloatToStrF((af.Size / 1024 / 1024), ffFixed, 4, 2))
    else
        filesize := '';

    // Set filetype
    case af.AudioType of
        at_Undef  : filetype := 'unknown';
        at_File   : filetype := AnsiLowerCase(ExtractFileExt(af.Pfad));
        at_Stream : filetype := 'Webstream';
        at_CDDA   : filetype := 'CD-Audio';
        at_CUE    : filetype := 'CUE';
    end;

    // Set pfad
    if af.isStream then
        path := af.Pfad
    else
        path := '';

    // Replace Insert-Tags in Pattern
    result := StringReplace(result, '{{Class}}'        , aClass, [rfReplaceAll]);

    result := StringReplace(result, '{{PlaylistTitle}}', EscapeHTMLChars(fWebDisplay.PlaylistTitle(af)), [rfReplaceAll]);
    result := StringReplace(result, '{{Title}}'    , EscapeHTMLChars(fWebDisplay.GetNonEmptyTitle(af)) , [rfReplaceAll]);
    result := StringReplace(result, '{{Artist}}'   , EscapeHTMLChars(af.Artist), [rfReplaceAll]);
    result := StringReplace(result, '{{Album}}'    , EscapeHTMLChars(af.Album) , [rfReplaceAll]);

    result := StringReplace(result, '{{Votes}}'    , EscapeHTMLChars(IntToStr(af.VoteCounter)) , [rfReplaceAll]);
    result := StringReplace(result, '{{PrebookIndex}}', IntToStr(af.PrebookIndex) , [rfReplaceAll]);

    if af.VoteCounter = 0 then
        result := StringReplace(result, '{{VoteClass}}', 'hidden', [rfReplaceAll])
    else
        result := StringReplace(result, '{{VoteClass}}', 'votes' , [rfReplaceAll]);

    if af.PrebookIndex > 0 then
        result := Stringreplace(result, '{{PrebookClass}}', 'prebook', [rfReplaceAll])
    else
        result := Stringreplace(result, '{{PrebookClass}}', 'hidden', [rfReplaceAll]);

    if af.Artist = '' then
        result := StringReplace(result, '{{ArtistClass}}', 'hidden', [rfReplaceAll])
    else
        result := StringReplace(result, '{{ArtistClass}}', 'artist' , [rfReplaceAll]);

    if af.Album = '' then
        result := StringReplace(result, '{{AlbumClass}}', 'hidden', [rfReplaceAll])
    else
        result := StringReplace(result, '{{AlbumClass}}', 'album' , [rfReplaceAll]);


    if af.Track = 0 then
        result := StringReplace(result, '{{TrackClass}}', 'hidden', [rfReplaceAll])
    else
        result := StringReplace(result, '{{TrackClass}}', 'track' , [rfReplaceAll]);

    result := StringReplace(result, '{{Track}}'     , IntToStr(af.Track)        , [rfReplaceAll]);


    result := StringReplace(result, '{{Duration}}'  , duration                  , [rfReplaceAll]);
    result := StringReplace(result, '{{Size}}'      , EscapeHTMLChars(filesize) , [rfReplaceAll]);
    result := StringReplace(result, '{{Filetype}}'  , EscapeHTMLChars(filetype) , [rfReplaceAll]);
    result := StringReplace(result, '{{URL}}'       , EscapeHTMLChars(path)     , [rfReplaceAll]);
    result := StringReplace(result, '{{Quality}}'   , EscapeHTMLChars(quality)  , [rfReplaceAll]);

    if notfound then
        result := StringReplace(result, '{{Warning}}' , WebServer_FileNotFound, [rfReplaceAll])
    else
        result := StringReplace(result, '{{Warning}}' , '', [rfReplaceAll]);


    if (af.CoverID <> '') and (FileExists(TCoverArtSearcher.SavePath + af.CoverID + '.jpg')) then
        result := StringReplace(result, '{{CoverID}}'   , EscapeHTMLChars(af.CoverID), [rfReplaceAll])
    else
        result := StringReplace(result, '{{CoverID}}', '0', [rfReplaceAll]);
end;

function TNempWebServer.fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer; isAdmin: Boolean; IsPlayingFile: Boolean=False): String;
var buttons, btnTmp: String;

    function replaceTag(btnPattern: String; aAction: String): String;
    begin
        result := btnPattern;
        result := StringReplace(result, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);
        result := StringReplace(result, '{{Action}}' , aAction                 , [rfReplaceAll]);
    end;

begin
    buttons := aPattern;

    if (AllowFileDownload or isAdmin) and af.isFile then
    begin
        btnTmp := PatternButtonFileDownload[isAdmin];
        btnTmp := StringReplace(btnTmp, '{{Filename}}'          , HRefEncode(af.Dateiname) , [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{ID}}'                , IntToStr(af.WebServerID) , [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Action}}'            , 'file_download'          , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileDownload}}' , btnTmp                   , [rfReplaceAll]);
    end else
        buttons := StringReplace(buttons, '{{BtnFileDownload}}' , '', [rfReplaceAll]);


    if AllowVotes or isAdmin then
    begin
        btnTmp := replaceTag(PatternButtonFileVote[isAdmin], 'file_vote');
        buttons := StringReplace(buttons, '{{BtnFileVote}}', btnTmp, [rfReplaceAll]);
    end else
        buttons := StringReplace(buttons, '{{BtnFileVote}}'   , '', [rfReplaceAll]);


    if AllowRemoteControl or isAdmin then
    begin
        btnTmp := replaceTag(PatternButtonFileMoveUp[isAdmin], 'file_moveup');
        buttons := StringReplace(buttons, '{{BtnFileMoveUp}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileMoveDown[isAdmin], 'file_movedown');
        buttons := StringReplace(buttons, '{{BtnFileMoveDown}}', btnTmp, [rfReplaceAll]);
        if IsPlayingFile then
            buttons := StringReplace(buttons, '{{BtnFileDelete}}', '', [rfReplaceAll])
        else
        begin
            btnTmp := replaceTag(PatternButtonFileDelete[isAdmin], 'file_delete');
            buttons := StringReplace(buttons, '{{BtnFileDelete}}', btnTmp, [rfReplaceAll]);
        end;
        btnTmp := replaceTag(PatternButtonFilePlayNow[isAdmin], 'file_playnow');
        buttons := StringReplace(buttons, '{{BtnFilePlayNow}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileAdd[isAdmin], 'file_add');
        buttons := StringReplace(buttons, '{{BtnFileAdd}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileAddnext[isAdmin], 'file_addnext');
        buttons := StringReplace(buttons, '{{BtnFileAddNext}}', btnTmp, [rfReplaceAll]);
    end else
    begin
        buttons := StringReplace(buttons, '{{BtnFileMoveUp}}'   , '', [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileMoveDown}}' , '', [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileDelete}}'   , '', [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFilePlayNow}}'  , '', [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileAdd}}'      , '', [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileAddNext}}'  , '', [rfReplaceAll]);
    end;

    result := buttons;
end;

function TNempWebServer.fSetControlButtons(aPattern: String; isPlaying, isAdmin: Boolean): String;
var buttons: String;
begin
    buttons := aPattern;
    buttons := StringReplace(buttons, '{{PlayerControls}}'     , PatternPlayerControls[isAdmin]   , [rfReplaceAll]);

    if AllowRemoteControl or isAdmin then
    begin
        if isPlaying then
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', PatternButtonPause[isAdmin] , [rfReplaceAll])
        else
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', PatternButtonPlay[isAdmin] , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'     , PatternButtonStop[isAdmin]      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'     , PatternButtonNext[isAdmin]      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'     , PatternButtonPrev[isAdmin]      , [rfReplaceAll]);
    end else
    begin
        buttons := StringReplace(buttons, '{{BtnControlPlayPause}}' , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'      , '' , [rfReplaceAll]);
    end;
    result := buttons;
end;

function TNempWebServer.GenerateErrorPage(aErrorMessage: String; aPage: Integer; isAdmin: Boolean): String;
var menu: String;
begin
    menu := MainMenu(aPage, isAdmin);
    result := StringReplace(PatternErrorPage[isAdmin], '{{Menu}}', menu, [rfreplaceAll]);
    result := StringReplace(result, '{{ErrorMessage}}', aErrorMessage, [rfreplaceAll]);
    result := StringReplace(result, '{{BrowseMenu}}'  , '' , [rfReplaceAll]);
end;


procedure TNempWebServer.GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; aPart: Integer; isAdmin: Boolean);
var menu, PageData, PlayerData: String;
    af: TAudioFile;
begin
    menu := MainMenu(0, isAdmin);
    af := aNempPlayer.MainAudioFile;
    if assigned(af) then
    begin
        // ID generieren/setzen
        EnsureFileHasID(af);

        case aPart of
            1: begin
                // 1: Controls  [[PlayerControls]]
                HTML_Player := UTF8String(fSetControlButtons(PatternPlayerControls[isAdmin], aNempPlayer.Status = PLAYER_ISPLAYING, isAdmin));
            end;
            2: begin
                // 2: Playerdata [[ItemPlayer]]
                PlayerData := PatternItemPlayer[isAdmin];
                PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
                PlayerData := fSetBasicFileData(af, PlayerData, '');
                PlayerData := fSetFileButtons(af, PlayerData, 0, isAdmin);
                HTML_Player := UTF8String(PlayerData);
            end;
        else
            begin
                PlayerData := PatternItemPlayer[isAdmin];
                PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
                PlayerData := fSetBasicFileData(af, PlayerData, '');
                PlayerData := fSetFileButtons(af, PlayerData, 0, isAdmin);
                PageData := PatternPlayerPage[isAdmin];
                PageData := fSetControlButtons(PatternPlayerPage[isAdmin], aNempPlayer.Status = PLAYER_ISPLAYING, isAdmin);
                PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
                PageData := StringReplace(PageData, '{{ItemPlayer}}', PlayerData, [rfReplaceAll]);
                HTML_Player := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]))
            end;
        end;

    end else
    begin
        if (aPart=0) then
            PageData := GenerateErrorPage(WebServer_PlayerNotReady, 0, isAdmin)
        else
            PageData := 'fail';

        HTML_Player := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
    end;
end;

// konvertiert die Playlist in ein HTML-Formular
// in VCL-Threads ausführen. Zugriff auf den HTML-String ist durch den Setter Threadsafe.
procedure TNempWebServer.GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist; isAdmin: Boolean);
var Items, PageData: String;
    menu: String;
begin
    menu := MainMenu(1, isAdmin);
    Items := GenerateHTMLfromPlaylistItem(aNempPlaylist, -1, isAdmin);
    if Items = '' then
    begin
        PageData := GenerateErrorPage(WebServer_EmptyPlaylist, 1, isAdmin)
    end else
    begin
        PageData := PatternPlaylistPage[isAdmin];
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{PlaylistItems}}', Items, [rfReplaceAll]);
    end;
    HTML_PlaylistView := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;

function TNempWebServer.GenerateHTMLfromPlaylistItem(
  aNempPlayList: TNempPlaylist; aIdx: Integer; isAdmin: Boolean): String;
var Item, Items, aClass: String;
    af: tAudioFile;
    i: Integer;
begin
    if aIdx = -1 then
    begin
        // get All items
        Items := '';
        for i := 0 to aNempPlayList.Count - 1 do
        begin
            af := aNempPlayList.Playlist[i];
            // ID generieren/setzen
            EnsureFileHasID(af);

            // create new Item
            Item := PatternItemPlaylist[isAdmin];
            Item := StringReplace(Item, '{{Index}}'  , IntToStr(i + 1)         , [rfReplaceAll]);
            Item := StringReplace(Item, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);

            if af = aNempPlaylist.PlayingFile then
                Item := StringReplace(Item, '{{Anchor}}'     , 'name="currentTrack"', [rfReplaceAll])
            else
                Item := StringReplace(Item, '{{Anchor}}'     , '', [rfReplaceAll]);

            // Set "Current" class
            if af = aNempPlaylist.PlayingFile then
                aClass := 'current '
            else
                aClass := '';

            // replace tags
            Item := fSetBasicFileData(af, Item, aClass);
            Item := fSetFileButtons(af, Item, 1, isAdmin, af = aNempPlaylist.PlayingFile);
            Items := Items + Item;
        end;
        result := Items;
        HTML_PlaylistView := UTF8String(Items);
    end else
    begin
        if (aIdx >= 0) and (aIdx < aNempPlaylist.Count) then
        begin
            af := aNempPlayList.Playlist[aIdx];
            Item := PatternItemPlaylist[isAdmin];
            Item := StringReplace(Item, '{{Index}}'  , IntToStr(aIdx + 1)         , [rfReplaceAll]);

            Item := StringReplace(Item, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);

            // Set "Current" class
            if af = aNempPlaylist.PlayingFile then
                aClass := 'current '
            else
                aClass := '';

            // replace tags
            Item := fSetBasicFileData(af, Item, aClass);
            Item := fSetFileButtons(af, Item, 1, isAdmin, af = aNempPlaylist.PlayingFile);
        end else
            Item := 'fail';

        result := Item;
        HTML_PlaylistView := UTF8String(Item);
    end;
end;

procedure TNempWebServer.GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer; isAdmin: Boolean);
var PageData, FileData: String;
    menu: String;
begin
    menu := MainMenu(1, isAdmin);
    if assigned(aAudioFile) then
    begin
        aAudioFile.FileIsPresent := (not aAudioFile.IsFile) or FileExists(aAudioFile.Pfad);

        FileData := PatternItemPlaylistDetails[isAdmin];
        FileData := StringReplace(FileData, '{{Index}}' , IntToStr(aIdx + 1)              , [rfReplaceAll]);

        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1, isAdmin);

        PageData := PatternPlaylistDetailsPage[isAdmin];
        PageData := StringReplace(PageData, '{{Menu}}'               , menu     , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemPlaylistDetails}}', FileData , [rfReplaceAll]);
    end else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 1, isAdmin);

    HTML_PlaylistDetails := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString;
    Start: Integer; isAdmin: Boolean): UTf8String;
var ResultList: TAudioFileList;
    af: TAudioFile;
    i, maxIdx: Integer;
    aClass, PageData, Pagination, menu, browsemenu, Item, Items, warning: String;
    btnPrev, BtnNext, Link: String;
begin
    menu := Mainmenu(2, isAdmin);
    browsemenu := BrowseSubMenu('', '"', '', isAdmin);

    PageData := PatternSearchPage[isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'       , menu         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}' , browsemenu, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', aSearchString, [rfReplaceAll]);

    if aSearchString <> '' then
    begin
        Items := '';
        maxIdx := 0;
        if Start < 0 then
            Start := 0;

        ResultList := TAudioFileList.Create(False);
        try
            SearchLibrary(aSearchString, ResultList);
            if ResultList.Count > 0 then
            begin
                maxIdx := Start + MaxCountPerPage - 1;
                if maxIdx > (ResultList.Count - 1) then
                    maxIdx := ResultList.Count - 1;

                for i := Start to maxIdx do
                begin
                    af := ResultList[i];
                    // ID generieren/setzen
                    EnsureFileHasID(af);
                    Item := PatternItemSearchlist[isAdmin];
                    Item := StringReplace(Item, '{{ID}}'  , IntToStr(af.WebServerID), [rfReplaceAll]);
                    aClass := '';
                    // replace tags
                    Item := fSetBasicFileData(af, Item, aClass);
                    Item := fSetFileButtons(af, Item, 2, isAdmin);
                    Items := Items + Item;
                end;
            end;

            // Build Pagination
            if (Start > 0) then
            begin
                BtnPrev := PatternPaginationPrev[isAdmin];
                Link := 'library?start=' + IntToStr(start-MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
                BtnPrev := StringReplace(BtnPrev, '{{Link}}', Link, [rfReplaceAll]);
            end
            else
                BtnPrev := '';

            if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
            begin
                BtnNext := PatternPaginationNext[isAdmin];
                Link := 'library?start=' + IntToStr(start+MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
                BtnNext := StringReplace(BtnNext, '{{Link}}', Link, [rfReplaceAll]);

            end
            else
                BtnNext := '';

            if (BtnNext = '') and (BtnPrev = '') then
                Pagination := ''
            else
            begin
                Pagination := StringReplace(PatternPagination[isAdmin], '{{NextPage}}', BtnNext, [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{PrevPage}}', BtnPrev, [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{Start}}' , IntToStr(Start+1)           , [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{End}}'   , IntToStr(MaxIdx+1)          , [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{Count}}' , IntToStr(ResultList.Count), [rfReplaceAll]);
            end;

            if ResultList.Count = 0 then
            begin
                warning := PatternNoFilesHint[isAdmin];
                warning := StringReplace(warning, '{{Value}}', aSearchString  , [rfReplaceAll]);
                PageData := StringReplace(PageData, '{{NoFilesHint}}', warning  , [rfReplaceAll]);
            end
            else
                PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);

            PageData := StringReplace(PageData, '{{Pagination}}', Pagination, [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{SearchResultItems}}', Items, [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{SearchCount}}', IntToStr(ResultList.Count), [rfReplaceAll]);
        finally
            ResultList.Free;
        end;
    end else
    begin
        PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{Pagination}}', '', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{SearchResultItems}}', '', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{SearchCount}}', '0', [rfReplaceAll]);
    end;

    result := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLMedienbibBrowseList(aMode: String; aChar: Char; other, isAdmin: Boolean): UTf8String;
var PageData, menu, browsemenu, pagination: String;
    Items, Item, baseLink, Link, ItemPattern: String;
    i, ListIdx: Integer;
    aList, LinkList: TObjectlist;
    ab: TCountedString;
    //maxC: Integer;

    {function GetMaxCount(aList: TObjectList): Integer;
    var i: Integer;
    begin
        result := 1;
        for i := 0 to aList.Count - 1 do
        begin
            if TCountedString(aList[i]).Count > result then
                result := TCountedString(aList[i]).Count;
        end;
        if result < 200 then
            result := 200;
    end;
    }

   { function PoperSize(aMax, c: Integer): Integer;
    begin
        result := round((c*sqrt(c))/aMax * 14) + 10;
        if result > 22 then
            result := 22;
    end; }

begin
    menu := MainMenu(2, isAdmin);
    browsemenu := BrowseSubMenu(aMode, aChar, '', isAdmin);

    if CharInSet(aChar, ['A'..'Z']) then
        ListIdx := ord(aChar) - ord('A') + 1
    else
        ListIdx := 0;

    aList := MainArtists[1]; // fallback
    LinkList := Nil;
    ItemPattern := PatternItemBrowseArtist[isAdmin];
    if aMode = 'artist' then
    begin
        ItemPattern := PatternItemBrowseArtist[isAdmin];
        if other then
        begin
            aList := OtherArtists[ListIdx];
            LinkList := MainArtists[ListIdx];
            if LinkList.Count = 0 then
                LinkList := Nil;
            if aList.Count = 0 then
            begin
                aList := MainArtists[ListIdx]; // Fallback
                other := False;
                LinkList := Nil;
            end;
        end
        else
        begin
            aList := MainArtists[ListIdx];
            LinkList := OtherArtists[ListIdx];
            if LinkList.Count = 0 then
                LinkList := Nil;
            if aList.Count = 0 then
            begin
                aList := OtherArtists[ListIdx]; // Fallback
                other := True;
                LinkList := Nil;
            end;
        end;
    end;
    if aMode = 'album' then
    begin
        ItemPattern := PatternItemBrowseAlbum[isAdmin];
        aList := Albums[ListIdx];
    end;
    if aMode = 'genre' then
    begin
        ItemPattern := PatternItemBrowseGenre[isAdmin];
        aList := Genres;
    end;

    Items := '';
    baseLink := 'browse?mode=' + EscapeHTMLChars(aMode) + '&amp;l=' + EscapeHTMLChars(aChar) + '&amp;value=';

    // maxC := GetMaxCount(aList);

    for i := 0 to aList.Count - 1 do
    begin
        ab := TCountedString(aList[i]);
        Item := ItemPattern;
        Link := baseLink + ParamsEncode(UTF8String(ab.Value));

        Item := StringReplace(Item, '{{Link}}'   , Link, [rfReplaceAll]);
        //Item := StringReplace(Item, '{{Font}}'   , IntToStr(PoperSize(maxC, ab.Count)) + 'px', [rfReplaceAll]);
        Item := StringReplace(Item, '{{Font}}'   , IntToStr(ab.FontSize) + 'px', [rfReplaceAll]);
        Item := StringReplace(Item, '{{Value}}'  , EscapeHTMLChars(ab.Value), [rfReplaceAll]);
        Item := StringReplace(Item, '{{SecondValue}}'  , EscapeHTMLChars(ab.SecondValue), [rfReplaceAll]);

        Item := StringReplace(Item, '{{Count}}'  , IntToStr(ab.Count), [rfReplaceAll]);
        Item := StringReplace(Item, '{{CoverID}}', EscapeHTMLChars(ab.CoverID), [rfReplaceAll]);
        Items := Items + Item;
    end;


    PageData := PatternSearchPage[isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);


    if aMode='artist' then
    begin
        if assigned(LinkList) then
        begin
            if Other then
            begin
                pagination := PatternPaginationMain[isAdmin];
                Link := 'browse?mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;l=' + ParamsEncode(UTF8String(aChar)) + '&amp;other=0';
            end
            else
            begin
                pagination := PatternPaginationOther[isAdmin];
                Link := 'browse?mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;l=' + ParamsEncode(UTF8String(aChar)) + '&amp;other=1';
            end;
            pagination := StringReplace(pagination, '{{Letter}}', aChar, [rfReplaceAll]);
            pagination := StringReplace(pagination, '{{Link}}', Link, [rfReplaceAll]);
        end else
            pagination := '';
        PageData := StringReplace(PageData, '{{Pagination}}', pagination, [rfReplaceAll]);
    end
    else
        PageData := StringReplace(PageData, '{{Pagination}}', '', [rfReplaceAll]);

    PageData := StringReplace(PageData, '{{SearchResultItems}}', Items, [rfReplaceAll]);
    result := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;

function TNempWebServer.GenerateHTMLMedienbibBrowseResult(aMode: String; aValue: String;
    Start: Integer; isAdmin: Boolean): UTf8String;
var PageData, menu, browsemenu: String;
    Items, warning: String;
    btnPrev, BtnNext, Pagination, Link: String;
    i,  maxIdx: Integer;
    af: TAudioFile;
    ResultList: TAudioFileList;

    procedure AddItem(afile: TAudioFile);
    var aClass, Item: String;
    begin
        //if c < 1000 then
        //begin
            EnsureFileHasID(af);
            Item := PatternItemSearchlist[isAdmin];
            Item := StringReplace(Item, '{{ID}}'  , IntToStr(afile.WebServerID), [rfReplaceAll]);
            aClass := '';
            // replace tags
            Item := fSetBasicFileData(afile, Item, aClass);
            Item := fSetFileButtons(afile, Item, 2, isAdmin);
            Items := Items + Item;
        //end;
        //inc(c);
    end;

begin
    menu := MainMenu(2, isAdmin);
    browsemenu := BrowseSubMenu(aMode, ' ', aValue, isAdmin);

    PageData := PatternSearchPage[isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    Items := '';

    EnterCriticalSection(CS_AccessLibrary);

    ResultList := TAudioFileList.Create(False);
    try
        if aMode='artist' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := fWebMedienBib[i];
                if AnsiSameText(af.Artist, aValue) then
                    ResultList.Add(af);
            end;

        if aMode='album' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := fWebMedienBib[i];
                if AnsiSameText(af.Album, aValue) then
                    ResultList.Add(af);
                    //AddItem(af);
            end;

        if aMode='genre' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := fWebMedienBib[i];
                if AnsiSameText(af.genre, aValue) then
                    ResultList.Add(af);
            end;

        if Start < 0 then Start := 0;

        maxIdx := Start + MaxCountPerPage - 1;
        if maxIdx > (ResultList.Count - 1) then
            maxIdx := ResultList.Count - 1;

        for i := Start to maxIdx do
            AddItem(ResultList[i]);

        // Build Pagination
        if (Start > 0) then
        begin
            BtnPrev := PatternPaginationPrev[isAdmin];
            Link := 'browse?start=' + IntToStr(start-MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;value=' + ParamsEncode(UTF8String(aValue));
            BtnPrev := StringReplace(BtnPrev, '{{Link}}', Link, [rfReplaceAll]);
        end
        else
            BtnPrev := '';

        if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
        begin
            BtnNext := PatternPaginationNext[isAdmin];
            Link := 'browse?start=' + IntToStr(start+MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;value=' + ParamsEncode(UTF8String(aValue));
            BtnNext := StringReplace(BtnNext, '{{Link}}', Link, [rfReplaceAll]);
        end
        else
            BtnNext := '';

        if (BtnNext = '') and (BtnPrev = '') then
            Pagination := ''
        else
        begin
            Pagination := StringReplace(PatternPagination[isAdmin], '{{NextPage}}', BtnNext, [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{PrevPage}}', BtnPrev, [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{Start}}' , IntToStr(Start+1)           , [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{End}}'   , IntToStr(MaxIdx+1)          , [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{Count}}' , IntToStr(ResultList.Count), [rfReplaceAll]);
        end;

        if ResultList.Count = 0 then
        begin
            warning := PatternNoFilesHint[isAdmin];
            warning := StringReplace(warning, '{{Value}}', aValue  , [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{NoFilesHint}}', warning  , [rfReplaceAll]);
        end
        else
            PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll])

    //if c <= 1000 then
    //    PageData := StringReplace(PageData, '{{TooManyFilesWarning}}', ''  , [rfReplaceAll])
    //else
    //begin
    //    warning := PatternTooManyFilesWarning;
    //    warning := StringReplace(warning, '{{Count}}', IntToStr(c)  , [rfReplaceAll]);
    //    PageData := StringReplace(PageData, '{{TooManyFilesWarning}}', warning  , [rfReplaceAll]);
    //end;

    finally
        ResultList.Free;
    end;

    LeaveCriticalSection(CS_AccessLibrary);

    PageData := StringReplace(PageData, '{{Pagination}}', Pagination, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchResultItems}}', Items, [rfReplaceAll]);
    result := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));

end;


function TNempWebServer.GenerateHTMLfromMedienbibSearch_Details(aAudioFile: TAudioFile; isAdmin: Boolean): UTf8String;
var PageData, FileData, menu: String;
begin
    menu := MainMenu(2, isAdmin);

    if assigned(aAudioFile) then
    begin
        aAudioFile.FileIsPresent := (not aAudioFile.IsFile) or FileExists(aAudioFile.Pfad);

        FileData := PatternItemSearchDetails[isAdmin];
        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1, isAdmin);

        PageData := PatternSearchDetailsPage[isAdmin];
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemSearchDetails}}', FileData, [rfReplaceAll]);
    end
    else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 2, isAdmin);

    result := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;

procedure TNempWebServer.CopyDisplayHelper;
begin
  // copy the Main NempDisplay, as the Webserver works with Threads. This way, changing settings is possible
  // (but it has no effect on the webserver until it is restarted).
  fWebDisplay.Assign(NempDisplay);
end;

procedure TNempWebServer.CopyLibrary(OriginalLib: TMedienBibliothek);
begin
    EnterCriticalSection(CS_AccessLibrary);
    OriginalLib.CopyLibrary(fWebMedienBib, fCurrentMaxID);

    ClearHelperLists;

    PrepareAlbums;
    PrepareGenres;
    PrepareArtists;

    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.Shutdown;
var i: Integer;
begin
    EnterCriticalSection(CS_AccessLibrary);
    for i := 0 to fWebMedienBib.Count - 1 do
        fWebMedienBib[i].Free;
    fWebMedienBib.Clear;
    LeaveCriticalSection(CS_AccessLibrary);
end;


procedure TNempWebServer.SearchLibrary(Keyword: UnicodeString; DestList: TAudioFileList);
var Keywords: TStringList;
    KeywordsUTF8: TUTF8Stringlist;
    tmpList: TAudioFileList;
    i: Integer;

begin
    if trim(Keyword) = '' then exit;

    EnterCriticalSection(CS_AccessLibrary);

    Keywords := TStringList.Create;
    try
        ExplodeWithQuoteMarks('+', Keyword, Keywords);

        SetLength(KeywordsUTF8, Keywords.Count);
        for i := 0 to Keywords.Count - 1 do
            KeywordsUTF8[i] := UTF8Encode(AnsiLowerCase(Keywords[i]));

        tmpList := TAudioFileList.Create(False);
        try
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                if AudioFileMatchesKeywords(fWebMedienBib[i], Keywords) then
                    DestList.Add(fWebMedienBib[i])
                else
                    if AudioFileMatchesKeywordsApprox(fWebMedienBib[i], KeywordsUTF8) then
                        tmpList.Add(fWebMedienBib[i]);
            end;
            for i := 0 to tmpList.Count - 1 do
                DestList.Add(tmpList[i]);
        finally
            tmpList.Free;
        end;
    finally
      Keywords.Free;
    end;
    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.LoadTemplates(isAdmin: Boolean);
var sl: TStringList;

    function GetTemplate(aFilename: String): String;
    begin
        if FileExists(aFilename) then
        begin
            sl.LoadFromFile(aFilename);
            result := sl.Text;
        end else
            result := '';
    end;

begin
    if isAdmin then
        fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\' + Theme + '\Admin\'
    else
        fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\' + Theme + '\';
    sl := TStringList.Create;
    try
        PatternBody[isAdmin] := GetTemplate(fLocalDir + 'Body.tpl');
        PatternMenu[isAdmin] := GetTemplate(fLocalDir + 'Menu.tpl');
        PatternBrowseMenu[isAdmin] := GetTemplate(fLocalDir + 'MenuLibraryBrowse.tpl');

        PatternPagination[isAdmin]      := GetTemplate(fLocalDir + 'Pagination.tpl');
        PatternPaginationNext[isAdmin]  := GetTemplate(fLocalDir + 'PaginationNextPage.tpl');
        PatternPaginationPrev[isAdmin]  := GetTemplate(fLocalDir + 'PaginationPrevPage.tpl');
        PatternPaginationOther[isAdmin] := GetTemplate(fLocalDir + 'PaginationOther.tpl');
        PatternPaginationMain[isAdmin]  := GetTemplate(fLocalDir + 'PaginationMain.tpl');


        // Buttons for Player Control
        // PatternButtonPlayPause := trim(GetTemplate(fLocalDir + 'BtnControlPlayPause.tpl'));
        PatternPlayerControls[isAdmin] := trim(GetTemplate(fLocalDir + 'PlayerControls.tpl'));
        PatternButtonPause[isAdmin] := trim(GetTemplate(fLocalDir + 'BtnControlPause.tpl'));
        PatternButtonPlay[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnControlPlay.tpl'));
        PatternButtonNext[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnControlNext.tpl'));
        PatternButtonPrev[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnControlPrev.tpl'));
        PatternButtonStop[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnControlStop.tpl'));

        // Buttons for File-Handling
        PatternButtonFileDownload[isAdmin] := trim(GetTemplate(fLocalDir + 'BtnFileDownload.tpl'));
        PatternButtonFilePlayNow[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnFilePlayNow.tpl'));
        PatternButtonFileAdd[isAdmin]      := trim(GetTemplate(fLocalDir + 'BtnFileAdd.tpl'));
        PatternButtonFileAddNext[isAdmin]  := trim(GetTemplate(fLocalDir + 'BtnFileAddNext.tpl'));
        PatternButtonFileMoveUp[isAdmin]   := trim(GetTemplate(fLocalDir + 'BtnFileMoveUp.tpl'));
        PatternButtonFileMoveDown[isAdmin] := trim(GetTemplate(fLocalDir + 'BtnFileMoveDown.tpl'));
        PatternButtonFileDelete[isAdmin]   := trim(GetTemplate(fLocalDir + 'BtnFileDelete.tpl'));
        PatternButtonFileVote[isAdmin]     := trim(GetTemplate(fLocalDir + 'BtnFileVote.tpl'));

        // The PLAYER page
        PatternItemPlayer[isAdmin] := trim(GetTemplate(fLocalDir + 'ItemPlayer.tpl'));
        PatternPlayerPage[isAdmin] := GetTemplate(fLocalDir + 'PagePlayer.tpl');

        // The PLAYLIST page
        PatternPlaylistPage[isAdmin] := GetTemplate(fLocalDir + 'PagePlaylist.tpl');
        PatternItemPlaylist[isAdmin] := GetTemplate(fLocalDir + 'ItemPlaylist.tpl');

        // The PLAYLIST DETAILS page
        PatternPlaylistDetailsPage[isAdmin] := GetTemplate(fLocalDir + 'PagePlaylistDetails.tpl');
        PatternItemPlaylistDetails[isAdmin] := GetTemplate(fLocalDir + 'ItemPlaylistDetails.tpl');

        // The LIBRARY page
        PatternSearchPage[isAdmin]       := GetTemplate(fLocalDir + 'PageLibrary.tpl');
        //PatternSearchResultPage[isAdmin] := GetTemplate(fLocalDir + 'PageLibrarySearchResults.tpl');
        PatternItemSearchlist[isAdmin]   := GetTemplate(fLocalDir + 'ItemSearchResult.tpl');

        PatternItemBrowseArtist[isAdmin] := GetTemplate(fLocalDir + 'ItemBrowseArtist.tpl');
        PatternItemBrowseAlbum[isAdmin]  := GetTemplate(fLocalDir + 'ItemBrowseAlbum.tpl');
        PatternItemBrowseGenre[isAdmin]  := GetTemplate(fLocalDir + 'ItemBrowseGenre.tpl');

        // The LIBRARY DETAILS page
        PatternSearchDetailsPage[isAdmin] := GetTemplate(fLocalDir + 'PageLibraryDetails.tpl');
        PatternItemSearchDetails[isAdmin] := GetTemplate(fLocalDir + 'ItemSearchDetails.tpl');

        // The ERROR page
        PatternErrorPage[isAdmin]   := GetTemplate(fLocalDir + 'PageError.tpl');
        PatternNoFilesHint[isAdmin] := GetTemplate(fLocalDir + 'WarningNoFiles.tpl');

    finally
        sl.Free;
    end;
end;

procedure TNempWebServer.TemplateFallback;

    procedure ProcessTemplate(var aDoubleString: TDoubleString);
    begin
        if aDoubleString[True] = '' then
            aDoubleString[True] := aDoubleString[False]
    end;

begin
        ProcessTemplate(PatternBody);
        ProcessTemplate(PatternMenu           );
        ProcessTemplate(PatternBrowseMenu     );
        ProcessTemplate(PatternPagination     );
        ProcessTemplate(PatternPaginationNext );
        ProcessTemplate(PatternPaginationPrev );
        ProcessTemplate(PatternPaginationOther);
        ProcessTemplate(PatternPaginationMain );
        ProcessTemplate(PatternPlayerControls );
        ProcessTemplate(PatternButtonPause    );
        ProcessTemplate(PatternButtonPlay     );
        ProcessTemplate(PatternButtonNext     );
        ProcessTemplate(PatternButtonPrev     );
        ProcessTemplate(PatternButtonStop     );
        // Buttons for File-Handling
        ProcessTemplate(PatternButtonFileDownload  );
        ProcessTemplate(PatternButtonFilePlayNow   );
        ProcessTemplate(PatternButtonFileAdd       );
        ProcessTemplate(PatternButtonFileAddNext   );
        ProcessTemplate(PatternButtonFileMoveUp    );
        ProcessTemplate(PatternButtonFileMoveDown  );
        ProcessTemplate(PatternButtonFileDelete    );
        ProcessTemplate(PatternButtonFileVote      );
        // The PLAYER page
        ProcessTemplate(PatternItemPlayer          );
        ProcessTemplate(PatternPlayerPage          );
        // The PLAYLIST page
        ProcessTemplate(PatternPlaylistPage        );
        ProcessTemplate(PatternItemPlaylist        );
        // The PLAYLIST DETAILS page
        ProcessTemplate(PatternPlaylistDetailsPage );
        ProcessTemplate(PatternItemPlaylistDetails );
        // The LIBRARY page
        ProcessTemplate(PatternSearchPage          );
        //ProcessTemplate(PatternSearchResultPage    );
        ProcessTemplate(PatternItemSearchlist      );
        ProcessTemplate(PatternItemBrowseArtist    );
        ProcessTemplate(PatternItemBrowseAlbum     );
        ProcessTemplate(PatternItemBrowseGenre     );
        // The LIBRARY DETAILS page
        ProcessTemplate(PatternSearchDetailsPage   );
        ProcessTemplate(PatternItemSearchDetails   );
        // The ERROR page
        ProcessTemplate(PatternErrorPage           );
        ProcessTemplate(PatternNoFilesHint         );
end;

procedure TNempWebServer.ClearHelperLists;
var i: Integer;
begin
    for i := 0 to 26 do
    begin
        MainArtists[i].Clear;
        OtherArtists[i].Clear;
        Albums[i].Clear;
    end;
    Genres.Clear;
end;

function CorrectIndex(s: String): Integer;
var tmp: String;
begin
    if s = '' then
        result := 0
    else
    begin
        s := AnsiUppercase(s);
        tmp := s[1];
        case tmp[1] of
            'Ä': tmp := 'A';
            'Ö': tmp := 'O';
            'Ü': tmp := 'U';
        end;

        if CharInSet(tmp[1], ['A'..'Z']) then
            result := ord(tmp[1]) - ord('A') + 1
        else
            result := 0;
    end;
end;

function SortCountedString(item1, item2: Pointer): Integer;
begin
    result := AnsiCompareText(TCountedString(item1).fValue, TCountedString(item2).fValue);
end;

procedure TNempWebServer.MergeArtistsIfNecessary;
var i, c: Integer;    
begin
    for i := 0 to 26 - 1 do
    begin
        if MainArtists[i].Count + OtherArtists[i].Count < MergeArtistConst then
        begin
            OtherArtists[i].OwnsObjects := False;
            for c := 0 to OtherArtists[i].Count - 1 do
                MainArtists[i].Add(OtherArtists[i][c]);
            OtherArtists[i].Clear;
            MainArtists[i].Sort(SortCountedString);          
        end;        
    end;    
end;

procedure TNempWebServer.PrepareArtists;
var currentArtist, currentCoverID: String;
    c, i, idx: Integer;
    newEntry: TCountedString;

begin
    fWebMedienBib.Sort(Sort_ArtistAlbumTrackTitel_asc);

    if fWebMedienBib.Count > 0 then
    begin
        currentArtist := fWebMedienBib[0].Artist;
        currentCoverID := fWebMedienBib[0].CoverID;
        c := 1;

        for i := 1 to fWebMedienBib.Count - 1 do
        begin
            if not AnsiSameText(fWebMedienBib[i].Artist, currentArtist) then
            begin
                if trim(currentArtist) <> '' then
                begin
                    // insert currentArtist into one of the Artists-Lists
                    idx := CorrectIndex(currentArtist);
                    newEntry := TCountedString.Create(currentArtist, c, currentCoverID);
                    if c >= GoodArtist then
                        MainArtists[idx].Add(newEntry)
                    else
                        OtherArtists[idx].Add(newEntry);
                end; // otherwise: Do not add this artist at all
                // start counting again
                currentArtist := fWebMedienBib[i].Artist;
                currentCoverID := fWebMedienBib[i].CoverID;
                c := 1;
            end else
            begin
                // just count this file to the current-Artist-Count
                inc(c);
                if currentCoverID = '' then
                    currentCoverID := fWebMedienBib[i].CoverID;
            end;
        end;

        // add last item
        if trim(currentArtist) <> '' then
        begin
            // insert currentArtist into one of the Artists-Lists
            idx := CorrectIndex(currentArtist);
            newEntry := TCountedString.Create(currentArtist, c, currentCoverID);
            if c >= GoodArtist then
                MainArtists[idx].Add(newEntry)
            else
                OtherArtists[idx].Add(newEntry);
        end; // otherwise: Do not add this artist at all

        // check List counts, and merge eventually
        MergeArtistsIfNecessary;

        // set Font Sizes
        for i := 0 to 26 do
        begin
            SetFontSizes(MainArtists[i]);
            SetFontSizes(OtherArtists[i]);
        end;
    end;
end;

procedure TNempWebServer.PrepareAlbums;
var currentAlbum, currentCoverID: String;
    c, i, idx: Integer;
    newEntry: TCountedString;
    tmpArtistStrings: TStringList;

begin
    fWebMedienBib.Sort(Sort_AlbumTrack_asc);
    if fWebMedienBib.Count > 0 then
    begin
        tmpArtistStrings := TStringList.Create;
        try
            currentAlbum := fWebMedienBib[0].Album;
            currentCoverID := fWebMedienBib[0].CoverID;
            c := 1;
            tmpArtistStrings.Add(fWebMedienBib[0].Artist);
            for i := 1 to fWebMedienBib.Count - 1 do
            begin

                if not AnsiSameText(fWebMedienBib[i].Album, currentAlbum) then
                begin
                    if (trim(currentAlbum) <> '') and (c >= GoodAlbum) then
                    begin
                        // insert currentAlbum into one of the Album-Lists
                        idx := CorrectIndex(currentAlbum);

                        newEntry := TCountedString.Create(currentAlbum, c, currentCoverID);
                        // get a proper Artist for the album
                        newEntry.getSecondValue(tmpArtistStrings);
                        // clear current artist list
                        tmpArtistStrings.Clear;

                        Albums[idx].Add(newEntry);
                    end; // otherwise do not add this album
                    // start counting again
                    currentAlbum := fWebMedienBib[i].Album;
                    currentCoverID := fWebMedienBib[i].CoverID;
                    c := 1;
                end else
                begin
                    // just count this file to the current-Artist-Count
                    inc(c);
                    if currentCoverID = '' then
                        currentCoverID := fWebMedienBib[i].CoverID;
                    tmpArtistStrings.Add(fWebMedienBib[i].Artist);
                end;
            end;

            // insert last item
            if (trim(currentAlbum) <> '') and (c >= GoodAlbum) then
            begin
                // insert currentAlbum into one of the Album-Lists
                idx := CorrectIndex(currentAlbum);
                newEntry := TCountedString.Create(currentAlbum, c, currentCoverID);
                // get a proper Artist for the album
                newEntry.getSecondValue(tmpArtistStrings);
                Albums[idx].Add(newEntry);
            end;

            // set Font Sizes
            for i := 0 to 26 do
                SetFontSizes(Albums[i]);
        finally
            tmpArtistStrings.Free;
        end;
    end;
end;

procedure TNempWebServer.PrepareGenres;
var currentGenre, currentCoverID: String;
    c, i: Integer;
    newEntry: TCountedString;
begin
    fWebMedienBib.Sort(Sort_Genre_asc);
    if fWebMedienBib.Count > 0 then
    begin
        currentGenre := fWebMedienBib[0].Genre;
        currentCoverID := fWebMedienBib[0].CoverID;
        c := 1;

        for i := 1 to fWebMedienBib.Count - 1 do
        begin
            if not AnsiSameText(fWebMedienBib[i].Genre, currentGenre) then
            begin
                if (trim(currentGenre) <> '')
                  // and (currentGenre <> 'Other')
                  and ( not ( (length(currentGenre) <= 5) and CharinSet(trim(currentGenre)[1], ['0'..'9', '('] ) ))
                then
                begin
                    // insert currentGenre into the Genres-List
                    newEntry := TCountedString.Create(currentGenre, c, currentCoverID);
                    Genres.Add(newEntry);
                end;
                // start counting again
                currentGenre := fWebMedienBib[i].Genre;
                currentCoverID := fWebMedienBib[i].CoverID;
                c := 1;
            end else
            begin
                // just count this file to the current-Artist-Count
                inc(c);
                if currentCoverID = '' then
                    currentCoverID := fWebMedienBib[i].CoverID;
            end;
        end;
        newEntry := TCountedString.Create(currentGenre, c, '1');
        Genres.Add(newEntry);

        SetFontSizes(Genres);
    end;
end;

procedure TNempWebServer.SetFontSizes(aList: TObjectList);
var i, cMin, cMax: integer;
    aItem: TCountedString;
    //TreshHolds: Array[1..8] of Double;
    //Delta: Double;
    //Flag: Boolean;

const FontSizes : Array[1..8] of Integer = (10,12,14,16,18,20,22,24);

begin
    // 1. finding min/max
    if aList.Count > 0 then
    begin
        aItem := TCountedString(aList[0]);
        cMin := aItem.Count;
        cMax := aItem.Count;
    end else
        exit;

    for i := 1 to aList.Count - 1 do
    begin
        aItem := TCountedString(aList[i]);
        if aItem.Count > cMax then
            cMax := aItem.Count;
        if aItem.Count < cMin then
            cMin := aItem.Count;
    end;

    // really small values ("other Artists")
    if cMax < 20 then
        cMax := 20
    else
        // small values (normal artists)
        if cMax < 250 then
            cMax := 250;

    // 2. setting Treshholds
    // Delta := (cMax - cMin) / 8;
    // for i := 1 to 8 do
    //    TreshHolds[i] := 100* ln(cMin + i*Delta) + 2;

    // 3. setting Fonts
    for i := 0 to aList.Count - 1 do
    begin
        aItem := TCountedString(aList[i]);
        aItem.fFontSize := round((aItem.Count * sqrt(aItem.Count)) / cMax * 14) + 10;  // see note below
        if aItem.fFontSize > 24 then
            aItem.fFontSize := 24;

        ///  note:
        ///  the commented code is from http://www.echochamberproject.com/node/247,
        ///  which is cited by http://en.wikipedia.org/wiki/Tag_cloud
        ///  However, this logarithmic scale does not work well on my collection
        ///  especially on "genre" ("Pop" is used VERY often and destroys even the
        ///  "good look" of a logarithmic scale)
        ///  the -erm- "semi-quadratic" (x^(1.5)) scheme yields to good results
        ///  (on my collection, imho)

        {Flag := False;
        for f := 1 to 8 do
        begin
            if (not Flag) and (100* ln(2*aItem.Count + 2) <= TreshHolds[f]) then
            begin
                aItem.fFontSize := FontSizes[f];
                Flag := True;
            end;
            if (not Flag) then
                aItem.fFontSize := FontSizes[8];
        end;
        }
    end;
end;




procedure TNempWebServer.SetActive(Value: Boolean);
var
    success: Boolean;
begin
    if Value = fActive  then
        exit;

    if Value then
    begin
        // Server aktivieren
        success := True;
        try
            IdHTTPServer1.Active := False;
            IdHTTPServer1.Bindings.Clear;
            IdHTTPServer1.DefaultPort := Port;

            LoadTemplates(True);    // DO NOT SWAP THESE LINES !!
            LoadTemplates(False);

            TemplateFallback;


            IdHTTPServer1.Active := True;
        except
            on E: Exception do
            begin
                success := False;
                fLastErrorString := E.Message;
            end;
        end;

        if Success then
        begin
            fActive := True;
            fLastErrorString := '';
            SendMessage(fMainHandle, WM_WebServer, WS_StringLog,
                  Integer(PChar(DateTimeToStr(Now, fLocalFormatSettings)
                             + ', Server acticated at Port ' + IntToStr(IdHTTPServer1.DefaultPort) + ', Files in library: '
                             + IntToStr(Count))));
        end
        else
        begin
            fActive := False;
            SendMessage(fMainHandle, WM_WebServer, WS_StringLog,
                Integer(PChar(DateTimeToStr(Now, fLocalFormatSettings) + ',Server activation failed.')));
            SendMessage(fMainHandle, WM_WebServer, WS_StringLog,
                Integer(PChar('Reason: ' + fLastErrorString)));
            Shutdown;
        end;
    end else
    begin
        // Server deaktivieren
        IdHTTPServer1.Active := False;
        fActive := False;
        Shutdown;
        SendMessage(fMainHandle, WM_WebServer, WS_StringLog,
                Integer(PChar(DateTimeToStr(Now, fLocalFormatSettings) + ', Server shutdown.')));
    end;
end;

function TNempWebServer.GetAudioFileFromWebServerID(aID: Integer): TAudioFile;
var i: Integer;
begin
    EnterCriticalSection(CS_AccessLibrary);
    result := Nil;
    for i := 0 to fWebMedienBib.Count - 1 do
    begin
        if fWebMedienBib[i].WebServerID = aID then
        begin
            result := fWebMedienBib[i];
            break;
        end;
    end;
    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.GetThemes(dest: TStrings);
var SR: TSearchRec;
begin
    if (FindFirst(ExtractFilePath(Paramstr(0)) + 'HTML\' + '*', faDirectory, SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
              dest.Add(Sr.Name);
        until FindNext(SR)<>0;
    FindClose(SR);
end;

function TNempWebServer.fGetCount: Integer;
begin
    EnterCriticalSection(CS_AccessLibrary);
    if  Assigned(fWebMedienBib) then
        result := fWebMedienBib.Count
    else
        result := 0;
    LeaveCriticalSection(CS_AccessLibrary);
end;


procedure TNempWebServer.logQuery(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; Permit: TQueryResult);
var logstr: String;
begin
    logstr := DateTimeToStr(Now, fLocalFormatSettings) + ', ' + AContext.Binding.PeerIP + ', ' +
         (aRequestInfo.Document) + ', ' + trim((aRequestInfo.Params.CommaText));
    case permit of
        qrError: logstr := logstr + ' (Error)';
        qrPermit: ;
        qrDeny: logstr := logstr + ' (Denied)';
        qrRemoteControlDenied: logstr := logstr + ' (Remote Control denied)';
        qrDownloadDenied: logstr := logstr + ' (Download denied)';
        qrLibraryAccessDenied: logstr := logstr + ' (Library access denied)';
        qrFileNotFound: logstr := logstr + ' (File not found)';
        qrInvalidParameter: logstr := logstr + ' (Invalid Parameter)';
    end;

    SendMessage(fMainHandle, WM_WebServer, WS_StringLog, Integer(PChar(logstr)));
end;

procedure TNempWebServer.logQueryAuth(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo);
var logstr: String;
begin
    logstr := DateTimeToStr(Now, fLocalFormatSettings) + ', ' + AContext.Binding.PeerIP + ', query login: ' +
         (aRequestInfo.AuthUsername) + '//' + (aRequestInfo.AuthPassword);
    SendMessage(fMainHandle, WM_WebServer, WS_StringLog, Integer(PChar(logstr)));
end;


function TNempWebServer.HandleError(AResponseInfo: TIdHTTPResponseInfo;
      Error: TQueryResult; isAdmin: Boolean): TQueryResult;
var ErrorMessage, PageData: String;
    Body: UTF8String;
    ms: TMemoryStream;
begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    case Error of
        qrError              : ErrorMessage := WebServer_SomeError;
        qrRemoteControlDenied: ErrorMessage := WebServer_RemoteControlDenied;
        qrDownloadDenied     : ErrorMessage := WebServer_DownloadDenied;
        qrLibraryAccessDenied: ErrorMessage := WebServer_LibraryAccessDenied;
        qrDeny               : ErrorMessage := WebServer_AccessDenied;
        qrFileNotFound       : ErrorMessage := WebServer_FileNotFound;
        qrInvalidParameter   : ErrorMessage := WebServer_InvalidParameter;
    else
        ErrorMessage := WebServer_UnknownError;
    end;

    PageData := GenerateErrorPage(ErrorMessage, -1, isAdmin);
    Body := UTF8String(StringReplace(PatternBody[isAdmin], '{{Content}}', PageData, [rfReplaceAll]));

    AResponseInfo.ContentType := 'text/html';
    ms := TMemoryStream.Create;
    ms.Write(Body[1], length(Body));
    AResponseInfo.ContentStream := ms;
    result := Error;
end;

procedure TNempWebServer.AddNoCacheHeader(AResponseInfo: TIdHTTPResponseInfo);
begin
    AResponseInfo.CustomHeaders.Add('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
    AResponseInfo.CustomHeaders.Add('Cache-Control: no-store, no-cache, must-revalidate');
    AResponseInfo.CustomHeaders.Add('Cache-Control: post-check=0, pre-check=0');  // ,false ???
    AResponseInfo.CustomHeaders.Add('Pragma: no-cache');
end;

function TNempWebServer.ResponsePlayer(ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
begin
        AResponseInfo.ContentType := 'text/html; charset=utf-8';
        ms := TMemoryStream.Create;
            EnterCriticalSection(CS_AccessHTMLCode);
            if isAdmin then
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerAdmin, 0)
            else
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayer, 0); //QueryPlayer;
            html := HTML_Player;
            LeaveCriticalSection(CS_AccessHTMLCode);
        if html = '' then html := ' ';
        ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
end;
function TNempWebServer.ResponsePlayerJS(ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    queriedAction, queriedPart: String;
    aProgress, aVolume: Integer;
    aMessage: Integer;
begin
        AResponseInfo.ContentType := 'text/html; charset=utf-8';
        queriedAction := aRequestInfo.Params.Values['action'];
        if queriedAction = 'getprogress' then
        begin
            aProgress := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETPROGRESS, 0);
            ms := TMemoryStream.Create;
            html := UTF8String(IntToStr(aProgress));
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end else
        if queriedAction = 'getvolume' then
        begin
            aVolume := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETVOLUME, 0);
            ms := TMemoryStream.Create;
            html := UTF8String(IntToStr(aVolume));
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end
        else
        begin
            queriedPart := aRequestInfo.Params.Values['part'];

            ms := TMemoryStream.Create;
                EnterCriticalSection(CS_AccessHTMLCode);
                if isAdmin then
                    aMessage := WS_QueryPlayerJSAdmin
                else
                    aMessage := WS_QueryPlayerJS;

                if queriedPart= 'controls' then
                    SendMessage(fMainHandle, WM_WebServer, aMessage, 1)
                else
                    SendMessage(fMainHandle, WM_WebServer, aMessage, 2); //QueryPlayer;
                html := HTML_Player;
                LeaveCriticalSection(CS_AccessHTMLCode);
            if html = '' then html := ' ';
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end;

        result := qrPermit;
end;

function TNempWebServer.ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedAction: String;
begin
  AResponseInfo.ContentType := 'text/html; charset=utf-8';
  if AllowRemoteControl or isAdmin then
  begin
      result := qrPermit;
      queriedAction := aRequestInfo.Params.Values['action'];

      if queriedAction = 'stop' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_STOP, 0)
      else
      if queriedAction = 'playpause' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PLAY, 0)
      else
      if queriedAction = 'next' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_NEXTTITLE, 0)
      else
      if queriedAction = 'previous' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PREVTITLE, 0)
      else
          result := qrInvalidParameter;

      if isAdmin then
          AResponseInfo.Redirect('/admin/player')
      else
          AResponseInfo.Redirect('/player');

      AResponseInfo.ContentStream := Nil;
  end else
  begin
      result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
  end;
end;

function TNempWebServer.ResponseJSPlayerControl(ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedAction, queriedValue: String;
    aProgress, aVolume: Integer;
begin
  AResponseInfo.ContentType := 'text/html; charset=utf-8';
  if AllowRemoteControl or isAdmin then
  begin
      queriedAction := aRequestInfo.Params.Values['action'];
      if queriedAction = 'stop' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_STOP, 0)
      else
      if queriedAction = 'playpause' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PLAY, 0)
      else
      if queriedAction = 'next' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_NEXTTITLE, 0)
      else
      if queriedAction = 'previous' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PREVTITLE, 0)
      else
      //if queriedAction = 'getprogress' then
          // nothing. all is done in responseplayerJS
      //if queriedAction = 'getvolume' then
          // nothing. all is done in responseplayerJS
      //else
      if queriedAction = 'setprogress' then
      begin
          queriedValue := aRequestInfo.Params.Values['value'];
          aProgress := StrToIntDef(queriedValue, -1);
          if aProgress <> -1 then
              SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_SETPROGRESS, aProgress);
      end
      else
      if queriedAction = 'setvolume' then
      begin
          queriedValue := aRequestInfo.Params.Values['value'];
          aVolume := StrToIntDef(queriedValue, -1);
          if aVolume <> -1 then
          begin
              if aVolume = 1000 then
                  SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_INCVOLUME, 0)
              else
                  if aVolume = -1000 then
                      SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_DECVOLUME, 0)
                  else
                      SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_SETVolume, aVolume);
          end;
      end;

      result := ResponsePlayerJS(ARequestInfo, AResponseInfo, isAdmin);
  end else
  begin
      result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
  end;
end;

function TNempWebServer.ResponseClassicPlaylistControl(AContext: TIdContext;
ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedAction: String;
    queriedID, newID: Integer;
    af: TAudioFile;
    localVote, localControl: Boolean;

    procedure DoRedirect;
    begin
        if isAdmin then
            AResponseInfo.Redirect('/admin/playlist')
        else
            AResponseInfo.Redirect('/playlist');
        AResponseInfo.ContentStream := Nil;
    end;
begin
    localVote := AllowVotes or isAdmin;
    localControl := AllowRemoteControl or isAdmin;

    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowRemoteControl or isAdmin or AllowVotes then
    begin
        result := qrPermit;
        queriedAction := aRequestInfo.Params.Values['action'];
        if (queriedAction = 'file_playnow') then
        begin
            if localControl then
            begin
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID) > 0 then
                begin
                    // todo: Hier ggf. ein result erwarten und auswerten?
                    DoRedirect;
                    result := qrPermit;
                end else
                begin
                    // file is not in the playlist yet. add it and sart play.
                    af := GetAudioFileFromWebServerID(queriedID);
                    if assigned(af) then
                    begin
                        // send Audiofile to Nemp main window/playlist
                        newID := SendMessage(fMainWindowHandle, WM_WebServer, WS_InsertNext, LParam(af));
                        // try to play this file
                        if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, newID) > 0 then
                        begin
                            DoRedirect;
                            result := qrPermit;
                        end else
                            result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
                    end else
                        result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
                end
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;

        if (queriedAction = 'file_vote') then
        begin
            if localVote then
            begin
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                case Votemachine.ProcessVote(queriedID, AContext.Binding.PeerIP) of
                    vr_Success            : begin result := qrPermit; DoRedirect; end;
                    vr_TotalVotesExceeded : begin result := qrDeny;   DoRedirect; end;
                    vr_FileVotesExceeded  : begin result := qrDeny;   DoRedirect; end;
                    vr_Exception          : result := HandleError(AResponseInfo, qrError, isAdmin);
                end;
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;

        if (queriedAction = 'file_add') then
        begin
            if localControl then
            begin
                EnterCriticalSection(CS_AccessLibrary);
                result := qrPermit;
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                af := GetAudioFileFromWebServerID(queriedID);
                if assigned(af) then
                begin
                    // sende Audiofile an Nemp-Hauptfenster/playlist
                    SendMessage(fMainWindowHandle, WM_WebServer, WS_AddToPlaylist, LParam(af));
                    DoRedirect;
                end else // not in bib
                begin
                    result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
                end;
                LeaveCriticalSection(CS_AccessLibrary);
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;
        if (queriedAction = 'file_addnext') then
        begin
            if localControl then
            begin
                EnterCriticalSection(CS_AccessLibrary);
                result := qrPermit;
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                af := GetAudioFileFromWebServerID(queriedID);
                if assigned(af) then
                begin
                    // sende Audiofile an Nemp-Hauptfenster/playlist
                    SendMessage(fMainWindowHandle, WM_WebServer, WS_InsertNext, LParam(af));
                    DoRedirect;
                end else
                begin
                    result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
                end;
                LeaveCriticalSection(CS_AccessLibrary);
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;
        if (queriedAction = 'file_moveup') then
        begin
            if localControl then
            begin
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveUp, queriedID) >= 1 then
                begin
                    // todo: Hier ggf. ein result erwarten und auswerten?
                    DoRedirect;
                    result := qrPermit;
                end else
                    result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;
        if (queriedAction = 'file_movedown') then
        begin
            if localControl then
            begin
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveDown, queriedID) >= 1 then
                begin
                    // todo: Hier ggf. ein result erwarten und auswerten?
                    DoRedirect;
                    result := qrPermit;
                end else
                    result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;
        if (queriedAction = 'file_delete') then
        begin
            if localControl then
            begin
                queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
                if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID) > 0 then
                begin
                    // todo: Hier ggf. ein result erwarten und auswerten?
                    DoRedirect;
                    result := qrPermit;
                end else
                    result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
            end
            else
                result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
        end;
    end else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
    end;
end;

function TNempWebServer.ResponseJSPlaylistControl(AContext: TIdContext;
    ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedAction: String;
    queriedID: Integer;
    res, newID: Integer;
    html: UTF8String;
    af: TAudioFile;
    localVote, localControl, requestDone: Boolean;

    function BuildStream(aContent: UTF8String): TMemoryStream;
    begin
        if aContent = '' then aContent := ' ';
        
        result := tMemoryStream.Create;
        result.Write(aContent[1], length(aContent))
    end;

    function Addnext(aAction: String; doPlay: Boolean=False): TQueryResult;
    begin
        EnterCriticalSection(CS_AccessLibrary);
        result := qrPermit;
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        af := GetAudioFileFromWebServerID(queriedID);
        if assigned(af) then
        begin
            // sende Audiofile an Nemp-Hauptfenster/playlist
            if (aAction = 'file_addnext') then
                newID := SendMessage(fMainWindowHandle, WM_WebServer, WS_InsertNext, LParam(af))
            else
                newID := SendMessage(fMainWindowHandle, WM_WebServer, WS_AddToPlaylist, LParam(af));

            if DoPlay then
                SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, newID);

            if NOT DoPlay then
                AResponseInfo.ContentStream := BuildStream(UTF8String('ok'));
        end
        else
        begin
            AResponseInfo.ContentStream := BuildStream(UTF8String('invalid parameter'));
            result := qrInvalidParameter;
        end;
        LeaveCriticalSection(CS_AccessLibrary);
    end;

    function PlayNow(aID: Integer): tQueryResult;
    begin
        res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID);
        if res > 0 then
        begin
            AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(res)));
            result := qrPermit;
        end else
        begin
            // result := HandleError(AResponseInfo, qrInvalidParameter)
            Addnext('file_addnext', True);
            AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(newID)));
            result := qrPermit;
        end;
    end;


begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowRemoteControl or isAdmin or AllowVotes then
    begin
        localVote := AllowVotes or isAdmin;
        localControl := AllowRemoteControl or isAdmin;
        requestDone := False;

        result := qrPermit;
        queriedAction := aRequestInfo.Params.Values['action'];

        if (queriedAction = 'file_playnow') and localControl then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            result := PlayNow(queriedID);
        end;

        if (queriedAction = 'file_vote') and localVote then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            case Votemachine.ProcessVote(queriedID, AContext.Binding.PeerIP) of
                vr_Success   : AResponseInfo.ContentStream := BuildStream(UTF8String('ok'));
                vr_TotalVotesExceeded : AResponseInfo.ContentStream := BuildStream(UTF8String('spam'));
                vr_FileVotesExceeded  : AResponseInfo.ContentStream := BuildStream(UTF8String('already voted'));
                vr_Exception : AResponseInfo.ContentStream := BuildStream(UTF8String('exception'));
            end;
        end;


        if (queriedAction = 'file_moveup') and localControl then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveUpCheck, queriedID);
            // res = -1: Moveup of a prebook-list-item. reload of Playlist is recommended
            // res = -2: moveup of first item, no action required
            // res >= 0: moveup of a file, swapping required

            // send moveup-message to player
            if  res >= -1 then
                SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveUp, queriedID);

            // send ID/res to browser
            AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(res)));
            result := qrPermit;
        end;

        if (queriedAction = 'file_movedown') and localControl then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveDownCheck, queriedID);
            // res = -1: Moveup of a prebook-list-item. reload of Playlist is recommended
            // res = -2: moveup of first item, no action required
            // res >= 0: moveup of a file, swapping required

            // send moveup-message to player
            if  res >= -1 then
                SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveDown, queriedID);

            // send ID/res to browser
            AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(res)));
            result := qrPermit;
        end;

        if (queriedAction = 'file_delete') and localControl then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID);

            // possible values for "res"
            // 0 : Invalid, reload playlist
            // 1 : File deleted, just hide the item in browser
            // 2 : File removed from Prebooklist, reload Playlist
            AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(res)));
            result := qrPermit;
        end;

        if ((queriedAction = 'file_addnext')
            or (queriedAction = 'file_add'))  and localControl
        then
        begin
            requestDone := True;
            addNext(queriedAction, False);
        end;


        if (queriedAction = 'loaditem') then
        begin
            requestDone := True;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);

            // return one (or all) item of the playlist
            EnterCriticalSection(CS_AccessHTMLCode);
            if isAdmin then
                SendMessage(fMainWindowHandle, WM_WebServer, WS_QueryPlaylistItemAdmin, queriedID)
            else
                SendMessage(fMainWindowHandle, WM_WebServer, WS_QueryPlaylistItem, queriedID);
            html := HTML_PlaylistView;
            LeaveCriticalSection(CS_AccessHTMLCode);

            AResponseInfo.ContentStream := BuildStream(html);
            result := qrPermit;
        end;

        if not requestDone then
            result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
    end
    else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied, isAdmin)
    end;


end;

function TNempWebServer.ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
begin
        AResponseInfo.ContentType := 'text/html; charset=utf-8';
       ms := TMemoryStream.Create;
            EnterCriticalSection(CS_AccessHTMLCode);
            if isAdmin then
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistAdmin, 0)
            else
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylist, 0);
            html := HTML_PlaylistView;
            LeaveCriticalSection(CS_AccessHTMLCode);
        if html = '' then html := ' ';
        ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
end;


function TNempWebServer.ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    queriedID: Integer;
begin
        EnterCriticalSection(CS_AccessHTMLCode);
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        AResponseInfo.ContentType := 'text/html; charset=utf-8';

        if isAdmin then
            SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistDetailAdmin, queriedID)
        else
            SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistDetail, queriedID);
        html := HTML_PlaylistDetails;
        LeaveCriticalSection(CS_AccessHTMLCode);
        if html <> '' then
        begin
            ms := TMemoryStream.Create;
            ms.Write(html[1], length(html));
            AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := ms;
            result := qrPermit;
        end else
            result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
end;

function TNempWebServer.ResponseCover (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedCover: String;
    fn: UnicodeString;
begin
    queriedCover := aRequestInfo.Params.Values['ID'];
    fn := TCoverArtSearcher.SavePath + queriedCover + '.jpg';
    if not FileExists(fn) then
        fn := fLocalDir + 'default_cover.png';
    if not FileExists(fn) then
        fn := fLocalDir + 'default_cover.jpg';

    if FileExists(fn) then
    begin
        try
            AResponseInfo.ContentType := FileType2MimeType(fn);
            AResponseInfo.ContentStream := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
            result := qrPermit;
        except
            result := HandleError(AResponseInfo, qrError, isAdmin);
        end;
    end else
        result := qrFileNotFound;
end;


function TNempWebServer.ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedID: Integer;
    fn: UnicodeString;
    af: TAudioFile;
begin
    if AllowFileDownload or isAdmin then
    begin
        // Check first in the playlist
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);

        // Critical Section - das hier läuft in einem Thread
        EnterCriticalSection(CS_AccessPlaylistFilename);
        // Nachricht an VCLm dort wird QueriedPlaylistFilename gesetzt
        SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDownloadID, queriedID);
        // das abrufen in lokale Variable
        fn := QueriedPlaylistFilename;
        // CS verlassen
        LeaveCriticalSection(CS_AccessPlaylistFilename);

        if fn = '' then
        begin
            // ID was not found in the Playlist
            // -> Search in the library
            EnterCriticalSection(CS_AccessLibrary);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
                fn := af.Pfad;
            LeaveCriticalSection(CS_AccessLibrary);
        end;

        if fn = '' then
        begin
            // ID was not found in Bib nor Playlist => Invalid request
            result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
        end else
        begin
            if (FileExists(fn)) then
            begin
                try
                    AResponseInfo.CustomHeaders.Add(('Content-Disposition: attachment; '));
                    AResponseInfo.ContentType := 'audio/mp3';
                    //AResponseInfo.ServeFile(AContext, fn);
                    AResponseInfo.ContentStream := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
                    result := qrPermit;
                except
                    //error
                    result := HandleError(AResponseInfo, qrError, isAdmin);
                end;
            end else
            begin
                // File not found
                result := HandleError(AResponseInfo, qrFileNotFound, isAdmin);
            end;
        end;
    end else
    begin
        result := HandleError(AResponseInfo, qrDownloadDenied, isAdmin);
    end;
end;


function utf8URLDecode(ASrc: AnsiString): UTf8String;
var
  i: integer;
  ESC: string[2];
  CharCode: integer;
  tmp: AnsiString;
begin
  tmp := '';    {Do not Localize}
  // S.G. 27/11/2002: Spaces is NOT to be encoded as "+".
  // S.G. 27/11/2002: "+" is a field separator in query parameter, space is...
  // S.G. 27/11/2002: well, a space
  // ASrc := StringReplace(ASrc, '+', ' ', [rfReplaceAll]);  {do not localize}
  i := 1;
  while i <= Length(ASrc) do begin
    if ASrc[i] <> '%' then begin  {do not localize}
      tmp := tmp + AnsiString(ASrc[i])
    end else begin
      Inc(i); // skip the % char
      ESC := Copy(ASrc, i, 2); // Copy the escape code
      Inc(i, 1); // Then skip it.
      try
        CharCode := StrToInt(String('$' + ESC));  {do not localize}
        tmp := tmp + (AnsiChar(CharCode));
      except end;
    end;
    Inc(i);
  end;
  if length(tmp) > 0 then
  begin
      setlength(result, length(tmp));
      move(tmp[1], result[1], length(result));
  end else
      result := '';

end;


function TNempWebServer.ResponseSearchInLibrary (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    searchstring: String;
    a: AnsiString;
    i, Start: Integer;

begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowLibraryAccess or isAdmin then
    begin
        Start  := StrToIntDef(aRequestInfo.Params.Values['start'], 0);

        i := pos('query=', ARequestInfo.UnparsedParams);
        if i > 0 then
        begin
            // UnparsedParams sollte nur Ascii-Zeichen anthalten - also ist das ok
            a := AnsiString(copy(ARequestInfo.UnparsedParams, i+6, length(ARequestInfo.UnparsedParams) - i));
            // die Parameter sind utf-kodiert als %12%43%82%20 ...
            // also: Die %xx in UTF8String dekodieren, das Ergebnis zu UnicodeString
            SearchString := Utf8ToString(utf8URLDecode(a));
        end else
            SearchString := '';

        ms := TMemoryStream.Create;
        html := GenerateHTMLMedienbibSearchFormular(searchstring, Start, isAdmin);
        if html = '' then html := ' ';
            ms.Write(html[1], length(html));
        // NOT necessary here AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied, isAdmin);
end;

function TNempWebServer.ResponseBrowseInLibrary (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var QueryMode, QueryLetter, QueryValue, QueryOther: String;
    ms: TMemoryStream;
    html: UTf8String;
    i, Start: Integer;
    a: AnsiString;
begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowLibraryAccess or isAdmin then
    begin
        Start       := StrToIntDef(aRequestInfo.Params.Values['start'], 0);
        QueryMode   := aRequestInfo.Params.Values['mode'];
        QueryLetter := UpperCase(aRequestInfo.Params.Values['l']);
        //QueryValue  := aRequestInfo.Params.Values['value'];

        i := pos('value=', ARequestInfo.UnparsedParams);
        if i > 0 then
        begin
            // UnparsedParams sollte nur Ascii-Zeichen anthalten - also ist das ok
            a := AnsiString(copy(ARequestInfo.UnparsedParams, i+6, length(ARequestInfo.UnparsedParams) - i));
            // die Parameter sind utf-kodiert als %12%43%82%20 ...
            // also: Die %xx in UTF8String dekodieren, das Ergebnis zu UnicodeString
            QueryValue := Utf8ToString(utf8URLDecode(a));
        end else
            QueryValue := '';

        QueryOther  := aRequestInfo.Params.Values['other'];

        if QueryValue = '' then
        begin
            if QueryLetter = '' then
                QueryLetter := 'A';
            // generate List of Artists/Albums/Genres according to QueryMode (+ Letter)

            ms := TMemoryStream.Create;
            html := GenerateHTMLMedienbibBrowseList(Querymode, QueryLetter[1], QueryOther='1', isAdmin);
            if html = '' then html := ' ';
                ms.Write(html[1], length(html));
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := ms;
            result := qrPermit;

        end else
        begin
            // generate List of Titles according to QueryMode + Value
            ms := TMemoryStream.Create;
            html := GenerateHTMLMedienbibBrowseResult(Querymode, QueryValue, Start, isAdmin);
            if html = '' then html := ' ';
                ms.Write(html[1], length(html));
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := ms;

            result := qrPermit;
        end;
    end  else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied, isAdmin);
end;

function TNempWebServer.ResponseLibraryDetails (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedID: Integer;
    af: TAudioFile;
    html: UTf8String;
    ms: TMemoryStream;
begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowLibraryAccess or isAdmin then
    begin
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        // Ja, doppelt eintreten hält besser! Nach dem Verlassen von getAudioFilefromLib könnte sonst die Liste geleert werden!!
        EnterCriticalSection(CS_AccessLibrary);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
            begin
                html := GenerateHTMLfromMedienbibSearch_Details(af, isAdmin);
                ms := TMemoryStream.Create;
                if html = '' then html := ' ';
                ms.Write(html[1], length(html));
                // NOT necessary here AddNoCacheHeader(AResponseInfo);
                AResponseInfo.ContentStream := ms;
                result := qrPermit;
            end else // not in bib
                result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
        LeaveCriticalSection(CS_AccessLibrary);
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied, isAdmin);
end;

procedure TNempWebServer.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var //ms: TMemoryStream;
    RequestedDocument: String;
    permit: TQueryResult;
    fn: UnicodeString;
    queriedAction: String;
    isAdmin: Boolean;
    UserLoginOK, AdminLoginOK, DoLog: Boolean;
begin
    DoLog := True;
    if ValidIP(AContext.Binding.PeerIP, AContext.Binding.IP) then
    begin
        RequestedDocument := aRequestInfo.Document;

        if RequestedDocument = '/admin' then
        begin
            AResponseInfo.Redirect('/admin/player');
            exit;
        end;

        if AnsiStartsStr('/admin', RequestedDocument) then
        begin
            RequestedDocument := Copy(RequestedDocument, 7, length(RequestedDocument));
            isAdmin := True;
        end else
            isAdmin := False;

        if (RequestedDocument = '/') or (RequestedDocument = '') then
            RequestedDocument := '/player';


        UserLoginOK := (ARequestInfo.AuthUsername = UsernameU) and (ARequestInfo.AuthPassword = PasswordU);
        AdminLoginOK := (ARequestInfo.AuthUsername = UsernameA) and (ARequestInfo.AuthPassword = PasswordA);


        if isAdmin and (not AdminLoginOK) then
        begin
            logQueryAuth(AContext, aRequestInfo);
            AResponseInfo.ContentText := 'Administrator verification needed';
            AResponseInfo.AuthRealm := 'Nemp webserver login';
            exit;
        end else
            if (not UserLoginOK) and (not AdminLoginOK) then
            begin
                logQueryAuth(AContext, aRequestInfo);
                AResponseInfo.ContentText := 'Enter your username and password';
                AResponseInfo.AuthRealm := 'Nemp webserver login';
                exit;
            end;

        if RequestedDocument = '/player' then permit := ResponsePlayer(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playlist' then permit := ResponsePlaylistView(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/library' then permit := ResponseSearchInLibrary(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/browse' then permit := ResponseBrowseInLibrary(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/cover' then permit := ResponseCover(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playercontrol' then permit := ResponseClassicPlayerControl(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playercontrolJS' then begin
            permit := ResponseJSPlayerControl(ARequestInfo, AResponseInfo, isAdmin);
            queriedAction := aRequestInfo.Params.Values['action'];
            DoLog := queriedAction <> 'getprogress';
        end
        else
        if RequestedDocument = '/playlistcontrol' then permit := ResponseClassicPlaylistControl(AContext, ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playlistcontrolJS' then permit := ResponseJSPlaylistControl(AContext, ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playlist_details' then permit := ResponsePlaylistDetails(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/library_details' then permit := ResponseLibraryDetails(ARequestInfo, AResponseInfo, isAdmin)
        else
        begin
            // Hier: Erstmal testen, obs der Versuch ist, eine Datei runterzuladen
            // d.h. Es gibt einen Parameter "download"
            queriedAction := ARequestInfo.Params.Values['Action'];

            // '' dürfte am häufigsten vorkommen (css, bilder, ...)
            if queriedAction = '' then
            begin
                fn := fLocalDir + StringReplace(RequestedDocument, '/', '\', [rfReplaceAll]);
                if FileExists(fn) then
                begin
                    DoLog := False;
                    try
                        AResponseInfo.ContentStream := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
                        AResponseInfo.ContentType := FileType2MimeType(RequestedDocument);
                        permit := qrPermit;
                    except
                        permit := HandleError(AResponseInfo, qrError, isAdmin);
                    end
                end
                else
                    permit := HandleError(AResponseInfo, qrFileNotFound, isAdmin);

            end else
                if queriedAction = 'file_download' then
                begin
                    permit := ResponseFileDownload(ARequestInfo, AResponseInfo, isAdmin);
                end
                else
                    permit := qrDeny;
        end;
    end else
        permit := qrDeny;

    if DoLog then
        logQuery(AContext, aRequestInfo, permit);
end;



initialization


  InitializeCriticalSection(CS_AccessHTMLCode);
  InitializeCriticalSection(CS_AccessPlaylistFilename);
  InitializeCriticalSection(CS_AccessLibrary);
  InitializeCriticalSection(CS_Authentification);


finalization


  DeleteCriticalSection(CS_AccessHTMLCode);
  DeleteCriticalSection(CS_AccessPlaylistFilename);
  DeleteCriticalSection(CS_AccessLibrary);
  DeleteCriticalSection(CS_Authentification);

  
end.
