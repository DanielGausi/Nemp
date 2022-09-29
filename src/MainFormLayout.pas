{

    Unit MainFormLayout

    - Classes for the Nemp MainForm Layout

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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

unit MainFormLayout;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Messages, math, System.IniFiles, Graphics,
  System.Generics.Collections, System.Generics.Defaults, Nemp_ConstantsAndTypes, NempPanel;


type

  teNempBlocks = (
    nbTree,
    nbCoverflow,
    nbCloud,
    nbPlaylist,
    nbMedialist,
    nbDetails,
    nbControls
  );

  teFileOverViewMode = (fovBoth, fovCover, fovText);

const
  cNempBlocksID: Array[teNempBlocks] of Char = ( 'a', 'b', 'c', 'p', 'm', 'd', 'x');


type
  TNempLayout = class
    private
      fBlocksUsed: Array[teNempBlocks] of Boolean;
      fNempBlocks: Array[teNempBlocks] of TNempPanel;
      fBlockHeapControl: TWinControl;

      fConstructionLayout: Boolean;
      fCriticalParsingError: Boolean;
      fMainContainer: TNempContainerPanel;

      fOnSplitterMoved: TNotifyEvent;
      fOnContainerResize: TNotifyEvent;
      fOnAfterContainerCreate: TNotifyEvent;
      fOnAfterBuild: TNotifyEvent;

      // ContainerPanels: sorted list of freshly created ContainerPanels A, B, C, D, E, F, G (at most, probably less)
      // BuildInstructions: sorted list with instructions what SubPanels should be created for the Panel with the ID
      fContainerPanels: TNempContainerPanelList;
      fBuildInstructions: TStringList;
      fBuildInProcess: Boolean;

      // addtional properties
      fFileOverviewCoverRatio: Integer;
      fTreeViewRatio         : Integer;
      fTreeviewOrientation   : Integer; // stacked (new) or side by side (classic)
      fShowControlCover      : Boolean;
      fFileOVerviewOrientation: Integer;
      fFileOverviewMode: teFileOverViewMode;

      fShowBibSelection: Boolean; // Show TreeView, Coverflow, tagCloud
      fShowMedialist: Boolean; // Show the MediaList (if not: Only access to full Albums/Directories/Artists/whatever the Library is configured by)
      fShowFileOverview: Boolean; // Show the File Overview Panel
      fShowCategoryTree: Boolean; // Show the Category-Selection tree

      fBrowseMode: Integer;
      fSplitterColor: TColor;

      procedure TestAddBlock(ID: teNempBlocks);
      procedure TestAddContainer(ID: Char; DummyContainers: TStringList);
      procedure TestInstructionLine(aInstruction: String; DummyContainers: TStringList);

      procedure AddBlock(ID: teNempBlocks; aParent: TNempContainerPanel);
      function AddContainer(ID: Char; aParent: TNempContainerPanel): TNempContainerPanel;
      procedure ParseInstructionLine(aInstruction: String; aPanel: TNempContainerPanel);
      procedure ParseRatioLine(aRatioLine: String; aPanel: TNempContainerPanel);

      procedure SetNempBlock(Index: teNempBlocks; Value: TNempPanel);
      function GetNempBlock(Index: teNempBlocks): TNempPanel;

      function TestInstructions(aBuildInstructions: TStrings): Boolean;
      procedure SetDefaultInstructions(aBuildInstructions: TStrings);

      function CreateInstructionLine(aContainer: TNempContainerPanel): string;
      function CreateRatioLine(aContainer: TNempContainerPanel): string;

      procedure SetSplitterColor(Value: TColor);


    public
      property ConstructionLayout: Boolean read fConstructionLayout write fConstructionLayout;
      property BlockHeapControl: TWinControl read fBlockHeapControl write fBlockHeapControl;
      property BuildInProcess: Boolean read fBuildInProcess;


      property TreeviewOrientation   : Integer read fTreeviewOrientation    write fTreeviewOrientation   ;
      property FileOVerviewOrientation: Integer read fFileOVerviewOrientation write fFileOVerviewOrientation ;
      property FileOverviewMode  : teFileOverViewMode read fFileOverviewMode   write fFileOverviewMode   ;
      property ShowControlCover : Boolean read fShowControlCover  write fShowControlCover;

      // Show/Hide some of the Sections in the MainWindow. Playlist and Controls are always visible
      property ShowBibSelection : Boolean read fShowBibSelection  write fShowBibSelection;
      property ShowMedialist    : Boolean read fShowMedialist     write fShowMedialist   ;
      property ShowFileOverview : Boolean read fShowFileOverview  write fShowFileOverview;
      property ShowCategoryTree : Boolean read fShowCategoryTree write fShowCategoryTree;
      // only relevant in the real MainWindow, not for the FormDesigner
      property FileOverviewCoverRatio: Integer read fFileOverviewCoverRatio write fFileOverviewCoverRatio;
      property TreeViewRatio         : Integer read fTreeViewRatio          write fTreeViewRatio         ;
      property SplitterColor: TColor read fSplitterColor write SetSplitterColor;


      property BrowseMode: Integer read fBrowseMode write fBrowseMode;

      property MainContainer: TNempContainerPanel read fMainContainer write fMainContainer;
      property TreePanel: TNempPanel Index nbTree read GetNempBlock write SetNempBlock;
      property CoverflowPanel: TNempPanel Index nbCoverflow read GetNempBlock write SetNempBlock;
      property CloudPanel: TNempPanel Index nbCloud read GetNempBlock write SetNempBlock;
      property PlaylistPanel: TNempPanel Index nbPlaylist read GetNempBlock write SetNempBlock;
      property MedialistPanel: TNempPanel Index nbMedialist read GetNempBlock write SetNempBlock;
      property DetailsPanel: TNempPanel Index nbDetails read GetNempBlock write SetNempBlock;
      property ControlsPanel: TNempPanel Index nbControls read GetNempBlock write SetNempBlock;

      property OnSplitterMoved: TNotifyEvent read fOnSplitterMoved write fOnSplitterMoved;
      property OnContainerResize: TNotifyEvent read fOnContainerResize write fOnContainerResize;
      property OnAfterContainerCreate: TNotifyEvent read fOnAfterContainerCreate write fOnAfterContainerCreate;
      property OnAfterBuild: TNotifyEvent read fOnAfterBuild write fOnAfterBuild;

      constructor Create;
      destructor Destroy; override;

      procedure Assign(Source: TNempLayout);

      procedure Clear;
      procedure LoadSettings;
      procedure SaveSettings(ReCreateBuildInstructions: Boolean);
      procedure ResetToDefault;
      function LoadPreset(Source: TMemIniFile; Section: String; ReloadRatios: Boolean): Boolean;

      procedure PrepareRebuild;
      procedure PrepareSplitForm;
      procedure BuildMainForm(Instructions: TStringList = Nil);
      procedure ReNumberContainerPanels;
      procedure CreateBuildInstructions(dest: TStrings);
      procedure Simplify; //(Complete: Boolean);

      procedure RefreshVisibilty;
      procedure ReAlignMainForm;
      procedure RefreshEditButtons(SplitComplete: Boolean);

      procedure Split(Source: TNempContainerPanel; SplitOrientation: tePanelOrientation);
      procedure DeletePanel(Source: TNempContainerPanel);

      procedure ResizeSubPanel(ABlockPanel: TPanel; aSubPanel: TWinControl; aRatio: Integer);

  end;

function NempLayout: TNempLayout;
function NempLayout_Ready: Boolean;

implementation

uses Dialogs, StringHelper;

var
  fNempLayout: TNempLayout;

const
  cIniMainFormLayout: String = 'MainFormLayout';

  cMAXBUILD = 25;
  // note: Changes should also be done in "SetDefaultInstructions"
  cInitBuild: String = 'vBx';
  cInitRatio: String = '50,50';
  cDefaultBuild: Array[0..cMAXBUILD] of String = (
    'haEF', //
    'vGm',  //
    'vpd',  //
    'hbc',
    '','','','','','','','','','','','','','','','','','','','','',''
  );
  cDefaultRatio: Array[0..cMAXBUILD] of String = (
    '26,72,50',
    '50,50', //
    '51,48',
    '50,50','','','','','','','','','','','','','','','','','','','','','',''
  );

function NempLayout: TNempLayout;
begin
  if not assigned(fNempLayout) then
    fNempLayout := TNempLayout.Create;

  result := fNempLayout;
end;

function NempLayout_Ready: Boolean;
begin
  result := assigned(fNempLayout);
end;

{ TNempLayout }

constructor TNempLayout.Create;
begin
  BlockHeapControl := Nil;
  fContainerPanels := TNempContainerPanelList.Create(False);
  fBuildInstructions := TStringList.Create;

  fCriticalParsingError := False;
  fConstructionLayout := False;
end;

destructor TNempLayout.Destroy;
var
  i: Integer;
begin
  BlockHeapControl := Nil;
  try
    for i := fContainerPanels.Count - 1 downto 0 do
      fContainerPanels[i].Free;
  except
  ;
  end;

  fContainerPanels.Free;
  fBuildInstructions.Free;

  inherited;
end;

procedure TNempLayout.Assign(Source: TNempLayout);
begin
  fBuildInstructions.Assign(Source.fBuildInstructions);
  fTreeviewOrientation    := Source.fTreeviewOrientation;
  fFileOVerviewOrientation  := Source.fFileOVerviewOrientation;
  FileOverviewMode  := Source.FileOverviewMode;
  fShowControlCover := Source.fShowControlCover;

  fShowBibSelection  := Source.fShowBibSelection;
  fShowMedialist     := Source.fShowMedialist;
  fShowFileOverview  := Source.fShowFileOverview;
  fShowCategoryTree  := Source.fShowCategoryTree;
end;

procedure TNempLayout.Clear;
var
  iBlock: teNempBlocks;
  i: Integer;
begin
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do begin
    fBlocksUsed[iBlock] := False;
    fNempBlocks[iBlock].Parent := BlockHeapControl;
  end;
  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Free;
  fMainContainer.Clear;
  fContainerPanels.Clear;
  fBuildInstructions.Clear;
  fCriticalParsingError := False;
end;

procedure TNempLayout.SetNempBlock(Index: teNempBlocks; Value: TNempPanel);
begin
  fNempBlocks[Index] := Value;
end;
function TNempLayout.GetNempBlock(Index: teNempBlocks): TNempPanel;
begin
  result := fNempBlocks[Index];
end;

procedure TNempLayout.LoadSettings;
begin
  LoadPreset(NempSettingsManager, cIniMainFormLayout, True);
end;

function TNempLayout.LoadPreset(Source: TMemIniFile; Section: String; ReloadRatios: Boolean): Boolean;
var
  intFovMode: Integer;
begin
  Source.ReadSectionValues(Section, fBuildInstructions);
  result := TestInstructions(fBuildInstructions);

  if not result then
    SetDefaultInstructions(fBuildInstructions);

  if ReloadRatios then begin
    fFileOverviewCoverRatio := Source.ReadInteger(cIniMainFormLayout, 'FileOverviewCoverRatio', 50);
    fTreeViewRatio := Source.ReadInteger(cIniMainFormLayout, 'TreeViewRatio', 30);
  end;

  fTreeviewOrientation := Source.ReadInteger(Section, 'TreeviewOrientation', 1);
  fFileOVerviewOrientation := Source.ReadInteger(Section, 'FileOVerviewOrientation', 0);
  intFovMode := Source.ReadInteger(Section, 'FileOverviewMode', 0);
  case intFovMode of
    1: fFileOverviewMode := fovCover;
    2:  fFileOverviewMode := fovText;
  else
    fFileOverviewMode := fovBoth;
  end;

  fShowControlCover := Source.ReadBool(Section, 'ShowControlCover', True);
  fShowBibSelection := Source.ReadBool(Section, 'ShowBibSelection', True);
  fShowMedialist    := Source.ReadBool(Section, 'ShowMedialist', True);
  fShowFileOverview := Source.ReadBool(Section, 'ShowFileOverview', True);
  fShowCategoryTree := Source.ReadBool(Section, 'ShowCategoryTree', True);
end;


procedure TNempLayout.SaveSettings(ReCreateBuildInstructions: Boolean);
var
  i: Integer;
begin
  ///  When Nemp is closed in "split window" mode, the InstructionLines would be empty
  ///  Therefore: Do not rewrite this part of the section in this case.
  if ReCreateBuildInstructions then begin
    NempSettingsManager.EraseSection(cIniMainFormLayout);
    NempSettingsManager.WriteString(cIniMainFormLayout, 'A', CreateInstructionLine(MainContainer));
    NempSettingsManager.WriteString(cIniMainFormLayout, 'ARatio', CreateRatioLine(MainContainer));

    for i := 0 to fContainerPanels.Count - 1 do begin
      NempSettingsManager.WriteString(cIniMainFormLayout, fContainerPanels[i].ID, CreateInstructionLine(fContainerPanels[i]));
      NempSettingsManager.WriteString(cIniMainFormLayout, fContainerPanels[i].ID + 'Ratio', CreateRatioLine(fContainerPanels[i]));
    end;
  end;

  NempSettingsManager.WriteInteger(cIniMainFormLayout, 'FileOverviewCoverRatio', fFileOverviewCoverRatio);
  NempSettingsManager.WriteInteger(cIniMainFormLayout, 'TreeViewRatio', fTreeViewRatio);
  NempSettingsManager.WriteInteger(cIniMainFormLayout, 'TreeviewOrientation', fTreeviewOrientation);
  NempSettingsManager.WriteInteger(cIniMainFormLayout, 'FileOVerviewOrientation', fFileOVerviewOrientation);
  NempSettingsManager.WriteInteger(cIniMainFormLayout, 'FileOverviewMode', Integer(fFileOverviewMode));

  NempSettingsManager.WriteBool(cIniMainFormLayout, 'ShowControlCover', fShowControlCover);
  NempSettingsManager.WriteBool(cIniMainFormLayout, 'ShowBibSelection', fShowBibSelection);
  NempSettingsManager.WriteBool(cIniMainFormLayout, 'ShowMedialist', fShowMedialist);
  NempSettingsManager.WriteBool(cIniMainFormLayout, 'ShowFileOverview', fShowFileOverview);
  NempSettingsManager.WriteBool(cIniMainFormLayout, 'ShowCategoryTree', fShowCategoryTree);
end;

procedure TNempLayout.ResetToDefault;
begin
  SetDefaultInstructions(fBuildInstructions);
  fTreeviewOrientation := 0;
  fShowControlCover := True;
  fShowBibSelection := True;
  fShowMedialist    := True;
  fShowFileOverview := True;
  fShowCategoryTree := True;
end;

procedure TNempLayout.ReNumberContainerPanels;
begin
  for var i: Integer := 0 to fContainerPanels.Count - 1 do begin
    fContainerPanels[i].ID := chr(ord('B') + i);
    fContainerPanels[i].Caption := chr(ord('B') + i);
  end;
end;

procedure TNempLayout.CreateBuildInstructions(dest: TStrings);
var
  i: Integer;
begin
  ReNumberContainerPanels;

  dest.Clear;
  dest.Add('A=' + CreateInstructionLine(MainContainer));
  for i := 0 to fContainerPanels.Count - 1 do
    dest.Add(fContainerPanels[i].ID + '=' + CreateInstructionLine(fContainerPanels[i]));

  dest.Add('ARatio=' + CreateRatioLine(MainContainer));
  for i := 0 to fContainerPanels.Count - 1 do
    dest.Add(fContainerPanels[i].ID + 'Ratio=' + CreateRatioLine(fContainerPanels[i]));

end;

procedure TNempLayout.Simplify; //(Complete: Boolean);
var
  Instructions: TStringList;
  WorkToDo, Changed: Boolean;
  redIdx: Integer;
  redID, replaceID: String;

  function DetectRedundantInstruction(out idx: Integer; out idName, idReplace: String): Boolean;
  begin
    result := False;
    for var i: Integer := Instructions.Count - 1 downto 0 do begin
      if (length(Instructions.ValueFromIndex[i]) = 2)
      //and (Complete or (Instructions.ValueFromIndex[i][2] in ['B'..'Z']))
    then  begin
        idx := i;
        idName := Instructions.Names[i];
        idReplace := Instructions.ValueFromIndex[i][2];
        result := True;
      end;
    end;
  end;

  procedure ReplaceRedundantID(old, new: String);
  begin
    for var i: Integer := Instructions.Count - 1 downto 0 do
      Instructions.ValueFromIndex[i] := StringReplace(Instructions.ValueFromIndex[i], old, new, [rfReplaceAll]);
  end;

begin
  Instructions := TStringList.Create;
  try
    CreateBuildInstructions(Instructions);
    WorkToDo := True;
    Changed := False;
    while WorkToDo do begin
      WorkToDo := False;
      if DetectRedundantInstruction(redIdx, redID, replaceID) then begin

        Instructions.Delete(redIdx);
        if Instructions.IndexOfName(redID+'Ratio') > -1 then
          Instructions.Delete(Instructions.IndexOfName(redID+'Ratio'));

        ReplaceRedundantID(redID, replaceID);

        WorkToDo := True;
        Changed := True;
      end;
    end;

    if Changed then
      fBuildInstructions.Assign(Instructions);

  finally
    Instructions.Free;
  end;
end;


function TNempLayout.TestInstructions(aBuildInstructions: TStrings): Boolean;
var
  BuildStr: String;
  currentIdx: Integer;
  iBlock: teNempBlocks;
  DummyContainers: TStringList;
begin
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do
    fBlocksUsed[iBlock] := False;

  fCriticalParsingError := False;
  BuildStr := aBuildInstructions.Values['A'];

  DummyContainers := TStringList.Create;
  try
    TestInstructionLine(BuildStr, DummyContainers);

    currentIdx := 0;
    while currentIdx <= DummyContainers.Count - 1 do begin
      BuildStr := aBuildInstructions.Values[DummyContainers[currentIdx]];
      TestInstructionLine(BuildStr, DummyContainers);
      inc(currentIdx);
    end;

  finally
    DummyContainers.Free;
  end;

  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do
    if not fBlocksUsed[iBlock] then
      fCriticalParsingError := True;

  result := not fCriticalParsingError;

  // reset "used" information
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do
    fBlocksUsed[iBlock] := False;
end;

procedure TNempLayout.SetDefaultInstructions(aBuildInstructions: TStrings);
begin
  aBuildInstructions.Clear;
  aBuildInstructions.Add('A=vBx');
  aBuildInstructions.Add('B=haEF');
  aBuildInstructions.Add('E=vGm');
  aBuildInstructions.Add('F=vpd');
  aBuildInstructions.Add('G=hbc');

  aBuildInstructions.Add('ARatio=50,50');
  aBuildInstructions.Add('BRatio=26,72,50');
  aBuildInstructions.Add('ERatio=50,50');
  aBuildInstructions.Add('FRatio=51,48');
  aBuildInstructions.Add('GRatio=50,50');
end;


procedure TNempLayout.PrepareRebuild;
var
  iBlock: teNempBlocks;
  i: Integer;
begin
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do begin
    fBlocksUsed[iBlock] := False;
    fNempBlocks[iBlock].Parent := BlockHeapControl;
  end;

  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Free;

  fMainContainer.Clear;
  fContainerPanels.Clear;
end;

procedure TNempLayout.PrepareSplitForm;
var
  i: Integer;
begin
  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Clear;  //.Visible := False;
  fMainContainer.Clear;
end;

procedure TNempLayout.BuildMainForm(Instructions: TStringList = Nil);
var
  BuildStr, RatioStr: String;
  i, currentIdx: Integer;
  currentContainer: TNempContainerPanel;
begin
  if assigned(Instructions) then
    fBuildInstructions.Assign(Instructions);

  LockWindowUpdate(fMainContainer.Handle);
  fBuildInProcess := True;
  PrepareRebuild;

  fMainContainer.ID := 'A';

  BuildStr := StrListValueDef(fBuildInstructions, 'A', cInitBuild);
  RatioStr := StrListValueDef(fBuildInstructions, 'ARatio', cInitRatio);
  ParseInstructionLine(BuildStr, fMainContainer);
  ParseRatioLine(RatioStr, fMainContainer);
  currentIdx := 0;
  while (currentIdx <= fContainerPanels.Count - 1) and (currentIdx <= cMAXBUILD) do begin
    currentContainer := fContainerPanels[currentIdx];
    if (not ConstructionLayout) or (currentContainer.ChildPanelCount = 0) then begin
      // During Construction, some Dummy-Containers are created, that should contain exactly one of the GUI-Blocks
      // these Dummy-Containers are directly filled with the proper GUI-Block and need no further handling here
      BuildStr := StrListValueDef(fBuildInstructions, currentContainer.ID, cDefaultBuild[currentIdx]);
      RatioStr := StrListValueDef(fBuildInstructions, currentContainer.ID+'Ratio', cDefaultRatio[currentIdx]);
      ParseInstructionLine(BuildStr, currentContainer);
      ParseRatioLine(RatioStr, currentContainer);
    end;
    inc(currentIdx);
  end;

  RefreshVisibilty;
  fMainContainer.AlignChildPanels(True);
  fMainContainer.OnSplitterMoved := OnSplitterMoved;
  for i := 0 to fContainerPanels.Count - 1 do
    fContainerPanels[i].OnSplitterMoved := OnSplitterMoved;

  fBuildInProcess := False;
  LockWindowUpdate(0);

  if assigned(OnAfterBuild) then
    OnAfterBuild(self);
end;

procedure TNempLayout.RefreshVisibilty;
var
  iBlock: teNempBlocks;
begin
  if ConstructionLayout then begin
    for iBlock := Low(teNempBlocks) to High(teNempBlocks) do
      fNempBlocks[iBlock].ShowPanel;
  end else
  begin
    // "the real layout", i.e. the actual Nemp MainForm
    if ShowBibSelection and (BrowseMode = 0) then
      TreePanel.ShowPanel
    else
      TreePanel.HidePanel;

    if ShowBibSelection and (BrowseMode = 1) then
      CoverflowPanel.ShowPanel
    else
      CoverflowPanel.HidePanel;

    if ShowBibSelection and (BrowseMode = 2) then
      CloudPanel.ShowPanel
    else
      CloudPanel.HidePanel;

    if ShowMedialist then
      MedialistPanel.ShowPanel
    else
      MedialistPanel.HidePanel;

    if ShowFileOverview then
      DetailsPanel.ShowPanel
    else
      DetailsPanel.HidePanel;

//    Dieser Check geht manchmal schief und blendet auch das MainPanel aus ...

    for iBlock := Low(teNempBlocks) to High(teNempBlocks) do begin
      if assigned(fNempBlocks[iBlock].Parent) and (fNempBlocks[iBlock].Parent is TNempContainerPanel) then
        TNempContainerPanel(fNempBlocks[iBlock].Parent).CheckVisibility;
    end;
  end;
end;


procedure TNempLayout.ReAlignMainForm;
begin
  LockWindowUpdate(fMainContainer.Handle);
  fMainContainer.AlignChildPanels(True);
  LockWindowUpdate(0);
end;

procedure TNempLayout.SetSplitterColor(Value: TColor);
begin
  fSplitterColor := Value;
  fMainContainer.SplitterColor := Value;
end;

procedure TNempLayout.AddBlock(ID: teNempBlocks; aParent: TNempContainerPanel);
var
  blockParent: TNempContainerPanel;
begin
  fBlocksUsed[ID] := True;
  if ConstructionLayout then begin
    blockParent := AddContainer(cNempBlocksID[ID], aParent);
    if fNempBlocks[ID].FixedHeight then begin
      blockParent.FixedHeight := True;
      blockParent.Height := fNempBlocks[ID].Height;
    end;
  end
  else
    blockParent := aParent;

  blockParent.AddNempPanel(fNempBlocks[ID]);
end;

function TNempLayout.AddContainer(ID: Char; aParent: TNempContainerPanel): TNempContainerPanel;
begin
  result := aParent.AddContainerPanel;
  result.ID := ID;
  if self.ConstructionLayout then begin
    result.Caption := ID;
    result.ParentBackground := False;
  end;
  fContainerPanels.Add(result);

  if assigned(fOnAfterContainerCreate) then
    fOnAfterContainerCreate(result);
end;

procedure TNempLayout.ParseInstructionLine(aInstruction: String;
  aPanel: TNempContainerPanel);
var
  StartIdx, i: Integer;
begin
  if length(aInstruction) = 0 then
    exit;

  StartIdx := 2;
  case aInstruction[1] of
    'h': aPanel.Orientation := poHorizontal;
    'v': aPanel.Orientation := poVertical;
  else
    begin
      // actually an error, but try to parse it anyway
      aPanel.Orientation := poVertical;
      StartIdx := 1;
    end;
  end;

  for i := StartIdx to length(aInstruction) do begin
    case aInstruction[i] of
      'a': AddBlock(nbTree, aPanel);
      'b': AddBlock(nbCoverflow, aPanel);
      'c': AddBlock(nbCloud, aPanel);
      'p': AddBlock(nbPlaylist, aPanel);
      'm': AddBlock(nbMedialist, aPanel);
      'd': AddBlock(nbDetails, aPanel);
      'x': AddBlock(nbControls, aPanel);
      'B'..'Z': AddContainer(aInstruction[i], aPanel);
    else
      ; // Parsing-Error, invalid Data
    end;
  end;
end;

procedure TNempLayout.ParseRatioLine(aRatioLine: String;
  aPanel: TNempContainerPanel);
var
  RatioStringList: TStringList;
  i: Integer;
begin
  RatioStringList := TStringList.Create;
  try
    RatioStringList.Delimiter := ',';
    RatioStringList.DelimitedText := aRatioLine;
    if RatioStringList.Count = aPanel.ChildPanelCount then begin
      for i := 0 to RatioStringList.Count - 1 do
        aPanel.ChildRatio[i] := StrToIntDef(RatioStringList[i], 20);

    end else
    begin
      for i := 0 to aPanel.ChildPanelCount - 1 do
        aPanel.ChildRatio[i] := Round(100 / aPanel.ChildPanelCount);
    end;

  finally
    RatioStringList.Free;
  end;
end;

function TNempLayout.CreateInstructionLine(aContainer: TNempContainerPanel): string;
var
  i: Integer;
  b: teNempBlocks;
  BlockFound: Boolean;
begin
  case aContainer.Orientation of
    poVertical: result := 'v';
    poHorizontal: result := 'h';
  else
    result := '';
  end;

  for i := 0 to aContainer.ChildPanelCount - 1 do begin
    // add the terminal symbol for one of the Nemp GUI Elements
    BlockFound := False;
    for b := Low(teNempBlocks) to High(teNempBlocks) do begin
      if fNempBlocks[b] = aContainer.ChildPanel[i] then begin
        BlockFound := True;
        result := result + cNempBlocksID[b];
        break;
      end;
    end;
    // if the current ChildPanel is not one of the actual GUI elements: Add the ID of the Container to the instruction line
    if (not BlockFound) and (aContainer.ChildPanel[i] is TNempContainerPanel) then
        result := result + TNempContainerPanel(aContainer.ChildPanel[i]).ID;
  end;
end;

function TNempLayout.CreateRatioLine(aContainer: TNempContainerPanel): string;
var
  i: Integer;
begin
  if aContainer.ChildPanelCount > 0 then
    result := aContainer.ChildPanel[0].Ratio.ToString
  else
    result := '';
  for i := 1 to aContainer.ChildPanelCount - 1 do
    result := result + ',' + aContainer.ChildPanel[i].Ratio.ToString;
end;

procedure TNempLayout.TestAddBlock(ID: teNempBlocks);
begin
  if fBlocksUsed[ID] then
    fCriticalParsingError := True
  else
    fBlocksUsed[ID] := True;
end;

procedure TNempLayout.TestAddContainer(ID: Char; DummyContainers: TStringList);
begin
  if DummyContainers.IndexOf(ID) <> -1 then
    fCriticalParsingError := True
  else
    DummyContainers.Add(ID);
end;

procedure TNempLayout.TestInstructionLine(aInstruction: String; DummyContainers: TStringList);
var
  StartIdx, i: Integer;
begin
  if length(aInstruction) = 0 then begin
    fCriticalParsingError := True;
    exit;
  end;

  case aInstruction[1] of
    'h', 'v': StartIdx := 2;
  else
    StartIdx := 1;
  end;

  for i := StartIdx to length(aInstruction) do begin
    case aInstruction[i] of
      'a': TestAddBlock(nbTree);
      'b': TestAddBlock(nbCoverflow);
      'c': TestAddBlock(nbCloud);
      'p': TestAddBlock(nbPlaylist);
      'm': TestAddBlock(nbMedialist);
      'd': TestAddBlock(nbDetails);
      'x': TestAddBlock(nbControls);
      'B'..'Z': TestAddContainer(aInstruction[i], DummyContainers);
    else
        fCriticalParsingError := True;
    end;
  end;
end;

procedure TNempLayout.Split(Source: TNempContainerPanel; SplitOrientation: tePanelOrientation);
var
  ParentPanel, newPanel: TNempContainerPanel;
begin
  if (Source.HierarchyLevel > 0)  then
    ParentPanel := Source.ParentPanel
  else
    ParentPanel := Nil;

  // (a) (Hierarchylevel > 0) und (ParentPanel.Orientation = SplitOrientation) // == "Same Orientation"
  //     => Add a new Container to the ParentPanel, as Sibling to the Source
  if (Source.HierarchyLevel > 0) and (ParentPanel.Orientation = SplitOrientation) then begin
    newPanel := AddContainer('_', ParentPanel);
    newPanel.Ratio := 50;
    newPanel.OnSplitterMoved := OnSplitterMoved;
    ParentPanel.AlignChildPanels(False);
  end else
  // (b) (ParentPanel.Orientation <> Source.Orientation) // == "different Orientation"
  //     => Create a new Level of Panels within the BtnPanel, i.e. create 2 ContainerPanels on it
  begin
    Source.Orientation := SplitOrientation;
    newPanel := AddContainer('_', Source);
    newPanel.Ratio := 50;
    newPanel.OnSplitterMoved := OnSplitterMoved;
    newPanel := AddContainer('_', Source);
    newPanel.Ratio := 50;
    newPanel.OnSplitterMoved := OnSplitterMoved;
    Source.AlignChildPanels(False);
  end;
end;

procedure TNempLayout.DeletePanel(Source: TNempContainerPanel);
var
  tmpParent, SpareChild: TNempContainerPanel;
begin
  tmpParent := Source.ParentPanel;
  fContainerPanels.Remove(Source);
  Source.Free;

  // If the tmpParent has only one Child left, and this Child has no Childs on its own, it should be removed as well
  if tmpParent.HasSpareChild(SpareChild) then begin
    fContainerPanels.Remove(SpareChild);
    SpareChild.Free;
  end;

  if assigned(tmpParent) then begin
    tmpParent.AlignChildPanels(false);
  end;
end;

procedure TNempLayout.RefreshEditButtons(SplitComplete: Boolean);
var
  i: Integer;
begin
  if fMainContainer.ChildPanelCount = 0 then
    fMainContainer.ShowEditButtons(not SplitComplete)
  else
    fMainContainer.HideEditButtons;

  for i := 0 to fContainerPanels.Count - 1 do
    if fContainerPanels[i].ChildPanelCount = 0 then
      fContainerPanels[i].ShowEditButtons(not SplitComplete)
    else
      fContainerPanels[i].HideEditButtons;
end;

procedure TNempLayout.ResizeSubPanel(ABlockPanel: TPanel;
  aSubPanel: TWinControl; aRatio: Integer);
var newSize: Integer;
begin
  if aSubPanel.Align in [alLeft, alRight] then begin
    newSize := Round(aRatio / 100 * (ABlockPanel.Width));
    if newSize < 30 then
        newSize := 30;
    if ABlockPanel.Width - newSize < 30 then
        newSize := ABlockPanel.Width - 30;
    aSubPanel.Width := newSize;
  end else
  if aSubPanel.Align in [alTop, alBottom] then begin
    newSize := Round(aRatio / 100 * (ABlockPanel.Height));
    if newSize < 30 then
        newSize := 30;
    if ABlockPanel.Height - newSize < 30 then
        newSize := ABlockPanel.Width - 30;
    aSubPanel.Height := newSize;
  end
end;


initialization
  fNempLayout := Nil;

finalization
  if assigned(fNempLayout) then
    fNempLayout.Free;

end.
