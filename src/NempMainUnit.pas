{

    Unit NempMainUnit
    Form Nemp_MainForm

    The MainForm of Nemp

    ---------------------------------------------------------------
    Nemp - Noch efin Mp3-Player
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


Unit NempMainUnit;

{$I xe.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NempAudioFiles, AudioFileHelper, ComCtrls, Grids, Contnrs, ShellApi,
  Menus, ImgList, ExtCtrls, StrUtils, Inifiles, CheckLst, //madexcept,
  Buttons,  VirtualTrees, VSTEditControls,
  jpeg, activeX, DateUtils, cddaUtils, MyDialogs,
    spectrum_vis,
  Hilfsfunktionen, Systemhelper, CoverHelper, TreeHelper, NempDragFiles,
  ComObj, ShlObj, clipbrd, Spin,  U_CharCode,
  MainFormHelper, MessageHelper, BibSearchClass, MainFormLayout,
  Nemp_ConstantsAndTypes, NempApi, SplitForm_Hilfsfunktionen, SearchTool, mmsystem,
   Nemp_SkinSystem, NempPanel, SkinButtons, math, PlayerLog,

  PlayerClass, PlaylistClass, MedienbibliothekClass, BibHelper, deleteHelper,
  PlaylistDuplicates,

  LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists,
  LibraryOrganizer.Webradio, Cover.ViewCache,

  gnuGettext, Nemp_RessourceStrings, languageCodes,
  OneInst, DriveRepairTools, ShoutcastUtils, WebServerClass, ScrobblerUtils,
  UpdateUtils, PlayWebstream,
  ClassicCoverFlowClass, CoverDownloads,
  unitFlyingCow, dglOpenGL, NempCoverFlowClass, PartyModeClass, RatingCtrls, tagClouds,
  Lyrics, pngimage, ExPopupList, SilenceDetection,
  System.ImageList, System.Types, System.UITypes, ProgressShape,
  System.Win.TaskbarCore, Vcl.Taskbar, BaseForms, Vcl.VirtualImageList,
  System.Actions, Vcl.ActnList, Vcl.AppEvnts
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

  TNemp_MainForm = class(TNempCustomMainForm)
    BassTimer: TTimer;
    Nemp_MainMenu: TMainMenu;
    PlayListImageList: TImageList;
    PlaylistPanel: TNempPanel;
    PanelStandardBrowse: TNempPanel;
    SplitterBrowse: TSplitter;
    ArtistsVST: TVirtualStringTree;
    AlbenVST: TVirtualStringTree;
    TreePanel: TNempPanel;
    AutoSavePlaylistTimer: TTimer;
    PlaylistFillPanel: TNempPanel;
    GRPBOXPlaylist: TNempPanel;
    SleepTimer: TTimer;
    BirthdayTimer: TTimer;
    PanelCoverBrowse: TNempPanel;
    CoverScrollbar: TScrollBar;
    MenuImages: TImageList;
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
    MM_O_SplitToggle_Playlist: TMenuItem;
    N32: TMenuItem;
    MM_O_ToggleStayOnTop: TMenuItem;
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
    N35: TMenuItem;
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
    AuswahlHeaderPanel0: TNempPanel;
    TabBtn_Preselection0: TSkinButton;
    TabBtn_Browse0: TSkinButton;
    TabBtn_CoverFlow0: TSkinButton;
    AuswahlFillPanel0: TNempPanel;
    AuswahlStatusLBL0: TLabel;
    PlayerHeaderPanel: TNempPanel;
    MM_ML_Search: TMenuItem;
    IMGMedienBibCover: TImage;
    ImgScrollCover: TImage;
    Pnl_CoverFlowLabel: TNempPanel;
    Lbl_CoverFlow: TLabel;
    PM_P_PartyMode: TMenuItem;
    TabBtn_TagCloud0: TSkinButton;
    MM_O_PartyMode: TMenuItem;
    PanelTagCloudBrowse: TNempPanel;
    PM_ML_GetTags: TMenuItem;
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
    Medialist_Collection_PopupMenu: TPopupMenu;
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
    PM_ML_SortLayerBy: TMenuItem;
    PM_ML_SortLayerByDirectory: TMenuItem;
    PM_ML_SortLayerByGenre: TMenuItem;
    PM_ML_SortLayerByFileAge: TMenuItem;
    PM_ML_SortLayerByReleaseYear: TMenuItem;
    PM_ML_SortLayerByCount: TMenuItem;
    PM_ML_SortLayerByArtistAlbum: TMenuItem;
    PM_ML_SortLayerByAlbum: TMenuItem;
    PM_ML_SortLayerByName: TMenuItem;
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
    MedienBibDetailPanel: TNempPanel;
    DetailID3TagPanel: TNempPanel;
    MedienBibDetailHeaderPanel: TNempPanel;
    MedienBibDetailFillPanel: TNempPanel;
    TabBtn_Cover: TSkinButton;
    TabBtn_SummaryLock: TSkinButton;
    SplitterFileOverview: TSplitter;
    DetailCoverLyricsPanel: TNempPanel;
    LyricsMemo: TMemo;
    ImgDetailCover: TImage;
    MedienBibDetailStatusLbl: TLabel;
    ContainerPanelMedienBibDetails: TNempPanel;
    __MainContainerPanel: TNempContainerPanel;
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
    LblBibReplayGain: TLabel;
    PlaylistManagerPopup: TPopupMenu;
    N10: TMenuItem;
    PM_PLM_RecentPlaylists: TMenuItem;
    PM_PLM_SaveAsNewFavorite: TMenuItem;
    PM_PLM_SaveAsExistingFavorite: TMenuItem;
    N19: TMenuItem;
    PM_PLM_EditFavourites: TMenuItem;
    PM_PLM_Default: TMenuItem;
    PM_PL_SaveAsPlaylist: TMenuItem;
    MM_PL_SaveAsPlaylist: TMenuItem;
    lblBibFilename: TLabel;
    lblBibDirectory: TLabel;
    Bevel2: TBevel;
    NempTaskbarManager: TTaskbar;
    PM_PL_ScanForDuplicates: TMenuItem;
    PlaylistVST_HeaderPopup: TPopupMenu;
    pmShowColumnIndex: TMenuItem;
    DummyImageList: TImageList;
    TabBtnCoverCategory: TSkinButton;
    Medialist_Browse_Categories_PopupMenu: TPopupMenu;
    PM_ML_ConfigureMedialibrary: TMenuItem;
    MM_ML_ConfigureMediaLibrary: TMenuItem;
    AuswahlControlPanel0: TNempPanel;
    PlaylistControlPanel: TNempPanel;
    TabBtn_Playlist: TSkinButton;
    TabBtn_Favorites: TSkinButton;
    EditPlaylistSearch: TEdit;
    MedienBibDetailControlPanel: TNempPanel;
    MedienListeControlPanel: TNempPanel;
    PM_ML_ChangeCategory: TMenuItem;
    PM_MLView_ChangeCategory: TMenuItem;
    PM_ML_bpm: TMenuItem;
    N11: TMenuItem;
    PM_ML_SortLayerAscending: TMenuItem;
    PM_ML_SortLayerDescending: TMenuItem;
    TabBtnTagCloudCategory: TSkinButton;
    PM_ML_SortPlaylistsBy: TMenuItem;
    PM_ML_SortPlaylistsByPath: TMenuItem;
    PM_ML_SortPlaylistsByFolder: TMenuItem;
    PM_ML_SortPlaylistsByFilename: TMenuItem;
    N28: TMenuItem;
    PM_ML_SortPlaylistsAscending: TMenuItem;
    PM_ML_SortPlaylistsDescending: TMenuItem;
    PM_ML_SortLayerByArtistReleaseYear: TMenuItem;
    CoverflowPanel: TNempPanel;
    AuswahlHeaderPanel1: TNempPanel;
    AuswahlFillPanel1: TNempPanel;
    AuswahlStatusLBL1: TLabel;
    AuswahlControlPanel1: TNempPanel;
    TabBtn_Browse1: TSkinButton;
    TabBtn_CoverFlow1: TSkinButton;
    TabBtn_Preselection1: TSkinButton;
    TabBtn_TagCloud1: TSkinButton;
    CloudPanel: TNempPanel;
    AuswahlHeaderPanel2: TNempPanel;
    AuswahlFillPanel2: TNempPanel;
    AuswahlStatusLBL2: TLabel;
    AuswahlControlPanel2: TNempPanel;
    edtCloudSearch: TEdit;
    TabBtn_Browse2: TSkinButton;
    TabBtn_CoverFlow2: TSkinButton;
    TabBtn_Preselection2: TSkinButton;
    TabBtn_TagCloud2: TSkinButton;
    EmptyLibraryPanel: TNempPanel;
    MM_O_JoinWindows: TMenuItem;
    MM_O_SplitWindows: TMenuItem;
    N29: TMenuItem;
    MM_O_CompactToggleFileOverview: TMenuItem;
    MM_O_CompactToggleTitleList: TMenuItem;
    MM_O_CompactToggleBrowselist: TMenuItem;
    ActionListLayout: TActionList;
    actJoinWindows: TAction;
    actSplitWindows: TAction;
    actToggleFileOverview: TAction;
    actToggleTitleList: TAction;
    actToggleBrowseList: TAction;
    actTogglePlaylist: TAction;
    actToggleStayOnTop: TAction;
    PM_P_JoinWindows: TMenuItem;
    PM_P_SplitWindows: TMenuItem;
    N31: TMenuItem;
    PM_P_CompactToggleFileoverview: TMenuItem;
    PM_P_CompactToggleTitlelist: TMenuItem;
    PM_P_CompactToggleBrowseList: TMenuItem;
    PM_P_SplitTogglePlaylist: TMenuItem;
    PM_P_ToggleStayOnTop: TMenuItem;
    SplitWindowTimer: TTimer;
    N33: TMenuItem;
    PM_ML_FavPlaylistSeparator: TMenuItem;
    PM_ML_SaveAsNewFavorite: TMenuItem;
    PM_ML_EditFavorites: TMenuItem;
    PM_ML_ResetTagCloudSeparator: TMenuItem;
    PM_ML_ResetTagCloud: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    N34: TMenuItem;
    PM_P_TreeView: TMenuItem;
    PM_P_FileOverview: TMenuItem;
    PM_P_TreeViewStacked: TMenuItem;
    PM_P_TreeViewSideBySide: TMenuItem;
    PM_P_OverviewCoverAndDetails: TMenuItem;
    PM_P_OverviewOnlyCover: TMenuItem;
    PM_P_OverviewOnlyDetails: TMenuItem;
    Onlydetails2: TMenuItem;
    PM_P_OverviewStacked: TMenuItem;
    PM_P_OverviewSideBySide: TMenuItem;
    PM_P_ShowCategorySelection: TMenuItem;
    actTreeviewStacked: TAction;
    actTreeViewSideBySide: TAction;
    MM_O_Treeview: TMenuItem;
    MM_O_TreeviewSideBySide: TMenuItem;
    MM_O_TreeviewStacked: TMenuItem;
    MM_O_Overview: TMenuItem;
    MM_O_OverviewSideBySide: TMenuItem;
    MM_O_OverviewStacked: TMenuItem;
    N39: TMenuItem;
    MM_O_OverviewOnlyDetails: TMenuItem;
    MM_O_OverviewOnlyCover: TMenuItem;
    MM_O_OverviewCoverAndDetails: TMenuItem;
    MM_O_ShowCategorySelection: TMenuItem;
    N40: TMenuItem;
    actToggleShowCategorySelection: TAction;
    actFileOverviewBoth: TAction;
    actFileOverviewOnlyCover: TAction;
    actFileOverviewOnlyDetails: TAction;
    actFileOverviewStacked: TAction;
    actFileOverviewSideBySide: TAction;
    N37: TMenuItem;
    pm_FO_FileOverview: TMenuItem;
    pm_FO_SideBySide: TMenuItem;
    pm_FO_Stacked: TMenuItem;
    N41: TMenuItem;
    pm_FO_OnlyDetails: TMenuItem;
    pm_FO_OnlyCover: TMenuItem;
    pm_FO_CoverAndDetails: TMenuItem;
    PM_ML_ShowCategorySelection: TMenuItem;
    PM_ML_Treeview: TMenuItem;
    PM_ML_TreeViewSideBySide: TMenuItem;
    PM_ML_TreeViewStacked: TMenuItem;
    MM_ML_SearchDirectoryCurrentCategory: TMenuItem;
    PM_ML_SearchDirectoryCurrentCategory: TMenuItem;
    MM_T_DirectoriesProgram: TMenuItem;
    PM_P_DirectoriesProgram: TMenuItem;
    PM_MLView_RemoveFromCategory: TMenuItem;
    PM_ML_RemoveFromCategory: TMenuItem;
    Medialist_Category_PopupMenu: TPopupMenu;
    PM_ML_ConfigureMediaLibraryCat: TMenuItem;
    PM_ML_ClearCategory: TMenuItem;
    PM_ML_ShowPlaylistCategories: TMenuItem;
    PM_ML_ShowWebradioCategory: TMenuItem;
    N42: TMenuItem;
    actShowControlCover: TAction;
    Showcoverinconrtolpanel1: TMenuItem;
    Showcoverinconrtolpanel2: TMenuItem;
    MM_H_HelpOnline: TMenuItem;
    MM_ML_RefreshPlaylists: TMenuItem;
    PM_ML_CollectionShowPlaylistInExplorer: TMenuItem;
    pm_TagShowInExplorer: TMenuItem;
    PM_ML_ApplyDefaultActionToWholeList: TMenuItem;
    PM_P_OnlineHelp: TMenuItem;
    MM_H_CleanupUpdate: TMenuItem;
    PM_P_CleanupUpdate: TMenuItem;
    MM_T_Plugins: TMenuItem;
    PM_P_Plugins: TMenuItem;
    MM_T_PluginConfigure: TMenuItem;
    MM_T_PluginStop: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    PM_P_PluginConfigure: TMenuItem;
    PM_P_PluginStop: TMenuItem;
    DSPPluginImage: TImage;
    MM_T_PluginOpenFolder: TMenuItem;
    PM_P_PluginOpenFolder: TMenuItem;
    PM_T_Plugins: TMenuItem;
    PM_T_PluginOpenFolder: TMenuItem;
    PM_T_PluginStop: TMenuItem;
    PM_T_PluginConfigure: TMenuItem;
    N45: TMenuItem;

    procedure FormCreate(Sender: TObject);

    procedure RefreshStarGraphicsAllForms;
    procedure Skinan1Click(Sender: TObject);
    procedure ActivateSkin(aName: String);

    procedure ChangeLanguage(Sender: TObject);
    procedure ActivateDSPPlugin(Sender: TObject);

    Procedure AnzeigeSortMENUClick(Sender: TObject);

    procedure PM_ML_HideSelectedClick(Sender: TObject);
    procedure MM_ML_DeleteClick(Sender: TObject);
    procedure MM_ML_SearchDirectoryClick(Sender: TObject);
    procedure MM_ML_LoadClick(Sender: TObject);

    procedure MM_ML_SaveClick(Sender: TObject);

    procedure DatenbankUpdateTBClick(Sender: TObject);

    procedure ChangeCategory(aList: TAudioFileList);
    procedure HandleFiles(aList: TAudioFileList; how: integer);

    function GetSelectedCollectionFromMainWindow: TAudioCollection;
    procedure GenerateSortedListFromCollection(source: TAudioCollection; dest: TAudioFileList; CreateFileCopies: Boolean);
    function GenerateSortedListFromCollectionTree(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
    function GenerateSortedListFromCoverFlow(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
    function GenerateSortedListFromTagCloud(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
    function GenerateSortedListFromFileView(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
    function CopyAudioFileList(Source, Dest: TAudioFileList): Boolean;

    procedure PM_ML_CollectionPlayEnqueueClick(Sender: TObject);
    function GetFocussedAudioFile:TAudioFile;
    procedure Medialist_View_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_ShowInExplorerClick(Sender: TObject);

    procedure ShowSummary(aList: TAudioFileList = Nil);
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
    procedure MM_O_PreferencesClick(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure FormShow(Sender: TObject);

    function ValidAudioFile(filename: UnicodeString; JustPlay: Boolean): boolean;
    function NempFileType(filename: UnicodeString): TNempFileType;
    // procedure PM_ML_GetLyricsClick(Sender: TObject);

    procedure VSTBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);

    procedure StringVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);

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
    procedure VSTFilesStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure PlaylistVSTDragOver(Sender: TBaseVirtualTree;
      Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
      Mode: TDropMode; var Effect: Integer; var Accept: Boolean);

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
    procedure PM_ML_ExtendedShowAllFilesInDirClick(Sender: TObject);
    procedure NachDiesemDingSuchen1Click(Sender: TObject);
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
    // procedure PlaylistVSTResize(Sender: TObject);
    procedure ArtistsVSTResize(Sender: TObject);
    procedure AlbenVSTResize(Sender: TObject);
    procedure PaintFrameMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PlayerTabsClick(Sender: TObject);

    procedure TABPanelAuswahlClick(Sender: TObject);
    procedure PM_ML_MedialibraryExportClick(Sender: TObject);
    procedure PM_P_CloseClick(Sender: TObject);
    procedure PaintFrameMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PM_P_MinimizeClick(Sender: TObject);
    procedure AutoSavePlaylistTimerTimer(Sender: TObject);
    procedure AlbenVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FormResize(Sender: TObject);
    procedure PM_ML_DeleteSelectedClick(Sender: TObject);
    procedure EDITFastSearchEnter(Sender: TObject);
    procedure EDITFastSearchKeyPress(Sender: TObject; var Key: Char);
    procedure DoFastSearch(aString: UnicodeString; AllowErr: Boolean = False);
    procedure DoFastIPCSearch(aString: UnicodeString);

    procedure TitlesVSTGetHint(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex;
      var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: String);
    procedure VolTimerTimer(Sender: TObject);
    procedure IncrementalCoverSearchTimerTimer(Sender: TObject);
    procedure VSTAfterItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure SortierAuswahl1POPUPClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure TreePanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TntFormDestroy(Sender: TObject);
    procedure PaintFrameMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnCloseClick(Sender: TObject);
    procedure __BtnMinimizeClick(Sender: TObject);
    // procedure BtnMenuClick(Sender: TObject);
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
    Procedure OnRecentPlaylistsChange(Sender: TObject);
    procedure OnFavouritePlaylistsChange(Sender: TObject);

    Function GeneratePlaylistSTFilter: string;
    function GenerateMedienBibSTFilter: String;

    procedure RepairZOrder;

    procedure PM_ML_FilesPlayNowClick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    Procedure RepaintPanels;
    Procedure RepaintPlayerPanel;
    Procedure RepaintOtherForms;
    procedure RepaintAll;
    Procedure RepaintVisOnPause;
    procedure TABPanelPaint(Sender: TObject);

    procedure ShowDetailForm(aAudioFile: TAudioFile; DoShow: Boolean);
    procedure TNAMenuPopup(Sender: TObject);
    Procedure TNA_PlaylistClick(Sender: TObject);
    procedure BirthdayTimerTimer(Sender: TObject);
    procedure MenuBirthdayStartClick(Sender: TObject);

    procedure ShowMatchingControls;//(MainOrHeadset: Integer);
    procedure ShowProgress(aProgress: Double; aSeconds: Integer; MainPlayer: Boolean);// aTimeString: String);
    procedure ReCheckAndSetProgressChangeGUIStatus;
    procedure ReInitPlayerVCL(GetCoverWasSuccessful: Boolean);

    procedure RefreshPaintFrameHint(ShowDelayExplanation: Boolean);
    procedure DisplayTitleInformation(ShowMainFile, GetCoverWasSuccessful: Boolean);

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
    procedure TabBtn_Preselection0Click(Sender: TObject);
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
    procedure DoExpandCloud(ac: TAudioFileCollection);
    // procedure DoResetCloud(ac: TAudioFileCollection);
    procedure PanelTagCloudBrowseDblClick(Sender: TObject);
    procedure CloudTestKey(Sender: TObject; var Key: Char);

    procedure CloudTestKeyDown(Sender: TObject; var Key: Word;
    Shift: TShiftState);

    procedure CloudPaint(Sender: TObject);
    procedure CloudAfterPaint(Sender: TObject);
    procedure OnGetCloudHint(Sender: TCloudView; ac: TAudioFileCollection; var HintText: String);

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
    procedure SplitterBrowseMoved(Sender: TObject);

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
    procedure PlaylistVSTEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure CorrectSkinRegionsTimerTimer(Sender: TObject);
    procedure MM_O_Skin_UseAdvancedClick(Sender: TObject);
    procedure PanelCoverBrowseMouseWheelDown(Sender: TObject;
      Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure PanelCoverBrowseMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure CoverFlowRefreshViewTimerTimer(Sender: TObject);
    procedure EditPlaylistSearchEnter(Sender: TObject);
    procedure EditPlaylistSearchChange(Sender: TObject);
    procedure EditPlaylistSearchKeyPress(Sender: TObject; var Key: Char);
    procedure EditPlaylistSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintFrameDblClick(Sender: TObject);
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
    procedure RefreshVSTDetailsTimerTimer(Sender: TObject);
    procedure TabBtn_MarkerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure QuickSearchHistory_PopupMenuPopup(Sender: TObject);
    procedure pmQuickSeachHistoryClick(Sender: TObject);
    procedure Medialist_Collection_PopupMenuPopup(Sender: TObject);
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
    procedure AfterLayoutBuild(Sender: TObject);
    // procedure __MainContainerPanelResize(Sender: TObject);
    procedure Pnl_CoverFlowLabelPaint(Sender: TObject);
    procedure ControlPanelPaint(Sender: TObject);
    procedure EmptyLibraryPanelPaint(Sender: TObject);
    procedure _ControlPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure _ControlPanelResize(Sender: TObject);
    procedure NewPlayerPanelResize(Sender: TObject);

    procedure PlaylistCueChanged(Sender: TNempPlaylist);
    procedure PlaylistUserChangedTitle(Sender: TNempPlaylist);
    procedure OnDeletePlaylistDuplicate(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
    procedure OnDeletePlaylistDuplicateOriginal(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
    procedure OnAfterLastDuplicateDeleted(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
    procedure OnDuplicateDblClick(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
    procedure OnAfterRefreshDuplicateScan(Sender: TObject);
    procedure PlaylistDeleteFile(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
    procedure PlaylistAddFile(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
    procedure PlaylistFilePropertiesChanged(Sender: TNempPlaylist);
    procedure PlaylistSearchResultsChanged(Sender: TNempPlaylist);
    procedure PlaylistPropertiesChanged(Sender: TNempPlaylist);

    procedure PlaylistAudioFileMoved(Sender: TNempPlaylist; aFile: TAudioFile; oldIndex, newIndex: Integer);
    procedure PlaylistCueListFound(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
    procedure PlaylistChangedCompletely(Sender: TNempPlaylist);
    procedure PlaylistCleared(Sender: TNempPlaylist);


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
    procedure TabBtn_FavoritesClick(Sender: TObject);
    procedure PM_PLM_SaveAsNewFavoriteClick(Sender: TObject);

    procedure PM_PLM_LoadFavoritePlaylistClick(Sender: TObject);
    procedure PM_PLM_SwitchToDefaultPlaylistClick(Sender: TObject);

    procedure PM_PLM_SaveAsExistingFavoriteClick(Sender: TObject);
    procedure PlaylistManagerPopupPopup(Sender: TObject);

    procedure OnPlaylistManagerReset(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure PlaylistVSTDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure PM_PLM_EditFavouritesClick(Sender: TObject);
    procedure PM_PL_SaveAsPlaylistClick(Sender: TObject);
    procedure TabBtn_SummaryLockClick(Sender: TObject);
    procedure NempTaskbarManagerThumbPreviewRequest(Sender: TObject; APreviewHeight,
      APreviewWidth: Integer; PreviewBitmap: TBitmap);
    procedure PM_PL_ScanForDuplicatesClick(Sender: TObject);
    procedure pmShowColumnIndexClick(Sender: TObject);
    procedure PlayerArtistLabelDblClick(Sender: TObject);
    procedure AlbenVSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure AlbenVSTIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: string; var Result: Integer);
    procedure AlbenVSTMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure AlbenVSTDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; const Text: string;
      const CellRect: TRect; var DefaultDraw: Boolean);
    procedure AlbenVSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure AlbenVSTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure ArtistsVSTDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure PanelCoverBrowseDblClick(Sender: TObject);
    procedure TabBtnCoverCategoryClick(Sender: TObject);
    procedure PM_ML_FilesPlayEnqueueClick(Sender: TObject);
    procedure PM_ML_ConfigureMedialibraryClick(Sender: TObject);
    procedure CategoryVSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure CategoryVSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);

    procedure LibraryMetaDragOver(Shift: TShiftState; State: TDragState;
      Pt: TPoint; Mode: TDropMode; DataObject: IDataObject; var Effect: Integer; var Accept: Boolean);

    procedure LibraryCollectionTreeDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure TreesGetUserClipboardFormats(Sender: TBaseVirtualTree;
      var Formats: TFormatEtcArray);
    procedure TreesRenderOLEData(Sender: TBaseVirtualTree;
      const FormatEtcIn: tagFORMATETC; out Medium: tagSTGMEDIUM;
      ForClipboard: Boolean; var Result: HRESULT);
    procedure LibraryVSTEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure VSTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);

    procedure LibraryMetaDragDrop(Shift: TShiftState; Pt: TPoint;
      Mode: TDropMode; DataObject: IDataObject; var Effect: Integer);
    procedure LibraryCollectionTreeDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure ssdedtCloudSearchChange(Sender: TObject);
    procedure ssdedtCloudSearchKeyPress(Sender: TObject; var Key: Char);
    procedure PM_ML_ChangeCategoryClick(Sender: TObject);
    procedure PM_MLView_ChangeCategoryClick(Sender: TObject);
    procedure Medialist_Browse_Categories_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_SortPlaylistsDescendingClick(Sender: TObject);
    procedure EmptyLibraryPanelResize(Sender: TObject);
    procedure actJoinSplitWindowsExecute(Sender: TObject);
    procedure actToggleFileOverviewExecute(Sender: TObject);
    procedure actToggleTitleListExecute(Sender: TObject);
    procedure actToggleBrowseListExecute(Sender: TObject);
    procedure actTogglePlaylistExecute(Sender: TObject);
    procedure actToggleStayOnTopExecute(Sender: TObject);
    procedure SplitWindowTimerTimer(Sender: TObject);
    procedure PM_ML_ResetTagCloudClick(Sender: TObject);
    function ApplicationEvents1Help(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure CloseHelpWnd;
    procedure actTreeviewStackedExecute(Sender: TObject);
    procedure actTreeViewSideBySideExecute(Sender: TObject);
    procedure actToggleShowCategorySelectionExecute(Sender: TObject);
    procedure actFileOverviewStackedExecute(Sender: TObject);
    procedure actFileOverviewSideBySideExecute(Sender: TObject);
    procedure actFileOverviewBothExecute(Sender: TObject);
    procedure actFileOverviewOnlyCoverExecute(Sender: TObject);
    procedure actFileOverviewOnlyDetailsExecute(Sender: TObject);
    procedure PM_P_ViewClick(Sender: TObject);
    procedure PlaylistVSTStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure MM_ML_SearchDirectoryCurrentCategoryClick(Sender: TObject);
    procedure MM_T_DirectoriesProgramClick(Sender: TObject);
    procedure PM_MLView_RemoveFromCategoryClick(Sender: TObject);
    procedure PM_ML_RemoveFromCategoryClick(Sender: TObject);
    procedure Medialist_Category_PopupMenuPopup(Sender: TObject);
    procedure PM_ML_ShowPlaylistCategoriesClick(Sender: TObject);
    procedure PM_ML_ShowWebradioCategoryClick(Sender: TObject);
    procedure PM_ML_ClearCategoryClick(Sender: TObject);
    procedure actShowControlCoverExecute(Sender: TObject);
    procedure MM_H_HelpOnlineClick(Sender: TObject);
    procedure MM_ML_RefreshPlaylistsClick(Sender: TObject);
    procedure PM_ML_CollectionShowPlaylistInExplorerClick(Sender: TObject);
    procedure pm_TagShowInExplorerClick(Sender: TObject);
    procedure PM_ML_ApplyDefaultActionToWholeListClick(Sender: TObject);
    procedure TitlesVSTDrawHint(Sender: TBaseVirtualTree; HintCanvas: TCanvas;
      Node: PVirtualNode; R: TRect; Column: TColumnIndex);
    procedure TitlesVSTGetHintKind(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
    procedure TitlesVSTGetHintSize(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
    procedure MM_H_CleanupUpdateClick(Sender: TObject);
    procedure MM_HelpClick(Sender: TObject);
    procedure MM_T_PluginConfigureClick(Sender: TObject);
    procedure MM_T_PluginStopClick(Sender: TObject);
    procedure MM_T_PluginsClick(Sender: TObject);
    procedure PM_P_PluginsClick(Sender: TObject);
    procedure MM_T_PluginOpenFolderClick(Sender: TObject);
    procedure PM_T_PluginsClick(Sender: TObject);

  private
    { Private declarations }
    CoverImgDownX: Integer;
    CoverImgDownY: Integer;
    TagCloudDownX: Integer;
    TagCloudDownY: Integer;

    ResizeFlag: Cardinal;

    CurrentTagToChange: String;
    fCurrentlySelectedFile: TAudioFile;

    PaintFrameDownX: Integer;
    PaintFrameDownY: Integer;

    OldScrollbarWindowProc: TWndMethod;
    OldLyricMemoWindowProc: TWndMethod;

    // a replacement for the PopupMenu.Tag, as we have two medialist popups now
    // MediaListPopupTag: Integer;
    LastPaintedTime: Integer;
    FormReadyAndActivated : Boolean;
    MostRecentInsertNodeForPlaylist: PVirtualNode;

    procedure OwnMessageProc(var msg: TMessage);
    procedure NewScrollBarWndProc(var Message: TMessage);
    procedure NewLyricMemoWndProc(var Message: TMessage);
    procedure WMStartEditing(var Msg: TMessage); Message WM_STARTEDITING;

    procedure CMMenuClosed(var Msg: TMessage ); message CM_MENUCLOSED;
    procedure CM_ENTERMENULOOP(var Msg: TMessage ); message CM_ENTERMENULOOP;

    procedure HandleRemoteFilename(filename: UnicodeString; Mode: Integer);
    procedure CatchAllExceptionsOnShutDown(Sender: TObject; E: Exception);
    procedure HandleInsertHeadsetToPlaylist(aAction: Integer);

    procedure PlaylistSelectNextFlagged(aFlag: Integer);
    procedure PlaylistSelectNextSearchresult;
    procedure PlaylistSelectNextDuplicate;
    procedure PlaylistScrollToPlayingFile;
    procedure PlaylistSelectAllSearchresults;

    function GetCurrentlySelectedFile: TAudioFile;
    procedure SetCurrentlySelectedFile(Value: TAudioFile);

    procedure RefreshSubForm(aForm: TNempSubForm; IsVisible: Boolean);
    procedure InitTaskBarIcons;

    procedure OnCoverDownloadComplete(DownloadItem: TCoverDownloadItem; Bitmap: TBitmap);
    procedure OnDownloadSaved(DownloadItem: TCoverDownloadItem);

    procedure OnNempDragover(Shift: TShiftState; State: TDragState;
      Pt: TPoint; var Effect: Integer; var Accept: Boolean);
    procedure OnNempDrop(const DataObject: IDataObject; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer);

    procedure HandleLibraryDragOver(lc: TLibraryCategory; DataObject: IDataObject; Shift: TShiftState; State: TDragState;
        detailedInternalDrop: Boolean; var Effect: Integer; var Accept: Boolean; var HintStr: String);

    procedure SearchDirectoryForNewFiles(TargetCategory: TLibraryCategory);

    procedure CDDBConsistencyCheck(af: TAudioFile);

  public
    { Public declarations }
    CloudViewer: TCloudView;

    NempIsClosing: Boolean;
    fDropManager : TNempDragManager;// IDropTarget;


    // Z�hlt die Nachrichten "Neues Laufwerk angeschlossen"
    // n�tig, da ein Update der Bib nicht m�glich ist, wenn ein Update bereits l�uft
    NewDrivesNotificationCount: Integer;

    WebRadioInsertMode: Integer;

    PlayListSkinImageList: TImageList;
    MenuSkinImageList: TImageList;

    ActivationMessage: Cardinal;
    MinimizedIndicator: Boolean;

    NempDockedForms: Array [1..3] of Boolean;
    NempSkin: TNempSkin;

    TaskBarDelay: integer;

    ContinueWithPlaylistAdding: Boolean;
    KeepOnWithLibraryProcess: Boolean;

    ReadyForGetFileApiCommands: Boolean;

    SelectionPrefix: UnicodeString;
    OldSelectionPrefix: UnicodeString;

    CorrectSkinRegionsTimer,
    ReallyDeletePlaylistTimer,
    VolTimer,
    RefreshVSTCoverTimer,
    RefreshVSTDetailsTimer,
    CurrentSearchDirPlayistTimer,
    CurrentSearchDirMediaLibraryTimer,
    IncrementalCoverSearchTimer : TTimer;

    Nemp_VersionString: String;
    Saved8087CW: Word;
    SelectedPlayListMp3s: TNodeArray;
    // NempWindowDefault: DWord;
    MainPlayerControlsActive: Boolean;
    AlphaBlendBMP: TBitmap;
    BibRatingHelper: TRatingHelper;
    TagLabelList: TComponentList;

    // reference to AB1 and AB2, needed for assigning the correct graphics
    ABRepeatStartImg, ABRepeatEndImg: TImage;
    Resizing: Boolean;

    property CurrentlySelectedFile: TAudioFile read GetCurrentlySelectedFile write SetCurrentlySelectedFile;

    procedure MinimizeNemp(Sender: TObject);
    procedure DeactivateNemp(Sender: TObject);
    procedure RestoreNemp;
    procedure ProcessCommandline(lpData: Pointer; StartPlay: Boolean) ; overload;
    procedure ProcessCommandline(filename: UnicodeString; StartPlay: Boolean; Enqueue: Boolean); overload;

    function GetShutDownInfoCaption: String;
    procedure RefreshAuswahlStatusLBL(newCaption: String);

    procedure RefreshCurrentSearchDirPlayist(Sender: TObject);
    procedure RefreshCurrentSearchDirMediaLibrary(Sender: TObject);
    procedure ReInitTaskbarManager(TryAgainOnException: Boolean);
    procedure ConfirmPlaylistClearing(InsertCount: Integer; var EnqueueMode: Integer);
    procedure PlayEnqueue(aCollection: TAudioCollection; EnqueueMode: Integer);
    procedure PlayEnqueueFromView(EnqueueMode: Integer);
    procedure DirectPlayFocusedFile;
    procedure TogglePlayPause(WantDialog: Boolean);
    procedure CoverFlowCategoryMenuItemClick(Sender: TObject);
    function GetFocussedCategory: TLibraryCategory;
    function GetFocussedCollection: TAudioCollection;
    procedure ReFillBrowseTrees(RemarkOldNodes: LongBool);
    procedure ClearBrowseTrees;
    procedure ReFillCategoryMenu;
    procedure ReFillCategoryTree(RemarkOldNodes: LongBool);
    procedure RefreshCollectionTreeHeader(Source: TLibraryCategory);
    procedure FillCollectionTree(Source: TLibraryCategory; RemarkOldNodes: LongBool; OnlySearchResults: Boolean = False);
    procedure FillCollectionCoverflow(Source: TLibraryCategory; RemarkOldNodes: LongBool);
    procedure FillCollectionTagCloud(Source: TLibraryCategory; RemarkOldNodes: LongBool);
    procedure AddCollection(aCollection: TAudioCollection; aNode: PVirtualNode; OnlySearchResults: Boolean = False);
    //procedure CorrectSkinRegions;
    //procedure ResetVolSteps;
    procedure ReSizeBrowseTrees;
    procedure ReAlignBrowseTrees;
    procedure ReAlignFileOverview;
    procedure ReAlignControlCover;
    procedure RefreshActionLayoutCheckedStatus;
    procedure RefreshCategorySelectionVisibility;
  protected
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
    procedure NeedPreviewMainPicker(aRootCollection: TRootCollection);

    procedure FCtest(var msg : TMessage); message WM_FLYINGCOWTEST;

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

  CoverDownloadThread: TCoverDownloadWorkerThread;

  SavePath: UnicodeString; // Programmdir oder Userdir

  LanguageList: TStrings;

  ErrorLog: TStringList;
  ErrorLogCount: Integer;

implementation

uses   Splash, About, OptionsComplete, StreamVerwaltung,
   PlaylistUnit,  AuswahlUnit,  MedienlisteUnit, ShutDown, Details,
  BirthdayShow, RandomPlaylist, BasicSettingsWizard,
  NewPicture, ShutDownEdit, NewStation, BibSearch, BassHelper,
  ExtendedControlsUnit, CloudEditor, NempHelp,
  TagHelper, PartymodePassword, CreateHelper, PlaylistToUSB, ErrorForm,
  CDOpenDialogs, WebServerLog, Lowbattery, ProgressUnit, EffectsAndEqualizer,
  MainFormBuilderForm, ReplayGainProgress, NempReplayGainCalculation,
  NewFavoritePlaylist, PlaylistManagement, PlaylistEditor, AudioDisplayUtils ,
  fChangeFileCategory, fExport, fUpdateCleaning, UpdateCleaning;


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
    // Prefix zur�cksetzen
    SelectionPrefix := '';
end;

procedure TNemp_MainForm.VolTimerTimer(Sender: TObject);
begin
    VolTimer.Enabled := False;
    NempPlayer.VolStep := 0;
end;

procedure TNemp_MainForm.CorrectSkinRegionsTimerTimer(Sender: TObject);
begin
    CorrectSkinRegionsTimer.Enabled := False;
    MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);
    NempSkin.SetRegionsAgain;
    ReAcceptDragFiles;

    if NempTaskbarManager.Tag = 0 then
      ReInitTaskbarManager(False);
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
// gew�hlt wird, wird die Playlist f�r jede Datei neu gel�scht. das ist erstens nicht unbedingt
// sinnvoll, und zweitens kommt da irgendwas mit irgendwem durcheinander (die Anzahl der Dateien, die
// am Ende in der Playlist sind, ist irgendwie nicht vorhersehbar...???).
// So wird das L�schen der Playlist f�r einen gewissen Zeitraum verhindert, und alle markierten Dateien
// werden in die Playlist eingef�gt.
procedure TNemp_MainForm.ReallyDeletePlaylistTimerTimer(Sender: TObject);
begin
    NempPlaylist.ProcessBufferStringlist;
    ReallyDeletePlaylistTimer.Enabled := False;
end;


procedure TNemp_MainForm.PanelTagCloudBrowseClick(Sender: TObject);
var
  ac: TAudioFileCollection;
begin
    CloudViewer.FocussedTag := CloudViewer.MouseOverTag;
    ac := CloudViewer.FocussedCollection;
    if assigned(ac) then
      MedienBib.GenerateAnzeigeListe(ac);
end;

procedure TNemp_MainForm.DoExpandCloud(ac: TAudioFileCollection);
begin
  if assigned(ac) and ac.ExpandTagCloud then begin
    CloudViewer.Collection := ac;
    CloudViewer.PaintCloud;
    CloudViewer.FocussedTag := CloudViewer.GetFirstNewTag;
    MedienBib.GenerateAnzeigeListe(ac);
  end;
end;

(*procedure TNemp_MainForm.DoResetCloud(ac: TAudioFileCollection);
begin
  //if assigned(ac) then
//    DoExpandCloud(ac.Root);
end;*)

procedure TNemp_MainForm.PanelTagCloudBrowseDblClick(Sender: TObject);
begin
  CloudViewer.FocussedTag := CloudViewer.MouseOverTag;
  DoExpandCloud(CloudViewer.FocussedCollection);
end;


procedure TNemp_MainForm.PanelTagCloudBrowseMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   DateiListe: TAudioFileList;
begin
    if ssleft in shift then
    begin
      if (abs(X - TagCloudDownX) > 5) or  (abs(Y - TagCloudDownY) > 5) then
      begin
          Dateiliste := TAudioFileList.Create(False);
          try
              GenerateSortedListFromTagCloud(Dateiliste, false);
              InitiateDragDrop(DateiListe, PanelTagCloudBrowse, fDropManager, True, False); // AutoDecideExternalDrag ?
          finally
              FreeAndNil(Dateiliste);
          end;
      end;
    end
    else
    begin
      TagCloudDownX := 0;
      TagCloudDownY := 0;
      CloudViewer.MouseOverTag := CloudViewer.GetTagAtMousePos(x,y);
    end;
end;

procedure TNemp_MainForm.PanelTagCloudBrowsePaint(Sender: TObject);
begin
    exit;
    // MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);
end;

procedure TNemp_MainForm.PanelTagCloudBrowseResize(Sender: TObject);
begin
  if not FormReadyAndActivated then
    exit;
  CloudViewer.ResizePaint(''{MedienBib.TagCloud.CurrentTagList});
end;


procedure TNemp_MainForm.CloudTestKey(Sender: TObject; var Key: Char);
begin
  if ord(Key) = vk_return then
    DoExpandCloud(CloudViewer.FocussedCollection);
end;

procedure TNemp_MainForm.PM_ML_ResetTagCloudClick(Sender: TObject);
begin
  DoExpandCloud(CloudViewer.RootCollection);
end;

procedure TNemp_MainForm.CloudTestKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ac: TAudioFileCollection;
begin
    CloudViewer.NavigateCloud(Key, Shift);
    // NavigateCloud changes CloudViewer.FocussedCollection

    if (ssCtrl in Shift) and (key = $46) then
      edtCloudSearch.SetFocus;

    case key of
        vk_Escape,
        vk_Back: DoExpandCloud(CloudViewer.FocussedCollection);
    else
      begin
        ac := CloudViewer.FocussedCollection;
        if assigned(ac) then
          MedienBib.GenerateAnzeigeListe(ac);
      end;
    end;
end;

procedure TNemp_MainForm.CloudAfterPaint(Sender: TObject);
begin
    if Not NempSkin.isActive then
        CloudViewer.PaintAgain;
end;

procedure TNemp_MainForm.CloudPaint(Sender: TObject);
begin
  CloudViewer.PaintAgain;
end;

procedure TNemp_MainForm.OnGetCloudHint(Sender: TCloudView; ac: TAudioFileCollection; var HintText: String);
var
  Files: TAudioFileList;
  i, maxC: Integer;
begin
  if not assigned(ac) then begin
    HintText := '';
    exit;
  end;

  Files := TAudioFileList.Create(False);
  try
    HintText := '';
    ac.GetFiles(Files, False, False);
    if Files.Count > 0 then
      Hinttext := NempDisplay.PlaylistTitle(Files[0]);
    maxC := min(5, Files.Count);
    for i := 1 to maxC - 1 do
        Hinttext := Hinttext + #13#10 + NempDisplay.PlaylistTitle(Files[i]);
    if Files.Count > 5 then
      Hinttext := Hinttext + #13#10 + Format(TagCloud_MoreFiles, [Files.Count-5]);
  finally
    Files.Free;
  end;
end;

procedure TNemp_MainForm.PanelTagCloudBrowseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ac: TAudioFileCollection;
begin
    CloudViewer.SetFocus;
    TagCloudDownX := X;
    TagCloudDownY := Y;

    if Button = mbRight then begin
      CloudViewer.FocussedTag := CloudViewer.MouseOverTag;
      ac := CloudViewer.FocussedCollection;
      if assigned(ac) then
        MedienBib.GenerateAnzeigeListe(ac);
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
    else begin
      // Broadcast-Messages like WM_POWER and WM_DEVICECHANGE are sent to every window, i.e. to the MainForm as well.
      // We should not send this message to the current MainForm-Handle again
      case Msg.Msg of
        WM_POWERBROADCAST,
        WM_DEVICECHANGE: msg.Result := 0;
      else
        msg.Result := sendmessage(self.Handle, msg.Msg, msg.WParam, msg.LParam);
      end;
    end;
end;


procedure TNemp_MainForm.FormCreate(Sender: TObject);
begin
    FormReadyAndActivated := false;

    FOwnMessageHandler := AllocateHWND( OwnMessageProc );
    TagLabelList := TComponentList.Create(True);

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

    VolTimer := TTimer.Create(self);
    VolTimer.Enabled := False;
    VolTimer.Interval := 100;
    VolTimer.OnTimer := VolTimerTimer;

    RefreshVSTCoverTimer := TTimer.Create(self);
    RefreshVSTCoverTimer.Enabled := False;
    RefreshVSTCoverTimer.Interval := 1000;
    RefreshVSTCoverTimer.OnTimer := RefreshVSTCoverTimerTimer;

    RefreshVSTDetailsTimer := TTimer.Create(self);
    RefreshVSTDetailsTimer.Enabled := False;
    RefreshVSTDetailsTimer.Interval := 100;
    RefreshVSTDetailsTimer.OnTimer := RefreshVSTDetailsTimerTimer;

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

    //DragAcceptFiles (Handle, True);
    //DragAcceptFiles(_ControlPanel.Handle, True);

    OleInitialize(nil);
    fDropManager := TNempDragManager.Create(_ControlPanel);
    RegisterExpectedMemoryLeak(fDropManager);
    fDropManager.OnDragOver := OnNempDragover;
    fDropManager.OnDrop := OnNempDrop;


    // (bei ReAcceptDragFiles)
    // RegisterDragDrop(PlayerControlPanel.Handle, fDropManager as IDropTarget);

    // DragSource := DS_EXTERN;

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
    // "OnMinimize"-Event �ndern
    Application.OnMinimize    := MinimizeNemp;
    Application.OnDeactivate  := DeactivateNemp;

    WebRadioInsertMode := PLAYER_PLAY_DEFAULT;
    // MediaListPopupTag := 0;

    VST.NodeDataSize         := SizeOf(TAudioFile);
    ArtistsVST.NodeDataSize  := SizeOf(TAudioCollection);
    AlbenVST.NodeDataSize    := SizeOf(TLibraryCategory);
    PlaylistVST.NodeDataSize := SizeOf(TAudioFile);

    VST.EmptyListMessage := MainForm_LibraryIsEmpty;
    PlaylistVST.EmptyListMessage := MainForm_PlaylistIsEmpty;

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
        ListFiles := False;
        ListDirs := False;
        MHandle := FOwnMessageHandler;
        MCurrentDir := mkNoneMessage;
        MFound      := mkSendMessage;
    end;
    with ST_Playlist do
    begin
        ID      := ST_ID_Playlist;
        Recurse := True;
        ListFiles := False;
        ListDirs := False;
        MHandle := FOwnMessageHandler;
        MCurrentDir := mkNoneMessage;
        MFound      := mkSendMessage;
    end;

    // Get Savepath for settings and other data
    if UseUserAppData then
    begin
        // User DOES NOT want a portable storage of data - use the user directory
        SavePath := GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\';
        try
            ForceDirectories(SavePath);
        except
            SavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
        end;
    end else
    begin
        // User DOES want a portable/locale storage of configuration and data - use program directory
        SavePath := ExtractFilePath(ParamStr(0)) + 'Data\';
    end;

    TCoverArtSearcher.InitCoverArtCache(SavePath, 0);

    // Create additional controls
    CloudViewer           := TCloudView.Create(self);
    CloudViewer.Parent    := PanelTagCloudBrowse;
    CloudViewer.Name      := 'CloudViewer';
    CloudViewer.Align     := alClient;
    CloudViewer.TabStop   := True;
    CloudViewer.PopupMenu := Medialist_Collection_PopupMenu;
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
    CloudViewer.OnGetHint := OnGetCloudHint;
    CloudViewer.StyleElements := [];

    TabBtnTagCloudcategory.Parent := CloudViewer;
    TabBtnTagCloudcategory.Left := 2;
    TabBtnTagCloudcategory.Top := 2;

    //NewPlayerPanel.DoubleBuffered := True;

    // create and initialize FormBuilder

    NempLayout.ConstructionLayout := False;

    NempLayout.TreePanel       := TreePanel;
    NempLayout.CoverflowPanel  := CoverflowPanel;
    NempLayout.CloudPanel      := CloudPanel;
    NempLayout.PlaylistPanel   := PlaylistPanel;
    NempLayout.MedialistPanel  := MedialistPanel;
    NempLayout.DetailsPanel    := MedienBibDetailPanel;
    NempLayout.ControlsPanel   := _ControlPanel;
    NempLayout.MainContainer   := __MainContainerPanel;
    NempLayout.OnAfterBuild := AfterLayoutBuild;

    fCurrentlySelectedFile := TAudioFile.Create;
    fCurrentlySelectedFile.AudioType := at_File;
    // Create Player
    NempPlayer            := TNempPlayer.Create(FOwnMessageHandler);
    NempPlayer.Statusproc := StatusProc;
    NempPlayer.OnPlayerStopped := OnPlayerStopped;
    NempPlayer.OnMessage := OnPlayerMessage;

    // Create Playlist
    NempPlaylist        := TNempPlaylist.Create;
    NempPlaylist.Player := NempPlayer;
    NempPlaylist.MainWindowHandle := FOwnMessageHandler;
    NempPlaylist.OnCueChanged := PlaylistCueChanged;
    NempPlaylist.OnUserChangedTitle := PlaylistUserChangedTitle;
    NempPlaylist.OnBeforeDeleteAudiofile := PlaylistDeleteFile;
    NempPlaylist.OnAddAudioFile := PlaylistAddFile;
    NempPlaylist.OnFilePropertiesChanged := PlaylistFilePropertiesChanged;
    NempPlaylist.OnSearchResultsChanged := PlaylistSearchResultsChanged;
    NempPlaylist.OnPropertiesChanged := PlaylistPropertiesChanged;
    NempPlaylist.OnCueListFound := PlaylistCueListFound;
    NempPlaylist.OnPlaylistChangedCompletely := PlaylistChangedCompletely;
    NempPlaylist.OnPlaylistCleared := PlaylistCleared;
    NempPlaylist.OnFileMoved := PlaylistAudioFileMoved;

    NempPlaylist.PlaylistManager.SavePath := SavePath;
    ForceDirectories(IncludeTrailingPathDelimiter(SavePath) + 'Playlists\');
    NempPlaylist.PlaylistManager.OnReset := OnPlaylistManagerReset;
    NempPlaylist.PlaylistManager.OnRecentPlaylistChange    := OnRecentPlaylistsChange;
    NempPlaylist.PlaylistManager.OnFavouritePlaylistChange := OnFavouritePlaylistsChange;

    BibRatingHelper := TRatingHelper.Create;

    // Create Medialibrary
    MedienBib := TMedienBibliothek.Create(FOwnMessageHandler, PanelCoverBrowse.Handle);
    MedienBib.BibScrobbler := NempPlayer.NempScrobbler;
    //MedienBib.TagCloud.Canvas := CloudViewer.Canvas;
    MedienBib.SavePath := SavePath;

    CoverDownloadThread := TCoverDownloadWorkerThread.Create;
    CoverDownloadThread.OnDownloadComplete := OnCoverDownloadComplete;
    CoverDownloadThread.OnDownloadSaved := OnDownloadSaved;

    // needed for ClassicFlow
    MedienBib.NewCoverFlow.MainImage := IMGMedienBibCover;
    MedienBib.NewCoverFlow.ScrollImage := ImgScrollCover;
    // Needed for FlyingCow
    MedienBib.NewCoverFlow.Window := PanelCoverBrowse.Handle ;
    MedienBib.NewCoverFlow.events_window := FOwnMessageHandler;

    MedienBib.NewCoverFlow.DownloadThread := CoverDownloadThread;



    // Create Skin-System
    NempSkin := TNempSkin.create;
    PlayListSkinImageList := TImageList.Create(Nemp_MainForm);
    PlayListSkinImageList.Height := 14;
    PlayListSkinImageList.Width := 14;

    MenuSkinImageList := TImageList.Create(Nemp_MainForm);
    MenuSkinImageList.Height := 16;
    MenuSkinImageList.Width := 16;

    //NempSkin.FormBuilder := NempFormBuildOptions;
    NempSkin.FormLayout := NempLayout;

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

    InitTaskBarIcons;

    // Create Updater
    NempUpdater := TNempUpdater.Create(FOwnMessageHandler);

    // create WebServer
    NempWebServer := TNempWebServer.Create(FOwnMessageHandler);
    NempWebServer.SavePath := SavePath;

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

    MostRecentInsertNodeForPlaylist := Nil;
end;

procedure TNemp_MainForm.FormDeactivate(Sender: TObject);
begin
    //DragSource := DS_Extern;
end;

procedure TNemp_MainForm.FormShow(Sender: TObject);
begin
  // StuffToDoAfterCreate;
  // Nothing to do here. Will be done in nemp.dpr
  if assigned(FSplash) then
      FSplash.Close;
end;

procedure TNemp_MainForm.InitTaskBarIcons;
var aIcon: TIcon;
begin
  aIcon := TIcon.Create;
  try
    TaskBarImages.GetIcon(0, aIcon); // prev
    NemptaskbarManager.TaskBarButtons[0].Icon.Assign(aIcon);

    if NempPlayer.BassStatus = BASS_ACTIVE_PLAYING then
      TaskBarImages.GetIcon(2, aIcon) // play/pause
    else
      TaskBarImages.GetIcon(1, aIcon); // play/pause

    NemptaskbarManager.TaskBarButtons[1].Icon.Assign(aIcon);

    TaskBarImages.GetIcon(3, aIcon); // next
    NemptaskbarManager.TaskBarButtons[2].Icon.Assign(aIcon);

    TaskBarImages.GetIcon(6, aIcon); // menu
    NemptaskbarManager.TaskBarButtons[3].Icon.Assign(aIcon);

    TaskBarImages.GetIcon(4, aIcon); //vol down
    NemptaskbarManager.TaskBarButtons[4].Icon.Assign(aIcon);

    TaskBarImages.GetIcon(5, aIcon); // vol up
    NemptaskbarManager.TaskBarButtons[5].Icon.Assign(aIcon);

    NemptaskbarManager.ApplyButtonsChanges;
  finally
    aIcon.Free;
  end;
end;

procedure TNemp_MainForm.ReInitTaskbarManager(TryAgainOnException: Boolean);
var progressValue: Int64;
    progressState: TTaskbarProgressState;
    i: Integer;
begin

  Application.ProcessMessages;
  try
      progressState := NempTaskbarManager.ProgressState;
      progressValue := NempTaskbarManager.ProgressValue;
      NempTaskbarManager.Free;

      NempTaskbarManager := TTaskBar.Create(self);
      NempTaskbarManager.TabProperties := [TThumbTabProperty.CustomizedPreview];

      for i := 1 to 6 do
        NempTaskbarManager.TaskBarButtons.Add;
      NempTaskbarManager.TaskBarButtons[3].ButtonState := [TThumbButtonState.Enabled, TThumbButtonState.NoBackGround];

      NempTaskbarManager.OnThumbButtonClick := fspTaskbarManagerThumbButtonClick;
      NempTaskbarManager.OnThumbPreviewRequest := NempTaskbarManagerThumbPreviewRequest;

      NempTaskbarManager.ProgressMaxValue := 100;
      NempTaskbarManager.ProgressValue := progressValue;
      NempTaskbarManager.ProgressState := progressState;
      //if self.Visible then
        NempTaskbarManager.Initialize;

      //if self.Visible then
        InitTaskBarIcons;

      NempTaskbarManager.Tag := 1; // successfully initiated
  except
    if TryAgainOnException then
      CorrectSkinRegionsTimer.Enabled := True;
  end;

end;



procedure TNemp_MainForm.CatchAllExceptionsOnShutDown(Sender: TObject; E: Exception);
begin
    Application.Terminate;
end;

procedure TNemp_MainForm.TntFormClose(Sender: TObject; var Action: TCloseAction);
var PosAndSize : PWindowPlacement;
begin
    NempIsClosing := True;
    //PauseMadExcept(True);
    try
        Application.OnException := CatchAllExceptionsOnShutDown;

        NempTrayIcon.Visible := False;

        NempOptions.UnInstallHotKeys;
        NempOptions.UninstallMediakeyHotkeys;

        NempWebServer.Free;

        AcceptApiCommands := False;
        RefreshAuswahlStatusLBL(MainForm_ShuttingDownHint);
        //AuswahlStatusLBL.Caption := (MainForm_ShuttingDownHint);
        //AuswahlStatusLBL.Update;

        GetMem(PosAndSize,SizeOf(TWindowPlacement));
        try
          PosAndSize^.Length := SizeOf(TWindowPlacement);
          if GetWindowPlacement(Handle,PosAndSize) then
          begin
              if Tag = 0 then
              begin
                  // one Window
                  NempOptions.FormPositions[nfMain].Width := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
                  NempOptions.FormPositions[nfMain].Height := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
                  NempOptions.FormPositions[nfMain].Top := PosAndSize^.rcNormalPosition.Top;
                  NempOptions.FormPositions[nfMain].Left := PosAndSize^.rcNormalPosition.Left;
              end else
              begin
                  // seperate Windows
                  NempOptions.FormPositions[nfMainMini].Width := PosAndSize^.rcNormalPosition.Right - PosAndSize^.rcNormalPosition.Left;
                  NempOptions.FormPositions[nfMainMini].Height := PosAndSize^.rcNormalPosition.Bottom - PosAndSize^.rcNormalPosition.Top;
                  NempOptions.FormPositions[nfMainMini].Top := PosAndSize^.rcNormalPosition.Top;
                  NempOptions.FormPositions[nfMainMini].Left := PosAndSize^.rcNormalPosition.Left;
              end;
          end;
        finally
          FreeMem(PosAndSize,SizeOf(TWindowPlacement))
        end;
        NempOptions.MainFormMaximized := WindowState = wsMaximized;

        NempOptions.SaveSettings;
        // NempFormBuildOptions.SaveSettings;
        NempLayout.SaveSettings(NempOptions.AnzeigeMode = 0);

        if NempOptions.AnzeigeMode = 1 then begin
          AuswahlForm.SaveWindowPosition;
          ExtendedControlForm.SaveWindowPosition;
          MedienlisteForm.SaveWindowPosition;
          PlaylistForm.SaveWindowPosition;
        end;
        self.SaveWindowPosition(NempOptions.AnzeigeMode);

        TDrivemanager.SaveSettings;
        NempDisplay.SaveSettings;

        NempPlayer.SaveSettings;
        NempPlaylist.SaveSettings;
        MedienBib.SaveSettings;
        NempUpdater.SaveSettings;

        NempSkin.NempPartyMode.SaveSettings;

        VSTColumns_SaveSettings(VST);

        NempSettingsManager.LastExitOK := True;
        // finally save settings into the file on the disk
        NempSettingsManager.WriteToDisk;

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

        if MedienBib.AutoSaveMediaList AND {(MedienBib.Count > 0) AND} (MedienBib.Changed) then
        begin
            RefreshAuswahlStatusLBL(MainForm_ShuttingDownHint_MediaLib);
            MedienBib.SaveToFile(SavePath + NEMP_NAME + '.gmp', True);
        end;

        CoverScrollbar.WindowProc := OldScrollbarWindowProc;
        LyricsMemo.WindowProc := OldLyricMemoWindowProc;

        ST_Playlist.Free;
        ST_Medienliste.Free;
        TagLabelList.Clear;

        FreeAndNil(NempLayout);


        fCurrentlySelectedFile.Free;
        Spectrum.Free;
        NempSkin.Free;
        NempPlaylist.Free;
        NempPlayer.Free;
        MedienBib.NewCoverFlow.DownloadThread := Nil;
        CoverDownloadThread.Terminate;
        CoverDownloadThread.WaitFor;
        CoverDownloadThread.Free;
        MedienBib.Free;
        BibRatingHelper.Free;
        LanguageList.Free;
        NempUpdater.Free;
        FreeAndNil(ErrorLog);



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

procedure TNemp_MainForm.OnCoverDownloadComplete(DownloadItem: TCoverDownloadItem; Bitmap: TBitmap);

  function DownloadItemStillMatchesCoverFlow: Boolean;
  var
    aCollection: TAudioFileCollection;
  begin
      if DownloadItem.Index <= MedienBib.NewCoverFlow.CoverCount - 1 then
      begin
          aCollection := TAudioFileCollection(MedienBib.NewCoverFlow.Collection[DownloadItem.Index]);
          result := (aCollection.Artist = DownloadItem.Artist)
                    and (aCollection.Album = DownloadItem.Album);
      end else
          result := False;
  end;

  function DownloadItemStillMatchesPlayer: Boolean;
  begin
      if (DownloadItem.SubQueryType = sqtFile) then
          result := assigned(NempPlayer.MainAudioFile)
              and
              (IncludeTrailingPathDelimiter(NempPlayer.MainAudioFile.Ordner)
               = IncludeTrailingPathDelimiter(DownloadItem.Directory))
      else
          result := assigned(NempPlayer.MainAudioFile)
              and (CddbIDFromCDDA(NempPlayer.MainAudioFile.Pfad) = DownloadItem.FileType)
  end;


begin
  case DownloadItem.QueryType of
          qtPlayer: begin
            if DownloadItemStillMatchesPlayer then
            begin
                NempPlayer.MainPlayerPicture.Assign(Bitmap);
                Nemp_MainForm.CoverImage.Picture.Assign(NempPlayer.MainPlayerPicture);
                Nemp_MainForm.CoverImage.Hint := DownloadItem.Status;
            end;
          end;

          qtCoverFlow: begin
            if DownloadItemStillMatchesCoverFlow then
            begin
                Medienbib.NewCoverFlow.SetPreview (DownloadItem.Index, Bitmap.Width, Bitmap.Height, Bitmap.Scanline[Bitmap.Height-1]);
                MedienBib.NewCoverFlow.Paint(1);
            end;
          end;

          qtTreeView: begin
            // nothing todo. Refreshing the Cover will be done after the file was saved, without an overlay-icon
          end;
        end;
end;
procedure TNemp_MainForm.OnDownloadSaved(DownloadItem: TCoverDownloadItem);
var
  ArchivedCollection: TAudioCollection;
  newID: String;
begin
  NewID := Medienbib.CoverArtSearcher.InitCoverFromFilename(DownloadItem.newFilename, tm_VCL);
  ArchivedCollection := CoverDownloadThread.GetArchivedCollection(DownloadItem.ArchiveID);
  if assigned(ArchivedCollection) and (newID <> '')then
    ArchivedCollection.ApplyNewCoverID(newID);

  MedienBib.Changed := True;
  if (MedienBib.BrowseMode = 0) and (DownloadItem.QueryType = qtTreeView) then
    Nemp_MainForm.AlbenVST.Invalidate;
end;


procedure TNemp_MainForm.NewSelected (Var Msg: TMessage);
var
  aIndex: Integer;
  aCollection: TAudioCollection;
begin
    if (MedienBib.BrowseMode <> 1) or (not NempLayout.ShowBibSelection) then
      exit;

    CoverScrollBar.OnChange := Nil;
    aIndex := Integer(Msg.WParam);
    if CoverScrollbar.Position <> aIndex then
    begin
        CoverScrollbar.Position := aIndex;
        if CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1 then
        begin
          aCollection := MedienBib.NewCoverFlow.Collection[aIndex];
          MedienBib.GenerateAnzeigeListe(aCollection);
          Lbl_CoverFlow.Caption := aCollection.Caption;
        end;
    end else
    begin
        if CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1 then
        begin
          aCollection := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
          Lbl_CoverFlow.Caption := aCollection.Caption;
        end;
    end;
    CoverScrollbar.OnChange := CoverScrollbarChange;
end;


procedure TNemp_MainForm.FCtest(var msg : TMessage);
begin
    Caption := IntTostr(Cardinal(msg.WParam)) + ' - ' + IntTostr(Integer(msg.LParam));
end;

procedure TNemp_MainForm.NeedPreviewMainPicker(aRootCollection: TRootCollection);
var
  bmp: TBitmap;
begin
  if NempIsClosing then
    exit;

  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf24bit;
    MedienBib.CoverArtSearcher.PaintMainPickCover(bmp, aRootCollection);
    Medienbib.NewCoverFlow.SetMainPickCoverPreview( bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);
  finally
    bmp.Free;
  end;
end;

procedure TNemp_MainForm.NeedPreview (var msg : TWMFCNeedPreview);
var
  bmp: TBitmap;
  pic: TPicture;
  success: Boolean;
  newID: String;
  aCollection: TAudioCollection;

begin
  if NempIsClosing then exit;
  if MedienBib.BrowseMode <> 1 then exit;
  if (not NempLayout.ShowBibSelection) then exit;

  pic := TPicture.Create;
  bmp := TBitmap.Create;
  try
      bmp.PixelFormat := pf24bit;

      if MedienBib.NewCoverFlow.CoverCount > msg.index then
      begin
          aCollection := MedienBib.NewCoverFlow.Collection[msg.Index];

          case MedienBib.NewCoverFlow.Mode of
              cm_Classic: success := False; // we already failed during the painting process
              cm_OpenGL : begin
                  // if (aCover.ID = 'all') or (aCover.ID = 'searchresult') then
                  if aCollection is TRootCollection then
                    NeedPreviewMainPicker(TRootCollection(aCollection));
                  success := MedienBib.CoverArtSearcher.GetCoverBitmapFromCollection(aCollection, pic);
              end
          else
              success := True; // we are not in CoverflowMode at all, should not happen
          end;

          if (not success) and PreviewGraphicShouldExist(aCollection.CoverID) then
          begin
              // file \coverSavepath\<id>.jpg is missing, even if it should exist (= it was manually deleted?)
              // try to recreate it from the image files already existing on the disc/id3Tag
              success := RepairCoverFileVCL(aCollection.CoverID, Nil, pic, newID);
              if success and (aCollection.CoverID <> newID) then
                aCollection.ApplyNewCoverID(newID);
          end;

          bmp.Height := TCoverArtSearcher.CoverSize;
          bmp.Width := TCoverArtSearcher.CoverSize;
          FitBitmapIn(bmp, pic.Graphic);

          Medienbib.NewCoverFlow.SetPreview (msg.Index, bmp.Width, bmp.Height, bmp.Scanline[bmp.Height-1]);

          if (not success) and (MedienBib.CoverSearchLastFM) then
            CoverDownloadThread.AddJob(aCollection, msg.index, qtCoverFlow);
      end;
  finally
      pic.free;
      bmp.Free;
  end;
end;


procedure TNemp_MainForm.MinimizeNemp(Sender: TObject);
begin
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
    (*Procedure ShowApplication;
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
    End;*)
begin

  //if NempOptions.NempWindowView = NEMPWINDOW_TASKBAR_MIN_TRAY then
  //    NempTrayIcon.Visible := False;
  //Show;
  ///02.2017
  //ShowWindow(Application.Handle, SW_RESTORE);

  ShowWindow(Nemp_MainForm.Handle, SW_RESTORE);
  ///02.2017
  SetForegroundWindow(Nemp_MainForm.Handle);

  RepairZOrder;

  MinimizedIndicator := False;

  //if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
  //    ShowWindow( Application.Handle, SW_HIDE );


  ///02.2017
  // ShowApplication;
  ///02.2017

  // Show;

  // if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
  //    ShowWindow( Application.Handle, SW_HIDE );


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
  // �ber die Commandline kommen nur SAchen f�r die Playlist
  // Zumindest bisher (2.5d, f�r die n�chste Version ist auch nichts anderes geplant)
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
          if NempPlaylist.PlaylistManager.PreparePlaylistLoading(
                      -2,
                      NempPlaylist.Playlist,
                      NempPlaylist.PlayingIndex,
                      Round(NempPlaylist.PlayingTrackPos) )
          then
          begin
              NempPlaylist.PlaylistManager.Reset;
              NempPlaylist.ClearPlaylist;
          end else
              exit;
      end;
      NempPlaylist.Status := 1;
      NempPlaylist.ResetInsertIndex;
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
                // change (bugfix?) in version 4.14
                // if multiple playlists are selected for "Play in Nemp": Play only one. Which one doesn't really matter
                if not enqueue then
                begin
                    if NempPlaylist.PlaylistManager.PreparePlaylistLoading(
                        -2,
                        NempPlaylist.Playlist,
                        NempPlaylist.PlayingIndex,
                        Round(NempPlaylist.PlayingTrackPos) )
                    then
                    begin
                        NempPlaylist.PlaylistManager.Reset;
                        NempPlaylist.ClearPlaylist;
                    end else
                        exit;
                end;
                NempPlaylist.LoadFromFile(filename);
                if Startplay then
                begin
                  NempPlaylist.InitPlayingFile;
                end;
            end
            else
                if (AnsiLowerCase(ExtractFileExt(filename))='.cue') then
                begin
                  NempPlaylist.LoadCueSheet(filename);
                  if Startplay then
                  begin
                      NempPlaylist.InitPlayingFile;
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
      //NempPlaylist.GetInsertNodeFromPlayPosition
      NempPlaylist.InitInsertIndexFromPlayPosition(True)
  else
      //NempPlaylist.InsertNode := NIL;
      NempPlaylist.ResetInsertIndex;

  NempPlaylist.InsertFileToPlayList(filename);

  if (Mode in [PLAYER_PLAY_NOW, PLAYER_PLAY_FILES]) AND (NempPlaylist.Count > NempPlaylist.InsertIndex-1) then
  begin
      NempPlayer.LastUserWish := USER_WANT_PLAY;
      NempPlaylist.Play(NempPlaylist.InsertIndex-1, 0, True);
  end;
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
          NEMP_BUTTON_PLAY      : TogglePlayPause(aMSg.LParam <> WM_WebServer); //PlayPauseBTNIMGClick(Nil);
          NEMP_BUTTON_PAUSE     : TogglePlayPause(aMSg.LParam <> WM_WebServer); //PlayPauseBTNIMGClick(Nil);
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
    NempOptions.GlobalUseAdvancedSkin := NOT NempOptions.GlobalUseAdvancedSkin;

    MM_O_Skin_UseAdvanced.Checked := NempOptions.GlobalUseAdvancedSkin;
    PM_P_Skin_UseAdvancedSkin.Checked := NempOptions.GlobalUseAdvancedSkin;

    {$IFDEF USESTYLES}
    // deactivate it immediately
    if Not NempOptions.GlobalUseAdvancedSkin then
    begin
        TStyleManager.SetStyle('Windows');
        ReInitTaskbarManager(True);
        if NempOptions.UseSkin then
        begin
            if NOT NempSkin.UseDefaultMenuImages then
                NempSkin.SetDefaultMenuImages;
            NempSkin.SetVSTHeaderSettings;
        end;
         CorrectSkinRegionsTimer.Enabled := True;
    end else
    begin
        // refresh skin, if a skin is used, and it supports advanced skinning
        if NempOptions.UseSkin then
        begin
            if NempSkin.UseAdvancedSkin then
                ActivateSkin(GetSkinDirFromSkinName(NempOptions.SkinName))
            else
                TranslateMessageDLG((AdvancedSkinActivateHint), mtInformation, [MBOK], 0);
        end;
    end;
    //UpdateFormDesignNeu;     ??? 08.2018 warum war das hier???

    if assigned(FDetails) then
        FDetails.RefreshStarGraphics;

    if assigned(RandomPlaylistForm) then
        RandomPlaylistForm.RefreshStarGraphics;

    if assigned(OptionsCompleteForm) then
      OptionsCompleteForm.RefreshStarGraphics;

    {$ENDIF}
end;

procedure TNemp_MainForm.RefreshStarGraphicsAllForms;
begin
  if assigned(FDetails) then
    FDetails.RefreshStarGraphics;
  if assigned(RandomPlaylistForm) then
    RandomPlaylistForm.RefreshStarGraphics;
  if assigned(OptionsCompleteForm) then
    OptionsCompleteForm.RefreshStarGraphics;
  if assigned(FormPlaylistDuplicates) then
    FormPlaylistDuplicates.RefreshStarGraphics
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
  NempOptions.UseSkin := False;
  // RePaintPanels;
  RepaintOtherForms;
  RepaintAll;
end;


// Ein paar Routinen, die das Skinnen erleichtren
procedure TNemp_MainForm.Skinan1Click(Sender: TObject);
begin
  NempOptions.UseSkin := True;
  NempOptions.SkinName := StringReplace((Sender as TMenuItem).Caption,'&&','&',[rfReplaceAll]);
  ActivateSkin(GetSkinDirFromSkinName(NempOptions.SkinName));
  SetSkinRadioBox(NempOptions.SkinName);
 // CorrectSkinRegionsTimer.Enabled := True;
end;



procedure TNemp_MainForm.TabBtn_FavoritesClick(Sender: TObject);
var pt: TPoint;
begin
  pt := TabBtn_Favorites.ClientToScreen(Point(0,0));
  PlaylistManagerPopup.Popup(pt.X, pt.Y + TabBtn_Favorites.Height);
end;

function TNemp_MainForm.GetFocussedAudioFile:TAudioFile;
var  OldNode: PVirtualNode;
begin
    OldNode := VST.FocusedNode;
    if assigned(OldNode) then
        result :=  VST.GetNodeData<TAudioFile>(OldNode)
    else
      result := NIL;
end;

procedure TNemp_MainForm.GRPBOXArtistsAlbenResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;
    if NempLayout_Ready then
      NempLayout.ResizeSubPanel(TreePanel, ArtistsVST, NempLayout.TreeViewRatio);
end;

procedure TNemp_MainForm.EmptyLibraryPanelResize(Sender: TObject);
begin
  LblEmptyLibraryHint.Width := (EmptyLibraryPanel.Width - 50);
  LblEmptyLibraryHint.Left := 25;
  LblEmptyLibraryHint.Top := (EmptyLibraryPanel.Height - LblEmptyLibraryHint.Height) Div 2;
end;

procedure TNemp_MainForm.EmptyLibraryPanelPaint(Sender: TObject);
begin
  NempSkin.DrawArtistAlbumPanel((Sender as TNempPanel), MedienBib.Count, NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

Procedure TNemp_MainForm.AnzeigeSortMENUClick(Sender: TObject);
var oldAudioFile: TAudioFile;
begin
  if MedienBib.StatusBibUpdate >= 2 then exit;
  if Not (Sender is TMenuItem) then exit;

  oldAudioFile := GetFocussedAudioFile;
  VST.Enabled := False;

  case (Sender as TMenuItem).Tag of
      colIdx_ARTIST: begin
          MedienBib.AddSorter(colIdx_TITLE, False);
          MedienBib.AddSorter(colIdx_ARTIST);
      end;
      colIdx_EX_ARTISTALBUMTITEL: begin
          MedienBib.AddSorter(colIdx_TITLE, False);
          MedienBib.AddSorter(colIdx_ALBUM);
          MedienBib.AddSorter(colIdx_ARTIST);
      end;
      colIdx_TITLE: begin
          MedienBib.AddSorter(colIdx_ARTIST, False);
          MedienBib.AddSorter(colIdx_TITLE);
      end;
      colIdx_ALBUM: begin
          MedienBib.AddSorter(colIdx_ALBUM, False);
          MedienBib.AddSorter(colIdx_ARTIST);
          MedienBib.AddSorter(colIdx_TITLE);
      end;
      colIdx_EX_ALBUMTITELARTIST: begin
          MedienBib.AddSorter(colIdx_ARTIST, False);
          MedienBib.AddSorter(colIdx_TITLE);
          MedienBib.AddSorter(colIdx_ALBUM);
      end;
      colIdx_EX_ALBUMTRACK: begin
          MedienBib.AddSorter(colIdx_TRACK, False);
          MedienBib.AddSorter(colIdx_ALBUM);
      end;
      colIdx_Filename: MedienBib.AddSorter(colIdx_Filename, False);
      colIdx_Path: MedienBib.AddSorter(colIdx_Path, False);
      colIdx_Lyrics: MedienBib.AddSorter(colIdx_Lyrics, False);
      colIdx_EXTENSION : MedienBib.AddSorter(colIdx_EXTENSION, False);
      colIdx_GENRE: MedienBib.AddSorter(colIdx_GENRE, False);
      colIdx_Duration: MedienBib.AddSorter(colIdx_Duration, False);
      colIdx_FILESIZE: MedienBib.AddSorter(colIdx_FILESIZE, False);
      colIdx_LastFMTags: MedienBib.AddSorter(colIdx_LastFMTags, False);
      colIdx_TRACKGAIN: MedienBib.AddSorter(colIdx_TRACKGAIN, False);
      colIdx_ALBUMGAIN: MedienBib.AddSorter(colIdx_ALBUMGAIN, False);
      colIdx_BPM: MedienBib.AddSorter(colIdx_BPM, False);
      colIdx_HARMONICKEY: MedienBib.AddSorter(colIdx_HARMONICKEY, False);
  end;

  MedienBib.SortAnzeigeListe;

  // Anzeige im VST aktualisieren
  VST.Header.SortColumn := MedienBib.Sortparams[0].Tag;
  case MedienBib.Sortparams[0].Direction of
      sd_Ascending  : VST.Header.SortDirection := sdAscending  ;
      sd_Descending : VST.Header.SortDirection := sdDescending ;
  end;

  FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);

  VST.Enabled := True;
end;

procedure TNemp_MainForm.MM_ML_SortAscendingClick(Sender: TObject);
var
  oldAudioFile: TAudioFile;
  sndTag: Integer;
begin
  oldAudioFile := GetFocussedAudioFile;

  //(Sender as TMenuItem).Checked := True;
  //das checked im OnPopup machen. das dan auch f�r die Sortiermodi  - dabie ggf. auf  Sortparams[0 - 1 - 2- 3 ]  �berpr�fen

  sndTag := (Sender as TMenuItem).Tag;
  MedienBib.ChangeSortDirection(teSortDirection(sndTag));
  VST.Header.SortDirection := VirtualTrees.TSortDirection(sndTag);

  MedienBib.SortAnzeigeListe;
  FillTreeView(MedienBib.AnzeigeListe, oldAudioFile);
end;

procedure TNemp_MainForm.PM_ML_HideSelectedClick(Sender: TObject);
var i:integer;
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
            MedienBib.AnzeigeListe.Extract(VST.GetNodeData<TAudioFile>(SelectedMp3s[i]));
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
    SelectedPlaylistCollection: TAudioPlaylistCollection;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;

    if MedienBib.CurrentCategory.CategoryType = ccPlaylists then begin
      FocussedAlbumNode := AlbenVST.FocusedNode;
      if assigned(FocussedAlbumNode) then
      begin
        NewSelectNode := AlbenVST.GetNextSibling(FocussedAlbumNode);
        if not Assigned(NewSelectNode) then
          NewSelectNode := AlbenVST.GetPreviousSibling(FocussedAlbumNode);

        SelectedPlaylistCollection := TAudioPlaylistCollection(AlbenVST.GetNodeData<TAudioCollection>(FocussedAlbumNode));
        AlbenVST.DeleteNode(FocussedAlbumNode);
        Medienbib.DeletePlaylist(SelectedPlaylistCollection.LibraryPlaylist);
        // remove empty collections, refresh view
        // note: even if this method is only used in Tree-Mode, it is safer that way ...
        MedienBib.RefreshCollections;

        if assigned(NewSelectNode) then
        begin
          AlbenVST.Selected[NewSelectNode] := True;
          AlbenVST.FocusedNode := NewSelectNode;
        end;
        AlbenVST.Invalidate;
      end;
    end;
end;

procedure TNemp_MainForm.PM_ML_DeleteSelectedClick(Sender: TObject);
var i, iGes: Integer;
    SelectedMp3s: TNodeArray;
    // FileList: TAudioFileList;
    af: TAudioFile;
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

    MedienBib.StatusBibUpdate := BIB_Status_ReadAccessBlocked;
    BlockGUI(3);
    KeepOnWithLibraryProcess := true;   // ok, apm is used

    ProgressFormLibrary.AutoClose := True;
    ProgressFormLibrary.InitiateProcess(True, pa_DeleteFiles);

    // Hier wird komplett gel�scht.
    // d.h.: aus der Medienliste entfernen und aus alle anderen Listen
    ct := GetTickCount;
    begin
        // in allen Listen l�schen und MP3-File entfernen
        VST.BeginUpdate;
            iGes := Length(SelectedMP3s);
            for i := 0 to Length(SelectedMP3s) - 1 do
            begin
                af := VST.GetNodeData<TAudioFile>(SelectedMP3s[i]);
                VST.DeleteNode(SelectedMP3s[i]);
                MedienBib.DeleteAudioFile(af);
                nt := GetTickCount;
                if (nt > ct + 10) or (nt < ct) then
                begin
                    ct := nt;
                    ProgressFormLibrary.LblSuccessCount.Caption := IntToStr(i);
                    ProgressFormLibrary.MainProgressBar.Position := Round(i/iGes * 100);
                    ProgressFormLibrary.Update;
                    Application.ProcessMessages;
                    if not KeepOnWithLibraryProcess then break;
                end;
            end;
        VST.EndUpdate;
    end;
    ProgressFormLibrary.MainProgressBar.Position := 100;

    if KeepOnWithLibraryProcess then
        ProgressFormLibrary.LblMain.Caption := DeleteSelect_DeletingFilesComplete
    else
        // user aborted the operation
        ProgressFormLibrary.LblMain.Caption := MediaLibrary_OperationCancelled;

    ProgressFormLibrary.lblCurrentItem.Caption := '';
    ProgressFormLibrary.FinishProcess(jt_WorkingLibrary);

    // Refresh Collections and the view
    MedienBib.RefreshCollections;

    MedienBib.BuildTotalString;
    MedienBib.BuildTotalLyricString;

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
        RefreshAuswahlStatusLBL('');
        // AuswahlStatusLBL.Caption := '';
        Caption:= Nemp_Caption;
        ResetBrowsePanels;
    end;
end;

procedure TNemp_MainForm.MM_ML_SearchClick(Sender: TObject);
begin
    if not assigned(FormBibSearch) then
        Application.CreateForm(TFormBibSearch, FormBibSearch);
    FormBibSearch.Show;
end;

procedure TNemp_MainForm.SearchDirectoryForNewFiles(TargetCategory: TLibraryCategory);
var
  newdir: UnicodeString;
  OpenDlg: TFileOpenDialog;
begin
  MedienBib.InitTargetCategory(TargetCategory);
  if MedienBib.InitialDialogFolder = ''  then
      MedienBib.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);

  ST_Medienliste.Mask := GenerateMedienBibSTFilter;
  OpenDlg :=  TFileOpenDialog.Create(self);
  try
    OpenDlg.Options := OpenDlg.Options + [fdoPickFolders];
    OpenDlg.DefaultFolder := MedienBib.InitialDialogFolder;
    if OpenDlg.Execute then begin
      newDir := OpenDlg.FileName;
      MedienBib.InitialDialogFolder := OpenDlg.FileName;
      MedienBib.ST_Ordnerlist.Add(newdir);
      // DateiSuche starten
      if (Not ST_Medienliste.IsSearching) then begin
        PutDirListInAutoScanList(MedienBib.ST_Ordnerlist);
        MedienBib.StatusBibUpdate := 1;
        BlockGUI(1);
        StartMediaLibraryFileSearch;
      end;
    end;
  finally
    OpenDlg.Free
  end;
end;

procedure TNemp_MainForm.MM_ML_SearchDirectoryClick(Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  SearchDirectoryForNewFiles(Nil);
end;

procedure TNemp_MainForm.MM_ML_SearchDirectoryCurrentCategoryClick(
  Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if MedienBib.StatusBibUpdate <> 0 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  SearchDirectoryForNewFiles(MedienBib.CurrentCategory)
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
procedure TNemp_MainForm.HandleFiles(aList: TAudioFileList; how: integer);
var i:integer;
    Abspielen: Boolean;
    imax: integer;
    FirstNewNode: PvirtualNode;
begin

    if aList.Count = 0 then exit;

    aList[0].ReCheckExistence;

    if How = PLAYER_PLAY_FILES then // erst PlayList l�schen
        NempPlaylist.ClearPlaylist;

    // Check, whether the player is currently playing
    // or the user selected "play now"
    Abspielen := ((NempPlaylist.Count = 0) and (NempPlayer.MainStream = 0)) OR (How = PLAYER_PLAY_FILES);

    if How in [{PLAYER_PLAY_NOW, }PLAYER_PLAY_NEXT] then
        NempPlaylist.InitInsertIndexFromPlayPosition(True)
    else
        NempPlaylist.ResetInsertIndex;

    // Erste Datei einf�gen und ggf. Abspielen
    NempPlaylist.InsertFileToPlayList(aList[0]);
    FirstNewNode := GetNodeWithAudioFile(PlaylistVST, aList[0]);
    if assigned(FirstNewNode) then
        PlayListVST.ScrollIntoView(FirstNewNode, False);

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
    for i := 1 to iMax do
    begin
          if ContinueWithPlaylistAdding then
              NempPlaylist.InsertFileToPlayList(aList[i])
          else
              // free the remaining Audiofiles. They are not needed any more
              aList[i].Free;

          if (i Mod 100 = 0) and ContinueWithPlaylistAdding then
              Application.ProcessMessages;
    end;
    ContinueWithPlaylistAdding := False;
end;

{
    --------------------------
    GenerateLists ...
    --------------------------
    Parameter CreateFileCopies:
      True: Create Copies of the selected files to add them into the Playlist
      False: Just add the original FileObjects into the destination-list (e.g. temporary lists to initiate Drag&Drop)
}

function TNemp_MainForm.GetSelectedCollectionFromMainWindow: TAudioCollection;
var
  FocusNode: PVirtualNode;
begin
  result := Nil;

  case MedienBib.BrowseMode of
    0: begin
        FocusNode := AlbenVST.FocusedNode;
        if assigned(FocusNode) then
          result := AlbenVST.GetNodeData<TAudioCollection>(FocusNode);
    end;
    1: begin
        if CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1 then
          result := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
    end;
    2: begin
      result := CloudViewer.FocussedCollection;
    end;
  end;

end;

procedure TNemp_MainForm.GenerateSortedListFromCollection(source: TAudioCollection; dest: TAudioFileList; CreateFileCopies: Boolean);
var
  tmpList: TAudioFileList;
  i: Integer;
begin
  if not CreateFileCopies then begin
    // just get the files from the collection
    source.GetFiles(dest, true);
    // Dont sort really long lists, and DO NOT sort files from a Playlist-Collection
    if (dest.Count <= 5000) and (source.CollectionClass = ccFiles) then
      dest.Sort(Sort_AlbumTrack_asc);
  end else
  begin
    // get the files from the collection and create copies of these files
    tmpList := TAudioFileList.Create(False);
    try
      source.GetFiles(tmpList, true);
      if (tmpList.Count <= 5000) and (source.CollectionClass = ccFiles) then
        tmpList.Sort(Sort_AlbumTrack_asc);
      for i := 0 to tmpList.Count - 1 do
        tmpList[i].AddCopyToList(dest);
    finally
      tmpList.Free;
    end;
  end;
end;


function TNemp_MainForm.GenerateSortedListFromCollectionTree(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
var
  FocusNode: PVirtualNode;
  ac: TAudioCollection;
begin
  result := false;
  FocusNode := AlbenVST.FocusedNode;
  if not assigned(FocusNode) then
    exit;

  ac := AlbenVST.GetNodeData<TAudioCollection>(FocusNode);
  if assigned(ac) then begin
    result := true;
    GenerateSortedListFromCollection(ac, dest, CreateFileCopies);
  end;
end;

function TNemp_MainForm.GenerateSortedListFromCoverFlow(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
var
  ac: TAudioCollection;
begin
  result := CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1;
  if result then begin
    ac := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
    if assigned(ac) then
      GenerateSortedListFromCollection(ac, dest, CreateFileCopies);
  end;
end;

function TNemp_MainForm.GenerateSortedListFromTagCloud(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
var
  ac: TAudioCollection;
begin
  result := False;
  ac := CloudViewer.FocussedCollection;
  if assigned(ac) then begin
    result := True;
    GenerateSortedListFromCollection(ac, dest, CreateFileCopies);
  end;
end;

function TNemp_MainForm.GenerateSortedListFromFileView(dest: TAudioFileList; CreateFileCopies: Boolean): Boolean;
var
  i: Integer;
  SelectedMp3s: TNodeArray;
  af: TAudioFile;
begin
  result := True;
  SelectedMP3s := VST.GetSortedSelection(False);
  for i := 0 to length(SelectedMP3s) - 1 do begin
    af := VST.GetNodeData<TAudioFile>(SelectedMP3s[i]);
    if CreateFileCopies then
      af.AddCopyToList(dest)
    else
      dest.Add(af)
  end;
end;

function TNemp_MainForm.CopyAudioFileList(Source, Dest: TAudioFileList): Boolean;
var
  i: Integer;
begin
  result := True;
  for i := 0 to Source.Count - 1 do
    Source[i].AddCopyToList(Dest)
end;

{
F�r Nemp 5.0 wird eine weitere Enqueue-Aktion ben�tigt:
1x f�r Browse-Liste (sp�ter = mit Coverflow + TagCloud, weil alles AudioCollection sein werden)
1x f�r den VST unten
}


procedure TNemp_MainForm.ConfirmPlaylistClearing(InsertCount: Integer; var EnqueueMode: Integer);
begin
  if (EnqueueMode = PLAYER_PLAY_FILES) and (NempPlaylist.Count > 20) and (InsertCount < 5) then begin
    // Ask the user, whether the current playlist should be cleared
    if TranslateMessageDLG(Format((Playlist_QueryReallyDelete), [NempPlaylist.Count, InsertCount]), mtWarning, [mbYes, mbNo], 0) = mrYes then
      EnqueueMode := PLAYER_PLAY_FILES
    else
      EnqueueMode := PLAYER_ENQUEUE_FILES;
  end;
end;

procedure TNemp_MainForm.PlayEnqueue(aCollection: TAudioCollection; EnqueueMode: Integer);
var
  DateiListe: TAudioFileList;
  acCount: Integer;
begin
  if not assigned(aCollection) then
    exit;

  DateiListe := TAudioFileList.Create(False);
  try
    case aCollection.CollectionClass of
      ccFiles,
      ccPlaylists: begin
        GenerateSortedListFromCollection(aCollection, DateiListe, True);
        acCount := DateiListe.Count;
      end;
      ccWebStations: begin
        acCount := 1;
      end;
    else
      acCount := 0;
    end;
    ConfirmPlaylistClearing(acCount, EnqueueMode);

    case aCollection.CollectionClass of
      ccFiles,
      ccPlaylists: HandleFiles(Dateiliste, EnqueueMode);
      ccWebStations: begin
          WebRadioInsertMode := EnqueueMode;
          TAudioWebradioCollection(aCollection).Station.TuneIn(NempPlaylist.BassHandlePlaylist);
      end;
    end;
  finally
    FreeAndNil(DateiListe);
  end;
end;

procedure TNemp_MainForm.PlayEnqueueFromView(EnqueueMode: Integer);
var
  FileList: TAudioFileList;
  Proceed: Boolean;
begin
  FileList := TAudioFileList.Create(False);
  try
    Proceed := True;
    if not NempPlaylist.ApplyDefaultActionToWholeList then
      GenerateSortedListFromFileView(FileList, True)
    else begin
      if MedienBib.AnzeigeListe.Count <= 1000 then
        CopyAudioFileList(MedienBib.AnzeigeListe, FileList)
      else begin
        case TranslateMessageDLG(Format((Playlist_QueryTooManyFiles), [MedienBib.AnzeigeListe.Count]), mtConfirmation, [MBYes, MBNo, MBCancel], 0) of
          mrYes: CopyAudioFileList(MedienBib.AnzeigeListe, FileList);
          mrNo: GenerateSortedListFromFileView(FileList, True);
        else
          Proceed := False; // Cancel the operation, do not add files at all to the playlist
        end;
      end
    end;

    if Proceed then begin
      ConfirmPlaylistClearing(FileList.Count, EnqueueMode);
      HandleFiles(FileList, EnqueueMode);
    end;
  finally
    FileList.Free;
  end;
end;

procedure TNemp_MainForm.DirectPlayFocusedFile;
var
  af: TAudioFile;
begin
  if assigned(VST.FocusedNode) then begin
    af := VST.GetNodeData<TAudioFile>(VST.FocusedNode);
    if assigned(af) and FileExists(af.Pfad) then
      NempPlaylist.PlayBibFile(af, NempPlayer.FadingInterval);
  end;
end;

procedure TNemp_MainForm.PM_ML_CollectionPlayEnqueueClick(Sender: TObject);
var
  ac: TAudioCollection;
begin
  ac := GetSelectedCollectionFromMainWindow;
  PlayEnqueue(ac, (Sender as TMenuItem).Tag);
end;

procedure TNemp_MainForm.PM_ML_CollectionShowPlaylistInExplorerClick(
  Sender: TObject);
var
  ac: TAudioCollection;
  FilePath: String;
begin
  ac := GetSelectedCollectionFromMainWindow;
  if assigned(ac) and (ac.CollectionClass = ccPlaylists) then begin
    FilePath := TAudioPlaylistCollection(ac).LibraryPlaylist.Path;
    if FileExists(FilePath) then
      ShellExecute(Handle, 'open' ,'explorer.exe',
            PChar('/e,/select,"' + FilePath+'"'), '', sw_ShowNormal)
    else
      TranslateMessageDLG(Format(PlaylistManager_BibPlaylistNoFound, [FilePath]), mtWarning, [MBOK], 0)
  end;
end;

procedure TNemp_MainForm.PM_ML_ConfigureMedialibraryClick(Sender: TObject);
begin
  if Not Assigned(OptionsCompleteForm) then
    Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
  OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.CategoriesNode;
  OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.CategoriesNode] := True;
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabCategories;
  OptionsCompleteForm.Show;
end;

procedure TNemp_MainForm.PM_ML_FilesPlayEnqueueClick(Sender: TObject);
begin
  PlayEnqueueFromView((Sender as TMenuItem).Tag);
end;

procedure TNemp_MainForm.PM_ML_FilesPlayNowClick(Sender: TObject);
begin
  DirectPlayFocusedFile;
end;

procedure TNemp_MainForm.PM_ML_ApplyDefaultActionToWholeListClick(
  Sender: TObject);
begin
  NempPlaylist.ApplyDefaultActionToWholeList := not NempPlaylist.ApplyDefaultActionToWholeList;
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
    MM_ML_SearchDirectoryCurrentCategory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode
                      AND assigned(MedienBib.CurrentCategory) and (MedienBib.CurrentCategory is TLibraryFileCategory);
    MM_ML_Webradio        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    MM_ML_Search  .Enabled := LibraryNotCritical ;

    MM_ML_Load        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_Save        .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_ExportAsCSV .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_Delete      .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;

    MM_ML_RefreshAll         .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    MM_ML_RefreshPlaylists   .Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
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

    MM_PL_Save           .Enabled := (NempPlaylist.Count > 0);
    MM_PL_SaveAsPlaylist .Enabled := (NempPlaylist.Count > 0);
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
    MM_ML_ConfigureMediaLibrary.Enabled := PartyModeNotActive;

    PM_ML_ConfigureMedialibrary.Enabled := (MedienBib.StatusBibUpdate = 0) and PartyModeNotActive;

    MM_O_FormBuilder.Enabled := NempOptions.AnzeigeMode = 0;
end;


{
  ***************************
  PopUp MediaListMenus
  ***************************
}
procedure TNemp_MainForm.Medialist_Category_PopupMenuPopup(Sender: TObject);
var
  PartyModeNotActive, LibraryIsIdle, FileCat, CatCanBeCleared: Boolean;
  lc: TLibraryCategory;
begin
  PartyModeNotActive := NOT NempSkin.NempPartyMode.Active;
  LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;

  if assigned(ArtistsVST.FocusedNode) then begin
    lc := ArtistsVST.GetNodeData<TLibraryCategory>(ArtistsVST.FocusedNode);
  end else
    lc := Nil;

  FileCat := assigned(lc) and (lc.CategoryType = ccFiles);
  CatCanBeCleared := LibraryIsIdle and PartyModeNotActive and FileCat and (not lc.IsDefault);

  PM_ML_ConfigureMedialibraryCat.Enabled := LibraryIsIdle and PartyModeNotActive;
  PM_ML_ClearCategory.Enabled := CatCanBeCleared and (lc.ItemCount > 0);

  if CatCanBeCleared then
    PM_ML_ClearCategory.Caption := Format(MainForm_MenuCaptionsClearCollection, [lc.Caption])
  else
    PM_ML_ClearCategory.Caption := MainForm_MenuCaptionsClearCollectionBlanko;

  PM_ML_ShowPlaylistCategories.Checked := NempOrganizerSettings.ShowPlaylistCategories;
  PM_ML_ShowWebradioCategory.Checked := NempOrganizerSettings.ShowWebradioCategory;
end;

procedure TNemp_MainForm.Medialist_Collection_PopupMenuPopup(Sender: TObject);
var //o: TComponent;
    //PoppedAtAlbumVST,
    LibraryNotBlockedByPartymode: Boolean; // PoppedAtArtistVST

    //ArtistNode, AlbumNode: PVirtualNode;
    canPlay, LibraryIsIdle: Boolean;

    //tmpCaption: String;

    aNode: PVirtualNode;
    nLevel, i: Integer;
    ac: TAudioCollection;
    lc: TLibraryCategory;
    acFile: TAudioFileCollection;
    isAlbum, isDirectory, isSortable, isFavPlLC: Boolean;
    levelCaption, enqueueCaption, CollectionCaption: String;
begin
    // The (smaller) menu for the Browsing part (top left of the form)
    // ---------------------------------------------------------------
    LibraryIsIdle      := MedienBib.StatusBibUpdate = 0;
    // LibraryNotCritical := MedienBib.StatusBibUpdate <= 1;
    LibraryNotBlockedByPartymode := NOT NempSkin.NempPartyMode.DoBlockBibOperations;
    ac := Nil;
    lc := MedienBib.CurrentCategory;
    //Nil;
    //catNode := ArtistsVST.FocusedNode;
    //if assigned(catNode) then
    //  lc := ArtistsVST.GetNodeData<TLibraryCategory>(catNode);

    nLevel := -1;
    case MedienBib.BrowseMode of
      0: begin
        aNode := AlbenVST.FocusedNode;
        nLevel := AlbenVST.GetNodeLevel(aNode);
        if assigned(aNode) then
          ac := AlbenVST.GetNodeData<TAudioCollection>(aNode);
      end;
      1: begin
          nLevel := 1;
          if (CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1) then
            ac := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
      end;
      2: begin
        ac := CloudViewer.FocussedCollection;
      end;
    end;

    RefreshActionLayoutCheckedStatus;

    enqueueCaption := MainForm_MenuCaptionsEnqueue;
    if assigned(ac) then begin
      if (ac is TRootCollection) and assigned(lc) then begin
        enqueueCaption := Format(MainForm_MenuCaptionEnqueueAll, [lc.Name])
      end else
        case ac.CollectionClass of
          ccFiles: enqueueCaption := Format(MainForm_MenuCaptionEnqueueCollection, [ac.SimpleCaption]);
          ccPlaylists: enqueueCaption := Format(MainForm_MenuCaptionEnqueuePlaylistCollection, [ac.SimpleCaption]);
          ccWebStations: enqueueCaption := Format(MainForm_MenuCaptionEnqueueWebradioCollection, [ac.SimpleCaption]);
        end;
    end;
    PM_ML_EnqueueBrowse.Caption := enqueueCaption;

    PM_ML_CollectionShowPlaylistInExplorer.Visible := LibraryNotBlockedByPartymode and (ac.CollectionClass = ccPlaylists);

    isSortable := assigned(lc) and (MedienBib.BrowseMode <> 2);
    PM_ML_SortLayerBy.Visible := isSortable and (lc.CategoryType = ccFiles);
    PM_ML_SortPlaylistsBy.Visible := isSortable and (lc.CategoryType = ccPlaylists);

    // Menus "Sort Layer/Collection by"
    if assigned(ac) and (ac is TAudioFileCollection) and (nLevel >= 0) and (MedienBib.BrowseMode <> 2) then begin
      acFile := TAudioFileCollection(ac);
      if not (acFile is TRootCollection) and (acFile.CollectionCount = 0) then begin
        acFile := acFile.Parent;
        dec(nLevel);
      end;

      if (acFile is TRootCollection) then begin
        levelCaption := TRootCollection(acFile).LevelCaption[0];
        CollectionCaption := TRootCollection(acFile).LevelCaption[0]
      end
      else begin
        levelCaption := acFile.Root.LevelCaption[nLevel];
        CollectionCaption := acFile.SimpleCaption;
      end;

      isAlbum := (acFile.ChildContent = ccAlbum) or (MedienBib.BrowseMode = 1);
      isDirectory := acFile.ChildContent = ccDirectory;

      case acFile.Root.SpecialContent of
        scRegular: PM_ML_SortLayerBy.Caption := Format(MainForm_MenuCaptionsSortLayerBy, [levelCaption]);
        scDirectory: PM_ML_SortLayerBy.Caption :=  MainForm_MenuCaptionsSortDirectoriesBy;
        scTagCloud: PM_ML_SortLayerBy.Caption :=  MainForm_MenuCaptionsSortTagCloudBy;
      end;
      // PM_ML_SortLayerBy.Visible := True;

      for i := 0 to PM_ML_SortLayerBy.Count - 1 do
        PM_ML_SortLayerBy.Items[i].Checked := acFile.ChildSorting = teCollectionSorting(PM_ML_SortLayerBy.Items[i].Tag);
      // two special cases:
      PM_ML_SortLayerByArtistAlbum.Checked := (acFile.ChildSorting = csArtist) and (acFile.SecondaryChildSorting = csAlbum);
      PM_ML_SortLayerByArtistReleaseYear.Checked := (acFile.ChildSorting = csArtist) and (acFile.SecondaryChildSorting = csYear);

      PM_ML_SortLayerAscending.Checked := acFile.ChildSortDirection = sd_Ascending;
      PM_ML_SortLayerDescending.Checked := acFile.ChildSortDirection = sd_Descending;

      {PM_ML_SortLayerByAlbum.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortLayerByAlbum.Tag);
      PM_ML_SortLayerByArtistAlbum.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortLayerByArtistAlbum.Tag);
      PM_ML_SortLayerByReleaseYear.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortLayerByReleaseYear.Tag);
      PM_ML_SortLayerByFileAge.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortLayerByFileAge.Tag);
      PM_ML_SortLayerByDirectory.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortLayerByDirectory.Tag);
      PM_ML_SortCollectionByName.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortCollectionByName.Tag);
      PM_ML_SortCollectionByCount.Checked := acFile.SubCollectionSorting = teCollectionSorting(PM_ML_SortCollectionByCount.Tag);
      }

      // Submenu for "sort layer by"
      PM_ML_SortLayerByAlbum.Visible := isAlbum;
      PM_ML_SortLayerByArtistAlbum.Visible := isAlbum;
      PM_ML_SortLayerByArtistReleaseYear.Visible := isAlbum;
      PM_ML_SortLayerByReleaseYear.Visible := isAlbum;
      PM_ML_SortLayerByFileAge.Visible := isAlbum;
      PM_ML_SortLayerByGenre.Visible := isAlbum;
      PM_ML_SortLayerByDirectory.Visible := isAlbum or isDirectory;
      (*
      // Submenu for "Sort Collection by"
      PM_ML_SortCollectionBy.Caption := Format(MainForm_MenuCaptionsSortCollectionBy, [CollectionCaption]);
      PM_ML_SortCollectionBy.Visible := False;

      PM_ML_SortCollectionByAlbum.Visible := isAlbum;
      PM_ML_SortCollectionByArtistAlbum.Visible := isAlbum;
      PM_ML_SortCollectionByReleaseYear.Visible := isAlbum;
      PM_ML_SortCollectionByFileAge.Visible := isAlbum;
      PM_ML_SortCollectionByGenre.Visible := isAlbum;
      PM_ML_SortCollectionByDirectory.Visible := isAlbum or isDirectory;
      *)
    end;// else
    //begin
    //  PM_ML_SortLayerBy.Visible := False;
      //PM_ML_SortCollectionBy.Visible := False;
    //end;

    if assigned(ac) and (ac is TAudioPlaylistCollection) and (MedienBib.BrowseMode <> 2) then begin
      for i := 0 to self.PM_ML_SortPlaylistsBy.Count - 1 do
        PM_ML_SortPlaylistsBy.Items[i].Checked := NempOrganizerSettings.PlaylistSorting = tePlaylistCollectionSorting(PM_ML_SortPlaylistsBy.Items[i].Tag);
      PM_ML_SortPlaylistsAscending.Checked := NempOrganizerSettings.PlaylistSortDirection = sd_Ascending;
      PM_ML_SortPlaylistsDescending.Checked := NempOrganizerSettings.PlaylistSortDirection = sd_Descending;
    end;

    // Show MenuItems for "Favorite Playlists", Actions will be the same as in PlaylistManager-Popup
    isFavPlLC := LC = MedienBib.FavoritePlaylistCategory;
    PM_ML_SaveAsNewFavorite.Visible := isFavPlLC;
    PM_ML_EditFavorites.Visible := isFavPlLC;
    PM_ML_FavPlaylistSeparator.Visible := isFavPlLC;

    if assigned(ac) then begin
      PM_ML_ChangeCategory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode
            AND (ac.CollectionClass = ccFiles)
            AND (ac.Count > 0) ;
      PM_ML_RemoveFromCategory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode
            AND (ac.CollectionClass = ccFiles)
            AND (ac.Count > 0) ;

      case ac.CollectionClass of
        ccFiles: canPlay := ac.Count > 0;
        ccPlaylists: canPlay := True;
        ccWebStations: canPlay := True;
      else
        canPlay := False;
      end
    end
    else begin
      canPlay := False;
      PM_ML_ChangeCategory.Enabled := False;
      PM_ML_RemoveFromCategory.Enabled := False;
    end;

    PM_ML_PlayBrowse    .Enabled := canPlay AND LibraryNotBlockedByPartymode;
    PM_ML_EnqueueBrowse .Enabled := canPlay;
    PM_ML_PlayNextBrowse.Enabled := canPlay;

    // SearchDirectory, MediaLibrary->, Webradio stations:
    // That WAS blocked through MediaLibray-Update-Logic before
    // changed to OnPopup (2019)
    PM_ML_SortLayerBy.Enabled := LibraryIsIdle;
    PM_ML_ConfigureMedialibrary.Enabled := LibraryIsIdle and LibraryNotBlockedByPartymode;


    PM_ML_SearchDirectory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode;
    PM_ML_SearchDirectoryCurrentCategory.Enabled := LibraryIsIdle AND LibraryNotBlockedByPartymode
                      AND assigned(MedienBib.CurrentCategory) and (MedienBib.CurrentCategory is TLibraryFileCategory);

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
                                  and (MedienBib.CurrentCategory.CategoryType = ccPlaylists)
                                  AND assigned(AlbenVST.FocusedNode);

    PM_ML_ResetTagCloudSeparator.Visible := MedienBib.BrowseMode = 2;
    PM_ML_ResetTagCloud.Visible := MedienBib.BrowseMode = 2;
end;

procedure TNemp_MainForm.Medialist_View_PopupMenuPopup(Sender: TObject);
var SelectedMp3s: TNodeArray;
    SomeFilesSelected: Boolean;
    LibraryIsIdle, LibraryNotCritical, LibraryNotBlockedByPartymode: Boolean;
begin
    // the (bigger) menu for the viewing part (bottom of the form)
    // ---------------------------------------------------------------
    // MediaListPopupTag := 3;

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

    PM_ML_ApplyDefaultActionToWholeList.Checked := NempPlaylist.ApplyDefaultActionToWholeList;

    // Sorting
    PM_ML_SortBy.Enabled := LibraryNotCritical;

    // Hide/remove
    PM_ML_HideSelected  .Enabled := SomeFilesSelected;
    PM_ML_DeleteSelected.Enabled := SomeFilesSelected AND LibraryIsIdle
                                                      AND LibraryNotBlockedByPartymode
                                                      AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);

    // Editing Files
    PM_MLView_ChangeCategory.Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);
    PM_MLView_RemoveFromCategory.Enabled := LibraryIsIdle AND SomeFilesSelected AND LibraryNotBlockedByPartymode AND (NOT MedienBib.AnzeigeShowsPlaylistFiles);

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
    ///PM_ML_GetLyrics      .Enabled := LibraryIsIdle AND SomeFilesSelected
    ///                                               AND LibraryNotBlockedByPartymode
    ///                                               AND (NOT MedienBib.AnzeigeShowsPlaylistFiles); Disabled for now (06.2022)
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

    PM_ML_SortArtistTitle.Checked := (MedienBib.Sortparams[0].Tag = colIdx_ARTIST) and (MedienBib.Sortparams[1].Tag = colIdx_TITLE) ;
    PM_ML_SortArtistAlbumTitle.Checked := (MedienBib.Sortparams[0].Tag = colIdx_ARTIST) and (MedienBib.Sortparams[1].Tag = colIdx_ALBUM) and (MedienBib.Sortparams[2].Tag = colIdx_TITLE);
    PM_ML_SortTitleArtist.Checked := (MedienBib.Sortparams[0].Tag = colIdx_TITLE) and (MedienBib.Sortparams[1].Tag = colIdx_ARTIST);
    PM_ML_SortAlbumArtistTitle.Checked := (MedienBib.Sortparams[0].Tag = colIdx_ALBUM) and (MedienBib.Sortparams[1].Tag = colIdx_ARTIST) and (MedienBib.Sortparams[2].Tag = colIdx_TITLE);
    PM_ML_SortAlbumTitleArtist.Checked := (MedienBib.Sortparams[0].Tag = colIdx_ALBUM) and (MedienBib.Sortparams[1].Tag = colIdx_TITLE) and (MedienBib.Sortparams[2].Tag = colIdx_ARTIST);
    PM_ML_SortAlbumTracknr.Checked := (MedienBib.Sortparams[0].Tag = colIdx_ALBUM) and (MedienBib.Sortparams[1].Tag = colIdx_TRACK);
    PM_ML_SortFilename.Checked := (MedienBib.Sortparams[0].Tag = colIdx_Filename);
    PM_ML_SortPathFilename.Checked := (MedienBib.Sortparams[0].Tag = colIdx_Path);
    PM_ML_SortLyricsexists.Checked := (MedienBib.Sortparams[0].Tag = colIdx_Lyrics);
    PM_ML_SortGenre.Checked := (MedienBib.Sortparams[0].Tag = colIdx_GENRE);
    PM_ML_SortDuration.Checked := (MedienBib.Sortparams[0].Tag = colIdx_Duration);
    PM_ML_SortFilesize.Checked := (MedienBib.Sortparams[0].Tag = colIdx_FILESIZE);
    PM_ML_bpm.Checked := (MedienBib.Sortparams[0].Tag = colIdx_BPM);
    //-
    PM_ML_SortAscending.Checked := MedienBib.Sortparams[0].Direction = sd_Ascending;
    PM_ML_SortDescending.Checked := MedienBib.Sortparams[0].Direction = sd_Descending;
end;



procedure TNemp_MainForm.PM_ML_SetRatingsOfSelectedFilesClick(
  Sender: TObject);
var CurrentAF, listFile :TAudioFile;
    iSel, iGes, iList: Integer;
    SelectedMp3s: TNodeArray;
    ListOfFiles: TAudioFileList;
    newRating: Integer;
    resetCounter: Boolean;
    TagMod100: Integer;
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
    NempTaskbarManager.ProgressState := TTaskBarProgressState.Normal;
    NempTaskbarManager.ProgressValue := 0;

    TagMod100 := (Sender as TMenuItem).Tag Mod 100;
    if (Sender as TMenuItem).Tag >= 100 then
        LocalTree := VST
    else
        LocalTree := PlaylistVST;

    ProgressFormLibrary.AutoClose := True;
    ProgressFormLibrary.InitiateProcess(True, pa_UpdateMetaData);

    SelectedMP3s := LocalTree.GetSortedSelection(False);
    ListOfFiles := TAudioFileList.Create(False);
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

            ct := GetTickCount;
            iGes := Length(SelectedMP3s);
            for iSel := 0 to Length(SelectedMP3s) - 1 do
            begin
                CurrentAF := LocalTree.GetNodeData<TAudioFile>(SelectedMP3s[iSel]);
                // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
                CurrentAF.GetAudioData(CurrentAF.Pfad);

                      // get List of this AudioFile
                      GetListOfAudioFileCopies(CurrentAF, ListOfFiles);
                      // edit all these files
                      for iList := 0 to ListOfFiles.Count - 1 do
                      begin
                          listFile := ListOfFiles[iList];
                          listFile.Rating := newRating;
                          if resetCounter then
                              listFile.PlayCounter := 0;
                      end;
                      // write the rating into the file on disk
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
                    NempTaskbarManager.ProgressValue := Round(iSel/iGes * 100);
                    ProgressFormLibrary.lblSuccessCount.Caption := IntToStr(iSel);
                    ProgressFormLibrary.MainProgressBar.Position := Round(iSel/iGes * 100);
                    ProgressFormLibrary.Update;
                    application.processmessages;
                    if not KeepOnWithLibraryProcess then break;
                end;
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
    NempTaskbarManager.ProgressState := TTaskBarProgressState.None;
end;

procedure TNemp_MainForm.PM_ML_SetmarkerClick(Sender: TObject);
begin
    SetMarker(Sender, ((Sender as TMenuItem).Tag Mod 100));
end;

procedure TNemp_MainForm.SetMarker(Sender: TObject; aValue: Byte);
var CurrentAF :TAudioFile;
    iSel, iList: Integer;
    SelectedMp3s: TNodeArray;
    ListOfFiles: TAudioFileList;
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
    ListOfFiles := TAudioFileList.Create(False);
    try
        for iSel := 0 to length(SelectedMP3s) - 1 do
        begin
            CurrentAF := LocalTree.GetNodeData<TAudioFile>(SelectedMP3s[iSel]);
            CurrentAF.Favorite := aValue;
            // get List of this AudioFile
            GetListOfAudioFileCopies(CurrentAF, ListOfFiles, False);
            // edit all these files
            for iList := 0 to ListOfFiles.Count - 1 do
                ListOfFiles[iList].Favorite := aValue;
            // correct GUI
            CorrectVCLAfterAudioFileEdit(CurrentAF, False);
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
  Node: PVirtualNode;
  af: TAudioFile;
begin
  Node:=VST.FocusedNode;
  if not Assigned(Node) then
    Exit;

  af := VST.GetNodeData<TAudioFile>(Node);
  if DirectoryExists(af.Ordner) then
    ShellExecute(Handle, 'open' ,'explorer.exe',
          PChar('/e,/select,"' + af.Pfad+'"'), '', sw_ShowNormal);
end;



procedure TNemp_MainForm.PM_ML_ShowPlaylistCategoriesClick(Sender: TObject);
begin
  NempOrganizerSettings.ShowPlaylistCategories := not NempOrganizerSettings.ShowPlaylistCategories;
  ReFillCategoryTree(True);
end;

procedure TNemp_MainForm.PM_ML_ShowWebradioCategoryClick(Sender: TObject);
begin
  NempOrganizerSettings.ShowWebradioCategory := not NempOrganizerSettings.ShowWebradioCategory;
  ReFillCategoryTree(True);
end;

procedure TNemp_MainForm.ShowSummary(aList: TAudioFileList = Nil);
var i, catCount: integer;
  dauer: int64;
  groesse: int64;
  Liste: TAudioFileList;
begin
  dauer:=0;
  groesse:=0;
  // ???
  if assigned(aList) then
      Liste := aList
  else
      Liste := MedienBib.Anzeigeliste;

  if MedienBib.Count = 0 then
      //AuswahlStatusLBL.Caption := ''
      RefreshAuswahlStatusLBL('')
  else
  begin
    catCount := MedienBib.CurrentCategory.CollectionCount;
    case MedienBib.CurrentCategory.CategoryType of
      ccFiles: begin
          for i:=0 to Liste.Count-1 do
          begin
              dauer := dauer + Liste[i].Duration;
              groesse := groesse + Liste[i].Size;
          end;

          if Liste.Count = 1 then
              //AuswahlStatusLBL.Caption :=
              RefreshAuswahlStatusLBL(Format((MainForm_Summary_FileCountSingle),[Liste.Count])
                             + SizeToString(groesse)
                             + SekToZeitString(dauer))
          else
              //AuswahlStatusLBL.Caption :=
              RefreshAuswahlStatusLBL(Format((MainForm_Summary_FileCountMulti),[Liste.Count])
                             + SizeToString(groesse)
                             + SekToZeitString(dauer))
      end;
      ccPlaylists: begin
        if catCount = 1 then
          //AuswahlStatusLBL.Caption :=
          RefreshAuswahlStatusLBL(Format(MainForm_Summary_PlaylistCountSingle, [catCount]))
        else
          //AuswahlStatusLBL.Caption :=
          RefreshAuswahlStatusLBL(Format(MainForm_Summary_PlaylistCountMulti, [catCount]))
      end;
      ccWebStations: begin
        if MedienBib.RadioStationList.Count = 1 then
          //AuswahlStatusLBL.Caption :=
          RefreshAuswahlStatusLBL(Format(MainForm_Summary_WebradioCountSingle, [MedienBib.RadioStationList.Count]))
        else
          //AuswahlStatusLBL.Caption :=
          RefreshAuswahlStatusLBL(Format(MainForm_Summary_WebradioCountMulti, [MedienBib.RadioStationList.Count]))
      end;
    end;

  end;
end;


procedure TNemp_MainForm.ShowHelp;
//var ProperHelpFile: String;
begin
  Application.HelpContext(HELP_Nemp_Main);
  (*
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
    *)
end;

procedure TNemp_MainForm.ToolButton7Click(Sender: TObject);
begin
    ShowHelp;
end;

procedure TNemp_MainForm.MM_H_HelpOnlineClick(Sender: TObject);
begin
  if AnsiStartsText('de', NempOptions.Language) then
    ShellExecute(Handle, 'open', PChar(NEMP_ONLINE_HELP_DE), nil, nil, SW_SHOW)
  else
    ShellExecute(Handle, 'open', PChar(NEMP_ONLINE_HELP_EN), nil, nil, SW_SHOW)
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

procedure TNemp_MainForm.MM_ML_RefreshPlaylistsClick(Sender: TObject);
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
    exit;

  if MedienBib.StatusBibUpdate <> 0 then begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;
  MedienBib.RefreshPlaylists;
end;

procedure TNemp_MainForm.PM_ML_RefreshSelectedClick(Sender: TObject);
var i: Integer;
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

    SelectedMP3s := VST.GetSortedSelection(False);
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
        for i := 0 to Length(SelectedMP3s) - 1 do
            MedienBib.UpdateList.Add(VST.GetNodeData<TAudioFile>(SelectedMP3s[i]));

        // refresh them in a thread
        MedienBib.RefreshFiles_Selected;
    end;
end;


procedure TNemp_MainForm.PM_ML_PropertiesClick(Sender: TObject);
var AudioFile: TAudioFile;
    Node: PVirtualNode;
begin
    if NempSkin.NempPartyMode.DoBlockDetailWindow then
        exit;

    Node:=VST.FocusedNode;
    if not Assigned(Node) then
      Node := VST.GetFirstSelected;
    if not Assigned(Node) then
      exit;

    AudioFile := VST.GetNodeData<TAudioFile>(Node);
    ShowDetailForm(AudioFile, True);

    if not FileExists(AudioFile.Pfad) then
    begin
      AudioFile.FileIsPresent := False;
      VST.InvalidateNode(Node);
    end;
end;



procedure TNemp_MainForm.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var af: TAudioFile;
begin
        af := Sender.GetNodeData<TAudioFile>(Node);

        case Column of
          colIdx_ARTIST    : CellText := NempDisplay.TreeArtist(af);// af.GetArtistForVST(NempOptions.ReplaceNAArtistBy);
          colIdx_ALBUMARTIST : CellText := af.AlbumArtist;
          colIdx_COMPOSER  : CellText := af.Composer;
          colIdx_TITLE     : CellText := NempDisplay.TreeTitle(af); // af.GetTitleForVST(NempOptions.ReplaceNATitleBy);
          colIdx_ALBUM     : CellText := NempDisplay.TreeAlbum(af); // af.GetAlbumForVST(NempOptions.ReplaceNAAlbumBy);
          colIdx_Duration  : CellText := NempDisplay.TreeDuration(af); //  af.GetDurationForVST;
          colIdx_BITRATE   : CellText := NempDisplay.TreeBitrate(af); //  af.GetBitrateForVST;
          colIdx_CBRVBR   : if af.vbr then CellText := 'vbr'
                          else CellText := 'cbr';
          colIdx_ChannelMODE  : CellText := NempDisplay.TreeChannelmode(af);
          colIdx_SAMPLERATE   : CellText := NempDisplay.TreeSamplerate(af);
          colIdx_COMMENT   : CellText := af.Comment;
          colIdx_FILESIZE  : CellText :=  NempDisplay.TreeFileSize(af);
          colIdx_FILEAGE   : Celltext := af.FileAgeString;
          colIdx_Path      : CellText := af.Pfad;
          colIdx_Directory : CellText := af.Ordner;
          colIdx_Filename  : CellText := af.Dateiname;
          colIdx_YEAR      : CellText := af.Year;
          colIdx_GENRE     : CellText := af.genre;
          colIdx_Lyrics    : CellText := ' ';
          colIdx_EXTENSION : CellText := af.Extension;
          colIdx_TRACK     : CellText := IntToStr(af.Track);
          colIdx_CD        : CellText := af.CD;
          colIdx_RATING    : CellText := '     ';
          colIdx_PLAYCOUNTER : CellText := IntToStr(af.PlayCounter);

          colIdx_Marker  : CellText := ' '; // noFav
          colIdx_LastFMTags: CellText := ' ';

          colIdx_TRACKGAIN : Celltext := GainValueToString(af.TrackGain);
          colIdx_ALBUMGAIN : Celltext := GainValueToString(af.AlbumGain);
          colIdx_TRACKPEAK : Celltext := PeakValueToString(af.TrackPeak);
          colIdx_ALBUMPEAK : Celltext := PeakValueToString(af.AlbumPeak);
          colIdx_BPM : Celltext := af.BPM;
          colIdx_HARMONICKEY: CellText := af.HarmonicKey;

        else
          CellText := ' ';
        end;
        // Correct CellText for toAutoSpan to a non-empty-string
        if CellText = '' then Celltext := ' ';

end;

procedure TNemp_MainForm.VSTAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var af: TAudioFile;
    st: Integer;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);

  case Column of
     colIdx_RATING: begin
            TargetCanvas.Brush.Style := bsClear;
            if af.Rating = 0 then
                st := 127
            else
                st := af.Rating;
            RatingGraphics.DrawRatingInStars(st, TargetCanvas, CellRect.Bottom - CellRect.Top, CellRect.Left);
     end;
  end;
end;


procedure TNemp_MainForm.VSTColumnClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var aFile: TAudioFile;
    ListOfFiles: TAudioFileList;
    iList: Integer;
    newMark: Byte;
    FileIsInLibrary: Boolean;
begin

    case Column of
      colIdx_Marker: begin
          aFile := GetFocussedAudioFile;
          if assigned(aFile) then
          begin
              newMark := (aFile.Favorite + 1) Mod 4;
              aFile.Favorite := newMark;
              ListOfFiles := TAudioFileList.Create(False);
              try
                  // get List of this AudioFile
                  FileIsInLibrary := GetListOfAudioFileCopies(aFile, ListOfFiles);
                  // edit all these files
                  for iList := 0 to ListOfFiles.Count - 1 do
                      ListOfFiles[iList].Favorite := newMark;
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
  case NempPlaylist.DefaultAction of
    PLAYER_ENQUEUE_FILES: PlayEnqueueFromView(PM_ML_Enqueue.Tag);
    PLAYER_PLAY_FILES   : PlayEnqueueFromView(PM_ML_Play.Tag);
    PLAYER_PLAY_NEXT    : PlayEnqueueFromView(PM_ML_PlayNext.Tag);
    PLAYER_PLAY_NOW     : DirectPlayFocusedFile;
  end;
end;


procedure TNemp_MainForm.VSTAfterGetMaxColumnWidth(Sender: TVTHeader;
  Column: TColumnIndex; var MaxWidth: Integer);
begin
  if Column = colIdx_RATING then
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

          MedienBib.AddSorter(HitInfo.Column); //   (VST.Header.Columns[HitInfo.Column].Tag);
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


procedure TNemp_MainForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  AudioFile:TAudioFile;
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

    AudioFile := VST.GetNodeData<TAudioFile>(Node);
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
            font.Style := ModeToStyle(AudioFile.ChannelModeIdx)
        else
            font.Style := NempOptions.DefaultFontStyles;

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
                case Column of
                    colIdx_RATING,
                    colIdx_LastFMTags,
                    colIdx_Lyrics: ; // nothing
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
    aAudioFile: TAudioFile;
begin
    // Used for next Search with "F3"
    OldSelectionPrefix := SearchText;

    aAudioFile := Sender.GetNodeData<TAudioFile>(Node);

    case VST.FocusedColumn of
        colIdx_ARTIST:   aString := aAudioFile.Artist;
        colIdx_ALBUMARTIST: aString := aAudioFile.AlbumArtist;
        colIdx_COMPOSER: aString := aAudioFile.Composer;
        colIdx_TITLE:    aString := aAudioFile.Titel;
        colIdx_ALBUM:    aString := aAudioFile.Album;
        colIdx_Path,
        colIdx_Directory: aString := aAudioFile.Ordner;
        colIdx_Filename:  aString := aAudioFile.Dateiname;
        colIdx_EXTENSION: aString := aAudioFile.Extension;
    else
        aString := aAudioFile.Artist;
    end;
    Result := StrLIComp(PChar(SearchText), PChar(aString), length(SearchText));
end;

procedure TNemp_MainForm.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Node,ScrollNode: PVirtualNode;
  erfolg:boolean;

        function GetNodeWithPrefix(aVST: TVirtualStringTree; StartNode:PVirtualNode; FocussedAttribut:integer; Prefix: UnicodeString; var Erfolg:boolean):PVirtualNode;
        // erfolg gibt an, ob man beim kompletten Durchlauf des Baumes einen weiteren Knoten mit den
        // gew�nschten EIgenschaften gefunden hat.
        // Wenn man beim Startknoten wieder ankommt, gibt es keinen (weiteren) Knoten mit dem
        // entsprechenden Prefix.
        var
          nextnode:PVirtualnode;
          AudioFile: TAudioFile;
          aString: String;
        begin
          erfolg := false;
          nextnode := startNode;
          repeat
            AudioFile := aVST.GetNodeData<TAudioFile>(nextNode);

            case FocussedAttribut of
                colIdx_ARTIST    : aString := AudioFile.Artist;
                colIdx_ALBUMARTIST: aString := AudioFile.AlbumArtist;
                colIdx_COMPOSER  : aString := AudioFile.Composer;
                colIdx_TITLE     : aString := AudioFile.Titel;
                colIdx_ALBUM     : aString := AudioFile.Album;
                colIdx_Path,
                colIdx_Directory : aString := AudioFile.Ordner;
                colIdx_Filename  : aString := AudioFile.Dateiname;
                colIdx_EXTENSION : aString := AudioFile.Extension;
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
      case NempPlaylist.DefaultAction of
        PLAYER_ENQUEUE_FILES: PlayEnqueueFromView(PM_ML_Enqueue.Tag);
        PLAYER_PLAY_FILES   : PlayEnqueueFromView(PM_ML_Play.Tag);
        PLAYER_PLAY_NEXT    : PlayEnqueueFromView(PM_ML_PlayNext.Tag);
        PLAYER_PLAY_NOW     : DirectPlayFocusedFile;
      end;
    end;

    VK_F3:
    begin
      if OldSelectionPrefix = '' then Exit;
      if not Assigned(VST.FocusedNode) then Exit;
      // n�chstes Vorkommen des Prefixes suchen, dazu: beim n�chsten Knoten beginnen
      if VST.GetNext(VST.FocusedNode) <> NIL then
        ScrollNode := GetNodeWithPrefix(VST, VST.GetNext(VST.FocusedNode), VST.FocusedColumn, OldSelectionPrefix,erfolg)
      else
        ScrollNode := GetNodeWithPrefix(VST, VST.GetFirst, VST.FocusedColumn, OldSelectionPrefix,erfolg);
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
        if  (VST.GetNodeData<TAudioFile>(Node)).AudioType = at_File then
            NempPlayer.PlayJingle(VST.GetNodeData<TAudioFile>(Node));
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
    {VK_F1: if ssShift in shift then
              PM_P_ViewSeparateWindows_EqualizerClick(NIL)
           else
              ShowHelp;
    VK_F2: if ssShift in shift then
              PM_P_ViewSeparateWindows_PlaylistClick(NIL);
    VK_F3: if ssShift in shift then
              PM_P_ViewSeparateWindows_MedialistClick(NIL);
    VK_F4: if ssShift in shift then
              PM_P_ViewSeparateWindows_BrowseClick(NIL);
    }
    $42 {B}: if (ssCtrl in shift) and (ssShift in shift) then
                actToggleBrowseList.Execute;

    $44 {D}: if (ssCtrl in shift) and (ssShift in shift) then
                actToggleFileOverview.Execute;

    $4E {P}: if (ssCtrl in shift) and (ssShift in shift) then
                actTogglePlaylist.Execute;

    $54 {T}: if (ssCtrl in shift)  then begin
              if (ssShift in shift) then
                actToggleTitleList.Execute
              else
                actToggleStayOnTop.Execute;
    end;

    $46 {F}: if (ssCtrl in Shift) then
                EditFastSearch.SetFocus;

    VK_F7: begin
            if NOT NempSkin.NempPartyMode.Active then
                SwapWindowMode(NempOptions.AnzeigeMode + 1); // "mod 2" is done in this SwapWindowMode
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
  AudioFile: TAudioFile;
begin

  SelectedMP3s := VST.GetSortedSelection(False);
  c := length(SelectedMp3s);
  if c = 0 then
  begin
      MedienListeStatusLBL.Caption := '';
      exit;
  end;
  dauer := 0;
  groesse := 0;

  for i := 0 to length(SelectedMp3s) - 1 do
  begin
      aNode := SelectedMP3s[i];
      AudioFile := VST.GetNodeData<TAudioFile>(aNode);
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

  if c > 0 then begin
    RefreshVSTDetailsTimer.Enabled := False;
    RefreshVSTDetailsTimer.Enabled := True;
    RefreshVSTDetailsTimer.Tag := SD_MEDIENBIB;
  end;
end;

procedure TNemp_MainForm.FillBibDetailLabels(aAudioFile: TAudioFile);

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
        SetLabelMouseActions(LblBibArtist, (aAudioFile.IsValidArtist) AND (aAudioFile.AudioType in [at_File, at_CDDA]));
        SetLabelMouseActions(LblBibTitle , (aAudioFile.IsValidTitle)  AND (aAudioFile.AudioType in [at_File, at_CDDA]));
        SetLabelMouseActions(LblBibAlbum , (aAudioFile.IsValidAlbum)  AND (aAudioFile.AudioType in [at_File, at_CDDA]));
        SetLabelMouseActions(LblBibYear  , (aAudioFile.IsValidYear)   AND (aAudioFile.AudioType in [at_File, at_CDDA]));
        SetLabelMouseActions(LblBibGenre , (aAudioFile.IsValidGenre)  AND (aAudioFile.AudioType in [at_File, at_CDDA]));
        SetLabelMouseActions(LblBibDirectory, (aAudioFile.AudioType in [at_File, at_CDDA]));

        case aAudioFile.AudioType of

            at_Undef  : LblBibArtist    .Caption := 'ERROR: UNDEFINED AUDIOTYPE'; // should never happen
            at_Cue,
            at_File,
            at_CDDA : begin
                LblBibArtist.Caption := NempDisplay.SummaryArtist(aAudioFile);
                LblBibTitle .Caption := NempDisplay.SummaryTitle(aAudioFile);
                LblBibAlbum.Caption  := NempDisplay.SummaryAlbum(aAudioFile);
                LblBibYear.Caption   := NempDisplay.SummaryYear(aAudioFile);
                LblBibGenre.Caption  := NempDisplay.SummaryGenre(aAudioFile);
                lblBibFilename.Caption  := aAudioFile.Dateiname;
                lblBibDirectory.Caption := aAudioFile.Ordner;

                lblBibDirectory.Hint := MainForm_DoublClickToSearchDirectory;
                LblBibArtist.Hint := NempDisplay.SummaryHintArtist(aAudioFile);
                LblBibTitle.Hint  := NempDisplay.SummaryHintTitle(aAudioFile);
                LblBibAlbum.Hint  := NempDisplay.SummaryHintAlbum(aAudioFile);
                LblBibYear.Hint   := NempDisplay.SummaryHintYear(aAudioFile);
                LblBibGenre.Hint  := NempDisplay.SummaryHintGenre(aAudioFile);
            end;
            at_Stream : begin
                LblBibArtist.Caption := SetString(aAudioFile.Description, AudioFileProperty_Name);
                LblBibTitle .Caption := SetString(aAudioFile.Titel, AudioFileProperty_Title);
                LblBibAlbum .Caption := SetString(aAudioFile.Ordner, AudioFileProperty_URL);
                LblBibYear  .Caption := NempDisplay.SummaryBitrate(aAudioFile);
                LblBibGenre .Caption := NempDisplay.SummaryGenre(aAudioFile);
                lblBibFilename.Caption := '';
                lblBibDirectory.Caption := '';

                LblBibArtist.Hint := '';
                LblBibTitle .Hint := '';
                LblBibAlbum .Hint := '';
                LblBibYear  .Hint := '';
                LblBibGenre .Hint := '';
                lblBibDirectory.Hint := '';
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

    RefreshActionLayoutCheckedStatus;
end;

procedure TNemp_MainForm.pm_TagDetailsClick(Sender: TObject);
begin
  // if not assigned(MedienBib.CurrentAudioFile) then
  //   exit;
  ShowDetailForm(CurrentlySelectedFile, True);
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
    backup := CurrentlySelectedFile.RawTagLastFM;

    if HandleSingleFileTagChange(CurrentlySelectedFile, '', newTagDummy, IgnoreWarningsDummy) then
        DoSyncStuffAfterTagEdit(CurrentlySelectedFile, backup);
end;

procedure TNemp_MainForm.PM_RenameTagThisFileClick(Sender: TObject);
var newTagDummy: String;
    backup: UTF8String;
    IgnoreWarningsDummy: Boolean;
begin
    backup := CurrentlySelectedFile.RawTagLastFM;

    if HandleSingleFileTagChange(CurrentlySelectedFile, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
        DoSyncStuffAfterTagEdit(CurrentlySelectedFile, backup);
end;

procedure TNemp_MainForm.PM_RemoveTagThisFileClick(Sender: TObject);
var backup: UTF8String;
begin
    //if not assigned(CurrentlySelectedFile) then
    //    exit;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentlySelectedFile.Pfad)
    then
    begin
        backup := CurrentlySelectedFile.RawTagLastFM;
        CurrentlySelectedFile.RemoveTag(CurrentTagToChange);
        DoSyncStuffAfterTagEdit(CurrentlySelectedFile, backup);
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
    //if not assigned(MedienBib.CurrentAudioFile) then
    //    exit;

    backup := CurrentlySelectedFile.RawTagLastFM;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentlySelectedFile.Pfad)
    then
    begin
        if HandleIgnoreRule(CurrentTagToChange) then
        begin
            // update the current File NOW
            CurrentlySelectedFile.ChangeTag(CurrentTagToChange, '');
            // MedienBib.RelocateAudioFile(MedienBib.CurrentAudioFile); // (2023) will be done in Bib.ChangeTags
            DoSyncStuffAfterTagEdit(CurrentlySelectedFile, backup);
            // show the tags again.
            CreateTagLabels(CurrentlySelectedFile);
            // update all files, show hint to activate the Looooong procedure later.
            MedienBib.ChangeTags(CurrentTagToChange, '');
            MedienBib.RefreshCollections;
            SetGlobalWarningID3TagUpdate;
            // Set a warning in the tab button, if we are using the tag cloud right now for browsing
            //SetBrowseTabCloudWarning(True);
        end;
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);

end;

procedure TNemp_MainForm.PM_TagMergeListClick(Sender: TObject);
var backup: UTF8String;
    newTag: String;
begin
    //if not assigned(MedienBib.CurrentAudioFile) then
    //  exit;

    // the tag to ignore is stored in the global variable "CurrentTagToChange"
    backup := CurrentlySelectedFile.RawTagLastFM;

    if (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentlySelectedFile.Pfad)
    then
    begin
        if HandleMergeRule(CurrentTagToChange, newTag) then
        begin
            // update the current File NOW
            CurrentlySelectedFile.ChangeTag(CurrentTagToChange, newTag);
            // MedienBib.RelocateAudioFile(MedienBib.CurrentAudioFile);
            DoSyncStuffAfterTagEdit(CurrentlySelectedFile, backup);
            // show the tags again.
            CreateTagLabels(CurrentlySelectedFile);

            // update all files, show hint to activate the Looooong procedure later.
            MedienBib.ChangeTags(CurrentTagToChange, newTag);
            MedienBib.RefreshCollections;
            SetGlobalWarningID3TagUpdate;
            // Set a warning in the tab button, if we are using the tag cloud right now for browsing
            //SetBrowseTabCloudWarning(True);
        end;

    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;


procedure TNemp_MainForm.pm_TagShowInExplorerClick(Sender: TObject);
begin
  if {assigned(MedienBib.CurrentAudioFile) and} DirectoryExists(CurrentlySelectedFile.Ordner) then
  ShellExecute(Handle, 'open' ,'explorer.exe',
      PChar('/e,/select,"' + CurrentlySelectedFile.Pfad+'"'), '', sw_ShowNormal);
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
    //if not assigned(MedienBib.CurrentAudioFile) then
    //    exit;

    //Medienbib.BibSearcher.SearchOptions.SearchParam := 0;      // New Search
    Medienbib.BibSearcher.SearchOptions.AllowErrors := False;  // no errors allowed
    KeyWords.General   := '';
    KeyWords.Artist    := '';
    KeyWords.Album     := '';
    KeyWords.Titel     := '';
    KeyWords.Pfad      := '';
    KeyWords.Ordner    := '';
    KeyWords.Kommentar := '';
    KeyWords.Lyric     := '';

    Medienbib.BibSearcher.SearchOptions.SkipGenreCheck  := True;
    Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := True;


    case (Sender as TLabel).Tag of
        0: begin  // artist
            KeyWords.Artist := CurrentlySelectedFile.Artist;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        1: begin  // title  ... for cover songs and other versions?
            KeyWords.Titel := CurrentlySelectedFile.Titel;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        2: begin // album
            KeyWords.Album  := CurrentlySelectedFile.Album;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        4: begin // year
            Medienbib.BibSearcher.SearchOptions.SkipYearCheck  := False;
            Medienbib.BibSearcher.SearchOptions.WhichYearCheck := 2; // exact match

            Medienbib.BibSearcher.SearchOptions.MinMaxYear := strtointdef(CurrentlySelectedFile.Year, 0);
            Medienbib.BibSearcher.SearchOptions.IncludeNAYear := False;
            Medienbib.BibSearcher.SearchOptions.Include0Year := False;
            MedienBib.CompleteSearchNoSubStrings(Keywords);
        end;
        5: begin // genre
            tmpGenreList := TStringList.Create;
            try
                tmpGenreList.Add(CurrentlySelectedFile.Genre);
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
        6: begin // new: Directory
          KeyWords.Ordner := CurrentlySelectedFile.Ordner;
          MedienBib.CompleteSearchNoSubStrings(Keywords);

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
    try
      DetailID3TagPanel.DisableAlign;
      TagLabelList.Clear;
      DetailID3TagPanel.EnableAlign;
    except
      DetailID3TagPanel.EnableAlign;
    end;

    currentTop := LblBibDirectory.Top + LblBibDirectory.Height + 12;

    baseLeft := 8;
    currentLeft := baseleft;
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

                        newWidth := newLabel.Width;
                        newHeight:= newLabel.Height;

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
var CoverFileFound: Boolean;
    originalID, newID: String;
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

            CoverFileFound := TCoverArtSearcher.GetCover_Fast(aAudioFile, ImgDetailCover.Picture);

            // if the CoverIDFile wasn't found, but should be present: create it again
            // (just as it done in the coverflow as well)
            // Note: This will probably remove a manually set Cover for the library
            originalID := aAudioFile.CoverID;
            if (not CoverFileFound) and PreviewGraphicShouldExist(originalID) then
                RepairCoverFileVCL(originalID, aAudioFile, ImgDetailCover.Picture, newID);

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
        RefreshVSTCover(CurrentlySelectedFile);

    if assigned(MedienBib) then
        CreateTagLabels(CurrentlySelectedFile);
end;

procedure TNemp_MainForm.RefreshVSTDetailsTimerTimer(Sender: TObject);
var
  aNode: PVirtualNode;
  aVST: TVirtualStringTree;
  AudioFile, CueParentFile: TAudioFile;
begin
  RefreshVSTDetailsTimer.Enabled := False;
  if (RefreshVSTDetailsTimer.Tag = SD_MEDIENBIB) then
    aVST := VST
  else
    aVST := PlaylistVST;

  aNode := aVST.FocusedNode;
  if not Assigned(aNode) then
    exit;

  AudioFile := aVST.GetNodeData<TAudioFile>(aNode);

  if (RefreshVSTDetailsTimer.Tag = SD_MEDIENBIB) then
  begin
    // Show Details from Medialibrary
    if AudioFile.IsLocalFile then
        AudioFile.ReCheckExistence;

    ShowVSTDetails(AudioFile, SD_MEDIENBIB);
    ShowDetailForm(AudioFile, False);
  end else
  begin
    // Show Details from Playlist
    if AudioFile.AudioType = at_Cue then
      CueParentFile := AudioFile.Parent
    else
      CueParentFile := AudioFile;

    if aVST.GetNodeLevel(aNode) = 0 then
      NempPlaylist.RefreshAudioFile(aNode.Index, false);

    ShowVSTDetails(AudioFile, SD_PLAYLIST);
    ShowDetailForm(CueParentFile, False);

    if assigned(FormPlaylistDuplicates)
      and FormPlaylistDuplicates.Visible
    then
      FormPlaylistDuplicates.ShowDuplicateAnalysis(CueParentFile);
  end;
end;

procedure TNemp_MainForm.CDDBConsistencyCheck(af: TAudioFile);
var
  cddbID: UTF8String;
  DriveNo: Integer;
begin
  cddbID := TCDDADrive.GetDriveCDDBID(af.Pfad);
  if (cddbID = '') or (String(cddbID) <> af.Comment) then begin
    DriveNo := TCDDADrive.GetDriveNumber(af.Pfad);
    if (DriveNo < 0) or (DriveNo >= CDDriveList.Count) then begin
      // Invalid Drive, probably an disconnected external CDDrive. What to do in this case?
      // (nothing for now)
    end
    else begin
      // Drive exists
      CDDriveList[DriveNo].ClearDiscInformation;
      CDDriveList[DriveNo].GetDiscInformation(NempOptions.UseCDDB, NempOptions.PreferCDDB);
      NempPlaylist.SynchFilesWithCDDrive(CDDriveList[DriveNo]);
    end;
  end;
end;

procedure TNemp_MainForm.ShowVSTDetails(aAudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
var DoShowDetails, SameFile: Boolean;
    MainFile: TAudioFile;
begin
  if assigned(aAudioFile) and assigned(aAudioFile.Parent) then
    MainFile := aAudioFile.Parent
  else
    MainFile :=  aAudioFile;

  // SameFile: Show Information about different Cue, even if the display is locked
  // to only the currently playing file
  SameFile := CurrentlySelectedFile = MainFile;

  case Source of
      -1: DoShowDetails := True;
      SD_PLAYLIST, SD_MEDIENBIB: DoShowDetails := (NempOptions.VSTDetailsLock = 0) or SameFile;
      SD_PLAYER:                 DoShowDetails := (NempOptions.VSTDetailsLock = 1) or SameFile;
  else
      DoShowDetails := False;
  end;

  if not DoShowDetails then
    exit;

  CurrentlySelectedFile := MainFile;
  if Source <> - 1 then
      pm_TagDetails.Tag := Source;

  LblBibArtist  .Visible :=  assigned(aAudioFile);
  LblBibTitle   .Visible :=  assigned(aAudioFile);
  LblBibAlbum   .Visible :=  assigned(aAudioFile);
  LblBibYear    .Visible :=  assigned(aAudioFile);
  LblBibGenre   .Visible :=  assigned(aAudioFile);
  lblBibDirectory.Visible :=  assigned(aAudioFile);
  lblBibFilename .Visible :=  assigned(aAudioFile);
  LblBibDuration    .Visible :=  assigned(aAudioFile);
  LblBibPlayCounter .Visible :=  assigned(aAudioFile);
  LblBibQuality     .Visible :=  assigned(aAudioFile);
  LblBibReplayGain  .Visible :=  assigned(aAudioFile);

  ImgBibRating  .Visible :=  assigned(aAudioFile);

  // check, whether the current cd is valid for the AudioFile-Object
  // this is VERY important for the cover-downloading:
  // if album-Artist-data does not match the cddb-id, a wrong cover will be downloaded
  // and displayed permanently
  if assigned(MainFile) and (MainFile.isCDDA) then
    CDDBConsistencyCheck(MainFile);

  FillBibDetailLabels(aAudioFile);
  CreateTagLabels(MainFile);

  // Get Cover
  RefreshVSTCover(MainFile);

  if assigned(MainFile) and (trim(String(MainFile.Lyrics)) <> '') then   // put this into RefreshVSTCover-Method???
      LyricsMemo.Text := String(MainFile.Lyrics)
  else
      LyricsMemo.Text := MainForm_Lyrics_NoLyrics;

  if not assigned(MainFile) then
       exit;

  case aAudioFile.AudioType of
      at_File: begin
          ImgBibRating.Visible := True;
          LblBibDuration   .Caption := NempDisplay.SummaryDurationSize(aAudioFile);
          LblBibQuality    .Caption := NempDisplay.SummaryQuality(aAudioFile);
          LblBibPlayCounter.Caption := NempDisplay.SummaryPlayCounter(aAudioFile);
          LblBibReplayGain .Caption := NempDisplay.SummaryReplayGain(aAudioFile);

          BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
      end;

      at_Cue: begin
            ImgBibRating.Visible := False;
            LblBibDuration  .Caption := NempDisplay.SummaryDurationSizeCue(aAudioFile, MainFile);
            LblBibQuality   .Caption := NempDisplay.SummaryQuality(MainFile);
            LblBibReplayGain.Caption := NempDisplay.SummaryReplayGain(MainFile);
            LblBibPlayCounter.Caption := '';
            // BibRatingHelper.DrawRatingInStarsOnBitmap(aAudioFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height);
      end;

      at_Stream: begin
          ImgBibRating.Visible := False;
          LblBibDuration  .Caption := '';
          LblBibPlayCounter.Caption := '';
          LblBibQuality.Caption := '';
          LblBibReplayGain.Caption := '';
      end;

      at_CDDA: begin
          ImgBibRating.Visible := False;
          LblBibDuration  .Caption := NempDisplay.SummaryDuration(MainFile) ;
          LblBibQuality.Caption := NempDisplay.SummaryQuality(aAudioFile); //'CD-Audio';
          LblBibPlayCounter.Caption := '';
          LblBibReplayGain.Caption := '';
      end;
  end;
end;

procedure TNemp_MainForm.ImgDetailCoverDblClick(Sender: TObject);
begin
    // if assigned(MedienBib.CurrentAudioFile) then
      MedienBib.GenerateAlbumAnzeigeListe(CurrentlySelectedFile);
      //ShowDetailForm(MedienBib.CurrentAudioFile, True);
end;

procedure TNemp_MainForm.ImgDetailCoverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CoverImgDownX := X;
    CoverImgDownY := Y;
end;

procedure TNemp_MainForm.ImgDetailCoverMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  af: TAudioFile;
  DateiListe: TAudioFileList;
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
              af := CurrentlySelectedFile
          else
              af := Nil;

          if Assigned(af) then
          begin
            Dateiliste := TAudioFileList.Create(False);
            try
              if ssShift in shift then
                MedienBib.GetAlbumTitelListFromAudioFile(Dateiliste, af) // get all files for this "Album"
              else
                Dateiliste.Add(af); // add just the current file

              InitiateDragDrop(DateiListe, ImgDetailCover, fDropManager, True, False);
            finally
              FreeAndNil(Dateiliste);
            end;

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
var ListOfFiles: TAudioFileList;
    listFile: TAudioFile;
    i, newRating: Integer;
    aErr: TNempAudioError;
begin
    if      (not NempSkin.NempPartyMode.DoBlockTreeEdit)
        and (Button = mbLeft)
    then
    begin
        if // Assigned(MedienBib.CurrentAudioFile) and
           (MedienBib.StatusBibUpdate <= 1)
           and (MedienBib.CurrentThreadFilename <> CurrentlySelectedFile.Pfad)
        then
        begin
              // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
              CurrentlySelectedFile.GetAudioData(CurrentlySelectedFile.Pfad);
              ListOfFiles := TAudioFileList.Create(False);
              try
                  // get List of this AudioFile
                  GetListOfAudioFileCopies(CurrentlySelectedFile, ListOfFiles);
                  newRating := BibRatingHelper.MousePosToRating(x, ImgBibRating.Width);
                  // edit all these files
                  for i := 0 to ListOfFiles.Count - 1 do
                  begin
                      listFile := ListOfFiles[i];
                      listFile.Rating := newRating;
                  end;
                  // write the rating into the file on disk
                  // aErr := MedienBib.CurrentAudioFile.SetAudioData(NempOptions.AllowQuickAccessToMetadata);
                  aErr := CurrentlySelectedFile.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);
                  HandleError(afa_SaveRating, CurrentlySelectedFile, aErr);
                  
                  MedienBib.Changed := True;
              finally
                  ListOfFiles.Free;
              end;
              // Correct GUI (player, Details, Detailform, VSTs))
              CorrectVCLAfterAudioFileEdit(CurrentlySelectedFile);
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
        if Assigned(CurrentlySelectedFile) then
            BibRatingHelper.DrawRatingInStarsOnBitmap(CurrentlySelectedFile.Rating, ImgBibRating.Picture.Bitmap, ImgBibRating.Width, ImgBibRating.Height)
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


function TNemp_MainForm.NempFileType(filename: UnicodeString): TNempFileType;
var Extension: string;
begin
  Extension := AnsiLowerCase(ExtractFileExt(filename));
  result := nftUnknown;
  if (Extension = '.m3u') OR (Extension = '.m3u8')
      OR (Extension = '.pls') OR (Extension = '.npl')
      OR (Extension = '.asx') OR (Extension = '.wax')
      // OR (Extension = '.cue') OR (Extension = '.gmp')
  then
    result := nftPlaylist
  else
    if extension = '.cue' then
      result := nftCUE
    else
      if extension = '.cda' then
        result := nftCDDA
      else
        if NempPlayer.ValidExtensions.IndexOf(extension) > -1 then
          result := nftSupported
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
  else // Aufnahme in die Medienliste verlangt, und nicht "alles rein" in den Optionen gew�hlt
  // also genauer pr�fen
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

(* Disabled for now (06.2022)
procedure TNemp_MainForm.PM_ML_GetLyricsClick(Sender: TObject);
var i: Integer;
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
            MedienBib.UpdateList.Add(VST.GetNodeData<TAudioFile>(SelectedMP3s[i]));

        MedienBib.GetLyrics;
    end;
end;
*)


procedure TNemp_MainForm.PM_ML_GetTagsClick(Sender: TObject);
var i: integer;
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
            MedienBib.UpdateList.Add(VST.GetNodeData<TAudioFile>(SelectedMp3s[i]));

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
end;

procedure TNemp_MainForm.PlaylistVSTAfterItemPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var af: TAudioFile;
begin
  with TargetCanvas do
  begin
      af := PlaylistVST.GetNodeData<TAudioFile>(Node);
      if (af = NempPlaylist.PlayingFile) Or (af = NempPlaylist.PlayingCue) then
      begin
        if NempSkin.isActive then
            Pen.Color := NempSkin.SkinColorScheme.PlaylistPlayingFileColor
        else
            Pen.Color := clWindowText; //clGradientActiveCaption;
        pen.Width := 1;  //2 //3;  // 1 is enough, and looks better on some skins, imho.

        Polyline([Point(ItemRect.Left+1 {+ (Integer(PlaylistVST.Indent) * Integer(PlaylistVST.GetNodeLevel(Node)))}, ItemRect.Top+1),
              Point(ItemRect.Left+1 {+ (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node)))}, ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Bottom-1),
              Point(ItemRect.Right-1, ItemRect.Top+1),
              Point(ItemRect.Left+1 {+ (Integer(PlaylistVST.Indent * PlaylistVST.GetNodeLevel(Node)))}, ItemRect.Top+1)]
              );
      end;
  end;
end;

procedure TNemp_MainForm.StringVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  if NempOrganizerSettings.ShowElementCount then
    CellText := lc.CaptionCount //Format('%s (%d)', [lc.Name, lc.ItemCount]);
  else
    CellText := lc.Caption;
end;

procedure TNemp_MainForm.AlbenVSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  ac: TAudioCollection;
begin
  if not NempOrganizerSettings.ShowCoverArtOnAlbum then
    exit;
  case Kind of
    ikNormal, ikSelected: begin
          ac := AlbenVST.GetNodeData<TAudioCollection>(Node);
          if assigned(ac) and (ac.CoverID <> '') then
            ImageIndex := 0;
            end;
  end;
end;

procedure TNemp_MainForm.AlbenVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  ac: TAudioCollection;
begin
  ac := Sender.GetNodeData<TAudioCollection>(Node);
  CellText := ac.Caption;
end;


procedure TNemp_MainForm.AddCollection(aCollection: TAudioCollection;
  aNode: PVirtualNode; OnlySearchResults: Boolean = False);
var
  i: Integer;
  subCollectionNode: PVirtualNode;
  subCollection: TAudioCollection;
begin
  if aCollection.WantCombine then begin
    subCollection := aCollection.Collection[0];
    if (not OnlySearchResults) or subCollection.MatchesCurrentSearch then begin
      // AlbenVST.SetNodeData<TAudioCollection>(aNode, subCollection);
      AddCollection(subCollection, aNode, OnlySearchResults)
    end;
  end else begin
    for i := 0 to aCollection.CollectionCount - 1 do
    begin
      subCollection := aCollection.Collection[i];
      if (not OnlySearchResults) or subCollection.MatchesCurrentSearch then begin
        subCollectionNode := AlbenVST.AddChild(aNode, subCollection);
        AddCollection(subCollection, subCollectionNode, OnlySearchResults)
      end;
    end;
  end;
end;

function TNemp_MainForm.GetFocussedCategory: TLibraryCategory;
var
  aNode: PVirtualNode;
begin
  aNode := ArtistsVST.FocusedNode;
  if Assigned(aNode) then
    result := ArtistsVST.GetNodeData<TLibraryCategory>(aNode)
  else
    result := Nil;
end;

function TNemp_MainForm.GetFocussedCollection: TAudioCollection;
var
  aNode: PVirtualNode;
begin
  aNode := AlbenVST.FocusedNode;
  if Assigned(aNode) then
    result := AlbenVST.GetNodeData<TAudioCollection>(aNode)
  else
    result := Nil;
end;

procedure TNemp_MainForm.Medialist_Browse_Categories_PopupMenuPopup(
  Sender: TObject);
begin
  ReFillCategoryMenu;
end;

procedure TNemp_MainForm.ReFillCategoryMenu;
var
  i: Integer;
  aMenuItem: TMenuItem;
begin
  Medialist_Browse_Categories_PopupMenu.Items.Clear;
  // File-Categories
  for i := 0 to Medienbib.FileCategories.Count - 1 do begin
    aMenuItem := TMenuItem.Create(Nemp_MainForm);
    aMenuItem.OnClick := CoverFlowCategoryMenuItemClick;
    aMenuItem.Caption := MedienBib.FileCategories[i].CaptionCount;
    aMenuItem.Checked := MedienBib.FileCategories[i] = MedienBib.CurrentCategory;
    aMenuItem.Tag := i;
    Medialist_Browse_Categories_PopupMenu.Items.Add(aMenuItem);
  end;
  if MedienBib.BrowseMode <> 2  then begin
    // Playlists-Categories
    if NempOrganizerSettings.ShowPlaylistCategories then
      for i := 0 to MedienBib.PlaylistCategories.Count - 1 do begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := CoverFlowCategoryMenuItemClick;
        aMenuItem.Caption := MedienBib.PlaylistCategories[i].CaptionCount;
        aMenuItem.Checked := MedienBib.PlaylistCategories[i] = MedienBib.CurrentCategory;
        aMenuItem.Tag := 1000 + i;
        Medialist_Browse_Categories_PopupMenu.Items.Add(aMenuItem);
      end;
    // Webradio-Category
    if NempOrganizerSettings.ShowWebradioCategory then begin
      aMenuItem := TMenuItem.Create(Nemp_MainForm);
      aMenuItem.OnClick := CoverFlowCategoryMenuItemClick;
      aMenuItem.Caption := MedienBib.WebRadioCategory.CaptionCount;

      aMenuItem.Checked := MedienBib.WebRadioCategory = MedienBib.CurrentCategory;
      aMenuItem.Tag := 2000;
      Medialist_Browse_Categories_PopupMenu.Items.Add(aMenuItem);
    end;
  end;
end;

procedure TNemp_MainForm.ReFillCategoryTree(RemarkOldNodes: LongBool);
var
  i: Integer;
  oldNode: PVirtualNode;
begin
  ArtistsVST.BeginUpdate;
  ArtistsVST.Clear;

  for i := 0 to MedienBib.FileCategories.Count - 1 do
    ArtistsVST.AddChild(Nil, MedienBib.FileCategories[i]);

  if NempOrganizerSettings.ShowPlaylistCategories then
    for i := 0 to MedienBib.PlaylistCategories.Count - 1 do
      ArtistsVST.AddChild(Nil, MedienBib.PlaylistCategories[i]);

  if NempOrganizerSettings.ShowWebradioCategory then
    ArtistsVST.AddChild(Nil, MedienBib.WebRadioCategory);

  if RemarkOldNodes then
    oldNode := GetOldNode(MedienBib.CurrentCategory, ArtistsVST)
  else
    oldNode := ArtistsVST.GetFirst;

  ArtistsVST.ScrollIntoView(oldNode, True);
  ArtistsVST.FocusedNode := oldNode;
  ArtistsVST.Selected[oldNode] := True;

  ArtistsVST.EndUpdate;
end;


procedure TNemp_MainForm.RefreshCollectionTreeHeader(Source: TLibraryCategory);
begin
  if not assigned(Source) then
    AlbenVST.Header.Columns[0].Text := ''
  else begin
    AlbenVST.Header.Columns[0].Text := Format('%s (%d)', [Source.Caption, Source.ItemCount]);
   { case Source.CategoryType of
      ccFiles: AlbenVST.Header.Columns[0].Text := Format('%s (%d)', [TreeHeader_CatFiles, Source.ItemCount]);
      ccPlaylists: AlbenVST.Header.Columns[0].Text := Format('%s (%d)', [TreeHeader_CatPlaylists, Source.ItemCount]);
      ccWebStations: AlbenVST.Header.Columns[0].Text := Format('%s (%d)', [TreeHeader_CatWebRadio, Source.ItemCount]);
    else
      AlbenVST.Header.Columns[0].Text := '';
    end;}
  end;
end;

procedure TNemp_MainForm.CoverFlowCategoryMenuItemClick(Sender: TObject);
var
  TagDiv, TagMod: Integer;
  aCat: TLibraryCategory;
begin
  TagDiv := (Sender as TMenuItem).Tag Div 1000;
  TagMod := (Sender as TMenuItem).Tag Mod 1000;

  aCat := Nil;
  case TagDiv of
    0: if TagMod < MedienBib.FileCategories.Count then
      aCat := MedienBib.FileCategories[TagMod];
    1: if TagMod < MedienBib.PlaylistCategories.Count then
      aCat := MedienBib.PlaylistCategories[TagMod];
    2: aCat := MedienBib.WebRadioCategory;
  end;

  case MedienBib.BrowseMode of
    0: ; // nothing to do. Category-Selection is done by the treeview, not the Popup
    1: FillCollectionCoverflow(aCat, True);
    2: FillCollectionTagCloud(aCat, True);
  end;

end;

procedure TNemp_MainForm.FillCollectionCoverflow(Source: TLibraryCategory; RemarkOldNodes: LongBool);
begin
  if assigned(Source) then
    MedienBib.CurrentCategory := Source
  else begin
    if MedienBib.FileCategories.Count > 0 then
      MedienBib.CurrentCategory := MedienBib.FileCategories[0]
    else
      MedienBib.CurrentCategory := Nil;
  end;

  if assigned(MedienBib.CurrentCategory) then begin
    MedienBib.NewCoverFlow.SetNewList(MedienBib.CurrentCategory);
    MedienBib.CoverArtSearcher.PrepareMainCover(MedienBib.CurrentCategory);
    SetCoverFlowScrollbarRange(MedienBib.NewCoverFlow.CoverCount);
    if RemarkOldNodes then begin
      CoverScrollbar.Position := MedienBib.NewCoverFlow.GetCollectionIndex(MedienBib.CurrentCategory.FindLastCollectionAgain);
      //MedienBib.NewCoverFlow.CurrentItem
    end
    else
      CoverScrollbar.Position := 0;

    CoverScrollbarChange(Nil);
    MedienBib.NewCoverFlow.Paint(50);
  end;
end;

procedure TNemp_MainForm.FillCollectionTagCloud(Source: TLibraryCategory; RemarkOldNodes: LongBool);
var
  lastSelectedCollection: TAudioCollection;
  ParentCol, FocusCol: TAudioFileCollection;
  LastKeyFound,
  ExpandLastKey: Boolean;
begin
  if assigned(Source) and (Source.CategoryType = ccFiles) then
    MedienBib.CurrentCategory := Source
  else begin
    if MedienBib.FileCategories.Count > 0 then
      MedienBib.CurrentCategory := MedienBib.FileCategories[0]
    else
      MedienBib.CurrentCategory := Nil;
  end;

  if assigned(MedienBib.CurrentCategory) then begin
    lastSelectedCollection := Nil;
    if RemarkOldNodes then
      lastSelectedCollection := TLibraryFileCategory(MedienBib.CurrentCategory).FindLastCollectionAgainTagCloud(LastKeyFound, ExpandLastKey);
    if not assigned(lastSelectedCollection) then
      lastSelectedCollection := MedienBib.CurrentCategory.Collections[0];
     // das ergab grade ne AV .... au�erhalb des g�ltigen bereichs
      //wenn eine leere Categorie gew�hlt ist

    if not LastKeyFound or ExpandLastKey then begin
      TAudioFileCollection(lastSelectedCollection).ExpandTagCloud;
      CloudViewer.Collection := TAudioFileCollection(lastSelectedCollection);
    end else
    begin
      ParentCol := TAudioFileCollection(lastSelectedCollection).Parent;
      if assigned(ParentCol) {and (ParentCol.CollectionType <> ctRoot)} then begin
        CloudViewer.Collection := ParentCol;
      end else
      begin
        TAudioFileCollection(lastSelectedCollection).ExpandTagCloud;
        CloudViewer.Collection := TAudioFileCollection(lastSelectedCollection);
      end;
    end;

    CloudViewer.PaintCloud;
    FocusCol := TAudioFileCollection(lastSelectedCollection);
    if not assigned(FocusCol) then
      FocusCol := CloudViewer.GetFirstNewCollection;
    CloudViewer.FocussedCollection := FocusCol;
    MedienBib.GenerateAnzeigeListe(FocusCol);
  end;
end;

procedure TNemp_MainForm.FillCollectionTree(Source: TLibraryCategory; RemarkOldNodes: LongBool; OnlySearchResults: Boolean = False);
var
  rootNode, oldNode: PVirtualNode;
  i: Integer;
  ac, lastSelectedCollection: TAudioCollection;
begin
  if not assigned(Source) then
    source := GetFocussedCategory;

  RefreshCollectionTreeHeader(Source);

  if assigned(Source) then begin
    MedienBib.CurrentCategory := Source;

    // Get lastSelectedCollection first.
    // This may create some more layers of sub-collections which the tree should also display
    lastSelectedCollection := Source.FindLastCollectionAgain;
    // Fill the treeview

    AlbenVST.BeginUpdate;
    VST.BeginUpdate;
    VST.Clear;
    AlbenVST.Clear;
    for i := 0 to Source.CollectionCount - 1 do begin
      rootNode := AlbenVST.AddChild(Nil, Source.Collections[i]);
      AddCollection(Source.Collections[i], rootNode, OnlySearchResults);
    end;
    VST.EndUpdate;
    AlbenVST.EndUpdate;

    // Get the node with lastSelectedCollection
    if RemarkOldNodes then
      oldNode := GetOldNode(lastSelectedCollection, AlbenVST)
    else
      oldNode := AlbenVST.GetFirst;

    // neuen (alten) Knoten (wieder) focussieren
    AlbenVST.ScrollIntoView(oldNode, True);
    AlbenVST.FocusedNode := oldNode;
    AlbenVST.Selected[oldNode] := True;
    AlbenVST.Expanded[oldNode] := True;

    if not assigned(oldNode) then
      ShowSummary
    else begin
      ac := AlbenVST.GetNodeData<TAudioCollection>(oldNode);
      if assigned(ac) then
        MedienBib.GenerateAnzeigeListe(ac);
    end;
  end;
end;

procedure TNemp_MainForm.ClearBrowseTrees;
begin
  case MedienBib.BrowseMode of
    0: begin
        ArtistsVST.Clear;
        AlbenVST.Clear;
    end;
    1: begin
        MedienBib.NewCoverFlow.Clear;
    end;
    2: begin
      CloudViewer.Clear;
      CloudViewer.Repaint;
    end;
  end;
end;

procedure TNemp_MainForm.ReFillBrowseTrees(RemarkOldNodes: LongBool);
begin
  case MedienBib.BrowseMode of
      0:  begin
                // erneuert nach einer Einf�ge/L�sch/Edit-aktion die oberen beiden Listen
                // die alten Knoten werden nach M�glichkeit wieder selektiert/focussiert
                // Change auf Nil setzen
                ArtistsVST.OnFocusChanged := NIL;
                AlbenVST.OnFocusChanged := NIL;
                // refill Trees
                ReFillCategoryTree(RemarkOldNodes);
                FillCollectionTree({Nil,}MedienBib.CurrentCategory, RemarkOldNodes);
                // Change wieder umsetzen
                ArtistsVST.OnFocusChanged := ArtistsVSTFocusChanged;
                AlbenVST.OnFocusChanged := AlbenVSTFocusChanged;
      end;
      1: begin
                // Coverflow
                ReFillCategoryMenu;
                FillCollectionCoverflow(MedienBib.CurrentCategory, RemarkOldNodes);
      end;
      2: begin
                ReFillCategoryMenu;
                FillCollectionTagCloud(MedienBib.CurrentCategory, RemarkOldNodes);
      end;
  end;
  SetBrowseTabWarning(False);
  // SetBrowseTabCloudWarning(False);
end;


procedure TNemp_MainForm.RefreshCoverFlowTimerTimer(Sender: TObject);
//var
//  i: Integer;
begin
    RefreshCoverFlowTimer.Enabled := False;
    if Not MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow then
        exit;

    case MedienBib.BrowseMode of
      {0: begin
        for i := 0 to MedienBib.CurrentCategory.CollectionCount - 1 do
          MedienBib.CurrentCategory.Collections[i].PerformSearch(EDITFastSearch.Text, False);

        FillCollectionTree(MedienBib.CurrentCategory, True, True);

      end;}
      1: begin
        MedienBib.GenerateCoverCategoryFromSearchresult(MedienBib.AnzeigeListe);
        MedienBib.NewCoverFlow.ClearTextures;
        MedienBib.NewCoverFlow.SetNewList(MedienBib.CoverSearchCategory);
        MedienBib.CoverArtSearcher.PrepareMainCover(MedienBib.CoverSearchCategory);
        CoverScrollbar.OnChange := Nil;
        SetCoverFlowScrollbarRange(MedienBib.NewCoverFlow.CoverCount);
        CoverScrollbar.Position := MedienBib.NewCoverFlow.GetCollectionIndex(MedienBib.CoverSearchCategory.FindLastCollectionAgain);
        CoverScrollbar.OnChange := CoverScrollbarChange;
        CoverScrollbarChange(Nil);
        MedienBib.NewCoverFlow.Paint(1);
      end;
      {2: begin
        CloudViewer.PaintCloud(EDITFastSearch.Text);
      end;}
    end;
end;

procedure TNemp_MainForm.ArtistsVSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.font.Style := NempOptions.ArtistAlbenFontStyles;

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
var
  aNode: PVirtualNode;
  lc: TLibraryCategory;
begin
  aNode := ArtistsVST.FocusedNode;
  if not Assigned(aNode) then
      Exit;

  lc := ArtistsVST.GetNodeData<TLibraryCategory>(Node);
  if assigned(lc) then begin
    FillCollectionTree(lc, True);

    if assigned(RandomPlaylistForm)
      and RandomPlaylistForm.Visible
    then
      RandomPlaylistForm.RefillTagListFromMainWindow;
  end;
end;

procedure TNemp_MainForm.ArtistsVSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  lc: TLibraryCategory;
begin
  // Used for next Search with "F3"
  OldSelectionPrefix := SearchText;
  lc := ArtistsVST.GetNodeData<TLibraryCategory>(Node);
  Result := StrLIComp(PChar(SearchText), PChar(lc.Name), length(SearchText));
end;

procedure TNemp_MainForm.AlbenVSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: string; var Result: Integer);
var
  ac: TAudioCollection;
begin
  // Used for next Search with "F3"
  OldSelectionPrefix := SearchText;
  ac := AlbenVST.GetNodeData<TAudioCollection>(Node);
  Result := ac.ComparePrefix(SearchText);
  //StrLIComp(PChar(SearchText), PChar(ac.Caption), length(SearchText));
end;

procedure TNemp_MainForm.AlbenVSTMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var
  ac: TAudioCollection;
begin
  if not assigned(Node) then
    exit;

  if not NempOrganizerSettings.ShowCoverArtOnAlbum then
    NodeHeight := AlbenVST.DefaultNodeHeight
  else
  begin
    ac := AlbenVST.GetNodeData<TAudioCollection>(Node);
    if assigned(ac) and (ac.CoverID <> '') then begin
      NodeHeight := CoverManager.CoverSize + (2* CoverManager.VerticalMargin);
      Node.States := Node.States + [vsMultiline];
    end
    else
      NodeHeight := AlbenVST.DefaultNodeHeight;
  end;
end;


procedure TNemp_MainForm.AlbenVSTDrawText(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  aGraphic: TGraphic;
  ac: TAudioCollection;
  y: Integer;
  success: Boolean;
  newID: String;
begin
  if not NempOrganizerSettings.ShowCoverArtOnAlbum then
    exit;

  ac := AlbenVST.GetNodeData<TAudioCollection>(Node);

  if assigned(ac) and (ac.CoverID <> '') then begin
      aGraphic := CoverManager.GetCachedCover(ac.CoverID, success).Graphic;
      if (not success) and PreviewGraphicShouldExist(ac.CoverID) then
      begin
        if RepairCoverFileVCL(ac.CoverID, Nil, Nil, newID) and (ac.CoverID <> newID) then
          ac.ApplyNewCoverID(newID);
        // try again after repair
        aGraphic := CoverManager.GetCachedCover(ac.CoverID, success).Graphic;
      end;
      y := Max((Cellrect.Height - aGraphic.Height) Div 2, 0);
      TargetCanvas.Draw(CellRect.Left - CoverManager.CoverOffset, y, aGraphic);

     if (not success) and (MedienBib.CoverSearchLastFM) then
        CoverDownloadThread.AddJob(ac, Node.Index, qtTreeView);
  end;
end;

procedure TNemp_MainForm.AlbenVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var 
  ac: TAudioCollection;
begin
  if not assigned(node) then begin
    ShowSummary;
    exit;
  end;

  ac := AlbenVST.GetNodeData<TAudioCollection>(Node);
  if assigned(ac) then begin
    MedienBib.GenerateAnzeigeListe(ac);
  end;
end;


procedure TNemp_MainForm.StringVSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var ScrollNode: PVirtualNode;
  erfolg:boolean;
  aTree: TVirtualStringTree;
  ac: TAudioCollection;

      function GetStringNodeWithPrefix(aTree: TVirtualStringTree; StartNode:PVirtualNode; Prefix:string; var Erfolg:boolean):PVirtualNode;
      // erfolg gibt an, ob man beim kompletten Durchlauf des Baumes einen weiteren Knoten mit den
      // gew�nschten Eigenschaften gefunden hat.
      // Wenn man beim Startknoten wieder ankommt, gibt es keinen (weiteren) Knoten mit dem
      // entsprechenden Prefix.
      var nextNode:PVirtualnode;
          aString: UnicodeString;
      begin
          erfolg := false;
          nextNode := StartNode;
          repeat
            ac := AlbenVST.GetNodeData<TAudioCollection>(nextnode);
            aString := ac.Caption;

            erfolg := ac.MatchPrefix(Prefix);
            //AnsiStartsText(Prefix, aString);
            result := nextNode;
            // n�chsten Knoten w�hlen
            nextNode := aTree.GetNext(nextnode);
            // oder vorne wieder anfangen
            if nextNode = NIL then
              nextNode := aTree.GetFirst;
          until erfolg or (nextNode = StartNode);
          if not erfolg then result := nextNode;
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
      ac := AlbenVST.GetNodeData<TAudioCollection>(AlbenVST.FocusedNode);
      CollectionDblClick(ac, AlbenVST.FocusedNode, AlbenVST);
    end;
  end;
end;


procedure TNemp_MainForm.AlbenVSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
var
  albumNode: PVirtualNode;
  ac: TAudioCollection;
begin
  // Sinn: Zeige alle Titel eines Albums an.
  albumNode := AlbenVST.FocusedNode;
  if not Assigned(albumNode) then
    exit;

  ac := AlbenVST.GetNodeData<TAudioCollection>(albumNode);
  CollectionDblClick(ac, AlbenVST.FocusedNode, AlbenVST);
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
var af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if not assigned(af) then exit;

  case Column of
    0: CellText := NempDisplay.TreeAudioFileIndex(af, Node.Index + 1);
    1: CellText := NempDisplay.PlaylistTitle(af, True);
    2: CellText := NempDisplay.TreeDuration(af)
    // the NempDisplay methods will handle PrebookIndex/VoteCounter and start times for Cue-Entries
  end;
end;

procedure TNemp_MainForm.PlaylistVSTColumnDblClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
    InitiateFocussedPlay(PlaylistVST);
    Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
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

procedure TNemp_MainForm.TogglePlayPause(WantDialog: Boolean);
var
  fNode: PVirtualNode;
begin
  NempPlaylist.UserInput;
  if WantDialog
      and (NempPlayer.MainStream = 0)
      and (NempPlaylist.Count = 0)
      and (not assigned(NempPlaylist.PlayingFile))
  then begin
      MM_PL_FilesClick(NIL);
      exit;
  end;

  if NempPlayer.MainStream = 0 then begin
    NempPlayer.LastUserWish := USER_WANT_PLAY;
    fNode := PlaylistVST.FocusedNode;
    if assigned(fNode) then begin
      if PlaylistVST.GetNodeLevel(fNode) <> 0 then
          fNode := PlaylistVST.NodeParent[fNode];
      NempPlaylist.Play(fNode.Index, NempPlayer.FadingInterval, True);
    end else
        NempPlaylist.Play(-1, NempPlayer.FadingInterval, True);
  end
  else
    NempPlaylist.TogglePlayPause(True);

  Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
  PlaylistVST.Invalidate;
end;

procedure TNemp_MainForm.PlayPauseBTNIMGClick(Sender: TObject);
begin
  TogglePlayPause(True);
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
    NempPlayer.PlayInHeadset(CurrentlySelectedFile);
    // Show Details
    DisplayHeadsetTitleInformation(False);
end;

procedure TNemp_MainForm.StopHeadSetBtnClick(Sender: TObject);
begin
    NempPlayer.StopHeadset;
end;

procedure TNemp_MainForm.PM_PlayCDAudioClick(Sender: TObject);
var CurrentIdx, i: Integer;
  newFile: TAudioFile;
begin
    CurrentIdx := NempPlaylist.Count; // CurrentIdx ist der erwartete Index des ersten neu eingef�gten Files

    if not assigned(CDOpenDialog) then
        Application.CreateForm(TCDOpenDialog, CDOpenDialog);

    if CDOpenDialog.ShowModal = mrOK then
    begin
        for i := 0 to CDOpenDialog.SelectedFiles.Count - 1 do begin
          newFile := TAudioFile.Create;
          newFile.Assign(CDOpenDialog.SelectedFiles[i]);
          NempPlaylist.AddFileToPlaylist(newFile);
        end;
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
var ListOfFiles: TAudioFileList;
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

                  ListOfFiles := TAudioFileList.Create(False);
                  try
                      // get List of this AudioFile
                      GetListOfAudioFileCopies(NempPlayer.MainAudioFile, ListOfFiles);
                      newRating := PlayerRatingGraphics.MousePosToRating(x, RatingImage.Width);
                      // edit all these files
                      for i := 0 to ListOfFiles.Count - 1 do
                      begin
                          listFile := ListOfFiles[i];
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
var i:integer;
  Selectedmp3s: TNodeArray;
  NewSelectNode: PVirtualNode;
  allNodesDeleted: Boolean;
begin
    // get the selected Nodes
    Selectedmp3s := PlaylistVST.GetSortedSelection(False);
    if length(SelectedMp3s) = 0 then
        exit;

    // determine a Node we want to select after removing the selected files
    NewSelectNode := PlaylistVST.GetNextSibling(Selectedmp3s[length(Selectedmp3s)-1]);
    if not Assigned(NewSelectNode) then
        NewSelectNode := PlaylistVST.GetPreviousSibling(Selectedmp3s[0]);

    PlaylistVST.BeginUpdate;
    allNodesDeleted := True;
    // remove all selected Nodes
    for i := length(Selectedmp3s)-1 downto 0 do
    begin
      // Nodes mit Level 1 (CueInfos) werden nicht gel�scht
      if PlaylistVST.GetNodeLevel(Selectedmp3s[i])=0 then
          NempPlaylist.DeleteAudioFileFromPlaylist(Selectedmp3s[i].Index)
      else
          allNodesDeleted := False;
    end;
    PlaylistVST.EndUpdate;

    if assigned(NewSelectNode) AND allNodesDeleted then
    begin
        PlaylistVST.Selected[NewSelectNode] := True;
        PlaylistVST.FocusedNode := NewSelectNode;
    end;


    PlaylistVSTChange(PlaylistVST, Nil);
end;
                 
// Datei im Headset abspielen
procedure TNemp_MainForm.PM_PL_PlayInHeadsetClick(Sender: TObject);
begin
    // Play new song in headset
    NempPlayer.PlayInHeadset(CurrentlySelectedFile);

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
      1: NempPlaylist.Sort(Sort_Pfad_asc);
      2: NempPlaylist.Sort(Sort_ArtistTitel_asc);
      3: NempPlaylist.Sort(Sort_TitelArtist_asc);
      4: NempPlaylist.Sort(Sort_AlbumTrack_asc);
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
exit;
  case PlayListSaveDialog.FilterIndex of
    1: PlayListSaveDialog.DefaultExt := 'm3u';
    2: PlayListSaveDialog.DefaultExt := 'm3u8';
    3: PlayListSaveDialog.DefaultExt := 'pls';
    4: PlayListSaveDialog.DefaultExt := 'npl';
  else
      PlayListSaveDialog.DefaultExt := 'm3u8';
  end;
end;


///  PM_PL_SavePlaylistClick
///  -------------------------
///  Save the Playlist, but try to use the "current name"
procedure TNemp_MainForm.PM_PL_SavePlaylistClick(Sender: TObject);
begin
  if NempPlaylist.PlaylistManager.CurrentIndex >= 0 then
  begin
      // Quicksave current playlist
      NempPlaylist.PlaylistManager.SaveCurrentPlaylist(NempPlaylist.Playlist, False);
      PlayListStatusLBL.Caption := Format(PlaylistManager_Saved, [NempPlaylist.PlaylistManager.CurrentPlaylistDescription]);
  end
  else
      // regular saving, show SaveDialog
      PM_PL_SaveAsPlaylistClick(Sender);
end;

procedure TNemp_MainForm.PM_PL_ScanForDuplicatesClick(Sender: TObject);
var
  aPlaylistDuplicateCollector: TPlaylistDuplicateCollector;
  firstDuplicateNode: PVirtualNode;
begin
  aPlaylistDuplicateCollector := TPlaylistDuplicateCollector.Create;
  try
    aPlaylistDuplicateCollector.ScanForDuplicates(NempPlaylist.Playlist);

    if aPlaylistDuplicateCollector.Count = 0 then
      TranslateMessageDLG((PlaylistDuplicates_NoDuplicatesFound), mtInformation, [MBOK], 0)
    else
    begin
      if not assigned(FormPlaylistDuplicates) then
      begin
        Application.CreateForm(TFormPlaylistDuplicates, FormPlaylistDuplicates);
        FormPlaylistDuplicates.OnDeleteAudioFile := OnDeletePlaylistDuplicate;
        FormPlaylistDuplicates.OnDeleteOriginalAudioFile   := OnDeletePlaylistDuplicateOriginal;

        FormPlaylistDuplicates.OnAfterLastDuplicateDeleted := OnAfterLastDuplicateDeleted;
        FormPlaylistDuplicates.OnAfterRefreshDuplicateScan := OnAfterRefreshDuplicateScan;
        FormPlaylistDuplicates.OnDuplicateDblClick := OnDuplicateDblClick;
      end;

      // FormPlaylistDuplicates will free the Collector OnClose
      FormPlaylistDuplicates.PlaylistDuplicateCollector := aPlaylistDuplicateCollector;

      firstDuplicateNode := GetNodeWithAudioFile(PlaylistVST, aPlaylistDuplicateCollector.DuplicateFiles[0]);
      if assigned(firstDuplicateNode) then
      begin
        PlaylistVST.ClearSelection;
        PlaylistVST.Selected[firstDuplicateNode] := True;
        PlaylistVST.ScrollIntoView(firstDuplicateNode, True);
        PlaylistVST.FocusedNode := firstDuplicateNode;
      end;
      FormPlaylistDuplicates.Show;
      FormPlaylistDuplicates.ShowDuplicateAnalysis(aPlaylistDuplicateCollector.DuplicateFiles[0]);
    end;

  finally
    if aPlaylistDuplicateCollector.Count = 0 then
      aPlaylistDuplicateCollector.Free;
  end;
end;

///  PM_PL_SaveAsPlaylistClick
///  ---------------------------
///  Save the current Playlist under a new name
procedure TNemp_MainForm.PM_PL_SaveAsPlaylistClick(Sender: TObject);
var dir, newFileName: String;
begin
  if NempPlaylist.SuggestSaveLocation(dir, newFileName) then
      PlayListSaveDialog.InitialDir := Dir;
  PlayListSaveDialog.FileName := newFileName;

  if PlayListSaveDialog.Execute then
  begin
      NempPlaylist.SaveToFile(PlayListSaveDialog.FileName, False);
      NempPlaylist.PlaylistManager.AddRecentPlaylist(PlayListSaveDialog.FileName);
      PlayListStatusLBL.Caption := Playlist_Saved;
  end;
end;


procedure TNemp_MainForm.PM_PL_ShowInExplorerClick(Sender: TObject);
var Node: PVirtualNode;
    af: TAudioFile;
begin
    Node := PlaylistVST.FocusedNode;
    if not Assigned(Node) then
        Exit;
    af := PlaylistVST.GetNodeData<TAudioFile>(Node);

    if DirectoryExists(af.Ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
                      , PChar('/e,/select,"'+af.Pfad+'"'), '', sw_ShowNormal);
end;

procedure TNemp_MainForm.PM_PL_LoadPlaylistClick(Sender: TObject);
var restart: boolean;
    GoOn: Boolean;
begin
    GoOn := NempPlaylist.PlaylistManager.PreparePlaylistLoading(
                  -2,
                  NempPlaylist.Playlist,
                  NempPlaylist.PlayingIndex,
                  Round(NempPlaylist.PlayingTrackPos) );

    if GoOn and PlayListOpenDialog.Execute then
    begin
        restart := NempPlayer.Status = Player_ISPLAYING;
        NempPlaylist.PlaylistManager.Reset;
        NempPlaylist.ClearPlaylist;
        NempPlaylist.LoadFromFile(PlayListOpenDialog.FileName);
        NempPlaylist.PlaylistManager.AddRecentPlaylist(PlayListOpenDialog.FileName);

        If restart then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(0,0, True);
        end;
    end;
end;

procedure TNemp_MainForm.MM_T_PlaylistLogClick(Sender: TObject);
begin
    if not assigned(PlayerLogForm) then
        Application.CreateForm(TPlayerLogForm, PlayerLogForm);
    PlayerLogForm.Show;
end;

procedure TNemp_MainForm.PM_PL_PropertiesClick(Sender: TObject);
var
  Node: PVirtualNode;
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

  ShowDetailForm(PlaylistVST.GetNodeData<TAudioFile>(Node), True);
end;

procedure TNemp_MainForm.PM_PL_ReplayGain_Click(Sender: TObject);
var aVST: TVirtualStringtree;
    af: TAudioFile;
    SelectedMp3s: TNodeArray;
    i: Integer;
    FileList: TAudioFileList;
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

    if not GetSpecialPermissionToChangeMetaData then exit;

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
    FileList := TAudioFileList.Create(False);
    try
        SelectedMp3s := aVST.GetSortedSelection(False);
        for i := 0 to length(SelectedMp3s) - 1 do
        begin
            if aVST.GetNodeLevel(Selectedmp3s[i]) = 0 then
            begin
                af := aVST.GetNodeData<TAudioFile>(SelectedMp3s[i]);
                // only add actual files (no webradio, CDDA, ..)
                if af.IsFile then
                    FileList.Add(af);
            end;
        end;

        // sort the list by Album for AlbumGain calculation
        FileList.Sort(Sort_AlbumTrack_asc);

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
      AudioFile := PlaylistVST.GetNodeData<TAudioFile>(aNode);
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

  RefreshVSTDetailsTimer.Tag := SD_Playlist;
  RefreshVSTDetailsTimer.Enabled := False;
  RefreshVSTDetailsTimer.Enabled := True;
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

    // during testing ....
    ///NempTaskBarManager.ProgressState := TTaskBarProgressState.None;
    ///NempTaskBarManager.ProgressState := TTaskBarProgressState.Normal;
    ///NempTaskBarManager.ProgressValue := round(aProgress*100);
    ///NempTaskBarManager.ApplyProgressChanges;

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
            //xx fspTaskbarPreviews1.InvalidatePreview;
            NempTaskbarManager.InvalidateThumbPreview;
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

procedure TNemp_MainForm.PlaylistSelectNextFlagged(aFlag: Integer);
var af: TAudioFile;
    currentNode, StartNode: PVirtualNode;
begin
    // Select a new Node flagged with "aFlag"
    // Begin with the currently focussed node, or the first node in the playlist
    if assigned(PlaylistVst.FocusedNode) then
      StartNode := PlaylistVst.FocusedNode
    else
      StartNode := PlaylistVst.GetFirst;
    if not assigned(StartNode) then
      exit; // empty list, nothing to do here ...

    PlaylistVST.Selected[StartNode] := False;
    // we want the *next* node
    // => begin with the next node (or the first one, if the current node is the last one in the playlist)
    currentNode := GetNextNodeOrFirst(PlaylistVST, StartNode);
    repeat
        // get an AudioFile which is marked as a current search result
        af := PlaylistVST.GetNodeData<TAudioFile>(currentNode);
        if not af.FlaggedWith(aFlag) then
        begin
            PlaylistVST.Selected[currentNode] := False;
            currentNode := GetNextNodeOrFirst(PlaylistVST, currentNode);
        end;
    until af.FlaggedWith(aFlag) or (currentNode = StartNode);

    PlaylistVST.Selected[currentNode] := true;
    PlaylistVST.ScrollIntoView(currentNode, True);
    PlaylistVST.FocusedNode := currentNode;
end;

procedure TNemp_MainForm.PlaylistSelectNextDuplicate;
begin
  PlaylistSelectNextFlagged(FLAG_DUPLICATE);
end;

procedure TNemp_MainForm.PlaylistSelectNextSearchresult;
begin
  PlaylistSelectNextFlagged(FLAG_SEARCHRESULT);
end;

procedure TNemp_MainForm.PlaylistSelectAllSearchresults;
var currentNode: PVirtualNode;
    af: TAudioFile;
begin
    currentNode := PlaylistVst.GetFirst;
    while assigned(CurrentNode) do
    begin
        af := PlaylistVST.GetNodeData<TAudioFile>(currentNode);
        PlaylistVST.Selected[currentNode] := af.IsSearchResult;
        currentNode := PlaylistVST.GetNextSibling(currentNode);
    end;
end;

function TNemp_MainForm.GetCurrentlySelectedFile: TAudioFile;
begin
  result := fCurrentlySelectedFile;
end;


procedure TNemp_MainForm.SetCurrentlySelectedFile(Value: TAudioFile);
begin
  if assigned(Value) then
    fCurrentlySelectedFile.Assign(Value)
  else
    fCurrentlySelectedFile.Clear;

end;


procedure TNemp_MainForm.PlaylistScrollToPlayingFile;
var aNode: PVirtualNode;
begin
  if not assigned(NempPlaylist.PlayingFile) then
    exit;

  aNode := GetNodeWithAudioFile(PlaylistVST, NempPlaylist.PlayingFile);
  // if there is a CueList attached: scroll into the active CueNode
  if assigned(NempPlaylist.PlayingFile.CueList) then
    aNode := GetNodeWithCueFile(PlaylistVST, aNode, NempPlayer.GetActiveCue);
  PlaylistVST.ScrollIntoView(aNode, True);
end;

procedure TNemp_MainForm.PlayerArtistLabelDblClick(Sender: TObject);
begin
  PlaylistScrollToPlayingFile;
end;

// Event-Handler for the Playlist:
// Refresh some captions when a new entry in the CueSheet is played
procedure TNemp_MainForm.PlaylistCueChanged(Sender: TNempPlaylist);
begin
    // Refresh Treeview
    PlaylistVST.Invalidate;
    // Refresh Labels in MainControls
    if MainPlayerControlsActive then
    begin
        if assigned(NempPlayer.MainAudioFile) then
        begin
            PlayerArtistLabel.Caption := NempDisplay.PlayerLine1(NempPlayer.MainAudioFile, NempPlayer.GetActiveCue);  // NempPlayer.PlayerLine1;
            PlayerTitleLabel.Caption  := NempDisplay.PlayerLine2(NempPlayer.MainAudioFile, NempPlayer.GetActiveCue); // NempPlayer.PlayerLine2;
            ShowVSTDetails(NempPlayer.CurrentFile, SD_PLAYER);

            // NempPlayer.GetActiveCue
        end;
    end;
end;

///  Event-Handler for the Playlist:
///  -----------------------------------------------
procedure TNemp_MainForm.PlaylistUserChangedTitle(Sender: TNempPlaylist);
begin
  PlaylistScrollToPlayingFile;
end;

///  PlaylistDeleteFile
///  Called when a File was Removed from the Playlist
///  * Delete the Node from the Treeview
///  * Clear the MedienBib.CurrentAudioFile reference if needed
procedure TNemp_MainForm.PlaylistDeleteFile(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
var aNode: PVirtualNode;
begin
    //if MedienBib.CurrentAudioFile = aFile then
    //    MedienBib.CurrentAudioFile := Nil;

    // Todo: remove aFile from the DuplicateCollector (if needed)
    if assigned(FormPlaylistDuplicates) and FormPlaylistDuplicates.Visible then
      FormPlaylistDuplicates.RemoveAudioFile(aFile);

    aNode := GetNodeWithAudioFile(PlaylistVST, aFile);
    if assigned(aNode) then
        PlaylistVST.DeleteNode(aNode);

    PlaylistVST.Invalidate;
end;

// OnDeletePlaylistDuplicate:
// Some Duplicate should be deleted. No re-selection in the PlaylistVST is needed
procedure TNemp_MainForm.OnDeletePlaylistDuplicate(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
begin
  NempPlaylist.DeleteAudioFileFromPlaylist(aFile);
end;

// OnDeletePlaylistDuplicateOriginal
// the "original" of some duplicates should be deleted (= the currently focussed file)
// after that: Select the next duplicate
procedure TNemp_MainForm.OnDeletePlaylistDuplicateOriginal(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
var currentNode, newSelectedNode: PVirtualNode;
begin
  currentNode := GetNodeWithAudioFile(PlaylistVST, aFile);

  // determine a Node we want to select after removing the selected files
  newSelectedNode := PlaylistVST.GetNextSibling(currentNode);
  if not Assigned(newSelectedNode) then
    newSelectedNode := PlaylistVST.GetPreviousSibling(currentNode);

  NempPlaylist.DeleteAudioFileFromPlaylist(aFile);

  // Select the next node
  if assigned(newSelectedNode)  then
  begin
    PlaylistVST.Selected[newSelectedNode] := True;
    PlaylistVST.FocusedNode := newSelectedNode;
  end;
  PlaylistVSTChange(PlaylistVST, Nil);
end;

procedure TNemp_MainForm.OnAfterLastDuplicateDeleted(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
var af: TAudioFile;
    currentNode, StartNode: PVirtualNode;
begin
  // Select a new Node marked as "Duplicate"
  // Begin with the node storing "aFile" (which should be the focused node!), or the first node in the playlist
  if assigned(PlaylistVst.FocusedNode) then
    StartNode := PlaylistVst.FocusedNode
  else
    StartNode := PlaylistVst.GetFirst;
  if not assigned(StartNode) then
      exit; // empty list, nothing to do here ...

  PlaylistVST.Selected[StartNode] := False;
  // we want the *next* Duplicate
  // => begin with the next node (or the first one, if the current node is the last one in the playlist)
  currentNode := GetNextNodeOrFirst(PlaylistVST, StartNode);
  repeat
    // get an AudioFile which is marked as a "Duplicate"
    af := PlaylistVST.GetNodeData<TAudioFile>(currentNode);
    if not (af.FlaggedWith(FLAG_DUPLICATE) or af.FlaggedWith(FLAG_EXACTDUPLICATE)) then
    begin
      PlaylistVST.Selected[currentNode] := False;
      currentNode := GetNextNodeOrFirst(PlaylistVST, currentNode);
    end;
  until af.FlaggedWith(FLAG_DUPLICATE) or af.FlaggedWith(FLAG_EXACTDUPLICATE) or (currentNode = StartNode);

  PlaylistVST.Selected[currentNode] := true;
  PlaylistVST.ScrollIntoView(currentNode, True);
  PlaylistVST.FocusedNode := currentNode;

  PlaylistVSTChange(PlaylistVST, Nil);
end;

procedure TNemp_MainForm.OnAfterRefreshDuplicateScan(Sender: TObject);
begin
  PlaylistVST.Invalidate;
end;

procedure TNemp_MainForm.OnDuplicateDblClick(Sender: TPlaylistDuplicateCollector; aFile: TAudioFile);
var
  aNode: PVirtualNode;
begin
  aNode := GetNodeWithAudioFile(PlaylistVST, aFile);
  PlaylistVST.ScrollIntoView(aNode, True);
end;


procedure TNemp_MainForm.PlaylistAddFile(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
var NewNode, InsertNode: PVirtualNode;
    i: Integer;
begin
    if aIndex = -1 then
    begin
        NewNode := PlaylistVST.AddChild(Nil, aFile);
    end else
    begin
        // Remember MostRecentInsertNodeForPlaylist
        // this will make the search for the InsertNode for the next File in the queue much faster
        insertNode := GetNodeWithIndex(PlaylistVST, aIndex, MostRecentInsertNodeForPlaylist);
        NewNode := PlayListVST.InsertNode(InsertNode, amInsertBefore, aFile);
        MostRecentInsertNodeForPlaylist := NewNode;
    end;
    // insert CueNodes, if neccessary
    if assigned(aFile.CueList) then
        for i := 0 to aFile.CueList.Count - 1 do
            PlaylistVST.AddChild(NewNode, aFile.Cuelist[i]);

    PlaylistVST.Invalidate;
end;

procedure TNemp_MainForm.PlaylistAudioFileMoved(Sender: TNempPlaylist; aFile: TAudioFile; oldIndex, newIndex: Integer);
var oldNode, newNode: PVirtualNode;
begin
    oldNode := GetNodeWithIndex(PlaylistVST, oldIndex, Nil);
    newNode := GetNodeWithIndex(PlaylistVST, newIndex, Nil);

    if assigned(newNode) then
        PlaylistVST.MoveTo(oldNode, newNode, amInsertBefore, false)
    else
    begin
        newNode := PlaylistVST.GetLastChild(Nil);
        PlaylistVST.MoveTo(oldNode, newNode, amInsertAfter, false)
    end;

end;

procedure TNemp_MainForm.PlaylistCueListFound(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer);
var MainNode: PVirtualNode;
    i: Integer;
begin
    MainNode := GetNodeWithAudioFile(PlaylistVST, aFile);
    if not assigned(MainNode) then
        exit;

    PlaylistVST.BeginUpdate;
    for i := 0 to aFile.CueList.Count - 1 do
        PlaylistVST.AddChild(MainNode, aFile.Cuelist[i]);
    PlaylistVST.EndUpdate;

    PlaylistVST.Invalidate;
end;

///  PlaylistFilePropertiesChanged
///  Called when some properties of some AudioFiles has been changed
///  * Repaint the Tree (GetText, ImageIndex, ...)
procedure TNemp_MainForm.PlaylistFilePropertiesChanged(Sender: TNempPlaylist);
begin
    PlaylistVST.Invalidate;
end;

///  PlaylistPropertiesChanged
///  Called when the summary of the playist has been changed
///  * Refresh the INformation in the Tree Header
procedure TNemp_MainForm.PlaylistPropertiesChanged(Sender: TNempPlaylist);
begin
    if Sender.PlaylistManager.CurrentIndex = -1 then
        PlaylistVST.Header.Columns[1].Text := Format('%s (%d)', [(TreeHeader_Playlist), Sender.Playlist.Count])
    else
        PlaylistVST.Header.Columns[1].Text := Format('%s - %s (%d)', [(TreeHeader_Playlist), Sender.PlaylistManager.CurrentPlaylistDescription,  Sender.Playlist.Count]);

    PlaylistVST.Header.Columns[2].Text := SekToZeitString(Sender.Dauer);
end;

///  PlaylistSearchResultsChanged
///  * While seaching, the SearchResults may change. If the currently focussed
///    Node still matches the search results, we do nothing
///    Otherwise, we scroll to the next matching node
procedure TNemp_MainForm.PlaylistSearchResultsChanged(Sender: TNempPlaylist);
var
  af: TAudioFile;
  StartNode: PVirtualNode;
begin
  if assigned(PlaylistVst.FocusedNode) then
    StartNode := PlaylistVst.FocusedNode
  else
    StartNode := PlaylistVst.GetFirst;
  if assigned(StartNode) then begin
    // we do not consider CueSheets in the Search
    if PlaylistVst.GetNodeLevel(StartNode) > 0 then
      StartNode := StartNode.Parent;
    af := PlaylistVST.GetNodeData<TAudioFile>(StartNode);
    if assigned(af) and (not af.IsSearchResult) then
        PlaylistSelectNextSearchresult;
  end;
end;

///  PlaylistCleared
///  PlaylistChangedCompletely
///  * The Playlist has changed completely. By clearing, loading, by sorting or something else
///    Moving single Nodes doesn't help here - we need to refill the complete list.
procedure TNemp_MainForm.PlaylistCleared(Sender: TNempPlaylist);
begin
    PlaylistVST.Clear;
    if assigned(FormPlaylistDuplicates) and FormPlaylistDuplicates.Visible
    then
      FormPlaylistDuplicates.Clear;
end;
///  We can assume that the currently focussed Node is still there (in some way)
///  after we are done with refilling the tree
procedure TNemp_MainForm.PlaylistChangedCompletely(Sender: TNempPlaylist);
var i, c: integer;
    aNode, oldNode: PVirtualNode;
    oldAf: TAudioFile;
begin
    PlaylistVST.BeginUpdate;

    // remember the currently focussed AudioFile
    // If there is none focussed, try the PlayingFile
    oldNode := PlaylistVST.FocusedNode;
    if assigned(oldNode) then
        oldAf := PlaylistVST.GetNodeData<TAudioFile>(oldNode)
    else
        oldAf := Sender.PlayingFile;

    // Clear and refill the TreeView
    PlaylistVST.Clear;
    for i := 0 to Sender.Playlist.Count-1 do
    begin
        aNode := PlaylistVST.AddChild(Nil, Sender.Playlist.Items[i]);
        // ggf. Cuelist einf�gen
        if Assigned(Sender.Playlist.Items[i].CueList) then
            for c := 0 to Sender.Playlist.Items[i].CueList.Count - 1 do
                PlaylistVST.AddChild(aNode, Sender.Playlist.Items[i].Cuelist[c]);
    end;

    // Try to find the oldNode again
    if assigned(oldAf) then
    begin
        oldNode := GetNodeWithAudioFile(PlaylistVST, oldAf);
        if assigned(oldNode) then
            PlaylistVST.ScrollIntoView(oldNode, True);
    end;
    PlaylistVST.EndUpdate;
end;

procedure TNemp_MainForm.RefreshPaintFrameHint(ShowDelayExplanation: Boolean);
var af: TAudioFile;
begin
  if ShowDelayExplanation then
  begin
    if MainPlayerControlsActive then
      PaintFrame.Hint := _(PlaylistAutoDelay);
  end else
  begin
    if MainPlayerControlsActive then
      af := NempPlayer.MainAudioFile
    else
      af := NempPlayer.HeadSetAudioFile;

    if assigned(af) then
      PaintFrame.Hint := NempDisplay.HintText(af)
    else
      PaintFrame.Hint := '';
  end;
end;

procedure TNemp_MainForm.DisplayTitleInformation(ShowMainFile, GetCoverWasSuccessful: Boolean);
var fn, aHint: String;
    af, cueFile: TAudioFile;
    aPic: TPicture;
begin

  if ShowMainFile = MainPlayerControlsActive then
  begin

            if ShowMainFile then
            begin
              af := NempPlayer.MainAudioFile;
              cueFile := NempPlayer.GetActiveCue;
              aPic := NempPlayer.MainPlayerPicture;
              fn := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_MainPlayer.png';
            end else
            begin
              af := NempPlayer.HeadSetAudioFile;
              cueFile := Nil;
              aPic := NempPlayer.HeadsetPicture;
              fn := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_headphone.png';
            end;

            CoverImage.Picture.Assign(Nil);
            CoverImage.Refresh;
            if assigned(af) then
            begin
                if af.isCDDA then
                  CDDBConsistencyCheck(af);

                PlayerArtistLabel.Caption := NempDisplay.PlayerLine1(af, cueFile); //'TODO Line1' ;//NempPlayer.PlayerLine1;
                PlayerTitleLabel.Caption  := NempDisplay.PlayerLine2(af, cueFile); //'TODO Line2' ;// NempPlayer.PlayerLine2;

                aHint := NempDisplay.HintText(af);

                // Rating
                Spectrum.DrawRating(af.Rating);
                // Cover
                CoverImage.Picture.Assign(aPic);
                CoverImage.Hint := aHint;

                // initiate Cover Download, if necessary (and allowed by User)
                // no Cover-Download for Headset-Playback
                if (NOT GetCoverWasSuccessful) and ShowMainFile  then
                begin
                    if MedienBib.CoverSearchLastFM then
                        CoverDownloadThread.AddJob(af, 0);
                end;

                // Progress and Vis
                PaintFrame.Hint := aHint;
                if ShowMainFile then
                begin
                  ShowProgress(NempPlayer.Progress, NempPlayer.TimeInSec, True);
                  NempPlayer.DrawHeadsetVisualisation;
                end
                else
                begin
                  ShowProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset, False);
                  NempPlayer.DrawHeadsetVisualisation;
                end;
                ReCheckAndSetProgressChangeGUIStatus;

                HeadSetTimer.Enabled := (NempPlayer.BassHeadSetStatus = BASS_ACTIVE_PLAYING) and (not ShowMainFile);
                BassTimer.Enabled    := (NempPlayer.BassStatus = BASS_ACTIVE_PLAYING) and (ShowMainFile);

            end else
            begin
              // default information
              PlayerArtistLabel.Caption := Player_NoTitleLoaded;
              PlayerTitleLabel.Caption := '';

              // rating
              Spectrum.DrawRating(0);

              // Cover
              if FileExists(fn) then
                CoverImage.Picture.LoadFromFile(fn);
              CoverImage.Hint := '';

              // zero progress
              SetProgressButtonPosition(0);
              SlideBarShape.Progress := 0;
              // disable Slidebar
              ReCheckAndSetProgressChangeGUIStatus;

              // clear vis
              PaintFrame.Hint := '';
              if ShowMainFile then
                NempPlayer.DrawMainPlayerVisualisation
              else
                NempPlayer.DrawHeadsetVisualisation;
            end;
  end;

end;

procedure TNemp_MainForm.DisplayPlayerMainTitleInformation(GetCoverWasSuccessful: Boolean);
begin
  DisplayTitleInformation(True, GetCoverWasSuccessful);
end;

procedure TNemp_MainForm.DisplayHeadsetTitleInformation(GetCoverWasSuccessful: Boolean);

begin
  DisplayTitleInformation(False, GetCoverWasSuccessful);
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
        NempTrayIcon.Hint := StringReplace(NempDisplay.PlaylistTitle(NempPlayer.MainAudioFile), '&', '&&&', [rfReplaceAll]);
    end;

    ShowVSTDetails(NempPlayer.CurrentFile, SD_PLAYER);

    DisplayPlayerMainTitleInformation(GetCoverWasSuccessful);
    DisplayHeadsetTitleInformation(GetCoverWasSuccessful);
end;


procedure TNemp_MainForm.CoverImageDblClick(Sender: TObject);
var af: TAudioFile;
begin
  if MainPlayerControlsActive then
    af := NempPlaylist.PlayingFile    // MainControls -> show Details of current PlayingFile
  else
    af := NempPlayer.HeadSetAudioFile; // HeadsetControls -> show Details of current HeadsetFile

  if assigned(af) then
    ShowDetailForm(af, True);
end;

procedure TNemp_MainForm.PlaylistVSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Node: PVirtualNode;
    af: TAudioFile;
begin
  case Key of
    vK_RETURN: begin
        if (ssShift in Shift) then
            PlaylistSelectAllSearchresults
        else
        begin
            InitiateFocussedPlay(PlaylistVST);
            Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
        end;
    end;

    $46: begin
        if (ssCtrl in Shift) then
            EditPlaylistSearch.SetFocus;
    end;

    VK_F3: begin
        if (EditPlaylistSearch.Tag = 1) and (Length(Trim(EditPlaylistSearch.Text)) >= 3) then // search is active
          PlaylistSelectNextSearchresult
        else
        if assigned(FormPlaylistDuplicates) and FormPlaylistDuplicates.Visible then
          PlaylistSelectNextDuplicate
    end;

    VK_ESCAPE: begin
        EditPlaylistSearch.Text := '';
        NempPlaylist.ClearSearch(True);
    end;

    VK_F9: begin
        if (NempPlayer.JingleStream = 0) then
        begin
            Node := PlaylistVST.FocusedNode;
            if not Assigned(Node) then
                Exit;
            //Data := PlaylistVST.GetNodeData(Node);
            af := PlaylistVST.GetNodeData<TAudioFile>(Node);
            if af.AudioType = at_File then
                NempPlayer.PlayJingle(af);
        end;
    end;

    VK_F8: begin
        NempPlayer.PlayJingle(Nil);
    end;

    48..57, 96..105: begin // 0..9, NumPad 0..9
        Node := PlaylistVST.FocusedNode;
        if assigned(Node) and (PlaylistVST.GetNodeLevel(Node) = 0) then
        begin
            af := PlaylistVST.GetNodeData<TAudioFile>(Node);
            NempPlaylist.ProcessKeypress(key - 48, af);
            // (if key-48 is too large, ProcessKeypress will substract another time 48 from it)
        end;
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
  aPfad: UnicodeString;
begin
  if Medienbib.StatusBibUpdate >= 2 then exit;

  aNode := VST.FocusedNode;
  if not assigned(aNode) then exit;

  aPfad := (VST.GetNodeData<TAudioFile>(aNode)).Ordner;

  MedienBib.GetFilesInDir(aPfad, Sender=PM_ML_ExtendedShowAllFilesInDir);
end;

procedure TNemp_MainForm.NachDiesemDingSuchen1Click(Sender: TObject);
var aNode: pVirtualNode;
    af: TAudioFile;
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

    af := VST.GetNodeData<TAudioFile>(aNode);
    case (Sender as TMenuItem).Tag of
        1: begin
            KeyWords.Titel  := af.Titel;
            SearchString := KeyWords.Titel;
        end;
        2: begin
            KeyWords.Artist := af.Artist;
            SearchString := KeyWords.Artist;
        end;
        3: begin
            KeyWords.Album  := af.Album;
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

procedure TNemp_MainForm.MM_PL_DirectoryClick(Sender: TObject);
var
  OpenDlg: TFileOpenDialog;
begin
  if (NempPlaylist.InitialDialogFolder = '') then
      NempPlaylist.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);

  OpenDlg := TFileOpenDialog.Create(self);
  try
    OpenDlg.Options := OpenDlg.Options + [fdoPickFolders];
    OpenDlg.DefaultFolder := NempPlaylist.InitialDialogFolder;

    if OpenDlg.Execute then begin
      NempPlaylist.InitialDialogFolder := OpenDlg.FileName;
      MarkCDDriveDataAsDeprecated;
      NempPlaylist.ResetInsertIndex;
      ST_Playlist.Mask := GeneratePlaylistSTFilter;

      if NameOfMyComputer <> OpenDlg.FileName then begin
        NempPlaylist.ST_Ordnerlist.Add(OpenDlg.FileName);
        if (Not ST_Playlist.IsSearching) then begin
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
    OpenDlg.Free;
  end;
end;

procedure TNemp_MainForm.PM_PL_AddCDAudioClick(Sender: TObject);
var i: integer;
  Abspielen: Boolean;
  newFile: TAudioFile;
begin
    // Playlistl�nge merken
    Abspielen := NempPlaylist.Count = 0;

    // Show CD-Open-Dialog, insert files, ...

    if not assigned(CDOpenDialog) then
        Application.CreateForm(TCDOpenDialog, CDOpenDialog);

    if CDOpenDialog.ShowModal = mrOK then
    begin
        for i := 0 to CDOpenDialog.SelectedFiles.Count - 1 do begin
          newFile := TAudioFile.Create;
          newFile.Assign(CDOpenDialog.SelectedFiles[i]);
          NempPlaylist.AddFileToPlaylist(newFile);
        end;
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
  // Playlistl�nge merken
  Abspielen := NempPlaylist.Count = 0;

  // einf�gen
  if PlaylistDateienOpenDialog.Execute then begin
    MarkCDDriveDataAsDeprecated;
    for i := 0 to PlaylistDateienOpenDialog.Files.Count - 1 do
      NempPlaylist.AddFileToPlaylist(PlaylistDateienOpenDialog.Files[i]);
  end;

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
        NempPlaylist.PlaylistManager.AddRecentPlaylist(PlayListOpenDialog.FileName);
    end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedAddToMedialibraryClick(Sender: TObject);
var
  i: Integer;
  newFilenames: TStringList;
begin
    if NempSkin.NempPartyMode.DoBlockBibOperations then
        exit;

    if MedienBib.StatusBibUpdate <> 0 then
    begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    // new simplified method, using existing method Handle_DropFilesForLibrary
    newFilenames := TStringList.Create;
    try
      for i := 0 to NempPlaylist.Count - 1 do begin
        if NempPlaylist.Playlist[i].IsFile then
          newFilenames.Add(NempPlaylist.Playlist[i].Pfad);
      end;
      Handle_DropFilesForLibrary(newFilenames, MedienBib.CurrentCategory, True);
    finally
      newFilenames.Free;
    end;
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
    PM_PL_SaveAsPlaylist    .Enabled := (NempPlaylist.Count > 0);

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

      NempTaskbarManager.ProgressState := TTaskBarProgressState.None;
      // kann sein, dass der Player ab und zu mal blockiert - hier dann umsetzen ;-)
      NempPlaylist.AcceptInput := True;
      KeepOnWithLibraryProcess := False;  // CancelButton
      ContinueWithPlaylistAdding := False;
  end;

end;


procedure TNemp_MainForm.ChangeCategory(aList: TAudioFileList);
begin
  if NOT (assigned(MedienBib.CurrentCategory)
    and (MedienBib.CurrentCategory is TLibraryFileCategory))
  then
    exit;

  if not assigned(FormChangeCategory) then
    Application.CreateForm(TFormChangeCategory, FormChangeCategory);

  FormChangeCategory.SetCategories(MedienBib.FileCategories, TLibraryFileCategory(MedienBib.CurrentCategory));
  FormChangeCategory.SetFiles(aList);
  if FormChangeCategory.ShowModal = mrOK then begin
    MedienBib.ChangeCategory(
            MedienBib.CurrentCategory,
            FormChangeCategory.NewCategory,
            aList,
            FormChangeCategory.Effect);
    MedienBib.RefreshCollections;
  end;
end;

procedure TNemp_MainForm.PM_MLView_ChangeCategoryClick(Sender: TObject);
var
  FileList: TAudioFileList;
begin
  FileList := TAudioFileList.Create(False);
  try
    if GenerateSortedListFromFileView(FileList, False) then
      // Show SelectionDialog and Change Category of the files
      ChangeCategory(FileList);
  finally
    FileList.Free;
  end;
end;

procedure TNemp_MainForm.PM_ML_ChangeCategoryClick(Sender: TObject);
var
  FileList: TAudioFileList;
begin
  FileList := TAudioFileList.Create(False);
  try
    case medienBib.BrowseMode of
      0: GenerateSortedListFromCollectionTree(FileList, False);
      1: GenerateSortedListFromCoverFlow(FileList, False);
      2: GenerateSortedListFromTagCloud(FileList, False);
    end;
    // Show SelectionDialog and Change Category of the files
    ChangeCategory(FileList);
  finally
    FileList.Free;
  end;
end;

procedure TNemp_MainForm.PM_MLView_RemoveFromCategoryClick(Sender: TObject);
var
  FileList: TAudioFileList;
begin
  FileList := TAudioFileList.Create(False);
  try
    if GenerateSortedListFromFileView(FileList, False) then begin
      MedienBib.RemoveFromCategory(MedienBib.CurrentCategory, FileList);
      MedienBib.RefreshCollections;
    end;
  finally
    FileList.Free;
  end;
end;

procedure TNemp_MainForm.PM_ML_RemoveFromCategoryClick(Sender: TObject);
var
  FileList: TAudioFileList;
begin
  FileList := TAudioFileList.Create(False);
  try
    case medienBib.BrowseMode of
      0: GenerateSortedListFromCollectionTree(FileList, False);
      1: GenerateSortedListFromCoverFlow(FileList, False);
      2: GenerateSortedListFromTagCloud(FileList, False);
    end;
    MedienBib.RemoveFromCategory(MedienBib.CurrentCategory, FileList);
    MedienBib.RefreshCollections;
  finally
    FileList.Free;
  end;
end;

procedure TNemp_MainForm.PM_ML_ClearCategoryClick(Sender: TObject);
var
  lc: TLibraryCategory;
  lcf: TLibraryFileCategory;
  FileList: TAudioFileList;
begin
  lc := MedienBib.CurrentCategory;
  if assigned(lc) and (lc.CategoryType = ccFiles) and (not lc.IsDefault) then begin
    lcf := TLibraryFileCategory(lc);
    if lcf.ItemCount > 0 then begin // should always be the case
      if TranslateMessageDLG(Format(MainForm_ConfirmClearCategory,[lcf.ItemCount]), mtWarning, [mbYes,MBNo], 0) = mrYes then begin
        FileList := TAudioFileList.Create(False);
        try
          lcf.Collections[0].GetFiles(FileList, True);
          MedienBib.RemoveFromCategory(lc, FileList);
          MedienBib.RefreshCollections;
        finally
          FileList.Free;
        end;
      end;
    end;
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
  newFilenames: TStringList;
begin
  if not Clipboard.HasFormat(CF_HDROP) then
    Exit;

  // new simplified method, using existing method Handle_DropFilesFor<...>
  newFilenames := TStringList.Create;
  try
    // Get Filenames (including Directories) from the Clipboard
    Clipboard.Open;
    try
      f := Clipboard.GetAsHandle(CF_HDROP);
      if f <> 0 then begin
        numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0);
        for i := 0 to numfiles - 1 do begin
          buffer[0] := #0;
          DragQueryFile(f, i, buffer, SizeOf(buffer));
          newFilenames.Add(buffer);
        end;
      end;
    finally
      Clipboard.Close;
    end;
    // Add Files/Directories to the Library or the Playlist
    if Sender = PM_PL_ExtendedPasteFromClipboard then
      Handle_DropFilesForPlaylist(newFilenames, False, PlaylistVST.FocusedNode, dmBelow, False)
    else
      Handle_DropFilesForLibrary(newFilenames, MedienBib.CurrentCategory, True);
  finally
    newFilenames.Free;
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
var af: TAudioFile;
begin

  case Kind of
    ikNormal, ikSelected:
      begin
        af := Sender.GetNodeData<TAudioFile>(Node);
        //if (Column = 0) and (af.PrebookIndex > 0) then
        //     ImageIndex := 18 // timer image
        //else
        begin
            case Column of
              1:  begin  // main column
                      //if Sender.GetNodeLevel(Node) = 0 then
                      //begin
                          if Not af.FileIsPresent then
                              imageIndex := 5
                          else
                          begin
                              // VoteCounter: Lowest Priority
                              if af.VoteCounter > 0 then
                                  ImageIndex := 20;

                              // files matches the current search keywords
                              if af.IsSearchResult then
                                  ImageIndex := 21;

                              if af.FlaggedWith(FLAG_DUPLICATE) then
                                ImageIndex := 22;
                              if af.FlaggedWith(FLAG_EXACTDUPLICATE) then
                                ImageIndex := 23;

                              if (af.PrebookIndex > 0) then
                                ImageIndex := 18;

                              // play indicator: Highest priority
                              if (af = NempPlayList.PlayingFile)
                                  or (af = NempPlaylist.PlayingCue)
                              then
                                  case NempPlayer.Status of
                                      PLAYER_ISPLAYING: ImageIndex := 2;
                                      PLAYER_ISPAUSED:  ImageIndex := 3;
                                  else
                                      ImageIndex := 4;
                                  end;
                          end;
                      //end;
                  end; // case Column 0
                  2: begin
                        if (af.AudioType = at_File)
                        AND NOT (
                              IsZero(af.TrackGain)
                              AND
                              IsZero(af.AlbumGain)
                            )
                        then begin
                            if NempPlayer.ApplyReplayGain then
                                ImageIndex := 16
                            else
                                ImageIndex := 17;
                        end;

                  end;
            end;
        end;
      end;
  end;
end;

procedure TNemp_MainForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
var af: TAudioFile;
begin
  case Kind of
    ikNormal, ikSelected:
      begin
          af := Sender.GetNodeData<TAudioFile>(Node);
          case Column of
              colIdx_Lyrics :
                  if af.LyricsExisting then ImageIndex := 6
                  else ImageIndex := 7;

              colIdx_LastFMTags:
                      if Length(af.RawTagLastFM) > 0 then ImageIndex := 11;
                  //else imageIndex := 15;
                  // Con_Titel: imageIndex := 10;

              colIdx_Marker: ImageIndex := 12 + (af.Favorite mod 4);

              colIdx_ARTIST: if (trim(af.Artist) = '') and (NempDisplay.ArtistSubstitute <> svEmpty) then ImageIndex := 24;
              colIdx_TITLE: if (trim(af.Titel) = '') and (NempDisplay.TitleSubstitute <> svEmpty) then ImageIndex := 24;
              colIdx_ALBUM: if (trim(af.Album) = '') and (NempDisplay.AlbumSubstitute <> svEmpty) then ImageIndex := 24;
          end;
      end;
  end;
end;

procedure TNemp_MainForm.PM_PL_ExtendedScanFilesClick(Sender: TObject);
var i: Integer;
begin
  /// note (2019)
  ///  This may lead to a looong operation, that can't be cancelled, as here is no
  ///  Application.ProcessMessages involved.
  ///  However, This method is probably very rarely used, and in most cases the
  ///  playlist contains <1000 files or so, which should be scanned quite fast.

  ClearCDDriveData;

  NempPlayer.CoverArtSearcher.StartNewSearch;
  for i := 0 to NempPlaylist.Playlist.Count - 1 do begin
    if (NempPlaylist.Playlist[i].isCDDA) then
      CDDBConsistencyCheck(NempPlaylist.Playlist[i])
    else
      NempPlaylist.RefreshAudioFile(i, True);
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




procedure TNemp_MainForm.MM_HelpClick(Sender: TObject);
begin
  MM_H_CleanupUpdate.Visible := NempOptions.LastUpdateCleaningSuccess <> cCurrentCleanUpdate;
  PM_P_CleanupUpdate.Visible := NempOptions.LastUpdateCleaningSuccess <> cCurrentCleanUpdate;
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

procedure TNemp_MainForm.ArtistsVSTResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;
    ArtistsVST.Header.Columns[0].Width := ArtistsVST.Width;
end;


procedure TNemp_MainForm.AlbenVSTResize(Sender: TObject);
begin
  if not FormReadyAndActivated then exit;
  if not NempLayout_Ready then exit;

  AlbenVST.Header.Columns[0].Width := AlbenVST.Width;
  if NempSkin.isActive and (NempOptions.AnzeigeMode = 0) then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetArtistAlbumOffsets;
    NempSkin.SetVSTOffsets;
    NempSkin.SetPlaylistOffsets;

    // 2022 No repaint. This causes some flickering, and it's probably not needed any more (?)
    //  RepaintPanels;
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
  if (Sender = NewPlayerPanel) and (x >= NewPlayerPanel.Width - 8) then begin

    if button = mbLeft then
    begin
      Resizing := True;
      ReleaseCapture;
      PerForm(WM_SysCommand, ResizeFlag , 0);
    end;




  end else
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
end;

procedure TNemp_MainForm.PaintFrameMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Sender = NewPlayerPanel) and (NempOptions.AnzeigeMode = 1) and (x >= NewPlayerPanel.Width - 8) then begin
    (Sender as TControl).Cursor := crSizeWE;
    ResizeFlag := SC_SIZE or WMSZ_RIGHT;
    exit;
  end else
    (Sender as TControl).Cursor := crDefault;


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
          NempOptions.MainFormMaximized := WindowState=wsMaximized;
          // aktuelle Aufteilung speichern
          NempOptions.FormPositions[nfMain].Top   := Top ;
          NempOptions.FormPositions[nfMain].Left  := Left;
      end;
      if Tag = 1 then
      begin
          NempOptions.FormPositions[nfMainMini].Top   := Top ;
          NempOptions.FormPositions[nfMainMini].Left  := Left;
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

  Resizing := False;
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
            if NempOptions.Anzeigemode = 1 then
            begin
                // Set Compact Mode
                // Party-mode in Separate-Window-Mode is not allowed.
                // Anzeigemode := 0;
                UpdateFormDesignNeu(0);
            end;

            NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active;
        end;
    end;

    if NempSkin.NempPartyMode.Active then
      CloudViewer.PartyModeMultiplier := NempSkin.NempPartyMode.ResizeFactor
    else
      CloudViewer.PartyModeMultiplier := 1;

    if Medienbib.BrowseMode = 2 then
      CloudViewer.PaintCloud;
end;


procedure TNemp_MainForm.TabBtn_EqualizerClick(Sender: TObject);
begin
    if not assigned(FormEffectsAndEqualizer) then
        Application.CreateForm(TFormEffectsAndEqualizer, FormEffectsAndEqualizer);
    FormEffectsAndEqualizer.Show;
end;


procedure TNemp_MainForm.PlayerTabsClick(Sender: TObject);
begin
  TabBtn_Cover.Tag       := (TabBtn_Cover.Tag + 1) mod 2;
  TabBtn_Cover.GlyphLine := TabBtn_Cover.Tag;

  LyricsMemo.Visible     := TabBtn_Cover.Tag = 1;
  ImgDetailCover.Visible := (TabBtn_Cover.Tag = 0);
end;

procedure TNemp_MainForm.TabBtn_SummaryLockClick(Sender: TObject);
begin
  TabBtn_SummaryLock.Tag       := (TabBtn_SummaryLock.Tag + 1) mod 2;
  TabBtn_SummaryLock.GlyphLine := TabBtn_SummaryLock.Tag;

  NempOptions.VSTDetailsLock := TabBtn_SummaryLock.Tag;

  if NempOptions.VSTDetailsLock = 1 then
    ShowVSTDetails(NempPlayer.CurrentFile, SD_PLAYER);
end;


procedure TNemp_MainForm.TABPanelAuswahlClick(Sender: TObject);
begin
    //if MedienBib.Count > 0 then
    begin
        SwitchBrowsePanel((Sender as TControl).Tag);
        SwitchMediaLibrary((Sender as TControl).Tag);
    end;
end;


procedure TNemp_MainForm.PM_ML_MedialibraryExportClick(Sender: TObject);
var
  ExportSuccess: Boolean;
begin
  if NempSkin.NempPartyMode.DoBlockBibOperations then
      exit;

  if MedienBib.StatusBibUpdate <> 0 then
  begin
      TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
  end;

  MedienBib.PrepareExport;
  if FormExport.ShowModal = mrOK then begin
    if FormExport.ExportMode = 3 then
      ExportSuccess := MedienBib.DoPlaylistExport(NempPlaylist.Playlist, FormExport.ExportFilename)
    else
      ExportSuccess := MedienBib.DoExport(FormExport.ExportMode, FormExport.ExportFilename);

    if ExportSuccess then begin
      if TranslateMessageDLG((ExportSucceeded), mtInformation, [MBYes, MBNo], 0) = mrYes then
        ShellExecute(Handle, 'open', PChar(FormExport.ExportFilename), nil, nil, SW_SHOWNORMAl);
    end else begin
      if FormExport.ExportMode = 1 then // export CurrentCategory
        TranslateMessageDLG((ExportFailed_CurrentCategory), mtWarning, [MBOK], 0)
      else
        TranslateMessageDLG((ExportFailed_Unknown), mtWarning, [MBOK], 0)
    end;

    MedienBib.FinishExport(True);
  end else
    MedienBib.FinishExport(False);
 (*
  SaveDialog1.Filter := (MediaLibrary_CSVFilter) + ' (*.csv)|*.csv';
  if SaveDialog1.Execute then
      if not MedienBib.SaveAsCSV(SaveDialog1.FileName) then
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
  *)
end;

procedure TNemp_MainForm.PM_P_CloseClick(Sender: TObject);
begin
  close;
end;


procedure TNemp_MainForm.FormActivate(Sender: TObject);
begin
    //XXXNempTaskbarManager.Active := True;
    FormReadyAndActivated := True;

    //NempLayout.BuildMainForm(nil);

    Application.OnDeactivate := FormDeactivate;

    self.OnActivate := Nil;
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
                  NempTaskbarManager.ProgressState := TTaskBarProgressState.None;
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


procedure TNemp_MainForm.FormResize(Sender: TObject);
begin
    if NempOptions.AnzeigeMode = 1 then
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
            // AND (MedienBib.BrowseMode = 1)
        then
            RefreshCoverFlowTimer.Enabled := True;
    end;

end;

procedure TNemp_MainForm.pmShowColumnIndexClick(Sender: TObject);
begin
  NempPlaylist.ShowIndexInTreeview := NOT NempPlaylist.ShowIndexInTreeview;
  RefreshPlaylistVSTHeader;
end;

procedure TNemp_MainForm.EDITFastSearchEnter(Sender: TObject);
begin
  if (EditFastSearch.Text <> '')
       AND (MedienBib.DisplayContent <> DISPLAY_QuickSearch)
  then
  begin
      //restore last quicksearch
      //RefreshCoverFlowTimer.Enabled := False;
      DoFastSearch(Trim(EDITFastSearch.Text), MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter);
      // Restart Timer
      //if MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow
      //    AND (MedienBib.BrowseMode = 1)
      //then
      //    RefreshCoverFlowTimer.Enabled := True;
  end;
end;

procedure TNemp_MainForm.EDITFastSearchExit(Sender: TObject);
begin
  if Trim(EditFastSearch.Text) <> '' then
    //if EditFastSearch.Tag <> 0 then
        MedienBib.BibSearcher.AddQuickSearchQueryToHistory(EditFastSearch.Text);
end;


//--------------------
// Playlist-Search
//--------------------
procedure TNemp_MainForm.EditPlaylistSearchEnter(Sender: TObject);
begin
  // EditPlaylistSearch.SelectAll;
  if Length(Trim(EditPlaylistSearch.Text)) >= 3 then
      NempPlaylist.Search(EditPlaylistSearch.Text)
end;

procedure TNemp_MainForm.EditPlaylistSearchKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    case key of
      VK_RETURN:
          begin
            key := 0;
            if (ssShift in Shift) then
                PlaylistSelectAllSearchresults
            else
            begin
                // Play the currently selected node
                InitiateFocussedPlay(PlaylistVST);
                Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
            end;
          end;
      VK_F3: begin
            PlaylistSelectNextSearchresult;
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
                    // AND (MedienBib.BrowseMode = 1)
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

              case MedienBib.BrowseMode of
                0: FillCollectionTree(MedienBib.CurrentCategory, True, False);
                1: RestoreCoverFlowAfterSearch;
                2: CloudViewer.PaintCloud('');
              end;

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


procedure TNemp_MainForm.ssdedtCloudSearchChange(Sender: TObject);
begin
  if MedienBib.BrowseMode = 2 then
    CloudViewer.PaintCloud(edtCloudSearch.Text);
end;


procedure TNemp_MainForm.ssdedtCloudSearchKeyPress(Sender: TObject; var Key: Char);
begin
      case ord(key) of
        VK_RETURN: key := #0;

        VK_ESCAPE: begin
              key := #0;
              edtCloudSearch.Text := '';
              CloudViewer.PaintCloud('');
        end
    end;
end;

procedure TNemp_MainForm.EDITFastSearchChange(Sender: TObject);
begin
  if MedienBib.Count = 0 then exit;

  If MedienBib.BibSearcher.QuickSearchOptions.WhileYouType then
  begin
      if Trim(EDITFastSearch.Text)= '' then
      begin
          RefreshCoverFlowTimer.Enabled := False;
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
                      // AND (MedienBib.BrowseMode = 1)
                  then
                      RefreshCoverFlowTimer.Enabled := True;
              end;
          end
          else
          begin
              RefreshCoverFlowTimer.Enabled := False;
              if Trim(EDITFastSearch.Text) = '*' then
                  MedienBib.QuickSearchShowAllFiles
              else begin
                VST.EmptyListMessage := MedienBib.BibSearcher.GetNewEmptyListMessage(elmShortSearch);
                VST.Invalidate;
              end;
          end;
  end;
end;


procedure TNemp_MainForm.TitlesVSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: String);
var af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if assigned(af) then
  begin
      HintText := NempDisplay.HintText(af);
      //LineBreakStyle := hlbForceSingleLine;
  end;
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
var
  aNode, catNode: PVirtualNode;
  nLevel, sndTag: Integer;
  ac: TAudioCollection;
  // acFile: TAudioFileCollection;
  lc: TLibraryCategory;
  rc: TRootCollection;
  newSorting, secondSorting: teCollectionSorting;
  newDirection, secondDirection: teSortDirection;
  // Flag-variable: add a new sorting type, or just change the sortdirection?
  OnlyChangeDirection, AddSecondSorter: Boolean;

begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  sndTag := (Sender as TMenuItem).Tag;

  // Init local variables (to get rid of compiler warnings)
  OnlyChangeDirection := False;
  AddSecondSorter := False;
  newSorting := csDefault;
  secondSorting := csDefault;
  newDirection := sd_Ascending;
  secondDirection := sd_Ascending;

  case sndTag of
    0..7: begin
      // csDefault, csAlbum, csArtist, csCount, csYear, csFileAge, csGenre, csDirectory
      OnlyChangeDirection := False;
      AddSecondSorter := False;
      newSorting := teCollectionSorting(sndTag);
      newDirection := sd_Ascending;
    end;
    50: begin
      OnlyChangeDirection := False;
      AddSecondSorter := True;
      newSorting := csAlbum;
      newDirection := sd_Ascending;
      secondSorting := csArtist;
      secondDirection := sd_Ascending;
    end;
    51: begin
      OnlyChangeDirection := False;
      AddSecondSorter := True;
      newSorting := csYear;
      newDirection := sd_Descending;
      secondSorting := csArtist;
      secondDirection := sd_Ascending;
    end;

    100, 101: begin
      OnlyChangeDirection := True;
      AddSecondSorter := False; //True; das geht nicht so ohne weiteres, wenn man nur die sortierrichtung umdreht ...
      newSorting := csDefault; // actually not used later
      newDirection := teSortDirection(sndTag mod 2);
    end;
  end;

  case MedienBib.BrowseMode of
      0: begin
            // classic browse mode
            // Get Collection, Get RootCollection, Get CollectionLevel
            lc := Nil;
            catNode := ArtistsVST.FocusedNode;
            if assigned(catNode) then
              lc := ArtistsVST.GetNodeData<TLibraryCategory>(catNode);

            ac := Nil;
            aNode := AlbenVST.FocusedNode;
            nLevel := AlbenVST.GetNodeLevel(aNode);
            if assigned(aNode) then
              ac := AlbenVST.GetNodeData<TAudioCollection>(aNode);

            if assigned(ac) and (ac is TAudioFileCollection) and (nLevel >= 0) then begin
              //acFile := TAudioFileCollection(ac);
              if not (ac is TRootCollection) and (ac.CollectionCount = 0) then begin
                dec(nLevel);
                //acFile := acFile.Parent;
              end;

              rc := TAudioFileCollection(ac).Root;

              MedienBib.ChangeFileCollectionSorting(lc.IndexOf(rc), nLevel, newSorting, newDirection, OnlyChangeDirection);    // newDirection = sd_Ascending
              if AddSecondSorter then
                MedienBib.ChangeFileCollectionSorting(lc.IndexOf(rc), nLevel, SecondSorting, SecondDirection, OnlyChangeDirection);    // newDirection = sd_Ascending

               // refill Tree
              AlbenVST.OnFocusChanged := NIL;
              FillCollectionTree(Nil, True);
              AlbenVST.OnFocusChanged := AlbenVSTFocusChanged;
            end;
       end;
      1: begin
            ac := MedienBib.NewCoverFlow.Collection[0];
            if assigned(ac) and (ac is TRootCollection) then begin
              MedienBib.ChangeFileCollectionSorting(0, 0, newSorting, newDirection, OnlyChangeDirection);    // newDirection= sd_Ascending
              if AddSecondSorter then
                MedienBib.ChangeFileCollectionSorting(0, 0, SecondSorting, SecondDirection, OnlyChangeDirection);
              FillCollectionCoverflow(MedienBib.CurrentCategory, True);
            end;
      end
      else
      begin
          // Tagcloud. Do nothing (menu item is disabled anyway)
      end;
  end;
end;

procedure TNemp_MainForm.PM_ML_SortPlaylistsDescendingClick(Sender: TObject);
var
  sndTag: Integer;
  newSorting: tePlaylistCollectionSorting;
  newDirection: teSortDirection;
begin
  if MedienBib.StatusBibUpdate >= 2 then
  begin
    TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
    exit;
  end;

  sndTag := (Sender as TMenuItem).Tag;
  if (sndTag >= Ord(Low(tePlaylistCollectionSorting))) and (sndTag <= Ord(High(tePlaylistCollectionSorting))) then begin
    newSorting := tePlaylistCollectionSorting(sndTag);
    newDirection := NempOrganizerSettings.PlaylistSortDirection;
  end else
  begin
    newSorting := NempOrganizerSettings.PlaylistSorting;
    newDirection := teSortDirection(sndTag mod 2);
  end;

  MedienBib.ChangePlaylistCollectionSorting(newSorting, newDirection);
  case MedienBib.BrowseMode of
    0: begin
      AlbenVST.OnFocusChanged := NIL;
      FillCollectionTree(Nil, True);
      AlbenVST.OnFocusChanged := AlbenVSTFocusChanged;
    end;
    1: begin
      FillCollectionCoverflow(MedienBib.CurrentCategory, True);
    end;
    2: ; // TagCloud: Nothing to do
  end;
end;


procedure TNemp_MainForm.TreePanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  PerForm(WM_SysCommand, $F012 , 0);
end;

procedure TNemp_MainForm.TntFormDestroy(Sender: TObject);
begin
    {$IFDEF USESTYLES}
    FreeAllControlStyleHooks;
    {$ENDIF}
    try
        RevokeDragDrop(Handle);

        RevokeDragFiles;
        IDropSource(fDropManager)._Release;// := Nil;

        TagLabelList.Free;
        CoverScrollbar.WindowProc := OldScrollbarWindowProc;
        LyricsMemo.WindowProc := OldLyricMemoWindowProc;
        AlphaBlendBMP.Free;
        (*
        fCurrentlySelectedFile.Free;
        Spectrum.Free;
        NempSkin.Free;
        NempPlaylist.Free;
        NempPlayer.Free;
        MedienBib.NewCoverFlow.DownloadThread := Nil;
        CoverDownloadThread.Terminate;
        CoverDownloadThread.WaitFor;
        CoverDownloadThread.Free;
        MedienBib.Free;
        BibRatingHelper.Free;
        LanguageList.Free;
        NempUpdater.Free;
        FreeAndNil(ErrorLog);*)
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
                //NempPlaylist.InsertNode := NIL;
                NempPlaylist.ResetInsertIndex;
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
                //NempPlaylist.InsertNode := NIL;
                NempPlaylist.ResetInsertIndex;
                newPlaylistFile := TAudioFile.Create;
                newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
                NempPlaylist.InsertFileToPlayList(newPlaylistFile);
            end;
            2: begin
                // enqueue after the current track
                //NempPlaylist.GetInsertNodeFromPlayPosition;
                NempPlaylist.InitInsertIndexFromPlayPosition(True);
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

procedure TNemp_MainForm.actJoinSplitWindowsExecute(Sender: TObject);
begin
  if NempSkin.NempPartyMode.Active then exit;
  // Application.ProcessMessages;
  // PostMessage(Handle, WM_MedienBib, MB_ToggleWindowMode, (Sender as TComponent).Tag mod 2);
  // When Calling from the MainMenu, this may crash, as we set the MainMenu := Nil in SplitMainForm
  // Posting a Message to Split the Form doesn't help, but a Timer does ....
  SplitWindowTimer.Tag := (Sender as TComponent).Tag;
  SplitWindowTimer.Enabled := True;
end;

procedure TNemp_MainForm.SplitWindowTimerTimer(Sender: TObject);
begin
  SplitWindowTimer.Enabled := False;
  if (NempOptions.Anzeigemode <> ((Sender as TComponent).Tag mod 2)) then
    SwapWindowMode(NempOptions.Anzeigemode + 1);
end;

procedure TNemp_MainForm.actToggleBrowseListExecute(Sender: TObject);
begin
  if NempOptions.AnzeigeMode = 0 then begin
    NempLayout.ShowBibSelection := not NempLayout.ShowBibSelection ;
    NempLayout.RefreshVisibilty;
    NempLayout.ReAlignMainForm;
  end else
  begin
    var newVisible: Boolean := NOT NempOptions.FormPositions[nfBrowse].Visible;
    NempOptions.FormPositions[nfBrowse].Visible := newVisible;
    RefreshSubForm(AuswahlForm, newVisible);
  end;
end;

procedure TNemp_MainForm.actToggleFileOverviewExecute(Sender: TObject);
begin
  if NempOptions.AnzeigeMode = 0 then begin
    NempLayout.ShowFileOverview := not NempLayout.ShowFileOverview;
    NempLayout.RefreshVisibilty;
    NempLayout.ReAlignMainForm;
  end else
  begin
    var newVisible: Boolean := NOT NempOptions.FormPositions[nfExtendedControls].Visible;
    NempOptions.FormPositions[nfExtendedControls].Visible := newVisible;
    RefreshSubForm(ExtendedControlForm, newVisible);
  end;
end;

procedure TNemp_MainForm.actToggleTitleListExecute(Sender: TObject);
begin
  if NempOptions.AnzeigeMode = 0 then begin
    NempLayout.ShowMedialist := not NempLayout.ShowMedialist;
    NempLayout.RefreshVisibilty;
    NempLayout.ReAlignMainForm;
  end else
  begin
    var newVisible: Boolean := NOT NempOptions.FormPositions[nfMediaLibrary].Visible;
    NempOptions.FormPositions[nfMediaLibrary].Visible := newVisible;
    RefreshSubForm(MedienListeForm, newVisible);
  end;
end;

procedure TNemp_MainForm.RefreshSubForm(aForm: TNempSubForm; IsVisible: Boolean);
begin
  aForm.Visible := IsVisible;
  if aForm.Visible then begin
    FormPosAndSizeCorrect(aForm);
    aForm.DoFormResize;
  end;
  ReInitDocks;
end;

procedure TNemp_MainForm.actTogglePlaylistExecute(Sender: TObject);
var newVisible: Boolean;
begin
  if NempOptions.AnzeigeMode = 0 then begin
    // nothing to do. Playlist is always visible in CompactMode
  end
  else begin
    newVisible := NOT NempOptions.FormPositions[nfPlaylist].Visible;
    NempOptions.FormPositions[nfPlaylist].Visible := newVisible;
    RefreshSubForm(PlaylistForm, newVisible);
  end;
end;

procedure TNemp_MainForm.actToggleStayOnTopExecute(Sender: TObject);
begin
  NempOptions.MiniNempStayOnTop := NOT NempOptions.MiniNempStayOnTop;
  RepairZOrder;
end;

procedure TNemp_MainForm.actTreeViewSideBySideExecute(Sender: TObject);
begin
  NempLayout.TreeviewOrientation := 0;
  ReAlignBrowseTrees;
end;

procedure TNemp_MainForm.actTreeviewStackedExecute(Sender: TObject);
begin
  NempLayout.TreeviewOrientation := 1;
  ReAlignBrowseTrees;
end;

procedure TNemp_MainForm.actToggleShowCategorySelectionExecute(Sender: TObject);
begin
  NempLayout.ShowCategoryTree := not NempLayout.ShowCategoryTree;
  ReAlignBrowseTrees;
  RefreshCategorySelectionVisibility;
end;

procedure TNemp_MainForm.actFileOverviewSideBySideExecute(Sender: TObject);
begin
  NempLayout.FileOVerviewOrientation := 0;
  ReAlignFileOverview;
end;

procedure TNemp_MainForm.actFileOverviewStackedExecute(Sender: TObject);
begin
  NempLayout.FileOVerviewOrientation := 1;
  ReAlignFileOverview;
end;

procedure TNemp_MainForm.actFileOverviewBothExecute(Sender: TObject);
begin
  NempLayout.FileOverviewMode := fovBoth;
  ReAlignFileOverview;
end;

procedure TNemp_MainForm.actFileOverviewOnlyCoverExecute(Sender: TObject);
begin
  NempLayout.FileOverviewMode := fovCover;
  ReAlignFileOverview;
end;

procedure TNemp_MainForm.actFileOverviewOnlyDetailsExecute(Sender: TObject);
begin
  NempLayout.FileOverviewMode := fovText;
  ReAlignFileOverview;
end;

procedure TNemp_MainForm.actShowControlCoverExecute(Sender: TObject);
begin
  NempLayout.ShowControlCover := not NempLayout.ShowControlCover;
  ReAlignControlCover;
end;

// Set the Checked/Visible/Enabled status of the Layout-Actions.
// Called in OnClick of the "View" MenuItems
procedure TNemp_MainForm.RefreshActionLayoutCheckedStatus;
begin
  actJoinWindows.Visible := NempOptions.Anzeigemode = 1;
  actSplitWindows.Visible := NempOptions.Anzeigemode = 0;
  actTogglePlaylist.Visible := NempOptions.Anzeigemode = 1;
  actToggleStayOnTop.Enabled := NempOptions.Anzeigemode = 1;

  if NempOptions.AnzeigeMode = 0 then begin
    actToggleBrowseList.Checked := NempLayout.ShowBibSelection;
    actToggleFileOverview.Checked := NempLayout.ShowFileOverview;
    actToggleTitleList.Checked := NempLayout.ShowMedialist;
    actToggleStayOnTop.Checked := False;
  end else
  begin
    actToggleFileOverview.Checked := NempOptions.FormPositions[nfExtendedControls].Visible;
    actTogglePlaylist.Checked  := NempOptions.FormPositions[nfPlaylist].Visible;
    actToggleTitleList.Checked := NempOptions.FormPositions[nfMediaLibrary].Visible;
    actToggleBrowseList.Checked := NempOptions.FormPositions[nfBrowse].Visible;
    actToggleStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
  end;

  actTreeviewStacked.Checked := NempLayout.TreeviewOrientation = 1;
  actTreeViewSideBySide.Checked := NempLayout.TreeviewOrientation = 0;
  actToggleShowCategorySelection.Checked := NempLayout.ShowCategoryTree;
  actFileOverviewBoth.Checked := NempLayout.FileOverviewMode = fovBoth;
  actFileOverviewOnlyCover.Checked := NempLayout.FileOverviewMode = fovCover;
  actFileOverviewOnlyDetails.Checked := NempLayout.FileOverviewMode = fovText;
  actFileOverviewStacked.Checked := NempLayout.FileOVerviewOrientation = 1;
  actFileOverviewSideBySide.Checked := NempLayout.FileOVerviewOrientation = 0;
  actShowControlCover.Checked := NempLayout.ShowControlCover;
end;


(*procedure TNemp_MainForm.BtnMenuClick(Sender: TObject);
var point: TPoint;
begin
  GetCursorPos(Point);
  Player_PopupMenu.Popup(Point.X, Point.Y+10);
end;*)

procedure TNemp_MainForm.BtnMinimizeClick(Sender: TObject);
begin
    Application.Minimize;
end;

procedure TNemp_MainForm._ControlPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TNemp_MainForm._ControlPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then exit;
    if not NempLayout_Ready then exit;
    ReAlignControlCover;
end;

procedure TNemp_MainForm.NewPlayerPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    PaintFrame.Visible := NewPlayerPanel.Width > 170;

    if assigned(NempPlayer) and NempPlayer.ABRepeatActive then
        RepositionABRepeatButtons;
end;



procedure TNemp_MainForm.Nichtvorhandenelschen1Click(Sender: TObject);
begin
  NempPlaylist.DeleteDeadFiles;
end;

procedure TNemp_MainForm.TabPanelMedienlisteClick(Sender: TObject);
var pt: TPoint;
begin
  //GetCursorPos(Point);
  //Medialist_View_PopupMenu.Popup(Point.X, Point.Y+10);
  pt := TabBtn_Medialib.ClientToScreen(Point(0,0));
  Medialist_View_PopupMenu.Popup(pt.X, pt.Y + TabBtn_Medialib.Height);
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

procedure TNemp_MainForm.RefreshAuswahlStatusLBL(newCaption: String);
var
  aLbl: TLabel;
begin
  case medienBib.BrowseMode of
    0: aLbl := AuswahlStatusLBL0;
    1: aLbl := AuswahlStatusLBL1;
    2: aLbl := AuswahlStatusLBL2;
  else
    aLbl := AuswahlStatusLBL0;
  end;
  aLbl.Caption := newCaption;
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

    PM_P_FormBuilder.Enabled := NempOptions.AnzeigeMode = 0;
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

    if NempPlaylist.PlaylistManager.PrepareRecentPlaylistLoading(
                    idx,
                    NempPlaylist.Playlist,
                    NempPlaylist.PlayingIndex,
                    Round(NempPlaylist.PlayingTrackPos) )
    then
    begin
        restart := NempPlayer.Status = Player_ISPLAYING;
        NempPlaylist.ClearPlaylist;
        NempPlaylist.PlaylistManager.Reset;
        NempPlaylist.LoadFromFile(NempPlaylist.PlaylistManager.RecentPlaylists[idx]);
        if restart then
        begin
          NempPlayer.LastUserWish := USER_WANT_PLAY;
          NempPlaylist.Play(0,0, True);
        end
    end;
end;


Procedure TNemp_MainForm.OnRecentPlaylistsChange(Sender: TObject);
var i: Integer;
    aMenuItem: TMenuItem;
    FileList: TStringList;
begin
    // Recent Playlists initialisieren
    MM_PL_RecentPlaylists.Clear;
    PM_PL_RecentPlaylists.Clear;
    PM_PLM_RecentPlaylists.Clear;

    FileList := (Sender as TPlaylistManager).RecentPlaylists;
    for i := 0 to FileList.Count - 1 do
    begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := LoadARecentPlaylist;
        aMenuItem.Caption := IntToStr(i) + ' - ' + FileList[i];
        aMenuItem.Tag := i;
        MM_PL_RecentPlaylists.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := LoadARecentPlaylist;
        aMenuItem.Caption := IntToStr(i) + ' - ' + FileList[i];
        aMenuItem.Tag := i;
        PM_PL_RecentPlaylists.Add(aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.OnClick := LoadARecentPlaylist;
        aMenuItem.Caption := IntToStr(i) + ' - ' + FileList[i];
        aMenuItem.Tag := i;
        PM_PLM_RecentPlaylists.Add(aMenuItem);
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

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.Caption := (Playlist_NoRecentlists);
        aMenuItem.Enabled := False;
        PM_PLM_RecentPlaylists.Add(aMenuItem);
    end;
end;

procedure TNemp_MainForm.OnFavouritePlaylistsChange(Sender: TObject);
var i: Integer;
    aMenuItem: TMenuItem;
    aList: TQuickLoadPlaylistCollection;
begin
    ///  Do not use PlaylistManagerPopup.Items.Clear; here,
    ///  as we want some of the menu items to be fixed
    ///  It's maybe not the fastest way, but we don't have THAT many Items anyway
    for i := PlaylistManagerPopup.Items.Count - 1 downto 0 do
    begin
        if PlaylistManagerPopup.Items[i].Tag <> -1 then
            PlaylistManagerPopup.Items.Delete(i);
    end;

    aList := NempPlaylist.PlaylistManager.QuickLoadPlaylists;

    for i := 0 to aList.Count - 1 do
    begin
        aMenuItem := TMenuItem.Create(PlaylistManagerPopup);
        aMenuItem.Caption := aList[i].Description;
        aMenuItem.Tag := i;
        aMenuItem.RadioItem := True;
        aMenuItem.OnClick := PM_PLM_LoadFavoritePlaylistClick;
        PlaylistManagerPopup.Items.Insert(i+1, aMenuItem);
        if NempPlaylist.PlaylistManager.CurrentIndex = i then
        begin
            aMenuItem.Default := True;
            aMenuItem.Checked := True;
        end;
    end;

    if NempPlaylist.PlaylistManager.CurrentIndex = -1 then
    begin
        PM_PLM_Default.Checked := True;
        PM_PLM_Default.Default := True;
    end;

    // Refresh the Playlist-Header
    PlaylistPropertiesChanged(NempPlaylist);

    // ReImport Playlists into the MediaLibrary
    // todo !! (oder das doch woanders machen???)
end;

procedure TNemp_MainForm.PlaylistManagerPopupPopup(Sender: TObject);
var i: Integer;
    EnableElements: Boolean;
begin
    EnableElements := Not NempSkin.NempPartyMode.Active;
    for i := 0 to PlaylistManagerPopup.Items.Count - 1 do
        PlaylistManagerPopup.Items[i].Enabled := EnableElements;

    if NempPlaylist.PlaylistManager.CurrentIndex >= 0 then
    begin
        PM_PLM_SaveAsExistingFavorite.Caption := Format(MainForm_SavePlaylistAsExistingFavorite, [NempPlaylist.PlaylistManager.CurrentPlaylistDescription]);
        PM_PLM_SaveAsExistingFavorite.Enabled := EnableElements;
    end else
    begin
        PM_PLM_SaveAsExistingFavorite.Caption := MainForm_SavePlaylistNotAvailable;
        PM_PLM_SaveAsExistingFavorite.Enabled := False;
    end;
end;

procedure TNemp_MainForm.PM_PLM_SaveAsExistingFavoriteClick(Sender: TObject);
begin
    NempPlaylist.PlaylistManager.SaveCurrentPlaylist(NempPlaylist.Playlist, False);
    PlayListStatusLBL.Caption := Format(PlaylistManager_Saved, [NempPlaylist.PlaylistManager.CurrentPlaylistDescription]);
end;

procedure TNemp_MainForm.OnPlaylistManagerReset(Sender: TObject);
begin
    if PlaylistManagerPopup.Items.Count > 0 then
    begin
        PlaylistManagerPopup.Items[0].Checked := True;
        PlaylistManagerPopup.Items[0].Default := True;
    end;
end;

procedure TNemp_MainForm.PM_PLM_SaveAsNewFavoriteClick(Sender: TObject);
var newFav: TQuickLoadPlaylist;
begin
    if not assigned(NewFavoritePlaylistForm) then
        Application.CreateForm(TNewFavoritePlaylistForm, NewFavoritePlaylistForm);

    if NewFavoritePlaylistForm.ShowModal = mrOK then
    begin
        // create a new FavoritePlaylist and add it to the PlaylistManager
        newFav := NempPlaylist.PlaylistManager.AddNewPlaylist(
            NewFavoritePlaylistForm.edit_PlaylistDescription.Text,
            NewFavoritePlaylistForm.edit_PlaylistFilename.Text,
            NempPlaylist.Playlist, False);

        NempPlaylist.PlaylistManager.SwitchToPlaylist(newFav);

        // Refresh the Header - show a new Playlist Description in it
        PlaylistPropertiesChanged(NempPlaylist);


        MedienBib.ImportFavoritePlaylists(NempPlaylist.PlaylistManager);
        Nemp_MainForm.ArtistsVST.Invalidate;

        if MedienBib.CurrentCategory = MedienBib.FavoritePlaylistCategory then
          ReFillBrowseTrees(True);
    end;
end;

procedure TNemp_MainForm.PM_PLM_EditFavouritesClick(Sender: TObject);
begin
    // PlaylistEditorForm
    if not assigned(PlaylistEditorForm) then
        Application.CreateForm(TPlaylistEditorForm, PlaylistEditorForm);

    PlaylistEditorForm.Show;
end;


procedure TNemp_MainForm.PM_PLM_SwitchToDefaultPlaylistClick(Sender: TObject);
var idx: Integer;
begin
    if NempPlaylist.PlaylistManager.CurrentIndex = -1 then
    // we are already in the "default playlist"
        exit;

    idx := (Sender as TMenuItem).Tag;
    if NempPlaylist.PlaylistManager.PreparePlaylistLoading(
                      idx,
                      NempPlaylist.Playlist,
                      NempPlaylist.PlayingIndex,
                      Round(NempPlaylist.PlayingTrackPos) )
    then
    begin
          NempPlaylist.PlaylistManager.Reset;
          // Refresh the Header - show a new Playlist Description in it
          PlaylistPropertiesChanged(NempPlaylist);
    end;
end;

procedure TNemp_MainForm.PM_PLM_LoadFavoritePlaylistClick(Sender: TObject);
var restart: boolean;
    idx, StartPos: Integer;
begin
    restart := NempPlayer.Status = Player_ISPLAYING;
    idx := (Sender as TMenuItem).Tag;

    // If the User selects the same playlist again
    // reload it (if it actually was changed, and the user confirmed it)
    if idx = NempPlaylist.PlaylistManager.CurrentIndex then
    begin
        if NempPlaylist.PlaylistManager.PrepareSamePlaylistLoading(
                      NempPlaylist.Playlist,
                      NempPlaylist.PlayingFileName,
                      Round(NempPlaylist.PlayingTrackPos) )
        then
        begin
            NempPlaylist.ClearPlaylist;
            NempPlaylist.LoadManagedPlayList(idx);
            If restart then
                NempPlayer.LastUserWish := USER_WANT_PLAY;

            StartPos := NempPlaylist.PlaylistManager.CurrentPlaylistTrackPos;

            NempPlaylist.Play(NempPlaylist.PlaylistManager.CurrentPlaylistIndex,
                  NempPlayer.FadingInterval, restart,
                  StartPos );
        end;
    end else
    // The User selected a different Favourite Playlist
    begin
        if NempPlaylist.PlaylistManager.PreparePlaylistLoading(
                      idx,
                      NempPlaylist.Playlist,
                      NempPlaylist.PlayingIndex,
                      Round(NempPlaylist.PlayingTrackPos) )
        then
        begin
            NempPlaylist.ClearPlaylist;
            NempPlaylist.LoadManagedPlayList(idx);

            (Sender as TMenuItem).Default := True;
            (Sender as TMenuItem).Checked := True;

            If restart then
                NempPlayer.LastUserWish := USER_WANT_PLAY;

            if NempPlaylist.SavePositionInTrack then
                StartPos := NempPlaylist.PlaylistManager.CurrentPlaylistTrackPos
            else
                StartPos := 0;

            NempPlaylist.Play(NempPlaylist.PlaylistManager.CurrentPlaylistIndex,
                  NempPlayer.FadingInterval, restart,
                  StartPos );
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
var  af: TAudioFile;
begin
    if (NempSkin.NempPartyMode.DoBlockTreeEdit)
    then
        allowed := false
    else
    begin
        af := VST.GetNodeData<TAudioFile>(Node);

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
                case Column of
                    colIdx_ARTIST,
                    colIdx_ALBUMARTIST,
                    colIdx_COMPOSER,
                    colIdx_TITLE,
                    colIdx_ALBUM,
                    colIdx_COMMENT,
                    colIdx_YEAR,
                    colIdx_GENRE,
                    colIdx_Track,
                    colIdx_BPM,
                    colIdx_HarmonicKey,
                    colIdx_CD: begin
                        if af.HasSupportedTagFormat then
                        begin
                            ClearShortCuts;
                            allowed := NempOptions.AllowQuickAccessToMetadata;
                        end else
                            allowed := False;
                    end;
                    colIdx_RATING: begin
                            ClearShortCuts;
                            allowed := True; // always allow edit of ratings
                            //allowed := NempOptions.AllowQuickAccessToMetadata;
                    end;
                else
                    {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
                    CON_PFAD, CON_ORDNER, CON_DATEINAME, colIdx_Lyrics, CON_EXTENSION }
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
    case Column of
        colIdx_RATING: begin
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
var af: tAudioFile;
    aErr: TNempAudioError;
    newRating: Byte;
begin
    if (NempSkin.NempPartyMode.DoBlockTreeEdit) then
        exit;

    SetShortCuts;
    MedienBib.Changed := True;

    af := VST.GetNodeData<TAudioFile>(Node);
    if assigned(af)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> af.Pfad)
    then
    begin
        if Column = colIdx_RATING then
        begin
            // Bugfix 4.13.2 // 4.14:
            // Only handle Rating here. Text information ist written in OnNewText

            // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
            newRating := af.Rating;
            af.GetAudioData(af.Pfad);
            af.Rating := newRating;

            aErr := af.WriteRatingsToMetaData(newRating, NempOptions.AllowQuickAccessToMetadata);

            if (aErr = AUDIOERR_None) then
            begin
                SyncAudioFilesWith(af);
                MedienBib.Changed := True;
                CorrectVCLAfterAudioFileEdit(af);
            end else
                // on Rating-Edit error: Just an entry in the Error-Log
                HandleError(afa_SaveRating, af, aErr);
        end;
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;

procedure TNemp_MainForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var af: TAudioFile;
    WriteNewStringData: Boolean;
    aErr: TNempAudioError;
    SearchDirty, CollectionDirty: Boolean;
begin
    af := VST.GetNodeData<TAudioFile>(Node);
    if not assigned(af) then  exit;

    if MedienBib.StatusBibUpdate > 1 then
    begin
        TranslateMessageDLG(Warning_MedienBibIsBusyEdit, mtWarning, [mbOK], 0);
        exit;
    end;

    if af.Pfad = MedienBib.CurrentThreadFilename then
    begin
        TranslateMessageDLG(Warning_MedienBibBusyThread, mtWarning, [mbOK], 0);
        exit;
    end;

    MedienBib.Changed := True;
    // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
    af.GetAudioData(af.Pfad); // not needed any more .... ?

    WriteNewStringData := True;
    case Column of
        colIdx_ARTIST : af.Artist := NewText;
        colIdx_ALBUMARTIST: af.AlbumArtist := NewText;
        colIdx_COMPOSER: af.Composer := NewText;
        colIdx_TITLE  : af.Titel := NewText;
        colIdx_ALBUM  : af.Album := NewText;
        colIdx_COMMENT : af.Comment := NewText;
        colIdx_YEAR : af.Year := NewText;
        colIdx_GENRE: af.Genre := NewText;
        colIdx_TRACK : af.Track := StrToIntDef(NewText, 0);
        colIdx_CD: af.CD := NewText;
        colIdx_BPM: af.BPM := NewText;
        colIdx_HarmonicKey: af.HarmonicKey := NewText;
    else
        {CON_DAUER, CON_BITRATE, CON_CBR, CON_MODE, CON_SAMPLERATE, CON_FILESIZE,
        CON_PFAD, CON_ORDNER, CON_DATEINAME, CON_LYRICSEXISTING, CON_EXTENSION, ... }
        // Nothing to do. Something was wrong ;-)
        WriteNewStringData := false;
    end;

    if WriteNewStringData then
    begin
        aErr := af.WriteStringToMetaData(NewText, Column, NempOptions.AllowQuickAccessToMetadata );
        if (aErr = AUDIOERR_None) then
        begin
            SyncAudioFilesWith(af);
            MedienBib.Changed := True;
            CorrectVCLAfterAudioFileEdit(af);

            // using variables, as we need to perform *both* checks, even if the first one is already TRUE
            SearchDirty := MedienBib.SearchStringIsDirty(Column);
            CollectionDirty := MedienBib.CollectionsAreDirty(Column);

            if SearchDirty or CollectionDirty then
              SetBrowseTabWarning(True);
        end else
        begin
            // Read old Data again, if we edited something else than RATING
            SynchAFileWithDisc(af, True);
            TranslateMessageDLG(NempAudioErrorString[aErr], mtWarning, [MBOK], 0);
            HandleError(afa_DirectEdit, af, aErr, True);
        end;
    end;
end;




procedure TNemp_MainForm.RepairZOrder;
begin
  if (NempOptions.MiniNempStayOnTop) AND (NempOptions.AnzeigeMode = 1) then
  begin
    // Fenster in den Vordergrund setzen.
    SetWindowPos(Nemp_MainForm.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  end else
  begin
    // Jetzt die Hautform NICHT in den Vordergrund setzen
    SetWindowPos(Nemp_MainForm.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  end;

  if assigned(PlaylistForm) and PlaylistForm.Visible then
    SetForeGroundWindow(PlaylistForm.Handle);
  if assigned(MedienlisteForm) and MedienlisteForm.Visible then
    SetForeGroundWindow(MedienlisteForm.Handle);
  if assigned(AuswahlForm) and AuswahlForm.Visible then
    SetForeGroundWindow(AuswahlForm.Handle);
  if assigned(ExtendedControlForm) and ExtendedControlForm.Visible then
    SetForeGroundWindow(ExtendedControlForm.Handle);

  SetForeGroundWindow(Handle);
end;



procedure TNemp_MainForm.PM_PL_ClearPlaylistClick(Sender: TObject);
begin
    NempPlaylist.ClearPlaylist(True);
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
        TreePanel.Repaint;
        CloudPanel.Repaint;
        CoverflowPanel.Repaint;

        {
        if MedienBib.BrowseMode = 2 then
        begin
            PanelTagCloudBrowse.Repaint;
            MedienBib.TagCloud.  ShowTags(False);
        end;
        }

        MedienlisteFillPanel.Repaint;
        GRPBOXVST.Repaint;
        DetailID3TagPanel.Repaint;

        AuswahlFillPanel0.Repaint;
        AuswahlFillPanel1.Repaint;
        AuswahlFillPanel2.Repaint;

        PlaylistFillPanel.Repaint;

        AuswahlHeaderPanel0.Repaint;
        AuswahlHeaderPanel1.Repaint;
        AuswahlHeaderPanel2.Repaint;

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
  // wenn das nciht durch den Timer automatisch gemacht w�rde.
  // Zeit und Spectrum-Informationen k�nnen nicht wieder gezeichnet werden.
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

procedure TNemp_MainForm.ShowDetailForm(aAudioFile: TAudioFile; DoShow: Boolean);
begin
  if NempSkin.NempPartyMode.DoBlockDetailWindow then exit;
  if not assigned(FDetails) then
    Application.CreateForm(TFDetails, FDetails);

  FDetails.NewAudioFileSelected(aAudioFile, DoShow);
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
        aMenuItem.Checked := (i=centerIdx) AND (NempPlaylist.PlayingFile = NempPlaylist.Playlist[i]);
        aMenuItem.OnClick := TNA_PlaylistClick;
        aMenuItem.Tag := i;
        aMenuItem.Caption := EscapeAmpersAnd(NempDisplay.PlaylistTitle(NempPlaylist.Playlist[i]));
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
    if (not BirthdayTimer.Enabled) AND (Not NempPlayer.CheckBirthdaySettings) then
    begin
          if TranslateMessageDLG((BirthdaySettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
          begin
            if Not Assigned(OptionsCompleteForm) then
                Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
            OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.BirthdayNode;
            OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.BirthdayNode] := True;
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabBirthday;
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
            // �berpr�fen auf SubDirs und diese entfernen
            MedienBib.ScanListContainsSubDirs(aDirList.Strings[i]);
            // Aktuellen Ordner einf�gen
            MedienBib.AutoScanDirList.Add(IncludeTrailingPathDelimiter(aDirList.Strings[i]));
          end;
       end;
    end;
  end; // if JobListContainsNewDirs
end;


procedure TNemp_MainForm.MedialistPanelResize(Sender: TObject);
begin
  if not FormReadyAndActivated then exit;
  if NempLayout_Ready then
    NempSkin.SetVSTOffsets;
end;

procedure TNemp_MainForm.MedienBibDetailPanelResize(Sender: TObject);
begin
  if not FormReadyAndActivated then exit;
  if NempLayout_Ready and MedienBibDetailPanel.Visible then
    NempLayout.ResizeSubPanel(MedienBibDetailPanel, DetailCoverLyricsPanel, NempLayout.FileOverviewCoverRatio);
end;


procedure TNemp_MainForm.DetailID3TagPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    if assigned(MedienBib) then
        RefreshVSTCoverTimer.Enabled := True;
end;



procedure TNemp_MainForm.PlaylistPanelResize(Sender: TObject);
begin
  if not FormReadyAndActivated then
      exit;

  if NempLayout_Ready then
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
var
  aCollection: TAudioCollection;
begin
  if (MedienBib.BrowseMode <> 1) or (not NempLayout.ShowBibSelection) then
    exit;

    if CoverScrollbar.Position <= MedienBib.NewCoverFlow.CoverCount - 1 then
    begin
        MedienBib.NewCoverFlow.CurrentItem := CoverScrollbar.Position;
        aCollection := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
        MedienBib.GenerateAnzeigeListe(aCollection);
        Lbl_CoverFlow.Caption := aCollection.Caption;
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

procedure TNemp_MainForm.PanelCoverBrowseDblClick(Sender: TObject);
var
  ac: TAudioCollection;
begin
  if (CoverScrollbar.Position > MedienBib.NewCoverFlow.CoverCount - 1) then
    exit;

  if NempPlaylist.UseDefaultActionOnCoverFlowDoubleClick then begin
    ac := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
    case  ac.CollectionClass of
      ccFiles: PlayEnqueue(ac, NempPlaylist.DefaultAction);
      ccPlaylists: PlayEnqueue(ac, NempPlaylist.DefaultAction);
      ccWebStations: TAudioWebradioCollection(ac).Station.TuneIn(NempPlaylist.BassHandlePlaylist);
    end;
  end;
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
    //if CoverFlowRefreshViewTimer.Enabled then exit;
    CoverFlowRefreshViewTimer.Enabled := False;
    MedienBib.NewCoverFlow.CurrentItem := MedienBib.NewCoverFlow.CurrentItem + 1;
    CoverFlowRefreshViewTimer.Enabled := True;
end;

procedure TNemp_MainForm.PanelCoverBrowseMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
    //if CoverFlowRefreshViewTimer.Enabled then exit;
    CoverFlowRefreshViewTimer.Enabled := False;
    MedienBib.NewCoverFlow.CurrentItem := MedienBib.NewCoverFlow.CurrentItem - 1;
    CoverFlowRefreshViewTimer.Enabled := True;
end;

procedure TNemp_MainForm.CoverFlowRefreshViewTimerTimer(Sender: TObject);
var
  aCollection: TAudioCollection;
begin
    CoverFlowRefreshViewTimer.Enabled := False;
    CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
    aCollection := MedienBib.NewCoverFlow.Collection[CoverScrollbar.Position];
    MedienBib.GenerateAnzeigeListe(aCollection);
    if assigned(aCollection) then
      Lbl_CoverFlow.Caption := aCollection.Caption
    else
      Lbl_CoverFlow.Caption := '';
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
        Newindex := MedienBib.NewCoverFlow.FindItemWithPrefix(SelectionPrefix, ActualIndex);
        // MedienBib.GetCoverWithPrefix(SelectionPrefix, ActualIndex);
        CoverScrollbar.Position := NewIndex;

        // Timer neustarten
        IncrementalCoverSearchTimer.Enabled := False;
        IncrementalCoverSearchTimer.Enabled := True;
    end;
    VK_F3:
    begin
        if OldSelectionPrefix = '' then Exit;
        ActualIndex := CoverScrollbar.Position;
        Newindex := MedienBib.NewCoverFlow.FindItemWithPrefix(OldSelectionPrefix, (ActualIndex + 1) Mod MedienBib.NewCoverFlow.CoverCount);
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
var
  DateiListe: TAudioFileList;
begin
  if ssleft in shift then
  begin
    if (abs(X - CoverImgDownX) > 5) or  (abs(Y - CoverImgDownY) > 5) then
    begin
      Dateiliste := TAudioFileList.Create(False);
      try
        GenerateSortedListFromCoverFlow(Dateiliste, false);
        InitiateDragDrop(DateiListe, IMGMedienBibCover, fDropManager, True, False); // AutoDecideExternalDrag
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
  // altes Menu mit Playlist-Eintr�gen erstellen und neues erstellen
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

    // ggf. den minIdx korrigieren, so dass immer count Eintr�ge da sind
    minIdx := maxIdx - NempPlaylist.TNA_PlaylistCount;
    if minIdx < 0 then minIdx := 0;

    for i := MaxIdx downto MinIdx do
    begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.RadioItem := True;
        aMenuItem.AutoCheck := True;
        aMenuItem.Checked := (i=centerIdx) AND (NempPlaylist.PlayingFile = NempPlaylist.Playlist[i]);
        aMenuItem.OnClick := TNA_PlaylistClick;
        aMenuItem.Tag := i;
        aMenuItem.Caption := EscapeAmpersAnd(NempDisplay.PlaylistTitle(NempPlaylist.Playlist[i]));
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
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabBirthday;
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.TabPanelPlaylistClick(Sender: TObject);
var pt: TPoint;
begin
  //GetCursorPos(Point);
  //PlayListPOPUP.Popup(Point.X, Point.Y+10);
  pt := TabBtn_Playlist.ClientToScreen(Point(0,0));
  PlayListPOPUP.Popup(pt.X, pt.Y + TabBtn_Playlist.Height);
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

procedure TNemp_MainForm.MM_T_DirectoriesProgramClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open' ,'explorer.exe', PCHAR('"'+ExtractFilePath(ParamStr(0))+'"'), '', sw_ShowNormal)
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

procedure TNemp_MainForm.MM_T_PluginsClick(Sender: TObject);
var
  i: Integer;
begin
  MM_T_PluginConfigure.Enabled := NempPlayer.DSPPluginActive;
  MM_T_PluginStop.Enabled := NempPlayer.DSPPluginActive;
  for i := 0 to MM_T_Plugins.Count - 5 do
    MM_T_Plugins.Items[i].Checked := MM_T_Plugins.Items[i].Tag = NempPlayer.ActivePluginIndex;
end;

procedure TNemp_MainForm.PM_P_PluginsClick(Sender: TObject);
var
  i: Integer;
begin
  PM_P_PluginConfigure.Enabled := NempPlayer.DSPPluginActive;
  PM_P_PluginStop.Enabled := NempPlayer.DSPPluginActive;
  for i := 0 to PM_P_Plugins.Count - 5 do
    PM_P_Plugins.Items[i].Checked := PM_P_Plugins.Items[i].Tag = NempPlayer.ActivePluginIndex;
end;

procedure TNemp_MainForm.PM_T_PluginsClick(Sender: TObject);
var
  i: Integer;
begin
  PM_T_PluginConfigure.Enabled := NempPlayer.DSPPluginActive;
  PM_T_PluginStop.Enabled := NempPlayer.DSPPluginActive;
  for i := 0 to PM_T_Plugins.Count - 5 do
    PM_T_Plugins.Items[i].Checked := PM_T_Plugins.Items[i].Tag = NempPlayer.ActivePluginIndex;
end;

procedure TNemp_MainForm.ActivateDSPPlugin(Sender: TObject);
begin
  if (Sender is TMenuItem) then begin
    NempPlayer.ActivateDSPPlugin(TMenuItem(Sender).Tag);
    ReArrangeToolImages;
  end;
end;

procedure TNemp_MainForm.MM_T_PluginConfigureClick(Sender: TObject);
begin
  NempPlayer.ConfigureActiveDSPPlugin;
end;

procedure TNemp_MainForm.MM_T_PluginStopClick(Sender: TObject);
begin
  NempPlayer.StopActiveDSPPlugin;
  ReArrangeToolImages;
end;

procedure TNemp_MainForm.MM_T_PluginOpenFolderClick(Sender: TObject);
var
  PluginPath: String;
begin
  PluginPath := IncludeTrailingPathdelimiter(SavePath) + 'Plugins\';
  if ForceDirectories(PluginPath) then
    ShellExecute(Handle, 'open' ,'explorer.exe', PChar('"' + PluginPath + '"'), '', sw_ShowNormal)
  else
    TranslateMessageDLG((Warning_PluginDirNotFound), mtWarning, [mbOk], 0);

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
    //AlbenVSTFocusChanged(AlbenVST, AlbenVST.FocusedNode, 0);
end;

procedure TNemp_MainForm.ArtistsVSTClick(Sender: TObject);
begin
    //ArtistsVSTFocusChanged(ArtistsVST, ArtistsVST.FocusedNode, 0);
end;


procedure TNemp_MainForm.fspTaskbarManagerThumbButtonClick(Sender: TObject;
  ButtonId: Integer);
var point: TPoint;
begin
    case ButtonID of
        0: PlayPrevBTNIMGClick(Nil);
        1: PlayPauseBTNIMGClick(Nil);
        502: StopBTNIMGClick(Nil);
        2: PlayNextBTNIMGClick(NIL);
        4: begin
            NempPlayer.Volume := NempPlayer.Volume - 10;
            CorrectVolButton;
        end;
        5: begin
            NempPlayer.Volume := NempPlayer.Volume + 10;
            CorrectVolButton;
        end;
        3: begin
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

procedure TNemp_MainForm.NempTaskbarManagerThumbPreviewRequest(Sender: TObject;
  APreviewHeight, APreviewWidth: Integer; PreviewBitmap: TBitmap);
begin
    NempPlayer.DrawPreviewNew(APreviewHeight, APreviewWidth, PreviewBitmap, NempSkin.isActive);
end;



procedure TNemp_MainForm.MM_H_CheckForUpdatesClick(Sender: TObject);
begin
    NempUpdater.CheckForUpdatesManually;
end;

procedure TNemp_MainForm.MM_H_CleanupUpdateClick(Sender: TObject);
begin
  if not assigned(FormUpdateCleaning) then
    Application.CreateForm(TFormUpdateCleaning, FormUpdateCleaning);
  FormUpdateCleaning.Show;
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

procedure TNemp_MainForm.TabBtn_Preselection0Click(Sender: TObject);
var pt: TPoint;
begin
  // GetCursorPos(Point);
  // Medialist_Browse_PopupMenu.Popup(Point.X, Point.Y+10);
  pt := (Sender as TSkinButton).ClientToScreen(Point(0,0));
  Medialist_Collection_PopupMenu.Popup(pt.X, pt.Y + (Sender as TSkinButton).Height);
end;


procedure TNemp_MainForm.TabBtnCoverCategoryClick(Sender: TObject);
var pt: TPoint;
begin
  // GetCursorPos(Point);
  // Medialist_Browse_Categories_PopupMenu.Popup(Point.X, Point.Y+10);
  pt := (Sender as TSkinButton).ClientToScreen(Point(0,0));
  Medialist_Browse_Categories_PopupMenu.Popup(pt.X, pt.Y + (Sender as TSkinButton).Height);
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
            OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabLastfm;
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
            OptionsCompleteForm.cpScrobbleLog.Caption := Scrobble_Inactive;
        end;
        if assigned(NempPlayer.MainAudioFile) and (NempPlayer.Status = PLAYER_ISPLAYING) then
        begin
            // nur neu Scrobbeln, wenn es vorher nicht getan wurde.
            // Sonst wird der Zeitz�hler zur�ckgesetzt, und Submitten ggf. unterbunden
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
            OptionsCompleteForm.cpScrobbleLog.Caption := Scrobble_Offline;
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
  OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabLastfm;
  OptionsCompleteForm.Show;
end;


procedure TNemp_MainForm.PM_P_ViewClick(Sender: TObject);
begin
  RefreshActionLayoutCheckedStatus
end;

procedure TNemp_MainForm.ToolImageClick(Sender: TObject);
var pt: TPoint;
begin
  // GetCursorPos(Point);
  // PopupTools.Popup(Point.X, Point.Y+10);
  pt := (Sender as TImage).ClientToScreen(Point(0,0));
  PopupTools.Popup(pt.X, pt.Y + (Sender as TImage).Height);
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
        NempWebServer.LoadSettings;
        // 2.) Medialib kopieren
        NempWebServer.CopyLibrary(MedienBib);
        NempWebServer.CopyDisplayHelper;
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
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.tabWebserver;
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


{
  --------------------------------------------
  New Drag&Drop for the Trees
  --------------------------------------------
}
///  1. Allow Dragging
///  -------------------------------------------------
///  * Category-Tree
///    - no Dragging at all.
procedure TNemp_MainForm.ArtistsVSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := False; // no Drag&Drop from the "artist tree" any more
end;

///  * CollectionTree
///    - no Drag&Drop for WebRadio-Collections, otherwise OK
procedure TNemp_MainForm.AlbenVSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  ac: TAudioCollection;
begin
  ac := AlbenVST.GetNodeData<TAudioCollection>(Node);
  Allowed := assigned(ac) and (ac.CollectionClass <> ccWebStations)
    and (ac.Count > 0);
end;

///  * PlaylistTree
///    - Drag&Drop only for Files, not for CueSheet-Nodes
procedure TNemp_MainForm.PlaylistVSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := Sender.GetNodeLevel(Node) = 0;
end;

///  * MainVST at the bottom: Allow always
procedure TNemp_MainForm.VSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
end;

///  2. Start Dragging (VCL part)
///  -------------------------------------------------
///  * Collection Tree: Init Drag with the selected Collection
procedure TNemp_MainForm.AlbenVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  DateiListe: TAudioFileList;
begin
  Dateiliste := TAudioFileList.Create(False);
  try
    if GenerateSortedListFromCollectionTree(DateiListe, False) then
      InitiateDragDrop(DateiListe, AlbenVST, fDropManager, False, False);
  finally
    FreeAndNil(Dateiliste);
  end;
end;

///  * Other Trees (with Files at the nodes) Init Drag from the selected nodes
procedure TNemp_MainForm.VSTFilesStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  InitiateDragDrop(Sender as TVirtualStringTree, fDropManager, False, False);
end;

procedure TNemp_MainForm.PlaylistVSTStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  InitiateDragDrop(Sender as TVirtualStringTree, fDropManager, False, True);
end;

///  3. Begin OLE-Dragging: GetUserClipboardFormats
///  -------------------------------------------------
///  * For all Trees the same: Add "CF_HDROP" to enable dragging files to the explorer
///    IMPORTANT: Remove "DragMove" from the allowed operations in that case (to avoid messing up the users file system)
procedure TNemp_MainForm.TreesGetUserClipboardFormats(
  Sender: TBaseVirtualTree; var Formats: TFormatEtcArray);
var
  i: Integer;
  State: TKeyboardState;
begin
    GetKeyboardState(State);
    if ((State[VK_CONTROL] and 128) = 0)
      and ((State[VK_RButton] and 128) = 0)
    then
      (Sender as TVirtualStringTree).DragOperations := [doCopy, doMove]
    else
    begin
      (Sender as TVirtualStringTree).DragOperations := [doCopy];
      i := Length(Formats);
      SetLength(Formats, i + 1);
      Formats[i].cfFormat := CF_HDROP;
      Formats[i].ptd := nil;
      Formats[i].dwAspect := DVASPECT_CONTENT;
      Formats[i].lindex := -1;
      Formats[i].tymed := TYMED_HGLOBAL;
    end;
end;

///  4. During OLE-Dragging: RenderOLEData
///  -------------------------------------------------
///  * For all Trees the same: Convert the Filenames remembered in StartDrag (the VCL-Operation)
///    into the OLE-Dataformat in the CF_HDROP section
procedure TNemp_MainForm.TreesRenderOLEData(Sender: TBaseVirtualTree; const FormatEtcIn: tagFORMATETC;
  out Medium: tagSTGMEDIUM; ForClipboard: Boolean; var Result: HRESULT);
begin
  if FormatEtcIn.cfFormat = CF_HDROP then
    result := OLERenderFilenames(fDropManager.Files, Medium);
end;

///  5. During Dragging: DragOver (many different options ...)
///  -------------------------------------------------
///  * Trees listing Files/Collections from the Library:
///    - possible Actions are "add to the Library" and "add to category"
///    - give Feedback when no proper action will be executed
///      (i.e. the user is just dragging within the library )

procedure TNemp_MainForm.HandleLibraryDragOver(lc: TLibraryCategory; DataObject: IDataObject; Shift: TShiftState; State: TDragState;
        detailedInternalDrop: Boolean; var Effect: Integer; var Accept: Boolean; var HintStr: String);

  procedure SetFeedBackParams(vEffect: Integer; vAccept: Boolean; vHint: String);
  begin
    Effect := vEffect;
    Accept := vAccept;
    HintStr := vhint;
  end;

  procedure SetExternalOrPlayerFeedback;
  begin
    if assigned(lc) and (LC.CategoryType = ccFiles) and (not lc.IsDefault) and (not lc.IsNew) then
      SetFeedBackParams(DROPEFFECT_COPY, True, DragDropLibraryCategory)
    else
      SetFeedBackParams(DROPEFFECT_COPY, True, DragDropLibrary);
  end;

begin
  if assigned(fDropManager.DragSource) then begin
    if fDropManager.SourceIsPlayer then begin
      // Dragging from the Player/Playlist to the Library
      SetExternalOrPlayerFeedback;
    end
    else begin
      // DragSource is the MediaLibrary itself
      if not detailedInternalDrop then begin
            // moving within the library without specifying a different category doesn't make sense
            SetFeedBackParams(DROPEFFECT_NONE, False, DragDropHintTargetPlaylistOrCategory);
      end
      else begin
            if assigned(lc) and (LC.CategoryType = ccFiles) then begin
              if (ssCtrl in Shift) then
                SetFeedBackParams(DROPEFFECT_COPY, True, DragDropCategoryCopy)
              else
                SetFeedBackParams(DROPEFFECT_MOVE, True, DragDropCategoryMOVE);
            end else
            begin
              if assigned(lc) then // ... but not a File Category
                SetFeedBackParams(DROPEFFECT_NONE, False, DragDropLibraryInternFailCategory)
              else
                SetFeedBackParams(DROPEFFECT_NONE, False, DragDropHintTargetPlaylistOrCategory);
            end;
      end;
    end;
  end else
  begin
    // DragOver from the Windows Explorer (or something like that)
    if not ObjContainsFiles(DataObject) then
      SetFeedBackParams(DROPEFFECT_NONE, False, '')
    else
      SetExternalOrPlayerFeedback
  end;
end;

procedure TNemp_MainForm.LibraryMetaDragOver(Shift: TShiftState; State: TDragState;
  Pt: TPoint; Mode: TDropMode; DataObject: IDataObject;
  var Effect: Integer; var Accept: Boolean);
var
  lc: TLibraryCategory;
  TargetCount: Integer;
  HintStr, LCName: String;

begin
  if State = dsDragLeave then begin
    SetDragHint(DataObject, '', '', Effect);
    exit;
  end;

  lc := MedienBib.CurrentCategory;
  LCName := MedienBib.GetTargetFileCategoryName(lc, TargetCount);
  HandleLibraryDragOver(lc, DataObject, Shift, State,
        False, Effect, Accept, HintStr);

  // Adjust the DragHint
  SetDragHint(DataObject, HintStr, LCName, Effect);
end;

procedure TNemp_MainForm.LibraryCollectionTreeDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
  var Effect: Integer; var Accept: Boolean);
begin
  // (also ussed for the main VST with the media list)
  LibraryMetaDragOver(Shift, State, Pt, Mode, Sender.DragManager.DataObject, Effect, Accept);
end;

///  * The Category-Treeview
///    - possible Actions are
///      - add to the Library
///      - Copy to Category
///      - Move to Category
///    - give Feedback when no proper action will be executed
///      (i.e. the user is just dragging within the library, but no specific Category )
procedure TNemp_MainForm.CategoryVSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  lc: TLibraryCategory;
  TargetCount: Integer;
  HintStr, LCName: String;

begin
  if State = dsDragLeave then begin
    SetDragHint(Sender.DragManager.DataObject, '', '', Effect);
    exit;
  end;

  lc := ArtistsVST.GetNodeData<TLibraryCategory>(ArtistsVST.DropTargetNode);
  LCName := MedienBib.GetTargetFileCategoryName(lc, TargetCount);
  HandleLibraryDragOver(lc, (Sender as TVirtualStringTree).DragManager.DataObject, Shift, State,
        True, Effect, Accept, HintStr);

  SetDragHint(Sender.DragManager.DataObject, HintStr, LCName, Effect);
end;

///  * The Playlist-Treeview
///    - possible Actions are
///      - add to the Playlist
///      - Copy from Playlist to Playlist
///      - Move within the Playlist
procedure TNemp_MainForm.PlaylistVSTDragOver(Sender: TBaseVirtualTree;
    Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
    Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  szMessage: String;
  ValidNode: Boolean;

  procedure SetFeedBackParams(vEffect: Integer; vAccept: Boolean; vHint: String);
  begin
    Effect := vEffect;
    Accept := vAccept;
    szMessage := vhint;
  end;

begin
    if State = dsDragLeave then begin
      SetDragHint(Sender.DragManager.DataObject, '', '', Effect);
      Accept := True;
      exit;
    end;

    ValidNode := ValidPlaylistDropNode(PlayListVST, PlayListVST.DropTargetNode);

    if fDropManager.DragSource = PlaylistVST then begin
      // Drag&Drop within the Playlist
      // The Effect will be set automatically by the Treeview according to Keyboard-Modifiers
      // But we have to set the DragHint again
      case Effect of
        DROPEFFECT_MOVE: szMessage := DragDropPlaylistMove;
        DROPEFFECT_COPY: szMessage := DragDropPlaylistCopy;
      else
        szMessage := DragDropPlaylistMove; // this case shouldn't happen
      end;
      // Accept only at NodeLevel 0: We can't Copy/Move a file into a CueList
      Accept := ValidPlaylistDropNode(PlayListVST, PlayListVST.DropTargetNode);
    end else
    begin
        // DragSource is NOT the Playlist, so we are expecting new Files for the Playlist
        // Either from the Library or from external sources
        if assigned(fDropManager.DragSource) then
          // From internal sources: Always Accept (except on cueNodes)
          SetFeedBackParams(DROPEFFECT_COPY, ValidNode, DragDropPlaylistAdd)
        else begin
          // From external sources: Do accept only "Files", but not things like "Text"
          // Note: Some other stuff like "E-Mails" dragged from Thunderbird are also considered as "Files"
          if ObjContainsFiles(Sender.DragManager.DataObject) then
            SetFeedBackParams(DROPEFFECT_COPY, ValidNode, DragDropPlaylistAdd)
          else
            // Definitely no Files - don't accept
            SetFeedBackParams(DROPEFFECT_NONE, False, '')
        end;
    end;
    // correct Efect/Hintstr if Accept is False
    if not Accept then
      SetFeedBackParams(DROPEFFECT_NONE, False, '');

    SetDragHint(Sender.DragManager.DataObject, szMessage, '', Effect);
end;

procedure TNemp_MainForm.TitlesVSTGetHintKind(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Kind: TVTHintKind);
begin
  if MedienBib.ShowAdvancedHints then
    Kind := vhkOwnerDraw
  else
    Kind := vhkText;
end;

procedure TNemp_MainForm.TitlesVSTDrawHint(Sender: TBaseVirtualTree;
  HintCanvas: TCanvas; Node: PVirtualNode; R: TRect; Column: TColumnIndex);
var
  af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if assigned(af) then
    VSTDrawCoverHint((Sender as TVirtualStringTree), HintCanvas, af, R, BibRatingHelper);
end;

procedure TNemp_MainForm.TitlesVSTGetHintSize(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var R: TRect);
var
  af: TAudioFile;
begin
  af := Sender.GetNodeData<TAudioFile>(Node);
  if assigned(af) then
    VSTGetCoverHintSize((Sender as TVirtualStringTree), af, R, BibRatingHelper);
end;



///  * Other Controls, handled by our own NempDropManager
///    - The Player Control
///    - The CoverFlow
///    - The TagCloud
///    Possible Actions are
///      - add to the Playlist (PlayerControls)
///      - add to the Library (CoverFlow, TagCloud)
procedure TNemp_MainForm.OnNempDragover(Shift: TShiftState; State: TDragState;
        Pt: TPoint; var Effect: Integer; var Accept: Boolean);
var
  o: TWinControl;
  szMessage: String;

  procedure SetFeedBackParams(vEffect: Integer; vAccept: Boolean);
  begin
    Effect := vEffect;
    Accept := vAccept;
  end;

begin
  o := FindVCLWindow(pt);
  case GetDropWindowSection(o) of
    ws_none,
    ws_Playlist: szMessage := ''; // Should not happen

    // Target is Library: Do the same as for the CollectionTree/FileTree
    ws_Library : begin
      LibraryMetaDragOver(Shift, State, Pt, dmOnNode, fDropManager.DataObject, Effect, Accept);
    end;

    // Target are the Player Controls
    ws_Controls: begin
          if MainPlayerControlsActive then
            szMessage := DragDropPlayerMain
          else
            szMessage := DragDropPlayerHeadset;
          if assigned(fDropManager.DragSource) then
            SetFeedBackParams(DROPEFFECT_COPY, True)
          else begin
            if ObjContainsFiles(fDropManager.DataObject) then
              SetFeedBackParams(DROPEFFECT_COPY, True)
            else begin
              SetFeedBackParams(DROPEFFECT_NONE, False);
              szMessage := '';
            end;
          end;
          SetDragHint(fDropManager.DataObject, szMessage, '', Effect);
    end;
  end;
end;

///  6. Dropping (many different options ...)
///  -------------------------------------------------
///  * Trees listing Files/Collections from the Library:
///    - possible Actions are "add to the Library" or "add to category"
procedure TNemp_MainForm.LibraryCollectionTreeDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
begin
  LibraryMetaDragDrop(Shift, Pt, Mode, DataObject, Effect);
end;

procedure TNemp_MainForm.LibraryMetaDragDrop(Shift: TShiftState; Pt: TPoint;
  Mode: TDropMode; DataObject: IDataObject; var Effect: Integer);
var
  lc: TLibraryCategory;
  FileList: TStringList;
begin
  lc := MedienBib.CurrentCategory;
  FileList := TStringList.Create;
  try
    if assigned(fDropManager.DragSource) and (fDropManager.SourceIsPlayer) then begin
      for var i: Integer := 0 to FDropManager.FileNameCount - 1 do
        FileList.Add(FDropManager.FileNames[i]);
      Handle_DropFilesForLibrary(FileList, lc, True);
    end else
    begin
      // external DropSource
      GetFileListFromObj(DataObject, FileList);
      Handle_DropFilesForLibrary(FileList, lc, False);
    end;
  finally
    FileList.Free;
  end;
end;

///  -------------------------------------------------
///  * Other Controls, handled by our own NempDropManager
///    - The Player Control
///    - The CoverFlow
///    - The TagCloud
///    Possible Actions are
///      - add to the Playlist (PlayerControls)
///      - add to the Library (CoverFlow, TagCloud)
procedure TNemp_MainForm.OnNempDrop(const DataObject: IDataObject; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer);
var
  o: TWinControl;
  i: Integer;
  FileList: TStringList;
begin
  o := FindVCLWindow(pt);
  case GetDropWindowSection(o) of
    ws_none,
    ws_Playlist: ; // Should not happen

    // Target is Library: Do the same as for the CollectionTree/FileTree
    ws_Library : begin
      LibraryMetaDragDrop(Shift, Pt, dmOnNode, DataObject, Effect);
    end;

    // Target is one of the Player Controls
    ws_Controls: begin
          FileList := TStringList.Create;
          try
              if assigned(fDropManager.DragSource) then begin
                for i := 0 to FDropManager.FileNameCount - 1 do
                  FileList.Add(FDropManager.FileNames[i]);
              end
              else begin
                if ObjContainsFiles(fDropManager.DataObject) then
                  GetFileListFromObj(DataObject, FileList);
                //else: nothing to do
              end;

              if MainPlayerControlsActive then
                Handle_DropFilesForPlaylist(FileList, True, Nil, dmOnNode, True)
              else
                Handle_DropFilesForHeadPhone(FileList);

          finally
            FileList.Free;
          end;
    end;
  end;
end;

///  * The Category-Treeview
///    - possible Actions are
///      - add to the Library
///      - Copy to Category
///      - Move to Category
procedure TNemp_MainForm.CategoryVSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  TargetCategory: TLibraryCategory;
  FileList : TStringList;
  AudioFileList: TAudioFileList;
  af: TAudioFile;
  i: Integer;
begin
  TargetCategory := ArtistsVST.GetNodeData<TLibraryCategory>(ArtistsVST.DropTargetNode);

        if assigned(fDropManager.DragSource) then begin
          if assigned(TargetCategory) and (TargetCategory is TLibraryFileCategory) and
                ((fDropManager.DragSource = VST)
             or (fDropManager.DragSource = AlbenVST))
          then begin
            // we are dropping Files from the Library
            AudioFileList := TAudioFileList.Create(False);
            try
              for i := 0 to fDropManager.FileNameCount - 1 do begin
                af := MedienBib.GetAudioFileWithFilename(fDropManager.Filenames[i]);
                if assigned(af) then
                  AudioFileList.Add(af);
              end;

              if Effect = DROPEFFECT_COPY then
                MedienBib.ChangeCategory(MedienBib.CurrentCategory, TargetCategory, AudioFileList, caCategoryCopy)
              else
                MedienBib.ChangeCategory(MedienBib.CurrentCategory, TargetCategory, AudioFileList, caCategoryMove);
              MedienBib.RefreshCollections(False);

              ArtistsVST.Invalidate;
            finally
              AudioFileList.Free;
            end;
          end else
          begin
            // We do NOT allow library-internal Drag&Drop into a non-FileCategory
            // Therefore: if we reach this code, the DropSource IS the Player/Playlist
            // The TargetCategory (i.e. the DropTargetNode) may be a non-FileCategory, but this will be fixed by Handle_DropFilesForLibrary
            // => Get the FileList from the DragDropManager and add it to the Library. Allow changing of Category for existing files (if it is a FileCategory)
            FileList := TStringList.Create;
            try
              if (fDropManager.SourceIsPlayer) then begin
                for i := 0 to FDropManager.FileNameCount - 1 do
                  FileList.Add(FDropManager.FileNames[i]);
                Handle_DropFilesForLibrary(FileList, TargetCategory, TargetCategory is TLibraryFileCategory);
              end
            finally
              FileList.Free;
            end;
          end;
        end
        else begin
          // Files from an external source
          // Add them into the Media Library
          if ObjContainsFiles(fDropManager.DataObject) then begin
            FileList := TStringList.Create;
            try
              GetFileListFromObj(DataObject, FileList);
              Handle_DropFilesForLibrary(FileList, TargetCategory, True);
            finally
              FileList.Free;
            end;
          end;
        end;
end;




///  * PlaylistTree
///    Possible actions are
///      - add to the Playlist
///      - Copy from Playlist to Playlist
///      - Move within the Playlist
procedure TNemp_MainForm.PlaylistVSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var Attachmode: TVTNodeAttachMode;
    Nodes: TNodeArray;
    aNode: PVirtualNode;
    i: Integer;
    NewSortList: TAudioFileList;
    FileList: TStringList;
begin
    if NOT assigned(fDropManager.DragSource) then begin
      // Drop from an external Source.
      // Try to get Files from the OLEDrag-Object and insert it into the Playlist
      FileList := TStringList.Create;
      try
        if ObjContainsFiles(fDropManager.DataObject) then begin
          GetFileListFromObj(DataObject, FileList);
          Handle_DropFilesForPlaylist(FileList, False, PlaylistVST.DropTargetNode, Mode, False);
        end;
      finally
        FileList.Free;
      end;
    end else
    begin
       // Internal Drop.
       // In DragOver we have decided whether we want o MOVE or COPY the selected tracks
        if Effect = DROPEFFECT_COPY then begin
          // Use the Filenames stored in the DropManager
          FileList := TStringList.Create;
          try
            for i := 0 to FDropManager.FileNameCount - 1 do
              FileList.Add(FDropManager.FileNames[i]);
            Handle_DropFilesForPlaylist(FileList, False, PlaylistVST.DropTargetNode, Mode, False);
          finally
            FileList.Free;
          end;
        end else
        begin
          // Just move the Nodes
                // Get the selected Nodes
                // Note: This Selection may differ from the one we started with (?)
                //       as the playlist can auto-delete nodes when playback is finished
                Nodes := PlaylistVST.GetSortedSelection(True);

                // Translate the drop position into an node attach mode.
                case Mode of
                    dmAbove : AttachMode := amInsertBefore;
                    dmOnNode: AttachMode := amInsertAfter;
                    dmBelow : AttachMode := amInsertAfter;
                else
                    AttachMode := amNowhere;
                end;

                // move the selected Nodes to Target
                if not assigned(PlaylistVST.DropTargetNode) then
                begin
                    // DropTarget is the empty space below the (small) Playlist
                    // => Move files to the end of the Playlist
                    aNode := PlaylistVST.GetLastChild(Nil);
                    for i := High(Nodes) downto 0 do
                        PlaylistVST.MoveTo(Nodes[i], aNode, amInsertAfter, False)
                end else
                begin
                    if AttachMode = amInsertBefore then
                        for i := 0 to High(Nodes) do
                            PlaylistVST.MoveTo(Nodes[i], PlaylistVST.DropTargetNode, AttachMode, False)
                    else
                        for i := High(Nodes) downto 0 do
                            PlaylistVST.MoveTo(Nodes[i], PlaylistVST.DropTargetNode, AttachMode, False);
                end;
          // after Moving the Nodes, rebuild the Playlist according to the new Node-sorting
                NewSortList := TAudioFileList.Create(False);
                try
                    aNode := PlaylistVST.GetFirst;
                    while assigned(aNode)  do
                    begin
                        NewSortList.Add(PlaylistVST.GetNodeData<TAudioFile>(aNode));
                        aNode := PlaylistVST.GetNextSibling(aNode);
                    end;
                    // ... and apply this sorting to the actual playlist
                    NempPlaylist.GetSortOrderFromList(NewSortList);
                finally
                    NewSortList.Free;
                end;
        end;
        FDropManager.FinishDrag;
        NempPlaylist.PlaylistHasChanged := True;
    end;
end;



///  XXXX. End Dragging (VCL part)
///  -------------------------------------------------
///  * Library-Trees: just clear the DropManager
procedure TNemp_MainForm.LibraryVSTEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  fDropManager.FinishDrag;
end;

///  * Playlist: Also Re-Init Playlist
procedure TNemp_MainForm.PlaylistVSTEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    NempPlaylist.ReInitPlaylist;  // 4.14: Still needed??
    FDropManager.FinishDrag;
end;


procedure TNemp_MainForm.ReSizeBrowseTrees;
begin
  if not NempLayout.ShowCategoryTree then
    exit;

  if NempLayout.TreeviewOrientation = 0 then
    ArtistsVST.Width := Round(PanelStandardBrowse.Width * NempLayout.TreeViewRatio / 100)
  else
    ArtistsVST.Height := Round(PanelStandardBrowse.Height * NempLayout.TreeViewRatio / 100);
end;

procedure TNemp_MainForm.RefreshCategorySelectionVisibility;
begin
   // Show/Hide category selection
  TabBtnCoverCategory.Visible := NempLayout.ShowCategoryTree;
  TabBtnTagCloudCategory.Visible := NempLayout.ShowCategoryTree;
  CloudViewer.CategorySelectionVisible := NempLayout.ShowCategoryTree;
  if (not NempLayout.ShowCategoryTree) and (MedienBib.CurrentCategory <> MedienBib.DefaultFileCategory)  then begin
    MedienBib.CurrentCategory := MedienBib.DefaultFileCategory;
    ReFillBrowseTrees(False);
  end;
  if MedienBib.BrowseMode = 2 then
    CloudViewer.ResizePaint(''); // just in case
end;


procedure TNemp_MainForm.ReAlignBrowseTrees;
begin
  if ((ArtistsVST.Align = alTop) and (NempLayout.TreeviewOrientation = 0))
    OR ((ArtistsVST.Align = alLeft) and (NempLayout.TreeviewOrientation = 1))
    OR (ArtistsVST.Visible <> NempLayout.ShowCategoryTree)
  then begin
    LockWindowUpdate(PanelStandardBrowse.Handle);
    // current Layout does not match the NempLayout.TreeviewOrientation
    ArtistsVST.Align := alNone;
    AlbenVST.Align := alNone;
    if (NempLayout.TreeViewRatio <= 5) or (NempLayout.TreeViewRatio >= 95) then
      NempLayout.TreeViewRatio := 30;

    if not NempLayout.ShowCategoryTree then begin
      ArtistsVST.Visible := False;
      SplitterBrowse.Visible := False;
    end else
    begin
      ArtistsVST.Visible := True;
      SplitterBrowse.Visible := True;
      if NempLayout.TreeviewOrientation = 0 then begin
        // Side by side
        ArtistsVST.Align := alLeft;
        ArtistsVST.Width := Round(PanelStandardBrowse.Width * NempLayout.TreeViewRatio / 100);
        SplitterBrowse.Align := alLeft;
        SplitterBrowse.Left := ArtistsVST.Width;
      end else begin
        // About each other
        ArtistsVST.Align := alTop;
        ArtistsVST.Height := Round(PanelStandardBrowse.Height * NempLayout.TreeViewRatio / 100);
        SplitterBrowse.Align := alTop;
        SplitterBrowse.Top := ArtistsVST.Height;
      end;
    end;
    AlbenVST.Align := alClient;
    LockWindowUpdate(0);
  end;
end;

procedure TNemp_MainForm.ReAlignFileOverview;
begin
  LockWindowUpdate(ContainerPanelMedienBibDetails.Handle);

  DetailCoverLyricsPanel.Align := alNone;
  DetailID3TagPanel.Align := alNone;

  case NempLayout.FileOverviewMode of
    fovCover: begin
      SplitterFileOverview.Visible := False;
      DetailCoverLyricsPanel.Visible := True;
      DetailID3TagPanel.Visible := False;
      DetailCoverLyricsPanel.Align := alClient;
    end;
    fovText: begin
      SplitterFileOverview.Visible := False;
      DetailCoverLyricsPanel.Visible := False;
      DetailID3TagPanel.Visible := True;
      DetailID3TagPanel.Align := alClient;
    end;
    fovBoth: begin
      if (NempLayout.FileOverviewCoverRatio <= 5) or (NempLayout.FileOverviewCoverRatio >= 95) then
        NempLayout.FileOverviewCoverRatio := 50;
      SplitterFileOverview.Visible := True;
      DetailCoverLyricsPanel.Visible := True;
      DetailID3TagPanel.Visible := True;
      if NempLayout.FileOVerviewOrientation = 0 then begin
        // Side by Side
        DetailCoverLyricsPanel.Align := alLeft;
        DetailCoverLyricsPanel.Width := Round(ContainerPanelMedienBibDetails.Width * NempLayout.FileOverviewCoverRatio  / 100);
        SplitterFileOverview.Align := alLeft;
        SplitterFileOverview.Left := DetailCoverLyricsPanel.Width;
      end else begin
        // Stacked
        DetailCoverLyricsPanel.Align := alTop;
        DetailCoverLyricsPanel.Height := Round(ContainerPanelMedienBibDetails.Height * NempLayout.FileOverviewCoverRatio  / 100);
        SplitterFileOverview.Align := alTop;
        SplitterFileOverview.Top := DetailCoverLyricsPanel.Height;
      end;
      DetailID3TagPanel.Align := alClient;
    end;
  end;
  LockWindowUpdate(0);
end;

procedure TNemp_MainForm.ReAlignControlCover;
var
  currentVis: Boolean;
begin
  currentVis := PlayerControlCoverPanel.Visible;
  PlayerControlCoverPanel.Visible := (_ControlPanel.Width > 550) and NempLayout.ShowControlCover;

  if PlayerControlCoverPanel.Visible then begin
    if not currentVis then
      // refresh Display, especially the cover (otherwise there is a problem with transparency)
      ShowMatchingControls;
    ControlContainer1.Width := OutputControlPanel.Width
                         + PlayerControlCoverPanel.Width
                         + PlayerControlPanel.Width
  end
  else
      ControlContainer1.Width := OutputControlPanel.Width
                         + PlayerControlPanel.Width
end;

procedure TNemp_MainForm.AfterLayoutBuild(Sender: TObject);
begin
  ReAlignBrowseTrees;
  ReAlignFileOverview;

  MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);

  // Show/Hide category selection
  RefreshCategorySelectionVisibility;
  CorrectSkinRegionsTimer.Enabled := True;

  if NempSkin.isActive then
    NempLayout.SplitterColor := NempSkin.SkinColorScheme.SplitterColor;

  if NempSkin.isActive and (NempOptions.AnzeigeMode = 0) then
  begin
    NempSkin.RepairSkinOffset;
    NempSkin.SetArtistAlbumOffsets;
    NempSkin.SetVSTOffsets;
    NempSkin.SetPlaylistOffsets;
  end;
end;

// Splitter between Categories and Collections
procedure TNemp_MainForm.SplitterBrowseMoved(Sender: TObject);
begin
  if not FormReadyAndActivated then exit;

  // This is a special Splitter, NOT part of the new FormLayout concept
  if NempLayout_Ready then begin
    if ArtistsVST.Align in [alLeft, alRight] then
      NempLayout.TreeViewRatio := Round(ArtistsVST.Width / TreePanel.Width * 100)
    else
      NempLayout.TreeViewRatio := Round(ArtistsVST.Height / TreePanel.Height * 100)
  end;
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
  if not FormReadyAndActivated then exit;
  if not NempLayout_Ready then exit;

  // This is a special Splitter, NOT part of the new FormLayout Concept
  if NempLayout.FileOverviewMode = fovBoth then begin
    if DetailCoverLyricsPanel.Align in [alLeft, alRight] then
      NempLayout.FileOverviewCoverRatio := Round(DetailCoverLyricsPanel.Width * 100 / MedienBibDetailPanel.Width)
    else
      NempLayout.FileOverviewCoverRatio := Round(DetailCoverLyricsPanel.Height * 100 / MedienBibDetailPanel.Height)
  end;
end;

{procedure TNemp_MainForm.__MainContainerPanelResize(Sender: TObject);
begin
    if not FormReadyAndActivated then
        exit;

    //if Assigned_NempFormBuildOptions then
    //    NempFormBuildOptions.OnSuperContainerResize(Sender);
end;}


function TNemp_MainForm.ApplicationEvents1Help(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
  CloseHelpWnd;
  if FileExists(Application.HelpFile) then
    Result := ShellExecute(0,'open','hh.exe',
                         PWideChar('-mapid '+IntToStr(Data)
                                   +' ms-its:'+Application.HelpFile),
                         nil,SW_SHOW) = 32
  else begin
    result := false;
    TranslateMessageDLG((Error_HelpFileNotFound), mtError, [MBOK], 0);
  end;

  CallHelp := false;
end;

procedure TNemp_MainForm.CloseHelpWnd;
var
  HlpWind: HWND;
const
  HelpTitle = 'Nemp - Noch ein Mp3-Player';
begin
  HlpWind := FindWindow('HH Parent',HelpTitle);
  if HlpWind <> 0 then PostMessage(HlpWind,WM_Close,0,0);
end;



initialization


finalization

    DeallocateHWnd(FOwnMessageHandler);

end.

