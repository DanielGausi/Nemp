unit OneInst;

interface

uses
  Windows, Messages, dialogs, sysutils, IniFiles, Classes, StrUtils;

var
  { Mit dieser MessageId meldet sich dann eine zweite Instanz }
  SecondInstMsgId: UINT = 0;


function ParamBlobToStr(lpData: Pointer): Widestring;
function ParamStrToBlob(out cbData: DWORD): Pointer;

function IsExeInProgramSubDir: Boolean;


implementation

uses Systemhelper;

const
  { Maximale Zeit, die auf die Antwort der ersten Instanz gewartet wird (ms) }
  TimeoutWaitForReply = 5000;
  CSIDL_APPDATA = $001a;
  //CSIDL_PROGRAM_FILES = $26;

  ZeilenEnde = #13#10;

var
  { Der Text den diese Variable hat sollte bei jedem neuen Programm geändert }
  { werden und möglichst eindeutig (und nicht zu kurz) sein.                 }
  UniqueName: array [0..MAX_PATH] of Char = 'NEMP - noch ein MP3-Player ID'#0;
  MutexHandle: THandle = 0;


{ kleine Hilfsfunktion die uns die Kommandozeilenparameter entpackt }
function ParamBlobToStr(lpData: Pointer): Widestring;
var
  pStr: PWideChar;
  NewStr: Widestring;
begin
  Result := '';
  pStr := lpData;
  while pStr[0] <> #0 do
  begin
    Setlength(NewStr, lStrLenW(pStr));
    lstrcpyW(pWideChar(NewStr), pStr);
    Result := Result + NewStr + Widechar(#13) + Widechar(#10);
    pStr := @pStr[lstrlenW(pStr) + 1];
  end;
end;

{ kleine Hilfsfunktion die uns die Kommandozeilenparameter einpackt }
function ParamStrToBlob(out cbData: DWORD): Pointer;
var
  Loop: Integer;
  pStr: PChar;
begin
  cbData := Length(ParamStr(1)) * SizeOf(Char) + 4;  { gleich inklusive #0#0 }
  for Loop := 2 to ParamCount do
    cbData := cbData + DWORD(Length(ParamStr(Loop)) * SizeOf(Char) + 2);
  Result := GetMemory(cbData);
  ZeroMemory(Result, cbData);
  pStr := Result;
  for Loop := 1 to ParamCount do
  begin
    lstrcpy(pStr, PChar(ParamStr(Loop)));
    pStr := @pStr[lstrlen(pStr) + 1];
  end;
end;

procedure HandleSecondInstance;
var
  Run: DWORD;
  Now: DWORD;
  Msg: TMsg;
  Wnd: HWND;
  Dat: TCopyDataStruct;
begin
  // MessageBox(0, 'läuft schon', nil, MB_ICONINFORMATION);
  {----------------------------------------------------------------------------}
  { Wir versenden eine Nachricht an alle Hauptfenster (HWND_BROADCAST) mit der }
  { eindeutigen Message-Id, die wir zuvor registriert haben. Da nur eine       }
  { Instanz unseres Programms läuft sollte auch nur eine Anwendung antworten.  }
  {                                                                            }
  { (Broadcast sollten _NUR_ mit registrierten Nachrichten-Ids erfolgen!)      }
  {----------------------------------------------------------------------------}

  SendMessage(HWND_BROADCAST, SecondInstMsgId, GetCurrentThreadId, 0);

  { Wir warten auf die Antwort der ersten Instanz                        }
  { Für die, die es nicht wußten - auch Threads haben Message-Queues ;o) }
  Wnd := 0;
  Run := GetTickCount;
  while True do
  begin
    if PeekMessage(Msg, 0, SecondInstMsgId, SecondInstMsgId, PM_NOREMOVE) then
    begin
      GetMessage(Msg, 0, SecondInstMsgId, SecondInstMsgId);
      if Msg.message = SecondInstMsgId then
      begin
        Wnd := Msg.wParam;
        Break;
      end;
    end;
    Now := GetTickCount;
    if Now < Run then
      Run := Now;  { Überlaufschutz - passiert nur alle 48 Tage, aber naja }
    if Now - Run > TimeoutWaitForReply then
      Break;
  end;

  if (Wnd <> 0) and IsWindow(Wnd) then
  begin
    { Als Antwort haben wir das Handle bekommen, an das wir die Daten senden. }

    {-------------------------------------------------------------------------}
    { Wir verschicken nun eine Message mit WM_COPYDATA. Dabei handelt es sich }
    { eine der wenigen Nachrichten, bei der Windows Daten aus einem Prozeß in }
    { einen anderen einblendet. Nach Behandlung der Nachricht werden diese    }
    { wieder aus dem Adreßraum des Empfängers ausgeblendet, sodaß derjenige,  }
    { der die Nachricht erhält und die Daten weiter verwenden will, sich die  }
    { Daten kopieren muß.                                                     }
    {-------------------------------------------------------------------------}

    { Zur Absicherung schreiben wir nochmal die eindeutige Nachrichten-Id in  }
    { das Tag-Feld, das uns die Nachricht bietet.                             }
    { Ansonsten schreiben wir die Kommandozeilenparameter als                 }
    { durch #0 getrennte und durch #0#0 beendete Liste in den Datenblock      }
    Dat.dwData := SecondInstMsgId;
    Dat.lpData := ParamStrToBlob(Dat.cbData);
    SendMessage(Wnd, WM_COPYDATA, 0, LPARAM(@Dat));
    FreeMemory(Dat.lpData);


  end;
end;

procedure CheckForSecondInstance;
var
  Loop: Integer;
begin
  {-----------------------------------------------------------------------------}
  { Wir versuchen ein systemweit eindeutiges benanntes Kernelobjekt, ein Mutex  }
  { anzulegen und prüfen, ob dieses Objekt schon existiert.                     }
  { Der Name zum Anlegen eines Mutex darf nicht länger als MAX_PATH (260) sein  }
  { und darf alle Zeichen außer '\' enthalten.                                  }
  {                                                                             }
  { (Einzige Ausnahme sind die beiden Schlüsselwörter 'Global\' und 'Local\'    }
  {  mit denen ein Mutexname auf einem Terminalserver beginnen darf, damit der  }
  {  Mutex nicht nur oder expliziet für eine Session dient. Das wird aber nur   }
  {  sehr selten benötigt, wenn, dann meist bei Diensten auf Terminalservern.)  }
  {                                                                             }
  { Windows kennt nur einen Namensraum für Events, Semaphoren und andere        }
  { benannte Kernelobjekte. Das heißt es kommt zum Beispiel zu einem Fehler bei }
  { dem Versuch mit dem Namen eines existierenden benannten Events einen Mutex  }
  { zu erzeugen. (da gewinnt das Wort 'Sonderfall' fast eine neue Bedeutung ;o) }
  {-----------------------------------------------------------------------------}

  for Loop := lstrlen(UniqueName) to MAX_PATH - 1 do
  begin
    MutexHandle := CreateMutex(nil, False, UniqueName);
    if (MutexHandle = 0) and (GetLastError = INVALID_HANDLE_VALUE) then
      { Es scheint schon ein Kernelobjekt mit diesem Namen zu geben. }
      { Wir versuchen das Problem durch Anhängen von '_' zu lösen.   }
      lstrcat(UniqueName, '_')
    else
      { es gibt zumindest keinen Konflikt durch den geteilten Namensraum }
      Break;
  end;

  case GetLastError of
    0:
      begin
        { Wir haben den Mutex angelegt; sind also die erste Instanz. }
      end;
    ERROR_ALREADY_EXISTS:
      begin
        { Es gibt also schon eine Instanz - beginnen wir mit dem Prozedere. }
        try
          HandleSecondInstance;
        finally
          { was auch immer passiert, alles endet hier ;o) }
          { Die 183 ist nicht ganz zufällig, kleiner Spaß }
          Halt(183);
        end;
      end;
  else
    { Keine Ahnung warum wir hier landen sollten,        }
    { außer Microsoft hat wiedermal die Regeln geändert. }
    { Wie auch immer - wir lassen das Programm starten.  }
  end;
end;


function IsExeInProgramSubDir: Boolean;
var p1: String;
begin
    result := false;
    p1 := IncludeTrailingPathDelimiter(GetEnvironmentVariable('ProgramFiles'));
    if AnsiStartsText(p1, ParamStr(0)) then
        result := true
    else
    begin
        p1 := GetEnvironmentVariable('ProgramW6432');
        if p1 <> '' then
            result := AnsiStartsText(IncludeTrailingPathDelimiter(p1), ParamStr(0));
    end;
end;
{
ShowMessage(GetEnvironmentVariable('ProgramW6432'));
ShowMessage(GetEnvironmentVariable('ProgramFiles'));
}

function AllowOnlyOneInstance:boolean;
var NEMP_NAME: WideString;
  Savepath: WideString;
  ini: TMeminiFile;
begin
    result := True;

    NEMP_NAME := 'Nemp';
    //if AnsiStartsText(GetShellFolder(CSIDL_PROGRAM_FILES), Paramstr(0)) then
    if IsExeInProgramSubDir then
    begin
        // Nemp liegt im System-Programmverzeichnis
        SavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
        try
            ForceDirectories(SavePath);
        except
            if Not DirectoryExists(SavePath) then
                SavePath := ExtractFilePath(Paramstr(0)) + 'Data\';
        end;
    end else
    begin
        // Nemp liegt woanders
        SavePath := ExtractFilePath(Paramstr(0)) + 'Data\';
    end;

    ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
    try
        result := ini.ReadBool('Allgemein', 'AllowOnlyOneInstance', True);
    finally
        ini.free;
    end;
end;

initialization

  { Wir holen uns gleich zu Beginn eine eindeutige Nachrichten-Id die wir im }
  { Programm zur eindeutigen Kommunikation zwischen den Instanzen brauchen.  }
  { Jedes Programm bekommt, wenn es den gleichen Text benutzt, die gleiche   }
  { Id zurück (zumindest innerhalb einer Windows Sitzung)
                  }
  // Eine zweite Instanz abblocken, falls das generell unerwünscht ist,
  // oder falls ein Parameter übergeben wurde (d.h. eine neue Datei wird hinzugefügt)
  if (ParamCount > 0) OR AllowOnlyOneInstance then
  begin

    SecondInstMsgId := RegisterWindowMessage(UniqueName);
    { Auf eine schon laufende Instanz überprüfen. }
    CheckForSecondInstance;
  end;

finalization

  { Den Mutex wieder freigeben, was eigentlich nicht nötig wäre, da Windows NT }
  { Alle angeforderten Kernel-Objekte zum Prozeßende freigibt. Aber sicher ist }
  { sicher (Windows 95/98 kann nur 65535 Objekte verwalten - jaja 32-Bit ;o).  }
  if MutexHandle <> 0 then
  begin
    ReleaseMutex(MutexHandle);
    MutexHandle := 0;  { hilft beim Debuggen }
  end;

end.
