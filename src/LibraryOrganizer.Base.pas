unit LibraryOrganizer.Base;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, DriveRepairTools,
  NempAudioFiles, NempFileUtils, Nemp_ConstantsAndTypes, Nemp_RessourceStrings;

resourcestring
  rsCollectionDataUnknown = '-?-';

  rsDefaultCategoryAll = 'Music';
  rsDefaultCategoryNew = 'Recently added';
  rsDefaultCategoryAudioBook = 'Audio books';
  rsDefaultCategoryPlaylist = 'Playlists';
  rsDefaultCategoryFavPlaylist = 'Favourite playlists';
  rsDefaultCategoryWebradio = 'Webradio';

  rsNewCategoryName = 'New category';

const
  MAX_LIST_SIZE = 5;

  MP3DB_CAT_NAME = 1;
  MP3DB_CAT_INDEX = 2;
  MP3DB_CAT_SORTINDEX = 3;
  MP3DB_CAT_TAG = 4;
  MP3DB_CAT_ISDEFAULT = 5;
  MP3DB_CAT_ISNEW = 6;

const
  DefaultCategories: Array [0..1] of String = ('c0d0', 'e0');


type
  // Difference between ctDirectory and ctPath:
  // - ctDirectory creates a subcollection for every folder on the path, simulating the actual file system on the disk
  // - ctPath uses just the Path (without the Filename) as a Key. Used to get the "common directory" during analysis of a collection
  teCollectionType = (ctNone, ctRoot, ctArtist, ctAlbum, ctDirectory, ctGenre, ctDecade, ctYear, ctFileAgeYear, ctFileAgeMonth,
      ctPath, ctCoverID); // the last 2 are just for internal use
  teCollectionSorting = (csDefault, csAlbum, csArtistAlbum, csCount, csYear, csFileAge, csGenre, csDirectory);

  teMissingCoverPreSorting = (mcFirst, mcIgnore, mcEnd);

  TCollectionConfig = record
    CollectionType: teCollectionType; // a..l
    CollectionSorting: teCollectionSorting; // 0..7
  end;

  TCollectionTypeList = class(TList<TCollectionConfig>);
  // TRootCollectionConfig = Array of TCollectionConfig;  // save as ([a..j][0..5])*
  // Note: The Medialibrary will load an "Array of TCollectionTypeList" from the settings-inifile
  // to initialise the Collections in the FileCategories


  teInsertMode = (imList, imDictionary);
  teCollectionUniqueness = (cuUnique, cuSampler, cuInvalid);
  teCollectionClass = (ccFiles, ccPlaylists, ccWebStations);
  teAlbumKeyMode = (akAlbumOnly, akAlbumArtist, akAlbumDirectory, akDirectoryOnly, akCoverID);
  tePlaylistCaptionMode = (pcmFilename, pcmFolder, pcmPath);
  teCoverState = (csUnchecked, csInValid, csOK, csMissing);

const
  //TypStrings: Array[teCollectionType] of String = (
  //'ctNone', 'ctRoot', 'ctArtist', 'ctAlbum', 'ctDirectory', 'ctGenre', 'ctDecade', 'ctYear', 'ctFileAgeYear', 'ctFileAgeMonth',
  //'ctPath', 'ctCoverID');

  RootCaptions: Array[teCollectionType] of String = (
    rsCollectionDataUnknown, rsCollectionDataUnknown,
    TreeHeader_Artists, TreeHeader_Albums,
    TreeHeader_Directories, TreeHeader_Genres,
    TreeHeader_Years, TreeHeader_Years,
    TreeHeader_FileAges, TreeHeader_FileAges,
    TreeHeader_Directories, 'CoverID' // the last 2 are just for internal use
  );

  RootCaptionsExact: Array[teCollectionType] of String = (
    rsCollectionDataUnknown, rsCollectionDataUnknown,
    TreeHeader_Artists, TreeHeader_Albums,
    TreeHeader_Directories, TreeHeader_Genres,
    TreeHeader_Decades, TreeHeader_Years,
    TreeHeader_FileAges, TreeHeader_FileAgesMonth,
    TreeHeader_Directories, 'CoverID' // the last 2 are just for internal use
  );

  CollectionSortingNames: Array[teCollectionSorting] of String = (
    CollectionSorting_Default, CollectionSorting_ByAlbum, CollectionSorting_ByArtistAlbum,
    CollectionSorting_ByCount, CollectionSorting_ByYear, CollectionSorting_ByFileAge,
    CollectionSorting_ByGenre, CollectionSorting_ByDirectory
  );

  //teCollectionSorting = (csDefault, csAlbum, csArtistAlbum, csCount, csYear, csFileAge, csGenre, csDirectory);

type

  TOrganizerSettings = class
    private
      //fGroupYearsByDecade   : Boolean;
      //fGroupFileAgeByYear   : Boolean;
      fAlbumKeyMode: teAlbumKeyMode;
      fPlaylistCaptionMode: tePlaylistCaptionMode;
      fTrimCDFromDirectory: Boolean;
      fCDNames: TStringList;
      fShowCollectionCount: Boolean;
      fShowCoverArtOnAlbum: Boolean;
      fDefaultRootCollectionConfig: TCollectionTypeList; //TRootCollectionConfig;
      fCoverFlowRootCollectionConfig: TCollectionTypeList; //TRootCollectionConfig;
      fCategoryConfig: Array of TCollectionTypeList; //TRootCollectionConfig;

      procedure ClearCategoryConfig;
      function GetRootCollectionConfig(Index: Integer): TCollectionTypeList; //TRootCollectionConfig;

      //procedure InitDefaultRootCollections;
      function GetRootCollectionCount: Integer;
    public
      //property GroupYearsByDecade   : Boolean read fGroupYearsByDecade   write fGroupYearsByDecade   ;
      //property GroupFileAgeByYear   : Boolean read fGroupFileAgeByYear   write fGroupFileAgeByYear   ;
      property ShowCollectionCount  : Boolean read fShowCollectionCount write fShowCollectionCount;
      property ShowCoverArtOnAlbum  : Boolean read fShowCoverArtOnAlbum write fShowCoverArtOnAlbum;
      property AlbumKeyMode: teAlbumKeyMode read fAlbumKeyMode write fAlbumKeyMode;
      property PlaylistCaptionMode: tePlaylistCaptionMode read fPlaylistCaptionMode write fPlaylistCaptionMode;
      property TrimCDFromDirectory: Boolean read fTrimCDFromDirectory write fTrimCDFromDirectory;
      property CDNames: TStringList read fCDNames;

      property RootCollectionCount: Integer read GetRootCollectionCount;
      property RootCollectionConfig[Index: Integer]: TCollectionTypeList {TRootCollectionConfig} read GetRootCollectionConfig;
      property CoverFlowRootCollectionConfig: TCollectionTypeList {TRootCollectionConfig} read fCoverFlowRootCollectionConfig;

      constructor create;
      destructor Destroy; override;
      procedure Clear;

      procedure Assign(Source: TOrganizerSettings);
      procedure LoadSettings;
      procedure SaveSettings;
      procedure AddConfig(newConfig: TCollectionTypeList);

      procedure ChangeFileCollectionSorting(RCIndex, Layer: Integer; newSorting: teCollectionSorting);
      procedure ChangeCoverFlowSorting(newSorting: teCollectionSorting);

  end;

  TCollectionKeyData = record  // ggf. entschlacken? Den Typ wieder entfernen?
    Artist,
    Album,
    Genre,
    Directory,
    CoverID,
    Key: String;
    Year: Integer;
    FileAge: TDateTime;
  end;

  //TAudioCollection = class;
  //TAudioCollectionNotifyEvent = procedure(Sender: TAudioCollection) of object;

  TLibraryCategory = class;

  TAudioCollectionList = class;

  TAudioCollection = class
    private

    protected
      fCollectionClass: teCollectionClass;
      fOwnerCategory: TLibraryCategory;
      fArchiveList: TAudioCollectionList;
      fArchiveID: Integer;
      fCount: Integer;
      fKey: String;
      function GetCaption: String; virtual; abstract;
      function GetSimpleCaption: String; virtual; abstract;
      function GetCoverID: String; virtual; abstract;
      function GetSubCollection(Index: Integer): TAudioCollection; virtual; abstract;
      function GetCollectionCount: Integer; virtual; abstract;

      procedure DoGetFiles(dest: TAudioFileList; recursive: Boolean); virtual; abstract;
      procedure DoChangeCoverIDAfterDownload(newID: String); virtual; abstract;
    public
      property ArchiveID: Integer read fArchiveID;
      property Key: String read fKey;
      property Count: Integer read fCount;
      property Caption: String read GetCaption;
      property SimpleCaption: String read GetSimpleCaption;
      property CoverID: String read GetCoverID;
      // property KeyData: TCollectionKeyData read fKeyData;
      property CollectionClass: teCollectionClass read fCollectionClass;

      property CollectionCount: Integer read GetCollectionCount;
      property SubCollections[Index: Integer]: TAudioCollection read GetSubCollection;

      constructor Create(aOwner: TLibraryCategory);
      destructor Destroy; override;

      procedure Clear; virtual; abstract;
      procedure RemoveEmptyCollections; virtual; abstract;
      procedure Empty; virtual; abstract;
      procedure GetFiles(dest: TAudioFileList; recursive: Boolean);
      procedure Analyse(recursive: Boolean); virtual; abstract;

      procedure SortCollection(doRecursive: Boolean = True); virtual; abstract;
      procedure ReSortCollection(newSorting: teCollectionSorting); virtual; abstract;
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); virtual; abstract;

      function MatchPrefix(aPrefix: String): Boolean; virtual; abstract;
      function ComparePrefix(aPrefix: String): Integer; virtual; abstract;

      function GetCollectionIndex(aCollection: TAudioCollection): Integer; virtual; abstract;

      // for Coverdownloads we need to remember a collection for some time
      // and we need access to this collection after the download is complete. For that, we
      // "archive" the collection in a simple list, where it can be found much faster than
      // in the complete Category-Tree.
      // The Destructor will remove it from this Archive, if needed.
      // Disregard will remove it from the Archive
      procedure Archive(ArchiveList: TAudioCollectionList; ID: Integer);
      procedure Disregard;

      procedure ApplyNewCoverID(newID: String);

  end;

  TAudioCollectionList = class(TObjectList<TAudioCollection>);



  (*

  TAudioWebStreamCollection = class(TAudioCollection)
  private
      function GetCaption: String; override;
    public
      constructor Create(aStationName: String); // vermutlich anderer Typ, oder mehr parameter
      destructor Destroy; override;

      procedure GetFiles(dest: TAudioFileList; recursive: Boolean); override;   // im grunde NIX
      procedure GetCommonInformation(recursive: Boolean); override;   // im grunde NIX

  end;

  TAudioWebStreamCollectionList = class(TObjectList<TAudioWebStreamCollection>);

  TRootWebStreamCollection = class(TAudioCollection) // Das muss keine Collection sein. Das ist auf dem Level "Category"
    private
      fWebStreams: TAudioWebStreamCollectionList;
    public
      constructor Create;
      destructor Destroy; override;
      procedure AddStation(aPlaylistFile: String); // vermutlich anderer Typ, oder mehr parameter
  end;
*)
  ///////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////

  TAudioCollectionNotifyEvent = procedure(Sender: TAudioCollection) of object;

  TCollectionMetaInfo = class
    private
      fKeyPath: TStringList;
      // fCollectionLink: TAudioCollection; // may become invalid over time ...
      fRootIndex: Integer;

      function GetKey(Index: Integer): String;
      function GetKeyCount: Integer;
    public
      property RootIndex: Integer read fRootIndex write fRootIndex;
      property Keys[Index: Integer]: String read GetKey;
      property KeyCount: Integer read GetKeyCount;

      constructor Create;
      destructor Destroy; override;
      procedure Clear;

      procedure Assign(aInfo: TCollectionMetaInfo);
      procedure AddKey(aKey: String);

      procedure LoadSettings;
      procedure SaveSettings;
  end;


  TLibraryCategory = class
    private
      fName: String;
      fCaptionMode: Integer; // Only used in PlaylistCategory
      fIsDefault: Boolean;
      fIsNew: Boolean;

      function GetCollection(Index: Integer): TAudioCollection;
      function GetCollectionCount: Integer;
      function GetNameCount: String;

    protected
      // Category.Collections:
      // For Files, this is a predefined List of TRootCollections, like "Music", "New stuff", "Earbooks"
      // For Category Playlists/Webradio, it is the list of Playlists/Webradio-Stations, in form of a TAudioCollection
      fCollections: TAudioCollectionList;

      fLastSelectedCollectionData: TCollectionMetaInfo;
      //fLastSelectedCollection: TAudioCollection;

      fIndex: Byte;     // for the Bitmask-property in Audiofiles, 0..32
      fSortIndex: Byte; // for the sort order in the treeview (= Index in the CategoryList)
      fCategoryType: teCollectionClass;

      function GetItemCount: Integer; virtual; abstract;
    public
      property Name: String read fName write fName;
      property CategoryType: teCollectionClass read fCategoryType;

      property IsDefault: Boolean read fIsDefault write fIsDefault;
      property IsNew    : Boolean read fIsNew     write fIsNew    ;

      property Index: Byte read fIndex write fIndex;
      property SortIndex: Byte read fSortIndex write fSortIndex;
      property CaptionMode: Integer read fCaptionMode write fCaptionMode;
      property ItemCount: Integer read GetItemCount;
      property CollectionCount: Integer read GetCollectionCount;
      property Collections[Index: Integer]: TAudioCollection read GetCollection;
      function IndexOf(Index: TAudioCollection): Integer;

      property LastSelectedCollectionData: TCollectionMetaInfo read fLastSelectedCollectionData;
      // property LastSelectedCollection: TAudioCollection read fLastSelectedCollection;

      property NameCount: String read GetNameCount;

      constructor Create;
      destructor Destroy; override;
      procedure Clear; virtual;

      procedure AssignSettings(Source: TLibraryCategory);

      // sorting the collections stored in fCollections,
      // but NOT fCollections itself!
      procedure SortCollections(doRecursive: Boolean = True); virtual;
      procedure AnalyseCollections(recursive: Boolean); virtual;
      procedure RemoveEmptyCollections; virtual;

      procedure RepairDriveChars(DriveManager: TDriveManager); virtual; abstract;

      procedure RememberLastCollection(aCollection: TAudioCollection); virtual; abstract;
      function FindLastCollectionAgain: TAudioCollection; virtual; abstract;

      procedure LoadFromStream(aStream: TStream); virtual;
      function SaveToStream(aStream: TStream): LongInt; virtual;
  end;



  // the complete MediaLibrary is separated into Categories (like "music, earbooks, recently added" or whatever
  // also, there may be more than one Category for Playlists
  TLibraryCategoryList = class(TObjectList<TLibraryCategory>);

  (*
    Wie das abbilden:
    [ 1 ] Playlists
          Webradio
       -> Medialibrary   (folgend: "Sub-Bibliotheken, Kategorien")
            - AudioBooks
            - News
            - TestFiles
    ----------------------------
    [ 2 ] Directories
            - c:\
              - Musik\
                 - Alben\
                 - Sampler\
          Artist-Album
            - Nightwish
              - Decades
              - Human:Nature
            - Xandria
              - ..
              - ..
    Dabei: Falls bei [1] MediaLibrary ausgwählt ist, sollen unten die Items (=AudioCollections) von
           allen Kategorien (inkl. ohne Kategorie) aufgelistet werden
           Probleme: "Kategorie" wird File-spezifisch, nicht "Collection-spezifisch" (das macht ja gar keinen Sinn)
                     d.h. Collection-Keys können sich überschneiden, auch wenn die Files selber disjunkt verteilt sind.
                     d.h. man müsste sowohl die Collection-Objekte mergen, als auch jeweils die Files
                     => ÖRGS.
           => Besser: "Medialibrary" und die "Kategorien" gleich behandeln, und die Files ggf. doppelt einsortieren
              Aber nö. Dann kann ich "TestFiles" nicht einfach aussortieren.
              Daher: Disjunkte Aufteilung, Default-Kategorie "Musik",  keine Möglichkeit für "Alles durchbrowsen"

  *)



  function GetDefaultCategory(aList: TLibraryCategoryList): TLibraryCategory;
  function GetDefaultCategoryIndex(aList: TLibraryCategoryList): Integer;

  procedure SetDefaultCategory(aList: TLibraryCategoryList; defaultCat: TLibraryCategory);
  procedure SetDefaultCategoryIndex(aList: TLibraryCategoryList; defaultIndex: Integer);

  function GetNewCategory(aList: TLibraryCategoryList): TLibraryCategory;
  function GetNewCategoryIndex(aList: TLibraryCategoryList): Integer;
  procedure SetNewCategory(aList: TLibraryCategoryList; newCat: TLibraryCategory);
  procedure SetNewCategoryIndex(aList: TLibraryCategoryList; newIndex: Integer);



  function NempOrganizerSettings: TOrganizerSettings;
  procedure IniStrToRootConfig(aString: String; Dest: TCollectionTypeList);

  function RootConfigToIniStr(aConfig: TCollectionTypeList): String;

  procedure AddConfigToList(Dest: TCollectionTypeList; newType: teCollectionType; newSorting: teCollectionSorting);


implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper;

var
  fNempOrganizerSettings: TOrganizerSettings;


function NempOrganizerSettings: TOrganizerSettings;
begin
  if not assigned(fNempOrganizerSettings) then
    fNempOrganizerSettings := TOrganizerSettings.Create;
  result := fNempOrganizerSettings;
end;



procedure IniStrToRootConfig(aString: String; Dest: TCollectionTypeList);
var
  i, configDepth: Integer;
begin
  configDepth := Length(aString) Div 2;

  //Setlength(result, configDepth);
  for i := 0 to configDepth-1 do begin
    AddConfigToList(Dest,
        teCollectionType(ord(aString[2*i+1]) - ord('a')),
        teCollectionSorting(StrToIntDef(aString[2*i+2], 0))
    );
    // result[i].CollectionType := teCollectionType(ord(aString[2*i+1]) - ord('a'));
    // result[i].CollectionSorting := teCollectionSorting(StrToIntDef(aString[2*i+2], 0));
  end;
end;

function RootConfigToIniStr(aConfig: TCollectionTypeList): String;
var
  i, configDepth: Integer;
begin
  configDepth := aConfig.Count;// Length(aConfig);

  result := '';
  for i := 0 to configDepth-1 do begin
    result := result
              + chr(Integer(aConfig[i].CollectionType) + ord('a'))
              + IntToStr(Integer(aConfig[i].CollectionSorting));
  end;
end;


function GetDefaultCategory(aList: TLibraryCategoryList): TLibraryCategory;
var
  idx: Integer;
begin
  idx := GetDefaultCategoryIndex(aList);
  if idx >= 0 then
    result := aList[idx]
  else
    result := Nil;
end;

function GetDefaultCategoryIndex(aList: TLibraryCategoryList): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to aList.Count - 1 do begin
    if aList[i].fIsDefault then begin
      result := i;
      break;
    end;
  end;
end;

procedure SetDefaultCategory(aList: TLibraryCategoryList; defaultCat: TLibraryCategory);
var
  i: Integer;
begin
  for i := 0 to aList.Count - 1 do
    aList[i].fIsDefault := aList[i] = defaultCat;
end;

procedure SetDefaultCategoryIndex(aList: TLibraryCategoryList; defaultIndex: Integer);
var
  i: Integer;
begin
  if (defaultIndex >= 0) and (defaultIndex < aList.Count) then begin
    for i := 0 to aList.Count - 1 do
      aList[i].fIsDefault := False;
    // Set new index
    aList[defaultIndex].fIsDefault := True;
  end;
end;


function GetNewCategory(aList: TLibraryCategoryList): TLibraryCategory;
var
  idx: Integer;
begin
  idx := GetNewCategoryIndex(aList);
  if idx >= 0 then
    result := aList[idx]
  else
    result := Nil;
end;

function GetNewCategoryIndex(aList: TLibraryCategoryList): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to aList.Count - 1 do begin
    if aList[i].fIsNew then begin
      result := i;
      break;
    end;
  end;
end;

procedure SetNewCategory(aList: TLibraryCategoryList; newCat: TLibraryCategory);
var
  i: Integer;
begin
  for i := 0 to aList.Count - 1 do
    aList[i].fIsNew := aList[i] = newCat;
end;

procedure SetNewCategoryIndex(aList: TLibraryCategoryList; newIndex: Integer);
var
  i: Integer;
begin
  if (newIndex >= 0) and (newIndex < aList.Count) then begin
    for i := 0 to aList.Count - 1 do
      aList[i].fIsNew := False;
    // Set new index
    aList[newIndex].fIsNew := True;
  end;
end;

procedure AddConfigToList(Dest: TCollectionTypeList; newType: teCollectionType; newSorting: teCollectionSorting);
var
  newData: TCollectionConfig;
begin
  newData.CollectionType := newType;
  newData.CollectionSorting := newSorting;
  Dest.Add(newData);
end;


{ TOrganizerSettings }

constructor TOrganizerSettings.create;
begin
  inherited create;

  fCDNames := TStringList.Create;
  fCDNames.Delimiter := ',';
  fCDNames.StrictDelimiter := True;
  fCDNames.Add('CD');
  AlbumKeyMode := akAlbumDirectory;  //akCoverID; //akDirectoryOnly; //akAlbumDirectory;
  PlaylistCaptionMode := pcmFolder; //pcmPath; //pcmFilename; //pcmFolder;

  fTrimCDFromDirectory := True;

  fShowCollectionCount := True;
  fShowCoverArtOnAlbum := True;

 { fDefaultRootCollectionConfig: TCollectionTypeList; //TRootCollectionConfig;
      fCoverFlowRootCollectionConfig: TCollectionTypeList; //TRootCollectionConfig;
      fCategoryConfig: Array of TCollectionTypeList; //TRootCollectionConfig;
  }


  fCoverFlowRootCollectionConfig := TCollectionTypeList.Create;
  fDefaultRootCollectionConfig := TCollectionTypeList.Create;

  // Default-RootCollectionConfig (as a final Fallback)
  AddConfigToList(fDefaultRootCollectionConfig, ctArtist, csDefault);
  AddConfigToList(fDefaultRootCollectionConfig, ctAlbum, csDefault);
  {SetLength(fDefaultRootCollectionConfig, 2);
  fDefaultRootCollectionConfig[0].CollectionType := ctArtist;
  fDefaultRootCollectionConfig[1].CollectionType := ctAlbum;
  fDefaultRootCollectionConfig[0].CollectionSorting := csDefault;
  fDefaultRootCollectionConfig[1].CollectionSorting := csDefault;  }

end;

destructor TOrganizerSettings.Destroy;
begin
  ClearCategoryConfig;
  fCDNames.Free;
  fCoverFlowRootCollectionConfig.Free;
  fDefaultRootCollectionConfig.Free;
  inherited;
end;

procedure TOrganizerSettings.Clear;
begin
  ClearCategoryConfig;
  fCDNames.clear;
end;

procedure TOrganizerSettings.ClearCategoryConfig;
var
  i: Integer;
begin
  for i := 0 to Length(fCategoryConfig) - 1 do
    fCategoryConfig[i].Free;

  SetLength(fCategoryConfig, 0);
end;

procedure TOrganizerSettings.Assign(Source: TOrganizerSettings);
var
  i, iRC: Integer;
begin
  fAlbumKeyMode        := Source.fAlbumKeyMode;
  fPlaylistCaptionMode := Source.fPlaylistCaptionMode;
  fTrimCDFromDirectory := Source.fTrimCDFromDirectory;
  fCDNames.Assign(Source.fCDNames);
  fShowCollectionCount := Source.fShowCollectionCount;
  fShowCoverArtOnAlbum := Source.fShowCoverArtOnAlbum;

  // assign CategoryConfig
  ClearCategoryConfig;
  SetLength(fCategoryConfig, Length(Source.fCategoryConfig));
  for iRC := 0 to Length(fCategoryConfig) -1  do begin
    fCategoryConfig[iRC] := TCollectionTypeList.Create;
    // SetLength(fCategoryConfig[iRC], Length(Source.fCategoryConfig[iRC]));

    for i := 0 to Source.fCategoryConfig[iRC].Count - 1 do begin
      AddConfigToList(
        fCategoryConfig[iRC],
        Source.fCategoryConfig[iRC][i].CollectionType,
        Source.fCategoryConfig[iRC][i].CollectionSorting
      );
      //fCategoryConfig[iRC][i].CollectionType := Source.fCategoryConfig[iRC][i].CollectionType;
      //fCategoryConfig[iRC][i].CollectionSorting := Source.fCategoryConfig[iRC][i].CollectionSorting;
    end;
  end;

  // assign DefaultRootConfig
  //SetLength(fDefaultRootCollectionConfig, Length(Source.fDefaultRootCollectionConfig));
  fDefaultRootCollectionConfig.Clear;
  for i := 0 to Source.fDefaultRootCollectionConfig.Count - 1 do begin
    AddConfigToList(
        fDefaultRootCollectionConfig,
        Source.fDefaultRootCollectionConfig[i].CollectionType,
        Source.fDefaultRootCollectionConfig[i].CollectionSorting
      );
    //fDefaultRootCollectionConfig[i].CollectionType := Source.fDefaultRootCollectionConfig[i].CollectionType;
    //fDefaultRootCollectionConfig[i].CollectionSorting := Source.fDefaultRootCollectionConfig[i].CollectionSorting;
  end;

  // assign CoverFlowConfig
  fCoverFlowRootCollectionConfig.Clear;
  // SetLength(fCoverFlowRootCollectionConfig, Length(Source.fCoverFlowRootCollectionConfig));
  for i := 0 to Source.fCoverFlowRootCollectionConfig.Count - 1 do begin
    AddConfigToList(
        fCoverFlowRootCollectionConfig,
        Source.fCoverFlowRootCollectionConfig[i].CollectionType,
        Source.fCoverFlowRootCollectionConfig[i].CollectionSorting
      );

    //fCoverFlowRootCollectionConfig[i].CollectionType := Source.fCoverFlowRootCollectionConfig[i].CollectionType;
    //fCoverFlowRootCollectionConfig[i].CollectionSorting := Source.fCoverFlowRootCollectionConfig[i].CollectionSorting;
  end;
end;

procedure TOrganizerSettings.AddConfig(newConfig: TCollectionTypeList);
var
  lastIndex, i: Integer;
begin
  SetLength(fCategoryConfig, Length(fCategoryConfig) + 1);
  lastIndex := Length(fCategoryConfig) - 1;
  fCategoryConfig[lastIndex] := TCollectionTypeList.Create;
  for i := 0 to newConfig.Count - 1 do
    AddConfigToList(
      fCategoryConfig[lastIndex],
      newConfig[i].CollectionType,
      newConfig[i].CollectionSorting
    );
end;


procedure TOrganizerSettings.ChangeFileCollectionSorting(RCIndex,
  Layer: Integer; newSorting: teCollectionSorting);
var
  ChangedData: TCollectionConfig;
begin
  if (RCIndex >= RootCollectionCount) then
    exit;
  if RootCollectionConfig[RCIndex].Count = 0 then
    exit;

  ChangedData.CollectionSorting := newSorting;

  if RootCollectionConfig[RCIndex][0].CollectionType = ctDirectory then begin
    ChangedData.CollectionType := ctDirectory;
    RootCollectionConfig[RCIndex][0] := ChangedData;
  end
  else begin
    if RootCollectionConfig[RCIndex].Count >= Layer then begin
      ChangedData.CollectionType := RootCollectionConfig[RCIndex][Layer].CollectionType;
      RootCollectionConfig[RCIndex][Layer] := ChangedData;
    end;
  end;
end;

procedure TOrganizerSettings.ChangeCoverFlowSorting(
  newSorting: teCollectionSorting);
var
  ChangedData: TCollectionConfig;
begin
  ChangedData.CollectionSorting := newSorting;

  if CoverFlowRootCollectionConfig.Count > 0 then
    ChangedData.CollectionType := CoverFlowRootCollectionConfig[0].CollectionType
  else
    ChangedData.CollectionType := ctAlbum;

  CoverFlowRootCollectionConfig.Clear;
  CoverFlowRootCollectionConfig.Add(ChangedData);
end;


function TOrganizerSettings.GetRootCollectionCount: Integer;
begin
  result := length(fCategoryConfig);
end;

function TOrganizerSettings.GetRootCollectionConfig(
  Index: Integer): TCollectionTypeList;
begin
  if (Index < 0) or (Index > length(fCategoryConfig)) then begin
    result := fDefaultRootCollectionConfig
  end else
  begin
    result := fCategoryConfig[Index];
  end;
end;

{ // (Test code)
procedure TOrganizerSettings.InitDefaultRootCollections;
begin
  SetLength(fCategoryConfig, 2);
  SetLength(fCategoryConfig[0], 2);
  fCategoryConfig[0][0].CollectionType := ctArtist;
  fCategoryConfig[0][0].CollectionSorting := csDefault;
  fCategoryConfig[0][1].CollectionType := ctAlbum;
  fCategoryConfig[0][1].CollectionSorting := csDefault;
  SetLength(fCategoryConfig[1], 1);
  fCategoryConfig[1][0].CollectionType := ctDirectory;
  fCategoryConfig[1][0].CollectionSorting := csDefault;
end;}

procedure TOrganizerSettings.LoadSettings;
var
  categoryString, defStr: String;
  i, categoryCount: Integer;
begin
  // xx := NempSettingsManager.ReadBool('Allgemein', 'RegisterHotKeys', False);

  categoryCount := NempSettingsManager.ReadInteger('LibraryOrganizer', 'RootCount', 2);
  if categoryCount = 0 then
    categoryCount := 1;
  if categoryCount > 5 then
    categoryCount := 5;

  ClearCategoryConfig;
  SetLength(fCategoryConfig, categoryCount);
  for i := 0 to categoryCount-1 do begin
    fCategoryConfig[i] := TCollectionTypeList.Create;
    if i <= 1 then
      defStr := DefaultCategories[i]
    else
      defStr := 'e0';
    categoryString := NempSettingsManager.ReadString('LibraryOrganizer', 'Root'+IntToStr(i), defStr);
    IniStrToRootConfig(categoryString, fCategoryConfig[i]);
  end;
  // Configuration des Coverflow
  // note: Only "d" makes sense here (=Album)
  categoryString := NempSettingsManager.ReadString('LibraryOrganizer', 'CoverflowConfig', 'd5');
  IniStrToRootConfig(categoryString, fCoverFlowRootCollectionConfig);

  fAlbumKeyMode := teAlbumKeyMode(NempSettingsManager.ReadInteger('LibraryOrganizer', 'AlbumKeyMode', Integer(akAlbumDirectory)));
  fPlaylistCaptionMode := tePlaylistCaptionMode(NempSettingsManager.ReadInteger('LibraryOrganizer', 'PlaylistCaptionMode', Integer(pcmFilename)));
  fTrimCDFromDirectory := NempSettingsManager.ReadBool('LibraryOrganizer', 'TrimCDFromDirectory', True);
  fCDNames.DelimitedText := NempSettingsManager.ReadString('LibraryOrganizer', 'CDNames', 'CD');

  fShowCollectionCount := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCollectionCount', True);
  fShowCoverArtOnAlbum := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCoverArtOnAlbum', True);
end;

procedure TOrganizerSettings.SaveSettings;
var
  i, categoryCount: Integer;
begin
  categoryCount := Length(fCategoryConfig);
  NempSettingsManager.WriteInteger('LibraryOrganizer', 'RootCount', categoryCount);
  for i := 0 to categoryCount-1 do begin
    NempSettingsManager.WriteString('LibraryOrganizer', 'Root'+IntToStr(i), RootConfigToIniStr(fCategoryConfig[i]) );
  end;
  NempSettingsManager.WriteString('LibraryOrganizer', 'CoverflowConfig', RootConfigToIniStr(fCoverFlowRootCollectionConfig) );

  NempSettingsManager.WriteInteger('LibraryOrganizer', 'AlbumKeyMode', Integer(fAlbumKeyMode));
  NempSettingsManager.WriteInteger('LibraryOrganizer', 'PlaylistCaptionMode', Integer(fPlaylistCaptionMode));
  NempSettingsManager.WriteBool('LibraryOrganizer', 'TrimCDFromDirectory', fTrimCDFromDirectory);
  NempSettingsManager.WriteString('LibraryOrganizer', 'CDNames', fCDNames.DelimitedText);
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCollectionCount', fShowCollectionCount);
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCoverArtOnAlbum', fShowCoverArtOnAlbum);
end;

{ TLibraryCategory }

constructor TLibraryCategory.Create;
begin
  fCollections := TAudioCollectionList.Create(True);
  fIsDefault := False;
  fIsNew := False;
  fLastSelectedCollectionData := TCollectionMetaInfo.Create;
end;

destructor TLibraryCategory.Destroy;
begin
  fCollections.Free;
  fLastSelectedCollectionData.Free;
  inherited;
end;

procedure TLibraryCategory.AssignSettings(Source: TLibraryCategory);
begin
  Name := Source.Name;
  Index := Source.Index;
  SortIndex := Source.SortIndex;
  IsDefault := Source.IsDefault;
  IsNew := Source.IsNew;
end;

procedure TLibraryCategory.Clear;
var
  i: Integer;
begin
  for i := 0 to self.fCollections.Count - 1 do
    fCollections[i].Clear;

  fCollections.Clear;

  // XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  //auch fCollections selbst clearen? Bei Playlists wird das gemacht
  //aber die RootColelctions bei Files bleiben drin - dafür gibt es eine eigene reset-Methode - sinnvoll?
end;

procedure TLibraryCategory.RemoveEmptyCollections;
var
  i: Integer;
begin
  for i := fCollections.Count - 1 downto 0 do begin
    if fCollections[i].Count = 0 then
      fCollections.Delete(i)
    else
      fCollections[i].RemoveEmptyCollections;
  end;
end;

procedure TLibraryCategory.LoadFromStream(aStream: TStream);
var c: Integer;
    dataID: Byte;
begin
  c := 0;
  repeat
    aStream.Read(dataID, sizeof(dataID));
    inc(c);
    case dataID of
      MP3DB_CAT_NAME      : fName := ReadTextFromStream(aStream);
      MP3DB_CAT_INDEX     : fIndex := ReadByteFromStream(aStream);
      MP3DB_CAT_SORTINDEX : fSortIndex := ReadByteFromStream(aStream);
      MP3DB_CAT_TAG       : fCaptionMode := ReadIntegerFromStream(aStream);
      MP3DB_CAT_ISDEFAULT : fIsDefault := ReadBoolFromStream(aStream);
      MP3DB_CAT_ISNEW     : fIsNew := ReadBoolFromStream(aStream);

      DATA_END_ID      : ; // Explicitly do Nothing
    else
      begin
        if not ReadUnkownDataFromStream(aStream) then
          c := DATA_END_ID;
      end;
    end;
  until (dataID = DATA_END_ID) OR (c >= DATA_END_ID);
end;

function TLibraryCategory.SaveToStream(aStream: TStream): LongInt;
begin
  result :=          WriteTextToStream(aStream, MP3DB_CAT_NAME, fName);
  result := result + WriteByteToStream(aStream, MP3DB_CAT_INDEX, fIndex);
  result := result + WriteByteToStream(aStream, MP3DB_CAT_SORTINDEX, fSortIndex);
  result := result + WriteIntegerToStream(aStream, MP3DB_CAT_TAG, fCaptionMode);
  result := result + WriteBoolToStream(aStream, MP3DB_CAT_ISDEFAULT, fIsDefault);
  result := result + WriteBoolToStream(aStream, MP3DB_CAT_ISNEW, fIsNew);
  result := result + WriteDataEnd(aStream);
end;

function TLibraryCategory.GetCollection(Index: Integer): TAudioCollection;
begin
  result := fCollections[Index];
end;

function TLibraryCategory.IndexOf(Index: TAudioCollection): Integer;
begin
  result := fCollections.IndexOf(Index);
end;

function TLibraryCategory.GetCollectionCount: Integer;
begin
  result := fCollections.Count;
end;

function TLibraryCategory.GetNameCount: String;
begin
  result := Format('%s (%d)', [fName, ItemCount]);
end;

procedure TLibraryCategory.SortCollections(doRecursive: Boolean);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count - 1 do
    fCollections[i].SortCollection(doRecursive);
end;

procedure TLibraryCategory.AnalyseCollections(recursive: Boolean);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count - 1 do
    fCollections[i].Analyse(recursive);
end;



{ TAudioCollection }


procedure TAudioCollection.ApplyNewCoverID(newID: String);
begin
  DoChangeCoverIDAfterDownload(newID);
end;

constructor TAudioCollection.Create(aOwner: TLibraryCategory);
begin
  inherited Create;

  fOwnerCategory := aOwner;
  fArchiveList := Nil;
  fArchiveID := 0;
end;

destructor TAudioCollection.Destroy;
begin
  if assigned(fArchiveList) then
    fArchiveList.Remove(self);

  inherited;
end;

procedure TAudioCollection.Archive(ArchiveList: TAudioCollectionList; ID: Integer);
begin
  if not assigned(fArchiveList) then begin
    fArchiveList := ArchiveList;
    fArchiveList.Add(self);
    fArchiveID := ID;
  end;
end;

procedure TAudioCollection.Disregard;
begin
  if assigned(fArchiveList) then begin
    fArchiveList.Remove(self);
    fArchiveList := Nil;
    fArchiveID := 0;
  end;
end;


procedure TAudioCollection.GetFiles(dest: TAudioFileList; recursive: Boolean);
begin
  if assigned(fOwnerCategory) then
    fOwnerCategory.RememberLastCollection(self);
    //fLastSelectedCollection := self;
  DoGetFiles(dest, recursive);
end;

{ TCollectionMetaInfo }

constructor TCollectionMetaInfo.Create;
begin
  fKeyPath := TStringList.Create;
end;

destructor TCollectionMetaInfo.Destroy;
begin
  fKeyPath.Free;
  inherited;
end;

procedure TCollectionMetaInfo.Clear;
begin
  fKeyPath.Clear;
  fRootIndex := -1;
end;

procedure TCollectionMetaInfo.Assign(aInfo: TCollectionMetaInfo);
begin
  fRootIndex := aInfo.fRootIndex;
  fKeyPath.Assign(aInfo.fKeyPath);
end;

procedure TCollectionMetaInfo.AddKey(aKey: String);
begin
  fKeyPath.Add(aKey);
end;

function TCollectionMetaInfo.GetKey(Index: Integer): String;
begin
  result := fKeyPath[Index];
end;

function TCollectionMetaInfo.GetKeyCount: Integer;
begin
  result := fKeyPath.Count;
end;

procedure TCollectionMetaInfo.LoadSettings;
var
  keyString: String;
  i, keyDepth: Integer;
begin
  fRootIndex := NempSettingsManager.ReadInteger('LibraryOrganizerSelection', 'RootIndex', 0);
  keyDepth := NempSettingsManager.ReadInteger('LibraryOrganizerSelection', 'KeyDepth', 0);
  for i := 0 to keyDepth-1 do begin
    keyString := NempSettingsManager.ReadString('LibraryOrganizerSelection', 'Key'+IntToStr(i), '');
    fKeyPath.Add(keyString);
  end;
end;

procedure TCollectionMetaInfo.SaveSettings;
var
  i: Integer;
begin
  NempSettingsManager.WriteInteger('LibraryOrganizerSelection', 'RootIndex', fRootIndex);
  NempSettingsManager.WriteInteger('LibraryOrganizerSelection', 'KeyDepth', KeyCount);
  for i := 0 to KeyCount-1 do
    NempSettingsManager.WriteString('LibraryOrganizerSelection', 'Key'+IntToStr(i), Keys[i]);
end;

initialization

  fNempOrganizerSettings := Nil;

finalization

  if assigned(fNempOrganizerSettings) then
    fNempOrganizerSettings.Free;

end.
