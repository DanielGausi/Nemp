{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                    Taskbar manager  unit              }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}

unit fspTaskbarMgr;

{$I fspWinTaskbar.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  imglist, Forms, ShlObj, fspTaskbarApi, System.UITypes;

type
 TfspTaskProgressState = (fstpsNoProgress, fstpsIndeterminate, fstpsNormal,
                         fstpsError, fstpsPaused);
 TfspTaskThumbFlag = (fsttfDisable, fsttfDismissionClick, fsttfNoBackground,
                         fsttfHidden, fsttfNonInteractive);
 TfspTaskThumbFlags = set of TfspTaskThumbFlag;

type
  EfspTbrInvalidThumbButton = class(Exception);

resourcestring
  SfspTbrNumOfThumbsExceeded = 'Maximum thumb buttons exceeded';
  SfspTbrThumbsCreated = 'You cannot add or remove thumb buttons after creation';
  SfspTbrThumbsAlreadyCreated = 'Thumb buttons already created';

type
  TThumbButtonEvent = procedure(Sender : TObject; ButtonId : Integer) of Object;

type
  TfspTaskbarMgr = class;

  TfspTaskbarThumbButton = class (TCollectionItem)
  private
    FImageIndex : TImageIndex;
    FId : Integer;
    FFlags : TfspTaskThumbFlags;
    FHint  : WideString;
    FShowHint : Boolean;
    FIcon     : TIcon;
    procedure SetId(const Value: Integer);
    procedure SetImageIndex(const Value: TImageIndex);
    procedure SetIcon(const Value: TIcon);
    procedure SetFlags(const Value: TfspTaskThumbFlags);
    procedure SetHint(const Value: WideString);
    procedure SetShowHint(const Value: Boolean);
  protected
    function GetDisplayName: string; override;
    procedure SetIndex(Value: Integer); override;
  public
    constructor Create(AOwner:TCollection);override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property ImageIndex : TImageIndex read FImageIndex write SetImageIndex;
    property Id : Integer read FId write SetId;
    property Hint : WideString read FHint write SetHint;
    property ShowHint : Boolean read FShowHint write SetShowHint;
    property Flags : TfspTaskThumbFlags read FFlags write SetFlags;
    property Icon : TIcon read FIcon write SetIcon;
  end;

  TfspTaskbarThumbButtonCollection = class(TCollection)
  private
    FTaskbarMgr: TfspTaskbarMgr;
    function GetThumbButton(Index: Integer): TfspTaskbarThumbButton;
    procedure SetThumbButton(Index: Integer; Value: TfspTaskbarThumbButton);
    procedure CreateThumbButtons;
    function PrepareThumbs(var Thumbs: array of TThumbButton) : Integer;
  protected
    function GetOwner: TPersistent; override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(TaskbarMgr: TfspTaskbarMgr);
    function  Add: TfspTaskbarThumbButton;
    procedure Delete(Index : Integer);
    procedure Clear;
    function Insert(Index: Integer): TfspTaskbarThumbButton;
    property Items[Index: Integer]: TfspTaskbarThumbButton read GetThumbButton write SetThumbButton; default;
  end;

  TfspTaskbarMgr = class(TComponent)
  private
    FActive : Boolean;
    FProgressValue: Integer;
    FProgressValueMax: Integer;
    FProgressState: TfspTaskProgressState;
    FOverlayIcon: TIcon;
    FThumbsImages : TCustomImageList;
    FThumbButtons : TfspTaskbarThumbButtonCollection;
    FThumbButtonsCreated : Boolean;
    FOnThumbButtonClick: TThumbButtonEvent;
    FOrigMainWndProc : Pointer;
    procedure SetProgressValue(const Value: Integer);
    procedure SetProgressValueMax(const Value: Integer);
    procedure SetProgressState(const Value: TfspTaskProgressState);
    procedure SetOverlayIcon(const Value: TIcon);
    function GetAppId: String;
    procedure SetAppId(const Value: String);
    procedure SetThumbButtons(
      const Value: TfspTaskbarThumbButtonCollection);
    procedure MainWndProc(var Message: TMessage);
    procedure SetActive(const Value: Boolean);
  protected
    { Protected declarations }
  public
    property AppId : String read GetAppId write SetAppId; //no reason to make it published
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure CreateOverlayIcon(Icon : HICON; IconDescription : PWChar);
    procedure ThumbsBeginUpdate;
    procedure ThumbsEndUpdate;
  published
    property Active : Boolean read FActive write SetActive;
    property ProgressValue : Integer read FProgressValue write SetProgressValue;
    property ProgressValueMax : Integer read FProgressValueMax write SetProgressValueMax;
    property ProgressState : TfspTaskProgressState read FProgressState write SetProgressState;
    property OverlayIcon : TIcon read FOverlayIcon write SetOverlayIcon;
    property Images : TCustomImageList read FThumbsImages write FThumbsImages;
    property ThumbButtons : TfspTaskbarThumbButtonCollection read FThumbButtons write SetThumbButtons;
    property OnThumbButtonClick : TThumbButtonEvent read FOnThumbButtonClick write FOnThumbButtonClick;
  end;

implementation
uses fspTaskbarCommon, ComObj, ActiveX;

const
  MaxThumbButtons = 7;


function Tps2Tbpf(State : TfspTaskProgressState) : Integer;
begin
  case State of
    fstpsNoProgress    : Result := TBPF_NOPROGRESS;
    fstpsIndeterminate : Result := TBPF_INDETERMINATE;
    fstpsNormal        : Result := TBPF_NORMAL;
    fstpsError         : Result := TBPF_ERROR;
    fstpsPaused        : Result := TBPF_PAUSED;
  else
    Result := -1;
  end;
end;

{ TfspTaskbarMgr }

constructor TfspTaskbarMgr.Create(AOwner: TComponent);
begin
  inherited;
  FProgressValue := 0;
  FProgressValueMax := 100;
  FOverlayIcon := TIcon.Create;
  FThumbButtons := TfspTaskbarThumbButtonCollection.Create(self);
  FThumbButtonsCreated := False;
end;


destructor TfspTaskbarMgr.Destroy;
begin
  FThumbButtons.Free;
  FOverlayIcon.Free;
  inherited;
end;

procedure TfspTaskbarMgr.CreateOverlayIcon(Icon : HICON; IconDescription : PWChar);
begin
  if Assigned(pTaskBarList) then
    pTaskBarList.SetOverlayIcon(fspTaskbarMainAppWnd, Icon, IconDescription);
end;

procedure TfspTaskbarMgr.SetOverlayIcon(const Value: TIcon);
begin
  FOverlayIcon.Assign(Value);
  if Value <> nil then begin
    if FActive then
      CreateOverlayIcon(Value.Handle, nil);
  end
  else
    CreateOverlayIcon(0, nil);
end;

procedure TfspTaskbarMgr.SetProgressState(
  const Value: TfspTaskProgressState);
var
  State : Integer;
begin
  FProgressState := Value;
  State := Tps2Tbpf(FProgressState);
  if FActive and Assigned(pTaskBarList) then
    pTaskBarList.SetProgressState(fspTaskbarMainAppWnd, State);
end;

procedure TfspTaskbarMgr.SetProgressValue(const Value: Integer);
begin
  FProgressValue := Value;
  if FActive and Assigned(pTaskBarList) then
    pTaskBarList.SetProgressValue(fspTaskbarMainAppWnd, FProgressValue, FProgressValueMax);
end;

procedure TfspTaskbarMgr.SetProgressValueMax(const Value: Integer);
begin
  FProgressValueMax := Value;
  if FActive and Assigned(pTaskBarList) then
    pTaskBarList.SetProgressValue(fspTaskbarMainAppWnd, FProgressValue, FProgressValueMax);
end;

function TfspTaskbarMgr.GetAppId: String;
var
  AppID : PWChar;
begin
  Result := '';
  if Assigned(fspGetCurrentProcessExplicitAppUserModelID) then
    if fspGetCurrentProcessExplicitAppUserModelID(AppID) = 0 then begin
      Result := WideCharToString(AppID);
      CoTaskMemFree(AppID);
    end;
end;

procedure TfspTaskbarMgr.SetActive(const Value: Boolean);
var
  PrgState : Integer;
begin
  if FActive <> Value then begin
    if not (csDesigning in ComponentState) then begin
      if not Assigned(pTaskBarList) then
        Exit;
      {$IFDEF FSP_VER_2007}
        if fspTaskbarMainAppWnd = 0 then
          if Application.MainFormOnTaskBar then
            fspTaskbarMainAppWnd := TCustomForm(Owner).Handle
          else
            fspTaskbarMainAppWnd := Application.Handle; //Legacy App
      {$ENDIF}
      if Value then begin
        if not FThumbButtonsCreated then begin
          FOrigMainWndProc := Pointer(GetWindowLong(fspTaskbarMainAppWnd, GWL_WNDPROC));
          SetWindowLong(fspTaskbarMainAppWnd, GWL_WNDPROC, Integer(MakeObjectInstance(MainWndProc)));
          if Assigned(fspChangeWindowMessageFilter) then begin
            fspChangeWindowMessageFilter (WM_COMMAND, MSGFLT_ADD);
          end;
          FThumbButtons.CreateThumbButtons;
          FThumbButtonsCreated  := True;
        end;
        if FProgressState <> fstpsNoProgress then begin
          PrgState := Tps2Tbpf(FProgressState);
          pTaskBarList.SetProgressState(fspTaskbarMainAppWnd, PrgState);
          if (FProgressValue <> 0) and (FProgressState <> fstpsIndeterminate) then
            pTaskBarList.SetProgressValue(fspTaskbarMainAppWnd, FProgressValue, FProgressValueMax);
        end;
        if not FOverlayIcon.Empty then
          CreateOverlayIcon(FOverlayIcon.Handle, nil);
      end
      else begin //Active = False
        if not FOverlayIcon.Empty then
          CreateOverlayIcon(0, nil);
        if (FProgressState <> fstpsNoProgress) or (FProgressValue <> 0) then
          pTaskBarList.SetProgressState(fspTaskbarMainAppWnd, TBPF_NOPROGRESS);
      end;
    end;
    FActive := Value;
  end;
end;

procedure TfspTaskbarMgr.SetAppId(const Value: String);
begin
  if Assigned(fspSetCurrentProcessExplicitAppUserModelID) then
   fspSetCurrentProcessExplicitAppUserModelID(PWChar(WideString(Value)));
end;

procedure TfspTaskbarMgr.SetThumbButtons(
  const Value: TfspTaskbarThumbButtonCollection);
begin
  FThumbButtons.Assign(Value);
end;


procedure TfspTaskbarMgr.MainWndProc (var Message : TMessage);
begin
  if (Message.Msg = WM_COMMAND) then begin
    if HIWORD(Message.WParam) = THBN_CLICKED then
       if Assigned(FOnThumbButtonClick) then
         FOnThumbButtonClick(self, LOWORD(Message.WParam));
  end;
  Message.Result := CallWindowProc(FOrigMainWndProc, fspTaskbarMainAppWnd,
                    Message.Msg, Message.wParam, Message.lParam);
end;


procedure TfspTaskbarMgr.ThumbsBeginUpdate;
begin
  FThumbButtons.BeginUpdate;
end;

procedure TfspTaskbarMgr.ThumbsEndUpdate;
begin
  FThumbButtons.EndUpdate;
end;

{ TfspTaskbarThumbButton }

constructor TfspTaskbarThumbButton.Create(AOwner: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FId := -1;
  FHint := '';
  FShowHint := False;
  FIcon := TIcon.Create;
end;

destructor TfspTaskbarThumbButton.Destroy;
begin
  inherited;
  FIcon.Free;
end;


procedure TfspTaskbarThumbButton.Assign(Source: TPersistent);
begin
  if Source is TfspTaskbarThumbButton then begin
    ImageIndex := TfspTaskbarThumbButton(Source).ImageIndex;
    Id := TfspTaskbarThumbButton(Source).Id;
    Hint := TfspTaskbarThumbButton(Source).Hint;
    ShowHint := TfspTaskbarThumbButton(Source).ShowHint;
    Flags := TfspTaskbarThumbButton(Source).Flags;
    Icon.Assign(TfspTaskbarThumbButton(Source).Icon);
  end
  else
    inherited Assign(Source);
end;


function TfspTaskbarThumbButton.GetDisplayName: string;
begin
  Result := 'ThumbButton' + IntToStr(Index);
end;

procedure TfspTaskbarThumbButton.SetId(const Value: Integer);
begin
  FId := Value;
  Changed(True);
end;

procedure TfspTaskbarThumbButton.SetImageIndex(const Value: TImageIndex);
begin
  FImageIndex := Value;
  Changed(True);
end;

procedure TfspTaskbarThumbButton.SetIndex(Value: Integer);
begin
  inherited;
end;

procedure TfspTaskbarThumbButton.SetIcon(const Value: TIcon);
begin
  FIcon.Assign(Value);
  Changed(True);
end;

procedure TfspTaskbarThumbButton.SetFlags(const Value: TfspTaskThumbFlags);
begin
  FFlags := Value;
  Changed(True);
end;

procedure TfspTaskbarThumbButton.SetHint(const Value: WideString);
begin
  FHint := Value;
  Changed(True);
end;

procedure TfspTaskbarThumbButton.SetShowHint(const Value: Boolean);
begin
  FShowHint := Value;
  Changed(True);
end;

{ TfspTaskbarThumbButtonCollection }

constructor TfspTaskbarThumbButtonCollection.Create(TaskbarMgr: TfspTaskbarMgr);
begin
  inherited Create(TfspTaskbarThumbButton);
  FTaskbarMgr := TaskbarMgr;
end;

function TfspTaskbarThumbButtonCollection.Add: TfspTaskbarThumbButton;
begin
  if FTaskbarMgr.FThumbButtonsCreated then
    raise EfspTbrInvalidThumbButton.Create(SfspTbrThumbsCreated);
  if Count < MaxThumbButtons then
    Result := TfspTaskbarThumbButton(inherited Add)
  else
    raise EfspTbrInvalidThumbButton.Create(SfspTbrNumOfThumbsExceeded);
end;

procedure TfspTaskbarThumbButtonCollection.Delete(Index: Integer);
begin
  if FTaskbarMgr.FThumbButtonsCreated then
    raise EfspTbrInvalidThumbButton.Create(SfspTbrThumbsCreated);
  inherited;
end;

procedure TfspTaskbarThumbButtonCollection.Clear;
begin
  if FTaskbarMgr.FThumbButtonsCreated then
    raise EfspTbrInvalidThumbButton.Create(SfspTbrThumbsCreated);
  inherited;
end;

function TfspTaskbarThumbButtonCollection.Insert(
  Index: Integer): TfspTaskbarThumbButton;
begin
  Result := Add;
  Result.Index := Index;
end;

function TfspTaskbarThumbButtonCollection.GetOwner: TPersistent;
begin
  Result := FTaskbarMgr;
end;

function TfspTaskbarThumbButtonCollection.GetThumbButton(
  Index: Integer): TfspTaskbarThumbButton;
begin
  Result := TfspTaskbarThumbButton(inherited Items[Index]);
end;

procedure TfspTaskbarThumbButtonCollection.SetThumbButton(Index: Integer;
  Value: TfspTaskbarThumbButton);
begin
  Items[Index].Assign(Value);
end;

function TfspTaskbarThumbButtonCollection.PrepareThumbs(var Thumbs: Array of TThumbButton) : Integer;
var
  BtnCount : Integer;
  i : Integer;
begin
  BtnCount := Count;
  if BtnCount > MaxThumbButtons then
    BtnCount := MaxThumbButtons;
  for i := 0 to BtnCount - 1 do begin
    Thumbs[i].dwMask := THB_FLAGS;
    if (Items[i].ImageIndex >= 0) and Assigned(FTaskbarMgr.Images) then
      Thumbs[i].dwMask := Thumbs[i].dwMask + THB_BITMAP;
    if not Items[i].FIcon.Empty then
      Thumbs[i].dwMask := Thumbs[i].dwMask + THB_ICON;
    if Items[i].FShowHint then
      Thumbs[i].dwMask := Thumbs[i].dwMask + THB_TOOLTIP;

    Thumbs[i].iId := Items[i].FId;
    Thumbs[i].iBitmap := Items[i].FImageIndex;
    Thumbs[i].hIcon := Items[i].FIcon.Handle;
    lstrcpynW(Thumbs[i].szTip, PWChar(Items[i].FHint), 260);
    Thumbs[i].dwFlags := 0;
    if fsttfDisable in Items[i].FFlags then
      Thumbs[i].dwFlags := Thumbs[i].dwFlags + THBF_DISABLED;
    if fsttfDismissionClick in Items[i].FFlags then
      Thumbs[i].dwFlags := Thumbs[i].dwFlags + THBF_DISMISSONCLICK;
    if fsttfNoBackground in Items[i].FFlags then
      Thumbs[i].dwFlags := Thumbs[i].dwFlags + THBF_NOBACKGROUND;
    if fsttfHidden in Items[i].FFlags then
      Thumbs[i].dwFlags := Thumbs[i].dwFlags + THBF_HIDDEN;
    if fsttfNonInteractive in Items[i].FFlags then
      Thumbs[i].dwFlags := Thumbs[i].dwFlags + THBF_NONINTERACTIVE;
  end;
  Result := BtnCount;
end;

procedure TfspTaskbarThumbButtonCollection.CreateThumbButtons;
var
  Thumbs : Array[0..MaxThumbButtons-1] of TThumbButton;
  BtnCount : Integer;
begin
  if not Assigned(pTaskBarList) then
    Exit;
  BtnCount := PrepareThumbs(Thumbs);
  if BtnCount = 0 then
    Exit;
  if Assigned(FTaskbarMgr.Images) then
    OleCheck(pTaskBarList.ThumbBarSetImageList(fspTaskbarMainAppWnd, FTaskbarMgr.Images.Handle));
  OleCheck(pTaskBarList.ThumbBarAddButtons(fspTaskbarMainAppWnd, BtnCount, @Thumbs[0]));
end;

procedure TfspTaskbarThumbButtonCollection.Update(Item: TCollectionItem);
var
  Thumbs : Array[0..MaxThumbButtons-1] of TThumbButton;
  BtnCount : Integer;
begin
  if not FTaskbarMgr.FThumbButtonsCreated then
    Exit;
  if not Assigned(pTaskBarList) then
    Exit;
  BtnCount := PrepareThumbs(Thumbs);
  if BtnCount > 0 then
    OleCheck(pTaskBarList.ThumbBarUpdateButtons(fspTaskbarMainAppWnd, BtnCount, @Thumbs[0]));
end;

end.
