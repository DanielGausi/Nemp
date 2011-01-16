unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, nempApi, lcdg15, lcdg15Nemp, ImgList;

type
  TMainForm = class(TForm)

    GrpOutput: TGroupBox;
    Image1: TImage;
    MainTimer: TTimer;
    ImageList1: TImageList;
    StartTimer: TTimer;
    BtnHide: TButton;
    GrpBoxSettings: TGroupBox;
    cbHighStartPriority: TCheckBox;
    cbHighPriority: TCheckBox;
    cbStartWithNemp: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure BtnHideClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }

    NempG15Applet: TNempG15Applet;
    procedure myCallbackConfigure();


  public
    { Public-Deklarationen }


  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}


procedure TMainForm.BtnHideClick(Sender: TObject);
begin
    hide;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin

    NempG15Applet.StartWithNemp := cbStartWithNemp .Checked;
    if cbHighStartPriority .Checked then
        NempG15Applet.StartPriority := 255
    else
        NempG15Applet.StartPriority := 1;

    if cbHighPriority.Checked then
        NempG15Applet.DisplayPriority := 255
    else
        NempG15Applet.DisplayPriority := 1;

    NempG15Applet.SaveSettings;
end;

procedure TMainForm.FormCreate(Sender: TObject);

begin
    // nothing. Start as fast as possible.
    // Init is done by the StartTimer-OnTimer.
    NempG15Applet := Nil;

    BtnHide.Visible := ParamCount = 1;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
    if assigned(NempG15Applet) then
        NempG15Applet.Free;
end;


procedure TMainForm.StartTimerTimer(Sender: TObject);
begin
    StartTimer.Enabled := False;
    if assigned(NempG15Applet) then
        exit; // oops, this should not happen. ;-)

    NempG15Applet := TNempG15Applet.Create;
    NempG15Applet.OnConfig := myCallbackConfigure;
    NempG15Applet.ControlImage := Image1;
    ImageList1.GetBitmap(0, NempG15Applet.SplashImage);

    if Not assigned(NempG15Applet.g15Display) then

        MessageDLG('NempG15Applet could not be loaded: Another copy is already running, or no G15 can be found.', mtError, [MBOK], 0);

    MainTimer.Enabled := True;

    cbStartWithNemp     .Checked := NempG15Applet.StartWithNemp;
    cbHighStartPriority .Checked := NempG15Applet.StartPriority = 255;
    cbHighPriority      .Checked := NempG15Applet.DisplayPriority = 255;
end;



procedure TMainForm.MainTimerTimer(Sender: TObject);
var hwndNemp:THandle;
begin
  hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
  if (hwndNemp = 0) And (ParamCount = 1) then
      close
  else
  begin
      MainTimer.Tag := MainTimer.Tag + 1;

      if (MainTimer.Tag < 10) or (hwndNemp = 0) or (Not assigned(NempG15Applet.g15Display)) then
      begin
          NempG15Applet.PaintIntro;
      end else
      begin
          if NempG15Applet.AppState = 0 then
              NempG15Applet.PaintCurrentTrackInfo
          else
              NempG15Applet.PaintPlaylistPart;
      end;
  end;
end;



procedure TMainForm.myCallbackConfigure;
begin

    //shellexecute(handle,'open',pchar('"E:\NempSVN\nemp\src\G15App\NempG15App.exe"'),0,0,sw_hide);
    //if not visible then
    begin
        ShowWindow( Handle, SW_HIDE );
        SetWindowLong( Handle, GWL_EXSTYLE,
                 GetWindowLong(Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW);
        ShowWindow( Handle, SW_SHOW );
    end;
end;



end.
