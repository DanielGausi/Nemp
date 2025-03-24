unit uNempHintWindow;

interface

uses
  Windows, Classes, System.Types, Messages, Graphics, VCL.Controls, Vcl.Themes, Dialogs;


type
  PNempHintData = ^TNempHintData;

  TNempShowSimpleHintEvent = procedure(Sender: TObject; var HintText: String; var OwnerDraw: Boolean) of object;
  TNempDrawHintEvent = procedure(Sender: TObject; HintCanvas: TCanvas; R: TRect; AData: PNempHintData) of object;
  TNempCalcHintEvent = procedure(var Rect: TRect; MaxWidth: Integer; const AHint: string; AData: PNempHintData) of object;

  TNempHintData = record
    HintRect: TRect;
    HintText: string;
    // BidiMode: TBidiMode;
    // Alignment: TAlignment;
    OnDrawHint: TNempDrawHintEvent;
    OnGetHintSize: TNempCalcHintEvent;
    Control: TControl;
    Tag: Integer; // some additional value, may be used in OnDrawHint
  end;

  TNempHintWindow = class(THintWindow)
  strict private
    FHintData: TNempHintData;
    FTextHeight: Integer;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    //procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
  strict protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override;
  end;

  function GetHintWindowClass(doOwnerDraw: Boolean): THintWindowClass;

implementation

function GetHintWindowClass(doOwnerDraw: Boolean): THintWindowClass;
begin
  if doOwnerDraw then
    result := TNempHintWindow
  else
    result := THintWindow;
end;

{ TNempHintWindow }

function TNempHintWindow.CalcHintRect(MaxWidth: Integer; const AHint: string;
  AData: Pointer): TRect;
begin
  FHintData := PNempHintData(AData)^;
  if assigned(FHintData.OnGetHintSize) then
    FHintData.OnGetHintSize(result, MaxWidth, AHint, AData)
  else
    result := inherited;

  // procedure(var Rect: TRect; MaxWidth: Integer; const AHint: string; AData: Pointer) of object;
  // todo
  (*
      with FHintData do
      begin
        // The draw tree gets its hint size by the application (but only if not a header hint is about to show).
        // If the user will be drawing the hint, it gets its hint size by the application
        // (but only if not a header hint is about to show).
        // This size has already been determined in CMHintShow.
        if Assigned(Node) and (not IsRectEmpty(HintRect)) then
          Result := HintRect
        else
        begin
           ..
        end
  *)
end;

procedure TNempHintWindow.CMTextChanged(var Message: TMessage);
begin
inherited;
end;

procedure TNempHintWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := WS_POPUP;
    ExStyle := ExStyle and not WS_EX_CLIENTEDGE;
  end;
end;

procedure TNempHintWindow.Paint;
begin
  if assigned(FHintData.OnDrawHint) then begin
    inherited; // remove later ;-)
    FHintData.OnDrawHint(FHintData.Control, Canvas, Rect(0, 0, Width, Height), @fHintData)
  end
  else
    inherited;
end;

(*function TNempHintWindow.StyleServices(
  AControl: TControl): TCustomStyleServices;
begin
  Result := Vcl.Themes.StyleServices(AControl);
end;

procedure TNempHintWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;*)

end.
