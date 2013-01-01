unit Lowbattery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, gnuGettext;

type
  TFormLowBattery = class(TForm)
    Image1: TImage;
    Lbl_Warning: TLabel;
    st_Metadata: TStaticText;
    BtnOk: TButton;
    cb_ToDo: TComboBox;
    LblWhatNow: TLabel;
    BtnCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure BackUpComboBoxes;
    procedure RestoreComboboxes;
  end;

var
  FormLowBattery: TFormLowBattery;

implementation

{$R *.dfm}

procedure TFormLowBattery.FormCreate(Sender: TObject);
var filename: String;
begin
    TranslateComponent (self);
    cb_ToDo.ItemIndex := 0;
    BtnOK.ModalResult := mrOk;
    filename := ExtractFilePath(ParamStr(0)) + 'Images\lowBattery.png';
    if FileExists(filename) then
        Image1.Picture.LoadFromFile(filename);
end;

procedure TFormLowBattery.BackUpComboBoxes;
var i: Integer;
begin
    for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        Components[i].Tag := (Components[i] as TComboBox).ItemIndex;
end;
procedure TFormLowBattery.RestoreComboboxes;
var i: Integer;
begin
  for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        (Components[i] as TComboBox).ItemIndex := Components[i].Tag;
end;

end.
