{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.81               }
{                    Taskbutton previews                }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}


unit fspTaskbarPreviews;

{$I fspWinTaskbar.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TNeedIconicBitmapEvent = procedure(Sender : TObject; Width : Integer; Height : Integer; var Bitmap : HBITMAP) of Object;
  TNeedIconicLivePreviewEvent = procedure(Sender : TObject; var Bitmap : HBITMAP; var Origin : TPoint) of Object;
type
  TfspTaskbarPreviews = class(TComponent)
  private
    FActive: Boolean;
    FWndHandle : THandle;
    FOwnerHandle  : THandle;
    FOrigFormProc : Pointer;
    FOrigAppProc  : Pointer;
    FDualMode     : Boolean;
    FOnNeedIconicBitmap : TNeedIconicBitmapEvent;
    FOnNeedIconicLivePreview : TNeedIconicLivePreviewEvent;
    FCustomLiveView: Boolean;
    procedure SubclassFormProc(var Message : TMessage);
    procedure SubclassAppProc(var Message : TMessage);
    procedure SetActive(const Value: Boolean);
    procedure SetCustomLiveView(const Value: Boolean);
    { Private declarations }
  protected
    { Protected declarations }
    function SendIconicRepresentation(Wnd : THandle; Width : Integer; Height : Integer) : HRESULT; virtual;
    function SendLivePreviewBitmap(Wnd : THandle) : HResult; virtual;
    procedure EnableCustomLiveView(Enable : Boolean); virtual;
  public
    { Public declarations }
    property WndHandle : THandle read FWndHandle;
    constructor Create(AOwner : TComponent); override;
    procedure InvalidatePreview;
  published
    { Published declarations }
    property Active : Boolean read FActive write SetActive;
    property CustomLiveView : Boolean read FCustomLiveView write SetCustomLiveView;
    property OnNeedIconicBitmap : TNeedIconicBitmapEvent read FOnNeedIconicBitmap write FOnNeedIconicBitmap;
    property OnNeedIconicLivePreview : TNeedIconicLivePreviewEvent read FOnNeedIconicLivePreview write FOnNeedIconicLivePreview;
  end;


implementation
uses fspTaskbarApi, fspTaskbarCommon, ComObj;


{ TfspTaskbarPreviews }

constructor TfspTaskbarPreviews.Create(AOwner: TComponent);
begin
  if not (AOwner is TCustomForm) then
    raise  EfspTbrInvalidOwner.Create(SfspTbrInvalidOwner);
  inherited;
  FActive := False;
  FCustomLiveView := False;
  FOrigFormProc := nil;
  FOrigAppProc := nil;
end;


function TfspTaskbarPreviews.SendIconicRepresentation(Wnd : THandle; Width,
  Height: Integer): HRESULT;
var
  hbm : HBITMAP;
begin
  Result := -1;
  if Assigned(FOnNeedIconicBitmap) then begin
    FOnNeedIconicBitmap(Self, Width, Height, hbm);
    if hbm <> 0 then begin
      Result := fspDwmSetIconicThumbnail(Wnd, hbm, 0);
      DeleteObject(hbm);
    end;
  end;
end;

function TfspTaskbarPreviews.SendLivePreviewBitmap(Wnd : THandle): HResult;
var
  hbm : HBITMAP;
  Origin : TPoint;
begin
  Result := -1;
  if Assigned(FOnNeedIconicLivePreview ) then begin
    FOnNeedIconicLivePreview(Self, hbm, Origin);
    if hbm <> 0 then begin
      Result := fspDwmSetIconicLivePreviewBitmap(Wnd, hbm, @Origin, 0);
      DeleteObject(hbm);
    end;
  end;
end;

procedure TfspTaskbarPreviews.SetActive(const Value: Boolean);
var
  EnableAttribute : DWORD;
  hr : HRESULT;
begin
  if FActive <> Value then begin
    if not Assigned(fspDwmSetWindowAttribute) then
      Exit; // Not Windows 7 - no previews.
      
    if not (csDesigning in ComponentState) then begin
      FOwnerHandle := TCustomForm(Owner).Handle;
      if Value then begin
      // Always subclass OnwerForm
        if Assigned(fspChangeWindowMessageFilter) then begin
          fspChangeWindowMessageFilter (WM_DWMSENDICONICTHUMBNAIL, MSGFLT_ADD );
          fspChangeWindowMessageFilter (WM_DWMSENDICONICLIVEPREVIEWBITMAP, MSGFLT_ADD);
        end;
        FOrigFormProc := Pointer(GetWindowLong(FOwnerHandle, GWL_WNDPROC));
        SetWindowLong(FOwnerHandle, GWL_WNDPROC, Integer(MakeObjectInstance(SubclassFormProc)));

        {$IFDEF FSP_VER_2007}
          if fspTaskbarMainAppWnd = 0 then
            if Application.MainFormOnTaskBar then
              fspTaskbarMainAppWnd := FOwnerHandle
            else
              fspTaskbarMainAppWnd := Application.Handle; //Legacy App
        {$ENDIF}

        if ((Application.MainForm = Owner) or  (Application.MainForm = nil)) and
           (Application.Handle = fspTaskbarMainAppWnd) then begin
        //when MainForm is nil, it means that the main form is being created now!
        //common case - main form, no TaskbarMgr. Use Application.Handle instead of Form
          FDualMode := True;
          FWndHandle := fspTaskbarMainAppWnd;
        //  Subclass App.
          FOrigAppProc := Pointer(GetWindowLong(FWndHandle, GWL_WNDPROC));
          SetWindowLong(FWndHandle, GWL_WNDPROC, Integer(MakeObjectInstance(SubclassAppProc)));
        end
        else begin
        // either other form, or TaskbarMgr enabled - use current form handle
          FDualMode := False;
          FWndHandle := FOwnerHandle;
        end;
      end
      else begin
        if FOrigFormProc <> nil then begin
          SetWindowLong(FOwnerHandle, GWL_WNDPROC, Integer(FOrigFormProc));
          FOrigFormProc := nil;
        end;
        if FOrigAppProc <> nil then begin
          SetWindowLong(Application.Handle, GWL_WNDPROC, Integer(FOrigFormProc));
          FOrigAppProc := nil;
        end;
      end;

      EnableAttribute := DWORD(Value);
      hr := fspDwmSetWindowAttribute(
          FWndHandle,
          DWMWA_FORCE_ICONIC_REPRESENTATION,
          @EnableAttribute,
          SizeOf(EnableAttribute));
      OleCheck(hr);

      EnableAttribute := DWORD(Value);
      hr := fspDwmSetWindowAttribute(
          FWndHandle,
          DWMWA_HAS_ICONIC_BITMAP,
          @EnableAttribute,
          SizeOf(EnableAttribute));
      OleCheck(hr);

      if FDualMode then begin
        EnableAttribute := DWORD(Value);
        hr := fspDwmSetWindowAttribute(
            FOwnerHandle,
            DWMWA_FORCE_ICONIC_REPRESENTATION,
            @EnableAttribute,
            SizeOf(EnableAttribute));
        OleCheck(hr);

        EnableAttribute := DWORD(Value);
        hr := fspDwmSetWindowAttribute(
            FOwnerHandle,
            DWMWA_HAS_ICONIC_BITMAP,
            @EnableAttribute,
            SizeOf(EnableAttribute));
        OleCheck(hr);
      end;
    end;
    FActive := Value;
    if FActive then
      EnableCustomLiveView(FCustomLiveView);
  end;
end;

procedure TfspTaskbarPreviews.SetCustomLiveView(const Value: Boolean);
begin
  if FCustomLiveView <> Value then begin
    FCustomLiveView := Value;
    if FActive then
      EnableCustomLiveView(FCustomLiveView);
  end;
end;

procedure TfspTaskbarPreviews.EnableCustomLiveView(Enable: Boolean);
var
  EnableAttribute : DWORD;
  hr : HRESULT;
begin
  if not (csDesigning in ComponentState) then begin
    EnableAttribute := DWORD(not Enable);
    hr := fspDwmSetWindowAttribute(
        FWndHandle,
        DWMWA_DISALLOW_PEEK,
        @EnableAttribute,
        SizeOf(EnableAttribute));
    OleCheck(hr);
    if FDualMode then begin
      EnableAttribute := DWORD(not Enable);
      hr := fspDwmSetWindowAttribute(
          FOwnerHandle,
          DWMWA_DISALLOW_PEEK,
          @EnableAttribute,
          SizeOf(EnableAttribute));
      OleCheck(hr);
    end;
  end;
end;


procedure TfspTaskbarPreviews.SubclassFormProc(var Message: TMessage);
begin
  Message.Result := 1;
  case Message.Msg of
     WM_DWMSENDICONICTHUMBNAIL:
     begin
       if FDualMode then
         Exit;
       if SendIconicRepresentation(FOwnerHandle, HIWORD(Message.lParam), LOWORD(Message.lParam)) = 0 then
         Message.Result := 0;
     end;
     WM_DWMSENDICONICLIVEPREVIEWBITMAP:
       if SendLivePreviewBitmap(FOwnerHandle) = 0 then
         Message.Result := 0;
  else
    Message.Result := CallWindowProc(FOrigFormProc, FOwnerHandle,
                      Message.Msg, Message.wParam, Message.lParam);
  end;

end;

procedure TfspTaskbarPreviews.SubclassAppProc(var Message: TMessage);
begin
  Message.Result := 1;
  case Message.Msg of
    WM_DWMSENDICONICTHUMBNAIL:
     if SendIconicRepresentation(Application.Handle, HIWORD(Message.lParam), LOWORD(Message.lParam)) = 0 then
       Message.Result := 0;
     WM_DWMSENDICONICLIVEPREVIEWBITMAP: //may flicker in legacy (FDual) mode.
       Exit;
  else
    Message.Result := CallWindowProc(FOrigAppProc, Application.Handle,
                      Message.Msg, Message.wParam, Message.lParam);
  end;
end;

procedure TfspTaskbarPreviews.InvalidatePreview;
begin
  if Assigned(fspDwmInvalidateIconicBitmaps) then
    fspDwmInvalidateIconicBitmaps(FWndHandle);
end;

end.
