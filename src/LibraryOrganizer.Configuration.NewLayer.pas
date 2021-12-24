unit LibraryOrganizer.Configuration.NewLayer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  LibraryOrganizer.Base, LibraryOrganizer.Files, Nemp_RessourceStrings;

type
  TFormNewLayer = class(TForm)
    PnlButtons: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    MainPanel: TPanel;
    lblGroupBy: TLabel;
    lblMain: TLabel;
    lblSortBy: TLabel;
    cbProperties: TComboBox;
    cbSortings: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure cbPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    function GetCollectionType: teCollectionType;
    function GetSortingType: teCollectionSorting;

    procedure SetEdit(Value: Boolean);
    //procedure FillPropertiesSelection(IsRoot: Boolean);

  public
    { Public declarations }
    property CollectionType: teCollectionType read GetCollectionType;
    property SortingType: teCollectionSorting read GetSortingType;
    property EditValue: Boolean write SetEdit;

    procedure FillPropertiesSelection(IsRoot: Boolean);
    procedure FillSortingsSelection(aCollectionType: teCollectionType);

    procedure SetDefaultValues(aType: teCollectionType; aSorting: teCollectionSorting);
  end;

var
  FormNewLayer: TFormNewLayer;

resourcestring
  rcHeaderNewLayer = 'Add a new layer to organize your audiofiles';
  rcHeaderEditLayer = 'Change layer properties';
  rcCaptionNew = 'Nemp: New category layer';
  rcCaptionEdit = 'Nemp: Edit category layer';

implementation

{$R *.dfm}

procedure TFormNewLayer.cbPropertiesChange(Sender: TObject);
begin
  if cbProperties.ItemIndex >= 0 then
    FillSortingsSelection(self.CollectionType);
end;

procedure TFormNewLayer.FillPropertiesSelection(IsRoot: Boolean);
begin
  cbProperties.Clear;

  cbProperties.Items.AddObject(TreeHeader_Artists, TObject(ctArtist));
  cbProperties.Items.AddObject(TreeHeader_Albums, TObject(ctAlbum));
  if IsRoot then
    cbProperties.Items.AddObject(TreeHeader_Directories, TObject(ctDirectory));
  cbProperties.Items.AddObject(TreeHeader_Genres, TObject(ctGenre));
  cbProperties.Items.AddObject(TreeHeader_Decades, TObject(ctDecade));
  cbProperties.Items.AddObject(TreeHeader_Years, TObject(ctYear));
  cbProperties.Items.AddObject(TreeHeader_FileAges, TObject(ctFileAgeYear));
  cbProperties.Items.AddObject(TreeHeader_FileAgesMonth, TObject(ctFileAgeMonth));

  cbProperties.ItemIndex := 0;
  FillSortingsSelection(self.CollectionType);
end;

procedure TFormNewLayer.FillSortingsSelection(aCollectionType: teCollectionType);
begin
  cbSortings.Clear;
  cbSortings.Items.AddObject( CollectionSortingNames[csDefault], TObject(csDefault));

  case aCollectionType of

    ctAlbum: begin
      cbSortings.Items.AddObject(CollectionSortingNames[csAlbum], TObject(csAlbum));
      cbSortings.Items.AddObject(CollectionSortingNames[csArtistAlbum], TObject(csArtistAlbum));
      cbSortings.Items.AddObject(CollectionSortingNames[csGenre], TObject(csGenre));
      cbSortings.Items.AddObject(CollectionSortingNames[csYear], TObject(csYear));
      cbSortings.Items.AddObject(CollectionSortingNames[csFileAge], TObject(csFileAge));
      cbSortings.Items.AddObject(CollectionSortingNames[csDirectory], TObject(csDirectory));
    end;
    ctDirectory: begin
      cbSortings.Items.AddObject( CollectionSortingNames[csFileAge], TObject(csFileAge));
    end;
    ctNone: ;
    ctRoot: ;
    ctArtist: ;
    ctGenre: ;
    ctDecade: ;
    ctYear: ;
    ctFileAgeYear: ;
    ctFileAgeMonth: ;
    ctPath: ;
    ctCoverID: ;
  end;

  cbSortings.Items.AddObject( CollectionSortingNames[csCount], TObject(csCount));
  cbSortings.ItemIndex := 0;
end;

procedure TFormNewLayer.SetDefaultValues(aType: teCollectionType; aSorting: teCollectionSorting);
var
  propIdx, sortIdx: Integer;
begin
  propIdx := cbProperties.Items.IndexOfObject(TObject(aType));
  if propIdx >= 0 then begin
    cbProperties.ItemIndex := propIdx;

    FillSortingsSelection(aType);
    sortIdx := cbSortings.Items.IndexOfObject(TObject(aSorting));
    if sortIdx >= 0 then
      cbSortings.ItemIndex := sortIdx;
  end;
end;

procedure TFormNewLayer.SetEdit(Value: Boolean);
begin
  if Value then begin
    Caption := rcCaptionEdit;
    lblMain.Caption := rcHeaderEditLayer;
  end else
  begin
    Caption := rcCaptionNew;
    lblMain.Caption := rcHeaderNewLayer;
  end;
end;

procedure TFormNewLayer.FormShow(Sender: TObject);
begin
//
end;

function TFormNewLayer.GetCollectionType: teCollectionType;
begin
  result := teCollectionType(cbProperties.Items.Objects[cbProperties.ItemIndex]);
end;

function TFormNewLayer.GetSortingType: teCollectionSorting;
begin
  result := teCollectionSorting(cbSortings.Items.Objects[cbSortings.ItemIndex]);
end;

end.
