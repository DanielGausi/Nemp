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
    Copyright (C) 2005-2010, Daniel Gaussmann
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
  MP3FileUtils, AudioFileClass, Hilfsfunktionen, HtmlHelper,
  Playlistclass, PlayerClass, Nemp_ConstantsAndTypes,
  MedienbibliothekClass, BibSearchClass, Votings;

const
    // Messages für WebServer:
    WM_WebServer = WM_USER + 800;

    WS_QueryPlayer = 10;
    WS_QueryPlayerJS = 11;
    WS_QueryPlaylist = 1;
    WS_QueryPlaylistDetail = 2;

    WS_PlaylistPlayID = 3;

    WS_InsertNext = 4;
    WS_AddToPlaylist = 5;

    WS_PlaylistMoveUp = 7;
    WS_PlaylistMoveUpCheck = 17;
    WS_PlaylistMoveDown = 8;
    WS_PlaylistMoveDownCheck  = 18;

    WS_QueryPlaylistItem = 20;

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




type
  TQueryResult = (qrPermit, qrDeny, qrRemoteControlDenied,
                  qrDownloadDenied, qrLibraryAccessDenied,
                  qrFileNotFound, qrInvalidParameter, qrError);

  type TCountedString = class
      private
          fValue: String;
          fCount: Integer;
          fCoverID: String;
          fFontSize: Integer;
      public
          property Value: String read fValue;
          property Count: Integer read fCount;
          property CoverID: String read fCoverID;
          property FontSize: Integer read fFontSize;
          constructor Create(aValue: String; c: Integer; aCoverID: String);
  end;


  TNempWebServer = class
      private
          fMainHandle: DWord;
          fMainWindowHandle: DWord; // Eventually we need 2 handles - Options and mainwindow

          fCurrentMaxID: Integer;

          fWebMedienBib: TObjectlist;

          fHTML_Player: UTf8String;
          fHTML_PlaylistView: Utf8String;
          fHTML_PlaylistDetails: UTf8String;
          fQueriedPlaylistFilename: UnicodeString;

          fHTML_MedienbibSearchForPlay: UTf8String;

          fUsername: String;
          fPassword: String;
          fRootDir : String;

          fOnlyLAN               : Longbool;
          fAllowPlaylistDownload : Longbool;
          fAllowLibraryAccess    : Longbool;
          fAllowRemoteControl    : Longbool;
          fPort                  : Word;

          // VCL-Variable
          fActive: Boolean;

          IdHTTPServer1: TIdHTTPServer;
          fLocalFormatSettings: TFormatSettings;
          fLocalDir: UnicodeString;
          fLastErrorString: String;

          PatternBody: String;
          // Buttons for Player Control
          PatternPlayerControls: String;
          PatternButtonNext : String;
          // PatternButtonPlayPause : String;
          PatternButtonPause : String;
          PatternButtonPlay : String;
          PatternButtonPrev : String;
          PatternButtonStop : String;
          // Buttons for Files
          PatternButtonFileDownload : String;
          PatternButtonFileMoveUp   : String;
          PatternButtonFileMoveDown : String;
          PatternButtonFileDelete   : String;
          PatternButtonFilePlayNow  : String;
          PatternButtonFileAdd      : String;
          PatternButtonFileAddnext  : String;
          PatternButtonFileVote     : String;

          PatternButtonSuccess      : String;
          PatternButtonFail         : String;


          PatternMenu : String;
          PatternBrowseMenu : String;
          PatternPagination : String;
          PatternPaginationNext : String;
          PatternPaginationPrev : String;
          PatternPaginationOther: String;
          PatternPaginationMain: String;


          PatternPlayerPage: String;
          PatternItemPlayer: String;   // the item on the PLAYER page

          PatternPlaylistPage: String;
          PatternItemPlaylist: String;  // one item on the PLAYLIST page

          PatternPlaylistDetailsPage : String;
          PatternItemPlaylistDetails : String; // the item on the Detail-Page

          PatternSearchPage: String;
          PatternSearchResultPage: String;
          PatternItemSearchlist: String;  // one item on the SEARCHLIST page

          PatternSearchDetailsPage : String;
          PatternItemBrowseArtist  : String;
          PatternItemBrowseAlbum   : String;
          PatternItemBrowseGenre   : String;


          PatternItemSearchDetails : String; // the item on the Search-Detail-Page

          PatternNoFilesHint: String;
          PatternErrorPage: String;

          // Lists for Browsing in the Library
          MainArtists  : Array [0..26] of TObjectList;
          OtherArtists : Array [0..27] of TObjectList;
          Albums       : Array [0..27] of TObjectList;
          Genres       : TObjectList;


          function fGetUsername: String;
          procedure fSetUsername(Value: String);
          function fGetPassword: String;
          procedure fSetPassword(Value: String);

          function fGetRootDir: String;
          procedure fSetRootDir(Value: String);

          procedure fSetOnlyLAN              (Value: Longbool);
          procedure fSetAllowPlaylistDownload(Value: Longbool);
          procedure fSetAllowLibraryAccess   (Value: Longbool);
          procedure fSetAllowRemoteControl   (Value: Longbool);

          function fGetOnlyLAN              : Longbool;
          function fGetAllowPlaylistDownload: Longbool;
          function fGetAllowLibraryAccess   : Longbool;
          function fGetAllowRemoteControl   : Longbool;

          function MainMenu(aPage: Integer = -1): String;
          function BrowseSubMenu(aMode: String; aLetter: Char; aValue: String): String;

          function fGetCount: Integer;

          // replace basic Insert-tags like {{artist}} in a given pattern
          function fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
          // replace InsertTags for Buttons
          function fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer): String;

          function fSetControlButtons(aPattern: String; isPlaying: Boolean): String;

          // The following methods have been methods of a WebServerForm-Class
          // ---->
          procedure logQuery(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; Permit: TQueryResult);
          procedure logQueryAuth(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo);

          function HandleError(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult): TQueryResult;
          function GenerateErrorPage(aErrorMessage: String; aPage: Integer): String;

          procedure AddNoCacheHeader(AResponseInfo: TIdHTTPResponseInfo);
          function ResponsePlayer (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponsePlayerJS (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseJSPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponseClassicPlaylistControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseCover (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponseJSPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponseSearchInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseBrowseInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseLibraryDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          procedure IdHTTPServer1CommandGet(AContext: TIdContext;
              ARequestInfo: TIdHTTPRequestInfo;
              AResponseInfo: TIdHTTPResponseInfo);

          // ---->

          procedure SetActive(Value: Boolean);
          procedure LoadTemplates;

          procedure SetFontSizes(aList: TObjectList);
          procedure ClearHelperLists;
          procedure PrepareArtists;
          procedure PrepareAlbums;
          procedure PrepareGenres;


      public
          SavePath: UnicodeString;
          CoverSavePath: UnicodeString;

          // Loglist logs all access to Webserver.
          // Note: Access this list only from VCL-Thread!
          //       IDhttpServer will add strings via SendMessage.
          LogList: TStringList;

          VoteMachine: TVoteMachine;


          property Username: string read fGetUsername write fSetUsername;
          property Password: string read fGetPassword write fSetPassword;
          property RootDir : String read fGetRootDir  write fSetRootDir;
          property OnlyLAN               : Longbool read fGetOnlyLAN               write fSetOnlyLAN              ;
          property AllowFileDownload     : Longbool read fGetAllowPlaylistDownload write fSetAllowPlaylistDownload;
          property AllowLibraryAccess    : Longbool read fGetAllowLibraryAccess    write fSetAllowLibraryAccess   ;
          property AllowRemoteControl    : Longbool read fGetAllowRemoteControl    write fSetAllowRemoteControl   ;

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
          procedure LoadfromIni;
          procedure SaveToIni;

          procedure GetThemes(out Themes: TStrings);

          // Im VCL-Thread ausführen, mit CS geschützt
          // d.h. Message an Form Senden, die das dann ausführt

          function ValidIP(aIP, bIP: String): Boolean;

          procedure GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; aPart: Integer=0);
          procedure GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist);
          procedure GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer);

          function GenerateHTMLfromPlaylistItem(aNempPlayList: TNempPlaylist; aIdx: Integer): String;

          // Das kann im Indy-Thread geamcht werden, daher mit Result
          function GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString; Start: Integer): UTf8String;
          function GenerateHTMLfromMedienbibSearch_Details(aAudioFile: TAudioFile): UTf8String;

          function GenerateHTMLMedienbibBrowseList(aMode: String; aChar: Char; other: Boolean): UTf8String;
          function GenerateHTMLMedienbibBrowseResult(aMode: String; aValue: String; Start: Integer): UTf8String;

          procedure Shutdown;
          procedure CopyLibrary(OriginalLib: TMedienBibliothek);

          procedure SearchLibrary(Keyword: UnicodeString; DestList: TObjectlist);
          function GetAudioFileFromWebServerID(aID: Integer): TAudioFile;

          procedure EnsureFileHasID(af: tAudioFile);

  end;

var
    CS_AccessHTMLCode: RTL_CRITICAL_SECTION;
    CS_AccessPlaylistFilename: RTL_CRITICAL_SECTION;
    CS_AccessLibrary: RTL_CRITICAL_SECTION;
    CS_Authentification: RTL_CRITICAL_SECTION;

const
    GoodArtist = 5;
    GoodAlbum  = 3;
    MaxCountPerPage = 100;

implementation

uses Nemp_RessourceStrings, AudioFileHelper;


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

    fFontSize := 10;
end;


constructor TNempWebServer.Create(aHandle: DWord);
var i: Integer;
begin
    inherited create;
    fMainHandle := aHandle;
    fMainWindowHandle := aHandle;
    fCurrentMaxID  := 1;
    Active := False;
    fWebMedienBib := TObjectlist.Create(False);
    IdHTTPServer1 := TIdHTTPServer.Create(Nil);
    IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;

    GetLocaleFormatSettings(LOCALE_USER_DEFAULT, fLocalFormatSettings);
    Username := 'admin';
    Password := 'pass';
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
        TAudioFile(fWebMedienBib[i]).Free;
    fWebMedienBib.Free;
    LeaveCriticalSection(CS_AccessLibrary);
    IdHTTPServer1.Free;
    LogList.Free;
    inherited;
end;                                                          
                                                              
procedure TNempWebServer.LoadfromIni;                         
var ini:TMemIniFile;
begin
    ini := TMeminiFile.Create(SavePath + 'NempWebServer.ini', TEncoding.UTF8);
    try
        ini.Encoding := TEncoding.UTF8;
        // aus der Ini lesen
        OnlyLAN               := Ini.ReadBool('Remote', 'OnlyLAN'               , True);
        AllowFileDownload     := Ini.ReadBool('Remote', 'AllowPlaylistDownload' , True);
        AllowLibraryAccess    := Ini.ReadBool('Remote', 'AllowLibraryAccess'    , True);
        AllowRemoteControl    := Ini.ReadBool('Remote', 'AllowRemoteControl', False);
        Port               := Ini.ReadInteger('Remote', 'Port', 80);
        RootDir            := Ini.ReadString('Remote', 'RootDir' , 'Extended');
        Username           := Ini.ReadString('Remote', 'Username', 'admin'  );
        Password           := Ini.ReadString('Remote', 'Password', 'pass'   );
    finally
        ini.Free;
    end;
end;


procedure TNempWebServer.SaveToIni;
var ini:TMemIniFile;
begin
  ini := TMeminiFile.Create(SavePath + 'NempWebServer.ini', TEncoding.UTF8);
  try
      Ini.Encoding := TEncoding.UTF8;
      Ini.WriteBool('Remote', 'OnlyLAN'               , OnlyLAN);
      Ini.WriteBool('Remote', 'AllowPlaylistDownload' , AllowFileDownload);
      Ini.WriteBool('Remote', 'AllowLibraryAccess'    , AllowLibraryAccess);
      Ini.WriteBool('Remote', 'AllowRemoteControl'    , AllowRemoteControl);
      Ini.WriteInteger('Remote', 'Port', Port);
      Ini.WriteString('Remote', 'RootDir' , RootDir);
      Ini.WriteString('Remote', 'Username', Username);
      Ini.WriteString('Remote', 'Password', Password);
      try
          Ini.UpdateFile;
      except
            // Silent Exception
      end;
  finally
      ini.Free;
  end;
end;




function TNempWebServer.fGetUsername: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fUsername;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetUsername(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fUsername := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetPassword: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fPassword;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetPassword(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fPassword := Value;
    LeaveCriticalSection(CS_Authentification);
end;

function TNempWebServer.fGetRootDir: String;
begin
    EnterCriticalSection(CS_Authentification);
    result := fRootDir;
    LeaveCriticalSection(CS_Authentification);
end;
procedure TNempWebServer.fSetRootDir(Value: String);
begin
    EnterCriticalSection(CS_Authentification);
    fRootDir := Value;
    LeaveCriticalSection(CS_Authentification);
end;

procedure TNempWebServer.fSetOnlyLAN(Value: Longbool);
begin
    InterLockedExchange(Integer(fOnlyLAN), Integer(Value));
end;
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
function TNempWebServer.fGetOnlyLAN: Longbool;
begin
  InterLockedExchange(Integer(Result), Integer(fOnlyLAN));
end;
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


function TNempWebServer.MainMenu(aPage: Integer = -1): String;
begin
    result := PatternMenu;

    if aPage = 0 then
        result := StringReplace(result, '{{PlayerClass}}', 'player active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlayerClass}}', 'player', [rfReplaceAll]);

    if aPage = 1 then
        result := StringReplace(result, '{{PlaylistClass}}', 'playlist active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlaylistClass}}', 'playlist', [rfReplaceAll]);

    if AllowLibraryAccess then
    begin
        if aPage = 2 then
            result := StringReplace(result, '{{LibraryClass}}', 'library active', [rfReplaceAll])
        else
            result := StringReplace(result, '{{LibraryClass}}', 'library', [rfReplaceAll]);
    end
    else
        result := StringReplace(result, '{{LibraryClass}}', 'hidden', [rfReplaceAll]);
end;

function TNempWebServer.BrowseSubMenu(aMode: String; aLetter: Char; aValue: String): String;
var sub: String;
    c: Char;
    letterClass: String;
    idx: Integer;
begin
    result := PatternBrowseMenu;

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
            sub := '<ul class="charselection"> <li class="genre active">' +  aValue + '</li></ul>';
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
var lastpoint: integer;
    CommonPart: string;
begin
  if Not OnlyLAN then
      result := True
  else
  begin
      lastpoint := length(aIP);
      repeat
        dec(lastpoint);
      until (lastpoint < 1) or (aIP[lastpoint] = '.');
      CommonPart := copy(aIP, 1, lastpoint);
      result := AnsiStartsStr(CommonPart, bIP);
  end;
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
        quality := quality + af.SampleRate;
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

    result := StringReplace(result, '{{PlaylistTitle}}', EscapeHTMLChars(af.PlaylistTitle), [rfReplaceAll]);
    result := StringReplace(result, '{{Title}}'    , EscapeHTMLChars(af.NonEmptyTitle) , [rfReplaceAll]);
    result := StringReplace(result, '{{Artist}}'   , EscapeHTMLChars(af.Artist), [rfReplaceAll]);
    result := StringReplace(result, '{{Album}}'    , EscapeHTMLChars(af.Album) , [rfReplaceAll]);

    result := StringReplace(result, '{{Votes}}'    , EscapeHTMLChars(IntToStr(af.VoteCounter)) , [rfReplaceAll]);

    if af.VoteCounter = 0 then
        result := StringReplace(result, '{{VoteClass}}', 'hidden', [rfReplaceAll])
    else
        result := StringReplace(result, '{{VoteClass}}', 'votes' , [rfReplaceAll]);


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


    if (af.CoverID <> '') and (FileExists(CoverSavePath + af.CoverID + '.jpg')) then
        result := StringReplace(result, '{{CoverID}}'   , EscapeHTMLChars(af.CoverID), [rfReplaceAll])
    else
        result := StringReplace(result, '{{CoverID}}', '0', [rfReplaceAll]);
end;

function TNempWebServer.fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer): String;
var buttons, btnTmp: String;

    function replaceTag(btnPattern: String; aAction: String): String;
    begin
        result := btnPattern;
        result := StringReplace(result, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);
        result := StringReplace(result, '{{Action}}' , aAction                 , [rfReplaceAll]);
    end;

begin
    buttons := aPattern;

    if AllowFileDownload and af.isFile then
    begin
        btnTmp := PatternButtonFileDownload;
        btnTmp := StringReplace(btnTmp, '{{Filename}}'          , HRefEncode(af.Dateiname) , [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{ID}}'                , IntToStr(af.WebServerID) , [rfReplaceAll]);
        btnTmp := StringReplace(btnTmp, '{{Action}}'            , 'file_download'          , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnFileDownload}}' , btnTmp                   , [rfReplaceAll]);
    end else
        buttons := StringReplace(buttons, '{{BtnFileDownload}}' , '', [rfReplaceAll]);

    if AllowRemoteControl then
    begin
        btnTmp := replaceTag(PatternButtonFileVote, 'file_vote');
        buttons := StringReplace(buttons, '{{BtnFileVote}}', btnTmp, [rfReplaceAll]);

        btnTmp := replaceTag(PatternButtonFileMoveUp, 'file_moveup');
        buttons := StringReplace(buttons, '{{BtnFileMoveUp}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileMoveDown, 'file_movedown');
        buttons := StringReplace(buttons, '{{BtnFileMoveDown}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileDelete, 'file_delete');
        buttons := StringReplace(buttons, '{{BtnFileDelete}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFilePlayNow, 'file_playnow');
        buttons := StringReplace(buttons, '{{BtnFilePlayNow}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileAdd, 'file_add');
        buttons := StringReplace(buttons, '{{BtnFileAdd}}', btnTmp, [rfReplaceAll]);
        btnTmp := replaceTag(PatternButtonFileAddnext, 'file_addnext');
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

function TNempWebServer.fSetControlButtons(aPattern: String; isPlaying: Boolean): String;
var buttons: String;
begin
    buttons := aPattern;
    buttons := StringReplace(buttons, '{{PlayerControls}}'     , PatternPlayerControls      , [rfReplaceAll]);

    if AllowRemoteControl then
    begin
        if isPlaying then
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', PatternButtonPause , [rfReplaceAll])
        else
            buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', PatternButtonPlay , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'     , PatternButtonStop      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'     , PatternButtonNext      , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'     , PatternButtonPrev      , [rfReplaceAll]);
    end else
    begin
        buttons := StringReplace(buttons, '{{BtnControlPlayPause}}' , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlStop}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlNext}}'      , '' , [rfReplaceAll]);
        buttons := StringReplace(buttons, '{{BtnControlPrev}}'      , '' , [rfReplaceAll]);
    end;
    result := buttons;
end;

function TNempWebServer.GenerateErrorPage(aErrorMessage: String; aPage: Integer): String;
var menu: String;
begin
    menu := MainMenu(aPage);
    result := StringReplace(PatternErrorPage, '{{Menu}}', menu, [rfreplaceAll]);
    result := StringReplace(result, '{{message}}', aErrorMessage, [rfreplaceAll]);
end;


procedure TNempWebServer.GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer; aPart: Integer=0);
var menu, PageData, PlayerData: String;
    af: TAudioFile;
begin
    menu := MainMenu(0);
    af := aNempPlayer.MainAudioFile;
    if assigned(af) then
    begin
        // ID generieren/setzen
        EnsureFileHasID(af);

        case aPart of
            1: begin
                // 1: Controls  [[PlayerControls]]
                HTML_Player := UTF8String(fSetControlButtons(PatternPlayerControls, aNempPlayer.Status = PLAYER_ISPLAYING));
            end;
            2: begin
                // 2: Playerdata [[ItemPlayer]]
                PlayerData := PatternItemPlayer;
                PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
                PlayerData := fSetBasicFileData(af, PlayerData, '');
                PlayerData := fSetFileButtons(af, PlayerData, 0);
                HTML_Player := UTF8String(PlayerData);
            end;
        else
            begin
                PlayerData := PatternItemPlayer;
                PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
                PlayerData := fSetBasicFileData(af, PlayerData, '');
                PlayerData := fSetFileButtons(af, PlayerData, 0);
                PageData := PatternPlayerPage;
                PageData := fSetControlButtons(PatternPlayerPage, aNempPlayer.Status = PLAYER_ISPLAYING);
                PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
                PageData := StringReplace(PageData, '{{ItemPlayer}}', PlayerData, [rfReplaceAll]);
                HTML_Player := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]))
            end;
        end;

    end else
    begin
        if (aPart=0) then
            PageData := GenerateErrorPage(WebServer_NoFile, 0)
        else
            PageData := 'fail';
    end;
end;

// konvertiert die Playlist in ein HTML-Formular
// in VCL-Threads ausführen. Zugriff auf den HTML-String ist durch den Setter Threadsafe.
procedure TNempWebServer.GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist);
var //i: Integer;
    //af: TAudioFile;
    //aClass: String;
    //Item,
    Items, PageData: String;
    menu: String;

begin
    menu := MainMenu(1);
    Items := GenerateHTMLfromPlaylistItem(aNempPlaylist, -1);

    PageData := PatternPlaylistPage;
    PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{PlaylistItems}}', Items, [rfReplaceAll]);

    HTML_PlaylistView := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;

function TNempWebServer.GenerateHTMLfromPlaylistItem(
  aNempPlayList: TNempPlaylist; aIdx: Integer): String;
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
            af := TAudioFile(aNempPlayList.Playlist[i]);
            // ID generieren/setzen
            EnsureFileHasID(af);

            // create new Item
            Item := PatternItemPlaylist;
            Item := StringReplace(Item, '{{Index}}'  , IntToStr(i + 1)         , [rfReplaceAll]);

            if af.PrebookIndex > 0 then
                Item := Stringreplace(Item, '{{PrebookClass}}', 'prebook', [rfReplaceAll])
            else
                Item := Stringreplace(Item, '{{PrebookClass}}', 'noprebook', [rfReplaceAll]);
            Item := StringReplace(Item, '{{PrebookIndex}}', IntToStr(af.PrebookIndex) , [rfReplaceAll]);


            Item := StringReplace(Item, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);

            // Set "Current" class
            if af = aNempPlaylist.PlayingFile then
                aClass := 'current '
            else
                aClass := '';

            // replace tags
            Item := fSetBasicFileData(af, Item, aClass);
            Item := fSetFileButtons(af, Item, 1);
            Items := Items + Item;
        end;
        result := Items;
        HTML_PlaylistView := UTF8String(Items);
    end else
    begin
        if (aIdx >= 0) and (aIdx < aNempPlaylist.Count) then
        begin
            af := TAudioFile(aNempPlayList.Playlist[aIdx]);
            Item := PatternItemPlaylist;
            Item := StringReplace(Item, '{{Index}}'  , IntToStr(aIdx + 1)         , [rfReplaceAll]);

            if af.PrebookIndex > 0 then
                Item := Stringreplace(Item, '{{PrebookClass}}', 'prebook', [rfReplaceAll])
            else
                Item := Stringreplace(Item, '{{PrebookClass}}', 'noprebook', [rfReplaceAll]);
            Item := StringReplace(Item, '{{PrebookIndex}}', IntToStr(af.PrebookIndex) , [rfReplaceAll]);

            Item := StringReplace(Item, '{{ID}}'     , IntToStr(af.WebServerID), [rfReplaceAll]);

            // Set "Current" class
            if af = aNempPlaylist.PlayingFile then
                aClass := 'current '
            else
                aClass := '';

            // replace tags
            Item := fSetBasicFileData(af, Item, aClass);
            Item := fSetFileButtons(af, Item, 1);
        end else
            Item := 'fail';

        result := Item;
        HTML_PlaylistView := UTF8String(Item);
    end;
end;

procedure TNempWebServer.GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer);
var PageData, FileData: String;
    menu: String;
begin
    menu := MainMenu(1);
    if assigned(aAudioFile) then
    begin
        aAudioFile.FileIsPresent := (not aAudioFile.IsFile) or FileExists(aAudioFile.Pfad);

        FileData := PatternItemPlaylistDetails;
        FileData := StringReplace(FileData, '{{Index}}' , IntToStr(aIdx + 1)              , [rfReplaceAll]);
        if aAudioFile.PrebookIndex > 0 then
            FileData := Stringreplace(FileData, '{{PrebookClass}}', 'prebook', [rfReplaceAll])
        else
            FileData := Stringreplace(FileData, '{{PrebookClass}}', 'noprebook', [rfReplaceAll]);
        FileData := StringReplace(FileData, '{{PrebookIndex}}', IntToStr(aAudioFile.PrebookIndex) , [rfReplaceAll]);

        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1);

        PageData := PatternPlaylistDetailsPage;
        PageData := StringReplace(PageData, '{{Menu}}'               , menu     , [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemPlaylistDetails}}', FileData , [rfReplaceAll]);
    end else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 1);

    HTML_PlaylistDetails := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString; Start: Integer): UTf8String;
var ResultList: TObjectlist;
    af: TAudioFile;
    i, maxIdx: Integer;
    aClass, PageData, Pagination, menu, browsemenu, Item, Items, warning: String;
    btnPrev, BtnNext, Link: String;
begin
    menu := Mainmenu(2);
    browsemenu := BrowseSubMenu('', '"', '');
    //if aSearchString = '' then
        PageData := PatternSearchPage;
    //else
    //    PageData := PatternSearchResultPage;

    PageData := StringReplace(PageData, '{{Menu}}'       , menu         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}' , browsemenu, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', aSearchString, [rfReplaceAll]);

    if aSearchString <> '' then
    begin
        Items := '';
        maxIdx := 0;
        if Start < 0 then
            Start := 0;

        ResultList := TObjectList.Create(False);
        try
            SearchLibrary(aSearchString, ResultList);
            if ResultList.Count > 0 then
            begin
                maxIdx := Start + MaxCountPerPage - 1;
                if maxIdx > (ResultList.Count - 1) then
                    maxIdx := ResultList.Count - 1;

                for i := Start to maxIdx do
                begin
                    af := TAudioFile(ResultList[i]);
                    // ID generieren/setzen
                    EnsureFileHasID(af);
                    Item := PatternItemSearchlist;
                    Item := StringReplace(Item, '{{ID}}'  , IntToStr(af.WebServerID), [rfReplaceAll]);
                    aClass := '';
                    // replace tags
                    Item := fSetBasicFileData(af, Item, aClass);
                    Item := fSetFileButtons(af, Item, 2);
                    Items := Items + Item;
                end;
            end;

            // Build Pagination
            if (Start > 0) then
            begin
                BtnPrev := PatternPaginationPrev;
                Link := 'library?start=' + IntToStr(start-MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
                BtnPrev := StringReplace(BtnPrev, '{{Link}}', Link, [rfReplaceAll]);
            end
            else
                BtnPrev := '';

            if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
            begin
                BtnNext := PatternPaginationNext;
                Link := 'library?start=' + IntToStr(start+MaxCountPerPage) + '&amp;query=' + ParamsEncode(UTF8String(aSearchString));
                BtnNext := StringReplace(BtnNext, '{{Link}}', Link, [rfReplaceAll]);

            end
            else
                BtnNext := '';

            if (BtnNext = '') and (BtnPrev = '') then
                Pagination := ''
            else
            begin
                Pagination := StringReplace(PatternPagination, '{{NextPage}}', BtnNext, [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{PrevPage}}', BtnPrev, [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{Start}}' , IntToStr(Start+1)           , [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{End}}'   , IntToStr(MaxIdx+1)          , [rfReplaceAll]);
                Pagination := StringReplace(Pagination       , '{{Count}}' , IntToStr(ResultList.Count), [rfReplaceAll]);
            end;

            if ResultList.Count = 0 then
            begin
                warning := PatternNoFilesHint;
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

    result := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;


function TNempWebServer.GenerateHTMLMedienbibBrowseList(aMode: String; aChar: Char; other: Boolean): UTf8String;
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
    menu := MainMenu(2);
    browsemenu := BrowseSubMenu(aMode, aChar, '');

    PageData := PatternSearchPage;
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{NoFilesHint}}', ''  , [rfReplaceAll]);

    if CharInSet(aChar, ['A'..'Z']) then
        ListIdx := ord(aChar) - ord('A') + 1
    else
        ListIdx := 0;

    aList := MainArtists[1]; // fallback
    LinkList := Nil;
    ItemPattern := PatternItemBrowseArtist;
    if aMode = 'artist' then
    begin
        ItemPattern := PatternItemBrowseArtist;
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
        ItemPattern := PatternItemBrowseAlbum;
        aList := Albums[ListIdx];
    end;
    if aMode = 'genre' then
    begin
        ItemPattern := PatternItemBrowseGenre;
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
        Item := StringReplace(Item, '{{Count}}'  , IntToStr(ab.Count), [rfReplaceAll]);
        Item := StringReplace(Item, '{{CoverID}}', EscapeHTMLChars(ab.CoverID), [rfReplaceAll]);
        Items := Items + Item;
    end;

    if aMode='artist' then
    begin
        if assigned(LinkList) then
        begin
            if Other then
            begin
                pagination := PatternPaginationMain;
                Link := 'browse?mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;l=' + ParamsEncode(UTF8String(aChar)) + '&amp;other=0';
            end
            else
            begin
                pagination := PatternPaginationOther;
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
    result := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;

function TNempWebServer.GenerateHTMLMedienbibBrowseResult(aMode: String; aValue: String; Start: Integer): UTf8String;
var PageData, menu, browsemenu: String;
    Items, warning: String;
    btnPrev, BtnNext, Pagination, Link: String;
    i,  maxIdx: Integer;
    af: TAudioFile;
    ResultList: TObjectList;

    procedure AddItem(afile: TAudioFile);
    var aClass, Item: String;
    begin
        //if c < 1000 then
        //begin
            EnsureFileHasID(af);
            Item := PatternItemSearchlist;
            Item := StringReplace(Item, '{{ID}}'  , IntToStr(afile.WebServerID), [rfReplaceAll]);
            aClass := '';
            // replace tags
            Item := fSetBasicFileData(afile, Item, aClass);
            Item := fSetFileButtons(afile, Item, 2);
            Items := Items + Item;
        //end;
        //inc(c);
    end;

begin
    menu := MainMenu(2);
    browsemenu := BrowseSubMenu(aMode, ' ', aValue);

    PageData := PatternSearchPage;
    PageData := StringReplace(PageData, '{{Menu}}'        , menu       , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{BrowseMenu}}'  , browsemenu , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', ''         , [rfReplaceAll]);
    Items := '';

    EnterCriticalSection(CS_AccessLibrary);

    ResultList := TObjectList.Create(False);
    try
        if aMode='artist' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := TAudioFile(fWebMedienBib[i]);
                if AnsiSameText(af.Artist, aValue) then
                    ResultList.Add(af);
                    //AddItem(af);
            end;

        if aMode='album' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := TAudioFile(fWebMedienBib[i]);
                if AnsiSameText(af.Album, aValue) then
                    ResultList.Add(af);
                    //AddItem(af);
            end;

        if aMode='genre' then
            for i := 0 to fWebMedienBib.Count - 1 do
            begin
                af := TAudioFile(fWebMedienBib[i]);
                if AnsiSameText(af.genre, aValue) then
                    ResultList.Add(af);
                    //AddItem(af);
            end;

        if Start < 0 then Start := 0;

        maxIdx := Start + MaxCountPerPage - 1;
        if maxIdx > (ResultList.Count - 1) then
            maxIdx := ResultList.Count - 1;

        for i := Start to maxIdx do
            AddItem(TAudioFile(ResultList[i]));

        // Build Pagination
        if (Start > 0) then
        begin
            BtnPrev := PatternPaginationPrev;
            Link := 'browse?start=' + IntToStr(start-MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;value=' + ParamsEncode(UTF8String(aValue));
            BtnPrev := StringReplace(BtnPrev, '{{Link}}', Link, [rfReplaceAll]);
        end
        else
            BtnPrev := '';

        if (Start + MaxCountPerPage) < (ResultList.Count - 1) then
        begin
            BtnNext := PatternPaginationNext;
            Link := 'browse?start=' + IntToStr(start+MaxCountPerPage) + '&amp;mode=' + ParamsEncode(UTF8String(aMode)) + '&amp;value=' + ParamsEncode(UTF8String(aValue));
            BtnNext := StringReplace(BtnNext, '{{Link}}', Link, [rfReplaceAll]);
        end
        else
            BtnNext := '';

        if (BtnNext = '') and (BtnPrev = '') then
            Pagination := ''
        else
        begin
            Pagination := StringReplace(PatternPagination, '{{NextPage}}', BtnNext, [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{PrevPage}}', BtnPrev, [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{Start}}' , IntToStr(Start+1)           , [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{End}}'   , IntToStr(MaxIdx+1)          , [rfReplaceAll]);
            Pagination := StringReplace(Pagination       , '{{Count}}' , IntToStr(ResultList.Count), [rfReplaceAll]);
        end;

        if ResultList.Count = 0 then
        begin
            warning := PatternNoFilesHint;
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
    result := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));

end;


function TNempWebServer.GenerateHTMLfromMedienbibSearch_Details(aAudioFile: TAudioFile): UTf8String;
var PageData, FileData, menu: String;
begin
    menu := MainMenu(2);

    if assigned(aAudioFile) then
    begin
        aAudioFile.FileIsPresent := (not aAudioFile.IsFile) or FileExists(aAudioFile.Pfad);

        FileData := PatternItemSearchDetails;
        FileData := StringReplace(FileData, '{{ID}}'    , IntToStr(aAudioFile.WebServerID), [rfReplaceAll]);
        FileData := fSetBasicFileData(aAudioFile, FileData, '');
        FileData := fSetFileButtons(aAudioFile, FileData, 1);

        PageData := PatternSearchDetailsPage;
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemSearchDetails}}', FileData, [rfReplaceAll]);
    end
    else
        PageData := GenerateErrorPage(WebServer_InvalidParameter, 2);

    result := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
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
        TAudioFile(fWebMedienBib[i]).Free;
    fWebMedienBib.Clear;
    LeaveCriticalSection(CS_AccessLibrary);
end;


procedure TNempWebServer.SearchLibrary(Keyword: UnicodeString; DestList: TObjectlist);
var Keywords: TStringList;
    KeywordsUTF8: TUTF8Stringlist;
    tmpList: TObjectlist;
    i: Integer;

begin
    if trim(Keyword) = '' then exit;

    EnterCriticalSection(CS_AccessLibrary);

    Keywords := ExplodeWithQuoteMarks('+', Keyword);

    SetLength(KeywordsUTF8, Keywords.Count);
    for i := 0 to Keywords.Count - 1 do
        KeywordsUTF8[i] := UTF8Encode(AnsiLowerCase(Keywords[i]));

    tmpList := TObjectlist.Create(False);
    for i := 0 to fWebMedienBib.Count - 1 do
    begin
        if AudioFileMatchesKeywords(TAudioFile(fWebMedienBib[i]), Keywords) then
            DestList.Add(TAudioFile(fWebMedienBib[i]))
        else
            if AudioFileMatchesKeywordsApprox(TAudioFile(fWebMedienBib[i]), KeywordsUTF8) then
                tmpList.Add(TAudioFile(fWebMedienBib[i]));
    end;
    for i := 0 to tmpList.Count - 1 do
        DestList.Add(tmpList[i]);

    tmpList.Free;
    Keywords.Free;

    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.LoadTemplates;
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
    fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\' + RootDir + '\';
    sl := TStringList.Create;
    try
        PatternBody := GetTemplate(fLocalDir + 'Body.tpl');
        PatternMenu := GetTemplate(fLocalDir + 'Menu.tpl');
        PatternBrowseMenu := GetTemplate(fLocalDir + 'MenuLibraryBrowse.tpl');

        PatternPagination      := GetTemplate(fLocalDir + 'Pagination.tpl');
        PatternPaginationNext  := GetTemplate(fLocalDir + 'PaginationNextPage.tpl');
        PatternPaginationPrev  := GetTemplate(fLocalDir + 'PaginationPrevPage.tpl');
        PatternPaginationOther := GetTemplate(fLocalDir + 'PaginationOther.tpl');
        PatternPaginationMain  := GetTemplate(fLocalDir + 'PaginationMain.tpl');


        // Buttons for Player Control
        // PatternButtonPlayPause := trim(GetTemplate(fLocalDir + 'BtnControlPlayPause.tpl'));
        PatternPlayerControls := trim(GetTemplate(fLocalDir + 'PlayerControls.tpl'));
        PatternButtonPause := trim(GetTemplate(fLocalDir + 'BtnControlPause.tpl'));
        PatternButtonPlay  := trim(GetTemplate(fLocalDir + 'BtnControlPlay.tpl'));
        PatternButtonNext  := trim(GetTemplate(fLocalDir + 'BtnControlNext.tpl'));
        PatternButtonPrev  := trim(GetTemplate(fLocalDir + 'BtnControlPrev.tpl'));
        PatternButtonStop  := trim(GetTemplate(fLocalDir + 'BtnControlStop.tpl'));

        PatternButtonSuccess := trim(GetTemplate(fLocalDir + 'BtnSuccess.tpl'));
        PatternButtonFail := trim(GetTemplate(fLocalDir + 'BtnFail.tpl'));

        // Buttons for File-Handling
        PatternButtonFileDownload := trim(GetTemplate(fLocalDir + 'BtnFileDownload.tpl'));
        PatternButtonFilePlayNow := trim(GetTemplate(fLocalDir + 'BtnFilePlayNow.tpl'));
        PatternButtonFileAdd := trim(GetTemplate(fLocalDir + 'BtnFileAdd.tpl'));
        PatternButtonFileAddNext := trim(GetTemplate(fLocalDir + 'BtnFileAddNext.tpl'));
        PatternButtonFileMoveUp := trim(GetTemplate(fLocalDir + 'BtnFileMoveUp.tpl'));
        PatternButtonFileMoveDown := trim(GetTemplate(fLocalDir + 'BtnFileMoveDown.tpl'));
        PatternButtonFileDelete := trim(GetTemplate(fLocalDir + 'BtnFileDelete.tpl'));
        PatternButtonFileVote := trim(GetTemplate(fLocalDir + 'BtnFileVote.tpl'));

        // The PLAYER page
        PatternItemPlayer := trim(GetTemplate(fLocalDir + 'ItemPlayer.tpl'));
        PatternPlayerPage := GetTemplate(fLocalDir + 'PagePlayer.tpl');

        // The PLAYLIST page
        PatternPlaylistPage := GetTemplate(fLocalDir + 'PagePlaylist.tpl');
        PatternItemPlaylist := GetTemplate(fLocalDir + 'ItemPlaylist.tpl');

        // The PLAYLIST DETAILS page
        PatternPlaylistDetailsPage := GetTemplate(fLocalDir + 'PagePlaylistDetails.tpl');
        PatternItemPlaylistDetails := GetTemplate(fLocalDir + 'ItemPlaylistDetails.tpl');

        // The LIBRARY page
        PatternSearchPage := GetTemplate(fLocalDir + 'PageLibrary.tpl');
        PatternSearchResultPage := GetTemplate(fLocalDir + 'PageLibrarySearchResults.tpl');
        PatternItemSearchlist := GetTemplate(fLocalDir + 'ItemSearchResult.tpl');

        PatternItemBrowseArtist := GetTemplate(fLocalDir + 'ItemBrowseArtist.tpl');
        PatternItemBrowseAlbum := GetTemplate(fLocalDir + 'ItemBrowseAlbum.tpl');
        PatternItemBrowseGenre := GetTemplate(fLocalDir + 'ItemBrowseGenre.tpl');

        // The LIBRARY DETAILS page
        PatternSearchDetailsPage := GetTemplate(fLocalDir + 'PageLibraryDetails.tpl');
        PatternItemSearchDetails := GetTemplate(fLocalDir + 'ItemSearchDetails.tpl');

        // The ERROR page
        PatternErrorPage := GetTemplate(fLocalDir + 'PageError.tpl');
        PatternNoFilesHint := GetTemplate(fLocalDir + 'WarningNoFiles.tpl');

    finally
        sl.Free;
    end;
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

procedure TNempWebServer.PrepareArtists;
var currentArtist, currentCoverID: String;
    c, i, idx: Integer;
    newEntry: TCountedString;

begin
    fWebMedienBib.Sort(Sortieren_ArtistAlbumTrackTitel_asc);

    if fWebMedienBib.Count > 0 then
    begin
        currentArtist := TAudioFile(fWebMedienBib[0]).Artist;
        currentCoverID := TAudioFile(fWebMedienBib[0]).CoverID;
        c := 1;

        for i := 1 to fWebMedienBib.Count - 1 do
        begin
            if not AnsiSameText(TAudioFile(fWebMedienBib[i]).Artist, currentArtist) then
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
                currentArtist := TAudioFile(fWebMedienBib[i]).Artist;
                currentCoverID := '';
                c := 1;
            end else
            begin
                // just count this file to the current-Artist-Count
                inc(c);
                if currentCoverID = '' then
                    currentCoverID := TAudioFile(fWebMedienBib[i]).CoverID;
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
begin
    fWebMedienBib.Sort(Sortieren_AlbumTrack_asc);
    if fWebMedienBib.Count > 0 then
    begin
        currentAlbum := TAudioFile(fWebMedienBib[0]).Album;
        currentCoverID := TAudioFile(fWebMedienBib[0]).CoverID;
        c := 1;

        for i := 1 to fWebMedienBib.Count - 1 do
        begin

            if not AnsiSameText(TAudioFile(fWebMedienBib[i]).Album, currentAlbum) then
            begin
                if (trim(currentAlbum) <> '') and (c >= GoodAlbum) then
                begin
                    // insert currentAlbum into one of the Album-Lists
                    idx := CorrectIndex(currentAlbum);
                    newEntry := TCountedString.Create(currentAlbum, c, currentCoverID);
                    Albums[idx].Add(newEntry);
                end; // otherwise do not add this album
                // start counting again
                currentAlbum := TAudioFile(fWebMedienBib[i]).Album;
                currentCoverID := '';
                c := 1;
            end else
            begin
                // just count this file to the current-Artist-Count
                inc(c);
                if currentCoverID = '' then
                    currentCoverID := TAudioFile(fWebMedienBib[i]).CoverID;
            end;
        end;

        // insert last item
        if (trim(currentAlbum) <> '') and (c >= GoodAlbum) then
        begin
            // insert currentAlbum into one of the Album-Lists
            idx := CorrectIndex(currentAlbum);
            newEntry := TCountedString.Create(currentAlbum, c, currentCoverID);
            Albums[idx].Add(newEntry);
        end;

        // set Font Sizes
        for i := 0 to 26 do
            SetFontSizes(Albums[i]);
    end;
end;

procedure TNempWebServer.PrepareGenres;
var currentGenre: String;
    c, i: Integer;
    newEntry: TCountedString;
begin
    fWebMedienBib.Sort(Sortieren_Genre_asc);
    if fWebMedienBib.Count > 0 then
    begin
        currentGenre := TAudioFile(fWebMedienBib[0]).Genre;
        c := 1;

        for i := 1 to fWebMedienBib.Count - 1 do
        begin
            if not AnsiSameText(TAudioFile(fWebMedienBib[i]).Genre, currentGenre) then
            begin
                if (trim(currentGenre) <> '')
                  and (currentGenre <> 'Other')
                  and ( not ( (length(currentGenre) <= 5) and CharinSet(trim(currentGenre)[1], ['0'..'9', '('] ) ))
                then
                begin
                    // insert currentGenre into the Genres-List
                    newEntry := TCountedString.Create(currentGenre, c, '1');
                    Genres.Add(newEntry);
                end;
                // start counting again
                currentGenre := TAudioFile(fWebMedienBib[i]).Genre;
                c := 1;
            end else
            begin
                // just count this file to the current-Artist-Count
                inc(c);
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

            LoadTemplates;

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
        if TAudioFile(fWebMedienBib[i]).WebServerID = aID then
        begin
            result := TAudioFile(fWebMedienBib[i]);
            break;
        end;
    end;
    LeaveCriticalSection(CS_AccessLibrary);
end;

procedure TNempWebServer.GetThemes(out Themes: TStrings);
var SR: TSearchRec;
begin
    if (FindFirst(ExtractFilePath(Paramstr(0)) + 'HTML\' + '*', faDirectory, SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
              Themes.Add(Sr.Name);
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
         (aRequestInfo.Document) + ', ' + trim((aRequestInfo.Params.Text));

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


function TNempWebServer.HandleError(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult): TQueryResult;
var ErrorMessage, PageData: String;
    Body: UTF8String;
    ms: TMemoryStream;
begin
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

    PageData := GenerateErrorPage(ErrorMessage, -1);
    Body := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));

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

function TNempWebServer.ResponsePlayer(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
begin
        ms := TMemoryStream.Create;
            EnterCriticalSection(CS_AccessHTMLCode);
            SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayer, 0); //QueryPlayer;
            html := HTML_Player;
            LeaveCriticalSection(CS_AccessHTMLCode);
        if html = '' then html := ' ';
        ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
end;
function TNempWebServer.ResponsePlayerJS(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    queriedAction, queriedPart: String;
    aProgress, aVolume: Integer;
begin
        queriedAction := aRequestInfo.Params.Values['action'];
        if queriedAction = 'getprogress' then
        begin
            aProgress := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETPROGRESS, 0);
            ms := TMemoryStream.Create;
            html := IntToStr(aProgress);
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end else
        if queriedAction = 'getvolume' then
        begin
            aVolume := SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_GETVOLUME, 0);
            ms := TMemoryStream.Create;
            html := IntToStr(aVolume);
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end
        else
        begin
            queriedPart := aRequestInfo.Params.Values['part'];

            ms := TMemoryStream.Create;
                EnterCriticalSection(CS_AccessHTMLCode);
                if queriedPart= 'controls' then
                    SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerJS, 1)
                else
                    SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayerJS, 2); //QueryPlayer;
                html := HTML_Player;
                LeaveCriticalSection(CS_AccessHTMLCode);
            if html = '' then html := ' ';
            ms.Write(html[1], length(html));
            AResponseInfo.ContentStream := ms;
        end;

        result := qrPermit;
end;

function TNempWebServer.ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedAction: String;
begin
  if AllowRemoteControl then
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
      AResponseInfo.Redirect('/player');
      AResponseInfo.ContentStream := Nil;
  end else
  begin
      result := HandleError(AResponseInfo, qrRemoteControlDenied)
  end;
end;

function TNempWebServer.ResponseJSPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedAction, queriedValue: String;
    aProgress, aVolume: Integer;
begin
  if AllowRemoteControl then
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
          if aProgress <> -1 then
              SendMessage(fMainWindowHandle, WM_WebServer, WS_IPC_SETVolume, aVolume);
      end;

      //else
      //    result := qrInvalidParameter;
      ;

      result := ResponsePlayerJS(ARequestInfo, AResponseInfo);
  end else
  begin
      result := HandleError(AResponseInfo, qrRemoteControlDenied)
  end;
end;

function TNempWebServer.ResponseClassicPlaylistControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedAction: String;
    queriedID: Integer;
    af: TAudioFile;
begin
    if AllowRemoteControl then
    begin
        result := qrPermit;
        queriedAction := aRequestInfo.Params.Values['action'];

        if queriedAction = 'file_playnow' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID) > 0 then
            begin
                // todo: Hier ggf. ein result erwarten und auswerten?
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
                result := qrPermit;
            end else
                result := HandleError(AResponseInfo, qrInvalidParameter)
        end
        else
        if queriedAction = 'file_add' then
        begin
            EnterCriticalSection(CS_AccessLibrary);
            result := qrPermit;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
            begin
                // sende Audiofile an Nemp-Hauptfenster/playlist
                SendMessage(fMainWindowHandle, WM_WebServer, WS_AddToPlaylist, LParam(af));
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
            end else // not in bib
            begin
                result := HandleError(AResponseInfo, qrInvalidParameter);
            end;
            LeaveCriticalSection(CS_AccessLibrary);
        end;
        if queriedAction = 'file_addnext' then
        begin
            EnterCriticalSection(CS_AccessLibrary);
            result := qrPermit;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
            begin
                // sende Audiofile an Nemp-Hauptfenster/playlist
                SendMessage(fMainWindowHandle, WM_WebServer, WS_InsertNext, LParam(af));
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
            end else
            begin
                result := HandleError(AResponseInfo, qrInvalidParameter);
            end;
            LeaveCriticalSection(CS_AccessLibrary);
        end;
        if queriedAction = 'file_moveup' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveUp, queriedID) >= 1 then
            begin
                // todo: Hier ggf. ein result erwarten und auswerten?
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
                result := qrPermit;
            end else
                result := HandleError(AResponseInfo, qrInvalidParameter);
        end;
        if queriedAction = 'file_movedown' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistMoveDown, queriedID) >= 1 then
            begin
                // todo: Hier ggf. ein result erwarten und auswerten?
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
                result := qrPermit;
            end else
                result := HandleError(AResponseInfo, qrInvalidParameter);
        end;
        if queriedAction = 'file_delete' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID) > 0 then
            begin
                // todo: Hier ggf. ein result erwarten und auswerten?
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
                result := qrPermit;
            end else
                result := HandleError(AResponseInfo, qrInvalidParameter);
        end;
    end else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied)
    end;
end;

function TNempWebServer.ResponseJSPlaylistControl(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedAction: String;
    queriedID: Integer;
    res, newID: Integer;
    html: UTF8String;
    af: TAudioFile;

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
                AResponseInfo.ContentStream := BuildStream(UTF8String(PatternButtonSuccess));
        end
        else
        begin

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
    if AllowRemoteControl then
    begin
        result := qrPermit;
        queriedAction := aRequestInfo.Params.Values['action'];

        if queriedAction = 'file_playnow' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            result := PlayNow(queriedID);
        end;

        if queriedAction = 'file_vote' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            case Votemachine.ProcessVote(queriedID, AContext.Binding.PeerIP) of
                vr_Success   : AResponseInfo.ContentStream := BuildStream(UTF8String('ok'));
                vr_TotalVotesExceeded : AResponseInfo.ContentStream := BuildStream(UTF8String('spam'));
                vr_FileVotesExceeded  : AResponseInfo.ContentStream := BuildStream(UTF8String('already voted'));
                vr_Exception : AResponseInfo.ContentStream := BuildStream(UTF8String('exception'));
            end;
        end;


        if queriedAction = 'file_moveupcheck' then
        begin
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

        if queriedAction = 'file_movedowncheck' then
        begin
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

        if queriedAction = 'file_delete' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            res := SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID);
            //if res > 0 then
            //begin
                // 0 : Invalid, reload playlist
                // 1 : File deleted, hide item
                // 2 : File removed from Prebooklist, reload Playlist
                AResponseInfo.ContentStream := BuildStream(UTF8String(IntTostr(res)));
                result := qrPermit;
            //end else
            //    result := HandleError(AResponseInfo, qrInvalidParameter);
        end;

        if (queriedAction = 'file_addnext')
            or (queriedAction = 'file_add')
        then
        begin
            addNext(queriedAction, False);
        end;


        if queriedAction = 'loaditem' then
        begin
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);

            // return one (or all) item of the playlist
            EnterCriticalSection(CS_AccessHTMLCode);
            SendMessage(fMainWindowHandle, WM_WebServer, WS_QueryPlaylistItem, queriedID);
            html := HTML_PlaylistView;
            LeaveCriticalSection(CS_AccessHTMLCode);

            AResponseInfo.ContentStream := BuildStream(html);
            result := qrPermit;
        end;

    end
    else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied)
    end;


end;

function TNempWebServer.ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
begin
       ms := TMemoryStream.Create;
            EnterCriticalSection(CS_AccessHTMLCode);
            SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylist, 0);
            html := HTML_PlaylistView;
            LeaveCriticalSection(CS_AccessHTMLCode);
        if html = '' then html := ' ';
        ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
end;


function TNempWebServer.ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    queriedID: Integer;
begin
        EnterCriticalSection(CS_AccessHTMLCode);
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
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
            result := HandleError(AResponseInfo, qrInvalidParameter);
end;

function TNempWebServer.ResponseCover (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedCover: String;
    fn: UnicodeString;
begin
    queriedCover := aRequestInfo.Params.Values['ID'];
    fn := CoverSavePath + queriedCover + '.jpg';
    if not FileExists(fn) then
        fn := fLocalDir + 'default_cover.png';
    if not FileExists(fn) then
        fn := fLocalDir + 'default_cover.jpg';

    if FileExists(fn) then
    begin
        try
            AResponseInfo.ContentStream := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
            result := qrPermit;
        except
            result := HandleError(AResponseInfo, qrError);
        end;
    end else
        result := qrFileNotFound;
end;


function TNempWebServer.ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedID: Integer;
    fn: UnicodeString;
    af: TAudioFile;
begin
    if AllowFileDownload then
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
            result := HandleError(AResponseInfo, qrInvalidParameter);
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
                    result := HandleError(AResponseInfo, qrError);
                end;
            end else
            begin
                // File not found
                result := HandleError(AResponseInfo, qrFileNotFound);
            end;
        end;
    end else
    begin
        result := HandleError(AResponseInfo, qrDownloadDenied);
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


function TNempWebServer.ResponseSearchInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var ms: TMemoryStream;
    html: UTf8String;
    searchstring: String;
    a: AnsiString;
    i, Start: Integer;

begin
    if AllowLibraryAccess then
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
        html := GenerateHTMLMedienbibSearchFormular(searchstring, Start);
        if html = '' then html := ' ';
            ms.Write(html[1], length(html));
        // NOT necessary here AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied);
end;

function TNempWebServer.ResponseBrowseInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var QueryMode, QueryLetter, QueryValue, QueryOther: String;
    ms: TMemoryStream;
    html: UTf8String;
    i, Start: Integer;
    a: AnsiString;
begin
    if AllowLibraryAccess then
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
            html := GenerateHTMLMedienbibBrowseList(Querymode, QueryLetter[1], QueryOther='1');
            if html = '' then html := ' ';
                ms.Write(html[1], length(html));
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := ms;
            result := qrPermit;

        end else
        begin
            // generate List of Titles according to QueryMode + Value
            ms := TMemoryStream.Create;
            html := GenerateHTMLMedienbibBrowseResult(Querymode, QueryValue, Start);
            if html = '' then html := ' ';
                ms.Write(html[1], length(html));
            // NOT necessary here AddNoCacheHeader(AResponseInfo);
            AResponseInfo.ContentStream := ms;

            result := qrPermit;
        end;
    end  else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied);
end;

function TNempWebServer.ResponseLibraryDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedID: Integer;
    af: TAudioFile;
    html: UTf8String;
    ms: TMemoryStream;
begin
    if AllowLibraryAccess then
    begin
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        // Ja, doppelt eintreten hält besser! Nach dem Verlassen von getAudioFilefromLib könnte sonst die Liste geleert werden!!
        EnterCriticalSection(CS_AccessLibrary);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
            begin
                html := GenerateHTMLfromMedienbibSearch_Details(af);
                ms := TMemoryStream.Create;
                if html = '' then html := ' ';
                ms.Write(html[1], length(html));
                // NOT necessary here AddNoCacheHeader(AResponseInfo);
                AResponseInfo.ContentStream := ms;
                result := qrPermit;
            end else // not in bib
                result := HandleError(AResponseInfo, qrInvalidParameter);
        LeaveCriticalSection(CS_AccessLibrary);
    end else
        result := HandleError(AResponseInfo, qrLibraryAccessDenied);
end;

procedure TNempWebServer.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var //ms: TMemoryStream;
    RequestedDocument: String;
    permit: TQueryResult;
    fn: UnicodeString;
    queriedAction: String;
begin

    if ValidIP(AContext.Binding.PeerIP, AContext.Binding.IP) then
    begin
        RequestedDocument := aRequestInfo.Document;
        if RequestedDocument = '/' then
            RequestedDocument := '/player';

        if ((ARequestInfo.AuthUsername <> Username) or (ARequestInfo.AuthPassword <> Password)) then
        begin
            logQueryAuth(AContext, aRequestInfo);
            AResponseInfo.ContentText := 'Enter your username and password';
            AResponseInfo.AuthRealm := 'Nemp webserver login';
            exit;
        end;

        if RequestedDocument = '/player' then permit := ResponsePlayer(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playlist' then permit := ResponsePlaylistView(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/library' then permit := ResponseSearchInLibrary(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/browse' then permit := ResponseBrowseInLibrary(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/cover' then permit := ResponseCover(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playercontrol' then permit := ResponseClassicPlayerControl(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playercontrolJS' then permit := ResponseJSPlayerControl(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playlistcontrol' then permit := ResponseClassicPlaylistControl(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playlistcontrolJS' then permit := ResponseJSPlaylistControl(AContext, ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playlist_details' then permit := ResponsePlaylistDetails(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/library_details' then permit := ResponseLibraryDetails(ARequestInfo, AResponseInfo)
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
                    try
                        AResponseInfo.ContentStream := TFileStream.Create(fn, fmOpenRead or fmShareDenyWrite);
                        permit := qrPermit;
                    except
                        permit := HandleError(AResponseInfo, qrError);
                    end
                end
                else
                    permit := HandleError(AResponseInfo, qrFileNotFound);

            end else
                if queriedAction = 'file_download' then
                begin
                    permit := ResponseFileDownload(ARequestInfo, AResponseInfo);
                end
                else
                    permit := qrDeny;
        end;
    end else
        permit := qrDeny;

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
