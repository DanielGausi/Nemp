unit LibraryOrganizer.Configuration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, System.Generics.Defaults,
  gnuGettext, Nemp_RessourceStrings, MyDialogs, NempAudioFiles, LibraryOrganizer.Configuration.NewLayer,
  LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists,
  Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.Menus, ActiveX;

type
 
  teMoveDirection = (mdUp, mdDown);

  TFormLibraryConfiguration = class(TForm)
    PnlButtons: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    VSTCategories: TVirtualStringTree;
    BtnAddCategory: TButton;
    BtnDeleteCategory: TButton;
    grpBoxCategories: TGroupBox;
    BtnApply: TButton;
    checkBoxNewFilesCategory: TCheckBox;
    cbNewFilesCategory: TComboBox;
    lblDefaultCategory: TLabel;
    grpBoxSortLevels: TGroupBox;
    VSTSortings: TVirtualStringTree;
    BtnAddRootLayer: TButton;
    BtnAddSubLayer: TButton;
    ActionList1: TActionList;
    ActionAddCategory: TAction;
    ActionDeleteCategory: TAction;
    ActionAddRootLayer: TAction;
    ActionAddLayer: TAction;
    ActionDeleteLayer: TAction;
    BtnDeleteLayer: TButton;
    PnlSettings: TPanel;
    grpBoxAlbumSettings: TGroupBox;
    lblAlbumDefinition: TLabel;
    cbIgnoreCDDirectories: TCheckBox;
    editCDNames: TLabeledEdit;
    cbAlbumKeymode: TComboBox;
    grpBoxView: TGroupBox;
    lblPlaylistCaptionMode: TLabel;
    cbShowCoverForAlbum: TCheckBox;
    cbShowCollectionCount: TCheckBox;
    cbPlaylistCaptionMode: TComboBox;
    ActionEditLayer: TAction;
    PopupLayers: TPopupMenu;
    Editlayer1: TMenuItem;
    Addrootlayer1: TMenuItem;
    Deletelayer1: TMenuItem;
    Addlayer1: TMenuItem;
    PopupCategories: TPopupMenu;
    ActionEditCategory: TAction;
    Addcategory1: TMenuItem;
    Deletecategory1: TMenuItem;
    Editcategory1: TMenuItem;
    pnlLayerButtons: TPanel;
    cbDefaultCategory: TComboBox;
    pnlLayerAdds: TPanel;
    lblCoverFlowSorting: TLabel;
    cbCoverFlowSorting: TComboBox;
    pnlCategoryButtons: TPanel;
    pnlCategoryAdds: TPanel;
    PnlMain: TPanel;
    ActionLayerMoveDown: TAction;
    ActionLayerMoveUp: TAction;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    N1: TMenuItem;
    ActionMoveCategoryUp: TAction;
    ActionMoveCategoryDown: TAction;
    N2: TMenuItem;
    Moveup2: TMenuItem;
    Movedown2: TMenuItem;
    Splitter1: TSplitter;
    cbShowCategoryCount: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VSTCategoriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTSortingsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTCategoriesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCategoriesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
    procedure cbDefaultCategoryChange(Sender: TObject);
    procedure cbNewFilesCategoryChange(Sender: TObject);
    procedure ActionAddCategoryExecute(Sender: TObject);
    procedure ActionDeleteCategoryExecute(Sender: TObject);
    procedure ActionAddRootLayerExecute(Sender: TObject);
    procedure ActionAddLayerExecute(Sender: TObject);
    procedure ActionDeleteLayerExecute(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure VSTSortingsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionEditLayerExecute(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure ActionEditCategoryExecute(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure checkBoxNewFilesCategoryClick(Sender: TObject);
    procedure VSTSortingsDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTCategoriesDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCategoriesDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTCategoriesDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTSortingsDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTSortingsDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure ActionLayerMoveUpExecute(Sender: TObject);
    procedure ActionLayerMoveDownExecute(Sender: TObject);
    procedure ActionMoveCategoryUpExecute(Sender: TObject);
    procedure ActionMoveCategoryDownExecute(Sender: TObject);
    procedure PopupCategoriesPopup(Sender: TObject);
    procedure PopupLayersPopup(Sender: TObject);
    procedure cbCoverFlowSortingChange(Sender: TObject);
  private
    { Private declarations }
    FileCategories: TLibraryCategoryList;
    RootCollections: TAudioCollectionList;
    OrganizerSettings: TOrganizerSettings;
    fCategoriesChanged: Boolean;
    fCollectionsChanged: Boolean;

    procedure FillCategoryTree;
    procedure FillCategoryComboBoxes;
    procedure FillCollectionTree;

    procedure RefreshCategoryButtons;
    procedure RefreshLayerActions(Node: PVirtualNode; rc: TRootCollection);


    procedure PrepareNewLayerForm(isRoot: Boolean);
    procedure PrepareEditLayerForm(AllowDirectory: Boolean; aType: teCollectionContent; aSorting: teCollectionSorting);

    function CategoryNameExists(aName: String; Categories: TLibraryCategoryList): Boolean;
    function NewUniqueCategoryName(Categories: TLibraryCategoryList): String;

    function CategoryIndexExists(aIndex: Integer; CatEdit, CatLibrary: TLibraryCategoryList): Boolean; overload;
    function CategoryIndexExists(aIndex: Integer; Categories: TLibraryCategoryList): Boolean; overload;

    function NewUniqueCategoryIndex(CatEdit, CatLibrary: TLibraryCategoryList): Integer;

    procedure EnsureDefaultCategoryIsSet;
    procedure EnsureNewCategoryIsSet;

    procedure MoveLayer(Direction: teMoveDirection);
    procedure MoveCategory(Direction: teMoveDirection);


  public
    { Public declarations }
  end;


var
  FormLibraryConfiguration: TFormLibraryConfiguration;

implementation

uses NempMainUnit, Hilfsfunktionen;

{$R *.dfm}

function getNextIdx(const aIdx: Integer; Button: teMoveDirection): Integer;
begin
  case Button of
    mdUp:   result := aIdx - 1;
    mdDown: result := aIdx + 1;
  else
    result := aIdx + 1;
  end;
end;

function ValidRange(aIdx, bIdx, maxIdx: Integer): Boolean;
begin
  result := (aIdx >= 0) and (bIdx >= 0)
        and (aIdx <= maxIdx) and (bIdx <= maxIdx);
end;


procedure TFormLibraryConfiguration.FormCreate(Sender: TObject);
begin
  BackUpComboBoxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);

  FileCategories := TLibraryCategoryList.Create(False);
  OrganizerSettings := TOrganizerSettings.create;
  RootCollections := TAudioCollectionList.Create(False);

  VSTCategories.NodeDataSize := SizeOf(TLibraryCategory);
  VSTSortings.NodeDataSize := SizeOf(TAudioCollection);

  // Valid Sortings for Coverflow
  cbCoverFlowSorting.Clear;
  cbCoverFlowSorting.Items.AddObject( CollectionSortingNames[csDefault], TObject(csDefault));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csAlbum], TObject(csAlbum));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csArtistAlbum], TObject(csArtistAlbum));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csGenre], TObject(csGenre));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csYear], TObject(csYear));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csFileAge], TObject(csFileAge));
  cbCoverFlowSorting.Items.AddObject(CollectionSortingNames[csDirectory], TObject(csDirectory));
  cbCoverFlowSorting.Items.AddObject( CollectionSortingNames[csCount], TObject(csCount));
  cbCoverFlowSorting.ItemIndex := 0;
end;

procedure TFormLibraryConfiguration.FormDestroy(Sender: TObject);
begin
  FileCategories.OwnsObjects := True;
  FileCategories.Free;
  OrganizerSettings.Free;
  RootCollections.OwnsObjects := True;
  RootCollections.Free;
end;

procedure TFormLibraryConfiguration.FormShow(Sender: TObject);
var
  i, iRC: Integer;
  newCat: TLibraryFileCategory;
  newRoot: TRootCollection;
  aRootConfig: TCollectionConfigList;
begin
  OrganizerSettings.Assign(NempOrganizerSettings);
  fCategoriesChanged  := False;
  fCollectionsChanged := False;

  RootCollections.OwnsObjects := True;
  RootCollections.Clear;
  for iRC := 0 to OrganizerSettings.RootCollectionCount - 1 do begin
    aRootConfig := OrganizerSettings.RootCollectionConfig[iRC];
    newRoot := TRootCollection.Create(Nil);
    for i := 0 to aRootConfig.Count - 1 do begin
      newRoot.AddSubCollectionType(aRootConfig[i].CollectionContent, aRootConfig[i].CollectionSorting);
    end;
    RootCollections.Add(newRoot);
  end;
  RootCollections.OwnsObjects := False;

  FileCategories.OwnsObjects := True;
  FileCategories.Clear;
  for i := 0 to MedienBib.FileCategories.Count - 1 do begin
    newCat := TLibraryFileCategory.Create;
    newCat.AssignSettings(MedienBib.FileCategories[i]);
    FileCategories.Add(newCat);
  end;
  FileCategories.OwnsObjects := False;

  FillCategoryTree;
  FillCategoryComboBoxes;
  FillCollectionTree;

  cbCoverFlowSorting.ItemIndex := cbCoverFlowSorting.Items.IndexOfObject(
    TObject(OrganizerSettings.CoverFlowRootCollectionConfig[0].CollectionSorting)
  );

  cbAlbumKeymode.ItemIndex := Integer(OrganizerSettings.AlbumKeyMode);
  cbIgnoreCDDirectories.Checked := OrganizerSettings.TrimCDFromDirectory;
  editCDNames.Text := OrganizerSettings.CDNames.DelimitedText;
  cbShowCollectionCount.Checked := OrganizerSettings.ShowCollectionCount;
  cbShowCategoryCount.Checked := OrganizerSettings.ShowCategoryCount;
  cbShowCoverForAlbum.Checked := OrganizerSettings.ShowCoverArtOnAlbum;
  checkBoxNewFilesCategory.Checked := OrganizerSettings.UseNewCategory;
  cbPlaylistCaptionMode.ItemIndex := Integer(OrganizerSettings.PlaylistCaptionMode);

  cbNewFilesCategory.Enabled := checkBoxNewFilesCategory.Checked;
end;

procedure TFormLibraryConfiguration.FillCategoryComboBoxes;
var
  i: Integer;
begin
  cbDefaultCategory.OnChange := Nil;
  cbNewFilesCategory.OnChange := Nil;

  cbDefaultCategory.Items.Clear;
  cbNewFilesCategory.Items.Clear;
  for i := 0 to FileCategories.Count - 1 do begin
    cbDefaultCategory.Items.Add(FileCategories[i].Name);
    cbNewFilesCategory.Items.Add(FileCategories[i].Name);
  end;

  cbDefaultCategory.ItemIndex := GetDefaultCategoryIndex(FileCategories);
  cbNewFilesCategory.ItemIndex := GetNewCategoryIndex(FileCategories);

  cbDefaultCategory.OnChange := cbDefaultCategoryChange;
  cbNewFilesCategory.OnChange := cbNewFilesCategoryChange;
end;

procedure TFormLibraryConfiguration.FillCategoryTree;
var
  i: Integer;
begin
  VSTCategories.BeginUpdate;
  VSTCategories.Clear;
  for i := 0 to FileCategories.Count - 1 do
    VSTCategories.AddChild(Nil, FileCategories[i]);

  if FileCategories.Count > 0 then begin
    VSTCategories.FocusedNode := VSTCategories.GetFirst;
    VSTCategories.Selected[VSTCategories.GetFirst] := True;
  end;
  VSTCategories.EndUpdate;
end;

procedure TFormLibraryConfiguration.FillCollectionTree;
var
  i, iLevel: Integer;
  newNode: PVirtualNode;
begin
  VSTSortings.BeginUpdate;
  VSTSortings.Clear;
  for i := 0 to RootCollections.Count - 1 do begin
    NewNode := VSTSortings.AddChild(nil, RootCollections[i]);
    for iLevel := 0 to TRootCollection(RootCollections[i]).LayerDepth - 1 do
      newNode := VSTSortings.AddChild(newNode, RootCollections[i]);
  end;

  VSTSortings.FullExpand;
  VSTSortings.EndUpdate;
end;


procedure TFormLibraryConfiguration.VSTCategoriesEditing(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TFormLibraryConfiguration.VSTCategoriesGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  CellText := lc.Name;
end;

procedure TFormLibraryConfiguration.VSTCategoriesNewText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  NewText: string);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  lc.Name := NewText;
  fCategoriesChanged := True;
end;

procedure TFormLibraryConfiguration.VSTSortingsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  rc: TRootCollection;
  level: Integer;
begin
  rc := Sender.GetNodeData<TRootCollection>(Node);

  level := Sender.GetNodeLevel(Node);
  if Level = 0 then
    CellText := rc.Caption
  else
  begin
    CellText := rc.LevelCaption[level-1];
    if rc.GetCollectionCompareType(level-1) <> csDefault then
      CellText := CellText
        + ' ('
        + _(CollectionSortingNames[rc.GetCollectionCompareType(level-1)])
        + ')';
  end;
end;

procedure TFormLibraryConfiguration.VSTSortingsFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  rc: TRootCollection;
begin
  if not assigned(Node) then
    exit;
  rc := Sender.GetNodeData<TRootCollection>(Node);

  RefreshLayerActions(Node, rc);
  //ActionAddLayer.Enabled := NOT rc.IsDirectoryCollection;
  //ActionDeleteLayer.Enabled := (Sender.GetNodeLevel(Node) = 0) or (rc.LayerDepth > 1)
end;

function TFormLibraryConfiguration.CategoryNameExists(aName: String; Categories: TLibraryCategoryList): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to Categories.Count - 1 do
    if Categories[i].Name = aName then begin
      result := True;
      break;
    end;
end;

procedure TFormLibraryConfiguration.cbCoverFlowSortingChange(Sender: TObject);
begin
  fCollectionsChanged := True;
end;

procedure TFormLibraryConfiguration.cbDefaultCategoryChange(Sender: TObject);
begin
  SetDefaultCategoryIndex(FileCategories, cbDefaultCategory.ItemIndex);
  VSTCategories.Invalidate;
end;

procedure TFormLibraryConfiguration.cbNewFilesCategoryChange(Sender: TObject);
begin
  SetNewCategoryIndex(FileCategories, cbNewFilesCategory.ItemIndex);
  VSTCategories.Invalidate;
end;

procedure TFormLibraryConfiguration.checkBoxNewFilesCategoryClick(
  Sender: TObject);
begin
  cbNewFilesCategory.Enabled := checkBoxNewFilesCategory.Checked;
end;

function TFormLibraryConfiguration.CategoryIndexExists(aIndex: Integer; CatEdit, CatLibrary: TLibraryCategoryList): Boolean;
begin
  result := CategoryIndexExists(aIndex, CatEdit);
  if not result then
    result := CategoryIndexExists(aIndex, CatLibrary);
end;

function TFormLibraryConfiguration.CategoryIndexExists(aIndex: Integer; Categories: TLibraryCategoryList): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to Categories.Count - 1 do
    if Categories[i].Index = aIndex then begin
      result := True;
      break;
    end;
end;

function TFormLibraryConfiguration.NewUniqueCategoryName(Categories: TLibraryCategoryList): String;
var
  c: Integer;
begin
  result := rsNewCategoryName;
  c := 0;
  while CategoryNameExists(result, Categories) do begin
    inc(c);
    result := rsNewCategoryName + ' (' + IntToStr(c) + ')';
  end;
end;

procedure TFormLibraryConfiguration.RefreshCategoryButtons;
begin
  ActionAddCategory.Enabled := FileCategories.Count < 32;
  ActionDeleteCategory.Enabled  := FileCategories.Count > 1;
end;

procedure TFormLibraryConfiguration.RefreshLayerActions(Node: PVirtualNode;
  rc: TRootCollection);
var
  nLevel: Integer;
begin
  nLevel := VSTSortings.GetNodeLevel(Node);
  ActionEditLayer.Enabled := nLevel > 0;
  ActionAddLayer.Enabled := rc.SpecialContent = scRegular; //NOT rc.IsDirectoryCollection;
  ActionDeleteLayer.Enabled := (nLevel = 0) or (rc.LayerDepth > 1)
end;

procedure TFormLibraryConfiguration.PopupCategoriesPopup(Sender: TObject);
var
  aNode: PVirtualNode;
  curIdx, newIdx: Integer;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then begin
    ActionMoveCategoryUp.Enabled := False;
    ActionMoveCategoryDown.Enabled := False;
  end else
  begin
    curIdx := aNode.Index;
    newIdx := getNextIdx(curIdx, mdUp);
    ActionMoveCategoryUp.Enabled := ValidRange(curIdx, newIdx, FileCategories.Count-1);
    newIdx := getNextIdx(curIdx, mdDown);
    ActionMoveCategoryDown.Enabled := ValidRange(curIdx, newIdx, FileCategories.Count-1);
  end;
end;


procedure TFormLibraryConfiguration.MoveCategory(Direction: teMoveDirection);
var
  aNode: PVirtualNode;
  curIdx, newIdx: Integer;
begin
  fCategoriesChanged := True;
  aNode := VSTCategories.FocusedNode;
  curIdx := aNode.Index;
  newIdx := getNextIdx(curIdx, Direction);

  if ValidRange(curIdx, newIdx, FileCategories.Count-1) then begin
    FileCategories.Move(curIdx, newIdx);
    case Direction of
      mdUp: VSTCategories.MoveTo(aNode, VSTCategories.GetPreviousSibling(aNode), amInsertBefore, false );
      mdDown: VSTCategories.MoveTo(aNode, VSTCategories.GetNextSibling(aNode), amInsertAfter, false );
    end;
    VSTCategories.Invalidate;
  end;
end;

procedure TFormLibraryConfiguration.ActionMoveCategoryDownExecute(
  Sender: TObject);
begin
  MoveCategory(mdDown);
end;

procedure TFormLibraryConfiguration.ActionMoveCategoryUpExecute(
  Sender: TObject);
begin
  MoveCategory(mdUp);
end;


procedure TFormLibraryConfiguration.PopupLayersPopup(Sender: TObject);
var
  aNode: PVirtualNode;
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then begin
    ActionLayerMoveUp.Enabled := False;
    ActionLayerMoveDown.Enabled := False;
    ActionAddLayer.Enabled := False;
    ActionEditLayer.Enabled := False;
    ActionDeleteLayer.Enabled := False;
  end else begin
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    level := VSTSortings.GetNodeLevel(aNode);

    if level = 0 then begin
      curIdx := aNode.Index;
      newIdx := getNextIdx(curIdx, mdUp);
      ActionLayerMoveUp.Enabled := ValidRange(curIdx, newIdx, RootCollections.Count-1);
      newIdx := getNextIdx(curIdx, mdDown);
      ActionLayerMoveDown.Enabled := ValidRange(curIdx, newIdx, RootCollections.Count-1);
    end
    else begin
      curIdx := level - 1;
      newIdx := getNextIdx(curIdx, mdUp);
      ActionLayerMoveUp.Enabled := ValidRange(curIdx, newIdx, rc.LayerDepth-1);
      newIdx := getNextIdx(curIdx, mdDown);
      ActionLayerMoveDown.Enabled := ValidRange(curIdx, newIdx, rc.LayerDepth-1)
    end;
  end;
end;

procedure TFormLibraryConfiguration.MoveLayer(Direction: teMoveDirection);
var
  aNode: PVirtualNode;
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;

  fCollectionsChanged := True;
  rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
  level := VSTSortings.GetNodeLevel(aNode);

  if level = 0 then begin
    curIdx := aNode.Index;
    newIdx := getNextIdx(curIdx, Direction);

    if ValidRange(curIdx, newIdx, RootCollections.Count-1) then begin
      RootCollections.Move(curIdx, newIdx);
      case Direction of
        mdUp: VSTSortings.MoveTo(aNode, VSTSortings.GetPreviousSibling(aNode), amInsertBefore, false );
        mdDown: VSTSortings.MoveTo(aNode, VSTSortings.GetNextSibling(aNode), amInsertAfter, false );
      end;
      VSTSortings.Invalidate;
    end;
  end
  else begin
    curIdx := level - 1;
    newIdx := getNextIdx(curIdx, Direction);
    if ValidRange(curIdx, newIdx, rc.LayerDepth-1) then begin
      rc.MoveSubCollectionType(curIdx, newIdx);

      case Direction of
        mdUp: VSTSortings.FocusedNode := aNode.Parent;
        mdDown: VSTSortings.FocusedNode := aNode.FirstChild;
      end;
      VSTSortings.Selected[aNode] := False;
      VSTSortings.Selected[VSTSortings.FocusedNode] := True;

      VSTSortings.Invalidate;
    end;
  end;
end;

procedure TFormLibraryConfiguration.ActionLayerMoveDownExecute(Sender: TObject);
begin
  MoveLayer(mdDown);
end;

procedure TFormLibraryConfiguration.ActionLayerMoveUpExecute(Sender: TObject);
begin
  MoveLayer(mdUp);
end;

procedure TFormLibraryConfiguration.BtnOKClick(Sender: TObject);
begin
  BtnApply.Click;
  Close;
end;

function TFormLibraryConfiguration.NewUniqueCategoryIndex(CatEdit, CatLibrary: TLibraryCategoryList): Integer;
begin
  result := 0;
  while CategoryIndexExists(result, CatEdit, CatLibrary) do begin
    inc(result);
  end;
end;

procedure TFormLibraryConfiguration.EnsureDefaultCategoryIsSet;
begin
  if GetDefaultCategoryIndex(FileCategories) = -1 then
    SetDefaultCategoryIndex(FileCategories, 0);
end;

procedure TFormLibraryConfiguration.EnsureNewCategoryIsSet;
begin
  if GetNewCategoryIndex(FileCategories) = -1 then
    SetNewCategoryIndex(FileCategories, 0);
end;

{
  ActionAddCategoryExecute
  Add a new Category to the list
}
procedure TFormLibraryConfiguration.ActionAddCategoryExecute(Sender: TObject);
var
  newCat: TLibraryFileCategory;
begin
  fCategoriesChanged := True;
  newCat := TLibraryFileCategory.Create;
  newCat.Name := NewUniqueCategoryName(FileCategories);
  newCat.Index := NewUniqueCategoryIndex(self.FileCategories, MedienBib.FileCategories);

  if newCat.Index < 32 then begin
    FileCategories.Add(newCat);
    VSTCategories.AddChild(Nil, newCat);
  end else
  begin
    newCat.Free;
    TranslateMessageDLG(LibraryOrganizer_NoMoreCategoriesPossible, mtInformation, [MBOK], 0);
  end;

  RefreshCategoryButtons;
  FillCategoryComboBoxes;
end;

{
  ActionDeleteCategoryExecute
  Removes the selected Category from the list
}
procedure TFormLibraryConfiguration.ActionDeleteCategoryExecute(
  Sender: TObject);
var
  aNode, reselectNode: PVirtualNode;
  lc: TLibraryCategory;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCategoriesChanged := True;
  // get the next node that should be selected after the current one is removed
  reselectNode := VSTCategories.GetNextSibling(aNode);
  if not assigned(reselectNode) then
    VSTCategories.GetPreviousSibling(aNode);
  // remove the Category and its node
  lc := VSTCategories.GetNodeData<TLibraryCategory>(aNode);
  VSTCategories.DeleteNode(aNode);
  FileCategories.Remove(lc);
  lc.Free;
  // select another node
  if assigned(reselectNode) then begin
    VSTCategories.FocusedNode := reselectNode;
    VSTCategories.Selected[reselectNode] := True;
  end;

  EnsureDefaultCategoryIsSet;
  EnsureNewCategoryIsSet;
  RefreshCategoryButtons;
  FillCategoryComboBoxes;
end;

procedure TFormLibraryConfiguration.PrepareEditLayerForm(AllowDirectory: Boolean;
  aType: teCollectionContent; aSorting: teCollectionSorting);
begin
  if not assigned(FormNewLayer) then
    Application.CreateForm(TFormNewLayer, FormNewLayer);
  FormNewLayer.FillPropertiesSelection(AllowDirectory);
  FormNewLayer.SetDefaultValues(aType, aSorting);
  FormNewLayer.EditValue := True;
end;

procedure TFormLibraryConfiguration.PrepareNewLayerForm(isRoot: Boolean);
begin
  if not assigned(FormNewLayer) then
    Application.CreateForm(TFormNewLayer, FormNewLayer);
  FormNewLayer.FillPropertiesSelection(isRoot);
  FormNewLayer.EditValue := False;
end;

procedure TFormLibraryConfiguration.ActionAddRootLayerExecute(Sender: TObject);
var
  newRoot: TRootCollection;
  NewNode: PVirtualNode;
  iLevel: Integer;
begin
  PrepareNewLayerForm(True);
  if FormNewLayer.ShowModal = mrOk then begin
    fCollectionsChanged := True;
    newRoot := TRootCollection.Create(Nil);
    newRoot.AddSubCollectionType(FormNewLayer.CollectionType, FormNewLayer.SortingType);
    RootCollections.Add(newRoot);
    NewNode := VSTSortings.AddChild(nil, newRoot);
    for iLevel := 0 to TRootCollection(newRoot).LayerDepth - 1 do
      newNode := VSTSortings.AddChild(newNode, newRoot);
  end;
end;

procedure TFormLibraryConfiguration.ActionAddLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;

  PrepareNewLayerForm(False);
  if FormNewLayer.ShowModal = mrOk then begin
    fCollectionsChanged := True;
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    rc.InsertSubCollectionType(VSTSortings.GetNodeLevel(aNode), FormNewLayer.CollectionType, FormNewLayer.SortingType);
    // The data assigned to each node under one RootCollectionNode is all the same, so we can just add a new child
    // at the end of the current subtree and trigger a repaint of the Tree
    while aNode.ChildCount > 0 do
      aNode := aNode.FirstChild;
    VSTSortings.AddChild(aNode, rc);
    VSTSortings.Expanded[aNode] := True;
    VSTSortings.Invalidate;
  end;
end;


procedure TFormLibraryConfiguration.ActionDeleteLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  level: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCollectionsChanged := True;
  level := VSTSortings.GetNodeLevel(aNode);
  if level = 0 then begin
    // delete the RootCollection
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    VSTSortings.DeleteNode(aNode);
    VSTSortings.Invalidate;
    RootCollections.Remove(rc);
    rc.Free;
  end else
  begin
    // delete a sub-layer from the RootCollection
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    // delete the node first (i.e. the last child in this subtree)
    while aNode.ChildCount > 0 do
      aNode := aNode.FirstChild;
    VSTSortings.DeleteNode(aNode);
    // delete the collection layer
    rc.RemoveSubCollection(level-1);
    VSTSortings.Invalidate;
  end;
end;

procedure TFormLibraryConfiguration.ActionEditCategoryExecute(Sender: TObject);
var
  aNode: PVirtualNode;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCategoriesChanged := True;
  VSTCategories.EditNode(aNode, 0);
end;

procedure TFormLibraryConfiguration.ActionEditLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  level: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCollectionsChanged := True;
  level := VSTSortings.GetNodeLevel(aNode);
  if level > 0 then begin
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);

    PrepareEditLayerForm(rc.LayerDepth <= 1,
        rc.CollectionConfigList[level-1].CollectionContent,
        rc.CollectionConfigList[level-1].CollectionSorting
        );

    if FormNewLayer.ShowModal = mrOk then begin
      rc.ChangeSubCollectionType(level-1,
        FormNewLayer.CollectionType,
        FormNewLayer.SortingType
      );

      RefreshLayerActions(aNode, rc);
      VSTSortings.Invalidate;
    end;
  end;
end;


procedure TFormLibraryConfiguration.BtnApplyClick(Sender: TObject);
var
  i: Integer;
  newCat: TLibraryFileCategory;
begin
  if fCategoriesChanged then begin
    MedienBib.ClearFileCategories;
    // create new Categories in Medienbib
    for i := 0 to FileCategories.Count - 1 do begin
      newCat := TLibraryFileCategory.Create;
      newCat.AssignSettings(FileCategories[i]);
      MedienBib.FileCategories.Add(newCat);
    end;
    MedienBib.DefaultFileCategory := TLibraryFileCategory(GetDefaultCategory(MedienBib.FileCategories));
    MedienBib.NewFilesCategory := TLibraryFileCategory(GetNewCategory(MedienBib.FileCategories));
  end;

  if fCollectionsChanged then begin
    // Convert RootCollections to OrganizerSettings
    OrganizerSettings.Clear;
    for i := 0 to RootCollections.Count - 1 do begin
      OrganizerSettings.AddConfig(TRootCollection(RootCollections[i]).CollectionConfigList);
    end;
    OrganizerSettings.ChangeCoverFlowSorting(
      teCollectionSorting(cbCoverFlowSorting.Items.Objects[cbCoverFlowSorting.ItemIndex])
    );
  end;

  OrganizerSettings.AlbumKeyMode := teAlbumKeyMode(cbAlbumKeymode.ItemIndex);
  OrganizerSettings.TrimCDFromDirectory := cbIgnoreCDDirectories.Checked;
  OrganizerSettings.CDNames.DelimitedText := editCDNames.Text;
  OrganizerSettings.ShowCollectionCount := cbShowCollectionCount.Checked;
  OrganizerSettings.ShowCategoryCount := cbShowCategoryCount.Checked;
  OrganizerSettings.ShowCoverArtOnAlbum := cbShowCoverForAlbum.Checked;
  OrganizerSettings.UseNewCategory := checkBoxNewFilesCategory.Checked;
  OrganizerSettings.PlaylistCaptionMode := tePlaylistCaptionMode(cbPlaylistCaptionMode.ItemIndex);
  NempOrganizerSettings.Assign(OrganizerSettings);

  MedienBib.ReFillFileCategories;
end;

procedure TFormLibraryConfiguration.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

{
  ------------------------------
  Drag&Drop of Categories
  ------------------------------
}
procedure TFormLibraryConfiguration.VSTCategoriesDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TFormLibraryConfiguration.VSTCategoriesDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
  Accept := Source = VSTCategories;
end;

procedure TFormLibraryConfiguration.VSTCategoriesDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);
var
  aNode, focusNode: PVirtualNode;
  lc: TLibraryCategory;
begin
  fCategoriesChanged := True;
  focusNode := VSTCategories.FocusedNode;
  case Mode of
    dmNowhere: VSTCategories.MoveTo(focusNode, VSTCategories.RootNode, amInsertAfter, False);
    dmAbove: VSTCategories.MoveTo(focusNode, VSTCategories.DropTargetNode, amInsertBefore, False);
    dmOnNode,
    dmBelow: VSTCategories.MoveTo(focusNode, VSTCategories.DropTargetNode, amInsertAfter, False);
  end;
  VSTCategories.Invalidate;

  // Fill the FileCategories according to the new Node order.
  // Don't use "Move" here, as Index-Calculation would be a lot trickier here
  aNode := Sender.GetFirst;
  while assigned(aNode) do begin
    lc := Sender.GetNodeData<TLibraryCategory>(aNode);
    FileCategories[aNode.Index] := lc;
    aNode := Sender.GetNextSibling(aNode);
  end;
end;


{
  ------------------------------
  Drag&Drop of Category Layers
  ------------------------------
}
procedure TFormLibraryConfiguration.VSTSortingsDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
var
  rcD: TRootCollection;
begin
  rcD := Sender.GetNodeData<TRootCollection>(Node);
  Allowed := (Sender.GetNodeLevel(Node) = 0) or (rcD.LayerDepth > 1);
end;

procedure TFormLibraryConfiguration.VSTSortingsDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
var
  rcF, rcD: TRootCollection;
begin
  Accept := Source = VSTSortings;
  if not accept then
    exit;  // nothing more to test

  rcF := Sender.GetNodeData<TRootCollection>(Sender.FocusedNode);
  if assigned(Sender.DropTargetNode) then
    rcD := Sender.GetNodeData<TRootCollection>(Sender.DropTargetNode)
  else
    rcD := Sender.GetNodeData<TRootCollection>(Sender.GetLast);

  // Accept within the same RootCollection ( => change Layer order)
  // or move the complete RootCollection (=> Change order of RootCollections)
  accept := (rcF = rCD) or (Sender.GetNodeLevel(Sender.FocusedNode) = 0);
end;

procedure TFormLibraryConfiguration.VSTSortingsDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);
var
  rcF, rcD: TRootCollection;
  focusNode, aNode, DropRoot: PVirtualNode;
  curIdx, targetIdx, idxModifier: Cardinal;
begin
  rcF := Sender.GetNodeData<TRootCollection>(Sender.FocusedNode);
  fCollectionsChanged := True;

  focusNode := Sender.FocusedNode;
  DropRoot := VSTSortings.DropTargetNode;
  while Sender.GetNodeLevel(DropRoot) > 0 do
    DropRoot := DropRoot.Parent;

  if (Sender.GetNodeLevel(focusNode) = 0) then begin
    // correct DropMode if the user drops a "Level-0-Node" over a node which higher level
    if assigned(VSTSortings.DropTargetNode) then begin
      if (DropRoot.Index < focusNode.Index) and (Sender.GetNodeLevel(VSTSortings.DropTargetNode) > 0)  then
        Mode := dmAbove;
      if (DropRoot.Index > focusNode.Index) and (Sender.GetNodeLevel(VSTSortings.DropTargetNode) > 0) then
        Mode := dmBelow;
    end;
    // Move the RootCollection to another position in the list
    case Mode of
      dmNowhere: VSTSortings.MoveTo(focusNode, VSTSortings.RootNode, amInsertAfter, False);
      dmAbove: VSTSortings.MoveTo(focusNode, DropRoot, amInsertBefore, False);
      dmOnNode,
      dmBelow: VSTSortings.MoveTo(focusNode, DropRoot, amInsertAfter, False);
    end;
    // Fill the Category-Layers according to the new Node order.
    aNode := Sender.GetFirst;
    while assigned(aNode) do begin
      rcD := Sender.GetNodeData<tRootCollection>(aNode);
      RootCollections[aNode.Index] := rcD;
      aNode := Sender.GetNextSibling(aNode);
    end;

  end else
  begin
    // we are moving a Layer within the same RootCollection
    curIdx := Sender.GetNodeLevel(focusNode) - 1;
    targetIdx := Sender.GetNodeLevel(VSTSortings.DropTargetNode) - 1;
    // modify the targetIdx according to Drop-Direction
    if (targetIdx < curIdx) then
      idxModifier := 1
    else
      idxModifier := 0;

    case Mode of
      dmNowhere: targetIdx := rcF.LayerDepth - 1;
      dmAbove: targetIdx := targetIdx + idxModifier - 1;
      dmOnNode,
      dmBelow: targetIdx := targetIdx + idxModifier;
    end;

    rcF.MoveSubCollectionType(curIdx, targetIdx);

    // Repaint the tree and set the focussed node to the just moved node
    VSTSortings.Invalidate;
    aNode := DropRoot;
    while assigned(aNode) and (Sender.GetNodeLevel(aNode) <= targetIdx) do
      aNode := aNode.FirstChild;
    Sender.FocusedNode := aNode;
    Sender.Selected[aNode] := True;
  end;

end;


end.
