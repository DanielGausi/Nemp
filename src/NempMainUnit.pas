{

    Unit NempMainUnit
    Form Nemp_MainForm

    The MainForm of Nemp

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
   Nemp_SkinSystem, NempPanel, SkinButtons, math, PlayerLog,

  PlayerClass, PlaylistClass, MedienbibliothekClass, BibHelper, deleteHelper,

  gnuGettext, Nemp_RessourceStrings, languageCodes,
  OneInst, DriveRepairTools, ShoutcastUtils, WebServerClass, ScrobblerUtils,
  UpdateUtils, uDragFilesSrc, PlayWebstream,
  ClassicCoverFlowClass,
  unitFlyingCow, dglOpenGL, NempCoverFlowClass, PartyModeClass, RatingCtrls, tagClouds,
  fspTaskbarMgr, fspTaskbarPreviews, Lyrics, pngimage, ExPopupList, SilenceDetection,
  System.ImageList, System.Types, System.UITypes, ProgressShape
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF}
  ;

type

  {$IFDEF USESTYLES}
(*  TFormStyleHookFix= class (TFormStyleHook)
  procedure CMDialogChar(var Message: TWMKey); message CM_DIALOGCHAR;
  end;

  TFormStyleHookHelper= class  helper for TFormStyleHook
  private
     function CheckHotKeyItem(ACharCode: Word): Boolean;
  end;
  *)
  {$ENDIF}

  TNemp_MainForm = class(TNempForm)
    _TopMainPanel: TPanel;
    BassTimer: TTimer;
    SubSplitter1: TSplitter;
    Nemp_MainMenu: TMainMenu;
    PlayListImageList: TImageList;
    PlaylistPanel: TNempPanel;
    GRPBOXArtistsAlben: TNempPanel;
    PanelStandardBrowse: TPanel;
    SplitterBrowse: TSplitter;
    ArtistsVST: TVirtualStringTree;
    AlbenVST: TVirtualStringTree;
    AuswahlPanel: TPanel;
    AutoSavePlaylistTimer: TTimer;
    DragFilesSrc1: TDragFilesSrc;
    _VSTPanel: TNempPanel;
    PlaylistFillPanel: TNempPanel;
    GRPBOXPlaylist: TNempPanel;
    SleepTimer: TTimer;
    BirthdayTimer: TTimer;
    PanelCoverBrowse: TNempPanel;
    CoverScrollbar: TScrollBar;
    MenuImages: TImageList;
    TabBtn_Playlist: TSkinButton;
    PlayListStatusLBL: TLabel;
    PlayListOpenDialog: TOpenDialog;
    PlaylistDateienOpenDialog: TOpenDialog;
    OpenDialog1: TOpenDialog;
    PlayListSaveDialog: TSaveDialog;
    SaveDialog1: TSaveDialog;
    Medialist_View_PopupMenu: TPopupMenu;
    PlayListPOPUP: TPopupMenu;
    TNAMenu: TPopupMenu;
    Player_PopupMenu: TPopupMenu;
    VST_ColumnPopup: TPopupMenu;
    PopupPlayPause: TPopupMenu;
    PopupStop: TPopupMenu;
    PopupRepeat: TPopupMenu;
    MM_Medialibrary: TMenuItem;
    MM_ML_SearchDirectory: TMenuItem;
    MM_ML_Webradio: TMenuItem;
    N22: TMenuItem;
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
    MM_T_Birthday: TMenuItem;
    MM_T_BirthdayActivate: TMenuItem;
    MM_T_BirthdayOptions: TMenuItem;
    MM_T_RemoteNemp: TMenuItem;
    MM_T_WebServerActivate: TMenuItem;
    MM_T_WebServerOptions: TMenuItem;
    MM_T_Scrobbler: TMenuItem;
    MM_T_ScrobblerActivate: TMenuItem;
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
    PM_P_Birthday: TMenuItem;
    PM_P_BirthdayActivate: TMenuItem;
    PM_P_BirthdayOptions: TMenuItem;
    PM_P_RemoteNemp: TMenuItem;
    PM_P_WebServerActivate: TMenuItem;
    PM_P_WebServerOptions: TMenuItem;
    PM_P_Scrobbler: TMenuItem;
    PM_P_ScrobblerActivate: TMenuItem;
    PM_P_ScrobblerOptions: TMenuItem;
    PM_P_Directories: TMenuItem;
    PM_P_DirectoriesRecordings: TMenuItem;
    PM_P_DirectoriesData: TMenuItem;
    N17: TMenuItem;
    PM_P_About: TMenuItem;
    PM_P_Help: TMenuItem;
    PM_P_CheckForUpdates: TMenuItem;
    PM_PlayFiles: TMenuItem;
    PM_PlayWebstream: TMenuItem;
    PM_StopNow: TMenuItem;
    PM_StopAfterTitle: TMenuItem;
    PM_RepeatAll: TMenuItem;
    PM_RepeatTitle: TMenuItem;
    PM_RandomMode: TMenuItem;
    PM_RepeatOff: TMenuItem;
    NempTrayIcon: TTrayIcon;
    AuswahlHeaderPanel: TNempPanel;
    TabBtn_Preselection: TSkinButton;
    TabBtn_Browse: TSkinButton;
    TabBtn_CoverFlow: TSkinButton;
    AuswahlFillPanel: TNempPanel;
    AuswahlStatusLBL: TLabel;
    PlayerHeaderPanel: TNempPanel;
    MM_ML_Search: TMenuItem;
    IMGMedienBibCover: TImage;
    ImgScrollCover: TImage;
    MM_ML_BrowseByAlbumArtists: TMenuItem;
    MM_ML_BrowseByYearArtist: TMenuItem;
    Pnl_CoverFlowLabel: TNempPanel;
    Lbl_CoverFlow: TLabel;
    PM_P_PartyMode: TMenuItem;
    TabBtn_TagCloud: TSkinButton;
    MM_O_PartyMode: TMenuItem;
    PanelTagCloudBrowse: TNempPanel;
    PM_ML_GetTags: TMenuItem;
    fspTaskbarManager: TfspTaskbarMgr;
    fspTaskbarPreviews1: TfspTaskbarPreviews;
    PM_ML_CloudEditor: TMenuItem;
    TaskBarImages: TImageList;
    Win7TaskBarPopup: TPopupMenu;
    test1: TMenuItem;
    N67: TMenuItem;
    PM_PL_ShowInExplorer: TMenuItem;
    N69: TMenuItem;
    MM_T_CloudEditor: TMenuItem;
    N71: TMenuItem;
    MM_ML_CloseNemp: TMenuItem;
    PM_ML_SetRatingsOfSelectedFilesCHOOSE: TMenuItem;
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
    PM_PL_StopAfterCurrentTitle: TMenuItem;
    MM_ML_BrowseByFileageAlbum: TMenuItem;
    MM_ML_BrowseByFileageArtist: TMenuItem;
    HeadSetTimer: TTimer;
    PM_PL_ClearPlaylist: TMenuItem;
    MM_PL_ClearPlaylist: TMenuItem;
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
    MM_T_WebServerShowLog: TMenuItem;
    PM_P_WebServerShowLog: TMenuItem;
    N70: TMenuItem;
    PM_ABRepeat: TMenuItem;
    PopupRepeatAB: TPopupMenu;
    PM_StopABrepeat: TMenuItem;
    PM_ABRepeatSetA: TMenuItem;
    PM_ABRepeatSetB: TMenuItem;
    PM_SetA: TMenuItem;
    PM_SetB: TMenuItem;
    N78: TMenuItem;
    LblEmptyLibraryHint: TLabel;
    WalkmanModeTimer: TTimer;
    PlaylistVST: TVirtualStringTree;
    MM_O_Skin_UseAdvanced: TMenuItem;
    PM_P_Skin_UseAdvancedSkin: TMenuItem;
    CoverFlowRefreshViewTimer: TTimer;
    EditPlaylistSearch: TEdit;
    PopupEditExtendedTags: TPopupMenu;
    PM_RemoveTagThisFile: TMenuItem;
    N1: TMenuItem;
    PM_TagIgnoreList: TMenuItem;
    PM_TagMergeList: TMenuItem;
    PM_TagAudiofile: TMenuItem;
    PM_TagTagCloud: TMenuItem;
    MM_Warning_ID3Tags: TMenuItem;
    PM_RenameTagThisFile: TMenuItem;
    PM_AddTagThisFile: TMenuItem;
    pm_TagDetails: TMenuItem;
    N79: TMenuItem;
    PM_ML_MarkFile: TMenuItem;
    PM_ML_Mark0: TMenuItem;
    PM_ML_Mark1: TMenuItem;
    PM_ML_Mark2: TMenuItem;
    PM_ML_Mark3: TMenuItem;
    N81: TMenuItem;
    PM_PL_MarkFiles: TMenuItem;
    PM_PL_Mark0: TMenuItem;
    N86: TMenuItem;
    PM_PL_Mark3: TMenuItem;
    PM_PL_Mark2: TMenuItem;
    PM_PL_Mark1: TMenuItem;
    MM_T_PlaylistLog: TMenuItem;
    PM_P_PlaylistLog: TMenuItem;
    QuickSearchHistory_PopupMenu: TPopupMenu;
    pmRecentSearches: TMenuItem;
    pmQuickSeachHistory0: TMenuItem;
    N80: TMenuItem;
    pmQuickSeachHistory1: TMenuItem;
    pmQuickSeachHistory2: TMenuItem;
    pmQuickSeachHistory3: TMenuItem;
    pmQuickSeachHistory4: TMenuItem;
    pmQuickSeachHistory5: TMenuItem;
    pmQuickSeachHistory6: TMenuItem;
    pmQuickSeachHistory7: TMenuItem;
    pmQuickSeachHistory8: TMenuItem;
    pmQuickSeachHistory9: TMenuItem;
    N82: TMenuItem;
    Medialist_Browse_PopupMenu: TPopupMenu;
    PM_ML_EnqueueBrowse: TMenuItem;
    PM_ML_PlayBrowse: TMenuItem;
    PM_ML_PlayNextBrowse: TMenuItem;
    PM_ML_SortBy: TMenuItem;
    PM_ML_SortAscending: TMenuItem;
    PM_ML_SortDescending: TMenuItem;
    N4: TMenuItem;
    PM_ML_SortFilesize: TMenuItem;
    PM_ML_SortDuration: TMenuItem;
    N7: TMenuItem;
    PM_ML_SortGenre: TMenuItem;
    PM_ML_SortLyricsexists: TMenuItem;
    PM_ML_SortPathFilename: TMenuItem;
    PM_ML_SortFilename: TMenuItem;
    N8: TMenuItem;
    PM_ML_SortAlbumTracknr: TMenuItem;
    PM_ML_SortAlbumTitleArtist: TMenuItem;
    PM_ML_SortAlbumArtistTitle: TMenuItem;
    PM_ML_SortTitleArtist: TMenuItem;
    PM_ML_SortArtistAlbumTitle: TMenuItem;
    PM_ML_SortArtistTitle: TMenuItem;
    PM_ML_BrowseBy: TMenuItem;
    PM_ML_BrowseByMore: TMenuItem;
    N11: TMenuItem;
    PM_ML_BrowseByFileageArtist: TMenuItem;
    PM_ML_BrowseByFileageAlbum: TMenuItem;
    PM_ML_BrowseByYearArtist: TMenuItem;
    PM_ML_BrowseByAlbumArtists: TMenuItem;
    PM_ML_BrowseByGenresYears: TMenuItem;
    PM_ML_BrowseByGenresArtists: TMenuItem;
    PM_ML_BrowseByDirectoriesAlbums: TMenuItem;
    PM_ML_BrowseByDirectoriesArtists: TMenuItem;
    PM_ML_BrowseByArtistsAlbums: TMenuItem;
    N16: TMenuItem;
    PM_ML_RemoveSelectedPlaylists: TMenuItem;
    _ControlPanel: TNempPanel;
    NewPlayerPanel: TNempPanel;
    SlideBarShape: TProgressShape;
    RatingImage: TImage;
    ab1: TImage;
    ab2: TImage;
    SlideBarButton: TSkinButton;
    PlayerArtistLabel: TLabel;
    PlayerTitleLabel: TLabel;
    SlideForwardBTN: TSkinButton;
    SlideBackBTN: TSkinButton;
    RecordBtn: TSkinButton;
    PlayerTimeLbl: TLabel;
    BtnClose: TSkinButton;
    MedialistPanel: TNempPanel;
    MedienBibHeaderPanel: TNempPanel;
    EDITFastSearch: TEdit;
    MedienlisteFillPanel: TNempPanel;
    MedienListeStatusLBL: TLabel;
    TabBtn_Medialib: TSkinButton;
    TabBtn_Marker: TSkinButton;
    GRPBOXVST: TNempPanel;
    VST: TVirtualStringTree;
    SubSplitter2: TSplitter;
    MedienBibDetailPanel: TNempPanel;
    DetailID3TagPanel: TNempPanel;
    MedienBibDetailHeaderPanel: TNempPanel;
    MedienBibDetailFillPanel: TNempPanel;
    TabBtn_Cover: TSkinButton;
    TabBtn_Lyrics: TSkinButton;
    SplitterFileOverview: TSplitter;
    DetailCoverLyricsPanel: TNempPanel;
    LyricsMemo: TMemo;
    ImgDetailCover: TImage;
    MedienBibDetailStatusLbl: TLabel;
    ContainerPanelMedienBibDetails: TNempPanel;
    __MainContainerPanel: TNempPanel;
    MainSplitter: TSplitter;
    ControlContainer2: TNempPanel;
    ControlContainer1: TNempPanel;
    HeadsetControlPanel: TNempPanel;
    VolShapeHeadset: TShape;
    VolumeImageHeadset: TImage;
    lblHeadphoneControl: TLabel;
    VolButtonHeadset: TSkinButton;
    PlayPauseHeadSetBtn: TSkinButton;
    StopHeadSetBtn: TSkinButton;
    BtnLoadHeadset: TSkinButton;
    BtnHeadsetToPlaylist: TSkinButton;
    BtnHeadsetPlaynow: TSkinButton;
    PlayerControlCoverPanel: TNempPanel;
    CoverImage: TImage;
    OutputControlPanel: TNempPanel;
    TabBtn_MainPlayerControl: TSkinButton;
    TabBtn_Equalizer: TSkinButton;
    TabBtn_Headset: TSkinButton;
    PlayerControlPanel: TNempPanel;
    VolShape: TShape;
    VolumeImage: TImage;
    WalkmanImage: TImage;
    WebserverImage: TImage;
    SleepImage: TImage;
    BirthdayImage: TImage;
    ScrobblerImage: TImage;
    PlayPauseBTN: TSkinButton;
    StopBTN: TSkinButton;
    PlayPrevBTN: TSkinButton;
    PlayNextBTN: TSkinButton;
    RandomBtn: TSkinButton;
    VolButton: TSkinButton;
    MM_O_FormBuilder: TMenuItem;
    PM_P_FormBuilder: TMenuItem;
    ImgBibRating: TImage;
    LblBibAlbum: TLabel;
    LblBibArtist: TLabel;
    LblBibDuration: TLabel;
    LblBibGenre: TLabel;
    LblBibPlayCounter: TLabel;
    LblBibQuality: TLabel;
    LblBibTitle: TLabel;
    LblBibYear: TLabel;
    Bevel1: TBevel;
    PaintFrame: TImage;
    PopupTools: TPopupMenu;
    PM_T_ShutDown: TMenuItem;
    PM_T_ShutDownActivate: TMenuItem;
    PM_T_Birthday: TMenuItem;
    PM_T_BirthdayActivate: TMenuItem;
    PM_T_BirthdayOptions: TMenuItem;
    PM_T_WebServer: TMenuItem;
    PM_T_WebServerActivate: TMenuItem;
    PM_T_WebServerOptions: TMenuItem;
    PM_T_WebServerShowLog: TMenuItem;
    PM_T_Scrobbler: TMenuItem;
    PM_T_ScrobblerActivate: TMenuItem;
    PM_T_ScrobblerOptions: TMenuItem;
    PM_T_ShutDownSettings: TMenuItem;
    PM_T_ShutdownInfo: TMenuItem;
    PM_P_ShutdownInfo: TMenuItem;
    MM_T_ShutdownInfo: TMenuItem;
    PM_P_ShutDownSettings: TMenuItem;
    MM_T_ShutdownSettings: TMenuItem;
    Help1: TMenuItem;
    PopupHeadset: TPopupMenu;
    PM_H_EnqueueEndOfPlaylist: TMenuItem;
    PM_H_PlayAndClearPlaylist: TMenuItem;
    PM_H_EnqueueAfterCurrentTitle: TMenuItem;
    PM_H_JustPlay: TMenuItem;
    MM_T_EqualizerEffects: TMenuItem;
    PM_P_EqualizerEffects: TMenuItem;
    BtnMinimize: TSkinButton;
    N24: TMenuItem;
    PM_PL_ReplayGain: TMenuItem;
    PM_PL_ReplayGain_SingleTracks: TMenuItem;
    PM_PL_ReplayGain_OneAlbum: TMenuItem;
    PM_PL_ReplayGain_MultiAlbums: TMenuItem;
    PM_PL_ReplayGain_Clear: TMenuItem;
    PM_ML_ReplayGain: TMenuItem;
    PM_ML_ReplayGain_SingleTracks: TMenuItem;
    PM_ML_ReplayGain_OneAlbum: TMenuItem;
    PM_ML_ReplayGain_MultiAlbum: TMenuItem;
    PM_ML_ReplayGain_Clear: TMenuItem;
    N27: TMenuItem;

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
    function GenerateListForHandleFiles(aList: TObjectList; what: integer; OnlyTemporaryFiles: Boolean): Boolean;

    procedure EnqueueTBClick(Sender: TObject);
    procedure PM_ML_PlayClick(Sender: TObject);
    function GetFocussedAudioFile:TAudioFile;
    procedure Medialist_View_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_ShowInExplorerClick(Sender: TObject);

    procedure ShowSummary(aList: TObjectList = Nil);
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

    procedure PlayNextBTNIMGClick(Sender: TObject);
    procedure PlayPrevBTNIMGClick(Sender: TObject);
    procedure StopBTNIMGClick(Sender: TObject);
    procedure PlayPauseBTNIMGClick(Sender: TObject);
    procedure SlideBarShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SlideBarButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    //procedure ShowPlayerDetails(aAudioFile: TAudioFile);
    //procedure ShowHeadsetDetails(aAudioFile: TAudioFile);
    procedure ShowVSTDetails(aAudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
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

    procedure SubSplitter1Moved(Sender: TObject);
    procedure PlayListSaveDialogTypeChange(Sender: TObject);
    procedure PM_TNA_CloseClick(Sender: TObject);
    procedure PM_TNA_RestoreClick(Sender: TObject);
    //procedure AnzeigeBTNClick(Sender: TObject);

    //procedure AnzeigeBTNMouseDown(Sender: TObject; Button: TMouseButton;
    //  Shift: TShiftState; X, Y: Integer);
    procedure PlaylistVSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure PM_PL_ExtendedScanFilesClick(Sender: TObject);

    procedure LyricsMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

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
    procedure PM_ML_DeleteSelectedClick(Sender: TObject);
    procedure EDITFastSearchEnter(Sender: TObject);
    procedure PM_P_ViewStayOnTopClick(Sender: TObject);
    procedure EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
    procedure DoFastSearch(aString: UnicodeString; AllowErr: Boolean = False);
    procedure DoFastIPCSearch(aString: UnicodeString);

    procedure PlaylistVSTGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: String);
    procedure DragFilesSrc1Dropping(Sender: TObject);
    procedure DragDropTimerTimer(Sender: TObject);
    procedure VolTimerTimer(Sender: TObject);
    procedure IncrementalCoverSearchTimerTimer(Sender: TObject);
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
    procedure __BtnMinimizeClick(Sender: TObject);
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
    //procedure ResetShutDownCaptions;
    //procedure StundenClick(Sender: TObject);
    procedure InitShutDown;
    procedure ActivateShutDownMode(Sender: TObject);
    procedure SleepTimerTimer(Sender: TObject);
    procedure Schlafmodusdeaktivieren1Click(Sender: TObject);

    procedure LoadARecentPlaylist(Sender: TObject);
    function DeleteFileFromRecentList(aIdx: Integer): boolean;
    function AddFileToRecentList(NewFile: UnicodeString): Boolean;
    Procedure SetRecentPlaylistsMenuItems;

    Function GeneratePlaylistSTFilter: string;
    function GenerateMedienBibSTFilter: String;

    procedure RepairZOrder;
    // procedure ActualizeVDTCover;

    procedure PM_ML_PlayNowClick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    Procedure RepaintPanels;
    Procedure RepaintPlayerPanel;
    Procedure RepaintOtherForms;
    procedure RepaintAll;
    Procedure RepaintVisOnPause;
    procedure TABPanelPaint(Sender: TObject);
    procedure MainSplitterMoved(Sender: TObject);

    procedure PlaylistVSTCollapsAndExpanded(Sender: TBaseVirtualTree;
      Node: PVirtualNode);

    procedure AktualisiereDetailForm(aAudioFile: TAudioFile; Source: Integer; Foreground: Boolean = False);
    procedure TNAMenuPopup(Sender: TObject);
    Procedure TNA_PlaylistClick(Sender: TObject);
    procedure BirthdayTimerTimer(Sender: TObject);
    procedure MenuBirthdayStartClick(Sender: TObject);

    procedure ShowMatchingControls;//(MainOrHeadset: Integer);
    procedure ShowProgress(aProgress: Double; aSeconds: Integer; MainPlayer: Boolean);// aTimeString: String);
    procedure ReCheckAndSetProgressChangeGUIStatus;
    procedure ReInitPlayerVCL(GetCoverWasSuccessful: Boolean);
    procedure DisplayPlayerMainTitleInformation(GetCoverWasSuccessful: Boolean);
    procedure DisplayHeadsetTitleInformation(GetCoverWasSuccessful: Boolean);

    procedure PutDirListInAutoScanList(aDirList: TStringList);
    procedure EDITFastSearchExit(Sender: TObject);
    procedure MitzuflligenEintrgenausderMedienbibliothekfllen1Click(
      Sender: TObject);
    //procedure ReallyClearPlaylistTimerTimer(Sender: TObject);
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
    procedure TabPanelPlaylistClick(Sender: TObject);
    procedure PM_P_DirectoriesRecordingsClick(Sender: TObject);
    procedure PM_P_DirectoriesDataClick(Sender: TObject);
    procedure PlaylistPanelResize(Sender: TObject);
    procedure VSTAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);

    procedure Player_PopupMenuPopup(Sender: TObject);
    procedure VST_ColumnPopupPopup(Sender: TObject);
    procedure Splitter4CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);

    procedure VST_ColumnPopupOnClick(Sender: TObject);
    procedure EDITFastSearchChange(Sender: TObject);
    procedure AlbenVSTClick(Sender: TObject);
    procedure ArtistsVSTClick(Sender: TObject);
    procedure PM_PlayFilesClick(Sender: TObject);
    procedure PM_PlayWebstreamClick(Sender: TObject);
    procedure PM_StopNowClick(Sender: TObject);
    procedure PM_StopAfterTitleClick(Sender: TObject);
    procedure PopupStopPopup(Sender: TObject);
    procedure PM_RepeatMenuClick(Sender: TObject);
    procedure PopupRepeatPopup(Sender: TObject);
    //procedure ShutDown_EndofPlaylistClick(Sender: TObject);
    procedure MM_H_CheckForUpdatesClick(Sender: TObject);
    procedure VolButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SlideBarButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure SlideBarButtonEndDrag(Sender, Target: TObject; X,
      Y: Integer);

    procedure GrpBoxControlDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);

    procedure VolButtonEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure TabBtn_PreselectionClick(Sender: TObject);
    procedure TabBtn_CoverMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PM_P_ScrobblerActivateClick(Sender: TObject);
    procedure PM_P_ScrobblerOptionsClick(Sender: TObject);
    procedure ToolImageClick(Sender: TObject);
    procedure MM_T_WebServerActivateClick(Sender: TObject);
    procedure MM_T_WebServerOptionsClick(Sender: TObject);

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
    procedure DetailID3TagPanelResize(Sender: TObject);
    procedure ImgBibRatingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgBibRatingMouseLeave(Sender: TObject);
    procedure ImgBibRatingMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure FillBibDetailLabels(aAudioFile: TAudioFile);
    procedure CreateTagLabels(aAudioFile: TAudioFile);
    procedure DetailLabelMouseOver(Sender: TObject);
    procedure DetailLabelMouseLeave(Sender: TObject);
    procedure DetailTagLabelDblClick(Sender: TObject);
    procedure DetailLabelDblClick(Sender: TObject);
    procedure DetailLabelDblClickNewTag(Sender: TObject);
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

    procedure VSTAfterGetMaxColumnWidth(Sender: TVTHeader; Column: TColumnIndex;
      var MaxWidth: Integer);
    procedure fspTaskbarManagerThumbButtonClick(Sender: TObject;
      ButtonId: Integer);
    procedure FormActivate(Sender: TObject);
    procedure fspTaskbarPreviews1NeedIconicBitmap(Sender: TObject; Width,
      Height: Integer; var Bitmap: HBITMAP);
    procedure PM_ML_CloudEditorClick(Sender: TObject);

    procedure NewPlayerPanelClick(Sender: TObject);
    procedure Win7TaskBarPopupPopup(Sender: TObject);
    procedure PM_PL_ShowInExplorerClick(Sender: TObject);
    procedure PM_ML_SetRatingsOfSelectedFilesClick(Sender: TObject);
    procedure GRPBOXArtistsAlbenResize(Sender: TObject);
    procedure AuswahlPanelResize(Sender: TObject);
    procedure SplitterBrowseMoved(Sender: TObject);
    procedure SubSplitter2Moved(Sender: TObject);

    procedure VolButton_HeadsetStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PLayPauseBtnHeadsetClick(Sender: TObject);
    procedure BtnLoadHeadsetClick(Sender: TObject);
    procedure HeadSetTimerTimer(Sender: TObject);
    procedure StopHeadSetBtnClick(Sender: TObject);
    procedure VolButtonHeadsetKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnHeadsetToPlaylistClick(Sender: TObject);
    procedure PM_PL_ClearPlaylistClick(Sender: TObject);

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
    procedure __PM_W_WebServerShowLogClick(Sender: TObject);
    procedure BtnHeadsetPlaynowClick(Sender: TObject);
    procedure ab1StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure ab1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BtnABRepeatClick(Sender: TObject);
    procedure PM_ABRepeatSetAClick(Sender: TObject);
    procedure PM_ABRepeatSetBClick(Sender: TObject);
    procedure WalkmanModeTimerTimer(Sender: TObject);
    procedure WalkmanImageClick(Sender: TObject);
    procedure VSTEndDrag(Sender, Target: TObject; X, Y: Integer);
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
    procedure PM_ML_BrowseByMoreClick(Sender: TObject);
    //procedure VST_ColumnPopupCoverClick(Sender: TObject);
    procedure PM_RemoveTagThisFileClick(Sender: TObject);
    procedure PopupEditExtendedTagsPopup(Sender: TObject);
    procedure PM_TagIgnoreListClick(Sender: TObject);
    procedure PM_TagMergeListClick(Sender: TObject);
    procedure MM_Warning_ID3TagsClick(Sender: TObject);
    procedure PM_RenameTagThisFileClick(Sender: TObject);

    procedure pm_TagDetailsClick(Sender: TObject);
    procedure PM_ML_SetmarkerClick(Sender: TObject);

    procedure SetMarker(Sender: TObject; aValue: Byte);
    procedure TabBtn_MarkerClick(Sender: TObject);
    procedure VSTColumnClick(Sender: TBaseVirtualTree; Column: TColumnIndex;
      Shift: TShiftState);
    procedure TabBtn_MarkerKeyPress(Sender: TObject; var Key: Char);
    procedure CoverScrollbarEnter(Sender: TObject);
    procedure MM_T_PlaylistLogClick(Sender: TObject);
    procedure RefreshVSTCover(aAudioFile: TAudioFile);
    procedure RefreshVSTCoverTimerTimer(Sender: TObject);
    procedure TabBtn_MarkerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QuickSearchHistory_PopupMenuPopup(Sender: TObject);
    procedure pmQuickSeachHistoryClick(Sender: TObject);
    procedure Medialist_Browse_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_RemoveSelectedPlaylistsClick(Sender: TObject);
    procedure MM_MedialibraryClick(Sender: TObject);
    procedure MM_PlaylistClick(Sender: TObject);
    procedure MM_OptionsClick(Sender: TObject);
    procedure ShowSlideBarButtonAtCorrectPosition;
    procedure SlideBarShapeMouseEnter(Sender: TObject);
    procedure SlideBarShapeMouseLeave(Sender: TObject);
    procedure TabBtn_MainPlayerControlClick(Sender: TObject);
    procedure TabBtn_EqualizerClick(Sender: TObject);
    procedure HeadsetControlPanelClick(Sender: TObject);
    procedure PlayerControlPanelClick(Sender: TObject);
    procedure PlayerControlPanelMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PlayerControlPanelMouseWheelUp(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure HeadsetControlPanelMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure HeadsetControlPanelMouseWheelUp(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure TabBtn_HeadsetClick(Sender: TObject);
    procedure MM_O_FormBuilderClick(Sender: TObject);
    procedure MedialistPanelResize(Sender: TObject);
    procedure MedienBibDetailPanelResize(Sender: TObject);
    procedure SplitterFileOverviewMoved(Sender: TObject);
    procedure SplitterFileOverviewCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure _TopMainPanelResize(Sender: TObject);
    procedure __MainContainerPanelResize(Sender: TObject);
    procedure Pnl_CoverFlowLabelPaint(Sender: TObject);
    procedure ControlPanelPaint(Sender: TObject);
    procedure GRPBOXArtistsAlbenPaint(Sender: TObject);
    procedure _ControlPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure _ControlPanelResize(Sender: TObject);
    procedure NewPlayerPanelResize(Sender: TObject);

    procedure PlaylistCueChanged(Sender: TObject);
    procedure OnPlayerStopped(Sender: TObject);
    procedure OnPlayerMessage(Sender: TObject; aMessage: String);
    procedure ReallyDeletePlaylistTimerTimer(Sender: TObject);
    procedure ImgDetailCoverDblClick(Sender: TObject);
    procedure InsertHeadsetToPlaylistClick(Sender: TObject);
    procedure __MainContainerPanelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure __MainContainerPanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure __MainContainerPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnMinimizeClick(Sender: TObject);
    procedure PM_PL_ReplayGain_Click(Sender: TObject);

  private
    { Private declarations }
    CoverImgDownX: Integer;
    CoverImgDownY: Integer;
    TagCloudDownX: Integer;
    TagCloudDownY: Integer;

    ResizeFlag: Cardinal;

    CurrentTagToChange: String;

    NewStringFromVSTEdit: String;

    PaintFrameDownX: Integer;
    PaintFrameDownY: Integer;

    OldScrollbarWindowProc: TWndMethod;
    OldLyricMemoWindowProc: TWndMethod;

    // a replacement for the PopupMenu.Tag, as we have two medialist popups now
    MediaListPopupTag: Integer;

    // Setzt alle DragOver-Eventhandler auf das der Effekte-Groupbox
    //procedure SetGroupboxEffectsDragover;
    // ... der Equalizer-Groupbox
    //procedure SetGroupboxEQualizerDragover;

    //LastPaintedTimeString: String;
    LastPaintedTime: Integer;

    FormReadyAndActivated : Boolean;

    DeleteAudioFilesAfterHandled: Boolean;


    procedure OwnMessageProc(var msg: TMessage);
    procedure NewScrollBarWndProc(var Message: TMessage);
    procedure NewLyricMemoWndProc(var Message: TMessage);
    procedure WMStartEditing(var Msg: TMessage); Message WM_STARTEDITING;

    procedure CMMenuClosed(var Msg: TMessage ); message CM_MENUCLOSED;
    procedure CM_ENTERMENULOOP(var Msg: TMessage ); message CM_ENTERMENULOOP;

    function ArtistDragContainsFiles: Boolean;
    function ArtistAlbumDragContainsFiles: Boolean;

    procedure HandleRemoteFilename(filename: UnicodeString; Mode: Integer);

    procedure CatchAllExceptionsOnShutDown(Sender: TObject; E: Exception);

    procedure HandleInsertHeadsetToPlaylist(aAction: Integer);

  public
    { Public declarations }
    CloudViewer: TCloudViewer;

    NempIsClosing: Boolean;


    // Zählt die Nachrichten "Neues Laufwerk angeschlossen"
    // nötig, da ein Update der Bib nicht möglich ist, wenn ein Update bereits läuft
    NewDrivesNotificationCount: Integer;

    WebRadioInsertMode: Integer;

    PlayListSkinImageList: TImageList;
    MenuSkinImageList: TImageList;

    ActivationMessage: Cardinal;

    MinimizedIndicator: Boolean;
//-----------------------

    DragDropList: TStringList;  // Liste mir interne gedraggten Dateien, da der normale
                                   // Drag&Drop bei WS nicht so richtig klappt.

    NempOptions: TNempOptions; // Viele viele Optionen, die in der ini stehen
    NempFormBuildOptions: TNempFormBuildOptions;

    NempDockedForms: Array [1..3] of Boolean;
    NempSkin: TNempSkin;

    // Laufzeit-tmp-Variablen
    AutoShowDetailsTMP: Boolean;
    DragSource: Integer; // Woher kommen die Gedraggten Files?

    BackupPlayingIndex: Integer; // Beim Startvorgang mit Parameter den alten PlayingIndex merken,
                                 // Falls mit den Parametern was nicht stimmt

    TaskBarDelay: integer;

    ContinueWithPlaylistAdding: Boolean;

    KeepOnWithLibraryProcess: Boolean;

    ReadyForGetFileApiCommands: Boolean;

    SelectionPrefix: UnicodeString;
    OldSelectionPrefix: UnicodeString;

    CorrectSkinRegionsTimer,
    ReallyDeletePlaylistTimer,
    VolTimer,
    DragDropTimer,
    RefreshVSTCoverTimer,
    CurrentSearchDirPlayistTimer,
    CurrentSearchDirMediaLibraryTimer,
    IncrementalCoverSearchTimer : TTimer;

    Nemp_VersionString: String;

    Saved8087CW: Word;

    SelectedPlayListMp3s: TNodeArray;

    NempWindowDefault: DWord;

    AnzeigeMode: Integer;
    UseSkin: Boolean;
    GlobalUseAdvancedSkin: Boolean;
    SkinName: UnicodeString;

    MainPlayerControlsActive: Boolean;

    AlphaBlendBMP: TBitmap;

    BibRatingHelper: TRatingHelper;

    TagLabelList: TObjectList;

    // reference to AB1 and AB2, needed for assigning the correct graphics
    ABRepeatStartImg, ABRepeatEndImg: TImage;

    Resizing: Boolean;

    //procedure EmptyScrollBarWndProc(var Message: TMessage);

    procedure MinimizeNemp(Sender: TObject);
    procedure DeactivateNemp(Sender: TObject);
    procedure RestoreNemp;
    procedure NotifyDeskband(aMsg: Integer);
    procedure ProcessCommandline(lpData: Pointer; StartPlay: Boolean) ; overload;
    procedure ProcessCommandline(filename: UnicodeString; StartPlay: Boolean; Enqueue: Boolean); overload;

    function GetShutDownInfoCaption: String;

    procedure RefreshCurrentSearchDirPlayist(Sender: TObject);
    procedure RefreshCurrentSearchDirMediaLibrary(Sender: TObject);

    //procedure CorrectSkinRegions;
    //procedure ResetVolSteps;
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
    // procedure STNewDir   (var Msg: TMessage); message ST_CurrentDir   ;   This is "too fast" to display

   end;


   {$IFDEF USESTYLES}
    // see https://community.embarcadero.com/view-profile/10750-
    TStyleEnginePrivateHelper = class helper for TStyleEngine
        class procedure DoFreeControlHooks;
    end;
    {$ENDIF}


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
  CDOpenDialogs, WebServerLog, Lowbattery, ProgressUnit, EffectsAndEqualizer,
  MainFormBuilderForm, ReplayGainProgress, NempReplayGainCalculation;


{$R *.dfm}

{$IFDEF USESTYLES}
/// -----------------------
/// Workaround for some exceptions on closing after changing to Windows-Style
/// https://community.embarcadero.com/view-profile/10750-
class procedure TStyleEnginePrivateHelper.DoFreeControlHooks;
begin
    TStyleEngine.FreeControlHooks;
end;

procedure FreeAllControlStyleHooks;
begin
TStyleEngine.DoFreeControlHooks;
end;
/// -----------------------

{ TFormStyleHookFix }
(*
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

*)
{$ENDIF}


// some Timers, not on the Form, but created in OnCreate
procedure TNemp_MainForm.IncrementalCoverSearchTimerTimer(Sender: TObject);
begin
    // Prefix zurücksetzen
    SelectionPrefix := '';
end;

procedure TNemp_MainForm.DragDropTimerTimer(Sender: TObject);
begin
    DragDropTimer.Enabled := False;
    Nemp_MainForm.DragSource := DS_EXTERN;
end;

procedure TNemp_MainForm.VolTimerTimer(Sender: TObject);
begin
    VolTimer.Enabled := False;
    NempPlayer.VolStep := 0;
end;

procedure TNemp_MainForm.CorrectSkinRegionsTimerTimer(Sender: TObject);
begin
    CorrectSkinRegionsTimer.Enabled := False;
    NempSkin.SetRegionsAgain;
    MedienBib.NewCoverFlow.SetNewHandle(Nemp_MainForm.PanelCoverBrowse.Handle);
    ReAcceptDragFiles;

    // NempSkin.AssignOtherGraphics;
    //UpdateFormDesignNeu;      // really necessary??? (july 2019)
end;

// Refresh the CurrentDir information on the ProgreessForms
procedure TNemp_MainForm.RefreshCurrentSearchDirPlayist(Sender: TObject);
begin
    ProgressFormPlaylist.lblSuccessCount.Caption := IntToStr(NempPlaylist.FileSearchCounter);
    ProgressFormPlaylist.lblCurrentItem.Caption := Format(Playlist_SearchingNewFilesDir, [NempPlaylist.CurrentSearchDir]);
end;
procedure TNemp_MainForm.RefreshCurrentSearchDirMediaLibrary(Sender: TObject);
begin
    ProgressFormLibrary.lblSuccessCount.Caption := IntToStr(MedienBib.UpdateList.Count);
    ProgressFormLibrary.lblCurrentItem.Caption := Format(MediaLibrary_SearchingNewFilesDir, [MedienBib.CurrentSearchDir]);

    Nemp_MainForm.LblEmptyLibraryHint.Caption :=
          Format(_(MediaLibrary_SearchingNewFilesBigLabel),  [MedienBib.UpdateList.Count]);
end;



// Sinn dieses Timers:
// Wenn im Explorer mehrere Dateien markiert werden, und die Funktion "In Nemp abspielen"
// gewählt wird, wird die Playlist für jede Datei neu gelöscht. das ist erstens nicht unbedingt
// sinnvoll, und zweitens kommt da irgendwas mit irgendwem durcheinander (die Anzahl der Dateien, die
// am Ende in der Playlist sind, ist irgendwie nicht vorhersehbar...???).
// So wird das Löschen der Playlist für einen gewissen Zeitraum verhindert, und alle markierten Dateien
// werden in die Playlist eingefügt.
procedure TNemp_MainForm.ReallyDeletePlaylistTimerTimer(Sender: TObject);
begin
    NempPlaylist.ProcessBufferStringlist;
    ReallyDeletePlaylistTimer.Enabled := False;
end;

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
    i, maxC: Integer;
    DateiListe: TObjectlist;
begin
    if ssleft in shift then
    begin
      if (abs(X - TagCloudDownX) > 5) or  (abs(Y - TagCloudDownY) > 5) then
      begin
          Dateiliste := TObjectlist.Create(False);
          try
              GenerateListForHandleFiles(DateiListe, 2, True);  // was: 4
              DragSource := DS_VST;
              with DragFilesSrc1 do
              begin
                  // Add files selected to DragFilesSrc1 list
                  ClearFiles;
                  DragDropList.Clear;

                  maxC := min(NempOptions.maxDragFileCount, DateiListe.Count);
                  if DateiListe.Count > NempOptions.maxDragFileCount then
                      AddErrorLog(Format(Warning_TooManyFiles, [NempOptions.maxDragFileCount]));

                  for i := 0 to maxC - 1 do
                  begin
                      AddFile((Dateiliste[i] as TAudiofile).Pfad);
                      DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad);
                  end;
                  // This is the START of the drag (FROM) operation.
                  Execute;
              end;
          finally
              FreeAndNil(Dateiliste);
          end;
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
    exit;
    MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);
end;

procedure TNemp_MainForm.PanelTagCloudBrowseResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    MedienBib.TagCloud.CloudPainter.Height := CloudViewer.Height;
    MedienBib.TagCloud.CloudPainter.Width := CloudViewer.Width;
    MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);
end;


procedure TNemp_MainForm.CloudTestKey(Sender: TObject; var Key: Char);
begin
    if ord(Key) = vk_return then
    begin
        MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, True);
        MedienBib.TagCloud.ShowTags(True);
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
//var c: Integer;
begin
    FormReadyAndActivated := false;

    FOwnMessageHandler := AllocateHWND( OwnMessageProc );
    TagLabelList := TObjectList.Create(True);

    NempFormBuildOptions := Nil;

    ABRepeatStartImg := ab1;
    ABRepeatEndImg   := ab2;

    CorrectSkinRegionsTimer := TTimer.Create(self);
    CorrectSkinRegionsTimer.Enabled := False;
    CorrectSkinRegionsTimer.Interval := 500;
    CorrectSkinRegionsTimer.OnTimer := CorrectSkinRegionsTimerTimer;

    ReallyDeletePlaylistTimer := TTimer.Create(self);
    ReallyDeletePlaylistTimer.Enabled := False;
    ReallyDeletePlaylistTimer.Interval := 500;
    ReallyDeletePlaylistTimer.OnTimer := ReallyDeletePlaylistTimerTimer;

    DragDropTimer := TTimer.Create(self);
    DragDropTimer.Enabled := False;
    DragDropTimer.Interval := 1000;
    DragDropTimer.OnTimer := DragDropTimerTimer;

    VolTimer := TTimer.Create(self);
    VolTimer.Enabled := False;
    VolTimer.Interval := 100;
    VolTimer.OnTimer := VolTimerTimer;

    RefreshVSTCoverTimer := TTimer.Create(self);
    RefreshVSTCoverTimer.Enabled := False;
    RefreshVSTCoverTimer.Interval := 1000;
    RefreshVSTCoverTimer.OnTimer := RefreshVSTCoverTimerTimer;

    CurrentSearchDirPlayistTimer := TTimer.Create(self);
    CurrentSearchDirPlayistTimer.Enabled := False;
    CurrentSearchDirPlayistTimer.Interval := 250;
    CurrentSearchDirPlayistTimer.OnTimer := RefreshCurrentSearchDirPlayist;

    CurrentSearchDirMediaLibraryTimer := TTimer.Create(self);
    CurrentSearchDirMediaLibraryTimer.Enabled := False;
    CurrentSearchDirMediaLibraryTimer.Interval := 250;
    CurrentSearchDirMediaLibraryTimer.OnTimer := RefreshCurrentSearchDirMediaLibrary;

    IncrementalCoverSearchTimer := TTimer.Create(self);
    IncrementalCoverSearchTimer.Enabled := False;
    IncrementalCoverSearchTimer.Interval := 1000;
    IncrementalCoverSearchTimer.OnTimer := IncrementalCoverSearchTimerTimer;

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
    KeepOnWithLibraryProcess   := False;

    NempRegionsDistance.Docked := True;
    MinimizedIndicator         := False;
    {$IFDEF USESTYLES}FormatSettings.{$ENDIF}DecimalSeparator := '.';
    //FormatSettings.Decimalseparator   := '.';

    OldScrollbarWindowProc    := CoverScrollbar.WindowProc;
    CoverScrollbar.WindowProc := NewScrollBarWndProc;
    OldLyricMemoWindowProc    := LyricsMemo.WindowProc;
    LyricsMemo.WindowProc     := NewLyricMemoWndProc;
    // "OnMinimize"-Event ändern
    Application.OnMinimize    := MinimizeNemp;
    Application.OnDeactivate  := DeactivateNemp;

    WebRadioInsertMode := PLAYER_PLAY_DEFAULT;
    MediaListPopupTag := 0;

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
    CloudViewer.PopupMenu := Medialist_Browse_PopupMenu;
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

    CloudViewer.StyleElements := [];

    //NewPlayerPanel.DoubleBuffered := True;

    // create and initialize FormBuilder
    NempFormBuildOptions := TNempFormBuildOptions.Create;

    NempFormBuildOptions.NewLayout := Layout_TwoRows;

    NempFormBuildOptions.MegaContainer  := self;
    NempFormBuildOptions.SuperContainer := __MainContainerPanel;
    NempFormBuildOptions.MainContainerA := _TopMainPanel;
    NempFormBuildOptions.MainContainerB := _VSTPanel;
    NempFormBuildOptions.ControlPanel.SetControlValues(_ControlPanel, ControlContainer1, ControlContainer2,
                                                OutputControlPanel, PlayerControlCoverPanel, PlayerControlPanel, HeadsetControlPanel, NewPlayerPanel, {SpectrumPanel,}
                                                'Player Control');
    NempFormBuildOptions.MainSplitter := MainSplitter;

    NempFormBuildOptions.ChildPanelMinHeight := CHILD_PANEL_MinHeight;
    NempFormBuildOptions.ChildPanelMinWidth  := CHILD_PANEL_MinWidth;

    NempFormBuildOptions.MainPanelMinHeight := MAIN_PANEL_MinHeight;
    NempFormBuildOptions.MainPanelMinWidth := MAIN_PANEL_MinWidth;


    // fill it with the default layout
    // define the ChildPanels and its content
    NempFormBuildOptions.BlockBrowse.SetValues(AuswahlPanel, AuswahlHeaderPanel, GRPBOXArtistsAlben, 'Nemp Coverflow');
    NempFormBuildOptions.BlockPlaylist.SetValues(PlaylistPanel, PlayerHeaderPanel, GRPBOXPlaylist, 'Nemp Playlist');
    NempFormBuildOptions.BlockMediaList.SetValues(MedialistPanel, MedienBibHeaderPanel, GRPBOXVST, 'Nemp Medialist');
    NempFormBuildOptions.BlockFileOverview.SetValues(MedienBibDetailPanel, MedienBibDetailHeaderPanel, ContainerPanelMedienBibDetails, 'Nemp File overview');
    // place them on the two MainPanels
    NempFormBuildOptions.PanelAChilds.Add(NempFormBuildOptions.BlockBrowse);
    NempFormBuildOptions.PanelAChilds.Add(NempFormBuildOptions.BlockPlaylist);

    NempFormBuildOptions.PanelBChilds.Add(NempFormBuildOptions.BlockMediaList);
    NempFormBuildOptions.PanelBChilds.Add(NempFormBuildOptions.BlockFileOverView);
    // Place the Splitters
    NempFormBuildOptions.SubSplitter1 := SubSplitter1;
    NempFormBuildOptions.SubSplitter2 := SubSplitter2;

    ///////////////////////////////////////

    // Create Player
    NempPlayer            := TNempPlayer.Create(FOwnMessageHandler);
    NempPlayer.Statusproc := StatusProc;
    NempPlayer.OnPlayerStopped := OnPlayerStopped;
    NempPlayer.OnMessage := OnPlayerMessage;

    // Create Playlist
    NempPlaylist        := TNempPlaylist.Create;
    NempPlaylist.VST    := PlaylistVST;
    NempPlaylist.Player := NempPlayer;
    NempPlaylist.MainWindowHandle := FOwnMessageHandler;
    NempPlaylist.OnCueChanged := PlaylistCueChanged;

    BibRatingHelper := TRatingHelper.Create;

    // Create Medialibrary
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

    MenuSkinImageList := TImageList.Create(Nemp_MainForm);
    MenuSkinImageList.Height := 16;
    MenuSkinImageList.Width := 16;

    NempSkin.FormBuilder := NempFormBuildOptions;

    // ------------------------------------
    // tmp code to save the menu-imagelist into a file,
    // as base for the MenuSkinImageList
   { ButtonTmp := TBitmap.Create;
    singleBtn := TBitmap.Create;
    try
      Buttontmp.PixelFormat := pf32bit;
      ButtonTmp.Width := 608;
      Buttontmp.Height := 16;
      //Nemp_MainForm.PlayListSkinImageList.Clear;
      for i := 0 to 37 do
      begin
          singleBtn.Canvas.Brush.Color := clWhite;
          singleBtn.Canvas.FillRect(rect(0,0,16,16));

          MenuImages.GetBitmap(i, singleBtn);

        Buttontmp.Canvas.CopyRect(
            rect(i*16,0,i*16+16, ButtonTmp.Height),
            singleBtn.Canvas,
            rect(0,0,16,16)
            );
        //Nemp_MainForm.PlayListSkinImageList.AddMasked(ButtonTmp,Buttontmp.Canvas.Pixels[0,0]);
      end;


      buttontmp.SaveToFile('F:\MenuImages.bmp');
    finally
      ButtonTmp.Free;
    end;
    }

    // ------------------------------------

    // Create Updater
    NempUpdater := TNempUpdater.Create(FOwnMessageHandler);

    // create WebServer
    NempWebServer := TNempWebServer.Create(FOwnMessageHandler);
    NempWebServer.SavePath := SavePath;
    NempWebServer.CoverSavePath := MedienBib.CoverSavePath;

    // create Spectrum
    Spectrum := TSpectrum.Create(PaintFrame.Width, PaintFrame.Height);
    Spectrum.MainImage := PaintFrame;
    Spectrum.StarImage := RatingImage;

    // Set some ShortCuts
    PM_PL_MagicCopyToClipboard.ShortCut :=
       Menus.ShortCut(Word('C'), [ssCtrl, ssShift]);
    PM_ML_MagicCopyToClipboard.ShortCut :=
       Menus.ShortCut(Word('C'), [ssCtrl, ssShift]);

    MainPlayerControlsActive := True;
    TabBtn_MainPlayerControl.GlyphLine := 1;
    ShowMatchingControls;//(TabBtn_MainPlayerControl.GlyphLine);

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
              if Tag = 0 then
              begin
                  // one Window
                  NempFormBuildOptions.WindowSizeAndPositions.MainFormWidth := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
                  NempFormBuildOptions.WindowSizeAndPositions.MainFormHeight := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
                  NempFormBuildOptions.WindowSizeAndPositions.MainFormTop := PosAndSize^.rcNormalPosition.Top;
                  NempFormBuildOptions.WindowSizeAndPositions.MainFormLeft := PosAndSize^.rcNormalPosition.Left;
              end else
              begin
                  // seperate Windows
                  NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormWidth := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
                  NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormHeight := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
                  NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormTop := PosAndSize^.rcNormalPosition.Top;
                  NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormLeft := PosAndSize^.rcNormalPosition.Left;
              end;
            {
            NempOptions.NempFormAufteilung[Tag].FormWidth := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
            NempOptions.NempFormAufteilung[Tag].FormHeight := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
            NempOptions.NempFormAufteilung[Tag].FormTop := PosAndSize^.rcNormalPosition.Top;
            NempOptions.NempFormAufteilung[Tag].FormLeft := PosAndSize^.rcNormalPosition.Left;
            }

          end;
        finally
          FreeMem(PosAndSize,SizeOf(TWindowPlacement))
        end;
        NempFormBuildOptions.WindowSizeAndPositions.MainFormMaximized := WindowState = wsMaximized;

        {
        NempOptions.NempFormAufteilung[Tag].TopMainPanelHeight := _TopMainPanel.Height;
        NempOptions.NempFormAufteilung[Tag].AuswahlPanelWidth  := AuswahlPanel.Width;
        NempOptions.NempFormAufteilung[Tag].ArtistWidth        := ArtistsVST.Width;
        NempOptions.NempFormAufteilung[Tag].Maximized          := WindowState = wsMaximized;
        }

        ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
        try
            ini.Encoding := TEncoding.UTF8;
            WriteNempOptions(ini, NempOptions, NempFormBuildOptions, AnzeigeMode);

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
        NempPlayer.NempLogFile.UpdateLogfile(SavePath + NEMP_NAME + '-PlayerLog.log');

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
        MedialistPanel.Parent := Nemp_MainForm;
        MedienBibDetailPanel.Parent := Nemp_MainForm;

        CoverScrollbar.WindowProc := OldScrollbarWindowProc;
        LyricsMemo.WindowProc := OldLyricMemoWindowProc;

        ST_Playlist.Free;
        ST_Medienliste.Free;
        FreeAndNil(DragDropList);
        TagLabelList.Clear;

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
  KeepOnWithLibraryProcess   := False;
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
    if CoverScrollbar.Position <> Integer(Msg.WParam) then
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
    pic: TPicture;
    success: Boolean;
    dummyAudioFile: TAudioFile;
    afList: TObjectList;
begin
  if NempIsClosing then exit;

  pic := TPicture.Create;
  bmp := TBitmap.Create;
  try
      bmp.PixelFormat := pf24bit;
      bmp.Height := 240;
      bmp.Width := 240;

      if MedienBib.CoverList.Count > msg.Index then
      begin
          aCover := TNempCover(MedienBib.CoverList[msg.Index]);

          case MedienBib.NewCoverFlow.Mode of
              cm_Classic: success := False; // we already failed during the painting process
              cm_OpenGL : success := GetCoverBitmapFromID(aCover.ID, pic, MedienBib.CoverSavePath);
          else
              success := True; // we are not in CoverflowMode at all, should not happen
          end;


          if (not success) and PreviewGraphicShouldExist(aCover.ID) then
          begin
              // file \coverSavepath\<id>.jpg is missing, even if it should exist (= it was manually deleted?)
              // try to recreate it from the image files already existing on the disc/id3Tag

              dummyAudioFile := TAudioFile.Create;
              try
                  // We do not have an "Audiofile" with this coverID right now, so get one first.
                  // this is needed, as otherwise we won't find the (now deleted) cover, if there's only cover art in
                  // the ID3Tag, ond no jpg-files at all around the mp3-files
                  afList := TObjectList.Create(False);
                  try
                      MedienBib.GetTitelListFromCoverID(afList, aCover.ID);
                      if afList.Count = 0 then
                          dummyAudioFile.Pfad := IncludeTrailingPathDelimiter(aCover.Directory) + 'foo.bar'
                      else
                          dummyAudioFile.GetAudioData(TAudioFile(afList[0]).Pfad)//, GAD_COVER)
                  finally
                      afList.Free;
                  end;

                  MedienBib.InitCover(dummyAudioFile, tm_VCL, True);
                  // try again getting the coverbitmap
                  success := GetCoverBitmapFromID(dummyAudioFile.CoverID, pic, MedienBib.CoverSavePath);
                  // if we found an image, but the ID has changed: Change it on the other files with that ID as well
                  if (dummyAudioFile.CoverID <> aCover.ID) then
                  begin
                      MedienBib.ChangeCoverID(aCover.ID, dummyAudioFile.CoverID);
                      if  MedienBib.NewCoverFlow.CurrentCoverID = aCover.ID then
                          MedienBib.NewCoverFlow.CurrentCoverID := dummyAudioFile.CoverID;
                      aCover.ID := dummyAudioFile.CoverID;
                  end;
              finally
                  dummyAudioFile.Free;
              end;
          end;

          FitBitmapIn(bmp, pic.Graphic);
          Medienbib.NewCoverFlow.SetPreview (msg.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);

          if (not success) and (MedienBib.CoverSearchLastFM) then
              Medienbib.NewCoverFlow.DownloadCover(aCover, msg.index);

      end;
  finally
      pic.free;
      bmp.Free;
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

      try
        OldScrollbarWindowProc(Message);
      except
          // silent exception - This "wuppdi" actually seems to work (I got the message sometimes)
          // and by that we'll get rid of some Exceptions druing WindowMode-Changing!
          // wuppdi;
      end;
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
          idx := Pos('/close', filename);
          if idx > 0 then
          begin
              close;
          end else
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

  // an empty string is recognized as faDirectory, so the ProgressWindow will be opened if we don't exit in this case
  if filename = '' then exit;

  ReallyDeletePlaylistTimer.Enabled := False;


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
          NempPlaylist.FileSearchCounter := 0;
          ProgressFormPlaylist.AutoClose := True;
          ProgressFormPlaylist.InitiateProcess(True, pa_SearchFilesForPlaylist);
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
  ReallyDeletePlaylistTimer.Enabled := True;
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
var o: TWinControl;
Begin
    Inherited;

    o := FindVCLWindow(Mouse.CursorPos);
    case GetDropWindowSection(o) of
          ws_none    : Handle_DropFilesForLibrary(aMsg); // default: add files also into the library
          ws_Library : Handle_DropFilesForLibrary(aMsg);
          ws_Playlist: Handle_DropFilesForPlaylist(aMsg, False);
          ws_Controls: begin
                          if MainPlayerControlsActive then
                              Handle_DropFilesForPlaylist(aMsg, True)
                          else
                              Handle_DropFilesForHeadPhone(aMsg)
                        end;
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
        if UseSkin then
        begin
            if NOT NempSkin.UseDefaultMenuImages then
                NempSkin.SetDefaultMenuImages;
        end;
         CorrectSkinRegionsTimer.Enabled := True;
        //CorrectSkinRegions;
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
    //UpdateFormDesignNeu;     ??? 08.2018 warum war das hier???

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

    // RePaintPanels;
    RepaintOtherForms;
    RepaintAll;
end;

procedure TNemp_MainForm.WindowsStandardClick(Sender: TObject);
begin
  NempSkin.DeActivateSkin;
  SetSkinRadioBox('');
  UseSkin := False;
  // RePaintPanels;
  RepaintOtherForms;
  RepaintAll;
end;


// Ein paar Routinen, die das Skinnen erleichtren
procedure TNemp_MainForm.Skinan1Click(Sender: TObject);
begin
  UseSkin := True;
  SkinName := StringReplace((Sender as TMenuItem).Caption,'&&','&',[rfReplaceAll]);
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
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(NempFormBuildOptions) then
        NempFormBuildOptions.ResizeSubPanel(AuswahlPanel, ArtistsVST, NempFormBuildOptions.BrowseArtistRatio);

    LblEmptyLibraryHint.Width := (GRPBOXArtistsAlben.Width - 50);
    LblEmptyLibraryHint.Left := 25;
    LblEmptyLibraryHint.Top := (GRPBOXArtistsAlben.Height - LblEmptyLibraryHint.Height) Div 2;
end;

Procedure TNemp_MainForm.AnzeigeSortMENUClick(Sender: TObject);
var oldAudioFile: TAudioFile;
begin
  if MedienBib.StatusBibUpdate >= 2 then exit;
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
      CON_TRACKGAIN: MedienBib.AddSorter(CON_TRACKGAIN, False);
      CON_ALBUMGAIN: MedienBib.AddSorter(CON_ALBUMGAIN, False);
  end;

  MedienBib.SortAnzeigeListe;

  // Anzeige im VST aktualisieren
  VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);
  case MedienBib.Sortparams[0].Direction of
      sd_Ascending  : VST.Header.SortDirection := sdAscending  ;
      sd_Descending : VST.Header.SortDirection := sdDescending ;
  end;

  FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);

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



procedure TNemp_MainForm.PM_ML_RemoveSelectedPlaylistsClick(Sender: TObject);
var FocussedAlbumNode, NewSelectNode: PVirtualNode;
    AlbumData: PStringTreeData;
    SelectedPlaylist: TJustaString;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

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
            AlbenVST.DeleteNode(FocussedAlbumNode);
            Medienbib.DeletePlaylist(SelectedPlaylist);

            if assigned(NewSelectNode) then
            begin
                AlbenVST.Selected[NewSelectNode] := True;
                AlbenVST.FocusedNode := NewSelectNode;
            end;

            if MedienBib.Alben.Count = 0 then
                AlbenVST.Header.Columns[0].Text := TreeHeader_Playlists
            else
                AlbenVST.Header.Columns[0].Text := TreeHeader_Playlists + ' (' + inttostr(MedienBib.Alben.Count) + ')';

            AlbenVST.Invalidate;
        end;
    end;
end;

procedure TNemp_MainForm.PM_ML_DeleteSelectedClick(Sender: TObject);
var i: Integer;
    SelectedMp3s: TNodeArray;
    FileList: TObjectList;
    nt, ct: Cardinal;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        TranslateMessageDLG((Medialibrary_GUIError3), mtInformation, [MBOK], 0);
        exit;
    end;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    SelectedMP3s := VST.GetSortedSelection(False);
    if length(SelectedMP3s) = 0 then
        exit;

    //VST.BeginUpdate;
    MedienBib.StatusBibUpdate := BIB_Status_ReadAccessBlocked;
    BlockGUI(3);
    KeepOnWithLibraryProcess := true;   // ok, apm is used

    ProgressFormLibrary.AutoClose := True;
    ProgressFormLibrary.InitiateProcess(True, pa_DeleteFiles);

    // Hier wird komplett gelöscht.
    // d.h.: aus der Medienliste entfernen und aus alle anderen Listen
    ct := GetTickCount;
    begin
        FileList := TObjectList.Create(False);
        try
            // collect Data first
            VSTSelectionToAudiofileList(VST, SelectedMP3s, FileList);
            // Delete Nodes
            VST.DeleteSelectedNodes;

            // in allen Listen löschen und MP3-File entfernen
            for i := 0 to FileList.Count-1 do
            begin
                //Data := VST.GetNodeData(SelectedMP3s[i]);
                MedienBib.DeleteAudioFile(TAudioFile(FileList[i]));

                nt := GetTickCount;
                if (nt > ct + 10) or (nt < ct) then
                begin
                    ct := nt;
                    ProgressFormLibrary.LblSuccessCount.Caption := IntToStr(i);
                    ProgressFormLibrary.MainProgressBar.Position := Round(i/FileList.Count * 100);
                    ProgressFormLibrary.Update;
                    Application.ProcessMessages;
                    if not KeepOnWithLibraryProcess then break;
                end;
            end;
        finally
            FileList.Free;
        end;
    end;
    ProgressFormLibrary.MainProgressBar.Position := 100;

    if KeepOnWithLibraryProcess then
        ProgressFormLibrary.LblMain.Caption := DeleteSelect_DeletingFilesComplete
    else
        // user aborted the operation
        ProgressFormLibrary.LblMain.Caption := MediaLibrary_OperationCancelled;

    ProgressFormLibrary.lblCurrentItem.Caption := '';
    ProgressFormLibrary.FinishProcess(jt_WorkingLibrary);

    //VST.EndUpdate;
    MedienBib.RepairBrowseListsAfterDelete;
    MedienBib.BuildTotalString;
    MedienBib.BuildTotalLyricString;
    ReFillBrowseTrees(True);

    // unblock GUI
    UnBlockGUI;
    KeepOnWithLibraryProcess := False;
    ShowSummary;
    MedienBib.StatusBibUpdate := BIB_Status_Free;

    ResetBrowsePanels;
end;




procedure TNemp_MainForm.MM_ML_DeleteClick(Sender: TObject);
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

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
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

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
          newdir := fb.SelectedItem;
          MedienBib.InitialDialogFolder := fb.SelectedItem;
          MedienBib.ST_Ordnerlist.Add(newdir);
          // DateiSuche starten
          if (Not ST_Medienliste.IsSearching) then
          begin
            PutDirListInAutoScanList(MedienBib.ST_Ordnerlist);
            MedienBib.StatusBibUpdate := 1;
            BlockGUI(1);
            StartMediaLibraryFileSearch;
          end;
      end;
  finally
      fb.Free;
  end;
end;

procedure TNemp_MainForm.MM_ML_LoadClick(Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if MedienBib.StatusBibUpdate <> 0 then
  begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
  end;

  if Opendialog1.Execute then
  begin
      MedienBib.Clear;
      LblEmptyLibraryHint.Caption := MainForm_LibraryIsLoading;
      MedienBib.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TNemp_MainForm.MM_ML_SaveClick(Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if MedienBib.StatusBibUpdate >= 2 then
  begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
  end;

  SaveDialog1.Filter := (Medialibrary_DialogFilter) + ' (*.gmp)|*.gmp';
  if SaveDialog1.Execute then
     MedienBib.SaveToFile(SaveDialog1.FileName, False);
end;


procedure TNemp_MainForm.DatenbankUpdateTBClick(Sender: TObject);
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
    else
        MedienBib.DeleteFilesUpdateBib;
end;

{
  -------------------
  HandleFiles
  -------------------
    Add some files to the Playlist.
    The file in aList a *Copies* of Files in the medialibrary (or otherwise not connected to the library)
    Adding these one by one (with Application.ProcessMessages) should be ok, even if
    the library is currently updating (collecting new files, deleting files, ...)
}
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
    for i := 1 to iMax do
    begin
          if ContinueWithPlaylistAdding then
              tmp := NempPlaylist.InsertFileToPlayList(TAudiofile(aList[i]))
          else
              // free the remaining Audiofiles. They are not needed any more
              TAudiofile(aList[i]).Free;

          if (i Mod 100 = 0) and ContinueWithPlaylistAdding then
          begin
              PlayListVST.ScrollIntoView( tmp, False, True);
              Application.ProcessMessages;
          end;
          // if Not ContinueWithPlaylistAdding then break;
          // No, we have to free the rest of the list now (2019), so finish the loop completely
    end;
    ContinueWithPlaylistAdding := False;
end;

{
    --------------------------
    GenerateListForHandleFiles
    --------------------------
    OnlyTemporaryFiles: FileList is only temporary used to create a proper FileNameList
    for a Drag&Drop- or Copy&Paste-Operation, and not actually used for a later call
    of "HandleFiles(aList)".
    so:  OnlyTemporaryFiles = True:  Store only references of existing audiofiles in aList
         OnlyTemporaryFiles = False: Store new created copies of audiofiles in aList

    Note: A Drag&Drop // Copy&Paste Operation MUST NOT call this method on a Webradio station !!

    return value: True iff a list actually has been generated, meaning no webradio station is tuning in

}
function TNemp_MainForm.GenerateListForHandleFiles(aList: tObjectList; what: integer; OnlyTemporaryFiles: Boolean): Boolean;
var i: integer;
  DataS: PStringTreeData;
  DataA: PTreeData;
  aNode: PVirtualNode;
  artist, album: UnicodeString;
  SelectedMp3s: TNodeArray;
  tmpFileList: TObjectList;
begin
  SelectedMP3s := Nil;
  /// meaning of parameter "what" changed
  ///       old:         new (2019)
  ///  --------------------------
  ///  0:   VST          artist/album, from ARTIST
  ///  100: -            artist/album, from ALBUM
  ///  1:   Artist       Coverflow
  ///  2:   album        TagCloud
  ///  3:   coverflow    VST
  ///  4:   tagcloud     (unused)

  result := True;
  DeleteAudioFilesAfterHandled := False;
  case what of
      0, 100: begin // BrwoseMode=0 ... Artist / Album
          aNode := ArtistsVST.FocusedNode;
          if assigned(aNode) then
          begin
            DataS  := ArtistsVST.GetNodeData(aNode);
            Artist := TJustAstring(DataS^.FString).DataString
          end else
            Artist := BROWSE_ALL;

          if what = 100 then
          begin
              // the user opened the menu within the album-VST
              aNode := AlbenVST.FocusedNode;
              if assigned(aNode) then
              begin
                  DataS := AlbenVST.GetNodeData(aNode);
                  Album := TJustAstring(DataS^.FString).DataString
              end else
                  Album := BROWSE_ALL;
          end else
              // the user opened the menu on the artist-VST, use "allAlbums"
              Album := BROWSE_ALL;

          if (Artist = BROWSE_PLAYLISTS) and (Album <> BROWSE_ALL) then //(letzteres sollte immer so sein ;-))
          begin
              LoadPlaylistFromFile(album, aList, Nempplaylist.AutoScan);
              if OnlyTemporaryFiles then
                  DeleteAudioFilesAfterHandled := True;
                  // the AudioFiles loaded into aList are only used temporarily (e.g. to fill a DragDropList with proper Filenames)
                  // but these files from LoadPlaylistFromFile are only referenced in this list now
                  // => MemoryLeak
                  // => delete the AudioFile-Objects after their temporary usage is done.
          end
          else
              if (Artist = BROWSE_RADIOSTATIONS) and (Album <> BROWSE_ALL) then //(letzteres sollte immer so sein ;-))
              begin

                  if Integer(aNode.Index) < MedienBib.RadioStationList.Count then
                  begin
                      result := False;
                      TStation(MedienBib.RadioStationList[aNode.Index]).TuneIn(NempPlaylist.BassHandlePlaylist)
                  end
                  else
                      TranslateMessageDLG(Shoutcast_MainForm_BibError, mtError, [mbOK], 0);
              end else
              begin
                  tmpFileList := TObjectList.Create(False);
                  try
                      MedienBib.GetTitelList(tmpFileList, Artist, Album);
                      // Sort
                      if tmpFileList.Count <= 5000 then
                          tmpFileList.Sort(Sortieren_AlbumTrack_asc);

                      // add files to the actual list
                      for i := 0 to tmpFileList.Count-1 do
                          if OnlyTemporaryFiles then
                              aList.Add(tmpFileList[i])
                          else
                              TAudioFile(tmpFileList[i]).AddCopyToList(aList);
                  finally
                      tmpFileList.Free;
                  end;
              end;
      end;

      1: begin
          // Quelle ist das Cover-Flow-Image
          tmpFileList := TObjectList.Create(False);
          try
              if CoverScrollbar.Position <= MedienBib.Coverlist.Count -1 then
                  MedienBib.GetTitelListFromCoverID(tmpFileList, TNempCover(MedienBib.Coverlist[CoverScrollbar.Position]).key);
              // Sortieren
              if tmpFileList.Count <= 5000 then
                  tmpFileList.Sort(Sortieren_AlbumTrack_asc);
              // add files to the actual list
              for i := 0 to tmpFileList.Count-1 do
                  if OnlyTemporaryFiles then
                      aList.Add(tmpFileList[i])
                  else
                      TAudioFile(tmpFileList[i]).AddCopyToList(aList);
          finally
              tmpFileList.Free;
          end;
      end;

      2: begin
          tmpFileList := TObjectList.Create(False);
          try
              MedienBib.GenerateDragDropListFromTagCloud(MedienBib.TagCloud.FocussedTag, tmpFileList);
                // Sortieren
              if tmpFileList.Count <= 5000 then
                  tmpFileList.Sort(Sortieren_AlbumTrack_asc);
              // add files to the actual list
              for i := 0 to tmpFileList.Count-1 do
                  if OnlyTemporaryFiles then
                      aList.Add(tmpFileList[i])
                  else
                      TAudioFile(tmpFileList[i]).AddCopyToList(aList);
          finally
              tmpFileList.Free;
          end;
      end;

      3: begin // Quelle ist der VST
          SelectedMP3s := VST.GetSortedSelection(False);
          for i:=0 to length(SelectedMP3s)-1 do
          begin
              DataA := VST.GetNodeData(SelectedMP3s[i]);
              if OnlyTemporaryFiles then
                  aList.Add(DataA^.FAudioFile)
              else
                  DataA^.FAudioFile.AddCopyToList(aList);
          end;
          // Nicht sortieren
      end;

  else
    TranslateMessageDLG('Uh-Oh. Something strange happens (GenerateListForHandleFiles). Please report this error.'
      + #13#10 + 'Param: ' + InttoStr(what) , mtWarning, [mbOK], 0);
  end;
end;


procedure TNemp_MainForm.EnqueueTBClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  try
      WebRadioInsertMode := PLAYER_ENQUEUE_FILES;
      if GenerateListForHandleFiles(Dateiliste, MediaListPopupTag, False) then
          HandleFiles(Dateiliste, PLAYER_ENQUEUE_FILES);
  finally
      FreeAndNil(DateiListe);
  end;
end;

procedure TNemp_MainForm.PM_ML_PlayClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  try
      WebRadioInsertMode := PLAYER_PLAY_FILES;
      if GenerateListForHandleFiles(Dateiliste, MediaListPopupTag, False) then
      begin
          if (NempPlaylist.Count > 20) AND (DateiListe.Count < 5) then
          begin
            if TranslateMessageDLG(Format((Playlist_QueryReallyDelete), [NempPlaylist.Count, DateiListe.Count]), mtWarning, [mbYes, mbNo], 0) = mrYes then
                HandleFiles(Dateiliste, PLAYER_PLAY_FILES)
            else
                HandleFiles(Dateiliste, PLAYER_ENQUEUE_FILES);
          end
          else
              HandleFiles(Dateiliste, PLAYER_PLAY_FILES);
      end;
  finally
      FreeAndNil(Dateiliste);
  end;
end;

procedure TNemp_MainForm.PM_ML_PlayNextClick(Sender: TObject);
var DateiListe: TObjectList;
begin
  DateiListe := TObjectList.Create(False);
  try
      WebRadioInsertMode := PLAYER_PLAY_NEXT;
      if GenerateListForHandleFiles(Dateiliste, MediaListPopupTag, False) then
          HandleFiles(Dateiliste, PLAYER_PLAY_NEXT);
  finally
      FreeAndNil(DateiListe);
  end;
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


{
  ***************************
  Activating MainMenu Items

  Note: check also PartyMode.CorrectMenuStuff
  ***************************
}
procedure TNemp_MainForm.MM_MedialibraryClick(Sender: TObject);
var LibraryIsIdle, LibraryNotCritical, LibraryNotBlockedByPartymode: Boolean;
begin
    /// MainMenu: MediaLibrary
    /// !! Align with Menuitems in the two PopUpMenus
    ///    Medialist_Browse_PopupMenuPopup
    ///    Medialist_View_PopupMenuPopup
    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    LibraryNotCritical := MedienBib.StatusBibUpdate <= 1;
    LibraryNotBlockedByPartymode := NOT NempSkin.NempPartyMode.DoBlockBibOperations;

    // Disable some items, if necessary
    MM_ML_SearchDirectory .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_Webradio        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    MM_ML_BrowseBy.Enabled := LibraryNotCritical ;
    MM_ML_Search  .Enabled := LibraryNotCritical ;

    MM_ML_Load        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_Save        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_ExportAsCSV .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_Delete      .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    MM_ML_RefreshAll         .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_DeleteMissingFiles .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    MM_T_CloudEditor         .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
end;

procedure TNemp_MainForm.MM_PlaylistClick(Sender: TObject);
var LibraryIsIdle, LibraryNotBlockedByPartymode, PlaylistNotBlockedByPartymode: Boolean;
begin
    /// MainMenu: Playlist
    /// !! Align with Menuitems in the PopUpMenu
    ///    PlayListPOPUPPopup
    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    LibraryNotBlockedByPartymode  := NOT NempSkin.NempPartyMode.DoBlockBibOperations;
    PlaylistNotBlockedByPartymode := NOT NempSkin.NempPartyMode.Active;  // we block all "mass actions" by default

    MM_PL_Directory          .Enabled := PlaylistNotBlockedByPartymode ; // only files allowed, no directories
    MM_PL_SortBy             .Enabled := PlaylistNotBlockedByPartymode ; // no sorting in partymode
    MM_PL_GeneraterandomPlaylist.Enabled := PlaylistNotBlockedByPartymode;
    MM_PL_Load               .Enabled := PlaylistNotBlockedByPartymode ; // load without deleting the current list is allowed
    MM_PL_DeleteMissingFiles .Enabled := PlaylistNotBlockedByPartymode ; // no removing of (missing) files
    MM_PL_RecentPlaylists    .Enabled := PlaylistNotBlockedByPartymode ;
    MM_PL_ClearPlaylist      .Enabled := PlaylistNotBlockedByPartymode ; // no. just no. ;-)
    MM_PL_Webstream          .Enabled := PlaylistNotBlockedByPartymode ;

    MM_PL_ExtendedAddToMedialibrary.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
end;

procedure TNemp_MainForm.MM_OptionsClick(Sender: TObject);
var PartyModeNotActive: Boolean;
begin
    /// MainMenu: Settings
    /// !! Align with MenuItmes in the PopupMenu
    /// Player_PopupMenuPopup
    //-----------------
    /// MainMenu: Tools
    /// done in: Player_PopupMenuPopup
    PartyModeNotActive := NOT NempSkin.NempPartyMode.Active;
    MM_O_Preferences .Enabled := PartyModeNotActive;
    MM_O_Wizard      .Enabled := PartyModeNotActive;
    MM_O_View        .Enabled := PartyModeNotActive;

    MM_O_FormBuilder.Enabled := Nemp_MainForm.AnzeigeMode = 0;
end;


{
  ***************************
  PopUp MediaListMenus
  ***************************
}


procedure TNemp_MainForm.Medialist_Browse_PopupMenuPopup(Sender: TObject);
var o: TComponent;
    PoppedAtAlbumVST, LibraryNotBlockedByPartymode: Boolean; // PoppedAtArtistVST

    SDataArtist: PStringTreeData;
    ArtistNode, AlbumNode: PVirtualNode;
    canPlay, LibraryIsIdle, LibraryNotCritical: Boolean;

    tmpCaption: String;
begin
    // The (smaller) menu for the Browsing part (top left of the form)
    // ---------------------------------------------------------------
    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    LibraryNotCritical := MedienBib.StatusBibUpdate <= 1;
    LibraryNotBlockedByPartymode := NOT NempSkin.NempPartyMode.DoBlockBibOperations;

    o := Screen.ActiveForm.ActiveControl;
    //PoppedAtArtistVST := assigned(o) AND (o.Name = 'ArtistsVST')     ;
    PoppedAtAlbumVST  := assigned(o) AND (o.Name = 'AlbenVST')       ;

    // Set the private field MediaListPopupTag properly, so that
    // GenerateListForHandleFiles within the PLay/Enqueue Event handlers will work correctly
    MediaListPopupTag := MedienBib.BrowseMode;
    if PoppedAtAlbumVST then
        MediaListPopupTag := MediaListPopupTag + 100; // so: MediaListPopupTag = 100 !!

    // BrowseBy doesn't make sense in TagCloud mode
    PM_ML_BrowseBy.Enabled := MedienBib.BrowseMode <> 2;

    // set proper menu caption fo "enqueue all of this <thing>"
    tmpCaption := MainForm_MenuCaptionsEnqueue;
    case MedienBib.BrowseMode of
        0: if PoppedAtAlbumVST then
              tmpCaption := GetProperMenuString(Integer(MedienBib.NempSortArray[2]))
           else
              tmpCaption := GetProperMenuString(Integer(MedienBib.NempSortArray[1]));
        1: tmpCaption := GetProperMenuString(1); // coverflow, use "album"
        2: tmpCaption := GetProperMenuString(6); // tag cloud
    end;
    PM_ML_EnqueueBrowse.Caption := tmpCaption;

    // Enabling of Play/Enqueue Buttons
    // Playing "all Playlists" or "all Webradio stations" doesn't make sense
    if MedienBib.BrowseMode = 0 then
    begin
        ArtistNode := ArtistsVST.FocusedNode;
        if assigned(ArtistNode) then
        begin
            SDataArtist := ArtistsVST.GetNodeData(ArtistNode);
            if (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_PLAYLISTS)
                 AND (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_RADIOSTATIONS)
            then
                // no All-Webradio/Playlists selected -> Play does make sense
                canPlay := True
            else
            begin
                // we need to check for a focussed album node
                AlbumNode  := AlbenVST.FocusedNode;
                // Playing does make sense, iff a playlist/webradio-station is selected
                canPlay := assigned(AlbumNode);
            end;
        end else
            // no artist selected, nothing to play
            canPlay := False
    end else
        canPlay := True;

    PM_ML_PlayBrowse    .Enabled := canPlay AND LibraryNotBlockedByPartymode;
    PM_ML_EnqueueBrowse .Enabled := canPlay;
    PM_ML_PlayNextBrowse.Enabled := canPlay;

    // SearchDirectory, MediaLibrary->, Webradio stations:
    // That WAS blocked through MediaLibray-Update-Logic before
    // changed to OnPopup (2019)
    PM_ML_BrowseBy.Enabled := LibraryNotCritical;

    PM_ML_SearchDirectory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    PM_ML_Medialibrary   .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibraryLoad             .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibrarySave             .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibraryExport           .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibraryDelete           .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibraryRefresh          .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_MedialibraryDeleteNotExisting.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
        PM_ML_CloudEditor                  .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    PM_ML_Webradio.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    PM_ML_RemoveSelectedPlaylists.Enabled := LibraryIsIdle
                                  AND LibraryNotBlockedByPartymode
                                  AND (medienbib.CurrentArtist = BROWSE_PLAYLISTS)
                                  AND assigned(AlbenVST.FocusedNode)
end;

procedure TNemp_MainForm.Medialist_View_PopupMenuPopup(Sender: TObject);
var SelectedMp3s: TNodeArray;
    SomeFilesSelected: Boolean;
    LibraryIsIdle, LibraryNotCritical, LibraryNotBlockedByPartymode: Boolean;
begin
    // the (bigger) menu for the viewing part (bottom of the form)
    // ---------------------------------------------------------------
    MediaListPopupTag := 3;

    SelectedMP3s := VST.GetSortedSelection(False);
    SomeFilesSelected  := length(SelectedMP3s) > 0;
    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    LibraryNotCritical := MedienBib.StatusBibUpdate <= 1;
    LibraryNotBlockedByPartymode := NOT NempSkin.NempPartyMode.DoBlockBibOperations;

    // Play-Buttons
    PM_ML_Enqueue    .Enabled := SomeFilesSelected;
    PM_ML_Play       .Enabled := SomeFilesSelected;
    PM_ML_PlayNext   .Enabled := SomeFilesSelected;
    PM_ML_PlayNow    .Enabled := SomeFilesSelected;
    PM_ML_PlayHeadset.Enabled := SomeFilesSelected;
    // Set default button
    PM_ML_Play    .Default := NempPlaylist.DefaultAction = 1;
    PM_ML_Enqueue .Default := NempPlaylist.DefaultAction = 0;
    PM_ML_PlayNext.Default := NempPlaylist.DefaultAction = 2;
    PM_ML_PlayNow .Default := NempPlaylist.DefaultAction = 3;

    // Sorting
    PM_ML_SortBy.Enabled := LibraryNotCritical;

    // Hide/remove
    PM_ML_HideSelected  .Enabled := SomeFilesSelected;
    PM_ML_DeleteSelected.Enabled := SomeFilesSelected AND LibraryIsIdle
                                                      AND LibraryNotBlockedByPartymode
                                                      AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);

    // Editing Files
    PM_ML_SetRatingsOfSelectedFilesCHOOSE.Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles1 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles2 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles3 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles4 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles5 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles6 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles7 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles8 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles9 .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_SetRatingsOfSelectedFiles10.Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
            PM_ML_ResetRating                .Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
    PM_ML_MarkFile.Enabled := LibraryIsIdle AND SomeFilesSelected;
            PM_ML_Mark1.Enabled := LibraryIsIdle AND SomeFilesSelected;
            PM_ML_Mark2.Enabled := LibraryIsIdle AND SomeFilesSelected;
            PM_ML_Mark3.Enabled := LibraryIsIdle AND SomeFilesSelected;
            PM_ML_Mark0.Enabled := LibraryIsIdle AND SomeFilesSelected;
    PM_ML_GetLyrics      .Enabled := LibraryIsIdle AND SomeFilesSelected
                                                   AND LibraryNotBlockedByPartymode
                                                   AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
    PM_ML_GetTags        .Enabled := LibraryIsIdle AND SomeFilesSelected
                                                   AND LibraryNotBlockedByPartymode
                                                   AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
    PM_ML_RefreshSelected.Enabled := LibraryIsIdle AND SomeFilesSelected
                                                   AND LibraryNotBlockedByPartymode
                                                   AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);

    // Clipboard
    PM_ML_CopyToClipboard      .Enabled := SomeFilesSelected;
    PM_ML_MagicCopyToClipboard .Enabled := SomeFilesSelected;
    PM_ML_PasteFromClipboard   .Enabled := LibraryIsIdle AND Clipboard.HasFormat(CF_HDROP) AND LibraryNotBlockedByPartymode;
    // Extended
    PM_ML_Extended.Enabled := assigned(VST.FocusedNode) AND LibraryNotCritical;

    // properties and details
    PM_ML_ShowInExplorer.Enabled :=  assigned(VST.FocusedNode);
    PM_ML_Properties    .Enabled :=  assigned(VST.FocusedNode) AND (NOT NempSkin.NempPartyMode.DoBlockDetailWindow);
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
    nt, ct: Cardinal;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

    // preparation
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    // Change in 2019,
    // bug: metadata inside of the file could have been deleted by this.
    //      (if view shows unscanned PlaylistFiles)
    //      The additional Sync with ID3tags resolves this as well, but nevertheless:
    //      set rating of playlist files is disabled
    if MedienBib.AnzeigeShowsPlaylistFiles then
    begin
        TranslateMessageDLG((Medialibrary_GUIError6), mtInformation, [MBOK], 0);
        exit;
    end;

    MedienBib.StatusBibUpdate := 3;
    BlockGUI(3);
    KeepOnWithLibraryProcess := true; // ok, apm is used
    fspTaskbarManager.ProgressState := fstpsNormal;
    fspTaskbarManager.ProgressValue := 0;

    TagMod100 := (Sender as TMenuItem).Tag Mod 100;
    if (Sender as TMenuItem).Tag >= 100 then
        LocalTree := VST
    else
        LocalTree := PlaylistVST;

    ProgressFormLibrary.AutoClose := True;
    ProgressFormLibrary.InitiateProcess(True, pa_UpdateMetaData);

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
            VSTSelectionToAudiofileList(LocalTree, SelectedMP3s, SelectedFiles);
            ct := GetTickCount;

            for iSel := 0 to SelectedFiles.Count-1 do
            begin
                CurrentAF := TAudioFile(SelectedFiles[iSel]);
                // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                CurrentAF.GetAudioData(CurrentAF.Pfad);

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
                      //aErr := CurrentAF.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                      aErr := CurrentAF.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);
                      if resetCounter then
                          aErr := CurrentAF.WritePlayCounterToMetaData(0, NempOptions.AllowQuickAccessToMetadata);

                      HandleError(afa_SaveRating, CurrentAF, aErr);
                      // correct GUI
                      CorrectVCLAfterAudioFileEdit(CurrentAF);

                nt := GetTickCount;
                if (nt > ct + 250) or (nt < ct) then
                begin
                    ct := nt;
                    fspTaskbarManager.ProgressValue := Round(iSel/SelectedFiles.Count * 100);
                    ProgressFormLibrary.lblSuccessCount.Caption := IntToStr(iSel);
                    ProgressFormLibrary.MainProgressBar.Position := Round(iSel/SelectedFiles.Count * 100);
                    ProgressFormLibrary.Update;
                    application.processmessages;
                    if not KeepOnWithLibraryProcess then break;
                end;
            end;
        finally
            SelectedFiles.Free;
        end;
    finally
        ListOfFiles.Free;
    end;
    MedienBib.Changed := True;

    ProgressFormLibrary.MainProgressBar.Position := 100;
    ProgressFormLibrary.LblMain.Caption := MediaLibrary_RatingComplete;
    ProgressFormLibrary.lblCurrentItem.Caption := '';
    ProgressFormLibrary.FinishProcess(jt_WorkingLibrary);

    // clean up stuff
    UnBlockGUI;

    KeepOnWithLibraryProcess := False;
    MedienBib.StatusBibUpdate := 0;
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

procedure TNemp_MainForm.PM_ML_SetmarkerClick(Sender: TObject);
begin
    SetMarker(Sender, ((Sender as TMenuItem).Tag Mod 100));
end;

procedure TNemp_MainForm.SetMarker(Sender: TObject; aValue: Byte);
var CurrentAF :TAudioFile;
    iSel, iList: Integer;
    SelectedMp3s: TNodeArray;
    SelectedFiles, ListOfFiles: TObjectList;
    LocalTree: TVirtualStringTree;
begin
    // a quick method. No Application.ProcessMessages needed, therefore no medienBib.StatusUpdate
    SelectedMp3s := Nil;
    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    if (Sender as TMenuItem).Tag >= 100 then
        LocalTree := VST
    else
        LocalTree := PlaylistVST;

    SelectedMP3s := LocalTree.GetSortedSelection(False);
    ListOfFiles := TObjectList.Create(False);
    try
        SelectedFiles := TObjectList.Create(False);
        try
            // Collect Data
            VSTSelectionToAudiofileList(LocalTree, SelectedMP3s, SelectedFiles);
            for iSel := 0 to SelectedFiles.Count-1 do
            begin
                CurrentAF := TAudioFile(SelectedFiles[iSel]);
                CurrentAF.Favorite := aValue;
                // get List of this AudioFile
                GetListOfAudioFileCopies(CurrentAF, ListOfFiles);
                // edit all these files
                for iList := 0 to ListOfFiles.Count - 1 do
                    TAudioFile(ListOfFiles[iList]).Favorite := aValue;
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
end;





procedure TNemp_MainForm.TabBtn_MarkerClick(Sender: TObject);
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;

    if (MedienBib.DisplayContent = DISPLAY_Favorites) or (TabBtn_Marker.Tag = 0) then
    begin
        // change the currently displayed marker
        TabBtn_Marker.Tag := (TabBtn_Marker.Tag + 1) mod 5;
        TabBtn_Marker.GlyphLine := TabBtn_Marker.Tag;
    end;
    // else: just re-display the current marker, do not change it for now
    MedienBib.ShowMarker(TabBtn_Marker.Tag);
end;


procedure TNemp_MainForm.TabBtn_MarkerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;
    if Button = mbRight then
    begin
        TabBtn_Marker.Tag := 0;
        TabBtn_Marker.GlyphLine := TabBtn_Marker.Tag;
        MedienBib.ShowMarker(TabBtn_Marker.Tag);
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



procedure TNemp_MainForm.ShowSummary(aList: TObjectList = Nil);
var i:integer;
  dauer:int64;
  groesse:int64;
  Liste: TObjectlist;
begin
  dauer:=0;
  groesse:=0;
  // ???
  if assigned(aList) then
      Liste := aList
  else
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
    //if (NempOptions.Language = 'de') then
    if (LeftStr(NempOptions.Language,2) = 'de') then
    begin
        ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-de.pdf';
        if NOT FileExists(ProperHelpFile) then
            ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-en.pdf';
    end else
    begin
        ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-en.pdf';
        if NOT FileExists(ProperHelpFile) then
            ProperHelpFile := ExtractFilePath(Paramstr(0))+'nemp-help-de.pdf';
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
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;
    MedienBib.RefreshFiles_All;
end;

procedure TNemp_MainForm.PM_ML_RefreshSelectedClick(Sender: TObject);
var i: Integer;
    SelectedMp3s: TNodeArray;
    SelectedFiles: TObjectList;

begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  SelectedMp3s := Nil;
  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  SelectedMP3s := VST.GetSortedSelection(False);
  SelectedFiles := TObjectList.Create(False);
  try
      // Collect Data
      VSTSelectionToAudiofileList(VST, SelectedMP3s, SelectedFiles);

      if MedienBib.AnzeigeShowsPlaylistFiles then
      begin
          TranslateMessageDLG((Medialibrary_GUIError6), mtInformation, [MBOK], 0);
          // removed. It doesn't make much sense anyway
          // if the user changes the selection in <Album> (= selects another playlist),
          // all data is lost again.
          // if the user wants nice metadata in the VST view on playlist files, he should
          // activate the scanning of playlist files
      end else
      begin
          // do it in a thread now
          MedienBib.UpdateList.Clear;
          // put selected files into UpdateList
          for i := 0 to SelectedFiles.Count - 1 do
              MedienBib.UpdateList.Add(SelectedFiles[i]);
          // refresh them in a thread
          MedienBib.RefreshFiles_Selected;
      end;
  finally
      SelectedFiles.Free;
  end;
end;




procedure TNemp_MainForm.PM_ML_PropertiesClick(Sender: TObject);
var AudioFile: TAudioFile;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    if NempSkin.NempPartyMode.DoBlockDetailWindow then
        exit;

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

          CON_FAVORITE :  if Data^.FAudioFile.Favorite <> 0 then CellText := ' ' // fav
                          else CellText := ' '; // noFav

          CON_LASTFMTAGS : CellText := ' ';// Data^.FAudioFile.RawTagLastFM;

          //CON_TRACKGAIN : Celltext := Data^.FAudioFile.TrackGainStr; //  'Track gain (todo)';
          //CON_ALBUMGAIN : Celltext := Data^.FAudioFile.AlbumGainStr; //  'Album gain (todo)';

          CON_TRACKGAIN : Celltext := GainValueToString(Data^.FAudioFile.TrackGain); //  'Track gain (todo)';
          CON_ALBUMGAIN : Celltext := GainValueToString(Data^.FAudioFile.AlbumGain); //  'Album gain (todo)';

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

  if Data^.FAudioFile = MedienBib.BibSearcher.DummyAudioFile then
      exit;

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


procedure TNemp_MainForm.VSTColumnClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var aFile: TAudioFile;
    ListOfFiles: TObjectList;
    iList: Integer;
    newMark: Byte;
    FileIsInLibrary: Boolean;
begin
    case VST.Header.Columns[column].Tag of
      CON_FAVORITE: begin
          aFile := GetFocussedAudioFile;
          if assigned(aFile) then
          begin
              newMark := (aFile.Favorite + 1) Mod 4;
              aFile.Favorite := newMark;
              ListOfFiles := TObjectList.Create(False);
              try
                  // get List of this AudioFile
                  FileIsInLibrary := GetListOfAudioFileCopies(aFile, ListOfFiles);
                  // edit all these files
                  for iList := 0 to ListOfFiles.Count - 1 do
                      TAudioFile(ListOfFiles[iList]).Favorite := newMark;
                  // correct GUI
                  CorrectVCLAfterAudioFileEdit(aFile);
              finally
                  ListOfFiles.Free;
              end;

              VST.InvalidateNode(VST.FocusedNode);
              MedienBib.Changed := True;

              if (NOT FileIsInLibrary) and (MedienBib.AnzeigeShowsPlaylistFiles) then
              begin
                  // Show warning, that the marker could not be saved.
                  AddErrorLog(MainForm_MarkerErrorPlaylistFiles);
              end;

          end;
      end;
    end;
end;

procedure TNemp_MainForm.VSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
  MediaListPopupTag := 3;

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
          FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);
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
  PM_ML_SortAscending.Checked := True;
end;

procedure TNemp_MainForm.MM_ML_SortDescendingClick(Sender: TObject);
begin
  PM_ML_SortDescending.Checked := True;
end;



procedure TNemp_MainForm.VSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i, maxC: Integer;
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

        maxC := min(NempOptions.maxDragFileCount, length(SelectedMp3s));
        if length(SelectedMp3s) > NempOptions.maxDragFileCount then
            AddErrorLog(Format(Warning_TooManyFiles, [NempOptions.maxDragFileCount]));

        for i := 0 to maxC - 1 do
        begin
            Data := aVST.GetNodeData(SelectedMP3s[i]);
            AddFile(Data^.FAudioFile.Pfad);
            DragDropList.Add(Data^.FAudioFile.Pfad);
            if (Data^.FAudioFile.Duration > MIN_CUESHEET_DURATION) then
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
            (vsSelected in Node.States) //AND
            //((Sender.Focused) OR ((Sender = PlaylistVST) and EditPlaylistSearch.Focused))
            then
        begin
          if Sender = PlaylistVST then
          begin
              if Sender.Focused then
                  font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[3]
              else
                  font.color := NempSkin.SkinColorScheme.Tree_UnfocusedColor[3]
          end
          else
            if Sender = VST then begin
                if Sender.Focused then
                    font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[4]
                else
                    font.color := NempSkin.SkinColorScheme.Tree_UnfocusedColor[4]
            end;
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



procedure TNemp_MainForm.MM_O_FormBuilderClick(Sender: TObject);
begin
    if not assigned(MainFormBuilder) then
        Application.CreateForm(TMainFormBuilder, MainFormBuilder);
    MainFormBuilder.Show;
    MainFormBuilder.BringToFront;
end;

procedure TNemp_MainForm.MM_O_PreferencesClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
    Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.Show;
  OptionsCompleteForm.BringToFront;
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
        MediaListPopupTag := 3; // Set the value to "VST"
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

    $54 {T}: if ssCtrl in shift then
              PM_P_ViewStayOnTopClick(NIL);

    $46: begin       // F
        if (ssCtrl in Shift) then
            EditFastSearch.SetFocus;
    end;


    VK_F7: begin
            if NOT NempSkin.NempPartyMode.Active then
                SwapWindowMode(AnzeigeMode + 1); // "mod 2" is done in this SwapWindowMode
           end;

    VK_F8: NempPlayer.PlayJingle(Nil);
  end;
end;




procedure TNemp_MainForm.VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var c, i: Integer;
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

  c := VST.RootNodeCount;
  if c > 1 then
      MedienListeStatusLBL.Caption := MedienListeStatusLBL.Caption + '; '
                                + Format((MainForm_Summary_FileCountTotal), [c] );

  aNode := VST.FocusedNode;
  if Assigned(aNode) then
  begin
      Data := VST.GetNodeData(aNode);
      AudioFile := Data^.FAudioFile;

      if AudioFile.IsLocalFile then
          AudioFile.ReCheckExistence;

      ShowVSTDetails(AudioFile, SD_MEDIENBIB);
      AktualisiereDetailForm(AudioFile, SD_MEDIENBIB);
  end
end;

procedure TNemp_MainForm.FillBibDetailLabels(aAudioFile: TAudioFile);
var tmp: String;
    function SetString(aString: String; add: String = ''): String;
    begin
        if Trim(aString) = '' then
            result := add + ' N/A'
        else
            result := aString;
    end;
    procedure SetLabelMouseActions(aLabel: TLabel; DoEnable: Boolean);
    begin
        if DoEnable then
        begin
            aLabel.OnDblClick := DetailLabelDblClick;
            aLabel.OnMouseEnter := DetailLabelMouseOver;
            aLabel.OnMouseLeave := DetailLabelMouseLeave;
        end else
        begin
            aLabel.OnDblClick := Nil;
            aLabel.OnMouseEnter := Nil;
            aLabel.OnMouseLeave := Nil;
        end;
    end;
begin
    if assigned(aAudioFile) then
    begin
        SetLabelMouseActions(LblBibArtist, (aAudioFile.IsValidArtist) AND ((aAudioFile.AudioType = at_File) or (aAudioFile.AudioType = at_CDDA)));
        SetLabelMouseActions(LblBibTitle , (aAudioFile.IsValidTitle)  AND ((aAudioFile.AudioType = at_File) or (aAudioFile.AudioType = at_CDDA)));
        SetLabelMouseActions(LblBibAlbum , (aAudioFile.IsValidAlbum)  AND ((aAudioFile.AudioType = at_File) or (aAudioFile.AudioType = at_CDDA)));
        SetLabelMouseActions(LblBibYear  , (aAudioFile.IsValidYear)   AND ((aAudioFile.AudioType = at_File) or (aAudioFile.AudioType = at_CDDA)));
        SetLabelMouseActions(LblBibGenre , (aAudioFile.IsValidGenre)  AND ((aAudioFile.AudioType = at_File) or (aAudioFile.AudioType = at_CDDA)));

        case aAudioFile.AudioType of
            at_Undef  : LblBibArtist    .Caption := 'ERROR: UNDEFINED AUDIOTYPE'; // should never happen
            at_File,
            at_CDDA : begin
                LblBibArtist.Caption := SetString(aAudioFile.GetReplacedArtist(NempOptions.ReplaceNAArtistBy),AudioFileProperty_Artist);
                LblBibTitle .Caption := SetString(aAudioFile.GetReplacedTitle(NempOptions.ReplaceNATitleBy), AudioFileProperty_Title);

                tmp := SetString(aAudioFile.GetReplacedAlbum(NempOptions.ReplaceNAAlbumBy), AudioFileProperty_Album);
                if aAudioFile.Track <> 0 then
                    tmp := tmp + Format(', Track %d', [aAudioFile.Track]);
                LblBibAlbum .Caption := tmp;

                tmp := SetString(aAudioFile.Year, AudioFileProperty_Year);
                if tmp <> '0' then
                    LblBibYear  .Caption := tmp
                else
                    LblBibYear  .Caption := AudioFileProperty_Year + ' N/A';
                LblBibGenre .Caption := SetString(aAudioFile.Genre, AudioFileProperty_Genre);

                if aAudioFile.IsValidArtist then
                    LblBibArtist  .Hint := Format(MainForm_DoublClickToSearchArtist ,[aAudioFile.Artist])
                else LblBibArtist .Hint := '';

                if aAudioFile.IsValidTitle then
                    LblBibTitle  .Hint := Format(MainForm_DoublClickToSearchTitle  ,[aAudioFile.Titel])
                else LblBibTitle .Hint := '';

                if aAudioFile.IsValidAlbum then
                    LblBibAlbum   .Hint := Format(MainForm_DoublClickToSearchAlbum  ,[aAudioFile.Album])
                else LblBibAlbum  .Hint := '';

                if aAudioFile.IsValidYear then
                    LblBibYear    .Hint := Format(MainForm_DoublClickToSearchYear   ,[aAudioFile.Year])
                else LblBibYear   .Hint := '';

                if aAudioFile.IsValidGenre then
                    LblBibGenre   .Hint := Format(MainForm_DoublClickToSearchGenre  ,[aAudioFile.Genre])
                else LblBibGenre  .Hint := '';

            end;
            at_Stream : begin
                LblBibArtist.Caption := SetString(aAudioFile.Description, AudioFileProperty_Name);
                LblBibTitle .Caption := SetString(aAudioFile.Ordner, AudioFileProperty_URL);
                LblBibAlbum .Caption := SetString(aAudioFile.Titel, AudioFileProperty_Title);
                LblBibYear  .Caption := inttostr(aAudioFile.Bitrate) + ' kbit/s';
                LblBibGenre .Caption := '(' + AudioFileProperty_Webstream + ')';;

                LblBibArtist.Hint := '';
                LblBibTitle .Hint := '';
                LblBibAlbum .Hint := '';
                LblBibYear  .Hint := '';
                LblBibGenre .Hint := '';
            end;
        end;
    end;
end;


procedure TNemp_MainForm.MM_Warning_ID3TagsClick(Sender: TObject);
begin
    // if TranslateMessageDLG(Format(MediaLibrary_InconsistentFilesHintCount, [MM_Warning_ID3Tags.Tag]), mtInformation, [mbYes,MBNo], 0) = mrYes then
    // begin
        // This action will start a new thread!
        if MedienBib.StatusBibUpdate <> 0 then
            MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
        else
        begin
            if not GetSpecialPermissionToChangeMetaData then exit;

            MedienBib.StatusBibUpdate := 1;
            BlockGUI(1);
            // Fill UpdateList
            MedienBib.PutInconsistentFilesToUpdateList;
            MedienBib.UpdateId3tags;
        end;
    // end;
end;


procedure TNemp_MainForm.PopupEditExtendedTagsPopup(Sender: TObject);
var enableEditExtendeTag: Boolean;
begin
    CurrentTagToChange :=  '';
    if (PopupEditExtendedTags.PopupComponent is TLabel) then
    begin

        CurrentTagToChange := (PopupEditExtendedTags.PopupComponent as TLabel).Caption;
    end;

    enableEditExtendeTag := CurrentTagToChange <>  '';

    PM_AddTagThisFile    .Visible := NempOptions.AllowQuickAccessToMetadata;
    PM_RemoveTagThisFile .Visible := NempOptions.AllowQuickAccessToMetadata;
    PM_RenameTagThisFile .Visible := NempOptions.AllowQuickAccessToMetadata;
    PM_TagIgnoreList     .Visible := NempOptions.AllowQuickAccessToMetadata;
    PM_TagMergeList      .Visible := NempOptions.AllowQuickAccessToMetadata;
    N1                   .Visible := NempOptions.AllowQuickAccessToMetadata;
    N79                  .Visible := NempOptions.AllowQuickAccessToMetadata;

    PM_RemoveTagThisFile.Enabled := enableEditExtendeTag and NempOptions.AllowQuickAccessToMetadata;
    PM_RenameTagThisFile.Enabled := enableEditExtendeTag and NempOptions.AllowQuickAccessToMetadata;
    PM_TagIgnoreList    .Enabled := enableEditExtendeTag and NempOptions.AllowQuickAccessToMetadata;
    PM_TagMergeList     .Enabled := enableEditExtendeTag and NempOptions.AllowQuickAccessToMetadata;
end;

procedure TNemp_MainForm.pm_TagDetailsClick(Sender: TObject);
begin
    if not assigned(MedienBib.CurrentAudioFile) then
        exit;
    AutoShowDetailsTMP := True;
    AktualisiereDetailForm(MedienBib.CurrentAudioFile, pm_TagDetails.Tag, True);
end;


{
----------------------------------------
Tag Management: Handle a single File
----------------------------------------
}

procedure TNemp_MainForm.DetailLabelDblClickNewTag(Sender: TObject);
var newTagDummy: String;
    backup: UTF8String;
    IgnoreWarningsDummy: Boolean;
begin
    backup := MedienBib.CurrentAudioFile.RawTagLastFM;

    if HandleSingleFileTagChange(MedienBib.CurrentAudioFile, '', newTagDummy, IgnoreWarningsDummy) then
        DoSyncStuffAfterTagEdit(MedienBib.CurrentAudioFile,backup);
end;

procedure TNemp_MainForm.PM_RenameTagThisFileClick(Sender: TObject);
var newTagDummy: String;
    backup: UTF8String;
    IgnoreWarningsDummy: Boolean;
begin
    backup := MedienBib.CurrentAudioFile.RawTagLastFM;

    if HandleSingleFileTagChange(MedienBib.CurrentAudioFile, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
        DoSyncStuffAfterTagEdit(MedienBib.CurrentAudioFile,backup);
end;

procedure TNemp_MainForm.PM_RemoveTagThisFileClick(Sender: TObject);
var backup: UTF8String;
begin
    if not assigned(MedienBib.CurrentAudioFile) then
        exit;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
    then
    begin
        backup := MedienBib.CurrentAudioFile.RawTagLastFM;
        MedienBib.CurrentAudioFile.RemoveTag(CurrentTagToChange);

        DoSyncStuffAfterTagEdit(MedienBib.CurrentAudioFile,backup);
    end;
end;


{
----------------------------------------
Tag Management: Global Rules
----------------------------------------
}
procedure TNemp_MainForm.PM_TagIgnoreListClick(Sender: TObject);
var backup: UTF8String;
begin
    if not assigned(MedienBib.CurrentAudioFile) then
        exit;

    backup := MedienBib.CurrentAudioFile.RawTagLastFM;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
    then
    begin
        if HandleIgnoreRule(CurrentTagToChange) then
        begin
            // update the current File NOW
            MedienBib.CurrentAudioFile.ChangeTag(CurrentTagToChange, '');
            DoSyncStuffAfterTagEdit(MedienBib.CurrentAudioFile, backup);

            // show the tags again.
            CreateTagLabels(MedienBib.CurrentAudioFile);

            // update all files, show hint to activate the Looooong procedure later.
            MedienBib.ChangeTags(CurrentTagToChange, '');
            SetGlobalWarningID3TagUpdate;

            // Set a warning in the tab button, if we are using the tag cloud right now for browsing
            SetBrowseTabCloudWarning(True);
        end;
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);

end;

procedure TNemp_MainForm.PM_TagMergeListClick(Sender: TObject);
var backup: UTF8String;
    newTag: String;
begin
    if not assigned(MedienBib.CurrentAudioFile) then
        exit;

    // the tag to ignore is stored in the global variable "CurrentTagToChange"
    backup := MedienBib.CurrentAudioFile.RawTagLastFM;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> MedienBib.CurrentAudioFile.Pfad)
    then
    begin
        if HandleMergeRule(CurrentTagToChange, newTag) then
        begin
            // update the current File NOW
            MedienBib.CurrentAudioFile.ChangeTag(CurrentTagToChange, newTag);
            DoSyncStuffAfterTagEdit(MedienBib.CurrentAudioFile, backup);
            // show the tags again.
            CreateTagLabels(MedienBib.CurrentAudioFile);

            // update all files, show hint to activate the Looooong procedure later.
            MedienBib.ChangeTags(CurrentTagToChange, newTag);
            SetGlobalWarningID3TagUpdate;

            // Set a warning in the tab button, if we are using the tag cloud right now for browsing
            SetBrowseTabCloudWarning(True);
        end;

    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;


{
----------------------------------------
Tag Management: Navigation and stuff
----------------------------------------
}

procedure TNemp_MainForm.DetailLabelMouseOver(Sender: TObject);
begin
    (Sender as Tlabel).Font.Style := (Sender as Tlabel).Font.Style + [fsUnderline];
    // to remove the tag through the Popup Menu
    // This will be called on "regular labels" as well, but that shouldn't be a problem.
    CurrentTagToChange := (Sender as Tlabel).Caption;
end;

procedure TNemp_MainForm.DetailLabelMouseLeave(Sender: TObject);
begin
    (Sender as Tlabel).Font.Style := (Sender as Tlabel).Font.Style - [fsUnderline];
end;

// click on a Tag-Label
procedure TNemp_MainForm.DetailTagLabelDblClick(Sender: TObject);
begin
    MedienBib.GlobalQuickTagSearch((Sender as TLabel).Caption);
end;

// click on a Artist/Album/Titel7Genre/Year-Label
procedure TNemp_MainForm.DetailLabelDblClick(Sender: TObject);
var KeyWords: TSearchKeyWords;
    tmpGenreList: TStringList;

begin
    // Show all Files from the clicked Artist/Album/Year/Genre
    if not assigned(MedienBib.CurrentAudioFile) then
        exit;

    //Medienbib.BibSearcher.SearchOptions.SearchParam := 0;      // New Search
    Medienbib.BibSearcher.SearchOptions.AllowErrors := False;  // no errors allowed
    KeyWords.General   := '';
    KeyWords.Artist    := '';
    KeyWords.Album     := '';
    KeyWords.Titel     := '';
    KeyWords.Pfad      := '';
    KeyWords.Kommentar := '';
    KeyWords.Lyric     := '';

    Medienbib.BibSearcher.SearchOptions.SkipGenreCheck  := True;
    Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := True;


    case (Sender as TLabel).Tag of
        0: begin  // artist
            KeyWords.Artist := MedienBib.CurrentAudioFile.Artist;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        1: begin  // title  ... for cover songs and other versions?
            KeyWords.Titel := MedienBib.CurrentAudioFile.Titel;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        2: begin // album
            KeyWords.Album  := MedienBib.CurrentAudioFile.Album;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        4: begin // year
            Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := False;
            Medienbib.BibSearcher.SearchOptions.WhichYearCheck := 2; // exact match

            Medienbib.BibSearcher.SearchOptions.MinMaxYear := strtointdef(MedienBib.CurrentAudioFile.Year, 0);
            Medienbib.BibSearcher.SearchOptions.IncludeNAYear := False;
            Medienbib.BibSearcher.SearchOptions.Include0Year := False;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        5: begin // genre
            tmpGenreList := TStringList.Create;
            try
                tmpGenreList.Add(MedienBib.CurrentAudioFile.Genre);
                Medienbib.BibSearcher.SearchOptions.GenreStrings := tmpGenreList;
                Setlength(Medienbib.BibSearcher.SearchOptions.GenreChecked, 1);
                Medienbib.BibSearcher.SearchOptions.GenreChecked[0] := true;
                Medienbib.BibSearcher.SearchOptions.SkipGenreCheck  := False;
                Medienbib.BibSearcher.SearchOptions.IncludeNAGenres := False;
                MedienBib.CompleteSearchNoSubStrings(Keywords);
            finally
                tmpGenreList.Free;
            end;
        end;
    end;
end;

procedure TNemp_MainForm.CreateTagLabels(aAudioFile: TAudioFile);
var newLabel: TLabel;
    i: Integer;
    currentTop, CurrentLeft, newWidth, newHeight: Integer;
    tmpTagList: TStringlist;
    baseLeft: Integer;
begin

    TagLabelList.Clear;
    currentTop := LblBibPlayCounter.Top + LblBibPlayCounter.Height + 12;

    baseLeft := 8;
    currentLeft := baseleft;

    //if NempOptions.AllowQuickAccessToMetadata then
    //    VDTCover.PopupMenu := PopupEditExtendedTags;
    //else
    //    VDTCover.PopupMenu := Nil;

    if assigned(aAudioFile) then
    begin
        case aAudioFile.AudioType of
            at_File: begin
                tmpTagList := TStringlist.Create;
                try
                    tmpTagList.Text := String(aAudioFile.RawTagLastFM);
                    for i := 0 to tmpTagList.Count - 1 do
                    begin
                        newLabel := TLabel.Create(Nil);
                        TagLabelList.Add(newLabel);

                        newLabel.Parent := DetailID3TagPanel;
                        //newLabel.Parent := sbFileOverview;
                        newLabel.ShowAccelChar := False;
                        newLabel.AutoSize := True;
                        newLabel.Caption := tmpTagList[i];
                        newLabel.Tag := 10000 + i;
                        newLabel.OnMouseEnter := DetailLabelMouseOver;
                        newLabel.OnMouseLeave := DetailLabelMouseLeave;
                        newLabel.OnDblClick := DetailTagLabelDblClick;
                        if NempOptions.AllowQuickAccessToMetadata then
                            newLabel.PopupMenu := PopupEditExtendedTags;
                        newLabel.Hint := Format(MainForm_DoublClickToSearchTags, [tmpTagList[i]]);
                        if NempSkin.isActive then
                        begin
                            newLabel.Color       := NempSkin.SkinColorScheme.LabelBackGroundCL;
                            newLabel.Font.Color  := NempSkin.SkinColorScheme.LabelCL;
                            newLabel.Transparent := NempSkin.DrawTransparentLabel;
                            newLabel.StyleElements :=  [seClient, seBorder];
                        end;

                        newWidth := newLabel.Width;   //newLabel.Canvas.TextWidth(tmpTagList[i]);
                        newHeight:= newLabel.Height;  //newLabel.Canvas.TextHeight(tmpTagList[i]);

                        if currentLeft + newWidth < DetailID3TagPanel.Width then
                        begin
                            newLabel.Top := currentTop;
                            newLabel.Left := currentLeft;
                            currentLeft := currentLeft + newWidth + 15;
                        end else
                        begin
                            currentTop :=  currentTop + newHeight;
                            newLabel.Top := currentTop;
                            newLabel.Left := baseLeft;
                            currentLeft := baseLeft + newWidth + 15;
                        end;
                    end;
                finally
                    tmpTagList.Free;
                end;
                // add "last tag" for editing.
                if (NempOptions.AllowQuickAccessToMetadata) and (aAudioFile.HasSupportedTagFormat) then
                begin
                    newLabel := TLabel.Create(Nil);
                    TagLabelList.Add(newLabel);

                    newLabel.Parent := DetailID3TagPanel;
                    newLabel.AutoSize := True;
                    newLabel.Caption := MainForm_DoublClickToAddTag;
                    newLabel.Tag := -1;
                    newLabel.OnMouseEnter := DetailLabelMouseOver;
                    newLabel.OnMouseLeave := DetailLabelMouseLeave;
                    newLabel.OnDblClick := DetailLabelDblClickNewTag;
                    newLabel.Hint := MainForm_DoublClickToAddTagHint;
                    if NempSkin.isActive then
                    begin
                        newLabel.Color       := NempSkin.SkinColorScheme.LabelBackGroundCL;
                        newLabel.Font.Color  := NempSkin.SkinColorScheme.LabelCL;
                        newLabel.Transparent := NempSkin.DrawTransparentLabel;
                        newLabel.StyleElements :=  [seClient, seBorder];
                    end;

                    newWidth := newLabel.Width;
                    newHeight:= newLabel.Height;

                    if currentLeft + newWidth < DetailID3TagPanel.Width then
                    begin
                        newLabel.Top := currentTop;
                        newLabel.Left := currentLeft;
                    end else
                    begin
                        currentTop :=  currentTop + newHeight;
                        newLabel.Top := currentTop;
                        newLabel.Left := baseLeft;
                    end;
                end;

            end
        else
            // nothing;
            // other types of audiofiles do not support additional Tags.
        end;
    end;

end;

procedure TNemp_MainForm.RefreshVSTCover(aAudioFile: TAudioFile);
begin
    if assigned(aAudioFile) then
    begin
        // clear current image  (needed because of Transparencies)
        ImgDetailCover.Picture.Assign(Nil);
        ImgDetailCover.Refresh;

        if (ImgDetailCover.Width * ImgDetailCover.Height) > 0 then
        begin
            ImgDetailCover.Picture.Bitmap.Width := ImgDetailCover.Width;
            ImgDetailCover.Picture.Bitmap.Height := ImgDetailCover.Height;

            // Bild holen - (das ist ne recht umfangreiche Prozedur!!)
            GetCover(aAudioFile, ImgDetailCover.Picture, False); // False: Only get the cover from the ID, nothing else
                                                   // or maybe more, if aAudioFile is in the Playlist??

            ImgDetailCover.Picture.Assign(ImgDetailCover.Picture);
            ImgDetailCover.Refresh;
        end;
    end;
end;

procedure TNemp_MainForm.RefreshVSTCoverTimerTimer(Sender: TObject);
begin
    // refresh the VST-Cover after a resize of this part
    // this will result in a better display of the cover than just using the
    // image-stretch property.
    RefreshVSTCoverTimer.Enabled := False;
    if assigned(MedienBib) then
        RefreshVSTCover(MedienBib.CurrentAudioFile);

    if assigned(MedienBib) then
        CreateTagLabels(MedienBib.CurrentAudioFile);
end;

procedure TNemp_MainForm.ShowVSTDetails(aAudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
var
    tmp: String;
begin
  MedienBib.CurrentAudioFile := aAudioFile;
  if Source <> - 1 then
      pm_TagDetails.Tag := Source;

  LblBibArtist  .Visible :=  assigned(aAudioFile);
  LblBibTitle   .Visible :=  assigned(aAudioFile);
  LblBibAlbum   .Visible :=  assigned(aAudioFile);
  LblBibYear    .Visible :=  assigned(aAudioFile);
  LblBibGenre   .Visible :=  assigned(aAudioFile);

  LblBibDuration    .Visible :=  assigned(aAudioFile);
  LblBibPlayCounter .Visible :=  assigned(aAudioFile);
  LblBibQuality     .Visible :=  assigned(aAudioFile);

  ImgBibRating  .Visible :=  assigned(aAudioFile);


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
  CreateTagLabels(aAudioFile);

  // Get Cover
  RefreshVSTCover(aAudiofile);

  if assigned(aAudioFile) and (trim(String(aAudioFile.Lyrics)) <> '') then   // put this into RefreshVSTCover-Method???
      LyricsMemo.Text := String(aAudioFile.Lyrics)
  else
      LyricsMemo.Text := MainForm_Lyrics_NoLyrics;

  if not assigned(aAudiofile) then
       exit;

  case aAudioFile.AudioType of
      at_File: begin
          LblBibDuration  .Caption := SekToZeitString(aAudioFile.Duration)
                                    + ', ' + FloatToStrF((aAudioFile.Size / 1024 / 1024),ffFixed,4,2) + ' MB';
          if aAudioFile.vbr then
              tmp := inttostr(aAudioFile.Bitrate) + ' kbit/s (vbr), '
          else
              tmp := inttostr(aAudioFile.Bitrate) + ' kbit/s, ';
          LblBibQuality.Caption := tmp + aAudioFile.SampleRate + ', ' + aAudioFile.ChannelMode;
          ImgBibRating.Visible := True;
          BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
          LblBibPlayCounter.Caption := Format(DetailForm_PlayCounter, [aAudioFile.PlayCounter]);
      end;

      at_Stream: begin
          ImgBibRating.Visible := False;
          LblBibDuration  .Caption := '';
          LblBibPlayCounter.Caption := '';
          LblBibQuality.Caption := '';
      end;

      at_CDDA: begin
          LblBibDuration  .Caption := SekToZeitString(aAudioFile.Duration) ;
          LblBibQuality.Caption := 'CD-Audio';
          ImgBibRating.Visible := False;
          LblBibPlayCounter.Caption := '';
      end;
  end;
end;

procedure TNemp_MainForm.ImgDetailCoverDblClick(Sender: TObject);
begin
    if assigned(MedienBib.CurrentAudioFile) then
    begin
        AutoShowDetailsTMP := True;
        AktualisiereDetailForm(MedienBib.CurrentAudioFile, SD_PLAYLIST, True);
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
          if (Sender = CoverImage) then
          begin
              if self.MainPlayerControlsActive then
                  af := NempPlayer.MainAudioFile
              else
                  af := NempPlayer.HeadSetAudioFile;
          end
          else
          if (Sender = ImgDetailCover) then
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



procedure TNemp_MainForm.ImgBibRatingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i, newRating: Integer;
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
              // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
              MedienBib.CurrentAudioFile.GetAudioData(MedienBib.CurrentAudioFile.Pfad);
              ListOfFiles := TObjectList.Create(False);
              try
                  // get List of this AudioFile
                  GetListOfAudioFileCopies(MedienBib.CurrentAudioFile, ListOfFiles);
                  newRating := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
                  // edit all these files
                  for i := 0 to ListOfFiles.Count - 1 do
                  begin
                      listFile := TAudioFile(ListOfFiles[i]);
                      listFile.Rating := newRating;
                  end;
                  // write the rating into the file on disk
                  // aErr := MedienBib.CurrentAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                  aErr := MedienBib.CurrentAudioFile.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);
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
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

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
        BlockGUI(1);

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
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

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
        BlockGUI(1);

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
      end
(*  else
  begin
      if (Node = NempPlaylist.LastHighlightedSearchResultNode) then
      begin
        if NempSkin.isActive then
        begin
            //ItemColor := NempSkin.SkinColorScheme.Tree_UnfocusedSelectionColor[3];
            //EraseAction := eaColor;
        end;
        {else
            Pen.Color := clGradientActiveCaption;
        pen.Width := 1;//3;
        pen.Style := psDot; // psDash;

        Polyline([Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent) * Integer(PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1),
              Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Top+1),
              Point(ItemRect.Left+1 + (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node))), ItemRect.Top+1)]
              );
              }
      end;
  end;
  *)
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
        pen.Style := psSolid; //psDot; // psDash;

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

    MedienBib.ReBuildCoverListFromList(MedienBib.AnzeigeListe);

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
          (vsSelected in Node.States) // AND (Sender.Focused)
      then
      begin
          if Sender = ArtistsVST then
          begin
              if Sender.Focused then
                  font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[1]
              else
                  font.color := NempSkin.SkinColorScheme.Tree_UnfocusedColor[1]
          end else
          begin
              if Sender = AlbenVST then
              begin
                  if Sender.Focused then
                      font.color := NempSkin.SkinColorScheme.Tree_FontSelectedColor[2]
                  else
                      font.color := NempSkin.SkinColorScheme.Tree_UnfocusedColor[2]
              end
          end;
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
procedure TNemp_MainForm.MainSplitterMoved(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if not assigned(NempFormBuildOptions) then
        exit;

    //NempOptions.NempFormRatios.VSTHeight := Round(_TopMainPanel.Height / Height * 100);    
    NempFormBuildOptions.OnMainSplitterMoved(Sender);

    if NempSkin.isActive then
    begin
        NempSkin.RepairSkinOffset;
        NempSkin.SetVSTOffsets;
        RepaintPanels;
    end;
end;

// vertical splitter between player and Browse
procedure TNemp_MainForm.SubSplitter1Moved(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(NempFormBuildOptions) then
        NempFormBuildOptions.OnSplitterMoved(Sender);

    if NempSkin.isActive then
    begin
        NempSkin.FitSkinToNewWindow;
        RepaintPanels;
    end;
end;

//vertical splitter between Artist and Album
procedure TNemp_MainForm.SplitterBrowseMoved(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if not FormReadyAndActivated then
        exit;

    if assigned(NempFormBuildOptions) then
        NempFormBuildOptions.BrowseArtistRatio := Round(ArtistsVST.Width / AuswahlPanel.Width * 100);
end;

procedure TNemp_MainForm.Splitter4CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin

end;

// vertical splitter between VST and Cover
procedure TNemp_MainForm.SubSplitter2Moved(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if not assigned(NempFormBuildOptions) then
        exit;
            
    NempFormBuildOptions.OnSplitterMoved(Sender);     

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
          if MainPlayerControlsActive then
          begin
              // draw visualisation
              NempPlayer.DrawMainPlayerVisualisation; // (SlideBarButton.Tag = 0);
              // ... progress (Time, SlideButton)
              ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
          end;

          //... scroll taskbar title
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


procedure TNemp_MainForm.PlayerControlPanelClick(Sender: TObject);
begin
    FocusControl(VolButton);
end;


procedure TNemp_MainForm.HeadsetControlPanelClick(Sender: TObject);
begin
    FocusControl(VolButtonHeadset);
end;



procedure TNemp_MainForm.HeadSetTimerTimer(Sender: TObject);
begin
    if NempPlayer.BassHeadSetStatus = BASS_ACTIVE_PLAYING then
    begin
        if NOT MainPlayerControlsActive then
          begin
              // draw visualisation
              NempPlayer.DrawHeadsetVisualisation;
              // ... progress (Time, SlideButton)
              ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset, False);
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
  ARect.TopLeft :=  PlaylistVST.ClientToScreen(Point(0,0));
  ARect.BottomRight :=  PlaylistVST.ClientToScreen(Point(PlaylistVST.Width, PlaylistVST.Height));
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
    NempPlaylist.PlaylistHasChanged := True;
end;


procedure TNemp_MainForm.VSTEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    ClipCursor(Nil);
    NempPlaylist.ReInitPlaylist;
    DragDropTimer.Enabled := True;
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
var newProgress: Double;
begin
  newProgress := x / SlideBarShape.Width;

  if MainPlayerControlsActive then
      NempPlaylist.Progress := newProgress
  else
      NempPlayer.HeadsetProgress := newProgress;

  SetProgressButtonPosition(newProgress);

  // sometimes the button can't be dragged directly after a click on the shape.
  // therefore, start dragging here as well.
  SlideBarButton.BeginDrag(false);
  SlideBarButton.Visible := True;
end;

procedure TNemp_MainForm.ShowSlideBarButtonAtCorrectPosition;
begin
    if MainPlayerControlsActive then
         SetProgressButtonPosition(NempPlayer.Progress)
    else
        SetProgressButtonPosition(NempPlayer.HeadsetProgress);

    SlideBarButton.Visible := True;
end;

procedure TNemp_MainForm.SlideBarShapeMouseEnter(Sender: TObject);
begin
    ShowSlideBarButtonAtCorrectPosition;
end;

procedure TNemp_MainForm.SlideBarShapeMouseLeave(Sender: TObject);
begin
    SlideBarButton.Visible := False;
end;

procedure TNemp_MainForm.SlideBarButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
    with (Sender as TControl) do Begindrag(false);
    ARect.TopLeft :=  NewPlayerPanel.ClientToScreen(Point(0,0));
    ARect.BottomRight :=  NewPlayerPanel.ClientToScreen(Point(NewPlayerPanel.Width, NewPlayerPanel.Height));
    SlideBarButton.Tag := 1;
    ClipCursor(@Arect);
end;


procedure TNemp_MainForm.VolButton_HeadsetStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
    with VolButtonHeadset do Begindrag(false);
    ARect.TopLeft :=  HeadsetControlPanel.ClientToScreen(Point(0,0));
    ARect.BottomRight :=  HeadsetControlPanel.ClientToScreen(Point(HeadsetControlPanel.Width, HeadsetControlPanel.Height));
    ClipCursor(@Arect);
end;


procedure TNemp_MainForm.ab1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
    with (Sender as TControl) do
        Begindrag(false);

    (Sender as TControl).BringToFront;
    SlideBarButton.BringToFront;

    ARect.TopLeft :=  NewPlayerPanel.ClientToScreen(Point(0,0));
    ARect.BottomRight :=  NewPlayerPanel.ClientToScreen(Point(NewPlayerPanel.Width, NewPlayerPanel.Height));

    SlideBarButton.Tag := 1;
    ClipCursor(@Arect);
end;


procedure TNemp_MainForm.ab1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    ClipCursor(NIL);
    SlideBarButton.Tag := 0;

    NempPlayer.SetABSyncs(
        (ABRepeatStartImg.Left - SlideBarShape.Left) / (SlideBarShape.Width),
        (ABRepeatEndImg.Left + ABRepeatEndImg.Width - SlideBarShape.Left) / (SlideBarShape.Width)
        );

end;

procedure TNemp_MainForm.GrpBoxControlDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var NewPos: Integer;

    procedure CheckBounds(aMin, aMax: Integer);
    begin
        if NewPos <= aMin then NewPos := aMin
        else
            if NewPos >= aMax then NewPos := aMax;
    end;

begin
    if Source = SlideBarButton then
    begin
        if (Sender is TNempPanel) then
            NewPos := x - (SlideBarButton.Width Div 2)
        else
            NewPos := (Sender as TControl).Left + x - (SlideBarButton.Width Div 2);

        CheckBounds(SlideBarShape.Left - (SlideBarButton.Width Div 2), SlideBarShape.Width + SlideBarShape.Left - (SlideBarButton.Width Div 2));
        SlideBarButton.Left := NewPos;

        if (SlidebarButton.Tag = 1) and not SlidebarButton.Visible then
             SlidebarButton.Visible := True;

        if MainPlayerControlsActive then
            PlayerTimeLbl.Caption := NempPlayer.GetTimeStringFromProgress(ProgressButtonPositionToProgress)
        else
            PlayerTimeLbl.Caption := NempPlayer.GetHeadsetTimeStringFromProgress(ProgressButtonPositionToProgress);
    end else
        if Source = VolButton then
        begin
            if (Sender is TNempPanel) then
                NewPos := x - (VolButton.Width Div 2)
            else
                NewPos := (Sender as TControl).Left + x - (VolButton.Width Div 2);

            CheckBounds(VolShape.Left, VolShape.Left + VolShape.Width - VolButton.Width);
            VolButton.Left := NewPos;

            NempPlayer.Volume := VCLVolToPlayer;
        end else
            if (source = ab1) or (source = ab2) then
            begin
                if (Sender is TNempPanel) then
                    NewPos := x - ((source as TControl).Width Div 2)
                else
                    NewPos := (Sender as TControl).Left + x - ((source as TControl).Width Div 2);

                CheckBounds(SlideBarShape.Left, SlideBarShape.Width  + SlideBarShape.Left - (source as TControl).Width);
                (source as TControl).Left := NewPos;
                SwapABImagesIfNecessary(Source as TImage);

                if (Source as TImage) = ABRepeatStartImg then
                    PlayerTimeLbl.Caption := NempPlayer.GetTimeStringFromProgress((ABRepeatStartImg.Left - SlideBarShape.Left ) / SlideBarShape.Width)
                else
                    PlayerTimeLbl.Caption := NempPlayer.GetTimeStringFromProgress((ABRepeatEndImg.Left + ABRepeatEndImg.Width - SlideBarShape.Left) / SlideBarShape.Width);
            end else
                if Source = VolButtonHeadset then
                begin
                    if (Sender is TNempPanel) then
                        NewPos := x - (VolButtonHeadset.Width Div 2)
                    else
                        NewPos := (Sender as TControl).Left + x - (VolButtonHeadset.Width Div 2);

                    CheckBounds(VolShapeHeadset.Left, VolShapeHeadset.Left + VolShapeHeadset.Width - VolButtonHeadset.Width);
                    VolButtonHeadset.Left := NewPos;

                    NempPlayer.HeadSetVolume := Round((VolButtonHeadset.Left - VolShapeHeadset.Left)  * (100/(VolShapeHeadset.Width - VolButtonHeadset.Width)));
                end;
end;

procedure TNemp_MainForm.SlideBarButtonEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
    if MainPlayerControlsActive then
    begin
        NempPlaylist.Progress := ProgressButtonPositionToProgress;
        ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
    end
    else
    begin
        // NempPlayer is enough here, we do not handle Cue-Stuff in Headset
        NempPlayer.HeadsetProgress := ProgressButtonPositionToProgress;
        ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset, False);
    end;

  SlideBarButton.Tag := 0;
  ClipCursor(NIL);
end;


procedure TNemp_MainForm.VolButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
    with VolButton do Begindrag(false);
    ARect.TopLeft :=  PlayerControlPanel.ClientToScreen(Point(0,0));
    ARect.BottomRight :=  PlayerControlPanel.ClientToScreen(Point(PlayerControlPanel.Width, PlayerControlPanel.Height));
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

procedure TNemp_MainForm.BtnLoadHeadsetClick(Sender: TObject);
begin
    // Play new song in headset
    NempPlayer.PlayInHeadset(MedienBib.CurrentAudioFile);
    // Show Details
    DisplayHeadsetTitleInformation(False);
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
begin
    if not assigned(FPlayWebstream) then
        Application.CreateForm(tFPlayWebstream, FPlayWebstream);

    case FPlayWebstream.ShowModal of
        mrOK: begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            if Sender = PM_PlayWebstream then
                WebRadioInsertMode := PLAYER_PLAY_NOW;
            NempPlayer.MainStation.URL := FPlayWebstream.edtURL.Text;
            NempPlayer.MainStation.TuneIn(NempPlaylist.BassHandlePlaylist);
        end;
        mrRetry: begin
            if not assigned(FormStreamVerwaltung) then
                Application.CreateForm(TFormStreamVerwaltung, FormStreamVerwaltung);
            FormStreamVerwaltung.show;
        end;
    end;
end;

procedure TNemp_MainForm.SlideBackBTNIMGClick(Sender: TObject);
begin
    if MainPlayerControlsActive then
    begin
        NempPlaylist.Time := NempPlaylist.Time - 5;
        ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
    end
    else begin
        NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 5;
        ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset, False);
    end;
end;
procedure TNemp_MainForm.SlideForwardBTNIMGClick(Sender: TObject);
begin
    if MainPlayerControlsActive then
    begin
        NempPlaylist.Time := NempPlaylist.Time + 5;
        ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
    end
    else
    begin
        NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 5;
        ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset, False);
    end;

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
    i, newRating: Integer;
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
                  // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                  NempPlayer.MainAudioFile.GetAudioData(NempPlayer.MainAudioFile.Pfad);

                  ListOfFiles := TObjectList.Create(False);
                  try
                      // get List of this AudioFile
                      GetListOfAudioFileCopies(NempPlayer.MainAudioFile, ListOfFiles);
                      newRating := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);
                      // edit all these files
                      for i := 0 to ListOfFiles.Count - 1 do
                      begin
                          listFile := TAudioFile(ListOfFiles[i]);
                          listFile.Rating := newRating
                      end;
                      // write the rating into the file on disk
                      // aErr := NempPlayer.MainAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                      aErr := NempPlayer.MainAudioFile.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);
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

    // Show Headset Controls and File Details
    TabBtn_MainPlayerControl.GlyphLine := 1;
    MainPlayerControlsActive := False;
    ShowMatchingControls;//(1);
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



procedure TNemp_MainForm.MM_T_PlaylistLogClick(Sender: TObject);
begin
    if not assigned(PlayerLogForm) then
        Application.CreateForm(TPlayerLogForm, PlayerLogForm);
    PlayerLogForm.Show;
end;

procedure TNemp_MainForm.PM_PL_PropertiesClick(Sender: TObject);
var AudioFile:TAudioFile;
    Node: PVirtualNode;
    Data: PTreeData;
begin
    if NempSkin.NempPartyMode.DoBlockDetailWindow then
        exit;

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
end;

procedure TNemp_MainForm.PM_PL_ReplayGain_Click(Sender: TObject);
var aVST: TVirtualStringtree;
    Data: PTreeData;
    SelectedMp3s: TNodeArray;
    i: Integer;
    FileList: TObjectList;
    RGMode: TRGCalculationMode;
    CopyFiles: Boolean;
begin

    if assigned(NempReplayGainCalculator) then
    begin
        TranslateMessageDLG((Progressform_ReplayGain_AlreadyRunning), mtInformation, [MBOK], 0);
        exit;
    end;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    // determine Source and ReplayGain calculation setting
    if (Sender as TMenuItem).Tag >= 100 then
        aVST := self.PlaylistVST
    else
        aVST := self.VST;

    case (Sender as TMenuItem).Tag Mod 100 of
        0: RGMode := RG_Calculate_SingleTracks  ;
        1: RGMode := RG_Calculate_SingleAlbum   ;
        2: RGMode := RG_Calculate_MultiAlbums   ;
        3: RGMode := RG_Delete_ReplayGainValues ;
    else
        RGMode := RG_Calculate_SingleTracks  ;
    end;

    // collect files to scan from the TreeView
    FileList := TObjectList.Create(False);
    try
        SelectedMp3s := aVST.GetSortedSelection(False);
        for i := 0 to length(SelectedMp3s) - 1 do
        begin
            if aVST.GetNodeLevel(Selectedmp3s[i]) = 0 then
            begin
                Data := aVST.GetNodeData(SelectedMP3s[i]);
                // only add actual files (no webradio, CDDA, ..)
                if Data^.FAudioFile.IsFile then
                    FileList.Add(Data^.FAudioFile);
            end;
        end;

        // sort the list by Album for AlbumGain calculation
        FileList.Sort(Sortieren_AlbumTrack_asc);

        // if the source is the Playlist-VST, or the Library-VST is showing PlaylistFiles, then we
        // have to copy the files for the ReplayGain Calculator.
        CopyFiles :=   (aVst = PlaylistVST)
                    OR ((aVst = VST) and MedienBib.AnzeigeShowsPlaylistFiles);

        // start the calculation in a secondary thread
        ReplayGainProgressForm.Show;
        ReplayGainProgressForm.InitiateReplayGainCalculation(FileList, RGMode, CopyFiles);

    finally
        FileList.Free;
    end;
end;

// replayGain-Calculation from the "Browse-Lists, Coverflow, TagCloud"
procedure TNemp_MainForm.PlaylistVSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var aNode: PVirtualNode;
  Data: PTreeData;
  AudioFile: TAudioFile;
  c,i:integer;
  dauer:int64;
  groesse:int64;
  SelectedMP3s: TNodeArray;
  cueSelected: Boolean;
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
  cueSelected := False;

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

          at_Cue: cueSelected := True;

          at_CDDA: dauer := dauer + AudioFile.Duration; // size is not available
      end;
  end;

  if cueSelected then
  begin
      // Nemp does not (yet) get details about a "CUE-File", so put some "unknown" into the caption
      if c = 1 then
          PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCueCountSingle), [c])

          // no further data available; only 1 cue sheet selected, nothing else
      else begin
          if dauer  = 0 then
              // only cue sheets selected
              PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCueCountMultiOnlyCue), [c])
          else
              // cue sheets and files selected
              PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCueCountMulti), [c])
                                              + SizeToString(groesse)
                                              + SekToZeitString(dauer)
      end;
  end else
  begin
      if c = 1 then
          PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountSingle), [c])
                                    + SizeToString(groesse)
                                    + SekToZeitString(dauer)
      else
          PlayListStatusLBL.Caption := Format((MainForm_Summary_SelectedFileCountMulti), [c])
                                    + SizeToString(groesse)
                                    + SekToZeitString(dauer);
  end;

  aNode := PlaylistVST.FocusedNode;
  if not Assigned(aNode) then Exit;

  if PlaylistVST.GetNodeLevel(aNode) > 0 then
  begin
      aNode := anode.Parent;
      Data := PlaylistVST.GetNodeData(aNode);
      AudioFile := Data^.FAudioFile;
      ShowVSTDetails(AudioFile, SD_PLAYLIST);
  end else
  begin
      NempPlaylist.ActualizeNode(aNode, false);

      Data := PlaylistVST.GetNodeData(aNode);
      AudioFile := Data^.FAudioFile;
      ShowVSTDetails(AudioFile, SD_PLAYLIST);
      AktualisiereDetailForm(AudioFile, SD_PLAYLIST);
  end;
end;


/// Switch between MainPlayer-Controls and Headset-Controls
procedure TNemp_MainForm.TabBtn_MainPlayerControlClick(Sender: TObject);
begin
    TabBtn_MainPlayerControl.GlyphLine := 1;
    TabBtn_Headset.GlyphLine := 0;
    MainPlayerControlsActive := True;
    ShowMatchingControls;

    if NempPlaylist.AutoStopHeadsetSwitchTab then
        NempPlayer.PauseHeadset;
end;
procedure TNemp_MainForm.TabBtn_HeadsetClick(Sender: TObject);
begin
    TabBtn_Headset.GlyphLine := 1;
    TabBtn_MainPlayerControl.GlyphLine := 0;
    MainPlayerControlsActive := False;
    ShowMatchingControls;
end;

procedure TNemp_MainForm.ShowMatchingControls;
begin
    PlayerControlPanel.Visible  := MainPlayerControlsActive;
    HeadsetControlPanel.Visible := NOT MainPlayerControlsActive;

    if PlayerControlCoverPanel.Visible then
            ControlContainer1.Width := OutputControlPanel.Width + PlayerControlCoverPanel.Width
                               + PlayerControlPanel.Width
        else
            ControlContainer1.Width := OutputControlPanel.Width + PlayerControlPanel.Width;

    CorrectVCLForABRepeat;

    if MainPlayerControlsActive then
        DisplayPlayerMainTitleInformation(True) // Show Information about MainAudioFile
    else
        DisplayHeadsetTitleInformation(True);   // Show Information about Headset-AudioFile
end;



procedure TNemp_MainForm.ShowProgress(aProgress: Double; aSeconds: Integer; MainPlayer: Boolean);
begin
    SlidebarShape.Progress := aProgress;

    if (SlideBarButton.Tag = 0) then // d.h. der Button wird grade nicht gedraggt
    begin
        if LastPaintedTime <> aSeconds then
        begin
            if MainPlayer then
               playerTimeLbl.Caption := NempPlayer.TimeString
            else
                playerTimeLbl.Caption := NempPlayer.TimeStringHeadset;
            LastPaintedTime := aSeconds;
            // Refresh Win7 preview
            fspTaskbarPreviews1.InvalidatePreview;
        end;
        if (SlideBarButton.Visible) then
            SetProgressButtonPosition(aProgress);
    end;
end;

procedure TNemp_MainForm.ReCheckAndSetProgressChangeGUIStatus;
var SlidebarEnabled: Boolean;
begin
    if MainPlayerControlsActive then
    begin
        // Main Player
        if assigned(NempPlayer.MainAudioFile) then
            SlidebarEnabled := (not NempPlayer.URLStream) and (not NempPlayer.PrescanInProgress)
        else
            SlidebarEnabled := False;
    end else
    begin
        // Headset
        if assigned(NempPlayer.HeadSetAudioFile) then
            SlidebarEnabled := (not NempPlayer.HeadSetAudioFile.isStream)
        else
            SlidebarEnabled := False;
    end;

    SlideBackBTN.    Enabled := SlidebarEnabled;
    SlideForwardBtn .Enabled := SlidebarEnabled;
    SlideBarShape   .Enabled := SlidebarEnabled;
    SlidebarButton  .Enabled := SlidebarEnabled;
end;

procedure TNemp_MainForm.OnPlayerMessage(Sender: TObject; aMessage: String);
begin
    PlayerArtistLabel.Caption := aMessage;
    PlayerTitleLabel.Caption  :=  '';
    spectrum.DrawClear;
    // refreshing is necessary during connecting to a webstream
    PlayerArtistLabel.Refresh;
    PlayerTitleLabel.Refresh;
end;

procedure TNemp_MainForm.OnPlayerStopped(Sender: TObject);
begin
    PlayerArtistLabel.Caption := '';
    PlayerTitleLabel.Caption :=  '';
    spectrum.DrawClear;
end;

procedure TNemp_MainForm.PlaylistCueChanged(Sender: TObject);
begin
    if MainPlayerControlsActive then
    begin
        if assigned(NempPlayer.MainAudioFile) then
        begin
            PlayerArtistLabel.Caption := NempPlayer.PlayerLine1;
            PlayerTitleLabel.Caption  := NempPlayer.PlayerLine2;
        end;
    end;
end;


// new procedure ... fit it in somehow ...
procedure TNemp_MainForm.DisplayPlayerMainTitleInformation(GetCoverWasSuccessful: Boolean);
var fn, aHint: String;
    af: TAudioFile;
begin
    if MainPlayerControlsActive then
    begin
          CoverImage.Picture.Assign(Nil);
          CoverImage.Refresh;
          if assigned(NempPlayer.MainAudioFile) then
          begin
              af := NempPlayer.MainAudioFile;
              PlayerArtistLabel.Caption := NempPlayer.PlayerLine1;
              PlayerTitleLabel.Caption  := NempPlayer.PlayerLine2;

              aHint := af.GetHint(NempOptions.ReplaceNAArtistBy,
                                   NempOptions.ReplaceNATitleBy,
                                   NempOptions.ReplaceNAAlbumBy);

              // Rating
              Spectrum.DrawRating(af.Rating);

              // Cover
              CoverImage.Picture.Assign(NempPlayer.MainPlayerPicture);
              CoverImage.Hint := aHint;

              // initiate Cover Download, if necessary (and allowed by User)
              if NOT GetCoverWasSuccessful then
              begin
                  if MedienBib.CoverSearchLastFM then
                      Medienbib.NewCoverFlow.DownloadPlayerCover(af);
              end;

              // Progress
              ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
              ReCheckAndSetProgressChangeGUIStatus;

              // vis
              NempPlayer.DrawMainPlayerVisualisation;
              PaintFrame.Hint := aHint;

          end else
          begin
              PlayerArtistLabel.Caption := Player_NoTitleLoaded;
              PlayerTitleLabel.Caption := '';  //Player_NoTitleLoadedDropHereToStart;

              // rating
              Spectrum.DrawRating(0);

              // cover
              fn := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_MainPlayer.png';
              if FileExists(fn) then
                  CoverImage.Picture.LoadFromFile(fn);
              CoverImage.Hint := '';

              // zero progress
              SetProgressButtonPosition(0);
              SlideBarShape.Progress := 0;
              // disable Slidebar
              ReCheckAndSetProgressChangeGUIStatus;

              // clear vis
              NempPlayer.DrawMainPlayerVisualisation;
              PaintFrame.Hint := '';
          end;
    end;

end;

procedure TNemp_MainForm.DisplayHeadsetTitleInformation(GetCoverWasSuccessful: Boolean);
var fn, aHint: String;
    af: TAudioFile;
begin
    if not MainPlayerControlsActive then
    begin
        CoverImage.Picture.Assign(Nil);
        if assigned(NempPlayer.HeadSetAudioFile) then
        begin
            // display information about the Headset Title
            af := NempPlayer.HeadSetAudioFile;

            aHint := af.GetHint(NempOptions.ReplaceNAArtistBy,
                                   NempOptions.ReplaceNATitleBy,
                                   NempOptions.ReplaceNAAlbumBy);

            // artist + title
            if NempPlayer.HeadSetAudioFile.Artist <> '' then
                PlayerArtistLabel.Caption := af.Artist
            else
                PlayerArtistLabel.Caption := Player_UnkownArtist;
            PlayerTitleLabel.Caption := af.NonEmptyTitle;

            // Rating
            Spectrum.DrawRating(af.Rating);

            // Cover //no cover download for headset
            CoverImage.Picture.Assign(NempPlayer.HeadsetPicture);
            CoverImage.Hint := aHint;

            // Progress
            ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSec, False);

            // visualisation
            NempPlayer.DrawHeadsetVisualisation;
            Paintframe.Hint := aHint;

            // enable/disable slidebar
            ReCheckAndSetProgressChangeGUIStatus;

            HeadSetTimer.Enabled := NempPlayer.BassHeadSetStatus = BASS_ACTIVE_PLAYING;
        end else
        begin
            // default information
            PlayerArtistLabel.Caption := Player_NoTitleLoaded;
            PlayerTitleLabel.Caption := '';

            // rating
            Spectrum.DrawRating(0);

            // Cover
            CoverImage.Hint := '';
            fn := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_headphone.png';
            if FileExists(fn) then
                CoverImage.Picture.LoadFromFile(fn);

            // zero progress
            SetProgressButtonPosition(0);
            SlideBarShape.Progress := 0;
            // disable Slidebar
            ReCheckAndSetProgressChangeGUIStatus;

            // clear vis
            NempPlayer.DrawHeadsetVisualisation;
            PaintFrame.Hint := '';
        end;

    end;
end;

procedure TNemp_MainForm.ReInitPlayerVCL(GetCoverWasSuccessful: Boolean);
begin
    // called from: CreateHelper - StuffToDoAfterCreate (if not playing) to init the display
    //              Player.Play
    //              Player.ReversePlayback ( should be changed, probably, move DirectionButton-Stuff into another procedure)
                                           // But no; Direction is Set to "forwards" on ".Play"
                                           // Or call effectForm.refreshDirectionButtons from here (if needed)?

    // Reset Effect-Buttons
    if assigned(FormEffectsAndEqualizer) then
        FormEffectsAndEqualizer.ResetEffectButtons;

    // Reset AB-Repeat-Buttons
    CorrectVCLForABRepeat;      // Only if Main-Display, not for Headset? ??? - Check ! todo
                                // if called from Player.ReversePlayback, we need to check for Main/Headset-Display!!

    // general information (Application-Level, show always this)
    if NempPlayer.MainStream = 0 then
    begin
        Application.Title := NEMP_NAME_TASK;
        NempTrayIcon.Hint := 'Nemp - Noch ein mp3-Player';
    end else
    begin
        Application.Title := NempPlayer.GenerateTaskbarTitel;
        NempTrayIcon.Hint := StringReplace(NempPlayer.MainAudioFile.PlaylistTitle, '&', '&&&', [rfReplaceAll]);
    end;

    DisplayPlayerMainTitleInformation(GetCoverWasSuccessful);
    DisplayHeadsetTitleInformation(GetCoverWasSuccessful);
end;


procedure TNemp_MainForm.CoverImageDblClick(Sender: TObject);
var af: TAudioFile;
begin
    if  MainPlayerControlsActive then
        af := NempPlaylist.PlayingFile    // MainControls -> show Details of current PlayingFile
    else
       af := NempPlayer.HeadSetAudioFile; // HeadsetControls -> show Details of current HeadsetFile

    if assigned(af) then
    begin
        AutoShowDetailsTMP := True;
        AktualisiereDetailForm(af, SD_PLAYLIST, True);
        // note: there may be an issue with "SD_PLAYLIST vs, SD_MEDIENBIB" here
        //      ( or not?)
    end;
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
          begin
              // search again (to reselect nodes) ...
              if Length(Trim(EditPlaylistSearch.Text)) >= 2 then
                  NempPlaylist.Search(EditPlaylistSearch.Text, True);
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

  MedienBib.GetFilesInDir(aPfad, Sender=PM_ML_ExtendedShowAllFilesInDir);
end;

procedure TNemp_MainForm.NachDiesemDingSuchen1Click(Sender: TObject);
var aNode: pVirtualNode;
    Data: PTreeData;
    newComboBoxString: UnicodeString;
    KeyWords: TSearchKeyWords;
    SearchString: String;
begin
    if Medienbib.StatusBibUpdate >= 2 then exit;
    //Medienbib.BibSearcher.SearchOptions.SearchParam := 0;       // = New Search
    Medienbib.BibSearcher.SearchOptions.AllowErrors := False;  // no errors allowed
    KeyWords.General   := '';
    KeyWords.Artist    := '';
    KeyWords.Album     := '';
    KeyWords.Titel     := '';
    KeyWords.Pfad      := '';
    KeyWords.Kommentar := '';
    KeyWords.Lyric     := '';

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
              NempPlaylist.FileSearchCounter := 0;
              ProgressFormPlaylist.AutoClose := True;
              ProgressFormPlaylist.InitiateProcess(True, pa_SearchFilesForPlaylist);
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
var i, newCount: integer;
  AudioFile: TAudioFile;
  aErr: TNempAudioError;
  newFilenames: TStringList;
  lastFileName: String;
  nt, ct: Cardinal;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    ProgressFormLibrary.AutoClose := True;
    ProgressFormLibrary.InitiateProcess(True, pa_Default);

    MedienBib.ReInitCoverSearch;
    newCount := 0;
    MedienBib.StatusBibUpdate := 3;
    BlockGUI(3);
    KeepOnWithLibraryProcess := True; // ok, apm is used

    // Create a List of the playlist filenames first
    // Do not work in the long loop with the playlist itself, as the user may delete some files during the longer process
    newFilenames := TStringList.Create;
    try
        for i := 0 to NempPlaylist.Count - 1 do
            if (NempPlaylist.Playlist[i] as TAudioFile).IsFile then
                newFilenames.Add((NempPlaylist.Playlist[i] as TAudioFile).Pfad);

        // sort the list to avoid duplicates in the UpdateList
        newFilenames.Sort;

        lastFileName := '';
        ct := GetTickCount;
        for i := 0 to newFilenames.Count - 1 do
        begin
            if lastFileName <> newFilenames[i] then
            begin
                lastFileName := newFilenames[i];
                AudioFile := MedienBib.GetAudioFileWithFilename(newFilenames[i]);
                if (AudioFile = Nil) then
                begin
                    AudioFile := TAudioFile.Create;
                    aErr := AudioFile.GetAudioData(newFilenames[i], {GAD_Cover or} GAD_Rating or MedienBib.IgnoreLyricsFlag);
                    HandleError(afa_NewFile, AudioFile, aErr);
                    MedienBib.InitCover(AudioFile, tm_VCL);
                    MedienBib.UpdateList.Add(AudioFile);
                    inc(newCount);
                end;

                // process messages every now and then
                nt := GetTickCount;
                if (nt > ct + 250) or (nt < ct) then
                begin
                    ct := nt;
                    ProgressFormLibrary.lblSuccessCount.Caption := IntToStr(newCount);
                    ProgressFormLibrary.MainProgressBar.Position := Round(i/newFilenames.Count * 100);
                    ProgressFormLibrary.Update;
                    Application.ProcessMessages;
                    if not KeepOnWithLibraryProcess then break;
                end;
            end;
        end;
        ProgressFormLibrary.MainProgressBar.Position := 100;
        MedienBib.NewFilesUpdateBib;  // unblocking will be done from there

    finally
        newFilenames.Free;
    end;
    KeepOnWithLibraryProcess := False;
end;

procedure TNemp_MainForm.PlayListPOPUPPopup(Sender: TObject);
var aNodeFocussed, SomeFilesSelected: Boolean;
    LibraryIsIdle, LibraryNotBlockedByPartymode, PlaylistNotBlockedByPartymode: Boolean;
begin
    aNodeFocussed     := assigned(PlayListVST.FocusedNode);
    SomeFilesSelected := length(PlayListVST.GetSortedSelection(False)) > 0;

    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    LibraryNotBlockedByPartymode  := NOT NempSkin.NempPartyMode.DoBlockBibOperations;
    PlaylistNotBlockedByPartymode := NOT NempSkin.NempPartyMode.Active;  // we block all "mass actions" by default

    PM_PL_Properties.Enabled              := aNodeFocussed;
    PM_PL_PlayInHeadset.Enabled           := aNodeFocussed;
    PM_PL_ExtendedCopyToClipboard.Enabled := SomeFilesSelected;
    PM_PL_MagicCopyToClipboard   .Enabled := SomeFilesSelected;

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

    PM_PL_AddDirectories    .Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_AddWebstream      .Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_SortBy            .Enabled := PlaylistNotBlockedByPartymode AND (NempPlaylist.Count > 0);
    PM_PL_GeneraterandomPlaylist.Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_LoadPlaylist      .Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_SavePlaylist      .Enabled := (NempPlaylist.Count > 0);
    PM_PL_ClearPlaylist     .Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_RecentPlaylists   .Enabled := PlaylistNotBlockedByPartymode ;
    PM_PL_DeleteSelected    .Enabled := (SomeFilesSelected AND PlaylistNotBlockedByPartymode) OR // a little bit too much to deny deleting at all
                                                                         // -> allow deleting in small steps in partymode
                                        ((NOT PlaylistNotBlockedByPartymode) AND (length(PlayListVST.GetSortedSelection(False)) = 1));

    PM_PL_DeleteMissingFiles.Enabled := PlaylistNotBlockedByPartymode;
    PM_PL_SetRatingofSelectedFilesTo .Enabled := SomeFilesSelected AND LibraryNotBlockedByPartymode;
    PM_PL_MarkFiles.Enabled := SomeFilesSelected;

    ClipCursor(Nil);
    PM_PL_ExtendedPasteFromClipboard.Enabled := Clipboard.HasFormat(CF_HDROP);
    PM_PL_ExtendedAddToMedialibrary.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    PM_PL_ReplayGain.Enabled := SomeFilesSelected AND LibraryNotBlockedByPartymode and LibraryIsIdle
                                    AND (Not assigned(NempReplayGainCalculator));
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
      KeepOnWithLibraryProcess := False;  // CancelButton
      ContinueWithPlaylistAdding := False;
  end;

end;



procedure TNemp_MainForm.PM_ML_CloudEditorClick(Sender: TObject);
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    // switch to TagCloud
    if MedienBib.BrowseMode <> 2 then
        MedienBib.ReBuildTagCloud;
    //begin
    //    SwitchBrowsePanel(TabBtn_TagCloud.Tag);
    //    SwitchMediaLibrary(TabBtn_TagCloud.Tag);
    //end;
    // navigate to whole library
    //MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.ClearTag, True);
    //MedienBib.TagCloud.ShowTags(True);

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

  MedienBib.ReInitCoverSearch;

  if Sender = PM_PL_ExtendedPasteFromClipboard then
  begin
        JobList := NempPlaylist.ST_Ordnerlist;
        ST_PLaylist.Mask := GeneratePlaylistSTFilter;
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
                    end else
                    begin
                        if Not MedienBib.AudioFileExists(buffer) then
                        begin
                            AudioFile:=TAudioFile.Create;
                            aErr := AudioFile.GetAudioData(buffer, {GAD_Cover or} GAD_Rating or MedienBib.IgnoreLyricsFlag);
                            HandleError(afa_PasteFromClipboard, AudioFile, aErr);
                            MedienBib.InitCover(AudioFile, tm_VCL);
                            MedienBib.UpdateList.Add(AudioFile);
                        end;
                    end;
                end;
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
          NempPlaylist.FileSearchCounter := 0;
          ProgressFormPlaylist.AutoClose := True;
          ProgressFormPlaylist.InitiateProcess(True, pa_SearchFilesForPlaylist);
          ST_Playlist.SearchFiles(JobList[0]);
      end;
  end else
  begin
      if JobList.Count > 0 then
      begin
          PutDirListInAutoScanList(JobList);
          BlockGUI(1);
          StartMediaLibraryFileSearch;
      end
      else
          // Die Dateien einpflegen, die evtl. einzeln in die Updatelist geaten sind
          MedienBib.NewFilesUpdateBib;
  end;
end;


procedure TNemp_MainForm.PM_TNA_CloseClick(Sender: TObject);
begin
  close;
end;

procedure TNemp_MainForm.PM_TNA_RestoreClick(Sender: TObject);
begin
  RestoreNemp;
end;

procedure TNemp_MainForm.__PM_W_WebServerShowLogClick(Sender: TObject);
begin
    if not assigned(WebServerLogForm) then
        Application.CreateForm(TWebServerLogForm, WebServerLogForm);
    WebServerLogForm.Show;
end;


procedure TNemp_MainForm.PlaylistVSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var Data: PTreeData;
begin
    //exit;
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
                              {
                                  // don't show the music-note on ecery node any more
                                  // not the playing node
                                  case Data.FAudioFile.AudioType of
                                      at_Undef  : ImageIndex := 8;
                                      at_File   : ImageIndex := 0;
                                      at_Stream : ImageIndex := 9;
                                      at_CDDA   : ImageIndex := 10;
                                  end;
                                  ImageIndex := 16;    }

                              end;
                          end;
                      end;
                  end; // case Column 0
                  1: begin
                        if (Data.FAudioFile.AudioType = at_File)
                        AND NOT (
                              IsZero(Data.FAudioFile.TrackGain)
                              AND
                              IsZero(Data.FAudioFile.AlbumGain)
                            )
                        then ImageIndex := 16;

                  end;
            end;
        end;
      end;
  end;
end;

procedure TNemp_MainForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var Data: PTreeData;

begin
  case Kind of
    ikNormal, ikSelected:
      begin
          Data := Sender.GetNodeData(Node);

          if Data^.FAudioFile = MedienBib.BibSearcher.DummyAudioFile then
              imageIndex := -1
          else

              case VST.Header.Columns[column].Tag of
                  CON_LYRICSEXISTING :
                      if Data^.FAudioFile.LyricsExisting then imageIndex := 6
                      else imageIndex := 7;

                  CON_LASTFMTAGS :
                          if Length(Data^.FAudioFile.RawTagLastFM) > 0 then imageIndex := 11;
                      //else imageIndex := 15;
                      // Con_Titel: imageIndex := 10;

                  CON_Favorite: begin
                      imageIndex := 12 + ((Data^.FAudioFile.Favorite mod 4));
                  end;
              end;
      end;
  end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedScanFilesClick(Sender: TObject);
var Node: PVirtualNode;
begin
  /// note (2019)
  ///  This may lead to a looong operation, that can't be cancelled, as here is no
  ///  Application.ProcessMessages involved.
  ///  However, This method is probably very rarely used, and in most cases the
  ///  playlist contains <1000 files or so, which should be scanned quite fast.
  ClearCDDBCache;
  Node := PlaylistVST.GetFirst;
  while assigned(Node) {and LangeAktionWeitermachen} do
  begin
      NempPlaylist.ActualizeNode(Node, True);
      Node := PlaylistVST.GetNextSibling(Node);
  end;
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
  if not FormReadyAndActivated then
        exit;

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
    if not FormReadyAndActivated then
        exit;
    ArtistsVST.Header.Columns[0].Width := ArtistsVST.Width;
end;


procedure TNemp_MainForm.AlbenVSTResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if not assigned(NempFormBuildOptions) then
        exit;
    
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
        ShowVSTDetails(NempPlayer.MainAudioFile, SD_PLAYLIST);
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
    ExtendedControlForm.Resizing := False;
end;

procedure TNemp_MainForm.PaintFrameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin

      ClipCursor(Nil);



      if (Sender = NewPlayerPanel) and (not (ssLeft in Shift)) then
      begin
          if (X > SlidebarShape.Left - 10)
              and (Y > SlidebarShape.Top - 10)
              and (Y < SlidebarShape.Top + SlidebarShape.Height + 10)
          then
              ShowSlideBarButtonAtCorrectPosition
          else
              SlideBarButton.Visible := False;
      end;


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
      if Tag = 0 then
      begin
          NempFormBuildOptions.WindowSizeAndPositions.MainFormMaximized := WindowState=wsMaximized;
          // aktuelle Aufteilung speichern
          NempFormBuildOptions.WindowSizeAndPositions.MainFormTop   := Top ;
          NempFormBuildOptions.WindowSizeAndPositions.MainFormLeft  := Left;
      end;
      if Tag = 1 then
      begin
          NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormTop   := Top ;
          NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormLeft  := Left;
          // (maximized doesnt make sense in seperate-window-mode)
      end;
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
    if NempSkin.NempPartyMode.Active then
        exit;

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
var MessageString: String;
begin
    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusyOnPartyMode), mtWarning, [MBOK], 0);
        exit;
    end;

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
        MessageString := _(ParrtyMode_ActivationHint);
        if NempSkin.NempPartyMode.ShowPasswordOnActivate then
            MessageString := MessageString + #13#10#13#10
                      + Format(_(ParrtyMode_Password_PromptOnActivate), [NempSkin.NempPartyMode.Password]);

        if TranslateMessageDLG(MessageString, mtInformation, [mbOK, mbCancel], 0) = mrOK then
        begin
            if Anzeigemode = 1 then
            begin
                // Set Compact Mode
                // Party-mode in Separate-Window-Mode is not allowed.
                // Anzeigemode := 0;
                UpdateFormDesignNeu(0);
            end;

            NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active;
        end;
    end;
end;


procedure TNemp_MainForm.TabBtn_EqualizerClick(Sender: TObject);
begin
    if not assigned(FormEffectsAndEqualizer) then
        Application.CreateForm(TFormEffectsAndEqualizer, FormEffectsAndEqualizer);
    FormEffectsAndEqualizer.Show;
end;




procedure TNemp_MainForm.PlayerTabsClick(Sender: TObject);
begin
    Case (Sender as TControl).Tag of
        1: begin
            TabBtn_Cover.GlyphLine  := 1;
            TabBtn_Lyrics.GlyphLine := 0;
            LyricsMemo.Visible     := False;
            ImgDetailCover.Visible := True;
        end;
        2: begin
            TabBtn_Cover.GlyphLine  := 0;
            TabBtn_Lyrics.GlyphLine := 1;
            LyricsMemo.Visible := True;
            ImgDetailCover.Visible := False;
        end;
    end;
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
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

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
    FormReadyAndActivated := True;
end;

procedure TNemp_MainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var c: Integer;
begin
  CanClose := (MedienBib.StatusBibUpdate = 0) AND (NempPlaylist.Status = 0) AND (not MM_Warning_ID3Tags.Visible);
  if not CanClose then
  begin
      if (MedienBib.StatusBibUpdate > 0) then
      begin
          // medienbib is busy
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
                  KeepOnWithLibraryProcess := False;
              end;
          end;
      end else
          if MM_Warning_ID3Tags.Visible then
          begin
              c := MedienBib.CountInconsistentFiles;
              if c > 0 then
                  CanClose := TranslateMessageDLG((MediaLibrary_InconsistentFilesWarning), mtWarning, [MBYes, MBNo], 0) = mrYes
              else
                  CanClose := True;
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


function TNemp_MainForm.ArtistDragContainsFiles: Boolean;
var SDataArtist: PStringTreeData;
    ArtistNode: PVirtualNode;
begin
    ArtistNode := ArtistsVST.FocusedNode;
    if assigned(ArtistNode) then
    begin
        SDataArtist := ArtistsVST.GetNodeData(ArtistNode);
        result := (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_PLAYLISTS)
             AND (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_RADIOSTATIONS);
    end else
        // no artist selected, no files to drag
        result := False
end;


function TNemp_MainForm.ArtistAlbumDragContainsFiles: Boolean;
var SDataArtist: PStringTreeData;
    ArtistNode, AlbumNode: PVirtualNode;
begin
    ArtistNode := ArtistsVST.FocusedNode;
    if assigned(ArtistNode) then
    begin
        SDataArtist := ArtistsVST.GetNodeData(ArtistNode);
        if (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_PLAYLISTS)
             AND (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_RADIOSTATIONS)
        then
            // Artist is not All-Webradio or Playlists -> there are files to drag
            result := True
        else
        begin
            // we need to check for a focused album node
            AlbumNode  := AlbenVST.FocusedNode;
            // Dragging files does make sense, if an "album" is selected,
            // provided that it is not a webradio station (regular playlist files are ok!)
            result := assigned(AlbumNode) and (TJustAstring(SDataArtist^.FString).DataString <> BROWSE_RADIOSTATIONS);
        end;
    end else
        // no artist selected, no files to drag
        result := False
end;


procedure TNemp_MainForm.ArtistsVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i, maxC: integer;
  DateiListe: TObjectlist;
begin
  if not ArtistDragContainsFiles then
      exit;

  Dateiliste := TObjectlist.Create(False);
  try
      GenerateListForHandleFiles(DateiListe, 0, True);     // was: 1
      DragSource := DS_VST;
      with DragFilesSrc1 do
      begin
          // Add files selected to DragFilesSrc1 list
          ClearFiles;
          DragDropList.Clear;

          maxC := min(NempOptions.maxDragFileCount, DateiListe.Count);
          if DateiListe.Count > NempOptions.maxDragFileCount then
              AddErrorLog(Format(Warning_TooManyFiles, [NempOptions.maxDragFileCount]));

          for i := 0 to maxC - 1 do
          begin
              AddFile((Dateiliste[i] as TAudiofile).Pfad);
              DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad);
          end;

          // This is the START of the drag (FROM) operation.
          Execute;
      end;

  finally
      FreeAndNil(Dateiliste);
  end;
end;

procedure TNemp_MainForm.AlbenVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var i, maxC: Integer;
    DateiListe: TObjectlist;
begin
    if not ArtistAlbumDragContainsFiles then
      exit;

    Dateiliste := TObjectlist.Create(False);
    try
        GenerateListForHandleFiles(Dateiliste, 100, true);  // was: 2
        DragSource := DS_VST;
        with DragFilesSrc1 do
        begin
            // Add files selected to DragFilesSrc1 list
            ClearFiles;
            DragDropList.Clear;

            maxC := min(NempOptions.maxDragFileCount, DateiListe.Count);
            if DateiListe.Count > NempOptions.maxDragFileCount then
                AddErrorLog(Format(Warning_TooManyFiles, [NempOptions.maxDragFileCount]));

            for i := 0 to maxC - 1 do
            begin
                AddFile((Dateiliste[i] as TAudiofile).Pfad);
                DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad)
            end;
            // This is the START of the drag (FROM) operation.
            Execute;
        end;

        // DeleteAudioFilesAfterHandled was set to TRUE in GenerateListForHandleFiles,
        // if a Playlist has been dragged. IN that case, new Audiofiles have been created,
        // which schould be freed again.
        if DeleteAudioFilesAfterHandled then
        begin
            for i := 0 to DateiListe.Count - 1 do
                (Dateiliste[i] as TAudioFile).Free;
        end;


    finally
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
    if AnzeigeMode = 1 then
        SetRegion(__MainContainerPanel , self, NempRegionsDistance, handle);
end;


procedure TNemp_MainForm.MM_ML_WebradioClick(Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if not assigned(FormStreamVerwaltung) then
    Application.CreateForm(TFormStreamVerwaltung, FormStreamVerwaltung);
  FormStreamVerwaltung.show;
end;

procedure TNemp_MainForm.QuickSearchHistory_PopupMenuPopup(Sender: TObject);

    procedure FillString(aItem: TMenuItem; aIndex: Integer);
    begin
        if MedienBib.BibSearcher.QuickSearchHistory.Count > aIndex then
        begin
            aItem.Caption := MedienBib.BibSearcher.QuickSearchHistory[aIndex];
            aItem.Visible := True;
        end else
            aItem.Visible := False;
    end;

begin
    if MedienBib.BibSearcher.QuickSearchHistory.Count = 0 then
        pmRecentSearches.Caption := _(MainForm_NoRecentQuickSearchresults)
    else
        pmRecentSearches.Caption := _(MainForm_RecentQuickSearchresults);
    FillString(pmQuickSeachHistory0, 0);
    FillString(pmQuickSeachHistory1, 1);
    FillString(pmQuickSeachHistory2, 2);
    FillString(pmQuickSeachHistory3, 3);
    FillString(pmQuickSeachHistory4, 4);
    FillString(pmQuickSeachHistory5, 5);
    FillString(pmQuickSeachHistory6, 6);
    FillString(pmQuickSeachHistory7, 7);
    FillString(pmQuickSeachHistory8, 8);
    FillString(pmQuickSeachHistory9, 9);
end;

procedure TNemp_MainForm.pmQuickSeachHistoryClick(Sender: TObject);
begin
    MedienBib.BibSearcher.MoveQuickSearchQueryToHistory((Sender as TMenuItem).Tag);

    EditFastSearch.OnChange := Nil;
    EditFastSearch.Text := MedienBib.BibSearcher.MostrecentQuickSearch;
    EditFastSearch.OnChange := EDITFastSearchChange;

    RefreshCoverFlowTimer.Enabled := False;
    DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType);
    if (MedienBib.AnzeigeListe.Count) > 1 then
    begin
        // Restart Timer
        if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
            AND (MedienBib.BrowseMode = 1)
        then
            RefreshCoverFlowTimer.Enabled := True;
    end;

end;

procedure TNemp_MainForm.EDITFastSearchEnter(Sender: TObject);
begin
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

  if (EditFastSearch.Text <> '')
       AND (MedienBib.DisplayContent <> DISPLAY_QuickSearch)
  then
  begin
      //restore last quicksearch
      RefreshCoverFlowTimer.Enabled := False;
      DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter);
      // Restart Timer
      if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
          AND (MedienBib.BrowseMode = 1)
      then
          RefreshCoverFlowTimer.Enabled := True;

  end;
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
  end else
  begin
      if EditFastSearch.Tag <> 0 then
          MedienBib.BibSearcher.AddQuickSearchQueryToHistory(EditFastSearch.Text);
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
      VK_F3: begin
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

        VK_ESCAPE: begin
              key := #0;
              EditPlaylistSearch.Text := '';
              NempPlaylist.ClearSearch(True);
        end
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


procedure TNemp_MainForm.EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
begin
  case ord(key) of
      VK_RETURN:
          begin
            key := #0;
            if Trim(EDITFastSearch.Text)= '' then
            begin
                //MedienBib.ShowQuickSearchList;
                MedienBib.RestoreAnzeigeListeAfterQuicksearch;
                RestoreCoverFlowAfterSearch;
            end
            else
            begin
                MedienBib.BibSearcher.AddQuickSearchQueryToHistory(EditFastSearch.Text);
                RefreshCoverFlowTimer.Enabled := False;
                if Trim(EDITFastSearch.Text) = '*' then
                    MedienBib.QuickSearchShowAllFiles
                else
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
              MedienBib.BibSearcher.AddQuickSearchQueryToHistory(EditFastSearch.Text);
              EDITFastSearch.Text := '';
              //MedienBib.ShowQuickSearchList;
              MedienBib.RestoreAnzeigeListeAfterQuicksearch;
              RestoreCoverFlowAfterSearch;
          end
  end;
end;

procedure TNemp_MainForm.TabBtn_MarkerKeyPress(Sender: TObject;
  var Key: Char);
begin
    case ord(key) of
        VK_ESCAPE: begin
            key := #0;
            //MedienBib.ShowQuickSearchList;
        end;
    end;
end;


procedure TNemp_MainForm.EDITFastSearchChange(Sender: TObject);
begin
  If MedienBib.BibSearcher.QuickSearchOptions.WhileYouType then
  begin
      if Trim(EDITFastSearch.Text)= '' then
      begin
          MedienBib.RestoreAnzeigeListeAfterQuicksearch;
          RestoreCoverFlowAfterSearch;
      end
      else
          if Length(Trim(EDITFastSearch.Text)) >= 2 then
          begin
              RefreshCoverFlowTimer.Enabled := False;
              DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType);
              if (MedienBib.AnzeigeListe.Count) > 1 then
              begin
                  // Restart Timer
                  if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
                      AND (MedienBib.BrowseMode = 1)
                  then
                      RefreshCoverFlowTimer.Enabled := True;
              end;
          end
          else
              if Trim(EDITFastSearch.Text) = '*' then
                  MedienBib.QuickSearchShowAllFiles
              else
                  FillTreeViewQueryTooShort;
  end;
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

  case MedienBib.BrowseMode of
      0: begin
            // classic browse mode
            case (Sender as TMenuItem).Tag of
                0:  begin
                        MedienBib.NempSortArray[1] := siArtist;
                        MedienBib.NempSortArray[2] := siAlbum;
                    end;
                1:  begin
                        MedienBib.NempSortArray[1] := siOrdner;
                        MedienBib.NempSortArray[2] := siArtist;
                    end;
                2:  begin
                        MedienBib.NempSortArray[1] := siOrdner;
                        MedienBib.NempSortArray[2] := siAlbum;
                    end;
                3:  begin
                        MedienBib.NempSortArray[1] := siGenre;
                        MedienBib.NempSortArray[2] := siArtist;
                    end;
                4:  begin
                        MedienBib.NempSortArray[1] := siGenre;
                        MedienBib.NempSortArray[2] := siJahr;
                    end;
                6:  begin
                        MedienBib.NempSortArray[1] := siAlbum;
                        MedienBib.NempSortArray[2] := siArtist;
                    end;
                7:  begin
                        MedienBib.NempSortArray[1] := siJahr;
                        MedienBib.NempSortArray[2] := siArtist;
                    end;
                8: begin
                        MedienBib.NempSortArray[1] := siFileAge;
                        MedienBib.NempSortArray[2] := siAlbum;
                    end;
                9:  begin
                        MedienBib.NempSortArray[1] := siFileAge;
                        MedienBib.NempSortArray[2] := siArtist;
                    end;
          end;
      end;
      1: begin
          // Coverflow
            case (Sender as TMenuItem).Tag of
                0: MedienBib.CoverSortOrder := 1;
                1: MedienBib.CoverSortOrder := 6;
                2: MedienBib.CoverSortOrder := 7;
                3: MedienBib.CoverSortOrder := 3;
                4: MedienBib.CoverSortOrder := 5;
                6: MedienBib.CoverSortOrder := 2;
                7: MedienBib.CoverSortOrder := 4;
                8: MedienBib.CoverSortOrder := 8;
                9: MedienBib.CoverSortOrder := 9;
            end;
      end
      else
      begin
          // Tagcloud. Do nothing.
          // menu item is disabled anyway
      end;
  end;

  case (Sender as TMenuItem).Tag of
      0..4, 6..9 : SwitchMediaLibrary(MedienBib.BrowseMode);
      //5 : SwitchMediaLibrary(1);     // CoverFlow
  end;
end;




procedure TNemp_MainForm.PM_ML_BrowseByMoreClick(Sender: TObject);
begin
    if Not Assigned(OptionsCompleteForm) then
        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);

    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.VorauswahlNode;
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabView0;
    OptionsCompleteForm.Show;
end;

procedure TNemp_MainForm.AuswahlPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PerForm(WM_SysCommand, $F012 , 0);
end;

procedure TNemp_MainForm.AuswahlPanelResize(Sender: TObject);
var ExtraSpace: Integer;
begin
    ExtraSpace := 16 * AnzeigeMode;
    AuswahlFillPanel.Left := TabBtn_TagCloud.Left + TabBtn_TagCloud.Width + 6;
    AuswahlFillPanel.Width := AuswahlPanel.Width - AuswahlFillPanel.Left - ExtraSpace;

    AuswahlStatusLBL.Width := AuswahlFillPanel.Width - 16;
end;


procedure TNemp_MainForm.TntFormDestroy(Sender: TObject);
begin
    {$IFDEF USESTYLES}
    FreeAllControlStyleHooks;
    {$ENDIF}
    try
        NempFormBuildOptions.Free;
        TagLabelList.Free;
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

procedure TNemp_MainForm.HandleInsertHeadsetToPlaylist(aAction: Integer);
var newPlaylistFile: TAudioFile;
begin
    if assigned(NempPlayer.HeadSetAudioFile) then
    begin
        case aAction of
            0: begin
                // enqueue (at the end)
                NempPlaylist.InsertNode := NIL;
                newPlaylistFile := TAudioFile.Create;
                newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
                NempPlaylist.InsertFileToPlayList(newPlaylistFile);
            end;
            1: begin
                // play (and clear current list)
                if (NempPlaylist.Count > 20) then
                begin
                    if TranslateMessageDLG(Format((Playlist_QueryReallyDelete), [NempPlaylist.Count, 1]), mtWarning, [mbYes, mbNo], 0) = mrYes then
                        // yes, user really wants tor delete the Playlist
                        NempPlayList.ClearPlaylist;
                end else
                    // just clear it without asking
                    NempPlayList.ClearPlaylist;

                // add the Headset-Track into the playlist
                NempPlaylist.InsertNode := NIL;
                newPlaylistFile := TAudioFile.Create;
                newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
                NempPlaylist.InsertFileToPlayList(newPlaylistFile);
            end;
            2: begin
                // enqueue after the current track
                NempPlaylist.GetInsertNodeFromPlayPosition;
                newPlaylistFile := TAudioFile.Create;
                newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
                NempPlaylist.InsertFileToPlayList(newPlaylistFile);
            end;
            3: begin
                  // just play
                  //if FileExists(NempPlayer.HeadSetAudioFile.Pfad) then
                      NempPlaylist.PlayBibFile(NempPlayer.HeadSetAudioFile, NempPlayer.FadingInterval);
            end;
        end;
    end;

    if NempPlaylist.AutoStopHeadsetAddToPlayist then
        NempPlayer.PauseHeadset;
end;

procedure TNemp_MainForm.InsertHeadsetToPlaylistClick(
  Sender: TObject);
begin
    HandleInsertHeadsetToPlaylist((Sender as TMenuItem).Tag);
end;

procedure TNemp_MainForm.BtnHeadsetToPlaylistClick(Sender: TObject);
begin
    HandleInsertHeadsetToPlaylist(NempPlaylist.HeadSetAction);
end;

procedure TNemp_MainForm.BtnHeadsetPlaynowClick(Sender: TObject);
var newPlaylistFile: TAudioFile;
begin
    if assigned(NempPlayer.HeadSetAudioFile) then
    begin
        newPlaylistFile := TAudioFile.Create;
        newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
        NempPlaylist.PlayHeadsetFile(newPlaylistFile, NempPlayer.FadingInterval, NempPlayer.HeadsetTime);
    end;
end;


procedure TNemp_MainForm.__BtnMinimizeClick(Sender: TObject);
begin
  Application.minimize;
end;



procedure TNemp_MainForm.PM_P_ViewCompactClick(Sender: TObject);
begin
  MM_O_ViewCompactCompleteClick(PM_P_ViewCompactComplete);
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_PlaylistClick(Sender: TObject);
begin
  NempFormBuildOptions.WindowSizeAndPositions.PlaylistVisible := NOT NempFormBuildOptions.WindowSizeAndPositions.PlaylistVisible;
  PM_P_ViewSeparateWindows_Playlist.Checked := NempFormBuildOptions.WindowSizeAndPositions.PlaylistVisible;
  MM_O_ViewSeparateWindows_Playlist.Checked := NempFormBuildOptions.WindowSizeAndPositions.PlaylistVisible;

  PlaylistForm.Visible := NempFormBuildOptions.WindowSizeAndPositions.PlaylistVisible;
  if PlaylistForm.Visible then
  begin
      FormPosAndSizeCorrect(PlaylistForm);
      PlaylistForm.FormResize(Nil);
  end;
  ReInitDocks;
end;


procedure TNemp_MainForm.PM_P_ViewSeparateWindows_MedialistClick(Sender: TObject);
begin
  NempFormBuildOptions.WindowSizeAndPositions.MedienlisteVisible := NOT NempFormBuildOptions.WindowSizeAndPositions.MedienlisteVisible;
  PM_P_ViewSeparateWindows_Medialist.Checked := NempFormBuildOptions.WindowSizeAndPositions.MedienlisteVisible;
  MM_O_ViewSeparateWindows_Medialist.Checked := NempFormBuildOptions.WindowSizeAndPositions.MedienlisteVisible;

  MedienListeForm.Visible := NempFormBuildOptions.WindowSizeAndPositions.MedienListeVisible;
  if MedienListeForm.Visible then
  begin
      FormPosAndSizeCorrect(MedienListeForm);
      MedienListeForm.FormResize(Nil);
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_BrowseClick(
  Sender: TObject);
var reactivate: Boolean;
begin
  NempFormBuildOptions.WindowSizeAndPositions.AuswahlSucheVisible := NOT NempFormBuildOptions.WindowSizeAndPositions.AuswahlSucheVisible;
  PM_P_ViewSeparateWindows_Browse.Checked := NempFormBuildOptions.WindowSizeAndPositions.AuswahlSucheVisible;
  MM_O_ViewSeparateWindows_Browse.Checked := NempFormBuildOptions.WindowSizeAndPositions.AuswahlSucheVisible;


                      {$IFDEF USESTYLES}
                      reactivate := False;
                      if  (GlobalUseAdvancedSkin) AND
                          (UseSkin AND NempSkin.UseAdvancedSkin)
                      then
                      begin
                          // deactivate advanced skin temporary
                      //    TStyleManager.SetStyle('Windows');    //???
                      //    reactivate := True;                   //???
 /// ok, (2018). Why deactivate the skin here temporarily? Coverflow-Stuff? OlderStill needed in Tokyo?

                      end;
                      {$ENDIF}

  AuswahlForm.Visible := NempFormBuildOptions.WindowSizeAndPositions.AuswahlSucheVisible;


                      {$IFDEF USESTYLES}
                      if reactivate then
                      begin
                          TStylemanager.SetStyle(NempSkin.AdvancedStyleName);
                          CorrectSkinRegionsTimer.Enabled := True;
                          //CorrectSkinRegions;
                      end;
                      {$ENDIF}

  if AuswahlForm.Visible then
  begin
      FormPosAndSizeCorrect(AuswahlForm);
      AuswahlForm.FormResize(Nil);
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.PM_P_ViewSeparateWindows_EqualizerClick(
  Sender: TObject);
begin
  NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible := NOT NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
  PM_P_ViewSeparateWindows_Equalizer.Checked := NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
  MM_O_ViewSeparateWindows_Equalizer.Checked := NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;


  ExtendedControlForm.Visible := NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
  if ExtendedControlForm.Visible then
  begin
      FormPosAndSizeCorrect(ExtendedControlForm);
      ExtendedControlForm.FormResize(Nil);
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.BtnMenuClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Player_PopupMenu.Popup(Point.X, Point.Y+10);
end;

procedure TNemp_MainForm.BtnMinimizeClick(Sender: TObject);
begin
    Application.Minimize;
end;

procedure TNemp_MainForm._ControlPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);

    playerArtistLabel.Caption := Inttostr(random(4999));
end;

procedure TNemp_MainForm._ControlPanelResize(Sender: TObject);
var WidthLimit: Integer;
begin
    if not FormReadyAndActivated then
        exit;

    if not assigned(NempFormBuildOptions) then
        exit;

    if NempFormBuildOptions.ControlPanelTwoRows then
        WidthLimit := 305
    else
        WidthLimit := 400;

    //if not NempFormBuildOptions.ControlPanelTwoRows then
    begin
        PlayerControlCoverPanel.Visible := (_ControlPanel.Width > WidthLimit) and NempFormBuildOptions.ControlPanelShowCover;
        if PlayerControlCoverPanel.Visible then
            ControlContainer1.Width := OutputControlPanel.Width
                               + PlayerControlCoverPanel.Width
                               + PlayerControlPanel.Width
        else
            ControlContainer1.Width := OutputControlPanel.Width
                               + PlayerControlPanel.Width
    end;
end;

procedure TNemp_MainForm.NewPlayerPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    PaintFrame.Visible := NewPlayerPanel.Width > 170;

    if assigned(NempPlayer) and NempPlayer.ABRepeatActive then
        RepositionABRepeatButtons;
end;


procedure TNemp_MainForm._TopMainPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(NempFormBuildOptions) then
        NempFormBuildOptions.OnMainContainerResize(Sender);
end;

procedure TNemp_MainForm.__MainContainerPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(NempFormBuildOptions) then
        NempFormBuildOptions.OnSuperContainerResize(Sender);
end;


procedure TNemp_MainForm.Nichtvorhandenelschen1Click(Sender: TObject);
begin
  NempPlaylist.DeleteDeadFiles;
end;

procedure TNemp_MainForm.TabPanelMedienlisteClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Medialist_View_PopupMenu.Popup(Point.X, Point.Y+10);
end;

Function TNemp_MainForm.GenerateSleepHint: String;
var c: Integer;
begin
  if NempOptions.ShutDownAtEndOfPlaylist then
  begin
      result := #13#10#13#10 + NempShutDown_AtEndOfPlaylist_Hint;
      Case NempOptions.ShutDownMode of
            SHUTDOWNMODE_StopNemp  : result := NempShutDown_StopHint_AtEndOfPlaylist     + result;
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

function TNemp_MainForm.GetShutDownInfoCaption: String;
var c: Integer;
begin
    // default: not active
    result := NempShutDown_PopupNotActive;

    if SleepTimer.Enabled then
    begin
        c := SecondsBetween(Now, NempOptions.ShutDownTime);
        case NempOptions.ShutDownMode of
          SHUTDOWNMODE_StopNemp  : result := Format((NempShutDown_StopPopupTime),  [SekToZeitString(c, True)] );
          SHUTDOWNMODE_ExitNemp  : result := Format((NempShutDown_ClosePopupTime),  [SekToZeitString(c, True)] );
          SHUTDOWNMODE_Suspend   : result := Format((NempShutDown_SuspendPopupTime),  [SekToZeitString(c, True)] );
          SHUTDOWNMODE_Hibernate : result := Format((NempShutDown_HibernatePopupTime),  [SekToZeitString(c, True)] );
          SHUTDOWNMODE_Shutdown  : result := Format((NempShutDown_ShutDownPopupTime),  [SekToZeitString(c, True)] );
        end;
    end else
    begin
        if NempOptions.ShutDownAtEndOfPlaylist then
        begin
            case NempOptions.ShutDownMode of
                SHUTDOWNMODE_ExitNemp  : result := NempShutDown_ClosePopupTime_AtEndOfPlaylist;
                SHUTDOWNMODE_Suspend   : result := NempShutDown_SuspendPopupTime_AtEndOfPlaylist;
                SHUTDOWNMODE_Hibernate : result := NempShutDown_HibernatePopupTime_AtEndOfPlaylist;
                SHUTDOWNMODE_Shutdown  : result := NempShutDown_ShutDownPopupTime_AtEndOfPlaylist;
            end;
        end;
    end;
end;

procedure TNemp_MainForm.Player_PopupMenuPopup(Sender: TObject);
var PartyModeNotActive, ToolsNotBlockedBypartymode: Boolean;
    CaptionString: String;
begin
    // enable/disable several items regarding PartyMode
    PartyModeNotActive         := NOT NempSkin.NempPartyMode.Active;
    ToolsNotBlockedBypartymode := NOT NempSkin.NempPartyMode.DoBlockTools;
    // Block Always
    PM_P_Preferences                       .Enabled := PartyModeNotActive;
    PM_P_Wizard                            .Enabled := PartyModeNotActive;
    PM_P_View                              .Enabled := PartyModeNotActive;
        {PM_P_ViewCompactComplete           .Enabled := PartyModeNotActive;
        PM_P_ViewSeparateWindows_Equalizer .Enabled := PartyModeNotActive;
        PM_P_ViewSeparateWindows_Playlist  .Enabled := PartyModeNotActive;
        PM_P_ViewSeparateWindows_Medialist .Enabled := PartyModeNotActive;
        PM_P_ViewSeparateWindows_Browse    .Enabled := PartyModeNotActive;
        PM_P_ViewStayOnTop                 .Enabled := PartyModeNotActive;
    PM_P_CheckForUpdates                   .Enabled := PartyModeNotActive; }
    // Block, iff Blocking Tools is wanted
    PM_P_ShutDown        .Enabled := ToolsNotBlockedBypartymode;
    PM_P_Birthday        .Enabled := ToolsNotBlockedBypartymode;
    PM_P_RemoteNemp      .Enabled := ToolsNotBlockedBypartymode;
    PM_P_Scrobbler       .Enabled := ToolsNotBlockedBypartymode;
    PM_P_KeyboardDisplay .Enabled := ToolsNotBlockedBypartymode;
    PM_P_Directories     .Enabled := ToolsNotBlockedBypartymode;
    // also: Enable/Disable section "Tools" in MainMenu here
    MM_T_Shutdown        .Enabled := ToolsNotBlockedBypartymode;
    MM_T_Birthday        .Enabled := ToolsNotBlockedBypartymode;
    MM_T_RemoteNemp      .Enabled := ToolsNotBlockedBypartymode;
    MM_T_Scrobbler       .Enabled := ToolsNotBlockedBypartymode;
    MM_T_KeyboardDisplay .Enabled := ToolsNotBlockedBypartymode;
    MM_T_Directories     .Enabled := ToolsNotBlockedBypartymode;

    CaptionString := GetShutDownInfoCaption;
    PM_T_ShutdownInfo.Caption := CaptionString;
    MM_T_ShutdownInfo.Caption := CaptionString;
    PM_P_ShutdownInfo.Caption := CaptionString;

    PM_P_FormBuilder.Enabled := Nemp_MainForm.AnzeigeMode = 0;
end;


procedure TNemp_MainForm.ActivateShutDownMode(Sender: TObject);
var c: Integer;
begin
    // activate ShutDown after Settings-Dialog
    if not assigned(ShutDownEditForm) then
        Application.CreateForm(TShutDownEditForm, ShutDownEditForm);

    if ShutDownEditForm.ShowModal = mrOk then
    begin
        if NempOptions.ShutDownAtEndOfPlaylist then
        begin
            SleepTimer.Enabled := False;
            // !
            NempPlaylist.WiedergabeMode := NEMP_API_NOREPEAT; //(NempPlaylist.WiedergabeMode + 1) Mod 4;
            SetRepeatBtnGraphics;
        end else
        begin
            c := SecondsBetween(Now, NempOptions.ShutDownTime);
            if c <= 120 then
                SleepTimer.Interval := 250    // 0.25sek
            else
                SleepTimer.Interval := 10000; // 10sek

            SleepTimer.Enabled := True;
        end;

        SleepImage.Hint := GenerateSleepHint;
        ReArrangeToolImages;
    end;
end;

procedure TNemp_MainForm.InitShutDown;
begin
    // ResetShutDownCaptions;
    NempOptions.ShutDownAtEndOfPlaylist := False;
    SleepTimer.Enabled := False;
    ReArrangeToolImages;

    // Laufende Aktionen Beenden
    MedienBib.Abort;
    ST_Playlist.Break;
    ST_Medienliste.Break;
    KeepOnWithLibraryProcess := False;

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
    if SleepTimer.Enabled or NempOptions.ShutDownAtEndOfPlaylist then
    begin
        // Disable ShutDown
        SleepTimer.Enabled := False;
        NempOptions.ShutDownAtEndOfPlaylist := False;

        ReArrangeToolImages;
    end else
    begin
        ActivateShutDownMode(Sender);
    end;

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

procedure TNemp_MainForm.STFinish(var Msg: TMessage);
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
                // Changed for Nemp 4.13 to "> 0": Block whenever the library is working! or not ???
                //
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
                            allowed := True; // always allow edit of ratings
                            //allowed := NempOptions.AllowQuickAccessToMetadata;
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
        end
    else
        begin
            EditLink := TStringEditLink.Create;
        end;
    end;
end;

procedure TNemp_MainForm.VSTEditCancelled(Sender: TBaseVirtualTree;
  Column: TColumnIndex);
begin
    // PM_ML_HideSelected.ShortCut := 46;  // 46=Entf;
    SetShortCuts;
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
  newRating: Byte;
begin
    if (NempSkin.NempPartyMode.DoBlockTreeEdit)
        // or (not NempOptions.AllowQuickAccessToMetadata)
    then
        exit;

    //PM_ML_HideSelected.ShortCut := 46;    // 46=Entf;
    SetShortCuts;
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
        if (VST.Header.Columns[column].Tag = CON_RATING) then
        begin
            // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
            // for string-properties "GetAudioData" was called in VSTNewText to sync the library with the file
            newRating := af.Rating;
            af.GetAudioData(af.Pfad);
            af.Rating := newRating;

            aErr := af.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);
        end else
        begin
            aErr := af.WriteStringToMetaData(NewStringFromVSTEdit, VST.Header.Columns[column].Tag, NempOptions.AllowQuickAccessToMetadata )

        end;
        // aErr := af.SetAudioData(NempOptions.AllowQuickAccessToMetadata);

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
                ///SynchronizeAudioFile(af, af.Pfad, True);
                SynchAFileWithDisc(af, True);
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
                // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                af.GetAudioData(af.Pfad); // not needed any more .... ?

                NewStringFromVSTEdit := NewText;

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


procedure TNemp_MainForm.PanelCoverBrowsePaint(Sender: TObject);
begin
    NempSkin.DrawARegularPanel((Sender as TNempPanel), NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
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

        PlaylistPanel.Repaint;
        AuswahlPanel.Repaint;

        {
        if MedienBib.BrowseMode = 2 then
        begin
            PanelTagCloudBrowse.Repaint;
            MedienBib.TagCloud.  ShowTags(False);
        end;
        }

        _VSTPanel.Repaint;
        MedienlisteFillPanel.Repaint;
        GRPBOXVST.Repaint;
        DetailID3TagPanel.Repaint;

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
      NewPlayerPanel.Repaint;
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
        Spectrum.DrawClear;
end;


procedure TNemp_MainForm.TABPanelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
  aPanel := (Sender as TNempPanel);

  if aPanel.Tag <= 3 then
      NempSkin.DrawARegularPanel(aPanel, NempSkin.UseBackgroundImages[aPanel.Tag])
  else
      NempSkin.DrawARegularPanel(aPanel, True);

  aPanel.Canvas.Brush.Style := bsclear;
  aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
  begin
    aPanel.Canvas.Pen.Width := 1;
    aPanel.Canvas.Pen.Style := psSolid;
    aPanel.Canvas.RoundRect(0,0, aPanel.Width, aPanel.Height, 6, 6);
  //  Polyline([Point(1,1), Point(1,aPanel.Height-2), Point(aPanel.Width - 2, aPanel.Height - 2), Point(aPanel.Width - 2,1), Point(1,1)]);
  end;
end;

procedure TNemp_MainForm.PanelPaint(Sender: TObject);
begin
    if (Sender as TNempPanel).Tag <= 3 then
        NempSkin.DrawARegularPanel((Sender as TNempPanel), NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag])
    else
        NempSkin.DrawARegularPanel((Sender as TNempPanel), True);
end;

procedure TNemp_MainForm.GRPBOXArtistsAlbenPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
    aPanel := (Sender as TNempPanel);

    // Special case Artist/Album: Paint Browse-Bitmap (if set)
    NempSkin.DrawArtistAlbumPanel((Sender as TNempPanel), MedienBib.Count, NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);

    aPanel.Canvas.Brush.Style := bsclear;
    aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
    aPanel.Canvas.Pen.Width := 1;
    aPanel.Canvas.Pen.Style := psSolid;
    aPanel.Canvas.RoundRect(0,0, aPanel.Width-0, aPanel.Height-0, 6, 6);
end;


procedure TNemp_MainForm.NewPanelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
  aPanel := (Sender as TNempPanel);

  if aPanel.Tag <= 3 then
      NempSkin.DrawARegularPanel(aPanel, NempSkin.UseBackgroundImages[aPanel.Tag])
  else
      NempSkin.DrawARegularPanel(aPanel, true);

  aPanel.Canvas.Brush.Style := bsclear;
  aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
  aPanel.Canvas.Pen.Width := 1;
  aPanel.Canvas.Pen.Style := psSolid;
  aPanel.Canvas.RoundRect(0,0, aPanel.Width-0, aPanel.Height-0, 6, 6);
end;

// Special case: the CoverFlow-Label-Panel
// nEver use background here
procedure TNemp_MainForm.Pnl_CoverFlowLabelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
    aPanel := (Sender as TNempPanel);

    NempSkin.DrawARegularPanel(aPanel, false);

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



procedure TNemp_MainForm.ControlPanelPaint(Sender: TObject);
var aPanel: TNempPanel;
begin
    aPanel := (Sender as TNempPanel);

    NempSkin.DrawAControlPanel(aPanel, True, False);

    aPanel.Canvas.Brush.Style := bsclear;
    aPanel.Canvas.Pen.Color := Nempskin.SkinColorScheme.GroupboxFrameCL;  //TabTextCL;
    aPanel.Canvas.Pen.Width := 1;
    aPanel.Canvas.Pen.Style := psSolid;
    aPanel.Canvas.RoundRect(0,0, aPanel.Width-0, aPanel.Height-0, 6, 6);
end;


procedure TNemp_MainForm.PlayerControlPanelMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.Volume := NempPlayer.Volume - 1;
    CorrectVolButton;
end;

procedure TNemp_MainForm.PlayerControlPanelMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.Volume := NempPlayer.Volume + 1;
    CorrectVolButton;
end;



procedure TNemp_MainForm.HeadsetControlPanelMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume - 1;
    CorrectVolButton;
end;

procedure TNemp_MainForm.HeadsetControlPanelMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    NempPlayer.HeadsetVolume := NempPlayer.HeadsetVolume + 1;
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
    NempPlayer.PauseForBirthday;
    if Not Assigned(BirthdayForm) then
        Application.CreateForm(TBirthdayForm, BirthdayForm);
    BirthdayForm.Show;
    BirthdayTimer.Enabled := False;
    ReArrangeToolImages;
  end;
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
        // Calculate the CountDownTime
        if NempPlayer.NempBirthdayTimer.UseCountDown then
            NempPlayer.NempBirthdayTimer.StartCountDownTime :=
              IncSecond(NempPlayer.NempBirthdayTimer.StartTime,
                      - NempPlayer.GetCountDownLength(NempPlayer.NempBirthdayTimer.CountDownFileName))
        else
            NempPlayer.NempBirthdayTimer.StartCountDownTime := NempPlayer.NempBirthdayTimer.StartTime;

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


procedure TNemp_MainForm.MedialistPanelResize(Sender: TObject);
var ExtraSpace: Integer;
begin
    if not FormReadyAndActivated then
        exit;

    ExtraSpace := 16 * AnzeigeMode;
    MedienlisteFillPanel.Left := EditFastSearch.Left + EditFastSearch.Width + 6;
    MedienlisteFillPanel.Width := MedialistPanel.Width - MedienlisteFillPanel.Left - ExtraSpace;// - 8;
    MedienListeStatusLBL.Width := MedienlisteFillPanel.Width - 16;

    if assigned(NempFormBuildOptions) then
        NempSkin.SetVSTOffsets;
end;

procedure TNemp_MainForm.MedienBibDetailPanelResize(Sender: TObject);
var ExtraSpace: Integer;
begin
    if not FormReadyAndActivated then
        exit;

    ExtraSpace := 16 * AnzeigeMode;
    MedienBibDetailFillPanel.Left := TabBtn_Lyrics.Left + TabBtn_Lyrics.Width + 6;
    MedienBibDetailFillPanel.Width := MedienBibDetailPanel.Width - MedienBibDetailFillPanel.Left - ExtraSpace;
    MedienBibDetailStatusLbl.Width := MedienBibDetailFillPanel.Width - 16;

    if assigned(NempFormBuildOptions) and ( NOT NempFormBuildOptions.HideFileOverviewPanel) then
         NempFormBuildOptions.ResizeSubPanel(MedienBibDetailPanel, DetailCoverLyricsPanel, NempFormBuildOptions.FileOverviewCoverRatio);
end;


procedure TNemp_MainForm.DetailID3TagPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(MedienBib) then
        RefreshVSTCoverTimer.Enabled := True;
end;


procedure TNemp_MainForm.SplitterFileOverviewCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
var s: TSplitter;
begin
    s := Sender as TSplitter;
    if s.Align in [alLeft, alRight] then
        accept := (s.MinSize < NewSize) and ( (s.Parent.Width - newSize) > s.MinSize)
    else
        accept := (s.MinSize < NewSize) and ( (s.Parent.Height - newSize) > s.MinSize)
end;

procedure TNemp_MainForm.SplitterFileOverviewMoved(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if not assigned(NempFormBuildOptions) then
        exit;

    if MedienBibDetailPanel.Width > 0 then
        NempFormBuildOptions.FileOverviewCoverRatio := Round(DetailCoverLyricsPanel.Width * 100 / MedienBibDetailPanel.Width)
    else
        NempFormBuildOptions.FileOverviewCoverRatio := 50;
end;


procedure TNemp_MainForm.PlaylistPanelResize(Sender: TObject);
var ExtraSpace: Integer;
begin
    if not FormReadyAndActivated then
        exit;

    ExtraSpace := 16 * AnzeigeMode;
    PlaylistFillPanel.Left := EditplaylistSearch.Left + EditplaylistSearch.Width + 6;
    PlaylistFillPanel.Width := PlaylistPanel.Width - PlaylistFillPanel.Left - ExtraSpace;
    PlayListStatusLBL.Width := PlaylistFillPanel.Width - 16;

    if assigned(NempFormBuildOptions) then
        NempSkin.SetPlaylistOffsets;
end;



procedure TNemp_MainForm.MitzuflligenEintrgenausderMedienbibliothekfllen1Click(
  Sender: TObject);
begin
  if Not Assigned(RandomPlaylistForm) then
        Application.CreateForm(TRandomPlaylistForm, RandomPlaylistForm);
  /// RandomPlaylistForm.ShowModal;
  ///  Why modal??
  RandomPlaylistForm.Show;
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

procedure TNemp_MainForm.CoverScrollbarEnter(Sender: TObject);
begin
    if (Medienbib.DisplayContent <> DISPLAY_BrowseFiles)
        and (Medienbib.DisplayContent <> DISPLAY_Search)
    then
        CoverScrollbarChange(Sender);
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
    CoverFlowRefreshViewTimer.Enabled := True;
end;

procedure TNemp_MainForm.PanelCoverBrowseMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    if CoverFlowRefreshViewTimer.Enabled then exit;
    MedienBib.NewCoverFlow.CurrentItem := MedienBib.NewCoverFlow.CurrentItem - 1;
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
    if not FormReadyAndActivated then
        exit;
    if PanelCoverBrowse.Visible then
        MedienBib.NewCoverFlow.Paint;
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
        IncrementalCoverSearchTimer.Enabled := False;
        IncrementalCoverSearchTimer.Enabled := True;
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
var i, maxC: Integer;
  DateiListe: TObjectlist;
begin
  if ssleft in shift then
  begin
    if (abs(X - CoverImgDownX) > 5) or  (abs(Y - CoverImgDownY) > 5) then
    begin
    //showmessage( inttostr(abs(X - CoverImgDownX)) + '----' + inttostr(abs(Y - CoverImgDownY)) );
        Dateiliste := TObjectlist.Create(False);
        try
            GenerateListForHandleFiles(DateiListe, 1, true);
            DragSource := DS_VST;
            with DragFilesSrc1 do
            begin
                // Add files selected to DragFilesSrc1 list
                ClearFiles;
                DragDropList.Clear;

                maxC := min(NempOptions.maxDragFileCount, DateiListe.Count);
                if DateiListe.Count > NempOptions.maxDragFileCount then
                    AddErrorLog(Format(Warning_TooManyFiles, [NempOptions.maxDragFileCount]));

                for i := 0 to maxC - 1 do
                begin
                    AddFile((Dateiliste[i] as TAudiofile).Pfad);
                    DragDropList.Add((Dateiliste[i] as TAudiofile).Pfad);
                end;
                // This is the START of the drag (FROM) operation.
                Execute;
            end;

        finally
            FreeAndNil(Dateiliste);
        end;
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

  // try to create the directory, if it not exist already
  // --- this behaviour should be OK.
  //     The default directory is savePath + \webradio, so it's in the same directory as "Cover\",
  //     which is created automatically anyway.
  if NOT DirectoryExists(ExtractFilePath(NempPlayer.DownloadDir)) then
  try
      ForceDirectories(NempPlayer.DownloadDir);
  except
      // silent exception here
      // TranslateMessageDLG((Warning_RecordingDirNotFoundCreationFailed), mtWarning, [mbOk], 0);
  end;

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



(*
procedure TNemp_MainForm.VST_ColumnPopupCoverClick(Sender: TObject);
begin
    if Sender is TMenuItem then
    begin
        Nemp_MainForm.NempOptions.ShowCoverAndDetails := (Sender as TMenuItem).Checked;
        ActualizeVDTCover;
    end;
end;
*)

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

procedure TNemp_MainForm.VST_ColumnPopupPopup(Sender: TObject);
var i: Integer;
begin

    for i := 0 to VST_ColumnPopup.Items.Count - 1 do
    begin
        VST_ColumnPopup.Items[i].Checked :=
                coVisible in Nemp_MainForm.VST.Header.Columns[VST_ColumnPopup.Items[i].Tag].Options;
    end;

    //VST_ColumnPopupCover.Checked := Nemp_MainForm.NempOptions.ShowCoverAndDetails;
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
    if MainPlayerControlsActive then
    begin
        case key of
            vk_up, vk_Right: NempPlaylist.Time := NempPlaylist.Time + 5;
            vk_Down, vk_Left: NempPlaylist.Time := NempPlaylist.Time - 5;
        end;
    end else
    begin
        case key of
            vk_up, vk_Right: NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 5;
            vk_Down, vk_Left: NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 5;
        end;

    end;
end;

procedure TNemp_MainForm.TabBtn_PreselectionClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Medialist_Browse_PopupMenu.Popup(Point.X, Point.Y+10);
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

procedure TNemp_MainForm.PM_P_ScrobblerOptionsClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
      Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer7;
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.ToolImageClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  PopupTools.Popup(Point.X, Point.Y+10);
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


procedure TNemp_MainForm.MM_T_WebServerOptionsClick(Sender: TObject);
begin
    if Not Assigned(OptionsCompleteForm) then
        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.WebServerNode;
    OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.WebServerNode] := True;
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer8;
    OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.__MainContainerPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    Resizing := True;
    ReleaseCapture;
    PerForm(WM_SysCommand, ResizeFlag , 0);
  end;
end;



procedure TNemp_MainForm.__MainContainerPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TNemp_MainForm.__MainContainerPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   Resizing := False;
end;

initialization


finalization

    DeallocateHWnd(FOwnMessageHandler);

end.

