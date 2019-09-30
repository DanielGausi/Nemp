unit ProgressShape;

interface

uses
  Windows, SysUtils, Classes, Controls, Messages, VCL.extctrls, Vcl.Graphics ;

type
  //TMouseWheelEvent = procedure(Sender: TObject; delta: Word) of object;


  TProgressShape = class(TShape)
  private
    { Private-Deklarationen }
    FProgressPen: TPen;
    FProgressBrush: TBrush;
    fProgress: Double;    // value 0...1

    fLastNewPaintWidth: Integer; // to reduce repaints

    procedure SetProgressBrush(Value: TBrush);
    procedure SetProgressPen(Value: TPen);
    procedure SetProgress(Value: Double);

    //FOnPaint: TNotifyEvent;
    //FOnAfterPaint: TNotifyEvent;
    //FOnMouseWheel: TMouseWheelEvent;

    //FOwnerDraw: Boolean;
    //procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    //procedure WMMouseWheel(var Message: TMessage); message WM_MouseWheel;
  protected
    { Protected-Deklarationen }
    //procedure Paint; override;
    procedure Paint; override;
  public
    { Public-Deklarationen }
    //property Canvas;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    { Published-Deklarationen }
    property ProgressPen: TPen read FProgressPen write SetProgressPen;
    property ProgressBrush: TBrush read FProgressBrush write SetProgressBrush;
    property Progress: Double read fProgress write SetProgress;

    //property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    //property OnAfterPaint: TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
    //property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
    //property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    //property OnMouseWheelUp;
    //property OnMouseWheelDown;
  end;

procedure Register;

implementation

(*
procedure TNempPanel.Paint;
begin
//  inherited paint;
  if FOwnerDraw AND Assigned(FOnPaint) then
    FOnPaint(Self)
  else
    inherited;

  if Assigned(FOnAfterPaint) then
      FOnAfterPaint(Self);
end;

procedure TNempPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if FOwnerDraw AND Assigned(FOnPaint) then
    Message.Result := 1
  else
    inherited
end;
*)



procedure Register;
begin
  RegisterComponents('Beispiele', [TProgressShape]);
end;

{ TProgressShape }

// copied from the VCL, extended by the "progress part"
constructor TProgressShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProgressPen := TPen.Create;
  FProgressPen.OnChange := StyleChanged;
  FProgressBrush := TBrush.Create;
  FProgressBrush.OnChange := StyleChanged;
end;

destructor TProgressShape.Destroy;
begin
  FProgressPen.Free;
  FProgressBrush.Free;
  inherited;
end;

procedure TProgressShape.Paint;
var
  X, Y, W, H, S: Integer;
begin
  with Canvas do
  begin
    Pen := Self.Pen;
    Brush := Self.Brush;
    X := Pen.Width div 2;
    Y := X;
    W := Width - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    case Self.Shape of
      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
    end;
  end;

  // progresspart, for now: Quick&Dirty only for rectangular horizontal shapes <============>
  with Canvas do
  begin
    Pen := fProgressPen;
    Brush := fProgressBrush;
    X := fProgressPen.Width div 2;
    Y := X;
    fLastNewPaintWidth := Round(Width * fProgress );
    W := fLastNewPaintWidth - Pen.Width + 1;
    H := Height - Pen.Width + 1;
    if Pen.Width = 0 then
    begin
      Dec(W);
      Dec(H);
    end;
    if W < H then S := W else S := H;
    if Self.Shape in [stSquare, stRoundSquare, stCircle] then
    begin
      Inc(X, (W - S) div 2);
      Inc(Y, (H - S) div 2);
      W := S;
      H := S;
    end;
    case Self.Shape of
      stRectangle, stSquare:
        Rectangle(X, Y, X + W, Y + H);
      stRoundRect, stRoundSquare:
        RoundRect(X, Y, X + W, Y + H, S div 4, S div 4);
      stCircle, stEllipse:
        Ellipse(X, Y, X + W, Y + H);
    end;
  end;


end;


procedure TProgressShape.SetProgress(Value: Double);
var NewPaintWidth: Integer;
begin
  fProgress := Value;

  NewPaintWidth := Round(Width * fProgress);

  if fLastNewPaintWidth <> NewPaintWidth then
      Invalidate;
end;

procedure TProgressShape.SetProgressBrush(Value: TBrush);
begin
    FProgressBrush.Assign(Value);
end;

procedure TProgressShape.SetProgressPen(Value: TPen);
begin
    FProgressPen.Assign(Value);
end;


end.
