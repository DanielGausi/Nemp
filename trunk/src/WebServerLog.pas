unit WebServerLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WebServerClass, ExtCtrls;

type
  TWebServerLogForm = class(TForm)
    LogMemo: TMemo;
    BtnSave: TButton;
    BtnRefresh: TButton;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    cbAutoRefresh: TCheckBox;
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure cbAutoRefreshClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  WebServerLogForm: TWebServerLogForm;

implementation

uses NempMainUnit;

{$R *.dfm}

procedure TWebServerLogForm.BtnRefreshClick(Sender: TObject);
begin
    LogMemo.Lines.Assign(NempWebserver.LogList);
    SendMessage(LogMemo.Handle, WM_VScroll, SB_Bottom, 0);
end;

procedure TWebServerLogForm.BtnSaveClick(Sender: TObject);
begin
    if SaveDialog1.Execute then
        LogMemo.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TWebServerLogForm.cbAutoRefreshClick(Sender: TObject);
begin
    Timer1.Enabled := cbAutoRefresh.Checked;
end;

procedure TWebServerLogForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Timer1.Enabled := False;
end;

procedure TWebServerLogForm.FormShow(Sender: TObject);
begin
    LogMemo.Lines.Assign(NempWebserver.LogList);
    Timer1.Enabled := cbAutoRefresh.Checked;
end;

procedure TWebServerLogForm.Timer1Timer(Sender: TObject);
begin
    LogMemo.Lines.Assign(NempWebserver.LogList);
    SendMessage(LogMemo.Handle, WM_VScroll, SB_Bottom, 0);
end;

end.
