// -----------------------------------------------------------------------------
//
// TFileTypeRegistration-Klasse
// Copyright (c) 2004 Mathias Simmack
//
// -----------------------------------------------------------------------------

// -- Revision history ---------------------------------------------------------
//
//   * erste Version
//   * "FInternalName" in "GetInternalKey" zur�ckgesetzt (damit wird
//     u.U. ein Fehler vermieden, wenn der gesuchte Schl�ssel nicht
//     existiert, "FInternalName" aber noch von einer fr�heren Aktion
//     einen Wert enthielt)
//   * Explorer-Integration (Rechtsklick -> Neu -> ...) durch die zwei
//     Funktion "AddNewFileSupport" und "RemoveNewFileSupport" m�glich
//
// -----------------------------------------------------------------------------
//   Modified by Daniel Gau�mann
//   September 2006
//
//   Statt HKEY_ClassesRoot nur in HKEY_CurrentUser\software\classes
//   in NT Systemen. Bei 9x: wie gehabt
//
//   Auch sonst einige �nderungen vorgenommen, z.B. die "InternalName" Geschichte
//   rausgenommen, weil die meinem Zweck entgegensteht:
//   Ich m�chte ja gerade meine Dateitypen (mp3, etc) immer als Nemp.AudioFile
//   registrieren, egal was vorher da war!
//
// -----------------------------------------------------------------------------
unit filetypes;

interface

uses
  Windows, SysUtils, Registry, ShlObj, dialogs;

type
  TFileTypeRegistration = class
    FRegConnector : TRegistry;
    FExtension,
    FInternalName : string;
    FVerb         : string;
    fKey    : string; // = '' oder Softwareclasses...
    fWindowsNT: Boolean;
    function GetInternalValue(const KeyName, ValueName: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function RegisterType(const Extension, InternalName: string;
      Description: string = ''; IconFile: string = '';
      IconIndex: integer = -1): boolean;
    function UnregisterExtension(const Extension: string): boolean;
    function UnregisterType(const Extension: string): boolean;
    procedure UpdateShell;
    function AddHandler(const HandlerVerb, CommandLine: string;
      HandlerDescription: string = ''): boolean; overload;

    function AddDirectoryHandler(const HandlerVerb, CommandLine: string;
      HandlerDescription: string = ''): boolean; overload;

    function DeleteHandler(const HandlerVerb: string): boolean;
    function DeleteDirectoryHandler(const HandlerVerb: string): boolean;

    function DeleteUserChoice(const Extension: String): Boolean;
    function DeleteSpecialSetting(const Extension: string): Boolean;

    function ExtensionOpensWithApplication(const Extension, InternalName, AppName: string): boolean;


    function SetITouchMediaPlayer(CommandLine: string): boolean;


    function SetDefaultHandler: boolean; overload;
    function SetDefaultHandler(const HandlerVerb: string): boolean; overload;
    function GetInternalKey(const Extension: string): string;

    property Extension: string read FExtension;
    property InternalName: string read FInternalName;
    property CurrentVerb: string read FVerb;
    property key: string read fKey;
  end;


implementation

(* *****************************************************************************

  Beispiel #1: Einen neuen Dateityp registrieren
  ----------------------------------------------

  ftr := TFileTypeRegistration.Create;
  if(ftr <> nil) then
  try
    // die Dateiendung ".foo" registrieren, der interne Schl�ssel
    // lautet "FooFile", eine Beschreibung und eine Symboldatei
    // sind ebenfalls angegeben
    if(ftr.RegisterType('.foo','FooFile','FOO Description',
      'c:\folder\icon.ico')) then
    begin
      // f�gt den Handler "open" hinzu und verkn�pft ihn mit dem
      // Programm "foo.exe"
      ftr.AddHandler('open','"c:\folder\foo.exe" "%1"');

      // setzt den zuletzt benutzten Handler ("open" in dem Fall)
      // als Standard
      ftr.SetDefaultHandler;
    end;

    if(ftr.RegisterType('.foo','ThisIsNotTheFOOKey')) then
    // Das ist kein Fehler! Obwohl hier der interne Name
    // "ThisIsNotTheFOOKey" verwendet wird, benutzt die Funktion
    // intern den bereits vorhandenen Schl�ssel "FooFile" (s. oben).
    begin
      // zwei neue Handler werden registriert, ...
      ftr.AddHandler('print','"c:\folder\foo.exe" /p "%1"');
      ftr.AddHandler('edit','notepad.exe "%1"');

      // ... & dank der �berladenen Funktion "SetDefaultHandler"
      // kann diesmal auch "print" als Standardhandler gesetzt
      // werden
      ftr.SetDefaultHandler('print');
    end;
  finally
    ftr.Free;
  end;


  Beispiel #2: Einen neuen Typ mit einem vorhandenen Schl�ssel
  verkn�pfen
  ------------------------------------------------------------

  Das Beispiel registriert die Endung ".foo" auf die gleiche
  Weise wie Textdateien (.txt). Es wird einfach der interne
  Schl�sselname ermittelt und f�r die Endung ".foo" gesetzt

  ftr := TFileTypeRegistration.Create;
  if(ftr <> nil) then
  try
    strInternalTextFileKey := ftr.GetInternalKey('.txt');
    if(strInternalTextFileKey <> '') then
      ftr.RegisterType('.foo',strInternalTextFileKey);
  finally
    ftr.Free;
  end;


  Beispiel #3: Einen Handler entfernen
  ------------------------------------

  ftr := TFileTypeRegistration.Create;
  if(ftr <> nil) then
  try
    // den internen Schl�sselnamen des Typs ".foo" ermitteln, ...
    if(ftr.GetInternalKey('.foo') <> '') then
    // ... wobei das Ergebnis in dem Fall unwichtig ist, weil
    // intern auch die Eigenschaft "FInternalName" gesetzt
    // wird
    begin
      // den "print"-Handler entfernen, ...
      ftr.DeleteHandler('print');

      // ... & den Standardhandler aktualisieren
      ftr.SetDefaultHandler('open');
    end;
  finally
    ftr.Free;
  end;


  Beispiel #4: Nur eine Dateiendung entfernen
  -------------------------------------------

  In diesem Fall wird lediglich die Endung ".foo" entfernt. Der
  evtl. vorhandene interne Schl�ssel bleibt bestehen. Das ist
  f�r das Beispiel #2 n�tzlich, wenn die Endung ".foo" entfernt
  werden soll, intern aber mit den Textdateien verlinkt ist, die
  ja im Normalfall nicht entfernt werden d�rfen/sollten.

    ftr.UnregisterExtension('.foo');


  Beispiel #5: Den kompletten Dateityp entfernen
  ----------------------------------------------

  Dieses Beispiel entfernt dagegen den kompletten Dateityp,
  inkl. des evtl. vorhandenen internen Schl�ssels (vgl. mit
  Beispiel #4).

    ftr.UnregisterType('.foo');

  Bezogen auf Beispiel #2 w�re das die fatale L�sung, weil dadurch
  zwar die Endung ".foo" deregistriert wird, gleichzeitig wird
  aber auch der intern verwendete Schl�ssel der Textdateien
  gel�scht.

  ALSO, VORSICHT!!!

***************************************************************************** *)


const
  ShellKey = '%s\shell\%s';

// -----------------------------------------------------------------------------
//
// TFileTypeRegistration-Klasse
//
// -----------------------------------------------------------------------------

constructor TFileTypeRegistration.Create;
var wv : TOSVersionInfo;
begin
  FExtension    := '';
  FInternalName := '';
  FVerb         := '';

  wv.dwOSVersionInfoSize := sizeof(TOSversionInfo);
  GetVersionEx(wv);

  if (wv.dwPlatformId = VER_PLATFORM_WIN32s) then
    FRegConnector := nil
  else
  begin
    if (wv.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS) then
    begin
      // Windows 9x
      FRegConnector := TRegistry.Create;
      FRegConnector.RootKey := HKEY_CLASSES_ROOT;
      fKey := '';
      fWindowsNT := False;
    end;
    if (wv.dwPlatformId = VER_PLATFORM_WIN32_NT) then
    begin
      // Windows NT. Ich setze immer nur den lokalen User
      FRegConnector := TRegistry.Create;
      FRegConnector.RootKey := HKEY_CURRENT_USER;
      fKey := '\Software\Classes\';
      fWindowsNT := True;
    end;
  end;
end;

destructor TFileTypeRegistration.Destroy;
begin
  if(FRegConnector <> nil) then
    FreeAndNil(FRegConnector);
end;

function TFileTypeRegistration.ExtensionOpensWithApplication(const Extension, InternalName, AppName: string): boolean;
var ShellDefaultAction, CommandLine: String;
begin
  result := True;

  if(FRegConnector = nil) or (Extension = '') then
      exit;

  if fWindowsNT and FRegConnector.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + Extension, false)
    and FRegConnector.ValueExists('Application')
  then
  begin
      // etwas grob, Application k�nnte ja auch unser Programm sein - ist aber auch nicht so tragisch.
      result := False;
      FRegConnector.CloseKey;
  end;



  if Result then
  begin
      // weitertesten
      // Name stimmt �berein?
      if (FRegConnector.OpenKey(fKey + Extension, false)) then
      try
          result := (FRegConnector.ReadString('') = InternalName);
      finally
          FRegConnector.CloseKey;
      end;

      if Result then
      begin
          // Weiter testen
          // Aktueller Handler die App?
          if (FRegConnector.OpenKey(fKey + InternalName + '\shell', False)) then
          begin
              // Default-Aktion holen (Enqueue, play, ...)
              try
                  ShellDefaultAction := FRegConnector.ReadString('');
              finally
                  FRegConnector.CloseKey;
              end;

              if (FRegConnector.OpenKey(fKey + Format(ShellKey + '\command', [InternalName, ShellDefaultAction]), False)) then
              try
                  CommandLine := FRegConnector.ReadString('');
                  result := Pos(AppName, CommandLine) > 0;
              finally
                  FRegConnector.CloseKey;
              end else
                result := False;
          end else
              result := False;
      end;
  end;
end;

function TFileTypeRegistration.RegisterType(const Extension,
  InternalName: string; Description: string = ''; IconFile: string = '';
  IconIndex: integer = -1): boolean;
//var
  //strDummy : string;    // ich schreibe IMMER den �bergebenen InternalNam ( wohl "Nemp.AudioFile" o.�.)
begin
  // Standardergebnis
  Result         := false;
  if(FRegConnector = nil) or
    (Extension = '') or
    (Extension[1] <> '.') then exit;

  // ist dieser Typ evtl. schon registriert?
  //strDummy := self.GetInternalKey(Extension);

  // Nein. :o)
  //if(strDummy = '') then
    //strDummy := InternalName;

  // den Schl�ssel mit der Dateiendung anlegen oder aktualisieren
  if(FRegConnector.OpenKey(fKey + Extension,true)) then
  try
    FRegConnector.WriteString('',InternalName);
    Result := (FRegConnector.ReadString('') = InternalName);
  finally
    FRegConnector.CloseKey;
  end;
  if (not Result) then exit;

  // den internen Schl�ssel �ffnen
  if(Result) and
    (FRegConnector.OpenKey(fKey + InternalName,true)) then
  try
    // Beschreibung anlegen
    if(Description <> '') then
      FRegConnector.WriteString('',Description);

    // Symbol zuweisen (Datei muss existieren!)
    if(IconFile <> '') and
      (fileexists(IconFile)) and
      (FRegConnector.OpenKey(fKey + InternalName + '\DefaultIcon',true)) then
    try
      if(IconIndex <> -1) then
        FRegConnector.WriteString('',Format('%s,%d',[IconFile,IconIndex]))
      else
        FRegConnector.WriteString('',IconFile);
    finally
      FRegConnector.CloseKey;
    end;
  finally
    FRegConnector.CloseKey;
  end;

  // Systemsymbole aktualisieren
  self.UpdateShell;

  // Properties aktualisieren
  if(Result) then
  begin
    FExtension    := Extension;
    FInternalName := InternalName;
  end;
end;

function TFileTypeRegistration.UnregisterExtension(const Extension: string):
  boolean;
begin
  Result := false;
  if(FRegConnector = nil) or
    (Extension = '') or
    (Extension[1] <> '.') then exit;

  // die Endung entfernen
  Result := (FRegConnector.KeyExists(fKey + Extension)) and
    (FRegConnector.DeleteKey(fKey + Extension));

  // Systemsymbole aktualisieren
  self.UpdateShell;
end;

function TFileTypeRegistration.UnregisterType(const Extension: string):
  boolean;
var
  strDummy : string;
begin
  Result   := false;
  if(FRegConnector = nil) or
    (Extension = '') or
    (Extension[1] <> '.') then exit;

  // den internen Namen der Endung ermitteln
  strDummy := self.GetInternalKey(Extension);

  // die Endung entfernen (s. "UnregisterExtension"), ...
  Result   := (self.UnregisterExtension(Extension)) and
  // ... & den internen Schl�ssel l�schen
    (strDummy <> '') and
    (FRegConnector.KeyExists(fKey + strDummy)) and
    (FRegConnector.DeleteKey(fKey + strDummy));

  // Systemsymbole aktualisieren
  self.UpdateShell;
end;

procedure TFileTypeRegistration.UpdateShell;
begin
  SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);
end;



function TFileTypeRegistration.AddHandler(const HandlerVerb,
  CommandLine: string; HandlerDescription: string = ''): boolean;
begin
  // Standardergebnis
  Result := false;
  if(FRegConnector = nil) or
    (FInternalName = '') or
    (HandlerVerb = '') or
    (CommandLine = '') then exit;

  // der interne Schl�ssel muss existieren
  if(FRegConnector.KeyExists(fKey + FInternalName)) then
  begin
    // den Handler (= Verb) erzeugen
    if(FRegConnector.OpenKey(fKey + Format(ShellKey + '\command',
      [FInternalName,HandlerVerb]),true)) then
    try
      FRegConnector.WriteString('',CommandLine);
      Result := (FRegConnector.ReadString('') = CommandLine);
    finally
      FRegConnector.CloseKey;
    end;

    // ggf. Beschreibung f�r Handler setzen
    if(HandlerDescription <> '') then
    begin
      if(FRegConnector.OpenKey(fKey + Format(ShellKey,[FInternalName,
        HandlerVerb]),true)) then
      try
        FRegConnector.WriteString('',HandlerDescription);
      finally
        FRegConnector.CloseKey;
      end;
    end;
  end;

  // interne Eigenschaft anpassen (f�r "SetDefaultHandler")
  if(Result) then
    FVerb := HandlerVerb;
end;

function TFileTypeRegistration.AddDirectoryHandler(const HandlerVerb,
  CommandLine: string; HandlerDescription: string = ''): boolean;
begin
  // Standardergebnis
  Result := false;
  if(FRegConnector = nil) or
    (HandlerVerb = '') or
    (CommandLine = '') then exit;

    // den Handler (= Verb) erzeugen
    if(FRegConnector.OpenKey(fKey + Format(ShellKey + '\command',
      ['directory',HandlerVerb]),true)) then
    try
      FRegConnector.WriteString('',CommandLine);
      Result := (FRegConnector.ReadString('') = CommandLine);
    finally
      FRegConnector.CloseKey;
    end;

    // ggf. Beschreibung f�r Handler setzen
    if(HandlerDescription <> '') then
    begin
      if(FRegConnector.OpenKey(fKey + Format(ShellKey,['directory',
        HandlerVerb]),true)) then
      try
        FRegConnector.WriteString('',HandlerDescription);
      finally
        FRegConnector.CloseKey;
      end;
    end;
end;

function TFileTypeRegistration.SetITouchMediaPlayer(CommandLine: string): boolean;
begin
  Result := False;
  if(FRegConnector = nil) then exit;


  if FRegConnector.OpenKey('\Software\Logitech\iTouch\CurrentVersion', False) then
  try
    FRegConnector.WriteString('MediaPlayer', CommandLine);
    Result := (FRegConnector.ReadString('MediaPlayer') = CommandLine);
  finally
    FRegConnector.CloseKey;
  end;
end;

function TFileTypeRegistration.DeleteUserChoice(
  const Extension: String): Boolean;
var ucKey: string;
begin
    // Standardergebnis
    Result := false;
    if(FRegConnector = nil)
        then exit;

    ucKey := //FRegConnector.RootKey
       '\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\'
      + Extension + '\UserChoice';
    Result :=
        FRegConnector.KeyExists(ucKey) and
        FRegConnector.DeleteKey(ucKey);
end;


function TFileTypeRegistration.DeleteHandler(const HandlerVerb: string):
  boolean;
begin
  // Standardergebnis
  Result := false;
  if(FRegConnector = nil) or
    (FInternalName = '') or
    (HandlerVerb = '') then exit;

  // Handlerschl�ssel entfernen (sofern vorhanden)
  Result :=
    (FRegConnector.KeyExists(fKey + Format(ShellKey,[FInternalName,HandlerVerb]))) and
    (FRegConnector.DeleteKey(fKey + Format(ShellKey,[FInternalName,HandlerVerb])));
end;

function TFileTypeRegistration.DeleteDirectoryHandler(const HandlerVerb: string):
  boolean;
begin
  // Standardergebnis
  Result := false;
  if(FRegConnector = nil) or
    (HandlerVerb = '') then exit;

  // Handlerschl�ssel entfernen (sofern vorhanden)
  Result :=
    (FRegConnector.KeyExists(fKey + Format(ShellKey,['directory',HandlerVerb]))) and
    (FRegConnector.DeleteKey(fKey + Format(ShellKey,['directory',HandlerVerb])));
end;

// Gesonderter Wert (falls mal "�ffnen mit ... [x]immer damit �ffnen" gew�hlt wurde) steht in
// HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mp3
//   -- Application
function TFileTypeRegistration.DeleteSpecialSetting(const Extension: string): Boolean;
// Extension: Inkl. Punkt, also z.B. '.mp3'
begin
  Result := false;
  if(FRegConnector = nil) or (Extension = '') or not fWindowsNT then
      exit;

  if FRegConnector.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\' + Extension, false) then
  begin
      result := FRegConnector.DeleteValue('Application');
      FRegConnector.CloseKey;
  end;

end;



function TFileTypeRegistration.SetDefaultHandler: boolean;
begin
  if(FInternalName <> '') and (FVerb <> '') then
    Result := self.SetDefaultHandler(FVerb)
  else
    Result := false;
end;

function TFileTypeRegistration.SetDefaultHandler(const HandlerVerb: string):
  boolean;
begin
  Result := false;
  if(FRegConnector = nil) or
    (FInternalName = '') or
    (HandlerVerb = '') then exit;

  // interner Schl�ssel muss existieren, ...
  if(FRegConnector.KeyExists(fKey + FInternalName)) and
  // ... & Handler muss existieren, ...
    (FRegConnector.KeyExists(fKey + Format(ShellKey,[FInternalName,HandlerVerb]))) and
    (FRegConnector.OpenKey(fKey + FInternalName + '\shell',false)) then
  try
  // ... dann den Handler als Standard eintragen
    FRegConnector.WriteString('',HandlerVerb);
    Result := (FRegConnector.ReadString('') = HandlerVerb);
  finally
    FRegConnector.CloseKey;
  end;
end;

// Die brauche ich zum Unregistrieren der Datentypen
function TFileTypeRegistration.GetInternalKey(const Extension: string): string;
begin
  if(FRegConnector = nil) or
    (Extension = '') or
    (Extension[1] <> '.') then exit;

  // einen evtl. eingestellten internen Namen zur�cksetzen
  FInternalName   := '';

  // den Schl�ssel der Dateiendung �ffnen, ...
  if(FRegConnector.KeyExists(fKey + Extension)) and
    (FRegConnector.OpenKey(fKey + Extension,false)) then
  try
  // ... & den Standardwert auslesen, ...
    FInternalName := FRegConnector.ReadString('');
  finally
    FRegConnector.CloseKey;
  end;

  // ... als Funktionsergebnis zur�ckliefern
  if(not FRegConnector.KeyExists(fKey + FInternalName)) then
    FInternalName := '';

  Result := FInternalName;
end;

function TFileTypeRegistration.GetInternalValue(const KeyName,
  ValueName: string): string;
begin
  Result := '';
  if(FInternalName = '') then exit;

  if(FRegConnector.KeyExists(fKey + FInternalName)) and
    (FRegConnector.OpenKey(fKey + Format('%s\%s',[FInternalName,KeyName]),false)) then
  try
    Result := FRegConnector.ReadString(ValueName);
  finally
    FRegConnector.CloseKey;
  end;
end;



{


Gesonderter Wert (falls mal "�ffnen mit ... [x]immer damit �ffnen" gew�hlt wurde)
steht in

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.mp3
   -- Application



HKEY_CURRENT_USER\Software\Classes\.mp3
}

end.




