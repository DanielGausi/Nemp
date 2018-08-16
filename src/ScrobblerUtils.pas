{

  ScrobblerUtils, Version 0.2a

  A Borland/Codegear/Embarcadero Delphi-Class for Last.Fm scrobbling support.
  See http://www.last.fm in case you dont know what "scrobbling" means

}
{
  -------------------------------------------------------

  Copyright (C) 2009, Daniel Gaussmann
                      www.gausi.de
                      mail@gausi.de
  All rights reserved.

  *******************************************************

  Note: Read and accept the "Terms of Use" on LastFM before
        using this unit.

        http://www.last.fm/api/tos

  -------------------------------------------------------

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

  -------------------------------------------------------
}

{
  Version History:
  -------------------------------------------------------

  v0.2a, November 2011
  -------------------
    * deleted some "uses"
    * moved methods/fields of TApplicationScrobbler from "private" to "protected"

  v0.2, November 2011
  -------------------
    * switched to Scrobble-API 2.0
    * (almost) everything is WideString/UnicodeString/PWideChar now

  v0.1a, march 2009:
  ------------------
    * replaced "PChar" by "PAnsiChar"
    
  v0.1, march 2009:
  -----------------
    * First release

  -------------------------------------------------------
}

unit ScrobblerUtils;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StrUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack,
  IdException, md5, StdCtrls, DateUtils, Contnrs, System.Types;

const
    UnixStartDate: TDateTime = 25569.0;

    BaseApiURL = 'http://ws.audioscrobbler.com/2.0/';
    /// BaseScrobbleURL = 'http://post.audioscrobbler.com/';

    Scrobble_GetSessionError = 'Invalid response to GetSession. ';
    Scrobble_GetTokenError = 'Invalid response to GetToken. ';
    Scrobble_ProtocolError = 'Protocol exception';
    Scrobble_ConnectError = 'Network exception. Please check your internet connection.';
    Scrobble_UnkownError = 'An unknown error occurred.';
    ///ScrobbleFailureWait = 'Da stimmt was nicht mit dem Scrobbeln. Log-Einträge lesen für weitere Details.';
    Scrobble_FileTooShort = 'Submission skipped: Track too short (min. 30 seconds)';
    Scrobble_PlayAmount = 'Submission skipped: Playback too short (min. 50% or 4 minutes)';

    WM_Scrobbler = WM_User + 850;

    ///SC_HandShakeError = 1;                     // old messages, used in v0.1
    ///SC_HandShakeCancelled = 2;
    ///SC_HandShakeException = 3;
    ///SC_NowPlayingError = 4;
    ///SC_NowPlayingException = 5;
    ///SC_SubmissionError = 6;
    ///SC_SubmissionException = 7;
    SC_GetToken = 10;
    //SC_GetTokenException = 11;
    SC_GetSession = 12;
    //SC_GetSessionException = 13;
    ///SC_HandShakeComplete = 14;
    SC_NowPlayingComplete = 15;
    SC_SubmissionComplete = 16;
    ///SC_SubmissionSkipped = 17;

    // new for 2.0
    SC_ScrobblingSkipped = 18;       // Scrobbling paused for a while
    SC_InvalidSessionKey = 19;       // Invalid Session Key: STOP
    SC_ServiceUnavailable = 20;      // Server Failure: Count Error, try Again
    SC_IPSpam = 21;                  // Spam: Pause
    SC_ScrobbleException = 22;       // Probably a Bug in implementation : DoScrobble = False
    SC_UnknownScrobbleError = 23;    // Unknown Failure: Count Error, try Again
    SC_IndyException = 24;           // Indy-Exception
    SC_JobIsDone = 25;               // Job is done, EndWork MUST be called by VCL
    SC_GetAuthException = 26;        // Error during authentification process
    SC_InvalidToken = 27;            // The Token was invalid (during getSession)

    SC_ScrobblingSkippedAgain = 28;  // repeated SC_ScrobblingSkipped message

    SC_BeginWork = 50;
    SC_EndWork = 51;
    ///SC_TooMuchErrors = 100;

    SC_Message = 1000;  // general Message  // not used
    SC_Hint = 1001;     // Hint, something wasn't perfect
    SC_Error = 1002;    // Error, something was wrong
    
type

    TScrobbleStatus = (hs_OK=1,
               // hs_EXCEPTION,
               hs_UnknownFailure,
               hs_InvalidToken,
               // hs_BANNED,
               // hs_BADAUTH,
               // hs_BADTIME,
               hs_FAILED,
               hs_BADSESSION,
               // hs_HANDSHAKECANCELLED,
               hs_SPAM,
               hs_SCROBBLINGEXCEPTION // Scrobbling Exception (bug in implementation)
               );

    TScrobbleHint = (hs_Artist=1, hs_Track, hs_Album);


type

  {$IFNDEF UNICODE}
      UnicodeString = WideString;
  {$ENDIF}

    TParameter = record
        name: UnicodeString;
        value: UnicodeString;
    end;

    PSessionResponse = ^TSessionResponse;
    TSessionResponse = record
        Username: UnicodeString;
        SessionKey: AnsiString;
    end;


    TValueArray = Array of TParameter;

    TScrobbleMode = (sm_Auth, sm_NowPlaying, sm_Scrobble);

    TScrobbleFile = Class
          Interpret: UnicodeString;
          Title: UnicodeString;
          Album: UnicodeString;
          AlbumArtist: UnicodeString; //not used
          Length: UnicodeString;      // Duration of the track in seconds
          TrackNr: UnicodeString;
          MBTrackID: UnicodeString;   // Music-Brainz-TrackID, not used

          DisplayTitle: UnicodeString; // e.g. "Artist - Album"
          StartTime: UnicodeString;

          procedure Assign(aScrobbleFile: TScrobbleFile);
    end;

    // Class TScrobbler
    // For each job one instance of tis class is created.
    // It begins a new thread, which do the designated job.
    // At the end the object frees itself.
    TApplicationScrobbler = class;
    TScrobbler = class
      private
          fWindowHandle: HWND; // Messages will be sent to this Handle
          fThread: Integer;
          fIDHttp: TIdHttp;
          fParent: TApplicationScrobbler;

          fToken: AnsiString;   // needed for GetSession
          Username: UnicodeString;
          SessionKey: AnsiString;

          ParamList: TStrings;
          SuccessMessage: UnicodeString;

          // All "f"-methods are executed in a secondary thread

          // Authentification

          // 1st step: GetToken
          // Get a Token from LastFM. Such a token is valid for approx.1 hour.
          // It MUST be authenticated by the lastFM user.
          // This is done through a link to last.fm containing the token
          // After this your app is alowed to edit the users LastFM user profile.
          procedure fGetToken;

          // 2nd step: The user has to click on "OK - This App good for me" on the lastFM website

          // 3rd step: GetSession
          // The authenticated token is used to get a Session Key and Username
          // This session key has an infinity lifetime per default.
          // You should save it for later use (e.g. inifiles)
          procedure fGetSession;

          // Scrobbling (2.0)

          // parsing methods to parse the responsefrom the lastFM webserver
          function ParseLfmError(aResponse: UnicodeString; Mode: TScrobbleMode): TScrobbleStatus;
          function ParseGetTokenResult(aResponse: UnicodeString): AnsiString;
          function ParseGetSessionResult(aResponse: UnicodeString): TSessionResponse;
          procedure ParseScrobbledFile(aResponse: UnicodeString);
          function ParseNowPlayingResult(aResponse: UnicodeString; Mode: TScrobbleMode): TScrobbleStatus;

          // the main scrobbling methods
          procedure fScrobbleNowPlaying;
          procedure fScrobbleSubmit;

          // begins the new thread with the proper method
          procedure ScrobbleNowPlaying;
          procedure ScrobbleSubmit;

      public
          property Parent: TApplicationScrobbler read fParent write fParent;
          property Token: AnsiString read fToken write fToken;

          constructor Create(aHandle: HWnd);
          destructor Destroy; override;

          // begins the new thread with the proper method
          procedure GetToken;
          procedure GetSession;
    end;


    // Class TApplicationScrobbler
    // See readme.txt for further comments
    TApplicationScrobbler = class
        protected
            fMainWindowHandle: HWND;

            StartTimeUTC: TSystemTime;
            StartTimeLocal: TDateTime;
            PlayAmount: Integer; // in seconds

            fWorking: Boolean;      // True iff a TScrobbler is working right now
            FScrobbleJobCount: Integer;

            ValidSessionKey : Boolean;
            ErrorInARowCount: Integer;
            EarliestNextScrobbleAttempt: TDateTime;
            TimeToWaitInterval: Integer;

            fPlayingFile: TScrobbleFile;
            fNewFile: Boolean;
            fCurrentFileAdded: Boolean;
            // Check for errors.
            // used by TScrobbler in Thread to decide to scrobble or not
            function fScrobblingAllowed: Boolean;
            procedure CountError;
            procedure CountSuccess;
            procedure ScrobbleCurrentFile;
            procedure ScrobbleJobList;

            procedure BeginWork;
            procedure EndWork;

            function SortParams(params: TValueArray): UnicodeString;
            // YOU MUST implement GenerateSignature in your own TMyAppScrobbler!
            function GenerateSignature(SortedParams: UnicodeString): UnicodeString; virtual; abstract;

        public
            ApiKey: AnsiString;      // constant. Get it on YOUR lastFM user profile
            Token: AnsiString;
            SessionKey: AnsiString;
            Username: UnicodeString;

            AlwaysScrobble: Boolean; // global (i.e. start scrobbling when app starts)
            DoScrobble: Boolean;     // local (during one app session)

            JobList: TObjectList;
            LogList: TStrings;

            property Working: Boolean Read fWorking;
            constructor Create(aHandle: HWND);
            destructor Destroy; override;

            procedure JobDone;

            procedure GetToken;
            procedure GetSession;

            // scrobble next file (iv available)
            procedure ScrobbleNext(PlayerIsPlaying: Boolean);
            procedure ScrobbleNextCurrentFile(PlayerIsPlaying: Boolean);

            // Retry
            Procedure ScrobbleAgain(PlayerIsPlaying: Boolean);

            // User thinks, that he has solved some issues - allow scrobbling again
            procedure ProblemSolved;

            function AddToScrobbleList(IsJustPlaying: Boolean): Boolean;
            procedure ChangeCurrentPlayingFile(Interpret, Title, Album: UnicodeString; Length, TrackNr: Integer);
            procedure PlaybackStarted;
            procedure PlaybackPaused;
            procedure PlaybackResumed;
    end;


  procedure StartGetToken(Scrobbler: TScrobbler);
  procedure StartGetSession(Scrobbler: TScrobbler);

  procedure StartScrobbleNowPlaying(Scrobbler: TScrobbler);
  procedure StartScrobbleSubmit(Scrobbler: TScrobbler);

  function ParseHTMLChars(s: UnicodeString): UnicodeString;


implementation


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

function ParseHTMLChars(s: UnicodeString): UnicodeString;
begin
    result := StringReplace(s, '&amp;', '&', [rfReplaceAll]);
    result := StringReplace(result, '&lt;', '<', [rfReplaceAll]);
    result := StringReplace(result, '&gt;', '>', [rfReplaceAll]);
    result := StringReplace(result, '&quot;', '"', [rfReplaceAll]);
end;


procedure TScrobbleFile.Assign(aScrobbleFile: TScrobbleFile);
begin
    if assigned(aScrobbleFile) then
    begin
        Interpret    := aScrobbleFile.Interpret    ;
        Title        := aScrobbleFile.Title        ;
        Album        := aScrobbleFile.Album        ;
        Length       := aScrobbleFile.Length       ;
        TrackNr      := aScrobbleFile.TrackNr      ;
        MBTrackID    := aScrobbleFile.MBTrackID    ;
        DisplayTitle := aScrobbleFile.DisplayTitle ;
        StartTime    := aScrobbleFile.StartTime    ;
    end;
end;


// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// Class TApplicationScrobbler
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------


constructor TApplicationScrobbler.Create(aHandle: HWND);
begin
    inherited Create;
    fMainWindowHandle := aHandle;
    LogList := TStringList.Create;
    JobList := TObjectList.Create(True);
    fPlayingFile := TScrobbleFile.Create;
    fCurrentFileAdded := False;
    ErrorInARowCount := 0;
    EarliestNextScrobbleAttempt := Now;
    ValidSessionKey := True;
    TimeToWaitInterval := 1;

    DoScrobble := False;
end;
destructor TApplicationScrobbler.Destroy;
begin
    LogList.Free;
    JobList.Free;
    fPlayingFile.Free;
    inherited destroy;
end;

procedure TApplicationScrobbler.BeginWork;
begin
    fWorking := True;
    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_BeginWork, 0);
end;

procedure TApplicationScrobbler.EndWork;
begin
    fWorking := False;
    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_EndWork, 0);
end;

procedure TApplicationScrobbler.JobDone;
begin
    EndWork;
end;

// fScrobblingAllowed, works in secondary Thread
function TApplicationScrobbler.fScrobblingAllowed: Boolean;
var SendWarning: Boolean;
begin
    if ValidSessionKey then
    begin
        SendWarning := False;
        if ErrorInARowCount >= 5 then // or 3? 5? 10?
        begin
            // we had a lot of errors recently. Just take a timout.
            EarliestNextScrobbleAttempt := IncMinute(Now, TimeToWaitInterval);
            ErrorInARowCount := 0;
            SendWarning := True;
            // increase TimeToWait (i.e. wait longer, if the errors occur again after the timeout)
            if TimeToWaitInterval < 60 then
                TimeToWaitInterval := TimeToWaitInterval * 2
            else
                TimeToWaitInterval := 120;
        end;

        if Now < EarliestNextScrobbleAttempt then
        begin
            result := False;
            // notify main window
            if SendWarning then
                SendMessage(fMainWindowHandle, WM_Scrobbler, SC_ScrobblingSkipped,
                      LParam(MinutesBetween(Now, EarliestNextScrobbleAttempt)+1))
            else
                SendMessage(fMainWindowHandle, WM_Scrobbler, SC_ScrobblingSkippedAgain,
                      LParam(MinutesBetween(Now, EarliestNextScrobbleAttempt)+1));

            SendMessage(fMainWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
        end else
            result := True;
    end else
    begin
        SendMessage(fMainWindowHandle, WM_Scrobbler, SC_InvalidSessionKey, 0);
        SendMessage(fMainWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
        result := False;
    end;
end;

procedure TApplicationScrobbler.CountError;
begin
    inc(ErrorInARowCount);
end;

procedure TApplicationScrobbler.CountSuccess;
begin
    ErrorInARowCount := 0;
    TimeToWaitInterval := 1;
    ValidSessionKey := True;
    EarliestNextScrobbleAttempt := Now;
end;

function TApplicationScrobbler.AddToScrobbleList(IsJustPlaying: Boolean): Boolean;
var aScrobbleFile: TScrobbleFile;
    StartTimeDelphi: TDateTime;
    diff: LongInt;
begin
    result := False;
    if IsJustPlaying then
        PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);

    if DoScrobble then
    begin
        if ((PlayAmount > 240) or (PlayAmount > ( StrToIntDef(fPlayingFile.Length, 0) Div 2 )) )
           AND
           (StrToIntDef(fPlayingFile.Length, 0) > 30)
        then
        begin
            if (not fCurrentFileAdded) then   // hier beim else nichts senden, daher so. ;-)
            begin
                aScrobbleFile := TScrobbleFile.Create;
                aScrobbleFile.Assign(fPlayingFile);
                StartTimeDelphi := EncodeDateTime(StartTimeUTC.wYear, StartTimeUTC.wMonth, StartTimeUTC.wDay, StartTimeUTC.wHour, StartTimeUTC.wMinute, StartTimeUTC.wSecond, StartTimeUTC.wMilliSeconds);
                diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Sekunden pro Tag
                aScrobbleFile.StartTime := IntToStr(Diff);

                JobList.Add(aScrobbleFile);
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
                if (StrToIntDef(fPlayingFile.Length, 0) <= 30) then
                    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_Hint, Lparam(PWideChar(UnicodeString(Scrobble_FileTooShort))))
                else
                    SendMessage(fMainWindowHandle, WM_Scrobbler, SC_Hint, Lparam(PWideChar(UnicodeString(Scrobble_PlayAmount))));
            end;
        end;
    end;
end;

procedure TApplicationScrobbler.ChangeCurrentPlayingFile(Interpret, Title, Album: UnicodeString; Length, TrackNr: Integer);
var s: TSystemTime;
    StartTimeDelphi: TDateTime;
    diff: LongInt;
begin
    GetSystemTime(s);
    fPlayingFile.DisplayTitle := Interpret + ' - ' + Title;

    fPlayingFile.Interpret := Interpret;
    fPlayingFile.Title     := Title;
    fPlayingFile.Album     := Album;
    fPlayingFile.Length    := IntToStr(Length);

    if TrackNr <> 0 then
        fPlayingFile.TrackNr := IntToStr(TrackNr)
    else
        fPlayingFile.TrackNr := '';

    StartTimeDelphi := EncodeDateTime(s.wYear, s.wMonth, s.wDay, s.wHour, s.wMinute, s.wSecond, s.wMilliSeconds);
    diff := Round((StartTimeDelphi - UnixStartDate) * 86400); // 86400: Seconds per day
    fPlayingFile.StartTime := IntToStr(diff);

    fNewFile := True;
    fCurrentFileAdded := False;
end;


procedure TApplicationScrobbler.GetToken;
var aScrobbler: TScrobbler;
begin
    BeginWork;
    aScrobbler := TScrobbler.Create(fMainWindowHandle);
    try
        aScrobbler.Parent := self;
        aScrobbler.GetToken;
    except
        aScrobbler.Free;
        EndWork;
    end;
end;


procedure TApplicationScrobbler.GetSession;
var aScrobbler: TScrobbler;
begin
    BeginWork;
    aScrobbler := TScrobbler.Create(fMainWindowHandle);
    try
        aScrobbler.Token := Token;
        aScrobbler.Parent := self;
        aScrobbler.GetSession;
    except
        aScrobbler.Free;
        EndWork;
    end;
end;

function TApplicationScrobbler.SortParams(params: TValueArray): UnicodeString;
var complete: Boolean;
    tmp: TParameter;
    i: integer;
begin
    // bubblesort
    complete := false;
    while not complete do
    begin
        complete := true;
        for i := 0 to length(params) - 2 do
            if params[i].name > params[i+1].name then
            begin
                tmp := params[i];
                params[i] := params[i+1];
                params[i+1] := tmp;
                complete := false;
            end;
    end;
    result := '';
    for i := 0 to length(params)-1  do
        result := result + params[i].name + params[i].value;
end;

procedure TApplicationScrobbler.ScrobbleCurrentFile;
var aScrobbler: TScrobbler;
    Params: TValueArray;
    ParamCount: Integer;
    sig: UnicodeString;
  i: Integer;
begin
    fNewFile := False;
    if DoScrobble then
    begin
        BeginWork;
        aScrobbler := TScrobbler.Create(fMainWindowHandle);
        try
            aScrobbler.Parent := self;
            aScrobbler.Username   := self.Username;
            aScrobbler.SessionKey := self.SessionKey;

            SetLength(Params, 10); // we have at most 10 Parameters to add;
            // Required Parameters
            Params[0].name := 'api_key'; Params[0].value := UnicodeString(ApiKey)    ;
            Params[1].name := 'artist';
            if fPlayingFile.Interpret = '' then
                Params[1].value := 'Unknown Artist'
            else
                Params[1].value := fPlayingFile.Interpret   ;

            Params[2].name := 'method';  Params[2].value := 'track.updateNowPlaying' ;
            Params[3].name := 'sk';      Params[3].value := UnicodeString(SessionKey);
            Params[4].name := 'track';
            if fPlayingFile.Title = '' then
                Params[4].value := 'Unknown Title'
            else
                Params[4].value := fPlayingFile.Title;

            ParamCount := 5;
            // optional parameters
            if fPlayingFile.Album <> '' then
            begin
                Params[ParamCount].name  := 'album' ;
                Params[ParamCount].value := fPlayingFile.Album;
                inc(ParamCount);
            end;
            if fPlayingFile.TrackNr <> '' then
            begin
                Params[ParamCount].name  := 'trackNumber' ;
                Params[ParamCount].value := fPlayingFile.TrackNr;
                inc(ParamCount);
            end;
            if fPlayingFile.Length <> '' then
            begin
                Params[ParamCount].name  := 'duration' ;
                Params[ParamCount].value := fPlayingFile.Length;
                inc(ParamCount);
            end;
            SetLength(Params, ParamCount); // cut Array

            for i := 0 to length(params) - 1 do
                aScrobbler.ParamList.Add(params[i].name+'=' + ParamsEncode(UTF8Encode(params[i].value)));

            sig := GenerateSignature(SortParams(params));
            aScrobbler.ParamList.Add('api_sig=' + sig);

            aScrobbler.SuccessMessage := 'Now Playing Notification: OK. ' + fPlayingFile.DisplayTitle;
            aScrobbler.ScrobbleNowPlaying;
        except
            aScrobbler.Free;
            EndWork;
        end;
    end;
end;

procedure TApplicationScrobbler.ScrobbleNextCurrentFile(PlayerIsPlaying: Boolean);
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


procedure TApplicationScrobbler.ScrobbleJobList;
var i, idx: Integer;
    aScrobbleFile: TScrobbleFile;
    aScrobbler: TScrobbler;
    Params: TValueArray;
    sig: UnicodeString;

    procedure AddParam(name, value: String; required: Boolean);
    begin
        if (value <> '') or required then
        begin
            inc(idx);
            Params[idx].name := name;
            if value = '' then
                Params[idx].value := 'Unknown'
            else
                Params[idx].value := value;
        end;
    end;

begin
    // scrobbelcount setzen! Wichtig fürs löschen aus der Joblist bei Erfolg
    FScrobbleJobCount := JobList.Count - 1;
    if FScrobbleJobCount > 9 then
        FScrobbleJobCount := 9;
    // eigentlich sind bis zu 50 erlaubt
    // 10 am Stück reichen aber auch.
    // Der Rest wird dann ggf. danach gescrobbelt

    BeginWork;
    aScrobbler := TScrobbler.Create(fMainWindowHandle);
    try
          aScrobbler.Parent := self;
          aScrobbler.Username    := Username;
          aScrobbler.SessionKey  := SessionKey;

          SetLength(Params, (FScrobbleJobCount+1)*6 + 3);

          Params[0].name := 'api_key'; Params[0].value := UnicodeString(ApiKey)    ;
          Params[1].name := 'method';  Params[1].value := 'track.scrobble' ;
          Params[2].name := 'sk';      Params[2].value := UnicodeString(SessionKey);
          idx := 2;

          for i := 0 to FScrobbleJobCount do
          begin
              aScrobbleFile := TScrobbleFile(Joblist[i]);
              AddParam('artist[' + IntToStr(i) + ']'     , aScrobbleFile.Interpret, True );
              AddParam('track[' + IntToStr(i) + ']'      , aScrobbleFile.Title    , True );
              AddParam('timestamp[' + IntToStr(i) + ']'  , aScrobbleFile.StartTime, True );
              AddParam('album[' + IntToStr(i) + ']'      , aScrobbleFile.Album    , False);
              AddParam('duration[' + IntToStr(i) + ']'   , aScrobbleFile.Length   , False);
              AddParam('trackNumber[' + IntToStr(i) + ']', aScrobbleFile.TrackNr  , False);
          end;
          SetLength(Params, idx+1); // cut Array

          for i := 0 to length(params) - 1 do
                aScrobbler.ParamList.Add(params[i].name+'=' + ParamsEncode(UTF8Encode(params[i].value)));

          sig := GenerateSignature(SortParams(Params));
          aScrobbler.ParamList.Add('api_sig=' + sig);

          if JobList.Count = 1 then
              aScrobbler.SuccessMessage := 'Scrobble: OK. ' + TScrobbleFile(Joblist[0]).DisplayTitle
          else
              aScrobbler.SuccessMessage := 'Scrobble: OK. (' + IntToStr(FScrobbleJobCount) + ' Dateien)';

          aScrobbler.ScrobbleSubmit;
    except
      aScrobbler.Free;
      EndWork;
    end;
end;

Procedure TApplicationScrobbler.ScrobbleNext(PlayerIsPlaying: Boolean);
var i: Integer;
begin
    // Diese Proc wird aufgerufen, wenn das Submitten per "ScrobbleJobList" erfolgreich war.
    // d.h.: Die gescrobbelten Dateien aus der JobListe entfernen
    for i := 0 to FScrobbleJobCount do
        JobList.Remove(JobList[0]);
    FScrobbleJobCount := 0;

    ScrobbleAgain(PlayerIsPlaying);
end;

Procedure TApplicationScrobbler.ScrobbleAgain(PlayerIsPlaying: Boolean);
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

procedure TApplicationScrobbler.PlaybackStarted;
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

procedure TApplicationScrobbler.ProblemSolved;
begin
    ErrorInARowCount := 0;
    TimeToWaitInterval := 1;
    ValidSessionKey := True;
    EarliestNextScrobbleAttempt := Now;
end;

procedure TApplicationScrobbler.PlaybackPaused;
begin
    PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);
end;

procedure TApplicationScrobbler.PlaybackResumed;
begin
    StartTimeLocal := Now;
end;


// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------
// Class TScrobbler
// -------------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------------


constructor TScrobbler.Create(aHandle: HWnd);
begin
    inherited Create;
    fWindowHandle := aHandle;
    fThread := 0;

    fIDHttp := TIdHttp.Create;
    fIDHttp.ConnectTimeout:= 20000;
    fIDHttp.ReadTimeout:= 20000;

    fIDHttp.Request.UserAgent := 'Mozilla/3.0';
    fIDHttp.HTTPOptions :=  [];  // Hinweis: hoForceEncodeParams maskiert keine '&',
                                 // was zu Problemen bei der einen oder anderen Band führt. ;-)

    ParamList := TStringList.Create;
end;

destructor TScrobbler.Destroy;
begin
    fIDHttp.Free;
    ParamList.Free;
    inherited destroy;
end;


function TScrobbler.ParseLfmError(aResponse: UnicodeString; Mode: TScrobbleMode): TScrobbleStatus;
var p,p2,p3: Integer;
    errorCode: Integer;
    errorMessage: UnicodeString;
begin
    result := hs_UnknownFailure;

    if pos('<lfm status="failed">', aResponse) > 0 then
    begin
        // something went wrong. Get the errorcode.
        // expected format:  <error code="XX">An Error Message</error>
        p := pos('<error code="', aResponse);
        if p > 0 then
        begin
            p2 := posEx('"', aResponse, p+13);
            errorCode := StrToIntDef(Copy(aResponse, p+13, p2-p-13), 8);
            p3 := posEx('</error>', aResponse, p2);
            errorMessage := Copy(aResponse, p2+2, p3-p2-2);

            SendMessage(fWindowHandle, WM_Scrobbler, SC_Error, LParam(PWideChar(UnicodeString('Error code ' + IntToStr(ErrorCode)))));
            SendMessage(fWindowHandle, WM_Scrobbler, SC_Error, LParam(PWideChar(errorMessage)));

            case errorCode of
                4,  // Invalid authentication token supplied
                14, // This token has not been authorized
                15: // This token has expired
                   begin
                    result := hs_InvalidToken;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_InvalidToken, 0);
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                   end;

                9: begin
                    // invalid Session Key
                    // STOP scrobbling
                    result := hs_BADSESSION;
                    Parent.ValidSessionKey := False;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_InvalidSessionKey, 0);
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                end;
                11, 16: begin
                    // Server Offline, temp. unavailable
                    // Count Error, Try again
                    result := hs_FAILED;
                    if mode <> sm_Auth then
                    begin
                        Parent.CountError;
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_ServiceUnavailable, LParam(mode));
                    end else
                        SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);

                end;
                29: begin
                    // IP-Spam, wait a few minutes
                    result := hs_SPAM;
                    Parent.EarliestNextScrobbleAttempt := IncMinute(Now, 5);
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_IPSpam, 0);
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                end;
            else
                begin
                    // something strange is going on.
                    // Probably something with the implementation is wrong - STOP
                    result := hs_SCROBBLINGEXCEPTION;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_ScrobbleException, 0);
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                end;
            end;
        end;
    end else
    begin
        // something else is wrong
        if mode <> sm_Auth then
            Parent.CountError
    end;
end;

{ GetToken-Response:
     <?xml version="1.0" encoding="utf-8"?>
    <lfm status="ok">
       <token>  ...some md5-hash... </token>
    </lfm>
}
function TScrobbler.ParseGetTokenResult(aResponse: UnicodeString): AnsiString;
var idx: Integer;
begin
    idx := Pos('<token>', aResponse );
    if idx >= 1 then
        result := AnsiString(copy(aResponse, idx + length('<token>'), 32) )
    else
        result := '';
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
var Sig: UnicodeString;
    Response, MessageText: UnicodeString;
    tmpStat: TScrobbleStatus;
    ParsedResponse: AnsiString;
begin
  try
      Sig := Parent.GenerateSignature('api_key' + String(Parent.ApiKey)
              + 'method' + 'auth.gettoken');
      try
          Response := fIDHTTP.Get( BaseApiURL + '?method=auth.gettoken'
                            + '&' + 'api_key=' + String(Parent.ApiKey)
                            + '&' + 'api_sig=' + Sig);
          ParsedResponse := ParseGetTokenResult(Response);

          if (ParsedResponse <> '')  then
          begin
              SendMessage(fWindowHandle, WM_Scrobbler, SC_GetToken, lParam(PAnsiChar(ParsedResponse)));
              SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
          end
          else
          begin
              MessageText := Scrobble_GetTokenError + #13#10 + Response;
              SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
              SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
          end;

      except
            on E: EIdHTTPProtocolException do
            begin
                tmpStat := ParseLfmError(E.ErrorMessage, sm_Auth);
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + E.ErrorMessage;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, LParam(PWideChar(MessageText)));
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                end;
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end;

            on E: EIdexception do
            begin
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end;
        end;
     finally
        self.free;
     end;
end;

{  GetSession-Repsonse:
      <?xml version="1.0" encoding="utf-8"?>
      <lfm status="ok">
      <session>
         <name> ...username... </name>
         <key> ...some md5-hash... </key>
         <subscriber>0</subscriber>
      </session></lfm>
}
function TScrobbler.ParseGetSessionResult(aResponse: UnicodeString): TSessionResponse;
var start, ende: Integer;
begin
    start := Pos('<name>', aResponse);
    ende  := Pos('</name>', aResponse);
    if (start < ende) and (ende > 1) then
        result.Username := copy(aResponse, start + length('<name>'), ende - (start + length('<name>')) )
    else
        result.Username := '';

    start := Pos('<key>', aResponse );
    if start >= 1 then
        result.SessionKey := AnsiString(copy(aResponse, start + length('<key>'), 32))
    else
        result.SessionKey := '';
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
var Sig: UnicodeString;
    Response, MessageText: UnicodeString;
    ParsedResponse: TSessionResponse;
    tmpStat: TScrobbleStatus;
begin
    try
        Sig := Parent.GenerateSignature('api_key' + String(Parent.ApiKey)
              + 'method' + 'auth.getsession'
              + 'token' + String(Token));
        try
            Response := fIDHTTP.Get( BaseApiURL + '?method=auth.getsession'
                            + '&' + 'api_key=' + String(Parent.ApiKey)
                            + '&' + 'token=' + String(Token)
                            + '&' + 'api_sig=' + Sig);

            ParsedResponse := ParseGetSessionResult(Response);
            if (ParsedResponse.Username <> '') and (ParsedResponse.SessionKey <> '') then
            begin
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetSession, lParam(@ParsedResponse));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end
            else
            begin
                MessageText := Scrobble_GetSessionError + #13#10 + Response;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end;
        except
            on E: EIdHTTPProtocolException do
            begin
                tmpStat := ParseLfmError(E.ErrorMessage, sm_Auth);
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + E.ErrorMessage;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, LParam(PWideChar(MessageText)));
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
                end;
                //(z.B. 404)
            end;

            on E: EIdSocketError do
            begin
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end;

            on E: EIdexception do
            begin
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_GetAuthException, lParam(PWideChar(MessageText)));
                SendMessage(fWindowHandle, WM_Scrobbler, SC_JobIsDone, 0);
            end;
        end;
    finally
        self.free;
    end;
end;



procedure TScrobbler.ParseScrobbledFile(aResponse: UnicodeString);
var p,p2: Integer;
    correctedValue: UnicodeString;
begin
        p := pos('<track corrected="1">', aResponse);
        if p > 0 then
        begin
            p2 := posEx('</track>', aResponse, p);
            correctedValue := ParseHTMLChars(Copy(aresponse, p + 21, p2-p-21));
            SendMessage(fWindowHandle, WM_Scrobbler, SC_Hint, lParam(PWideChar(UnicodeString('Hint: Track corrected to ' + correctedValue))));
        end;

        p := pos('<artist corrected="1">', aResponse);
        if p > 0 then
        begin
            p2 := posEx('</artist>', aResponse, p);
            correctedValue := ParseHTMLChars(Copy(aresponse, p + 22, p2-p-22));
            SendMessage(fWindowHandle, WM_Scrobbler, SC_Hint, lParam(PWideChar(UnicodeString('Hint: Artist corrected to ' + correctedValue))));
        end;

        p := pos('<album corrected="1">', aResponse);
        if p > 0 then
        begin
            p2 := posEx('</album>', aResponse, p);
            correctedValue := ParseHTMLChars(Copy(aresponse, p + 20, p2-p-20));
            SendMessage(fWindowHandle, WM_Scrobbler, SC_Hint, lParam(PWideChar(UnicodeString('Hint: Album corrected to ' + correctedValue))));
        end;

        p := pos('<ignoredMessage code="1">', aResponse);
        if p > 0 then
        begin
            p2 := posEx('</ignoredMessage>', aResponse, p);
            correctedValue := ParseHTMLChars(Copy(aresponse, p + 25, p2-p-25));
            if trim(correctedValue) = '' then
                correctedValue := '(no reason specified)';
            SendMessage(fWindowHandle, WM_Scrobbler, SC_Hint, lParam(PWideChar(UnicodeString('Hint: Scrobbling ignored: ' + correctedValue))));
        end;
end;

function TScrobbler.ParseNowPlayingResult(aResponse: UnicodeString; Mode: TScrobbleMode): TScrobbleStatus;
var p,p2: Integer;
    partOfResponse: UnicodeString;
begin
    if pos('<lfm status="ok">', aResponse) > 0  then
    begin
        result := hs_OK;
        Parent.CountSuccess;

        case Mode of
            sm_Auth: ; // this method will not be called during Authentification (GetToken/GetSession)
            sm_NowPlaying: SendMessage(fWindowHandle, WM_Scrobbler, SC_NowPlayingComplete, LParam(PWideChar(SuccessMessage)));
            sm_Scrobble: SendMessage(fWindowHandle, WM_Scrobbler, SC_SubmissionComplete, LParam(PWideChar(SuccessMessage)));
        end;

        // Scan scrobbled Data for additional Hints (like "Artist corrected")
        case Mode of
            sm_Auth: ;
            sm_NowPlaying: begin
                p := pos('<nowplaying>', aResponse);
                p2 := posEx('</nowplaying>', aResponse, p);
                partOfResponse := Copy(aResponse, p+12, p2-p-12);
                ParseScrobbledFile(partOfResponse);
            end;

            sm_Scrobble: begin
                p := pos('<scrobble>', aResponse);
                while p > 0 do
                begin
                    p2 := posEx('</scrobble>', aResponse, p);
                    partOfResponse := Copy(aResponse, p+10, p2-p-10);
                    ParseScrobbledFile(partOfResponse);
                    p := posEx('<scrobble>', aResponse, p2);
                end;
            end;
        end;
    end else
        result := ParseLfmError(aResponse, Mode)
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
    Response: UnicodeString;
    MessageText: UnicodeString;
begin
    try
        try
            // 1st: Check, whether it is ok to scrobble
            // should be done in this thread, as we eventually change the corresponding values
            // if something is wrong here (Errorcount, nextAllowedScrobbelTime, etc.)
            if Parent.fScrobblingAllowed then
            begin
                Response := fIDHTTP.Post(BaseApiURL, ParamList);
                // Parse the Response and react properly
                tmpStat := ParseNowPlayingResult(Response, sm_NowPlaying);
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_UnkownError + #13#10 + 'Server message:'#13#10 + Response;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_UnknownScrobbleError, LParam(PWideChar(MessageText)));
                end;
            end;
            // else: the main window was notified by the fScrobblingAllowed-method,
            // that the scobbling was skipped and Endwork will be called via "JobDone"

        except
            on E: EIdHTTPProtocolException do
            begin
                //(z.B. 404)
                // Parse the ErrorMessage and react properly
                // here we get the lfm-errorcodes as InvalidSessionKey etc.
                tmpStat := ParseNowPlayingResult(E.ErrorMessage, sm_NowPlaying);

                // if the Status is hs_UnknownFailure
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + E.ErrorMessage;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_UnknownScrobbleError, LParam(PWideChar(MessageText)));
                end;
            end;

            on E: EIdSocketError do
            begin
                Parent.CountError;
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_IndyException, lParam(PWideChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                Parent.CountError;
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_IndyException, lParam(PWideChar(MessageText)));
            end;

        end;
    finally
        self.free;
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
    Response, MessageText: UnicodeString;
begin
    try
        try
            if Parent.fScrobblingAllowed then
            begin
                Response := fIDHTTP.Post(BaseApiURL, ParamList);
                // Parse the Response and react properly
                tmpStat := ParseNowPlayingResult(Response, sm_Scrobble);
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_UnkownError + #13#10 + 'Server message:'#13#10 + Response;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_UnknownScrobbleError, LParam(PWideChar(MessageText)));
                end;
            end;
        except
            on E: EIdHTTPProtocolException do
            begin
                tmpStat := ParseNowPlayingResult(E.ErrorMessage, sm_Scrobble);

                // if the Status is hs_UnknownFailure
                if tmpStat = hs_UnknownFailure then
                begin
                    MessageText := Scrobble_ProtocolError + #13#10 + 'Server message:'#13#10 + E.Message + #13#10 + E.ErrorMessage;
                    SendMessage(fWindowHandle, WM_Scrobbler, SC_UnknownScrobbleError, LParam(PWideChar(MessageText)));
                end;
            end;

            on E: EIdSocketError do
            begin
                MessageText := Scrobble_ConnectError + #13#10 + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_IndyException, lParam(PWideChar(MessageText)));
            end;

            on E: EIdexception do
            begin
                MessageText := Scrobble_UnkownError + '(' + E.ClassName + ') ' + E.Message;
                SendMessage(fWindowHandle, WM_Scrobbler, SC_IndyException, lParam(PWideChar(MessageText)));
            end;
        end;

    finally
        self.free;
    end;
end;


end.


