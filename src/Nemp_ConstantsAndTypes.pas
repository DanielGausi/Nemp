{

    Unit Nemp_ConstantsAndTypes

    - Some Constants and types used in Nemp
      e.g. Records, Messages

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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
unit Nemp_ConstantsAndTypes;

{$I xe.inc}

interface

uses Windows, Messages, Graphics, IniFiles, Forms,  Classes, Controls,
      Vcl.ExtCtrls, Generics.Collections, oneInst, SystemHelper,
     SysUtils, Contnrs, ShellApi, VirtualTrees,  Hilfsfunktionen,
     WindowsVersionInfo, System.StrUtils,
     dialogs;


const // MAXCHILDS = 10;
      // CONTROL_PANEL_HEIGHT_1 = 100;
      // CONTROL_PANEL_HEIGHT_2 = 200;
      // CONTROL_PANEL_CoverWidth = 100;
      // CONTROL_PANEL_VisualisationWidth = 140;

      //CONTROL_PANEL_MinWidth_1 = 550;
      //CONTROL_PANEL_MinWidth_2 = 309;  // check later, maybe

      MAINFORM_MinHeight = 300;
      MAINFORM_MinWidth = 400;

      // MAIN_PANEL_MinHeight = 250;
      // MAIN_PANEL_MinWidth = 250;
      // these values are for childs in a "2-rows-layout", without ControlPanel
      // Formbuilder should adjust Constraints accoding to the Layout, especially the Height
      // CHILD_PANEL_MinWidth = 250;
      // CHILD_PANEL_MinHeight = 180;

type

    TAudioFileStringIndex = (siArtist, siAlbum, siOrdner, siGenre, siJahr, siFileAge, siDateiname);

    // pa_default is used only for putting files from the playlist into the media library
    TEProgressActions = (pa_Default, pa_SearchFiles, pa_SearchFilesForPlaylist, pa_RefreshFiles,
        pa_CleanUp, {pa_Searchlyrics,} pa_SearchTags, pa_UpdateMetaData, pa_DeleteFiles, pa_ScanNewFiles,
        pa_ScanNewPlaylistFiles, pa_RefreshPlaylistFiles);

    TEDefaultCoverType = (dcFile, dcWebRadio, dcCDDA, dcNoCover_deprecated, dcError);

    TLibraryColumn = record   // formerly known as TSpalte
      Position: Integer;
      Width: Integer;
      Visible: Boolean;
      Name: String;
    end;


    TENempFormIDs = (nfMain, nfMainMini, nfPlaylist, nfMediaLibrary, nfBrowse, nfExtendedControls);

    TFormData = record
      Key: String;
      Top,
      Left,
      Width,
      Height: Integer;
      Docked,
      Visible: Boolean;
    end;
    TFormDataArray = array[TENempFormIDs] of TFormData;

  const
      cDefaultWindowData: TFormDataArray = (
        (Key: 'Main'; Top: -1; Left: -1; Width: 1200; Height: 750; Docked: False; Visible: True),
        (Key: 'MiniMain'; Top: 460; Left: 180; Width: 800; Height: 100; Docked: False; Visible: True), //height: ignored here
        (Key: 'Playlist'; Top: 50; Left: 830; Width: 400; Height: 390; Docked: False; Visible: True),
        (Key: 'MediaList'; Top: 580; Left: 50; Width: 840; Height: 330; Docked: False; Visible: True),
        (Key: 'BrowseList'; Top: 50; Left: 50; Width: 760; Height: 390; Docked: False; Visible: True),
        (Key: 'Extended'; Top: 580; Left: 910; Width: 330; Height: 330; Docked: False; Visible: True)
      );
      cWebGenericWebRadioID = 'Webradio';

  type

    TNempFormData = class
    private
        fNempForm : TENempFormIDs;
        fTop,
        fLeft,
        fWidth,
        fHeight  : Integer;
        fDocked: Boolean;
        fVisible: Boolean;

        procedure CenterForm;

      public
        property Top    : Integer read fTop     write fTop    ;
        property Left   : Integer read fLeft    write fLeft   ;
        property Width  : Integer read fWidth   write fWidth  ;
        property Height : Integer read fHeight  write fHeight ;
        property Docked : Boolean read fDocked  write fDocked ;
        property Visible: Boolean read fVisible write fVisible;

        constructor create(aNempForm: TENempFormIDs);

        function SetDataToString: String;
        procedure GetDataFromString(aString: String);
        procedure SetData(aFormData: TFormData);
    end;


    TNempRegionsDistance = record
      Left: integer;
      Right: integer;
      Top: integer;
      Bottom: integer;
      RelativPositionX: integer;
      RelativPositionY: integer;
      docked: boolean;
    end;

    TNempButtonData = record
      Name        : String;
      Visible     : Boolean;
      Left        : Integer;
      Top         : Integer;
      Width       : Integer;
      Height      : Integer;
    end;

    TEHotKeyTypes = (hkPlay, hkStop, hkNext, hkPrev, hkSlideForward, hkSlideBack, hkIncVol, hkDecVol, hkMute);
    THotKeyInfo = record
      Activate: Boolean;
      Modifier: Cardinal;
      Key: Byte;
    end;

const
    cHotKeyTypeNames: Array[TEHotKeyTypes] of String =
        ( 'Play', 'Stop', 'Next', 'Prev', 'SlideForward', 'SlideBack', 'IncVol', 'DecVol', 'Mute');
    cHotKeyDefaults: Array[TEHotKeyTypes] of THotKeyInfo =
    ( (Activate: True; Modifier: 6; Key: 80),  // 'P'
      (Activate: True; Modifier: 6; Key: 83),  // 'S'
      (Activate: True; Modifier: 6; Key: 78),  // 'N'
      (Activate: True; Modifier: 6; Key: 66),  // 'B'
      (Activate: True; Modifier: 6; Key: 77),  // 'M'
      (Activate: True; Modifier: 6; Key: 86),  // 'V'
      (Activate: True; Modifier: 6; Key: 187), // '+'
      (Activate: True; Modifier: 6; Key: 189), // '-'
      (Activate: True; Modifier: 6; Key: 48)   // '0'
    );

type
    TNempHotKey = class
      private
        fHotKeyType : TEHotKeyTypes;
        fActivate : Boolean;
        fModifier : Cardinal;
        fKey      : Byte;
        fID       : Integer;
        function SetDataToString: String;
        procedure GetDataFromString(aString: String);
        procedure SetData(aActivate: Boolean; aModifier: Cardinal; aKey: Byte);
      public
        property Activate : Boolean  read fActivate write fActivate;
        property Modifier : Cardinal read fModifier write fModifier;
        property Key      : Byte     read fKey      write fKey     ;
        property ID       : Integer  read fID;
        constructor create(HotKeyType: TEHotKeyTypes);
    end;

    THotKeyArray = Array[TEHotKeyTypes] of TNempHotKey;

    // TNempSettingsManager: A global IniFile for settings storage
    TNempSettingsManager = class(TMemIniFile)
      private
        fSavePath: String;
        fWriteAccessPossible: Boolean;

        function GetLastExitOk: Boolean;
        procedure SetLastExitOk(value: Boolean);

        procedure InitiateSavePath;
      public
        property SavePath: String read fSavePath;
        property LastExitOK: Boolean read GetLastExitOk write SetLastExitOk;
        property WriteAccessPossible: boolean read fWriteAccessPossible;

        constructor create;
        destructor Destroy; override;
        procedure WriteToDisk;
    end;


    TNempOptions = class
      private
        fHotKeys: THotKeyArray;
        fMainFormHandle: HWND;

        procedure LoadHotKeys;
        function LoadHotKeys_Deprecated: Boolean;

      public
        // etaws Kleinkram und allgemeine Optionen
        //DenyID3Edit: Boolean;
        LastKnownVersion: Integer;
        LastUpdateCleaningCheck: Integer;
        LastUpdateCleaningSuccess: Integer;
        AllowOnlyOneInstance: Boolean;
        RegisterHotKeys: Boolean;
        IgnoreVolumeUpDownKeys: Boolean;
        RegisterMediaHotkeys: Boolean;

        TabStopAtPlayerControls: Boolean;
        TabStopAtTabs: Boolean;
        VSTDetailsLock: Integer;

        UseDisplayApp: Boolean;
        DisplayApp: String;

        AutoCloseProgressWindow: Boolean;
        ShowSplashScreen: Boolean;
        MiniNempStayOnTop: Boolean;
        QuickRefreshDetails: Boolean;
        FullRowSelect: Boolean;
        TippSpeed: Integer;

        // NempWindowView: Word;
        ShowTrayIcon: Boolean;
        StartMinimized: Boolean;
        StartMinimizedByParameter: Boolean;
        // FixCoverFlowOnStart: Boolean;

        //Sprache
        Language: String;
        maxDragFileCount: Integer;

        // shutdown variables
        // used during runtime
        ShutDownMode: Integer;
        ShutDownTime: TDateTime;
        ShutDownAtEndOfPlaylist: Boolean;
        // used for the initialising the settings form
        ShutDownModeIniIdx,
        ShutDownTimeIniIdx,
        ShutDownTimeIniHours,
        ShutDownTimeIniMinutes : Integer;

        MaxDauer: Array[1..4] of Integer;
        RowHeight: Integer;
        ChangeFontColorOnBitrate:boolean;
        ChangeFontSizeOnLength:boolean;
        ChangeFontStyleOnMode:boolean;
        ChangeFontOnCbrVbr:boolean;
        FontNameVBR:TFontName;
        FontNameCBR:TFontName;
        DefaultFontSize:integer;
        ArtistAlbenFontSize: Integer;
        ArtistAlbenRowHeight: Integer;

        DefaultFontStyle: Integer;
        ArtistAlbenFontStyle: Integer;
        DefaultFontStyles: TFontStyles;
        ArtistAlbenFontStyles: TFontStyles;

        AllowQuickAccessToMetadata: Boolean;
        UseCDDB: Boolean;
        PreferCDDB: Boolean;
        AutoScanNewCDs: Boolean;
        CDDBServer: String;
        CDDBEMail: String;

        AnzeigeMode: Integer;
        UseSkin: Boolean;
        GlobalUseAdvancedSkin: Boolean;
        SkinName: UnicodeString;
        PreferredLyricSearch: Integer;

        FormPositions: array[TENempFormIDs] of TNempFormData;
        MainFormMaximized: Boolean;

        property HotKeys: THotKeyArray read fHotKeys;

        constructor create;
        destructor Destroy; override;

        procedure LoadSettings(aHandle: HWND);
        procedure SaveSettings;
        procedure SaveHotKeys;

        procedure DefineHotKey(aHotKey: TEHotKeyTypes; aActivate: Boolean; aModifier: Cardinal; aKey: Byte);
        procedure UnInstallHotKeys;
        procedure UninstallMediakeyHotkeys;
        procedure InstallHotkeys;
        procedure InstallMediakeyHotkeys(IgnoreVolume: Boolean);
    end;


const

    // Diese Daten kommen  nur in den GMPs zum Einsatz!!
    MP3DB_HEADER = 'GMP';
    // MP3DB_VERSION_OLD: Byte = 3;    // Dateiformat 2.5 - 3.0
    // MP3DB_SUBVERSION_Old: Byte = 1; // Format 3.1 seit Nemp 2.5x3, bzw. seit Nemp3.0 ;-)

    MP3DB_VERSION   : Byte = 5;    //4;  // Dateiformat seit 4.13: "5.0"
    MP3DB_SUBVERSION: Byte = 1;    //   4:13 0;    //2;
    /// File Format since 4.14: "5.1"
    /// Changes since 4.13: Filenames in Library (and npl-files) can be relative filenames
    ///                     in that case, the DriveID stored at the audiofiles is "-somewhat"
    ///                     to indicate that the Drive Letter MUST NOT be changed after loading


    //-------------
    // Zeug für die Anzeige:
    NEMP_NAME = 'Nemp'; // Bezeichnung der ini-Datei
    NEMP_CAPTION = 'Nemp - Noch ein MP3-Player';
    NEMP_NAME_TASK_LONG = '[ N e m p ]';
    NEMP_NAME_TASK = '[Nemp]';
    NEMP_VERSION_SPLASH = 'version 5.2';
    NEMP_BASS_DEFAULT_USERAGENT = 'Nemp/5.2';
    CDDB_DEFAULT_SERVER = 'gnudb.gnudb.org';
    CDDB_DEFAULT_EMAIL = 'nemp@gausi.de';
    CDDB_APPNAME = 'nemp+5.2';

    NEMP_ONLINE_HELP_DE = 'https://nemp-help.gausi.de/de/';
    NEMP_ONLINE_HELP_EN = 'https://nemp-help.gausi.de/en/';

    NEMP_TIPSIZE = 128;

    NEMP_PLAYER_COVERSIZE = 88;

    //MAX_DRAGFILECOUNT = 2500; Now: NempOptions.maxDragFileCount

    // Messages des Players
    //---------------------------------------
    // Jedes Event eine eigene Message, da diese von
    // den BASS_ChannelSetSync-Routinen benutzt werden!
    WM_Player = WM_USER + 500;
    // Player hat ein Cue zuende abgespielt
    WM_NextCue = WM_USER + 501;
    WM_COUNTDOWN_FINISH = WM_USER + 502;
    WM_BIRThDAY_FINISH = WM_USER + 503;
    // Player hat eine Datei zuende abgespielt
    WM_NextFile = WM_USER + 504;
    // Playback Angehalten
    WM_SlideComplete = WM_USER + 505;
    WM_ResetPlayerVCL = WM_USER + 506;
    WM_WebRadio = WM_USER + 507;
      wWebRadioBuffering = 2;
      wWebRadioNewMetaData = 3;
      wWebRadioNewMetaDataOgg = 4;
    // WM_NewMetaData = WM_USER + 507;

    WM_PlayerStop = WM_USER + 508;
    WM_PlayerPlay = WM_USER + 509;
    WM_PlayerAcceptInput = WM_User + 510;

    WM_ActualizePlayPauseBtn = WM_USER + 511;
    WM_PlayerStopRecord = WM_User + 512;

    // Wird von den SetEndSyncs gesendet, mit Zusatzparameter, ob am Ende neue Datei gespielt wird, oder gestoppt wird.
    WM_ChangeStopBtn = WM_USER + 513;
    WM_StopPlaylist = WM_USER + 514;
    WM_PlayerHeadSetEnd = WM_USER + 515;
    WM_PlayerSilenceDetected = WM_USER + 516;
    WM_PlayerPrescanComplete = WM_USER + 517;

    WM_PrepareNextFile = WM_USER + 518;
    WM_PlayerDelayedPlayNext = WM_USER + 519;
    WM_PlayerDelayCompleted = WM_USER + 520;
    WM_PlayerPlayAgain = WM_USER + 521;

    //---------------------------------------
    // Messages der Medienbibliothek
    //---------------------------------------
    // Irgendwer oder irgendwas fängt an, die Updateliste zu bearbeiten.
    // Weitere Starts dieser Art dürfen nicht stattfinden!
    // d.H. Drag&Drop und Hinzufügen von Ordnern und Dateien muss verhindert werden
    // Dauer: ggf. bis zu ein paar Minuten

    WM_MedienBib = WM_USER + 600;

    MB_BlockUpdateStart = 1;
    // Die Updateliste ist komplett. Es wird begonnen, die Medienbib zu aktualisieren
    // Schreibzugriff auf Einzeldateien sowie die Vorauswahl-Kriterien müssen verhindert werden
    // Dauer: ein paar Sekunden.
    MB_BlockWriteAccess = 2;
    // Vorbereitungen sind abgeschlossen. Listen sollen umgehängt werden.
    // d.h. KEINERLEI Zugriff auf die Medienliste. Trees Disablen
    // Dauer: Ein paar Millisekunden
    MB_BlockReadAccess =  3;
    // Update ist fertig. Jetzt müssen die Trees neu befüllt werden
    MB_RefillTrees = 4;
    MB_ClearBrowseTrees = 11;
    MB_ClearFilesTree = 12;
    MB_ClearEmptyNodes = 8;
    // Aufräumen ist auch erledigt. Controls wieder entsperren
    MB_Unblock =  5;
    // AnzeigeListe kontrollieren, ob gelöschte Dateien enthalten sind
    MB_CheckAnzeigeList = 6;
    // Anzeigeliste neu füllen
    MB_ReFillAnzeigeList = 7;
    MB_ImportFavoritePlaylists = 9;

    MB_LoadLastSelectionData = 10;
    // Dateigefunden
    //MB_NewFile = 8;
    //MB_ProgressSearch = 9;
    //MB_ProgressSearchFuzzy = 10;

    //MB_ProgressRefresh = 11;
    MB_ProgressRefreshJustProgressbar = 30;
    //MB_SearchAutoAbort = 12;
    // Show search results. lParam contains a Pointer to the result-list
    MB_ShowSearchResults = 13;

    MB_ShowQuickSearchResults = 25;
    MB_ShowFavorites = 26;

    // Show Quicksearch-results
    // Two Steps: Results from "QuickSearchList" and "Additional results"
    ///MB_GetQuickSearchResults = 25;
    //// MB_GetAdditionalQuickSearchResults = 26;
    ///MB_ShowQuickSearchResults  = 27;


    //MB_DeadFilesWarning = 14;
    // Warnung: Duplikate in der Bib gefunden. Das sollte eigentlich nicht mehr vorkommen
    MB_DuplicateWarning = 15;
    // Recheck Current playingfile after the bib was initially loaded (rating!)
    ///// MB_ReCheckPlaylingFile = 35;
    // AutScan der Ordner starten
    MB_StartAutoScanDirs = 16;
    // WebServer automatisch starten
    MB_ActivateWebServer = 21;
    // Suche nach toten Dateien
    MB_ProgressSearchDead = 17;
    // Lyrics, send Status complete/failed
    MB_ProgressCurrentFileOrDirUpdate = 18;
    MB_ProgressScanningNewFiles = 27;
    // same for Tags
    // MB_TagsUpdateStatus = 28;
    // Lyrics/PostProcessor: Send the filename which is currently edited by a thread
    MB_ThreadFileUpdate = 23;
    // Refresh AudioFile: GetAudiodata in VCL-Thread, as Cover-stuff will create some
    // Exceptions in secondary threads.
    MB_RefreshAudioFile = 24;

    // Exception im Thread - wahrscheinlich keine Internetverbindung.
    //MB_LyricUpdateFailed = 19;
    // Liste abgearbeitet
    MB_UpdateProcessComplete = 20;
    MB_UpdateProcessCompleteSomeErrors = 19; // for dispalying an error-image

    MB_CurrentProcessFailCount = 46;
    MB_CurrentProcessSuccessCount = 47;

    MB_StartLongerProcess = 48;
    MB_ProgressShowHint = 49;  // LParam: String to display

    // Search the playlist for a filename and set the ratings
    MB_UnifyPlaylistRating = 22;

    // Set the Win7-Taskbar-Progressbar
    MB_SetWin7TaskbarProgress = 29;
    MB_RefreshTagCloudFile = 31;

    // Set TabWarning for TagCloud after getting Tags
    MB_TagsSetFinished = 32;

    // An error occured in a Thread: Log Message
    MB_ErrorLog = 33;
    //
    MB_ErrorLogHint = 34;

    MB_UserInputDeadFiles = 36;

    // Error during loading the gmp file
    MB_InvalidGMPFile = 37;

    MB_ID3TagUpdateComplete = 38;

    MB_StartAutoDeleteFiles = 39;
    // new startup-system
    MB_CheckForStartJobs = 40;

    MB_InfoDeadFiles = 41;

    MB_OutOfMemory = 43;
          // for lParams
          OutOfMemory_DataReduced = 1;
          OutOfMemory_DataDisabled = 2;
          OutOfMemory_LyricsDisabled = 3;
          OutOfMemory_ErrorBuildingDataString = 4;
          OutOfMemory_ErrorBuildingLyricString = 5;

    MB_AddNewLogEntry = 44;
    MB_EditLastLogEntry = 45;

    MB_FixAudioFilePaths = 50;
    MB_FixPlaylistFilePaths = 51;


    MB_MessageForLog = 98;
    MB_MessageForDialog = 99;

    MB_SetStatus = 100;

    // Konstanten für den Status der Bib:
    BIB_Status_Free = 0;
    BIB_Status_UpdateStart = 1;
    BIB_Status_WriteAccessBlocked = 2;
    BIB_Status_ReadAccessBlocked = 3;
    //-----------------------------------------

    APPCOMMAND_MEDIA_NEXTTRACK      = 720896;
    APPCOMMAND_MEDIA_PREVIOUSTRACK  = 786432;
    APPCOMMAND_MEDIA_STOP           = 851968;
    APPCOMMAND_MEDIA_PLAY_PAUSE     = 917504; // = APPCOMMAND_MEDIA_PLAY_PAUSE = $e0000
    APPCOMMAND_MEDIA_PLAY           = $2e0000;
    APPCOMMAND_MEDIA_PAUSE          = $2f0000;

    APPCOMMAND_VOLUME_DOWN          = $90000;
    APPCOMMAND_VOLUME_UP            = $a0000;

    VK_VOLUME_MUTE      = $AD;
    VK_VOLUME_DOWN      = $AE;
    VK_VOLUME_UP        = $AF;
    VK_MEDIA_NEXT_TRACK = $B0;
    VK_MEDIA_PREV_TRACK = $B1;
    VK_MEDIA_STOP       = $B2;
    VK_MEDIA_PLAY_PAUSE = $B3;

    PBT_APMRESUMESUSPEND = 7;
    PBT_APMSUSPEND = 4;

    // WM_TRAYMSG = WM_USER + 10; // not needed any more (tTrayIcon)
    cLibraryColumnCount = 32; // formerly known as Spaltenzahl

    // Nicht Ändern! Das sind auch die Tags in den Menu-Einträgen zum Sortieren!!
    (*CON_ARTIST    = 0 ;
    CON_TITEL     = 1 ;
    CON_ALBUM     = 2 ;
    CON_DAUER     = 3 ;
    CON_BITRATE   = 4 ;
    CON_CBR       = 5 ;
    CON_MODE      = 6 ;
    CON_SAMPLERATE= 7 ;
    CON_STANDARDCOMMENT = 8 ;
    CON_FILESIZE  = 9 ;
    CON_PFAD      = 10;
    CON_ORDNER    = 11;
    CON_DATEINAME = 12;
           // CON_KATEGORIE = 13;
    CON_YEAR      = 13;
    CON_GENRE     = 14;
    CON_LYRICSEXISTING = 15;
    CON_TRACKNR   = 16;
        CON_CD        = 22;
    CON_RATING    = 17;
    CON_PLAYCOUNTER = 18;
    CON_LASTFMTAGS = 19;
    CON_EXTENSION = 20;
    CON_FILEAGE = 21;
    CON_FAVORITE = 23;
    CON_TRACKGAIN = 24;
    CON_ALBUMGAIN = 25;
    CON_TRACKPEAK = 26;
    CON_ALBUMPEAK = 27;
    CON_BPM = 28;
    CON_ALBUMARTIST = 29;
    CON_COMPOSER = 30;
    *)



    {NEMPWINDOW_ONLYTASKBAR = 0;
    NEMPWINDOW_TASKBAR_MIN_TRAY = 1;
    NEMPWINDOW_TRAYONLY = 2;
    NEMPWINDOW_BOTH = 3;
    NEMPWINDOW_BOTH_MIN_TRAY = 4;}

    SHUTDOWNMODE_StopNemp = 0;
    SHUTDOWNMODE_ExitNemp = 1;
    SHUTDOWNMODE_Suspend = 2;
    SHUTDOWNMODE_Hibernate = 3;
    SHUTDOWNMODE_Shutdown = 4;

    // MODE_ARTIST_TITEL = 0;
    // MODE_PATH         = 1;
    // MODE_INFO         = 2;
    // MODE_LYRICS       = 3;
    // MODE_MAX          = 4;

      // SEARCH_ARTIST = 0;
      // SEARCH_ALBUM  = 1;
      // SEARCH_COVERID = 2;

      // Anzeige der Details: AudioFile aus der Playlist oder der MedienBib?
      SD_PLAYLIST = 0;
      SD_MEDIENBIB = 1;
      SD_PLAYER = 2;

      DS_EXTERN = 0;
      DS_INTERN = 10;
      //DS_VST = 10;
      //DS_PLAYLIST = 20;

      PLAYER_INIT = 0;         // Beim Start. Ermöglicht AutoPlay beim ersten Einfügen
      PLAYER_ISPLAYING = 1;
      PLAYER_ISPAUSED = 2;
      PLAYER_ISSTOPPED_MANUALLY = 3;      // Drück auf Stop
      PLAYER_ISSTOPPED_AUTOMATICALLY = 4; // Am Ende des Stücks, wenn "gestoppt" wird

      PLAYER_STOP_NORMAL = 0;
      PLAYER_STOP_AFTERTITLE = 1;

      PLAYER_ENQUEUE_FILES = 0; // Achtung! Muss mit den Itemindexes der Radiogroup
      PLAYER_PLAY_FILES = 1;    // in der Optionen-Form übereinstimmen!
      PLAYER_PLAY_NEXT = 2;
      PLAYER_PLAY_NOW = 3;
      PLAYER_PLAY_DEFAULT = 4;

      PLAYER_SLIDEDISTANCE = 5;

      CSIDL_APPDATA = $001a;
      CSIDL_MYMUSIC = $000d;

      Equalizer_Center : Array [0..9] of integer =
              //(60, 170, 310, 600, 1000, 3000, 6000, 12000, 14000, 16000); // Original (Winamp)
              (30, 60, 120, 250, 500, 1000, 2000, 4000, 12000, 16000);  // Bass-Empfehlung
    {
    Bass erwartet als EQ-Werte Zahlen im Bereich von 15 ... -15.
    Diese max Werte machen dann ziemlich dummen Ton in den Boxen.

    Bei den Reglern habe ich einen Bereich von 0-60.
    D.h. in der ini usw. ist es sinnvoll, einen Bereich von -30..+30 zu speichern
    dieser soll nun gemappt werden auf einen Bereich -max...+max, wobei ich max "leicht veränderbar" d.h. justierbar
    haben möchte. Evtl. sogar in den Optionen einstellbar.
    }

      // Neue Werte, für die neuen Formeln (die aber wohl gleich sind ;-))
      EQ_NEW_MAX = 10;     //10            // d.h gain für die Bass wird max. auf +/- EQ_NEW_MAX gesetzt (maximal allerdings auf 15)
      EQ_NEW_FACTOR = 30 / EQ_NEW_MAX; // Eigentlich 60/2*max -> Umrechnungsfaktor für die Button-Positionen

//      ALPHA = 1; //  "Brüllfaktor" Werte > 2 liefern weniger Gebrüll
                   //  das ist der Faktor, mit dem die -30..30 aus den Ini-Dateien verechnet wird.
                   //  Sollte nur justiert werden, damit alte Inis weiter brauchbar sind
                   //  Oder gar nicht ?? oder nur die DEFAULTPRESETS???

      EQ_BandWidth = 1;

      EQ_DEFAULTPRESETS : Array[0..17] of Array[0..9] of single =
        (
        (0,0,0,0,0,0,0,0,0,0),
        (0,0,0,0,0,0,-13,-13,-13,-15),    // Classical
        (0,0,7,15,15,15,7,0,0,0),         // Club
        (15,12,6,0,0,-12,-15,-15,0,0),      // Dance
        (15,15,15,9,0,-6,-12,-15,-15,-15), // Full Bass
        (15,7,0,-12,-6,0,9,13,15,15),     // Full Bass & Treble
        (-12,-12,-12,-6,3,12,13,14,15,15),    // Full Treble
        (6,15,12,-6,-6,0,6,10,13,15),       // Laptop Speakers / Headphones
        (12,12,6,6,0,-9,-9,-9,0,0),         // Large Hall
        (-9,0,6,9,9,9,6,3,3,0),           // Live
        (15,12,8,0,0,0,0,8,12,15),        // Party
        (-6,6,9,12,7,-3,-6,-6,-6,-6),      // Pop
        (0,0,-5,-9,0,9,9,0,0,0),          // Reggae
        (9,5,-6,-12,-6,5,9,12,12,12),         // Rock
        (-6,-12,-9,-3,9,10,11,12,13,10),   // Ska
        (9,3,-9,-12,-9,9,11,12,13,14),     // Soft
        (9,9,3,-3,-9,-12,-9,-3,9,15),      // Soft Rock
        (15,12,0,-12,-12,0,12,14,14,14)       // Techno
        );
      EQ_NAMES : Array[0..17] of string =
      (  'Default',
         'Classical',
         'Club',
         'Dance',
         'Full Bass',
         'Full Bass and Treble',
         'Full Treble',
         'Laptop Speakers',
         'Large Hall',
         'Live',
         'Party',
         'Pop',
         'Reggae',
         'Rock',
         'Ska',
         'Soft',
         'Soft Rock',
         'Techno'
         );

      colIdx_Artist       = 0;
      colIdx_Title        = 1;
      colIdx_Album        = 2;
      colIdx_Track        = 3;
      colIdx_CD           = 4;
      colIdx_Year         = 5;
      colIdx_AlbumArtist  = 6;
      colIdx_Composer     = 7;
      colIdx_Duration     = 8;
      colIdx_Genre        = 9;
      colIdx_Comment      = 10;
      colIdx_Bitrate      = 11;
      colIdx_cbrvbr       = 12;
      colIdx_Channelmode  = 13;
      colIdx_Samplerate   = 14;
      colIdx_Extension    = 15;
      colIdx_Filename     = 16;
      colIdx_Directory    = 17;
      colIdx_Path         = 18;
      colIdx_Filesize     = 19;
      colIdx_Fileage      = 20;
      colIdx_Rating       = 21;
      colIdx_PlayCounter  = 22;
      colIdx_TrackGain    = 23;
      colIdx_AlbumGain    = 24;
      colIdx_TrackPeak    = 25;
      colIdx_AlbumPeak    = 26;
      colIdx_BPM          = 27;
      colIdx_Lyrics       = 28;
      colIdx_LastFMTags   = 29;
      colIdx_Marker       = 30;
      colIdx_HarmonicKey  = 31;

      //-----
      colIdx_EX_ARTISTALBUMTITEL = 117;
      colIdx_EX_ALBUMTITELARTIST = 118;
      colIdx_EX_ALBUMTRACK = 119;

      DefaultColumns: array[0..cLibraryColumnCount-1] of TLibraryColumn =
      (
        (Position: 0; Width: 120; Visible: True; Name: 'Artist'),
        (Position: 1; Width: 120; Visible: True; Name: 'Title'),
        (Position: 2; Width: 120; Visible: True; Name: 'Album'),
        (Position: 3; Width:  50; Visible: True; Name: 'Track'),
        (Position: 4; Width:  50; Visible: False; Name: 'CD'),
        (Position: 5; Width:  50; Visible: True; Name: 'Year'),
        (Position: 6; Width: 120; Visible: True; Name: 'Album-Artist'),
        (Position: 7; Width: 120; Visible: False; Name: 'Composer'),
        (Position: 8; Width:  50; Visible: True; Name: 'Duration'),
        (Position: 9; Width: 120; Visible: False; Name: 'Genre'),
        (Position:10; Width: 120; Visible: False; Name: 'Comment'),
        (Position:11; Width:  50; Visible: False; Name: 'Bitrate'),
        (Position:12; Width:  50; Visible: False; Name: 'cbr/vbr'),
        (Position:13; Width:  50; Visible: False; Name: 'Channelmode'),
        (Position:14; Width:  50; Visible: False; Name: 'Samplerate'),
        (Position:15; Width:  50; Visible: False; Name: 'Type'),
        (Position:16; Width: 120; Visible: False; Name: 'Filename'),
        (Position:17; Width: 120; Visible: False; Name: 'Directory'),
        (Position:18; Width: 120; Visible: False; Name: 'Path'),
        (Position:19; Width:  50; Visible: False; Name: 'Filesize'),
        (Position:20; Width:  50; Visible: False; Name: 'Fileage'),
        (Position:21; Width: 100; Visible: True; Name: 'Rating'),
        (Position:22; Width:  50; Visible: False; Name: 'Play counter'),
        (Position:23; Width:  50; Visible: False; Name: 'Track gain'),
        (Position:24; Width:  50; Visible: False; Name: 'Album gain'),
        (Position:25; Width:  50; Visible: False; Name: 'Track peak'),
        (Position:26; Width:  50; Visible: False; Name: 'Album peak'),
        (Position:27; Width:  50; Visible: False; Name: 'BPM'),
        (Position:28; Width:  50; Visible: False; Name: 'Lyrics'),
        (Position:29; Width:  50; Visible: False; Name: 'Tags'),
        (Position:30; Width:  50; Visible: False; Name: 'Marker'),
        (Position:31; Width:  50; Visible: False; Name: 'Harmonic key')
      );

      // für die Prozedur ActualizeEQ:
      // Je nach Modus den übergebenen Gain-Wert als Position des Buttons oder als echten Wert (z.B. aus der Ini) interpretieren
      SETFX_MODE_VCL = 0;
      SETFX_MODE_DATA = 1;

      // Nemp API
      NEMP_BUTTON_PREVTITLE     = 40044; // previous title
      NEMP_BUTTON_PLAY          = 40045; // play
      NEMP_BUTTON_PAUSE         = 40046; // pause
      NEMP_BUTTON_STOP          = 40047; // stop
      NEMP_BUTTON_NEXTTITLE     = 40048; // next title
      NEMP_VOLUMEUP    = 40058; // volume up
      NEMP_VOLUMEDOWN  = 40059; // volume down

      IPC_MODE_SAMPLERATE = 0;
      IPC_MODE_BITRATE = 1;
      IPC_MODE_CHANNELS = 2;

      cmNoStretch = 1;

      // For starting VST
      WM_STARTEDITING = WM_User + 778;

      VORBIS_RATING = 'RATING';
      VORBIS_PLAYCOUNT = 'PLAYCOUNT';
      VORBIS_CATEGORIES = 'CATEGORIES';
      VORBIS_USERCOVERID = 'NEMP_COVER_ID';

      // APE_LYRICS = 'UNSYNCEDLYRICS';
      APE_RATING = 'RATING';
      APE_PLAYCOUNT = 'PLAYCOUNT';
      APE_CATEGORIES = 'CATEGORIES';
      APE_USERCOVERID = 'NEMP_COVER_ID';

      M4A_BPM = 'BPM';
      M4A_TMPO = 'tmpo';
      M4A_HARMONIC_KEY = 'initialkey';

      REPLAYGAIN_TRACK_GAIN = 'REPLAYGAIN_TRACK_GAIN';
      REPLAYGAIN_ALBUM_GAIN = 'REPLAYGAIN_ALBUM_GAIN';
      REPLAYGAIN_TRACK_PEAK = 'REPLAYGAIN_TRACK_PEAK';
      REPLAYGAIN_ALBUM_PEAK = 'REPLAYGAIN_ALBUM_PEAK';


function GetDefaultEqualizerIndex(aEQSettingsName: String): Integer;

function NempOptions: TNempOptions;
function NempSettingsManager: TNempSettingsManager;

implementation

uses PlaylistUnit, MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, BasicSettingsWizard, Treehelper;

var fNempOptions: TNempOptions;
    fNempSettingsManager: TNempSettingsManager;


function NempSettingsManager: TNempSettingsManager;
begin
  if not assigned(fNempSettingsManager) then
    fNempSettingsManager := TNempSettingsManager.create;
  result := fNempSettingsManager;
end;

function NempOptions: TNempOptions;
begin
  if not assigned(fNempOptions) then
    fNempOptions := TNempOptions.create;
  result := fNempOptions;
end;


procedure CheckValue(var x: Integer; minValue, maxValue: Integer);
begin
    if x < minValue then
        x := minValue;
    if x > maxValue then
        x := maxValue;
end;


function GetDefaultEqualizerIndex(aEQSettingsName: String): Integer;
var i: Integer;
begin
    result := 0;
    for i := 0 to 17 do
    begin
        if SameText(EQ_NAMES[i], aEQSettingsName) then
        begin
            result := i;
            break;
        end;
    end;
end;


{ TNempOptions }

constructor TNempOptions.create;
var
  idxKey: TEHotKeyTypes;
  idxForm: TENempFormIDs;
begin
  inherited;

  for idxKey := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
    fHotKeys[idxKey] := TNempHotKey.create(idxKey);

  for idxForm := Low(TENempFormIDs) to High(TENempFormIDs) do
    FormPositions[idxForm] := TNempFormData.create(idxForm);
end;

destructor TNempOptions.Destroy;
var
  idxKey: TEHotKeyTypes;
  idxForm: TENempFormIDs;
begin
  for idxKey := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
    fHotKeys[idxKey].Free;
  for idxForm := Low(TENempFormIDs) to High(TENempFormIDs) do
    FormPositions[idxForm].Free;
  inherited;
end;


procedure TNempOptions.SaveHotKeys;
var i: TEHotKeyTypes;
begin
  // delete deprecated Hotkeys.ini (not used any longer)
  if FileExists(NempSettingsManager.SavePath + 'Hotkeys.ini') then
    DeleteFile(NempSettingsManager.SavePath + 'Hotkeys.ini');

  // remove deprecated ini entries
  NempSettingsManager.DeleteKey('Allgemein', 'RegisterHotKeys');
  NempSettingsManager.DeleteKey('Allgemein', 'RegisterMediaHotkeys');
  NempSettingsManager.DeleteKey('Allgemein', 'IgnoreVolumeUpDownKeys');
  // write new entries
  NempSettingsManager.WriteBool('Hotkeys', 'RegisterHotKeys', RegisterHotKeys);
  NempSettingsManager.WriteBool('Hotkeys', 'RegisterMediaHotkeys', RegisterMediaHotkeys);
  NempSettingsManager.WriteBool('Hotkeys', 'IgnoreVolumeUpDownKeys', IgnoreVolumeUpDownKeys);

  for i := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
    NempSettingsManager.WriteString('Hotkeys', cHotKeyTypeNames[i], fHotKeys[i].SetDataToString);
end;

procedure TNempOptions.LoadHotKeys;
var i: TEHotKeyTypes;
begin
  if NempSettingsManager.SectionExists('Hotkeys') then
  begin
    RegisterHotKeys         := NempSettingsManager.ReadBool('Hotkeys', 'RegisterHotKeys', False);
    RegisterMediaHotkeys    := NempSettingsManager.ReadBool('Hotkeys', 'RegisterMediaHotkeys', True);
    IgnoreVolumeUpDownKeys  := NempSettingsManager.ReadBool('Hotkeys', 'IgnoreVolumeUpDownKeys', True);

    for i := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
      fHotKeys[i].GetDataFromString(NempSettingsManager.ReadString('Hotkeys', cHotKeyTypeNames[i], ''));
  end else
  begin
    if not LoadHotKeys_Deprecated then
      for i := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
        fHotKeys[i].GetDataFromString(NempSettingsManager.ReadString('Hotkeys', cHotKeyTypeNames[i], ''));
  end;
end;

function TNempOptions.LoadHotKeys_Deprecated: Boolean;
var Ini: TMemIniFile;
    hMod: Cardinal;
    hKey: Byte;
    Activate: Boolean;
begin
  RegisterHotKeys         := NempSettingsManager.ReadBool('Allgemein', 'RegisterHotKeys', False);
  RegisterMediaHotkeys    := NempSettingsManager.ReadBool('Allgemein', 'RegisterMediaHotkeys', True);
  IgnoreVolumeUpDownKeys  := NempSettingsManager.ReadBool('Allgemein', 'IgnoreVolumeUpDownKeys', True);

  if not FileExists(NempSettingsManager.SavePath + 'Hotkeys.ini') then
  begin
    result := False;
    exit;
  end;

  result := True;
  ini := TMeminiFile.Create(NempSettingsManager.SavePath + 'Hotkeys.ini', TEncoding.UTF8);
  try
       Activate := Ini.ReadBool('HotKeys','InstallHotkey_Play'       , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Play' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Play', ord('P'));
       fHotKeys[hkPlay].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_Stop'       , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Stop' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Stop', ord('S'));
       fHotKeys[hkStop].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_Next'       , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Next' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Next', ord('N'));
       fHotKeys[hkNext].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_Prev'       , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Prev' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Prev', ord('B'));
       fHotKeys[hkPrev].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_JumpForward', True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpForward' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpForward', ord('M'));
       fHotKeys[hkSlideForward].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_JumpBack'   , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpBack' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpBack', ord('V'));
       fHotKeys[hkSlideBack].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_IncVol'     , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_IncVol' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_IncVol', $BB);
       fHotKeys[hkIncVol].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_DecVol'     , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_DecVol' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_DecVol', $BD);
       fHotKeys[hkDecVol].SetData(Activate, hMod, hKey);

       Activate := Ini.ReadBool('HotKeys','InstallHotkey_Mute'       , True);
       hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Mute' , 6);
       hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Mute', ord('0'));
       fHotKeys[hkMute].SetData(Activate, hMod, hKey);
  finally
    ini.Free;
  end;
end;


procedure TNempOptions.UninstallMediakeyHotkeys;
var i: Integer;
begin
    for i := 11 to 17 do
      UnRegisterHotkey(fMainFormHandle, i);
end;

procedure TNempOptions.InstallMediakeyHotkeys(IgnoreVolume: Boolean);
begin
    if not IgnoreVolume then
    begin
        RegisterHotkey(fMainFormHandle, 11, 0, VK_VOLUME_MUTE     );
        RegisterHotkey(fMainFormHandle, 12, 0, VK_VOLUME_DOWN     );
        RegisterHotkey(fMainFormHandle, 13, 0, VK_VOLUME_UP       );
    end;

    RegisterHotkey(fMainFormHandle, 14, 0, VK_MEDIA_NEXT_TRACK);
    RegisterHotkey(fMainFormHandle, 15, 0, VK_MEDIA_PREV_TRACK);
    RegisterHotkey(fMainFormHandle, 16, 0, VK_MEDIA_STOP      );
    RegisterHotkey(fMainFormHandle, 17, 0, VK_MEDIA_PLAY_PAUSE);
end;

procedure TNempOptions.DefineHotKey(aHotKey: TEHotKeyTypes; aActivate: Boolean; aModifier: Cardinal; aKey: Byte);
begin
  fHotkeys[aHotKey].Activate := aActivate;
  fHotkeys[aHotKey].Modifier := aModifier;
  fHotkeys[aHotKey].Key := aKey;
end;

procedure TNempOptions.UnInstallHotKeys;
var iKey: TEHotKeyTypes;
begin
  for iKey := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
    UnRegisterHotkey(fMainFormHandle, fHotKeys[iKey].ID);
end;

procedure TNempOptions.InstallHotkeys;
var iKey: TEHotKeyTypes;
begin
  for iKey := Low(TEHotKeyTypes) to High(TEHotKeyTypes) do
  begin
    if fHotkeys[iKey].fActivate then
      RegisterHotkey(fMainFormHandle, fHotkeys[iKey].ID, fHotkeys[iKey].Modifier, fHotkeys[iKey].Key )
  end;
end;


procedure TNempOptions.LoadSettings(aHandle: HWND);
var
  WinVersionInfo: TWindowsVersionInfo;
  defaultAdvanced: Boolean;
begin
  fMainFormHandle := aHandle;

  LastKnownVersion := NempSettingsManager.ReadInteger('Allgemein','LastKnownVersion',0 );
  LastUpdateCleaningCheck := NempSettingsManager.ReadInteger('Allgemein','LastUpdateCleaningCheck', 0);
  LastUpdateCleaningSuccess := NempSettingsManager.ReadInteger('Allgemein','LastUpdateCleaningSuccess', 0);

  ShowSplashScreen := NempSettingsManager.ReadBool('Allgemein', 'ShowSplashScreen', True);

  AutoCloseProgressWindow := NempSettingsManager.ReadBool('Allgemein', 'AutoCloseProgressWindow', True);
  StartMinimized          := NempSettingsManager.ReadBool('Allgemein', 'StartMinimized', False);
  AllowOnlyOneInstance    := NempSettingsManager.ReadBool('Allgemein', 'AllowOnlyOneInstance', True);

  TabStopAtPlayerControls := NempSettingsManager.ReadBool('Allgemein', 'TabStopAtPlayerControls', True);
  TabStopAtTabs := NempSettingsManager.ReadBool('Allgemein', 'TabStopAtTabs', True);
  VSTDetailsLock:= NempSettingsManager.ReadInteger('Allgemein', 'VSTDetailsLock', 0);

  DisplayApp    := NempSettingsManager.ReadString('Allgemein', 'DisplayApp', 'NempG15App.exe');
  DisplayApp    := Stringreplace(DisplayApp, '\', '', [rfReplaceAll]);
  UseDisplayApp := NempSettingsManager.ReadBool('Allgemein', 'UseDisplayApp', false);

  AllowQuickAccessToMetadata := NempSettingsManager.ReadBool('Allgemein', 'AllowQuickAccessToMetadata', False);

  MiniNempStayOnTop := NempSettingsManager.ReadBool('Allgemein', 'MiniNempStayOnTop', False);
  QuickRefreshDetails := NempSettingsManager.ReadBool('Allgemein', 'QuickRefreshDetails', True);

  ShutDownModeIniIdx     := NempSettingsManager.ReadInteger('Allgemein',  'ShutDownModeIniIdx'    , 4);
  ShutDownTimeIniIdx     := NempSettingsManager.ReadInteger('Allgemein',  'ShutDownTimeIniIdx'    , 3);
  ShutDownTimeIniHours   := NempSettingsManager.ReadInteger('Allgemein',  'ShutDownTimeIniHours'  , 2);
  ShutDownTimeIniMinutes := NempSettingsManager.ReadInteger('Allgemein',  'ShutDownTimeIniMinutes', 0);
  CheckValue(ShutDownModeIniIdx    , 0, 4);  // 5 different ShutDown-Modes
  CheckValue(ShutDownTimeIniIdx    , 0, 8);  // 9 different preselections for countdown-length
  CheckValue(ShutDownTimeIniHours  , 0, 24);
  CheckValue(ShutDownTimeIniMinutes, 0, 59);

  ShutDownAtEndOfPlaylist := False;
  Language := NempSettingsManager.ReadString('Allgemein', 'Language', '');
  maxDragFileCount := NempSettingsManager.ReadInteger('Allgemein', 'maxDragFileCount', 2500);
  PreferredLyricSearch := NempSettingsManager.ReadInteger('Allgemein', 'PreferredLyricSearchIdx', 0);
  if PreferredLyricSearch < 0 then
    PreferredLyricSearch := 0;

  UseCDDB := NempSettingsManager.ReadBool('Allgemein', 'UseCDDB', False);
  PreferCDDB := NempSettingsManager.ReadBool('Allgemein', 'PreferCDDB', False);
  CDDBServer := NempSettingsmanager.ReadString('Allgemein', 'CDDBServer', '');
  CDDBEMail := NempSettingsmanager.ReadString('Allgemein', 'CDDBEMail', '');
  AutoScanNewCDs := NempSettingsManager.ReadBool('Allgemein', 'AutoScanNewCDs', True);

  ShowTrayIcon            := NempSettingsManager.ReadBool('Fenster', 'ShowTrayIcon', False);
  FullRowSelect := NempSettingsManager.ReadBool('Fenster', 'FullRowSelect', True);

  ArtistAlbenFontSize  := NempSettingsManager.ReadInteger('Font','ArtistAlbenFontSize', 8);
  ArtistAlbenRowHeight := NempSettingsManager.ReadInteger('Font','ArtistAlbenRowHeight', 16);
  RowHeight            := NempSettingsManager.ReadInteger('Font', 'RowHeight', 16 );
  DefaultFontSize      := NempSettingsManager.ReadInteger('Font', 'DefaultFontSize', 8);
  DefaultFontStyle     := NempSettingsManager.ReadInteger('Font', 'DefaultFontStyle', 0);
  ArtistAlbenFontStyle := NempSettingsManager.ReadInteger('Font', 'ArtistAlbenFontStyle', 0);
  DefaultFontStyles     := FontSelectorItemIndexToStyle(DefaultFontStyle     );
  ArtistAlbenFontStyles := FontSelectorItemIndexToStyle(ArtistAlbenFontStyle );

  ChangeFontColorOnBitrate := NempSettingsManager.ReadBool('Font','ChangeFontColorOnBitrate',False);
  ChangeFontSizeOnLength   := NempSettingsManager.ReadBool('Font','ChangeFontSizeOnLength',False);

  MaxDauer[1] := NempSettingsManager.ReadInteger('Font', 'Maxdauer1',  60);
  MaxDauer[2] := NempSettingsManager.ReadInteger('Font', 'Maxdauer2', 150);
  MaxDauer[3] := NempSettingsManager.ReadInteger('Font', 'Maxdauer3', 360);
  MaxDauer[4] := NempSettingsManager.ReadInteger('Font', 'Maxdauer4', 900);

  ChangeFontStyleOnMode := NempSettingsManager.ReadBool('Font','ChangeFontStyleOnMode',False);
  ChangeFontOnCbrVbr    := NempSettingsManager.ReadBool('Font','ChangeFontOnCbrVbr',False);
  FontNameVBR := NempSettingsManager.ReadString('Font','FontNameVBR','Tahoma');
  FontNameCBR := NempSettingsManager.ReadString('Font','FontNameCBR','Courier');

  // AnzeigeModus (Das "i" in der NempFormAufteilung)
  AnzeigeMode := (NempSettingsManager.ReadInteger('Fenster', 'Anzeigemode', 0)) Mod 2; // 0 oder 1, was anderes gibts nicht mehr.

  UseSkin  := NempSettingsManager.ReadBool('Fenster', 'UseSkin', True);
  SkinName := NempSettingsManager.ReadString('Fenster','SkinName','Dark');
  // correction of old naming scheme
  if AnsiStartsText('<public> ', SkinName) then
    SkinName := StringReplace(SkinName, '<public> ', '', [rfReplaceAll]);

  {$IFDEF USESTYLES}
      WinVersionInfo := TWindowsVersionInfo.Create;
      try
          // use advanced Skin on Windows Vista and above (6), but NOT on XP and below (5)
          defaultAdvanced := WinVersionInfo.MajorVersion >= 6;
      finally
          WinVersionInfo.Free;
      end;
      GlobalUseAdvancedSkin := NempSettingsManager.ReadBool('Fenster', 'UseAdvancedSkin', defaultAdvanced);
  {$ELSE}
      GlobalUseAdvancedSkin := False;
  {$ENDIF}

  LoadHotKeys;
end;

procedure TNempOptions.SaveSettings;
begin

  NempSettingsManager.WriteBool('Allgemein', 'StartMinimized', StartMinimized);

  NempSettingsManager.WriteBool('Allgemein', 'AutoCloseProgressWindow', AutoCloseProgressWindow);
  NempSettingsManager.WriteBool('Allgemein', 'ShowSplashScreen', ShowSplashScreen);
  NempSettingsManager.WriteInteger('Allgemein','LastKnownVersion', WIZ_CURRENT_SKINVERSION);
  NempSettingsManager.WriteInteger('Allgemein','LastUpdateCleaningCheck', LastUpdateCleaningCheck);
  NempSettingsManager.WriteInteger('Allgemein','LastUpdateCleaningSuccess', LastUpdateCleaningSuccess);

  NempSettingsManager.WriteBool('Allgemein', 'AllowOnlyOneInstance', AllowOnlyOneInstance);
  NempSettingsManager.WriteBool('Allgemein', 'RegisterHotKeys', RegisterHotKeys);
  NempSettingsManager.WriteBool('Allgemein', 'RegisterMediaHotkeys', RegisterMediaHotkeys);
  NempSettingsManager.WriteBool('Allgemein', 'IgnoreVolumeUpDownKeys', IgnoreVolumeUpDownKeys);
  NempSettingsManager.WriteBool('Allgemein', 'TabStopAtPlayerControls', TabStopAtPlayerControls);
  NempSettingsManager.WriteBool('Allgemein', 'TabStopAtTabs', TabStopAtTabs);
  NempSettingsManager.WriteInteger('Allgemein', 'VSTDetailsLock', VSTDetailsLock);

  NempSettingsManager.WriteBool('Allgemein', 'UseDisplayApp', UseDisplayApp);
  // Note: The Display-App-String is written by the G15-App only

  NempSettingsManager.WriteBool('Allgemein', 'AllowQuickAccessToMetadata', AllowQuickAccessToMetadata);
  NempSettingsManager.WriteBool('Allgemein', 'MiniNempStayOnTop', MiniNempStayOnTop);
  NempSettingsManager.WriteBool('Allgemein', 'QuickRefreshDetails', QuickRefreshDetails);

  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownModeIniIdx'    , ShutDownModeIniIdx    );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniIdx'    , ShutDownTimeIniIdx    );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniHours'  , ShutDownTimeIniHours  );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniMinutes', ShutDownTimeIniMinutes);

  NempSettingsManager.WriteString('Allgemein', 'Language', Language);
  NempSettingsManager.WriteInteger('Allgemein', 'maxDragFileCount', maxDragFileCount);
  NempSettingsManager.WriteInteger('Allgemein', 'PreferredLyricSearchIdx', PreferredLyricSearch);

  NempSettingsManager.WriteBool('Allgemein', 'UseCDDB', UseCDDB);
  NempSettingsManager.WriteBool('Allgemein', 'PreferCDDB', PreferCDDB);
  NempSettingsmanager.WriteString('Allgemein', 'CDDBServer', CDDBServer);
  NempSettingsmanager.WriteString('Allgemein', 'CDDBEMail', CDDBEMail);
  NempSettingsManager.WriteBool('Allgemein', 'AutoScanNewCDs', AutoScanNewCDs);

  NempSettingsManager.WriteInteger('Fenster', 'Anzeigemode', AnzeigeMode);
  NempSettingsManager.WriteBool('Fenster', 'UseSkin', UseSkin);
  NempSettingsManager.WriteString('Fenster','SkinName', SkinName);
  NempSettingsManager.WriteBool('Fenster', 'UseAdvancedSkin', GlobalUseAdvancedSkin);
  NempSettingsManager.WriteBool('Fenster', 'ShowTrayIcon', ShowTrayIcon);
  NempSettingsManager.WriteBool('Fenster', 'FullRowSelect', FullRowSelect);

  NempSettingsManager.WriteInteger('Font','ArtistAlbenFontSize',ArtistAlbenFontSize);
  NempSettingsManager.WriteInteger('Font','ArtistAlbenRowHeight',ArtistAlbenRowHeight);
  NempSettingsManager.WriteInteger('Font', 'RowHeight', RowHeight  );
  NempSettingsManager.WriteInteger('Font','DefaultFontSize',DefaultFontSize);
  NempSettingsManager.WriteInteger('Font', 'DefaultFontStyle', DefaultFontStyle);
  NempSettingsManager.WriteInteger('Font', 'ArtistAlbenFontStyle', ArtistAlbenFontStyle);

  NempSettingsManager.Writebool('Font','ChangeFontSizeOnLength',ChangeFontSizeOnLength);
  NempSettingsManager.Writebool('Font','ChangeFontColorOnBitrate',ChangeFontColorOnBitrate);
  NempSettingsManager.WriteInteger('Font', 'Maxdauer1', MaxDauer[1]);
  NempSettingsManager.WriteInteger('Font', 'Maxdauer2', MaxDauer[2]);
  NempSettingsManager.WriteInteger('Font', 'Maxdauer3', MaxDauer[3]);
  NempSettingsManager.WriteInteger('Font', 'Maxdauer4', MaxDauer[4]);

  NempSettingsManager.Writebool('Font','ChangeFontStyleOnMode',ChangeFontStyleOnMode);
  NempSettingsManager.Writebool('Font','ChangeFontOnCbrVbr',ChangeFontOnCbrVbr);
  NempSettingsManager.WriteString('Font','FontNameVBR',FontNameVBR);
  NempSettingsManager.WriteString('Font','FontNameCBR',FontNameCBR);

  SaveHotKeys;

end;

{ TNempHotKey }

constructor TNempHotKey.create(HotKeyType: TEHotKeyTypes);
begin
  fHotKeyType := HotKeyType;
  fID := Integer(HotKeyType) + 1;
end;

procedure TNempHotKey.GetDataFromString(aString: String);
var
  HotKeyData: TStringList;
begin
  HotKeyData := TStringList.Create;
  try
    Explode(';', aString, HotKeyData);
    if HotKeyData.Count = 3 then
    begin
      fActivate := HotKeyData[0] = '1';
      fModifier := StrToIntDef(HotKeyData[1], cHotKeyDefaults[fHotKeyType].Modifier );
      fKey      := StrToIntDef(HotKeyData[2], cHotKeyDefaults[fHotKeyType].Key      );
    end else
    begin
      fActivate := cHotKeyDefaults[fHotKeyType].Activate;
      fModifier := cHotKeyDefaults[fHotKeyType].Modifier;
      fKey      := cHotKeyDefaults[fHotKeyType].Key     ;
    end;
  finally
    HotKeyData.Free;
  end;
end;

procedure TNempHotKey.SetData(aActivate: Boolean; aModifier: Cardinal; aKey: Byte);
begin
  fActivate := aActivate;
  fModifier := aModifier;
  fKey := aKey;
end;

function TNempHotKey.SetDataToString: String;
begin
  if fActivate then
    result := '1' + ';' + IntToStr(fModifier) + ';' + IntToStr(fKey)
  else
    result := '0' + ';' + IntToStr(fModifier) + ';' + IntToStr(fKey);
end;


{ TNempSettingsManager }

constructor TNempSettingsManager.create;
begin
  InitiateSavePath;
  fWriteAccessPossible := True;
  inherited create(fSavePath + 'Nemp.ini', TEncoding.UTF8);
end;

destructor TNempSettingsManager.Destroy;
begin

  inherited;
end;

function TNempSettingsManager.GetLastExitOk: Boolean;
begin
  result := ReadBool('Allgemein', 'LastExitOK', True);
end;

procedure TNempSettingsManager.SetLastExitOk(value: Boolean);
begin
  WriteBool('Allgemein', 'LastExitOK', value);
end;

procedure TNempSettingsManager.InitiateSavePath;
begin
  if UseUserAppData then
  begin
    // User DOES NOT want a portable storage of data - use the user directory
    fSavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
    try
      ForceDirectories(fSavePath);
    except
      fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
    end;
  end else
  begin
    // User DOES want a portable/locale storage of configuration and data - use program directory
    fSavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
  end;
end;

procedure TNempSettingsManager.WriteToDisk;
begin
  try
    UpdateFile;
    fWriteAccessPossible := True;
  except
    // Silent Exception
    fWriteAccessPossible := False;
  end;
end;


{ TNempFormData }

constructor TNempFormData.create(aNempForm: TENempFormIDs);
begin
  fNempForm := aNempForm;
end;

procedure TNempFormData.CenterForm;
begin
  fTop := (Screen.PrimaryMonitor.Height - fHeight) Div 2;
  if fTop < 0 then begin
    fTop := 50;
    fHeight := Screen.PrimaryMonitor.Height - 50;
  end;

  fLeft := (Screen.PrimaryMonitor.Width - fWidth) Div 2;
  if fLeft < 0 then begin
    fLeft := 50;
    fWidth := Screen.PrimaryMonitor.Width - 50;
  end;

end;

procedure TNempFormData.GetDataFromString(aString: String);
var
  WindowDataStrings: TStringList;
begin
  WindowDataStrings := TStringList.Create;
  try
    Explode(';', aString, WindowDataStrings);
    if WindowDataStrings.Count = 6 then
    begin
      fTop     := StrToIntDef(WindowDataStrings[0], cDefaultWindowData[fNempForm].Top);
      fLeft    := StrToIntDef(WindowDataStrings[1], cDefaultWindowData[fNempForm].Left);
      fWidth   := StrToIntDef(WindowDataStrings[2], cDefaultWindowData[fNempForm].Width);
      fHeight  := StrToIntDef(WindowDataStrings[3], cDefaultWindowData[fNempForm].Height);
      fDocked  := WindowDataStrings[4] = '1';
      fVisible := WindowDataStrings[5] = '1';
    end else
    begin
      fTop     := cDefaultWindowData[fNempForm].Top;
      fLeft    := cDefaultWindowData[fNempForm].Left;
      fWidth   := cDefaultWindowData[fNempForm].Width;
      fHeight  := cDefaultWindowData[fNempForm].Height;
      fDocked  := cDefaultWindowData[fNempForm].Docked;
      fVisible := cDefaultWindowData[fNempForm].Visible;
    end;

    if (fTop = -1) and (fLeft = -1) then
      CenterForm;

  finally
    WindowDataStrings.Free;
  end;
end;

procedure TNempFormData.SetData(aFormData: TFormData);
begin
  fTop     := aFormData.Top      ;
  fLeft    := aFormData.Left     ;
  fWidth   := aFormData.Width    ;
  fHeight  := aFormData.Height   ;
  fDocked  := aFormData.Docked   ;
  fVisible := aFormData.Visible  ;
end;

function TNempFormData.SetDataToString: String;
  function BoolToStr(b: Boolean): String;
  begin
    if b then
      result := '1'
    else
      result := '0';
  end;
begin
  result := IntToStr(fTop   ) + ';' +
            IntToStr(fLeft  ) + ';' +
            IntToStr(fWidth ) + ';' +
            IntToStr(fHeight) + ';' +
            BoolToStr(fDocked) +';' +
            BoolToStr(fVisible)
end;

initialization
  fNempOptions := Nil;
  fNempSettingsManager := Nil;

finalization
  if assigned(fNempOptions) then
    fNempOptions.Free;

  if assigned(fNempSettingsManager) then
    fNempSettingsManager.Free;

end.


