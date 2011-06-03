{

    Unit UpdateUtils

    - Class for Updating-Stuff.
      Connects to gausi.de,
      Check for a new version and
      Show proper MessageBox

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
unit UpdateUtils;

interface

uses Windows, Classes, SysUtils, StrUtils, Messages, ExtCtrls, DateUtils, Inifiles, Controls,
     IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, IdException, Nemp_RessourceStrings;

type

    TNempVersion = class
        private
            fMajor: Cardinal;
            fMinor: Cardinal;
            fPatch: Cardinal;
            fBuild: Cardinal;
        public
            property Major: Cardinal read fMajor;
            property Minor: Cardinal read fMinor;
            property Patch: Cardinal read fPatch;
            property Build: Cardinal read fBuild;
            constructor Create;
    end;

    TUpdateType = (utNone, utError, utMajor, utMinor, utPatch, utBuild, utDownGrade);

    TNempUpdateInfo = class
       StableRelease: String;
       LastRelease: String;
       ReleaseStatus: String;
       ReleaseNote: String;	
    end;

    TNempUpdater = class
        private
            fChecking: LongBool;
            fCancel: LongBool;

            fTimer: TTimer;

            fWindowHandle: HWnd;

            fLastCheck: TDateTime;
            fCheckInterval: Integer;
            fAutoCheck: Boolean;

            fThread: Integer;
            fDownloadString: String;

            fManualCheck: Boolean;
            fNotifyOnBetas: Boolean;

            fWriteAccessPossible: Boolean;

            procedure fCheckForUpdates;
            function fGetUpdateType(aString: String): TUpdateType;

            procedure DoOnTimer(Sender: TObject);

            function GetCancel: LongBool;
            procedure SetCancel(Value: LongBool);
            function GetChecking: LongBool;
            procedure SetChecking(Value: LongBool);

            function GetLastCheck: TDateTime;
            procedure SetLastCheck(Value: TDateTime);


        public
            property LastCheck: TDateTime read GetLastCheck write SetLastCheck;

            // Gibt an, ob gerade ein Check (d.h. ein Thread zum runterladen) läuft oder nicht
            property Checking: LongBool read GetChecking write SetChecking;

            // Gibt an, ob nach dem runterladen weitergemacht werden soll (
            // Set Cancel = True z.B. bei OnDestroy vor dem WaitForSingleObject
            // Threadsicher arbeiten
            property Cancel: LongBool read GetCancel write SetCancel;

            // URL zur Versionsdatei im Netz (im Create setzen, nie ändern)
            // property VersionInfoPath: String read fVersionInfoPath write fVersionInfoPath;

            // Update-Intervall in Tagen
            // 0: Bei jedem Start
            property CheckInterval: Integer read fCheckInterval write fCheckInterval;
            property AutoCheck: Boolean read fAutoCheck write fAutoCheck;
            property NotifyOnBetas: Boolean read fNotifyOnBetas write fNotifyOnBetas;

            property ManualCheck: Boolean read fManualCheck;

            // Is writeaccess to the inifile possible? If not: Dont show Diaalog, Dont search for Updates
            property WriteAccessPossible: Boolean read fWriteAccessPossible write fWriteAccessPossible;

            constructor Create(aHandle: HWnd);
            destructor Destroy; override;

            procedure CheckForUpdatesManually;
            procedure CheckForUpdatesAutomatically;

            procedure LoadFromIni(ini: TMemIniFile);
            procedure WriteToIni(ini: TMemIniFile);
    end;

    procedure StartCheckForUpdates(Updater: TNempUpdater);


const
    WM_Update = WM_USER + 750;
    UPDATE_CONNECT_ERROR = 1;
    UPDATE_VERSION_ERROR = 2;
    UPDATE_NEWER_VERSION = 3;
    UPDATE_CURRENT_VERSION = 4;
//    UPDATE_OLDER_VERSION = 5;

    UPDATE_TEST_VERSION = 6;
    UPDATE_CURRENTTEST_VERSION = 7;
    UPDATE_NEWERTEST_VERSION = 8;
    UPDATE_PRIVATE_VERSION = 9;


    UPDATE_URL = 'http://www.gausi.de/nemp/current_version.txt';


Var
    NempUpdater: TNempUpdater;

    CSNempUpdateAccessLastCheck: RTL_CRITICAL_SECTION;



implementation

uses
  Dialogs;

constructor TNempVersion.Create;
var
  lpVerInfo: pointer;
  rVerValue: PVSFixedFileInfo;
  dwInfoSize: cardinal;
  dwValueSize: cardinal;
  dwDummy: cardinal;
  lpstrPath: pChar;

begin
    inherited Create;

    lpstrPath := pChar(Paramstr(0));
    dwInfoSize := GetFileVersionInfoSize(lpstrPath, dwDummy);
    if dwInfoSize = 0 then
    begin
        fMajor := 0;
        fMinor := 0;
        fPatch := 0;
        fBuild := 0;
    end else
    begin
        GetMem(lpVerInfo, dwInfoSize);
        GetFileVersionInfo(lpstrPath, 0, dwInfoSize, lpVerInfo);
        VerQueryValue(lpVerInfo, '\', pointer(rVerValue), dwValueSize);

        with rVerValue^ do
        begin
          fMajor := dwFileVersionMS shr 16;
          fMinor := dwFileVersionMS and $FFFF;
          fPatch := dwFileVersionLS shr 16;
          fBuild := dwFileVersionLS and $FFFF;
        end;
        FreeMem(lpVerInfo, dwInfoSize);
    end;
end;

constructor TNempUpdater.Create(aHandle: HWnd);
begin
    inherited Create;
    fTimer := TTimer.Create(Nil);
    fTimer.Interval := 60000; // = 1 minute
    fTimer.OnTimer := DoOnTimer;
    fTimer.Enabled := True;
    
    fWindowHandle := aHandle;
    fThread := 0;
end;

destructor TNempUpdater.Destroy;
begin
  Cancel := True;
  if fThread <> 0 then
      WaitForSingleObject(fThread, 5000);
  fTimer.Free;
  inherited destroy;
end;

procedure TNempUpdater.DoOnTimer(Sender: TObject);
begin
    fTimer.Enabled := False;


    if AutoCheck and ((CheckInterval = 0) or (DaysBetween(Now, LastCheck) >= CheckInterval)) then
    begin
        ///  New in Nemp 3.3.3: First MessageDlg canceled.
        ///  Reason: People should know this function now
        ///     and: starting from a CD will cause this dialog EVERY time.
        // ok, AutoCheck is true, so do it
        CheckForUpdatesAutomatically;
    end;
end;

function TNempUpdater.GetCancel: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fCancel));
end;
procedure TNempUpdater.SetCancel(Value: LongBool);
begin
    InterLockedExchange(Integer(fCancel), Integer(Value));
end;

function TNempUpdater.GetChecking: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fChecking));
end;
procedure TNempUpdater.SetChecking(Value: LongBool);
begin
    InterLockedExchange(Integer(fChecking), Integer(Value));
end;

function TNempUpdater.GetLastCheck: TDateTime;
begin
    EnterCriticalSection(CSNempUpdateAccessLastCheck);
    result := fLastCheck;
    LeaveCriticalSection(CSNempUpdateAccessLastCheck)
end;
procedure TNempUpdater.SetLastCheck(Value: TDateTime);
begin
    EnterCriticalSection(CSNempUpdateAccessLastCheck);
    fLastCheck := Value;
    LeaveCriticalSection(CSNempUpdateAccessLastCheck);
end;

procedure StartCheckForUpdates(Updater: TNempUpdater);
begin
    Updater.fCheckForUpdates;
end;


procedure TNempUpdater.CheckForUpdatesManually;
var Dummy: Cardinal;
begin
    Cancel := False;
    Checking := True;
    fManualCheck := True;

    if fThread = 0 then
        fThread := BeginThread(Nil, 0, @StartCheckForUpdates, Self, 0, Dummy)
end;

procedure TNempUpdater.CheckForUpdatesAutomatically;
var Dummy: Cardinal;
begin
    Cancel := False;
    Checking := True;
    fManualCheck := False;
    if fThread = 0 then
        fThread := BeginThread(Nil, 0, @StartCheckForUpdates, Self, 0, Dummy)
end;

procedure TNempUpdater.fCheckForUpdates;
var IDHttp: TIDHttp;
    MessageText: String;
    sl: TStrings;
    ini: TMemIniFile;
    // StableVersion, LastRelease, ReleaseStatus, ReleaseNote: String;
    NempUpdateInfo: TNempUpdateInfo;

begin
    // Indy erstellen, Datei runterladen, Version checken, ggf. Message absenden (falls Cancel=false)
    IDHttp :=  TidHttp.Create;
    try
        IDHttp.ConnectTimeout:= 5000;
        IDHttp.ReadTimeout:= 5000;
        IDHttp.Request.UserAgent := 'Mozilla/3.0';

        // VersionsDatei herunterladen
        fDownloadString := '';
        fDownloadString := IDHttp.Get(UPDATE_URL);


        if not Cancel then
        begin
            sl := TStringList.Create;
            try
                sl.Text := fDownloadString;
                ini := TMemIniFile.Create('');
                try
                    ini.SetStrings(sl);
                    NempUpdateInfo := TNempUpdateInfo.Create;
                    try
                        NempUpdateInfo.StableRelease := ini.ReadString('UpdateInfo', 'StableRelease', 'x.x.x.x');
                        NempUpdateInfo.LastRelease   := ini.ReadString('UpdateInfo', 'LastRelease', NempUpdateInfo.StableRelease);
                        NempUpdateInfo.ReleaseStatus := ini.ReadString('UpdateInfo', 'ReleaseStatus', 'Beta');
                        NempUpdateInfo.ReleaseNote   := ini.ReadString('UpdateInfo', 'ReleaseNote', 'Use with caution!');


                        case fGetUpdateType(NempUpdateInfo.StableRelease) of
                            utError : SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);
                            utMajor,
                            utMinor,
                            utPatch,  // Es gibt eine neue Stabile Version => Update empfehlen
                            utBuild : SendMessage(fWindowHandle, WM_Update, UPDATE_NEWER_VERSION, lParam(NempUpdateInfo));  //Param: Stable-version aus Ini

                            utNone  : begin
                                // stabile Version ist aktuell - ggf. auf alpha/beta/release candidate testen

                                if NempUpdateInfo.LastRelease = NempUpdateInfo.StableRelease then
                                    // lokale Version ist die aktuelle, weitere Testversionen gibt es nicht
                                    SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENT_VERSION, 0)       // Kein Parameter notwendig
                                else
                                begin
                                    // Lastrelease weicht zumindest auf den ersten Blick von der lokalen Version ab
                                    case fGetUpdateType(NempUpdateInfo.LastRelease) of
                                        utError: SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);
                                        utMajor,
                                        utMinor,
                                        utPatch,
                                        utBuild : // lokale Version aktuell, aber eine Testversion ist verfügbar
                                            SendMessage(fWindowHandle, WM_Update, UPDATE_TEST_VERSION, lParam(NempUpdateInfo));

                                        utNone: // lokale Version aktuell, neue Testversion auch (der Fall kann eigentlich hier nicht eintreten)
                                            SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENTTEST_VERSION, 0);

                                        utDownGrade: // lokale Version aktuell, und _neuer_ als das letzte Release!
                                                     // kann eigentlich auch nicht auftreten, da LastRelease >= StableVersion gilt
                                            SendMessage(fWindowHandle, WM_Update, UPDATE_PRIVATE_VERSION, lParam(NempUpdateInfo));
                                    end;
                                end;
                            end; // StableVersion = lokale Version

                            utDownGrade : begin
                                // Lokale Version ist bereits eine Testversion
                                // hier: auf eine neue Testversion checken ...

                                case fGetUpdateType(NempUpdateInfo.LastRelease) of
                                    utError: SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);
                                    utMajor,
                                    utMinor,
                                    utPatch,
                                    utBuild : // Neuere TestVersion ist verfügbar
                                        SendMessage(fWindowHandle, WM_Update, UPDATE_NEWERTEST_VERSION, lParam(NempUpdateInfo));

                                    utNone: // lokale Version ist die aktuellste Testversion
                                        SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENTTEST_VERSION, 0);

                                    utDownGrade: // lokale Version ist noch nicht auf dem Server bekannt
                                        SendMessage(fWindowHandle, WM_Update, UPDATE_PRIVATE_VERSION, lParam(NempUpdateInfo));
                                end
                            end;
                        end;
                    finally
                        NempUpdateInfo.Free;
                    end;
                finally
                    ini.Free;
                end;
                LastCheck := Now;

            finally
                sl.Free;
            end;
        end; // else nichts machen

    except
        on E: EIdHTTPProtocolException do
        begin
            MessageText := NempUpdate_Error + #13#10#13#10 + E.Message;
            SendMessage(fWindowHandle, WM_Update, UPDATE_CONNECT_ERROR, lParam(PChar(MessageText)));
            //(z.B. 404)
        end;

        on E: EIdSocketError do
        begin
            MessageText := NempUpdate_ConnectError + #13#10#13#10 + E.Message;
            SendMessage(fWindowHandle, WM_Update, UPDATE_CONNECT_ERROR, lParam(PChar(MessageText)));
        end;

        on E: EIdexception do
        begin
            MessageText := NempUpdate_UnkownError + '(' + E.ClassName + ')' + #13#10#13#10 + E.Message;
            SendMessage(fWindowHandle, WM_Update, UPDATE_CONNECT_ERROR, lParam(PChar(MessageText)));
        end;
    end;

    // Am Ende:
    Checking := False;
    CloseHandle(fThread);
    fThread := 0;

    IDHttp.Free;
end;

function TNempUpdater.fGetUpdateType(aString: String): TUpdateType;
var idx1, idx2: Integer;
    intStr: String;
    major, minor, patch, build: Cardinal;
    NempVersion: TNempVersion;
begin
  //(utNone, utError, utMajor, utMinor, utPatch, utBuild);
//  result := utNone;

  idx1 := 1;
  idx2 := pos('.', aString);
  intStr := Copy(aString, idx1, idx2-idx1);
  major := StrToIntDef(intStr, 99999);

  idx1 := idx2+1;
  idx2 := posEx('.', aString, idx1);
  intStr := Copy(aString, idx1, idx2-idx1);
  minor := StrToIntDef(intStr, 99999);

  idx1 := idx2+1;
  idx2 := posEx('.', aString, idx1);
  intStr := Copy(aString, idx1, idx2-idx1);
  patch := StrToIntDef(intStr, 99999);

  idx1 := idx2+1;
  //idx2 := posEx('.', fDownloadString, idx1);
  intStr := Copy(aString, idx1, 10);
  build := StrToIntDef(intStr, 99999);

  if (major = 99999) or (minor = 99999) or (patch = 99999) or (build = 99999) then
      result := utError
  else
  begin
      NempVersion := TNempVersion.Create;
      result := utNone;
      try
          try
              if major > NempVersion.Major then
                  result := utMajor;

              if major < NempVersion.Major then
                  result := utDownGrade;

              if (result = utNone) and (minor > NempVersion.Minor) then
                  result := utMinor;
              if (result = utNone) and (minor < NempVersion.Minor) then
                  result := utDownGrade;

              if (result = utNone)  and (patch > NempVersion.Patch) then
                  result := utPatch;
              if (result = utNone)  and (patch < NempVersion.Patch) then
                  result := utDownGrade;

              if (result = utNone)  and (build > NempVersion.Build) then
                  result := utBuild;
              if (result = utNone)  and (build < NempVersion.Build) then
                  result := utDownGrade;
          except
              result := utError;
          end;
      finally
          NempVersion.Free;
      end;
  end;
end;

procedure TNempUpdater.LoadFromIni(ini: TMemIniFile);
begin
    LastCheck      := Ini.ReadDateTime('Updater', 'LastCheck', 0);
    fCheckInterval := Ini.ReadInteger('Updater', 'Interval', 7);
    fAutoCheck     := Ini.ReadBool('Updater', 'AutoCheck', False);
    fNotifyOnBetas := Ini.ReadBool('Updater', 'NotifyOnBetas', False);
end;

procedure TNempUpdater.WriteToIni(ini: TMemIniFile);
begin
     Ini.WriteDateTime('Updater', 'LastCheck', LastCheck);
     Ini.WriteInteger('Updater', 'Interval', fCheckInterval);
     Ini.WriteBool('Updater', 'AutoCheck', fAutoCheck);
     Ini.WriteBool('Updater', 'NotifyOnBetas', fNotifyOnBetas);
end;

initialization

  InitializeCriticalSection(CSNempUpdateAccessLastCheck);

finalization

  DeleteCriticalSection(CSNempUpdateAccessLastCheck);


end.
