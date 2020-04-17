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

interface

uses Windows, Messages, Graphics, IniFiles, Forms,  Classes, Controls,
      Vcl.ExtCtrls, Generics.Collections,
     SysUtils, Contnrs, ShellApi, VirtualTrees,  Hilfsfunktionen,

     dialogs;


const MAXCHILDS = 10;
      CONTROL_PANEL_HEIGHT_1 = 100;
      CONTROL_PANEL_HEIGHT_2 = 200;
      CONTROL_PANEL_CoverWidth = 100;
      CONTROL_PANEL_VisualisationWidth = 140;

      CONTROL_PANEL_MinWidth_1 = 550;
      CONTROL_PANEL_MinWidth_2 = 309;  // check later, maybe


      MAIN_PANEL_MinHeight = 250;
      MAIN_PANEL_MinWidth = 250;
      // these values are for childs in a "2-rows-layout", without ControlPanel
      // Formbuilder should adjust Constraints accoding to the Layout, especially the Height
      CHILD_PANEL_MinWidth = 250;
      CHILD_PANEL_MinHeight = 180;

type

    TAudioFileStringIndex = (siArtist, siAlbum, siOrdner, siGenre, siJahr, siFileAge, siDateiname);

    // pa_default is used only for putting files from the playlist into the media library
    TProgressActions = (pa_Default, pa_SearchFiles, pa_SearchFilesForPlaylist, pa_RefreshFiles, pa_CleanUp, pa_Searchlyrics, pa_SearchTags, pa_UpdateMetaData, pa_DeleteFiles, pa_ScanNewFiles);

    TDefaultCoverType = (dcFile, dcWebRadio, dcCDDA, dcNoCover_deprecated, dcError);

    TNempSortArray = Array[1..2] of TAudioFileStringIndex;

    TSpalte = record
      Bezeichnung: string;
      Inhalt: integer;
      visible: boolean;
      width: integer;
      sortAscending: boolean;
    end;


    TNempWindowSizeAndPositions = record
        // MiniForms visible
        PlaylistVisible,
        MedienlisteVisible,
        AuswahlSucheVisible,
        ErweiterteControlsVisible: Boolean;

        // MiniForms docked
        PlaylistDocked,
        MedienlisteDocked,
        AuswahlListeDocked,
        ExtendedControlsDocked: Boolean;

        MainFormMaximized: Boolean;

        MainFormTop,      // position/size of the Mainform (compact mode)
        MainFormLeft,
        MainFormHeight,
        MainFormWidth: Integer;

        MiniMainFormTop,  // position/size of the Mainform (multi window mode)
        MiniMainFormLeft,
        MiniMainFormHeight,
        MiniMainFormWidth: Integer;

        PlaylistTop,
        PlaylistLeft,
        PlaylistHeight,
        PlaylistWidth: Integer;

        MedienlisteTop,
        MedienlisteLeft,
        MedienlisteHeight,
        MedienlisteWidth: Integer;

        AuswahlSucheTop,
        AuswahlSucheLeft,
        AuswahlSucheHeight,
        AuswahlSucheWidth: Integer;

        ExtendedControlsTop,
        ExtendedControlsLeft,
        ExtendedControlsHeight,
        ExtendedControlsWidth: Integer;
    end;


    TMainLayout = (Layout_TwoRows, Layout_TwoColumns, Layout_Undef);

    TControlPanelPosition = (
        cp_FormTop, cp_FormCenter, cp_FormBottom, // on top or bottom of the MainForm, or between the two MainPanels (Layout 2Rows only)
        // cp_ChildA, cp_ChildB, //no. The ControlPanel on the same level as the 4 other Panels doesn't make sense
                                 // in mode "2Rows" it would require a fixed height of the other element in the row
        cp_subPanel // as a subPanel inside of one of the "blocks"
                    // additional parameters needed: (a) which block and (b) where (alTop or alBottom)
    );

    TControlPanelSubPosition = (cp_SubTop, cp_SubBottom);

    TNempBlockPanel = class
        private
            fBlock  : TPanel;  // the Main Panel of one "block", these are also in the "ChildLists" below
            fHeader : TPanel;  // the small header Panel inside the Block
            fContent: TPanel; // the actual content-panel of the Block
            fName   : String; // for a nicer display in a combobox or something

            fRatio  : Integer;

            // some temporary variables for loading from the inifile
            fSortIndex: Integer;
            fParentIndex: Integer;

            function fGetHeight : Integer     ;
            function fGetWidth  : Integer     ;
            function fGetLeft   : Integer     ;
            function fGetTop    : Integer     ;
            function fGetParent : TWinControl ;
            function fGetAlign  : TAlign      ;

            procedure fSetHeight(Value: Integer      );
            procedure fSetWidth (Value: Integer      );
            procedure fSetLeft  (Value: Integer      );
            procedure fSetTop   (Value: Integer      );
            procedure fSetParent(Value: TWinControl  );
            procedure fSetAlign (Value: TAlign       );

        public
            property Block   : TPanel read fBlock  ;
            property Header  : TPanel read fHeader ;
            property Content : TPanel read fContent;
            property Name    : String read fName   ;

            property Height  : Integer      read fGetHeight  write fSetHeight ;
            property Width   : Integer      read fGetWidth   write fSetWidth  ;
            property Left    : Integer      read fGetLeft    write fSetLeft   ;
            property Top     : Integer      read fGetTop     write fSetTop    ;
            property Parent  : TWinControl  read fGetParent  write fSetParent ;
            property Align   : TAlign       read fGetAlign   write fSetAlign  ;

            property Ratio : Integer read fRatio;
            constructor create;
            procedure SetValues(aBlock, aHeader, aContent: TPanel; aName: String);
    end;

    TPanelList = class(TObjectList<TNempBlockPanel>);

    TControlPanel = class(TNempBlockPanel)
        private
            function fIsReal: Boolean;
        public
            Container1,
            Container2,
            Select,
            Cover,
            Player,
            Headset,
            Progress : TPanel;

            Name: String;

            // real: The "real" ControlPanel with all the subPanels,
            // and not the pure ControlPanel on the Test-Form
            property IsReal: Boolean read fIsReal;

            constructor create;
            procedure SetControlValues( aBlock, aContainer1, aContainer2,
                                 aSelect, aCover, aPlayer, aHeadset, aProgress{, aVisualisation}: TPanel;
                                 aName: String);
    end;

    TNempFormBuildOptions = class
        private
            fMainLayout: TMainLayout;

            fRebuildingRightNow: Boolean;

            function fGetAnUnusedSplitter: TSplitter;
            procedure fMakeSplittersAvailable(aTag: Integer);

            procedure fSetBlockSizes(aMainContainer: TPanel; aChildList: TPanelList);
            procedure fSetMainContainerSizes;

            procedure fTopToSortIndex;
            procedure fLeftToSortIndex;
            // sort the Childs by Top or Left.
            // called by RefreshBothRowsOrColumns;
            procedure fSortaChildList(aPanelList: TPanelList);
            procedure fSortChilds;

            function fGetIsReal: Boolean;

            procedure fApplyRatio(aMainContainer: TPanel; aChildList: TPanelList);

            procedure SetProperConstraints;

        public

            // settings for the ControlPanel
            ControlPanelPosition    : TControlPanelPosition;    // top, center, bottom, SubPanel
            ControlPanelSubPosition : TControlPanelSubPosition; // top or bottom within the subpanel
            ControlPanelSubParent   : TNempBlockPanel;          // parentPanel if ControlPanelPosition=SubPanel
            ControlPanelTwoRows          : Boolean;
            ControlPanelShowCover        : Boolean;
            // Show/Hide the "File Overview"-Panel
            HideFileOverviewPanel: Boolean;

            MegaContainer: TWinControl; // another Panel in the Testform, in real Nemp the Form directly
            SuperContainer: TPanel;     // contains Container A+B (and maybe the ControlPanel)
            MainContainerA: TPanel;     // topPanel
            MainContainerB: TPanel;     // bottomPanel

            BlockBrowse      : TNempBlockPanel;  // Create these in Constructor, fill them later with method "SetValues"
            BlockPlaylist    : TNempBlockPanel;  //  -- " --
            BlockMediaList   : TNempBlockPanel;  //  -- " --
            BlockFileOverview: TNempBlockPanel;  //  -- " --

            ControlPanel: TControlPanel;

            // The Splitter betwenn the 2 main panels
            MainSplitter: TSplitter;
            // 2 Lists with Sub-Panels on the two main panels
            PanelAChilds: TPanelList;
            PanelBChilds: TPanelList;
            // 2 splitters for the subpanels
            SubSplitter1: TSplitter;
            SubSplitter2: TSplitter;

            ChildPanelMinWidth: Integer;
            ChildPanelMinHeight: Integer;
            NewLayout: TMainLayout;

            WindowSizeAndPositions: TNempWindowSizeAndPositions;

            BrowseArtistRatio     ,
            FileOverviewCoverRatio,
            TopPanelRatio          : Integer;
            // new ratios (2019, Formbuilder)
            // (still Integer-Values: 0..100%)

            // some fixed values, by design
            // not the same for MainForm and TestForm
            MainPanelMinHeight,
            MainPanelMinWidth: Integer;

            property MainLayout: TMainLayout read fMainLayout;
            property RebuildingRightNow: Boolean read fRebuildingRightNow;

            property Isreal: Boolean read fGetIsReal;

            constructor Create;
            destructor Destroy; override;

            procedure LoadFromIni(aIni: TMemIniFile);
            procedure SaveToIni(aIni: TMemIniFile);

            procedure BeginUpdate;
            procedure EndUpdate;

            procedure SwapMainLayout;
            procedure RefreshControlPanel;
            procedure Assign(aNempFormBuildOptions: TNempFormBuildOptions);
            procedure ResetToDefault;

            procedure NilConstraints;

            function EmptyPanel(aChildList: TPanelList): Boolean;

            // MakeOneSplitterAvailable: Used by the Testform when we move one Block to another ContainerPanel
            // The "available" Splitter will then be used on the new ContainerPanel by RefreshBothRowsOrColumns
            procedure MakeOneSplitterAvailable(aTag: Integer);

            // GetBlockByPanel: used by the up/down/left/right-Buttons on the TestForm to move the Blocks
            function GetBlockByPanel(aPanel: TPanel): TNempBlockPanel;

            // refresh both rows or columns
            // called after a ChildPanel has been moved from one to another
            procedure RefreshBothRowsOrColumns(DoSort: Boolean);

            // get a scaling factor after a Child has beed added from the other MainPanel
            // Called by RefreshBothRowsOrColumns
            function GetRescaleFactorRow(aMainPanel: TPanel): Double;
            function GetRescaleFactorColumn(aMainPanel: TPanel): Double;

            // refresh one Column or Row
            // called after a ChildPanel has been moved inside the same MainPanel
            procedure RefreshAColumn(aMainPanel: TPanel; scaleFactor: Double = 1);
            procedure RefreshARow(aMainPanel: TPanel; scaleFactor: Double = 1);

            // if one of the Main container is resized:
            // resize the childs according to the ratios
            procedure OnMainContainerResize(Sender: TObject);
            // if one of the 2 splitters on the mainPanels has been moved
            procedure OnSplitterMoved(Sender: TObject);
            // the MainSplitter between the two ontainerPanels has been moved
            procedure OnMainSplitterMoved(Sender: TObject);
            procedure OnSuperContainerResize(Sender: TObject);

            procedure ResizeSubPanel(ABlockPanel: TPanel; aSubPanel: TWinControl; aRatio: Integer);

            // on initializing the form, (?or after setting a new layuot?)
            procedure ApplyRatios;
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



    TNempOptions = record
        // etaws Kleinkram und allgemeine Optionen
        //DenyID3Edit: Boolean;
        LastKnownVersion: Integer;
        AllowOnlyOneInstance: Boolean;
        RegisterHotKeys: Boolean;
        IgnoreVolumeUpDownKeys: Boolean;
        RegisterMediaHotkeys: Boolean;

        TabStopAtPlayerControls: Boolean;
        TabStopAtTabs: Boolean;

        UseDisplayApp: Boolean;
        DisplayApp: String;

        AutoCloseProgressWindow: Boolean;
        ShowSplashScreen: Boolean;
        MiniNempStayOnTop: Boolean;
        FullRowSelect: Boolean;
        // EditOnClick: Boolean;
        TippSpeed: Integer;

        NempWindowView: Word;
        StartMinimized: Boolean;
        StartMinimizedByParameter: Boolean;
        FixCoverFlowOnStart: Boolean;

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


        // Optionen für die Darstellung der Playliste/Medienliste
        // MinFontColor: TColor;          // not editable in Nemp 4.0 any longer
        // MaxFontColor: TColor;
        // MiddleFontColor: TColor;
        // MiddleToMinComputing: Byte;
        // MiddleToMaxComputing: Byte;
        MaxDauer: Array[1..4] of Integer;
        /// FontSize: Array[1..5] of Integer;
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

        ReplaceNAArtistBy  : Integer;
        ReplaceNATitleBy   : Integer;
        ReplaceNAAlbumBy   : Integer;

        WriteAccessPossible: Boolean;
        AllowQuickAccessToMetadata: Boolean;
        UseCDDB: Boolean;

        // Steuerung des Deskbands:
        //Folgende Nachrichten werden registriert und an ein Deskband gesendet:
        //NEMP_DESKBAND_ACTIVATE:   array [0..MAX_PATH] of Char = 'NEMP - Deskband Activate'#0;
        //NEMP_DESKBAND_DEACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Deactivate'#0;
        // Ein Deskband wird so gesucht und gefunden:
        //       wnd :=  FindWindow('Shell_TrayWnd', nil);
        //       wnd :=  FindWindowEx(wnd, 0, 'ReBarWindow32', nil);
        //       wnd :=  FindWindowEx(wnd, 0, 'TNempDeskBand', Nil);
        ShowDeskbandOnMinimize: Boolean;
        ShowDeskbandOnStart   : Boolean;
        HideDeskbandOnRestore : Boolean;
        HideDeskbandOnClose   : Boolean;

        // "Die letzten 10" => moved to TPlaylistManager
        //RecentPlaylists: Array[1..10] of UnicodeString;

        // Hotkey-Details
        InstallHotkey_Play        : Boolean;
        InstallHotkey_Stop        : Boolean;
        InstallHotkey_Next        : Boolean;
        InstallHotkey_Prev        : Boolean;
        InstallHotkey_JumpForward : Boolean;
        InstallHotkey_JumpBack    : Boolean;
        InstallHotkey_IncVol      : Boolean;
        InstallHotkey_DecVol      : Boolean;
        InstallHotkey_Mute        : Boolean;

        HotkeyMod_Play        : Cardinal;
        HotkeyMod_Stop        : Cardinal;
        HotkeyMod_Next        : Cardinal;
        HotkeyMod_Prev        : Cardinal;
        HotkeyMod_JumpForward : Cardinal;
        HotkeyMod_JumpBack    : Cardinal;
        HotkeyMod_IncVol      : Cardinal;
        HotkeyMod_DecVol      : Cardinal;
        HotkeyMod_Mute        : Cardinal;

        HotkeyKey_Play        : Byte;
        HotkeyKey_Stop        : Byte;
        HotkeyKey_Next        : Byte;
        HotkeyKey_Prev        : Byte;
        HotkeyKey_JumpForward : Byte;
        HotkeyKey_JumpBack    : Byte;
        HotkeyKey_IncVol      : Byte;
        HotkeyKey_DecVol      : Byte;
        HotkeyKey_Mute        : Byte;
    end;


    TNempForm = class(TForm)
    public
      NempRegionsDistance: TNempRegionsDistance;
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
    NEMP_VERSION_SPLASH = 'version 4.13';// 'v3.3';
    NEMP_BASS_DEFAULT_USERAGENT = 'Nemp/4.13';

    NEMP_TIPSIZE = 128;

    NEMP_PLAYER_COVERSIZE = 88;

    BROWSE_PLAYLISTS =     '!!{A8F4183D-C8FE-4585-A6C6-36FCC402143D}';
    BROWSE_RADIOSTATIONS = '!!{B3723948-3015-4E60-8727-4AC7663CE7A5}';
    BROWSE_ALL =           '!!{F7B03349-5B91-4025-B439-EAF46875717B}';


    //MAX_DRAGFILECOUNT = 2500; Now: NempOptions.maxDragFileCount
    MIN_CUESHEET_DURATION = 600; // no automatic scanning for cue sheets for short tracks

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
    WM_NewMetaData = WM_USER + 507;
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
    // Aufräumen ist auch erledigt. Controls wieder entsperren
    MB_Unblock =  5;
    // AnzeigeListe kontrollieren, ob gelöschte Dateien enthalten sind
    MB_CheckAnzeigeList = 6;
    // Anzeigeliste neu füllen
    MB_ReFillAnzeigeList = 7;

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
    MB_TagsSetTabWarning = 32;

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

    Spaltenzahl = 28;
    // Nicht Ändern! Das sind auch die Tags in den Menu-Einträgen zum Sortieren!!
    CON_ARTIST    = 0 ;
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

    //-----
    CON_EX_ARTISTALBUMTITEL = 117;
    CON_EX_ALBUMTITELARTIST = 118;
    CON_EX_ALBUMTRACK = 119;

    NEMPWINDOW_ONLYTASKBAR = 0;
    NEMPWINDOW_TASKBAR_MIN_TRAY = 1;
    NEMPWINDOW_TRAYONLY = 2;
    NEMPWINDOW_BOTH = 3;
    NEMPWINDOW_BOTH_MIN_TRAY = 4;

    SHUTDOWNMODE_StopNemp = 0;
    SHUTDOWNMODE_ExitNemp = 1;
    SHUTDOWNMODE_Suspend = 2;
    SHUTDOWNMODE_Hibernate = 3;
    SHUTDOWNMODE_Shutdown = 4;

    MODE_ARTIST_TITEL = 0;
    MODE_PATH         = 1;
    MODE_INFO         = 2;
    MODE_LYRICS       = 3;
    MODE_MAX          = 4;

      SEARCH_ARTIST = 0;
      SEARCH_ALBUM  = 1;
      SEARCH_COVERID = 2;

      // Anzeige der Details: AudioFile aus der Playlist oder der MedienBib?
      SD_PLAYLIST = 0;
      SD_MEDIENBIB = 1;

      DS_EXTERN = 0;
      DS_VST = 10;
      DS_PLAYLIST = 20;

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

      DefaultSpalten : array[0..27] of TSpalte =
      (
        (Bezeichnung: 'Artist' ;Inhalt: CON_ARTIST        ;visible: True  ;width: 122 ;sortAscending: True),
        (Bezeichnung: 'Title' ;Inhalt: CON_TITEL          ;visible: True  ;width: 190 ;sortAscending: True),
        (Bezeichnung: 'Album' ;Inhalt: CON_ALBUM          ;visible: True  ;width: 130 ;sortAscending: True),
        (Bezeichnung: 'Duration' ;Inhalt: CON_DAUER       ;visible: True  ;width: 44  ;sortAscending: True),
        (Bezeichnung: 'Bitrate' ;Inhalt: CON_BITRATE      ;visible: False  ;width: 44  ;sortAscending: True),
        (Bezeichnung: 'cbr/vbr' ;Inhalt: CON_CBR          ;visible: False  ;width: 51  ;sortAscending: True),
        (Bezeichnung: 'Channelmode' ;Inhalt: CON_MODE     ;visible: False  ;width: 53  ;sortAscending: True),
        (Bezeichnung: 'Samplerate' ;Inhalt: CON_SAMPLERATE ;visible: False  ;width: 40  ;sortAscending: True),
        (Bezeichnung: 'Comment' ;Inhalt: CON_STANDARDCOMMENT;visible: False ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Filesize' ;Inhalt: CON_FILESIZE    ;visible: False ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Path' ;Inhalt: CON_PFAD            ;visible: False ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Directory' ;Inhalt: CON_ORDNER     ;visible: False ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Filename' ;Inhalt: CON_DATEINAME   ;visible: False ;width: 50  ;sortAscending: True),
        //        (Bezeichnung: 'Kategorie'  ;Inhalt: CON_KATEGORIE  ;visible: False ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Year' ;Inhalt: CON_YEAR             ;visible: True  ;width: 50  ;sortAscending: True),
        (Bezeichnung: 'Genre' ;Inhalt: CON_GENRE           ;visible: True  ;width: 100 ;sortAscending: True),
        (Bezeichnung: 'Lyrics' ;Inhalt: CON_LYRICSEXISTING ;visible: False  ;width: 50 ;sortAscending: True),
        (Bezeichnung: 'Track' ;Inhalt: CON_TRACKNR         ;visible: false  ;width: 50 ;sortAscending: True),
        (Bezeichnung: 'Rating' ;Inhalt: CON_RATING         ;visible: true  ;width: 100 ;sortAscending: True),
        (Bezeichnung: 'Play counter' ;Inhalt: CON_PLAYCOUNTER;visible: false  ;width: 44;sortAscending: True),
        (Bezeichnung: 'Tags' ;Inhalt: CON_LASTFMTAGS       ;visible: false  ;width: 44;sortAscending: True),
        (Bezeichnung: 'Type' ;Inhalt: CON_EXTENSION        ;visible: false  ;width: 50;sortAscending: True),
        (Bezeichnung: 'Fileage' ;Inhalt: CON_FILEAGE       ;visible: false  ;width: 80;sortAscending: True),
        (Bezeichnung: 'CD' ;Inhalt: CON_CD                 ;visible: false  ;width: 50 ;sortAscending: True),
        (Bezeichnung: 'Marker' ;Inhalt: CON_FAVORITE       ;visible: true   ;width: 44 ;sortAscending: True),
        // new in Nemp 4.13
        (Bezeichnung: 'Track gain' ;Inhalt: CON_TRACKGAIN       ;visible: false   ;width: 70 ;sortAscending: True),
        (Bezeichnung: 'Album gain' ;Inhalt: CON_ALBUMGAIN       ;visible: false   ;width: 70 ;sortAscending: True),
        (Bezeichnung: 'Track peak' ;Inhalt: CON_TRACKPEAK       ;visible: false   ;width: 70 ;sortAscending: True),
        (Bezeichnung: 'Album peak' ;Inhalt: CON_ALBUMPEAK       ;visible: false   ;width: 70 ;sortAscending: True)
      );

      AUDIOFILE_STRINGS : Array[0..4] of string =
        ('artist', 'album', 'directory', 'genre', 'year');

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
      // Note: These 3 Flags has been used in Nemp3
      // They are still used in the Code, but has no effect after all
      //cmUseBibDefaults = 2;
      //cmUseDefaultCover = 4;
      //cmCustomizeMainCover= 8;

      // For starting VST
      WM_STARTEDITING = WM_User + 778;

      //NEMP_DESKBAND_ACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Activate'#0;
      //NEMP_DESKBAND_DEACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Deactivate'#0;
      //NEMP_DESKBAND_UPDATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Update'#0;

      VORBIS_COMMENT = 'COMMENT';
      VORBIS_LYRICS = 'UNSYNCEDLYRICS';
      VORBIS_RATING = 'RATING';
      VORBIS_PLAYCOUNT = 'PLAYCOUNT';
      VORBIS_CATEGORIES = 'CATEGORIES';
      VORBIS_DISCNUMBER = 'DISCNUMBER';

      VORBIS_USERCOVERID = 'NEMP_COVER_ID';
      //VORBIS_FAVORITE = 'FAVORITE';

      APE_COMMENT = 'COMMENT';
      APE_LYRICS = 'UNSYNCEDLYRICS';
      APE_RATING = 'RATING';
      APE_PLAYCOUNT = 'PLAYCOUNT';
      APE_CATEGORIES = 'CATEGORIES';
      APE_DISCNUMBER = 'DISCNUMBER';
      APE_USERCOVERID = 'NEMP_COVER_ID';
      //APE_FAVORITE = 'FAVORITE';

      REPLAYGAIN_TRACK_GAIN = 'REPLAYGAIN_TRACK_GAIN';
      REPLAYGAIN_ALBUM_GAIN = 'REPLAYGAIN_ALBUM_GAIN';

      REPLAYGAIN_TRACK_PEAK = 'REPLAYGAIN_TRACK_PEAK';
      REPLAYGAIN_ALBUM_PEAK = 'REPLAYGAIN_ALBUM_PEAK';


procedure SaveWindowPositons(ini: TMemIniFile; var FormBuildOptions: TNempFormBuildOptions; aMode: Integer);
procedure ReadNempOptions(ini: TMemIniFile; var Options: TNempOptions; var FormBuildOptions: TNempFormBuildOptions);
procedure WriteNempOptions(ini: TMemIniFile; var Options: TNempOptions; var FormBuildOptions: TNempFormBuildOptions; aMode: Integer);

procedure UnInstallHotKeys(Handle: HWND);
procedure UninstallMediakeyHotkeys(Handle: HWND);

procedure InstallHotkeys(aIniPath: UnicodeString; Handle: HWND);
procedure InstallMediakeyHotkeys(IgnoreVolume: Boolean; Handle: HWND);


function GetDefaultEqualizerIndex(aEQSettingsName: String): Integer;


implementation

uses PlaylistUnit, MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, BasicSettingsWizard, Treehelper;


procedure CheckValue(var x: Integer; minValue, maxValue: Integer);
begin
    if x < minValue then
        x := minValue;
    if x > maxValue then
        x := maxValue;
end;


{ TNempBlockPanel }

constructor TNempBlockPanel.create;
begin
    fBlock   := Nil;
    fHeader  := Nil;
    fContent := Nil;
    fName    := '';
end;

procedure TNempBlockPanel.SetValues(aBlock, aHeader, aContent: TPanel;
  aName: String);
begin
    fBlock   := aBlock;
    fHeader  := aHeader;
    fContent := aContent;
    fName    := aName;
end;

{$region 'Simple Getter/Setter for TNempBlockPanel'}

function TNempBlockPanel.fGetAlign: TAlign;
begin
    result := fBlock.Align
end;

function TNempBlockPanel.fGetHeight: Integer;
begin
    result := fBlock.Height;
end;

function TNempBlockPanel.fGetLeft: Integer;
begin
    result := fBlock.Left;
end;

function TNempBlockPanel.fGetParent: TWinControl;
begin
    result := fBlock.Parent;
end;

function TNempBlockPanel.fGetTop: Integer;
begin
    result := fBlock.Top;
end;

function TNempBlockPanel.fGetWidth: Integer;
begin
    result := fBlock.Width;
end;

procedure TNempBlockPanel.fSetAlign(Value: TAlign);
begin
    fBlock.Align := Value;
end;

procedure TNempBlockPanel.fSetHeight(Value: Integer);
begin
    fBlock.Height := Value;
end;

procedure TNempBlockPanel.fSetLeft(Value: Integer);
begin
    fBlock.Left := Value;
end;

procedure TNempBlockPanel.fSetParent(Value: TWinControl);
begin
    fBlock.Parent := Value;
end;

procedure TNempBlockPanel.fSetTop(Value: Integer);
begin
    fBlock.Top := Value;
end;

procedure TNempBlockPanel.fSetWidth(Value: Integer);
begin
    fBlock.Width := Value;
end;
{$endregion}

{ TControlPanel }

constructor TControlPanel.create;
begin
    //
end;

function TControlPanel.fIsReal: Boolean;
begin
    result := assigned(Container1) AND
              assigned(Container2) AND
              assigned(Select) AND
              assigned(Cover) AND
              assigned(Player) AND
              assigned(Headset) AND
              assigned(Progress);// AND assigned(Visualisation);
end;

{$region 'Getter/Setter for TControlPanel'}
(*
function TControlPanel.fGetAlign: TAlign;
begin
    result := Block.Align;
end;
function TControlPanel.fGetHeight: Integer;
begin
    result := Block.Height;
end;
function TControlPanel.fGetLeft: Integer;
begin
    result := Block.Left;
end;
function TControlPanel.fGetParent: TWinControl;
begin
    result := Block.Parent;
end;
function TControlPanel.fGetTop: Integer;
begin
    result := Block.Top;
end;
function TControlPanel.fGetWidth: Integer;
begin
    result := Block.Width;
end;


procedure TControlPanel.fSetAlign(Value: TAlign);
begin
    Block.Align := Value;
end;
procedure TControlPanel.fSetHeight(Value: Integer);
begin
    Block.Height := Value;
end;
procedure TControlPanel.fSetLeft(Value: Integer);
begin
    Block.Left := Value;
end;
procedure TControlPanel.fSetParent(Value: TWinControl);
begin
    Block.Parent := Value;
end;
procedure TControlPanel.fSetTop(Value: Integer);
begin
    Block.Top := Value;
end;
procedure TControlPanel.fSetWidth(Value: Integer);
begin
    Block.Width := Value;
end;
*)
{$endregion}

procedure TControlPanel.SetControlValues(aBlock, aContainer1, aContainer2, aSelect,
  aCover, aPlayer, aHeadset, aProgress{, aVisualisation}: TPanel; aName: String);
begin
    fBlock        := aBlock         ;
    Container1    := aContainer1    ;
    Container2    := aContainer2    ;
    Select        := aSelect        ;
    Cover         := aCover         ;
    Player        := aPlayer        ;
    Headset       := aHeadset       ;
    Progress      := aProgress      ;
    //Visualisation := aVisualisation ;
    Name          := aName          ;
end;




{ TNempFormBuildOptions }


constructor TNempFormBuildOptions.Create;
begin
    // the List DO NOT owns the panels!
    PanelAChilds := TPanelList.Create(False);
    PanelBChilds := TPanelList.Create(False);

    BlockBrowse      := TNempBlockPanel.create;
    BlockPlaylist    := TNempBlockPanel.create;
    BlockMediaList   := TNempBlockPanel.create;
    BlockFileOverview:= TNempBlockPanel.create;

    ControlPanel := TControlPanel.create;

    HideFileOverviewPanel := False;

    ControlPanelTwoRows           := False;
    ControlPanelShowCover         := True;
    // ControlPanelShowVisualisation := True;

    fMainLayout := Layout_TwoRows;
    ControlPanelPosition := cp_FormBottom;
end;

destructor TNempFormBuildOptions.Destroy;
begin
    BlockBrowse.Free;
    BlockPlaylist.Free;
    BlockMediaList.Free;
    BlockFileOverview.Free;

    PanelAChilds.Free;
    PanelBChilds.Free;

    ControlPanel.Free;
    inherited;
end;

procedure TNempFormBuildOptions.BeginUpdate;
begin
    fRebuildingRightNow := True;
end;


procedure TNempFormBuildOptions.EndUpdate;
begin
    fRebuildingRightNow := False;
end;

function TNempFormBuildOptions.fGetAnUnusedSplitter: TSplitter;
begin
    if SubSplitter1.Tag = -1 then
        result := SubSplitter1
    else
        result := SubSplitter2
end;

function TNempFormBuildOptions.fGetIsReal: Boolean;
begin
    if Assigned(ControlPanel) then
        result := ControlPanel.IsReal
    else
        result := False;
end;

procedure TNempFormBuildOptions.fMakeSplittersAvailable(aTag: Integer);
begin
    // make Both Splitters available
    if SubSplitter1.Tag = aTag then
    begin
        SubSplitter1.Align := alNone;
        SubSplitter1.Tag := -1;
    end;
    if SubSplitter2.Tag = aTag then
    begin
        SubSplitter2.Align := alNone;
        SubSplitter2.Tag := -1;
    end;
end;

procedure TNempFormBuildOptions.MakeOneSplitterAvailable(aTag: Integer);
begin
    // make only one splitter available for building
    // used by BuilderForm when moving one subpanel to another Mainpanel
    if SubSplitter1.Tag = aTag then
    begin
        SubSplitter1.Align := alNone;
        SubSplitter1.Tag := -1;
    end else
    begin
        SubSplitter2.Align := alNone;
        SubSplitter2.Tag := -1;
    end;
end;




procedure TNempFormBuildOptions.fSetMainContainerSizes;
var newSize: Integer;
begin
    // set size of the two MainPanels
    if MainLayout = Layout_TwoRows then
    begin
        // two rows, adjust Height of the MainContainer
        newSize := Round(SuperContainer.Height * TopPanelRatio / 100);
        if newSize < MainPanelMinHeight then
            newSize := MainPanelMinHeight;
        if newSize > SuperContainer.Height - MainPanelMinHeight then
            newSize :=  SuperContainer.Height - MainPanelMinHeight;

        MainContainerA.Height := newSize;
    end else
    begin
        newSize := Round(SuperContainer.Width * TopPanelRatio / 100);
        if newSize < MainPanelMinWidth then
            newSize := MainPanelMinWidth;
        if newSize > SuperContainer.Width - MainPanelMinWidth then
            newSize :=  SuperContainer.Width - MainPanelMinWidth;

        MainContainerA.Width := newSize;
    end;
end;


procedure TNempFormBuildOptions.fSetBlockSizes(aMainContainer: TPanel; aChildList: TPanelList);
var i, newSize: Integer;
begin
    if not (assigned(aMainContainer) and assigned(aChildList)) then
        exit;

    if MainLayout = Layout_TwoRows then
        // two rows, adjust Width
        for i := 0 to aChildList.Count - 2 do
        begin
            newSize := Round(aMainContainer.Width * aChildList[i].Ratio / 100);
            if newSize > ChildPanelMinWidth then
                aChildList[i].Width := newSize
            else
                aChildList[i].Width := ChildPanelMinWidth;
        end
    else
        // two columns
        for i := 0 to aChildList.Count - 2 do
        begin
            newSize := Round(aMainContainer.Height * aChildList[i].Ratio / 100);
            if newSize > ChildPanelMinHeight then
                aChildList[i].Height := newSize
            else
                aChildList[i].Height := ChildPanelMinHeight;
        end
end;


procedure TNempFormBuildOptions.OnMainContainerResize(Sender: TObject);
var aChildList: TPanelList;
begin
    if fRebuildingRightNow then
        exit;

    if (Sender as TPanel) = MainContainerA then
        aChildList := self.PanelAChilds
    else
        if (Sender as TPanel) = MainContainerB then
            aChildList := self.PanelBChilds
        else
            aChildList := Nil;

    fSetBlockSizes(Sender as TPanel, aChildList);
end;


procedure TNempFormBuildOptions.OnSplitterMoved(Sender: TObject);
var aChildList: TPanelList;
    aContainer: TPanel;
    i: Integer;
begin
    aContainer := (Sender as TSplitter).Parent as TPanel;
    if (Sender as TSplitter).Tag = 0 then
        aChildList := self.PanelAChilds
    else
        if (Sender as TSplitter).Tag = 1 then
            aChildList := self.PanelBChilds
        else
            aChildList := Nil;

    if assigned(aChildList) then
    begin
        if MainLayout = Layout_TwoRows then
            // two rows, adjust ratio according to Width
            for i := 0 to aChildList.Count - 1 do
            begin
                aChildList[i].fRatio :=  Round( aChildList[i].Width / aContainer.Width * 100);
                if aChildList[i].fRatio < 10 then
                    aChildList[i].fRatio := 10;
                if aChildList[i].fRatio > 90 then
                    aChildList[i].fRatio := 90;
            end
        else
            for i := 0 to aChildList.Count - 1 do
            begin
                aChildList[i].fRatio :=  Round( aChildList[i].Height / aContainer.Height * 100);
                if aChildList[i].fRatio < 10 then
                    aChildList[i].fRatio := 10;
                if aChildList[i].fRatio > 90 then
                    aChildList[i].fRatio := 90;
            end;
    end;
end;


procedure TNempFormBuildOptions.OnSuperContainerResize(Sender: TObject);
begin
    if fRebuildingRightNow then
        exit;

    fSetMainContainerSizes;
end;

procedure TNempFormBuildOptions.OnMainSplitterMoved(Sender: TObject);
begin
    if MainLayout = Layout_TwoRows then
        TopPanelRatio := Round(MainContainerA.Height / SuperContainer.Height * 100)
    else
        TopPanelRatio := Round(MainContainerA.Width / SuperContainer.Width * 100)
end;

procedure TNempFormBuildOptions.fApplyRatio(aMainContainer: TPanel; aChildList: TPanelList);
var i, sum: Integer;
begin
    // first: set min sizes (correct invalid values)
    for i := 0 to aChildList.Count - 1 do
    begin
        if aChildList[i].fRatio < 10 then
            aChildList[i].fRatio := 10;
        if aChildList[i].fRatio > 90 then
            aChildList[i].fRatio := 90;
    end;

    // get the sum of all ratios, should be 100 ....
    sum := 0;
    for i := 0 to aChildList.Count - 1 do
        sum := sum + aChildList[i].Ratio;

    // ... if not: rescale them.
    // note: that may result in "smaller than 10%-panels", but thats ok now. (hopefully)
    if (sum <> 100) then
        for i := 0 to aChildList.Count - 1 do
            aChildList[i].fRatio := Round( aChildList[i].Ratio / sum * 100);

    fSetBlockSizes(aMainContainer, aChildList);
end;

procedure TNempFormBuildOptions.ApplyRatios;
begin
    // set size of the two MainPanels
    fSetMainContainerSizes;
    fApplyRatio(MainContainerA, PanelAChilds);
    fApplyRatio(MainContainerB, PanelBChilds);
end;

procedure TNempFormBuildOptions.Assign(
  aNempFormBuildOptions: TNempFormBuildOptions);
var i: Integer;
    aSplitter: TSplitter;
begin
    self.PanelAChilds.Clear;
    self.PanelBChilds.Clear;

    for i := 0 to aNempFormBuildOptions.PanelAChilds.Count - 1 do
    begin
        if aNempFormBuildOptions.PanelAChilds[i] = aNempFormBuildOptions.BlockBrowse then
            PanelAChilds.Add(BlockBrowse);
        if aNempFormBuildOptions.PanelAChilds[i] = aNempFormBuildOptions.BlockPlaylist then
            PanelAChilds.Add(BlockPlaylist);
        if aNempFormBuildOptions.PanelAChilds[i] = aNempFormBuildOptions.BlockMediaList then
            PanelAChilds.Add(BlockMediaList);
        if aNempFormBuildOptions.PanelAChilds[i] = aNempFormBuildOptions.BlockFileOverview then
            PanelAChilds.Add(BlockFileOverview);
    end;

    for i := 0 to aNempFormBuildOptions.PanelBChilds.Count - 1 do
    begin
        if aNempFormBuildOptions.PanelBChilds[i] = aNempFormBuildOptions.BlockBrowse then
            PanelBChilds.Add(BlockBrowse);
        if aNempFormBuildOptions.PanelBChilds[i] = aNempFormBuildOptions.BlockPlaylist then
            PanelBChilds.Add(BlockPlaylist);
        if aNempFormBuildOptions.PanelBChilds[i] = aNempFormBuildOptions.BlockMediaList then
            PanelBChilds.Add(BlockMediaList);
        if aNempFormBuildOptions.PanelBChilds[i] = aNempFormBuildOptions.BlockFileOverview then
            PanelBChilds.Add(BlockFileOverview);
    end;

    self.NewLayout := aNempFormBuildOptions.MainLayout;

    ControlPanelPosition    := aNempFormBuildOptions.ControlPanelPosition     ;
    ControlPanelSubPosition := aNempFormBuildOptions.ControlPanelSubPosition  ;

    if aNempFormBuildOptions.ControlPanelSubParent = aNempFormBuildOptions.BlockBrowse then
        ControlPanelSubParent := BlockBrowse;
    if aNempFormBuildOptions.ControlPanelSubParent = aNempFormBuildOptions.BlockPlaylist then
        ControlPanelSubParent := BlockPlaylist;
    if aNempFormBuildOptions.ControlPanelSubParent = aNempFormBuildOptions.BlockMediaList then
        ControlPanelSubParent := BlockMediaList;
    if aNempFormBuildOptions.ControlPanelSubParent = aNempFormBuildOptions.BlockFileOverview then
        ControlPanelSubParent := BlockFileOverview;


    HideFileOverviewPanel := aNempFormBuildOptions.HideFileOverviewPanel;
    BlockFileOverview.fBlock.Visible := NOT HideFileOverviewPanel;

    ControlPanelTwoRows           := aNempFormBuildOptions.ControlPanelTwoRows           ;
    ControlPanelShowCover         := aNempFormBuildOptions.ControlPanelShowCover         ;

    TopPanelRatio := aNempFormBuildOptions.TopPanelRatio;
    BlockBrowse      .fRatio := aNempFormBuildOptions.BlockBrowse      .fRatio;
    BlockPlaylist    .fRatio := aNempFormBuildOptions.BlockPlaylist    .fRatio;
    BlockMediaList   .fRatio := aNempFormBuildOptions.BlockMediaList   .fRatio;
    BlockFileOverview.fRatio := aNempFormBuildOptions.BlockFileOverview.fRatio;

    RefreshBothRowsOrColumns(False);
    SwapMainLayout;
    ApplyRatios;
end;


procedure TNempFormBuildOptions.LoadFromIni(aIni: TMemIniFile);
var ControlPanelSubParentIdx: Integer;
begin

    NewLayout                 := TMainLayout(aIni.ReadInteger('FormBuilder', 'MainLayout', 1) mod 2);
    HideFileOverviewPanel     := aIni.ReadBool('FormBuilder', 'HideFileOverviewPanel', False  );

    // settings for ControlPanel
    ControlPanelPosition      := TControlPanelPosition(aIni.ReadInteger('FormBuilder', 'ControlPanelPosition', 3) mod 4);
    ControlPanelSubPosition   := TControlPanelSubPosition(aIni.ReadInteger('FormBuilder', 'ControlPanelSubPosition', 1) mod 2);
    ControlPanelSubParentIdx  := aIni.ReadInteger('FormBuilder', 'ControlPanelSubParentIdx', 2) mod 4 ;
    case ControlPanelSubParentIdx of
        0: ControlPanelSubParent := BlockBrowse;
        1: ControlPanelSubParent := BlockPlaylist;
        2: ControlPanelSubParent := BlockMediaList;
        3: ControlPanelSubParent := BlockFileOverview;
    end;
    ControlPanelTwoRows           := aIni.ReadBool('FormBuilder', 'ControlPanelTwoRows'          , False );
    ControlPanelShowCover         := aIni.ReadBool('FormBuilder', 'ControlPanelShowCover'        , True  );
    // ControlPanelShowVisualisation := aIni.ReadBool('FormBuilder', 'ControlPanelShowVisualisation', True  );

    // position and sizes of the 4 blocks
    BlockBrowse.fParentIndex      := aIni.ReadInteger('FormBuilder', 'BlockBrowseParent'      , 0);
    BlockBrowse.fSortIndex        := aIni.ReadInteger('FormBuilder', 'BlockBrowseSort'        , 0);
    BlockBrowse.fRatio            := aIni.ReadInteger('FormBuilder', 'BlockBrowseRatio'       , 50);

    BlockPlaylist.fParentIndex    := aIni.ReadInteger('FormBuilder', 'BlockPlaylistParent'    , 1);
    BlockPlaylist.fSortIndex      := aIni.ReadInteger('FormBuilder', 'BlockPlaylistSort'      , 0);
    BlockPlaylist.fRatio          := aIni.ReadInteger('FormBuilder', 'BlockPlaylistRatio'     , 50);

    BlockMediaList.fParentIndex   := aIni.ReadInteger('FormBuilder', 'BlockMediaListParent'   , 0);
    BlockMediaList.fSortIndex     := aIni.ReadInteger('FormBuilder', 'BlockMediaListSort'     , 1);
    BlockMediaList.fRatio         := aIni.ReadInteger('FormBuilder', 'BlockMediaListRatio'    , 70);

    BlockFileOverview.fParentIndex:= aIni.ReadInteger('FormBuilder', 'BlockFileOverviewParent', 1);
    BlockFileOverview.fSortIndex  := aIni.ReadInteger('FormBuilder', 'BlockFileOverviewSort'  , 1);
    BlockFileOverview.fRatio      := aIni.ReadInteger('FormBuilder', 'BlockFileOverviewRatio' , 30);

    // main Ratio and some special ratios
    TopPanelRatio          := aIni.ReadInteger('FormBuilder', 'RatioTopPanel'         , 60);
    BrowseArtistRatio      := aIni.ReadInteger('FormBuilder', 'RatioBrowseArtist'     , 50);
    FileOverviewCoverRatio := aIni.ReadInteger('FormBuilder', 'RatioFileOverviewCover', 50);

    CheckValue(BlockBrowse.fRatio       , 10, 90);
    CheckValue(BlockPlaylist.fRatio     , 10, 90);
    CheckValue(BlockMediaList.fRatio    , 10, 90);
    CheckValue(BlockFileOverview.fRatio , 10, 90);

    CheckValue(TopPanelRatio          , 10, 90);
    CheckValue(BrowseArtistRatio      , 10, 90);
    CheckValue(FileOverviewCoverRatio , 10, 90);


    // apply some settings directly ?
    BlockFileOverview.fBlock.Visible := NOT HideFileOverviewPanel;

    // fill the PanelLists
    PanelAChilds.Clear;
    PanelBChilds.Clear;
    if BlockBrowse      .fParentIndex = 0 then PanelAChilds.Add(BlockBrowse)       else PanelBChilds.Add(BlockBrowse);
    if BlockPlaylist    .fParentIndex = 0 then PanelAChilds.Add(BlockPlaylist)     else PanelBChilds.Add(BlockPlaylist);
    if BlockMediaList   .fParentIndex = 0 then PanelAChilds.Add(BlockMediaList)    else PanelBChilds.Add(BlockMediaList);
    if BlockFileOverview.fParentIndex = 0 then PanelAChilds.Add(BlockFileOverview) else PanelBChilds.Add(BlockFileOverview);
    // sort the PanelLists
    fSortChilds;

end;

procedure TNempFormBuildOptions.SaveToIni(aIni: TMemIniFile);
var i, ControlPanelSubParentIdx: Integer;
begin

    if newLayout <> MainLayout then   // needed when we start in seprate mode and do not enter compact mode at all
        aIni.WriteInteger('FormBuilder', 'MainLayout', Integer(newLayout))
    else
        aIni.WriteInteger('FormBuilder', 'MainLayout', Integer(MainLayout));


    aIni.WriteBool('FormBuilder', 'HideFileOverviewPanel', HideFileOverviewPanel);

    // settings for ControlPanel
    aIni.WriteInteger('FormBuilder', 'ControlPanelPosition', Integer(ControlPanelPosition));
    aIni.WriteInteger('FormBuilder', 'ControlPanelSubPosition', Integer(ControlPanelSubPosition));
    ControlPanelSubParentIdx := 0;
    if ControlPanelSubParent = BlockBrowse then
        ControlPanelSubParentIdx := 0
    else
        if ControlPanelSubParent = BlockPlaylist then
            ControlPanelSubParentIdx := 1
        else
            if ControlPanelSubParent = BlockMediaList then
                ControlPanelSubParentIdx := 2
            else
                if ControlPanelSubParent = BlockFileOverview then
                    ControlPanelSubParentIdx := 3;
    aIni.WriteInteger('FormBuilder', 'ControlPanelSubParentIdx', ControlPanelSubParentIdx);

    aIni.WriteBool('FormBuilder', 'ControlPanelTwoRows'          , ControlPanelTwoRows           );
    aIni.WriteBool('FormBuilder', 'ControlPanelShowCover'        , ControlPanelShowCover         );
    // aIni.WriteBool('FormBuilder', 'ControlPanelShowVisualisation', ControlPanelShowVisualisation );

    // make sure the temporary index variables are set correctly
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].fParentIndex := 0;
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].fSortIndex := i;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].fParentIndex := 1;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].fSortIndex := i;

    aIni.WriteInteger('FormBuilder', 'BlockBrowseParent'      , BlockBrowse.fParentIndex);
    aIni.WriteInteger('FormBuilder', 'BlockBrowseSort'        , BlockBrowse.fSortIndex  );
    aIni.WriteInteger('FormBuilder', 'BlockBrowseRatio'       , BlockBrowse.fRatio      );

    aIni.WriteInteger('FormBuilder', 'BlockPlaylistParent'    , BlockPlaylist.fParentIndex );
    aIni.WriteInteger('FormBuilder', 'BlockPlaylistSort'      , BlockPlaylist.fSortIndex   );
    aIni.WriteInteger('FormBuilder', 'BlockPlaylistRatio'     , BlockPlaylist.fRatio       );

    aIni.WriteInteger('FormBuilder', 'BlockMediaListParent'   , BlockMediaList.fParentIndex);
    aIni.WriteInteger('FormBuilder', 'BlockMediaListSort'     , BlockMediaList.fSortIndex  );
    aIni.WriteInteger('FormBuilder', 'BlockMediaListRatio'    , BlockMediaList.fRatio      );

    aIni.WriteInteger('FormBuilder', 'BlockFileOverviewParent', BlockFileOverview.fParentIndex);
    aIni.WriteInteger('FormBuilder', 'BlockFileOverviewSort'  , BlockFileOverview.fSortIndex  );
    aIni.WriteInteger('FormBuilder', 'BlockFileOverviewRatio' , BlockFileOverview.fRatio      );

    // main Ratio and some special ratios
     aIni.WriteInteger('FormBuilder', 'RatioBrowseArtist'     , BrowseArtistRatio     );
     aIni.WriteInteger('FormBuilder', 'RatioFileOverviewCover', FileOverviewCoverRatio);
     aIni.WriteInteger('FormBuilder', 'RatioTopPanel'         , TopPanelRatio         );

end;

procedure TNempFormBuildOptions.NilConstraints;
begin

    MainSplitter.MinSize := 1; // 0 is not possible
    SubSplitter1.MinSize := 1;
    SubSplitter2.MinSize := 1;

    MainContainerA   .Constraints.MinHeight := 0;
    MainContainerA   .Constraints.MinWidth  := 0;
    MainContainerB   .Constraints.MinHeight := 0;
    MainContainerB   .Constraints.MinWidth  := 0;
    BlockBrowse      .Block.Constraints.MinHeight := 0;
    BlockBrowse      .Block.Constraints.MinWidth  := 0;
    BlockPlaylist    .Block.Constraints.MinHeight := 0;
    BlockPlaylist    .Block.Constraints.MinWidth  := 0;
    BlockMediaList   .Block.Constraints.MinHeight := 0;
    BlockMediaList   .Block.Constraints.MinWidth  := 0;
    BlockFileOverview.Block.Constraints.MinHeight := 0;
    BlockFileOverview.Block.Constraints.MinWidth  := 0;
end;

procedure TNempFormBuildOptions.SetProperConstraints;
begin
{
      MAIN_PANEL_MinHeight = 250;
      MAIN_PANEL_MinWidth = 250;

      CHILD_PANEL_MinWidth = 150;
      CHILD_PANEL_MinHeight = 100;
}

    case MainLayout of
        Layout_TwoRows: begin
            MainSplitter.MinSize := MAIN_PANEL_MinHeight;
            SubSplitter1.MinSize := CHILD_PANEL_MinWidth;
            SubSplitter2.MinSize := CHILD_PANEL_MinWidth;

            MainContainerA   .Constraints.MinHeight := MAIN_PANEL_MinHeight;
            MainContainerA   .Constraints.MinWidth  := MAIN_PANEL_MinWidth;  // FormConstraints will be a higher
            MainContainerB   .Constraints.MinHeight := MAIN_PANEL_MinHeight;
            MainContainerB   .Constraints.MinWidth  := MAIN_PANEL_MinWidth;

            BlockBrowse      .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockPlaylist    .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockMediaList   .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockFileOverview.Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;

            BlockBrowse      .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockPlaylist    .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockMediaList   .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockFileOverview.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
        end;

        Layout_TwoColumns: begin

            MainSplitter.MinSize := MAIN_PANEL_MinWidth;
            SubSplitter1.MinSize :=  CHILD_PANEL_MinHeight;
            SubSplitter2.MinSize := CHILD_PANEL_MinHeight;

            MainContainerA   .Constraints.MinHeight := MAIN_PANEL_MinHeight; // FormConstraints will be a higher
            MainContainerA   .Constraints.MinWidth  := MAIN_PANEL_MinWidth;
            MainContainerB   .Constraints.MinHeight := MAIN_PANEL_MinHeight; // FormConstraints will be a higher
            MainContainerB   .Constraints.MinWidth  := MAIN_PANEL_MinWidth;

            BlockBrowse      .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockPlaylist    .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockMediaList   .Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;
            BlockFileOverview.Block.Constraints.MinWidth  := CHILD_PANEL_MinWidth;

            BlockBrowse      .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockPlaylist    .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockMediaList   .Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;
            BlockFileOverview.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight;

        end;

        Layout_Undef: ; // nothing to do
    end;

    if (ControlPanelPosition = cp_subPanel) and ControlPanelTwoRows then
    begin
        if ControlPanelSubParent = BlockBrowse then BlockBrowse.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight + 100;
        if ControlPanelSubParent = BlockPlaylist then BlockPlaylist.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight + 100;
        if ControlPanelSubParent = BlockMediaList then BlockMediaList.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight + 100;
        if ControlPanelSubParent = BlockFileOverview then BlockFileOverview.Block.Constraints.MinHeight := CHILD_PANEL_MinHeight + 100;
    end;


end;

function TNempFormBuildOptions.EmptyPanel(aChildList: TPanelList): Boolean;
begin
    result := (aChildList.Count = 0) // should not happen
              or
              ( (aChildList.Count = 1) AND (aChildList[0] = BlockFileOverview) AND (HideFileOverviewPanel))
end;



procedure TNempFormBuildOptions.SwapMainLayout;
var firstPanelRelativeSize: Double;
    RatioArrayA, RatioArrayB: Array[0..MAXCHILDS] of Double;
    i, completeSize, completeSizeA, completeSizeB, currentleft, currentTop: Integer;
    SizeFits: Boolean;
    RemainingSizeNeeded, RemainingSize: Integer;
    newSplitter: TSplitter;
begin
    // backup current ratios of Widths (or Heights)
    case MainLayout of
        Layout_TwoRows: begin
            firstPanelRelativeSize := MainContainerA.Height / SuperContainer.Height;

            completeSize :=  MainContainerA.Width - (4 * (PanelAChilds.Count - 1)); // 4 * X -> Size of the Splitters
            for i := 0 to PanelAChilds.Count - 1 do
                RatioArrayA[i] := PanelAChilds[i].Width / completeSize;
            completeSize :=  MainContainerB.Width - (4 * (PanelBChilds.Count - 1));
            for i := 0 to PanelBChilds.Count - 1 do
                RatioArrayB[i] := PanelBChilds[i].Width / completeSize;
        end;

        Layout_TwoColumns: begin
            firstPanelRelativeSize := MainContainerA.Width / SuperContainer.Width;

            completeSize :=  MainContainerA.Height - (4 * (PanelAChilds.Count - 1)); // 4 * X -> Size of the Splitters
            for i := 0 to PanelAChilds.Count - 1 do
                RatioArrayA[i] := PanelAChilds[i].Height / completeSize;
            completeSize :=  MainContainerB.Height - (4 * (PanelBChilds.Count - 1));
            for i := 0 to PanelBChilds.Count - 1 do
                RatioArrayB[i] := PanelBChilds[i].Height / completeSize;
        end;

        Layout_Undef: begin
            firstPanelRelativeSize := 0.5;
            for i := 0 to PanelAChilds.Count - 1 do RatioArrayA[i] := 1/PanelAChilds.Count;
            for i := 0 to PanelBChilds.Count - 1 do RatioArrayB[i] := 1/PanelBChilds.Count;
        end;
    end;


    // before updating the orientation of the MainPanels:
    // set Parent to NIL
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].Parent := Nil;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].Parent := Nil;

    // unalign ChildPanels
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].Align := alNone;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].Align := alNone;

    // unalign Splitters
    SubSplitter1.Align := alNone;
    SubSplitter2.Align := alNone;
    SubSplitter1.Tag := -1;  // -1 <=> "not used"
    SubSplitter2.Tag := -1;  // -1 <=> "not used"

    if ControlPanelPosition in [cp_FormTop, cp_FormCenter, cp_FormBottom] then
    begin
        ControlPanel.Parent := Nil;
        ControlPanel.Align := alNone;
    end;

    // Swap MainPanel orientation
    MainContainerA.Align := alNone;
    MainContainerB.Align := alNone;
    MainSplitter.Align := alNone;
    case NewLayout of    // NewLayout here!
          Layout_TwoRows: begin
              currentTop := 0;

              if ControlPanelPosition in [cp_FormTop, cp_FormCenter, cp_FormBottom] then
                  RemainingSize := SuperContainer.Height - ControlPanel.Height - 4
              else
                  RemainingSize := SuperContainer.Height - 4;

              // place the ControlPanel here, if "TOP"
              if ControlPanelPosition = cp_FormTop then
              begin
                  ControlPanel.Parent := SuperContainer;
                  ControlPanel.Top := 0;
                  ControlPanel.Align := alTop;
                  currentTop := ControlPanel.Height;
                  // Do not change the height here - the CP has a fixed height!
              end;

              MainContainerA.Top := currentTop;
              MainContainerA.Height := Round({SuperContainer.Height} RemainingSize * firstPanelRelativeSize);

              if MainContainerA.Height < ChildPanelMinHeight then
                  MainContainerA.Height := ChildPanelMinHeight;

              if MainContainerA.Height > RemainingSize - ChildPanelMinHeight then
                  MainContainerA.Height := RemainingSize - ChildPanelMinHeight;

              currentTop := currentTop + MainContainerA.Height; // no splitter here
              // place the ControlPanel here, if "CENTER"
              if ControlPanelPosition = cp_FormCenter then
              begin
                  ControlPanel.Parent := SuperContainer;
                  ControlPanel.Top := currentTop;
                  ControlPanel.Align := alTop;
                  currentTop := ControlPanel.Height;
                  // Do not change the height here - the CP has a fixed height!
              end;

              // place the ControlPanel now at the botom, if "BOTTOM"
              if ControlPanelPosition = cp_FormBottom then
              begin
                  ControlPanel.Parent := SuperContainer;
                  ControlPanel.Align := alBottom;
              end;

              // Place the splitter and the remaining MainPanel
              MainContainerA.Visible := NOT EmptyPanel(PanelAChilds);
              MainContainerB.Visible := NOT EmptyPanel(PanelBChilds);

              if NOT (EmptyPanel(PanelAChilds) or EmptyPanel(PanelBChilds)) then
              begin
                  MainSplitter.Visible := True;
                  MainSplitter.Height := 4;
                  MainSplitter.Top := currentTop; //MainContainerA.Height;
                  MainContainerA.Align := alTop;
                  MainSplitter.Align := alTop;
                  MainContainerB.Align := alClient;
              end else
              begin
                  MainSplitter.Visible := False;
                  if EmptyPanel(PanelAChilds) then MainContainerB.Align := alClient;
                  if EmptyPanel(PanelBChilds) then MainContainerA.Align := alClient;
              end;

          end;
          Layout_TwoColumns: begin

              RemainingSize := SuperContainer.Width - 4;

              if ControlPanelPosition in [cp_FormTop, cp_FormCenter, cp_FormBottom] then
              begin
                  ControlPanel.Parent := MegaContainer
              end;

              if ControlPanelPosition in [cp_FormTop, cp_FormCenter] then
              begin
                  ControlPanel.Top := 0;
                  ControlPanel.Align := alTop;
              end;
              if ControlPanelPosition = cp_FormBottom then
              begin
                  //  ControlPanel.Top := 0;
                  ControlPanel.Align := alBottom;
              end;

              MainContainerA.Visible := NOT EmptyPanel(PanelAChilds);
              MainContainerB.Visible := NOT EmptyPanel(PanelBChilds);
              if NOT (EmptyPanel(PanelAChilds) or EmptyPanel(PanelBChilds)) then
              begin
                  MainSplitter.Visible := True;
                  MainContainerA.Left := 0;
                  MainContainerA.Width := Round(SuperContainer.Width * firstPanelRelativeSize);

                  if MainContainerA.Width < ChildPanelMinWidth then
                      MainContainerA.Width := ChildPanelMinWidth;

                  if MainContainerA.Width > RemainingSize - ChildPanelMinWidth then
                      MainContainerA.Width := RemainingSize - ChildPanelMinWidth;

                  MainSplitter.Width := 4;
                  MainSplitter.Left := MainContainerA.Width;
                  MainContainerA.Align := alLeft;
                  MainSplitter.Align := alLeft;
                  MainContainerB.Align := alClient;
              end  else
              begin
                  MainSplitter.Visible := False;
                  if EmptyPanel(PanelAChilds) then MainContainerB.Align := alClient;
                  if EmptyPanel(PanelBChilds) then MainContainerA.Align := alClient;
              end;
          end;
    end;



    // Fill Mainpanels with ChildPanels
    // But first: a quick check whether the rotated sizes matches the constraints
    // if not: set (almost) equal size to all childs
    case NewLayout of
        Layout_TwoRows: begin
            // check Sizes
            SizeFits := True;
            completeSizeA :=  MainContainerA.Width - (4 * (PanelAChilds.Count - 1));
            for i := 0 to PanelAChilds.Count - 1 do
                if (completeSizeA * RatioArrayA[i]) < ChildPanelMinWidth then SizeFits := False;
            if Not SizeFits then
                for i := 0 to PanelAChilds.Count - 1 do RatioArrayA[i] := 1/PanelAChilds.Count;

            SizeFits := True;
            completeSizeB :=  MainContainerB.Width - (4 * (PanelBChilds.Count - 1));
            for i := 0 to PanelBChilds.Count - 1 do
                if (completeSizeB * RatioArrayB[i]) < ChildPanelMinWidth then SizeFits := False;
            if Not SizeFits then
                for i := 0 to PanelBChilds.Count - 1 do RatioArrayB[i] := 1/PanelBChilds.Count;
        end;
        Layout_TwoColumns: begin
            // check Sizes
            SizeFits := True;
            completeSizeA :=  MainContainerA.Height - (4 * (PanelAChilds.Count - 1));
            for i := 0 to PanelAChilds.Count - 1 do
                if (completeSizeA * RatioArrayA[i]) < ChildPanelMinHeight then SizeFits := False;
            if Not SizeFits then
                for i := 0 to PanelAChilds.Count - 1 do RatioArrayA[i] := 1/PanelAChilds.Count;

            SizeFits := True;
            completeSizeB :=  MainContainerB.Height - (4 * (PanelBChilds.Count - 1));
            for i := 0 to PanelBChilds.Count - 1 do
                if (completeSizeB * RatioArrayB[i]) < ChildPanelMinHeight then SizeFits := False;
            if Not SizeFits then
                for i := 0 to PanelBChilds.Count - 1 do RatioArrayB[i] := 1/PanelBChilds.Count;
        end;
        else begin
            // just some dummy values. Should never occur
            completeSizeA := 500;
            completeSizeB := 500;
        end;


    end;

    // Set Parents again
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].Parent := MainContainerA;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].Parent := MainContainerB;


    case Newlayout  of
      Layout_TwoRows: begin
            // fill the two rows

            currentLeft := 0;
            for i := 0 to PanelAChilds.Count - 2 do
            begin
                PanelAChilds[i].Left := currentleft;
                PanelAChilds[i].Width := Round(completeSizeA * RatioArrayA[i]);
                currentLeft := currentLeft + PanelAChilds[i].Width;

                newSplitter := fGetAnUnusedSplitter;
                newSplitter.Width := 4;
                newSplitter.Left := currentLeft;
                newSplitter.Tag := 0; // 0 <=> PanelA
                newSplitter.Visible := True;
                currentLeft := currentLeft + newSplitter.Width;

                PanelAChilds[i].Align := alLeft;
                newSplitter.Align := alLeft;
            end;
            if PanelAChilds.Count > 0 then
            begin
                i := PanelAChilds.Count - 1;
                PanelAChilds[i].Left := currentleft;
                PanelAChilds[i].Align := alClient;
            end;

            currentLeft := 0;
            for i := 0 to PanelBChilds.Count - 2 do
            begin
                PanelBChilds[i].Left := currentleft;
                //PanelBChilds[i].Height := MainContainerB.Height;
                PanelBChilds[i].Width := Round(completeSizeB * RatioArrayB[i]);
                currentLeft := currentLeft + PanelBChilds[i].Width;

                newSplitter := fGetAnUnusedSplitter;
                newSplitter.Width := 4;
                newSplitter.Left := currentLeft;
                newSplitter.Tag := 1; // 1 <=> PanelB
                newSplitter.Visible := True;
                currentLeft := currentLeft + newSplitter.Width;

                PanelBChilds[i].Align := alLeft;
                newSplitter.Align := alLeft;
            end;
            if PanelBChilds.Count > 0 then
            begin
                i := PanelBChilds.Count - 1;
                PanelBChilds[i].Left := currentleft;
                PanelBChilds[i].Align := alClient;
            end;

      end;
      Layout_TwoColumns: begin
            currentTop := 0;
            for i := 0 to PanelAChilds.Count - 2 do
            begin
                PanelAChilds[i].Top := currentTop;
                PanelAChilds[i].Height := Round(completeSizeA * RatioArrayA[i]);
                currentTop := currentTop + PanelAChilds[i].Height;

                newSplitter := fGetAnUnusedSplitter;
                newSplitter.Height := 4;
                newSplitter.Top := currentTop;
                newSplitter.Tag := 0;
                newSplitter.Visible := True;
                currentTop := currentTop + newSplitter.Height;

                PanelAChilds[i].Align := alTop;
                newSplitter.Align := alTop;
            end;
            if PanelAChilds.Count > 0 then
            begin
                i := PanelAChilds.Count - 1;
                PanelAChilds[i].Top := currentTop;
                PanelAChilds[i].Align := alClient;
            end;

            currentTop := 0;
            for i := 0 to PanelBChilds.Count - 2 do
            begin
                PanelBChilds[i].Top := currentTop;
                PanelBChilds[i].Height := Round(completeSizeB * RatioArrayB[i]);
                currentTop := currentTop + PanelBChilds[i].Height;

                newSplitter := fGetAnUnusedSplitter;
                newSplitter.Height := 4;
                newSplitter.Top := currentTop;
                newSplitter.Tag := 1;
                newSplitter.Visible := True;
                currentTop := currentTop + newSplitter.Height;

                PanelBChilds[i].Align := alTop;
                newSplitter.Align := alTop;
            end;
            if PanelBChilds.Count > 0 then
            begin
                i := PanelBChilds.Count - 1;
                PanelBChilds[i].Top := currentTop;
                PanelBChilds[i].Align := alClient;
            end;

      end;
    end;

    // set the Parent of ControlPanel to one of the Blocks
    if ControlPanelPosition = cp_subPanel then
    begin
        ControlPanel.Parent := ControlPanelSubParent.fBlock;

        if self.ControlPanelSubPosition = cp_SubTop then
        begin
            ControlPanel.Align := alTop;
            ControlPanelSubParent.fHeader.Top := ControlPanel.Height;
        end
        else
            ControlPanel.Align := alBottom;
    end;

    fMainLayout := NewLayout;

    RefreshControlPanel;

    if IsReal then
        SetProperConstraints;
end;

procedure TNempFormBuildOptions.RefreshBothRowsOrColumns(DoSort: Boolean);
var rescaleFactorA, rescaleFactorB: Double;
begin

    // Nope. RefreshMainLayout; // if needed: turn mainpanels by 90 degrees
   // Problem beim resizeFaktor: Wenn der letzt (alClient) kleiner wird als Constraints = > fehler, SuperContainer wächst

    case MainLayout of
      Layout_TwoRows: begin
          rescaleFactorA := GetRescaleFactorRow(MainContainerA);
          rescaleFactorB := GetRescaleFactorRow(MainContainerB);

          if DoSort  then
          begin
              fLeftToSortIndex;
              fSortChilds;
          end;

          RefreshARow(MainContainerA, rescaleFactorA);
          RefreshARow(MainContainerB, rescaleFactorB);

      end;
      Layout_TwoColumns: begin
          rescaleFactorA := GetRescaleFactorColumn(MainContainerA);
          rescaleFactorB := GetRescaleFactorColumn(MainContainerB);

          if DoSort  then
          begin
              fTopToSortIndex;
              fSortChilds;
          end;

          RefreshAColumn(MainContainerA, rescaleFactorA);
          RefreshAColumn(MainContainerB, rescaleFactorB);

      end;
      Layout_Undef: ; // nothing to do;
    end;

end;



procedure TNempFormBuildOptions.RefreshControlPanel;
begin
    if ControlPanel.IsReal then
    begin
        /// note: without the extr visualisation panel
        ///  this can be done much more simple. But I kkep it that way for now ...
        {
        Block,
            Container1, Container2,
            Select, Cover,
            Player, Headset,
            Progress, Visualisation: TPanel;
        }
        ControlPanel.Cover.Visible := ControlPanelShowCover;
        if ControlPanelShowCover then
            ControlPanel.Cover.width := CONTROL_PANEL_CoverWidth
        else
            ControlPanel.Cover.width := 0;

        // CONTROL_PANEL_CoverWidth = 100;
        // CONTROL_PANEL_VisualisationWidth = 140;

         if self.ControlPanelTwoRows then
        begin
            // two rows

            ControlPanel.Container1.Align := alNone;
            ControlPanel.Container2.Align := alNone;
            ControlPanel.Progress.Align := alNone;

            ControlPanel.Select.Left := 0;
            ControlPanel.Cover.Left := ControlPanel.Select.Width;
            ControlPanel.Player.Left := ControlPanel.Cover.Left + ControlPanel.Cover.Width;
            ControlPanel.Headset.Left := ControlPanel.Player.Left + ControlPanel.Player.Width;

            // progress-panel to alClient
            ControlPanel.Progress.Left := 0;
            ControlPanel.Progress.Align := alClient;


            ControlPanel.Container1.Top := 0;
            ControlPanel.Container1.Width := ControlPanel.Width;
            ControlPanel.Container1.Height := CONTROL_PANEL_HEIGHT_1;

            ControlPanel.Container2.Top := CONTROL_PANEL_HEIGHT_1;
            ControlPanel.Container2.Height := CONTROL_PANEL_HEIGHT_1;
            ControlPanel.Container2.Width := ControlPanel.Width;

            ControlPanel.Container1.Align := alTop;
            ControlPanel.Container2.Align := alTop;

            ControlPanel.Height := CONTROL_PANEL_HEIGHT_2;

            //ControlPanel.Container2.Align := alClient;

        end else
        begin
            ControlPanel.Container1.Align := alNone;
            ControlPanel.Container2.Align := alNone;

            // one row
            ControlPanel.Progress.Align := alNone;
            // ControlPanel.Visualisation.Align := alNone;

            ControlPanel.Select.Left := 0;
            ControlPanel.Cover.Left := ControlPanel.Select.Width;
            ControlPanel.Player.Left := ControlPanel.Cover.Left + ControlPanel.Cover.Width;
            ControlPanel.Headset.Left := ControlPanel.Player.Left + ControlPanel.Player.Width;

            ControlPanel.Progress.Left := 0;
            ControlPanel.Progress.Align := alClient;

            ControlPanel.Container1.Left := 0;
            ControlPanel.Container1.Width := ControlPanel.Select.Width +
                                             ControlPanel.Cover.width +
                                             ControlPanel.Player.Width;

            ControlPanel.Container1.Height := CONTROL_PANEL_HEIGHT_1;
            ControlPanel.Container2.Height := CONTROL_PANEL_HEIGHT_1;
            ControlPanel.Height := CONTROL_PANEL_HEIGHT_1;

            ControlPanel.Container2.Left := ControlPanel.Container1.Width;

            ControlPanel.Container1.Align := alLeft;
            ControlPanel.Container2.Align := alClient;
        end;

    end;
    // else: nothing to do, just the testform.
end;

procedure TNempFormBuildOptions.ResetToDefault;
begin
    NewLayout  := Layout_TwoRows;
    HideFileOverviewPanel := False;

    // settings for ControlPanel
    ControlPanelPosition      := cp_FormBottom;
    ControlPanelSubPosition   := cp_SubBottom;   // but that doesn't matter here
    ControlPanelSubParent     := BlockMediaList; // but that doesn't matter here

    ControlPanelTwoRows           := False;
    ControlPanelShowCover         := True;
    // ControlPanelShowVisualisation := True;

    // position and sizes of the 4 blocks
    PanelAChilds.Clear;
    PanelBChilds.Clear;
    PanelAChilds.Add(BlockBrowse);
    PanelAChilds.Add(BlockPlaylist);
    PanelBChilds.Add(BlockMediaList);
    PanelBChilds.Add(BlockFileOverview);
    BlockBrowse.fRatio := 50;
    BlockPlaylist.fRatio := 50;
    BlockMediaList.fRatio := 70;
    BlockFileOverview.fRatio := 30;


    // main Ratio and some special ratios
    TopPanelRatio          := 50;
    BrowseArtistRatio      := 50;
    FileOverviewCoverRatio := 50;

    // apply some settings directly ?
    BlockFileOverview.Block.Visible := NOT HideFileOverviewPanel;

    RefreshBothRowsOrColumns(False);
    SwapMainLayout;
    ApplyRatios;
end;

procedure TNempFormBuildOptions.ResizeSubPanel(ABlockPanel: TPanel; aSubPanel: TWinControl; aRatio: Integer);
var newWidth: Integer;
begin
    newWidth := Round(aRatio / 100 * (ABlockPanel.Width));
    if newWidth < 30 then
        newWidth := 30;

    if ABlockPanel.Width - newWidth < 30 then
        newWidth := ABlockPanel.Width - 30;

    aSubPanel.Width := newWidth;
end;

function TNempFormBuildOptions.GetBlockByPanel(aPanel: TPanel): TNempBlockPanel;
var i: Integer;
begin
    result := Nil;
    for i := 0 to PanelAChilds.Count - 1 do
        if PanelAChilds[i].Block = aPanel then
            result := PanelAChilds[i];

    if not assigned (result) then
    begin
        for i := 0 to PanelBChilds.Count - 1 do
            if PanelBChilds[i].Block = aPanel then
                result := PanelBChilds[i];
    end;
end;

function TNempFormBuildOptions.GetRescaleFactorColumn(
  aMainPanel: TPanel): Double;
var aChildList: TPanelList;
    i, totalHeight: Integer;
begin
    // Get the proper Lists for this Main Panel
    if aMainPanel = MainContainerA then
        aChildList := PanelAChilds
    else
        aChildList := PanelBChilds;

    // compute the total Height of the ChildPanels
    totalHeight := 0;
    for i := 0 to aChildList.Count - 1 do
        totalHeight := totalHeight + aChildList[i].Height;

    // get a proper scaling factor, so that all childs fit in the Mainpanel later
    result := (aMainpanel.Height - ChildPanelMinHeight - (4 * (aChildList.Count-1)))  /  (totalHeight) ;

    if result > 1 then
        result := 1;
end;

function TNempFormBuildOptions.GetRescaleFactorRow(aMainPanel: TPanel): Double;
var aChildList: TPanelList;
    i, totalWidth: Integer;
begin
    // Get the proper Lists for this Main Panel
    if aMainPanel = MainContainerA then
        aChildList := PanelAChilds
    else
        aChildList := PanelBChilds;

    // compute the total Width of the ChildPanels
    totalWidth := 0;
    for i := 0 to aChildList.Count - 1 do
        totalWidth := totalWidth + aChildList[i].Width;

    // get a proper scaling factor, so that all childs fit in the Mainpanel later
    // reduce mainwidth by 1xChildPanelmainWidth to ensure everything fits.
    result := (aMainpanel.Width - ChildPanelMinWidth - (4 * (aChildList.Count-1))) / (totalWidth);

    if result > 1 then
        result := 1;
    if result < 0.1 then
        result := 0.1;
end;



procedure TNempFormBuildOptions.fTopToSortIndex;
var i: Integer;
begin
    for i := 0 to PanelAChilds.Count - 1 do
        PanelAChilds[i].fSortIndex := PanelAChilds[i].Top;
    for i := 0 to PanelBChilds.Count - 1 do
        PanelBChilds[i].fSortIndex := PanelBChilds[i].Top;
end;

procedure TNempFormBuildOptions.fLeftToSortIndex;
var i: Integer;
begin
    for i := 0 to PanelAChilds.Count - 1 do
        PanelAChilds[i].fSortIndex := PanelAChilds[i].Left;
    for i := 0 to PanelBChilds.Count - 1 do
        PanelBChilds[i].fSortIndex := PanelBChilds[i].Left;
end;

// sorting: just do a quick Bubblesort

procedure TNempFormBuildOptions.fSortaChildList(aPanelList: TPanelList);
var i: Integer;
    swapped: Boolean;
begin
    swapped := True;
    while swapped do
    begin
        swapped := False;
        for i := 0 to aPanelList.Count - 2 do
        begin
            if aPanelList[i].fSortIndex > aPanelList[i+1].fSortIndex then
            begin
                aPanelList.Exchange(i, i+1);
                swapped := True;
            end;
        end;
    end;
end;

procedure TNempFormBuildOptions.fSortChilds;
begin
    fSortaChildList(PanelAChilds);
    fSortaChildList(PanelBChilds);
end;


procedure TNempFormBuildOptions.RefreshARow(aMainPanel: TPanel; scaleFactor: Double = 1);
var aChildList: TPanelList;
    //aSplitterList: TSplitterList;
    i, currentLeft: Integer;
    widthArray: Array[0..MAXCHILDS] of Integer;
    DesiredSplitterTag: Integer;
    newSplitter: TSplitter;
begin
    // Get the proper Lists for this Main Panel
    if aMainPanel = MainContainerA then
    begin
        aChildList := PanelAChilds;
        //aSplitterList := PanelASplitters;
        DesiredSplitterTag := 0;
    end else
    begin
        aChildList := PanelBChilds;
        //aSplitterList := PanelBSplitters;
        DesiredSplitterTag := 1;
    end;

    // get the widths of the ChildPanels (before un-aligning them!)
    for i := 0 to aChildList.Count - 1 do
        widthArray[i] := Round(aChildList[i].Width * scaleFactor);

    // unalign ChildPanels and Splitters
    for i := 0 to aChildList.Count - 1 do
        aChildList[i].Align := alNone;
    
    fMakeSplittersAvailable(DesiredSplitterTag);


    // Set Parents (needed, if we swapped some Childs before)
    for i := 0 to aChildList.Count - 1 do
        aChildList[i].Parent := aMainPanel;


    currentLeft := 0;
    for i := 0 to aChildList.Count - 2 do
    begin
        aChildList[i].Left := currentleft;
        aChildList[i].Width := widthArray[i];
        currentLeft := currentLeft + aChildList[i].Width;

        newSplitter := fGetAnUnusedSplitter;
        newSplitter.Width := 4;
        newSplitter.Parent := aMainPanel;
        newSplitter.Tag  := DesiredSplitterTag;
        newSplitter.Left := currentLeft;
        newSplitter.Visible := True;
        currentLeft := currentLeft + newSplitter.Width;

        aChildList[i].Align := alLeft;
        newSplitter.Align := alLeft;
    end;
    if aChildList.Count > 0 then
    begin
        i := aChildList.Count - 1;
        aChildList[i].Left := currentleft;
        aChildList[i].Align := alClient;
    end;
end;


procedure TNempFormBuildOptions.RefreshAColumn(aMainPanel: TPanel; scaleFactor: Double = 1);
var aChildList: TPanelList;
    i, currentTop: Integer;
    heightArray: Array[0..MAXCHILDS] of Integer;
    DesiredSplitterTag: Integer;
    newSplitter: TSplitter;
begin
    // Get the proper Lists for this Main Panel
    if aMainPanel = MainContainerA then
    begin
        aChildList := PanelAChilds;
        DesiredSplitterTag := 0;
    end else
    begin
        aChildList := PanelBChilds;
        DesiredSplitterTag := 1;
    end;

    // get the heights of the ChildPanels (before un-aligning them!)
    for i := 0 to aChildList.Count - 1 do
        heightArray[i] := Round(aChildList[i].Height * scaleFactor);

    // unalign ChildPanels and Splitters
    for i := 0 to aChildList.Count - 1 do
        aChildList[i].Align := alNone;
    fMakeSplittersAvailable(DesiredSplitterTag);

    // Set Parents (needed, if we swapped some Childs before)
    for i := 0 to aChildList.Count - 1 do
        aChildList[i].Parent := aMainPanel;

    currentTop := 0;
    for i := 0 to aChildList.Count - 2 do
    begin
        aChildList[i].Top := currentTop;
        aChildList[i].Height := heightArray[i];
        currentTop := currentTop + aChildList[i].Height;

        newSplitter := fGetAnUnusedSplitter;
        newSplitter.Height := 4;
        newSplitter.Parent := aMainPanel;
        newSplitter.Tag := DesiredSplitterTag;
        newSplitter.Top := currentTop;
        newSplitter.Visible := True;
        currentTop := currentTop + newSplitter.Height;

        aChildList[i].Align := alTop;
        newSplitter.Align := alTop;
    end;
    if aChildList.Count > 0 then
    begin
        i := aChildList.Count - 1;
        aChildList[i].Top := currentTop;
        aChildList[i].Align := alClient;
    end;
end;

procedure ReadNempOptions(ini: TMemIniFile; var Options: TNempOptions; var FormBuildOptions: TNempFormBuildOptions);
begin

    with FormBuildOptions.WindowSizeAndPositions do
    begin
        MainFormTop            := ini.ReadInteger('Windows', 'MainTop'     ,0   );
        MainFormLeft           := ini.ReadInteger('Windows', 'MainLeft'    ,0   );
        MainFormWidth          := ini.ReadInteger('Windows', 'MainWidth'   ,1200);
        MainFormHeight         := ini.ReadInteger('Windows', 'MainHeight'  ,750 );
        MainFormMaximized         := ini.ReadBool('Windows', 'maximiert_0' ,False);

        MiniMainFormTop            := ini.ReadInteger('Windows', 'MiniTop'   , 0 );
        MiniMainFormLeft           := ini.ReadInteger('Windows', 'MiniLeft'  , 616 );
        MiniMainFormWidth          := ini.ReadInteger('Windows', 'MiniWidth' , 800 );
        //MiniMainFormWidth          := 234 + 2 * GetSystemMetrics(SM_CXFrame);
        MiniMainFormHeight         := 560;

        PlaylistVisible           := ini.ReadBool('Windows','PlaylistVisible'   , True);
        MedienlisteVisible        := ini.ReadBool('Windows','MedienlisteVisible', True);
        AuswahlSucheVisible       := ini.ReadBool('Windows','AuswahlVisible'    , True);
        ErweiterteControlsVisible := ini.ReadBool('Windows','ControlsVisible'   , True);

        PlaylistDocked            := ini.ReadBool('Windows','PlaylistDocked'    , False);
        MedienlisteDocked         := ini.ReadBool('Windows','MedienlisteDocked' , False);
        AuswahlListeDocked        := ini.ReadBool('Windows','AuswahlListeDocked', False);
        ExtendedControlsDocked    := ini.ReadBool('Windows','ExtendedControlsDocked', False);

        ExtendedControlsTop       := Ini.ReadInteger('Windows', 'ExtendedControlsTop'   , 166);
        ExtendedControlsLeft      := Ini.ReadInteger('Windows', 'ExtendedControlsLeft'  , 623);
        ExtendedControlsHeight    := Ini.ReadInteger('Windows', 'ExtendedControlsHeight' , 330);
        ExtendedControlsWidth     := Ini.ReadInteger('Windows', 'ExtendedControlsWidth'  , 400);

        PlaylistTop               := Ini.ReadInteger('Windows', 'PlaylistTop'   , 23);
        PlaylistLeft              := Ini.ReadInteger('Windows', 'PlaylistLeft'  , 868);
        PlaylistHeight            := Ini.ReadInteger('Windows', 'PlaylistHeight', 391);
        PlaylistWidth             := Ini.ReadInteger('Windows', 'PlaylistWidth' , 254);

        MedienlisteTop            := Ini.ReadInteger('Windows', 'MedienlisteTop'   , 428);
        MedienlisteLeft           := Ini.ReadInteger('Windows', 'MedienlisteLeft'  , 16);
        MedienlisteHeight         := Ini.ReadInteger('Windows', 'MedienlisteHeight', 330);
        MedienlisteWidth          := Ini.ReadInteger('Windows', 'MedienlisteWidth' , 1108);

        AuswahlSucheTop           := Ini.ReadInteger('Windows', 'AuswahlSucheTop'   , 22);
        AuswahlSucheLeft          := Ini.ReadInteger('Windows', 'AuswahlSucheLeft'  , 18);
        AuswahlSucheHeight        := Ini.ReadInteger('Windows', 'AuswahlSucheHeight', 391);
        AuswahlSucheWidth         := Ini.ReadInteger('Windows', 'AuswahlSucheWidth' , 594);
    end;


    With Options do
    begin
        LastKnownVersion     := ini.ReadInteger('Allgemein','LastKnownVersion',0 );

        AutoCloseProgressWindow := ini.ReadBool('Allgemein', 'AutoCloseProgressWindow', False);
        StartMinimized       := ini.ReadBool('Allgemein', 'StartMinimized', False);
        AllowOnlyOneInstance := ini.ReadBool('Allgemein', 'AllowOnlyOneInstance', True);
        RegisterHotKeys      := ini.ReadBool('Allgemein', 'RegisterHotKeys', False);
        RegisterMediaHotkeys := ini.ReadBool('Allgemein', 'RegisterMediaHotkeys', True);
        IgnoreVolumeUpDownKeys  := ini.ReadBool('Allgemein', 'IgnoreVolumeUpDownKeys', True);
        TabStopAtPlayerControls := ini.ReadBool('Allgemein', 'TabStopAtPlayerControls', True);
        TabStopAtTabs := ini.ReadBool('Allgemein', 'TabStopAtTabs', False);

        DisplayApp := Ini.ReadString('Allgemein', 'DisplayApp', 'NempG15App.exe');
        UseDisplayApp := Ini.ReadBool('Allgemein', 'UseDisplayApp', false);
        // "Kill" relative Paths
        DisplayApp := Stringreplace(DisplayApp, '\', '', [rfReplaceAll]);

        AllowQuickAccessToMetadata := Ini.ReadBool('Allgemein', 'AllowQuickAccessToMetadata', False);
        UseCDDB                    := Ini.ReadBool('Allgemein', 'UseCDDB', False);

        MiniNempStayOnTop := ini.ReadBool('Allgemein', 'MiniNempStayOnTop', False);
        FixCoverFlowOnStart := ini.ReadBool('Allgemein', 'FixCoverFlowOnStart', False);

        //ShutdownMode := Ini.ReadInteger('Allgemein', 'ShutDownMode', SHUTDOWNMODE_Shutdown);
        ShutDownModeIniIdx     := Ini.ReadInteger('Allgemein',  'ShutDownModeIniIdx'    , 4);
        ShutDownTimeIniIdx     := Ini.ReadInteger('Allgemein',  'ShutDownTimeIniIdx'    , 3);
        ShutDownTimeIniHours   := Ini.ReadInteger('Allgemein',  'ShutDownTimeIniHours'  , 2);
        ShutDownTimeIniMinutes := Ini.ReadInteger('Allgemein',  'ShutDownTimeIniMinutes', 0);

        CheckValue(ShutDownModeIniIdx      , 0, 4);  // 5 different ShutDown-Modes
        CheckValue(ShutDownTimeIniIdx      , 0, 8);  // 9 different preselections for countdown-length
        CheckValue(ShutDownTimeIniHours    , 0, 24);
        CheckValue(ShutDownTimeIniMinutes  , 0, 59);


        // ShutDownAtEndOfPlaylist initialisieren
        ShutDownAtEndOfPlaylist := False;
        Language := Ini.ReadString('Allgemein', 'Language', '');
        maxDragFileCount := Ini.ReadInteger('Allgemein', 'maxDragFileCount', 2500);

        NempWindowView       := ini.ReadInteger('Fenster', 'NempWindowView', NEMPWINDOW_ONLYTASKBAR);
        ShowDeskbandOnMinimize  := ini.ReadBool('Fenster', 'ShowDeskbandOnMinimize', False);
        ShowDeskbandOnStart     := ini.ReadBool('Fenster', 'ShowDeskbandOnStart', True);
        HideDeskbandOnRestore   := ini.ReadBool('Fenster', 'HideDeskbandOnRestore', False);
        HideDeskbandOnClose     := ini.ReadBool('Fenster', 'HideDeskbandOnClose', True);

        FullRowSelect := ini.ReadBool('Fenster', 'FullRowSelect', True);

        ReplaceNAArtistBy := ini.ReadInteger('Fenster', 'ReplaceNAArtistBy', 3);
        if not ReplaceNAArtistBy in [0,1,2,3,4,5] then ReplaceNAArtistBy := 3;
        ReplaceNATitleBy  := ini.ReadInteger('Fenster', 'ReplaceNATitleBy' , 2);
        if not ReplaceNATitleBy in [0,1,2,3,4,5] then ReplaceNATitleBy := 2;
        ReplaceNAAlbumBy  := ini.ReadInteger('Fenster', 'ReplaceNAAlbumBy' , 4);
        if not ReplaceNAAlbumBy in [0,1,2,3,4,5] then ReplaceNAAlbumBy := 4;

        ArtistAlbenFontSize   := ini.ReadInteger('Font','ArtistAlbenFontSize',8);
        ArtistAlbenRowHeight  := ini.ReadInteger('Font','ArtistAlbenRowHeight',14);
        RowHeight             := Ini.ReadInteger('Font', 'RowHeight', 16 );
        DefaultFontSize       := ini.ReadInteger('Font', 'DefaultFontSize', 8);
        DefaultFontStyle      := ini.ReadInteger('Font', 'DefaultFontStyle', 0);
        ArtistAlbenFontStyle  := ini.ReadInteger('Font', 'ArtistAlbenFontStyle', 0);
        // translate into actual font styles
        DefaultFontStyles     := FontSelectorItemIndexToStyle(DefaultFontStyle);
        ArtistAlbenFontStyles := FontSelectorItemIndexToStyle(ArtistAlbenFontStyle);

        ChangeFontColorOnBitrate := ini.ReadBool('Font','ChangeFontColorOnBitrate',False);
        ChangeFontSizeOnLength := ini.ReadBool('Font','ChangeFontSizeOnLength',False);

        MaxDauer[1] := Ini.ReadInteger('Font', 'Maxdauer1',  60);
        MaxDauer[2] := Ini.ReadInteger('Font', 'Maxdauer2', 150);
        MaxDauer[3] := Ini.ReadInteger('Font', 'Maxdauer3', 360);
        MaxDauer[4] := Ini.ReadInteger('Font', 'Maxdauer4', 900);

        ChangeFontStyleOnMode := ini.ReadBool('Font','ChangeFontStyleOnMode',False);
        ChangeFontOnCbrVbr := ini.ReadBool('Font','ChangeFontOnCbrVbr',False);
        FontNameVBR := ini.ReadString('Font','FontNameVBR','Tahoma');
        FontNameCBR := ini.ReadString('Font','FontNameCBR','Courier');
    end;

end;

procedure SaveWindowPositons(ini: TMemIniFile; var FormBuildOptions: TNempFormBuildOptions; aMode: Integer);
begin


    with FormBuildOptions.WindowSizeAndPositions do
    begin
        if aMode = 1 then
        begin

            ini.WriteInteger('Windows', 'MiniTop'  , MiniMainFormTop   );
            ini.WriteInteger('Windows', 'MiniLeft' , MiniMainFormLeft  );
            ini.WriteInteger('Windows', 'MiniWidth' , MiniMainFormWidth );

            ini.WriteBool('Windows','PlaylistVisible'   , PlaylistVisible           );
            ini.WriteBool('Windows','MedienlisteVisible', MedienlisteVisible        );
            ini.WriteBool('Windows','AuswahlVisible'    , AuswahlSucheVisible       );
            ini.WriteBool('Windows','ControlsVisible'   , ErweiterteControlsVisible );

            ini.WriteBool('Windows','PlaylistDocked'    , PlaylistForm.NempRegionsDistance.docked   );
            ini.WriteBool('Windows','MedienlisteDocked' , MedienlisteForm.NempRegionsDistance.docked);
            ini.WriteBool('Windows','AuswahlListeDocked', AuswahlForm.NempRegionsDistance.docked    );
            ini.WriteBool('Windows','ExtendedControlsDocked', ExtendedControlForm.NempRegionsDistance.docked );

            Ini.WriteInteger('Windows', 'ExtendedControlsTop'    , ExtendedControlForm.Top);
            Ini.WriteInteger('Windows', 'ExtendedControlsLeft'   , ExtendedControlForm.Left);
            Ini.WriteInteger('Windows', 'ExtendedControlsHeight' , ExtendedControlForm.Height);
            Ini.WriteInteger('Windows', 'ExtendedControlsWidth'  , ExtendedControlForm.Width);

            Ini.WriteInteger('Windows', 'PlaylistTop'   , PlaylistForm.Top   );
            Ini.WriteInteger('Windows', 'PlaylistLeft'  , PlaylistForm.Left  );
            Ini.WriteInteger('Windows', 'PlaylistHeight', PlaylistForm.Height);
            Ini.WriteInteger('Windows', 'PlaylistWidth' , PlaylistForm.Width );

            Ini.WriteInteger('Windows', 'MedienlisteTop'   , MedienlisteForm.Top   );
            Ini.WriteInteger('Windows', 'MedienlisteLeft'  , MedienlisteForm.Left  );
            Ini.WriteInteger('Windows', 'MedienlisteHeight', MedienlisteForm.Height);
            Ini.WriteInteger('Windows', 'MedienlisteWidth' , MedienlisteForm.Width );

            Ini.WriteInteger('Windows', 'AuswahlSucheTop'   , AuswahlForm.Top   );
            Ini.WriteInteger('Windows', 'AuswahlSucheLeft'  , AuswahlForm.Left  );
            Ini.WriteInteger('Windows', 'AuswahlSucheHeight', AuswahlForm.Height);
            Ini.WriteInteger('Windows', 'AuswahlSucheWidth' , AuswahlForm.Width );
        end else
        begin
            ini.WriteInteger('Windows', 'MainTop'     , MainFormTop     );
            ini.WriteInteger('Windows', 'MainLeft'    , MainFormLeft    );
            ini.WriteInteger('Windows', 'MainWidth'   , MainFormWidth   );
            ini.WriteInteger('Windows', 'MainHeight'  , MainFormHeight  );
            ini.WriteBool('Windows', 'maximiert_0' ,MainFormMaximized);
        end;
    end;
end;

procedure WriteNempOptions(ini: TMemIniFile; var Options: TNempOptions; var FormBuildOptions: TNempFormBuildOptions; aMode: Integer);
begin
    SaveWindowPositons(ini, FormBuildOptions, aMode);
    FormBuildOptions.SaveToIni(ini);

  With Options do
  begin
        //ini.WriteBool('Allgemein','DenyID3Edit',DenyID3Edit);
        ini.WriteBool('Allgemein', 'StartMinimized', StartMinimized);

        ini.WriteBool('Allgemein', 'AutoCloseProgressWindow', AutoCloseProgressWindow);
        ini.WriteBool('Allgemein', 'ShowSplashScreen', ShowSplashScreen);
        ini.WriteInteger('Allgemein','LastKnownVersion', WIZ_CURRENT_SKINVERSION);
        ini.WriteBool('Allgemein', 'AllowOnlyOneInstance', AllowOnlyOneInstance);
        ini.WriteBool('Allgemein', 'RegisterHotKeys', RegisterHotKeys);
        ini.WriteBool('Allgemein', 'RegisterMediaHotkeys', RegisterMediaHotkeys);
        ini.WriteBool('Allgemein', 'IgnoreVolumeUpDownKeys', IgnoreVolumeUpDownKeys);
        ini.WriteBool('Allgemein', 'TabStopAtPlayerControls', TabStopAtPlayerControls);
        ini.WriteBool('Allgemein', 'TabStopAtTabs', TabStopAtTabs);

        Ini.WriteBool('Allgemein', 'UseDisplayApp', UseDisplayApp);
        // Note: The Display-App-String is written by the G15-App only

        Ini.WriteBool('Allgemein', 'AllowQuickAccessToMetadata', AllowQuickAccessToMetadata);
        Ini.WriteBool('Allgemein', 'UseCDDB', UseCDDB);

        ini.WriteBool('Allgemein', 'MiniNempStayOnTop', MiniNempStayOnTop);
        ini.WriteBool('Allgemein', 'FixCoverFlowOnStart', FixCoverFlowOnStart);

        Ini.WriteInteger('Allgemein',  'ShutDownModeIniIdx'    , ShutDownModeIniIdx    );
        Ini.WriteInteger('Allgemein',  'ShutDownTimeIniIdx'    , ShutDownTimeIniIdx    );
        Ini.WriteInteger('Allgemein',  'ShutDownTimeIniHours'  , ShutDownTimeIniHours  );
        Ini.WriteInteger('Allgemein',  'ShutDownTimeIniMinutes', ShutDownTimeIniMinutes);

        Ini.WriteString('Allgemein', 'Language', Language);
        Ini.WriteInteger('Allgemein', 'maxDragFileCount', maxDragFileCount);


        {
        ini.WriteInteger('Fenster', 'Splitter1_0'          , NempFormAufteilung[0].TopMainPanelHeight);
        ini.WriteInteger('Fenster', 'BrowseListenWeite_0'  , NempFormAufteilung[0].AuswahlPanelWidth );
        ini.WriteInteger('Fenster', 'ArtisListenWeite_0'   , NempFormAufteilung[0].ArtistWidth       );
        ini.WriteBool('Fenster', 'maximiert_0', NempFormAufteilung[0].Maximized);

        ini.WriteInteger('Fenster', 'Splitter1_1'          ,NempFormAufteilung[1].TopMainPanelHeight);//391;
        ini.WriteInteger('Fenster', 'BrowseListenWeite_1'  ,NempFormAufteilung[1].AuswahlPanelWidth);//303;
        ini.WriteInteger('Fenster', 'ArtisListenWeite_1'   ,NempFormAufteilung[1].ArtistWidth);//73;

        ini.WriteInteger('Fenster', 'Top_1'                , NempFormAufteilung[1].FormTop           );
        ini.WriteInteger('Fenster', 'Left_1'               , NempFormAufteilung[1].FormLeft          );


        Ini.WriteInteger('Fenster', 'VSTHeight'      , NempFormRatios.VSTHeight    );
        Ini.WriteInteger('Fenster', 'BrowseWidth'    , NempFormRatios.BrowseWidth  );
        Ini.WriteInteger('Fenster', 'VSTWidth'       , NempFormRatios.VSTWidth     );
        Ini.WriteInteger('Fenster', 'VDTCoverWidth'  , NempFormRatios.VDTCoverWidth);
        //Ini.WriteInteger('Fenster', 'VDTCoverHeight' , NempFormRatios.VDTCoverHeight);
        Ini.WriteInteger('Fenster', 'ArtistWidth'    , NempFormRatios.ArtistWidth  );
          }

        Ini.WriteInteger('Fenster', 'NempWindowView', NempWindowView);
        ini.WriteBool('Fenster', 'ShowDeskbandOnMinimize', ShowDeskbandOnMinimize);
        ini.WriteBool('Fenster', 'ShowDeskbandOnStart', ShowDeskbandOnStart);
        ini.WriteBool('Fenster', 'HideDeskbandOnRestore', HideDeskbandOnRestore);
        ini.WriteBool('Fenster', 'HideDeskbandOnClose', HideDeskbandOnClose);
        ini.WriteBool('Fenster', 'FullRowSelect', FullRowSelect);
        //ini.WriteBool('Fenster', 'ShowCoverAndDetails', ShowCoverAndDetails);
        //ini.WriteInteger('Fenster', 'CoverWidth', CoverWidth);

        ini.WriteInteger('Fenster', 'ReplaceNAArtistBy', ReplaceNAArtistBy);
        ini.WriteInteger('Fenster', 'ReplaceNATitleBy' , ReplaceNATitleBy );
        ini.WriteInteger('Fenster', 'ReplaceNAAlbumBy' , ReplaceNAAlbumBy );

        ini.WriteInteger('Font','ArtistAlbenFontSize',ArtistAlbenFontSize);
        ini.WriteInteger('Font','ArtistAlbenRowHeight',ArtistAlbenRowHeight);
        Ini.WriteInteger('Font', 'RowHeight', RowHeight  );
        ini.WriteInteger('Font','DefaultFontSize',DefaultFontSize);
        ini.WriteInteger('Font', 'DefaultFontStyle', DefaultFontStyle);
        ini.WriteInteger('Font', 'ArtistAlbenFontStyle', ArtistAlbenFontStyle);

        ini.Writebool('Font','ChangeFontSizeOnLength',ChangeFontSizeOnLength);
        ini.Writebool('Font','ChangeFontColorOnBitrate',ChangeFontColorOnBitrate);
        Ini.WriteInteger('Font', 'Maxdauer1', MaxDauer[1]);
        Ini.WriteInteger('Font', 'Maxdauer2', MaxDauer[2]);
        Ini.WriteInteger('Font', 'Maxdauer3', MaxDauer[3]);
        Ini.WriteInteger('Font', 'Maxdauer4', MaxDauer[4]);

        ini.Writebool('Font','ChangeFontStyleOnMode',ChangeFontStyleOnMode);
        ini.Writebool('Font','ChangeFontOnCbrVbr',ChangeFontOnCbrVbr);
        ini.WriteString('Font','FontNameVBR',FontNameVBR);
        ini.WriteString('Font','FontNameCBR',FontNameCBR);
  end;
end;

procedure UnInstallHotKeys(Handle: HWND);
var i: Integer;
begin
    for i := 0 to 9 do
        UnRegisterHotkey(Handle, i);
end;

procedure UninstallMediakeyHotkeys(Handle: HWND);
var i: Integer;
begin
    for i := 11 to 17 do
        UnRegisterHotkey(Handle, i);
end;

procedure InstallMediakeyHotkeys(IgnoreVolume: Boolean; Handle: HWND);
begin
    if not IgnoreVolume then
    begin
        RegisterHotkey(Handle, 11, 0, VK_VOLUME_MUTE     );
        RegisterHotkey(Handle, 12, 0, VK_VOLUME_DOWN     );
        RegisterHotkey(Handle, 13, 0, VK_VOLUME_UP       );
    end;

    RegisterHotkey(Handle, 14, 0, VK_MEDIA_NEXT_TRACK);
    RegisterHotkey(Handle, 15, 0, VK_MEDIA_PREV_TRACK);
    RegisterHotkey(Handle, 16, 0, VK_MEDIA_STOP      );
    RegisterHotkey(Handle, 17, 0, VK_MEDIA_PLAY_PAUSE);
end;

procedure InstallHotkeys(aIniPath: UnicodeString; Handle: HWND);
var Ini: TMemIniFile;
    hMod: Cardinal;
    hKey: Byte;
begin
  ini := TMeminiFile.Create(aIniPath + 'Hotkeys.ini', TEncoding.UTF8);
  try
       ini.Encoding := TEncoding.UTF8;

       If Ini.ReadBool('HotKeys','InstallHotkey_Play'       , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Play' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Play', ord('P'));
         RegisterHotkey(Handle, 1, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_Stop'       , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Stop' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Stop', ord('S'));
         RegisterHotkey(Handle, 2, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_Next'       , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Next' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Next', ord('N'));
         RegisterHotkey(Handle, 3, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_Prev'       , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Prev' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Prev', ord('B'));
         RegisterHotkey(Handle, 4, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_JumpForward', True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpForward' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpForward', ord('M'));
         RegisterHotkey(Handle, 5, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_JumpBack'   , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpBack' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpBack', ord('V'));
         RegisterHotkey(Handle, 6, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_IncVol'     , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_IncVol' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_IncVol', $BB);
         RegisterHotkey(Handle, 7, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_DecVol'     , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_DecVol' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_DecVol', $BD);
         RegisterHotkey(Handle, 8, HMod, hKey);
       end;

       If Ini.ReadBool('HotKeys','InstallHotkey_Mute'       , True) then
       begin
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Mute' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Mute', ord('0'));
         RegisterHotkey(Handle, 9, HMod, hKey);
       end;
  finally
    ini.Free;
  end;
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






end.


