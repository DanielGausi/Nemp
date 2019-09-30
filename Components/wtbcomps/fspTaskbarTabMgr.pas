{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.81               }
{                    Taskbar Tab manager                }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}

unit fspTaskbarTabMgr;

{$I fspWinTaskbar.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, contnrs;

type
  TfspTaskbarTabMgr = class;
  TfspTaskbarTab = class;

  TTabNeedIconicBitmapEvent = procedure(Sender : TObject; Tab : TfspTaskbarTab;
                      Width : Integer; Height : Integer; var Bitmap : HBITMAP) of Object;
  TTabNeedIconicLivePreviewEvent = procedure(Sender : TObject; Tab : TfspTaskbarTab;
                           var Bitmap : HBITMAP; var Origin : TPoint) of Object;
  TTabNotifyEvent = procedure(Sender : TObject; Tab : TfspTaskbarTab) of Object;

  TfspTaskbarTab = class(TObject)
  private
    FManager : TfspTaskbarTabMgr;
    FTabHWnd : THandle;
    FMainWnd : THandle;
    FTabData : Pointer;
    FThumbTooltip : WideString;
    function GetCaption : TCaption;
    procedure SetCaption(ACaption : TCaption);
    function GetIndex : Integer;
    procedure SetIndex(const NewIndex: Integer);
    function GetIconHandle: THandle;
    procedure SetIconHandle(const Value: THandle);
  protected
    function SendIconicRepresentation(Width : Integer; Height : Integer) : HRESULT; virtual;
    function SendLivePreviewBitmap : HRESULT; virtual;
    procedure SetThumbTooltip(Tooltip: WideString);
  public
    property TabHWnd : THandle read FTabHWnd;
    property Caption : TCaption read GetCaption write SetCaption;
    property ThumbTooltip : WideString read FThumbTooltip write SetThumbTooltip;
    property TabData : Pointer read FTabData write FTabData;
    property Index : Integer read GetIndex write SetIndex;
    constructor Create(ATabMgr : TfspTaskbarTabMgr; ATabData : Pointer; ACaption : TCaption);
    property IconHandle : THandle read GetIconHandle write SetIconHandle;
    destructor Destroy; override;
    procedure Activate;
    procedure InvalidatePreview;
  end;

  TfspTaskbarTabMgr = class(TComponent)
  private
    { Private declarations }
    FMainForm : TForm;
    FMainWnd  : THandle;
    FOrigMainWndProc : Pointer;
    FTaskbarTabs : TObjectList;
    FOnNeedIconicBitmap : TTabNeedIconicBitmapEvent;
    FOnNeedIconicLivePreview : TTabNeedIconicLivePreviewEvent;
    FOnMinimize : TNotifyEvent;
    FOnRestore : TNotifyEvent;
    FOnActivateTab: TTabNotifyEvent;
    FOnCloseTab: TTabNotifyEvent;
    FActive: Boolean;
    function GetTaskbarTabIndex(I: Integer): TfspTaskbarTab;
    function GetTabCount: Integer;
    procedure SetActive(const Value: Boolean);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure MainWndProc(var Message : TMessage);
    property TaskbarTabs[I : Integer] : TfspTaskbarTab read GetTaskbarTabIndex;
    property TabCount : Integer read GetTabCount;
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function AddTab(TabData : Pointer; Caption : TCaption) : TfspTaskbarTab;
    procedure RemoveTab(Tab : TfspTaskbarTab);
    procedure MoveTab(CurrentIndex : Integer; NewIndex : Integer);
    procedure ActivateTab(TabIndex : Integer);
    procedure InvalidateAllPreviews;
  published
    { Published declarations }
    property Active : Boolean read FActive write SetActive;
    property OnNeedIconicBitmap : TTabNeedIconicBitmapEvent read FOnNeedIconicBitmap write FOnNeedIconicBitmap;
    property OnNeedIconicLivePreview : TTabNeedIconicLivePreviewEvent read FOnNeedIconicLivePreview write FOnNeedIconicLivePreview;
    property OnMinimize : TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnRestore : TNotifyEvent read FOnRestore write FOnRestore;
    property OnActivateTab : TTabNotifyEvent read FOnActivateTab write FOnActivateTab;
    property OnCloseTab : TTabNotifyEvent read FOnCloseTab write FOnCloseTab;
  end;

implementation
uses fspTaskbarApi, fspTaskbarCommon, ComObj, fspControlsExt;

const
  WS_EX_NOACTIVATE = $08000000;

  TabWinClassName = '__TfspTaskbarTab';


function TabWndProc (hwnd : THandle; uMsg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT; stdcall;
var
  TabWnd : TfspTaskbarTab;
  EnableAttribute : DWORD;
  hr : HRESULT;
begin
  Result := 0;
  TabWnd := Pointer(GetWindowLong(HWnd, GWL_USERDATA));
  if not Assigned(TabWnd) then begin
    if uMsg = WM_NCCREATE then begin
      TabWnd := PCreateStruct(lParam).lpCreateParams;
      TabWnd.FTabHWnd := hwnd;
      SetWindowLong(hWnd, GWL_USERDATA, Integer(TabWnd));
    end;
    Result := DefWindowProc(hwnd, uMsg, wParam, lParam);
  end
  else begin
    case uMsg of
    WM_CREATE: begin
            EnableAttribute := 1;
            if Assigned(fspDwmSetWindowAttribute) and Assigned(fspDwmSetWindowAttribute) then begin
              hr := fspDwmSetWindowAttribute(
                  hwnd,
                  DWMWA_FORCE_ICONIC_REPRESENTATION,
                  @EnableAttribute,
                  SizeOf(EnableAttribute));
              OleCheck(hr);
              hr := fspDwmSetWindowAttribute(
                  hwnd,
                  DWMWA_HAS_ICONIC_BITMAP,
                  @EnableAttribute,
                  SizeOf(EnableAttribute));
              OleCheck(hr);
            end;
//            hr := pTaskBarList.RegisterTab(hwnd, Application.Handle);
            if TabWnd.FManager.FActive and (pTaskBarList <> nil) then begin
              hr := pTaskBarList.RegisterTab(hwnd, TabWnd.FMainWnd);
              OleCheck(hr);
              hr := pTaskBarList.SetTabOrder(hwnd, 0);
              OleCheck(hr);
            end;

    end;
    WM_DESTROY: begin
      if TabWnd.FManager.FActive and (pTaskBarList <> nil) then
        pTaskBarList.UnregisterTab(hwnd);
    end;
    WM_ACTIVATE: begin
       if LOWORD(wParam) = WA_ACTIVE then
         if Assigned(TabWnd.FManager.FOnActivateTab) then
           TabWnd.FManager.FOnActivateTab(TabWnd.FManager, TabWnd);
    end;
    WM_CLOSE: begin
       if Assigned(TabWnd.FManager.FOnCloseTab) then
         TabWnd.FManager.FOnCloseTab(TabWnd.FManager, TabWnd);
    end;
    WM_SYSCOMMAND: begin
       if (wParam and $FFF0 <> SC_CLOSE) then
         Result := SendMessage(TForm(TabWnd.FManager.Owner).Handle, WM_SYSCOMMAND, wParam, lParam)
       else
         Result := DefWindowProc(hwnd, uMsg, wParam, lParam);
    end;
    WM_DWMSENDICONICTHUMBNAIL:
       TabWnd.SendIconicRepresentation(HIWORD(lParam), LOWORD(lParam));
    WM_DWMSENDICONICLIVEPREVIEWBITMAP:
    begin
      TabWnd.SendLivePreviewBitmap;
    end;
    else
       Result := DefWindowProc(hwnd, uMsg, wParam, lParam);
    end; // case
  end;
end;


function RegisterClass : Atom;
var
  WndClass : TWndClassEx;
begin
  ZeroMemory(@WndClass, SizeOf(WndClass));
  WndClass.cbSize := SizeOf(WndClass);
  WndClass.lpfnWndProc := @TabWndProc;
  WndClass.hInstance := hInstance;
  WndClass.hIcon := Application.Icon.Handle;
  WndClass.lpszClassName := TabWinClassName;
  Result := Windows.RegisterClassEx(WndClass);
end;

{ TfspTaskbarTabMgr }


constructor TfspTaskbarTabMgr.Create(AOwner: TComponent);
begin
  if not (AOwner is TCustomForm) then
    raise  EfspTbrInvalidOwner.Create(SfspTbrInvalidOwner);
  inherited;
  FMainForm := AOwner as TForm;
  FTaskbarTabs := TObjectList.Create(True);
end;

destructor TfspTaskbarTabMgr.Destroy;
begin
  if Assigned(FTaskbarTabs) then
    FTaskbarTabs.Free;
  inherited;
end;

procedure TfspTaskbarTabMgr.SetActive(const Value: Boolean);
var
  i : Integer;
begin
  if FActive <> Value then begin

    if not Assigned(fspDwmSetWindowAttribute) then
      Exit; // Not Windows 7 - no tabs.

    if not (csDesigning in ComponentState) then begin
      if Value then begin
        if Assigned(fspChangeWindowMessageFilter) then begin
          fspChangeWindowMessageFilter (WM_DWMSENDICONICTHUMBNAIL, MSGFLT_ADD);
          fspChangeWindowMessageFilter (WM_DWMSENDICONICLIVEPREVIEWBITMAP, MSGFLT_ADD);
        end;
        FMainWnd := FMainForm.Handle;
        fspTaskbarMainAppWnd := FMainWnd;
        if not Assigned(pTaskBarList) then
          Exit;
        FOrigMainWndProc := Pointer(GetWindowLong(FMainWnd, GWL_WNDPROC));
        SetWindowLong(FMainWnd, GWL_WNDPROC, Integer(MakeObjectInstance(MainWndProc)));
        SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
        SetWindowLong(FMainWnd, GWL_EXSTYLE, GetWindowLong(FMainWnd, GWL_EXSTYLE) or WS_EX_APPWINDOW);
        for i := 0 to FTaskbarTabs.Count - 1 do begin
          OleCheck(pTaskBarList.RegisterTab(TaskbarTabs[i].FTabHWnd, FMainWnd));
          OleCheck(pTaskBarList.SetTabOrder(TaskbarTabs[i].FTabHWnd, 0));
        end;
      end
      else begin
        SetWindowLong(FMainWnd, GWL_WNDPROC, Integer(FOrigMainWndProc));
        SetWindowLong(Application.Handle,GWL_EXSTYLE,GetWindowLong(Application.Handle,GWL_EXSTYLE) and not WS_EX_TOOLWINDOW);
        SetWindowLong(FMainWnd, GWL_EXSTYLE, GetWindowLong(FMainWnd, GWL_EXSTYLE) and not WS_EX_APPWINDOW);
        fspTaskbarMainAppWnd := Application.Handle;
        for i := 0 to FTaskbarTabs.Count - 1 do
          OleCheck(pTaskBarList.UnRegisterTab(TaskbarTabs[i].FTabHWnd));
      end;
    end;
    FActive := Value;
  end;
end;


procedure TfspTaskbarTabMgr.MainWndProc (var Message : TMessage);
begin
  if (Message.Msg = WM_SYSCOMMAND) then begin
    if (Message.wParam and $FFF0) = SC_MINIMIZE then begin
      ShowWindow(TCustomForm(Owner).Handle, SW_SHOWMINIMIZED);
      if Assigned(FOnMinimize) then
        FOnMinimize(self);
      Message.Result := 0;
      Exit;
    end
    else if (Message.wParam and $FFF0) = SC_RESTORE then begin
      ShowWindow(TCustomForm(Owner).Handle, SW_SHOWNORMAL);
      if Assigned(FOnRestore) then
        FOnRestore(self);
      Message.Result := 0;
      Exit;
    end
  end;
  Message.Result := CallWindowProc(FOrigMainWndProc, TCustomForm(Owner).Handle,
                    Message.Msg, Message.wParam, Message.lParam);
end;


function TfspTaskbarTabMgr.AddTab(TabData: Pointer;
  Caption: TCaption): TfspTaskbarTab;
begin
  Result := nil;
  if FTaskbarTabs <> nil then begin
    Result := TfspTaskbarTab.Create(self, TabData, Caption);
    FTaskbarTabs.Add(Result);
  end;
end;

procedure TfspTaskbarTabMgr.RemoveTab(Tab: TfspTaskbarTab);
begin
  if FTaskbarTabs <> nil then
    FTaskbarTabs.Remove(Tab);
end;

function TfspTaskbarTabMgr.GetTaskbarTabIndex(I: Integer): TfspTaskbarTab;
begin
  if FTaskbarTabs <> nil then
    Result := TfspTaskbarTab(FTaskbarTabs[i])
  else
    Result := nil;
end;

function TfspTaskbarTabMgr.GetTabCount: Integer;
begin
  if FTaskbarTabs <> nil then
    Result := FTaskbarTabs.Count
  else
    Result := -1;
end;


procedure TfspTaskbarTabMgr.MoveTab(CurrentIndex, NewIndex: Integer);
var
  InsertBefore : THandle;
begin
  if FTaskbarTabs <> nil then begin
    if NewIndex = CurrentIndex then
      Exit;
    if (CurrentIndex >= 0) and (CurrentIndex < FTaskbarTabs.Count) and
      (NewIndex >= 0) and (NewIndex < FTaskbarTabs.Count) then begin
      if NewIndex < CurrentIndex then
        InsertBefore := TfspTaskbarTab(FTaskbarTabs[NewIndex]).FTabHWnd
      else if NewIndex < FTaskbarTabs.Count - 1 then
        InsertBefore := TfspTaskbarTab(FTaskbarTabs[NewIndex+1]).FTabHWnd
      else
        InsertBefore := 0;
      if FActive and (pTaskBarList <> nil) then
        pTaskBarList.SetTabOrder(TfspTaskbarTab(FTaskbarTabs[CurrentIndex]).FTabHWnd, InsertBefore);
      FTaskbarTabs.Move(CurrentIndex, NewIndex);
    end;
  end;
end;

procedure TfspTaskbarTabMgr.ActivateTab(TabIndex: Integer);
begin
  if FTaskbarTabs <> nil then
    TfspTaskbarTab(FTaskbarTabs[TabIndex]).Activate;
end;

procedure TfspTaskbarTabMgr.InvalidateAllPreviews;
var
  i : Integer;
begin
  if FTaskbarTabs <> nil then
    for i := 0 to TabCount - 1 do 
      TaskbarTabs[i].InvalidatePreview;
end;


{ TfspTaskbarTab }

constructor TfspTaskbarTab.Create(ATabMgr : TfspTaskbarTabMgr; ATabData : Pointer; ACaption : TCaption);
var
  localWnd : THandle;
begin
  FMainWnd := TForm(ATabMgr.Owner).Handle;
  FTabData := ATabData;
  FManager := ATabMgr;
  localWnd := CreateWindowEx(WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE,
            PChar(TabWinClassName),
            PChar(ACaption),
            WS_POPUP or WS_BORDER or WS_SYSMENU or WS_CAPTION,
            -32000,
            -32000,
            10,
            10,
            0,
            0,
            hInstance,
            Pointer(Self));

  if localWnd = 0 then
     raise EfspTbrHelperTabError.CreateFmt(SfspTbrHelperTabError,
                                    [GetLastError()]);

end;

destructor TfspTaskbarTab.Destroy;
begin
  DestroyWindow(FTabHWnd);
  inherited;
end;



function TfspTaskbarTab.SendIconicRepresentation(Width,
  Height: Integer): HRESULT;
var
  hbm : HBITMAP;
begin
  Result := -1;
  hbm := 0;
  if Assigned(FManager.FOnNeedIconicBitmap) then begin
    FManager.FOnNeedIconicBitmap(Fmanager, self, Width, Height, hbm);
    if hbm <> 0 then begin
      if Assigned(fspDwmSetIconicThumbnail) then
        Result := fspDwmSetIconicThumbnail(FTabHWnd, hbm, 0);
      DeleteObject(hbm);
    end;
  end;
end;

function TfspTaskbarTab.SendLivePreviewBitmap: HResult;
var
  hbm : HBITMAP;
  Origin : TPoint;
begin
  Result := -1;
  hbm := 0;
  Origin := Point(0, 0);
  if Assigned(FManager.FOnNeedIconicLivePreview ) then begin
    FManager.FOnNeedIconicLivePreview(Fmanager, self, hbm, Origin);
    if hbm <> 0 then begin
      if Assigned(fspDwmSetIconicLivePreviewBitmap) then
        Result := fspDwmSetIconicLivePreviewBitmap(FTabHWnd, hbm, @Origin, 0);
      DeleteObject(hbm);
    end;
  end;
end;

function TfspTaskbarTab.GetCaption: TCaption;
var
  Caption : Array[0..255] of Char;
begin
  GetWindowText(FTabHWnd, Caption, 255);
  Result := Caption
end;

procedure TfspTaskbarTab.SetCaption(ACaption: TCaption);
begin
  SetWindowText(FTabHWnd, PChar(ACaption));
end;

procedure TfspTaskbarTab.SetThumbTooltip(Tooltip: WideString);
begin
  if FThumbTooltip <> Tooltip then begin
    FThumbTooltip := Tooltip;
    if Assigned(FManager) and FManager.FActive and Assigned(pTaskBarList) then
      pTaskBarList.SetThumbnailTooltip(TabHWnd, PWChar(Tooltip));
  end;
end;

function TfspTaskbarTab.GetIndex : Integer;
begin
  if Assigned(FManager) then
    Result := FManager.FTaskbarTabs.IndexOf(self)
  else
    Result := -1;
end;


procedure TfspTaskbarTab.SetIndex(const NewIndex: Integer);
var
  CurrentIndex : Integer;
begin
  CurrentIndex := GetIndex;
  if CurrentIndex <> NewIndex then
    FManager.MoveTab(CurrentIndex, NewIndex);
end;

procedure TfspTaskbarTab.Activate;
begin
  if FManager.Active and Assigned(pTaskBarList) then
    pTaskBarList.SetTabActive(FTabHWnd, FMainWnd, 0);
end;

procedure TfspTaskbarTab.InvalidatePreview;
begin
  if Assigned(fspDwmInvalidateIconicBitmaps) then
    fspDwmInvalidateIconicBitmaps(FTabHWnd);
end;

function TfspTaskbarTab.GetIconHandle: THandle;
begin
  Result := SendMessage(FTabHWnd, WM_GETICON, ICON_SMALL, 0);
end;

procedure TfspTaskbarTab.SetIconHandle(const Value: THandle);
begin
  SendMessage(FTabHWnd, WM_SETICON, ICON_SMALL, Value);
end;

initialization
  RegisterClass;

finalization

end.
