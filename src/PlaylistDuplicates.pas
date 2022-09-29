{

    Unit PlaylistDuplicates

    - Managing Duplicates in the Nemp Playlist

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
unit PlaylistDuplicates;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections,
  NempAudioFiles, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, PlaylistClass,
  AudioDisplayUtils, RatingCtrls, TreeHelper, gnuGetText, NempHelp,
  VirtualTrees, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus;

type

  TInfoLabel = record
    LblArtist,
    LblTitle,
    LblAlbum,
    LblYear,
    LblGenre,
    lblDirectory,
    lblFilename,
    LblDuration,
    LblPlayCounter,
    LblQuality,
    LblReplayGain,
    LblPlaylistPosition: TLabel;
    ImgRating: TImage;
  end;

  TDuplicateDistance = record
    TracksBetween: Integer;
    DurationBetween: Integer;
    StreamFound: Boolean;
    Valid: Boolean;
  end;

  TEDuplicateCause = (dcNone, dcSameFile, dcSameFilename, dcSameArtistTitle);
  TEDuplicateCauses = Set of TEDuplicateCause;

  TPlaylistDuplicateCollector = class;

  TDuplicateNotifyEvent = procedure(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile) of Object;

  TDuplicate = class
    private
      fOriginalFile: TAudioFile;
      fDuplicates: TAudioFileList;

      function GetIsDuplicate: Boolean;
      function GetCount: Integer;
    public
      //property DuplicateFile: TAudioFile read fDuplicateFile write fDuplicateFile;
      property IsDuplicate: Boolean read GetIsDuplicate;
      property Count: Integer read GetCount;

      constructor Create(aOriginalFile: TAudioFile);
      destructor Destroy; override;

      procedure Add(aDuplicateFile: TAudioFile);
      procedure Remove(aDuplicateFile: TAudioFile);

      function GetDuplicateCause(aIndex: Integer): TEDuplicateCauses;
      class function CompareFiles(FileA, FileB: TAudioFile): TEDuplicateCauses;
      class function SameArtistTitle(FileA, FileB: TAudioFile): Boolean;
      class function SameFilename(FileA, FileB: TAudioFile): Boolean;

  end;

  TDuplicateList = class(TObjectList<TDuplicate>);


  TPlaylistDuplicateCollector = class
    private
      fPlaylist: TAudioFileList;
      fDuplicateFiles: TDuplicateList;
      // called to Notify the DuplicateForm to remove a file from the view
      // fOnBeforeRemoveFile: TDuplicateNotifyEvent;

      function GetCount: Integer;
      function GetDuplicateAudioFile(Index: Integer): TAudioFile;
      procedure ScanForDuplicates(aAudioFile: TAudioFile; aPlaylist: TAudioFileList); overload;
    public
      property Count: Integer read GetCount;
      property DuplicateFiles[Index: Integer]: TAudioFile read GetDuplicateAudioFile;

      //
      // property OnBeforeRemoveFile: TDuplicateNotifyEvent read fOnBeforeRemoveFile write fOnBeforeRemoveFile;

      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure RefreshScan;
      procedure ScanForDuplicates(aPlaylist: TAudioFileList); overload;
      function GetDuplicateByFile(af: TAudioFile): TDuplicate;
      procedure UnflagFiles;

      procedure Remove(aAudioFile: TAudioFile);
      function DistanceBetween(FileA, FileB: TAudioFile): TDuplicateDistance;
  end;


  TFormPlaylistDuplicates = class(TForm)
    pnlMain: TPanel;
    grpBoxDuplicates: TGroupBox;
    VstDuplicates: TVirtualStringTree;
    PopupMenu1: TPopupMenu;
    Deletethisduplicate1: TMenuItem;
    PnlDetails: TPanel;
    grpBoxDetailsPlaylist: TGroupBox;
    Bevel2: TBevel;
    ImgRatingPlaylist: TImage;
    LblAlbumPlaylist: TLabel;
    LblArtistPlaylist: TLabel;
    lblDirectoryPlaylist: TLabel;
    LblDurationPlaylist: TLabel;
    lblFilenamePlaylist: TLabel;
    LblGenrePlaylist: TLabel;
    LblPlayCounterPlaylist: TLabel;
    LblQualityPlaylist: TLabel;
    LblReplayGainPlaylist: TLabel;
    LblTitlePlaylist: TLabel;
    LblYearPlaylist: TLabel;
    Splitter1: TSplitter;
    grpBoxDetailsDuplicate: TGroupBox;
    ImgRatingDuplicate: TImage;
    LblAlbumDuplicate: TLabel;
    LblArtistDuplicate: TLabel;
    lblDirectoryDuplicate: TLabel;
    LblDurationDuplicate: TLabel;
    lblFilenameDuplicate: TLabel;
    LblGenreDuplicate: TLabel;
    LblPlayCounterDuplicate: TLabel;
    LblQualityDuplicate: TLabel;
    LblReplayGainDuplicate: TLabel;
    LblTitleDuplicate: TLabel;
    LblYearDuplicate: TLabel;
    Bevel1: TBevel;
    imgDuplicateTitle: TImage;
    imgDuplicatePath: TImage;
    Splitter2: TSplitter;
    grpBoxCompare: TGroupBox;
    PnlFooter: TPanel;
    BtnOK: TButton;
    BtnRefresh: TButton;
    lblTracksBetweenCaption: TLabel;
    lblTracksBetween: TLabel;
    lblSummaryDuplicate: TLabel;
    lblTimeBetween: TLabel;
    LblPlaylistPositionDuplicate: TLabel;
    LblPlaylistPositionPlaylist: TLabel;
    imgDuplicateInfo: TImage;
    imgDuplicateReason: TImage;
    lblDuplicateReason1: TLabel;
    lblDuplicateReason2: TLabel;
    PnlPlaylistSelect: TPanel;
    grpBoxPlaylist: TGroupBox;
    imgPlaylist: TImage;
    LblPlaylistTitle: TLabel;
    LblPlaylistTime: TLabel;
    lblPlaylistIndex: TLabel;
    btnDeleteOriginal: TButton;
    btnDeleteDuplicate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VstDuplicatesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VstDuplicatesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure Deletethisduplicate1Click(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure btnDeleteOriginalClick(Sender: TObject);
    procedure btnDeleteDuplicateClick(Sender: TObject);
    procedure VstDuplicatesColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
  private
    { Private declarations }
    RatingHelper: TRatingHelper;
    currentPlaylistRating,
    currentDuplicateRating: Byte;
    fCurrentPlaylistFile: TAudioFile;
    fCurrentDuplicateFile: TAudioFile;
    Warning1,
    Warning2: TPicture;
    fPlaylistDuplicateCollector: TPlaylistDuplicateCollector;
    fOnDeleteAudioFile: TDuplicateNotifyEvent;
    fOnDeleteOriginalAudioFile: TDuplicateNotifyEvent;
    fOnAfterLastDuplicateDeleted: TDuplicateNotifyEvent;
    fOnDuplicateDblClick: TDuplicateNotifyEvent;
    fOnAfterRefreshScan: TNotifyEvent;

    fPlaylistInfoLabel,
    fDuplicateInfoLabel: TInfoLabel;

    procedure InitGraphics;
    procedure SetCollector(aValue: TPlaylistDuplicateCollector);

    function SetInfoString(aString: String; add: String = ''): String;
    procedure ShowAudioDetails(dest: TInfoLabel; af: TAudioFile);
    procedure ShowPlaylistDetails(af: TAudioFile);
    procedure ShowDuplicateDetails(af: TAudioFile);
    procedure ShowDistanceDetails(PlaylistFile, DuplicateFile: TAudioFile);

    procedure ShowWarnings(af: TAudioFile);
    procedure FillTreeWithDuplicates(aSourceDuplicate: TDuplicate);

    // called when the user deletes an entry from the middle treeview in this form
    procedure DeleteAudioFile(af: TAudioFile);
    procedure DeleteFocussedAudioFile;

  public
    { Public declarations }

    property PlaylistDuplicateCollector: TPlaylistDuplicateCollector read fPlaylistDuplicateCollector write SetCollector;
    property OnDeleteAudioFile: TDuplicateNotifyEvent read fOnDeleteAudioFile write fOnDeleteAudioFile;
    property OnDeleteOriginalAudioFile: TDuplicateNotifyEvent read fOnDeleteOriginalAudioFile write fOnDeleteOriginalAudioFile;
    property OnAfterLastDuplicateDeleted: TDuplicateNotifyEvent read fOnAfterLastDuplicateDeleted write fOnAfterLastDuplicateDeleted;
    property OnAfterRefreshDuplicateScan: TNotifyEvent read fOnAfterRefreshScan write fOnAfterRefreshScan;
    property OnDuplicateDblClick: TDuplicateNotifyEvent read fOnDuplicateDblClick write fOnDuplicateDblClick;

    procedure RefreshStarGraphics;
    procedure RefreshAnalysisView; // after a Retranslate
    procedure ShowDuplicateAnalysis(af: TAudioFile);

    // remove an AudioFile from the Duplicate-Colelction.
    // called from the Mainform during NempPlaylist.OnBeforeDeleteAudiofile
    procedure RemoveAudioFile(aFile: TAudioFile);
    procedure Clear;

  end;

var
  FormPlaylistDuplicates: TFormPlaylistDuplicates;

implementation

uses NempMainUnit, MainFormHelper, math;

{$R *.dfm}


{ TDuplicate }

constructor TDuplicate.Create(aOriginalFile: TAudioFile);
begin
  inherited create;
  fOriginalFile := aOriginalFile;
  fDuplicates := TAudioFileList.Create(False);
end;

destructor TDuplicate.Destroy;
begin
  fDuplicates.Free;
  inherited;
end;

procedure TDuplicate.Add(aDuplicateFile: TAudioFile);
begin
  fDuplicates.Add(aDuplicateFile);
end;

procedure TDuplicate.Remove(aDuplicateFile: TAudioFile);
begin
  fDuplicates.Remove(aDuplicateFile);
  if fDuplicates.Count = 0 then
    fOriginalFile.UnSetFlag(FLAG_DUPLICATEGENERAL);
end;

function TDuplicate.GetCount: Integer;
begin
  result := fDuplicates.Count;
end;

function TDuplicate.GetDuplicateCause(aIndex: Integer): TEDuplicateCauses;
begin
  if (aIndex >= 0) and (aIndex < fDuplicates.Count) then
    result := CompareFiles(fOriginalFile, fDuplicates[aIndex])
  else
    result := [];
end;

function TDuplicate.GetIsDuplicate: Boolean;
begin
  result := fDuplicates.Count > 0;
end;

class function TDuplicate.SameArtistTitle(FileA, FileB: TAudioFile): Boolean;
begin
  result := AnsiSameText(FileA.Artist, FileB.Artist) and AnsiSameText(FileA.Titel, FileB.Titel)
    and (FileA.Artist <> '') and (FileA.Titel <> '');

end;

class function TDuplicate.SameFilename(FileA, FileB: TAudioFile): Boolean;
begin
  result := AnsiSameText(FileA.Dateiname, FileB.Dateiname);
end;

// (dcNone, dcSameFile, dcSameFilename, dcSameArtistTitle);
class function TDuplicate.CompareFiles(FileA, FileB: TAudioFile): TEDuplicateCauses;
begin
  result := [];
  if FileA.Pfad = FileB.Pfad then
    result := result + [dcSameFile];
  if SameFilename(FileA, FileB) then
    result := result + [dcSameFilename];
  if SameArtistTitle(FileA, FileB) then //(FileA.Artist = FileB.Artist) and (FileA.Titel = FileB.Titel) then
    result := result + [dcSameArtistTitle];
end;





{ TPlaylistDuplicates }

constructor TPlaylistDuplicateCollector.Create;
begin
  inherited create;
  fDuplicateFiles := TDuplicateList.Create(True);
end;

destructor TPlaylistDuplicateCollector.Destroy;
begin
  fDuplicateFiles.Free;
  inherited;
end;

procedure TPlaylistDuplicateCollector.Clear;
begin
  fDuplicateFiles.clear;
end;

function TPlaylistDuplicateCollector.GetCount: Integer;
begin
  result := fDuplicateFiles.Count;
end;

procedure TPlaylistDuplicateCollector.ScanForDuplicates(aAudioFile: TAudioFile;
  aPlaylist: TAudioFileList);
var
  i: Integer;
  newDuplicate: TDuplicate;
  DuplicateCauses: TEDuplicateCauses;
  flags: Integer;
begin
    newDuplicate := TDuplicate.Create(aAudioFile);
    try
      flags := 0;

      for i := 0 to aPlaylist.Count - 1 do
      begin
        if (aPlaylist[i] <> aAudioFile) then
        begin // not the exact same entry in the Playlist
          DuplicateCauses := newDuplicate.CompareFiles(aPlaylist[i], aAudioFile);

          if DuplicateCauses <> [] then
          begin

            // dcSameFile, dcSameFilename, dcSameArtistTitle
            if dcSameFile in DuplicateCauses then
              flags := flags or FLAG_EXACTDUPLICATE;
            if (dcSameFilename in DuplicateCauses) or (dcSameArtistTitle in DuplicateCauses) then
              flags := flags or FLAG_DUPLICATE;

            newDuplicate.Add(aPlaylist[i]);
          end;
        end;
      end;

      if newDuplicate.IsDuplicate then
      begin
        aAudioFile.SetFlag(flags);
        fDuplicateFiles.Add(newDuplicate);
      end;

    finally
      if not newDuplicate.IsDuplicate then
        newDuplicate.Free;
    end;
end;

procedure TPlaylistDuplicateCollector.ScanForDuplicates(aPlaylist: TAudioFileList);
var
  i: Integer;
begin
  Clear;
  fPlaylist := aPlaylist;
  // runtime: O(n^2)
  for i := 0 to aPlaylist.Count - 1 do
    ScanForDuplicates(aPlaylist[i], aPlaylist);
end;

procedure TPlaylistDuplicateCollector.RefreshScan;
var
  i: Integer;
begin
  Clear;
  // runtime: O(n^2)
  if assigned(fPlaylist) then
    for i := 0 to fPlaylist.Count - 1 do
      ScanForDuplicates(fPlaylist[i], fPlaylist);
end;


procedure TPlaylistDuplicateCollector.UnflagFiles;
var
  i: Integer;
begin
  for i := 0 to fDuplicateFiles.Count - 1 do
    fDuplicateFiles[i].fOriginalFile.UnSetFlag(FLAG_DUPLICATEGENERAL);
end;

function TPlaylistDuplicateCollector.GetDuplicateAudioFile(
  Index: Integer): TAudioFile;
begin
  if (Index >= 0) and (Index <= fDuplicateFiles.Count - 1) then
  begin
    result := fDuplicateFiles[Index].fOriginalFile;
  end else
    result := Nil;
end;

function TPlaylistDuplicateCollector.GetDuplicateByFile(af: TAudioFile): TDuplicate;
var
  i: Integer;
begin
  result := Nil;
  for i := 0 to self.fDuplicateFiles.Count - 1 do
  begin
    if self.fDuplicateFiles[i].fOriginalFile = af then
    begin
      result := fDuplicateFiles[i];
      break;
    end;
  end;
end;

// This method is called, when a File is removed from the NempPlaylist.
// in that case, ALL occurences of "aAudioFile" must be removed
procedure TPlaylistDuplicateCollector.Remove(aAudioFile: TAudioFile);
var i: Integer;
begin
  // 1.) Remove aAudioFile from all Duplicate-Lists
  // If DuplicateCount is down to zero, the Originalfile will be flagged as "NoDuplicate" again
  for i := 0 to fDuplicateFiles.Count - 1 do
    fDuplicateFiles[i].Remove(aAudioFile);

  // 2.) Remove Objects from fDuplicateFiles, where OriginalFile=aAudioFile (or the list is now empty)
  for i := fDuplicateFiles.Count - 1 downto 0 do
  begin
    if (fDuplicateFiles[i].fOriginalFile = aAudioFile) or (fDuplicateFiles[i].Count = 0) then
      fDuplicateFiles.Delete(i);
  end;
end;

function TPlaylistDuplicateCollector.DistanceBetween(FileA, FileB: TAudioFile): TDuplicateDistance;
var
  FileAIdx, FileBIdx, i: Integer;
  iFile: TAudioFile;
begin
  FileAIdx  := fPlaylist.IndexOf(FileA);
  FileBIdx := fPlaylist.IndexOf(FileB);

  result.TracksBetween := 0;
  result.DurationBetween := 0;
  result.StreamFound := False;
  result.Valid := False;

  if (FileAIdx >= 0) and (FileBIdx >= 0)  then
  begin
    result.Valid := True;
    result.TracksBetween := abs(FileBIdx - FileAIdx) - 1;
    for i := min(FileAIdx, FileBIdx)+1 to max(FileAIdx, FileBIdx)-1 do
    begin
      iFile := fPlaylist[i];
      if not iFile.isStream then
        result.DurationBetween := result.DurationBetween + iFile.Duration
      else
        result.StreamFound := True;
    end;
  end;
end;

{ TFormPlaylistDuplicates }


procedure TFormPlaylistDuplicates.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  HelpContext := HELP_CleanupPlaylist;

  with fPlaylistInfoLabel do
  begin
    LblArtist      := LblArtistPlaylist;
    LblTitle       := LblTitlePlaylist;
    LblAlbum       := LblAlbumPlaylist;
    LblYear        := LblYearPlaylist;
    LblGenre       := LblGenrePlaylist;
    lblDirectory   := lblDirectoryPlaylist;
    lblFilename    := lblFilenamePlaylist;
    LblDuration    := LblDurationPlaylist;
    LblPlayCounter := LblPlayCounterPlaylist;
    LblQuality     := LblQualityPlaylist;
    LblReplayGain  := LblReplayGainPlaylist;
    LblPlaylistPosition := LblPlaylistPositionPlaylist;
    ImgRating      := ImgRatingPlaylist;
  end;

  with fDuplicateInfoLabel do
  begin
    LblArtist      := LblArtistDuplicate;
    LblTitle       := LblTitleDuplicate;
    LblAlbum       := LblAlbumDuplicate;
    LblYear        := LblYearDuplicate;
    LblGenre       := LblGenreDuplicate;
    lblDirectory   := lblDirectoryDuplicate;
    lblFilename    := lblFilenameDuplicate;
    LblDuration    := LblDurationDuplicate;
    LblPlayCounter := LblPlayCounterDuplicate;
    LblQuality     := LblQualityDuplicate;
    LblReplayGain  := LblReplayGainDuplicate;
    LblPlaylistPosition := LblPlaylistPositionDuplicate;
    ImgRating      := ImgRatingDuplicate;
  end;

  RatingHelper := TRatingHelper.Create;
  LoadStarGraphics(RatingHelper);
  Warning1 := TPicture.Create;
  Warning2 := TPicture.Create;
  InitGraphics;

  VstDuplicates.NodeDataSize := SizeOf(TAudioFile);
  fPlaylistDuplicateCollector := Nil;
  fCurrentPlaylistFile := Nil;
  fCurrentDuplicateFile := Nil;
end;

procedure TFormPlaylistDuplicates.FormDestroy(Sender: TObject);
begin
  RatingHelper.Free;
  Warning1.Free;
  Warning2.Free;
end;

procedure TFormPlaylistDuplicates.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin

  fPlaylistDuplicateCollector.UnflagFiles;
  fPlaylistDuplicateCollector.Free;
  fPlaylistDuplicateCollector := Nil;
  fCurrentPlaylistFile := Nil;
  fCurrentDuplicateFile := Nil;
end;

procedure TFormPlaylistDuplicates.InitGraphics;
var
  basePath, filename: String;
begin
  basePath := ExtractFilePath(ParamStr(0));

  filename := basePath + 'Images\duplicate1.png';
  if FileExists(filename) then
    Warning1.LoadFromFile(filename);

  filename := basePath + 'Images\duplicate2.png';
  if FileExists(filename) then
    Warning2.LoadFromFile(filename);

  filename := basePath + 'Images\DuplicateInfo.png';
  if FileExists(filename) then
    imgDuplicateInfo.Picture.LoadFromFile(filename);

  filename := basePath + 'Images\NempLogo_b.png';
  if FileExists(filename) then
    imgPlaylist.Picture.LoadFromFile(filename);
end;

procedure TFormPlaylistDuplicates.VstDuplicatesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  aNode: PVirtualNode;
  AudioFile: TAudioFile;
begin
  aNode := VSTDuplicates.FocusedNode;
  if not Assigned(aNode) then Exit;

  AudioFile := VSTDuplicates.GetNodeData<TAudioFile>(aNode);
  ShowDuplicateDetails(AudioFile);
  ShowDistanceDetails(fCurrentPlaylistFile, AudioFile);
  ShowWarnings(AudioFile);
end;

procedure TFormPlaylistDuplicates.VstDuplicatesColumnDblClick(
  Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
var
  clickedFile: TAudioFile;
  clickedNode: PVirtualNode;
begin
  clickedNode := VSTDuplicates.FocusedNode;
  if assigned(clickedNode) then
  begin
    clickedFile := VSTDuplicates.GetNodeData<TAudioFile>(clickedNode);
    if assigned(OnDuplicateDblClick) then
      OnDuplicateDblClick(PlaylistDuplicateCollector, clickedFile);
  end;
end;

procedure TFormPlaylistDuplicates.VstDuplicatesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if not assigned(af) then exit;

  case Column of
    0: CellText := IntToStr(PlaylistDuplicateCollector.fPlaylist.IndexOf(af)+1);
    1: CellText := NempDisplay.PlaylistTitle(af);
    2: CellText := NempDisplay.TreeDuration(af)
  end;
end;

procedure TFormPlaylistDuplicates.RefreshStarGraphics;
begin
  LoadStarGraphics(RatingHelper);

  if IMGRatingPlaylist.Visible then
    RatingHelper.DrawRatingInStarsOnBitmap(currentPlaylistRating, IMGRatingPlaylist.Picture.Bitmap, IMGRatingPlaylist.Width, IMGRatingPlaylist.Height);
  if IMGRatingDuplicate.Visible then
    RatingHelper.DrawRatingInStarsOnBitmap(currentDuplicateRating, IMGRatingDuplicate.Picture.Bitmap, IMGRatingDuplicate.Width, IMGRatingDuplicate.Height);
end;



procedure TFormPlaylistDuplicates.FillTreeWithDuplicates(
  aSourceDuplicate: TDuplicate);
var
  i: Integer;
  firstNode: PVirtualNode;
begin
  VstDuplicates.BeginUpdate;
  VstDuplicates.Clear;

  if assigned(aSourceDuplicate) then
  begin
    for i := 0 to aSourceDuplicate.fDuplicates.Count-1 do
      VstDuplicates.AddChild(Nil, aSourceDuplicate.fDuplicates[i]);
  end;

  firstNode := VstDuplicates.GetFirst;
  if assigned(firstNode) then
  begin
    VSTDuplicates.Selected[firstNode] := True;
    VSTDuplicates.FocusedNode := firstNode;
  end;

  VstDuplicates.EndUpdate;
end;

procedure TFormPlaylistDuplicates.RefreshAnalysisView;
begin
  ShowPlaylistDetails(fCurrentPlaylistFile);
  ShowDuplicateDetails(fCurrentDuplicateFile);
  ShowDistanceDetails(fCurrentPlaylistFile, fCurrentDuplicateFile);
  ShowWarnings(fCurrentDuplicateFile);
end;

procedure TFormPlaylistDuplicates.ShowDuplicateAnalysis(af: TAudioFile);
var
  aDuplicate: TDuplicate;
begin
  ShowPlaylistDetails(af);
  aDuplicate := PlaylistDuplicateCollector.GetDuplicateByFile(af);
  FillTreeWithDuplicates(aDuplicate);
  if assigned(aDuplicate) then
  begin
    ShowDuplicateDetails(aDuplicate.fDuplicates[0]);
    ShowDistanceDetails(af, aDuplicate.fDuplicates[0]);
    ShowWarnings(aDuplicate.fDuplicates[0]);
  end else
  begin
    // Clear Duplicate details
    ShowDuplicateDetails(Nil);
    ShowDistanceDetails(Nil, Nil);
    ShowWarnings(Nil);
  end;
end;

procedure TFormPlaylistDuplicates.SetCollector(aValue: TPlaylistDuplicateCollector);
begin
  if assigned(fPlaylistDuplicateCollector) then
    fPlaylistDuplicateCollector.Free;

  fPlaylistDuplicateCollector := aValue;
end;


function TFormPlaylistDuplicates.SetInfoString(aString, add: String): String;
begin
  if Trim(aString) = '' then
    result := add + ' N/A'
  else
    result := aString;
end;


procedure TFormPlaylistDuplicates.Deletethisduplicate1Click(Sender: TObject);
begin
  DeleteFocussedAudioFile;
end;

procedure TFormPlaylistDuplicates.DeleteFocussedAudioFile;
var
  aNode, NewSelectNode: PVirtualNode;
begin
  aNode := VSTDuplicates.FocusedNode;
  if not Assigned(aNode) then
    exit;

  // determin the next node that should be selected
  NewSelectNode := VSTDuplicates.GetNextSibling(aNode);
  if not Assigned(NewSelectNode) then
    NewSelectNode := VSTDuplicates.GetPreviousSibling(aNode);

  // Delete the selected file from the playlist
  // (and from this view, which is triggered during deleting)
  if Assigned(aNode) then
    DeleteAudioFile(VSTDuplicates.GetNodeData<TAudioFile>(aNode));

  // refresh GUI, select next Node in the list of duplicates (if available)
  if assigned(NewSelectNode) then
  begin
    if assigned(NewSelectNode) then
    begin
      VSTDuplicates.Selected[NewSelectNode] := True;
      VSTDuplicates.FocusedNode := NewSelectNode;
    end;
    VstDuplicatesChange(VSTDuplicates, Nil);
  end else
  begin
    // NempPlayist/MainWindow should select the next available duplicate
    if assigned(fOnAfterLastDuplicateDeleted) then
      fOnAfterLastDuplicateDeleted(fPlaylistDuplicateCollector, fCurrentPlaylistFile);
  end;
end;


// called when deleting a file from the treeview here.
// In that case, the file should be deleted from the playlist, which is handled
// by the MainForm and the NempPlaylist
// During that, TFormPlaylistDuplicates.RemoveAudioFile() will also be called
procedure TFormPlaylistDuplicates.DeleteAudioFile(af: TAudioFile);
begin
  if assigned(fOnDeleteAudioFile) then
    fOnDeleteAudioFile(fPlaylistDuplicateCollector, af);
end;


// Called from the Mainform to remove all references of an AudioFile in this form
// (and in the data structure, of course)
procedure TFormPlaylistDuplicates.RemoveAudioFile(aFile: TAudioFile);
var
  aNode: PVirtualNode;
begin
  // clear the reference to fCurrentPlaylistFile, if needed
  if aFile = fCurrentPlaylistFile then
    fCurrentPlaylistFile := Nil;
  if aFile = fCurrentDuplicateFile then
    fCurrentDuplicateFile := Nil;

  // remove the file from the TreeView
  aNode := GetNodeWithAudioFile(VSTDuplicates, aFile);
  if assigned(aNode) then
    VSTDuplicates.DeleteNode(aNode);

  // remove the file from the DuplicateCollector
  fPlaylistDuplicateCollector.Remove(aFile);

  VSTDuplicates.Invalidate;
end;

procedure TFormPlaylistDuplicates.btnDeleteDuplicateClick(Sender: TObject);
begin
  DeleteFocussedAudioFile;
end;

procedure TFormPlaylistDuplicates.btnDeleteOriginalClick(Sender: TObject);
begin
  if assigned(OnDeleteOriginalAudioFile) then
    OnDeleteOriginalAudioFile(fPlaylistDuplicateCollector, fCurrentPlaylistFile);
end;

procedure TFormPlaylistDuplicates.BtnOKClick(Sender: TObject);
begin
  close;
end;

procedure TFormPlaylistDuplicates.BtnRefreshClick(Sender: TObject);
begin
  fPlaylistDuplicateCollector.RefreshScan;
  if assigned(OnAfterRefreshDuplicateScan) then
    OnAfterRefreshDuplicateScan(fPlaylistDuplicateCollector);
end;

procedure TFormPlaylistDuplicates.Clear;
begin
  fCurrentPlaylistFile := Nil;
  fCurrentDuplicateFile := Nil;
  fPlaylistDuplicateCollector.Clear;
  ShowDuplicateAnalysis(Nil);
end;



procedure TFormPlaylistDuplicates.ShowAudioDetails(dest: TInfoLabel; af: TAudioFile);
var
  afIsNotNil: Boolean;
begin
  afIsNotNil := assigned(af);

  dest.LblArtist      .Visible := afIsNotNil;
  dest.LblTitle       .Visible := afIsNotNil;
  dest.LblAlbum       .Visible := afIsNotNil;
  dest.LblYear        .Visible := afIsNotNil;
  dest.LblGenre       .Visible := afIsNotNil;
  dest.lblDirectory   .Visible := afIsNotNil;
  dest.lblFilename    .Visible := afIsNotNil;
  dest.LblDuration    .Visible := afIsNotNil;
  dest.LblPlayCounter .Visible := afIsNotNil;
  dest.LblQuality     .Visible := afIsNotNil;
  dest.LblReplayGain  .Visible := afIsNotNil;
  dest.LblPlaylistPosition.Visible := afIsNotNil;
  dest.ImgRating      .Visible := afIsNotNil;

  if not afIsNotNil then
    exit;

  dest.LblPlaylistPosition.Caption :=
    Format(PlaylistDuplicates_PositionInPlaylist, [PlaylistDuplicateCollector.fPlaylist.IndexOf(af)+1]);

  case af.AudioType of

      at_Undef  : dest.LblArtist.Caption := 'ERROR: UNDEFINED AUDIOTYPE'; // should never happen
      at_Cue,
      at_File,
      at_CDDA : begin
          dest.LblArtist .Caption := NempDisplay.SummaryArtist(af);
          dest.LblTitle  .Caption := NempDisplay.SummaryTitle(af);
          dest.LblAlbum .Caption  := NempDisplay.SummaryAlbum(af);
          dest.LblYear .Caption   := NempDisplay.SummaryYear(af);
          dest.LblGenre .Caption  := NempDisplay.SummaryGenre(af);
          dest.lblFilename .Caption  := af.Dateiname;
          dest.lblDirectory .Caption := af.Ordner;
      end;
      at_Stream : begin
          dest.LblArtist .Caption := SetInfoString(af.Description, AudioFileProperty_Name);
          dest.LblTitle  .Caption := SetInfoString(af.Titel, AudioFileProperty_Title);
          dest.LblAlbum  .Caption := SetInfoString(af.Ordner, AudioFileProperty_URL);
          dest.LblYear   .Caption := NempDisplay.SummaryBitrate(af);
          dest.LblGenre  .Caption := NempDisplay.SummaryGenre(af);
          dest.lblFilename .Caption := '';
          dest.lblDirectory .Caption := '';
      end;
  end;

  case af.AudioType of
      at_File: begin
          dest.ImgRating .Visible := True;
          dest.LblDuration    .Caption := NempDisplay.SummaryDurationSize(af);
          dest.LblQuality     .Caption := NempDisplay.SummaryQuality(af);
          dest.LblPlayCounter .Caption := NempDisplay.SummaryPlayCounter(af);
          dest.LblReplayGain  .Caption := NempDisplay.SummaryReplayGain(af);

          RatingHelper.DrawRatingInStarsOnBitmap(af.Rating, dest.ImgRating.Picture.Bitmap, dest.ImgRating.Width, dest.ImgRating.Height);
      end;

      at_Cue: begin
            dest.ImgRating .Visible := False;
            dest.LblDuration   .Caption := NempDisplay.SummaryDurationSizeCue(af, af);
            dest.LblQuality    .Caption := NempDisplay.SummaryQuality(af);
            dest.LblReplayGain .Caption := NempDisplay.SummaryReplayGain(af);
            dest.LblPlayCounter .Caption := '';
            // BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
      end;

      at_Stream: begin
          dest.ImgRating .Visible := False;
          dest.LblDuration   .Caption := '';
          dest.LblPlayCounter .Caption := '';
          dest.LblQuality .Caption := '';
          dest.LblReplayGain .Caption := '';
      end;

      at_CDDA: begin
          dest.ImgRating .Visible := False;
          dest.LblDuration   .Caption := NempDisplay.SummaryDuration(af) ;
          dest.LblQuality .Caption := 'CD-Audio';
          dest.LblPlayCounter .Caption := '';
          dest.LblReplayGain .Caption := '';
      end;
  end;

end;

procedure TFormPlaylistDuplicates.ShowPlaylistDetails(af: TAudioFile);
begin
  fCurrentPlaylistFile := af;
  if assigned(af) then begin
    currentPlaylistRating := af.Rating;
    lblPlaylistIndex.Caption := IntToStr(PlaylistDuplicateCollector.fPlaylist.IndexOf(af) + 1);
    LblPlaylistTitle.Caption := NempDisplay.PlaylistTitle(af);
    LblPlaylistTime.Caption := NempDisplay.TreeDuration(af);
  end
  else
  begin
    currentPlaylistRating := 0;
    lblPlaylistIndex.Caption := '';
    LblPlaylistTitle.Caption := PlaylistDuplicates_NoFileSelected;
    LblPlaylistTime.Caption := '0:00';
  end;

  ShowAudioDetails(fPlaylistInfoLabel, af);
end;

procedure TFormPlaylistDuplicates.ShowDuplicateDetails(af: TAudioFile);
begin
  fCurrentDuplicateFile := af;
  if assigned(af) then
    currentDuplicateRating := af.Rating
  else
    currentDuplicateRating := 0;

  ShowAudioDetails(fDuplicateInfoLabel, af);
end;

procedure TFormPlaylistDuplicates.ShowDistanceDetails(PlaylistFile, DuplicateFile: TAudioFile);
var
  DistanceData: TDuplicateDistance;
  timeStr: String;
begin
  if (not assigned(PlaylistFile)) or (not assigned(DuplicateFile)) then
  begin
    lblTracksBetweenCaption.Caption := PlaylistDuplicates_NoDuplicateInformation;
    lblTracksBetween.Visible := False;
    lblTimeBetween.Visible := False;
    imgDuplicateInfo.Visible := False;
    exit;
  end;

  lblTracksBetweenCaption.Caption := PlaylistDuplicates_BetweenTracksCaption;

  DistanceData := fPlaylistDuplicateCollector.DistanceBetween(PlaylistFile, DuplicateFile);
  timeStr := Format(rsFormatSummaryDuration, [DistanceData.DurationBetween Div 60, DistanceData.DurationBetween mod 60]);

  lblTracksBetween.Visible := True;
  imgDuplicateInfo.Visible := True;
  if DistanceData.TracksBetween > 0 then
    lblTracksBetween.Caption := Format(PlaylistDuplicates_TracksBetween, [DistanceData.TracksBetween])
  else
    lblTracksBetween.Caption := PlaylistDuplicates_TracksBetweenZero;

  if DistanceData.DurationBetween = 0 then
  begin
    lblTimeBetween.Visible := DistanceData.TracksBetween > 0;
    lblTimeBetween.Caption := PlaylistDuplicates_TimeBetweenOnlyStream; // or: No title at all, but in that case, it's invisible
  end else
  begin
    lblTimeBetween.Visible := True;
    if DistanceData.StreamFound then
      lblTimeBetween.Caption := Format(PlaylistDuplicates_TimeBetweenStream, [timeStr])
    else
      lblTimeBetween.Caption := Format(PlaylistDuplicates_TimeBetween, [timeStr]);
  end;

  {
  PlaylistDuplicates_TimeBetween = '%s between these two tracks.';
  PlaylistDuplicates_TimeBetweenStream = 'At least %s between these two tracks (contains webstream).';
  PlaylistDuplicates_TimeBetweenOnlyStream = 'Unknown play time between these tracks (only webstream).';
  }


  {
  PlaylistDuplicates_TrackAfterOriginal  = 'The selected duplicate comes %d tracks after the original track.';
PlaylistDuplicates_TrackBeforeOriginal = 'The selected duplicate comes %d tracks before the original track.';

PlaylistDuplicates_TimeBetween = '%s between these two tracks.';
PlaylistDuplicates_TimeBetweenStream = 'At least %s between these tracks, but there is also a webstream.';
PlaylistDuplicates_TimeBetweenOnlyStream = 'Unknown play time between these tracks (only webstream)';
  }

  {
  TracksBetween: Integer;
    DurationBetween: Integer;
    StreamFound: Boolean;
    Valid: Boolean;

  }

  {PlaylistIdx  := fPlaylistDuplicateCollector.fPlaylist.IndexOf(PlaylistFile);
  DuplicateIdx := fPlaylistDuplicateCollector.fPlaylist.IndexOf(DuplicateFile);

  if (PlaylistIdx >= 0) and (DuplicateIdx >= 0)  then
  begin
    streamFound := False;
    DurationBetween := 0;

    for i := min(PlaylistIdx, DuplicateIdx) to max(PlaylistIdx, DuplicateIdx)-1 do
    begin
      iFile := fPlaylistDuplicateCollector.fPlaylist[i];
      if not iFile.isStream then
        DurationBetween := DurationBetween + iFile.Duration
      else
        streamFound := True;
    end;
  end else
  begin
    // mindestens ein File ist nicht (mehr) in der Playlist (sollte nicht vorkommen)
  end;
   }
end;



procedure TFormPlaylistDuplicates.ShowWarnings(af: TAudioFile);
var
  rCount: Integer;
begin
  if (not assigned(af)) or
     (not assigned(fCurrentPlaylistFile)) then
  begin
    imgDuplicateTitle.Visible := False;
    imgDuplicatePath.Visible := False;

    lblDuplicateReason1.Visible := False;
    lblDuplicateReason2.Visible := False;
    imgDuplicateReason.Visible := False;
    lblSummaryDuplicate.Visible := False;
    exit;
  end;

  lblDuplicateReason1.Visible := True;
  imgDuplicateReason.Visible := True;
  lblSummaryDuplicate.Visible := True;
  if (fCurrentPlaylistFile.Pfad = af.Pfad)  and (fCurrentPlaylistFile.Pfad = af.Pfad) then
  begin
    lblDuplicateReason2.Visible := False;
    lblDuplicateReason1.Caption := PlaylistDuplicates_WarningPath;
    imgDuplicateReason.Picture.Assign(Warning2);
  end else
  begin
    imgDuplicateReason.Picture.Assign(Warning1);
    rCount := 0;
    if TDuplicate.SameArtistTitle(fCurrentPlaylistFile, af) then //  (fCurrentPlaylistFile.Artist = af.Artist)  and (fCurrentPlaylistFile.Titel = af.Titel) then
    begin
      inc(rCount);
      lblDuplicateReason1.Caption := PlaylistDuplicates_WarningArtistTitle;
    end;

    if TDuplicate.SameFilename(fCurrentPlaylistFile, af) then
    // (fCurrentPlaylistFile.Dateiname = af.Dateiname)  and (fCurrentPlaylistFile.Dateiname = af.Dateiname) then
    begin
      if rCount = 1 then
      begin
          lblDuplicateReason2.Visible := True;
          lblDuplicateReason2.Caption := PlaylistDuplicates_WarningFilename;
      end else
      begin
        lblDuplicateReason1.Caption := PlaylistDuplicates_WarningFilename;
        lblDuplicateReason2.Visible := False;
      end;
    end else
      lblDuplicateReason2.Visible := False;
  end;

  {

  if (fCurrentPlaylistFile.Artist = af.Artist)  and (fCurrentPlaylistFile.Titel = af.Titel) then
  begin
    LblArtistDuplicate.Left := 32;
    LblTitleDuplicate.Left := 32;
    imgDuplicateTitle.Hint := PlaylistDuplicates_WarningArtistTitle;
    imgDuplicateTitle.Visible := True;
    imgDuplicateTitle.Picture.Assign(Warning1);
  end else
  begin
    imgDuplicateTitle.Visible := False;
    LblArtistDuplicate.Left := 16;
    LblTitleDuplicate.Left := 16;
  end;

  if (fCurrentPlaylistFile.Pfad = af.Pfad)  and (fCurrentPlaylistFile.Pfad = af.Pfad) then
  begin
    imgDuplicatePath.Top := 48 + 8;
    imgDuplicatePath.Visible := True;
    imgDuplicatePath.Picture.Assign(Warning2);
    imgDuplicatePath.Hint := PlaylistDuplicates_WarningPath;
    LblDirectoryDuplicate.Left := 32;
    LblFilenameDuplicate.Left := 32;
  end else
  if (fCurrentPlaylistFile.Dateiname = af.Dateiname)  and (fCurrentPlaylistFile.Dateiname = af.Dateiname) then
  begin
    imgDuplicatePath.Top := 48;
    imgDuplicatePath.Visible := True;
    imgDuplicatePath.Picture.Assign(Warning1);
    imgDuplicatePath.Hint := PlaylistDuplicates_WarningFilename;
    LblDirectoryDuplicate.Left := 16;
    LblFilenameDuplicate.Left := 32;
  end else
  begin
    imgDuplicatePath.Visible := False;
    LblDirectoryDuplicate.Left := 16;
    LblFilenameDuplicate.Left := 16;
  end;
  }
end;





end.
