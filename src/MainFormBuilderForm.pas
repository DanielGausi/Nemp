{

    Unit MainFormBuilderForm

    - Construction of the MainForm Layout

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
unit MainFormBuilderForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, MyDialogs, MainFormLayout,
  System.Generics.Collections, System.Generics.Defaults,

  Nemp_ConstantsAndTypes, Vcl.ComCtrls, NempPanel, Vcl.Menus, System.IniFiles,
  Vcl.Imaging.pngimage;

type

  TMenuItemList = TObjectList<TMenuItem>;

  TMainFormBuilder = class(TForm)
    BtnApply: TButton;
    BtnCancel: TButton;
    BtnOK: TButton;
    pnlButtons: TPanel;
    MainContainer: TNempContainerPanel;
    pnlTree: TNempPanel;
    pnlCoverflow: TNempPanel;
    pnlCloud: TNempPanel;
    pnlPlaylist: TNempPanel;
    pnlMedialist: TNempPanel;
    pnlDetails: TNempPanel;
    pnlControls: TNempPanel;
    cbSelection: TCheckBox;
    cbMedialist: TCheckBox;
    cbeDetails: TCheckBox;
    btnRemoveTree: TButton;
    btnRemoveCoverflow: TButton;
    btnRemoveCloud: TButton;
    btnRemovePlaylist: TButton;
    btnRemoveMediaList: TButton;
    btnRemoveDetails: TButton;
    btnRemoveControls: TButton;
    lblMainContainer: TLabel;
    grpBoxNempElements: TGroupBox;
    grpBoxVisibleElements: TGroupBox;
    pnlNempWindowEdit: TPanel;
    pnlSettings: TPanel;
    grpBoxAdditionalConfig: TGroupBox;
    cbControlPanelShowCover: TCheckBox;
    grpBoxNempConstruction: TGroupBox;
    pnlConstructionHint: TPanel;
    lblElementCount: TLabel;
    pnlConstruction: TPanel;
    MainMenu: TMainMenu;
    mmLayout: TMenuItem;
    mmSplit1: TMenuItem;
    mmClear: TMenuItem;
    mmResetToDefault: TMenuItem;
    mmUndo: TMenuItem;
    cbTreeViewOrientation: TComboBox;
    lblTreeViewOrientation: TLabel;
    cbFileOverviewOrientation: TComboBox;
    lblFileOverview: TLabel;
    cbFileOverviewMode: TComboBox;
    lblPlaylistAlwaysVisible: TLabel;
    mmExampleLayouts: TMenuItem;
    cbShowCategorySelection: TCheckBox;
    imgInfo: TImage;
    BtnHelp: TButton;
    ImgHelp: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnResetToDefaultClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbSelectionClick(Sender: TObject);
    procedure AfterContainerCreated(Sender: TObject);

    procedure MainContainerResize(Sender: TObject);
    procedure BtnNewLayoutClick(Sender: TObject);
    //procedure BtnSplitHorizontallyClick(Sender: TObject);
    //procedure btnSplitVerticallyClick(Sender: TObject);

    procedure BtnEditContainerClick(Sender: TObject);
    procedure NempContainerDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NempContainerDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure BtnResetPanelClick(Sender: TObject);
    procedure pnlDefaultContainerDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure pnlDefaultContainerDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);

    procedure mmLayoutPresetClick(Sender: TObject);
    procedure cbFileOverviewModeChange(Sender: TObject);
    procedure mmUndoClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
  private
    { Private declarations }

    TestLayout: TNempLayout;
    BackupLayout: TNempLayout;
    LayoutDefaults: TMemIniFile;
    AvailableLayouts: TStringList;
    CreatedMenuItems: TMenuItemList;

    procedure BuildMainMenu;

    procedure ApplySettingsToGui;
    procedure RefreshEditGUI;
    procedure RefreshFileOverViewGUI;
    procedure RemovePanelFromParent(aPanel: TNempPanel);
    procedure ResetNempPanel(aPanel: TNempPanel);
    procedure ResetAllNempPanel;
    procedure AssignFromBackupLayout;
  public
    { Public declarations }
    procedure WndProc(var Msg: TMessage); override;
    procedure ReTranslateMenuItems;
  end;

var
  MainFormBuilder: TMainFormBuilder;

implementation

uses Nemp_RessourceStrings, Hilfsfunktionen, gnugettext, SplitForm_Hilfsfunktionen, NempHelp;

{$R *.dfm}

const
  WM_REMOVEPANEL = WM_USER + 1;


procedure TMainFormBuilder.FormCreate(Sender: TObject);
var
  fnIni, imgFile: String;
begin
  BackupComboboxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);
  HelpContext := HELP_FormDesigner;

  MainContainer.ID := 'A';
  TestLayout := TNempLayout.Create;
  TestLayout.ConstructionLayout := True;

  TestLayout.TreePanel       := pnlTree;
  TestLayout.CoverflowPanel  := pnlCoverflow;
  TestLayout.CloudPanel      := pnlCloud;
  TestLayout.PlaylistPanel   := pnlPlaylist;
  TestLayout.MedialistPanel  := pnlMedialist;
  TestLayout.DetailsPanel    := pnlDetails;
  TestLayout.ControlsPanel   := pnlControls;
  TestLayout.MainContainer   := MainContainer;
  TestLayout.OnAfterContainerCreate := AfterContainerCreated;
  //TestLayout.OnSplitterMoved := NewLayoutSplitterMoved;
  TestLayout.BlockHeapControl := grpBoxNempElements;

  BackupLayout := TNempLayout.Create;

  MainContainer.OnEditButtonClick := BtnEditContainerClick;
  MainContainer.CreateEditButtons;
  MainContainer.SplitterMinSize := 33;
  lblMainContainer.Font.Size := 11;
  lblMainContainer.Caption := Format(FormBuilder_MainContainerCaption, [#$25E7, #$2B12]);

  fnIni := ExtractFilePath(ParamStr(0)) + 'Data\Layouts';
  if FileExists(fnIni) then  begin
    LayoutDefaults := TMemIniFile.Create(fnIni, TEncoding.UTF8);
    //LayoutDefaults := TMemIniFile.Create(fnIni);
    AvailableLayouts := TStringList.Create;
    CreatedMenuItems := TMenuItemList.Create(False);
  end
  else begin
    LayoutDefaults := Nil;
    AvailableLayouts := Nil;
  end;

  imgFile := ExtractFilePath(ParamStr(0)) + 'Images\info.png';
  if FileExists(imgFile) then
    imgInfo.Picture.LoadFromFile(imgFile);

  BuildMainMenu;
end;

procedure TMainFormBuilder.FormDestroy(Sender: TObject);
begin
  TestLayout.Free;
  if assigned(LayoutDefaults) then
    LayoutDefaults.Free;
  if assigned(AvailableLayouts) then
    AvailableLayouts.Free;
  if assigned(CreatedMenuItems) then
    CreatedMenuItems.Free;
end;

procedure TMainFormBuilder.FormShow(Sender: TObject);
begin
  BackupLayout.Assign(NempLayout);
  AssignFromBackupLayout;
  lblElementCount.Caption := FormBuilder_ConstructionFormShow;
end;

procedure TMainFormBuilder.BuildMainMenu;
var
  langKey, newName: String;
  newItem: TMenuItem;
  i: Integer;
begin
  if not assigned(LayoutDefaults) then begin
    //mmSplit1.Visible := False;
    mmExampleLayouts.Visible := False;
    exit;
  end;

  LayoutDefaults.ReadSections(AvailableLayouts);
  if NempOptions.Language = 'de' then
    langKey := 'de'
  else
    langKey := 'en';

  for i := 0 to AvailableLayouts.Count - 1 do begin
    newName := LayoutDefaults.ReadString(AvailableLayouts[i], langKey, AvailableLayouts[i]);

    newItem := TMenuItem.Create(self);
    newItem.Tag := i;
    newItem.AutoHotkeys := maManual;
    newItem.Caption := newName;
    newItem.Hint := FormBuilder_LoadPresetHint;
    newItem.OnClick := mmLayoutPresetClick;
    CreatedMenuItems.Add(newItem);
    // mmLayout.Insert(i, newItem);
    mmExampleLayouts.Add(newItem)
  end;
end;

procedure TMainFormBuilder.ReTranslateMenuItems;
var
  langKey: String;
  i: Integer;
begin
  if not assigned(CreatedMenuItems) then
    exit;

  if NempOptions.Language = 'de' then
    langKey := 'de'
  else
    langKey := 'en';

  for i := 0 to CreatedMenuItems.Count - 1 do
    CreatedMenuItems[i].Caption := LayoutDefaults.ReadString(AvailableLayouts[i], langKey, AvailableLayouts[i]);
end;

procedure TMainFormBuilder.mmLayoutPresetClick(Sender: TObject);
var
  idx: Integer;
begin
  idx := (Sender as TMenuItem).Tag;
  if (idx >= 0) and (idx <= AvailableLayouts.Count - 1) then begin
    if not TestLayout.LoadPreset(LayoutDefaults, AvailableLayouts[idx], False) then
      TranslateMessageDLG(FormBuilder_PresetInstructionsInvalid, mtWarning, [MBOK], 0);

    ApplySettingsToGui;
    TestLayout.BuildMainForm;
    RefreshEditGUI;
  end else
    TranslateMessageDLG(FormBuilder_PresetInstructionsMissing, mtError, [MBOK], 0); // should not happen at all ...
end;


procedure TMainFormBuilder.AssignFromBackupLayout;
begin
  TestLayout.Assign(BackupLayout);
  ApplySettingsToGui;
  TestLayout.BuildMainForm;
  RefreshEditGUI;
  RefreshFileOverViewGUI;
end;

// reset all input and restore Default Laoyut
procedure TMainFormBuilder.BtnResetToDefaultClick(Sender: TObject);
begin
  TestLayout.ResetToDefault;
  ApplySettingsToGui;
  TestLayout.BuildMainForm;
  RefreshEditGUI;
  RefreshFileOverViewGUI;
end;

procedure TMainFormBuilder.BtnCancelClick(Sender: TObject);
begin
  NempLayout.Assign(BackupLayout);
  NempLayout.BuildMainForm;
  Close;
end;

procedure TMainFormBuilder.mmUndoClick(Sender: TObject);
begin
  AssignFromBackupLayout;
  TestLayout.Assign(BackupLayout);
  ApplySettingsToGui;
  TestLayout.BuildMainForm;
  RefreshEditGUI;
  RefreshFileOverViewGUI;
  // revoke changes also on MainForm
  NempLayout.Assign(BackupLayout);
  NempLayout.BuildMainForm;
end;


procedure TMainFormBuilder.WndProc(var Msg: TMessage);
begin
  inherited;
  case Msg.Msg of
    WM_REMOVEPANEL: begin
      TestLayout.DeletePanel(TNempContainerPanel(Msg.WParam));
      RefreshEditGUI;
    end;
  end;
end;

procedure TMainFormBuilder.RefreshEditGUI;
var
  lc: Integer;
  AllPanelsPlaced: Boolean;
begin
  lc := MainContainer.LeafCount;
  lblMainContainer.Visible := False; //lc = 1;

  AllPanelsPlaced := (pnlTree.Parent <> grpBoxNempElements)
          and (pnlCoverflow.Parent <> grpBoxNempElements)
          and (pnlCloud.Parent <> grpBoxNempElements)
          and (pnlPlaylist.Parent <> grpBoxNempElements)
          and (pnlMedialist.Parent <> grpBoxNempElements)
          and (pnlDetails.Parent <> grpBoxNempElements)
          and (pnlControls.Parent <> grpBoxNempElements);

  btnRemoveTree.Visible := pnlTree.Parent <> grpBoxNempElements;
  btnRemoveCoverflow.Visible := pnlCoverflow.Parent <> grpBoxNempElements;
  btnRemoveCloud.Visible := pnlCloud.Parent <> grpBoxNempElements;
  btnRemovePlaylist.Visible := pnlPlaylist.Parent <> grpBoxNempElements;
  btnRemoveMediaList.Visible := pnlMedialist.Parent <> grpBoxNempElements;
  btnRemoveDetails.Visible := pnlDetails.Parent <> grpBoxNempElements;
  btnRemoveControls.Visible := pnlControls.Parent <> grpBoxNempElements;

  BtnOk.Enabled := AllPanelsPlaced;
  BtnApply.Enabled := AllPanelsPlaced;

  if AllPanelsPlaced then
    lblElementCount.Caption := FormBuilder_ConstructionComplete
  else
  begin
    if lc = 1 then
      lblElementCount.Caption := Format(FormBuilder_MainContainerCaption, [#$25E7, #$2B12])
    else
      if lc < 7 then
        lblElementCount.Caption := Format(FormBuilder_ElementCount, [7 - lc])
      else
        if lc = 7 then
          lblElementCount.Caption := FormBuilder_ElementCountComplete
        else
          lblElementCount.Caption := FormBuilder_ElementCountTooMany;
  end;

  TestLayout.RefreshEditButtons(lc=7);
  TestLayout.ReNumberContainerPanels;
  // TestLayout.CreateBuildInstructions(Memo1.Lines);
end;

procedure TMainFormBuilder.RefreshFileOverViewGUI;
begin
  // lblFileOVerviewOrientation.Enabled := cbFileOverviewMode.ItemIndex = 0;
  cbFileOverviewOrientation.Enabled := cbFileOverviewMode.ItemIndex = 0;
end;

{
  Remove a NempPanel from the Framework (and put it back to the Selection-Container)
}
procedure TMainFormBuilder.RemovePanelFromParent(aPanel: TNempPanel);
var
  aParent: TNempContainerPanel;
begin
  if assigned(aPanel.Parent) and (aPanel.Parent is TNempContainerPanel) then begin
    aParent := TNempContainerPanel(aPanel.Parent);
    aParent.RemovePanel(aPanel);
    if aPanel.FixedHeight and (assigned(aParent.ParentPanel)) then begin
      aParent.Align := alNone;
      aParent.FixedHeight := False;
      aParent.ParentPanel.AlignChildPanels(False);
    end;
  end;


  RefreshEditGUI;
end;

procedure TMainFormBuilder.ResetNempPanel(aPanel: TNempPanel);

begin
  aPanel.Align := alNone;
  RemovePanelFromParent(aPanel);

  // put it back to the Selection-Container
  aPanel.Parent := grpBoxNempElements;
  aPanel.Visible := True;
  aPanel.Top := 16;
  aPanel.Left := aPanel.Tag;
  aPanel.Width := 96;
  if aPanel.FixedHeight then
    aPanel.Height := 35
  else
    aPanel.Height := 50;
  RefreshEditGUI;
end;

procedure TMainFormBuilder.ResetAllNempPanel;
begin
  ResetNempPanel(pnlTree);
  ResetNempPanel(pnlCoverflow);
  ResetNempPanel(pnlCloud);
  ResetNempPanel(pnlPlaylist);
  ResetNempPanel(pnlMedialist);
  ResetNempPanel(pnlDetails);
  ResetNempPanel(pnlControls);
end;

procedure TMainFormBuilder.BtnResetPanelClick(Sender: TObject);
var
  snd: TNempPanel;
begin
  snd := ((Sender as TButton).Parent) as TNempPanel;
  ResetNempPanel(snd);
end;

{
  Assign the NempPanels to a Container within the built up Framework
}
procedure TMainFormBuilder.NempContainerDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  snd, sndParent: TNempContainerPanel;
  src: TNempPanel;
begin
  snd := Sender as TNempContainerPanel;
  if (Source is TNempPanel)
      and (snd.HierarchyLevel > 0)
      and (snd.ChildPanelCount = 0)
  then begin
    src := TNempPanel(Source);
    sndParent := snd.ParentPanel;
    accept := (not src.FixedHeight)
        or (src.FixedHeight and (sndParent.Orientation = poVertical));
  end
  else
    accept := False;
end;

procedure TMainFormBuilder.NempContainerDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  snd: TNempContainerPanel;
  src: TNempPanel;
begin
  snd := Sender as TNempContainerPanel;
  src := TNempPanel(Source);
  src.Align := alNone;
  // remove the Panel from its previous Parent and add it to the DropTarget
  RemovePanelFromParent(src);
  snd.AddNempPanel(src);
  // adjust the Height of the DropTarget (=Sender), if the SourcePanel has a FixedHeight (i.e. = ControlPanel)
  if src.FixedHeight then begin
    snd.Align := alNone;
    snd.Height := src.Height;
    snd.FixedHeight := True;
    src.Align := alClient;
    snd.ParentPanel.AlignChildPanels(false);
  end else
    src.Align := alClient;

  //snd.AlignChildPanels(False);
  RefreshEditGUI;
end;



procedure TMainFormBuilder.pnlDefaultContainerDragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept := (Source is TNempPanel);
end;

procedure TMainFormBuilder.pnlDefaultContainerDragDrop(Sender, Source: TObject;
  X, Y: Integer);
begin
  ResetNempPanel(Source as TNempPanel);
end;


{

}
procedure TMainFormBuilder.MainContainerResize(Sender: TObject);
begin
  TestLayout.ReAlignMainForm;
end;

procedure TMainFormBuilder.BtnNewLayoutClick(Sender: TObject);
begin
  TestLayout.Clear;
  ResetAllNempPanel;
  RefreshEditGUI;
end;


{
  Schrittweise Aufbau per GUI-Interaktionen
}

procedure TMainFormBuilder.AfterContainerCreated(Sender: TObject);
var
  cntSend: TNempContainerPanel;
begin
  cntSend := Sender as TNempContainerPanel;
  cntSend.BevelOuter := bvRaised;
  cntSend.OnEditButtonClick := BtnEditContainerClick;
  cntSend.OnDragOver := NempContainerDragOver;
  cntSend.OnDragDrop := NempContainerDragDrop;
  cntSend.CreateEditButtons;
  cntSend.ParentBackground := False;
end;

procedure TMainFormBuilder.BtnEditContainerClick(Sender: TObject);
var
  BtnPanel: TNempContainerPanel;
begin
  if not (Sender is TButton) then exit;
  if not ((Sender as TButton).Parent is TNempContainerPanel) then exit;
  BtnPanel :=  TNempContainerPanel((Sender as TButton).Parent);

  case TButton(Sender).Tag of
    1: TestLayout.Split(BtnPanel, poHorizontal);
    2: TestLayout.Split(BtnPanel, poVertical);
    // deleting a button (by deleting it's Parent) in its own OnClick event is not a good idea. Therefore:
    3: PostMessage(Handle, WM_REMOVEPANEL, wParam(BtnPanel), 0); // see WndProc how to handle WM_REMOVEPANEL
  end;
  RefreshEditGUI;
end;


procedure TMainFormBuilder.BtnHelpClick(Sender: TObject);
begin
  Application.HelpContext(Help_FormDesigner);
end;

procedure TMainFormBuilder.BtnApplyClick(Sender: TObject);
begin
    if NempOptions.AnzeigeMode = 1 then
    begin
        TranslateMessageDLG(FormBuilder_SeparateWindowWarning, mtWarning, [MBOK], 0);
    end else
    begin
        TestLayout.ShowBibSelection  := cbSelection.Checked;
        TestLayout.ShowMedialist     := cbMedialist.Checked;
        TestLayout.ShowFileOverview  := cbeDetails.Checked;
        // Additional Settings
        TestLayout.ShowControlCover := cbControlPanelShowCover.Checked;
        TestLayout.ShowCategoryTree := cbShowCategorySelection.Checked;
        TestLayout.TreeviewOrientation := cbTreeViewOrientation.ItemIndex;
        TestLayout.FileOVerviewOrientation := cbFileOverviewOrientation.ItemIndex;
        TestLayout.FileOverviewMode := teFileOverViewMode(cbFileOverviewMode.ItemIndex);

        RevokeDragFiles;
        //LockWindowUpdate(Nemp_MainForm.Handle);
        //LockWindowUpdate(0);
        TestLayout.Simplify;
        NempLayout.Clear;
        NempLayout.Assign(TestLayout);
        NempLayout.BuildMainForm;

        NempLayout.SaveSettings(True);
        NempSettingsManager.UpdateFile;
        // TestLayout.Clear;
        // TestLayout.BuildMainForm;
    end;
end;


procedure TMainFormBuilder.BtnOKClick(Sender: TObject);
begin
    BtnApplyClick(Sender);
    close;
end;

procedure TMainFormBuilder.ApplySettingsToGui;
begin
  cbSelection.Checked := TestLayout.ShowBibSelection;
  cbMedialist.Checked := TestLayout.ShowMedialist;
  cbeDetails.Checked := TestLayout.ShowFileOverview;
  // Additional Settings
  cbControlPanelShowCover.Checked := TestLayout.ShowControlCover;
  cbShowCategorySelection.Checked := TestLayout.ShowCategoryTree;
  cbTreeViewOrientation.ItemIndex := TestLayout.TreeviewOrientation;
  cbFileOverviewOrientation.ItemIndex := TestLayout.FileOVerviewOrientation;
  cbFileOverviewMode.ItemIndex := Integer(TestLayout.FileOverviewMode);
end;

procedure TMainFormBuilder.cbFileOverviewModeChange(Sender: TObject);
begin
  RefreshFileOverViewGUI;
end;

procedure TMainFormBuilder.cbSelectionClick(Sender: TObject);
begin
  case TCheckBox(Sender).Tag of
    0: TestLayout.ShowBibSelection := TCheckBox(Sender).Checked;
    1: TestLayout.ShowMedialist := TCheckBox(Sender).Checked;
    2: TestLayout.ShowFileOverview := TCheckBox(Sender).Checked;
  end;
end;



end.
