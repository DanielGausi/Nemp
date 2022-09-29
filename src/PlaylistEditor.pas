{

    Unit PlaylistEditor
    Form PlaylistEditorForm

    Editor for favorite Playists with Copy&Paste, Drag&Drop and some more.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2020, Daniel Gaussmann
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

unit PlaylistEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees, Vcl.StdCtrls, Generics.Collections,
  WinApi.ShellApi, WinApi.ActiveX, MyDialogs, NempHelp,
  NempAudioFiles, PlayerClass, PlaylistClass, PlaylistManagement, AudioFileHelper, DriveRepairTools,
  Vcl.Menus, VCL.Clipbrd, NempDragFiles, vcl.themes;

type
  TPlaylistEditorForm = class(TForm)
    PnlPlaylistSelection: TPanel;
    PlaylistSelectionVST: TVirtualStringTree;
    Splitter1: TSplitter;
    BtnNew: TButton;
    BtnRemove: TButton;
    PnlPlaylistFiles: TPanel;
    PlaylistFilesVST: TVirtualStringTree;
    BtnSave: TButton;
    BtnImport: TButton;
    PlayListOpenDialog: TOpenDialog;
    PopUpPlaylist: TPopupMenu;
    PM_PL_Delete: TMenuItem;
    PM_PL_AddFiles: TMenuItem;
    PM_PL_AddPlaylist: TMenuItem;
    PM_PL_Save: TMenuItem;
    PM_PL_ShowinExplorer: TMenuItem;
    PlaylistDateienOpenDialog: TOpenDialog;
    PM_PL_Paste: TMenuItem;
    PM_PL_Copy: TMenuItem;
    N1: TMenuItem;
    BtnAdd: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PlaylistSelectionVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure PlaylistFilesVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure FormDestroy(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure PlaylistFilesVSTDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure PlaylistFilesVSTDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure PlaylistFilesVSTDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure PlaylistFilesVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PlaylistFilesVSTEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure PM_PL_ImportClick(Sender: TObject);
    procedure PM_PL_ShowinExplorerClick(Sender: TObject);
    procedure PM_PL_SaveClick(Sender: TObject);
    procedure PM_PL_DeleteClick(Sender: TObject);
    procedure PM_PL_AddFilesClick(Sender: TObject);
    procedure PlaylistSelectionVSTEditing(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure PlaylistSelectionVSTNewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure PlaylistSelectionVSTEdited(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure PlaylistSelectionVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure PlaylistSelectionVSTFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure PM_PL_PasteClick(Sender: TObject);
    procedure PM_PL_CopyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PlaylistFilesVSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure PlaylistFilesVSTGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
    procedure PlaylistSelectionVSTDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure PlaylistSelectionVSTDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure PlaylistSelectionVSTEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure PlaylistSelectionVSTDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure PlaylistSelectionVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlaylistFilesVSTGetUserClipboardFormats(Sender: TBaseVirtualTree;
      var Formats: TFormatEtcArray);
    procedure PlaylistFilesVSTRenderOLEData(Sender: TBaseVirtualTree;
      const FormatEtcIn: tagFORMATETC; out Medium: tagSTGMEDIUM;
      ForClipboard: Boolean; var Result: HRESULT);
    procedure PopUpPlaylistPopup(Sender: TObject);
    procedure PlaylistSelectionVSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    { Private declarations }
    currentQuickPlaylist: TQuickLoadPlaylist;
    currentPlaylistChanged: Boolean;

    MostRecentInsertNodeForPlaylist: PVirtualNode;

    procedure FillPlaylistTree;
    function Handle_DropFilesForEditorPlaylist(FileList: TStringList;
      TargetNode: PVirtualNode; Mode: TDropMode): Boolean;
    procedure InsertFile(aFileName: String; var InsertIndex: Integer);
    procedure RefreshPlaylistHeader;

    procedure RefreshEditButtons;

  public
    { Public declarations }
    //QuickLoadPlaylists: TQuickLoadPlaylistCollection;

    EditorPlaylist: TAudioFileList;

    DriveManager: TDriveManager;
    LocalPlaylistManager: TPlaylistManager;
  end;

var
  PlaylistEditorForm: TPlaylistEditorForm;
  // OldLBWindowProc: TWndMethod;

implementation

Uses NempMainUnit, Hilfsfunktionen, Nemp_ConstantsAndTypes, TreeHelper, Nemp_RessourceStrings,
  NewFavoritePlaylist, MainFormHelper, SystemHelper, gnuGettext, AudioDisplayUtils;

{$R *.dfm}


///  OnCreate, OnDestroy
///  * initialize and free local stuff
procedure TPlaylistEditorForm.FormCreate(Sender: TObject);
begin
    PlaylistSelectionVST.NodeDataSize := SizeOf(TQuickLoadPlaylist);
    PlaylistFilesVST.NodeDataSize := SizeOf(TAudioFile);

    DriveManager := TDriveManager.Create;
    LocalPlaylistManager := TPlaylistManager.Create(DriveManager);
    LocalPlaylistManager.QuickLoadPlaylists.OwnsObjects := False;

    //QuickLoadPlaylists := TQuickLoadPlaylistCollection.Create(False);
    EditorPlaylist := TAudioFileList.Create(True);
    currentQuickPlaylist := Nil;
    currentPlaylistChanged := False;

    RegisterDragDrop(PlaylistFilesVST.Handle, Nemp_MainForm.fDropManager as IDropTarget);
    TranslateComponent (self);

    HelpContext := HELP_FavoritePlaylists;
end;

procedure TPlaylistEditorForm.FormDestroy(Sender: TObject);
begin
    EditorPlaylist.Free;
    LocalPlaylistManager.Free;
    DriveManager.Free;

    RevokeDragDrop(PlaylistFilesVST.Handle);
end;


///  FormShow
///  Fill the Treeview with the list of Managed Playlists
procedure TPlaylistEditorForm.FormShow(Sender: TObject);
var i: Integer;
    aNode: PVirtualNode;
begin
    PlaylistDateienOpenDialog.Filter := Nemp_MainForm.PlaylistDateienOpenDialog.Filter;
    // copy from the Main PlaylistManager
    LocalPlaylistManager.SavePath := NempPlaylist.PlaylistManager.SavePath;
    LocalPlaylistManager.QuickLoadPlaylists.Clear;
    for i := 0 to NempPlaylist.PlaylistManager.QuickLoadPlaylists.Count - 1 do
        LocalPlaylistManager.QuickLoadPlaylists.Add(NempPlaylist.PlaylistManager.QuickLoadPlaylists[i]);

    // display it in the Treeview;
    PlaylistSelectionVST.Clear;
    for i := 0 to LocalPlaylistManager.Count - 1 do
        PlaylistSelectionVST.AddChild(Nil, LocalPlaylistManager.QuickLoadPlaylists[i]);

    // Select the first Playlist
    if LocalPlaylistManager.Count > 0 then
    begin
        aNode := PlaylistSelectionVST.GetFirst;
        PlaylistSelectionVST.Selected[aNode] := True;
    end;
    currentPlaylistChanged := False;

    RefreshEditButtons;


//    assigned(currentQuickPlaylist)

    {
    LocalPlaylistManager.RecentPlaylists.Clear;
    for i := 0 to NempPlaylist.PlaylistManager.RecentPlaylists.Count - 1 do
        LocalPlaylistManager.RecentPlaylists.Add(NempPlaylist.PlaylistManager.RecentPlaylists[i]);
    }
end;

///  OnCloseQuery:
///  * Check for Changes in the current playlist
procedure TPlaylistEditorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    MedienBib.ImportFavoritePlaylists(NempPlaylist.PlaylistManager);
    Nemp_MainForm.ArtistsVST.Invalidate;

    if MedienBib.CurrentCategory = MedienBib.FavoritePlaylistCategory then
      Nemp_MainForm.ReFillBrowseTrees(True);
end;

procedure TPlaylistEditorForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := True;
    if currentPlaylistChanged then
    begin
         if  assigned(currentQuickPlaylist) then
         begin
            case TranslateMessageDLG(Format((PlaylistManagerAutoSave_Text), [currentQuickPlaylist.Description]),
                    mtWarning, [mbYes, MBNo, MBCancel], 0) of
                mrYes: begin
                    PM_PL_SaveClick(nil);
                    currentPlaylistChanged := False;
                    CanClose := True;
                end;
                mrNo    : begin
                    currentPlaylistChanged := False;
                    CanClose := True;
                end;
                mrCancel: CanClose := False;
            end;
         end;
    end ;
end;


///  Some little methods
///  ----------------------------------------
///  RefreshPlaylistHeader
///  * Show playlist summary in the Treeview Header
procedure TPlaylistEditorForm.RefreshPlaylistHeader;
var Duration: Int64;
    i: Integer;
begin
    Duration := 0;
    for i:= 0 to EditorPlayList.Count - 1 do
        Duration := Duration + EditorPlayList[i].Duration;

    PlaylistFilesVST.Header.Columns[0].Text := Format('%s - %s (%d)', [(TreeHeader_Playlist), LocalPlaylistManager.CurrentPlaylistDescription,  EditorPlaylist.Count]);
    PlaylistFilesVST.Header.Columns[1].Text := SekToZeitString(Duration);
end;
///  InsertFile
///  * Insert a new File into the current Playlist (and the Tree)
procedure TPlaylistEditorForm.InsertFile(aFileName: String; var InsertIndex: Integer);
var NewFile: TAudioFile;
    NewNode, insertNode: PVirtualNode;
begin
    NewFile := TAudioFile.Create;
    NewFile.Pfad := aFilename;
    SynchNewFileWithBib(newFile);

    if (InsertIndex = -1) or (InsertIndex = EditorPlaylist.Count) then
    begin
        if InsertIndex = EditorPlaylist.Count then
            inc(InsertIndex);
        EditorPlaylist.Add(NewFile);
        PlaylistFilesVST.AddChild(Nil, newFile);
    end else
    begin
        EditorPlaylist.Insert(InsertIndex, NewFile);

        insertNode := GetNodeWithIndex(PlaylistFilesVST, InsertIndex, MostRecentInsertNodeForPlaylist);
        NewNode := PlaylistFilesVST.InsertNode(InsertNode, amInsertBefore, NewFile);
        MostRecentInsertNodeForPlaylist := NewNode;

        inc(InsertIndex);
    end;
    currentPlaylistChanged := True;
end;


///  Events for the Treeviews:
///  * Display proper text information
procedure TPlaylistEditorForm.PlaylistFilesVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var af: TAudioFile;
begin
    af := Sender.GetNodeData<TAudioFile>(Node);
    case column of
      0: CellText := NempDisplay.PlaylistTitle(af);
      1: CellText := NempDisplay.TreeDuration(af); // af.GetDurationForVST;
    end;
end;
///  * put some more detailed file information into the Hint
procedure TPlaylistEditorForm.PlaylistFilesVSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
var af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if assigned(af) then
      HintText := NempDisplay.HintText(af);
end;
///  * strike out non existing files
procedure TPlaylistEditorForm.PlaylistFilesVSTPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
var AudioFile:TAudioFile;
begin
    TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText);
    AudioFile := PlaylistFilesVST.GetNodeData<TAudioFile>(Node);
    if NOT AudioFile.FileIsPresent then
        TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsStrikeOut]
end;

///  * GetText for the Selection Treeview
procedure TPlaylistEditorForm.PlaylistSelectionVSTGetText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
begin
    Celltext := Sender.GetNodeData<TQuickLoadPlaylist>(Node).Description;
end;

///  FillPlaylistTree
///  * fill the PlaylistFilesTree with all the files from the selected Playlist
procedure TPlaylistEditorForm.FillPlaylistTree;
var i: Integer;
begin
    PlaylistFilesVST.Clear;
    for i := 0 to EditorPlaylist.Count - 1 do
        PlaylistFilesVST.AddChild(Nil, EditorPlaylist[i]);
end;
///  PlaylistSelectionVSTFocusChanging
///  * Check for changes, allow FocusChange after proper UserInput if changes occured
procedure TPlaylistEditorForm.PlaylistSelectionVSTFocusChanging(
  Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn,
  NewColumn: TColumnIndex; var Allowed: Boolean);
begin
    Allowed := True; // default
    if currentPlaylistChanged and (OldNode <> NewNode) then
    begin
        // ToDo: Ask User to Save/Discard changes
         if  assigned(currentQuickPlaylist) then
         begin
            case TranslateMessageDLG(Format((PlaylistManagerAutoSave_Text), [currentQuickPlaylist.Description]),
                    mtWarning, [mbYes, MBNo, MBCancel], 0) of
                mrYes: begin
                    PM_PL_SaveClick(nil);
                    Allowed := True;                
                end;
                mrNo: Allowed := True;
                mrCancel: begin
                    Allowed := False;              
                    Sender.Selected[oldNode] := True;
                end;
            end;
         end;     
    end ;
end;
///  PlaylistSelectionVSTFocusChanged
///  Load the new Playlist into the Treeview
procedure TPlaylistEditorForm.PlaylistSelectionVSTFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
    if (not assigned(Node)) then
    begin
        // clear the current Playlist ...
        EditorPlaylist.Clear;
        DriveManager.Clear;
        FillPlaylistTree;
        currentQuickPlaylist := Nil;
        currentPlaylistChanged := False;
        RefreshEditButtons;
        exit;
    end;

    // clear the current Playlist ...
    EditorPlaylist.Clear;
    DriveManager.Clear;
    // ... and load the new one
    LocalPlaylistManager.LoadPlaylist(Node.Index, EditorPlaylist, false);
    // ... show Files in Treeview
    FillPlaylistTree;
    currentQuickPlaylist := PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(Node);
    // ... refresh Header
    RefreshPlaylistHeader;
    currentPlaylistChanged := False;
    RefreshEditButtons;
end;

procedure TPlaylistEditorForm.RefreshEditButtons;
var
  enable: Boolean;
begin
  enable := assigned(self.currentQuickPlaylist);
  BtnAdd.Enabled := enable;
  BtnImport.Enabled := enable;
  BtnSave.Enabled := enable;
end;

procedure TPlaylistEditorForm.PopUpPlaylistPopup(Sender: TObject);
var
  enable, selected: Boolean;

begin
  enable := assigned(self.currentQuickPlaylist);
  PM_PL_AddFiles.Enabled := enable;
  PM_PL_AddPlaylist.Enabled := enable;
  PM_PL_Save.Enabled := enable;
  PM_PL_Paste.Enabled := enable;

  selected := PlaylistFilesVST.SelectedCount > 0;

  PM_PL_ShowinExplorer.Enabled := enable and selected;
  PM_PL_Delete.Enabled := enable and selected;
  PM_PL_Copy.Enabled := enable and selected;

end;



///  Edit QuickloadPlaylist
procedure TPlaylistEditorForm.PlaylistSelectionVSTEditing(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
    Allowed := True;
end;



///  Set Description to the new Value
procedure TPlaylistEditorForm.PlaylistSelectionVSTNewText(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  NewText: string);
var ql: TQuickLoadPlaylist;
begin
    ql := PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(Node);
    ql.Description := NewText;
end;


procedure TPlaylistEditorForm.PlaylistSelectionVSTPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;

procedure TPlaylistEditorForm.PlaylistSelectionVSTEdited(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var ql: TQuickLoadPlaylist;
begin
    ql := PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(Node);

    if NempPlaylist.PlaylistManager.QuickLoadPlaylists.IndexOf(ql) >= 0 then
    begin
        // the current Playlist is ot yet part of the original Favorite List
        // NempPlaylist.PlaylistManager.QuickLoadPlaylists.Add(currentQuickPlaylist);
        Nemp_MainForm.OnFavouritePlaylistsChange(Self);
        Nemp_MainForm.PlaylistPropertiesChanged(NempPlaylist);
    end;
end;



///  Drag&Drop inside the VST
procedure TPlaylistEditorForm.PlaylistFilesVSTDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
    Allowed := True;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  InitiateDragDrop(PlaylistFilesVST, Nemp_MainForm.fDropManager, False, True);
  // last parameter=True:
  // Actually, we do not know, whether the source is the "player".
  // But it's safer to assume it is
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTGetUserClipboardFormats(
  Sender: TBaseVirtualTree; var Formats: TFormatEtcArray);
var
  i: Integer;
  State: TKeyboardState;
begin
    GetKeyboardState(State);
    if ((State[VK_CONTROL] and 128) = 0)
      and ((State[VK_RButton] and 128) = 0)
    then
      (Sender as TVirtualStringTree).DragOperations := [doCopy, doMove]
    else
    begin
      (Sender as TVirtualStringTree).DragOperations := [doCopy];
      i := Length(Formats);
      SetLength(Formats, i + 1);
      Formats[i].cfFormat := CF_HDROP;
      Formats[i].ptd := nil;
      Formats[i].dwAspect := DVASPECT_CONTENT;
      Formats[i].lindex := -1;
      Formats[i].tymed := TYMED_HGLOBAL;
    end;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTRenderOLEData(
  Sender: TBaseVirtualTree; const FormatEtcIn: tagFORMATETC;
  out Medium: tagSTGMEDIUM; ForClipboard: Boolean; var Result: HRESULT);
begin
  if FormatEtcIn.cfFormat = CF_HDROP then begin
    result := OLERenderFilenames(Nemp_MainForm.fDropManager.Files, Medium);
  end;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  szMessage: String;

  procedure SetFeedBackParams(vEffect: Integer; vAccept: Boolean; vHint: String);
  begin
    Effect := vEffect;
    Accept := vAccept;
    szMessage := vhint;
  end;

begin
  if State = dsDragLeave then begin
    SetDragHint(Sender.DragManager.DataObject, '', '', Effect);
    Accept := True;
    exit;
  end;

  if Source = PlaylistSelectionVST then begin
    accept := False;
    exit;
  end;

  if Nemp_MainForm.fDropManager.DragSource = PlaylistFilesVST then begin
    // Drag&Drop within the Playlist
    // The Effect will be set automatically by the Treeview according to Keyboard-Modifiers
    // But we have to set the DragHint again
    case Effect of
      DROPEFFECT_MOVE: szMessage := DragDropPlaylistMove;
      DROPEFFECT_COPY: szMessage := DragDropPlaylistCopy;
    else
      szMessage := DragDropPlaylistMove; // this case shouldn't happen
    end;
    Accept := True;
  end else
  begin
      if not assigned(currentQuickPlaylist) then
        SetFeedBackParams(DROPEFFECT_NONE, False, PlaylistManager_CreatePlaylistFirstDragDrop)
      else
      begin
          // DragSource is NOT the Playlist, so we are expecting new Files for the Playlist
          // Either from the Library or from external sources
          if assigned(Nemp_MainForm.fDropManager.DragSource) then
            // From internal sources: Always Accept  (except on cueNodes)
            SetFeedBackParams(DROPEFFECT_COPY, TRUE {ValidNode}, DragDropPlaylistAdd)
          else begin
            // From external sources: Do accept only "Files", but not things like "Text"
            // Note: Some other stuff like "E-Mails" dragged from Thunderbird are also considered as "Files"
            if ObjContainsFiles(Sender.DragManager.DataObject) then
              SetFeedBackParams(DROPEFFECT_COPY, True, DragDropPlaylistAdd)
            else
              // Definitely no Files - don't accept
              SetFeedBackParams(DROPEFFECT_NONE, False, '')
          end;
      end;
  end;
  // correct Efect/Hintstr if Accept is False
  if (not Accept) and assigned(currentQuickPlaylist) then
    SetFeedBackParams(DROPEFFECT_NONE, False, '');

  SetDragHint(Sender.DragManager.DataObject, szMessage, '', Effect);

end;

procedure TPlaylistEditorForm.PlaylistFilesVSTEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  Nemp_MainForm.FDropManager.FinishDrag;
end;

function TPlaylistEditorForm.Handle_DropFilesForEditorPlaylist(FileList: TStringList;
  TargetNode: PVirtualNode; Mode: TDropMode): Boolean;
var
  i, InsertIndex: Integer;
  Filename: String;
begin
    result := True;
    InsertIndex := -1;

    if assigned(TargetNode)  then begin
      case Mode of
        dmNowhere: InsertIndex := -1;
        dmAbove: InsertIndex := TargetNode.Index;
        dmOnNode,
        dmBelow: InsertIndex := TargetNode.Index + 1;
      end;
    end;

    for i := 0 to FileList.Count - 1 do begin
      Filename := FileList[i];
      if (FileGetAttr(UnicodeString(Filename)) AND faDirectory = faDirectory) then
        // nothing
      else
      begin
        case Nemp_MainForm.NempFileType(Filename) of
          nftPlaylist, nftCUE: ; // nothing
          nftSupported, nftCDDA: InsertFile(FileName, InsertIndex);
          nftUnknown: begin
              if FileList.Count = 1 then
                InsertFile(FileName, InsertIndex);
          end;
        end;
      end;
    end;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var Attachmode: TVTNodeAttachMode;
    Nodes: TNodeArray;
    aNode: PVirtualNode;
    i: Integer;
    FileList: TStringList;
begin
    if NOT assigned(Nemp_MainForm.fDropManager.DragSource) then begin
      // Drop from an external Source.
      // Try to get Files from the OLEDrag-Object and insert it into the Playlist
      FileList := TStringList.Create;
      try
        if ObjContainsFiles(Nemp_MainForm.fDropManager.DataObject) then begin
          GetFileListFromObj(DataObject, FileList);
          Handle_DropFilesForEditorPlaylist(FileList, PlaylistFilesVST.DropTargetNode, Mode);
        end;
      finally
        FileList.Free;
      end;
    end else
    begin
      // Internal Drop.
      // In DragOver we have decided whether we want MOVE or COPY the selected tracks
      if Effect = DROPEFFECT_COPY then begin
        // Use the Filenames stored in the DropManager
        FileList := TStringList.Create;
        try
          for i := 0 to Nemp_MainForm.FDropManager.FileNameCount - 1 do
            FileList.Add(Nemp_MainForm.FDropManager.FileNames[i]);
          Handle_DropFilesForEditorPlaylist(FileList, PlaylistFilesVST.DropTargetNode, Mode);
        finally
          FileList.Free;
        end;
      end else
      begin
        // Just move the Nodes
        Nodes := PlaylistFilesVST.GetSortedSelection(True);
        // Translate the drop position into an node attach mode.
        case Mode of
          dmAbove : AttachMode := amInsertBefore;
          dmOnNode: AttachMode := amInsertAfter;
          dmBelow : AttachMode := amInsertAfter;
        else
          AttachMode := amNowhere;
        end;

        // move the selected Nodes to Target
        if not assigned(PlaylistFilesVST.DropTargetNode) then
        begin
          // DropTarget is the empty space below the (small) Playlist
          // => Move files to the end of the Playlist
          aNode := PlaylistFilesVST.GetLastChild(Nil);
          for i := High(Nodes) downto 0 do
              PlaylistFilesVST.MoveTo(Nodes[i], aNode, amInsertAfter, False)
        end else
        begin
          if AttachMode = amInsertBefore then
            for i := 0 to High(Nodes) do
              PlaylistFilesVST.MoveTo(Nodes[i], PlaylistFilesVST.DropTargetNode, AttachMode, False)
          else
            for i := High(Nodes) downto 0 do
              PlaylistFilesVST.MoveTo(Nodes[i], PlaylistFilesVST.DropTargetNode, AttachMode, False);
        end;
      end;
      // put the current sorting of AudioFiles in the EditorPlaylist again
      EditorPlaylist.OwnsObjects := False;
      EditorPlaylist.Clear;
      EditorPlaylist.OwnsObjects := True;
      aNode := PlaylistFilesVST.GetFirst;
      while assigned(aNode)  do
      begin
        EditorPlaylist.Add(PlaylistFilesVST.GetNodeData<TAudioFile>(aNode));
        aNode := PlaylistFilesVST.GetNextSibling(aNode);
      end;
    end;
    currentPlaylistChanged := True;
    Nemp_MainForm.fDropManager.FinishDrag;
    PlaylistFilesVST.Invalidate;
end;


///  Drag&Drop Operations for Selection
///  DragAllowed
procedure TPlaylistEditorForm.PlaylistSelectionVSTDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
    Allowed := True;
end;
///  DragStart
procedure TPlaylistEditorForm.PlaylistSelectionVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin

end;
///  DragOver
procedure TPlaylistEditorForm.PlaylistSelectionVSTDragOver(
  Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState;
  State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer;
  var Accept: Boolean);
begin
    if Source <> PlaylistSelectionVST then
        exit;
    Effect := DROPEFFECT_MOVE;
    accept := True;
end;
// Mainmethod: DragDrop, move Nodes/Favorites
procedure TPlaylistEditorForm.PlaylistSelectionVSTDragDrop(
  Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject;
  Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer;
  Mode: TDropMode);
var Attachmode: TVTNodeAttachMode;
    Nodes: TNodeArray;
    aNode: PVirtualNode;
    i: Integer;
begin
    // Translate the drop position into an node attach mode.
    case Mode of
        dmAbove : AttachMode := amInsertBefore;
        dmOnNode: AttachMode := amInsertAfter;
        dmBelow : AttachMode := amInsertAfter;
    else
        AttachMode := amNowhere;
    end;

    // Get the selected Nodes
    Nodes := PlaylistSelectionVST.GetSortedSelection(True);

    // move the selected Nodes to Target
    if not assigned(PlaylistSelectionVST.DropTargetNode) then
    begin
        // DropTarget is the empty space below the
        // => Move files to the end of the Playlist
        aNode := PlaylistSelectionVST.GetLastChild(Nil);
        for i := High(Nodes) downto 0 do
            PlaylistSelectionVST.MoveTo(Nodes[i], aNode, amInsertAfter, False)
    end else
    begin
        if AttachMode = amInsertBefore then
            for i := 0 to High(Nodes) do
                PlaylistSelectionVST.MoveTo(Nodes[i], PlaylistSelectionVST.DropTargetNode, AttachMode, False)
        else
            for i := High(Nodes) downto 0 do
                PlaylistSelectionVST.MoveTo(Nodes[i], PlaylistSelectionVST.DropTargetNode, AttachMode, False);
    end;

    // resort Datalists
    LocalPlaylistManager.QuickLoadPlaylists.Clear;
    NempPlaylist.PlaylistManager.QuickLoadPlaylists.OwnsObjects := False;
    NempPlaylist.PlaylistManager.QuickLoadPlaylists.Clear;
    NempPlaylist.PlaylistManager.QuickLoadPlaylists.OwnsObjects := True;

    aNode := PlaylistSelectionVST.GetFirst;
    while assigned(aNode)  do
    begin
        LocalPlaylistManager.QuickLoadPlaylists.Add(PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(aNode));
        NempPlaylist.PlaylistManager.QuickLoadPlaylists.Add(PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(aNode));
        aNode := PlaylistSelectionVST.GetNextSibling(aNode);
    end;
    // Change Menu Items in mainForm
    Nemp_MainForm.OnFavouritePlaylistsChange(Self);

    // Nemp_MainForm.DragSource := DS_EXTERN;
    PlaylistSelectionVST.Invalidate;
end;
///  DragEnd
procedure TPlaylistEditorForm.PlaylistSelectionVSTEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin

end;


///
///  Popup-Menu Operations
///
///  Add some files to the Playlist
procedure TPlaylistEditorForm.PM_PL_AddFilesClick(Sender: TObject);
var i, dummy: Integer;
begin
    if PlaylistDateienOpenDialog.Execute then
    begin
        dummy := -1;
        for i := 0 to PlaylistDateienOpenDialog.Files.Count - 1 do
            InsertFile(PlaylistDateienOpenDialog.Files[i], dummy);

        RefreshPlaylistHeader;
        currentPlaylistChanged := True;
    end;
end;

///  Load an existing Playlist and add these files into the current Playlist
procedure TPlaylistEditorForm.PM_PL_ImportClick(Sender: TObject);
begin
    if PlaylistOpenDialog.Execute then
    begin
        LoadPlaylistFromFile(PlaylistOpenDialog.FileName, EditorPlaylist, True, DriveManager);
        FillPlaylistTree;

        RefreshPlaylistHeader;
        currentPlaylistChanged := True;
    end;
end;

///  Copy&Paste
procedure TPlaylistEditorForm.PM_PL_CopyClick(Sender: TObject);
var FileString: String;
begin
    FileString := GetFileListForClipBoardFromTree(PlaylistFilesVST);
    if FileString <> '' then
        CopyFilesToClipboard(FileString);
end;
procedure TPlaylistEditorForm.PM_PL_PasteClick(Sender: TObject);
var InsertIndex, i, numFiles: Integer;
    extension: String;
    f: THandle;
    buffer: array [0..MAX_PATH] of WideChar;
begin
    if not Clipboard.HasFormat(CF_HDROP) then
        Exit;

    if assigned(PlaylistFilesVST.FocusedNode) then
        InsertIndex := PlaylistFilesVST.FocusedNode.Index + 1
    else
        InsertIndex := -1;

    Clipboard.Open;
    try
        f := Clipboard.GetAsHandle(CF_HDROP);
        if f <> 0 then
        begin
            numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0);

            for i := 0 to numfiles - 1 do
            begin
                buffer[0] := #0;
                DragQueryFile(f, i, buffer, SizeOf(buffer));
                clipCursor(Nil);
                if (FileGetAttr((buffer)) AND faDirectory <> faDirectory) then
                begin
                    extension := AnsiLowerCase(ExtractFileExt(buffer));
                    if NempPlayer.ValidExtensions.IndexOf(extension) > -1 then
                        InsertFile(buffer, InsertIndex)
                end;
            end;
        end;
    finally
        Clipboard.Close;
    end;
    RefreshPlaylistHeader;
    currentPlaylistChanged := True;
    PlaylistFilesVST.Invalidate;
end;

///  Delete selected files from the Playlist
procedure TPlaylistEditorForm.PM_PL_DeleteClick(Sender: TObject);
var i: Integer;
  Selectedmp3s: TNodeArray;
  NewSelectNode: PVirtualNode;
begin
    // get the selected Nodes
    Selectedmp3s := PlaylistFilesVST.GetSortedSelection(False);
    if length(SelectedMp3s) = 0 then
        exit;

    // get a Node we want to select after removing the selected files
    NewSelectNode := PlaylistFilesVST.GetNextSibling(Selectedmp3s[length(Selectedmp3s)-1]);
    if not Assigned(NewSelectNode) then
        NewSelectNode := PlaylistFilesVST.GetPreviousSibling(Selectedmp3s[0]);

    // remove all selected Nodes
    for i := length(Selectedmp3s)-1 downto 0 do
        EditorPlaylist.Delete(Selectedmp3s[i].Index);
    PlaylistFilesVST.DeleteSelectedNodes;

    // select a proper new Node
    if assigned(NewSelectNode) then
    begin
        PlaylistFilesVST.Selected[NewSelectNode] := True;
        PlaylistFilesVST.FocusedNode := NewSelectNode;
    end;

    RefreshPlaylistHeader;
    // Set the Changed-Flag
    currentPlaylistChanged := True;
end;

///  Save Current Playlist
procedure TPlaylistEditorForm.PM_PL_SaveClick(Sender: TObject);
begin
    if not assigned(currentQuickPlaylist) then begin
      // should not happen with the disabled button and Drag/Drop now
      TranslateMessageDLG(PlaylistManager_CreatePlaylistFirstSave, mtError, [mbOK], 0);
      exit;
    end;

    LocalPlaylistManager.SaveCurrentPlaylist(EditorPlaylist, False);
    currentPlaylistChanged := False;

    if NempPlaylist.PlaylistManager.QuickLoadPlaylists.IndexOf(currentQuickPlaylist) = -1 then
    begin
        // the current Playlist is ot yet part of the original Favorite List
        NempPlaylist.PlaylistManager.QuickLoadPlaylists.Add(currentQuickPlaylist);
        Nemp_MainForm.OnFavouritePlaylistsChange(Self);
    end else
    begin
        // the current Playlist is the one currently active in Nemp
        if currentQuickPlaylist.Filename = NempPlaylist.PlaylistManager.CurrentPlaylistFilename then
            NempPlaylist.PlaylistManager.BackupPlaylistFilenames(EditorPlaylist);
    end;
end;

///  Show AudioFile in Windows Explorer
procedure TPlaylistEditorForm.PM_PL_ShowinExplorerClick(Sender: TObject);
var af: TAudioFile;
begin
    af := PlaylistFilesVST.GetNodeData<TAudioFile>(PlaylistFilesVST.FocusedNode);
    if not assigned(af) then
        exit;
    if DirectoryExists(af.Ordner) then
        ShellExecute(Handle, 'open', 'explorer.exe', PChar('/e,/select,"'+af.Pfad+'"'), '', sw_ShowNormal);
end;



procedure TPlaylistEditorForm.BtnNewClick(Sender: TObject);
var newQuickLoadPlaylist: TQuickLoadPlaylist;
    newNode: PVirtualNode;
begin

    if not assigned(NewFavoritePlaylistForm) then
        Application.CreateForm(TNewFavoritePlaylistForm, NewFavoritePlaylistForm);

    if NewFavoritePlaylistForm.ShowModal = mrOK then
    begin
        PlaylistFilesVST.Clear;
        EditorPlaylist.Clear;

        // create a new FavoritePlaylist and add it to the Nemp PlaylistManager
        newQuickLoadPlaylist := NempPlaylist.PlaylistManager.AddNewPlaylist(
            trim(NewFavoritePlaylistForm.edit_PlaylistDescription.Text),
            trim(NewFavoritePlaylistForm.edit_PlaylistFilename.Text),
            EditorPlaylist, True);

        // add the same to the editor
        LocalPlaylistManager.QuickLoadPlaylists.Add(newQuickLoadPlaylist);
        newNode := PlaylistSelectionVST.AddChild(Nil, newQuickLoadPlaylist);
        PlaylistSelectionVST.Selected[newNode] := True;
        PlaylistSelectionVST.FocusedNode := newNode;

        RefreshPlaylistHeader;
        currentPlaylistChanged := False;
    end;
end;

procedure TPlaylistEditorForm.BtnRemoveClick(Sender: TObject);
var ql: TQuickLoadPlaylist;
    NewSelectNode: PVirtualNode;
begin
    ql := PlaylistSelectionVST.GetNodeData<TQuickLoadPlaylist>(PlaylistSelectionVST.FocusedNode);
    if not assigned(ql) then
        exit;

    if  TranslateMessageDLG(Format((PlaylistManager_DeleteFavorite), [ql.Description]),
                    mtWarning, [mbYes,MBNo], 0) = mrYes
    then
    begin
        // Get a node to select after this operation
        NewSelectNode := PlaylistSelectionVST.GetNextSibling(PlaylistSelectionVST.FocusedNode);
        if not Assigned(NewSelectNode) then
            NewSelectNode := PlaylistSelectionVST.GetPreviousSibling(PlaylistSelectionVST.FocusedNode);

        // remove the selected favorite from the Editor
        LocalPlaylistManager.QuickLoadPlaylists.Extract(ql);
        PlaylistSelectionVST.DeleteNode(PlaylistSelectionVST.FocusedNode);
        // actually delete it from Nemp (and from Disk)
        NempPlaylist.PlaylistManager.DeletePlaylist(ql);

        // Select the next node
        if assigned(NewSelectNode) then
        begin
            PlaylistSelectionVST.Selected[NewSelectNode] := True;
            PlaylistSelectionVST.FocusedNode := NewSelectNode;
        end;

    end;
end;

end.
