{

    Unit MedienbibliothekClass

    One of the Basic-Units - The Library

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

(*29.05.2009: 5050 LOC, 12.06: 4060 LOC

Evtl-. ToDo
- Medienbib nach einem Update direkt speichern
- Funktion: Showsummary irgendwie mit einbauen  --- hab ich. Evtl. noch bei MedienBib-Suche-Ende einfügen.
*)


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

uses Windows, Contnrs, Sysutils,  Classes, Inifiles,
     dialogs, Messages, JPEG, PNGImage, GifImg, MD5, Graphics, Math,
     AudioFileClass, AudioFileHelper, Nemp_ConstantsAndTypes, Hilfsfunktionen, Mp3FileUtils,
     ID3v2Frames,
     U_CharCode, gnuGettext, oneInst, StrUtils,  CoverHelper, BibHelper, StringHelper,
     Nemp_RessourceStrings, DriveRepairTools, ShoutcastUtils, BibSearchClass,
     //Indys:
     IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,

     NempCoverFlowClass, TagClouds, ScrobblerUtils;


type

    TMedienBibliothek = class
    private
        MainWindowHandle: DWord;  // Handle of Nemp Main Window, Destination for all the messages

        // Thread-Handles
        fHND_UpdateThread: DWord;
        fHND_DeleteFilesThread: DWord;
        fHND_RefreshFilesThread: DWord;
        fHND_GetLyricsThread: DWord;
        fHND_GetTagsThread: DWord;
        fHND_UpdateID3TagsThread: DWord;
        fHND_BugFixID3TagsThread: DWord;


        // General note:
        //     all lists beginning with "tmp" are temporary lists, which stores the library
        //     during a update-process, so that the Application is blocked only for a very
        //     short time.
        Mp3ListePfadSort: TObjectlist;      // List of all files in the library. Sorted by Path.
        tmpMp3ListePfadSort: TObjectlist;   // Used for saving, searching and checking for new files

        Mp3ListeArtistSort:TObjectList;     // Two copies of the Mp3ListePfadSort, sorted by other criterias.
        Mp3ListeAlbenSort: TObjectlist;     // used for fast browsing in the library.
        tmpMp3ListeArtistSort:TObjectList;
        tmpMp3ListeAlbenSort: TObjectlist;

        DeadFiles: TObjectlist;             // Two lists, that collect dead files
        DeadPlaylists: TObjectList;

        AlleAlben: TStringList;             // A list with all albums
        tmpAlleAlben: TStringList;          // (the list is shown in MainForm when selecting "All Artists")

        fUsedDrives: TObjectList;           // The TDrives used by the Library

        PlaylistFiles: TObjectList;         // temporarly AudioFiles, loaded from Playlists

        AllPlaylistsPfadSort: TObjectList;     // Lists for Playlists.
        tmpAllPlaylistsPfadSort: TObjectList;  // Contain "TJustAString"-Objects
        AllPlaylistsNameSort: TObjectList;     // Same list, sorted by name for display

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

        fArtist: UnicodeString;    // currently selected artist/album
        fAlbum: UnicodeString;     // Note: OnChange-Events of the trees MUST set these!
        fArtistIndex: Cardinal;
        fAlbumIndex: Cardinal;

      //  fCurrentCoverID: String;     // currently selected cover
      //  fCurrentCoverIDX: Integer;   // Note:  OnChange-Events of the scrollbar MUST set these!

        fChanged: LongBool;          // has bib changed? Is saving necessary?
        // Two helpers for Changed.
        // Loading a Library will execute the same code as adding new files.
        // On Startup a little different behaviour is wanted (e.g. the library is not changed)
        fChangeAfterUpdate: LongBool;
        fInitializing: Integer;

        // After the user changes some information in an audiofile,
        // key1/2 and the matching "real information" are not identical.
        // As the "merge"-method is done by the real information, the old lists
        // must be resorted before merging.
        fBrowseListsNeedUpdate: Boolean;

        // Pfad zum Speicherverzeichnis - wird z.B. fürs Kopieren der Cover benötigt.
        // Savepath:
        fSavePath: UnicodeString;        // ProgramDir or UserDir. used for Settings, Skins, ...
        fCoverSavePath: UnicodeString;   // Path for Cover, := SavePath + 'Cover\'

        // used for faster cover-initialisation.
        // i.e. do not search coverfiles for every audiofile.
        // use the same cover again, if the next audiofile is in the same directory
        fLastCoverName: UnicodeString;
        fLastPath: UnicodeString;
        fLastID: String;

        // Browsemode
        // 0: Classic
        // 1: Coverflow
        // 2: Tagcloud
        fBrowseMode: Integer;
        fCoverSortOrder: Integer;

        function IsAutoSortWanted: Boolean;
        // Getter and Setter for some properties.
        // Most of them Thread-Safe
        function GetCount: Integer;
        procedure SetStatusBibUpdate(Value: Integer);
        function GetStatusBibUpdate   : Integer;
        procedure SetUpdateFortsetzen(Value: LongBool);
        function GetUpdateFortsetzen: LongBool;
        function GetChangeAfterUpdate: LongBool;
        procedure SetChangeAfterUpdate(Value: LongBool);
        function GetChanged: LongBool;
        procedure SetChanged(Value: LongBool);
        function GetInitializing: Integer;
        procedure SetInitializing(Value: Integer);
        function GetBrowseMode: Integer;
        procedure SetBrowseMode(Value: Integer);
        function GetCoverSortOrder: Integer;
        procedure SetCoverSortOrder(Value: Integer);

        // Update-Process for new files, which has been collected before.
        // Runs in seperate Thread, sends proper messages to mainform for sync
        // 1. Prepare Update.
        //    - Merge Updatelist with MainList into tmpMainList
        //    - Create other tmp-Lists and -stuff and sort them
        procedure PrepareNewFilesUpdate;
        // 1b. Update UsedDriveList
        procedure AddUsedDrivesInformation(aList: TObjectlist; aPlaylistList: TObjectList);
        // 2. Swap Lists, used on update-process
        procedure SwapLists;
        // 3. Clean tmp-lists, which are not needed after an update
        procedure CleanUpTmpLists;

        // Update-Process for Non-Existing Files.
        // Runs in seperate Thread, sends proper messages to mainform for sync
        // 1. Search Library for dead files
        Function CollectDeadFiles: Boolean;
        // 2. Prepare Update
        //    - Fill tmplists with files, which are NOT dead
        procedure PrepareDeleteFilesUpdate;
        // 3. Send Message and do
        //    CleanUpDeadFilesFromVCLLists
        //    in VCL-Thread
        // 4. Delete DeadFiles
        procedure CleanUpDeadFiles;

        // Refreshing Library
        procedure fRefreshFiles;      // 1a. Refresh files OR
        procedure fGetLyrics;         // 1b. get Lyrics
        procedure fGetTags;           // 1c. get Tags (from LastFM)
        procedure fUpdateId3tags;     // 2.  Write Library-Data into the id3-Tags (used in CloudEditor)
        procedure fBugFixID3Tags;     // BugFix-Method

        // ControlRawTag. Result: The new rawTag for the audiofile, including the previous existing
        function ControlRawTag(af: TAudioFile; newTags: String; aIgnoreList: TStringList; aMergeList: TObjectList): String;

        // General Note:
        // "Artist" and "Album" are not necessary the artist and album, but
        // the two AudioFile-Properties selected for  browsing.
        // "Artist" ist the primary property (left), "Album" the secondary (right)

        // Get all Artists from the Library
        procedure GenerateArtistList(Source: TObjectlist; Target: TObjectlist);
        // Get all Albums from the Library
        procedure InitAlbenlist(Source: TObjectlist; Target: TStringList);
        // Get a Name-Sorted list of all Playlists
        // Note: No source-target-Parameter, as these lists are rather small.
        // No threaded tmp-list stuff needed here.
        // => call it AFTER swaplists
        procedure InitPlayListsList;
        // Get all Cover from the Library (TNempCover, used for browsing)
        procedure GenerateCoverList(Source: TObjectlist; Target: TObjectlist);

        // Helper for Browsing Between
        // "Start" and "Ende" are the files with the wanted "Name"
        procedure GetStartEndIndex(Liste: TObjectlist; name: UnicodeString; Suchart: integer; var Start: integer; var Ende: Integer);
        procedure GetStartEndIndexCover(Liste: TObjectlist; aCoverID: String; var Start: integer; var Ende: Integer);

        // Helper for "FillRandomList"
        function CheckYearRange(Year: UnicodeString): Boolean;
        //function CheckGenrePL(Genre: UnicodeString): Boolean;
        function CheckRating(aRating: Byte): Boolean;
        function CheckLength(aLength: Integer): Boolean;
        function CheckTags(aTagList: TObjectList): Boolean;

        // Synch a List of TDrives with the current situation on the PC
        // i.e. Search the Drive-IDs in the system and adjust the drive-letters
        procedure SynchronizeDrives(Source: TObjectList);
        // Check whether drive has changed after a new device has been connected
        function DrivesHaveChanged: Boolean;

        // Saving/loading the *.gmp-File
        procedure LoadDrivesFromStream(aStream: TStream);
        procedure SaveDrivesToStream(aStream: TStream);

        procedure LoadAudioFilesFromStream(aStream: TStream);
        procedure SaveAudioFilesToStream(aStream: TStream);

        procedure LoadPlaylistsFromStream(aStream: TStream);
        procedure SavePlaylistsToStream(aStream: TStream);

        procedure LoadRadioStationsFromStream(aStream: TStream);
        procedure SaveRadioStationsToStream(aStream: TStream);

        procedure LoadFromFile4(aStream: TStream);

    public
        // Some Beta-Options
        BetaDontUseThreadedUpdate: Boolean;

        // Diese Objekte werden in der linken Vorauswahlspalte angezeigt.
        AlleArtists: TObjectList;
        tmpAlleArtists: TObjectList;

        Coverlist: tObjectList;
        tmpCoverlist: tObjectList;

        // Die Alben, die in der rechten Vorauswahl-Spalte angezeigt werden.
        // wird im Onchange der linken Spalte aktualisiert
        Alben: TObjectList;

        // Liste, die unten in der Liste angezeigt wird.
        // wird generiert über Onchange der Vorauswahl, oder aber von der Such-History
        // Achtung: Auf diese NUR IM VCL-HAUPTTHREAD zugreifen !!
        AnzeigeListe: TObjectList; // Speichert die Liste, die gerade im Tree angezeigt wird.
        AnzeigeListe2: TObjectList; // Speichert zusätzliche QuickSearch-Resultate.
        // Flag, was für Dateien in der Playlist sind
        // Muss bei jeder Änderung der AnzeigeListe gesetzt werden
        // Zusätzlich dürfen Dateien aus der AnzeigeListe ggf. nicht in andere Listen gehängt werden.
        AnzeigeShowsPlaylistFiles: Boolean;

        // Liste für die Webradio-Stationen
        // Darauf greift auch die Stream-Verwaltung-Form zu
        // Objekte darin sind von Typ TStation
        RadioStationList: TObjectlist;

        // Liste, in die die neu einzupflegenden Dateien kommen
        // Auf diese Liste greift Searchtool zu, wenn die Platte durchsucht wird,
        // und auch die Laderoutine
        UpdateList: TObjectlist;

        // Sammelt während eines Updates die neuen Playlist-Dateien
        PlaylistUpdateList: TObjectList;

        // Speichert die zu durchsuchenden Ordner für SearchTool
        ST_Ordnerlist: TStringList;

        PlaylistFillOptions: TPlaylistFillOptions;

        // Optionen, die aus der Ini kommen/gespeichert werden müssen
        NempSortArray: TNempSortArray;
        IncludeAll: Boolean;
        IncludeFilter: String; // a string like "*.mp3;*.ogg;*.wma" - replaces the old Include*-Vars
        
        AutoLoadMediaList: Boolean;
        AutoSaveMediaList: Boolean;
        alwaysSortAnzeigeList: Boolean;
        SkipSortOnLargeLists: Boolean;
        AnzeigeListIsCurrentlySorted: Boolean;
        AutoScanPlaylistFilesOnView: Boolean;
        ShowHintsInMedialist: Boolean;
        NempCharCodeOptions: TConvertOptions;
        AutoScanDirs: Boolean;
        AutoScanDirList: TStringList;
        // Die Todo-List enthält die, die ggf. bei "Newdrive" gescannt werden müsssem.
        // Also die, die ncoh nicht gescannt wurden.
        AutoScanToDoList: TStringList;

        // Bei neuen Ordnern (per Drag&Drop o.ä.) Dialog anzeigen, ob sie in die Auto-Liste eingefügt werden sollen
        AskForAutoAddNewDirs: Boolean;
        // Automatisch neue Ordner in die Scanlist einfügen
        AutoAddNewDirs: Boolean;

        AutoActivateWebServer: Boolean;

         // Optionen für die Coversuche
        CoverSearchInDir: Boolean;
        CoverSearchInParentDir: Boolean;
        CoverSearchInSubDir: Boolean;
        CoverSearchInSisterDir: Boolean;
        CoverSearchSubDirName: UnicodeString;
        CoverSearchSisterDirName: UnicodeString;
        CoverSearchLastFM: Integer;
        CoverSearchLastFMInit: Boolean;  // used for the first "do you want this"-message on first start
        HideNACover: Boolean;
        // Einstellungen für Standard-Cover
        // Eines für alle. Ist eins nicht da: Fallback auf Default
        //UseNempDefaultCover: Boolean;
        //PersonalizeMainCover: Boolean;

        // Fürs Detail-Fenster:
        WriteRatingToTag: Boolean;

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

        TagCloud: TTagCloud;
        // BibScrobbler: Link to Player.NempScrobbler
        BibScrobbler: TNempScrobbler;

        property StatusBibUpdate   : Integer read GetStatusBibUpdate    write SetStatusBibUpdate;

        property Count: Integer read GetCount;

        property CurrentArtist: UnicodeString read fArtist write fArtist;
        property CurrentAlbum: UnicodeString read fAlbum write fAlbum;
//        property CurrentCoverID: String read fCurrentCoverID write fCurrentCoverID;
//        property CurrentCoverIDX: Integer read fCurrentCoverIDX write fCurrentCoverIDX;

        property ArtistIndex: Cardinal read fArtistIndex write fArtistIndex;
        property AlbumIndex: Cardinal read fAlbumIndex write fAlbumIndex;
        property Changed: LongBool read GetChanged write SetChanged;
        property ChangeAfterUpdate: LongBool read GetChangeAfterUpdate write SetChangeAfterUpdate;
        property Initializing: Integer read GetInitializing write SetInitializing;
        property BrowseMode: Integer read GetBrowseMode write SetBrowseMode;
        property CoverSortOrder: Integer read GetCoverSortOrder write SetCoverSortOrder;

        property UpdateFortsetzen: LongBool read GetUpdateFortsetzen Write SetUpdateFortsetzen;

        property SavePath: UnicodeString read fSavePath write fSavePath;
        property CoverSavePath: UnicodeString read fCoverSavePath write fCoverSavePath;

        // Basic Operations. Create, Destroy, Clear, Copy
        constructor Create(aWnd: DWord; CFHandle: DWord);
        destructor Destroy; override;
        procedure Clear;
        // Copy The Files from the Library for use in WebServer
        // Note: WebServer will run multiple threads, but read-access only.
        //       Sync with main program will be complicated, so the webserver uses
        //       a copy of the list.
        procedure CopyLibrary(dest: TObjectlist; var CurrentMaxID: Integer);
        // Load/Save options into IniFile
        procedure LoadFromIni(ini: TMemIniFile);
        procedure WriteToIni(ini: TMemIniFile);

        // Managing the Library
        // - Merging new Files into the library (Param NewBib=True on loading a new library
        //                                       false otherwise)
        // - Delete not existing files
        // - Refresh AudioFile-Information
        // - Automatically get Lyrics from LyricWiki.org
        // These methods will start a new thread and call several private methods
        procedure NewFilesUpdateBib(NewBib: Boolean = False);
        procedure DeleteFilesUpdateBib;
        procedure CleanUpDeadFilesFromVCLLists;
        procedure RefreshFiles;
        procedure GetLyrics;
        procedure GetTags;
        procedure UpdateId3tags;
        procedure BugFixID3Tags;

        // Additional managing. Run in VCL-Thread.
        procedure BuildTotalString;
        procedure BuildTotalLyricString;
        function DeleteAudioFile(aAudioFile: tAudioFile): Boolean;
        function DeletePlaylist(aPlaylist: TJustAString): Boolean;
        procedure Abort;        // abort running update-threads
        procedure ResetRatings;
        // Check, whether Key1 and Key2 matches strings[sortarray[1/2]]
        function ValidKeys(aAudioFile: TAudioFile): Boolean;
        // Not needed any longer
        // function RestoreSortOrderAfterItemChanged(aAudioFile: tAudioFile): Boolean;


        // Check, whether AudioFiles already exists in the library.
        function AudioFileExists(aFilename: UnicodeString): Boolean;
        function GetAudioFileWithFilename(aFilename: UnicodeString): TAudioFile;
        function PlaylistFileExists(aFilename: UnicodeString): Boolean;

        // Initializing Cover-Information
        // This is not done by the AudioFile-Class for reason of performance.
        // 1. Search a Cover for the AudioFile
        //    if the new file is in the same directory as the last one,
        //    the method will use the last cover for this one, too
        //    (except there is one in the id3-tag of the file)

        // Copy a CoverFile to Cover\<md5-Hash(File)>
        // returnvalue: the MD5-Hash (i.e. filename of the resized cover)
        function InitCoverFromFilename(aFileName: UnicodeString): String;
        procedure InitCover(aAudioFile: tAudioFile);
        // 2. If AudioFile is in a new directory:
        //    Get a List with candidates for the cover for the audiofile
        procedure GetCoverListe(aAudioFile: tAudioFile; aCoverListe: TStringList);
        // Reset internal variables fLastPath, fLastCoverID, ...
        procedure ReInitCoverSearch;

        // Methods for Browsing in the Library
        // 1. Generate BrowseLists
        //    see private methods, called during update-process
        // 2. Regenerate BrowseLists
        Procedure ReBuildBrowseLists;     // Complete Rebuild
        procedure ReBuildCoverList;       // -"- of CoverLists
        procedure ReBuildTagCloud;        // -"- of the TagCloud
        procedure GetTopTags(ResultCount: Integer; Offset: Integer; Target: TObjectList);
        procedure RestoreTagCloudNavigation;
        procedure RepairBrowseListsAfterDelete; // Rebuild, but sorting is not needed
        procedure RepairBrowseListsAfterChange; // Another Repair-method :?
        // 3. When Browsing the left tree, fill the right tree
        procedure GetAlbenList(Artist: UnicodeString);
        // 4. Get from a selected pair of "Artist"-"Album" the matching titles
        Procedure GetTitelList(Target: TObjectlist; Artist: UnicodeString; Album: UnicodeString);
        // Ruft nur GetTitelList auf, mit Target = AnzeigeListe
        // NUR IM VCL_HAUPTTHREAD benutzen
        Procedure GenerateAnzeigeListe(Artist: UnicodeString; Album: UnicodeString; UpdateQuickSearchList: Boolean = True);
        // wie oben, nur wirdf hier nur auf eine der großen Listen zugegriffen
        // und die Sortierung ist immer nach CoverID, kein zweites Kriterium möglich.
        procedure GetTitelListFromCoverID(Target: TObjectlist; aCoverID: String);
        procedure GenerateAnzeigeListeFromCoverID(aCoverID: String);
        procedure GenerateAnzeigeListeFromTagCloud(aTag: TTag; BuildNewCloud: Boolean);
        // Search the next matching cover
        function GetCoverWithPrefix(aPrefix: UnicodeString; Startidx: Integer): Integer;


        // Methods for searching
        // See BibSearcherClass for Details.
        Procedure ShowQuickSearchList;  // Displays the QuicksearchList
        procedure FillQuickSearchList;  // Set the currently displayed List as QuickSearchList
        // Searching for keywords
        // a. Quicksearch
        procedure GlobalQuickSearch(Keyword: UnicodeString; AllowErr: Boolean);
        // b. detailed search
        procedure CompleteSearch(Keywords: TSearchKeyWords);
        // c. get all files from the library in the same directory
        procedure GetFilesInDir(aDirectory: UnicodeString);

        // Sorting the Lists
        procedure AddSorter(TreeHeaderColumnTag: Integer; FlipSame: Boolean = True);
        procedure SortAList(aList: TObjectList);
        procedure SortAnzeigeListe;

        // Generating RandomList (Random Playlist)
        procedure FillRandomList(aList: TObjectlist);

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

        // Saving/Loading
        // a. Export as CSV, to get the library to Excel or whatever.
        function SaveAsCSV(aFilename: UnicodeString): Boolean;
        // b. Loading/Saving the *.gmp-File
        // will call several private methods
        procedure SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
        procedure LoadFromFile(aFilename: UnicodeString);

        function CountInconsistentFiles: Integer;      // Count "ID3TagNeedsUpdate"-AudioFiles
        procedure PutInconsistentFilesToUpdateList;    // Put these files into the updatelist
        procedure PutAllFilesToUpdateList;    // Put these files into the updatelist

  end;

  Procedure fNewFilesUpdate(MB: TMedienbibliothek);
  Procedure fDeleteFilesUpdate(MB: TMedienbibliothek);
  procedure fRefreshFilesThread(MB: TMedienbibliothek);
  procedure fGetLyricsThread(MB: TMedienBibliothek);
  procedure fGetTagsThread(MB: TMedienBibliothek);

  procedure fUpdateID3TagsThread(MB: TMedienBibliothek);
  procedure fBugFixID3TagsThread(MB: TMedienBibliothek);


  function GetProperMenuString(aIdx: Integer): UnicodeString;

  var //CSStatusChange: RTL_CRITICAL_SECTION;
      CSUpdate: RTL_CRITICAL_SECTION;
      CSAccessDriveList: RTL_CRITICAL_SECTION;


implementation

uses fspTaskBarMgr, TagHelper;

function GetProperMenuString(aIdx: Integer): UnicodeString;
begin
    case aIdx of

    0: result := MainForm_MenuCaptionsPlayAllArtist   ;
    1: result := MainForm_MenuCaptionsPlayAllAlbum    ;
    2: result := MainForm_MenuCaptionsPlayAllDirectory;
    3: result := MainForm_MenuCaptionsPlayAllGenre    ;
    4: result := MainForm_MenuCaptionsPlayAllYear     ;
    else result := '(?)'
    end;
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
  MainWindowHandle := aWnd;

  Mp3ListePfadSort   := TObjectlist.Create(False);
  Mp3ListeArtistSort := TObjectList.create(False);
  Mp3ListeAlbenSort  := TObjectlist.create(False);
  tmpMp3ListePfadSort   := TObjectlist.Create(False);
  tmpMp3ListeArtistSort := TObjectList.create(False);
  tmpMp3ListeAlbenSort  := TObjectlist.create(False);

  DeadFiles := TObjectlist.create(False);
  DeadPlaylists := TObjectlist.create(False);

  AlleAlben := TStringList.Create;
  tmpAlleAlben := TStringList.Create;
  AlleArtists  := TObjectlist.create(False);
  tmpAlleArtists  := TObjectlist.create(False);
  Coverlist := tObjectList.create(False);
  tmpCoverlist := tObjectList.create(False);

  Alben        := TObjectlist.create(False);
  AnzeigeListe := TObjectlist.create(False);
  AnzeigeListe2 := TObjectlist.create(False);

  AnzeigeShowsPlaylistFiles := False;

  BibSearcher := TBibSearcher.Create(aWnd);

  RadioStationList    := TObjectlist.Create;
  UpdateList   := TObjectlist.create(False);
  ST_Ordnerlist := TStringList.Create;
  AutoScanDirList := TStringList.Create;
  AutoScanDirList.Sorted := True;
  AutoScanToDoList := TStringList.Create;

  fUsedDrives := TObjectList.Create;

  PlaylistFiles := TObjectList.Create(True);
  tmpAllPlaylistsPfadSort := TObjectList.Create(False);
  AllPlaylistsPfadSort := TObjectList.Create(False);
  AllPlaylistsNameSort := TObjectList.Create(False);
  PlaylistUpdateList := TObjectList.Create(False);

  NempSortArray[1] := siOrdner;//Artist;
  NempSortArray[2] := siArtist;

  //SortParam := CON_ARTIST;
  //SortAscending := True;
  Changed := False;
  Initializing := init_nothing;

  CurrentArtist := BROWSE_ALL;
  CurrentAlbum := BROWSE_ALL;
  //CurrentCoverID  := 'all';
  //CurrentCoverIDX := 0;
  for i := 0 to SORT_MAX  do
        begin
            SortParams[i].Comparefunction := AFComparePath;
            SortParams[i].Direction := sd_Ascending;
            SortParams[i].Tag := CON_PFAD;
        end;

  NewCoverFlow := TNempCoverFlow.Create;// (CFHandle, aWnd);

  TagCloud := TTagCloud.Create;
end;
destructor TMedienBibliothek.Destroy;
var i: Integer;
begin
  NewCoverFlow.Clear;
  NewCoverFlow.free;

  TagCloud.Free;

  for i := 0 to Mp3ListePfadSort.Count - 1 do
    TAudioFile(Mp3ListePfadSort[i]).Free;

  Mp3ListePfadSort.Free;
  Mp3ListeArtistSort.Free;
  Mp3ListeAlbenSort.Free;

  tmpMp3ListePfadSort.Free;
  tmpMp3ListeArtistSort.Free;
  tmpMp3ListeAlbenSort.Free;

  DeadFiles.Free;
  DeadPlaylists.Free;

  AlleAlben.Free;
  tmpAlleAlben.Free;

  for i := 0 to tmpAlleArtists.Count - 1 do
    TJustaString(tmpAlleArtists[i]).Free;
  for i := 0 to AlleArtists.Count - 1 do
    TJustaString(AlleArtists[i]).Free;
  for i := 0 to Alben.Count - 1 do
    TJustaString(Alben[i]).Free;
  for i := 0 to Coverlist.Count - 1 do
    TNempCover(CoverList[i]).Free;
  for i := 0 to tmpCoverlist.Count - 1 do
    TNempCover(tmpCoverlist[i]).Free;
  for i := 0 to AllPlaylistsPfadSort.Count - 1 do
      TJustaString(AllPlaylistsPfadSort[i]).Free;

  AutoScanDirList.Free;
  AutoScanToDoList.Free;
      EnterCriticalSection(CSAccessDriveList);
      fUsedDrives.Free;
      LeaveCriticalSection(CSAccessDriveList);
  PlaylistFiles.Free;
  tmpAllPlaylistsPfadSort.Free;
  AllPlaylistsNameSort.Free;
  AllPlaylistsPfadSort.Free;

  RadioStationList.Free;

  tmpAlleArtists.Free;
  AlleArtists.Free;
  Alben.Free;
  AnzeigeListe.Free;
  AnzeigeListe2.Free;

  UpdateList.Free;
  PlaylistUpdateList.Free;
  ST_Ordnerlist.Free;
  tmpCoverlist.Free;
  Coverlist.Free;
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
  for i := 0 to Mp3ListePfadSort.Count - 1 do
    TAudioFile(Mp3ListePfadSort[i]).Free;

  Mp3ListePfadSort.Clear;
  Mp3ListeArtistSort.Clear;
  Mp3ListeAlbenSort.Clear;
  tmpMp3ListePfadSort.Clear;
  tmpMp3ListeArtistSort.Clear;
  tmpMp3ListeAlbenSort.Clear;
  DeadFiles.Clear;
  DeadPlaylists.Clear;

  UpdateList.Clear;
  PlaylistUpdateList.Clear;
  ST_Ordnerlist.Clear;

  EnterCriticalSection(CSAccessDriveList);
  fUsedDrives.Clear;
  LeaveCriticalSection(CSAccessDriveList);

  AlleAlben.Clear;
  tmpAlleAlben.Clear;

  for i := 0 to tmpAlleArtists.Count - 1 do
    TJustaString(tmpAlleArtists[i]).Free;
  for i := 0 to AlleArtists.Count - 1 do
    TJustaString(AlleArtists[i]).Free;
  for i := 0 to Alben.Count - 1 do
    TJustaString(Alben[i]).Free;
  for i := 0 to Coverlist.Count - 1 do
    TNempCover(CoverList[i]).Free;
  for i := 0 to tmpCoverlist.Count - 1 do
    TNempCover(tmpCoverlist[i]).Free;
  for i := 0 to AllPlaylistsPfadSort.Count - 1 do
      TJustaString(AllPlaylistsPfadSort[i]).Free;

  tmpAllPlaylistsPfadSort.Clear;
  AllPlaylistsPfadSort.Clear;
  AllPlaylistsNameSort.Clear;
  PlaylistFiles.Clear;
  tmpAlleArtists.Clear;
  AlleArtists.Clear;
  Alben.Clear;
  AnzeigeListe.Clear;
  AnzeigeListe2.Clear;
  AnzeigeShowsPlaylistFiles := False;

  BibSearcher.Clear;
  Coverlist.Clear;
  tmpCoverlist.Clear;

  NewCoverFlow.clear;

  ClearRandomCover;
  RadioStationList.Clear;
  RepairBrowseListsAfterDelete;
  AnzeigeListIsCurrentlySorted := False;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
end;
{
    --------------------------------------------------------
    CopyLibrary
    - Copy the list for use in Webserver
    --------------------------------------------------------
}
procedure TMedienBibliothek.CopyLibrary(dest: TObjectlist; var CurrentMaxID: Integer);
var i: Integer;
    newAF, AF: TAudioFile;
begin
  if StatusBibUpdate <> BIB_Status_ReadAccessBlocked then
  begin
      dest.Clear;
      dest.Capacity := Mp3ListePfadSort.Count;
      for i := 0 to Mp3ListePfadSort.Count - 1 do
      begin
          AF := TAudioFile(Mp3ListePfadSort[i]);
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
        if TAudioFile(Mp3ListePfadSort[i]).ID3TagNeedsUpdate then
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
        if TAudioFile(MP3ListePfadSort[i]).ID3TagNeedsUpdate then
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
function TMedienBibliothek.GetInitializing: Integer;
begin
  InterLockedExchange(Result, fInitializing);
end;
procedure TMedienBibliothek.SetInitializing(Value: Integer);
begin
  InterLockedExchange(fInitializing, Value);
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

{
    --------------------------------------------------------
    LoadFromIni
    SaveToIni
    Load/Save the settings into the IniFile
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadFromIni(ini: TMemIniFile);
var tmpcharcode, dircount, i: integer;
    tmp: UnicodeString;
    so, sd: Integer;
begin
        BetaDontUseThreadedUpdate := Ini.ReadBool('Beta', 'DontUseThreadedUpdate', False);

        NempSortArray[1] := TAudioFileStringIndex(Ini.ReadInteger('MedienBib', 'Vorauswahl1', integer(siArtist)));
        NempSortArray[2] := TAudioFileStringIndex(Ini.ReadInteger('MedienBib', 'Vorauswahl2', integer(siAlbum)));

        if (NempSortArray[1] > siJahr) OR (NempSortArray[2] > siJahr) or
           (NempSortArray[1] < siArtist) OR (NempSortArray[2] < siArtist)then
        begin
          NempSortArray[1] := siArtist;
          NempSortArray[2] := siAlbum;
        end;

        AlwaysSortAnzeigeList := ini.ReadBool('MedienBib', 'AlwaysSortAnzeigeList', False);
        SkipSortOnLargeLists  := ini.ReadBool('MedienBib', 'SkipSortOnLargeLists', True);
        AutoScanPlaylistFilesOnView := ini.ReadBool('MedienBib', 'AutoScanPlaylistFilesOnView', True);
        ShowHintsInMedialist := ini.ReadBool('Medienbib', 'ShowHintsInMedialist', True);

        for i := SORT_MAX downto 0 do
        begin
            so := Ini.ReadInteger('MedienBib', 'Sortorder' + IntToStr(i), CON_PFAD);
            self.AddSorter(so, False);
            sd := Ini.ReadInteger('MedienBib', 'SortMode' + IntToStr(i), Integer(sd_Ascending));
            if sd = Integer(sd_Ascending) then
                SortParams[i].Direction := sd_Ascending
            else
                SortParams[i].Direction := sd_Descending;
        end;


        //SortParam := Ini.ReadInteger('MedienBib', 'Sortorder', CON_ARTIST);

        CoverSearchInDir         := ini.ReadBool('MedienBib','CoverSearchInDir', True);
        CoverSearchInParentDir   := ini.ReadBool('MedienBib','CoverSearchInParentDir', True);
        CoverSearchInSubDir      := ini.ReadBool('MedienBib','CoverSearchInSubDir', True);
        CoverSearchInSisterDir   := ini.ReadBool('MedienBib', 'CoverSearchInSisterDir', True);
        CoverSearchSubDirName    := ini.ReadString('MedienBib', 'CoverSearchSubDirName', 'cover');
        CoverSearchSisterDirName := ini.ReadString('MedienBib', 'CoverSearchSisterDirName', 'cover');
        CoverSearchLastFM        := ini.ReadInteger('MedienBib', 'CoverSearchLastFM', BoolUnDef);
        CoverSearchLastFMInit    := True;

        HideNACover := ini.ReadBool('MedienBib', 'HideNACover', False);
        //UseNempDefaultCover      := Ini.ReadBool('MedienBib', 'UseNempDefaultCover', True);
        //PersonalizeMainCover     := Ini.ReadBool('MedienBib', 'PersonalizeMainCover', True);

        WriteRatingToTag := Ini.ReadBool('MedienBib','WriteRatingToTag', False);

        BrowseMode     := Ini.ReadInteger('MedienBib', 'BrowseMode', 0);
        if (BrowseMode < 0) OR (BrowseMode > 2) then
          BrowseMode := 0;
        CoverSortOrder := Ini.ReadInteger('MedienBib', 'CoverSortOrder', 1);
        if (CoverSortOrder < 1) OR (CoverSortOrder > 7) then
          CoverSortorder := 1;

        IncludeAll := ini.ReadBool('MedienBib', 'other', True);
        IncludeFilter := Ini.ReadString('MedienBib', 'includefilter', '*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.wma');
        AutoLoadMediaList := ini.ReadBool('MedienBib', 'autoload', True);
        AutoSaveMediaList := ini.ReadBool('MedienBib', 'autosave', AutoLoadMediaList);

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetGreek', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 1) then tmpcharcode := 0;
        NempCharCodeOptions.Greek := GreekEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetCyrillic', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Cyrillic := CyrillicEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetHebrew', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Hebrew := HebrewEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetArabic', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 2) then tmpcharcode := 0;
        NempCharCodeOptions.Arabic := ArabicEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetThai', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Thai := ThaiEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetKorean', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Korean := KoreanEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetChinese', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 1) then tmpcharcode := 0;
        NempCharCodeOptions.Chinese := ChineseEncodings[tmpcharcode];

        tmpcharcode := ini.ReadInteger('MedienBib', 'CharSetJapanese', 0);
        if (tmpcharcode < 0) or (tmpcharcode > 0) then tmpcharcode := 0;
        NempCharCodeOptions.Japanese := JapaneseEncodings[tmpcharcode];

        NempCharCodeOptions.AutoDetectCodePage := ini.ReadBool('MedienBib', 'AutoDetectCharCode', True);
        NempCharCodeOptions.AlwaysWriteUnicode := ini.ReadBool('MedienBib', 'AlwaysWriteUnicode', False);

        AutoScanDirs := Ini.ReadBool('MedienBib', 'AutoScanDirs', True);
        AskForAutoAddNewDirs  := Ini.ReadBool('MedienBib', 'AskForAutoAddNewDirs', True);
        AutoAddNewDirs        := Ini.ReadBool('MedienBib', 'AutoAddNewDirs', True);

        dircount := Ini.ReadInteger('MedienBib', 'dircount', 0);
        for i := 1 to dircount do
        begin
            tmp := Ini.ReadString('MedienBib', 'ScanDir' + IntToStr(i), '');
            if trim(tmp) <> '' then
                AutoScanDirList.Add(IncludeTrailingPathDelimiter(tmp));
        end;

        AutoActivateWebServer := Ini.ReadBool('MedienBib', 'AutoActivateWebServer', False);

        NewCoverFlow.Mode := TCoverFlowMode(ini.ReadInteger('MedienBib', 'CoverFlowMode', Integer(cm_OpenGL)));

        CurrentArtist := Ini.ReadString('MedienBib','SelectedArtist', BROWSE_ALL);
        CurrentAlbum := Ini.ReadString('MedienBib','SelectedAlbum', BROWSE_ALL);
        NewCoverFlow.CurrentCoverID := Ini.ReadString('MedienBib','SelectedCoverID', 'all');
        NewCoverFlow.CurrentItem    := ini.ReadInteger('MedienBib', 'SelectedCoverIDX', 0);

        BibSearcher.LoadFromIni(ini);
        TagCloud.LoadFromIni(ini);
end;
procedure TMedienBibliothek.WriteToIni(ini: TMemIniFile);
var i: Integer;
begin
        Ini.WriteBool('Beta', 'DontUseThreadedUpdate', BetaDontUseThreadedUpdate);

        Ini.WriteInteger('MedienBib', 'Vorauswahl1', integer(NempSortArray[1]));
        Ini.WriteInteger('MedienBib', 'Vorauswahl2', integer(NempSortArray[2]));
        ini.WriteBool('MedienBib', 'AlwaysSortAnzeigeList', AlwaysSortAnzeigeList);
        ini.WriteBool('MedienBib', 'SkipSortOnLargeLists', SkipSortOnLargeLists);

        ini.WriteBool('MedienBib', 'AutoScanPlaylistFilesOnView', AutoScanPlaylistFilesOnView);
        ini.WriteBool('Medienbib', 'ShowHintsInMedialist', ShowHintsInMedialist);

        for i := SORT_MAX downto 0 do
        begin
            Ini.WriteInteger('MedienBib', 'Sortorder' + IntToStr(i), SortParams[i].Tag);
            Ini.WriteInteger('MedienBib', 'SortMode' + IntToStr(i), Integer(SortParams[i].Direction));
        end;

        ini.Writebool('MedienBib','CoverSearchInDir', CoverSearchInDir);
        ini.Writebool('MedienBib','CoverSearchInParentDir', CoverSearchInParentDir);
        ini.Writebool('MedienBib','CoverSearchInSubDir', CoverSearchInSubDir);
        ini.Writebool('MedienBib', 'CoverSearchInSisterDir', CoverSearchInSisterDir);
        ini.WriteString('MedienBib', 'CoverSearchSubDirName', (CoverSearchSubDirName));
        ini.WriteString('MedienBib', 'CoverSearchSisterDirName', (CoverSearchSisterDirName));
        ini.WriteInteger('MedienBib', 'CoverSearchLastFM', CoverSearchLastFM);
        ini.WriteBool('MedienBib', 'HideNACover', HideNACover);
        //Ini.WriteBool('MedienBib', 'UseNempDefaultCover', UseNempDefaultCover);
        //Ini.WriteBool('MedienBib', 'PersonalizeMainCover', PersonalizeMainCover);

        Ini.Writebool('MedienBib','WriteRatingToTag', WriteRatingToTag);

        ini.WriteBool('MedienBib', 'other', IncludeAll);
        ini.WriteString('MedienBib', 'includefilter', IncludeFilter);
        ini.WriteBool('MedienBib', 'autoload', AutoLoadMediaList);
        ini.WriteBool('MedienBib', 'autosave', AutoSaveMediaList);

        ini.WriteInteger('MedienBib', 'CharSetGreek', NempCharCodeOptions.Greek.Index);
        ini.WriteInteger('MedienBib', 'CharSetCyrillic', NempCharCodeOptions.Cyrillic.Index);
        ini.WriteInteger('MedienBib', 'CharSetHebrew', NempCharCodeOptions.Hebrew.Index);
        ini.WriteInteger('MedienBib', 'CharSetArabic', NempCharCodeOptions.Arabic.Index);
        ini.WriteInteger('MedienBib', 'CharSetThai', NempCharCodeOptions.Thai.Index);
        ini.WriteInteger('MedienBib', 'CharSetKorean', NempCharCodeOptions.Korean.Index);
        ini.WriteInteger('MedienBib', 'CharSetChinese', NempCharCodeOptions.Chinese.Index);
        ini.WriteInteger('MedienBib', 'CharSetJapanese', NempCharCodeOptions.Japanese.Index);
        ini.WriteBool('MedienBib', 'AutoDetectCharCode', NempCharCodeOptions.AutoDetectCodePage);
        ini.WriteBool('MedienBib', 'AlwaysWriteUnicode', NempCharCodeOptions.AlwaysWriteUnicode);

        Ini.WriteBool('MedienBib', 'AutoScanDirs', AutoScanDirs);
        Ini.WriteInteger('MedienBib', 'dircount', AutoScanDirList.Count);
        Ini.WriteBool('MedienBib', 'AskForAutoAddNewDirs', AskForAutoAddNewDirs);
        Ini.WriteBool('MedienBib', 'AutoAddNewDirs', AutoAddNewDirs);
        Ini.WriteBool('MedienBib', 'AutoActivateWebServer', AutoActivateWebServer);

        ini.WriteInteger('MedienBib', 'BrowseMode', fBrowseMode);
        ini.WriteInteger('MedienBib', 'CoverSortOrder', fCoverSortOrder);

        for i := 0 to AutoScanDirList.Count -1  do
            Ini.WriteString('MedienBib', 'ScanDir' + IntToStr(i+1), AutoScanDirList[i]);

        Ini.WriteString('MedienBib','SelectedArtist', CurrentArtist);
        Ini.WriteString('MedienBib','SelectedAlbum', CurrentAlbum);
        Ini.WriteString('MedienBib','SelectedCoverID', NewCoverFlow.CurrentCoverID);
        Ini.WriteInteger('MedienBib', 'SelectedCoverIDX', NewCoverFlow.CurrentItem);

         ini.WriteInteger('MedienBib', 'CoverFlowMode', Integer(NewCoverFlow.Mode));


        BibSearcher.SaveToIni(Ini);
        TagCloud.SaveToIni(Ini);
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
  if BetaDontUseThreadedUpdate then
  begin
      fNewFilesUpdate(self);
      fHND_UpdateThread := 0;
  end
  else
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
  if (MB.UpdateList.Count > 0) or (MB.PlaylistUpdateList.Count > 0) then
  begin                        // status: Temporary comments, as I found a concept-bug here ;-)
    MB.PrepareNewFilesUpdate;  // status: ok (no StatusChange needed)
    MB.SwapLists;              // status: ok (StatusChange via SendMessage)
    MB.CleanUpTmpLists;        // status: ok (No StatusChange allowed)
    if MB.ChangeAfterUpdate then
        MB.Changed := True;
  end else
  begin
      SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
  end;

  //MB.StatusBibUpdate := 0;         // note: This is dangerous
  {$Message Hint 'STATUS MUST NOT be set to zero here, unless it is sure that this ends here '}
  /// status-Comment: The only problem is AutoScanDirs files.
  ///  If AutoScanDirs do not call NewFilesUpdate (because there are no new files)
  ///  ///  NO. NewFilesUpdate is called everytime on ST_Finish, whether there are 0 files or not.
  ///  the status remains BIB_Status_ReadAccessBlocked
  ///  This would be fatal.


  case MB.Initializing of
      init_nothing: begin
          if MB.AutoScanDirs then
          begin
              MB.Initializing := init_AutoScanDir;
              SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_StartAutoScanDirs, 0);
              // Scanning is done in a separate thread.
              // Problem: Another Thread (VCL, in preparation for Player.PostProcess)
              //          could have gotten the Status=0 from above and start working
              //          before the Message (StartAutoScan) was processed
              //          So two Threads will work on the Library!!
          end else
          begin
              // Not really "Complete", but after this we have nothing more special to do here
              MB.Initializing := Init_Complete;
              // No Autoscan wanted, but maybe we want to activate the WebServer now.
              if MB.AutoActivateWebServer then
              begin
                  SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_ActivateWebServer, 0);
                  // Activation is done in VCL-Thread.
                  // So the WebServer IS activated when SendMessage returns
              end;
              SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
          end;
      end;
      init_AutoScanDir: begin
          // AutoScandir has been completed, so WebServer-Activation is the next thing to do.
          if MB.AutoActivateWebServer then
          begin
              MB.Initializing := Init_Complete;
              SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_ActivateWebServer, 0);
              // Activation is done in VCL-Thread.
              // So the WebServer IS activated when SendMessage returns
          end;
          MB.Initializing := Init_Complete;
          SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
      end;
      init_complete: begin
          // nothing more to do.
          SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
      end;
  end;

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
var i,d: Integer;
    aAudioFile: TAudioFile;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);

  UpdateList.Sort(Sortieren_Pfad_asc);
  Merge(UpdateList, Mp3ListePfadSort, tmpMp3ListePfadSort, SO_Pfad, NempSortArray);
  PlaylistUpdateList.Sort(PlaylistSort_Pfad);
  MergePlaylists(PlaylistUpdateList, AllPlaylistsPfadSort, tmpAllPlaylistsPfadSort);

  if ChangeAfterUpdate then
  begin
      // i.e. new files, not from a *.gmp-File
      // Collect information of used Drives
      AddUsedDrivesInformation(UpdateList, PlaylistUpdateList);
  end;

  // Build proper Browse-Lists
  case BrowseMode of
      0: begin
          // Classic Browsing: Artist-Album (or whatever the user wanted)
          UpdateList.Sort(Sortieren_String1String2Titel_asc);

          if fBrowseListsNeedUpdate then
          begin
              // We need Block-READ-access in this case here!
              SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
              // Set the status of the library to Readaccessblocked
              SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_ReadAccessBlocked);
          end;

          if fBrowseListsNeedUpdate then
              Mp3ListeArtistSort.Sort(Sortieren_String1String2Titel_asc);
          Merge(UpdateList, Mp3ListeArtistSort, tmpMp3ListeArtistSort, SO_ArtistAlbum, NempSortArray);

          if fBrowseListsNeedUpdate then
              Mp3ListeAlbenSort.Sort(Sortieren_String2String1Titel_asc);
          UpdateList.Sort(Sortieren_String2String1Titel_asc);
          Merge(UpdateList, Mp3ListeAlbenSort, tmpMp3ListeAlbenSort, SO_AlbumArtist, NempSortArray);

          fBrowseListsNeedUpdate := False;
      end;
      1: begin
          // Coverflow
          UpdateList.Sort(Sortieren_CoverID);
          Merge(UpdateList, Mp3ListeArtistSort, tmpMp3ListeArtistSort, SO_Cover, NempSortArray);
          Merge(UpdateList, Mp3ListeAlbenSort, tmpMp3ListeAlbenSort, SO_Cover, NempSortArray);
      end;
      2: begin
          // TagCloud: Just put all files into the tmp-Lists
          // we do not need them really, but at least the file therein should be the same as in the PfadSortList
          tmpMp3ListeArtistSort.Clear;
          for i := 0 to Mp3ListeArtistSort.Count - 1 do
              tmpMp3ListeArtistSort.Add(Mp3ListeArtistSort[i]);
          tmpMp3ListeAlbenSort.Clear;
          for i := 0 to Mp3ListeAlbenSort.Count - 1 do
              tmpMp3ListeAlbenSort.Add(Mp3ListeAlbenSort[i]);
          for i := 0 to UpdateList.Count - 1 do
          begin
              tmpMp3ListeArtistSort.Add(UpdateList[i]);
              tmpMp3ListeAlbenSort.Add(UpdateList[i]);
          end;
      end;
  end;

  // Check for Duplicates
  // Note: This test should be always negative. If not, something in the system went wrong. :(
  //       Probably the Sort and Binary-Search methods do not match then.
  for i := 0 to tmpMp3ListePfadSort.Count-2 do
  begin
    if TAudioFile(tmpMp3ListePfadSort[i]).Pfad = TAudioFile(tmpMp3ListePfadSort[i+1]).Pfad then
    begin
      // Oops. Send Warning to MainWindow
      SendMessage(MainWindowHandle, WM_MedienBib, MB_DuplicateWarning, Integer(pWideChar(TAudioFile(tmpMp3ListePfadSort[i]).Pfad)));
      AnzeigeListe.Clear;
      AnzeigeListe2.Clear;
      AnzeigeListIsCurrentlySorted := False;
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList, 0);
      // Delete Duplicates
      for d := tmpMp3ListePfadSort.Count-1 downto 1 do
      begin
        if TAudioFile(tmpMp3ListePfadSort[d-1]).Pfad = TAudioFile(tmpMp3ListePfadSort[d]).Pfad then
        begin
          aAudioFile := TAudioFile(tmpMp3ListePfadSort[d]);
          tmpMp3ListePfadSort.Extract(aAudioFile);
          tmpMp3ListeArtistSort.Extract(aAudioFile);
          tmpMp3ListeAlbenSort.Extract(aAudioFile);

          BibSearcher.RemoveAudioFileFromLists(aAudioFile);
          FreeAndNil(aAudioFile);
        end;
      end;
      // break testing-loop. Duplicates has been deleted.
      break;
    end;
  end;

  // Prepare BrowseLists
  case BrowseMode of
      0: begin
          InitAlbenlist(tmpMp3ListeAlbenSort, tmpAlleAlben);
          Generateartistlist(tmpMp3ListeArtistSort, tmpAlleArtists);
      end;
      1: begin
          GenerateCoverList(tmpMp3ListeArtistSort, tmpCoverList);
      end;
      2: begin
          // nothing to do. TagCloud will be rebuild in "RefillBrowseTrees"
      end;
  end;


  // Build String for accelerated search
  BibSearcher.BuildTMPTotalString(tmpMp3ListePfadSort);
  BibSearcher.BuildTMPTotalLyricString(tmpMp3ListePfadSort);
end;


{
    --------------------------------------------------------
    AddUsedDrivesInformation
    - Check and Update UsedDrivesList
    --------------------------------------------------------
}
procedure TMedienBibliothek.AddUsedDrivesInformation(aList: TObjectlist; aPlaylistList: TObjectList);
var ActualDrive: WideChar;
    i: Integer;
    NewDrive: TDrive;
begin
    EnterCriticalSection(CSAccessDriveList);
    ActualDrive := '-';
    for i := 0 to aList.Count - 1 do
    begin
        if TAudioFile(aList[i]).Pfad[1] <> ActualDrive then
        begin
            ActualDrive := TAudioFile(aList[i]).Pfad[1];

            if ActualDrive <> '\' then
            begin
                if not Assigned(GetDriveFromListByChar(fUsedDrives, Char(ActualDrive))) then
                begin
                    NewDrive := TDrive.Create;
                    NewDrive.GetInfo(ActualDrive + ':\');
                    fUsedDrives.Add(NewDrive);
                end;
            end;
        end;
    end;

    ActualDrive := '-';
    for i := 0 to aPlaylistList.Count - 1 do
    begin
        if TJustaString(aPlaylistList[i]).DataString[1] <> ActualDrive then
        begin
            ActualDrive := TJustaString(aPlaylistList[i]).DataString[1];
            if ActualDrive <> '\' then
            begin
                if not Assigned(GetDriveFromListByChar(fUsedDrives, Char(ActualDrive))) then
                begin
                    NewDrive := TDrive.Create;
                    NewDrive.GetInfo(ActualDrive + ':\');
                    fUsedDrives.Add(NewDrive);
                end;
            end;
        end;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;
{
    --------------------------------------------------------
    SwapLists
    - Swap temporary lists with real ones.
      VCL MUST NOT read on the library
    Duration of this Operation: a few milli-seconds, almost nothing
    --------------------------------------------------------
}
procedure TMedienBibliothek.SwapLists;
var swaplist: TObjectlist;
    swapstlist: TStringList;
begin
  EnterCriticalSection(CSUpdate);

  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
  // Set the status of the library to Readaccessblocked
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_ReadAccessBlocked);
  /// StatusBibUpdate := BIB_Status_ReadAccessBlocked;

  swaplist := Mp3ListePfadSort;
  Mp3ListePfadSort := tmpMp3ListePfadSort;
  BibSearcher.MainList := Mp3ListePfadSort;
  tmpMp3ListePfadSort := swaplist;

  swaplist := Mp3ListeArtistSort;
  Mp3ListeArtistSort := tmpMp3ListeArtistSort;
  tmpMp3ListeArtistSort := swaplist;

  swaplist := Mp3ListeAlbenSort;
  Mp3ListeAlbenSort := tmpMp3ListeAlbenSort;
  tmpMp3ListeAlbenSort := swaplist;

  swaplist := AlleArtists;
  AlleArtists := tmpAlleArtists;
  tmpAlleArtists := swaplist;

  swaplist := Coverlist;
  Coverlist := tmpCoverlist;
  tmpCoverlist := swaplist;

  swapstlist := AlleAlben;
  AlleAlben := tmpAlleAlben;
  tmpAlleAlben := swapstlist;

  swapList := AllPlaylistsPfadSort;
  AllPlaylistsPfadSort := tmpAllPlaylistsPfadSort;
  tmpAllPlaylistsPfadSort := swapList;
  InitPlayListsList;

  BibSearcher.SwapTotalStrings;

  LeaveCriticalSection(CSUpdate);

// Send Refill-Message
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
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
var i: Integer;
  aString: tJustAString;
begin
  // Die Objekte hierdrin werden noch alle gebraucht!
  tmpMp3ListeArtistSort.Clear;
  tmpMp3ListeAlbenSort.Clear;
  tmpMp3ListePfadSort.Clear;
  tmpAllPlaylistsPfadSort.Clear;
  tmpAlleAlben.Clear;
  // alte JustaStrings löschen
  for i := 0 to tmpAlleArtists.Count - 1 do
  begin
    aString := tJustAString(tmpAlleArtists[i]);
    FreeAndNil(aString);
  end;
  tmpAlleArtists.Clear;
  Updatelist.Clear;
  PlaylistUpdateList.Clear;
  // Send UnBlock-Message
  SendMessage(MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
  /// StatusBibUpdate := 0;      // THIS IS DANGEROUS. DON NOT DO THIS HERE !!!
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
      fHND_DeleteFilesThread := BeginThread(Nil, 0, @fDeleteFilesUpdate, Self, 0, Dummy);
  end;
end;
{
    --------------------------------------------------------
    fDeleteFilesUpdate
    - runs in secondary thread and calls several private methods
    --------------------------------------------------------
}
Procedure fDeleteFilesUpdate(MB: TMedienbibliothek);
begin
    // Status is = 1 here (see above)     // status: Temporary comments, as I found a concept-bug here ;-)
    MB.CollectDeadFiles;                  // status: ok, no change needed
    MB.PrepareDeleteFilesUpdate;          // status: ok, change via SendMessage
    if (MB.DeadFiles.Count + MB.DeadPlaylists.Count) > 0 then
       MB.Changed := True;
    MB.SwapLists;                         // status: ok, change via SendMessage
    // Delete AudioFiles from "VCL-Lists"
    // This includes AnzeigeListe and the BibSearcher-Lists
    // MainForm will call CleanUpDeadFilesFromVCLLists
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_CheckAnzeigeList, 0);
    // Free deleted AudioFiles
    MB.CleanUpDeadFiles;                  // status: ok, no change needed
    // Clear temporary lists
    MB.CleanUpTmpLists;                   // status: ok, no change allowed
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free); // status: ok, thread finished
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
Function TMedienBibliothek.CollectDeadFiles: Boolean;
var i, ges, freq: Integer;
begin
      SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockUpdateStart, 0);

      ges := Mp3ListePfadSort.Count + AllPlaylistsPfadSort.Count  + 1;
      freq := Round(ges / 100) + 1;
      for i := 0 to Mp3ListePfadSort.Count-1 do
      begin
          if Not FileExists((Mp3ListePfadSort[i] as TAudioFile).Pfad) then
            DeadFiles.Add(Mp3ListePfadSort[i] as TAudioFile);
          if i mod freq = 0 then
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressSearchDead, Round(i/ges * 100));

          if not UpdateFortsetzen then break;
      end;

      for i := 0 to AllPlaylistsPfadSort.Count-1 do
      begin
          if Not FileExists(TJustaString(AllPlaylistsPfadSort[i]).DataString) then
            DeadPlaylists.Add(AllPlaylistsPfadSort[i] as TJustaString);
          if i mod freq = 0 then
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressSearchDead, Round((i + Mp3ListePfadSort.Count)/ges * 100));

          if not UpdateFortsetzen then break;
      end;
      result := True;
end;
{
    --------------------------------------------------------
    PrepareDeleteFilesUpdate
    - Block Write-Access to library.
    - "AntiMerge" DeadFiles and Mainlist to tmp-List
    --------------------------------------------------------
}
procedure TMedienBibliothek.PrepareDeleteFilesUpdate;
var i: Integer;
begin
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_WriteAccessBlocked);

  DeadFiles.Sort(Sortieren_Pfad_asc);
  AntiMerge(Mp3ListePfadSort, DeadFiles, tmpMp3ListePfadSort);

  AntiMergePlaylists(AllPlaylistsPfadSort, DeadPlaylists, tmpAllPlaylistsPfadSort);

  // Der Rest geht nicht mit AntiMerge. :(
  case BrowseMode of
      0: begin
          // Classic browse
          tmpMp3ListeArtistSort.Clear;
          for i := 0 to tmpMp3ListePfadSort.Count - 1 do
            tmpMp3ListeArtistSort.Add(tmpMp3ListePfadSort[i]);
          tmpMp3ListeArtistSort.Sort(Sortieren_String1String2Titel_asc);

          tmpMp3ListeAlbenSort.Clear;
          for i := 0 to tmpMp3ListePfadSort.Count - 1 do
            tmpMp3ListeAlbenSort.Add(tmpMp3ListePfadSort[i]);
          tmpMp3ListeAlbenSort.Sort(Sortieren_String2String1Titel_asc);

          fBrowseListsNeedUpdate := False;

          // BrowseListen vorbereiten.
          InitAlbenlist(tmpMp3ListeAlbenSort, tmpAlleAlben);
          Generateartistlist(tmpMp3ListeArtistSort, tmpAlleArtists);
      end;
      1: begin
          // CoverFlow
          tmpMp3ListeArtistSort.Clear;
          tmpMp3ListeAlbenSort.Clear;
          for i := 0 to tmpMp3ListePfadSort.Count - 1 do
          begin
            tmpMp3ListeArtistSort.Add(tmpMp3ListePfadSort[i]);
            tmpMp3ListeAlbenSort.Add(tmpMp3ListePfadSort[i]);
          end;
          tmpMp3ListeArtistSort.Sort(Sortieren_CoverID);
          tmpMp3ListeAlbenSort.Sort(Sortieren_CoverID);

          // BrowseListen vorbereiten.
          GenerateCoverList(tmpMp3ListeArtistSort, tmpCoverList);
      end;
      2: begin
          // tagCloud
          tmpMp3ListeArtistSort.Clear;
          tmpMp3ListeAlbenSort.Clear;
          for i := 0 to tmpMp3ListePfadSort.Count - 1 do
          begin
              tmpMp3ListeArtistSort.Add(tmpMp3ListePfadSort[i]);
              tmpMp3ListeAlbenSort.Add(tmpMp3ListePfadSort[i]);
          end;
          // Note: We do not need sorted BrowseLists in the TagCloud
      end;
  end;

  BibSearcher.BuildTMPTotalString(tmpMp3ListePfadSort);
  BibSearcher.BuildTMPTotalLyricString(tmpMp3ListePfadSort);
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
    // Delete DeadFiles from AnzeigeListe
    for i := 0 to DeadFiles.Count - 1 do
    begin
        AnzeigeListe.Extract(TAudioFile(DeadFiles[i]));
        AnzeigeListe2.Extract(TAudioFile(DeadFiles[i]));
    end;
    // Delete DeadFiles from BibSearcher
    BibSearcher.RemoveAudioFilesFromLists(DeadFiles);
end;
{
    --------------------------------------------------------
    CleanUpDeadFiles
    --------------------------------------------------------
}
procedure TMedienBibliothek.CleanUpDeadFiles;
var i: Integer;
    aAudioFile: TAudioFile;
    jas: TJustaString;
begin
  for i := 0 to DeadFiles.Count - 1 do
  begin
     aAudioFile := TAudioFile(DeadFiles[i]);
     FreeAndNil(aAudioFile);
  end;
  for i := 0 to DeadPlaylists.Count - 1 do
  begin
      jas := TJustaString(DeadPlaylists[i]);
      FreeAndNil(jas);
  end;
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
procedure TMedienBibliothek.RefreshFiles;
var Dummy: Cardinal;
begin
  if StatusBibUpdate = 0 then
  begin
      UpdateFortsetzen := True;
      StatusBibUpdate := BIB_Status_ReadAccessBlocked;
      fHND_RefreshFilesThread := (BeginThread(Nil, 0, @fRefreshFilesThread, Self, 0, Dummy));
  end;
end;
{
    --------------------------------------------------------
    fRefreshFilesThread
    - the secondary thread will call the proper private method
    --------------------------------------------------------
}
procedure fRefreshFilesThread(MB: TMedienbibliothek);
begin
    MB.fRefreshFiles;
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
        CloseHandle(MB.fHND_RefreshFilesThread);
    except
    end;
end;
{
    --------------------------------------------------------
    fRefreshFilesThread
    - Block read access for the VCL
    --------------------------------------------------------
}
procedure TMedienBibliothek.fRefreshFiles;
var i, toteFilesCount, freq: Integer;
    AudioFile: TAudioFile;
    oldArtist, oldAlbum: UnicodeString;
    oldID: string;
    einUpdate: boolean;
begin
  // AudioFiles will be changed. Block everything.
  SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);

  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNormal));

  toteFilesCount := 0;
  einUpdate := False;

  EnterCriticalSection(CSUpdate);
  freq := Round(Mp3ListeArtistSort.Count / 100) + 1;
  for i := 0 to MP3ListePfadSort.Count - 1 do
  begin
    AudioFile := TAudioFile(MP3ListePfadSort[i]);
    if FileExists(AudioFile.Pfad) then
    begin
        AudioFile.FileIsPresent:=True;
        oldArtist := AudioFile.Strings[NempSortArray[1]];
        oldAlbum := AudioFile.Strings[NempSortArray[2]];
        oldID := AudioFile.CoverID;

        // GetAudioData within the secondary is a very bad idea.
        // The cover-stuff will cause some exceptions like OutOfRessources
        // The Mainthread will do the following at this message:
        // AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover or GAD_Rating);
        // InitCover(AudioFile);
        SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshAudioFile, lParam(AudioFile));

        if  (oldArtist <> AudioFile.Strings[NempSortArray[1]])
            OR (oldAlbum <> AudioFile.Strings[NempSortArray[2]])
            or (oldID <> AudioFile.CoverID)
        then
            einUpdate := true;
    end
    else
    begin
        AudioFile.FileIsPresent:=False;
        inc(toteFilesCount);
    end;
    if i mod freq = 0 then
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefresh, Round(i/MP3ListePfadSort.Count * 100));

    if Not UpdateFortsetzen then break;
  end;

  if toteFilesCount > 0 then
    SendMessage(MainWindowHandle, WM_MedienBib, MB_DeadFilesWarning, toteFilesCount);

  if einUpdate then
  begin
      // Listen sortieren
      // With lParam = 1 only the caption of the StatusLabel is changed
      SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 1);

      case BrowseMode of
          0: begin
              Mp3ListeArtistSort.Sort(Sortieren_String1String2Titel_asc);
              Mp3ListeAlbenSort.Sort(Sortieren_String2String1Titel_asc);
              // BrowseListen neu füllen

              SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 1);
              GenerateArtistList(Mp3ListeArtistSort, AlleArtists);
              InitAlbenList(Mp3ListeAlbenSort, AlleAlben);
          end;
          1: begin
              Mp3ListeArtistSort.Sort(Sortieren_CoverID);
              Mp3ListeAlbenSort.Sort(Sortieren_CoverID);
              SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 1);
              GenerateCoverList(Mp3ListeArtistSort, CoverList);
          end;
          2: begin
              // Nothing to do here. TagCloud will be rebuild in VCL-Thread
              // by MB_RefillTrees
          end;
      end;

      // Build TotalStrings
      BibSearcher.BuildTotalString(Mp3ListePfadSort);
      BibSearcher.BuildTotalLyricString(Mp3ListePfadSort);

      // Nachricht diesbzgl. an die VCL
      SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(True));
  end;

  LeaveCriticalSection(CSUpdate);

  // Status zurücksetzen, Unblock library
  SendMessage(MainWindowHandle, WM_MedienBib, MB_UnBlock, 0);
  SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNoProgress));

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
  var Dummy: Cardinal;
begin
    // Status MUST be set outside
    // (the updatelist is filled in VCL-Thread)
    // But, to be sure:
    StatusBibUpdate := 1;
    UpdateFortsetzen := True;
    fHND_GetLyricsThread := BeginThread(Nil, 0, @fGetLyricsThread, Self, 0, Dummy);
end;
{
    --------------------------------------------------------
    fGetLyricsThread
    - secondary thread
    Files the user wants to fill with lyrics are stored in the UpdateList,
    so CleanUpTmpLists must be called after getting Lyrics.
    --------------------------------------------------------
}
procedure fGetLyricsThread(MB: TMedienBibliothek);
begin
    MB.fGetLyrics;
    MB.CleanUpTmpLists;
    SendMessage(MB.MainWindowHandle, WM_MedienBib, MB_SetStatus, BIB_Status_Free);
    try
      CloseHandle(MB.fHND_GetLyricsThread);
    except
    end;
end;
{
    --------------------------------------------------------
    fGetLyrics
    - Block Update-Access
    --------------------------------------------------------
}
procedure TMedienBibliothek.fGetLyrics;
var i: Integer;
    aAudioFile: TAudioFile;
    ID3v2tag: TID3v2Tag;
    IdHTTP1: TIdHTTP;
    LyricWikiResponse: String;
    LyricQuery: AnsiString;
    done, failed: Integer;
begin
    ID3v2tag := TID3v2tag.Create;
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockUpdateStart, 0);

    IdHTTP1 := TIdHTTP.Create;
    IDHttp1.ConnectTimeout:= 5000;
    IDHttp1.ReadTimeout:= 5000;
    IDHttp1.Request.UserAgent := 'Mozilla/3.0';
    IDHttp1.HTTPOptions :=  [hoForceEncodeParams];

    done := 0;
    failed := 0;
    // Lyrics suchen
    for i := 0 to UpdateList.Count - 1 do
    begin
        if not UpdateFortsetzen then break;

        aAudioFile := tAudioFile(UpdateList[i]);
        if FileExists(aAudioFile.Pfad)
           AND (AnsiLowerCase(ExtractFileExt(aAudioFile.Pfad))='.mp3')
        then
        begin

            // call the vcl, that we will edit this file now
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar(aAudioFile.Pfad)));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateStatus,
                    Integer(PWideChar(Format(MediaLibrary_SearchLyricsStats, [done, done + failed]))));
            aAudioFile.FileIsPresent:=True;
             {$Message Hint 'Hier UTF8-Konzept überdenken (vgl. auch: Detail-Fenster)'}
            {LyricQuery := 'http://lyricwiki.org/api.php?func=getSong&artist='
                        + StringToURLString(WordUppercase(UTF8Encode((aAudiofile.Artist))))
                        + '&song='
                        + StringToURLString(WordUppercase(UTF8Encode((aAudiofile.Titel))))
                        + '&fmt=text';
            }
            LyricQuery := 'http://lyricwiki.org/api.php?func=getSong&artist='
                        + StringToURLStringAND(UTF8Encode(WordUppercase((aAudiofile.Artist))))
                        + '&song='
                        + StringToURLStringAND(UTF8Encode(WordUppercase((aAudiofile.Titel))))
                        + '&fmt=text';

            LyricWikiResponse := '';
            try
                LyricWikiResponse := idHttp1.Get(String(LyricQuery));
            except
                if UpdateFortsetzen then
                begin
                  IDHttp1.Disconnect;
                  SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateFailed, 0);
                  UpdateFortsetzen := False;
                end;
            end;

            if UpdateFortsetzen then
            begin
                LyricWikiResponse := StringReplace(LyricWikiResponse, #10, #13#10, [rfReplaceAll]);

                If (Trim(LyricWikiResponse) <> '') and (Trim(LyricWikiResponse) <> 'Not found') then
                begin
                    // Lyrics speichern
                    // 1. id3Tag ermitteln
                    ID3v2tag.ReadFromFile(aAudioFile.Pfad);
                    if not Id3v2Tag.exists then
                    begin
                      // Tag erstellen und sinnvoll füllen
                      if aAudioFile.Titel <> AUDIOFILE_UNKOWN then
                          ID3v2tag.Title  := aAudioFile.Titel;
                      if aAudioFile.Artist <> AUDIOFILE_UNKOWN then
                          ID3v2tag.Artist := aAudioFile.Artist;
                      if aAudioFile.Album <> AUDIOFILE_UNKOWN then
                          ID3v2tag.album  := aAudioFile.Album;
                      if aAudioFile.Comment <> AUDIOFILE_UNKOWN then
                          ID3v2tag.Comment:= aAudioFile.Comment;
                      ID3v2tag.Year   := aAudioFile.Year;
                      ID3v2Tag.Track  := IntToStr(aAudioFile.Track);
                      ID3v2tag.Genre  := aAudioFile.Genre;
                    end;
                    Id3v2Tag.Lyrics := ProcessWikiResponse((trim(LyricWikiResponse)));

                    if Id3v2Tag.WriteToFile(aAudioFile.Pfad) = MP3ERR_None then
                    begin
                        aAudioFile.Lyrics := UTF8Encode(Id3v2Tag.Lyrics);
                        Changed := True;
                        inc(done);
                    end else
                    begin
                        // Datei konnte nicht aktualisiert werden.
                        // (Schreibgeschützt, oder jemand anders greift grade auf die Datei zu)
                        // nichts an den Lyrics ändern, aber
                        inc(failed);
                    end;
                end else
                    inc(failed);
            end;
        end
        else begin
            aAudioFile.FileIsPresent:=False;
            inc(failed);
        end;
    end;
    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar('')));

    // Build TotalStrings
    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockWriteAccess, 0);
    BibSearcher.BuildTMPTotalString(Mp3ListePfadSort);
    BibSearcher.BuildTMPTotalLyricString(Mp3ListePfadSort);

    SendMessage(MainWindowHandle, WM_MedienBib, MB_BlockReadAccess, 0);
    BibSearcher.SwapTotalStrings;

    if done + failed = 1 then
    begin
        // ein einzelnes File wurde angefordert
        // Bei Mißerfolg einen Hinweis geben.
        if (done = 0) then
            SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateComplete,
                Integer(PChar(MediaLibrary_SearchLyricsComplete_SingleNotFound)))
    end else
    begin
        // mehrere Dateien wurden gesucht.
        if failed = 0 then
            SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateComplete,
                Integer(PChar((MediaLibrary_SearchLyricsComplete_AllFound))))
        else
            if done > 0.5 * (failed + done) then
                // ganz gutes Ergebnis - mehr als die Hälfte gefunden
                SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateComplete,
                    Integer(PChar(Format(MediaLibrary_SearchLyricsComplete_ManyFound, [done, done + failed]))))
            else
                if done > 0 then
                    // Nicht so tolles Ergebnis
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateComplete,
                        Integer(PChar(Format(MediaLibrary_SearchLyricsComplete_FewFound, [done, done + failed]))))
                else
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_LyricUpdateComplete,
                        Integer(PChar(MediaLibrary_SearchLyricsComplete_NoneFound)))
    end;
    IdHTTP1.Free;
    id3v2Tag.free;
    // UnblockMEssage is sent via CleanUpTMPLists
end;



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
    fHND_GetTagsThread := BeginThread(Nil, 0, @fGetTagsThread, Self, 0, Dummy);
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
    // Todo: Rebuild TagCloud ??
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
    s: String;
    TagPostProcessor: TTagPostProcessor;
begin
    done := 0;
    failed := 0;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNormal));

    TagPostProcessor := TTagPostProcessor.Create;
    try
        TagPostProcessor.LoadFiles;
        for i := 0 to UpdateList.Count - 1 do
        begin
            if not UpdateFortsetzen then break;

            af := TAudioFile(UpdateList[i]);

            if FileExists(af.Pfad) then
            begin
                // call the vcl, that we will edit this file now
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                            Integer(PWideChar(af.Pfad)));

                SendMessage(MainWindowHandle, WM_MedienBib, MB_TagsUpdateStatus,
                            Integer(PWideChar(Format(MediaLibrary_SearchTagsStats, [done, done + failed]))));

                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));
                af.FileIsPresent:=True;

                // GetTags will create the IDHttp-Object
                s := BibScrobbler.GetTags(af);

                // bei einer exception ganz abbrechen??
                // nein, manchmal kommen ja auch BadRequests...???

                if trim(s) = '' then
                begin
                    inc(failed);
                end else
                begin
                    inc(done);
                    // process new Tags. Rename, delete ignored and duplicates.
                    af.RawTagLastFM := ControlRawTag(af, s, TagPostProcessor.IgnoreList, TagPostProcessor.MergeList);
                    af.SetAudioData(SAD_Both);
                    Changed := True;
                end;
            end;
        end;
    finally
        TagPostProcessor.Free;
    end;

    if done > 0 then
        SendMessage(MainWindowHandle, WM_MedienBib, MB_TagsSetTabWarning, 0);

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNoProgress));

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar('')));
end;

{
    --------------------------------------------------------
    ControlRawtag
    - Correct RawTags from lastFM
      af: Current AudioFile
      newTags: String with new tags (result from LastFM)
      aIgnorelist, aMergeList: Data how to change newTags
      Result: The new #13#10-seperated TagString, including the old ones
    --------------------------------------------------------
}
function TMedienBibliothek.ControlRawTag(af: TAudioFile; newTags: String;
  aIgnoreList: TStringList; aMergeList: TObjectList): String;
var oldTagList, newTagList: TStringList;
    i: Integer;
    aMergeItem: tTagMergeItem;

        function GetMatchingMergeItem(aKey: String): TTagMergeItem;
        var i: Integer;
        begin
            result := Nil;
            for i := 0 to aMergeList.Count - 1 do
            begin
                if AnsiSameText(TTagMergeItem(aMergeList[i]).OriginalKey, aKey) then
                begin
                    result := TTagMergeItem(aMergeList[i]);
                    break;
                end;
            end;
        end;

begin
    oldTagList := TStringList.Create;
    newTagList := TStringList.Create;
    try
        oldTagList.Text := af.RawTagLastFM;
        newTagList.Text := newTags;

        // 1.) delete duplicates, i.e. new tags, that are already there
        for i := newTagList.Count - 1 downto 0 do
            if oldTagList.IndexOf(newTagList[i]) >= 0 then
                newTagList.Delete(i);

        // 2.) delete ignored tags
        for i := newTagList.Count - 1 downto 0 do
            if aIgnoreList.IndexOf(newTagList[i]) >= 0 then
                newTagList.Delete(i);

        // 3.) Change Tags as described in aMergeList
        for i := 0 to newTagList.Count - 1 do
        begin
            aMergeItem := GetMatchingMergeItem(newTagList[i]);
            if assigned(aMergeItem) then
                // change key
                newTagList[i] := aMergeItem.ReplaceKey;
        end;

        // 4.) Add new Tags to oldTagList, check for duplicates EVERY time,
        //     as by 3.) we could have generated duplicates again.
        for i := 0 to newTagList.Count - 1 do
        begin
            if oldTagList.IndexOf(newTagList[i]) = -1 then
                oldTagList.Add(newtagList[i]);
        end;

        result := trim(oldTagList.Text);
    finally
        oldTagList.Free;
        newTagList.Free;
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
var i: Integer;
    af: TAudioFile;
begin
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNormal));

    for i := 0 to UpdateList.Count - 1 do
    begin
        if not UpdateFortsetzen then break;

        af := TAudioFile(UpdateList[i]);

        if FileExists(af.Pfad) then
        begin
            // call the vcl, that we will edit this file now
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                        Integer(PWideChar(af.Pfad)));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));

            SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile,
                        Integer(PWideChar(
                            Format(MediaLibrary_CloudUpdateStatus,
                            [Round(i/UpdateList.Count * 100), af.Dateiname]))));

            af.FileIsPresent := True;

            af.SetAudioData(SAD_Both);
            af.ID3TagNeedsUpdate := False;

            Changed := True;
        end;
    end;

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNoProgress));

    SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile, Integer(PWideChar('')));

    // clear thread-used filename
    SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar('')));
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
    aFrame: TID3v2Frame;
    FrameList: TObjectList;
    ms: TMemoryStream;
    privateOwner: AnsiString;
    LogList: TStringList;
begin
    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNormal));

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

            af := TAudioFile(UpdateList[i]);

            if FileExists(af.Pfad) then
            begin
                // call the vcl, that we will edit this file now
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                            Integer(PWideChar(af.Pfad)));
                SendMessage(MainWindowHandle, WM_MedienBib, MB_ProgressRefreshJustProgressbar, Round(i/UpdateList.Count * 100));

                SendMessage(MainWindowHandle, WM_MedienBib, MB_RefreshTagCloudFile,
                        Integer(PWideChar(
                            Format(MediaLibrary_CloudUpdateStatus,
                            [Round(i/UpdateList.Count * 100), af.Dateiname]))));


                af.FileIsPresent := True;

                id3 := TID3v2Tag.Create;
                try
                    // Read the tag from the file
                    id3.ReadFromFile(af.Pfad);

                    // Get all private Frames in the ID3Tag
                    FrameList := id3.GetAllPrivateFrames; // List is Created in this method

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
                    FrameList.Free;
                finally
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

    SendMessage(MainWindowHandle, WM_MedienBib, MB_SetWin7TaskbarProgress, Integer(fstpsNoProgress));

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
var i: Integer;
begin
//  result := StatusBibUpdate = 0;
// ??? Status MUST be set to 3 before calling this, as we have an "Application.ProcessMessages"
//     in the calling Method PM_ML_DeleteSelectedClick

  result := true;
  AnzeigeListe.Extract(aAudioFile);
  AnzeigeListe2.Extract(aAudioFile);
  if AnzeigeShowsPlaylistFiles then
  begin
      PlaylistFiles.Extract(aAudioFile);
  end
  else
  begin
      Mp3ListePfadSort.Extract(aAudioFile);
      Mp3ListeArtistSort.Extract(aAudioFile);
      Mp3ListeAlbenSort.Extract(aAudioFile);
      tmpMp3ListePfadSort.Extract(aAudioFile);
      tmpMp3ListeArtistSort.Extract(aAudioFile);
      tmpMp3ListeAlbenSort.Extract(aAudioFile);
      BibSearcher.RemoveAudioFileFromLists(aAudioFile);
      Changed := True;
  end;
  FreeAndNil(aAudioFile);
end;
function TMedienBibliothek.DeletePlaylist(aPlaylist: TJustAString): boolean;
begin
    result := StatusBibUpdate = 0;
    if StatusBibUpdate <> 0 then exit;
    tmpAllPlaylistsPfadSort.Extract(aPlaylist);
    AllPlaylistsPfadSort.Extract(aPlaylist);
    AllPlaylistsNameSort.Extract(aPlaylist);
    Alben.Extract(aPlaylist);
    Changed := True;
    FreeAndNil(aPlaylist);
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

  // this is the main-code in this method
  if StatusBibUpdate > 0 then
      UpdateFortsetzen := False;
end;
{
    --------------------------------------------------------
    ResetRatings
    - Set the ratings of all AudioFiles back to 0.
    Note: Ratings in the ID3-Tags are untouched!
    --------------------------------------------------------
}
procedure TMedienBibliothek.ResetRatings;
var i: Integer;
begin
  if StatusBibUpdate >= 2 then exit;
  EnterCriticalSection(CSUpdate);
  for i := 0 to Mp3ListeArtistSort.Count - 1 do
    (Mp3ListeArtistSort[i] as TAudioFile).Rating := 0;
  Changed := True;
  LeaveCriticalSection(CSUpdate);
end;


{
    --------------------------------------------------------
    ValidKeys
    - Check, whether Key1 and Key2 matches strings[sortarray[1/2]]
      runs in VCL-Thread
    --------------------------------------------------------
}
function TMedienBibliothek.ValidKeys(aAudioFile: TAudioFile): Boolean;
begin
    result := (aAudioFile.Key1 = aAudioFile.Strings[NempSortArray[1]])
          AND (aAudioFile.Key2 = aAudioFile.Strings[NempSortArray[2]]);

    if Not result then
        fBrowseListsNeedUpdate := True;
end;

{
    --------------------------------------------------------
    RestoreSortOrderAfterItemChanged
    - Extract a (changed) AudioFile from the lists, add it to the UpdateList
      and re-merge it
    Run ONLY IN VCL-Thread !
    - Not needed any longer: Browsing is done by audiofile.key1/key2, and the User should click
                             the TabBrowseBtn to refresh the Browse-Lists
    --------------------------------------------------------
}
(*
function TMedienBibliothek.RestoreSortOrderAfterItemChanged(aAudioFile: tAudioFile): Boolean;
var swaplist: TObjectlist;
    swapstlist: TStringList;
begin
  result := StatusBibUpdate = 0;
  if StatusBibUpdate <> 0 then exit;  // WICHTIG!!!

  StatusBibUpdate := BIB_Status_ReadAccessBlocked;
  // Datei aus den Listen entfernen
  Mp3ListeArtistSort.Extract(aAudioFile);
  Mp3ListeAlbenSort.Extract(aAudioFile);
  //Datei wieder einpflegen
  UpdateList.Add(aAudioFile);
  if BrowseMode = 0 then
  begin
      Merge(UpdateList, Mp3ListeArtistSort, tmpMp3ListeArtistSort, SO_ArtistAlbum, NempSortArray);
      Merge(UpdateList, Mp3ListeAlbenSort, tmpMp3ListeAlbenSort, SO_AlbumArtist, NempSortArray);
      // BrowseListen vorbereiten.
      InitAlbenlist(tmpMp3ListeAlbenSort, tmpAlleAlben);
      Generateartistlist(tmpMp3ListeArtistSort, tmpAlleArtists);
  end else
  begin
      Merge(UpdateList, Mp3ListeArtistSort, tmpMp3ListeArtistSort, SO_Cover, NempSortArray);
      Merge(UpdateList, Mp3ListeAlbenSort, tmpMp3ListeAlbenSort, SO_Cover, NempSortArray);
      GenerateCoverList(tmpMp3ListeArtistSort, tmpCoverlist);
  end;
  // SwapLists, nur ohne Messages.
  // DIESE PROZEDUR DARF ALSO NUR IM VCL_THREAD AUSGEFÜHRT WERDEN !!!!
  EnterCriticalSection(CSUpdate);
      swaplist := Mp3ListeArtistSort;
      Mp3ListeArtistSort := tmpMp3ListeArtistSort;
      tmpMp3ListeArtistSort := swaplist;
      swaplist := Mp3ListeAlbenSort;
      Mp3ListeAlbenSort := tmpMp3ListeAlbenSort;
      tmpMp3ListeAlbenSort := swaplist;

      swaplist := Coverlist;
      Coverlist := tmpCoverlist;
      tmpCoverlist := swaplist;
      swaplist := AlleArtists;
      AlleArtists := tmpAlleArtists;
      tmpAlleArtists := swaplist;
      swapstlist := AlleAlben;
      AlleAlben := tmpAlleAlben;
      tmpAlleAlben := swapstlist;
  LeaveCriticalSection(CSUpdate);
  CleanUpTmpLists;
  StatusBibUpdate := 0;
  Changed := True;
end;
*)

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
    result := binaersuche(Mp3ListePfadSort, ExtractFilePath(aFilename), ExtractFileName(aFilename), 0,Mp3ListePfadSort.Count-1) > -1;
end;
function TMedienBibliothek.PlaylistFileExists(aFilename: UnicodeString): Boolean;
begin
    result := BinaerPlaylistSuche(AllPlaylistsPfadSort, aFilename, 0, AllPlaylistsPfadSort.Count-1) > -1;
end;
function TMedienBibliothek.GetAudioFileWithFilename(aFilename: UnicodeString): TAudioFile;
var idx: Integer;
begin
  idx := binaersuche(Mp3ListePfadSort,ExtractFilePath(aFilename), ExtractFileName(aFilename),0,Mp3ListePfadSort.Count-1);
  if idx = -1 then
    result := Nil
  else
    result := TAudioFile(Mp3ListePfadSort[idx]);
end;

{
    --------------------------------------------------------
    InitCover
    Get a CoverID for the Audiofile, using the last ID,
    in case the directory of the new file is the same as th
    one of the last one.
    --------------------------------------------------------
}
procedure TMedienBibliothek.InitCover(aAudioFile: tAudioFile);
var CoverListe: TStringList;
    NewCoverName: String;
begin
  try
      if aAudioFile.CoverID <> '' then
      // das bedeutet, dass GetAudioData zuvor ein Cover gefunden hat!
      begin
        flastID := aAudioFile.CoverID;
        fLastPath := '';
        fLastCoverName := '';
      end else // AudioFile.GetAudioData hat kein Cover im ID3Tag gefunden. Also: In Dateien drumherum suchen
      begin
            //Wenn Da kein Erfolg: Cover-Datei suchen.
            // Aber nur, wenn man jetzt in einem Anderen Ordner ist.
            // Denn sonst würde die Suche ja dasselbe Ergebnis liefern
            //if (fLastPath <> ExtractFilePath(aAudioFile.Pfad)) then
            if (fLastPath <> aAudioFile.Ordner) then
            begin
                //fLastPath := ExtractFilePath(aAudioFile.Pfad);
                fLastPath := aAudioFile.Ordner;

                Coverliste := TStringList.Create;
                GetCoverListe(aAudioFile, coverliste);
                if Coverliste.Count > 0 then
                begin
                    NewCoverName := coverliste[GetFrontCover(CoverListe)];
                    if  (NewCovername <> fLastCoverName) then
                    begin
                        aAudioFile.CoverID := InitCoverFromFilename(NewCovername);
                        if aAudioFile.CoverID = '' then
                        begin
                            // Something was wrong with the Coverfile (see comments in InitCoverFromFilename)
                            // possible solution: Try the next coverfile.
                            // Easier: Just use "Default-Cover" and md5(AudioFile.Ordner) as Cover-ID
                            NewCoverName := '';
                            aAudioFile.CoverID := '__'+ MD5DigestToStr(MD5UnicodeString(aAudioFile.Ordner));
                        end;
                        flastID := aAudioFile.CoverID;
                        fLastCoverName := NewCovername;
                    end
                    else
                        aAudioFile.CoverID := flastID;
                end else
                begin
                    // Kein Cover gefunden
                    fLastCoverName := '';

                    flastID := '__'+ MD5DigestToStr(MD5UnicodeString(aAudioFile.Ordner));
                    //flastID := '__'+ (StringReplace(aAudioFile.Ordner, '\', '-', [rfreplaceall]));
                    aAudioFile.CoverID := flastID;
                end;
                coverliste.free;
            end else
            begin
                // Datei ist im selben Ordner wie die letzte Datei, also auch dasselbe Cover.
                aAudioFile.CoverID := fLastId;
            end;
      end;
  except
    if assigned(aAudioFile) then aAudioFile.CoverID := '';
     flastID := '';
     fLastPath := '';
     fLastCoverName := '';
  end;
end;
{
    --------------------------------------------------------
    GetCoverListe
    - Get a list of candidates for the cover
      Used e.g. by InitCover, when the directory changed
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetCoverListe(aAudioFile: tAudioFile; aCoverListe: TStringList);
var Ordner: UnicodeString;
begin
  Ordner := aAudioFile.Ordner;
  if DirectoryExists(Ordner) then // Nach Ordnern suchen

    if CoverSearchInDir then
      SucheCover(Ordner, aCoverListe);
    if (aCoverListe.Count <= 0) and CoverSearchInParentDir then
      if CountFilesInParentDir(Ordner) <= 5 then
        SucheCoverInParentDir(Ordner, aCoverListe);

    if (aCoverListe.Count <= 0) and CoverSearchInSubDir then
      if CountSubDirs(Ordner) <= 5 then
        SucheCoverInSubDir(Ordner, aCoverListe, CoverSearchSubDirName);

    if (aCoverListe.Count <= 0) and CoverSearchInSisterDir then
      if CountSisterDirs(Ordner) <= 5 then
        SucheCoverInSisterDir(Ordner, aCoverListe, CoverSearchSisterDirName);
end;
{
    --------------------------------------------------------
    InitCoverFromFilename
    - Copy a Coverfile into the Cover-Directory of the library
    Return value: The New Cover-ID (i.e. the filename for the resized cover)
    --------------------------------------------------------
}
function TMedienBibliothek.InitCoverFromFilename(aFileName: UnicodeString): String;
var aGraphic: TPicture;
    newID: String;
begin
    try
        newID := MD5DigestToStr(MD5File(aFileName));
    except
        newID := ''
    end;

    if newID = '' then
    begin
        // somethin was wrong with opening the file ...
        // I've got sometimes Exceptions "cannot access file..." with fresh downloaded files from LastFM
        // maybe conflicts with an antivirus-scanner??
        // so, try again.
        sleep(100);
        try
            newID := MD5DigestToStr(MD5File(aFileName));
        except
            newID := ''
        end;
    end;

  result := '';

  if newID <> '' then
  begin
      aGraphic := TPicture.Create;
      try
          try
              aGraphic.LoadFromFile(aFilename);

              if SafeResizedGraphic(aGraphic.Graphic, CoverSavePath + newID + '.jpg', 240, 240) then
                  result := newID;
          except
              // something was wrong with the coverfile - e.g. filename=cover.gif, but its a jpeg
              // => silent exception, as this is done during the search for new files.
              // wuppdi;
          end;

      finally
          aGraphic.Free;
      end;
  end;
end;
{
    --------------------------------------------------------
    ReInitCoverSearch
    - Reset the internally used variables for faster coversearch
    --------------------------------------------------------
}
procedure TMedienBibliothek.ReInitCoverSearch;
begin
  fSavePath      := '';
  fLastCoverName := '';
  fLastPath      := '';
  fLastID        := '';
end;

{
    --------------------------------------------------------
    GenerateArtistList
    - Get all different Artists from the library.
    Used in the left of the two browse-trees
    --------------------------------------------------------
}
procedure TMedienBibliothek.GenerateArtistList(Source: TObjectlist; Target: TObjectlist);
var i, start: integer;
  aktualArtist, lastArtist: UnicodeString;
  tmpJaS: TJustaString;
begin
  for i := 0 to Target.Count - 1 do
    TJustaString(Target[i]).Free;

  Target.Clear;
  Target.Add(TJustastring.create(BROWSE_PLAYLISTS));
  Target.Add(TJustastring.create(BROWSE_RADIOSTATIONS));
  Target.Add(TJustastring.create(BROWSE_ALL));

  if Source.Count < 1 then exit;


  aktualArtist := (Source[0] as TAudioFile).Strings[NempSortArray[1]];
  // Copy current value for "artist" to key1
  (Source[0] as TAudioFile).Key1 := aktualArtist;

  lastArtist := aktualArtist;
  if lastArtist <> '' then
    Target.Add(TJustastring.create(lastArtist));

  for i := 1 to Source.Count - 1 do
  begin
    aktualArtist := (Source[i] as TAudioFile).Strings[NempSortArray[1]];
    // Copy current value for "artist" to key1
    (Source[i] as TAudioFile).Key1 := aktualArtist;

    if NOT AnsiSameText(aktualArtist, lastArtist) then
    begin
      lastArtist := aktualArtist;
      if lastArtist <> '' then
        Target.Add(TJustastring.create(lastArtist));
    end;
  end;

  if (NempSortArray[1] <> siOrdner) then
  begin
    i := 3;      // <All> auslassen
    while (i < Target.Count) and (  AnsiCompareText(TJustastring(Target[i]).AnzeigeString, AUDIOFILE_UNKOWN) < 0  ) do
      inc(i);

    start := i;
    if (start < Target.Count) and (  AnsiCompareText(TJustastring(Target[i]).AnzeigeString, AUDIOFILE_UNKOWN) = 0  ) then
    begin
        for i := start downto 4 do
        begin
            tmpJaS := TJustastring(Target[i]);
            Target[i] := Target[i-1];
            Target[i-1] := tmpJaS;
        end;
    end;
  end;
end;
{
    --------------------------------------------------------
    InitAlbenlist
    - Get all different Albums from the library.
    Used in the right of the two browse lists, if Artist=<All> is selected
    --------------------------------------------------------
}
procedure TMedienBibliothek.InitAlbenlist(Source: TObjectlist; Target: TStringList);
var i: integer;
  aktualAlbum, lastAlbum: UnicodeString;
begin
  // Initiiere eine Liste mit allen Alben
  Target.Clear;
  Target.Add(BROWSE_ALL);
  if Source.Count < 1 then exit;

  // Copy current value for "album" to key2
  (Source[0] as TAudioFile).Key2 := (Source[0] as TAudioFile).Strings[NempSortArray[2]];

  aktualAlbum := (Source[0] as TAudioFile).Strings[NempSortArray[2]];
  lastAlbum := aktualAlbum;
  // Ungültige Alben nicht einfügen
  if lastAlbum <> '' then  // Hier noch eine bessere Überprüfung einbauen ???      (*)
    Target.Add(lastAlbum);

  for i := 1 to Source.Count - 1 do
  begin
    // Copy current value for "album" to key2
    (Source[i] as TAudioFile).Key2 := (Source[i] as TAudioFile).Strings[NempSortArray[2]];
    // check for "new album"
    aktualAlbum := (Source[i] as TAudioFile).Strings[NempSortArray[2]];
    if NOT AnsiSameText(aktualAlbum, lastAlbum) then
    begin
      lastAlbum := aktualAlbum;
      if lastAlbum <> '' then  // Hier noch eine bessere Überprüfung einbauen ???   (*)
        Target.Add(lastAlbum);
    end;
  end;
end;
{
    --------------------------------------------------------
    InitPlayListsList
    - Sort the Playlists by Name
    Used by the right browse-tree, when Playlists are selected
    --------------------------------------------------------
}
procedure TMedienBibliothek.InitPlayListsList;
var i: Integer;
begin
    AllPlaylistsNameSort.Clear;
    for i := 0 to AllPlaylistsPfadSort.Count - 1 do
        AllPlaylistsNameSort.Add(AllPlaylistsPfadSort[i]);

    AllPlaylistsNameSort.Sort(PlaylistSort_Name);
end;

{
    --------------------------------------------------------
    GenerateCoverList
    - Get all Cover-IDs from the Library
    Used for Coverflow
    --------------------------------------------------------
}
procedure TMedienBibliothek.GenerateCoverList(Source: TObjectlist; Target: TObjectlist);
var i: integer;
  aktualID, lastID: String;
  newCover: TNempCover;
  aktualAudioFile: tAudioFile;
  AudioFilesWithSameCover: tObjectlist;

begin
  for i := 0 to Target.Count - 1 do
    TNempCover(Target[i]).Free;
  Target.Clear;

  newCover := TNempCover.Create;
  newCover.ID := 'all';
  newCover.key := 'all';
  newCover.Artist := 'All artists';
  Newcover.Album := 'Your media-library';
  Target.Add(NewCover);

  if Source.Count < 1 then
  begin
    GetRandomCover(Target);
    exit;
  end;

  AudioFilesWithSameCover := TObjectlist.Create(False);

  aktualAudioFile := (Source[0] as TAudioFile);
  aktualAudioFile.Key1 := aktualAudioFile.CoverID;   // copy ID to key1
  aktualID := aktualAudioFile.CoverID;
  lastID := aktualID;

  newCover := TNempCover.Create;
  newCover.ID := aktualAudioFile.CoverID;
  newCover.key := newCover.ID;
  NewCover.Artist := aktualAudioFile.Artist;
  NewCover.Album := aktualAudioFile.Album;
  NewCover.Year := StrToIntDef(aktualAudioFile.Year, 0);
  NewCover.Genre := aktualAudioFile.Genre;
  Target.Add(NewCover);

  AudioFilesWithSameCover.Add(aktualAudioFile);

  for i := 1 to Source.Count - 1 do
  begin
    aktualAudioFile := (Source[i] as TAudioFile);
    aktualAudioFile.Key1 := aktualAudioFile.CoverID;   // copy ID to key1
    aktualID := aktualAudioFile.CoverID;
    if SameText(aktualID, lastID) then
    begin
      AudioFilesWithSameCover.Add(aktualAudioFile);
    end else
    begin
      // Checklist (liste, cover)
      GetCoverInfos(AudioFilesWithSameCover, newCover);

      // to do here: if info = <N/A> then ignore this cover, i.e. delete it from the list.
      if HideNACover then
      begin
          if (newCover.Artist = AUDIOFILE_UNKOWN) and (newCover.Album = AUDIOFILE_UNKOWN) then
          begin
              // discard current cover
              NewCover.Free;
              Target.Delete(Target.Count - 1);
          end;
      end;

      // Neues Cover erstellen und neue Liste anfangen
      lastID := aktualID;
      newCover := TNempCover.Create;
      newCover.ID := aktualAudioFile.CoverID;
      newCover.key := newCover.ID;
      NewCover.Year := StrToIntDef(aktualAudioFile.Year, 0);
      NewCover.Genre := aktualAudioFile.Genre;
      Target.Add(NewCover);
      AudioFilesWithSameCover.Clear;
      AudioFilesWithSameCover.Add(aktualAudioFile);
    end;
  end;

  // Check letzte List
  GetCoverInfos(AudioFilesWithSameCover, newCover);
  AudioFilesWithSameCover.Free;

  // Coverliste sortieren
  case CoverSortorder of
      1: Target.Sort(CoverSort_Artist);
      2: Target.Sort(CoverSort_Album);
      3: Target.Sort(CoverSort_Genre);
      4: Target.Sort(CoverSort_Jahr);
      5: Target.Sort(CoverSort_GenreYear);
      6: Target.Sort(CoverSort_DirectoryArtist);
      7: Target.Sort(CoverSort_DirectoryAlbum);
  end;
  GetRandomCover(Target);

///// das im Hauptthread mit der neuen Liste machen  NewCoverFlow.SetNewList(Target);

{  NewCoverFlow.BeginUpdate;
  NewCoverFlow.Clear;
  for i := 0 to Target.Count - 1 do
  begin
      item := TFlyingCowItem.Create( TNempCover(Target[i]).ID, TNempCover(Target[i]).Artist, TNempCover(Target[i]).Album );
      NewCoverFlow.Add(item);
  end;
  NewCoverFlow.EndUpdate;

  //if Target.Count > 0 then
  //    NewCoverFlow.CurrentItem := 0;
  }
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
  Mp3ListeArtistSort.Sort(Sortieren_String1String2Titel_asc);
  Mp3ListeAlbenSort.Sort(Sortieren_String2String1Titel_asc);
  GenerateArtistList(Mp3ListeArtistSort, AlleArtists);
  InitAlbenList(Mp3ListeAlbenSort, AlleAlben);
  //...ein Senden dieser nachricht ist daher ok.
  // d.h. einfach die Bäume neufüllen. Ein markieren der zuletzt markierten Knoten ist unsinnig
  SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, LParam(False));
end;
{
    --------------------------------------------------------
    ReBuildCoverList
    - update the coverlist
    --------------------------------------------------------
}
procedure TMedienBibliothek.ReBuildCoverList;
begin
  Mp3ListeArtistSort.Sort(Sortieren_CoverID);
  Mp3ListeAlbenSort.Sort(Sortieren_CoverID);
  GenerateCoverList(Mp3ListeArtistSort, CoverList);
end;

{
    --------------------------------------------------------
    ReBuildTagCloud
    - update the TagCloud
    --------------------------------------------------------
}
procedure TMedienBibliothek.ReBuildTagCloud;
begin
    // Build the Tagcloud.
    TagCloud.BuildCloud(Mp3ListePfadSort, Nil, True);
end;

procedure TMedienBibliothek.RestoreTagCloudNavigation;
begin
    TagCloud.RestoreNavigation(Mp3ListeArtistSort);
end;

procedure TMedienBibliothek.GetTopTags(ResultCount: Integer; Offset: Integer; Target: TObjectList);
begin
    TagCloud.GetTopTags(ResultCount, Offset, Mp3ListeArtistSort, Target);
end;


{
    --------------------------------------------------------
    RepairBrowseListsAfterDelete
    RepairBrowseListsAfterChange
    - Repairing the Browselist
    --------------------------------------------------------
}
procedure TMedienBibliothek.RepairBrowseListsAfterDelete;
begin

    case BrowseMode of
        0: begin
          GenerateArtistList(Mp3ListeArtistSort, AlleArtists);
          InitAlbenList(Mp3ListeAlbenSort, AlleAlben);
        end;
        1: GenerateCoverList(Mp3ListeArtistSort, CoverList);
        2: ;// nothing to do
  end;
  // nicht senden SendMessage(MainWindowHandle, WM_RefillTrees, 0, 0);
  // Denn: Es sollen jetzt die alten Knoten wieder markiert werden
end;
Procedure TMedienBibliothek.RepairBrowseListsAfterChange;
begin
  case BrowseMode of
      0: begin
          Mp3ListeArtistSort.Sort(Sortieren_String1String2Titel_asc);
          Mp3ListeAlbenSort.Sort(Sortieren_String2String1Titel_asc);
          GenerateArtistList(Mp3ListeArtistSort, AlleArtists);
          InitAlbenList(Mp3ListeAlbenSort, AlleAlben);
      end;
      1: begin
          Mp3ListeArtistSort.Sort(Sortieren_CoverID);
          Mp3ListeAlbenSort.Sort(Sortieren_CoverID);
          GenerateCoverList(Mp3ListeArtistSort, CoverList);
      end;
      2: ;// nothing to to
  end;
end;

{
    --------------------------------------------------------
    GetStartEndIndex
    - Get the indices, where the wanted "name" can be found
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetStartEndIndex(Liste: TObjectlist; name: UnicodeString; Suchart: integer; var Start: integer; var Ende: Integer);
var einIndex: integer;
  min, max:integer;
begin
  // Bereich festlegen, in dem gesucht werden darf.
  min := Start;
  max := Ende;
  case Suchart of
        SEARCH_ARTIST:
                begin
                  if NempSortArray[1] = siOrdner then
                    einIndex := BinaerArtistSuche_JustContains(Liste, name, Start, Ende)
                  else
                    einIndex := BinaerArtistSuche(Liste, name, Start, Ende);

                  Start := EinIndex;
                  Ende := EinIndex;
                  if EinIndex = -1 then exit;

                  if NempSortArray[1] = siOrdner then
                  begin
                    while (Start > min) AND (Pos(name,(Liste[Start-1] as TAudiofile).Key1) = 1) do
                        dec(Start);
                    while (Ende < max) AND (Pos(name,(Liste[Ende+1] as TAudiofile).Key1) = 1) do
                        inc(Ende);
                  end else begin
                    // note: AnsiSameText uses correct Unicode
                    while (Start > min) AND (AnsiSameText(name,(Liste[Start-1] as TAudiofile).Key1)) do
                        dec(Start);
                    while (Ende < max) AND (AnsiSameText(name,(Liste[Ende+1] as TAudiofile).Key1)) do
                        inc(Ende);
                  end;
        end;
        SEARCH_ALBUM: begin
                  // Suchart : Search_album
                  if NempSortArray[2] = siOrdner then
                    einIndex := BinaerAlbumSuche_JustContains(Liste, name, Start, Ende)
                  else
                    einIndex := BinaerAlbumSuche(Liste, name, Start, Ende);
                  Start := EinIndex;
                  Ende := EinIndex;
                  if EinIndex = -1 then exit;
                  if NempSortArray[2] = siOrdner then
                  begin
                    while (Start > min) AND (Pos(name,(Liste[Start-1] as TAudiofile).Key2) = 1) do
                        dec(Start);
                    while (Ende < max) AND (Pos(name,(Liste[Ende+1] as TAudiofile).Key2) = 1) do
                        inc(Ende);
                  end else begin
                    while (Start > min) AND (AnsiSameText((Liste[Start-1] as TAudiofile).Key2,name)) do
                        dec(Start);
                    while (Ende < max) AND (AnsiSameText((Liste[Ende+1] as TAudiofile).Key2,name)) do
                        inc(Ende);
                  end;
        end;
        SEARCH_COVERID: begin
           // s.u.   (GetStartEndIndexCover)
        end;
  end;
end;
{
    --------------------------------------------------------
    GetStartEndIndexCover
    - Get the indices, where the wanted "name" can be found
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetStartEndIndexCover(Liste: TObjectlist; aCoverID: String; var Start: integer; var Ende: Integer);
var einIndex: integer;
  min, max:integer;
begin
  min := Start;
  max := Ende;
  einIndex := BinaerCoverIDSuche(Liste, aCoverID, Start, Ende);
  Start := EinIndex;
  Ende := EinIndex;
  while (Start > min) AND (AnsiSameText((Liste[Start-1] as TAudiofile).Key1, aCoverID)) do dec(Start);
  while (Ende < max) AND (AnsiSameText((Liste[Ende+1] as TAudiofile).Key1, aCoverID)) do inc(Ende);
end;

{
    --------------------------------------------------------
    GetAlbenList
    - When Browsing the left tree, fill the right tree
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetAlbenList(Artist: UnicodeString);
var i,start, Ende: integer;
  aktualAlbum, lastAlbum: UnicodeString;
  tmpstrlist: TStringList;
  tmpJaS: TJustaString;
begin
  for i := 0 to Alben.Count - 1 do
    TJustaString(Alben[i]).Free;

  Alben.Clear;

  if Artist = BROWSE_ALL then
  begin
      for i:=0 to AlleAlben.Count - 1 do
          Alben.Add(TJustAString.create(AlleAlben[i]));
  end else
  if Artist = BROWSE_RADIOSTATIONS then
  begin
      for i := 0 to RadioStationList.Count - 1 do
          Alben.Add(TJustaString.create(TStation(RadioStationList[i]).URL, TStation(RadioStationList[i]).Name))
  end else
  if Artist = BROWSE_PLAYLISTS then
  begin
      for i:=0 to AllPlaylistsNameSort.Count - 1 do
          Alben.Add(TJustastring.create(
              TJustastring(AllPlaylistsNameSort[i]).DataString,
              TJustastring(AllPlaylistsNameSort[i]).AnzeigeString));
  end
  else
  begin
      Alben.Add(TJustastring.create(BROWSE_ALL));

      // nur die Alben eines Artists einfügen
      // Voraussetzung: Sortierung der Liste nach Artist -> Album
      // Dann bei jedem Albumwechsel das Album einfügen
      Start := 0;
      Ende := Mp3ListeArtistSort.Count-1;
      GetStartEndIndex(Mp3ListeArtistSort, Artist, SEARCH_ARTIST, Start, Ende);

      if (start > Mp3ListeArtistSort.Count-1) OR (Mp3ListeArtistSort.Count < 1)  or (start < 0) then exit;

      if NempSortArray[1] = siOrdner then
      begin
          // Es sollen alle Alben aufgelistet werden, die in dem Ordner oder einem
          // Unterordner enthalten sind.
          // da die Liste primör nach Ordner, dann erst nach Album sortiert ist, kann
          // es da beim "einfachen" Einfügen zu doppelten Einträgen kommen, und/oder
          // zu einer unsortierten Liste. Daher:

          // Ja, der Trick mit der tmp-Liste ist etwas unschön. Das kann
          // man evtl. besser machen
          tmpstrlist := TStringList.Create;
          tmpstrlist.Sorted := True;
          tmpstrlist.Duplicates := dupIgnore;
          for i:= Start to Ende do
            //tmpstrlist.Add((Mp3ListeArtistSort[i] as TAudioFile).Strings[NempSortArray[2]]);
            tmpstrlist.Add((Mp3ListeArtistSort[i] as TAudioFile).Key2);

          for i := 0 to tmpstrlist.Count - 1 do
            Alben.Add(TJustastring.create(tmpstrlist[i]));

          tmpstrlist.Free;
      end else
      begin
            // Hier funktioniert das einfache EInfügen
            aktualAlbum := (Mp3ListeArtistSort[start] as TAudioFile).Key2;
            lastAlbum := aktualAlbum;
            Alben.Add(TJustastring.create(lastAlbum));

            for i := start+1 to Ende do
            begin
              aktualAlbum := (Mp3ListeArtistSort[i] as TAudioFile).Key2;
              if NOT AnsiSameText(aktualAlbum, lastAlbum) then
              begin
                lastAlbum := aktualAlbum;
                Alben.Add(TJustastring.create(lastAlbum));
              end;
            end;
      end;
  end;

  if (NempSortArray[2] <> siOrdner)
    AND (Artist <> BROWSE_RADIOSTATIONS)
    AND (Artist <> BROWSE_PLAYLISTS)
  then
  begin
    i := 1;      // <All> auslassen
    while (i < Alben.Count) and (AnsiCompareText(TJustastring(Alben[i]).AnzeigeString, AUDIOFILE_UNKOWN) < 0  ) do
      inc(i);

    start := i;
    if (start < Alben.Count) and (  AnsiCompareText(TJustastring(Alben[i]).AnzeigeString, AUDIOFILE_UNKOWN) = 0  ) then
    begin
        for i := start downto 2 do
        begin
            tmpJaS := TJustastring(Alben[i]);
            Alben[i] := Alben[i-1];
            Alben[i-1] := tmpJaS;
        end;
    end;
  end;
end;

{
    --------------------------------------------------------
    GetTitelList
    - Get the matching titles for "Artist" and "Album"
    --------------------------------------------------------
}
Procedure TMedienBibliothek.GetTitelList(Target: TObjectlist; Artist: UnicodeString; Album: UnicodeString);
var i, Start, Ende: integer;
begin
  Target.Clear;
  Start := 0;
  Ende := Mp3ListeArtistSort.Count - 1;

  if Artist <> BROWSE_ALL then
  begin
      if Album <> BROWSE_ALL then
      begin
          GetStartEndIndex(Mp3ListeAlbenSort, Album, SEARCH_ALBUM, Start, Ende);
          GetStartEndIndex(Mp3ListeAlbenSort, Artist, SEARCH_ARTIST, Start, Ende);
          if (start > Mp3ListeAlbenSort.Count - 1) OR (Mp3ListeAlbenSort.Count < 1) or (start < 0) then exit;
          for i := Start to Ende do
            Target.Add(Mp3ListeAlbenSort[i]);
      end else
      begin
        //alle Titel eines Artists - Jetzt ist wieder die Artist-Liste gefragt
        GetStartEndIndex(Mp3ListeArtistSort, Artist, SEARCH_ARTIST, Start, Ende);
        if (start > Mp3ListeArtistSort.Count - 1) OR (Mp3ListeArtistSort.Count < 1) or (start < 0) then exit;
        for i := Start to Ende do
          Target.Add(Mp3ListeArtistSort[i]);
      end;
  end else
  begin
        //Artist ist <Alle>. d.h. es werden alle Titel oder alle Titel eines Albums gewünscht.
        // d.h. jetzt ist die Sortierung Album benötigt!!
        if Album <> BROWSE_ALL then
          GetStartEndIndex(Mp3ListeAlbenSort , Album, SEARCH_ALBUM, Start, Ende);
        if start = -1 then exit;
        for i := Start to Ende do
          Target.Add(Mp3ListeAlbenSort[i]);
  end;
end;

function TMedienBibliothek.IsAutoSortWanted: Boolean;
begin
    result := AlwaysSortAnzeigeList
          And
          ( (AnzeigeListe.Count + AnzeigeListe2.Count < 5000) or (Not SkipSortOnLargeLists));
end;

{
    --------------------------------------------------------
    GenerateAnzeigeListe
    - GetTitelList with Target=Anzeigeliste
    (has gone a little complicated since allowing webradio and playlists there...)
    --------------------------------------------------------
}
Procedure TMedienBibliothek.GenerateAnzeigeListe(Artist: UnicodeString; Album: UnicodeString; UpdateQuickSearchList: Boolean = True);
var i: Integer;
begin
  AnzeigeListIsCurrentlySorted := False;
  if Artist = BROWSE_PLAYLISTS then
  begin
      // Playlist Datei in PlaylistFiles laden.
      PlaylistFiles.Clear;
      AnzeigeListe.Clear;
      AnzeigeListe2.Clear;

      if FileExists(Album) then
      begin
          LoadPlaylistFromFile(Album, PlaylistFiles, AutoScanPlaylistFilesOnView);

          AnzeigeShowsPlaylistFiles := True;
          for i := 0 to PlaylistFiles.Count - 1 do
              AnzeigeListe.Add(TAudioFile(PlaylistFiles[i]));
          SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0)
      end else
          SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  100);

  end else
  if Artist = BROWSE_RADIOSTATIONS then
  begin
      AnzeigeListe.Clear;
      AnzeigeListe2.Clear;
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0);
  end else
  begin
      AnzeigeShowsPlaylistFiles := False;
      GetTitelList(AnzeigeListe, Artist, Album);
      if IsAutoSortWanted then
          SortAnzeigeliste;
      if UpdateQuickSearchList then
          FillQuickSearchList;
      SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0);
  end;
end;
{
    --------------------------------------------------------
    GetTitelListFromCoverID
    - Same as above, for Coverflow
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetTitelListFromCoverID(Target: TObjectlist; aCoverID: String);
var i, Start, Ende: integer;
begin
  Target.Clear;
  Start := 0;
  Ende := Mp3ListeArtistSort.Count - 1;

  if (aCoverID <> 'all') then // and (aCoverID <> '') then
    GetStartEndIndexCover(Mp3ListeArtistSort, aCoverID, Start, Ende);

  if (start > Mp3ListeArtistSort.Count - 1) OR (Mp3ListeArtistSort.Count < 1) or (start < 0) then
      exit;

  for i := Start to Ende do
      Target.Add(Mp3ListeArtistSort[i]);
end;
{
    --------------------------------------------------------
    GenerateAnzeigeListeFromCoverID
    - Same as above, for Coverflow
    --------------------------------------------------------
}
procedure TMedienBibliothek.GenerateAnzeigeListeFromCoverID(aCoverID: String);
begin
  AnzeigeListIsCurrentlySorted := False;

  AnzeigeListe2.Clear;
  GetTitelListFromCoverID(AnzeigeListe, aCoverID);

  AnzeigeShowsPlaylistFiles := False;
  AnzeigeListIsCurrentlySorted := False;
  if IsAutoSortWanted then
      SortAnzeigeliste;
  FillQuickSearchList;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0);
end;
{
    --------------------------------------------------------
    GenerateAnzeigeListeFromTagCloud
    - Same as above, for TagCloud
      this is called when teh user clicks a Tag in the cloud,
      not in the breadcrumb-navigation
    --------------------------------------------------------
}
procedure TMedienBibliothek.GenerateAnzeigeListeFromTagCloud(aTag: TTag; BuildNewCloud: Boolean);
var i: Integer;
begin
  if not assigned(aTag) then exit;


  AnzeigeListIsCurrentlySorted := False;

  AnzeigeListe.Clear;
  AnzeigeListe2.Clear;

  if aTag = TagCloud.ClearTag then
      for i := 0 to Mp3ListeArtistSort.Count - 1 do
          AnzeigeListe.Add(Mp3ListeArtistSort[i])
  else
      // we need no binary search or stuff here. The Tag saves all its AudioFiles.
      for i := 0 to aTag.AudioFiles.Count - 1 do
          AnzeigeListe.Add(aTag.AudioFiles[i]);

  if BuildNewCloud then
      TagCloud.BuildCloud(Mp3ListeArtistSort, aTag, False);
      // Note: Parameter Mp3ListeArtistSort is not used in this method, as the Filelist of aTag is used!


  AnzeigeShowsPlaylistFiles := False;
  AnzeigeListIsCurrentlySorted := False;
  if IsAutoSortWanted then
      SortAnzeigeliste;
  FillQuickSearchList;
  SendMessage(MainWindowHandle, WM_MedienBib, MB_ReFillAnzeigeList,  0);
end;

{
    --------------------------------------------------------
    GetCoverWithPrefix
    - Get the first/next matching cover
    Used by OnKeyDown of the CoverScrollbar
    --------------------------------------------------------
}
function TMedienBibliothek.GetCoverWithPrefix(aPrefix: UnicodeString; Startidx: Integer): Integer;
var nextidx: Integer;
    aCover: TNempCover;
    erfolg: Boolean;
begin
  nextIdx := Startidx;
  result := StartIdx;

  erfolg := False;
  repeat
    aCover := Coverlist[nextIdx] as TNempCover;
    if AnsiStartsText(aPrefix, aCover.Artist) or AnsiStartsText(aPrefix, aCover.Album)
    then
    begin
      result := nextIdx;
      erfolg := True;
    end;
    nextIdx := (nextIdx + 1) Mod (Coverlist.Count);
  until erfolg or (nextIdx = StartIdx);
end;


{
    --------------------------------------------------------
    FillQuickSearchList
    ShowQuickSearchList
    - Set/Get the QuickSearchList
    --------------------------------------------------------
}
procedure TMedienBibliothek.FillQuickSearchList;
begin
  if AnzeigeShowsPlaylistFiles then
      MessageDLG((Medialibrary_QuickSearchError1), mtError, [MBOK], 0)
  else
      BibSearcher.SetQuickSearchList(AnzeigeListe);
end;
Procedure TMedienBibliothek.ShowQuickSearchList;
begin
    AnzeigeShowsPlaylistFiles := False;
    AnzeigeListIsCurrentlySorted := False;
    BibSearcher.ShowQuickSearchList;
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
    EnterCriticalSection(CSUpdate);
    BibSearcher.GlobalQuickSearch(Keyword, AllowErr);
    LeaveCriticalSection(CSUpdate);
end;
procedure TMedienBibliothek.CompleteSearch(Keywords: TSearchKeyWords);
begin
    if StatusBibUpdate >= 2 then exit;
    EnterCriticalSection(CSUpdate);
    BibSearcher.CompleteSearch(KeyWords);
    LeaveCriticalSection(CSUpdate);
end;

{
    --------------------------------------------------------
    GetFilesInDir
    - Get all files in the library within the given directory
    --------------------------------------------------------
}
procedure TMedienBibliothek.GetFilesInDir(aDirectory: UnicodeString);
var i: Integer;
begin
  if StatusBibUpdate >= 2 then exit;
  EnterCriticalSection(CSUpdate);

  if Not AnzeigeShowsPlaylistFiles then
  begin
      for i := 0 to MP3ListeArtistSort.Count-1 do
        if (Mp3ListeArtistSort[i] as tAudiofile).Ordner = aDirectory then
          AnzeigeListe.Add(Mp3ListeArtistSort[i]);
  end else
      MessageDLG((Medialibrary_GUIError1), mtError, [MBOK], 0);

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
        CON_ARTIST              : NewSortMethod := AFCompareArtist;
        CON_TITEL               : NewSortMethod := AFCompareTitle;
        CON_ALBUM               : NewSortMethod := AFCompareAlbum;
        CON_DAUER               : NewSortMethod := AFCompareDuration;
        CON_BITRATE             : NewSortMethod := AFCompareBitrate;
        CON_CBR                 : NewSortMethod := AFCompareCBR;
        CON_MODE                : NewSortMethod := AFCompareChannelMode;
        CON_SAMPLERATE          : NewSortMethod := AFCompareSamplerate;
        CON_STANDARDCOMMENT     : NewSortMethod := AFCompareComment;
        CON_FILESIZE            : NewSortMethod := AFCompareFilesize;
        CON_PFAD                : NewSortMethod := AFComparePath;
        CON_ORDNER              : NewSortMethod := AFCompareDirectory;
        CON_DATEINAME           : NewSortMethod := AFCompareFilename;
        CON_EXTENSION           : NewSortMethod := AFCompareExtension;
        CON_YEAR                : NewSortMethod := AFCompareYear;
        CON_GENRE               : NewSortMethod := AFCompareGenre;
        CON_LYRICSEXISTING      : NewSortMethod := AFCompareLyricsExists;
        CON_TRACKNR             : NewSortMethod := AFCompareTrackNr;
        CON_RATING              : NewSortMethod := AFCompareRating;
        CON_PLAYCOUNTER         : NewSortMethod := AFComparePlayCounter;
        CON_LASTFMTAGS          : NewSortMethod := AFCompareLastFMTagsExists;
    else
        NewSortMethod := AFComparePath;
    end;

    if (TreeHeaderColumnTag = SortParams[0].Tag) and FlipSame then
    begin
        // wuppdi;
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
{
    --------------------------------------------------------
    SortAList
    SortAnzeigeListe
    - Sort the files in the list
    --------------------------------------------------------
}
procedure TMedienBibliothek.SortAList(aList: TObjectList);
begin

    aList.Sort(MainSort);
 {
  case SortParam of                                 // +++_asc   else    +++_desc
    CON_ARTIST              : if SortAscending then aList.Sort(Sortieren_ArtistTitel_asc) else aList.Sort(Sortieren_ArtistTitel_desc);
    CON_TITEL               : if SortAscending then aList.Sort(Sortieren_TitelArtist_asc) else aList.Sort(Sortieren_TitelArtist_desc);
    CON_ALBUM               : if SortAscending then aList.Sort(Sortieren_AlbumArtistTitel_asc) else aList.Sort(Sortieren_AlbumArtistTitel_desc);
    CON_DAUER               : if SortAscending then aList.Sort(Sortieren_Dauer_asc) else aList.Sort(Sortieren_Dauer_desc);
    CON_BITRATE             : if SortAscending then aList.Sort(Sortieren_Bitrate_asc) else aList.Sort(Sortieren_Bitrate_desc);
    CON_CBR                 : if SortAscending then aList.Sort(Sortieren_CBR_asc) else aList.Sort(Sortieren_CBR_desc);
    CON_MODE                : if SortAscending then aList.Sort(Sortieren_Mode_asc) else aList.Sort(Sortieren_Mode_desc);
    CON_SAMPLERATE          : if SortAscending then aList.Sort(Sortieren_Samplerate_asc) else aList.Sort(Sortieren_Samplerate_desc);
    CON_STANDARDCOMMENT     : if SortAscending then aList.Sort(Sortieren_Comment_asc) else aList.Sort(Sortieren_Comment_desc);
    CON_FILESIZE            : if SortAscending then aList.Sort(Sortieren_DateiGroesse_asc) else aList.Sort(Sortieren_DateiGroesse_desc);
    CON_PFAD                : if SortAscending then aList.Sort(Sortieren_Pfad_asc) else aList.Sort(Sortieren_Pfad_desc);
    CON_ORDNER              : if SortAscending then aList.Sort(Sortieren_Pfad_asc) else aList.Sort(Sortieren_Pfad_desc);
    CON_DATEINAME           : if SortAscending then aList.Sort(Sortieren_Dateiname_asc) else aList.Sort(Sortieren_Dateiname_desc);
    CON_YEAR                : if SortAscending then aList.Sort(Sortieren_Jahr_asc) else aList.Sort(Sortieren_Jahr_desc);
    CON_GENRE               : if SortAscending then aList.Sort(Sortieren_Genre_asc) else aList.Sort(Sortieren_Genre_desc);
    CON_LYRICSEXISTING      : if SortAscending then aList.Sort(Sortieren_Lyrics_asc) else aList.Sort(Sortieren_Lyrics_desc);
    CON_TRACKNR             : if SortAscending then aList.Sort(Sortieren_Track_asc) else aList.Sort(Sortieren_Track_desc);
    CON_EX_ARTISTALBUMTITEL : if SortAscending then aList.Sort(Sortieren_ArtistAlbumTitel_asc) else aList.Sort(Sortieren_ArtistAlbumTitel_desc);
    CON_EX_ALBUMTITELARTIST : if SortAscending then aList.Sort(Sortieren_AlbumTitelArtist_asc) else aList.Sort(Sortieren_AlbumTitelArtist_desc);
    CON_EX_ALBUMTRACK       : if SortAscending then aList.Sort(Sortieren_AlbumTrack_asc) else aList.Sort(Sortieren_AlbumTrack_Desc);
    CON_RATING              : if SortAscending then aList.Sort(Sortieren_Rating_asc) else aList.Sort(Sortieren_Rating_Desc);
  end;
  }
end;
procedure TMedienBibliothek.SortAnzeigeListe;
begin
  SortAList(AnzeigeListe);
  SortAList(AnzeigeListe2);
  AnzeigeListIsCurrentlySorted := True;
end;

{
    --------------------------------------------------------
    CheckGenrePL
    CheckYearRange
    CheckRating
    CheckLength
    CheckTags
    - Helper for FillRandomList
    --------------------------------------------------------
}
//function TMedienBibliothek.CheckGenrePL(Genre: UnicodeString): Boolean;
//var GenreIDX: Integer;
//begin
  //if PlaylistFillOptions.SkipGenreCheck then
  //  result := true
  //else
  //begin
  //  GenreIDX := PlaylistFillOptions.GenreStrings.IndexOf(Genre);
  //  if GenreIDX > -1 then
  //    result := PlaylistFillOptions.GenreChecked[GenreIDX]
  //  else
  //    result := False; //PlaylistFillOptions.IncludeNAGenres; // Unbekannte genres auch aufzählen
  //end;
//end;

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
function TMedienBibliothek.CheckTags(aTagList: TObjectList): Boolean;
var i, c: Integer;
begin
    if PlaylistFillOptions.SkipTagCheck or (not assigned(PlaylistFillOptions.WantedTags)) then
        result := true
    else
    begin
        c := 0;
        for i := 0 to PlaylistFillOptions.WantedTags.Count - 1 do
        begin
            if aTagList.IndexOf(PlaylistFillOptions.WantedTags[i]) >= 0 then
                inc(c);
        end;
        result := c >= PlaylistFillOptions.MinTagMatchCount;
    end;
end;

{
    --------------------------------------------------------
    FillRandomList
    - Generate a Random list from the library
    --------------------------------------------------------
}
procedure TMedienBibliothek.FillRandomList(aList: TObjectlist);
var sourceList: TObjectlist;
    i: Integer;
    aAudioFile: TAudioFile;
begin
  EnterCriticalSection(CSUpdate);

  if PlaylistFillOptions.WholeBib then
    SourceList := Mp3ListePfadSort
  else
    SourceList := AnzeigeListe;
  // passende Stücke zusammensuchen
  for i := 0 to SourceList.Count - 1 do
  begin
    aAudioFile := SourceList[i] as TAudioFile;
    if CheckYearRange(aAudioFile.Year)
        //and CheckGenrePL(aAudioFile.Genre)
        and CheckRating(aAudioFile.Rating)
        and CheckLength(aAudioFile.Duration)
        and CheckTags(aAudioFile.Taglist)
        then
      aList.Add(aAudioFile);
  end;
  // Liste mischen
  for i := 0 to aList.Count-1 do
    aList.Exchange(i,i + random(aList.Count-i));
  // Überflüssiges löschen
  For i := aList.Count - 1 downto PlaylistFillOptions.MaxCount do
    aList.Delete(i);

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
    SynchronizeDrives
    --------------------------------------------------------
}
procedure TMedienBibliothek.SynchronizeDrives(Source: TObjectList);
var PCDrives: TObjectlist;
    iSource: Integer;
    CurrentDrive, syncPCDrive, newDrive: TDrive;
    LastCheckedDriveChar: Char;
begin
    EnterCriticalSection(CSAccessDriveList);
    PCDrives := TObjectList.Create;
    try
        GetLogicalDrives(PCDrives);
        LastCheckedDriveChar := 'C';
        fUsedDrives.Clear;
        for iSource := 0 to Source.Count - 1 do
        begin
            CurrentDrive := tDrive(Source[iSource]);

            // Seriennummer dieses Laufwerks in der PC-Liste suchen
            syncPCDrive := GetDriveFromListBySerialNr(PCDrives, CurrentDrive.SerialNr);
            if assigned(syncPCDrive) then
            begin
                // Laufwerk vorhanden
                newDrive := TDrive.Create;
                newDrive.Assign(syncPCDrive);
                newDrive.OldChar := CurrentDrive.Drive[1];
                fUsedDrives.Add(newDrive);
            end else
            begin
                // Laufwerk nicht gefunden. Also nicht angeschlossen/nicht vorhanden
                // jetzt: Schauen, ob der Laufwerksbuchstabe in Gebrauch ist.
                if Not assigned(GetDriveFromListByChar(PCDrives, CurrentDrive.Drive[1])) then
                begin
                    // Laufwerksbuchstabe nicht am Rechner in Gebrauch -> weiterverwenden
                    newDrive := TDrive.Create;
                    newDrive.Assign(CurrentDrive);
                    newDrive.OldChar := CurrentDrive.Drive[1];
                    fusedDrives.Add(NewDrive);
                end else
                begin
                    // Laufwerk mit der Seriennummer nicht da, aber Buchstabe am PC in Gebrauch
                    // -> Ausweichplatz suchen
                    While (assigned(GetDriveFromListByChar(PCDrives, LastCheckedDriveChar))
                          OR assigned(GetDriveFromListByChar(Source, LastCheckedDriveChar)))
                      and (LastCheckedDriveChar <> 'Z') do
                          // nächsten Buchstaben probieren
                          LastCheckedDriveChar := Chr(Ord(LastCheckedDriveChar) + 1);

                    newDrive := TDrive.Create;
                    newDrive.Assign(CurrentDrive);
                    newDrive.Drive := LastCheckedDriveChar + ':\';
                    newDrive.OldChar := CurrentDrive.Drive[1];
                    fusedDrives.Add(NewDrive);
               end;
            end;
        end;
    finally
        PCDrives.Free;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;

{
    --------------------------------------------------------
    DrivesHaveChanged
    --------------------------------------------------------
}
function TMedienBibliothek.DrivesHaveChanged: Boolean;
var i: Integer;
begin
    EnterCriticalSection(CSAccessDriveList);
    result := False;
    for i := 0 to fusedDrives.Count - 1 do
    begin
        if TDrive(fUsedDrives[i]).Drive[1] <> TDrive(fUsedDrives[i]).OldChar then
        begin
            result := True;
            break;
        end;
    end;
    LeaveCriticalSection(CSAccessDriveList);
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
var CurrentUsedDrives: TObjectList;
    i: Integer;
    NewDrive: TDrive;
begin
    //result := False;
    EnterCriticalSection(CSAccessDriveList);
    CurrentUsedDrives := TObjectList.Create;
    try
        for i := 0 to fusedDrives.Count - 1 do
        begin
            NewDrive := TDrive.Create;
            NewDrive.Assign(TDrive(fUsedDrives[i]));
            CurrentUsedDrives.Add(NewDrive);
        end;
        // Laufwerke Neu synchronisieren
        SynchronizeDrives(CurrentUsedDrives);
        result := DrivesHaveChanged;
    finally
        CurrentUsedDrives.Free;
    end;
    LeaveCriticalSection(CSAccessDriveList);
end;
{
    --------------------------------------------------------
    RepairDriveCharsAtAudioFiles
    RepairDriveCharsAtPlaylistFiles
    - Change all AudioFiles according to the new situation
    --------------------------------------------------------
}
procedure TMedienBibliothek.RepairDriveCharsAtAudioFiles;
var i: Integer;
    CurrentDriveChar, CurrentReplaceChar: WideChar;
    aAudioFile: TAudioFile;
    aDrive: TDrive;
begin
    EnterCriticalSection(CSAccessDriveList);
    CurrentDriveChar := '-';
    CurrentReplaceChar := '-';
    for i := 0 to Mp3ListePfadsort.Count - 1 do
    begin
        aAudioFile := TAudioFile(Mp3ListePfadsort[i]);
        if (aAudioFile.Ordner[1] <> CurrentDriveChar) then
        begin
            if aAudioFile.Ordner[1] <> '\' then
            begin
                aDrive := GetDriveFromListByOldChar(fUsedDrives, Char(aAudioFile.Ordner[1]));
                if assigned(aDrive) and (aDrive.Drive <> '') then
                begin
                    // aktuelle Buchstaben merken
                    // und replaceChar neu setzen
                    CurrentDriveChar := aAudioFile.Ordner[1];
                    CurrentReplaceChar := WideChar(aDrive.Drive[1]);
                end else
                begin
                    MessageDLG((Medialibrary_DriveRepairError), mtError, [MBOK], 0);
                    exit;
                end;
            end else
            begin
                CurrentDriveChar := '\';
                CurrentReplaceChar := '\';
            end;
        end;
        aAudioFile.SetNewDriveChar(CurrentReplaceChar);
    end;
    LeaveCriticalSection(CSAccessDriveList);

    // am Ende die Pfadsort-Liste neu sortieren
    Mp3ListePfadsort.Sort(Sortieren_Pfad_asc);
end;
procedure TMedienBibliothek.RepairDriveCharsAtPlaylistFiles;
var i: Integer;
    CurrentDriveChar, CurrentReplaceChar: WideChar;
    aString: TJustaString;
    aDrive: TDrive;
begin
    CurrentDriveChar := '-';
    CurrentReplaceChar := '-';
    EnterCriticalSection(CSAccessDriveList);
    for i := 0 to AllPlaylistsPfadSort.Count - 1 do
    begin
        aString := TJustaString(AllPlaylistsPfadSort[i]);
        if (aString.DataString[1] <> CurrentDriveChar) then
        begin
            if (aString.DataString[1] <> '\') then
            begin
                // Neues Laufwerk - Infos dazwischenschieben
                aDrive := GetDriveFromListByOldChar(fUsedDrives, Char(aString.DataString[1]));
                if assigned(aDrive) and (aDrive.Drive <> '') then
                begin
                    // aktuelle Buchstaben merken
                    // und replaceChar neu setzen
                    CurrentDriveChar := aString.DataString[1];
                    CurrentReplaceChar := WideChar(aDrive.Drive[1]);
                end else
                begin
                    MessageDLG((Medialibrary_DriveRepairError), mtError, [MBOK], 0);
                    exit;
                end;
            end else
            begin
                CurrentDriveChar := '\';
                CurrentReplaceChar := '\';
            end;
        end;
        aString.DataString[1] := CurrentReplaceChar
        //aAudioFile.SetNewDriveChar(CurrentReplaceChar);
    end;
    LeaveCriticalSection(CSAccessDriveList);
    // am Ende die Pfadsort-Liste neu sortieren
    AllPlaylistsPfadSort.Sort(PlaylistSort_Name);
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
    i, c: Integer;
begin
    fs := Nil;
    try
        fs := TMemoryStream.Create;
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
        if assigned(fs) then
            fs.Free;
    end;
end;
procedure TMedienBibliothek.ImportFavorites(aFilename: UnicodeString);
var fs: TMemoryStream;
begin
    fs := Nil;
    try
        fs := TMemoryStream.Create;
        fs.LoadFromFile(aFilename);
        fs.Position := 0;
        LoadRadioStationsFromStream(fs);
        Changed := True;
    finally
        if assigned(fs) then
            fs.Free;
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
      tmpstrList.Capacity := Mp3ListeArtistSort.Count + 1;
      tmpstrList.Add('Artist;Title;Album;Genre;Year;Track;Filename;Directory;Filesize;Duration;Bitrate;Channelmode;Samplerate;Rating;Playcounter;vbr;Lyrics');
      for i:= 0 to Mp3ListeArtistSort.Count - 1 do
        tmpstrList.Add((Mp3ListeArtistSort[i] as TAudioFile).GenerateCSVString);
      try
          tmpStrList.SaveToFile(aFileName);
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
procedure TMedienBibliothek.LoadDrivesFromStream(aStream: TStream);
var SavedDriveList: TObjectList;
    DriveCount, i: Integer;
    newDrive: TDrive;
begin
    SavedDriveList := TObjectList.Create;
    aStream.Read(DriveCount, SizeOf(Integer));

    for i := 0 to DriveCount - 1 do
    begin
        newDrive := TDrive.Create;
        newDrive.LoadFromStream(aStream);
        SavedDriveList.Add(newDrive);
    end;
  // Daten synchronisieren
  SynchronizeDrives(SavedDriveList);
  SavedDriveList.Free;
end;
procedure TMedienBibliothek.SaveDrivesToStream(aStream: TStream);
var tmpStream: TMemoryStream;
    i, len: Integer;
    MainID: Byte;
begin
    tmpStream := TMemoryStream.Create;
    tmpStream.Write(fUsedDrives.Count, SizeOf(Integer));
    for i := 0 to fUsedDrives.Count-1 do
    begin
        TDrive(fUsedDrives[i]).ID := i;
        TDrive(fUsedDrives[i]).SaveToStream(tmpStream);
    end;

    MainID := 2;
    aStream.Write(MainID, SizeOf(Byte));
    len := tmpStream.Size;
    aStream.Write(len, SizeOf(Integer));

    tmpStream.SaveToStream(aStream);
    tmpStream.Free;
end;
{
    --------------------------------------------------------
    LoadAudioFilesFromStream
    SaveAudioFilesToStream
    - Read/Write a List of TAudioFiles
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadAudioFilesFromStream(aStream: TStream);
var FilesCount, i, DriveID: Integer;
    newAudioFile: TAudioFile;
    ID: Byte;
    CurrentDriveChar: WideChar;
begin
    CurrentDriveChar := 'C';
    aStream.Read(FilesCount, SizeOf(FilesCount));
    for i := 1 to FilesCount do
    begin
        aStream.Read(ID, SizeOf(ID));
        case ID of
            0: begin
                newAudioFile := TAudioFile.Create;
                newAudioFile.LoadFromStream(aStream);
                newAudioFile.SetNewDriveChar(CurrentDriveChar);
                UpdateList.Add(newAudioFile);
            end;
            1: begin
                // LaufwerksID lesen, diese suchen, LW-Buchstaben auslesen.
                aStream.Read(DriveID, SizeOf(DriveID));
                // DriveID ist der index des Laufwerks in der fDrives-Liste
                if DriveID < fUsedDrives.Count then
                begin
                    aStream.Read(ID, SizeOf(ID));
                    if ID <> 0 then
                    begin
                        MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'DriveID falsch: ID <> 0'), mtError, [MBOK], 0);
                        exit;
                    end;
                    if DriveID = -1 then
                        CurrentDriveChar := '\'
                    else
                        CurrentDriveChar := WideChar(TDrive(fUsedDrives[DriveID]).Drive[1]);
                    newAudioFile := TAudioFile.Create;
                    newAudioFile.LoadFromStream(aStream);
                    newAudioFile.SetNewDriveChar(CurrentDriveChar);
                    UpdateList.Add(newAudioFile);
                end else
                begin
                    MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'DriveID falsch: ' + IntToStr(DriveID)), mtError, [MBOK], 0);
                    exit;
                end;
            end;
        else
            MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'ID falsch: ' + inttostr(ID)), mtError, [MBOK], 0);
            exit;
        end;
    end;
end;
procedure TMedienBibliothek.SaveAudioFilesToStream(aStream: TStream);
var tmpStream: TMemoryStream;
    i, len: Integer;
    CurrentDriveChar: WideChar;
    aAudioFile: TAudioFile;
    aDrive: tDrive;
    MainID, ID: Byte;
    c: Integer;
    tmpid: Integer;
begin
    tmpStream := TMemoryStream.Create;
    tmpStream.Size := 2000 * Mp3ListePfadSort.Count;
    c := Mp3ListePfadSort.Count;
    tmpStream.Write(c, sizeOf(c));
    CurrentDriveChar := '-';

    for i := 0 to Mp3ListePfadSort.Count - 1 do
    begin
        aAudioFile := TAudioFile(MP3ListePfadSort[i]);
        if aAudioFile.Ordner[1] <> CurrentDriveChar then
        begin
            if aAudioFile.Ordner[1] <> '\' then
            begin
                // Neues Laufwerk - Infos dazwischenschieben
                aDrive := GetDriveFromListByChar(fUsedDrives, Char(aAudioFile.Ordner[1]));
                if assigned(aDrive) then
                begin
                    ID := 1;
                    tmpStream.Write(ID, SizeOf(ID));
                    tmpStream.Write(aDrive.ID, SizeOf(aDrive.ID));
                    CurrentDriveChar := aAudioFile.Ordner[1];
                end else
                begin
                    MessageDLG((Medialibrary_SaveException1), mtError, [MBOK], 0);
                    exit;
                end;
            end else
            begin
                    ID := 1;
                    tmpStream.Write(ID, SizeOf(ID));
                    tmpid := -1;
                    tmpStream.Write(tmpid, SizeOf(tmpid));
                    CurrentDriveChar := aAudioFile.Ordner[1];
            end;
        end;
        ID := 0;
        tmpStream.Write(ID, SizeOf(ID));
        aAudioFile.SaveToStream(tmpStream, '');
    end;
    tmpStream.size := tmpStream.Position;

    MainID := 1;
    aStream.Write(MainID, SizeOf(MainID));
    len := tmpStream.Size;
    aStream.Write(len, SizeOf(len));
    tmpStream.SaveToStream(aStream);
    tmpStream.Free;
end;
{
    --------------------------------------------------------
    LoadPlaylistsFromStream
    SavePlaylistsToStream
    - Read/Write a List of Playlist-Files (TJustaStrings)
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadPlaylistsFromStream(aStream: TStream);
var FilesCount, i, DriveID: Integer;
    jas: TJustaString;
    ID: Byte;
    CurrentDriveChar: WideChar;
    tmputf8: UTF8String;
    tmpWs: UnicodeString;
    len: Integer;
begin
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

                jas := TJustaString.create(tmpWs, ExtractFileName(tmpWs));
                PlaylistUpdateList.Add(jas);
            end;
            1: begin
                // LaufwerksID lesen, diese suchen, LW-Buchstaben auslesen.
                aStream.Read(DriveID, SizeOf(DriveID));
                // DriveID ist der index des Laufwerks in der fDrives-Liste
                if DriveID < fUsedDrives.Count then
                begin
                    aStream.Read(ID, SizeOf(ID));
                    if ID <> 0 then
                    begin
                        MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'DriveID falsch: ID <> 0'), mtError, [MBOK], 0);
                        exit;
                    end;
                    if DriveID = -1 then
                        CurrentDriveChar := '\'
                    else
                        CurrentDriveChar := WideChar(TDrive(fUsedDrives[DriveID]).Drive[1]);
                    aStream.Read(len,sizeof(len));
                    setlength(tmputf8, len);
                    aStream.Read(PAnsiChar(tmputf8)^,len);
                    tmpWs := UTF8ToString(tmputf8);
                    tmpWs[1] := CurrentDriveChar;

                    jas := TJustaString.create(tmpWs, ExtractFileName(tmpWs));
                    PlaylistUpdateList.Add(jas);
                end else
                begin
                    MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'DriveID falsch: ' + IntToStr(DriveID)), mtError, [MBOK], 0);
                    exit;
                end;
            end;
        else
            MessageDLG((Medialibrary_InvalidLibFile + #13#10 + 'ID falsch: ' + inttostr(ID)), mtError, [MBOK], 0);
            exit;
        end;
    end;

end;
procedure TMedienBibliothek.SavePlaylistsToStream(aStream: TStream);
var tmpStream: TMemoryStream;
    i, len: Integer;
    CurrentDriveChar: WideChar;
    jas: TJustaString;
    aDrive: tDrive;
    MainID, ID: Byte;
    c: Integer;
    tmpstr: UTF8String;
    tmpid: Integer;
begin
    tmpStream := TMemoryStream.Create;
    tmpStream.Size := 100 * AllPlaylistsPfadSort.Count;
    c := AllPlaylistsPfadSort.Count;
    tmpStream.Write(c, sizeOf(c));
    CurrentDriveChar := '-';

    for i := 0 to AllPlaylistsPfadSort.Count - 1 do
    begin
        jas := TJustaString(AllPlaylistsPfadSort[i]);

        if jas.DataString[1] <> CurrentDriveChar then
        begin
            // Neues Laufwerk - Infos dazwischenschieben
            if jas.DataString[1] <> '\' then
            begin
                    aDrive := GetDriveFromListByChar(fUsedDrives, Char(jas.DataString[1]));
                    if assigned(aDrive) then
                    begin
                        ID := 1;
                        tmpStream.Write(ID, SizeOf(ID));
                        tmpStream.Write(aDrive.ID, SizeOf(aDrive.ID));
                        CurrentDriveChar := jas.DataString[1];
                    end else
                    begin
                        MessageDLG((Medialibrary_SaveException1), mtError, [MBOK], 0);
                        exit;
                    end;
            end else
            begin
                    ID := 1;
                    tmpStream.Write(ID, SizeOf(ID));
                    tmpid := -1;
                    tmpStream.Write(tmpid, SizeOf(tmpid));
                    CurrentDriveChar := jas.DataString[1];
            end;
        end;
        ID := 0;
        tmpStream.Write(ID, SizeOf(ID));

        // String schreiben
        tmpstr := UTF8Encode(jas.DataString);
        len := length(tmpstr);
        tmpStream.Write(len, SizeOf(len));
        tmpStream.Write(PAnsiChar(tmpstr)^,len);
    end;
    tmpStream.size := tmpStream.Position;


    MainID := 3;
    aStream.Write(MainID, SizeOf(MainID));
    len := tmpStream.Size;
    aStream.Write(len, SizeOf(len));
    tmpStream.SaveToStream(aStream);
    tmpStream.Free;
end;
{
    --------------------------------------------------------
    LoadRadioStationsFromStream
    SaveRadioStationsToStream
    - Read/Write a List of Webradio stations
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadRadioStationsFromStream(aStream: TStream);
var i, c: Integer;
    NewStation: TStation;
begin
    aStream.Read(c, SizeOf(c));
    // Stationen laden
    for i := 1 to c do
    begin
        NewStation := TStation.Create(MainWindowHandle);
        NewStation.LoadFromStream(aStream);
        RadioStationList.Add(NewStation);
    end;
end;

procedure TMedienBibliothek.SaveRadioStationsToStream(aStream: TStream);
var i, c, len: Integer;
    tmpStream: TMemoryStream;
    MainID: Byte;
begin
    c := RadioStationList.Count;
    tmpStream := TMemoryStream.Create;
    tmpStream.Write(c, SizeOf(c));
    // speichern
    for i := 0 to c-1 do
        TStation(RadioStationList[i]).SaveToStream(tmpStream);
    
    MainID := 4;
    aStream.Write(MainID, SizeOf(MainID));
    len := tmpStream.Size;
    aStream.Write(len, SizeOf(len));
    tmpStream.SaveToStream(aStream);
    tmpStream.Free;
end;

{
    --------------------------------------------------------
    LoadFromFile4
    - Load a gmp-File in Nemp 3.3-Format
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadFromFile4(aStream: TStream);
var MainID: Byte;
    BlockSize: Integer;
begin
  // neues Format besteht aus mehreren "Blöcken"
  // Jeder Block beginnt mit einer ID (1 Byte)
  //             und einer Größenangabe (4 Bytes)
  // Die einzelnen Blöcke werden getrennt geladen und gespeichert
  // wichtig: Zuerst die Laufwerks-Liste in die Datei speichern,
  // DANACH die Audiodateien
  // Denn: In der Audioliste wird Bezug auf die UsedDrives genommen!!

  While aStream.Position < aStream.Size do
  begin
      aStream.Read(MainID, SizeOf(Byte));
      aStream.Read(BlockSize, SizeOf(Integer));

      case MainID of
          1: LoadAudioFilesFromStream(aStream); // Audiodaten lesen
          2: LoadDrivesFromStream(aStream); // Drive-Info lesen
          3: LoadPlaylistsFromStream(aStream);
          4: LoadRadioStationsFromStream(aStream);
      else
        aStream.Seek(BlockSize, soFromCurrent);
      end;
  end;
end;

{
    --------------------------------------------------------
    LoadFromFile
    - Load a gmp-File
    --------------------------------------------------------
}
procedure TMedienBibliothek.LoadFromFile(aFilename: UnicodeString);
var
    aStream: TMemoryStream;
    Header: AnsiString;
    version, Subversion: byte;
begin
    if StatusBibUpdate <> 0 then exit;

    if FileExists(aFilename) then
    begin
        try
            aStream := TMemoryStream.Create;
            try
                aStream.LoadFromFile(aFilename);

                setlength(Header,length(MP3DB_HEADER));
                aStream.Read(Header[1],length(MP3DB_HEADER));
                aStream.Read(Version,sizeOf(MP3DB_VERSION));
                aStream.Read(Subversion, sizeof(MP3DB_SUBVERSION));

                if Header = 'GMP' then
                begin
                    case Version of
                        2: MessageDLG((Medialibrary_LibFileTooOld), mtError, [MBOK], 0);
                        3: MessageDLG((Medialibrary_LibFileTooOld), mtError, [MBOK], 0);
                        4: begin
                            if Subversion <= 1 then // new in Nemp 4.0: Subversion changed to 1
                                                    // (additional value in RadioStations)
                            begin
                                EnterCriticalSection(CSAccessDriveList);
                                LoadFromFile4(aStream);
                                LeaveCriticalSection(CSAccessDriveList);
                                NewFilesUpdateBib(True);
                            end else
                                MessageDLG((Medialibrary_LibFileTooYoung), mtError, [MBOK], 0);
                        end
                        else
                            MessageDLG((Medialibrary_LibFileTooYoung), mtError, [MBOK], 0);

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
                    MessageDLG((Medialibrary_InvalidLibFile), mtError, [MBOK], 0);

            finally
                FreeAndNil(aStream);
            end;
        except
            on E: Exception do MessageDLG((ErrorLoadingMediaLib) + #13#10 + E.Message, mtError, [mbOK], 0);
        end;
    end else
    begin
        // Datei nicht vorhanden - nur Webradio laden
        if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
            ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
        else
            if FileExists(SavePath + 'default.nwl') then
                ImportFavorites(SavePath + 'default.nwl');

        // We have no library, but we have to update anyway,
        // as this ensures AutoScan and/or webserver-activation
        NewFilesUpdateBib(True);

        {case BrowseMode of
            0: ReBuildBrowseLists;
            1: ReBuildCoverList;
            2: ; // Nothing to do
        end;
        SendMessage(MainWindowHandle, WM_MedienBib, MB_RefillTrees, 0);
        }
    end;
end;

{
    --------------------------------------------------------
    SaveToFile
    - Save a gmp-File
    --------------------------------------------------------
}
procedure TMedienBibliothek.SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
var  str: TFileStream;
begin
  try
      Str := TFileStream.Create(aFileName, fmCreate or fmOpenWrite);
      try
        EnterCriticalSection(CSAccessDriveList);

        str.Write(AnsiString(MP3DB_HEADER), length(MP3DB_HEADER));
        str.Write(MP3DB_VERSION,sizeOf(MP3DB_VERSION));
        str.Write(MP3DB_SUBVERSION, sizeof(MP3DB_SUBVERSION));

        SaveDrivesToStream(str);

        SaveAudioFilesToStream(str);
        SavePlaylistsToStream(str);
        SaveRadioStationsToStream(str);
      finally
        LeaveCriticalSection(CSAccessDriveList);
        FreeAndNil(str);
      end;
      Changed := False;
  except
      on e: Exception do
          if not Silent then
              MessageDLG(E.Message, mtError, [MBOK], 0)
  end;
end;


initialization

  InitializeCriticalSection(CSUpdate);
  InitializeCriticalSection(CSAccessDriveList);

finalization

  DeleteCriticalSection(CSUpdate);
  DeleteCriticalSection(CSAccessDriveList);

end.

