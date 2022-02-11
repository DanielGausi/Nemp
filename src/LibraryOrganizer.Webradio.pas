unit LibraryOrganizer.Webradio;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils, ShoutcastUtils, DriveRepairTools,
  NempAudioFiles, NempFileUtils, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, LibraryOrganizer.Base;

type

  TLibraryWebradioCategory = class;

  // A TAudioPlaylistCollection is defined by a Playlistfile (e.g. "myPlaylist.m3u")
  TAudioWebradioCollection = class(TAudioCollection)
    private
      fName         : String;
      fMediaType    : String;  // mp3, ogg, aac...
      fURL          : String;  // da gehts rein, wenn man manuell was eingibt.
      fBitrate      : Integer;
      fGenre        : String;
      fSortIndex    : Integer; // used for a custom sorting of the favorite stations in nemp
      fStation: TStation;
    protected
      function GetCaption: String; override;
      function GetSimpleCaption: String; override;
      function GetCoverID: String; override;  // = ''
      function GetCollection(Index: Integer): TAudioCollection; override; // = Nil
      function GetCollectionCount: Integer; override; // = 0
    public
      property Station: TStation read fStation;

      constructor Create(aOwner: TLibraryCategory; aStation: TStation);
      destructor Destroy; override;
      procedure Clear; override;
      procedure RemoveEmptyCollections; override;

      procedure DoGetFiles(dest: TAudioFileList; recursive: Boolean); override;
      procedure DoChangeCoverIDAfterDownload(newID: String); override; // empty

      function MatchPrefix(aPrefix: String): Boolean; override;
      function ComparePrefix(aPrefix: String): Integer; override;
      function IndexOf(aCollection: TAudioCollection): Integer; override;

      procedure Analyse(recursive: Boolean); override; // empty
      procedure Sort(doRecursive: Boolean = True); override; // empty
      procedure ReSort(newSorting: teCollectionSorting); override; // empty
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); override; // empty

  end;

  TLibraryWebradioCategory = class(TLibraryCategory)
    private

    protected
      function GetItemCount: Integer; override;
      function GetCaption: String; override;

    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear; override;
      procedure AddStation(aStation: TStation);
      procedure RemoveStation(aStation: TStation);
      // sort the List of fCollections
      procedure Sort(SortOrder: teCollectionSorting);

      procedure RememberLastCollection(aCollection: TAudioCollection); override;
      function FindLastCollectionAgain: TAudioCollection; override;

      procedure RepairDriveChars(DriveManager: TDriveManager); override;
  end;


implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper, gnugettext;

{ TAudioWebradioCollection }


constructor TAudioWebradioCollection.Create(aOwner: TLibraryCategory;
  aStation: TStation);
begin
  inherited create(aOwner);

  fCollectionClass := ccWebStations;
  fKey := aStation.URL;

  fName      := aStation.Name      ;
  fMediaType := aStation.MediaType ;
  fURL       := aStation.URL       ;
  fBitrate   := aStation.Bitrate   ;
  fGenre     := aStation.Genre     ;
  fSortIndex := aStation.SortIndex ;

  fStation := aStation;
  fCount := 1;
end;

destructor TAudioWebradioCollection.Destroy;
begin
  // nothing more to do;
  inherited;
end;


procedure TAudioWebradioCollection.Clear;
begin
  inherited;
  // nothing more to do;
end;

function TAudioWebradioCollection.GetCaption: String;
begin
  if fName <> '' then
    result := fName
  else
    result := fKey;
end;

function TAudioWebradioCollection.GetSimpleCaption: String;
begin
  result := GetCaption;
end;

function TAudioWebradioCollection.IndexOf(
  aCollection: TAudioCollection): Integer;
begin
  result := -1;
end;

function TAudioWebradioCollection.GetCollectionCount: Integer;
begin
  result := 0;
end;

function TAudioWebradioCollection.GetCoverID: String;
begin
  result := '';
end;

function TAudioWebradioCollection.GetCollection(
  Index: Integer): TAudioCollection;
begin
  result := Nil;
end;

procedure TAudioWebradioCollection.Analyse(recursive: Boolean);
begin
  // nothing to do
end;

procedure TAudioWebradioCollection.DoChangeCoverIDAfterDownload(newID: String);
begin
  inherited;
  // nothing to do
end;

procedure TAudioWebradioCollection.DoGetFiles(dest: TAudioFileList;
  recursive: Boolean);
begin
  // nothing to do
end;

function TAudioWebradioCollection.MatchPrefix(aPrefix: String): Boolean;
begin
  result := AnsiContainsText(fKey, aPrefix)
    or AnsiContainsText(fName, aPrefix);
end;

function TAudioWebradioCollection.ComparePrefix(aPrefix: String): Integer;
begin
  if MatchPrefix(aPrefix) then
    result := 0
  else
    result := 1;
end;

procedure TAudioWebradioCollection.RemoveEmptyCollections;
begin
  // nothing to do
end;

procedure TAudioWebradioCollection.ReSort(
  newSorting: teCollectionSorting);
begin
  // nothing to do
end;

procedure TAudioWebradioCollection.Sort(doRecursive: Boolean);
begin
  // nothing to do
end;

procedure TAudioWebradioCollection.SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False);
begin
    // nothing to do
end;

{ TLibraryWebradioCategory }

constructor TLibraryWebradioCategory.Create;
begin
  inherited Create;

  fCategoryType := ccWebStations;
end;

destructor TLibraryWebradioCategory.Destroy;
begin

  inherited;
end;

function TLibraryWebradioCategory.GetCaption: String;
begin
  result := _(Name);
end;

function TLibraryWebradioCategory.GetItemCount: Integer;
begin
  result := CollectionCount;
end;

procedure TLibraryWebradioCategory.Clear;
begin
  inherited;
  fCollections.Clear;
end;

procedure TLibraryWebradioCategory.AddStation(aStation: TStation);
var
  newCollection: TAudioWebradioCollection;
begin
  newCollection := TAudioWebradioCollection.Create(self, aStation);
  //newCollection.fCaptionMode := tePlaylistCaptionMode(CaptionMode);
  fCollections.Add(newCollection);
end;

procedure TLibraryWebradioCategory.RemoveStation(aStation: TStation);
var
  i: Integer;
  awc: TAudioWebradioCollection;
begin
  for i := 0 to CollectionCount - 1 do begin
    if TAudioWebradioCollection(Collections[i]).fStation = aStation then begin
      awc := TAudioWebradioCollection(Collections[i]);
      awc.fCount := 0;
      awc.fName      := '';
      awc.fMediaType := '';
      awc.fURL       := '';
      awc.fBitrate   := 0;
      awc.fGenre     := '';
      awc.fSortIndex := 0;

      awc.fKey := '';
      break;
    end;
  end;
end;

procedure TLibraryWebradioCategory.RepairDriveChars(
  DriveManager: TDriveManager);
begin
  inherited;
  // nothing to do
end;

procedure TLibraryWebradioCategory.Sort(SortOrder: teCollectionSorting);
begin
  // todo (?)
end;

procedure TLibraryWebradioCategory.RememberLastCollection(aCollection: TAudioCollection);
begin
  inherited;

  fLastSelectedCollectionData[fBrowseMode].Clear;
  fLastSelectedCollectionData[fBrowseMode].RootIndex := -1;
  fLastSelectedCollectionData[fBrowseMode].AddKey(aCollection.Key);
end;

function TLibraryWebradioCategory.FindLastCollectionAgain: TAudioCollection;
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
