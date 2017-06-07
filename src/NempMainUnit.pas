{

    Unit NempMainUnit
    Form Nemp_MainForm

    The MainForm of Nemp

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


Unit NempMainUnit;

{$I xe.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NempAudioFiles, AudioFileHelper, ComCtrls, Grids, Contnrs, ShellApi,
  Menus, ImgList, ExtCtrls, StrUtils, Inifiles, CheckLst, //madexcept,
  Buttons,  VirtualTrees, VSTEditControls,
  jpeg, activeX, XPMan, DateUtils, cddaUtils, MyDialogs,
   Mp3FileUtils, spectrum_vis,
  Hilfsfunktionen, Systemhelper, CoverHelper, TreeHelper ,
  ComObj, ShlObj, clipbrd, Spin,  U_CharCode,
      fldbrows, MainFormHelper, MessageHelper, BibSearchClass,
  Nemp_ConstantsAndTypes, NempApi, SplitForm_Hilfsfunktionen, SearchTool, mmsystem,
   Nemp_SkinSystem, NempPanel, SkinButtons, math,

  PlayerClass, PlaylistClass, MedienbibliothekClass, BibHelper, deleteHelper,

  gnuGettext, Nemp_RessourceStrings, languageCodes,
  OneInst, DriveRepairTools, ShoutcastUtils, WebServerClass, ScrobblerUtils,
  //dwTaskbarComponents, dwTaskbarThumbnails,
  UpdateUtils, uDragFilesSrc,

  unitFlyingCow, dglOpenGL, NempCoverFlowClass, PartyModeClass, RatingCtrls, tagClouds,
  fspTaskbarMgr, fspTaskbarPreviews, Lyrics, pngimage, ExPopupList, SilenceDetection
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF}
  ;

type

  {$IFDEF USESTYLES}
  TFormStyleHookFix= class (TFormStyleHook)
  procedure CMDialogChar(var Message: TWMKey); message CM_DIALOGCHAR;
  end;

  TFormStyleHookHelper= class  helper for TFormStyleHook
  private
     function CheckHotKeyItem(ACharCode: Word): Boolean;
  end;
  {$ENDIF}

  TNemp_MainForm = class(TNempForm)
    Splitter1: TSplitter;
    TopMainPanel: TPanel;
    PlayerPanel: TNempPanel;
    BassTimer: TTimer;
    Splitter2: TSplitter;
    Nemp_MainMenu: TMainMenu;
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
    VSTPanel: TNempPanel;
    GRPBOXVST: TNempPanel;
    PlaylistFillPanel: TNempPanel;
    GRPBOXPlaylist: TNempPanel;
    SleepTimer: TTimer;
    BirthdayTimer: TTimer;
    VolTimer: TTimer;
    ReallyClearPlaylistTimer: TTimer;
    PanelCoverBrowse: TNempPanel;
    CoverScrollbar: TScrollBar;
    MenuImages: TImageList;
    Splitter4: TSplitter;
    VDTCover: TNempPanel;
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
    MM_Playlist: TMenuItem;
    MM_PL_Files: TMenuItem;
    MM_PL_Directory: TMenuItem;
    MM_PL_WebStream: TMenuItem;
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
    N26: TMenuItem;
    MM_PL_ExtendedAddToMedialibrary: TMenuItem;
    MM_PL_ExtendedScanFiles: TMenuItem;
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
    N24: TMenuItem;
    MM_T_BirthdayOptions: TMenuItem;
    MM_T_RemoteNemp: TMenuItem;
    MM_T_WebServerActivate: TMenuItem;
    N64: TMenuItem;
    MM_T_WebServerOptions: TMenuItem;
    MM_T_Scrobbler: TMenuItem;
    MM_T_ScrobblerActivate: TMenuItem;
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
    PM_PL_AddFiles: TMenuItem;
    PM_PL_AddDirectories: TMenuItem;
    PM_PL_AddWebstream: TMenuItem;
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
    PM_PL_PlayInHeadset: TMenuItem;
    N13: TMenuItem;
    PM_PL_ExtendedAddToMedialibrary: TMenuItem;
    PM_PL_ExtendedScanFiles: TMenuItem;
    PM_PL_ExtendedCopyToClipboard: TMenuItem;
    PM_PL_ExtendedPasteFromClipboard: TMenuItem;
    N48: TMenuItem;
    PM_PL_Properties: TMenuItem;
    PM_TNA_PlayPause: TMenuItem;
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
    PM_P_Preferences: TMenuItem;
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
    N41: TMenuItem;
    PM_P_BirthdayOptions: TMenuItem;
    PM_P_RemoteNemp: TMenuItem;
    PM_P_WebServerActivate: TMenuItem;
    N65: TMenuItem;
    PM_P_WebServerOptions: TMenuItem;
    PM_P_Scrobbler: TMenuItem;
    PM_P_ScrobblerActivate: TMenuItem;
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
    N63: TMenuItem;
    PM_S_ScrobblerOptions: TMenuItem;
    _Webserver: TMenuItem;
    PM_W_WebServerActivate: TMenuItem;
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
    PaintFrame: TImage;
    CoverImage: TImage;
    IMGMedienBibCover: TImage;
    ImgScrollCover: TImage;
    PM_ML_BrowseByAlbumArtists: TMenuItem;
    PM_ML_BrowseByYearArtist: TMenuItem;
    MM_ML_BrowseByAlbumArtists: TMenuItem;
    MM_ML_BrowseByYearArtist: TMenuItem;
    Pnl_CoverFlowLabel: TNempPanel;
    Lbl_CoverFlow: TLabel;
    PM_P_PartyMode: TMenuItem;
    TabBtn_TagCloud: TSkinButton;
    MM_O_PartyMode: TMenuItem;
    ImgDetailCover: TImage;
    PanelTagCloudBrowse: TNempPanel;
    PM_ML_GetTags: TMenuItem;
    fspTaskbarManager: TfspTaskbarMgr;
    fspTaskbarPreviews1: TfspTaskbarPreviews;
    PM_ML_CloudEditor: TMenuItem;
    MemoDisableTimer: TTimer;
    TaskBarImages: TImageList;
    Win7TaskBarPopup: TPopupMenu;
    test1: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    PM_PL_ShowInExplorer: TMenuItem;
    N69: TMenuItem;
    MM_PL_ShowInExplorer: TMenuItem;
    MM_T_CloudEditor: TMenuItem;
    MM_ML_DeleteSelectedFiles: TMenuItem;
    MM_ML_GetAdditionalTags: TMenuItem;
    MM_ML_GetLyrics: TMenuItem;
    N71: TMenuItem;
    MM_ML_CloseNemp: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles1: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles2: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles3: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles4: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles5: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles6: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles7: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles8: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles9: TMenuItem;
    PM_ML_SetRatingsOfSelectedFiles10: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    PM_ML_ResetRating: TMenuItem;
    MM_ML_SetRatingSelected: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles1: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles2: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles3: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles4: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles5: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles6: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles7: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles8: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles9: TMenuItem;
    MM_ML_SetRatingsOfSelectedFiles10: TMenuItem;
    N74: TMenuItem;
    MM_ML_SetRatingsOfSelectedFilesReset: TMenuItem;
    PM_PL_SetRatingofSelectedFilesTo: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles1: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles2: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles3: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles4: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles5: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles6: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles7: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles8: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles9: TMenuItem;
    PM_PL_SetRatingsOfSelectedFiles10: TMenuItem;
    N75: TMenuItem;
    PM_PL_ResetRating: TMenuItem;
    MM_PL_SetRatingofSelectedFilesTo: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles1: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles2: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles3: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles4: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles5: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles6: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles7: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles8: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles9: TMenuItem;
    MM_PL_SetRatingsOfSelectedFiles10: TMenuItem;
    N77: TMenuItem;
    MM_PL_ResetRating: TMenuItem;
    PM_PL_StopAfterCurrentTitle: TMenuItem;
    MM_ML_BrowseByFileageAlbum: TMenuItem;
    PM_ML_BrowseByFileageAlbum: TMenuItem;
    MM_ML_BrowseByFileageArtist: TMenuItem;
    PM_ML_BrowseByFileageArtist: TMenuItem;
    VDTCoverInfoPanel: TNempPanel;
    BtnApplyEditTags: TButton;
    BtnCancelEditTags: TButton;
    EdtBibAlbum: TEdit;
    EdtBibArtist: TEdit;
    EdtBibGenre: TComboBox;
    EdtBibTitle: TEdit;
    EdtBibTrack: TEdit;
    EdtBibYear: TEdit;
    ImgBibRating: TImage;
    LblBibAlbum: TLabel;
    LblBibArtist: TLabel;
    LblBibDuration: TLabel;
    LblBibGenre: TLabel;
    LblBibPlayCounter: TLabel;
    LblBibQuality: TLabel;
    LblBibTags: TLabel;
    LblBibTitle: TLabel;
    LblBibTrack: TLabel;
    LblBibYear: TLabel;
    MemBibTags: TMemo;
    CoverDetails_Popup: TPopupMenu;
    PM_Cover_Aside: TMenuItem;
    PM_Cover_Below: TMenuItem;
    PM_Cover_DontShowDetails: TMenuItem;
    GRPBOXHeadset: TNempPanel;
    TabBtn_Headset: TSkinButton;
    SlidebarButton_Headset: TSkinButton;
    SlideBarShapeHeadset: TShape;
    BtnLoadHeadset: TSkinButton;
    HeadSetTimer: TTimer;
    PlayPauseHeadSetBtn: TSkinButton;
    StopHeadSetBtn: TSkinButton;
    VolButtonHeadset: TSkinButton;
    VolShapeHeadset: TShape;
    HeadsetCoverImage: TImage;
    LblHeadsetArtist: TLabel;
    SlideForwardHeadsetBTN: TSkinButton;
    SlideBackHeadsetBTN: TSkinButton;
    BtnHeadsetToPlaylist: TSkinButton;
    PM_PL_ClearPlaylist: TMenuItem;
    MM_PL_ClearPlaylist: TMenuItem;
    ButtonNextEQ: TButton;
    ButtonPrevEQ: TButton;
    PM_PL_MagicCopyToClipboard: TMenuItem;
    PM_ML_MagicCopyToClipboard: TMenuItem;
    PM_PL_CopyPlaylistToUSB: TMenuItem;
    MM_PL_CopyPlaylistToUSB: TMenuItem;
    MM_H_ErrorLog: TMenuItem;
    N76: TMenuItem;
    PM_ML_ShowAllIncompleteTaggedFiles: TMenuItem;
    RefreshCoverFlowTimer: TTimer;
    MM_T_KeyboardDisplay: TMenuItem;
    PM_P_KeyboardDisplay: TMenuItem;
    MM_O_Wizard: TMenuItem;
    PM_P_Wizard: TMenuItem;
    PM_PlayCDAudio: TMenuItem;
    PM_PL_AddCDAudio: TMenuItem;
    PM_W_WebServerShowLog: TMenuItem;
    MM_T_WebServerShowLog: TMenuItem;
    PM_P_WebServerShowLog: TMenuItem;
    BtnHeadsetPlaynow: TSkinButton;
    ab1: TImage;
    ab2: TImage;
    N70: TMenuItem;
    PM_ABRepeat: TMenuItem;
    PopupRepeatAB: TPopupMenu;
    PM_StopABrepeat: TMenuItem;
    PM_ABRepeatSetA: TMenuItem;
    PM_ABRepeatSetB: TMenuItem;
    PM_SetA: TMenuItem;
    PM_SetB: TMenuItem;
    N78: TMenuItem;
    BtnABRepeatSetA: TSkinButton;
    BtnABRepeatSetB: TSkinButton;
    BtnABRepeatUnset: TSkinButton;
    LblEmptyLibraryHint: TLabel;
    WalkmanModeTimer: TTimer;
    WalkmanImage: TImage;
    CorrectSkinRegionsTimer: TTimer;
    TreeImages: TImageList;
    PlaylistVST: TVirtualStringTree;
    VST: TVirtualStringTree;
    MM_O_Skin_UseAdvanced: TMenuItem;
    PM_P_Skin_UseAdvancedSkin: TMenuItem;
    CoverFlowRefreshViewTimer: TTimer;
    EditPlaylistSearch: TEdit;

    procedure FormCreate(Sender: TObject);


    procedure InitPlayingFile(Startplay: Boolean; StartAtOldPosition: Boolean = False);

    procedure Skinan1Click(Sender: TObject);
    procedure ActivateSkin(aName: String);

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
    procedure ShowHelp;

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

    function ValidAudioFile(filename: UnicodeString; JustPlay: Boolean): boolean;
    procedure PM_ML_GetLyricsClick(Sender: TObject);

    procedure VSTBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);

    procedure StringVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);

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
    procedure ShowHeadsetDetails(aAudioFile: TAudioFile);
    procedure ShowVSTDetails(aAudioFile: TAudioFile);
    procedure VolButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PM_PL_DeleteAllClick(Sender: TObject);
    procedure PM_PL_DeleteSelectedClick(Sender: TObject);
    procedure PM_PL_PlayInHeadsetClick(Sender: TObject);
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
    procedure Splitter2Moved(Sender: TObject);
    procedure Btn_EffectsOffClick(Sender: TObject);
    procedure PlayListSaveDialogTypeChange(Sender: TObject);
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
    procedure SetEqualizerByName(aSetting: UnicodeString);
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
    procedure DoFastIPCSearch(aString: UnicodeString);

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
    function DeleteFileFromRecentList(aIdx: Integer): boolean;
    function AddFileToRecentList(NewFile: UnicodeString): Boolean;
    Procedure SetRecentPlaylistsMenuItems;

    Function GeneratePlaylistSTFilter: string;
    function GenerateMedienBibSTFilter: String;
    procedure PlaylistVSTEnter(Sender: TObject);
    procedure VSTEnter(Sender: TObject);

    procedure RepairZOrder;
    procedure ActualizeVDTCover;

    procedure PM_PL_AddToPrebookListEndClick(Sender: TObject);
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

    procedure AktualisiereDetailForm(aAudioFile: TAudioFile; Source: Integer; Foreground: Boolean = False);
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
    //procedure MM_ML_ResetRatingsClick(Sender: TObject);
    procedure Player_PopupMenuPopup(Sender: TObject);
    procedure VST_ColumnPopupPopup(Sender: TObject);
    procedure Splitter4CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);

    procedure VST_ColumnPopupOnClick(Sender: TObject);
    procedure VST_ColumnPopupCoverOnClick(Sender: TObject);
    procedure EDITFastSearchChange(Sender: TObject);
    procedure CB_MedienBibGlobalQuickSearchClick(Sender: TObject);
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
    procedure HideTagMemo;
    function GetCorrespondingEdit(aLabel: TLabel): TControl;
    function GetCorrespondingLabel(aEdit: TControl): TLabel;

    procedure EdtBibArtistExit(Sender: TObject);
    procedure EdtBibArtistKeyPress(Sender: TObject; var Key: Char);
    procedure VDTCoverClick(Sender: TObject);
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
    procedure PanelTagCloudBrowseMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);


    procedure PM_PL_AddToPrebookListBeginningClick(Sender: TObject);
    procedure PM_PL_RemoveFromPrebookListClick(Sender: TObject);
    procedure VSTAfterGetMaxColumnWidth(Sender: TVTHeader; Column: TColumnIndex;
      var MaxWidth: Integer);
    procedure fspTaskbarManagerThumbButtonClick(Sender: TObject;
      ButtonId: Integer);
    procedure FormActivate(Sender: TObject);
    procedure fspTaskbarPreviews1NeedIconicBitmap(Sender: TObject; Width,
      Height: Integer; var Bitmap: HBITMAP);
    procedure PM_ML_CloudEditorClick(Sender: TObject);
    procedure LblBibTagsClick(Sender: TObject);
    procedure BtnApplyEditTagsClick(Sender: TObject);
    procedure MemBibTagsKeyPress(Sender: TObject; var Key: Char);
    procedure MemBibTagsExit(Sender: TObject);
    procedure MemoDisableTimerTimer(Sender: TObject);

    procedure NewPlayerPanelClick(Sender: TObject);
    procedure NewPlayerPanelMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure NewPlayerPanelMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Win7TaskBarPopupPopup(Sender: TObject);
    procedure PM_PL_ShowInExplorerClick(Sender: TObject);
    procedure PM_ML_SetRatingsOfSelectedFilesClick(Sender: TObject);
    procedure GRPBOXArtistsAlbenResize(Sender: TObject);
    procedure AuswahlPanelResize(Sender: TObject);
    procedure VDTCoverInfoPanelResize(Sender: TObject);
    procedure Splitter3Moved(Sender: TObject);
    procedure Splitter4Moved(Sender: TObject);
    procedure ImgDetailSwitchClick(Sender: TObject);
    procedure PM_Cover_DontShowDetailsClick(Sender: TObject);
    procedure SlideBarShapeHeadsetMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SlidebarButton_HeadsetEndDrag(Sender, Target: TObject; X,
      Y: Integer);
    procedure SlidebarButton_HeadsetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SlidebarButton_HeadsetStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PLayPauseBtnHeadsetClick(Sender: TObject);
    procedure BtnLoadHeadsetClick(Sender: TObject);
    procedure HeadSetTimerTimer(Sender: TObject);
    procedure StopHeadSetBtnClick(Sender: TObject);
    procedure VolButtonHeadsetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GRPBOXHeadsetMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure GRPBOXHeadsetMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure GRPBOXHeadsetClick(Sender: TObject);
    procedure BtnHeadsetToPlaylistClick(Sender: TObject);
    procedure PM_PL_ClearPlaylistClick(Sender: TObject);
    procedure SlideBackHeadsetBTNClick(Sender: TObject);
    procedure SlideForwardHeadsetBTNClick(Sender: TObject);
    procedure ButtonNextEQClick(Sender: TObject);
    procedure MM_ML_WebradioClick(Sender: TObject);
    procedure PM_PL_MagicCopyToClipboardClick(Sender: TObject);
    procedure PM_PL_CopyPlaylistToUSBClick(Sender: TObject);
    procedure MM_H_ErrorLogClick(Sender: TObject);
    procedure PM_ML_ShowAllIncompleteTaggedFilesClick(Sender: TObject);
    procedure RefreshCoverFlowTimerTimer(Sender: TObject);
    procedure ImgDetailCoverMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgDetailCoverMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PM_P_KeyboardDisplayClick(Sender: TObject);
    procedure MM_O_WizardClick(Sender: TObject);
    procedure PM_PlayCDAudioClick(Sender: TObject);
    procedure PM_PL_AddCDAudioClick(Sender: TObject);
    procedure PM_W_WebServerShowLogClick(Sender: TObject);
    procedure BtnHeadsetPlaynowClick(Sender: TObject);
    procedure ab1StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ab1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BtnABRepeatClick(Sender: TObject);
    procedure PM_ABRepeatSetAClick(Sender: TObject);
    procedure PM_ABRepeatSetBClick(Sender: TObject);
    procedure WalkmanModeTimerTimer(Sender: TObject);
    procedure WalkmanImageClick(Sender: TObject);
    procedure VSTEndDrag(Sender, Target: TObject; X, Y: Integer);
    //procedure ArtistsVSTAfterCellPaint(Sender: TBaseVirtualTree;
    //  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
    //  CellRect: TRect);
    procedure CorrectSkinRegionsTimerTimer(Sender: TObject);
    procedure MM_O_Skin_UseAdvancedClick(Sender: TObject);
    procedure PanelCoverBrowseMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PanelCoverBrowseMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure CoverFlowRefreshViewTimerTimer(Sender: TObject);
    procedure EditPlaylistSearchEnter(Sender: TObject);
    procedure EditPlaylistSearchExit(Sender: TObject);
    procedure EditPlaylistSearchChange(Sender: TObject);
    procedure EditPlaylistSearchKeyPress(Sender: TObject; var Key: Char);
    procedure EditPlaylistSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintFrameDblClick(Sender: TObject);

  private
    CoverImgDownX: Integer;
    CoverImgDownY: Integer;
    TagCloudDownX: Integer;
    TagCloudDownY: Integer;

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



    // Setzt alle DragOver-Eventhandler auf das der Effekte-Groupbox
    procedure SetGroupboxEffectsDragover;
    // ... der Equalizer-Groupbox
    procedure SetGroupboxEQualizerDragover;


    procedure OwnMessageProc(var msg: TMessage);
    procedure NewScrollBarWndProc(var Message: TMessage);
    procedure NewLyricMemoWndProc(var Message: TMessage);
    procedure WMStartEditing(var Msg: TMessage); Message WM_STARTEDITING;

    procedure CMMenuClosed(var Msg: TMessage ); message CM_MENUCLOSED;
    procedure CM_ENTERMENULOOP(var Msg: TMessage ); message CM_ENTERMENULOOP;



    procedure HandleRemoteFilename(filename: UnicodeString; Mode: Integer);

    procedure CatchAllExceptionsOnShutDown(Sender: TObject; E: Exception);

    { Private declarations }
  public

      CloudViewer: TCloudViewer;

    NempIsClosing: Boolean;


    // Zählt die Nachrichten "Neues Laufwerk angeschlossen"
    // nötig, da ein Update der Bib nicht möglich ist, wenn ein Update bereits läuft
    NewDrivesNotificationCount: Integer;

    WebRadioInsertMode: Integer;

    { Public declarations }
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
    GlobalUseAdvancedSkin: Boolean;
    SkinName: UnicodeString;

    AktiverTree: TVirtualStringTree;
    AlphaBlendBMP: TBitmap;

    BibRatingHelper: TRatingHelper;

    procedure MinimizeNemp(Sender: TObject);
    procedure DeactivateNemp(Sender: TObject);
    procedure RestoreNemp;
    procedure NotifyDeskband(aMsg: Integer);
    procedure ProcessCommandline(lpData: Pointer; StartPlay: Boolean) ; overload;
    procedure ProcessCommandline(filename: UnicodeString; StartPlay: Boolean; Enqueue: Boolean); overload;
  protected
    Procedure WMDropFiles (Var aMsg: tMessage);  message WM_DROPFILES;
    procedure MediaKey (Var aMSG: tMessage); message WM_APPCOMMAND;

    Procedure NempAPI_Commands(Var aMSG: tMessage); message WM_COMMAND;
    Procedure NempAPI_UserCommands(Var aMSG: tMessage); message WM_USER;

    Procedure MedienBibMessage(Var aMsg: TMessage); message WM_MedienBib;

    Procedure ShoutcastQueryMessage(Var aMsg: TMessage); message WM_Shoutcast;
    Procedure WebServerMessage(Var aMsg: TMessage); message WM_WebServer;
    Procedure UpdaterMessage(Var aMsg: TMessage); message WM_Update;
    Procedure ScrobblerMessage(Var aMsg: TMessage); message WM_Scrobbler;

    procedure WndProc(var Message: TMessage); override;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;

    procedure hotkey(var msg:Tmessage); message WM_HOTKEY;
    procedure WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING); //message WM_WINDOWPOSCHANGING;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure WMEndSession(var M: TWMEndSession); message WM_ENDSESSION;

    procedure NeedPreview (var msg : TWMFCNeedPreview); message WM_FC_NEEDPREVIEW;

    procedure NewSelected (Var Msg: TMessage); message WM_FC_SELECT;

    procedure STStart    (var Msg: TMessage); message ST_Start    ;
    procedure STNewFile  (var Msg: TMessage); message ST_NewFile  ;
    procedure STFinish   (var Msg: TMessage); message ST_Finish   ;
   end;


var

  Nemp_MainForm: TNemp_MainForm;
  FOwnMessageHandler: HWND;

  ST_Playlist       : TSearchTool;
  ST_Medienliste    : TSearchTool;

  CueSyncHandle: DWord;

  AcceptApiCommands: Boolean = False; // am Ende des OnShows auf True setzen.
                                      // Beim Close auf False

  NempPlayer: TNempPlayer;
  NempPlayList: TNempPlaylist; // Die Playlist halt ;-)
  NempWebServer: TNempWebServer;
  MedienBib: TMedienbibliothek;

  SavePath: UnicodeString; // Programmdir oder Userdir

  LanguageList: TStrings;

  ErrorLog: TStringList;
  ErrorLogCount: Integer;

implementation

uses   Splash, About, OptionsComplete, StreamVerwaltung,
   PlaylistUnit,  AuswahlUnit,  MedienlisteUnit, ShutDown, Details,
  BirthdayShow, RandomPlaylist, BasicSettingsWizard,
  NewPicture, ShutDownEdit, NewStation, BibSearch, BassHelper,
  ExtendedControlsUnit, fspControlsExt, CloudEditor,
  TagHelper, PartymodePassword, CreateHelper, PlaylistToUSB, ErrorForm,
  CDOpenDialogs, WebServerLog, Lowbattery;


{$R *.dfm}


{$IFDEF USESTYLES}
{ TFormStyleHookFix }

procedure TFormStyleHookFix.CMDialogChar(var Message: TWMKey);
begin
   if ((Message.KeyData and $20000000) <> 0 ) and (CheckHotKeyItem(Message.CharCode)) then
    begin
      Message.Result := 1;
      Handled := True;
    end
end;

{ TFormStyleHookHelper }
function TFormStyleHookHelper.CheckHotKeyItem(ACharCode: Word): Boolean;
begin
  Result:=False;
  if Self.FMainMenuBarHook<>nil then
   Result:=Self.FMainMenuBarHook.CheckHotKeyItem(ACharCode);
end;
{$ENDIF}




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
           on E: Exception do TranslateMessageDLG('Error in InitPlayingFile: ' + #13#10 + E.Message,mtError, [mbOK], 0);
        end;
    end;
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
    MedienBib.TagCloud.  ShowTags(True);//(ListView1);
end;


procedure TNemp_MainForm.PanelTagCloudBrowseMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var aTag: TPaintTag;
    i:integer;
    DateiListe: TObjectlist;
    maxC: Integer;
begin
    if ssleft in shift then
    begin
      if (abs(X - TagCloudDownX) > 5) or  (abs(Y - TagCloudDownY) > 5) then
      begin
          Dateiliste := TObjectlist.Create(False);
          GenerateListForHandleFiles(DateiListe, 4);
          DragSource := DS_VST;
          with DragFilesSrc1 do
          begin
              // Add files selected to DragFilesSrc1 list
              ClearFiles;
              DragDropList.Clear;

              maxC := min(MAX_DRAGFILECOUNT, DateiListe.Count - 1);

              //if DateiListe.Count > MAX_DRAGFILECOUNT then
              //begin
              //  //MessageDlg(MESSAGE_TOO_MANY_FILES, mtInformation, [MBOK], 0);
              //  FreeAndNil(Dateiliste);
              //  exit;
              //end;
              for i:=0 to maxC do
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
        TagCloudDownX := 0;
        TagCloudDownY := 0;

        aTag := MedienBib.TagCloud.CloudPainter.GetTagAtMousePos(x,y);

        if (aTag <> MedienBib.TagCloud.MouseOverTag) and assigned(aTag) then
        begin
            MedienBib.TagCloud.CloudPainter.RePaintTag(MedienBib.TagCloud.MouseOverTag, False);
            MedienBib.TagCloud.MouseOverTag := aTag;
            MedienBib.TagCloud.CloudPainter.RePaintTag(MedienBib.TagCloud.MouseOverTag, True);
        end;
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
        MedienBib.TagCloud.ShowTags(True);//(ListView1);
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
                MedienBib.TagCloud.ShowTags(True);
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
    MedienBib.TagCloud.CloudPainter.PaintAgain;
end;

procedure TNemp_MainForm.PanelTagCloudBrowseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CloudViewer.SetFocus;
    TagCloudDownX := X;
    TagCloudDownY := Y;

    if Button = mbRight then
    begin
        MedienBib.TagCloud.FocussedTag := MedienBib.TagCloud.MouseOverTag;
        MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, False);
    end;
end;

procedure TNemp_MainForm.PanelTagCloudBrowseMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    TagCloudDownX := 0;
    TagCloudDownY := 0;
end;

procedure TNemp_MainForm.OwnMessageProc(var msg: TMessage);
begin
    if NempIsClosing then
        msg.Result := 0
    else
        msg.Result := sendmessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
end;


procedure TNemp_MainForm.FormCreate(Sender: TObject);
begin

    FOwnMessageHandler := AllocateHWND( OwnMessageProc );

    TranslateComponent (self);
    Randomize;
    // Diverse Exceptions abschalten
    SetErrorMode(SEM_FAILCRITICALERRORS); // e.g. Dont display "Insert Disk"
    Saved8087CW := Default8087CW;
    Set8087CW($133f);

    DragAcceptFiles (Handle, True);
    DragSource := DS_EXTERN;

    NewDrivesNotificationCount := 0;
    NempIsClosing              := False;
    ReadyForGetFileApiCommands := False;
    LangeAktionWeitermachen    := False;
    NempRegionsDistance.Docked := True;
    MinimizedIndicator         := False;
    {$IFDEF USESTYLES}FormatSettings.{$ENDIF}Decimalseparator   := '.';

    OldScrollbarWindowProc    := CoverScrollbar.WindowProc;
    CoverScrollbar.WindowProc := NewScrollBarWndProc;
    OldLyricMemoWindowProc    := LyricsMemo.WindowProc;
    LyricsMemo.WindowProc     := NewLyricMemoWndProc;
    // "OnMinimize"-Event ändern
    Application.OnMinimize    := MinimizeNemp;
    Application.OnDeactivate  := DeactivateNemp;

    WebRadioInsertMode := PLAYER_PLAY_DEFAULT;

    VST.NodeDataSize         := SizeOf(TTreeData);
    ArtistsVST.NodeDataSize  := SizeOf(TStringTreeData);
    ALbenVST.NodeDataSize    := SizeOf(TStringTreeData);
    PlaylistVST.NodeDataSize := SizeOf(TTreeData);

    ErrorLog := TStringList.Create;
    ErrorLogCount := 0;
    AlphaBlendBMP := TBitmap.Create;

    // Create FileSearcher
    ST_Playlist := TSearchTool.Create;
    ST_Medienliste := TSearchTool.Create;
    with ST_Medienliste do
    begin
        ID      := ST_ID_Medialist;
        Recurse := True;
        MHandle := FOwnMessageHandler;
        MCurrentDir := mkNoneMessage;
        MFound      := mkSendMessage;
    end;
    with ST_Playlist do
    begin
        ID      := ST_ID_Playlist;
        Recurse := True;
        MHandle := FOwnMessageHandler;
        MCurrentDir := mkNoneMessage;
        MFound      := mkSendMessage;
    end;

    DragDropList := TStringList.Create;

    // Get Savepath for settings
    if IsExeInProgramSubDir then
    begin
        // Nemp liegt im System-Programmverzeichnis
        SavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
        try
            ForceDirectories(SavePath);
        except
            SavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
        end;
    end else
    begin
        // Nemp liegt woanders
        SavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
    end;



    // Create additional controls
    CloudViewer           := TCloudViewer.Create(self);
    CloudViewer.Parent    := PanelTagCloudBrowse;
    CloudViewer.Name      := 'CloudViewer';
    CloudViewer.Align     := alClient;
    CloudViewer.TabStop   := True;
    CloudViewer.PopupMenu := Medialist_PopupMenu;
    CloudViewer.OnKeypress   := CloudTestKey;
    CloudViewer.OnKeyDown    := CloudTestKeyDown;
    CloudViewer.OnMouseMove  := PanelTagCloudBrowseMouseMove;
    CloudViewer.OnClick      := PanelTagCloudBrowseClick;
    CloudViewer.OnDblClick   := PanelTagCloudBrowseDblClick;
    CloudViewer.OnMouseDown  := PanelTagCloudBrowseMouseDown;
    CloudViewer.OnMouseUp    := PanelTagCloudBrowseMouseUp;
    CloudViewer.OnResize     := PanelTagCloudBrowseResize;
    CloudViewer.OnPaint      := CloudPaint;
    CloudViewer.OnAfterPaint := CloudAfterPaint;
    NewPlayerPanel.DoubleBuffered := True;


    // Create Player
    NempPlayer            := TNempPlayer.Create(FOwnMessageHandler);
    NempPlayer.Statusproc := StatusProc;
    // Create Playlist
    NempPlaylist        := TNempPlaylist.Create;
    NempPlaylist.VST    := PlaylistVST;
    NempPlaylist.Player := NempPlayer;
    NempPlaylist.MainWindowHandle := FOwnMessageHandler;

    BibRatingHelper := TRatingHelper.Create;
    // Create Medialibrary
    //Application.CreateForm(TMsgForm, MsgForm);



    MedienBib := TMedienBibliothek.Create(FOwnMessageHandler, PanelCoverBrowse.Handle);
    MedienBib.BibScrobbler := NempPlayer.NempScrobbler;
    MedienBib.TagCloud.CloudPainter.Canvas := CloudViewer.Canvas;
    MedienBib.SavePath := SavePath;
    MedienBib.CoverSavePath := SavePath + 'Cover\';
    MedienBib.NewCoverFlow.CoverSavePath := MedienBib.CoverSavePath;
    // needed for ClassicFlow
    MedienBib.NewCoverFlow.MainImage := IMGMedienBibCover;
    MedienBib.NewCoverFlow.ScrollImage := ImgScrollCover;
    // Needed for FlyingCow
    MedienBib.NewCoverFlow.Window := PanelCoverBrowse.Handle ;
    MedienBib.NewCoverFlow.events_window := FOwnMessageHandler;
    try
        ForceDirectories(MedienBib.CoverSavePath);
    except
        if not DirectoryExists(MedienBib.CoverSavePath) then
            MedienBib.CoverSavePath := MedienBib.SavePath;
    end;

    // Create Skin-System
    NempSkin := TNempSkin.create;
    PlayListSkinImageList := TImageList.Create(Nemp_MainForm);
    PlayListSkinImageList.Height := 14;
    PlayListSkinImageList.Width := 14;

    // Create Updater
    NempUpdater := TNempUpdater.Create(FOwnMessageHandler);

    // create WebServer
    NempWebServer := TNempWebServer.Create(FOwnMessageHandler);
    NempWebServer.SavePath := SavePath;
    NempWebServer.CoverSavePath := MedienBib.CoverSavePath;

    // create Spectrum
    Spectrum := TSpectrum.Create(PaintFrame.Width, PaintFrame.Height);
    Spectrum.MainImage := PaintFrame;
    Spectrum.TextImage := TextAnzeigeImage;
    Spectrum.TimeImage := TimePaintbox;
    Spectrum.StarImage := RatingImage;

    // Set some ShortCuts
    PM_PL_MagicCopyToClipboard.ShortCut :=
       Menus.ShortCut(Word('C'), [ssCtrl, ssShift]);
    PM_ML_MagicCopyToClipboard.ShortCut :=
       Menus.ShortCut(Word('C'), [ssCtrl, ssShift]);
end;

procedure TNemp_MainForm.FormShow(Sender: TObject);
begin
  // StuffToDoAfterCreate;
  // Nothing to do here. Will be done in nemp.dpr
  if assigned(FSplash) then
      FSplash.Close;
end;

procedure TNemp_MainForm.CatchAllExceptionsOnShutDown(Sender: TObject; E: Exception);
begin
    Application.Terminate;
end;

procedure TNemp_MainForm.TntFormClose(Sender: TObject; var Action: TCloseAction);
    var i:integer;
    ini:TMemIniFile;
    s:integer;
    PosAndSize : PWindowPlacement;
begin
    NempIsClosing := True;
    //PauseMadExcept(True);
    try
        Application.OnException := CatchAllExceptionsOnShutDown;

        NempTrayIcon.Visible := False;

        UnInstallHotKeys(FOwnMessageHandler);
        UninstallMediakeyHotkeys(FOwnMessageHandler);

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
            WriteNempOptions(ini, NempOptions, AnzeigeMode);

            Ini.WriteInteger('Fenster', 'Anzeigemode', AnzeigeMode);
            ini.WriteBool('Fenster', 'UseSkin', UseSkin);
            ini.WriteString('Fenster','SkinName', SkinName);
            ini.WriteBool('Fenster', 'UseAdvancedSkin', GlobalUseAdvancedSkin);

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

        if MedienBib.AutoSaveMediaList AND {(MedienBib.Count > 0) AND} (MedienBib.Changed) then
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
        AudioPanel.Top := NewPlayerPanel.Top + NewPlayerPanel.Height + 3;

        CoverScrollbar.WindowProc := OldScrollbarWindowProc;
        LyricsMemo.WindowProc := OldLyricMemoWindowProc;

        ST_Playlist.Free;
        ST_Medienliste.Free;
        FreeAndNil(DragDropList);

        Set8087CW(Default8087CW);

    except
        halt;
    end;
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
    try
        aNode := Pointer(Msg.WParam);
        VST.EditNode(aNode, Msg.LParam);
    except
        /// nothing
        /// This happens, when the user select "search for ..." in the popup-menu
        /// and the menu is over the "rating"-column
    end;
end;

procedure TNemp_MainForm.CMMenuClosed(var Msg: TMessage );
begin
    Win7TaskBarPopup.Tag := 0;
end;

procedure TNemp_MainForm.CM_ENTERMENULOOP(var Msg: TMessage );
begin
    Win7TaskBarPopup.Tag := 1;
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
            MedienBib.GenerateAnzeigeListeFromCoverID(aCover.key);
            Lbl_CoverFlow.Caption := aCover.InfoString;
        end;
    end else
    begin
        if CoverScrollbar.Position <= MedienBib.Coverlist.Count -1 then
        begin
            aCover := TNempCover(MedienBib.CoverList[CoverScrollbar.Position]);
            Lbl_CoverFlow.Caption := aCover.InfoString;
        end;
    end;
    CoverScrollbar.OnChange := CoverScrollbarChange;
end;

procedure TNemp_MainForm.NeedPreview (var msg : TWMFCNeedPreview);
var
    aCover: tNempCover;
    bmp: TBitmap;
    success: Boolean;
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

          success := GetCoverBitmapFromID(aCover.ID, bmp, MedienBib.CoverSavePath);
          Medienbib.NewCoverFlow.SetPreview (msg.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);

          //if (not success) then
          //    CheckAndDoCoverDownloaderQuery;

          if (not success) and (MedienBib.CoverSearchLastFM) then
              Medienbib.NewCoverFlow.DownloadCover(aCover, msg.index);
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
  begin
  /// XXX das geht so nicht mehr, weil in der Taskleiste seit D2007 Form.Handle drin steckt. Aber das
  ///  einfach ausblenden bewirkt da nichts.
    if NempTrayIcon.Visible then ShowWindow(Application.Handle, SW_HIDE); // vorher Application.Handle

{   SetWindowLong( Nemp_MainForm.Handle, GWL_EXSTYLE,
                 Nemp_MainForm.NempWindowDefault
                 or WS_EX_TOOLWINDOW
                 //and (not WS_ICONIC)
                 and (not WS_EX_APPWINDOW));}

  end;


  if NempOptions.ShowDeskbandOnMinimize then
      NotifyDeskband(NempDeskbandActivateMessage);

  Application.ShowMainForm := False;
//  hide;
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
  else
    OldScrollbarWindowProc(Message);
  end;
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
        SetForegroundWindow (Nemp_MainForm.Handle);
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

  ///02.2017
  ShowWindow(Application.Handle, SW_RESTORE);
  ///02.2017
  SetForegroundWindow(Nemp_MainForm.Handle);

  RepairZOrder;

  MinimizedIndicator := False;

  //if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
  //    ShowWindow( Application.Handle, SW_HIDE );

  Show;
  ///02.2017
  ShowApplication;
  ///02.2017
  Application.ShowMainForm := True;

  if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
      ShowWindow( Application.Handle, SW_HIDE );


  if WindowState <> wsMaximized then
  begin
      FormPosAndSizeCorrect(Nemp_MainForm);
      FormPosAndSizeCorrect(AuswahlForm);
      FormPosAndSizeCorrect(PlaylistForm);
      FormPosAndSizeCorrect(MedienlisteForm);
      FormPosAndSizeCorrect(ExtendedControlForm);
      ReInitRelativePositions;
  end;

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
      RestoreNemp;

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
  // Über die Commandline kommen nur SAchen für die Playlist
  // Zumindest bisher (2.5d, für die nächste Version ist auch nichts anderes geplant)
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
          // Parameter immer an die Playlist anhängen
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
// var newnode: PVirtualNode;
begin
  if Mode = PLAYER_PLAY_FILES then
    NempPlaylist.ClearPlaylist;

  if Mode in [PLAYER_PLAY_NOW, PLAYER_PLAY_NEXT] then
    NempPlaylist.GetInsertNodeFromPlayPosition
  else
    NempPlaylist.InsertNode := NIL;

  {newnode := }NempPlaylist.InsertFileToPlayList(filename);
  // DONT - Most users dont get it ;-)  if Mode=PLAYER_PLAY_NEXT then
  // DONT - Most users dont get it ;-)      NempPlaylist.AddNodeToPrebookList(newnode);


  if (Mode in [PLAYER_PLAY_NOW, PLAYER_PLAY_FILES]) AND (NempPlaylist.Count > NempPlaylist.InsertIndex-1) then
  begin
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      NempPlaylist.Play(NempPlaylist.InsertIndex-1, 0, True);
  end;
end;

procedure TNemp_MainForm.HeadSetTimerTimer(Sender: TObject);
begin
  if SlideBarButton_HeadSet.Tag = 0 then
    SlideBarButton_HeadSet.Left := SlideBarShapeHeadset.Left
          + Round((SlideBarShapeHeadset.Width - SlideBarButton_HeadSet.Width) * NempPlayer.HeadsetProgress);
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
        if MinimizedIndicator then
        begin
            RestoreNemp;
            MinimizedIndicator := False;
        end else
        begin
            Application.Minimize;
            MinimizedIndicator := True;
        end;
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
          //COMMAND_RESTORE       : if MinimizedIndicator then RestoreNemp else application.Minimize;

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
    ///02.2017
    RestoreNemp;
end;

Procedure TNemp_MainForm.MedienBibMessage(Var aMsg: TMessage);
begin
    if NempIsClosing then
        aMsg.Result := 1
    else
        Handle_MedienBibMessage(aMsg);
end;


Procedure TNemp_MainForm.ShoutcastQueryMessage(Var aMsg: TMessage);
begin
    if NempIsClosing then
        aMsg.Result := 1
    else
        Handle_ShoutcastQueryMessage(aMsg);
end;

Procedure TNemp_MainForm.WebServerMessage(Var aMsg: TMessage);
begin
    if NempIsClosing then
        aMsg.Result := 1
    else
        Handle_WebServerMessage(aMsg);
end;

Procedure TNemp_MainForm.UpdaterMessage(Var aMsg: TMessage);
begin
    if NempIsClosing then
        aMsg.Result := 1
    else
        Handle_UpdaterMessage(aMsg);
end;

Procedure TNemp_MainForm.ScrobblerMessage(Var aMsg: TMessage);
begin
    if NempIsClosing then
        aMsg.Result := 1
    else
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
                            if (not NempIsClosing) and NempSkin.isActive then
                              NempSkin.FitSkinToNewWindow;
                            Message.Result := 0;
                        end;
                  SC_Restore:
                        begin
                            MinimizedIndicator := False;
                            if (not NempIsClosing) and NempSkin.isActive then
                              NempSkin.FitSkinToNewWindow;
                            Message.Result := 0;
                        end;
              end;
          end;
      else
          if (Message.Msg = SecondInstMsgId) and (not NempIsClosing) then
            PostThreadMessage(Message.WParam, SecondInstMsgId, Handle, 0)
          else
            inherited WndProc(Message);
      end;
  end;
end;


procedure TNemp_MainForm.WMCopyData(var Msg: TWMCopyData);
var IncomingPAnsiChar:PAnsiChar;
    IncomingPWideChar: PWideChar;
    mode: Integer;
begin
  if (MsG.CopyDataStruct.dwData = SecondInstMsgId) AND (SecondInstMsgId <> 0) then
  begin
      if (not NempIsClosing) then
          ProcessCommandline(Msg.CopyDataStruct.lpData, NempPlaylist.AutoPlayEnqueuedTitle)
      else
      begin
          inherited;
          exit;
      end;
  end;
  ;//else

  if NOT AcceptApiCommands then inherited
  else
    case MsG.CopyDataStruct.dwData of
        IPC_SEND_SEARCHSTRING: if ReadyForGetFileApiCommands then begin
                  IncomingPAnsiChar := PAnsiChar(Msg.CopyDataStruct.lpData);
                  Msg.Result := 1;
                  DoFastIPCSearch(trim(UnicodeString(AnsiString(IncomingPAnsiChar))));
        end;

        IPC_SEND_FILEFORPLAYLIST..IPC_SEND_FILEFORPLAYLIST+4:
            if ReadyForGetFileApiCommands then
            begin
                    Mode := MsG.CopyDataStruct.dwData - IPC_SEND_FILEFORPLAYLIST_W;
                    if (Mode >= PLAYER_PLAY_DEFAULT) then
                      Mode := NempPlaylist.DefaultAction;
                    IncomingPAnsiChar := PAnsiChar(Msg.CopyDataStruct.lpData);
                    Msg.Result := 1;
                    HandleRemoteFilename(UnicodeString(AnsiString(IncomingPAnsiChar)), Mode);
            end;

        // WideString-variante
        IPC_SEND_SEARCHSTRING_W: if ReadyForGetFileApiCommands then begin
                  IncomingPWideChar := PWideChar(Msg.CopyDataStruct.lpData);
                  DoFastIPCSearch(trim(UnicodeString(IncomingPWideChar)));
                  Msg.Result := 1;
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
    1,17: if NempPlayer.Status = PLAYER_ISPLAYING then
        PlayPauseBTNIMGClick(Nil)
      else
        PlayPauseBTNIMGClick(NIL);
    2,16: StopBTNIMGClick(Nil);
    3,14: PlayNextBTNIMGClick(PlayNextBTN);
    4,15: PlayPrevBTNIMGClick(PlayPrevBTN);
    5: SlideForwardBTNIMGClick(NIL);
    6: SlideBackBTNIMGClick(NIL);
    7,13: begin
        VolTimer.Enabled := False;
        NempPlayer.VolStep := NempPlayer.VolStep + 1;
        NempPlayer.Volume := NempPlayer.Volume + 1 + (NempPlayer.VolStep DIV 3);
        VolTimer.Enabled := True;
        CorrectVolButton;
      end;
    8,12: begin
        VolTimer.Enabled := False;
        NempPlayer.VolStep := NempPlayer.VolStep + 1;
        NempPlayer.Volume := NempPlayer.Volume - 1 - (NempPlayer.VolStep DIV 3);
        VolTimer.Enabled := True;
        CorrectVolButton;
      end;
    9,11: begin
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
    begin
        if NOT (o is TNempPanel) then
            // get parent, should be the HeadPhone-Groupbox
            o := o.Parent;
        if assigned(o) and ObjectIsHeadphone(o.Name) then
            Handle_DropFilesForHeadPhone(aMsg)
        else
            Handle_DropFilesForLibrary(aMsg);
    end;
end;


procedure TNemp_MainForm.MediaKey (Var aMSG: tMessage);
begin
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

procedure TNemp_MainForm.MM_O_Skin_UseAdvancedClick(Sender: TObject);
begin
    GlobalUseAdvancedSkin := NOT GlobalUseAdvancedSkin;

    MM_O_Skin_UseAdvanced.Checked := GlobalUseAdvancedSkin;
    PM_P_Skin_UseAdvancedSkin.Checked := GlobalUseAdvancedSkin;

    {$IFDEF USESTYLES}
    // deactivate it immediately
    if Not Nemp_MainForm.GlobalUseAdvancedSkin then
    begin
        TStyleManager.SetStyle('Windows');
        Nemp_MainForm.CorrectSkinRegionsTimer.Enabled := True;
    end else
    begin
        // refresh skin, if a skin is used, and it supports advanced skinning
        if UseSkin then
        begin
            if NempSkin.UseAdvancedSkin then
                ActivateSkin(GetSkinDirFromSkinName(SkinName))
            else
                TranslateMessageDLG((AdvancedSkinActivateHint), mtInformation, [MBOK], 0);
        end;
    end;
    UpdateFormDesignNeu;

    if assigned(FDetails) then
        FDetails.LoadStarGraphics;
    {$ENDIF}
end;


procedure TNemp_MainForm.ActivateSkin(aName: String);
begin
    NempSkin.LoadFromDir(aName);
    NempSkin.ActivateSkin;

    if NempSkin.NempPartyMode.Active then
    begin
        // I have no idea, why I need to reactivate PartyMode to
        // get proper results with the player-image... :(
        NempSkin.NempPartyMode.Active := false;
        NempSkin.NempPartyMode.Active := true;
    end;

    RePaintPanels;
    RepaintOtherForms;

    RepaintAll;
end;

procedure TNemp_MainForm.WindowsStandardClick(Sender: TObject);
begin
  NempSkin.DeActivateSkin;
  SetSkinRadioBox('');
  UseSkin := False;
  RePaintPanels;
  RepaintOtherForms;
  RepaintAll;
end;


// Ein paar Routinen, die das Skinnen erleichtren
procedure TNemp_MainForm.Skinan1Click(Sender: TObject);
//var tmpstr: UnicodeString;
begin
  UseSkin := True;
  SkinName := StringReplace((Sender as TMenuItem).Caption,'&&','&',[rfReplaceAll]);

  // SkinName ist die Globale Var, die in die ini gespeichert wird -> da muss das privat//global mit rein!!!
{  tmpstr := StringReplace(SkinName,
              '<public> ', ExtractFilePath(ParamStr(0)) + 'Skins\', []);

  tmpstr := StringReplace(tmpstr,
              '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);
 }
  ActivateSkin(GetSkinDirFromSkinName(SkinName));

  SetSkinRadioBox(SkinName);

 // CorrectSkinRegionsTimer.Enabled := True;
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


procedure TNemp_MainForm.GRPBOXArtistsAlbenResize(Sender: TObject);
var newWidth: Integer;
begin
    newWidth := Round(NempOptions.NempFormRatios.ArtistWidth / 100 * (AuswahlPanel.Width));
    if newWidth < 50 then
        newWidth := 50;
    ArtistsVST.Width := newWidth;


    LblEmptyLibraryHint.Width := (GRPBOXArtistsAlben.Width - 50);
    LblEmptyLibraryHint.Left := 25;
    LblEmptyLibraryHint.Top := (GRPBOXArtistsAlben.Height - LblEmptyLibraryHint.Height) Div 2;


end;

Procedure TNemp_MainForm.AnzeigeSortMENUClick(Sender: TObject);
var oldAudioFile: TAudioFile;
begin
  if Not (Sender is TMenuItem) then exit;

  oldAudioFile := GetFocussedAudioFile;
  VST.Enabled := False;

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
      CON_EXTENSION : MedienBib.AddSorter(CON_EXTENSION, False);
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
// Medialist_PopupMenu.Tag auswerten und bei Tag ~ Alben ggf. die markierten Playlists löschen


procedure TNemp_MainForm.PM_ML_DeleteSelectedClick(Sender: TObject);
var i:integer;
    AlbumData: PStringTreeData;
    FocussedAlbumNode, NewSelectNode: PVirtualNode;
    SelectedPlaylist: TJustaString;
    SelectedMp3s: TNodeArray;
    FileList: TObjectList;
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
                TranslateMessageDLG((Medialibrary_GUIError3), mtInformation, [MBOK], 0);
            end else
            begin
                if MedienBib.StatusBibUpdate <> 0 then
                begin
                    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
                    exit;
                end;
                VST.BeginUpdate;
                MedienBib.StatusBibUpdate := BIB_Status_ReadAccessBlocked;
                SelectedMP3s := VST.GetSortedSelection(False);
                if length(SelectedMP3s) = 0 then exit;
                StarteLangeAktion(length(SelectedMP3s), Format((MediaLibrary_Deleting), [0]), False);

                // Hier wird komplett gelöscht.
                // d.h.: aus der Medienliste entfernen und aus alle anderen Listen
                begin
                    FileList := TObjectList.Create(False);
                    try
                        // collect Data first
                        VSTSelectionToAudiofileList(VST, SelectedMP3s, FileList);
                        // Delete Nodes
                        VST.DeleteSelectedNodes;

                        // in allen Listen löschen und MP3-File entfernen
                        for i:=0 to FileList.Count-1 do
                        begin
                            //Data := VST.GetNodeData(SelectedMP3s[i]);
                            MedienBib.DeleteAudioFile(TAudioFile(FileList[i]));
                            if i mod 64 = 0 then
                            begin
                                MedienListeStatusLBL.Caption := Format((MediaLibrary_Deleting), [Round(i/length(SelectedMP3s) * 100)]);
                                Application.ProcessMessages;
                            end;
                        end;
                    finally
                        FileList.Free;
                    end;
                end;

                VST.EndUpdate;
                MedienBib.RepairBrowseListsAfterDelete;
                MedienBib.BuildTotalString;
                MedienBib.BuildTotalLyricString;
                ReFillBrowseTrees(True);
                MedienListeStatusLBL.Caption := '';
                BeendeLangeAktion;
                MedienBib.StatusBibUpdate := BIB_Status_Free;

                ResetBrowsePanels;
            end;
        end;
    end; // case
end;


procedure TNemp_MainForm.MM_ML_DeleteClick(Sender: TObject);
begin
    if TranslateMessageDLG((Medialibrary_QueryReallyDelete), mtWarning, [mbYes,MBNo], 0) = mrYes then
    begin
        MedienBib.Clear;
        MedienListeStatusLBL.Caption := '';
        AuswahlStatusLBL.Caption := '';
        Caption:= Nemp_Caption;
        ResetBrowsePanels;
    end;
    // AktualisiereDetailForm(NIL, SD_MEDIENBIB);
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
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  if MedienBib.InitialDialogFolder = ''  then
      MedienBib.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);

  ST_Medienliste.Mask := GenerateMedienBibSTFilter;
  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_BibCaption, MedienBib.InitialDialogFolder );
  try
      if fb.Execute then
      begin
          fspTaskbarManager.ProgressValue := 0;
          fspTaskbarManager.ProgressState := fstpsIndeterminate;
          newdir := fb.SelectedItem;
          MedienBib.InitialDialogFolder := fb.SelectedItem;
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
      LblEmptyLibraryHint.Caption := MainForm_LibraryIsLoading;
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
    Abspielen: Boolean;
    imax: integer;
    tmp: PvirtualNode;
begin
    if aList.Count = 0 then exit;

    (aList[0] as TAudiofile).ReCheckExistence;

    if How = PLAYER_PLAY_FILES then // erst PlayList löschen
        NempPlaylist.ClearPlaylist;

    // Check, whether the player is currently playing
    // or the user selected "play now"
    Abspielen := ((NempPlaylist.Count = 0) and (NempPlayer.MainStream = 0)) OR (How = PLAYER_PLAY_FILES);

    if How in [{PLAYER_PLAY_NOW, }PLAYER_PLAY_NEXT] then
        NempPlaylist.GetInsertNodeFromPlayPosition
    else
        NempPlaylist.InsertNode := NIL;

    // Erste Datei einfügen und ggf. Abspielen
    tmp := NempPlaylist.InsertFileToPlayList(TAudiofile(aList[0]));

    // DONT - Most users dont get it ;-) if How=PLAYER_PLAY_NEXT then
    // DONT - Most users dont get it ;-)  NempPlaylist.AddNodeToPrebookList(tmp);

    if assigned(tmp) then
      PlayListVST.ScrollIntoView( tmp, False, True);

    if Abspielen AND (NempPlaylist.Count>0) then // 2.Bedingung: Es wurde tatsächlich was eingefügt
    begin
        NempPlayer.LastUserWish := USER_WANT_PLAY;
        NempPlaylist.Play(0, 0, True);
    end
    else
        // Playlist war vor dem Einfügen nicht leer
        // aber Modus ist PLAY_NOW => Neu eingefügtes erstes File abspielen
        if (HOW = PLAYER_PLAY_NOW) AND (NempPlaylist.Count > 0) then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(NempPlaylist.Count-1, 0, True);
        end;

    iMax := aList.Count-1;

    ContinueWithPlaylistAdding := True;

    // weitere Dateien einfügen
    for i:=1 to iMax do
    begin
      (aList[i] as TAudiofile).ReCheckExistence;

      tmp := NempPlaylist.InsertFileToPlayList(TAudiofile(aList[i]));
      // DONT - Most users dont get it ;-)  if How=PLAYER_PLAY_NEXT then
      // DONT - Most users dont get it ;-)    NempPlaylist.AddNodeToPrebookList(tmp);
      if i Mod 20 = 0 then
      begin
          PlayListVST.ScrollIntoView( tmp, False, True);
          Application.ProcessMessages;
      end;
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
                  TranslateMessageDLG(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
              FreeFilesInHandleFilesList := True;
          end else
          begin
              FreeFilesInHandleFilesList := False;
              // Wenn ein spezielles Album ausgewählt wurde, dann
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
        //MedienBib.GetTitelListFromCoverID(aList, TNempCover(MedienBib.Coverlist[CoverScrollbar.Position]).ID);
        if CoverScrollbar.Position <= MedienBib.Coverlist.Count -1 then
            MedienBib.GetTitelListFromCoverID(aList, TNempCover(MedienBib.Coverlist[CoverScrollbar.Position]).key);
        // Sortieren
        if aList.Count <= 5000 then
            aList.Sort(Sortieren_AlbumTrack_asc);
      end;
      4: begin
        MedienBib.GenerateDragDropListFromTagCloud(MedienBib.TagCloud.FocussedTag, aList);
          // Sortieren
        if aList.Count <= 5000 then
            aList.Sort(Sortieren_AlbumTrack_asc);
      end;
  else
    TranslateMessageDLG('Uh-Oh. Something strange happens (GenerateListForHandleFiles). Please report this error.'
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
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben geöffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      HandleFiles(Dateiliste, PLAYER_ENQUEUE_FILES);
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
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben geöffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      if (NempPlaylist.Count > 20) AND (DateiListe.Count < 5) then
      begin
        if TranslateMessageDLG((Playlist_QueryReallyDelete), mtWarning, [mbYes, mbNo], 0) = mrYes then
              HandleFiles(Dateiliste, PLAYER_PLAY_FILES)
      end
      else
        HandleFiles(Dateiliste, PLAYER_PLAY_FILES);

      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(Dateiliste);
end;


procedure TNemp_MainForm.PM_ML_PlayNextClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  WebRadioInsertMode := PLAYER_PLAY_NEXT;
  // Dateiliste füllen, abhängig davon, wo wir gerade sind.
  GenerateListForHandleFiles(Dateiliste, Medialist_PopupMenu.Tag);
  if NOT (     (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) // Webradio markiert
           AND (Medialist_PopupMenu.Tag = 2)                    // Popup auf Alben geöffnet
          ) then                                                // bei Webradio wird ein Thread gestartet, der das dann erledigt.
  begin
      HandleFiles(Dateiliste, PLAYER_PLAY_NEXT);
      if FreeFilesInHandleFilesList then DoFreeFilesInHandleFilesList(DateiListe);
  end;
  FreeAndNil(DateiListe);
end;

procedure TNemp_MainForm.PM_ML_PlayNowClick(Sender: TObject);
var  OldNode: PVirtualNode;
      Data: PTreeData;
      af: TAudioFile;
begin
    OldNode := VST.FocusedNode;
    if assigned(OldNode) then
    begin
      Data := VST.GetNodeData(OldNode);
      af :=  Data^.FAudioFile;
    end else
      af := NIL;
    if assigned(af) and FileExists(af.Pfad) then
        NempPlaylist.PlayBibFile(af, NempPlayer.FadingInterval);
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

  if MedienBib.Count <= 10 then
      PM_ML_SearchDirectory.Default := True
  else
  begin
      Nemp_MainForm.PM_ML_Play    .Default := NempPlaylist.DefaultAction = 1;
      Nemp_MainForm.PM_ML_Enqueue .Default := NempPlaylist.DefaultAction = 0;
      Nemp_MainForm.PM_ML_PlayNext.Default := NempPlaylist.DefaultAction = 2;
      Nemp_MainForm.PM_ML_PlayNow .Default := NempPlaylist.DefaultAction = 3;
  end;


  { PLAYER_ENQUEUE_FILES = 0; // Achtung! Muss mit den Itemindexes der Radiogroup
      PLAYER_PLAY_FILES = 1;    // in der Optionen-Form übereinstimmen!
      PLAYER_PLAY_NEXT = 2;
      PLAYER_PLAY_NOW = 3;
      PLAYER_PLAY_DEFAULT = 4;
      }
  
  o := Screen.ActiveForm.ActiveControl;
  if (o <> NIL) AND ((o.Name = 'VST') or (o.Name = 'TabBtn_Medialib')) then
  begin
      PM_ML_Play.Caption     := (MainForm_MenuCaptionsPlay    );
      PM_ML_Enqueue.Caption  := (MainForm_MenuCaptionsEnqueue );
      PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNext);
      PM_ML_PlayNow.Caption  := (MainForm_MenuCaptionsPlayNow );
      PM_ML_PlayNow.Visible  := True;
      PM_ML_BrowseBy.Enabled := True;
      aVst := Vst;
      Medialist_PopupMenu.Tag := 0;
  end
  else
    if (o <> NIL) AND (o.Name = 'ArtistsVST') then
    begin
        PM_ML_Enqueue.Caption := GetProperMenuString(Integer(MedienBib.NempSortArray[1])); //Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[Integer(MedienBib.NempSortArray[1])]]);
        PM_ML_Play.Caption    := (MainForm_MenuCaptionsPlayAll );
        PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
        PM_ML_PlayNow.Visible  := False;
        PM_ML_BrowseBy.Enabled := True;
        aVst := ArtistsVST;
        Medialist_PopupMenu.Tag := 1;
    end
    else
      if (o <> NIL) AND (o.Name = 'AlbenVST') then
      begin
          if (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) then
              PM_ML_Enqueue.Caption := MainForm_MenuCaptionsEnqueueAllPlaylist
          else
              if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
                  PM_ML_Enqueue.Caption := MainForm_MenuCaptionsEnqueueAllWebradio
              else
                  PM_ML_Enqueue.Caption := GetProperMenuString(Integer(MedienBib.NempSortArray[2]));;//Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[Integer(MedienBib.NempSortArray[2])]]);
          PM_ML_Play.Caption     := (MainForm_MenuCaptionsPlayAll );
          PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
          PM_ML_PlayNow.Visible  := False;
          PM_ML_BrowseBy.Enabled := True;
          aVST := ALbenVST;
          Medialist_PopupMenu.Tag := 2;
      end else
        if (o <> NIL) AND (o.Name = 'CoverScrollbar') then
        begin
            PM_ML_Enqueue.Caption  := GetProperMenuString(1);; //Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[1]]);
            PM_ML_Play.Caption     := (MainForm_MenuCaptionsPlayAll );
            PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
            PM_ML_PlayNow.Visible  := False;
            PM_ML_BrowseBy.Enabled := True;
            aVST := Nil;
            Medialist_PopupMenu.Tag := 3;
        end else
          if (o <> NIL) AND (o.Name = 'CloudViewer') then
          begin
              PM_ML_Enqueue.Caption  := GetProperMenuString(6); //Format((MainForm_MenuCaptionsPlayAll), [AUDIOFILE_STRINGS[1]]);
              PM_ML_Play.Caption     := (MainForm_MenuCaptionsPlayAll );
              PM_ML_PlayNext.Caption := (MainForm_MenuCaptionsPlayNextAll);
              PM_ML_PlayNow.Visible  := False;
              PM_ML_BrowseBy.Enabled := False;
              aVST := Nil;
              Medialist_PopupMenu.Tag := 4;
          end
          else
              aVST := Nil;

      PM_ML_SortBy.Enabled := (aVST = VST) AND Not LangeAktionWeitermachen;
      PM_ML_Extended.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;

    if (((aVST = NIL) OR (aVST.FocusedNode= NIL))
       or ((aVST = VST) AND (VST.SelectedCount = 0)))
        AND
       ((o <> NIL) AND (o.Name <> 'CoverScrollbar')
                   AND (o.Name <>'CloudViewer') )
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
      PM_ML_PlayHeadset.Enabled := False;
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
      PM_ML_Properties.Enabled := (aVST = VST) AND (not LangeAktionWeitermachen) and (not NempSkin.NempPartyMode.DoBlockBibOperations);
      PM_ML_RefreshSelected.Enabled := (aVST = VST) AND (not LangeAktionWeitermachen)  and (not NempSkin.NempPartyMode.DoBlockBibOperations);
      PM_ML_HideSelected.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_DeleteSelected.Enabled := (((aVST = VST) AND (not MedienBib.AnzeigeShowsPlaylistFiles) AND (not LangeAktionWeitermachen))
                                    OR ((aVST = AlbenVST) and (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) AND (not LangeAktionWeitermachen)))
                                    and (not NempSkin.NempPartyMode.DoBlockBibOperations);


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
      PM_ML_GetLyrics.Enabled := (aVST = VST) AND (not MedienBib.AnzeigeShowsPlaylistFiles) AND (not LangeAktionWeitermachen) and (not NempSkin.NempPartyMode.DoBlockBibOperations);
      PM_ML_GetTags.Enabled := (aVST = VST) AND (not MedienBib.AnzeigeShowsPlaylistFiles) AND (not LangeAktionWeitermachen) and (not NempSkin.NempPartyMode.DoBlockBibOperations);
      PM_ML_PlayHeadset.Enabled := (aVST = VST);

      //PM_ML_DeleteSelected.Enabled := (aVST = VST) AND not LangeAktionWeitermachen;
      PM_ML_ExtendedShowAllFilesInDir.Enabled := (not MedienBib.AnzeigeShowsPlaylistFiles);
      PM_ML_ExtendedAddAllFilesInDir.Enabled := (not MedienBib.AnzeigeShowsPlaylistFiles);
      PM_ML_ExtendedSearchTitle.Enabled := True;
      PM_ML_ExtendedSearchArtist.Enabled := True;
      PM_ML_ExtendedSearchAlbum.Enabled := True;
      PM_ML_ShowInExplorer.Enabled := (aVST = VST);
      PM_ML_CopyToClipboard.Enabled := (aVST = VST) AND (not LangeAktionWeitermachen);
    end;
    PM_ML_PasteFromClipboard.Enabled := (Clipboard.HasFormat(CF_HDROP)) and (not NempSkin.NempPartyMode.DoBlockBibOperations);

    if (aVST = VST) AND (aVST.FocusedNode <> NIL) then
    begin
        Data := aVST.GetNodeData(aVST.FocusedNode);
        if Data.FAudioFile.Titel = '' then
            PM_ML_ExtendedSearchTitle.Caption := MainForm_MenuCaptionsSearchForEmptyTitle
        else
            PM_ML_ExtendedSearchTitle.Caption  := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Titel]);

        if Data.FAudioFile.Artist = '' then
            PM_ML_ExtendedSearchArtist.Caption := MainForm_MenuCaptionsSearchForEmptyArtist
        else
            PM_ML_ExtendedSearchArtist.Caption := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Artist]);

        if Data.FAudioFile.Album = '' then
            PM_ML_ExtendedSearchAlbum.Caption := MainForm_MenuCaptionsSearchForEmptyAlbum
        else
            PM_ML_ExtendedSearchAlbum.Caption  := Format((MainForm_MenuCaptionsSearchForVar), [Data.FAudioFile.Album]);
    end else
    begin
        PM_ML_ExtendedSearchTitle.Caption  := (MainForm_MenuCaptionsSearchForTitle);
        PM_ML_ExtendedSearchArtist.Caption := (MainForm_MenuCaptionsSearchForArtist);
        PM_ML_ExtendedSearchAlbum.Caption  := (MainForm_MenuCaptionsSearchForAlbum)
    end;

    // Additional: Hide most of the items when opening from the Browse-Part
    //(makes some of the things above useless...)
    N14                              .visible := aVST = VST;
    PM_ML_PlayHeadset                .visible := aVST = VST;
    PM_ML_SortBy                     .visible := aVST = VST;
    PM_ML_HideSelected               .visible := aVST = VST;
    PM_ML_DeleteSelected             .visible := aVST = VST;
    PM_ML_SetRatingsOfSelectedFiles  .visible := aVST = VST;
    PM_ML_GetLyrics                  .visible := aVST = VST;
    PM_ML_GetTags                    .visible := aVST = VST;
    N3                               .visible := aVST = VST;
    PM_ML_CopyToClipboard            .visible := aVST = VST;
    PM_ML_PasteFromClipboard         .visible := aVST = VST;
    PM_ML_Extended                   .visible := aVST = VST;
    N55                              .visible := aVST = VST;
    PM_ML_RefreshSelected            .visible := aVST = VST;
    PM_ML_ShowInExplorer             .visible := aVST = VST;
    PM_ML_Properties                 .visible := aVST = VST;
end;

procedure TNemp_MainForm.PM_ML_SetRatingsOfSelectedFilesClick(
  Sender: TObject);
var CurrentAF, listFile :TAudioFile;
    iSel, iList: Integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
    Node:PVirtualNode;
    SelectedFiles, ListOfFiles: TObjectList;
    newRating: Integer;
    resetCounter: Boolean;
    detUpdate, TagMod100: Integer;
    LocalTree: TVirtualStringTree;
    aErr: TNempAudioError;
begin
    // preparation
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;
    MedienBib.StatusBibUpdate := 3;
    BlockeMedienListeReadAccess(True);
    LangeAktionWeitermachen := true;
    fspTaskbarManager.ProgressState := fstpsNormal;
    fspTaskbarManager.ProgressValue := 0;

    TagMod100 := (Sender as TMenuItem).Tag Mod 100;
    if (Sender as TMenuItem).Tag >= 100 then
        LocalTree := VST
    else
        LocalTree := PlaylistVST;

    SelectedMP3s := LocalTree.GetSortedSelection(False);
    ListOfFiles := TObjectList.Create(False);
    try
        if TagMod100 = 10 then
        begin
            newRating := 0;
            resetCounter := True;
        end
        else
        begin
            newRating := Round(TagMod100 * 25.5) + 20;
            resetCounter := False;
        end;

        if newRating > 255 then newRating := 255;


        SelectedFiles := TObjectList.Create(False);
        try
            // Collect Data
            VSTSelectionToAudiofileList(VST, SelectedMP3s, SelectedFiles);

            for iSel := 0 to SelectedFiles.Count-1 do
            begin
                fspTaskbarManager.ProgressValue := Round(iSel/SelectedFiles.Count * 100);
                application.processmessages;
                if not LangeAktionWeitermachen then break;

                //Data := LocalTree.GetNodeData(SelectedMP3s[iSel]);
                CurrentAF := TAudioFile(SelectedFiles[iSel]); //Data^.FAudioFile;

                      // get List of this AudioFile
                      GetListOfAudioFileCopies(CurrentAF, ListOfFiles);
                      // edit all these files
                      for iList := 0 to ListOfFiles.Count - 1 do
                      begin
                          listFile := TAudioFile(ListOfFiles[iList]);
                          listFile.Rating := newRating;
                          if resetCounter then
                              listFile.PlayCounter := 0;
                      end;
                      // write the rating into the file on disk
                      aErr := CurrentAF.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                      HandleError(afa_SaveRating, CurrentAF, aErr);
                      // correct GUI
                      CorrectVCLAfterAudioFileEdit(CurrentAF);
            end;
        finally
            SelectedFiles.Free;
        end;
    finally
        ListOfFiles.Free;
    end;
    MedienBib.Changed := True;

    // clean up stuff
    BlockeMedienListeReadAccess(False);
    BlockeMedienListeWriteAcces(False);
    BlockeMedienListeUpdate(False);

    LangeAktionWeitermachen := False;
    MedienBib.StatusBibUpdate := 0;
    MedienListeStatusLBL.Caption := '';
    ShowSummary;
    fspTaskbarManager.ProgressState := fstpsNoProgress;
    Node := LocalTree.FocusedNode;
    if LocalTree = VST then
        detUpdate := SD_MEDIENBIB
    else
        detUpdate := SD_PLAYLIST;

    if Assigned(Node) then
    begin
        Data := LocalTree.GetNodeData(Node);
        AktualisiereDetailForm(Data^.FAudioFile, detUpdate);
    end else
        AktualisiereDetailForm(NIL, detUpdate);
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

    // showmessage('/e,/select,"'+Data^.FAudioFile.Pfad+'"');
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

  if MedienBib.Count = 0 then
      AuswahlStatusLBL.Caption := ''
  else
  begin
      if (MedienBib.BrowseMode = 0) and (MedienBib.CurrentArtist = BROWSE_PLAYLISTS) then
      begin
          if MedienBib.Alben.Count = 1 then
              AuswahlStatusLBL.Caption := Format(MainForm_Summary_PlaylistCountSingle, [MedienBib.Alben.Count])
          else
              AuswahlStatusLBL.Caption := Format(MainForm_Summary_PlaylistCountMulti, [MedienBib.Alben.Count])
      end
      else
      if (MedienBib.BrowseMode = 0) and (MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS) then
      begin
          if MedienBib.RadioStationList.Count = 1 then
              AuswahlStatusLBL.Caption := Format(MainForm_Summary_WebradioCountSingle, [MedienBib.RadioStationList.Count])
          else
              AuswahlStatusLBL.Caption := Format(MainForm_Summary_WebradioCountMulti, [MedienBib.RadioStationList.Count])
      end
      else
      begin
          for i:=0 to Liste.Count-1 do
          begin
              dauer := dauer + (Liste[i] as TAudioFile).Duration;
              groesse := groesse + (Liste[i] as TAudioFile).Size;
          end;
          if Liste.Count = 1 then
              AuswahlStatusLBL.Caption := Format((MainForm_Summary_FileCountSingle),[Liste.Count])
                             + SizeToString(groesse)
                             + SekToZeitString(dauer)
          else
              AuswahlStatusLBL.Caption := Format((MainForm_Summary_FileCountMulti),[Liste.Count])
                             + SizeToString(groesse)
                             + SekToZeitString(dauer)
      end;
  end;
end;


procedure TNemp_MainForm.ShowHelp;
var ProperHelpFile: String;
begin
    if NempOptions.Language = 'de' then
    begin
        ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-de.chm';
        if NOT FileExists(ProperHelpFile) then
            ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-en.chm';
    end else
    begin
        ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-en.chm';
        if NOT FileExists(ProperHelpFile) then
            ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-de.chm';
    end;

    if NOT FileExists(ProperHelpFile) then
        TranslateMessageDLG((Error_HelpFileNotFound), mtError, [mbOK], 0)
    else
        ShellExecute(Handle, 'open', PChar(ProperHelpFile), nil, nil, SW_SHOWNORMAl);
end;

procedure TNemp_MainForm.ToolButton7Click(Sender: TObject);
begin
    ShowHelp;
end;


procedure TNemp_MainForm.MM_ML_RefreshAllClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;
  MedienBib.RefreshFiles;
end;

procedure TNemp_MainForm.PM_ML_RefreshSelectedClick(Sender: TObject);
var
    AudioFile:TAudioFile;
    i,tot:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
    SelectedFiles: TObjectList;
    Node:PVirtualNode;
    oldArtist, oldAlbum: UnicodeString;
    oldID: String;
    einUpdate: boolean;
    aErr: TNempAudioError;

begin
  SelectedMp3s := Nil;
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  MedienBib.StatusBibUpdate := 3;
  BlockeMedienListeReadAccess(True);
  LangeAktionWeitermachen := true;
  MedienBib.ReInitCoverSearch;
  SelectedMP3s := VST.GetSortedSelection(False);

  fspTaskbarManager.ProgressState := fstpsNormal;
  fspTaskbarManager.ProgressValue := 0;

  SelectedFiles := TObjectList.Create(False);
  try
      // Collect Data
      VSTSelectionToAudiofileList(VST, SelectedMP3s, SelectedFiles);

      if MedienBib.AnzeigeShowsPlaylistFiles then
      begin

          //MessageDLG((Medialibrary_GUIError4), mtError, [MBOK], 0);
          for i:=0 to SelectedFiles.Count-1 do
          begin
              application.processmessages;
              if not LangeAktionWeitermachen then break;
              //Data := VST.GetNodeData(SelectedMP3s[i]);
              AudioFile := TAudioFile(SelectedFiles[i]);//Data^.FAudioFile;
              if FileExists(AudioFile.Pfad) then
              begin
                  AudioFile.FileIsPresent:=True;
                  aErr := AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover or GAD_Rating);
                  HandleError(afa_RefreshingFileInformation, AudioFile, aErr);

                  MedienBib.InitCover(AudioFile);
                  VST.Invalidate;
              end
              else begin
                  AudioFile.FileIsPresent:=False;
                  VST.Invalidate;
              end;
              if i mod 64 = 0 then
              begin
                  MedienListeStatusLBL.Caption := Format((MediaLibrary_RefreshingFiles), [Round(i/SelectedFiles.Count * 100)]);
                  fspTaskbarManager.ProgressValue := Round(i/SelectedFiles.Count * 100);
              end;
          end;
      end else
      begin
          einUpdate := False;
          tot := 0;
          for i:=0 to SelectedFiles.Count-1 do
          begin
              application.processmessages;
              if not LangeAktionWeitermachen then break;
              //Data := VST.GetNodeData(SelectedMP3s[i]);
              AudioFile := TAudioFile(SelectedFiles[i]); //Data^.FAudioFile;
              oldArtist := AudioFile.Strings[MedienBib.NempSortArray[1]];
              oldAlbum := AudioFile.Strings[MedienBib.NempSortArray[2]];
              oldID := AudioFile.CoverID;
              if FileExists(AudioFile.Pfad) then
              begin
                  AudioFile.FileIsPresent:=True;
                  aErr := AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover or GAD_Rating);
                  HandleError(afa_RefreshingFileInformation, AudioFile, aErr);
                  MedienBib.InitCover(AudioFile);
                  if  (oldArtist <> AudioFile.Strings[MedienBib.NempSortArray[1]])
                       OR (oldAlbum <> AudioFile.Strings[MedienBib.NempSortArray[2]])
                       or (oldID <> AudioFile.CoverID)
                  then
                    einUpdate := true;
                  VST.Invalidate;
              end
              else begin
                  AudioFile.FileIsPresent:=False;
                  VST.Invalidate;
                  inc(tot);
              end;
              if i mod 64 = 0 then
              begin
                  MedienListeStatusLBL.Caption := Format((MediaLibrary_RefreshingFiles), [Round(i/SelectedFiles.Count * 100)]);
                  fspTaskbarManager.ProgressValue := Round(i/SelectedFiles.Count * 100);
              end;
          end;

          if tot > 0 then
              TranslateMessageDLG(MediaLibrary_FilesNotFoundJustHint, mtWarning, [MBOK], 0);

          if einUpdate then
          begin
              MedienBib.RepairBrowseListsAfterChange;
              MedienBib.BuildTotalString;
              MedienBib.BuildTotalLyricString;
              ReFillBrowseTrees(True);
          end;
          MedienBib.Changed := True;
      end;
  finally
      SelectedFiles.Free;
  end;

  BlockeMedienListeReadAccess(False);
  BlockeMedienListeWriteAcces(False);
  BlockeMedienListeUpdate(False);

  LangeAktionWeitermachen := False;
  MedienBib.StatusBibUpdate := 0;
  MedienListeStatusLBL.Caption := '';
  ShowSummary;
  fspTaskbarManager.ProgressState := fstpsNoProgress;

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

    AktualisiereDetailForm(AudioFile, SD_MEDIENBIB, True);

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
        Data:=Sender.GetNodeData(Node);
        if VST.Header.Columns[column].Position = 0 then
            Celltext := Data^.FAudioFile.Titel
        else
            CellText := '';
    end else
    begin

        Data:=Sender.GetNodeData(Node);

        case VST.Header.Columns[column].Tag of
          CON_ARTIST    : CellText := Data^.FAudioFile.GetArtistForVST(NempOptions.ReplaceNAArtistBy);
          CON_TITEL     : CellText := Data^.FAudioFile.GetTitleForVST(NempOptions.ReplaceNATitleBy);
          CON_ALBUM     : CellText := Data^.FAudioFile.GetAlbumForVST(NempOptions.ReplaceNAAlbumBy);
          CON_DAUER     : CellText := Data^.FAudioFile.GetDurationForVST;
          CON_BITRATE   : CellText := Data^.FAudioFile.GetBitrateForVST;
          CON_CBR       : if Data^.FAudioFile.vbr then CellText := 'vbr'
                          else CellText := 'cbr';
          CON_MODE            : CellText := Data^.FAudioFile.ChannelModeShort;
          CON_SAMPLERATE      : CellText := Data^.FAudioFile.Samplerate;
          CON_STANDARDCOMMENT : CellText := Data^.FAudioFile.Comment;
          CON_FILESIZE  : CellText := FloatToStrF((Data^.FAudioFile.Size / 1024 / 1024),ffFixed,4,2) + ' MB';
          CON_FILEAGE   : Celltext := Data^.FAudioFile.FileAgeString;//DateToStr(Data^.FAudioFile.FileAge);
          CON_PFAD      : CellText := Data^.FAudioFile.Pfad;
          CON_ORDNER    : CellText := Data^.FAudioFile.Ordner;
          CON_DATEINAME : CellText := Data^.FAudioFile.Dateiname;
          CON_YEAR      : CellText := Data^.FAudioFile.Year;
          CON_GENRE     : CellText := Data^.FAudioFile.genre;
          CON_LYRICSEXISTING : if Data^.FAudioFile.LyricsExisting then CellText := ''
                               else CellText := ' ';
          CON_EXTENSION : CellText := Data^.FAudioFile.Extension;
          CON_TRACKNR   : CellText := IntToStr(Data^.FAudioFile.Track);
          CON_CD        :  CellText := Data^.FAudioFile.CD;
          CON_RATING    : CellText := '     ';//IntToStr(Data^.FAudioFile.Rating);//'';//
          CON_PLAYCOUNTER : CellText := IntToStr(Data^.FAudioFile.PlayCounter);

          CON_LASTFMTAGS : CellText := ' ';// Data^.FAudioFile.RawTagLastFM;
        else
          CellText := ' ';
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
begin

  Medialist_PopupMenu.Tag := 0;

  case NempPlaylist.DefaultAction of
      PLAYER_ENQUEUE_FILES: PM_ML_Enqueue.Click  ;
      PLAYER_PLAY_FILES   : PM_ML_Play.Click     ;
      PLAYER_PLAY_NEXT    : PM_ML_PlayNext.Click ;
      PLAYER_PLAY_NOW     : PM_ML_PlayNow.Click  ;
  end;
end;


procedure TNemp_MainForm.VSTAfterGetMaxColumnWidth(Sender: TVTHeader;
  Column: TColumnIndex; var MaxWidth: Integer);
begin
if VST.Header.Columns[column].Tag = CON_RATING then
    MaxWidth := 80;
end;

procedure TNemp_MainForm.VSTHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
var oldAudioFile: TAudioFile;
begin
  VST.CancelEditNode;
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
  cueFile: String;
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
          TranslateMessageDLG((Warning_TooManyFiles), mtInformation, [MBOK], 0);
          exit;
        end;

        for i:=0 to length(SelectedMP3s)-1 do
        begin
            Data := aVST.GetNodeData(SelectedMP3s[i]);
            AddFile(Data^.FAudioFile.Pfad);
            DragDropList.Add(Data^.FAudioFile.Pfad);
            if (Data^.FAudioFile.Duration >  600) then
            begin
                cueFile := ChangeFileExt(Data^.FAudioFile.Pfad, '.cue');
                if FileExists(ChangeFileExt(Data^.FAudioFile.Pfad, '.cue')) then
                    // We dont need internal dragging of cue-Files, so only Addfile
                    AddFile(cueFile);
            end;
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
        if Not NempSkin.NempPartyMode.Active then
        begin
            if NempOptions.ChangeFontSizeOnLength AND (AudioFile.AudioType <> at_Stream) AND (Sender.GetNodeLevel(Node)=0)  then
                font.Size := LengthToSize(AudioFile.Duration,NempOptions.DefaultFontSize)
            else
                font.Size := NempOptions.DefaultFontSize;
        end;

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
            //font.Color := BitrateToColor(AudioFile.Bitrate, NempOptions.MinFontColor, NempOptions.MiddleFontColor, NempOptions.MaxFontColor, NempOptions.MiddleToMinComputing, NempOptions.MiddleToMaxComputing );
            font.Color := BitrateToColor(AudioFile.Bitrate, clRed, clBlack, clGreen, 2, 2);
        end;

        if  (NempSkin.isActive) AND
            (vsSelected in Node.States) AND
            ((Sender.Focused) OR ((Sender = PlaylistVST) and EditPlaylistSearch.Focused))
            then
        begin
          if Sender = PlaylistVST then
            font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[3]
          else
            if Sender = VST then font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[4]
        end;

        if NempOptions.ChangeFontStyleOnMode then
            font.Style := ModeToStyle(AudioFile.ChannelmodeInt)
        else
            font.Style := Nemp_MainForm.NempOptions.DefaultFontStyles;

        if NempOptions.ChangeFontOnCbrVbr then
        begin
          if AudioFile.vbr then font.Name := NempOptions.FontNameVBR
          else font.Name := NempOptions.FontNameCBR
        end;

        if NOT AudioFile.FileIsPresent then
        begin
            // duplicate code needed here. otherwise this produces exceptions on start,
            // if EVERY file in the playlist is missing.
            if Sender = PlaylistVST then
                Font.Style := Font.Style + [fsStrikeOut]
            else
            begin
                case VST.Header.Columns[column].Tag of
                    CON_RATING,
                    CON_LASTFMTAGS,
                    CON_LYRICSEXISTING: ; // nothing
                else
                    // strike out
                    Font.Style := Font.Style + [fsStrikeOut];
                end;
            end;
        end;
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
        CON_ARTIST:   aString := aAudioFile.Artist;
        CON_TITEL:    aString := aAudioFile.Titel;
        CON_ALBUM:    aString := aAudioFile.Album;
        CON_PFAD,
        CON_ORDNER:   aString := aAudioFile.Ordner;
        CON_DATEINAME:aString := aAudioFile.Dateiname;
        CON_EXTENSION:aString := aAudioFile.Extension;
    else
        aString := aAudioFile.Artist;
    end;
    Result := StrLIComp(PChar(SearchText), PChar(aString), length(SearchText));
end;

procedure TNemp_MainForm.VSTInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var data: PTreeData;
begin
    data := VST.GetNodeData(Node);
    if (data^.FAudioFile = MedienBib.BibSearcher.DummyAudioFile) {or (not assigned(data^.FAudioFile))} then
        InitialStates := [ivsDisabled];
end;

procedure TNemp_MainForm.VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
var tmpNode: PVirtualNode;
begin
    if assigned(NewNode) then
    begin
        tmpNode := NewNode;
        //if (vsDisabled in NewNode.States) then
        //    NewNode := NewNode.NextSibling;

        Allowed:= not (vsDisabled in tmpNode.States);
    end
    else
        Allowed := True; // or better false ???
end;

procedure TNemp_MainForm.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Node,ScrollNode: PVirtualNode;
  Data: PTreeData;
  erfolg:boolean;

        function GetNodeWithPrefix(aVST: TVirtualStringTree; StartNode:PVirtualNode; FocussedAttribut:integer; Prefix: UnicodeString; var Erfolg:boolean):PVirtualNode;
        // erfolg gibt an, ob man beim kompletten Durchlauf des Baumes einen weiteren Knoten mit den
        // gewünschten EIgenschaften gefunden hat.
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
                CON_ARTIST    : aString := AudioFile.Artist;
                CON_TITEL     : aString := AudioFile.Titel;
                CON_ALBUM     : aString := AudioFile.Album;
                CON_PFAD,
                CON_ORDNER    : aString := AudioFile.Ordner;
                CON_DATEINAME : aString := AudioFile.Dateiname;
                CON_EXTENSION : aString := AudioFile.Extension;
            else
                aString := AudioFile.Artist;
            end;

            erfolg := AnsiStartsText(Prefix, aString);
            result := Nextnode;

            // nächsten Knoten wählen
            nextnode := aVST.GetNext(nextnode);
            // oder vorne wieder anfangen
            if nextnode = NIL then
              nextnode := aVST.GetFirst;
          until erfolg or (nextnode = startnode);

          if not erfolg then result := nextnode;
        end;
begin
  // Das dann der Form.OnKEydown überlassen
  if ssctrl in Shift then exit;

  case key of
    VK_Return: begin
        case NempPlaylist.DefaultAction of
            PLAYER_ENQUEUE_FILES: PM_ML_Enqueue.Click  ;
            PLAYER_PLAY_FILES   : PM_ML_Play.Click     ;
            PLAYER_PLAY_NEXT    : PM_ML_PlayNext.Click ;
            PLAYER_PLAY_NOW     : PM_ML_PlayNow.Click  ;
        end;
    end;

    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      if not Assigned(VST.FocusedNode) then Exit;
      // nächstes Vorkommen des Prefixes suchen, dazu: beim nächsten Knoten beginnen
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

    VK_F9: begin
      if NempPlayer.JingleStream = 0 then
      begin
        Node := VST.FocusedNode;
        if not Assigned(Node) then
          Exit;
        Data := VST.GetNodeData(Node);
        if Data^.FAudioFile.AudioType = at_File then
            NempPlayer.PlayJingle(Data^.FAudioFile);
      end;
    end;

    VK_F8: begin
        NempPlayer.PlayJingle(Nil);
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
              PM_P_ViewSeparateWindows_EqualizerClick(NIL)
           else
              ShowHelp;
    VK_F2: if ssShift in shift then
              PM_P_ViewSeparateWindows_PlaylistClick(NIL);
    VK_F3: if ssShift in shift then
              PM_P_ViewSeparateWindows_MedialistClick(NIL);
    VK_F4: if ssShift in shift then
              PM_P_ViewSeparateWindows_BrowseClick(NIL);
    $52 {R}: if ssCtrl in shift then
             begin
                Nemp_MainForm.NempOptions.DetailMode := (Nemp_MainForm.NempOptions.DetailMode + 1) mod 3;
                Nemp_MainForm.ActualizeVDTCover;
             end;

    $54 {T}: if ssCtrl in shift then
              PM_P_ViewStayOnTopClick(NIL);

    $46: begin       // F
        if (ssCtrl in Shift) then
            EditFastSearch.SetFocus;
    end;


    VK_F7: begin
        SwapWindowMode(AnzeigeMode + 1); // "mod 2" is done in this SwapWindowMode

           end;

    VK_F8: NempPlayer.PlayJingle(Nil);
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

  c := VST.SelectedCount;
  SelectedMP3s := VST.GetSortedSelection(False);
  if c = 0 then
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

  if c = 1 then
      MedienListeStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountSingle), [c] )
                                  + SizeToString(groesse)
                                  + SekToZeitString(dauer)
  else
      MedienListeStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountMulti), [c] )
                                  + SizeToString(groesse)
                                  + SekToZeitString(dauer);
  aNode := VST.FocusedNode;
  if Assigned(aNode) then
  begin
      Data := VST.GetNodeData(aNode);
      AudioFile := Data^.FAudioFile;
      AudioFile.ReCheckExistence;
      ShowVSTDetails(AudioFile);
      AktualisiereDetailForm(AudioFile, SD_MEDIENBIB);
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
        case aAudioFile.AudioType of
            at_Undef  : LblBibArtist    .Caption := 'ERROR: UNDEFINED AUDIOTYPE'; // should never happen
            at_File,
            at_CDDA : begin
                LblBibArtist    .Caption := SetString(aAudioFile.GetReplacedArtist(NempOptions.ReplaceNAArtistBy),AudioFileProperty_Artist);
                LblBibTitle     .Caption := SetString(aAudioFile.GetReplacedTitle(NempOptions.ReplaceNATitleBy), AudioFileProperty_Title);
                LblBibAlbum     .Caption := SetString(aAudioFile.GetReplacedAlbum(NempOptions.ReplaceNAAlbumBy), AudioFileProperty_Album);
                LblBibTrack     .Caption := 'Track ' + SetString(IntToStr(aAudioFile.Track));
                LblBibYear      .Caption := SetString(aAudioFile.Year, AudioFileProperty_Year);
                LblBibGenre     .Caption := SetString(aAudioFile.Genre, AudioFileProperty_Genre);
            end;
            at_Stream : begin
                LblBibArtist    .Caption := SetString(aAudioFile.Description, AudioFileProperty_Name);
                LblBibTitle     .Caption := SetString(aAudioFile.Ordner, AudioFileProperty_URL);
                LblBibAlbum     .Caption := SetString(aAudioFile.Titel, AudioFileProperty_Title);
                LblBibTrack     .Caption := '(' + AudioFileProperty_Webstream + ')';
                LblBibYear      .Caption := inttostr(aAudioFile.Bitrate) + ' kbit/s';
                LblBibGenre     .Caption := '';
            end;
        end;
    end;
end;

procedure TNemp_MainForm.ShowVSTDetails(aAudioFile: TAudioFile);
var Coverbmp: TBitmap;
    tmp: String;
begin
  MedienBib.CurrentAudioFile := aAudioFile;
  if aAudioFile = NIL then
  begin
      ImgDetailCover.Visible := False;
      VDTCoverInfoPanel.Visible := False;
  end else
  begin
      ImgDetailCover.Visible := True;
      VDTCoverInfoPanel.Visible := NempOptions.DetailMode > 0;
  end;


  if assigned(aAudioFile) and (aAudioFile.isCDDA) then
  begin
      // check, whether the current cd is valid for the AudioFile-Object
      // this is VERY important for the cover-downloading:
      // if album-Artist-data does not match the cddb-id, a wrong cover will be downloaded
      // and displayed permanently
      if (CddbIDFromCDDA(aAudioFile.Pfad) <> aAudioFile.Comment) then
          aAudioFile.GetAudioData(aAudioFile.Pfad, 0);
  end;


  FillBibDetailLabels(aAudioFile);
  // Get Cover
  Coverbmp := tBitmap.Create;
  try
      Coverbmp.Width := 250;
      Coverbmp.Height := 250;

      // Bild holen - (das ist ne recht umfangreiche Prozedur!!)
      GetCover(aAudioFile, Coverbmp);
      ImgDetailCover.Picture.Bitmap.Assign(Coverbmp);
      ImgDetailCover.Refresh;
  finally
      Coverbmp.Free;
  end;

  if not assigned(aAudiofile) then
       exit;

  case aAudioFile.AudioType of
      at_File: begin
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
          ImgBibRating.Visible := True;
          BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
          LblBibTags.Caption := aAudioFile.GetTagDisplayString(NempOptions.AllowQuickAccessToMetadata); //  StringReplace(aAudioFile.RawTagLastFM, #13#10, ', ', [rfreplaceAll]);
          LblBibPlayCounter.Caption := Format(DetailForm_PlayCounter, [aAudioFile.PlayCounter]);
      end;

      at_Stream: begin
          ImgBibRating.Visible := False;
          LblBibDuration  .Caption := '';
          LblBibPlayCounter.Caption := '';
          LblBibTags.Caption := '';
          LblBibQuality.Caption := '';
      end;

      at_CDDA: begin
          LblBibDuration  .Caption := SekToZeitString(aAudioFile.Duration) ;
          LblBibQuality.Caption := 'CD-Audio';
          ImgBibRating.Visible := False;
          LblBibTags.Caption := '';
          LblBibPlayCounter.Caption := '';
      end;
  end;
end;

procedure TNemp_MainForm.VDTCoverClick(Sender: TObject);
var Point: tPoint;
begin
    // Disable Editing
    ShowLabelAgain(EdtBibArtist, GetCorrespondingLabel(EdtBibArtist));
    ShowLabelAgain(EdtBibTitle , GetCorrespondingLabel(EdtBibTitle ));
    ShowLabelAgain(EdtBibAlbum , GetCorrespondingLabel(EdtBibAlbum ));
    ShowLabelAgain(EdtBibTrack , GetCorrespondingLabel(EdtBibTrack ));
    ShowLabelAgain(EdtBibYear  , GetCorrespondingLabel(EdtBibYear  ));
    ShowLabelAgain(EdtBibGenre , GetCorrespondingLabel(EdtBibGenre ));
    MemoDisableTimer.Enabled := True;

    if Sender = ImgDetailCover then
    begin
        GetCursorPos(Point);
        CoverDetails_Popup.Popup(Point.X, Point.Y+10);
    end;
end;

procedure TNemp_MainForm.ImgDetailCoverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CoverImgDownX := X;
    CoverImgDownY := Y;
end;


procedure TNemp_MainForm.ImgDetailCoverMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var af: TAudioFile;
begin
    if ssleft in shift then
    begin
      if (abs(X - CoverImgDownX) > 5) or  (abs(Y - CoverImgDownY) > 5) then
      begin
          if Sender = HeadSetCoverImage then
              af := NempPlayer.HeadSetAudioFile
          else
          if Sender = ImgDetailCover then
              af := MedienBib.CurrentAudioFile
          else
              af := Nil;

          if Assigned(af) then
          begin
              DragSource := DS_VST;
              // Add files selected to DragFilesSrc1 list
              DragFilesSrc1.ClearFiles;
              DragDropList.Clear;
              DragFilesSrc1.AddFile(af.Pfad);
              DragDropList.Add(af.Pfad);
              // This is the START of the drag (FROM) operation.
              DragFilesSrc1.Execute;
          end;
      end;
    end
    else
    begin
        CoverImgDownX := 0;
        CoverImgDownY := 0;
    end;
end;

procedure TNemp_MainForm.VDTCoverInfoPanelResize(Sender: TObject);
begin
    LblBibTags.Width := VDTCoverInfoPanel.Width - 18;
    LblBibTags.Height := VDTCoverInfoPanel.Height - LblBibTags.Top - 2;
end;

procedure TNemp_MainForm.VDTCoverResize(Sender: TObject);
var dim: Integer;
begin
    case NempOptions.DetailMode of
        0: //Disabled
        begin
            VDTCoverInfoPanel.Visible := False;
            dim := VDTCover.Width;
            if dim > 250 then
                dim := 250;
            if dim > VDTCover.Height then
                dim := VDTCover.Height;
            ImgDetailCover.Width  := dim;
            ImgDetailCover.Height := dim;
        end;
        1: //Aside
        begin
            dim := Round(NempOptions.NempFormRatios.VDTCoverWidth / 100 * VDTCover.Width);
            if dim > 250 then
                dim := 250;
            if dim > VDTCover.Height then
                dim := VDTCover.Height;

            VDTCoverInfoPanel.Visible := True;
            ImgDetailCover.Width  := dim;
            ImgDetailCover.Height := dim;

            VDTCoverInfoPanel.Top := 2;
            VDTCoverInfoPanel.Left := dim + 4;
            VDTCoverInfoPanel.Width :=  VDTCover.Width - dim - 8;
            VDTCoverInfoPanel.Height := VDTCover.Height - VDTCoverInfoPanel.Top;
        end;
        2: //Below
        begin           //  VDTCoverHeight
            dim := Round(NempOptions.NempFormRatios.VDTCoverHeight / 100 * VDTCover.Height);
            if dim > VDTCover.Width then
                dim := VDTCover.Width;
            if dim > 250 then
                dim := 250;

            VDTCoverInfoPanel.Visible := True;
            ImgDetailCover.Width  := dim;
            ImgDetailCover.Height := dim;

            VDTCoverInfoPanel.Top := 2;
            VDTCoverInfoPanel.Left := ImgDetailCover.Left;

            VDTCoverInfoPanel.Top := ImgDetailCover.Top + ImgDetailCover.Height + 4;
            VDTCoverInfoPanel.Width :=  VDTCover.Width - 8;
            VDTCoverInfoPanel.Height := VDTCover.Height - VDTCoverInfoPanel.Top;
        end;
    end;
    NempOptions.CoverWidth := VDTCover.Width;

    // Disable Editing
    ShowLabelAgain(EdtBibArtist, GetCorrespondingLabel(EdtBibArtist));
    ShowLabelAgain(EdtBibTitle , GetCorrespondingLabel(EdtBibTitle ));
    ShowLabelAgain(EdtBibAlbum , GetCorrespondingLabel(EdtBibAlbum ));
    ShowLabelAgain(EdtBibTrack , GetCorrespondingLabel(EdtBibTrack ));
    ShowLabelAgain(EdtBibYear  , GetCorrespondingLabel(EdtBibYear  ));
    ShowLabelAgain(EdtBibGenre , GetCorrespondingLabel(EdtBibGenre ));
    LblBibTags.Visible := True;
    MemBibTags.Visible := False;
    BtnApplyEditTags.Visible := False;
    BtnCancelEditTags.Visible := False;
end;

procedure TNemp_MainForm.ImgBibRatingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i: Integer;
    aErr: TNempAudioError;
begin
    if      (not NempSkin.NempPartyMode.DoBlockTreeEdit)
        and (Button = mbLeft)
    then
    begin
        if Assigned(MedienBib.CurrentAudioFile)
           and (MedienBib.StatusBibUpdate <= 1)
           and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
        then
        begin
              ListOfFiles := TObjectList.Create(False);
              try
                  // get List of this AudioFile
                  GetListOfAudioFileCopies(MedienBib.CurrentAudioFile, ListOfFiles);
                  // edit all these files
                  for i := 0 to ListOfFiles.Count - 1 do
                  begin
                      listFile := TAudioFile(ListOfFiles[i]);
                      listFile.Rating := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
                  end;
                  // write the rating into the file on disk
                  aErr := MedienBib.CurrentAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                  HandleError(afa_SaveRating, MedienBib.CurrentAudioFile, aErr);
                  
                  MedienBib.Changed := True;
              finally
                  ListOfFiles.Free;
              end;
              // Correct GUI (player, Details, Detailform, VSTs))
              CorrectVCLAfterAudioFileEdit(MedienBib.CurrentAudioFile);
        end else
        begin
            TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
        end;
    end;
end;

procedure TNemp_MainForm.ImgBibRatingMouseLeave(Sender: TObject);
begin
    if (not NempSkin.NempPartyMode.DoBlockTreeEdit)
    then
    begin
        if Assigned(MedienBib.CurrentAudioFile) then
            BibRatingHelper.DrawRatingInStarsOnBitmap(MedienBib.CurrentAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height)
        else
            BibRatingHelper.DrawRatingInStarsOnBitmap(128, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
    end;
end;

procedure TNemp_MainForm.ImgBibRatingMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var rat: Integer;
begin
  if (not NempSkin.NempPartyMode.DoBlockTreeEdit)
  then
  begin
      // draw stars according to current mouse position
      rat := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
      BibRatingHelper.DrawRatingInStarsOnBitmap(rat, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
  end
end;



procedure TNemp_MainForm.PM_Cover_DontShowDetailsClick(Sender: TObject);
begin
    Nemp_MainForm.NempOptions.DetailMode := (Sender as TMenuItem).Tag;
    Nemp_MainForm.ActualizeVDTCover;
end;



procedure TNemp_MainForm.ImgDetailSwitchClick(Sender: TObject);
begin

end;

// Show the corresponding TEdit and set the Caption
procedure TNemp_MainForm.AdjustEditToLabel(aEdit: TControl; aLabel: TLabel);
var w: Integer;
begin
    if not Assigned(MedienBib.CurrentAudioFile) then
        exit;

    aEdit.Top := aLabel.Top - 4;
    aEdit.Left := aLabel.Left - 4;

    // Necessary here: (Re)Set aEdit.Text
    if Assigned(MedienBib.CurrentAudioFile) then
    begin
        EdtBibArtist    .Text := MedienBib.CurrentAudioFile.GetReplacedArtist(NempOptions.ReplaceNAArtistBy);
        EdtBibTitle     .Text := MedienBib.CurrentAudioFile.GetReplacedTitle(NempOptions.ReplaceNATitleBy);
        EdtBibAlbum     .Text := MedienBib.CurrentAudioFile.GetReplacedAlbum(NempOptions.ReplaceNAAlbumBy);
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

    if w + aEdit.Left > VDTCoverInfoPanel.Width then
        w := VDTCoverInfoPanel.Width - aEdit.Left;
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

procedure TNemp_MainForm.HideTagMemo;
begin
    LblBibTags.Visible := True;
    MemBibTags.Visible := False;
    BtnApplyEditTags.Visible := False;
    BtnCancelEditTags.Visible := False;
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
    if    (not Assigned(MedienBib.CurrentAudioFile))
       or (not NempOptions.AllowQuickAccessToMetadata)
       or NempSkin.NempPartyMode.DoBlockTreeEdit
    then
        exit;

    if MedienBib.CurrentAudioFile.HasSupportedTagFormat then
        AdjustEditToLabel(GetCorrespondingEdit(Sender as TLabel), Sender as TLabel);
end;
procedure TNemp_MainForm.LblBibTagsClick(Sender: TObject);
begin
    if (not Assigned(MedienBib.CurrentAudioFile))
        or NempSkin.NempPartyMode.DoBlockTreeEdit
        or (not NempOptions.AllowQuickAccessToMetadata)
    then
        exit;

    if MedienBib.CurrentAudioFile.HasSupportedTagFormat then
    begin
        MemBibTags.Top := LblBibDuration.Top;
        MemBibTags.Left := LblBibDuration.Left - 4;
        MemBibTags.Width := min(200, VDTCoverInfoPanel.Width - MemBibTags.Left);
        MemBibTags.Height := min(150, VDTCoverInfoPanel.Height - MemBibTags.Top );


        BtnApplyEditTags.Top  := MemBibTags.Top - 19; //+ MemBibTags.Height - 21;
        BtnApplyEditTags.Left := MemBibTags.Left + MemBibTags.Width - 28;

        BtnCancelEditTags.Top  := MemBibTags.Top - 19; //+ MemBibTags.Height - 21;
        BtnCancelEditTags.Left := MemBibTags.Left + MemBibTags.Width - 28 - 29;

        MemBibTags.Text := String(MedienBib.CurrentAudioFile.RawTagLastFM);

        LblBibTags.Visible := False;
        MemBibTags.Visible := True;
        BtnApplyEditTags.Visible := True;
        BtnCancelEditTags.Visible := True;

        MemBibTags.SetFocus;
    end;
end;

procedure TNemp_MainForm.BtnABRepeatClick(Sender: TObject);
begin
    if NempPlayer.ABRepeatActive then
        NempPlayer.RemoveABSyncs
    else
        NempPlayer.SetABSyncs(NempPlayer.Progress, -1);
    CorrectVCLForABRepeat;
end;

procedure TNemp_MainForm.PM_ABRepeatSetAClick(Sender: TObject);
begin
    NempPlayer.SetASync(NempPlayer.Progress);
    CorrectVCLForABRepeat;
end;

procedure TNemp_MainForm.PM_ABRepeatSetBClick(Sender: TObject);
begin
    NempPlayer.SetBSync(NempPlayer.Progress);
    CorrectVCLForABRepeat;
end;

procedure TNemp_MainForm.BtnApplyEditTagsClick(Sender: TObject);
var ListOfFiles: TObjectList;
    ListFile, BibFile: TAudioFile;
    i: Integer;
    aErr: TNempAudioError;
    backup: UTF8String;
begin
    if Assigned(MedienBib.CurrentAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
    then
    begin
        if Sender = BtnApplyEditTags then   // else: it was the Cancel-Button
        begin
            backup := MedienBib.CurrentAudioFile.RawTagLastFM;
            if CommasInString(MemBibTags.Text) then
            begin
                if TranslateMessageDLG((Tags_CommasFound), mtConfirmation, [MBYES, MBNO], 0) = mrYes then
                    MedienBib.CurrentAudioFile.RawTagLastFM := UTF8String(Trim(ReplaceCommasbyLinebreaks(Trim(MemBibTags.Text))))
                else
                    MedienBib.CurrentAudioFile.RawTagLastFM := UTF8String(Trim(MemBibTags.Text));
            end
            else
                MedienBib.CurrentAudioFile.RawTagLastFM := UTF8String(Trim(MemBibTags.Text));

            // write Data to the file
            aErr := MedienBib.CurrentAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
            if aErr = AUDIOERR_None then
            begin                
                // Generate a List of Files which should be updated now
                ListOfFiles := TObjectList.Create(False);
                try
                    GetListOfAudioFileCopies(MedienBib.CurrentAudioFile, ListOfFiles);
                    for i := 0 to ListOfFiles.Count - 1 do
                    begin
                        listFile := TAudioFile(ListOfFiles[i]);
                        listFile.RawTagLastFM := MedienBib.CurrentAudioFile.RawTagLastFM;
                    end;
                finally
                    ListOfFiles.Free;
                end;
                // Correct GUI (player, Details, Detailform, VSTs))
                CorrectVCLAfterAudioFileEdit(MedienBib.CurrentAudioFile);
                // Update the TagCloud
                BibFile := MedienBib.GetAudioFileWithFilename(MedienBib.CurrentAudioFile.Pfad);
                if assigned(BibFile) then
                    MedienBib.TagCloud.UpdateAudioFile(BibFile);
            end else
            begin
                MedienBib.CurrentAudioFile.RawTagLastFM := backup;
                HandleError(afa_EditingDetails, MedienBib.CurrentAudioFile, aErr);
                TranslateMessageDLG(AudioErrorString[aErr], mtWarning, [MBOK], 0);
            end;

            LblBibTags.Caption := MedienBib.CurrentAudioFile.GetTagDisplayString(NempOptions.AllowQuickAccessToMetadata);
        end;
    end;
    HideTagMemo;
end;

procedure TNemp_MainForm.MemBibTagsKeyPress(Sender: TObject; var Key: Char);
begin
    case Ord(key) of
        VK_Escape: begin
              key := #0;
              HideTagMemo;
        end;
    end;
end;

procedure TNemp_MainForm.MemBibTagsExit(Sender: TObject);
begin
    // ok, this is a BAAAAAD hack.
    // We want the memo to be closed like the edits,
    // but we have to allow a "OK-ButtonClick"
    // (which will cause an Memo-Exit first, which will hide the Button)
    MemoDisableTimer.Enabled := True;
end;
procedure TNemp_MainForm.MemoDisableTimerTimer(Sender: TObject);
begin
    MemoDisableTimer.Enabled := False;
    HideTagMemo;
end;



procedure TNemp_MainForm.EdtBibArtistExit(Sender: TObject);
begin
    ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
end;
procedure TNemp_MainForm.EdtBibArtistKeyPress(Sender: TObject; var Key: Char);
var ListOfFiles: TObjectList;
    listFile, backupFile: TAudioFile;
    i: Integer;
    aErr: TNempAudioError;
begin
    case Ord(key) of
        VK_Escape: begin
              key := #0;
              ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
        end;
        VK_RETURN: begin
              if Assigned(MedienBib.CurrentAudioFile)
                  and (MedienBib.StatusBibUpdate <= 1)
                  and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
              then
              begin
                  backupFile := TAudioFile.Create;
                  try                      
                      backupFile.Assign(MedienBib.CurrentAudioFile);
                      // Change current File
                      case (Sender as TComponent).Tag of
                          0: MedienBib.CurrentAudioFile.Artist := EdtBibArtist.Text;
                          1: MedienBib.CurrentAudioFile.Titel  := EdtBibTitle.Text;
                          2: MedienBib.CurrentAudioFile.Album  := EdtBibAlbum.Text;
                          3: MedienBib.CurrentAudioFile.Track  := StrToIntDef(EdtBibTrack.Text, 0);
                          4: MedienBib.CurrentAudioFile.Year   := EdtBibYear.Text;
                          5: MedienBib.CurrentAudioFile.Genre  := EdtBibGenre.Text;
                      end;

                      // write Data to file                                                    
                      aErr := MedienBib.CurrentAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                      if aErr = AUDIOERR_None  then
                      begin
                          // Generate a List of Files which should be updated now
                          ListOfFiles := TObjectList.Create(False);
                          try                  
                              GetListOfAudioFileCopies(MedienBib.CurrentAudioFile, ListOfFiles);
                              // edit these files
                              for i := 0 to ListOfFiles.Count - 1 do
                              begin
                                  // recycle var bibfile here
                                  listFile := TAudioFile(ListOfFiles[i]);
                                  // set the matching property of the files
                                  case (Sender as TComponent).Tag of
                                      0: listFile.Artist := EdtBibArtist.Text;
                                      1: listFile.Titel  := EdtBibTitle.Text;
                                      2: listFile.Album  := EdtBibAlbum.Text;
                                      3: listFile.Track  := StrToIntDef(EdtBibTrack.Text, 0);
                                      4: listFile.Year   := EdtBibYear.Text;
                                      5: listFile.Genre  := EdtBibGenre.Text;
                                  end;
                              end;                          
                          finally
                              ListOfFiles.Free;
                          end;
                      end else
                      begin
                          MedienBib.CurrentAudioFile.Assign(backupFile);
                          HandleError(afa_EditingDetails, MedienBib.CurrentAudioFile, aErr);
                          TranslateMessageDLG(AudioErrorString[aErr], mtWarning, [MBOK], 0);
                      end;
                  finally
                      backupFile.Free;
                  end;
                  //  FillBibDetailLabels(MedienBib.CurrentAudioFile);
                  // Correct GUI (player, Details, Detailform, VSTs))
                  CorrectVCLAfterAudioFileEdit(MedienBib.CurrentAudioFile);
                  MedienBib.Changed := True;

                  ShowLabelAgain(Sender as TControl, GetCorrespondingLabel(Sender as TControl));
              end
              else
              begin
                  TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
              end;
              key := #0;
        end;
    end;
end;

function TNemp_MainForm.ValidAudioFile(filename: UnicodeString; JustPlay:Boolean):boolean;
var extension: string;
begin
  extension := AnsiLowerCase(ExtractFileExt(filename));

  if Justplay then
  begin
    // this test is for the playlist
    result := (Extension <> '.m3u') AND (Extension <> '.m3u8')
          AND (Extension <> '.pls') AND (Extension <> '.gmp')
          AND (Extension <> '.cue') AND (Extension <> '.npl')
          AND (Extension <> '.asx') AND (Extension <> '.wax')
          ;
  end
  else // Aufnahme in die Medienliste verlangt, und nicht "alles rein" in den Optionen gewählt
  // also genauer prüfen
  begin
      if extension = '.cda' then
          result := false
      else
      begin
          if MedienBib.IncludeAll then
              // include any valid extension
              result := NempPlayer.ValidExtensions.IndexOf(extension) > -1
          else
              // include files as given in the Bib.Filterstring
              result := pos('*'+Extension, MedienBib.IncludeFilter) > 0;
      end;
  end;
end;

procedure TNemp_MainForm.PM_ML_GetLyricsClick(Sender: TObject);
var i:integer;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
begin
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        TranslateMessageDLG((Medialibrary_GUIError5), mtInformation, [MBOK], 0);
    end else
    begin
        if not GetSpecialPermissionToChangeMetaData then exit;

        MedienBib.StatusBibUpdate := 1;
        BlockeMedienListeUpdate(True);

        SelectedMP3s := VST.GetSortedSelection(False);
        for i:=0 to length(SelectedMP3s)-1 do
        begin
            Data := VST.GetNodeData(SelectedMP3s[i]);
            MedienBib.UpdateList.Add(Data^.FAudioFile);
        end;

        MedienBib.GetLyrics;
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
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        TranslateMessageDLG((Medialibrary_GUIError5), mtInformation, [MBOK], 0);
    end else
    begin
        if not GetSpecialPermissionToChangeMetaData then exit;

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
var Data: PTreeData;
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

      if (Node = NempPlaylist.LastHighlightedSearchResultNode) then
      begin
        if NempSkin.isActive then
            Pen.Color := NempSkin.SkinColorScheme.PlaylistPlayingFileColor
        else
            Pen.Color := clGradientActiveCaption;
        pen.Width := 1;//3;
        pen.Style := psDot;

        Polyline([Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent) * Integer(PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1),
              Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Top+1),
              Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1)]
              );
      end;



      Data := PlaylistVST.GetNodeData(Node);
      if assigned(Data) then
      begin
          if TAudioFile(Data^.FAudioFile).PrebookIndex > 0 then
          begin
              // Clear the area
              //brush.Color := PlaylistVST.Color;
              //Fillrect(Rect(ItemRect.Left+PlaylistVST.Indent, ItemRect.Top, ItemRect.Left+2*PlaylistVST.Indent, ItemRect.Bottom));
              // Paint the Index of the file
              Brush.Style := bsClear;
              Font.Size := 8; // fixed size. Otherwise the Indent can be to small
              Font.Style := [fsUnderline];
              TextOut(ItemRect.Left + Integer(PlaylistVST.Indent), ItemRect.Top,
                      IntTostr(TAudioFile(Data^.FAudioFile).PrebookIndex));
          end;
      end;
  end;
end;

procedure TNemp_MainForm.StringVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var Data: PStringTreeData;
begin
  Data:=Sender.GetNodeData(Node);
  if assigned(Data) then
  begin
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
  end else
      CellText := '';
end;


procedure TNemp_MainForm.ReFillBrowseTrees(RemarkOldNodes: LongBool);
var ArtistNode, AlbumNode: PVirtualNode;
  ArtistData, AlbumData: PStringTreeData;
  Artist, Album: UnicodeString;
begin

  case MedienBib.BrowseMode of
      0:  begin
                // erneuert nach einer Einfüge/Lösch/Edit-aktion die oberen beiden Listen
                // die alten Knoten werden nach Möglichkeit wieder selektiert/focussiert
                // Change auf Nil setzen
                ArtistsVST.OnFocusChanged := NIL;
                AlbenVST.OnFocusChanged := NIL;

                // linke Liste füllen
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
      end;
      1: begin
                // Coverflow
                If MedienBib.Coverlist.Count > 3 then
                    CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                else
                    CoverScrollbar.Max := 3;
                MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
                CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
                CoverScrollbarChange(Nil);
                MedienBib.NewCoverFlow.Paint(10);
      end;
      2: begin
                // 1. Backup Breadcrumbs (current navigation)
                if RemarkOldNodes then
                    MedienBib.TagCloud.BackUpNavigation;

                // 2. Rebuild TagCloud
                MedienBib.ReBuildTagCloud;

                // 3. Restore BreadCrumbs
                if RemarkOldNodes then
                    MedienBib.RestoreTagCloudNavigation;

                // 4. Show Tags
                // No, as ShoTags will select a new focussed Tag MedienBib.TagCloud.ShowTags;
                // 4. Show Files for the current Tag
                MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, False);
      end;
  end;
  SetBrowseTabWarning(False);
  SetBrowseTabCloudWarning(False);
end;


procedure TNemp_MainForm.RefreshCoverFlowTimerTimer(Sender: TObject);
begin
    RefreshCoverFlowTimer.Enabled := False;
    if Not MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow then
        exit;

    MedienBib.ReBuildCoverListFromList(MedienBib.AnzeigeListe, MedienBib.AnzeigeListe2);

    CoverScrollbar.OnChange := Nil;
    If MedienBib.Coverlist.Count > 3 then
        CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
    else
        CoverScrollbar.Max := 3;

    MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist, True);
    CoverScrollbar.OnChange := CoverScrollbarChange;
    MedienBib.NewCoverFlow.Paint(10);
end;

procedure TNemp_MainForm.ArtistsVSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin

  TargetCanvas.font.Style := Nemp_MainForm.NempOptions.ArtistAlbenFontStyles;

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
  // Könnte sein, dass jetzt Artist <Alle> markiert ist
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
  // Der Index kann erst hier bestimmt werden, da sich die Alben liste geändert hat!
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

  // OnChange wieder umsetzen? Muss das überhaupt?
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
    //Result := StrLIComp(PChar(SearchText), PChar(aString), Min(length(SearchText), length(aString)));
    Result := StrLIComp(PChar(SearchText), PChar(aString), length(SearchText));
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
          TranslateMessageDLG(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
      ShowVSTDetails(NIL);
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
      // gewünschten Eigenschaften gefunden hat.
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
            // nächsten Knoten wählen
            nextnode := aTree.GetNext(nextnode);
            // oder vorne wieder anfangen
            if nextnode = NIL then
              nextnode := aTree.GetFirst;
          until erfolg or (nextnode = startnode);
          if not erfolg then result := nextnode;
      end;

begin
  // Das dann der Form.OnKEydown überlassen
  if ssctrl in Shift then exit;

  aTree := Sender as TVirtualStringTree;
  case key of
    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      if not Assigned(aTree.FocusedNode) then Exit;
      // nächstes Vorkommen des Prefixes suchen, dazu: beim nächsten Knoten beginnen
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
              TStation(MedienBib.RadioStationList[AlbumNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist)
          else
              TranslateMessageDLG(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
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
          TStation(MedienBib.RadioStationList[AlbumNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist)
      else
          TranslateMessageDLG(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
  end else
  begin
      if (artist <> BROWSE_PLAYLISTS) then
      begin
          AlbumData := AlbenVST.GetNodeData(albumNode);
          MedienBib.GenerateAnzeigeListe(BROWSE_ALL, TJustAstring(AlbumData^.FString).DataString);
      end;
  end;
end;

// horizontal splitter between Top and VST
procedure TNemp_MainForm.Splitter1Moved(Sender: TObject);
begin
  NempOptions.NempFormRatios.VSTHeight := Round(TopMainPanel.Height / Height * 100);

  if NempSkin.isActive then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetVSTOffsets;
    RepaintPanels;
  end;
end;

// vertical splitter between player and Browse
procedure TNemp_MainForm.Splitter2Moved(Sender: TObject);
begin
  NempOptions.NempFormRatios.BrowseWidth := Round(AuswahlPanel.Width / (Width - PlayerPanel.Width) * 100);

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

//vertical splitter between Artist and Album
procedure TNemp_MainForm.Splitter3Moved(Sender: TObject);
begin
    NempOptions.NempFormRatios.ArtistWidth := Round(ArtistsVST.Width / AuswahlPanel.Width * 100);
end;

procedure TNemp_MainForm.Splitter4CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
    Accept := (NewSize <= 600) And (NewSize >= 130);
end;

// vertical splitter between VST and Cover
procedure TNemp_MainForm.Splitter4Moved(Sender: TObject);
begin
    NempOptions.NempFormRatios.VSTWidth := Round(VDTCover.Width / VSTPanel.Width * 100);
    if NempSkin.isActive then
    begin
        NempSkin.RepairSkinOffset;
        NempSkin.SetVSTOffsets;
        RepaintPanels;
    end;
end;


procedure TNemp_MainForm.BassTimerTimer(Sender: TObject);
begin
  if NempPlayer.BassStatus = BASS_ACTIVE_PLAYING then
  begin
        NempPlayer.DrawInfo(SlideBarButton.Tag = 0);

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

        fspTaskbarPreviews1.InvalidatePreview;
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
    0: cellText := Data^.FAudioFile.PlaylistTitle;
    1:  begin
          if PlaylistVST.GetNodeLevel(Node) = 0 then
              CellText := Data^.FAudioFile.GetDurationForVST
          else
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
//exit;
end;


procedure TNemp_MainForm.VSTEndDrag(Sender, Target: TObject; X, Y: Integer);
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

procedure TNemp_MainForm.SlideBarShapeHeadsetMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  NewPos := SlideBarShapeHeadset.Left + x - (SlidebarButton_Headset.Width Div 2);
  if NewPos <= SlideBarShapeHeadset.Left then
      NewPos := SlideBarShapeHeadset.Left
    else
      if NewPos >= SlideBarShapeHeadset.Left + SlideBarShapeHeadset.Width - SlidebarButton_Headset.Width then
        NewPos := SlideBarShapeHeadset.Left + SlideBarShapeHeadset.Width - SlidebarButton_Headset.Width;

  SlidebarButton_Headset.Left := NewPos;
  NempPlayer.HeadsetProgress := (SlidebarButton_Headset.Left - SlideBarShapeHeadset.Left) / (SlideBarShapeHeadset.Width - SlidebarButton_Headset.Width);


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

procedure TNemp_MainForm.SlidebarButton_HeadsetStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
  with (Sender as TControl) do
  begin
    Begindrag(false);
    ARect.TopLeft :=  (AudioPanel.ClientToScreen(Point(GRPBOXHeadset.Left, GRPBOXHeadset.Top)));
    ARect.BottomRight :=  (AudioPanel.ClientToScreen(Point(GRPBOXHeadset.Left + GRPBOXHeadset.Width, GRPBOXHeadset.Top + GRPBOXHeadset.Height)));
    Tag := 1;
    ClipCursor(@Arect);
  end;
end;

procedure TNemp_MainForm.ab1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
    with (Sender as TControl) do
        Begindrag(false);

    (Sender as TControl).BringToFront;
    SlideBarButton.BringToFront;

    ARect.TopLeft :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left, NewPlayerPanel.Top)));
    ARect.BottomRight :=  (PlayerPanel.ClientToScreen(Point(NewPlayerPanel.Left + NewPlayerPanel.Width, NewPlayerPanel.Top + NewPlayerPanel.Height)));
    SlideBarButton.Tag := 1;
    ClipCursor(@Arect);
end;


procedure TNemp_MainForm.ab1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    ClipCursor(NIL);
    SlideBarButton.Tag := 0;
    NempPlayer.SetABSyncs(
        (ab1.Left + (ab1.Width Div 2) - SlideBarShape.Left - (SlideBarButton.Width Div 2)) / (SlideBarShape.Width - SlideBarButton.Width),
        (ab2.Left + (ab2.Width Div 2) - SlideBarShape.Left - (SlideBarButton.Width Div 2)) / (SlideBarShape.Width - SlideBarButton.Width)
        );
end;

procedure TNemp_MainForm.SlidebarButton_HeadsetKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    vk_up, vk_Right:  NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 5;
    vk_Down, vk_Left: NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 5;
  end;
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
        NempPlayer.DrawTimeFromProgress((SlideBarButton.Left-SlideBarShape.Left) / (SlideBarShape.Width-SlideBarButton.Width));
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
    end else
    if (source = ab1) or (source = ab2) then
    begin
        if (Sender is TNempPanel) then
            NewPos := x - ((source as TControl).Width Div 2)
        else
            NewPos := (Sender as TControl).Left + x - ((source as TControl).Width Div 2);

        if NewPos <= SlideBarShape.Left - ((source as TControl).Width Div 2) + (SlideBarButton.Width Div 2) then
            NewPos := SlideBarShape.Left - ((source as TControl).Width Div 2) + (SlideBarButton.Width Div 2)
        else
            if NewPos >= SlideBarShape.Width  + SlideBarShape.Left - SlideBarButton.Width - ((source as TControl).Width Div 2) + (SlideBarButton.Width Div 2) then
                NewPos := SlideBarShape.Width + SlideBarShape.Left - SlideBarButton.Width - ((source as TControl).Width Div 2) + (SlideBarButton.Width Div 2);
        (source as TControl).Left := NewPos;
        NempPlayer.DrawTimeFromProgress(((source as TControl).Left + ((source as TControl).Width Div 2) - SlideBarShape.Left - (SlideBarButton.Width Div 2)) / (SlideBarShape.Width-SlideBarButton.Width));
    end else
    if source = SlidebarButton_Headset then
    begin
        if (Sender is TNempPanel) then
            NewPos := x - (SlidebarButton_Headset.Width Div 2)
        else
            NewPos := (Sender as TControl).Left + x - (SlidebarButton_Headset.Width Div 2);

        if NewPos <= SlideBarShapeHeadset.Left then
            NewPos := SlideBarShapeHeadset.Left
        else
            if NewPos >= SlideBarShapeHeadset.Width  + SlideBarShapeHeadset.Left - SlideBarButton_Headset.Width then
                NewPos := SlideBarShapeHeadset.Width + SlideBarShapeHeadset.Left - SlideBarButton_Headset.Width;
          SlidebarButton_Headset.Left := NewPos;
    end else
    if Source = VolButtonHeadset then
    begin
        if (Sender is TNempPanel) then
            NewPos := y - (VolButtonHeadset.Height Div 2)
        else
            NewPos := (Sender as TControl).Top + y - (VolButtonHeadset.Height Div 2);

        if NewPos <= VolShapeHeadset.Top - (VolButtonHeadset.Height Div 2) then
          NewPos := VolShapeHeadset.Top - (VolButtonHeadset.Height Div 2)
        else
          if NewPos >= VolShapeHeadset.Top + VolShapeHeadset.Height - (VolButtonHeadset.Height Div 2) then
            NewPos := VolShapeHeadset.Top + VolShapeHeadset.Height - (VolButtonHeadset.Height Div 2);
        VolButtonHeadset.Top := NewPos;
        NempPlayer.HeadSetVolume :=
            Round(100-((VolButtonHeadset.Top - VolShapeHeadset.Top + (VolButtonHeadset.Height Div 2))* (100/VolShapeHeadset.Height)));
    end;
end;

procedure TNemp_MainForm.SlideBarButtonEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  NempPlaylist.Progress := (SlideBarButton.Left-SlideBarShape.Left) / (SlideBarShape.Width-SlideBarButton.Width);
  SlideBarButton.Tag := 0;
  ClipCursor(NIL);
end;

procedure TNemp_MainForm.SlidebarButton_HeadsetEndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  NempPlayer.HeadSetProgress := (SlidebarButton_Headset.Left - SlideBarShapeHeadset.Left) / (SlideBarShapeHeadset.Width - SlidebarButton_Headset.Width);
  SlidebarButton_Headset.Tag := 0;
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


procedure TNemp_MainForm.VolButtonHeadsetKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    vk_up, vk_Right:  begin
                        VolTimer.Enabled := False;
                        NempPlayer.VolStep := NempPlayer.VolStep + 1;
                        NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume + 1 + (NempPlayer.VolStep DIV 3);
                        VolTimer.Enabled := True;
                        CorrectVolButton;
                     end;
    vk_Down, vk_Left: begin
                        VolTimer.Enabled := False;
                        NempPlayer.VolStep := NempPlayer.VolStep + 1;
                        NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume - 1 - (NempPlayer.VolStep DIV 3);
                        VolTimer.Enabled := True;
                        CorrectVolButton;
                       end;
  end;
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
      HandleStopAfterTitleClick
  else
      HandleStopNowClick;
end;

procedure TNemp_MainForm.PopupStopPopup(Sender: TObject);
begin
    if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
    begin
        PM_StopAfterTitle.Caption := MainForm_StopMenu_StopAfterTitle;
        PM_StopAfterTitle.ImageIndex := 27;
    end
    else
    begin
        PM_StopAfterTitle.Caption := MainForm_StopMenu_NoStopAfterTitle;
        PM_StopAfterTitle.ImageIndex := 26;
    end;
end;

procedure TNemp_MainForm.PM_StopNowClick(Sender: TObject);
begin
    HandleStopNowClick;
end;

procedure TNemp_MainForm.PM_StopAfterTitleClick(Sender: TObject);
begin
    HandleStopAfterTitleClick;
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
  if (NempPlayer.MainStream = 0) AND (NempPlaylist.Count = 0) and (not assigned(NempPlaylist.PlayingFile)) then
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

procedure TNemp_MainForm.PLayPauseBtnHeadsetClick(Sender: TObject);
begin
    // play current Headset-Track again
    case NempPlayer.BassHeadSetStatus of
        BASS_ACTIVE_PAUSED  : NempPlayer.resumeHeadset;
        BASS_ACTIVE_STOPPED : NempPlayer.PlayInHeadset(nil);
        BASS_ACTIVE_PLAYING : NempPlayer.PauseHeadset;
    end;
end;

procedure TNemp_MainForm.ShowHeadsetDetails(aAudioFile: TAudioFile);
var coverbmp: TBitmap;
    success: Boolean;
    fn: String;
begin
    if assigned(aAudioFile) then
    begin
        LblHeadsetArtist.Caption := aAudioFile.PlaylistTitle;
        SlidebarButton_Headset.Enabled := True;
        SlideBarShapeHeadset.Enabled := True;
        //BtnHeadsetToPlaylist.Enabled := True;
    end else
    begin
        LblHeadsetArtist.Caption := HeadSetLabel_Default1;
        //SlidebarButton_Headset.Enabled := False;
        //SlideBarShapeHeadset.Enabled := False;
        //BtnHeadsetToPlaylist.Enabled := False;
    end;

    Coverbmp := tBitmap.Create;
    try
        Coverbmp.Width := 250;
        Coverbmp.Height := 250;

        // Bild holen - (das ist ne recht umfangreiche Prozedur!!)
        if assigned(aAudioFile) then
            success := GetCover(aAudioFile, Coverbmp)
        else
            success := false;
        // HeadsetCoverImage.Visible := success;
        if success then
        begin
            HeadsetCoverImage.Picture.Bitmap.Assign(Coverbmp);
            HeadsetCoverImage.Refresh;
        end else
        begin
            fn := ExtractFilePath(ParamStr(0)) + 'Images\headset.png';
            if FileExists(fn) then
                HeadsetCoverImage.Picture.LoadFromFile(fn);
        end;
    finally
        Coverbmp.Free;
    end;
end;

procedure TNemp_MainForm.BtnLoadHeadsetClick(Sender: TObject);
begin
    // Play new song in headset
    NempPlayer.PlayInHeadset(MedienBib.CurrentAudioFile);
    // Show Details
    ShowHeadsetDetails(MedienBib.CurrentAudioFile);
end;

procedure TNemp_MainForm.StopHeadSetBtnClick(Sender: TObject);
begin
    NempPlayer.StopHeadset;
end;

procedure TNemp_MainForm.PM_PlayCDAudioClick(Sender: TObject);
var CurrentIdx, i: Integer;
begin
    CurrentIdx := NempPlaylist.Count; // CurrentIdx ist der erwartete Index des ersten neu eingefügten Files

    if not assigned(CDOpenDialog) then
        Application.CreateForm(TCDOpenDialog, CDOpenDialog);

    if CDOpenDialog.ShowModal = mrOK then
    begin
        for i := 0 to CDOpenDialog.Files.Count - 1 do
            NempPlaylist.AddFileToPlaylist(CDOpenDialog.Files[i]);
        if (NempPlaylist.Count > CurrentIdx) then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(CurrentIdx, 0, True);
        end;
    end;


end;

procedure TNemp_MainForm.PM_PlayFilesClick(Sender: TObject);
var CurrentIdx, i: Integer;
begin
    CurrentIdx := NempPlaylist.Count; // CurrentIdx ist der erwartete Index des ersten neu eingefügten Files
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


procedure TNemp_MainForm.SlideBackHeadsetBTNClick(Sender: TObject);
begin
    NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 5;
end;
procedure TNemp_MainForm.SlideForwardHeadsetBTNClick(Sender: TObject);
begin
    NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 5;
end;

procedure TNemp_MainForm.RatingImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var rat: Integer;
begin
  if (not NempSkin.NempPartyMode.DoBlockCurrentTitleRating)
  then
  begin
      // draw stars according to current mouse position
      rat := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);
      Spectrum.DrawRating(rat);
  end;
end;

procedure TNemp_MainForm.RatingImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i: Integer;
    aErr: TNempAudioError;
begin
    if (not NempSkin.NempPartyMode.DoBlockCurrentTitleRating)
        and (Button = mbLeft)  then
    begin
        if Assigned(NempPlayer.MainAudioFile) then
        begin
            if (MedienBib.StatusBibUpdate <= 1)
               and (MedienBib.CurrentThreadFilename <> NempPlayer.MainAudioFile.Pfad)
            then
            begin
                  ListOfFiles := TObjectList.Create(False);
                  try
                      // get List of this AudioFile
                      GetListOfAudioFileCopies(NempPlayer.MainAudioFile, ListOfFiles);
                      // edit all these files
                      for i := 0 to ListOfFiles.Count - 1 do
                      begin
                          listFile := TAudioFile(ListOfFiles[i]);
                          listFile.Rating := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);
                      end;
                      // write the rating into the file on disk
                      aErr := NempPlayer.MainAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                      HandleError(afa_SaveRating, NempPlayer.MainAudioFile, aErr);
                      MedienBib.Changed := True;
                  finally
                      ListOfFiles.Free;
                  end;
                  // Correct GUI (player, Details, Detailform, VSTs))
                  CorrectVCLAfterAudioFileEdit(NempPlayer.MainAudioFile);
            end else
            begin
                TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
            end;
        end; // else nothing to do
    end;
end;

procedure TNemp_MainForm.RatingImageMouseLeave(Sender: TObject);
begin
    if (not NempSkin.NempPartyMode.DoBlockCurrentTitleRating)
    then
    begin
        if assigned(NempPlayer.MainAudioFile) then
            Spectrum.DrawRating(NempPlayer.MainAudioFile.Rating)
        else
            Spectrum.DrawRating(0);
        NewPlayerPanel.Repaint;
    end;
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
                 
// Datei im Headset abspielen
procedure TNemp_MainForm.PM_PL_PlayInHeadsetClick(Sender: TObject);
begin
    // Play new song in headset
    NempPlayer.PlayInHeadset(MedienBib.CurrentAudioFile);
    // Show Details
    TabBtn_Headset.Click;
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
var dir, name: String;
begin

  if NempPlaylist.SuggestSaveLocation(dir, name) then
      PlayListSaveDialog.InitialDir := Dir;
  PlayListSaveDialog.FileName := name;

  if PlayListSaveDialog.Execute then
  begin
    NempPlaylist.SaveToFile(PlayListSaveDialog.FileName, False);

    if AddFileToRecentList(PlayListSaveDialog.FileName) then
        SetRecentPlaylistsMenuItems;
  end;
end;


procedure TNemp_MainForm.PM_PL_ShowInExplorerClick(Sender: TObject);
var
    datei_ordner: UnicodeString;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    Node := PlaylistVST.FocusedNode;
    if not Assigned(Node) then
        Exit;
    Data := PlaylistVST.GetNodeData(Node);
    datei_ordner := Data^.FAudioFile.Ordner;

    // showmessage('/e,/select,"'+Data^.FAudioFile.Pfad+'"');
    if DirectoryExists(datei_ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
                      , PChar('/e,/select,"'+Data^.FAudioFile.Pfad+'"'), '', sw_ShowNormal);
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
        // Wenn diese Datei existiert, dann Audiofile createn und in die Playlist einfügen
        // Sämtliches Einfügen wird in der Insert-Prozedur erledigt!
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
    AktualisiereDetailForm(AudioFile, SD_Playlist, True);

    //if assigned(FDetails) then // sollte aber hier immer so sein ;-)
    //  SetWindowPos(FDetails.Handle,HWND_TOP,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
    AudioFile.ReCheckExistence;
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
      case AudioFile.AudioType of
          at_File: begin
              dauer := dauer + AudioFile.Duration;
              groesse := groesse + AudioFile.Size;
          end;

          at_CDDA: dauer := dauer + AudioFile.Duration; // size is not available
      end;
  end;

  if c = 1 then
      PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountSingle), [c])
                                + SizeToString(groesse)
                                + SekToZeitString(dauer)
  else
      PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountMulti), [c])
                                + SizeToString(groesse)
                                + SekToZeitString(dauer);


  aNode := PlaylistVST.FocusedNode;
  if not Assigned(aNode) then Exit;

  if PlaylistVST.GetNodeLevel(aNode)>0 then exit;

  NempPlaylist.ActualizeNode(aNode, false);

  Data := PlaylistVST.GetNodeData(aNode);
  AudioFile := Data^.FAudioFile;
  ShowVSTDetails(AudioFile);
  AktualisiereDetailForm(AudioFile, SD_PLAYLIST);
end;

procedure TNemp_MainForm.ShowPlayerDetails(aAudioFile: TAudioFile);
var success: Boolean;
begin
  if aAudioFile = NIL then exit;
  if aAudioFile.CoverID = '' then
      MedienBib.InitCover(aAudioFile);

  success := NempPlayer.RefreshCoverBitmap;
  CoverImage.Visible := True;
  CoverImage.Hint := '';
  CoverImage.Picture.Bitmap.Assign(NempPlayer.CoverBitmap);
  if not success then
  begin
      //CheckAndDoCoverDownloaderQuery;
      if MedienBib.CoverSearchLastFM then
          Medienbib.NewCoverFlow.DownloadPlayerCover(aAudioFile);
  end;

  if aAudioFile.Lyrics <> '' then
    LyricsMemo.Text := UTF8ToString(aAudioFile.Lyrics)
  else
    LyricsMemo.Text := (MainForm_Lyrics_NoLyrics);

  //NempTrayIcon.Hint := StringReplace(aAudioFile.Artist + ' - ' + aAudioFile.Titel, '&', '&&&', [rfReplaceAll]);
  NempTrayIcon.Hint := StringReplace(aAudioFile.PlaylistTitle, '&', '&&&', [rfReplaceAll]);
end;

procedure TNemp_MainForm.CorrectSkinRegionsTimerTimer(Sender: TObject);
begin
    CorrectSkinRegionsTimer.Enabled := False;
    NempSkin.SetRegionsAgain;
    MedienBib.NewCoverFlow.SetNewHandle(Nemp_MainForm.PanelCoverBrowse.Handle);
    //ReAcceptDragFiles;
    UpdateFormDesignNeu;

end;


procedure TNemp_MainForm.CoverImageDblClick(Sender: TObject);
begin
  if NempPlaylist.PlayingFile = Nil then Exit;
  AutoShowDetailsTMP := True;
  AktualisiereDetailForm(NempPlaylist.PlayingFile, SD_PLAYLIST, True);
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

    $46: begin
        if (ssCtrl in Shift) then
            EditPlaylistSearch.SetFocus;
    end;

    VK_F3: begin
          if (EditPlaylistSearch.Tag = 1) and (Length(Trim(EditPlaylistSearch.Text)) >= 3) then // search is active
          // scroll into next node
          // if (ssCtrl in Shift) then
          //    NempPlaylist.ScrollToPreviousSearchResult;
          // else
          begin
              // search again (to reselect nodes) ...
              if Length(Trim(EditPlaylistSearch.Text)) >= 2 then
                  NempPlaylist.Search(EditPlaylistSearch.Text, True);
              //if NempPlaylist.Search(EditPlaylistSearch.Text, True) then
              //    NempPlaylist.ScrollToNextSearchResult;
          end;
      end;

    VK_F9: begin
     if (NempPlayer.JingleStream = 0) then
      begin
        Node := PlaylistVST.FocusedNode;
        if not Assigned(Node) then
          Exit;
        Data := PlaylistVST.GetNodeData(Node);
        if Data^.FAudioFile.AudioType = at_File then
            NempPlayer.PlayJingle(Data^.FAudioFile);
      end;
    end;

    VK_F8: begin
        NempPlayer.PlayJingle(Nil);
    end;

    96..105: begin // NumPad 0..9
        NempPlaylist.ProcessKeypress(key - 96, PlaylistVST.FocusedNode);
    end;

    48..57: begin// 0..9
        NempPlaylist.ProcessKeypress(key - 48, PlaylistVST.FocusedNode);
    end;

  end;
end;

procedure TNemp_MainForm.PlaylistVSTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
    VK_F9, VK_F8: NempPlayer.StopJingle;
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
  FillTreeView(MedienBib.AnzeigeListe, Nil);
  ShowSummary;
end;

procedure TNemp_MainForm.NachDiesemDingSuchen1Click(Sender: TObject);
var aNode: pVirtualNode;
    Data: PTreeData;
    newComboBoxString: UnicodeString;
    KeyWords: TSearchKeyWords;
    SearchString: String;
begin
    Medienbib.BibSearcher.SearchOptions.SearchParam := 0;       // = New Search
    Medienbib.BibSearcher.SearchOptions.AllowErrors := False;  // no errors allowed
    KeyWords.General   := '';
    KeyWords.Artist    := '';
    KeyWords.Album     := '';
    KeyWords.Titel     := '';
    KeyWords.Pfad      := '';
    KeyWords.Kommentar := '';
    KeyWords.Lyric     := '';
    KeyWords.Mode      := SEARCH_EXTENDED;

    aNode := VST.FocusedNode;
    if not assigned(aNode) then exit;

    Data := VST.GetNodeData(aNode);
    case (Sender as TMenuItem).Tag of
        1: begin
            KeyWords.Titel  := (Data^.FaudioFile).Titel;
            SearchString := KeyWords.Titel;
        end;
        2: begin
            KeyWords.Artist := (Data^.FaudioFile).Artist;
            SearchString := KeyWords.Artist;
        end;
        3: begin
            KeyWords.Album  := (Data^.FaudioFile).Album;
            SearchString := KeyWords.Album;
        end;
    end;

    if SearchString = '' then
    begin
        // MedienBib.EmptyArtist/Titel/AlbumSearch
        MedienBib.EmptySearch((Sender as TMenuItem).Tag);
    end else
    begin
        newComboBoxString := '';
        StringAdd(newComboBoxString, KeyWords.General  );
        StringAdd(newComboBoxString, KeyWords.Artist   );
        StringAdd(newComboBoxString, KeyWords.Album    );
        StringAdd(newComboBoxString, KeyWords.Titel    );
        StringAdd(newComboBoxString, KeyWords.Pfad     );
        StringAdd(newComboBoxString, KeyWords.Kommentar);
        StringAdd(newComboBoxString, KeyWords.Lyric    );
        if newComboBoxString = '' then
            newComboBoxString := (MainForm_NoSearchKeywords);

        KeyWords.ComboBoxString := newComboBoxString;

        Medienbib.BibSearcher.InitNewSearch(KeyWords);
        Medienbib.BibSearcher.SearchOptions.SkipGenreCheck  := True;
        Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := True;
        MedienBib.CompleteSearch(Keywords);
    end;
end;

procedure TNemp_MainForm.PM_ML_ShowAllIncompleteTaggedFilesClick(
  Sender: TObject);
begin
    MedienBib.EmptySearch(42);
end;


procedure TNemp_MainForm.MM_H_ShowReadmeClick(Sender: TObject);
begin
  if NOT FileExists(ExtractFilePath(Paramstr(0)) + 'readme.txt') then
    TranslateMessageDLG((Error_ReadmeFileNotFound), mtError, [mbOK], 0)
  else
    ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'readme.txt')
                      , nil, nil, SW_SHOWNORMAl);
end;

procedure TNemp_MainForm.MM_PL_DirectoryClick(Sender: TObject);
var newdir: UnicodeString;
    FB: TFolderBrowser;
begin
  if (NempPlaylist.InitialDialogFolder = '') then
      NempPlaylist.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);

  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_PlaylistCaption, NempPlaylist.InitialDialogFolder );
  try
      if fb.Execute then
      begin
          newdir := fb.SelectedItem;
          NempPlaylist.InitialDialogFolder := fb.SelectedItem;

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
            TranslateMessageDLG((Playlist_NotEverything), mtInformation, [MBOK], 0);
      end;
  finally
      fb.Free;
  end;
end;

procedure TNemp_MainForm.PM_PL_AddCDAudioClick(Sender: TObject);
var i: integer;
  Abspielen: Boolean;
begin
    // Playlistlänge merken
    Abspielen := NempPlaylist.Count = 0;

    // Show CD-Open-Dialog, insert files, ...

    if not assigned(CDOpenDialog) then
        Application.CreateForm(TCDOpenDialog, CDOpenDialog);

    if CDOpenDialog.ShowModal = mrOK then
    begin
        for i := 0 to CDOpenDialog.Files.Count - 1 do
            NempPlaylist.AddFileToPlaylist(CDOpenDialog.Files[i]);
    end;

    // ggf. abspielen
    if abspielen AND (NempPlaylist.Count > 0) then
    begin
      //StopAndFree;
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      NempPlaylist.Play(0, 0, True);
    end;

end;

procedure TNemp_MainForm.MM_PL_FilesClick(Sender: TObject);
var i: integer;
  Abspielen: Boolean;
begin
  // Playlistlänge merken
  Abspielen := NempPlaylist.Count = 0;

  // einfügen
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
  aErr: TNempAudioError;
begin
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
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

    if (NempPlaylist.Playlist[i] as TAudioFile).IsFile then
    begin
        AudioFile := MedienBib.GetAudioFileWithFilename((NempPlaylist.Playlist[i] as TAudioFile).Pfad);
        if AudioFile = Nil then
        begin
          AudioFile := TAudioFile.Create;
          aErr := AudioFile.GetAudioData((NempPlaylist.Playlist[i] as TAudioFile).Pfad, GAD_Cover or GAD_Rating);
          HandleError(afa_NewFile, AudioFile, aErr);

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
// var prebookAllowed: Boolean;
begin
  if (PlayListVST.FocusedNode= NIL) then
  begin
    PM_PL_DeleteSelected.Enabled   := False;
    PM_PL_Properties.Enabled := False;
    PM_PL_PlayInHeadset.Enabled := False;
    PM_PL_ExtendedCopyToClipboard.Enabled := False;
  end else begin
    PM_PL_DeleteSelected.Enabled   := True;
    PM_PL_Properties.Enabled := True;
    PM_PL_PlayInHeadset.Enabled := True;
    PM_PL_ExtendedCopyToClipboard.Enabled := True;
  end;

  if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
  begin
      PM_PL_StopAfterCurrentTitle.Caption := MainForm_PlaylistMenu_StopAfterTitle;
      PM_PL_StopAfterCurrentTitle.ImageIndex := 27;
  end
  else
  begin
      PM_PL_StopAfterCurrentTitle.Caption := MainForm_PlaylistMenu_NoStopAfterTitle;
      PM_PL_StopAfterCurrentTitle.ImageIndex := 26;
  end;

  // we could allow more, but this would be enough. ;-)
  //prebookAllowed := PlaylistVST.SelectedCount + NempPlaylist.PrebookCount <= 99;
  //PM_PL_AddToPrebookListEnd.Enabled := prebookAllowed;
  // PM_PL_AddToPrebookListBeginning.Enabled := prebookAllowed;

  If NempPlaylist.Count = 0 then
  begin
      PM_PL_SortBy.Enabled := False;
      PM_PL_SavePlaylist.Enabled := False;
  end else
  begin
      PM_PL_SortBy.Enabled := True;
      PM_PL_SavePlaylist.Enabled := True;
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

      fspTaskbarManager.ProgressState := fstpsNoProgress;
      // kann sein, dass der Player ab und zu mal blockiert - hier dann umsetzen ;-)
      NempPlaylist.AcceptInput := True;
      LangeAktionWeitermachen := False;
      ContinueWithPlaylistAdding := False;
  end;

end;

procedure TNemp_MainForm.PM_ML_CloudEditorClick(Sender: TObject);
begin
    // switch to TagCloud
    if MedienBib.BrowseMode <> 2 then
    begin
        SwitchBrowsePanel(TabBtn_TagCloud.Tag);
        SwitchMediaLibrary(TabBtn_TagCloud.Tag);
    end;
    // navigate to whole library
    MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.ClearTag, True);
    MedienBib.TagCloud.ShowTags(True);

    if not assigned(CloudEditorForm) then
        Application.CreateForm(TCloudEditorForm, CloudEditorForm);
    CloudEditorForm.Show;
end;

procedure TNemp_MainForm.PM_ML_CopyToClipboardClick(Sender: TObject);
var FileString: UnicodeString;
    aVST: TVirtualStringTree;
begin
  if Sender = PM_ML_CopyToClipboard then
      aVST := VST
 else
      aVST :=PlayListVST;

  FileString := GetFileListForClipBoardFromTree(aVST);

  if FileString<>'' then
      CopyFilesToClipboard(FileString);
end;


procedure TNemp_MainForm.PM_PL_MagicCopyToClipboardClick(Sender: TObject);
var FileString: UnicodeString;
    tmpPlaylist: String;
    aVST: TVirtualStringTree;
begin
    if Sender = PM_PL_MagicCopyToClipboard then
        aVST := PlayListVST
    else
        aVST := VST;

    FileString := GetFileListForClipBoardFromTree(aVST);

    if FileString <> '' then
    begin
        tmpPlaylist := WritePlaylistForClipBoard(aVST);
        if tmpPlaylist <> '' then
            FileString := FileString + tmpPlaylist + #0
        else
            TranslateMessageDLG(Warning_MagicCopyFailed, mtInformation, [MBOK], 0);
    end;

    if FileString<>'' then
        CopyFilesToClipboard(FileString);
end;

procedure TNemp_MainForm.PM_ML_PasteFromClipboardClick(Sender: TObject);
var
  f: THandle;
  buffer: array [0..MAX_PATH] of WideChar;
  i, numFiles: Integer;
  AudioFile: TAudiofile;
  JobList: TStringList;
  aErr: TNempAudioError;
begin
  if not Clipboard.HasFormat(CF_HDROP) then
    Exit;

  LangeAktionWeitermachen := True;
  MedienBib.ReInitCoverSearch;

  if Sender = PM_PL_ExtendedPasteFromClipboard then
  begin
        JobList := NempPlaylist.ST_Ordnerlist;
        ST_PLaylist.Mask := GeneratePlaylistSTFilter;
        // NempPlaylist.InsertNode := Nil; // evtl. später nochmal überprüfen!! Evtl. focussed Node? XXXXX
        NempPlaylist.InsertNode := PlaylistVST.FocusedNode;

  end else
  begin
        if MedienBib.StatusBibUpdate = 0 then
        begin
          MedienBib.StatusBibUpdate := 1;
          ST_Medienliste.Mask := GenerateMedienBibSTFilter;
          JobList := MedienBib.ST_Ordnerlist;
        end else
        begin
          TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
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
                        aErr := AudioFile.GetAudioData(buffer, GAD_Cover or GAD_Rating);
                        HandleError(afa_PasteFromClipboard, AudioFile, aErr);
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
        if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verlässt
          NewPos >= AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53} then
            NewPos := AudioPanel.Height - GRPBOXEqualizer.Top - BtnHeight{53}
        else
          ; //NewPos := NewPos;

  DraggingSlideButton.Top := NewPos;

  NempPlayer.SetEqualizer(DraggingSlideButton.Tag, VCLEQToPlayer(DraggingSlideButton.Tag));

  NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsCustom);
  Btn_EqualizerPresets.Caption := (MainForm_BtnEqualizerPresetsCustom);
end;

procedure TNemp_MainForm.GRPBOXHeadsetClick(Sender: TObject);
begin
    try
        FocusControl(SlidebarButton_Headset);
    except

    end;
end;

procedure TNemp_MainForm.GRPBOXHeadsetMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 1;
    SlideBarButton_HeadSet.Left := SlideBarShapeHeadset.Left
          + Round((SlideBarShapeHeadset.Width - SlideBarButton_HeadSet.Width) * NempPlayer.HeadsetProgress);
    // NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume - 1;
    // CorrectVolButton;
end;

procedure TNemp_MainForm.GRPBOXHeadsetMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 1;
    SlideBarButton_HeadSet.Left := SlideBarShapeHeadset.Left
          + Round((SlideBarShapeHeadset.Width - SlideBarButton_HeadSet.Width) * NempPlayer.HeadsetProgress);
    // NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume + 1;
    // CorrectVolButton;
end;

procedure TNemp_MainForm.EqualizerButton1EndDrag(Sender, Target: TObject;
  X, Y: Integer);
begin
  ClipCursor(Nil);
end;

// Prozdur für Alle Images unterhalb der Zeitanzeige
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
        if // Button zuweit unten, dass ein weiteres draggen die TopMAinPanel-Grenzen verlässt
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

// Diese Methode für alle Elemente in der Groupbox setzen - mit Ausnahme des Objektes,
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
// Für beide Echo Buttons
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


procedure TNemp_MainForm.PM_TNA_CloseClick(Sender: TObject);
begin
  close;
end;

procedure TNemp_MainForm.PM_TNA_RestoreClick(Sender: TObject);
begin
  RestoreNemp;
end;

procedure TNemp_MainForm.PM_W_WebServerShowLogClick(Sender: TObject);
begin
    if not assigned(WebServerLogForm) then
        Application.CreateForm(TWebServerLogForm, WebServerLogForm);
    WebServerLogForm.Show;
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
        if (Column = 0) and (Data.FAudioFile.PrebookIndex > 0) then
             ImageIndex := 16 // empty image// nothing ImageIndex := -1
        else
        begin
            case Column of
              0:  begin  // main column
                      if Sender.GetNodeLevel(Node) = 0 then
                      begin
                          if Not Data.FAudioFile.FileIsPresent then
                              imageIndex := 5
                          else
                          begin
                              if Node = NempPlayList.PlayingNode then
                                  case NempPlayer.Status of
                                      PLAYER_ISPLAYING: ImageIndex := 2;
                                      PLAYER_ISPAUSED:  ImageIndex := 3;
                                  else
                                      ImageIndex := 4;
                                  end// Case  NempPlayer.Status
                              else
                              begin
                                  // not the playing node
                                  case Data.FAudioFile.AudioType of
                                      at_Undef  : ImageIndex := 8;
                                      at_File   : ImageIndex := 0;
                                      at_Stream : ImageIndex := 9;
                                      at_CDDA   : ImageIndex := 10;
                                  end;
                              end;
                          end;
                      end;
                end; // case Column
            end;
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
                  if Length(Data^.FAudioFile.RawTagLastFM) > 0 then imageIndex := 11;
              //else imageIndex := 15;
          // Con_Titel: imageIndex := 10;
        end;
      end;
  end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedScanFilesClick(Sender: TObject);
var Node: PVirtualNode;
begin
  LangeAktionWeitermachen := True;

  ClearCDDBCache;
  Node := PlaylistVST.GetFirst;
  while assigned(Node) and LangeAktionWeitermachen do
  begin
      NempPlaylist.ActualizeNode(Node, True);
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

procedure TNemp_MainForm.SetEqualizerByName(aSetting: UnicodeString);
var i, DefIndex: integer;
  preset: single;
  ini: TMeminiFile;
begin
    // DefaultIndex ermitteln (für die voreingestellten Settings, falls die Ini leer ist)
    DefIndex := GetDefaultEqualizerIndex(aSetting);

    // Daten aus Ini laden
    ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        for i := 0 to 9 do
        begin
            preset := Ini.ReadInteger(aSetting, 'EQ'+inttostr(i+1), Round(EQ_DEFAULTPRESETS[DefIndex][i])) / EQ_NEW_FACTOR ;
            NempPlayer.SetEqualizer(i, preset);
            CorrectEQButton(i, False);
        end;
    finally
        ini.Free
    end;

    if SameText(aSetting,EQ_NAMES[0]) then
        NempPlayer.EQSettingName := (MainForm_BtnEqualizerPresetsSelect)
    else
        NempPlayer.EQSettingName := aSetting;
    Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;

end;

procedure TNemp_MainForm.SetEqualizerFromPresetClick(Sender: TObject);
var PresetName: String;
begin
  // Gewählte Einstellung erkennen
  PresetName := (Sender as TMenuItem).Caption;

  SetEqualizerByName(PresetName);
end;

procedure TNemp_MainForm.ButtonNextEQClick(Sender: TObject);
var //currentSetting: String;
    currentIdx, maxIdx, nextIdx: Integer;
    newSetting: String;
    Ini: TMeminiFile;
begin
    // Get the Index of the Current setting
    currentIdx := GetDefaultEqualizerIndex(NempPlayer.EQSettingName);

    // Get next Element
    Ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
    try
        maxIdx := Ini.ReadInteger('Summary', 'Max', 17);

        if (Sender as TButton).Tag = 0 then
        begin
            if currentIdx <= 0 then
                nextIdx := maxIdx
            else
                nextIdx := currentIdx - 1;
        end else
        begin
            if currentIdx >= maxIdx then
                nextIdx := 0
            else
                nextIdx := currentIdx + 1;
        end;

        newSetting := Ini.ReadString('Summary', 'Name'+IntToStr(nextIdx), GetDefaultEQName(nextIdx));
        SetEqualizerByName(newSetting);

    finally
        Ini.Free;
    end;

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
            // Gewählte Einstellung erkennen
            PresetName := (Sender as TMenuItem).Caption;
            if TranslateMessageDLG(Format(MainForm_BtnEqualizerOverwriteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
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
          // Eingabe - solange wiederholen, bis Abbruch oder Eingabe gültig
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
                      Cancel := TranslateMessageDLG(MainForm_EqualizerInvalidInput, mtWarning, [mbOk, mbCancel], 0) = mrCancel
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

                          // Abfrage, ob überschrieben werden soll
                          if NewNameExists then
                          begin
                              GoOn := TranslateMessageDLG(Format(MainForm_BtnEqualizerOverwriteQuery, [NewName]), mtInformation, [mbOk, mbCancel], 0) = mrOK
                          end else
                              GoOn := True;

                          if GoOn then
                          begin
                              // Falls neuer Name: max-Wert um eins erhöhen und reinschreiben
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
                              // Menüs neu initialisieren
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
    if TranslateMessageDLG(Format(MainForm_BtnEqualizerDeleteQuery, [PresetName]), mtInformation, [mbYes, mbNo], 0) = mrYes then
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
              // Idx markiert das Setting, das gelöscht werden soll
              // folgende Settings rücken eins auf
              for i := idx to c-1 do
              begin
                  EQName := Ini.ReadString('Summary', 'Name'+IntToStr(i+1), GetDefaultEQName(i));
                  Ini.WriteString('Summary', 'Name'+IntToStr(i), EQName);
              end;
              // letzten, jetzt überflüssigen Key löschen
              Ini.DeleteKey('Summary', 'Name'+IntToStr(c));
              // max-Wert verkleinern
              Ini.WriteInteger('Summary', 'Max', c-1);
              // ungültige Section löschen
              Ini.EraseSection(PresetName);
              try
                  // Ini speichern
                  Ini.UpdateFile;
              except
                  // Silent Exception
              end;
              // Menüs neu initialisieren
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
  if TranslateMessageDLG((Player_RestoreDefaultEqualizer), mtInformation, [mbOK, mbABORT], 0) = mrAbort then
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

          // ggf. Max erhöhen und Namen in Ini schreiben
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



procedure TNemp_MainForm.VSTHeaderDblClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
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

procedure TNemp_MainForm.PaintFrameDblClick(Sender: TObject);
begin
    if (NempPlayer.MainStream <> 0) then
        ShowVSTDetails(NempPlayer.MainAudioFile);
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
    if (Anzeigemode <> ((Sender as TMenuItem).Tag mod 2)) then
        SwapWindowMode(Anzeigemode + 1);
end;

procedure TNemp_MainForm.MM_O_WizardClick(Sender: TObject);
begin
    if not assigned(Wizard) then
        Application.CreateForm(TWizard, Wizard);
    Wizard.Show;
end;

procedure TNemp_MainForm.PM_P_PartyModeClick(Sender: TObject);
begin
    if NempSkin.NempPartyMode.Active then
    begin
        if not assigned(PasswordDlg) then
            Application.CreateForm(tPasswordDlg, PasswordDlg);
        PasswordDlg.ShowModal;
        if (PasswordDlg.Password.Text = NempSkin.NempPartyMode.Password)
           or (PasswordDlg.Password.Text = 'LSD')   // The Master-Password (I couldn't, resist, @TobiGott ;-))
        then
            NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active
        else
            TranslateMessageDLG(ParrtyMode_WrongPassword, mtError, [mbOK], 0);
    end else
    begin
        if NempSkin.NempPartyMode.ShowPasswordOnActivate then
            TranslateMessageDLG(
                Format(_(ParrtyMode_Password_PromptOnActivate), [NempSkin.NempPartyMode.Password]),
                mtInformation, [mbOK], 0);

        if Anzeigemode = 1 then
        begin
            // Set Compact Mode
            // Party-mode in Separate-Window-Mode is not allowed.
            Anzeigemode := 0;
            UpdateFormDesignNeu;
        end;

        NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active;
    end;
end;


procedure TNemp_MainForm.PlayerTabsClick(Sender: TObject);
var heightaddi: integer;
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
      TabBtn_Headset.GlyphLine := 0;
  end;

  GRPBoxCover.Visible     := (Sender as TControl).Tag = 1;
  GRPBoxLyrics.Visible    := (Sender as TControl).Tag = 2;
  GRPBoxEqualizer.Visible := (Sender as TControl).Tag = 3;
  GRPBoxEffekte.Visible   := (Sender as TControl).Tag = 4;
  GRPBOXHeadset.Visible   := (Sender as TControl).Tag = 5;
  HeadSetTimer.Enabled    := (Sender as TControl).Tag = 5;

  Case (Sender as TControl).Tag of
      1: TabBtn_Cover.GlyphLine := 1;
      2: begin
          LyricsMemo.Top          := 5;
          LyricsMemo.Height       := GRPBoxLyrics.Height - 10;
          TabBtn_Lyrics.GlyphLine := 1;
      end;
      3: TabBtn_Equalizer.GlyphLine := 1;
      4: begin
          DirectionPositionBTN.GlyphLine := DirectionPositionBTN.GlyphLine;
          TabBtn_Effects.GlyphLine := 1;
      end;
      5: begin
          ShowHeadsetDetails(NempPlayer.HeadSetAudioFile);
          TabBtn_Headset.GlyphLine := 1;
          if (AnzeigeMode = 1) and (not NempOptions.NempEinzelformOptions.ErweiterteControlsVisible)  then
          begin
              // Show Headset-Controls
              NempOptions.NempEinzelformOptions.ErweiterteControlsVisible := true;
              PM_P_ViewSeparateWindows_Equalizer.Checked := true;
              MM_O_ViewSeparateWindows_Equalizer.Checked := true;
              ExtendedControlForm.Visible := true;
              FormPosAndSizeCorrect(ExtendedControlForm);
              ReInitDocks;
          end;
      end;
  end; //case

  if ((Sender as TControl).Tag <> 5) and (NempPlaylist.AutoStopHeadset) then
      NempPlayer.PauseHeadset;

  Constraints.MinHeight := TopMainPanel.Constraints.MinHeight + heightaddi;
end;


procedure TNemp_MainForm.TABPanelAuswahlClick(Sender: TObject);
begin
    if MedienBib.Count > 0 then
    begin
        SwitchBrowsePanel((Sender as TControl).Tag);
        SwitchMediaLibrary((Sender as TControl).Tag);
    end;
end;


procedure TNemp_MainForm.PM_ML_MedialibraryExportClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

//deleted Oktober, 9, 2008  SaveDialog1.InitialDir := myFolder;
  SaveDialog1.Filter := (MediaLibrary_CSVFilter) + ' (*.csv)|*.csv';
  if SaveDialog1.Execute then
      if not MedienBib.SaveAsCSV(SaveDialog1.FileName) then
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
end;

procedure TNemp_MainForm.PM_P_CloseClick(Sender: TObject);
begin
  close;
end;


procedure TNemp_MainForm.FormActivate(Sender: TObject);
begin
    fspTaskbarManager.Active := True;
end;

procedure TNemp_MainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (MedienBib.StatusBibUpdate = 0) AND (NempPlaylist.Status = 0);
  if not CanClose then
  begin
      if TranslateMessageDLG((Warning_MedienBibIsBusyOnClose), mtWarning, [MBYes, MBNo], 0) = mrYES then
      begin
          if MedienBib.StatusBibUpdate = 0 then
              // if the dialog was open for a longer time ... ;-)
              CanClose := True
          else
          begin
              MedienBib.CloseAfterUpdate := True;

              ContinueWithPlaylistAdding := False;
              NempPlaylist.ST_Ordnerlist.Clear;
              Medienbib.ST_Ordnerlist.Clear;
              ST_Playlist.Break;
              ST_Medienliste.Break;
              MedienBib.Abort;
              fspTaskbarManager.ProgressState := fstpsNoProgress;
              // kann sein, dass der Player ab und zu mal blockiert - hier dann umsetzen ;-)
              NempPlaylist.AcceptInput := True;
              LangeAktionWeitermachen := False;
          end;
      end;
  end;
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
        TranslateMessageDLG((Warning_TooManyFiles), mtInformation, [MBOK], 0);
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
var i, maxC:integer;
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

            maxC := min(MAX_DRAGFILECOUNT, DateiListe.Count - 1);

            //if DateiListe.Count > MAX_DRAGFILECOUNT then
            //begin
            //  MessageDlg((Warning_TooManyFiles), mtInformation, [MBOK], 0);
            //  FreeAndNil(Dateiliste);
            //  exit;
            //end;

            for i:=0 to maxC do
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
var newHeight, newWidth: Integer;
begin
//  TopMainPanel.Constraints.MaxHeight := Height - 160;

  if AnzeigeMode = 0 then
  begin
      TopMainPanel.Constraints.MaxHeight := Height - 172;

      newHeight := Round(NempOptions.NempFormRatios.VSTHeight / 100 * Height);

      if NewHeight < TopMainPanel.Constraints.MinHeight then
          NewHeight := TopMainPanel.Constraints.MinHeight;

      if Height - NewHeight < 172 then
          NewHeight := Height - 172;

      TopMainPanel.Height := NewHeight;

      newWidth := Round(NempOptions.NempFormRatios.BrowseWidth / 100 * (Width - PlayerPanel.Width));

      if newWidth < 150 then //minimum BrowseList-width
          newWidth := 150;
      AuswahlPanel.Width := newWidth;

      AuswahlPanel.Constraints.MaxWidth := Width - 234 - 150;
      //if Width - 234 - AuswahlPanel.Width < 150 then
      //    AuswahlPanel.Width := Width - 234 - 150;

  end;
end;


procedure TNemp_MainForm.MM_PL_WebStreamClick(Sender: TObject);
var
  NewString: string;
  ClickedOK: Boolean;
begin
  NewString := 'http://';
  ClickedOK := InputQuery(Shoutcast_InputStreamCaption, Shoutcast_InputStreamLabel, NewString);
  if ClickedOK then
  begin
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      // WebRadioInsertMode := PLAYER_ENQUEUE_FILES;// PLAYER_PLAY_NOW;
      NempPlayer.MainStation.URL := NewString;
      NempPlayer.MainStation.TuneIn(NempPlaylist.BassHandlePlaylist);
  end;
end;

procedure TNemp_MainForm.MM_ML_WebradioClick(Sender: TObject);
begin
  if not assigned(FormStreamVerwaltung) then
    Application.CreateForm(TFormStreamVerwaltung, FormStreamVerwaltung);
  FormStreamVerwaltung.show;
end;

procedure TNemp_MainForm.EDITFastSearchEnter(Sender: TObject);
begin
  //if EditFastSearch.Font.Color = clGrayText then
  if EditFastSearch.Tag = 0 then
  begin
      EditFastSearch.OnChange := Nil;
      EditFastSearch.Text := '';
      EditFastSearch.OnChange := EDITFastSearchChange;
  end
  else
      EditFastSearch.SelectAll;
  EditFastSearch.Font.Color := clWindowText;
  EditFastSearch.Font.Style := [];
  EditFastSearch.Tag := 1;
end;

procedure TNemp_MainForm.EDITFastSearchExit(Sender: TObject);
begin
  if Trim(EditFastSearch.Text) = '' then
  begin
    EditFastSearch.Font.Color := clGrayText;
    EditFastSearch.Font.Style := [];
    EditFastSearch.Tag := 0;
    EditFastSearch.OnChange := Nil;
    EditFastSearch.Text := MainForm_GlobalQuickSearch;
    EditFastSearch.OnChange := EDITFastSearchChange;
  end;
end;


//--------------------
// Playlist-Search
//--------------------
procedure TNemp_MainForm.EditPlaylistSearchEnter(Sender: TObject);
begin
    if EditPlaylistSearch.Tag = 0 then
    begin
        EditPlaylistSearch.OnChange := Nil;
        EditPlaylistSearch.Text := '';
        EditPlaylistSearch.OnChange := EditPlaylistSearchChange;
    end
    else
    begin
        EditPlaylistSearch.SelectAll;
        if Length(Trim(EditPlaylistSearch.Text)) >= 3 then
            // do search ...
            NempPlaylist.Search(EditPlaylistSearch.Text)
    end;

    EditPlaylistSearch.Font.Color := clWindowText;
    EditPlaylistSearch.Font.Style := [];
    EditPlaylistSearch.Tag := 1;
end;

procedure TNemp_MainForm.EditPlaylistSearchExit(Sender: TObject);
begin
    if Trim(EditPlaylistSearch.Text) = '' then
    begin
        EditPlaylistSearch.Font.Color := clGrayText;
        EditPlaylistSearch.Font.Style := [];
        EditPlaylistSearch.Tag := 0;
        EditPlaylistSearch.OnChange := Nil;
        EditPlaylistSearch.Text := MainForm_PlaylistSearch;
        EditPlaylistSearch.OnChange := EditPlaylistSearchChange;
    end;
end;

procedure TNemp_MainForm.EditPlaylistSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case key of
      VK_RETURN:
          begin
            key := 0;
            if (ssShift in Shift) then
                NempPlaylist.PlayFocussed(NempPlaylist.LastHighlightedSearchResultNode)
            else
            begin
                if Length(Trim(EditPlaylistSearch.Text)) >= 2 then
                    NempPlaylist.SearchAll(EditPlaylistSearch.Text)
            end;
          end;
      VK_ESCAPE:
          begin
              key := 0;
              EditPlaylistSearch.Text := '';
              NempPlaylist.ClearSearch(True);
          end;
      VK_F3: begin
          // scroll into next node
          // if (ssCtrl in Shift) then
          //    NempPlaylist.ScrollToPreviousSearchResult;
          // else
              //NempPlaylist.ScrollToNextSearchResult;
          if Length(Trim(EditPlaylistSearch.Text)) >= 2 then
              NempPlaylist.Search(EditPlaylistSearch.Text, True);
      end;
  end;
end;

procedure TNemp_MainForm.EditPlaylistSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
    case ord(key) of
        VK_RETURN: key := #0;
    end;
end;

procedure TNemp_MainForm.EditPlaylistSearchChange(Sender: TObject);
begin
    if Trim(EditPlaylistSearch.Text)= '' then
        // Deselect all
        NempPlaylist.ClearSearch(True)
    else
        if Length(Trim(EditPlaylistSearch.Text)) >= 2 then
            // do search ...
            NempPlaylist.Search(EditPlaylistSearch.Text)
end;

procedure TNemp_MainForm.PM_P_ViewStayOnTopClick(Sender: TObject);
begin
  NempOptions.MiniNempStayOnTop := NOT NempOptions.MiniNempStayOnTop;

  PM_P_ViewStayOnTop.Checked     := NempOptions.MiniNempStayOnTop;
  MM_O_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
  RepairZOrder;
end;

procedure TNemp_MainForm.DoFastIPCSearch(aString: UnicodeString);
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;
    MedienBib.IPCSearch(aString);
end;

procedure TNemp_MainForm.DoFastSearch(aString: UnicodeString; AllowErr: Boolean = False);
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;
    MedienBib.GlobalQuickSearch(aString, AllowErr);
end;

procedure TNemp_MainForm.CB_MedienBibGlobalQuickSearchClick(
  Sender: TObject);
begin
    EditFastSearch.Font.Color := clGrayText;
    EditFastSearch.Font.Style := [];
    EditFastSearch.OnChange := Nil;
    EditFastSearch.Text := MainForm_GlobalQuickSearch;
    EditFastSearch.OnChange := EDITFastSearchChange;
    RestoreCoverFlowAfterSearch;
    MedienBib.ShowQuickSearchList;

    EditFastSearch.SetFocus;
end;

procedure TNemp_MainForm.EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
begin
  case ord(key) of
      VK_RETURN:
          begin
            key := #0;
            if Trim(EDITFastSearch.Text)= '' then
            begin
                MedienBib.ShowQuickSearchList;
                RestoreCoverFlowAfterSearch;
            end
            else
            begin
                RefreshCoverFlowTimer.Enabled := False;
                DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter);
                // Restart Timer
                if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
                    AND (MedienBib.BrowseMode = 1)
                then
                    RefreshCoverFlowTimer.Enabled := True;
            end;
          end;
      VK_ESCAPE:
          begin
              key := #0;
              EDITFastSearch.Text := '';
              RestoreCoverFlowAfterSearch;
          end
  end;
end;


procedure TNemp_MainForm.EDITFastSearchChange(Sender: TObject);
begin
  If MedienBib.BibSearcher.QuickSearchOptions.WhileYouType then
  begin
      if Trim(EDITFastSearch.Text)= '' then
      begin
          MedienBib.ShowQuickSearchList;
          RestoreCoverFlowAfterSearch;
      end
      else
          if Length(Trim(EDITFastSearch.Text)) >= 2 then
          begin
              RefreshCoverFlowTimer.Enabled := False;
              DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType);
              if (MedienBib.AnzeigeListe.Count) + (MedienBib.AnzeigeListe2.Count) > 1 then
              begin
                  // Restart Timer
                  if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
                      AND (MedienBib.BrowseMode = 1)
                  then
                      RefreshCoverFlowTimer.Enabled := True;
              end;
          end
          else
          begin
              MedienBib.BibSearcher.DummyAudioFile.Titel := MainForm_SearchQueryTooShort;
              FillTreeViewQueryTooShort(MedienBib.BibSearcher.DummyAudioFile);
          end;
  end;
end;



procedure TNemp_MainForm.FormPaint(Sender: TObject);
begin
  if ((Not BassTimer.Enabled) OR (NOT NempPlayer.UseVisualization))
      And (not NempIsClosing)
  then
      Spectrum.DrawClear;
end;


procedure TNemp_MainForm.PlaylistVSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
var Data: PTreeData;
begin
  Data := Sender.GetNodeData(Node);
  if not assigned(Data) then exit;

  HintText := Data^.FAudioFile.GetHint(NempOptions.ReplaceNAArtistBy,
                           NempOptions.ReplaceNATitleBy,
                           NempOptions.ReplaceNAAlbumBy);
end;

procedure TNemp_MainForm.DragFilesSrc1Dropping(Sender: TObject);
begin
  // Beim Droppen in Nemp wird die Quelle abgeprüft
  // (DragSource), um festzustellen, ob vom VST oder von außerhalb
  // was ankommt. Zuerst muss also geprüft werden, und kurz danach
  // die Quelle wieder auf "Extern" gestellt werden
  // Da es kein Event OnDropped gibt, löse ich das Dirty über einen Timer.
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
  // Parameter für Alphablending zusammstellen
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
      SourceConstantAlpha := BlendIntensity;  // Intensität
      AlphaFormat := 0;
    end;

  // Farbe für Zeile wählen
  AlphaBlendBMP.Canvas.Brush.Color := BlendColor;//RGB(0,0, 0);
  with ItemRect do
    begin
      // Bitmap-Größe einstellen, Bitmap einfärben
      AlphaBlendBMP.Width := Right - Left;
      AlphaBlendBMP.Height := Bottom - Top;
      AlphaBlendBMP.Canvas.FillRect (Rect(0, 0, Width, Height));
      //AlphaBlendBMP.Canvas.FillRect (Rect(0, 0, Right - Left, Bottom - Top));
      // Alphablending durchführen
      Windows.AlphaBlend(TargetCanvas.Handle, Left, Top, Right - Left, Bottom - Top,
                         AlphaBlendBMP.Canvas.Handle, 0, 0, AlphaBlendBMP.Width, AlphaBlendBMP.Height, lBlendParams);
    end;
end;



procedure TNemp_MainForm.SortierAuswahl1POPUPClick(Sender: TObject);
begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
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
    8: begin
            MedienBib.NempSortArray[1] := siFileAge;
            MedienBib.NempSortArray[2] := siAlbum;
            MedienBib.CoverSortOrder := 8;
    end;
    9: begin
            MedienBib.NempSortArray[1] := siFileAge;
            MedienBib.NempSortArray[2] := siArtist;
            MedienBib.CoverSortOrder := 9;
    end;


    // 5: Coverflow - nothing to do here
    100:  begin
            // Weitere Sortierungen - Optionsfenster anzeigen
            if Not Assigned(OptionsCompleteForm) then
              Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.VorauswahlNode;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabView0;
            OptionsCompleteForm.Show;
        end;
  end;

  case (Sender as TMenuItem).Tag of
      0..4, 6..9 : SwitchMediaLibrary(MedienBib.BrowseMode);
      //5 : SwitchMediaLibrary(1);     // CoverFlow
  end;
end;


procedure TNemp_MainForm.AuswahlPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PerForm(WM_SysCommand, $F012 , 0);
end;

procedure TNemp_MainForm.AuswahlPanelResize(Sender: TObject);
begin
    AuswahlStatusLBL.Width := AuswahlFillPanel.Width - 16;
end;

procedure TNemp_MainForm.TntFormDestroy(Sender: TObject);
begin
    try
        CoverScrollbar.WindowProc := OldScrollbarWindowProc;
        LyricsMemo.WindowProc := OldLyricMemoWindowProc;
        AlphaBlendBMP.Free;
        Spectrum.Free;
        NempSkin.Free;
        NempPlaylist.Free;
        NempPlayer.Free;
        MedienBib.Free;
        BibRatingHelper.Free;
        LanguageList.Free;
        NempUpdater.Free;
        FreeAndNil(ErrorLog);
        //DeallocateHWnd(FOwnMessageHandler);
        //ST_Playlist.Free;
        //ST_Medienliste.Free;
    except
        halt;
    end;
end;



procedure TNemp_MainForm.BtnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TNemp_MainForm.BtnHeadsetToPlaylistClick(Sender: TObject);
//var tmp: PvirtualNode;
begin
    if assigned(NempPlayer.HeadSetAudioFile) then
    begin
        case NempPlaylist.HeadSetAction of
            0: begin
                // enqueue (at the end)
                NempPlaylist.InsertNode := NIL;
                NempPlaylist.InsertFileToPlayList(NempPlayer.HeadSetAudioFile);
            end;
            1: begin
                // play(and clear current list)
                NempPlayList.ClearPlaylist;
                NempPlaylist.InsertNode := NIL;
                NempPlaylist.InsertFileToPlayList(NempPlayer.HeadSetAudioFile);
            end;
            2: begin
                // enqueue (in th prebook-list)
                NempPlaylist.GetInsertNodeFromPlayPosition;
                {tmp := }NempPlaylist.InsertFileToPlayList(NempPlayer.HeadSetAudioFile);
                // DONT - Most users dont get it ;-)  NempPlaylist.AddNodeToPrebookList(tmp);
            end;
            3: begin
                  // just play
                  //if FileExists(NempPlayer.HeadSetAudioFile.Pfad) then
                      NempPlaylist.PlayBibFile(NempPlayer.HeadSetAudioFile, NempPlayer.FadingInterval);
            end;
        end;
    end;
end;

procedure TNemp_MainForm.BtnHeadsetPlaynowClick(Sender: TObject);
begin
    if assigned(NempPlayer.HeadSetAudioFile) then
        NempPlaylist.PlayHeadsetFile(NempPlayer.HeadSetAudioFile, NempPlayer.FadingInterval, NempPlayer.HeadsetTime);
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
var reactivate: Boolean;
begin
  NempOptions.NempEinzelFormOptions.AuswahlSucheVisible := NOT NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  PM_P_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  MM_O_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;


                      {$IFDEF USESTYLES}
                      reactivate := False;
                      if  (GlobalUseAdvancedSkin) AND
                          (UseSkin AND NempSkin.UseAdvancedSkin)
                      then
                      begin
                          // deactivate advanced skin temporary
                          TStyleManager.SetStyle('Windows');
                          reactivate := True;
                      end;
                      {$ENDIF}

  AuswahlForm.Visible := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

                      {$IFDEF USESTYLES}
                      if reactivate then
                      begin
                          TStylemanager.SetStyle(NempSkin.name);
                          CorrectSkinRegionsTimer.Enabled := True;
                      end;
                      {$ENDIF}

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
var DlgResult: Integer;
begin
    if NempPlaylist.WiedergabeMode <> NEMP_API_NOREPEAT then
    begin
        DlgResult := TranslateMessageDLG(NempShutDown_AtEndOfPlaylist_Dlg,
            mtWarning, [MBYes, MBNO, MBAbort], 0);
    end else
        DlgResult := mrNone;

    // Exit when user choosed "Cancel"
    if DlgResult = MrAbort then exit;

    // switch mode
    if DlgResult = MrYes then
    begin
        NempPlaylist.WiedergabeMode := NEMP_API_NOREPEAT; //(NempPlaylist.WiedergabeMode + 1) Mod 4;
        SetRepeatBtnGraphics;
    end;

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

    SleepTimer.Enabled := False;
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
  begin
      if TranslateMessageDLG((Playlist_FileNotFound), mtWarning, [MBYES, MBNO, MBABORT], 0) = mrYes then
      begin
          if DeleteFileFromRecentList(idx) then
              SetRecentPlaylistsMenuItems;
      end;
  end;
end;

function TNemp_MainForm.DeleteFileFromRecentList(aIdx: Integer): boolean;
var i: Integer;
begin
    result := (aIdx > 1) and (aIdx < 11);

    if result then
    begin
        // file "aIdx" should be deleted
        for i := aIdx to 9 do
            NempOptions.RecentPlaylists[i] := NempOptions.RecentPlaylists[i+1];
        NempOptions.RecentPlaylists[10] := '';
    end;
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

  // Einfügeposition suchen
  for i := 1 to 10 do
    if (NempOptions.RecentPlaylists[i] = '')  then
    begin
      newpos := i;
      break;
    end;

  // ggf. das erste löschen, die anderen aufrücken
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
            if NempPlayer.ValidExtensions[i] <> '.cda' then
                result := result + ';*' + NempPlayer.ValidExtensions[i];
    end else
        result := MedienBib.IncludeFilter;
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

  if   (NempSkin.NempPartyMode.DoBlockTreeEdit)
    // or (not NempOptions.AllowQuickAccessToMetadata)
  then
      exit; // dont do anything here

  if not self.Active then
      exit;


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
      // in diesem Edit: Bei MouseLeave CancelEdit auslösen
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
    if (NempSkin.NempPartyMode.DoBlockTreeEdit)
    then
        allowed := false
    else
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
                    CON_CD: begin
                        if af.HasSupportedTagFormat then
                        begin
                            ClearShortCuts;
                            allowed := NempOptions.AllowQuickAccessToMetadata;
                        end else
                            allowed := False;
                    end;
                    CON_RATING: begin
                            ClearShortCuts;
                            allowed := True;
                    end;
                else
                    {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
                    CON_PFAD, CON_ORDNER, CON_DATEINAME, CON_LYRICSEXISTING, CON_EXTENSION }
                    allowed := False;
                end;
            end;
        end
        else
            // File does not exist - no editing allowed
            allowed := False;
    end;
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
            /// EditLink := TModStringEditLink.Create;
            EditLink := TStringEditLink.Create;
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
  ListOfFiles: TObjectList;
  listFile: TAudioFile;
  i: Integer;
  aErr: TNempAudioError;
begin
    if (NempSkin.NempPartyMode.DoBlockTreeEdit)
        // or (not NempOptions.AllowQuickAccessToMetadata)
    then
        exit;

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

    if assigned(af)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> af.Pfad)
    then
    begin
        aErr := af.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
        if (aErr = AUDIOERR_None) or (VST.Header.Columns[column].Tag = CON_RATING) then
        begin
            // Generate a List of Files which should be updated now
            ListOfFiles := TObjectList.Create(False);
            try
                GetListOfAudioFileCopies(af, ListOfFiles);
                for i := 0 to ListOfFiles.Count - 1 do
                begin
                    listFile := TAudioFile(ListOfFiles[i]);
                    // Data of the af was set in VSTNewText or TRatingEditLink.EndEdit
                    // copy Data from af to the files in the list.
                    listFile.Assign(af);
                end;
            finally
                ListOfFiles.Free;
            end;        
            MedienBib.Changed := True;
            CorrectVCLAfterAudioFileEdit(af);
        end;
        if (aErr <> AUDIOERR_None) then
        begin

            // Read old Data again, if we edited something else than RATING
            if VST.Header.Columns[column].Tag <> CON_RATING then
            begin
                SynchronizeAudioFile(af, af.Pfad, True);
                TranslateMessageDLG(AudioErrorString[aErr], mtWarning, [MBOK], 0);
                HandleError(afa_DirectEdit, af, aErr, True);
            end else
                HandleError(afa_SaveRating, af, aErr);
                // on Rating-Edit: Just an entry in the Error-Log
        end;
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
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
                    CON_CD: af.CD := NewText;
                else
                    {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
                    CON_PFAD, CON_ORDNER, CON_DATEINAME, CON_LYRICSEXISTING, CON_EXTENSION }
                    // Nothing to do. Something was wrong ;-)
                end;
                // Note: Data will be written into the File in "VSTEdited"
                // TabWarning is don in VSTEdited (CorrectVCLAfterAudioFileEdit)
                // if Not MedienBib.ValidKeys(af) then
                //    SetBrowseTabWarning(True);
            end
            else
                TranslateMessageDLG(Warning_MedienBibBusyThread, mtWarning, [mbOK], 0);
        end
        else
            TranslateMessageDLG(Warning_MedienBibIsBusyEdit, mtWarning, [mbOK], 0);
    end;
end;




procedure TNemp_MainForm.VSTEnter(Sender: TObject);
begin
  AktiverTree := VST;
end;



procedure TNemp_MainForm.RepairZOrder;
begin
  ///02.2017

  if (NempOptions.MiniNempStayOnTop) AND (AnzeigeMode = 1) then
  begin
    // Fenster in den Vordergrund setzen.
    SetWindowPos(Nemp_MainForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

    // ggf. das Detailfenster nach oben holen
//    if assigned(FDetails) and FDetails.CB_StayOnTop.Checked then
//      SetWindowPos(FDetails.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  end
  else
  begin
    // Jetzt die Hautform NICHT in den Vordergrund setzen
    SetWindowPos(Nemp_MainForm.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

    // ggf. das Detailfenster nach oben holen
//    if assigned(FDetails) and FDetails.CB_StayOnTop.Checked then
//      SetWindowPos(FDetails.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
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
    // wird von Options - OK aufgerufen nach Änderung der Cover-Zeugs
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
    // manually call OnResize, to put details below or aside the coverimage
    VDTCoverResize(VDTCover);
end;




procedure TNemp_MainForm.PM_PL_AddToPrebookListBeginningClick(Sender: TObject);
begin
    // NempPlaylist.AddSelectedNodesToPreBookList(pb_Beginning) ;
end;

procedure TNemp_MainForm.PM_PL_AddToPrebookListEndClick(
  Sender: TObject);
begin
    NempPlaylist.AddSelectedNodesToPreBookList(pb_End) ;
end;

procedure TNemp_MainForm.PM_PL_ClearPlaylistClick(Sender: TObject);
begin
    NempPlaylist.ClearPlaylist(False);
end;

procedure TNemp_MainForm.PM_PL_CopyPlaylistToUSBClick(Sender: TObject);
begin
    if not assigned(PlaylistCopyForm) then
        Application.CreateForm(TPlaylistCopyForm, PlaylistCopyForm);

    PlaylistCopyForm.Show;
end;

procedure TNemp_MainForm.PM_PL_RemoveFromPrebookListClick(Sender: TObject);
begin
    NempPlaylist.RemoveSelectedNodesFromPreBookList;
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


Procedure TNemp_MainForm.RepaintPanels;
begin
    try
        // Note this try..except seems to be necessary sometimes
        // (invalid winwdow handle when switching VCL styles)
        RepaintPlayerPanel;

        AudioPanel.Repaint;
        PlaylistPanel.Repaint;
        AuswahlPanel.Repaint;

        if MedienBib.BrowseMode = 2 then
        begin
            PanelTagCloudBrowse.Repaint;
            MedienBib.TagCloud.  ShowTags(False);
        end;

        VSTPanel.Repaint;
        MedienlisteFillPanel.Repaint;
        GRPBOXVST.Repaint;
        VDTCover.Repaint;
        VDTCoverInfoPanel.Repaint;

        AuswahlFillPanel.Repaint;
        PlaylistFillPanel.Repaint;

        AuswahlHeaderPanel.Repaint;
        MedienBibHeaderPanel.Repaint;
        PlayerHeaderPanel.Repaint;
    except
        // nothing
    end;
end;

Procedure TNemp_MainForm.RepaintPlayerPanel;
begin
  if NempSkin.isActive and NOT Nempskin.FixedBackGround then
  begin
    PlayerPanel.Repaint;
    //if NOT _IsThemeActive then // some issues with windows 10 - always paint everything
    //begin
      NewPlayerPanel.Repaint;
      GRPBOXLyrics.Repaint;
      GRPBOXEffekte.Repaint;
      GRPBOXEqualizer.Repaint;
      GRPBOXCover.Repaint;
    //end;
  end;
end;

Procedure TNemp_MainForm.RepaintOtherForms;
begin
  if PlaylistForm.Visible then PlaylistForm.RepaintForm;
  if MedienlisteForm.Visible then MedienlisteForm.RepaintForm;
  if AuswahlForm.Visible then AuswahlForm.RepaintForm;
  if ExtendedControlForm.Visible then ExtendedControlForm.RepaintForm;
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
  // wenn das nciht durch den Timer automatisch gemacht würde.
  // Zeit und Spectrum-Informationen können nicht wieder gezeichnet werden.
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


procedure TNemp_MainForm.NewPlayerPanelClick(Sender: TObject);
begin
    FocusControl(VolButton);
end;


procedure TNemp_MainForm.NewPlayerPanelMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.Volume := NempPlayer.Volume - 1;
    CorrectVolButton;
end;

procedure TNemp_MainForm.NewPlayerPanelMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.Volume := NempPlayer.Volume + 1;
    CorrectVolButton;
end;

procedure TNemp_MainForm.AktualisiereDetailForm(aAudioFile: TAudioFile; Source: Integer; Foreground: Boolean = False);
begin
  if (not NempSkin.NempPartyMode.DoBlockDetailWindow) and AutoShowDetailsTMP then
  begin
    if not assigned(FDetails) then
      Application.CreateForm(TFDetails, FDetails);
    FDetails.ShowDetails(aAudioFile, Source);
    if ForeGround then
        SetForeGroundWindow(FDetails.Handle);
  end;
end;


procedure TNemp_MainForm.TNAMenuPopup(Sender: TObject);
var i: Integer;
  centerIdx, minIdx, maxIdx: Integer;
  aMenuItem: TMenuItem;
begin
  // altes Menu mit Playlist-Einträgen erstellen und neues erstellen
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

    // ggf. den minIdx korrigieren, so dass immer count Einträge da sind
    minIdx := maxIdx - NempPlaylist.TNA_PlaylistCount;
    if minIdx < 0 then minIdx := 0;

    for i := MinIdx to MaxIdx do
    begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.RadioItem := True;
        aMenuItem.AutoCheck := True;
        aMenuItem.Checked := (i=centerIdx) AND assigned(NempPlaylist.PlayingNode);
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

  CorrectVCLForABRepeat;

  //Einige Buttons dis/enablen, je nachdem ob ne URL grade im Player läuft
  tmp := (not NempPlayer.URLStream) and (not NempPlayer.PrescanInProgress);
  SlideBackBTN.Enabled := tmp;
  SlideForwardBtn.Enabled := tmp;
  SlideBarShape.Enabled := tmp;
  SlidebarButton.Enabled := tmp;
  // Geschwindigkeit disablen, das macht bei Streams keinen Sinn
  EffekteLBL3.Enabled := tmp;
  SampleRateLBL.Enabled := tmp;
  SamplerateShape.Enabled := tmp;
  SampleRateButton.Enabled := tmp;
  // Rückwärtsspielen disablen
  DirectionPositionBTN.Enabled := tmp;

  // Anzeigen im Mittelteil:
  if NempPlayer.MainStream = 0 then
  begin
    Application.Title := NEMP_NAME_TASK;
    NempTrayIcon.Hint := 'Nemp - Noch ein mp3-Player';

    // Coveranzeige
    CoverIMage.Visible := False;
    LyricsMemo.Text := (MainForm_Lyrics_NoLyrics);

    Spectrum.DrawRating(0);
    PaintFrame.Hint := '';
  end else
  begin
      NempPlayer.RefreshPlayingTitel;
      PaintFrame.Hint := NempPlayer.MainAudioFile.GetHint(NempOptions.ReplaceNAArtistBy,
                           NempOptions.ReplaceNATitleBy,
                           NempOptions.ReplaceNAAlbumBy);

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
{  BirthdayTimer.Enabled := False;
  if assigned(BirthdayForm) then
    BirthdayForm.Close;

  ReArrangeToolImages;}
end;

procedure TNemp_MainForm.MenuBirthdayStartClick(Sender: TObject);
var timeleft: Integer;
begin
    // Einstellungen lesen
    NempPlayer.ReadBirthdayOptions(SavePath + NEMP_NAME + '.ini');

    if Not NempPlayer.CheckBirthdaySettings then
    begin
          if TranslateMessageDLG((BirthdaySettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
          begin
            if Not Assigned(OptionsCompleteForm) then
                Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.BirthdayNode;
            OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.BirthdayNode] := True;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer6;
            OptionsCompleteForm.Show;
          end;
          exit;
    end;

    if BirthdayTimer.Enabled then
    begin
        timeleft := 0;
        BirthdayTimer.Enabled := False;
        if assigned(BirthdayForm) then
            BirthdayForm.Close;
    end else
    begin
        timeleft := SecondsUntil(NempPlayer.NempBirthdayTimer.StartCountDownTime);
        if timeleft > 120 then
          BirthdayTimer.Interval := 60000
        else
          BirthdayTimer.Interval := 1000;

        BirthdayTimer.Enabled := True;
    end;

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
               mtConfirmation, [mbYes, mbNo], mrYes, 0, asknomore,
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
            // Überprüfen auf SubDirs und diese entfernen
            MedienBib.ScanListContainsSubDirs(aDirList.Strings[i]);
            // Aktuellen Ordner einfügen
            MedienBib.AutoScanDirList.Add(IncludeTrailingPathDelimiter(aDirList.Strings[i]));
          end;
       end;
    end;
  end; // if JobListContainsNewDirs
end;


procedure TNemp_MainForm.VSTPanelResize(Sender: TObject);
var newWidth: Integer;
begin
    // handle QuickSearch-Edit-stuff
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

    // handle ratio VST - Cover
    if NempOptions.CoverMode > 0 then
    begin
        // Cover is visible here
        newWidth := Round(NempOptions.NempFormRatios.VSTWidth / 100 * VSTPanel.Width);
        if newWidth < 100 then
            newWidth := 100;
        VDTCover.Width := newWidth;

    end;

end;

procedure TNemp_MainForm.PlaylistPanelResize(Sender: TObject);
begin
    // handle Search-Edit-stuff
    if PlaylistPanel.Width <= 120 then
    begin
        EditplaylistSearch.Width := 65 - (120 - PlaylistPanel.Width);
    end else
    begin
        EditplaylistSearch.Width := 65;
    end;

    if PlaylistPanel.Parent <> TopMainPanel then
    begin
        PlaylistFillPanel.Left := EditplaylistSearch.Left + EditplaylistSearch.Width + 6;
        PlaylistFillPanel.Width := PlaylistPanel.Width - PlaylistFillPanel.Left - 16;
    end else
    begin
        PlaylistFillPanel.Left := EditplaylistSearch.Left + EditplaylistSearch.Width + 6;
        PlaylistFillPanel.Width := PlaylistPanel.Width - PlaylistFillPanel.Left;
    end;

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
// gewählt wird, wird die Playlist für jede Datei neu gelöscht. das ist erstens nicht unbedingt
// sinnvoll, und zweitens kommt da irgendwas mit irgendwem durcheinander (die Anzahl der Dateien, die
// am Ende in der Playlist sind, ist irgendwie nicht vorhersehbar...???).
// So wird das Löschen der Playlist für einen gewissen Zeitraum verhindert, und alle markierten Dateien
// werden in die Playlist eingefügt.

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
        MedienBib.GenerateAnzeigeListeFromCoverID(aCover.key);

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
    CoverImgDownX := X;
    CoverImgDownY := Y;
    CoverScrollbar.SetFocus;

    MedienBib.NewCoverFlow.Paint(2);
end;

procedure TNemp_MainForm.PanelCoverBrowseMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    if CoverFlowRefreshViewTimer.Enabled then exit;
    MedienBib.NewCoverFlow.CurrentItem := MedienBib.NewCoverFlow.CurrentItem + 1;
    //CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
    CoverFlowRefreshViewTimer.Enabled := True;
end;

procedure TNemp_MainForm.PanelCoverBrowseMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    if CoverFlowRefreshViewTimer.Enabled then exit;
    MedienBib.NewCoverFlow.CurrentItem := MedienBib.NewCoverFlow.CurrentItem - 1;
    //CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
    CoverFlowRefreshViewTimer.Enabled := True;
end;

procedure TNemp_MainForm.CoverFlowRefreshViewTimerTimer(Sender: TObject);
var aCover: tNempCover;
begin
    CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
    aCover := TNempCover(MedienBib.CoverList[CoverScrollbar.Position]);
    MedienBib.GenerateAnzeigeListeFromCoverID(aCover.key);
    Lbl_CoverFlow.Caption := aCover.InfoString;
    CoverFlowRefreshViewTimer.Enabled := False;
end;


procedure TNemp_MainForm.PanelCoverBrowseResize(Sender: TObject);
begin
  if PanelCoverBrowse.Visible then
      MedienBib.NewCoverFlow.Paint;
end;

procedure IncrementalTimerFire(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); pascal;
begin
    // Prefix zurücksetzen
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
    VK_ESCAPE: begin
        ////key := #0;
        ////EDITFastSearch.Text := '';
        // show all covers again
        RestoreCoverFlowAfterSearch;
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
var i, maxC:integer;
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

            maxC := min(MAX_DRAGFILECOUNT, DateiListe.Count - 1);

            //if DateiListe.Count > MAX_DRAGFILECOUNT then
            //begin
            //  //MessageDlg(MESSAGE_TOO_MANY_FILES, mtInformation, [MBOK], 0);
            //  FreeAndNil(Dateiliste);
            //  exit;
            //end;
            for i := 0 to maxC do
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

procedure TNemp_MainForm.Win7TaskBarPopupPopup(Sender: TObject);
var i: Integer;
  centerIdx, minIdx, maxIdx: Integer;
  aMenuItem: TMenuItem;
begin
  // altes Menu mit Playlist-Einträgen erstellen und neues erstellen
  for i := Win7TaskBarPopup.Items.Count - 3 downto 0 do
      Win7TaskBarPopup.Items.Delete(i);

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

    // ggf. den minIdx korrigieren, so dass immer count Einträge da sind
    minIdx := maxIdx - NempPlaylist.TNA_PlaylistCount;
    if minIdx < 0 then minIdx := 0;


    for i := MaxIdx downto MinIdx do
    begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.RadioItem := True;
        aMenuItem.AutoCheck := True;
        aMenuItem.Checked := (i=centerIdx) AND assigned(NempPlaylist.PlayingNode);
        aMenuItem.OnClick := TNA_PlaylistClick;
        aMenuItem.Tag := i;
        aMenuItem.Caption := EscapeAmpersAnd(  TPlaylistFile(NempPlaylist.Playlist[i]).PlaylistTitle);
        Win7TaskBarPopup.Items.Insert(0, aMenuItem);
    end;
  end;
end;


procedure TNemp_MainForm.PM_P_BirthdayOptionsClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
    Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.BirthdayNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.BirthdayNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer6;
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.TabPanelPlaylistClick(Sender: TObject);
var point: TPoint;
begin
    GetCursorPos(Point);
    PlayListPOPUP.Popup(Point.X, Point.Y+10);
end;


procedure TNemp_MainForm.PM_P_DirectoriesRecordingsClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(NempPlayer.DownloadDir)) then
        ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+NempPlayer.DownloadDir+'"'), '', sw_ShowNormal)
  else
        TranslateMessageDLG((Warning_RecordingDirNotFound), mtWarning, [mbOk], 0);
end;

procedure TNemp_MainForm.PM_P_KeyboardDisplayClick(Sender: TObject);
var tmp: String;
begin
    if TranslateMessageDLG((StartG15ToolQuestion), mtInformation, [mbYes,MBNo], 0) = mrYes then
    begin
        if NempOptions.DisplayApp = '' then
            tmp := 'NempG15App.exe'
        else
            tmp := NempOptions.DisplayApp;

        tmp := ExtractFilepath(paramStr(0)) + tmp;
        if FileExists(tmp) then
            shellexecute(Handle,'open',pchar('"' + tmp + '"'),'userstart',NIL,sw_show)
        else
            TranslateMessageDLG((StartG15AppNotFound), mtWarning, [mbOK], 0)
    end;
end;

procedure TNemp_MainForm.PM_P_DirectoriesDataClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(SavePath)) then
      ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"'+SavePath+'"'), '', sw_ShowNormal)
  else
      TranslateMessageDLG((Warning_DataDirNotFound), mtWarning, [mbOk], 0);
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


procedure TNemp_MainForm.AlbenVSTClick(Sender: TObject);
begin
    AlbenVSTFocusChanged(AlbenVST, AlbenVST.FocusedNode, 0);
end;

(*
  // for skinning the [+] and [-] Buttons in teh Treeview
procedure TNemp_MainForm.ArtistsVSTAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  r : TRect;
  nd : PStringTreeData;
  t: Integer;
begin
  nd := Sender.GetNodeData(Node);

  // vsExpanded,          // Set if the node is expanded.
  // vsHasChildren,


  if (vsHasChildren in Node.States) then
  begin
      r := Sender.GetDisplayRect(Node, Column, true, false);

      t := ((Cellrect.Bottom - Cellrect.Top) - (11)) Div 2;

      if vsExpanded in Node.States then
          TreeImages.Draw(TargetCanvas, r.Left-14, t{CellRect.Top}, 1)
      else
          TreeImages.Draw(TargetCanvas, r.Left-14, t{CellRect.Top}, 0)

  end;

end; *)

procedure TNemp_MainForm.ArtistsVSTClick(Sender: TObject);
begin
    ArtistsVSTFocusChanged(ArtistsVST, ArtistsVST.FocusedNode, 0);
end;


procedure TNemp_MainForm.fspTaskbarManagerThumbButtonClick(Sender: TObject;
  ButtonId: Integer);
var point: TPoint;
begin
    case ButtonID of
        0: PlayPrevBTNIMGClick(Nil);
        1: PlayPauseBTNIMGClick(Nil);
        2: StopBTNIMGClick(Nil);
        3: PlayNextBTNIMGClick(NIL);
        4: begin
            NempPlayer.Volume := NempPlayer.Volume - 10;
            CorrectVolButton;
        end;
        5: begin
            NempPlayer.Volume := NempPlayer.Volume + 10;
            CorrectVolButton;
        end;
        42: begin
            if Win7TaskBarPopup.Tag = 0 then
            begin
                GetCursorPos(Point);
                Win7TaskBarPopup.Popup(Point.X, Point.Y-10);
            end else
            begin
                // Post MoudeDown/Up to close the Popup-Menu
                PostMessage(Handle, WM_LBUTTONDOWN, MK_LBUTTON, 0);
                PostMessage(Handle, WM_LBUTTONUP, MK_LBUTTON, 0);
            end;
        end;
    end;
end;

procedure TNemp_MainForm.fspTaskbarPreviews1NeedIconicBitmap(Sender: TObject;
  Width, Height: Integer; var Bitmap: HBITMAP);
begin
    Bitmap := NempPlayer.DrawPreview(Width,Height, NempSkin.isActive);
end;



procedure TNemp_MainForm.MM_H_CheckForUpdatesClick(Sender: TObject);
begin
    NempUpdater.CheckForUpdatesManually;
end;

procedure TNemp_MainForm.MM_H_ErrorLogClick(Sender: TObject);
begin
    if not assigned(FError) then
      Application.CreateForm(TFError, FError);

    FError.Show;
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
        if TranslateMessageDLG((ScrobbleSettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
            if Not Assigned(OptionsCompleteForm) then
                Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
            OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer7;
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
            // Sonst wird der Zeitzähler zurückgesetzt, und Submitten ggf. unterbunden
            if (NempPlayer.MainAudioFile.IsFile) or (NempPlayer.MainAudioFile.IsCDDA) then
            begin
                NempPlayer.NempScrobbler.ChangeCurrentPlayingFile(NempPlayer.MainAudioFile);
                NempPlayer.NempScrobbler.PlaybackStarted;
            end;
        end;
    end else
    begin
        //stop scrobbling
        NempPlayer.NempScrobbler.DoScrobble := False;
        if assigned(OptionsCompleteForm) and (OptionsCompleteForm.Visible) then
        begin
            OptionsCompleteForm.CB_ScrobbleThisSession.Checked := False;
            OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_Offline;
        end;
    end;
    ReArrangeToolImages;
end;

procedure TNemp_MainForm.PM_P_ScrobblerDeactivateClick(Sender: TObject);
begin
{    NempPlayer.NempScrobbler.DoScrobble := False;
    if assigned(OptionsCompleteForm) and (OptionsCompleteForm.Visible) then
    begin
        OptionsCompleteForm.CB_ScrobbleThisSession.Checked := False;
        OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_Offline;
    end;
    ReArrangeToolImages;
}
end;

procedure TNemp_MainForm.PM_P_ScrobblerOptionsClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
      Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer7;
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

procedure TNemp_MainForm.WalkmanImageClick(Sender: TObject);
begin
    if Not Assigned(FormLowBattery) then
      Application.CreateForm(TFormLowBattery, FormLowBattery);

    case FormLowBattery.ShowModal of
        mrOK: begin
            case FormLowbattery.cb_ToDo.ItemIndex of
                0: begin
                    // nothing to do
                end;
                1: begin
                    StopFluttering; // it will start again in 2 minutes. ;-)
                    ReArrangeToolImages;
                end;
                2: begin
                    StopFluttering;
                    ReArrangeToolImages;
                    NempPlayer.UseWalkmanMode := False;
                    WalkmanModeTimer.Enabled := False;
                end;
            end;
        end;
    else
        ; //nothing to do
    end;
end;

procedure TNemp_MainForm.WalkmanModeTimerTimer(Sender: TObject);
var hasBattery: Boolean;
    LoadPercent: Integer;
    factor: integer;
begin
    if GetPowerStatus(hasBattery, LoadPercent) = 0 then
    begin
        if (hasBattery and (LoadPercent <= 10)) then
        begin
            if WalkmanModeTimer.Tag = 0 then
            begin
                WalkmanModeTimer.Tag := 1;
                WalkmanModeTimer.Interval := 1000;
                ReArrangeToolImages;
            end;
            //loadPercent := 5;
            factor := Round((11  -  LoadPercent) * 2.8);

            WalkmanImage.Hint := Format(Hint_BatteryLow, [Loadpercent]);

            // start fluttering
            if Random >= 0.6 then
                NempPlayer.Flutter(Random(factor) / 100 + 1, 1000)  // faster
            else
                NempPlayer.Flutter(1 - (Random(factor)/ 100), 1000) // slower
        end
        else
        begin
            if (WalkmanModeTimer.Tag = 1) then
            begin
                StopFluttering;  // Timer.Tag and .Interval  is set there
                ReArrangeToolImages;
            end;
        end;
    end;
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
    if NempWebServer.Active then
    begin
        // Server deaktivieren
        NempWebServer.Active := False;
        ReArrangeToolImages;

        // Anzeige setzen
        if assigned(OptionsCompleteForm) then
            with OptionsCompleteForm do
            begin
                BtnServerActivate.Caption := WebServer_ActivateServer;
                EdtUsername.Enabled := True;
                EdtPassword.Enabled := True;
            end;
    end else
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
            TranslateMessageDLG('Server activation failed:' + #13#10 + NempWebServer.LastErrorString, mtError, [mbOK], 0);
        end;
    end
end;

procedure TNemp_MainForm.MM_T_WebServerDeactivateClick(Sender: TObject);
begin
   { if NempWebServer.Active then
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
            end;
            ReArrangeToolImages;
    end;    }
end;

procedure TNemp_MainForm.MM_T_WebServerOptionsClick(Sender: TObject);
begin
    if Not Assigned(OptionsCompleteForm) then
        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.WebServerNode;
    OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.WebServerNode] := True;
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer8;
    OptionsCompleteForm.Show;
end;

initialization

finalization

    DeallocateHWnd(FOwnMessageHandler);


end.

