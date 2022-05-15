unit LibraryOrganizer.Base;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, DriveRepairTools,        dialogs,
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
{
  Neues Format für die Ini-Strings eines Root-Eintrages für die TreeViews
  - Konfiguration einer Ebene separiert durch ";"
  - Elemente einer Ebene (Typ, Sortierungen inkl. auf/absteigend-Markierung) separiert durch ","
  Layer1,sort+,sort+,sort-;Layer2,sort+;Layer3,sort+,sort-,sort+
}

  cDefaultCategoryConfigStrings: Array [0..1] of String = ('c,0+;d,0+', 'e,0+');  // Interpret-Alben und Verzeichnis-Struktur
  cDefaultCategoryConfigStr = 'e,0+'; // Verzeichnis-Struktur
  cDefaultCoverFlowConfigStr  = 'd,2+,4-';  // Alben sortiert nach Interpret + Erscheinungsjahr

  //cDefaultCategoryConfigStrings: Array [0..1] of String = ('c00d00', 'e00');
  //cDefaultCategoryConfigStr = 'e00';
  //cDefaultCoverFlowConfigStr  = 'd50';

type
  // Difference between ctDirectory and ctPath:
  // - ctDirectory creates a subcollection for every folder on the path, simulating the actual file system on the disk
  // - ctPath uses just the Path (without the Filename) as a Key. Used to get the "common directory" during analysis of a collection
  teCollectionContent = (ccNone, ccRoot, ccArtist, ccAlbum, ccDirectory, ccGenre, ccDecade, ccYear, ccFileAgeYear, ccFileAgeMonth,
      ccTagCloud,
      ccPath, ccCoverID); // the last 2 are just for internal use
  // do not change the order of teCollectionSorting! The actualvalues are used e.g. as "Tag" for some MenuItems
  teCollectionSorting = (csDefault, csAlbum, csArtist, csCount, csYear, csFileAge, csGenre, csDirectory);
  tePlaylistCollectionSorting = (pcsFilename, pcsFolder, pcsPath);

  teMissingCoverPreSorting = (mcFirst, mcIgnore, mcEnd);

  TCollectionConfig = record
    Content: teCollectionContent; // a..l
    PrimarySorting: teCollectionSorting; // 0..7
    SecondarySorting: teCollectionSorting; // 0..7
    TertiarySorting: teCollectionSorting; // 0..7
    SortDirection1: teSortDirection;
    SortDirection2: teSortDirection;
    SortDirection3: teSortDirection;
  end;

  TCollectionConfigList = class(TList<TCollectionConfig>);
  // Note: The Medialibrary will load an "Array of TCollectionConfigList" from the settings-inifile
  // to initialise the RootCollections in the FileCategories

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

  cEmptyCollectionConfig: TCollectionConfig = (
      Content: ccNone;
      PrimarySorting: csDefault;
      SecondarySorting: csDefault;
      TertiarySorting: csDefault;
      SortDirection1: sd_Ascending;
      SortDirection2: sd_Ascending;
      SortDirection3: sd_Ascending );

  cDirectoryCollectionConfig: TCollectionConfig = (
      Content: ccDirectory;
      PrimarySorting: csDefault;
      SecondarySorting: csDefault;
      TertiarySorting: csDefault;
      SortDirection1: sd_Ascending;
      SortDirection2: sd_Ascending;
      SortDirection3: sd_Ascending );

  cTagCloudCollectionConfig: TCollectionConfig = (
      Content: ccTagCloud;
      PrimarySorting: csCount;
      SecondarySorting: csDefault;
      TertiarySorting: csDefault;
      SortDirection1: sd_Ascending;
      SortDirection2: sd_Ascending;
      SortDirection3: sd_Ascending );

  // Default Configuration for Treeview and Coverflow
  // (Second Configuration for TreeView: cDirectoryCollectionConfig)
  cDefaultConfig: TCollectionConfig = (
      Content: ccAlbum;
      PrimarySorting: csArtist;
      SecondarySorting: csYear;
      TertiarySorting: csDefault;
      SortDirection1: sd_Ascending;
      SortDirection2: sd_Descending;
      SortDirection3: sd_Ascending );

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
  CollectionSorting_ByArtist  = 'Artist';
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
    CollectionSorting_Default, CollectionSorting_ByAlbum, CollectionSorting_ByArtist,
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
      fPlaylistSorting: tePlaylistCollectionSorting;
      fPlaylistSortDirection: teSortDirection;
      fTrimCDFromDirectory: Boolean;
      fCDNames: TStringList;
      // fShowCollectionCount: Boolean;
      // fShowCategoryCount: Boolean;
      fShowElementCount: Boolean;
      fShowCoverArtOnAlbum: Boolean;
      // fUseNewCategory: Boolean;
      // fUseSmartAdd: Boolean;
      fDefaultRootCollectionConfig: TCollectionConfigList;
      fCoverFlowRootCollectionConfig: TCollectionConfigList;
      FTagCloudCollectionConfig: TCollectionConfigList;
      fCategoryConfig: Array of TCollectionConfigList;

      procedure ClearCategoryConfig;
      function GetRootCollectionConfig(Index: Integer): TCollectionConfigList;

      procedure CheckCoverFlowConfig;

      //procedure InitDefaultRootCollections;
      function GetRootCollectionCount: Integer;

      procedure SetPlaylistCaptionMode(Value: Integer);
      procedure SetAlbumKeyMode(Value: Integer);
      procedure SetPlaylistSorting(Value: Integer);
      procedure SetPlaylistDirection(Value: Integer);

    public
      //property GroupYearsByDecade   : Boolean read fGroupYearsByDecade   write fGroupYearsByDecade   ;
      //property GroupFileAgeByYear   : Boolean read fGroupFileAgeByYear   write fGroupFileAgeByYear   ;
      //property ShowCollectionCount  : Boolean read fShowCollectionCount write fShowCollectionCount;
      //property ShowCategoryCount    : Boolean read fShowCategoryCount write fShowCategoryCount;
      property ShowElementCount     : Boolean read fShowElementCount write fShowElementCount;
      property ShowCoverArtOnAlbum  : Boolean read fShowCoverArtOnAlbum write fShowCoverArtOnAlbum;
      // property UseNewCategory       : Boolean read fUseNewCategory write fUseNewCategory;
      // property UseSmartAdd          : Boolean read fUseSmartAdd write fUseSmartAdd;
      property AlbumKeyMode: teAlbumKeyMode read fAlbumKeyMode write fAlbumKeyMode;
      property PlaylistCaptionMode: tePlaylistCaptionMode read fPlaylistCaptionMode write fPlaylistCaptionMode;
      property PlaylistSorting: tePlaylistCollectionSorting read fPlaylistSorting write fPlaylistSorting;
      property PlaylistSortDirection: teSortDirection read fPlaylistSortDirection write fPlaylistSortDirection;

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

      // used in TFormLibraryConfiguration.BtnApplyClick
      procedure AddConfig(newConfig: TCollectionConfigList);

      procedure ChangeFileCollectionSorting(RCIndex, Layer: Integer; newSorting: teCollectionSorting;
        newDirection: teSortDirection; OnlyDirection: Boolean);
      procedure ChangeCoverFlowSorting(newSorting: teCollectionSorting;
        newDirection: teSortDirection; OnlyDirection: Boolean);

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
      procedure Analyse(recursive, ForceAnalysis: Boolean); virtual; abstract;

      procedure Sort(doRecursive: Boolean = True); virtual; abstract;
      procedure ReSort(newSorting: teCollectionSorting; newDirection: teSortDirection); virtual; abstract;
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
  procedure IniStrToRootConfig(ConfigStr: String; Dest: TCollectionConfigList);
  function RootConfigToIniStr(aConfig: TCollectionConfigList): String;

  procedure PrepareForNewPrimarySorting(var aConfig: TCollectionConfig);

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



procedure IniStrToRootConfig(ConfigStr: String; Dest: TCollectionConfigList);
var
  iLayer: Integer;
  ListLayer, ListSortings: TStringList;
  newConfig: TCollectionConfig;

  function ValidSort(aStr: String): Boolean;
  begin
    result := (Length(aStr) >= 2)
      and (StrToIntDef(aStr[1], -1) > -1)
      and ( (aStr[2] = '+') or (aStr[2] = '-'))
  end;

  function CharToSortDirection(aChar: Char): teSortDirection;
  begin
    if aChar = '+' then
      result := sd_Ascending
    else
      result := sd_Descending;
  end;

  function CharToSorting(aChar: Char): teCollectionSorting;
  var
    aInt: Integer;
  begin
    aInt := StrToInt(aChar);
    if (aInt >= Ord(Low(teCollectionSorting))) and (aInt <= Ord(High(teCollectionSorting))) then
      result := teCollectionSorting(aInt)
    else
      result := csDefault
  end;

begin

  ListLayer := TStringList.Create;
  ListSortings := TStringList.Create;
  try
    ListLayer.Delimiter := ';';
    ListSortings.Delimiter := ',';

    ListLayer.DelimitedText := ConfigStr;
    for iLayer := 0 to ListLayer.Count - 1 do begin
      ListSortings.DelimitedText := Listlayer[iLayer];
      newConfig := cEmptyCollectionConfig; // reset

      if (ListSortings.Count > 0) and (Length(ListSortings[0]) >= 1) then begin
        newConfig.Content := teCollectionContent(ord(ListSortings[0][1]) - ord('a'));
        if (ListSortings.Count > 1) and ValidSort(ListSortings[1]) then begin
          newConfig.PrimarySorting :=  CharToSorting(ListSortings[1][1]);
          newConfig.SortDirection1 := CharToSortDirection(ListSortings[1][2]);
        end;
        if (ListSortings.Count > 2) and ValidSort(ListSortings[2]) then begin
          newConfig.SecondarySorting :=  CharToSorting(ListSortings[2][1]);
          newConfig.SortDirection2 := CharToSortDirection(ListSortings[2][2]);
        end;
        if (ListSortings.Count > 3) and ValidSort(ListSortings[3]) then begin
          newConfig.TertiarySorting :=  CharToSorting(ListSortings[3][1]);
          newConfig.SortDirection3 := CharToSortDirection(ListSortings[3][2]);
        end;
      end;

      if newConfig.Content <> ccNone then
        dest.Add(newConfig);
    end;

  finally
    ListLayer.Free;
    ListSortings.Free;
  end;

end;

function RootConfigToIniStr(aConfig: TCollectionConfigList): String;
var
  i: Integer;

  function SortDirToStr(aDirection: teSortDirection): String;
  begin
    if aDirection = sd_Descending then
      result := '-'
    else
      result := '+';
  end;

  function SortToStr(aSorting: teCollectionSorting): String;
  begin
    result := IntToStr(Integer(aSorting));
  end;

  function ConfigToStr(Config: TCollectionConfig): String;
  begin
    result := chr(Integer(Config.Content) + ord('a'))
      + ',' + SortToStr(Config.PrimarySorting) + SortDirToStr(Config.SortDirection1)
      + ',' + SortToStr(Config.SecondarySorting) + SortDirToStr(Config.SortDirection2)
      + ',' + SortToStr(Config.TertiarySorting) + SortDirToStr(Config.SortDirection3);
  end;

begin
  if aConfig.Count > 0 then
    result := ConfigToStr(aConfig[0]);

  for i := 1 to aConfig.Count - 1 do
    result := result + ';' + ConfigToStr(aConfig[i]);

  {
  configDepth := aConfig.Count;// Length(aConfig);

  result := '';
  for i := 0 to configDepth-1 do begin
    result := result
              + chr(Integer(aConfig[i].Content) + ord('a'))
              + IntToStr(Integer(aConfig[i].PrimarySorting))
              + IntToStr(Integer(aConfig[i].SortDirection1 ));
  end;
  }
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
  for i := 0 to aList.Count - 1 do
    aList[i].fIsNew := False;
  // Set new index
  if (newIndex >= 0) and (newIndex < aList.Count) then
    aList[newIndex].fIsNew := True;
end;

procedure PrepareForNewPrimarySorting(var aConfig: TCollectionConfig);
begin
  aConfig.TertiarySorting := aConfig.SecondarySorting;
  aConfig.SecondarySorting := aConfig.PrimarySorting;
  aConfig.SortDirection3 := aConfig.SortDirection2;
  aConfig.SortDirection2 := aConfig.SortDirection1;
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
  fShowElementCount    := True;
  // fShowCollectionCount := True;
  // fShowCategoryCount   := True;
  fShowCoverArtOnAlbum := True;
  // fUseNewCategory := True;
  // fUseSmartAdd := True;

  fCoverFlowRootCollectionConfig := TCollectionConfigList.Create;
  fDefaultRootCollectionConfig := TCollectionConfigList.Create;
  FTagCloudCollectionConfig := TCollectionConfigList.Create;

  // Default-RootCollectionConfig (as a final Fallback)
  fDefaultRootCollectionConfig.Add(cDefaultConfig);

  //AddConfigToList(fDefaultRootCollectionConfig, ccArtist, csDefault, sd_Ascending);
  //AddConfigToList(fDefaultRootCollectionConfig, ccAlbum, csDefault, sd_Ascending);
  // TagCloud-Configuration (fixed)
  // AddConfigToList(FTagCloudCollectionConfig, ccTagCloud, csDefault, sd_Ascending);
  fTagCloudCollectionConfig.Add(cTagCloudCollectionConfig);
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
  fPlaylistSorting       := Source.fPlaylistSorting;
  fPlaylistSortDirection := Source.fPlaylistSortDirection;

  fTrimCDFromDirectory := Source.fTrimCDFromDirectory;
  fCDNames.Assign(Source.fCDNames);
  ShowElementCount     := Source.ShowElementCount;
  // fShowCollectionCount := Source.fShowCollectionCount;
  // fShowCategoryCount   := Source.fShowCategoryCount;
  fShowCoverArtOnAlbum := Source.fShowCoverArtOnAlbum;
  // fUseNewCategory      := Source.fUseNewCategory;
  // fUseSmartAdd         := Source.fUseSmartAdd;

  // assign CategoryConfig
  ClearCategoryConfig;
  SetLength(fCategoryConfig, Length(Source.fCategoryConfig));
  for iRC := 0 to Length(fCategoryConfig) -1  do begin
    fCategoryConfig[iRC] := TCollectionConfigList.Create;

    for i := 0 to Source.fCategoryConfig[iRC].Count - 1 do
      fCategoryConfig[iRC].Add(Source.fCategoryConfig[iRC][i])
  end;

  // assign DefaultRootConfig
  fDefaultRootCollectionConfig.Clear;
  for i := 0 to Source.fDefaultRootCollectionConfig.Count - 1 do
    fDefaultRootCollectionConfig.Add(Source.fDefaultRootCollectionConfig[i]);

  // assign CoverFlowConfig
  fCoverFlowRootCollectionConfig.Clear;
  for i := 0 to Source.fCoverFlowRootCollectionConfig.Count - 1 do
    fCoverFlowRootCollectionConfig.Add(Source.fCoverFlowRootCollectionConfig[i]);
end;

procedure TOrganizerSettings.AddConfig(newConfig: TCollectionConfigList);
var
  lastIndex, i: Integer;
begin
  SetLength(fCategoryConfig, Length(fCategoryConfig) + 1);
  lastIndex := Length(fCategoryConfig) - 1;
  fCategoryConfig[lastIndex] := TCollectionConfigList.Create;
  for i := 0 to newConfig.Count - 1 do
    fCategoryConfig[lastIndex].Add(newConfig[i])
end;


procedure TOrganizerSettings.ChangeFileCollectionSorting(RCIndex, Layer: Integer;
  newSorting: teCollectionSorting; newDirection: teSortDirection; OnlyDirection: Boolean);
var
  ChangedData: TCollectionConfig;
begin
  if (RCIndex >= RootCollectionCount) then
    exit;
  if RootCollectionConfig[RCIndex].Count = 0 then
    exit;

  if RootCollectionConfig[RCIndex][0].Content in [ccDirectory, ccTagCloud] then begin
    ChangedData := RootCollectionConfig[RCIndex][0];
    if OnlyDirection then
      ChangedData.SortDirection1 := newDirection
    else begin
      PrepareForNewPrimarySorting(ChangedData);
      ChangedData.PrimarySorting := newSorting;
      ChangedData.SortDirection1 := newDirection;
    end;
    RootCollectionConfig[RCIndex][0] := ChangedData;
  end else
  begin
    if RootCollectionConfig[RCIndex].Count >= Layer then begin
        ChangedData := RootCollectionConfig[RCIndex][Layer];
        if OnlyDirection then
          ChangedData.SortDirection1 := newDirection
        else begin
          PrepareForNewPrimarySorting(ChangedData);
          ChangedData.PrimarySorting := newSorting;
          ChangedData.SortDirection1 := newDirection;
        end;
        RootCollectionConfig[RCIndex][Layer] := ChangedData;
      end;
  end;
end;

procedure TOrganizerSettings.ChangeCoverFlowSorting(newSorting: teCollectionSorting;
  newDirection: teSortDirection; OnlyDirection: Boolean);
var
  ChangedData: TCollectionConfig;
begin
  ChangedData := CoverFlowRootCollectionConfig[0];
  if OnlyDirection then
    ChangedData.SortDirection1 := newDirection
  else begin
    PrepareForNewPrimarySorting(ChangedData);
    ChangedData.PrimarySorting := newSorting;
    ChangedData.SortDirection1 := newDirection;
  end;
  CoverFlowRootCollectionConfig[0] := ChangedData;
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


procedure TOrganizerSettings.CheckCoverFlowConfig;
begin
  if fCoverFlowRootCollectionConfig.Count = 0 then begin
    IniStrToRootConfig(cDefaultCoverFlowConfigStr, fCoverFlowRootCollectionConfig);
  end;
end;

procedure TOrganizerSettings.SetPlaylistCaptionMode(Value: Integer);
begin
  if (Value >= Integer(Low(tePlaylistCaptionMode))) and (Value <= Integer(High(tePlaylistCaptionMode))) then
    fPlaylistCaptionMode := tePlaylistCaptionMode(Value)
  else
    fPlaylistCaptionMode := pcmFilename;
end;
procedure TOrganizerSettings.SetAlbumKeyMode(Value: Integer);
begin
  if (Value >= Integer(Low(teAlbumKeyMode))) and (Value <= Integer(High(teAlbumKeyMode))) then
    fAlbumKeyMode := teAlbumKeyMode(Value)
  else
    fAlbumKeyMode := akAlbumDirectory;
end;
procedure TOrganizerSettings.SetPlaylistSorting(Value: Integer);
begin
  if (Value >= Integer(Low(tePlaylistCollectionSorting))) and (Value <= Integer(High(tePlaylistCollectionSorting))) then
    fPlaylistSorting := tePlaylistCollectionSorting(Value)
  else
    fPlaylistSorting := pcsFilename;
end;
procedure TOrganizerSettings.SetPlaylistDirection(Value: Integer);
begin
  if (Value >= Integer(Low(teSortDirection))) and (Value <= Integer(High(teSortDirection))) then
    fPlaylistSortDirection := teSortDirection(Value)
  else
    fPlaylistSortDirection := sd_Ascending;
end;


procedure TOrganizerSettings.LoadSettings;
var
  categoryString, defStr: String;
  i, categoryCount: Integer;
begin
  categoryCount := NempSettingsManager.ReadInteger('LibraryOrganizer', 'RootCount', 2);
  if categoryCount = 0 then
    categoryCount := 1;
  if categoryCount > 10 then
    categoryCount := 10;

  ClearCategoryConfig;
  SetLength(fCategoryConfig, categoryCount);
  for i := 0 to categoryCount-1 do begin
    fCategoryConfig[i] := TCollectionConfigList.Create;
    if i <= 1 then
      defStr := cDefaultCategoryConfigStrings[i]
    else
      defStr := cDefaultCategoryConfigStr;
    categoryString := NempSettingsManager.ReadString('LibraryOrganizer', 'Root'+IntToStr(i), defStr);
    IniStrToRootConfig(categoryString, fCategoryConfig[i]);
  end;

  // Configuration des Coverflow
  // note: Only "d" makes sense here (=Album)
  categoryString := NempSettingsManager.ReadString('LibraryOrganizer', 'CoverflowConfig', cDefaultCoverFlowConfigStr);
  IniStrToRootConfig(categoryString, fCoverFlowRootCollectionConfig);
  CheckCoverFlowConfig;

  SetAlbumKeyMode(NempSettingsManager.ReadInteger('LibraryOrganizer', 'AlbumKeyMode', Integer(akAlbumDirectory)));
  SetPlaylistCaptionMode(NempSettingsManager.ReadInteger('LibraryOrganizer', 'PlaylistCaptionMode', Integer(pcmFilename)));
  SetPlaylistSorting(NempSettingsManager.ReadInteger('LibraryOrganizer', 'PlaylistSorting', Integer(pcsFilename)));
  SetPlaylistDirection(NempSettingsManager.ReadInteger('LibraryOrganizer', 'PlaylistSortDirection', Integer(sd_Ascending)));

  fTrimCDFromDirectory := NempSettingsManager.ReadBool('LibraryOrganizer', 'TrimCDFromDirectory', True);
  fCDNames.DelimitedText := NempSettingsManager.ReadString('LibraryOrganizer', 'CDNames', 'CD');

  //fShowCollectionCount := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCollectionCount', True);
  //fShowCategoryCount   := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCategoryCount', True);
  fShowElementCount   := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowElementCount', True);
  fShowCoverArtOnAlbum := NempSettingsManager.ReadBool('LibraryOrganizer', 'ShowCoverArtOnAlbum', True);

  // fUseNewCategory := NempSettingsManager.ReadBool('LibraryOrganizer', 'UseNewCategory', True);
  // fUseSmartAdd := NempSettingsManager.ReadBool('LibraryOrganizer', 'UseSmartAdd', True);
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
  NempSettingsManager.WriteInteger('LibraryOrganizer', 'PlaylistSorting', Integer(fPlaylistSorting));
  NempSettingsManager.WriteInteger('LibraryOrganizer', 'PlaylistSortDirection', Integer(fPlaylistSortDirection));
  NempSettingsManager.WriteBool('LibraryOrganizer', 'TrimCDFromDirectory', fTrimCDFromDirectory);
  NempSettingsManager.WriteString('LibraryOrganizer', 'CDNames', fCDNames.DelimitedText);
  //NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCollectionCount', fShowCollectionCount);
  //NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCategoryCount', fShowCategoryCount);
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowElementCount', fShowElementCount);
  NempSettingsManager.WriteBool('LibraryOrganizer', 'ShowCoverArtOnAlbum', fShowCoverArtOnAlbum);

  // NempSettingsManager.WriteBool('LibraryOrganizer', 'UseNewCategory', fUseNewCategory);
  // NempSettingsManager.WriteBool('LibraryOrganizer', 'UseSmartAdd', fUseSmartAdd);
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
    fCollections[i].Analyse(recursive, False);
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
