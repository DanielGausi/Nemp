unit PartymodePassword;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, gnuGettext;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  PasswordDlg: TPasswordDlg;

implementation

{$R *.dfm}

procedure TPasswordDlg.FormCreate(Sender: TObject);
begin
    TranslateComponent (self);
end;

procedure TPasswordDlg.FormShow(Sender: TObject);
begin
    Password.Text := '';
end;

end.
 
