unit LibraryOrganizer.Base;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, DriveRepairTools,
  NempAudioFiles, NempFileUtils, Nemp_ConstantsAndTypes, Nemp_RessourceStrings;

resourcestring
  rsCollectionDataUnknown = '- ? -';

  rsDefaultCategoryAll = 'Music';
  rsDefaultCategoryNew = 'Recently added';
  rsDefaultCategoryAudioBook = 'Audio books';
  rsNewCategoryName = 'New category';

const
  // these category names are set automatically. The "name" should always be exactly like this
  // Translation will be done in the GetCaption
  rsDefaultCategoryPlaylist = 'Playlists';
  rsDefaultCategoryFavPlaylist = 'Favourite playlists';
  rsDefaultCategoryWebradio = 'Webradio';

const
  MAX_LIST_SIZE = 5;

  MP3DB_CAT_NAME = 1;
  MP3DB_CAT_INDEX = 2;
  // MP3DB_CAT_SORTINDEX = 3;
  MP3DB_CAT_TAG = 4;
  MP3DB_CAT_ISDEFAULT = 5;
  MP3DB_CAT_ISNEW = 6;

const
  DefaultCategories: Array [0..1] of String = ('c0d0', 'e0');


type
  // Difference between ctDirectory and ctPath:
  // - ctDirectory creates a subcollection for every folder on the path, simulating the actual file system on the disk
  // - ctPath uses just the Path (without the Filename) as a Key. Used to get the "common directory" during analysis of a collection
  teCollectionContent = (ccNone, ccRoot, ccArtist, ccAlbum, ccDirectory, ccGenre, ccDecade, ccYear, ccFileAgeYear, ccFileAgeMonth,
      ccTagCloud,
      ccPath, ccCoverID); // the last 2 are just for internal use
  teCollectionSorting = (csDefault, csAlbum, csArtistAlbum, csCount, csYear, csFileAge, csGenre, csDirectory);

  teMissingCoverPreSorting = (mcFirst, mcIgnore, mcEnd);

  TCollectionConfig = record
    CollectionContent: teCollectionContent; // a..l
    CollectionSorting: teCollectionSorting; // 0..7
  end;

  TCollectionConfigList = class(TList<TCollectionConfig>);
  // TRootCollectionConfig = Array of TCollectionConfig;  // save as ([a..j][0..5])*
  // Note: The Medialibrary will load an "Array of TCollectionTypeList" from the settings-inifile
  // to initialise the Collections in the FileCategories


  teInsertMode = (imList, imDictionary);
  teCollectionUniqueness = (cuUnique, cuSampler, cuInvalid);
  teCollectionClass = (ccFiles, ccPlaylists, ccWebStations);
  teAlbumKeyMode = (akAlbumOnly, akAlbumArtist, akAlbumDirectory, akDirectoryOnly, akCoverID);
  tePlaylistCaptionMode = (pcmFilename, pcmFolder, pcmFolderFilename, pcmPath);
  teCoverState = (csUnchecked, csInValid, csOK, csMissing);

  teCategoryAction = (caNone, caCategoryCopy, caCategoryMove);

const
  //TypStrings: Array[teCollectionType] of String = (
  //'ctNone', 'ctRoot', 'ctArtist', 'ctAlbum', 'ctDirectory', 'ctGenre', 'ctDecade', 'ctYear', 'ctFileAgeYear', 'ctFileAgeMonth',
  //'ctPath', 'ctCoverID');

  rcArtists = 'Artists';
  rcAlbums = 'Albums';
  rcDirectories = 'Directories';
  rcGenres = 'Genres';
  rcYears = 'Years';
  rcDecades = 'Decades';
  rcFileAges = 'Fileage';
  rcFileAgesMonth = 'Fileage (by month)';
  rcTagGloud = 'TagCloud';
  rcCoverID = 'CoverID';

  CollectionSorting_Default  = 'Name';
  CollectionSorting_ByAlbum  = 'Album';
  CollectionSorting_ByArtistAlbum  = 'Artist and Album';
  CollectionSorting_ByCount  = 'Count';
  CollectionSorting_ByYear  = 'Release year';
  CollectionSorting_ByFileAge  = 'Fileage';
  CollectionSorting_ByGenre  = 'Genre';
  CollectionSorting_ByDirectory  = 'Directory';

  RootCaptions: Array[teCollectionContent] of String = (
    rsCollectionDataUnknown, rsCollectionDataUnknown,
    rcArtists, rcAlbums,
    rcDirectories, rcGenres,
    rcYears, rcYears,
    rcFileAges, rcFileAges,
    rcTagGloud,
    rcDirectories, rcCoverID // the last 2 are just for internal use
  );

  RootCaptionsExact: Array[teCollectionContent] of String = (
    rsCollectionDataUnknown, rsCollectionDataUnknown,
    rcArtists, rcAlbums,
    rcDirectories, rcGenres,
    rcDecades, rcYears,
    rcFileAges, rcFileAgesMonth,
    rcTagGloud,
    rcDirectories, rcCoverID // the last 2 are just for internal use
  );

  CollectionSortingNames: Array[teCollectionSorting] of String = (
    CollectionSorting_Default, CollectionSorting_ByAlbum, CollectionSorting_ByArtistAlbum,
    CollectionSorting_ByCount, CollectionSorting_ByYear, CollectionSorting_ByFileAge,
    CollectionSorting_ByGenre, CollectionSorting_ByDirectory
  );

  OrganizerSelectionSuffix: Array [0..2] of String =
    ('Tree', 'CoverFlow', 'TagCloud');

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
      fShowCategoryCount: Boolean;
      fShowCoverArtOnAlbum: Boolean;
      fUseNewCategory: Boolean;
      fDefaultRootCollectionConfig: TCollectionConfigList;
      fCoverFlowRootCollectionConfig: TCollectionConfigList;
      FTagCloudCollectionConfig: TCollectionConfigList;
      fCategoryConfig: Array of TCollectionConfigList;

      procedure ClearCategoryConfig;
      function GetRootCollectionConfig(Index: Integer): TCollectionConfigList;

      //procedure InitDefaultRootCollections;
      function GetRootCollectionCount: Integer;
    public
      //property GroupYearsByDecade   : Boolean read fGroupYearsByDecade   write fGroupYearsByDecade   ;
      //property GroupFileAgeByYear   : Boolean read fGroupFileAgeByYear   write fGroupFileAgeByYear   ;
      property ShowCollectionCount  : Boolean read fShowCollectionCount write fShowCollectionCount;
      property ShowCategoryCount    : Boolean read fShowCategoryCount write fShowCategoryCount;
      property ShowCoverArtOnAlbum  : Boolean read fShowCoverArtOnAlbum write fShowCoverArtOnAlbum;
      property UseNewCategory       : Boolean read fUseNewCategory write fUseNewCategory;
      property AlbumKeyMode: teAlbumKeyMode read fAlbumKeyMode write fAlbumKeyMode;
      property PlaylistCaptionMode: tePlaylistCaptionMode read fPlaylistCaptionMode write fPlaylistCaptionMode;
      property TrimCDFromDirectory: Boolean read fTrimCDFromDirectory write fTrimCDFromDirectory;
      property CDNames: TStringList read fCDNames;

      property RootCollectionCount: Integer read GetRootCollectionCount;
      property RootCollectionConfig[Index: Integer]: TCollectionConfigList read GetRootCollectionConfig;
      property CoverFlowRootCollectionConfig: TCollectionConfigList read fCoverFlowRootCollectionConfig;
      property TagCloudCollectionConfig: TCollectionConfigList read FTagCloudCollectionConfig;

      constructor create;
      destructor Destroy; override;
      procedure Clear;

      procedure Assign(Source: TOrganizerSettings);
      procedure LoadSettings;
      procedure SaveSettings;
      procedure AddConfig(newConfig: TCollectionConfigList);

      procedure ChangeFileCollectionSorting(RCIndex, Layer: Integer; newSorting: teCollectionSorting);
      procedure ChangeCoverFlowSorting(newSorting: teCollectionSorting);

  end;

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
      function GetCollection(Index: Integer): TAudioCollection; virtual; abstract;
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

      property CollectionClass: teCollectionClass read fCollectionClass;

      property CollectionCount: Integer read GetCollectionCount;
      property Collection[Index: Integer]: TAudioCollection read GetCollection;

      constructor Create(aOwner: TLibraryCategory);
      destructor Destroy; override;

      procedure Clear; virtual; abstract;
      procedure RemoveEmptyCollections; virtual; abstract;
      // Last Parameter Remember: Sometimes the automatically "RememberLastCollection" of the OwnerCategory
      // is not wanted (e.g. when generating the HintString in TagCloud-Mode during MouseOver)
      procedure GetFiles(dest: TAudioFileList; recursive: Boolean; Remember: Boolean = True);
      procedure Analyse(recursive: Boolean); virtual; abstract;

      procedure Sort(doRecursive: Boolean = True); virtual; abstract;
      procedure ReSort(newSorting: teCollectionSorting); virtual; abstract;
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); virtual; abstract;

      function MatchPrefix(aPrefix: String): Boolean; virtual; abstract;
      function ComparePrefix(aPrefix: String): Integer; virtual; abstract;

      function IndexOf(aCollection: TAudioCollection): Integer; virtual; abstract;

      // for Coverdownloads we need to remember a collection for some time
      // and we need access to this collection after the download is complete. For that, we
      // "archive" the collection in a simple list, where it can be found much faster than
      // in the complete Category-Tree.
      // The Destructor will remove it from this Archive, if needed.
      // Disregard will remove it from this "Archive"
      procedure Archive(ArchiveList: TAudioCollectionList; ID: Integer);
      procedure Disregard;

      procedure ApplyNewCoverID(newID: String);

  end;

  TAudioCollectionList = class(TObjectList<TAudioCollection>);


  TAudioCollectionNotifyEvent = procedure(Sender: TAudioCollection) of object;

  TCollectionMetaInfo = class
    private
      fKeyPath: TStringList;
      fRootIndex: Integer;
      fExpanded: Boolean; // (for TagCloud)
      function GetKey(Index: Integer): String;
      function GetKeyCount: Integer;
    public
      property RootIndex: Integer read fRootIndex write fRootIndex;
      property Keys[Index: Integer]: String read GetKey;
      property KeyCount: Integer read GetKeyCount;
      property Expanded: Boolean read fExpanded write fExpanded;

      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure Assign(aInfo: TCollectionMetaInfo);
      procedure AddKey(aKey: String);
      procedure LoadSettings(BrowseIDx, CatIdx: Integer);
      procedure SaveSettings(BrowseIDx, CatIdx: Integer);
  end;

  TCollectionMetaInfoArray = Array[0..2] of TCollectionMetaInfo;


  TLibraryCategory = class
    private
      fName: String;
      fCaptionMode: Integer; // Only used in PlaylistCategory
      fIsDefault: Boolean;
      fIsNew: Boolean;

      function GetCollection(Index: Integer): TAudioCollection;
      function GetCollectionCount: Integer;

    protected
      // Category.Collections:
      // For Files, this is a predefined List of TRootCollections, with different ContentTypes7Sortings
      // For Category Playlists/Webradio, it is the list of Playlists/Webradio-Stations in form of a TAudioCollection
      fCollections: TAudioCollectionList;
      fBrowseMode: Integer;
      fLastSelectedCollectionData: TCollectionMetaInfoArray;
      fIndex: Byte;     // for the Bitmask-property in Audiofiles, 1..32
      fCategoryType: teCollectionClass;

      function GetItemCount: Integer; virtual; abstract;
      function GetCaption: String; virtual;
      function GetCaptionCount: String; virtual;
    public
      property Name: String read fName write fName;
      property Caption: String read GetCaption;
      property CaptionCount: String read GetCaptionCount;
      property CategoryType: teCollectionClass read fCategoryType;

      property IsDefault: Boolean read fIsDefault write fIsDefault;
      property IsNew    : Boolean read fIsNew     write fIsNew    ;
      property BrowseMode: Integer read fBrowseMode write fBrowseMode;

      property Index: Byte read fIndex write fIndex;
      property CaptionMode: Integer read fCaptionMode write fCaptionMode;
      property ItemCount: Integer read GetItemCount;
      property CollectionCount: Integer read GetCollectionCount;
      property Collections[Index: Integer]: TAudioCollection read GetCollection;
      function IndexOf(Index: TAudioCollection): Integer;

      property LastSelectedCollectionData: TCollectionMetaInfoArray read fLastSelectedCollectionData;

      constructor Create;
      destructor Destroy; override;
      procedure Clear; virtual;

      procedure AssignSettings(Source: TLibraryCategory);

      // Sort the collections in fCollections of the Category.
      // (But NOT fCollections itself, as this order is predefined by the Users choice)
      procedure SortCollections(doRecursive: Boolean = True); virtual;
      procedure AnalyseCollections(recursive: Boolean); virtual;
      procedure RemoveEmptyCollections; virtual;

      procedure RepairDriveChars(DriveManager: TDriveManager); virtual; abstract;

      procedure RememberLastCollection(aCollection: TAudioCollection); virtual; abstract;
      function FindLastCollectionAgain: TAudioCollection; virtual; abstract;

      procedure LoadFromStream(aStream: TStream); virtual;
      function SaveToStream(aStream: TStream): LongInt; virtual;
  end;


  // the complete MediaLibrary is separated into Categories (like "music, audiobooks, recently added" or whatever
  // also, there may be more than one Category for Playlists
  TLibraryCategoryList = class(TObjectList<TLibraryCategory>);

  function GetDefaultCategory(aList: TLibraryCategoryList): TLibraryCategory;
  function GetDefaultCategoryIndex(aList: TLibraryCategoryList): Integer;

  procedure SetDefaultCategory(aList: TLibraryCategoryList; defaultCat: TLibraryCategory);
  procedure SetDefaultCategoryIndex(aList: TLibraryCategoryList; defaultIndex: Integer);

  function GetNewCategory(aList: TLibraryCategoryList): TLibraryCategory;
  function GetNewCategoryIndex(aList: TLibraryCategoryList): Integer;
  procedure SetNewCategory(aList: TLibraryCategoryList; newCat: TLibraryCategory);
  procedure SetNewCategoryIndex(aList: TLibraryCategoryList; newIndex: Integer);


  function NempOrganizerSettings: TOrganizerSettings;
  procedure IniStrToRootConfig(aString: String; Dest: TCollectionConfigList);
  function RootConfigToIniStr(aConfig: TCollectionConfigList): String;

  procedure AddConfigToList(Dest: TCollectionConfigList; newType: teCollectionContent; newSorting: teCollectionSorting);


implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper, gnugettext;

var
  fNempOrganizerSettings: TOrganizerSettings;


function NempOrganizerSettings: TOrganizerSettings;
begin
  if not assigned(fNempOrganizerSettings) then
    fNempOrganizerSettings := TOrganizerSettings.Create;
  result := fNempOrganizerSettings;
end;



procedure IniStrToRootConfig(aString: String; Dest: TCollectionConfigList);
var
  i, configDepth: Integer;
begin
  configDepth := Length(aString) Div 2;

  for i := 0 to configDepth-1 do begin
    AddConfigToList(Dest,
        teCollectionContent(ord(aString[2*i+1]) - ord('a')),
        teCollectionSorting(StrToIntDef(aString[2*i+2], 0))
    );
  end;
end;

function RootConfigToIniStr(aConfig: TCollectionConfigList): String;
var
  i, configDepth: Integer;
begin
  configDepth := aConfig.Count;// Length(aConfig);

  result := '';
  for i := 0 to configDepth-1 do begin
    result := result
              + chr(Integer(aConfig[i].CollectionContent) + ord('a'))
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

procedure AddConfigToList(Dest: TCollectionConfigList; newType: teCollectionContent; newSorting: teCollectionSorting);
var
  newData: TCollectionConfig;
begin
  newData.CollectionContent := newType;
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
  fShowCategoryCount   := True;
  fShowCoverArtOnAlbum := True;
  fUseNewCategory := True;

  fCoverFlowRootCollectionConfig := TCollectionConfigList.Create;
  fDefaultRootCollectionConfig := TCollectionConfigList.Create;
  FTagCloudCollectionConfig := TCollectionConfigList.Create;

  // Default-RootCollectionConfig (as a final Fallback)
  AddConfigToList(fDefaultRootCollectionConfig, ccArtist, csDefault);
  AddConfigToList(fDefaultRootCollectionConfig, ccAlbum, csDefault);
  // TagCloud-Configuration (fixed)
  AddConfigToList(FTagCloudCollectionConfig, ccTagCloud, csDefault);
end;

destructor TOrganizerSettings.Destroy;
begin
  ClearCategoryConfig;
  fCDNames.Free;
  fCoverFlowRootCollectionConfig.Free;
  fDefaultRootCollectionConfig.Free;
  FTagCloudCollectionConfig.Free;
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
  fShowCategoryCount   := Source.fShowCategoryCount;
  fShowCoverArtOnAlbum := Source.fShowCoverArtOnAlbum;
  fUseNewCategory      := Source.fUseNewCategory;

  // assign CategoryConfig
  ClearCategoryConfig;
  SetLength(fCategoryConfig, Length(Source.fCategoryConfig));
  for iRC := 0 to Length(fCategoryConfig) -1  do begin
    fCategoryConfig[iRC] := TCollectionConfigList.Create;

    for i := 0 to Source.fCategoryConfig[iRC].Count - 1 do begin
      AddConfigToList(
        fCategoryConfig[iRC],
        Source.fCategoryConfig[iRC][i].CollectionContent,
        Source.fCategoryConfig[iRC][i].CollectionSorting
      );
    end;
  end;

  // assign DefaultRootConfig
  fDefaultRootCollectionConfig.Clear;
  for i := 0 to Source.fDefaultRootCollectionConfig.Count - 1 do begin
    AddConfigToList(
        fDefaultRootCollectionConfig,
        Source.fDefaultRootCollectionConfig[i].CollectionContent,
        Source.fDefaultRootCollectionConfig[i].CollectionSorting
      );
  end;

  // assign CoverFlowConfig
  fCoverFlowRootCollectionConfig.Clear;
  for i := 0 to Source.fCoverFlowRootCollectionConfig.Count - 1 do begin
    AddConfigToList(
        fCoverFlowRootCollectionConfig,
        Source.fCoverFlowRootCollectionConfig[i].CollectionContent,
        Source.fCoverFlowRootCollectionConfig[i].CollectionSorting
      );
  end;
end;

procedure TOrganizerSettings.AddConfig(newConfig: TCollectionConfigList);
var
  lastIndex, i: Integer;
begin
  SetLength(fCategoryConfig, Length(fCategoryConfig) + 1);
  lastIndex := Length(fCategoryConfig) - 1;
  fCategoryConfig[lastIndex] := TCollectionConfigList.Create;
  for i := 0 to newConfig.Count - 1 do
    AddConfigToList(
      fCategoryConfig[lastIndex],
      newConfig[i].CollectionContent,
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

  if RootCollectionConfig[RCIndex][0].CollectionContent = ccDirectory then begin
    ChangedData.CollectionContent := ccDirectory;
    RootCollectionConfig[RCIndex][0] := ChangedData;
  end
  else
    if RootCollectionConfig[RCIndex][0].CollectionContent = ccTagCloud then begin
      ChangedData.CollectionContent := ccTagCloud;
      RootCollectionConfig[RCIndex][0] := ChangedData;
    end
    else
    begin
      if RootCollectionConfig[RCIndex].Count >= Layer then begin
        ChangedData.CollectionContent := RootCollectionConfig[RCIndex][Layer].CollectionContent;
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
    ChangedData.CollectionContent := CoverFlowRootCollectionConfig[0].CollectionContent
  else
    ChangedData.CollectionContent := ccAlbum;

  CoverFlowRootCollectionConfig.Clear;
  CoverFlowRootCollectionConfig.Add(ChangedData);
end;


function TOrganizerSettings.GetRootCollectionCount: Integer;
begin
  result := length(fCategoryConfig);
end;

function TOrganizerSettings.GetRootCollectionConfig(
  Index: Integer): TCollectionConfigList;
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
  categoryCount := NempSettingsManager.ReadInteger('LibraryOrganizer', 'RootCount', 2);
  if categoryCount = 0 then
    categoryCount := 1;
  if categoryCount > 5 then
    categoryCount := 5;

  ClearCategoryConfig;
  SetLength(fCategoryConfig, categoryCount);
  for i := 0 to categoryCount-1 do begin
    fCategoryConfig[i] := TCollectionConfigList.Create;
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
  fShowCategoryCount   := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCategoryCount', True);
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
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCategoryCount', fShowCategoryCount);
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCoverArtOnAlbum', fShowCoverArtOnAlbum);
end;

{ TLibraryCategory }

constructor TLibraryCategory.Create;
var
  i: Integer;
begin
  fCollections := TAudioCollectionList.Create(True);
  fIsDefault := False;
  fIsNew := False;
  for i := 0 to 2 do
    fLastSelectedCollectionData[i] := TCollectionMetaInfo.Create;
end;

destructor TLibraryCategory.Destroy;
var
  i: Integer;
begin
  fCollections.Free;
  for i := 0 to 2 do
    fLastSelectedCollectionData[i].Free;
  inherited;
end;

procedure TLibraryCategory.AssignSettings(Source: TLibraryCategory);
begin
  Name := Source.Name;
  Index := Source.Index;
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
      //MP3DB_CAT_SORTINDEX : fSortIndex := ReadByteFromStream(aStream);
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
  //result := result + WriteByteToStream(aStream, MP3DB_CAT_SORTINDEX, fSortIndex);
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

function TLibraryCategory.GetCaption: String;
begin
  result := fName;
end;

function TLibraryCategory.GetCaptionCount: String;
begin
  result := Format('%s (%d)', [Caption, ItemCount]);
end;


procedure TLibraryCategory.SortCollections(doRecursive: Boolean);
var
  i: Integer;
begin
  for i := 0 to fCollections.Count - 1 do
    fCollections[i].Sort(doRecursive);
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


procedure TAudioCollection.GetFiles(dest: TAudioFileList; recursive: Boolean; Remember: Boolean = True);
begin
  if Remember and assigned(fOwnerCategory) then
    fOwnerCategory.RememberLastCollection(self);
  DoGetFiles(dest, recursive);
end;

{ TCollectionMetaInfo }

constructor TCollectionMetaInfo.Create;
begin
  fKeyPath := TStringList.Create;
  fExpanded := false;
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
  fExpanded := false;
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

procedure TCollectionMetaInfo.LoadSettings(BrowseIDx, CatIdx: Integer);
var
  keyString: String;
  i, keyDepth: Integer;
  suffix, idxStr: String;
begin
  idxStr := IntToStr(CatIdx);
  suffix := OrganizerSelectionSuffix[BrowseIdx];

  fRootIndex := NempSettingsManager.ReadInteger('LibraryOrganizerSelection' + suffix, 'RootIndex' + idxStr, 0);
  keyDepth := NempSettingsManager.ReadInteger('LibraryOrganizerSelection' + suffix, 'KeyDepth' + idxStr, 0);
  Expanded := NempSettingsManager.ReadBool('LibraryOrganizerSelection' + suffix, 'Expanded' + idxStr, False);
  for i := 0 to keyDepth-1 do begin
    keyString := NempSettingsManager.ReadString('LibraryOrganizerSelection' + suffix, 'Key' + idxStr + '-' + IntToStr(i), '');
    fKeyPath.Add(keyString);
  end;
end;

procedure TCollectionMetaInfo.SaveSettings(BrowseIDx, CatIdx: Integer);
var
  i: Integer;
  suffix, idxStr: String;
begin
  idxStr := IntToStr(CatIdx);
  suffix := OrganizerSelectionSuffix[BrowseIdx];
  NempSettingsManager.WriteInteger('LibraryOrganizerSelection' + suffix, 'RootIndex' + idxStr, fRootIndex);
  NempSettingsManager.WriteInteger('LibraryOrganizerSelection' + suffix, 'KeyDepth' + idxStr, KeyCount);
  NempSettingsManager.WriteBool('LibraryOrganizerSelection' + suffix, 'Expanded' + idxStr, Expanded);
  for i := 0 to KeyCount-1 do
    NempSettingsManager.WriteString('LibraryOrganizerSelection' + suffix, 'Key' + idxStr + '-' + IntToStr(i), Keys[i]);
end;

initialization

  fNempOrganizerSettings := Nil;

finalization

  if assigned(fNempOrganizerSettings) then
    fNempOrganizerSettings.Free;

end.
