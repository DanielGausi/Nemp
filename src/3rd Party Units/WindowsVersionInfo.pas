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

{.$define USE_VCL}

unit WindowsVersionInfo;

{$I Jedi.inc}
{$I xe.inc}

interface

uses
  SysUtils,
{$IFDEF USE_VCL}
  Classes, Controls,
{$ENDIF}
  Windows, StrUtils ;

const Codename = 'Codename: ';

type

  TWinEdition = (
    weUnknown,
    weWinXPHome,
    weWinXPHomeN,
    weWinXPHomeK,
    weWinXPHomeKN,
    weWinXPProfessional,
    weWinXPProfessionalN,
    weWinXPProfessionalK,
    weWinXPProfessionalKN,
    weWinXPStarter,
    weWinXPFLP,
    weWinXPEmbedded,
    weWin2000Prof,
    weWebEdition,
    weStandard,
    weStandard_V,
    weStandardCore,
    weStandardCore_V,
    weEnterprise,
    weEnterprise_V,
    weEnterpriseCore,
    weEnterpriseCore_V,
    weDataCenter,
    weDataCenter_V,
    weDataCenterCore,
    weDataCenterCore_V,
    weClusterEdition,
    weServerForSBE,
    weSBS,
    weSBSPremEdit,
    weEBSManagement,
    weEBSMessaging,
    weEBSSecurity,
    weHyperV,
    weStorageEnterprise,
    weStorageExpress,
    weStorageStandard,
    weStorageWorkgroup,
    weWin2003KN,
    weWinHomeServer,
    weWorkstation,
    weServerCore,
    weServer,
    weAdvancedServer,
    weWinXPMCE,
    weWinXPMCE2004,
    weWinXPMCE2005,
    weWinXPTabletPC,
    weWinXPTabletPC2005,
    weVistaUnlicensed,
    weVistaStarter,
    weVistaHomeBasic,
    weVistaHomeBasicN,
    weVistaHomePremium,
    weVistaBusiness,
    weVistaBusinessN,
    weVistaEnterprise,
    weVistaUltimate,
    weWindows7Starter,
    weWindows7HomeBasic,
    weWindows7HomeBasicN,
    weWindows7HomePremium,
    weWindows7Business,
    weWindows7BusinessN,
    weWindows7Enterprise,
    weWindows7Ultimate
  );

  TWindowsVersions =
   (wvUnknown, wvWin95, wvWin95OSR2, wvWin95OSR21, wvWin95OSR25, wvWin98,
    wvWin98SE, wvWinME, wvWinNT31, wvWinNT35, wvWinNT351, wvWinNT4, wvWin2000,
    wvWinXP, wvWin2003, wvWinXP64, wvWin2003R2, wvWinVista, wvWinLonghorn,
    wvWinLHS, wvWinServer2008, wvWindows7, wvWinServer2008R2);

  TProcessorArchitecture = (
    paUnknown,
    paAlpha,
    pax86,
    pax64,
    paIA64
  );

  TWinType = (
    wtUnknown,
    wtWin32s,
    wtWin9x,
    wtWinNT
  );

  TWindowsVersionInfo = class{$IFDEF USE_VCL}(TComponent){$ENDIF}
  private
    { Private declarations }
    FMajorVersion             : Byte;
    FMinorVersion             : Byte;
    FServicePackMajor         : Byte;
    FServicePackMinor         : Byte;
    FwProductType             : BYTE;
    FBuild                    : DWORD;
    FBuildRev                 : DWORD;
    FIdentValue               : real;
    FServicePack              : string;
    FFullName                 : string;
    FBuildLab                 : string;
    FBuildLabEx               : string;
    FCodename                 : string;    
    FIsWinFLP                 : boolean;
    FIsN                      : boolean;
    FIsServerCore             : boolean;
    FIsBeta                   : boolean;
    FProcessorArchitecture    : TProcessorArchitecture;
    FWinType                  : TWinType;
    FWindowsVersion           : TWindowsVersions;
    FEdition                  : TWinEdition;

    procedure InitVariablen;
    function IsWinFLP         : boolean;
    function IsWinXP_N_Edition: boolean;
    function IsK_Edition      : boolean;
    function IsWin2k3KN       : boolean;
    function IdentValue       : real;
    function GetWinVersion    : string;
    function GetBuildLab      : string;          overload;
    function GetBuildLab(Ex : boolean) : string; overload;
    function GetBuildLabEx    : string;
    function GetBuildRev      : DWORD;  

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create{$IFDEF USE_VCL}(AOwner: TComponent){$ENDIF}; {$IFDEF USE_VCL}override;{$ENDIF}
    function IsWindows2008ServerCore     : boolean;
    function IsServer : boolean;
    function IsWorkstation : boolean;
    function IsMediaCenterEdition : boolean;
    function IsTabletPCEdition : boolean;
  {$IFDEF USE_VCL}
  published
  {$ENDIF}
    { Published declarations }
    property MajorVersion           : Byte read FMajorVersion;
    property MinorVersion           : Byte read FMinorVersion;
    property BuildNumber            : DWORD read FBuild;
    property BuildRevision          : DWORD read FBuildRev;
    property ServicePack            : string read FServicePack;
    property WindowsVersionsString  : string read FFullName;
    property BuildLab               : string read FBuildLab;
    property BuildLabEx             : string read FBuildLabEx;
    property Codename               : string read FCodename;
    property ServicePackMajor       : Byte read FServicePackMajor;
    property ServicePackMinor       : Byte read FServicePackMinor;
    property IsBeta                 : boolean read FIsBeta;
    property PlatformID             : TWinType read FWinType;
    property WindowsVersion         : TWindowsVersions read FWindowsVersion;
    property WindowsEdition         : TWinEdition read FEdition;
    property ProcessorArchitecture  : TProcessorArchitecture read FProcessorArchitecture;
  end;

{$IFDEF USE_VCL}
procedure Register;
{$ENDIF}

implementation

uses  Windows_Fragment;

{$IFDEF USE_VCL}
procedure Register;
begin
  RegisterComponents('System', [TWindowsVersionInfo]);
end;
{$ENDIF}

{ TWindowsVersionInfo }
constructor TWindowsVersionInfo.Create{$IFDEF USE_VCL}(AOwner: TComponent){$ENDIF};
begin
{$IFDEF USE_VCL}
  inherited Create(AOwner);
{$ENDIF}  
  InitVariablen;
  FFullName := GetWinVersion;
end;

procedure TWindowsVersionInfo.InitVariablen;
begin
  // Set Default Values
  FMajorVersion           := MAXBYTE;
  FMinorVersion           := MAXBYTE;
  FBuild                  := MAXDWORD;
  FBuildRev               := MAXDWORD;
  FServicePackMajor       := MAXBYTE;
  FServicePackMinor       := MAXBYTE;
end;

function TWindowsVersionInfo.GetBuildRev : DWORD;
var sCSDBuildnumber  : string;
    iCSDBuildnumber : DWORD;
    bRevFromBuildLabEx : boolean;

    function RelativeKey(const Key: string): PChar;
    begin
      Result := PChar(Key);
      if (Key <> '') and (Key[1] = '\') then
        Inc(Result);
    end;

    function RegReadString(const RootKey: HKEY; const Key, Name: string): string;
    var
      RegKey: HKEY;
      Size: DWORD;
      StrVal: string;
      RegKind: DWORD;
      Ret: Longint;
    begin
      Result := '';
      if RegOpenKeyEx(RootKey, RelativeKey(Key), 0, KEY_READ, RegKey) = ERROR_SUCCESS then
      begin
        RegKind := 0;
        Size := 0;
        Ret := RegQueryValueEx(RegKey, PChar(Name), nil, @RegKind, nil, @Size);
        if Ret = ERROR_SUCCESS then
          if RegKind in [REG_SZ, REG_EXPAND_SZ] then
          begin
            SetLength(StrVal, Size);
            RegQueryValueEx(RegKey, PChar(Name), nil, @RegKind, PByte(StrVal), @Size);
            SetLength(StrVal, StrLen(PChar(StrVal)));
            Result := StrVal;
          end;
        RegCloseKey(RegKey);
      end
    end;


    function GetRevisionFromBuildLabEx: DWORD;
    var
      s: string;
      i: Integer;
      E: Integer;
    begin
      i := Pos('.', BuildLabEx);
      s := Copy(BuildLabEx, i+1, PosEx('.', BuildLabEx, i)-1); // PosEx ist in Unit StrUtils
      Val(s, Result, E);
      if E <> 0 then Result := MAXDWORD;
    end;

   (* function GetRevisionFromBuildLabEx(): DWORD;
    var
      sp : TStrSplitter;
    begin
      sp := TStrSplitter.Create;
      try
        try
          sp.Execute(BuildLabEx,'.');
          Result := StrToInt( sp[1] );
        except on E: EConvertError do
          Result := MAXDWORD;
        end;
      finally
        FreeAndNil(sp);
      end;
    end;     *)

Begin
  Result := MAXDWORD; 
  bRevFromBuildLabEx := false;
  sCSDBuildnumber := '0';
  iCSDBuildnumber := 0;
  try
    sCSDBuildnumber := RegReadString (HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows NT\CurrentVersion\',
    'CSDBuildNumber');
    if sCSDBuildnumber <> '' then
      iCSDBuildnumber := StrToInt( sCSDBuildnumber )
    else
    Begin
      iCSDBuildnumber := GetRevisionFromBuildLabEx;
      bRevFromBuildLabEx := true;
    end
  except on E: EConvertError do
  end;

  // Revision unter Vista:
  // bis Build 5536: Revsion = CSDBuildNumber
  // ab dann: Revision = 16384 + CSDBuildNumber
  if (FWindowsVersion = wvWinVista) OR (FWindowsVersion = wvWinLHS) OR (FWindowsVersion = wvWinServer2008) then
  Begin
    if (FBuild >= 5536) AND NOT(bRevFromBuildLabEx) then
      Result := 16384 + iCSDBuildnumber // Revision = ur RTM (16384) + SP Version
    else
      Result := iCSDBuildnumber;
  End;

  // Revision unter Windows "7":
  // Revision = CSDBuildNumber
  if FWindowsVersion = wvWindows7 then
  Begin
    Result := iCSDBuildnumber;
  End;
End;

function TWindowsVersionInfo.GetWinVersion: string;
var
  osvi             : TOSVersionInfo;
  bOsVersionInfoEx : boolean;
  key              : HKEY;
  szProductType    : array[0..79]of char;
  dwBuflen         : dword;
  pdwReturnedProductType  : Dword;
  si               : SYSTEM_INFO;
begin
  // Try calling GetVersionEx using the OSVERSIONINFOEX structure.
  // If that fails, try using the OSVERSIONINFO structure.
  ZeroMemory(@osvi,sizeof(TOSVersionInfo));
  osvi.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
{$IFDEF DELPHI2009_UP}
  bOsVersionInfoEx := GetVersionExW(osvi);
{$ELSE}
  bOsVersionInfoEx := GetVersionEx(osvi);
{$ENDIF}
  if(not bOsVersionInfoEx) then
  begin
    osvi.dwOSVersionInfoSize := VERSIONINFOSIZE;
{$IFDEF DELPHI2009_UP}
    if(not GetVersionExW(osvi)) then
{$ELSE}
    if(not GetVersionEx(osvi)) then
{$ENDIF}
    begin
      Result := 'Fehler bei der Ermittlung der Windows-Version';
      exit;
    end;
  end;

  //Use this method to avoid load issues on Windows 2000
  si := GetNativeSystemInfoEx;

  // private Felder setzen
  FMajorVersion   := osvi.dwMajorVersion;
  FMinorVersion   := osvi.dwMinorVersion;
  FBuild          := LOWORD(osvi.dwBuildNumber);
  FServicePack    := osvi.szCSDVersion;
  FServicePackMajor := osvi.wServicePackMajor;
  FServicePackMinor := osvi.wServicePackMinor;
  FwProductType := osvi.wProductType;

  // PROCESSOR_ARCHITECTURE ermitteln
  case si.wProcessorArchitecture of
    PROCESSOR_ARCHITECTURE_INTEL :
      FProcessorArchitecture := pax86;
    PROCESSOR_ARCHITECTURE_ALPHA :
      FProcessorArchitecture := paAlpha;
    PROCESSOR_ARCHITECTURE_AMD64 :
      FProcessorArchitecture :=  pax64;
    PROCESSOR_ARCHITECTURE_IA64 :
      FProcessorArchitecture := paIA64;
  end;

  //
  case osvi.dwPlatformId of
    // Test for the Windows NT product family.
    VER_PLATFORM_WIN32_NT:
      begin
        FWinType := wtWinNT;
        if(osvi.dwMajorVersion = 6) and (osvi.dwMinorVersion = 0) then
        Begin
          FBuildLab   := GetBuildLab;
          FBuildLabEx := GetBuildLabEx;
          FCodename   := Codename + 'Longhorn ';

          if (osvi.wProductType = VER_NT_WORKSTATION) Then
          Begin
            if (LOWORD(osvi.dwBuildNumber) <= 5048) then
            Begin
              FWindowsVersion := wvWinLonghorn;
              Result := 'Microsoft Windows ';
            End
            else
            Begin
              FWindowsVersion := wvWinVista;
              Result := 'Windows Vista ';
            End;

            FBuildRev   := GetBuildRev;

            FIsBeta :=  ((FBuild < 6000) OR ((FBuild = 6000)
                          AND (FBuildRev < 16386))
                          OR
                        (( FBuild = 6001 ) AND (FBuildRev < 18000)));
              
            case LOWORD(osvi.dwBuildNumber) of
            3551 .. 3670:
              Result := 'Microsoft Windows M2 ';
            3683 .. 3718:
              Result := 'Microsoft Windows M3 ';
            4001 .. 4014:
              Result := 'Microsoft Windows M4 ';
            4015 .. 4033:
              Result := 'Microsoft Windows M5 ';
            4039 .. 4059:
              Result := 'Microsoft Windows M6 ';
            4060 .. 4093:
              if FBuild = 4074 then
                Result := 'Microsoft Windows WinHEC Demo '
              else
                Result := 'Microsoft Windows M7 ';
            5048:
              Result := 'Microsoft Windows Developer Preview ';
            else
              Begin
                if (LOWORD(osvi.dwBuildNumber) > 5048) then
                Begin
                  if (GetProductInfo(osvi.dwMajorVersion, osvi.dwMinorVersion,
                      osvi.wServicePackMajor, osvi.wServicePackMinor, pdwReturnedProductType))then
                      begin
                      case (pdwReturnedProductType) of
                        PRODUCT_UNLICENSED:
                        Begin
                          FEdition := weVistaUnlicensed;
                          Result := Result + 'Unlizenzierte Edition! ';
                        End;
                        PRODUCT_BUSINESS:
                        Begin
                          FEdition := weVistaBusiness;
                          Result := Result + 'Business Edition ';
                        End;
                        PRODUCT_BUSINESS_N:
                        begin
                          FEdition := weVistaBusinessN;
                          Result := Result + 'Business N Edition ';
                        end;
                        PRODUCT_ENTERPRISE:
                        Begin
                          FEdition := weVistaEnterprise;
                          Result := Result + 'Enterprise Edition ';
                        End;
                        PRODUCT_HOME_BASIC:
                        Begin
                          FEdition := weVistaHomeBasic;
                          Result := Result + 'Home Basic Edition ';
                        End;
                        PRODUCT_HOME_BASIC_N:
                        Begin
                          FEdition := weVistaHomeBasicN;
                          Result := Result + 'Home Basic N Edition ';
                        End;
                        PRODUCT_HOME_PREMIUM:
                        Begin
                          FEdition := weVistaHomePremium;
                          Result := Result + 'Home Premium Edition ';
                        End;
                        PRODUCT_STARTER:
                        Begin
                          FEdition := weVistaStarter;
                          Result := Result + 'Starter Edition ';
                        End;
                        PRODUCT_ULTIMATE:
                        Begin
                          FEdition := weVistaUltimate;
                          Result := Result + 'Ultimate Edition ';
                        End;
                      end;  // End Case
                    end; // End ProductInfo

                  case FProcessorArchitecture of
                  pax86:
                    Result := Result + 'x86 ';
                  pax64:
                    Result := Result + 'x64 ';
                  paIA64:
                    Result := Result + 'IA64 ';
                  end;

                  case LOWORD(osvi.dwBuildNumber) of
                  5112:
                    Result := Result + '(Beta 1) ';
                  5219:
                    Result := Result + '(Sep 2005 CTP) ';
                  5231:
                    Result := Result + '(Oct 2005 CTP) ';
                  5259:
                    Result := Result + '(Nov 2005 TAP Preview)  ';
                  5270:
                    Result := Result + '(Dez 2005 CTP) ';
                  5308:
                    Result := Result + '(Feb 2006 CTP) ';
                  5342:
                    Result := Result + '(March 2006 TAP Release) ';
                  5365, 5381:
                    Result := Result + '(Beta 2 Preview) ';
                  5384:
                    Result := Result + '(Beta 2) ';
                  5456:
                    Result := Result + '(Post-Beta 2) ';
                  5465:
                    Result := Result + '(Beta 2 June Refresh) ';
                  5472:
                    Result := Result + '(Beta 2 July Refresh) ';
                  5536, 5552:
                    Result := Result + '(pre RC 1) ';
                  5600,
                  5728:
                    Result := Result + '(RC 1) ';
                  5744:
                    Result := Result + '(RC 2) ';
                  5840:
                    Result := Result + '(pre RTM) ';
                  6000:
                    Begin
                      case FBuildRev of
                      16384:
                        Result := Result + '(first RTM Build) ';
                      16385:
                        Result := Result + '(last pre RTM Build) ';
                      end;
                    End;
                  6001:
                    Begin
                      case FBuildRev of
                        16549, 16633:
                          Result := Result + '(pre SP1 Beta) ';
                        16659:
                          Result := Result + '(SP1 Beta) ';
                        17036, 17042:
                          Result := Result + '(SP1 RC1 preview) ';
                        17052:
                          Result := Result + '(SP1 RC1) ';
                        17128:
                          Result := Result + '(SP1 RC1 Refresh) ';
                      end;
                    End;
                  6002:
                    begin
                      case FBuildRev of
                        16489, 16497:
                        begin
                          FIsBeta := True;
                          Result := Result + '(SP2 Beta) ';
                        end;
                      end;
                    end;
                  end; // End Case
                End; // end if
              end;  // end else begin
            end; // end case
          end
          else
          Begin
            FWindowsVersion := wvWinLHS;
            Result := 'Microsoft Windows Server ';

            FBuildRev   := GetBuildRev;

            FIsBeta := ((FBuild < 6001) OR (FBuild = 6001) AND (FBuildRev < 18000));

            if (FBuildRev <> MAXDWORD ) AND (FBuildRev >= 16606) then
            Begin
              Result := 'Microsoft Windows Server 2008 ';
              FWindowsVersion := wvWinServer2008;
            End;  // end if (BuildLabRev)

            if (LOWORD(osvi.dwBuildNumber) >= 5048) then
            Begin
              if (GetProductInfo(osvi.dwMajorVersion, osvi.dwMinorVersion,
                  osvi.wServicePackMajor, osvi.wServicePackMinor, pdwReturnedProductType))then
              begin
                case (pdwReturnedProductType) of
                PRODUCT_CLUSTER_SERVER:
                Begin
                  FEdition := weClusterEdition;
                  Result := Result + 'HPC Edition ';
                End;
                PRODUCT_DATACENTER_SERVER_CORE:
                Begin
                  FEdition := weDataCenterCore;
                  FIsServerCore := true;
                  Result := Result + 'Core Datacenter Edition ';
                End;
                PRODUCT_DATACENTER_SERVER_CORE_V:
                Begin
                  FEdition := weDataCenterCore_V;
                  FIsServerCore := True;
                  Result := Result + 'Core Datacenter Edition without Hyper-V ';
                End;
                PRODUCT_DATACENTER_SERVER:
                Begin
                  FEdition := weDataCenter;
                  Result := Result + 'Datacenter Edition ';
                End;
                PRODUCT_DATACENTER_SERVER_V:
                Begin
                  FEdition := weDataCenter_V;
                  Result := Result + 'Datacenter Edition without Hyper-V ';
                End;
                PRODUCT_ENTERPRISE_SERVER:
                Begin
                  FEdition := weEnterprise;
                  Result := Result + 'Enterprise Edition ';
                End;
                PRODUCT_ENTERPRISE_SERVER_V:
                Begin
                  FEdition := weEnterprise_V;
                  Result := Result + 'Enterprise Edition without Hyper-V ';
                End;
                PRODUCT_ENTERPRISE_SERVER_CORE:
                Begin
                  FEdition := weEnterpriseCore;
                  FIsServerCore := true;
                  Result := Result + 'Core Enterprise Edition ';
                End;
                PRODUCT_ENTERPRISE_SERVER_CORE_V:
                Begin
                  FEdition := weEnterpriseCore_V;
                  FIsServerCore := true;
                  Result := Result + 'Core Enterprise Edition without Hyper-V ';
                End;
                PRODUCT_ENTERPRISE_SERVER_IA64:
                Begin
                  FEdition := weEnterprise;
                  Result := Result + 'Itanium Enterprise Edition ';
                End;
                PRODUCT_SERVER_FOR_SMALLBUSINESS:
                Begin
                  FEdition := weServerForSBE;
                  Result := Result + 'Server for Small Business Edition ';
                End;
                PRODUCT_SMALLBUSINESS_SERVER:
                Begin
                  FEdition := weSBS;
                  Result := Result + 'Small Business Server ';
                End;
                PRODUCT_SMALLBUSINESS_SERVER_PREMIUM:
                Begin
                  FEdition := weSBSPremEdit;
                  Result := Result + 'Small Business Server Premium Edition ';
                End;
                PRODUCT_STANDARD_SERVER:
                Begin
                  FEdition := weStandard;
                  Result := Result + 'Standard Edition ';
                End;
                PRODUCT_STANDARD_SERVER_V:
                Begin
                  FEdition := weStandard_V;
                  Result := Result + 'Standard Edition without Hyper-V ';
                End;
                PRODUCT_STANDARD_SERVER_CORE:
                Begin
                  FEdition := weStandardCore;
                  FIsServerCore := true;
                  Result := Result + 'Core Standard Edition ';
                End;
                PRODUCT_STANDARD_SERVER_CORE_V:
                Begin
                  FEdition := weStandardCore_V;
                  FIsServerCore := true;
                  Result := Result + 'Core Standard Edition without Hyper-V ';
                End;
                PRODUCT_STORAGE_ENTERPRISE_SERVER:
                Begin
                  FEdition := weStorageEnterprise;
                  Result := Result + 'Storage Enterprise Edition ';
                End;
                PRODUCT_STORAGE_EXPRESS_SERVER:
                Begin
                  FEdition := weStorageExpress;
                  Result := Result + 'Storage Express Edition ';
                End;
                PRODUCT_STORAGE_STANDARD_SERVER:
                Begin
                  FEdition := weStorageStandard;
                  Result := Result + 'Storage Standard Edition ';
                End;
                PRODUCT_STORAGE_WORKGROUP_SERVER:
                Begin
                  FEdition := weStorageWorkgroup;
                  Result := Result + 'Storage Workgroup Edition ';
                End;
                PRODUCT_HYPERV:
                Begin
                  FEdition := weHyperV;
                  Result := Result + 'Hyper-V Edition ';
                End;
                PRODUCT_MEDIUMBUSINESS_SERVER_MANAGEMENT:
                begin
                  FEdition := weEBSManagement;
                  Result := 'Windows Essential Business Server - Management Server';
                end;
                PRODUCT_MEDIUMBUSINESS_SERVER_MESSAGING:
                begin
                  FEdition := weEBSMessaging;
                  Result := 'Windows Essential Business Server - Messaging Server';
                end;
                PRODUCT_MEDIUMBUSINESS_SERVER_SECURITY:
                begin
                  FEdition := weEBSSecurity;
                  Result := 'Windows Essential Business Server - Security Server';
                end;
                PRODUCT_WEB_SERVER:
                Begin
                  FEdition := weWebEdition;
                  if (FBuildRev <> MAXDWORD ) AND (FBuildRev >= 16606) then
                    Result := 'Microsoft Windows Web Server 2008 '
                  else
                    Result := Result + 'Web Edition ';
                end;
                PRODUCT_WEB_SERVER_CORE:
                Begin
                  FEdition := weWebEdition;
                  FIsServerCore := True;
                  if (FBuildRev <> MAXDWORD ) AND (FBuildRev >= 16606) then
                    Result := 'Microsoft Windows Core Web Server 2008 '
                  else
                    Result := Result + 'Web Edition ';
                end;
              end;  // End if productInfo

              case FProcessorArchitecture of
              pax86:
                Result := Result + 'x86 ';
              pax64:
                Result := Result + 'x64 ';
              paIA64:
                Result := Result + 'IA64 ';
              end;

              case LOWORD(osvi.dwBuildNumber) of
              5112:
                Result := Result + '(Beta 1) ';
              5219:
                Result := Result + '(Sep 2005 CTP) ';
              5231:
                Result := Result + '(Oct 2005 CTP) ';
              5259:
                Result := Result + '(Nov 2005 TAP Preview) ';
              5270:
                Result := Result + '(Dez 2005 CTP) ';
              5308:
                Result := Result + '(Feb 2006 CTP) ';
              5384:
                Result := Result + '(Beta 2) ';
              5600:
                Result := Result + '(Aug 2006 CTP) ';
              5728:
                Result := Result + '(Sep 2006 CTP) ';
              5744:
                Result := Result + '(Oct 2006 CTP) ';
              6001:
              Begin
                case FBuildRev of
                16406:
                  Result := Result + '(Dez 2006 CTP) ';
                16461:
                  Result := Result + '(Feb 2007 CTP) ';
                16497:
                  Result := Result + '(April 2007 CTP) ';
                16510:
                  Result := Result + '(Beta 3) ';
                16606:
                  Result := Result + '(June 2007 CTP) ';
                16648:
                  Result := Result + '(pre RC0) ';
                16659:
                  Result := Result + '(RC0) ';
                17042:
                  Result := Result + '(Nov CTP - RC1) ';
                17051:
                  Result := Result + '(RC1) ';
                17119:
                  if FProcessorArchitecture = pax64 then
                    Result := Result + '(Hyper-V RC Build) ';
                end;  // End case FBuildRev
              End;  // if 6001
              6002:
                begin
                  case FBuildRev of
                    16489, 16497:
                    begin
                      FIsBeta := True;
                      Result := Result + '(SP2 Beta) ';
                    end;
                  end;
                end;
              end; // End Case osvi.dwBuildNumber
            End;  // end if GetProductInfo
          End;  // end if (LOWORD(osvi.dwBuildNumber) >= 5048)
        End; // end ELse
        end;

        if(osvi.dwMajorVersion = 6) and (osvi.dwMinorVersion = 1) then
        Begin
          FWindowsVersion := wvWindows7;
          Result := 'Windows 7 ';
          
          FBuildLab   := GetBuildLab;
          FBuildLabEx := GetBuildLabEx;
          FBuildRev   := GetBuildRev;
          FCodename   := Codename + 'Seven ';
          FIsBeta     := true;

          if (osvi.wProductType = VER_NT_WORKSTATION) Then
          Begin
            if (GetProductInfo(osvi.dwMajorVersion, osvi.dwMinorVersion,
                osvi.wServicePackMajor, osvi.wServicePackMinor, pdwReturnedProductType))then
            begin
              case (pdwReturnedProductType) of
                PRODUCT_UNLICENSED:
                Begin
                  FEdition := weVistaUnlicensed;
                  Result := Result + 'Unlizenzierte Edition! ';
                End;
                PRODUCT_BUSINESS:
                Begin
                  FEdition := weWindows7Business;
                  Result := Result + 'Business Edition ';
                End;
                PRODUCT_BUSINESS_N:
                begin
                  FEdition := weWindows7BusinessN;
                  Result := Result + 'Business N Edition ';
                end;
                PRODUCT_ENTERPRISE:
                Begin
                  FEdition := weWindows7Enterprise;
                  Result := Result + 'Enterprise Edition ';
                End;
                PRODUCT_HOME_BASIC:
                Begin
                  FEdition := weWindows7HomeBasic;
                  Result := Result + 'Home Basic Edition ';
                End;
                PRODUCT_HOME_BASIC_N:
                Begin
                  FEdition := weWindows7HomeBasicN;
                  Result := Result + 'Home Basic N Edition ';
                End;
                PRODUCT_HOME_PREMIUM:
                Begin
                  FEdition := weWindows7HomePremium;
                  Result := Result + 'Home Premium Edition ';
                End;
                PRODUCT_STARTER:
                Begin
                  FEdition := weWindows7Starter;
                  Result := Result + 'Starter Edition ';
                End;
                PRODUCT_ULTIMATE:
                Begin
                  FEdition := weWindows7Ultimate;
                  Result := Result + 'Ultimate Edition ';
                End;
              end;  // End Case
            end; // End ProductInfo

            case FProcessorArchitecture of
            pax86:
              Result := Result + 'x86 ';
            pax64:
              Result := Result + 'x64 ';
            paIA64:
              Result := Result + 'IA64 ';
            end;

            case LOWORD(osvi.dwBuildNumber) of
            6400..6499:
              Result := Result + '(pre M1) ';
            6518..6574:
              Result := Result + '(M1) ';
            6589:
              Result := Result + '(M2) ';
            6780..6899:
              Result := Result + '(M3) ';
            7000:
              Result := Result + '(Beta) ';
            end;
          End  // End IF
          Else
          Begin
            FWindowsVersion := wvWinServer2008R2;
            Result := 'Microsoft Windows Server 2008 R2';

            FBuildRev   := GetBuildRev;

            FIsBeta := True;

            case LOWORD(osvi.dwBuildNumber) of
            6608:
              Result := 'Microsoft Windows 7 Server' + '(M2) ';
            end;
          End;
        End;
        // Test for the specific product family.
        if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 2) then
        Begin
          FBuildLab := GetBuildLab;
          FCodename := Codename + '.net Server ';
          FIsBeta := (FBuild < 3790);

          if GetSystemMetrics(SM_SERVERR2) <> 0 Then
          Begin
            FWindowsVersion := wvWin2003R2;
            Result := 'Microsoft Windows Server 2003 R2 '
          End
          else
          if (osvi.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) Then
          Begin
            FWindowsVersion := wvWinXP64;
            Result := 'Microsoft Windows XP Professional x64 Edition '
          End
          else
          Begin
            FWindowsVersion := wvWin2003;
            Result := 'Microsoft Windows Server 2003 ';
          End;

          if IsWin2k3KN then
          Begin
            FEdition := weWin2003KN;
            Result := Result + 'KN ';
          End;

        End;

        if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 1) then
        Begin
          FWindowsVersion := wvWinXP;
          Result := 'Microsoft Windows XP ';
          FBuildLab := GetBuildLab;
          // Test auf N Edition
          FIsN        := IsWinXP_N_Edition;
          // Test auf FLP
          FIsWinFLP   := IsWinFLP;
          FCodename   := Codename + 'Whistler ';
          FIsBeta := (FBuild < 2600);
          FBuildRev := GetBuildRev;
        End;

        if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 0) then
        Begin
          FWindowsVersion := wvWin2000;
          Result := 'Microsoft Windows 2000 ';
          FCodename   := Codename + 'NT 5.0 ';
          FIsBeta := (FBuild < 2195);
        End;

        if(osvi.dwMajorVersion <= 4) then
        Begin
          Result := 'Microsoft Windows NT ';
          case FMajorVersion of
          4: FWindowsVersion := wvWinNT4;
          3: if FMinorVersion = 1 then
             Begin
               FIsBeta := (FBuild < 511);
               FWindowsVersion := wvWinNT31
             End
             else if FMinorVersion = 5 then
                  Begin
                    FIsBeta := (FBuild < 807);
                    FCodename   := Codename + 'Daytona ';
                    FWindowsVersion := wvWinNT35
                  end
                  else if FMinorVersion = 51 then
                    Begin
                      FWindowsVersion := wvWinNT351;
                      FIsBeta := (FBuild < 1057);
                    end
          end;
        End;
        // Test for specific product on Windows NT 4.0 SP6 and later.
        if(bOsVersionInfoEx) then
        begin
          // Test for the workstation type.
          if (osvi.wProductType = VER_NT_WORKSTATION) and (si.wProcessorArchitecture <> PROCESSOR_ARCHITECTURE_AMD64) then
          begin
            if(osvi.dwMajorVersion = 4) then
            Begin
              FWindowsVersion := wvWinNT4;
              FEdition := weWorkstation;
              FCodename   := Codename + 'Cairo ';
              FIsBeta := (FBuild < 1381);
              Result := Result + '4.0 Workstation '
            End
            else if(osvi.wSuiteMask and VER_SUITE_PERSONAL <> 0) and (osvi.dwMajorVersion = 5) then
            Begin
              Result := Result + 'Home Edition ';
              FEdition := weWinXPHome;

              if IsK_Edition then
              Begin
                if IsWinXP_N_Edition then
                Begin
                  Result := Result + 'KN ';
                  FEdition := weWinXPHomeKN;
                End
                else
                Begin
                  FEdition := weWinXPHomeK;
                  Result := Result + 'K ';
                End;
              End
              else
              // N-Edition ist Windows ohne MediaPlayer.
              // Muss in der EU angeboten werden
              // vormals RME - Reduced Media Edition
              if IsWinXP_N_Edition then
              Begin
                FEdition := weWinXPHomeN;
                Result := Result + 'N ';
              End;
            End
            else
            Begin
              if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 1) then
              Begin
                case LOWORD(osvi.dwBuildNumber) of
                2296, 2410, 2419, 2428:
                  Result := Result + 'Beta 1 ';
                2462 .. 2504:
                  Result := Result + 'Beta 2 ';
                2505:
                  Result := Result + 'RC 1 ';
                2525 .. 2542:
                  Result := Result + 'RC 2 ';
                2545:
                  Result := Result + 'pre RTM ';
                end;
                // Unterscheidung zw. MCE  und Prof.
                if GetSystemMetrics(SM_MEDIACENTER) <> 0 then
                Begin
                  // Wert zur Erkennung der MCE Versionen
                  FIdentValue := IdentValue;
                  
                  Result := Result + 'Media Center Edition ';
                  FEdition := weWinXPMCE;
                  if ((FIdentValue >= 2.0) and (FIdentValue < 3.0) )then
                  Begin
                    FEdition := weWinXPMCE2004;
                    Result := Result + '2004 ';
                  End;
                  if ((FIdentValue >= 3.0) and (FIdentValue <= 4.0) )then
                  Begin
                    FEdition := weWinXPMCE2005;
                    Result := Result + '2005 ';
                  End;
                End
                else if GetSystemMetrics(SM_TABLETPC) <> 0 then
                Begin
                  if (lstrcmpi(osvi.szCSDVersion,'Service Pack 2') = 0) then
                  Begin
                    FEdition := weWinXPTabletPC2005;
                    Result := Result + 'Tablet PC Edition 2005 '
                  End
                  else
                  Begin
                    FEdition := weWinXPTabletPC;
                    Result := Result + 'Tablet PC Edition ';
                  End;
                End
                else if GetSystemMetrics(SM_STARTER) <> 0 then
                Begin
                  FEdition := weWinXPStarter;
                  Result := Result + 'Starter Edition '
                End
                else if IsWinFLP then
                Begin
                  FEdition := weWinXPFLP;
                  Result := 'Windows Fundamentals for Legacy PCs '
                End
                else if (osvi.wSuiteMask and VER_SUITE_EMBEDDEDNT <> 0) then
                Begin
                  FEdition := weWinXPEmbedded;
                  Result := Result + 'Embedded '
                End
                else
                Begin
                  FEdition := weWinXPProfessional;
                  Result := Result + 'Professional ';
                  // KN-Edition ist Windows ohne MediaPlayer und Messenger.
                  // Muss in Korea angeboten werden
                  if IsK_Edition then
                  Begin
                    if IsWinXP_N_Edition then
                    Begin
                      Result := Result + 'KN ';
                      FEdition := weWinXPProfessionalKN;
                    End
                    else
                      Begin
                        FEdition := weWinXPProfessionalK;
                        Result := Result + 'K ';
                      End;
                  End
                  // N-Edition ist Windows ohne MediaPlayer.
                  // Muss in der EU angeboten werden
                  // vormals RME - Reduced Media Edition
                  else if IsWinXP_N_Edition then
                  Begin
                    FEdition := weWinXPProfessionalN;
                    Result := Result + 'N ';
                  End;
                End;
              End;
              if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 0) then
              Begin
                FEdition := weWin2000Prof;
                Result := Result + 'Professional ';
                case LOWORD(osvi.dwBuildNumber) of
                1671:
                  Result := Result + 'Beta 1 ';
                1877:
                  Result := Result + 'Beta 2 ';
                2031:
                  Result := Result + 'Beta 3 ';
                2072:
                Begin
                  if FProcessorArchitecture = paAlpha then
                    Result := Result + 'Beta für DEC-Alpha-Prozessoren '
                  else
                    Result := Result + 'RC 1 ';
                End;
                2128:
                  Result := Result + 'RC 2 ';
                2183:
                  Result := Result + 'RC 3 ';
                5111:
                Begin
                  FIsBeta := true;
                  FCodename   := Codename + 'Neptune ';
                end;
                end;
              End;
            End;
          end
          // Test for the server type.
          else if(osvi.wProductType = VER_NT_SERVER) OR (osvi.wProductType = VER_NT_DOMAIN_CONTROLLER ) then
          begin
            if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 2) then
            begin
              if ( si.wProcessorArchitecture= PROCESSOR_ARCHITECTURE_IA64 ) Then  // Win2003 Itanium
              Begin
                if(osvi.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Begin
                  FEdition := weDataCenter;
                  Result := Result + 'Datacenter Edition for Itanium-based Systems '
                End
                else if(osvi.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                Begin
                  FEdition := weEnterprise;
                  Result := Result + 'Enterprise Edition for Itanium-based Systems '
                End
                  else
                  Begin
                    FEdition := weStandard;
                    Result := Result + 'Standard Edition for Itanium-based Systems '
                  End;
              End
              else if ( si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64) Then // Win2003 x86-64 
              Begin
                if(osvi.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Begin
                  FEdition := weDataCenter;
                  Result := Result + 'Datacenter x64 Edition '
                End
                else if(osvi.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                begin
                  FEdition := weEnterprise;
                  Result := Result + 'Enterprise x64 Edition '
                end
                else
                Begin
                  FEdition := weStandard;
                  Result := Result + 'Standard x64 Edition'
                End;
              End
              else
              Begin      // Win 2003 x86
                if(osvi.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Begin
                  FEdition := weDataCenter;
                  Result := Result + 'Datacenter Edition '
                End
                else if osvi.wSuiteMask and VER_SUITE_WH_SERVER <> 0 then
                Begin
                  FEdition := weWinHomeServer;
                  Result := 'Microsoft Windows Home Server ';
                End
                else if(osvi.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                Begin
                  FEdition := weEnterprise;
                  Result := Result + 'Enterprise Edition '
                End
                else if(osvi.wSuiteMask AND VER_SUITE_BLADE <> 0) then
                Begin
                  FEdition := weWebEdition;
                  Result := Result + 'Web Edition '
                End
                else
                begin
                  FEdition := weStandard;
                  Result := Result + 'Standard Edition ';
                end;
               End;   
            end // Win 2000
            else if(osvi.dwMajorVersion = 5) and (osvi.dwMinorVersion = 0) then
            begin
              if(osvi.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
              Begin
                FEdition := weDataCenter;
                Result := Result + 'Datacenter Server '
              End
              else if(osvi.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
              Begin
                FEdition := weAdvancedServer;
                Result := Result + 'Advanced Server '
              End
              else
              begin
                FEdition := weServer;
                Result := Result + 'Server ';
              end;

              case LOWORD(osvi.dwBuildNumber) of
                1671:
                  Result := Result + 'Beta 1 ';
                1877:
                  Result := Result + 'Beta 2 ';
                2031:
                  Result := Result + 'Beta 3 ';
                2072:
                Begin
                  if FProcessorArchitecture = paAlpha then
                    Result := Result + 'Beta für DEC-Alpha-Prozessoren '
                  else
                    Result := Result + 'RC 1 ';
                End;
                2128:
                  Result := Result + 'RC 2 ';
                2183:
                  Result := Result + 'RC 3 ';
                end;
            end
            else if (osvi.dwMajorVersion = 4) and (osvi.dwMinorVersion = 0) then
            begin // Windows NT 4.0
              if(osvi.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
              Begin
                FEdition := weEnterprise;
                Result := Result + 'Server 4.0, Enterprise Edition '
              End
              else
              Begin
                FEdition := weServer;
                Result := Result + 'Server 4.0 ';
              End;
            end;
          end          
        end
        // Test for specific product on Windows NT 4.0 SP5 and earlier
        else
        begin
          dwBufLen := sizeof(szProductType);

          if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,
            'SYSTEM\CurrentControlSet\Control\ProductOptions',0,
            KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
          try
            ZeroMemory(@szProductType,sizeof(szProductType));

            if(RegQueryValueEx(key,'ProductType',nil,nil,
              @szProductType,@dwBufLen) <> ERROR_SUCCESS) or
              (dwBufLen > sizeof(szProductType)) then
            ZeroMemory(@szProductType,sizeof(szProductType));
          finally
            RegCloseKey(key);
          end;

          if(lstrcmpi('WINNT',szProductType) = 0) then
          Begin
            FEdition := weWorkstation;
            Result := Result + 'Workstation ';
          End;

          if(lstrcmpi('LANMANNT',szProductType) = 0) then
          begin
            FEdition := weServer;
            Result := Result + 'Server ';
          end;

          if(lstrcmpi('SERVERNT',szProductType) = 0) then
          Begin
            FEdition := weAdvancedServer;
            Result := Result + 'Advanced Server ';
          End;

          Result := Format('%s%d.%d',[Result,osvi.dwMajorVersion,
            osvi.dwMinorVersion]);
        end;

        // Display service pack (if any) and build number.
        if(osvi.dwMajorVersion = 4) and
          (lstrcmpi(osvi.szCSDVersion,'Service Pack 6') = 0) then
        begin
          // Test for SP6 versus SP6a.
          if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,
            'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Hotfix\Q246009',
            0,KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
            Begin
              FServicePack := 'Service Pack 6a';
            End;
            RegCloseKey(key);
        end
      end; // ELSE BEGIN
{$IFNDEF DELPHI2009_UP}
    // Test for the Windows 95 product family.
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        FWinType := wtWin9x;
        if(osvi.dwMajorVersion = 4) and (osvi.dwMinorVersion = 0) then
        begin
          Result := 'Microsoft Windows 95 ';
          FWindowsVersion := wvWin95;
          FCodename   := Codename + 'Chicago ';
          FIsBeta := (FBuild < 950) OR ( (FBuild > 951) AND (FBuild < 1110)) OR
          ( (FBuild > 1112) AND (FBuild < 1212) );
          case LOWORD(osvi.dwBuildNumber) of
          122:
              Result := Result + 'Beta ';
          189:
              Result := Result + 'Beta 2 Sept. 1994 ';
          347:
              Result := Result + 'Beta 3 März 1995 ';
          480:
              Result := Result + 'Beta 4 Mai 1995 ';
          950:
              if(osvi.szCSDVersion[1] = 'A') then
                Result := Result + 'OSR1 ';
          999:
            Begin
              FCodename   := Codename + 'Nashville ';
              Result := Result + 'B Beta ';
            end
          end;

          if(osvi.szCSDVersion[1] = 'C') then
          Begin
            FWindowsVersion := wvWin95OSR25; 
            Result := Result + 'C OSR2.5 ';
          End
          else
          if(osvi.szCSDVersion[1] = 'B') then
          Begin
            FWindowsVersion := wvWin95OSR21;
            Result := Result + 'B OSR2 ';
          End;

        end;

        if(osvi.dwMajorVersion = 4) and (osvi.dwMinorVersion = 10) then
        begin
          FWindowsVersion := wvWin98;
          Result := 'Microsoft Windows 98 ';
          FCodename   := Codename + 'Memphis ';
          FIsBeta :=  (FBuild < 1998) OR ( (FBuild > 1998) AND (FBuild < 2222) );
          if(osvi.szCSDVersion[1] = 'A') or (osvi.szCSDVersion[1] = 'B') then
          Begin
            FWindowsVersion := wvWin98SE;
            Result:= Result + 'SE ';
          End;
          case LOWORD(osvi.dwBuildNumber) of
          1387:
            Result := Result + 'Developer Release ';
          1488:
            Result := Result + 'Beta 1 ';
          1546:
            Result := Result + 'Beta 2 ';
          1602:
            Result := Result + 'Beta 2.1 ';
          1619:
            Result := Result + 'Beta 2 Refresh ';
          1629 .. 1658:
            Result := Result + 'Beta 3 ';
          1691:
            Result := Result + 'RC 0 ';
          1720 .. 1723:
            Result := Result + 'RC 1 ';
          end;
        end;

        if(osvi.dwMajorVersion = 4) and (osvi.dwMinorVersion = 90) then
        begin
          FWindowsVersion := wvWinME;
          FCodename   := Codename + 'Georgia ';
          FIsBeta :=  (FBuild < 3000);
          Result := 'Microsoft Windows Millennium Edition ';
          case LOWORD(osvi.dwBuildNumber) of
          2380 .. 2416:
              Result := Result + 'Beta 1 ';
          2419 .. 2495:
              Result := Result + 'Beta 2 ';
          2499 .. 2520:
              Result := Result + 'Beta 3 ';
          2525:
              Result := Result + 'RC 1 ';
          end;
        end;
      end;
    VER_PLATFORM_WIN32s:
      Result := 'Microsoft Win32s';
{$ENDIF}
  end;
end;

function TWindowsVersionInfo.IdentValue: real;
var Ident        : array[0..3]of char;
    key          : HKEY;
    dwBuflen     : dword;
Begin
  ZeroMemory(@Ident,sizeof(Ident));
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,
      'SOFTWARE\Microsoft\Windows\CurrentVersion\Media Center',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      RegQueryValueEx(key,'Ident',nil,nil,@Ident,@dwBufLen);
    End
  finally
  end;
  {$IFDEF USESTYLES}FormatSettings.{$ENDIF}DecimalSeparator := '.';
  //FormatSettings.DecimalSeparator := '.';
  try
    Result := StrToFloat( StrPas( Ident) );
  except on E : EConvertError Do
    Result := 0.0;
  end;
End;

function TWindowsVersionInfo.GetBuildLabEx : string;
begin
  Result := GetBuildLab(true);
end;

function TWindowsVersionInfo.GetBuildLab : string;
begin
  Result := GetBuildLab(false);
end;

function TWindowsVersionInfo.GetBuildLab(Ex: boolean): string;
var BuildLabTemp : array[0..255]of char;
    key          : HKEY;
    dwBuflen     : dword;
Begin
  Result := '';
  ZeroMemory(@BuildLabTemp,sizeof(BuildLabTemp));
  dwBuflen := Sizeof(BuildLabTemp);
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,
      'SOFTWARE\Microsoft\Windows NT\CurrentVersion',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      if Ex then
      Begin
        RegQueryValueEx(key,'BuildLabEx',nil,nil,@BuildLabTemp,@dwBufLen);
      End
      else
      Begin
        RegQueryValueEx(key,'BuildLab',nil,nil,@BuildLabTemp,@dwBufLen);
      End;
    End
  finally
  end;
  Result := BuildLabTemp;
End;

function TWindowsVersionInfo.IsWin2k3KN: boolean;
var WindowsMediaServices  : integer;
    key                 : HKEY;
    dwBuflen            : dword;
begin
  WindowsMediaServices := 1;
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\WindowsFeatures',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      RegQueryValueEx(key,'Windows Media Services', nil,nil,@WindowsMediaServices,@dwBufLen);
    End;
  finally
  end;
  Result := ( 0 = WindowsMediaServices );
end;

function TWindowsVersionInfo.IsK_Edition: boolean;
var KWeblinks           : integer;
    Messenger           : DWORD;
    key                 : HKEY;
    dwBuflen            : dword;
Begin
  KWeblinks := 1;
  Messenger := 1;
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\WindowsFeatures',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      RegQueryValueEx(key,'KWeblinks', nil,nil,@KWeblinks,@dwBufLen);
      RegQueryValueEx(key,'Windows Messenger', nil,nil,@Messenger,@dwBufLen);
    End;
  finally
  end;
  Result := ( 0 = KWeblinks ) OR ( 0 = Messenger ) ;
End;

function TWindowsVersionInfo.IsWinXP_N_Edition: boolean;
var WindowsMediaPlayer  : integer;
    key                 : HKEY;
    dwBuflen            : dword;
Begin
  WindowsMediaPlayer := 1;
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\WindowsFeatures',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      RegQueryValueEx(key,'Windows Media Player', nil,nil,@WindowsMediaPlayer,@dwBufLen);
    End;
  finally
  end;
  Result := ( 0 = WindowsMediaPlayer );
End;

function TWindowsVersionInfo.IsWinFLP: boolean;
var fundamentals : integer;
    key          : HKEY;
    dwBuflen     : dword;
Begin
  fundamentals := 0;
  try
    if(RegOpenKeyEx(HKEY_LOCAL_MACHINE,'SYSTEM\WPA\Fundamentals',0,
      KEY_QUERY_VALUE,key) = ERROR_SUCCESS) then
    Begin
      RegQueryValueEx(key,'Installed',nil,nil,@fundamentals,@dwBufLen);
    End;
  finally
  end;
  Result := ( 1 = fundamentals );
End;

function TWindowsVersionInfo.IsWindows2008ServerCore;
begin
  Result := ( (FWindowsVersion = wvWinLHS) or (FWindowsVersion = wvWinServer2008 )
            AND ( FIsServerCore ));
end;

function TWindowsVersionInfo.IsMediaCenterEdition: boolean;
begin
  Result := GetSystemMetrics(SM_MEDIACENTER) <> 0;
end;

function TWindowsVersionInfo.IsServer: boolean;
begin
  Result := (FwProductType = VER_NT_DOMAIN_CONTROLLER) OR
            (FwProductType = VER_NT_SERVER);
end;

function TWindowsVersionInfo.IsWorkstation: boolean;
begin
  Result := (FwProductType = VER_NT_WORKSTATION);
end;

function TWindowsVersionInfo.IsTabletPCEdition: boolean;
begin
  Result := GetSystemMetrics(SM_TABLETPC) <> 0;
end;

end.
