unit MainFormBuilderForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,

  Nemp_ConstantsAndTypes, Vcl.ComCtrls;

type



  TMainFormBuilder = class(TForm)
    __MainContainer: TPanel;
    _ControlPanel: TPanel;
    _TopMainPanel: TPanel;
    _BottomMainPanel: TPanel;
    MainSplitter: TSplitter;
    ___FormSimulatorPanel: TPanel;
    BlockBrowse: TPanel;
    BlockPlaylist: TPanel;
    BlockMedialist: TPanel;
    BlockFileOverview: TPanel;
    SplitterBottom: TSplitter;
    SplitterTop: TSplitter;
    ImgCoverFlowUp: TImage;
    ImgPlaylistUp: TImage;
    ImgFileOverviewUp: TImage;
    ImgMediaListUp: TImage;
    ImgCoverFlowLeft: TImage;
    ImgPlaylistLeft: TImage;
    ImgMediaListLeft: TImage;
    ImgFileOverviewLeft: TImage;
    ImgFileOverviewDown: TImage;
    ImgFileOverviewRight: TImage;
    ImgMediaListRight: TImage;
    ImgMediaListDown: TImage;
    ImgCoverFlowDown: TImage;
    ImgPlaylistDown: TImage;
    ImgPlaylistRight: TImage;
    ImgCoverFlowRight: TImage;
    GrpBoxSettings: TGroupBox;
    cbMainLayout: TComboBox;
    HeaderBrowse: TPanel;
    HeaderPlaylist: TPanel;
    HeaderFileOverview: TPanel;
    HeaderMedialist: TPanel;
    ContentBrowse: TPanel;
    ContentPlaylist: TPanel;
    ContentMedialist: TPanel;
    ContentFileOverview: TPanel;
    Apply: TButton;
    GroupBox1: TGroupBox;
    cbControlPosition: TComboBox;
    RGrpControlSubPanel: TRadioGroup;
    LblSubPanelPosition: TLabel;
    cbControlPositionSubPanel: TComboBox;
    GroupBox2: TGroupBox;
    cbControlPanelRows: TCheckBox;
    cbControlPanelShowCover: TCheckBox;
    GroupBox3: TGroupBox;
    cbHideFileOverview: TCheckBox;
    BtnUndo: TButton;
    BtnResetToDefault: TButton;
    procedure cbMainLayoutChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BlockBrowseResize(Sender: TObject);
    procedure BlockPlaylistResize(Sender: TObject);
    procedure BlockMedialistResize(Sender: TObject);
    procedure BlockFileOverviewResize(Sender: TObject);
    procedure ImgRightClick(Sender: TObject);
    procedure ImgLeftClick(Sender: TObject);
    procedure ImgUpClick(Sender: TObject);
    procedure ImgDownClick(Sender: TObject);
    procedure cbControlPositionChange(Sender: TObject);
    procedure RGrpControlSubPanelClick(Sender: TObject);
    procedure cbControlPositionSubPanelChange(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbControlPanelRowsClick(Sender: TObject);
    procedure cbControlPanelShowCoverClick(Sender: TObject);
    procedure cbControlPanelShowVisualisationClick(Sender: TObject);
    procedure cbHideFileOverviewClick(Sender: TObject);
    procedure SplitterTopMoved(Sender: TObject);
    procedure MainSplitterMoved(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure BtnResetToDefaultClick(Sender: TObject);
    procedure SplitterTopCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
  private
    { Private declarations }
    LocalBuildOptions: TNempFormBuildOptions;

    procedure ApplySettings;

    procedure FixRowLayoutButtons(aRow, aColumn, maxRow, maxColumn: Integer; aBlock: TNempBlockPanel);
    procedure FixAllButtons;
    procedure FixSettingsGUI;
  public
    { Public declarations }

  end;

var
  MainFormBuilder: TMainFormBuilder;

implementation

uses NempMainUnit;

{$R *.dfm}


procedure TMainFormBuilder.FixAllButtons;
var i: Integer;
begin
    case localBuildOptions.MainLayout of
      Layout_TwoRows: begin
          for i := 0 to localBuildOptions.PanelAChilds.Count - 1 do
              FixRowLayoutButtons(0, i, 1, localBuildOptions.PanelAChilds.Count-1, localBuildOptions.PanelAChilds[i]);

          for i := 0 to localBuildOptions.PanelBChilds.Count - 1 do
              FixRowLayoutButtons(1, i, 1, localBuildOptions.PanelBChilds.Count-1, localBuildOptions.PanelBChilds[i]);
      end;

      Layout_TwoColumns: begin
          for i := 0 to localBuildOptions.PanelAChilds.Count - 1 do
              FixRowLayoutButtons(i, 0, localBuildOptions.PanelAChilds.Count-1, 1, localBuildOptions.PanelAChilds[i]);

          for i := 0 to localBuildOptions.PanelBChilds.Count - 1 do
              FixRowLayoutButtons(i, 1, localBuildOptions.PanelBChilds.Count-1, 1, localBuildOptions.PanelBChilds[i]);

      end;
    end;

end;

procedure TMainFormBuilder.FixRowLayoutButtons(aRow, aColumn, maxRow,
  maxColumn: Integer; aBlock: TNempBlockPanel);
var UpVis, DownVis, LeftVis, RightVis: Boolean;
begin
    UpVis   := (aRow > 0)            and (maxColumn > 0);
    DownVis := (aRow < maxRow)       and (maxColumn > 0);
    LeftVis := (aColumn > 0)         and (maxRow > 0);
    RightVis:= (aColumn < maXColumn) and (maxRow > 0);

    if aBlock.Block = BlockBrowse then
    begin
        ImgCoverFlowUp   .Visible := UpVis;
        ImgCoverFlowDown .Visible := DownVis;
        ImgCoverFlowLeft .Visible := LeftVis;
        ImgCoverFlowRight.Visible := RightVis;
    end;

    if aBlock.Block = BlockPlaylist then
    begin
        ImgPlaylistUp   .Visible := UpVis;
        ImgPlaylistDown .Visible := DownVis;
        ImgPlaylistLeft .Visible := LeftVis;
        ImgPlaylistRight.Visible := RightVis;
    end;

    if aBlock.Block = BlockMedialist then
    begin
        ImgMediaListUp   .Visible := UpVis;
        ImgMediaListDown .Visible := DownVis;
        ImgMediaListLeft .Visible := LeftVis;
        ImgMediaListRight.Visible := RightVis;
    end;

    if aBlock.Block = BlockFileOverview then
    begin
        ImgFileOverviewUp   .Visible := UpVis;
        ImgFileOverviewDown .Visible := DownVis;
        ImgFileOverviewLeft .Visible := LeftVis;
        ImgFileOverviewRight.Visible := RightVis;
    end;
end;

procedure TMainFormBuilder.FixSettingsGUI;
begin

    RGrpControlSubPanel.OnClick := Nil;
    if LocalBuildOptions.ControlPanelSubParent = LocalBuildOptions.BlockBrowse       then RGrpControlSubPanel.ItemIndex := 0;
    if LocalBuildOptions.ControlPanelSubParent = LocalBuildOptions.BlockPlaylist     then RGrpControlSubPanel.ItemIndex := 1;
    if LocalBuildOptions.ControlPanelSubParent = LocalBuildOptions.BlockMediaList    then RGrpControlSubPanel.ItemIndex := 2;
    if LocalBuildOptions.ControlPanelSubParent = LocalBuildOptions.BlockFileOverview then RGrpControlSubPanel.ItemIndex := 3;
    RGrpControlSubPanel.OnClick := RGrpControlSubPanelClick;

    cbControlPosition.OnChange := Nil;
    cbControlPosition.ItemIndex := Integer(LocalBuildOptions.ControlPanelPosition);
    cbControlPosition.OnChange := cbControlPositionChange;

    cbMainLayout.OnChange := Nil;
    cbMainLayout.ItemIndex := Integer(LocalBuildOptions.MainLayout);
    cbMainLayout.OnChange := cbMainLayoutChange;

    cbControlPositionSubPanel.OnChange := Nil;
    if LocalBuildOptions.ControlPanelSubPosition = cp_SubTop then cbControlPositionSubPanel.ItemIndex := 0;
    if LocalBuildOptions.ControlPanelSubPosition = cp_SubBottom then cbControlPositionSubPanel.ItemIndex := 1;
    cbControlPositionSubPanel.OnChange := cbControlPositionSubPanelChange;

    cbControlPanelRows.Checked              := LocalBuildOptions.ControlPanelTwoRows           ;
    cbControlPanelShowCover.Checked         := LocalBuildOptions.ControlPanelShowCover         ;
    // cbControlPanelShowVisualisation.Checked := LocalBuildOptions.ControlPanelShowVisualisation ;

    cbHideFileOverview.OnClick := Nil;
    cbHideFileOverview.Checked := LocalBuildOptions.HideFileOverviewPanel;
    cbHideFileOverview.OnClick := cbHideFileOverviewClick;

    // enable/disable Postion-sub-settings for ControlPanel
    RGrpControlSubPanel.Enabled       := LocalBuildOptions.ControlPanelPosition = cp_subPanel;
    LblSubPanelPosition.Enabled       := LocalBuildOptions.ControlPanelPosition = cp_subPanel;
    cbControlPositionSubPanel.Enabled := LocalBuildOptions.ControlPanelPosition = cp_subPanel;
end;

procedure TMainFormBuilder.FormCreate(Sender: TObject);
var a: tListItem;
    fn: String;
begin
    LocalBuildOptions := TNempFormBuildOptions.Create;
    LocalBuildOptions.NewLayout := Layout_TwoRows;

    LocalBuildOptions.MegaContainer  := ___FormSimulatorPanel;
    LocalBuildOptions.SuperContainer := __MainContainer;
    LocalBuildOptions.MainContainerA := _TopMainPanel;
    LocalBuildOptions.MainContainerB := _BottomMainPanel;
    LocalBuildOptions.MainSplitter := MainSplitter;

    LocalBuildOptions.ChildPanelMinHeight := 100;
    LocalBuildOptions.ChildPanelMinWidth  := 100;

    LocalBuildOptions.MainPanelMinHeight := 100;
    LocalBuildOptions.MainPanelMinWidth := 100;

    LocalBuildOptions.ControlPanel.SetControlValues(_ControlPanel, Nil, Nil, Nil, Nil, Nil, Nil, Nil,{ Nil,} 'Player Control');

    // fill it with the default layout
    LocalBuildOptions.BlockBrowse.SetValues(BlockBrowse, HeaderBrowse, ContentBrowse, 'Coverflow');
    LocalBuildOptions.BlockPlaylist.SetValues(BlockPlaylist, HeaderPlaylist, ContentPlaylist, 'Playlist');
    LocalBuildOptions.BlockMediaList.SetValues(BlockMediaList, HeaderMediaList, ContentMedialist, 'Medialist');
    LocalBuildOptions.BlockFileOverview.SetValues(BlockFileOverview, HeaderFileOverview, ContentFileOverview, 'File overview');

    LocalBuildOptions.PanelAChilds.Add(LocalBuildOptions.BlockBrowse);
    LocalBuildOptions.PanelAChilds.Add(LocalBuildOptions.BlockPlaylist);

    LocalBuildOptions.PanelBChilds.Add(LocalBuildOptions.BlockMediaList);
    LocalBuildOptions.PanelBChilds.Add(LocalBuildOptions.BlockFileOverView);

    LocalBuildOptions.SubSplitter1 := SplitterTop;
    LocalBuildOptions.SubSplitter2 := SplitterBottom;

    fn := ExtractFilePath(ParamStr(0)) + 'Images\FormBuilderUp.png';
    if FileExists(fn) then
    begin
        ImgMediaListUp    .Picture.LoadFromFile(fn);
        ImgFileOverviewUp .Picture.LoadFromFile(fn);
        ImgPlaylistUp     .Picture.LoadFromFile(fn);
        ImgCoverFlowUp    .Picture.LoadFromFile(fn);
    end;

    fn := ExtractFilePath(ParamStr(0)) + 'Images\FormBuilderDown.png';
    if FileExists(fn) then
    begin
        ImgMediaListDown    .Picture.LoadFromFile(fn);
        ImgFileOverviewDown .Picture.LoadFromFile(fn);
        ImgPlaylistDown     .Picture.LoadFromFile(fn);
        ImgCoverFlowDown    .Picture.LoadFromFile(fn);
    end;

    fn := ExtractFilePath(ParamStr(0)) + 'Images\FormBuilderLeft.png';
    if FileExists(fn) then
    begin
        ImgMediaListLeft    .Picture.LoadFromFile(fn);
        ImgFileOverviewLeft .Picture.LoadFromFile(fn);
        ImgPlaylistLeft     .Picture.LoadFromFile(fn);
        ImgCoverFlowLeft    .Picture.LoadFromFile(fn);
    end;

    fn := ExtractFilePath(ParamStr(0)) + 'Images\FormBuilderRight.png';
    if FileExists(fn) then
    begin
        ImgMediaListRight    .Picture.LoadFromFile(fn);
        ImgFileOverviewRight .Picture.LoadFromFile(fn);
        ImgPlaylistRight     .Picture.LoadFromFile(fn);
        ImgCoverFlowRight    .Picture.LoadFromFile(fn);
    end;

    ApplySettings;
    LocalBuildOptions.SwapMainLayout;
    FixAllButtons;
end;

procedure TMainFormBuilder.FormShow(Sender: TObject);
begin
    LocalBuildOptions.Assign(Nemp_MainForm.NempFormBuildOptions);
    FixAllButtons;
    FixSettingsGUI;
end;




procedure TMainFormBuilder.BtnUndoClick(Sender: TObject);
begin
    LocalBuildOptions.Assign(Nemp_MainForm.NempFormBuildOptions);
    FixAllButtons;
    FixSettingsGUI;
end;

// reset all input and restore Default Laoyut
procedure TMainFormBuilder.BtnResetToDefaultClick(Sender: TObject);
begin
    LocalBuildOptions.ResetToDefault;
    FixAllButtons;
    FixSettingsGUI;
end;


procedure TMainFormBuilder.ApplyClick(Sender: TObject);
begin

    LockWindowUpdate(Nemp_MainForm.Handle);

    Nemp_MainForm.NempFormBuildOptions.BeginUpdate;
    Nemp_MainForm.NempFormBuildOptions.assign (LocalBuildOptions);
    Nemp_MainForm.NempFormBuildOptions.EndUpdate;

    LockWindowUpdate(0);

    Nemp_MainForm.CorrectSkinRegionsTimer.Enabled := True;
    // Nemp_MainForm.CorrectSkinRegions;
end;


procedure TMainFormBuilder.BlockBrowseResize(Sender: TObject);
begin
    ImgCoverFlowUp    .left := (ContentBrowse.Width  Div 2) - 12;
    ImgCoverFlowUp.Top := 4;

    ImgCoverFlowDown  .left := (ContentBrowse.Width  Div 2) - 12;
    ImgCoverFlowDown.Top := ContentBrowse.Height - 28;

    ImgCoverFlowLeft  .top  := (ContentBrowse.Height Div 2) - 12;
    ImgCoverFlowLeft.Left := 4;

    ImgCoverFlowRight .top  := (ContentBrowse.Height Div 2) - 12;
    ImgCoverFlowRight.Left := ContentBrowse.Width - 28;
end;
procedure TMainFormBuilder.BlockFileOverviewResize(Sender: TObject);
begin
    ImgFileOverviewUp    .left := (ContentFileOverview.Width  Div 2) - 12;
    ImgFileOverviewUp.Top := 4;

    ImgFileOverviewDown  .left := (ContentFileOverview.Width  Div 2) - 12;
    ImgFileOverviewDown.Top := ContentFileOverview.Height - 28;

    ImgFileOverviewLeft  .top  := (ContentFileOverview.Height Div 2) - 12;
    ImgFileOverviewLeft.Left := 4;

    ImgFileOverviewRight .top  := (ContentFileOverview.Height Div 2) - 12;
    ImgFileOverviewRight.Left  := ContentFileOverview.Width - 28;
end;
procedure TMainFormBuilder.BlockMedialistResize(Sender: TObject);
begin
    ImgMediaListUp    .Left := (ContentMedialist.Width  Div 2) - 12;
    ImgMediaListUp    .Top := 4;

    ImgMediaListDown  .Left := (ContentMedialist.Width  Div 2) - 12;
    ImgMediaListDown  .Top := ContentMedialist.Height - 28;

    ImgMediaListLeft  .top  := (ContentMedialist.Height Div 2) - 12;
    ImgMediaListLeft  .left := 4;

    ImgMediaListRight .top  := (ContentMedialist.Height Div 2) - 12;
    ImgMediaListRight .left := ContentMedialist.Width - 28

end;
procedure TMainFormBuilder.BlockPlaylistResize(Sender: TObject);
begin
    ImgPlaylistUp    .left := (ContentPlaylist.Width  Div 2) - 12;
    ImgPlaylistUp    .Top := 4;

    ImgPlaylistDown  .left := (ContentPlaylist.Width  Div 2) - 12;
    ImgPlaylistDown.Top := ContentPlaylist.Height - 28;

    ImgPlaylistLeft  .top  := (ContentPlaylist.Height Div 2) - 12;
    ImgPlaylistLeft  .left := 4;

    ImgPlaylistRight .top  := (ContentPlaylist.Height Div 2) - 12;
    ImgPlaylistRight .left := ContentPlaylist.Width  - 28;
end;



procedure TMainFormBuilder.ApplySettings;
begin
    LocalBuildOptions.ControlPanelPosition := TControlPanelPosition(cbControlPosition.ItemIndex);
    LocalBuildOptions.NewLayout := TMainLayout(cbMainLayout.ItemIndex);
    case cbControlPositionSubPanel.ItemIndex of
        0: LocalBuildOptions.ControlPanelSubPosition := cp_SubTop;
        1:  LocalBuildOptions.ControlPanelSubPosition := cp_SubBottom;
    end;

    case RGrpControlSubPanel.ItemIndex of
        0: LocalBuildOptions.ControlPanelSubParent := LocalBuildOptions.BlockBrowse;
        1: LocalBuildOptions.ControlPanelSubParent := LocalBuildOptions.BlockPlaylist;
        2: LocalBuildOptions.ControlPanelSubParent := LocalBuildOptions.BlockMediaList;
        3: LocalBuildOptions.ControlPanelSubParent := LocalBuildOptions.BlockFileOverview;
    end;
end;



procedure TMainFormBuilder.cbMainLayoutChange(Sender: TObject);
begin
    LocalBuildOptions.NewLayout := TMainLayout(cbMainLayout.ItemIndex);
    LocalBuildOptions.SwapMainLayout;
    FixAllButtons;
end;

procedure TMainFormBuilder.cbHideFileOverviewClick(Sender: TObject);
var VisA, VisB: Boolean;
begin
    VisA := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds);
    VisB := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds);

    if cbHideFileOverview.Checked then
    begin
        // set one of the splitters to "available"
        if LocalBuildOptions.PanelAChilds.IndexOf(LocalBuildOptions.BlockFileOverview) > -1 then
            LocalBuildOptions.MakeOneSplitterAvailable(0);
        if LocalBuildOptions.PanelBChilds.IndexOf(LocalBuildOptions.BlockFileOverview) > -1 then
            LocalBuildOptions.MakeOneSplitterAvailable(1);
        // remove the block from the childpanels
        LocalBuildOptions.PanelAChilds.Extract(LocalBuildOptions.BlockFileOverview);
        LocalBuildOptions.PanelBChilds.Extract(LocalBuildOptions.BlockFileOverview);
        // hide the block
        LocalBuildOptions.BlockFileOverview.Block.Visible := False;
    end else
    begin
        // show the block
        LocalBuildOptions.BlockFileOverview.Block.Visible := True;
        // add it to the (second) panel
        // buit only if it is really NOT included in one of the lists
        if (LocalBuildOptions.PanelAChilds.IndexOf(LocalBuildOptions.BlockFileOverview) = -1)
            and (LocalBuildOptions.PanelBChilds.IndexOf(LocalBuildOptions.BlockFileOverview) = -1)
        then
            LocalBuildOptions.PanelBChilds.Add(LocalBuildOptions.BlockFileOverview);
    end;
    // rebuild the layout
    LocalBuildOptions.HideFileOverviewPanel := cbHideFileOverview.Checked;
    LocalBuildOptions.RefreshBothRowsOrColumns(False);
    FixAllButtons;

    if (VisA <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds))
        or  (VisB <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds))
    then
        LocalBuildOptions.SwapMainLayout;
end;

procedure TMainFormBuilder.cbControlPanelRowsClick(Sender: TObject);
begin
    LocalBuildOptions.ControlPanelTwoRows           := cbControlPanelRows.Checked;
end;

procedure TMainFormBuilder.cbControlPanelShowCoverClick(Sender: TObject);
begin
    LocalBuildOptions.ControlPanelShowCover         := cbControlPanelShowCover.Checked;
end;

procedure TMainFormBuilder.cbControlPanelShowVisualisationClick(
  Sender: TObject);
begin
    //LocalBuildOptions.ControlPanelShowVisualisation := cbControlPanelShowVisualisation.Checked;
end;

procedure TMainFormBuilder.cbControlPositionChange(Sender: TObject);
begin
    ApplySettings;
    LocalBuildOptions.SwapMainLayout;

    RGrpControlSubPanel      .Enabled := cbControlPosition.ItemIndex = 3;
    LblSubPanelPosition      .Enabled := cbControlPosition.ItemIndex = 3;
    cbControlPositionSubPanel.Enabled := cbControlPosition.ItemIndex = 3;
end;

procedure TMainFormBuilder.cbControlPositionSubPanelChange(Sender: TObject);
begin
    ApplySettings;
    LocalBuildOptions.SwapMainLayout;
end;

procedure TMainFormBuilder.RGrpControlSubPanelClick(Sender: TObject);
begin
    ApplySettings;
    LocalBuildOptions.SwapMainLayout;
end;


procedure TMainFormBuilder.SplitterTopCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
var s: TSplitter;
begin
    s := Sender as TSplitter;
    if s.Align in [alLeft, alRight] then
        accept := (s.MinSize < NewSize) and ( (s.Parent.Width - newSize) > s.MinSize)
    else
        accept := (s.MinSize < NewSize) and ( (s.Parent.Height - newSize) > s.MinSize)
end;

procedure TMainFormBuilder.SplitterTopMoved(Sender: TObject);
begin
    LocalBuildOptions.OnSplitterMoved(Sender);
end;

procedure TMainFormBuilder.MainSplitterMoved(Sender: TObject);
begin
    LocalBuildOptions.OnMainSplitterMoved(Sender);
end;

procedure TMainFormBuilder.ImgUpClick(Sender: TObject);
var idx: Integer;
    ParentPanel: TPanel;
    ParentBlock: TNempBlockPanel;
    aSplitter: TSplitter;
    VisA, VisB: Boolean;
begin
    VisA := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds);
    VisB := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds);

    // UP-Click
    ParentPanel := ((Sender as TImage).Parent.Parent) as TPanel;
    ParentBlock := LocalBuildOptions.GetBlockByPanel(ParentPanel);

    // if "two columns": Move one Up in the ChildList
    if LocalBuildOptions.MainLayout = Layout_TwoColumns  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if (idx > 0) and (idx < LocalBuildOptions.PanelAChilds.Count) then
            LocalBuildOptions.PanelAChilds.Exchange(idx, idx - 1);

        // or is it in the right MainPanel?
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if (idx > 0) and (idx < LocalBuildOptions.PanelBChilds.Count) then
            LocalBuildOptions.PanelBChilds.Exchange(idx, idx - 1);

        LocalBuildOptions.RefreshAColumn((ParentPanel.Parent) as TPanel);
        FixAllButtons;
    end;

    // if "two Rows": Move to the upper row
    if LocalBuildOptions.MainLayout = Layout_TwoRows  then
    begin
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if idx > -1 then // it really is in the bottom MAIN Panel
        begin
            LocalBuildOptions.PanelBChilds.Extract(ParentBlock);
            if idx = 0 then
                LocalBuildOptions.PanelAChilds.Insert(idx, ParentBlock)      ///
            else
                LocalBuildOptions.PanelAChilds.Add(ParentBlock); // order will be done by RefreshBothRowsOrColumns

            LocalBuildOptions.MakeOneSplitterAvailable(1);
        end;

        LocalBuildOptions.RefreshBothRowsOrColumns(True);
        LocalBuildOptions.ApplyRatios;
        FixAllButtons;
    end;

    if (VisA <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds))
        or  (VisB <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds))
    then
        LocalBuildOptions.SwapMainLayout;
end;




procedure TMainFormBuilder.ImgDownClick(Sender: TObject);
var idx: Integer;
    ParentPanel: TPanel;
    ParentBlock: TNempBlockPanel;
    aSplitter: TSplitter;
    VisA, VisB: Boolean;
begin
    VisA := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds);
    VisB := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds);

    // DOWN-Click
    ParentPanel := ((Sender as TImage).Parent.Parent) as TPanel;
    ParentBlock := LocalBuildOptions.GetBlockByPanel(ParentPanel);

    // if "two columns": Move one DOWN in the ChildList
    if LocalBuildOptions.MainLayout = Layout_TwoColumns  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if (idx > -1) and (idx < LocalBuildOptions.PanelAChilds.Count - 1) then
            LocalBuildOptions.PanelAChilds.Exchange(idx, idx + 1);

        // or is it in the right MainPanel?
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if (idx > -1) and (idx < LocalBuildOptions.PanelBChilds.Count - 1) then
            LocalBuildOptions.PanelBChilds.Exchange(idx, idx + 1);

        LocalBuildOptions.RefreshAColumn((ParentPanel.Parent) as TPanel);
        FixAllButtons;
    end;

    // if "two Rows": Move to the bottom row
    if LocalBuildOptions.MainLayout = Layout_TwoRows  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if idx > -1 then // it really is in the bottom MAIN Panel
        begin
            LocalBuildOptions.PanelAChilds.Extract(ParentBlock);
            if idx = 0 then
                LocalBuildOptions.PanelBChilds.Insert(idx, ParentBlock)      ///
            else
                LocalBuildOptions.PanelBChilds.Add(ParentBlock);

            LocalBuildOptions.MakeOneSplitterAvailable(0);
        end;

        LocalBuildOptions.RefreshBothRowsOrColumns(True);
        LocalBuildOptions.ApplyRatios;
        FixAllButtons;
    end;

    if (VisA <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds))
        or  (VisB <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds))
    then
        LocalBuildOptions.SwapMainLayout;
end;

procedure TMainFormBuilder.ImgLeftClick(Sender: TObject);
var idx: Integer;
    ParentPanel: TPanel;
    ParentBlock: TNempBlockPanel;
    aSplitter: TSplitter;
    VisA, VisB: Boolean;
begin
    VisA := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds);
    VisB := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds);

    // LeftClick
    ParentPanel := ((Sender as TImage).Parent.Parent) as TPanel;
    ParentBlock := LocalBuildOptions.GetBlockByPanel(ParentPanel);

    // if "two rows": Move one Left in the ChildList
    if LocalBuildOptions.MainLayout = Layout_TwoRows  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if (idx > 0) and (idx < LocalBuildOptions.PanelAChilds.Count) then
            LocalBuildOptions.PanelAChilds.Exchange(idx, idx - 1);

        // or is it in the bottom MainPanel?
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if (idx > 0) and (idx < LocalBuildOptions.PanelBChilds.Count) then
            LocalBuildOptions.PanelBChilds.Exchange(idx, idx - 1);

        LocalBuildOptions.RefreshARow((ParentPanel.Parent) as TPanel);
        FixAllButtons;
    end;

    // if "two Columns": Move to the left Column
    if LocalBuildOptions.MainLayout = Layout_TwoColumns  then
    begin
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if idx > -1 then // it really is in the right MAIN Panel
        begin
            LocalBuildOptions.PanelBChilds.Extract(ParentBlock);
            if idx = 0 then
                LocalBuildOptions.PanelAChilds.Insert(idx, ParentBlock)   ////
            else
                LocalBuildOptions.PanelAChilds.Add(ParentBlock);

            LocalBuildOptions.MakeOneSplitterAvailable(1);
        end;

        LocalBuildOptions.RefreshBothRowsOrColumns(True);
        LocalBuildOptions.ApplyRatios;
        FixAllButtons;
    end;

    if (VisA <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds))
        or  (VisB <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds))
    then
        LocalBuildOptions.SwapMainLayout;
end;

procedure TMainFormBuilder.ImgRightClick(Sender: TObject);
var idx: Integer;
    ParentPanel: TPanel;
    ParentBlock: TNempBlockPanel;
    aSplitter: TSplitter;
    VisA, VisB: Boolean;
begin
    VisA := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds);
    VisB := LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds);

    // RightClick
    ParentPanel := ((Sender as TImage).Parent.Parent) as TPanel;
    ParentBlock := LocalBuildOptions.GetBlockByPanel(ParentPanel);

    // if "two rows": Move one Right in the ChildList
    if LocalBuildOptions.MainLayout = Layout_TwoRows  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if (idx > -1) and (idx < LocalBuildOptions.PanelAChilds.Count - 1) then
            LocalBuildOptions.PanelAChilds.Exchange(idx, idx + 1);

        // or is it in the bottom MainPanel?
        idx := LocalBuildOptions.PanelBChilds.IndexOf(ParentBlock);
        if (idx > -1) and (idx < LocalBuildOptions.PanelBChilds.Count - 1) then
            LocalBuildOptions.PanelBChilds.Exchange(idx, idx + 1);

        LocalBuildOptions.RefreshARow((ParentPanel.Parent) as TPanel);
        FixAllButtons;
    end;

    // if "two Columns": Move to the right Column
    if LocalBuildOptions.MainLayout = Layout_TwoColumns  then
    begin
        idx := LocalBuildOptions.PanelAChilds.IndexOf(ParentBlock);
        if idx > -1 then // it really is in the left MAIN Panel
        begin
            LocalBuildOptions.PanelAChilds.Extract(ParentBlock);
            if idx = 0 then
                LocalBuildOptions.PanelBChilds.insert(idx, ParentBlock)  ////
            else
                LocalBuildOptions.PanelBChilds.Add(ParentBlock);

            LocalBuildOptions.MakeOneSplitterAvailable(0);
        end;

        LocalBuildOptions.RefreshBothRowsOrColumns(True);
        LocalBuildOptions.ApplyRatios;
        FixAllButtons;
    end;

    if (VisA <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelAChilds))
        or  (VisB <> LocalBuildOptions.EmptyPanel(LocalBuildOptions.PanelBChilds))
    then
        LocalBuildOptions.SwapMainLayout;
end;



end.
