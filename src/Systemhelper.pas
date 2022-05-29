{

    Unit Systemhelper

    - Some System-Methods, Wrappers for Windows-API-Stuff

    Note: Probably every function/procedure was copied from "the internet", mostly
             www.entwickler-ecke.de
             www.delphipraxis.net
             www.delphi-treff.de
          It is assumed that these functions are kinda "public domain".
          If you want your credits here, give me a notice.

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

unit Systemhelper;

interface


uses
  Windows, Messages, SysUtils,  Classes, Forms, Dialogs, ShlObj, ActiveX,
  ClipBrd, ShellApi,  WinSock, AnsiStrings;


// Is XP-Theme active or Classic-mode?
// True: XP, False: Classic
//    - used at SetRegions for GroupBoxes (the borders have different positions there)
function _IsThemeActive: Boolean;

// Get the label from a Drive
// used in ScrobblerUtils for encoding SessionKey before saving to IniFile
function GetVolumeSerialNr(const Drive: string): string;

// Get special folders like Program_files, AppData, ...
function GetShellFolder(CSIDL: integer): string;

function NameOfMyComputer: UnicodeString;

procedure CopyFilesToClipboard(FileList: String);

// Exit Windows
function ExWindows(const AFlag: Word): Boolean;

{ The SetSuspendState function suspends the system by shutting power down.
  Depending on the Hibernate parameter,
  the system either enters a suspend (sleep) state or hibernation.}
function SetSuspendState(Hibernate: Boolean): Boolean;

function FindWindowByTitle(WindowTitle: string): Hwnd;

// Get all LAN-IPs
procedure getIPs(dest: Tstrings);

// Get the Version-Information from a File.
// used in About-Form and UpdateUtils
function GetFileVersionString(Path: String): string;

// Opens the Properties-Dialog for a File (like in Explorer)
function ShowFileProperties(const hWndOwner: HWnd; FileName, Caption: PChar): Boolean;

// Get the time the file was created
function GetFileCreationDateTime(Filename:String):TDateTime;

function FileIsWriteProtected(Filename: String): Boolean;

// http://michael-puff.de/Programmierung/Delphi/Code-Snippets/SystemPowerStatus.shtml
function GetPowerStatus(var HasBattery: Boolean; var LoadstatusPercent: Integer): DWORD;

implementation

var
  _SetSuspendState: function (Hibernate, ForceCritical, DisableWakeEvent: BOOL): BOOL
  stdcall = nil;


function _IsThemeActive: Boolean;
// Returns True if the user uses XP style
const
  themelib = 'uxtheme.dll';
type
  TIsThemeActive = function: BOOL; stdcall;
var
  IsThemeActive: TIsThemeActive;
  huxtheme: HINST;
begin
  Result := False;
  // Check if XP or later Version
  if (Win32Platform  = VER_PLATFORM_WIN32_NT) and
     (((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or
      (Win32MajorVersion > 5)) then
  begin
    huxtheme := LoadLibrary(themelib);
    if huxtheme <> 0 then
    begin
      try
        IsThemeActive := GetProcAddress(huxtheme, 'IsThemeActive');
        Result := IsThemeActive;
      finally
       if huxtheme > 0 then
          FreeLibrary(huxtheme);
      end;
    end;
  end;
end;


function GetVolumeSerialNr(const Drive: string): string;
var t: Integer;
    dummy, srnNr: DWord;
    Buffer, Buffer2 : array[0..MAX_PATH + 1] of Char;
begin
    result := '0';
    if Drive <> '' then
    begin
        t := GetDriveType(PChar(Drive));
        if (t = DRIVE_FIXED) then
        begin
            FillChar(Buffer, sizeof(Buffer), #0);
            FillChar(Buffer2, sizeof(Buffer2), #0);
            if GetVolumeInformation(PChar(Drive), Buffer, sizeof(Buffer), @srnNr,
                      dummy, dummy, Buffer2, sizeof(Buffer2))
            then
                result := IntToStr(srnNr)
        end;
    end;
end;



function GetShellFolder(CSIDL: integer): string;
var
  pidl              : PItemIdList;
  FolderPath        : string;
  SystemFolder      : Integer;
  Malloc            : IMalloc;
begin
  Malloc := nil;
  FolderPath := '';
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      SetLength(FolderPath, max_path);
      if SHGetPathFromIDList(pidl, PChar(FolderPath)) then
      begin
        SetLength(FolderPath, length(PChar(FolderPath)));
      end;
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;


procedure CopyFilesToClipboard(FileList: String);
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  iLen: Integer;
begin
  iLen := Length(FileList) + 2;
  FileList := FileList + #0#0;
  hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT,
    SizeOf(TDropFiles) + (iLen * SizeOf(Char)));
  if (hGlobal = 0) then raise Exception.Create('Could not allocate memory.');
  begin
    DropFiles := GlobalLock(hGlobal);
    DropFiles^.fWide := True;
    DropFiles^.pFiles := SizeOf(TDropFiles);
    Move(FileList[1], (PAnsiChar(DropFiles) + SizeOf(TDropFiles))^, iLen * SizeOf(Char));
    GlobalUnlock(hGlobal);
    Clipboard.SetAsHandle(CF_HDROP, hGlobal);
  end;
end;



function NameOfMyComputer: UnicodeString;
var
  pMal: IMalloc;
  pidl: PItemIdList;
  isf: IShellFolder;
  StrRet: TStrRet;
begin
  Result:='';
  if (SHGetMalloc(pMal) = NoError) and
     (SHGetDesktopFolder(isf) = NoError) then
  begin
    try
      SHGetSpecialFolderLocation(0, CSIDL_Drives, pidl);
      if pidl <> nil then
      begin
        isf.GetDisplayNameOf(pidl, SHGDN_NORMAL, StrRet);
        if StrRet.pOleStr <> nil then
        begin
          Result:=StrRet.pOleStr
        end
      end;
    finally
      if pidl<> nil then pMal.Free(pidl);
      isf:=nil;
      pMal:=nil
    end
  end
end;


function ExWindows(const AFlag: Word): Boolean;
var
  vi     : TOSVersionInfo;
  hToken : THandle;
  tp     : TTokenPrivileges;
  h      : DWord;
begin
  result:= false;

  vi.dwOSVersionInfoSize:=SizeOf(vi);

  if GetVersionEx(vi) then
  begin
    if vi.dwPlatformId = VER_PLATFORM_WIN32_NT then
    begin
      // Windows NT
      // Achtung bei Delphi 2 muﬂ @hToken stehen ...
      if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES,hToken) then
      begin
        LookupPrivilegeValue(nil,'SeShutdownPrivilege',tp.Privileges[0].Luid);
        tp.PrivilegeCount := 1;
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        h := 0;
        AdjustTokenPrivileges(hToken,False,tp,0,PTokenPrivileges(nil)^, h);
        CloseHandle(hToken);
        result := ExitWindowsEx(Aflag, 0);
      end;
    end
    else
    begin // Windows 95
      Result := ExitWindowsEx(Aflag, 0);
    end;
  end;
end;


{  Parameters:

   Hibernate: If this parameter is TRUE, the system hibernates.
              If the parameter is FALSE, the system is suspended.
   ForceCritical: If this parameter is TRUE, the system suspends operation immediately;
                  if it is FALSE, the system broadcasts a PBT_APMQUERYSUSPEND event to
                  each application to request permission to suspend operation.
   DisableWakeEvent: If this parameter is TRUE, the system disables all wake events.
                     If the parameter is FALSE, any system wake events remain enabled.


  Windows NT/2000/XP: Included in Windows 2000 and later.
  Windows 95/98/Me: Included in Windows 98 and later.
}

function LinkAPI(const module, functionname: string): Pointer; forward;

function SetSuspendState(Hibernate: Boolean): Boolean;
begin
  if not Assigned(_SetSuspendState) then
    @_SetSuspendState := LinkAPI('POWRPROF.dll', 'SetSuspendState');
  if Assigned(_SetSuspendState) then
    Result := _SetSuspendState(Hibernate, False, False)
  else
    Result := False;
end;

function LinkAPI(const module, functionname: string): Pointer;
var
  hLib: HMODULE;
begin
  hLib := GetModulehandle(PChar(module));
  if hLib = 0 then
    hLib := LoadLibrary(PChar(module));
  if hLib <> 0 then
    Result := getProcAddress(hLib, PChar(functionname))
  else
    Result := nil;
end;



function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do
  begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;


// http://www.delphipraxis.net/topic114668_wlan+ip+ermitteln.html
procedure getIPs(dest: Tstrings);
type
  PPInAddr= ^PInAddr;
var
  wsaData: TWSAData;
  HostInfo: PHostEnt;
  HostName: Array[0..255] of AnsiChar;
  Addr: PPInAddr;
begin
  Dest.Clear;
  if WSAStartup($0102, wsaData)=0 then
  try
    if gethostname(HostName, SizeOf(HostName)) = 0 then Begin
       HostInfo:= gethostbyname(HostName);
       if HostInfo<>nil then Begin
          Addr := Pointer(HostInfo^.h_addr_list);
          if (Addr<>nil) AND (Addr^<>nil) then
             Repeat
                    Dest.Add(String(AnsiStrings.StrPas(inet_ntoa(Addr^^))));
                    inc(Addr);
             Until Addr^=nil;
       end;
    end;
  finally
    WSACleanup;
  end;
end;


function GetFileVersionString(Path: String): string;
var
  lpVerInfo: pointer;
  rVerValue: PVSFixedFileInfo;
  dwInfoSize: cardinal;
  dwValueSize: cardinal;
  dwDummy: cardinal;
  lpstrPath: pChar;

begin
  if Trim(Path) = EmptyStr then
    lpstrPath := pChar(Paramstr(0))
  else
    lpstrPath := pChar(Path);

  dwInfoSize := GetFileVersionInfoSize(lpstrPath, dwDummy);

  if dwInfoSize = 0
  then begin
    Result := '(-)';//'No version specification';
    Exit;
  end;

  GetMem(lpVerInfo, dwInfoSize);
  GetFileVersionInfo(lpstrPath, 0, dwInfoSize, lpVerInfo);
  VerQueryValue(lpVerInfo, '\', pointer(rVerValue), dwValueSize);

  with rVerValue^ do
  begin
    Result := IntTostr(dwFileVersionMS shr 16);
    Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
    Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
    Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
  end;
  FreeMem(lpVerInfo, dwInfoSize);

end;

function ShowFileProperties(const hWndOwner: HWnd;
  FileName, Caption: PChar): Boolean;
var
  Info : TShellExecuteInfo;
begin
  With Info Do Begin
    cbSize := SizeOf(Info);
    fMask  := SEE_MASK_NOCLOSEPROCESS or
      SEE_MASK_INVOKEIDLIST or SEE_MASK_FLAG_NO_UI;
    wnd    := hWndOwner;
    lpVerb := 'properties';
    lpFile := FileName;
    lpParameters := Caption;
    lpDirectory := Nil;
    nShow := 0;
    hInstApp := 0;
    lpIDList := Nil;
  End;

  Result := ShellExecuteEx(@Info);
end;


// source: http://www.delphi-forum.de/viewtopic.php?t=26462
function GetFileCreationDateTime(Filename:String):TDateTime;
var t:TWin32FileAttributeData;
    Zeit:SYSTEMTIME;
begin
 GetFileAttributesEx(pchar(FileName),GetFileExInfoStandard,@t);
 FileTimeToSystemTime(t.ftCreationTime,Zeit);
 Result:=SystemTimeToDateTime(zeit);
end;

function FileIsWriteProtected(Filename: String): Boolean;
begin
    result := FileGetAttr(FileName) and faReadOnly  > 0;
end;

// http://michael-puff.de/Programmierung/Delphi/Code-Snippets/SystemPowerStatus.shtml
function GetPowerStatus(var HasBattery: Boolean; var LoadstatusPercent: Integer): DWORD;
var
  SystemPowerStatus: TSystemPowerStatus;
//  Text: string;
{resourcestring
  rsLoadStatusUnknown = 'Unbekannter Status';
  rsLoadStatusNoBattery = 'Es existiert keine Batterie';
  rsLoadStatusHigh = 'Hoher Ladezustand';
  rsLoadStatusLow = 'Niedriger Ladezustand';
  rsLoadStatusCritical = 'Kritischer Ladezustand';
  rsLoadStatusLoading = 'Batterie wird geladen';
  rsLoadSatusUnknownLoading = 'Unbekannter Ladezustand';}
begin
  SetLastError(0);
  if GetSystemPowerStatus(SystemPowerStatus) then
    with SystemPowerStatus do
    begin
      HasBattery := ACLineStatus = 0;
      {
      // Ladezustand der Batterie
      if (BatteryFlag = 255) then
        Text := rsLoadStatusUnknown
      else if (BatteryFlag and 128 = 128) then
        Text := rsLoadStatusNoBattery
      else
      begin
        case (BatteryFlag and (1 or 2 or 4)) of
          1: Text := rsLoadStatusHigh;
          2: Text := rsLoadStatusLow;
          4: Text := rsLoadStatusCritical;
        else
          Text := rsLoadSatusUnknownLoading
        end;
        if (BatteryFlag and 8 = 8) then
          LoadStatusString := Text + rsLoadStatusLoading;
      end;
      }
      // Ladezustand in Prozent
      if (BatteryLifePercent <> 255) then
        LoadstatusPercent := BatteryLifePercent
      else
        LoadstatusPercent := -1;
  end;
  Result := GetLastError;
end;

end.
