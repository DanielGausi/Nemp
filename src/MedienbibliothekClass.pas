{

    Unit MedienbibliothekClass

    One of the Basic-Units - The Library

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

(*
Hinweise für eventuelle Erweiterungen:
--------------------------------------
- Die Threads werden mit der VCL per SendMessage synchronisiert.
  D.h.: Eine VCL-Aktion, die was länger dauert und deswegen Application.ProcessMessages
        verwendet, DARF NICHT gestartet werden, wenn der MedienBibStatus <> 0 ist!
        Denn das bedeutet, dass ein Update-Vorgang gestartet wurde, und evtl. bald eine
        Message kommt, die der VCL mitteilt, dass exklusiver Zugriff erforderlich ist.
        Zusätzlich muss eine solche VCL-Aktion den MedienBibStatus auf 3 setzen.

*)

unit MedienbibliothekClass;

interface

uses Windows, Contnrs, Sysutils,  Classes, Inifiles, RTLConsts,
     dialogs, Messages, JPEG, PNGImage, MD5, Graphics,  Lyrics,
     AudioFiles.Base, NempFileUtils,
     NempAudioFiles, AudioFileHelper, Nemp_ConstantsAndTypes, Hilfsfunktionen,
     HtmlHelper, ID3v2Tags, ID3v2Frames,
     U_CharCode, gnuGettext, oneInst, StrUtils,  CoverHelper, BibHelper, StringHelper,
     Nemp_RessourceStrings, DriveRepairTools, ShoutcastUtils, BibSearchClass,
     NempCoverFlowClass, TagClouds, ScrobblerUtils, CustomizedScrobbler,
     LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists, LibraryOrganizer.Webradio,
     PlaylistManagement,
     DeleteHelper, TagHelper, Generics.Collections, unFastFileStream, System.Types, System.UITypes,
     {Winapi.Wincodec, Winapi.ActiveX,} System.Generics.Defaults;

const
    BUFFER_SIZE = 10 * 1024;// * 1024;

    MP3DB_BLOCK_FILES = 1;
    MP3DB_BLOCK_DRIVES = 2;
    MP3DB_BLOCK_PLAYLISTS = 3;
    MP3DB_BLOCK_WEBSTREAMS = 4;
    MP3DB_BLOCK_CAT_FILES = 5;
    MP3DB_BLOCK_CAT_PLAYLISTS = 6;
    // MP3DB_BLOCK_CAT_WEBSTREAMS = 7; probably not

type

    TLibraryLyricsUsage = record
        TotalFiles: Integer;
        FilesWithLyrics: Integer;
        TotalLyricSize: Integer;
    end;

    TDisplayContent = (DISPLAY_None, DISPLAY_BrowseFiles, DISPLAY_BrowsePlaylist, DISPLAY_Search, DISPLAY_Quicksearch, DISPLAY_Favorites);

    PDeadFilesInfo = ^TDeadFilesInfo;
    TDeadFilesInfo = record
        MissingDrives: Integer;
        ExistingDrives: Integer;
        MissingFilesOnMissingDrives: Integer;
        MissingFilesOnExistingDrives: Integer;
        MissingPlaylistsOnMissingDrives: Integer;
        MissingPlaylistsOnExistingDrives: Integer;
    end;

    // types for the automatic stuff to do after create.
    // note: When adding Jobs, ALWAYS add also a JOB_Finish job to finalize the process
    TJobType = (JOB_LoadLibrary, JOB_AutoScanNewFiles, JOB_AutoScanMissingFiles, JOB_StartWebServer, JOB_Finish);
    TStartJob = class
        public
            Typ: TJobType;
            Param: String;
            constructor Create(atype: TJobType; aParam: String);
            procedure Assign(aJob: TStartjob);
    end;
    TJobList = class(TObjectList<TStartJob>);

    TMedienBibliothek = class
    private
        MainWindowHandle: DWord;  // Handle of Nemp Main Window, Destination for all the messages

        // Thread-Handles
        fHND_LoadThread: DWord;
        fHND_UpdateThread: DWord;
        fHND_ScanFilesAndUpdateThread: DWord;
        fHND_DeleteFilesThread: DWord;
        fHND_RefreshFilesThread: DWord;
        // fHND_GetLyricsThread: DWord;
        fHND_GetTagsThread: DWord;
        fHND_UpdateID3TagsThread: DWord;
        fHND_BugFixID3TagsThread: DWord;

        // filename for Thread-based loading
        fBibFilename: UnicodeString;

        Mp3ListePfadSort: TAudioFileList;           // List of all files in the library. Sorted by Path.
        AllPlaylistsPfadSort: TLibraryPlaylistList; // Lists for Playlists.
        FavoritePlaylists: TLibraryPlaylistList; // imported from the PlaylistManager

        DeadFiles: TAudioFileList;             // Two lists, that collect dead files
        DeadPlaylists: TLibraryPlaylistList;

        fDriveManager: TDriveManager; // managing the Drives used by the Library
        fPlaylistDriveManager: TDriveManager; // Another one for the Playlistfiles. Probably not needed in most cases

        fIgnoreListCopy: TStringList;
        fMergeListCopy: TObjectList;

        // Status of the Library
        // Note: This is a legacy from older versions, e.g.
        //       No-ID3-Editing on status 1 is due to GetLyrics, where Tags are also
        //       written. This should be more fine grained.
        // But: Changing this now will probably cause more problems then solving ;-)
        //      Maybe later....
        //    0  Ok, everything is allowed
        //    1  awaiting Update (e.g. search for new files is running)
        //       or: another Thread is running on the library, editing some files
        //           the current file is sent to the VCL, so VCL can edit all files
        //           except this very special one.
        //       Adding/removing of files from the library is not allowed
        //       (duration: some minutes, up to 1/2 hour or so.)
        //    2  Update in progress. Do not write on lists (e.g. sorting)
        //       (usually the library is for 1-5 seconds in this state)
        //    3  Update in critical part
        //       Block Readaccess to the library
        //       (usually only a few mili-seconds)
        // IMPORTANT NOTE:
        //    DO NOT set the status except in the VCL-MainThread
        //    Status MUST be set via SendMessage from thread
        //    Status MUST NOT be set to 0 (zero) until the thread has finished
        //    A Thread MUST NOT be started, if the status is <> 0
        fStatusBibUpdate: Integer;

        // Thread-safe variable. DO NOT access it directly, always use the property
        fUpdateFortsetzen: LongBool;
        // another one, for scanning hard disk for new files (new in version 4.12.)
        fFileSearchAborted: LongBool;

        fCurrentCategory: TLibraryCategory;

        fDefaultFileCategory: TLibraryFileCategory;
        fNewFilesCategory: TLibraryFileCategory;
        // fCollectionMetaInfo: TCollectionMetaInfo;
        fCurrentCategoryIdx: Integer;
        fNewCategoryMask: Cardinal;
        fChangeCategoryMask: Cardinal;
        fChangeCategory: TLibraryFileCategory;

        fChanged: LongBool;          // has bib changed? Is saving necessary?
        // Two helpers for Changed.
        // Loading a Library will execute the same code as adding new files.
        // On Startup a little different behaviour is wanted (e.g. the library is not changed)
        fChangeAfterUpdate: LongBool;
        // fInitializing: Integer; // not needed any more

        // After the user changes some information in an audiofile,
        // key1/2 and the matching "real information" are not identical.
        // As the "merge"-method is done by the real information, the old lists
        // must be resorted before merging.
        // fBrowseListsNeedUpdate: Boolean;

        // Pfad zum Speicherverzeichnis - wird z.B. fürs Kopieren der Cover benötigt.
        // Savepath:
        fSavePath: UnicodeString;        // ProgramDir or UserDir. used for Settings, Skins, ...
        // fCoverSavePath: UnicodeString;   // Path for Cover, := SavePath + 'Cover\'

        // The Flag for ignoring Lyrics in GetAudioData.
        // MUST be 0 (use Lyrics) or GAD_NOLYRICS (=8, ignore Lyrics)
        fIgnoreLyrics: Boolean;
        fIgnoreLyricsFlag: Integer;

        // used for faster cover-initialisation.
        // i.e. do not search coverfiles for every audiofile.
        // use the same cover again, if the next audiofile is in the same directory
        // fLastCoverName: UnicodeString;
        // fLastPath: UnicodeString;
        // fLastID: String;    CoverArtSearcher

        // Browsemode
        // 0: Classic
        // 1: Coverflow
        // 2: Tagcloud
        fBrowseMode: Integer;
        fCoverSortOrder: Integer;

        fSearchStringIsDirty: Boolean;
        fCollectionsAreDirty: Boolean;

        fAutoScanPlaylistFilesOnView: Boolean;

        fJobList: TJobList;

        function IsAutoSortWanted: Boolean;
        // Getter and Setter for some properties.
        // Most of them Thread-Safe
        function GetCount: Integer;
        procedure SetStatusBibUpdate(Value: Integer);
        function GetStatusBibUpdate   : Integer;
        procedure SetUpdateFortsetzen(Value: LongBool);
        function GetUpdateFortsetzen: LongBool;
        procedure SetFileSearchAborted(Value: LongBool);
        function GetFileSearchAborted: LongBool;
        function GetChangeAfterUpdate: LongBool;
        procedure SetChangeAfterUpdate(Value: LongBool);
        function GetChanged: LongBool;
        procedure SetChanged(Value: LongBool);
        function GetBrowseMode: Integer;
        procedure SetBrowseMode(Value: Integer);
        function GetCoverSortOrder: Integer;
        procedure SetCoverSortOrder(Value: Integer);
        procedure SetNewCategoryMask(Value: Cardinal);
        function GetNewCategoryMask: Cardinal;
        procedure SetChangeCategoryMask(Value: Cardinal);
        function GetChangeCategoryMask: Cardinal;

        procedure fSetIgnoreLyrics(aValue: Boolean);

        function GetCategoryIndexByCategory(aCat: TLibraryCategory): Integer;
        function GetCategoryByCategoryIndex(aIdx: Integer): TLibraryCategory;

        procedure SetCurrentCategory(Value: TLibraryCategory);
        procedure SetAutoScanPlaylistFilesOnView(Value: Boolean);

        // Update-Process for new files, which has been collected before.
        // Runs in seperate Thread, sends proper messages to mainform for sync
        // 1. Prepare Update.
        //    - Merge Updatelist with MainList into tmpMainList
        //    - Create other tmp-Lists and -stuff and sort them
        procedure PrepareNewFilesUpdate;
        procedure BuildSearchStrings;
        // 3. Clean tmp-lists, which are not needed after an update
        procedure CleanUpTmpLists;

        // Update-Process for Non-Existing Files.
        // Runs in seperate Thread, sends proper messages to mainform for sync
        // 1. Search Library for dead files
        Function fCollectDeadFiles: Boolean;
        // 1b. Let the user select files which should be deleted or not
//        procedure UserInputDeadFiles(DeleteDataList: TObjectList);
        // 2. Prepare Update
        //    - Fill tmplists with files, which are NOT dead

        procedure fPrepareDeleteFilesUpdate;
        // 3. Send Message and do
        //    CleanUpDeadFilesFromVCLLists
        //    in VCL-Thread
        // 4. Delete DeadFiles
        procedure fCleanUpDeadFiles;

        procedure fPrepareUserInputDeadFiles(DeleteDataList: TObjectList);
        procedure fReFillDeadFilesByDataList(DeleteDataList: TObjectList);
        procedure fGetDeadFilesSummary(DeleteDataList: TObjectList; var aSummary: TDeadFilesInfo);

        // Refreshing Library
        procedure fRefreshFiles(aRefreshList: TAudioFileList);      // 1a. Refresh files OR
        procedure fScanNewFiles;
        // procedure fGetLyrics;         // 1b. get Lyrics
        procedure fPrepareGetTags;    // 1c. get tags, but at first make a copy of the Ignore/rename-Rules in VCL-Thread
        procedure fGetTags;           //     get Tags (from LastFM)
        procedure fUpdateId3tags;     // 2.  Write Library-Data into the id3-Tags (used in CloudEditor)
        procedure fBugFixID3Tags;     // BugFix-Method

        function GetDefaultFileCategory: TLibraryFileCategory;
        procedure SetDefaultFileCategory(Value: TLibraryFileCategory);
        function GetNewFilesCategory: TLibraryFileCategory;
        procedure SetNewFilesCategory(Value: TLibraryFileCategory);

        function GetDefaultPlaylistCategory: TLibraryPlaylistCategory;
        function GetFavoritePlaylistCategory: TLibraryPlaylistCategory;

        // Helper for "FillRandomList"
        function CheckYearRange(Year: UnicodeString): Boolean;
        function CheckRating(aRating: Byte): Boolean;
        function CheckLength(aLength: Integer): Boolean;
        function CheckTags(aAudioFile: TAudioFile): Boolean;
        function CheckCategory(aAudioFile: TAudioFile): Boolean;

        // Synch a List of TDrives with the current situation on the PC
        // i.e. Search the Drive-IDs in the system and adjust the drive-letters
        // procedure SynchronizeDrives(Source: TObjectList);
        // Check whether drive has changed after a new device has been connected
        // function DrivesHaveChanged: Boolean;

        // Saving/loading the *.gmp-File
        function LoadDrivesFromStream_DEPRECATED(aStream: TStream): Boolean;
        function LoadDrivesFromStream(aStream: TStream): Boolean;
        procedure SaveDrivesToStream(aStream: TStream);

        function LoadAudioFilesFromStream_DEPRECATED(aStream: TStream; MaxSize: Integer): Boolean;
        function LoadAudioFilesFromStream(aStream: TStream): Boolean;
        procedure SaveAudioFilesToStream(aStream: TStream; StreamFilename: String);

        function LoadPlaylistsFromStream_DEPRECATED(aStream: TStream): Boolean;
        function LoadPlaylistsFromStream(aStream: TStream): Boolean;
        procedure SavePlaylistsToStream(aStream: TStream; StreamFilename: String);

        function LoadRadioStationsFromStream_DEPRECATED(aStream: TStream): Boolean;
        function LoadRadioStationsFromStream(aStream: TStream): Boolean;
        procedure SaveRadioStationsToStream(aStream: TStream);

        // Ensure that the Library does contain proper "Categories"
        procedure EnsureCategoriesExist;
        procedure InitFileCategories;
        procedure InitLastSelectedCollection;

        // Load/Save Categories
        function LoadFileCategoriesFromStream(aStream: TStream): Boolean;
        function LoadPlaylistCategoriesFromStream(aStream: TStream): Boolean;
        procedure SaveCategoriesToStream(aStream: TStream; aList: TLibraryCategoryList);
        procedure SaveFileCategoriesToStream(aStream: TStream);
        procedure SavePlaylistCategoriesToStream(aStream: TStream);

        procedure LoadFromFile4(aStream: TStream; SubVersion: Integer);
        // new format since Nemp 4.13 (end of 2019)
        procedure LoadFromFile5(aStream: TStream; SubVersion: Integer);
        procedure fLoadFromFile(aFilename: UnicodeString);

        procedure MergeFilesIntoPathList(aUpdateList: TAudioFileList);
        procedure DeleteFilesFromPathList(missingFiles: TAudioFileList);
        procedure DeleteFilesFromOtherLists(missingFiles: TAudioFileList);
        procedure DeletePlaylists(MissingPlaylists: TLibraryPlaylistList);


        procedure MergeFileIntoCategories(aFileList: TAudioFileList);
        procedure MergePlaylistsIntoCategories(aPlaylistList: TLibraryPlaylistList);
        procedure MergeWebradioIntoCategories(aStationList: TObjectList);
        procedure MergeNempDefaultPlaylists;

        procedure FinishCategories;

    public
        CloseAfterUpdate: Boolean; // flag used in OnCloseQuery
        // Some Beta-Options
        //BetaDontUseThreadedUpdate: Boolean;

        // Liste, die unten in der Liste angezeigt wird.
        // wird generiert über Onchange der Vorauswahl, oder aber von der Such-History
        // Achtung: Auf diese NUR IM VCL-HAUPTTHREAD zugreifen !!

        ///  *************************
        ///  Rework 2018:
        ///  - Three "Real" Lists, which actually stores AudioFileObjects
        ///    a. LastBrowseResult (for Browsing, Coverflow, TagCloud and "big" search)
        ///    b. LastQuickSearchResult (for Quicksearch)
        ///    c. LastMarkFilter (for switching between files with different marks)
        ///  - Two "Virtual" Lists, which are only links to one of the two above
        ///    * AnzeigeListe (pointer to a. or b. or c.), which is displayed in the VST
        ///    * BaseMarkerList (pointer to a. or b. or "all files" (user setting))
        ///
        ///  maybe later: replace "AnzeigeShowsPlaylistFiles" by another "PlaylistFilesList" ??
        ///  ************************
        LastBrowseResultList      : TAudioFileList;
        LastQuickSearchResultList : TAudioFileList;
        LastMarkFilterList        : TAudioFileList;
        // virtual Lists, do NOT create/free. These are just links to one of three above (or "allFiles")
        AnzeigeListe          : TAudioFileList;
        BaseMarkerList        : TAudioFileList;
        // AnzeigeListe2: TObjectList; // Speichert zusätzliche QuickSearch-Resultate.
        // Flag, was für Dateien in der Playlist sind
        // Muss bei jeder Änderung der AnzeigeListe gesetzt werden
        // Zusätzlich dürfen Dateien aus der AnzeigeListe ggf. nicht in andere Listen gehängt werden.
        // AnzeigeShowsPlaylistFiles: Boolean;  //Changed to a function...
        DisplayContent: TDisplayContent;

        // Liste für die Webradio-Stationen
        // Darauf greift auch die Stream-Verwaltung-Form zu
        // Objekte darin sind von Typ TStation
        RadioStationList: TObjectlist;

        // Liste, in die die neu einzupflegenden Dateien kommen
        // Auf diese Liste greift Searchtool zu, wenn die Platte durchsucht wird,
        // und auch die Laderoutine
        UpdateList: TAudioFileList;
        PlaylistUpdateList: TLibraryPlaylistList;
        CategoryChangeList: TAudioFileList;

        // Speichert die zu durchsuchenden Ordner für SearchTool
        ST_Ordnerlist: TStringList;

        PlaylistFillOptions: TPlaylistFillOptions;

        // Optionen, die aus der Ini kommen/gespeichert werden müssen
        IncludeAll: Boolean;
        IncludeFilter: String; // a string like "*.mp3;*.ogg;*.wma" - replaces the old Include*-Vars
        
        AutoLoadMediaList: Boolean;
        AutoSaveMediaList: Boolean;
        alwaysSortAnzeigeList: Boolean;
        limitMarkerToCurrentFiles: Boolean;
        SkipSortOnLargeLists: Boolean;
        AnzeigeListIsCurrentlySorted: Boolean;
        //AutoScanPlaylistFilesOnView: Boolean;
        ShowHintsInMedialist: Boolean;
        AutoScanDirs: Boolean;
        AutoScanDirList: TStringList;  // complete list of all Directories to scan
        AutoScanToDoList: TStringList; // the "working list"

        CurrentSearchDir: String;

        // for the scan process for new files: New method in 4.12
        UseNewFileScanMethod: Boolean;

        AutoDeleteFiles: Boolean;       
        AutoDeleteFilesShowInfo: Boolean;

        InitialDialogFolder: String;  // last used folder for "scan for audiofiles"

        // Bei neuen Ordnern (per Drag&Drop o.ä.) Dialog anzeigen, ob sie in die Auto-Liste eingefügt werden sollen
        AskForAutoAddNewDirs: Boolean;
        // Automatisch neue Ordner in die Scanlist einfügen
        AutoAddNewDirs: Boolean;

        AutoActivateWebServer: Boolean;

        CoverSearchLastFM: Boolean;
        // HideNACover: Boolean;
        MissingCoverMode: teMissingCoverPreSorting; //Integer;

        // Einstellungen für Standard-Cover
        // Eines für alle. Ist eins nicht da: Fallback auf Default
        //UseNempDefaultCover: Boolean;
        //PersonalizeMainCover: Boolean;

        // zur Laufzeit - weitere Sortiereigenschaften
        //Sortparam: Integer; // Eine der CON_ // CON_EX_- Konstanten
        //SortAscending: Boolean;

        SortParams: Array[0..SORT_MAX] of TCompareRecord;
          { TODO :
            SortParams im Create initialisieren
            SortParams in Ini Speichern/Laden }

        // this is used to synchronize access to single mediafiles
        // Some threads are running and modifying the files: GetLyrics and the Player.PostProcessor
        // This is fine, but the VCL MUST NOT try to write the same files.
        // So, the threads send a message to the vcl with the filename as (w/l)Param
        // and when the user wants to set the info manually the vcl must test this variable!
        // (this is necessary on status 1)
        CurrentThreadFilename: UnicodeString;

        BibSearcher: TBibSearcher;

        // The Currently selected File in the Treeview.
        // used for editing-stuff in the detail-panel besides the tree
        // Note: This File is not necessary in the library. It can be just in
        // the playlist! Or one entry in a Library-Playlist.
        CurrentAudioFile: TAudioFile;


        NewCoverFlow: TNempCoverFlow;

        TagPostProcessor: TTagPostProcessor;
        AskForAutoResolveInconsistencies: Boolean;
        ShowAutoResolveInconsistenciesHints: Boolean;
        AutoResolveInconsistencies: Boolean;

        AskForAutoResolveInconsistenciesRules: Boolean;
        AutoResolveInconsistenciesRules: Boolean;
        //ShowAutoResolveInconsistenciesHints: Boolean;

        // BibScrobbler: Link to Player.NempScrobbler
        BibScrobbler: TNempScrobbler;

        CoverArtSearcher: TCoverArtSearcher;

        {
          Categories for the Media Library
          - FileCategories are customizable by the user (up to 32)
          - PlaylistCategories are fixed
            - DefaultCategory: all "normal Playlists" found during scanning for music files
            - FavoriteCategory: Import of the QuickLoadPlaylists from the PlaylistManager
          - WebradioCategory: Fixed, only 1 Category
          - CoverSearchCategory: reduced to the QuickSearch-Results
        }
        FileCategories: TLibraryCategoryList;
        PlaylistCategories: TLibraryCategoryList;
        WebRadioCategory: TLibraryWebradioCategory;
        CoverSearchCategory: TLibraryFileCategory;

        property StatusBibUpdate   : Integer read GetStatusBibUpdate    write SetStatusBibUpdate;

        property Count: Integer read GetCount;
        // property CoverCount: Integer read GetCoverCount;

        property CurrentCategory: TLibraryCategory read fCurrentCategory write SetCurrentCategory;
        property CurrentCategoryIdx: Integer read fCurrentCategoryIdx write fCurrentCategoryIdx;

        property Changed: LongBool read GetChanged write SetChanged;
        property ChangeAfterUpdate: LongBool read GetChangeAfterUpdate write SetChangeAfterUpdate;
        property BrowseMode: Integer read GetBrowseMode write SetBrowseMode;
        property CoverSortOrder: Integer read GetCoverSortOrder write SetCoverSortOrder;

        property UpdateFortsetzen: LongBool read GetUpdateFortsetzen Write SetUpdateFortsetzen;
        property FileSearchAborted: LongBool read GetFileSearchAborted write SetFileSearchAborted;
        property NewCategoryMask: Cardinal read GetNewCategoryMask write SetNewCategoryMask;
        property ChangeCategoryMask: Cardinal read GetChangeCategoryMask write SetChangeCategoryMask;

        property SavePath: UnicodeString read fSavePath write fSavePath;

        property IgnoreLyrics     : Boolean read fIgnoreLyrics     write fSetIgnoreLyrics  ;
        property IgnoreLyricsFlag : Integer read fIgnoreLyricsFlag                         ;

        property PlaylistDriveManager: TDriveManager read fPlaylistDriveManager;

        property DefaultFileCategory: TLibraryFileCategory read GetDefaultFileCategory write SetDefaultFileCategory;
        property NewFilesCategory: TLibraryFileCategory read GetNewFilesCategory write SetNewFilesCategory;


        property DefaultPlaylistCategory: TLibraryPlaylistCategory read GetDefaultPlaylistCategory;
        property FavoritePlaylistCategory: TLibraryPlaylistCategory read GetFavoritePlaylistCategory;
        property AutoScanPlaylistFilesOnView: Boolean read fAutoScanPlaylistFilesOnView write SetAutoScanPlaylistFilesOnView;

        // Basic Operations. Create, Destroy, Clear, Copy
        constructor Create(aWnd: DWord; CFHandle: DWord);
        destructor Destroy; override;
        procedure Clear;
        procedure ClearFileCategories;
        // Copy The Files from the Library for use in WebServer
        // Note: WebServer will run multiple threads, but read-access only.
        //       Sync with main program will be complicated, so the webserver uses
        //       a copy of the list.
        procedure CopyLibrary(dest: TAudioFileList; var CurrentMaxID: Integer);
        // Load/Save options into IniFile
        procedure LoadSettings;
        procedure SaveSettings;

        procedure LoadLastSelectionData;

        // Managing the Library
        // - Merging new Files into the library (Param NewBib=True on loading a new library
        //                                       false otherwise)
        // - Delete not existing files
        // - Refresh AudioFile-Information
        // These methods will start a new thread and call several private methods
        procedure NewFilesUpdateBib(NewBib: Boolean = False);
        procedure DeleteFilesUpdateBib;
        procedure DeleteFilesUpdateBibAutomatic;

        // for Nemp 4.12: Scan Files in UpdateList for the first time and merge them into the MediaLibrary
        procedure ScanNewFilesAndUpdateBib;

        procedure CleanUpDeadFilesFromVCLLists;
        procedure RefreshFiles_All;
        procedure RefreshFiles_Selected;
        procedure GetLyrics;
        procedure GetTags;
        procedure UpdateId3tags;
        procedure BugFixID3Tags;


        // Additional managing. Run in VCL-Thread.
        procedure BuildTotalString;
        procedure BuildTotalLyricString;
        function DeleteAudioFile(aAudioFile: tAudioFile): Boolean;
        function DeletePlaylist(aPlaylist: TLibraryPlaylist): Boolean;
        function DeleteWebRadioStation(aStation: TStation): Boolean;

        procedure Abort;        // abort running update-threads
        function RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
        function CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean;

        // set fBrowseListsNeedUpdate to true
        procedure ChangeCoverID(oldID, newID: String);

        procedure ProcessLoadedFilenames;
        procedure ProcessLoadedPlaylists;

        // even more stuff for file managing: Additional Tags
        function AddNewTagConsistencyCheck(aAudioFile: TAudioFile; newTag: String): TTagConsistencyError;
        function AddNewTag(aAudioFile: TAudioFile; newTag: String; IgnoreWarnings: Boolean; Threaded: Boolean = False): TTagError;

        // Check, whether AudioFiles already exists in the library.
        function AudioFileExists(aFilename: UnicodeString): Boolean;
        function GetAudioFileWithFilename(aFilename: UnicodeString): TAudioFile;
        function PlaylistFileExists(aFilename: UnicodeString): Boolean;

        // 2018: new helper method to set the BaseMarkerList properly
        procedure SetBaseMarkerList(aList: TAudioFileList);

        // Methods for Browsing in the Library
        // 1. Generate BrowseLists
        //    see private methods, called during update-process
        // 2. Regenerate BrowseLists
        procedure CreateRootCollections;
        procedure ReBuildCategories;
        Procedure ReBuildBrowseLists;     // Complete Rebuild
        procedure ReFillFileCategories;
        procedure FillRootCollection(Dest: TRootCollection; SourceCategory: TLibraryCategory);

        // On DragOver: Get the proper Name for the target category for the DragOver-Hint.
        // Consider the case when lc is the "Default" ot "Recently Added"-Category
        function GetTargetFileCategoryName(lc: TLibraryCategory; out CatCount: Integer): String;
        // On Drop: Init the Target Category(Categories)
        // Consider Categories "Default" and "Recently Added"
        procedure InitTargetCategory(lc: TLibraryCategory);

        procedure ChangeCategory(Current, Target: TLibraryCategory; Files: TAudioFileList; Action: teCategoryAction);
        procedure RemoveFromCategory(Current: TLibraryCategory; Files: TAudioFileList);

        // AudioFileCategoryShouldChange: used while "adding" already existing files to the library
        // If files are added to a category they do not already belong to, this should be changed
        function AudioFileCategoryShouldChange(AudioFile: TAudioFile): Boolean;

        procedure GenerateCoverCategoryFromSearchresult(Source: TAudioFileList);

        procedure DeleteEmptyPlaylistCollections;
        procedure DeleteEmptyFileCollections;
        procedure DeleteEmptyWebRadioCollections;
        procedure RefreshCollections(FullRefill: Boolean = True);
        procedure RefreshWebRadioCategory;

        procedure ChangeFileCollectionSorting(RCIndex, Layer: Integer; newSorting: teCollectionSorting;
          newDirection: teSortDirection; OnlyDirection: Boolean);
        procedure ChangePlaylistCollectionSorting(newSorting: tePlaylistCollectionSorting; newDirection: teSortDirection);

        function SearchStringIsDirty(EditedColumn: Integer): Boolean;
        function CollectionsAreDirty(EditedColumn: Integer): Boolean; overload;
        function CollectionsAreDirty(EditedContent: teCollectionContent): Boolean; overload;

        function TabBtnBrowse_InconsistencyHint: String;
        procedure RepairSearchStrings;

        function AnzeigeShowsPlaylistFiles: Boolean;
        procedure GenerateAnzeigeListe(aCollection: TAudioCollection);
        procedure GenerateReverseAnzeigeListe(aCollection: TAudioCollection);
        procedure GenerateAlbumAnzeigeListe(aAudioFile: TAudioFile);
        procedure GetAlbumTitelListFromAudioFile(Target: TAudioFileList; aAudioFile: TAudioFile);

        procedure GetTitelListFromCoverIDUnsorted(Target: TAudioFileList; aCoverID: String);
        procedure GetTitelListFromDirectoryUnsorted(Target: TAudioFileList; aDirectory: String);
        function GetAudioFileWithCoverID(aCoverID: String): TAudioFile;

        procedure RestoreAnzeigeListeAfterQuicksearch;

        // Methods for searching
        // See BibSearcherClass for Details.
        ///Procedure ShowQuickSearchList;  // Displays the QuicksearchList
        ///procedure FillQuickSearchList;  // Set the currently displayed List as QuickSearchList
        // Searching for keywords
        // a. Quicksearch
        procedure GlobalQuickSearch(Keyword: UnicodeString; AllowErr: Boolean);
        procedure IPCSearch(Keyword: UnicodeString);
        // special case: Searching for a Tag
        procedure GlobalQuickTagSearch(KeyTag: UnicodeString);
        // search for '*' => show all files in the library
        procedure QuickSearchShowAllFiles;

        // b. detailed search
        procedure CompleteSearch(Keywords: TSearchKeyWords);
        procedure CompleteSearchNoSubStrings(Keywords: TSearchKeyWords);
        // c. get all files from the library in the same directory
        procedure GetFilesInDir(aDirectory: UnicodeString; ClearExistingView: Boolean);
        // d. Special case: Search for Empty Strings
        procedure EmptySearch(Mode: Integer);
        // list favorites
        procedure ShowMarker(aIndex: Byte);

        // Sorting the Lists
        procedure AddSorter(TreeHeaderColumnTag: Integer; FlipSame: Boolean = True);
        procedure ChangeSortDirection(NewDirection: teSortDirection);
        procedure SortAnzeigeListe;

        // Generating RandomList (Random Playlist)
        procedure FillRandomList(aList: TAudioFileList);

        // copy all files into another list (used for counting ratings)
        procedure FillListWithMedialibrary(aList: TAudioFileList);

        // Helper for AutoScan-Directories
        function ScanListContainsParentDir(NewDir: UnicodeString):UnicodeString;
        function ScanListContainsSubDirs(NewDir: UnicodeString):UnicodeString;
        Function JobListContainsNewDirs(aJobList: TStringList): Boolean;

        // Resync drives when connecting new devices to the computer
        // Return value: Something has changed (True) or no changes (False)
        function ReSynchronizeDrives: Boolean;
        // Change the paths of all AudioFiles according to the new situation
        procedure RepairDriveCharsAtAudioFiles;
        procedure RepairDriveCharsAtPlaylistFiles;

        // Managing webradio in the Library
        procedure ExportFavorites(aFilename: UnicodeString);
        procedure ImportFavorites(aFilename: UnicodeString);
        function AddRadioStation(aStation: TStation): Integer;

        procedure ImportFavoritePlaylists(Source: TPlaylistManager);

        // Saving/Loading
        // a. Export as CSV, to get the library to Excel or whatever.
        function SaveAsCSV(aFilename: UnicodeString): Boolean;
        // b. Loading/Saving the *.gmp-File
        // will call several private methods
        procedure SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
        procedure LoadFromFile(aFilename: UnicodeString; Threaded: Boolean = False);

        function CountInconsistentFiles: Integer;      // Count "ID3TagNeedsUpdate"-AudioFiles
        procedure PutInconsistentFilesToUpdateList;    // Put these files into the updatelist
        procedure PutAllFilesToUpdateList;    // Put these files into the updatelist
        function ChangeTags(oldTag, newTag: String): Integer;
        function CountFilesWithTag(aTag: String): Integer;

        // note: When adding Jobs, ALWAYS add also a JOB_Finish job to finalize the process
        procedure AddStartJob(aJobtype: TJobType; aJobParam: String);
        procedure ProcessNextStartJob;

        function GetLyricsUsage: TLibraryLyricsUsage;
        procedure RemoveAllLyrics;

  end;

  Procedure fLoadLibrary(MB: TMedienbibliothek);
  Procedure fNewFilesUpdate(MB: TMedienbibliothek);
  procedure fScanNewFilesAndUpdateBib(MB: TMedienbibliothek);

  Procedure fDeleteFilesUpdateContainer(MB: TMedienbibliothek; askUser: Boolean);
  Procedure fDeleteFilesUpdateUser(MB: TMedienbibliothek);
  Procedure fDeleteFilesUpdateAutomatic(MB: TMedienbibliothek);

  procedure fRefreshFilesThread_All(MB: TMedienbibliothek);
  procedure fRefreshFilesThread_Selected(MB: TMedienbibliothek);

  // procedure fGetLyricsThread(MB: TMedienBibliothek);
  procedure fGetTagsThread(MB: TMedienBibliothek);

  procedure fUpdateID3TagsThread(MB: TMedienBibliothek);
  procedure fBugFixID3TagsThread(MB: TMedienBibliothek);

  function GetProperMenuString(aIdx: Integer): UnicodeString;

  var //CSStatusChange: RTL_CRITICAL_SECTION;
      CSUpdate: RTL_CRITICAL_SECTION;
      CSAccessDriveList: RTL_CRITICAL_SECTION;
      CSAccessBackupCoverList: RTL_CRITICAL_SECTION;

implementation

uses System.Win.TaskbarCore, AudioDisplayUtils, Math;

function GetProperMenuString(aIdx: Integer): UnicodeString;
begin
    case aIdx of
        0: result := MainForm_MenuCaptionsEnqueueAllArtist   ;
        1: result := MainForm_MenuCaptionsEnqueueAllAlbum    ;
        2: result := MainForm_MenuCaptionsEnqueueAllDirectory;
        3: result := MainForm_MenuCaptionsEnqueueAllGenre    ;
        4: result := MainForm_MenuCaptionsEnqueueAllYear     ;
        5: result := MainForm_MenuCaptionsEnqueueAllDate     ;
        6: result := MainForm_MenuCaptionsEnqueueAllTag      ;
    else
        result := '(?)'
    end;
end;


constructor TStartJob.Create(atype: TJobType; aParam: String);
begin
    Typ := atype;
    Param := aParam;
end;

procedure TStartJob.Assign(aJob: TStartjob);
begin
    self.Typ := aJob.Typ;
    self.Param := aJob.Param;
end;

{
    --------------------------------------------------------
    Create, Destroy
    Create/Free all the lists
    --------------------------------------------------------
}
constructor TMedienBibliothek.Create(aWnd: DWord; CFHandle: DWord);
var i: Integer;
begin
  inherited create;
  CloseAfterUpdate := False;
  MainWindowHandle := aWnd;

  Mp3ListePfadSort   := TAudioFileList.Create(False);

  FileCategories := TLibraryCategoryList.Create(True);
  PlaylistCategories := TLibraryCategoryList.Create(True);
  CoverSearchCategory := TLibraryFileCategory.Create;
  WebRadioCategory := TLibraryWebradioCategory.Create;
  // fCollectionMetaInfo := TCollectionMetaInfo.Create;
  InitFileCategories;

  DeadFiles := TAudioFileList.create(False);
  DeadPlaylists := TLibraryPlaylistList.create(False);

  fIgnoreListCopy := TStringList.Create;
  fMergeListCopy := TObjectList.Create;

  LastBrowseResultList      := TAudioFileList.create(False);
  LastQuickSearchResultList := TAudioFileList.create(False);
  LastMarkFilterList        := TAudioFileList.create(False);
  // virtual Lists, do NOT create/free
  AnzeigeListe              := LastBrowseResultList;
  BaseMarkerList            := LastBrowseResultList;

  DisplayContent := DISPLAY_None;

  BibSearcher := TBibSearcher.Create(aWnd);
  BibSearcher.MainList := Mp3ListePfadSort;

  RadioStationList    := TObjectlist.Create;
  UpdateList   := TAudioFileList.create(False);
  CategoryChangeList := TAudioFileList.create(False);
  ST_Ordnerlist := TStringList.Create;
  AutoScanDirList := TStringList.Create;
  AutoScanDirList.Sorted := True;
  AutoScanToDoList := TStringList.Create;

  fDriveManager := TDriveManager.Create;
  fPlaylistDriveManager := TDriveManager.Create;

  AllPlaylistsPfadSort := TLibraryPlaylistList.Create(False);
  PlaylistUpdateList := TLibraryPlaylistList.Create(False);
  FavoritePlaylists := TLibraryPlaylistList.Create(True);

  //SortParam := CON_ARTIST;
  //SortAscending := True;
  Changed := False;
  //Initializing := init_nothing;

  fSearchStringIsDirty := False;
  fCollectionsAreDirty := False;

  for i := 0 to SORT_MAX  do
        begin
            SortParams[i].Comparefunction := AFComparePath;
            SortParams[i].Direction := sd_Ascending;
            SortParams[i].Tag := colIdx_Path;
        end;

  NewCoverFlow := TNempCoverFlow.Create;// (CFHandle, aWnd);

  CoverArtSearcher := TCoverArtSearcher.Create;

  TagPostProcessor := TTagPostProcessor.Create; // Data files are loaded automatically

  fJobList := TJobList.Create;
  fJobList.OwnsObjects := True;
  fChangeCategory := Nil;
end;

destructor TMedienBibliothek.Destroy;
var i: Integer;
begin

  fJobList.Free;
  NewCoverFlow.free;
  fIgnoreListCopy.Free;
  fMergeListCopy.Free;

  TagPostProcessor.Free;
  CoverArtSearcher.Free;

  for i := 0 to Mp3ListePfadSort.Count - 1 do
    Mp3ListePfadSort[i].Free;

  Mp3ListePfadSort.Free;

  DeadFiles.Free;
  DeadPlaylists.Free;

  FileCategories.Free;
  PlaylistCategories.Free;
  CoverSearchCategory.Free;
  WebRadioCategory.Free;

  for i := 0 to AllPlaylistsPfadSort.Count - 1 do
      AllPlaylistsPfadSort[i].Free;

  AutoScanDirList.Free;
  AutoScanToDoList.Free;
      EnterCriticalSection(CSAccessDriveList);
      fDriveManager.Free;
      fPlaylistDriveManager.Free;
      LeaveCriticalSection(CSAccessDriveList);
  AllPlaylistsPfadSort.Free;
  FavoritePlaylists.Free;

  RadioStationList.Free;

  LastBrowseResultList      .Free;
  LastQuickSearchResultList .Free;
  LastMarkFilterList        .Free;
  // virtual Lists, do NOT create/free
  AnzeigeListe          := Nil;
  BaseMarkerList        := Nil;

  UpdateList.Free;
  CategoryChangeList.Free;
  PlaylistUpdateList.Free;
  ST_Ordnerlist.Free;
  BibSearcher.Free;

  inherited Destroy;
end;


{
    --------------------------------------------------------
    Clear
    Clear the lists, free the AudioFiles
    --------------------------------------------------------
}
procedure TMedienBibliothek.Clear;
var i: Integer;
begin
  fJobList.Clear;
  for i := 0 to Mp3ListePfadSort.Count - 1 do
      Mp3ListePfadSort[i].Free;

  Mp3ListePfadSort.Clear;
  DeadFiles.Clear;
  DeadPlaylists.Clear;

  FileCategories.Clear;
  PlaylistCategories.Clear;
  CoverSearchCategory.Clear;
  WebRadioCategory.Clear;
  InitFileCategories; // create Default-Lists

  UpdateList.Clear;
  CategoryChangeList.Clear;
  PlaylistUpdateList.Clear;
  ST_Ordnerlist.Clear;

  EnterCriticalSection(CSAccessDriveList);
  fDriveManager.Clear;
  fPlaylistDriveManager.Clear;
  LeaveCriticalSection(CSAccessDriveList);

  for i := 0 to AllPlaylistsPfadSort.Count - 1 do
      AllPlaylistsPfadSort[i].Free;

  AllPlaylistsPfadSort.Clear;
  FavoritePlaylists.Clear;

  LastBrowseResultList      .Clear;
  LastQuickSearchResultList .Clear;
  LastMarkFilterList        .Clear;

  DisplayContent := DISPLAY_None;

  BibSearcher.Clear;
  NewCoverFlow.clear;

  CoverArtSearcher.Clear;
  RadioStationList.Clear;
  AnzeigeListIsCurrentlySorted := False;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
end;

procedure TMedienBibliothek.ClearFileCategories;
begin
  FileCategories.Clear;
  CurrentCategory := Nil;
  fNewFilesCategory := Nil;
  fDefaultFileCategory := Nil;
  fChangeCategory := Nil;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, 0);
end;
{
    --------------------------------------------------------
    CopyLibrary
    - Copy the list for use in Webserver
    --------------------------------------------------------
}
procedure TMedienBibliothek.CopyLibrary(dest: TAudioFileList; var CurrentMaxID: Integer);
var i: Integer;
    newAF, AF: TAudioFile;
begin
  if StatusBibUpdate <> BIB_Status_ReadAccessBlocked then
  begin
      dest.Clear;
      dest.Capacity := Mp3ListePfadSort.Count;
      for i := 0 to Mp3ListePfadSort.Count - 1 do
      begin
          AF := Mp3ListePfadSort[i];
          newAF := TAudioFile.Create;
          newAF.AssignLight(AF); // d.h. ohne Lyrics!
          if AF.WebServerID = 0 then
          begin
              AF.WebServerID := CurrentMaxID;
              newAF.WebServerID := CurrentMaxID;
              inc(CurrentMaxID);
          end else
              newAF.WebServerID := AF.WebServerID;
          dest.Add(newAF);
      end;
  end;
end;

{
    --------------------------------------------------------
    CountInconsistentFiles
    - Count "ID3TagNeedsUpdate"-AudioFiles
      VCL-Thread only!
    --------------------------------------------------------
}
function TMedienBibliothek.CountInconsistentFiles: Integer;
var i, c: Integer;
begin
    c := 0;
    for i := 0 to Mp3ListePfadSort.Count - 1 do
        if Mp3ListePfadSort[i].ID3TagNeedsUpdate then
            inc(c);
    result := c;
end;
{
    --------------------------------------------------------
    PutInconsistentFilesToUpdateList
    - Put these Files into the Update-List
      Runs in VCL-MainThread!
    --------------------------------------------------------
}
procedure TMedienBibliothek.PutInconsistentFilesToUpdateList;
var i: integer;
begin
    UpdateList.Clear;
    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        if MP3ListePfadSort[i].ID3TagNeedsUpdate then
            UpdateList.Add(MP3ListePfadSort[i]);
    end;
end;
{
    --------------------------------------------------------
    PutAllFilesToUpdateList
    - Put all Files into the Update-List
      Used for ID3Bugfix
    --------------------------------------------------------
}
procedure TMedienBibliothek.PutAllFilesToUpdateList;
var i: integer;
begin
    UpdateList.Clear;
    for i := 0 to Mp3ListePfadSort.Count - 1 do
        UpdateList.Add(MP3ListePfadSort[i]);
end;


function TMedienBibliothek.ChangeTags(oldTag, newTag: String): Integer;
var i, c, iCat: Integer;

begin
    result := 0;
    if StatusBibUpdate >= 2 then exit;
    c := 0;
    for i := 0 to Mp3ListePfadSort.Count - 1 do
        if Mp3ListePfadSort[i].ChangeTag(oldTag, newTag) then begin
          inc(c);
          for iCat := 0 to self.FileCategories.Count - 1 do
            TLibraryFileCategory(FileCategories[iCat]).RelocateAudioFile(Mp3ListePfadSort[i]);
        end;
    result := c;
end;

function TMedienBibliothek.CountFilesWithTag(aTag: String): Integer;
var i, c: Integer;
begin
    result := 0;
    if StatusBibUpdate >= 2 then exit;
    c := 0;
    for i := 0 to Mp3ListePfadSort.Count - 1 do
        if Mp3ListePfadSort[i].ContainsTag(aTag) then
            inc(c);
    result := c;
end;

{
    --------------------------------------------------------
    Setter/Getter for some properties.
    Most of them Threadsafe, as they are needed in VCL and secondary thread
    --------------------------------------------------------
}
function TMedienBibliothek.GetCount: Integer;
begin
  result := Mp3ListePfadSort.Count;
end;
procedure TMedienBibliothek.SetStatusBibUpdate(Value: Integer);
begin
  InterLockedExchange(fStatusBibUpdate, Value);
end;
function TMedienBibliothek.GetStatusBibUpdate   : Integer;
begin
  InterLockedExchange(Result, fStatusBibUpdate);
end;
function TMedienBibliothek.GetChangeAfterUpdate: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fChangeAfterUpdate));
end;
procedure TMedienBibliothek.SetChangeAfterUpdate(Value: LongBool);
begin
  InterLockedExchange(Integer(fChangeAfterUpdate), Integer(Value));
end;
function TMedienBibliothek.GetChanged: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fChanged));
end;
procedure TMedienBibliothek.SetChanged(Value: LongBool);
begin
  InterLockedExchange(Integer(fChanged), Integer(Value));
end;
function TMedienBibliothek.GetBrowseMode: Integer;
begin
  InterLockedExchange(Result, fBrowseMode);
end;
procedure TMedienBibliothek.SetBrowseMode(Value: Integer);
begin
  InterLockedExchange(fBrowseMode, Value);
end;
function TMedienBibliothek.GetCoverSortOrder: Integer;
begin
  InterLockedExchange(Result, fCoverSortOrder);
end;
procedure TMedienBibliothek.SetCoverSortOrder(Value: Integer);
begin
  InterLockedExchange(fCoverSortOrder, Value);
end;
procedure TMedienBibliothek.SetUpdateFortsetzen(Value: LongBool);
begin
  InterLockedExchange(Integer(fUpdateFortsetzen), Integer(Value));
end;
function TMedienBibliothek.GetUpdateFortsetzen: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fUpdateFortsetzen));
end;
procedure TMedienBibliothek.SetFileSearchAborted(Value: LongBool);
begin
    InterLockedExchange(Integer(fFileSearchAborted), Integer(Value));
end;

procedure TMedienBibliothek.SetNewCategoryMask(Value: Cardinal);
begin
  InterlockedExchange(Integer(fNewCategoryMask), Integer(Value));
end;

function TMedienBibliothek.GetNewCategoryMask: Cardinal;
begin
  InterLockedExchange(Integer(Result), Integer(fNewCategoryMask));
end;

procedure TMedienBibliothek.SetChangeCategoryMask(Value: Cardinal);
begin
  InterlockedExchange(Integer(fChangeCategoryMask), Integer(Value));
end;

function TMedienBibliothek.GetChangeCategoryMask: Cardinal;
begin
  InterLockedExchange(Integer(Result), Integer(fChangeCategoryMask));
end;

function TMedienBibliothek.GetFileSearchAborted: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fFileSearchAborted));
end;

procedure TMedienBibliothek.fSetIgnoreLyrics(aValue: Boolean);
begin
    fIgnoreLyrics := aValue;
    if aValue then
        fIgnoreLyricsFlag := GAD_NOLYRICS
    else
        fIgnoreLyricsFlag := 0;
end;

{
    --------------------------------------------------------
    LoadFromIni
    SaveToIni
    Load/Save the settings into the IniFile
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadSettings;
var tmpcharcode, dircount, i: integer;
    tmp: UnicodeString;
    so, sd: Integer;
begin
        //BetaDontUseThreadedUpdate := Ini.ReadBool('Beta', 'DontUseThreadedUpdate', False);

        // temporary, maybe add an option later (or remove it completely, so use it always)
        UseNewFileScanMethod := NempSettingsManager.ReadBool('MedienBib', 'UseNewFileScanMethod', True);

        AlwaysSortAnzeigeList := NempSettingsManager.ReadBool('MedienBib', 'AlwaysSortAnzeigeList', False);
        limitMarkerToCurrentFiles := NempSettingsManager.ReadBool('MedienBib', 'limitMarkerToCurrentFiles', True);
        SkipSortOnLargeLists  := NempSettingsManager.ReadBool('MedienBib', 'SkipSortOnLargeLists', True);
        AutoScanPlaylistFilesOnView := NempSettingsManager.ReadBool('MedienBib', 'AutoScanPlaylistFilesOnView', True);
        ShowHintsInMedialist := NempSettingsManager.ReadBool('Medienbib', 'ShowHintsInMedialist', True);

        for i := SORT_MAX downto 0 do
        begin
            so := NempSettingsManager.ReadInteger('MedienBib', 'Sortorder' + IntToStr(i), colIdx_Path);
            self.AddSorter(so, False);
            sd := NempSettingsManager.ReadInteger('MedienBib', 'SortMode' + IntToStr(i), Integer(sd_Ascending));
            if sd = Integer(sd_Ascending) then
                SortParams[i].Direction := sd_Ascending
            else
                SortParams[i].Direction := sd_Descending;
        end;

        TCoverArtSearcher.UseDir         := NempSettingsManager.ReadBool('MedienBib','CoverSearchInDir', True);
        TCoverArtSearcher.UseParentDir   := NempSettingsManager.ReadBool('MedienBib','CoverSearchInParentDir', True);
        TCoverArtSearcher.UseSubDir      := NempSettingsManager.ReadBool('MedienBib','CoverSearchInSubDir', True);
        TCoverArtSearcher.UseSisterDir   := NempSettingsManager.ReadBool('MedienBib', 'CoverSearchInSisterDir', True);
        TCoverArtSearcher.SubDirName     := NempSettingsManager.ReadString('MedienBib', 'CoverSearchSubDirName', 'cover');
        TCoverArtSearcher.SisterDirName  := NempSettingsManager.ReadString('MedienBib', 'CoverSearchSisterDirName', 'cover');
        TCoverArtSearcher.CoverSizeIndex := NempSettingsManager.ReadInteger('MedienBib', 'CoverSize', 1);
        TCoverArtSearcher.InitCoverArtCache(Savepath, TCoverArtSearcher.CoverSizeIndex);

        CoverSearchLastFM        := NempSettingsManager.ReadBool('MedienBib', 'CoverSearchLastFM', False);
        MissingCoverMode := teMissingCoverPreSorting(NempSettingsManager.ReadInteger('MedienBib', 'MissingCoverMode', 1));

        IgnoreLyrics := NempSettingsManager.ReadBool('MedienBib', 'IgnoreLyrics', False);

        BrowseMode     := NempSettingsManager.ReadInteger('MedienBib', 'BrowseMode', 1);
        if (BrowseMode < 0) OR (BrowseMode > 2) then
          BrowseMode := 1;
        CoverSortOrder := NempSettingsManager.ReadInteger('MedienBib', 'CoverSortOrder', 8);
        if (CoverSortOrder < 1) OR (CoverSortOrder > 9) then
          CoverSortorder := 1;

        IncludeAll := NempSettingsManager.ReadBool('MedienBib', 'other', True);
        IncludeFilter := NempSettingsManager.ReadString('MedienBib', 'includefilter', '*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.wma;*.ape;*.flac');
        AutoLoadMediaList := NempSettingsManager.ReadBool('MedienBib', 'autoload', True);
        AutoSaveMediaList := NempSettingsManager.ReadBool('MedienBib', 'autosave', AutoLoadMediaList);

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetGreek', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 1) then tmpcharcode := 0;
        NempCharCodeOptions.Greek := GreekEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetCyrillic', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Cyrillic := CyrillicEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetHebrew', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Hebrew := HebrewEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetArabic', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Arabic := ArabicEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetThai', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Thai := ThaiEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetKorean', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Korean := KoreanEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetChinese', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 1) then tmpcharcode := 0;
        NempCharCodeOptions.Chinese := ChineseEncodings[tmpcharcode];

        tmpcharcode := NempSettingsManager.ReadInteger('MedienBib', 'CharSetJapanese', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Japanese := JapaneseEncodings[tmpcharcode];

        NempCharCodeOptions.AutoDetectCodePage := NempSettingsManager.ReadBool('MedienBib', 'AutoDetectCharCode', True);

        InitialDialogFolder := NempSettingsManager.ReadString('MedienBib', 'InitialDialogFolder', '');

        AutoScanDirs := NempSettingsManager.ReadBool('MedienBib', 'AutoScanDirs', True);
        AskForAutoAddNewDirs  := NempSettingsManager.ReadBool('MedienBib', 'AskForAutoAddNewDirs', True);
        AutoAddNewDirs        := NempSettingsManager.ReadBool('MedienBib', 'AutoAddNewDirs', True);
        AutoDeleteFiles         := NempSettingsManager.ReadBool('MedienBib', 'AutoDeleteFiles', False);
        AutoDeleteFilesShowInfo := NempSettingsManager.ReadBool('MedienBib', 'AutoDeleteFilesShowInfo', False);

        AutoResolveInconsistencies          := NempSettingsManager.ReadBool('MedienBib', 'AutoResolveInconsistencies'      , True);
        AskForAutoResolveInconsistencies    := NempSettingsManager.ReadBool('MedienBib', 'AskForAutoResolveInconsistencies', True);
        ShowAutoResolveInconsistenciesHints := NempSettingsManager.ReadBool('MedienBib', 'ShowAutoResolveInconsistenciesHints', True);

        AskForAutoResolveInconsistenciesRules := NempSettingsManager.ReadBool('MedienBib', 'AskForAutoResolveInconsistenciesRules', True);
        AutoResolveInconsistenciesRules       := NempSettingsManager.ReadBool('MedienBib', 'AutoResolveInconsistenciesRules'      , True);

        dircount := NempSettingsManager.ReadInteger('MedienBib', 'dircount', 0);
        for i := 1 to dircount do
        begin
            tmp := NempSettingsManager.ReadString('MedienBib', 'ScanDir' + IntToStr(i), '');
            if trim(tmp) <> '' then
            begin
                AutoScanDirList.Add(IncludeTrailingPathDelimiter(tmp));
                AutoScanToDoList.Add(IncludeTrailingPathDelimiter(tmp));
            end;
        end;

        AutoActivateWebServer := NempSettingsManager.ReadBool('MedienBib', 'AutoActivateWebServer', False);

        NewCoverFlow.LoadSettings;
        BibSearcher.LoadFromIni(NempSettingsManager);
        fCurrentCategoryIdx := NempSettingsManager.ReadInteger('LibraryOrganizerSelection', 'CollectionIndex', 0);
        NempOrganizerSettings.LoadSettings;
end;

procedure TMedienBibliothek.SaveSettings;
var i, catIdx: Integer;
begin
        NempSettingsManager.WriteBool('MedienBib', 'AlwaysSortAnzeigeList', AlwaysSortAnzeigeList);
        NempSettingsManager.WriteBool('MedienBib', 'limitMarkerToCurrentFiles', limitMarkerToCurrentFiles);

        NempSettingsManager.WriteBool('MedienBib', 'SkipSortOnLargeLists', SkipSortOnLargeLists);

        NempSettingsManager.WriteBool('MedienBib', 'AutoScanPlaylistFilesOnView', AutoScanPlaylistFilesOnView);
        NempSettingsManager.WriteBool('Medienbib', 'ShowHintsInMedialist', ShowHintsInMedialist);

        for i := SORT_MAX downto 0 do
        begin
            NempSettingsManager.WriteInteger('MedienBib', 'Sortorder' + IntToStr(i), SortParams[i].Tag);
            NempSettingsManager.WriteInteger('MedienBib', 'SortMode' + IntToStr(i), Integer(SortParams[i].Direction));
        end;

        NempSettingsManager.Writebool('MedienBib','CoverSearchInDir', TCoverArtSearcher.UseDir);
        NempSettingsManager.Writebool('MedienBib','CoverSearchInParentDir', TCoverArtSearcher.UseParentDir);
        NempSettingsManager.Writebool('MedienBib','CoverSearchInSubDir', TCoverArtSearcher.UseSubDir);
        NempSettingsManager.Writebool('MedienBib', 'CoverSearchInSisterDir', TCoverArtSearcher.UseSisterDir);
        NempSettingsManager.WriteString('MedienBib', 'CoverSearchSubDirName', TCoverArtSearcher.SubDirName);
        NempSettingsManager.WriteString('MedienBib', 'CoverSearchSisterDirName', TCoverArtSearcher.SisterDirName);
        NempSettingsManager.WriteInteger('MedienBib', 'CoverSize', TCoverArtSearcher.CoverSizeIndex);

        NempSettingsManager.WriteBool('MedienBib', 'CoverSearchLastFM', CoverSearchLastFM);
        NempSettingsManager.WriteInteger('MedienBib', 'MissingCoverMode', Integer(MissingCoverMode));
        NempSettingsManager.WriteBool('MedienBib', 'IgnoreLyrics', IgnoreLyrics);

        NempSettingsManager.WriteBool('MedienBib', 'other', IncludeAll);
        NempSettingsManager.WriteString('MedienBib', 'includefilter', IncludeFilter);
        NempSettingsManager.WriteBool('MedienBib', 'autoload', AutoLoadMediaList);
        NempSettingsManager.WriteBool('MedienBib', 'autosave', AutoSaveMediaList);

        NempSettingsManager.WriteInteger('MedienBib', 'CharSetGreek', NempCharCodeOptions.Greek.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetCyrillic', NempCharCodeOptions.Cyrillic.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetHebrew', NempCharCodeOptions.Hebrew.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetArabic', NempCharCodeOptions.Arabic.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetThai', NempCharCodeOptions.Thai.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetKorean', NempCharCodeOptions.Korean.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetChinese', NempCharCodeOptions.Chinese.Index);
        NempSettingsManager.WriteInteger('MedienBib', 'CharSetJapanese', NempCharCodeOptions.Japanese.Index);
        NempSettingsManager.WriteBool('MedienBib', 'AutoDetectCharCode', NempCharCodeOptions.AutoDetectCodePage);

        NempSettingsManager.WriteString('MedienBib', 'InitialDialogFolder', InitialDialogFolder);
        NempSettingsManager.WriteBool('MedienBib', 'AutoScanDirs', AutoScanDirs);
        NempSettingsManager.WriteBool('MedienBib', 'AutoDeleteFiles', AutoDeleteFiles);
        NempSettingsManager.WriteBool('MedienBib', 'AutoDeleteFilesShowInfo', AutoDeleteFilesShowInfo);
        NempSettingsManager.WriteInteger('MedienBib', 'dircount', AutoScanDirList.Count);
        NempSettingsManager.WriteBool('MedienBib', 'AskForAutoAddNewDirs', AskForAutoAddNewDirs);
        NempSettingsManager.WriteBool('MedienBib', 'AutoAddNewDirs', AutoAddNewDirs);
        NempSettingsManager.WriteBool('MedienBib', 'AutoActivateWebServer', AutoActivateWebServer);

        NempSettingsManager.WriteBool('MedienBib', 'ShowAutoResolveInconsistenciesHints', ShowAutoResolveInconsistenciesHints);
        NempSettingsManager.WriteBool('MedienBib', 'AskForAutoResolveInconsistencies', AskForAutoResolveInconsistencies);
        NempSettingsManager.WriteBool('MedienBib', 'AutoResolveInconsistencies'      , AutoResolveInconsistencies);
        NempSettingsManager.WriteBool('MedienBib', 'AskForAutoResolveInconsistenciesRules' , AskForAutoResolveInconsistenciesRules);
        NempSettingsManager.WriteBool('MedienBib', 'AutoResolveInconsistenciesRules'       , AutoResolveInconsistenciesRules);

        NempSettingsManager.WriteInteger('MedienBib', 'BrowseMode', fBrowseMode);
        NempSettingsManager.WriteInteger('MedienBib', 'CoverSortOrder', fCoverSortOrder);

        for i := 0 to AutoScanDirList.Count -1  do
            NempSettingsManager.WriteString('MedienBib', 'ScanDir' + IntToStr(i+1), AutoScanDirList[i]);

        NempSettingsManager.WriteInteger('MedienBib', 'CoverFlowMode', Integer(NewCoverFlow.Mode));
        BibSearcher.SaveToIni(NempSettingsManager);

        // Write Info "current selection"
        NempSettingsManager.EraseSection('LibraryOrganizerSelection');
        NempSettingsManager.WriteInteger('LibraryOrganizerSelection', 'CollectionIndex', GetCategoryIndexByCategory(CurrentCategory));
        for i := 0 to 2 do begin
          NempSettingsManager.EraseSection ('LibraryOrganizerSelection' + OrganizerSelectionSuffix[i]);
          for catIdx := 0 to FileCategories.Count - 1 do
            FileCategories[catIdx].LastSelectedCollectionData[i].SaveSettings(i, catIdx);
        end;

        NempSettingsManager.WriteBool('MedienBib', 'UseNewFileScanMethod', UseNewFileScanMethod);

        NewCoverFlow.SaveSettings;
        NempOrganizerSettings.SaveSettings;
end;


procedure TMedienBibliothek.ScanNewFilesAndUpdateBib;
var Dummy: Cardinal;
    i: Integer;
begin
    if Not FileSearchAborted then
    begin
        StatusBibUpdate := 1;
        // actually start scanning the files and merge them into the library afterwards
        fHND_ScanFilesAndUpdateThread  := BeginThread(Nil, 0, @fScanNewFilesAndUpdateBib, Self, 0, Dummy);
    end else
    begin
        // the search for new files has been cancelled by the user.
        // Discard files in the UpdateList and cleanUP Progress-GUI
        for i := 0 to UpdateList.Count - 1 do
            UpdateList[i].Free;
        UpdateList.Clear;
        CategoryChangeList.Clear;
         
        // we are in the main VCL Thread here.
        // however, use the same methods to finish the jobs as in the threaded methods
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                              Integer(PChar(_(  MediaLibrary_SearchingNewFiles_Aborted  )) ));
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);

        // current //job// is done, set status to 0
        SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
        // check for the next job
        SendMessage(MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);       
    end;
end;

procedure fScanNewFilesAndUpdateBib(MB: TMedienbibliothek);
begin
    if (MB.UpdateList.Count > 0) or (MB.PlaylistUpdateList.Count > 0) or (MB.CategoryChangeList.Count > 0) then
    begin
        // new part here: Scan the files first
        MB.UpdateFortsetzen := True;
        MB.fScanNewFiles;
        // Merge Files into the Library
        // Status is set properly in PrepareNewFilesUpdate
        MB.PrepareNewFilesUpdate;
        MB.BuildSearchStrings;
        MB.CleanUpTmpLists;

        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                            Integer(PChar(_(MediaLibrary_SearchingNewFilesComplete ) )));
        //if MB.ChangeAfterUpdate then
        MB.Changed := True;
    end else
    begin
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                          Integer(PChar(_(MediaLibrary_SearchingNewFiles_NothingFound )) ));
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    end;

    // current //job// is done, set status to 0
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    // check for the next job
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);
    try
        CloseHandle(MB.fHND_ScanFilesAndUpdateThread);
    except
    end;
end;

procedure TMedienBibliothek.fScanNewFiles;
var i, freq, ges: Integer;
    AudioFile: TAudioFile;
    ct, nt: Cardinal;
    ScanList: TAudioFileList;
begin

  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockUpdateStart, 0); // Or better MB_BlockWriteAccess? - No, it should be ok so.
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));

  SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_ScanNewFiles));

  // release the Factory (but this should not happen here, as the Factory should have been NILed by the previous thread)
  if WICImagingFactory_ScanThread <> Nil then
  begin
      if WICImagingFactory_ScanThread._Release = 0 then
          Pointer(WICImagingFactory_ScanThread) := Nil;
  end;

  ges := UpdateList.Count;
  freq := Round(UpdateList.Count / 100) + 1;
  ct := GetTickCount;

  ScanList := TAudioFileList.Create(False);
  try
      // Transfer the items from the UpdateList into a temporary new List
      ScanList.Capacity := UpdateList.Count;
      for i := 0 to UpdateList.Count - 1 do
          ScanList.Add(UpdateList[i]);
      // Clear the original UpdateList
      UpdateList.Clear;

      ChangeAfterUpdate := True;
      for i := 0 to ScanList.Count - 1 do
      begin
          if Not UpdateFortsetzen then
          begin
              // Free the remaining AudioFiles in the ScanList, and
              // don't add them to the UpdateList, which is processed after this method
              ScanList[i].Free;
          end else
          begin
              AudioFile := ScanList[i];
              if FileExists(AudioFile.Pfad) then
              begin
                  AudioFile.FileIsPresent:=True;
                  AudioFile.GetAudioData(AudioFile.Pfad, GAD_Rating or IgnoreLyricsFlag);
                  AudioFile.Category := NewCategoryMask;
                  CoverArtSearcher.InitCover(AudioFile, tm_Thread, INIT_COVER_DEFAULT);
              end
              else
              begin
                  // should npt happen here ...
                  AudioFile.FileIsPresent:=False;
              end;
              // Add the File to the UpdateList, which is merged into the MediaLibrary later.
              UpdateList.Add(AudioFile);

              nt := GetTickCount;
              if (i mod freq = 0) or (nt > ct + 500) or (nt < ct) then
              begin
                  ct := nt;

                  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressCurrentFileOrDirUpdate,
                                  Integer(PWideChar(Format(_(MediaLibrary_ScanningFilesInDir),
                                                        [ AudioFile.Ordner ]))));

                  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressScanningNewFiles,
                                  Integer(PWideChar(Format(_(MediaLibrary_ScanningFilesCount),
                                                        [ i, ges ]))));

                  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/ges * 100));
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, i+1);
                  // No counting of non-existing files here
                  // SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, DeadFiles.Count);
              end;
          end;
      end;

      // release the Factory now, scanning is complete and the the thread will terminate soon
      if WICImagingFactory_ScanThread <> Nil then
      begin
          if WICImagingFactory_ScanThread._Release = 0 then
              Pointer(WICImagingFactory_ScanThread) := Nil;
      end;

      // progress complete
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);

  finally
      ScanList.Free;
  end;
end;

{
    --------------------------------------------------------
    NewFilesUpdateBib
    - Public method for merging new files into the library
      The new files are stored in UpdateList and came from
       - a *.gmp-File (happens when starting Nemp)
       - a search for mp3-Files done with SearchUtils

    Note: This Method is called after loading a Library-File,
          and after a FileSearch
          It should NOT check for status = 0, but it MUST set it
          to 2 immediatly
          Check =/<> 0 MUST be done outside!
    --------------------------------------------------------
}
procedure TMedienBibliothek.NewFilesUpdateBib(NewBib: Boolean = False);
var Dummy: Cardinal;
begin
  ChangeAfterUpdate := Not NewBib;
  if NewBib then Changed := False;
  // Some people reported strange errors on startup, which possibly
  // be caused by this thread. So in this case call the thread method
  // directly.
  StatusBibUpdate := 2;
  //if BetaDontUseThreadedUpdate then
  //begin
  //    fNewFilesUpdate(self);
  //    fHND_UpdateThread := 0;
  //end
  //else
      fHND_UpdateThread := (BeginThread(Nil, 0, @fNewFilesUpdate, Self, 0, Dummy));
end;
{
    --------------------------------------------------------
    fNewFilesUpdate
    - runs in secondary thread and calls the private Library-Methods
      Note: These methods will send several Messages to Mainform to
      block Read/Write-Access to the library when its needed.
    --------------------------------------------------------
}
procedure fNewFilesUpdate(MB: TMedienbibliothek);
begin
  if (MB.UpdateList.Count > 0) or (MB.PlaylistUpdateList.Count > 0) or (MB.CategoryChangeList.Count > 0) then
  begin                        // status: Temporary comments, as I found a concept-bug here ;-)
    MB.PrepareNewFilesUpdate;  // status: ok (no StatusChange needed)
    MB.BuildSearchStrings;
    MB.CleanUpTmpLists;        // status: ok (No StatusChange allowed)

    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                        Integer(PChar(_(MediaLibrary_SearchingNewFilesComplete ) )));

    if MB.ChangeAfterUpdate then
        MB.Changed := True;
  end else
  begin
      SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                        Integer(PChar(_(MediaLibrary_SearchingNewFiles_NothingFound )) ));

      SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
  end;

  // current //job// is done, set status to 0
  SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
  // check for the next job
  SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);

  try
      CloseHandle(MB.fHND_UpdateThread);
  except
  end;
end;
{
    --------------------------------------------------------
    PrepareNewFilesUpdate
    - Merge UpdateList with MainList into tmp-List
      VCL MUST NOT write on the library,
      e.g. no Sorting
           no ID3-Tag-Editing
      Duration of this Operation: a few seconds
    --------------------------------------------------------
}
procedure TMedienBibliothek.PrepareNewFilesUpdate;
var i, d: Integer;
    aAudioFile: TAudioFile;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(MediaLibrary_Preparing)));

  // Merge new files into Mp3ListePfadSort
  UpdateList.Sort(Sort_Pfad_asc);
  MergeFilesIntoPathList(UpdateList);

  PlaylistUpdateList.Sort(SortPlaylists_Path);
  MergePlaylists(AllPlaylistsPfadSort, PlaylistUpdateList);

  if ChangeAfterUpdate then
  begin
      // i.e. new files, not from a *.gmp-File
      // Collect information of used Drives
      EnterCriticalSection(CSAccessDriveList);
      fDriveManager.AddDrivesFromAudioFiles(UpdateList);
      fDriveManager.AddDrivesFromPlaylistFiles(PlaylistUpdateList);
      LeaveCriticalSection(CSAccessDriveList);
  end;

  // Change Category for previously existing files
  if CategoryChangeList.Count > 0 then
    ChangeCategory(Nil, fChangeCategory, CategoryChangeList, caCategoryCopy);

  // Build proper Browse-Lists
  case BrowseMode of
      0,1: begin
          MergeFileIntoCategories(UpdateList);
          MergePlaylistsIntoCategories(PlaylistUpdateList);
      end;

      2: begin
          MergeFileIntoCategories(UpdateList);
          MergePlaylistsIntoCategories(PlaylistUpdateList);
      end;
  end;

  if assigned(FavoritePlaylistCategory) and (FavoritePlaylistCategory.CollectionCount = 0) then
    MergeNempDefaultPlaylists;

  if WebRadioCategory.CollectionCount = 0 then
    MergeWebradioIntoCategories(RadioStationList);


  // Check for Duplicates
  // Note: This test should be always negative. If not, something in the system went wrong. :(
  //       Probably the Sort and Binary-Search methods do not match then.
  for i := 0 to Mp3ListePfadSort.Count-2 do
  begin
    if Mp3ListePfadSort[i].Pfad = Mp3ListePfadSort[i+1].Pfad then
    begin
      // Oops. Send Warning to MainWindow
      SendMessage(MainWindowHandle, WM_MedienBib, MB_DuplicateWarning, Integer(pWideChar(Mp3ListePfadSort[i].Pfad)));
      ChangeAfterUpdate := True; // We need to save the changed library after the cleanup

      AnzeigeListe.Clear;
      AnzeigeListIsCurrentlySorted := False;
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
      // Delete Duplicates
      for d := Mp3ListePfadSort.Count-1 downto 1 do
      begin
        if Mp3ListePfadSort[d-1].Pfad = Mp3ListePfadSort[d].Pfad then
        begin
          aAudioFile := Mp3ListePfadSort[d];
          Mp3ListePfadSort.Extract(aAudioFile);

          BibSearcher.RemoveAudioFileFromLists(aAudioFile);
          FreeAndNil(aAudioFile);
        end;
      end;
      // break testing-loop. Duplicates has been deleted.
      break;
    end;
  end;

  FinishCategories;
end;


procedure TMedienBibliothek.BuildSearchStrings;
begin
  EnterCriticalSection(CSUpdate);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_ReadAccessBlocked);

  BibSearcher.BuildTotalSearchStrings(Mp3ListePfadSort);
  LeaveCriticalSection(CSUpdate);

  fSearchStringIsDirty := False;
end;
{
    --------------------------------------------------------
    CleanUpTmpLists
    - After Update, clear the temporary lists
      and give VCL full access to library again
    Duration: a few milli-seconds
    --------------------------------------------------------
}
procedure TMedienBibliothek.CleanUpTmpLists;
begin
  Updatelist.Clear;
  PlaylistUpdateList.Clear;
  CategoryChangeList.Clear;
  {.$Message Warn 'Status darf im Thread nicht gesetzt werden'}
  {.$Message Warn 'Und auf 0 gar nicht, weil es hier evtl. noch weitergeht!!'}
end;

{
    --------------------------------------------------------
    DeleteFilesUpdateBib
    - Collect dead files (i.e. not existing files) and remove them
      from the library
    --------------------------------------------------------
}
Procedure TMedienBibliothek.DeleteFilesUpdateBib;
  var Dummy: Cardinal;
begin
  if StatusBibUpdate = 0 then
  begin
      UpdateFortsetzen := True;
      StatusBibUpdate := 1;
      fHND_DeleteFilesThread := BeginThread(Nil, 0, @fDeleteFilesUpdateUser, Self, 0, Dummy);
  end;
end;

Procedure TMedienBibliothek.DeleteFilesUpdateBibAutomatic;
  var Dummy: Cardinal;
begin
  if StatusBibUpdate = 0 then
  begin
      UpdateFortsetzen := True;
      StatusBibUpdate := 1;
      fHND_DeleteFilesThread := BeginThread(Nil, 0, @fDeleteFilesUpdateAutomatic, Self, 0, Dummy);
  end else
      // consider it done.
      SendMessage(MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);
end;
{
    --------------------------------------------------------
    fDeleteFilesUpdate_USER||Automatic
    - runs in secondary thread and calls several private methods
    --------------------------------------------------------
}
Procedure fDeleteFilesUpdateUser(MB: TMedienbibliothek);
begin
    fDeleteFilesUpdateContainer(MB, true);
end;
Procedure fDeleteFilesUpdateAutomatic(MB: TMedienbibliothek);
begin
    fDeleteFilesUpdateContainer(MB, false);
end;

Procedure fDeleteFilesUpdateContainer(MB: TMedienbibliothek; askUser: Boolean);
var DeleteDataList: TObjectList;
    SummaryDeadFiles: TDeadFilesInfo;
begin
    // Status is = 1 here (see above)     // status: Temporary comments, as I found a concept-bug here ;-)
    MB.fCollectDeadFiles;                  // status: ok, no change needed
    // there ---^ check MB.fCurrentJob for a matching parameter

    if (MB.DeadFiles.Count + MB.DeadPlaylists.Count) > 0 then
    begin
        DeleteDataList := TObjectList.Create(True);
        try
            MB.fPrepareUserInputDeadFiles(DeleteDataList);
            if askUser then
            begin
                // let the user correct the list
                SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(_(MediaLibrary_SearchingMissingFilesComplete_PrepareUserInput))));

                SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UserInputDeadFiles, lParam(DeleteDataList));
                MB.fReFillDeadFilesByDataList(DeleteDataList);
            end
            else
            begin
                // user can't change anything, fill the list
                MB.fReFillDeadFilesByDataList(DeleteDataList);
                // create a message containing a summary of the files to be deleted now (for logging, if wanted)
                MB.fGetDeadFilesSummary(DeleteDataList, SummaryDeadFiles);
                SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_InfoDeadFiles, lParam(@SummaryDeadFiles));
            end;
        finally
            DeleteDataList.Free;
        end;
    end;

    if (MB.DeadFiles.Count + MB.DeadPlaylists.Count) > 0 then
    begin
        MB.fPrepareDeleteFilesUpdate;          // status: ok, change via SendMessage
        MB.RefreshCollections;
        MB.BuildSearchStrings;
        MB.Changed := True;

        // Delete AudioFiles from "VCL-Lists"
        // This includes AnzeigeListe and the BibSearcher-Lists
        // MainForm will call CleanUpDeadFilesFromVCLLists
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckAnzeigeList, 0);
        // Free deleted AudioFiles
        MB.fCleanUpDeadFiles;                  // status: ok, no change needed
        // Clear temporary lists
        MB.CleanUpTmpLists;                   // status: ok, no change allowed

        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                        Integer(PChar(_(DeleteSelect_DeletingFilesComplete )) ));
    end else
    begin
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckAnzeigeList, 0);
        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);

        SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                        Integer(PChar(_(DeleteSelect_DeletingFilesAborted )) ));
    end;

    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free); // status: ok, thread finished
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);

    try
        CloseHandle(MB.fHND_DeleteFilesThread);
    except
    end;
end;

{
    --------------------------------------------------------
    CollectDeadFiles
    - Block Update-Access to library.
      i.e. VCL MUST NOT start a searching for new files
    --------------------------------------------------------
}
Function TMedienBibliothek.fCollectDeadFiles: Boolean;
var i, ges, freq: Integer;
    nt, ct: Cardinal;
begin
      SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockUpdateStart, 0);
      SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));
      SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_CleanUp));

      ges := Mp3ListePfadSort.Count + AllPlaylistsPfadSort.Count  + 1;
      freq := Round(ges / 100) + 1;
      ct := GetTickCount;
      for i := 0 to Mp3ListePfadSort.Count-1 do
      begin
          if Not FileExists(Mp3ListePfadSort[i].Pfad) then
            DeadFiles.Add(Mp3ListePfadSort[i]);

          nt := GetTickCount;
          if (i mod freq = 0) or (nt > ct + 500) or (nt < ct) then
          begin
                ct := nt;
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressSearchDead,
                      Integer(PChar( Mp3ListePfadSort[i].Ordner)) );

                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/ges * 100));
                // SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressSearchDead, Round(i/ges * 100));

                SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, (i+1) - DeadFiles.Count);
                SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, DeadFiles.Count);
          end;

          if not UpdateFortsetzen then break;
      end;

      for i := 0 to AllPlaylistsPfadSort.Count-1 do
      begin
          if Not FileExists(AllPlaylistsPfadSort[i].Path) then
            DeadPlaylists.Add(AllPlaylistsPfadSort[i]);

          nt := GetTickCount;
          if (i mod freq = 0) or (nt > ct + 500) or (nt < ct) then
          begin
              ct := nt;
              SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressSearchDead, Integer(PChar(MediaLibrary_SearchingMissingPlaylist)));
              SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round((Mp3ListePfadSort.Count+i)/ges * 100));

              SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount,
                                Mp3ListePfadSort.Count + i - DeadFiles.Count - DeadPlaylists.Count);
              SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount,
                                DeadFiles.Count + DeadPlaylists.Count);
          end;

          if not UpdateFortsetzen then break;
      end;
      result := True;

      SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(MediaLibrary_SearchingMissingFilesComplete_AnalysingData)));
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);
      SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));
end;
{
    --------------------------------------------------------
    UserInputDeadFiles
    - Let the user select file that shoul be deleted (or not)
    - change DeadFiles acording to user input
    --------------------------------------------------------
}
procedure TMedienBibliothek.fPrepareUserInputDeadFiles(DeleteDataList: TObjectList);
var i: Integer;
    currentDir: String;
    currentLogicalDrive, currentLibraryDrive: TDrive;
    currentDriveChar: Char;
    currentPC: String;
    newDeleteData, currentDeleteData: TDeleteData;

    function IsLocalDir(aFilename: String): Boolean;
    begin
        if length(aFilename) > 1 then
            result := aFilename[1] <> '\'
        else
            result := False;
    end;


    function ExtractPCNameFromPath(aDir: String): String;
    var posSlash: Integer;
    begin
        posSlash := posEx('\', aDir, 3);
        if posSlash >= 3 then
            result := Copy(aDir, 1, posSlash)
        else
            result := '';
    end;

    function RessourceCount(aPC: String): Integer;
    var j, c: Integer;
    begin
        c := 0;
        for j := 0 to mp3ListePfadSort.Count - 1 do
        begin
            if AnsiStartsText(aPC, Mp3ListePfadSort[j].Ordner) then
                inc(c);
        end;
        result := c;
    end;

    function GetMatchingDeleteDataObject(aDrive: String; isLocal: Boolean): TDeleteData;
    var i: Integer;
        fcurrentLogicalDrive, fcurrentLibraryDrive: TDrive;
    begin
        result := Nil;
        for i := 0 to DeleteDataList.Count - 1 do
        begin
            if TDeleteData(DeleteDataList[i]).DriveString = aDrive then
            begin
                result := TDeleteData(DeleteDataList[i]);
                break;
            end;
        end;

        if not assigned(result) then
        begin
            // create a new DeleteDataObject
            result := TDeleteData.Create;
            result.DriveString := aDrive;
            DeleteDataList.Add(result);
            if isLocal then
            begin
                fcurrentLogicalDrive := fDriveManager.GetPhysicalDriveByChar(aDrive[1]);
                fcurrentLibraryDrive := fDriveManager.GetManagedDriveByChar(aDrive[1]);
                if fcurrentLogicalDrive = NIL then
                begin
                    // complete Drive is NOT there
                    result.DoDelete       := False;
                    result.Hint           := dh_DriveMissing;

                    if assigned(fcurrentLibraryDrive) then
                        result.DriveType := fcurrentLibraryDrive.typ
                    else
                        result.DriveType := DriveTypeTexts[DRIVE_REMOTE];
                end else
                begin
                    // drive is there => just the file is not present
                    result.DoDelete    := True;
                    result.Hint        := dh_DivePresent;
                    result.DriveType   := fcurrentLibraryDrive.typ
                end;
            end else
            begin
                // assume that its missing, further check after this loop
                result.DoDelete    := False;
                result.Hint        := dh_NetworkMissing;
                result.DriveType   := DriveTypeTexts[DRIVE_REMOTE];
            end;
        end;
    end;

begin
    EnterCriticalSection(CSAccessDriveList);
    // prepare data - check whether the drive of the issing files exists etc.
    currentDriveChar  := ' ';    // invalid drive letter
    currentPC         := 'XXX';  // invalid PC-Name
    newDeleteData     := Nil;

    for i := 0 to DeadFiles.Count - 1 do
    begin
        currentDir := DeadFiles[i].Ordner;
        if length(currentDir) > 0 then
        begin
            if IsLocalDir(currentDir) then
            begin
                // C:\, F:\, whatever - a LOCAL drive
                if currentDriveChar <> currentDir[1] then
                begin
                    // beginning of a ne drive - check for this drive
                    currentDriveChar := currentDir[1];
                    currentLogicalDrive := fDriveManager.GetPhysicalDriveByChar(currentDriveChar);
                    currentLibraryDrive := fDriveManager.GetManagedDriveByChar(currentDriveChar);
                    newDeleteData := TDeleteData.Create;
                    newDeleteData.DriveString := currentDriveChar; // at first only the letter + ':\';
                    if currentLogicalDrive = NIL then
                    begin
                        // complete logical Drive is NOT there
                        newDeleteData.DoDelete       := False;
                        newDeleteData.Hint           := dh_DriveMissing;

                        // use the drivetype from the library
                        if assigned(currentLibraryDrive) then
                            newDeleteData.DriveType := currentLibraryDrive.typ
                        else
                            // fallback to "remote" (but this should not happen)
                            newDeleteData.DriveType := DriveTypeTexts[DRIVE_REMOTE];
                    end else
                    begin
                        // drive is there => just the file is not present
                        newDeleteData.DoDelete       := True;
                        newDeleteData.Hint           := dh_DivePresent;
                        newDeleteData.DriveType      := currentLogicalDrive.Typ;
                    end;
                    DeleteDataList.Add(newDeleteData);
                end;
            end else
            begin
                // File on another pc in the network
                if not AnsiStartsText(currentPC, currentDir)  then
                begin
                    currentPC := ExtractPCNameFromPath(currentDir);
                    newDeleteData := TDeleteData.Create;
                    newDeleteData.DriveString := currentPC ;
                    // assume that its missing, further check after this loop
                    newDeleteData.DoDelete       := False;
                    newDeleteData.Hint           := dh_NetworkMissing;
                    newDeleteData.DriveType  := DriveTypeTexts[DRIVE_REMOTE];
                    DeleteDataList.Add(newDeleteData);
                end;
            end;
        end; // otherwise something is really wrong with the file. ;-)
        // Add file to the DeleteData-Objects FileList
        if assigned(newDeleteData) then
            newDeleteData.Files.Add(DeadFiles[i]);
    end;

    // The same for playlists, but re-use the existing DeleteDataList-Objects
    currentDeleteData := Nil;
    currentDriveChar  := ' ';    // invalid drive letter
    currentPC         := 'XXX';  // invalid PC-Name

    for i := 0 to DeadPlaylists.Count - 1 do
    begin
        currentDir := DeadPlaylists[i].Path;
        if length(currentDir) > 0 then
        begin
            if IsLocalDir(currentDir) then
            begin
                if currentDriveChar <> currentDir[1] then
                begin
                    // beginning of a new drive - Get a matching DeleteData-Object from the already existing list
                    // (or create a new one)
                    currentDriveChar := currentDir[1];
                    currentDeleteData := GetMatchingDeleteDataObject(currentDriveChar{ + ':\'}, True);
                end;
            end else
            begin
                // File on another pc in the network
                if not AnsiStartsText(currentPC, currentDir)  then
                begin
                    currentPC := ExtractPCNameFromPath(currentDir);
                    currentDeleteData := GetMatchingDeleteDataObject(currentPC, False);
                end;
            end;
        end;
        // Add file to the DeleteData-Objects Playlist-FileList
        if assigned(currentDeleteData) then
            currentDeleteData.PlaylistFiles.Add(DeadPlaylists[i]);
    end;

    // make the drivestrings a little bit nicer, add the name (from the library-drive)
    for i := 0 to DeleteDataList.Count-1 do
    begin
        currentDeleteData := TDeleteData(DeleteDataList[i]);
        if Length(currentDeleteData.DriveString) > 0 then
        begin
            currentLibraryDrive := fDriveManager.GetManagedDriveByChar(currentDeleteData.DriveString[1]);
            if assigned(currentLibraryDrive) then
                currentDeleteData.DriveString := currentDeleteData.DriveString
                  + ':\ (' + currentLibraryDrive.Name + ')';
        end;
    end;

    // Try to determine, whether network-ressources are online or not
    for i := 0 to DeleteDataList.Count - 1 do
    begin
        if TDeleteData(DeleteDatalist[i]).DriveString[1] = '\' then
        begin
            if RessourceCount(TDeleteData(DeleteDatalist[i]).DriveString) >
               TDeleteData(DeleteDatalist[i]).Files.Count then
            begin
                // some files on this ressource can be found
                TDeleteData(DeleteDatalist[i]).DoDelete       := True;
                TDeleteData(DeleteDatalist[i]).Hint           := dh_NetworkPresent;
            end;
        end;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;
{
    --------------------------------------------------------
    ReFillDeadFilesByDataList
    - Refill the DeadFiles-List according to which files
      the user wants to be deleted
    --------------------------------------------------------
}
procedure TMedienBibliothek.fReFillDeadFilesByDataList(DeleteDataList: TObjectList);
var i, f: Integer;
    currentData: TDeleteData;
begin
    DeadFiles.Clear;
    DeadPlaylists.Clear;

    for i := 0 to DeleteDataList.Count - 1 do
    begin
        currentData := TDeleteData(DeleteDataList[i]);
        if currentData.DoDelete then
        begin
            for f := 0 to currentData.Files.Count - 1 do
                DeadFiles.Add(currentData.Files[f]);
            for f := 0 to currentData.PlaylistFiles.Count - 1 do
                Deadplaylists.Add(currentData.PlaylistFiles[f]);
        end;
    end;
end;

procedure TMedienBibliothek.fGetDeadFilesSummary(DeleteDataList: TObjectList; var aSummary: TDeadFilesInfo);
var i: Integer;
    currentData: TDeleteData;
begin
    aSummary.MissingDrives := 0;
    aSummary.ExistingDrives := 0;
    aSummary.MissingFilesOnMissingDrives := 0;
    aSummary.MissingFilesOnExistingDrives := 0;
    aSummary.MissingPlaylistsOnMissingDrives := 0 ;
    aSummary.MissingPlaylistsOnExistingDrives := 0;

    for i := 0 to DeleteDataList.Count - 1 do
    begin
        currentData := TDeleteData(DeleteDataList[i]);
        if currentData.DoDelete then
        begin
            aSummary.ExistingDrives := aSummary.ExistingDrives + 1;
            aSummary.MissingFilesOnExistingDrives := aSummary.MissingFilesOnExistingDrives + currentData.Files.Count;
            aSummary.MissingPlaylistsOnExistingDrives := aSummary.MissingPlaylistsOnExistingDrives + currentData.PlaylistFiles.Count;
        end else
        begin
            aSummary.MissingDrives := aSummary.MissingDrives  + 1;
            aSummary.MissingFilesOnMissingDrives := aSummary.MissingFilesOnMissingDrives + currentData.Files.Count;
            aSummary.MissingPlaylistsOnMissingDrives := aSummary.MissingPlaylistsOnMissingDrives + currentData.PlaylistFiles.Count;
        end;
    end;
end;
{
    --------------------------------------------------------
    PrepareDeleteFilesUpdate
    - Block Write-Access to library.
    - "AntiMerge" DeadFiles and Mainlist to tmp-List
    --------------------------------------------------------
}
procedure TMedienBibliothek.fPrepareDeleteFilesUpdate;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_ReadAccessBlocked);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(DeleteSelect_DeletingFiles)));

  DeadFiles.Sort(Sort_Pfad_asc);

  DeleteFilesFromPathList(DeadFiles);
  DeleteFilesFromOtherLists(DeadFiles);
  DeletePlaylists(DeadPlaylists);
end;

{
    --------------------------------------------------------
    CleanUpDeadFilesFromVCLLists
    - This is called by the VCL-thread,
      not from the secondary update-thread!
    --------------------------------------------------------
}
procedure TMedienBibliothek.CleanUpDeadFilesFromVCLLists;
var i: Integer;
begin
    // Delete DeadFiles from AnzeigeListe (meaning: from the possible "real" lists behind this list)
    for i := 0 to DeadFiles.Count - 1 do
    begin
        LastBrowseResultList      .Extract(DeadFiles[i]);
        LastQuickSearchResultList .Extract(DeadFiles[i]);
        LastMarkFilterList        .Extract(DeadFiles[i]);
    end;
    // Delete DeadFiles from BibSearcher
    BibSearcher.RemoveAudioFilesFromLists(DeadFiles);
end;
{
    --------------------------------------------------------
    CleanUpDeadFiles
    --------------------------------------------------------
}
procedure TMedienBibliothek.fCleanUpDeadFiles;
var i: Integer;
begin
  for i := 0 to DeadFiles.Count - 1 do
   DeadFiles[i].Free;
  for i := 0 to DeadPlaylists.Count - 1 do
    DeadPlaylists[i].Free;
  DeadFiles.Clear;
  DeadPlaylists.Clear;
end;

{
    --------------------------------------------------------
    RefreshFiles
    - create a secondary thread
      However, during the whole execution the library will be blocked, as
      - Artists/Albums may change, so binary search on the audiofiles will fail
        so browsing is not possible
      - Quicksearch will also fail, as the TotalStrings do not necessarly match
        the AudioFiles
      Refreshing without blocking would be possible, but require a full copy of the
      AudioFiles, which will require much more RAM
    --------------------------------------------------------
}
procedure TMedienBibliothek.RefreshFiles_All;
var Dummy: Cardinal;
begin
  if StatusBibUpdate = 0 then
  begin
      UpdateFortsetzen := True;
      StatusBibUpdate := BIB_Status_ReadAccessBlocked;
      // reset Coversearch
      CoverArtSearcher.StartNewSearch;
      // start refreshing files
      fHND_RefreshFilesThread := (BeginThread(Nil, 0, @fRefreshFilesThread_All, Self, 0, Dummy));
  end;
end;
procedure TMedienBibliothek.RefreshFiles_Selected;
var Dummy: Cardinal;
begin
  if StatusBibUpdate = 0 then
  begin
      UpdateFortsetzen := True;
      StatusBibUpdate := BIB_Status_ReadAccessBlocked;
      // reset Coversearch
      CoverArtSearcher.StartNewSearch;
      // start refreshing files
      fHND_RefreshFilesThread := (BeginThread(Nil, 0, @fRefreshFilesThread_Selected, Self, 0, Dummy));
  end;
end;

{
    --------------------------------------------------------
    fRefreshFilesThread
    - the secondary thread will call the proper private method
    --------------------------------------------------------
}
procedure fRefreshFilesThread_All(MB: TMedienbibliothek);
begin
    MB.fRefreshFiles(MB.Mp3ListePfadSort);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
        CloseHandle(MB.fHND_RefreshFilesThread);
    except
    end;
end;
procedure fRefreshFilesThread_Selected(MB: TMedienbibliothek);
begin
    MB.fRefreshFiles(MB.UpdateList);
    MB.UpdateList.Clear;
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
        CloseHandle(MB.fHND_RefreshFilesThread);
    except
    end;
end;

function TMedienBibliothek.GetDefaultFileCategory: TLibraryFileCategory;
begin
  result := fDefaultFileCategory;
end;

procedure TMedienBibliothek.SetDefaultFileCategory(Value: TLibraryFileCategory);
begin
  fDefaultFileCategory := Value;
  SetDefaultCategory(FileCategories, Value);
end;

function TMedienBibliothek.GetNewFilesCategory: TLibraryFileCategory;
begin
  result := fNewFilesCategory;
end;

procedure TMedienBibliothek.SetNewFilesCategory(Value: TLibraryFileCategory);
begin
  fNewFilesCategory := Value;
  SetNewCategory(FileCategories, Value);
end;

function TMedienBibliothek.GetDefaultPlaylistCategory: TLibraryPlaylistCategory;
begin
  result := TLibraryPlaylistCategory(PlaylistCategories[0]);
end;

function TMedienBibliothek.GetFavoritePlaylistCategory: TLibraryPlaylistCategory;
begin
  if PlaylistCategories.Count > 1 then
    result := TLibraryPlaylistCategory(PlaylistCategories[1])
  else
    result := Nil;
end;

{
    --------------------------------------------------------
    fRefreshFilesThread
    - Block read access for the VCL
    --------------------------------------------------------
}
function TMedienBibliothek.RelocateAudioFile(aAudioFile: TAudioFile): Boolean;
var
  i, actualCatIdx: Integer;
  checked: Boolean;
begin
  result := False;
  checked := False;
  for i := 0 to FileCategories.Count - 1 do begin
    actualCatIdx := FileCategories[i].Index;
    if aAudioFile.IsCategory(actualCatIdx) then begin
      checked := True;
      if TLibraryFileCategory(FileCategories[i]).RelocateAudioFile(aAudioFile) then
        result := True;
    end;
  end;
  if not checked then begin
    result := DefaultFileCategory.RelocateAudioFile(aAudioFile);
  end;
end;

function TMedienBibliothek.CollectionKeyHasChanged(aAudioFile: TAudioFile): Boolean;
var
  i, actualCatIdx: Integer;
  checked: Boolean;
begin
  result := False;
  checked := False;
  for i := 0 to FileCategories.Count - 1 do begin
    actualCatIdx := FileCategories[i].Index;
    if aAudioFile.IsCategory(actualCatIdx) then begin
      checked := True;
      if TLibraryFileCategory(FileCategories[i]).CollectionKeyHasChanged(aAudioFile) then
        result := True;
    end;
  end;
  if not checked then begin
    result := DefaultFileCategory.CollectionKeyHasChanged(aAudioFile);
  end;
end;

procedure TMedienBibliothek.fRefreshFiles(aRefreshList: TAudioFileList);
var i, freq, ges: Integer;
    AudioFile: TAudioFile;
    einUpdate: boolean;
    DeleteDataList: TObjectList;
    ct, nt: Cardinal;
begin
  // AudioFiles will be changed. Block everything.
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0); //
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));
  SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_RefreshFiles));

  einUpdate := False;

  EnterCriticalSection(CSUpdate);
  ges := aRefreshList.Count;
  freq := Round(aRefreshList.Count / 100) + 1;
  ct := GetTickCount;
  for i := 0 to aRefreshList.Count - 1 do
  begin
        AudioFile := aRefreshList[i];
        if FileExists(AudioFile.Pfad) then
        begin
            AudioFile.FileIsPresent := True;
            if SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshAudioFile, lParam(AudioFile)) = Integer(True) then
              einUpdate := True;
        end
        else
        begin
            AudioFile.FileIsPresent:=False;
            DeadFiles.Add(AudioFile);
        end;

        nt := GetTickCount;
        if (i mod freq = 0) or (nt > ct + 500) or (nt < ct) then
        begin
            ct := nt;
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressCurrentFileOrDirUpdate,
                            Integer(PWideChar(Format(_(MediaLibrary_RefreshingFilesInDir),
                                                  [ AudioFile.Ordner ]))));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/ges * 100));
            SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, (i+1) - DeadFiles.Count);
            SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, DeadFiles.Count);
        end;

        if Not UpdateFortsetzen then break;
  end;

  SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);


  // first: adjust Browse&Search stuff for the new data
  if einUpdate then
  begin
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(MediaLibrary_RefreshingFilesPreparingLibrary)));
      SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
      {
        While refreshing AudioData, the files have been relocated in the Category-Collection-Structure..
        But the structure may have been changed (e.g. some new collections, or now empty ones), so these should be sorted and analysed again
      }
      RefreshCollections;
      BuildSearchStrings;
  end;

  // After this: Handle missing files
  if DeadFiles.Count > 0 then
  begin
      // SendMessage(MainWindowHandle, WM_MedienBib, MB_DeadFilesWarning, LParam(DeadFiles.Count));
      DeleteDataList := TObjectList.Create(True);
      try
          fPrepareUserInputDeadFiles(DeleteDataList);
          SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressShowHint, Integer(PChar(_(MediaLibrary_SearchingMissingFilesComplete_PrepareUserInput))));
          SendMessage(MainWindowHandle, WM_MedienBib, MB_UserInputDeadFiles, lParam(DeleteDataList));
          // user can change DeleteDataList (set the DoDelete-property of the objects)
          // so: Change the DeadFiles-list and fill it with the files that should be deleted.
          fReFillDeadFilesByDataList(DeleteDataList);
      finally
          DeleteDataList.Free;
      end;

      if (DeadFiles.Count{ + DeadPlaylists.Count}) > 0 then
      // (we haven't checked for playlist during "refreshing files"
      begin
          fPrepareDeleteFilesUpdate;
          RefreshCollections;
          BuildSearchStrings;
          SendMessage(MainWindowHandle, WM_MedienBib, MB_CheckAnzeigeList, 0);
          fCleanUpDeadFiles;
          CleanUpTmpLists;
      end;

      SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free); // status: ok, thread finished
  end;

  LeaveCriticalSection(CSUpdate);

  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                        Integer(PChar(_(MediaLibrary_RefreshingFilesCompleteFinished ) )));

  // Status zurücksetzen, Unblock library
  SendMessage(MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));

  // Changed Setz. Ja...IMMER. Eine Abfrage, ob sich _irgendwas_ an _irgendeinem_ File
  // geändert hat, führe ich nicht durch.
  Changed := True;
end;


{
    --------------------------------------------------------
    GetLyrics
    - Creates a secondary thread and load lyrics from LyricWiki.org
    --------------------------------------------------------
}

procedure TMedienBibliothek.GetLyrics;
begin
  MessageDLG((MediaLibrary_SearchLyricsDisabled), mtInformation, [MBOK], 0);
  (*
    Main construct still in comments, just for the case this feature will be revived later
    // Status MUST be set outside
    // (the updatelist is filled in VCL-Thread)
    // But, to be sure:
    StatusBibUpdate := 1;
    UpdateFortsetzen := True;

    fHND_GetLyricsThread := BeginThread(Nil, 0, @fGetLyricsThread, Self, 0, Dummy);
  *)
end;

{
    --------------------------------------------------------
    fGetLyricsThread
    - secondary thread
    Files the user wants to fill with lyrics are stored in the UpdateList,
    so CleanUpTmpLists must be called after getting Lyrics.
    --------------------------------------------------------
}
(*
procedure fGetLyricsThread(MB: TMedienBibliothek);
begin
    MB.fGetLyrics;
    MB.CleanUpTmpLists;
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
      CloseHandle(MB.fHND_GetLyricsThread);
    except
    end;
end;*)
{
    --------------------------------------------------------
    fGetLyrics
    - Block Update-Access
    --------------------------------------------------------
}
(*procedure TMedienBibliothek.fGetLyrics;
var i: Integer;
    aAudioFile: TAudioFile;
    LyricWikiResponse, backup: String;
    done, failed: Integer;
    Lyrics: TLyrics;
    aErr: TNempAudioError;
    ErrorOcurred, CurrentSuccess: Boolean;
    ErrorLog: TErrorLog;

    tmpLyricFirstPriority,tmpLyricSecondPriority  : TLyricFunctionsEnum;

begin
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockUpdateStart, 0);

    done := 0;
    failed := 0;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));
    SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_Searchlyrics));

    ErrorOcurred := False;

    Lyrics :=  TLyrics.create;
    try
            // Lyrics suchen
            for i := 0 to UpdateList.Count - 1 do
            begin
                if not UpdateFortsetzen then break;

                aAudioFile := UpdateList[i];
                if FileExists(aAudioFile.Pfad)
                    AND aAudioFile.HasSupportedTagFormat
                then
                begin
                    // call the vcl, that we will edit this file now
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                            Integer(PWideChar(aAudioFile.Pfad)));

                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressCurrentFileOrDirUpdate,
                            Integer(PWideChar(Format(_(MediaLibrary_SearchingLyrics_JustFile),
                                                  [ aAudioFile.Dateiname ]))));

                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));

                    aAudioFile.FileIsPresent:=True;

                    // possible ENetHTTPClientException is handled in Lyrics.GetLyris
                    LyricWikiResponse := Lyrics.GetLyrics(aAudiofile.Artist, aAudiofile.Titel);
                    if LyricWikiResponse <> '' then
                    begin
                        backup := String(aAudioFile.Lyrics);
                        // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                        aAudioFile.GetAudioData(aAudioFile.Pfad);
                        // Set new Lyrics
                        aAudioFile.Lyrics := UTF8Encode(LyricWikiResponse);
                        aErr := aAudioFile.WriteLyricsToMetaData(aAudioFile.Lyrics, True);
                        if aErr = AUDIOERR_None then
                        begin
                            inc(done);
                            CurrentSuccess := True;
                            Changed := True;
                        end else
                        begin
                            // discard new lyrics
                            aAudioFile.Lyrics := Utf8String(backup);
                            inc(failed);
                            CurrentSuccess := False;
                            ErrorOcurred := True;
                            // FehlerMessage senden
                            ErrorLog := TErrorLog.create(afa_LyricSearch, aAudioFile, aErr, false);
                            try
                                SendMessage(MainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                            finally
                                ErrorLog.Free;
                            end;
                        end;
                    end
                    else
                    begin
                        inc(failed);
                        CurrentSuccess := False;
                        // as set by Lyrics.getLyrics, in case of an Exception
                        if Lyrics.ExceptionOccured then
                        begin
                            ErrorOcurred := True;  // Count Exceptions?
                            // Display Exception Message
                            SendMessage(MainWindowHandle, WM_MedienBib, MB_MessageForLog, LParam(Lyrics.ExceptionMessage));
                        end;

                    end;
                end
                else begin
                    if Not FileExists(aAudioFile.Pfad) then
                        aAudioFile.FileIsPresent:=False;
                    inc(failed);
                    CurrentSuccess := False;
                end;
                if CurrentSuccess then
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, done)
                else
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, failed);

            end;
    finally
            Lyrics.Free;
    end;

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

    SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));

    // Build TotalStrings
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
    BibSearcher.BuildTotalSearchStrings(Mp3ListePfadSort);

    if ErrorOcurred then
    begin
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                Integer(PChar(_(MediaLibrary_SearchLyricsComplete_SomeErrors))));
        // display the Warning-Image
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessCompleteSomeErrors, 0);
    end else
    begin
          if done + failed = 1 then
          begin
              // ein einzelnes File wurde angefordert
              // Bei Misserfolg einen Hinweis geben.
              if (done = 0) then
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchLyricsComplete_SingleNotFound))))
              else
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchLyricsComplete_AllFound))))
          end else
          begin
              // mehrere Dateien wurden gesucht.
              if failed = 0 then
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchLyricsComplete_AllFound))))
              else
                  if done > 0.5 * (failed + done) then
                      // ganz gutes Ergebnis - mehr als die Hälfte gefunden
                      SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                          Integer(PChar(Format(_(MediaLibrary_SearchLyricsComplete_ManyFound), [done, done + failed]))))
                  else
                      if done > 0 then
                          // Nicht so tolles Ergebnis
                          SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                              Integer(PChar(Format(_(MediaLibrary_SearchLyricsComplete_FewFound), [done, done + failed]))))
                      else
                          SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                              Integer(PChar(_(MediaLibrary_SearchLyricsComplete_NoneFound))))
          end;
    end;
end;
*)



{
    --------------------------------------------------------
    GetTags
    - Same as GetLyrics:
      Creates a secondary thread and get Tags from LastFM
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetTags;
  var Dummy: Cardinal;
begin
    // Status MUST be set outside
    // (the updatelist is filled in VCL-Thread)
    // But, to be sure:
    StatusBibUpdate := 1;
    UpdateFortsetzen := True;
    // copy the Ignore- and Rename-Lists to make them thread-safe
    fPrepareGetTags;
    // start the thread
    fHND_GetTagsThread := BeginThread(Nil, 0, @fGetTagsThread, Self, 0, Dummy);
end;

procedure TMedienBibliothek.fPrepareGetTags;
var i: Integer;
    aTagMergeItem: TTagMergeItem;
begin
    fIgnoreListCopy.Clear;
    fMergeListCopy.Clear;
    for i := 0 to TagPostProcessor.IgnoreList.Count - 1 do
        fIgnoreListCopy.Add(TagPostProcessor.IgnoreList[i]);

    for i := 0 to TagPostProcessor.MergeList.Count-1 do
    begin
        aTagMergeItem := TTagMergeItem.Create(
            TTagMergeItem(TagPostProcessor.MergeList[i]).OriginalKey,
            TTagMergeItem(TagPostProcessor.MergeList[i]).ReplaceKey);
        fMergeListCopy.Add(aTagMergeItem);
    end;
end;
{
    --------------------------------------------------------
    fGetTagsThread
    - start a secondary thread
    --------------------------------------------------------
}
procedure fGetTagsThread(MB: TMedienBibliothek);
begin
    MB.fGetTags;
    MB.CleanUpTmpLists;
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
        CloseHandle(MB.fHND_GetTagsThread);
    except
    end;
end;
{
    --------------------------------------------------------
    fGetTags
    - getting the tags
    --------------------------------------------------------
}
procedure TMedienBibliothek.fGetTags;
var i: Integer;
    done, failed: Integer;
    af: TAudioFile;
    s, backup: String;
    aErr: TNempAudioError;
    ErrorOcurred, currentSuccess: Boolean;
    ErrorLog: TErrorLog;
begin
    done := 0;
    failed := 0;
    ErrorOcurred := false;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));

    // if UpdateList.Count > 1 then
        SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_SearchTags));

    for i := 0 to UpdateList.Count - 1 do
    begin
        if not UpdateFortsetzen then break;

        af := UpdateList[i];

        if FileExists(af.Pfad) AND af.HasSupportedTagFormat then
        begin
            // call the vcl, that we will edit this file now
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                        Integer(PWideChar(af.Pfad)));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressCurrentFileOrDirUpdate,
                            Integer(PWideChar(Format(_(MediaLibrary_SearchingTags_JustFile),
                                                      [af.Dateiname]))));

            //SendMessage(MainWindowHandle, WM_MedienBib, MB_TagsUpdateStatus,
            //            Integer(PWideChar(Format(_(MediaLibrary_SearchTagsStats), [done, done + failed]))));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));
            af.FileIsPresent:=True;

            // GetTags will create the IDHttp-Object
            s := BibScrobbler.GetTags(af);
            // 08.2017: s is a comma-separated list of tags now

            // bei einer exception ganz abbrechen??
            // nein, manchmal kommen ja auch BadRequests...???
            if trim(s) = '' then
            begin
                inc(failed);
                currentSuccess := False;

                if BibScrobbler.ExceptionOccured then
                begin
                    ErrorOcurred := True;  // Count Exceptions?
                    // Display Exception Message
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_MessageForLog, LParam(BibScrobbler.ExceptionMessage));
                end;

            end else
            begin
                backup := String(af.RawTagLastFM);
                // process new Tags. Rename, delete ignored and duplicates.

                // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                af.GetAudioData(af.Pfad);

                // Set new Tags
                // change to medienbib.addnewtag (THREADED)
                // param false: do not ignore warnings but resolve inconsistencies
                // param true: use thread-safe copies of rule-lists
                AddNewTag(af, s, False, True);
                aErr := af.WriteRawTagsToMetaData(af.RawTagLastFM, True);

                if aErr = AUDIOERR_None then
                begin
                    Changed := True;
                    inc(done);
                    currentSuccess := True;
                end
                else
                begin
                    inc(failed);
                    currentSuccess := False;
                    ErrorOcurred := True;
                    // FehlerMessage senden
                    ErrorLog := TErrorLog.create(afa_TagSearch, af, aErr, false);
                    try
                        SendMessage(MainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                    finally
                        ErrorLog.Free;
                    end;
                end;
            end;
        end else
        begin
            if Not FileExists(af.Pfad) then
                af.FileIsPresent:=False;
            inc(failed);
            currentSuccess := False;
        end;

        if CurrentSuccess then
            SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, done)
        else
            SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, failed);
    end;

    if done > 0 then
        SendMessage(MainWindowHandle, WM_MedienBib, MB_TagsSetFinished, 0);

    SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));


    if ErrorOcurred then
    begin
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                Integer(PChar(_(MediaLibrary_SearchTagsComplete_SomeErrors))));
        // display the Warning-Image
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessCompleteSomeErrors, 0);
    end else
    begin
          if done + failed = 1 then
          begin
              // ein einzelnes File wurde angefordert
              // Bei Mißerfolg einen Hinweis geben.
              if (done = 0) then
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchTagsComplete_SingleNotFound))))
              else
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchTagsComplete_AllFound))))
          end else
          begin
              // mehrere Dateien wurden gesucht.
              if failed = 0 then
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar(_(MediaLibrary_SearchTagsComplete_AllFound))))
              else
                  if done > 0.5 * (failed + done) then
                      // ganz gutes Ergebnis - mehr als die Hälfte gefunden
                      SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                          Integer(PChar(Format(_(MediaLibrary_SearchTagsComplete_ManyFound), [done, done + failed]))))
                  else
                      if done > 0 then
                          // Nicht so tolles Ergebnis
                          SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                              Integer(PChar(Format(_(MediaLibrary_SearchTagsComplete_FewFound), [done, done + failed]))))
                      else
                          SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                              Integer(PChar(_(MediaLibrary_SearchTagsComplete_NoneFound))))
          end;
    end;
end;


{
    --------------------------------------------------------
    UpdateId3tags
    - Updating the ID3Tags
      Used by the TagCloud-Editor
    --------------------------------------------------------
}
procedure TMedienBibliothek.UpdateId3tags;
var Dummy: Cardinal;
begin
    // Status MUST be set outside
    // (the updatelist is filled in VCL-Thread)
    // But, to be sure:
    StatusBibUpdate := 1;
    UpdateFortsetzen := True;
    fHND_UpdateID3TagsThread := BeginThread(Nil, 0, @fUpdateID3TagsThread, Self, 0, Dummy);
end;



procedure fUpdateID3TagsThread(MB: TMedienBibliothek);
begin
    MB.fUpdateId3tags;

    // Note: CleanUpTmpLists and stuff is not necessary here.
    // We did not change the library, we "just" changed the ID3-Tags in some files
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    try
        CloseHandle(MB.fHND_UpdateID3TagsThread);
    except
    end;
end;

procedure TMedienBibliothek.fUpdateId3tags;
var i, freq, ges: Integer;
    af: TAudioFile;
    aErr: TNempAudioError;
    ErrorOcurred: Boolean;
    ErrorLog: TErrorLog;
    ct, nt: Cardinal;
    errCount, inconCount: Integer;
    newTags: UTF8String;
begin
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));
    SendMessage(MainWindowHandle, WM_MedienBib, MB_StartLongerProcess, Integer(pa_UpdateMetadata));

    ErrorOcurred := False;

    ges := UpdateList.Count;
    freq := Round(UpdateList.Count / 100) + 1;
    ct := GetTickCount;
    errCount := 0;

    for i := 0 to UpdateList.Count - 1 do
    begin
        if not UpdateFortsetzen then break;

        af := UpdateList[i];

        if FileExists(af.Pfad) then
        begin
            // call the vcl, that we will edit this file now
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                        Integer(PWideChar(af.Pfad)));

            nt := GetTickCount;
            if (i mod freq = 0) or (nt > ct + 500) or (nt < ct) then
            begin
                ct := nt;
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/ges * 100));
                // display current item in progress-label
                SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile,
                        Integer(PWideChar(Format(MediaLibrary_CloudUpdateStatus, [af.Dateiname]))));
                // display success/fail
                SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessSuccessCount, i - errCount);
                SendMessage(MainWindowHandle, WM_MedienBib, MB_CurrentProcessFailCount, errCount);
            end;

            af.FileIsPresent := True;

            newTags := af.RawTagLastFM;
            // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
            af.GetAudioData(af.Pfad);
            af.RawTagLastFM := newTags;

            aErr := af.WriteRawTagsToMetaData(af.RawTagLastFM, True);
            if aErr = AUDIOERR_None then
            begin
                af.ID3TagNeedsUpdate := False;
                Changed := True;
            end else
            begin
                inc(errCount);
                ErrorOcurred := True;
                ErrorLog := TErrorLog.create(afa_TagCloud, af, aErr, false);
                try
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                finally
                    ErrorLog.Free;
                end;
            end;
        end else
        begin
            // not an unexpected error, but the file could not be updated, as it's currently not available
            inc(errCount);
        end;
    end;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, 100);
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));

    // this will reset the status of the MenuItem indicating the warning for inconsistent files
    SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile, Integer(PWideChar('')));


    // present a summary of this operation in the progress window
    if ErrorOcurred then
    begin
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                Integer(PChar(_(MediaLibrary_InconsistentFiles_SomeErrors))));
        // display the Warning-Image
        SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessCompleteSomeErrors, 0);
    end else
    begin
          if Updatefortsetzen then
          begin
              // user *did not* aborted the operation.
              if errCount = 0 then
                  // everything is fine
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete, Integer(PChar(MediaLibrary_InconsistentFiles_Completed_Success)))
              else
              begin
                  // some files are still inconsitent
                  inconCount := CountInconsistentFiles;
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                          Integer(PChar( Format(_(MediaLibrary_InconsistentFiles_Completed_SomeFailed),[inconCount]) )));
              end;
          end else
          begin
              // user *did* click on "Abort"
              // some ID3Tags are still inconsistent with the files in the library
              inconCount := CountInconsistentFiles;
              SendMessage(MainWindowHandle, WM_MedienBib, MB_UpdateProcessComplete,
                      Integer(PChar( Format(_(MediaLibrary_InconsistentFiles_Abort),[inconCount]) )));
          end;
    end;

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));
end;


{
    --------------------------------------------------------
    UpdateId3tags
    - Updating the ID3Tags
      Used by the TagCloud-Editor
    --------------------------------------------------------
}
procedure TMedienBibliothek.BugFixID3Tags;
var Dummy: Cardinal;
begin
    // Status MUST be set outside
    // (the updatelist is filled in VCL-Thread)
    // But, to be sure:
    StatusBibUpdate := 1;
    UpdateFortsetzen := True;
    fHND_BugFixID3TagsThread := BeginThread(Nil, 0, @fBugFixID3TagsThread, Self, 0, Dummy);
end;



procedure fBugFixID3TagsThread(MB: TMedienBibliothek);
begin
    MB.fBugFixID3Tags;
    // Note: CleanUpTmpLists and stuff is not necessary here.
    // We did not change the library, we "just" changed the ID3-Tags in some files
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
    try
        CloseHandle(MB.fHND_BugFixID3TagsThread);
    except
    end;
end;

procedure TMedienBibliothek.fBugFixID3Tags;
var i, f: Integer;
    af: TAudioFile;
    id3: TID3v2Tag;
    FrameList: TObjectList;
    ms: TMemoryStream;
    privateOwner: AnsiString;
    LogList: TStringList;
begin
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.Normal));

    LogList := TStringList.Create;
    try
        LogList.Add('Fixing ID3Tags. ');
        LogList.Add(DateTimeToStr(now));
        LogList.Add('Number of files to check: ' + IntToStr(UpdateList.Count));
        LogList.Add('---------------------------');

        for i := 0 to UpdateList.Count - 1 do
        begin

            if not UpdateFortsetzen then
            begin
                LogList.Add('Cancelled by User at file ' + IntToStr(i));
                break;
            end;

            af := UpdateList[i];

            if FileExists(af.Pfad) then
            begin
                // call the vcl, that we will edit this file now
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                            Integer(PWideChar(af.Pfad)));
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));

                SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile,
                        Integer(PWideChar(
                            Format(MediaLibrary_CloudUpdateStatus,
                            [{Round(i/UpdateList.Count * 100),} af.Dateiname]))));


                af.FileIsPresent := True;

                id3 := TID3v2Tag.Create;
                FrameList := TObjectList.Create(False);
                try
                    // Read the tag from the file
                    id3.ReadFromFile(af.Pfad);

                    // Get all private Frames in the ID3Tag
                    id3.GetAllPrivateFrames(FrameList);

                    // delete everything except the 'NEMP/Tags'-Private Frames
                    // (from this list only, not from the ID3Tag ;-) )
                    for f := FrameList.Count - 1 downto 0 do
                    begin
                        ms := TMemoryStream.Create;
                        try
                            (FrameList[f] as TID3v2Frame).GetPrivateFrame(privateOwner, ms);
                        finally
                            ms.Free;
                        end;
                        if privateOwner <> 'NEMP/Tags' then
                            FrameList.Delete(f);
                    end;

                    if FrameList.Count > 1 then
                    begin
                        LogList.Add('Duplicate Entry: ' + af.Pfad);
                        LogList.Add('Count: ' + IntToStr(FrameList.Count));
                        // Oops, we have duplicate 'NEMP/Tags' in the file :(
                        for f := FrameList.Count - 1 downto 0 do
                            // Delete all these Frames
                            id3.DeleteFrame(TID3v2Frame(FrameList[f]));

                        // Set New Private Frame
                        if length(af.RawTagLastFM) > 0 then
                        begin
                            ms := TMemoryStream.Create;
                            try
                                ms.Write(af.RawTagLastFM[1], length(af.RawTagLastFM));
                                id3.SetPrivateFrame('NEMP/Tags', ms);
                            finally
                                ms.Free;
                            end;
                        end else
                            // delete Tags-Frame
                            id3.SetPrivateFrame('NEMP/Tags', NIL);

                        // Update the File
                        id3.WriteToFile(af.Pfad);
                        LogList.Add('...fixed');
                        LogList.Add('');
                    end;

                finally
                    FrameList.Free;
                    id3.Free;
                end;
                Changed := True;
            end;
        end;
        LogList.Add('Done.');
        LogList.SaveToFile(SavePath + 'ID3TagBugFix.log', TEncoding.Unicode);
    finally
        LogList.Free;
    end;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(TTaskBarProgressState.None));

    SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile, Integer(PWideChar('')));

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar('')));
end;
{
    --------------------------------------------------------
    BuildTotalString
    BuildTotalLyricString
    - Build Strings for Accelerated Search directly, not via tmp-Strings
    Note: This MUST be done in VCL-Thread!
    --------------------------------------------------------
}
procedure TMedienBibliothek.BuildTotalString;
begin
    EnterCriticalSection(CSUpdate);
    BibSearcher.BuildTotalString(Mp3ListePfadSort);
    LeaveCriticalSection(CSUpdate);
end;
procedure TMedienBibliothek.BuildTotalLyricString;
begin
    EnterCriticalSection(CSUpdate);
    BibSearcher.BuildTotalLyricString(Mp3ListePfadSort);
    LeaveCriticalSection(CSUpdate);
end;

{
    --------------------------------------------------------
    DeleteAudioFile
    DeletePlaylist
    - Delete an AudioFile/Playlist from the library
    Run in VCL-Thread
    --------------------------------------------------------
}
function TMedienBibliothek.DeleteAudioFile(aAudioFile: tAudioFile): Boolean;
var
  i: Integer;
begin
//  result := StatusBibUpdate = 0;
// ??? Status MUST be set to 3 before calling this, as we have an "Application.ProcessMessages"
//     in the calling Method PM_ML_DeleteSelectedClick

  result := true;

  if aAudioFile = CurrentAudioFile then
      currentAudioFile := Nil;

  LastBrowseResultList      .Extract(aAudioFile);
  LastQuickSearchResultList .Extract(aAudioFile);
  LastMarkFilterList        .Extract(aAudioFile);

  if AnzeigeShowsPlaylistFiles then
  begin
    // Do NOT delete anything in that case: these file are handled by the AudioCollection
    // PlaylistFiles.Extract(aAudioFile);
  end
  else
  begin
      Mp3ListePfadSort.Extract(aAudioFile);
      BibSearcher.RemoveAudioFileFromLists(aAudioFile);
      // remove it from all Categories
      CoverSearchCategory.RemoveAudioFile(aAudioFile);
      for i := 0 to FileCategories.Count - 1 do
        TLibraryFileCategory(FileCategories[i]).RemoveAudioFile(aAudioFile);
      FreeAndNil(aAudioFile);
      Changed := True;
  end;
end;

function TMedienBibliothek.DeletePlaylist(aPlaylist: TLibraryPlaylist): Boolean;
var
  i: Integer;
begin
  result := StatusBibUpdate = 0;
  if StatusBibUpdate <> 0 then
    exit;

  // remove the PlaylistFile from the main list ...
  AllPlaylistsPfadSort.Remove(aPlaylist);
  // and from all Categories. This will NOT delete the corresponding Collections,
  // but the reference to "aPlaylist" is niled in there
  for i := 0 to PlaylistCategories.Count - 1 do
    TLibraryPlaylistCategory(PlaylistCategories[i]).RemovePlaylist(aPlaylist);
  // it's safe to free the playlist now
  FreeAndNil(aPlaylist);
  Changed := True;
end;

function TMedienBibliothek.DeleteWebRadioStation(aStation: TStation): Boolean;
begin
  result := StatusBibUpdate = 0;
  if StatusBibUpdate <> 0 then
    exit;

  TLibraryWebradioCategory(WebRadioCategory).RemoveStation(aStation);
  RadioStationList.Remove(aStation);
  Changed := True;
end;

{
    --------------------------------------------------------
    Abort
    - Set UpdateFortsetzen to false, to abort a running update-process
    --------------------------------------------------------
}
procedure TMedienBibliothek.Abort;
begin
  // when we get in "long VCL-actions" an exception,
  // the final MedienBib.StatusBibUpdate := 0; will not be called
  // so Nemp will never close
  // this is not 1000% "safe" with thread, but should be ok
  if not UpdateFortsetzen then
      StatusBibUpdate := 0;

  FileSearchAborted := True;
  // this is the main-code in this method
  if StatusBibUpdate > 0 then
  begin
      UpdateFortsetzen := False;
  end;
end;


procedure TMedienBibliothek.ChangeCoverID(oldID, newID: String);
var i: Integer;
begin
    if StatusBibUpdate >= 2 then exit;

    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
      if Mp3ListePfadSort[i].CoverID = oldID then
        Mp3ListePfadSort[i].CoverID := newID;
    end;
    Changed := True;
end;


procedure TMedienBibliothek.ChangeFileCollectionSorting(RCIndex, Layer: Integer;
  newSorting: teCollectionSorting; newDirection: teSortDirection; OnlyDirection: Boolean);
var
  iCat: Integer;
  rc: TRootCollection;
  FileCat: TLibraryCategory;
begin
  // Change Sorting in the Library-Configuration
  case self.BrowseMode of
    0: NempOrganizerSettings.ChangeFileCollectionSorting(RCIndex, Layer, newSorting, newDirection, OnlyDirection);
    1: NempOrganizerSettings.ChangeCoverFlowSorting(newSorting, newDirection, OnlyDirection);
  end;

  // change the sorting in the current Collections
  for iCat := 0 to FileCategories.Count - 1 do begin
    FileCat := FileCategories[iCat];

    if (FileCat.ItemCount > 0) and (RCIndex < FileCat.CollectionCount) then begin
      rc := TRootCollection(FileCat.Collections[RCIndex]);

      case rc.SpecialContent of
        scRegular: begin
          rc.ChangeSubCollectionSorting(Layer, newSorting, newDirection, OnlyDirection);
          rc.SortCollectionLevel(Layer, True);
        end;
        scDirectory: rc.ReSortDirectoryCollection(newSorting, newDirection, OnlyDirection, True);
        scTagCloud: rc.ReSortTagCloudCollection(newSorting, newDirection, OnlyDirection, True);
      end;

    end;
  end;
end;

procedure TMedienBibliothek.ChangePlaylistCollectionSorting(newSorting: tePlaylistCollectionSorting;
          newDirection: teSortDirection);
var
  catIdx: Integer;
begin
  NempOrganizerSettings.PlaylistSorting := newSorting;
  NempOrganizerSettings.PlaylistSortDirection := newDirection;
  for catIdx := 0 to PlaylistCategories.Count - 1 do
    TLibraryPlaylistCategory(PlaylistCategories[catIdx]).Sort(newSorting, newDirection);
end;

{
    --------------------------------------------------------
    After editing single files, the Collections-datastructure
    and/or the SearchString for QuickSearch need an update.
    --------------------------------------------------------
}
function TMedienBibliothek.SearchStringIsDirty(EditedColumn: Integer): Boolean;
begin
  if not BibSearcher.AccelerateSearch then
    fSearchStringIsDirty := False
  else begin
    fSearchStringIsDirty := fSearchStringIsDirty
      or (EditedColumn in [colIdx_ARTIST, colIdx_TITLE, colIdx_ALBUM])
      or (BibSearcher.AccelerateSearchIncludeComment and (EditedColumn = colIdx_COMMENT))
      or (BibSearcher.AccelerateSearchIncludeGenre and (EditedColumn = colIdx_GENRE))
      or (BibSearcher.AccelerateSearchIncludeComposer and (EditedColumn = colIdx_COMPOSER))
      or (BibSearcher.AccelerateSearchIncludeAlbumArtist and (EditedColumn = colIdx_ALBUMARTIST))
  end;

  result := fSearchStringIsDirty;
end;

function TMedienBibliothek.CollectionsAreDirty(EditedContent: teCollectionContent): Boolean;
var
  r: Integer;
  FileCat: TLibraryFileCategory;
begin
  result := fCollectionsAreDirty;
  if result or (editedContent = ccNone) then exit;

  FileCat := TLibraryFileCategory(FileCategories[0]);
  for r := 0 to FileCat.CollectionCount - 1 do
    fCollectionsAreDirty := fCollectionsAreDirty
      or TRootCollection(FileCat.Collections[r]).ContainsContent(editedContent)
      or TRootCollection(FileCat.Collections[r]).ContainsContent(ccTagCloud);

  result := fCollectionsAreDirty;
end;

function TMedienBibliothek.CollectionsAreDirty(EditedColumn: Integer): Boolean;
var
  editedContent: teCollectionContent;
begin
  case EditedColumn of
    colIdx_ARTIST : editedContent := ccArtist;
    colIdx_ALBUMARTIST : editedContent := ccArtist;
    colIdx_ALBUM  : editedContent := ccAlbum;
    colIdx_YEAR   : editedContent := ccYear;
    colIdx_GENRE  : editedContent := ccGenre;
  else
    editedContent := ccNone; // i.e. edited property isn't relevant for the structure of the Collection
  end;

  result := CollectionsAreDirty(editedContent);
end;

procedure TMedienBibliothek.RepairSearchStrings;
begin
  if fSearchStringIsDirty then begin
    EnterCriticalSection(CSUpdate);
    BibSearcher.BuildTotalSearchStrings(Mp3ListePfadSort);
    LeaveCriticalSection(CSUpdate);
    fSearchStringIsDirty := False;
  end;
end;

function TMedienBibliothek.TabBtnBrowse_InconsistencyHint: String;
begin
  result := TabBtnBrowse_RepairHint;
  if fSearchStringIsDirty then
    result := result + #13#10 + TabBtnBrowse_DirtySearch;
  if self.fCollectionsAreDirty then
    result := result + #13#10 + TabBtnBrowse_DirtyCollections;

  result := result + #13#10 + TabBtnBrowse_RepairHint2;
end;


{
    --------------------------------------------------------
    Methods to add new Tags to an AudioFile with respect to the Ignore/Merge-Lists
    --------------------------------------------------------
}
function TMedienBibliothek.AddNewTagConsistencyCheck(aAudioFile: TAudioFile; newTag: String): TTagConsistencyError;
var currentTagList, newTagList: TStringlist;
    i: Integer;
    replaceTag: String;
begin
    result := CONSISTENCY_OK;
    TagPostProcessor.LogList.Clear;

    currentTagList := TStringlist.Create;
    try
        currentTagList.Text := String(aAudioFile.RawTagLastFM);
        currentTagList.CaseSensitive := False;

        newTagList := TStringlist.Create;
        try
              if CommasInString(NewTag) then
                  // replace commas with linebreaks first
                  NewTag := ReplaceCommasbyLinebreaks(Trim(NewTag));
              // fill the Stringlist with the new Tags (probably only one)
              newTagList.Text := Trim(NewTag);

              for i := 0 to newTagList.Count-1 do
              begin
                  // duplicate in the list itself?
                  if newTagList.IndexOf(newTagList[i]) < i then
                  begin
                      if result = CONSISTENCY_OK then
                          result := CONSISTENCY_HINT; // Duplicate found, no user action required
                      TagPostProcessor.LogList.Add(Format(TagManagement_TagDuplicateInput, [newTagList[i]]));
                  end;
                  // Does it already exist?
                  if currentTagList.IndexOf(newTagList[i]) > -1 then
                  begin
                      if result = CONSISTENCY_OK then
                          result := CONSISTENCY_HINT;  // Duplicate found, no user action required
                      TagPostProcessor.LogList.Add(Format(TagManagement_TagAlreadyExists, [newTagList[i]]));
                  end;
                  // is it on the Igore list?
                  if TagPostProcessor.IgnoreList.IndexOf(newTagList[i]) > -1 then
                  begin
                      result := CONSISTENCY_WARNING; // new Tag is on the Ignore List, User action required
                      TagPostProcessor.LogList.Add(Format(TagManagement_TagIsOnIgnoreList, [newTagList[i]]));
                  end;
                  // is it on the Merge list?
                  replaceTag := GetRenamedTag(newTagList[i], TagPostProcessor.MergeList);
                  if replaceTag <> '' then
                  begin
                      result := CONSISTENCY_WARNING; // new tag is on the Merge list, User action required
                      TagPostProcessor.LogList.Add(Format(TagManagement_TagIsOnRenameList, [newTagList[i], replaceTag]));
                  end;
              end;
        finally
            newTagList.Free;
        end;
    finally
        currentTagList.Free;
    end;
end;


function TMedienBibliothek.AddNewTag(aAudioFile: TAudioFile; newTag: String; IgnoreWarnings: Boolean; Threaded: Boolean = False): TTagError;
var currentTagList, newTagList: TStringlist;
    i: Integer;
    replaceTag: String;
    localIgnoreList: TStringList;
    localMergeList: TObjectList;
begin
    result := TAGERR_NONE;
    currentTagList := TStringlist.Create;
    try
        currentTagList.Text := String(aAudioFile.RawTagLastFM);
        currentTagList.CaseSensitive := False;

        if Threaded then
        begin
            localIgnoreList := fIgnoreListCopy;
            localMergeList  := fMergeListCopy;
        end else
        begin
            localIgnoreList := TagPostProcessor.IgnoreList;
            localMergeList  := TagPostProcessor.MergeList;
        end;

        newTagList := TStringlist.Create;
        try
              if CommasInString(NewTag) then
                  // replace commas with linebreaks first
                  NewTag := ReplaceCommasbyLinebreaks(Trim(NewTag));
              // fill the Stringlist with the new Tags (probably only one)
              newTagList.Text := Trim(NewTag);

              // process the tags
              for i := newTagList.Count-1 downto 0 do
              begin
                  // is it on the Igore list?
                  if (localIgnoreList.IndexOf(newTagList[i]) > -1) and (not IgnoreWarnings) then
                      newTagList.Delete(i)
                  else
                  begin
                      // is it on the Merge list?
                      replaceTag := GetRenamedTag(newTagList[i], localMergeList);
                      if (replaceTag <> '') and (not IgnoreWarnings) then
                          newTagList[i] := replaceTag;
                  end;
              end;

              // delete duplicate entries in the new taglist
              for i := newTagList.Count-1 downto 0 do
                  if newTagList.IndexOf(newTagList[i]) < i then
                      newTagList.Delete(i);
              // delete the entries the file is already tagged with
              for i := newTagList.Count-1 downto 0 do
                  if currentTagList.IndexOf(newTagList[i]) > -1 then
                      newTagList.Delete(i);

              // add the new tags to the current tags
              newTag := Trim(newTagList.Text);
              if newTag <> '' then
              begin
                  Changed := True;
                  if aAudioFile.RawTagLastFM = '' then
                      aAudioFile.RawTagLastFM := UTF8String(newTag)
                  else
                  begin
                      // fixed some compiler warnings regarding implicit string casts
                      //cleanup current RawTag (to be sure)
                      aAudioFile.RawTagLastFM := UTF8String(trim(String(aAudioFile.RawTagLastFM)));
                      // add new Tag
                      aAudioFile.RawTagLastFM := aAudioFile.RawTagLastFM + #13#10 + UTF8String(newTag);
                  end;
              end;
        finally
            newTagList.Free;
        end;
    finally
        currentTagList.Free;
    end;
end;


{
    --------------------------------------------------------
    AudioFileExists
    PlaylistFileExists
    GetAudioFileWithFilename
    - Check, whether fa file is already in the library
    --------------------------------------------------------
}
function TMedienBibliothek.AudioFileExists(aFilename: UnicodeString): Boolean;
begin
    result := binaersuche(Mp3ListePfadSort, ExtractFileDir(aFilename), ExtractFileName(aFilename), 0,Mp3ListePfadSort.Count-1) > -1;
end;
function TMedienBibliothek.PlaylistFileExists(aFilename: UnicodeString): Boolean;
begin
    result := BinaerPlaylistSuche(AllPlaylistsPfadSort, aFilename, 0, AllPlaylistsPfadSort.Count-1) > -1;
end;
function TMedienBibliothek.GetAudioFileWithFilename(aFilename: UnicodeString): TAudioFile;
var idx: Integer;
begin
  idx := binaersuche(Mp3ListePfadSort,ExtractFileDir(aFilename), ExtractFileName(aFilename),0,Mp3ListePfadSort.Count-1);
  if idx = -1 then
    result := Nil
  else
    result := Mp3ListePfadSort[idx];
end;

// GenerateCoverListFromSearchResult
// Fill the CoverViewList with matching Covers
procedure TMedienBibliothek.GenerateCoverCategoryFromSearchresult(
  Source: TAudioFileList);
var
  i: Integer;
  aRoot: tRootCollection;
begin
  if Source.Count < 1 then
    exit;

  CoverSearchCategory.Clear;
  aRoot := CoverSearchCategory.AddRootCollection(NempOrganizerSettings.CoverFlowRootCollectionConfig);
  aRoot.MissingCoverMode := MissingCoverMode;
  for i := 0 to Source.Count - 1 do
    CoverSearchCategory.AddAudioFile(Source[i]);

  CoverSearchCategory.AnalyseCollections(True);
  CoverSearchCategory.SortCollections(True);
end;


procedure TMedienBibliothek.SetBaseMarkerList(aList: TAudioFileList);
begin
    if limitMarkerToCurrentFiles then
        BaseMarkerList := aList
    else
        BaseMarkerList := Mp3ListePfadSort;
end;

{
    --------------------------------------------------------
    ReBuildBrowseLists
    - used when user changes the criteria for browsing
      (e.g. from Artist-Album to Directory-Artist
    --------------------------------------------------------
}
Procedure TMedienBibliothek.ReBuildBrowseLists;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(False));
end;


function TMedienBibliothek.IsAutoSortWanted: Boolean;
begin
    result := AlwaysSortAnzeigeList
          And
          ( (AnzeigeListe.Count {+ AnzeigeListe2.Count} < 5000) or (Not SkipSortOnLargeLists));
end;


function TMedienBibliothek.AnzeigeShowsPlaylistFiles: Boolean;
begin
  result := DisplayContent = DISPLAY_BrowsePlaylist;
end;
{
    --------------------------------------------------------
    GenerateAnzeigeListe
    - GetTitelList with Target=Anzeigeliste
    (has gone a little complicated since allowing webradio and playlists there...)
    --------------------------------------------------------
}

procedure TMedienBibliothek.GenerateAnzeigeListe(aCollection: TAudioCollection);
var
  i: Integer;
begin
  LastBrowseResultList.Clear;
  AnzeigeListe := LastBrowseResultList;
  SetBaseMarkerList(LastBrowseResultList);

  if not assigned(aCollection) then begin
    // Show everything, needed only in "AuswahlForm.OnClose"
    BibSearcher.GetNewEmptyListMessage(elmSearch);
    DisplayContent := DISPLAY_BrowseFiles;
    for i := 0 to mp3ListePfadSort.Count - 1 do
      AnzeigeListe.Add(mp3ListePfadSort[i]);
    if IsAutoSortWanted then
      SortAnzeigeliste;
  end else
  begin
    aCollection.GetFiles(AnzeigeListe, True);

    case aCollection.CollectionClass of
      ccFiles: begin
        BibSearcher.GetNewEmptyListMessage(elmCategory);
        DisplayContent := DISPLAY_BrowseFiles;
        if IsAutoSortWanted then
          SortAnzeigeliste;
      end;
      ccPlaylists: begin
        CurrentAudioFile := Nil;
        BibSearcher.GetNewEmptyListMessage(elmPlaylist);
        DisplayContent := DISPLAY_BrowsePlaylist;
      end;
      ccWebStations: begin  // nothing to do, there are no files to display at all.
        CurrentAudioFile := Nil;
        BibSearcher.GetNewEmptyListMessage(elmTitle);
      end;
    end;
  end;

  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
end;

procedure TMedienBibliothek.GenerateReverseAnzeigeListe(aCollection: TAudioCollection);
var
  afc: TAudioFileCollection;
begin
  if (aCollection is TAudioFileCollection) then begin
    afc := TAudioFileCollection(aCollection);

    LastBrowseResultList.Clear;
    AnzeigeListe := LastBrowseResultList;
    SetBaseMarkerList(LastBrowseResultList);

    afc.GetReverseFiles(AnzeigeListe);
    if IsAutoSortWanted then
      SortAnzeigeliste;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
  end;
end;

procedure TMedienBibliothek.GenerateAlbumAnzeigeListe(aAudioFile: TAudioFile);
begin
  LastBrowseResultList.Clear;
  AnzeigeListe := LastBrowseResultList;
  SetBaseMarkerList(LastBrowseResultList);
  GetAlbumTitelListFromAudioFile(AnzeigeListe, aAudioFile);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
end;

procedure TMedienBibliothek.GetAlbumTitelListFromAudioFile(Target: TAudioFileList; aAudioFile: TAudioFile);
var
  SourceAlbumKey: String;
begin
  if not assigned(aAudioFile) then
    exit;

  SourceAlbumKey := GenerateAlbumKey(aAudioFile);
  for var i: Integer := 0 to Mp3ListePfadSort.Count - 1 do begin
    if GenerateAlbumKey(Mp3ListePfadSort[i]) = SourceAlbumKey then
      Target.Add(Mp3ListePfadSort[i]);
  end;

  Target.Sort(Sort_AlbumTrack_asc);
end;

{
    --------------------------------------------------------
    GetTitelListFromCoverIDUnsorted
    - Same result as above, but can be used when NOT in Coverflow mode by the DetailForm when changing Library-Cover
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetTitelListFromCoverIDUnsorted(Target: TAudioFileList; aCoverID: String);
var i: Integer;
begin
  // war: Mp3ListeArtistSort
    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        if Mp3ListePfadSort[i].CoverID = aCoverID then
            Target.Add(Mp3ListePfadSort[i]);
    end;
end;

procedure TMedienBibliothek.GetTitelListFromDirectoryUnsorted(Target: TAudioFileList; aDirectory: String);
var i: Integer;
begin
    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        if Mp3ListePfadSort[i].Ordner = aDirectory then
            Target.Add(Mp3ListePfadSort[i]);
    end;
end;

function TMedienBibliothek.GetAudioFileWithCoverID(aCoverID: String): TAudioFile;
var i: Integer;
begin
  result := Nil;
  for i := 0 to Mp3ListePfadSort.Count - 1 do
  begin
    if Mp3ListePfadSort[i].CoverID = aCoverID then
    begin
      result := Mp3ListePfadSort[i];
      break;
    end;
  end;
end;


procedure TMedienBibliothek.RestoreAnzeigeListeAfterQuicksearch;
begin
    AnzeigeListe := LastBrowseResultList;
    SetBaseMarkerList(LastBrowseResultList);
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0);
end;

{
    --------------------------------------------------------
    GlobalQuickSearch
    CompleteSearch
    - Search for files in the library.
    --------------------------------------------------------
}
procedure TMedienBibliothek.GlobalQuickSearch(Keyword: UnicodeString; AllowErr: Boolean);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.GlobalQuickSearch(Keyword, AllowErr);
    LeaveCriticalSection(CSUpdate);
end;
procedure TMedienBibliothek.CompleteSearch(Keywords: TSearchKeyWords);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.CompleteSearch(KeyWords);
    LeaveCriticalSection(CSUpdate);
end;
procedure TMedienBibliothek.CompleteSearchNoSubStrings(Keywords: TSearchKeyWords);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.CompleteSearchNoSubStrings(KeyWords);
    LeaveCriticalSection(CSUpdate);
end;


procedure TMedienBibliothek.IPCSearch(Keyword: UnicodeString);
begin
    if StatusBibUpdate >= 2 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.IPCQuickSearch(Keyword);
    LeaveCriticalSection(CSUpdate);
end;

procedure TMedienBibliothek.GlobalQuickTagSearch(KeyTag: UnicodeString);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.GlobalQuickTagSearch(KeyTag);
    LeaveCriticalSection(CSUpdate);
end;

procedure TMedienBibliothek.QuickSearchShowAllFiles;
begin
    if StatusBibUpdate >= 2 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.ShowAllFiles;
    LeaveCriticalSection(CSUpdate);
end;

procedure TMedienBibliothek.EmptySearch(Mode: Integer);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.EmptySearch(Mode);
    LeaveCriticalSection(CSUpdate);
end;
procedure TMedienBibliothek.ShowMarker(aIndex: Byte);
begin
    if StatusBibUpdate >= 2 then exit;
    if Count = 0 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.SearchMarker(aIndex, BaseMarkerList);
    LeaveCriticalSection(CSUpdate);
end;

{
    --------------------------------------------------------
    GetFilesInDir
    - Get all files in the library within the given directory
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetFilesInDir(aDirectory: UnicodeString; ClearExistingView: Boolean);
var i: Integer;
    tmpList: TObjectList;
begin
  if StatusBibUpdate >= 2 then exit;
  EnterCriticalSection(CSUpdate);

  if AnzeigeShowsPlaylistFiles then
      MessageDLG((Medialibrary_GUIError1), mtError, [MBOK], 0)
  else
  begin
      tmpList := TObjectList.Create(False);
      try
          if not ClearExistingView then
          begin
              // add currently listed files to the tmpList
              for i := 0 to AnzeigeListe.Count - 1 do
                  tmpList.Add(AnzeigeListe[i]);
          end;

          for i := 0 to Mp3ListePfadSort.Count-1 do
              if Mp3ListePfadSort[i].Ordner = aDirectory then
                  tmpList.Add(Mp3ListePfadSort[i]);

          SendMessage(MainWindowHandle, WM_MedienBib, MB_ShowSearchResults, lParam(tmpList));
      finally
          tmpList.Free;
      end;
  end;

  LeaveCriticalSection(CSUpdate);
end;

{
    --------------------------------------------------------
    AddSorter
    - Add new/modify first element of SortParams: Array[0..SORT_MAX] of TCompareRecord;
    --------------------------------------------------------
}
procedure TMedienBibliothek.AddSorter(TreeHeaderColumnTag: Integer; FlipSame: Boolean = True);
var NewSortMethod: TAudioFileCompare;
    i: Integer;
begin
    case TreeHeaderColumnTag of
        colIdx_ARTIST              : NewSortMethod := AFCompareArtist;
        colIdx_ALBUMARTIST         : NewSortMethod := AFCompareAlbumArtist;
        colIdx_COMPOSER            : NewSortMethod := AFCompareComposer;
        colIdx_TITLE               : NewSortMethod := AFCompareTitle;
        colIdx_ALBUM               : NewSortMethod := AFCompareAlbum;
        colIdx_DURATION            : NewSortMethod := AFCompareDuration;
        colIdx_BITRATE             : NewSortMethod := AFCompareBitrate;
        colIdx_CBRVBR              : NewSortMethod := AFCompareCBR;
        colIdx_ChannelMode         : NewSortMethod := AFCompareChannelMode;
        colIdx_SAMPLERATE          : NewSortMethod := AFCompareSamplerate;
        colIdx_COMMENT             : NewSortMethod := AFCompareComment;
        colIdx_FILESIZE            : NewSortMethod := AFCompareFilesize;
        colIdx_FILEAGE             : NewSortMethod := AFCompareFileAge;
        colIdx_Path                : NewSortMethod := AFComparePath;
        colIdx_Directory           : NewSortMethod := AFCompareDirectory;
        colIdx_Filename            : NewSortMethod := AFCompareFilename;
        colIdx_Extension           : NewSortMethod := AFCompareExtension;
        colIdx_YEAR                : NewSortMethod := AFCompareYear;
        colIdx_GENRE               : NewSortMethod := AFCompareGenre;
        colIdx_Lyrics              : NewSortMethod := AFCompareLyricsExists;
        colIdx_TRACK               : NewSortMethod := AFCompareTrackNr;
        colIdx_RATING              : NewSortMethod := AFCompareRating;
        colIdx_PLAYCOUNTER         : NewSortMethod := AFComparePlayCounter;
        colIdx_LastFMTags          : NewSortMethod := AFCompareLastFMTagsExists;
        colIdx_CD                  : NewSortMethod := AFCompareCD;
        colIdx_Marker              : NewSortMethod := AFCompareFavorite;
        colIdx_TRACKGAIN           : NewSortMethod := AFCompareTrackGain;
        colIdx_ALBUMGAIN           : NewSortMethod := AFCompareAlbumGain;
        colIdx_TRACKPEAK           : NewSortMethod := AFCompareTrackPeak;
        colIdx_ALBUMPEAK           : NewSortMethod := AFCompareAlbumPeak;
        colIdx_BPM                 : NewSortMethod := AFCompareBPM;
    else
        NewSortMethod := AFComparePath;
    end;

    if (TreeHeaderColumnTag = SortParams[0].Tag) and FlipSame then
    begin
         // flip SortDirection of primary sorter
        case SortParams[0].Direction of
             sd_Ascending: SortParams[0].Direction := sd_Descending;
             sd_Descending: SortParams[0].Direction := sd_Ascending;
        end;
    end else
    begin
        // Set new primary sorter
        for i := SORT_MAX downto 1 do
        begin
            SortParams[i].Comparefunction := Sortparams[i-1].Comparefunction;
            SortParams[i].Direction := SortParams[i-1].Direction;
            SortParams[i].Tag := SortParams[i-1].Tag
        end;
        Sortparams[0].Comparefunction := NewSortmethod;
        Sortparams[0].Direction := sd_Ascending;
        Sortparams[0].Tag := TreeHeaderColumnTag;
    end;
end;

procedure TMedienBibliothek.ChangeSortDirection(NewDirection: teSortDirection);
begin
  SortParams[0].Direction := NewDirection;
  SortParams[1].Direction := NewDirection;
  SortParams[2].Direction := NewDirection;
end;

procedure TMedienBibliothek.AddStartJob(aJobtype: TJobType; aJobParam: String);
var newJob: TStartJob;
begin
    newJob := TStartJob.Create(aJobType, aJobParam);
    fJobList.Add(newJob);
end;

procedure TMedienBibliothek.ProcessNextStartJob;
var nextJob: TStartJob;
begin
    if (fJobList.Count > 0) AND (not CloseAfterUpdate) then
    begin
        nextJob := fJoblist[0];
        case nextJob.Typ of
          JOB_LoadLibrary:        ; // nothing to do
          JOB_AutoScanNewFiles    : PostMessage(MainWindowHandle, WM_MedienBib, MB_StartAutoScanDirs, 0) ;
          JOB_AutoScanMissingFiles: PostMessage(MainWindowHandle, WM_MedienBib, MB_StartAutoDeleteFiles, 0) ;
          JOB_StartWebServer      : PostMessage(MainWindowHandle, WM_MedienBib, MB_ActivateWebServer, 0) ;
          JOB_Finish              : begin
                // set the status to "free" (=0)
                SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
                // if there are more jobs to do (should not happen) process the next jobs as well
                if fJobList.Count > 1 then
                    PostMessage(MainWindowHandle, WM_MedienBib, MB_CheckForStartJobs, 0);
                    // !!! do NOT use *SEND*message here
          end;
        end;
        fJoblist.Delete(0);
    end;
end;

procedure TMedienBibliothek.SortAnzeigeListe;
begin
  AnzeigeListe.Sort(MainSort);
  AnzeigeListIsCurrentlySorted := True;
end;


{
    --------------------------------------------------------
    CheckYearRange
    CheckRating
    CheckLength
    CheckTags
    - Helper for FillRandomList
    --------------------------------------------------------
}
function TMedienBibliothek.CheckYearRange(Year: UnicodeString): Boolean;
var intYear: Integer;
begin
  result := False;
  if PlaylistFillOptions.SkipYearCheck then
    result := true
  else
  begin
    intYear := strtointdef(Year,-1);
    if (intYear >= PlaylistFillOptions.MinYear)
       AND (intYear <= PlaylistFillOptions.MaxYear) then
    result := True;
  end;
end;

function TMedienBibliothek.CheckRating(aRating: Byte): Boolean;
begin
    if aRating = 0 then arating := 128;
    Case PlaylistFillOptions.RatingMode of
        0: result := true;
        1: result := aRating >= PlaylistFillOptions.Rating;
        2: result := aRating = PlaylistFillOptions.Rating;
        3: result := aRating <= PlaylistFillOptions.Rating;
    else
        result := False;
    end;
end;

function TMedienBibliothek.CheckLength(aLength: Integer): Boolean;
begin
    result := ((Not PlaylistFillOptions.UseMinLength) or (aLength >= PlaylistFillOptions.MinLength))
            AND
             ((Not PlaylistFillOptions.UseMaxLength) or (aLength <= PlaylistFillOptions.MaxLength))
end;

function TMedienBibliothek.CheckTags(aAudioFile: TAudioFile): Boolean;
var i, c: Integer;
  AutoTags, LastFMTags, UniqueTags: TStringList;
begin
  if PlaylistFillOptions.SkipTagCheck or (not assigned(PlaylistFillOptions.WantedTags)) then
    result := true
  else
  begin
    AutoTags := TStringList.Create;
    LastFMTags := TStringList.Create;
    UniqueTags := TStringList.Create;
    try
      aAudioFile.GetAllTags(AutoTags, LastFMTags);
      UniqueTags.Sorted := True;
      UniqueTags.Duplicates := dupIgnore;
      for i := 0 to AutoTags.Count - 1 do
        UniqueTags.Add(Autotags[i]);
      for i := 0 to LastFMTags.Count - 1 do
        UniqueTags.Add(LastFMTags[i]);

      c := 0;
      for i := 0 to PlaylistFillOptions.WantedTags.Count - 1 do begin
        if UniqueTags.IndexOf(PlaylistFillOptions.WantedTags[i]) >= 0 then
          inc(c);
      end;
      result := c >= PlaylistFillOptions.MinTagMatchCount;
    finally
      AutoTags.Free;
      LastFMtags.Free;
      UniqueTags.Free;
    end;
  end;
end;

function TMedienBibliothek.CheckCategory(aAudioFile: TAudioFile): Boolean;
begin
  if not PlaylistFillOptions.CheckCategory then
    result := True
  else
    result := (aAudioFile.IsCategory(PlaylistFillOptions.CategoryIdx))
end;

{
    --------------------------------------------------------
    FillRandomList
    - Generate a Random list from the library
    --------------------------------------------------------
}
procedure TMedienBibliothek.FillRandomList(aList: TAudioFileList);
var sourceList, tmpFileList: TAudioFileList;
    i: Integer;
    aAudioFile: TAudioFile;
begin
    EnterCriticalSection(CSUpdate);

    case PlaylistFillOptions.SelectionRange of
      rprLibrary,
      rprCategory: SourceList := Mp3ListePfadSort;
      rprView: SourceList := AnzeigeListe;
    else
      SourceList := Mp3ListePfadSort;
    end;

    PlaylistFillOptions.CheckCategory := PlaylistFillOptions.SelectionRange = rprCategory;
    if assigned(CurrentCategory) and (CurrentCategory.CategoryType = ccFiles) then
      PlaylistFillOptions.CategoryIdx := CurrentCategory.Index
    else begin
      if assigned(DefaultFileCategory) then
        PlaylistFillOptions.CategoryIdx := DefaultFileCategory.Index
      else
        PlaylistFillOptions.CheckCategory := False; // Something is wrong with categories: Skip check
    end;

    // passende Stücke zusammensuchen
    tmpFileList := TAudioFileList.Create(False);
    try
        for i := 0 to SourceList.Count - 1 do
        begin
            aAudioFile := SourceList[i];
            if CheckYearRange(aAudioFile.Year)
                //and CheckGenrePL(aAudioFile.Genre)
                and CheckCategory(aAudioFile)
                and CheckRating(aAudioFile.Rating)
                and CheckLength(aAudioFile.Duration)
                and CheckTags(aAudioFile)
                then
              tmpFileList.Add(aAudioFile);
        end;
        // Liste mischen
        for i := 0 to tmpFileList.Count-1 do
            tmpFileList.Exchange(i,i + random(tmpFileList.Count-i));
        // Überflüssiges löschen
        For i := tmpFileList.Count - 1 downto PlaylistFillOptions.MaxCount do
            tmpFileList.Delete(i);

        // eigentliche Zielliste mit Kopien füllen
        for i := 0 to tmpFileList.Count-1 do
            tmpFileList[i].AddCopyToList(aList);
    finally
        tmpFileList.Free;
    end;

  LeaveCriticalSection(CSUpdate);
end;

procedure TMedienBibliothek.FillListWithMedialibrary(aList: TAudioFileList);
var sourceList: TAudioFileList;
    i: Integer;
begin
    EnterCriticalSection(CSUpdate);
    SourceList := Mp3ListePfadSort;
    for i := 0 to SourceList.Count - 1 do
        aList.Add(SourceList[i]);
    LeaveCriticalSection(CSUpdate);
end;

{
    --------------------------------------------------------
    ScanListContainsParentDir
    ScanListContainsSubDirs
    JobListContainsNewDirs
    - Helper for AutoScan-Lists
    --------------------------------------------------------
}
function TMedienBibliothek.ScanListContainsParentDir(NewDir: UnicodeString): UnicodeString;
var i: Integer;
begin
  result := '';
  for i := 0 to AutoScanDirList.Count - 1 do
  begin
    if AnsiStartsText(
        IncludeTrailingPathDelimiter(AutoScanDirList.Strings[i]), IncludeTrailingPathDelimiter(NewDir))  then
    begin
      result := AutoScanDirList.Strings[i];
      break;
    end;
  end;
end;
function TMedienBibliothek.ScanListContainsSubDirs(NewDir: UnicodeString): UnicodeString;
var i: Integer;
begin
  result := '';
  for i := AutoScanDirList.Count - 1 downto 0 do
  begin
    if AnsiStartsText(IncludeTrailingPathDelimiter(NewDir), IncludeTrailingPathDelimiter(AutoScanDirList.Strings[i]))  then
    begin
      result := result + #13#10 + AutoScanDirList.Strings[i];
      AutoScanDirList.Delete(i);
    end;
  end;
end;
Function TMedienBibliothek.JobListContainsNewDirs(aJobList: TStringList): Boolean;
var i: integer;
begin
  result := False;
  for i := 0 to aJobList.Count - 1 do
    if AutoScanDirList.IndexOf(IncludeTrailingPathDelimiter(aJobList.Strings[i])) = -1 then
    begin
      result := True;
      break;
    end;
end;

{
    --------------------------------------------------------
    ReSynchronizeDrives
    - Resync drives when new devices connects to the PC
    Note: This method runs in VCL-Thread.
       It MUST NOT be called when an update is running!
       If Windows send the message "New Drive" and an update is running,
       a counter will be increased, which is checked at the end of
       the update-process
    --------------------------------------------------------
}
function TMedienBibliothek.ReSynchronizeDrives: Boolean;
begin
    if Not TDriveManager.EnableUSBMode then
        result := false
    else
    begin
        EnterCriticalSection(CSAccessDriveList);
        fDriveManager.ReSynchronizeDrives;
        fPlaylistDriveManager.ReSynchronizeDrives;
        // relavant is only the "main" DriveManager later.
        // if a currently loaded PlaylistFile has changed: Just load it again by clicking it another time
        result := fDriveManager.DrivesHaveChanged;
        LeaveCriticalSection(CSAccessDriveList);
    end;
end;
{
    --------------------------------------------------------
    RepairDriveCharsAtAudioFiles
    RepairDriveCharsAtPlaylistFiles
    - Change all AudioFiles according to the new situation
    --------------------------------------------------------
}
procedure TMedienBibliothek.RepairDriveCharsAtAudioFiles;
var
  i: Integer;
begin
    EnterCriticalSection(CSAccessDriveList);
    fDrivemanager.RepairDriveCharsAtAudioFiles(Mp3ListePfadsort);
    for i := 0 to FileCategories.Count - 1  do
      FileCategories[i].RepairDriveChars(fDrivemanager);
    LeaveCriticalSection(CSAccessDriveList);
    // am Ende die Pfadsort-Liste neu sortieren
    Mp3ListePfadsort.Sort(Sort_Pfad_asc);
end;

procedure TMedienBibliothek.RepairDriveCharsAtPlaylistFiles;
var
  i: Integer;
begin
    EnterCriticalSection(CSAccessDriveList);
    fDriveManager.RepairDriveCharsAtPlaylistFiles(AllPlaylistsPfadSort);
    for i := 0 to PlaylistCategories.Count - 1  do
      PlaylistCategories[i].RepairDriveChars(fDrivemanager);
    LeaveCriticalSection(CSAccessDriveList);
    // am Ende die Pfadsort-Liste neu sortieren
    AllPlaylistsPfadSort.Sort(SortPlaylists_Path);
end;

{
    --------------------------------------------------------
    ExportFavorites
    ImportFavorites
    AddRadioStation
    - Managing webradio in the library
    --------------------------------------------------------
}
procedure TMedienBibliothek.ExportFavorites(aFilename: UnicodeString);
var fs: TMemoryStream;
    ini: TMemIniFile;
    i, c: Integer;
begin
    if AnsiLowerCase(ExtractFileExt(aFilename)) = '.pls' then
    begin
        //save as pls Playlist-File
        ini := TMeminiFile.Create(aFilename);
        try
            ini.Clear;
            for i := 0 to RadioStationList.Count - 1 do
            begin
                ini.WriteString ('playlist', 'File'  + IntToStr(i+1), TStation(RadioStationList[i]).URL);
                ini.WriteString ('playlist', 'Title'  + IntToStr(i+1), TStation(RadioStationList[i]).Name);
                ini.WriteInteger ('playlist', 'Length'  + IntToStr(i+1), -1);
            end;
            ini.WriteInteger('playlist', 'NumberOfEntries', RadioStationList.Count);
            ini.WriteInteger('playlist', 'Version', 2);
            try
                Ini.UpdateFile;
            except
                on E: Exception do
                    MessageDLG(E.Message, mtError, [mbOK], 0);
            end;
      finally
          ini.Free
      end;

    end
    else
    if AnsiLowerCase(ExtractFileExt(aFilename)) = '.nwl' then
    begin
        fs := TMemoryStream.Create;
        try
            c := RadioStationList.Count;
            fs.Write(c, SizeOf(c));
            for i := 0 to c-1 do
                TStation(RadioStationList[i]).SaveToStream(fs);
            try
                fs.SaveToFile(aFilename);
            except
                on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
            end;
        finally
            fs.Free;
        end;
    end;
end;
procedure TMedienBibliothek.ImportFavorites(aFilename: UnicodeString);
var fs: TMemoryStream;
    ini: TMemIniFile;
    NumberOfEntries, i: Integer;
    newURL, newName: String;
    NewStation: TStation;
begin
    if AnsiLowerCase(ExtractFileExt(aFilename)) = '.pls' then
    begin
        ini := TMeminiFile.Create(aFilename);
        try
            NumberOfEntries := ini.ReadInteger('playlist','NumberOfEntries',-1);
            for i := 1 to NumberOfEntries do
            begin
                newURL := ini.ReadString('playlist','File'+ IntToStr(i),'');
                if newURL = '' then continue;

                if GetAudioTypeFromFilename(newURL) = at_Stream then
                begin
                    NewStation := TStation.Create(MainWindowHandle);
                    NewStation.URL := newURL;
                    newName := ini.ReadString('playlist','Title'+ IntToStr(i),'');
                    NewStation.Name := NewName;
                    RadioStationList.Add(NewStation);
                end;
            end;
        finally
            ini.free;
        end;
    end else
    if AnsiLowerCase(ExtractFileExt(aFilename)) = '.nwl' then
    begin
        fs := TMemoryStream.Create;
        try
            fs.LoadFromFile(aFilename);
            fs.Position := 0;
            LoadRadioStationsFromStream_DEPRECATED(fs);
            Changed := True;
        finally
            fs.Free;
        end;
    end;
end;
{
    --------------------------------------------------------
    AddRadioStation
    Note: Station gets a new Handle for Messages here.
    --------------------------------------------------------
}
function TMedienBibliothek.AddRadioStation(aStation: TStation): Integer;
var newStation: TStation;
    i, maxIdx: Integer;

begin
    maxIdx := -1;
    for i := 0 to RadioStationList.Count - 1 do
        if TSTation(RadioStationList[i]).SortIndex > maxIdx  then
            maxIdx := TSTation(RadioStationList[i]).SortIndex;
    inc(maxIdx);

    newStation := TStation.Create(MainWindowHandle);
    newStation.Assign(aStation);
    newStation.SortIndex := maxIdx;
    RadioStationList.Add(NewStation);
    //WebRadioCategory.AddStation(NewStation);
    Changed := True;
    result := maxIdx;
end;

{
    --------------------------------------------------------
    SaveAsCSV
    - Save the library in a *.csv-File
    Note: Only Audiofiles are saved,
       No Playlists,
       No Webradio stations
    --------------------------------------------------------
}
function TMedienBibliothek.SaveAsCSV(aFilename: UnicodeString): boolean;
var i: integer;
  tmpStrList : TStringList;
begin
  if StatusBibUpdate >= 2 then
  begin
    result := False;
    exit;
  end;
  result := true;
  EnterCriticalSection(CSUpdate);
  tmpStrList := TStringList.Create;
  try
      tmpstrList.Capacity := Mp3ListePfadSort.Count + 1;
      tmpStrList.Add(cCSVHeader);
      for i:= 0 to Mp3ListePfadSort.Count - 1 do
        tmpstrList.Add(NempDisplay.CSVLine(Mp3ListePfadSort[i]));
      try
          tmpStrList.SaveToFile(aFileName, TEnCoding.UTF8);
      except
          on E: Exception do
          begin
              MessageDLG(E.Message, mtError, [mbOK], 0);
              result := False;
          end;
      end;
  finally
      FreeAndNil(tmpStrList);
  end;
  LeaveCriticalSection(CSUpdate);
end;


{
    --------------------------------------------------------
    LoadDrivesFromStream
    SaveDrivesToStream
    - Read/Write a List of TDrives
    --------------------------------------------------------
}
function TMedienBibliothek.LoadDrivesFromStream_DEPRECATED(aStream: TStream): Boolean;
var SavedDriveList: TDriveList;
    DriveCount, i: Integer;
    newDrive: TDrive;
begin
    result := True;
    SavedDriveList := TDriveList.Create;
    try
        aStream.Read(DriveCount, SizeOf(Integer));
        for i := 0 to DriveCount - 1 do
        begin
            newDrive := TDrive.Create;
            newDrive.LoadFromStream_DEPRECATED(aStream);
            SavedDriveList.Add(newDrive);
        end;
        // Daten synchronisieren
        EnterCriticalSection(CSAccessDriveList);
            fDriveManager.SynchronizeDrives(SavedDriveList);
        LeaveCriticalSection(CSAccessDriveList);
    finally
        SavedDriveList.Free;
    end;
end;

function TMedienBibliothek.LoadDrivesFromStream(aStream: TStream): Boolean;
var SavedDriveList: TDriveList;
begin
    result := True;
    EnterCriticalSection(CSAccessDriveList);
    SavedDriveList := TDriveList.Create(True);
    try
        fDriveManager.LoadDrivesFromStream(aStream, SavedDriveList);
        // we do not allow "add Library to Library", so we can just synch the Loaded Dirves into
        // the (empty) list of ManagedDrives there
        fDrivemanager.SynchronizeDrives(SavedDriveList);
    finally
        SavedDriveList.Free;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;


procedure TMedienBibliothek.SaveDrivesToStream(aStream: TStream);
var len: Integer;
    MainID: Byte;
    BytesWritten: LongInt;
    SizePosition, EndPosition: Int64;
begin
    MainID := MP3DB_BLOCK_DRIVES;
    aStream.Write(MainID, SizeOf(Byte));
    len := 42; // dummy, needs to be corrected later
    SizePosition := aStream.Position;
    aStream.Write(len, SizeOf(Integer));

    // save the Drives from DriveManager into the Stream
    EnterCriticalSection(CSAccessDriveList);
    fDriveManager.SaveDrivesToStream(aStream);
    LeaveCriticalSection(CSAccessDriveList);

    // correct the size information for this block
    EndPosition := aStream.Position;
    aStream.Position := SizePosition;

    BytesWritten := EndPosition - SizePosition;
    aStream.Write(BytesWritten, SizeOf(BytesWritten));
    // seek to the end position again
    aStream.Position := EndPosition;
end;
{
    --------------------------------------------------------
    LoadAudioFilesFromStream
    SaveAudioFilesToStream
    - Read/Write a List of TAudioFiles
    --------------------------------------------------------
}
function TMedienBibliothek.LoadAudioFilesFromStream(aStream: TStream): Boolean;
var FilesCount, i: Integer;
    newAudioFile: TAudioFile;
begin
    result := True;

    aStream.Read(FilesCount, SizeOf(FilesCount));
    for i := 1 to FilesCount do
    begin
        // create a new Audiofile object and read the data from the stream
        newAudioFile := TAudioFile.Create;
        newAudioFile.LoadDataFromStream(aStream, False, True);
        // add the file to the update list
        UpdateList.Add(newAudioFile);
    end;

    // adjust paths of the AudioFiles. Needs to be done in VCL-Thread due to Relative Paths
    SendMessage(MainWindowHandle, WM_MedienBib, MB_FixAudioFilePaths, 0);
end;

procedure TMedienBibliothek.ProcessLoadedFilenames;
var i: Integer;
    newAudioFile: TAudioFile;
    currentDriveID: Integer;
    CurrentDriveChar: Char;
begin
    EnterCriticalSection(CSAccessDriveList);

    CurrentDriveChar := ' ';
    currentDriveID := -2;

    for i := 0 to UpdateList.Count-1 do
    begin
        newAudioFile := UpdateList[i];
        if newAudioFile.AudioType = at_File then
            newAudioFile.Pfad := ExpandFilename(newAudioFile.Pfad);

        ///  New method since version 4.14
        ///  Nemp will save only relative Paths, if LibrayrFile and AudioFile are on the same
        ///  Drive.
        ///  If USBMode is enabled, and the loaded PlaylistFile wasn't stored as a relative Path: DO adjust Drive letter
        ///  Otherwise: DO NOT adjust the Drive Letter
        if TDriveManager.EnableUSBMode and (newAudioFile.DriveID <> -5) then
        begin
            // now assign a proper drive letter, according to the DriveID of the audiofile
            if currentDriveID <> newAudioFile.DriveID then
            begin
                // currentDriveChar does not match, we need to find the correct one
                if newAudioFile.DriveID <= -1 then
                    CurrentDriveChar := '\'
                else
                begin
                    if newAudioFile.DriveID < fDriveManager.ManagedDrivesCount then
                        CurrentDriveChar := fDriveManager.GetManagedDriveByIndex(newAudioFile.DriveID).Drive[1]
                end;
                // anyway, we've got a new ID here, and we can set the next drive with this ID faster
                currentDriveID := newAudioFile.DriveID;
            end;
            // now *actually* assign the proper drive letter ;-)
            newAudioFile.SetNewDriveChar(CurrentDriveChar);
        end;
    end;

    LeaveCriticalSection(CSAccessDriveList);
end;

function TMedienBibliothek.LoadAudioFilesFromStream_DEPRECATED(aStream: TStream; MaxSize: Integer): Boolean;
var FilesCount, i, DriveID: Integer;
    newAudioFile: TAudioFile;
    ID: Byte;
    CurrentDriveChar: WideChar;

begin
    EnterCriticalSection(CSAccessDriveList);

    result := True;
    CurrentDriveChar := 'C';
    aStream.Read(FilesCount, SizeOf(FilesCount));

    for i := 1 to FilesCount do
    begin
        aStream.Read(ID, SizeOf(ID));
        case ID of
            0: begin
                newAudioFile := TAudioFile.Create;
                {audioSize := }newAudioFile.LoadSizeInfoFromStream_DEPRECATED(aStream);
                newAudioFile.LoadDataFromStream_DEPRECATED(aStream);
                newAudioFile.SetNewDriveChar(CurrentDriveChar);
                UpdateList.Add(newAudioFile);
            end;
            1: begin
                // LaufwerksID lesen, diese suchen, LW-Buchstaben auslesen.
                aStream.Read(DriveID, SizeOf(DriveID));
                // DriveID ist der index des Laufwerks in der fDrives-Liste
                if DriveID < fDriveManager.ManagedDrivesCount then  // fUsedDrives.Count then
                begin
                    aStream.Read(ID, SizeOf(ID));  // this  ID=0 is just the marker as ID=0 used in this CASE-loop
                    if ID <> 0 then
                    begin
                        SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                                        #13#10 + 'invalid audiofile data' +
                                        #13#10 + 'DriveID: ID <> 0' )));
                        result := False;
                        LeaveCriticalSection(CSAccessDriveList);
                        exit;
                    end;
                    if DriveID = -1 then
                        CurrentDriveChar := '\'
                    else
                        CurrentDriveChar := fDriveManager.GetManagedDriveByIndex(DriveID).Drive[1];
                        // CurrentDriveChar := WideChar(TDrive(fUsedDrives[DriveID]).Drive[1]);
                    newAudioFile := TAudioFile.Create;

                    {audioSize := }newAudioFile.LoadSizeInfoFromStream_DEPRECATED(aStream);
                    newAudioFile.LoadDataFromStream_DEPRECATED(aStream);
                    newAudioFile.SetNewDriveChar(CurrentDriveChar);
                    UpdateList.Add(newAudioFile);
                end else
                begin
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                                        #13#10 + 'invalid audiofile data' +
                                        #13#10 + 'invalid DriveID')));
                    result := False;
                    LeaveCriticalSection(CSAccessDriveList);
                    exit;
                end;
            end;
        else
            SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                    Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                        #13#10 + 'invalid audiofile data' +
                        #13#10 + 'invalid ID' + IntToStr(ID))));
            result := False;
            LeaveCriticalSection(CSAccessDriveList);
            exit;
        end;
    end;

    LeaveCriticalSection(CSAccessDriveList);
end;


procedure TMedienBibliothek.SaveAudioFilesToStream(aStream: TStream; StreamFilename: String);
var i, len: Integer;
    CurrentDriveChar: WideChar;
    aAudioFile: TAudioFile;
    aDrive: tDrive;
    MainID: Byte;
    FileCount, currentDriveID: Integer;
    BytesWritten: LongInt;
    SizePosition, EndPosition: Int64;
    ERROROCCURRED, DoMessageShow: Boolean;
    LibrarySaveDriveChar: Char;
    AudioFileSavePath: String;

begin
    EnterCriticalSection(CSAccessDriveList);

    // write size info before writing actual data
    MainID := MP3DB_BLOCK_FILES;
    aStream.Write(MainID, SizeOf(MainID));
    len := 42; // just a dummy value here. needs to be corrected at the end of this procedure
    SizePosition := aStream.Position;
    aStream.Write(len, SizeOf(len));

    FileCount := Mp3ListePfadSort.Count; // * FAKE_FILES_MULTIPLIER;

    BytesWritten := aStream.Write(FileCount, sizeOf(FileCount));
    CurrentDriveChar := '-';
    currentDriveID := -2;
    // if Length(StreamFilename) > 0 then
    LibrarySaveDriveChar := StreamFilename[1];
    // when we save it on a network drive: Don't use relative paths at all
    if LibrarySaveDriveChar = '\' then
        LibrarySaveDriveChar := '-';

    DoMessageShow := True;

    ///  New saving method since Nemp 4.14
    ///  (1) If an AudioFile is on the same local Drive than the LibraryFile (parameter StreamFilename),
    ///      then we save the RELATIVE path to the AudioFile. In that case, we also use an invalid DriveID
    ///      for it, as the LoadFromStream method MUST NOT "fix" the Drive Letter later.
    ///      (Possible situation: Nemp with the complete music collection is moved to another computer, on
    ///       a different drive with a different ID, into a different base directory)
    ///  (2) If the Audiofiles are on a different Drive, then we use the previous system with "DriveID"
    ///      (= index of the Drive in the DriveList), so that Nemp can fix the DriveLetter after loading.
    ///      Possible situation for this: External HardDrive with more than one partition used for the
    ///      music collection

    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        ERROROCCURRED := False;
        aAudioFile := MP3ListePfadSort[i];

        if (aAudioFile.Ordner[1] = LibrarySaveDriveChar) and TDrivemanager.EnableCloudMode then
        begin
            aAudioFile.DriveID := -5;
            AudioFileSavePath := ExtractRelativePath(StreamFilename, aAudioFile.Pfad );
        end else
        begin
              // get a Proper DriveID, if the Drive char is different from the previouos file
              if aAudioFile.Ordner[1] <> CurrentDriveChar then
              begin
                  if aAudioFile.Ordner[1] <> '\' then
                  begin
                      // Neues Laufwerk - Infos dazwischenschieben
                      aDrive := fDriveManager.GetManagedDriveByChar(aAudioFile.Ordner[1]);
                      if assigned(aDrive) then
                      begin
                          currentDriveID := aDrive.ID;
                          CurrentDriveChar := aAudioFile.Ordner[1];
                      end else
                      begin
                          if DoMessageShow then
                              MessageDLG((Medialibrary_SaveException1), mtError, [MBOK], 0);
                          DoMessageShow := False;
                          ERROROCCURRED := True;
                      end;
                  end else
                  begin
                      currentDriveID := -1;
                      CurrentDriveChar := aAudioFile.Ordner[1];
                  end;
              end;
              // set the DriveID properly
              aAudioFile.DriveID := currentDriveID;
              AudioFileSavePath := aAudioFile.Pfad;
        end;
        // write the audiofile data into the stream
        if not ERROROCCURRED then
            BytesWritten := BytesWritten + aAudioFile.SaveToStream(aStream, AudioFileSavePath);

    end;

    // correct the size information for this block
    EndPosition := aStream.Position;
    aStream.Position := SizePosition;
    aStream.Write(BytesWritten, SizeOf(BytesWritten));
    // seek to the end position again
    aStream.Position := EndPosition;

    LeaveCriticalSection(CSAccessDriveList);
end;

{
    --------------------------------------------------------
    LoadPlaylistsFromStream
    SavePlaylistsToStream
    - Read/Write a List of Playlist-Files
    --------------------------------------------------------
}
function TMedienBibliothek.LoadPlaylistsFromStream(aStream: TStream): Boolean;
var i, FileCount: Integer;
    NewLibraryPlaylist: TLibraryPlaylist;
begin
    result := True;
    aStream.Read(FileCount, SizeOf(FileCount));
        for i := 1 to FileCount do
        begin
            NewLibraryPlaylist := TLibraryPlaylist.Create;
            NewLibraryPlaylist.LoadFromStream(aStream);
            PlaylistUpdateList.Add(NewLibraryPlaylist);
        end;
        // fix Paths for the Playlists. Needs to be done in VCL-Thread due to Relative Paths
        SendMessage(MainWindowHandle, WM_MedienBib, MB_FixPlaylistFilePaths, 0);
end;

procedure TMedienBibliothek.ProcessLoadedPlaylists;
var i, currentDriveID: Integer;
    CurrentDriveChar: WideChar;

    NewLibraryPlaylist: TLibraryPlaylist;
begin
    EnterCriticalSection(CSAccessDriveList);

    CurrentDriveChar := ' ';
    currentDriveID := -2;

    for i := 0 to PlaylistUpdateList.Count-1 do
    begin
        NewLibraryPlaylist := PlaylistUpdateList[i];
        NewLibraryPlaylist.Path := ExpandFilename(NewLibraryPlaylist.Path);

        // if USBMode is enabled, and the loaded PlaylistFile wasn't stored as a relative Path:
        // adjust Drive letter
        if TDriveManager.EnableUSBMode and (NewLibraryPlaylist.DriveID <> -5) then
        begin
              if currentDriveID <> NewLibraryPlaylist.DriveID then
              begin
                  // currentDriveChar does not match, we need to find the correct one
                  if NewLibraryPlaylist.DriveID <= -1 then
                      CurrentDriveChar := '\'
                  else
                  begin
                      if NewLibraryPlaylist.DriveID < fDriveManager.ManagedDrivesCount then
                          CurrentDriveChar := fDriveManager.GetManagedDriveByIndex(NewLibraryPlaylist.DriveID).Drive[1];
                  end;
                  // anyway, we've got a new ID here, and we can set the next drive with this ID faster
                  currentDriveID := NewLibraryPlaylist.DriveID;
              end;
              // set the proper drive char
              NewLibraryPlaylist.SetNewDriveChar(CurrentDriveChar);
        end;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;

function TMedienBibliothek.LoadPlaylistsFromStream_DEPRECATED(aStream: TStream): Boolean;
var FilesCount, i, DriveID: Integer;
    NewLibraryPlaylist: TLibraryPlaylist;
    ID: Byte;
    CurrentDriveChar: WideChar;
    tmputf8: UTF8String;
    tmpWs: UnicodeString;
    len: Integer;
begin
    EnterCriticalSection(CSAccessDriveList);

    result := True;
    CurrentDriveChar := 'C';
    aStream.Read(FilesCount, SizeOf(FilesCount));
    for i := 1 to FilesCount do
    begin
        aStream.Read(ID, SizeOf(ID));
        case ID of
            0: begin
                aStream.Read(len,sizeof(len));
                setlength(tmputf8, len);
                aStream.Read(PAnsiChar(tmputf8)^,len);
                tmpWs := UTF8ToString(tmputf8);
                tmpWs[1] := CurrentDriveChar;

                NewLibraryPlaylist := TLibraryPlaylist.Create;
                NewLibraryPlaylist.Path := tmpWs;
                PlaylistUpdateList.Add(NewLibraryPlaylist);
            end;
            1: begin
                // LaufwerksID lesen, diese suchen, LW-Buchstaben auslesen.
                aStream.Read(DriveID, SizeOf(DriveID));
                // DriveID ist der index des Laufwerks in der fDrives-Liste
                if DriveID < fDriveManager.ManagedDrivesCount then
                begin
                    aStream.Read(ID, SizeOf(ID));
                    if ID <> 0 then
                    begin
                        //MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'DriveID falsch: ID <> 0'), mtError, [MBOK], 0);
                        SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                                        #13#10 + 'invalid playlist data' +
                                        #13#10 + 'DriveID: ID <> 0' )));
                        result := False;
                        LeaveCriticalSection(CSAccessDriveList);
                        exit;
                    end;
                    if DriveID = -1 then
                        CurrentDriveChar := '\'
                    else
                        CurrentDriveChar := fDriveManager.GetManagedDriveByIndex(DriveID).Drive[1];
                    aStream.Read(len,sizeof(len));
                    setlength(tmputf8, len);
                    aStream.Read(PAnsiChar(tmputf8)^,len);
                    tmpWs := UTF8ToString(tmputf8);
                    tmpWs[1] := CurrentDriveChar;

                    NewLibraryPlaylist := TLibraryPlaylist.Create;
                    NewLibraryPlaylist.Path := tmpWs;
                    PlaylistUpdateList.Add(NewLibraryPlaylist);
                end else
                begin
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                                        #13#10 + 'invalid playlist data' +
                                        #13#10 + 'invalid DriveID' )));
                    result := False;
                    LeaveCriticalSection(CSAccessDriveList);
                    exit;
                end;
            end;
        else
            SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                            Integer(PWideChar(_(Medialibrary_InvalidLibFile) +
                                #13#10 + 'invalid playlist data' +
                                #13#10 + 'invalid ID' )));
            result := False;
            LeaveCriticalSection(CSAccessDriveList);
            exit;
        end;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;
procedure TMedienBibliothek.SavePlaylistsToStream(aStream: TStream; StreamFilename: String);
var i, len, FileCount: Integer;
    MainID: Byte;
    BytesWritten: LongInt;
    SizePosition, EndPosition: Int64;
    NewLibraryPlaylist, existingPL: TLibraryPlaylist;

    LibrarySaveDriveChar: Char;
begin
    EnterCriticalSection(CSAccessDriveList);

    // write block header, with dummy size (write the correct value at the end of this procedure)
    MainID := MP3DB_BLOCK_PLAYLISTS;
    aStream.Write(MainID, SizeOf(MainID));
    len := 42; // dummy size;
    SizePosition := aStream.Position;
    aStream.Write(len, SizeOf(len));

    // write FileCount
    FileCount := AllPlaylistsPfadSort.Count;
    BytesWritten := aStream.Write(FileCount, sizeOf(FileCount));

    LibrarySaveDriveChar := StreamFilename[1];
    // when we save it on a network drive: Don't use relative paths at all
    if LibrarySaveDriveChar = '\' then
        LibrarySaveDriveChar := '-';

    //----------------------------
    // write the actual data
    NewLibraryPlaylist := TLibraryPlaylist.Create;
    try
        for i := 0 to AllPlaylistsPfadSort.Count - 1 do
        begin
            existingPL := AllPlaylistsPfadSort[i];

            if (existingPL.Path[1] = LibrarySaveDriveChar) and TDrivemanager.EnableCloudMode then
            begin
                // write Relative Path
                NewLibraryPlaylist.DriveID := -5;
                NewLibraryPlaylist.Path := ExtractRelativePath(StreamFilename, existingPL.Path);
            end else
            begin
                // write absolute Path
                NewLibraryPlaylist.Path := existingPL.Path;
                if existingPL.Path[1] = '\' then
                    NewLibraryPlaylist.DriveID := -1
                else
                begin

                    //aDrive := fDriveManager.GetManagedDriveByChar(jas.DataString[1]);
                    //if assigned(aDrive) then
                    //    NewLibraryPlaylist.DriveID := aDrive.ID
                    NewLibraryPlaylist.DriveID := existingPL.DriveID;
                    //else
                    //begin
                        //MessageDLG((Medialibrary_SaveException1), mtError, [MBOK], 0);


                        //MessageDLG( 'unbekannte DriveID für ' +  jas.DataString, mtError, [MBOK], 0);
                        //LeaveCriticalSection(CSAccessDriveList);
                        //exit;
                    //end;
                end;
            end;

            BytesWritten := BytesWritten + NewLibraryPlaylist.SaveToStream(aStream);
        end;
    finally
        NewLibraryPlaylist.Free;
    end;
    // --------------------------
    // write correct block size
    EndPosition := aStream.Position;
    aStream.Position := SizePosition;
    aStream.Write(BytesWritten, SizeOf(BytesWritten));
    // seek to the end position again
    aStream.Position := EndPosition;

    LeaveCriticalSection(CSAccessDriveList);
end;
{
    --------------------------------------------------------
    LoadRadioStationsFromStream
    SaveRadioStationsToStream
    - Read/Write a List of Webradio stations
    --------------------------------------------------------
}
function TMedienBibliothek.LoadRadioStationsFromStream(aStream: TStream): Boolean;
var i, StationCount: Integer;
    NewStation: TStation;
begin
    // todo: Some error handling?
    Result := True;

    aStream.Read(StationCount, SizeOf(StationCount));
    // Stationen laden
    for i := 1 to StationCount do
    begin
        NewStation := TStation.Create(MainWindowHandle);
        NewStation.LoadFromStream(aStream);
        RadioStationList.Add(NewStation);
    end;
end;

function TMedienBibliothek.LoadRadioStationsFromStream_DEPRECATED(aStream: TStream): Boolean;
var i, c: Integer;
    NewStation: TStation;
begin
    // todo: Some error handling?
    Result := True;

    aStream.Read(c, SizeOf(c));
    // Stationen laden
    for i := 1 to c do
    begin
        NewStation := TStation.Create(MainWindowHandle);
        NewStation.LoadFromStream_DEPRECATED(aStream);
        RadioStationList.Add(NewStation);
        //WebRadioCategory.AddStation(NewStation);
    end;
end;

procedure TMedienBibliothek.SaveRadioStationsToStream(aStream: TStream);
var i, c, len: Integer;
    MainID: Byte;
    BytesWritten: LongInt;
    SizePosition, EndPosition: Int64;
begin
    MainID := MP3DB_BLOCK_WEBSTREAMS;
    aStream.Write(MainID, SizeOf(MainID));
    len := 42; // just a dummy value here. needs to be corrected at the end of this procedure
    SizePosition := aStream.Position;
    aStream.Write(len, SizeOf(len));

    c := RadioStationList.Count;
    aStream.Write(c, SizeOf(c));
    // speichern
    for i := 0 to c-1 do
        TStation(RadioStationList[i]).SaveToStream(aStream);

    // correct the size information for this block
    EndPosition := aStream.Position;
    aStream.Position := SizePosition;
    BytesWritten := EndPosition - SizePosition;
    aStream.Write(BytesWritten, SizeOf(BytesWritten));
    // seek to the end position again
    aStream.Position := EndPosition;
end;

{
    --------------------------------------------------------
    LoadCategoriesFromStream
    SaveCategoriesToStream
    - Read/Write a List Categories
    --------------------------------------------------------
}

function TMedienBibliothek.GetCategoryIndexByCategory(aCat: TLibraryCategory): Integer;
var
  tmpIdx: Integer;
begin
  result := 0;
  if not assigned(aCat) then
    exit;

  case aCat.CategoryType of
    ccFiles: begin
      tmpIdx := FileCategories.IndexOf(aCat);
      if tmpIdx >= 0 then
        result := tmpIdx;
    end;
    ccPlaylists: begin
      tmpIdx := PlaylistCategories.IndexOf(aCat);
      if tmpIdx >= 0 then
        result := 1000 + tmpIdx;
    end;
    ccWebStations: result := 2000;
  end;
end;


function TMedienBibliothek.GetCategoryByCategoryIndex(aIdx: Integer): TLibraryCategory;
var
  IdxMod: Integer;
begin
  IdxMod := (aIdx mod 1000);
  result := Nil;

  case aIdx Div 1000 of
    0: begin
        if (IdxMod >= 0) and (IdxMod < FileCategories.Count) then
          result := FileCategories[IdxMod];
    end;
    1: begin
        if (IdxMod >= 0) and (IdxMod < PlaylistCategories.Count) then
          result := PlaylistCategories[IdxMod];
    end;
    2: result := WebRadioCategory;
  end;
end;

procedure TMedienBibliothek.SetCurrentCategory(Value: TLibraryCategory);
begin
  fCurrentCategory := Value;
end;

procedure TMedienBibliothek.SetAutoScanPlaylistFilesOnView(Value: Boolean);
var
  i: Integer;
begin
  if Value <> fAutoScanPlaylistFilesOnView then begin
    fAutoScanPlaylistFilesOnView := Value;
    for i := 0 to PlaylistCategories.Count - 1 do
      TLibraryPlaylistCategory(PlaylistCategories[i]).AutoScan := Value;
  end;
end;


procedure TMedienBibliothek.EnsureCategoriesExist;
var
  DoInitNemp5: Boolean;

  procedure AddFileCategory(aName: String; aIndex: Integer);
  var
    NewCategory: TLibraryFileCategory;
  begin
    NewCategory := TLibraryFileCategory.Create;
    NewCategory.Name := aName;
    NewCategory.Index := aIndex;
    NewCategory.IsUserDefined := False;
    FileCategories.Add(NewCategory);
  end;

  procedure AddPlaylistCategoryLibrary(aName: String; aIndex: Integer);
  var
    NewCategory: TLibraryPlaylistCategory;
  begin
    NewCategory := TLibraryPlaylistCategory.Create;
    NewCategory.Name := aName;
    NewCategory.Index := aIndex;
    //NewCategory.SortIndex := aIndex;
    NewCategory.CaptionMode := 0; // Oder was anderes?
    NewCategory.AutoScan := AutoScanPlaylistFilesOnView;
    PlaylistCategories.Add(NewCategory);
  end;

  procedure DummyForGetText;
  var s: String;
  begin
    s := _('Music');
    s := _('Recently added');
    s := _('Audio books');
  end;

begin
    DoInitNemp5 := FileCategories.Count = 0;
    if DoInitNemp5 then begin
      AddFileCategory('Music', 0);
      AddFileCategory('Recently added', 1);
      AddFileCategory('Audio books', 2);
    end;
    if not assigned(CurrentCategory) then
      CurrentCategory := FileCategories[0];

    DefaultFileCategory := TLibraryFileCategory(GetDefaultCategory(FileCategories));
    NewFilesCategory := TLibraryFileCategory(GetNewCategory(FileCategories));
    // Ensure that we have a "Default" category
    if not assigned(fDefaultFileCategory) then
      DefaultFileCategory := TLibraryFileCategory(FileCategories[0]);
    // Ensure that we have a "Recently Added" category when upgrading from Nemp4 to Nemp5
    if DoInitNemp5 and (not assigned(fNewFilesCategory)) then
      NewFilesCategory := TLibraryFileCategory(FileCategories[min(1, FileCategories.Count-1)]);

    if PlaylistCategories.Count = 0 then begin
      AddPlaylistCategoryLibrary(rsDefaultCategoryPlaylist, 0);
      AddPlaylistCategoryLibrary(rsDefaultCategoryFavPlaylist, 1);
    end;
end;

procedure TMedienBibliothek.InitLastSelectedCollection;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_LoadLastSelectionData, 0);
end;

procedure TMedienBibliothek.LoadLastSelectionData;
var
  i, catidx: Integer;
  tmpCat: TLibraryCategory;

begin
  // Read Info "current selection"
  fCurrentCategoryIdx := NempSettingsManager.ReadInteger('LibraryOrganizerSelection', 'CollectionIndex', 0);
  tmpCat := GetCategoryByCategoryIndex(fCurrentCategoryIdx);
  if assigned(tmpCat) then
    CurrentCategory := tmpCat;

  for i := 0 to 2 do begin
    for catIdx := 0 to FileCategories.Count - 1 do
      FileCategories[catIdx].LastSelectedCollectionData[i].LoadSettings(i, catIdx);
  end;
end;

procedure TMedienBibliothek.CreateRootCollections;
var
  i,r: Integer;
  newRoot: TRootCollection;
begin
  case BrowseMode of
    0: begin
      // create the RootCollections
      for i := 0 to FileCategories.Count - 1 do begin
        TLibraryFileCategory(FileCategories[i]).Clear;
        for r := 0 to NempOrganizerSettings.RootCollectionCount - 1 do begin
          TLibraryFileCategory(FileCategories[i]).AddRootCollection(
            NempOrganizerSettings.RootCollectionConfig[r]);
        end;
      end;
    end;
    1: begin
      // create Cover-RootCollection for every category
      for i := 0 to FileCategories.Count - 1 do begin
        TLibraryFileCategory(FileCategories[i]).Clear;
        newRoot := TLibraryFileCategory(FileCategories[i]).AddRootCollection(NempOrganizerSettings.CoverFlowRootCollectionConfig);
        newRoot.MissingCoverMode := MissingCoverMode;
      end;
      CoverSearchCategory.Clear;
      newRoot := CoverSearchCategory.AddRootCollection(NempOrganizerSettings.CoverFlowRootCollectionConfig);
      newRoot.MissingCoverMode := MissingCoverMode;
    end;
    2: begin
      // TagCloud
      for i := 0 to FileCategories.Count - 1 do begin
        TLibraryFileCategory(FileCategories[i]).Clear;
        TLibraryFileCategory(FileCategories[i]).AddRootCollection(NempOrganizerSettings.TagCloudCollectionConfig);
      end;
    end;
  end;

end;

procedure TMedienBibliothek.InitFileCategories;
var
  i: Integer;
begin
  EnsureCategoriesExist;
  CreateRootCollections;

  for i := 0 to self.FileCategories.Count - 1 do
    FileCategories[i].BrowseMode := BrowseMode;

  // Playlists: The same in every case (?)
  for i := 0 to PlaylistCategories.Count - 1 do begin
    PlaylistCategories[i].Clear;
  end;
  //
  WebRadioCategory.Name := rsDefaultCategoryWebradio;
end;

procedure TMedienBibliothek.DeleteEmptyFileCollections;
var
  i, r: Integer;
begin
  // Note: DO NOT use ... FileCategories[i].RemoveEmptyCollections;
  // This would also delete empty RootCollections, but we want to keep those
  for i := 0 to FileCategories.Count - 1 do
    for r := 0 to FileCategories[i].CollectionCount - 1 do
      FileCategories[i].Collections[r].RemoveEmptyCollections;
end;

procedure TMedienBibliothek.DeleteEmptyPlaylistCollections;
var
  i: Integer;
begin
  for i := 0 to PlaylistCategories.Count - 1 do
    PlaylistCategories[i].RemoveEmptyCollections;
end;

procedure TMedienBibliothek.DeleteEmptyWebRadioCollections;
begin
  WebRadioCategory.RemoveEmptyCollections;
end;

procedure TMedienBibliothek.RefreshCollections(FullRefill: Boolean);
var
  catIdx: Integer;
begin
  // this method may be called by VCL- and background-Threads
  case BrowseMode of
    // ClearEmptyNodes first: Otherwise we get some access violations (e.g. on GetImageIndex)
    0: SendMessage(MainWindowHandle, WM_MedienBib, MB_ClearEmptyNodes, 0);
    1: ;
    2: ;
  end;

  DeleteEmptyFileCollections;
  DeleteEmptyPlaylistCollections;
  DeleteEmptyWebRadioCollections;

  // Analysing and sorting the Collections in FileCategories will only be done, if there was a change in the Collection.
  // => After add/edit/delete only a few files, not everything will be analysed and sorted again; only the neccessary parts.
  for catIdx := 0 to FileCategories.Count - 1 do begin
    FileCategories[catIdx].AnalyseCollections(True);
    FileCategories[catIdx].SortCollections(True);
  end;

  // refill view
  if FullRefill then
    SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
end;

procedure TMedienBibliothek.RefreshWebRadioCategory;
begin

  // DeleteEmptyWebRadioCollections;
  WebRadioCategory.Clear;
  MergeWebradioIntoCategories(RadioStationList);

  if (CurrentCategory is TLibraryWebradioCategory) then
    SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
end;

procedure TMedienBibliothek.FillRootCollection(Dest: TRootCollection; SourceCategory: TLibraryCategory);
var
  i, CatIdx: Integer;
  CheckCat: Boolean;
begin
  CatIdx := 0;
  CheckCat := assigned(SourceCategory);
  if CheckCat then begin
    if SourceCategory.CategoryType = ccFiles then
      CatIdx := CurrentCategory.Index
    else begin
      if assigned(DefaultFileCategory) then
        CatIdx := DefaultFileCategory.Index
      else
        CheckCat := False; // Something is wrong with categories: Skip check
    end;
  end;

  if CheckCat then begin
    for i := 0 to Mp3ListePfadSort.Count - 1 do
      if Mp3ListePfadSort[i].IsCategory(CatIdx) then
        Dest.AddAudioFile(Mp3ListePfadSort[i]);
  end else
  begin
    for i := 0 to Mp3ListePfadSort.Count - 1 do
      Dest.AddAudioFile(Mp3ListePfadSort[i]);
  end;

  Dest.Sort(False);
end;

procedure TMedienBibliothek.ReBuildCategories;
begin
  InitFileCategories;
  MergeFileIntoCategories(Mp3ListePfadSort);
  MergePlaylistsIntoCategories(AllPlaylistsPfadSort);

  if assigned(FavoritePlaylistCategory) and (FavoritePlaylistCategory.CollectionCount = 0) then
    MergeNempDefaultPlaylists;
end;

procedure TMedienBibliothek.ReFillFileCategories;
begin
  CreateRootCollections;
  MergeFileIntoCategories(Mp3ListePfadSort);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, 1);
end;

procedure TMedienBibliothek.FinishCategories;
begin
  case BrowseMode of
      0: begin
        // ??
      end;
      1: begin
          CoverArtSearcher.PrepareMainCover(CurrentCategory);
      end;
      2: begin
          // ??
      end;
  end;
end;

function TMedienBibliothek.GetTargetFileCategoryName(lc: TLibraryCategory; out CatCount: Integer): String;
begin
  CatCount := 0;
  if not assigned(lc) then
    result := ''
  else
  if not (lc.CategoryType = ccFiles) then
    result := '' // but this case should not occur, i.e. in this case the "Name" would not be used
  else
  begin
    // simple setup: Use Category Name only if it is neither the "default" nor the "recently added" category
    if lc.IsDefault or lc.IsNew then
      result := lc.Name
    else
    begin
      inc(CatCount);
      result := lc.Name;
    end;
    {
    // different setup:
    // Show category names in more cases (but I think that's too much and kind of confusing)
    inc(CatCount);
    result := lc.Name;
    // if the actual DropOver-Category is our "Recently Added"-Category, the dropped files
    // should *also* be added into the Default-Category, if the setting "UseSmartAdd" is activated
    if (lc.IsNew)
      and assigned(DefaultFileCategory)
      and (DefaultFileCategory <> lc)
    then begin
      result := result + ', ' + DefaultFileCategory.Name;
      inc(CatCount);
    end;

    if (not lc.IsNew) and assigned(NewFilesCategory)
    then begin
      result := result + ', ' + NewFilesCategory.Name;
      inc(CatCount);
    end;
    }
  end;
end;

procedure TMedienBibliothek.InitTargetCategory(lc: TLibraryCategory);
var
  CategoryMask: Cardinal;
begin
  CategoryMask := 0;
  if assigned(lc) and (lc.CategoryType = ccFiles) then begin
    CategoryMask := 1 shl lc.Index;
    // Add DefaultCategory, if it makes sense
    if lc.IsNew and assigned(DefaultFileCategory) then
      CategoryMask := CategoryMask or (1 shl DefaultFileCategory.Index);
  end
  else
    if assigned(DefaultFileCategory) then
      CategoryMask := 1 shl DefaultFileCategory.Index;
  // Add "Recently Added"-Category if wanted
  if assigned(NewFilesCategory) then
    CategoryMask := CategoryMask or (1 shl NewFilesCategory.Index);

  NewCategoryMask := Categorymask;

  // CategoryMask for changing category:
  // Use lc.Index, if it is not one of the "special" categories
  if assigned(lc) and (lc.CategoryType = ccFiles) and (not lc.IsDefault) and (not lc.IsNew) then begin
    ChangeCategoryMask := 1 shl lc.Index;
    fChangeCategory := TLibraryFileCategory(lc);
  end
  else begin
    ChangeCategoryMask := 0;
    fChangeCategory := NIL;
  end;
end;

procedure TMedienBibliothek.ChangeCategory(Current, Target: TLibraryCategory; Files: TAudioFileList; Action: teCategoryAction);
var
  i: Integer;
  curIdx, targetIdx: Byte;
begin
  if Action = caNone then
    exit;

  // remove Files from the current Category
  if (Action = caCategoryMove) and (Current is TLibraryFileCategory) then begin
    curIdx := Current.Index;
    for i := 0 to Files.Count - 1 do begin
      Files[i].RemoveFromCategory(curIdx);
      TLibraryFileCategory(Current).RemoveAudioFile(Files[i]);
    end;
  end;

  if assigned(Target) and (Target is TLibraryFileCategory) then begin
    targetIdx := Target.Index;
    for i := 0 to Files.Count - 1 do begin
      if not Files[i].IsCategory(targetIdx) then begin // do not add it again, if it is already in the TargetCategory
        Files[i].AddToCategory(targetIdx);
        TLibraryFileCategory(Target).AddAudioFile(Files[i]);
      end;
    end;
  end;
  Changed := True;
end;

procedure TMedienBibliothek.RemoveFromCategory(Current: TLibraryCategory; Files: TAudioFileList);
var
  i: Integer;
  curIdx, defIdx: Byte;
begin
  curIdx := Current.Index;
  defIdx := DefaultFileCategory.Index;

  for i := 0 to Files.Count - 1 do begin
    Files[i].RemoveFromCategory(curIdx);
    TLibraryFileCategory(Current).RemoveAudioFile(Files[i]);

    // make sure that the files remain in at least one category.
    // If not, add it to the Default Category
    if (Files[i].Category = 0) then begin
      Files[i].AddToCategory(defIdx);
      TLibraryFileCategory(DefaultFileCategory).AddAudioFile(Files[i]);
    end;
  end;
  Changed := True;
end;

function TMedienBibliothek.AudioFileCategoryShouldChange(AudioFile: TAudioFile): Boolean;
begin
  result := (AudioFile.Category or ChangeCategoryMask) <> AudioFile.Category;
end;

function TMedienBibliothek.LoadFileCategoriesFromStream(aStream: TStream): Boolean;
var
  i, CatCount: Integer;
  NewCategory: TLibraryFileCategory;
begin
  Result := True;
  aStream.Read(CatCount, SizeOf(CatCount));
  if CatCount > 0 then
    FileCategories.Clear;
  for i := 1 to CatCount do begin
    NewCategory := TLibraryFileCategory.Create;
    NewCategory.LoadFromStream(aStream);
    FileCategories.Add(NewCategory);
  end;
end;

function TMedienBibliothek.LoadPlaylistCategoriesFromStream(aStream: TStream): Boolean;
var
  i, CatCount: Integer;
  NewCategory: TLibraryPlaylistCategory;
begin
  Result := True;
  aStream.Read(CatCount, SizeOf(CatCount));
  if CatCount > 0 then
    PlaylistCategories.Clear;
  for i := 1 to CatCount do begin
    NewCategory := TLibraryPlaylistCategory.Create;
    NewCategory.LoadFromStream(aStream);
    NewCategory.AutoScan := AutoScanPlaylistFilesOnView;
    PlaylistCategories.Add(NewCategory);
  end;
end;

procedure TMedienBibliothek.SaveCategoriesToStream(aStream: TStream; aList: TLibraryCategoryList);
var i, c, len: Integer;
    BytesWritten: LongInt;
    SizePosition, EndPosition: Int64;
begin
    len := 42; // just a dummy value here. needs to be corrected at the end of this procedure
    SizePosition := aStream.Position;
    aStream.Write(len, SizeOf(len));
    c := aList.Count;
    aStream.Write(c, SizeOf(c));
    // speichern
    for i := 0 to c-1 do
      aList[i].SaveToStream(aStream);
    // correct the size information for this block
    EndPosition := aStream.Position;
    aStream.Position := SizePosition;
    BytesWritten := EndPosition - SizePosition;
    aStream.Write(BytesWritten, SizeOf(BytesWritten));
    // seek to the end position again
    aStream.Position := EndPosition;
end;

procedure TMedienBibliothek.SaveFileCategoriesToStream(aStream: TStream);
var
  MainID: Byte;
begin
  MainID := MP3DB_BLOCK_CAT_FILES;
  aStream.Write(MainID, SizeOf(MainID));
  SaveCategoriesToStream(aStream, FileCategories)
end;

procedure TMedienBibliothek.SavePlaylistCategoriesToStream(aStream: TStream);
var
  MainID: Byte;
begin
  MainID := MP3DB_BLOCK_CAT_PLAYLISTS;
  aStream.Write(MainID, SizeOf(MainID));
  SaveCategoriesToStream(aStream, PlaylistCategories)
end;


{
    --------------------------------------------------------
    LoadFromFile4
    - Load a gmp-File in Nemp 3.3-Format

    - Subversion: 0,1: load the blocks completely
                    2: buffing possible for audiofiles
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadFromFile4(aStream: TStream; SubVersion: Integer);
var MainID: Byte;
    BlockSize: Integer;
    GoOn: Boolean;
begin
    // neues Format besteht aus mehreren "Blöcken"
    // Jeder Block beginnt mit einer ID (1 Byte)
    //             und einer Größenangabe (4 Bytes)
    // Die einzelnen Blöcke werden getrennt geladen und gespeichert
    // wichtig: Zuerst die Laufwerks-Liste in die Datei speichern,
    // DANACH die Audiodateien
    // Denn: In der Audioliste wird Bezug auf die UsedDrives genommen!!
    GoOn := True;

    While (aStream.Position < aStream.Size) and GoOn do
    begin
        aStream.Read(MainID, SizeOf(Byte));
        aStream.Read(BlockSize, SizeOf(Integer));

        case MainID of
            // note: Drives are located BEFORE the Audiofiles in the *.gmp-File!
            MP3DB_BLOCK_FILES: GoOn := LoadAudioFilesFromStream_DEPRECATED(aStream, BlockSize); // Audiodaten lesen
            MP3DB_BLOCK_DRIVES: GoOn := LoadDrivesFromStream_DEPRECATED(aStream); // Drive-Info lesen
            MP3DB_BLOCK_PLAYLISTS: GoOn := LoadPlaylistsFromStream_DEPRECATED(aStream);
            MP3DB_BLOCK_WEBSTREAMS: GoOn := LoadRadioStationsFromStream_DEPRECATED(aStream);
        else
          aStream.Seek(BlockSize, soFromCurrent);
        end;
    end;
    InitFileCategories;
    InitLastSelectedCollection;
end;


procedure TMedienBibliothek.LoadFromFile5(aStream: TStream; SubVersion: Integer);
var MainID: Byte;
    BlockSize: Integer;
    GoOn: Boolean;
begin
    // Changes in Version 5:
    // - the structure of the different blocks has been unified
    // - the content of the blocks (e.g. audiofiles) is kinda update-proof.
    //   It is easier to add new data fields without changing the file format
    // - also some simplifications (but at the cost of a minor increase of size)
    GoOn := True;

    While (aStream.Position < aStream.Size) and GoOn do
    begin
        aStream.Read(MainID, SizeOf(Byte));
        aStream.Read(BlockSize, SizeOf(Integer));

        case MainID of
            // note: Drives are located BEFORE the Audiofiles in the *.gmp-File!
            MP3DB_BLOCK_FILES: GoOn := LoadAudioFilesFromStream(aStream);   // 4.13: Done
            MP3DB_BLOCK_DRIVES: GoOn := LoadDrivesFromStream(aStream);       // 4.13: Done
            MP3DB_BLOCK_PLAYLISTS: GoOn := LoadPlaylistsFromStream(aStream);    // 4.13: Done
            MP3DB_BLOCK_WEBSTREAMS: GoOn := LoadRadioStationsFromStream(aStream); // 4.13: done
            MP3DB_BLOCK_CAT_FILES: GoOn := LoadFileCategoriesFromStream(aStream) ;
            MP3DB_BLOCK_CAT_PLAYLISTS: GoOn := LoadPlaylistCategoriesFromStream(aStream);
        else
          aStream.Seek(BlockSize, soFromCurrent);
        end;
    end;
    InitFileCategories; // i.e. Re-Init
    InitLastSelectedCollection;
end;

{
    --------------------------------------------------------
    LoadFromFile
    - Load a gmp-File
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadFromFile(aFilename: UnicodeString; Threaded: Boolean = False);
var Dummy: Cardinal;
begin
    StatusBibUpdate := 2;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);
    // Nemp 4.14: We may use relative Paths in the Library as well
    SetCurrentDir(ExtractFilePath(aFileName));
    if Threaded then
    begin
        fBibFilename := aFilename;
        fHND_LoadThread := (BeginThread(Nil, 0, @fLoadLibrary, Self, 0, Dummy));
    end else
        fLoadFromFile(aFilename);
end;

Procedure fLoadLibrary(MB: TMedienbibliothek);
begin
    MB.fLoadFromFile(MB.fBibFilename);
    try
      CloseHandle(MB.fHND_LoadThread);
    except
    end;
end;

procedure TMedienBibliothek.fLoadFromFile(aFilename: UnicodeString);
var aStream: TFastFileStream;
    Header: AnsiString;
    version, Subversion: byte;
    success: Boolean;
begin
    // if StatusBibUpdate <> 0 then exit;

    success := True; // think positive!
    if FileExists(aFilename) then
    begin
        try
            aStream := TFastFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                aStream.BufferSize := BUFFER_SIZE;

                setlength(Header,length(MP3DB_HEADER));
                aStream.Read(Header[1],length(MP3DB_HEADER));
                aStream.Read(Version,sizeOf(MP3DB_VERSION));
                aStream.Read(Subversion, sizeof(MP3DB_SUBVERSION));

                if Header = 'GMP' then
                begin
                    case Version of
                        2,
                        3: begin
                            SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_LibFileTooOld) )));

                            success := False;
                        end;
                        4: begin
                            if Subversion <= 2 then // new in Nemp 4.0: Subversion changed to 1
                                                    // (additional value in RadioStations)
                            begin
                                EnterCriticalSection(CSAccessDriveList);
                                LoadFromFile4(aStream, Subversion);
                                LeaveCriticalSection(CSAccessDriveList);
                                NewFilesUpdateBib(True);
                            end else
                            begin
                                SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_LibFileTooYoung) )));
                                success := False;
                            end;
                        end;
                        5: begin
                            // new format since Nemp 4.13, end of 2019
                            if subversion <= 1 then
                            begin
                                // EnterCriticalSection(CSAccessDriveList);
                                LoadFromFile5(aStream, Subversion);
                                // LeaveCriticalSection(CSAccessDriveList);
                                NewFilesUpdateBib(True);
                            end else
                            begin
                                SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                    Integer(PWideChar(_(Medialibrary_LibFileTooYoung) )));
                                success := False;
                            end;
                        end
                        else
                        begin
                            SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                                Integer(PWideChar(_(Medialibrary_LibFileTooYoung) )));
                            success := False;
                        end;

                    end; // case Version

                    if RadioStationList.Count = 0 then
                    begin
                        if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
                            ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
                        else
                            if FileExists(SavePath + 'default.nwl') then
                                ImportFavorites(SavePath + 'default.nwl')
                    end;
                end else // if Header = 'GMP'
                begin
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                            Integer(PWideChar(_(Medialibrary_InvalidLibFile) )));
                    success := False;
                end;

                if Not Success then begin
                    // InitFileCategories; //done in Create/Clear
                    // We have no valid library, but we have to update anyway,
                    // as this ensures AutoScan and/or webserver-activation
                    InitFileCategories; // i.e. Re-Init
                    InitLastSelectedCollection;
                    NewFilesUpdateBib(True);
                end;
            finally
                FreeAndNil(aStream);
            end;
        except
            on E: Exception do begin
                SendMessage(MainWindowHandle, WM_MedienBib, MB_InvalidGMPFile,
                        Integer(PWideChar((ErrorLoadingMediaLib) + #13#10 + E.Message )));
                // success := False;
            end;
        end;
    end else
    begin
        // InitFileCategories; //done in Create/Clear
        // Datei nicht vorhanden - nur Webradio laden
        if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
            ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
        else
            if FileExists(SavePath + 'default.nwl') then
                ImportFavorites(SavePath + 'default.nwl');

        InitFileCategories; // i.e. Re-Init
        InitLastSelectedCollection;

        // We have no library, but we have to update anyway,
        // as this ensures AutoScan and/or webserver-activation
        NewFilesUpdateBib(True);
    end;
end;

{
    --------------------------------------------------------
    SaveToFile
    - Save a gmp-File
    --------------------------------------------------------
}
procedure TMedienBibliothek.SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
var  str: TFastFileStream;
    aFile: THandle;
begin
  if not FileExists(aFilename) then
  begin
      aFile := FileCreate(aFileName);
      if aFile = INVALID_HANDLE_VALUE then
          raise EFCreateError.CreateResFmt(@SFCreateErrorEx, [ExpandFileName(AFileName), SysErrorMessage(GetLastError)])
      else
          CloseHandle(aFile);
  end;

  try
      Str := TFastFileStream.Create(aFileName, fmCreate or fmOpenReadWrite);
      try
        EnterCriticalSection(CSAccessDriveList);

        str.Write(AnsiString(MP3DB_HEADER), length(MP3DB_HEADER));
        str.Write(MP3DB_VERSION,sizeOf(MP3DB_VERSION));
        str.Write(MP3DB_SUBVERSION, sizeof(MP3DB_SUBVERSION));

        SaveDrivesToStream(str); // 4.13: Done

        SaveAudioFilesToStream(str, aFileName);
        SavePlaylistsToStream(str, aFileName);
        SaveRadioStationsToStream(str);
        SaveFileCategoriesToStream(str);
        SavePlaylistCategoriesToStream(str);

        str.Size := str.Position;
      finally
        LeaveCriticalSection(CSAccessDriveList);
        FreeAndNil(str);
      end;
      Changed := False;
  except
      on e: Exception do
          //if not Silent then
              MessageDLG(E.Message, mtError, [MBOK], 0)
  end;
end;


// this function should only be called after a check for StatusBibUpdate
// (used in the warning messageDlg when the User deactivates Lyrics usage)
function TMedienBibliothek.GetLyricsUsage: TLibraryLyricsUsage;
var i: Integer;
    aAudioFile: TAudioFile;
begin
    result.TotalFiles := Mp3ListePfadSort.Count;
    result.FilesWithLyrics := 0;
    result.TotalLyricSize := 0;

    if StatusBibUpdate >= 2 then exit;
    EnterCriticalSection(CSUpdate);
    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        aAudioFile := Mp3ListePfadSort[i];
        if aAudioFile.LyricsExisting then
        begin
            inc(result.FilesWithLyrics);
            inc(result.TotalLyricSize, Length(aAudioFile.Lyrics));
        end;
    end;

    if BibSearcher.AccelerateLyricSearch then
        result.TotalLyricSize := result.TotalLyricSize * 2;

    LeaveCriticalSection(CSUpdate);
end;



procedure TMedienBibliothek.RemoveAllLyrics;
var i: Integer;
begin
    if StatusBibUpdate >= 2 then exit;

    EnterCriticalSection(CSUpdate);
    for i := 0 to Mp3ListePfadSort.Count - 1 do
        Mp3ListePfadSort[i].Lyrics := '';

    BibSearcher.ClearTotalLyricString;
    LeaveCriticalSection(CSUpdate);
end;


// MergeFilesIntoPathList
// Previously "merge()" in BibHelper.pas, but now with instant swapping and only for the main Path-Sorted-List
procedure TMedienBibliothek.MergeFilesIntoPathList(aUpdateList: TAudioFileList);
var idxA, idxB: Integer;
  NewPathList, swapList: TAudioFileList;

  function CompareFilePaths(item1, item2: TAudioFile): Integer;
  begin
    // Sort_Pfad_asc
    result := AnsiCompareText_Nemp(item1.Ordner, item2.Ordner);
    if result = 0 then
      result := AnsiCompareText_Nemp(item1.Dateiname, item2.Dateiname);
  end;

begin
  NewPathList := TAudioFileList.Create(False);

  // Mische die beiden Source-Listen zu einer Target-Liste.
  idxA := 0;
  idxB := 0;
  while (idxA < Mp3ListePfadSort.Count) OR (idxB < aUpdateList.Count) do
  begin
        if (idxA < Mp3ListePfadSort.Count) AND (idxB < aUpdateList.Count) then
        begin
            // Noch was in beiden Spource-Listen drin
            if CompareFilePaths(Mp3ListePfadSort[idxA], aUpdateList[idxB]) < 0 then
            begin
              NewPathList.Add(Mp3ListePfadSort[idxA]);
              inc(idxA);
            end else
            begin
              NewPathList.Add(aUpdateList[idxB]);
              inc(idxB);
            end;
        end else
        begin
            // Nur noch in einer Liste was drin
            if (idxA < Mp3ListePfadSort.Count) then
            begin
              NewPathList.Add(Mp3ListePfadSort[idxA]);
              inc(idxA);
            end else
            begin
              NewPathList.Add(aUpdateList[idxB]);
              inc(idxB);
            end;
        end;
  end; // While


  // use the NewPathList as MainList from now on
  swapList := Mp3ListePfadSort;
  Mp3ListePfadSort := NewPathList;
  BibSearcher.MainList := NewPathList;
  // free the old PathList
  swapList.Free;
end;

procedure TMedienBibliothek.DeleteFilesFromPathList(missingFiles: TAudioFileList);
var
  idxS, idxD, i: Integer;
  NewPathList, swapList: TAudioFileList;
begin
  idxS := 0;
  idxD := 0;
  NewPathList := TAudioFileList.Create(False);

  while (idxS < Mp3ListePfadSort.Count) AND (idxD < missingFiles.Count) do
  begin
    if Mp3ListePfadSort[idxS].Pfad = missingFiles[idxD].Pfad then
    begin
      // File is missing, do not add it to the new List.
      inc(idxS);
      inc(idxD);
    end else
    begin
      NewPathList.Add(Mp3ListePfadSort[idxS]);
      inc(idxS);
    end;
  end;
  // missingFiles done. Add the remaining Files from Mp3ListPfadSort
  for i := idxS to Mp3ListePfadSort.Count -1 do
    NewPathList.Add(Mp3ListePfadSort[i]);

  // use the NewPathList as MainList from now on
  swapList := Mp3ListePfadSort;
  Mp3ListePfadSort := NewPathList;
  BibSearcher.MainList := NewPathList;
  // free the old PathList
  swapList.Free;
end;

procedure TMedienBibliothek.DeleteFilesFromOtherLists(missingFiles: TAudioFileList);
var
  i, iCat: Integer;
begin
  for i := 0 to missingFiles.Count - 1 do begin
    // similar to DeleteAudioFile(), but
    // - without Mp3ListePfadSort.Extract (this is done before more efficiently)
    // - without check for "AnzeigeShowsPlaylistFiles" (we do have "real" files here)
    // - no AudioFile.free (this is done later)
    if missingFiles[i] = CurrentAudioFile then
      currentAudioFile := Nil;

    LastBrowseResultList      .Extract(missingFiles[i]);
    LastQuickSearchResultList .Extract(missingFiles[i]);
    LastMarkFilterList        .Extract(missingFiles[i]);

    BibSearcher.RemoveAudioFileFromLists(missingFiles[i]);
    // remove from all Categories
    for iCat := 0 to FileCategories.Count - 1 do
      TLibraryFileCategory(FileCategories[iCat]).RemoveAudioFile(missingFiles[i]);
  end;
end;

procedure TMedienBibliothek.DeletePlaylists(MissingPlaylists: TLibraryPlaylistList);
var
  i, iCat: Integer;
begin
  // remove all Missing Playlists from the main list and all Categories
  for i := 0 to MissingPlaylists.Count - 1 do begin
    AllPlaylistsPfadSort.Remove(MissingPlaylists[i]);
    for iCat := 0 to PlaylistCategories.Count - 1 do
      TLibraryPlaylistCategory(PlaylistCategories[iCat]).RemovePlaylist(MissingPlaylists[i]);
  end;
end;

procedure TMedienBibliothek.MergeFileIntoCategories(aFileList: TAudioFileList);
var
  i, catIdx, actualCatIdx: Integer;
  added: Boolean;
begin
  fCollectionsAreDirty := False;
  for i := 0 to aFileList.Count - 1 do begin
    added := False;
    for catIdx := 0 to FileCategories.Count - 1 do begin
      actualCatIdx := FileCategories[catIdx].Index;
      if aFileList[i].IsCategory(actualCatIdx) then begin
        TLibraryFileCategory(FileCategories[catIdx]).AddAudioFile(aFileList[i]);
        added := True;
      end;
    end;
    if not added then begin
      DefaultFileCategory.AddAudioFile(aFileList[i]);
      // explicitly add the file to this category, and ONLY this one (i.e. remove other Bits from removed Categories)
      // (invalid Category-Bits are still possible, but less likely)
      aFileList[i].SetExclusiveCategory(DefaultFileCategory.Index);
    end;
  end;

  // Analysing and sorting the Collections in FileCategories will only be done,
  // if there was a change in the Collection.
  // => After adding only a few files to the library, not everything will be analysed and sorted again; only the neccessary parts.
  for catIdx := 0 to FileCategories.Count - 1 do begin
    FileCategories[catIdx].AnalyseCollections(True);
    FileCategories[catIdx].SortCollections(True);
  end;
end;

procedure TMedienBibliothek.MergePlaylistsIntoCategories(aPlaylistList: TLibraryPlaylistList);
var
  i, catIdx, actualCatIdx: Integer;
  added: Boolean;
begin
  for i := 0 to aPlaylistList.Count - 1  do begin
    added := False;
    aPlaylistList[i].Category := 0;
    for catIdx := 0 to self.PlaylistCategories.Count - 1 do begin
      actualCatIdx := PlaylistCategories[catIdx].Index;
      if aPlaylistList[i].IsCategory(actualCatIdx) then begin
        TLibraryPlaylistCategory(PlaylistCategories[catIdx]).AddPlaylist(aPlaylistList[i]);
        added := True;
      end;
    end;
    if not added then
      DefaultPlaylistCategory.AddPlaylist(aPlaylistList[i]);
  end;

  // todo: SortOrder einstellbar ... ?  Ggf. an CaptionMode koppeln?
  for catIdx := 0 to PlaylistCategories.Count - 1 do begin
    // TLibraryPlaylistCategory(PlaylistCategories[catIdx]).Sort(csAlbum);
    TLibraryPlaylistCategory(PlaylistCategories[catIdx]).Sort(
        NempOrganizerSettings.PlaylistSorting,
        NempOrganizerSettings.PlaylistSortDirection);
  end;
end;

procedure TMedienBibliothek.MergeWebradioIntoCategories(aStationList: TObjectList);
var
  i: Integer;
begin
  for i := 0 to aStationlist.Count - 1 do
    WebRadioCategory.AddStation(TStation(aStationlist[i]));
end;

procedure TMedienBibliothek.MergeNempDefaultPlaylists;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ImportFavoritePlaylists, 0);
end;

procedure TMedienBibliothek.ImportFavoritePlaylists(Source: TPlaylistManager);
var
  i: Integer;
  newLibPL: TLibraryPlaylist;
begin
  FavoritePlaylistCategory.Clear;
  FavoritePlaylists.Clear;

  FavoritePlaylistCategory.DriveManager := Source.DriveManager;
  for i := 0 to Source.Count - 1 do begin
    newLibPL := TLibraryPlaylist.Create(Source.UserSavePath + Source.QuickLoadPlaylists[i].FileName);
    newLibPL.Name := Source.QuickLoadPlaylists[i].Description;
    FavoritePlaylists.Add(newLibPL);
    FavoritePlaylistCategory.AddPlaylist(newLibPL);
  end;
end;




initialization

  InitializeCriticalSection(CSUpdate);
  InitializeCriticalSection(CSAccessDriveList);
  InitializeCriticalSection(CSAccessBackupCoverList);

finalization

  DeleteCriticalSection(CSUpdate);
  DeleteCriticalSection(CSAccessDriveList);
  DeleteCriticalSection(CSAccessBackupCoverList);
end.

