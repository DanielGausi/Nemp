{

    Unit CloudEditor
    Form CloudEditorForm

    A Form for editing and managing the TagCloud

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}
unit CloudEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, contnrs, StrUtils, gnugettext,

  AudioFileClass, TagClouds, StdCtrls, Spin, TagHelper, ComCtrls
  ;

type

// types for the VirtualStringTree in CloudEditorForm
  TTagTreeData = record
      FTag : TTag;
  end;
  TIgnoreTagData = record
      fString: TIgnoreTagString;
  end;
  TMergeTagData = record
      fMergeTag: TTagMergeItem;
  end;

  PIgnoreTagData = ^TIgnoreTagData;
  PMergeTagData = ^TMergeTagData;
  PTagTreeData = ^TTagTreeData;


  TCloudEditorForm = class(TForm)
    LblUpdateWarning: TLabel;
    BtnUpdateID3Tags: TButton;
    BtnBugFix: TButton;
    PC_Select: TPageControl;
    TS_ExistingTags: TTabSheet;
    TS_DeleteTags: TTabSheet;
    TS_MergedTags: TTabSheet;
    cbHideAutoTags: TCheckBox;
    lblMinTagCount: TLabel;
    seMinTagCount: TSpinEdit;
    TagVST: TVirtualStringTree;
    BtnTagRename: TButton;
    BtnMerge: TButton;
    BtnDeleteTags: TButton;
    cbAutoAddMergeTags: TCheckBox;
    cbAutoAddIgnoreTags: TCheckBox;
    MergeTagVST: TVirtualStringTree;
    IgnoreTagVST: TVirtualStringTree;
    LblMergeTagHint: TStaticText;
    BtnDeleteMergeTag: TButton;
    LblDeleteTagHint: TStaticText;
    BtnDeleteIgnoreTag: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TagVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure TagVSTHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure TagVSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure TagVSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure cbHideAutoTagsClick(Sender: TObject);
    procedure seMinTagCountChange(Sender: TObject);
    procedure TagVSTIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure TagVSTKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnTagRenameClick(Sender: TObject);
    procedure BtnMergeClick(Sender: TObject);
    procedure BtnUpdateID3TagsClick(Sender: TObject);
    procedure BtnDeleteTagsClick(Sender: TObject);
    procedure TagVSTBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure BtnBugFixClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MergeTagVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure IgnoreTagVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure MergeTagVSTHeaderClick(Sender: TVTHeader;
      HitInfo: TVTHeaderHitInfo);
    procedure BtnDeleteIgnoreTagClick(Sender: TObject);
    procedure BtnDeleteMergeTagClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LocalTagList: TObjectList;

    TagPostProcessor: TTagPostProcessor;

    OldSelectionPrefix : String;

    procedure FillTagTree(reselect: Boolean = False);
    procedure SortTags;                          // Resort the Tags
    procedure ReselectNode(aKey: UTF8String);    // Reselect a node with the given key


    procedure ReselectIgnoreNode(aKey: String);
    procedure ReselectMergeNode(aOriginalKey, aReplaceKey: String);

    procedure ClearIgnoreTree;
    procedure FillIgnoreTree(reselect: Boolean = False);
    procedure FillMergeTree(reselect: Boolean = False);

    procedure SortMergetags;



  public
    { Public-Deklarationen }
    procedure ActualizeTreeView;      // get the tags from the cloud with current settings and show them in the tree

    procedure RefreshWarningLabel;       // Count "ID3TagNeedsUpdate"-AudioFiles and display are warning
  end;


var
  CloudEditorForm: TCloudEditorForm;

implementation

{$R *.dfm}

uses NempMainUnit, MedienBibliothekClass, Nemp_RessourceStrings, Math, MainFormHelper;


{
    --------------------------------------------------------
    AddVSTTag, AddVSTIgnoreTag, AddVSTMergeTag
    - Adding nodes to the VSTs
    --------------------------------------------------------
}
function AddVSTTag(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aTag: TTag): PVirtualNode;
var Data: PTagTreeData;
begin
  Result :=  AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data := AVST.GetNodeData(Result);
  Data^.FTag := aTag;
end;

function AddVSTIgnoreTag(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aString: String): PVirtualNode;
var Data: PIgnoreTagData;
begin
  Result :=  AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data := AVST.GetNodeData(Result);
  Data^.fString := TIgnoreTagString.create(aString);
end;

function AddVSTMergeTag(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aMergeTag: TTagMergeItem): PVirtualNode;
var Data: PMergeTagData;
begin
  Result :=  AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data := AVST.GetNodeData(Result);
  Data^.fMergeTag := aMergeTag;
end;

{
    --------------------------------------------------------
    Create, Destroy
    - Init/Create/Free local Lists
    --------------------------------------------------------
}
procedure TCloudEditorForm.FormCreate(Sender: TObject);
begin
    TranslateComponent (self);

    TagVST.NodeDataSize := SizeOf(TTagTreeData);
    IgnoreTagVST.NodeDataSize := SizeOf(TIgnoreTagData);
    MergeTagVST.NodeDataSize := SizeOf(TMergeTagData);

    LocalTagList := TObjectList.Create(False);
    TagPostProcessor := TTagPostProcessor.Create;

    PC_Select.ActivePageIndex := 0;
end;

procedure TCloudEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var c: Integer;
begin
    c := MedienBib.CountInconsistentFiles;

    if c > 0 then
        CanClose := MessageDLG((MediaLibrary_InconsistentFilesWarning), mtWarning, [MBYes, MBNo], 0) = mrYes
    else
        CanClose := True;
end;
procedure TCloudEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    TagPostProcessor.SaveFiles;
end;
procedure TCloudEditorForm.FormDestroy(Sender: TObject);
begin
    ClearIgnoreTree;
    LocalTagList.Free;
    TagPostProcessor.Free;
end;

procedure TCloudEditorForm.FormShow(Sender: TObject);
begin
    ActualizeTreeView;
    TagPostProcessor.LoadFiles;
    FillMergeTree(False);
    FillIgnoreTree(False);
end;


procedure TCloudEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case key of
        // Abort Action
        VK_ESCAPE: Nemp_MainForm.StopMenuClick(nil);
    end;
end;

{
    --------------------------------------------------------
    ActualizeTreeView
    FillTagTree
    - Fill the TreeView with the local Tags and current settings
    --------------------------------------------------------
}
procedure TCloudEditorForm.ActualizeTreeView;
begin
    // Get the tags from the TagCloud
    MedienBib.TagCloud.CopyTags(LocalTagList, cbHideAutoTags.Checked, seMinTagCount.Value);
    SortTags;
    // Fill the treeview
    FillTagTree;
end;


procedure TCloudEditorForm.ReselectNode(aKey: UTF8String);
var aNode: PVirtualNode;
    Data: PTagTreeData;
begin
    aNode := TagVST.GetFirst;
    Data := TagVST.GetNodeData(aNode);
    while (Data^.FTag.Key <> aKey) and (aNode <> TagVST.GetLast) do
    begin
        aNode := TagVST.GetNext(aNode);
        Data := TagVST.GetNodeData(aNode);
    end;

    TagVST.FocusedNode := aNode;
    TagVST.ScrollIntoView(aNode, True);
    TagVST.Selected[aNode] := True;
end;

procedure TCloudEditorForm.FillTagTree(reselect: Boolean = False);
var i: integer;
    oldNode: PVirtualNode;
    oldData: PTagTreeData;
    oldKey: UTf8String;
begin
    if Reselect then
    begin
        oldNode := TagVST.FocusedNode;
        if assigned(oldNode) then
        begin
            oldData := TagVST.GetNodeData(oldNode);
            oldKey := oldData^.FTag.Key;
        end;
    end;

    TagVST.BeginUpdate;
    TagVST.Clear;
    for i:=0 to LocalTagList.Count-1 do
        AddVSTTag(TagVST,Nil,TTag(LocalTagList.Items[i]));
    TagVST.EndUpdate;

    if Reselect then
        ReselectNode(oldKey);
end;

procedure TCloudEditorForm.SortTags;
begin
    // Sort LocalTagList
    if TagVST.Header.SortDirection = sdDescending then
        case TagVST.Header.SortColumn of
            0: LocalTagList.Sort(Sort_Name_DESC);
            1: LocalTagList.Sort(Sort_Count_DESC);
        end
    else
        case TagVST.Header.SortColumn of
            0: LocalTagList.Sort(Sort_Name);
            1: LocalTagList.Sort(Sort_Count);
        end;
end;


procedure TCloudEditorForm.SortMergetags;
begin
    if MergeTagVST.Header.SortDirection = sdDescending then
        case MergeTagVST.Header.SortColumn of
            0: TagPostProcessor.MergeList.Sort(Sort_OriginalKey_DESC);
            1: TagPostProcessor.MergeList.Sort(Sort_ReplaceKey_DESC);
        end
    else
        case MergeTagVST.Header.SortColumn of
            0: TagPostProcessor.MergeList.Sort(Sort_OriginalKey);
            1: TagPostProcessor.MergeList.Sort(Sort_ReplaceKey);
        end;
end;



procedure TCloudEditorForm.ReselectIgnoreNode(aKey: String);
var aNode: PVirtualNode;
    Data: PIgnoreTagData;
begin
    aNode := IgnoreTagVST.GetFirst;
    Data := IgnoreTagVST.GetNodeData(aNode);
    while (Data^.fString.DataString <> aKey) and (aNode <> IgnoreTagVST.GetLast) do
    begin
        aNode := IgnoreTagVST.GetNext(aNode);
        Data := IgnoreTagVST.GetNodeData(aNode);
    end;

    IgnoreTagVST.FocusedNode := aNode;
    IgnoreTagVST.ScrollIntoView(aNode, True);
    IgnoreTagVST.Selected[aNode] := True;
end;

procedure TCloudEditorForm.ClearIgnoreTree;
var aNode: PVirtualNode;
    aData: PIgnoreTagData;
    dummy, tmp: TIgnoreTagString;

begin
    // just to be sure, use dummy-objects while clearing.
    dummy := TIgnoreTagString.create('');
    try
        aNode := IgnoreTagVST.GetFirst;
        while assigned(aNode) do
        begin
            aData := IgnoreTagVST.GetNodeData(aNode);
            tmp := aData.fString;
            aData.fString := dummy;
            tmp.Free;
            aNode := IgnoreTagVST.GetNext(aNode);
        end;
    finally
        IgnoreTagVST.Clear;
        dummy.Free;
    end;
end;

procedure TCloudEditorForm.FillIgnoreTree(reselect: Boolean);
var i: integer;
    oldNode: PVirtualNode;
    oldData: PIgnoreTagData;
    oldKey: String;
begin
    if Reselect then
    begin
        oldNode := IgnoreTagVST.FocusedNode;
        if assigned(oldNode) then
        begin
            oldData := IgnoreTagVST.GetNodeData(oldNode);
            oldKey := oldData^.fString.DataString;
        end;
    end;

    IgnoreTagVST.BeginUpdate;
    ClearIgnoreTree;

    for i:=0 to TagPostProcessor.IgnoreList.Count-1 do
        AddVSTIgnoreTag(IgnoreTagVST, Nil, TagPostProcessor.IgnoreList[i]);
    IgnoreTagVST.EndUpdate;

    if Reselect then
        ReselectIgnoreNode(oldKey);
end;

procedure TCloudEditorForm.ReselectMergeNode(aOriginalKey, aReplaceKey: String);
var aNode: PVirtualNode;
    Data: PMergeTagData;
begin
    aNode := MergeTagVST.GetFirst;
    Data := MergeTagVST.GetNodeData(aNode);
    while (Data^.fMergeTag.OriginalKey <> aOriginalKey)
          and (Data^.fMergeTag.ReplaceKey <> aReplaceKey)
          and (aNode <> MergeTagVST.GetLast) do
    begin
        aNode := MergeTagVST.GetNext(aNode);
        Data := MergeTagVST.GetNodeData(aNode);
    end;

    MergeTagVST.FocusedNode := aNode;
    MergeTagVST.ScrollIntoView(aNode, True);
    MergeTagVST.Selected[aNode] := True;
end;

procedure TCloudEditorForm.FillMergeTree(reselect: Boolean);
var i: integer;
    oldNode: PVirtualNode;
    oldData: PMergeTagData;
    oldOriginalKey, oldReplacekey: String;
begin
    if Reselect then
    begin
        oldNode := MergeTagVST.FocusedNode;
        if assigned(oldNode) then
        begin
            oldData := MergeTagVST.GetNodeData(oldNode);
            oldOriginalKey := oldData^.fMergeTag.OriginalKey;
            oldReplacekey  := oldData^.fMergeTag.ReplaceKey;
        end;
    end;

    MergeTagVST.BeginUpdate;
    MergeTagVST.Clear;
    for i:=0 to TagPostProcessor.MergeList.Count-1 do
        AddVSTMergeTag(MergeTagVST, Nil, TTagMergeItem(TagPostProcessor.MergeList[i]));
    MergeTagVST.EndUpdate;

    if Reselect then
        ReselectMergeNode(oldOriginalKey, oldReplacekey);
end;


procedure TCloudEditorForm.RefreshWarningLabel;
var c: Integer;
begin
    c := MedienBib.CountInconsistentFiles;
    LblUpdateWarning.Caption := Format(TagEditor_FilesNeedUpdate, [c]);
    LblUpdateWarning.Visible := c > 0;
    BtnUpdateID3Tags.Enabled := c > 0;
end;


{
    --------------------------------------------------------
    cbHideAutoTagsClick
    seMinTagCountChange
    - Fill the TreeView with the local Tags and current settings
    --------------------------------------------------------
}
procedure TCloudEditorForm.cbHideAutoTagsClick(Sender: TObject);
begin
    ActualizeTreeView;
end;
procedure TCloudEditorForm.seMinTagCountChange(Sender: TObject);
begin
    ActualizeTreeView;
end;

{
    --------------------------------------------------------
    TagVSTColumnDblClick
    - Show all Audiofiles from the Tag in MainWindow
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var aNode: PVirtualNode;
    Data: PTagTreeData;
begin
    aNode := TagVST.FocusedNode;
    if assigned(aNode) then
    begin
        Data := TagVST.GetNodeData(aNode);
        if assigned(Data) then
            MedienBib.GenerateAnzeigeListeFromTagCloud(Data^.FTag, False);
    end;
end;

{
    --------------------------------------------------------
    TagVSTGetText
    - Get a proper Srting (key/count) to display
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PTagTreeData;
begin
    Data := TagVST.GetNodeData(Node);
    if assigned(Data) then
    begin
        case Column of
          0: CellText := Data^.FTag.Key;
          1: CellText := IntToStr(Data^.FTag.count);
        end;
    end;
end;

procedure TCloudEditorForm.MergeTagVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PMergeTagData;
begin
    Data := MergeTagVST.GetNodeData(Node);
    if assigned(Data) then
    begin
        case Column of
          0: CellText := Data^.fMergeTag.OriginalKey;
          1: CellText := Data^.fMergeTag.ReplaceKey;
        end;
    end;
end;



procedure TCloudEditorForm.IgnoreTagVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PIgnoreTagData;
begin
    Data := IgnoreTagVST.GetNodeData(Node);
    if assigned(Data) then
    begin
        case Column of
          0: CellText := Data^.fString.DataString;
        end;
    end;
end;

{
    --------------------------------------------------------
    TagVSTHeaderClick
    - Sort the Tags (by name or by count)
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if (HitInfo.Button = mbLeft) then
  begin
      if (HitInfo.Column > -1 ) then
      begin
          if HitInfo.Column = TagVST.Header.SortColumn then
              // Swap SortDirection
              case TagVST.Header.SortDirection of
                  sdAscending:  TagVST.Header.SortDirection := sdDescending;
                  sdDescending: TagVST.Header.SortDirection := sdAscending;
              end;
          // Set SortColumn
          TagVST.Header.SortColumn := HitInfo.Column;

          SortTags;
          // Show Tags in TreeView
          FillTagTree(True);
      end;
  end;
end;

procedure TCloudEditorForm.MergeTagVSTHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
    if (HitInfo.Button = mbLeft) then
    begin
        if (HitInfo.Column > -1 ) then
        begin
            if HitInfo.Column = MergeTagVST.Header.SortColumn then
                // Swap SortDirection
                case MergeTagVST.Header.SortDirection of
                    sdAscending:  MergeTagVST.Header.SortDirection := sdDescending;
                    sdDescending: MergeTagVST.Header.SortDirection := sdAscending;
                end;
            // Set SortColumn
            MergeTagVST.Header.SortColumn := HitInfo.Column;

            SortMergeTags;
            // Show in TreeView
            FillMergeTree(True);
        end;
    end;
end;


{
    --------------------------------------------------------
    TagVSTIncrementalSearch
    - IncrementalSearch in the TagTree
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var Data: PTagTreeData;
    aString: String;
begin
    Data := TagVST.GetNodeData(Node);
    OldSelectionPrefix := SearchText;

    if assigned(Data) then
    begin
        aString := Data^.FTag.Key;
//        Result := StrLIComp(PChar(SearchText), PChar(aString), Min(length(SearchText), length(aString)));
        Result := StrLIComp(PChar(SearchText), PChar(aString), length(SearchText));
    end;
end;

{
    --------------------------------------------------------
    TagVSTKeyDown
    - F3: IncrementalSearch to next
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var ScrollNode, aNode: PVirtualNode;
    erfolg: boolean;
    Data: PTagTreeData;

        function GetNodeWithPrefix(StartNode:PVirtualNode; Prefix: String; var Erfolg:boolean):PVirtualNode;
        var nextnode:PVirtualnode;
            Data: PTagTreeData;
            aString: String;
        begin
          erfolg := false;
          nextnode := startNode;
          repeat
              Data := TagVST.GetNodeData(nextnode);
              aString := Data^.FTag.Key;
              erfolg := AnsiStartsText(Prefix, aString);
              result := Nextnode;

              // nächsten Knoten wählen
              nextnode := TagVST.GetNext(nextnode);
              // oder vorne wieder anfangen
              if nextnode = NIL then
                  nextnode := TagVST.GetFirst;
          until erfolg or (nextnode = startnode);
          if not erfolg then result := nextnode;
        end;

begin
    case key of
        VK_F3: begin
            if OldSelectionPrefix = '' then Exit;
            if not Assigned(TagVST.FocusedNode) then Exit;
            // nächstes Vorkommen des Prefixes suchen, dazu: beim nächsten Knoten beginnen
            if TagVST.GetNext(TagVST.FocusedNode) <> NIL then
                ScrollNode := GetNodeWithPrefix(TagVST.GetNext(TagVST.FocusedNode), OldSelectionPrefix,erfolg)
            else
                ScrollNode := GetNodeWithPrefix(TagVST.GetFirst,  OldSelectionPrefix, erfolg);
            if erfolg then
            begin
              // den alten deselektieren, und zum neuen hinscrollen, Focus setzen und selektieren
              TagVST.Selected[TagVST.FocusedNode] := False;
              TagVST.ScrollIntoView(ScrollNode, True);
              TagVST.FocusedNode := ScrollNode;
              TagVST.Selected[ScrollNode] := True;
            end;
        end;
        VK_Return: begin
            aNode := TagVST.FocusedNode;
            if assigned(aNode) then
            begin
                Data := TagVST.GetNodeData(aNode);
                if assigned(Data) then
                    MedienBib.GenerateAnzeigeListeFromTagCloud(Data^.FTag, False);
            end;
        end;
    end;
end;


{
    --------------------------------------------------------
    TagVSTBeforeItemErase
    - Paint Breadcrumb-Tags of the Cloud with a different background
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
var Data: PTagTreeData;
begin
    Data := TagVST.GetNodeData(Node);
    with TargetCanvas do
    begin
        if Data^.FTag.BreadCrumbIndex < High(Integer) then
            ItemColor := $CCCCCC
        else
            ItemColor := TagVST.Color;
        EraseAction := eaColor;
    end;
end;
{
    --------------------------------------------------------
    TagVSTPaintText
    - Paint Autotags italic
    --------------------------------------------------------
}
procedure TCloudEditorForm.TagVSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var Data: PTagTreeData;
    aTag: TTag;
begin
    Data := TagVST.GetNodeData(Node);
    if assigned(Data) then
    begin
        aTag := Data^.FTag;

        if aTag.IsAutoTag then
            TargetCanvas.Font.Style := [fsItalic];
    end;
end;

{
    --------------------------------------------------------
    BtnTagRenameClick
    - Rename the focussed Tag
    --------------------------------------------------------
}
procedure TCloudEditorForm.BtnTagRenameClick(Sender: TObject);
var newKey: String;
    Data: PTagTreeData;
begin
    if MedienBib.StatusBibUpdate > 1 then
        MessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0)
    else
        if assigned(TagVST.FocusedNode) then
        begin
            Data := TagVST.GetNodeData(TagVST.FocusedNode);

            newKey := Data^.FTag.Key;
            if InputQuery(TagEditor_RenameTag_Caption, TagEditor_RenameTag_Prompt, newKey) then
            begin
                MedienBib.TagCloud.RenameTag(Data^.FTag, newKey);
                if cbAutoAddMergeTags.Checked then
                begin
                    TagPostProcessor.AddMergeTag(Data^.FTag.Key, newKey);
                    FillMergeTree;
                end;
                ActualizeTreeView;
                ReselectNode(newKey);
                RefreshWarningLabel;
                SetBrowseTabCloudWarning(True);
            end;
        end;
end;

{
    --------------------------------------------------------
    BtnMergeClick
    - Merge the selected Tags
    --------------------------------------------------------
}
procedure TCloudEditorForm.BtnMergeClick(Sender: TObject);
var SelectedTags: TNodeArray;
    maxCount, i: Integer;
    Data: PTagTreeData;
    maxKey: String;
begin
    if MedienBib.StatusBibUpdate > 1 then
        MessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0)
    else
    begin
        SelectedTags := TagVST.GetSortedSelection(False);
        if Length(SelectedTags) > 0 then
        begin
            maxCount := 0;
            maxKey := '';
            // Get Tag with maximum Count for newKey-suggestion
            for i := 0 to length(SelectedTags) - 1 do
            begin
                Data := TagVST.GetNodeData(SelectedTags[i]);
                if Data^.FTag.count > maxCount then
                begin
                    maxCount := Data^.FTag.count;
                    maxKey := Data^.FTag.Key;
                end;
            end;

            // Get new key-name
            if InputQuery(TagEditor_Merge_Caption, TagEditor_Merge_Prompt, maxKey) then
            begin
                for i := 0 to length(SelectedTags) - 1 do
                begin
                    // process selected tags: rename them to the new Keyname
                    Data := TagVST.GetNodeData(SelectedTags[i]);
                    if Data^.FTag.Key <> maxKey then
                    begin
                        MedienBib.TagCloud.RenameTag(Data^.FTag, maxKey);
                        if cbAutoAddMergeTags.Checked then
                            TagPostProcessor.AddMergeTag(Data^.FTag.Key, maxKey);
                    end;
                end;
                if cbAutoAddMergeTags.Checked then
                    FillMergeTree;

                ActualizeTreeView;
                ReselectNode(maxKey);
                RefreshWarningLabel;
                SetBrowseTabCloudWarning(True);
            end;
        end;
    end;
end;

{
    --------------------------------------------------------
    BtnDeleteTagsClick
    - Delete the selected Tags
    --------------------------------------------------------
}

procedure TCloudEditorForm.BtnDeleteTagsClick(Sender: TObject);
var SelectedTags: TNodeArray;
    i: Integer;
    Data: PTagTreeData;

begin
    if MedienBib.StatusBibUpdate > 1 then
        MessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0)
    else
    begin
        SelectedTags := TagVST.GetSortedSelection(False);
        if Length(SelectedTags) > 0 then
        begin
            for i := 0 to length(SelectedTags) - 1 do
            begin
                // delete selected Tags
                Data := TagVST.GetNodeData(SelectedTags[i]);
                MedienBib.TagCloud.DeleteTag(Data^.FTag);

                if cbAutoAddIgnoreTags.Checked then
                    TagPostProcessor.AddIgnoreTag(Data^.FTag.Key);
            end;
            if cbAutoAddIgnoreTags.Checked then
                FillIgnoreTree;
            ActualizeTreeView;
            RefreshWarningLabel;
            SetBrowseTabCloudWarning(True);
        end;
    end;
end;

procedure TCloudEditorForm.BtnDeleteIgnoreTagClick(Sender: TObject);
var SelectedTags: TNodeArray;
    i: Integer;
    Data: PIgnoreTagData;
begin
    IgnoreTagVST.BeginUpdate;
    SelectedTags := IgnoreTagVST.GetSortedSelection(False);
    if Length(SelectedTags) > 0 then
    begin
        for i := 0 to length(SelectedTags) - 1 do
        begin
            Data := IgnoreTagVST.GetNodeData(SelectedTags[i]);
            TagPostProcessor.DeleteIgnoreTag(Data.fString.DataString);
            Data.fString.Free;
        end;
    end;
    IgnoreTagVST.DeleteSelectedNodes;
    IgnoreTagVST.EndUpdate;
end;

procedure TCloudEditorForm.BtnDeleteMergeTagClick(Sender: TObject);
var SelectedTags: TNodeArray;
    i: Integer;
    Data: PMergeTagData;
begin
    SelectedTags := MergeTagVST.GetSortedSelection(False);

    MergeTagVST.BeginUpdate;
    if Length(SelectedTags) > 0 then
    begin
        for i := 0 to length(SelectedTags) - 1 do
        begin
            Data :=MergeTagVST.GetNodeData(SelectedTags[i]);
            TagPostProcessor.DeleteMergeTag(Data.fMergeTag.OriginalKey, Data.fMergeTag.ReplaceKey);
        end;
    end;
    MergeTagVST.DeleteSelectedNodes;
    MergeTagVST.EndUpdate;
end;

procedure TCloudEditorForm.BtnUpdateID3TagsClick(Sender: TObject);
begin
    // This action will start a new thread!
    if MedienBib.StatusBibUpdate <> 0 then
        MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
    else
    begin
        MedienBib.StatusBibUpdate := 1;
        BlockeMedienListeUpdate(True);
        LblUpdateWarning.Visible := True;
        // Fill UpdateList
        MedienBib.PutInconsistentFilesToUpdateList;
        MedienBib.UpdateId3tags;
    end;
end;

{
    --------------------------------------------------------
    BtnBugFixClick
    - Fix ID3Tags
      As there was a Bug in MP3FileUtils, some files may have a
      duplicate "Private-Tag-Frame"
      This Method will delete the duplicates.
    --------------------------------------------------------
}
procedure TCloudEditorForm.BtnBugFixClick(Sender: TObject);
begin
    // This action will start a new thread!
    if MedienBib.StatusBibUpdate <> 0 then
        MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
    else
    begin
        if MessageDLG('Nemp wird nun alle Dateien auf Inkonsistenzen in den ID3Tags untersuchen, '
          + 'die durch einen Fehler in einer früheren Pre-Alpha-Version verursacht werden konnten.'
          + #13#10+#13#10
          + 'Einen Bericht darüber finden sie danach in der Datei "ID3TagBugFix.log".'
          , mtInformation, [MBOK, MBCancel], 0) = mrok then
        begin
            MedienBib.StatusBibUpdate := 1;
            BlockeMedienListeUpdate(True);
            LblUpdateWarning.Visible := True;

            MedienBib.PutAllFilesToUpdateList;
            MedienBib.BugFixID3Tags;
        end;
    end;
end;


end.
