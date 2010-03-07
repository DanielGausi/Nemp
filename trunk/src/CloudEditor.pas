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

  AudioFileClass, TagClouds, StdCtrls, Spin
  ;

type

  TCloudEditorForm = class(TForm)
    TagVST: TVirtualStringTree;
    cbHideAutoTags: TCheckBox;
    seMinTagCount: TSpinEdit;
    lblMinTagCount: TLabel;
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
  private
    { Private-Deklarationen }
    LocalTagList: TObjectList;

    OldSelectionPrefix : String;
    procedure FillTagTree;
  public
    { Public-Deklarationen }
    procedure ActualizeTreeView;
  end;


var
  CloudEditorForm: TCloudEditorForm;

implementation

{$R *.dfm}

uses NempMainUnit, MedienBibliothekClass, Math;

function AddVSTTag(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aTag: TTag): PVirtualNode;
var Data: PTagTreeData;
begin
  Result :=  AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data := AVST.GetNodeData(Result);
  Data^.FTag := aTag;
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

    // Todo

    {
    LocalList einmalig aus tagCloud holen
    Danach: Nur aus dieser die Daten zur Anzeige holen.

    Aus LocalTagList k�nnen Tags dann gel�scht werden, und sie bleiben hier
    dann weg, machen aber keine AVS, weil sie in der TagClud noch da sind.

    Au�erdem k�nnen hier NEUE TAGS erzeugt werden.

    Die Liste der AudioFiles an den Tags kann aber durchaus ge�ndert werden.

    Beim Beenden dieser Form muss dann die Tag-Cloud KOMPLETT neu aufgebaut
    werden, inklusive vorherigem Zerst�ren aller Tag-Objekte !!
    notwendige Daten sind dann ja auch in den RawTags der AudioFiles drin.
    Danach kann dann ein Update der ID3Tags in einem Thread erfolgen.


    }

end;
procedure TCloudEditorForm.FormDestroy(Sender: TObject);
begin
    LocalTagList.Free;
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
    // Fill the treeview
    FillTagTree;
end;

procedure TCloudEditorForm.FillTagTree;
var i: integer;
begin
    TagVST.BeginUpdate;
    TagVST.Clear;
    for i:=0 to LocalTagList.Count-1 do
        AddVSTTag(TagVST,Nil,TTag(LocalTagList.Items[i]));
    TagVST.EndUpdate;
end;

procedure TCloudEditorForm.FormShow(Sender: TObject);
begin
    ActualizeTreeView;
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
          // Sort LocalTagList
          if TagVST.Header.SortDirection =  sdDescending then
              case HitInfo.Column of
                  0: LocalTagList.Sort(Sort_Name_DESC);
                  1: LocalTagList.Sort(Sort_Count_DESC);
              end
          else
              case HitInfo.Column of
                  0: LocalTagList.Sort(Sort_Name);
                  1: LocalTagList.Sort(Sort_Count);
              end;
          // Show Tags in TreeView
          FillTagTree;
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
var ScrollNode: PVirtualNode;
    erfolg: boolean;

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

              // n�chsten Knoten w�hlen
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
            // n�chstes Vorkommen des Prefixes suchen, dazu: beim n�chsten Knoten beginnen
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

end.
