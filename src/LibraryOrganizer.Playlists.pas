unit LibraryOrganizer.Playlists;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils,DriveRepairTools,
  NempAudioFiles, NempFileUtils, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, LibraryOrganizer.Base;

const
  MAX_CACHED_PLAYLISTS = 50;

type

  TLibraryPlaylistCategory = class;

  // A TAudioPlaylistCollection is defined by a Playlistfile (e.g. "myPlaylist.m3u")
  TAudioPlaylistCollection = class(TAudioCollection)
    private
      // temporary AudioFiles, loaded from a PlaylistFile to display them
      fPlaylistFiles: TAudioFileList;
      fFileName: String;
      fFolder: String;
      fName: String;
      fCaptionMode: tePlaylistCaptionMode;
      fLibraryPlaylist: TLibraryPlaylist;
    protected
      function GetCaption: String; override;
      function GetSimpleCaption: String; override;
      function GetCoverID: String; override;  // = ''
      function GetCollection(Index: Integer): TAudioCollection; override; // = Nil
      function GetCollectionCount: Integer; override; // = 0
    public
      property LibraryPlaylist: TLibraryPlaylist read fLibraryPlaylist;

      constructor Create(aOwner: TLibraryCategory; aPlaylist: TLibraryPlaylist); //Create(aPlaylistFile: String);
      destructor Destroy; override;
      procedure Clear; override;
      procedure RemoveEmptyCollections; override;

      procedure DoGetFiles(dest: TAudioFileList; recursive: Boolean); override;
      procedure DoChangeCoverIDAfterDownload(newID: String); override; // empty

      function MatchPrefix(aPrefix: String): Boolean; override;
      function ComparePrefix(aPrefix: String): Integer; override;
      function IndexOf(aCollection: TAudioCollection): Integer; override;

      procedure Analyse(recursiv, ForceAnalysise: Boolean); override; // empty
      procedure Sort(doRecursive: Boolean = True); override; // empty
      procedure ReSort(newSorting: teCollectionSorting; newDirection: teSortDirection); override; // empty
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); override; // empty

      function ChangeDriveChar(newChar: Char): Boolean;

  end;

  TLibraryPlaylistCategory = class(TLibraryCategory)
    private
      fLoadedPlaylistCounter: Integer;
      fDriveManager: TDriveManager;
      fSortDirection: teSortDirection;
      fSortOrder: tePlaylistCollectionSorting;
      procedure NotifyLoading;
    protected
      function GetItemCount: Integer; override;
      function GetCaption: String; override;
      function Compare(const item1,item2: TAudioPlaylistCollection): Integer;

    public
      property DriveManager: TDriveManager read fDriveManager write fDriveManager;

      constructor Create;
      destructor Destroy; override;
      procedure Clear; override;
      procedure AddPlaylist(aPlaylistFile: TLibraryPlaylist);
      procedure RemovePlaylist(aPlaylistFile: TLibraryPlaylist);
      // sort the List of fCollections
      procedure Sort(newSortOrder: tePlaylistCollectionSorting; newSortDirection: teSortDirection);

      procedure RememberLastCollection(aCollection: TAudioCollection); override;
      function FindLastCollectionAgain: TAudioCollection; override;

      procedure RepairDriveChars(DriveManager: TDriveManager); override;

  end;


implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper, gnugettext;



{ TAudioPlaylistCollection }
constructor TAudioPlaylistCollection.Create(aOwner: TLibraryCategory; aPlaylist: TLibraryPlaylist);
begin
  inherited create(aOwner);
  fCollectionClass := ccPlaylists;
  fKey := aPlaylist.Path;
  fFileName := ExtractFilename(fKey);
  fFolder :=  ExtractFileName(ExtractFileDir(fKey));
  fName := aPlaylist.Name;
  fLibraryPlaylist := aPlaylist;
  fCount := 1;

  fPlaylistFiles := TAudioFileList.Create(True);
end;

destructor TAudioPlaylistCollection.Destroy;
begin
  fPlaylistFiles.Free;
  inherited;
end;

procedure TAudioPlaylistCollection.Clear;
begin
  fPlaylistFiles.Clear;
end;

function TAudioPlaylistCollection.GetCaption: String;
begin
  // Frage: hier ggf. nach CollectionType (muss noch eingeführt werden) unterscheiden?
  // z.B. Playlist, die man so in der Bib hat im Modus "Folder"
  // aber einen Ordner mit selbstgemachten Playlists im Modus "Filename"
  if fName <> '' then
    result := fName
  else
  begin
    case NempOrganizerSettings.PlaylistCaptionMode of
      pcmFilename: result := fFileName; //ExtractFileName(fKey);
      pcmFolder: result := fFolder; //ExtractFileName(ExtractFileDir(fKey)); // + '\' + ExtractFileName(fKey);
      pcmFolderFilename: result := ExtractFileName(ExtractFileDir(fKey)) + '\' + ExtractFileName(fKey);
      pcmPath: result := fKey;
    end;
  end;
end;

function TAudioPlaylistCollection.GetSimpleCaption: String;
begin
  result := GetCaption;
end;

function TAudioPlaylistCollection.IndexOf(
  aCollection: TAudioCollection): Integer;
begin
  result := -1;
end;

function TAudioPlaylistCollection.GetCoverID: String;
begin
  result := '';
end;

function TAudioPlaylistCollection.GetCollection(
  Index: Integer): TAudioCollection;
begin
  result := Nil;
end;

function TAudioPlaylistCollection.MatchPrefix(aPrefix: String): Boolean;
begin
  result := AnsiContainsText(fKey, aPrefix); // or: only fFileName?
end;

function TAudioPlaylistCollection.ComparePrefix(aPrefix: String): Integer;
begin
  if MatchPrefix(aPrefix) then
    result := 0
  else
    result := 1; // or 1, doesn't matter
end;

function TAudioPlaylistCollection.GetCollectionCount: Integer;
begin
  result := 0; // there are no subCollections here
end;

procedure TAudioPlaylistCollection.Analyse(recursiv, ForceAnalysise: Boolean);
begin
  // nothing to do
end;

procedure TAudioPlaylistCollection.DoChangeCoverIDAfterDownload(newID: String);
begin
  inherited;
  // nothing to do
end;

procedure TAudioPlaylistCollection.DoGetFiles(dest: TAudioFileList;
  recursive: Boolean);
var
  i: Integer;
begin
  TLibraryPlaylistCategory(fOwnerCategory).NotifyLoading;
  // fPlaylistFiles.Clear;
  // do not Clear and relod the List, if not necessary!
  // reason: GetFiles will be called to view all files, and to handle drag&drop and play/enque
  if fPlaylistFiles.Count = 0 then
    LoadPlaylistFromFile(fKey, fPlaylistFiles, True, TLibraryPlaylistCategory(fOwnerCategory).DriveManager);
  for i := 0 to fPlaylistFiles.Count - 1 do
    dest.Add(fPlaylistFiles[i]);
end;


procedure TAudioPlaylistCollection.RemoveEmptyCollections;
begin
  inherited;
  // nothing to do
end;

procedure TAudioPlaylistCollection.ReSort(
  newSorting: teCollectionSorting; newDirection: teSortDirection);
begin
  // nothing to do
end;

procedure TAudioPlaylistCollection.Sort(doRecursive: Boolean);
begin
  // nothing to do
end;

procedure TAudioPlaylistCollection.SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False);
begin
  // nothing to do
end;

function TAudioPlaylistCollection.ChangeDriveChar(newChar: Char): Boolean;
begin
  if fKey[1] <> newChar then begin
    fKey[1] := newChar;
    result := True;
  end else
    result := False;
end;


{ TLibraryPlaylistCollection }

constructor TLibraryPlaylistCategory.Create;
begin
  inherited create;
  fLoadedPlaylistCounter := 0;
  fCategoryType := ccPlaylists;
end;

destructor TLibraryPlaylistCategory.Destroy;
begin

  inherited;
end;


function TLibraryPlaylistCategory.GetCaption: String;
begin
  result := _(Name);
end;

function TLibraryPlaylistCategory.GetItemCount: Integer;
begin
  result := CollectionCount;
end;

procedure TLibraryPlaylistCategory.NotifyLoading;
var
  i: Integer;
begin
  // a simple "Garbage Collector"
  // Every Collection has its own Playlist. When the User displays to many Playlists, it could be
  // that there are too many Audiofiles stored nobody actually cares about.
  // Therefore: If the counter is too high, clear all Playlists.
  inc(fLoadedPlaylistCounter);
  if fLoadedPlaylistCounter > MAX_CACHED_PLAYLISTS then begin
    for i := 0 to fCollections.Count - 1 do
      TAudioPlaylistCollection(fCollections[i]).fPlaylistFiles.Clear;
    fLoadedPlaylistCounter := 0;
  end;
end;


procedure TLibraryPlaylistCategory.Clear;
begin
  inherited;

  DriveManager := Nil;
  self.fCollections.Clear;
end;

function TLibraryPlaylistCategory.Compare(const item1, item2: TAudioPlaylistCollection): Integer;

  function CompareKey(const item1, item2: TAudioPlaylistCollection): Integer;
  begin
    result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
  end;
  function CompareFolder(const item1, item2: TAudioPlaylistCollection): Integer;
  begin
    result := AnsiCompareText_NempIgnoreCase(item1.fFolder, item2.fFolder);
    if result = 0 then
      result := CompareKey(item1, item2);
  end;
  function CompareFilename(const item1, item2: TAudioPlaylistCollection): Integer;
  begin
    result := AnsiCompareText_NempIgnoreCase(item1.fFileName, item2.fFileName);
    if result = 0 then
      result := CompareFolder(item1, item2);
  end;

begin
  case fSortOrder of
    pcsPath: begin
        case fSortDirection of
          sd_Ascending: result := CompareKey(item1, item2);
          sd_Descending: result := CompareKey(item2, item1);
        else
          result := CompareKey(item1, item2);
        end;
    end;
    pcsFolder: begin
        case fSortDirection of
          sd_Ascending: result := CompareFolder(TAudioPlaylistCollection(item1), TAudioPlaylistCollection(item2));
          sd_Descending: result := CompareFolder(TAudioPlaylistCollection(item2), TAudioPlaylistCollection(item1));
        else
          result := CompareFolder(TAudioPlaylistCollection(item1), TAudioPlaylistCollection(item2));
        end;
    end;
    pcsFilename: begin
        case fSortDirection of
          sd_Ascending: result := CompareFilename(TAudioPlaylistCollection(item1), TAudioPlaylistCollection(item2));
          sd_Descending: result := CompareFilename(TAudioPlaylistCollection(item2), TAudioPlaylistCollection(item1));
        else
          result := CompareFilename(TAudioPlaylistCollection(item1), TAudioPlaylistCollection(item2));
        end;
    end;
  else
    result := CompareKey(item1, item2);
  end;
end;

procedure TLibraryPlaylistCategory.Sort(newSortOrder: tePlaylistCollectionSorting; newSortDirection: teSortDirection);
begin
  fSortOrder := newSortOrder;
  fSortDirection := newSortDirection;

  fCollections.Sort(
      TComparer<TAudioCollection>.Construct( function (const item1,item2: TAudioCollection): Integer
          begin
            result := Compare(TAudioPlaylistCollection(item1), TAudioPlaylistCollection(item2))
            //AnsiCompareText_NempIgnoreCase(TAudioPlaylistCollection(item1).fFileName, TAudioPlaylistCollection(item2).fFileName);
          end)
  );

  (*
  case newSortOrder of
    cpsFilename: fCollections.Sort(
        TComparer<TAudioCollection>.Construct( function (const item1,item2: TAudioCollection): Integer
            begin
              result := AnsiCompareText_NempIgnoreCase(TAudioPlaylistCollection(item1).fFileName, TAudioPlaylistCollection(item2).fFileName);
            end)
    );
  else    // cpsPath, cpsDirectory
    fCollections.Sort(
        TComparer<TAudioCollection>.Construct( function (const item1,item2: TAudioCollection): Integer
            begin
              result := AnsiCompareText_NempIgnoreCase(item1.Key, item2.Key);
            end)
    );
  end;*)
end;

procedure TLibraryPlaylistCategory.AddPlaylist(aPlaylistFile: TLibraryPlaylist);
var
  newCollection: TAudioPlaylistCollection;
begin
  newCollection := TAudioPlaylistCollection.Create(self, aPlaylistFile);
  newCollection.fCaptionMode := tePlaylistCaptionMode(CaptionMode);
  fCollections.Add(newCollection);
end;

procedure TLibraryPlaylistCategory.RemovePlaylist(
  aPlaylistFile: TLibraryPlaylist);
var
  i: Integer;
  ac: TAudioPlaylistCollection;
begin
  for i := 0 to CollectionCount - 1 do begin
    if TAudioPlaylistCollection(Collections[i]).fLibraryPlaylist = aPlaylistFile then begin
      ac := TAudioPlaylistCollection(Collections[i]);
      ac.fCount := 0;
      ac.fLibraryPlaylist := Nil;
      ac.fFileName := '';
      ac.fKey := '';
      break;
    end;
  end;
end;

procedure TLibraryPlaylistCategory.RepairDriveChars(
  DriveManager: TDriveManager);
var i: Integer;
    CurrentDriveChar, CurrentReplaceChar: WideChar;
    aDrive: TDrive;
begin
    CurrentDriveChar := '-';
    CurrentReplaceChar := '-';
    for i := 0 to fCollections.Count - 1 do
    begin
        if (fCollections[i].Key[1] <> CurrentDriveChar) then
        begin
            if (fCollections[i].Key[1] <> '\') then
            begin
                aDrive := DriveManager.GetManagedDriveByOldChar(fCollections[i].Key[1]);
                if assigned(aDrive) and (aDrive.Drive <> '') then
                begin
                    CurrentDriveChar := fCollections[i].Key[1];
                    CurrentReplaceChar := aDrive.Drive[1];
                end;
            end else
            begin
                CurrentDriveChar := '\';
                CurrentReplaceChar := '\';
            end;
        end;
        TAudioPlaylistCollection(fCollections[i]).ChangeDriveChar(CurrentReplaceChar);
    end;
end;

procedure TLibraryPlaylistCategory.RememberLastCollection(
  aCollection: TAudioCollection);
begin
  inherited;
  fLastSelectedCollectionData[fBrowseMode].Clear;
  fLastSelectedCollectionData[fBrowseMode].RootIndex := -1;
  fLastSelectedCollectionData[fBrowseMode].AddKey(aCollection.Key);
end;

function TLibraryPlaylistCategory.FindLastCollectionAgain: TAudioCollection;
var
  i: Integer;
begin
  result := Nil;
  if fLastSelectedCollectionData[fBrowseMode].KeyCount = 0 then
    exit;

  for i := 0 to fCollections.Count - 1 do begin
    if fCollections[i].Key = fLastSelectedCollectionData[fBrowseMode].Keys[0] then begin
      result := fCollections[i];
      break;
    end;
  end;
end;

end.
