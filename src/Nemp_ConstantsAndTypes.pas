{

    Unit Nemp_ConstantsAndTypes

    - Some Constants and types used in Nemp
      e.g. Records, Messages

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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
     SysUtils, Contnrs, ShellApi, VirtualTrees,  Hilfsfunktionen;


type

    TAudioFileStringIndex = (siArtist, siAlbum, siOrdner, siGenre, siJahr, siFileAge, siDateiname);

    TDefaultCoverType = (dcAllFiles, dcWebRadio, dcNoCover, dcError);

    TNempSortArray = Array[1..2] of TAudioFileStringIndex;

    TSpalte = record
      Bezeichnung: string;
      Inhalt: integer;
      visible: boolean;
      width: integer;
      sortAscending: boolean;
    end;

    TNempMainFormRatios = record
      VSTHeight: Integer;
      BrowseWidth: Integer;
      ArtistWidth: Integer;

      VSTWidth: Integer;
      VDTCoverWidth: Integer;
      VDTCoverHeight: Integer;

    end;

    // Das speichert die Aufteilung der Form
    // Im Programm findet man dann ein Array dieses Typs,
    // für jeden Anzeigemodus eins.
    TNempFormAufteilung = record
      FormTop: integer;
      FormLeft: integer;
      FormHeight: integer;
      FormWidth: integer;
      TopMainPanelHeight: integer;
      AuswahlPanelWidth: integer;
      ArtistWidth: integer;
      FormMinHeight: integer;
      FormMaxHeight: integer;
      FormMinWidth: integer;
      FormMaxWidth: integer;
      Maximized: boolean;
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

    TNempEinzelFormOptions = record
      PlaylistVisible: Boolean;
      MedienlisteVisible: Boolean;
      AuswahlSucheVisible: Boolean;
      ErweiterteControlsVisible: Boolean;

      PlaylistDocked: Boolean;
      MedienlisteDocked: Boolean;
      AuswahlListeDocked: Boolean;
      ExtendedControlsDocked: Boolean;

      PlaylistTop: Integer;
      PlaylistLeft: Integer;
      PlaylistHeight: Integer;
      PlaylistWidth: Integer;

      MedienlisteTop: Integer;
      MedienlisteLeft: Integer;
      MedienlisteHeight: Integer;
      MedienlisteWidth: Integer;

      AuswahlSucheTop: Integer;
      AuswahlSucheLeft: Integer;
      AuswahlSucheHeight: Integer;
      AuswahlSucheWidth: Integer;

      ExtendedControlsTop: Integer;
      ExtendedControlsLeft: Integer;
      ExtendedControlsHeight: Integer;
      ExtendedControlsWidth: Integer;

    end;

    TNempOptions = record
        // etaws Kleinkram und allgemeine Optionen
        //DenyID3Edit: Boolean;
        AllowOnlyOneInstance: Boolean;
        RegisterHotKeys: Boolean;
        IgnoreVolumeUpDownKeys: Boolean;
        RegisterMediaHotkeys: Boolean;


        TabStopAtPlayerControls: Boolean;
        TabStopAtTabs: Boolean;

        DisplayApp: String;


        MiniNempStayOnTop: Boolean;
        FullRowSelect: Boolean;
        EditOnClick: Boolean;
        TippSpeed: Integer;
        NempFormAufteilung: Array [0..1] of TNempFormAufteilung;
        NempFormRatios: TNempMainFormRatios;
        NempEinzelFormOptions: TNempEinzelFormOptions; // Optionen für die Einzelformen
        NempWindowView: Word;
        StartMinimized: Boolean;
        StartMinimizedByParameter: Boolean;
        FixCoverFlowOnStart: Boolean;

        //Sprache
        Language: String;

        ShutDownMode: Integer;
        ShutDownTime: TDateTime;
        ShutDownAtEndOfPlaylist: Boolean;

        // Optionen für die Darstellung der Playliste/Medienliste
        // MinFontColor: TColor;          // not editable in Nemp 4.0 any longer
        // MaxFontColor: TColor;
        // MiddleFontColor: TColor;
        // MiddleToMinComputing: Byte;
        // MiddleToMaxComputing: Byte;
        MaxDauer: Array[1..4] of Integer;
        FontSize: Array[1..5] of Integer;
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
        CoverMode: Integer;
        DetailMode: Integer;
        CoverWidth: Integer;

        ReplaceNAArtistBy  : Integer;
        ReplaceNATitleBy   : Integer;
        ReplaceNAAlbumBy   : Integer;


        WriteAccessPossible: Boolean;

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

        // "Die letzten 10"
        RecentPlaylists: Array[1..10] of UnicodeString;

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
    MP3DB_VERSION_OLD: Byte = 3;    // Dateiformat 2.5 - 3.0
    MP3DB_SUBVERSION_Old: Byte = 1; // Format 3.1 seit Nemp 2.5x3, bzw. seit Nemp3.0 ;-)
    
    MP3DB_VERSION: Byte = 4;        // Dateiformat seit 3.1
    MP3DB_SUBVERSION: Byte = 1;     // subversion changed to 1 in Nemp 4.0

    // "Extended Boolean", used for "unset" settings
    BoolUnDef = 0;
    BoolTrue = 1;
    BoolFalse = 2;

    //-------------
    // Zeug für die Anzeige:
    NEMP_NAME = 'Nemp'; // Bezeichnung der ini-Datei
    NEMP_CAPTION = 'Nemp - Noch ein MP3-Player';
    NEMP_NAME_TASK_LONG = '[ N e m p ]';
    NEMP_NAME_TASK = '[Nemp]';
    NEMP_VERSION_SPLASH = 'v4.1';// 'v3.3';

    NEMP_TIPSIZE = 128;

    BROWSE_PLAYLISTS =     '!!{A8F4183D-C8FE-4585-A6C6-36FCC402143D}';
    BROWSE_RADIOSTATIONS = '!!{B3723948-3015-4E60-8727-4AC7663CE7A5}';
    BROWSE_ALL =           '!!{F7B03349-5B91-4025-B439-EAF46875717B}';

    //ALL_ALBUMS = '{6388E9C0-F52B-4D3D-B958-8A87EFDD84B8}';

    // Höhe der Cover/EQ/Lyrics/Effekte-Box
    //EXTENDED_HEIGHT = 218;
    // Minimale Höhe des oberen teils:
    TOP_MIN_HEIGHT = 323;//311///426;

    MAX_DRAGFILECOUNT = 500;

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

    MB_ProgressRefresh = 11;
    MB_ProgressRefreshJustProgressbar = 30;
    //MB_SearchAutoAbort = 12;
    // Show search results. lParam contains a Pointer to the result-list
    MB_ShowSearchResults = 13;
    // Show Quicksearch-results
    // Two Steps: Results from "QuickSearchList" and "Additional results"
    MB_GetQuickSearchResults = 25;
    MB_GetAdditionalQuickSearchResults = 26;
    MB_ShowQuickSearchResults  = 27;


    MB_DeadFilesWarning = 14;
    // Warnung: Duplikate in der Bib gefunden. Das sollte eigentlich nicht mehr vorkommen
    MB_DuplicateWarning = 15;
    // AutScan der Ordner starten
    MB_StartAutoScanDirs = 16;
    // WebServer automatisch starten
    MB_ActivateWebServer = 21;
    // Suche nach toten Dateien
    MB_ProgressSearchDead = 17;
    // Lyrics, send Status complete/failed
    MB_LyricUpdateStatus = 18;
    // same for Tags
    MB_TagsUpdateStatus = 28;
    // Lyrics/PostProcessor: Send the filename which is currently edited by a thread
    MB_ThreadFileUpdate = 23;
    // Refresh AudioFile: GetAudiodata in VCL-Thread, as Cover-stuff will create some
    // Exceptions in secondary threads.
    MB_RefreshAudioFile = 24;

    // Exception im Thread - wahrscheinlich keine Internetverbindung.
    MB_LyricUpdateFailed = 19;
    // Liste abgearbeitet
    MB_LyricUpdateComplete = 20;

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

    //SEARCH_SIMPLE = 0;
    SEARCH_EXTENDED = 1;
    //SEARCH_LYRICs = 2;

    Spaltenzahl = 22;
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
    CON_RATING    = 17;
    CON_PLAYCOUNTER = 18;
    CON_LASTFMTAGS = 19;
    CON_EXTENSION = 20;
    CON_FILEAGE = 21;
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

    // Konstanten für die Indizes in der Buttons16ImageList. Da ändert sich ja ab und zu etwas,
    // und die Bilder müssen zur Laufzeit gesetzt werden. Mit den Konstanten wird das hoffentlich leichter wartbar sein.
    BTNIDX_SlideBack = 0;
    BTNIDX_Previous = 1;
    BTNIDX_Play = 2;
    BTNIDX_Pause = 3;
    BTNIDX_Stop = 4; // <--------
    BTNIDX_StopDown = 5;

    BTNIDX_Next = 6;
    BTNIDX_SlideForward = 7;

    BTNIDX_RepeatAll = 8;
//    BTNIDX_RepeatTitle = 9;
//    BTNIDX_Random = 10;  // <-----------
//    BTNIDX_NoRepeat = 11;

    BTNIDX_Reverse = 12;
    BTNIDX_Forward = 13;

    BTNIDX_RecordInActive = 14;
    BTNIDX_RecordActive = 15;

    BTNIDX_Minimize = 15;  // = BTNIDX_RecordActive !!
    BTNIDX_Close = 16;
    BTNIDX_Menu = 17;

    BTNIDX_Max = 14; // = BTNIDX_RecordInActive !!

    sepchar: char=';';



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

      DefaultSpalten : array[0..21] of TSpalte =
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
        (Bezeichnung: 'Fileage' ;Inhalt: CON_FILEAGE       ;visible: false  ;width: 80;sortAscending: True)
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

      IPC_PLAYFILE    = 100;
      IPC_ENQUEUEFILE = 100;

      IPC_ISPLAYING  = 104;
      IPC_GETOUTPUTTIME = 105;
      IPC_JUMPTOTIME = 106;

      IPC_SETPLAYLISTPOS = 121; //??

      IPC_SETVOLUME  = 122;
      IPC_GETLISTLENGTH  = 124;
      IPC_GETLISTPOS  = 125;

      IPC_GETINFO = 126;
      IPC_GETEQDATA = 127;
      IPC_SETEQDATA = 128;

      //Nemp-Spezifisch. Gibts nicht bei Winamp


             ID_Time   = 301;
             ID_Volume = 302;
             ID_EQ     = 303;
             ID_REVERB = 304;
             ID_ECHO   = 305; // Time und Mix hintereinander
             ID_SPEED  = 306;
    // Aktuelle Zeit im Titel ??
    // Volume
    // 10x Equalizer
    // Reverb
    // EchoMix
    // EchoTime
    // Speed

      IPC_GETREVERB = 42001;           // Value zwischen -96..0
      IPC_SETREVERB = 42002;
      IPC_GETECHOTIME = 42003;         //100...2000
      IPC_SETECHOTIME = 42004;
      IPC_GETECHOMIX = 42005;          //0..50
      IPC_SETECHOMIX = 42006;
      IPC_GETSPEED = 42007;           // 67..133
      IPC_SETSPEED = 42008;
      //---------------
      //Suchanfragen
      IPC_QUERY_SEARCHSTATUS = 42009;
      IPC_SEND_SEARCHSTRING = 42010;
      IPC_SEND_FILEFORPLAYLIST = 42040;
      //
      IPC_SEND_SEARCHSTRING_W = 52010;
      IPC_SEND_FILEFORPLAYLIST_W = 52040;

      IPC_GETSEARCHLISTLENGTH  = 42124;
      IPC_GETSEARCHLISTFILE  = 42211;
      IPC_GETSEARCHLISTTITLE = 42212;

      //Hinweis: XXXTITLE Liefert "Artist - Titel"
      //         XXXTITLEONLY nur "Titel"
      // Details zu Playlist/Searchlist
      IPC_GETPLAYLISTARTIST     = 42213;
      IPC_GETPLAYLISTALBUM      = 42214;
      IPC_GETPLAYLISTTITLEONLY  = 42215;

      IPC_GETSEARCHLISTARTIST    = 42216;
      IPC_GETSEARCHLISTALBUM     = 42217;
      IPC_GETSEARCHLISTTITLEONLY = 42218;

      //
      IPC_GETPLAYLISTFILE_W   = 51211;
      IPC_GETPLAYLISTTITLE_W  = 51212;

      IPC_GETSEARCHLISTFILE_W  = 52211;
      IPC_GETSEARCHLISTTITLE_W = 52212;
      // Details zu Playlist/Searchlist
      IPC_GETPLAYLISTARTIST_W     = 52213;
      IPC_GETPLAYLISTALBUM_W      = 52214;
      IPC_GETPLAYLISTTITLEONLY_W  = 52215;
      IPC_GETSEARCHLISTARTIST_W    = 52216;
      IPC_GETSEARCHLISTALBUM_W     = 52217;
      IPC_GETSEARCHLISTTITLEONLY_W = 52218;

      // Anfrage zum Cover:
      IPC_QUERYCOVER = 52400;
      IPC_SENDCOVER = 52401;

      // Unterschied zu GetOutputTime: Im Parameter kommt der Trackindex, nicht ein Flag für Dauer/Pos
      IPC_GETPLAYLISTTRACKLENGTH = 42219;
      IPC_GETSEARCHLISTTRACKLENGTH = 42220;

      IPC_GETVOLUME = 42221;

      COMMAND_RESTORE = 43001;

      //----------------------------------------

      IPC_GETPLAYLISTFILE  = 211;
      IPC_GETPLAYLISTTITLE = 212;

      IPC_GET_SHUFFLE  = 250;
      IPC_GET_REPEAT  = 251;
      IPC_SET_SHUFFLE = 252;

      NEMP_API_STOPPED = 0;
      NEMP_API_PLAYING = 1;
      NEMP_API_PAUSED = 3;
      NEMP_API_REPEATALL = 0;
      NEMP_API_REPEATTITEL = 1;
      NEMP_API_SHUFFLE = 2;
      NEMP_API_NOREPEAT = 3;

      cmNoStretch = 1;
      // Note: These 3 Flags has been used in Nemp3
      // They are still used in the Code, but has no effect after all
      cmUseBibDefaults = 2;
      cmUseDefaultCover = 4;
      cmCustomizeMainCover= 8;


      // For starting VST
      WM_STARTEDITING = WM_User + 778;

      // Some Constants for Initializing the library.
      // On Nemp Start, several thing may be done automatically in Threads,
      // i.e. AutoScanDirs for new files and AutoActivate WebServer
      // We need to know, which part of Startup is already done, this is stored in Bib.Initializing
      init_nothing = 0;
      init_AutoScanDir = 1;
      init_Complete = 2;



      NEMP_DESKBAND_ACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Activate'#0;
      NEMP_DESKBAND_DEACTIVATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Deactivate'#0;
      NEMP_DESKBAND_UPDATE: array [0..MAX_PATH] of Char = 'NEMP - Deskband Update'#0;

      VORBIS_COMMENT = 'COMMENT';
      VORBIS_LYRICS = 'UNSYNCEDLYRICS';
      VORBIS_RATING = 'RATING';
      VORBIS_PLAYCOUNT = 'PLAYCOUNT';
      VORBIS_CATEGORIES = 'CATEGORIES';


var

  NempDeskbandActivateMessage: UINT = 0;
  NempDeskbandDeActivateMessage: UINT = 0;
  NempDeskbandUpdateMessage: UINT = 0;





procedure ReadNempOptions(ini: TMemIniFile; var Options: TNempOptions);
procedure WriteNempOptions(ini: TMemIniFile; var Options: TNempOptions);
procedure UnInstallHotKeys(Handle: HWND);
procedure UninstallMediakeyHotkeys(Handle: HWND);

procedure InstallHotkeys(aIniPath: UnicodeString; Handle: HWND);
procedure InstallMediakeyHotkeys(IgnoreVolume: Boolean; Handle: HWND);


function GetDefaultEqualizerIndex(aEQSettingsName: String): Integer;


implementation

uses PlaylistUnit, MedienListeUnit, AuswahlUnit, ExtendedControlsUnit;

procedure ReadNempOptions(ini: TMemIniFile; var Options: TNempOptions);
var i: integer;
    tmp: String;

      procedure CheckValue(var x: Integer; minValue, maxValue: Integer);
      begin
          if x < minValue then
              x := minValue;
          if x > maxValue then
              x := maxValue;
      end;

begin
  With Options do
  begin
        //DenyID3Edit     := ini.ReadBool('Allgemein','DenyID3Edit',False);
        StartMinimized       := ini.ReadBool('Allgemein', 'StartMinimized', False);
        AllowOnlyOneInstance := ini.ReadBool('Allgemein', 'AllowOnlyOneInstance', True);
        RegisterHotKeys      := ini.ReadBool('Allgemein', 'RegisterHotKeys', True);
        RegisterMediaHotkeys := ini.ReadBool('Allgemein', 'RegisterMediaHotkeys', True);
        IgnoreVolumeUpDownKeys  := ini.ReadBool('Allgemein', 'IgnoreVolumeUpDownKeys', True);
        TabStopAtPlayerControls := ini.ReadBool('Allgemein', 'TabStopAtPlayerControls', True);
        TabStopAtTabs := ini.ReadBool('Allgemein', 'TabStopAtTabs', False);

        DisplayApp := Ini.ReadString('Allgemein', 'DisplayApp', '');
        // "Kill" relative Paths
        DisplayApp := Stringreplace(DisplayApp, '\', '', [rfReplaceAll]);

        MiniNempStayOnTop := ini.ReadBool('Allgemein', 'MiniNempStayOnTop', False);
        FixCoverFlowOnStart := ini.ReadBool('Allgemein', 'FixCoverFlowOnStart', False);

                  //ShutdownMode := Ini.ReadInteger('Allgemein', 'ShutDownMode', SHUTDOWNMODE_Shutdown);
        // ShutDownAtEndOfPlaylist initialisieren
        ShutDownAtEndOfPlaylist := False;
        Language := Ini.ReadString('Allgemein', 'Language', '');

        NempFormAufteilung[0].FormTop            := ini.ReadInteger('Fenster', 'Top_0'                ,0  );
        NempFormAufteilung[0].FormLeft           := ini.ReadInteger('Fenster', 'Left_0'               ,0  );
        NempFormAufteilung[0].FormWidth          := ini.ReadInteger('Fenster', 'Width_0'              ,800);
        NempFormAufteilung[0].FormHeight         := ini.ReadInteger('Fenster', 'Height_0'             ,800);
        NempFormAufteilung[0].TopMainPanelHeight := ini.ReadInteger('Fenster', 'Splitter1_0'          ,350);
        NempFormAufteilung[0].AuswahlPanelWidth  := ini.ReadInteger('Fenster', 'BrowseListenWeite_0'  ,320);
        NempFormAufteilung[0].ArtistWidth        := ini.ReadInteger('Fenster', 'ArtisListenWeite_0'   ,160);
        NempFormAufteilung[0].Maximized          := ini.ReadBool('Fenster', 'maximiert_0',False);

        NempFormAufteilung[1].FormTop            := ini.ReadInteger('Fenster', 'Top_1'                ,-10);
        NempFormAufteilung[1].FormLeft           := ini.ReadInteger('Fenster', 'Left_1'               ,336);
        NempFormAufteilung[1].FormWidth          := 234 + 2 * GetSystemMetrics(SM_CXFrame);
        NempFormAufteilung[1].FormHeight         := 560;
        NempFormAufteilung[1].TopMainPanelHeight := 430;//370;//ini.ReadInteger('Fenster', 'Splitter1_1'          ,350);//391;
        NempFormAufteilung[1].AuswahlPanelWidth  := ini.ReadInteger('Fenster', 'BrowseListenWeite_1'  ,320);//303;
        NempFormAufteilung[1].ArtistWidth        := ini.ReadInteger('Fenster', 'ArtisListenWeite_1'   ,160);//73;
        NempFormAufteilung[1].Maximized := False;

        NempFormRatios.VSTHeight      := Ini.ReadInteger('Fenster', 'VSTHeight'      , 50);
        NempFormRatios.BrowseWidth    := Ini.ReadInteger('Fenster', 'BrowseWidth'    , 50);
        NempFormRatios.VSTWidth       := Ini.ReadInteger('Fenster', 'VSTWidth'       , 30);
        NempFormRatios.VDTCoverWidth  := Ini.ReadInteger('Fenster', 'VDTCoverWidth'  , 50);
        NempFormRatios.VDTCoverHeight := Ini.ReadInteger('Fenster', 'VDTCoverHeight' , 20);
        NempFormRatios.ArtistWidth    := Ini.ReadInteger('Fenster', 'ArtistWidth'    , 50);

        CheckValue(NempFormRatios.VSTHeight     , 10, 90);
        CheckValue(NempFormRatios.BrowseWidth   , 10, 90);
        CheckValue(NempFormRatios.VSTWidth      , 10, 90);
        CheckValue(NempFormRatios.VDTCoverWidth , 10, 90);
        CheckValue(NempFormRatios.VDTCoverHeight, 10, 90);
        CheckValue(NempFormRatios.ArtistWidth   , 10, 90);

        NempEinzelFormOptions.PlaylistVisible           := ini.ReadBool('EinzelFenster','PlaylistVisible'   , True);
        NempEinzelFormOptions.MedienlisteVisible        := ini.ReadBool('EinzelFenster','MedienlisteVisible', True);
        NempEinzelFormOptions.AuswahlSucheVisible       := ini.ReadBool('EinzelFenster','AuswahlVisible'    , True);
        NempEinzelFormOptions.ErweiterteControlsVisible := ini.ReadBool('EinzelFenster','ControlsVisible'   , True);

        NempEinzelFormOptions.PlaylistDocked      := ini.ReadBool('EinzelFenster','PlaylistDocked'    , False);
        NempEinzelFormOptions.MedienlisteDocked   := ini.ReadBool('EinzelFenster','MedienlisteDocked' , False);
        NempEinzelFormOptions.AuswahlListeDocked  := ini.ReadBool('EinzelFenster','AuswahlListeDocked', False);
        NempEinzelFormOptions.ExtendedControlsDocked := ini.ReadBool('EinzelFenster','ExtendedControlsDocked', False);

        NempEinzelFormOptions.ExtendedControlsTop  := Ini.ReadInteger('Einzelfenster', 'ExtendedControlsTop'   , 166);
        NempEinzelFormOptions.ExtendedControlsLeft := Ini.ReadInteger('Einzelfenster', 'ExtendedControlsLeft'  , 346);


        NempEinzelFormOptions.PlaylistTop    := Ini.ReadInteger('Einzelfenster', 'PlaylistTop'   , 23);
        NempEinzelFormOptions.PlaylistLeft   := Ini.ReadInteger('Einzelfenster', 'PlaylistLeft'  , 597);
        NempEinzelFormOptions.PlaylistHeight := Ini.ReadInteger('Einzelfenster', 'PlaylistHeight', 391);
        NempEinzelFormOptions.PlaylistWidth  := Ini.ReadInteger('Einzelfenster', 'PlaylistWidth' , 254);

        NempEinzelFormOptions.MedienlisteTop    := Ini.ReadInteger('Einzelfenster', 'MedienlisteTop'   , 428);
        NempEinzelFormOptions.MedienlisteLeft   := Ini.ReadInteger('Einzelfenster', 'MedienlisteLeft'  , 16);
        NempEinzelFormOptions.MedienlisteHeight := Ini.ReadInteger('Einzelfenster', 'MedienlisteHeight', 205);
        NempEinzelFormOptions.MedienlisteWidth  := Ini.ReadInteger('Einzelfenster', 'MedienlisteWidth' , 836);

        NempEinzelFormOptions.AuswahlSucheTop    := Ini.ReadInteger('Einzelfenster', 'AuswahlSucheTop'   , 22);
        NempEinzelFormOptions.AuswahlSucheLeft   := Ini.ReadInteger('Einzelfenster', 'AuswahlSucheLeft'  , 18);
        NempEinzelFormOptions.AuswahlSucheHeight := Ini.ReadInteger('Einzelfenster', 'AuswahlSucheHeight', 391);
        NempEinzelFormOptions.AuswahlSucheWidth  := Ini.ReadInteger('Einzelfenster', 'AuswahlSucheWidth' , 303);

        NempFormAufteilung[0].FormMinHeight := 600;
        NempFormAufteilung[0].FormMaxHeight := 0;
        NempFormAufteilung[0].FormMinWidth  := 800;
        NempFormAufteilung[0].FormMaxWidth  := 0;

        NempFormAufteilung[1].FormMinHeight := 0;
        NempFormAufteilung[1].FormMaxHeight := 0;
        NempFormAufteilung[1].FormMinWidth  := 0;
        NempFormAufteilung[1].FormMaxWidth  := 0;

        NempWindowView       := ini.ReadInteger('Fenster', 'NempWindowView', NEMPWINDOW_ONLYTASKBAR);
        ShowDeskbandOnMinimize  := ini.ReadBool('Fenster', 'ShowDeskbandOnMinimize', False);
        ShowDeskbandOnStart     := ini.ReadBool('Fenster', 'ShowDeskbandOnStart', True);
        HideDeskbandOnRestore   := ini.ReadBool('Fenster', 'HideDeskbandOnRestore', False);
        HideDeskbandOnClose     := ini.ReadBool('Fenster', 'HideDeskbandOnClose', True);

        FullRowSelect := ini.ReadBool('Fenster', 'FullRowSelect', True);
        EditOnClick   := ini.ReadBool('Fenster', 'EditOnClick', True);

        CoverMode := ini.ReadInteger('Fenster', 'CoverMode', 2);
        if not CoverMode in [0,1,2] then CoverMode := 1;
        CoverWidth := ini.ReadInteger('Fenster', 'CoverWidth', 240);
        if (CoverWidth < 0) or (CoverWidth > 600) then CoverWidth := 450;
        DetailMode := ini.ReadInteger('Fenster', 'DetailMode', 1);
        if not DetailMode in [0,1,2] then DetailMode := 1;

        ReplaceNAArtistBy := ini.ReadInteger('Fenster', 'ReplaceNAArtistBy', 3);
        if not ReplaceNAArtistBy in [0,1,2,3,4,5] then ReplaceNAArtistBy := 3;
        ReplaceNATitleBy  := ini.ReadInteger('Fenster', 'ReplaceNATitleBy' , 2);
        if not ReplaceNATitleBy in [0,1,2,3,4,5] then ReplaceNATitleBy := 2;
        ReplaceNAAlbumBy  := ini.ReadInteger('Fenster', 'ReplaceNAAlbumBy' , 4);
        if not ReplaceNAAlbumBy in [0,1,2,3,4,5] then ReplaceNAAlbumBy := 4;

        ArtistAlbenFontSize  := ini.ReadInteger('Font','ArtistAlbenFontSize',8);
        ArtistAlbenRowHeight := ini.ReadInteger('Font','ArtistAlbenRowHeight',14);
        RowHeight   := Ini.ReadInteger('Font', 'RowHeight', 16 );
        DefaultFontSize := ini.ReadInteger('Font','DefaultFontSize',8);
        ChangeFontColorOnBitrate := ini.ReadBool('Font','ChangeFontColorOnBitrate',True);
        ChangeFontSizeOnLength := ini.ReadBool('Font','ChangeFontSizeOnLength',False);

        //MinFontColor   := StringToColor(Ini.ReadString('Font','MinColor'   , 'clred'   ));
        //MiddleFontColor:= StringToColor(Ini.ReadString('Font','MiddleColor', 'clblack'   ));
        //MaxFontColor   := StringToColor(Ini.ReadString('Font','MaxColor'   , 'clgreen'   ));
        //MiddleToMinComputing := Ini.ReadInteger('Font', 'MiddleToMinComputing', 2);
        //MiddleToMaxComputing := Ini.ReadInteger('Font', 'MiddleToMaxComputing', 2);

        MaxDauer[1] := Ini.ReadInteger('Font', 'Maxdauer1',  59);
        MaxDauer[2] := Ini.ReadInteger('Font', 'Maxdauer2', 149);
        MaxDauer[3] := Ini.ReadInteger('Font', 'Maxdauer3', 359);
        MaxDauer[4] := Ini.ReadInteger('Font', 'Maxdauer4', 899);
        FontSize[1] := Ini.ReadInteger('Font', 'FontSize1', 6  );
        FontSize[2] := Ini.ReadInteger('Font', 'FontSize2', 6  );
        FontSize[3] := Ini.ReadInteger('Font', 'FontSize3', 8  );
        FontSize[4] := Ini.ReadInteger('Font', 'FontSize4', 10 );
        FontSize[5] := Ini.ReadInteger('Font', 'FontSize5', 12 );

        ChangeFontStyleOnMode := ini.ReadBool('Font','ChangeFontStyleOnMode',True);
        ChangeFontOnCbrVbr := ini.ReadBool('Font','ChangeFontOnCbrVbr',False);
        FontNameVBR := ini.ReadString('Font','FontNameVBR','Tahoma');
        FontNameCBR := ini.ReadString('Font','FontNameCBR','Courier');

        for i := 1 to 10 do
          RecentPlaylists[i] := Ini.ReadString('RecentPlaylists', 'Playlist'+ IntToStr(i), '');
  end;

end;

procedure WriteNempOptions(ini: TMemIniFile; var Options: TNempOptions);
var i: integer;
begin
  With Options do
  begin
        //ini.WriteBool('Allgemein','DenyID3Edit',DenyID3Edit);
        ini.WriteBool('Allgemein', 'StartMinimized', StartMinimized);
        ini.WriteBool('Allgemein', 'AllowOnlyOneInstance', AllowOnlyOneInstance);
        ini.WriteBool('Allgemein', 'RegisterHotKeys', RegisterHotKeys);
        ini.WriteBool('Allgemein', 'RegisterMediaHotkeys', RegisterMediaHotkeys);
        ini.WriteBool('Allgemein', 'IgnoreVolumeUpDownKeys', IgnoreVolumeUpDownKeys);
        ini.WriteBool('Allgemein', 'TabStopAtPlayerControls', TabStopAtPlayerControls);
        ini.WriteBool('Allgemein', 'TabStopAtTabs', TabStopAtTabs);

        ini.WriteBool('Allgemein', 'MiniNempStayOnTop', MiniNempStayOnTop);
        ini.WriteBool('Allgemein', 'FixCoverFlowOnStart', FixCoverFlowOnStart);

        //ini.WriteInteger('Allgemein', 'ShutDownMode', ShutDownMode);
        Ini.WriteString('Allgemein', 'Language', Language);

        ini.WriteInteger('Fenster', 'Top_0'                , NempFormAufteilung[0].FormTop           );
        ini.WriteInteger('Fenster', 'Left_0'               , NempFormAufteilung[0].FormLeft          );
        ini.WriteInteger('Fenster', 'Width_0'              , NempFormAufteilung[0].FormWidth         );
        ini.WriteInteger('Fenster', 'Height_0'             , NempFormAufteilung[0].FormHeight        );
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
        Ini.WriteInteger('Fenster', 'VDTCoverHeight' , NempFormRatios.VDTCoverHeight);
        Ini.WriteInteger('Fenster', 'ArtistWidth'    , NempFormRatios.ArtistWidth  );

        ini.WriteBool('EinzelFenster','PlaylistVisible'   , NempEinzelFormOptions.PlaylistVisible           );
        ini.WriteBool('EinzelFenster','MedienlisteVisible', NempEinzelFormOptions.MedienlisteVisible        );
        ini.WriteBool('EinzelFenster','AuswahlVisible'    , NempEinzelFormOptions.AuswahlSucheVisible       );
        ini.WriteBool('EinzelFenster','ControlsVisible'   , NempEinzelFormOptions.ErweiterteControlsVisible );

        ini.WriteBool('EinzelFenster','PlaylistDocked'    , PlaylistForm.NempRegionsDistance.docked   );
        ini.WriteBool('EinzelFenster','MedienlisteDocked' , MedienlisteForm.NempRegionsDistance.docked);
        ini.WriteBool('EinzelFenster','AuswahlListeDocked', AuswahlForm.NempRegionsDistance.docked    );
        ini.WriteBool('EinzelFenster','ExtendedControlsDocked', NempEinzelFormOptions.ExtendedControlsDocked);

        Ini.WriteInteger('Einzelfenster', 'ExtendedControlsTop'   , ExtendedControlForm.Top);
        Ini.WriteInteger('Einzelfenster', 'ExtendedControlsLeft'  , ExtendedControlForm.Left);


        Ini.WriteInteger('Einzelfenster', 'PlaylistTop'   , PlaylistForm.Top   );
        Ini.WriteInteger('Einzelfenster', 'PlaylistLeft'  , PlaylistForm.Left  );
        Ini.WriteInteger('Einzelfenster', 'PlaylistHeight', PlaylistForm.Height);
        Ini.WriteInteger('Einzelfenster', 'PlaylistWidth' , PlaylistForm.Width );

        Ini.WriteInteger('Einzelfenster', 'MedienlisteTop'   , MedienlisteForm.Top   );
        Ini.WriteInteger('Einzelfenster', 'MedienlisteLeft'  , MedienlisteForm.Left  );
        Ini.WriteInteger('Einzelfenster', 'MedienlisteHeight', MedienlisteForm.Height);
        Ini.WriteInteger('Einzelfenster', 'MedienlisteWidth' , MedienlisteForm.Width );

        Ini.WriteInteger('Einzelfenster', 'AuswahlSucheTop'   , AuswahlForm.Top   );
        Ini.WriteInteger('Einzelfenster', 'AuswahlSucheLeft'  , AuswahlForm.Left  );
        Ini.WriteInteger('Einzelfenster', 'AuswahlSucheHeight', AuswahlForm.Height);
        Ini.WriteInteger('Einzelfenster', 'AuswahlSucheWidth' , AuswahlForm.Width );

        Ini.WriteInteger('Fenster', 'NempWindowView', NempWindowView);
        ini.WriteBool('Fenster', 'ShowDeskbandOnMinimize', ShowDeskbandOnMinimize);
        ini.WriteBool('Fenster', 'ShowDeskbandOnStart', ShowDeskbandOnStart);
        ini.WriteBool('Fenster', 'HideDeskbandOnRestore', HideDeskbandOnRestore);
        ini.WriteBool('Fenster', 'HideDeskbandOnClose', HideDeskbandOnClose);
        ini.WriteBool('Fenster', 'FullRowSelect', FullRowSelect);
        ini.WriteBool('Fenster', 'EditOnClick', EditOnClick);
        ini.WriteInteger('Fenster', 'CoverMode', CoverMode);
        ini.WriteInteger('Fenster', 'CoverWidth', CoverWidth);
        ini.WriteInteger('Fenster', 'DetailMode', DetailMode);

        ini.WriteInteger('Fenster', 'ReplaceNAArtistBy', ReplaceNAArtistBy);
        ini.WriteInteger('Fenster', 'ReplaceNATitleBy' , ReplaceNATitleBy );
        ini.WriteInteger('Fenster', 'ReplaceNAAlbumBy' , ReplaceNAAlbumBy );

        ini.WriteInteger('Font','ArtistAlbenFontSize',ArtistAlbenFontSize);
        ini.WriteInteger('Font','ArtistAlbenRowHeight',ArtistAlbenRowHeight);
        Ini.WriteInteger('Font', 'RowHeight', RowHeight  );
        ini.WriteInteger('Font','DefaultFontSize',DefaultFontSize);
        ini.Writebool('Font','ChangeFontSizeOnLength',ChangeFontSizeOnLength);
        ini.Writebool('Font','ChangeFontColorOnBitrate',ChangeFontColorOnBitrate);
        Ini.WriteInteger('Font', 'Maxdauer1', MaxDauer[1]);
        Ini.WriteInteger('Font', 'Maxdauer2', MaxDauer[2]);
        Ini.WriteInteger('Font', 'Maxdauer3', MaxDauer[3]);
        Ini.WriteInteger('Font', 'Maxdauer4', MaxDauer[4]);
        Ini.WriteInteger('Font', 'FontSize1', FontSize[1]);
        Ini.WriteInteger('Font', 'FontSize2', FontSize[2]);
        Ini.WriteInteger('Font', 'FontSize3', FontSize[3]);
        Ini.WriteInteger('Font', 'FontSize4', FontSize[4]);
        Ini.WriteInteger('Font', 'FontSize5', FontSize[5]);

        //Ini.WriteString('Font','MinColor'   , '$'+InttoHex(Integer( MinFontColor ),8)  );
        //Ini.WriteString('Font','MiddleColor', '$'+InttoHex(Integer( MiddleFontColor ),8)  );
        //Ini.WriteString('Font','MaxColor'   , '$'+InttoHex(Integer( MaxFontColor ),8)  );
        //Ini.WriteInteger('Font', 'MiddleToMinComputing', MiddleToMinComputing);
        //Ini.WriteInteger('Font', 'MiddleToMaxComputing', MiddleToMaxComputing);

        ini.Writebool('Font','ChangeFontStyleOnMode',ChangeFontStyleOnMode);
        ini.Writebool('Font','ChangeFontOnCbrVbr',ChangeFontOnCbrVbr);
        ini.WriteString('Font','FontNameVBR',FontNameVBR);
        ini.WriteString('Font','FontNameCBR',FontNameCBR);

        for i := 1 to 10 do
          Ini.WriteString('RecentPlaylists', 'Playlist'+ IntToStr(i), RecentPlaylists[i]);
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

initialization
  NempDeskbandActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_ACTIVATE);
  NempDeskbandDeActivateMessage := RegisterWindowMessage(NEMP_DESKBAND_DEACTIVATE);
  NempDeskbandUpdateMessage := RegisterWindowMessage(NEMP_DESKBAND_UPDATE);

finalization
  // nothing todo


end.


