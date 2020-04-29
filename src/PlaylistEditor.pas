unit PlaylistEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, VirtualTrees, Vcl.StdCtrls, Generics.Collections,
  WinApi.ShellApi, WinApi.ActiveX, MyDialogs,
  NempAudioFiles, PlayerClass, PlaylistClass, PlaylistManagement, AudioFileHelper, DriveRepairTools,
  uDragFilesSrc, Vcl.Menus, VCL.Clipbrd;

type
  TPlaylistEditorForm = class(TForm)
    PnlPlaylistSelection: TPanel;
    PlaylistSelectionVST: TVirtualStringTree;
    Splitter1: TSplitter;
    BtnNew: TButton;
    BtnRemove: TButton;
    PnlPlaylistFiles: TPanel;
    PlaylistFilesVST: TVirtualStringTree;
    DragFilesSrc1: TDragFilesSrc;
    DragDropTimer: TTimer;
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
    procedure DragFilesSrc1Dropping(Sender: TObject);
    procedure DragDropTimerTimer(Sender: TObject);
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
  private
    { Private declarations }
    currentQuickPlaylist: TQuickLoadPlaylist;
    currentPlaylistChanged: Boolean;

    MostRecentInsertNodeForPlaylist: PVirtualNode;

    procedure FillPlaylistTree;
    Procedure WMDropFiles (Var aMsg: tMessage);  message WM_DROPFILES;
    procedure LBWindowProc(var Message: TMessage);

    procedure InsertFile(aFileName: String; var InsertIndex: Integer);
    procedure RefreshPlaylistHeader;

  public
    { Public declarations }
    //QuickLoadPlaylists: TQuickLoadPlaylistCollection;

    EditorPlaylist: TAudioFileList;

    DriveManager: TDriveManager;
    LocalPlaylistManager: TPlaylistManager;
  end;

var
  PlaylistEditorForm: TPlaylistEditorForm;
  OldLBWindowProc: TWndMethod;

implementation

Uses NempMainUnit, Hilfsfunktionen, Nemp_ConstantsAndTypes, TreeHelper, Nemp_RessourceStrings,
  NewFavoritePlaylist, MainFormHelper, SystemHelper, gnuGettext;

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

    // Allow Drop of Files only in the PlaylistVST
    // Modify the WindowProc Method of the PlaylistFilesVST
    // https://www.swissdelphicenter.ch/de/showcode.php?id=493
    OldLBWindowProc := PlaylistFilesVST.WindowProc;
    PlaylistFilesVST.WindowProc := LBWindowProc;
    DragAcceptFiles(PlaylistFilesVST.Handle, True);

    TranslateComponent (self);
end;

procedure TPlaylistEditorForm.FormDestroy(Sender: TObject);
begin
    EditorPlaylist.Free;
    LocalPlaylistManager.Free;
    DriveManager.Free;

    PlaylistFilesVST.WindowProc := OldLBWindowProc;
    DragAcceptFiles(PlaylistFilesVST.Handle, False);
end;

procedure TPlaylistEditorForm.LBWindowProc(var Message: TMessage);
begin
  if Message.Msg = WM_DROPFILES then
      WMDROPFILES(Message); // handle WM_DROPFILES message
  OldLBWindowProc(Message);
  // call default ListBox1 WindowProc method to handle all other messages
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

    {
    LocalPlaylistManager.RecentPlaylists.Clear;
    for i := 0 to NempPlaylist.PlaylistManager.RecentPlaylists.Count - 1 do
        LocalPlaylistManager.RecentPlaylists.Add(NempPlaylist.PlaylistManager.RecentPlaylists[i]);
    }
end;

///  OnCloseQuery:
///  * Check for Changes in the current playlist
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
                    CanClose := True;
                end;
                mrNo    : CanClose := True;
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
      0: CellText := af.PlaylistTitle;
      1: CellText := af.GetDurationForVST;
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
      HintText := af.GetHint(0, 0, 0);
end;
///  * strike out non existing files
procedure TPlaylistEditorForm.PlaylistFilesVSTPaintText(
  Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType);
var AudioFile:TAudioFile;
begin
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
    if currentPlaylistChanged then
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




///  Editing a single Playlist
///  HandleDropFiles (from within Nemp or from the Explorer)
///  Note: limited features here:
///        * no support for dropped directories
///        * no Cue-Sheets
procedure TPlaylistEditorForm.WMDropFiles(var aMsg: tMessage);
Var Idx, Size, FileCount, NodeTop, InsertIndex: Integer;
    Filename: PChar;
    p: TPoint;
    aNode : PVirtualNode;
    extension: String;
begin
    p := PlayListFilesVST.ScreenToClient(Mouse.CursorPos);
    aNode := PlayListFilesVST.GetNodeAt(p.x, p.y, True,  NodeTop);
    if not assigned(aNode) then
        InsertIndex := -1
    else
    begin
        // DropTarget is an actual AudioFile
        // Determine whether we want to insert new files before or after the DropNode
        if p.y - NodeTop < (PlayListFilesVST.NodeHeight[aNode] Div 2) then
            InsertIndex := aNode.Index
        else
            InsertIndex := aNode.Index + 1;
        if InsertIndex >= self.EditorPlaylist.Count then
            InsertIndex := -1;
    end;

    MostRecentInsertNodeForPlaylist := Nil;
    if (Nemp_MainForm.DragSource = DS_EXTERN) then
    begin
        FileCount := DragQueryFile (aMsg.WParam, $FFFFFFFF, nil, 255);
        for Idx := 0 To FileCount - 1 do
        begin
            Size := DragQueryFile (aMsg.WParam, Idx, nil, 0) + 2;
            Filename := StrAlloc(Size);
            DragQueryFile(aMsg.WParam, Idx, Filename, Size);

            if (FileGetAttr(UnicodeString(Filename)) AND faDirectory = 0) then
            begin
                extension := AnsiLowerCase(ExtractFileExt(filename));
                if NempPlayer.ValidExtensions.IndexOf(extension) > -1 then
                    InsertFile(Filename, InsertIndex)
                else
                if    ((extension = '.m3u')
                    or (extension = '.m3u8')
                    OR (extension = '.pls')
                    OR (extension = '.npl')
                    OR (extension = '.asx')
                    OR (extension = '.wax'))
                    AND (FileCount = 1)
                then
                begin
                    LoadPlaylistFromFile(filename, EditorPlaylist, True, DriveManager);
                    FillPlaylistTree;
                    currentPlaylistChanged := True;
                end;
            end;
            StrDispose(Filename);
        end;
    end
    else
    begin
        for idx := 0 to Nemp_MainForm.DragDropList.Count - 1 do
            InsertFile(Nemp_MainForm.DragDropList[idx], InsertIndex);
    end;
    // Clear Drag&Drop stuff
    Nemp_MainForm.DragDropList.Clear;
    DragFinish(aMsg.WParam);
    Nemp_MainForm.DragSource := DS_EXTERN;
    RefreshPlaylistHeader;
    PlaylistFilesVST.Invalidate;
end;

procedure TPlaylistEditorForm.DragFilesSrc1Dropping(Sender: TObject);
begin
    // Note: it ssems, that this event is NEVER triggered any more ...
    // (maybe a conflict with VST Drag&Drop stuff?)
    DragDropTimer.Enabled := True;
end;
procedure TPlaylistEditorForm.DragDropTimerTimer(Sender: TObject);
begin
    DragDropTimer.Enabled := False;
    Nemp_MainForm.DragSource := DS_EXTERN;
    Nemp_MainForm.DragDropList.Clear;
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
var State: TKeyboardState;
begin
    Nemp_MainForm.DragSource := DS_INTERN;

    GetKeyboardState(State);
    if (State[VK_CONTROL] and 128) <> 0 then
        InitiateDragDrop(PlaylistFilesVST, Nemp_MainForm.DragDropList, DragFilesSrc1, 2500);
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
    if Source <> PlaylistFilesVST then
        exit;
    Effect := DROPEFFECT_MOVE;
    accept := True;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
    DragDropTimer.Enabled := True;
end;

procedure TPlaylistEditorForm.PlaylistFilesVSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var Attachmode: TVTNodeAttachMode;
    Nodes: TNodeArray;
    aNode: PVirtualNode;
    i: Integer;
begin
    // If we used Ctrl+Mouse during the start off the Drag&Drop operation, we
    // have filled DragDropList with the dragged files.
    // In that case: Do not *move* the nodes, but insert new copies of these files
    // into the target location. This will be handled by WMDropFiles.
    if (Nemp_MainForm.DragSource = DS_EXTERN) or (Nemp_MainForm.DragDropList.Count > 0) then
        exit;

    // Translate the drop position into an node attach mode.
    case Mode of
        dmAbove : AttachMode := amInsertBefore;
        dmOnNode: AttachMode := amInsertAfter;
        dmBelow : AttachMode := amInsertAfter;
    else
        AttachMode := amNowhere;
    end;

    // Get the selected Nodes
    Nodes := PlaylistFilesVST.GetSortedSelection(True);

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

    currentPlaylistChanged := True;
    Nemp_MainForm.DragSource := DS_EXTERN;
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
    Nemp_MainForm.DragSource := DS_INTERN;
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

    Nemp_MainForm.DragSource := DS_EXTERN;
    PlaylistSelectionVST.Invalidate;
end;
///  DragEnd
procedure TPlaylistEditorForm.PlaylistSelectionVSTEndDrag(Sender,
  Target: TObject; X, Y: Integer);
begin
    DragDropTimer.Enabled := True;
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
            NewFavoritePlaylistForm.edit_PlaylistDescription.Text,
            NewFavoritePlaylistForm.edit_PlaylistFilename.Text,
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
