{

    Unit CloudEditor
    Form CloudEditorForm

    A Form for editing and managing the TagCloud

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
unit CloudEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, contnrs, StrUtils,

  AudioFileClass, TagClouds, StdCtrls, Spin, TagHelper, ComCtrls
  ;

type

// types for the VirtualStringTree in CloudEditorForm
  TTagTreeData = record
      FTag : TTag;
  end;
  TIgnoreTagData = record
      fString: String;
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
    PageControl1: TPageControl;
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

    procedure FillIgnoreTree(reselect: Boolean = False);
    procedure FillMergeTree(reselect: Boolean = False);



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
  Data^.fString := aString;
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
    TagVST.NodeDataSize := SizeOf(TTagTreeData);
    LocalTagList := TObjectList.Create(False);


    TagPostProcessor := TTagPostProcessor.Create;
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
procedure TCloudEditorForm.FormDestroy(Sender: TObject);
begin
    LocalTagList.Free;
    TagPostProcessor.Free;
end;

procedure TCloudEditorForm.FormShow(Sender: TObject);
begin
    ActualizeTreeView;
    TagPostProcessor.LoadFiles;
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
var i: Integer;
    aNode: PVirtualNode;
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
    if TagVST.Header.SortDirection =  sdDescending then
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




procedure TCloudEditorForm.ReselectIgnoreNode(aKey: String);
var i: Integer;
    aNode: PVirtualNode;
    Data: PIgnoreTagData;
begin
    aNode := TagVST.GetFirst;
    Data := TagVST.GetNodeData(aNode);
    while (Data^.fString <> aKey) and (aNode <> IgnoreTagVST.GetLast) do
    begin
        aNode := IgnoreTagVST.GetNext(aNode);
        Data := IgnoreTagVST.GetNodeData(aNode);
    end;

    IgnoreTagVST.FocusedNode := aNode;
    IgnoreTagVST.ScrollIntoView(aNode, True);
    IgnoreTagVST.Selected[aNode] := True;
end;

procedure TCloudEditorForm.FillIgnoreTree(reselect: Boolean);
begin
       sd
end;

procedure TCloudEditorForm.ReselectMergeNode(aOriginalKey, aReplaceKey: String);
var i: Integer;
    aNode: PVirtualNode;
    Data: PMergeTagData;
begin
    aNode := TagVST.GetFirst;
    Data := TagVST.GetNodeData(aNode);
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
begin
       sd
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
        Result := StrLIComp(PChar(SearchText), PChar(aString), Min(length(SearchText), length(aString)));
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
                ActualizeTreeView;
                ReselectNode(newKey);
                RefreshWarningLabel;
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
                        MedienBib.TagCloud.RenameTag(Data^.FTag, maxKey);
                end;
                ActualizeTreeView;
                ReselectNode(maxKey);
                RefreshWarningLabel;
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
            end;
            ActualizeTreeView;
            RefreshWarningLabel;
        end;
    end;
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
