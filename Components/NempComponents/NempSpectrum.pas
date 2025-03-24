unit NempSpectrum;

interface

uses
  Winapi.Windows, WinApi.Messages, System.SysUtils, System.Classes,
  VCL.Graphics, VCL.Controls, VCL.GraphUtil, uNempHintWindow;

const
  cValueCount = 512;
  cDefaultBarWidth = 3;
  cDefaultBarGap = 1;
  cHeightMultiplicator = 500;

type
  TFFTData = array [0..512] of Single;
  TIntArray = Array of Integer;

  teSpectrumDrawMode = (sdmLines, sdmBars, sdmGradientBars);

  TNempSpectrum =   class(TCustomControl) //Cclass(TGraphicControl)
  private
    fGradientBMP: TBitmap;
    fParentBuffer: TBitmap;
    fIdleFactor: Integer;
    fIdleSign: Integer;
    fPeaks: TIntArray; // array [0..30] of Integer;
    fBars : TIntArray; // array [0..30] of Integer;

    fDrawRes: Integer;
    fDrawWidth: Integer;
    fDrawHeight: Integer;
    fBarWidth: Integer; //
    fBarInternalWidth: Integer; // InternalWidth of a Bar
    fBarInternalGap: Integer;   // Gap between two Bars

    fPaddings: TPadding;
    fActive: Boolean;
    fBarCount: Integer;
    fFallSpeedPeaks: Integer;
    fFallSpeedBars: Integer;
    fDrawMode: teSpectrumDrawMode;
    fDrawPeaks: Boolean;
    fColorBar2: TColor;
    fColorBar1: TColor;
    fColorPeak: TColor;
    fDelayComplete: Integer;
    FHintData: TNempHintData; // used while preparing the hint window

    procedure SetPaddings(const Value: TPadding);
    procedure SetData(const Value: TFFTData);
    procedure SetBarCount(const Value: Integer);
    procedure SetDrawMode(const Value: teSpectrumDrawMode);
    procedure SetDrawPeaks(const Value: Boolean);
    procedure SetColorBar1(const Value: TColor);
    procedure SetColorBar2(const Value: TColor);
    procedure SetColorPeak(const Value: TColor);
    procedure SetBarWidth(const Value: Integer);
    procedure SetDelayElapsed(const Value: Integer);

    procedure UpdateSize;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
  protected
    FOnShowHint: TNempShowSimpleHintEvent;
    FOnDrawHint: TNempDrawHintEvent;
    FOnGetHintSize: TNempCalcHintEvent;

    procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
    procedure WndProc(var Message: TMessage); override;

    procedure Paint; override;
    procedure RefreshGradient;
    procedure PaintLines;
    procedure PaintBars;
    procedure PaintGradient;

  public
    property Data: TFFTData write SetData;
    property Active: Boolean read fActive;
    property DelayElapsed: Integer write SetDelayElapsed;
    property DelayComplete: Integer write fDelayComplete;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure DrawWithoutNewData;

  published

    property Paddings: TPadding read fPaddings write SetPaddings;
    property BarCount: Integer read fBarCount write SetBarCount;
    property BarWidth: Integer read fBarWidth write SetBarWidth;

    property FallSpeedBars: Integer read fFallSpeedBars write fFallSpeedBars;
    property FallSpeedPeaks: Integer read fFallSpeedPeaks write fFallSpeedPeaks;

    property DrawMode: teSpectrumDrawMode read fDrawMode write SetDrawMode;
    property DrawPeaks: Boolean read fDrawPeaks write SetDrawPeaks;

    property ColorPeak: TColor read fColorPeak write SetColorPeak;
    property ColorBar1: TColor read fColorBar1 write SetColorBar1;
    property ColorBar2: TColor read fColorBar2 write SetColorBar2;

    property OnShowHint: TNempShowSimpleHintEvent read FOnShowHint write FOnShowHint;
    property OnDrawHint: TNempDrawHintEvent       read FOnDrawHint write FOnDrawHint;
    property OnGetHintSize: TNempCalcHintEvent    read FOnGetHintSize write FOnGetHintSize;

    // publish inherited properties
    property Visible;
    property Margins;
    property OnClick;
    property OnDblClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;

    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property PopupMenu;
    property Align;
    property Anchors;

  end;

procedure Register;

implementation

uses
  math, NempControls.Common;

procedure Register;
begin
  RegisterComponents('Nemp Components', [TNempSpectrum]);
end;

{ TNempSpectrum }

constructor TNempSpectrum.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csReplicatable];
  fDrawWidth := Width;
  fDrawHeight := Height;
  fActive := False;
  fBarCount := 25;
  SetLength(self.fPeaks, fBarCount);
  SetLength(self.fBars, fBarCount);
  fDrawRes := 2; // cValueCount Div fBarCount;
  fFallSpeedPeaks := 1;
  fFallSpeedBars := 3;
  fDrawPeaks := True;

  fIdleFactor := 1;
  fIdleSign := 1;

  fBarWidth := cDefaultBarWidth + cDefaultBarGap;
  fBarInternalWidth := cDefaultBarWidth;
  fBarInternalGap := cDefaultBarGap;

  fPaddings := TPadding.Create(self);
  fGradientBMP := TBitmap.Create(10,10);
  fParentBuffer := TBitmap.Create;

  DoubleBuffered := True;
end;

destructor TNempSpectrum.Destroy;
begin
  fGradientBMP.Free;
  fParentBuffer.Free;
  fPaddings.Free;
  inherited;
end;

procedure TNempSpectrum.ChangeScale(M, D: Integer; isDpiChange: Boolean);
var
  newBarWidth, newGap: Integer;
begin
  inherited;

  fDrawWidth := Width - (fPaddings.Left) - (fPaddings.Right);
  fDrawHeight := Height - (fPaddings.Top) - (fPaddings.Bottom);

  newBarWidth := ScaleValue(fBarWidth);  // default: 3+1
  if newBarWidth >= 6 then
    newGap := 2
  else
    newGap := 1;
  fBarInternalWidth := newBarWidth - newGap;
  fBarInternalGap := newGap;
  UpdateSize;
end;


procedure TNempSpectrum.SetDelayElapsed(const Value: Integer);
var
  iBar: Integer;
  res, extMul: Extended;
begin
  if Value = 0 then begin
    for iBar:= Low(fBars) to High(fBars) do begin
      fPeaks[iBar] := 1;
      fBars[iBar] := 1;
    end;
  end else begin
    res := (2 * pi) / (max(10, fBarCount Div 3));

    if fIdleSign = 1 then begin
      inc(fIdleFactor, 4);
      if fIdleFactor > 100 then
        fIdleSign := -1;
    end else begin
      dec(fIdleFactor, 4);
      if fIdleFactor < - 100 then
        fIdleSign := 1;
    end;

    extMul := (fIdleFactor) / 200;
    for iBar:= Low(fBars) to High(fBars) do begin
      fPeaks[iBar] := round( (1.5 + extMul * sin(res * iBar)) * fDrawHeight/3);
      if (fDelayComplete > 0) and (iBar <= fBarCount * (Value / fDelayComplete)) then
        fBars[iBar] := round( (1.5 + extMul * sin(res * iBar)) * fDrawHeight/3)
      else
        fBars[iBar] := 0;
    end;
  end;
  Invalidate;
end;

procedure TNempSpectrum.DrawWithoutNewData;
var
  iBar: Integer;
begin
  fActive := False;
  for iBar:= Low(fBars) to High(fBars) do begin
    fPeaks[iBar] := max(1, fPeaks[iBar] - fFallSpeedPeaks);
    fBars[iBar] := max(1, fBars[iBar] - fFallSpeedBars);
    fActive := fActive or (fPeaks[iBar] > 1);
  end;
  Invalidate;
end;


{
  Convert FFTData into BarHeights
  We skip some data at the beginning, and we do not use all Values.
}
procedure TNempSpectrum.SetData(const Value: TFFTData);
var
  iBar, iBarHeight: Integer;

  function GetVal(aIdx: Integer): Integer;
  var
    YVal : Single;
    d: Integer;
  begin
    YVal := 0;
    for d := 0 to fDrawRes - 1 do
      YVal := YVal + Abs(Value[(fDrawRes * aIdx) + d]);

    YVal := YVal / fDrawRes;
    result := min(fDrawHeight, Trunc(YVal * cHeightMultiplicator));
  end;

begin
  fActive := False;
  for iBar:= Low(fBars) to High(fBars) do begin
    iBarHeight := GetVal(iBar + 5);
    if iBarHeight >= fPeaks[iBar] then
      fPeaks[iBar] := iBarHeight
    else begin
      fPeaks[iBar] := max(1, fPeaks[iBar] - fFallSpeedPeaks);
      fActive := fActive or (fPeaks[iBar] > 1);
    end;

    if iBarHeight >= fBars[iBar] then
      fBars[iBar] := iBarHeight
    else
      fBars[iBar] := max(1, fBars[iBar] - fFallSpeedBars);
  end;
  Invalidate;
end;

procedure TNempSpectrum.SetDrawMode(const Value: teSpectrumDrawMode);
begin
  if fDrawMode <> Value then begin
    fDrawMode := Value;
    Invalidate;
  end;
end;

procedure TNempSpectrum.SetDrawPeaks(const Value: Boolean);
begin
  if fDrawPeaks <> Value then begin
    fDrawPeaks := Value;
    Invalidate;
  end;
end;

procedure TNempSpectrum.SetBarCount(const Value: Integer);
var
  checkVal: Integer;
begin
  checkVal := Value;
  if checkVal <= 0 then checkVal := 1;
  if checkVal >= 512 then checkVal := 512;

  if fBarCount <> checkVal then begin
    fBarCount := checkVal;
    SetLength(fPeaks, checkVal);
    SetLength(fBars, checkVal);
    Clear;
  end;
end;

procedure TNempSpectrum.SetBarWidth(const Value: Integer);
begin
  if fBarWidth <> Value then begin
    fBarWidth := Value;
  end;
end;

procedure TNempSpectrum.SetColorBar1(const Value: TColor);
begin
  if fColorBar1 <> Value then begin
    fColorBar1 := Value;
    RefreshGradient;
    Invalidate;
  end;
end;

procedure TNempSpectrum.SetColorBar2(const Value: TColor);
begin
  if fColorBar2 <> Value then begin
    fColorBar2 := Value;
    RefreshGradient;
    Invalidate;
  end;
end;

procedure TNempSpectrum.SetColorPeak(const Value: TColor);
begin
  if fColorPeak <> Value then begin
    fColorPeak := Value;
    Invalidate;
  end;
end;

procedure TNempSpectrum.SetPaddings(const Value: TPadding);
begin
  fPaddings.Assign(Value);
  fDrawWidth := Width - fPaddings.Left - fPaddings.Right;
  fDrawHeight := Height - fPaddings.Top - fPaddings.Bottom;
end;

procedure TNempSpectrum.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  msg.result := 1;
end;

procedure TNempSpectrum.CMHintShow(var Message: TCMHintShow);
var
  doOwnerDraw, ShowOwnHint: Boolean;
begin
  with Message do begin
    Result := 0;
    with HintInfo^ do begin
      doOwnerDraw := False;
      ShowOwnHint := True;
      if assigned(FOnShowHint) then begin
        HintStr := GetShortHint(Hint);
        FOnShowHint(Self, HintStr, doOwnerDraw);
      end else begin
        HintStr := GetShortHint(Hint);
      end;
      // Set our own hint window class and prepare structure to be passed to the hint window.
      if ShowOwnHint and (Result = 0) then
      begin
        HintWindowClass := GetHintWindowClass(doOwnerDraw); // GetHintWindowClass;
        FHintData.HintText := HintStr;
        FHintData.OnDrawHint := FOnDrawHint;
        FHintData.OnGetHintSize := FOnGetHintSize;
        FHintData.Control := Self;
        FHintData.Tag := 0;  // not used here
        HintData := @FHintData;
      end;
    end;
  end;
end;

procedure TNempSpectrum.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_SIZE: UpdateSize;
  end;
end;

procedure TNempSpectrum.Clear;
var
  i: Integer;
begin
  for i := Low(fPeaks) to High(fPeaks) do begin
    fPeaks[i] := 0;
    fBars[i] := 0;
  end;
  // Invalidate;
end;

procedure TNempSpectrum.PaintLines;
var
  i: Integer;
begin
  Canvas.Pen.Color := ColorBar1;
  Canvas.Pen.Width := 1;

  for i := Low(fBars) to High(fPeaks) do begin
   Canvas.MoveTo(i, Height - fPaddings.Bottom);
   Canvas.LineTo(i, Height - fPaddings.Bottom - fBars[i]);
  end;

  if fDrawPeaks then
    for i := Low(fBars) to High(fPeaks) do
      Canvas.Pixels[i, Height - fPaddings.Bottom - fPeaks[i]] := fColorPeak;
end;

procedure TNempSpectrum.PaintBars;
var
  i, xOffSet, BarWidthComplete: Integer;
begin
  Canvas.Pen.Color := fColorPeak;
  Canvas.Pen.Width := 1;
  Canvas.Brush.Color := fColorBar1;
  Canvas.Brush.Style := bsSolid;

  BarWidthComplete := fBarInternalWidth + fBarInternalGap;
  xOffset := fPaddings.Left;
  for i := Low(fBars) to High(fPeaks) do begin
    Canvas.FillRect(Rect(
          xOffset + (i * BarWidthComplete),             Height - fPaddings.Bottom - fBars[i],
          xOffset + (i * BarWidthComplete) + fBarInternalWidth, Height - fPaddings.Bottom));
  end;

  if fDrawPeaks then
    for i := Low(fBars) to High(fPeaks) do begin
      Canvas.MoveTo(xOffset + (i * BarWidthComplete), Height - fPaddings.Bottom - fPeaks[i]);
      Canvas.LineTo(xOffset + (i * BarWidthComplete) + fBarInternalWidth, Height - fPaddings.Bottom - fPeaks[i]);
    end;
end;

procedure TNempSpectrum.UpdateSize;
begin
  RefreshGradient;

  FParentBuffer.SetSize(Width, Height);
  DrawParentImage(self, FParentBuffer.Canvas);
end;


procedure TNempSpectrum.RefreshGradient;
begin
  fDrawHeight := Height - fPaddings.Top - fPaddings.Bottom;
  fGradientBMP.Height := fDrawHeight;
  fGradientBMP.Width := fBarWidth;
  GradientFillCanvas(fGradientBMP.Canvas, ColorBar2, ColorBar1, Rect(0, 0, fGradientBMP.Width, fGradientBMP.Height), gdVertical);
end;

procedure TNempSpectrum.PaintGradient;
var
  i, xOffSet, BarWidthComplete: Integer;
begin

  Canvas.Pen.Color := fColorPeak;
  Canvas.Pen.Width := 1;
  BarWidthComplete := fBarInternalWidth + fBarInternalGap;
  xOffset := fPaddings.Left;

  for i := Low(fBars) to High(fPeaks) do begin
    Canvas.CopyRect(Rect(
          xOffset + (i * BarWidthComplete),             Height - fPaddings.Bottom - fBars[i],
          xOffset + (i * BarWidthComplete) + fBarInternalWidth, Height - fPaddings.Bottom),
          fGradientBMP.Canvas,
          Rect(0, Height - fPaddings.Bottom - fBars[i], fBarInternalWidth, Height - fPaddings.Bottom));
  end;

  if fDrawPeaks then
    for i := Low(fBars) to High(fPeaks) do begin
      Canvas.MoveTo(xOffset + (i * BarWidthComplete), Height - fPaddings.Bottom - fPeaks[i]);
      Canvas.LineTo(xOffset + (i * BarWidthComplete) + fBarInternalWidth, Height - fPaddings.Bottom - fPeaks[i]);
    end;
end;

procedure TNempSpectrum.Paint;
begin
  if csDestroying in ComponentState then exit;

  if csDesigning in ComponentState then begin
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(0, 0, Width, Height);
  end else begin
    DrawParentImage(self, FParentBuffer.Canvas);
    BitBlt(Canvas.Handle, 0, 0, Width, Height, FParentBuffer.Canvas.Handle, 0, 0, SRCCOPY);

    case fDrawMode of
      sdmLines: PaintLines;
      sdmBars: PaintBars;
      sdmGradientBars: PaintGradient;
    end;

  end;

end;

end.
