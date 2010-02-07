{

    Unit NempMainUnit
    Form Nemp_MainForm

    The MainForm of Nemp

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
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}


Unit NempMainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AudioFileClass, AudioFileHelper, ComCtrls, Grids, Contnrs, ShellApi,
  Menus, ImgList, ExtCtrls, StrUtils, Inifiles, CheckLst,
  WinampFunctions, Buttons,  VirtualTrees, VSTEditControls,
  jpeg, activeX, XPMan, DateUtils,
   Mp3FileUtils, spectrum_vis,
  Hilfsfunktionen, Systemhelper, CoverHelper, TreeHelper ,
  ComObj, ShlObj, clipbrd, Spin,  U_CharCode,
      fldbrows, MainFormHelper, MessageHelper,
  Nemp_ConstantsAndTypes, SplitForm_Hilfsfunktionen, SearchTool, mmsystem,
   Nemp_SkinSystem, NempPanel, SkinButtons, math,

  PlayerClass, PlaylistClass, MedienbibliothekClass, BibHelper, MyDialogs,
  
  gnuGettext, Nemp_RessourceStrings, languageCodes,
  OneInst, DriveRepairTools, ShoutcastUtils, WebServerClass, ScrobblerUtils,
  dwTaskbarComponents, dwTaskbarThumbnails,
  UpdateUtils, uDragFilesSrc,

  unitFlyingCow, dglOpenGL, NempCoverFlowClass, PartyModeClass, RatingCtrls, tagClouds;

type

  TNemp_MainForm = class(TNempForm)
    Splitter1: TSplitter;
    TopMainPanel: TPanel;
    PlayerPanel: TNempPanel;
    BassTimer: TTimer;
    Splitter2: TSplitter;
    Nemp_MainMenu: TMainMenu;
    MMKeyTimer: TTimer;
    PlayListImageList: TImageList;
    PlaylistPanel: TNempPanel;
    GRPBOXLyrics: TNempPanel;
    GRPBOXEffekte: TNempPanel;
    HallShape: TShape;
    HallLBL: TLabel;
    EchoWetDryMixShape: TShape;
    EchoTimeShape: TShape;
    EchoTimeLBL: TLabel;
    EchoMixLBL: TLabel;
    EffekteLBL2: TLabel;
    EffekteLBL1: TLabel;
    SampleRateShape: TShape;
    SampleRateLBL: TLabel;
    EffekteLBL3: TLabel;
    HallButton: TSkinButton;
    EchoWetDryMixButton: TSkinButton;
    EchoTimeButton: TSkinButton;
    SampleRateButton: TSkinButton;
    DirectionPositionBTN: TSkinButton;
    Btn_EffectsOff: TBitBtn;
    GRPBOXEqualizer: TNempPanel;
    EqualizerShape5: TShape;
    EqualizerShape2: TShape;
    EqualizerShape3: TShape;
    EqualizerShape4: TShape;
    EqualizerShape6: TShape;
    EqualizerShape7: TShape;
    EqualizerShape8: TShape;
    EqualizerShape9: TShape;
    EqualizerShape10: TShape;
    EQLBL1: TLabel;
    EQLBL2: TLabel;
    EQLBL3: TLabel;
    EQLBL4: TLabel;
    EQLBL5: TLabel;
    EQLBL6: TLabel;
    EQLBL7: TLabel;
    EQLBL8: TLabel;
    EQLBL9: TLabel;
    EQLBL10: TLabel;
    EqualizerShape1: TShape;
    EqualizerDefaultShape: TShape;
    EqualizerButton1: TSkinButton;
    EqualizerButton2: TSkinButton;
    EqualizerButton3: TSkinButton;
    EqualizerButton5: TSkinButton;
    EqualizerButton4: TSkinButton;
    EqualizerButton6: TSkinButton;
    EqualizerButton7: TSkinButton;
    EqualizerButton8: TSkinButton;
    EqualizerButton9: TSkinButton;
    EqualizerButton10: TSkinButton;
    Btn_EqualizerPresets: TSkinButton;
    GRPBOXArtistsAlben: TNempPanel;
    PanelStandardBrowse: TPanel;
    Splitter3: TSplitter;
    ArtistsVST: TVirtualStringTree;
    AlbenVST: TVirtualStringTree;
    AuswahlPanel: TPanel;
    AutoSavePlaylistTimer: TTimer;
    DragFilesSrc1: TDragFilesSrc;
    DragDropTimer: TTimer;
    VSTPanel: TPanel;
    GRPBOXVST: TNempPanel;
    PlaylistFillPanel: TNempPanel;
    GRPBOXPlaylist: TNempPanel;
    PlaylistVST: TVirtualStringTree;
    SleepTimer: TTimer;
    BirthdayTimer: TTimer;
    VolTimer: TTimer;
    ReallyClearPlaylistTimer: TTimer;
    PanelCoverBrowse: TNempPanel;
    CoverScrollbar: TScrollBar;
    MenuImages: TImageList;
    VSTSubPanel: TNempPanel;
    VST: TVirtualStringTree;
    Splitter4: TSplitter;
    VDTCover: TNempPanel;
    VDTCoverTimer: TTimer;
    dwTaskbarThumbnails1: TdwTaskbarThumbnails;
    TabBtn_Nemp: TSkinButton;
    TabBtn_Playlist: TSkinButton;
    PlayListStatusLBL: TLabel;
    PlayListOpenDialog: TOpenDialog;
    PlaylistDateienOpenDialog: TOpenDialog;
    OpenDialog1: TOpenDialog;
    PlayListSaveDialog: TSaveDialog;
    SaveDialog1: TSaveDialog;
    Medialist_PopupMenu: TPopupMenu;
    PlayListPOPUP: TPopupMenu;
    TNAMenu: TPopupMenu;
    Equalizer_PopupMenu: TPopupMenu;
    Player_PopupMenu: TPopupMenu;
    SleepPopup: TPopupMenu;
    BirthdayPopup: TPopupMenu;
    VST_ColumnPopup: TPopupMenu;
    PopupPlayPause: TPopupMenu;
    PopupStop: TPopupMenu;
    PopupRepeat: TPopupMenu;
    ScrobblerPopup: TPopupMenu;
    WebServerPopup: TPopupMenu;
    MM_Medialibrary: TMenuItem;
    MM_ML_SearchDirectory: TMenuItem;
    MM_ML_Webradio: TMenuItem;
    N22: TMenuItem;
    MM_ML_SortBy: TMenuItem;
    MM_ML_SortByArtistTitle: TMenuItem;
    MM_ML_SortByArtistAlbumTitle: TMenuItem;
    MM_ML_SortByTitleArtist: TMenuItem;
    MM_ML_SortByAlbumArtistTitle: TMenuItem;
    MM_ML_SortByAlumTitleArtist: TMenuItem;
    MM_ML_SortByAlbumTrack: TMenuItem;
    N10: TMenuItem;
    MM_ML_SortByFilename: TMenuItem;
    MM_ML_SortByPath: TMenuItem;
    MM_ML_SortByLyrics: TMenuItem;
    MM_ML_SortByGenre: TMenuItem;
    N11: TMenuItem;
    MM_ML_SortByDuration: TMenuItem;
    MM_ML_SortByFilesize: TMenuItem;
    N4: TMenuItem;
    MM_ML_SortAscending: TMenuItem;
    MM_ML_SortDescending: TMenuItem;
    MM_ML_BrowseBy: TMenuItem;
    MM_ML_BrowseByArtistAlbum: TMenuItem;
    MM_ML_BrowseByDirectoryArtist: TMenuItem;
    MM_ML_BrowseByDirectoryAlbum: TMenuItem;
    MM_ML_BrowseByGenreArtist: TMenuItem;
    MM_ML_BrowseByGenreYear: TMenuItem;
    N29: TMenuItem;
    MM_ML_BrowseByMore: TMenuItem;
    N23: TMenuItem;
    MM_ML_Delete: TMenuItem;
    MM_ML_Load: TMenuItem;
    MM_ML_Save: TMenuItem;
    MM_ML_ExportAsCSV: TMenuItem;
    N21: TMenuItem;
    MM_ML_DeleteMissingFiles: TMenuItem;
    MM_ML_RefreshAll: TMenuItem;
    MM_ML_ResetRatings: TMenuItem;
    MM_Playlist: TMenuItem;
    MM_PL_Add: TMenuItem;
    MM_PL_Files: TMenuItem;
    MM_PL_Directory: TMenuItem;
    MM_PL_WebStream: TMenuItem;
    MM_PL_Delete: TMenuItem;
    MM_PL_DeleteAll: TMenuItem;
    MM_PL_DeleteSelected: TMenuItem;
    MM_PL_DeleteMissingFiles: TMenuItem;
    MM_PL_RecentPlaylists: TMenuItem;
    MM_PL_SortBy: TMenuItem;
    MM_PL_SortByFilename: TMenuItem;
    MM_PL_SortByArtist: TMenuItem;
    MM_PL_SortByTitle: TMenuItem;
    MM_PL_SortByAlbumTrack: TMenuItem;
    N6: TMenuItem;
    MM_PL_SortByInverse: TMenuItem;
    MM_PL_SortByMix: TMenuItem;
    N18: TMenuItem;
    MM_PL_GenerateRandomPlaylist: TMenuItem;
    MM_PL_Load: TMenuItem;
    MM_PL_Save: TMenuItem;
    MM_PL_AddPlaylist: TMenuItem;
    N1: TMenuItem;
    MM_PL_PlaySelectedNext: TMenuItem;
    MM_PL_PlayInHeadset: TMenuItem;
    MM_PL_StopHeadset: TMenuItem;
    N26: TMenuItem;
    MM_PL_Extended: TMenuItem;
    MM_PL_ExtendedAddToMedialibrary: TMenuItem;
    MM_PL_ExtendedCopyFromWinamp: TMenuItem;
    MM_PL_ExtendedScanFiles: TMenuItem;
    MM_PL_ExtendedCopyToClipboard: TMenuItem;
    MM_PL_ExtendedPasteFromClipboard: TMenuItem;
    N33: TMenuItem;
    MM_PL_Properties: TMenuItem;
    MM_Options: TMenuItem;
    MM_O_Preferences: TMenuItem;
    MM_O_View: TMenuItem;
    MM_O_ViewCompact: TMenuItem;
    MM_O_ViewCompactComplete: TMenuItem;
    N34: TMenuItem;
    MM_O_ViewSeparateWindows: TMenuItem;
    MM_O_ViewSeparateWindows_Equalizer: TMenuItem;
    MM_O_ViewSeparateWindows_Playlist: TMenuItem;
    MM_O_ViewSeparateWindows_Medialist: TMenuItem;
    MM_O_ViewSeparateWindows_Browse: TMenuItem;
    N32: TMenuItem;
    MM_O_ViewStayOnTop: TMenuItem;
    MM_O_Skins: TMenuItem;
    MM_O_Skins_OpenEditor: TMenuItem;
    MM_O_Skins_WindowsStandard: TMenuItem;
    N38: TMenuItem;
    MM_O_Languages: TMenuItem;
    MM_O_Defaultlanguage: TMenuItem;
    MM_Tools: TMenuItem;
    MM_T_Shutdown: TMenuItem;
    MM_T_ShutdownOff: TMenuItem;
    N56: TMenuItem;
    MM_T_ShutDownModeStop: TMenuItem;
    MM_T_Shutdown_5Minutes0: TMenuItem;
    MM_T_Shutdown_15Minutes0: TMenuItem;
    MM_T_Shutdown_30Minutes0: TMenuItem;
    MM_T_Shutdown_45minutes0: TMenuItem;
    MM_T_Shutdown_60Minutes0: TMenuItem;
    MM_T_Shutdown_90Minutes0: TMenuItem;
    MM_T_Shutdown_120Minutes0: TMenuItem;
    N44: TMenuItem;
    MM_T_ShutDown_Custom0: TMenuItem;
    MM_T_ShutdownModeCloseNemp: TMenuItem;
    MM_T_Shutdown_5Minutes1: TMenuItem;
    MM_T_Shutdown_15Minutes1: TMenuItem;
    MM_T_Shutdown_30Minutes1: TMenuItem;
    MM_T_Shutdown_45minutes1: TMenuItem;
    MM_T_Shutdown_60Minutes1: TMenuItem;
    MM_T_Shutdown_90Minutes1: TMenuItem;
    MM_T_Shutdown_120Minutes1: TMenuItem;
    N60: TMenuItem;
    MM_T_ShutDown_Custom1: TMenuItem;
    MM_T_ShutDown_EndofPlaylist1: TMenuItem;
    MM_T_ShutdownModeSuspend: TMenuItem;
    MM_T_Shutdown_5Minutes2: TMenuItem;
    MM_T_Shutdown_15Minutes2: TMenuItem;
    MM_T_Shutdown_30Minutes2: TMenuItem;
    MM_T_Shutdown_45minutes2: TMenuItem;
    MM_T_Shutdown_60Minutes2: TMenuItem;
    MM_T_Shutdown_90Minutes2: TMenuItem;
    MM_T_Shutdown_120Minutes2: TMenuItem;
    N46: TMenuItem;
    MM_T_ShutDown_Custom2: TMenuItem;
    MM_T_ShutDown_EndofPlaylist2: TMenuItem;
    MM_T_ShutdownModeHibernate: TMenuItem;
    MM_T_Shutdown_5Minutes3: TMenuItem;
    MM_T_Shutdown_15Minutes3: TMenuItem;
    MM_T_Shutdown_30Minutes3: TMenuItem;
    MM_T_Shutdown_45minutes3: TMenuItem;
    MM_T_Shutdown_60Minutes3: TMenuItem;
    MM_T_Shutdown_90Minutes3: TMenuItem;
    MM_T_Shutdown_120Minutes3: TMenuItem;
    N47: TMenuItem;
    MM_T_ShutDown_Custom3: TMenuItem;
    MM_T_ShutDown_EndofPlaylist3: TMenuItem;
    MM_T_ShutdownModeShutDownWindows: TMenuItem;
    MM_T_Shutdown_5Minutes4: TMenuItem;
    MM_T_Shutdown_15Minutes4: TMenuItem;
    MM_T_Shutdown_30Minutes4: TMenuItem;
    MM_T_Shutdown_45minutes4: TMenuItem;
    MM_T_Shutdown_60Minutes4: TMenuItem;
    MM_T_Shutdown_90Minutes4: TMenuItem;
    MM_T_Shutdown_120Minutes4: TMenuItem;
    N49: TMenuItem;
    MM_T_ShutDown_Custom4: TMenuItem;
    MM_T_ShutDown_EndofPlaylist4: TMenuItem;
    MM_T_Birthday: TMenuItem;
    MM_T_BirthdayActivate: TMenuItem;
    MM_T_BirthdayDeactivate: TMenuItem;
    N24: TMenuItem;
    MM_T_BirthdayOptions: TMenuItem;
    MM_T_RemoteNemp: TMenuItem;
    MM_T_WebServerActivate: TMenuItem;
    MM_T_WebServerDeactivate: TMenuItem;
    N64: TMenuItem;
    MM_T_WebServerOptions: TMenuItem;
    MM_T_Scrobbler: TMenuItem;
    MM_T_ScrobblerActivate: TMenuItem;
    MM_T_ScrobblerDeactivate: TMenuItem;
    N62: TMenuItem;
    MM_T_ScrobblerOptions: TMenuItem;
    MM_T_Directories: TMenuItem;
    MM_T_DirectoriesRecordings: TMenuItem;
    MM_T_DirectoriesData: TMenuItem;
    MM_Help: TMenuItem;
    MM_H_About: TMenuItem;
    MM_H_ShowReadme: TMenuItem;
    N19: TMenuItem;
    MM_H_Help: TMenuItem;
    MM_H_CheckForUpdates: TMenuItem;
    PM_ML_Play: TMenuItem;
    PM_ML_Enqueue: TMenuItem;
    PM_ML_PlayNext: TMenuItem;
    PM_ML_PlayNow: TMenuItem;
    N14: TMenuItem;
    PM_ML_PlayHeadset: TMenuItem;
    PM_ML_StopHeadset: TMenuItem;
    N2: TMenuItem;
    PM_ML_SortBy: TMenuItem;
    PM_ML_SortByArtistTitel: TMenuItem;
    PM_ML_SortByArtistAlbumTitle: TMenuItem;
    PM_ML_SortByTitleArtist: TMenuItem;
    PM_ML_SortByAlbumArtistTitle: TMenuItem;
    PM_ML_SortByAlbumTitleArtist: TMenuItem;
    PM_ML_SortByAlbumTrack: TMenuItem;
    N7: TMenuItem;
    PM_ML_SortByFilename: TMenuItem;
    PM_ML_SortByPath: TMenuItem;
    PM_ML_SortByLyrics: TMenuItem;
    PM_ML_SortByGenre: TMenuItem;
    N8: TMenuItem;
    PM_ML_SortByDuration: TMenuItem;
    PM_ML_SortByFileSize: TMenuItem;
    N90: TMenuItem;
    PM_ML_SortDescending: TMenuItem;
    PM_ML_SortAscending: TMenuItem;
    PM_ML_BrowseBy: TMenuItem;
    PM_ML_BrowseByArtistAlbum: TMenuItem;
    PM_ML_BrowseByDirArtist: TMenuItem;
    PM_ML_BrowseByDirAlbum: TMenuItem;
    PM_ML_BrowseByGenreArtist: TMenuItem;
    PM_ML_BrowseByGenreYear: TMenuItem;
    N16: TMenuItem;
    PM_ML_BrowseByMore: TMenuItem;
    N5: TMenuItem;
    PM_ML_Medialibrary: TMenuItem;
    PM_ML_MedialibraryDeleteNotExisting: TMenuItem;
    PM_ML_MedialibraryRefresh: TMenuItem;
    PM_ML_ResetRatings: TMenuItem;
    PM_ML_MedialibrarySave: TMenuItem;
    PM_ML_MedialibraryLoad: TMenuItem;
    PM_ML_MedialibraryExport: TMenuItem;
    PM_ML_MedialibraryDelete: TMenuItem;
    PM_ML_SearchDirectory: TMenuItem;
    PM_ML_Webradio: TMenuItem;
    PM_ML_RefreshSelected: TMenuItem;
    PM_ML_HideSelected: TMenuItem;
    PM_ML_DeleteSelected: TMenuItem;
    PM_ML_GetLyrics: TMenuItem;
    N3: TMenuItem;
    PM_ML_ShowInExplorer: TMenuItem;
    PM_ML_CopyToClipboard: TMenuItem;
    PM_ML_PasteFromClipboard: TMenuItem;
    PM_ML_Extended: TMenuItem;
    PM_ML_ExtendedShowAllFilesInDir: TMenuItem;
    PM_ML_ExtendedAddAllFilesInDir: TMenuItem;
    N15: TMenuItem;
    PM_ML_ExtendedSearchTitle: TMenuItem;
    PM_ML_ExtendedSearchArtist: TMenuItem;
    PM_ML_ExtendedSearchAlbum: TMenuItem;
    N55: TMenuItem;
    PM_ML_Properties: TMenuItem;
    PM_PL_Add: TMenuItem;
    PM_PL_AddFiles: TMenuItem;
    PM_PL_AddDirectories: TMenuItem;
    PM_PL_AddWebstream: TMenuItem;
    PM_PL_Delete: TMenuItem;
    PM_PL_DeleteAll: TMenuItem;
    PM_PL_DeleteSelected: TMenuItem;
    PM_PL_DeleteMissingFiles: TMenuItem;
    PM_PL_RecentPlaylists: TMenuItem;
    PM_PL_SortBy: TMenuItem;
    PM_PL_SortByFilename: TMenuItem;
    PM_PL_SortByArtist: TMenuItem;
    PM_PL_SortByTitle: TMenuItem;
    PM_PL_SortByAlbumTrack: TMenuItem;
    N9: TMenuItem;
    PM_PL_SortByInverse: TMenuItem;
    PM_PL_SortByMix: TMenuItem;
    N25: TMenuItem;
    PM_PL_GeneraterandomPlaylist: TMenuItem;
    PM_PL_LoadPlaylist: TMenuItem;
    PM_PL_SavePlaylist: TMenuItem;
    PM_PL_AddPlaylist: TMenuItem;
    N12: TMenuItem;
    PM_PL_PlaySelectedNext: TMenuItem;
    PM_PL_PlayInHeadset: TMenuItem;
    PM_PL_StopHeadset: TMenuItem;
    N13: TMenuItem;
    PM_PL_Extended: TMenuItem;
    PM_PL_ExtendedAddToMedialibrary: TMenuItem;
    PM_PL_ExtendedCopyFromWinamp: TMenuItem;
    PM_PL_ExtendedScanFiles: TMenuItem;
    PM_PL_ExtendedCopyToClipboard: TMenuItem;
    PM_PL_ExtendedPasteFromClipboard: TMenuItem;
    N48: TMenuItem;
    PM_PL_Properties: TMenuItem;
    PM_TNA_Play: TMenuItem;
    PM_TNA_Pause: TMenuItem;
    PM_TNA_Stop: TMenuItem;
    PM_TNA_Next: TMenuItem;
    PM_TNA_Previous: TMenuItem;
    PM_TNA_Playlist: TMenuItem;
    N20: TMenuItem;
    PM_TNA_Restore: TMenuItem;
    PM_TNA_Close: TMenuItem;
    PM_EQ_Disabled: TMenuItem;
    N27: TMenuItem;
    PM_EQ_Load: TMenuItem;
    PM_EQ_Save: TMenuItem;
    PM_EQ_Delete: TMenuItem;
    N45: TMenuItem;
    PM_EQ_RestoreStandard: TMenuItem;
    PM_P_Options: TMenuItem;
    PM_P_View: TMenuItem;
    PM_P_ViewCompact: TMenuItem;
    PM_P_ViewCompactComplete: TMenuItem;
    N31: TMenuItem;
    PM_P_ViewSeparateWindows: TMenuItem;
    PM_P_ViewSeparateWindows_Equalizer: TMenuItem;
    PM_P_ViewSeparateWindows_Playlist: TMenuItem;
    PM_P_ViewSeparateWindows_Medialist: TMenuItem;
    PM_P_ViewSeparateWindows_Browse: TMenuItem;
    N35: TMenuItem;
    PM_P_ViewStayOnTop: TMenuItem;
    PM_P_Skins: TMenuItem;
    PM_P_Skins_OpenEditor: TMenuItem;
    PM_P_Skins_WindowsStandard: TMenuItem;
    N30: TMenuItem;
    PM_P_Languages: TMenuItem;
    PM_P_Defaultlanguage: TMenuItem;
    N36: TMenuItem;
    PM_P_ShutDown: TMenuItem;
    PM_P_ShutDownOff: TMenuItem;
    N57: TMenuItem;
    PM_P_ShutDownModeStop: TMenuItem;
    PM_P_ShutDown_5Minutes0: TMenuItem;
    PM_P_ShutDown_15Minutes0: TMenuItem;
    PM_P_ShutDown_30Minutes0: TMenuItem;
    PM_P_ShutDown_45Minutes0: TMenuItem;
    PM_P_ShutDown_60Minutes0: TMenuItem;
    PM_P_ShutDown_90Minutes0: TMenuItem;
    PM_P_ShutDown_120Minutes0: TMenuItem;
    N39: TMenuItem;
    PM_P_ShutDown_Custom0: TMenuItem;
    PM_P_ShutDownModeCloseNemp: TMenuItem;
    PM_P_ShutDown_5Minutes1: TMenuItem;
    PM_P_ShutDown_15Minutes1: TMenuItem;
    PM_P_ShutDown_30Minutes1: TMenuItem;
    PM_P_ShutDown_45Minutes1: TMenuItem;
    PM_P_ShutDown_60Minutes1: TMenuItem;
    PM_P_ShutDown_90Minutes1: TMenuItem;
    PM_P_ShutDown_120Minutes1: TMenuItem;
    N40: TMenuItem;
    PM_P_ShutDown_Custom1: TMenuItem;
    PM_P_ShutDown_EndofPlaylist1: TMenuItem;
    PM_P_ShutDownModeSuspend: TMenuItem;
    PM_P_ShutDown_5Minutes2: TMenuItem;
    PM_P_ShutDown_15Minutes2: TMenuItem;
    PM_P_ShutDown_30Minutes2: TMenuItem;
    PM_P_ShutDown_45Minutes2: TMenuItem;
    PM_P_ShutDown_60Minutes2: TMenuItem;
    PM_P_ShutDown_90Minutes2: TMenuItem;
    PM_P_ShutDown_120Minutes2: TMenuItem;
    N59: TMenuItem;
    PM_P_ShutDown_Custom2: TMenuItem;
    PM_P_ShutDown_EndofPlaylist2: TMenuItem;
    PM_P_ShutDownModeHibernate: TMenuItem;
    PM_P_ShutDown_5Minutes3: TMenuItem;
    PM_P_ShutDown_15Minutes3: TMenuItem;
    PM_P_ShutDown_30Minutes3: TMenuItem;
    PM_P_ShutDown_45Minutes3: TMenuItem;
    PM_P_ShutDown_60Minutes3: TMenuItem;
    PM_P_ShutDown_90Minutes3: TMenuItem;
    PM_P_ShutDown_120Minutes3: TMenuItem;
    N42: TMenuItem;
    PM_P_ShutDown_Custom3: TMenuItem;
    PM_P_ShutDown_EndofPlaylist3: TMenuItem;
    PM_P_ShutDownModeShutDownWindows: TMenuItem;
    PM_P_ShutDown_5Minutes4: TMenuItem;
    PM_P_ShutDown_15Minutes4: TMenuItem;
    PM_P_ShutDown_30Minutes4: TMenuItem;
    PM_P_ShutDown_45Minutes4: TMenuItem;
    PM_P_ShutDown_60Minutes4: TMenuItem;
    PM_P_ShutDown_90Minutes4: TMenuItem;
    PM_P_ShutDown_120Minutes4: TMenuItem;
    N43: TMenuItem;
    PM_P_ShutDown_Custom4: TMenuItem;
    PM_P_ShutDown_EndofPlaylist4: TMenuItem;
    PM_P_Birthday: TMenuItem;
    PM_P_BirthdayActivate: TMenuItem;
    PM_P_BirthdayDeactivate: TMenuItem;
    N41: TMenuItem;
    PM_P_BirthdayOptions: TMenuItem;
    PM_P_RemoteNemp: TMenuItem;
    PM_P_WebServerActivate: TMenuItem;
    PM_P_WebServerDeactivate: TMenuItem;
    N65: TMenuItem;
    PM_P_WebServerOptions: TMenuItem;
    PM_P_Scrobbler: TMenuItem;
    PM_P_ScrobblerActivate: TMenuItem;
    PM_P_ScrobblerDectivate: TMenuItem;
    N61: TMenuItem;
    PM_P_ScrobblerOptions: TMenuItem;
    PM_P_Directories: TMenuItem;
    PM_P_DirectoriesRecordings: TMenuItem;
    PM_P_DirectoriesData: TMenuItem;
    N17: TMenuItem;
    PM_P_About: TMenuItem;
    PM_P_ShowReadme: TMenuItem;
    PM_P_Help: TMenuItem;
    PM_P_CheckForUpdates: TMenuItem;
    N28: TMenuItem;
    PM_P_Minimize: TMenuItem;
    PM_P_Close: TMenuItem;
    _Shutdown: TMenuItem;
    PM_S_ShutDownOff: TMenuItem;
    N37: TMenuItem;
    PM_S_ShutDownModeStop: TMenuItem;
    PM_S_ShutDown_5Minutes0: TMenuItem;
    PM_S_ShutDown_15Minutes0: TMenuItem;
    PM_S_ShutDown_30Minutes0: TMenuItem;
    PM_S_ShutDown_45Minutes0: TMenuItem;
    PM_S_ShutDown_60Minutes0: TMenuItem;
    PM_S_ShutDown_90Minutes0: TMenuItem;
    PM_S_ShutDown_120Minutes0: TMenuItem;
    N50: TMenuItem;
    PM_S_ShutDown_Custom0: TMenuItem;
    PM_S_ShutDownModeCloseNemp: TMenuItem;
    PM_S_ShutDown_5Minutes1: TMenuItem;
    PM_S_ShutDown_15Minutes1: TMenuItem;
    PM_S_ShutDown_30Minutes1: TMenuItem;
    PM_S_ShutDown_45Minutes1: TMenuItem;
    PM_S_ShutDown_60Minutes1: TMenuItem;
    PM_S_ShutDown_90Minutes1: TMenuItem;
    PM_S_ShutDown_120Minutes1: TMenuItem;
    N51: TMenuItem;
    PM_S_ShutDown_Custom1: TMenuItem;
    PM_S_ShutDown_EndofPlaylist1: TMenuItem;
    PM_S_ShutDownModeSuspend: TMenuItem;
    PM_S_ShutDown_5Minutes2: TMenuItem;
    PM_S_ShutDown_15Minutes2: TMenuItem;
    PM_S_ShutDown_30Minutes2: TMenuItem;
    PM_S_ShutDown_45Minutes2: TMenuItem;
    PM_S_ShutDown_60Minutes2: TMenuItem;
    PM_S_ShutDown_90Minutes2: TMenuItem;
    PM_S_ShutDown_120Minutes2: TMenuItem;
    N52: TMenuItem;
    PM_S_ShutDown_Custom2: TMenuItem;
    PM_S_ShutDown_EndofPlaylist2: TMenuItem;
    PM_S_ShutDownModeHibernate: TMenuItem;
    PM_S_ShutDown_5Minutes3: TMenuItem;
    PM_S_ShutDown_15Minutes3: TMenuItem;
    PM_S_ShutDown_30Minutes3: TMenuItem;
    PM_S_ShutDown_45Minutes3: TMenuItem;
    PM_S_ShutDown_60Minutes3: TMenuItem;
    PM_S_ShutDown_90Minutes3: TMenuItem;
    PM_S_ShutDown_120Minutes3: TMenuItem;
    N53: TMenuItem;
    PM_S_ShutDown_Custom3: TMenuItem;
    PM_S_ShutDown_EndofPlaylist3: TMenuItem;
    PM_S_ShutDownModeShutDownWindows: TMenuItem;
    PM_S_ShutDown_5Minutes4: TMenuItem;
    PM_S_ShutDown_15Minutes4: TMenuItem;
    PM_S_ShutDown_30Minutes4: TMenuItem;
    PM_S_ShutDown_45Minutes4: TMenuItem;
    PM_S_ShutDown_60Minutes4: TMenuItem;
    PM_S_ShutDown_90Minutes4: TMenuItem;
    PM_S_ShutDown_120Minutes4: TMenuItem;
    N54: TMenuItem;
    PM_S_ShutDown_Custom4: TMenuItem;
    PM_S_ShutDown_EndofPlaylist4: TMenuItem;
    _Birthdaymode: TMenuItem;
    PM_B_BirthdayActivate: TMenuItem;
    PM_B_BirthdayDeactivate: TMenuItem;
    N461: TMenuItem;
    PM_B_BirthdayOptions: TMenuItem;
    N58: TMenuItem;
    VST_ColumnPopupCover: TMenuItem;
    VST_ColumnPopupCoverOff: TMenuItem;
    VST_ColumnPopupCoverLeft: TMenuItem;
    VST_ColumnPopupCoverRight: TMenuItem;
    PM_PlayFiles: TMenuItem;
    PM_PlayWebstream: TMenuItem;
    PM_StopNow: TMenuItem;
    PM_StopAfterTitle: TMenuItem;
    PM_RepeatAll: TMenuItem;
    PM_RepeatTitle: TMenuItem;
    PM_RandomMode: TMenuItem;
    PM_RepeatOff: TMenuItem;
    _Scrobbler: TMenuItem;
    PM_S_ScrobblerActivate: TMenuItem;
    PM_S_ScrobblerDeactivate: TMenuItem;
    N63: TMenuItem;
    PM_S_ScrobblerOptions: TMenuItem;
    _Webserver: TMenuItem;
    PM_W_WebServerActivate: TMenuItem;
    PM_W_WebServerDeactivate: TMenuItem;
    N66: TMenuItem;
    PM_W_WebServerOptions: TMenuItem;
    LyricsMemo: TMemo;
    NempTrayIcon: TTrayIcon;
    AuswahlHeaderPanel: TNempPanel;
    TabBtn_Preselection: TSkinButton;
    TabBtn_Browse: TSkinButton;
    TabBtn_CoverFlow: TSkinButton;
    AuswahlFillPanel: TNempPanel;
    AuswahlStatusLBL: TLabel;
    MedienBibHeaderPanel: TNempPanel;
    CB_MedienBibGlobalQuickSearch: TSkinButton;
    EDITFastSearch: TEdit;
    MedienlisteFillPanel: TNempPanel;
    MedienListeStatusLBL: TLabel;
    TabBtn_Medialib: TSkinButton;
    PlayerHeaderPanel: TNempPanel;
    MM_ML_Search: TMenuItem;
    NewPlayerPanel: TNempPanel;
    TextAnzeigeIMAGE: TImage;
    TimePaintBox: TImage;
    SlideBarButton: TSkinButton;
    SlideBarShape: TShape;
    SlideBackBTN: TSkinButton;
    PlayPrevBTN: TSkinButton;
    PlayPauseBTN: TSkinButton;
    StopBTN: TSkinButton;
    RecordBtn: TSkinButton;
    PlayNextBTN: TSkinButton;
    SlideForwardBTN: TSkinButton;
    RandomBtn: TSkinButton;
    VolShape: TShape;
    VolButton: TSkinButton;
    SleepImage: TImage;
    WebserverImage: TImage;
    BirthdayImage: TImage;
    ScrobblerImage: TImage;
    BtnMenu: TSkinButton;
    BtnMinimize: TSkinButton;
    BtnClose: TSkinButton;
    AudioPanel: TNempPanel;
    GRPBOXCover: TNempPanel;
    TabBtn_Cover: TSkinButton;
    TabBtn_Lyrics: TSkinButton;
    TabBtn_Equalizer: TSkinButton;
    TabBtn_Effects: TSkinButton;
    RatingImage: TImage;
    LblPlayerTitle: TLabel;
    LblPlayerArtist: TLabel;
    LblPlayerAlbum: TLabel;
    PaintFrame: TImage;
    CoverImage: TImage;
    IMGMedienBibCover: TImage;
    ImgScrollCover: TImage;
    PM_ML_BrowseByAlbumArtists: TMenuItem;
    PM_ML_BrowseByYearArtist: TMenuItem;
    MM_ML_BrowseByAlbumArtists: TMenuItem;
    MM_ML_BrowseByYearArtist: TMenuItem;
    Panel1: TNempPanel;
    Lbl_CoverFlow: TLabel;
    PM_P_PartyMode: TMenuItem;
    TabBtn_TagCloud: TSkinButton;
    MM_O_PartyMode: TMenuItem;
    ImgDetailCover: TImage;
    LblBibArtist: TLabel;
    LblBibTitle: TLabel;
    LblBibAlbum: TLabel;
    LblBibYear: TLabel;
    LblBibTrack: TLabel;
    LblBibGenre: TLabel;
    LblBibDuration: TLabel;
    LblBibQuality: TLabel;
    ImgBibRating: TImage;
    EdtBibArtist: TEdit;
    EdtBibAlbum: TEdit;
    EdtBibTitle: TEdit;
    EdtBibYear: TEdit;
    EdtBibTrack: TEdit;
    EdtBibGenre: TComboBox;
    Button1: TButton;
    PanelTagCloudBrowse: TNempPanel;
    PM_ML_GetTags: TMenuItem;
    LblBibTags: TLabel;

    procedure FormCreate(Sender: TObject);

    procedure InitPlayingFile(Startplay: Boolean; StartAtOldPosition: Boolean = False);

    procedure Skinan1Click(Sender: TObject);

    procedure ChangeLanguage(Sender: TObject);

    Procedure AnzeigeSortMENUClick(Sender: TObject);

    procedure PM_ML_HideSelectedClick(Sender: TObject);
    procedure MM_ML_DeleteClick(Sender: TObject);
    procedure MM_ML_SearchDirectoryClick(Sender: TObject);
    procedure MM_ML_LoadClick(Sender: TObject);

    procedure MM_ML_SaveClick(Sender: TObject);

    procedure DatenbankUpdateTBClick(Sender: TObject);

    procedure HandleFiles(aList: TObjectList; how: integer);
    procedure GenerateListForHandleFiles(aList: TObjectList; what: integer);
    procedure DoFreeFilesInHandleFilesList(aList: TObjectList);
                  
    procedure EnqueueTBClick(Sender: TObject);
    procedure PM_ML_PlayClick(Sender: TObject);
    function GetFocussedAudioFile:TAudioFile;
    procedure Medialist_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_ShowInExplorerClick(Sender: TObject);

    procedure ShowSummary;

    procedure ToolButton7Click(Sender: TObject);
    procedure MM_ML_RefreshAllClick(Sender: TObject);
    procedure PM_ML_RefreshSelectedClick(Sender: TObject);

    procedure PM_ML_PropertiesClick(Sender: TObject);

    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
//    procedure VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
//      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MM_ML_SortAscendingClick(Sender: TObject);
    procedure MM_ML_SortDescendingClick(Sender: TObject);
    procedure VSTStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure MM_O_PreferencesClick(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormShow(Sender: TObject);

    Procedure StuffToDoOnCreate;
    Procedure StuffToDoAfterCreate;

    function ValidAudioFile(filename: UnicodeString; JustPlay: Boolean): boolean;
    procedure PM_ML_GetLyricsClick(Sender: TObject);

    procedure VSTBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);

    procedure StringVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);

    procedure SetBrowseTabWarning(ShowWarning: Boolean);
    procedure ReFillBrowseTrees(RemarkOldNodes: LongBool);

    procedure ArtistsVSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);

    procedure StringVSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ArtistsVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure AlbenVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure AlbenVSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure BassTimerTimer(Sender: TObject);
    procedure PlaylistVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure PlaylistVSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure PlaylistVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PlaylistVSTDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure PlaylistVSTMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    //Procedure StreamPause;
    procedure PlayNextBTNIMGClick(Sender: TObject);
    procedure PlayPrevBTNIMGClick(Sender: TObject);
    procedure StopBTNIMGClick(Sender: TObject);
    procedure PlayPauseBTNIMGClick(Sender: TObject);
    procedure SlideBarShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SlideBarButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure ShowPlayerDetails(aAudioFile: TAudioFile);
    procedure ShowVSTDetails(aAudioFile: TAudioFile);
    procedure VolButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PM_PL_DeleteAllClick(Sender: TObject);
    procedure PM_PL_DeleteSelectedClick(Sender: TObject);
    procedure PlayInHeadset(aTree: TVirtualStringTree);
    procedure PM_PL_PlayInHeadsetClick(Sender: TObject);
    procedure PM_PL_StopHeadsetClick(Sender: TObject);
    procedure PM_ML_PlayHeadsetClick(Sender: TObject);
    procedure BassTimeLBLClick(Sender: TObject);
    procedure PlaylistSortClick(Sender: TObject);
    procedure PM_PL_SortByInverseClick(Sender: TObject);
    procedure PM_PL_SortByMixClick(Sender: TObject);
    procedure PM_PL_SavePlaylistClick(Sender: TObject);
    procedure PM_PL_LoadPlaylistClick(Sender: TObject);

    procedure LoadCueSheet(filename: UnicodeString);
    procedure SlideBackBTNIMGClick(Sender: TObject);
    procedure SlideForwardBTNIMGClick(Sender: TObject);
    procedure PlaylistVSTDragDrop(Sender: TBaseVirtualTree;
      Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
      Shift: TShiftState; Pt: TPoint; var Effect: Integer;
      Mode: TDropMode);
    procedure PM_PL_PropertiesClick(Sender: TObject);
    procedure PlaylistVSTChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure CoverImageDblClick(Sender: TObject);
    procedure PlaylistVSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PM_ML_PlayNextClick(Sender: TObject);
    procedure PM_ML_ExtendedShowAllFilesInDirClick(Sender: TObject);
    procedure NachDiesemDingSuchen1Click(Sender: TObject);
    procedure MM_H_ShowReadmeClick(Sender: TObject);
    procedure PM_PL_ExtendedCopyFromWinampClick(Sender: TObject);
    procedure MM_PL_DirectoryClick(Sender: TObject);
    procedure MM_PL_FilesClick(Sender: TObject);
    procedure MM_PL_AddPlaylistClick(Sender: TObject);
    procedure PM_PL_ExtendedAddToMedialibraryClick(Sender: TObject);
    procedure PlayListPOPUPPopup(Sender: TObject);
    procedure PlaylistVSTAfterItemPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure StopMENUClick(Sender: TObject);
    procedure PM_ML_CopyToClipboardClick(Sender: TObject);
    procedure PM_ML_PasteFromClipboardClick(Sender: TObject);
    procedure PlaylistVSTMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EqualizerButton1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure EqualizerButton1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure EqualizerButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SampleRateButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SampleRateButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HallButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure HallButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EchoWetDryMixButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure EchoWetDryMixButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EchoTimeButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HallShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EchoWetDryMixShapeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EchoTimeShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SampleRateShapeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Splitter3Moved(Sender: TObject);
    procedure Splitter2Moved(Sender: TObject);
    procedure Btn_EffectsOffClick(Sender: TObject);
    procedure PlayListSaveDialogTypeChange(Sender: TObject);
    procedure MMKeyTimerTimer(Sender: TObject);
    procedure PM_TNA_CloseClick(Sender: TObject);
    procedure PM_TNA_RestoreClick(Sender: TObject);
    procedure AnzeigeBTNClick(Sender: TObject);

    procedure AnzeigeBTNMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlaylistVSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure PM_PL_ExtendedScanFilesClick(Sender: TObject);

    procedure LyricsMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    function GetDefaultEQName(aIdx: Integer): String;
    procedure InitEqualizerMenuFormIni(aIni: TMemIniFile);
    procedure SetEqualizerFromPresetClick(Sender: TObject);
    procedure Btn_EqualizerPresetsClick(Sender: TObject);
    procedure DirectionPositionBTNClick(Sender: TObject);
    procedure SaveEQSettingsClick(Sender: TObject);
    procedure DeleteEQSettingsClick(Sender: TObject);
    procedure PM_EQ_RestoreStandardClick(Sender: TObject);
    procedure MM_H_AboutClick(Sender: TObject);
    procedure RepeatBitBTNIMGClick(Sender: TObject);
    procedure SetRepeatBtnGraphics;
    procedure PlaylistVSTKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VSTHeaderDrawQueryElements(Sender: TVTHeader;
      var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
    procedure VSTAdvancedHeaderDraw(Sender: TVTHeader;
      var PaintInfo: THeaderPaintInfo;
      const Elements: THeaderPaintElements);
    procedure PlaylistVSTResize(Sender: TObject);
    procedure ArtistsVSTResize(Sender: TObject);
    procedure AlbenVSTResize(Sender: TObject);
    procedure PaintFrameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MM_O_ViewCompactCompleteClick(Sender: TObject);
    procedure PlayerTabsClick(Sender: TObject);

    procedure TABPanelAuswahlClick(Sender: TObject);
    procedure AuswahlPanelResize(Sender: TObject);
    procedure PM_ML_MedialibraryExportClick(Sender: TObject);
    procedure PM_P_CloseClick(Sender: TObject);
    procedure PaintFrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PM_P_MinimizeClick(Sender: TObject);
    procedure AutoSavePlaylistTimerTimer(Sender: TObject);
    procedure ArtistsVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure AlbenVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PlaylistVSTScroll(Sender: TBaseVirtualTree; DeltaX,
      DeltaY: Integer);
    procedure FormResize(Sender: TObject);
    procedure MM_PL_WebStreamClick(Sender: TObject);
    procedure PM_ML_DeleteSelectedClick(Sender: TObject);
    procedure EDITFastSearchEnter(Sender: TObject);
    procedure PM_P_ViewStayOnTopClick(Sender: TObject);
    procedure EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
    procedure DoFastSearch(aString: UnicodeString; AllowErr: Boolean = False);
    procedure FormPaint(Sender: TObject);
    procedure PlaylistVSTGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: String);
    procedure DragFilesSrc1Dropping(Sender: TObject);
    procedure DragDropTimerTimer(Sender: TObject);
    procedure VSTAfterItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure SortierAuswahl1POPUPClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure AuswahlPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TntFormDestroy(Sender: TObject);
    procedure PaintFrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnMinimizeClick(Sender: TObject);
    procedure PM_P_ViewCompactClick(Sender: TObject);
    procedure PM_P_ViewSeparateWindows_PlaylistClick(Sender: TObject);
    procedure PM_P_ViewSeparateWindows_MedialistClick(Sender: TObject);
    procedure PM_P_ViewSeparateWindows_BrowseClick(
      Sender: TObject);
    procedure PM_P_ViewSeparateWindows_EqualizerClick(
      Sender: TObject);
    procedure BtnMenuClick(Sender: TObject);
    procedure Nichtvorhandenelschen1Click(Sender: TObject);
    procedure TabPanelMedienlisteClick(Sender: TObject);
    Function GenerateSleepHint: String;
    procedure ResetShutDownCaptions;
    procedure StundenClick(Sender: TObject);
    procedure InitShutDown;
    procedure SleepTimerTimer(Sender: TObject);
    procedure Schlafmodusdeaktivieren1Click(Sender: TObject);

    procedure LoadARecentPlaylist(Sender: TObject);
    function AddFileToRecentList(NewFile: UnicodeString): Boolean;
    Procedure SetRecentPlaylistsMenuItems;

    Function GeneratePlaylistSTFilter: string;
    function GenerateMedienBibSTFilter: String;
    procedure PlaylistVSTEnter(Sender: TObject);
    procedure VSTEnter(Sender: TObject);

    procedure RepairZOrder;
    procedure ActualizeVDTCover;

    procedure PM_PL_PlaySelectedNextClick(Sender: TObject);
    procedure PM_ML_PlayNowClick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    //procedure GroupboxPaint(Sender: TObject);
    Procedure RepaintPanels;
    Procedure RepaintPlayerPanel;
    Procedure RepaintOtherForms;
    procedure RepaintAll;
    Procedure RepaintVisOnPause;
    procedure TABPanelPaint(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);

    procedure PlaylistVSTCollapsAndExpanded(Sender: TBaseVirtualTree;
      Node: PVirtualNode);

    procedure AktualisiereDetailForm(aAudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
    procedure TNAMenuPopup(Sender: TObject);
    Procedure TNA_PlaylistClick(Sender: TObject);
    procedure BirthdayTimerTimer(Sender: TObject);
    procedure MenuBirthdayAusClick(Sender: TObject);
    procedure MenuBirthdayStartClick(Sender: TObject);

    procedure ReInitPlayerVCL;
    procedure VolTimerTimer(Sender: TObject);
    procedure PutDirListInAutoScanList(aDirList: TStringList);
    procedure EDITFastSearchExit(Sender: TObject);
    procedure VSTPanelResize(Sender: TObject);
    procedure MitzuflligenEintrgenausderMedienbibliothekfllen1Click(
      Sender: TObject);
    procedure ReallyClearPlaylistTimerTimer(Sender: TObject);
    procedure RecordBtnIMGClick(Sender: TObject);
    procedure CoverScrollbarChange(Sender: TObject);
    procedure PanelCoverBrowseResize(Sender: TObject);
    procedure ImgScrollCoverMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CoverScrollbarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IMGMedienBibCoverMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IMGMedienBibCoverMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IMGMedienBibCoverMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure Lbl_CoverFlowMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SkinEditorstarten1Click(Sender: TObject);
    procedure WindowsStandardClick(Sender: TObject);
    procedure PM_P_BirthdayOptionsClick(Sender: TObject);
    procedure _XXX_SleepLBLClick(Sender: TObject);
    procedure _XXX_BirthdayLBLClick(Sender: TObject);
    procedure TabPanelPlaylistClick(Sender: TObject);
    procedure PM_P_DirectoriesRecordingsClick(Sender: TObject);
    procedure PM_P_DirectoriesDataClick(Sender: TObject);
    procedure PlaylistPanelResize(Sender: TObject);
    procedure VSTAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure MM_ML_ResetRatingsClick(Sender: TObject);
    procedure Player_PopupMenuPopup(Sender: TObject);
    procedure VST_ColumnPopupPopup(Sender: TObject);
//    procedure VDTCoverDrawNode(Sender: TBaseVirtualTree;
//      const PaintInfo: TVTPaintInfo);
//    procedure VDTCoverFreeNode(Sender: TBaseVirtualTree;
//      Node: PVirtualNode);
//    procedure VDTCoverAdvancedHeaderDraw(Sender: TVTHeader;
//      var PaintInfo: THeaderPaintInfo;
//      const Elements: THeaderPaintElements);
//    procedure VDTCoverResize(Sender: TObject);
//    procedure VDTCoverHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure Splitter4CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);

    procedure VST_ColumnPopupOnClick(Sender: TObject);
    procedure VST_ColumnPopupCoverOnClick(Sender: TObject);
    procedure EDITFastSearchChange(Sender: TObject);
    procedure CB_MedienBibGlobalQuickSearchClick(Sender: TObject);
    procedure RefreshMedienBibCover;
    procedure VDTCoverTimerTimer(Sender: TObject);
    procedure AlbenVSTClick(Sender: TObject);
    procedure ArtistsVSTClick(Sender: TObject);
    procedure PM_PlayFilesClick(Sender: TObject);
    procedure PM_PlayWebstreamClick(Sender: TObject);
    procedure PM_StopNowClick(Sender: TObject);
    procedure PM_StopAfterTitleClick(Sender: TObject);
    procedure PopupStopPopup(Sender: TObject);
    procedure PM_RepeatMenuClick(Sender: TObject);
    procedure PopupRepeatPopup(Sender: TObject);
    procedure ShutDown_EndofPlaylistClick(Sender: TObject);
    procedure PM_EQ_DisabledClick(Sender: TObject);
    procedure MM_H_CheckForUpdatesClick(Sender: TObject);
    procedure dwTaskbarThumbnails1ThumbnailClick(
      Sender: TdwTaskbarThumbnailItem);
    procedure VolButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SlideBarButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GRPBOXEffekteDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
      
    procedure SlideBarButtonEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure EffectsButtonEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure GRPBOXEqualizerDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure EqualizerButton1EndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure GrpBoxControlDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure VolButtonEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure EqualizerButton9KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HallButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EchoWetDryMixButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EchoTimeButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SampleRateButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabBtn_PreselectionClick(Sender: TObject);
    procedure TabBtn_CoverMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PM_P_ScrobblerActivateClick(Sender: TObject);
    procedure PM_P_ScrobblerDeactivateClick(Sender: TObject);
    procedure PM_P_ScrobblerOptionsClick(Sender: TObject);
    procedure ScrobblerImageClick(Sender: TObject);
    procedure SleepImageClick(Sender: TObject);
    procedure BirthdayImageClick(Sender: TObject);
    procedure MM_T_WebServerActivateClick(Sender: TObject);
    procedure MM_T_WebServerDeactivateClick(Sender: TObject);
    procedure MM_T_WebServerOptionsClick(Sender: TObject);
    procedure WebserverImageClick(Sender: TObject);

    procedure NempTrayIconClick(Sender: TObject);
    procedure ArtistsVSTIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure VSTIncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode;
      const SearchText: string; var Result: Integer);
    procedure NewPanelPaint(Sender: TObject);
    procedure MM_ML_SearchClick(Sender: TObject);
    procedure VSTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure VSTEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure VSTMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
    procedure VSTEditCancelled(Sender: TBaseVirtualTree; Column: TColumnIndex);
    procedure PanelCoverBrowseMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanelCoverBrowsePaint(Sender: TObject);
    procedure CorrectFormAfterPartyModeChange;
    procedure PM_P_PartyModeClick(Sender: TObject);
    procedure RatingImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RatingImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RatingImageMouseLeave(Sender: TObject);
    procedure PanelCoverBrowseAfterPaint(Sender: TObject);
    procedure VSTHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure VSTHeaderDblClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure VSTInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure VDTCoverResize(Sender: TObject);
    procedure ImgBibRatingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgBibRatingMouseLeave(Sender: TObject);
    procedure ImgBibRatingMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LblBibArtistClick(Sender: TObject);

    procedure FillBibDetailLabels(aAudioFile: TAudioFile);
    procedure AdjustEditToLabel(aEdit: TControl; aLabel: TLabel);
    procedure ShowLabelAgain(aEdit: TControl; aLabel: TLabel);
    function GetCorrespondingEdit(aLabel: TLabel): TControl;
    function GetCorrespondingLabel(aEdit: TControl): TLabel;

    procedure EdtBibArtistExit(Sender: TObject);
    procedure EdtBibArtistKeyPress(Sender: TObject; var Key: Char);
    procedure VDTCoverClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PM_ML_GetTagsClick(Sender: TObject);
    procedure PanelTagCloudBrowseResize(Sender: TObject);
    procedure PanelTagCloudBrowsePaint(Sender: TObject);
    procedure PanelTagCloudBrowseMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PanelTagCloudBrowseClick(Sender: TObject);
    procedure PanelTagCloudBrowseDblClick(Sender: TObject);
    procedure CloudTestKey(Sender: TObject; var Key: Char);

    procedure CloudTestKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);

    procedure CloudPaint(Sender: TObject);
    procedure CloudAfterPaint(Sender: TObject);

    procedure PanelTagCloudBrowseMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  private

    MediaTest: Boolean;
    MediaCount: Integer;

    CoverImgDownX: Integer;
    CoverImgDownY: Integer;
    PaintFrameDownX: Integer;
    PaintFrameDownY: Integer;

    OldScrollbarWindowProc: TWndMethod;
    OldLyricMemoWindowProc: TWndMethod;

    FreeFilesInHandleFilesList: Boolean;

    // Speichert den Slidebutton, der gerade gedraggt wird
    DraggingSlideButton: TSkinButton;

    EditingVSTStrings: Boolean;
    EditingVSTRating: Boolean;
    LastVSTMouseOverNode: PVirtualNode;

    NempIsClosing: Boolean;

    // Setzt alle DragOver-Eventhandler auf das der Effekte-Groupbox
    procedure SetGroupboxEffectsDragover;
    // ... der Equalizer-Groupbox
    procedure SetGroupboxEQualizerDragover;

    procedure NewScrollBarWndProc(var Message: TMessage);
    procedure NewLyricMemoWndProc(var Message: TMessage);
    procedure WMStartEditing(var Msg: TMessage); Message WM_STARTEDITING;

    procedure ProcessCommandline(lpData: Pointer; StartPlay: Boolean) ; overload;
    procedure ProcessCommandline(filename: UnicodeString; StartPlay: Boolean; Enqueue: Boolean); overload;

    procedure HandleRemoteFilename(filename: UnicodeString; Mode: Integer);

    { Private declarations }
  public

      CloudViewer: TCloudViewer;

    // Z�hlt die Nachrichten "Neues Laufwerk angeschlossen"
    // n�tig, da ein Update der Bib nicht m�glich ist, wenn ein Update bereits l�uft
    NewDrivesNotificationCount: Integer;

    WebRadioInsertMode: Integer;
    AllowClose: boolean;

    { Public declarations }
    DoHookInstall: Boolean;
    SchonMalEineMediaTasteGedrueckt: Boolean;
    EqualizerButtons: Array[0..9] of TSkinButton;

    PlayListSkinImageList: TImageList;

    ActivationMessage: Cardinal;

    MinimizedIndicator: Boolean;
//-----------------------

    DragDropList: TStringList;  // Liste mir interne gedraggten Dateien, da der normale
                                   // Drag&Drop bei WS nicht so richtig klappt.

    NempOptions: TNempOptions; // Viele viele Optionen, die in der ini stehen

    NempDockedForms: Array [1..3] of Boolean;
    NempSkin: TNempSkin;


    // Laufzeit-tmp-Variablen
    AutoShowDetailsTMP: Boolean;
    DragSource: Integer; // Woher kommen die Gedraggten Files?

    BackupPlayingIndex: Integer; // Beim Startvorgang mit Parameter den alten PlayingIndex merken,
                                 // Falls mit den Parametern was nicht stimmt

    TaskBarDelay: integer;

    ContinueWithPlaylistAdding: Boolean;
    LangeAktionWeitermachen: Boolean;
    ReadyForGetFileApiCommands: Boolean;

    SelectionPrefix: UnicodeString;
    OldSelectionPrefix: UnicodeString;
    IncrementalTimerID: Cardinal;

    Nemp_VersionString: String;

    Saved8087CW: Word;

    SelectedPlayListMp3s: TNodeArray;

    NempWindowDefault: DWord;

    AnzeigeMode: Integer;
    UseSkin: Boolean;
    SkinName: UnicodeString;

    AktiverTree: TVirtualStringTree;
    AlphaBlendBMP: TBitmap;

    BibRatingHelper: TRatingHelper;

    procedure MinimizeNemp(Sender: TObject);
    procedure DeactivateNemp(Sender: TObject);
    procedure RestoreNemp;
  protected
    Procedure WMDropFiles (Var aMsg: tMessage);  message WM_DROPFILES;
    procedure MediaKey (Var aMSG: tMessage); message WM_APPCOMMAND;

    procedure NotifyDeskband(aMsg: Integer);
    Procedure NempAPI_Commands(Var aMSG: tMessage); message WM_COMMAND;
    Procedure NempAPI_UserCommands(Var aMSG: tMessage); message WM_USER;

    Procedure MedienBibMessage(Var aMsg: TMessage); message WM_MedienBib;
//    Procedure PlayerMessage(Var aMsg: TMessage); message WM_Player;

    Procedure ShoutcastQueryMessage(Var aMsg: TMessage); message WM_Shoutcast;
    Procedure WebServerMessage(Var aMsg: TMessage); message WM_WebServer;
    Procedure UpdaterMessage(Var aMsg: TMessage); message WM_Update;
    Procedure ScrobblerMessage(Var aMsg: TMessage); message WM_Scrobbler;

    procedure WndProc(var Message: TMessage); override;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;

    procedure hotkey(var msg:Tmessage); message WM_HOTKEY;
    procedure WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var M: TWMEndSession); message WM_ENDSESSION;

    procedure NeedPreview (var msg : TWMFCNeedPreview); message WM_FC_NEEDPREVIEW;

    procedure NewSelected (Var Msg: TMessage); message WM_FC_SELECT;

    ///procedure FCTest (var msg : TMessage); message WM_FLYINGCOWTEST;


    procedure STStart    (var Msg: TMessage); message ST_Start    ;
    procedure STNewFile  (var Msg: TMessage); message ST_NewFile  ;
    procedure STFinish   (var Msg: TMessage); message ST_Finish   ;


  end;


var

  Nemp_MainForm: TNemp_MainForm;

  ST_Playlist       : TSearchTool;
  ST_Medienliste    : TSearchTool;

  CueSyncHandle: DWord;

  InstallHook: TInstallHook;
  UninstallHook: TUninstallHook;
  HookIsInstalled: Boolean;

  AcceptApiCommands: Boolean = False; // am Ende des OnShows auf True setzen.
                                      // Beim Close auf False
  lib: Cardinal;

  NempPlayer: TNempPlayer;
  NempPlayList: TNempPlaylist; // Die Playlist halt ;-)
  NempWebServer: TNempWebServer;
  MedienBib: TMedienbibliothek;

  SavePath: UnicodeString; // Programmdir oder Userdir

  LanguageList: TStrings;

implementation

uses   Splash, MultimediaKeys,
    About, OptionsComplete, StreamVerwaltung,
   PlaylistUnit,  AuswahlUnit,  MedienlisteUnit, ShutDown, Details,
  HeadsetControl, BirthdayShow, RandomPlaylist,
  NewPicture, ShutDownEdit, NewStation, BibSearch, BassHelper,
  ExtendedControlsUnit, NoLyricWikiApi;


{$R *.dfm}


procedure TNemp_MainForm.InitPlayingFile(Startplay: Boolean; StartAtOldPosition: Boolean = False);
begin
    if StartPlay then
        NempPlayer.LastUserWish := USER_WANT_PLAY
    else
        NempPlayer.LastUserWish := USER_WANT_STOP;
    if (NempPlaylist.PlayingIndex > -1) AND (NempPlaylist.PlayingIndex <= NempPlaylist.PlayList.Count-1) then
    begin
    try
      if NempPlaylist.SavePositionInTrack AND StartAtOldPosition then
        NempPlaylist.Play(NempPlaylist.PlayingIndex, NempPlayer.FadingInterval, StartPlay, NempPlaylist.PositionInTrack)
      else
        NempPlaylist.Play(NempPlaylist.PlayingIndex, NempPlayer.FadingInterval, StartPlay);
      basstimer.Enabled := StartPlay;
    except
       on E: Exception do MessageDLG('Error in InitPlayingFile: ' + #13#10 + E.Message,mtError, [mbOK], 0);
    end;
    end;
end;

Procedure TNemp_MainForm.StuffToDoOnCreate;
var i, s, section:integer;
    ini:TMemIniFile;
    DefaultEQ: integer;
    specbmp:TBitmap;
    SR: TSearchrec;
    tmpLastExitOK: boolean;
    maxFont: integer;
    aMenuItem: TMenuItem;
    tmpwstr: UnicodeString;
    tmpstr: String;
begin
    BackUpComboboxes;
    TranslateComponent (self);
    RestoreComboboxes;
    NempIsClosing := False;

    NewDrivesNotificationCount := 0;
    ReadyForGetFileApiCommands := False;
    Randomize;
    NempRegionsDistance.docked := true;
    MinimizedIndicator := False;
    OldScrollbarWindowProc := CoverScrollbar.WindowProc;
    OldLyricMemoWindowProc := LyricsMemo.WindowProc;
    //OldCoverFlowPanelWindowProc := PanelCoverBrowse.WindowProc;

    CoverScrollbar.WindowProc :=  NewScrollBarWndProc;

    LyricsMemo.WindowProc := NewLyricMemoWndProc;
    AllowClose := True;
    WebRadioInsertMode := PLAYER_PLAY_DEFAULT;
        // Diverse Exceptions abschalten
       SetErrorMode(SEM_FAILCRITICALERRORS); // e.g. Dont display "Insert Disk"
       Saved8087CW := Default8087CW;
       Set8087CW($133f);
    Decimalseparator := '.';
    DragAcceptFiles (Handle, True);
    LangeAktionWeitermachen := False;
    VST.NodeDataSize := SizeOf(TTreeData);

////    VDTCover.NodeDataSize := SizeOf(TCoverTreeData);

    ArtistsVST.NodeDataSize := SizeOf(TStringTreeData);
    ALbenVST.NodeDataSize := SizeOf(TStringTreeData);
    PlaylistVST.NodeDataSize := SizeOf(TTreeData);
    Application.Title := NEMP_NAME_TASK;
    Application.Name := NEMP_NAME;
    Application.Name := NEMP_NAME;

    // "OnMinimize"-Event �ndern
    Application.OnMinimize := MinimizeNemp;
    Application.OnDeactivate := DeactivateNemp;

    AlphaBlendBMP := TBitmap.Create;

    ST_Playlist := TSearchTool.Create;
    ST_Medienliste := TSearchTool.Create;
    with ST_Medienliste do
    begin
      ID := ST_ID_Medialist;
      Recurse := True;
      //Zielhandle der Messages festlegen
      MHandle     := Handle;
      //Art der Message bei Benachrichtigungen �ber den aktuellen Ordner, der durchsucht wird, �ndern
      MCurrentDir := mkNoneMessage; //brauche ich nicht abfragen, da ich ein Timer verwende ;)
      MFound := mkSendMessage;
    end;
    with ST_Playlist do
    begin
      ID := ST_ID_Playlist;
      Recurse := True;
      MHandle     := Handle;
      MCurrentDir := mkNoneMessage;
      MFound := mkSendMessage;
    end;

    if Assigned(FSplash) then
    begin
      FSplash.StatusLBL.Caption := (SplashScreen_Loading);
      FSplash.Update;
    end;

    // Diverse Controls richtig positionieren
    GRPBoxCover.Parent := AudioPanel;
    GRPBoxEffekte.Parent := AudioPanel;
    GRPBoxEqualizer.Parent := AudioPanel;
    GRPBoxLyrics.Parent := AudioPanel;
    GRPBoxCover      .Align := alLeft;
    GRPBoxEffekte    .Align := alLeft;
    GRPBoxEqualizer  .Align := alLeft;
    GRPBoxLyrics     .Align := alLeft;
    GRPBoxCover      .Width := 191;
    GRPBoxEffekte    .Width := 191;
    GRPBoxEqualizer  .Width := 191;
    GRPBoxLyrics     .Width := 191;

    GRPBoxLyrics.Visible := False;
    GRPBoxEffekte.Visible := False;
    GRPBoxEqualizer.Visible := False;
    // Neu: August 2007
    TopMainPanel.Constraints.MinHeight := TOP_MIN_HEIGHT;

    GRPBOXArtistsAlben.Height := GRPBOXPlaylist.Height;
    GRPBOXArtistsAlben.Anchors := [akleft, aktop, akright, akBottom];

    ArtistsVST.SelectionBlendFactor := 75;
    AlbenVST.SelectionBlendFactor := 75;
    VST.SelectionBlendFactor := 75;
    PlaylistVST.SelectionBlendFactor := 75;

    // EQ-Buttons-Array bef�llen
    EqualizerButtons[0] := EqualizerButton1;
    EqualizerButtons[1] := EqualizerButton2;
    EqualizerButtons[2] := EqualizerButton3;
    EqualizerButtons[3] := EqualizerButton4;
    EqualizerButtons[4] := EqualizerButton5;
    EqualizerButtons[5] := EqualizerButton6;
    EqualizerButtons[6] := EqualizerButton7;
    EqualizerButtons[7] := EqualizerButton8;
    EqualizerButtons[8] := EqualizerButton9;
    EqualizerButtons[9] := EqualizerButton10;

    DragDropList := TStringList.Create;

    //--------------------------------------------------------------------
    // neues System - Unterscheidung nach Order
    if AnsiStartsText(GetShellFolder(CSIDL_PROGRAM_FILES), Paramstr(0)) then
    begin
      // Nemp liegt im System-Programmverzeichnis
      SavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
      try
        ForceDirectories(SavePath);
      except
        SavePath := ExtractFilePath(ParamStr(0));
      end;

    end else
    begin
      // Nemp liegt woanders
      SavePath := ExtractFilePath(ParamStr(0));
    end;

    // Hook-Funktionen initialisieren
    lib := LoadLibraryW(PWideChar(ExtractFilePath(Paramstr(0))+'KBHook.dll'));
    if lib <> INVALID_HANDLE_VALUE then
    begin
      InstallHook := GetProcAddress(lib, 'InstallHook');
      UnInstallHook := GetProcAddress(lib, 'UninstallHook');
    end;

    NempPlayer := TNempPlayer.Create(Handle);
    NempPlayer.Statusproc := StatusProc;

    NempPlaylist := TNempPlaylist.Create;
    NempPlaylist.VST := PlaylistVST;
    NempPlaylist.Player := NempPlayer;
    NempPlaylist.MainWindowHandle := Handle;

    BibRatingHelper := TRatingHelper.Create;
    MedienBib := TMedienBibliothek.Create(self.Handle, PanelCoverBrowse.Handle);
    MedienBib.BibScrobbler := NempPlayer.NempScrobbler;
    MedienBib.TagCloud.CloudPainter.Canvas := CloudViewer.Canvas;
    //MedienBib.TagCloud.CloudPainter.Canvas := PanelTagCloudBrowse.Canvas;
    //MedienBib.MainWindowHandle := Handle;
    MedienBib.SavePath := SavePath;
    MedienBib.CoverSavePath := SavePath + 'Cover\';


    MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
    MedienBib.NewCoverFlow.CoverSavePath := MedienBib.CoverSavePath;

            // needed for ClassicFlow
            MedienBib.NewCoverFlow.MainImage := IMGMedienBibCover;
            MedienBib.NewCoverFlow.ScrollImage := ImgScrollCover;

            // Needed for FlyingCow
            MedienBib.NewCoverFlow.Window := PanelCoverBrowse.Handle ;
            MedienBib.NewCoverFlow.events_window := Self.Handle;

    try
      ForceDirectories(MedienBib.CoverSavePath);
    except
      if not DirectoryExists(MedienBib.CoverSavePath) then
        MedienBib.CoverSavePath := MedienBib.SavePath;
    end;

    // Skin-System initialisieren
    NempSkin := TNempSkin.create;
    PlayListSkinImageList := TImageList.Create(Nemp_MainForm);
    PlayListSkinImageList.Height := 14;
    PlayListSkinImageList.Width := 14;

    if Assigned(FSplash) then
    begin
      FSplash.StatusLBL.Caption := (SplashScreen_LoadingPreferences);
      FSplash.Update;
    end;

    ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
    try
        ini.Encoding := TEncoding.UTF8;

        tmpLastExitOK := ini.ReadBool('Allgemein', 'LastExitOK', True);
        ReadNempOptions(ini, NempOptions);
        if (NempOptions.Language <> '') and (NempOptions.Language <> GetCurrentLanguage) then
          Uselanguage(NempOptions.Language);
        //Player-Einstellungen lesen
        NempPlayer.LoadFromIni(Ini);
{...}        //Player initialisieren
        NempPlayer.InitBassEngine(Handle, ExtractFilePath(ParamStr(0)), tmpwstr);
        // VCL an den Player anpassen
        PlaylistDateienOpenDialog.Filter := tmpwstr;
        CorrectVolButton;
        CorrectHallButton;
        CorrectEchoButtons;
        CorrectSpeedButton;
        for i := 0 to 9 do CorrectEQButton(i);
        // TabStops setzen
        SetTabStopsPlayer;
        SetTabStopsTabs;

        // Hier auch Scrobbler.Checked setzen
        MM_T_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;
        PM_P_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;

        //Playlist-Einstellungen laden
        NempPlaylist.LoadFromIni(Ini);
        PlaylistVST.ShowHint := NempPlaylist.ShowHintsInPlaylist;
        // MedienBib-Einstellungen laden
        MedienBib.LoadFromIni(Ini);
        CB_MedienBibGlobalQuickSearch.OnClick := Nil;
//////        CB_MedienBibGlobalQuickSearch.Checked := MedienBib.BibSearcher.QuickSearchOptions.GlobalQuickSearch;
        CB_MedienBibGlobalQuickSearch.OnClick := CB_MedienBibGlobalQuickSearchClick;     //Quicksearch (library)

        EditFastSearch.Text := MainForm_GlobalQuickSearch;

        VST.ShowHint := MedienBib.ShowHintsInMedialist;

        UseSkin             := ini.ReadBool('Fenster', 'UseSkin', True);
        SkinName            := ini.ReadString('Fenster','SkinName','<public> Nemp3');

        for i:=0 to Spaltenzahl-1 do
        begin
            s := ini.ReadInteger('Spalten','Inhalt' + IntToStr(i), DefaultSpalten[i].Inhalt);
            VST.Header.Columns[i].Text := _(DefaultSpalten[s].Bezeichnung);
            VST.Header.Columns[i].Tag := s;

            if ini.readbool('Spalten','visible' + IntToStr(i), DefaultSpalten[i].visible) then
                VST.Header.Columns[i].Options := VST.Header.Columns[i].Options + [coVisible]
            else
                VST.Header.Columns[i].Options := VST.Header.Columns[i].Options - [coVisible];

            VST.Header.Columns[i].Width := ini.ReadInteger('Spalten','Breite' + IntToStr(i), DefaultSpalten[i].width);

            aMenuItem := TMenuItem.Create(Nemp_MainForm);
            aMenuItem.AutoHotkeys := maManual;
            aMenuItem.AutoCheck := True;
            aMenuItem.Tag := i;
            aMenuItem.OnClick := VST_ColumnPopupOnClick;
            aMenuItem.Caption := _(DefaultSpalten[s].Bezeichnung);
            VST_ColumnPopup.Items.Insert(i, aMenuItem);
        end;

        ini.ReadInteger('Spalten','BreiteCover', 250);

        // Initialisierung des Hooks
        if lib <> INVALID_HANDLE_VALUE then
        begin
          SchonMalEineMediaTasteGedrueckt := ini.ReadBool('Multimediatasten','BereitsGedrueckt',False);
          DoHookInstall := ini.ReadBool('Multimediatasten','HookInstall',False);
          if DoHookInstall then
          begin
            InstallHook(Nemp_MainForm.Handle);
            HookIsInstalled := True;
          end else
          begin
            HookIsInstalled := False;
          end;
          MediaCount := 0;
          MediaTest := False;
        end
        else begin
          SchonMalEineMediaTasteGedrueckt := True;
          DoHookInstall := False;
        end;

        NempUpdater := TNempUpdater.Create(Handle);
        NempUpdater.LoadFromIni(Ini);

        NempSkin.NempPartyMode.LoadFromIni(ini);

        // AnzeigeModus (Das "i" in der NempFormAufteilung)
        AnzeigeMode := (Ini.ReadInteger('Fenster', 'Anzeigemode', 0)) Mod 2; // 0 oder 1, was anderes gibts nicht mehr.

        Tag := -1;

        // Jetzt: False reinschreiben
        // Das wird erst am Ende wieder "gut gemacht" ;-)
        ini.WriteBool('Allgemein', 'LastExitOK', False);
        ini.Encoding := TEncoding.UTF8;
        try
            Ini.UpdateFile;
        except
            // Silent Exception
        end;
    finally
        ini.Free
    end;

    Top := NempOptions.NempFormAufteilung[AnzeigeMode].FormTop;
    Left := NempOptions.NempFormAufteilung[AnzeigeMode].FormLeft;
    Height := NempOptions.NempFormAufteilung[AnzeigeMode].FormHeight;
    Width := NempOptions.NempFormAufteilung[AnzeigeMode].FormWidth;

    // Optionen verarbeiten, Variablen entsprechend setzen
    PM_P_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
    MM_O_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;

    AutoShowDetailsTMP := NempOptions.AutoShowDetails;

    // Men�eintr�ge checken//unchecken
    PM_P_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
    PM_P_ViewSeparateWindows_Playlist.Checked  := NempOptions.NempEinzelFormOptions.PlaylistVisible;
    PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
    PM_P_ViewSeparateWindows_Browse.Checked    := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

    MM_O_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
    MM_O_ViewSeparateWindows_Playlist.Checked  := NempOptions.NempEinzelFormOptions.PlaylistVisible;
    MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
    MM_O_ViewSeparateWindows_Browse.Checked    := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

    if NempOptions.FullRowSelect then
      VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions + [toFullRowSelect]
    else
      VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions - [toFullRowSelect];

    ArtistsVST.DefaultNodeHeight := NempOptions.ArtistAlbenRowHeight;
    AlbenVST.DefaultNodeHeight   := NempOptions.ArtistAlbenRowHeight;
    ArtistsVST.Font.Size := NempOptions.ArtistAlbenFontSize;
    AlbenVST.Font.Size   := NempOptions.ArtistAlbenFontSize;
    VST.DefaultNodeHeight         := NempOptions.RowHeight;
    PlaylistVST.DefaultNodeHeight := NempOptions.RowHeight;
    if NempOptions.ChangeFontSizeOnLength then
    begin
        maxFont := NempOptions.FontSize[1];
        if NempOptions.FontSize[2] > maxFont then maxFont := NempOptions.FontSize[2];
        if NempOptions.FontSize[3] > maxFont then maxFont := NempOptions.FontSize[3];
        if NempOptions.FontSize[4] > maxFont then maxFont := NempOptions.FontSize[4];
        if NempOptions.FontSize[5] > maxFont then maxFont := NempOptions.FontSize[5];
    end
    else
      maxFont := NempOptions.DefaultFontSize;

    PlaylistVST.Canvas.Font.Size := maxFont;
    PlaylistVST.Header.Columns[1].Width := PlaylistVST.Canvas.TextWidth('mmm:mm');
    VST.Font.Size:=NempOptions.DefaultFontSize;
    PlaylistVST.Font.Size:=NempOptions.DefaultFontSize;
    if Screen.Fonts.IndexOf(NempOptions.FontNameVBR) = -1 then
      NempOptions.FontNameVBR := VST.Font.Name;
    if Screen.Fonts.IndexOf(NempOptions.FontNameCBR) = -1 then
      NempOptions.FontNameCBR := VST.Font.Name;
    case NempPlaylist.WiedergabeMode of
        0: begin
              RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatAll);
        end;
        1: begin
              RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatTitle);
        end;
        2: begin
              RandomBtn.Hint := (MainForm_RepeatBtnHint_RandomMode);
        end
        else begin
              RandomBtn.Hint := (MainForm_RepeatBtnHint_NoRepeat);
        end;
    end;

    BassTimer.Interval := NempPlayer.VisualizationInterval;
    AutoSavePlaylistTimer.Enabled := NempPlaylist.AutoSave;
    AutoSavePlaylistTimer.Interval := 5 * 60000;

    if NempOptions.RegisterHotKeys then
        InstallHotkeys (SavePath, Handle);

    ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        InitEqualizerMenuFormIni(ini);
        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;

    finally
        ini.Free
    end;

    SetRecentPlaylistsMenuItems;

    if (NOT tmpLastExitOK) AND
       ( FileExists(SavePath + 'temp.npl') or
         FileExists(SavePath + 'temp.m3u8') or
         FileExists(SavePath + 'temp.m3u'))
    then begin
            if Assigned(FSplash) then
            begin
                FSplash.StatusLBL.Caption := (SplashScreen_Loadingplaylist);
                FSplash.Update;
            end;
            if FileExists(SavePath + 'temp.npl') then
                NempPlaylist.LoadFromFile(SavePath + 'temp.npl')
            else
                if FileExists(SavePath + 'temp.m3u8') then
                    NempPlaylist.LoadFromFile(SavePath + 'temp.m3u8')
                else
                    NempPlaylist.LoadFromFile(SavePath + 'temp.m3u');
    end else // backup existiert nicht oder tmplastexit war False
    begin

        if   (FileExists(SavePath +  NEMP_NAME + '.npl')
           or FileExists(SavePath +  NEMP_NAME + '.m3u8')
           or FileExists(SavePath +  NEMP_NAME + '.m3u') ) then
        begin
            if Assigned(FSplash) then
            begin
                FSplash.StatusLBL.Caption := (SplashScreen_Loadingplaylist);
                FSplash.Update;
            end;
            if FileExists(SavePath +  NEMP_NAME + '.npl') then
                NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.npl')
            else
                if FileExists(SavePath +  NEMP_NAME + '.m3u8') then
                    NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.m3u8')
                else
                    NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.m3u');
        end;
    end;

    VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);

    DragSource := DS_EXTERN;

    Spectrum := TSpectrum.Create(PaintFrame.Width, PaintFrame.Height);
    Spectrum.MainImage := PaintFrame;
    Spectrum.TextImage := TextAnzeigeImage;
    Spectrum.TimeImage := TimePaintbox;
    Spectrum.StarImage := RatingImage;
    Spectrum.Mode := 1;
    //Spectrum.Height := PaintFrame.Height;
    Spectrum.LineFallOff := 7;
    Spectrum.PeakFallOff := 1;
    Spectrum.Pen := clActiveCaption;
    Spectrum.Peak := clBackground;
    Spectrum.BackColor := clBtnFace;
    Spectrum.TimebackColor := Spectrum.BackColor;
    Spectrum.TitelbackColor := Spectrum.BackColor;
    Spectrum.TextColor := clWindowText;
    Spectrum.TextPosY := 0;
    Spectrum.TextPosX := 0;
    Spectrum.ScrollDelay := NempPlayer.ScrollAnzeigeDelay;


    // Ggf. Tray-Icon erzeugen und das erzeugen in TrayIconAdded merken
    if NempOptions.NempWindowView in [NEMPWINDOW_TRAYONLY, NEMPWINDOW_BOTH, NEMPWINDOW_BOTH_MIN_TRAY] then
      NempTrayIcon.Visible := True
    else
      NempTrayIcon.Visible := False;

    NempWindowDefault := GetWindowLong(Application.Handle, GWL_EXSTYLE);
    if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
    begin
      ShowWindow( Application.Handle, SW_HIDE );
      SetWindowLong( Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
      ShowWindow( Application.Handle, SW_SHOW );
    end;


    if Assigned(FSplash) then
    begin
      FSplash.StatusLBL.Caption := (SplashScreen_SearchSkins);
      FSplash.Update;
    end;
    // Skin-MenuItems setzen
    if (FindFirst(GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\'+'*',faDirectory,SR)=0) then
    repeat
      if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
      begin
        tmpstr :=  StringReplace('<private> ' + Sr.Name,'&','&&',[rfReplaceAll]);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := SkinAn1Click;
        aMenuItem.Caption := tmpstr; //'<private> ' + Sr.Name;
        PM_P_Skins.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := SkinAn1Click;
        aMenuItem.Caption := tmpstr; //'<private> ' + Sr.Name;
        MM_O_Skins.Add(aMenuItem);
      end;
    until FindNext(SR)<>0;
    FindClose(SR);

    if (FindFirst(ExtractFilePath(Paramstr(0)) + 'Skins\' +'*',faDirectory,SR)=0) then
    repeat
      if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
      begin
        tmpstr :=  StringReplace('<public> ' + Sr.Name,'&','&&',[rfReplaceAll]);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := SkinAn1Click;
        aMenuItem.Caption := tmpstr; ///'<public> ' + Sr.Name;
        PM_P_Skins.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := SkinAn1Click;
        aMenuItem.Caption := tmpstr; ///'<public> ' + Sr.Name;
        MM_O_Skins.Add(aMenuItem);
      end;
    until FindNext(SR)<>0;
    FindClose(SR);

    // installierte Sprachen suchen
    LanguageList := TStringlist.Create;
    DefaultInstance.GetListOfLanguages ('default',LanguageList);
    for i := 0 to LanguageList.Count - 1 do
    begin
        tmpstr := getlanguagename(LanguageList[i]);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := ChangeLanguage;
        if  tmpstr <> '' then
          aMenuItem.Caption := tmpstr
        else
          aMenuItem.Caption := '(?)';
        aMenuItem.Tag := i;
        MM_O_Languages.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := ChangeLanguage;
        if  tmpstr <> '' then
          aMenuItem.Caption := tmpstr
        else
          aMenuItem.Caption := '(?)';
        aMenuItem.Tag := i;
        PM_P_Languages.Add(aMenuItem);
    end;
  Spectrum.DrawClear;
  NewPlayerPanel.DoubleBuffered := True;
end;


procedure TNemp_MainForm.PanelTagCloudBrowseClick(Sender: TObject);
begin
    MedienBib.TagCloud.FocussedTag := MedienBib.TagCloud.MouseOverTag;
    MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, False);
end;

procedure TNemp_MainForm.PanelTagCloudBrowseDblClick(Sender: TObject);
begin
    MedienBib.TagCloud.FocussedTag := MedienBib.TagCloud.MouseOverTag;
    MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, True);
    MedienBib.TagCloud.  ShowTags;//(ListView1);
end;


procedure TNemp_MainForm.PanelTagCloudBrowseMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var aTag: TPaintTag;
begin
    aTag := MedienBib.TagCloud.CloudPainter.GetTagAtMousePos(x,y);

    if (aTag <> MedienBib.TagCloud.MouseOverTag) and assigned(aTag) then
    begin

        MedienBib.TagCloud.CloudPainter.RePaintTag(MedienBib.TagCloud.MouseOverTag, False);
        MedienBib.TagCloud.MouseOverTag := aTag;
        MedienBib.TagCloud.CloudPainter.RePaintTag(MedienBib.TagCloud.MouseOverTag, True);

        //if assigned(aTag) then
        //    caption := aTag.key + ' - ' + IntToStr(aTag.count) + 'index: ' + IntToStr(aTag.BreadCrumbIndex);
    end;
end;

procedure TNemp_MainForm.PanelTagCloudBrowsePaint(Sender: TObject);
begin
    MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);
end;

procedure TNemp_MainForm.PanelTagCloudBrowseResize(Sender: TObject);
begin
    MedienBib.TagCloud.CloudPainter.Height := CloudViewer.Height;
    MedienBib.TagCloud.CloudPainter.Width := CloudViewer.Width;
    MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);
end;


procedure TNemp_MainForm.CloudTestKey(Sender: TObject; var Key: Char);
begin
    if ord(Key) = vk_return then
    begin
        MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, True);
        MedienBib.TagCloud.ShowTags;//(ListView1);
    end;
end;

procedure TNemp_MainForm.CloudTestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    MedienBib.TagCloud.NavigateCloud(Key, Shift);
    case key of
        vk_Escape,
        vk_Back: begin
                MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, True);
                MedienBib.TagCloud.ShowTags;
        end
    else
        MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, False);
    end;
end;

procedure TNemp_MainForm.CloudAfterPaint(Sender: TObject);
begin


    if Not NempSkin.isActive then
        MedienBib.TagCloud.CloudPainter.PaintAgain;
end;

procedure TNemp_MainForm.CloudPaint(Sender: TObject);
begin
  caption := IntToStr(random(high(integer)));
  MedienBib.TagCloud.CloudPainter.PaintAgain;
end;

procedure TNemp_MainForm.PanelTagCloudBrowseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CloudViewer.SetFocus;
end;


procedure TNemp_MainForm.FormCreate(Sender: TObject);

begin
  // Nothing to do here. Will be done in nemp.dpr

  //showmessage('sdsd');
  CloudViewer := TCloudViewer.Create(self);
  CloudViewer.Parent := PanelTagCloudBrowse;

 // CloudViewer.Left := 0;
 // CloudViewer.Top := 29;
 // CloudViewer.Width := PanelTagCloudBrowse.Width;
 // CloudViewer.Height := PanelTagCloudBrowse.Height - 29;

 // CloudViewer.Anchors := [akLeft, akTop, akBottom, akRight];

   CloudViewer.Align := alClient;


  CloudViewer.TabStop := True;

  CloudViewer.OnKeypress := CloudTestKey;
  CloudViewer.OnKeyDown := CloudTestKeyDown;


  CloudViewer.OnMouseMove := PanelTagCloudBrowseMouseMove;
  CloudViewer.OnClick := PanelTagCloudBrowseClick;
  CloudViewer.OnDblClick := PanelTagCloudBrowseDblClick;

  CloudViewer.OnMouseDown := PanelTagCloudBrowseMouseDown;

  CloudViewer.OnResize := PanelTagCloudBrowseResize;

  CloudViewer.OnPaint := CloudPaint;
  CloudViewer.OnAfterPaint := CloudAfterPaint;

end;

procedure TNemp_MainForm.FormShow(Sender: TObject);
begin
  // StuffToDoAfterCreate;
  // Nothing to do here. Will be done in nemp.dpr
  FSplash.Close;

end;

Procedure TNemp_MainForm.StuffToDoAfterCreate;
var
  tmpstr: UnicodeString;
begin
  if NempOptions.ShowDeskbandOnStart then
  begin
    NotifyDeskband(NempDeskbandActivateMessage);
  end;

  if Useskin then
  begin
    tmpstr := StringReplace(SkinName,
              '<public> ', ExtractFilePath(Paramstr(0)) + 'Skins\', []);
    tmpstr := StringReplace(tmpstr,
              '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);
    Nempskin.LoadFromDir(tmpstr);
    NempSkin.ActivateSkin;
    RandomBtn.GlyphLine := NempPlaylist.WiedergabeMode;
  end else
  begin
    NempSkin.DeActivateSkin;

    TabBtn_Equalizer.ResetGlyph;

  end;

  if Assigned(FSplash) then
  begin
    FSplash.StatusLBL.Caption := (SplashScreen_InitPlayer);
    FSplash.Update;
  end;

  NempOptions.StartMinimizedByParameter := False;

  if (ParamCount = 0) or (trim(paramstr(1)) = '/minimized') then
  begin
      //showmessage('Da');
      if trim(paramstr(1)) = '/minimized' then
      begin
          //showmessage('Auch Da');
          NempOptions.StartMinimizedByParameter := True;
      end;
      InitPlayingFile(NempPlaylist.AutoplayOnStart, True);
  end else
  begin
      //
      if NempPlaylist.AutoPlayNewTitle then
      begin
        // Letzten Index merken
        BackupPlayingIndex := NempPlaylist.PlayingIndex;
        // Index auf den neuen Titel setzen, der aber nicht nicht in der Liste drin ist!
        NempPlaylist.PlayingIndex := NempPlaylist.Count; // Ja, nicht ..-1, es kommt ja wahrscheinlich einer dazu ;-)
      end;

      if ParamCount >= 2 then
      begin
          if trim(paramstr(1)) = '/play' then                             // Hier wirklich Startplay = True
              ProcessCommandline(paramstr(2), True, False)               // Das bewirkt, dass das Playingfile gesetzt
          else                                                            // wird. Wenn Autoplay True ist, wird
              if trim(paramstr(1)) = '/enqueue' then                      // die Wiedergabe gestartet, sonst nicht!!
                  ProcessCommandline(paramstr(2), True, True);
      end else
      begin
          ProcessCommandline(paramstr(1), True, True);
      end;
  end;

  if Assigned(FSplash) then
  begin
    FSplash.StatusLBL.Caption := (SplashScreen_LoadingMediaLib);
    FSplash.Update;
  end;

  // Anzeige oben links initialisieren
  SwitchBrowsePanel(MedienBib.BrowseMode);
  // Medienliste laden
  if MedienBib.AutoLoadMediaList then // AND (FileExists(SavePath + NEMP_NAME + '.gmp')) then
  begin
      MedienBib.LoadFromFile(SavePath + NEMP_NAME + '.gmp');
  end
  else
  begin
      case MedienBib.BrowseMode of
          0 : MedienBib.ReBuildBrowseLists;

          1: begin
              MedienBib.ReBuildCoverList;
              MedienBib.CurrentArtist := BROWSE_ALL;
              MedienBib.CurrentAlbum := BROWSE_ALL;
              If MedienBib.Coverlist.Count > 3 then
                CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
              else
                CoverScrollbar.Max := 3;
              CoverScrollbarChange(Nil);
          end;
          2: begin
                MedienBib.ReBuildTagCloud;
                MedienBib.TagCloud.ShowTags;
                MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.ClearTag, True);
          end;
      end;
      if FileExists(ExtractFilePath(ParamStr(0)) + 'default.nwl') then
              MedienBib.ImportFavorites(ExtractFilePath(ParamStr(0)) + 'default.nwl')
          else
              if FileExists(SavePath + 'default.nwl') then
                  MedienBib.ImportFavorites(SavePath + 'default.nwl');
      ReFillBrowseTrees(False);
  end;
  ReadyForgetFileApiCommands := True;

  if assigned(FSplash) then
  begin
    FSplash.StatusLBL.Caption := (SplashScreen_GenerateWindows);
    FSplash.Update;
  end;
  // nicht nochmla machen, da hier ;-)
  //  Nemp_MainForm.OnShow := Nil;

  UpdateFormDesignNeu;
  ActualizeVDTCover;
  ReTranslateNemp(GetCurrentLanguage);
  Spectrum.DrawClear;
  ReInitPlayerVCL;
  ReArrangeToolImages;

  if NempSkin.isActive then
      NempSkin.SetVSTOffsets;

  AcceptApiCommands := True;
  EditFastSearch.OnChange := EDITFastSearchChange;

  NempPlaylist.UpdatePlayListHeader(PlaylistVST, NempPlaylist.Count, NempPlaylist.Dauer);

  NempWebServer := TNempWebServer.Create(Nemp_MainForm.Handle);
  NempWebServer.SavePath := SavePath;
  NempWebServer.CoverSavePath := MedienBib.CoverSavePath;

  EdtBibGenre.Items := Genres;
  //NempWebServer.LoadfromIni;
  // Das war hier wegen. ServerAutoActivate.
  // Aber: Das sollte eine Eigenschaft der MedienBib sein
  //       Denn die muss das anleiern, wenn der Startvorgang komplett ist.
  // DAher: Server.LoadFromIni erst dann.
end;

procedure TNemp_MainForm.TntFormClose(Sender: TObject; var Action: TCloseAction);
    var i:integer;
    ini:TMemIniFile;
    s:integer;
    PosAndSize : PWindowPlacement;
begin
    NempIsClosing := True;

    NempWebServer.Free;

    AcceptApiCommands := False;
    AuswahlStatusLBL.Caption := (MainForm_ShuttingDownHint);
    AuswahlStatusLBL.Update;

    GetMem(PosAndSize,SizeOf(TWindowPlacement));
    try
      PosAndSize^.Length := SizeOf(TWindowPlacement);
      if GetWindowPlacement(Handle,PosAndSize) then
      begin
        NempOptions.NempFormAufteilung[Tag].FormWidth := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
        NempOptions.NempFormAufteilung[Tag].FormHeight := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
        NempOptions.NempFormAufteilung[Tag].FormTop := PosAndSize^.rcNormalPosition.Top;
        NempOptions.NempFormAufteilung[Tag].FormLeft := PosAndSize^.rcNormalPosition.Left;
      end;
    finally
      FreeMem(PosAndSize,SizeOf(TWindowPlacement))
    end;
    NempOptions.NempFormAufteilung[Tag].TopMainPanelHeight := TopMainPanel.Height;
    NempOptions.NempFormAufteilung[Tag].AuswahlPanelWidth  := AuswahlPanel.Width;
    NempOptions.NempFormAufteilung[Tag].ArtistWidth        := ArtistsVST.Width;
    NempOptions.NempFormAufteilung[Tag].Maximized          := WindowState = wsMaximized;
    NempOptions.CoverWidth := VDTCover.Width;

    ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
    try
        ini.Encoding := TEncoding.UTF8;
        WriteNempOptions(ini, NempOptions);

        Ini.WriteInteger('Fenster', 'Anzeigemode', AnzeigeMode);
        ini.WriteBool('Fenster', 'UseSkin', UseSkin);
        ini.WriteString('Fenster','SkinName', SkinName);

        NempPlayer.WriteToIni(Ini);
        NempPlaylist.WriteToIni(Ini);
        MedienBib.WriteToIni(Ini);
        NempUpdater.WriteToIni(Ini);

        NempSkin.NempPartyMode.WriteToIni(ini);

        for i:=0 to Spaltenzahl-1 do
        begin
            s := GetColumnIDfromPosition(VST, i);
            ini.WriteInteger('Spalten', 'Inhalt' + IntToStr(i), VST.Header.Columns[s].Tag);
            ini.Writebool('Spalten', 'visible'  + IntToStr(i), (coVisible in VST.Header.Columns[s].Options));
            ini.WriteInteger('Spalten', 'Breite' + IntToStr(i), VST.Header.Columns[s].Width);
        end;

        ini.Writebool('Multimediatasten','BereitsGedrueckt',SchonMalEineMediaTasteGedrueckt);
        ini.Writebool('Multimediatasten','HookInstall',DoHookInstall);
        ini.WriteBool('Allgemein', 'LastExitOK', True);

        ini.Encoding := TEncoding.UTF8;
        try
            Ini.UpdateFile;
        except
            // Silent Exception
        end;
    finally
        ini.Free
    end;

    // PlayList abspeichern
    NempPlaylist.SaveToFile(SavePath + NEMP_NAME + '.npl', True);

    // Do not Postprocess files any longer
    NempPlayer.LastUserWish := USER_WANT_STOP;
    NempPlayer.PostProcessor.NempIsClosing := True;

    NempPlaylist.Stop;
    bassTimer.Enabled :=False;

    visible := False;
    if assigned(FDetails) then FDetails.Hide;
    if assigned(Auswahlform) then Auswahlform.Hide;
    if assigned(MedienlisteForm) then MedienlisteForm.Hide;
    if assigned(PlaylistForm) then PlaylistForm.Hide;
    if assigned(ExtendedControlForm) then ExtendedControlForm.Hide;

    if NempOptions.HideDeskbandOnClose then
        NotifyDeskband(NempDeskbandDeActivateMessage);

    if MedienBib.AutoSaveMediaList AND (MedienBib.Count > 0) AND (MedienBib.Changed) then
    begin
      AuswahlStatusLBL.Caption := (MainForm_ShuttingDownHint_MediaLib);
      AuswahlStatusLBL.Update;
      MedienBib.SaveToFile(SavePath + NEMP_NAME + '.gmp', True);
    end;

    PlaylistPanel.Parent := Nemp_MainForm;
    AuswahlPanel.Parent := Nemp_MainForm;
    VSTPanel.Parent := Nemp_MainForm;

    AudioPanel.Parent := PlayerPanel;
    AudioPanel.Left := 2;
    AudioPanel.Top := 121;

    CoverScrollbar.WindowProc := OldScrollbarWindowProc;
    LyricsMemo.WindowProc := OldLyricMemoWindowProc;

    // Kopie ausm Destroy
    if HookIsInstalled then UninstallHook;

    ST_Playlist.Free;
    ST_Medienliste.Free;
    FreeAndNil(DragDropList);

    Set8087CW(Default8087CW);

    for i := 0 to 9 do
      UnRegisterHotkey(Handle, i);

end;

procedure TNemp_MainForm.WMQueryEndSession(var M: TWMQueryEndSession);
var aAction: TCloseAction;
begin
  MedienBib.Abort;
  ST_Playlist.Break;
  ST_Medienliste.Break;
  LangeAktionWeiterMachen := False;
  M.Result := 1;
  TntFormClose(Nil, aAction);
  self.OnClose := Nil;
end;

procedure TNemp_MainForm.WMStartEditing(var Msg: TMessage);
var aNode: PVirtualNode;
begin
    aNode := Pointer(Msg.WParam);
    VST.EditNode(aNode, Msg.LParam);

end;

procedure TNemp_MainForm.WMEndSession(var M: TWMEndSession);
begin
  M.Result := 0;

  close;
end;

procedure TNemp_MainForm.DeactivateNemp(Sender: TObject);
begin
    ClipCursor(Nil);
end;


procedure TNemp_MainForm.NewSelected (Var Msg: TMessage);
var aCover: tNempCover;
begin
    CoverScrollBar.OnChange := Nil;
    if CoverScrollbar.Position <> Msg.WParam then
    begin
        CoverScrollbar.Position := Msg.WParam;
        if CoverScrollbar.Position <= MedienBib.Coverlist.Count -1 then
        begin
            aCover := TNempCover(MedienBib.CoverList[CoverScrollbar.Position]);
            MedienBib.GenerateAnzeigeListeFromCoverID(aCover.ID);
            Lbl_CoverFlow.Caption := aCover.InfoString;
        end;
    end;
    CoverScrollbar.OnChange := CoverScrollbarChange;
end;

procedure TNemp_MainForm.NeedPreview (var msg : TWMFCNeedPreview);
var
    aCover: tNempCover;
    bmp: TBitmap;
begin
  if NempIsClosing then exit;

  bmp := TBitmap.Create;
  try
      bmp.PixelFormat := pf24bit;
      bmp.Height := 240;
      bmp.Width := 240;

      if MedienBib.CoverList.Count > msg.Index then
      begin
          aCover := TNempCover(MedienBib.CoverList[msg.Index]);

          GetCoverBitmapFromID(aCover.ID, bmp, MedienBib.CoverSavePath);
       
          Medienbib.NewCoverFlow.SetPreview (msg.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);
      end;
  finally
      bmp.free;
  end;
end;


procedure TNemp_MainForm.MinimizeNemp(Sender: TObject);
begin
  // NEMPWINDOW_ONLYTASKBAR = 0;
  // NEMPWINDOW_TASKBAR_MIN_TRAY = 1;
  // NEMPWINDOW_TRAYONLY = 2;
  // NEMPWINDOW_BOTH = 3;
  // NEMPWINDOW_BOTH_MIN_TRAY = 4;

  // nur minimiert im Tray: Icon erzeugen
  if NempOptions.NempWindowView = NEMPWINDOW_TASKBAR_MIN_TRAY then
    NempTrayIcon.Visible := True;

  if NempOptions.NempWindowView in [NEMPWINDOW_TASKBAR_MIN_TRAY, NEMPWINDOW_BOTH_MIN_TRAY, NEMPWINDOW_TRAYONLY]
  then // Taskbar-Eintrag weg, aber nur, wenn ein Icon da ist
    if NempTrayIcon.Visible then ShowWindow(Application.Handle,SW_HIDE);

  if NempOptions.ShowDeskbandOnMinimize then
    NotifyDeskband(NempDeskbandActivateMessage);

  MinimizedIndicator := True;
end;

procedure TNemp_MainForm.NewScrollBarWndProc(var Message: TMessage);
var z: smallint;
begin
  case Message.Msg of
    WM_MouseWheel: begin
      z := hiWord(Message.wParam);
      if z > 0 then
        CoverScrollbar.Position := CoverScrollbar.Position - 1
      else
        CoverScrollbar.Position := CoverScrollbar.Position + 1;

      MedienBib.NewCoverFlow.CurrentItem := CoverScrollbar.Position;
    end;
  end;
  OldScrollbarWindowProc(Message);
end;


procedure TNemp_MainForm.NewLyricMemoWndProc(var Message: TMessage);
var z: smallint;
begin
    case Message.Msg of
    WM_MouseWheel: begin
      z := hiWord(Message.wParam);
      if z > 0 then
          SendMessage(LyricsMemo.Handle, WM_VSCROLL, SB_LINEUP, 0)
      else
          SendMessage(LyricsMemo.Handle, WM_VSCROLL, SB_LINEDown, 0);
    end;
  end;
    OldLyricMemoWindowProc(Message);
end;


procedure TNemp_MainForm.RestoreNemp;

Procedure ShowApplication;
Var 
  Thread1, 
  Thread2: Cardinal;
Begin 
  Thread1 := GetCurrentThreadId;
  Thread2 := GetWindowThreadProcessId (GetForegroundWindow, nil); 
  AttachThreadInput (Thread1, Thread2, true); 
  Try
    SetForegroundWindow (Application.Handle); 
  Finally 
    AttachThreadInput (Thread1, Thread2, false); 
  End;
  if NempOptions.HideDeskbandOnRestore then
    NotifyDeskband(NempDeskbandDeActivateMessage);
End;

begin
  // NEMPWINDOW_ONLYTASKBAR = 0;
  // NEMPWINDOW_TASKBAR_MIN_TRAY = 1;
  // NEMPWINDOW_TRAYONLY = 2;
  // NEMPWINDOW_BOTH = 3;
  // NEMPWINDOW_BOTH_MIN_TRAY = 4;

  if NempOptions.NempWindowView = NEMPWINDOW_TASKBAR_MIN_TRAY then
      NempTrayIcon.Visible := False;

  ShowWindow (Application.Handle, SW_RESTORE);
  SetForegroundWindow(Nemp_MainForm.Handle);

  //if Tag = 3 then 
    RepairZOrder;

  MinimizedIndicator := False;

  Show;
  ShowApplication;

  Application.ShowMainForm := True;
end;

procedure TNemp_MainForm.ProcessCommandline(lpData: Pointer; StartPlay: Boolean);
var filename: String;
  idx: Integer;
  enqueue: Boolean;
begin
  filename := Trim(ParamBlobToStr(lpData));

  enqueue := True;

  if length(filename) > 1 then
  begin
      if filename[1] = '/' then
      begin
        idx := Pos('/play', filename);
        if idx > 0 then
        begin
          filename := Copy(filename, 8, length(filename));
          enqueue := False;
        end
        else
        begin
          idx := Pos('/enqueue', filename);
          if idx > 0 then
            filename := Copy(filename, 11, length(filename))

          else
              // unbekannter Paramter, oder '/minimized'
              filename := '';
        end;
      end;
  end else
      PlayPauseBtn.Click;

  if Not Enqueue then
  begin
    ProcessCommandline(filename, True, enqueue);
  end
  else
  begin
    ProcessCommandline(filename, Startplay, enqueue);
  end;
end;

procedure TNemp_MainForm.ProcessCommandline(filename: UnicodeString; StartPlay: Boolean; Enqueue: Boolean);
var extension: string;
begin
  // �ber die Commandline kommen nur SAchen f�r die Playlist
  // Zumindest bisher (2.5d, f�r die n�chste Version ist auch nichts anderes geplant)
  if (ST_Playlist.IsSearching)  then exit;

  ReallyClearPlaylistTimer.Enabled := False;
  //Weiter unten wieder starten...

  // Verzeichnisse rekursiv durchsuchen lassen.
  // Start des Abspielens wird dort erledigt.
  if (FileGetAttr(fileName) AND faDirectory) = faDirectory then
  begin
      if not Enqueue then
      begin
        NempPlaylist.ClearPlaylist;
      end;
      NempPlaylist.Status := 1;
      NempPlaylist.InsertNode := NIL;
      NempPlaylist.ST_Ordnerlist.Add(filename);
      ST_Playlist.Mask := GeneratePlaylistSTFilter;
      if  (NempPlaylist.ST_Ordnerlist.Count > 0) And (Not ST_Playlist.IsSearching) then
      begin
          ST_Playlist.SearchFiles(NempPlaylist.ST_Ordnerlist[0]);
      end;
  end
  else
  begin
      extension := AnsiLowerCase(ExtractFileExt(filename));
      if ValidAudioFile(filename, True) then
        begin
          // Parameter immer an die Playlist anh�ngen
          If Not NempPlaylist.ProcessingBufferlist then
          begin
              NempPlaylist.BufferStringList.Add(filename);
          end;
          NempPlaylist.LastCommandWasPlay := Not Enqueue;
        end // if valid AudioFile
        else if (extension = '.m3u') or (extension = '.m3u8') or (extension = '.pls') or (extension = '.npl')
                or (extension = '.asx') or (extension = '.wax') then
            begin
              NempPlaylist.LoadFromFile(filename);
              if Startplay then
              begin
                InitPlayingFile(NempPlaylist.AutoplayOnStart);
              end;
            end
            else
                if (AnsiLowerCase(ExtractFileExt(filename))='.cue') then
                begin
                  LoadCueSheet(filename);
                  if Startplay then
                  begin
                      InitPlayingFile(NempPlaylist.AutoplayOnStart);
                  end;
                end;
  end;
  // Timer wieder starten
  ReallyClearPlaylistTimer.Enabled := True;
end;

procedure TNemp_MainForm.HandleRemoteFilename(filename: UnicodeString; Mode: Integer);
begin
  if Mode = PLAYER_PLAY_FILES then
    NempPlaylist.ClearPlaylist;

  if Mode in [PLAYER_PLAY_NOW, PLAYER_PLAY_NEXT] then
    NempPlaylist.GetInsertNodeFromPlayPosition
  else
    NempPlaylist.InsertNode := NIL;

  NempPlaylist.InsertFileToPlayList(filename);

  if (Mode in [PLAYER_PLAY_NOW, PLAYER_PLAY_FILES]) AND (NempPlaylist.Count > NempPlaylist.InsertIndex-1) then
  begin
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      NempPlaylist.Play(NempPlaylist.InsertIndex-1, 0, True);
  end;
end;

procedure TNemp_MainForm.NotifyDeskband(aMsg: Integer);
var wnd: THandle;
begin
  wnd :=  FindWindow('Shell_TrayWnd', nil);
  wnd :=  FindWindowEx(wnd, 0, 'ReBarWindow32', nil);
  wnd :=  FindWindowEx(wnd, 0, 'TNempDeskBand', Nil);
  SendMessage(wnd, aMsg, GetCurrentThreadId, 0);
end;

Procedure TNemp_MainForm.NempAPI_Commands(Var aMSG: tMessage);
begin
    if aMsg.WParam = COMMAND_RESTORE then
      begin
        if MinimizedIndicator then RestoreNemp else Application.Minimize;
      end else
      begin

          if Not AcceptApiCommands then inherited
          else
          case aMSG.WParam of

          NEMP_BUTTON_PREVTITLE : PlayPrevBTNIMGClick(Nil);
          NEMP_BUTTON_PLAY      : PlayPauseBTNIMGClick(Nil);
          NEMP_BUTTON_PAUSE     : PlayPauseBTNIMGClick(Nil);
          NEMP_BUTTON_STOP      : StopBTNIMGClick(Nil);
          NEMP_BUTTON_NEXTTITLE : PlayNextBTNIMGClick(NIL);
          COMMAND_RESTORE       : if MinimizedIndicator then RestoreNemp else application.Minimize;


          NEMP_VOLUMEUP: begin
                            NempPlayer.Volume := NempPlayer.Volume + 1;
                            CorrectVolButton;
                         end;

          NEMP_VOLUMEDOWN: begin
                            NempPlayer.Volume := NempPlayer.Volume - 1;
                            CorrectVolButton;
                           end;
          else inherited;
          end
      end;
end;

Procedure TNemp_MainForm.NempAPI_UserCommands(Var aMSG: tMessage);
begin
  if Not Handle_NempAPI_UserCommands(aMSG) then
      inherited;
end;

procedure TNemp_MainForm.NempTrayIconClick(Sender: TObject);
begin
    RestoreNemp;
end;

Procedure TNemp_MainForm.MedienBibMessage(Var aMsg: TMessage);
begin
    Handle_MedienBibMessage(aMsg);
end;


Procedure TNemp_MainForm.ShoutcastQueryMessage(Var aMsg: TMessage);
begin
    Handle_ShoutcastQueryMessage(aMsg);
end;

Procedure TNemp_MainForm.WebServerMessage(Var aMsg: TMessage);
begin
    Handle_WebServerMessage(aMsg);
end;

Procedure TNemp_MainForm.UpdaterMessage(Var aMsg: TMessage);
begin
    Handle_UpdaterMessage(aMsg);
end;

Procedure TNemp_MainForm.ScrobblerMessage(Var aMsg: TMessage);
begin
    Handle_ScrobblerMessage(aMsg);
end;

procedure TNemp_MainForm.WndProc(var Message: TMessage);
begin
  if Not Handle_WndProc(Message) then
  begin
      case Message.Msg of
          Wm_Syscommand:
          begin
              inherited WndProc(Message);
              case Message.WParam of
                  SC_MAXIMIZE:
                        begin
                            MinimizedIndicator := False;
                            if NempSkin.isActive then
                              NempSkin.FitSkinToNewWindow;
                            Message.Result := 0;
                        end;
                  SC_Restore:
                        begin
                            MinimizedIndicator := False;
                            if NempSkin.isActive then
                              NempSkin.FitSkinToNewWindow;
                            Message.Result := 0;
                        end;
              end;
          end;
      else
          if Message.Msg = SecondInstMsgId then
            PostThreadMessage(Message.WParam, SecondInstMsgId, Handle, 0)
          else
            inherited WndProc(Message);
      end;
  end;
end;


procedure TNemp_MainForm.WMCopyData(var Msg: TWMCopyData);
var IncomingPChar:PChar;
    IncomingPWideChar: PWideChar;
    mode: Integer;
begin
  if (MsG.CopyDataStruct.dwData = SecondInstMsgId) AND (SecondInstMsgId <> 0) then
  begin
      ProcessCommandline(Msg.CopyDataStruct.lpData, False) // False: Nicht Play
  end;
  ;//else

  if NOT AcceptApiCommands then inherited
  else
    case MsG.CopyDataStruct.dwData of
        IPC_SEND_SEARCHSTRING: if ReadyForGetFileApiCommands then begin
                  IncomingPChar := PChar(Msg.CopyDataStruct.lpData);
                  Msg.Result := 1;
                  DoFastSearch(trim(UnicodeString(IncomingPChar)));
        end;

        IPC_SEND_FILEFORPLAYLIST..IPC_SEND_FILEFORPLAYLIST+4:
            if ReadyForGetFileApiCommands then
            begin
                    Mode := MsG.CopyDataStruct.dwData - IPC_SEND_FILEFORPLAYLIST_W;
                    if (Mode >= PLAYER_PLAY_DEFAULT) then
                      Mode := NempPlaylist.DefaultAction;
                    IncomingPChar := PChar(Msg.CopyDataStruct.lpData);
                    Msg.Result := 1;
                    HandleRemoteFilename(UnicodeString(IncomingPChar), Mode);
            end;

        // WideString-variante
        IPC_SEND_SEARCHSTRING_W: if ReadyForGetFileApiCommands then begin
                  IncomingPWideChar := PWideChar(Msg.CopyDataStruct.lpData);
                  Msg.Result := 1;
                  DoFastSearch(trim(UnicodeString(IncomingPWideChar)));
        end;

        IPC_SEND_FILEFORPLAYLIST_W..IPC_SEND_FILEFORPLAYLIST_W+4:
            if ReadyForGetFileApiCommands then
            begin
                    Mode := MsG.CopyDataStruct.dwData - IPC_SEND_FILEFORPLAYLIST_W;
                    if (Mode >= PLAYER_PLAY_DEFAULT) then
                      Mode := NempPlaylist.DefaultAction;

                    IncomingPWideChar := PWideChar(Msg.CopyDataStruct.lpData);
                    Msg.Result := 1;
                    HandleRemoteFilename(UnicodeString(IncomingPWideChar), Mode);
            end;
        else
        { Tcha wohl doch nicht ID - stimmte nicht }
        inherited;
    end;
end;

procedure TNemp_MainForm.hotkey(var msg:Tmessage);
begin
  case msg.wparam of
    1: if NempPlayer.Status = PLAYER_ISPLAYING then
        PlayPauseBTNIMGClick(Nil)
      else
        PlayPauseBTNIMGClick(NIL);
    2: StopBTNIMGClick(Nil);
    3: PlayNextBTNIMGClick(PlayNextBTN);
    4: PlayPrevBTNIMGClick(PlayPrevBTN);
    5: SlideForwardBTNIMGClick(NIL);
    6: SlideBackBTNIMGClick(NIL);
    7: begin
        VolTimer.Enabled := False;
        NempPlayer.VolStep := NempPlayer.VolStep + 1;
        NempPlayer.Volume := NempPlayer.Volume + 1 + (NempPlayer.VolStep DIV 3);
        VolTimer.Enabled := True;
        CorrectVolButton;
      end;
    8: begin
        VolTimer.Enabled := False;
        NempPlayer.VolStep := NempPlayer.VolStep + 1;
        NempPlayer.Volume := NempPlayer.Volume - 1 - (NempPlayer.VolStep DIV 3);
        VolTimer.Enabled := True;
        CorrectVolButton;
      end;
    9,10: begin
          if NempPlayer.IsMute then
            NempPlayer.UnMute
          else
            NempPlayer.Mute;
      end;
  end;
end;

Procedure TNemp_MainForm.WMDropFiles (Var aMsg: tMessage);
Var
  p: TPoint;
  o: TControl;
Begin
    Inherited;
    p := (mouse.CursorPos);
    o := GetObjectAt(self, p.x,p.y);
    if not assigned(o) then
      exit;

    if ObjectIsPlaylist(o.Name) then
        Handle_DropFilesForPlaylist(aMsg)
    else
        Handle_DropFilesForLibrary(aMsg);
end;


procedure TNemp_MainForm.MediaKey (Var aMSG: tMessage);
begin
  if not SchonMalEineMediaTasteGedrueckt then
  begin
      if MediaTest then
      begin
        // MediaTest l�uft
        // => auf Eingabe in Form2 reagieren
        if (aMSG.LParam = APPCOMMAND_MEDIA_PLAY_PAUSE)
        then begin
          inc(MediaCount);
          aMsg.result := 1;
          if not assigned(FormMediaKeyInit) then
            Application.CreateForm(TFormMediaKeyInit, FormMediaKeyInit);
          FormMediaKeyInit.ReactOnMMKey;
        end;
      end else  // Medientest l�uft noch nicht
      begin
        if   (aMSG.LParam = APPCOMMAND_MEDIA_STOP)
          OR (aMSG.LParam = APPCOMMAND_MEDIA_PLAY_PAUSE)
          OR (aMSG.LParam = APPCOMMAND_MEDIA_NEXTTRACK)
          OR (aMSG.LParam = APPCOMMAND_MEDIA_PREVIOUSTRACK)
        then
        begin
            if GetForeGroundWindow = Nemp_MainForm.Handle then
            begin
                // Taste im Vordergrund-Fenster gedr�ckt
                // Es kann sein, dass iTouch etc. l�uft
                // => MediaTest Starten
                aMsg.result := 1;
                MMKeyTimer.Enabled := True; // im OnTimer wird der Test ausgef�hrt
            end else
            begin
              // Fenster ist NICHT im Vordergrund
              // => iTouch o.�. l�uft
              //    (Fenster erh�lt auch ohne Hook und Ohne Fokus den Befehl)
              SchonMalEineMediaTasteGedrueckt := True;
              DoHookInstall := False;
              aMsg.result := 1;
            end;
        end else
           aMsg.Result := DefWindowProc(self.handle, aMsg.Msg, aMsg.WParam, aMsg.LParam);
      end;
  end
  else // SchonMalEineMediaTasteGedrueckt= true
  // ganz normal auf die Tasten reagieren
  begin
      if Not NempPlaylist.AcceptInput then exit;
      case aMSG.LParam of
          APPCOMMAND_MEDIA_NEXTTRACK     : begin
              aMsg.Result := 1;
              PlayNextBTNIMGClick(PlayNextBTN);
            end;
          APPCOMMAND_MEDIA_PREVIOUSTRACK : begin
              aMsg.Result := 1;
              PlayPrevBTNIMGClick(PlayPrevBTN);
          end;
          APPCOMMAND_MEDIA_STOP          : begin
              aMsg.Result := 1;
              StopBTNIMGClick(NIL);
          end;
          APPCOMMAND_MEDIA_PLAY_PAUSE,
          APPCOMMAND_MEDIA_PLAY,
          APPCOMMAND_MEDIA_PAUSE    : begin
              aMsg.Result := 1;
              PlayPauseBTNIMGClick(NIL);
          end;

          APPCOMMAND_VOLUME_DOWN  : begin
              if NempOptions.IgnoreVolumeUpDownKeys then
                  aMsg.Result := DefWindowProc(self.handle, aMsg.Msg, aMsg.WParam, aMsg.LParam)
              else
              begin
                  VolTimer.Enabled := False;
                  NempPlayer.VolStep := NempPlayer.VolStep + 1;
                  NempPlayer.Volume := NempPlayer.Volume - 1 - (NempPlayer.VolStep DIV 3);
                  VolTimer.Enabled := True;
                  CorrectVolButton;
                  aMsg.Result := 1;
              end;
          end;

          APPCOMMAND_VOLUME_UP  : begin
              if NempOptions.IgnoreVolumeUpDownKeys then
                  aMsg.Result := DefWindowProc(self.handle, aMsg.Msg, aMsg.WParam, aMsg.LParam)
              else
              begin
                  VolTimer.Enabled := False;
                  NempPlayer.VolStep := NempPlayer.VolStep + 1;
                  NempPlayer.Volume := NempPlayer.Volume + 1 + (NempPlayer.VolStep DIV 3);
                  VolTimer.Enabled := True;
                  CorrectVolButton;
                  aMsg.Result := 1;
              end;
          end;
      else
          begin
              aMsg.Result := DefWindowProc(self.handle, aMsg.Msg, aMsg.WParam, aMsg.LParam);
          end;

      end;
  end;
end;

// Ein paar Routinen, die das Skinnen erleichtren
procedure TNemp_MainForm.Skinan1Click(Sender: TObject);
var tmpstr: UnicodeString;
begin
  UseSkin := True;
  SkinName := StringReplace((Sender as TMenuItem).Caption,'&&','&',[rfReplaceAll]);
  //SkinName := (Sender as TMenuItem).Caption;

  // SkinName ist die Globale Var, die in die ini gespeichert wird -> da muss das privat//global mit rein!!!
  tmpstr := StringReplace(SkinName,
              '<public> ', ExtractFilePath(ParamStr(0)) + 'Skins\', []);

  tmpstr := StringReplace(tmpstr,
              '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);

  NempSkin.LoadFromDir(tmpstr);
  NempSkin.ActivateSkin;
  RePaintPanels;
  RepaintOtherForms;

  RepaintAll;
end;



procedure TNemp_MainForm.RefreshMedienBibCover;
var aNode: PVirtualNode;
    Data: PTreeData;
    AudioFile: TAudioFile;
begin
   { VDTCover.Clear;

    aNode := VST.FocusedNode;
    if Assigned(aNode) then
    begin
        Data := VST.GetNodeData(aNode);
        AudioFile := Data^.FAudioFile;
    end else
    begin
        aNode := VST.GetFirst;
        if assigned(aNode) then
        begin
            Data := VST.GetNodeData(aNode);
            AudioFile := Data^.FAudioFile;
        end else
            AudioFile := Nil;
    end;

    if assigned(AudioFile) then
    begin
        aNode := AddVDTCover(VDTCover, Nil, AudioFile, True);
        if VDTCover.Height - Integer(VDTCover.Header.Height) < 240 then
            aNode.NodeHeight := VDTCover.Height - Integer(VDTCover.Header.Height)
        else
            aNode.NodeHeight := 240;
    end;
    }
end;



procedure TNemp_MainForm.VDTCoverTimerTimer(Sender: TObject);
begin
    VDTCoverTimer.Enabled := False;
    RefreshMedienBibCover;
end;



function TNemp_MainForm.GetFocussedAudioFile:TAudioFile;
var  OldNode: PVirtualNode;
  Data: PTreeData;
begin
    OldNode := VST.FocusedNode;
    if assigned(OldNode) then
    begin
      Data := VST.GetNodeData(OldNode);
      result :=  Data^.FAudioFile;
    end else
      result := NIL;
end;


Procedure TNemp_MainForm.AnzeigeSortMENUClick(Sender: TObject);
var oldAudioFile: TAudioFile;
    //sortparam: Integer;
begin
  if Not (Sender is TMenuItem) then exit;

  oldAudioFile := GetFocussedAudioFile;
  VST.Enabled := False;
  // sortParam := (Sender as TMenuItem).Tag;

  case (Sender as TMenuItem).Tag of
      CON_ARTIST: begin
          MedienBib.AddSorter(CON_TITEL, False);
          MedienBib.AddSorter(CON_ARTIST);
      end;
      CON_EX_ARTISTALBUMTITEL: begin
          MedienBib.AddSorter(CON_TITEL, False);
          MedienBib.AddSorter(CON_ALBUM);
          MedienBib.AddSorter(CON_ARTIST);
      end;
      CON_TITEL: begin
          MedienBib.AddSorter(CON_ARTIST, False);
          MedienBib.AddSorter(CON_TITEL);
      end;
      CON_ALBUM: begin
          MedienBib.AddSorter(CON_ALBUM, False);
          MedienBib.AddSorter(CON_ARTIST);
          MedienBib.AddSorter(CON_TITEL);
      end;
      CON_EX_ALBUMTITELARTIST: begin
          MedienBib.AddSorter(CON_ARTIST, False);
          MedienBib.AddSorter(CON_TITEL);
          MedienBib.AddSorter(CON_ALBUM);
      end;
      CON_EX_ALBUMTRACK: begin
          MedienBib.AddSorter(CON_TRACKNR, False);
          MedienBib.AddSorter(CON_ALBUM);
      end;
      CON_DATEINAME: MedienBib.AddSorter(CON_DATEINAME, False);
      CON_PFAD: MedienBib.AddSorter(CON_PFAD, False);
      CON_LYRICSEXISTING: MedienBib.AddSorter(CON_LYRICSEXISTING, False);
      CON_GENRE: MedienBib.AddSorter(CON_GENRE, False);
      CON_DAUER: MedienBib.AddSorter(CON_DAUER, False);
      CON_FILESIZE: MedienBib.AddSorter(CON_FILESIZE, False);
      CON_LASTFMTAGS: MedienBib.AddSorter(CON_LASTFMTAGS, False);
  end;

  MedienBib.SortAnzeigeListe;

  // Anzeige im VST aktualisieren
  VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);
  if MM_ML_SortAscending.Checked then
    VST.Header.SortDirection := sdAscending
  else
    VST.Header.SortDirection := sdDescending;

  //FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);

  FillTreeViewQuickSearchReselect(MedienBib.AnzeigeListe, MedienBib.AnzeigeListe2,
      MedienBib.BibSearcher.DummyAudioFile, oldAudioFile);

  VST.Enabled := True;
end;


procedure TNemp_MainForm.PM_ML_HideSelectedClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
    NewSelectNode: PVirtualNode;
begin

    SelectedMP3s := VST.GetSortedSelection(False);
    if length(SelectedMP3s) = 0 then exit;
    
    VST.BeginUpdate;
    NewSelectNode := VST.GetNextSibling(Selectedmp3s[length(Selectedmp3s)-1]);
    if not Assigned(NewSelectNode) then
      NewSelectNode := VST.GetPreviousSibling(Selectedmp3s[0]);

    begin
      for i:=0 to length(SelectedMP3s)-1 do
      begin
        Data := VST.GetNodeData(SelectedMP3s[i]);
        MedienBib.AnzeigeListe.Extract(Data^.FAudioFile);
        MedienBib.AnzeigeListe2.Extract(Data^.FAudioFile);
      end;
      VST.DeleteSelectedNodes;
    end;

    if assigned(NewSelectNode) then
    begin
      VST.Selected[NewSelectNode] := True;
      VST.FocusedNode := NewSelectNode;
    end;

    VST.EndUpdate;
end;


// bei hide oder delete:
// Medialist_PopupMenu.Tag auswerten und bei Tag ~ Alben ggf. die markierten Playlists l�schen


procedure TNemp_MainForm.PM_ML_DeleteSelectedClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    AlbumData: PStringTreeData;
    FocussedAlbumNode, NewSelectNode: PVirtualNode;
    SelectedPlaylist: TJustaString;
    SelectedMp3s: TNodeArray;
begin
    SelectedMp3s := Nil;
    case Medialist_PopupMenu.Tag of
        2: begin
            // albenVST - was tun, falls Playlisten (oder Webradio?) dran sind
            if medienbib.CurrentArtist = BROWSE_PLAYLISTS then
            begin
                FocussedAlbumNode := AlbenVST.FocusedNode;
                if assigned(FocussedAlbumNode) then
                begin
                    NewSelectNode := AlbenVST.GetNextSibling(FocussedAlbumNode);
                    if not Assigned(NewSelectNode) then
                        NewSelectNode := AlbenVST.GetPreviousSibling(FocussedAlbumNode);

                    AlbumData := AlbenVST.GetNodeData(FocussedAlbumNode);
                    SelectedPlaylist := TJustAstring(AlbumData^.FString);

                    AlbenVST.DeleteNode(FocussedAlbumNode, True);

                    Medienbib.DeletePlaylist(SelectedPlaylist);

                    if assigned(NewSelectNode) then
                    begin
                      AlbenVST.Selected[NewSelectNode] := True;
                      AlbenVST.FocusedNode := NewSelectNode;
                    end;
                    AlbenVST.Invalidate;
                end;
            end;
        end;

        0: begin
            if MedienBib.AnzeigeShowsPlaylistFiles then
            begin
                MessageDLG((Medialibrary_GUIError3), mtError, [MBOK], 0);
            end else
            begin
                if MedienBib.StatusBibUpdate <> 0 then
                begin
                  MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
                  exit;
                end;
                VST.BeginUpdate;
                SelectedMP3s := VST.GetSortedSelection(False);
                if length(SelectedMP3s) = 0 then exit;
                StarteLangeAktion(length(SelectedMP3s), Format((MediaLibrary_Deleting), [0]), False);

                // Hier wird komplett gel�scht.
                // d.h.: aus der Medienliste entfernen und aus alle anderen Listen
                begin
                  // in allen Listen l�schen und MP3-File entfernen
                  for i:=0 to length(SelectedMP3s)-1 do
                  begin
                    Data := VST.GetNodeData(SelectedMP3s[i]);
                    MedienBib.DeleteAudioFile(Data^.FAudioFile);

                    if i mod 256 = 0 then
                    begin
                      MedienListeStatusLBL.Caption := Format((MediaLibrary_Deleting), [Round(i/length(SelectedMP3s) * 100)]);
                      application.processmessages;
                    end;

                  end;
                  VST.DeleteSelectedNodes;
                end;

                VST.EndUpdate;
                MedienBib.RepairBrowseListsAfterDelete;
                MedienBib.BuildTotalString;
                MedienBib.BuildTotalLyricString;
                ReFillBrowseTrees(True);
                MedienListeStatusLBL.Caption := '';
                BeendeLangeAktion;
            end;
        end;
    end; // case
end;


procedure TNemp_MainForm.MM_ML_DeleteClick(Sender: TObject);
begin
    if MessageDlg((Medialibrary_QueryReallyDelete), mtWarning, [mbYes,MBNo], 0) = mrYes then
    begin
        MedienBib.Clear;
        MedienListeStatusLBL.Caption := '';
        AuswahlStatusLBL.Caption := '';
        Caption:= Nemp_Caption;
    end;
    AktualisiereDetailForm(NIL, SD_MEDIENBIB);
end;

procedure TNemp_MainForm.MM_ML_SearchClick(Sender: TObject);
begin
    if not assigned(FormBibSearch) then
        Application.CreateForm(TFormBibSearch, FormBibSearch);
    FormBibSearch.Show;
end;

procedure TNemp_MainForm.MM_ML_SearchDirectoryClick(Sender: TObject);
var newdir: UnicodeString;
    FB: TFolderBrowser;
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  ST_Medienliste.Mask := GenerateMedienBibSTFilter;
  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_Caption );
  try
      if fb.Execute then
      begin
          newdir := fb.SelectedItem;
          MedienBib.ST_Ordnerlist.Add(newdir);
          // DateiSuche starten
          if (Not ST_Medienliste.IsSearching) then
          begin
            PutDirListInAutoScanList(MedienBib.ST_Ordnerlist);
            MedienBib.StatusBibUpdate := 1;
            BlockeMedienListeUpdate(True);
            ST_Medienliste.SearchFiles(MedienBib.ST_Ordnerlist[0]);
          end;
      end;
  finally
      fb.Free;
  end;
end;

procedure TNemp_MainForm.MM_ML_LoadClick(Sender: TObject);
begin
  if Opendialog1.Execute then
  begin
      MedienBib.Clear;
      MedienBib.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TNemp_MainForm.MM_ML_SaveClick(Sender: TObject);
begin
  SaveDialog1.Filter := (Medialibrary_DialogFilter) + ' (*.gmp)|*.gmp';
  if SaveDialog1.Execute then
     MedienBib.SaveToFile(SaveDialog1.FileName, False);
end;


procedure TNemp_MainForm.DatenbankUpdateTBClick(Sender: TObject);
begin
    MedienBib.DeleteFilesUpdateBib;
end;

procedure TNemp_MainForm.HandleFiles(aList: TObjectList; how: integer);
var i:integer;
    datei_pfad: UnicodeString;
    Abspielen: Boolean;
    imax: integer;
begin
    if aList.Count = 0 then exit;

    datei_pfad := (aList[0] as TAudiofile).Pfad;
    if Not (aList[0] as TAudiofile).isStream then
        (aList[0] as TAudiofile).FileIsPresent := FileExists(datei_pfad);


    if How = PLAYER_PLAY_FILES then // erst PlayList l�schen
        NempPlaylist.ClearPlaylist;

    // Hier �berpr�fen, ob die Playlist leer ist
    // ebtweder, weil sie gerade eben gel�scht wurde,
    // oder weil sie halt schon leer war.
    // Auf jeden Fall macht es dann Sinn, die erste Datei abzuspielen:
    Abspielen := NempPlaylist.Count = 0;

    if How in [{PLAYER_PLAY_NOW, }PLAYER_PLAY_NEXT] then
        NempPlaylist.GetInsertNodeFromPlayPosition
    else
        NempPlaylist.InsertNode := NIL;

    // Erste Datei einf�gen und ggf. Abspielen
    NempPlaylist.InsertFileToPlayList(TAudiofile(aList[0]));

    if Abspielen AND (NempPlaylist.Count>0) then // 2.Bedingung: Es wurde tats�chlich was eingef�gt
    begin
        NempPlayer.LastUserWish := USER_WANT_PLAY;
        NempPlaylist.Play(0, 0, True);
    end
    else
        // Playlist war vor dem Einf�gen nicht leer
        // aber Modus ist PLAY_NOW => Neu eingef�gtes erstes File abspielen
        if (HOW = PLAYER_PLAY_NOW) AND (NempPlaylist.Count > 0) then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(NempPlaylist.Count-1, 0, True);
        end;

    iMax := aList.Count-1;

    ContinueWithPlaylistAdding := True;

    // weitere Dateien einf�gen
    for i:=1 to iMax do
    begin
      datei_pfad := (aList[i] as TAudiofile).Pfad;
      if Not (aList[i] as TAudiofile).isStream then
          (aList[i] as TAudiofile).FileIsPresent := FileExists(datei_pfad);

      NempPlaylist.InsertFileToPlayList(TAudiofile(aList[i]));
      if i Mod 20 = 0 then
          application.ProcessMessages;
      if Not ContinueWithPlaylistAdding then break;
    end;

    ContinueWithPlaylistAdding := False;
end;

procedure TNemp_MainForm.GenerateListForHandleFiles(aList: tObjectList; what: integer);
var i: integer;
  DataS: PStringTreeData;
  DataA: PTreeData;
  aNode: PVirtualNode;
  artist, album: UnicodeString;
  SelectedMp3s: TNodeArray;
begin
  SelectedMP3s := Nil;
  case what of
      0: begin // Quelle ist der VST
          FreeFilesInHandleFilesList := False;
          SelectedMP3s := VST.GetSortedSelection(False);
          for i:=0 to length(SelectedMP3s)-1 do
          begin
              DataA := VST.GetNodeData(SelectedMP3s[i]);
              aList.Add(DataA^.FAudioFile)
          end;
          // Nicht sortieren
      end;
      1: begin  // Artists
          FreeFilesInHandleFilesList := False;
          aNode := ArtistsVST.FocusedNode;
          if assigned(aNode) then
          begin
            DataS := ArtistsVST.GetNodeData(aNode);
            if (TJustAstring(DataS^.FString).DataString <> BROWSE_PLAYLISTS)
               AND (TJustAstring(DataS^.FString).DataString <> BROWSE_RADIOSTATIONS)
            then
            begin
                MedienBib.GetTitelList(aList, TJustAstring(DataS^.FString).DataString, BROWSE_ALL);
                // Sortieren
                if aList.Count <= 5000 then
                    aList.Sort(Sortieren_AlbumTrack_asc);
            end;
          end;
      end;
      2: begin // Alben
          aNode := ArtistsVST.FocusedNode;
          if assigned(aNode) then
          begin
            DataS  := ArtistsVST.GetNodeData(aNode);
            Artist := TJustAstring(DataS^.FString).DataString
          end else
            Artist := BROWSE_ALL;

          aNode := AlbenVST.FocusedNode;
          if assigned(aNode) then
          begin
            DataS := AlbenVST.GetNodeData(aNode);
            Album := TJustAstring(DataS^.FString).DataString
          end else
            Album := BROWSE_ALL;

          if (Artist = BROWSE_PLAYLISTS) and (Album <> BROWSE_ALL) then //(letzteres sollte immer so sein ;-))
          begin
              FreeFilesInHandleFilesList := True;
              LoadPlaylistFromFile(album, aList, Nempplaylist.AutoScan);
          end else
          if (Artist = BROWSE_RADIOSTATIONS) and (Album <> BROWSE_ALL) then //(letzteres sollte immer so sein ;-))
          begin
              if Integer(aNode.Index) < MedienBib.RadioStationList.Count then
                  TStation(MedienBib.RadioStationList[aNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist)
              else
                  MessageDlg(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
              FreeFilesInHandleFilesList := True;
          end else
          begin
              FreeFilesInHandleFilesList := False;
              // Wenn ein spezielles Album ausgew�hlt wurde, dann
              //   dann alle Titel dieses Albums nehmen -> Artist=alle
              // ansonsten:
              //   Wenn also "Alle Alben" markiert wurden, dann nur die Titel des Artists,
              //   und nicht die gesamte Medienliste!
              //if Album <> BROWSE_ALL then Artist := BROWSE_ALL;
              //  MedienBib.GetTitelList(aList, Artist, Album);
              // DAS MACHT BEI VIELEN VORSORTIERUNGEN KEINEN SINN!!! Daher einfach nur:

              MedienBib.GetTitelList(aList, Artist, Album);
              //Sortieren
              if aList.Count <= 5000 then
                  aList.Sort(Sortieren_AlbumTrack_asc);
          end;
      end;
      3: begin
        // Quelle ist das Cover-Flow-Image
        MedienBib.GetTitelListFromCoverID(aList, TNempCover(MedienBib.Coverlist[CoverScrollbar.Position]).ID);
        // Sortieren
        if aList.Count <= 5000 then
            aList.Sort(Sortieren_AlbumTrack_asc);
      end;
  else
    MessageDlg('Uh-Oh. Something strange happens (GenerateListForHandleFiles). Please report this error.'
      + #13#10 + 'Param: ' + InttoStr(what) , mtWarning, [mbOK], 0);
  end;
end;

procedure TNemp_MainForm.DoFreeFilesInHandleFilesList(aList: TObjectList);
var i: Integer;
begin
    for i := 0 to aList.Count - 1 do
        TAudioFile(aList[i]).Free;
end;

procedure TNemp_MainForm.EnqueueTBClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  WebRadioInsertMode := PLAYER_ENQUEUE_FILES;
  GenerateListForHandleFiles(Dateiliste, Medialist_PopupMenu.Tag);
  if NOT (     (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) // Webradio markiert
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben ge�ffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      HandleFiles(Dateiliste, PLAYER_ENQUEUE_FILES);
      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(DateiListe);
end;

procedure TNemp_MainForm.PM_ML_PlayNextClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  WebRadioInsertMode := PLAYER_PLAY_NEXT;
  // Dateiliste f�llen, abh�ngig davon, wo wir gerade sind.
  GenerateListForHandleFiles(Dateiliste, Medialist_PopupMenu.Tag);
  if NOT (     (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) // Webradio markiert
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben ge�ffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      HandleFiles(Dateiliste, PLAYER_PLAY_NEXT);
      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(DateiListe);
end;

procedure TNemp_MainForm.PM_ML_PlayNowClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  WebRadioInsertMode := PLAYER_PLAY_NOW;
  GenerateListForHandleFiles(Dateiliste, Medialist_PopupMenu.Tag);
  if NOT (     (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) // Webradio markiert
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben ge�ffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      HandleFiles(Dateiliste, PLAYER_PLAY_NOW);
      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(DateiListe);
end;


procedure TNemp_MainForm.PM_ML_PlayClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  WebRadioInsertMode := PLAYER_PLAY_FILES;
  GenerateListForHandleFiles(Dateiliste, Medialist_PopupMenu.Tag);
  if NOT (     (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) // Webradio markiert
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben ge�ffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      if (NempPlaylist.Count > 20) AND (DateiListe.Count < 5) then
      begin
        if MessageDlg((Playlist_QueryReallyDelete), mtWarning, [mbYes, mbNo], 0) = mrYes then
              HandleFiles(Dateiliste, PLAYER_PLAY_FILES)
      end
      else
        HandleFiles(Dateiliste, PLAYER_PLAY_FILES);

      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(Dateiliste);
end;

procedure TNemp_MainForm.Medialist_PopupMenuPopup(Sender: TObject);
var o: TComponent;
  aVst: TVirtualStringTree;
  Data: PTreeData;

  DataS: PStringTreeData;
  aNode: PVirtualNode;
  canPlay: Boolean;
begin
  if LangeAktionWeitermachen then   exit;
  
  o := Screen.ActiveForm.ActiveControl;
  if (o <> NIL) AND ((o.Name = 'VST') or (o.Name = 'TabBtn_Medialib')) then
  begin
      PM_ML_Play.Caption     := (MainForm_MenuCaptionsPlay    );
      PM_ML_Enqueue.Caption  := (MainForm_MenuCaptionsEnqueue );
      PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNext);
      PM_ML_PlayNow.Caption  := (MainForm_MenuCaptionsPlayNow );
      aVst := Vst;
      Medialist_PopupMenu.Tag := 0;
  end
  else
    if (o <> NIL) AND (o.Name = 'ArtistsVST') then
    begin
        PM_ML_Play.Caption     := GetProperMenuString(Integer(MedienBib.NempSortArray[1])); //Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[Integer(MedienBib.NempSortArray[1])]]);
        PM_ML_Enqueue.Caption  := (MainForm_MenuCaptionsEnqueueAll );
        PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
        PM_ML_PlayNow.Caption  := (MainForm_MenuCaptionsPlayNowAll );
        aVst := ArtistsVST;
        Medialist_PopupMenu.Tag := 1;
    end
    else
      if (o <> NIL) AND (o.Name = 'AlbenVST') then
      begin
          if (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) then
              PM_ML_Play.Caption := MainForm_MenuCaptionsPlayAllPlaylist
          else
              if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
                  PM_ML_Play.Caption := MainForm_MenuCaptionsPlayAllWebradio
              else
                  PM_ML_Play.Caption     := GetProperMenuString(Integer(MedienBib.NempSortArray[2]));;//Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[Integer(MedienBib.NempSortArray[2])]]);

          PM_ML_Enqueue.Caption  := (MainForm_MenuCaptionsEnqueueAll );
          PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
          PM_ML_PlayNow.Caption  := (MainForm_MenuCaptionsPlayNowAll );
          aVST := ALbenVST;
          Medialist_PopupMenu.Tag := 2;
      end else
        if (o <> NIL) AND (o.Name = 'CoverScrollbar') then
        begin
            PM_ML_Play.Caption     := GetProperMenuString(1);; //Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[1]]);
            PM_ML_Enqueue.Caption  := (MainForm_MenuCaptionsEnqueueAll );
            PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
            PM_ML_PlayNow.Caption  := (MainForm_MenuCaptionsPlayNowAll );
            aVST := Nil;
            Medialist_PopupMenu.Tag := 3;
        end else
            aVST := Nil;

      PM_ML_SortBy.Enabled := (aVST = VST) AND Not LangeAktionWeitermachen;
      PM_ML_Extended.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;

    if (((aVST = NIL) OR (aVST.FocusedNode= NIL))
       or ((aVST = VST) AND (VST.SelectedCount = 0)))
        AND
       ((o <> NIL) AND (o.Name <> 'CoverScrollbar'))
       then
    begin
      PM_ML_Properties.Enabled := False;
      PM_ML_RefreshSelected.Enabled := False;
      PM_ML_HideSelected.Enabled := False;
      PM_ML_DeleteSelected.Enabled:=False;
      PM_ML_Play.Enabled := False;
      PM_ML_Enqueue.Enabled := False;
      PM_ML_PlayNext.Enabled := False;
      PM_ML_PlayNow.Enabled := False;
      PM_ML_DeleteSelected.Enabled := False;
      PM_ML_PlayHeadset.Enabled := False;
      PM_ML_StopHeadset.Enabled := NempPlayer.EnableHeadSet;
      PM_ML_DeleteSelected.Enabled := False;
      PM_ML_GetLyrics.Enabled := False;
      PM_ML_ExtendedShowAllFilesInDir.Enabled := False;
      PM_ML_ExtendedAddAllFilesInDir.Enabled := False;
      PM_ML_ExtendedSearchTitle.Enabled := False;
      PM_ML_ExtendedSearchArtist.Enabled := False;
      PM_ML_ExtendedSearchAlbum.Enabled := False;
      PM_ML_ShowInExplorer.Enabled := False;
      PM_ML_CopyToClipboard.Enabled := False;
    end else
    begin
      // ???
      //Liste:=AnzeigeListe;
      PM_ML_Properties.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_RefreshSelected.Enabled := (aVST = VST) AND {(not MedienBib.AnzeigeShowsPlaylistFiles) AND} (not LangeAktionWeitermachen);
      PM_ML_HideSelected.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_DeleteSelected.Enabled := ((aVST = VST) AND (not MedienBib.AnzeigeShowsPlaylistFiles) AND (not LangeAktionWeitermachen))
                                    OR ((aVST = AlbenVST) and (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) AND (not LangeAktionWeitermachen))
      ;


      if aVST = ArtistsVST then
      begin
          aNode := ArtistsVST.FocusedNode;
          if assigned(aNode) then
          begin
              DataS := ArtistsVST.GetNodeData(aNode);
              if (TJustAstring(DataS^.FString).DataString <> BROWSE_PLAYLISTS)
                 AND (TJustAstring(DataS^.FString).DataString <> BROWSE_RADIOSTATIONS)
              then
                  canPlay := True
              else
                  canPlay := False;
          end else canPlay := False;
      end else
          canPlay := True;

      PM_ML_Play.Enabled := canPlay;
      PM_ML_Enqueue.Enabled := canPlay;
      PM_ML_PlayNext.Enabled := canPlay;
      PM_ML_PlayNow.Enabled := canPlay;
      //PM_ML_DeleteSelected.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_GetLyrics.Enabled := (aVST = VST) AND (not MedienBib.AnzeigeShowsPlaylistFiles) AND (not LangeAktionWeitermachen);
      PM_ML_PlayHeadset.Enabled := (aVST = VST) AND NempPlayer.EnableHeadSet;
      PM_ML_StopHeadset.Enabled := NempPlayer.EnableHeadSet;

      //PM_ML_DeleteSelected.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_ExtendedShowAllFilesInDir.Enabled := (not MedienBib.AnzeigeShowsPlaylistFiles);
      PM_ML_ExtendedAddAllFilesInDir.Enabled := (not MedienBib.AnzeigeShowsPlaylistFiles);
      PM_ML_ExtendedSearchTitle.Enabled := True;
      PM_ML_ExtendedSearchArtist.Enabled := True;
      PM_ML_ExtendedSearchAlbum.Enabled := True;
      PM_ML_ShowInExplorer.Enabled := (aVST = VST);
      PM_ML_CopyToClipboard.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
    end;
    PM_ML_PasteFromClipboard.Enabled := Clipboard.HasFormat(CF_HDROP);

    if (aVST = VST) AND (aVST.FocusedNode <> NIL) then
    begin
      Data := aVST.GetNodeData(aVST.FocusedNode);
      PM_ML_ExtendedSearchTitle.Caption  := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Titel]);
      PM_ML_ExtendedSearchArtist.Caption := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Artist]);
      PM_ML_ExtendedSearchAlbum.Caption  := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Album]);
    end else
    begin
      PM_ML_ExtendedSearchTitle.Caption  := (MainForm_MenuCaptionsSearchForTitle);
      PM_ML_ExtendedSearchArtist.Caption := (MainForm_MenuCaptionsSearchForArtist);
      PM_ML_ExtendedSearchAlbum.Caption  := (MainForm_MenuCaptionsSearchForAlbum)
    end;
end;

procedure TNemp_MainForm.PM_ML_ShowInExplorerClick(Sender: TObject);
var
    datei_ordner: UnicodeString;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    Node:=VST.FocusedNode;
    if not Assigned(Node) then
        Exit;
    Data := VST.GetNodeData(Node);
    datei_ordner := Data^.FAudioFile.Ordner;

    if DirectoryExists(datei_ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
                      , PChar('/e,/select,"'+Data^.FAudioFile.Pfad+'"'), '', sw_ShowNormal);
end;

procedure TNemp_MainForm.ShowSummary;
var i:integer;
  dauer:int64;
  groesse:int64;
  Liste: TObjectlist;
begin
  dauer:=0;
  groesse:=0;
  // ???
  Liste := MedienBib.Anzeigeliste;

  if MedienBib.CurrentArtist = BROWSE_PLAYLISTS then
  begin
      AuswahlStatusLBL.Caption := Format(MainForm_Summary_PlaylistCount, [MedienBib.Alben.Count])
  end else
  if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
  begin
      AuswahlStatusLBL.Caption := Format(MainForm_Summary_WebradioCount, [MedienBib.RadioStationList.Count]);
  end else
  begin
      for i:=0 to Liste.Count-1 do
      begin
        dauer := dauer + (Liste[i] as TAudioFile).Duration;
        groesse := groesse + (Liste[i] as TAudioFile).Size;
      end;

      AuswahlStatusLBL.Caption := Format((MainForm_Summary_FileCount),[Liste.Count])
                         + SizeToString(groesse)
                         + SekToZeitString(dauer);
  end;
end;


procedure TNemp_MainForm.ToolButton7Click(Sender: TObject);
begin
  if NOT FileExists(ExtractFilePath(Paramstr(0))+'faq.htm') then
    MessageDLG((Error_HelpFileNotFound), mtError, [mbOK], 0)
  else
    ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'faq.htm')
                      , nil, nil, SW_SHOWNORMAl);
end;


procedure TNemp_MainForm.MM_ML_RefreshAllClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;
  MedienBib.RefreshFiles;
end;

procedure TNemp_MainForm.MM_ML_ResetRatingsClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
      MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
  end;
  if MessageDlg(MedienBib_ConfirmResetRatings, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
      MedienBib.ResetRatings;
      VST.Invalidate;
  end;
end;

procedure TNemp_MainForm.PM_ML_RefreshSelectedClick(Sender: TObject);
var
    AudioFile:TAudioFile;
    i,tot:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
    Node:PVirtualNode;
    oldArtist, oldAlbum: UnicodeString;
    oldID: String;
    einUpdate: boolean;
begin
  SelectedMp3s := Nil;
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  MedienBib.StatusBibUpdate := 3;
  BlockeMedienListeReadAccess(True);
  LangeAktionWeitermachen := true;
  MedienBib.ReInitCoverSearch;
  SelectedMP3s := VST.GetSortedSelection(False);

  if MedienBib.AnzeigeShowsPlaylistFiles then
  begin
      //MessageDLG((Medialibrary_GUIError4), mtError, [MBOK], 0);
      for i:=0 to length(SelectedMP3s)-1 do
      begin
          application.processmessages;
          if not LangeAktionWeitermachen then break;
          Data := VST.GetNodeData(SelectedMP3s[i]);
          AudioFile := Data^.FAudioFile;
          if FileExists(AudioFile.Pfad) then
          begin
              AudioFile.FileIsPresent:=True;
              AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover or GAD_Rating);
              MedienBib.InitCover(AudioFile);
              VST.InvalidateNode(SelectedMP3s[i]);
          end
          else begin
              AudioFile.FileIsPresent:=False;
              VST.InvalidateNode(SelectedMP3s[i]);
          end;
          if i mod 256 = 0 then
              MedienListeStatusLBL.Caption := Format((MediaLibrary_RefreshingFiles), [Round(i/length(SelectedMP3s) * 100)]);
      end;
  end else
  begin
      einUpdate := False;
      tot := 0;
      for i:=0 to length(SelectedMP3s)-1 do
      begin
          application.processmessages;
          if not LangeAktionWeitermachen then break;
          Data := VST.GetNodeData(SelectedMP3s[i]);
          AudioFile := Data^.FAudioFile;
          oldArtist := AudioFile.Strings[MedienBib.NempSortArray[1]];
          oldAlbum := AudioFile.Strings[MedienBib.NempSortArray[2]];
          oldID := AudioFile.CoverID;
          if FileExists(AudioFile.Pfad) then
          begin
            AudioFile.FileIsPresent:=True;
            AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover or GAD_Rating);
            MedienBib.InitCover(AudioFile);
            if  (oldArtist <> AudioFile.Strings[MedienBib.NempSortArray[1]])
                 OR (oldAlbum <> AudioFile.Strings[MedienBib.NempSortArray[2]])
                 or (oldID <> AudioFile.CoverID)
            then
              einUpdate := true;
            VST.InvalidateNode(SelectedMP3s[i]);
          end
          else begin
            AudioFile.FileIsPresent:=False;
            VST.InvalidateNode(SelectedMP3s[i]);
            inc(tot);
          end;
          if i mod 256 = 0 then
          begin
            MedienListeStatusLBL.Caption := Format((MediaLibrary_RefreshingFiles), [Round(i/length(SelectedMP3s) * 100)]);
          end;
      end;

      if tot > 0 then
          if (tot < 2000) AND (tot < MedienBib.Count DIV 10) then // weniger als 10% fehlen
              MessageDlg(Format((MediaLibrary_FilesNotFound), [tot]), mtWarning, [MBOK], 0)
          else // mehr als 10% fehlen => Laufwerk fehlt?
              MessageDlg(Format((MediaLibrary_FilesNotFoundExternalDrive), [tot]), mtWarning, [MBOK], 0);

      if einUpdate then
      begin
        MedienBib.RepairBrowseListsAfterChange;
        ReFillBrowseTrees(True);
      end;
      MedienBib.Changed := True;
  end;

  BlockeMedienListeReadAccess(False);
  BlockeMedienListeWriteAcces(False);
  BlockeMedienListeUpdate(False);

  LangeAktionWeitermachen := False;
  MedienBib.StatusBibUpdate := 0;
  MedienListeStatusLBL.Caption := '';
  ShowSummary;

  Node := VST.FocusedNode;
  if Assigned(Node) then
  begin
      Data := VST.GetNodeData(Node);
      AktualisiereDetailForm(Data^.FAudioFile, SD_MEDIENBIB);
  end else
      AktualisiereDetailForm(NIL, SD_MEDIENBIB);
end;


procedure TNemp_MainForm.PM_ML_PropertiesClick(Sender: TObject);
var
    AudioFile: TAudioFile;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    Node:=VST.FocusedNode;
    if not Assigned(Node) then
      Node := VST.GetFirstSelected;
    if not Assigned(Node) then
      exit;
    Data := VST.GetNodeData(Node);
    AudioFile := Data^.FAudioFile as TAudiofile;
    AutoShowDetailsTMP := True;

    AktualisiereDetailForm(AudioFile, SD_MEDIENBIB);

    if not FileExists(AudioFile.Pfad) then
    begin
      AudioFile.FileIsPresent := False;
      VST.InvalidateNode(Node);
    end;
end;



procedure TNemp_MainForm.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var Data: PTreeData;
begin

    if (vsDisabled in Node.States) then
    begin

    if VST.Header.Columns[column].Position = 0 then
        Celltext := MainForm_MoreSearchresults
    else
        CellText := '';
    end else
    begin

        Data:=Sender.GetNodeData(Node);

        case VST.Header.Columns[column].Tag of
          CON_ARTIST    : begin
                              if Data^.FAudioFile.isStream then
                                CellText := Format('(%s)', [AudioFileProperty_Webstream])
                              else
                                CellText := Data^.FAudioFile.Artist;
                          end;
          CON_TITEL     : begin
                              if Data^.FAudioFile.isStream then
                                CellText := Format('(%s)', [AudioFileProperty_Webstream])
                              else
                                CellText := Data^.FAudioFile.Titel;
                          end;
          CON_ALBUM     : begin
                              if Data^.FAudioFile.isStream then
                                CellText := Format('(%s)', [AudioFileProperty_Webstream])
                              else
                                CellText := Data^.FAudioFile.Album;
                          end;
          CON_DAUER     : CellText := SekIntToMinStr(Data^.FAudioFile.Duration);
          CON_BITRATE   : CellText := inttostr(Data^.FAudioFile.Bitrate);
          CON_CBR       : if Data^.FAudioFile.vbr then CellText := 'vbr'
                          else CellText := 'cbr';
          CON_MODE            : CellText := Data^.FAudioFile.ChannelModeShort;
          CON_SAMPLERATE      : CellText := Data^.FAudioFile.SamplerateShort;
          CON_STANDARDCOMMENT : CellText := Data^.FAudioFile.Comment;
          CON_FILESIZE  : CellText := FloatToStrF((Data^.FAudioFile.Size / 1024 / 1024),ffFixed,4,2);
          CON_PFAD      : CellText := Data^.FAudioFile.Pfad;
          CON_ORDNER    : CellText := Data^.FAudioFile.Ordner;
          CON_DATEINAME : CellText := Data^.FAudioFile.Dateiname;
          CON_YEAR      : CellText := Data^.FAudioFile.Year;
          CON_GENRE     : CellText := Data^.FAudioFile.genre;
          CON_LYRICSEXISTING : if Data^.FAudioFile.LyricsExisting then CellText := ''
                               else CellText := ' ';
          CON_TRACKNR   : CellText := IntToStr(Data^.FAudioFile.Track);
          CON_RATING    : CellText := '     ';//IntToStr(Data^.FAudioFile.Rating);//'';//
          CON_PLAYCOUNTER : CellText := IntToStr(Data^.FAudioFile.PlayCounter);

          CON_LASTFMTAGS : CellText := ' ';// Data^.FAudioFile.RawTagLastFM;
        else CellText := ' ';
        end;
        // Correct CellText for toAutoSpan to a non-empty-string
        if CellText = '' then Celltext := ' ';
    end;

end;

procedure TNemp_MainForm.VSTAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var Data: PTreeData;
    st: Integer;
begin
  Data:=Sender.GetNodeData(Node);

  case VST.Header.Columns[column].Tag of
     CON_RATING: begin
        TargetCanvas.Brush.Style := bsClear;

        if Data^.FAudioFile.Rating = 0 then
            st := 127
        else
            st := Data^.FAudioFile.Rating;

        RatingGraphics.DrawRatingInStars(st, TargetCanvas, CellRect.Bottom - CellRect.Top, CellRect.Left);
     end;
  end;
end;



procedure TNemp_MainForm.VSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var Dateiliste: TObjectlist;
begin
  DateiListe := TObjectList.Create(False);
  GenerateListForHandleFiles(Dateiliste, 0);
  HandleFiles(Dateiliste, NempPlaylist.DefaultAction);
  if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  FreeAndNil(Dateiliste);
end;


procedure TNemp_MainForm.VSTHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var oldAudioFile: TAudioFile;
begin
  if (HitInfo.Button = mbLeft) then
  begin
      if (HitInfo.Column > -1 ) then
      begin
          oldAudioFile := GetFocussedAudioFile;
          VST.Enabled := False;

          MedienBib.AddSorter(VST.Header.Columns[HitInfo.Column].Tag);
          VST.Header.SortColumn := HitInfo.Column;
          if MedienBib.SortParams[0].Direction = sd_Ascending then
              VST.Header.SortDirection := sdAscending
          else
              VST.Header.SortDirection := sdDescending;

          MedienBib.SortAnzeigeListe;

          //FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);
          FillTreeViewQuickSearchReselect(MedienBib.AnzeigeListe, MedienBib.AnzeigeListe2,
              MedienBib.BibSearcher.DummyAudioFile, oldAudioFile);

          VST.Enabled := true;
      end;
  end else
  begin
      VST_ColumnPopup.Popup(
      VST.ClientToScreen(Point(HitInfo.x,HitInfo.y)).X,
      VST.ClientToScreen(Point(HitInfo.x,HitInfo.y)).Y
      );
  end;
end;


(*procedure TNemp_MainForm.VDTCoverHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if HitInfo.Button = mbRight then
  begin
      VST_ColumnPopup.Popup(
      VDTCover.ClientToScreen(Point(HitInfo.x,HitInfo.y)).X,
      VDTCover.ClientToScreen(Point(HitInfo.x,HitInfo.y)).Y
      );
  end;
end;  *)

procedure TNemp_MainForm.MM_ML_SortAscendingClick(Sender: TObject);
begin
  MM_ML_SortAscending.Checked := True;
  PM_ML_SortAscending.Checked := True;
end;

procedure TNemp_MainForm.MM_ML_SortDescendingClick(Sender: TObject);
begin
  MM_ML_SortDescending.Checked := True;
  PM_ML_SortDescending.Checked := True;
end;

procedure TNemp_MainForm.VSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i:integer;
  SelectedMp3s: TNodeArray;
  Data: PTreeData;
  aVST: TVirtualStringTree;
begin
    DragSource := DS_VST;
    aVST := Sender as TVirtualStringTree;
    with DragFilesSrc1 do
    begin
    // Add files selected to DragFilesSrc1 list
        ClearFiles;
        DragDropList.Clear;
        SelectedMp3s := aVST.GetSortedSelection(False);

        if length(SelectedMp3s) > MAX_DRAGFILECOUNT then
        begin
          MessageDlg((Warning_TooManyFiles), mtInformation, [MBOK], 0);
          exit;
        end;

        for i:=0 to length(SelectedMP3s)-1 do
        begin
            Data := aVST.GetNodeData(SelectedMP3s[i]);
            AddFile(Data^.FAudioFile.Pfad);
            DragDropList.Add(Data^.FAudioFile.Pfad);
        end;
        // This is the START of the drag (FROM) operation.
        Execute;
    end;
end;

procedure TNemp_MainForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  AudioFile:TAudioFile;
  Data: PTreeData;
  AllowColorChange: Boolean;
begin
  if NempSkin.isActive then
  begin
    if Sender = PlaylistVSt then
      AllowColorChange := NOT NempSkin.DisableBitrateColorsPlaylist
    else
      AllowColorChange := NOT NempSkin.DisableBitrateColorsMedienliste;
  end
  else
    AllowColorChange := True;

    Data := Sender.GetNodeData(Node);
    AudioFile := Data^.FAudioFile;
    With TargetCanvas Do
    begin
        if NempOptions.ChangeFontSizeOnLength AND (NOT AudioFile.isStream) AND (Sender.GetNodeLevel(Node)=0)  then
          font.Size := LengthToSize(AudioFile.Duration,NempOptions.DefaultFontSize)
        else
          font.Size := NempOptions.DefaultFontSize;

        if AllowColorChange AND
              ( (NempOptions.ChangeFontColorOnBitrate AND (Not (vsSelected in Node.States)))
                OR
                (NempOptions.ChangeFontColorOnBitrate AND (Column <> Sender.FocusedColumn)))
        then
        begin
          if NempSkin.isActive then
          begin
            if AllowColorChange then
                  font.Color := BitrateToColor(AudioFile.Bitrate,
                                NempSkin.SkinColorScheme.MinFontColor,
                                NempSkin.SkinColorScheme.MiddleFontColor,
                                NempSkin.SkinColorScheme.MaxFontColor,
                                NempSkin.SkinColorScheme.MiddleToMinComputing,
                                NempSkin.SkinColorScheme.MiddleToMaxComputing )
            else
            begin
                  if Sender = PlaylistVST then
                    font.color := NempSkin.SkinColorScheme.Tree_FontColor[3]
                  else
                    font.color := NempSkin.SkinColorScheme.Tree_FontColor[4]
            end;
          end
          else
            // "kein Skin Aktiviert":
            font.Color := BitrateToColor(AudioFile.Bitrate, NempOptions.MinFontColor, NempOptions.MiddleFontColor, NempOptions.MaxFontColor, NempOptions.MiddleToMinComputing, NempOptions.MiddleToMaxComputing );
        end;

        if  (NempSkin.isActive) AND
            (vsSelected in Node.States) AND
            (Sender.Focused) then
        begin
          if Sender = PlaylistVST then
            font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[3]
          else
            if Sender = VST then font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[4]
        end;

        if NempOptions.ChangeFontStyleOnMode then
          font.Style := ModeToStyle(AudioFile.ChannelmodeInt);
        if NempOptions.ChangeFontOnCbrVbr then
        begin
          if AudioFile.vbr then font.Name := NempOptions.FontNameVBR
          else font.Name := NempOptions.FontNameCBR
        end;

        if NOT AudioFile.FileIsPresent then
            Font.Style := Font.Style + [fsStrikeOut];
    end;
end;

procedure TNemp_MainForm.MM_O_PreferencesClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
    Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.VSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var aString: String;
    Data: PTreeData;
    aAudioFile: TAudioFile;
begin
    // Used for next Search with "F3"
    OldSelectionPrefix := SearchText;

    Data := Sender.GetNodeData(Node);
    aAudioFile := Data^.FAudioFile;

    case VST.Header.Columns[VST.FocusedColumn].Tag of
        CON_ARTIST: aString := aAudioFile.Artist;
        CON_TITEL: aString := aAudioFile.Titel;
        CON_ALBUM: aString := aAudioFile.Album;
    else
        aString := aAudioFile.Artist;
    end;
    Result := StrLIComp(PChar(SearchText), PChar(aString), Min(length(SearchText), length(aString)));
end;

procedure TNemp_MainForm.VSTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  if (MedienBib.AnzeigeListe.Count > 0) and (Node.Index = MedienBib.AnzeigeListe.Count) then
    InitialStates:= [ivsDisabled];
end;

procedure TNemp_MainForm.VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var tmpNode: PVirtualNode;
begin
    if assigned(NewNode) then
    begin
        tmpNode := NewNode;

        if (vsDisabled in NewNode.States) then
            NewNode := NewNode.NextSibling;

        Allowed:= not (vsDisabled in tmpNode.States);

        //NewNode := tmpNode;
    end
    else
        Allowed := True; // or better false ???
end;

procedure TNemp_MainForm.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Node,ScrollNode: PVirtualNode;
  Data: PTreeData;
  erfolg:boolean;
  Dateiliste: TObjectlist;

        function GetNodeWithPrefix(aVST: TVirtualStringTree; StartNode:PVirtualNode; FocussedAttribut:integer; Prefix: UnicodeString; var Erfolg:boolean):PVirtualNode;
        // erfolg gibt an, ob man beim kompletten Durchlauf des Baumes einen weiteren Knoten mit den
        // gew�nschten EIgenschaften gefunden hat.
        // Wenn man beim Startknoten wieder ankommt, gibt es keinen (weiteren) Knoten mit dem
        // entsprechenden Prefix.
        var
          nextnode:PVirtualnode;
          Data:PTreeData;
          AudioFile: TAudioFile;
          aString: String;
        begin
          erfolg := false;
          nextnode := startNode;
          repeat
            Data := aVST.GetNodeData(nextnode);
            AudioFile := Data^.FAudioFile;

            case FocussedAttribut of
                CON_ARTIST: aString := AudioFile.Artist;
                CON_TITEL: aString := AudioFile.Titel;
                CON_ALBUM: aString := AudioFile.Album;
            else
                aString := AudioFile.Artist;
            end;

            erfolg := AnsiStartsText(Prefix, aString);
            result := Nextnode;

            // n�chsten Knoten w�hlen
            nextnode := aVST.GetNext(nextnode);
            // oder vorne wieder anfangen
            if nextnode = NIL then
              nextnode := aVST.GetFirst;
          until erfolg or (nextnode = startnode);

          if not erfolg then result := nextnode;
        end;
begin
  // Das dann der Form.OnKEydown �berlassen
  if ssctrl in Shift then exit;
  
  case key of
    VK_Return: begin
      DateiListe := TObjectList.Create(False);
      GenerateListForHandleFiles(Dateiliste, 0);
      HandleFiles(Dateiliste, NempPlaylist.DefaultAction);
      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
      FreeAndNil(Dateiliste);
    end;

    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      if not Assigned(VST.FocusedNode) then Exit;
      // n�chstes Vorkommen des Prefixes suchen, dazu: beim n�chsten Knoten beginnen
      if VST.GetNext(VST.FocusedNode) <> NIL then
        ScrollNode := GetNodeWithPrefix(VST, VST.GetNext(VST.FocusedNode), VST.Header.Columns[VST.FocusedColumn].Tag, OldSelectionPrefix,erfolg)
      else
        ScrollNode := GetNodeWithPrefix(VST, VST.GetFirst, VST.Header.Columns[VST.FocusedColumn].Tag, OldSelectionPrefix,erfolg);
      if erfolg then
      begin
        // den alten deselektieren, und zum neuen hinscrollen, Focus setzen und selektieren
        VST.Selected[VST.FocusedNode] := False;
        VST.ScrollIntoView(ScrollNode, True);
        VST.FocusedNode := ScrollNode;
        VST.Selected[ScrollNode] := True;
      end;
    end;

 {   VK_F4: begin
        TopMainPanel.Tag := TopMainPanel.Height;
        Splitter2.Tag := Splitter2.Left;
        Splitter3.Tag := Splitter3.Left;
        // Auf Seite2 Wechseln
        TabBtn_Search.Click;
    end;
}
    VK_F9: begin
      if NempPlayer.JingleStream = 0 then
      begin
        Node := VST.FocusedNode;
        if not Assigned(Node) then
          Exit;
        Data := VST.GetNodeData(Node);
        NempPlayer.PlayJingle(Data^.FAudioFile);
      end;

    end;
  end;
end;





procedure TNemp_MainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: begin
        //if StopMENU.Visible then
          StopMenuClick(Sender);
        ClipCursor(Nil);
    end;
    VK_F1: if ssShift in shift then
           begin
              PM_P_ViewSeparateWindows_EqualizerClick(NIL);
           end else
           begin

              if NOT FileExists(ExtractFilePath(Paramstr(0))+'faq.htm') then
                MessageDLG((Error_HelpFileNotFound), mtError, [mbOK], 0)
              else
                ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'faq.htm')
                      , nil, nil, SW_SHOWNORMAl);
           end;
    VK_F2: if ssShift in shift then
           begin
              PM_P_ViewSeparateWindows_PlaylistClick(NIL)
           end;
    VK_F3: if ssShift in shift then
           begin
              PM_P_ViewSeparateWindows_MedialistClick(NIL);
           end;
    VK_F4: if ssShift in shift then
           begin
              PM_P_ViewSeparateWindows_BrowseClick(NIL);
           end;
    $54 {T}: if ssCtrl in shift then
           begin
              PM_P_ViewStayOnTopClick(NIL);
           end;

    VK_F8,
    VK_F7: begin
              Anzeigemode := (AnzeigeMode + 1) mod 2;
              if Anzeigemode = 1 then
              begin
                  // Party-mode in Separate-Window-Mode is not allowed.
                  NempSkin.NempPartyMode.Active := False;
                  CorrectFormAfterPartyModeChange;
              end;
              UpdateFormDesignNeu;
           end;

    $42 {B}: if (Anzeigemode = 0) OR Auswahlform.Visible then begin
                //if (ssCtrl in Shift) AND (ssAlt in Shift) then
                //  PlayPrevBTNClick(PlayPrevBTN)
                //else
                  if (ssctrl in Shift) and not LangeAktionWeitermachen then TabBtn_Browse.Click;
            end;
    $46 {F}: if (Anzeigemode = 0) OR Auswahlform.Visible then
                    if (ssctrl in Shift) and not LangeAktionWeitermachen then TabBtn_CoverFlow.Click;

    $31 {1}: if (ssctrl in Shift) then TabBtn_Cover.Click;
    $32 {2}: if (ssctrl in Shift) then TabBtn_Lyrics.Click;
    $33 {3}: if (ssctrl in Shift) then TabBtn_Equalizer.Click;
    $34 {4}: if (ssctrl in Shift) then TabBtn_Effects.Click;

  end;
end;



procedure TNemp_MainForm.VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var c,i:integer;
  dauer:int64;
  groesse:int64;
  SelectedMP3s: TNodeArray;
  aNode: PVirtualNode;
  Data: PTreeData;
  AudioFile: TAudioFile;
begin

  VDTCoverTimer.Enabled := False;

  c := VST.SelectedCount;
  SelectedMP3s := VST.GetSortedSelection(False);
  if c=0 then
  begin
    MedienListeStatusLBL.Caption := '';
    exit;
  end;
  dauer:=0;
  groesse:=0;

  for i:=0 to VST.SelectedCount-1 do
  begin
    aNode := SelectedMP3s[i];
    Data := VST.GetNodeData(aNode);
    AudioFile := Data^.FAudioFile;
    dauer := dauer + AudioFile.Duration;
    groesse := groesse + AudioFile.Size;
  end;

  MedienListeStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCount), [c] )
                                  + SizeToString(groesse)
                                  + SekToZeitString(dauer);


  aNode := VST.FocusedNode;
  if Assigned(aNode) then
  begin
      Data := VST.GetNodeData(aNode);
      AudioFile := Data^.FAudioFile;

      if AudioFile.isStream then
      begin
          //nothing
      end else
      begin
          AudioFile.FileIsPresent := FileExists(AudioFile.Pfad);
          VST.InvalidateNode(aNode);
      end;

      ShowVSTDetails(AudioFile);
      AktualisiereDetailForm(AudioFile, SD_MEDIENBIB);



    {  aNode := AddVDTCover(VDTCover, Nil, AudioFile);
      if VDTCover.Height - Integer(VDTCover.Header.Height) < 240 then
          aNode.NodeHeight := VDTCover.Height - Integer(VDTCover.Header.Height)
      else
          aNode.NodeHeight := 240;
}
      VDTCoverTimer.Enabled := True;
  end
end;

procedure TNemp_MainForm.FillBibDetailLabels(aAudioFile: TAudioFile);
    function SetString(aString: String; add: String = ''): String;
    begin
        if Trim(aString) = '' then
            result := add + ' N/A'
        else
            result := aString;
    end;
begin
    if assigned(aAudioFile) then
    begin
        LblBibArtist    .Caption := SetString(aAudioFile.Artist, AudioFileProperty_Artist);
        LblBibTitle     .Caption := SetString(aAudioFile.Titel, AudioFileProperty_Title);
        LblBibAlbum     .Caption := SetString(aAudioFile.Album, AudioFileProperty_Album);
        LblBibTrack     .Caption := 'Track ' + SetString(IntToStr(aAudioFile.Track));
        LblBibYear      .Caption := SetString(aAudioFile.Year, AudioFileProperty_Year);
        LblBibGenre     .Caption := SetString(aAudioFile.Genre, AudioFileProperty_Genre);
    end;
end;

procedure TNemp_MainForm.ShowVSTDetails(aAudioFile: TAudioFile);
var Coverbmp: TBitmap;
    tmp: String;
begin
  MedienBib.CurrentAudioFile := aAudioFile;

  if aAudioFile = NIL then exit;

  FillBibDetailLabels(aAudioFile);

  EdtBibArtist    .Text := aAudioFile.Artist;
  EdtBibTitle     .Text := aAudioFile.Titel;
  EdtBibAlbum     .Text := aAudioFile.Album;
  EdtBibTrack     .Text := IntToStr(aAudioFile.Track);
  EdtBibYear      .Text := aAudioFile.Year;
  if Trim(aAudioFile.Genre) = '' then
      EdtBibGenre     .Text := 'Other'
  else
      EdtBibGenre     .Text := aAudioFile.Genre;

  LblBibDuration  .Caption := SekToZeitString(aAudioFile.Duration)
                            + ', ' + FloatToStrF((aAudioFile.Size / 1024 / 1024),ffFixed,4,2) + ' MB';

  if aAudioFile.vbr then
      tmp := inttostr(aAudioFile.Bitrate) + ' kbit/s (vbr), '
  else
      tmp := inttostr(aAudioFile.Bitrate) + ' kbit/s, ';
  LblBibQuality.Caption := tmp + aAudioFile.SampleRate + ', ' + aAudioFile.ChannelMode;

  BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);

  LblBibTags.Caption := StringReplace(aAudioFile.RawTagLastFM, #13#10, ', ', [rfreplaceAll]);
  // Get Cover
  Coverbmp := tBitmap.Create;
  try
      Coverbmp.Width := 250;
      Coverbmp.Height := 250;

      // Bild holen - (das ist ne recht umfangreiche Prozedur!!)
      if GetCover(aAudioFile, Coverbmp) then
      begin
          ImgDetailCover.Picture.Bitmap.Assign(Coverbmp);
          ImgDetailCover.Refresh;
      end;
  finally
      Coverbmp.Free;
  end;
end;

procedure TNemp_MainForm.VDTCoverClick(Sender: TObject);
begin
    // Disable Editing
    ShowLabelAgain(EdtBibArtist, GetCorrespondingLabel(EdtBibArtist));
    ShowLabelAgain(EdtBibTitle , GetCorrespondingLabel(EdtBibTitle ));
    ShowLabelAgain(EdtBibAlbum , GetCorrespondingLabel(EdtBibAlbum ));
    ShowLabelAgain(EdtBibTrack , GetCorrespondingLabel(EdtBibTrack ));
    ShowLabelAgain(EdtBibYear  , GetCorrespondingLabel(EdtBibYear  ));
    ShowLabelAgain(EdtBibGenre , GetCorrespondingLabel(EdtBibGenre ));
end;

procedure TNemp_MainForm.VDTCoverResize(Sender: TObject);
var dim: Integer;
begin
    // Compute better Imagesize
    if VDTCover.Height < VDTCover.Width - 100 then
        dim := VDTCover.Height
    else
        dim := VDTCover.Width - 100;

    if dim > 250 then
        dim := 250;

    ImgDetailCover.Width  := dim;
    ImgDetailCover.Height := dim;

    LblBibArtist  .left := dim + 8;
    LblBibTitle   .left := dim + 8;
    LblBibAlbum   .left := dim + 8;
    LblBibTrack   .left := dim + 8;
    LblBibYear    .left := dim + 8;
    LblBibGenre   .left := dim + 8;
    LblBibDuration.left := dim + 8;
    LblBibQuality .left := dim + 8;
    ImgBibRating  .left := dim + 8;
    LblBibTags    .left := dim + 8;
    LblBibTags.Width := VDTCover.Width - dim - 10;
    LblBibTags.Height := VDTCover.Height - LblBibTags.Top - 8;

    // Disable Editing
    ShowLabelAgain(EdtBibArtist, GetCorrespondingLabel(EdtBibArtist));
    ShowLabelAgain(EdtBibTitle , GetCorrespondingLabel(EdtBibTitle ));
    ShowLabelAgain(EdtBibAlbum , GetCorrespondingLabel(EdtBibAlbum ));
    ShowLabelAgain(EdtBibTrack , GetCorrespondingLabel(EdtBibTrack ));
    ShowLabelAgain(EdtBibYear  , GetCorrespondingLabel(EdtBibYear  ));
    ShowLabelAgain(EdtBibGenre , GetCorrespondingLabel(EdtBibGenre ));
end;

procedure TNemp_MainForm.ImgBibRatingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft  then
        if Assigned(MedienBib.CurrentAudioFile) then
        begin
            MedienBib.CurrentAudioFile.Rating := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
            MedienBib.Changed := True;
            // Set this rating in all copies of the file in the Playlist
            NempPlaylist.UnifyRating(MedienBib.CurrentAudioFile.Pfad, MedienBib.CurrentAudioFile.Rating);
            VST.Invalidate;
        end;
end;

procedure TNemp_MainForm.ImgBibRatingMouseLeave(Sender: TObject);
var aNode: PVirtualNode;
    Data: PTreeData;
    AudioFile: TAudioFile;
begin
    //aNode := VST.FocusedNode;
    if Assigned(MedienBib.CurrentAudioFile) then
    //begin
    //    Data := VST.GetNodeData(aNode);
    //    AudioFile := Data^.FAudioFile;
        BibRatingHelper.DrawRatingInStarsOnBitmap(MedienBib.CurrentAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height)
    //end
    else
        BibRatingHelper.DrawRatingInStarsOnBitmap(128, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
end;

procedure TNemp_MainForm.ImgBibRatingMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var rat: Integer;
begin
  // draw stars according to current mouse position
  rat := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
  BibRatingHelper.DrawRatingInStarsOnBitmap(rat, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
end;


// Show the corresponding TEdit and set the Caption
procedure TNemp_MainForm.AdjustEditToLabel(aEdit: TControl; aLabel: TLabel);
var w: Integer;
begin
    aEdit.Top := aLabel.Top - 4;
    aEdit.Left := aLabel.Left - 4;

    // Necessary here: (Re)Set aEdit.Text
    if Assigned(MedienBib.CurrentAudioFile) then
    begin
        EdtBibArtist    .Text := MedienBib.CurrentAudioFile.Artist;
        EdtBibTitle     .Text := MedienBib.CurrentAudioFile.Titel;
        EdtBibAlbum     .Text := MedienBib.CurrentAudioFile.Album;
        EdtBibTrack     .Text := IntToStr(MedienBib.CurrentAudioFile.Track);
        EdtBibYear      .Text := MedienBib.CurrentAudioFile.Year;
        if Trim(MedienBib.CurrentAudioFile.Genre) = '' then
            EdtBibGenre     .Text := 'Other'
        else
            EdtBibGenre     .Text := MedienBib.CurrentAudioFile.Genre;
    end;

    if (aEdit is TComboBox) then
        w := 150
    else
    begin
        w := aLabel.Width + 14;
        if w < 150 then
            w := 150;
    end;

    if w + aEdit.Left > VDTCover.Width then
        w := VDTCover.Width - aEdit.Left;
    aEdit.Width := w;

    aLabel.Visible := False;
    aEdit.Visible := True;

    if (aEdit is TEdit) then
        (aEdit as TEdit).SetFocus;
    if (aEdit is TComboBox) then
        (aEdit as TComboBox).SetFocus;
end;

// Show the Label, Hide the Edit. Do not Change AudioFile-Information
procedure TNemp_MainForm.ShowLabelAgain(aEdit: TControl; aLabel: TLabel);
begin
    aLabel.Visible := True;
    LblBibGenre.Visible := True;
    aEdit.Visible := False;
end;

function TNemp_MainForm.GetCorrespondingEdit(aLabel: TLabel): TControl;
begin
    case aLabel.Tag of
        0: Result := EdtBibArtist;
        1: Result := EdtBibTitle;
        2: Result := EdtBibAlbum;
        3: Result := EdtBibTrack;
        4: Result := EdtBibYear;
        5: Result := EdtBibGenre;
    else
         Result := EdtBibArtist;
    end;
end;
function TNemp_MainForm.GetCorrespondingLabel(aEdit: TControl): TLabel;
begin
    case aEdit.Tag of
        0: Result := LblBibArtist;
        1: Result := LblBibTitle;
        2: Result := LblBibAlbum;
        3: Result := LblBibTrack;
        4: Result := LblBibYear;
        5: Result := LblBibGenre;
    else
         Result := LblBibArtist;
    end;
end;

// OnLblClick  : Show the Edit
// OnEditExit  : Show the Label again, do not Change Information
// OnKeyEscape : Show the Label again, do not Change Information
// OnKeyEnter  : Show the Label again, update the Information
procedure TNemp_MainForm.LblBibArtistClick(Sender: TObject);
begin
    AdjustEditToLabel(GetCorrespondingEdit(Sender as TLabel), Sender as TLabel);
end;
procedure TNemp_MainForm.EdtBibArtistExit(Sender: TObject);
begin
    ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
end;
procedure TNemp_MainForm.EdtBibArtistKeyPress(Sender: TObject; var Key: Char);
begin
    case Ord(key) of
        VK_Escape: begin
              key := #0;
              ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
        end;
        VK_RETURN: begin
              if Assigned(MedienBib.CurrentAudioFile) then
              begin
                  case (Sender as TControl).Tag of
                      0: MedienBib.CurrentAudioFile.Artist := EdtBibArtist.Text;
                      1: MedienBib.CurrentAudioFile.Titel  := EdtBibTitle.Text;
                      2: MedienBib.CurrentAudioFile.Album  := EdtBibAlbum.Text;
                      3: MedienBib.CurrentAudioFile.Track  := StrToIntDef(EdtBibTrack.Text, 0);
                      4: MedienBib.CurrentAudioFile.Year   := EdtBibYear.Text;
                      5: MedienBib.CurrentAudioFile.Genre  := EdtBibGenre.Text;
                  end;
                  FillBibDetailLabels(MedienBib.CurrentAudioFile);
                  MedienBib.Changed := True;
                  NempPlaylist.UnifyRating(MedienBib.CurrentAudioFile.Pfad, MedienBib.CurrentAudioFile.Rating);
                  VST.Invalidate;
              end;
              key := #0;
              ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
        end;
    end;
end;


function TNemp_MainForm.ValidAudioFile(filename: UnicodeString; JustPlay:Boolean):boolean;
var extension: string;
begin
  extension := AnsiLowerCase(ExtractFileExt(filename));

  if Justplay OR MedienBib.IncludeAll then
  begin
    //showmessage('just play');
    result := (Extension <> '.m3u') AND (Extension <> '.m3u8')
          AND (Extension <> '.pls') AND (Extension <> '.gmp')
          AND (Extension <> '.cue') AND (Extension <> '.npl')
          AND (Extension <> '.asx') AND (Extension <> '.wax')
          ;
  end
  else // Aufnahme in die Medienliste verlangt, und nicht "alles rein" in den Optionen gew�hlt
  // also genauer pr�fen
  begin
  if (extension='.mp3') AND MedienBib.IncludeMP3 then result := True
    else if (extension='.ogg') AND MedienBib.IncludeOGG then result := True
      else if (extension='.wav') AND MedienBib.IncludeWAV then result := True
        else if (extension='.wma') AND MedienBib.IncludeWMA then result := True
          else if (extension='.mp1') AND MedienBib.IncludeMP1 then result := True
            else if (extension='.mp2') AND MedienBib.IncludeMP2 then result := True
              else
                result := False;
  end;
end;

procedure TNemp_MainForm.PM_ML_GetLyricsClick(Sender: TObject);
var // i:integer;
    // Data: PTreeData;
    SelectedMp3s: TNodeArray;

begin
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
      MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    if NempOptions.DenyID3Edit then
    begin
      MessageDLG((Error_ID3EditDenied), mtInformation, [mbOK], 0);
      exit; // Edit nicht erlaubt
    end;
    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        MessageDLG((Medialibrary_GUIError5), mtError, [MBOK], 0);
    end else
    begin
          if not assigned(NoLyricWikiApiForm) then
              Application.CreateForm(TNoLyricWikiApiForm, NoLyricWikiApiForm);
          NoLyricWikiApiForm.ShowModal;

    {
        MedienBib.StatusBibUpdate := 1;
        BlockeMedienListeUpdate(True);

        SelectedMP3s := VST.GetSortedSelection(False);
        for i:=0 to length(SelectedMP3s)-1 do
        begin
            Data := VST.GetNodeData(SelectedMP3s[i]);
            MedienBib.UpdateList.Add(Data^.FAudioFile);
        end;

        MedienBib.GetLyrics;
    }
    end;
end;


procedure TNemp_MainForm.PM_ML_GetTagsClick(Sender: TObject);
var  i:integer;
     Data: PTreeData;
    SelectedMp3s: TNodeArray;
begin
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
      MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    if NempOptions.DenyID3Edit then
    begin
      MessageDLG((Error_ID3EditDenied), mtInformation, [mbOK], 0);
      exit; // Edit nicht erlaubt
    end;
    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        MessageDLG((Medialibrary_GUIError5), mtError, [MBOK], 0);
    end else
    begin

        MedienBib.StatusBibUpdate := 1;
        BlockeMedienListeUpdate(True);

        SelectedMP3s := VST.GetSortedSelection(False);
        for i:=0 to length(SelectedMP3s)-1 do
        begin
            Data := VST.GetNodeData(SelectedMP3s[i]);
            MedienBib.UpdateList.Add(Data^.FAudioFile);
        end;

        MedienBib.GetTags;

    end;
end;



procedure TNemp_MainForm.VSTBeforeItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
  var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  if not NempSkin.isActive then
  with TargetCanvas do
  begin
      if Node.Index mod 2 = 0 then
        ItemColor := $EEEEEE  //$49DDEF // $70A33F // $436BFF
      else
        ItemColor := VST.Color;
      EraseAction := eaColor;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTAfterItemPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
begin
  with TargetCanvas do
  begin
    if (Node = NempPlaylist.PlayingNode) Or (Node = NempPlaylist.ActiveCueNode) then
    begin
      if NempSkin.isActive then
        Pen.Color := NempSkin.SkinColorScheme.PlaylistPlayingFileColor
      else
        Pen.Color := clGradientActiveCaption;
      pen.Width := 2;//3;
      Polyline([Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent) * Integer(PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1),
            Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Bottom-1),
            Point(ItemRect.Right-1, ItemRect.Bottom-1),
            Point(ItemRect.Right-1, ItemRect.Top+1),
            Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1)]
            );
    end;
  end;
end;

procedure TNemp_MainForm.StringVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var Data: PStringTreeData;
begin
  Data:=Sender.GetNodeData(Node);
  if TJustAstring(Data^.FString).DataString = BROWSE_ALL then
      CellText := _('<All Files>')
  else
      if TJustAstring(Data^.FString).DataString = BROWSE_PLAYLISTS then
          CellText := _('<Playlists>')
      else
          if TJustAstring(Data^.FString).DataString = BROWSE_RADIOSTATIONS then
              CellText := _('<Webradio>')
          else
              CellText := TJustAstring(Data^.FString).AnzeigeString;
end;


// When editing audiofiles, the browse-lists may become invalid
// in this case, a Warning-Icon should be displayed in the first Browse-Button
procedure TNemp_MainForm.SetBrowseTabWarning(ShowWarning: Boolean);
begin
    if ShowWarning then
    begin
        // Show a warning-sign
        if Medienbib.BrowseMode = 0 then
        begin
            // Browsing by artist-album activated
            TabBtn_Browse.GlyphLine := 2;
        end else
            // Browsing by cover (or something else) activated
            TabBtn_Browse.GlyphLine := 0;
        TabBtn_Browse.Hint := TabBtnBrowse_Hint1 + #13#10 + TabBtnBrowse_Hint2;

    end else
    begin
        // Show Default-Button
        if Medienbib.BrowseMode = 0 then
        begin
            // Browsing by artist-album activated
            TabBtn_Browse.GlyphLine := 1;
        end else
            // Browsing by cover (or something else) activated
            TabBtn_Browse.GlyphLine := 0;
        TabBtn_Browse.Hint := TabBtnBrowse_Hint1;
    end;
    // Refresh the Button
    TabBtn_Browse.Refresh;
end;

procedure TNemp_MainForm.ReFillBrowseTrees(RemarkOldNodes: LongBool);
var ArtistNode, AlbumNode: PVirtualNode;
  ArtistData, AlbumData: PStringTreeData;
  Artist, Album: UnicodeString;
begin

  if MedienBib.BrowseMode = 0 then
  begin
                // erneuert nach einer Einf�ge/L�sch/Edit-aktion die oberen beiden Listen
                // die alten Knoten werden nach M�glichkeit wieder selektiert/focussiert
                // Change auf Nil setzen
                ArtistsVST.OnFocusChanged := NIL;
                AlbenVST.OnFocusChanged := NIL;
  
                // linke Liste f�llen
                if MedienBib.NempSortArray[1] = siOrdner then
                  FillStringTreeWithSubNodes(MedienBib.AlleArtists, ArtistsVST)
                else
                  FillStringTree(MedienBib.AlleArtists, ArtistsVST);

                if RemarkOldNodes then
                begin
                    ArtistNode := GetOldNode(MedienBib.CurrentArtist, ArtistsVST);
                    if assigned(ArtistNode) then
                    begin
                        ArtistData := ArtistsVST.GetNodeData(ArtistNode);
                        Artist := TJustAstring(ArtistData^.FString).DataString;
                    end else
                        Artist := BROWSE_ALL;
                end else
                begin
                    ArtistNode := ArtistsVST.GetFirst;
                    if assigned(ArtistNode) then
                        ArtistNode := ArtistsVST.GetNextSibling(ArtistNode);
                    if assigned(ArtistNode) then
                        ArtistNode := ArtistsVST.GetNextSibling(ArtistNode);
                    Artist := BROWSE_ALL;
                end;
                // neuen (alten) Knoten (wieder) focussieren
                ArtistsVST.ScrollIntoView(ArtistNode, True);
                ArtistsVST.FocusedNode := ArtistNode;
                ArtistsVST.Selected[ArtistNode] := True;

                // zum markierten Knoten passende Albenliste bestimmen lassen
                MedienBib.GetAlbenList(Artist);
                //...und anzeigen
                if MedienBib.NempSortArray[2] = siOrdner then
                    FillStringTreeWithSubNodes(MedienBib.Alben, AlbenVST)
                else
                    FillStringTree(MedienBib.Alben, AlbenVST);

                if RemarkOldNodes then
                begin
                    AlbumNode := GetOldNode(MedienBib.CurrentAlbum, AlbenVST);
                    if assigned(AlbumNode) then
                    begin
                        AlbumData := AlbenVST.GetNodeData(AlbumNode);
                        Album := TJustAstring(AlbumData^.FString).DataString;
                    end else
                        Album := BROWSE_ALL;
                end else
                begin
                    AlbumNode := AlbenVST.GetFirst;
                    Album := BROWSE_ALL;
                end;
                // neuen (alten) Knoten (wieder) focussieren
                AlbenVST.ScrollIntoView(AlbumNode, True);
                AlbenVST.FocusedNode := AlbumNode;
                AlbenVST.Selected[AlbumNode] := True;

                MedienBib.GenerateAnzeigeListe(Artist, Album);

                // Change wieder umsetzen
                ArtistsVST.OnFocusChanged := ArtistsVSTFocusChanged;
                AlbenVST.OnFocusChanged := AlbenVSTFocusChanged;
  end else
  begin

     If MedienBib.Coverlist.Count > 3 then
                  CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                else
                  CoverScrollbar.Max := 3;

     MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
     CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
     CoverScrollbarChange(Nil);
     MedienBib.NewCoverFlow.Paint(10);
  end;

  SetBrowseTabWarning(False);
end;


procedure TNemp_MainForm.ArtistsVSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender = ArtistsVST then
      if (Node.Index <= 2) And (Node.Parent = (Sender as TBaseVirtualTree).RootNode) then
          TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsbold];

  if (Sender = AlbenVST) AND (MedienBib.CurrentArtist <> BROWSE_PLAYLISTS) AND (MedienBib.CurrentArtist <> BROWSE_RADIOSTATIONS) then
      if (Node.Index = 0) And (Node.Parent = (Sender as TBaseVirtualTree).RootNode) then
          TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsbold];


  With TargetCanvas Do
  begin
    if  (NempSkin.isActive) AND
        (vsSelected in Node.States) AND
        (Sender.Focused) then
    begin
      if Sender = ArtistsVST then font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[1]
      else if Sender = AlbenVST then font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[2]
    end;
  end;
end;

procedure TNemp_MainForm.ArtistsVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var aNode, oldAlbumNode: PVirtualNode;
  OldAlbumData: PStringTreeData;
  OldAlbum: UnicodeString;
  OldAlbumIDX, i : Integer;
  Data: PStringTreeData;
begin
  aNode := ArtistsVST.FocusedNode;
  if not Assigned(aNode) then
      Exit;

  // Vorher: alten Alben Knoten merken.
  // K�nnte sein, dass jetzt Artist <Alle> markiert ist
  // Dann sollen alle Titel des Albums angezeigt werden
  OldAlbumNode := AlbenVST.FocusedNode;
  if Assigned(OldAlbumNode) then
  begin
    OldAlbumData := AlbenVST.GetNodeData(OldAlbumNode);
    OldAlbum := TJustAstring(OldAlbumData^.FString).DataString;
  end else
    OldAlbum := BROWSE_ALL;
  AlbenVST.OnFocusChanged := NIL;

  Data := ArtistsVST.GetNodeData(aNode);

  MedienBib.CurrentArtist := TJustAstring(Data^.FString).DataString;
  MedienBib.ArtistIndex := aNode.Index;


  Medienbib.GetAlbenList(MedienBib.CurrentArtist);
  if MedienBib.NempSortArray[2] = siOrdner then
    FillStringTreeWithSubNodes(Medienbib.Alben, AlbenVST)
  else
    FillStringTree(Medienbib.Alben, AlbenVST);

  // Alten Knoten wieder suchen
  // Der Index kann erst hier bestimmt werden, da sich die Alben liste ge�ndert hat!
  OldAlbumIDX := -1;
  for i:=0 to MedienBib.Alben.Count - 1 do
    if (MedienBib.Alben[i] as TJustaString).DataString = OldAlbum then
    begin
      OldAlbumIDX := i;
      break;
    end;

  if OldAlbumIDX > -1 then                       // Knoten existiert noch
  begin
    OldAlbumNode := AlbenVST.GetFirst;
    for i := 0 to OldAlbumIDX-1 do
      if assigned(OldAlbumNode) then
        OldAlbumNode := AlbenVST.GetNext(OldAlbumNode)
  end else                                       // Knoten existiert nicht mehr
  begin
    OldAlbumNode := AlbenVST.GetFirst;
    OldAlbum := BROWSE_ALL;
    MedienBib.CurrentAlbum := BROWSE_ALL;
  end;
  // alten Knoten focussieren
  AlbenVST.ScrollIntoView(OldAlbumNode, True);
  AlbenVST.FocusedNode := OldAlbumNode;
  AlbenVST.Selected[OldAlbumNode] := True;

  // Fill Auswahlliste
  MedienBib.GenerateAnzeigeListe(TJustAstring(Data^.FString).DataString, OldAlbum);
  // sollte automatisch gehen....FillTreeView(VST, AnzeigeListe);


  // OnChange wieder umsetzen? Muss das �berhaupt?
  AlbenVST.OnFocusChanged := AlbenVSTFocusChanged;
  // ????

end;

procedure TNemp_MainForm.ArtistsVSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var aString: String;
    Data:PStringTreeData;
begin
    // Used for next Search with "F3"
    OldSelectionPrefix := SearchText;

    Data := Sender.GetNodeData(Node);
    aString := TJustAstring(Data^.FString).AnzeigeString;
    Result := StrLIComp(PChar(SearchText), PChar(aString), Min(length(SearchText), length(aString)));
end;

procedure TNemp_MainForm.AlbenVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var FocussedArtistNode: PVirtualNode;
  ArtistData, AlbumData: PStringTreeData;
  Artist, Album: UnicodeString;
  Station: TStation;
begin
  if not assigned(node) then exit;

  FocussedArtistNode := ArtistsVST.FocusedNode;
  if assigned(FocussedArtistNode) then
  begin
    ArtistData := ArtistsVST.GetNodeData(FocussedArtistNode);
    Artist := TJustAstring(ArtistData^.FString).DataString;
  end else Artist := BROWSE_ALL;

  AlbumData := AlbenVST.GetNodeData(node);
  Album := TJustAstring(AlbumData^.FString).DataString;
  MedienBib.CurrentAlbum := Album;
  MedienBib.AlbumIndex := Node.Index;

  if Artist = BROWSE_RADIOSTATIONS then
  begin
      if Integer(Node.Index) < MedienBib.RadioStationList.Count then
      begin
          Station := TStation(MedienBib.RadioStationList[Node.Index]);
          AuswahlStatusLBL.Caption := Station.GetInfoString;
      end
      else
          MessageDlg(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);

  end else
      MedienBib.GenerateAnzeigeListe(Artist, Album);
end;


procedure TNemp_MainForm.StringVSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var ScrollNode, albumNode, artistNode: PVirtualNode;
  erfolg:boolean;
  aTree: TVirtualStringTree;
  AlbumData: PStringTreeData;
  ArtistData: PStringTreeData;
  artist: UnicodeString;


      function GetStringNodeWithPrefix(aTree: TVirtualStringTree; StartNode:PVirtualNode; Prefix:string; var Erfolg:boolean):PVirtualNode;
      // erfolg gibt an, ob man beim kompletten Durchlauf des Baumes einen weiteren Knoten mit den
      // gew�nschten Eigenschaften gefunden hat.
      // Wenn man beim Startknoten wieder ankommt, gibt es keinen (weiteren) Knoten mit dem
      // entsprechenden Prefix.
      var nextnode:PVirtualnode;
          Data:PStringTreeData;
          aString: UnicodeString;
      begin
          erfolg := false;
          nextnode := startNode;
          repeat
            Data := aTree.GetNodeData(nextnode);
            aString := TJustAstring(Data^.FString).AnzeigeString;
            erfolg := AnsiStartsText(Prefix, aString);
            result := Nextnode;
            // n�chsten Knoten w�hlen
            nextnode := aTree.GetNext(nextnode);
            // oder vorne wieder anfangen
            if nextnode = NIL then
              nextnode := aTree.GetFirst;
          until erfolg or (nextnode = startnode);
          if not erfolg then result := nextnode;
      end;

begin
  // Das dann der Form.OnKEydown �berlassen
  if ssctrl in Shift then exit;

  aTree := Sender as TVirtualStringTree;
  case key of
    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      if not Assigned(aTree.FocusedNode) then Exit;
      // n�chstes Vorkommen des Prefixes suchen, dazu: beim n�chsten Knoten beginnen
      if aTree.GetNext(aTree.FocusedNode) <> NIL then
        ScrollNode := GetStringNodeWithPrefix(aTree, aTree.GetNext(aTree.FocusedNode), OldSelectionPrefix, erfolg)
      else
        ScrollNode := GetStringNodeWithPrefix(aTree, aTree.GetFirst, OldSelectionPrefix, erfolg);
      if erfolg then
      begin
        aTree.ScrollIntoView(ScrollNode, True);
        aTree.FocusedNode := ScrollNode;
        aTree.Selected[ScrollNode] := True;
      end;
    end;
    VK_RETURN: begin
      albumNode := AlbenVST.FocusedNode;
      if not Assigned(albumNode) then
        Exit;
      //AlbumData := AlbenVST.GetNodeData(albumNode);
      artistNode := ArtistsVST.FocusedNode;
      if assigned(ArtistNode) then
      begin
          ArtistData := ArtistsVST.GetNodeData(ArtistNode);
          artist := TJustAstring(ArtistData^.FString).DataString;
      end else
          artist := BROWSE_ALL;


      if artist = BROWSE_RADIOSTATIONS then
      begin
          if Integer(AlbumNode.Index) < MedienBib.RadioStationList.Count then
          begin
              TStation(MedienBib.RadioStationList[AlbumNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist);
          end
          else
              MessageDlg(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
      end else
      if (artist <> BROWSE_PLAYLISTS) then
      begin
          AlbumData := AlbenVST.GetNodeData(albumNode);
          MedienBib.GenerateAnzeigeListe(BROWSE_ALL, TJustAstring(AlbumData^.FString).DataString);
      end;
    end;
  end;
end;


procedure TNemp_MainForm.AlbenVSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var
    albumNode, artistNode: PVirtualNode;
    AlbumData: PStringTreeData;
    ArtistData: PStringTreeData;
    artist: UnicodeString;
begin
  // Sinn: Zeige alle Titel eines Albums an.
  albumNode := AlbenVST.FocusedNode;
  if not Assigned(albumNode) then
      Exit;

  artistNode := ArtistsVST.FocusedNode;
  if assigned(ArtistNode) then
  begin
      ArtistData := ArtistsVST.GetNodeData(ArtistNode);
      artist := TJustAstring(ArtistData^.FString).DataString;
  end else
      artist := BROWSE_ALL;


  if artist = BROWSE_RADIOSTATIONS then
  begin
      if Integer(AlbumNode.Index) < MedienBib.RadioStationList.Count then
      begin
          TStation(MedienBib.RadioStationList[AlbumNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist);
      end
      else
          MessageDlg(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
  end else
  begin
      if (artist <> BROWSE_PLAYLISTS) then
      begin
          AlbumData := AlbenVST.GetNodeData(albumNode);
          MedienBib.GenerateAnzeigeListe(BROWSE_ALL, TJustAstring(AlbumData^.FString).DataString);
      end;
  end;
end;

procedure TNemp_MainForm.Splitter3Moved(Sender: TObject);
begin
  //xx//Splitter3.Tag := Splitter3.Left;
end;

procedure TNemp_MainForm.Splitter2Moved(Sender: TObject);
begin
  //xx//Splitter2.Tag := Splitter2.Left;
  if NempSkin.isActive then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetArtistAlbumOffsets;
    NempSkin.SetVSTOffsets;
    NempSkin.SetPlaylistOffsets;
    NempSkin.FitSkinToNewWindow;
    RepaintPanels;
  end;
end;

procedure TNemp_MainForm.Splitter1Moved(Sender: TObject);
begin
  if NempSkin.isActive then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetVSTOffsets;
    RepaintPanels;
  end;
end;

procedure TNemp_MainForm.BassTimerTimer(Sender: TObject);
begin
  //basstimer.Tag := basstimer.Tag +1;  Label15.Caption := IntTostr(Basstimer.Tag);
  if NempPlayer.BassStatus = BASS_ACTIVE_PLAYING then
  begin
        NempPlayer.DrawInfo;

        if SlideBarButton.Tag = 0 then // d.h. der Button wird grade nicht gedraggt
          SlideBarButton.Left := SlideBarShape.Left + Round((SlideBarShape.Width-SlideBarButton.Width) * NempPlayer.Progress);

        if NempPlayer.ScrollTaskbarTitel then
        begin
          inc(TaskBarDelay);
          if TaskBarDelay >= NempPlayer.ScrollTaskbarDelay then
          begin
            Application.Title := copy(Application.Title, 2 , length(Application.Title)- 1) + Application.Title[1];
            TaskBarDelay := 0;
          end;
        end;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var Data: PTreeData;
begin
  Data:=Sender.GetNodeData(Node);
  if not assigned(Data) then exit;

  case Column of
    0: begin
          cellText := //inttostr(Node.Index) + ' - ' + IntToStr(NempPlaylist.Playlist.IndexOf(Data^.FAudioFile)) + ' - ' +
            Data^.FAudioFile.PlaylistTitle;
       end;
    1:  begin
          if PlaylistVST.GetNodeLevel(Node) = 0 then
          begin
            if Data^.FAudioFile.isStream then
              CellText := '(inf)'
            else
              CellText := SekIntToMinStr(Data^.FAudioFile.Duration);
          end else
            CellText := '@' + SekIntToMinStr(Round(Data^.FAudioFile.Index01));// Da steht der INdex drin
        end;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
  //NempPlayer.AutoPlayNextFile := Not ((GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0));
  NempPlaylist.UserInput;
  NempPlayer.LastUserWish := USER_WANT_PLAY;
  NempPlaylist.PlayFocussed;
  Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
end;

procedure TNemp_MainForm.PlaylistVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var aRect: TRect;
begin
  DragSource := DS_PLAYLIST;
  ARect.TopLeft :=  (GRPBOXPlaylist.ClientToScreen(Point(PlaylistVST.Left, PlaylistVST.Top)));
  ARect.BottomRight :=  (GRPBOXPlaylist.ClientToScreen(Point(PlaylistVST.Left + PlaylistVST.Width, PlaylistVST.Top + PlaylistVST.Height)));
  ClipCursor(@Arect);
  SelectedPlayListMp3s := PlaylistVST.GetSortedSelection(True);
end;

procedure TNemp_MainForm.PlaylistVSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);

const MOVE_UP = 0;
      MOVE_DOWN = 1;

  function IsInSelectionArray(aNode:PVirtualnode; NodeArray:TNodeArray ):boolean;
  var i:integer;
  begin
    result := False;
    for i := 0 to length(SelectedPlayListMp3s)-1 do
      if aNode = NodeArray[i] then
      begin
        result := True;
        //Break;
      end;
  end;

  function AllowMove(Direction: integer): boolean;
  var aNode: PVirtualNode;
  begin
    case Direction of
      MOVE_UP: begin
                 aNode := playlistVST.GetPrevious(SelectedPlayListMp3s[0]);
                 result := assigned(aNode)
                               AND (PlaylistVST.GetNodeLevel(aNode) = 0)
                               AND (NOT PlaylistVST.Expanded[aNode]);
              end;
      MOVE_DOWN: begin
                 aNode := playlistVST.GetNext(SelectedPlayListMp3s[high(SelectedPlayListMp3s)]);
                 result := assigned(aNode)
                               AND (PlaylistVST.GetNodeLevel(aNode) = 0)
                               AND (NOT PlaylistVST.Expanded[aNode]);
              end
      else result := true;
    end;
  end;

var aNode: PVirtualNode;
  i:integer;
begin

  if Source <> PlaylistVST then exit;

  if Dragsource = DS_PLAYLIST then
  begin
    accept := True;
    Effect := DROPEFFECT_MOVE;

    aNode := PlayListVST.GetNodeAt(Pt.x, Pt.Y);

    if (pt.Y >= NempPlaylist.YMouseDown + Integer(PlaylistVST.DefaultNodeHeight))
      OR ( (Not IsInSelectionArray(aNode, SelectedPlayListMp3s))
            AND
            (pt.Y > Integer(NempPlaylist.YMouseDown)) )
    then
    begin
      While ((pt.Y >= NempPlaylist.YMouseDown + Integer(PlaylistVST.DefaultNodeHeight))
            OR
            ( (Not IsInSelectionArray(aNode, SelectedPlayListMp3s))
               AND
               (NOT PlaylistVST.GetNodeLevel(aNode)=1)
               AND
              (pt.Y > Integer(NempPlaylist.YMouseDown)) ))
            AND
            (SelectedPlayListMp3s[length(SelectedPlayListMp3s)-1].NextSibling <> NIL) do
      begin
        // moven nur, wenn aNode Level 0 hat
        if (PlaylistVST.GetNodeLevel(aNode) = 0) AND (NOT PlaylistVST.Expanded[aNode]) then //AllowMove(MOVE_UP) then
              for i := length(SelectedPlayListMp3s)-1 downto 0 do
              begin
                if (PlaylistVST.GetNodeLevel(SelectedPlayListMp3s[i]) = 0) then
                begin
                  NempPlaylist.Playlist.Move(SelectedPlayListMp3s[i].Index,SelectedPlayListMp3s[i].Index+1);
                  PlaylistVST.MoveTo(SelectedPlayListMp3s[i],SelectedPlayListMp3s[i].NextSibling,amInsertAfter,false);
                end;
              end;
        NempPlaylist.YMouseDown := NempPlaylist.YMouseDown + Integer(PlaylistVST.DefaultNodeHeight);
      end;
    end

    else

    if (pt.Y < NempPlaylist.YMouseDown - Integer(PlaylistVST.DefaultNodeHeight))
      OR ( (Not IsInSelectionArray(aNode, SelectedPlayListMp3s))
            AND
            (pt.Y < Integer(NempPlaylist.YMouseDown)) )
    then
    begin
      while ((pt.Y < NempPlaylist.YMouseDown - Integer(PlaylistVST.DefaultNodeHeight))
            OR
            ( (Not IsInSelectionArray(aNode, SelectedPlayListMp3s))
               AND
               (NOT PlaylistVST.GetNodeLevel(aNode)=1)
               AND
              (pt.Y < Integer(NempPlaylist.YMouseDown)) ))
            AND
            (SelectedPlayListMp3s[0].PrevSibling <> NIL)
      do
      //if SelectedPlayListMp3s[0].PrevSibling <> NIL then
      begin
        // moven nur, wenn aNode Level 0 hat
        if (PlaylistVST.GetNodeLevel(aNode) = 0) then //AllowMove(MOVE_DOWN) then
                for i := 0 to length(SelectedPlayListMp3s)-1 do
                begin
                  if (PlaylistVST.GetNodeLevel(SelectedPlayListMp3s[i]) = 0) then
                  begin
                    NempPlaylist.Playlist.Move(SelectedPlayListMp3s[i].Index,SelectedPlayListMp3s[i].Index-1);
                    PlaylistVST.MoveTo(SelectedPlayListMp3s[i],SelectedPlayListMp3s[i].PrevSibling,amInsertBefore,false);
                  end;
                end;
        //PlayListYMouseDown := pt.Y;
        NempPlaylist.YMouseDown := NempPlaylist.YMouseDown - Integer(PlaylistVST.DefaultNodeHeight);
      end;
    end;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
begin
  ClipCursor(Nil);
  DragSource := DS_EXTERN;
  NempPlaylist.ReInitPlaylist;
end;

procedure TNemp_MainForm.PlaylistVSTMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ClipCursor(Nil);
end;


procedure TNemp_MainForm.PlaylistVSTMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  NempPlaylist.YMouseDown := Y;
end;

procedure TNemp_MainForm.SlideBarShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  NewPos := SlideBarShape.Left + x - (SlideBarButton.Width Div 2);
  if NewPos <= SlideBarShape.Left then
      NewPos := SlideBarShape.Left
    else
      if NewPos >= SlideBarShape.Left + SlideBarShape.Width - SlideBarButton.Width then
        NewPos := SlideBarShape.Left + SlideBarShape.Width - SlideBarButton.Width;
        
  SlideBarButton.Left := NewPos;
  NempPlaylist.Progress := (SlideBarButton.Left-SlideBarShape.Left) / (SlideBarShape.Width-SlideBarButton.Width);
end;

procedure TNemp_MainForm.SlideBarButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
  with (Sender as TControl) do Begindrag(false);
  ARect.TopLeft :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left, NewPlayerPanel.Top)));
  ARect.BottomRight :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left + NewPlayerPanel.Width, NewPlayerPanel.Top + NewPlayerPanel.Height)));
  SlideBarButton.Tag := 1;
  ClipCursor(@Arect);
end;

procedure TNemp_MainForm.GrpBoxControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos: Integer;
begin
    if Source = SlideBarButton then
    begin
        if (Sender is TNempPanel) then
            NewPos := x - (SlideBarButton.Width Div 2)
        else
            NewPos := (Sender as TControl).Left + x - (SlideBarButton.Width Div 2);

        if NewPos <= SlideBarShape.Left then
            NewPos := SlideBarShape.Left
        else
            if NewPos >= SlideBarShape.Width  + SlideBarShape.Left - SlideBarButton.Width then
                NewPos := SlideBarShape.Width + SlideBarShape.Left - SlideBarButton.Width;

          SlideBarButton.Left := NewPos;
    end else
    if Source = VolButton then
    begin
        if (Sender is TNempPanel) then
            NewPos := y - (VolButton.Height Div 2)
        else
            NewPos := (Sender as TControl).Top + y - (VolButton.Height Div 2);

        if NewPos <= VolShape.Top - (VolButton.Height Div 2) then
          NewPos := VolShape.Top - (VolButton.Height Div 2)
        else
          if NewPos >= VolShape.Top + VolShape.Height - (VolButton.Height Div 2) then
            NewPos := VolShape.Top + VolShape.Height - (VolButton.Height Div 2);
        VolButton.Top := NewPos;
        NempPlayer.Volume := VCLVolToPlayer;
    end;
end;

procedure TNemp_MainForm.SlideBarButtonEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  NempPlaylist.Progress := (SlideBarButton.Left-SlideBarShape.Left) / (SlideBarShape.Width-SlideBarButton.Width);
  SlideBarButton.Tag := 0;
  ClipCursor(NIL);
end;

procedure TNemp_MainForm.VolButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  with VolButton do Begindrag(false);
  ARect.TopLeft :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left, NewPlayerPanel.Top)));
  ARect.BottomRight :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left + NewPlayerPanel.Width, NewPlayerPanel.Top + NewPlayerPanel.Height)));
  ClipCursor(@Arect);
end;

procedure TNemp_MainForm.VolButtonEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
    ClipCursor(Nil);
end;

procedure TNemp_MainForm.PlayNextBTNIMGClick(Sender: TObject);
begin
  NempPlaylist.UserInput;
  if (GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0) then
      NempPlaylist.PlayNextFile(True)
  else
      NempPlaylist.PlayNext(True);
  Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
end;

procedure TNemp_MainForm.PlayPrevBTNIMGClick(Sender: TObject);
begin
  NempPlaylist.UserInput;
  if (GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0) then
      NempPlaylist.PlayPreviousFile(True)
  else
      NempPlaylist.PlayPrevious(True);
  Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
end;

procedure TNemp_MainForm.StopBTNIMGClick(Sender: TObject);
begin
  if ((GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0)) then
  begin
      if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
      begin
          NempPlayer.SetNoEndSyncs(NempPlayer.MainStream);
          NempPlayer.SetNoEndSyncs(NempPlayer.SlideStream);
          NempPlayer.LastUserWish := USER_WANT_STOP;
      end else
      begin
          NempPlayer.SetEndSyncs(NempPlayer.MainStream);
          NempPlayer.SetEndSyncs(NempPlayer.SlideStream);
          NempPlayer.LastUserWish := USER_WANT_PLAY;
      end;
  end else
  begin
      NempPlayer.LastUserWish := USER_WANT_STOP;
      NempPlaylist.stop;
      if NempPlayer.BassStatus <> BASS_ACTIVE_PLAYING then
      begin
        Spectrum.DrawClear;
        Spectrum.DrawText(NempPlayer.PlayingTitel,False);
        Spectrum.DrawTime('  00:00');
      end;

      Application.Title := NempPlayer.GenerateTaskbarTitel;
      PlaylistVST.Invalidate;
      Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
  end;
end;

procedure TNemp_MainForm.PopupStopPopup(Sender: TObject);
begin
    if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
        PM_StopAfterTitle.Caption := MainForm_StopMenu_StopAfterTitle
    else
        PM_StopAfterTitle.Caption := MainForm_StopMenu_NoStopAfterTitle;
end;

procedure TNemp_MainForm.PM_StopNowClick(Sender: TObject);
begin
    NempPlayer.LastUserWish := USER_WANT_STOP;
    NempPlaylist.stop;
    if NempPlayer.BassStatus <> BASS_ACTIVE_PLAYING then
    begin
      Spectrum.DrawClear;
      Spectrum.DrawText(NempPlayer.PlayingTitel,False);
      Spectrum.DrawTime('  00:00');
    end;

    Application.Title := NempPlayer.GenerateTaskbarTitel;
    PlaylistVST.Invalidate;
    Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
end;

procedure TNemp_MainForm.PM_StopAfterTitleClick(Sender: TObject);
begin
    if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
    begin
        NempPlayer.SetNoEndSyncs(NempPlayer.MainStream);
        NempPlayer.SetNoEndSyncs(NempPlayer.SlideStream);
        NempPlayer.LastUserWish := USER_WANT_STOP;
    end else
    begin
        NempPlayer.SetEndSyncs(NempPlayer.MainStream);
        NempPlayer.SetEndSyncs(NempPlayer.SlideStream);
        NempPlayer.LastUserWish := USER_WANT_PLAY;
    end;
end;

Procedure TNemp_MainForm.TNA_PlaylistClick(Sender: TObject);
var idx: Integer;
begin
  if (Sender is TMenuItem) then
  begin
    idx := (Sender as TMenuItem).Tag;
    if assigned(NempPlaylist.Playlist) AND (NempPlaylist.Count > idx) And (idx >= 0) then
    begin
        NempPlayer.LastUserWish := USER_WANT_PLAY;
        NempPlaylist.Play(idx, NempPlayer.FadingInterval, True);
    end;
  end;
end;

procedure TNemp_MainForm.PlayPauseBTNIMGClick(Sender: TObject);
begin
  NempPlaylist.UserInput;
  if (NempPlayer.MainStream = 0) AND (NempPlaylist.Count = 0) then
  begin
      MM_PL_FilesClick(NIL);
      exit;
  end;

  if NempPlayer.MainStream = 0 then
  begin
      //NempPlayer.AutoPlayNextFile := Not ((GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0));
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      NempPlaylist.Play(-1, NempPlayer.FadingInterval, True);
  end
  else
    case NempPlayer.BassStatus of
      BASS_ACTIVE_PAUSED  : begin // ok
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlayer.resume;
      end;
      BASS_ACTIVE_STOPPED : begin   // ok
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            // Der Stream-Status ist also STOPPED
            // Da kann durch echten Stop passiert sein,
            // oder durch ein ausfaden nach Klick auf den Pause-Button.
            if NempPlayer.Status = PLAYER_ISPAUSED then
                NempPlayer.resume
            else
            begin
                //NempPlayer.AutoPlayNextFile := Not ((GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0));
                NempPlaylist.PlayAgain(True);
            end;
      end;
      BASS_ACTIVE_PLAYING: begin     // ok
            if NempPlayer.Status = PLAYER_ISPLAYING then
            begin
                NempPlayer.LastUserWish := USER_WANT_STOP;
                NempPlaylist.pause;
            end
            else
              if NempPlayer.Status = PLAYER_ISPAUSED then
              begin
                  NempPlayer.LastUserWish := USER_WANT_PLAY;
                  NempPlayer.resume;
              end;
      end;

    end;
  Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
  PlaylistVST.Invalidate;
end;

procedure TNemp_MainForm.PM_PlayFilesClick(Sender: TObject);
var CurrentIdx, i: Integer;
begin
    CurrentIdx := NempPlaylist.Count; // CurrentIdx ist der erwartete Index des ersten neu eingef�gten Files
    if PlaylistDateienOpenDialog.Execute then
    begin
        for i := 0 to PlaylistDateienOpenDialog.Files.Count - 1 do
            NempPlaylist.AddFileToPlaylist(PlaylistDateienOpenDialog.Files[i]);

        if (NempPlaylist.Count > CurrentIdx) then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(CurrentIdx, 0, True);
        end;
    end;
end;

procedure TNemp_MainForm.PM_PlayWebstreamClick(Sender: TObject);
var
  NewString: string;
  ClickedOK: Boolean;
begin
  NewString := 'http://';

  ClickedOK := InputQuery(Shoutcast_InputStreamCaption, Shoutcast_InputStreamLabel, NewString);
  if ClickedOK then
  begin
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      WebRadioInsertMode := PLAYER_PLAY_NOW;
      NempPlayer.MainStation.URL := NewString;
      NempPlayer.MainStation.TuneIn(NempPlaylist.BassHandlePlaylist);
  end;
end;

procedure TNemp_MainForm.SlideBackBTNIMGClick(Sender: TObject);
begin
  NempPlaylist.Time := NempPlaylist.Time - 5;
end;

procedure TNemp_MainForm.SlideForwardBTNIMGClick(Sender: TObject);
begin
  NempPlaylist.Time := NempPlaylist.Time + 5;
end;



procedure TNemp_MainForm.RatingImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var rat: Integer;
begin
  // draw stars according to current mouse position
  rat := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);
  Spectrum.DrawRating(rat);
end;

procedure TNemp_MainForm.RatingImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var af: TAudioFile;
begin
    if Button = mbLeft  then
        if assigned(NempPlayer.MainAudioFile) then
        begin
            // set the rating
            NempPlayer.MainAudioFile.Rating := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);

            // Set this rating in all copies of the file in the Playlist
            NempPlaylist.UnifyRating(NempPlayer.MainAudioFile.Pfad, NempPlayer.MainAudioFile.Rating);

            // if possible: Update the library
            // hm, ok, but: This will create an irritating message in case the file
            // is not in the library at all...
            if MedienBib.StatusBibUpdate <= 1 then
            begin
                // get the file in the library
                af := MedienBib.GetAudioFileWithFilename(NempPlayer.MainAudioFile.Pfad);
                if assigned(af) then
                begin
                    if af.Pfad <> MedienBib.CurrentThreadFilename then
                    begin
                        // set the rating
                        af.Rating := NempPlayer.MainAudioFile.Rating;
                        // write it to file
                        af.QuickUpdateTag;
                        MedienBib.Changed := True;
                        // tell the postprocessor "already done. :D"
                        NempPlayer.PostProcessor.ManualRating := True;
                    end else
                        MessageDLG(Warning_MedienBibBusyThread, mtWarning, [mbOK], 0);
                end;
            end
            else
                MessageDLG(Warning_MedienBibIsBusyRating, mtWarning, [mbOK], 0);
        end else
            Spectrum.DrawRating(0);
end;

procedure TNemp_MainForm.RatingImageMouseLeave(Sender: TObject);
begin
    if assigned(NempPlayer.MainAudioFile) then
        Spectrum.DrawRating(NempPlayer.MainAudioFile.Rating)
    else
        Spectrum.DrawRating(0);
    NewPlayerPanel.Repaint;
end;



procedure TNemp_MainForm.PM_PL_DeleteAllClick(Sender: TObject);
begin
  NempPlaylist.ClearPlaylist;
end;

procedure TNemp_MainForm.PM_PL_DeleteSelectedClick(Sender: TObject);
begin
  NempPlaylist.DeleteMarkedFiles;

PlaylistVSTChange(PlaylistVST, Nil);
end;
                 
// Datei im Headset (2. Device abspielen)
procedure TNemp_MainForm.PlayInHeadset(aTree: TVirtualStringTree);
var aNode: PVirtualNode;
  Data: PTreeData;
  aAudiofile: TAudiofile;

begin
  if not assigned(HeadsetControlForm) then
    Application.CreateForm(THeadsetControlForm, HeadsetControlForm);

  aNode := aTree.FocusedNode;
  if assigned(aNode) then
  begin
      Data := aTree.GetNodeData(aNode);
      aAudiofile := Data^.FAudioFile;
      NempPlayer.PlayInHeadset(aAudioFile);
  end else
      aAudioFile := Nil;

  HeadsetControlForm.Show;
  HeadsetControlForm.Timer1.Enabled := True;

  if assigned(aAudioFile) then
      HeadsetControlForm.Lbl_HeadSetTitle.Caption := NempPlayer.GenerateTitelString(aAudioFile, 0)
  else
      HeadsetControlForm.Lbl_HeadSetTitle.Caption := HeadSetForm_NoAudioFile;
end;


procedure TNemp_MainForm.PM_PL_PlayInHeadsetClick(Sender: TObject);
begin
  PlayInHeadset(PlaylistVST);
end;

procedure TNemp_MainForm.PM_PL_StopHeadsetClick(Sender: TObject);
begin
  NempPlayer.StopHeadset;
  if assigned(HeadsetControlForm) then
    HeadSetControlForm.Close;
end;

procedure TNemp_MainForm.PM_ML_PlayHeadsetClick(Sender: TObject);
begin
  PlayInHeadset(VST);
end;

procedure TNemp_MainForm.BassTimeLBLClick(Sender: TObject);
begin
  NempPlayer.TimeMode := (NempPlayer.TimeMode + 1) Mod 2;
end;

procedure TNemp_MainForm.PlaylistSortClick(Sender: TObject);
begin
    Case (Sender as TMenuItem).Tag of
      1: NempPlaylist.Sort(Sortieren_Pfad_asc);
      2: NempPlaylist.Sort(Sortieren_ArtistTitel_asc);
      3: NempPlaylist.Sort(Sortieren_TitelArtist_asc);
      4: NempPlaylist.Sort(Sortieren_AlbumTrack_asc);
    end;
    NempPlayer.SetCueSyncs;
end;


procedure TNemp_MainForm.PM_PL_SortByInverseClick(Sender: TObject);
begin
  NempPlaylist.ReverseSortOrder;
  NempPlayer.SetCueSyncs;
end;

procedure TNemp_MainForm.PM_PL_SortByMixClick(Sender: TObject);
begin
  NempPlaylist.Mix;
  NempPlayer.SetCueSyncs;
end;

procedure TNemp_MainForm.PlayListSaveDialogTypeChange(Sender: TObject);
begin
  case PlayListSaveDialog.FilterIndex of
    1: PlayListSaveDialog.DefaultExt := 'm3u';
    2: PlayListSaveDialog.DefaultExt := 'm3u8';
    3: PlayListSaveDialog.DefaultExt := 'pls';
    4: PlayListSaveDialog.DefaultExt := 'npl';
  end;
end;


procedure TNemp_MainForm.PM_PL_SavePlaylistClick(Sender: TObject);
begin
  if PlayListSaveDialog.Execute then
  begin
    NempPlaylist.SaveToFile(PlayListSaveDialog.FileName, False);

    if AddFileToRecentList(PlayListSaveDialog.FileName) then
        SetRecentPlaylistsMenuItems;
  end;
end;


procedure TNemp_MainForm.PM_PL_LoadPlaylistClick(Sender: TObject);
var restart: boolean;
begin
  if PlayListOpenDialog.Execute then
  begin
    restart := NempPlayer.Status = Player_ISPLAYING;
    NempPlaylist.ClearPlaylist;
    NempPlaylist.LoadFromFile(PlayListOpenDialog.FileName);
    if AddFileToRecentList(PlayListOpenDialog.FileName) then
        SetRecentPlaylistsMenuItems;
    If restart then
    begin
        NempPlayer.LastUserWish := USER_WANT_PLAY;
        NempPlaylist.Play(0,0, True);
    end;
  end;
end;


procedure TNemp_MainForm.LoadCueSheet(filename: UnicodeString);
var tmplist: TStringList;
    i: Integer;
    AudioFilename: UnicodeString;
begin
  if Not FileExists(filename) then exit;

  tmplist := TStringList.Create;
  tmplist.LoadFromFile(filename);

  for i:=0 to tmplist.Count - 1 do
  begin
      // nach einem "FILE"-Eintrag suchen
      if (GetCueID(tmplist[i]) = CUE_ID_FILE) then
      begin
        // FILE-Eintrag gefunden.
        AudioFilename := ExtractFilePath(filename) + GetFileNameFromCueString(tmplist[i]);
        // Wenn diese Datei existiert, dann Audiofile createn und in die Playlist einf�gen
        // S�mtliches Einf�gen wird in der Insert-Prozedur erledigt!
        if FileExists(AudioFilename) then
          NempPlaylist.InsertFileToPlayList(AudioFilename, filename);
      end;
  end;

  FreeAndNil(tmplist);
end;



procedure TNemp_MainForm.PM_PL_PropertiesClick(Sender: TObject);
var AudioFile:TAudioFile;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    Node:=PlaylistVST.FocusedNode;
    if not Assigned(Node) then
      Node := PlaylistVST.GetFirstSelected;
    if not Assigned(Node) then
      exit;
    if PlaylistVST.GetNodeLevel(Node) = 1 then
      Node := Node.Parent;

    Data := PlaylistVST.GetNodeData(Node);
    AudioFile := Data^.FAudioFile;
    AutoShowDetailsTMP := True;
    AktualisiereDetailForm(AudioFile, SD_Playlist);

    if assigned(FDetails) then // sollte aber hier immer so sein ;-)
      SetWindowPos(FDetails.Handle,HWND_TOP,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

    if not (FileExists(AudioFile.Pfad) OR AudioFile.isStream) then
    begin
      AudioFile.FileIsPresent := False;
      PlaylistVST.InvalidateNode(Node);
    end;
end;

procedure TNemp_MainForm.PlaylistVSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var aNode: PVirtualNode;
  Data: PTreeData;
  AudioFile: TAudioFile;
  c,i:integer;
  dauer:int64;
  groesse:int64;
  SelectedMP3s: TNodeArray;
begin

  c := PlaylistVST.SelectedCount;
  SelectedMP3s := PlaylistVST.GetSortedSelection(False);
  if c=0 then
  begin
    PlayListStatusLBL.Caption := '';
    exit;
  end;
  dauer:=0;
  groesse:=0;

  for i:=0 to length(SelectedMP3s) - 1 do
  begin
    aNode := SelectedMP3s[i];
    Data := PlaylistVST.GetNodeData(aNode);
    AudioFile := Data^.FAudioFile;
    if Not AudioFile.isStream then
    begin
      dauer := dauer + AudioFile.Duration;
      groesse := groesse + AudioFile.Size;
    end;
  end;
  PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCount), [c])
                                + SizeToString(groesse)
                                + SekToZeitString(dauer);

  aNode := PlaylistVST.FocusedNode;
  if not Assigned(aNode) then Exit;

  if PlaylistVST.GetNodeLevel(aNode)>0 then exit;

  NempPlaylist.ActualizeNode(aNode);

  Data := PlaylistVST.GetNodeData(aNode);
  AudioFile := Data^.FAudioFile;
  AktualisiereDetailForm(AudioFile, SD_PLAYLIST);
end;

procedure TNemp_MainForm.ShowPlayerDetails(aAudioFile: TAudioFile);
var
  Coverbmp: TBitmap;
  ///ordner: UnicodeString;
begin
  if aAudioFile = NIL then exit;

  LblPlayerTitle.Caption := aAudioFile.Titel;//   PlaylistTitle;
  LblPlayerArtist.Caption := aAudioFile.Artist;
  LblPlayerAlbum.Caption := aAudioFile.Album;

  ///Ordner := ExtractFileDir(aAudioFile.Pfad);

  Coverbmp := tBitmap.Create;
  Coverbmp.Width := CoverImage.Width;
  Coverbmp.Height := CoverImage.Width; //ja, quadratisch!

  if aAudioFile.CoverID = '' then
      MedienBib.InitCover(aAudioFile);

  // Bild holen - (das ist ne recht umfangreiche Prozedur!!)
  if GetCover(aAudioFile, Coverbmp) then
  begin
    CoverImage.Visible := True;
    CoverImage.Picture.Bitmap.Assign(Coverbmp);
//    UpdateCoverBtn(CoverBmp);

    CoverImage.Refresh;
  end else
    CoverImage.Visible := False;
  Coverbmp.Free;

  if aAudioFile.Lyrics <> '' then
    LyricsMemo.Text := UTF8ToString(aAudioFile.Lyrics)
  else
    LyricsMemo.Text := (MainForm_Lyrics_NoLyrics);

  NempTrayIcon.Hint := StringReplace(aAudioFile.Artist + ' - ' + aAudioFile.Titel, '&', '&&&', [rfReplaceAll]);
end;

procedure TNemp_MainForm.CoverImageDblClick(Sender: TObject);
begin
  if NempPlaylist.PlayingFile = Nil then Exit;
  AutoShowDetailsTMP := True;
  AktualisiereDetailForm(NempPlaylist.PlayingFile, SD_PLAYLIST);
end;

procedure TNemp_MainForm.PlaylistVSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Node: PVirtualNode;
    Data: PTreeData;
begin
  case Key of
    vK_RETURN: begin
       //NempPlayer.AutoPlayNextFile := Not ((GetAsyncKeyState(vk_shift) < 0) and (GetAsyncKeyState(vk_Control) >= 0));
       NempPlaylist.UserInput;
       NempPlayer.LastUserWish := USER_WANT_PLAY;
       NempPlaylist.PlayFocussed;
       Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
    end;

    VK_F9: begin
     if (NempPlayer.JingleStream = 0) then
      begin
        Node := PlaylistVST.FocusedNode;
        if not Assigned(Node) then
          Exit;
        Data := PlaylistVST.GetNodeData(Node);
        if PathSeemsToBeURL(Data^.FAudioFile.Pfad) then exit;
        NempPlayer.PlayJingle(Data^.FAudioFile);
      end;
    end;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
    VK_F9: NempPlayer.StopJingle;
  end;
end;

procedure TNemp_MainForm.PM_ML_ExtendedShowAllFilesInDirClick(Sender: TObject);
var
  aNode: pVirtualNode;
  Data: PTreeData;
  aPfad: UnicodeString;
begin
  if Medienbib.StatusBibUpdate >= 2 then exit;
  
  aNode := VST.FocusedNode;
  if not assigned(aNode) then exit;

  Data := VST.GetNodeData(aNode);
  aPfad := (Data^.FaudioFile).Ordner;
  if Sender=PM_ML_ExtendedShowAllFilesInDir then
  begin
    MedienBib.AnzeigeListe.Clear;
    MedienBib.AnzeigeListe2.Clear;
  end;

  MedienBib.GetFilesInDir(aPfad);

  //Filltreeview(VST, MedienBib.AnzeigeListe);
  FillTreeView(MedienBib.AnzeigeListe, Nil);
  ShowSummary;
end;

procedure TNemp_MainForm.NachDiesemDingSuchen1Click(Sender: TObject);
//var  aNode: pVirtualNode;
//      Data: PTreeData;
//      tmpstr: UnicodeString;
begin

ShowMessage('Not implemented right now');

{

  aNode := VST.FocusedNode;
  if not assigned(aNode) then exit;

  Data := VST.GetNodeData(aNode);
  case (Sender as TMenuItem).Tag of
    1: tmpstr := (Data^.FaudioFile).Titel;
    2: tmpstr := (Data^.FaudioFile).Artist;
    3: tmpstr := (Data^.FaudioFile).Album;
  end;

  // Seite Wechseln
  TabBtn_Search.Click;
  // Genaue Suche
  CB_SearchMode.ItemIndex := 1;

  TitelEDIT.Text := '';
  ArtistEdit.Text := '';
  AlbumEdit.Text := '';
  KommentarEdit.Text := '';
  case (Sender as TMenuItem).Tag of
    1: TitelEDIT.Text  := tmpstr;
    2: ArtistEdit.Text := tmpstr;
    3: AlbumEdit.Text  := tmpstr;
  end;
  CB_SearchOptionsExtended.ItemIndex := 0;
  GenaueSucheBTNClick(Nil);

  }
end;



procedure TNemp_MainForm.MM_H_ShowReadmeClick(Sender: TObject);
begin
  if NOT FileExists(ExtractFilePath(Paramstr(0)) + 'readme.txt') then
    MessageDLG((Error_ReadmeFileNotFound), mtError, [mbOK], 0)
  else
    ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'readme.txt')
                      , nil, nil, SW_SHOWNORMAl);
end;

procedure TNemp_MainForm.PM_PL_ExtendedCopyFromWinampClick(Sender: TObject);
begin
  NempPlaylist.GetFromWinamp;
end;

procedure TNemp_MainForm.MM_PL_DirectoryClick(Sender: TObject);
var newdir: UnicodeString;
    FB: TFolderBrowser;
begin
  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_Caption );
  try
      if fb.Execute then
      begin
          newdir := fb.SelectedItem;

          NempPlaylist.InsertNode := Nil;
          ST_Playlist.Mask := GeneratePlaylistSTFilter;

          if NameOfMyComputer <> newdir then
          begin
            NempPlaylist.ST_Ordnerlist.Add(newdir);
            if (Not ST_Playlist.IsSearching) then
            begin
              NempPlaylist.Status := 1;
              ST_Playlist.SearchFiles(NempPlaylist.ST_Ordnerlist[0]);
            end;
          end
          else
            MessageDlg((Playlist_NotEverything), mtInformation, [MBOK], 0);
      end;
  finally
      fb.Free;
  end;
end;

procedure TNemp_MainForm.MM_PL_FilesClick(Sender: TObject);
var i: integer;
  Abspielen: Boolean;
begin
  // Playlistl�nge merken
  Abspielen := NempPlaylist.Count = 0;

  // einf�gen
  if PlaylistDateienOpenDialog.Execute then
    for i := 0 to PlaylistDateienOpenDialog.Files.Count - 1 do
      NempPlaylist.AddFileToPlaylist(PlaylistDateienOpenDialog.Files[i]);

  // ggf. abspielen
  if abspielen AND (NempPlaylist.Count > 0) then
  begin
    //StopAndFree;
    NempPlayer.LastUserWish := USER_WANT_PLAY;
    NempPlaylist.Play(0, 0, True);
  end;
end;

procedure TNemp_MainForm.MM_PL_AddPlaylistClick(Sender: TObject);
begin
  if PlayListOpenDialog.Execute then
  begin
    NempPlaylist.LoadFromFile(PlayListOpenDialog.FileName);

    if AddFileToRecentList(PlayListOpenDialog.FileName) then
        SetRecentPlaylistsMenuItems;
  end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedAddToMedialibraryClick(Sender: TObject);
var i: integer;
  AudioFile: TAudioFile;
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  MedienBib.Anzeigeliste.Clear;
  MedienBib.AnzeigeListe2.Clear;
  Medienbib.AnzeigeShowsPlaylistFiles := False;
  VST.Clear;
  MedienBib.ReInitCoverSearch;

  MedienListeStatusLBL.Caption := (Medialibrary_AddingPlaylist);
  MedienBib.StatusBibUpdate := 1;
  for i := 0 to NempPlaylist.Count - 1 do
  begin

    if NOT (NempPlaylist.Playlist[i] as TAudioFile).isStream then
    begin
        AudioFile := MedienBib.GetAudioFileWithFilename((NempPlaylist.Playlist[i] as TAudioFile).Pfad);
        if AudioFile = Nil then
        begin
          AudioFile := TAudioFile.Create;
          AudioFile.GetAudioData((NempPlaylist.Playlist[i] as TAudioFile).Pfad, GAD_Cover or GAD_Rating);
          MedienBib.InitCover(AudioFile);
          MedienBib.UpdateList.Add(AudioFile);
        end;
        MedienBib.Anzeigeliste.Add(AudioFile);
        VST.AddChild(Nil, AudioFile);
    end;
  end;
  MedienBib.NewFilesUpdateBib;

  LangeAktionWeitermachen := False;
end;

procedure TNemp_MainForm.PlayListPOPUPPopup(Sender: TObject);
begin
  if (PlayListVST.FocusedNode= NIL) then
  begin
    PM_PL_DeleteSelected.Enabled   := False;
    PM_PL_Properties.Enabled := False;
    PM_PL_PlayInHeadset.Enabled := False;
    PM_PL_StopHeadset.Enabled   := NempPlayer.EnableHeadSet;
    PM_PL_ExtendedCopyToClipboard.Enabled := False;
  end else begin
    PM_PL_DeleteSelected.Enabled   := True;
    PM_PL_Properties.Enabled := True;
    PM_PL_PlayInHeadset.Enabled := NempPlayer.EnableHeadSet;
    PM_PL_StopHeadset.Enabled   := NempPlayer.EnableHeadSet;
    PM_PL_ExtendedCopyToClipboard.Enabled := True;
  end;
  If NempPlaylist.Count = 0 then
  begin
    PM_PL_SortBy.Enabled := False;
    PM_PL_SavePlaylist.Enabled := False;
    PM_PL_DeleteAll.Enabled    := False;
  end else
  begin
    PM_PL_SortBy.Enabled := True;
    PM_PL_SavePlaylist.Enabled := True;
    PM_PL_DeleteAll.Enabled    := True;
    //InMedienlisteaufnehmen1.Enabled := NOT StopMENU.Visible;
  end;
  ClipCursor(Nil);
  PM_PL_ExtendedPasteFromClipboard.Enabled := Clipboard.HasFormat(CF_HDROP);
end;


procedure TNemp_MainForm.StopMENUClick(Sender: TObject);
begin
  if ContinueWithPlaylistAdding then
     ContinueWithPlaylistAdding := False
  else
  begin
      MedienBib.Abort;
      NempPlaylist.ST_Ordnerlist.Clear;
      Medienbib.ST_Ordnerlist.Clear;
      ST_Playlist.Break;
      ST_Medienliste.Break;

      // kann sein, dass der Player ab und zu mal blockiert - hier dann umsetzen ;-)
      NempPlaylist.AcceptInput := True;
      LangeAktionWeitermachen := False;
      ContinueWithPlaylistAdding := False;
  end;

end;

procedure TNemp_MainForm.PM_ML_CopyToClipboardClick(Sender: TObject);
var FileString: UnicodeString;
  idx: integer;
  SelectedMP3s: TNodeArray;
  Data: PTreeData;
  aVST: TVirtualStringTree;
begin
  if Sender = PM_ML_CopyToClipboard then
    aVST := VST
  //if Sender = PlayListKopierenPMENU then
  else
    aVST :=PlayListVST;

  SelectedMP3s := aVST.GetSortedSelection(False);
  if length(SelectedMp3s) > MAX_DRAGFILECOUNT then
  begin
    MessageDlg((Warning_TooManyFiles), mtInformation, [MBOK], 0);
    exit;
  end;
  FileString := '';
  for idx := 0 to length(SelectedMP3s)-1 do
  begin
    Data := aVST.GetNodeData(SelectedMP3s[idx]);
    if FileExists(Data^.FAudioFile.Pfad) then
      FileString := FileString + Data^.FAudioFile.Pfad + #0;
  end;

  if FileString<>'' then
    CopyFilesToClipboard(FileString);

  //CopyFilesToClipboardW
end;


procedure TNemp_MainForm.PM_ML_PasteFromClipboardClick(Sender: TObject);
var
  f: THandle;
  buffer: array [0..MAX_PATH] of WideChar;
  i, numFiles: Integer;
  AudioFile: TAudiofile;
  JobList: TStringList;

begin
  if not Clipboard.HasFormat(CF_HDROP) then
    Exit;

  LangeAktionWeitermachen := True;
  MedienBib.ReInitCoverSearch;

  if Sender = PM_PL_ExtendedPasteFromClipboard then
  begin
        JobList := NempPlaylist.ST_Ordnerlist;
        ST_PLaylist.Mask := GeneratePlaylistSTFilter;
    // XXXXXXX ???
        NempPlaylist.InsertNode := Nil; // evtl. sp�ter nochmal �berpr�fen!! Evtl. focussed Node? XXXXX
  end else
  begin
        if MedienBib.StatusBibUpdate = 0 then
        begin
          MedienBib.StatusBibUpdate := 1;
          ST_Medienliste.Mask := GenerateMedienBibSTFilter;
          JobList := MedienBib.ST_Ordnerlist;
        end else
        begin
          MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
          LangeAktionWeitermachen := False;
          exit;
        end;
  end;

  Clipboard.Open;
  try
    f := Clipboard.GetAsHandle(CF_HDROP);
    if f <> 0 then
    begin
      numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0);

      for i := 0 to numfiles - 1 do
      begin
        buffer[0] := #0;
        DragQueryFile(f, i, buffer, SizeOf(buffer));
        clipCursor(Nil);
        if LangeAktionWeitermachen then
          begin
              if (FileGetAttr((buffer)) AND faDirectory = faDirectory)
              then
              begin // ein Ordner in der gedroppten Liste gefunden
                  JobList.Add(buffer);
              end
              else // eine Datei in der gedroppten Liste gefunden
                if ValidAudioFile(buffer, (Sender = PM_PL_ExtendedPasteFromClipboard)) then
                begin // Musik-Datei
                    if Sender = PM_PL_ExtendedPasteFromClipboard then
                    begin
                        NempPlaylist.InsertFileToPlayList(buffer)
                    end
                    else begin
                      if Not MedienBib.AudioFileExists(buffer) then
                      begin
                        AudioFile:=TAudioFile.Create;
                        AudioFile.GetAudioData(buffer, GAD_Cover or GAD_Rating);
                        MedienBib.InitCover(AudioFile);
                        MedienBib.UpdateList.Add(AudioFile);
                      end;
                    end;
                end;
          end; //if LangeAktionWeitermachen
      end;

    end;
  finally
    Clipboard.Close;
  end;

  if Sender = PM_PL_ExtendedPasteFromClipboard then
  begin
    if (JobList.Count > 0) And (Not ST_Playlist.IsSearching) then
    begin
      NempPlaylist.Status := 1;
      ST_Playlist.SearchFiles(JobList[0]);
    end;
  end else
  begin
    if JobList.Count > 0 then
    begin
      PutDirListInAutoScanList(JobList);
      BlockeMedienListeUpdate(True);
      ST_Medienliste.SearchFiles(JobList[0]);
    end
    else
      // Die Dateien einpflegen, die evtl. einzeln in die Updatelist geaten sind
      MedienBib.NewFilesUpdateBib;
  end;

  LangeAktionWeitermachen := False;
end;

procedure TNemp_MainForm.SetGroupboxEQualizerDragover;
begin
    Btn_EqualizerPresets  .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL1                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL2                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL3                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL4                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL5                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL6                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL7                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL8                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL9                .OnDragOver := GRPBOXEqualizerDragOver;
    EQLBL10               .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton1      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton2      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton3      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton4      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton5      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton6      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton7      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton8      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton9      .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerButton10     .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerDefaultShape .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape1       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape2       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape3       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape4       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape5       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape6       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape7       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape8       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape9       .OnDragOver := GRPBOXEqualizerDragOver;
    EqualizerShape10      .OnDragOver := GRPBOXEqualizerDragOver;
end;

procedure TNemp_MainForm.GRPBOXEqualizerDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos, BtnHeight: Integer;
begin
    BtnHeight := DraggingSlideButton.Height;
    if (Sender is TNempPanel) then
        NewPos := y - (BtnHeight Div 2)
    else
        NewPos := (Sender as TControl).Top + y - (BtnHeight Div 2);

  if NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
    NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53};

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
    else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
        NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight
      else
        if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verl�sst
          NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
            NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53}
        else
          ; //NewPos := NewPos;

  DraggingSlideButton.Top := NewPos;

  NempPlayer.SetEqualizer(DraggingSlideButton.Tag, VCLEQToPlayer(DraggingSlideButton.Tag));

  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;

procedure TNemp_MainForm.EqualizerButton1EndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  ClipCursor(Nil);
end;

// Prozdur f�r Alle Images unterhalb der Zeitanzeige
procedure TNemp_MainForm.EqualizerButton1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEQualizerDragover;
  (Sender as TSkinButton).OnDragOver := EqualizerButton1DragOver;
  DraggingSlideButton := (Sender as TSkinButton);

  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  (AudioPanel.ClientToScreen(Point(GRPBOXEqualizer.Left, GRPBOXEqualizer.Top)));
    ARect.BottomRight :=  (AudioPanel.ClientToScreen(Point(GRPBOXEqualizer.Left + GRPBOXEqualizer.Width, GRPBOXEqualizer.Top + GRPBOXEqualizer.Height)));
    ClipCursor(@Arect);
  end;
end;
procedure TNemp_MainForm.EqualizerButton1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
Var newpos: integer;
  localTag: Integer;
  BtnHeight: Integer;
begin
  localtag := (Sender as TControl).Tag;
  BtnHeight := EqualizerButtons[localTag].Height;
  NewPos := (Sender as TControl).Top + y - (BtnHeight Div 2);


  if NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
    NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53};

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
    else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
        NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight
      else
        if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verl�sst
          NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
            NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53}
        else
          ; //NewPos := NewPos;

  EqualizerButtons[localTag].Top := NewPos;
  NempPlayer.SetEqualizer(localTag, VCLEQToPlayer(localTag));

  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;
procedure TNemp_MainForm.EqualizerButton1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var LocalTag: integer;
begin
  if Button = mbRight then
  begin
      LocalTag := (Sender as TControl).Tag;
      NempPlayer.SetEqualizer((Sender as TControl).Tag, 0);
      CorrectEQButton(LocalTag);

      NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
      Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
  end;
end;

procedure TNemp_MainForm.EqualizerButton9KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var Newpos: Integer;
    localTag, BtnHeight: Integer;
begin
  localtag := (Sender as TControl).Tag;
  BtnHeight := EqualizerButtons[localTag].Height;

  case key of
    vk_up: NewPos := (Sender as TControl).Top - 1;
    vk_Down: NewPos := (Sender as TControl).Top + 1;
    vk_Space: NewPos := (EqualizerShape1.Top + ((EqualizerShape1.Height - BtnHeight) Div 2) )   ;//62; // Default-Stellung

    vk_Right : begin
                  (EqualizerButtons[(localTag + 1) mod 10]).SetFocus;
                  exit;
               end;
    vk_Left : begin
                  (EqualizerButtons[(localTag + 9 ) mod 10]).SetFocus;
                  exit;
               end;

    else NewPos := EqualizerButtons[localTag].Top;
  end;

  if NewPos <= EqualizerShape1.Top then
      NewPos := EqualizerShape1.Top
  else
      if NewPos >= EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight then
          NewPos := EqualizerShape1.Top + EqualizerShape1.Height - BtnHeight;

  EqualizerButtons[localTag].Top := NewPos;
  NempPlayer.SetEqualizer(localTag, VCLEQToPlayer(localTag));
  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;

procedure TNemp_MainForm.SetGroupboxEffectsDragover;
begin
     Btn_EffectsOff        .OnDragOver := GRPBOXEffekteDragOver;
     DirectionPositionBTN  .OnDragOver := GRPBOXEffekteDragOver;
     EchoMixLBL            .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeButton        .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeLBL           .OnDragOver := GRPBOXEffekteDragOver;
     EchoTimeShape         .OnDragOver := GRPBOXEffekteDragOver;
     EchoWetDryMixButton   .OnDragOver := GRPBOXEffekteDragOver;
     EchoWetDryMixShape    .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL1           .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL2           .OnDragOver := GRPBOXEffekteDragOver;
     EffekteLBL3           .OnDragOver := GRPBOXEffekteDragOver;
     //EffekteLBL4           .OnDragOver := GRPBOXEffekteDragOver;
     HallButton            .OnDragOver := GRPBOXEffekteDragOver;
     HallLBL               .OnDragOver := GRPBOXEffekteDragOver;
     HallShape             .OnDragOver := GRPBOXEffekteDragOver;
     //PosRewindCB           .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateButton      .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateLBL         .OnDragOver := GRPBOXEffekteDragOver;
     SampleRateShape       .OnDragOver := GRPBOXEffekteDragOver;
end;

// Diese Methode f�r alle Elemente in der Groupbox setzen - mit Ausnahme des Objektes,
// das gerade gedraggt wird
procedure TNemp_MainForm.GRPBOXEffekteDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos: Integer;
begin
    if (Sender is TNempPanel) then
        NewPos := x - (DraggingSlideButton.Width Div 2)
    else
        NewPos := (Sender as TControl).Left + x - (DraggingSlideButton.Width Div 2);
    // Die Shapes sind hier alle gleich - also z.B. das HallShape nehmen
    if NewPos <= HallShape.Left then
        NewPos := HallShape.Left
    else
        if NewPos >= HallShape.Left + HallShape.Width - DraggingSlideButton.Width then
            NewPos := HallShape.Left + HallShape.Width - DraggingSlideButton.Width;

    DraggingSlideButton.Left := NewPos;

    if DraggingSlideButton = Hallbutton then
    begin
      NempPlayer.ReverbMix := VCLHallToPlayer;
      CorrectHallButton;
    end else
      if DraggingSlideButton = EchoWetDryMixButton then
      begin
        NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;
        CorrectEchoButtons;
      end else
        if DraggingSlideButton = EchoTimeButton then
        begin
          NempPlayer.EchoTime := VCLEchoTimeToPlayer;
          CorrectEchoButtons;
        end else
          if DraggingSlideButton = SampleRateButton then
          begin
            NempPlayer.Speed := VCLSpeedToPlayer;
            CorrectSpeedButton;
          end;
end;

procedure TNemp_MainForm.EffectsButtonEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
    ClipCursor(nil);
end;

procedure TNemp_MainForm.SampleRateButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);
  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left, GRPBOXEffekte.Top)));
    ARect.BottomRight :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left + GRPBOXEffekte.Width, GRPBOXEffekte.Top + GRPBOXEffekte.Height)));
    ClipCursor(@Arect);
  end;
end;

procedure TNemp_MainForm.SampleRateButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
Var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Up: begin
              EchoTimeButton.SetFocus;
              exit;
            end;
    vk_Down: begin
              DirectionPositionBTN.SetFocus;
              exit;
            end;
    vk_Space: NewPos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= SampleRateShape.Left then
      NewPos := SampleRateShape.Left
    else
      if NewPos >= SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width then
        NewPos := SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width;
  SampleRateButton.Left := NewPos;
  NempPlayer.Speed := VCLSpeedToPlayer ; //(Sender as TButton).Left, SETFX_MODE_VCL);
  CorrectSpeedButton;
end;
procedure TNemp_MainForm.SampleRateButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var newpos: integer;
begin
  if Button = mbRight then
  begin
    NewPos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
    SampleRateButton.Left := NewPos;
    NempPlayer.Speed := 1;
    CorrectSpeedButton;
  end;
end;
procedure TNemp_MainForm.SampleRateShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  if Button = mbRight then
    Newpos := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left
  else
    NewPos := SampleRateShape.Left + x - (SampleRateButton.Width Div 2);
  if NewPos <= SampleRateShape.Left then
      SampleRateButton.Left := SampleRateShape.Left
    else
      if NewPos >= SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width then
        SampleRateButton.Left := SampleRateShape.Left + SampleRateShape.Width - SampleRateButton.Width
      else
        SampleRateButton.Left := NewPos;
  NempPlayer.Speed := VCLSpeedToPlayer; // (SampleRateButton.Left, SETFX_MODE_VCL);
  CorrectSpeedButton;
end;


procedure TNemp_MainForm.HallButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);
  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left, GRPBOXEffekte.Top)));
    ARect.BottomRight :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left + GRPBOXEffekte.Width, GRPBOXEffekte.Top + GRPBOXEffekte.Height)));
    ClipCursor(@Arect);
  end;
end;

procedure TNemp_MainForm.HallButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Newpos: Integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Down: begin
                EchoWetDryMixButton.SetFocus;
                exit;
             end;
    vk_Up: begin
                Btn_EffectsOff.SetFocus;
                exit;
            end;
    vk_Space: NewPos := HallShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= HallShape.Left then
      NewPos := HallShape.Left
    else
      if NewPos >= HallShape.Left + HallShape.Width - HallButton.Width then
        NewPos := HallShape.Left + HallShape.Width - HallButton.Width;

  HallButton.Left := NewPos;
  NempPlayer.ReverbMix := VCLHallToPlayer;
  CorrectHallButton;
end;
procedure TNemp_MainForm.HallButtonMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    NempPlayer.ReverbMix := -96;
    CorrectHallButton;
  end;
end;
procedure TNemp_MainForm.HallShapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := HallShape.Left
  else
    NewPos := HallShape.Left + x - (HallButton.Width Div 2);
  if NewPos <= HallShape.Left then
      NewPos := HallShape.Left
    else
      if NewPos >= HallShape.Left + HallShape.Width - HallButton.Width then
        NewPos := HallShape.Left + HallShape.Width - HallButton.Width
      else
        NewPos := NewPos;
  HallButton.Left := NewPos;

  NempPlayer.ReverbMix := VCLHallToPlayer;
  CorrectHallButton;
end;

procedure TNemp_MainForm.EchoWetDryMixButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
// F�r beide Echo Buttons
begin
  SetGroupboxEffectsDragover;
  DraggingSlideButton := (Sender as TSkinButton);

  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left, GRPBOXEffekte.Top)));
    ARect.BottomRight :=  (AudioPanel.ClientToScreen(Point(GRPBOXEffekte.Left + GRPBOXEffekte.Width, GRPBOXEffekte.Top + GRPBOXEffekte.Height)));
    ClipCursor(@Arect);
  end;
end;

procedure TNemp_MainForm.EchoWetDryMixButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
Var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Up: begin
                HallButton.SetFocus;
                exit;
           end;
    vk_Down: begin
                EchoTimeButton.SetFocus;
                exit;
             end;
    vk_Space: NewPos := EchoWetDryMixShape.Left; // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= EchoWetDryMixShape.Left then
      NewPos := EchoWetDryMixShape.Left
    else
      if NewPos >= EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width then
        NewPos := EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width;
  EchoWetDryMixButton.Left := NewPos;
  NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;
  CorrectEchoButtons;
end;
procedure TNemp_MainForm.EchoWetDryMixButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    NempPlayer.EchoWetDryMix := 0;
    CorrectEchoButtons;
  end;
end;
procedure TNemp_MainForm.EchoWetDryMixShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := EchoWetDryMixShape.Left
  else
    NewPos := EchoWetDryMixShape.Left + x - (EchoWetDryMixButton.Width Div 2);
  if NewPos <= EchoWetDryMixShape.Left then
      EchoWetDryMixButton.Left := EchoWetDryMixShape.Left
    else
      if NewPos >= EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width then
        EchoWetDryMixButton.Left := EchoWetDryMixShape.Left + EchoWetDryMixShape.Width - EchoWetDryMixButton.Width
      else
        EchoWetDryMixButton.Left := NewPos;

  NempPlayer.EchoWetDryMix := VCLEchoMixToPlayer;//  (EchoWetDryMixButton.Left, -1, SETFX_MODE_VCL);
  CorrectEchoButtons;
end;

procedure TNemp_MainForm.EchoTimeButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
Var newpos: integer;
begin
  case key of
    vk_Left: NewPos := (Sender as TControl).Left - 1;
    vk_Right: NewPos := (Sender as TControl).Left + 1;
    vk_Down: begin
                SampleRateButton.SetFocus;
                exit;
             end;
    vk_Up: begin
                EchoWetDryMixButton.SetFocus;
                exit;
           end;     
    vk_Space: NewPos := EchoTimeShape.Left;  // Default-Stellung
    else NewPos := (Sender as TControl).Left;
  end;
  if NewPos <= EchoTimeShape.Left then
      NewPos := EchoTimeShape.Left
    else
      if NewPos >= EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width then
        NewPos := EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width;

  EchoTimeButton.Left := NewPos;
  NempPlayer.EchoTime := VCLEchoTimeToPlayer;
  CorrectEchoButtons;
end;
procedure TNemp_MainForm.EchoTimeButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    NempPlayer.EchoTime := 100;
    CorrectEchoButtons;
  end;
end;

procedure TNemp_MainForm.EchoTimeShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var NewPos: Integer;
begin
  if Button = mbRight then
    NewPos := EchoWetDryMixShape.Left
  else
    NewPos := EchoTimeShape.Left + x - (EchoTimeButton.Width Div 2);
  if NewPos <= EchoTimeShape.Left then
      EchoTimeButton.Left := EchoTimeShape.Left
    else
      if NewPos >= EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width then
        EchoTimeButton.Left := EchoTimeShape.Left + EchoTimeShape.Width - EchoTimeButton.Width
      else
        EchoTimeButton.Left := NewPos;

  NempPlayer.EchoTime := VCLEchoTimeToPlayer;
  CorrectEchoButtons;
end;
procedure TNemp_MainForm.Btn_EffectsOffClick(Sender: TObject);
begin
  HallButtonMouseDown(HallButton, mbright, [], 0,0);
  EchoWetDryMixButtonMouseDown(EchoWetDryMixButton, mbright, [], 0,0);
  EchoTimeButtonMouseDown(EchoTimeButton, mbright, [], 0,0);
  SampleRateButtonMouseDown(SampleRateButton, mbright, [], 0,0);
end;


procedure TNemp_MainForm.MMKeyTimerTimer(Sender: TObject);
begin
  MMKeyTimer.Enabled := False;

  try
    if Not HookIsInstalled then InstallHook(Nemp_MainForm.Handle);
  except
    //showmessage('nicht installiert');
  end;

  MediaCount := 0;
  MediaTest := True;

  if not assigned(FormMediaKeyInit) then
    Application.CreateForm(TFormMediaKeyInit, FormMediaKeyInit);

  if FormMediaKeyInit.Showmodal = mrOK then
  begin
    if (MediaCount > 1) OR (MediaCount = 0) then
      try
        SchonMalEineMediaTasteGedrueckt := True;
        DoHookInstall := False;
        MessageDLG(_('Your system is already prepared to handle media keys with Nemp properly. No changes neccessary.'), mtInformation, [mbOK],0);
        if HookIsInstalled then UninstallHook;
        HookIsInstalled := False;
        if assigned(OptionsCompleteForm) then
          OptionsCompleteForm.Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Standard);
      except end
      else
      begin
        SchonMalEineMediaTasteGedrueckt := True;
        DoHookInstall := True;
        MessageDLG(_('Nemp will hook media keys. In case of unpleasant behaviour you can deactivate this within the preferences.'), mtInformation, [mbOK],0);
        if assigned(OptionsCompleteForm) then
          OptionsCompleteForm.Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Hook);
      end;
  end else // FormMediaKeyInit Abgebrochen
    try
      SchonMalEineMediaTasteGedrueckt := True;
      DoHookInstall := False;
      if HookIsInstalled then UninstallHook;
      HookIsInstalled := False;
    except
    end;
  MediaTest := False;
end;

procedure TNemp_MainForm.PM_TNA_CloseClick(Sender: TObject);
begin
  close;
end;

procedure TNemp_MainForm.PM_TNA_RestoreClick(Sender: TObject);
begin
  RestoreNemp;
end;

procedure TNemp_MainForm.AnzeigeBTNMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbright then
    // Anhalten/Weiterlaufen
    Spectrum.TextPosX := Spectrum.TextPosX + round(((TextAnzeigeIMAGE.Width DIV 2)-x) / 1.4 );
  if ssShift in Shift then
    NempPlayer.ScrollAnzeigeTitel := NOT NempPlayer.ScrollAnzeigeTitel;
  Spectrum.DrawText(NempPlayer.PlayingTitel);
end;

procedure TNemp_MainForm.AnzeigeBTNClick(Sender: TObject);
begin
  NempPlayer.PlayingTitelMode := (NempPlayer.PlayingTitelMode +1) mod MODE_MAX;
  Spectrum.DrawText(NempPlayer.PlayingTitel,False);
end;


procedure TNemp_MainForm.PlaylistVSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var Data: PTreeData;
begin
 case Kind of
    ikNormal, ikSelected:
      begin
        Data := Sender.GetNodeData(Node);
        case Column of
          0:  // main column
            if (Data.FAudioFile.isStream) AND NOT (Node = NempPlaylist.PlayingNode) then
            begin
              imageIndex := 9;
              exit;  // Anmerkung: Streams k�nnen nur Level 0 haben, daher ist das "if Level..." im Else-Zweik ausreichend!
            end else
            begin
                if Sender.GetNodeLevel(Node) = 0 then
                begin
                        if Not Data.FAudioFile.FileIsPresent then
                          imageIndex := 5
                        else
                          if Node = NempPlayList.PlayingNode then
                            case NempPlayer.Status of
                               PLAYER_ISPLAYING: ImageIndex := 2;
                               PLAYER_ISPAUSED:  ImageIndex := 3;
                               else              ImageIndex := 4;
                            end// Case

                            else
                            begin
                              if Data.FAudioFile.FileChecked then
                              begin
                                if Data.FAudioFile.LyricsExisting then
                                  ImageIndex := 1
                                else
                                  ImageIndex := 0;
                                // Cue-Sheet vorhanden?
                                if assigned(Data.FAudioFile.CueList) and (Data.FAudioFile.CueList.Count > 0) then
                                  ImageIndex := 10;
                              end
                              else // Datei noch nicht untersucht => "?-Note"
                                imageIndex := 8;
                            end;
                end else // level=1
                  ;// nix - kein Bild anzeigen!
            end; // case Column
        end;
      end;
  end;
end;

procedure TNemp_MainForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var Data: PTreeData;
begin
  case Kind of
    ikNormal, ikSelected:
      begin
        Data := Sender.GetNodeData(Node);
        case VST.Header.Columns[column].Tag of
          CON_LYRICSEXISTING :
              if Data^.FAudioFile.LyricsExisting then imageIndex := 6
              else imageIndex := 7;

          CON_LASTFMTAGS :
                  if Length(Data^.FAudioFile.RawTagLastFM) > 0 then imageIndex := 14
              //else imageIndex := 15;

        end;
      end;
  end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedScanFilesClick(Sender: TObject);
var Node: PVirtualNode;
    i: integer;
begin
  for i := 0 to NempPlaylist.Count - 1 do
      TAudioFile(NempPlaylist.Playlist[i]).FileChecked := False;

  LangeAktionWeitermachen := True;

  Node := PlaylistVST.GetFirst;
  while assigned(Node) and LangeAktionWeitermachen do
  begin
      NempPlaylist.ActualizeNode(Node);
      Node := PlaylistVST.GetNextSibling(Node);
  end;
  LangeAktionWeitermachen := False;
end;

procedure TNemp_MainForm.LyricsMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    $41: if ssCtrl in Shift then
        begin
          key := 0;
          LyricsMemo.SelectAll;
        end;
  end;
end;

procedure TNemp_MainForm.Btn_EqualizerPresetsClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Equalizer_PopupMenu.Popup(Point.X, Point.Y);
end;

procedure TNemp_MainForm.Button1Click(Sender: TObject);
//var s: String;
begin
{  s := NempPlayer.NempScrobbler.GetTags(MedienBib.CurrentAudioFile);

  if trim(s) = '' then
      ShowMessage('No Tags found')
  else
  begin
      MedienBib.CurrentAudioFile.RawTagLastFM := AnsiLowerCase(s);
      MedienBib.CurrentAudioFile.SetAudioData(SAD_BOTH);
  end;
}
end;

function TNemp_MainForm.GetDefaultEQName(aIdx: Integer): String;
begin
  if (aIdx >= 0) and (aIdx <= 17) then
      result := EQ_NAMES[aIdx]
  else
      result := 'Unknown equalizer setting (' + IntToStr(aIdx) + ')';
end;

procedure TNemp_MainForm.InitEqualizerMenuFormIni(aIni: TMemIniFile);
var c, i: Integer;
    EQName: String;
    aMenuItem: TMenuItem;
    RewriteIni: Boolean;
begin
    RewriteIni := False;

    c := aIni.ReadInteger('Summary', 'Max', 17);
    if not aIni.ValueExists('Summary', 'Max') then
    begin
        aIni.WriteInteger('Summary', 'Max', c);
        RewriteIni := True;
    end;

    PM_EQ_Load.Clear;
    PM_EQ_Save.Clear;
    PM_EQ_Delete.Clear;

    for i := 0 to c do
    begin
        EQName := aIni.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
        if not (aIni.ValueExists('Summary', 'Name'+IntToStr(i)))then
        begin
            aIni.WriteString('Summary', 'Name'+IntToStr(i), EQName);
            RewriteIni := True;
        end;

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := SetEqualizerFromPresetClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Load.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := SaveEQSettingsClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Save.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.AutoCheck := False;
        aMenuItem.Tag := 0;
        aMenuItem.OnClick := DeleteEQSettingsClick;
        aMenuItem.Caption := EQName;
        PM_EQ_Delete.Add(aMenuItem);
    end;

    aMenuItem := TMenuItem.Create(Nemp_MainForm);
    aMenuItem.AutoHotkeys := maManual;
    aMenuItem.AutoCheck := False;
    aMenuItem.Tag := 0;
    aMenuItem.Caption := '-';
    PM_EQ_Save.Add(aMenuItem);

    aMenuItem := TMenuItem.Create(Nemp_MainForm);
    aMenuItem.AutoHotkeys := maManual;
    aMenuItem.AutoCheck := False;
    aMenuItem.Tag := 1;
    aMenuItem.OnClick := SaveEQSettingsClick;
    aMenuItem.Caption := MainForm_BtnEqualizerSaveNewButton;
    PM_EQ_Save.Add(aMenuItem);

    if RewriteIni then
        try
            aIni.UpdateFile;
        except
            // Silent Exception
        end;
end;

procedure TNemp_MainForm.PM_EQ_DisabledClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to 9 do
    begin
        NempPlayer.SetEqualizer(i, 0);
        CorrectEQButton(i);
    end;
    NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect);
    Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
end;


procedure TNemp_MainForm.SetEqualizerFromPresetClick(Sender: TObject);
var i, DefIndex: integer;
  preset: single;
  PresetName: String;
  ini: TMeminiFile;
begin
  // Gew�hlte Einstellung erkennen
  PresetName := (Sender as TMenuItem).Caption;
  // DefaultIndex ermitteln (f�r die voreingestellten Settings, falls die Ini leer ist)
  DefIndex := GetDefaultEqualizerIndex(PresetName);

  // Daten aus Ini laden
  ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
  try
      for i := 0 to 9 do
      begin
          preset := Ini.ReadInteger(PresetName, 'EQ'+inttostr(i+1), Round(EQ_DEFAULTPRESETS[DefIndex][i])) / EQ_NEW_FACTOR ;
          NempPlayer.SetEqualizer(i, preset);
          CorrectEQButton(i);
      end;
  finally
      ini.Free
  end;

  if SameText(PresetName,EQ_NAMES[0]) then
      NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect)
  else
      NempPlayer.EQSettingName := (Sender as TMenuItem).Caption;
  Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;

end;

procedure TNemp_MainForm.SaveEQSettingsClick(Sender: TObject);
var i, c: integer;
    preset: Integer;
    ini: TMemIniFile;
    PresetName, existingName: String;
    NewName: String;
    Ok, Check, Cancel, NewNameExists, GoOn: Boolean;
begin
  case (Sender as TMenuItem).Tag of
      0: begin
            // Gew�hlte Einstellung erkennen
            PresetName := (Sender as TMenuItem).Caption;
            if MessageDlg(Format(MainForm_BtnEqualizerOverwriteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
            begin
                // Daten aus Ini laden
                ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
                try
                    for i := 0 to 9 do
                    begin
                        preset := Round(NempPlayer.fxGain[i] * EQ_NEW_FACTOR);
                        ini.WriteInteger(PresetName, 'EQ'+inttostr(i+1), preset);
                    end;
                    try
                        Ini.UpdateFile;
                    except
                        // Silent Exception
                    end;
                finally
                    ini.Free
                end;
                NempPlayer.EQSettingName := (Sender as TMenuItem).Caption;
                Btn_EqualizerPresets.Caption := (Sender as TMenuItem).Caption;
            end;
      end
  else
      begin
          // Save unter neuem Namen
          NewName := 'New preset';
          // Eingabe - solange wiederholen, bis Abbruch oder Eingabe g�ltig
          repeat
              Cancel := False;
              Check := False;
              Ok := InputQuery(MainForm_BtnEqualizerSaveNewCaption, MainForm_BtnEqualizerSaveNewPrompt, NewName);
              if OK then
              begin
                  NewName := trim(NewName);
                  Check := length(NewName) >= 1;
                  for i := 1 to length(NewName) do
                  begin
                      if not CharInSet(NewName[i], ['a'..'z', ' ', 'A'..'Z', '0'..'9']) then //(NewName[i] in ['a'..'z', ' ', 'A'..'Z', '0'..'9']) then
                      begin
                          Check := False;
                          break;
                      end;
                  end;
                  if Not Check then
                      Cancel := MessageDLG(MainForm_EqualizerInvalidInput, mtWarning, [mbOk, mbCancel], 0) = mrCancel
                  else
                  begin
                      // OK und Check ok => speichern!
                      Ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
                      try
                          // zuerst NewName suchen - evtl. gibts die Section schon in der Auflistung!
                          NewNameExists := False;
                          c := Ini.ReadInteger('Summary', 'Max', 17);
                          for i := 0 to c do
                          begin
                              existingName := Ini.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
                              if existingName = NewName then
                              begin
                                  NewNameExists := True;
                                  break;
                              end;
                          end;

                          // Abfrage, ob �berschrieben werden soll
                          if NewNameExists then
                          begin
                              GoOn := MessageDLG(Format(MainForm_BtnEqualizerOverwriteQuery, [NewName]), mtInformation, [mbOk, mbCancel], 0) = mrOK
                          end else
                              GoOn := True;

                          if GoOn then
                          begin
                              // Falls neuer Name: max-Wert um eins erh�hen und reinschreiben
                              if not NewNameExists then
                              begin
                                  Ini.WriteInteger('Summary', 'Max', c+1);
                                  Ini.WriteString('Summary', 'Name'+IntToStr(c+1), NewName);
                              end;
                              // Werte in die (neue) Section schreiben
                              for i := 0 to 9 do
                              begin
                                  preset := Round(NempPlayer.fxGain[i] * EQ_NEW_FACTOR);
                                  ini.WriteInteger(NewName, 'EQ'+inttostr(i+1), preset);
                              end;

                              try
                                  // Ini speichern
                                  Ini.UpdateFile;
                              except
                                  // Silent Exception
                              end;
                              // Men�s neu initialisieren
                              InitEqualizerMenuFormIni(Ini);

                              NempPlayer.EQSettingName := NewName;
                              Btn_EqualizerPresets.Caption := NewName;
                          end;
                      finally
                          ini.Free
                      end;
                  end;
              end else
                  Cancel := True;
          until (OK and Check) or Cancel;
      end
  end;
end;


procedure TNemp_MainForm.DeleteEQSettingsClick(Sender: TObject);
var i, c, idx: integer;
    Ini: TMemIniFile;
    PresetName, EQName: String;
begin
    PresetName := (Sender as TMenuItem).Caption;
    if MessageDlg(Format(MainForm_BtnEqualizerDeleteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
          Ini := TMemIniFile.Create(SavePath + 'Nemp_EQ.ini');
          try
              c := Ini.ReadInteger('Summary', 'Max', 17);
              idx := c+1;
              for i := 0 to c do
              begin
                  EQName := Ini.ReadString('Summary', 'Name'+IntToStr(i), GetDefaultEQName(i));
                  if SameText(EQName, PresetName) then
                  begin
                    idx := i;
                    break;
                  end;
              end;
              // Idx markiert das Setting, das gel�scht werden soll
              // folgende Settings r�cken eins auf
              for i := idx to c-1 do
              begin
                  EQName := Ini.ReadString('Summary', 'Name'+IntToStr(i+1), GetDefaultEQName(i));
                  Ini.WriteString('Summary', 'Name'+IntToStr(i), EQName);
              end;
              // letzten, jetzt �berfl�ssigen Key l�schen
              Ini.DeleteKey('Summary', 'Name'+IntToStr(c));
              // max-Wert verkleinern
              Ini.WriteInteger('Summary', 'Max', c-1);
              // ung�ltige Section l�schen
              Ini.EraseSection(PresetName);
              try
                  // Ini speichern
                  Ini.UpdateFile;
              except
                  // Silent Exception
              end;
              // Men�s neu initialisieren
              InitEqualizerMenuFormIni(Ini);

              if SameText(NempPlayer.EQSettingName, PresetName) then
              begin
                  NempPlayer.EQSettingName := MainForm_BtnEqualizerPresetsCustom;
                  Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
              end;
          finally
              Ini.Free;
          end;
    end;
end;

procedure TNemp_MainForm.PM_EQ_RestoreStandardClick(Sender: TObject);
var i, OldMax, iSearch, g, preset: integer;
    Ini: TMemIniFile;
    ValueFound: Boolean;
begin
  if MessageDlg((Player_RestoreDefaultEqualizer), mtInformation, [mbOK, mbABORT], 0) = mrAbort then
      exit;

  Ini := TMemIniFile.Create(SavePath + 'Nemp_EQ.ini');
  try
      OldMax := Ini.ReadInteger('Summary', 'Max', 17);

      for i := 0 to 17 do
      begin
          ValueFound := False;
          for iSearch := 0 to OldMax do
          begin
              if SameText( Ini.ReadString('Summary', 'Name'+IntToStr(iSearch), EQ_NAMES[i]), EQ_NAMES[i]) then
              begin
                  ValueFound := True;
                  break;
              end;
          end;

          // ggf. Max erh�hen und Namen in Ini schreiben
          if not ValueFound then
          begin
              inc(OldMax);
              Ini.WriteInteger('Summary', 'Max', OldMax);
              Ini.WriteString('Summary', 'Name'+IntToStr(OldMax), EQ_NAMES[i]);
          end;

          // Werte in der Section neu schreiben
          for g := 0 to 9 do
          begin
              preset := Round(EQ_DEFAULTPRESETS[i][g]);
              Ini.WriteInteger(EQ_NAMES[i], 'EQ'+inttostr(g+1), preset);
          end;
      end;
      try
          Ini.UpdateFile;
      except
          // Silent Exception
      end;
      InitEqualizerMenuFormIni(Ini);
  finally
      Ini.Free;
  end;

  for i := 0 to 9 do
  begin
    NempPlayer.SetEqualizer(i, 0);
    CorrectEQButton(i);
  end;
  NempPlayer.EQSettingName := MainForm_BtnEqualizerPresetsSelect;
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsSelect);
end;



procedure TNemp_MainForm.DirectionPositionBTNClick(Sender: TObject);
begin
  Nempplayer.ReversePlayback(False{PosRewindCB.Checked});
end;

procedure TNemp_MainForm.MM_H_AboutClick(Sender: TObject);
begin
  if Not Assigned(AboutForm) then
    Application.CreateForm(TAboutForm, AboutForm);
  AboutForm.showmodal;
end;

procedure TNemp_MainForm.SetRepeatBtnGraphics;
begin

  RandomBtn.GlyphLine := NempPlaylist.WiedergabeMode;
  case NempPlaylist.WiedergabeMode of
    0: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatAll);
    1: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatTitle);
    2: RandomBtn.Hint := (MainForm_RepeatBtnHint_RandomMode);
    else
        RandomBtn.Hint := (MainForm_RepeatBtnHint_NoRepeat);
  end;
end;

procedure TNemp_MainForm.RepeatBitBTNIMGClick(Sender: TObject);
begin
    NempPlaylist.WiedergabeMode := (NempPlaylist.WiedergabeMode + 1) Mod 4;
    SetRepeatBtnGraphics;
end;

procedure TNemp_MainForm.PM_RepeatMenuClick(Sender: TObject);
begin
    NempPlaylist.WiedergabeMode := (Sender as TComponent).Tag;
    SetRepeatBtnGraphics;
end;

procedure TNemp_MainForm.PopupRepeatPopup(Sender: TObject);
begin
    case NempPlaylist.WiedergabeMode of
        0: PM_RepeatAll.Checked := True;
        1: PM_RepeatTitle.Checked := True;
        2: PM_RandomMode.Checked := True;
    else
        PM_RepeatOff.Checked := True;
    end;
end;



procedure TNemp_MainForm.VSTHeaderDblClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
exit;
end;


procedure TNemp_MainForm.VSTAdvancedHeaderDraw(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
var  idx: integer;
begin
  if Sender = ArtistsVST.Header then idx := 1
  else if Sender = AlbenVST.Header then idx := 2
  else if Sender = PlaylistVST.Header then idx := 3
  else {if Sender = VST.Header then} idx := 4;


  with PaintInfo do
  begin
    // First check the column member. If it is NoColumn then it's about the header background.
    if Column = nil then
    begin
      if hpeBackground in Elements then
      begin
        TargetCanvas.Brush.Color := NempSkin.SkinColorScheme.Tree_HeaderBackgroundColor[idx];
        TargetCanvas.FillRect(PaintRectangle);

        if (idx = 4) and paintinfo.ShowRightBorder then
        begin
            TargetCanvas.Pen.Color :=  NempSkin.SkinColorScheme.Tree_BorderColor[idx];
            TargetCanvas.MoveTo(PaintRectangle.Right-1, PaintRectangle.Top+1);
            TargetCanvas.LineTo(PaintRectangle.Right-1, PaintRectangle.Bottom-1);
        end;
      end;
    end else
    begin
        TargetCanvas.Brush.Color := NempSkin.SkinColorScheme.Tree_HeaderBackgroundColor[idx];
        TargetCanvas.FillRect(PaintRectangle);
        if (idx = 4) and paintinfo.ShowRightBorder then
        begin
            TargetCanvas.Pen.Color :=  NempSkin.SkinColorScheme.Tree_BorderColor[idx];
            TargetCanvas.MoveTo(PaintRectangle.Right-1, PaintRectangle.Top+1);
            TargetCanvas.LineTo(PaintRectangle.Right-1, PaintRectangle.Bottom-1);
        end
    end;
  end;
end;

procedure TNemp_MainForm.PlaylistVSTResize(Sender: TObject);
begin
  if (NempSkin.isActive and Nempskin.DisablePlaylistScrollbar)
       OR // Oder Scrollbar unsichtbar
     (PlaylistVST.Height > Integer(playlistVST.RootNode.TotalHeight))
  then
    PlaylistVST.Header.Columns[0].Width := PlayListVST.Width - PlaylistVST.Header.Columns[1].Width - 4 // - 12;
  else
    PlaylistVST.Header.Columns[0].Width := PlayListVST.Width - PlaylistVST.Header.Columns[1].Width - 22;// - 12;
end;
procedure TNemp_MainForm.PlaylistVSTCollapsAndExpanded(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  // Wichtig
  PlaylistVSTResize(Sender);
end;

procedure TNemp_MainForm.ArtistsVSTResize(Sender: TObject);
begin
  ArtistsVST.Header.Columns[0].Width := ArtistsVST.Width;
end;


procedure TNemp_MainForm.AlbenVSTResize(Sender: TObject);
begin
  AlbenVST.Header.Columns[0].Width := AlbenVST.Width;
  if NempSkin.isActive and (AnzeigeMode = 0) then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetArtistAlbumOffsets;
    NempSkin.SetVSTOffsets;
    NempSkin.SetPlaylistOffsets;
    RepaintPanels;
  end;
end;

procedure TNemp_MainForm.PaintFrameMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReInitDocks;
  PaintFrameDownX := X;
  PaintFrameDownY := Y;
  // Andere Formen auch in den Vordergund!!!
  //if Tag = 3 then
    RepairZOrder;

    PlaylistForm.Resizing := False;
    MedienlisteForm.Resizing := False;
    AuswahlForm.Resizing := False;
end;

procedure TNemp_MainForm.PaintFrameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
      ClipCursor(Nil);

      if (ssLeft in Shift) AND (WindowState <> wsMaximized) then
      begin
        Left := Left + X - PaintFrameDownX;
        Top  := Top  + Y - PaintFrameDownY;

        if Assigned(ExtendedControlForm) AND ExtendedControlForm.NempRegionsDistance.docked
          AND ExtendedControlForm.Visible
        then
        begin
          ExtendedControlForm.Top := Top + ExtendedControlForm.NempRegionsDistance.RelativPositionY;
          ExtendedControlForm.Left := Left + ExtendedControlForm.NempRegionsDistance.RelativPositionX;
        end;

        if Assigned(PlaylistForm) AND PlaylistForm.NempRegionsDistance.docked
          AND PlaylistForm.Visible
        then
        begin
          PlaylistForm.Top := Top + PlaylistForm.NempRegionsDistance.RelativPositionY;
          PlaylistForm.Left := Left + PlaylistForm.NempRegionsDistance.RelativPositionX;
        end;

        if Assigned(MedienlisteForm) AND MedienlisteForm.NempRegionsDistance.docked
          AND MedienlisteForm.Visible
        then
        begin
          MedienlisteForm.Top := Top + MedienlisteForm.NempRegionsDistance.RelativPositionY;
          MedienlisteForm.Left := Left + MedienlisteForm.NempRegionsDistance.RelativPositionX;
        end;

        if Assigned(AuswahlForm) AND AuswahlForm.NempRegionsDistance.docked
          AND AuswahlForm.Visible
        then
        begin
          AuswahlForm.Top := Top + AuswahlForm.NempRegionsDistance.RelativPositionY;
          AuswahlForm.Left := Left + AuswahlForm.NempRegionsDistance.RelativPositionX;
        end;

        if NempSkin.isActive then
        begin
          NempSkin.FitPlayerToNewWindow;
          RepaintVisOnPause;
          RepaintPlayerPanel;
        end;
      end;

end;

procedure TNemp_MainForm.WMExitSizeMove(var Message: TMessage);
begin
  if NempSkin.isActive then
  begin
    NempSkin.FitSkinToNewWindow;
    RepaintVisOnPause;
    RepaintPanels;
  end;
  message.Result := 0;
end;

procedure TNemp_MainForm.WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING);
begin
  SnapForm(Message, Nemp_MainForm, NIL);
  if assigned(ExtendedControlForm) and not ExtendedControlForm.NempRegionsDistance.docked
      and ExtendedControlForm.Visible then
          SnapForm(Message, Nemp_MainForm, ExtendedControlForm);
  if assigned(auswahlform) and not AuswahlForm.NempRegionsDistance.docked
      and AuswahlForm.Visible then
          SnapForm(Message, Nemp_MainForm, AuswahlForm);
  if assigned(medienlisteform) AND not medienlisteform.NempRegionsDistance.docked
      and MedienlisteForm.Visible  then
          SnapForm(Message, Nemp_MainForm, MedienlisteForm);
  if Assigned(PlaylistForm)  AND not PlaylistForm.NempRegionsDistance.docked
      and PlaylistForm.Visible then
          SnapForm(Message, Nemp_MainForm, PlaylistForm);
  Message.Result := 0;
end;

procedure TNemp_MainForm.PaintFrameMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Tag in [0,1] then
  begin
      NempOptions.NempFormAufteilung[Tag].Maximized := WindowState=wsMaximized;
      // aktuelle Aufteilung speichern
      NempOptions.NempFormAufteilung[Tag].FormTop   := Top ;
      NempOptions.NempFormAufteilung[Tag].FormLeft  := Left;
  end;

  ReInitDocks;

  if NempSkin.isActive then
  begin
    NempSkin.FitSkinToNewWindow;
    RepaintPanels;
    RepaintOtherForms;
  end;

  if ExtendedControlForm.Visible then
  begin
    ExtendedControlForm.NempRegionsDistance.RelativPositionX := ExtendedControlForm.Left - Left;
    ExtendedControlForm.NempRegionsDistance.RelativPositionY := ExtendedControlForm.Top - Top;
  end;

  if PlaylistForm.Visible then
  begin
    PlaylistForm.NempRegionsDistance.RelativPositionX := PlaylistForm.Left - Left;
    PlaylistForm.NempRegionsDistance.RelativPositionY := PlaylistForm.Top - Top;
  end;

  if MedienlisteForm.Visible then
  begin
    MedienlisteForm.NempRegionsDistance.RelativPositionX := MedienlisteForm.Left - Left;
    MedienlisteForm.NempRegionsDistance.RelativPositionY := MedienlisteForm.Top - Top;
  end;

  if Auswahlform.Visible then
  begin
    AuswahlForm.NempRegionsDistance.RelativPositionX := AuswahlForm.Left - Left;
    AuswahlForm.NempRegionsDistance.RelativPositionY := AuswahlForm.Top - Top;
  end;
  
end;

procedure TNemp_MainForm.MM_O_ViewCompactCompleteClick(Sender: TObject);
begin
  Anzeigemode := (Sender as TMenuItem).Tag mod 2;
  if Anzeigemode = 1 then
  begin
      // Party-mode in Separate-Window-Mode is not allowed.
      NempSkin.NempPartyMode.Active := False;
      CorrectFormAfterPartyModeChange;
  end;

  UpdateFormDesignNeu;
end;

procedure TNemp_MainForm.CorrectFormAfterPartyModeChange;
begin
{    if NempSkin.NempPartyMode.Active then
      Spectrum.SetScale(NempSkin.NempPartyMode.ResizeFactor)
    else
      Spectrum.SetScale(1);
    ReArrangeToolImages;
}
end;

procedure TNemp_MainForm.PM_P_PartyModeClick(Sender: TObject);
begin
  if Anzeigemode = 1 then
  begin
      // Set Compact Mode
      // Party-mode in Separate-Window-Mode is not allowed.
      Anzeigemode := 0;
      UpdateFormDesignNeu;
  end;

  NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active;
  CorrectFormAfterPartyModeChange;
end;


procedure TNemp_MainForm.PlayerTabsClick(Sender: TObject);
var heightaddi: integer;
    point: TPoint;
begin

  if AnzeigeMode = 0 then
    heightaddi := 170
  else
    heightaddi := 80;

  if (Sender as TControl).Tag > 0 then
  begin
      TabBtn_Cover.GlyphLine := 0;
      TabBtn_Lyrics.GlyphLine := 0;
      TabBtn_Equalizer.GlyphLine := 0;
      TabBtn_Effects.GlyphLine := 0;
  end;

  Case (Sender as TControl).Tag of
      0: begin
          GetCursorPos(Point);
          Player_PopupMenu.Popup(Point.X, Point.Y+10);
      end;
      1: begin
          GRPBoxCover.Visible     := True;
          GRPBoxLyrics.Visible    := False;
          GRPBoxEqualizer.Visible := False;
          GRPBoxEffekte.Visible   := False;
          TabBtn_Cover.GlyphLine := 1;
      end;
      2: begin
          GRPBoxCover.Visible     := False;
          GRPBoxLyrics.Visible    := True;
          GRPBoxEqualizer.Visible := False;
          GRPBoxEffekte.Visible   := False;
          TabBtn_Lyrics.GlyphLine := 1;
      end;
      3: begin
          GRPBoxCover.Visible     := False;
          GRPBoxLyrics.Visible    := False;
          GRPBoxEqualizer.Visible := True;
          GRPBoxEffekte.Visible   := False;
          TabBtn_Equalizer.GlyphLine := 1;
      end;
      4: begin
          GRPBoxCover.Visible     := False;
          GRPBoxLyrics.Visible    := False;
          GRPBoxEqualizer.Visible := False;
          GRPBoxEffekte.Visible   := True;
          // erzwingt den Refresh des Buttons. Scheint manchmal n�tig zu sein...
          DirectionPositionBTN.GlyphLine := DirectionPositionBTN.GlyphLine;
          TabBtn_Effects.GlyphLine := 1;
      end;
  end; //case

  Constraints.MinHeight := TopMainPanel.Constraints.MinHeight + heightaddi;
end;


procedure TNemp_MainForm.AuswahlPanelResize(Sender: TObject);
begin
  if AuswahlPanel.Width < ArtistsVST.Width + 20 then
    ArtistsVST.Width := AuswahlPanel.Width DIV 2;
  AuswahlStatusLBL.Width := AuswahlFillPanel.Width - 16;
end;



procedure TNemp_MainForm.TABPanelAuswahlClick(Sender: TObject);
begin
    SwitchBrowsePanel((Sender as TControl).Tag);
    SwitchMediaLibrary((Sender as TControl).Tag);
end;


procedure TNemp_MainForm.PM_ML_MedialibraryExportClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

//deleted Oktober, 9, 2008  SaveDialog1.InitialDir := myFolder;
  SaveDialog1.Filter := (MediaLibrary_CSVFilter) + ' (*.csv)|*.csv';
  if SaveDialog1.Execute then
      if not MedienBib.SaveAsCSV(SaveDialog1.FileName) then
        MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
end;

procedure TNemp_MainForm.PM_P_CloseClick(Sender: TObject);
begin
  close;
end;


procedure TNemp_MainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (MedienBib.StatusBibUpdate = 0) AND (NempPlaylist.Status = 0);
  if not CanClose then
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
end;

procedure TNemp_MainForm.PM_P_MinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;



procedure TNemp_MainForm.AutoSavePlaylistTimerTimer(Sender: TObject);
begin
    if FileExists(SavePath + 'temp.npl') then
        CopyFileW(PWideChar(SavePath + 'temp.npl'), PWideChar(SavePath + 'temp.old.npl'), False);

  NempPlaylist.SaveToFile(SavePath + 'temp.npl', True);
end;

procedure TNemp_MainForm.ArtistsVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i:integer;
  DateiListe: TObjectlist;
  aNode: PVirtualNode;
begin
  aNode := ArtistsVST.FocusedNode;
  if not assigned(aNode) then exit;
  Dateiliste := TObjectlist.Create(False);

  GenerateListForHandleFiles(DateiListe, 1);

  DragSource := DS_VST;
  with DragFilesSrc1 do
  begin
      // Add files selected to DragFilesSrc1 list
      ClearFiles;
      DragDropList.Clear;

      if DateiListe.Count > MAX_DRAGFILECOUNT then
      begin
        MessageDlg((Warning_TooManyFiles), mtInformation, [MBOK], 0);
        if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
        FreeAndNil(Dateiliste);
        exit;
      end;

      for i:=0 to DateiListe.Count - 1 do
      begin
          AddFile((Dateiliste[i] as TAudiofile).Pfad);
          DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad);
      end;

      // This is the START of the drag (FROM) operation.
      Execute;
  end;
  if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  FreeAndNil(Dateiliste);
end;

procedure TNemp_MainForm.AlbenVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i:integer;
  DateiListe: TObjectlist;
  aNode, ArtistNode: PVirtualNode;

  DataS: PStringTreeData;
  Artist: UnicodeString;

begin
    aNode := AlbenVST.FocusedNode;
    if not assigned(aNode) then exit;

    ArtistNode := ArtistsVST.FocusedNode;
    if assigned(ArtistNode) then
    begin
        DataS  := ArtistsVST.GetNodeData(ArtistNode);
        Artist := TJustAstring(DataS^.FString).DataString
    end else
        Artist := BROWSE_ALL;

    if Artist <> BROWSE_RADIOSTATIONS then
    begin
        Dateiliste := TObjectlist.Create(False);
        GenerateListForHandleFiles(Dateiliste, 2);
        DragSource := DS_VST;
        with DragFilesSrc1 do
        begin
            // Add files selected to DragFilesSrc1 list
            ClearFiles;
            DragDropList.Clear;

            if DateiListe.Count > MAX_DRAGFILECOUNT then
            begin
              MessageDlg((Warning_TooManyFiles), mtInformation, [MBOK], 0);
              FreeAndNil(Dateiliste);
              exit;
            end;

            for i:=0 to DateiListe.Count - 1 do
            begin
                AddFile((Dateiliste[i] as TAudiofile).Pfad);
                DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad)
            end;
            // This is the START of the drag (FROM) operation.
            Execute;
        end;

        if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
        FreeAndNil(Dateiliste);
    end;
end;
procedure TNemp_MainForm.PlaylistVSTScroll(Sender: TBaseVirtualTree; DeltaX,
  DeltaY: Integer);
begin
  NempPlayList.YMouseDown := NempPlayList.YMouseDown + DeltaY;
end;

procedure TNemp_MainForm.FormResize(Sender: TObject);
begin
//  TopMainPanel.Constraints.MaxHeight := Height - 160;

  if AnzeigeMode = 0 then
  begin
    TopMainPanel.Constraints.MaxHeight := Height - 172;
    if Height - TopMainpanel.Height < 172 then
      TopMainPanel.Height := Height - 172;

    AuswahlPanel.Constraints.MaxWidth := Width - 234 - 150;
    if Width - 234 - AuswahlPanel.Width < 150 then
      AuswahlPanel.Width := Width - 234 - 150;
  end;
end;


procedure TNemp_MainForm.MM_PL_WebStreamClick(Sender: TObject);
begin
  if not assigned(FormStreamVerwaltung) then
    Application.CreateForm(TFormStreamVerwaltung, FormStreamVerwaltung);
  FormStreamVerwaltung.show;
end;

procedure TNemp_MainForm.EDITFastSearchEnter(Sender: TObject);
begin
  if EditFastSearch.Font.Color = clGrayText then
  begin
      EditFastSearch.OnChange := Nil;
      EditFastSearch.Text := '';
      EditFastSearch.OnChange := EDITFastSearchChange;
  end
  else
      EditFastSearch.SelectAll;
  EditFastSearch.Font.Color := clWindowText;
  EditFastSearch.Font.Style := [];
end;

procedure TNemp_MainForm.EDITFastSearchExit(Sender: TObject);
begin
  if Trim(EditFastSearch.Text) = '' then
  begin
    EditFastSearch.Font.Color := clGrayText;
    EditFastSearch.Font.Style := [];
    EditFastSearch.OnChange := Nil;
    EditFastSearch.Text := MainForm_GlobalQuickSearch;
    EditFastSearch.OnChange := EDITFastSearchChange;
  end;
end;

procedure TNemp_MainForm.PM_P_ViewStayOnTopClick(Sender: TObject);
begin
  NempOptions.MiniNempStayOnTop := NOT NempOptions.MiniNempStayOnTop;

  PM_P_ViewStayOnTop.Checked     := NempOptions.MiniNempStayOnTop;
  MM_O_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
  RepairZOrder;
end;

procedure TNemp_MainForm.DoFastSearch(aString: UnicodeString; AllowErr: Boolean = False);
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;
    MedienBib.GlobalQuickSearch(aString, AllowErr);
end;

procedure TNemp_MainForm.CB_MedienBibGlobalQuickSearchClick(
  Sender: TObject);
begin
///  MedienBib.BibSearcher.QuickSearchOptions.GlobalQuickSearch := CB_MedienBibGlobalQuickSearch.Checked;


    EditFastSearch.Font.Color := clGrayText;
    EditFastSearch.Font.Style := [];
    EditFastSearch.OnChange := Nil;
    EditFastSearch.Text := MainForm_GlobalQuickSearch;
    EditFastSearch.OnChange := EDITFastSearchChange;

    MedienBib.ShowQuickSearchList;
{
  if EditFastSearch.Font.Color = clGrayText then
  begin
      EditFastSearch.OnChange := Nil;
      EditFastSearch.Text := MainForm_GlobalQuickSearch;
      EditFastSearch.OnChange := EDITFastSearchChange;
  end else
  begin
      if Trim(EDITFastSearch.Text)= '' then
      begin
          // Je nach letzte Quicksearch oder alles anzeigen
          //if MedienBib.BibSearcher.QuickSearchOptions.GlobalQuickSearch then
          //    MedienBib.GenerateAnzeigeListe(BROWSE_ALL, BROWSE_ALL, False) // False: Kein Update der Quicksearchlist
          //else
          MedienBib.ShowQuickSearchList;
      end
      else
          DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter);
  end;

  }
end;

procedure TNemp_MainForm.EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_RETURN then
  begin
    key := #0;
    if Trim(EDITFastSearch.Text)= '' then
    begin
        // Je nach letzte Quicksearch oder alles anzeigen
        //if MedienBib.BibSearcher.QuickSearchOptions.GlobalQuickSearch then
        //    MedienBib.GenerateAnzeigeListe(BROWSE_ALL, BROWSE_ALL, False) // False: Kein Update der Quicksearchlist
        //else
            MedienBib.ShowQuickSearchList;
    end
    else
        DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter);
  end;
end;





procedure TNemp_MainForm.EDITFastSearchChange(Sender: TObject);
begin
  If MedienBib.BibSearcher.QuickSearchOptions.WhileYouType then
  begin
      if Trim(EDITFastSearch.Text)= '' then
      begin
          // Je nach letzte Quicksearch oder alles anzeigen
          //if MedienBib.BibSearcher.QuickSearchOptions.GlobalQuickSearch then
          //    MedienBib.GenerateAnzeigeListe(BROWSE_ALL, BROWSE_ALL, False) // False: Kein Update der Quicksearchlist
          //else
              MedienBib.ShowQuickSearchList;
      end else
          if Length(Trim(EDITFastSearch.Text)) >= 2 then
              DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType);
  end;
  // Sonst nichts machen.
end;



procedure TNemp_MainForm.FormPaint(Sender: TObject);
begin
  if (Not BassTimer.Enabled) OR (NOT NempPlayer.UseVisualization) then
      Spectrum.DrawClear;
end;


procedure TNemp_MainForm.PlaylistVSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
var Data: PTreeData;
begin
  Data := Sender.GetNodeData(Node);

  if not assigned(Data) then exit;

  if Data^.FAudioFile.isStream then
    HintText := ' ' + (AudioFileProperty_Webstream) + #13#10
               + Format(' %s: %s', [(AudioFileProperty_Name), Data^.FAudioFile.Description]) + #13#10
               + Format(' %s: %s', [(AudioFileProperty_URL) , Data^.FAudioFile.Pfad])
  else
  begin
    HintText :=
         Format(' %s: %s'        , [(AudioFileProperty_Artist)    ,Data^.FAudioFile.Artist]) + #13#10
       + Format(' %s: %s'        , [(AudioFileProperty_Title)     ,Data^.FAudioFile.Titel]) + #13#10
       + Format(' %s: %s'        , [(AudioFileProperty_Album)     ,Data^.FAudioFile.Album]);

    if Data^.FAudioFile.Track <> 0 then
      HintText := HintText + Format(' (%s %d)', [AudioFileProperty_Track, Data^.FAudioFile.Track]) + #13#10
    else
      HintText := HintText + #13#10;

    HintText := HintText
       + Format(' %s: %s'        , [(AudioFileProperty_Duration)  ,SekIntToMinStr(Data^.FAudioFile.Duration)]) + #13#10
       + Format(' %s: %s kbit/s' , [(AudioFileProperty_Bitrate)   ,IntTostr(Data^.FAudioFile.Bitrate)]) + #13#10
       + Format(' %s: %s MB'     , [(AudioFileProperty_Filesize)  ,FloatToStrF((Data^.FAudioFile.Size / 1024 / 1024),ffFixed,4,2)]) + #13#10
       + Format(' %s: %s'        , [(AudioFileProperty_Directory) ,Data^.FAudioFile.Ordner]) + #13#10
       + Format(' %s: %s'        , [(AudioFileProperty_Filename)  ,Data^.FAudioFile.Dateiname]);
    end;

end;

procedure TNemp_MainForm.DragFilesSrc1Dropping(Sender: TObject);
begin
  // Beim Droppen in Nemp wird die Quelle abgepr�ft
  // (DragSource), um festzustellen, ob vom VST oder von au�erhalb
  // was ankommt. Zuerst muss also gepr�ft werden, und kurz danach
  // die Quelle wieder auf "Extern" gestellt werden
  // Da es kein Event OnDropped gibt, l�se ich das Dirty �ber einen Timer.
  DragDropTimer.Enabled := True;
end;
procedure TNemp_MainForm.DragDropTimerTimer(Sender: TObject);
begin
  DragSource := DS_EXTERN;
  DragDropTimer.Enabled := False;
end;

procedure TNemp_MainForm.VSTAfterItemErase(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var
      lBlendParams: TBlendFunction;
      DoIt: Boolean;
      BlendColor: TColor;
      BlendIntensity: Integer;
begin
  // Parameter f�r Alphablending zusammstellen
  if Not NempSkin.isActive then exit;

  if Sender = VST then
  begin
    DoIt := NempSkin.UseBlendedMedienliste;
    BlendIntensity := Nempskin.BlendFaktorMedienliste2;
    BlendColor := Nempskin.SkinColorScheme.Tree_Color[4];
  end else
    if Sender = PlaylistVST then
    begin
      DoIt := NempSkin.UseBlendedPlaylist;
      BlendIntensity := Nempskin.BlendFaktorPlaylist2;
      BlendColor := Nempskin.SkinColorScheme.Tree_Color[3];
    end else
      if Sender = ArtistsVST then
      begin
        DoIt := NempSkin.UseBlendedArtists;
        BlendIntensity := Nempskin.BlendFaktorArtists2;
        BlendColor := Nempskin.SkinColorScheme.Tree_Color[1];
      end else
        //if Sender = AlbenVST then
        begin
          DoIt := NempSkin.UseBlendedAlben;
          BlendIntensity := Nempskin.BlendFaktorAlben2;
          BlendColor := Nempskin.SkinColorScheme.Tree_Color[2];
        end;

  if Not DoIt then exit;

  with lBlendParams do
    begin
      BlendOp := AC_SRC_OVER;
      BlendFlags := 0;
      SourceConstantAlpha := BlendIntensity;  // Intensit�t
      AlphaFormat := 0;
    end;

  // Farbe f�r Zeile w�hlen
  AlphaBlendBMP.Canvas.Brush.Color := BlendColor;//RGB(0,0, 0);
  with ItemRect do
    begin
      // Bitmap-Gr��e einstellen, Bitmap einf�rben
      AlphaBlendBMP.Width := Right - Left;
      AlphaBlendBMP.Height := Bottom - Top;
      AlphaBlendBMP.Canvas.FillRect (Rect(0, 0, Width, Height));
      //AlphaBlendBMP.Canvas.FillRect (Rect(0, 0, Right - Left, Bottom - Top));
      // Alphablending durchf�hren
      Windows.AlphaBlend(TargetCanvas.Handle, Left, Top, Right - Left, Bottom - Top,
                         AlphaBlendBMP.Canvas.Handle, 0, 0, AlphaBlendBMP.Width, AlphaBlendBMP.Height, lBlendParams);
    end;
end;



procedure TNemp_MainForm.SortierAuswahl1POPUPClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  // Changes herer todo:
  // - Detect Browse-Mode
  // - Set CoverSort AND Set MedienBibSortArray
  // - Switch SwitchMediaLibrary according to current Browsemode (Lists/Flow)

  //(Sender as TMenuItem).Checked := True;
  case (Sender as TMenuItem).Tag of
    0:  begin
            MedienBib.NempSortArray[1] := siArtist;
            MedienBib.NempSortArray[2] := siAlbum;
            MedienBib.CoverSortOrder := 1;
        end;
    1:  begin
            MedienBib.NempSortArray[1] := siOrdner;
            MedienBib.NempSortArray[2] := siArtist;
            MedienBib.CoverSortOrder := 6;
        end;
    2:  begin
            MedienBib.NempSortArray[1] := siOrdner;
            MedienBib.NempSortArray[2] := siAlbum;
            MedienBib.CoverSortOrder := 7;
        end;
    3:  begin
            MedienBib.NempSortArray[1] := siGenre;
            MedienBib.NempSortArray[2] := siArtist;
            MedienBib.CoverSortOrder := 3;
        end;
    4:  begin
            MedienBib.NempSortArray[1] := siGenre;
            MedienBib.NempSortArray[2] := siJahr;
            MedienBib.CoverSortOrder := 5;
        end;

    6: begin
            MedienBib.NempSortArray[1] := siAlbum;
            MedienBib.NempSortArray[2] := siArtist;
            MedienBib.CoverSortOrder := 2;
    end;
    7: begin
            MedienBib.NempSortArray[1] := siJahr;
            MedienBib.NempSortArray[2] := siArtist;
            MedienBib.CoverSortOrder := 4;
    end;

    // 5: Coverflow - nothing to do here
    100:  begin
            // Weitere Sortierungen - Optionsfenster anzeigen
            if Not Assigned(OptionsCompleteForm) then
              Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.VorauswahlNode;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAnzeige5;
            OptionsCompleteForm.Show;
        end;
  end;

  case (Sender as TMenuItem).Tag of
      0..4, 6..7 : SwitchMediaLibrary(MedienBib.BrowseMode);
      //5 : SwitchMediaLibrary(1);     // CoverFlow
  end;
end;


procedure TNemp_MainForm.AuswahlPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PerForm(WM_SysCommand, $F012 , 0);
end;

procedure TNemp_MainForm.TntFormDestroy(Sender: TObject);
begin
    CoverScrollbar.WindowProc := OldScrollbarWindowProc;
    LyricsMemo.WindowProc := OldLyricMemoWindowProc;

    AlphaBlendBMP.Free;
    try
      Spectrum.Free;
    except
    end;

    // nur zur Sicherheit
    try
      NempSkin.Free;
    except
    end;

    NempPlaylist.Free;
    NempPlayer.Free;

    MedienBib.Free;
    BibRatingHelper.Free;

    LanguageList.Free;
    NempUpdater.Free;

   //ST_Playlist.Free;
    //ST_Medienliste.Free;
end;

procedure TNemp_MainForm.BtnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TNemp_MainForm.BtnMinimizeClick(Sender: TObject);
begin
  Application.minimize;
end;

procedure TNemp_MainForm.PM_P_ViewCompactClick(Sender: TObject);
begin
  MM_O_ViewCompactCompleteClick(PM_P_ViewCompactComplete);
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_PlaylistClick(Sender: TObject);
begin
  NempOptions.NempEinzelFormOptions.PlaylistVisible := NOT NempOptions.NempEinzelFormOptions.PlaylistVisible;
  PM_P_ViewSeparateWindows_Playlist.Checked := NempOptions.NempEinzelFormOptions.PlaylistVisible;
  MM_O_ViewSeparateWindows_Playlist.Checked := NempOptions.NempEinzelFormOptions.PlaylistVisible;

  PlaylistForm.Visible := NempOptions.NempEinzelFormOptions.PlaylistVisible;
  if PlaylistForm.Visible then
  begin
      FormPosAndSizeCorrect(PlaylistForm);
      PlaylistForm.FormResize(Nil);
      //ReInitRelativePositions;
  end;
  ReInitDocks;
end;


procedure TNemp_MainForm.PM_P_ViewSeparateWindows_MedialistClick(Sender: TObject);
begin
  NempOptions.NempEinzelFormOptions.MedienlisteVisible := NOT NempOptions.NempEinzelFormOptions.MedienlisteVisible;
  PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
  MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;

  MedienListeForm.Visible := NempOptions.NempEinzelFormOptions.MedienListeVisible;
  if MedienListeForm.Visible then
  begin
      FormPosAndSizeCorrect(MedienListeForm);
      MedienListeForm.FormResize(Nil);
      //ReInitRelativePositions;
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_BrowseClick(
  Sender: TObject);
begin
  NempOptions.NempEinzelFormOptions.AuswahlSucheVisible := NOT NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  PM_P_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  MM_O_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

  AuswahlForm.Visible := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  if AuswahlForm.Visible then
  begin
      FormPosAndSizeCorrect(AuswahlForm);
      AuswahlForm.FormResize(Nil);
      //ReInitRelativePositions;
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_EqualizerClick(
  Sender: TObject);
begin
  NempOptions.NempEinzelformOptions.ErweiterteControlsVisible := NOT NempOptions.NempEinzelformOptions.ErweiterteControlsVisible;
  PM_P_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelformOptions.ErweiterteControlsVisible;
  MM_O_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelformOptions.ErweiterteControlsVisible;


  ExtendedControlForm.Visible := NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
  if ExtendedControlForm.Visible then
  begin
      FormPosAndSizeCorrect(ExtendedControlForm);
      //MedienListeForm.FormResize(Nil);
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.BtnMenuClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Player_PopupMenu.Popup(Point.X, Point.Y+10);
end;
procedure TNemp_MainForm._XXX_SleepLBLClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  SleepPopup.Popup(Point.X, Point.Y+10);
end;
procedure TNemp_MainForm._XXX_BirthdayLBLClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  BirthdayPopup.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.Nichtvorhandenelschen1Click(Sender: TObject);
begin
  NempPlaylist.DeleteDeadFiles;
end;

procedure TNemp_MainForm.TabPanelMedienlisteClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Medialist_PopupMenu.Popup(Point.X, Point.Y+10);
end;

Function TNemp_MainForm.GenerateSleepHint: String;
var c: Integer;
begin
  if NempOptions.ShutDownAtEndOfPlaylist then
  begin
      result := #13#10#13#10 + NempShutDown_AtEndOfPlaylist_Hint;
      Case NempOptions.ShutDownMode of
            //SHUTDOWNMODE_StopNemp  : result := Format((NempShutDown_StopHint     ),  [SekToZeitString(c, true)] );
            SHUTDOWNMODE_ExitNemp  : result := NempShutDown_CloseHint_AtEndOfPlaylist    + result;
            SHUTDOWNMODE_Suspend   : result := NempShutDown_SuspendHint_AtEndOfPlaylist  + result;
            SHUTDOWNMODE_Hibernate : result := NempShutDown_HibernateHint_AtEndOfPlaylist+ result;
            SHUTDOWNMODE_Shutdown  : result := NempShutDown_ShutDownHint_AtEndOfPlaylist + result;
            else result := ''
      end;
  end else
  begin
      c := SecondsBetween(Now, NempOptions.ShutDownTime);
      Case NempOptions.ShutDownMode of
            SHUTDOWNMODE_StopNemp  : result := Format((NempShutDown_StopHint     ),  [SekToZeitString(c, true)] );
            SHUTDOWNMODE_ExitNemp  : result := Format((NempShutDown_CloseHint    ),  [SekToZeitString(c, true)] );
            SHUTDOWNMODE_Suspend   : result := Format((NempShutDown_SuspendHint  ),  [SekToZeitString(c, true)] );
            SHUTDOWNMODE_Hibernate : result := Format((NempShutDown_HibernateHint),  [SekToZeitString(c, true)] );
            SHUTDOWNMODE_Shutdown  : result := Format((NempShutDown_ShutDownHint ),  [SekToZeitString(c, true)] );
            else result := ''
      end;
  end;
end;

procedure TNemp_MainForm.ResetShutDownCaptions;
begin
    PM_P_ShutDownModeStop            .Caption :=  NempShutDown_StopPopupBlank      ;
    PM_P_ShutDownModeCloseNemp       .Caption :=  NempShutDown_ClosePopupBlank     ;
    PM_P_ShutDownModeSuspend         .Caption :=  NempShutDown_SuspendPopupBlank   ;
    PM_P_ShutDownModeHibernate       .Caption :=  NempShutDown_HibernatePopupBlank ;
    PM_P_ShutDownModeShutDownWindows .Caption :=  NempShutDown_ShutDownPopupBlank  ;

    MM_T_ShutDownModeStop            .Caption :=  NempShutDown_StopPopupBlank      ;
    MM_T_ShutdownModeCloseNemp       .Caption :=  NempShutDown_ClosePopupBlank     ;
    MM_T_ShutDownModeSuspend         .Caption :=  NempShutDown_SuspendPopupBlank   ;
    MM_T_ShutDownModeHibernate       .Caption :=  NempShutDown_HibernatePopupBlank ;
    MM_T_ShutDownModeShutDownWindows .Caption :=  NempShutDown_ShutDownPopupBlank  ;

    PM_S_ShutDownModeStop            .Caption :=  NempShutDown_StopPopupBlank      ;
    PM_S_ShutdownModeCloseNemp       .Caption :=  NempShutDown_ClosePopupBlank     ;
    PM_S_ShutDownModeSuspend         .Caption :=  NempShutDown_SuspendPopupBlank   ;
    PM_S_ShutDownModeHibernate       .Caption :=  NempShutDown_HibernatePopupBlank ;
    PM_S_ShutDownModeShutDownWindows .Caption :=  NempShutDown_ShutDownPopupBlank  ;
end;

procedure TNemp_MainForm.Player_PopupMenuPopup(Sender: TObject);
var c: Integer;
begin
  ResetShutDownCaptions;
  if SleepTimer.Enabled then
  begin
      c := SecondsBetween(Now, NempOptions.ShutDownTime);
      case NempOptions.ShutDownMode of
        SHUTDOWNMODE_StopNemp : begin
                                    MM_T_ShutDownModeStop.Caption := Format((NempShutDown_StopPopupTime),  [SekToZeitString(c, True)] );
                                    PM_P_ShutDownModeStop.Caption := Format((NempShutDown_StopPopupTime),  [SekToZeitString(c, True)] );
                                    PM_S_ShutDownModeStop.Caption := Format((NempShutDown_StopPopupTime),  [SekToZeitString(c, True)] );
                                end;
        SHUTDOWNMODE_ExitNemp  : begin
                                    MM_T_ShutdownModeCloseNemp.Caption := Format((NempShutDown_ClosePopupTime),  [SekToZeitString(c, True)] );
                                    PM_P_ShutDownModeCloseNemp.Caption := Format((NempShutDown_ClosePopupTime),  [SekToZeitString(c, True)] );
                                    PM_S_ShutDownModeCloseNemp.Caption := Format((NempShutDown_ClosePopupTime),  [SekToZeitString(c, True)] );
                                 end;
        SHUTDOWNMODE_Suspend   : begin
                                   MM_T_ShutdownModeSuspend.Caption := Format((NempShutDown_SuspendPopupTime),  [SekToZeitString(c, True)] );
                                   PM_P_ShutDownModeSuspend.Caption := Format((NempShutDown_SuspendPopupTime),  [SekToZeitString(c, True)] );
                                   PM_S_ShutDownModeSuspend.Caption := Format((NempShutDown_SuspendPopupTime),  [SekToZeitString(c, True)] );
                                 end;
        SHUTDOWNMODE_Hibernate : begin
                                    MM_T_ShutdownModeHibernate.Caption := Format((NempShutDown_HibernatePopupTime),  [SekToZeitString(c, True)] );
                                    PM_P_ShutDownModeHibernate.Caption := Format((NempShutDown_HibernatePopupTime),  [SekToZeitString(c, True)] );
                                    PM_S_ShutDownModeHibernate.Caption := Format((NempShutDown_HibernatePopupTime),  [SekToZeitString(c, True)] );
                                 end;
        SHUTDOWNMODE_Shutdown  : begin
                                    MM_T_ShutdownModeShutDownWindows.Caption := Format((NempShutDown_ShutDownPopupTime),  [SekToZeitString(c, True)] );
                                    PM_P_ShutDownModeShutDownWindows.Caption := Format((NempShutDown_ShutDownPopupTime),  [SekToZeitString(c, True)] );
                                    PM_S_ShutDownModeShutDownWindows.Caption := Format((NempShutDown_ShutDownPopupTime),  [SekToZeitString(c, True)] );
                                 end;
      end;
  end else
  begin
      if NempOptions.ShutDownAtEndOfPlaylist then
      begin

          case NempOptions.ShutDownMode of
              SHUTDOWNMODE_ExitNemp  : begin
                                        MM_T_ShutdownModeCloseNemp.Caption := NempShutDown_ClosePopupTime_AtEndOfPlaylist;
                                        PM_P_ShutDownModeCloseNemp.Caption := NempShutDown_ClosePopupTime_AtEndOfPlaylist;
                                        PM_S_ShutDownModeCloseNemp.Caption := NempShutDown_ClosePopupTime_AtEndOfPlaylist;
                                     end;
              SHUTDOWNMODE_Suspend   : begin
                                       MM_T_ShutdownModeSuspend.Caption := NempShutDown_SuspendPopupTime_AtEndOfPlaylist;
                                       PM_P_ShutDownModeSuspend.Caption := NempShutDown_SuspendPopupTime_AtEndOfPlaylist;
                                       PM_S_ShutDownModeSuspend.Caption := NempShutDown_SuspendPopupTime_AtEndOfPlaylist;
                                     end;
              SHUTDOWNMODE_Hibernate : begin
                                        MM_T_ShutdownModeHibernate.Caption := NempShutDown_HibernatePopupTime_AtEndOfPlaylist;
                                        PM_P_ShutDownModeHibernate.Caption := NempShutDown_HibernatePopupTime_AtEndOfPlaylist;
                                        PM_S_ShutDownModeHibernate.Caption := NempShutDown_HibernatePopupTime_AtEndOfPlaylist;
                                     end;
              SHUTDOWNMODE_Shutdown  : begin
                                        MM_T_ShutdownModeShutDownWindows.Caption := NempShutDown_ShutDownPopupTime_AtEndOfPlaylist;
                                        PM_P_ShutDownModeShutDownWindows.Caption := NempShutDown_ShutDownPopupTime_AtEndOfPlaylist;
                                        PM_S_ShutDownModeShutDownWindows.Caption := NempShutDown_ShutDownPopupTime_AtEndOfPlaylist;
                                     end;
          end;
      end;
  end;
end;


procedure TNemp_MainForm.StundenClick(Sender: TObject);
var c: Integer;
begin
//neue Methode: Tag Mod 100 => Zeit
//                          => Shutdown-Time := Now + zeit
//              Tag DIV 100 => Modus (Stop, Clos, Hibernate,...)

  case ((Sender as TMenuItem).Tag) Mod 100 of
      0: NempOptions.ShutDownTime := IncMinute(Now, 5);
      1: NempOptions.ShutDownTime := IncMinute(Now, 15);
      2: NempOptions.ShutDownTime := IncMinute(Now, 30);
      3: NempOptions.ShutDownTime := IncMinute(Now, 45);
      4: NempOptions.ShutDownTime := IncMinute(Now, 60);
      5: NempOptions.ShutDownTime := IncMinute(Now, 90);
      6: NempOptions.ShutDownTime := IncMinute(Now, 120);
      else begin
          //...
          // Form zeigen, Zeit eingeben
          if not assigned(ShutDownEditForm) then
              Application.CreateForm(TShutDownEditForm, ShutDownEditForm);

          if ShutDownEditForm.ShowModal = mrOk then
              NempOptions.ShutDownTime := IncMinute(Now, 60 * ShutDownEditForm.SE_Hours.Value + ShutDownEditForm.SE_Minutes.Value)
          else
              exit;
      end;
  end;

  NempOptions.ShutDownMode := ((Sender as TMenuItem).Tag) Div 100;
  NempOptions.ShutDownAtEndOfPlaylist := False;
  
  case ((Sender as TMenuItem).Tag) Div 100 of
      SHUTDOWNMODE_StopNemp : begin
                                  MM_T_ShutDownModeStop.Checked := True;
                                  PM_P_ShutDownModeStop.Checked := True;
                                  PM_S_ShutDownModeStop.Checked := True;
                              end;
      SHUTDOWNMODE_ExitNemp  : begin
                                  MM_T_ShutdownModeCloseNemp.Checked := True;
                                  PM_P_ShutDownModeCloseNemp.Checked := True;
                                  PM_S_ShutDownModeCloseNemp.Checked := True;
                               end;
      SHUTDOWNMODE_Suspend   : begin
                                 MM_T_ShutdownModeSuspend.Checked := True;
                                 PM_P_ShutDownModeSuspend.Checked := True;
                                 PM_S_ShutDownModeSuspend.Checked := True;
                               end;
      SHUTDOWNMODE_Hibernate : begin
                                  MM_T_ShutdownModeHibernate.Checked := True;
                                  PM_P_ShutDownModeHibernate.Checked := True;
                                  PM_S_ShutDownModeHibernate.Checked := True;
                               end;
      SHUTDOWNMODE_Shutdown  : begin
                                  MM_T_ShutdownModeShutDownWindows.Checked := True;
                                  PM_P_ShutDownModeShutDownWindows.Checked := True;
                                  PM_S_ShutDownModeShutDownWindows.Checked := True;
                               end;
  end;

  ResetShutDownCaptions;

  c := SecondsBetween(Now, NempOptions.ShutDownTime);
  if c <= 120 then
    SleepTimer.Interval := 250    // 0.25sek
  else
    SleepTimer.Interval := 10000; // 10sek

  SleepTimer.Enabled := True;
  SleepImage.Hint := GenerateSleepHint;

  ReArrangeToolImages;
end;


procedure TNemp_MainForm.ShutDown_EndofPlaylistClick(Sender: TObject);
begin
    NempOptions.ShutDownMode := ((Sender as TMenuItem).Tag) DIV 100;

    NempOptions.ShutDownAtEndOfPlaylist := True;

    case ((Sender as TMenuItem).Tag) Div 100 of
        SHUTDOWNMODE_StopNemp : begin
                                    MM_T_ShutDownModeStop.Checked := True;
                                    PM_P_ShutDownModeStop.Checked := True;
                                    PM_S_ShutDownModeStop.Checked := True;
                                end;
        SHUTDOWNMODE_ExitNemp  : begin
                                    MM_T_ShutdownModeCloseNemp.Checked := True;
                                    PM_P_ShutDownModeCloseNemp.Checked := True;
                                    PM_S_ShutDownModeCloseNemp.Checked := True;
                                 end;
        SHUTDOWNMODE_Suspend   : begin
                                   MM_T_ShutdownModeSuspend.Checked := True;
                                   PM_P_ShutDownModeSuspend.Checked := True;
                                   PM_S_ShutDownModeSuspend.Checked := True;
                                 end;
        SHUTDOWNMODE_Hibernate : begin
                                    MM_T_ShutdownModeHibernate.Checked := True;
                                    PM_P_ShutDownModeHibernate.Checked := True;
                                    PM_S_ShutDownModeHibernate.Checked := True;
                                 end;
        SHUTDOWNMODE_Shutdown  : begin
                                    MM_T_ShutdownModeShutDownWindows.Checked := True;
                                    PM_P_ShutDownModeShutDownWindows.Checked := True;
                                    PM_S_ShutDownModeShutDownWindows.Checked := True;
                                 end;
    end;

    ResetShutDownCaptions;
    ReArrangeToolImages;
    SleepImage.Hint := GenerateSleepHint;
end;

procedure TNemp_MainForm.InitShutDown;
begin
    ResetShutDownCaptions;
    NempOptions.ShutDownAtEndOfPlaylist := False;
    SleepTimer.Enabled := False;

    ReArrangeToolImages;

    // Laufende Aktionen Beenden
    MedienBib.Abort;
    ST_Playlist.Break;
    ST_Medienliste.Break;
    LangeAktionWeiterMachen := False;

    case NempOptions.ShutDownMode of
        SHUTDOWNMODE_StopNemp, // : NempPlayer.stop;
        SHUTDOWNMODE_ExitNemp, // : Close;
        SHUTDOWNMODE_Suspend,
        SHUTDOWNMODE_Hibernate,
        SHUTDOWNMODE_Shutdown: begin
                                  if not assigned(ShutDownForm) then
                                      Application.CreateForm(TShutDownForm, ShutDownForm);
                                  ShutDownForm.Showmodal;
                               end;
    end;
end;


procedure TNemp_MainForm.SleepTimerTimer(Sender: TObject);
var c: Integer;
begin
  c := SecondsBetween(Now, NempOptions.ShutDownTime);
  if (c <= 120) and (SleepTimer.Interval <> 250) then
    SleepTimer.Interval := 250;    // runtersetzen auf 250ms

  SleepImage.Hint := GenerateSleepHint;

  if c <= 0 then
      InitShutDown;
end;

procedure TNemp_MainForm.Schlafmodusdeaktivieren1Click(Sender: TObject);
begin
  SleepTimer.Enabled := False;
  NempOptions.ShutDownAtEndOfPlaylist := False;

  MM_T_ShutdownOff.Checked := True;
  PM_P_ShutdownOff.Checked := True;
  PM_S_ShutdownOff.Checked := True;

  ReArrangeToolImages;
end;

procedure TNemp_MainForm.LoadARecentPlaylist(Sender: TObject);
var idx: integer;
    restart: Boolean;
begin
  idx := (Sender as TMenuItem).Tag;
  if not idx in [1.. 10] then exit;

  if FileExists(NempOptions.RecentPlaylists[idx]) then
  begin
     restart := NempPlayer.Status = Player_ISPLAYING;//  (NempPlayer.BassStatus = BASS_ACTIVE_PLAYING);
     NempPlaylist.ClearPlaylist;
     NempPlaylist.LoadFromFile(NempOptions.RecentPlaylists[idx]);
     If restart then
     begin
        NempPlayer.LastUserWish := USER_WANT_PLAY;
        NempPlaylist.Play(0,0, True);
     end
  end else
      MessageDLG((Playlist_FileNotFound), mtWarning, [MBOK], 0);
end;

function TNemp_MainForm.AddFileToRecentList(NewFile: UnicodeString): boolean;
var i, newpos: integer;
begin
  newpos := 11;

  // schon drin?
  for i := 1 to 10 do
    if NempOptions.RecentPlaylists[i] = NewFile then
    begin
      result := False;
      exit;
    end;

  // noch nicht drin, also rein damit!
  result := True;

  // Einf�geposition suchen
  for i := 1 to 10 do
    if (NempOptions.RecentPlaylists[i] = '')  then
    begin
      newpos := i;
      break;
    end;

  // ggf. das erste l�schen, die anderen aufr�cken
  if newpos = 11 then
  begin
    for i := 1 to 9 do
      NempOptions.RecentPlaylists[i] := NempOptions.RecentPlaylists[i+1];
    NempOptions.RecentPlaylists[10] := '';
    NewPos := 10;
  end;
  // reinschreiben
  NempOptions.RecentPlaylists[newPos] := NewFile;
end;

Procedure TNemp_MainForm.SetRecentPlaylistsMenuItems;
var i: Integer;
  aMenuItem: TMenuItem;
begin                                                         
  // Recent Playlists initialisieren                          
  MM_PL_RecentPlaylists.Clear;
  PM_PL_RecentPlaylists.Clear;

    for i := 1 to 10 do
    begin
      if NempOptions.RecentPlaylists[i] <> '' then
      begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := LoadARecentPlaylist;
        aMenuItem.Caption := IntToStr(i) + ' - ' + NempOptions.RecentPlaylists[i];
        aMenuItem.Tag := i;
        MM_PL_RecentPlaylists.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := LoadARecentPlaylist;
        aMenuItem.Caption := IntToStr(i) + ' - ' + NempOptions.RecentPlaylists[i];
        aMenuItem.Tag := i;
        PM_PL_RecentPlaylists.Add(aMenuItem);
      end;
      if PM_PL_RecentPlaylists.Count = 0 then
      begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.Caption := (Playlist_NoRecentlists);
        aMenuItem.Enabled := False;
        MM_PL_RecentPlaylists.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.Caption := (Playlist_NoRecentlists);
        aMenuItem.Enabled := False;
        PM_PL_RecentPlaylists.Add(aMenuItem);
      end;
    end;
end;




procedure TNemp_MainForm.STStart(var Msg: TMessage);
begin
    Handle_STStart(Msg);
end;


procedure TNemp_MainForm.STNewFile(var Msg: TMessage);
begin
    Handle_STNewFile(Msg);
end;

procedure TNemp_MainForm.STFinish   (var Msg: TMessage);
begin
    Handle_STFinish(Msg);
end;

Function TNemp_MainForm.GeneratePlaylistSTFilter: string;
var i: integer;
begin
    result := '';
    if NempPlayer.ValidExtensions.Count = 0 then exit;
    result := '*' + NempPlayer.ValidExtensions[0];
    for i := 1  to NempPlayer.ValidExtensions.Count-1 do
        result := result + ';*' + NempPlayer.ValidExtensions[i];
end;

function TNemp_MainForm.GenerateMedienBibSTFilter: String;
var i: integer;
begin
    result := '';
    if MedienBib.IncludeAll then
    begin
        result := '*' + NempPlayer.ValidExtensions[0];
        for i := 1  to NempPlayer.ValidExtensions.Count-1 do
            result := result + ';*' + NempPlayer.ValidExtensions[i];
    end else
    begin
        if MedienBib.IncludeMP3 then result := '*.mp3';
        if MedienBib.IncludeOGG then result := result + ';*.ogg';
        if MedienBib.IncludeWAV then result := result + ';*.wav';
        if MedienBib.IncludeWMA then result := result + ';*.wma';
        if MedienBib.IncludeMP1 then result := result + ';*.mp1';
        if MedienBib.IncludeMP2 then result := result + ';*.mp2';

        if (result <> '') AND (result[1] = ';') then
            result := copy(result, 2, length(result));
    end;
    // Ja, das ist so richtig. In die Medienbib kommen Playlist-Dateien rein.
    // In die Playlist nicht.
    result := result + ';*.m3u;*.m3u8;*.pls;*.npl;*.asx;*.wax';
end;


procedure TNemp_MainForm.PlaylistVSTEnter(Sender: TObject);
begin
  AktiverTree := PlaylistVST;
end;


procedure TNemp_MainForm.VSTMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var aNode: PVirtualNode;
    i: integer;
begin
  // OnMouseMove on a Rating-Field, the Editing should start without
  // further action (like Click).
  // For this, the Edit of other Rating-Nodes should be cancelled first.

  aNode := VST.GetNodeAt(x,y);
  if assigned(aNode) then
  begin
      i := VST.Header.Columns.ColumnFromPosition(Point(x,y));

      if i > 0 then
      case VST.Header.Columns[i].Tag of
         CON_RATING: begin
              if not EditingVSTStrings then
              begin
                  EditingVSTStrings := False;
                  EditingVSTRating := True;
                  // Note to "LastVSTMouseOverNode"
                  // After leaving the ratings Control to the left, there is a small area
                  // where ColumnFormPosition will return the ratings-Column, so
                  // a new editing is started, but without fireing the CancelEdit-Event when
                  // moving further to the left (as the cursor is already outside the editor)
                  // So, if the Node has not Changed since last time, do not start editing again.
                  // Ok, With VST.Margin=0 not necessary.
                  if LastVSTMouseOverNode <> aNode then
                  begin
                      VST.CancelEditNode;
                      PostMessage(self.Handle, WM_STARTEDITING, Integer(aNode), i);
                   end;
                  LastVSTMouseOverNode := aNode;

              end;
         end;
      else
          begin
              LastVSTMouseOverNode := Nil;
              if EditingVSTRating then
              begin
                  VST.CancelEditNode;
                  EditingVSTRating := False;
                  EditingVSTStrings := False;
              end;
          end;
      end;
      // damit habe ich die Column/die ID, den Tag der Spalte
      // Wenn Spalte = Bewertung, dann Edit Starten
      // in diesem Edit: Bei MouseLeave CancelEdit ausl�sen
      // ansonsten: Data getten, bei Klick setzen. => Verhalten wie beim WMP
      // hoffentlich.
  end else
      // when mouse is over an empty area
      LastVSTMouseOverNode := Nil;
end;

procedure TNemp_MainForm.VSTEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  Data: PTreeData;
  af: tAudioFile;
begin
    Data := VST.GetNodeData(Node);
    if assigned(Data) then
        af := Data^.FAudioFile
    else
        af := Nil;

    if assigned(af) and (FileExists(af.Pfad)) then
    begin
        if MedienBib.StatusBibUpdate > 1 then
            // if the library is in the "hot phase" of an update: Do not allow edit
            // Note: We have to check this again in EndUpdate and NewText!
            allowed := false
        else
        begin
            // Set the Delete-Shortcut to 0, otherwise the DEL-Key wont work in Edit
            case VST.Header.Columns[column].Tag of
                CON_ARTIST,
                CON_TITEL,
                CON_ALBUM,
                CON_STANDARDCOMMENT,
                CON_YEAR,
                CON_GENRE,
                CON_TRACKNR,
                CON_RATING: begin
                        ClearShortCuts;
                        allowed := True;
                end;
            else
                {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
                CON_PFAD, CON_ORDNER, CON_DATEINAME, CON_LYRICSEXISTING }
                allowed := False;
            end;
        end;
    end
    else
        // File does not exist - no editing allowed
        allowed := False;
end;

procedure TNemp_MainForm.VSTCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
var aRect: TRect;
begin
    case VST.Header.Columns[column].Tag of
        CON_RATING: begin
              aRect := VST.GetDisplayRect(Node, Column, False, False);
              RatingGraphics.SetBackGround(VST.Canvas, aRect);
              EditLink := TRatingEditLink.Create;
              EditingVSTRating := True;
              EditingVSTRating := False;
        end
    else
        begin
            EditLink := TModStringEditLink.Create;
            EditingVSTRating := False;
            EditingVSTStrings := True;
        end;
    end;
end;

procedure TNemp_MainForm.VSTEditCancelled(Sender: TBaseVirtualTree;
  Column: TColumnIndex);
begin
    // PM_ML_HideSelected.ShortCut := 46;  // 46=Entf;
    SetShortCuts;
    EditingVSTRating := False;
    EditingVSTStrings := False;
end;

procedure TNemp_MainForm.VSTEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
var
  Data: PTreeData;
  af: tAudioFile;
begin
    //PM_ML_HideSelected.ShortCut := 46;    // 46=Entf;
    SetShortCuts;
    EditingVSTRating := False;
    EditingVSTStrings := False;
    MedienBib.Changed := True;

    Data := VST.GetNodeData(Node);
    if assigned(Data) then
        af := Data^.FAudioFile
    else
        af := Nil;

    if assigned(af) then
    begin
        // Set the rating also in copies of this file in the playlist.
        if VST.Header.Columns[column].Tag = CON_RATING then
            NempPlaylist.UnifyRating(af.Pfad, af.Rating);

        if MedienBib.StatusBibUpdate <= 1 then
        begin
            if af.Pfad <> MedienBib.CurrentThreadFilename then
            begin
                // Data of the af was set in VSTNewText or TRatingEditLink.EndEdit

                af.SetAudioData(SAD_BOTH);

                if AutoShowDetailsTMP and assigned(FDetails) then
                    FDetails.ReloadTimer.Enabled := True;
                    // Note: a call of AktualisiereDetailForm(af, SD_MEDIENBIB); here
                    //       will produce some strange AVs here - so we do it quick&dirty with a timer
            end
            else
                MessageDLG(Warning_MedienBibBusyThread, mtWarning, [mbOK], 0);
        end else
            MessageDLG(Warning_MedienBibIsBusyEdit, mtWarning, [mbOK], 0);
    end;
end;

procedure TNemp_MainForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PTreeData;
  af: tAudioFile;
begin
    Data := VST.GetNodeData(Node);
    if assigned(Data) then
        af := Data^.FAudioFile
    else
        af := Nil;

    if assigned(af) then
    begin
        if MedienBib.StatusBibUpdate <= 1 then
        begin
            if af.Pfad <> MedienBib.CurrentThreadFilename then
            begin
                MedienBib.Changed := True;
                case VST.Header.Columns[column].Tag of
                    CON_ARTIST : af.Artist := NewText;
                    CON_TITEL  : af.Titel := NewText;
                    CON_ALBUM  : af.Album := NewText;
                    CON_STANDARDCOMMENT : af.Comment := NewText;
                    CON_YEAR : af.Year := NewText;
                    CON_GENRE: af.Genre := NewText;
                    CON_TRACKNR: af.Track := StrToIntDef(NewText, 0);
                else
                    {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
                    CON_PFAD, CON_ORDNER, CON_DATEINAME, CON_LYRICSEXISTING }
                    // Nothing to do. Something was wrong ;-)
                end;
                // Note: Data will be written into the File in "VSTEdited"
                if Not MedienBib.ValidKeys(af) then
                    SetBrowseTabWarning(True);
            end
            else
                MessageDLG(Warning_MedienBibBusyThread, mtWarning, [mbOK], 0);
        end
        else
            MessageDLG(Warning_MedienBibIsBusyEdit, mtWarning, [mbOK], 0);
    end;
end;



procedure TNemp_MainForm.VSTEnter(Sender: TObject);
begin
  AktiverTree := VST;
end;



procedure TNemp_MainForm.RepairZOrder;
begin
  if (NempOptions.MiniNempStayOnTop) AND (AnzeigeMode = 1) then
  begin
    // Fenster in den Vordergrund setzen.
    SetWindowPos(Nemp_MainForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

    // ggf. das Detailfenster nach oben holen
    if assigned(FDetails) and FDetails.CB_StayOnTop.Checked then
      SetWindowPos(FDetails.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  end
  else
  begin
    // Jetzt die Hautform NICHT in den Vordergrund setzen
    SetWindowPos(Nemp_MainForm.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

    // ggf. das Detailfenster nach oben holen
    if assigned(FDetails) and FDetails.CB_StayOnTop.Checked then
      SetWindowPos(FDetails.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  end;

  if assigned(PlaylistForm) and PlaylistForm.Visible then
    SetForeGroundWindow(PlaylistForm.Handle);
  if assigned(MedienlisteForm) and MedienlisteForm.Visible then
    SetForeGroundWindow(MedienlisteForm.Handle);
  if assigned(AuswahlForm) and AuswahlForm.Visible then
    SetForeGroundWindow(AuswahlForm.Handle);
  SetForeGroundWindow(Handle);
end;

procedure TNemp_MainForm.ActualizeVDTCover;
begin
    VDTCover.Width := NempOptions.CoverWidth;
    case NempOptions.CoverMode of
        0: begin
          // aus
          Splitter4.Visible := False;
          VDTCover.Visible := False;
        end;
        1: begin
          // links
          VDTCover.Align := alLeft;
          Splitter4.Align := alLeft;
          Splitter4.Visible := True;
          VDTCover.Visible := True;
          Splitter4.Left := VDTCover.Width;
        end;
        2: begin
          // rechts
          Splitter4.Align := alRight;
          VDTCover.Align := alRight;

          Splitter4.Visible := True;
          VDTCover.Visible := True;
          Splitter4.Left := VST.Width;
          VDTCover.Left := VST.Width + Splitter4.Width;
        end;
    end;
end;


procedure TNemp_MainForm.PM_PL_PlaySelectedNextClick(
  Sender: TObject);
var Data: PTreeData;
begin
  NempPlaylist.GetInsertNodeFromPlayPosition;
  if assigned(PlaylistVST.FocusedNode) then
  begin
    Data := PlaylistVST.GetNodeData(PlaylistVST.FocusedNode);
    NempPlaylist.InsertFileToPlayList(Data^.FAudioFile.Pfad);
  end;
end;

procedure TNemp_MainForm.PanelPaint(Sender: TObject);
begin
    if (Sender as TNempPanel).Tag <= 3 then
        NempSkin.DrawAPanel((Sender as TNempPanel), NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag])
    else
        NempSkin.DrawAPanel((Sender as TNempPanel), True);
end;


procedure TNemp_MainForm.PanelCoverBrowsePaint(Sender: TObject);
begin
    NempSkin.DrawAPanel((Sender as TNempPanel), NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
    MedienBib.NewCoverFlow.Paint;
end;

procedure TNemp_MainForm.PanelCoverBrowseAfterPaint(Sender: TObject);
begin
    // The AfterPaint-Event is needed for the Coverflow.
    // On WindowsXP the Coverflow on the Panel will not be repainted automatically.
    if Not NempSkin.isActive then
        MedienBib.NewCoverFlow.Paint;
    // Otherwise the Paint-Event has been fired, where the Coverflow was already painted.
end;

(*
procedure TNemp_MainForm.GroupboxPaint(Sender: TObject);
begin
  NempSkin.DrawAGroupbox((Sender as TNempGroupbox), NempSkin.UseBackgroundImages[(Sender as TNempGroupbox).Tag]);
end;
*)

Procedure TNemp_MainForm.RepaintPanels;
//var i: integer;
begin
    PlayerPanel.Repaint;
    AudioPanel.Repaint;
    PlaylistPanel.Repaint;
    AuswahlPanel.Repaint;
    VSTPanel.Repaint;

    MedienlisteFillPanel.Repaint;
    AuswahlFillPanel.Repaint;
    PlaylistFillPanel.Repaint;

    AuswahlHeaderPanel.Repaint;
    MedienBibHeaderPanel.Repaint;
    PlayerHeaderPanel.Repaint;

(*  // I Dont have any NempGroupboxes any more...
    if NOT _IsThemeActive then
    begin
      for i := 0 to ComponentCount-1 do
        if Components[i] is TNempGroupbox then
          TNempGroupbox(Components[i]).Repaint;
    end;
*)
end;

Procedure TNemp_MainForm.RepaintPlayerPanel;
begin
  if NempSkin.isActive and NOT Nempskin.FixedBackGround then
  begin
    PlayerPanel.Repaint;
    if NOT _IsThemeActive then
    begin
      NewPlayerPanel.Repaint;
      GRPBOXLyrics.Repaint;
      GRPBOXEffekte.Repaint;
      GRPBOXEqualizer.Repaint;
      GRPBOXCover.Repaint;
    end;
  end;
end;

Procedure TNemp_MainForm.RepaintOtherForms;
begin
  if PlaylistForm.Visible then PlaylistForm.Repaint;
  if MedienlisteForm.Visible then MedienlisteForm.Repaint;
  if AuswahlForm.Visible then AuswahlForm.Repaint;
  if ExtendedControlForm.Visible then ExtendedControlForm.Repaint;
end;

procedure TNemp_MainForm.RepaintAll;
var i: integer;
begin
  for i := 0 to ComponentCount-1 do
  begin
    if Components[i] is TWinControl then
      TWinControl(Components[i]).Repaint;
  end;
end;

Procedure TNemp_MainForm.RepaintVisOnPause;
begin
  // Zeichnet beim Verschieben des Fensters das Spectrum neu,
  // wenn das nciht durch den Timer automatisch gemacht w�rde.
  // Zeit und Spectrum-Informationen k�nnen nicht wieder gezeichnet werden.
  if (Not BassTimer.Enabled)
  OR (NOT NempPlayer.UseVisualization)
  OR (NempPlayer.BassStatus <> BASS_ACTIVE_PLAYING)
  then
  begin
        Spectrum.DrawClear;
        Spectrum.DrawText(Spectrum.TextString,False);
        Spectrum.DrawTime(Spectrum.TimeString);
  end;
end;


procedure TNemp_MainForm.TABPanelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
  aPanel := (Sender as TNempPanel);
  NempSkin.DrawAPanel(aPanel);
  aPanel.Canvas.Brush.Style := bsclear;
  aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
  begin
    aPanel.Canvas.Pen.Width := 1;
    aPanel.Canvas.Pen.Style := psSolid;
    aPanel.Canvas.RoundRect(0,0, aPanel.Width, aPanel.Height, 6, 6);
  //  Polyline([Point(1,1), Point(1,aPanel.Height-2), Point(aPanel.Width - 2, aPanel.Height - 2), Point(aPanel.Width - 2,1), Point(1,1)]);
  end;
end;

procedure TNemp_MainForm.NewPanelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
  aPanel := (Sender as TNempPanel);
  NempSkin.DrawAPanel(aPanel);

  aPanel.Canvas.Brush.Style := bsclear;
  aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
  aPanel.Canvas.Pen.Width := 1;
  aPanel.Canvas.Pen.Style := psSolid;
  aPanel.Canvas.RoundRect(0,0, aPanel.Width-0, aPanel.Height-0, 6, 6);
end;


procedure TNemp_MainForm.AktualisiereDetailForm(aAudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
begin
  if AutoShowDetailsTMP then
  begin
    if not assigned(FDetails) then
      Application.CreateForm(TFDetails, FDetails);
    FDetails.ShowDetails(aAudioFile, Source);
  end;
end;


procedure TNemp_MainForm.TNAMenuPopup(Sender: TObject);
var i: Integer;
  centerIdx, minIdx, maxIdx: Integer;
  aMenuItem: TMenuItem;
begin
  // altes Menu mit Playlist-Eintr�gen erstellen und neues erstellen
  for i := PM_TNA_Playlist.Count - 1 downto 0 do
    PM_TNA_Playlist.Delete(i);
  if assigned(NempPlaylist.Playlist) then
  begin
    centerIdx := NempPlaylist.PlayingIndex;

    // min Idx Count.halbe vor dem aktuellen Lied
    minIdx := centerIdx - (NempPlaylist.TNA_PlaylistCount DIV 2);
    // ggf. auf 0 korrigieren
    if MinIDX < 0 then MinIdx := 0;

    // maxIdx Count mehr
    maxIdx := minIdx + NempPlaylist.TNA_PlaylistCount;
    if MaxIdx > NempPlaylist.Count - 1 then MaxIdx := NempPlaylist.Count - 1;

    // ggf. den minIdx korrigieren, so dass immer count Eintr�ge da sind
    minIdx := maxIdx - NempPlaylist.TNA_PlaylistCount;
    if minIdx < 0 then minIdx := 0;

    for i := MinIdx to MaxIdx do
    begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.RadioItem := True;
        aMenuItem.AutoCheck := True;
        aMenuItem.Checked := (i=centerIdx) AND assigned(NempPlaylist.Playingfile);
        aMenuItem.OnClick := TNA_PlaylistClick;
        aMenuItem.Tag := i;
        aMenuItem.Caption := EscapeAmpersAnd(  TPlaylistFile(NempPlaylist.Playlist[i]).PlaylistTitle);
        PM_TNA_Playlist.Add(aMenuItem);
    end;
  end;
end;

procedure TNemp_MainForm.ReInitPlayerVCL;
var tmp: Boolean;
begin
  // Richtungsbutton bei den Effekten neu setzen
  if NempPlayer.MainStreamIsReverseStream then
  begin
    DirectionPositionBTN.GlyphLine := 1;
    DirectionPositionBTN.Tag := 1;
    DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayNormal);
  end else
  begin
    DirectionPositionBTN.GlyphLine := 0;
    DirectionPositionBTN.Tag := 0;
    DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayReverse);
  end;

  //Einige Buttons dis/enablen, je nachdem ob ne URL grade im Player l�uft
  tmp := not NempPlayer.URLStream;
  SlideBackBTN.Enabled := tmp;
  SlideForwardBtn.Enabled := tmp;
  SlideBarShape.Enabled := tmp;
  SlidebarButton.Enabled := tmp;
  // Geschwindigkeit disablen, das macht bei Streams keinen Sinn
  EffekteLBL3.Enabled := tmp;
  SampleRateLBL.Enabled := tmp;
  SamplerateShape.Enabled := tmp;
  SampleRateButton.Enabled := tmp;
  // R�ckw�rtsspielen disablen
  DirectionPositionBTN.Enabled := tmp;
  //PosRewindCB.Enabled := tmp;
  //EffekteLBL4.Enabled := tmp;

  // Anzeigen im Mittelteil:
  if NempPlayer.MainStream = 0 then
  begin
    Application.Title := NEMP_NAME_TASK;
    NempTrayIcon.Hint := 'Nemp - Noch ein mp3-Player';

    // Coveranzeige
    CoverIMage.Visible := False;
    LyricsMemo.Text := (MainForm_Lyrics_NoLyrics);

    Spectrum.DrawRating(0);
  end else
  begin
      NempPlayer.RefreshPlayingTitel;
      Application.Title := NempPlayer.GenerateTaskbarTitel;
      Spectrum.DrawRating(NempPlayer.MainAudioFile.Rating);
      if NempPlayer.URLStream then
      begin
        NempTrayIcon.Hint := StringReplace(NempPlayer.MainAudioFile.Titel, '&', '&&&', [rfReplaceAll]);
        LyricsMemo.Text := (MainForm_Lyrics_NoLyrics);
      end else
      begin
        Spectrum.DrawText(NempPlayer.PlayingTitel,False);
        TextAnzeigeIMAGE.Refresh;
      end;
      ShowPlayerDetails(NempPlayer.MainAudioFile);
  end;
end;



procedure TNemp_MainForm.BirthdayTimerTimer(Sender: TObject);
var timeleft: Integer;
begin
  timeleft := SecondsUntil(NempPlayer.NempBirthdayTimer.StartCountDownTime);
  if timeleft > 120 then
    BirthdayTimer.Interval := 60000
  else
    BirthdayTimer.Interval := 1000;

  BirthdayImage.Hint := Format((BirthdayCountDown_Hint),  [SekToZeitString(timeleft, true)] );

  if timeleft <= 0 then
  begin
    NempPlayer.pause;
    if Not Assigned(BirthdayForm) then
        Application.CreateForm(TBirthdayForm, BirthdayForm);
    BirthdayForm.Show;
    BirthdayTimer.Enabled := False;
    ReArrangeToolImages;
  end;
end;

procedure TNemp_MainForm.MenuBirthdayAusClick(Sender: TObject);
begin
  BirthdayTimer.Enabled := False;
  if assigned(BirthdayForm) then
    BirthdayForm.Close;

  ReArrangeToolImages;
end;

procedure TNemp_MainForm.MenuBirthdayStartClick(Sender: TObject);
var timeleft: Integer;
begin
  // Einstellungen lesen
  NempPlayer.ReadBirthdayOptions(SavePath + NEMP_NAME + '.ini');

  if Not NempPlayer.CheckBirthdaySettings then
      begin
        if MessageDLG((BirthdaySettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
          if Not Assigned(OptionsCompleteForm) then
            Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
          OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.BirthdayNode;
          OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.BirthdayNode] := True;
          OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio7;
          OptionsCompleteForm.Show;
        end;
        exit;
      end;

  timeleft := SecondsUntil(NempPlayer.NempBirthdayTimer.StartCountDownTime);
  if timeleft > 120 then
    Nemp_MainForm.BirthdayTimer.Interval := 60000
  else
    Nemp_MainForm.BirthdayTimer.Interval := 1000;

  Nemp_MainForm.BirthdayTimer.Enabled := True;

  ReArrangeToolImages;
  BirthdayImage.Hint := Format((BirthdayCountDown_Hint),  [SekToZeitString(timeleft, true)] );
end;

procedure TNemp_MainForm.VolTimerTimer(Sender: TObject);
begin
  NempPlayer.VolStep := 0;
  VolTimer.Enabled := False;
end;

procedure TNemp_MainForm.PutDirListInAutoScanList(aDirList: TStringList);
var asknomore: Boolean;
    i, dlgresult: Integer;
begin
  if MedienBib.JobListContainsNewDirs(aDirList) then
  begin
    // Bei Bedarf nachfragen, was mit den Ordern passieren soll
    if MedienBib.AskForAutoAddNewDirs then
    begin
        asknomore := Not MedienBib.AskForAutoAddNewDirs;
        dlgresult := MessageDlgWithNoMorebox
              ((AutoScanDirsDialog_Caption),
               (AutoScanDirsDialog_Text),
               mtConfirmation, [mbYes, mbNo], 0, 0, asknomore,
              (AutoScanDirsDialog_ShowAgain));

        MedienBib.AutoAddNewDirs := dlgresult = mrYes;
        MedienBib.AskForAutoAddNewDirs := not asknomore;
    end;

    if MedienBib.AutoAddNewDirs then
    begin
       for i := 0 to aDirList.Count - 1 do
       begin
          if MedienBib.ScanListContainsParentDir(aDirList.Strings[i]) <> '' then
             // noting - ein Parentordner ist schon drin in der Liste
          else
          begin
            // parentdir noch nicht drin.
            // �berpr�fen auf SubDirs und diese entfernen
            MedienBib.ScanListContainsSubDirs(aDirList.Strings[i]);
            // Aktuellen Ordner einf�gen
            MedienBib.AutoScanDirList.Add(IncludeTrailingPathDelimiter(aDirList.Strings[i]));
          end;
       end;
    end;
  end; // if JobListContainsNewDirs
end;


procedure TNemp_MainForm.VSTPanelResize(Sender: TObject);
begin
  if VSTPanel.Parent <> Nemp_MainForm then
  begin
      if VSTPanel.Width <= 320 then
      begin
        EDITFastSearch.Width := 194 - (320 - VSTPanel.Width);
        CB_MedienBibGlobalQuickSearch.Left := EditFastSearch.Left + EditFastSearch.Width - 17;
      end else
      begin
        EditFastSearch.Width := 194;
        CB_MedienBibGlobalQuickSearch.Left := 209;
      end;
      MedienlisteFillPanel.Left := EditFastSearch.Left + EditFastSearch.Width + 6;
      MedienlisteFillPanel.Width := VSTPanel.Width - MedienlisteFillPanel.Left - 16;
  end else
  begin
      MedienlisteFillPanel.Left := EditFastSearch.Left + EditFastSearch.Width + 6;
      MedienlisteFillPanel.Width := VSTPanel.Width - MedienlisteFillPanel.Left;// - 8;
  end;
  MedienListeStatusLBL.Width := MedienlisteFillPanel.Width - 16;
end;

procedure TNemp_MainForm.PlaylistPanelResize(Sender: TObject);
begin
  PlayListStatusLBL.Width := PlaylistFillPanel.Width - 16;
end;


procedure TNemp_MainForm.MitzuflligenEintrgenausderMedienbibliothekfllen1Click(
  Sender: TObject);
begin
  if Not Assigned(RandomPlaylistForm) then
        Application.CreateForm(TRandomPlaylistForm, RandomPlaylistForm);
  RandomPlaylistForm.ShowModal;
end;

// Sinn dieses Timers:
// Wenn im Explorer mehrere Dateien markiert werden, und die Funktion "In Nemp abspielen"
// gew�hlt wird, wird die Playlist f�r jede Datei neu gel�scht. das ist erstens nicht unbedingt
// sinnvoll, und zweitens kommt da irgendwas mit irgendwem durcheinander (die Anzahl der Dateien, die
// am Ende in der Playlist sind, ist irgendwie nicht vorhersehbar...???).
// So wird das L�schen der Playlist f�r einen gewissen Zeitraum verhindert, und alle markierten Dateien
// werden in die Playlist eingef�gt.

procedure TNemp_MainForm.ReallyClearPlaylistTimerTimer(Sender: TObject);
begin
  NempPlaylist.ProcessBufferStringlist;

  ReallyClearPlaylistTimer.Enabled := False;
end;

procedure TNemp_MainForm.RecordBtnIMGClick(Sender: TObject);
begin
  if Not NempPlayer.StreamRecording then
  begin
      // Aufnahme starten
      if NempPlayer.StartRecording then
      begin
            // Aufnahme-Beginn erfolgreich
            RecordBtn.GlyphLine := 1;
            RecordBtn.Hint := (MainForm_RecordBtnHint_Recording);
      end else
      begin
            // Aufnahme-Beginn nicht erfolgreich
            RecordBtn.GlyphLine := 0;
            RecordBtn.Hint := (MainForm_RecordBtnHint_Start);
      end;
  end else
  begin
      // Aufnahme beenden;
      NempPlayer.StopRecording;
      RecordBtn.GlyphLine := 0;
      RecordBtn.Hint := (MainForm_RecordBtnHint_Start);
  end;
  RecordBtn.Refresh;
end;

procedure TNemp_MainForm.CoverScrollbarChange(Sender: TObject);
var aCover: tNempCover;
begin


    if CoverScrollbar.Position <= MedienBib.Coverlist.Count -1 then
    begin

        MedienBib.NewCoverFlow.CurrentItem := CoverScrollbar.Position;

        aCover := TNempCover(MedienBib.CoverList[CoverScrollbar.Position]);
        MedienBib.GenerateAnzeigeListeFromCoverID(aCover.ID);

        Lbl_CoverFlow.Caption := aCover.InfoString;
    end;
end;

procedure TNemp_MainForm.ImgScrollCoverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MedienBib.NewCoverFlow.SelectItemAt(x,y);
  CoverScrollBar.OnChange := Nil;
  CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
  CoverScrollbar.OnChange := CoverScrollbarChange;
  CoverScrollbar.SetFocus;

end;



procedure TNemp_MainForm.PanelCoverBrowseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    MedienBib.NewCoverFlow.SelectItemAt(x,y);
//    CoverScrollBar.OnChange := Nil;
//    CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
//    CoverScrollbar.OnChange := CoverScrollbarChange;
    CoverImgDownX := X;
    CoverImgDownY := Y;
    CoverScrollbar.SetFocus;
end;

procedure TNemp_MainForm.PanelCoverBrowseResize(Sender: TObject);
begin
  if PanelCoverBrowse.Visible then
      MedienBib.NewCoverFlow.Paint;
      //RefreshScrollCover(CoverScrollbar.Position);
end;

procedure IncrementalTimerFire(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); pascal;
begin
    // Prefix zur�cksetzen
    Nemp_MainForm.SelectionPrefix := '';
end;

procedure TNemp_MainForm.CoverScrollbarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Newindex, ActualIndex: Integer;
    tempC       : array [1..2] of AnsiChar;
    keystate    : TKeyboardState;

begin
  if ssctrl in Shift then exit;
  case key of
    $41..$5A, $30..$39,32,
    $BA..$C0, $DB..$DE, $E2:
    begin
      //if not Assigned(aTree.FocusedNode) then Exit;
      // SuchPrefix erweitern
      GetKeyboardState(keystate);
      if ToAscii(Key, MapVirtualKey(key, 0), keyState, @tempC[1], 0) > 0 then
          SelectionPrefix := SelectionPrefix + Char(tempC[1]);

      // Das OldSelectionPrefix wird zur Suche mit F3 benutzt.
      // das SelectionPrefix wird bei OnTimer sinnigerweise auf '' gesetzt
      OldSelectionPrefix := SelectionPrefix;

      ActualIndex := CoverScrollbar.Position;
      Newindex := MedienBib.GetCoverWithPrefix(SelectionPrefix, ActualIndex);
      CoverScrollbar.Position := NewIndex;

      // Timer neustarten
      TimeKillEvent(IncrementalTimerID);
      IncrementalTimerID := TimeSetEvent(1000, 50, @IncrementalTimerFire, 0, TIME_ONESHOT);
    end;
    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      ActualIndex := CoverScrollbar.Position;
      Newindex := MedienBib.GetCoverWithPrefix(OldSelectionPrefix, (ActualIndex + 1) Mod MedienBib.Coverlist.Count);
      CoverScrollbar.Position := NewIndex;
    end;
  end;
end;



procedure TNemp_MainForm.IMGMedienBibCoverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CoverImgDownX := X;
  CoverImgDownY := Y;
  CoverScrollbar.SetFocus;
end;

procedure TNemp_MainForm.IMGMedienBibCoverMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var i:integer;
  DateiListe: TObjectlist;
begin
  if ssleft in shift then
  begin
    if (abs(X - CoverImgDownX) > 5) or  (abs(Y - CoverImgDownY) > 5) then
    begin
    //showmessage( inttostr(abs(X - CoverImgDownX)) + '----' + inttostr(abs(Y - CoverImgDownY)) );
        Dateiliste := TObjectlist.Create(False);
        GenerateListForHandleFiles(DateiListe, 3);
        DragSource := DS_VST;
        with DragFilesSrc1 do
        begin
            // Add files selected to DragFilesSrc1 list
            ClearFiles;
            DragDropList.Clear;
            if DateiListe.Count > 500 then
            begin
              //MessageDlg(MESSAGE_TOO_MANY_FILES, mtInformation, [MBOK], 0);
              FreeAndNil(Dateiliste);
              exit;
            end;
            for i:=0 to DateiListe.Count - 1 do
            begin
                AddFile((Dateiliste[i] as TAudiofile).Pfad);
                DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad);
            end;
            // This is the START of the drag (FROM) operation.
            Execute;
        end;
        if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
        FreeAndNil(Dateiliste);
    end;
  end
  else
  begin
    CoverImgDownX := 0;
    CoverImgDownY := 0;
  end;
end;

procedure TNemp_MainForm.IMGMedienBibCoverMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CoverImgDownX := 0;
  CoverImgDownY := 0;
end;


procedure TNemp_MainForm.Lbl_CoverFlowMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CoverScrollbar.SetFocus;
end;

procedure TNemp_MainForm.SkinEditorstarten1Click(Sender: TObject);
begin
  //if not assigned(SkinEditorForm) then
  //  Application.CreateForm(TSkinEditorForm, SkinEditorForm);
  //SkinEditorForm.show;
  MessageDlg('SkinEditor removed from Nemp.exe. Separate SkinEditor is not implemented yet!', mtError, [mbOK], 0);
end;

procedure TNemp_MainForm.WindowsStandardClick(Sender: TObject);
begin
  NempSkin.DeActivateSkin;
  UseSkin := False;
  RePaintPanels;
  RepaintOtherForms;

  RepaintAll;

end;

procedure TNemp_MainForm.PM_P_BirthdayOptionsClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
    Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.BirthdayNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.BirthdayNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio7;
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.TabPanelPlaylistClick(Sender: TObject);
var point: TPoint;
//a: TAudiofile;
// aDrive: TDrive;
begin
// Note: I Use this EventHandler testing several things
// commented code is just temporary here. ;-)
//   a.GenerateCSVString;
 //  aDrive := TDrive.Create;
 //  aDrive.GetInfo('E:\');
 //  Showmessage(aDrive.Name + #13#10 + IntToStr(aDrive.SerialNr));
//   exit;
//CloudViewer.SetFocus;
  GetCursorPos(Point);
  PlayListPOPUP.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.PM_P_DirectoriesRecordingsClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(NempPlayer.DownloadDir)) then
        ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+NempPlayer.DownloadDir+'"'), '', sw_ShowNormal)
  else
        MessageDLG((Warning_RecordingDirNotFound), mtWarning, [mbOk], 0);
end;

procedure TNemp_MainForm.PM_P_DirectoriesDataClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(SavePath)) then
      ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+SavePath+'"'), '', sw_ShowNormal)
  else
      MessageDLG((Warning_DataDirNotFound), mtWarning, [mbOk], 0);
end;


procedure TNemp_MainForm.ChangeLanguage(Sender: TObject);
var l: Integer;
    newLanguage: string;
begin
    try
      l := (Sender as tComponent).Tag;
    except
      l := -1;
    end;

    Case l of
      -1: newLanguage := 'en';
      else begin
          if l <= LanguageList.Count -1 then
            newLanguage := LanguageList[l]
          else
            newLanguage := 'en';
          end;
    end;
    NempOptions.Language := newLanguage; 
    ReTranslateNemp(newLanguage);
end;




procedure TNemp_MainForm.VST_ColumnPopupOnClick(Sender: TObject);
var s: Integer;
begin
    if Sender is TMenuItem then
    begin
        s := (Sender as TMenuItem).Tag;
        if (Sender as TMenuItem).Checked then
          Nemp_MainForm.VST.Header.Columns[s].Options := Nemp_MainForm.VST.Header.Columns[s].Options + [coVisible]
        else
          Nemp_MainForm.VST.Header.Columns[s].Options := Nemp_MainForm.VST.Header.Columns[s].Options - [coVisible];
    end;
end;

procedure TNemp_MainForm.VST_ColumnPopupCoverOnClick(Sender: TObject);
begin
    if (Sender is TMenuItem) then
    begin
        NempOptions.CoverMode := (Sender as TMenuItem).Tag;
        ActualizeVDTCover;
    end;
end;

procedure TNemp_MainForm.VST_ColumnPopupPopup(Sender: TObject);
var i: Integer;
begin
    for i := 0 to VST_ColumnPopup.Items.Count - 3 do
    begin
        VST_ColumnPopup.Items[i].Checked :=
                coVisible in Nemp_MainForm.VST.Header.Columns[VST_ColumnPopup.Items[i].Tag].Options;
    end;
    case NempOptions.CoverMode of
      0: VST_ColumnPopupCoverOff.Checked := True;
      1: VST_ColumnPopupCoverLeft.Checked := True;
      2: VST_ColumnPopupCoverRight.Checked := True;
    end;
end;
                (*
procedure TNemp_MainForm.VDTCoverDrawNode(Sender: TBaseVirtualTree;
  const PaintInfo: TVTPaintInfo);
var data: PCoverTreeData;
    x: Integer;
    xfactor, yfactor: Single;
    NewWidth, NewHeight: Integer;
begin
  with Sender as TVirtualDrawTree, PaintInfo do
  begin
      Data := Sender.GetNodeData(Node);
      if Assigned(Data.Image) then
      begin
          xfactor:= (ContentRect.Right-ContentRect.Left) / Data.Image.Width;
          yfactor:= (ContentRect.Bottom-ContentRect.Top) / Data.Image.Height;
          if xfactor > yfactor then
          begin
              NewWidth := round(Data.Image.Width * yfactor);
              NewHeight := round(Data.Image.Height * yfactor);
          end else
          begin
              NewWidth := round(Data.Image.Width * xfactor);
              NewHeight := round(Data.Image.Height * xfactor);
          end;
          X := ContentRect.Left + (VDTCover.Header.Columns[0].Width - NewWidth) div 2;

          SetStretchBltMode(Canvas.Handle, HALFTONE);
          StretchBlt(Canvas.Handle,
                     X, ContentRect.Top + 2,
                     NewWidth, NewHeight,
                     Data.Image.Canvas.Handle,
                     0,0,
                     Data.Image.Width, Data.Image.Height,
                     SRCCopy);
      end;
  end;
end;

procedure TNemp_MainForm.VDTCoverFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var CoverData: PCoverTreeData;

begin
  CoverData := VDTCover.GetNodeData(Node);
  if assigned(CoverData) then
    FreeAndNil(CoverData.Image);
end;

procedure TNemp_MainForm.VDTCoverAdvancedHeaderDraw(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; const Elements: THeaderPaintElements);
begin
  with PaintInfo do
  begin
    // First check the column member. If it is NoColumn then it's about the header background.
    if Column = nil then
    begin
      if hpeBackground in Elements then
      begin
        TargetCanvas.Brush.Color := NempSkin.SkinColorScheme.Tree_HeaderBackgroundColor[4];
        TargetCanvas.FillRect(PaintRectangle);
      end;
    end else
    begin
        TargetCanvas.Brush.Color := NempSkin.SkinColorScheme.Tree_HeaderBackgroundColor[4];
        TargetCanvas.FillRect(PaintRectangle);
        TargetCanvas.Pen.Color :=  NempSkin.SkinColorScheme.Tree_BorderColor[4];
        TargetCanvas.MoveTo(PaintRectangle.Right-1, PaintRectangle.Top+1);
        TargetCanvas.LineTo(PaintRectangle.Right-1, PaintRectangle.Bottom-1);
    end;
  end;
end;





procedure TNemp_MainForm.VDTCoverResize(Sender: TObject);
var h: Cardinal;
    aNode: PVirtualNode;
begin
  VDTCover.Header.Columns[0].Width := VDTCover.Width  - 4;

  if VDTCover.Height - Integer(VDTCover.Header.Height) < 240 then
      h := VDTCover.Height - Integer(VDTCover.Header.Height)
  else
      h := 240;

  aNode := VDTCover.GetFirst;
  if assigned(aNode) then
      aNode.NodeHeight := h;
end;

*)

procedure TNemp_MainForm.VSTHeaderDrawQueryElements(Sender: TVTHeader;
  var PaintInfo: THeaderPaintInfo; var Elements: THeaderPaintElements);
begin
   with PaintInfo do
  begin
    // First check the column member. If it is NoColumn then it's about the header background.
    if Column = nil then
      Elements := [hpeBackground] // No other flag is recognized for the header background.
    else
    begin
      // Using the index here ensures a column, regardless of its position, always has the same draw style.
      // By using the Position member, we could make a certain column place stand out, regardless of the column order.
      // Don't forget to change the AdvancedHeaderDraw event body accordingly after you changed the indicator here.
      //case Column.Index of
      //  0: // Default drawing.
      //    ;
      //  1: // Background only customization.
      Include(Elements, hpeBackground);
      //  2: // Full customization (well, quite).
      //    Elements := [hpeBackground, hpeText{, hpeDropMark, hpeHeaderGlyph, hpeSortGlyph}];
      //end;
    end;
  end;
end;

procedure TNemp_MainForm.Splitter4CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := (NewSize <= 600) And (NewSize >= 130);
end;



procedure TNemp_MainForm.AlbenVSTClick(Sender: TObject);
begin
    AlbenVSTFocusChanged(AlbenVST, AlbenVST.FocusedNode, 0);
end;

procedure TNemp_MainForm.ArtistsVSTClick(Sender: TObject);
begin
    ArtistsVSTFocusChanged(ArtistsVST, ArtistsVST.FocusedNode, 0);
end;


procedure TNemp_MainForm.dwTaskbarThumbnails1ThumbnailClick(
  Sender: TdwTaskbarThumbnailItem);
begin
    case (Sender as TdwTaskbarThumbnailItem).Tag of
      0: PlayPrevBTNIMGClick(Nil);
      1: PlayPauseBTNIMGClick(Nil);
      2: StopBTNIMGClick(Nil);
      3: PlayNextBTNIMGClick(NIL);
    end;
end;


procedure TNemp_MainForm.MM_H_CheckForUpdatesClick(Sender: TObject);
begin
    NempUpdater.CheckForUpdatesManually;
end;

procedure TNemp_MainForm.VolButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    vk_up, vk_Right:  begin
                        VolTimer.Enabled := False;
                        NempPlayer.VolStep := NempPlayer.VolStep + 1;
                        NempPlayer.Volume := NempPlayer.Volume + 1 + (NempPlayer.VolStep DIV 3);
                        VolTimer.Enabled := True;
                        CorrectVolButton;
                     end;
    vk_Down, vk_Left: begin
                        VolTimer.Enabled := False;
                        NempPlayer.VolStep := NempPlayer.VolStep + 1;
                        NempPlayer.Volume := NempPlayer.Volume - 1 - (NempPlayer.VolStep DIV 3);
                        VolTimer.Enabled := True;
                        CorrectVolButton;
                       end;
  end;
end;

procedure TNemp_MainForm.SlideBarButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    vk_up, vk_Right: NempPlaylist.Time := NempPlaylist.Time + 5;
    vk_Down, vk_Left: NempPlaylist.Time := NempPlaylist.Time - 5;
  end;
end;

procedure TNemp_MainForm.TabBtn_PreselectionClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Medialist_PopupMenu.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.TabBtn_CoverMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    (Sender as TSkinbutton).ResetGlyph;
end;

procedure TNemp_MainForm.PM_P_ScrobblerActivateClick(Sender: TObject);
begin
    if (NempPlayer.NempScrobbler.Username = '') or (NempPlayer.NempScrobbler.SessionKey = '') then
    begin
        if MessageDLG((ScrobbleSettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
            if Not Assigned(OptionsCompleteForm) then
                Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
            OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio9;
            OptionsCompleteForm.Show;
        end;
        exit;
    end;

    // Scrobbeln beginnen
    if not NempPlayer.NempScrobbler.DoScrobble then
    begin
        NempPlayer.NempScrobbler.DoScrobble := True;
        if assigned(OptionsCompleteForm) and (OptionsCompleteForm.Visible) then
        begin
            OptionsCompleteForm.CB_ScrobbleThisSession.Checked := True;
            OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_Inactive;
        end;
        if assigned(NempPlayer.MainAudioFile) and (NempPlayer.Status = PLAYER_ISPLAYING) then
        begin
            // nur neu Scrobbeln, wenn es vorher nicht getan wurde.
            // Sonst wird der Zeitz�hler zur�ckgesetzt, und Submitten ggf. unterbunden
            if not NempPlayer.MainAudioFile.IsStream then
            begin
                NempPlayer.NempScrobbler.ChangeCurrentPlayingFile(NempPlayer.MainAudioFile);
                NempPlayer.NempScrobbler.PlaybackStarted;
            end;
        end;
    end;
    ReArrangeToolImages;
end;

procedure TNemp_MainForm.PM_P_ScrobblerDeactivateClick(Sender: TObject);
begin
    NempPlayer.NempScrobbler.DoScrobble := False;
    if assigned(OptionsCompleteForm) and (OptionsCompleteForm.Visible) then
    begin
        OptionsCompleteForm.CB_ScrobbleThisSession.Checked := False;
        OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_Offline;
    end;
    ReArrangeToolImages;
end;

procedure TNemp_MainForm.PM_P_ScrobblerOptionsClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
      Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio9;
  OptionsCompleteForm.Show;
end;

procedure TNemp_MainForm.ScrobblerImageClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  ScrobblerPopup.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.SleepImageClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  SleepPopup.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.WebserverImageClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  WebServerPopup.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.BirthdayImageClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  BirthdayPopup.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.MM_T_WebServerActivateClick(Sender: TObject);
begin
    if not NempWebServer.Active then
    begin
        // Server aktivieren
        // 1. Einstellungen laden
        NempWebServer.LoadfromIni;
        // 2.) Medialib kopieren
        NempWebServer.CopyLibrary(MedienBib);
        NempWebServer.Active := True;
        // Control: Is it Active now?
        if NempWebServer.Active  then
        begin
            // Ok, Activation complete
            ReArrangeToolImages;
            // Save current settings
            // NempWebServer.SaveToIni; No, we have just loaded them
            // Anzeige setzen
            if assigned(OptionsCompleteForm) then
                with OptionsCompleteForm do
                begin
                    BtnServerActivate.Caption := WebServer_DeActivateServer;
                    EdtUsername.Enabled := False;
                    EdtPassword.Enabled := False;
                end;
        end else
        begin
            // OOps, an error occured
            MessageDLG('Server activation failed:' + #13#10 + NempWebServer.LastErrorString, mtError, [mbOK], 0);
        end;
    end
end;

procedure TNemp_MainForm.MM_T_WebServerDeactivateClick(Sender: TObject);
begin
    if NempWebServer.Active then
    begin
        // Server deaktivieren
        NempWebServer.Active := False;
        // Anzeige setzen
        if assigned(OptionsCompleteForm) then
            with OptionsCompleteForm do
            begin
                BtnServerActivate.Caption := WebServer_ActivateServer;
                EdtUsername.Enabled := True;
                EdtPassword.Enabled := True;
                //BtnUpdateAuth.Enabled := True;
                //LogMemo.Lines.Add(DateTimeToStr(Now, LocalFormatSettings) + ', Server shutdown.');
            end;
            ReArrangeToolImages;
    end;
end;

procedure TNemp_MainForm.MM_T_WebServerOptionsClick(Sender: TObject);
begin
    if Not Assigned(OptionsCompleteForm) then
        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.WebServerNode;
    OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.WebServerNode] := True;
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio10;
    OptionsCompleteForm.Show;
end;


end.
