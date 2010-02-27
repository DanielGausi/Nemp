(******************************************************************************)
(*                TWindowsVersionInfo Version 1.5.0 (Jan. 2009)               *)
(*                File: WindowsVersionInfo.pas                                *)
(*                Copyright ® 2007-2009 by MagicAndre1981                     *)
(*                E-Mail: MagicAndre1981 (at) live (dot) com                  *)
(*                                                                            *)
(*- - - - - - - - - - - - - - - - - - - - - - - ------------------------------*)
(*                Ich übernehme keine Haftung für etwaige                     *)
(*                Schäden, die durch diese Komponente verursacht              *)
(*                werden.                                                     *)
(*- - - - - - - - - - - - - - - - - - - - - - - ------------------------------*)
(*                Diese Komponente ist FREEWARE.                              *)
(*                Ihr dürft sie in Kommerziellen und OpenSourceprogrammen     *)
(*                bei Nennung meines Namens und einem Link zum Topic frei     *)
(*                nutzen.                                                     *)
(*----------------------------------------------------------------------------*)
(*                History: V1.0   (20.08.2007)                                *)
(*                         - Erstveröffentlichung                             *)
(*                         V1.0.1 (25.08.2007)                                *)
(*                         - Fix bei Compilerdirektive                        *)
(*                         V1.5.0 (Januar 2009)                               *)
(*                         - Erkennung der Vista/Server2008 Revision          *)
(*                           überarbeitet                                     *)
(*                         - Erkennung von Windows Server 2008 RC0/RC1/RTM    *)
(*                         - Code lässt sich unter Delphi 2009 compilieren    *)
(*                         - Support für Windows 7 / Server 2008 R2           *)
(*                         - neue Properties: - Codename                      *)
(*                                            - IsBeta                        *)
(*                         - Erkennung für Windows Vista / Server 2008 Sp2    *)
(*                         - Erkennung für neue Windows Server 2008 Editionen *)
(******************************************************************************)

unit Windows_Fragment;

interface

{$I Jedi.inc}

uses
  Windows, SysUtils;

type
  POSVersionInfoA = ^TOSVersionInfoA;
  POSVersionInfoW = ^TOSVersionInfoW;
  POSVersionInfo = POSVersionInfoA;
  _OSVERSIONINFOA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar; { Maintenance string for PSS usage }
    wServicePackMajor,
    wServicePackMinor,
    wSuiteMask         : word;
    wProductType,
    wReserved          : byte;
  end;
  {$EXTERNALSYM _OSVERSIONINFOA}
  _OSVERSIONINFOW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar; { Maintenance string for PSS usage }
    wServicePackMajor,
    wServicePackMinor,
    wSuiteMask         : word;
    wProductType,
    wReserved          : byte;
  end;
  {$EXTERNALSYM _OSVERSIONINFOW}
  _OSVERSIONINFO = _OSVERSIONINFOA;
  TOSVersionInfoA = _OSVERSIONINFOA;
  TOSVersionInfoW = _OSVERSIONINFOW;
{$IFDEF DELPHI2009_UP}
  TOSVersionInfo = TOSVersionInfoW;
{$ELSE}
  TOSVersionInfo = TOSVersionInfoA;
{$ENDIF}
  OSVERSIONINFOA = _OSVERSIONINFOA;
  {$EXTERNALSYM OSVERSIONINFOA}
  {$EXTERNALSYM OSVERSIONINFO}
  OSVERSIONINFOW = _OSVERSIONINFOW;
  {$EXTERNALSYM OSVERSIONINFOW}
  {$EXTERNALSYM OSVERSIONINFO}
{$IFDEF DELPHI2009_UP}
  OSVERSIONINFO = OSVERSIONINFOW;
{$ELSE}
  OSVERSIONINFO = OSVERSIONINFOA;
{$ENDIF}

const
  {$EXTERNALSYM VERSIONINFOSIZEA}
  VERSIONINFOSIZEA  = sizeof(TOSVersionInfoA) -
    (sizeof(word) * 3) - (sizeof(byte) * 2);
  {$EXTERNALSYM VERSIONINFOSIZEW}
  VERSIONINFOSIZEW  = sizeof(TOSVersionInfoW) -
    (sizeof(word) * 3) - (sizeof(byte) * 2);
  {$EXTERNALSYM VERSIONINFOSIZE}
{$IFDEF DELPHI2009_UP}
  VERSIONINFOSIZE   = VERSIONINFOSIZEA;
{$ELSE}
  VERSIONINFOSIZE   = VERSIONINFOSIZEW;
{$ENDIF}

  //
  // RtlVerifyVersionInfo() os product type values
  //
  VER_NT_WORKSTATION                    = $0000001;
  VER_NT_DOMAIN_CONTROLLER              = $0000002;
  VER_NT_SERVER                         = $0000003;

  VER_SERVER_NT                         = $80000000;
  VER_WORKSTATION_NT                    = $40000000;
  VER_SUITE_SMALLBUSINESS               = $00000001;
  VER_SUITE_ENTERPRISE                  = $00000002;
  VER_SUITE_BACKOFFICE                  = $00000004;
  VER_SUITE_COMMUNICATIONS              = $00000008;
  VER_SUITE_TERMINAL                    = $00000010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED    = $00000020;
  VER_SUITE_EMBEDDEDNT                  = $00000040;
  VER_SUITE_DATACENTER                  = $00000080;
  VER_SUITE_SINGLEUSERTS                = $00000100;
  VER_SUITE_PERSONAL                    = $00000200;
  VER_SUITE_BLADE                       = $00000400;
  VER_SUITE_EMBEDDED_RESTRICTED         = $00000800;
  VER_SUITE_SECURITY_APPLIANCE          = $00001000;

  VER_SUITE_WH_SERVER                   = $00008000;

  SM_SERVERR2	                          = 89; // Windows Server 2003 R2
  SM_STARTER                            = 88; // Starter Edition von Windows XP
  SM_MEDIACENTER                        = 87; // Windows XP media Center Edition
  SM_TABLETPC	                          = 86; // Windows XP Tablet PC Edition

  PROCESSOR_ARCHITECTURE_INTEL          =  0;
  PROCESSOR_ARCHITECTURE_MIPS           =  1;
  PROCESSOR_ARCHITECTURE_ALPHA          =  2;
  PROCESSOR_ARCHITECTURE_PPC            =  3;
  PROCESSOR_ARCHITECTURE_SHX            =  4;
  PROCESSOR_ARCHITECTURE_ARM            =  5;
  PROCESSOR_ARCHITECTURE_IA64           =  6;
  PROCESSOR_ARCHITECTURE_ALPHA64        =  7;
  PROCESSOR_ARCHITECTURE_MSIL           =  8;
  PROCESSOR_ARCHITECTURE_AMD64          =  9;
  PROCESSOR_ARCHITECTURE_IA32_ON_WIN64  = 10;

  PRODUCT_BUSINESS                      = $00000006;
  PRODUCT_BUSINESS_N                    = $00000010;
  PRODUCT_CLUSTER_SERVER                = $00000012;
  PRODUCT_DATACENTER_SERVER             = $00000008;
  PRODUCT_DATACENTER_SERVER_CORE        = $0000000C;
  PRODUCT_DATACENTER_SERVER_CORE_V      = $00000027;
  PRODUCT_DATACENTER_SERVER_V           = $00000025;
  PRODUCT_ENTERPRISE                    = $00000004;
  PRODUCT_ENTERPRISE_N                  = $0000001B;
  PRODUCT_ENTERPRISE_SERVER             = $0000000A;
  PRODUCT_ENTERPRISE_SERVER_CORE        = $0000000E;
  PRODUCT_ENTERPRISE_SERVER_CORE_V      = $00000029;
  PRODUCT_ENTERPRISE_SERVER_IA64        = $0000000F;
  PRODUCT_ENTERPRISE_SERVER_V           = $00000026;
  PRODUCT_HOME_BASIC                    = $00000002;
  PRODUCT_HOME_BASIC_N                  = $00000005;
  PRODUCT_HOME_PREMIUM                  = $00000003;
  PRODUCT_HYPERV                        = $0000002A;
  PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT = $0000001E;
  PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING  = $00000020;
  PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY   = $0000001F;
  PRODUCT_HOME_SERVER                   = $00000013;
  PRODUCT_SERVER_FOR_SMALLBUSINESS      = $00000018;
  PRODUCT_SERVER_FOR_SMALLBUSINESS_V    = $00000023;
  PRODUCT_SMALLBUSINESS_SERVER          = $00000009;
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM  = $00000019;
  PRODUCT_STANDARD_SERVER               = $00000007;
  PRODUCT_STANDARD_SERVER_CORE          = $0000000D;
  PRODUCT_STANDARD_SERVER_CORE_V        = $00000028;
  PRODUCT_STANDARD_SERVER_V             = $00000024;
  PRODUCT_STARTER                       = $0000000B;
  PRODUCT_STORAGE_ENTERPRISE_SERVER     = $00000017;
  PRODUCT_STORAGE_EXPRESS_SERVER        = $00000014;
  PRODUCT_STORAGE_STANDARD_SERVER       = $00000015;
  PRODUCT_STORAGE_WORKGROUP_SERVER      = $00000016;
  PRODUCT_UNDEFINED                     = $00000000;
  PRODUCT_ULTIMATE                      = $00000001;
  PRODUCT_WEB_SERVER                    = $00000011;
  PRODUCT_WEB_SERVER_CORE               = $0000001D;

  VER_SUITE_COMPUTE_SERVER              = $00004000;
  VER_SUITE_STORAGE_SERVER              = $00002000;

  PRODUCT_UNLICENSED                    = $ABCDABCD;

function GetVersionExA(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall;
{$EXTERNALSYM GetVersionExA}
function GetVersionExW(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall;
{$EXTERNALSYM GetVersionExW}
function GetVersionEx(var lpVersionInformation: TOSVersionInfo): BOOL; stdcall;
{$EXTERNALSYM GetVersionEx}

function GetNativeSystemInfoEx : SYSTEM_INFO;
function GetProductInfo(dwOSMajorVersion, dwOSMinorVersion,dwSpMajorVersion,
                        dwSpMinorVersion: DWord;
                        var pdwReturnedProductType: Dword): BOOL;

implementation

function GetVersionExA; external kernel32 name 'GetVersionExA';
function GetVersionExW; external kernel32 name 'GetVersionExW';
function GetVersionEx;  external kernel32 name 'GetVersionExA';

function GetProductInfo(dwOSMajorVersion, dwOSMinorVersion, dwSpMajorVersion,
                        dwSpMinorVersion: DWord; var pdwReturnedProductType: Dword): BOOL;
var po :TFarProc;
    DLLWnd :THandle;
    GetProductInfo : function(  dwOSMajorVersion, dwOSMinorVersion,
                                dwSpMajorVersion, dwSpMinorVersion: DWord; var
                                pdwReturnedProductType: Dword)
                                :boolean; stdcall;
begin
  Result := FALSE;
  DLLWnd := LoadLibrary('kernel32');
  if DLLWnd > 0 then
  begin
    try
      po := GetProcAddress(DLLWnd, 'GetProductInfo');
      if po <> nil then
      begin
        @GetProductInfo := po;
        if GetProductInfo(  dwOSMajorVersion, dwOSMinorVersion, dwSpMajorVersion,
                            dwSpMinorVersion, pdwReturnedProductType) then
        Begin
          Result := TRUE;
        End
        else
          Result := FALSE;
      end
      else
        Result := FALSE;
    finally
      FreeLibrary(DLLWnd);
    end;
  end;
end;

// Use this method to avoid load issues on Windows 2000
function GetNativeSystemInfoEx : SYSTEM_INFO;
var
  temp : SYSTEM_INFO;
  po :TFarProc;
  DLLWnd :THandle;
  SI  :SYSTEM_INFO;
  GetNativeSystemInfo:procedure(var LPSYSTEM_INFO:SYSTEM_INFO);stdcall;
begin
  ZeroMemory(@temp,sizeof(temp));
  DLLWnd := LoadLibrary('kernel32');
  if DLLWnd > 0 then
    begin
      try
        po := GetProcAddress(DLLWnd, 'GetNativeSystemInfo');
        if po <> nil then
          begin
            @GetNativeSystemInfo := po;
            GetNativeSystemInfo(SI);
            result := SI;
          end
          else
          begin
            GetSystemInfo(temp);
            Result := temp;
          end;
      finally
        FreeLibrary(DLLWnd);
      end;
    end;
end;

end.