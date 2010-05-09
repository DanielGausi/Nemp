{

    Unit ScrobblerUtils

    - a class to "Scrobble"

    Note: This Unit _IS NOT_ the same as the "ScrobblerUtils" that can be downloaded
          at my website. Here are some minor changes, e.g. key/secret, version etc.

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

unit ScrobblerUtils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StrUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, IdException,
  Dialogs, md5, StdCtrls, ShellApi, DateUtils, IniFiles, Contnrs, 

  AudioFileClass,
  Systemhelper, Nemp_RessourceStrings, Hilfsfunktionen;

const
    UnixStartDate: TDateTime = 25569.0;

    BaseApiURL = 'http://ws.audioscrobbler.com/2.0/';
    BaseScrobbleURL = 'http://post.audioscrobbler.com/';

    api_key = '542ec0c3e5e7b84030181176f3d0f264';
    // Note: This is a poor attempt to hide my "lastFM-secret" a little bit.
    // I know, that you are able to get it within a few seconds ;-)
    bd7fab7ec5900abf : Array[0..15] of Byte = ( $8a, $60, $99, $bf, $55, $74, $b4, $8a, $08, $46, $ff, $18, $49, $9e, $a2, $7c);
    effa65ecb689fccd : Array[0..15] of Byte = ( $95, $7b, $d2, $30, $20, $a0, $2c, $48, $d4, $4b, $3d, $25, $25, $e3, $4f, $4f);

    // Some Message-Constants
    WM_Scrobbler = WM_User + 850;

    SC_Message = 1000;

    SC_HandShakeError = 1;
    SC_HandShakeCancelled = 2;
    SC_HandShakeException = 3;

    SC_NowPlayingError = 4;
    SC_NowPlayingException = 5;

    SC_SubmissionError = 6;
    SC_SubmissionException = 7;

    SC_GetToken = 10;
    SC_GetTokenException = 11;

    SC_GetSession = 12;
    SC_GetSessionException = 13;

    SC_HandShakeComplete = 14;
    SC_NowPlayingComplete = 15;
    SC_SubmissionComplete = 16;
    SC_SubmissionSkipped = 17;

    SC_BeginWork = 50;
    SC_EndWork = 51;
    SC_TooMuchErrors = 100;

type

    TScrobbleStatus = (hs_OK=1, hs_EXCEPTION, hs_UnknownFailure, hs_UNAUTHORIZED, hs_BANNED, hs_BADAUTH, hs_BADTIME, hs_FAILED, hs_BADSESSION, hs_HANDSHAKECANCELLED);

const

    ScrobbleStatusStrings: Array[1..10] of String =
        ( '(OK)',
          '(Exception)',
          '(Unknown failure.)',
          'Unauthorized. Please reconfigure scrobbling. ',
          'Client banned. Please update Nemp',
          'Bad Authorization. Please reconfigure scrobbling. ',
          'Bad Time. Please check your Windows date/time settings.',
          'Server Failure. Please try again later.',
          'Bad Session. New handshake required.',
          'Too much Errors occured. Handshaking disabled for some time.'    );

type

    TScrobbleFile = Class
          Artist: UTF8String;
          Title: UTF8String;
          Album: UTF8String;
          Length: UTF8String;     // Lengt of the Track in seconds, '' if unknown
          TrackNr: UTF8String;    // TrackNumber, '' if unknown
          MBTrackID: UTF8String;  // Music-Brainz-TrackID. Whatever it ist - I do not support it yet.

          DisplayTitle: String;
          // zusätzlich fürs Submitten:
          StartTime: UTF8String;
          Source: UTF8String;
          Rating: UTF8String;

          procedure Assign(aAudioFile: TAudioFile; aStartTimeUTC: TSystemTime);
          procedure CopyFrom(aScrobbleFile: TScrobbleFile);
    end;

    TScrobbler = class
      private
          // private Felder für die Dinger, die sich nicht ändern bei den Post/Get-Anfragen
          // im Constructor setzen
          p: String; //  = 'p=1.2.1' // Protokoll-Version
          c: String; // Client-ID      // noch zu beschaffen. erstmal: 'c=tst'
          v: String; // Client-Version //                     erstmal: 'v=1.0'

          fWindowHandle: HWND; // Handle zum Scrobble-Fenster zum Schicken der Nachrichten (Parameter im Create)
          fThread: Integer;

          fIDHttp: TIdHttp;
          //Die "f"-Methoden werden in einem separaten Thread ausgeführt.

          // Authentifizierung
          // -----------------------------------
          // GetToken: Schritt 1
          // Liefert ein Token zurück. Dieses ist ca. eine Stunde gültig
          // und muss vom LastFM-User authentifiziert werden.
          // Dies Geschieht im Browser über einen Speziellen Link, der
          // eben dieses Token enthält
          // Darüber wird "Nemp" erlaubt, im Userprofil zu arbeiten.
          procedure fGetToken;

          // Schritt 2: Nutzer klickt im Browser auf "OK - Nemp darf"

          // GetSession: Schritt 3
          // Das vorher authentifizierte Token wird benutzt, um einen
          // Session-KEY zu erhalten. In der Antwort vom LastFM-Server
          // ist der Username und eben dieser Session-Key enthalten.
          // Der Session-Key ist beliebig lange gültig. und kann z.B.
          // in einer Ini-Datei gespeichert werden und später wiederverwendet
          // werden
          // Der User kann Nemp in seinem Profil deaktivieren - dann
          // erst wird der Session-Key ungültig
          procedure fGetSession;


          // Scrobbling
          // ---------------------------------------
          // Handshake:
          // Username und Session-Key werden benutzt, um eine Scrobbling-Session
          // zu starten.
          // Antwort enthält eine Session-ID, sowie zwei Links zur weiteren
          // Kommunikation. Ist einmal beim Start von Nemp nötig
          // Fehler:
          // BANNED: Nemp hat zu oft Mist gebaut und darf nicht mehr mit LastFM spielen. => Nemp-Update
          // BADAUTH: Wahrscheinlich Username, Session-KEY, oder auth-Token (gebildet aus "Secret")
          //          falsch. => Neu authentifizieren
          // BADTIME: Uhr geht falsch. => User soll Uhr neu stellen.
          // FAILED <reason>: Server-Fehler => Später nochmal probieren
          function fPerformHandShake: TScrobbleStatus;
          function ParseHandShakeResult(aResponse: string): TScrobbleStatus;

          // NowPlaying:
          // Session-ID und eine der Links wird verwendet, um Daten über das
          // aktuelle AudioFile zu senden
          // Fehler:
          // BADSESSION: Session-ID ungültig. => Neuer Handshake.
          function fPerformNowPlayingNotification: TScrobbleStatus;
          function fPerformSubmissionNotification: TScrobbleStatus;

          function ParseNowPlayingResult(aResponse: string): TScrobbleStatus;
          function ParseSubmissionResult(aResponse: string): TScrobbleStatus;

          procedure fScrobbleNowPlaying;
          procedure fScrobbleSubmit;

      public
          Token: String;   // Über GetToken ermitteln lassen

          // GetSession
          Username: String;     // Name des LastFM-Users
          SessionKey: String;   // Session-Key fürs Scrobblen. Muss (einmalig) über diverse Funktionen angefordert werden.

          // fürs "NowPlaying"
          SessionID: String;
          NowPlayingURL: String;
          SubmissionURL: String;

          ParamList: TStrings;

          SuccessMessage: String;
          EarliestNextHandshake: TDateTime;

          constructor Create(aHandle: HWnd);
          destructor Destroy; override;

          // Startet Thread
          procedure GetToken;
          procedure GetSession;       // Als Parameter das Token nehmen? Ja.
          procedure ScrobbleNowPlaying;      // Als Parameter ein AudioFile liefern? Und die ganzen Variablen ins Private verschieben? Ja. ;-)
          procedure ScrobbleSubmit;

          function GetUTCTimeStamp: String;
  end;

    TNempScrobbler = class
        private
            fMainWindowHandle: HWND;
            ErrorInARowCount: Integer;

            StartTimeUTC: TSystemTime;
            StartTimeLocal: TDateTime;
            PlayAmount: Integer; // in Seconds

            // Gibt an, ob gerade gescrobbelt wird.
            fWorking: Boolean;
            FScrobbleJobCount: Integer;

            fNewFile: Boolean; // gibt an, ob was neues da ist: Könnte ja sein, dass beim NP-Scrobbeln das File direkt neu gesetzt wird.
            fPlayingFile: TScrobbleFile;
            fCurrentFileAdded: Boolean;

            EarliestNextHandshake: TDateTime;
            TimeToWaitInterval: Integer;

            // LastFM allows only 5 calls per Second
            // The GetTag-Method will be calles very often - so we need a speed-limit here!
            fLastCall: DWord;

            // Setzt fWorking und setzt eine Message ab.
            procedure BeginWork;
            procedure EndWork;

            procedure ScrobbleCurrentFile;
            procedure ScrobbleJobList;

            function EncodeSessionKey(PlainKey: String): String;
            function DecodeSessionKey(CryptedKey: String): String;

            // Parse GetTags-RawString (XML-structure)
            // result: tag1(count1), tag2(count2), ...
            function ParseRawTag(aRawString: String; aAudioFile: TAudioFile): String;


        public
            SessionKey: String; // Der quasi allzeit gültige Session-Key  // "Sicher" in Ini-Datei speichern
            Username: String; // Der Username des LastFM-Users            // in Ini-Datei speichern

            AlwaysScrobble: Boolean; // Immer Scrobbeln, beim Start von Nemp aktivieren, in Ini speichern

            DoScrobble: Boolean; // Laufzeit-Variable, kann vom User manuell gesetzt werden. (Übers Tools-Menü)
            IgnoreErrors: Boolean;
            Status: TScrobbleStatus;                                      // Status des Scrobblers. Nur Socrobblen, wenn "OK"

            Token: String;            // getToken-Ergebnis. Muss der LastFM-User authentifizieren
            SessionID: String;        // Erhält man beim Handshake
            NowPlayingURL: String;    // Erhält man beim Handshake
            SubmissionURL: String;    // Erhält man beim Handshake

            JobList: TObjectList;
            LogList: TStrings;

            property Working: Boolean Read fWorking; 
            constructor Create(aHandle: HWND);
            destructor Destroy; override;

            procedure LoadFromIni(Ini: TMemIniFile);
            procedure SaveToIni(Ini: TMemIniFile);

            // Wenn man was gescrobbelt hat, könnte in der Zwischenzeit was neues dazu gekommen sein, oder sich geändert haben
            // daher: Beim "OK" sollte die VCL das anstoßen
            procedure ScrobbleNext(PlayerIsPlaying: Boolean);
            procedure ScrobbleNextCurrentFile(PlayerIsPlaying: Boolean);

            // wird in den Message-Handlern bei Fehlern aufgerufen
            Procedure ScrobbleAgain(PlayerIsPlaying: Boolean);

            //Neue Routinen, die von außen das Scrobbeln anleiern sollen:
            function AddToScrobbleList(IsJustPlaying: Boolean): Boolean; // result: hinzugefügt oder nicht
            procedure ChangeCurrentPlayingFile(aAudioFile: TAudioFile); // setzt das aktuelle Audiofile um und scrobbelt es ggf.

            procedure HandleHandshakeFailure(aFailure: TScrobbleStatus);
            procedure CountError(aFailure: TScrobbleStatus);
            procedure CountSuccess;

            procedure PlaybackStarted;
            procedure PlaybackPaused;
            procedure PlaybackResumed;

            procedure AllowHandShakingAgain;

            // Additional Methods

            // Get the Tags for an AudioFile
            // No Authorization required. No Thread
            //  - calling function (MedienBib.GetTags?) should create a Thread
            function GetTags(aAudioFile: tAudioFile): String;

    end;


  procedure StartGetToken(Scrobbler: TScrobbler);
  procedure StartGetSession(Scrobbler: TScrobbler);

  procedure StartScrobbleNowPlaying(Scrobbler: TScrobbler);
  procedure StartScrobbleSubmit(Scrobbler: TScrobbler);

  //Ermittelt aus einer Server-Antwort das Token
  function GetTokenFromResponse(aResponseString: String): String;
  // Ermittelt aus einer Server-Antwort den Usernamen des LastFM-Accounts
  function GetUserNameFromResponse(aResponseString: String): String;
  // Ermittelt den (allzeit gültigen) Session-Key aus der Server-Antwort
  function GetSessionKeyFromResponse(aResponseString: String): String;


implementation



function faae65f530febc67: string;
var i: integer;
begin
    result := '';
    for i := 0 to 15 do
        result := result + IntToHex( (bd7fab7ec5900abf[i] + effa65ecb689fccd[i]) mod 256, 2);

    result := lowercase(result);
end;


// Einige lose Funktionen. Werden im Hauptthread ausgeführt und liefern der Anwendung
// Daten für den weiteren Verlauf des "Scrobbelns"

// Ermitteln eines Tokens. Erwartetes Format:
            {
             <?xml
            version="1.0"
            encoding="utf-8"?>
            <lfm
            status="ok">
            <token>  (md5-Hash-String)  </token></lfm>
            }
function GetTokenFromResponse(aResponseString: String): String;
var idx: Integer;
begin
    idx := Pos('<token>', aResponseString );
    if idx >= 1 then
        result := copy(aResponseString, idx + length('<token>'), 32)
    else
        result := '';
end;

  // Ermittelt aus einer Server-Antwort den Usernamen des LastFM-Accounts. Format:
            {
            <?xml
            version="1.0"
            encoding="utf-8"?>
            <lfm
            status="ok">
            <session>
            <name>someUsername</name>                                 !!!
            <key>some MD5-like string</key>         !!!
            <subscriber>0</subscriber>
            </session></lfm>
            }
function GetUserNameFromResponse(aResponseString: String): String;
var start, ende: Integer;
begin
    start := Pos('<name>', aResponseString);
    ende  := Pos('</name>', aResponseString);
    if (start < ende) and (ende > 1) then
        result := copy(aResponseString, start + length('<name>'), ende - (start + length('<name>')) )
    else
        result := '';
end;
  // Ermittelt den (allzeit gültigen) Session-Key aus der Server-Antwort. Format wie bei Username
function GetSessionKeyFromResponse(aResponseString: String): String;
var idx: Integer;
begin
    idx := Pos('<key>', aResponseString );
    if idx >= 1 then
        result := copy(aResponseString, idx + length('<key>'), 32)
    else
        result := '';
end;


// von den Indys abgeguckt
function ParamsEncode(const ASrc: UTF8String): UTF8String;
var i: Integer;
begin
  Result := '';
  for i := 1 to Length(ASrc) do
  begin
    if (ASrc[i] in ['&', '*','#','%','<','>',' ','[',']'])
       or (not (ASrc[i] in [#33..#128]))
    then
    begin
      Result := Result + UTF8Encode('%' + IntToHex(Ord(ASrc[i]), 2));
    end
    else
    begin
      Result := Result + UTF8Encode(ASrc[i]);
    end;
  end;
end;


procedure TScrobbleFile.Assign(aAudioFile: TAudioFile; aStartTimeUTC: TSystemTime);
var StartTimeDelphi: TDateTime;
    diff: LongInt;
begin
    DisplayTitle := aAudioFile.Artist + ' - ' + aAudioFile.Titel;

    Artist := ParamsEncode(UTF8Encode(aAudioFile.Artist));
    Title  := ParamsEncode(UTF8Encode(aAudioFile.Titel));
    Album  := ParamsEncode(UTF8Encode(aAudioFile.Album));
    Length := UTF8Encode(IntToStr(aAudioFile.Duration));
    MBTrackID := '';

    if aAudioFile.Track <> 0 then
        TrackNr := UTF8Encode(IntToStr(aAudioFile.Track))
    else
        TrackNr := '';

    // zusätzlich fürs Submitten:
    StartTimeDelphi := EncodeDateTime(aStartTimeUTC.wYear, aStartTimeUTC.wMonth, aStartTimeUTC.wDay, aStartTimeUTC.wHour, aStartTimeUTC.wMinute, aStartTimeUTC.wSecond, aStartTimeUTC.wMilliSeconds);
    diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
    StartTime := UTF8Encode(IntToStr(Diff));

    Rating := ''; // oder 'L' für "Love"?
    Source := 'P'; // Bei Webstreams: 'R'
end;

procedure TScrobbleFile.CopyFrom(aScrobbleFile: TScrobbleFile);
begin
    if assigned(aScrobbleFile) then
    begin
        Artist       := aScrobbleFile.Artist       ;
        Title        := aScrobbleFile.Title        ;
        Album        := aScrobbleFile.Album        ;
        Length       := aScrobbleFile.Length       ;
        TrackNr      := aScrobbleFile.TrackNr      ;
        MBTrackID    := aScrobbleFile.MBTrackID    ;
        DisplayTitle := aScrobbleFile.DisplayTitle ;

        StartTime    := aScrobbleFile.StartTime    ;
        Source       := aScrobbleFile.Source       ;
        Rating       := aScrobbleFile.Rating       ;
    end;
end;


constructor TNempScrobbler.Create(aHandle: HWND);
begin
    inherited Create;
    fMainWindowHandle := aHandle;
    LogList := TStringList.Create;
    JobList := TObjectList.Create(True);
    fPlayingFile := TScrobbleFile.Create;
    fCurrentFileAdded := False;
    ErrorInARowCount := 0;
    EarliestNextHandshake := Now;
    TimeToWaitInterval := 1;
    fLastCall := GetTickCount;
end;
destructor TNempScrobbler.Destroy;
begin
    LogList.Free;
    JobList.Free;
    fPlayingFile.Free;
    inherited destroy;
end;

procedure TNempScrobbler.BeginWork;
begin
    fWorking := True;
    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_BeginWork, 0);
end;

procedure TNempScrobbler.EndWork;
begin
    fWorking := False;
    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_EndWork, 0);
end;


function TNempScrobbler.ParseRawTag(aRawString: String; aAudioFile: TAudioFile): String;
var oneTag, name, c: String;
    tagBegin, tagEnd: Integer;
    name1, name2, c1, c2: Integer;
begin

    tagBegin := pos('<tag>', aRawString);
    tagEnd := pos('</tag>', aRawString);
    result := '';
    while (tagBegin <> 0) do
    begin
        oneTag := copy(aRawString, tagBegin + 5, tagEnd - tagBegin - 5);

        name1 := pos('<name>', oneTag);
        name2 := pos('</name>', oneTag);
        name := copy(oneTag, name1 + 6, name2 - name1 - 6);

        c1 := pos('<count>', oneTag);
        c2 := pos('</count>', oneTag);
        c := copy(oneTag, c1 + 7, c2 - c1 - 7);

        if StrToIntDef(c, -1) >= 10 then          // ToDo: MinValue veränderbar, settings
        if result = '' then
            result := name
        else
            result := result + #13#10 + name;
            // note: if we change the #13#10 here, we MUST also change it in TagCloud.RenameTag

        tagBegin := posEx('<tag>', aRawString, tagEnd);
        tagEnd := posEx('</tag>', aRawString, tagEnd + 4);
    end;
end;

function TNempScrobbler.GetTags(aAudioFile: tAudioFile): String;
var url: UTF8String;
    aIDHttp: TIdHttp;
    raw: String;
    n: Dword;
begin
    if not assigned(aAudioFile) then
    begin
        result := '';
        exit;
    end;

    // We MUST NOT call this methode more than 5x per second.
    // So: Sleep for a while before the next call.
    // DO NOT Change this - Otherwise Nemp could be banned from LastFM-Services!
    n := GetTickCount;
    if n - fLastCall < 250 then  // ok, this will result in 3-4 calls per second.
        sleep(250);

    fLastCall := GetTickCount;
    url := 'http://ws.audioscrobbler.com/2.0/?method=track.gettoptags'
    + '&artist=' + StringToURLStringAnd(AnsiLowerCase(aAudioFile.Artist))
    + '&track='  + StringToURLStringAnd(AnsiLowerCase(aAudioFile.Titel))
    + '&api_key=' + api_key;


    aIDHttp := TIdHttp.Create;
    try
        aIDHttp.ConnectTimeout:= 20000;
        aIDHttp.ReadTimeout:= 20000;
        aIDHttp.Request.UserAgent := 'Mozilla/3.0';
        aIDHttp.HTTPOptions :=  [];
        try
            raw := aIDHttp.Get(url);
        except
            raw := '';
        end;
        result := ParseRawTag(raw, Nil);


    finally
        aIDhttp.Free;
    end;
end;

function MD5StringToDigest(const aString: String): TMD5Digest;
var i: Integer;
    aByteStr: String;
begin
    if length(aString) <> 32 then
    begin
        for i := 0 to 15 do
            result.v[i] := 0;
    end
    else
        for i := 0 to 15 do
        begin
            aByteStr := '$' + aString[2*i + 1] + aString[2*i + 2];
            result.v[i] := StrToIntDef(aByteStr, 0);
        end;
end;

function TNempScrobbler.EncodeSessionKey(PlainKey: String): String;
var plainDigest, VolumeSrnNrDigest, FolderDigest, resultDigest: TMD5Digest;
    i: Integer;
const CSIDL_APPDATA = $001a;
begin
    if length(PlainKey) = 32 then
    begin
        //  PlainKey in Ziffern übersetzen
        plainDigest := MD5StringToDigest(PlainKey);
        //die anderen HashSummen ermitteln
        VolumeSrnNrDigest := MD5String(AnsiString(GetVolumeSerialNr('C')));
        FolderDigest      := MD5String(AnsiString(GetShellFolder(CSIDL_APPDATA)));

        // addieren
        for i := 0 to 15 do
            resultDigest.v[i] := (plainDigest.v[i] + VolumeSrnNrDigest.v[i] + FolderDigest.v[i]) Mod 256;

        result := Lowercase(MD5DigestToStr(resultDigest));
    end
    else
        result := PlainKey;
end;

function TNempScrobbler.DecodeSessionKey(CryptedKey: String): String;
var cryptedDigest, VolumeSrnNrDigest, FolderDigest, resultDigest: TMD5Digest;
    i: Integer;
const CSIDL_APPDATA = $001a;
begin
    if length(CryptedKey) = 32 then
    begin
        //  PlainKey in Ziffern übersetzen
        cryptedDigest := MD5StringToDigest(CryptedKey);
        //die anderen HashSummen ermitteln
        VolumeSrnNrDigest := MD5String(AnsiString(GetVolumeSerialNr('C')));
        FolderDigest      := MD5String(AnsiString(GetShellFolder(CSIDL_APPDATA)));

        // addieren
        for i := 0 to 15 do
            resultDigest.v[i] := (cryptedDigest.v[i] + 256 + 256 - VolumeSrnNrDigest.v[i] - FolderDigest.v[i]) Mod 256;

        result := Lowercase(MD5DigestToStr(resultDigest));
    end
    else
        result := CryptedKey;
end;


procedure TNempScrobbler.LoadFromIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    // Der quasi allzeit gültige Session-Key
    cryptedKey := Ini.ReadString('Scrobbler', 'SessionKey', '');
    SessionKey := DecodeSessionKey(cryptedKey);

    Username   := Ini.ReadString('Scrobbler', 'Username', '');
    if (Username = '') or (SessionKey = '') then
    begin
        Status := hs_UNAUTHORIZED;
        LogList.Add('Loading Settings: No username/sessionkey found.');
    end
    else
    begin
        Status := hs_OK;
        LogList.Add('Username: ' + Username);
        LogList.Add('Sessionkey: ' + Sessionkey);
    end;

    AlwaysScrobble := Ini.ReadBool('Scrobbler', 'AlwaysScrobble', False);
    DoScrobble := AlwaysScrobble;
    IgnoreErrors := Ini.ReadBool('Scrobbler', 'IgnoreErrors', True);
end;
procedure TNempScrobbler.SaveToIni(Ini: TMemIniFile);
var cryptedKey: String;
begin
    cryptedKey := EncodeSessionKey(SessionKey);
    Ini.WriteString('Scrobbler', 'SessionKey', cryptedKey);
    Ini.WriteString('Scrobbler', 'Username', Username);

    Ini.WriteBool('Scrobbler', 'AlwaysScrobble', AlwaysScrobble);
    Ini.WriteBool('Scrobbler', 'IgnoreErrors', IgnoreErrors);
end;

procedure TNempScrobbler.CountError(aFailure: TScrobbleStatus);
begin
    inc(ErrorInARowCount);
    if ErrorInARowCount >= 10 then // 3
    begin
        // Zurückfallen zum Handshake: ID auf '' setzen.
        SessionID := '';
        SendMessage(fMainWindowHandle, WM_Scrobbler, SC_TooMuchErrors, 0);
    end;
end;

procedure TNempScrobbler.CountSuccess;
begin
    ErrorInARowCount := 0;
    TimeToWaitInterval := 1;
end;

procedure TNempScrobbler.HandleHandshakeFailure(aFailure: TScrobbleStatus);
begin
    SessionID := '';
    if aFailure <> hs_Ok then
    begin
        EarliestNextHandshake := IncMinute(Now, TimeToWaitInterval);
        SendMessage(fMainWindowHandle, WM_Scrobbler, SC_Message, LParam(PChar('Scrobbling will be disabled for approx. ' + IntToStr(TimeToWaitInterval) + ' minutes.'  )));

        if TimeToWaitInterval < 60 then
            TimeToWaitInterval := TimeToWaitInterval * 2
        else
            TimeToWaitInterval := 120;
    end;
    EndWork;
end;

function TNempScrobbler.AddToScrobbleList(IsJustPlaying: Boolean): Boolean; // result: hinzugefügt oder nicht
var aScrobbleFile: TScrobbleFile;
    StartTimeDelphi: TDateTime;
    diff: LongInt;
begin
    result := False;
    if IsJustPlaying then
        PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);

    if DoScrobble then
    begin
        if ((PlayAmount > 240) or (PlayAmount > ( StrToIntDef(String(fPlayingFile.Length), 0) Div 2 )) )
           AND
           (StrToIntDef(String(fPlayingFile.Length), 0) > 30)
        then
        begin
            if (not fCurrentFileAdded) then   // hier beim else nichts senden, daher so. ;-)
            begin
                aScrobbleFile := TScrobbleFile.Create;
                aScrobbleFile.CopyFrom(fPlayingFile);
                StartTimeDelphi := EncodeDateTime(StartTimeUTC.wYear, StartTimeUTC.wMonth, StartTimeUTC.wDay, StartTimeUTC.wHour, StartTimeUTC.wMinute, StartTimeUTC.wSecond, StartTimeUTC.wMilliSeconds);
                diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
                aScrobbleFile.StartTime := Utf8Encode(IntToStr(Diff));

                JobList.Add(aScrobbleFile); // AudioFile kann man dann auch wieder vergessen: Infos stecken im Scrobblefile drin
                fCurrentFileAdded := True;
                Result := True;
                if not fWorking then
                begin
                    // Fang mit dem scrobbeln der Jobliste an!
                    ScrobbleJobList;
                end;
            end;
        end else
        begin
            if (not fCurrentFileAdded) then
            begin
                fCurrentFileAdded := True;  // so tun als ob. Sonst kommt diee Message evt. mehrfach
                // Scrobbeln verweigert, weil zu kurz...
                if (StrToIntDef(String(fPlayingFile.Length), 0) <= 30) then
                    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_SubmissionSkipped, Lparam(Pchar('Submission skipped: File too short (min. 30seconds)')))
                else
                    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_SubmissionSkipped, Lparam(Pchar('Submission skipped: Playback too short (min. 50% or 4 minutes).')));
            end;
        end;
    end;
end;

procedure TNempScrobbler.ChangeCurrentPlayingFile(aAudioFile: TAudioFile); // setzt das aktuelle Audiofile um und scrobbelt es ggf.
var s: TSystemTime;
begin
    GetSystemTime(s);
    fPlayingFile.Assign(aAudioFile, s); // s wird zum NP-Scrobbling aber nicht benötigt.
    fNewFile := True;
    fCurrentFileAdded := False;
end;


procedure TNempScrobbler.ScrobbleCurrentFile;
var aScrobbler: TScrobbler;
begin
    fNewFile := False;
    if DoScrobble then
    begin
        BeginWork;
        aScrobbler := TScrobbler.Create(fMainWindowHandle);
        try
            aScrobbler.EarliestNextHandshake := EarliestNextHandshake;
            aScrobbler.Username   := self.Username;
            aScrobbler.SessionKey := self.SessionKey;
            aScrobbler.SessionID  := SessionID;
            aScrobbler.ParamList.Add('s=' + SessionID);
            aScrobbler.ParamList.Add('a=' + String(fPlayingFile.Artist   ));
            aScrobbler.ParamList.Add('t=' + String(fPlayingFile.Title    ));
            aScrobbler.ParamList.Add('b=' + String(fPlayingFile.Album    ));
            aScrobbler.ParamList.Add('l=' + String(fPlayingFile.Length   ));
            aScrobbler.ParamList.Add('n=' + String(fPlayingFile.TrackNr  ));
            aScrobbler.ParamList.Add('m=' + String(fPlayingFile.MBTrackID));
            aScrobbler.NowPlayingURL := NowPlayingURL;
            aScrobbler.SubmissionURL := SubmissionURL;
            aScrobbler.SuccessMessage := 'Now Playing Notification: OK. ' + fPlayingFile.DisplayTitle;
            aScrobbler.ScrobbleNowPlaying;
        except
            aScrobbler.Free;
            EndWork;
        end;
    end;
end;

procedure TNempScrobbler.ScrobbleNextCurrentFile(PlayerIsPlaying: Boolean);
begin
    if DoScrobble then
    begin
        if fNewFile and PlayerIsPlaying then
            ScrobbleCurrentFile
        else
            EndWork;
    end
    else
        EndWork;
end;


// Unterscheid zur früheren Fassung:
// - Es wird direkt alles gescrobbelt (d.h. max. 50, ich mach hier mal nur 10)
// - Die Parameterliste wird HIER erzeugt, und die Liste dem TScrobbler übergeben
procedure TNempScrobbler.ScrobbleJobList;
var i: Integer;
    aScrobbleFile: TScrobbleFile;
    aScrobbler: TScrobbler;
begin
    // scrobbelcount setzen! Wichtig fürs löschen aus der Joblist bei erfolg
    FScrobbleJobCount := JobList.Count;

    if FScrobbleJobCount > 10 then
        FScrobbleJobCount := 10;
    // eigentlich sind bis zu 50 erlaubt
    // 10 am Stück reichen aber auch.
    // Der Rest wird dann ggf. danach gescrobbelt

    aScrobbler := TScrobbler.Create(fMainWindowHandle);
    try
          BeginWork;
          aScrobbler.Username    := Username;
          aScrobbler.SessionKey  := SessionKey;
          aScrobbler.SessionID   := SessionID;
          aScrobbler.EarliestNextHandshake := EarliestNextHandshake;

          aScrobbler.ParamList.Add('s=' + SessionID);
          for i := 0 to JobList.Count -1 do
          begin
              aScrobbleFile := TScrobbleFile(Joblist[i]);
              aScrobbler.ParamList.Add('a[' + IntToStr(i) + ']=' + String(aScrobbleFile.Artist   ));
              aScrobbler.ParamList.Add('t[' + IntToStr(i) + ']=' + String(aScrobbleFile.Title    ));
              aScrobbler.ParamList.Add('i[' + IntToStr(i) + ']=' + String(aScrobbleFile.StartTime));
              aScrobbler.ParamList.Add('o[' + IntToStr(i) + ']=' + String(aScrobbleFile.Source   ));
              aScrobbler.ParamList.Add('r[' + IntToStr(i) + ']=' + String(aScrobbleFile.Rating   ));
              aScrobbler.ParamList.Add('b[' + IntToStr(i) + ']=' + String(aScrobbleFile.Album    ));
              aScrobbler.ParamList.Add('l[' + IntToStr(i) + ']=' + String(aScrobbleFile.Length   ));
              aScrobbler.ParamList.Add('n[' + IntToStr(i) + ']=' + String(aScrobbleFile.TrackNr  ));
              aScrobbler.ParamList.Add('m[' + IntToStr(i) + ']=' + String(aScrobbleFile.MBTrackID));
          end;
          aScrobbler.NowPlayingURL := NowPlayingURL;
          aScrobbler.SubmissionURL := SubmissionURL;

          if JobList.Count = 1 then
              aScrobbler.SuccessMessage := 'Scrobble: OK. ' + TScrobbleFile(Joblist[0]).DisplayTitle
          else
              aScrobbler.SuccessMessage := 'Scrobble: OK. (' + IntToStr(FScrobbleJobCount) + ' Files)';

          aScrobbler.ScrobbleSubmit;
    except
      aScrobbler.Free;
      EndWork;
    end;
end;

Procedure TNempScrobbler.ScrobbleNext(PlayerIsPlaying: Boolean);
var i: Integer;
begin
    // Diese Proc wird aufgerufen, wenn das Submitten per "ScrobbleJobList" erfolgreich war.
    // d.h.: Die gescrobbelten Dateien aus der JobListe entfernen
    for i := 1 to FScrobbleJobCount do
        JobList.Remove(JobList[0]);
    FScrobbleJobCount := 0;

    if DoScrobble then
    begin
        if JobList.Count > 0 then
            // erstmal die Liste weiter scrobblen
            ScrobbleJobList
        else
        begin
            if PlayerIsPlaying then
                ScrobbleCurrentFile  // muss nochmal gesendet werden, wird vom Submitten wohl überdeckt.
            else
                EndWork;
        end;
    end
    else
        EndWork;
end;


Procedure TNempScrobbler.ScrobbleAgain(PlayerIsPlaying: Boolean);
begin
    if DoScrobble then
    begin
        if JobList.Count > 0 then
            ScrobbleJobList
        else
        begin
            if PlayerIsPlaying then
                ScrobbleCurrentFile
            else
                EndWork;
        end;
    end
    else
        EndWork;
end;



procedure TNempScrobbler.PlaybackStarted;
begin
    GetSystemTime(StartTimeUTC);
    StartTimeLocal := Now;
    PlayAmount := 0;

    if DoScrobble then
    begin
        if not fWorking then
            // aktuelles File Scrobbeln
            ScrobbleCurrentFile
    end;
end;
procedure TNempScrobbler.PlaybackPaused;
begin
    PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);
end;
procedure TNempScrobbler.PlaybackResumed;
begin
    StartTimeLocal := Now;
end;

procedure TNempScrobbler.AllowHandShakingAgain;
begin
    self.EarliestNextHandshake := Now;
end;



// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------



constructor TScrobbler.Create(aHandle: HWnd);
begin
    inherited Create;
    fWindowHandle := aHandle;
    fThread := 0;
    p  := '1.2.1'; // Protokoll-Version
    c  := 'nem';   //'tst' ;
    v  := '3.3';   //'1.0' ;

    fIDHttp := TIdHttp.Create;
    fIDHttp.ConnectTimeout:= 20000;
    fIDHttp.ReadTimeout:= 20000;

    fIDHttp.Request.UserAgent := 'Mozilla/3.0';
    //fIDHttp.HTTPOptions :=  [hoForceEncodeParams];
    fIDHttp.HTTPOptions :=  [];

    EarliestNextHandshake := Now;

    ParamList := TStringList.Create;
end;

destructor TScrobbler.Destroy;
begin
    //WaitForSingleObject(fThread, 15000);
    fIDHttp.Free;
    ParamList.Free;
    inherited destroy;
end;

function TScrobbler.GetUTCTimeStamp: String;
var SystemTime: TSystemTime;
    currentTime: TDateTime;
    diff: LongInt;
begin
    GetSystemTime(SystemTime);
    currentTime :=
        EncodeDateTime(SystemTime.wYear, SystemTime.wMonth, SystemTime.wDay, SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond, SystemTime.wMilliSeconds);
    diff := Round((currentTime - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
    result := IntToStr(Diff);
end;



procedure TScrobbler.GetToken;
var Dummy: Cardinal;
begin
    fThread := BeginThread(Nil, 0, @StartGetToken, Self, 0, Dummy)
end;
procedure StartGetToken(Scrobbler: TScrobbler);
begin
    Scrobbler.fGetToken;
end;
procedure TScrobbler.fGetToken;
var Sig: String;
    Response, MessageText: String;
begin
  try
      Sig := 'api_key' + api_key
              + 'method' + 'auth.gettoken'
              + faae65f530febc67;
      try
          Response := fIDHTTP.Get( BaseApiURL + '?method=auth.gettoken'
                            + '&' + 'api_key=' + api_key
                            + '&' + 'api_sig=' + Lowercase(MD5DigestToStr(MD5String(AnsiString(sig)))));
          SendMessage(fWindowHandle, WM_Scrobbler, SC_GetToken, lParam(PChar(Response)));
      except
            on E: EIdHTTPProtocolException do
            begin
                MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetTokenException, lParam(PChar(MessageText)));
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetTokenException, lParam(PChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetTokenException, lParam(PChar(MessageText)));
            end;
        end;
     finally
        self.free;
     end;
end;


procedure TScrobbler.GetSession;
var Dummy: Cardinal;
begin
    fThread := BeginThread(Nil, 0, @StartGetSession, Self, 0, Dummy)
end;
procedure StartGetSession(Scrobbler: TScrobbler);
begin
    Scrobbler.fGetSession;
end;
procedure TScrobbler.fGetSession;
var Sig: String;
    Response, MessageText: String;
begin
    try
        Sig := 'api_key' + api_key
              + 'method' + 'auth.getsession'
              + 'token' + Token
              + faae65f530febc67;
        try
            Response := fIDHTTP.Get( BaseApiURL + '?method=auth.getsession'
                            + '&' + 'api_key=' + api_key
                            + '&' + 'token=' + Token
                            + '&' + 'api_sig=' + Lowercase(MD5DigestToStr(MD5String(AnsiString(sig)))));
            SendMessage(fWindowHandle, WM_Scrobbler, SC_GetSession, lParam(PChar(Response)));
        except
            on E: EIdHTTPProtocolException do
            begin
                MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetSessionException, lParam(PChar(MessageText)));
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetSessionException, lParam(PChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetSessionException, lParam(PChar(MessageText)));
            end;
        end;
    finally
        self.free;
    end;
end;

function TScrobbler.ParseHandShakeResult(aResponse: string): TScrobbleStatus;
var aList: TStringList;
    stat: String;
begin
    aList := TStringlist.Create;
    try
        aList.CommaText := aResponse;
        if (aList.Count >= 4) and (Uppercase(Trim(aList[0])) = 'OK') then
        begin
            SessionID := aList[1];
            NowPlayingURL := aList[2];
            SubmissionURL := aList[3]; //'http://post2.audioscrobbler.com:80/protocol_1.2'; //aList[2];  // 3
            Result := hs_OK;
        end else
        begin
            if aList.Count = 0 then
                Result := hs_UnknownFailure
            else
            begin
                stat := Uppercase(Trim(aList[0]));
                if stat = 'BANNED' then
                  Result := hs_BANNED
                else
                  if stat = 'BADAUTH' then
                    Result := hs_BADAUTH
                  else
                    if stat = 'BADTIME' then
                      result := hs_BADTIME
                    else
                      if Pos('FAILED', Stat) > 0 then
                        result := hs_FAILED
                      else
                        result := hs_UnknownFailure
            end;
        end;
    finally
        aList.Free;
    end;
end;

function TScrobbler.fPerformHandShake: TScrobbleStatus;
var authToken: String;
    Response, MessageText: String;
    t: String;
begin
    if Now < EarliestNextHandshake then
    begin
        result := hs_HANDSHAKECANCELLED;
        SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeCancelled, lParam(MinutesBetween(Now, EarliestNextHandshake)+1 ));
        exit;
    end;

    if (Username = '') or (SessionKey = '') then
    begin
        // ABBRECHEN! User hat sich noch nicht angemeldet
        result := hs_UNAUTHORIZED;
        SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeError, lParam(Result));
        //

        //  Das ist ein sehr harter Fehler - Der User muss sich erst anmelden Alles weitere ist komplett sinnfrei.

        //
    end
    else
    begin
        t := GetUTCTimeStamp;
        authToken := Lowercase(MD5DigestToStr(MD5String(AnsiString(faae65f530febc67 + t))));
        try
            Response := fIDHTTP.Get( BaseScrobbleURL + '?hs=true'
                            + '&' + 'p=' + p
                            + '&' + 'c=' + c
                            + '&' + 'v=' + v
                            + '&' + 'u=' + Username
                            + '&' + 't=' + t
                            + '&' + 'a=' + authToken
                            + '&' + 'api_key=' + api_key
                            + '&' + 'sk=' + SessionKey);
            result := ParseHandShakeResult(Response);

            case result of
                // Wenn alles Ok war, sind damit SessionID, NowPlayingURL und SubmissionURL gesetzt
                hs_OK: SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeComplete, lParam(PChar(Response)));
                else
                begin
                    // Wenn nicht, dann ist der Handshake fehlgeschlagen.
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeError, lParam(Result));
                    if result = hs_failed then
                        // Some Failure => Text senden
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_Message, lParam(Response));
                end;
            end;

        except
            on E: EIdHTTPProtocolException do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:' + #13#10 + E.Message + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeException, lParam(PChar(MessageText)));
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeException, lParam(PChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                result := hs_Exception;
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_HandShakeException, lParam(PChar(MessageText)));
            end;
        end;
    end;
end;


function TScrobbler.ParseNowPlayingResult(aResponse: string): TScrobbleStatus;
var stat: String;
begin
    stat := Uppercase(Trim(aResponse));
    if stat = 'OK' then
      result := hs_OK
    else
      if stat = 'BADSESSION' then
        result := hs_BADSESSION
      else
        result := hs_UnknownFailure;
end;

function TScrobbler.fPerformNowPlayingNotification: TScrobbleStatus;
var Response, MessageText: String;
begin
        try
            ParamList[0] := 's=' + SessionID;
            Response := fIDHTTP.Post(NowPlayingURL, ParamList);
            result := ParseNowPlayingResult(Response);
        except

            on E: EIdHTTPProtocolException do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingException, lParam(PChar(MessageText)));
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingException, lParam(PChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                result := hs_Exception;
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingException, lParam(PChar(MessageText)));
            end;
        end;

end;


procedure TScrobbler.ScrobbleNowPlaying;
var Dummy: Cardinal;
begin
    fThread := BeginThread(Nil, 0, @StartScrobbleNowPlaying, Self, 0, Dummy)
end;
procedure StartScrobbleNowPlaying(Scrobbler: TScrobbler);
begin
    Scrobbler.fScrobbleNowPlaying;
end;
procedure TScrobbler.fScrobbleNowPlaying;
var tmpStat: TScrobbleStatus;
begin
    try
        if SessionID = '' then
            tmpStat := fPerformHandShake
        else
            tmpStat := hs_OK;

        if tmpStat = hs_Ok then
        begin
            tmpStat := fPerformNowPlayingNotification;
            if tmpStat = hs_Ok then
                // Scrobbeln erfolgreich
                SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingComplete, LParam(PChar(SuccessMessage)))
            else
            begin
                // Scrobbeln war nicht erfolgreich. d.h.: (alte) Session-ID ist ungültig.
                // also: Neuer Handshake und zweiter Versuch.
                if tmpStat = hs_BADSESSION then
                    tmpStat := fPerformHandShake
                else
                    tmpStat := hs_OK; // einfach neu probieren
                if tmpStat = hs_Ok then
                begin
                    // Handshake war ok, nochmal Scrobbeln
                    tmpStat := fPerformNowPlayingNotification;
                    if tmpStat = hs_Ok then
                        // Scrobbeln erfolgreich
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingComplete, LParam(PChar(SuccessMessage)))
                    else
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingError, lParam(tmpStat));
                end;
            end;
        end;
    finally
        self.free;
    end;
end;


function TScrobbler.ParseSubmissionResult(aResponse: string): TScrobbleStatus;
var stat: String;
begin
    stat := Uppercase(Trim(aResponse));
    if stat = 'OK' then
      result := hs_OK
    else
      if stat = 'BADSESSION' then
        result := hs_BADSESSION
      else
        if Pos('FAILED', Stat) > 0 then
          result := hs_FAILED
        else
          result := hs_UnknownFailure;
end;

function TScrobbler.fPerformSubmissionNotification: TScrobbleStatus;
var Response, MessageText: String;
begin
        try
            ParamList[0] := 's=' + SessionID;
            Response := fIDHTTP.Post(SubmissionURL, ParamList);
            result := ParseSubmissionResult(Response);

            if result = hs_failed then
            // Some Failure => Text senden
                SendMessage(fWindowHandle, WM_Scrobbler, SC_Message, lParam(Response));

        except
            on E: EIdHTTPProtocolException do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ProtocolError + #13#10 + 'Server message: '#13#10 + E.Message + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionException, lParam(PChar(MessageText)));
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                result := hs_Exception;
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionException, lParam(PChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                result := hs_Exception;
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionException, lParam(PChar(MessageText)));
            end;


        end;                                                                   
end;

procedure TScrobbler.ScrobbleSubmit;
var Dummy: Cardinal;
begin
    fThread := BeginThread(Nil, 0, @StartScrobbleSubmit, Self, 0, Dummy)
end;
procedure StartScrobbleSubmit(Scrobbler: TScrobbler);
begin
    Scrobbler.fScrobbleSubmit;
end;
procedure TScrobbler.fScrobbleSubmit;
var tmpStat: TScrobbleStatus;
begin
    try
        if SessionID = '' then
            tmpStat := fPerformHandShake
        else
            tmpStat := hs_OK;

        if tmpStat = hs_Ok then
        begin
            tmpStat := fPerformSubmissionNotification;
            if tmpStat = hs_Ok then
                // Scrobbeln erfolgreich
                SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionComplete, LParam(PChar(SuccessMessage)))
            else
            begin
                // Scrobbeln war nicht erfolgreich. d.h.: (alte) Session-ID ist ungültig.
                // also: Neuer Handshake und zweiter Versuch.
                if tmpStat = hs_BADSESSION then
                    tmpStat := fPerformHandShake
                else
                    tmpStat := hs_OK; // einfach neu probieren

                if tmpStat = hs_Ok then
                begin
                    // Handshake war ok, nochmal Scrobbeln
                    tmpStat := fPerformSubmissionNotification;
                    if tmpStat = hs_Ok then
                        // Scrobbeln erfolgreich
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionComplete, LParam(PChar(SuccessMessage)))
                    else
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionError, lParam(tmpStat));
                end;
            end;
        end;
    finally
        self.free;
    end;
end;

end.


