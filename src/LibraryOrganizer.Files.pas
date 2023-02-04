{

    Unit LibraryOrganizer.Files

    - File-Class for the new (2022) MediaLibrary concept with Categories
      and different Layers in the TreeView

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
unit LibraryOrganizer.Files;

interface

uses
  Windows, System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils,
  NempAudioFiles, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, LibraryOrganizer.Base, DriveRepairTools;

type

  teSpecialContent = (scRegular, scDirectory, scTagCloud);

  TRootCollection = class;
  TAudioFileCollection = class;

  TCollectionComparer = function (const item1, item2: TAudioFileCollection): Integer;
  TCollectionCompareArray = Array[teCollectionSorting] of TCollectionComparer;

  TAudioFileCollectionList = class(TObjectList<TAudioFileCollection>);
  TAudioFileCollectionDict = class (TDictionary<string, TAudioFileCollection>);

  ///  FileCollectionMode:
  ///  cmDefault: Subcollections are determined by the Config of the RootCollection
  ///  cmDirectory: SubCollections are created as long as tehy are necessary, depending on the  depth of the directory structure
  ///  cmCloud: Subcollections are created on demand, and each file can be part of many subcollections
  teFileCollectionMode = (cmDefault, cmDirectory, cmCloud);

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
      fRoot: TRootCollection;
      fParent: TAudioFileCollection;
      fLevel: Integer;
      fNeedSorting: Boolean;
      fNeedAnalysis: Boolean;

      fCollectionList: TAudioFileCollectionList; // (sorted) list of Sub-Collections
      fCollectionDict: TAudioFileCollectionDict; // Dictionary of Sub-Collections (during build-up stage)
      fFileList: TAudioFileList;
      fLastAddedAudioFile: TAudioFile;

      // fContent: ContentType of the Collection itself. (needed e.g. to generate a proper Caption)
      // fChildContent: ContentType of the Collections stored in this collection. (needed while adding new files)
      // fChildSorting: Sorting of these Collections
      // Example:
      //    A Collection of ContentType "ccArtist" stores all files for one specific Artist
      //    This Collection can contain several Collections of ContentType "ccAlbum", each of these stores all files for a specific Album of the Artist
      //    The list of these Collections is sorted by fChildSorting "csFileAge", displaying the newest Album first

      // diese drei ersetzen durch zwei TCollectionConfig - Records
      // dieses enthält dann auch mehr Sortier-Ebenen und Sortier-Richtungen
      fConfig: TCollectionConfig;
      fChildConfig: TCollectionConfig;

      // fContent: teCollectionContent;
      // fChildContent: teCollectionContent;
      // fChildSorting: teCollectionSorting; //

      fMissingCoverMode: teMissingCoverPreSorting;

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
      // to distinguish automatically created Tags and LastFM-Tags in the TagCloud
      fIsAutoTag: Boolean;

      fValidArtist: Boolean;
      fValidAlbum: Boolean;
      fDuration: int64;

      function isCloud: Boolean;

      function TryGetCollection(aKey: String; out Value: TAudioFileCollection): Boolean;
      function InitNewCollection(aKey: String; CollectionMode: teFileCollectionMode = cmDefault): TAudioFileCollection;
      procedure SwitchToDictionary;

      procedure AddByArtist(aAudioFile: TAudioFile);
      procedure AddByAlbum(aAudioFile: TAudioFile);
      procedure AddByGenre(aAudioFile: TAudioFile);
      procedure AddByYear(aAudioFile: TAudioFile);
      procedure AddByDecade(aAudioFile: TAudioFile);
      procedure AddByFileAgeYear(aAudioFile: TAudioFile);
      procedure AddByFileAgeMonth(aAudioFile: TAudioFile);
      procedure AddByDirectory(aAudioFile: TAudioFile);
      procedure AddForTagCloud(aAudioFile: TAudioFile);
      procedure AddByPath(aAudioFile: TAudioFile);
      procedure AddByCoverID(aAudioFile: TAudioFile);

      function SearchAudioFileByKey (aKey: String; aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
      function SearchAudioFileByPath (aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;

      function GetCollectionByKey(aKey: String): TAudioFileCollection;
      function GetCollection(Index: Integer): TAudioCollection; override;
      function GetCollectionCount: Integer; override;

      function GetContent: teCollectionContent;
      procedure SetChildContent(Value: teCollectionContent);
      function GetChildContent: teCollectionContent;
      function GetPrimaryChildSorting: teCollectionSorting;
      function GetPrimaryChildSortDirection: teSortDirection;
      function GetSecondaryChildSorting: teCollectionSorting;

      function BuildCaption(IncludeCount: Boolean): String;
      function GetCaption: String; override;
      function GetSimpleCaption: String; override;
      function GetCategoryCaption: String;
      function GetCoverID: String; override;

      class function HasUniqueValue(aCollection: TAudioFileCollection): teCollectionUniqueness;
      function CalculateFileDuration: Int64;
      procedure GetCommonArtist;
      procedure GetCommonGenre;
      procedure GetCommonYear;
      procedure GetCommonFileAge;
      procedure GetCommonAlbum;
      procedure GetCommonCoverID;
      procedure GetCommonDirectory;

      procedure DecreaseCount(recursive: Boolean);
      procedure GetReverseFilesByProperty(dest: TAudioFileList; aCollectionType: teCollectionContent; aProperty: String);

      function CompareCollection_Main(const item1,item2: TAudioFileCollection): Integer;

    public

      property Artist  : String      read fArtist;
      property Album   : String      read fAlbum;
      property Genre   : String      read fGenre;
      property Directory: String     read fDirectory;
      property CoverID : String      read fCoverID write fCoverID; // wird ohnehin noch nicht als "common" ermittelt ...
      property Year    : Integer     read fYear;
      property FileAge : TDateTime   read fFileAge;
      property MissingCoverMode: teMissingCoverPreSorting read fMissingCoverMode write fMissingCoverMode;
      property IsAutoTag: Boolean read fIsAutoTag write fIsAutoTag;
      // The "Valid" properties should only be called directly after a call of "Analyse"
      property ValidArtist: Boolean read fValidArtist;
      property ValidAlbum: Boolean  read fValidAlbum;
      property Duration: int64 read fDuration write fDuration;

      // CategoryCaption: Used for the TagCloud. The RootCollection should show the Category there
      property CategoryCaption: String read GetCategoryCaption;

      // events
      // OnBeforeDeleteCollection: triggered before a subcollection is deleted from the SubCollections-List/Dict (todo then: Delete the VST-Node)
      property OnBeforeDeleteCollection: TAudioCollectionNotifyEvent read fOnBeforeDeleteCollection write fOnBeforeDeleteCollection;
      property OnAfterDeleteCollection: TAudioCollectionNotifyEvent read fOnAfterDeleteCollection write fOnAfterDeleteCollection;

      property NeedSorting: Boolean read fNeedSorting; // This indicates whether the fCollectionList should be sorted again
      property NeedAnalysis: Boolean read fNeedAnalysis;

      property Content: teCollectionContent read GetContent;
      property ChildContent: teCollectionContent read GetChildContent write SetChildContent; // fChildContent;
      property ChildSorting: teCollectionSorting read GetPrimaryChildSorting; //fChildSorting; // Childsorting: Needed to "check" the correct MenuItem during OnPopup of the Menu
      property SecondaryChildSorting: teCollectionSorting read GetSecondaryChildSorting;
      property ChildSortDirection: teSortDirection read GetPrimaryChildSortDirection;

      property Root: TRootCollection read fRoot;
      property Parent: TAudioFileCollection read fParent;

      //constructor Create(aOwner: TLibraryCategory; aRoot: TRootCollection; aLevel: Integer; RecursiveDir: Boolean = False);
      constructor Create(aOwner: TLibraryCategory; aRoot: TRootCollection; aLevel: Integer; CollectionMode: teFileCollectionMode = cmDefault);
      destructor Destroy; override;
      procedure Clear; override;
      procedure RemoveEmptyCollections; override;

      procedure AddAudioFile(aAudioFile: TAudioFile);
      procedure Sort(doRecursive: Boolean = True); override;
      procedure ReSort(newSorting: teCollectionSorting; newDirection: teSortDirection); override;
      procedure SortCollectionLevel(aLevel: Integer; ForceSorting: Boolean = False); override;
      procedure ReSortDirectoryCollection(newSorting: teCollectionSorting;
        newDirection: teSortDirection; OnlyDirection: Boolean; recursive: Boolean);
      procedure ReSortTagCloudCollection(newSorting: teCollectionSorting;
        newDirection: teSortDirection; OnlyDirection: Boolean; recursive: Boolean);


      procedure DoGetFiles(dest: TAudioFileList; recursive: Boolean); override;
      procedure DoChangeCoverIDAfterDownload(newID: String); override;
      procedure GetReverseFiles(dest: TAudioFileList);
      // Some special methods for TagCloud
      // Expand: Adds a new Layer of Tags by changing the subCollectionType to "Cloud" and adding all files into it
      // ClearSubCollections: Clears the SubCollections, but remains the FileList
      function ExpandTagCloud(DoSort: Boolean = False): Boolean;
      procedure ClearSubCollections;

      function SearchAudioFile(aAudioFile: TAudioFile; CheckExist: Boolean): TAudioFileCollection;
      function SearchEditedAudioFile(aAudioFile: TAudioFile): TAudioFileCollection;

      procedure RemoveAudioFile(aAudioFile: TAudioFile); virtual;
      procedure RemoveAudioFileFromTagCloud(aAudioFile: TAudioFile); virtual;

      function RelocateAudioFile(aAudioFile: TAudioFile): Boolean; virtual;
      function CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean; virtual;

      procedure RemoveCollection(aCollection: TAudioFileCollection);

      function MatchPrefix(aPrefix: String): Boolean; override;
      function ComparePrefix(aPrefix: String): Integer; override;
      function IndexOf(aCollection: TAudioCollection): Integer; override;

      function PerformSearch(aKeyword: String; ParentAreadyMatches: Boolean): Boolean; override;

      procedure Analyse(recursive, ForceAnalysis: Boolean); override;
      // After inserting all Files into a collection, we may want to analyze these files and collect further data
      // for example, when sorting by Album, we may want addtional common information like "year", "genre", "artist"

      class function CommonCoverID(AudioFiles: TAudioFileList): String;
  end;


  TRootCollection = class(TAudioFileCollection)
    private
      // List with the types of sub-collections. These are stored once in the RootCollection.
      // All SubCollections link to this list and can determine their type through their layer-level in the Tree.
      // Properties/Types are defined by the MediaLibrary-Settings
      fCollectionConfigList: TCollectionConfigList;
      fCaptionConfigList: TCollectionConfigList;

    protected
      function GetCaption: String; override;
      function GetLevelCaption(Index: Integer): String;
      function GetLayerDepth: Integer;
      function GetIsDirectoryCollection: Boolean;
      function GetSpecialContent: teSpecialContent;

      procedure AddCaptionConfig(aType: TCollectionConfig);
      procedure ReBuildCaptionTypes;
      property IsDirectoryCollection: Boolean read GetIsDirectoryCollection;
    public
      property LevelCaption[Index: Integer]: string read GetLevelCaption;
      property LayerDepth: Integer read GetLayerDepth;
      property SpecialContent: teSpecialContent read GetSpecialContent;
      property CollectionConfigList: TCollectionConfigList read fCollectionConfigList;

      constructor Create(aOwner: TLibraryCategory);
      destructor Destroy; override;
      procedure Clear; override;
      procedure Reset;
      // Special method for TagClouds:
      // ResetTagCloud: Clear all Sub-SubCollections to save Memory
      procedure ResetTagCloud;

      function ContainsContent(Value: teCollectionContent): Boolean;

      procedure AddSubCollectionType(aType: teCollectionContent; aSortingType: teCollectionSorting; aDirection: teSortDirection) overload;
      procedure AddSubCollectionType(aConfig: TCollectionConfig); overload;

      procedure InsertSubCollectionType(Index: Integer; aConfig: TCollectionConfig); overload;

      procedure MoveSubCollectionType(curIndex, newIndex: Integer);
      procedure ChangeSubCollectionType(Index: Integer; aConfig: TCollectionConfig);

      procedure ChangeSubCollectionSorting(Index: Integer; newSortingType: teCollectionSorting;
        newDirection: teSortDirection; OnlyDirection: Boolean);
      procedure RemoveSubCollection(Layer: Integer);

      function GetSubCollectionConfig(aLevel: Integer): TCollectionConfig;
      function GetSubCollectionType(aLevel: Integer): teCollectionContent;
      function GetCollectionCompareType(aLevel: Integer): teCollectionSorting;
      procedure ResortLevel(aLevel: Integer; newSorting: teCollectionSorting);

      procedure RemoveAudioFile(aAudioFile: TAudioFile); override;
      function RelocateAudioFile(aAudioFile: TAudioFile): Boolean; override;
      procedure RepairDriveChars(DriveManager: TDriveManager);
  end;

  TLibraryFileCategory = class(TLibraryCategory)
    protected
      function GetItemCount: Integer; override;
    public
      constructor Create;
      destructor Destroy; override;

      procedure RememberLastCollection(aCollection: TAudioCollection); override;
      function FindLastCollectionAgain: TAudioCollection;  override;
      function FindLastCollectionAgainTagCloud(var LastKeyFound, ExpandLastKey: Boolean): TAudioCollection;

      function AddRootCollection(aRootConfig: TCollectionConfigList): TRootCollection;

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

  function SortCollection_MissingCoverFirst(const item1, item2: TAudioFileCollection): Integer;
  function SortCollection_MissingCoverLast(const item1, item2: TAudioFileCollection): Integer;

  function CompareCollection_Default(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Album(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Artist(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Count(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Year(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_FileAge(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Genre(const item1,item2: TAudioFileCollection): Integer;
  function CompareCollection_Directory(const item1,item2: TAudioFileCollection): Integer;


  function GetAlbumArtistOrArtist(af: TAudioFile): String;
  function GenerateDirectoryAlbumKey(aAudioFile: TAudioFile): String;
  function GenerateArtistKey(aAudioFile: TAudioFile): String;
  function GenerateAlbumKey(aAudioFile: TAudioFile): String;
  function GenerateGenreKey(aAudioFile: TAudioFile): String;
  function GenerateDecadeKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
  function GenerateYearKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
  function GenerateFileAgeYearKey(aAudioFile: TAudioFile): String;
  function GenerateFileAgeMonthKey(aAudioFile: TAudioFile): String;

implementation

uses
  Hilfsfunktionen, StringHelper, AudioFileHelper, gnugettext, MainFormHelper;

type
  TKeyCache = record
    RawDirectory: String;
    ProcessedDirectory: String;
  end;

var
  fLibraryFormatSettings: TFormatSettings;
  KeyCache: TKeyCache;

const
  NempCollectionComparer: TCollectionCompareArray = (
        CompareCollection_Default,
        CompareCollection_Album,
        CompareCollection_Artist,
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
end;

function CompareCollection_Artist(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.fArtist, item2.fArtist);
end;

function CompareCollection_Count(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item1.Count, item2.Count); // reverse order
end;

function CompareCollection_Year(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item1.fYear, item2.fYear); // reverse order
end;

function CompareCollection_FileAge(const item1,item2: TAudioFileCollection): Integer;
begin
  result := CompareValue(item1.fFileAge, item2.fFileAge); // reverse order
end;

function CompareCollection_Genre(const item1,item2: TAudioFileCollection): Integer;
begin
  result := AnsiCompareText_NempIgnoreCase(item1.Genre, item2.Genre);
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

function GetAlbumArtistOrArtist(af: TAudioFile): String;
begin
  if NempOrganizerSettings.PreferAlbumArtist then begin
    result := af.AlbumArtist;
    if (result = '')
      or (NempOrganizerSettings.IgnoreVariousAlbumArtists and (AnsiSameText(result, 'Various Artists')))
    then
      result := af.Artist;
  end else
    result := af.Artist;
end;

function GenerateArtistKey(aAudioFile: TAudioFile): String;
begin
  result := AnsiLowerCase(GetAlbumArtistOrArtist(aAudioFile));
end;

function GenerateDirectoryAlbumKey(aAudioFile: TAudioFile): String;
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


function GenerateAlbumKey(aAudioFile: TAudioFile): String;
begin
  // todo: different key depending on settings (e.g. include Artist and/or Directory, the latter stripped by stuff like "CD 1")
  case NempOrganizerSettings.AlbumKeyMode of
    akAlbumOnly: result := AnsiLowerCase(aAudioFile.Album);
    akAlbumArtist: result := Format('%s||%s', [AnsiLowerCase(aAudioFile.Album), GenerateArtistKey(aAudioFile)]); //  AnsiLowerCase(aAudioFile.Artist)]
    akAlbumDirectory: result := Format('%s||%s', [AnsiLowerCase(aAudioFile.Album), GenerateDirectoryAlbumKey(aAudioFile)]);
    akDirectoryOnly: result := GenerateDirectoryAlbumKey(aAudioFile);
    akCoverID: result := aAudioFile.CoverID;
  end;
end;

function GenerateGenreKey(aAudioFile: TAudioFile): String;
begin
  result := trim(AnsiLowerCase(aAudioFile.Genre));
  // for later maybe: defining synonyms?
end;

function GenerateDecadeKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
begin
  IntYear := StrToIntDef(aAudioFile.Year, -1);
  result := YearToDecadeString(IntYear);
end;

function GenerateYearKey(aAudioFile: TAudioFile; out IntYear: Integer): String;
begin
  IntYear := StrToIntDef(aAudioFile.Year, -1);
  result := AddLeadingZeroes(IntYear, 4);
end;

function GenerateFileAgeYearKey(aAudioFile: TAudioFile): String;
begin
  result := FormatDateTime('yyyy', aAudioFile.FileAge, fLibraryFormatSettings);
end;

function GenerateFileAgeMonthKey(aAudioFile: TAudioFile): String;
begin
  result := FormatDateTime('yyyy-mm', aAudioFile.FileAge, fLibraryFormatSettings);
end;


{ TAudioFileCollection }

constructor TAudioFileCollection.Create(aOwner: TLibraryCategory; aRoot: TRootCollection; aLevel: Integer;
  CollectionMode: teFileCollectionMode = cmDefault);
begin
  inherited create(aOwner);

  fCollectionClass := ccFiles;
  fRoot := aRoot;
  fLevel := aLevel;
  fNeedSorting := False;
  fNeedAnalysis := False;
  fInsertMode := imList;
  fMissingCoverMode := mcIgnore;
  fCollectionList := TAudioFileCollectionList.Create(True);
  fIsAutoTag := True;

  if assigned(aRoot) then begin
    case CollectionMode of
      cmDefault: begin
        // note: aLevel >= 1 here, and therefore aLevel-1 >= 0
        fConfig := aRoot.GetSubCollectionConfig(aLevel-1);
        fChildConfig := aRoot.GetSubCollectionConfig(aLevel);
      end;
      cmDirectory: begin
        fConfig := cDirectoryCollectionConfig;
        fChildConfig := cDirectoryCollectionConfig;
      end;
      cmCloud: begin
        fConfig := cTagCloudCollectionConfig;
        fChildConfig := cEmptyCollectionConfig;
      end;
    end;
  end else
  begin
    fConfig := cEmptyCollectionConfig;
    fChildConfig := cEmptyCollectionConfig;
  end;
  fFileList := TAudioFileList.Create(False);
  fLastAddedAudioFile := Nil;
end;

destructor TAudioFileCollection.Destroy;
begin
  fFileList.Free;
  if assigned(fCollectionDict) then
    fCollectionDict.Free;
  fCollectionList.Free;

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

function TAudioFileCollection.isCloud: Boolean;
begin
  result := (Content = ccTagCloud)
      or ((Content = ccRoot) and (ChildContent = ccTagCloud))
end;

procedure TAudioFileCollection.DoGetFiles(dest: TAudioFileList;
  recursive: Boolean);
var
  i: Integer;
begin
  for i := 0 to fFileList.Count - 1 do
    dest.Add(fFileList[i]);

  if recursive and (not isCloud) and assigned(fCollectionList) then begin
    for i := 0 to fCollectionList.Count - 1 do
      fCollectionList[i].DoGetFiles(dest, recursive);
  end;
end;

procedure TAudioFileCollection.GetReverseFiles(dest: TAudioFileList);
var
  aProp: String;
begin
  aProp := '';
  case Content of
    //ctNone: ;
    //ctRoot: ;
    ccArtist: aProp := fArtist;
    ccAlbum: aProp := fAlbum;
    //ctDirectory: ;
    ccGenre: aProp := fGenre;
    //ctDecade: ;
    ccYear: aProp := IntToStr(fYear);
    //ctFileAgeYear: ;
    //ctFileAgeMonth: ;
  else
    aProp := '';
  end;

  if aProp <> '' then
    fRoot.GetReverseFilesByProperty(
      dest, Content, aProp)
  else
    GetFiles(dest, True);
end;

procedure TAudioFileCollection.GetReverseFilesByProperty(dest: TAudioFileList; aCollectionType: teCollectionContent; aProperty: String);
var
  i: Integer;

  function isMatch(aFile: TAudioFile): Boolean;
  begin
    case aCollectionType of
      //ctNone: ;
      //ctRoot: ;
      ccArtist: result := aFile.Artist = aProperty;
      ccAlbum: result := aFile.Album = aProperty;
      //ctDirectory: ;
      ccGenre: result := aFile.Genre = aProperty;
      //ctDecade: ;
      ccYear: result := aFile.Year = aProperty;
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

  if assigned(self.fCollectionList) then begin
    for i := 0 to fCollectionList.Count - 1 do
      fCollectionList[i].GetReverseFilesByProperty(dest, aCollectionType, aProperty);
  end;
end;

procedure TAudioFileCollection.ClearSubCollections;
begin
  fCollectionList.Clear;
  if assigned(fCollectionDict) then
    fCollectionDict.Clear;
end;

function TAudioFileCollection.ExpandTagCloud(DoSort: Boolean = False): Boolean;
var
  i: Integer;
begin
  result := Content = ccRoot;
  if Content <> ccTagCloud then
    exit;
  if fFileList.Count <= 1 then
    exit;

  ChildContent := ccTagCloud;
  // clear existing subcollections, to be sure
  ClearSubCollections;

  for i := 0 to fFileList.Count - 1 do
    AddForTagCloud(fFileList[i]);

  if DoSort then
    ReSort(Root.ChildSorting, Root.ChildSortDirection);

  result := True;
end;

function TAudioFileCollection.BuildCaption(IncludeCount: Boolean): String;
var
  mainValue, displayArtist, displayAlbum: String;

  procedure GetDisplayValues;
  begin
    if ValidArtist then
      displayArtist := self.fArtist
    else
      displayArtist := _(CoverFlowText_VariousArtists);
    if ValidAlbum then
      displayAlbum := self.fAlbum
    else
      displayAlbum := _(CoverFlowText_UnkownCompilation)
  end;

begin
  case self.Content of
    ccNone: mainValue := '<Error>'; //
    ccRoot: mainValue := ''; // should be handled by TRootCollection
    ccArtist:  mainValue := self.fArtist;
    ccAlbum: begin
      GetDisplayValues;
      if assigned(fParent)
        and (fParent.ChildSorting = csArtist)
      then
        mainValue := Format('%s - %s', [displayArtist, displayAlbum])
      else begin
        mainValue := Format('%s - %s', [displayArtist, displayAlbum]); //fKeyData.Album;
      end;
    end;
    ccDirectory: mainValue := fKey; //  .Directory;
    ccGenre: mainValue := fGenre;
    ccDecade: mainValue := IntToStr(fYear);
    ccYear: mainValue := IntToStr(fYear);
    ccFileAgeYear: mainValue := FormatDateTime('yyyy', fFileAge, fLibraryFormatSettings);
    ccFileAgeMonth: mainValue := FormatDateTime('mmmm yy', fFileAge, fLibraryFormatSettings);
  else
    mainValue := fKey;
  end;

  if mainValue = '' then
    mainValue := rsCollectionDataUnknown;

  if IncludeCount then
    result := Format('%s (%d)', [mainValue, Count] )
  else
    result := mainValue;
end;

function TAudioFileCollection.GetCaption: String;
begin
  result := BuildCaption(NempOrganizerSettings.ShowElementCount)
end;

function TAudioFileCollection.GetSimpleCaption: String;
begin
  result := BuildCaption(False);
end;

function TAudioFileCollection.GetCategoryCaption: String;
begin
  if assigned(fOwnerCategory) then
    result := fOwnerCategory.Name
  else
    result := '';
end;


function TAudioFileCollection.GetCoverID: String;
begin
  result := fCoverID;
end;

function TAudioFileCollection.CalculateFileDuration: Int64;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to fFileList.Count - 1 do
    result := result + fFileList[i].Duration;
end;

procedure TAudioFileCollection.GetCommonArtist;
var
  i, maxIdx: Integer;
  aStringlist: TStringList;
  mismatchPos: Integer;
  str1, tmpArtist : String;

begin
  // for a common "Artist", we should not work with collections.
  // On some albums, there are a lot tracks from "main artist feat. other artist"
  // or something like that. That should be recognized as "main artist"
  if fFileList.Count <= 50 then
    maxIdx := fFileList.Count-1
  else
    maxIdx := 50;

  aStringlist := TStringList.Create;
  try
    for i := 0 to maxIdx do begin
      tmpArtist := GetAlbumArtistOrArtist(fFileList[i]);
      if (tmpArtist <> '') then
        aStringlist.Add(tmpArtist);
    end;

    mismatchPos := 0;
    str1 := GetCommonString(aStringlist, 0, mismatchPos);  // error tolerance: 0
    if str1 = '' then begin
      fArtist := CoverFlowText_VariousArtists;
      fValidArtist := False;
    end
    else begin
      fArtist := str1;
      fValidArtist := True;
    end;
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
    if str1 = '' then begin
      fAlbum := ''; // CoverFlowText_UnkownCompilation; // 'Unknown compilation';
      fValidAlbum := False;
    end
    else
    begin
      if mismatchPos <= length(str1) Div 2 +1 then begin
        fAlbum := str1;
        fValidAlbum := True;
      end
      else begin
        fAlbum := copy(str1, 1, mismatchPos-1) + ' ... ';
        fValidAlbum := True;
      end;
    end;
  finally
    aStringList.Free;
  end;
end;

class function TAudioFileCollection.HasUniqueValue(aCollection: TAudioFileCollection): teCollectionUniqueness;
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
        aCollection.Sort(False); // by Count
        FileCount := aCollection.Count;

        if (FileCount > 5) and (FileCount <= 10) and (aCollection.fCollectionList[0].Count > (FileCount - 1)) then
          result := cuUnique
        else
          if (aCollection.fCollectionList[0].Count >= Round(FileCount * 0.9)) then
            result := cuUnique;
      end;
  end;
end;

procedure TAudioFileCollection.GetCommonCoverID;
begin
  fCoverID := CommonCoverID(fFileList);
end;

class function TAudioFileCollection.CommonCoverID(AudioFiles: TAudioFileList): String;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  // use the most common CoverID
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ccCoverID, csCount, sd_Descending);
    for i := 0 to AudioFiles.Count - 1 do
      aRoot.AddAudioFile(AudioFiles[i]);
    aRoot.Sort(False);

    case HasUniqueValue(aRoot) of
      cuUnique: Result := TAudioFileCollection(aRoot.Collection[0]).fCoverID;
    else
      //cuInvalid, cuSampler
       Result := ''; //TAudioFileCollection(aRoot.Collection[0]).fCoverID;
    end;
    //fCoverID := TAudioFileCollection(aRoot.Collection[0]).fCoverID;
    //if fCoverID= '' then
    //  fCoverID := IntToStr(aRoot.CollectionCount); ????? Why ?????
  finally
    aRoot.Free;
  end;
end;

procedure TAudioFileCollection.GetCommonDirectory;
var
  i: Integer;
  aRoot: TRootCollection;
begin
  aRoot := TRootCollection.Create(nil);
  try
    aRoot.AddSubCollectionType(ccPath, csCount, sd_Descending);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);
    aRoot.Sort(False);

    case HasUniqueValue(aRoot) of
      cuUnique: fDirectory := TAudioFileCollection(aRoot.Collection[0]).fDirectory;
      // cuSampler: fDirectory := TAudioFileCollection(aRoot.Collection[0]).fDirectory;
    else
      //cuInvalid, cuSampler
       fDirectory := '';
    end;
    // fDirectory := TAudioFileCollection(aRoot.Collection[0]).fDirectory; // ? no. That is not a good idea
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
    aRoot.AddSubCollectionType(ccGenre, csCount, sd_Descending);
    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);

    case HasUniqueValue(aRoot) of
      cuUnique: begin
          if TAudioFileCollection(aRoot.Collection[0]).fGenre = '' then
            fGenre := rsCollectionDataUnknown
          else
            fGenre := TAudioFileCollection(aRoot.Collection[0]).fGenre;
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
    aRoot.AddSubCollectionType(ccYear, csCount, sd_Descending);

    for i := 0 to fFileList.Count - 1 do
      aRoot.AddAudioFile(fFileList[i]);

    case HasUniqueValue(aRoot) of
      cuUnique: fYear := TAudioFileCollection(aRoot.Collection[0]).fYear;
      cuSampler: fYear := TAudioFileCollection(aRoot.Collection[0]).fYear;
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

procedure TAudioFileCollection.Analyse(recursive, ForceAnalysis: Boolean);
var
  i: Integer;
begin
  fDuration := 0;
  if recursive then
    for i := 0 to fCollectionList.Count - 1 do begin
      fCollectionList[i].Analyse(recursive, ForceAnalysis);
      fDuration := fDuration + fCollectionList[i].fDuration;
    end;

  if (fFileList.Count = 0) or (not fNeedAnalysis) then
    exit; // nothing more to do in that case

  fDuration := fDuration + CalculateFileDuration;

  if ForceAnalysis then begin
    GetCommonArtist;
    GetCommonAlbum;
    GetCommonGenre;
    GetCommonYear;
    GetCommonFileAge;
    GetCommonDirectory;
    getCommonCoverID;
  end else
  begin
    case self.Content of
      ccNone: ;
      ccRoot: ;
      ccArtist: ;
      ccAlbum: begin
            // like in the "Coverflow"
            GetCommonArtist;
            GetCommonAlbum;
            GetCommonGenre;
            GetCommonYear;
            GetCommonFileAge;
            GetCommonDirectory;
            getCommonCoverID;
      end;
      ccDirectory: begin
            // maybe useful for different sortings than "by directory name"
            //GetCommonArtist;
            //GetCommonAlbum;
            //GetCommonGenre;
            //GetCommonYear;
            GetCommonFileAge;
      end;
      ccGenre: ;
      ccDecade: ;
      ccYear: ;
      ccFileAgeYear: ;
      ccFileAgeMonth: ;
    end;
  end;
  // Analysis done.
  fNeedAnalysis := False;
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
        for i := 0 to fCollectionList.Count - 1 do begin
          if fCollectionList[i].fKey = aKey then begin
            Value := fCollectionList[i];
            result := True;
            break;
          end;
        end;
    end;
    imDictionary: begin
      if fCollectionDict.ContainsKey(aKey) then
        if fCollectionDict.TryGetValue(aKey, aCollection) then
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
  fCollectionDict := TAudioFileCollectionDict.Create(2 * fCollectionList.Count);
  for i := 0 to fCollectionList.Count - 1 do begin
    aCollection := fCollectionList[i];
    fCollectionDict.Add(aCollection.fKey, aCollection);
  end;
  fInsertMode := imDictionary;
end;

function TAudioFileCollection.InitNewCollection(aKey: String; CollectionMode: teFileCollectionMode = cmDefault): TAudioFileCollection;
begin
  fNeedSorting := True;
  result := TAudioFileCollection.Create(fOwnerCategory, fRoot, fLevel + 1, CollectionMode);
  result.fParent := self;
  result.fKey := aKey;

  case fInsertMode of
    imList: begin
      fCollectionList.Add(result);
    end;
    imDictionary: begin
      fCollectionList.Add(result);
      fCollectionDict.Add(aKey, result);
    end;
  end;

  if (fInsertMode = imList) and (fCollectionList.Count > MAX_LIST_SIZE) then
    SwitchToDictionary;
end;

function TAudioFileCollection.MatchPrefix(aPrefix: String): Boolean;
begin
  case self.Content of
    ccNone: result := False;
    ccRoot: result := False;
    ccArtist: result := AnsiStartsText(aPrefix, fArtist);
    ccAlbum: result := AnsiStartsText(aPrefix, fArtist) or AnsiStartsText(aPrefix, fAlbum);
    ccDirectory: result := AnsiStartsText(aPrefix, fKey);
    ccGenre: result := AnsiStartsText(aPrefix, fGenre);
    ccDecade: result := AnsiStartsText(aPrefix, IntToStr(fYear));
    ccYear: result := AnsiStartsText(aPrefix, IntToStr(fYear));
    ccFileAgeYear: result := AnsiStartsText(aPrefix, FormatDateTime('yyyy', fFileAge, fLibraryFormatSettings));
    ccFileAgeMonth: result := AnsiStartsText(aPrefix, FormatDateTime('mmmm yy', fFileAge, fLibraryFormatSettings));
  else
    result := AnsiStartsText(aPrefix, fKey);
  end;
end;


{
 Not in use yet ...
}
function TAudioFileCollection.PerformSearch(aKeyword: String; ParentAreadyMatches: Boolean): Boolean;
var
  tmpMatch, childMatch: Boolean;
  i: Integer;
begin

  fMatchesCurrentSearch := ParentAreadyMatches;

  if not fMatchesCurrentSearch then begin
      case self.Content of
        ccArtist: fMatchesCurrentSearch := AnsiContainsText(fArtist, aKeyword);
        ccAlbum: fMatchesCurrentSearch := AnsiContainsText(fArtist, aKeyword) or AnsiContainsText(fAlbum, aKeyword);
        ccDirectory: fMatchesCurrentSearch := AnsiContainsText(fKey, aKeyword);
        ccGenre: fMatchesCurrentSearch := AnsiContainsText(fGenre, aKeyword);
        ccDecade: fMatchesCurrentSearch := AnsiContainsText(IntToStr(fYear), aKeyword);
        ccYear: fMatchesCurrentSearch := AnsiContainsText(IntToStr(fYear), aKeyword);
        ccFileAgeYear: fMatchesCurrentSearch := AnsiContainsText(FormatDateTime('yyyy', fFileAge, fLibraryFormatSettings), aKeyword);
        ccFileAgeMonth: fMatchesCurrentSearch := AnsiContainsText(FormatDateTime('mmmm yy', fFileAge, fLibraryFormatSettings), aKeyword);
      else
        fMatchesCurrentSearch := AnsiContainsText(fKey, aKeyword);
      end;
  end;

  tmpMatch := False;
  if (not isCloud) and assigned(fCollectionList) then begin
    for i := 0 to fCollectionList.Count - 1 do begin
      childMatch := fCollectionList[i].PerformSearch(aKeyword, fMatchesCurrentSearch);
      tmpMatch := tmpMatch or childMatch;
    end;
  end;

  fMatchesCurrentSearch := fMatchesCurrentSearch or tmpMatch;
  result := fMatchesCurrentSearch;
end;

function TAudioFileCollection.ComparePrefix(aPrefix: String): Integer;
begin
  if MatchPrefix(aPrefix) then
    result := 0
  else
    result := 1;
end;

function TAudioFileCollection.IndexOf(aCollection: TAudioCollection): Integer;
begin
  if assigned(aCollection) and (aCollection is TAudioFileCollection)  then
    result := fCollectionList.IndexOf(TAudioFileCollection(aCollection))
  else
    result := 0;
end;

procedure TAudioFileCollection.AddByArtist(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  aKey: String;
begin
  aKey := GenerateArtistKey(aAudioFile);
  if not TryGetCollection(aKey, aCollection) then begin
    aCollection := InitNewCollection(aKey);
    aCollection.fArtist := GetAlbumArtistOrArtist(aAudioFile);
  end;
  aCollection.AddAudioFile(aAudioFile);
end;

procedure TAudioFileCollection.AddByAlbum(aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByGenre(aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByDecade(aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByPath (aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByCoverID(aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByYear(aAudioFile: TAudioFile);
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
end;

procedure TAudioFileCollection.AddForTagCloud(aAudioFile: TAudioFile);
var
  aCollection: TAudioFileCollection;
  i: Integer;
  AutoTags, LastFMTags: TStringList;

  function IsParentTag(newTag: String): Boolean;
  var
    col: TAudioFileCollection;
  begin
    result := False;
    col := self;
    while (not (col is TRootCollection)) and (not result) do begin
      result := result or (col.Key = newTag);
      col := col.Parent;
    end;
  end;

  procedure AddTag(newTag: String; IsLastFMTag: Boolean = False);
  begin
    if not IsParentTag(newTag) then begin
      if not TryGetCollection(newtag, aCollection) then begin
        aCollection := InitNewCollection(newTag, cmCloud);
      end;
      if aCollection.fLastAddedAudioFile <> aAudioFile then
        aCollection.AddAudioFile(aAudioFile);
      if IsLastFMTag then
        aCollection.IsAutotag := False;
    end;
  end;

begin
  AutoTags := TStringList.Create;
  LastFMTags := TStringList.Create;
  try
    aAudioFile.GetAllTags(AutoTags, LastFMTags);
    for i := 0 to AutoTags.Count - 1 do
      AddTag(Autotags[i]);
    for i := 0 to LastFMTags.Count - 1 do
      AddTag(LastFMTags[i], True);
  finally
    AutoTags.Free;
    LastFMtags.Free;
  end;
end;

procedure TAudioFileCollection.Clear;
begin
  fCount := 0;
  fNeedSorting := False;
  fIsAutoTag := True;
  fFileList.Clear;
  fCollectionList.Clear;
  if assigned(fCollectionDict) then
    fCollectionDict.Clear;
end;

procedure TAudioFileCollection.RemoveEmptyCollections;
var
  i: Integer;
begin
  for i := fCollectionList.Count - 1 downto 0 do begin
    if fCollectionList[i].Count = 0 then
      RemoveCollection(fCollectionList[i])
    else
      fCollectionList[i].RemoveEmptyCollections;
  end;
end;

procedure TAudioFileCollection.AddByFileAgeYear (aAudioFile: TAudioFile);
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

procedure TAudioFileCollection.AddByFileAgeMonth(
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

procedure TAudioFileCollection.AddByDirectory (aAudioFile: TAudioFile);
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
        aCollection := aCurrentCollection.InitNewCollection(newKey, cmDirectory);
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
  fLastAddedAudioFile := aAudioFile;
  case ChildContent of
    ccNone: begin
      fFileList.Add(aAudioFile);
      fNeedAnalysis := True;
    end;
    ccRoot: ; // should never happen
    ccArtist: AddByArtist(aAudioFile);
    ccAlbum: AddByAlbum(aAudioFile);
    ccDirectory: AddByDirectory(aAudioFile);
    ccGenre: AddByGenre(aAudioFile);
    ccDecade: AddByDecade(aAudioFile);
    ccYear: AddByYear(aAudioFile);
    ccFileAgeYear: AddByFileAgeYear(aAudioFile);
    ccFileAgeMonth: AddByFileAgeMonth(aAudioFile);
    ccTagCloud: begin
      fFileList.Add(aAudioFile);
      fNeedAnalysis := True;
      AddForTagCloud(aAudioFile);
    end;
    ccPath: AddByPath(aAudioFile);
    ccCoverID: AddByCoverID(aAudioFile);
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

function TAudioFileCollection.GetCollectionByKey(aKey: String): TAudioFileCollection;
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
  case ChildContent of
    ccNone: begin
      if (not CheckExist) or fFileList.Contains(aAudioFile) then
        result := self
      else
        result := Nil;
    end;
    ccRoot: result := Nil; // should never happen
    ccArtist: begin
      aKey := GenerateArtistKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccAlbum: begin
      aKey := GenerateAlbumKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccDirectory: begin
      result := SearchAudioFileByPath(aAudioFile, CheckExist);
    end;
    ccGenre: begin
      aKey := GenerateGenreKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccDecade: begin
      aKey := GenerateDecadeKey(aAudioFile, dummy);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccYear:  begin
      aKey := GenerateYearKey(aAudioFile, dummy);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccFileAgeYear: begin
      aKey := GenerateFileAgeYearKey(aAudioFile);
      result := SearchAudioFileByKey(aKey, aAudioFile, CheckExist);
    end;
    ccFileAgeMonth:  begin
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
    for i := 0 to fCollectionList.Count - 1 do begin
      result := fCollectionList[i].SearchEditedAudioFile(aAudioFile);
      if assigned(result) then
        break;
    end;
  end;
end;

function TAudioFileCollection.CompareCollection_Main(const item1,item2: TAudioFileCollection): Integer;
var actSorting: teCollectionSorting;
begin
  result := 0;
  case fChildConfig.SortDirection1 of
    sd_Ascending  : result := NempCollectionComparer[fChildConfig.PrimarySorting](item1, item2);
    sd_Descending : result := NempCollectionComparer[fChildConfig.PrimarySorting](item2, item1);
  end;

  if result = 0 then begin
      if (fChildConfig.PrimarySorting = csArtist)
        and (fChildConfig.SecondarySorting = csYear)
        and (not Item1.ValidArtist)
        and (NempOrganizerSettings.SamplerSortingIgnoreReleaseYear)
      then
        actSorting := csAlbum
      else
        actSorting := fChildConfig.SecondarySorting;

      case fChildConfig.SortDirection2 of
        sd_Ascending  : result := NempCollectionComparer[actSorting](item1, item2);
        sd_Descending : result := NempCollectionComparer[actSorting](item2, item1);
      end;

      if result = 0 then begin
          if (fChildConfig.SecondarySorting = csArtist)
            and (fChildConfig.TertiarySorting = csYear)
            and (not Item1.ValidArtist)
            and (NempOrganizerSettings.SamplerSortingIgnoreReleaseYear)
          then
            actSorting := csAlbum
          else
            actSorting := fChildConfig.TertiarySorting;

          case fChildConfig.SortDirection3 of
            sd_Ascending  : result := NempCollectionComparer[actSorting](item1, item2);
            sd_Descending : result := NempCollectionComparer[actSorting](item2, item1);
          end;

          if result = 0 then
            result := AnsiCompareText_NempIgnoreCase(item1.fKey, item2.fKey);
        end;
  end;
end;

procedure TAudioFileCollection.Sort(doRecursive: Boolean = True);
var
  i: Integer;
begin
  if fNeedSorting then begin
    case fMissingCoverMode of
      mcFirst: fCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := SortCollection_MissingCoverFirst(item1, item2);
                    if result = 0 then
                      result := CompareCollection_Main(item1, item2);
                  end));
      mcIgnore:  fCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := CompareCollection_Main(item1, item2);
                  end));
      mcEnd: fCollectionList.Sort(TComparer<TAudioFileCollection>.Construct( function (const item1, item2: TAudioFileCollection): Integer
                  begin
                    result := SortCollection_MissingCoverLast(item1, item2);
                    if result = 0 then
                      result := CompareCollection_Main(item1, item2);
                  end));
    end;
    fNeedSorting := False;
  end;
  if doRecursive then begin
    for i := 0 to self.fCollectionList.Count - 1 do
      fCollectionList[i].Sort(doRecursive);
  end;
end;


procedure TAudioFileCollection.ReSort(newSorting: teCollectionSorting; newDirection: teSortDirection);
begin
  fChildConfig.PrimarySorting := newSorting;
  fChildConfig.SortDirection1 := newDirection;
  fNeedSorting := True;
  Sort(False);
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
    fChildConfig := fRoot.GetSubCollectionConfig(aLevel);
    Sort(False);
    fNeedSorting := False;
  end else
  begin
    for i := 0 to fCollectionList.Count - 1 do
      fCollectionList[i].SortCollectionLevel(aLevel, ForceSorting);
  end;
end;

procedure TAudioFileCollection.ReSortDirectoryCollection(newSorting: teCollectionSorting;
  newDirection: teSortDirection; OnlyDirection: Boolean; recursive: Boolean);
var
  i: Integer;
begin
  PrepareForNewPrimarySorting(fChildConfig);
  if OnlyDirection then
    fChildConfig.SortDirection1 := newDirection
  else begin
    fChildConfig.PrimarySorting := newSorting;
    fChildConfig.SortDirection1 := newDirection;
  end;
  fNeedSorting := True;
  Sort(False);
  if recursive then
    for i := 0 to fCollectionList.Count - 1 do
      fCollectionList[i].ReSortDirectoryCollection(newSorting, newDirection, OnlyDirection, recursive);
end;

procedure TAudioFileCollection.ReSortTagCloudCollection(newSorting: teCollectionSorting;
  newDirection: teSortDirection; OnlyDirection: Boolean; recursive: Boolean);
var
  i: Integer;
begin
  PrepareForNewPrimarySorting(fChildConfig);
  if OnlyDirection then
    fChildConfig.SortDirection1 := newDirection
  else begin
    fChildConfig.PrimarySorting := newSorting;
    fChildConfig.SortDirection1 := newDirection;
  end;
  fNeedSorting := True;
  Sort(False);
  if recursive then
    for i := 0 to fCollectionList.Count - 1 do
      fCollectionList[i].ReSortTagCloudCollection(newSorting, newDirection, OnlyDirection, recursive);
end;

function TAudioFileCollection.GetCollection(Index: Integer): TAudioCollection;
begin
  result := fCollectionList[Index];
end;

function TAudioFileCollection.GetCollectionCount: Integer;
begin
  result := fCollectionList.Count;
end;

function TAudioFileCollection.GetContent: teCollectionContent;
begin
  result := fConfig.Content;
end;

function TAudioFileCollection.GetPrimaryChildSorting: teCollectionSorting;
begin
  result := fChildConfig.PrimarySorting;
end;

function TAudioFileCollection.GetSecondaryChildSorting: teCollectionSorting;
begin
  result := fChildConfig.SecondarySorting;
end;

function TAudioFileCollection.GetPrimaryChildSortDirection: teSortDirection;
begin
  result := fChildConfig.SortDirection1;
end;

function TAudioFileCollection.GetChildContent: teCollectionContent;
begin
  result := fChildConfig.Content;
end;

procedure TAudioFileCollection.SetChildContent(Value: teCollectionContent);
begin
  fChildConfig.Content := Value;
end;

procedure TAudioFileCollection.DecreaseCount(recursive: Boolean);
begin
  dec(fCount);
  if recursive and (fLevel > 0) and assigned(fParent) then
    fParent.DecreaseCount(recursive);
end;

procedure TAudioFileCollection.RemoveAudioFile(aAudioFile: TAudioFile);
var
  aIdx: Integer;
begin
  aIdx := fFileList.IndexOf(aAudioFile);
  if aIdx > -1 then begin
    fFileList.Delete(aIdx);
    DecreaseCount(True);
    fNeedAnalysis := True;
  end;
end;

procedure TAudioFileCollection.RemoveAudioFileFromTagCloud(aAudioFile: TAudioFile);
var
  i, aIdx: Integer;
begin
  if Content <> ccTagCloud then
    exit;

  aIdx := fFileList.IndexOf(aAudioFile);
  if aIdx > -1 then begin
    dec(fCount);
    fFileList.Delete(aIdx);
    for i := 0 to CollectionCount - 1 do
      TAudioFileCollection(Collection[i]).RemoveAudioFileFromTagCloud(aAudioFile);
  end;
end;

function TAudioFileCollection.RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
var
  ac: TAudioFileCollection;
begin
  ac := SearchAudioFile(aAudioFile, True);
  fNeedAnalysis := True;
  if assigned(ac) then begin
    result := True;  //False
    ac.fNeedAnalysis := True;
  end
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
    fCollectionDict.Remove(aCollection.fKey);

  fCollectionList.Remove(aCollection); // this will also free the collection

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
  fCollectionConfigList.Clear;
  fCaptionConfigList.Clear;
end;

procedure TRootCollection.ResetTagCloud;
var
  i: Integer;
begin
  if ChildContent = ccTagCloud then
    for i := 0 to fCollectionList.Count - 1 do
      tAudioFileCollection(Collection[i]).ClearSubCollections;
end;

function TRootCollection.ContainsContent(Value: teCollectionContent): Boolean;
var
  i: Integer;
begin
  result := False;
  for i := 0 to fCollectionConfigList.Count - 1 do
    result := result or (Value = fCollectionConfigList[i].Content);

  if (not Result) and (Value = ccYear) then begin
    // also check for content "Decade"
    for i := 0 to fCollectionConfigList.Count - 1 do
      result := result or (fCollectionConfigList[i].Content = ccDecade);
  end;
end;

constructor TRootCollection.Create(aOwner: TLibraryCategory);
begin
  inherited create(aOwner, Nil, 0);
  fParent := Nil;
  fRoot := self;
  fCollectionConfigList := TCollectionConfigList.Create;
  fCaptionConfigList := TCollectionConfigList.Create;

  fConfig.Content := ccRoot; //fContent := ccRoot;
  fChildConfig.Content := ccNone;  // muss später bestimmt werden, nach dem Einfügen der SubCollectionTypes
end;

destructor TRootCollection.Destroy;
begin
  fCollectionConfigList.Free;
  fCaptionConfigList.Free;
  inherited;
end;

procedure TRootCollection.AddCaptionConfig(aType: TCollectionConfig);
var
  newCaptionData: TCollectionConfig;
begin
  case aType.Content of
    ccNone,
    ccRoot: ; // nothing todo
    ccArtist,
    ccAlbum,
    ccDirectory,
    ccGenre: newCaptionData.Content := aType.Content;
    ccDecade,
    ccYear: newCaptionData.Content := ccYear;
    ccFileAgeYear,
    ccFileAgeMonth: newCaptionData.Content := ccFileAgeYear;
  else
    newCaptionData.Content := aType.Content;
  end;

  if (fCaptionConfigList.Count = 0)
  or (fCaptionConfigList[fCaptionConfigList.Count-1].Content <> newCaptionData.Content)
  then
    fCaptionConfigList.Add(newCaptionData)
end;

procedure TRootCollection.AddSubCollectionType(aType: teCollectionContent;
  aSortingType: teCollectionSorting; aDirection: teSortDirection);
var
  newConfig: TCollectionConfig;
begin
  newConfig := cEmptyCollectionConfig;
  newConfig.Content := aType;
  newConfig.PrimarySorting := aSortingType;
  newConfig.SortDirection1 := aDirection;
  fCollectionConfigList.Add(newConfig);
  fChildConfig := fCollectionConfigList[0];
  AddCaptionConfig(newConfig);
end;

procedure TRootCollection.AddSubCollectionType(aConfig: TCollectionConfig);
begin
  fCollectionConfigList.Add(aConfig);
  fChildConfig := fCollectionConfigList[0];
  AddCaptionConfig(aConfig);
end;

procedure TRootCollection.InsertSubCollectionType(Index: Integer;
  aConfig: TCollectionConfig);
begin
  fCollectionConfigList.Insert(Index, aConfig);
  fChildConfig := fCollectionConfigList[0];
  ReBuildCaptionTypes;
end;

procedure TRootCollection.MoveSubCollectionType(curIndex, newIndex: Integer);
begin
  fCollectionConfigList.Move(curIndex, newIndex);
  fChildConfig := fCollectionConfigList[0];
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ChangeSubCollectionSorting(Index: Integer; newSortingType: teCollectionSorting;
  newDirection: teSortDirection; OnlyDirection: Boolean);
var
  changedConfig: TCollectionConfig;
begin
  changedConfig := fCollectionConfigList[Index];
  if OnlyDirection then
    changedConfig.SortDirection1 := newDirection
  else begin
    PrepareForNewPrimarySorting(changedConfig);
    changedConfig.PrimarySorting := newSortingType;
    changedConfig.SortDirection1 := newDirection;
  end;
  fCollectionConfigList[Index] := changedConfig;
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ChangeSubCollectionType(Index: Integer; aConfig: TCollectionConfig);
begin
  fCollectionConfigList[Index] := aConfig;
  fChildConfig := fCollectionConfigList[0];
  ReBuildCaptionTypes;
end;

procedure TRootCollection.ReBuildCaptionTypes;
var
  i: Integer;
begin
  fCaptionConfigList.Clear;
  for i := 0 to fCollectionConfigList.Count-1 do
    AddCaptionConfig(fCollectionConfigList[i]);
end;

procedure TRootCollection.RemoveSubCollection(Layer: Integer);
begin
  // Layer entfernen, CaptionTyplist erneuern
  fCollectionConfigList.Delete(Layer);
  ReBuildCaptionTypes;
end;

function TRootCollection.GetSubCollectionConfig(aLevel: Integer): TCollectionConfig;
begin
  if (aLevel >= 0) and (aLevel < fCollectionConfigList.Count) then
    result := fCollectionConfigList[aLevel]
  else
    result := cEmptyCollectionConfig
end;

function TRootCollection.GetSubCollectionType(aLevel: Integer): teCollectionContent;
begin
  if (aLevel >= 0) and (aLevel < fCollectionConfigList.Count) then
    result := fCollectionConfigList[aLevel].Content
  else
    result := ccNone;
end;

function TRootCollection.GetCollectionCompareType(aLevel: Integer): teCollectionSorting;
begin
  if (aLevel >= 0) and (aLevel < fCollectionConfigList.Count) then
    result := fCollectionConfigList[aLevel].PrimarySorting
  else
    result := csDefault;
end;

function TRootCollection.GetCaption: String;
var
  i: Integer;
begin
  if fCaptionConfigList.Count > 0 then
    result := _(RootCaptions[fCaptionConfigList[0].Content]);

  for i := 1 to fCaptionConfigList.Count - 1 do
    result := result + ' - ' + _(RootCaptions[fCaptionConfigList[i].Content]);
end;

function TRootCollection.GetLevelCaption(Index: Integer): String;
begin
  if (fCollectionConfigList.Count > Index) and (Index >= 0) then
    result := _(RootCaptionsExact[fCollectionConfigList[Index].Content])
  else
    result := '';
end;

function TRootCollection.GetLayerDepth: Integer;
begin
  result := fCollectionConfigList.Count;
end;

function TRootCollection.GetIsDirectoryCollection: Boolean;
begin
  result := (fCollectionConfigList.Count > 0)
      and (fCollectionConfigList[0].Content = ccDirectory);
end;

function TRootCollection.GetSpecialContent: teSpecialContent;
begin
  result := scRegular;
  if fCollectionConfigList.Count > 0 then
    case fCollectionConfigList[0].Content of
      ccDirectory: result := scDirectory;
      ccTagCloud: result := scTagCloud;
    else
      ; //ccNone, ccRoot, ccArtist, ccAlbum, ccGenre, ccDecade, ccYear, ccFileAgeYear, ccFileAgeMonth,
    end;
end;


procedure TRootCollection.ResortLevel(aLevel: Integer; newSorting: teCollectionSorting);
begin
  if (aLevel < 0) or (aLevel >= fCollectionConfigList.Count) or (fCollectionConfigList[aLevel].PrimarySorting = newSorting) then
    exit; // nothing to do

  fCollectionConfigList.list[aLevel].PrimarySorting := newSorting;
  SortCollectionLevel(aLevel)
end;

procedure TRootCollection.RemoveAudioFile(aAudioFile: TAudioFile);
var
  leafCollection: TAudioFileCollection;
  i: Integer;
begin
  if ChildContent = ccTagCloud then begin
    // the File could be everywhere, and in multiple collections
    fFileList.Remove(aAudioFile);
    fCount := fFileList.Count;
    for i := 0 to CollectionCount - 1 do
      TAudioFileCollection(Collection[i]).RemoveAudioFileFromTagCloud(aAudioFile);
  end else
  begin
    // get the Collection that (should) contain the AudioFile
    leafCollection := SearchAudioFile(aAudioFile, True);
    if not assigned(leafCollection) then
      exit;
    // removes the AudioFile from the leafCollection.fFilelist and decreases the Counter (also in all ParentCollections)
    leafCollection.RemoveAudioFile(aAudioFile);
  end;
end;

function TRootCollection.RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
begin
  if ChildContent = ccTagCloud then begin
    result := True;
    RemoveAudioFile(aAudioFile);
    AddAudioFile(aAudioFile);
  end else
  begin
    result := inherited RelocateAudioFile(aAudioFile);
  end;
end;


procedure TRootCollection.RepairDriveChars(DriveManager: TDriveManager);
var
  i: Integer;
  aDrive: TDrive;
  somethingChanged: Boolean;
begin
  if ChildContent <> ccDirectory then
    exit; // nothing to do

  somethingChanged := False;
  for i := 0 to self.fCollectionList.Count - 1 do begin
    if fCollectionList[i].Key[1] <> '\' then begin
      aDrive := DriveManager.GetManagedDriveByOldChar(fCollectionList[i].Key[1]);
      if assigned(aDrive) and (aDrive.Drive <> '') and (aDrive.Drive[1] <> fCollectionList[i].Key[1]) then begin
        fCollectionList[i].fKey[1] := aDrive.Drive[1];
        somethingChanged := True;
      end;
    end;
  end;

  if somethingChanged then begin
    if fInsertMode = imDictionary then begin
      // refill the Dictionary, as the keys have changed
      fCollectionDict.Clear;
      for i := 0 to fCollectionList.Count - 1 do
        fCollectionDict.Add(fCollectionList[i].fKey, fCollectionList[i]);
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
  afc: TAudioFileCollection;
begin
  fLastSelectedCollectionData[fBrowseMode].Clear;

  afc := TAudioFileCollection(aCollection);
  fLastSelectedCollectionData[fBrowseMode].RootIndex := fCollections.IndexOf(afc.fRoot);
  fLastSelectedCollectionData[fBrowseMode].Expanded := afc.CollectionCount > 0;

  while assigned(afc.fParent) do begin
    fLastSelectedCollectionData[fBrowseMode].AddKey(afc.Key);
    afc := afc.fParent;
  end;
end;

function TLibraryFileCategory.FindLastCollectionAgain: TAudioCollection;
var
  subColl, resultColl: TAudioFileCollection;
  i: Integer;
begin
  result := Nil;
  if (fLastSelectedCollectionData[fBrowseMode].RootIndex > -1)
     and (fLastSelectedCollectionData[fBrowseMode].RootIndex < fCollections.Count)
  then begin
    // result: RootCollection
    resultColl := TAudioFileCollection(fCollections[fLastSelectedCollectionData[fBrowseMode].RootIndex]);

    for i := fLastSelectedCollectionData[fBrowseMode].KeyCount - 1 downto 0 do begin
      subColl := resultColl.GetCollectionByKey(fLastSelectedCollectionData[fBrowseMode].Keys[i]);
      if assigned(subColl) then
        resultColl := subColl
      else begin
        if resultColl.Content = ccTagCloud then begin
          // if i > 0 then
            resultColl.ExpandTagCloud(True);
          subColl := resultColl.GetCollectionByKey(fLastSelectedCollectionData[fBrowseMode].Keys[i]);
          if assigned(subColl) then
            resultColl := subColl
          else
            break;
        end else
          break;
      end;
    end;

    result := resultColl;
  end;
end;

function TLibraryFileCategory.FindLastCollectionAgainTagCloud(var LastKeyFound,
  ExpandLastKey: Boolean): TAudioCollection;
var
  subColl, resultColl: TAudioFileCollection;
  i: Integer;
begin
  result := Nil;
  LastKeyFound := True; // think positive here
  ExpandLastKey := fLastSelectedCollectionData[fBrowseMode].Expanded;
  if (fLastSelectedCollectionData[fBrowseMode].RootIndex > -1)
     and (fLastSelectedCollectionData[fBrowseMode].RootIndex < fCollections.Count)
  then begin
    resultColl := TAudioFileCollection(fCollections[fLastSelectedCollectionData[fBrowseMode].RootIndex]);
    // = one of the RootCollections

    // The keys are stored Bottom->Top in the CollectionData: Start with the last one
    for i := fLastSelectedCollectionData[fBrowseMode].KeyCount - 1 downto 0 do begin


      subColl := resultColl.GetCollectionByKey(fLastSelectedCollectionData[fBrowseMode].Keys[i]);
      if assigned(subColl) then
        resultColl := subColl
      else begin
        // A Collection with this Key doessn't exist (yet)
        // In TagClouds: Expand the Cloud by one Layer and search again for the Key
        if resultColl.Content = ccTagCloud then begin
          resultColl.ExpandTagCloud;
          subColl := resultColl.GetCollectionByKey(fLastSelectedCollectionData[fBrowseMode].Keys[i]);
          if assigned(subColl) then
            resultColl := subColl
          else begin
            LastKeyFound := False;
            ExpandLastKey := True;
            break;
          end;
        end else begin
          // Not in TagCloud-Mode
          LastKeyFound := False;
          break;
        end;
      end;
    end;

    result := resultColl;
  end;
end;


function TLibraryFileCategory.AddRootCollection(
  aRootConfig: TCollectionConfigList): TRootCollection;
var
  i: Integer;
begin
  result := TRootCollection.Create(self);
  for i := 0 to aRootConfig.Count - 1 do
    result.AddSubCollectionType(aRootConfig[i]);

  fCollections.Add(result);
end;

initialization

fLibraryFormatSettings := TFormatSettings.Create;

KeyCache.RawDirectory := '';
KeyCache.ProcessedDirectory := '';

end.
