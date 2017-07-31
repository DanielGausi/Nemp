unit PlayWebstream;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFPlayWebstream = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    BtnFavorites: TButton;
    lblURL: TLabel;
    edtURL: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FPlayWebstream: TFPlayWebstream;

implementation

{$R *.dfm}

uses gnugettext;

procedure TFPlayWebstream.FormCreate(Sender: TObject);
begin
    TranslateComponent(self);
end;

end.
