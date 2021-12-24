unit LibraryOrganizer.Files;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils,
  NempAudioFiles, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, LibraryOrganizer.Base, DriveRepairTools;

type

  TRootCollection = class;
  TAudioFileCollection = class;

  TCollectionComparer = function (const item1, item2: TAudioFileCollection): Integer;

  TCollectionCompareArray = Array[teCollectionSorting] of TCollectionComparer;

  TAudioFileCollectionList = class(TObjectList<TAudioFileCollection>);
  TAudioFileCollectionDict = class (TDictionary<string, TAudioFileCollection>);

  {TCollectionData = record
    CollectionType: teCollectionType;
    // Comparer: TCollectionComparer; // IComparer<TAudioFileCollection>;
    ComparerTag: teCollectionSortings;   // for saving/loading the sorting setting
    // Direction: TSortDirection; ??
  end;}

  {
    TAudioFileCollection
    An AudioFileCollection contains all Audiofiles with a specific property,
    e.g. all files from a specific Artist. Or, for the RootCollection: "All Files"
    The files will be split into several sub-Collections
    (e.g. one Collection for every Album of this Artist)
  }
  TAudioFileCollection = class(TAudioCollection)
    protected
      fInsertMode: teInsertMode;
      fRootCollection: TRootCollection;
      fParentCollection: TAudioFileCollection;
      fLevel: Integer;
      fNeedSorting: Boolean;
      fNeedAnalysis: Boolean;

      fSubCollectionList: TAudioFileCollectionList; // (sorted) list of Sub-Collections
      fSubCollectionDict: TAudioFileCollectionDict; // Dictionary of Sub-Collections (during build-up stage)
      fFileList: TAudioFileList;

      fMissingCoverMode: teMissingCoverPreSorting;
      fSubCollectionSorting: teCollectionSorting;

      fCollectionType: teCollectionType;
      fSubCollectionType: teCollectionType;

      fOnBeforeDeleteCollection: TAudioCollectionNotifyEvent;
      fOnAfterDeleteCollection: TAudioCollectionNotifyEvent;

      // Common properties of the Collection
      // when the collection is "finished", the method ".Analyse" will fill these values,
      // unless they're not set by default
      fArtist: String;
      fAlbum: String;
      fGenre: String;
      fDirectory: String;
      fCoverID: String;
      fYear: Integer;
      fFileAge: TDateTime;

      function GenerateDirectoryAlbumKey(aAudioFile: TAudioFile): String;
      function GenerateArtistKey(aAudioFile: TAudioFile): String;
      //function AdjustedAlbum(aAudioFile: TAudioFile): String;
      function GenerateAlbumKey(aAudioFile: TAudioFile): String;
      function GenerateGenreKey(aAudioFile: TAudioFile): String;
      function GenerateDecadeKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
      function GenerateYearKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
      function GenerateFileAgeYearKey(aAudioFile: TAudioFile): String;
      function GenerateFileAgeMonthKey(aAudioFile: TAudioFile): String;

      function TryGetCollection(aKey: String; out Value: TAudioFileCollection): Boolean;
      function InitNewCollection(aKey: String): TAudioFileCollection;
      function InitNewPathCollection(aKey: String): TAudioFileCollection;
      procedure SwitchToDictionary;

      procedure AddAudioFileByArtist(aAudioFile: TAudioFile);
      procedure AddAudioFileByAlbum(aAudioFile: TAudioFile);
      procedure AddAudioFileByGenre(aAudioFile: TAudioFile);
      procedure AddAudioFileByYear(aAudioFile: TAudioFile);
      procedure AddAudioFileByDecade(aAudioFile: TAudioFile);
      procedure AddAudioFileByFileAgeYear(aAudioFile: TAudioFile);
      procedure AddAudioFileByFileAgeMonth(aAudioFile: TAudioFile);
      procedure AddAudioFileByDirectory(aAudioFile: TAudioFile);
      procedure AddAudioFileByPath(aAudioFile: TAudioFile);
      procedure AddAudioFileByCoverID(aAudioFile: TAudioFile);

      function SearchAudioFileByKey (aKey: String; aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
      function SearchAudioFileByPath (aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;

      function GetSubCollectionByKey(aKey: String): TAudioFileCollection;
      function GetSubCollection(Index: Integer): TAudioCollection; override;
      function GetCollectionCount: Integer; override;

      function BuildCaption(IncludeCount: Boolean): String;
      function GetCaption: String; override;
      function GetSimpleCaption: String; override;
      function GetCoverID: String; override;

      function HasUniqueValue(aCollection: TAudioFileCollection): teCollectionUniqueness;
      procedure GetCommonArtist;
      procedure GetCommonGenre;
      procedure GetCommonYear;
      procedure GetCommonFileAge;
      procedure GetCommonAlbum;
      procedure GetCommonCoverID;
      procedure GetCommonDirectory;

      procedure DecreaseCount(recursive: Boolean);
      procedure GetReverseFilesByProperty(dest: TAudioFileList; aCollectionType: teCollectionType; aProperty: String);

    public
      //property CollectionCount: Integer read GetCollectionCount;
      //property SubCollections[Index: Integer]: TAudioFileCollection read GetSubCollection;

      property Artist  : String      read fArtist;
      property Album   : String      read fAlbum;
      property Genre   : String      read fGenre;
      property Directory: String     read fDirectory;
      property CoverID : String      read fCoverID write fCoverID; // wird ohnehin noch nicht als "common" ermittelt ...
      property Year    : Integer     read fYear;
      property FileAge : TDateTime   read fFileAge;
      property MissingCoverMode: teMissingCoverPreSorting read fMissingCoverMode write fMissingCoverMode;

      // events
      // OnBeforeDeleteCollection: triggered before a subcollection is deleted from the SubCollections-List/Dict (todo then: Delete the VST-Node)
      property OnBeforeDeleteCollection: TAudioCollectionNotifyEvent read fOnBeforeDeleteCollection write fOnBeforeDeleteCollection;
      property OnAfterDeleteCollection: TAudioCollectionNotifyEvent read fOnAfterDeleteCollection write fOnAfterDeleteCollection;

      property NeedSorting: Boolean read fNeedSorting; // This indicates whether the fSubCollectionList should be sorted again
      property NeedAnalysis: Boolean read fNeedAnalysis;

      property CollectionType: teCollectionType read fCollectionType;
      property SubCollectionType: teCollectionType read fSubCollectionType;
      property SubCollectionSorting: teCollectionSorting read fSubCollectionSorting;

      property RootCollection: TRootCollection read fRootCollection;
      property ParentCollection: TAudioFileCollection read fParentCollection;

      constructor Create(aOwner: TLibraryCategory; aRoot: TRootCollection; aLevel: Integer; RecursiveDir: Boolean = False);
      destructor Destroy; override;
      procedure Clear; override;
      procedure Empty; override;
      procedure RemoveEmptyCollections; override;

      procedure AddAudioFile(aAudioFile: TAudioFile);
      procedure SortCollection(doRecursive: Boolean = True); override;
      procedure ReSortCollection(newSorting: teCollectionSorting); override;
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); override;
      procedure ReSortDirectoryCollection(newSorting: teCollectionSorting; recursive: Boolean);

      procedure DoGetFiles(dest: TAudioFileList; recursive: Boolean); override;
      procedure DoChangeCoverIDAfterDownload(newID: String); override;
      procedure GetReverseFiles(dest: TAudioFileList);

      function SearchAudioFile(aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
      function SearchEditedAudioFile(aAudioFile: TAudioFile): TAudioFileCollection;

      procedure RemoveAudioFile(aAudioFile: TAudioFile); virtual;
      function RelocateAudioFile(aAudioFile: TAudioFile): Boolean; virtual;
      function CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean; virtual;

      procedure RemoveCollection(aCollection: TAudioFileCollection);


      function MatchPrefix(aPrefix: String): Boolean; override;
      function ComparePrefix(aPrefix: String): Integer; override;
      function GetCollectionIndex(aCollection: TAudioCollection): Integer; override;

      {
      Frage: Wie einzelne Audiofiles (z.B. nach einer Änderung einiger Eigenschaften) aus der Collection
      (oder besser: DEN COLLECTIONS!) entfernen?
      Problem: Die Key-Properties sind ggf. nach den Änderungen anders, d.h. man kann von der RootCollection aus
      die richtige FileList nicht mehr finden (Backup-Properties "Key1, Key2" möchte ich loswerden)
      Lösung: Vor dem Edit die Collections suchen und zwischenspeichern.
      Aus diesen dann nach dem edit das File löschen. Falls Count der Collection dann = 0: Collection aus dem Parent löschen (?)
      }


      procedure Analyse(recursive: Boolean); override;
      // After inserting all Files into a collection, we may want to analyze these files and collect further data
      // for example, when sorting by Album, we may want addtional common information like "year", "genre", "artist"

  end;

  // Den Typ nochmal überdenken ?
  // Sinn: Es soll mehrere Sortierungen für die AudioFiles geben, d.h. Root kann sein "Verzeichnisse" oder "Artist-Album"
  // Bei Webradio und Playlists: Da auch eine Baumstruktur ermöglichen?
  TRootCollection = class(TAudioFileCollection)
    private
      // Liste/Array mit Typen der sub-collections. Die werden nur im Root einmal gespeichert, alle
      // sub collections verweisen darauf und können anhand ihres Levels (Tiefe im Baum) ihren Typ bestimmen
      fCollectionTypeList: TCollectionTypeList;
      fCaptionTypeList: TCollectionTypeList;
      // Properties fest definiert durch MediaLibrary-Settings
      // caption dann z.B. "Verzeichnisse" oder "Artist-Album"

    protected
      function GetCaption: String; override;
      function GetLevelCaption(Index: Integer): String;
      function GetLayerDepth: Integer;
      function GetIsDirectoryCollection: Boolean;

      procedure AddCaptionType(aType: TCollectionConfig);
      procedure ReBuildCaptionTypes;

    public
      property LevelCaption[Index: Integer]: string read GetLevelCaption;
      property LayerDepth: Integer read GetLayerDepth;
      property IsDirectoryCollection: Boolean read GetIsDirectoryCollection;

      property CollectionTypeList: TCollectionTypeList read fCollectionTypeList;

      constructor Create(aOwner: TLibraryCategory);
      destructor Destroy; override;
      procedure Clear; override;
      procedure Reset;

      procedure AddSubCollectionType(aType: teCollectionType; aSortingType: teCollectionSorting);
      procedure InsertSubCollectionType(Index: Integer; aType: teCollectionType; aSortingType: teCollectionSorting);
      procedure MoveSubCollectionType(curIndex, newIndex: Integer);
      procedure ChangeSubCollectionType(Index: Integer; aType: teCollectionType; aSortingType: teCollectionSorting);
      procedure ChangeSubCollectionSorting(Index: Integer; aSortingType: teCollectionSorting);
      procedure RemoveSubCollection(Layer: Integer);

      function GetSubCollectionType(aLevel: Integer): teCollectionType;
      // function GetCollectionComparer(aLevel: Integer): TCollectionComparer; //IComparer<TAudioFileCollection>;
      function GetCollectionCompareType(aLevel: Integer): teCollectionSorting;
      procedure ResortLevel(aLevel: Integer; newSorting: teCollectionSorting);

      procedure RemoveAudioFile(aAudioFile: TAudioFile); override;
      procedure RepairDriveChars(DriveManager: TDriveManager);
  end;

  // TRootCollectionList = class(TObjectList<TRootCollection>);

  TLibraryFileCategory = class(TLibraryCategory)
    protected
      function GetItemCount: Integer; override;
    public
      constructor Create;
      destructor Destroy; override;

      // creates a new RootCollection, adds it to the internal list and returns.
      //function AddRootCollection: TRootCollection;
      procedure RememberLastCollection(aCollection: TAudioCollection); override;
      function FindLastCollectionAgain: TAudioCollection; override;

      //procedure Reset;
      function AddRootCollection(const Properties: Array of teCollectionType; const Sortings: Array of teCollectionSorting): TRootCollection; overload;
      function AddRootCollection(aRootConfig: TCollectionTypeList): TRootCollection; overload;

      procedure AddAudioFile(aAudioFile: TAudioFile);
      procedure RemoveAudioFile(aAudioFile: TAudioFile);

      // relocate: After editing/refreshing an Audiofile, it can happen, that the keys used to
      // sort it into the Collections have changed. Therefore, it should be relocated.
      // method: Try to find it using the (new) keys.
      // If success: nothing more to do
      // else: Search it without using the keys, remove it from there and add it again.
      // Return value: True iff the location has changed, False iff no change was neccessary.
      function RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
      function CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean;
      procedure RepairDriveChars(DriveManager: TDriveManager); override;
  end;

  //TLibraryFileCategoryList = class(TObjectList<TLibraryFileCategory>);


  {var
    SortCollection_Default,
    SortCollection_Album, // needed, as Album-Key can be quite complicated
    SortCollection_ArtistAlbum,
    SortCollection_Count,
    SortCollection_Year,
    SortCollection_FileAge,
    SortCollection_Genre,
    SortCollection_Directory: IComparer<TAudioFileCollection>;
    // not needed (probably)
    //SortCollection_Directory,
    //SortCollection_Genre
    //SortCollection_Artist
  }

    function SortCollection_MissingCoverFirst(const item1, item2: TAudioFileCollection): Integer;
    function SortCollection_MissingCoverLast(const item1, item2: TAudioFileCollection): Integer;

    function CompareCollection_Default(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_Album(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_ArtistAlbum(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_Count(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_Year(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_FileAge(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_Genre(const item1,item2: TAudioFileCollection): Integer;
    function CompareCollection_Directory(const item1,item2: TAudioFileCollection): Integer;

implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper;

type
  TKeyCache = record
    //RawAlbum,
    RawDirectory: String;
    //ProcessedAlbum,
    ProcessedDirectory: String;
  end;

var
  fLibraryFormatSettings: TFormatSettings;
  KeyCache: TKeyCache;


const
  NempCollectionComparer: TCollectionCompareArray = (
        CompareCollection_Default,
        CompareCollection_Album,
        CompareCollection_ArtistAlbum,
        CompareCollection_Count,
        CompareCollection_Year,
        CompareCollection_FileAge,
        CompareCollection_Genre,
        CompareCollection_Directory );

function CompareCollection_Default(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
end;

function CompareCollection_Album(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
end;

function CompareCollection_ArtistAlbum(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
end;

function CompareCollection_Count(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item2.Count, item1.Count); // reverse order
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
end;

function CompareCollection_Year(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item2.fYear, item1.fYear); // reverse order
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
end;

function CompareCollection_FileAge(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item2.fFileAge, item1.fFileAge); // reverse order
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
end;

function CompareCollection_Genre(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.Genre, item2.Genre);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
end;

function CompareCollection_Directory(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fDirectory, item2.fDirectory);
end;

function SortCollection_MissingCoverFirst(const item1, item2: TAudioFileCollection): Integer;
begin
  if (item1.CoverID <> '') and (item1.CoverID[1] = '_') then
  begin
      // item1 is a missing cover
      if (item2.CoverID <> '') and (item2.CoverID[1] = '_') then
          // both cover are missing
          result := 0
      else
          result := -1;
  end else
      if (item2.CoverID <> '') and (item2.CoverID[1] = '_') then
      begin
          // item2 is missing
          if (item1.CoverID <> '') and (item1.CoverID[1] = '_') then
              // both are missing
              result := 0
          else
              result := 1;
      end else
          // none is missing
          result := 0;
end;

function SortCollection_MissingCoverLast(const item1, item2: TAudioFileCollection): Integer;
begin
  if (item1.CoverID <> '') and (item1.CoverID[1] = '_') then
  begin
      // item1 is a missing cover
      if (item2.CoverID <> '') and (item2.CoverID[1] = '_') then
          // both cover are missing
          result := 0
      else
          result := 1;
  end else
      if (item2.CoverID <> '') and (item2.CoverID[1] = '_') then
      begin
          // item2 is missing
          if (item1.CoverID <> '') and (item1.CoverID[1] = '_') then
              // both are missing
              result := 0
          else
              result := -11;
      end else
          // none is missing
          result := 0;
end;

(*
function GetComparer(Sorting: teCollectionSortings): TCollectionComparer; // IComparer<TAudioFileCollection>;
begin
  case Sorting of
    csDefault    : result := CompareCollection_Default;
    csAlbum      : result := CompareCollection_Album;
    csArtistAlbum: result := CompareCollection_ArtistAlbum;
    csCount      : result := CompareCollection_Count;
    csYear       : result := CompareCollection_Year;
    csFileAge    : result := CompareCollection_FileAge;
    csGenre      : result := CompareCollection_Genre;
    csDirectory  : result := CompareCollection_Directory;
  else
    // by Key
    result := CompareCollection_Default;
  end;
end;   *)


{ TAudioFileCollection }

constructor TAudioFileCollection.Create(aOwner: TLibraryCategory; aRoot: TRootCollection; aLevel: Integer; RecursiveDir: Boolean = False);
begin
  inherited create(aOwner);

  fCollectionClass := ccFiles;
  fRootCollection := aRoot;
  fLevel := aLevel;
  fNeedSorting := False;
  fNeedAnalysis := False;
  fInsertMode := imList;
  fMissingCoverMode := mcIgnore;
  fSubCollectionList := TAudioFileCollectionList.Create(True);

  if assigned(aRoot) then begin
    if RecursiveDir then begin
      fCollectionType    := ctDirectory;
      fSubCollectionType := ctDirectory;
      //fSubCollectionComparer := CompareCollection_Default;   // here: Comparer-Settings for Directories from OrganizerSettings?
      fSubCollectionSorting := csDefault;
    end else
    begin
      // note: aLevel >= 1 here, and therefore aLevel-1 >= 0
      fCollectionType := aRoot.GetSubCollectionType(aLevel-1);
      fSubCollectionType := aRoot.GetSubCollectionType(aLevel);
      //fSubCollectionComparer := aRoot.GetCollectionComparer(aLevel);
      fSubCollectionSorting := aRoot.GetCollectionCompareType(aLevel);
    end;
  end else
  begin
    fCollectionType    := ctNone;
    fSubCollectionType := ctNone;
    //fSubCollectionComparer := CompareCollection_Default;
    fSubCollectionSorting := csDefault;
  end;
  fFileList := TAudioFileList.Create(False);
end;

destructor TAudioFileCollection.Destroy;
begin
  fFileList.Free;
  if assigned(fSubCollectionDict) then
    fSubCollectionDict.Free;
  fSubCollectionList.Free;

  inherited;
end;

procedure TAudioFileCollection.DoChangeCoverIDAfterDownload(newID: String);
var
  i: Integer;
begin
  inherited;
  fCoverID := newID;
  for i := 0 to fFileList.Count - 1 do
    fFileList[i].CoverID := newID;
end;

procedure TAudioFileCollection.DoGetFiles(dest: TAudioFileList;
  recursive: Boolean);
var
  i: Integer;
begin
  for i := 0 to fFileList.Count - 1 do
    dest.Add(fFileList[i]);

  if recursive and assigned(self.fSubCollectionList) then begin
    for i := 0 to fSubCollectionList.Count - 1 do
      fSubCollectionList[i].DoGetFiles(dest, recursive);
  end;
end;

procedure TAudioFileCollection.GetReverseFiles(dest: TAudioFileList);
var
  aProp: String;
begin
  aProp := '';
  case fCollectionType of
    //ctNone: ;
    //ctRoot: ;
    ctArtist: aProp := fArtist;
    ctAlbum: aProp := fAlbum;
    //ctDirectory: ;
    ctGenre: aProp := fGenre;
    //ctDecade: ;
    ctYear: aProp := IntToStr(fYear);
    //ctFileAgeYear: ;
    //ctFileAgeMonth: ;
  else
    aProp := '';
  end;

  if aProp <> '' then
    fRootCollection.GetReverseFilesByProperty(
      dest, fCollectionType, aProp)
  else
    GetFiles(dest, True);
end;

procedure TAudioFileCollection.GetReverseFilesByProperty(dest: TAudioFileList; aCollectionType: teCollectionType; aProperty: String);
var
  i: Integer;
  match: Boolean;

  function isMatch(aFile: TAudioFile): Boolean;
  begin
    case aCollectionType of
      //ctNone: ;
      //ctRoot: ;
      ctArtist: result := aFile.Artist = aProperty;
      ctAlbum: result := aFile.Album = aProperty;
      //ctDirectory: ;
      ctGenre: result := aFile.Genre = aProperty;
      //ctDecade: ;
      ctYear: result := aFile.Year = aProperty;
      //ctFileAgeYear: ;
      //ctFileAgeMonth: ;
    else
      result := False;
    end;
  end;

begin
  for i := 0 to fFileList.Count - 1 do
    if isMatch(fFileList[i]) then
      dest.Add(fFileList[i]);

  if assigned(self.fSubCollectionList) then begin
    for i := 0 to fSubCollectionList.Count - 1 do
      fSubCollectionList[i].GetReverseFilesByProperty(dest, aCollectionType, aProperty);
  end;
end;

function TAudioFileCollection.BuildCaption(IncludeCount: Boolean): String;
var
  mainValue: String;
begin
  case self.fCollectionType of
    ctNone: mainValue := '<Error>'; //
    ctRoot: mainValue := ''; // should be handled by TRootCollection
    ctArtist: mainValue := self.fArtist;
    ctAlbum: begin
      if assigned(fParentCollection)
        and (fParentCollection.fSubCollectionSorting = csArtistAlbum)
      then
        mainValue := Format('%s - %s', [fArtist, fAlbum])
      else begin
        mainValue := Format('%s - %s', [fArtist, fAlbum]); //fKeyData.Album;    // todo: empty string
        if mainValue = '' then
          mainValue := rsCollectionDataUnknown;
      end;
    end;
    ctDirectory: mainValue := fKey; //  .Directory;
    ctGenre: mainValue := fGenre;
    ctDecade: mainValue := IntToStr(fYear);
    ctYear: mainValue := IntToStr(fYear);
    ctFileAgeYear: mainValue := FormatDateTime('yyyy', fFileAge, fLibraryFormatSettings);
    ctFileAgeMonth: mainValue := FormatDateTime('mmmm yy', fFileAge, fLibraryFormatSettings);
  end;

  if IncludeCount then
    result := Format('%s (%d)', [mainValue, Count] )
  else
    result := mainValue;
end;

function TAudioFileCollection.GetCaption: String;
begin
  result := BuildCaption(NempOrganizerSettings.ShowCollectionCount)
end;

function TAudioFileCollection.GetSimpleCaption: String;
begin
  result := BuildCaption(False);
end;


function TAudioFileCollection.GetCoverID: String;
begin
  result := fCoverID;
end;


procedure TAudioFileCollection.GetCommonArtist;
var
  i, maxIdx: Integer;
  aStringlist: TStringList;
  mismatchPos: Integer;
  str1: String;

begin
  // for a common "Artist", we should not work with collections.
  // On some albums, there are a lot tracks from "main artist feat. other artist"
  // or somethin like that. That should be recognized as "main artist"

  if fFileList.Count <= 50 then
    maxIdx := fFileList.Count-1
  else
    maxIdx := 50;

  aStringlist := TStringList.Create;
  try
    for i := 0 to maxIdx do
      if (fFileList[i].Artist <> '') then
        aStringlist.Add(fFileList[i].Artist);

    mismatchPos := 0;
    str1 := GetCommonString(aStringlist, 0, mismatchPos);  // error tolerance: 0
    if str1 = '' then
      fArtist := CoverFlowText_VariousArtists
    else
        fArtist := str1;
  finally
    aStringList.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonAlbum;
var
  aStringList: TStringList;
  i, maxIdx: Integer;
  mismatchPos: Integer;
  str1: String;
begin
  if fFileList.Count <= 50 then
    maxIdx := fFileList.Count-1
  else
    maxIdx := 50;

  aStringList := TStringList.Create;
  try
    for i := 0 to maxIdx do
      if (fFileList[i].Album <> '') then
        aStringlist.Add(fFileList[i].Album);

    mismatchPos := 0;
    str1 := GetCommonString(aStringlist, 1, mismatchPos);
    if str1 = '' then
      fAlbum := CoverFlowText_UnkownCompilation // 'Unknown compilation';
    else
    begin
      if mismatchPos <= length(str1) Div 2 +1 then
        fAlbum := str1
      else
        fAlbum := copy(str1, 1, mismatchPos-1) + ' ... ';
    end;
  finally
    aStringList.Free;
  end;
end;

function TAudioFileCollection.HasUniqueValue(aCollection: TAudioFileCollection): teCollectionUniqueness;
var
  FileCount: Integer;
begin
  // cuUnique, cuSampler, cuInvalid
  case aCollection.CollectionCount of
    0: result := cuInvalid;
    1: result := cuUnique;
  else
      begin
        result := cuSampler;
        aCollection.SortCollection(False); // by Count
        FileCount := aCollection.Count;

        if (FileCount > 5) and (FileCount <= 10) and (aCollection.fSubCollectionList[0].Count > (FileCount - 1)) then
          result := cuUnique
        else
          if (aCollection.fSubCollectionList[0].Count >= Round(FileCount * 0.9)) then
            result := cuUnique;
      end;
  end;
end;

procedure TAudioFileCollection.GetCommonCoverID;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  // use the most common CoverID
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ctCoverID, csCount);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);
    aRoot.SortCollection(False);
    fCoverID := TAudioFileCollection(aRoot.SubCollections[0]).fCoverID;

    if fCoverID= '' then
      fCoverID := IntToStr(aRoot.CollectionCount);

  finally
    aRoot.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonDirectory;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  // A "common Directory" like "various" doesn't make sense
  // => use the most common Directory
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ctPath, csCount);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);
    fDirectory := TAudioFileCollection(aRoot.SubCollections[0]).fDirectory;
  finally
    aRoot.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonGenre;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ctGenre, csCount);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);

    case HasUniqueValue(aRoot) of
      cuUnique: begin
          if TAudioFileCollection(aRoot.SubCollections[0]).fGenre = '' then
            fGenre := rsCollectionDataUnknown
          else
            fGenre := TAudioFileCollection(aRoot.SubCollections[0]).fGenre;
      end;
      cuSampler: fGenre := CoverFlowText_VariousGenres
    else
      //cuInvalid
       fGenre := rsCollectionDataUnknown
    end;
  finally
    aRoot.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonYear;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  // common year: just get the most frequent year
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ctYear, csCount);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);

    case HasUniqueValue(aRoot) of
      cuUnique: fYear := TAudioFileCollection(aRoot.SubCollections[0]).fYear;
      cuSampler: fYear := TAudioFileCollection(aRoot.SubCollections[0]).fYear;
    else
      //cuInvalid
       fYear := -1
    end;
  finally
    aRoot.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonFileAge;
var
  i: Integer;
  newestAge, currentAge: TDateTime;
begin
  // FileAge: just get the newest date
  newestAge := 0;
  for i := 0 to fFileList.Count - 1 do begin
    currentAge := fFileList[i].FileAge;
    if currentAge > newestAge then
      newestAge := currentAge;
  end;

  fFileAge := newestAge;
end;

procedure TAudioFileCollection.Analyse(recursive: Boolean);
var str1: UnicodeString;
    maxidx, i, fehlstelle: Integer;
    aStringlist: TStringList;
    newestAge, currentAge: TDateTime;
begin
  if recursive then
    for i := 0 to fSubCollectionList.Count - 1 do
      fSubCollectionList[i].Analyse(recursive);

  if (fFileList.Count = 0) or (not fNeedAnalysis) then
    exit; // nothing more to do in that case

  case self.fCollectionType of
    ctNone: ;
    ctRoot: ;
    ctArtist: ;
    ctAlbum: begin
          // like in the "Coverflow"
          GetCommonArtist;
          GetCommonAlbum;
          GetCommonGenre;
          GetCommonYear;
          GetCommonFileAge;
          GetCommonDirectory;
          getCommonCoverID;
    end;
    ctDirectory: begin
          // maybe useful for different sortings than "by directory name"
          //GetCommonArtist;
          //GetCommonAlbum;
          //GetCommonGenre;
          //GetCommonYear;
          GetCommonFileAge;
    end;
    ctGenre: ;
    ctDecade: ;
    ctYear: ;
    ctFileAgeYear: ;
    ctFileAgeMonth: ;
  end;
  // Analysis done.
  fNeedAnalysis := False;
end;

function TAudioFileCollection.GenerateArtistKey(aAudioFile: TAudioFile): String;
begin
  result := AnsiLowerCase(aAudioFile.Artist);
end;


{
PathStructure := TStringlist.create;
  try
    Explode('\', aAudioFile.Pfad, PathStructure);
    // fix network paths starting with "\\"
    if (PathStructure.Count >= 3)
      and (PathStructure[0] = '')
      and (PathStructure[1] = '')
    then begin
      PathStructure[2] := '\\' + PathStructure[2];
      startIdx := 2;
    end else
      startIdx := 0;

    if (PathStructure.Count > startIdx) then
      AddRecursively(startIdx, self)
  finally
    PathStructure.Free;
  end;

}
function TAudioFileCollection.GenerateDirectoryAlbumKey(aAudioFile: TAudioFile): String;
var
  PathStructure: TStringlist;
  lastDirectory: String;
  i, startIdx, endIdx: Integer;
begin
  if (not NempOrganizerSettings.TrimCDFromDirectory) or (NempOrganizerSettings.CDNames.Count = 0) then
    result := aAudioFile.Ordner
  else
  begin
    // result should be the path, but something like "\CD 2\" as last directory should be ignored
    if KeyCache.RawDirectory = aAudioFile.Ordner  then
      result := KeyCache.ProcessedDirectory
    else begin
        PathStructure := TStringlist.create;
        try
          Explode('\', aAudioFile.Pfad, PathStructure);

          if (PathStructure.Count >= 3)
            and (PathStructure[0] = '')
            and (PathStructure[1] = '')
          then begin
            PathStructure[2] := '\\' + PathStructure[2];
            startIdx := 2;
          end else
            startIdx := 0;

          endIdx := PathStructure.Count - 2;

          // note: startIdx+2 because a folder like "CD 1" is the root folder, it should NOT be skipped
          // so, there must be (2) Directory-Levels + (1) the filename in the PathStructure when we want to skip the last dir
          if PathStructure.Count > startIdx + 2 then begin
            // analyse the last directory
            lastDirectory := PathStructure[PathStructure.Count - 2];
            for i := 0 to NempOrganizerSettings.CDNames.Count - 1 do
              lastDirectory  := StringReplace(lastDirectory, NempOrganizerSettings.CDNames[i], ' ', [rfIgnoreCase, rfReplaceAll]);
            lastDirectory := trim(lastDirectory);
            if (lastDirectory <> PathStructure[PathStructure.Count - 2]) and
                           ((lastDirectory <> '') and (StrToIntDef(lastDirectory, 10) < 10))
            then
              // skip the last directory for Key calculation
              endIdx := PathStructure.Count - 3
            else
              endIdx := PathStructure.Count - 2;
          end;

          result := '';
          for i := startIdx to endIdx do
            result := result + PathStructure[i] + '\';

          // Set the cache
          KeyCache.RawDirectory := aAudioFile.Ordner;
          KeyCache.ProcessedDirectory := result;
        finally
          PathStructure.Free;
        end;
    end;
  end;
end;

(*
This method works for Directories like "\CD 2\", but not for complete strings like "Some Album (CD 2)"
skip it for now, maybe later ...
function TAudioFileCollection.AdjustedAlbum(aAudioFile: TAudioFile): String;
var
  processedAlbum: String;
  i: Integer;
begin
  if (not NempOrganizerSettings.TrimCDFromDirectory) or (NempOrganizerSettings.CDNames.Count = 0) then
    result := aAudioFile.Album
  else
  begin
    // result should be the path, but something like "\CD 2\" as last directory should be ignored
    if KeyCache.RawAlbum = aAudioFile.Album  then
      result := KeyCache.ProcessedAlbum
    else begin
      // Remove thing like "CD 2" from the album information
      processedAlbum := aAudioFile.Album;
      for i := 0 to NempOrganizerSettings.CDNames.Count - 1 do
        processedAlbum  := StringReplace(processedAlbum, NempOrganizerSettings.CDNames[i], ' ', [rfIgnoreCase, rfReplaceAll]);
      processedAlbum := trim(processedAlbum);
      if (processedAlbum <> aAudioFile.Album)
        and ((processedAlbum <> '')
        and (StrToIntDef(processedAlbum, 10) < 10))
      then
        result := processedAlbum
      else
        result := aAudioFile.Album;
      // Set the cache to the new data
      KeyCache.RawAlbum := aAudioFile.Album;
      KeyCache.ProcessedAlbum := result;
    end;
  end;
end;
*)

function TAudioFileCollection.GenerateAlbumKey(aAudioFile: TAudioFile): String;
begin
  // todo: different key depending on settings (e.g. include Artist and/or Directory, the latter stripped by stuff like "CD 1")
  case NempOrganizerSettings.AlbumKeyMode of
    akAlbumOnly: result := AnsiLowerCase(aAudioFile.Album);
    akAlbumArtist: result := Format('%s||%s', [AnsiLowerCase(aAudioFile.Album), AnsiLowerCase(aAudioFile.Artist)]);
    akAlbumDirectory: result := Format('%s||%s', [AnsiLowerCase(aAudioFile.Album), GenerateDirectoryAlbumKey(aAudioFile)]);
    akDirectoryOnly: result := GenerateDirectoryAlbumKey(aAudioFile);
    akCoverID: result := aAudioFile.CoverID;
  end;
end;

function TAudioFileCollection.GenerateGenreKey(aAudioFile: TAudioFile): String;
begin
  result := trim(AnsiLowerCase(aAudioFile.Genre));
  // for later maybe: defining synonyms?
  //result := AnsiLowerCase(Trim(aAudioFile.Genre));
end;

function TAudioFileCollection.GenerateDecadeKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
begin
  IntYear := StrToIntDef(aAudioFile.Year, -1);
  result := YearToDecadeString(IntYear);
end;

function TAudioFileCollection.GenerateYearKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
begin
  IntYear := StrToIntDef(aAudioFile.Year, -1);
  result := AddLeadingZeroes(IntYear, 4);
end;

function TAudioFileCollection.GenerateFileAgeYearKey(aAudioFile: TAudioFile): String;
begin
  result := FormatDateTime('yyyy', aAudioFile.FileAge, fLibraryFormatSettings);
end;

function TAudioFileCollection.GenerateFileAgeMonthKey(aAudioFile: TAudioFile): String;
begin
  result := FormatDateTime('yyyy-mm', aAudioFile.FileAge, fLibraryFormatSettings);
end;

function TAudioFileCollection.TryGetCollection(aKey: String; out Value: TAudioFileCollection): Boolean;
var
  i: Integer;
  aCollection: TAudioFileCollection;
begin
  Value := Nil;
  result := False;
  case fInsertMode of
    imList: begin
        for i := 0 to fSubCollectionList.Count - 1 do begin
          if fSubCollectionList[i].fKey = aKey then begin
            Value := fSubCollectionList[i];
            result := True;
            break;
          end;
        end;
    end;
    imDictionary: begin
      if fSubCollectionDict.ContainsKey(aKey) then
        if fSubCollectionDict.TryGetValue(aKey, aCollection) then
        begin
          Value := aCollection;
          result := True;
        end;
    end;
  end;
end;

procedure TAudioFileCollection.SwitchToDictionary;
var
  i: Integer;
  aCollection: TAudioFileCollection;
begin
  fSubCollectionDict := TAudioFileCollectionDict.Create(2 * fSubCollectionList.Count);
  for i := 0 to fSubCollectionList.Count - 1 do begin
    aCollection := fSubCollectionList[i];
    fSubCollectionDict.Add(aCollection.fKey, aCollection);
  end;
  fInsertMode := imDictionary;
end;

function TAudioFileCollection.InitNewCollection(aKey: String): TAudioFileCollection;
begin
  fNeedSorting := True;
  result := TAudioFileCollection.Create(fOwnerCategory, fRootCollection, fLevel + 1);
  result.fParentCollection := self;
  result.fKey := aKey;

  case fInsertMode of
    imList: begin
      fSubCollectionList.Add(result);
    end;
    imDictionary: begin
      fSubCollectionList.Add(result);
      fSubCollectionDict.Add(aKey, result);
    end;
  end;

  if (fInsertMode = imList) and (fSubCollectionList.Count > MAX_LIST_SIZE) then
    SwitchToDictionary;
end;

function TAudioFileCollection.InitNewPathCollection(aKey: String): TAudioFileCollection;
begin
  result := TAudioFileCollection.Create(fOwnerCategory, fRootCollection, fLevel + 1, True);
  result.fParentCollection := self;
  result.fKey := aKey;

  case fInsertMode of
    imList: begin
      fSubCollectionList.Add(result);
    end;
    imDictionary: begin
      fSubCollectionList.Add(result);
      fSubCollectionDict.Add(aKey, result);
    end;
  end;

  if (fInsertMode = imList) and (fSubCollectionList.Count > MAX_LIST_SIZE) then
    SwitchToDictionary;
end;

function TAudioFileCollection.MatchPrefix(aPrefix: String): Boolean;
begin
  case self.fCollectionType of
    ctNone: result := False;
    ctRoot: result := False;
    ctArtist: result := AnsiStartsText(aPrefix, fArtist);
    ctAlbum: result := AnsiStartsText(aPrefix, fArtist) or AnsiStartsText(aPrefix, fAlbum);
    ctDirectory: result := AnsiStartsText(aPrefix, fKey);
    ctGenre: result := AnsiStartsText(aPrefix, fGenre);
    ctDecade: result := AnsiStartsText(aPrefix, IntToStr(fYear));
    ctYear: result := AnsiStartsText(aPrefix, IntToStr(fYear));
    ctFileAgeYear: result := AnsiStartsText(aPrefix, FormatDateTime('yyyy', fFileAge, fLibraryFormatSettings));
    ctFileAgeMonth: result := AnsiStartsText(aPrefix, FormatDateTime('mmmm yy', fFileAge, fLibraryFormatSettings));
  end;
end;

function TAudioFileCollection.ComparePrefix(aPrefix: String): Integer;
begin
  if MatchPrefix(aPrefix) then
    result := 0
  else
    result := 1;
end;

function TAudioFileCollection.GetCollectionIndex(aCollection: TAudioCollection): Integer;
begin
  if assigned(aCollection) and (aCollection is TAudioFileCollection)  then
    result := fSubCollectionList.IndexOf(TAudioFileCollection(aCollection))
  else
    result := 0;
end;

procedure TAudioFileCollection.AddAudioFileByArtist(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateArtistKey(aAudioFile);
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fArtist := aAudioFile.Artist;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByAlbum(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateAlbumKey(aAudioFile);
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fAlbum := aAudioFile.Album;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByGenre(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateGenreKey(aAudioFile);
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fGenre := aAudioFile.Genre;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByDecade(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  Year: Integer;
  decadeKey: String;
begin
  decadeKey := GenerateDecadeKey(aAudioFile, Year);

  if not TryGetCollection(decadeKey, aCollection) then begin
    aCollection := InitNewCollection(decadeKey);
    aCollection.fYear := YearToDecade(Year);
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByPath (aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := aAudioFile.Ordner;
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fDirectory := aAudioFile.Ordner;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByCoverID(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := aAudioFile.CoverID;
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fCoverID := aAudioFile.CoverID;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByYear(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey : String;
  Year: Integer;
begin
  aKey := GenerateYearKey(aAudioFile, Year);

  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fYear := Year;
  end;
  aCollection.AddAudioFile(aAudioFile);

  {if Year <= 0 then begin
    // invalid Year ("0" is also considered invalid here)
    if not TryGetValue(rsUnknownYear, aCollection) then begin
      aCollection := TAudioFileCollection.Create(ctYear, fSecondaryDictType, ctNone);
      aCollection.fKeyData.Year := -1;    // ??
      self.Add(rsUnknownYear, aCollection);
    end;

  end else
  begin
    // valid Year
    if not NempOrganizerSettings.GroupYearsByDecade then begin
      // just one entry for every year
      if not TryGetValue(aKey, aCollection) then begin
        aCollection := TAudioFileCollection.Create(ctYear, fSecondaryDictType, ctNone);
        aCollection.fKeyData.Year := Year;
        self.Add(aKey, aCollection);
      end;
    end else
    begin
      // organize years in SubRacks by decade
      decade := Year mod 10;
      decadeKey := IntToStr(decade);
      // get Collection "decade"
      if not TryGetValue(decadeKey, decadeCollection) then begin
        decadeCollection := TAudioFileCollection.Create(ctYear, ctYear, fSecondaryDictType);
        decadeCollection.fKeyData.Year := Decade;
        self.Add(decadeKey, decadeCollection);
      end;
      // get collection "year" within this decade
      if not decadeCollection.fSubRack.TryGetValue(aKey, aCollection) then begin
        aCollection := TAudioFileCollection.Create(ctYear, fSecondaryDictType, ctNone);
        aCollection.fKeyData.Year := Year;
        decadeCollection.fSubRack.Add(aKey, aCollection);
      end;
    end;
  end;

  aCollection.AddAudioFile(aAudioFile);    }
end;

procedure TAudioFileCollection.Clear;
begin
  fCount := 0;
  fNeedSorting := False;
  fFileList.Clear;
  fSubCollectionList.Clear;
  if assigned(fSubCollectionDict) then
    fSubCollectionDict.Clear;
end;

{
  Empty:
  Remove all Files from the Collection, but leave the structure as it is.
  Used for refilling the collections after a refresh.
}
procedure TAudioFileCollection.Empty;
var
  i: Integer;
begin
  fCount := 0;
  fNeedSorting := False;
  fFileList.Clear;
  for i := 0 to fSubCollectionList.Count - 1 do
    fSubCollectionList[i].Empty;
end;

procedure TAudioFileCollection.RemoveEmptyCollections;
var
  i: Integer;
begin
  for i := fSubCollectionList.Count - 1 downto 0 do begin
    if fSubCollectionList[i].Count = 0 then
      RemoveCollection(fSubCollectionList[i])
    else
      fSubCollectionList[i].RemoveEmptyCollections;
  end;
end;

procedure TAudioFileCollection.AddAudioFileByFileAgeYear (aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateFileAgeYearKey(aAudioFile);

  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fFileAge := aAudioFile.FileAge;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByFileAgeMonth(
  aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateFileAgeMonthKey(aAudioFile);

  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fFileAge := aAudioFile.FileAge;
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddAudioFileByDirectory (aAudioFile: TAudioFile);
var
  PathStructure: TStringlist;
  startIdx: Integer;

  procedure AddRecursively(idx: Integer; aCurrentCollection: TAudioFileCollection);
  var
    aCollection: TAudioFileCollection;
    newKey: String;
  begin
    if idx = (PathStructure.Count - 1) then
      aCurrentCollection.fFileList.Add(aAudioFile)
    else
    begin
      newKey := PathStructure[idx];

      if not aCurrentCollection.TryGetCollection(newKey, aCollection) then begin
        aCollection := aCurrentCollection.InitNewPathCollection(newKey);
        aCollection.fDirectory := newKey;
      end;

      inc(aCollection.fCount);
      AddRecursively(idx+1, aCollection);
    end;
  end;

begin
  PathStructure := TStringlist.create;
  try
    Explode('\', aAudioFile.Pfad, PathStructure);
    // fix network paths starting with "\\"
    if (PathStructure.Count >= 3)
      and (PathStructure[0] = '')
      and (PathStructure[1] = '')
    then begin
      PathStructure[2] := '\\' + PathStructure[2];
      startIdx := 2;
    end else
      startIdx := 0;

    if (PathStructure.Count > startIdx) then
      AddRecursively(startIdx, self)
  finally
    PathStructure.Free;
  end;
end;

procedure TAudioFileCollection.AddAudioFile(aAudioFile: TAudioFile);
begin
  inc(fCount);

  case self.fSubCollectionType of
    ctNone: begin
      fFileList.Add(aAudioFile);
      fNeedAnalysis := True;
    end;
    ctRoot: ; // should never happen
    ctArtist: AddAudioFileByArtist(aAudioFile);
    ctAlbum: AddAudioFileByAlbum(aAudioFile);
    ctDirectory: AddAudioFileByDirectory(aAudioFile);
    ctGenre: AddAudioFileByGenre(aAudioFile);
    ctDecade: AddAudioFileByDecade(aAudioFile);
    ctYear: AddAudioFileByYear(aAudioFile);
    ctFileAgeYear: AddAudioFileByFileAgeYear(aAudioFile);
    ctFileAgeMonth: AddAudioFileByFileAgeMonth(aAudioFile);
    ctPath: AddAudioFileByPath(aAudioFile);
    ctCoverID: AddAudioFileByCoverID(aAudioFile);
  end;
end;


function TAudioFileCollection.SearchAudioFileByKey(aKey: String; aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
var
  aCollection: TAudioFileCollection;
begin
  if TryGetCollection(aKey, aCollection) then
    result := aCollection.SearchAudioFile(aAudioFile, CheckExist)
  else
    result := Nil;
end;

function TAudioFileCollection.GetSubCollectionByKey(aKey: String): TAudioFileCollection;
var
  aCollection: TAudioFileCollection;
begin
  if TryGetCollection(aKey, aCollection) then
    result := aCollection
  else
    result := Nil;
end;

function TAudioFileCollection.SearchAudioFileByPath (aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
var
  PathStructure: TStringlist;
  startIdx: Integer;

  function SearchRecursively(idx: Integer; aCurrentCollection: TAudioFileCollection): TAudioFileCollection;
  var
    aCollection: TAudioFileCollection;
  begin
    if idx = (PathStructure.Count - 1) then begin
      if (not CheckExist) or aCurrentCollection.fFileList.Contains(aAudioFile) then
        result := aCurrentCollection
      else
        result := Nil;
    end
    else
    begin
      if aCurrentCollection.TryGetCollection(PathStructure[idx], aCollection) then
        result := SearchRecursively(idx+1, aCollection)
      else
        result := Nil; // not found
    end;
  end;

begin
  result := Nil;
  PathStructure := TStringlist.create;
  try
    Explode('\', aAudioFile.Pfad, PathStructure);
    // fix network paths starting with "\\"
    if (PathStructure.Count >= 3)
      and (PathStructure[0] = '')
      and (PathStructure[1] = '')
    then begin
      PathStructure[2] := '\\' + PathStructure[2];
      startIdx := 2;
    end else
      startIdx := 0;

    if (PathStructure.Count > startIdx) then
      result := SearchRecursively(startIdx, self)
  finally
    PathStructure.Free;
  end;

end;

function TAudioFileCollection.SearchAudioFile(aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
var
  aKey: String;
  dummy: Integer;
begin
  case self.fSubCollectionType of
    ctNone: begin
      if (not CheckExist) or fFileList.Contains(aAudioFile) then
        result := self
      else
        result := Nil;
    end;
    ctRoot: result := Nil; // should never happen
    ctArtist: begin
      aKey := GenerateArtistKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctAlbum: begin
      aKey := GenerateAlbumKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctDirectory: begin
      result := SearchAudioFileByPath(aAudioFile, CheckExist);
    end;
    ctGenre: begin
      aKey := GenerateGenreKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctDecade: begin
      aKey := GenerateDecadeKey(aAudioFile, dummy);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctYear:  begin
      aKey := GenerateYearKey(aAudioFile, dummy);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctFileAgeYear: begin
      aKey := GenerateFileAgeYearKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ctFileAgeMonth:  begin
      aKey := GenerateFileAgeMonthKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
  else
    result := Nil;
  end;
end;

function TAudioFileCollection.SearchEditedAudioFile(aAudioFile: TAudioFile): TAudioFileCollection;
var
  i: Integer;
begin
  result := nil;
  if fFileList.Contains(aAudioFile) then
    result := self
  else
  begin
    for i := 0 to fSubCollectionList.Count - 1 do begin
      result := fSubCollectionList[i].SearchEditedAudioFile(aAudioFile);
      if assigned(result) then
        break;
    end;
  end;
end;

procedure TAudioFileCollection.SortCollection(doRecursive: Boolean = True);
var
  i: Integer;
begin
  if fNeedSorting then begin
    case fMissingCoverMode of
      mcFirst: fSubCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := SortCollection_MissingCoverFirst(item1, item2);
                    if result = 0 then
                      result := NempCollectionComparer[fSubCollectionSorting](item1, item2);
                  end));
      mcIgnore:  fSubCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := NempCollectionComparer[fSubCollectionSorting](item1, item2);
                  end));
      mcEnd: fSubCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := SortCollection_MissingCoverLast(item1, item2);
                    if result = 0 then
                      result := NempCollectionComparer[fSubCollectionSorting](item1, item2);
                  end));
    end;

  (*
  procedure TMedienBibliothek.SortCoverList(aList: TNempCoverList);
var
  PreCoverSort, ActualCoverSort: TNempCoverCompare;
begin
  case MissingCoverMode of
    0: PreCoverSort := PreCoverSort_MissingFirst;
    2: PreCoverSort := PreCoverSort_MissingLast;
  else
    PreCoverSort := PreCoverSort_Default;
  end;

  case CoverSortorder of
    1: ActualCoverSort := ActualCoverSort_Artist;
    2: ActualCoverSort := ActualCoverSort_Album;
    3: ActualCoverSort := ActualCoverSort_Genre;
    4: ActualCoverSort := ActualCoverSort_Jahr;
    5: ActualCoverSort := ActualCoverSort_GenreYear;
    6: ActualCoverSort := ActualCoverSort_DirectoryArtist;
    7: ActualCoverSort := ActualCoverSort_DirectoryAlbum;
    8: ActualCoverSort := ActualCoverSort_FileAgeAlbum;
    9: ActualCoverSort := ActualCoverSort_FileAgeArtist;
  else
    ActualCoverSort := ActualCoverSort_Artist;
  end;

  aList.Sort(TComparer<TNempCover>.Construct( function (const item1, item2: TNempCover): Integer
    begin
      result := PreCoverSort(item1, item2);
      if result = 0 then
        result := ActualCoverSort(item1, item2);
    end));
end;

Sowas nutzen für Coverflow-RootCollection.Sort
In einer Property den PreSort-mode merken, setzen beim Create des Coverflow-Mode bzw. dem bauen der Rootcolelcitons

  *)


    //fSubCollectionList.Sort(fSubCollectionComparer);
    fNeedSorting := False;
  end;
  if doRecursive then begin
    for i := 0 to self.fSubCollectionList.Count - 1 do
      fSubCollectionList[i].SortCollection(doRecursive);
  end;
end;


procedure TAudioFileCollection.ReSortCollection(newSorting: teCollectionSorting);
begin
  // set Comparer
  // fSubCollectionComparer := GetComparer(newSorting);
  fSubCollectionSorting := newSorting;
  // sort the collection
  // fSubCollectionList.Sort(fSubCollectionComparer);
  fNeedSorting := True;
  SortCollection(False);
  fNeedSorting := False;
end;

{
  SortCollectionLevel:
  Sort a specific Layer in a RootCollection
  - Used for Non-Directory Collections
  - called by the MainForm->PopupMenu->SortLayerBy
}
procedure TAudioFileCollection.SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False);
var
  i: Integer;
begin
  if self.fLevel = aLevel then begin
    if ForceSorting then
      fNeedSorting := True;

    fSubCollectionSorting := fRootCollection.GetCollectionCompareType(aLevel);
    SortCollection(False);
    // fSubCollectionList.Sort(fSubCollectionComparer);
    fNeedSorting := False;
  end else
  begin
    for i := 0 to fSubCollectionList.Count - 1 do
      fSubCollectionList[i].SortCollectionLevel(aLevel, ForceSorting);
  end;
end;

procedure TAudioFileCollection.ReSortDirectoryCollection(newSorting: teCollectionSorting; recursive: Boolean);
var
  i: Integer;
begin
  fSubCollectionSorting := newSorting;
  fNeedSorting := True;
  SortCollection(False);
  if recursive then
    for i := 0 to fSubCollectionList.Count - 1 do
      fSubCollectionList[i].ReSortDirectoryCollection(newSorting, recursive);
end;

function TAudioFileCollection.GetSubCollection(Index: Integer): TAudioCollection;
begin
  result := fSubCollectionList[Index];
end;

function TAudioFileCollection.GetCollectionCount: Integer;
begin
  result := fSubCollectionList.Count;
end;

procedure TAudioFileCollection.DecreaseCount(recursive: Boolean);
begin
  dec(fCount);
  if recursive and (fLevel > 0) and assigned(fParentCollection) then
    fParentCollection.DecreaseCount(recursive);
end;

procedure TAudioFileCollection.RemoveAudioFile(aAudioFile: TAudioFile);
var
  aIdx: Integer;
begin
  //
  aIdx := fFileList.IndexOf(aAudioFile);
  if aIdx > -1 then begin
    fFileList.Delete(aIdx);
    DecreaseCount(True);
  end;
end;

function TAudioFileCollection.RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
var
  ac: TAudioFileCollection;
begin
  ac := SearchAudioFile(aAudioFile, True);
  if assigned(ac) then
    result := False
  else begin
    // the relevant file properties has changed
    result := True;
    ac := SearchEditedAudioFile(aAudioFile);
    if assigned(ac) then
      ac.RemoveAudioFile(aAudioFile);

    AddAudioFile(aAudioFile);
  end;
end;

function TAudioFileCollection.CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean;
var
  ac: TAudioFileCollection;
begin
  ac := SearchAudioFile(aAudioFile, True);
  result := not assigned(ac);
end;

procedure TAudioFileCollection.RemoveCollection(aCollection: TAudioFileCollection);
begin
  // trigger OnBeforeDeleteEvent
  if assigned(self.fOnBeforeDeleteCollection) then
    fOnBeforeDeleteCollection(aCollection);

  if fInsertMode = imDictionary then
    fSubCollectionDict.Remove(aCollection.fKey);

  fSubCollectionList.Remove(aCollection); // this will also free the collection

  if assigned(self.fOnAfterDeleteCollection) then
    fOnAfterDeleteCollection(aCollection);
end;

{ TRootCollection }

procedure TRootCollection.Clear;
begin
  inherited Clear;
end;

procedure TRootCollection.Reset;
begin
  clear;
  fCollectionTypeList.Clear;
  fCaptionTypeList.Clear;
end;

constructor TRootCollection.Create(aOwner: TLibraryCategory);
begin
  inherited create(aOwner, Nil, 0);
  fParentCollection := Nil;
  fRootCollection := self;
  fCollectionTypeList := TCollectionTypeList.Create;
  fCaptionTypeList := TCollectionTypeList.Create;

  fCollectionType := ctRoot;
  fSubCollectionType := ctNone;  // muss später bestimmt werden, nach dem Einfügen der SubCollectionTypes
end;

destructor TRootCollection.Destroy;
begin
  fCollectionTypeList.Free;
  fCaptionTypeList.Free;
  inherited;
end;

procedure TRootCollection.AddCaptionType(aType: TCollectionConfig);
var
  newCaptionData: TCollectionConfig;
begin
  case aType.CollectionType of
    ctNone,
    ctRoot: ; // nothing todo
    ctArtist,
    ctAlbum,
    ctDirectory,
    ctGenre: newCaptionData.CollectionType := aType.CollectionType;
    ctDecade,
    ctYear: newCaptionData.CollectionType := ctYear;
    ctFileAgeYear,
    ctFileAgeMonth: newCaptionData.CollectionType := ctFileAgeYear;
  end;

  if (fCaptionTypeList.Count = 0)
  or (fCaptionTypeList[fCaptionTypeList.Count-1].CollectionType <> newCaptionData.CollectionType)
  then
    fCaptionTypeList.Add(newCaptionData)
end;

procedure TRootCollection.AddSubCollectionType(aType: teCollectionType; aSortingType: teCollectionSorting);
var
  newData: TCollectionConfig;
begin
  newData.CollectionType := aType;
  newData.CollectionSorting := aSortingType;
  fCollectionTypeList.Add(newData);
  fSubCollectionType := fCollectionTypeList[0].CollectionType;
  fSubCollectionSorting := fCollectionTypeList[0].CollectionSorting;
  AddCaptionType(newData);
end;

procedure TRootCollection.InsertSubCollectionType(Index: Integer; aType: teCollectionType; aSortingType: teCollectionSorting);
var
  newData: TCollectionConfig;
begin
  newData.CollectionType := aType;
  newData.CollectionSorting := aSortingType;
  fCollectionTypeList.Insert(Index, newData);
  fSubCollectionType := fCollectionTypeList[0].CollectionType;
  fSubCollectionSorting := fCollectionTypeList[0].CollectionSorting;
  ReBuildCaptionTypes;
end;

procedure TRootCollection.MoveSubCollectionType(curIndex, newIndex: Integer);
begin
  fCollectionTypeList.Move(curIndex, newIndex);
  fSubCollectionType := fCollectionTypeList[0].CollectionType;
  fSubCollectionSorting := fCollectionTypeList[0].CollectionSorting;
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ChangeSubCollectionSorting(Index: Integer;
  aSortingType: teCollectionSorting);
var
  changedConfig: TCollectionConfig;
begin
  changedConfig.CollectionType := fCollectionTypeList[Index].CollectionType;
  changedConfig.CollectionSorting := aSortingType;
  fCollectionTypeList[Index] := changedConfig;

  fSubCollectionSorting := fCollectionTypeList[0].CollectionSorting;
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ChangeSubCollectionType(Index: Integer; aType: teCollectionType; aSortingType: teCollectionSorting);
var
  changedConfig: TCollectionConfig;
begin
  changedConfig.CollectionType := aType;
  changedConfig.CollectionSorting := aSortingType;

  fCollectionTypeList[Index] := changedConfig;

  //fCollectionTypeList[Index].CollectionType := aType;
  //fCollectionTypeList[Index].CollectionSorting := aSortingType;
  fSubCollectionType := fCollectionTypeList[0].CollectionType;
  fSubCollectionSorting := fCollectionTypeList[0].CollectionSorting;
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ReBuildCaptionTypes;
var
  i: Integer;
begin
  fCaptionTypeList.Clear;
  for i := 0 to fCollectionTypeList.Count-1 do
    AddCaptionType(fCollectionTypeList[i]);
end;

procedure TRootCollection.RemoveSubCollection(Layer: Integer);
begin
  // Layer entfernen, CaptionTyplist erneuern
  fCollectionTypeList.Delete(Layer);
  ReBuildCaptionTypes;
end;

function TRootCollection.GetSubCollectionType(aLevel: Integer): teCollectionType;
begin
  if (aLevel >= 0) and (aLevel < fCollectionTypeList.Count) then
    result := fCollectionTypeList[aLevel].CollectionType
  else
    result := ctNone;
end;

(*function TRootCollection.GetCollectionComparer(aLevel: Integer): TCollectionComparer;
begin
  if (aLevel >= 0) and (aLevel < fCollectionTypeList.Count) then
    result := fCollectionTypeList[aLevel].Comparer
  else
    result := CompareCollection_Default;
end;*)

function TRootCollection.GetCollectionCompareType(aLevel: Integer): teCollectionSorting;
begin
  if (aLevel >= 0) and (aLevel < fCollectionTypeList.Count) then
    result := fCollectionTypeList[aLevel].CollectionSorting
  else
    result := csDefault;
end;

function TRootCollection.GetCaption: String;
var
  i: Integer;
begin
  if fCaptionTypeList.Count > 0 then
    result := RootCaptions[fCaptionTypeList[0].CollectionType];

  for i := 1 to fCaptionTypeList.Count - 1 do
    result := result + ' - ' + RootCaptions[fCaptionTypeList[i].CollectionType];

  // result := result + ' ('  + inttostr(fLevel) + ')';
end;

function TRootCollection.GetLevelCaption(Index: Integer): String;
begin
  if (fCollectionTypeList.Count > Index) and (Index >= 0) then
    result := RootCaptionsExact[fCollectionTypeList[Index].CollectionType]
  else
    result := '';
end;

function TRootCollection.GetLayerDepth: Integer;
begin
  result := fCollectionTypeList.Count;
end;

function TRootCollection.GetIsDirectoryCollection: Boolean;
begin
  result := (fCollectionTypeList.Count > 0)
      and (fCollectionTypeList[0].CollectionType = ctDirectory);
end;


procedure TRootCollection.ResortLevel(aLevel: Integer; newSorting: teCollectionSorting);
begin
  if (aLevel < 0) or (aLevel >= fCollectionTypeList.Count) or (fCollectionTypeList[aLevel].CollectionSorting = newSorting) then
    exit; // nothing to do

  fCollectionTypeList.list[aLevel].CollectionSorting := newSorting;
  //fCollectionTypeList.list[aLevel].Comparer := GetComparer(newSorting);

  SortCollectionLevel(aLevel)
end;

procedure TRootCollection.RemoveAudioFile(aAudioFile: TAudioFile);
var
  leafCollection: TAudioFileCollection;
begin
  // get the Collection that (should) contain the AudioFile
  leafCollection := SearchAudioFile(aAudioFile, True);
  if not assigned(leafCollection) then
    exit;
  // removes the AudioFile from the leafCollection.fFilelist and decreases the Counter (also in all ParentCollections)
  leafCollection.RemoveAudioFile(aAudioFile);
end;


procedure TRootCollection.RepairDriveChars(DriveManager: TDriveManager);
var
  i: Integer;
  aDrive: TDrive;
  somethingChanged: Boolean;
begin
  if fSubCollectionType <> ctDirectory then
    exit; // nothing to do

  somethingChanged := False;
  for i := 0 to self.fSubCollectionList.Count - 1 do begin
    if fSubCollectionList[i].Key[1] <> '\' then begin
      aDrive := DriveManager.GetManagedDriveByOldChar(fSubCollectionList[i].Key[1]);
      if assigned(aDrive) and (aDrive.Drive <> '') and (aDrive.Drive[1] <> fSubCollectionList[i].Key[1]) then begin
        fSubCollectionList[i].fKey[1] := aDrive.Drive[1];
        somethingChanged := True;
      end;
    end;
  end;

  if somethingChanged then begin
    if fInsertMode = imDictionary then begin
      // refill the Dictionary, as the keys have changed
      fSubCollectionDict.Clear;
      for i := 0 to fSubCollectionList.Count - 1 do
        fSubCollectionDict.Add(fSubCollectionList[i].fKey, fSubCollectionList[i]);
    end;
  end;
end;

{ TLibraryFileCategory }

constructor TLibraryFileCategory.Create;
begin
  inherited create;

  fCategoryType := ccFiles;
end;

destructor TLibraryFileCategory.Destroy;
begin

  inherited;
end;

function TLibraryFileCategory.GetItemCount: Integer;
begin
  if fCollections.Count > 0 then
    result := TRootCollection(fCollections[0]).Count
  else
    result := 0;
end;

procedure TLibraryFileCategory.AddAudioFile(aAudioFile: TAudioFile);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count-1 do
    TRootCollection(fCollections[i]).AddAudioFile(aAudioFile);
end;

procedure TLibraryFileCategory.RemoveAudioFile(aAudioFile: TAudioFile);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count-1 do
    TRootCollection(fCollections[i]).RemoveAudioFile(aAudioFile);
end;

function TLibraryFileCategory.RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
var
  i: Integer;
begin
  result := False;
  for i := 0 to fCollections.Count-1 do
    if TRootCollection(fCollections[i]).RelocateAudioFile(aAudioFile) then
      result := True;
end;

function TLibraryFileCategory.CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean;
var
  i: Integer;
begin
  result := False;
  for i := 0 to fCollections.Count-1 do
    if TRootCollection(fCollections[i]).CollectionKeyHasChanged(aAudioFile) then
      result := True;
end;

procedure TLibraryFileCategory.RepairDriveChars(DriveManager: TDriveManager);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count-1 do
    TRootCollection(fCollections[i]).RepairDriveChars(DriveManager);
end;

procedure TLibraryFileCategory.RememberLastCollection(aCollection: TAudioCollection);
var
  ac: TAudioCollection;
  afc: TAudioFileCollection;
begin
  fLastSelectedCollectionData.Clear;

  afc := TAudioFileCollection(aCollection);
  fLastSelectedCollectionData.RootIndex := fCollections.IndexOf(afc.fRootCollection);

  while assigned(afc.fParentCollection) do begin
    fLastSelectedCollectionData.AddKey(afc.Key);
    afc := afc.fParentCollection;
  end;
end;

function TLibraryFileCategory.FindLastCollectionAgain: TAudioCollection;
var
  subColl, resultColl: TAudioFileCollection;
  i: Integer;
begin
  result := Nil;
  if (fLastSelectedCollectionData.RootIndex > -1)
     and (fLastSelectedCollectionData.RootIndex < fCollections.Count)
  then begin
    // result: RootCollection
    resultColl := TAudioFileCollection(fCollections[fLastSelectedCollectionData.RootIndex]);

    for i := fLastSelectedCollectionData.KeyCount - 1 downto 0 do begin
      subColl := resultColl.GetSubCollectionByKey(fLastSelectedCollectionData.Keys[i]);
      if assigned(subColl) then
        resultColl := subColl
      else
        break;
    end;

    result := resultColl;
  end;
end;


{procedure TLibraryFileCategory.Reset;
var
  i: Integer;
begin
  Clear;
  for i := fCollections.Count-1 downto 0 do
    fCollections.Delete(i);
end;}

(*function TLibraryFileCategory.AddRootCollection: TRootCollection;
var
  newCollection: TRootCollection;
begin
  newCollection := TRootCollection.Create;
  fCollections.Add(newCollection);
  result := newCollection;
end;*)

function TLibraryFileCategory.AddRootCollection(
  const Properties: Array of teCollectionType; const Sortings: Array of teCollectionSorting): TRootCollection;
var
  i, maxSort: Integer;

  newRoot: TRootCollection;
begin
  newRoot := TRootCollection.Create(self);
  maxSort := length(Sortings) - 1;

  for i := 0 to length(Properties) - 1 do
    if i <= maxSort then
      newRoot.AddSubCollectionType(Properties[i], Sortings[i])
    else
      newRoot.AddSubCollectionType(Properties[i], csDefault);

  fCollections.Add(newRoot);
  result := newRoot;
end;

function TLibraryFileCategory.AddRootCollection(
  aRootConfig: TCollectionTypeList): TRootCollection;
var
  i: Integer;
begin
  result := TRootCollection.Create(self);
  for i := 0 to aRootConfig.Count - 1 do begin
    result.AddSubCollectionType(aRootConfig[i].CollectionType, aRootConfig[i].CollectionSorting);
  end;

  fCollections.Add(result);
end;

initialization

fLibraryFormatSettings := TFormatSettings.Create;

//KeyCache.RawAlbum := '';
KeyCache.RawDirectory := '';
// KeyCache.ProcessedAlbum := '';
KeyCache.ProcessedDirectory := '';

(*
SortCollection_Default := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
end);

SortCollection_Album := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
end);

SortCollection_ArtistAlbum := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
end);

SortCollection_Count := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := CompareValue(item2.Count, item1.Count);
end);

SortCollection_Year := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := CompareValue(item1.fYear, item2.fYear);
end);

SortCollection_FileAge := TComparer<TAudioFileCollection>.Construct( CompareCollection_FileAge);

{function (const item1,item2: TAudioFileCollection): Integer
begin
  result := CompareValue(Item2.fFileAge, Item1.fFileAge);
end);}

SortCollection_Genre := TComparer<TAudioFileCollection>.Construct( function (const item1,item2: TAudioFileCollection): Integer
begin
  result := AnsiCompareText_NempIgnoreCase(Item2.Genre, Item1.Genre);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
  if result = 0 then
    result := AnsiCompareText_NempIgnoreCase(item1.fAlbum, item2.fAlbum);
end);
*)



end.
