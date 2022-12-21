unit CDSelection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, StrUtils, gnuGettext;

type
  TFormCDDBSelect = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    lvSelectCD: TListBox;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure lvSelectCDDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    function BetterLookingTitle(aTitle: String): String;

  public
    { Public-Deklarationen }
    SelectedEntry: Integer;

    procedure FillView(aCDDBResponse: UTF8String);
  end;

var
  FormCDDBSelect: TFormCDDBSelect;

implementation

{$R *.dfm}

function TFormCDDBSelect.BetterLookingTitle(aTitle: String): String;
var first, second: Integer;
begin
    first := pos(' ', aTitle);
    second := PosEx(' ', aTitle, first+1);
    result := Copy(aTitle, second+1, length(aTitle) - second) + ' (' + Copy(aTitle, 0, first-1) + ')';
end;

procedure TFormCDDBSelect.BtnCancelClick(Sender: TObject);
begin
    SelectedEntry := -1;
    close;
end;

procedure TFormCDDBSelect.BtnOKClick(Sender: TObject);
begin
    SelectedEntry := lvSelectCD.ItemIndex;
    close;

    modalresult := mrOk;
end;

procedure TFormCDDBSelect.FillView(aCDDBResponse: UTF8String);
var sl: tStringList;
    i: Integer;
begin
    lvSelectCD.Clear;
    sl := TStringList.Create;
    try
        sl.Text := String(aCDDBResponse);
        for i := 1 to sl.Count - 2 do
            lvSelectCD.Items.Add(BetterLookingTitle(sl[i]));

        lvSelectCD.ItemIndex := 0;
    finally
        sl.Free;
    end;
end;

procedure TFormCDDBSelect.FormCreate(Sender: TObject);
begin
    TranslateComponent (self);
end;

procedure TFormCDDBSelect.lvSelectCDDblClick(Sender: TObject);
begin
    SelectedEntry := lvSelectCD.ItemIndex;
    modalresult := mrOk;
end;

end.
