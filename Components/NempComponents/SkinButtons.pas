

{
  TSkinButton
  -----------
  - Reworked for Nemp Version 5.3
  - Derived directly from TCustomButton, not from TBitBtn.
  - The code contains some parts of the TBitBtn code, mainly
    the method DrawWindowsBackground()

}


unit SkinButtons;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Vcl.StdCtrls, Vcl.ImgList, System.UITypes, Winapi.CommCtrl, VCL.Themes;

const
  cRatingStarCount = 5;

type
  TRatingButton = class;

  TDrawButtonEvent = procedure(Control: TWinControl;
    aRect: TRect; State: TOwnerDrawState) of object;

  TChangeRatingEvent = procedure(Sender: TRatingButton; aRating: Integer) of object;

  TDrawMode = (dm_Windows, dm_Skin);

  TCustomSkinButton = class(TCustomButton)
  private
    FDrawMode: TDrawMode;
    FCanvas: TCanvas;
    FIsDown: Boolean;
    FIsDefault: Boolean;
    IsFocused: Boolean;
    FMouseInControl: Boolean;

    fTransparentBackground: Boolean;
    FOverlayImageIndex: TImageIndex;
    FOverlayImageName: TImageName;

    FStarFullImageIndex: TImageIndex;
    FStarHalfImageIndex: TImageIndex;
    FStarEmptyImageIndex: TImageIndex;
    FStarFullImageName: TImageName;
    FStarHalfImageName: TImageName;
    FStarEmptyImageName: TImageName;


    FBackgroundImages: TCustomImageList;
    FBackgroundImageChangeLink: TChangeLink;

    procedure BackgroundImageListChange(Sender: TObject);

    procedure PreparePainting(const DrawItemStruct: TDrawItemStruct);
    procedure FinishPainting;
    procedure DrawWindowsBackground(const DrawItemStruct: TDrawItemStruct);
    procedure DrawSkinBackground(const DrawItemStruct: TDrawItemStruct);


    procedure DrawImage(aCanvas: TCanvas);
    procedure DrawOverlayImage(aCanvas: TCanvas);
    procedure DrawButtonFocusRect(aCanvas: TCanvas);
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);

    procedure SetDrawMode(Value: TDrawMode);
    procedure UpdateImageName(Index: TImageIndex; var Name: TImageName);
    procedure UpdateImageIndex(Name: TImageName; var Index: TImageIndex);
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure SetBackgroundImages(const Value: TCustomImageList);
    procedure SetOverlayImageIndex(const Value: TImageIndex);
    procedure SetOverlayImageName(const Value: TImageName);
    procedure SetTransparentBackground(const Value: Boolean);
    procedure SetStarEmptyImageIndex(const Value: TImageIndex);
    procedure SetStarEmptyImageName(const Value: TImageName);
    procedure SetStarFullImageIndex(const Value: TImageIndex);
    procedure SetStarFullImageName(const Value: TImageName);
    procedure SetStarHalfImageIndex(const Value: TImageIndex);
    procedure SetStarHalfImageName(const Value: TImageName);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateStyleElements; override;
    procedure UpdateImageList; override;
    procedure UpdateImages; override;
    procedure UpdateImage; override;
    procedure SetImageList(AHandle: HIMAGELIST); override;
    procedure SetButtonStyle(ADefault: Boolean); override;

    procedure DrawBackground(const DrawItemStruct: TDrawItemStruct); virtual;
    procedure DrawContent(aCanvas: TCanvas); virtual;

    property OverlayImageIndex: TImageIndex read FOverlayImageIndex write SetOverlayImageIndex default -1;
    property OverlayImageName: TImageName read FOverlayImageName write SetOverlayImageName;

    property StarFullImageIndex : TImageIndex read FStarFullImageIndex  write SetStarFullImageIndex  default -1;
    property StarHalfImageIndex : TImageIndex read FStarHalfImageIndex  write SetStarHalfImageIndex  default -1;
    property StarEmptyImageIndex: TImageIndex read FStarEmptyImageIndex write SetStarEmptyImageIndex default -1;
    property StarFullImageName  : TImageName  read FStarFullImageName   write SetStarFullImageName   ;
    property StarHalfImageName  : TImageName  read FStarHalfImageName   write SetStarHalfImageName   ;
    property StarEmptyImageName : TImageName  read FStarEmptyImageName  write SetStarEmptyImageName  ;


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    //property Caption;
    property Constraints;
    //property DisabledImageIndex;
    //property DisabledImageName;
    property DoubleBuffered default True;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawMode: TDrawMode read FDrawMode write SetDrawMode;
    property Enabled;
    property Font;
    //property HotImageIndex;
    //property HotImageName;
    //property ImageIndex;
    //property ImageName;
    property Images;
    property BackgroundImages: TCustomImageList read FBackgroundImages write SetBackgroundImages;
    property ParentBiDiMode;
    property ParentDoubleBuffered default False;
    property ParentFont;
    property ParentShowHint;
    //property PressedImageIndex;
    //property PressedImageName;
    property PopupMenu;
    property ShowHint;
    //property SelectedImageIndex;
    //property SelectedImageName;
    property TabOrder;
    property TabStop;
    property TransparentBackground: Boolean read fTransparentBackground write SetTransparentBackground default false;
    property Visible;
    property WordWrap;
    property StyleElements;
    property StyleName;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSkinButton = class(TCustomSkinButton)
  strict private
    class constructor Create;
    class destructor Destroy;
  published
    property Caption;

    property DisabledImageIndex;
    property DisabledImageName;

    property OverlayImageIndex;
    property OverlayImageName;
    property HotImageIndex;
    property HotImageName;
    property ImageIndex;
    property ImageName;

    property PressedImageIndex;
    property PressedImageName;

    property SelectedImageIndex;
    property SelectedImageName;
  end;

  TRatingButton = class(TCustomSkinButton)
  private
    fRating: Byte;
    fTmpRating: Byte;
    FOnRatingChanged: TChangeRatingEvent;
    fAllowChangeRating: Boolean;
    fCustomBackground: TBitmap;
    FAlignment: TAlignment;
    fWantArrowButtons: Boolean;

    function XToRating(X: Integer): Integer;
    procedure DrawRating(aCanvas: TCanvas);
    procedure SetRating(const Value: Byte);

    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMWantSpecialKey(var Msg: TWMKey); message CM_WANTSPECIALKEY;

    procedure SetCustomBackground(const Value: TBitmap);
    procedure SetAlignment(const Value: TAlignment);
    function GetRatingWidth: Integer;
    function GetRatingDrawOffset: Integer;
  protected
    property RatingWidth: Integer read GetRatingWidth;
    property RatingDrawOffset: Integer read GetRatingDrawOffset;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure DrawBackground(const DrawItemStruct: TDrawItemStruct); override;
    procedure DrawContent(aCanvas: TCanvas); override;
  public
    property CustomBackground: TBitmap read fCustomBackground write SetCustomBackground;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taCenter;

    property Rating: Byte read fRating write SetRating;
    property WantArrowButtons: Boolean read fWantArrowButtons write fWantArrowButtons default False;
    property AllowChangeRating: Boolean read fAllowChangeRating write fAllowChangeRating;
    property OnRatingChanged: TChangeRatingEvent read FOnRatingChanged write FOnRatingChanged;

    property StarFullImageIndex;
    property StarHalfImageIndex;
    property StarEmptyImageIndex;
    property StarFullImageName;
    property StarHalfImageName;
    property StarEmptyImageName;
  end;

  {
    TRatingPainter:
      Draw a rating like in TRatingButton on a Canvas (e.g. in the Rating-Column in the main VST, or in VST Hints)
  }
  TRatingPainter = class
    private
      fImages: TCustomImageList;
      fStarFullIdx: Integer;
      fStarHalfIdx: Integer;
      fStarEmptyIdx: Integer;
      fCountIconIdx: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;

    public
      property Images: TCustomImageList read fImages write fImages;
      property StarFullIdx : Integer read fStarFullIdx  write fStarFullIdx ;
      property StarHalfIdx : Integer read fStarHalfIdx  write fStarHalfIdx ;
      property StarEmptyIdx: Integer read fStarEmptyIdx write fStarEmptyIdx;
      property CountIconIdx: Integer read fCountIconIdx write fCountIconIdx;
      property Width: Integer read GetWidth;
      property Height: Integer read GetHeight;

      constructor Create;
      procedure PaintRating(aRating: Integer; aCanvas: TCanvas; x, y: Integer; Enabled: Boolean = True);
      procedure PaintCountIcon(aCanvas: TCanvas; x, y: Integer; Enabled: Boolean = True);
  end;

  TSkinBtnStyleHook = class(TButtonStyleHook)
  strict protected
    procedure DrawButton(ACanvas: TCanvas; AMouseInControl: Boolean); override;
  end;

  //procedure PaintRating(aRating: Integer;
  //    aCanvas: TCanvas; x, y: Integer; Enabled: Boolean;
  //    Images: TCustomImageList;
  //    StarFullIdx, StarHalfIdx, StarEmptyIdx: Integer);

  procedure Register;


implementation


procedure Register;
begin
  RegisterComponents('Nemp Components', [TSkinButton]);
  RegisterComponents('Nemp Components', [TRatingButton]);
end;

procedure InternalPaintRating(aRating: Integer;
      aCanvas: TCanvas; x, y: Integer; Enabled: Boolean;
      Images: TCustomImageList;
      StarFullIdx, StarHalfIdx, StarEmptyIdx: Integer);
var
  i, p, imgIdx: Integer;
     iX: Integer;
begin

  imgIdx := StarFullIdx;
  for i := 1 to (aRating div 51) do begin
    Images.Draw(aCanvas,
      X + Images.Width*(i-1),
      Y,
      imgIdx,
      Enabled);
  end;

  p := aRating Div 51 + 1;
  if (p <= 5) then begin
    // if <= 25: Draw only a half star, otherwise another full star
    if ((aRating mod 51) <= 25) then
      imgIdx := StarHalfIdx;

    Images.Draw(aCanvas,
          X + Images.Width*(p-1),
          Y,
          imgIdx,
          Enabled);
      inc(p);

    imgIdx := StarEmptyIdx;
    for i := p to 5 do begin
      iX := X + Images.Width*(i-1);

      Images.Draw(aCanvas,
        iX,
        Y,
        imgIdx,
        Enabled);
    end;
  end;
end;



class constructor TSkinButton.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TSkinButton, TSkinBtnStyleHook);
end;

class destructor TSkinButton.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TSkinButton, TSkinBtnStyleHook);
end;

{ TCustomSkinButton }

constructor TCustomSkinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOverlayImageIndex := -1;
  FStarFullImageIndex := -1;
  FStarHalfImageIndex := -1;
  FStarEmptyImageIndex := -1;


  FBackgroundImageChangeLink := TChangeLink.Create;
  FBackgroundImageChangeLink.OnChange := BackgroundImageListChange;
  FCanvas := TCanvas.Create;
  ControlStyle := ControlStyle + [csReflector, csPaintBlackOpaqueOnGlass];
  DoubleBuffered := True;
  fTransparentBackground := False;
end;

procedure TCustomSkinButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

destructor TCustomSkinButton.Destroy;
begin
  FreeAndNil(FBackgroundImageChangeLink);
  FCanvas.Free;
  inherited;
end;

procedure TCustomSkinButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomSkinButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if StyleServices.Enabled and not FMouseInControl and not (csDesigning in ComponentState) then begin
    FMouseInControl := True;
    Repaint;
  end;
end;

procedure TCustomSkinButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if StyleServices.Enabled and FMouseInControl then begin
    FMouseInControl := False;
    Repaint;
  end;
end;

procedure TCustomSkinButton.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
  Message.Result := 1;
end;

procedure TCustomSkinButton.CNMeasureItem(var Message: TWMMeasureItem);
var
  Temp: PMeasureItemStruct;
begin
  Temp := Message.MeasureItemStruct;
  with Temp^ do begin
    itemWidth := Width;
    itemHeight := Height;
  end;
end;

procedure TCustomSkinButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, LPARAM(Word(Message.XPos) or (Word(Message.YPos) shl 16)));
end;

procedure TCustomSkinButton.BackgroundImageListChange(Sender: TObject);
begin
  if HandleAllocated then
    UpdateImage;
end;

procedure TCustomSkinButton.SetBackgroundImages(const Value: TCustomImageList);
begin
  if Value <> FBackgroundImages then
  begin
    if BackgroundImages <> nil then
    begin
      BackgroundImages.RemoveFreeNotification(Self);
      BackgroundImages.UnRegisterChanges(FBackgroundImageChangeLink);
    end;
    fBackgroundImages := Value;
    if BackgroundImages <> nil then
    begin
      BackgroundImages.RegisterChanges(FBackgroundImageChangeLink);
      BackgroundImages.FreeNotification(Self);
    end;
    UpdateImageList;
    UpdateImage;
  end;
end;

procedure TCustomSkinButton.SetDrawMode(Value: TDrawMode);
begin
  if Value <> FDrawMode then begin
    FDrawMode := Value;
    if DrawMode = dm_Skin then
      StyleElements := [seFont, seBorder]
    else
      StyleElements := [seFont, seClient, seBorder];
    Invalidate;
  end;
end;

procedure TCustomSkinButton.SetButtonStyle(ADefault: Boolean);
begin
  if ADefault <> IsFocused then begin
    IsFocused := ADefault;
    Refresh;
  end;
end;

procedure TCustomSkinButton.SetImageList(AHandle: HIMAGELIST);
begin
  // do nothing
end;

procedure TCustomSkinButton.SetOverlayImageIndex(const Value: TImageIndex);
begin
  if FOverlayImageIndex <> Value then begin
    FOverlayImageIndex := Value;
    UpdateImageName(Value, FOverlayImageName);
  end;
end;

procedure TCustomSkinButton.SetOverlayImageName(const Value: TImageName);
begin
  if Value <> FOverlayImageName then begin
    FOverlayImageName := Value;
    UpdateImageIndex(Value, FOverlayImageIndex);
  end;
end;

procedure TCustomSkinButton.SetStarEmptyImageIndex(const Value: TImageIndex);
begin
  if FStarEmptyImageIndex <> Value then begin
    FStarEmptyImageIndex := Value;
    UpdateImageName(Value, FStarEmptyImageName);
  end;
end;

procedure TCustomSkinButton.SetStarEmptyImageName(const Value: TImageName);
begin
  if Value <> FStarEmptyImageName then begin
    FStarEmptyImageName := Value;
    UpdateImageIndex(Value, FStarEmptyImageIndex);
  end;
end;

procedure TCustomSkinButton.SetStarFullImageIndex(const Value: TImageIndex);
begin
  if FStarFullImageIndex <> Value then begin
    FStarFullImageIndex := Value;
    UpdateImageName(Value, FStarFullImageName);
  end;
end;

procedure TCustomSkinButton.SetStarFullImageName(const Value: TImageName);
begin
  if Value <> FStarFullImageName then begin
    FStarFullImageName := Value;
    UpdateImageIndex(Value, FStarFullImageIndex);
  end;
end;

procedure TCustomSkinButton.SetStarHalfImageIndex(const Value: TImageIndex);
begin
  if FStarHalfImageIndex <> Value then begin
    FStarHalfImageIndex := Value;
    UpdateImageName(Value, FStarHalfImageName);
  end;
end;

procedure TCustomSkinButton.SetStarHalfImageName(const Value: TImageName);
begin
  if Value <> FStarHalfImageName then begin
    FStarHalfImageName := Value;
    UpdateImageIndex(Value, FStarHalfImageIndex);
  end;
end;

procedure TCustomSkinButton.SetTransparentBackground(const Value: Boolean);
begin
  if fTransparentBackground <> Value then begin
    fTransparentBackground := Value;
    Invalidate;
  end;
end;

procedure TCustomSkinButton.UpdateImage;
begin
  if not (csLoading in ComponentState) and not (csDestroying in ComponentState) then begin
    CheckImageIndexes;
    Invalidate;
  end;
end;

procedure TCustomSkinButton.UpdateImageList;
begin
  // do nothing
end;

procedure TCustomSkinButton.UpdateImages;
begin
  // do nothing
end;

procedure TCustomSkinButton.UpdateImageIndex(Name: TImageName; var Index: TImageIndex);
begin
  if (Images <> nil) and Images.IsImageNameAvailable then
    Index := Images.GetIndexByName(Name);
  UpdateImage;
end;

procedure TCustomSkinButton.UpdateImageName(Index: TImageIndex; var Name: TImageName);
begin
  if (Images <> nil) and Images.IsImageNameAvailable then
    Name := Images.GetNameByIndex(Index);
  UpdateImage;
end;

procedure TCustomSkinButton.UpdateStyleElements;
begin
  Invalidate;
end;

procedure TCustomSkinButton.PreparePainting(const DrawItemStruct: TDrawItemStruct);
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  FIsDown := DrawItemStruct.itemState and ODS_SELECTED <> 0;
  FIsDefault := DrawItemStruct.itemState and ODS_FOCUS <> 0;
end;

procedure TCustomSkinButton.FinishPainting;
begin
  FCanvas.Handle := 0;
end;

procedure TCustomSkinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if AComponent = BackGroundImages then
    BackGroundImages := nil;
end;

procedure TCustomSkinButton.DrawWindowsBackground(const DrawItemStruct: TDrawItemStruct);
var
  R: TRect;
  Flags: Longint;
  Details: TThemedElementDetails;
  Button: TThemedButton;
  LStyle: TCustomStyleServices;
begin
  R := ClientRect;

  if ThemeControl(Self) then
  begin
    LStyle := StyleServices(Self);
    if not Enabled then
      Button := tbPushButtonDisabled
    else
      if FIsDown then
        Button := tbPushButtonPressed
      else
        if FMouseInControl then
          Button := tbPushButtonHot
        else
          if IsFocused or FIsDefault then
            Button := tbPushButtonDefaulted
          else
            Button := tbPushButtonNormal;

    Details := LStyle.GetElementDetails(Button);
    // Parent background.
    if not (csGlassPaint in ControlState) then
      LStyle.DrawParentBackground(Handle, DrawItemStruct.hDC, Details, True)
    else
      FillRect(DrawItemStruct.hDC, R, GetStockObject(BLACK_BRUSH));
    // Button shape.
    LStyle.DrawElement(DrawItemStruct.hDC, Details, DrawItemStruct.rcItem);
  end
  else
  begin
    R := ClientRect;

    Flags := DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
    if FIsDown then Flags := Flags or DFCS_PUSHED;
    if DrawItemStruct.itemState and ODS_DISABLED <> 0 then
      Flags := Flags or DFCS_INACTIVE;

    { DrawFrameControl doesn't allow for drawing a button as the
        default button, so it must be done here. }
    if IsFocused or FIsDefault then
    begin
      FCanvas.Pen.Color := clWindowFrame;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Style := bsClear;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);

      { DrawFrameControl must draw within this border }
      InflateRect(R, -1, -1);
    end;

    { DrawFrameControl does not draw a pressed button correctly }
    if FIsDown then
    begin
      FCanvas.Pen.Color := clBtnShadow;
      FCanvas.Pen.Width := 1;
      FCanvas.Brush.Color := clBtnFace;
      FCanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      InflateRect(R, -1, -1);
    end
    else
      DrawFrameControl(DrawItemStruct.hDC, R, DFC_BUTTON, Flags);


  end;

end;

procedure TCustomSkinButton.DrawSkinBackground(const DrawItemStruct: TDrawItemStruct);
var
  GlyphIdx: Integer;
begin
  if not assigned(BackgroundImages) or (BackgroundImages.Count = 0) then
    DrawWindowsBackground(DrawItemStruct)
  else begin
    if (csDesigning in ComponentState) then
      GlyphIdx := 0
    else begin
      GlyphIdx := 0; // Normal
      if FMouseInControl then begin
        if FIsDown then GlyphIdx := 2 // Pressed
        else GlyphIdx := 1;           // Highlight
      end;
      if not Enabled then GlyphIdx := 3; // Disabled
    end;
    if GlyphIdx >= BackgroundImages.Count then
      GlyphIdx := BackgroundImages.Count - 1;

    BackgroundImages.Draw(FCanvas,
        (Width Div 2) - (BackgroundImages.Width Div 2),
        (Height Div 2) - (BackgroundImages.Height Div 2),
        GlyphIdx, (Enabled) or (DisabledImageIndex <> -1));
  end;
end;

procedure TCustomSkinButton.DrawBackground(const DrawItemStruct: TDrawItemStruct);
begin
  case FDrawMode of
    dm_Windows: DrawWindowsBackground(DrawItemStruct);
    dm_Skin: DrawSkinBackground(DrawItemStruct);
  end;
end;

procedure TCustomSkinButton.DrawContent(aCanvas: TCanvas);
begin
  DrawImage(FCanvas);
  DrawOverlayImage(FCanvas);
  DrawButtonFocusRect(FCanvas);
end;

procedure TCustomSkinButton.DrawImage(aCanvas: TCanvas);
var
  posX, posY, imgIdx: Integer;
begin
  imgIdx := ImageIndex;
  if FMouseInControl and (HotImageIndex >= 0) then imgIdx := HotImageIndex;
  if FIsDown and (PressedImageIndex >= 0) then imgIdx := PressedImageIndex;
  if (not Enabled) and (DisabledImageIndex >= 0) then imgIdx := DisabledImageIndex;

  if (Images = Nil) or (imgIdx < 0) or (imgIdx > Images.Count - 1) then
    exit;

  posX := (Width Div 2) - (Images.Width Div 2);
  posY := (Height Div 2) - (Images.Height Div 2);
  if FIsDown then begin
    inc(posX);
    inc(posY);
  end;
  Images.Draw(aCanvas, posX, posY, imgIdx, (Enabled) or (DisabledImageIndex <> -1));
end;

procedure TCustomSkinButton.DrawOverlayImage(aCanvas: TCanvas);
var
  posX, posY: Integer;
begin
  if (Images = Nil) or (OverlayImageIndex  < 0) or (OverlayImageIndex > Images.Count - 1) then
    exit;

  posX := (Width Div 2) - (Images.Width Div 2);
  posY := (Height Div 2) - (Images.Height Div 2);
  if FIsDown then begin
    inc(posX);
    inc(posY);
  end;
  Images.Draw(aCanvas, posX, posY, OverlayImageIndex, Enabled);
end;

procedure TCustomSkinButton.DrawButtonFocusRect(aCanvas: TCanvas);
var
  R: TRect;
begin
  if IsFocused and FIsDefault then begin
    R := ClientRect;
    InflateRect(R, -4, -4);
    FCanvas.Pen.Color := clWindowFrame;
    FCanvas.Brush.Color := clBtnFace;
    DrawFocusRect(aCanvas.Handle, R);
  end;
end;

procedure TCustomSkinButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
begin
  PreparePainting(DrawItemStruct);
  if (not fTransparentBackground) or (csDesigning in ComponentState) then
    DrawBackground(DrawItemStruct);
  DrawContent(FCanvas);
  FinishPainting;
end;


{ TSkinBtnStyleHook }

procedure TSkinBtnStyleHook.DrawButton(ACanvas: TCanvas;
  AMouseInControl: Boolean);
var
  Details:  TThemedElementDetails;
  DrawRect: TRect;
  LStyle: TCustomStyleServices;
begin
  if not (Control is TSkinButton) then
  begin
    inherited;
    Exit;
  end;
  LStyle := StyleServices;
  DrawRect := Control.ClientRect;
  if not Control.Enabled then
    Details := LStyle.GetElementDetails(tbPushButtonDisabled)
  else
  if FPressed then
    Details := LStyle.GetElementDetails(tbPushButtonPressed)
  else if AMouseInControl then
    Details := LStyle.GetElementDetails(tbPushButtonHot)
  else if Control.Focused or TSkinButton(Control).Default then
    Details := LStyle.GetElementDetails(tbPushButtonDefaulted)
  else
    Details := LStyle.GetElementDetails(tbPushButtonNormal);
  DrawRect := Control.ClientRect;
  LStyle.DrawElement(ACanvas.Handle, Details, DrawRect);

  TSkinButton(Control).DrawImage(aCanvas);
  TSkinButton(Control).DrawOverlayImage(aCanvas);
  // TSkinButton(Control).DrawButtonFocusRect(aCanvas);
end;

{ TRatingButton }

constructor TRatingButton.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  fAllowChangeRating := True;
  fWantArrowButtons := false;
  FAlignment := taCenter;
  fRating := 127;
  fTmpRating := 127;
  // fCustomBackground := TBitmap.Create;
end;

destructor TRatingButton.Destroy;
begin
  if assigned(fCustomBackground) then
    fCustomBackground.Free;
  inherited;
end;

procedure TRatingButton.CMMouseLeave(var Message: TMessage);
begin
  fTmpRating := fRating;
  inherited;
end;

procedure TRatingButton.CMWantSpecialKey(var Msg: TWMKey);
begin
  case Msg.CharCode of
    VK_Left,
    VK_Right,
    VK_Up,
    VK_Down: if fWantArrowButtons then
                Msg.Result := 1
             else
                inherited;
    else
      inherited;
  end;
end;

procedure TRatingButton.DrawBackground(const DrawItemStruct: TDrawItemStruct);
begin
  if not (csDesigning in ComponentState) and assigned(fCustomBackground) then begin
    FCanvas.Draw(0, 0, fCustomBackground);
  end else
    inherited DrawBackground(DrawItemStruct);
end;

procedure TRatingButton.DrawContent(aCanvas: TCanvas);
begin
  // todo, Rating zeichnen
  DrawRating(aCanvas);
end;

function TRatingButton.GetRatingWidth: Integer;
begin
  if (Images = Nil) then
    result := Width
  else
    result := cRatingStarCount * Images.Width;
end;

function TRatingButton.GetRatingDrawOffset: Integer;
begin
  case FAlignment of
    taLeftJustify: result := 0;
    taRightJustify: result := Width - RatingWidth;
    taCenter: result := (Width - RatingWidth) Div 2;
  else
    result := 0;
  end;
end;

procedure TRatingButton.DrawRating(aCanvas: TCanvas);
var i, p, posX, posY, imgIdx: Integer;
     xxx: Integer;
begin
  if assigned(Images) then begin
    posX := RatingDrawOffset;
    posY := (Height Div 2) - (Images.Height Div 2);

    InternalPaintRating(fTmpRating,
      aCanvas, posX, posY, Enabled,
      Images,
      FStarFullImageIndex, FStarHalfImageIndex, FStarEmptyImageIndex);
  end;
end;


function TRatingButton.XToRating(X: Integer): Integer;
var
  StepWidth: Integer;
begin
  StepWidth := RatingWidth div 10;
  
  result := ((x - RatingDrawOffset) div StepWidth) * StepWidth;
  
  // convert this to 1..255
  // adding 20 (set the rating near the upper-bound of )
  result := Round(255 * result / RatingWidth) + 20;
  if result > 255 then
    result := 255;
  if result < 20 then
    result := 20;
end;

procedure TRatingButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if fAllowChangeRating then begin
    Rating := XToRating(X);
    if assigned(FOnRatingChanged) then
      FOnRatingChanged(self, Rating);
  end;
  inherited;
end;

procedure TRatingButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if fAllowChangeRating then begin
    fTmpRating := XToRating(X);
    Invalidate;
  end;
  inherited;
end;

procedure TRatingButton.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TRatingButton.SetCustomBackground(const Value: TBitmap);
begin
  if assigned(Value) then begin
    if not assigned(fCustomBackground) then
      fCustomBackground := TBitmap.Create;
    fCustomBackground.Assign(Value);
  end else begin
    if assigned(fCustomBackground) then
      FreeAndNil(fCustomBackground);
  end;
  Invalidate;
end;

procedure TRatingButton.SetRating(const Value: Byte);
var
  tmp: Byte;
begin
  if Value = 0 then
    tmp := 127
  else
    tmp := Value;

  if fRating <> tmp then begin
    fRating := tmp;
    fTmpRating := tmp;
    Invalidate;
  end;
end;

{ TRatingPainter }

constructor TRatingPainter.Create;
begin
  inherited;
  fStarFullIdx  := 0;
  fStarHalfIdx  := 1;
  fStarEmptyIdx := 2;
  fCountIconIdx := 3;
end;

procedure TRatingPainter.PaintRating(aRating: Integer; aCanvas: TCanvas; x, y: Integer; Enabled: Boolean);
begin
  if assigned(Images) then
    InternalPaintRating(aRating, aCanvas, x, y, Enabled, Images, StarFullIdx, StarHalfIdx, StarEmptyIdx);
end;

function TRatingPainter.GetHeight: Integer;
begin
  if assigned(Images) then
    result := Images.Height
  else
    result := 16;
end;

function TRatingPainter.GetWidth: Integer;
begin
  if assigned(Images) then
    result := Images.Width
  else
    result := 16;
end;

procedure TRatingPainter.PaintCountIcon(aCanvas: TCanvas; x, y: Integer; Enabled: Boolean = True);
begin
  if assigned(Images) then
    Images.Draw(aCanvas, X, Y, fCountIconIdx, Enabled);
end;

end.

