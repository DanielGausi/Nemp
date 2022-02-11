{

    Unit TreeHelper

    - Some Helper for Trees.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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
unit TreeHelper;

interface

uses Windows, Graphics, SysUtils, VirtualTrees, Forms, Controls, NempAudioFiles, Types, StrUtils,
  Contnrs, Classes, Jpeg, PNGImage, {uDragFilesSrc,} NempDragFiles, math, WinApi.ActiveX, ShlObj, ComObj,
  ShellApi,
  Id3v2Frames, dialogs, Hilfsfunktionen, LibraryOrganizer.Base, LibraryOrganizer.Files,
  Nemp_ConstantsAndTypes, CoverHelper, MedienbibliothekClass, BibHelper,
  gnuGettext, Nemp_RessourceStrings;

  function LengthToSize(len:integer; def:integer):integer;
  function MaxFontSize(default: Integer): Integer;

  function ModeToStyle(m:Byte):TFontstyles;

  function FontSelectorItemIndexToStyle(m: Integer):TFontstyles;

  procedure VSTColumns_SaveSettings(aVST: TVirtualStringTree);
  procedure VSTColumns_LoadSettings(aVST: TVirtualStringTree);

  function GetColumnIDfromPosition(aVST:TVirtualStringTree; position:LongWord):integer;
  function GetColumnIDfromContent(aVST:TVirtualStringTree; content:integer):integer;

  function GetOldNode(ac: TAudioCollection; aTree: TVirtualStringTree): PVirtualNode; overload;
  function GetOldNode(lc: TLibraryCategory; aTree: TVirtualStringTree): PVirtualNode; overload;

  procedure ClearEmptyCollectionNodes(aTree: TVirtualStringTree);

  function GetNextNodeOrFirst(aTree: TVirtualStringTree; aNode: PVirtualNode): PVirtualNode;
  function GetNodeWithAudioFile(aTree: TVirtualStringTree; aAudioFile: TAudioFile): PVirtualNode;
  function GetNodeWithCueFile(aTree: TVirtualStringTree; aRootNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
  function GetNodeWithIndex(aTree: TVirtualStringTree; aIndex: Cardinal; StartNode: PVirtualNode): PVirtualNode;

  // function AutoDecideExternalDrag: Boolean;
  //function LimitFileCount(actualCount, maxCount: Integer): Integer;
  procedure PrepareDragImage(DragDrop: TNempDragManager; aFile: TAudioFile);
  //procedure InitiateDragDrop(SourceTree: TVirtualStringTree; Dest: TStringList; DragDrop: TDragFilesSrc; maxFiles: Integer); overload;
  // procedure InitiateDragDrop(Source, Dest: TAudioFileList; DragDrop: TDragFilesSrc; maxFiles: Integer); overload;

  procedure InitiateDragDrop(SourceTree: TVirtualStringTree; DragDrop: TNempDragManager; DoExecute: Boolean); overload;
  procedure InitiateDragDrop(Source: TAudioFileList; SourceControl: TControl; DragDrop: TNempDragManager; DoExecute: Boolean); overload;

  function ValidPlaylistDropNode(Source: TVirtualStringTree; Node: PVirtualNode): Boolean;

  function InitiateFocussedPlay(aTree: TVirtualStringTree): Boolean;

  // function ObjContainsFiles(const DataObj: IDataObject): Boolean;
  // procedure GetFileListFromObj(const DataObj: IDataObject; FileList: TStringList);
  // procedure SetDragHint(DataObject: IDataObject; const szMessage, szInsert: string; Effect: Integer);

type

  TNempDragOverEvent = procedure(Shift: TShiftState; State: TDragState;
    Pt: TPoint; var Effect: Integer; var Accept: Boolean) of object;

     (*
  TNempDropManager = class(TInterfacedObject, IDropTarget)
  private
    FOwner: TComponent;                            // The tree which is responsible for drag management.
    // FDragSource: TBaseVirtualTree;     // Reference to the source tree if the source was a VT, might be different than
                                       // the owner tree.
    // FIsDropTarget: Boolean;            // True if the owner is currently the drop target.
    // FDataObject: IDataObject;          // A reference to the data object passed in by DragEnter (only used when the owner
                                       // tree is the current drop target).
    FDropTargetHelper: IDropTargetHelper; // Win2k > Drag image support
    FFullDragging: BOOL;               // True, if full dragging is currently enabled in the system.

    fValidSource: Boolean;
    FDataObject: IDataObject;

    fOnDragOver: TNempDragOverEvent;

    function DoDragOver(KeyState: Integer; Pt: TPoint; State: TDragState; var Effect: LongInt): HResult;

    // function GetDataObject: IDataObject; stdcall;
    // function GetDragSource: TBaseVirtualTree; stdcall;
    // function GetDropTargetHelperSupported: Boolean; stdcall;
    // function GetIsDropTarget: Boolean; stdcall;
  public
    property OnDragOver: TNempDragOverEvent read fOnDragOver write fOnDragOver;
    property DataObject: IDataObject read FDataObject;

    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;

    function DragEnter(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint;
      var Effect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function DragOver(KeyState: Integer; Pt: TPoint; var Effect: LongInt): HResult; stdcall;
    function Drop(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint; var Effect: Integer): HResult; stdcall;
    // procedure ForceDragLeave; stdcall;
    // function GiveFeedback(Effect: Integer): HResult; stdcall;
    // function QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult; stdcall;



    //function _AddRef: Integer; stdcall;
    //function _Release: Integer; stdcall;
  end;
  *)


implementation

uses  NempMainUnit, PlayerClass,  MainFormHelper;


function MaxFontSize(default: Integer): Integer;
begin
    // sync with function LengthToSize!
    result := default + 2;
end;

function LengthToSize(len:integer;def:integer):integer;
begin
  with Nemp_MainForm do
  begin
    //if len < NempOptions.MaxDauer[1] then result := NempOptions.FontSize[1]
    //else if len < NempOptions.MaxDauer[2] then result := NempOptions.FontSize[2]
    //else if len < NempOptions.MaxDauer[3] then result := NempOptions.FontSize[3]
    //else if len < NempOptions.MaxDauer[4] then result := NempOptions.FontSize[4]
    //else  result := NempOptions.FontSize[5]

    if len < NempOptions.MaxDauer[1] then result := def - 2
    else if len < NempOptions.MaxDauer[2] then result := def - 1
    else if len < NempOptions.MaxDauer[3] then result := def
    else if len < NempOptions.MaxDauer[4] then result := def + 1
    else  result := def + 2;

    if result < 4 then
        result := 4;
  end;
end;

function ModeToStyle(m:Byte):TFontstyles;
begin
  // ('S ','JS','DC','M ','--');
  case m of
    0,2: result := [fsbold];
    1,4: result := [];
    else result := [fsitalic];
  end;
end;

function FontSelectorItemIndexToStyle(m: Integer): TFontstyles;
begin
    case m of
        0: result := [];
        1: result := [fsbold];
        2: result := [fsitalic];
        3: result := [fsbold, fsitalic];
    else
        result := [];
    end;
end;

procedure VSTColumns_SaveSettings(aVST: TVirtualStringTree);
var
  i, contentID: Integer;
  rawVisible, rawContent, rawWidth: String;

begin
  contentID := GetColumnIDfromPosition(aVST, 0);

  rawContent := IntToStr(aVST.Header.Columns[contentID].Tag);
  rawWidth :=   IntToStr(aVST.Header.Columns[contentID].Width);
  if (coVisible in aVST.Header.Columns[contentID].Options) then
    rawVisible := '1'
  else
    rawVisible := '0';

  for i := 1 to Spaltenzahl-1 do begin
    contentID := GetColumnIDfromPosition(aVST, i);

    rawContent := rawContent + ';' + IntToStr(aVST.Header.Columns[contentID].Tag);
    rawWidth   := rawWidth   + ';' + IntToStr(aVST.Header.Columns[contentID].Width);
    if (coVisible in aVST.Header.Columns[contentID].Options) then
      rawVisible := rawVisible + ';1'
    else
      rawVisible := rawVisible + ';0';
  end;
  NempSettingsManager.WriteString('Columns', 'Content', rawContent);
  NempSettingsManager.WriteString('Columns', 'Width', rawWidth);
  NempSettingsManager.WriteString('Columns', 'Visible', rawVisible);

  // remove depecated ini section
  NempSettingsManager.EraseSection('Spalten');
end;

procedure VSTColumns_LoadSettings(aVST: TVirtualStringTree);
var
  i, s, contentID: Integer;
  rawVisible, rawContent, rawWidth: String;
  VisibleList, ContentList, WidthList: TStringList;
begin
  if NempSettingsManager.SectionExists('Columns') then
  begin
    // load newer configuration style
    rawContent := NempSettingsManager.ReadString('Columns', 'Content', '');
    rawWidth := NempSettingsManager.ReadString('Columns', 'Width', '');
    rawVisible := NempSettingsManager.ReadString('Columns', 'Visible', '');
    ContentList := TStringList.Create;
    WidthList := TStringList.Create;
    VisibleList := TStringList.Create;
    try
      Explode(';', rawContent, ContentList);
      Explode(';', rawWidth, WidthList);
      Explode(';', rawVisible, VisibleList);
      if (ContentList.Count <= Spaltenzahl) and (ContentList.Count = WidthList.Count) and (WidthList.Count = VisibleList.Count) then
      begin
        for i := 0 to ContentList.Count - 1 do
        begin
          contentID := StrToIntDef(ContentList[i], DefaultSpalten[i].Inhalt);
          aVST.Header.Columns[i].Tag := contentID ;
          aVST.Header.Columns[i].Text := _(DefaultSpalten[contentID].Bezeichnung);
          aVST.Header.Columns[i].Width := StrToIntDef(WidthList[i], DefaultSpalten[i].width);
          if VisibleList[i] = '1' then
            aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options + [coVisible]
          else
            aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options - [coVisible];
        end;

        // if there are more Columns than defined in the Inifile (due to a new version): Set Default values
        for i := ContentList.Count to Spaltenzahl-1 do
        begin
          contentID := i;
          aVST.Header.Columns[i].Tag := i;
          aVST.Header.Columns[i].Text := _(DefaultSpalten[i].Bezeichnung);
          aVST.Header.Columns[i].Width := DefaultSpalten[i].width;
          aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options + [coVisible]
        end;
      end else
      begin
        // set default values for all columns
        for i := 0 to Spaltenzahl-1 do
        begin
          contentID := DefaultSpalten[i].Inhalt;
          aVST.Header.Columns[i].Tag := contentID;
          aVST.Header.Columns[i].Text := _(DefaultSpalten[contentID].Bezeichnung);
          aVST.Header.Columns[i].Width := DefaultSpalten[i].width;
          aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options + [coVisible]
        end;
      end;
    finally
      ContentList.Free;
      WidthList.Free;
      VisibleList.Free;
    end;
  end else
  begin
    // load old configuration style
    for i:=0 to Spaltenzahl-1 do
    begin
      s := NempSettingsManager.ReadInteger('Spalten','Inhalt' + IntToStr(i), DefaultSpalten[i].Inhalt);
      aVST.Header.Columns[i].Text := _(DefaultSpalten[s].Bezeichnung);
      aVST.Header.Columns[i].Tag := s;

      if NempSettingsManager.readbool('Spalten','visible' + IntToStr(i), DefaultSpalten[i].visible) then
        aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options + [coVisible]
      else
        aVST.Header.Columns[i].Options := aVST.Header.Columns[i].Options - [coVisible];

      aVST.Header.Columns[i].Width := NempSettingsManager.ReadInteger('Spalten','Breite' + IntToStr(i), DefaultSpalten[i].width);
    end;
  end;
end;

function GetColumnIDfromPosition(aVST:TVirtualStringTree; position:LongWord):integer;
var i:integer;
begin
  result := 0;
  for i:=0 to aVST.Header.Columns.Count-1 do
    if aVST.Header.Columns[i].Position = position then
      result := i;
end;

function GetColumnIDfromContent(aVST:TVirtualStringTree; content:integer):integer;
var i:integer;
begin
  result := 0;
  for i:=0 to aVST.Header.Columns.Count-1 do
    if aVST.Header.Columns[i].Tag = content then
      result := i;
end;


procedure ClearEmptyCollectionNodes(aTree: TVirtualStringTree);
var
  ac: TAudioCollection;
  nextNode, currentNode: PVirtualNode;

  function NextNodeNoChilds(aNode: PVirtualNode): PVirtualNode;
  begin
    result := aNode;
    // same method than in "GetNext" from the VirtualTrees.pas
    repeat
      // Is there a next sibling?
      if {(result <> aTree.RootNode) and} assigned(aTree.GetNextSibling(result)) then begin
        result := aTree.GetNextSibling(result);
        break
      end
      else begin
        // No sibling anymore, so use the parent's next sibling.
        if assigned(result.Parent) then
          result := result.Parent
        else begin
          // There are no further nodes to examine, hence there is no further visible node.
          result := Nil;
          break;
        end;
      end;
    until False or (result = aTree.RootNode);

    if (result = aNode) or (result = aTree.RootNode) then
      result := Nil;
  end;

begin
  currentNode := aTree.GetFirst;

  while assigned(currentNode) and (currentNode <> aTree.RootNode) do begin
    ac := aTree.GetNodeData<TAudioCollection>(currentNode);
    if (ac is TRootCollection) then
      currentNode := aTree.GetNext(currentNode)
    else begin
      if ac.Count > 0 then
        currentNode := aTree.GetNext(currentNode)
      else begin
        // currentNode contains NOT a RootCollection, and it's Count is zero => remove the Node (and all it's children)

        // 1. Get the next node we have to check
        nextNode := NextNodeNoChilds(currentNode);

        // 2. delete the current (empty) node
        aTree.DeleteNode(currentNode);
        // 3. check the next one (we may check a previous node again, but this shouldn't matter that much)
        currentNode := nextNode;
      end;
    end;
  end;
end;


function GetOldNode(ac: TAudioCollection; aTree: TVirtualStringTree): PVirtualNode; overload;
var
  currentAC: TAudioCollection;
begin
  result := aTree.GetFirst;
  currentAC := Nil;
  if not assigned(ac) then
    exit;

  if assigned(result) then
    currentAC := aTree.GetNodeData<TAudioCollection>(result);

  while assigned(result) and (currentAC <> ac) do begin
    result := aTree.GetNext(result);
    if assigned(result) then
      currentAC := aTree.GetNodeData<TAudioCollection>(result);
  end;
  if not assigned(result) then
    result := aTree.GetFirst;
end;

function GetOldNode(lc: TLibraryCategory; aTree: TVirtualStringTree): PVirtualNode; overload;
var
  currentLC: TLibraryCategory;
begin
  result := aTree.GetFirst;
  currentLC := Nil;
  if not assigned(lc) then
    exit;

  if assigned(result) then
    currentLC := aTree.GetNodeData<TLibraryCategory>(result);

  while assigned(result) and (currentLC <> lc) do begin
    result := aTree.GetNext(result);
    if assigned(result) then
      currentLC := aTree.GetNodeData<TLibraryCategory>(result);
  end;
  if not assigned(result) then
    result := aTree.GetFirst;
end;


function GetNextNodeOrFirst(aTree: TVirtualStringTree; aNode: PVirtualNode): PVirtualNode;
begin
    result := aTree.GetNextSibling(aNode);
    if not assigned(result) then
        result := aTree.GetFirst;
end;

function GetNodeWithAudioFile(aTree: TVirtualStringTree; aAudioFile: TAudioFile): PVirtualNode;
var aNode: PVirtualNode;
begin
    result := Nil;
    aNode := aTree.GetFirst;

    while assigned(aNode) and (Not assigned(result)) do
    begin
        if aTree.GetNodeData<TAudioFile>(aNode) = aAudioFile then
            result := aNode
        else
            aNode := aTree.GetNextSibling(aNode);
    end;
end;

function GetNodeWithCueFile(aTree: TVirtualStringTree; aRootNode: PVirtualNode; aAudioFile: TAudioFile): PVirtualNode;
var aNode: PVirtualNode;
begin
  result := Nil;
  aNode := aRootNode.FirstChild;
  while assigned(aNode) and (not assigned(result)) do
  begin
    if aTree.GetNodeData<TAudioFile>(aNode) = aAudioFile then
      result := aNode
    else
      aNode := aNode.NextSibling;
  end;
end;

function GetNodeWithIndex(aTree: TVirtualStringTree; aIndex: Cardinal; StartNode: PVirtualNode): PVirtualNode;
begin
    if assigned(StartNode) and (StartNode.Index <= aIndex) then
        result := StartNode
    else
        result := aTree.GetFirst;

    while assigned(result) and (result.Index <> aIndex) do
        result := aTree.GetNextSibling(result);
end;

function InitiateFocussedPlay(aTree: TVirtualStringTree): Boolean;
var MainNode, CueNode: PVirtualNode;
begin
    MainNode := aTree.FocusedNode;
    if not assigned(MainNode) then
    begin
          result := False;
          exit;
    end;

    NempPlaylist.UserInput;
    NempPlayer.LastUserWish := USER_WANT_PLAY;

    result := True;
    if aTree.GetNodeLevel(MainNode) = 0 then
    begin
        NempPlaylist.PlayFocussed(MainNode.Index, -1);
    end else
    begin
        CueNode := MainNode;
        MainNode := aTree.NodeParent[MainNode];
        NempPlaylist.PlayFocussed(MainNode.Index, CueNode.Index);
    end;
end;


procedure PrepareDragImage(DragDrop: TNempDragManager; aFile: TAudioFile);
var
  DragPicture: TPicture;
begin
  if assigned(aFile) then begin
    DragPicture := TPicture.Create;
    try
      DragPicture.Bitmap.Width := 80;
      DragPicture.Bitmap.Height := 80;
      TCoverArtSearcher.GetCover_Fast(aFile, DragPicture);
      DragDrop.SetDragGraphic(DragPicture)
    finally
      DragPicture.Free;
    end;
  end else
    DragDrop.SetDragGraphic(Nil);
end;


(*function LimitFileCount(actualCount, maxCount: Integer): Integer;
begin
  result := min(maxCount, actualCount);
  if actualCount > maxCount then
    AddErrorLog(Format(Warning_TooManyFiles, [maxCount]));
end; *)

function AutoDecideExternalDrag: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  // Allow dragging to the explorer, when Ctrl is pressed or Right MouseButton
  result := ((State[VK_CONTROL] and 128) <> 0)
         or ((State[VK_RButton] and 128) <> 0);
end;

function ValidPlaylistDropNode(Source: TVirtualStringTree; Node: PVirtualNode): Boolean;
begin
  result := (assigned(Node) and (Source.GetNodeLevel(Node) = 0))
              or (not assigned(Node));
end;


procedure InitiateDragDrop(SourceTree: TVirtualStringTree; DragDrop: TNempDragManager; DoExecute: Boolean);
var
  i: Integer;
  SelectedMp3s: TNodeArray;
begin
    DragDrop.InitDrag(SourceTree);
    SelectedMp3s := SourceTree.GetSortedSelection(False);
    for i := 0 to length(SelectedMp3s) - 1 do //maxC - 1 do
      DragDrop.AddFile(SourceTree.GetNodeData<TAudioFile>(SelectedMp3s[i]), True);

    if DoExecute and (DragDrop.FileNameCount > 0) then
    begin
      PrepareDragImage(DragDrop, SourceTree.GetNodeData<TAudioFile>(SelectedMp3s[0]));
      DragDrop.Execute;
    end;
end;


procedure InitiateDragDrop(Source: TAudioFileList; SourceControl: TControl; DragDrop: TNempDragManager; DoExecute: Boolean);
var
  i: Integer;
begin
    DragDrop.InitDrag(SourceControl);
    for i := 0 to Source.Count - 1 do // maxC - 1 do
      DragDrop.AddFile(Source[i], True);

    if DoExecute and (DragDrop.FileNameCount > 0) then
    begin
      PrepareDragImage(DragDrop, Source[0]);
      DragDrop.Execute;
    end;
end;


(*
procedure SetDragHint(DataObject: IDataObject; const szMessage, szInsert: string; Effect: Integer);
var
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  Data: Pointer;
  Descr: DROPDESCRIPTION;
  s: WideString;
  maxL: Integer;
begin
  ZeroMemory(@Descr, SizeOf(DROPDESCRIPTION));
  {Do not set Descr.&type to DROPIMAGE_INVALID - this value ignore any custom hint}
  {use same image as dropeffect type}
  Descr.&type := DROPIMAGE_LABEL;
  case Effect of
    DROPEFFECT_NONE:
      Descr.&type := DROPIMAGE_NONE;
    DROPEFFECT_COPY:
      Descr.&type := DROPIMAGE_COPY;
    DROPEFFECT_MOVE:
      Descr.&type := DROPIMAGE_MOVE;
    DROPEFFECT_LINK:
      Descr.&type := DROPIMAGE_LINK;
  end;
  {format message for system}

  maxL := min(Length(szMessage), MAX_PATH-1);
  s := Copy(szMessage, 1, maxL);
  Move(s[1], Descr.szMessage[0], maxL * SizeOf(WideChar));

  maxL := min(Length(szInsert), MAX_PATH-1);
  s := Copy(szInsert, 1, maxL);
  Move(s[1], Descr.szInsert[0], maxL * SizeOf(WideChar));
  {
  if Length(szMessage) <= MAX_PATH then
  begin
    s := szMessage + '%1 dumdii';
    Move(s[1], Descr.szMessage[0], Length(s) * SizeOf(WideChar));

    s := 'wuppdi';
    Move(s[1], Descr.szInsert[0], Length(s) * SizeOf(WideChar));
    //Descr.szInsert := 'wuppdi';
  end
  else
  begin
    s := Copy(szMessage, 1, MAX_PATH - 2) + '%1';
    Move(s[1], Descr.szMessage[0], Length(s) * SizeOf(WideChar));

    s := Copy(szMessage, MAX_PATH - 1, MAX_PATH);
    Move(s[1], Descr.szInsert[0], Length(s) * SizeOf(WideChar));
  end;
  }
  {prepare structures to set DROPDESCRIPTION data}
  FormatEtc.cfFormat := FDragDescriptionFormat; {registered clipboard format}
  FormatEtc.ptd := nil;
  FormatEtc.dwAspect := DVASPECT_CONTENT;
  FormatEtc.lindex := -1;
  FormatEtc.tymed := TYMED_HGLOBAL;

  ZeroMemory(@Medium, SizeOf(TStgMedium));
  Medium.tymed := TYMED_HGLOBAL;
  Medium.HGlobal := GlobalAlloc(GHND or GMEM_SHARE, SizeOf(DROPDESCRIPTION));
  Data := GlobalLock(Medium.HGlobal);
  Move(Descr, Data^, SizeOf(DROPDESCRIPTION));
  GlobalUnlock(Medium.HGlobal);

  DataObject.SetData(FormatEtc, Medium, True);
end; *)

end.
