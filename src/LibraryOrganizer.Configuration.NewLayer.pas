unit LibraryOrganizer.Configuration.NewLayer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, math, NempAudioFiles,
  LibraryOrganizer.Base, LibraryOrganizer.Files, Nemp_RessourceStrings;

type
  teCategoryEditMode = (teNew, teEdit, teCoverflow);

  TFormNewLayer = class(TForm)
    PnlButtons: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    MainPanel: TPanel;
    lblGroupBy: TLabel;
    lblMain: TLabel;
    lblSortBy: TLabel;
    cbProperties: TComboBox;
    cbPrimarySorting: TComboBox;
    cbPrimaryDirection: TComboBox;
    cbSecondaryDirection: TComboBox;
    cbTertiaryDirection: TComboBox;
    lblSecondarySorting: TLabel;
    cbSecondarySorting: TComboBox;
    cbTertiarySorting: TComboBox;
    procedure cbPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    fNewConfig: TCollectionConfig;

    // function GetCollectionType: teCollectionContent;
    // function GetSortingType: teCollectionSorting;

    procedure SetEditMode(Value: teCategoryEditMode);
    //procedure SetEdit(Value: Boolean);
    //procedure SetAllowPropertyChange(Value: Boolean);
    //procedure FillPropertiesSelection(IsRoot: Boolean);

    procedure FillSortingsSelection(aCollectionType: teCollectionContent);

  public
    { Public declarations }

    {TODO : die ersten beiden propertis durch eine TCollectionConfig ersetzen}
    //property CollectionType: teCollectionContent read GetCollectionType;
    //property SortingType: teCollectionSorting read GetSortingType;

    property NewConfig: TCollectionConfig read fNewConfig; // write fNewConfig;
    //property EditValue: Boolean write SetEdit;
    property EditMode: teCategoryEditMode write SetEditMode;
    //property AllowPropertyChange: Boolean write SetAllowPropertyChange;

    procedure FillPropertiesSelection(AllowSpecialContent: Boolean);

    //procedure SetDefaultValues(aType: teCollectionContent; aSorting: teCollectionSorting);
    procedure SetDefaultValues(aConfig: TCollectionConfig);

  end;

var
  FormNewLayer: TFormNewLayer;

resourcestring
  rcHeaderNewLayer = 'Add a new layer to organize your audiofiles';
  rcHeaderEditLayer = 'Change layer properties';
  rcHeaderEditCoverflow = 'Select Coverflow sort parameters';
  rcCaptionNew = 'Nemp: New category layer';
  rcCaptionEdit = 'Nemp: Edit category layer';
  rcCaptionEditCoverFlow = 'Nemp: Edit Coverflow';

implementation

uses gnugettext, Hilfsfunktionen;

{$R *.dfm}

procedure TFormNewLayer.FormCreate(Sender: TObject);
begin
  BackUpComboBoxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);
end;

procedure TFormNewLayer.BtnOKClick(Sender: TObject);
begin
  fNewConfig.Content := teCollectionContent(cbProperties.Items.Objects[cbProperties.ItemIndex]);
  fNewConfig.PrimarySorting := teCollectionSorting(cbPrimarySorting.Items.Objects[cbPrimarySorting.ItemIndex]);
  fNewConfig.SecondarySorting := teCollectionSorting(cbSecondarySorting.Items.Objects[cbSecondarySorting.ItemIndex]);
  fNewConfig.TertiarySorting := teCollectionSorting(cbTertiarySorting.Items.Objects[cbTertiarySorting.ItemIndex]);

  fNewConfig.SortDirection1 := teSortDirection(cbPrimaryDirection.ItemIndex);
  fNewConfig.SortDirection2 := teSortDirection(cbSecondaryDirection.ItemIndex);
  fNewConfig.SortDirection3 := teSortDirection(cbTertiaryDirection.ItemIndex);

  ModalResult := mrOK;
end;

procedure TFormNewLayer.cbPropertiesChange(Sender: TObject);
begin
  if cbProperties.ItemIndex >= 0 then begin
    fNewConfig.Content := teCollectionContent(cbProperties.Items.Objects[cbProperties.ItemIndex]);
    FillSortingsSelection(fNewConfig.Content);
  end;
end;

procedure TFormNewLayer.FillPropertiesSelection(AllowSpecialContent: Boolean);
begin
  cbProperties.Clear;

  cbProperties.Items.AddObject(TreeHeader_Artists, TObject(ccArtist));
  cbProperties.Items.AddObject(TreeHeader_Albums, TObject(ccAlbum));
  if AllowSpecialContent then begin
    cbProperties.Items.AddObject(TreeHeader_Directories, TObject(ccDirectory));
    cbProperties.Items.AddObject('TagCloud', TObject(ccTagCloud));
  end;
  cbProperties.Items.AddObject(TreeHeader_Genres, TObject(ccGenre));
  cbProperties.Items.AddObject(TreeHeader_Decades, TObject(ccDecade));
  cbProperties.Items.AddObject(TreeHeader_Years, TObject(ccYear));
  cbProperties.Items.AddObject(TreeHeader_FileAges, TObject(ccFileAgeYear));
  cbProperties.Items.AddObject(TreeHeader_FileAgesMonth, TObject(ccFileAgeMonth));

  cbProperties.ItemIndex := 0;

  FillSortingsSelection(teCollectionContent(cbProperties.Items.Objects[cbProperties.ItemIndex]));
end;

procedure TFormNewLayer.FillSortingsSelection(aCollectionType: teCollectionContent);

  procedure AddSorting(str: String; obj: TObject);
  begin
    cbPrimarySorting.Items.AddObject(str, obj);
    cbSecondarySorting.Items.AddObject(str, obj);
    cbTertiarySorting.Items.AddObject(str, obj);
  end;

begin
  cbPrimarySorting.Clear;
  cbSecondarySorting.Clear;
  cbTertiarySorting.Clear;

  AddSorting(CollectionSortingNames[csDefault], TObject(csDefault));

  case aCollectionType of

    ccAlbum: begin
      AddSorting(CollectionSortingNames[csAlbum], TObject(csAlbum));
      AddSorting(CollectionSortingNames[csArtist], TObject(csArtist));
      AddSorting(CollectionSortingNames[csGenre], TObject(csGenre));
      AddSorting(CollectionSortingNames[csYear], TObject(csYear));
      AddSorting(CollectionSortingNames[csFileAge], TObject(csFileAge));
      AddSorting(CollectionSortingNames[csDirectory], TObject(csDirectory));
    end;
    ccDirectory: begin
      AddSorting(CollectionSortingNames[csFileAge], TObject(csFileAge));
    end;
    // ccNone, ccRoot, ccArtist,  ccGenre,ccDecade, ccYear, ccFileAgeYear, ccFileAgeMonth, ccPath, ccCoverID: ; // nothing to do
  end;

  AddSorting(CollectionSortingNames[csCount], TObject(csCount));

  cbPrimarySorting.ItemIndex := 0;
  cbSecondarySorting.ItemIndex := 0; // min(cbSecondarySorting.Items.Count - 1, 1); // ?
  cbTertiarySorting.ItemIndex := 0;  // min(cbTertiarySorting.Items.Count - 1, 2); // ?
end;

procedure TFormNewLayer.SetDefaultValues(aConfig: TCollectionConfig);
begin
  fNewConfig := aConfig;

  cbProperties.ItemIndex := max(0, cbProperties.Items.IndexOfObject(TObject(aConfig.Content)));
  FillSortingsSelection(aConfig.Content);

  cbPrimarySorting.ItemIndex := max(0, cbPrimarySorting.Items.IndexOfObject(TObject(aConfig.PrimarySorting)));
  cbSecondarySorting.ItemIndex := max(0, cbSecondarySorting.Items.IndexOfObject(TObject(aConfig.SecondarySorting)));
  cbTertiarySorting.ItemIndex := max(0, cbTertiarySorting.Items.IndexOfObject(TObject(aConfig.TertiarySorting)));

  cbPrimaryDirection.ItemIndex := Integer(aConfig.SortDirection1);
  cbSecondaryDirection.ItemIndex := Integer(aConfig.SortDirection2);
  cbTertiaryDirection.ItemIndex := Integer(aConfig.SortDirection3);
end;

(*procedure TFormNewLayer.SetEdit(Value: Boolean);
begin
  if Value then begin
    Caption := rcCaptionEdit;
    lblMain.Caption := rcHeaderEditLayer;
  end else
  begin
    Caption := rcCaptionNew;
    lblMain.Caption := rcHeaderNewLayer;
  end;
end;*)

procedure TFormNewLayer.SetEditMode(Value: teCategoryEditMode);
begin
  case Value of
    teNew: begin
      Caption := rcCaptionNew;
      lblMain.Caption := rcHeaderNewLayer;
      cbProperties.Enabled := True;
    end;
    teEdit: begin
      Caption := rcCaptionEdit;
      lblMain.Caption := rcHeaderEditLayer;
      cbProperties.Enabled := True;
    end;
    teCoverflow: begin
      Caption := rcCaptionEditCoverFlow;
      lblMain.Caption := rcHeaderEditCoverFlow;
      cbProperties.Enabled := False;
    end;
  end;

end;

(*procedure TFormNewLayer.SetAllowPropertyChange(Value: Boolean);
begin
  cbProperties.Enabled := Value;
  if not Value then
    cbProperties.ItemIndex := max(0, cbProperties.Items.IndexOfObject(TObject(ccAlbum)));
end;
*)

(*
function TFormNewLayer.GetCollectionType: teCollectionContent;
begin
  result := teCollectionContent(cbProperties.Items.Objects[cbProperties.ItemIndex]);
end;

function TFormNewLayer.GetSortingType: teCollectionSorting;
begin
  result := teCollectionSorting(cbSortings.Items.Objects[cbSortings.ItemIndex]);
end;
*)

end.
