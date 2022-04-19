unit MainFormLayout;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Messages, math,
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

const
  cNempBlocksID: Array[teNempBlocks] of Char = ( 'a', 'b', 'c', 'p', 'm', 'd', 'x');


type
  TNempLayout = class
    private
      fBlocksUsed: Array[teNempBlocks] of Boolean;
      fNempBlocks: Array[teNempBlocks] of TNempPanel;

      fConstructionLayout: Boolean;
      fCriticalParsingError: Boolean;
      fMainContainer: TNempContainerPanel;

      fOnSplitterMoved: TNotifyEvent;
      fOnContainerResize: TNotifyEvent;
      fOnAfterContainerCreate: TNotifyEvent;

      // ContainerPanels: sorted list of freshly created ContainerPanels A, B, C, D, E, F, G (at most, probably less)
      // BuildInstructions: sorted list with instructions what SubPanels should be created for the Panel with the ID
      fContainerPanels: TNempPanelList;
      fBuildInstructions: TStringList;

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

      procedure PrepareRebuild;
    public
      property ConstructionLayout: Boolean read fConstructionLayout write fConstructionLayout;
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


      constructor Create;
      destructor Destroy; override;

      procedure Clear;
      procedure LoadSettings;
      procedure SaveSettings;

      procedure BuildMainForm(Instructions: TStringList = Nil);
      procedure ReAlignMainForm;
      procedure RefreshEditButtons;

      procedure Split(Source: TNempContainerPanel; SplitOrientation: tePanelOrientation);
      procedure DeletePanel(Source: TNempContainerPanel);

  end;

implementation

uses Dialogs, StringHelper;

const
  cIniMainFormLayout: String = 'MainFormLayout';

  cMAXBUILD = 6;
  cInitBuild: String = 'hBC';
  cInitRatio: String = '75,25';
  cDefaultBuild: Array[0..cMAXBUILD] of String = (
    'vDmx',
    'vpd',  // playlist, details
    'habc', // drei Browsemodi (erstmal auf einem Panel, wie bisher)
    '',
    '',
    '',
    ''
  );
  cDefaultRatio: Array[0..cMAXBUILD] of String = (
    '34,66',
    '80,20',
    '20,40,20',
    '',
    '',
    '',
    ''
  );

{ TNempLayout }

constructor TNempLayout.Create;
begin
  fContainerPanels := TNempPanelList.Create(False);
  fBuildInstructions := TStringList.Create;

  fCriticalParsingError := False;
  fConstructionLayout := False;
end;

destructor TNempLayout.Destroy;
var
  i: Integer;
begin
  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Free;

  fContainerPanels.Free;
  fBuildInstructions.Free;

  inherited;
end;



procedure TNempLayout.Clear;
var
  iBlock: teNempBlocks;
  i: Integer;
begin
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do begin
    fBlocksUsed[iBlock] := False;
    self.fNempBlocks[iBlock].Parent := Nil;
  end;

  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Free;

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
  NempSettingsManager.ReadSectionValues(cIniMainFormLayout, fBuildInstructions);

  if not TestInstructions(fBuildInstructions) then
    SetDefaultInstructions(fBuildInstructions);
end;

procedure TNempLayout.SaveSettings;
begin
  // todo:
end;

function TNempLayout.TestInstructions(aBuildInstructions: TStrings): Boolean;
var
  BuildStr: String;
  currentIdx: Integer;
  iBlock: teNempBlocks;
  DummyContainers: TStringList;
begin

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

  result := not fCriticalParsingError;

  // reset "used" information
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do
    fBlocksUsed[iBlock] := False;
end;

procedure TNempLayout.SetDefaultInstructions(aBuildInstructions: TStrings);
begin
  aBuildInstructions.Clear;
  aBuildInstructions.Add('A=hBC');
  aBuildInstructions.Add('B=vDmx');
  aBuildInstructions.Add('C=vpd');
  aBuildInstructions.Add('D=habc');

  aBuildInstructions.Add('ARatio=75,25');
  aBuildInstructions.Add('BRatio=34,66');
  aBuildInstructions.Add('CRatio=80,20');
  aBuildInstructions.Add('DRatio=20,40,20');
end;

  {
  ratios/Height/remainingSize bei Panels mit Child mit FixedHeight besser machen
  }

procedure TNempLayout.PrepareRebuild;
var
  iBlock: teNempBlocks;
  i: Integer;
begin
  for iBlock := Low(teNempBlocks) to High(teNempBlocks) do begin
    fBlocksUsed[iBlock] := False;
    fNempBlocks[iBlock].Parent := Nil;
  end;

  for i := fContainerPanels.Count - 1 downto 0 do
    fContainerPanels[i].Free;

  fContainerPanels.Clear;
end;

procedure TNempLayout.BuildMainForm(Instructions: TStringList = Nil);
var
  BuildStr, RatioStr: String;
  i, currentIdx: Integer;
  currentContainer: TNempContainerPanel;
begin
  if Instructions = Nil then
    Instructions := fBuildInstructions;

  LockWindowUpdate(fMainContainer.Handle);
  PrepareRebuild;

  fMainContainer.ID := 'A';

  BuildStr := StrListValueDef(Instructions, 'A', cInitBuild);
  RatioStr := StrListValueDef(Instructions, 'ARatio', cInitRatio);
  ParseInstructionLine(BuildStr, fMainContainer);
  ParseRatioLine(RatioStr, fMainContainer);
  currentIdx := 0;
  while (currentIdx <= self.fContainerPanels.Count - 1) and (currentIdx <= cMAXBUILD) do begin
    currentContainer := TNempContainerPanel(fContainerPanels[currentIdx]);
    if (not ConstructionLayout) or (currentContainer.ChildPanelCount = 0) then begin
      // During Construction, some Dummy-Containers are created, that should contain exactly one of the GUI-Blocks
      // these Dummy-Containers are directly filled with the proper GUI-Block and need no further handling here
      BuildStr := StrListValueDef(Instructions, currentContainer.ID, cDefaultBuild[currentIdx]);
      RatioStr := StrListValueDef(Instructions, currentContainer.ID+'Ratio', cDefaultRatio[currentIdx]);
      ParseInstructionLine(BuildStr, currentContainer);
      ParseRatioLine(RatioStr, currentContainer);
    end;
    inc(currentIdx);
  end;

  fMainContainer.AlignChildPanels(True);
  {for i := 0 to fContainerPanels.Count - 1 do
    if fContainerPanels[i].Visible then
      TNempContainerPanel(fContainerPanels[i]).AlignChildPanels;}

  fMainContainer.OnSplitterMoved := OnSplitterMoved;
  for i := 0 to fContainerPanels.Count - 1 do
    TNempContainerPanel(fContainerPanels[i]).OnSplitterMoved := OnSplitterMoved;


  LockWindowUpdate(0);
end;

procedure TNempLayout.ReAlignMainForm;
begin
  LockWindowUpdate(fMainContainer.Handle);
  fMainContainer.AlignChildPanels(True);
  //for var i: Integer := 0 to fContainerPanels.Count - 1 do
  //  if fContainerPanels[i].Visible then
  //    TNempContainerPanel(fContainerPanels[i]).AlignChildPanels;
  LockWindowUpdate(0);
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
  result.Caption := ID;
  result.ID := ID;
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
      'B'..'G': AddContainer(aInstruction[i], aPanel);
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
        aPanel.SetRatio(i, StrToIntDef(RatioStringList[i], 20));
    end else
    begin
      for i := 0 to aPanel.ChildPanelCount - 1 do
        aPanel.SetRatio(i, Round(100 / aPanel.ChildPanelCount));
    end;

  finally
    RatioStringList.Free;
  end;
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
      'B'..'G': TestAddContainer(aInstruction[i], DummyContainers);
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
    ParentPanel.AlignChildPanels(False);
  end else
  // (b) (ParentPanel.Orientation <> Source.Orientation) // == "different Orientation"
  //     => Create a new Level of Panels within the BtnPanel, i.e. create 2 ContainerPanels on it
  begin
    Source.Orientation := SplitOrientation;
    newPanel := AddContainer('_', Source);
    newPanel.Ratio := 50;
    newPanel := AddContainer('_', Source);
    newPanel.Ratio := 50;
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

procedure TNempLayout.RefreshEditButtons;
var
  i: Integer;
begin
  if fMainContainer.ChildPanelCount = 0 then
    fMainContainer.ShowEditButtons
  else
    fMainContainer.HideEditButtons;

  for i := 0 to fContainerPanels.Count - 1 do
    if TNempContainerPanel(fContainerPanels[i]).ChildPanelCount = 0 then
      TNempContainerPanel(fContainerPanels[i]).ShowEditButtons
    else
      TNempContainerPanel(fContainerPanels[i]).HideEditButtons;
end;

end.
