unit NempPanel;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Messages ;

type
  //TMouseWheelEvent = procedure(Sender: TObject; delta: Word) of object;


  TNempPanel = class(TPanel)
  private
    { Private-Deklarationen }
    FOnPaint: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    //FOnMouseWheel: TMouseWheelEvent;

    FOwnerDraw: Boolean;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    //procedure WMMouseWheel(var Message: TMessage); message WM_MouseWheel;
  protected
    { Protected-Deklarationen }
    procedure Paint; override;
  public
    { Public-Deklarationen }
    property Canvas;

  published
    { Published-Deklarationen }
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnAfterPaint: TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
    //property OnMouseWheel: TMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;

procedure Register;

implementation

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


        {
procedure TNempPanel.WMMouseWheel(var Message: TMessage);

begin
    inherited;
    if Assigned(FOnMouseWheel) then
        FOnMouseWheel(self, hiWord(Message.wParam));
end;        }

procedure Register;
begin
  RegisterComponents('Beispiele', [TNempPanel]);
end;

end.
