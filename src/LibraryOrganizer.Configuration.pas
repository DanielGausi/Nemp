unit LibraryOrganizer.Configuration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, System.Generics.Defaults,
  gnuGettext, Nemp_RessourceStrings, MyDialogs, NempAudioFiles, LibraryOrganizer.Configuration.NewLayer,
  LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists,
  Vcl.StdCtrls, Vcl.ExtCtrls, VirtualTrees, Vcl.ComCtrls, System.Actions,
  Vcl.ActnList, Vcl.Menus;

type
  (*TDisplayRootCollectionConfig = class
    private

      FRootCollectionConfig: TRootCollectionConfig;
    public
      constructor create(aRootCollectionConfig: TRootCollectionConfig);
      destructor Destroy; override;

  end;

  TDisplayRootCollectionConfigList = class(TObjectList<TDisplayRootCollectionConfig>);
  *)

  TFormLibraryConfiguration = class(TForm)
    PnlButtons: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    PageControl1: TPageControl;
    tsCategories: TTabSheet;
    tsSettings: TTabSheet;
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
    BtnMoveLayer: TUpDown;
    BtnMoveCategories: TUpDown;
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
    cbShowCount: TCheckBox;
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
    procedure VSTCategoriesPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure cbDefaultCategoryChange(Sender: TObject);
    procedure cbNewFilesCategoryChange(Sender: TObject);
    procedure ActionAddCategoryExecute(Sender: TObject);
    procedure ActionDeleteCategoryExecute(Sender: TObject);
    procedure ActionAddRootLayerExecute(Sender: TObject);
    procedure ActionAddLayerExecute(Sender: TObject);
    procedure ActionDeleteLayerExecute(Sender: TObject);
    procedure BtnMoveLayerClick(Sender: TObject; Button: TUDBtnType);
    procedure BtnApplyClick(Sender: TObject);
    procedure VSTSortingsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BtnMoveCategoriesClick(Sender: TObject; Button: TUDBtnType);
    procedure ActionEditLayerExecute(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure ActionEditCategoryExecute(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    //procedure VSTSortingsFocusChanged(Sender: TBaseVirtualTree;
    //  Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
    FileCategories: TLibraryCategoryList;
    RootCollections: TAudioCollectionList;
    OrganizerSettings: TOrganizerSettings;
    //DisplayRootCollectionConfigList: TDisplayRootCollectionConfigList;

    procedure FillCategoryTree;
    procedure FillCategoryComboBoxes;
    procedure FillCollectionTree;

    procedure RefreshCategoryButtons;
    procedure RefreshLayerActions(Node: PVirtualNode; rc: TRootCollection);



    procedure PrepareNewLayerForm(isRoot: Boolean);
    procedure PrepareEditLayerForm(AllowDirectory: Boolean; aType: teCollectionType; aSorting: teCollectionSorting);


    function CategoryNameExists(aName: String; Categories: TLibraryCategoryList): Boolean;
    function NewUniqueCategoryName(Categories: TLibraryCategoryList): String;

    function CategoryIndexExists(aIndex: Integer; CatEdit, CatLibrary: TLibraryCategoryList): Boolean; overload;
    function CategoryIndexExists(aIndex: Integer; Categories: TLibraryCategoryList): Boolean; overload;

    function NewUniqueCategoryIndex(CatEdit, CatLibrary: TLibraryCategoryList): Integer;

    procedure EnsureDefaultCategoryIsSet;
    procedure EnsureNewCategoryIsSet;


  public
    { Public declarations }
  end;

  {
  Benötigt wird:
  - Eine Liste mit Categorien (wie in der medienbibliothek, mit diesen Werten initialisiert)
  - Eine kopie vom globalen Objekt NempOrganizerSettings, inkl. "Assign"

  }

var
  FormLibraryConfiguration: TFormLibraryConfiguration;

implementation

uses NempMainUnit;

{$R *.dfm}

function getNextIdx(const aIdx: Integer; Button: TUDBtnType): Integer;
begin
  case Button of
    btNext: result := aIdx - 1;
    btPrev: result := aIdx + 1;
  end;
end;

function ValidRange(aIdx, bIdx, maxIdx: Integer): Boolean;
begin
  result := (aIdx >= 0) and (bIdx >= 0)
        and (aIdx <= maxIdx) and (bIdx <= maxIdx);
end;



procedure TFormLibraryConfiguration.FormCreate(Sender: TObject);
begin
  FileCategories := TLibraryCategoryList.Create(True);
  OrganizerSettings := TOrganizerSettings.create;
  RootCollections := TAudioCollectionList.Create(True);

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
  FileCategories.Free;
  OrganizerSettings.Free;
  RootCollections.Free;
end;

procedure TFormLibraryConfiguration.FormShow(Sender: TObject);
var
  i, iRC: Integer;
  newCat: TLibraryFileCategory;
  newRoot: TRootCollection;
  aRootConfig: TCollectionTypeList;
begin
  OrganizerSettings.Assign(NempOrganizerSettings);

  RootCollections.Clear;
  for iRC := 0 to OrganizerSettings.RootCollectionCount - 1 do begin
    aRootConfig := OrganizerSettings.RootCollectionConfig[iRC];
    newRoot := TRootCollection.Create(Nil);
    for i := 0 to aRootConfig.Count - 1 do begin
      newRoot.AddSubCollectionType(aRootConfig[i].CollectionType, aRootConfig[i].CollectionSorting);
    end;
    RootCollections.Add(newRoot);
  end;

  FileCategories.Clear;
  for i := 0 to MedienBib.FileCategories.Count - 1 do begin
    newCat := TLibraryFileCategory.Create;
    newCat.AssignSettings(MedienBib.FileCategories[i]);
    FileCategories.Add(newCat);
  end;

  FillCategoryTree;
  FillCategoryComboBoxes;
  FillCollectionTree;

  cbCoverFlowSorting.ItemIndex := cbCoverFlowSorting.Items.IndexOfObject(
    TObject(OrganizerSettings.CoverFlowRootCollectionConfig[0].CollectionSorting)
  );

  cbAlbumKeymode.ItemIndex := Integer(OrganizerSettings.AlbumKeyMode);
  cbIgnoreCDDirectories.Checked := OrganizerSettings.TrimCDFromDirectory;
  editCDNames.Text := OrganizerSettings.CDNames.DelimitedText;
  cbShowCount.Checked := OrganizerSettings.ShowCollectionCount;
  cbShowCoverForAlbum.Checked := OrganizerSettings.ShowCoverArtOnAlbum;
  cbPlaylistCaptionMode.ItemIndex := Integer(OrganizerSettings.PlaylistCaptionMode);
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
  CellText := lc.Name + ' ' + IntToStr(lc.Index) ;
end;

procedure TFormLibraryConfiguration.VSTCategoriesNewText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  NewText: string);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  lc.Name := NewText;
end;

procedure TFormLibraryConfiguration.VSTCategoriesPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  if lc.IsDefault then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsBold];
  if lc.IsNew then
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsItalic];
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
        + CollectionSortingNames[rc.GetCollectionCompareType(level-1)]
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
  ActionAddLayer.Enabled := NOT rc.IsDirectoryCollection;
  ActionDeleteLayer.Enabled := (nLevel = 0) or (rc.LayerDepth > 1)
end;

procedure TFormLibraryConfiguration.BtnMoveCategoriesClick(Sender: TObject;
  Button: TUDBtnType);
var
  aNode: PVirtualNode;
  curIdx, newIdx: Integer;
begin
  aNode := VSTCategories.FocusedNode;
  curIdx := aNode.Index;
  newIdx := getNextIdx(curIdx, Button);

  if ValidRange(curIdx, newIdx, FileCategories.Count-1) then begin
    FileCategories.Move(curIdx, newIdx);
    case Button of
      btNext: VSTCategories.MoveTo(aNode, VSTCategories.GetPreviousSibling(aNode), amInsertBefore, false );
      btPrev: VSTCategories.MoveTo(aNode, VSTCategories.GetNextSibling(aNode), amInsertAfter, false );
    end;
    VSTCategories.Invalidate;
  end;
end;

procedure TFormLibraryConfiguration.BtnMoveLayerClick(Sender: TObject;
  Button: TUDBtnType);
var
  aNode: PVirtualNode;
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;

  rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
  level := VSTSortings.GetNodeLevel(aNode);

  if level = 0 then begin
    curIdx := aNode.Index;
    newIdx := getNextIdx(curIdx, Button);

    if ValidRange(curIdx, newIdx, RootCollections.Count-1) then begin
      RootCollections.Move(curIdx, newIdx);
      case Button of
        btNext: VSTSortings.MoveTo(aNode, VSTSortings.GetPreviousSibling(aNode), amInsertBefore, false );
        btPrev: VSTSortings.MoveTo(aNode, VSTSortings.GetNextSibling(aNode), amInsertAfter, false );
      end;
      VSTSortings.Invalidate;
    end;
  end
  else begin
    curIdx := level - 1;
    newIdx := getNextIdx(curIdx, Button);
    if ValidRange(curIdx, newIdx, rc.LayerDepth-1) then begin
      rc.MoveSubCollectionType(curIdx, newIdx);

      case Button of
        btNext: VSTSortings.FocusedNode := aNode.Parent;
        btPrev: VSTSortings.FocusedNode := aNode.FirstChild;
      end;
      VSTSortings.Selected[aNode] := False;
      VSTSortings.Selected[VSTSortings.FocusedNode] := True;

      VSTSortings.Invalidate;
    end;
  end;
end;

procedure TFormLibraryConfiguration.BtnOKClick(Sender: TObject);
begin
  BtnApply.Click;
  Close;
end;

(*
procedure TFormLibraryConfiguration.VSTSortingsFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  if not assigned(Node) then
    exit;

  rc := VSTSortings.GetNodeData<TRootCollection>(Node);
  level := VSTSortings.GetNodeLevel(Node);

  if level = 0 then begin
    BtnMoveLayer.Min := 0;
    BtnMoveLayer.Max := RootCollections.Count;
    BtnMoveLayer.Position := Node.Index
  end
  else begin
    curIdx := level - 1;

    BtnMoveLayer.Min := 0;
    BtnMoveLayer.Max := rc.LayerDepth;
    BtnMoveLayer.Position := level-1;
  end;

  Caption := IntToStr(BtnMoveLayer.Min) + ' - ' +
             IntToStr(BtnMoveLayer.Position) + ' - ' +
             IntToStr(BtnMoveLayer.Max);

end;
*)


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
  newCat := TLibraryFileCategory.Create;
  newCat.Name := NewUniqueCategoryName(FileCategories);
  newCat.Index := NewUniqueCategoryIndex(self.FileCategories, MedienBib.FileCategories);
  newCat.SortIndex := FileCategories.Count; //SortIndex; actually needed? Or remove it from the code at all?

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
  // get the next node that should be selected after the current one is removed
  reselectNode := VSTCategories.GetNextSibling(aNode);
  if not assigned(reselectNode) then
    VSTCategories.GetPreviousSibling(aNode);
  // remove the Category and its node
  lc := VSTCategories.GetNodeData<TLibraryCategory>(aNode);
  VSTCategories.DeleteNode(aNode);
  FileCategories.Remove(lc);
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
  aType: teCollectionType; aSorting: teCollectionSorting);
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
  level := VSTSortings.GetNodeLevel(aNode);
  if level = 0 then begin
    // delete the RootCollection
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    VSTSortings.DeleteNode(aNode);
    VSTSortings.Invalidate;
    RootCollections.Remove(rc);
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
  level := VSTSortings.GetNodeLevel(aNode);
  if level > 0 then begin
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);

    PrepareNewLayerForm(rc.IsDirectoryCollection);

    PrepareEditLayerForm(rc.LayerDepth <= 1,
        rc.CollectionTypeList[level-1].CollectionType,
        rc.CollectionTypeList[level-1].CollectionSorting
        );

    if FormNewLayer.ShowModal = mrOk then begin
      rc.ChangeSubCollectionType(level-1,
        FormNewLayer.CollectionType,
        FormNewLayer.SortingType
      );

      RefreshLayerActions(aNode, rc);

      //rc.CollectionTypeList[level-1].CollectionType := FormNewLayer.CollectionType;
      //rc.CollectionTypeList[level-1].CollectionSorting :=  FormNewLayer.SortingType;

{      rc.InsertSubCollectionType(VSTSortings.GetNodeLevel(aNode), FormNewLayer.CollectionType, FormNewLayer.SortingType);
      // The data assigned to each node under one RootCollectionNode is all the same, so we can just add a new child
      // at the end of the current subtree and trigger a repaint of the Tree
      while aNode.ChildCount > 0 do
        aNode := aNode.FirstChild;
      VSTSortings.AddChild(aNode, rc);
      VSTSortings.Expanded[aNode] := True;}
      VSTSortings.Invalidate;
    end;



  end;
end;

procedure TFormLibraryConfiguration.BtnApplyClick(Sender: TObject);
var
  i: Integer;
  newCat: TLibraryFileCategory;
begin
  MedienBib.ClearFileCategories;

  // create new Categories in Medienbib
  for i := 0 to FileCategories.Count - 1 do begin
    newCat := TLibraryFileCategory.Create;
    newCat.AssignSettings(FileCategories[i]);
    MedienBib.FileCategories.Add(newCat);
  end;

  MedienBib.DefaultFileCategory := TLibraryFileCategory(GetDefaultCategory(MedienBib.FileCategories));
  MedienBib.NewFilesCategory := TLibraryFileCategory(GetNewCategory(MedienBib.FileCategories));


  // Convert RootCollections to OrganizerSettings
  OrganizerSettings.Clear;
  for i := 0 to RootCollections.Count - 1 do begin
    OrganizerSettings.AddConfig(TRootCollection(RootCollections[i]).CollectionTypeList);
  end;
  OrganizerSettings.ChangeCoverFlowSorting(
    teCollectionSorting(cbCoverFlowSorting.Items.Objects[cbCoverFlowSorting.ItemIndex])
  );

  OrganizerSettings.AlbumKeyMode := teAlbumKeyMode(cbAlbumKeymode.ItemIndex);
  OrganizerSettings.TrimCDFromDirectory := cbIgnoreCDDirectories.Checked;
  OrganizerSettings.CDNames.DelimitedText := editCDNames.Text;
  OrganizerSettings.ShowCollectionCount := cbShowCount.Checked;
  OrganizerSettings.ShowCoverArtOnAlbum := cbShowCoverForAlbum.Checked;
  OrganizerSettings.PlaylistCaptionMode := tePlaylistCaptionMode(cbPlaylistCaptionMode.ItemIndex);

  NempOrganizerSettings.Assign(OrganizerSettings);
  MedienBib.ReFillFileCategories;
end;

procedure TFormLibraryConfiguration.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
