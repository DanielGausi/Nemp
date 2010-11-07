unit ErrorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFError = class(TForm)
    Memo_Error: TMemo;
    BtnClear: TButton;
    BtnOK: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FError: TFError;

implementation

uses NempMainUnit, Nemp_RessourceStrings;

{$R *.dfm}

procedure TFError.BtnClearClick(Sender: TObject);
begin
    ErrorLogCount := 0;
    ErrorLog.Clear;
    Memo_Error.Clear;
    Memo_Error.Lines.Add(ErrorForm_NoMessages);
    Nemp_MainForm.MM_H_ErrorLog.Caption := MainForm_MainMenu_NoMessages;
end;

procedure TFError.BtnOKClick(Sender: TObject);
begin
    Close;
end;

procedure TFError.FormShow(Sender: TObject);
begin
    if ErrorLogCount = 0 then
        Memo_Error.Text := ErrorForm_NoMessages
    else
        Memo_Error.Lines.Assign(ErrorLog);
end;

end.
