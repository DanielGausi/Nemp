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

MedienbibliothekClass, BibSearchClass
;

const
    // Messages für WebServer:
    WM_WebServer = WM_USER + 800;

    WS_QueryPlayer = 10;
    WS_QueryPlaylist = 1;
    WS_QueryPlaylistDetail = 2;

    WS_PlaylistPlayID = 3;

    WS_InsertNext = 4;
    WS_AddToPlaylist = 5;

    WS_PlaylistMoveUp = 7;
    WS_PlaylistMoveDown = 8;
    WS_PlaylistDelete = 9;


    //    WM_QueryPlaylistDownload = 5553;
    WS_PlaylistDownloadID = 6;


    WS_StringLog = 100;



const HTML_Header = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"'
                     + #13#10 + '"http://www.w3.org/TR/html4/loose.dtd">'
                     + #13#10 + '<html>'
                     + #13#10 + '<head>'
                     + #13#10 + '<title>Nemp Webserver</title>'
                     + #13#10 + '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
                     + #13#10 + '<meta name="viewport" content="width=320">'    // for iPhone.

                     + #13#10 + '<link href="main.css" rel="stylesheet" type="text/css">'
                     + #13#10 + '</head>'
                     + #13#10 + '<body>';
      HTML_Footer = '</body> </html>';

      // HTML_PlayerHeader = '<h2>Nemp: Player</h2>';
      // HTML_PlaylistHeader = '<h2>Nemp: Playlist</h2>';
      HTML_LibraryHeader = '<h2>Nemp: Library</h2>';
      HTML_DetailsHeader = '<h2>Nemp: File information</h2>';

      {HTML_PlaylistEntryPattern = '<li><div class="playlistentry">'
                    + #13#10 + '<table>'
                    + #13#10 + '<tr>'
                    + #13#10 + '<td class="title"><a href="playlist_details?id=%d">%s</a></td>'
                    + #13#10 + '<td class="duration">%s</td>'
                    + #13#10 + '</tr>'
                    + #13#10 + '</table>'
                    + #13#10 + '</div>'
                    + #13#10 + '</li>';

      HTML_PlaylistEntryCurrentPattern = '<li><div class="playlistentrycurrent">'
                    + #13#10 + '<table>'
                    + #13#10 + '<tr>'
                    + #13#10 + '<td class="title"><a href="playlist_details?id=%d">%s</a></td>'
                    + #13#10 + '<td class="duration">%s</td>'
                    + #13#10 + '</tr>'
                    + #13#10 + '</table>'
                    + #13#10 + '</div>'
                    + #13#10 + '</li>';

      HTML_PlaylistEntryFileNotFound = '<li><div class="playlistentry">'
                    + #13#10 + '<table class="filenotfound">'
                    + #13#10 + '<tr>'
                    + #13#10 + '<td class="title">%s</td>'
                    + #13#10 + '<td class="duration">%s</td>'
                    + #13#10 + '</tr>'
                    + #13#10 + '</table>'
                    + #13#10 + '</div>'
                    + #13#10 + '</li>';
      }

      HTML_SearchMedialibrary1 = '<form action="/search" method="get">'
                    + #13#10 + '<table width="100%">'
                    + #13#10 + '<tr><td>Search for:</td></tr>'
                    + #13#10 + '<tr><td width="100%"><input class="text" type="text" name="query" size=30 maxlength=100 value=""></td></tr>'
                    + #13#10 + '<tr><td><input type="submit" value="Search" class="button"></td></tr>'
                    + #13#10 + '</table>'
                    + #13#10 + '</form>' ;

      HTML_SearchResultPattern = '<li><div class="playlistentry">'
                    + #13#10 + '<table>'
                    + #13#10 + '<tr>'
                    + #13#10 + '<td class="title"><a href="library_details?id=%d">%s</a></td>'
                    + #13#10 + '<td class="duration">%s</td>'
                    + #13#10 + '</tr>'
                    + #13#10 + '</table>'
                    + #13#10 + '</div>'
                    + #13#10 + '</li>';


      HTML_SearchResultsHeader = '<h2>Search results</h2>'
                    +#13#10 + '<ul  class="searchresults">';

      HTML_SearchResultsFooter = '</ul>';


type
  TQueryResult = (qrPermit, qrDeny, qrRemoteControlDenied,
                  qrDownloadDenied, qrLibraryAccessDenied,
                  qrFileNotFound, qrInvalidParameter, qrError);


  TNempWebServer = class
      private
          fMainHandle: DWord;
          fMainWindowHandle: DWord; // Eventually we need 2 handles - Options and mainwindow
          // ???

          fCurrentMaxID: Integer; // oder Integer?
          //fCurrentIDmaxLib: Integer; // oder Integer?

          fWebMedienBib: TObjectlist;

          fHTML_Player: UTf8String;
          fHTML_PlaylistView: Utf8String;
          fHTML_PlaylistDetails: UTf8String;
          fQueriedPlaylistFilename: UnicodeString;

          fHTML_MedienbibSearchForPlay: UTf8String;

          fUsername: String;
          fPassword: String;

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
          PatternButtonNext : String;
          PatternButtonPlayPause : String;
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


          PatternMenu : String;

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
          PatternItemSearchDetails : String; // the item on the Search-Detail-Page

          PatternErrorPage: String;

          //PatternPlayerControl : String;
          //PatternPlayerData : String;
          {
          Pattern : String;
          Pattern : String;
          Pattern : String;
          Pattern : String;
          }


          function fGetUsername: String;
          procedure fSetUsername(Value: String);
          function fGetPassword: String;
          procedure fSetPassword(Value: String);

          procedure fSetOnlyLAN              (Value: Longbool);
          procedure fSetAllowPlaylistDownload(Value: Longbool);
          procedure fSetAllowLibraryAccess   (Value: Longbool);
          procedure fSetAllowRemoteControl   (Value: Longbool);

          function fGetOnlyLAN              : Longbool;
          function fGetAllowPlaylistDownload: Longbool;
          function fGetAllowLibraryAccess   : Longbool;
          function fGetAllowRemoteControl   : Longbool;

          procedure EnsureFileHasID(af: tAudioFile);

          function MainMenu(aPage: Integer = -1): String;
          //function fGenerateHTMLPlaylistActionMenu(aFilename: String; aID: Integer; isFile: Boolean): UTf8String;
          //function fGenerateHTMLMedienBibActionMenu(aFilename: String; aID: Integer): UTf8String;
          //function fGenerateHTMLPlayerActionMenu(Content, aFilename: String; aID: Integer; isFile: Boolean): UTf8String;

          function fGetCount: Integer;

          // replace basic Insert-tags like {{artist}} in a given pattern
          function fSetBasicFileData(af: TAudioFile; aPattern, baseClass: String): String;
          // replace InsertTags for Buttons
          function fSetFileButtons(af: TAudioFile; aPattern: String; aPage: Integer): String;

          function fSetControlButtons(aPattern: String): String;



          //property Mainmenu: UTf8String read fGenerateHTMLMainMenu;


          // The following methods have been methods of a WebServerForm-Class
          // ---->
          procedure logQuery(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; Permit: TQueryResult);
          procedure logQueryAuth(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo);

          function HandleError(AResponseInfo: TIdHTTPResponseInfo; Error: TQueryResult): TQueryResult;
          function GenerateErrorPage(aErrorMessage: String; aPage: Integer): String;

          procedure AddNoCacheHeader(AResponseInfo: TIdHTTPResponseInfo);
          function ResponsePlayer (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseClassicPlayerControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseClassicPlaylistControl(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponsePlaylistView (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponsePlaylistDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseCover (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          //function ResponsePlay (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult; //PlaylistEintrag
          //function ResponseInsertNext (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult; // MedienBib-Eintrag
          //function ResponseAddToPlaylist (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult; // MedienBib-Eintrag

          //function ResponseDownloadFromPlaylist (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseFileDownload (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          function ResponseSearchInLibrary (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
          function ResponseLibraryDetails (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;

          procedure IdHTTPServer1CommandGet(AContext: TIdContext;
              ARequestInfo: TIdHTTPRequestInfo;
              AResponseInfo: TIdHTTPResponseInfo);

          // ---->

          procedure SetActive(Value: Boolean);
          procedure LoadTemplates;



      public
          SavePath: UnicodeString;
          CoverSavePath: UnicodeString;

          // Loglist logs all access to Webserver.
          // Note: Access this list only from VCL-Thread!
          //       IDhttpServer will add strings via SendMessage.
          LogList: TStringList;


          property Username: string read fGetUsername write fSetUsername;
          property Password: string read fGetPassword write fSetPassword;
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

          // Im VCL-Thread ausführen, mit CS geschützt
          // d.h. Message an Form Senden, die das dann ausführt

          function ValidIP(aIP, bIP: String): Boolean;
          procedure QueryPlayer; // Message senden...

          procedure QueryPlaylist; // Message senden...
          procedure QueryPlaylistDetails(aID: Integer);

          // konvertiert die Playlist in ein HTML-Formular
          // in VCL-Threads ausführen, mit CS geschützt

          //function HTMLDenied: UTf8String;
          //function HTMLRemoteControlDenied: UTf8String;
          //function HTMLInvalidParameter: UTf8String;
          //function HTMLDownloadDenied: UTf8String;
          //function HTMLLibraryAccessDenied: UTf8String;
          //function HTMLFileNotFound: UTf8String;
          //function HTMLError: UTf8String;


          procedure GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer);
          procedure GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist);
          procedure GenerateHTMLfromPlaylist_Details(aAudioFile: TAudioFile; aIdx: Integer);

          // Das kann im Indy-Thread geamcht werden, daher mit Result
          function GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString): UTf8String;
          function GenerateHTMLfromMedienbibSearch_Details(aAudioFile: TAudioFile): UTf8String;


          procedure Shutdown;
          procedure CopyLibrary(OriginalLib: TMedienBibliothek);

          procedure SearchLibrary(Keyword: UnicodeString; DestList: TObjectlist);
          function GetAudioFileFromWebServerID(aID: Integer): TAudioFile;

  end;

var
    CS_AccessHTMLCode: RTL_CRITICAL_SECTION;
    CS_AccessPlaylistFilename: RTL_CRITICAL_SECTION;
    CS_AccessLibrary: RTL_CRITICAL_SECTION;
    CS_Authentification: RTL_CRITICAL_SECTION;

implementation

uses Nemp_RessourceStrings;



constructor TNempWebServer.Create(aHandle: DWord);
begin
    inherited create;
    fMainHandle := aHandle;
    fMainWindowHandle := aHandle;
    fCurrentMaxID  := 1;
    // fCurrentIDmaxLib := 1;
    fWebMedienBib := TObjectlist.Create(False);
    IdHTTPServer1 := TIdHTTPServer.Create(Nil);
    IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;
    GetLocaleFormatSettings(LOCALE_USER_DEFAULT, fLocalFormatSettings);
    fLocalDir := ExtractFilePath(Paramstr(0)) + 'HTML\classic\';
    Username := 'admin';
    Password := 'pass';
    LogList := TStringList.Create;
end;

destructor TNempWebServer.Destroy;
var i: Integer;
begin
    IdHTTPServer1.Active := False;
    EnterCriticalSection(CS_AccessLibrary);
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
        Username           := Ini.ReadString('Remote', 'Username'        , 'admin');
        Password           := Ini.ReadString('Remote', 'Password'        , 'pass');
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
      Ini.WriteString('Remote', 'Username'        , Username);
      Ini.WriteString('Remote', 'Password'        , Password);
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
        result := StringReplace(result, '{{PlayerClass}}', 'Player active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlayerClass}}', 'Player', [rfReplaceAll]);

    if aPage = 1 then
        result := StringReplace(result, '{{PlaylistClass}}', 'Playlist active', [rfReplaceAll])
    else
        result := StringReplace(result, '{{PlaylistClass}}', 'Playlist', [rfReplaceAll]);

    if AllowLibraryAccess then
    begin
        if aPage = 2 then
            result := StringReplace(result, '{{LibraryClass}}', 'Library active', [rfReplaceAll])
        else
            result := StringReplace(result, '{{LibraryClass}}', 'Library', [rfReplaceAll]);
    end
    else
        result := StringReplace(result, '{{LibraryClass}}', 'hidden', [rfReplaceAll]);
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

{
function TNempWebServer.fGenerateHTMLPlaylistActionMenu(aFilename: String; aID: Integer; isFile: Boolean): UTf8String;
begin
    if Not isFile then
    begin
        if AllowRemoteControl then
        begin
            result := '<div class="actionmenu">'
                      + #13#10 + '<ul class="actionmenu">';
            if AllowRemoteControl then
                result := result + #13#10 + '<li> <a href="play?id=' + UTf8String(IntToStr(aID)) + '">Play now</a></li>';
            result := result + #13#10 + '</ul>'
                         + #13#10 + '</div>';
        end else
            result := '';

    end else
    begin
        if AllowFileDownload or AllowRemoteControl then
        begin
            result := '<div class="actionmenu">'
                      + #13#10 + '<ul class="actionmenu">';
            if AllowFileDownload then
                result := result + #13#10 + '<li> <a href="' +
                HRefEncode((aFilename)) + '?id=' + UTf8String(IntToStr(aID)) + '&Action=download_pl">Download</a></li>';
            if AllowRemoteControl then
                result := result + #13#10 + '<li> <a href="play?id=' + UTf8String(IntToStr(aID)) + '">Play now</a></li>';

            result := result + #13#10 + '</ul>'
                         + #13#10 + '</div>';
        end else
            result := '';
    end;
end;
function TNempWebServer.fGenerateHTMLMedienBibActionMenu(aFilename: String; aID: Integer): UTf8String;
begin
    result := '<div class="actionmenu">'
                  + #13#10 + '<ul class="actionmenu">';
    result := result + #13#10 +
          //'<li> <a href="' + +  'download_lib?id=' + IntToStr(aID) + '">Download</a></li>';
          '<li> <a href="' + HRefEncode((aFilename)) + '?id=' + UTf8String(IntToStr(aID)) + '&Action=download_lib">Download</a></li>';

    if AllowRemoteControl then
    begin
        result := result + #13#10 + '<li> <a href="insertnext?id=' + UTf8String(IntToStr(aID)) + '">Play next</a></li>';
        result := result + #13#10 + '<li> <a href="addtoplaylist?id=' + UTf8String(IntToStr(aID)) + '">Add to playlist</a></li>';
    end;

    result := result + #13#10 + '</ul>'
                     + #13#10 + '</div>';
end;
       }
       (*
function TNempWebServer.fGenerateHTMLPlayerActionMenu(Content, aFilename: String; aID: Integer; isFile: Boolean): UTf8String;
var btnDL, btnPlayPause, btnStop, btnNext, btnPrev: String;
    buttons: String;
begin
   // if AllowFileDownload and isFile then
   // begin
   //     btnDL := PatternButtonFileDownload;
   //     btnDL := StringReplace(btnDL, '{{filename}}', HRefEncode((aFilename)), [rfReplaceAll]);
   //     btnDL := StringReplace(btnDL, '{{ID}}', IntToStr(aID), [rfReplaceAll]);
   //     btnDL := StringReplace(btnDL, '{{mode}}', 'download_pl', [rfReplaceAll]);
   // end else
   //     btnDL := '';

    if AllowRemoteControl then
    begin
        btnPlayPause := PatternButtonPlayPause;
        btnStop := PatternButtonStop;
        btnNext := PatternButtonNext;
        btnPrev := PatternButtonPrev;
    end else
    begin
        btnPlayPause := '';
        btnStop := '';
        btnNext := '';
        btnPrev := '';
    end;

    buttons := Content;
    // buttons := StringReplace(buttons, '{{buttonDownload}}', btnDL, [rfReplaceAll]);
    buttons := StringReplace(buttons, '{{buttonPlayPause}}', btnPlayPause , [rfReplaceAll]);
    buttons := StringReplace(buttons, '{{buttonStop}}', btnStop, [rfReplaceAll]);
    buttons := StringReplace(buttons, '{{buttonNext}}', btnNext, [rfReplaceAll]);
    buttons := StringReplace(buttons, '{{buttonPrev}}', btnPrev, [rfReplaceAll]);

    result := buttons;
end;    *)
        {
function TNempWebServer.HTMLDenied: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Access denied.</div>' + HTML_Footer;
end;

function TNempWebServer.HTMLRemoteControlDenied: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Remote control denied.</div>' + HTML_Footer;
end;

function TNempWebServer.HTMLInvalidParameter: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Invalid parameter.</div>' + HTML_Footer;
end;

function TNempWebServer.HTMLDownloadDenied: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Download denied.</div>' + HTML_Footer;
end;
function TNempWebServer.HTMLLibraryAccessDenied: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Library access denied.</div>' + HTML_Footer;
end;
function TNempWebServer.HTMLFileNotFound: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">File not found.</div>' + HTML_Footer;
end;
function TNempWebServer.HTMLError: UTf8String;
begin
    result := HTML_Header + Mainmenu + '<div class="error">Some error occured. Please try again.</div>' + HTML_Footer;
end;
}

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
    result := StringReplace(result, '{{Title}}'    , EscapeHTMLChars(af.Titel), [rfReplaceAll]);
    result := StringReplace(result, '{{Artist}}'   , EscapeHTMLChars(af.Artist), [rfReplaceAll]);
    result := StringReplace(result, '{{Album}}'    , EscapeHTMLChars(af.Album), [rfReplaceAll]);

    result := StringReplace(result, '{{Duration}}'  , duration, [rfReplaceAll]);
    result := StringReplace(result, '{{Size}}'      , EscapeHTMLChars(filesize), [rfReplaceAll]);
    result := StringReplace(result, '{{Filetype}}'  , EscapeHTMLChars(filetype), [rfReplaceAll]);
    result := StringReplace(result, '{{URL}}'       , EscapeHTMLChars(path), [rfReplaceAll]);
    result := StringReplace(result, '{{Quality}}'   , EscapeHTMLChars(quality), [rfReplaceAll]);

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

function TNempWebServer.fSetControlButtons(aPattern: String): String;
var buttons: String;
begin
    buttons := aPattern;
    if AllowRemoteControl then
    begin
        buttons := StringReplace(buttons, '{{BtnControlPlayPause}}', PatternButtonPlayPause , [rfReplaceAll]);
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


procedure TNempWebServer.QueryPlayer;
begin
    SendMessage(fMainHandle, WM_WebServer, WS_QueryPlayer, 0);
end;

procedure TNempWebServer.GenerateHTMLfromPlayer(aNempPlayer: TNempPlayer);
var menu, PageData, PlayerData: String;
    af: TAudioFile;
begin
    menu := MainMenu(0);
    af := aNempPlayer.MainAudioFile;
    if assigned(af) then
    begin
        // ID generieren/setzen
        EnsureFileHasID(af);

        PlayerData := PatternItemPlayer;
        PlayerData := StringReplace(PlayerData, '{{ID}}'    , IntToStr(af.WebServerID), [rfReplaceAll]);
        PlayerData := fSetBasicFileData(af, PlayerData, '');
        PlayerData := fSetFileButtons(af, PlayerData, 0);

        PageData := PatternPlayerPage;
        PageData := fSetControlButtons(PatternPlayerPage);
        PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{ItemPlayer}}', PlayerData, [rfReplaceAll]);
    end else
    begin
        PageData := GenerateErrorPage(WebServer_NoFile, 0);
    end;

    HTML_Player := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;


procedure TNempWebServer.QueryPlaylist; // Message senden...
begin
    SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylist, 0);
end;

// konvertiert die Playlist in ein HTML-Formular
// in VCL-Threads ausführen. Zugriff auf den HTML-String ist durch den Setter Threadsafe.
procedure TNempWebServer.GenerateHTMLfromPlaylist_View(aNempPlayList: TNempPlaylist);
var i: Integer;
    af: TAudioFile;
    aClass: String;
    Item, Items, PageData: String;
    menu: String;

begin
    Items := '';
    menu := MainMenu(1);

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

    PageData := PatternPlaylistPage;
    PageData := StringReplace(PageData, '{{Menu}}', menu, [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{PlaylistItems}}', Items, [rfReplaceAll]);

    HTML_PlaylistView := UTF8String(StringReplace(PatternBody, '{{Content}}', PageData, [rfReplaceAll]));
end;

procedure TNempWebServer.QueryPlaylistDetails(aID: Integer);
begin
    // dadurch wird im VCL-Thread das AudioFile zur ID ermittelt
    // und die nachfolgende Prozedur aufgerufen
    SendMessage(fMainHandle, WM_WebServer, WS_QueryPlaylistDetail, aID);
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


function TNempWebServer.GenerateHTMLMedienbibSearchFormular(aSearchString: UnicodeString): UTf8String;
var ResultList: TObjectlist;
    af: TAudioFile;
    i: Integer;
    aClass, PageData, menu, Item, Items: String;
begin
    menu := Mainmenu(2);

    if aSearchString = '' then
        PageData := PatternSearchPage
    else
        PageData := PatternSearchResultPage;

    PageData := StringReplace(PageData, '{{Menu}}'        , menu         , [rfReplaceAll]);
    PageData := StringReplace(PageData, '{{SearchString}}', aSearchString, [rfReplaceAll]);

    if aSearchString <> '' then
    begin
        Items := '';

        ResultList := TObjectList.Create(False);
        try
            SearchLibrary(aSearchString, ResultList);
            if ResultList.Count > 0 then
            begin
                for i := 0 to ResultList.Count - 1 do
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
            PageData := StringReplace(PageData, '{{SearchResultItems}}', Items, [rfReplaceAll]);
            PageData := StringReplace(PageData, '{{SearchCount}}', IntToStr(ResultList.Count), [rfReplaceAll]);
        finally
            ResultList.Free;
        end;
    end else
    begin
        PageData := StringReplace(PageData, '{{SearchResultItems}}', '', [rfReplaceAll]);
        PageData := StringReplace(PageData, '{{SearchCount}}', '0', [rfReplaceAll]);
    end;

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
begin
    sl := TStringList.Create;
    try
        sl.LoadFromFile(fLocalDir + 'Body.tpl');
        PatternBody := sl.Text;

        // Buttons for Player Control
        sl.LoadFromFile(fLocalDir + 'BtnControlNext.tpl');
        PatternButtonNext := sl.Text;
        sl.LoadFromFile(fLocalDir + 'BtnControlPlayPause.tpl');
        PatternButtonPlayPause := sl.Text;
        sl.LoadFromFile(fLocalDir + 'BtnControlPrev.tpl');
        PatternButtonPrev := sl.Text;
        sl.LoadFromFile(fLocalDir + 'BtnControlStop.tpl');
        PatternButtonStop := sl.Text;
        sl.LoadFromFile(fLocalDir + 'Menu.tpl');
        PatternMenu := sl.Text;

        // Buttons for File-Handling
        sl.LoadFromFile(fLocalDir + 'BtnFileDownload.tpl');
        PatternButtonFileDownload := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFilePlayNow.tpl');
        PatternButtonFilePlayNow := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFileAdd.tpl');
        PatternButtonFileAdd := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFileAddNext.tpl');
        PatternButtonFileAddNext := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFileMoveUp.tpl');
        PatternButtonFileMoveUp := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFileMoveDown.tpl');
        PatternButtonFileMoveDown := trim(sl.Text);
        sl.LoadFromFile(fLocalDir + 'BtnFileDelete.tpl');
        PatternButtonFileDelete := trim(sl.Text);


        // The PLAYER page
        sl.LoadFromFile(fLocalDir + 'ItemPlayer.tpl');
        PatternItemPlayer := sl.Text;
        sl.LoadFromFile(fLocalDir + 'PagePlayer.tpl');
        PatternPlayerPage := sl.Text;

        // The PLAYLIST page
        sl.LoadFromFile(fLocalDir + 'PagePlaylist.tpl');
        PatternPlaylistPage := sl.Text;
        sl.LoadFromFile(fLocalDir + 'ItemPlaylist.tpl');
        PatternItemPlaylist := sl.Text;

        // The PLAYLIST DETAILS page
        sl.LoadFromFile(fLocalDir + 'PagePlaylistDetails.tpl');
        PatternPlaylistDetailsPage := sl.Text;
        sl.LoadFromFile(fLocalDir + 'ItemPlaylistDetails.tpl');
        PatternItemPlaylistDetails := sl.Text;

        // The LIBRARY page
        sl.LoadFromFile(fLocalDir + 'PageLibrary.tpl');
        PatternSearchPage := sl.Text;
        sl.LoadFromFile(fLocalDir + 'PageLibrarySearchResults.tpl');
        PatternSearchResultPage := sl.Text;
        sl.LoadFromFile(fLocalDir + 'ItemSearchResult.tpl');
        PatternItemSearchlist := sl.Text;

        // The LIBRARY DETAILS page
        sl.LoadFromFile(fLocalDir + 'PageLibraryDetails.tpl');
        PatternSearchDetailsPage := sl.Text;
        sl.LoadFromFile(fLocalDir + 'ItemSearchDetails.tpl');
        PatternItemSearchDetails := sl.Text;

        // The ERROR page
        sl.LoadFromFile(fLocalDir + 'PageError.tpl');
        PatternErrorPage := sl.Text;
    finally
        sl.Free;
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
            QueryPlayer;
            html := HTML_Player;
            LeaveCriticalSection(CS_AccessHTMLCode);
        if html = '' then html := ' ';
        ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
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
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID) = 1 then
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
            if  SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistDelete, queriedID) = 1 then
            begin
                // todo: Hier ggf. ein result erwarten und auswerten?
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
                result := qrPermit;
            end else
                result := HandleError(AResponseInfo, qrInvalidParameter);
        end;

        /// file_add
        /// file_addNext                     /insertnext
        ///  delete
        ///  moveUp                          /addtoplaylist
        ///  MoveDown

        //SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_STOP, 0);
        {else
        if queriedAction = 'playpause' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PLAY, 0)
        else
        if queriedAction = 'next' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_NEXTTITLE, 0)
        else
        if queriedAction = 'previous' then SendMessage(fMainWindowHandle, WM_COMMAND, NEMP_BUTTON_PREVTITLE, 0)
        else
            result := qrInvalidParameter;
        }
        //AResponseInfo.Redirect('/playlist');
        //AResponseInfo.ContentStream := Nil;
    end else
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
            QueryPlaylist;
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
        QueryPlaylistDetails(queriedID);
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


        (*
function TNempWebServer.ResponsePlay (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult;
var queriedID: Integer;
begin
    if AllowRemoteControl then
    begin
        queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
        SendMessage(fMainWindowHandle, WM_WebServer, WS_PlaylistPlayID, queriedID);
        AResponseInfo.Redirect('/playlist');
        AResponseInfo.ContentStream := Nil;
        result := qrPermit;
    end else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied)
    end;
end;

function TNempWebServer.ResponseInsertNext (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult; // MedienBib-Eintrag
var queriedID: Integer;
    af: TAudioFile;
begin
    if AllowRemoteControl then
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
            end else // not in bib
            begin
                result := HandleError(AResponseInfo, qrInvalidParameter);
            end;
        LeaveCriticalSection(CS_AccessLibrary);
    end else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied);
    end;
end;

function TNempWebServer.ResponseAddToPlaylist (ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): TQueryResult; // MedienBib-Eintrag
var queriedID: Integer;
    af: TAudioFile;
begin
    if AllowRemoteControl then
    begin
        EnterCriticalSection(CS_AccessLibrary);
            result := qrPermit;
            queriedID := StrToIntDef(aRequestInfo.Params.Values['ID'], 0);
            af := GetAudioFileFromWebServerID(queriedID);
            if assigned(af) then
            begin
                // sende Audiofile an Nemp-Hauptfenster/playlist
                SendMessage(fMainWindowHandle, WM_WebServer, WS_AddToPlaylist, LParam(af));
                AResponseInfo.Redirect('/playlist');
                AResponseInfo.ContentStream := Nil;
            end else
            begin
                result := HandleError(AResponseInfo, qrInvalidParameter);
            end;
        LeaveCriticalSection(CS_AccessLibrary);
    end else
    begin
        result := HandleError(AResponseInfo, qrRemoteControlDenied);
    end;
end;
*)


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
    i: Integer;

begin
    if AllowLibraryAccess then
    begin

        i := pos('=', ARequestInfo.UnparsedParams);
        if i > 0 then
        begin
            // UnparsedParams sollte nur Ascii-Zeichen anthalten - also ist das ok
            a := AnsiString(copy(ARequestInfo.UnparsedParams, i+1, length(ARequestInfo.UnparsedParams) - i));
            // die Parameter sind utf-kodiert als %12%43%82%20 ...
            // also: Die %xx in UTF8String dekodieren, das Ergebnis zu UnicodeString
            SearchString := Utf8ToString(utf8URLDecode(a));
        end else
            SearchString := '';

        ms := TMemoryStream.Create;


        html := GenerateHTMLMedienbibSearchFormular(searchstring);
        if html = '' then html := ' ';
            ms.Write(html[1], length(html));
        AddNoCacheHeader(AResponseInfo);
        AResponseInfo.ContentStream := ms;
        result := qrPermit;
    end else
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
                AddNoCacheHeader(AResponseInfo);
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
        if RequestedDocument = '/cover' then permit := ResponseCover(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playercontrol' then permit := ResponseClassicPlayerControl(ARequestInfo, AResponseInfo)
        else
        if RequestedDocument = '/playlistcontrol' then permit := ResponseClassicPlaylistControl(ARequestInfo, AResponseInfo)
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
