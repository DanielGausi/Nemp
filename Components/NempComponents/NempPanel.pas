unit NempPanel;

interface

uses
  Windows, VCL.Forms, Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Messages, math,
  System.Generics.Collections, System.Generics.Defaults, Graphics;

type
  //TMouseWheelEvent = procedure(Sender: TObject; delta: Word) of object;

  TNempPanel = class;
  TNempContainerPanel = class;
  TNempPanelList = TObjectList<TNempPanel>;
  TNempContainerPanelList = TObjectList<TNempContainerPanel>;
  
  TButtonList = TObjectList<TButton>;
  TSplitterList = TObjectList<TSplitter>;

  tePanelOrientation = (poVertical, poHorizontal);

  TNempPanel = class(TPanel)
  private
    { Private-Deklarationen }
    FOnPaint: TNotifyEvent;
    FOnAfterPaint: TNotifyEvent;
    fRatio: Integer; // The amount of space used in the ParentPanel
    fFixedHeight: Boolean;

    FOwnerDraw: Boolean;
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
  protected
    { Protected-Deklarationen }
    fUpdating: Boolean;

    procedure Paint; override;
  public
    { Public-Deklarationen }
    property Canvas;

    // Show/Hide the Panel itself and Show/Hide the parent Panel as well if necessary
    procedure ShowPanel;
    procedure HidePanel;

  published
    { Published-Deklarationen }
    property Ratio: Integer read fRatio write fRatio;
    property FixedHeight: Boolean read fFixedHeight write fFixedHeight default False;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
    property OnAfterPaint: TNotifyEvent read FOnAfterPaint write FOnAfterPaint;
    property OwnerDraw: Boolean read FOwnerDraw write FOwnerDraw;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;


  TNempContainerPanel = class(TNempPanel)
    private
      fID: Char;
      fParentPanel: TNempContainerPanel;
      fEditButtons: TButtonList;

      fCurrentSplitterIndex: Integer;
      fVisibleSumRatio: Integer;
      fVisibleFixedHeight: Integer;
      fVisibleChilds: TNempPanelList;

      fOrientation: tePanelOrientation; // how the ChildPanels are lined up
      fChildPanels: TNempPanelList;
      fChildSplitters: TSplitterList;
      fOnSplitterMoved: TNotifyEvent;

      fOnSplitterCanResize: TCanResizeEvent;
      fOnEditButtonClick: TNotifyEvent;
      // fOnContainerResize: TNotifyEvent;

      fHierarchyLevel: Integer;
      fSplitterMinSize: Integer;

      procedure SetOrientation(Value: tePanelOrientation);

      function GetChildPanelCount: Integer;
      function GetLeafCount: Integer;

      function GetChildPanel(Index: Integer): TNempPanel;

      procedure SetChildRatio(Index, Ratio: Integer);
      function GetChildRatio(Index: Integer): Integer;

      procedure DoOnEditButtonClicked(Sender: TObject);
      procedure DoOnSplitterMoved(Sender: TObject);
      procedure DoSplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);

      procedure WMSize(var Msg: TWMSize);  message WM_SIZE;

    protected
      procedure AnalyseChilds;
      procedure ResetAligning;
      procedure FinishAligning;
      procedure AlignHorizontally;
      procedure AlignVertically;
      procedure ResizeHorizontally(newWidth: Integer);
      procedure ResizeVertically(newHeight: Integer);

      function GetNewSplitter(aAlign: TAlign; aPos: Integer): TSplitter;
      // function CreateNewHorizontalSplitter(aAlign: TAlign; aLeft: Integer): TSplitter;
      // function CreateNewVerticalSplitter(aAlign: TAlign; aTop: Integer): TSplitter;
      procedure SetSplitterColor(Value: TColor);

    public
      property ChildPanelCount: Integer read GetChildPanelCount;
      property LeafCount: Integer read GetLeafCount;
      property Orientation: tePanelOrientation read fOrientation write SetOrientation;
      property ID: Char read fID write fID;
      property ParentPanel: TNempContainerPanel read fParentPanel;

      property ChildPanel[Index: Integer]: TNempPanel read GetChildPanel;
      property ChildRatio[Index: Integer]: Integer read GetChildRatio write SetChildRatio;

      property OnSplitterMoved: TNotifyEvent read fOnSplitterMoved write fOnSplitterMoved;
      property OnSplitterCanResize: TCanResizeEvent read fOnSplitterCanResize write fOnSplitterCanResize;
      property OnEditButtonClick: TNotifyEvent read fOnEditButtonClick write fOnEditButtonClick;
      //property OnContainerResize: TNotifyEvent read fOnContainerResize write fOnContainerResize;
      property SplitterColor: TColor write SetSplitterColor;

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Clear; // Only used for the MainPanel of the NempLayout

      // procedure Clear; // only used for the Main ContainerPanel
      function HasSpareChild(out SpareChild: TNempContainerPanel): Boolean;

      procedure CheckVisibility;
      procedure AlignChildPanels(Recursive: Boolean);

      // procedure ResizeChildPanels;
      // Problem: How to deal with the fixed-size-ControlPanel here?

      function AddContainerPanel: TNempContainerPanel;
      procedure AddNempPanel(Source: TNempPanel);
      procedure RemovePanel(Source: TNempPanel);
      procedure MovePanel(curIndex, newIndex: Integer);

      procedure CreateEditButtons;
      procedure ShowEditButtons(EnableSplit: Boolean);
      procedure HideEditButtons;


    published
      property HierarchyLevel: Integer read fHierarchyLevel write fHierarchyLevel;
      property SplitterMinSize: Integer read fSplitterMinSize write fSplitterMinSize default 120;

  end;


procedure Register;

implementation

const
  MIN_WIDTH = 50;
  MIN_HEIGHT = 50;

resourcestring
  rsEditBtnHint_DeletePanel = 'Delete pane';
  rsEditBtnHint_SplitH = 'Split horizontally';
  rsEditBtnHint_SplitV = 'Split vertically';


procedure TNempPanel.Paint;
begin
//  inherited paint;
  if FOwnerDraw AND Assigned(FOnPaint) then
    FOnPaint(Self)
  else
    inherited;

  if Assigned(FOnAfterPaint) then
      FOnAfterPaint(Self);
end;


procedure TNempPanel.ShowPanel;
begin
  if visible then
    exit;

  visible := True;
  if assigned(Parent) and (Parent is TNempContainerPanel) then begin
    TNempContainerPanel(Parent).ShowPanel;
    TNempContainerPanel(Parent).AlignChildPanels(False);
  end;
end;

procedure TNempPanel.HidePanel;
begin
  if not visible then
    exit;
  visible := False;
  if assigned(Parent) and (Parent is TNempContainerPanel) then
    TNempContainerPanel(Parent).CheckVisibility;
end;

procedure TNempPanel.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  if FOwnerDraw AND Assigned(FOnPaint) then
    Message.Result := 1
  else
    inherited
end;


{ TNempContainerPanel }

constructor TNempContainerPanel.Create(AOwner: TComponent);
begin
  inherited;
  fChildPanels := TNempPanelList.Create(False);
  fVisibleChilds := TNempPanelList.Create(False);
  fChildSplitters := TSplitterList.Create(False);
  fParentPanel := Nil;
  fEditButtons := Nil;
  fUpdating := False;
  fOrientation := poVertical;

  BevelOuter := bvNone;
  BevelInner := bvNone;
  BorderStyle := bsNone;
end;



destructor TNempContainerPanel.Destroy;
var
  i: Integer;
begin
  if assigned(fParentPanel) then begin
    fParentPanel.fChildPanels.Remove(self);
    fParentPanel.fVisibleChilds.Remove(self);
  end;
  if assigned(fEditButtons) then
    fEditButtons.Free;

  // in "inherited" the ChildPanels will be destroyed as well. Those would then try to remove themselves from
  // it's parent (i.e. this panel here) list of ChildPanels, which we will already free in the next step. Therefore:
  for i := 0 to fChildPanels.Count - 1 do
    if fChildPanels[i] is TNempContainerPanel then
      TNempContainerPanel(fChildPanels[i]).fParentPanel := Nil;

  fVisibleChilds.Free;
  fChildPanels.Free;
  fChildSplitters.Free;
  inherited;
end;

procedure TNempContainerPanel.Clear;
var
  i: Integer;
begin
  for i := 0 to fChildSplitters.Count - 1 do
    fChildSplitters[i].Visible := False;
  fCurrentSplitterIndex := 0;

  fChildPanels.Clear;
  fVisibleChilds.Clear;
end;


function TNempContainerPanel.HasSpareChild(out SpareChild: TNempContainerPanel): Boolean;
begin
  result := (ChildPanelCount = 1)
      and (fChildPanels[0] is TNempContainerPanel)
      and (TNempContainerPanel(fChildPanels[0]).ChildPanelCount = 0);
  if result then
    SpareChild := TNempContainerPanel(fChildPanels[0]);
end;

procedure TNempContainerPanel.CreateEditButtons;

  procedure AddButton(newLeft, newTag: Integer; newCaption, newHint: String);
  var
    newButton: TButton;
  begin
    newButton := TButton.Create(self);
    newButton.Height := 25;
    newButton.Width := 25;
    newButton.Top := 4;
    newButton.Left := newLeft;
    newButton.Tag := newTag;
    newButton.Font.Size := 12;
    newButton.Caption := newCaption;
    newButton.Hint := newHint;
    newButton.ShowHint := True;
    newButton.OnClick := DoOnEditButtonClicked;
    newButton.Parent := self;
    fEditButtons.Add(newButton);
  end;

begin
  if Assigned(fEditButtons) then exit; // Buttons are already created, nothing to do
  fEditButtons := TButtonList.Create(False);

  AddButton(4, 1, #$25E7, rsEditBtnHint_SplitV);      // SQUARE WITH Left HALF BLACK; Split vertically
  AddButton(4+25+4, 2, #$2B12, rsEditBtnHint_SplitH); // SQUARE WITH TOP HALF BLACK; Split horizontally
  if HierarchyLevel > 0 then
    AddButton(4+50+8, 3, #$2A2F, rsEditBtnHint_DeletePanel); // Vector or Cross Product; Delete

    {

     rsEditBtnHint_DeletePanel = 'Delete pane';
  rsEditBtnHint_SplitH = 'Split horizontally';
  rsEditBtnHint_SplitV = 'Split vertically';
    }

end;

procedure TNempContainerPanel.ShowEditButtons(EnableSplit: Boolean);
var
  i: Integer;
begin
  if not Assigned(fEditButtons) then
    CreateEditButtons
  else begin
    for i := 0 to fEditButtons.Count - 1 do
      fEditButtons[i].Visible := True;
    // Disable the "split-buttons" if enough panels are created
    for i := 0 to  1 do
      fEditButtons[i].Enabled := EnableSplit;
  end;
end;

procedure TNempContainerPanel.HideEditButtons;
begin
  if not Assigned(fEditButtons) then
    exit; // nothing to hide

  for var i: Integer := 0 to fEditButtons.Count - 1 do
    fEditButtons[i].Visible := False;
end;

procedure TNempContainerPanel.AnalyseChilds;
var
  i: Integer;
  TotalSumRatio: Integer;

begin
  fVisibleSumRatio := 0;
  TotalSumRatio := 0;
  fVisibleFixedHeight := 0;
  fVisibleChilds.Clear;

  for i := 0 to fChildPanels.Count - 1 do begin
    //if not fChildPanels[i].FixedHeight then
      TotalSumRatio := TotalSumRatio + fChildPanels[i].Ratio;
    if not fChildPanels[i].Visible then    
      continue;

    fVisibleChilds.Add(fChildPanels[i]);
    if fChildPanels[i].FixedHeight then
      fVisibleFixedHeight := fVisibleFixedHeight + fChildPanels[i].Height
    else
      fVisibleSumRatio := fVisibleSumRatio + fChildPanels[i].Ratio
  end;

  // if the total sum of all ratios gets to small, rescale it, so that size adjustrments will be more precise
  if TotalSumRatio <= 25 then begin
    for i := 0 to fChildPanels.Count - 1 do 
      fChildPanels[i].Ratio := fChildPanels[i].Ratio * 10;
    fVisibleSumRatio := fVisibleSumRatio * 10;  
  end;
  // if something's really wrong: set it to 100 to avoid "Division by 0" later 
  if fVisibleSumRatio = 0 then
    fVisibleSumRatio := 100;
end;

function TNempContainerPanel.GetChildPanelCount: Integer;
begin
  result := fChildPanels.Count;
end;

function TNempContainerPanel.GetChildPanel(Index: Integer): TNempPanel;
begin
  result := fChildPanels[Index];
end;

function TNempContainerPanel.GetLeafCount: Integer;
var
  i: Integer;
begin
  if (fChildPanels.Count = 0) or
     ( (fChildPanels.Count = 1) and (not (fChildPanels[0] is TNempContainerPanel) ))
  then
    result := 1
  else begin
    result := 0;
    for i := 0 to fChildPanels.Count - 1 do
      if (fChildPanels[i] is TNempContainerPanel)  then
        result := result + TNempContainerPanel(fChildPanels[i]).LeafCount;
  end;
end;

(*procedure TNempContainerPanel.GetVisibleChilds(Dest: TNempPanelList);
begin
  for var i: Integer := 0 to fChildPanels.Count - 1 do
    if fChildPanels[i].Visible then
      Dest.Add(fChildPanels[i]);
end;*)

procedure TNempContainerPanel.CheckVisibility;
var
  i: Integer;
  HasVisibleChild: Boolean;
begin


  HasVisibleChild := False;
  for i := 0 to fChildPanels.Count - 1 do
    if fChildPanels[i].Visible then
      HasVisibleChild := True;
  // if all ChildPanels are invisible: Hide this Panel itself
  if HasVisibleChild then begin
    if not visible then begin
      ShowPanel;
      AlignChildPanels(False);
    end;
  end
  else
    HidePanel;
end;

procedure TNempContainerPanel.SetOrientation(Value: tePanelOrientation);
begin
  if Value <> self.fOrientation then begin
    fOrientation := Value;
    AlignChildPanels(False);
  end;
end;

procedure TNempContainerPanel.DoOnEditButtonClicked(Sender: TObject);
begin
  if assigned(fOnEditButtonClick) then
    fOnEditButtonClick(Sender);
end;

procedure TNempContainerPanel.DoOnSplitterMoved(Sender: TObject);  // Sender is one of the TSplitter-Components!
var
  i: Integer;
begin
  if fUpdating then
    exit;

  case self.fOrientation of
    poVertical: begin
      for i := 0 to fChildPanels.Count - 1 do begin
        if fChildPanels[i].Visible then
          fChildPanels[i].Ratio := Round(fChildPanels[i].Height / (Height - fVisibleFixedHeight) * fVisibleSumRatio);
      end;
    end;
    poHorizontal: begin
      for i := 0 to fChildPanels.Count - 1 do begin
        if fChildPanels[i].Visible then
          fChildPanels[i].Ratio := Round(fChildPanels[i].Width / self.Width * fVisibleSumRatio);
      end;
    end;
  end;

  if assigned(OnSplitterMoved) then
    OnSplitterMoved(Sender);
end;

procedure TNempContainerPanel.DoSplitterCanResize(Sender: TObject; var NewSize: Integer; var Accept: Boolean);
var s: TSplitter;
begin
  s := Sender as TSplitter;
  if s.Align in [alLeft, alRight] then
      accept := (s.MinSize < NewSize) and ( (s.Parent.Width - newSize - s.Width) > s.MinSize)
  else
      accept := (s.MinSize < NewSize - s.Height) and ( (s.Parent.Height - newSize - s.Height) > s.MinSize);
end;


function TNempContainerPanel.GetNewSplitter(aAlign: TAlign; aPos: Integer): TSplitter;
begin
  if fCurrentSplitterIndex >= fChildSplitters.Count then begin
    result := TSplitter.Create(self);
    result.MinSize := SplitterMinSize;
    result.Parent := self;
    result.ResizeStyle := rsUpdate;
    fChildSplitters.Add(result);
  end else
    result := fChildSplitters[fCurrentSplitterIndex];

  result.Align := aAlign;
  case aAlign of
    alTop, alBottom: begin
      result.Top := aPos;
      result.Height := 4;
    end;
    alLeft, alRight: begin
      result.Left := aPos;
      result.Width := 4;
    end;
  end;

  result.Visible := True;
  result.OnMoved := DoOnSplitterMoved;
  result.OnCanResize := DoSplitterCanResize;
  inc(fCurrentSplitterIndex);
end;

procedure TNempContainerPanel.SetSplitterColor(Value: TColor);
var
  i: Integer;
begin
  for i := 0 to fChildSplitters.Count - 1 do
    fChildSplitters[i].Color := Value;
  for i := 0 to fChildPanels.Count - 1 do
    if ChildPanel[i] is TNempContainerPanel then
      TNempContainerPanel(ChildPanel[i]).SplitterColor := Value;
end;

procedure TNempContainerPanel.ResetAligning;
var
  i: Integer;
begin
  for i := 0 to fChildPanels.Count - 1 do
    fChildPanels[i].fUpdating := True;
  for i := 0 to fChildPanels.Count - 1 do
    fChildPanels[i].Align := alNone;

  for i := 0 to fChildSplitters.Count - 1 do
    fChildSplitters[i].Visible := False;
  fCurrentSplitterIndex := 0;
end;

procedure TNempContainerPanel.FinishAligning;
var
  i: Integer;
begin
for i := 0 to fChildPanels.Count - 1 do
    fChildPanels[i].fUpdating := False;
end;

procedure TNempContainerPanel.AlignHorizontally;
var
  i: Integer;
  currentLeft, remainingSize, newWidth: Integer;
  newSplitter: TSplitter;
begin
  // Note: We do not handle "FixedWidth" here, as it is not used in NEMP so far !
  fUpdating := True;
  // fChildSplitters.Clear;
  //ResetAligning;

  remainingSize := Width;
  currentLeft := 0;

  for i := 0 to fVisibleChilds.Count - 1 do begin
    fVisibleChilds[i].Left := currentLeft;

    if i = fVisibleChilds.Count - 1 then begin
      // special case: The last ChildPanel
      fVisibleChilds[i].Align := alClient;
    end else begin
      // all other Panels: Align left and add a new Splitter
      newWidth := Round(self.Width * fVisibleChilds[i].Ratio / fVisibleSumRatio);
      if (RemainingSize - newWidth < (fVisibleChilds.Count - 1 - i) * MIN_WIDTH) then
        newWidth := MIN_WIDTH;
      fVisibleChilds[i].Width := newWidth;
      fVisibleChilds[i].Align := alLeft;
      newSplitter := GetNewSplitter(alLeft, fVisibleChilds[i].Left + newWidth);
      currentLeft := newSplitter.Left + newSplitter.Width;
      remainingSize := Width - currentLeft;
    end;
  end;

  fUpdating := False;
end;

procedure TNempContainerPanel.AlignVertically;
var
  i: Integer;
  currentTop, remainingSize, newHeight, lastIndex: Integer;
  newSplitter: TSplitter;
begin
  fUpdating := True;
  // fChildSplitters.Clear;
  //ResetAligning;

  // special case: The last Panel has FixedHeight
  if fVisibleChilds.Last.FixedHeight then begin
    lastIndex := fVisibleChilds.Count - 2;
    fVisibleChilds.Last.Align := alBottom;
  end else
    lastIndex := fVisibleChilds.Count - 1;

  remainingSize := Height - fVisibleFixedHeight;
  currentTop := 0;
  for i := 0 to lastIndex do begin
    fVisibleChilds[i].Top := currentTop;
    if fVisibleChilds[i].FixedHeight then begin
      // fixed Height
      fVisibleChilds[i].Align := alTop;
      currentTop := fVisibleChilds[i].Top + fVisibleChilds[i].Height;
    end else begin
      // variable Height
      if i = lastIndex then begin
        // special case: The last visible Child (except maybe the very last one, which is already aligned to the Bottom)
        fVisibleChilds[i].Align := alClient;
      end else begin
        // all other Panels: Align Top and add a new Splitter
        newHeight := Floor((Height - fVisibleFixedHeight) * fVisibleChilds[i].Ratio / fVisibleSumRatio);

        if (RemainingSize - newHeight < (lastIndex - i) * MIN_HEIGHT) then
          newHeight := MIN_HEIGHT;
        fVisibleChilds[i].Height := newHeight;
        fVisibleChilds[i].Align := alTop;
        newSplitter := GetNewSplitter(alTop, fVisibleChilds[i].Top + newHeight);
        currentTop := newSplitter.Top + newSplitter.Height;
      end;
    end;
    remainingSize := Height - currentTop;
  end;
  fUpdating := False;
end;

procedure TNempContainerPanel.AlignChildPanels(Recursive: Boolean);
var
  i: Integer;
begin
  AnalyseChilds;
  if fVisibleChilds.Count = 0 then
    exit;

  //fUpdating := True;
  ResetAligning;
  case fOrientation of
    poVertical: AlignVertically;
    poHorizontal: AlignHorizontally;
  end;
  //fUpdating := False;

  if recursive then
    for i := 0 to fVisibleChilds.Count - 1 do
      if (fVisibleChilds[i] is TNempContainerPanel) then
        TNempContainerPanel(fVisibleChilds[i]).AlignChildPanels(recursive);

  FinishAligning;
end;

procedure TNempContainerPanel.ResizeHorizontally(newWidth: Integer);
var
  i, newSize: Integer;
begin
  AnalyseChilds; // (??)

  //fUpdating := True;
  if fVisibleChilds.Count > 1 then begin
    for i := 0 to fVisibleChilds.Count - 1 do begin
      // Do not adjust the size of a Child with Align = alClient
      if fVisibleChilds[i].FixedHeight or (fVisibleChilds[i].Align = alClient) then
        continue;
      newSize := Round(newWidth * fVisibleChilds[i].Ratio / fVisibleSumRatio);
      //if newSize > 250 then
          fVisibleChilds[i].Width := newSize
      //else
      //    visibleChilds[i].Width := 250;
    end;
  end;
  //fUpdating := False;
end;

procedure TNempContainerPanel.ResizeVertically(newHeight: Integer);
var
  i, newSize: Integer;
begin
  AnalyseChilds; // (??)

  //fUpdating := True;
  if fVisibleChilds.Count > 1 then begin
    for i := 0 to fVisibleChilds.Count - 1 do begin
      // Do not adjust the size of a Child with Align = alClient
      if fVisibleChilds[i].FixedHeight or (fVisibleChilds[i].Align = alClient) then
        continue;
      newSize := Floor(newHeight * fVisibleChilds[i].Ratio / fVisibleSumRatio);
      //if newSize > 250 then
          fVisibleChilds[i].Height := newSize;

          // fVisibleChilds[i].Width := Width - 40;
      //else
      //    visibleChilds[i].Height := 250;
    end;
  end;
  //fUpdating := False;
end;


procedure TNempContainerPanel.WMSize(var Msg: TWMSize);
begin
  inherited;

  if not fUpdating then

  case fOrientation of
    poVertical: ResizeVertically(Msg.Height);
    poHorizontal: ResizeHorizontally(Msg.Width);
  end;

  //inherited;
end;


function TNempContainerPanel.AddContainerPanel: TNempContainerPanel;
begin
  // Create a new ContainerPanel and add it to the list of ChildPanels
  result := TNempContainerPanel.Create(Nil);
  result.Parent := self;
  result.fParentPanel := self;
  result.HierarchyLevel := HierarchyLevel + 1;
  result.SplitterMinSize := self.SplitterMinSize;
  //result.Constraints.MinHeight := SplitterMinSize;
  //result.Constraints.MinWidth := SplitterMinSize;

  fChildPanels.Add(result);
end;

procedure TNempContainerPanel.AddNempPanel(Source: TNempPanel);
begin
  Source.Parent := self;
  fChildPanels.Add(Source);
end;

procedure TNempContainerPanel.RemovePanel(Source: TNempPanel);
begin
  fChildPanels.Remove(Source);
  fVisibleChilds.Remove(Source);
end;

procedure TNempContainerPanel.MovePanel(curIndex, newIndex: Integer);
begin
  fChildPanels.Move(curIndex, newIndex);
  AlignChildPanels(False);
end;

procedure TNempContainerPanel.SetChildRatio(Index, Ratio: Integer);
begin
  fChildPanels[Index].Ratio := Ratio;
end;

function TNempContainerPanel.GetChildRatio(Index: Integer): Integer;
begin
  result := fChildPanels[Index].Ratio;
end;


procedure Register;
begin
  RegisterComponents('Beispiele', [TNempPanel, TNempContainerPanel]);
end;

end.
