unit NempSkinnedTrackbar;

interface

uses
  Windows, Classes, System.Types, System.SysUtils, Messages, Graphics, Forms, Controls, Vcl.ComCtrls, Vcl.Themes, uNempHintWindow;

const

  cDefaultHeight = 24;
  cDefaultWidth = 150;

  cDefaultTrackBtnLength = 20;
  cDefaultTrackBtnThickNess = 12;
  cDefaultRangeBtnLength = 18;
  cDefaultRangeBtnThickness = 12;

  cDefaultTrackThickNess = 8;
  cDefaultProgressThickNess = 8;
  cDefaultRangeThickNess = 4;

  cFocusRectInflate = 1;

type
  TProgressRangeBar = class;

  teNSBVisibleMode = (vNever, vAlways, vHover);
  teNSBButtonProgressMode = (bmNested, bmCentered);
  teNSBStyle = (nsbStyleWindows, nsbStyleSkinned);
  {
      bmNested
      [-xxxxxxxxxxxxxxoooooooo-]       // visible Trackbar
      [-x-]                [-x-]       // Button min/max

      bmCentered
        [xxxxxxxxxxxxxxxxxxxx]
      [-x-]                [-x-]

      bmRange (RangeBar only)
         [xxxxxxxxxxxxxxxxx]
      [--x]               [x--]

      oder besser: (leichter verständlich, universeller?)
        - MarginsTrackbar
        - MarginsTrackBtn
        - MarginsRangeBtn
        oder: allgemeines Offset, was noch auf das alte konzept draufkommt?
      gebraucht wird:
        "wie viel von der vollen Breite wird für die Leiste gebraucht"
        Daraus wird dann min/max-Position der Buttons berechnet
        Beim TrackBtn (dessen Value in der Mitte liegt) zusätzlich von der Option "nested / nicht Nested"

      Position der TrackBar und MinMax-Bar
      - MinMax unsichtbar: Trackbar zentriert
      - MinMax sichtbar: TrackBar *unten*, MinMax *oben*
              unten/oben ggf. mit 1Pixel Platz, bestimmt durch max von Button/Bar-Höhe
              Platz dazwischen kann durch Height festgelegt werden - sollte passen


  }
  // (??) teNSButtonType = (nsbBTWindows, nsbBTSkinned, nsbBTGlyph);
  // teNSBFocusDrawType = (nsbFDTNone, nsbFDTWindows, nsbFDTSkinned);


  {
    Idee für MinMax-Grafiken in Nemp: Halbkreise
    Fokus-Rect-Handling für Glyphed-Buttons:
      Eigene Grafik?

  }


  teBarElement = (beTrack, beTrackBtn, beProgress, beBtnMin, beBtnMax, beRange);
  teScrollButton = (btnNone, btnTrack, btnMin, btnMax);
  teHintArea = (haNotSpecified, haTrackBtn, haMinBtn, haMaxBtn);



  TNempShowHintEvent = procedure(Sender: TProgressRangeBar; HintArea: teHintArea; var HintText: String; var OwnerDraw: Boolean) of object;
  TNempScrollNotifyEvent = procedure (Sender: TProgressRangeBar; ScrollButton: teScrollButton) of object;
  TNempScrollChangeEvent = procedure (Sender: TProgressRangeBar; ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double) of object;


  TDrawBarEvent = procedure(Sender: TProgressRangeBar; BarElement: teBarElement;
        TargetCanvas: TCanvas; TargetRect: TRect) of object;

  TTBColors = class(TPersistent)
  private
    type
      teNSBColors = ( nsbCLFrame, nsbCLFrameHighlight, nsbCLFrameDisabled,
            nsbCLBrush, nsbCLBrushHighlight, nsbCLBrushDisabled,
            nsbCLFocusRect);

    const cDefaultColors : array[teNSBColors] of TColor =  (
      clActiveBorder,     // nsbCLFrame,
      clActiveBorder,     // nsbCLFrameHighlight,
      clInactiveBorder,   // nsbCLFrameDisabled,
      clBtnFace,          // nsbCLBrush,
      clBtnHighlight,     // nsbCLBrushHighlight,
      clBtnShadow,        // nsbCLBrushDisabled,
      clHighlight         // nsbCLFocusRect
    );
  private
    FColors: Array[teNSBColors] of TColor;
    fOwner: TProgressRangeBar;
    function GetColor(const Index: teNSBColors): TColor;
    procedure SetColor(const Index: teNSBColors; const Value: TColor);

    procedure SetDefaultColors;
  public
    constructor Create(aOwner: TProgressRangeBar);
    procedure Assign(Source: TPersistent); override;
  published
    property FrameColor: TColor index nsbCLFrame read GetColor write SetColor;
    property FrameHighlightColor: TColor index nsbCLFrameHighlight read GetColor write SetColor;
    property FrameDisabledColor: TColor index nsbCLFrameDisabled read GetColor write SetColor;
    property BrushColor: TColor index nsbCLBrush read GetColor write SetColor;
    property BrushHighlightColor: TColor index nsbCLBrushHighlight read GetColor write SetColor;
    property BrushDisabledColor: TColor index nsbCLBrushDisabled read GetColor write SetColor;
    property FocusRectColor: TColor index nsbCLFocusRect read GetColor write SetColor;
  end;

  {
    Each element (track, button, progress) of a SlideBar can be customized.
    TNSBOptions offers some common properties for all elements.
  }
  TNSBElementOptions = class(TPersistent)
  private
    FOWner: TProgressRangeBar;
    FColors: TTBColors;
    // width of the Frame
    FFrameWidth: Integer;
    // corner radius
    FRadius: Integer;
    // when to draw this element
    FVisibleMode: teNSBVisibleMode;
    // how to draw the FocusRect in this element
    // FFocusDrawType: teNSBFocusDrawType;
    FMouseDown: Boolean;
    FMouseHover: Boolean;
    FFocussed: Boolean;
    procedure SetVisibleMode(const Value: teNSBVisibleMode);
    //procedure SetFocusDrawType(const Value: teNSBFocusDrawType);
    procedure SetFrameWidth(const Value: Integer);
    procedure SetRadius(const Value: Integer);
    procedure SetColors(const Value: TTBColors);

  public
    constructor Create(aOwner: TProgressRangeBar);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

  published
    property Colors: TTBColors read FColors write SetColors;
    property FrameWidth: Integer read FFrameWidth write SetFrameWidth;
    property Radius: Integer read FRadius write SetRadius;
    property VisibleMode: teNSBVisibleMode read FVisibleMode write SetVisibleMode;
    //property FocusDrawType: teNSBFocusDrawType read FFocusDrawType write SetFocusDrawType;
    {
    todo: Hier die Glyphen reinsetzen anstatt in der Trackbar selbst?
    }

  end;

  TNSBTrackOptions = class(TNSBElementOptions)
  private
    FThickness: Integer;
    procedure SetThickness(const Value: Integer);
  public
    constructor Create(aOwner: TProgressRangeBar);
    procedure Assign(Source: TPersistent); override;
  published
    property Thickness: Integer read FThickness write SetThickness;
  end;

  TNSBButtonOptions = class(TNSBElementOptions)
  private
    FThickness: Integer; // like the Thickness of the track
    FLength: Integer;
    procedure SetLength(const Value: Integer);
    procedure SetThickness(const Value: Integer);     // dimension along the Orientation of the track
  public
    constructor Create(aOwner: TProgressRangeBar);
    procedure Assign(Source: TPersistent); override;
  published
    property Thickness: Integer read FThickness write SetThickness;
    property Length: Integer read FLength write SetLength;
  end;


  TNempSlideBarOptions = class(TPersistent)
   (*
    KeyDown: Pos1/Ende PageUp/Down
    MouseDown: RechtsKlick: DefaultPosition?
    AccelerateKeyInput: Boolean // = größere Önderung bei Key gedrückt halten
    Inputs: Set Of (TrackBarKlick, Button-Drag&Drop, MouseWheel, ArrowKeys)
    FocusrectMode: Default/Skinned/User/Off
   *)
  end;

  TProgressRangeBar =  class(TCustomControl) // class(TCustomTransparentControl)
  private
    FParentBuffer: TBitmap;
    FBuffer: TBitmap;
    FOrientation: TTrackBarOrientation;
    FMin: Integer;
    FMax: Integer;
    FSmallStep: Integer;
    FLargeStep: Integer;

    FHintData: TNempHintData;                    // used while preparing the hint window
    FLastHintRect: TRect;                        // Area which the mouse must leave to reshow a hint.

    FPosition: Integer; // FMin..FMax
    FProgress: Double; // the same meaning, but scaled to 0..1
    FDefaultPosition: Integer;
    fAllowRange: Boolean;
    fRangeActive: Boolean;

    fRangeMin: Integer;
    fRangeMax: Integer;
    fRangeMinNorm: Double;
    fRangeMaxNorm: Double;
    fTrackBarMargin: Integer;

    FButtonMode: teNSBButtonProgressMode; // How the Button is painted in relation to the Track
    FStyle: teNSBStyle; // Default-Windows or Skinned

    FTrackBtnGlyph: TPicture;
    FMinBtnGlyphh: TPicture;
    FMaxBtnGlyphh: TPicture;

    // FElements: 3 Buttons, TrackBar, ProgressBar
    FElements: Array [teBarElement] of TNSBElementOptions;

    FDownButtonIdx: teScrollButton;
    FFocussedButtonIdx: teScrollButton;
    FMouseDelta: TPoint;

    FOnChange: TNotifyEvent;
    FOnScroll: TNempScrollChangeEvent;
    FOnStep: TNempScrollChangeEvent;
    FOnStartScroll: TNempScrollNotifyEvent;
    FOnEndScroll: TNempScrollNotifyEvent;
    FOnCancelScroll: TNempScrollNotifyEvent;

    FCurrentHintArea: teHintArea;
    FOnShowHint: TNempShowHintEvent;
    FOnDrawHint: TNempDrawHintEvent;
    FOnGetHintSize: TNempCalcHintEvent;

    procedure SetMin(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetSmallStep(Value: Integer);
    procedure SetLargeStep(Value: Integer);
    procedure SetOrientation(const Value: TTrackBarOrientation);
    procedure SetButtonMode(const Value: teNSBButtonProgressMode);

    procedure ValidatePosition;
    function ValidateMinNorm(newValue: Double): Double;
    function ValidateMaxNorm(newValue: Double): Double;

    procedure SetPosition(const Value: Integer);
    procedure SetProgress(const Value: Double);
    procedure SetDefaultPosition(const Value: Integer);

    function NormToMinmax(const Value: Double): Integer;
    function MinmaxToNorm(const Value: Integer): Double;
    function NeedRepaint(const PreviousProgress: Double): Boolean;

    function PointToProgress(const X, Y: Integer): Double;

    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure CMWantSpecialKey(var Msg: TWMKey); message CM_WANTSPECIALKEY;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
    procedure SetStyle(const Value: teNSBStyle);

    procedure UpdateSize;
    procedure SwapCanvas;
    procedure SetAllowRange(const Value: Boolean);
    procedure SetRangeActive(const Value: Boolean);
    procedure SetRangeMax(const Value: Integer);
    procedure SetRangeMin(const Value: Integer);
    function GetBtnElementOptions(const Index: teBarElement): TNSBButtonOptions;
    function GetTrackElementOptions(const Index: teBarElement): TNSBTrackOptions;
    procedure SetRangeMaxNorm(const Value: Double);
    procedure SetRangeMinNorm(const Value: Double);

    function GetHintArea: teHintArea;
    procedure SetMaxBtnGlyphh(const Value: TPicture);
    procedure SetMinBtnGlyphh(const Value: TPicture);
    procedure SetTrackBtnGlyph(const Value: TPicture);
    procedure SetBtnElementOptions(const Index: teBarElement; const Value: TNSBButtonOptions);
    procedure SetTrackBarOptions(const Index: teBarElement; const Value: TNSBTrackOptions);
    procedure SetTrackBarMargin(const Value: Integer);

  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;

    function CenterOfRect(ARect: TRect): TPoint;
    function GetRectTrackbar: TRect; virtual;  // Rect of the Track (for Drawing)
    function GetRectAvailableProgress: TRect; virtual;  // Rect of the actual Min-Max-Area (smaller than TrackRect for nested Buttons)
    function GetRectTrackButton: TRect; virtual;
    function GetRectProgress: TRect; virtual;

    function GetRectRangebar: TRect; virtual;
    function GetRectMinButton: TRect; virtual;
    function GetRectMaxButton: TRect; virtual;


    function GetThemeTrack: TThemedElementDetails;
    function GetThemeProgress: TThemedElementDetails;
    function GetThemeTrackButton: TThemedElementDetails;
    function GetThemeRangeButton(Base: TThemedTrackBar; ElementOptions: TNSBButtonOptions): TThemedElementDetails;
    function GetThemeMinButton: TThemedElementDetails;
    function GetThemeMaxButton: TThemedElementDetails;
    function GetThemeButton(ElementOptions: TNSBButtonOptions): TThemedElementDetails;

    procedure SetFocussedBtn(Index: teScrollButton);
    procedure ToggleFocussedBtn;
    function GetActiveButton: TNSBElementOptions;
    procedure InternalMouseMove(Shift: TShiftState; X, Y: Integer); virtual;     // im Klau-Code: ExtraMouseMove  //

    function DoStartScroll(const X, Y: Integer): TPoint; virtual;
    procedure DoScroll(const X, Y: Integer); virtual;
    procedure DoEndScroll; virtual;
    procedure DoCancelScroll; virtual;
    procedure ChangePosition(const Delta: Integer); virtual;

    function WantDrawTrack: Boolean; virtual;
    function WantDrawProgress: Boolean; virtual;
    function WantDrawButton: Boolean; virtual;
    function WantDrawRangeButtons: Boolean; virtual;
    function WantDrawRangeBar: Boolean; virtual;


    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Paint; override;

    procedure PrepareCanvas(const aCanvas: TCanvas; ElementOptions: TNSBElementOptions; aMouseIdx: Integer);
    procedure CheckFocusAndDrawIt(aButton: TNSBElementOptions; aCanvas: TCanvas; aRect: TRect);
    procedure DoDrawTrack(const ACanvas: TCanvas); virtual;
    procedure DoDrawButton(const ACanvas: TCanvas); virtual;
    procedure DoDrawProgress(const ACanvas: TCanvas); virtual;

    procedure DoDrawRangeBar(const ACanvas: TCanvas); virtual;
    procedure DoDrawRangeButtons(const ACanvas: TCanvas); virtual;

  public
    property ScrollingButton: teScrollButton read FDownButtonIdx;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property OnChange      : TNotifyEvent read FOnChange write FOnChange;
    property OnScroll      : TNempScrollChangeEvent read FOnScroll       write FOnScroll      ;
    property OnStep        : TNempScrollChangeEvent read FOnStep         write FOnStep        ;
    property OnStartScroll : TNempScrollNotifyEvent read FOnStartScroll  write FOnStartScroll ;
    property OnEndScroll   : TNempScrollNotifyEvent read FOnEndScroll    write FOnEndScroll   ;
    property OnCancelScroll: TNempScrollNotifyEvent read FOnCancelScroll write FOnCancelScroll;

    property OnShowHint: TNempShowHintEvent read FOnShowHint write FOnShowHint;
    property OnDrawHint: TNempDrawHintEvent read FOnDrawHint write FOnDrawHint;
    property OnGetHintSize: TNempCalcHintEvent read FOnGetHintSize write FOnGetHintSize;

    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property PopupMenu;

    property Min: Integer read FMin write SetMin default 0;
    property Max: Integer read FMax write SetMax default 100;
    property SmallStep: Integer read FSmallStep write SetSmallStep default 1;
    property LargeStep: Integer read FLargeStep write SetLargeStep default 10;

    property RangeMin: Integer read FRangeMin write SetRangeMin;
    property RangeMax: Integer read FRangeMax write SetRangeMax;
    property RangeMinNorm: Double read FRangeMinNorm write SetRangeMinNorm;
    property RangeMaxNorm: Double read FRangeMaxNorm write SetRangeMaxNorm;

    property Orientation: TTrackBarOrientation read FOrientation write SetOrientation;
    property ButtonMode: teNSBButtonProgressMode read FButtonMode write SetButtonMode;
    property Style: teNSBStyle read fStyle write SetStyle;
    property TrackBarMargin: Integer read fTrackBarMargin write SetTrackBarMargin;

    property Position: Integer read FPosition write SetPosition;
    property Progress: Double read FProgress write SetProgress;
    property DefaultPosition: Integer read fDefaultPosition write SetDefaultPosition;

    property AllowRange: Boolean read fAllowRange write SetAllowRange;
    property RangeActive: Boolean read fRangeActive write SetRangeActive;

    //property TrackButton: TNSBButtonOptions index beTrackBtn read GetBtnElementOptions;
    property TrackButton: TNSBButtonOptions index beTrackBtn read GetBtnElementOptions write SetBtnElementOptions;
    property RangeButtonMin: TNSBButtonOptions index beBtnMin read GetBtnElementOptions write SetBtnElementOptions;
    property RangeButtonMax: TNSBButtonOptions index beBtnMax read GetBtnElementOptions write SetBtnElementOptions;
    property TrackBar: TNSBTrackOptions index beTrack read GetTrackElementOptions write SetTrackBarOptions;
    property ProgressBar: TNSBTrackOptions index beProgress read GetTrackElementOptions write SetTrackBarOptions;
    property RangeBar: TNSBTrackOptions index beRange read GetTrackElementOptions write SetTrackBarOptions;



    property TrackBtnGlyph: TPicture read FTrackBtnGlyph write SetTrackBtnGlyph;
    property MinBtnGlyphh: TPicture read FMinBtnGlyphh write SetMinBtnGlyphh;
    property MaxBtnGlyphh: TPicture read FMaxBtnGlyphh write SetMaxBtnGlyphh;

    property Align;
    property Anchors;

  end;

  procedure Register;


implementation

uses
  math, NempControls.Common;


{ TCustomNempSkinnedTrackBar }

constructor TProgressRangeBar.Create(AOwner: TComponent);
var
  i: teBarElement;
begin
  inherited;
  FBuffer := TBitmap.Create;
  FParentBuffer := TBitmap.Create;

  FTrackBtnGlyph := TPicture.Create;
  FMinBtnGlyphh := TPicture.Create;
  FMaxBtnGlyphh := TPicture.Create;

  // Create option objects for the parts of this component

  FElements[beTrackBtn] := TNSBButtonOptions.Create(self);
  FElements[beBtnMin] := TNSBButtonOptions.Create(self);
  FElements[beBtnMax] := TNSBButtonOptions.Create(self);

  FElements[beTrack] := TNSBTrackOptions.Create(self);
  FElements[beProgress] := TNSBTrackOptions.Create(self);
  FElements[beRange] := TNSBTrackOptions.Create(self);

  // Set some default values different from the original defaults
  RangeButtonMin.FThickness := cDefaultRangeBtnThickness;
  RangeButtonMin.FLength := cDefaultRangeBtnLength;
  RangeButtonMax.FThickness := cDefaultRangeBtnThickness;
  RangeButtonMax.FLength := cDefaultRangeBtnLength;
  ProgressBar.Thickness := cDefaultProgressThickNess;
  ProgressBar.Colors.BrushColor := clHighlight;
  RangeBar.Thickness := cDefaultRangeThickNess;

  FStyle := nsbStyleWindows;
  fMin := 0;
  fMax := 100;
  FRangeMin := 0;
  FRangeMax := 100;
  fRangeMinNorm := 0;
  fRangeMaxNorm := 1;
  fSmallStep := 1;
  fLargeStep := 10;
  FPosition := 0;
  FProgress := 0;
  FDefaultPosition := 0;

  Height := cDefaultHeight;
  Width := cDefaultWidth;

  fAllowRange := True;  // later: False by Default ?
  fRangeActive := True; // later: False by Default !
  fOrientation := trHorizontal;
  fButtonMode := bmCentered;
  fTrackBarMargin := cFocusRectInflate + cDefaultRangeBtnLength - (cDefaultTrackBtnLength Div 2); // this ensures that the RangeButtons will fit into the ClientRect

  FDownButtonIdx := btnNone;
  FFocussedButtonIdx := btnNone;
  TabStop := True;

  FCurrentHintArea := haNotSpecified;
  //FMouseDownOLD := False;
end;

procedure TProgressRangeBar.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  //Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;// or WS_EX_LAYERED;
end;

destructor TProgressRangeBar.Destroy;
var
  i: teBarElement;
begin
  for i := Low(FElements) to High(FElements) do
    FElements[i].Free;
  FBuffer.Free;
  FParentBuffer.Free;
  FTrackBtnGlyph.Free;
  FMinBtnGlyphh.Free;
  FMaxBtnGlyphh.Free;
  inherited;
end;

procedure TProgressRangeBar.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_SIZE: UpdateSize;
  end;
end;

procedure TProgressRangeBar.CMEnabledChanged(var Msg: TMessage);
begin
  FDownButtonIdx := btnNone;
  FFocussedButtonIdx := btnNone;
  Invalidate;
  inherited;
end;

procedure TProgressRangeBar.CMHintShow(var Message: TCMHintShow);
var
  doOwnerDraw, ShowOwnHint: Boolean;

  function GetHintWindowClass: THintWindowClass;
  begin
    if doOwnerDraw then result := TNempHintWindow
    else result := THintWindow;
  end;

  function LimitCursorRect(): TRect;
  begin

  end;



begin
  if FDownButtonIdx <> btnNone then
    Message.Result := 1

  else
  with Message do
  begin
    Result := 0;
   //if (GetCapture = 0) and ShowHint and not (Dragging or IsMouseSelecting) and ([tsScrolling] * FStates = []) and
   //   (FHeader.States = []) and IsFocusedOrEditing then
    begin
      with HintInfo^ do
      begin
        doOwnerDraw := False;
        ShowOwnHint := True;
        // Möglich: HintString Anpassen je nach Position, also auch je nach Button

        FCurrentHintArea := GetHintArea;
        if assigned(FOnShowHint) then begin
          HintStr := GetShortHint(Hint);
          FOnShowHint(Self, FCurrentHintArea, HintStr, doOwnerDraw);
        end else begin
          HintStr := GetShortHint(Hint);
        end;

        // Set our own hint window class and prepare structure to be passed to the hint window.
        if ShowOwnHint and (Result = 0) then
        begin
          HintWindowClass := GetHintWindowClass; // GetHintWindowClass;
          FHintData.HintText := HintStr;
          FHintData.OnDrawHint := FOnDrawHint;
          FHintData.OnGetHintSize := FOnGetHintSize;
          FHintData.Control := Self;
          FHintData.Tag := Integer(FCurrentHintArea);


          {
          je nach aktivem Element das Rect anders setzen ...
          }
          if FCurrentHintArea = haNotSpecified then
            FLastHintRect := CursorRect
          else begin
            case FCurrentHintArea of
              haTrackBtn: FLastHintRect := GetRectTrackButton;
              haMinBtn: FLastHintRect := GetRectMinButton;
              haMaxBtn: FLastHintRect := GetRectMaxButton;
            else
              FLastHintRect := CursorRect;
            end;
            OffSetRect(FLastHintRect, CursorRect.Left, CursorRect.Top  );
            CursorRect := FLastHintRect;
          end;


          HintData := @FHintData;
        end
        else
          FLastHintRect := Rect(0, 0, 0, 0);
      end;

      // Remind that a hint is about to show.
      //if Result = 0 then
      //  DoStateChange([tsHint])
      //else
      //  DoStateChange([], [tsHint]);
    end;
  end;


end;

procedure TProgressRangeBar.CMMouseEnter(var Msg: TMessage);
begin
  TrackBar.FMouseHover := True;
  ProgressBar.FMouseHover := True;
  Invalidate;
  inherited;
end;

procedure TProgressRangeBar.CMMouseLeave(var Msg: TMessage);
begin
  InternalMouseMove([], -1, -1);
  for var i: teBarElement := Low(FElements) to High(FElements) do
    FElements[i].FMouseHover := False;

  Invalidate;
  inherited;
end;

procedure TProgressRangeBar.CMWantSpecialKey(var Msg: TWMKey);
begin
  case Msg.CharCode of
    VK_Left,
    VK_Right: if FOrientation = trHorizontal then
                Msg.Result := 1
              else
                inherited;
    VK_Up,
    VK_Down: if FOrientation = trVertical then
                Msg.Result := 1
             else
                inherited;
    VK_Prior,
    VK_Next: Msg.Result := 1;
    else
      inherited;
  end;
end;

procedure TProgressRangeBar.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
begin
  //SetBkMode (msg.DC, TRANSPARENT);
  msg.result := 1;
end;

procedure TProgressRangeBar.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  SetFocussedBtn(btnNone);
end;

procedure TProgressRangeBar.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  if FFocussedButtonIdx = btnNone then
    SetFocussedBtn(btnTrack);
  Invalidate;
end;



{
  # -----------------------------------------------------------------
  # GetThemedElementDetails for elements for Track, Buttons, Progress
  # -----------------------------------------------------------------
}

// Main Trackbar
function TProgressRangeBar.GetThemeTrack: TThemedElementDetails;
begin
  if FOrientation = trHorizontal then
    result := StyleServices(Self).GetElementDetails(tpBar) // ttbTrack)
  else
    result := StyleServices(Self).GetElementDetails(tpBarVert)
end;

// Progress an main Trackbar
function TProgressRangeBar.GetThemeProgress: TThemedElementDetails;
begin
  if FOrientation = trHorizontal then
    result := StyleServices(Self).GetElementDetails(tpChunk)
  else
    result := StyleServices(Self).GetElementDetails(tpChunkVert);
end;

// Button on the main Trackbar
function TProgressRangeBar.GetThemeButton(ElementOptions: TNSBButtonOptions): TThemedElementDetails;
begin
  // A regular Button seems to be the best option here. No need to distiguish
  // between nsbOHorizontal and nsbOVertical
  if not Enabled then
    result := StyleServices(Self).GetElementDetails(ttbThumbDisabled)    // diabled
  else begin
     //result := StyleServices(Self).GetElementDetails(tbPushButtonNormal); // normal
    result := StyleServices(Self).GetElementDetails(ttbThumbLeftNormal); // normal

    if ElementOptions.FMouseHover then
      result := StyleServices(Self).GetElementDetails(tbPushButtonHot);  // mouse over
    if ElementOptions.FMouseDown then
      result := StyleServices(Self).GetElementDetails(tbPushButtonPressed); // pressed
  end;
  // testtest .... für die Range-Buttons
  //result := StyleServices(Self).GetElementDetails(tsArrowBtnLeftNormal); // pressed
  //
end;

function TProgressRangeBar.GetThemeTrackButton: TThemedElementDetails;
begin
  if not Enabled then
    result := StyleServices(Self).GetElementDetails(tbPushButtonDisabled) // disabled     ttbThumbNormal
  else begin
    result := StyleServices(Self).GetElementDetails(tbPushButtonNormal); // normal        ttbThumbLeftNormal
    if TrackButton.FMouseHover then
      result := StyleServices(Self).GetElementDetails(tbPushButtonHot);  // mouse over
    if TrackButton.FMouseDown then
      result := StyleServices(Self).GetElementDetails(tbPushButtonPressed); // pressed
  end;
end;

function TProgressRangeBar.GetThemeRangeButton(Base: TThemedTrackBar; ElementOptions: TNSBButtonOptions): TThemedElementDetails;
begin
  if (not Enabled) then inc(Base, 4) else              // "Disabled"
  if ElementOptions.FMouseHover then inc(Base, 1) else // "Hot"
  if ElementOptions.FMouseDown then inc(Base, 2);      // "Pressed"
  result := StyleServices(Self).GetElementDetails(Base);
end;


function TProgressRangeBar.GetThemeMinButton: TThemedElementDetails;
begin
  if FOrientation = trHorizontal then
    result := GetThemeRangeButton(ttbThumbRightNormal, RangeButtonMin)
  else
    result := GetThemeRangeButton(ttbThumbTopNormal, RangeButtonMin)
end;

function TProgressRangeBar.GetThemeMaxButton: TThemedElementDetails;
begin
  if FOrientation = trHorizontal then
    result := GetThemeRangeButton(ttbThumbLeftNormal, RangeButtonMax)
  else
    result := GetThemeRangeButton(ttbThumbBottomNormal, RangeButtonMax)
end;



function TProgressRangeBar.GetBtnElementOptions(
  const Index: teBarElement): TNSBButtonOptions;
begin
  result := TNSBButtonOptions(FElements[Index]);
end;

procedure TProgressRangeBar.SetBtnElementOptions(const Index: teBarElement;
  const Value: TNSBButtonOptions);
begin
  TNSBButtonOptions(FElements[Index]).Assign(Value);
end;

function TProgressRangeBar.GetTrackElementOptions(const Index: teBarElement): TNSBTrackOptions;
begin
  result := TNSBTrackOptions(FElements[Index]);
end;

procedure TProgressRangeBar.SetTrackBarMargin(const Value: Integer);
begin
  if fTrackBarMargin <> Value then begin
    if Value < 0 then fTrackBarMargin := 0 else
    if Value > Width then fTrackBarMargin := Width else
    fTrackBarMargin := Value;
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetTrackBarOptions(const Index: teBarElement;
  const Value: TNSBTrackOptions);
begin
  TNSBTrackOptions(FElements[Index]).Assign(Value);
end;

function TProgressRangeBar.GetHintArea: teHintArea;
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := ScreenToClient(P);
  if PtInRect(GetRectTrackButton, P) then
    result := haTrackBtn
  else
  if PtInRect(GetRectMinButton, P) then
    result := haMinBtn
  else if PtInRect(GetRectMaxButton, P) then
    result := haMaxBtn
  else result := haNotSpecified;
end;


{
  # -----------------------------------------------------------------
  # Internal Calculation of several Positions and Rectangle Areas
  # -----------------------------------------------------------------
}

function TProgressRangeBar.CenterOfRect(ARect: TRect): TPoint;
begin
  result.X := ARect.Left + (ARect.Width Div 2);
  result.Y := ARect.Top + (ARect.Height Div 2);
end;

// Main Trackbar
function TProgressRangeBar.GetRectTrackbar: TRect;
var
  TTop, TLeft: Integer;
begin

  if FOrientation = trHorizontal then begin
    if RangeActive then
      TTop := Height - ScaleValue(cFocusRectInflate + Math.max(Trackbar.FThickness, TrackButton.Thickness))
    else
      TTop := (Height - ScaleValue(TrackBar.Thickness)) Div 2;

    case FButtonMode of
      bmNested: Result := Bounds(ScaleValue(fTrackBarMargin), TTop, ClientWidth - ScaleValue(2*fTrackBarMargin), ScaleValue(TrackBar.Thickness));
      bmCentered: Result := Bounds(ScaleValue(fTrackBarMargin + (TrackButton.Length Div 2)), TTop, ClientWidth - ScaleValue(TrackButton.Length + 2*fTrackBarMargin), ScaleValue(TrackBar.Thickness));
    else
      Result := Bounds(0 , 0, ClientWidth, ClientHeight);
    end;
  end else begin
    if RangeActive then
      TLeft := Width - ScaleValue(cFocusRectInflate + Math.max(Trackbar.FThickness, TrackButton.Thickness))
    else
      TLeft := (Width - ScaleValue(TrackBar.Thickness)) Div 2;
    case FButtonMode of
      bmNested: Result := Bounds(TLeft, ScaleValue(fTrackBarMargin), ScaleValue(TrackBar.Thickness), ClientHeight - ScaleValue(2*fTrackBarMargin));
      bmCentered: Result := Bounds(TLeft, ScaleValue(fTrackBarMargin + (TrackButton.Length Div 2)), ScaleValue(TrackBar.Thickness), ClientHeight - ScaleValue(TrackButton.Length + 2*fTrackBarMargin));
    else
      Result := Bounds(0 , 0, ClientWidth, ClientHeight);
    end;
  end;
end;

// MinMaxRect: The part of the main Trackbar, where the Progress from FMin-FMax (0..1) is displayed
// This can be smaller for nested Buttons
function TProgressRangeBar.GetRectAvailableProgress: TRect;
begin
  Result := GetRectTrackbar;
  if FOrientation = trHorizontal then begin
    case FButtonMode of
      bmNested: InflateRect(Result, ScaleValue(-TrackButton.Length Div 2), 0);
      bmCentered: ;
    end;
  end else begin
    case FButtonMode of
      bmNested: InflateRect(Result, 0, ScaleValue(-TrackButton.Length Div 2));
      bmCentered: ;
    end;
  end;
end;

{
neue private properties
- allowRange   -> erlaubt das Setzen von RangeActive
- RangeActive  -> zeigt ggf. die zusätzliche Trackar an
- mainOffset
- RangeOffset
}

// Button on the main Trackbar
function TProgressRangeBar.GetRectTrackButton: TRect;
var
  ProgressSize, BtnTop, BtnLeft: Integer;
  MinMaxRect: TRect;
begin
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: begin
      ProgressSize := Round(FProgress * MinMaxRect.Width);
      BtnLeft := ProgressSize +  MinMaxRect.left - ScaleValue(TrackButton.Length Div 2);
      BtnTop := MinMaxRect.Top + (MinMaxRect.Height - ScaleValue(TrackButton.Thickness)) Div 2; // (Height - TrackButton.Thickness) Div 2;
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(TrackButton.Length), ScaleValue(TrackButton.Thickness));
    end;
    trVertical: begin
      ProgressSize := Round(FProgress * MinMaxRect.Height);
      BtnLeft := MinMaxRect.Left + (MinMaxRect.Width - ScaleValue(TrackButton.Thickness)) Div 2; // (Width - TrackButton.Thickness) Div 2;
      BtnTop := MinMaxRect.Bottom - ProgressSize - ScaleValue(TrackButton.Length Div 2);
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(TrackButton.Thickness), ScaleValue(TrackButton.Length));
    end;
  end;
end;

// The Progress on the main Trackbar
function TProgressRangeBar.GetRectProgress: TRect;
var
  ProgressSize, prgTop, prgLeft: Integer;
  TrackRect, MinMaxRect: TRect;
begin
  TrackRect := GetRectTrackbar;
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: begin
      ProgressSize := Round(FProgress * MinMaxRect.Width) + (MinMaxRect.Left - TrackRect.Left);
      prgLeft := TrackRect.Left;
      prgTop := MinMaxRect.Top + (MinMaxRect.Height - ScaleValue(ProgressBar.Thickness)) Div 2;
      // (Height - ProgressBar.Thickness) Div 2;
      Result := Bounds( prgLeft, prgTop, ProgressSize, ScaleValue(ProgressBar.Thickness));
    end;
    trVertical: begin
      ProgressSize := Round(FProgress * MinMaxRect.Height) + (TrackRect.Bottom - MinMaxRect.Bottom);
      prgLeft := MinMaxRect.Left + (MinMaxRect.Width - ScaleValue(ProgressBar.Thickness)) Div 2;; //(Width - ProgressBar.Thickness) Div 2;
      prgTop := TrackRect.Bottom - ProgressSize;
      Result := Bounds(prgLeft, prgTop, ScaleValue(ProgressBar.Thickness), ProgressSize);
    end;
  end;
end;


function TProgressRangeBar.GetRectRangebar: TRect;
var
  MinMaxRect: TRect;
  rTop, rLeft, rSize: Integer;
begin
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: begin
        rTop := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMin.FThickness, RangeBar.Thickness) - RangeBar.Thickness) Div 2);
        rLeft := Round(fRangeMinNorm * MinMaxRect.Width) + MinMaxRect.Left;
        rSize := Round((fRangeMaxNorm - fRangeMinNorm) * MinMaxRect.Width);
        Result := Bounds(rLeft, rTop, rSize, ScaleValue(RangeBar.Thickness));
    end;
    trVertical: begin
        rLeft := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMin.FThickness, RangeBar.Thickness) - RangeBar.Thickness) Div 2);
        rTop := MinMaxRect.Bottom - Round(fRangeMaxNorm * MinMaxRect.Height) ;
        rSize := Round((fRangeMaxNorm - fRangeMinNorm) * MinMaxRect.Height);
        Result := Bounds(rLeft, rTop, ScaleValue(RangeBar.Thickness), rSize);
    end;
  end;
end;

function TProgressRangeBar.GetRectMinButton: TRect;
var
  ProgressSize, BtnTop, BtnLeft, BtnHeight: Integer;
  MinMaxRect: TRect;
begin
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: begin // the button on the left
      ProgressSize := Round(FRangeMinNorm * MinMaxRect.Width);
      BtnLeft := ProgressSize +  MinMaxRect.left - ScaleValue(RangeButtonMin.Length);
      BtnTop := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMin.FThickness, RangeBar.Thickness) - RangeButtonMin.Thickness)  Div 2);
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(RangeButtonMin.Length), ScaleValue(RangeButtonMin.Thickness));
    end;
    trVertical: begin // the button on the bottom
      ProgressSize := Round(FRangeMinNorm * MinMaxRect.Height);
      BtnLeft := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMin.FThickness, RangeBar.Thickness) - RangeButtonMin.Thickness)  Div 2); //(Width - RangeButtonMin.Thickness) Div 2;
      BtnTop := MinMaxRect.Bottom - ProgressSize;
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(RangeButtonMin.Thickness), ScaleValue(RangeButtonMin.Length));
    end;
  end;
end;

function TProgressRangeBar.GetRectMaxButton: TRect;
var
  ProgressSize, BtnTop, BtnLeft: Integer;
  MinMaxRect: TRect;
begin
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: begin // the button on the right
      ProgressSize := Round(FRangeMaxNorm * MinMaxRect.Width);
      BtnLeft := ProgressSize +  MinMaxRect.left;
      BtnTop := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMax.FThickness, RangeBar.Thickness) - RangeButtonMax.Thickness)  Div 2);// (Height - RangeButtonMax.Thickness) Div 2;
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(RangeButtonMax.Length), ScaleValue(RangeButtonMax.Thickness));
    end;
    trVertical: begin // the button on the bottom
      ProgressSize := Round(FRangeMaxNorm * MinMaxRect.Height);
      BtnLeft := ScaleValue(cFocusRectInflate + (Math.max(RangeButtonMax.FThickness, RangeBar.Thickness) - RangeButtonMax.Thickness)  Div 2); //(Width - RangeButtonMax.Thickness) Div 2;
      BtnTop := MinMaxRect.Bottom - ProgressSize - ScaleValue(RangeButtonMax.Length);
      Result := Bounds(BtnLeft, BtnTop, ScaleValue(RangeButtonMax.Thickness), ScaleValue(RangeButtonMax.Length));
    end;
  end;
end;

procedure TProgressRangeBar.PrepareCanvas(const aCanvas: TCanvas; ElementOptions: TNSBElementOptions; aMouseIdx: Integer);
begin
  aCanvas.Brush.Style := bsSolid;
  aCanvas.Pen.Width := ElementOptions.FrameWidth;
  if not enabled then begin
    aCanvas.Brush.Color := ElementOptions.Colors.BrushDisabledColor;
    aCanvas.Pen.Color := ElementOptions.Colors.FrameDisabledColor;
  end else
    if ElementOptions.FMouseHover then begin
      aCanvas.Brush.Color := ElementOptions.Colors.BrushHighlightColor;
      aCanvas.Pen.Color := ElementOptions.Colors.FrameHighlightColor;
    end else begin
      aCanvas.Brush.Color := ElementOptions.Colors.BrushColor;
      aCanvas.Pen.Color := ElementOptions.Colors.FrameColor;
    end;
end;

procedure TProgressRangeBar.CheckFocusAndDrawIt(aButton: TNSBElementOptions; aCanvas: TCanvas; aRect: TRect);
begin
  if aButton.FFocussed then begin
    InflateRect(aRect, ScaleValue(cFocusRectInflate), ScaleValue(cFocusRectInflate));
    aCanvas.DrawFocusRect(aRect);
  end;
end;

procedure TProgressRangeBar.DoDrawTrack(const ACanvas: TCanvas);
var
  TrackRect: TRect;
  TrackDetails: TThemedElementDetails;
begin
  TrackRect := GetRectTrackbar;
  case Style of
    nsbStyleWindows: begin
          TrackDetails := GetThemeTrack;
          StyleServices(Self).DrawElement(aCanvas.Handle, TrackDetails, TrackRect, nil, CurrentPPI );
    end;
    nsbStyleSkinned: begin
          PrepareCanvas(aCanvas, TrackBar, 0);
          aCanvas.RoundRect(TrackRect.Left, TrackRect.Top, TrackRect.Right, TrackRect.Bottom, TrackBar.Radius, TrackBar.Radius);
    end;
  end;
end;

procedure TProgressRangeBar.DoDrawProgress(const ACanvas: TCanvas);
var
  ProgressRect: TRect;
  prgDetails: TThemedElementDetails;
begin
  ProgressRect := GetRectProgress;

  case Style of
    nsbStyleWindows: begin
          prgDetails := GetThemeProgress;
          StyleServices(Self).DrawElement(aCanvas.Handle, prgDetails, ProgressRect, nil, CurrentPPI );
    end;
    nsbStyleSkinned:  begin
          PrepareCanvas(aCanvas, ProgressBar, 0);
          aCanvas.RoundRect(ProgressRect.Left, ProgressRect.Top, ProgressRect.Right, ProgressRect.Bottom, ProgressBar.Radius, ProgressBar.Radius);
    end;
  end;
end;

procedure TProgressRangeBar.DoDrawRangeBar(const ACanvas: TCanvas);
var
  BarRect: TRect;
  BarDetails: TThemedElementDetails;
begin
  BarRect := GetRectRangebar;
  case Style of
    nsbStyleWindows: begin
        BarDetails := GetThemeProgress; //GetThemeTrack;
        StyleServices(Self).DrawElement(aCanvas.Handle, BarDetails, BarRect, nil, CurrentPPI );
    end;
    nsbStyleSkinned: begin

    end;
  end;

end;

procedure TProgressRangeBar.DoDrawButton(const ACanvas: TCanvas);
var
  ButtonRect: TRect;
  BtnDetails: TThemedElementDetails;
begin
  ButtonRect := GetRectTrackButton;
  case Style of
    nsbStyleWindows: begin
        BtnDetails := GetThemeTrackButton;//(TrackButton);
        StyleServices(Self).DrawElement(aCanvas.Handle, BtnDetails, ButtonRect, nil, CurrentPPI );
        CheckFocusAndDrawIt(TrackButton, aCanvas, ButtonRect);
    end;
    nsbStyleSkinned: begin
        PrepareCanvas(aCanvas, TrackButton, 1);
        aCanvas.RoundRect(ButtonRect.Left, ButtonRect.Top, ButtonRect.Right, ButtonRect.Bottom, TrackButton.Radius, TrackButton.Radius);
        CheckFocusAndDrawIt(TrackButton, aCanvas, ButtonRect);
    end;
  end;
end;

procedure TProgressRangeBar.DoDrawRangeButtons(const ACanvas: TCanvas);
var
  ButtonRect: TRect;
  BtnDetails: TThemedElementDetails;
  copyDiff: Integer;
begin
  case Style of
    nsbStyleWindows: begin
        ButtonRect := GetRectMinButton;
        BtnDetails := GetThemeMinButton;
        // GetThemeButton(RangeButtonMin);

          if assigned(MinBtnGlyphh.Graphic) then begin
            aCanvas.Draw(ButtonRect.Left, ButtonRect.Top, MinBtnGlyphh.Graphic);
          //  CheckFocusAndDrawIt(RangeButtonMin, aCanvas, ButtonRect);
          end else begin
            StyleServices(Self).DrawElement(aCanvas.Handle, BtnDetails, ButtonRect, nil, CurrentPPI );
          end;


          //copyDiff := ButtonRect.Height + Trackbar.FThickness;
          //ButtonRect.Top := ButtonRect.Top + copyDiff;
          //ButtonRect.Bottom := ButtonRect.Bottom + copyDiff;
          //StyleServices(Self).DrawElement(aCanvas.Handle, BtnDetails, ButtonRect, nil, CurrentPPI );
          CheckFocusAndDrawIt(RangeButtonMin, aCanvas, ButtonRect);

        ButtonRect := GetRectMaxButton;
        // BtnDetails := GetThemeMaxButton; //GetThemeButton(RangeButtonMax);
        StyleServices(Self).DrawElement(aCanvas.Handle, GetThemeMaxButton, ButtonRect, nil, CurrentPPI );
        //end;
        CheckFocusAndDrawIt(RangeButtonMax, aCanvas, ButtonRect);
    end;
    nsbStyleSkinned: begin
        ButtonRect := GetRectMinButton;
        PrepareCanvas(aCanvas, RangeButtonMin, 2);
        aCanvas.RoundRect(ButtonRect.Left, ButtonRect.Top, ButtonRect.Right, ButtonRect.Bottom, RangeButtonMin.Radius, RangeButtonMin.Radius);
        CheckFocusAndDrawIt(RangeButtonMin, aCanvas, ButtonRect);
        ButtonRect := GetRectMaxButton;;
        PrepareCanvas(aCanvas, RangeButtonMax, 3);
        aCanvas.RoundRect(ButtonRect.Left, ButtonRect.Top, ButtonRect.Right, ButtonRect.Bottom, RangeButtonMax.Radius, RangeButtonMax.Radius);
        CheckFocusAndDrawIt(RangeButtonMax, aCanvas, ButtonRect);
    end;
  end;
end;


function TProgressRangeBar.WantDrawTrack: Boolean;
begin
  case TrackBar.VisibleMode of
    vNever: result := False;
    vAlways: result := True;
    vHover: result := TrackBar.FMouseHover or Focused;
  else
    result := True;
  end;
end;

function TProgressRangeBar.WantDrawProgress: Boolean;
begin
  case ProgressBar.VisibleMode of
    vNever: result := False;
    vAlways: result := True;
    vHover: result := ProgressBar.FMouseHover or Focused;
  else
    result := True;
  end;
end;

function TProgressRangeBar.WantDrawButton: Boolean;
begin
  case TrackButton.VisibleMode of
    vNever: result := False;
    vAlways: result := True;
    vHover: result := TrackButton.FMouseHover or Focused;
  else
    result := True;
  end;
end;

function TProgressRangeBar.WantDrawRangeBar: Boolean;
begin
  result := fRangeActive;
end;

function TProgressRangeBar.WantDrawRangeButtons: Boolean;
begin
  result := fRangeActive;
end;

procedure TProgressRangeBar.Paint;
begin
  inherited;

  //StyleServices.DrawParentBackground(Handle, FBuffer.Canvas.Handle, nil, False);
  DrawParentImage(self, FParentBuffer.Canvas);
  BitBlt(FBuffer.Canvas.Handle, 0, 0, Width, Height, FParentBuffer.Canvas.Handle, 0, 0, SRCCOPY);

  if WantDrawTrack then
    DoDrawTrack(FBuffer.Canvas);

  if WantDrawProgress then
    DoDrawProgress(FBuffer.Canvas);

  if WantDrawRangeBar then
    DoDrawRangeBar(FBuffer.Canvas);

  if WantDrawButton then
    DoDrawButton(FBuffer.Canvas);

  if WantDrawRangeButtons then
    DoDrawRangeButtons(FBuffer.Canvas);

  SwapCanvas;
end;

procedure TProgressRangeBar.SetFocussedBtn(Index: teScrollButton);
begin
  FFocussedButtonIdx := Index;
  TrackButton.FFocussed := Index = btnTrack;
  RangeButtonMin.FFocussed := Index = btnMin;
  RangeButtonMax.FFocussed := Index = btnMax;
  Invalidate;
end;

procedure TProgressRangeBar.ToggleFocussedBtn;
begin
  case FFocussedButtonIdx of
    btnNone : SetFocussedBtn(btnTrack);
    btnTrack: SetFocussedBtn(btnMin);
    btnMin  : SetFocussedBtn(btnMax);
    btnMax  : SetFocussedBtn(btnTrack);
  end;
end;

function TProgressRangeBar.GetActiveButton: TNSBElementOptions;
begin
  result := Nil;
  if TrackButton.FMouseHover then result := TrackButton
  else if RangeButtonMin.FMouseHover then result := RangeButtonMin
  else if RangeButtonMax.FMouseHover then result := RangeButtonMax;
end;

procedure TProgressRangeBar.InternalMouseMove(Shift: TShiftState; X,
  Y: Integer);
var
  RMin, RMax, RTrack: TRect;
  cMin, cMax, xy: TPoint;
  distMin, distMax: Integer;
  currentBtn: TNSBElementOptions;
  newHintArea: teHintArea;
begin
  currentBtn := GetActiveButton;

  // Get the nearest Button and set its FMouseHover property
  xy := Point(x, y);
  RTrack := GetRectTrackButton;
  if (not RangeActive) or PtInRect(RTrack, xy) then begin
    TrackButton.FMouseHover := True;
    RangeButtonMin.FMouseHover := False;
    RangeButtonMax.FMouseHover := False;
    if PtInRect(rTrack, xy) then
      newHintArea := haTrackBtn
    else
      newHintArea := haNotSpecified;
  end else
  begin
    RMin := GetRectMinButton;
    RMax := GetRectMaxButton;
    //InflateRect(RMin, 4, 4);
    //InflateRect(RMax, 4, 4);
    if PtInRect(RMin, xy) or PtInRect(RMax, xy) then begin
      //cMin := CenterOfRect(RMin);
      //cMax := CenterOfRect(RMax);
      // Manhattan-Distance is sufficient here, no need for Pytagoras :-)
      //distMin := abs(cMin.X - X) + abs(cMin.Y - y);
      //distMax := abs(cMax.X - X) + abs(cMax.Y - y);
      TrackButton.FMouseHover := False;
      RangeButtonMin.FMouseHover := PtInRect(RMin, xy);  // not TrackButton.FMouseHover and (distMin < distMax);
      RangeButtonMax.FMouseHover := PtInRect(RMax, xy); //not TrackButton.FMouseHover and (distMin >= distMax);

      if RangeButtonMin.FMouseHover then
        newHintArea := haMinBtn
      else
        newHintArea := haMaxBtn;

    end else begin
      RangeButtonMin.FMouseHover := False;
      RangeButtonMax.FMouseHover := False;
      TrackButton.FMouseHover := True;
      newHintArea := haNotSpecified;
    end;
  end;
  if currentBtn <> GetActiveButton then
    Invalidate;

  if (newHintArea <> FCurrentHintArea)
  and (newHintArea <> haNotSpecified)
  then
    Application.ActivateHint(Mouse.CursorPos);

    //Application.CancelHint;
end;

procedure TProgressRangeBar.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Visible and Enabled then begin
    Application.CancelHint;
    if Button = mbLeft then begin
      FMouseDelta := DoStartScroll(X, Y);
      if CanFocus then begin
        SetFocus;
        Invalidate;
      end;
    end else
    if Button = mbRight then begin
      if (FDownButtonIdx <> btnNone) then
        DoCancelScroll;
    end;
  end;
  inherited;
end;

procedure TProgressRangeBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDownButtonIdx <> btnNone then
    DoScroll(X - FMouseDelta.X, Y - FMouseDelta.Y)
  else begin
    InternalMouseMove(Shift, X, Y);
  end;
  inherited;
end;

procedure TProgressRangeBar.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDownButtonIdx <> btnNone then
    DoEndScroll;
  inherited;
end;


procedure TProgressRangeBar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT: if FOrientation = trHorizontal then ChangePosition(-FSmallStep);
    VK_RIGHT: if FOrientation = trHorizontal then ChangePosition(FSmallStep);
    VK_UP: if FOrientation = trVertical then ChangePosition(FSmallStep);
    VK_DOWN: if FOrientation = trVertical then ChangePosition(-FSmallStep);
    VK_Prior: ChangePosition(FLargeStep);
    VK_Next: ChangePosition(-FLargeStep);
    VK_Space: ToggleFocussedBtn;
  end;
  inherited;
end;

procedure TProgressRangeBar.SetMax(Value: Integer);
begin
  if Value <> FMax then begin
    FMax := Value;
    if FMin > FMax then
      FMin := FMax;
    ValidatePosition;
    Invalidate;
  end;
end;


procedure TProgressRangeBar.SetMin(Value: Integer);
begin
  if Value <> FMin then begin
    FMin := Value;
    if FMax < FMin then
      FMax := FMin;
    ValidatePosition;
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetOrientation(const Value: TTrackBarOrientation);
begin
  if Value <> FOrientation then begin
    FOrientation := Value;
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetAllowRange(const Value: Boolean);
begin
  if fAllowRange <> Value then begin
    fAllowRange := Value;
    if not fAllowRange then
      RangeActive := False
  end;
end;

procedure TProgressRangeBar.SetRangeActive(const Value: Boolean);
begin
  if fRangeActive <> Value then begin
    fRangeActive := Value;
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetButtonMode(const Value: teNSBButtonProgressMode);
begin
  if FButtonMode <> Value then begin
    FButtonMode := Value;
    Invalidate;
  end;
end;


procedure TProgressRangeBar.SetSmallStep(Value: Integer);
begin
  if Value < 1 then
    Value := 1
  else
    if Value > (FMax - FMin) then
      Value := (FMax - FMin);
  if Value <> FSmallStep then
    FSmallStep := Value;
end;

procedure TProgressRangeBar.SetStyle(const Value: teNSBStyle);
begin
  if fStyle <> Value then begin
    fStyle := Value;
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetMaxBtnGlyphh(const Value: TPicture);
begin
  FMaxBtnGlyphh.Assign(Value);
end;

procedure TProgressRangeBar.SetMinBtnGlyphh(const Value: TPicture);
begin
  FMinBtnGlyphh.Assign(Value);
end;

procedure TProgressRangeBar.SetTrackBtnGlyph(const Value: TPicture);
begin
  FTrackBtnGlyph.Assign(Value);
end;

procedure TProgressRangeBar.SwapCanvas;
begin
  BitBlt(Canvas.Handle, 0, 0, Width, Height, FBuffer.Canvas.Handle, 0, 0, SRCCOPY);
end;

procedure TProgressRangeBar.UpdateSize;
begin
  FBuffer.SetSize(Width, Height);
  FParentBuffer.SetSize(Width, Height);
  DrawParentImage(self, FParentBuffer.Canvas);
end;

procedure TProgressRangeBar.SetLargeStep(Value: Integer);
begin
  if Value < 1 then
    Value := 1
  else
    if Value > (FMax - FMin) then
      Value := (FMax - FMin);
  if Value <> FLargeStep then
    FLargeStep := Value;
end;

function TProgressRangeBar.ValidateMinNorm(newValue: Double): Double;
begin
  result := newValue;
  if result < 0 then result := 0;
  if result > fRangeMaxNorm then result := fRangeMaxNorm;
end;

function TProgressRangeBar.ValidateMaxNorm(newValue: Double): Double;
begin
  result := newValue;
  if result > 1 then result := 1;
  if result < fRangeMinNorm then result := fRangeMinNorm;
end;


procedure TProgressRangeBar.ValidatePosition;
begin
  (*
  ## todo:
  ## in den Nachfahren mit einem Button verschieben
  if FPosition < Min then
    FPosition := Min
  else
    if FPosition > Max then
      FPosition := Max;

  if FDefaultPosition < Min then FDefaultPosition := Min
  else if FDefaultPosition > Max then FDefaultPosition := Max;
  *)
end;

procedure TProgressRangeBar.ChangePosition(const Delta: Integer);

  procedure DoOnStep(ScrollPos: Integer; ScrollPosNorm: Double);
  begin
    if assigned(self.FOnStep) then
      FOnStep(self, FFocussedButtonIdx, ScrollPos, ScrollPosNorm);
  end;

begin
  case FFocussedButtonIdx of
    btnTrack: begin
        Position := Position + Delta;
        DoOnStep(Position, Progress)
    end;
    btnMin: begin
        RangeMin := RangeMin + Delta;
        DoOnStep(RangeMin, RangeMinNorm);
    end;
    btnMax: begin
        RangeMax := RangeMax + Delta;
        DoOnStep(RangeMax, RangeMaxNorm);
    end;
  end;
end;


function TProgressRangeBar.PointToProgress(const X, Y: Integer): Double;
var
  MinMaxRect: TRect;
begin
  MinMaxRect := GetRectAvailableProgress;
  if Orientation = trHorizontal then begin
    if x < MinMaxRect.Left then result := 0
    else if x > MinMaxRect.Right then result := 1
    else if MinMaxRect.Width = 0 then result := 1
    else result := (x - MinMaxRect.Left) / MinMaxRect.Width;
  end else begin
    if y < MinMaxRect.Top then result := 1
    else if y > MinMaxRect.Bottom then result := 0
    else if MinMaxRect.Height = 0 then result := 0
    else result := (MinMaxRect.Height - (y - MinMaxRect.Top)) / MinMaxRect.Height;
  end;
end;

function TProgressRangeBar.DoStartScroll(const X, Y: Integer): TPoint;
var
  ButtonPoint: TPoint;
  ButtonRect: TRect;
  NewProgress: Double;
  currentBtn: TNSBElementOptions;

  function DoStartTrackScroll(const X, Y: Integer): TPoint;
  begin
    if Assigned(FOnStartScroll) then FOnStartScroll(Self, btnTrack);
    FDownButtonIdx := btnTrack;
    SetFocussedBtn(btnTrack);
    if not PtInRect(ButtonRect, Point(x,y)) then begin
      // clicked outside the button
      NewProgress := PointToProgress(X, Y);
      if NewProgress <> FProgress then begin
        FProgress := NewProgress;
        FPosition := NormToMinmax(FProgress);
        Invalidate;
        if Assigned(FOnScroll) then FOnScroll(Self, btnTrack, FPosition, FProgress);
        if Assigned(FOnChange) then FOnChange(Self);
      end;
      ButtonRect := GetRectTrackButton;
      ButtonPoint := CenterOfRect(ButtonRect);
    end;
    Result.X := X - ButtonPoint.X;
    Result.Y := Y - ButtonPoint.Y;
  end;

  function DoStartMinScroll(const X, Y: Integer): TPoint;
  begin
    if Assigned(FOnStartScroll) then FOnStartScroll(Self, btnMin);
    FDownButtonIdx := btnMin;
    SetFocussedBtn(btnMin);
    ButtonPoint.X := ButtonPoint.X + (RangeButtonMin.FLength Div 2);
    ButtonPoint.Y := ButtonPoint.Y - (RangeButtonMin.FLength Div 2);
    Result.X := X - ButtonPoint.X;
    Result.Y := Y - ButtonPoint.Y;
  end;

  function DoStartMaxScroll(const X, Y: Integer): TPoint;
  begin
    if Assigned(FOnStartScroll) then FOnStartScroll(Self, btnMax);
    FDownButtonIdx := btnMax;
    SetFocussedBtn(btnMax);
    ButtonPoint.X := ButtonPoint.X - (RangeButtonMax.FLength Div 2);
    ButtonPoint.Y := ButtonPoint.Y + (RangeButtonMax.FLength Div 2);
    Result.X := X - ButtonPoint.X;
    Result.Y := Y - ButtonPoint.Y;
  end;

begin
  currentBtn := GetActiveButton;

  if currentBtn = TrackButton then ButtonRect := GetRectTrackButton
  else if currentBtn = RangeButtonMin then
    ButtonRect := GetRectMinButton
  else if currentBtn = RangeButtonMax then
    ButtonRect := GetRectMaxButton;

  ButtonPoint := CenterOfRect(ButtonRect);
  // ButtonPoint.X := ButtonPoint.X;
  if currentBtn = TrackButton then result := DoStartTrackScroll(X,Y)
  else if currentBtn = RangeButtonMin then result := DoStartMinScroll(X,Y)
  else if currentBtn = RangeButtonMax then result := DoStartMaxScroll(X,Y)
  else begin // should never happen ...
    FDownButtonIdx := btnNone;
    result := Point(0,0);
  end;
end;

procedure TProgressRangeBar.DoScroll(const X, Y: Integer);
var
  NewProgress, newValue: Double;
  t: Integer;
begin
  case FDownButtonIdx of
    btnTrack: begin
        NewProgress := PointToProgress(X, Y);
        if NewProgress <> FProgress then begin
          FProgress := NewProgress;
          FPosition := NormToMinmax(FProgress);
          Invalidate;
          if Assigned(FOnScroll) then FOnScroll(Self, btnTrack, FPosition, FProgress);
          if Assigned(FOnChange) then FOnChange(Self);
        end;
    end;
    btnMin: begin
        newValue := PointToProgress(X, Y);
        if newValue <> fRangeMinNorm then begin
          fRangeMinNorm := ValidateMinNorm(newValue);
          FRangeMin := NormToMinMax(FRangeMinNorm);
          Invalidate;
          if Assigned(FOnScroll) then FOnScroll(Self, btnMin, FRangeMin, fRangeMinNorm);
          if Assigned(FOnChange) then FOnChange(Self);
        end;
    end;

    btnMax: begin
        newValue := PointToProgress(X, Y);
        if newValue <> fRangeMaxNorm then begin
          fRangeMaxNorm := ValidateMaxNorm(newValue);
          FRangeMax := NormToMinMax(FRangeMaxNorm);
          Invalidate;
          if Assigned(FOnScroll) then FOnScroll(Self, btnMax, FRangeMax, fRangeMaxNorm);
          if Assigned(FOnChange) then FOnChange(Self);
        end;
    end;
  end;
end;

procedure TProgressRangeBar.DoEndScroll;
begin
  if Assigned(FOnEndScroll) then
    FOnEndScroll(self, FDownButtonIdx);
  FDownButtonIdx := btnNone;
  Invalidate;
end;

procedure TProgressRangeBar.DoCancelScroll;
begin
  if assigned(fOnCancelScroll) then
    fOnCancelScroll(self, FDownButtonIdx);
  FDownButtonIdx := btnNone;
  Invalidate;
end;

procedure TProgressRangeBar.SetDefaultPosition(const Value: Integer);
begin
  FDefaultPosition := Value;
end;

function TProgressRangeBar.NormToMinmax(const Value: Double): Integer;
begin
  if FMax > FMin then
    result := Round(Value * (FMax - FMin) + FMin)
  else
    result := fMin;
end;

function TProgressRangeBar.MinMaxToNorm(const Value: Integer): Double;
begin
  if FMax > FMin then
    result := (Value - FMin) / (FMax - FMin)
  else
    result := 1;
end;

function TProgressRangeBar.NeedRepaint(const PreviousProgress: Double): Boolean;
var
  MinMaxRect: TRect;
begin
  MinMaxRect := GetRectAvailableProgress;
  case FOrientation of
    trHorizontal: result := Round(FProgress * MinMaxRect.Width) <> Round(PreviousProgress * MinMaxRect.Width);
    trVertical: result := Round(FProgress * MinMaxRect.Height) <> Round(PreviousProgress * MinMaxRect.Height);
  else
    result := false;
  end;
end;


procedure TProgressRangeBar.SetPosition(const Value: Integer);
var
  PreviousProgress: Double;
begin
  if FPosition <> Value then begin
    PreviousProgress := FProgress;
    if Value < FMin then FPosition := FMin
    else if Value > FMax then FPosition := FMax
    else  FPosition := Value;
    // Sync with FProgress
    FProgress := MinMaxToNorm(FPosition);
    if NeedRepaint(PreviousProgress) then
      Invalidate;
  end;
end;

procedure TProgressRangeBar.SetProgress(const Value: Double);
var
  PreviousProgress: Double;
begin
  if FProgress <> Value then begin
    PreviousProgress := FProgress;
    if Value < 0 then FProgress := 0
    else if Value > 1 then FProgress := 1
    else FProgress := Value;
     // Sync with FPosition
    FPosition := NormToMinmax(FProgress);
    if NeedRepaint(PreviousProgress) then
      Invalidate;
  end;
end;

procedure TProgressRangeBar.SetRangeMin(const Value: Integer);
begin
  if FRangeMin <> Value then begin
    if Value < FMin then FRangeMin := FMin
    else if Value > FRangeMax then FRangeMin := FRangeMax
    else FRangeMin := Value;
    FRangeMinNorm := MinmaxToNorm(FRangeMin);
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetRangeMinNorm(const Value: Double);
begin
  if FRangeMinNorm <> Value then begin
    if Value < 0 then FRangeMinNorm := 0
    else if Value > FRangeMaxNorm then FRangeMinNorm := FRangeMaxNorm
    else FRangeMinNorm := Value;
    FRangeMin := NormToMinmax(FRangeMinNorm);
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetRangeMax(const Value: Integer);
begin
  if FRangeMax <> Value then begin
    if Value < FRangeMin then FRangeMax := FRangeMin
    else if Value > FMax then FRangeMax := FMax
    else FRangeMax := Value;
    FRangeMaxNorm := MinmaxToNorm(FRangeMax);
    Invalidate;
  end;
end;

procedure TProgressRangeBar.SetRangeMaxNorm(const Value: Double);
begin
  if FRangeMaxNorm <> Value then begin
    if Value < FRangeMinNorm then FRangeMaxNorm := FRangeMinNorm
    else if Value > 1 then FRangeMaxNorm := 1
    else FRangeMaxNorm := Value;
    FRangeMax := NormToMinmax(FRangeMaxNorm);
    Invalidate;
  end;
end;

{ TNSBElementOptions }

procedure TNSBElementOptions.Assign(Source: TPersistent);
begin
  if Source is TNSBElementOptions then
  begin
    FOWner       := TNSBElementOptions(Source).FOWner;
    FFrameWidth  := TNSBElementOptions(Source).FFrameWidth;
    FRadius      := TNSBElementOptions(Source).FRadius;
    FVisibleMode := TNSBElementOptions(Source).FVisibleMode;
    FColors.Assign(TNSBElementOptions(Source).FColors);
  end
  else
    inherited;
end;

constructor TNSBElementOptions.Create(aOwner: TProgressRangeBar);
begin
  inherited create;
  FOwner := aOwner;
  fColors := TTBColors.Create(aOwner);
  FFrameWidth := 1;
  FRadius := 4;
  FVisibleMode := vAlways;
  // FFocusDrawType := nsbFDTWindows;
  FMouseDown := False;
  FMouseHover := False;
  FFocussed := False;
end;

destructor TNSBElementOptions.Destroy;
begin
  fColors.Free;
  inherited;
end;

procedure TNSBElementOptions.SetColors(const Value: TTBColors);
begin
  FColors.Assign(Value);
end;

procedure TNSBElementOptions.SetVisibleMode(const Value: teNSBVisibleMode);
begin
  if FVisibleMode <> Value then begin
    FVisibleMode := Value;
    FOwner.Invalidate;
  end;
end;

(*procedure TNSBElementOptions.SetFocusDrawType(const Value: teNSBFocusDrawType);
begin
  if FFocusDrawType <> Value then begin
    FFocusDrawType := Value;
    FOwner.Invalidate;
  end;
end;*)

procedure TNSBElementOptions.SetFrameWidth(const Value: Integer);
begin
  if FFrameWidth <> Value then begin
    FFrameWidth := max(Value, 0);
    FOwner.Invalidate;
  end;
end;

procedure TNSBElementOptions.SetRadius(const Value: Integer);
begin
  if FRadius <> Value then begin
    FRadius := max(Value, 0);
    FOwner.Invalidate;
  end;
end;

{ TNSBTrackOptions }

procedure TNSBTrackOptions.Assign(Source: TPersistent);
begin
  if Source is TNSBTrackOptions then
  begin
    inherited;
    FThickness := TNSBButtonOptions(Source).FThickness;
  end
  else
    inherited;
end;

constructor TNSBTrackOptions.Create(aOwner: TProgressRangeBar);
begin
  inherited;
  FThickness := cDefaultTrackThickNess;
end;

procedure TNSBTrackOptions.SetThickness(const Value: Integer);
begin
  if FThickness <> Value then begin
    FThickness := max(Value, 0);
    FOwner.Invalidate;
  end;
end;

{ TNSBButtonOptions }

procedure TNSBButtonOptions.Assign(Source: TPersistent);
begin
  if Source is TNSBButtonOptions then
  begin
    inherited;
    FThickness := TNSBButtonOptions(Source).FThickness;
    FLength := TNSBButtonOptions(Source).FLength;
  end
  else
    inherited;
end;

constructor TNSBButtonOptions.Create(aOwner: TProgressRangeBar);
begin
  inherited;
  FThickness := cDefaultTrackBtnThickNess;
  fLength := cDefaultTrackBtnLength;
  VisibleMode := vAlways;
end;

procedure TNSBButtonOptions.SetLength(const Value: Integer);
begin
  if FLength <> Value then begin
    FLength := max(Value, 0);
    FOwner.Invalidate;
  end;
end;

procedure TNSBButtonOptions.SetThickness(const Value: Integer);
begin
  if FThickness <> Value then begin
    FThickness := max(Value, 0);
    FOwner.Invalidate;
  end;
end;

{ TTBColors }

procedure TTBColors.Assign(Source: TPersistent);
begin
  if Source is TTBColors then
    FColors := TTBColors(Source).FColors
  else
    inherited;
end;

constructor TTBColors.Create(aOwner: TProgressRangeBar);
begin
  inherited create;
  fOwner := aOwner;
  SetDefaultColors;
end;

function TTBColors.GetColor(const Index: teNSBColors): TColor;
begin
  Result := FColors[Index];
end;

procedure TTBColors.SetColor(const Index: teNSBColors; const Value: TColor);
begin
  if FColors[Index] <> Value then begin
    FColors[Index] := Value;
    if not (csLoading in FOwner.ComponentState) then
      FOwner.Invalidate;
  end;
end;

procedure TTBColors.SetDefaultColors;
begin
  for var i: teNSBColors := Low(teNSBColors) to High(teNSBColors) do
    FColors[i] := cDefaultColors[i];
end;


procedure Register;
begin
  RegisterComponents('Nemp Components', [TProgressRangeBar]);
end;


end.
