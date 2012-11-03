unit Lowbattery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormLowBattery = class(TForm)
    Image1: TImage;
    Lbl_Warning: TLabel;
    st_Metadata: TStaticText;
    BtnOk: TButton;
    cb_ToDo: TComboBox;
    LblWhatNow: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cb_ToDoChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormLowBattery: TFormLowBattery;

implementation

{$R *.dfm}

procedure TFormLowBattery.cb_ToDoChange(Sender: TObject);
begin
    BtnOK.ModalResult := cb_ToDo.ItemIndex + 1;
end;

procedure TFormLowBattery.FormCreate(Sender: TObject);
var filename: String;
begin
    BtnOK.ModalResult := mrOk;
    filename := ExtractFilePath(ParamStr(0)) + 'Images\lowBattery.png';
    if FileExists(filename) then
        Image1.Picture.LoadFromFile(filename);
end;

end.
