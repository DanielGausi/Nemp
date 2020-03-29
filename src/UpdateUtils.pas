{

    Unit UpdateUtils

    - Class for Updating-Stuff.
      Connects to gausi.de,
      Check for a new version and
      Show proper MessageBox

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
unit UpdateUtils;

interface

uses Windows, Classes, SysUtils, StrUtils, Messages, ExtCtrls, DateUtils,
      Variants,  Graphics,  Forms, WinApi.ShellApi, Richedit, Vcl.StdCtrls,
  Vcl.Controls, Vcl.ComCtrls,
     Inifiles, System.Net.URLClient, System.Net.HttpClient, SystemHelper,
     HtmlHelper, Nemp_RessourceStrings;

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

    TUpdateType = (utNone, utError, utDownGrade, utUpgrade);

    TNempUpdateInfo = class
       StableRelease: String;
       BetaRelease: String;
       ReleaseNotes: TMemoryStream;
       ReleaseNotes_DE: TMemoryStream;

       ReleaseIsStable: Boolean;
       DeveloperRelease: Boolean;
       constructor Create;
       destructor Destroy; override;
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

            // Update-Intervall in Tagen
            // 0: Bei jedem Start
            property CheckInterval: Integer read fCheckInterval write fCheckInterval;
            property AutoCheck: Boolean read fAutoCheck write fAutoCheck;
            property NotifyOnBetas: Boolean read fNotifyOnBetas write fNotifyOnBetas;

            property ManualCheck: Boolean read fManualCheck;

            // Is writeaccess to the inifile possible? If not: Dont show Dialog, Dont search for Updates
            property WriteAccessPossible: Boolean read fWriteAccessPossible write fWriteAccessPossible;

            constructor Create(aHandle: HWnd);
            destructor Destroy; override;

            procedure CheckForUpdatesManually;
            procedure CheckForUpdatesAutomatically;

            procedure LoadFromIni(ini: TMemIniFile);
            procedure WriteToIni(ini: TMemIniFile);
    end;

    TUpdateForm = class(TForm)
        RichEdit1: TRichEdit;
        Panel1: TPanel;
        ImgLogo: TImage;
        LblNewVersion: TLabel;
        BtnDownload: TButton;
        BtnClose: TButton;
    lblCurrentVersion: TLabel;
        procedure BtnCloseClick(Sender: TObject);
        procedure BtnDownloadClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    private
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
        UpdateInfo: TNempUpdateInfo;
    end;

    procedure StartCheckForUpdates(Updater: TNempUpdater);


const
    WM_Update = WM_USER + 750;
    UPDATE_CONNECT_ERROR = 1;
    UPDATE_VERSION_ERROR = 2;
    UPDATE_NEWER_VERSION = 3;
    UPDATE_CURRENT_VERSION = 4;

    UPDATE_TEST_VERSION = 6;
    UPDATE_CURRENTTEST_VERSION = 7;
    UPDATE_NEWERTEST_VERSION = 8;
    UPDATE_PRIVATE_VERSION = 9;

    UPDATE_URL = 'http://www.gausi.de/nemp/update_summary.txt'; // new URL since 4.13

    // some RTF files with ReleaseNotes (new in 4.13)
    RELEASENOTES_URL = 'http://www.gausi.de/nemp/updates.rtf';
    RELEASENOTES_BETA_URL = 'http://www.gausi.de/nemp/updates_beta.rtf';
    RELEASENOTES_DEV_URL = 'http://www.gausi.de/nemp/updates_dev.rtf';

    RELEASENOTES_URL_DE = 'http://www.gausi.de/nemp/updates_de.rtf';
    RELEASENOTES_BETA_URL_DE = 'http://www.gausi.de/nemp/updates_beta_de.rtf';
    RELEASENOTES_DEV_URL_DE = 'http://www.gausi.de/nemp/updates_dev_de.rtf';


Var
    NempUpdater: TNempUpdater;
    UpdateForm: TUpdateForm;

    CSNempUpdateAccessLastCheck: RTL_CRITICAL_SECTION;

implementation

uses
  Dialogs, NempMainUnit;

  {$R *.dfm}

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
var MessageText, fDownloadString: String;
    sl: TStrings;
    ini: TMemIniFile;
    NempUpdateInfo: TNempUpdateInfo;
    aResponse: IHttpResponse;

    StableUpdate, BetaUpdate: TUpdateType;

begin
    try
        // Get Update Summary
        fDownloadString := '';
        fDownloadString := GetURLAsString(UPDATE_URL);

        if fDownloadString = '' then
            exit;

        if Cancel then
            exit;

        sl := TStringList.Create;
        try
            sl.Text := fDownloadString;
            ini := TMemIniFile.Create('');
            try
                ini.SetStrings(sl);
                NempUpdateInfo := TNempUpdateInfo.Create;
                try
                    NempUpdateInfo.DeveloperRelease := False;
                    // Get version information from the downloaded Update Summary
                    NempUpdateInfo.StableRelease := ini.ReadString('UpdateInfo', 'StableRelease', 'x.x.x.x');
                    NempUpdateInfo.BetaRelease   := ini.ReadString('UpdateInfo', 'BetaRelease', NempUpdateInfo.StableRelease);

                    StableUpdate := fGetUpdateType(NempUpdateInfo.StableRelease);
                    BetaUpdate   := fGetUpdateType(NempUpdateInfo.BetaRelease)  ;

                    // Download Release Notes
                    // (we just download both german and english release notes)
                    if (StableUpdate = utUpgrade) then
                    begin
                        // Download Release Information (Stable)
                        aResponse := GetURLAsHttpResponse(RELEASENOTES_URL);
                        if aResponse.StatusCode = 200 then
                            NempUpdateInfo.ReleaseNotes.CopyFrom(aResponse.ContentStream, 0);
                        if Cancel then exit;

                        // Download Release Information (German, Stable)
                        aResponse := GetURLAsHttpResponse(RELEASENOTES_URL_DE);
                        if aResponse.StatusCode = 200 then
                            NempUpdateInfo.ReleaseNotes_DE.CopyFrom(aResponse.ContentStream, 0);
                        if Cancel then exit;

                        NempUpdateInfo.ReleaseIsStable := True;
                    end
                    else
                        if (BetaUpdate = utUpgrade) then
                        begin
                            // Download Release Information (Beta)
                            aResponse := GetURLAsHttpResponse(RELEASENOTES_BETA_URL);
                            if aResponse.StatusCode = 200 then
                                NempUpdateInfo.ReleaseNotes.CopyFrom(aResponse.ContentStream, 0);
                            if Cancel then exit;

                            // Download Release Information (German, Beta)
                            aResponse := GetURLAsHttpResponse(RELEASENOTES_BETA_URL_DE);
                            if aResponse.StatusCode = 200 then
                                NempUpdateInfo.ReleaseNotes_DE.CopyFrom(aResponse.ContentStream, 0);
                            if Cancel then exit;

                            NempUpdateInfo.ReleaseIsStable := False;
                        end else
                        begin
                            // current local version is a Developer Version
                            // download developer notes (for testing before releasing them)
                            // Download Release Information (Beta)
                            aResponse := GetURLAsHttpResponse(RELEASENOTES_DEV_URL);
                            if aResponse.StatusCode = 200 then
                                NempUpdateInfo.ReleaseNotes.CopyFrom(aResponse.ContentStream, 0);
                            if Cancel then exit;

                            // Download Release Information (German, Beta)
                            aResponse := GetURLAsHttpResponse(RELEASENOTES_DEV_URL_DE);
                            if aResponse.StatusCode = 200 then
                                NempUpdateInfo.ReleaseNotes_DE.CopyFrom(aResponse.ContentStream, 0);
                            if Cancel then exit;

                            NempUpdateInfo.ReleaseIsStable := False;
                            NempUpdateInfo.DeveloperRelease := True;
                        end;


                    case StableUpdate of
                        // something is wrong with the Uodate-File
                        utError   : SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);

                        // There is an Update available
                        utUpgrade : SendMessage(fWindowHandle, WM_Update, UPDATE_NEWER_VERSION, lParam(NempUpdateInfo));  //Param: Stable-version aus Ini

                        // current user version matches the most recent stable version
                        utNone  : begin
                            // check for "beta" versions
                            if NempUpdateInfo.BetaRelease = NempUpdateInfo.StableRelease then
                                // both version informations are the same - no further action needed
                                SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENT_VERSION, 0)
                            else
                            begin
                                // Beta version may be newer than the last stable release
                                case BetaUpdate of
                                    utError: SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);

                                    // new beta version available
                                    utUpgrade: SendMessage(fWindowHandle, WM_Update, UPDATE_TEST_VERSION, lParam(NempUpdateInfo));

                                    // same version (should not happen here ...)
                                    utNone: SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENTTEST_VERSION, 0);

                                    // another case that should be impossible, unless the release information ist bugged
                                    // (beta versions should have a *higher* number than stable releases)
                                    utDownGrade: SendMessage(fWindowHandle, WM_Update, UPDATE_PRIVATE_VERSION, lParam(NempUpdateInfo));
                                end;
                            end;
                        end; // StableVersion = curent user version

                        // current user version is already a beta version
                        utDownGrade : begin
                            // check, whether there is a more recent beta version
                            case BetaUpdate of
                                utError: SendMessage(fWindowHandle, WM_Update, UPDATE_VERSION_ERROR, 0);

                                // new beta version available
                                utUpgrade : SendMessage(fWindowHandle, WM_Update, UPDATE_NEWERTEST_VERSION, lParam(NempUpdateInfo));

                                // no update available
                                utNone: SendMessage(fWindowHandle, WM_Update, UPDATE_CURRENTTEST_VERSION, 0);

                                // developer version, should only happen for me and noone else ;-)
                                utDownGrade:  SendMessage(fWindowHandle, WM_Update, UPDATE_PRIVATE_VERSION, lParam(NempUpdateInfo));
                            end;

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

    except
        on E: ENetHTTPClientException do begin
            MessageText := Format(HTTP_Connection_Error, [GetDomainFromURL(UPDATE_URL), E.Message]);
            SendMessage(fWindowHandle, WM_Update, UPDATE_CONNECT_ERROR, lParam(PChar(MessageText)));
        end;

        on E: Exception do
        begin
            MessageText := NempUpdate_Error + #13#10#13#10 + E.Message ;
            SendMessage(fWindowHandle, WM_Update, UPDATE_CONNECT_ERROR, lParam(PChar(MessageText)));
        end;
    end;


    // Am Ende:
    Checking := False;
    CloseHandle(fThread);
    fThread := 0;
end;


function TNempUpdater.fGetUpdateType(aString: String): TUpdateType;
var idx1, idx2: Integer;
    intStr: String;
    major, minor, patch, build: Cardinal;
    NempVersion: TNempVersion;
begin
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
                  result := utUpgrade;

              if major < NempVersion.Major then
                  result := utDownGrade;

              if (result = utNone) and (minor > NempVersion.Minor) then
                  result := utUpgrade;
              if (result = utNone) and (minor < NempVersion.Minor) then
                  result := utDownGrade;

              if (result = utNone)  and (patch > NempVersion.Patch) then
                  result := utUpgrade;
              if (result = utNone)  and (patch < NempVersion.Patch) then
                  result := utDownGrade;

              if (result = utNone)  and (build > NempVersion.Build) then
                  result := utUpgrade;
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

procedure TUpdateForm.BtnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TUpdateForm.BtnDownloadClick(Sender: TObject);
begin
    if (LeftStr(Nemp_MainForm.NempOptions.Language,2) = 'de') then
        ShellExecute(Handle, 'open', 'http://www.gausi.de/nemp.html', nil, nil, SW_SHOW)
    else
        ShellExecute(Handle, 'open', 'http://www.gausi.de/nemp-en.html', nil, nil, SW_SHOW);
end;

procedure TUpdateForm.FormCreate(Sender: TObject);
var filename: String;
begin
    filename := ExtractFilePath(ParamStr(0)) + 'Images\NempLogo.png';
    if FileExists(filename) then
        ImgLogo.Picture.LoadFromFile(filename);
end;

procedure TUpdateForm.FormShow(Sender: TObject);
begin
    UpdateInfo.ReleaseNotes.Position := 0;

    if UpdateInfo.ReleaseIsStable then
        lblNewVersion.Caption     := Format(NempUpdate_InfoNewVersionAvailable, [UpdateInfo.StableRelease] )
    else
    begin
        if UpdateInfo.DeveloperRelease then
            lblNewVersion.Caption     := Format(NempUpdate_InfoDeveloperVersion, [UpdateInfo.StableRelease] )
        else
            lblNewVersion.Caption     := Format(NempUpdate_InfoNewBetaVersionAvailable, [UpdateInfo.BetaRelease] );
    end;

    BtnDownload.Enabled := Not UpdateInfo.DeveloperRelease;

    lblCurrentVersion.Caption := Format(NempUpdate_InfoYourVersion        , [GetFileVersionString('')] );

    UpdateInfo.ReleaseNotes_DE.Position := 0;
    UpdateInfo.ReleaseNotes.Position := 0;

    if (LeftStr(Nemp_MainForm.NempOptions.Language,2) = 'de') then
    begin
        if UpdateInfo.ReleaseNotes_DE.Size = 0 then
            // If the german release notes are empty: Show the regular ones
            // (this may happen on beta releases ...)
            UpdateForm.RichEdit1.Lines.LoadFromStream(UpdateInfo.ReleaseNotes)
        else
            UpdateForm.RichEdit1.Lines.LoadFromStream(UpdateInfo.ReleaseNotes_DE);
    end else
        UpdateForm.RichEdit1.Lines.LoadFromStream(UpdateInfo.ReleaseNotes);
end;

{ TNempUpdateInfo }

constructor TNempUpdateInfo.Create;
begin
    ReleaseNotes    := TMemoryStream.Create;
    ReleaseNotes_DE := TMemoryStream.Create;
    DeveloperRelease := False;
end;

destructor TNempUpdateInfo.Destroy;
begin
  ReleaseNotes.Free;
  ReleaseNotes_DE.Free;
  inherited;
end;

initialization

  InitializeCriticalSection(CSNempUpdateAccessLastCheck);

finalization

  DeleteCriticalSection(CSNempUpdateAccessLastCheck);


end.
