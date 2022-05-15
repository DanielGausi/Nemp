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
     WindowsVersionInfo,
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
    TEProgressActions = (pa_Default, pa_SearchFiles, pa_SearchFilesForPlaylist, pa_RefreshFiles, pa_CleanUp, pa_Searchlyrics, pa_SearchTags, pa_UpdateMetaData, pa_DeleteFiles, pa_ScanNewFiles);

    TEDefaultCoverType = (dcFile, dcWebRadio, dcCDDA, dcNoCover_deprecated, dcError);

    TSpalte = record
      Bezeichnung: string;
      Inhalt: integer;
      visible: boolean;
      width: integer;
      sortAscending: boolean;
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
        (Key: 'Main'; Top: 0; Left: 0; Width: 1200; Height: 750; Docked: False; Visible: True),
        (Key: 'MiniMain'; Top: 410; Left: 180; Width: 800; Height: 100; Docked: False; Visible: True), //height: ignored here
        (Key: 'Playlist'; Top: 0; Left: 780; Width: 400; Height: 390; Docked: False; Visible: True),
        (Key: 'MediaList'; Top: 530; Left: 0; Width: 840; Height: 330; Docked: False; Visible: True),
        (Key: 'BrowseList'; Top: 0; Left: 0; Width: 760; Height: 390; Docked: False; Visible: True),
        (Key: 'Extended'; Top: 530; Left: 860; Width: 330; Height: 330; Docked: False; Visible: True)
      );

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
            //property Header  : TPanel read fHeader ;
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
            procedure LoadSettings;
            procedure SaveSettings;

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
        DetailFormStayOnTop: Boolean;
        FullRowSelect: Boolean;
        TippSpeed: Integer;

        NempWindowView: Word;
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

        /// MOVED WriteAccessPossible: Boolean;
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

        AnzeigeMode: Integer;
        UseSkin: Boolean;
        GlobalUseAdvancedSkin: Boolean;
        SkinName: UnicodeString;

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
    NEMP_VERSION_SPLASH = 'version 4.15';// 'v3.3';
    NEMP_BASS_DEFAULT_USERAGENT = 'Nemp/4.15';

    NEMP_TIPSIZE = 128;

    NEMP_PLAYER_COVERSIZE = 88;

    BROWSE_PLAYLISTS =     '!!{A8F4183D-C8FE-4585-A6C6-36FCC402143D}';
    BROWSE_RADIOSTATIONS = '!!{B3723948-3015-4E60-8727-4AC7663CE7A5}';
    BROWSE_ALL =           '!!{F7B03349-5B91-4025-B439-EAF46875717B}';


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

    WM_PrepareNextFile = WM_USER + 518;
    WM_PlayerDelayedPlayNext = WM_USER + 519;
    WM_PlayerDelayCompleted = WM_USER + 520;

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

    Spaltenzahl = 29;
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
    CON_BPM = 28;

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

      DefaultSpalten : array[0..28] of TSpalte =
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
        (Bezeichnung: 'Album peak' ;Inhalt: CON_ALBUMPEAK       ;visible: false   ;width: 70 ;sortAscending: True),
        (Bezeichnung: 'BPM'        ;Inhalt: CON_BPM             ;visible: false   ;width: 70 ;sortAscending: True)
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

      TRACK_BPM = 'BPM';

      REPLAYGAIN_TRACK_GAIN = 'REPLAYGAIN_TRACK_GAIN';
      REPLAYGAIN_ALBUM_GAIN = 'REPLAYGAIN_ALBUM_GAIN';

      REPLAYGAIN_TRACK_PEAK = 'REPLAYGAIN_TRACK_PEAK';
      REPLAYGAIN_ALBUM_PEAK = 'REPLAYGAIN_ALBUM_PEAK';


function GetDefaultEqualizerIndex(aEQSettingsName: String): Integer;

function NempOptions: TNempOptions;
// function NempFormBuildOptions: TNempFormBuildOptions;
function NempSettingsManager: TNempSettingsManager;

//function Assigned_NempFormBuildOptions: Boolean;


implementation

uses PlaylistUnit, MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, BasicSettingsWizard, Treehelper;

var fNempOptions: TNempOptions;
    fNempSettingsManager: TNempSettingsManager;
    fNempFormBuildOptions: TNempFormBuildOptions;

{function Assigned_NempFormBuildOptions: Boolean;
begin
  result := assigned(fNempFormBuildOptions);
end;}

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

(*
function NempFormBuildOptions: TNempFormBuildOptions;
begin
  if not assigned(fNempFormBuildOptions) then
    fNempFormBuildOptions := TNempFormBuildOptions.create;
  result := fNempFormBuildOptions;
end;*)



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


procedure TNempFormBuildOptions.LoadSettings;
var ControlPanelSubParentIdx: Integer;

begin
    NewLayout                 := TMainLayout(NempSettingsManager.ReadInteger('FormBuilder', 'MainLayout', 1) mod 2);
    HideFileOverviewPanel     := NempSettingsManager.ReadBool('FormBuilder', 'HideFileOverviewPanel', False  );

    // settings for ControlPanel
    ControlPanelPosition      := TControlPanelPosition(NempSettingsManager.ReadInteger('FormBuilder', 'ControlPanelPosition', 3) mod 4);
    ControlPanelSubPosition   := TControlPanelSubPosition(NempSettingsManager.ReadInteger('FormBuilder', 'ControlPanelSubPosition', 1) mod 2);
    ControlPanelSubParentIdx  := NempSettingsManager.ReadInteger('FormBuilder', 'ControlPanelSubParentIdx', 2) mod 4 ;
    case ControlPanelSubParentIdx of
        0: ControlPanelSubParent := BlockBrowse;
        1: ControlPanelSubParent := BlockPlaylist;
        2: ControlPanelSubParent := BlockMediaList;
        3: ControlPanelSubParent := BlockFileOverview;
    end;
    ControlPanelTwoRows           := NempSettingsManager.ReadBool('FormBuilder', 'ControlPanelTwoRows'          , False );
    ControlPanelShowCover         := NempSettingsManager.ReadBool('FormBuilder', 'ControlPanelShowCover'        , True  );
    // ControlPanelShowVisualisation := aIni.ReadBool('FormBuilder', 'ControlPanelShowVisualisation', True  );

    // position and sizes of the 4 blocks
    BlockBrowse.fParentIndex      := NempSettingsManager.ReadInteger('FormBuilder', 'BlockBrowseParent'      , 0);
    BlockBrowse.fSortIndex        := NempSettingsManager.ReadInteger('FormBuilder', 'BlockBrowseSort'        , 0);
    BlockBrowse.fRatio            := NempSettingsManager.ReadInteger('FormBuilder', 'BlockBrowseRatio'       , 50);

    BlockPlaylist.fParentIndex    := NempSettingsManager.ReadInteger('FormBuilder', 'BlockPlaylistParent'    , 1);
    BlockPlaylist.fSortIndex      := NempSettingsManager.ReadInteger('FormBuilder', 'BlockPlaylistSort'      , 0);
    BlockPlaylist.fRatio          := NempSettingsManager.ReadInteger('FormBuilder', 'BlockPlaylistRatio'     , 50);

    BlockMediaList.fParentIndex   := NempSettingsManager.ReadInteger('FormBuilder', 'BlockMediaListParent'   , 0);
    BlockMediaList.fSortIndex     := NempSettingsManager.ReadInteger('FormBuilder', 'BlockMediaListSort'     , 1);
    BlockMediaList.fRatio         := NempSettingsManager.ReadInteger('FormBuilder', 'BlockMediaListRatio'    , 70);

    BlockFileOverview.fParentIndex:= NempSettingsManager.ReadInteger('FormBuilder', 'BlockFileOverviewParent', 1);
    BlockFileOverview.fSortIndex  := NempSettingsManager.ReadInteger('FormBuilder', 'BlockFileOverviewSort'  , 1);
    BlockFileOverview.fRatio      := NempSettingsManager.ReadInteger('FormBuilder', 'BlockFileOverviewRatio' , 30);

    // main Ratio and some special ratios
    TopPanelRatio          := NempSettingsManager.ReadInteger('FormBuilder', 'RatioTopPanel'         , 60);
    BrowseArtistRatio      := NempSettingsManager.ReadInteger('FormBuilder', 'RatioBrowseArtist'     , 50);
    FileOverviewCoverRatio := NempSettingsManager.ReadInteger('FormBuilder', 'RatioFileOverviewCover', 50);

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


procedure TNempFormBuildOptions.SaveSettings;
var i, ControlPanelSubParentIdx: Integer;
begin

    if newLayout <> MainLayout then   // needed when we start in seprate mode and do not enter compact mode at all
        NempSettingsManager.WriteInteger('FormBuilder', 'MainLayout', Integer(newLayout))
    else
        NempSettingsManager.WriteInteger('FormBuilder', 'MainLayout', Integer(MainLayout));


    NempSettingsManager.WriteBool('FormBuilder', 'HideFileOverviewPanel', HideFileOverviewPanel);

    // settings for ControlPanel
    NempSettingsManager.WriteInteger('FormBuilder', 'ControlPanelPosition', Integer(ControlPanelPosition));
    NempSettingsManager.WriteInteger('FormBuilder', 'ControlPanelSubPosition', Integer(ControlPanelSubPosition));
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
    NempSettingsManager.WriteInteger('FormBuilder', 'ControlPanelSubParentIdx', ControlPanelSubParentIdx);

    NempSettingsManager.WriteBool('FormBuilder', 'ControlPanelTwoRows'          , ControlPanelTwoRows           );
    NempSettingsManager.WriteBool('FormBuilder', 'ControlPanelShowCover'        , ControlPanelShowCover         );
    // aIni.WriteBool('FormBuilder', 'ControlPanelShowVisualisation', ControlPanelShowVisualisation );

    // make sure the temporary index variables are set correctly
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].fParentIndex := 0;
    for i := 0 to PanelAChilds.Count - 1 do PanelAChilds[i].fSortIndex := i;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].fParentIndex := 1;
    for i := 0 to PanelBChilds.Count - 1 do PanelBChilds[i].fSortIndex := i;

    NempSettingsManager.WriteInteger('FormBuilder', 'BlockBrowseParent'      , BlockBrowse.fParentIndex);
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockBrowseSort'        , BlockBrowse.fSortIndex  );
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockBrowseRatio'       , BlockBrowse.fRatio      );

    NempSettingsManager.WriteInteger('FormBuilder', 'BlockPlaylistParent'    , BlockPlaylist.fParentIndex );
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockPlaylistSort'      , BlockPlaylist.fSortIndex   );
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockPlaylistRatio'     , BlockPlaylist.fRatio       );

    NempSettingsManager.WriteInteger('FormBuilder', 'BlockMediaListParent'   , BlockMediaList.fParentIndex);
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockMediaListSort'     , BlockMediaList.fSortIndex  );
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockMediaListRatio'    , BlockMediaList.fRatio      );

    NempSettingsManager.WriteInteger('FormBuilder', 'BlockFileOverviewParent', BlockFileOverview.fParentIndex);
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockFileOverviewSort'  , BlockFileOverview.fSortIndex  );
    NempSettingsManager.WriteInteger('FormBuilder', 'BlockFileOverviewRatio' , BlockFileOverview.fRatio      );

    // main Ratio and some special ratios
    NempSettingsManager.WriteInteger('FormBuilder', 'RatioBrowseArtist'     , BrowseArtistRatio     );
    NempSettingsManager.WriteInteger('FormBuilder', 'RatioFileOverviewCover', FileOverviewCoverRatio);
    NempSettingsManager.WriteInteger('FormBuilder', 'RatioTopPanel'         , TopPanelRatio         );

    // delete deprecated windows section, replaced by section [NempForms]
    if NempSettingsManager.SectionExists('Windows') then
      NempSettingsManager.EraseSection('Windows');
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
  ShowSplashScreen := NempSettingsManager.ReadBool('Allgemein', 'ShowSplashScreen', True);

  AutoCloseProgressWindow := NempSettingsManager.ReadBool('Allgemein', 'AutoCloseProgressWindow', False);
  StartMinimized          := NempSettingsManager.ReadBool('Allgemein', 'StartMinimized', False);
  AllowOnlyOneInstance    := NempSettingsManager.ReadBool('Allgemein', 'AllowOnlyOneInstance', True);

  TabStopAtPlayerControls := NempSettingsManager.ReadBool('Allgemein', 'TabStopAtPlayerControls', True);
  TabStopAtTabs := NempSettingsManager.ReadBool('Allgemein', 'TabStopAtTabs', True);
  VSTDetailsLock:= NempSettingsManager.ReadInteger('Allgemein', 'VSTDetailsLock', 0);

  DisplayApp    := NempSettingsManager.ReadString('Allgemein', 'DisplayApp', 'NempG15App.exe');
  DisplayApp    := Stringreplace(DisplayApp, '\', '', [rfReplaceAll]);
  UseDisplayApp := NempSettingsManager.ReadBool('Allgemein', 'UseDisplayApp', false);

  AllowQuickAccessToMetadata := NempSettingsManager.ReadBool('Allgemein', 'AllowQuickAccessToMetadata', False);
  UseCDDB                    := NempSettingsManager.ReadBool('Allgemein', 'UseCDDB', False);

  MiniNempStayOnTop := NempSettingsManager.ReadBool('Allgemein', 'MiniNempStayOnTop', False);
  DetailFormStayOnTop := NempSettingsManager.ReadBool('Allgemein', 'DetailFormStayOnTop', False);
  // FixCoverFlowOnStart := NempSettingsManager.ReadBool('Allgemein', 'FixCoverFlowOnStart', False);

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

  NempWindowView          := NempSettingsManager.ReadInteger('Fenster', 'NempWindowView', NEMPWINDOW_ONLYTASKBAR);
  ShowDeskbandOnMinimize  := NempSettingsManager.ReadBool('Fenster', 'ShowDeskbandOnMinimize', False);
  ShowDeskbandOnStart     := NempSettingsManager.ReadBool('Fenster', 'ShowDeskbandOnStart', True);
  HideDeskbandOnRestore   := NempSettingsManager.ReadBool('Fenster', 'HideDeskbandOnRestore', False);
  HideDeskbandOnClose     := NempSettingsManager.ReadBool('Fenster', 'HideDeskbandOnClose', True);

  FullRowSelect := NempSettingsManager.ReadBool('Fenster', 'FullRowSelect', True);

  ArtistAlbenFontSize  := NempSettingsManager.ReadInteger('Font','ArtistAlbenFontSize',8);
  ArtistAlbenRowHeight := NempSettingsManager.ReadInteger('Font','ArtistAlbenRowHeight',14);
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
  SkinName := NempSettingsManager.ReadString('Fenster','SkinName','<public> Dark');
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
  NempSettingsManager.WriteBool('Allgemein', 'UseCDDB', UseCDDB);

  NempSettingsManager.WriteBool('Allgemein', 'MiniNempStayOnTop', MiniNempStayOnTop);
  NempSettingsManager.WriteBool('Allgemein', 'DetailFormStayOnTop', DetailFormStayOnTop);
  // NempSettingsManager.WriteBool('Allgemein', 'FixCoverFlowOnStart', FixCoverFlowOnStart);

  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownModeIniIdx'    , ShutDownModeIniIdx    );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniIdx'    , ShutDownTimeIniIdx    );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniHours'  , ShutDownTimeIniHours  );
  NempSettingsManager.WriteInteger('Allgemein',  'ShutDownTimeIniMinutes', ShutDownTimeIniMinutes);

  NempSettingsManager.WriteString('Allgemein', 'Language', Language);
  NempSettingsManager.WriteInteger('Allgemein', 'maxDragFileCount', maxDragFileCount);

  NempSettingsManager.WriteInteger('Fenster', 'Anzeigemode', AnzeigeMode);
  NempSettingsManager.WriteBool('Fenster', 'UseSkin', UseSkin);
  NempSettingsManager.WriteString('Fenster','SkinName', SkinName);
  NempSettingsManager.WriteBool('Fenster', 'UseAdvancedSkin', GlobalUseAdvancedSkin);

  NempSettingsManager.WriteInteger('Fenster', 'NempWindowView', NempWindowView);
  NempSettingsManager.WriteBool('Fenster', 'ShowDeskbandOnMinimize', ShowDeskbandOnMinimize);
  NempSettingsManager.WriteBool('Fenster', 'ShowDeskbandOnStart', ShowDeskbandOnStart);
  NempSettingsManager.WriteBool('Fenster', 'HideDeskbandOnRestore', HideDeskbandOnRestore);
  NempSettingsManager.WriteBool('Fenster', 'HideDeskbandOnClose', HideDeskbandOnClose);
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
  fNempFormBuildOptions := Nil;

finalization
  if assigned(fNempOptions) then
    fNempOptions.Free;

  if assigned(fNempSettingsManager) then
    fNempSettingsManager.Free;

  if assigned(fNempFormBuildOptions) then
    fNempFormBuildOptions.Free;


end.


