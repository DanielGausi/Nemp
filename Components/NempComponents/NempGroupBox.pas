unit NempGroupBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Messages;

type
  TNempGroupBox = class(TGroupBox)
  private
    { Private-Deklarationen }
    FOnPaint: TNotifyEvent;
    FOwnerDraw: Boolean;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    { Protected-Deklarationen }
    procedure Paint; override;

  public
    { Public-Deklarationen }
    property Canvas;
  published
    { Published-Deklarationen }
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
  end;

procedure Register;

implementation

procedure TNempGroupBox.Paint;
begin
  if FOwnerDraw AND Assigned(FOnPaint) then
    FOnPaint(Self)
  else
    inherited paint;
end;

procedure TNempGroupBox.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if FOwnerDraw AND Assigned(FOnPaint) then
    Message.Result := 1
  else
    inherited
end;

procedure Register;
begin
  RegisterComponents('Beispiele', [TNempGroupBox]);
end;

end.
