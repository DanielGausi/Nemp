// -----------------------------------------------------------------------------
//
// TFolderBrowser-Klasse
// Copyright (c) 2003-2005 Delphi-Forum
// Tino, Popov, Christian Stelzman (PL), Luckie, Aton, Mathias Simmack (msi)
//
// basiert auf den folgenden Beiträgen
//   - http://www.delphi-forum.de/viewtopic.php?t=11240
//   - http://www.delphi-forum.de/viewtopic.php?t=21471
//   * http://www.delphi-forum.de/viewtopic.php?t=25302
//   - http://www.delphi-forum.de/viewtopic.php?t=27010&start=0
//
// -----------------------------------------------------------------------------

// -- Revision history ---------------------------------------------------------
//
//
//
//
//
//   * ursprüngliche Version von PL (s. Link #3)
//   * Fehlerkorrekturen von Luckie
//       - Result bei Callback ergänzt
//       - Properties als private deklariert
//       - Bugs in "Execute"-Methode behoben
//   * Dateifilter in Callback-Funktion
//       - Idee (Aton)
//       - globale Stringvariable (msi)
//       - TFolderBrowser-Klasse (PL)
//   * Unterstützung für mehrere Filter ergänzt (msi)
//   * Unterstützung für verschiedene Root-Ordner (msi)
//   * Änderungen bei den Properties (msi)
//       - "SelFolder" in "SelectedItem" umbenannt
//       - "FNewFolder" als "NewFolderButton" verfügbar
//       - "FShowFiles" als "ShowFiles" verfügbar
//       - "FNoTT" als "NoTargetTranslation" verfügbar (XP-Flag)
//   * Funktion zum Ermitteln von Verknüpfungszielen ergänzt (msi)
//       - Ergänzung, um Umgebungsvariablen umzuwandeln
//   * "InitFolder" (s. Create) umbenannt in "PreSelectedFolder" (PL)
//   * "FNoTT" (NoTargetTranslation) standardmäßig auf TRUE gesetzt,
//     damit alle Windows-Versionen, inkl. XP, gleich reagieren (msi)
//   * "CoInitializeEx" (Execute & TranslateLink) geändert (msi)
//   * "TranslateMsiLink" (PL, msi)
//        - ermittelt Pfad/Programm aus MSI-Verknüpfungen (Office, Openoffice)
//        - benötigt installierten MSI
//
//   * Delphi2009-Support by jaenicke
//   * kleinere Änderungen bzgl. der Flags von Daniel Gausi Gaussmann
// -----------------------------------------------------------------------------
unit fldbrows;


interface

uses
  ShlObj, ActiveX, Windows, Messages;

type
  TFolderBrowser = class
  private
    // alles private gemacht; geht niemanden was an,
    // da nachträglicher Zugriff sinnlos (Luckie)
    FHandle      : THandle;
    FCaption     : string;
    FShowFiles   : boolean;
    FNewFolder   : boolean;
    FStatusText  : boolean;
    FNoTT        : boolean;
    FInitFolder  : string;
    FSelected    : string;
    FTop,
    FLeft        : integer;
    FPosChanged  : boolean;

    // mehrere Filter müssen durch #0 voneinander getrennt
    // werden, bspw. '*.txt'#0'*.*htm*'#0'*.xml'
    // der letzte Filter kann mit #0#0 enden, muss er aber
    // nicht, weil die Funktion "CheckFilter" diese beiden
    // Zeichen automatisch anhängt (Mathias)
    FFilter      : string;
    FRoot        : PItemIdList;
    procedure FreeItemIDList(var pidl: pItemIDList);
    procedure SetTopPosition(const Value: Integer);
    procedure SetLeftPosition(const Value: Integer);
  public
    constructor Create(Handle: THandle; const Caption: string;
      const PreSelectedFolder: string = ''; ShowFiles: Boolean = False;
      NewFolder: Boolean = False);
    destructor Destroy; override;
    function SetDefaultRoot: boolean;
    function SetRoot(const SpecialFolderId: integer): boolean; overload;
    function SetRoot(const Path: string): boolean; overload;
    function Execute: Boolean; overload;
    function TranslateLink(const LnkFile: string): string;
    function TranslateMsiLink(const LnkFile: string): string;
    property SelectedItem: string read FSelected;
    property Filter: string read FFilter write FFilter;
    property NewFolderButton: boolean read FNewFolder write FNewFolder;
    property ShowFiles: boolean read FShowFiles write FShowFiles;
    property StatusText: boolean read FStatusText write FStatusText;
    property NoTargetTranslation: boolean read FNoTT write FNoTT;
    property Top: integer read FTop write SetTopPosition;
    property Left: integer read FLeft write SetLeftPosition;
  end;

implementation


//
// erweiterte SHBrowseForFolder-Eigenschaften
// (Deklaration ist notwendig, weil u.U. nicht in jeder Delphi-Version
// bekannt und verfügbar)
//
const
  BIF_NEWDIALOGSTYLE     = $0040;
  BIF_USENEWUI           = BIF_NEWDIALOGSTYLE or BIF_EDITBOX;
  BIF_BROWSEINCLUDEURLS  = $0080;
  BIF_UAHINT             = $0100;
  BIF_NONEWFOLDERBUTTON  = $0200;
  BIF_NOTRANSLATETARGETS = $0400;
  BIF_SHAREABLE          = $8000;

  BFFM_IUNKNOWN          = 5;
  BFFM_SETOKTEXT         = WM_USER + 105; // Unicode only
  BFFM_SETEXPANDED       = WM_USER + 106; // Unicode only


// -- helper functions ---------------------------------------------------------

function fileexists(const FileName: string): boolean;
var
  Handle   : THandle;
  FindData : TWin32FindData;
begin
  Handle   := FindFirstFile(pchar(FileName),FindData);
  Result   := (Handle <> INVALID_HANDLE_VALUE);

  if(Result) then FindClose(Handle);
end;

function CheckFilter(const Path, Filter: string): boolean;
var
  p      : pchar;
begin
  // Standardergebnis
  Result := false;
  if(Path = '') or (Filter = '') then exit;

  // #0#0 an den Filter anhängen, damit später das Ende
  // korrekt erkannt wird
  p      := pchar(Filter + #0#0);
  while(p[0] <> #0) do
  begin
    // Datei mit entsprechendem Filter wurde gefunden, ...
    if(fileexists(Path + '\' + p)) then
    begin
    // ... Ergebnis auf TRUE setzen, und Schleife abbrechen
      Result := true;
      break;
    end;

    // ansonsten zum nächsten Filter
    inc(p,lstrlen(p) + 1);
  end;
end;

function SHGetIDListFromPath(const Path: string; out pidl: PItemIDList):
  boolean;
var
  ppshf        : IShellFolder;
  wpath        : array[0..MAX_PATH]of widechar;
  pchEaten,
  dwAttributes : Cardinal;
begin
  // Standardergebnis
  Result       := false;

  // IShellFolder-Handle holen
  if(SHGetDesktopFolder(ppshf) = S_OK) then
  try
    if(StringToWideChar(Path,wpath,sizeof(wpath)) <> nil) then
    begin
      // Pfadname in "PItemIdList" umwandeln
      ppshf.ParseDisplayName(0,nil,wpath,pchEaten,pidl,dwAttributes);
      Result   := pidl <> nil;
    end;
  finally
    ppshf      := nil;
  end;
end;

//
// "CreateComObject" (modifizierte Version; Mathias)
//
function CreateComObject(const ClassID: TGUID;
  out OleResult : HRESULT): IUnknown;
begin
  OleResult := CoCreateInstance(ClassID,nil,CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER,IUnknown,Result);
end;

//
// "ExpandEnvStr"
//
function ExpandEnvStr(const szInput: string): string;
const
  MAXSIZE = 32768;
begin
  SetLength(Result,MAXSIZE);
  SetLength(Result,ExpandEnvironmentStrings(pchar(szInput),
    @Result[1],length(Result)));
end;



// -----------------------------------------------------------------------------
//
// TFolderBrowser-Klasse
//
// -----------------------------------------------------------------------------

function FolderCallback(wnd: HWND; uMsg: UINT; lp, lpData: LPARAM): LRESULT;
  stdcall;
var
  path : array[0..MAX_PATH + 1]of char;
  fb   : TFolderBrowser;
begin
  fb   := TFolderBrowser(lpData);

  case uMsg of
    // Dialog wurde initialisiert
    BFFM_INITIALIZED:
      begin
        // Ordner auswählen, ...
        if(fb.FInitFolder <> '') then
          SendMessage(wnd,BFFM_SETSELECTION,WPARAM(true),
          LPARAM(pchar(fb.FInitFolder)));

        // ... & OK-Button deaktivieren, wenn Filter benutzt werden
        SendMessage(wnd,BFFM_ENABLEOK,0,LPARAM(fb.FFilter = ''));
        // oder anders gesagt: OK-Button aktivieren, wenn keine
        // Filter benutzt werden. ;o)
        // (Mathias)

        // Dialog neu positionieren
        if(fb.FPosChanged) then
          SetWindowPos(wnd,0,fb.Left,fb.Top,0,0,SWP_NOSIZE or SWP_NOZORDER);
      end;
    BFFM_SELCHANGED:
      if(PItemIdList(lp) <> nil) and (fb.FFilter <> '') then
      begin
        // den aktuellen Pfadnamen holen, ...
        ZeroMemory(@path,sizeof(path));
        if(SHGetPathFromIdList(PItemIdList(lp),path)) then
        begin
        // ... & anzeigen
          SendMessage(wnd,BFFM_SETSTATUSTEXT,0,LPARAM(@path));

        // gibt´s Dateien mit dem Filter?
        // nur dann wird der OK-Button des Dialogs aktiviert
          SendMessage(wnd,BFFM_ENABLEOK,0,LPARAM(CheckFilter(path,fb.FFilter)));
        end;
      end;
  end;

  Result := 0; // von Luckie hinzugefügt, hatte ich vergessen (oops)
end;


constructor TFolderBrowser.Create(Handle: THandle; const Caption: string;
  const PreSelectedFolder: string = ''; ShowFiles: Boolean = False;
  NewFolder: Boolean = False);
begin
  FHandle     := Handle;
  FCaption    := Caption;
  FInitFolder := PreSelectedFolder;
  FShowFiles  := ShowFiles;
  FNewFolder  := NewFolder;
  FStatusText := true;
  FNoTT       := true;
  FFilter     := '';
  FRoot       := nil;
  FTop        := 0;
  FLeft       := 0;
  FPosChanged := false;
end;

destructor TFolderBrowser.Destroy;
begin
  // ggf. belegte "PItemIdList" freigeben
  if(FRoot <> nil) then
    self.FreeItemIdList(FRoot);

  inherited Destroy;
end;

procedure TFolderBrowser.SetTopPosition(const Value: integer);
begin
  FPosChanged := true;
  FTop        := Value;
end;

procedure TFolderBrowser.SetLeftPosition(const Value: integer);
begin
  FPosChanged := true;
  FLeft       := Value;
end;

function TFolderBrowser.SetDefaultRoot: boolean;
begin
  // altes Objekt freigeben
  if(FRoot <> nil) then
    self.FreeItemIDList(FRoot);

  // und alles zurücksetzen
  FRoot  := nil;
  Result := true;
end;

function TFolderBrowser.SetRoot(const SpecialFolderId: integer): boolean;
begin
  // altes Objekt freigeben
  if(FRoot <> nil) then
    self.FreeItemIDList(FRoot);

  // SpecialFolderId kann eine der CSIDL_*-Konstanten sein,
  //   CSIDL_DESKTOP
  //   CSIDL_STARTMENU
  //   CSIDL_PERSONAL
  //   ...
  // s. PSDK

  // neuen Root setzen
  Result := SHGetSpecialFolderLocation(FHandle,SpecialFolderId,FRoot) = S_OK;
end;

function TFolderBrowser.SetRoot(const Path: string): boolean;
begin
  // altes Objekt freigeben
  if(FRoot <> nil) then
    self.FreeItemIDList(FRoot);

  // neuen Root setzen
  Result := SHGetIDListFromPath(Path,FRoot);
end;

function TFolderBrowser.Execute: Boolean;
var
  hr           : HRESULT;
  BrowseInfo   : TBrowseInfo;
  pidlResult   : PItemIDList;
  DisplayName,
  Path         : array[0..MAX_PATH + 1]of char;
begin
  Result       := false;

  hr           := CoInitializeEx(nil,COINIT_APARTMENTTHREADED);
  // Wenn die COM-Bibliothek noch nicht initialisiert ist,
  // dann ist das Ergebnis S_OK; ist sie bereits initialisiert
  // ist sie S_FALSE
  if(hr = S_OK) or (hr = S_FALSE) then
  try
    // "BrowseInfo" mit Werten füllen
    ZeroMemory(@BrowseInfo,sizeof(BrowseInfo));
    BrowseInfo.hwndOwner      := FHandle;
    BrowseInfo.pidlRoot       := FRoot;
    BrowseInfo.pszDisplayName := @Displayname;
    BrowseInfo.lpszTitle      := pchar(FCaption);
    BrowseInfo.lpfn           := @FolderCallBack;

    // TFolderBrowser-Klasse als Referenz für Callback-Funktion
    // übergeben (PL)
    BrowseInfo.lParam         := LPARAM(self);

    // Flags

    BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_USENEWUI;

    if(FStatusText) then
      BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_STATUSTEXT;


    // BIF_USENEWUI sorgt dafür dass besagter Button immer angezeigt wird,
    // egal, ob BIF_BROWSEINCLUDEFILES gesetzt wird oder nicht, daher
    // rausgenommen (Luckie)
    if(FShowFiles) then
      BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_BROWSEINCLUDEFILES;

    // Button zum Erstellen neuer Ordner anzeigen? (Luckie, PL)
    if(FNewFolder) then
      BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_NEWDIALOGSTYLE
    else
      BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_NONEWFOLDERBUTTON;

    // Windows XP sucht automatisch die Verknüpfungsziele von
    // Shortcuts heraus; soll stattdessen aber der Name der
    // Verknüpfung angezeigt werden, ist das Flag BIF_NOTRANSLATETARGETS
    // erforderlich; Sinn macht es nur unter Windows XP
    if(FNoTT) then
      BrowseInfo.ulFlags      := BrowseInfo.ulFlags or BIF_NOTRANSLATETARGETS;
    // für die älteren Windows-Versionen gibt es mit der Funktion
    // "TranslateLink" (s. weiter unten) eine Entsprechung, um die
    // Ziele von Shortcuts zu ermitteln (Mathias)


    // Dialog aufrufen
    pidlResult := SHBrowseForFolder(BrowseInfo);
    if(pidlResult <> nil) then
    begin
      if(FSelected = '') then
        if(SHGetPathFromIdList(pidlResult,Path)) and
          (Path[0] <> #0) then
        begin
          FSelected := Path;
          Result    := true;
        end;

      self.FreeItemIdList(pidlResult);
    end;
  finally
    CoUninitialize;
  end;
end;

function TFolderBrowser.TranslateLink(const LnkFile: string): string;
var
  link       : IShellLink;
  hr         : HRESULT;
  afile      : IPersistFile;
  pwcLnkFile : array[0..MAX_PATH]of widechar;
  szData     : array[0..MAX_PATH]of char;
  FindData   : TWin32FindData;
begin
  // Standardergebnis
  Result     := '';
  link       := nil;
  afile      := nil;

  hr         := CoInitializeEx(nil,COINIT_APARTMENTTHREADED);
  if(hr = S_OK) or (hr = S_FALSE) then
  try
    // IShellLink-Interface erzeugen, ...
    link   := CreateComObject(CLSID_ShellLink,hr) as IShellLink;
    if(hr = S_OK) and (link <> nil) then
    begin
    // ... & Verknüpfung laden
      StringToWideChar(LnkFile,pwcLnkFile,sizeof(pwcLnkFile));
      afile := link as IPersistFile;

      if(afile <> nil) and
        (afile.Load(pwcLnkFile,STGM_READ) = S_OK) then
      begin
        ZeroMemory(@szData,sizeof(szData));

    // Pfad + Dateiname ermitteln, ...
        if(link.GetPath(szData,sizeof(szData),FindData,
          SLGP_RAWPATH) = S_OK) then
        begin
          SetString(Result,szData,lstrlen(szData));
    // ... & evtl. Umgebungsvariablen filtern
          Result := ExpandEnvStr(Result);
        end;
      end;
    end;
  finally
    if(afile <> nil) then afile := nil;
    if(link <> nil) then link := nil;

    CoUninitialize;
  end;
end;

procedure TFolderBrowser.FreeItemIDList(var pidl: pItemIDList);
var
  ppMalloc : iMalloc;
begin
  if(SHGetMalloc(ppMalloc) = S_OK) then
  try
    ppMalloc.Free(pidl);
    pidl     := nil;
  finally
    ppMalloc := nil;
  end;
end;


const
  MsiDllName                = 'msi.dll';

  INSTALLSTATE_ABSENT       =  2;    // uninstalled
  INSTALLSTATE_LOCAL        =  3;    // installed on local drive
  INSTALLSTATE_SOURCE       =  4;    // run from source, CD or net
  INSTALLSTATE_SOURCEABSENT = -4;    // run from source, source is unavailable
  INSTALLSTATE_NOTUSED      = -7;    // component disabled
  INSTALLSTATE_INVALIDARG   = -2;    // invalid function argument
  INSTALLSTATE_UNKNOWN      = -1;    // unrecognized product or feature

type
  INSTALLSTATE              = LongInt;

  {$ifdef UNICODE}
  TMsiGetShortcutTarget     = function(szShortcutTarget, szProductCode,
    szFeatureId, szComponentCode: PChar): uint; stdcall;
  TMsiGetComponentPath      = function(szProduct, szComponent: PChar;
    lpPathBuf: PChar; pcchBuf: pdword): INSTALLSTATE; stdcall;
  {$else}
  TMsiGetShortcutTarget     = function(szShortcutTarget, szProductCode,
    szFeatureId, szComponentCode: PAnsiChar): uint; stdcall;
  TMsiGetComponentPath      = function(szProduct, szComponent: PAnsiChar;
    lpPathBuf: PAnsiChar; pcchBuf: pdword): INSTALLSTATE; stdcall;
  {$endif}
var
  MsiGetShortcutTarget      : TMsiGetShortcutTarget = nil;
  MsiGetComponentPath       : TMsiGetComponentPath  = nil;
  MsiDll                    : dword = 0;

function TFolderBrowser.TranslateMsiLink(const LnkFile: string): string;
var
  ProductCode,
  FeatureId,
  ComponentCode : array[0..MAX_PATH]of char;
  Path          : array[0..MAX_PATH]of char;
  PathLen       : dword;
begin
  Result := '';
  if(@MsiGetShortcutTarget = nil) or (@MsiGetComponentPath = nil) then exit;

  ZeroMemory(@ProductCode, sizeof(ProductCode));
  ZeroMemory(@FeatureId, sizeof(FeatureId));
  ZeroMemory(@ComponentCode, sizeof(ComponentCode));

  {$ifdef UNICODE}
  if(MsiGetShortcutTarget(PChar(LnkFile), ProductCode, FeatureId,
    ComponentCode) = ERROR_SUCCESS) then
  {$else}
  if(MsiGetShortcutTarget(PAnsiChar(LnkFile), ProductCode, FeatureId,
    ComponentCode) = ERROR_SUCCESS) then
  {$endif}
  begin
    ZeroMemory(@Path, sizeof(Path));
    PathLen := sizeof(Path);

    case MsiGetComponentPath(ProductCode, ComponentCode, Path, @PathLen) of
      INSTALLSTATE_LOCAL,
      INSTALLSTATE_SOURCE:
        SetString(Result, Path, lstrlen(Path));
    end;
  end;
end;


initialization
  MsiDll                     := GetModuleHandle(MsiDllName);
  if(MsiDll = 0) then MsiDll := LoadLibrary(MsiDllName);

  if(MsiDll <> 0) then
  begin
    {$ifdef UNICODE}
    MsiGetShortcutTarget     := GetProcAddress(MsiDll, 'MsiGetShortcutTargetW');
    MsiGetComponentPath      := GetProcAddress(MsiDll, 'MsiGetComponentPathW');
    {$else}
    MsiGetShortcutTarget     := GetProcAddress(MsiDll, 'MsiGetShortcutTargetA');
    MsiGetComponentPath      := GetProcAddress(MsiDll, 'MsiGetComponentPathA');
    {$endif}

    if(@MsiGetShortcutTarget = nil) or
      (@MsiGetComponentPath  = nil) then
    begin
      FreeLibrary(MsiDll);
      MsiDll := 0;
    end;
  end;
finalization
  if(MsiDll <> 0) then FreeLibrary(MsiDll);
end.
