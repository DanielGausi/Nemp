{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                    Taskbar API  unit                  }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}


unit fspTaskbarApi;

interface
uses Windows, SysUtils;

resourcestring
  SfspTbrInvalidOwner = 'This component must be placed on TCustomForm or its descendant';
  SfspTbrHelperTabError = 'Unable to create helper tab. Error code %d';

const
  TASKBAR_CID: TGUID = '{56FDF344-FD6D-11d0-958A-006097C9A090}';

const
  TBPF_NOPROGRESS = $0;
  TBPF_INDETERMINATE = $1;
  TBPF_NORMAL = $2;
  TBPF_ERROR = $4;
  TBPF_PAUSED = $8;

  THBF_ENABLED = $0;
  THBF_DISABLED = $1;
  THBF_DISMISSONCLICK = $2;
  THBF_NOBACKGROUND = $4;
  THBF_HIDDEN = $8;
  THBF_NONINTERACTIVE = $10;

  THB_BITMAP = $1;
  THB_ICON = $2;
  THB_TOOLTIP = $4;
  THB_FLAGS = $8;

  WM_DWMSENDICONICTHUMBNAIL = $323;
  WM_DWMSENDICONICLIVEPREVIEWBITMAP = $326;

  DWMWA_NCRENDERING_ENABLED = 1;
  DWMWA_NCRENDERING_POLICY = 2;
  DWMWA_TRANSITIONS_FORCEDISABLED = 3;
  DWMWA_ALLOW_NCPAINT = 4;
  DWMWA_CAPTION_BUTTON_BOUNDS = 5;
  DWMWA_NONCLIENT_RTL_LAYOUT = 6;
  DWMWA_FORCE_ICONIC_REPRESENTATION = 7;
  DWMWA_FLIP3D_POLICY = 8;
  DWMWA_EXTENDED_FRAME_BOUNDS = 9;
  DWMWA_HAS_ICONIC_BITMAP = 10;
  DWMWA_DISALLOW_PEEK = 11;
  DWMWA_EXCLUDED_FROM_PEEK = 12;
  DWMWA_LAST = 13;

  MSGFLT_ADD    = 1;
  MSGFLT_REMOVE = 2;

  THBN_CLICKED  = $1800;

type
  EfspTbrInvalidOwner = class(Exception);
  EfspTbrHelperTabError = class(Exception);

type

  THUMBBUTTON = packed record
    dwMask   : Integer;
    iId      : UINT;
    iBitmap  : UINT;
    hIcon    : HICON;
    szTip    : Array[0..259] of WCHAR;
    dwFlags  : Integer;
  end;
  TThumbButton = THUMBBUTTON;

type
  ITaskBarList4 = interface(IUnknown)
   ['{c43dc798-95d1-4bea-9030-bb99e2983a1a}']
    function HrInit() : HRESULT; stdcall;
    function AddTab(hwnd: THandle) : HRESULT; stdcall;
    function DeleteTab(hwnd: THandle) : HRESULT; stdcall;
    function ActivateTab(hwnd: THandle) : HRESULT; stdcall;
    function SetActiveAlt(hwnd: THandle) : HRESULT; stdcall;
    function MarkFullscreenWindow(hwnd: THandle; fFullscreen: Boolean) : HRESULT; stdcall;
    function SetProgressValue(hwnd: THandle; ullCompleted: Int64; ullTotal: Int64) : HRESULT; stdcall;
    function SetProgressState(hwnd: THandle; tbpFlags: Cardinal) : HRESULT; stdcall;
    function RegisterTab(hwnd: THandle; hwndMDI: THandle) : HRESULT; stdcall;
    function UnregisterTab(hwndTab: THandle) : HRESULT; stdcall;
    function SetTabOrder(hwndTab: THandle; hwndInsertBefore: THandle) : HRESULT; stdcall;
    function SetTabActive(hwndTab: THandle; hwndMDI: THandle; tbatFlags: Cardinal) : HRESULT; stdcall;
    function ThumbBarAddButtons(hwnd: THandle; cButtons: Cardinal; pButtons: Pointer) : HRESULT; stdcall;
    function ThumbBarUpdateButtons(hwnd: THandle; cButtons: Cardinal; pButtons: Pointer) : HRESULT; stdcall;
    function ThumbBarSetImageList(hwnd: THandle; himl: THandle) : HRESULT; stdcall;
    function SetOverlayIcon(hwnd: THandle; hIcon: THandle; pszDescription: PWChar) : HRESULT; stdcall;
    function SetThumbnailTooltip(hwnd: THandle; pszDescription: PWChar) : HRESULT; stdcall;
    function SetThumbnailClip(hwnd: THandle; var prcClip: TRect) : HRESULT; stdcall;
    function SetTabProperties(hwndTab: THandle; stpFlags: Integer) : HRESULT; stdcall;
  end;

var
  pTaskBarList: ITaskBarList4;

  //my definitions of dwmapi functions
  fspDwmSetWindowAttribute : function (hwnd: HWND; dwAttribute: DWORD;
  pvAttribute: Pointer; cbAttribute: DWORD): HResult; stdcall;
  fspDwmSetIconicThumbnail : function (hwnd: HWND; hbmp: HBITMAP;
  dwSITFlags: DWORD): HResult; stdcall;
  fspDwmSetIconicLivePreviewBitmap : function (hwnd: HWND; hbmp: HBITMAP;
  Client : PPoint; dwSITFlags: DWORD): HResult; stdcall;
  fspDwmInvalidateIconicBitmaps: function (hwnd: HWND): HResult; stdcall;

  fspSetCurrentProcessExplicitAppUserModelID : function (AppID : PWChar) : HResult; stdcall;
  fspGetCurrentProcessExplicitAppUserModelID : function (var AppID : PWChar) : HResult; stdcall;

  fspChangeWindowMessageFilter: function (mes: integer; dwFlag: dword): bool; stdcall;
  fspPrintWindow : function(hwnd : HWND; hdcBlt :  HDC; nFlags : UINT) : BOOL; stdcall;


implementation
uses
  ActiveX;

var
  HDwmApi  : HMODULE;
  HShell32 : HMODULE;
  HUser32 : HMODULE;

procedure InitTaskbarApi;
var
  hr : HRESULT;
begin
  if (Win32MajorVersion >= 7) or ((Win32MajorVersion = 6) and (Win32MinorVersion >=1)) then begin
    {$IFDEF FSP_COINIT_MULTITHREADED}
    CoInitializeEx(nil, COINIT_MULTITHREADED );
    {$ELSE}
    CoInitializeEx(nil, COINIT_APARTMENTTHREADED );
    {$ENDIF}
    hr := CoCreateInstance(TASKBAR_CID, nil, CLSCTX_INPROC_SERVER, ITaskBarList4, pTaskBarList);
    if hr = 0 then
      pTaskBarList.HrInit();

    HDwmApi := LoadLibrary('dwmapi.dll');
    if HDwmApi <> 0 then begin
      fspDwmSetWindowAttribute := GetProcAddress(HDwmApi, 'DwmSetWindowAttribute');
      fspDwmSetIconicThumbnail := GetProcAddress(HDwmApi, 'DwmSetIconicThumbnail');
      fspDwmSetIconicLivePreviewBitmap := GetProcAddress(HDwmApi, 'DwmSetIconicLivePreviewBitmap');
      fspDwmInvalidateIconicBitmaps := GetProcAddress(HDwmApi, 'DwmInvalidateIconicBitmaps');
    end;

    HShell32 := LoadLibrary('shell32.dll');
    if HShell32 <> 0 then begin
      fspSetCurrentProcessExplicitAppUserModelID := GetProcAddress(HShell32, 'SetCurrentProcessExplicitAppUserModelID');
      fspGetCurrentProcessExplicitAppUserModelID := GetProcAddress(HShell32, 'GetCurrentProcessExplicitAppUserModelID');
    end;

    HUser32 :=  LoadLibrary('User32.dll');
    if HUser32 <> 0 then begin
      fspChangeWindowMessageFilter := GetProcAddress(hUser32, 'ChangeWindowMessageFilter');
      fspPrintWindow := GetProcAddress(hUser32, 'PrintWindow');
    end;
  end;
end;

procedure DoneTaskbarApi;
begin
  if HDwmApi <> 0 then
    FreeLibrary(HDwmApi);
  if HShell32 <> 0 then
    FreeLibrary(HShell32);
  if HUser32 <> 0 then
    FreeLibrary(HUser32);
  pTaskBarList := nil;
end;

initialization
  InitTaskbarApi;

finalization
  DoneTaskbarApi;

end.
