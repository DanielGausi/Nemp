{
Diese Unit entspricht in weiten Teilen der Unit aus dem
Tutorial Deskbands mit Delphi,
http://info.borland.de/newsletter/nl05_6/Deskband/Deskband.htm
}

unit unitNempDeskBand;

interface

uses
  Windows, Messages, Classes, ActiveX, ComServ, ComObj, ShlObj, SHDocVw_TLB,
  Graphics,
  FormMainBand, TaskbarStuff;

const
  /// <summary>
  ///   Durch Microsoft definierte GUID zur Registrierung von Desk-Bändern
  /// </summary>
  REGKEY_DESK_BAND = '{00021492-0000-0000-C000-000000000046}';
  /// <summary>
  ///   GUID zur Identifizierung unseres Desk-Bandes. Jedes Desk-Band muss(!)
  ///   seine eigene GUID definieren
  /// </summary>
  {.$MESSAGE 'Ändern Sie diese GUID, damit das Deskband eindeutig bleibt. Drücken Sie hierfür STRG+SHIFT+G in ihrer Delphi IDE.'}

  CLSID_DEMO_DESK_BAND: TGUID = '{8C4CABF5-E8F3-43CB-BC94-E6A7DC512820}';
  /// <summary>
  ///   Der Titel unseres Desk-Bandes wie dieses im Kontextmenü "Symbolleisten"
  ///   angezeigt wird
  /// </summary>
  EXPLORER_MENU_CAPTION = 'Nemp - Noch ein Mp3-Player';
  /// <summary>
  ///   Der Titel des eingeblendeten Desk-Bandes
  /// </summary>
  BAND_TITLE = '';
  /// <summary>
  ///   Der Titel unseres Kontextmenüeintrages
  /// </summary>
  MENU_TITLE_ABOUT = 'über Nemp Deskband';

  DBIMF_TOPALIGN = $0400;

  NEMP_DESKBAND_ACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Activate'#0;
  NEMP_DESKBAND_DEACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Deactivate'#0;
  NEMP_DESKBAND_UPDATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Update'#0;


type
  /// <summary>
  ///   Klasse zur Registrierung unseres Desk-Bandes im Windows COM-SubSystem
  /// </summary>
  TDemoDeskBandFactory = class(TComObjectFactory)
  private
  protected
  public
    /// <summary>
    ///   Registriert bzw. entfernt unser Desk-Band in/aus dem Windows Explorer/
    ///   Internet Explorer
    /// </summary>
    procedure UpdateRegistry(Register: Boolean); override;
  end;

  /// <summary>
  ///   Das COM Objekt unseres Desk-Bandes. Dieses übernimmt alle Interaktionen
  ///   mit dem Windows/Internet Explorer
  /// </summary>
  TDemoDeskBand = class(TComObject, IDeskBand, IPersist, IPersistStream,
      IPersistStreamInit, IObjectWithSite, IContextMenu, IInputObject)
  private
    FHasFocus: Boolean;
    FBandID: DWORD;
    FParentWnd: HWND;
    FSite: IInputObjectSite;
    FMenuItemCount: Integer;
    FCommandTarget: IOleCommandTarget;
    FIE: IWebbrowser2;
    FBandForm: TNempDeskBand;
    FSavedWndProc: TWndMethod;
    FCloseDeskband: Boolean;
    /// <summary>
    ///   Blendet das DeskBand aus, sichert jedoch das Form-Objekt
    /// </summary>
    procedure HideBandForm;
  protected
    /// <summary>
    ///   Anzahl der eigenen Menü-Einträge im Kontextmenü des Desk-Bandes
    /// </summary>
    property MenuItemCount: Integer read FMenuItemCount;
    /// <summary>
    ///   Ist True, wenn des Desk-Band fokusiert ist, ansonsten False
    /// </summary>
    property HasFocus: Boolean read FHasFocus;
    /// <summary>
    ///   Speichert die ID des Bandes innerhalb des Host-Containers
    /// </summary>
    property BandID: DWORD read FBandID;
    /// <summary>
    ///   Pointer zur "WndProc" Methode des Delphi-Forms welches im DeskBand
    ///   dargestellt wird
    /// </summary>
    property SavedWndProc: TWndMethod read FSavedWndProc;
    /// <summary>
    ///   Windows-Handle des Host-Containers des Desk-Bandes
    /// </summary>
    property ParentWnd: HWND read FParentWnd;
    /// <summary>
    ///   Ermöglicht und des Host-Container zu informieren, wenn sie der Fokus
    ///   ändert
    /// </summary>
    property Site: IInputObjectSite read FSite;
    /// <summary>
    ///   Ermöglicht es dem Desk-Band Anweisungen zu erhalten bzw. zu geben
    /// </summary>
    property CommandTarget: IOleCommandTarget read FCommandTarget;
    /// <summary>
    ///   Unser Delphi-Form, welches im Desk-Band dargestellt wird
    /// </summary>
    property BandForm: TNempDeskBand read FBandForm;
    /// <summary>
    ///   Link zum Internet Explorer, wenn das Desk-Band im Internet Explorer
    ///   als Toolbar dargestellt wird.
    /// </summary>
    property IE: IWebbrowser2 read FIE;
  protected
    /// <summary>
    ///   Informiert den Host-Container, ob das Desk-Band den Fokus hat
    /// </summary>
    procedure FocusChange(bHasFocus: Boolean);
    /// <summary>
    ///   Informiert den Host-Container, dass sich die Einstellungen des
    ///   Desk-Bandes geändert haben und fordert diesen damit auf die Methode
    ///   GetBandInfo erneut aufzurufen
    /// </summary>
    procedure UpdateBandInfo;
    /// <summary>
    ///   Leitet Windows-Nachrichten an unser Delphi-Form weiter
    /// </summary>
    procedure BandWndProc(var Message: TMessage);
  public
    /// <summary>
    ///   Gibt alle Interface-Referenzen und Objekte frei. Intern wird jede
    ///   Freigabe von externen Interface-Referenzen durch einen seperaten
    ///   try...except-Block geschützt, da nicht alle Windows-Interfaces
    ///   Referenzzähler nutzen und diese somit evtl. bereits nicht mehr
    ///   existieren. Danke Bill :-/
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    ///   Hier treffen wir alle Initialisierungen für unser Desk-Band. Benutzen
    ///   sie niemals den constructor Create in extern erstellten COM-Objekten,
    ///   da sie nicht garantieren können, welche Variante zur Erstellung
    ///   genutzt wird
    /// </summary>
    procedure Initialize; override;

    // IDeskBand methods
    /// <summary>
    ///   Der Host-Container nutzt diese Methode zur Ermittlung der wichtigsten
    ///   Eigenschaften unseres Desk-Bandes
    /// </summary>
    function GetBandInfo(dwBandID, dwViewMode: DWORD; var pdbi: TDeskBandInfo): HResult; stdcall;
    /// <summary>
    ///   Der Host-Container ruft diese Methode auf, um den Deskband mitzuteilen,
    ///   ob es sich darstellen/verstecken soll. Soll es sich darstellen, so
    ///   holen wir uns ganz frech auch gleich mal den Fokus ;-)
    /// </summary>
    function ShowDW(fShow: BOOL): HResult; stdcall;
    /// <summary>
    ///   Der Host-Container ruft diese Methode auf, um uns mitzuteilen, dass
    ///   das Desk-Band geschlossen wird. Da Windows die COM-DLL nicht freigibt
    ///   bis der Explorer beendet wird (Abmeldung vom System), behalten wir
    ///   das Form auch im Speicher und setzen Visible lediglich auf False
    /// </summary>
    function CloseDW(dwReserved: DWORD): HResult; stdcall;
    /// <summary>
    ///   Wir ignorieren diese Anforderung einfach
    /// </summary>
    function ResizeBorderDW(var prcBorder: TRect; punkToolbarSite: IUnknown; fReserved: BOOL): HResult; stdcall;
    /// <summary>
    ///   Der Explorer möchte das Handle des darzustellenden Fensters haben.
    /// </summary>
    function GetWindow(out wnd: HWnd): HResult; stdcall;
    /// <summary>
    ///   Wir ignorieren auch diese Anforderung
    /// </summary>
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;

    // IPersistStream methods
    /// <summary>
    ///   Liefert die eineindeutige GUID unseres Desk-Bandes zurück.
    /// </summary>
    function GetClassID(out classID: TCLSID): HResult; stdcall;
    /// <summary>
    ///   Na klar sind wir schmutzig ;-) IsDirty wird aufgerufen, um
    ///   herauszufinden, ob es seit der letzten Speicherung Änderungen am
    ///   Objekt gab. Auch wenn wir keine Informationen speichern wollen, so
    ///   ist die Rückgabe von S_OK Voraussetzung dafür, dass der Explorer die
    ///   Nutzereinstellungen (Position, Größe, etc.) des Desk-Bandes speichert.
    ///   Manchmal sind die Microsofties schon komisch, oder ;-)
    /// </summary>
    function IsDirty: HResult; stdcall;
    /// <summary>
    ///   Ermöglicht es uns Daten aus dem Desk-Band Stream zu laden
    /// </summary>
    function Load(const stm: IStream): HResult; stdcall;
    /// <summary>
    ///   Ermöglicht es uns Daten in den Desk-Band Stream zu sichern
    /// </summary>
    function Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
    /// <summary>
    ///   Liefert die maximale Anzahl an Bytes zurück, welche unser Desk-Band
    ///   benötigt, um seine Informationen zu sichern
    /// </summary>
    function GetSizeMax(out cbSize: Largeint): HResult; stdcall;

    // IPersistStreamInit methods
    /// <summary>
    ///   Wird aufgerufen, um das Desk-Band aufzufordern alle
    ///   Standardeinstellungen zu laden 
    /// </summary>
    function InitNew: HResult; stdcall;

    // IObjectWithSite methods
    /// <summary>
    ///   Gibt uns eine Referenz auf den Host-Container
    /// </summary>
    function SetSite(const pUnkSite: IUnknown): HResult; stdcall;
    /// <summary>
    ///   Liefert die Referenz auf den uns letzten bekannten Host-Container
    ///   zurück
    /// </summary>
    function GetSite(const riid: TIID; out site: IUnknown): HResult; stdcall;

    // IContextMenu methods
    /// <summary>
    ///   Wir werden gebeten dem Host mitzuteilen welche Menüpunkte benötigt
    ///   sind
    /// </summary>
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    /// <summary>
    ///   Der Benutzer hat einen UNSERER Menüpunkte angeklickt. Wir werden jetzt
    ///   informiert was der Benutzer sehen will
    /// </summary>
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    /// <summary>
    ///   Liefert weitergehende Informationen (z.B. Hint) zu unseren Menüpunkten
    ///   zurück. Okay tut es nicht, aber nur weil ich es ignoriere ;-)
    /// </summary>
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult; stdcall;

    // IInputObject methods
    /// <summary>
    ///   Aktiviert/Deaktiviert das User Interface - also unser Delphi-Form
    /// </summary>
    function UIActivateIO(fActivate: BOOL; var lpMsg: TMsg): HResult; stdcall;
    /// <summary>
    ///   Gibt zurück ob wir glauben derzeit den Fokus zu haben
    /// </summary>
    function HasFocusIO: HResult; stdcall;
    /// <summary>
    ///   Übersetzt Kommando-Shortcuts für unser Desk-Band
    /// </summary>
    function TranslateAcceleratorIO(var lpMsg: TMsg): HResult; stdcall;
  end;

  var NempDeskbandActivateMessage: UINT = 0;
      NempDeskbandDeactivateMessage: UINT = 0;
      NempDeskbandUpdateMessage: UInt = 0;

implementation

uses
  Registry;

{ TDemoDeskBandFactory }

procedure TDemoDeskBandFactory.UpdateRegistry(Register: Boolean);
var
  GUID: string;
begin
  inherited UpdateRegistry(Register);
  GUID := GUIDToString(CLSID_DEMO_DESK_BAND);
  with TRegistry.Create do
  try
    if Register then
    begin
      // das Desk-Band wird installiert

      // Registrierung der COM Komponente
      RootKey := HKEY_CLASSES_ROOT;
      if OpenKey('CLSID\' + GUID, True) then
      try
        WriteString('', EXPLORER_MENU_CAPTION);
      finally
        CloseKey;
      end;
      if OpenKey('CLSID\' + GUID + '\InProcServer32', True) then
      try
        WriteString('ThreadingModel', 'Apartment');
      finally
        CloseKey;
      end;
      if OpenKey('CLSID\' + GUID + '\Implemented Categories\' + REGKEY_DESK_BAND, True) then
        CloseKey;

      {// Registrierung der COM Komponente im Internet Explorer
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\Microsoft\Internet Explorer\Toolbar', True) then
      try
        WriteString(GUID, '');
      finally
        CloseKey;
      end;}
    end
    else
    begin
      // das Desk-Band wird deinstalliert
      RootKey := HKEY_CLASSES_ROOT;
      DeleteKey('Component Categories\' + REGKEY_DESK_BAND + '\Enum');
      DeleteKey('CLSID\' + GUID + '\Implemented Categories\' + REGKEY_DESK_BAND);
      DeleteKey('CLSID\' + GUID + '\InProcServer32');
      DeleteKey('CLSID\' + GUID);
      CloseKey;

      {RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('Software\Microsoft\Internet Explorer\Toolbar', False) then
      try
        DeleteValue(GUID);
      finally
        CloseKey;
      end;   }
    end;
  finally
    Free;
  end;
end;

{ TDemoDeskBand }

procedure TDemoDeskBand.BandWndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_PARENTNOTIFY)  then
  begin
    FHasFocus := True;
    FocusChange(HasFocus);
  end;
  if (Message.Msg = NempDeskbandActivateMessage) then
  begin
    FCloseDeskband := False;
    UpdateBandInfo;
    ShowDW(True);
  end;
  if (Message.Msg = NempDeskbandDeActivateMessage) then
  begin
    FCloseDeskband := True;
    ShowDW(False);
    UpdateBandInfo;
  end;
  if (Message.Msg = NempDeskbandUpdateMessage) then
  begin
    BandForm.UpdateForm(Message.WParam, Message.LParam);
  end;

  SavedWndProc(Message);
end;

function TDemoDeskBand.CloseDW(dwReserved: DWORD): HResult;
begin
  HideBandForm;
  Result := S_OK;
end;

function TDemoDeskBand.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

destructor TDemoDeskBand.Destroy;
begin
  try
    FIE := nil;
  except
  end;
  if BandForm <> nil then
  try
    FBandForm.Free;
    FBandForm := nil;
  except
  end;
  try
    FSite := nil;
  except
  end;
  try
    FCommandTarget := nil;
  except
  end;
  inherited Destroy;
end;

procedure TDemoDeskBand.FocusChange(bHasFocus: Boolean);
begin
  if Site <> nil then
    Site.OnFocusChangeIS(Self, bHasFocus);
end;

procedure TDemoDeskBand.HideBandForm;
begin
  BandForm.Hide;
end;

function TDemoDeskBand.GetBandInfo(dwBandID, dwViewMode: DWORD; var pdbi: TDeskBandInfo): HResult;
var hwndNemp: THandle;
begin

  hwndNemp:= FindWindow('TNemp_MainForm.UnicodeClass',nil);

  if (hwndNemp <> 0) then        //???
    FBandForm.ReOrderControls;

  FBandId := dwBandID;

  if pdbi.dwMask or DBIM_MINSIZE <> 0 then
  begin
        pdbi.ptMinSize.x := 180;
        pdbi.ptMinSize.y := 22;
  end;


  if pdbi.dwMask or DBIM_MAXSIZE <> 0 then
  begin
        pdbi.ptMaxSize.x := 180;
        pdbi.ptMaxSize.y := 22;
  end;

  if pdbi.dwMask or DBIM_INTEGRAL <> 0 then
  begin
      pdbi.ptIntegral.x := 25; //25
      pdbi.ptIntegral.y := 22; //22
  end;

  if pdbi.dwMask or DBIM_ACTUAL <> 0 then
  begin
        pdbi.ptActual.x := 180;
        pdbi.ptActual.y := 22;
  end;

  if (hwndNemp = 0) OR (FCloseDeskband) then
  begin
    pdbi.ptMinSize.x := 0;
    pdbi.ptMinSize.y := 0;
    pdbi.ptMaxSize.x := 0;
    pdbi.ptMaxSize.y := 0;
    pdbi.ptActual.x := 0;
    pdbi.ptActual.y := 0;
  end;


  if pdbi.dwMask or DBIM_MODEFLAGS <> 0 then
  begin
    pdbi.dwModeFlags := DBIMF_NORMAL or DBIMF_VARIABLEHEIGHT;//  or DBIMF_TOPALIGN;
  end;

  if pdbi.dwMask or DBIM_BKCOLOR <> 0 then
  begin
    pdbi.crBkgnd := clGreen;
  end;

  if Pdbi.dwMask and DBIM_TITLE <> 0 then
  begin
    if BAND_TITLE <> '' then
    begin
      FillChar(pdbi.wszTitle, Length(pdbi.wszTitle) * SizeOf(pdbi.wszTitle[0]), #0);
      FillChar(pdbi.wszTitle, SizeOf(BAND_TITLE) + 1, ' ');
      StringToWideChar(BAND_TITLE, @pdbi.wszTitle, Length(BAND_TITLE) + 1);
    end else
    begin
      FillChar(pdbi.wszTitle, Length(pdbi.wszTitle) * SizeOf(pdbi.wszTitle[0]), #0);
    end;
  end;

  Result := NOERROR;
end;

function TDemoDeskBand.GetClassID(out classID: TCLSID): HResult;
begin
  classID := CLSID_DEMO_DESK_BAND;
  Result := S_OK;
end;

function TDemoDeskBand.GetCommandString(idCmd, uType: UINT; pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult;
begin
  Result := NOERROR;
end;

function TDemoDeskBand.GetSite(const riid: TIID; out site: IInterface): HResult;
begin
  if Site <> nil then
    Result := Site.QueryInterface(riid, site)
  else
    Result := E_FAIL;
end;

function TDemoDeskBand.GetSizeMax(out cbSize: Largeint): HResult;
begin
  cbSize := 256;
  Result := S_OK;
end;

function TDemoDeskBand.GetWindow(out wnd: HWnd): HResult;
begin
  if BandForm = nil then
  begin
    FBandForm := TNempDeskBand.CreateParented(ParentWnd);
  end;
  Wnd := BandForm.Handle;
  FSavedWndProc := BandForm.WindowProc;
  BandForm.WindowProc := BandWndProc;
  Result := S_OK;
end;

function TDemoDeskBand.HasFocusIO: HResult;
begin
  Result := Integer(not HasFocus);
end;

procedure TDemoDeskBand.Initialize;
begin
  inherited Initialize;
end;

function TDemoDeskBand.InitNew: HResult;
begin
  Result := S_OK;
end;

function TDemoDeskBand.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
begin
  if (HiWord(Integer(lpici.lpVerb)) <> 0) or (LoWord(lpici.lpVerb) > Pred(MenuItemCount)) then
  begin
    Result := E_FAIL;
    Exit;
  end;
  case LoWord(lpici.lpVerb) of
    0: MessageBox(ParentWnd,   'Nemp Deskband' + #13#10
                             + 'Programmiert von Daniel ''Gausi'' Gaußmann' + #13#10
                             + '(c) Februar 2009, www.gausi.de'
    , 'Über Nemp Deskband', 0);
  end;
  Result := NO_ERROR;
end;

function TDemoDeskBand.IsDirty: HResult;
begin
  Result := S_OK;
end;

function TDemoDeskBand.Load(const stm: IStream): HResult;
begin
  Result := S_OK;
end;

function TDemoDeskBand.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult;
begin
  FMenuItemCount := 1;
  AppendMenu(Menu, MF_STRING, idCmdFirst + 0, PChar(MENU_TITLE_ABOUT));
  Result := MenuItemCount;
end;

function TDemoDeskBand.ResizeBorderDW(var prcBorder: TRect; punkToolbarSite: IInterface; fReserved: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDemoDeskBand.Save(const stm: IStream; fClearDirty: BOOL): HResult;
begin
  Result := S_OK;
end;

function TDemoDeskBand.SetSite(const pUnkSite: IInterface): HResult;
begin
  if pUnkSite <> nil then
  begin
    FSite := pUnkSite as IInputObjectSite;
    (pUnkSite as IOleWindow).GetWindow(FParentWnd);
    FCommandTarget := pUnkSite as IOleCommandTarget;
    (CommandTarget as IServiceProvider).QueryService(IWebbrowserApp, IWebbrowser2, FIE);
  end;
  Result := S_OK;
end;

function TDemoDeskBand.ShowDW(fShow: BOOL): HResult;
var hwndNemp : THandle;
begin

  hwndNemp:= FindWindow('TNemp_MainForm.UnicodeClass',nil);

  if BandForm <> nil then
  begin
    if (fShow) AND (hwndNemp <> 0) then
      ShowWindow(BandForm.Handle, SW_SHOW)
    else
      //hide our window
      ShowWindow(BandForm.Handle, SW_HIDE);
  end;
  Result := S_OK;
end;

function TDemoDeskBand.TranslateAcceleratorIO(var lpMsg: TMsg): HResult;
begin
  if lpMsg.WParam <> VK_TAB then
  begin
    TranslateMessage(lpMSg);
    DispatchMessage(lpMsg);
    Result := S_OK;
  end
  else
  begin
    Result := S_FALSE;
  end;
end;

function TDemoDeskBand.UIActivateIO(fActivate: BOOL;
  var lpMsg: TMsg): HResult;
begin
  FHasFocus := fActivate;
  FocusChange(HasFocus);
  if HasFocus then
    if BandForm <> nil then
      BandForm.SetFocus;
  Result := S_OK;
end;

procedure TDemoDeskBand.UpdateBandInfo;
var
  vain, vaOut: OleVariant;
  PtrGuid: PGUID;
begin
  vaIn := Variant(BandID);
  New(PtrGUID);
  PtrGUID^ := IDESKBAND;
  CommandTarget.Exec(PtrGUID, DBID_BANDINFOCHANGED, OLECMDEXECOPT_DODEFAULT, vaIn, vaOut);
  Dispose(PtrGUID);
end;

initialization
  TDemoDeskBandFactory.Create(ComServer, TDemoDeskBand, CLSID_DEMO_DESK_BAND, '', BAND_TITLE, ciMultiInstance);
  NempDeskbandActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_ACTIVATE);
  NempDeskbandDeActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_DEACTIVATE);
  NempDeskbandUpdateMessage := RegisterWindowMessage(NEMP_DESKBAND_UPDATE);


end.
