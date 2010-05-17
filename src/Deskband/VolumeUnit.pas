unit VolumeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, NempApi, Buttons, ExtCtrls, XPMan, TaskbarStuff;

type
  TVolumeForm = class(TForm)
    SlideBarShape: TShape;
    VolButton: TImage;
    Image1: TImage;
    HideTimer: TTimer;
    CloseImage2: TImage;
    procedure ReOrderControls;
    procedure FormShow(Sender: TObject);
    procedure VolButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure VolButtonDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure VolButtonDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure VolButtonDragOverUpDown(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);

    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure HideTimerTimer(Sender: TObject);
    procedure CloseImage2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  protected

  public
    { Public-Deklarationen }
  end;

var
  VolumeForm: TVolumeForm;

implementation

{$R *.dfm}

procedure TVolumeForm.FormCreate(Sender: TObject);
begin
      Height := 22;
      Width := 77;
end;


procedure TVolumeForm.ReOrderControls;
var vol: Integer;
begin
  vol := GetNemp_Volume;
  if GetTaskbarPosition in [tbTop, tbBottom] then
  begin
      // Form waagerecht befüllen
      Height := 22;
      Width := 77;
      VolButton.Top := 5;

      if vol > -1 then
         VolButton.Left := 5 + Round(55/255 * vol);
      VolButton.OnDragOver := VolButtonDragOver;
      VolButton.DragCursor := crSizeWE;

      SlideBarShape.Left := 5;
      SlideBarShape.Top  := 8;
      SlideBarShape.Width := 60;
      SlideBarShape.Height := 4;
  end else
  begin
      //Senkrechte Form
      Height := 77;
      Width := 22;
      VolButton.Left := 5;
      if vol > -1 then
         VolButton.Top := 5 + 55 - Round(55/255 * vol);
      VolButton.OnDragOver := VolButtonDragOverUpDown;
      VolButton.DragCursor := crSizeNS;
      
      SlideBarShape.Left := 8;
      SlideBarShape.Top  := 5;
      SlideBarShape.Width := 4;
      SlideBarShape.Height := 60;
  end;
end;


procedure TVolumeForm.FormShow(Sender: TObject);

begin
  SetWindowLong(Handle, GWL_ExStyle, WS_EX_TOOLWINDOW);
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  HideTimer.Enabled := True;

  ReOrderControls;
end;

procedure TVolumeForm.VolButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  with VolButton do Begindrag(false);
  ARect.TopLeft :=  (ClientToScreen(Point(VolButton.Left, VolButton.Top)));
  ARect.BottomRight :=  (ClientToScreen(Point(VolButton.Left + VolButton.Width, VolButton.Top + VolButton.Height)));
  ClipCursor(@Arect);
  HideTimer.Enabled := False;
end;

procedure TVolumeForm.VolButtonDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
Var newpos: integer;
  AREct: TRect;
begin
  NewPos := VolButton.Left + x - 4;
  if NewPos <= 5 then
      VolButton.Left := 5
    else
      if NewPos >=55 then
        VolButton.Left := 55
      else
        VolButton.Left := NewPos;

  SetNemp_Volume(Round((VolButton.Left - 5)*255/50));

  ARect.TopLeft :=  (ClientToScreen(Point(VolButton.Left, VolButton.Top)));
  ARect.BottomRight :=  (ClientToScreen(Point(VolButton.Left + VolButton.Width, VolButton.Top + VolButton.Height)));
  ClipCursor(@Arect);
end;

procedure TVolumeForm.VolButtonDragOverUpDown(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
Var newpos: integer;
  AREct: TRect;
begin
  NewPos := VolButton.Top + y - 4;
  if NewPos <= 5 then
      VolButton.Top := 5
    else
      if NewPos >=55 then
        VolButton.Top := 55
      else
        VolButton.Top := NewPos;

  SetNemp_Volume(Round((60 - VolButton.Top - 5)*255/50));

  ARect.TopLeft :=  (ClientToScreen(Point(VolButton.Left, VolButton.Top)));
  ARect.BottomRight :=  (ClientToScreen(Point(VolButton.Left + VolButton.Width, VolButton.Top + VolButton.Height)));
  ClipCursor(@Arect);
end;

procedure TVolumeForm.VolButtonDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  ClipCursor(Nil);
  HideTimer.Enabled := True;
end;

procedure TVolumeForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  HideTimer.Enabled := False;
  HideTimer.Enabled := True;
end;

procedure TVolumeForm.HideTimerTimer(Sender: TObject);
begin
  close;
  HideTimer.Enabled := False;
end;

procedure TVolumeForm.CloseImage2Click(Sender: TObject);
begin
  close;
  HideTimer.Enabled := False;
end;



end.
