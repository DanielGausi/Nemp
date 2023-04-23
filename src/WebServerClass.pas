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

uses Windows, Classes, Messages, ContNrs, SysUtils, System.IOUtils, dialogs,
  IniFiles,  StrUtils, IdBaseComponent, IdComponent, IdCustomTCPServer,
  System.Generics.Defaults,
  IdCustomHTTPServer, IdHTTPServer, IdContext,
  NempAudioFiles, Hilfsfunktionen, HtmlHelper,
  Playlistclass, PlayerClass, Nemp_ConstantsAndTypes,
  MedienbibliothekClass, BibSearchClass, Votings,
  AudioDisplayUtils, LibraryOrganizer.Base, LibraryOrganizer.Files;

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
    //WS_PlaylistMoveUpCheck = 17;
    WS_PlaylistMoveDown = 8;
    //WS_PlaylistMoveDownCheck  = 18;
    WS_QueryPlaylistJS = 20;
    WS_QueryPlaylistJSAdmin = 120;
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
    AllowHtmlAudio,
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
    AllowHtmlAudio    : True;
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
const
  ResponseCodes: Array[TQueryResult] of Integer = (200, 403, 403, 403, 403, 404, 404, 400);

type
  TDoubleString = Array[Boolean] of String;

  teTemplates = (
    tplBody, tplPageError, tplPageLibrary, tplPageLibraryDetails, tplPagePlaylist, tplPagePlaylistDetails, tplPagePlayer,
    tplMenuMain, tplMenuLibrary,
    tplSummaryAlbum, tplSummaryArtist, tplSummaryGenre, tplSummarySearch,
    tplItemBrowseAlbum, tplItemBrowseArtist, tplItemBrowseGenre, tplItemFileLibrary, tplItemFileLibraryDetails,
    tplItemFilePlaylist, tplItemFilePlaylistDetails, tplItemPlayer, tplWarningNoFiles,
    tplPagination, //tplPaginationMainArtists, tplPaginationOtherArtists, tplPaginationNext, tplPaginationPrev,
    // tplPlayerControls,
    // tplBtnControlPlay, tplBtnControlPause, tplBtnControlStop, tplBtnControlNext, tplBtnControlPrev,

    tplBtnFilePlaynow, tplBtnFileAdd, tplBtnFileAddNext, tplBtnFileDelete,
    tplBtnFileMoveDown, tplBtnFileMoveUp, tplBtnFileVote, tplBtnFileDownload,
    tplBtnFilePlayBrowser, tplBtnIconNowPlaying,
    tplHtmlFileAudio, tplSliderPlaylistItemProgress
  );

const
  cTemplateFilenames: Array[teTemplates] of String = (
    'Body.tpl', 'PageError.tpl', 'PageLibrary.tpl', 'PageLibraryDetails.tpl', 'PagePlaylist.tpl', 'PagePlaylistDetails.tpl', 'PagePlayer.tpl',
    'MenuMain.tpl', 'MenuLibrary.tpl',
    'SummaryAlbum.tpl', 'SummaryArtist.tpl', 'SummaryGenre.tpl', 'SummarySearch.tpl',
    'ItemBrowseAlbum.tpl', 'ItemBrowseArtist.tpl', 'ItemBrowseGenre.tpl', 'ItemFileLibrary.tpl', 'ItemFileLibraryDetails.tpl',
    'ItemFilePlaylist.tpl', 'ItemFilePlaylistDetails.tpl', 'ItemFilePlayer.tpl', 'WarningNoFiles.tpl',
    'Pagination.tpl', // 'PaginationMainArtists.tpl', 'PaginationOtherArtists.tpl', 'PaginationNextPage.tpl', 'PaginationPrevPage.tpl',
    // 'PlayerControls.tpl',
    // 'BtnControlPlay.tpl', 'BtnControlPause.tpl', 'BtnControlStop.tpl', 'BtnControlNext.tpl', 'BtnControlPrev.tpl',
    'BtnFilePlayNow.tpl', 'BtnFileAdd.tpl', 'BtnFileAddNext.tpl', 'BtnFileDelete.tpl',
    'BtnFileMoveDown.tpl', 'BtnFileMoveUp.tpl', 'BtnFileVote.tpl', 'BtnFileDownload.tpl',
    'BtnFilePlayBrowser.tpl', 'BtnIconNowPlaying.tpl',
    'HtmlFileAudio.tpl', 'SliderPlaylistItemProgress.tpl'

  );
  // cCharOther: Char  = '§';
  // cCharOtherESC: String = '&sect;';
  cOtherLetters: String = 'other';

type
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

          fAllowPlaylistDownload : Longbool;
          fAllowHtmlAudio        : Longbool;
          fAllowLibraryAccess    : Longbool;
          fAllowRemoteControl    : Longbool;
          fAllowVotes            : LongBool;
          fPort                  : Word;

          // VCL-Variable
          fActive: Boolean;

          IdHTTPServer1: TIdHTTPServer;
          fLocalFormatSettings: TFormatSettings;
          fLocalDir: UnicodeString;
          fCommonDir: UnicodeString;
          fDefaultCoverFilename: UnicodeString;
          fLastErrorString: String;

          // List of Templates
          Templates: Array[teTemplates] of TDoubleString;

          // Lists for Browsing in the Library
          fCollectionAlbums : TRootCollection;
          fCollectionArtists: TRootCollection;
          fCollectionGenres : TRootCollection;
          // for the Subnavigation (letters)
          // Count of the collections starting with each letter.
          // If a value is zero, it will be left out in the navigation menu
          fMainArtistCount,
          fOtherArtistCount,
          fAlbumCount, fAlbumCountByArtist: Array[0..27] of Integer;

          // maximum number of files in one of the collections starting with each letter.
          // Used to calculate a proper font size for each cllection in the list of artist and genre
          fMaxCountMainArtist,
          fMaxCountOtherArtist: Array[0..27] of Integer;
          fMaxCountGenre: Integer;

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
          procedure fSetAllowHtmlAudio       (Value: Longbool);

          //function fGetOnlyLAN              : Longbool;
          function fGetAllowPlaylistDownload: Longbool;
          function fGetAllowLibraryAccess   : Longbool;
          function fGetAllowRemoteControl   : Longbool;
          function fGetAllowVotes           : Longbool;
          function fGetAllowHtmlAudio       : Longbool;

          function MainMenu(aPage: Integer; IsAdmin: Boolean): String;
          function BrowseSubMenu(aMode, startLetter: String; aValue: String; SortAlbumsByArtist, IsAdmin: Boolean): String;

          function fGetCount: Integer;

          // replace basic Insert-tags like {{artist}} in a given pattern
          function fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
          // replace InsertTags for Buttons
          function fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer; isAdmin: Boolean; IsPlayingFile: Boolean = False): String;

          // function fSetControlButtons(aPattern: String; isPlaying, isAdmin: Boolean): String;

          // The following methods have been methods of a WebServerForm-Class
          // ---->
          procedure logQuery(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; Permit: TQueryResult);
          procedure logQueryAuth(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo);

          function CreateStream(aContent: UTF8String): TMemoryStream;

          function HandleError(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult; isAdmin: Boolean): TQueryResult;
          function HandleErrorJS(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult; isAdmin: Boolean): TQueryResult;
          function GenerateErrorPage(aErrorMessage: String; aPage: Integer; isAdmin: Boolean): String;

          procedure AddNoCacheHeader(AResponseInfo: TIdHTTPResponseInfo);
          function ResponsePlayer (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponsePlayerJS (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseJSPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseClassicPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; Completepage: Boolean; isAdmin: Boolean): TQueryResult;
          function ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
          function ResponseCover (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseJSPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;

          function ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean; HtmlAudio: Boolean): TQueryResult;

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

          procedure InitRootCollections;

          function NavigationIndex(s: String): Integer;
          procedure PrepareCollections;

          function LoadSettingsDeprecated: Boolean;
          procedure LoadDefaultSettings;

          function FilePagination(Start, maxCount: Integer; LinkPrev, LinkNext: String; isAdmin: Boolean): String;
          function ArtistNavigation(startLetter, LinkMain, LinkOther: String; isAdmin: Boolean): String;

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
          property AllowHtmlAudio: LongBool read fGetAllowHtmlAudio write fSetAllowHtmlAudio;



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

          procedure GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; CompletePage: Boolean; isAdmin: Boolean);

          // List of Files in the Playlist.
          procedure GenerateHTMLfromPlaylist(aNempPlayList: TNempPlaylist; CompletePage: Boolean; isAdmin: Boolean);
          // File details for one file in the playlist
          procedure GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer; isAdmin: Boolean);

          // Das kann im Indy-Thread gemacht werden, daher mit Result
          // List of Albums, Artists or Genres
          function GenerateHTMLCollectionList(CollectionType: String; startLetter: String; SortAlbumsByArtist, other, isAdmin: Boolean): UTf8String;
          // List of Files of an Album, an Artist or a Genre
          function GenerateHTMLFileList(CollectionType: String; CollectionID: String; startLetter: String; Start: Integer; SortAlbumsByArtist, isAdmin: Boolean): UTf8String; overload;
          // List of files, matching a SearchString
          function GenerateHTMLFileList(aSearchString: UnicodeString; Start: Integer; isAdmin: Boolean): UTf8String; overload;
          // File details for one file in the Library
          function GenerateHTMLFileDetailsLibrary(aAudioFile: TAudioFile; isAdmin: Boolean): UTf8String;

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
  MIMEExtensions: array[1..31] of TMimeExtension = (

    (Ext: '.png'; MimeType: 'image/x-png'),
    (Ext: '.jpg'; MimeType: 'image/jpeg'),
    (Ext: '.jpeg'; MimeType: 'image/jpeg'),
    (Ext: '.html'; MimeType: 'text/html'),
    (Ext: '.htm'; MimeType: 'text/html'),
    (Ext: '.css'; MimeType: 'text/css'),
    (Ext: '.js'; MimeType: 'text/javascript'),

    (Ext: '.mp3'; MimeType: 'audio/mpeg'),
    (Ext: '.mp4'; MimeType: 'audio/mp4'),
    (Ext: '.m4a'; MimeType: 'audio/mp4'),
    (Ext: '.ogg'; MimeType: 'audio/ogg'),
    (Ext: '.opus'; MimeType: 'audio/opus'),
    (Ext: '.wav'; MimeType: 'audio/wav'),
    (Ext: '.flac'; MimeType: 'audio/flac'),

    (Ext: '.mpa'; MimeType: 'audio/mpeg'),
    (Ext: '.mp2'; MimeType: 'audio/mpeg'),
    (Ext: '.mp2a'; MimeType: 'audio/mpeg'),
    (Ext: '.aif'; MimeType: 'audio/x-aiff'),
    (Ext: '.aiff'; MimeType: 'audio/x-aiff'),
    (Ext: '.aifc'; MimeType: 'audio/x-aiff'),
    (Ext: '.mid'; MimeType: 'audio/midi'),
    (Ext: '.midi'; MimeType: 'audio/midi'),

    (Ext: '.txt'; MimeType: 'text/plain'),
    (Ext: '.xls'; MimeType: 'application/excel'),
    (Ext: '.rtf'; MimeType: 'text/richtext'),
    (Ext: '.gif'; MimeType: 'image/gif'),
    (Ext: '.jpe'; MimeType: 'image/jpeg'),
    (Ext: '.bmp'; MimeType: 'image/x-ms-bmp'),
    (Ext: '.pdf'; MimeType: 'application/pdf'),
    (Ext: '.zip'; MimeType: 'application/zip'),
    (Ext: '.exe'; MimeType: 'application/octet-stream')
);

function FileType2MimeType(const AFileName: string; default: String = 'text/html'): string;


var
    CS_AccessHTMLCode: RTL_CRITICAL_SECTION;
    CS_AccessPlaylistFilename: RTL_CRITICAL_SECTION;
    CS_AccessLibrary: RTL_CRITICAL_SECTION;
    CS_Authentification: RTL_CRITICAL_SECTION;

const
    cMinCountProperArtist = 5;
    cMinCountProperAlbum = 3;
    GoodArtist = 5;
    GoodAlbum  = 3;
    MergeArtistConst = 50;
    MaxCountPerPage = 100;

implementation

uses Nemp_RessourceStrings, AudioFileHelper, StringHelper, CoverHelper, math;

function FileType2MimeType(const AFileName: string; default: String = 'text/html'): string;
var
  FileExt: string;
  I: Integer;
begin
  Result := default; //'text/html';
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

(*function EscapedLetterParam(aLetter: Char): String;
begin
  if aLetter = cCharOther then
    result := cCharOtherESC
  else
    result := aLetter;
end;*)


constructor TNempWebServer.Create(aHandle: DWord);
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

    fCommonDir := ExtractFilePath(Paramstr(0)) + 'HTML\Common\';
    fDefaultCoverFilename := fCommonDir + 'default_cover.png';
    if not FileExists(fDefaultCoverFilename) then
      fDefaultCoverFilename := fCommonDir + 'default_cover.png';
    if not FileExists(fDefaultCoverFilename) then
      fDefaultCoverFilename := '';

    LogList := TStringList.Create;
    VoteMachine := TVoteMachine.Create(aHandle);
    VoteMachine.LibraryList := fWebMedienBib;

    fCollectionAlbums := TRootCollection.Create(Nil);
    fCollectionArtists:= TRootCollection.Create(Nil);
    fCollectionGenres := TRootCollection.Create(Nil);
    InitRootCollections;
end;

destructor TNempWebServer.Destroy;
var i: Integer;
begin
    IdHTTPServer1.Active := False;
    EnterCriticalSection(CS_AccessLibrary);
    fCollectionAlbums.Free;
    fCollectionArtists.Free;
    fCollectionGenres.Free;

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

procedure TNempWebServer.InitRootCollections;
const
  cAlbumConfig: TCollectionConfig = (
      Content: ccAlbum;
      PrimarySorting: csAlbum; //csArtist;
      SecondarySorting: csArtist; //csAlbum;
      TertiarySorting: csDefault; SortDirection1: sd_Ascending; SortDirection2: sd_Ascending; SortDirection3: sd_Ascending );

  cArtistConfig: TCollectionConfig = (
      Content: ccArtist;
      PrimarySorting: csArtist;
      SecondarySorting: csDefault;
      TertiarySorting: csDefault; SortDirection1: sd_Ascending; SortDirection2: sd_Ascending; SortDirection3: sd_Ascending );

  cGenreConfig: TCollectionConfig = (
      Content: ccGenre;
      PrimarySorting: csGenre;
      SecondarySorting: csDefault;
      TertiarySorting: csDefault; SortDirection1: sd_Ascending; SortDirection2: sd_Ascending; SortDirection3: sd_Ascending );
begin
  fCollectionAlbums.AddSubCollectionType(cAlbumConfig);
  fCollectionArtists.AddSubCollectionType(cArtistConfig);
  fCollectionArtists.AddSubCollectionType(cAlbumConfig);
  fCollectionGenres.AddSubCollectionType(cGenreConfig);
  fCollectionGenres.AddSubCollectionType(cArtistConfig);

  // später, nach dem befüllen: fCollectionAlbums.Sort(True)
  // Das sortiert die interne CollectionList mit den ganzen Alben (bzw. Artists, Genres)
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
    AllowHtmlAudio   := NempSettingsManager.ReadBool('Webserver', 'AllowHtmlAudio' , cDefaultServerSettings.AllowHtmlAudio );

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
  NempSettingsManager.WriteBool('Webserver', 'AllowHtmlAudio' , AllowHtmlAudio );
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

procedure TNempWebServer.fSetAllowHtmlAudio(Value: Longbool);
begin
    InterLockedExchange(Integer(fAllowHtmlAudio), Integer(Value));
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

function TNempWebServer.fGetAllowHtmlAudio: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fAllowHtmlAudio));
end;

function TNempWebServer.MainMenu(aPage: Integer; IsAdmin: Boolean): String;
begin
    result := Templates[tplMenuMain][isAdmin];

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

function TNempWebServer.BrowseSubMenu(aMode, startLetter: String; aValue: String; SortAlbumsByArtist, isAdmin: Boolean): String;
var sub: String;
    c: Char;
    letterClass, sortparam: String;
    idx: Integer;
begin
    result := Templates[tplMenuLibrary][isAdmin];

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

    //if  then // fallback
    //    sub := '';

    if (aMode = '') or (aMode = 'genre')then
      sub := ''
    else
    begin
        sub := '<ul class="charselection">';
        sortParam := IfThen((aMode = 'album') and SortAlbumsByArtist, '&albumsortmode=artist');

        // Links to "A".."Z"
        for c := 'A' to 'Z' do begin
          if c = startLetter then
            letterClass := c + ' active'
          else
            letterClass := c;
          idx := ord(c) - ord('A') + 1;
          if ((aMode = 'artist') and (fMainArtistCount[idx] + fOtherArtistCount[idx] > 0))
            or ((aMode = 'album') and (not SortAlbumsByArtist) and (fAlbumCount[idx] > 0))
            or ((aMode = 'album') and (SortAlbumsByArtist) and (fAlbumCountByArtist[idx] > 0))
          then
            sub := sub + '<li class="' + letterClass +'"> <a href="library?mode=' + aMode + sortParam + '&l=' + c + '">' + c + '</a></li>'#13#10;
        end;

        // Link to "0"
        if ((aMode = 'artist') and (fMainArtistCount[0] + fOtherArtistCount[0] > 0))
          or ((aMode = 'album') and (not SortAlbumsByArtist) and (fAlbumCount[0] > 0))
          or ((aMode = 'album') and (SortAlbumsByArtist) and (fAlbumCountByArtist[0] > 0))
        then begin
          letterClass := IfThen(startLetter = '0', 'number active', 'number');
          sub := sub +  '<li class="' + letterClass + '"> <a href="library?mode=' + aMode + sortParam + '&l=0">0-9</a></li>'#13#10;
        end;

        // Link to "other"
        if ((aMode = 'artist') and (fMainArtistCount[27] + fOtherArtistCount[27] > 0))
          or ((aMode = 'album') and (not SortAlbumsByArtist) and (fAlbumCount[27] > 0))
          or ((aMode = 'album') and (SortAlbumsByArtist) and (fAlbumCountByArtist[27] > 0))
        then begin
          letterClass := IfThen(startLetter = cOtherLetters, cOtherLetters + ' active', cOtherLetters);
          sub := sub +  '<li class="' + letterClass + '"> <a href="library?mode=' + aMode + sortParam + '&l=' + EscapeHTMLChars(cOtherLetters) + '">other</a></li>'#13#10;
        end;
        // Sort-Link for Albums (by Album name or by Artist name)
        if (aMode = 'album') and (aValue = '') then begin
          if SortAlbumsByArtist then
            sub := sub +  '<li class="sortmode"> <a href="library?mode=' + aMode + '&l=' + EscapeHTMLChars(startLetter) + '">Sort by album name</a></li>'#13#10
          else
            sub := sub +  '<li class="sortmode"> <a href="library?albumsortmode=artist&mode=' + aMode + '&l=' + EscapeHTMLChars(startLetter) + '">Sort by artist name</a></li>'#13#10
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
      case ASrc[i] of
        ' ': Result := Result + '%20';
      else
        Result := Result + '&#' + IntToStr(Ord(ASrc[i])) + ';';
       // '&', '*','#','%','<','>','[',']':
        //#33..#128: Result := Result + ASrc[i];
      end;
       (* if CharInSet(ASrc[i], ['&', '*','#','%','<','>',' ','[',']'])   //(ASrc[i] in ['&', '*','#','%','<','>',' ','[',']'])
          or (not CharInSet(ASrc[i], [#33..#128]) )                     //or (not (ASrc[i] in [#33..#128]))
        then
            Result := Result + '&#' + IntToStr(Ord(ASrc[i])) + ';'
        else
            Result := Result + ASrc[i];*)
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


function TNempWebServer.FilePagination(Start, maxCount: Integer; LinkPrev, LinkNext: String; isAdmin: Boolean): String;
var
  pagination: String;
  StartNext: Integer;
const
  LinkClass: Array[Boolean] of String = ('navigate', 'hidden');

begin
  pagination := Templates[tplPagination][isAdmin];
  pagination := StringReplace(pagination, '{{ClassFiles}}', 'files', [rfReplaceAll]);

  StartNext := Start + MaxCountPerPage;
  if StartNext >= maxCount then
    StartNext := maxCount;

  pagination := StringReplace(pagination, '{{LinkPrev}}', LinkPrev, [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassPrev}}', LinkClass[linkPrev = ''], [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkNext}}', LinkNext, [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassNext}}', LinkClass[LinkNext = ''], [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{Start}}' , IntToStr(Start+1), [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{End}}'   , IntToStr(StartNext), [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{Count}}' , IntToStr(maxCount), [rfReplaceAll]);

  // hide Artist-Navigation
  pagination := StringReplace(pagination, '{{ClassArtists}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassMain}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassOther}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkMain}}', '', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkOther}}', '', [rfReplaceAll]);

  result := pagination;
end;

function TNempWebServer.ArtistNavigation(startLetter, LinkMain, LinkOther: String; isAdmin: Boolean): String;
var
  pagination: String;
const
  LinkClass: Array[Boolean] of String = ('navigate', 'hidden');

begin
  pagination := Templates[tplPagination][isAdmin];
  pagination := StringReplace(pagination, '{{ClassArtists}}', 'artists', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassMain}}', LinkClass[LinkMain = ''], [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassOther}}', LinkClass[LinkOther = ''], [rfReplaceAll]);

  pagination := StringReplace(pagination, '{{Letter}}', startLetter, [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkMain}}', LinkMain, [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkOther}}', LinkOther, [rfReplaceAll]);

  // hide File-Navigation
  pagination := StringReplace(pagination, '{{ClassFiles}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassPrev}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{ClassNext}}', 'hidden', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkPrev}}', '', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{LinkNext}}', '', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{Start}}', '0', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{End}}', '0', [rfReplaceAll]);
  pagination := StringReplace(pagination, '{{Count}}', '0', [rfReplaceAll]);
  result := pagination;
end;



function TNempWebServer.fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
var duration, aClass: String;
    quality, filesize, filetype, path: String;
    notfound: Boolean;
    currentAlbumID, currentArtistID, currentGenreID: Integer;
    afc: TAudioFileCollection;
begin
    // IDs/Index MUST be replaced befor calling this method
    // (these are specific for playlist/library-view)
    result := aPattern;
    result := StringReplace(result, '{{Index}}'        , '', [rfReplaceAll]);
    result := StringReplace(result, '{{ID}}'           , '', [rfReplaceAll]);

    // Set Duration
    duration := IfThen(af.isStream, '(inf)', SekIntToMinStr(af.Duration));

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
        quality := IfThen(af.vbr, inttostr(af.Bitrate) + ' kbit/s (vbr), ', inttostr(af.Bitrate) + ' kbit/s, ');
        quality := quality + fWebDisplay.TreeSamplerate(af);
    end;

    // Set filesize
    filesize := IfThen(af.IsFile, (FloatToStrF((af.Size / 1024 / 1024), ffFixed, 4, 2)));

    // Set filetype
    case af.AudioType of
        at_Undef  : filetype := 'unknown';
        at_File   : filetype := AnsiLowerCase(ExtractFileExt(af.Pfad));
        at_Stream : filetype := 'Webstream';
        at_CDDA   : filetype := 'CD-Audio';
        at_CUE    : filetype := 'CUE';
    end;

    // Set path (yes, only for streams, and NOT for files!)
    path := IfThen(af.isStream, af.Pfad);

    // Replace Insert-Tags in Pattern
    result := StringReplace(result, '{{Class}}'        , aClass, [rfReplaceAll]);

    result := StringReplace(result, '{{PlaylistTitle}}', EscapeHTMLChars(fWebDisplay.PlaylistTitle(af)), [rfReplaceAll]);
    result := StringReplace(result, '{{Title}}'    , EscapeHTMLChars(fWebDisplay.GetNonEmptyTitle(af)) , [rfReplaceAll]);
    result := StringReplace(result, '{{Artist}}'   , EscapeHTMLChars(af.Artist), [rfReplaceAll]);
    result := StringReplace(result, '{{Album}}'    , EscapeHTMLChars(af.Album) , [rfReplaceAll]);
    result := StringReplace(result, '{{Genre}}'    , EscapeHTMLChars(af.Genre) , [rfReplaceAll]);
    result := StringReplace(result, '{{Genre}}'    , EscapeHTMLChars(af.Genre) , [rfReplaceAll]);
    result := StringReplace(result, '{{Duration}}'    , EscapeHTMLChars(SekIntToMinStr(af.Duration)) , [rfReplaceAll]);
    if StrToIntDef(af.Year, -1) >= 0  then
      result := StringReplace(result, '{{Year}}', EscapeHTMLChars(af.Year) , [rfReplaceAll])
    else
      result := StringReplace(result, '{{Year}}', '- ? -' , [rfReplaceAll]);

    // Search-Links: Use the WebServerID of the proper Collection
    afc := fCollectionAlbums.SearchAudioFile(af, False);
    if assigned(afc) then
      currentAlbumID := afc.WebServerID
    else
      currentAlbumID := 0;

    afc := fCollectionArtists.SearchAudioFile(af, False);
    if assigned(afc) then begin
      if assigned(afc.Parent) then
        currentArtistID := afc.Parent.WebServerID
      else
        currentArtistID := afc.WebServerID;
    end
    else
      currentArtistID := 0;

    afc := fCollectionGenres.SearchAudioFile(af, False);
    if assigned(afc) then begin
      if assigned(afc.Parent) then
        currentGenreID := afc.Parent.WebServerID
      else
        currentGenreID := afc.WebServerID;
    end
    else
      currentGenreID := 0;

    result := StringReplace(result, '{{ArtistID}}'   , currentArtistID.ToString, [rfReplaceAll]);
    result := StringReplace(result, '{{AlbumID}}'    , currentAlbumID.ToString, [rfReplaceAll]);
    result := StringReplace(result, '{{GenreID}}'    , currentGenreID.ToString, [rfReplaceAll]);
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
    result := StringReplace(result, '{{Mime}}', FileType2MimeType(af.Dateiname, 'audio/unknown'), [rfReplaceAll]);
    result := StringReplace(result, '{{Filename}}', HRefEncode(af.Dateiname), [rfReplaceAll]);

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
        btnTmp := Templates[tplBtnFileDownload][isAdmin];
        btnTmp := StringReplace(btnTmp, '{{Filename}}', HRefEncode(af.Dateiname), [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{ID}}', IntToStr(af.WebServerID), [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Action}}', 'file_download', [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Mime}}', FileType2MimeType(af.Dateiname, 'audio/unknown'), [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileDownload}}', btnTmp, [rfReplaceAll]);
    end else
        buttons := StringReplace(buttons, '{{BtnFileDownload}}' , '', [rfReplaceAll]);

    if (AllowHtmlAudio or isAdmin) and af.IsFile then begin
        btnTmp := Templates[tplHtmlFileAudio][isAdmin];
        btnTmp := StringReplace(btnTmp, '{{Filename}}', HRefEncode(af.Dateiname), [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{ID}}', IntToStr(af.WebServerID), [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Action}}', 'file_stream', [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Mime}}', FileType2MimeType(af.Dateiname, 'audio/unknown'), [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{HtmlFileAudio}}', btnTmp, [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{HtmlFileAudioClass}}', '', [rfReplaceAll]);

        btnTmp := Templates[tplBtnFilePlayBrowser][isAdmin];
        btnTmp := StringReplace(btnTmp, '{{ID}}', IntToStr(af.WebServerID), [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFilePlayBrowser}}', btnTmp, [rfReplaceAll]);
        btnTmp := Templates[tplBtnIconNowPlaying][isAdmin];
        btnTmp := StringReplace(btnTmp, '{{ID}}', IntToStr(af.WebServerID), [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnIconNowPlaying}}', btnTmp, [rfReplaceAll]);
    end else begin
      buttons := StringReplace(buttons, '{{HtmlFileAudio}}', '', [rfReplaceAll]);
      buttons := StringReplace(buttons, '{{BtnFilePlayBrowser}}', '', [rfReplaceAll]);
      buttons := StringReplace(buttons, '{{BtnIconNowPlaying}}', '', [rfReplaceAll]);
      buttons := StringReplace(buttons, '{{HtmlFileAudioClass}}', 'hidden', [rfReplaceAll]);
    end;


    if AllowVotes or isAdmin then
    begin
        btnTmp := replaceTag(Templates[tplBtnFileVote][isAdmin], 'file_vote');
        buttons := StringReplace(buttons, '{{BtnFileVote}}', btnTmp, [rfReplaceAll]);
    end else
        buttons := StringReplace(buttons, '{{BtnFileVote}}'   , '', [rfReplaceAll]);


    if AllowRemoteControl or isAdmin then
    begin
        btnTmp := replaceTag(Templates[tplBtnFileMoveUp][isAdmin], 'file_moveup');
        buttons := StringReplace(buttons, '{{BtnFileMoveUp}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(Templates[tplBtnFileMoveDown][isAdmin], 'file_movedown');
        buttons := StringReplace(buttons, '{{BtnFileMoveDown}}', btnTmp, [rfReplaceAll]);
        if IsPlayingFile then
            buttons := StringReplace(buttons, '{{BtnFileDelete}}', '', [rfReplaceAll])
        else
        begin
            btnTmp := replaceTag(Templates[tplBtnFileDelete][isAdmin], 'file_delete');
            buttons := StringReplace(buttons, '{{BtnFileDelete}}', btnTmp, [rfReplaceAll]);
        end;
        btnTmp := replaceTag(Templates[tplBtnFilePlayNow][isAdmin], 'file_playnow');
        buttons := StringReplace(buttons, '{{BtnFilePlayNow}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(Templates[tplBtnFileAdd][isAdmin], 'file_add');
        buttons := StringReplace(buttons, '{{BtnFileAdd}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(Templates[tplBtnFileAddNext][isAdmin], 'file_addnext');
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

(* function TNempWebServer.fSetControlButtons(aPattern: String; isPlaying, isAdmin: Boolean): String;
var buttons: String;
begin
    buttons := aPattern;
    buttons := StringReplace(buttons, '{{PlayerControls}}'     , Templates[tplPlayerControls][isAdmin]   , [rfReplaceAll]);

    if AllowRemoteControl or isAdmin then
    begin
        if isPlaying then
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', Templates[tplBtnControlPause][isAdmin] , [rfReplaceAll])
        else
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', Templates[tplBtnControlPlay][isAdmin] , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'     , Templates[tplBtnControlStop][isAdmin]      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'     , Templates[tplBtnControlNext][isAdmin]      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'     , Templates[tplBtnControlPrev][isAdmin]      , [rfReplaceAll]);
    end else
    begin
        buttons := StringReplace(buttons, '{{BtnControlPlayPause}}' , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'      , '' , [rfReplaceAll]);
    end;
    result := buttons;
end; *)

function TNempWebServer.GenerateErrorPage(aErrorMessage: String; aPage: Integer; isAdmin: Boolean): String;
var menu: String;
begin
    menu := MainMenu(aPage, isAdmin);
    result := StringReplace(Templates[tplPageError][isAdmin], '{{Menu}}', menu, [rfreplaceAll]);
    result := StringReplace(result, '{{ErrorMessage}}', aErrorMessage, [rfreplaceAll]);
    result := StringReplace(result, '{{MenuLibrary}}'  , '' , [rfReplaceAll]);
end;


procedure TNempWebServer.GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; CompletePage: Boolean; isAdmin: Boolean);
var menu, PageData, PlayerData: String;
    af: TAudioFile;

const StatusClass: Array[Boolean] of String = ('notplaying', 'playing');
  ControlClass: Array[Boolean] of String = ('ControlsForbidden', 'ControlsAllowed');

begin
    menu := MainMenu(0, isAdmin);
    af := aNempPlayer.MainAudioFile;
    if assigned(af) then
    begin
        // ID generieren/setzen
        EnsureFileHasID(af);

        PlayerData := Templates[tplItemPlayer][isAdmin];
        PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
        PlayerData := fSetBasicFileData(af, PlayerData, '');
        PlayerData := fSetFileButtons(af, PlayerData, 0, isAdmin);
        PageData := Templates[tplPagePlayer][isAdmin];
        // PageData := fSetControlButtons(PageData, aNempPlayer.Status = PLAYER_ISPLAYING, isAdmin);
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemPlayer}}', PlayerData, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ClassPlayerStatus}}', StatusClass[aNempPlayer.Status = PLAYER_ISPLAYING], [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ClassControls}}', ControlClass[isAdmin or AllowRemoteControl], [rfReplaceAll]);

        if CompletePage then
          HTML_Player := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]))
        else
          HTML_Player := UTF8String(PageData);
    end else
    begin
        if CompletePage then begin
          PageData := GenerateErrorPage(WebServer_PlayerNotReady, 0, isAdmin);
          HTML_Player := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
        end else
          HTML_Player := '';
    end;
end;

// konvertiert die Playlist in ein HTML-Formular
// in VCL-Threads ausführen. Zugriff auf den HTML-String ist durch den Setter Threadsafe.
procedure TNempWebServer.GenerateHTMLfromPlaylist(aNempPlayList: TNempPlaylist; CompletePage: Boolean; isAdmin: Boolean);
var Item, Items, aClass, menu, PageData: String;
    af: tAudioFile;
    i: Integer;
begin
    if aNempPlayList.Count = 0 then begin
      // Error, empty Playlist
      if CompletePage then begin
        PageData := GenerateErrorPage(WebServer_EmptyPlaylist, 1, isAdmin);
        HTML_PlaylistView := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
      end
      else
        HTML_PlaylistView := '';
    end else
    begin
        // get All items
        Items := '';
        for i := 0 to aNempPlayList.Count - 1 do
        begin
          af := aNempPlayList.Playlist[i];
          // ID generieren/setzen
          EnsureFileHasID(af);

          // create new Item
          Item := Templates[tplItemFilePlaylist][isAdmin];
          Item := StringReplace(Item, '{{Index}}', IntToStr(i + 1), [rfReplaceAll]);
          Item := StringReplace(Item, '{{ID}}', IntToStr(af.WebServerID), [rfReplaceAll]);

          if af = aNempPlaylist.PlayingFile then begin
              Item := StringReplace(Item, '{{Anchor}}', 'id="currentTrack"', [rfReplaceAll]);
              Item := StringReplace(Item, '{{Progress}}', Templates[tplSliderPlaylistItemProgress][isAdmin] , [rfReplaceAll])
          end
          else begin
              Item := StringReplace(Item, '{{Anchor}}', '', [rfReplaceAll]);
              Item := StringReplace(Item, '{{Progress}}', '', [rfReplaceAll]);
          end;

          // Set "Current" class
          aClass := IfThen(af = aNempPlaylist.PlayingFile, 'current ');
          // replace tags
          Item := fSetBasicFileData(af, Item, aClass);
          Item := fSetFileButtons(af, Item, 1, isAdmin, af = aNempPlaylist.PlayingFile);
          Items := Items + Item;
        end;

        if CompletePage then begin
          menu := MainMenu(1, isAdmin);
          PageData := Templates[tplPagePlaylist][isAdmin];
          PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
          PageData := StringReplace(PageData, '{{PlaylistItems}}', Items, [rfReplaceAll]);
          HTML_PlaylistView := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
        end else begin
          HTML_PlaylistView := UTF8String(Items);
        end;
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

        FileData := Templates[tplItemFilePlaylistDetails][isAdmin];
        FileData := StringReplace(FileData, '{{Index}}' , IntToStr(aIdx + 1)              , [rfReplaceAll]);

        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1, isAdmin);

        PageData := Templates[tplPagePlaylistDetails][isAdmin];
        PageData := StringReplace(PageData, '{{Menu}}'               , menu     , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemPlaylistDetails}}', FileData , [rfReplaceAll]);
    end else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 1, isAdmin);

    HTML_PlaylistDetails := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLFileList(aSearchString: UnicodeString;
    Start: Integer; isAdmin: Boolean): UTf8String;
var ResultList: TAudioFileList;
    af: TAudioFile;
    i, maxIdx: Integer;
    Duration: Int64;
    aClass, PageData, Pagination, menu, browsemenu, Item, Items, warning, Summary: String;
    LinkPrev, LinkNext: String;
begin
    menu := Mainmenu(2, isAdmin);
    browsemenu := BrowseSubMenu('', '"', '', false, isAdmin);

    if trim(aSearchString) = '' then
      aSearchString := '*';

    PageData := Templates[tplPageLibrary][isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'       , menu         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{MenuLibrary}}' , browsemenu, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', aSearchString, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{ClassLibrary}}', 'search', [rfReplaceAll]);

    if aSearchString <> '' then
    begin
        Items := '';
        if Start < 0 then
            Start := 0;

        ResultList := TAudioFileList.Create(False);
        try
            SearchLibrary(aSearchString, ResultList);
            Duration := 0;
            for i := 0 to ResultList.Count-1 do
              Duration := Duration + ResultList[i].Duration;

            Summary := Templates[tplSummarySearch][isAdmin];
            Summary := StringReplace(Summary, '{{Search}}', EscapeHTMLChars(aSearchString) , [rfReplaceAll]);
            Summary := StringReplace(Summary, '{{Count}}', EscapeHTMLChars(ResultList.Count.ToString) , [rfReplaceAll]);
            Summary := StringReplace(Summary, '{{Duration}}', EscapeHTMLChars(SekToZeitString(Duration)) , [rfReplaceAll]);

            if ResultList.Count > 0 then
            begin
                PageData := StringReplace(PageData, '{{Summary}}', Summary, [rfReplaceAll]);
                maxIdx := Start + MaxCountPerPage - 1;
                if maxIdx > (ResultList.Count - 1) then
                    maxIdx := ResultList.Count - 1;

                for i := Start to maxIdx do
                begin
                    af := ResultList[i];
                    // ID generieren/setzen
                    EnsureFileHasID(af);
                    Item := Templates[tplItemFileLibrary][isAdmin];
                    Item := StringReplace(Item, '{{ID}}'  , IntToStr(af.WebServerID), [rfReplaceAll]);
                    aClass := '';
                    // replace tags
                    Item := fSetBasicFileData(af, Item, aClass);
                    Item := fSetFileButtons(af, Item, 2, isAdmin);
                    Items := Items + Item;
                end;
            end;

            // Build Pagination
            LinkPrev := '';
            LinkNext := '';
            if (Start > 0) then
              LinkPrev := 'search?start=' + IntToStr(start-MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
            if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
              LinkNext := 'search?start=' + IntToStr(start+MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
            if (LinkNext = '') and (LinkPrev = '') then
              Pagination := ''
            else
              Pagination := FilePagination(Start, ResultList.Count, LinkPrev, LinkNext, isAdmin);

            if ResultList.Count = 0 then
            begin
                warning := Templates[tplWarningNoFiles][isAdmin];
                warning := StringReplace(warning, '{{Value}}', aSearchString  , [rfReplaceAll]);
                PageData := StringReplace(PageData, '{{NoFilesHint}}', warning  , [rfReplaceAll]);
                PageData := StringReplace(PageData, '{{Summary}}', '', [rfReplaceAll]);
            end
            else
                PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);

            PageData := StringReplace(PageData, '{{Pagination}}', Pagination, [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{LibraryItems}}', Items, [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{SearchCount}}', IntToStr(ResultList.Count), [rfReplaceAll]);
        finally
            ResultList.Free;
        end;
    end else
    begin
        PageData := StringReplace(PageData, '{{NoFilesHint}}', '<div class="warning">Search string must not be empty.</div>', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{Pagination}}', '', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{LibraryItems}}', '', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{SearchCount}}', '0', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{Summary}}', '', [rfReplaceAll]);
    end;

    result := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLCollectionList(CollectionType: String; startLetter: String; SortAlbumsByArtist, other, isAdmin: Boolean): UTf8String;
var PageData, menu, browsemenu, pagination: String;
    Items, Item, baseLink, Link, ItemPattern: String;
    i, requestedArrIdx: Integer;
    rc: TRootCollection;
    afc: TAudioFileCollection;
    ShowAll: Boolean;
    ShowSwitchLink: Boolean;
    maxCount: Integer;
    ValidCollection: Boolean;
    Comparer: TCollectionComparer;

    afcList: TAudioFileCollectionList;

    function CalcFontSize(colCount, maxCount: Integer): Integer;
    begin
      result := round((colCount * sqrt(colCount)) / maxCount * 14) + 10;
      if result > 24 then
          result := 24;
    end;

    function CheckRange(StartIdx, EndIdx: Integer): Integer;
    var i: Integer;
    begin
      result := -1;
      for i := StartIdx to EndIdx do
        if ((CollectionType = 'artist') and  (fMainArtistCount[i] + fOtherArtistCount[i] > 0))
          or ((CollectionType = 'album') and (not SortAlbumsByArtist) and (fAlbumCount[i] > 0))
          or ((CollectionType = 'album') and (SortAlbumsByArtist) and (fAlbumCountByArtist[i] > 0))
        then begin
          result := i;
          break;
        end;
    end;

    function FirstValidArrIdx(StartIdx: Integer): Integer;
    begin
      if StartIdx <= 0 then StartIdx := 1; // Ignore "0" on the first run
      if StartIdx >= 26 then StartIdx := 1; // ignore "other" on the first run

      result := CheckRange(StartIdx, 26);
      if result = -1 then
        result := CheckRange(1, StartIdx-1);
      if result = -1 then
        result := CheckRange(0, 0);
      if result = -1 then
        result := CheckRange(27, 27);
      if result = -1 then
        result := 0;
    end;

    function FixedStartLetter(Idx: Integer): String;
    begin
      case Idx of
        0: result := '0';
        1..26: result := chr(Idx - 1 + ord('A'));
        27: result := cOtherLetters;
      else
        result := '0';
      end;
    end;

begin
    if startLetter = '' then begin
      requestedArrIdx := FirstValidArrIdx(1);
      startLetter := FixedStartLetter(requestedArrIdx);
    end
    else begin
      if startLetter = cOtherLetters then
        requestedArrIdx := 27
      else begin
        case startLetter[1] of
          '0': requestedArrIdx := 0;
          'A'..'Z': requestedArrIdx := ord(startLetter[1]) - ord('A') + 1;
        else
          requestedArrIdx := 0;
        end;
      end;

      if ((CollectionType = 'artist') and  (fMainArtistCount[requestedArrIdx] + fOtherArtistCount[requestedArrIdx] = 0))
          or ((CollectionType = 'album') and (not SortAlbumsByArtist) and (fAlbumCount[requestedArrIdx] = 0))
          or ((CollectionType = 'album') and (SortAlbumsByArtist) and (fAlbumCountByArtist[requestedArrIdx] = 0))
      then begin
        requestedArrIdx := FirstValidArrIdx(requestedArrIdx);
        startLetter := FixedStartLetter(requestedArrIdx);
      end;
    end;

    menu := MainMenu(2, isAdmin);
    browsemenu := BrowseSubMenu(CollectionType, startLetter, '', SortAlbumsByArtist, isAdmin);

    ShowAll := True;
    ShowSwitchLink := False;
    maxCount := 20;
    rc := fCollectionArtists;
    ItemPattern := Templates[tplItemBrowseArtist][isAdmin];

    if CollectionType = 'artist' then
    begin
        ItemPattern := Templates[tplItemBrowseArtist][isAdmin];
        rc := fCollectionArtists;
        ShowAll := (fMainArtistCount[requestedArrIdx] + fOtherArtistCount[requestedArrIdx] <= MergeArtistConst)
            or (fMainArtistCount[requestedArrIdx] <= 5)
            or (fOtherArtistCount[requestedArrIdx] <= 5);

        if ShowAll then begin
          maxCount := max(fMaxCountOtherArtist[requestedArrIdx], fMaxCountMainArtist[requestedArrIdx]);
        end
        else begin
          if other then begin
            ShowSwitchLink := fMainArtistCount[requestedArrIdx] > 0;
            maxCount := fMaxCountOtherArtist[requestedArrIdx];
          end
          else begin
            ShowSwitchLink := fOtherArtistCount[requestedArrIdx] > 0;
            maxCount := fMaxCountMainArtist[requestedArrIdx];
          end;
        end
    end;
    if CollectionType = 'album' then
    begin
        rc := fCollectionAlbums;
        ItemPattern := Templates[tplItemBrowseAlbum][isAdmin];
    end;
    if CollectionType = 'genre' then
    begin
        rc := fCollectionGenres;
        maxCount := fMaxCountGenre;
        ItemPattern := Templates[tplItemBrowseGenre][isAdmin];
    end;

    Items := '';

    if (CollectionType = 'album') and SortAlbumsByArtist then
      baseLink := 'library?albumsortmode=artist&mode=' + EscapeHTMLChars(CollectionType) + '&amp;l=' + EscapeHTMLChars(startLetter) + '&amp;id='
    else
      baseLink := 'library?mode=' + EscapeHTMLChars(CollectionType) + '&amp;l=' + EscapeHTMLChars(startLetter) + '&amp;id=';

    afcList := TAudioFileCollectionList.Create(False);
    try
          for i := 0 to rc.CollectionCount - 1 do
          begin
              afc := TAudioFileCollection(rc.Collection[i]);
              ValidCollection := (rc = fCollectionGenres)
                  or ((CollectionType = 'artist') and (NavigationIndex(afc.Artist) = requestedArrIdx))
                  or ((CollectionType = 'album') and (not SortAlbumsByArtist) and(NavigationIndex(afc.Album) = requestedArrIdx))
                  or ((CollectionType = 'album') and SortAlbumsByArtist and (NavigationIndex(afc.Artist) = requestedArrIdx));

              ValidCollection := ValidCollection and
                (ShowAll or (other and (afc.Count < cMinCountProperArtist))
                         or (not other and (afc.Count > cMinCountProperArtist)) );
              if ValidCollection then
                afcList.Add(afc);
          end;

          if rc = fCollectionAlbums then begin
            if SortAlbumsByArtist then
              Comparer := CompareCollection_Artist
            else
              Comparer := CompareCollection_Album;

            afcList.Sort (TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                    begin
                      result := Comparer(item1, item2);
                    end));
          end;

          for i := 0 to afcList.Count - 1 do begin
              afc := afcList[i];
              Item := ItemPattern;
              Link := baseLink + ParamsEncode(UTF8String(afc.WebServerID.toString));
              Item := StringReplace(Item, '{{Link}}'   , Link, [rfReplaceAll]);
              Item := StringReplace(Item, '{{FontIdx}}'   , IntToStr( CalcFontSize(afc.Count, maxCount)), [rfReplaceAll]);
              Item := StringReplace(Item, '{{Artist}}'  , EscapeHTMLChars(afc.Artist), [rfReplaceAll]);
              Item := StringReplace(Item, '{{Album}}'  , EscapeHTMLChars(afc.Album), [rfReplaceAll]);
              Item := StringReplace(Item, '{{Genre}}'  , EscapeHTMLChars(afc.Genre), [rfReplaceAll]);
              if afc.Year >= 0 then
                Item := StringReplace(Item, '{{Year}}', EscapeHTMLChars(afc.Year.ToString) , [rfReplaceAll])
              else
                Item := StringReplace(Item, '{{Year}}', '- ? -' , [rfReplaceAll]);

              Item := StringReplace(Item, '{{Count}}'  , IntToStr(afc.Count), [rfReplaceAll]);
              Item := StringReplace(Item, '{{CoverID}}', EscapeHTMLChars(afc.CoverID), [rfReplaceAll]);
              Item := StringReplace(Item, '{{Duration}}'  , SekIntToMinStr(afc.Duration), [rfReplaceAll]);
              Items := Items + Item;
          end;
    finally
      afcList.Free;
    end;

    PageData := Templates[tplPageLibrary][isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{MenuLibrary}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{Summary}}', ''  , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{ClassLibrary}}', CollectionType, [rfReplaceAll]);

    if CollectionType='artist' then begin
      if ShowSwitchLink then begin
        if Other then
          pagination := ArtistNavigation(startLetter, 'library?mode=' + ParamsEncode(UTF8String(CollectionType)) + '&amp;l=' + ParamsEncode(UTF8String(startLetter)) + '&amp;other=0', '', isAdmin)
        else
          pagination := ArtistNavigation(startLetter, '', 'library?mode=' + ParamsEncode(UTF8String(CollectionType)) + '&amp;l=' + ParamsEncode(UTF8String(startLetter)) + '&amp;other=1', isAdmin);
      end else
          pagination := '';

      PageData := StringReplace(PageData, '{{Pagination}}', pagination, [rfReplaceAll]);
    end
    else
        PageData := StringReplace(PageData, '{{Pagination}}', '', [rfReplaceAll]);

    PageData := StringReplace(PageData, '{{LibraryItems}}', Items, [rfReplaceAll]);
    result := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;

function TNempWebServer.GenerateHTMLFileList(CollectionType: String; CollectionID: String; startLetter: String;
    Start: Integer; SortAlbumsByArtist, isAdmin: Boolean): UTf8String;
var PageData, menu, browsemenu: String;
    Items, warning: String;
    Pagination, LinkPrev, LinkNext, Summary: String;
    i,  maxIdx: Integer;
    ResultList: TAudioFileList;
    rc: TRootCollection;
    afc: TAudioFileCollection;
    requestedCollectionID: Integer;

    procedure AddItem(afile: TAudioFile);
    var
      aClass, Item: String;
    begin
      EnsureFileHasID(afile);
      Item := Templates[tplItemFileLibrary][isAdmin];
      Item := StringReplace(Item, '{{ID}}'  , IntToStr(afile.WebServerID), [rfReplaceAll]);
      aClass := '';
      // replace tags
      Item := fSetBasicFileData(afile, Item, aClass);
      Item := fSetFileButtons(afile, Item, 2, isAdmin);
      Items := Items + Item;
    end;

begin
    rc := Nil;
    Summary := Templates[tplSummaryArtist][isAdmin];
    if CollectionType='artist' then begin
      Summary := Templates[tplSummaryArtist][isAdmin];
      rc := self.fCollectionArtists;
    end else
      if CollectionType='album' then begin
        Summary := Templates[tplSummaryAlbum][isAdmin];
        rc := self.fCollectionAlbums;
      end else
        if CollectionType='genre' then begin
          Summary := Templates[tplSummaryGenre][isAdmin];
          rc := self.fCollectionGenres;
        end;

    menu := MainMenu(2, isAdmin);
    browsemenu := BrowseSubMenu(CollectionType, startLetter, CollectionID, SortAlbumsByArtist, isAdmin);

    PageData := Templates[tplPageLibrary][isAdmin];
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{MenuLibrary}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{ClassLibrary}}', CollectionType, [rfReplaceAll]);

    Items := '';

    EnterCriticalSection(CS_AccessLibrary);

    ResultList := TAudioFileList.Create(False);
    try
      if assigned(rc) then begin
        requestedCollectionID := StrToIntDef(CollectionID, -1);

        for i := 0 to rc.CollectionCount - 1 do
          if rc.Collection[i].WebServerID = requestedCollectionID then begin
            /// Generate Summary here
            afc := TAudioFileCollection(rc.Collection[i]);
            Summary := StringReplace(Summary, '{{Album}}', EscapeHTMLChars(afc.Album) , [rfReplaceAll]);
            Summary := StringReplace(Summary, '{{Artist}}', EscapeHTMLChars(afc.Artist) , [rfReplaceAll]);
            Summary := StringReplace(Summary, '{{CoverID}}', EscapeHTMLChars(afc.CoverID) , [rfReplaceAll]);

            Summary := StringReplace(Summary, '{{Genre}}', EscapeHTMLChars(afc.Genre) , [rfReplaceAll]);
            if afc.Year >= 0 then
              Summary := StringReplace(Summary, '{{Year}}', EscapeHTMLChars(afc.Year.ToString) , [rfReplaceAll])
            else
              Summary := StringReplace(Summary, '{{Year}}', '- ? -' , [rfReplaceAll]);

            Summary := StringReplace(Summary, '{{Count}}', EscapeHTMLChars(afc.Count.ToString) , [rfReplaceAll]);
            Summary := StringReplace(Summary, '{{Duration}}', EscapeHTMLChars(SekToZeitString(afc.Duration)) , [rfReplaceAll]);

            if CollectionType='artist' then
              Summary := StringReplace(Summary, '{{AlbumCount}}', EscapeHTMLChars(afc.CollectionCount.ToString) , [rfReplaceAll])
            else
              Summary := StringReplace(Summary, '{{AlbumCount}}', '' , [rfReplaceAll]);

            if CollectionType='genre' then
              Summary := StringReplace(Summary, '{{ArtistCount}}', EscapeHTMLChars(afc.CollectionCount.ToString) , [rfReplaceAll])
            else
              Summary := StringReplace(Summary, '{{ArtistCount}}', '' , [rfReplaceAll]);

            PageData := StringReplace(PageData, '{{Summary}}', Summary  , [rfReplaceAll]);

            rc.Collection[i].GetFiles(ResultList, True);
            break;
          end;
      end;

      if Start < 0 then
        Start := 0;

      maxIdx := Start + MaxCountPerPage - 1;
      if maxIdx > (ResultList.Count - 1) then
          maxIdx := ResultList.Count - 1;

      for i := Start to maxIdx do
        AddItem(ResultList[i]);

      // Build Pagination
      LinkPrev := '';
      LinkNext := '';
      if (Start > 0) then
        LinkPrev := 'library?start=' + IntToStr(start-MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(CollectionType)) + '&amp;id=' + ParamsEncode(UTF8String(CollectionID));
      if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
        LinkNext := 'library?start=' + IntToStr(start+MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(CollectionType)) + '&amp;id=' + ParamsEncode(UTF8String(CollectionID));
      if (LinkNext = '') and (LinkPrev = '') then
        Pagination := ''
      else
        Pagination := FilePagination(Start, ResultList.Count, LinkPrev, LinkNext, isAdmin);

      if ResultList.Count = 0 then begin
        warning := Templates[tplWarningNoFiles][isAdmin];
        warning := StringReplace(warning, '{{Value}}', CollectionID  , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{NoFilesHint}}', warning  , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{Summary}}', ''  , [rfReplaceAll]);
      end
      else
        PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);

    finally
        ResultList.Free;
        LeaveCriticalSection(CS_AccessLibrary);
    end;

    PageData := StringReplace(PageData, '{{Pagination}}', Pagination, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{LibraryItems}}', Items, [rfReplaceAll]);
    result := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLFileDetailsLibrary(aAudioFile: TAudioFile; isAdmin: Boolean): UTf8String;
var PageData, FileData, menu: String;
begin
    menu := MainMenu(2, isAdmin);

    if assigned(aAudioFile) then
    begin
        aAudioFile.FileIsPresent := (not aAudioFile.IsFile) or FileExists(aAudioFile.Pfad);

        FileData := Templates[tplItemFileLibraryDetails][isAdmin];
        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1, isAdmin);

        PageData := Templates[tplPageLibraryDetails][isAdmin];
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemLibraryDetails}}', FileData, [rfReplaceAll]);
    end
    else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 2, isAdmin);

    result := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
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
    PrepareCollections;
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

    if trim(Keyword) = '*' then begin
      for i := 0 to fWebMedienBib.Count - 1 do
        DestList.Add(fWebMedienBib[i]);
    end else begin
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
    end;
    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.LoadTemplates(isAdmin: Boolean);
var
  iTpl: teTemplates;
begin
    if isAdmin then
      fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\' + Theme + '\Admin\'
    else
      fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\' + Theme + '\';

    // fDefaultCoverFilename
    if FileExists(fLocalDir + 'default_cover.jpg') then
      fDefaultCoverFilename := fLocalDir + 'default_cover.jpg'
    else
      if FileExists(fLocalDir + 'default_cover.png') then
        fDefaultCoverFilename := fLocalDir + 'default_cover.png';

    for iTpl := low(teTemplates) to High(teTemplates) do begin
      if FileExists(fLocalDir + cTemplateFilenames[iTpl]) then
        Templates[iTpl][isAdmin] := TFile.ReadAllText(fLocalDir + cTemplateFilenames[iTpl], TEncoding.UTF8)
      else
        Templates[iTpl][isAdmin] := '';
    end;
end;

procedure TNempWebServer.TemplateFallback;
var
  iTpl: teTemplates;
begin
  for iTpl := low(teTemplates) to High(teTemplates) do
    if Templates[iTpl][True] = '' then
      Templates[iTpl][True] := Templates[iTpl][False];
end;

function TNempWebServer.NavigationIndex(s: String): Integer;
var
  c: Char;
begin
  if s = '' then
    result := 27
  else
  begin
    c := AnsiUpperCase(s)[1];
    case c of
      '0'..'9': result := 0;
      'A'..'Z': result := ord(c) - ord('A') + 1;
      'Ä': result := ord('A') - ord('A') + 1;
      'Ö': result := ord('O') - ord('A') + 1;
      'Ü': result := ord('U') - ord('A') + 1;
    else
      result := 27;
    end;
  end;
end;

procedure TNempWebServer.PrepareCollections;
var
  i: Integer;
  arrIdx: Integer;
begin
  fCollectionAlbums.Clear;
  fCollectionArtists.Clear;
  fCollectionGenres.Clear;

  for i := 0 to fWebMedienBib.Count - 1 do begin
    fCollectionAlbums.AddAudioFile(fWebMedienBib[i]);
    fCollectionArtists.AddAudioFile(fWebMedienBib[i]);
    fCollectionGenres.AddAudioFile(fWebMedienBib[i]);
  end;
  fCollectionAlbums.Analyse(True, True);
  fCollectionArtists.Analyse(True, True);
  fCollectionGenres.Analyse(True, True);

  fCollectionAlbums.Sort(True);
  fCollectionArtists.Sort(True);
  fCollectionGenres.Sort(True);

  // count collections staring with letter 0-9, A-Z, other
  for i := 0 to 27 do begin
    fMainArtistCount[i] := 0;
    fOtherArtistCount[i] := 0;
    fAlbumCount[i] := 0;
    fAlbumCountByArtist[i] := 0;

    fMaxCountMainArtist[i] := 20;
    fMaxCountOtherArtist[i] := 20;
  end;
  fMaxCountGenre := 20;

  for i := 0 to fCollectionAlbums.CollectionCount - 1 do begin
    fCollectionAlbums.Collection[i].WebServerID := 1000 + i;

    if fCollectionAlbums.Collection[i].Count >= cMinCountProperAlbum then begin
      arrIdx := NavigationIndex(TAudioFileCollection(fCollectionAlbums.Collection[i]).Album);
      inc(fAlbumCount[arriDX]);

      arrIdx := NavigationIndex(TAudioFileCollection(fCollectionAlbums.Collection[i]).Artist);
      inc(fAlbumCountByArtist[arriDX]);
    end;
  end;

  for i := 0 to fCollectionArtists.CollectionCount - 1 do begin
    fCollectionArtists.Collection[i].WebServerID := 1000 + i;
    arrIdx := NavigationIndex(TAudioFileCollection(fCollectionArtists.Collection[i]).Artist);

    if fCollectionArtists.Collection[i].Count >= cMinCountProperArtist then begin
      inc(fMainArtistCount[arrIdx]);
      if fCollectionArtists.Collection[i].Count > fMaxCountMainArtist[arrIdx] then
        fMaxCountMainArtist[arrIdx] := fCollectionArtists.Collection[i].Count;
    end
    else begin
      inc(fOtherArtistCount[arrIdx]);
      if fCollectionArtists.Collection[i].Count > fMaxCountOtherArtist[arrIdx] then
        fMaxCountOtherArtist[arrIdx] := fCollectionArtists.Collection[i].Count;
    end;
  end;

  for i := 0 to fCollectionGenres.CollectionCount - 1 do begin
    fCollectionGenres.Collection[i].WebServerID := 1000 + i;
    if fCollectionGenres.Collection[i].Count > fMaxCountGenre then
      fMaxCountGenre:= fCollectionGenres.Collection[i].Count;
  end;

  for i := 0 to 27 do begin
    if fMaxCountMainArtist[i] > 250 then
      fMaxCountMainArtist[i] := 250;
    if fMaxCountOtherArtist[i] > 250 then
      fMaxCountOtherArtist[i] := 250;
  end;
  if fMaxCountGenre > 250 then
    fMaxCountGenre := 250;
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
    dest.Clear;
    if (FindFirst(ExtractFilePath(Paramstr(0)) + 'HTML\' + '*', faDirectory, SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and (not AnsiSameText(SR.Name, 'Common')) and ((SR.Attr AND faDirectory)= faDirectory) then
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

function TNempWebServer.CreateStream(aContent: UTF8String): TMemoryStream;
begin
  if aContent = '' then aContent := ' ';
  result := TMemoryStream.Create;
  result.Write(aContent[1], length(aContent));
end;



function TNempWebServer.HandleError(AResponseInfo: TIdHTTPResponseInfo;
      Error: TQueryResult; isAdmin: Boolean): TQueryResult;
var ErrorMessage, PageData: String;
    Body: UTF8String;
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
    Body := UTF8String(StringReplace(Templates[tplBody][isAdmin], '{{Content}}', PageData, [rfReplaceAll]));
    AResponseInfo.ResponseNo := ResponseCodes[Error];
    AResponseInfo.ContentType := 'text/html';
    AResponseInfo.ContentStream := CreateStream(Body);
    result := Error;
end;

function TNempWebServer.HandleErrorJS(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult; isAdmin: Boolean): TQueryResult;
var
  ErrorMessage: String;
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
  AResponseInfo.ResponseNo := ResponseCodes[Error];
  AResponseInfo.ContentType := 'text/html';
  AResponseInfo.ContentStream := CreateStream(UTF8String(ErrorMessage));
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
var
  html: UTf8String;
begin
  AResponseInfo.ContentType := 'text/html; charset=utf-8';
  EnterCriticalSection(CS_AccessHTMLCode);
      if isAdmin then
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerAdmin, 0)
      else
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayer, 0);
      html := HTML_Player;
  LeaveCriticalSection(CS_AccessHTMLCode);

  AddNoCacheHeader(AResponseInfo);
  AResponseInfo.ContentStream := CreateStream(html);
  result := qrPermit;
end;

function TNempWebServer.ResponsePlayerJS(ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var
  html: UTf8String;
  queriedData: String;
  aProgress, aVolume: Integer;
begin
        AResponseInfo.ContentType := 'text/html; charset=utf-8';
        queriedData := aRequestInfo.Params.Values['data'];
        if queriedData = 'progress' then
        begin
            aProgress := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETPROGRESS, 0);
            AResponseInfo.ContentStream := CreateStream(UTF8String(aProgress.ToString));
        end else
        if queriedData = 'volume' then
        begin
            aVolume := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETVOLUME, 0);
            AResponseInfo.ContentStream := CreateStream(UTF8String(aVolume.ToString));
        end
        else
        begin
          EnterCriticalSection(CS_AccessHTMLCode);
              if isAdmin then
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerJSAdmin, 0)
              else
                SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerJS, 0);

              html := HTML_Player;
          LeaveCriticalSection(CS_AccessHTMLCode);

          if html = '' then begin
            html := ' ';
            AResponseInfo.ResponseNo := ResponseCodes[qrFileNotFound];
          end;
          AResponseInfo.ContentStream := CreateStream(html);
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
      if queriedAction = 'playpause' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PLAY, WM_WebServer)
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
    ActionExecuted: Boolean;
begin
  AResponseInfo.ContentType := 'text/html; charset=utf-8';
  queriedAction := aRequestInfo.Params.Values['action'];

  if AllowRemoteControl or isAdmin then
  begin
      ActionExecuted := True; // think positive
      if queriedAction = 'stop' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_STOP, 0)
      else
      if queriedAction = 'playpause' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PLAY, WM_WebServer)
      else
      if queriedAction = 'next' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_NEXTTITLE, 0)
      else
      if queriedAction = 'previous' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PREVTITLE, 0)
      else
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
      end
      else begin
        // error, unknown queriedAction
        ActionExecuted := False;
        HandleErrorJS(AResponseInfo, qrInvalidParameter, isAdmin)
      end;

      if ActionExecuted then
        // Response after a successful action: the contenet of "PagePlayer.tpl".
        // If an additional parameter "data" is set to "volume" or "progress", only the value for this data is returned.
        result := ResponsePlayerJS(ARequestInfo, AResponseInfo, isAdmin)
      else
        result := qrInvalidParameter
  end else begin
      // RemoteControl is not allowed, reply with an error
      result := qrRemoteControlDenied;
      HandleErrorJS(AResponseInfo, qrRemoteControlDenied, isAdmin)
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

function TNempWebServer.ResponseJSPlaylistControl (AContext: TIdContext;
    ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var queriedAction: String;
    queriedID, res, newPlayingID: Integer;
    af: TAudioFile;
    localVote, localControl, requestDone: Boolean;

    function Addnext(aAction: String; out PlayingID: Integer; doPlay: Boolean=False): TQueryResult;
    begin
        EnterCriticalSection(CS_AccessLibrary);
            result := qrPermit;
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then begin
              // sende Audiofile an Nemp-Hauptfenster/playlist
              if (aAction = 'file_addnext') then
                PlayingID := SendMessage(fMainWindowHandle, WM_WebServer, WS_InsertNext, LParam(af))
              else
                PlayingID := SendMessage(fMainWindowHandle, WM_WebServer, WS_AddToPlaylist, LParam(af));
              if DoPlay then
                SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, PlayingID);
            end
            else begin
              PlayingID := 0;
              result := qrInvalidParameter;
            end;
        LeaveCriticalSection(CS_AccessLibrary);
    end;

    function MessageResultToStream(res: Integer): TMemoryStream;
    begin
      case res of
        1: result := CreateStream('ok');
        2: result := CreateStream('prebook');
        3: result := CreateStream('denied');
      else
        result := CreateStream('error');
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
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);

        if (queriedAction = 'file_playnow') and localControl then
        begin
            requestDone := True;
            newPlayingID := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID);
            if newPlayingID = 0 then
              result := Addnext('file_addnext', newPlayingID, True);
            AResponseInfo.ContentStream := CreateStream(UTF8String(newPlayingID.toString));
        end;

        if (queriedAction = 'file_vote') and localVote then
        begin
            requestDone := True;
            case Votemachine.ProcessVote(queriedID, AContext.Binding.PeerIP) of
                vr_Success   : AResponseInfo.ContentStream := CreateStream(UTF8String('ok'));
                vr_TotalVotesExceeded : AResponseInfo.ContentStream := CreateStream(UTF8String('spam'));
                vr_FileVotesExceeded  : AResponseInfo.ContentStream := CreateStream(UTF8String('already voted'));
                vr_Exception : AResponseInfo.ContentStream := CreateStream(UTF8String('exception'));
            end;
        end;

        if (queriedAction = 'file_moveup') and localControl then
        begin
            requestDone := True;
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveUp, queriedID);
            AResponseInfo.ContentStream := MessageResultToStream(res);
        end;

        if (queriedAction = 'file_movedown') and localControl then
        begin
            requestDone := True;
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveDown, queriedID);
            AResponseInfo.ContentStream := MessageResultToStream(res);
        end;

        if (queriedAction = 'file_delete') and localControl then
        begin
            requestDone := True;
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID);
            AResponseInfo.ContentStream := MessageResultToStream(res);
        end;

        if ((queriedAction = 'file_addnext') or (queriedAction = 'file_add')) and localControl then begin
          requestDone := True;
          if addNext(queriedAction, newPlayingID, False) = qrPermit then
            AResponseInfo.ContentStream := CreateStream('ok')
          else
            AResponseInfo.ContentStream := CreateStream('error')
        end;

        if not requestDone then
            result := HandleErrorJS(AResponseInfo, qrRemoteControlDenied, isAdmin)
    end
    else begin
        result := HandleErrorJS(AResponseInfo, qrRemoteControlDenied, isAdmin)
    end;
end;

function TNempWebServer.ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; Completepage: Boolean; isAdmin: Boolean): TQueryResult;
var
  html: UTf8String;
begin
  AResponseInfo.ContentType := 'text/html; charset=utf-8';
  EnterCriticalSection(CS_AccessHTMLCode);
      // call GenerateHTMLfromPlaylist in Main Thread
      if isAdmin then begin
        if CompletePage then
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistAdmin, 0)
        else
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistJSAdmin, 0)
      end
      else begin
        if CompletePage then
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylist, 0)
        else
          SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistJS, 0)
      end;
      html := HTML_PlaylistView;
  LeaveCriticalSection(CS_AccessHTMLCode);

  if html = '' then begin
    // some error occured (JS only)
    AResponseInfo.ResponseNo := ResponseCodes[qrFileNotFound];
  end;

  AddNoCacheHeader(AResponseInfo);
  AResponseInfo.ContentStream := CreateStream(html);
  result := qrPermit;
end;


function TNempWebServer.ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var
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

  if html <> '' then begin
    AddNoCacheHeader(AResponseInfo);
    AResponseInfo.ContentStream := CreateStream(html);
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
        fn := fDefaultCoverFilename;

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
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean; HtmlAudio: Boolean): TQueryResult;
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
                    if HtmlAudio then begin
                      AResponseInfo.CustomHeaders.Add(('Connection: keep-alive; '));  // for streaming
                      AResponseInfo.CustomHeaders.Add(('Accept-Ranges: bytes; '));  // for streaming
                    end;

                    AResponseInfo.ContentType := FileType2MimeType(fn, 'audio/unknown');
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
var
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
        if i > 0 then begin
          // UnparsedParams sollte nur Ascii-Zeichen anthalten - also ist das ok
          a := AnsiString(copy(ARequestInfo.UnparsedParams, i+6, length(ARequestInfo.UnparsedParams) - i));
          // die Parameter sind utf-kodiert als %12%43%82%20 ...
          // also: Die %xx in UTF8String dekodieren, das Ergebnis zu UnicodeString
          SearchString := Utf8ToString(utf8URLDecode(a));
        end else
          SearchString := '';

        html := GenerateHTMLFileList(searchstring, Start, isAdmin);
        // NOT necessary here AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := CreateStream(html);
        result := qrPermit;
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied, isAdmin);
end;

function TNempWebServer.ResponseBrowseInLibrary (ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo; isAdmin: Boolean): TQueryResult;
var QueryMode, QueryLetter, QueryID, QueryOther, QueryAlbumSortMode: String;
    html: UTf8String;
    Start: Integer;
begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowLibraryAccess or isAdmin then
    begin
        Start       := StrToIntDef(aRequestInfo.Params.Values['start'], 0);
        QueryMode   := aRequestInfo.Params.Values['mode'];
        QueryLetter := aRequestInfo.Params.Values['l'];
        QueryID     := aRequestInfo.Params.Values['id'];
        if length(QueryLetter) = 1 then
          QueryLetter := AnsiUpperCase(QueryLetter);

        (*i := pos('value=', ARequestInfo.UnparsedParams);
        if i > 0 then
        begin
            // UnparsedParams sollte nur Ascii-Zeichen anthalten - also ist das ok
            a := AnsiString(copy(ARequestInfo.UnparsedParams, i+6, length(ARequestInfo.UnparsedParams) - i));
            // die Parameter sind utf-kodiert als %12%43%82%20 ...
            // also: Die %xx in UTF8String dekodieren, das Ergebnis zu UnicodeString
            QueryValue := Utf8ToString(utf8URLDecode(a));
        end else
            QueryValue := '';
        *)

        QueryOther  := aRequestInfo.Params.Values['other'];
        QueryAlbumSortMode := aRequestInfo.Params.Values['albumsortmode'];

        if QueryID = '' then
        begin
            if QueryLetter = '' then
                QueryLetter := 'A';
            // generate List of Artists/Albums/Genres according to QueryMode (+ Letter)
            html := GenerateHTMLCollectionList(Querymode, QueryLetter, QueryAlbumSortMode='artist', QueryOther='1', isAdmin);
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := CreateStream(html);
            result := qrPermit;
        end else
        begin
            // generate List of Titles according to QueryMode + Value
            if QueryLetter = '' then
              QueryLetter := ' ';
            html := GenerateHTMLFileList(Querymode, QueryID, QueryLetter, Start, QueryAlbumSortMode='artist', isAdmin);
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := CreateStream(html);
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
begin
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    if AllowLibraryAccess or isAdmin then
    begin
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        // Ja, doppelt eintreten hält besser! Nach dem Verlassen von getAudioFilefromLib könnte sonst die Liste geleert werden!!
        EnterCriticalSection(CS_AccessLibrary);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then begin
              html := GenerateHTMLFileDetailsLibrary(af, isAdmin);
              // NOT necessary here AddNoCacheHeader(AResponseInfo);
              AResponseInfo.ContentStream := CreateStream(html);
              result := qrPermit;
            end else // not in bib
              result := HandleError(AResponseInfo, qrInvalidParameter, isAdmin);
        LeaveCriticalSection(CS_AccessLibrary);
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied, isAdmin);
end;

procedure TNempWebServer.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  RequestedDocument: String;
  permit: TQueryResult;
  fn, basename: UnicodeString;
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
        if RequestedDocument = '/playerJS' then begin
          permit := ResponsePlayerJS(ARequestInfo, AResponseInfo, isAdmin);
          DoLog := aRequestInfo.Params.Values['data'] = '';
        end
        else
        if RequestedDocument = '/playlist' then permit := ResponsePlaylistView(ARequestInfo, AResponseInfo, True, isAdmin)
        else
        if RequestedDocument = '/playlistJS' then permit := ResponsePlaylistView(ARequestInfo, AResponseInfo, False, isAdmin)
        else
        if RequestedDocument = '/search' then permit := ResponseSearchInLibrary(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/library' then permit := ResponseBrowseInLibrary(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/cover' then permit := ResponseCover(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playercontrol' then permit := ResponseClassicPlayerControl(ARequestInfo, AResponseInfo, isAdmin)
        else
        if RequestedDocument = '/playercontrolJS' then permit := ResponseJSPlayerControl(ARequestInfo, AResponseInfo, isAdmin)
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
            queriedAction := ARequestInfo.Params.Values['action'];

            // '' dürfte am häufigsten vorkommen (css, bilder, ...)
            if queriedAction = '' then
            begin
                basename := StringReplace(RequestedDocument, '/', '\', [rfReplaceAll]);
                fn := fLocalDir + basename;
                if not FileExists(fn) then
                  fn := fCommonDir + basename;

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
                  permit := ResponseFileDownload(ARequestInfo, AResponseInfo, isAdmin, False)
                else
                  if queriedAction = 'file_stream' then
                    permit := ResponseFileDownload(ARequestInfo, AResponseInfo, isAdmin, True)
                  else begin
                    // permit := qrDeny;
                    permit := HandleError(AResponseInfo, qrError, isAdmin);
                  end;
        end;
    end else begin
        permit := HandleError(AResponseInfo, qrError, False);
    end;

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