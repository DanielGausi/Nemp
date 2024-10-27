{

    Unit OptionsComplete
    Form OptionsCompleteForm

    - Settings-Form.
      Three longer methods (Create, Show, Apply),
      Many Enable/Disable-Controls-Stuff
      Message-Handler for ScobblerUtils-Setup

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
unit OptionsComplete;

interface

{$I xe.inc}

uses
  Windows, Messages, SysUtils,  Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees,  ComCtrls, StdCtrls, Spin, CheckLst, ExtCtrls, shellapi,
  DateUtils,  IniFiles, jpeg, PNGImage,  math, Contnrs,
  bass, StringHelper, MainFormHelper, RatingCtrls,
  NempAudioFiles, Spectrum_vis, Hilfsfunktionen, Systemhelper, TreeHelper,
  CoverHelper, UpdateUtils, HtmlHelper,
  Nemp_ConstantsAndTypes, filetypes, Buttons, gnuGettext,
  Nemp_RessourceStrings,  ScrobblerUtils, ExtDlgs, NempCoverFlowClass,
  MyDialogs, Vcl.Mask, System.UITypes, Generics.Collections,
  System.Generics.Defaults, NempTrackBar,
  LibraryOrganizer.Configuration.NewLayer,
  LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists, LibraryOrganizer.Webradio,
  Vcl.Menus, System.Actions, Vcl.ActnList, ActiveX, System.ImageList,
  Vcl.ImgList
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF};

type

  teMoveDirection = (mdUp, mdDown);

  TOptionsCompleteForm = class(TForm)
    OpenDlg_CountdownSongs: TOpenDialog;
    OpenDlg_DefaultCover: TOpenPictureDialog;
    OpenDlg_SoundFont: TOpenDialog;
    Panel1: TPanel;
    OptionsVST: TVirtualStringTree;
    PageControl1: TPageControl;
    tabGeneral: TTabSheet;
    CB_AutoCheck: TCheckBox;
    Btn_CHeckNowForUpdates: TButton;
    CB_AutoCheckNotifyOnBetas: TCheckBox;
    CBBOX_UpdateInterval: TComboBox;
    CB_AllowMultipleInstances: TCheckBox;
    CB_AutoPlayNewTitle: TCheckBox;
    CB_SavePositionInTrack: TCheckBox;
    CB_AutoPlayOnStart: TCheckBox;
    CB_AutoPlayEnqueueTitle: TCheckBox;
    tabControl: TTabSheet;
    CB_Activate_Play: TCheckBox;
    CB_Activate_Stop: TCheckBox;
    CB_Activate_JumpBack: TCheckBox;
    CB_Activate_Prev: TCheckBox;
    CB_Activate_Next: TCheckBox;
    CB_Activate_JumpForward: TCheckBox;
    CB_Activate_IncVol: TCheckBox;
    CB_Activate_DecVol: TCheckBox;
    CB_Activate_Mute: TCheckBox;
    CBRegisterHotKeys: TCheckBox;
    CB_Mod_Play: TComboBox;
    CB_Key_Play: TComboBox;
    CB_Mod_Stop: TComboBox;
    CB_Key_Stop: TComboBox;
    CB_Mod_Next: TComboBox;
    CB_Key_Next: TComboBox;
    CB_Mod_Prev: TComboBox;
    CB_Key_Prev: TComboBox;
    CB_Mod_JumpForward: TComboBox;
    CB_Key_JumpForward: TComboBox;
    CB_Mod_JumpBack: TComboBox;
    CB_Key_JumpBack: TComboBox;
    CB_Mod_IncVol: TComboBox;
    CB_Key_IncVol: TComboBox;
    CB_Mod_DecVol: TComboBox;
    CB_Key_DecVol: TComboBox;
    CB_Mod_Mute: TComboBox;
    CB_Key_Mute: TComboBox;
    CB_IgnoreVolume: TCheckBox;
    cb_RegisterMediaHotkeys: TCheckBox;
    cb_UseG15Display: TCheckBox;
    CB_TabStopAtPlayerControls: TCheckBox;
    CB_TabStopAtTabs: TCheckBox;
    tabFiletypes: TTabSheet;
    lbl_AudioFormats: TLabel;
    lbl_PlaylistFormats: TLabel;
    CBFileTypes: TCheckListBox;
    CBPlaylistTypes: TCheckListBox;
    Btn_SelectAll: TButton;
    CBEnqueueStandard: TCheckBox;
    CBEnqueueStandardLists: TCheckBox;
    CBDirectorySupport: TCheckBox;
    LblConst_ReallyRandom: TLabel;
    LblConst_AvoidRepetitions: TLabel;
    TBRandomRepeat: TTrackBar;
    lbl_WeightedRandom: TLabel;
    RatingImage05: TImage;
    RatingImage10: TImage;
    RatingImage15: TImage;
    RatingImage20: TImage;
    RatingImage25: TImage;
    RatingImage30: TImage;
    RatingImage35: TImage;
    RatingImage40: TImage;
    RatingImage45: TImage;
    RatingImage50: TImage;
    lblCount30: TLabel;
    lblCount35: TLabel;
    lblCount40: TLabel;
    lblCount45: TLabel;
    lblCount50: TLabel;
    lblCount05: TLabel;
    lblCount10: TLabel;
    lblCount15: TLabel;
    lblCount20: TLabel;
    lblCount25: TLabel;
    lblCount00: TLabel;
    cb_UseWeightedRNG: TCheckBox;
    RandomWeight05: TEdit;
    RandomWeight10: TEdit;
    RandomWeight15: TEdit;
    RandomWeight20: TEdit;
    RandomWeight25: TEdit;
    RandomWeight30: TEdit;
    RandomWeight35: TEdit;
    RandomWeight40: TEdit;
    RandomWeight45: TEdit;
    RandomWeight50: TEdit;
    BtnCountRating: TButton;
    cbCountRatingOnlyPlaylist: TCheckBox;
    tabViewingSettings: TTabSheet;
    CBAlwaysSortAnzeigeList: TCheckBox;
    CBSkipSortOnLargeLists: TCheckBox;
    tabFontSizes: TTabSheet;
    Lbl_PartyMode_ResizeFactor: TLabel;
    CB_PartyMode_ResizeFactor: TComboBox;
    cb_PartyMode_BlockTreeEdit: TCheckBox;
    cb_PartyMode_BlockCurrentTitleRating: TCheckBox;
    cb_PartyMode_BlockTools: TCheckBox;
    Edt_PartyModePassword: TLabeledEdit;
    cb_PartyMode_ShowPasswordOnActivate: TCheckBox;
    LblConst_FontVBR: TLabel;
    LblConst_FontCBR: TLabel;
    CBChangeFontStyleOnMode: TCheckBox;
    CBChangeFontOnCbrVbr: TCheckBox;
    CBFontNameVBR: TComboBox;
    CBFontNameCBR: TComboBox;
    CBChangeFontColoronBitrate: TCheckBox;
    CBChangeFontSizeOnLength: TCheckBox;
    Label34: TLabel;
    Label32: TLabel;
    lbl_Browselist_FontStyle: TLabel;
    SEArtistAlbenRowHeight: TSpinEdit;
    SEArtistAlbenSIze: TSpinEdit;
    cb_Browselist_FontStyle: TComboBox;
    LblConst_RowHeight: TLabel;
    LblConst_BasicFontSize: TLabel;
    lbl_Medialist_FontStyle: TLabel;
    SERowHeight: TSpinEdit;
    SEFontSize: TSpinEdit;
    cb_Medialist_FontStyle: TComboBox;
    LblReplaceArtistBy: TLabel;
    LblReplaceTitletBy: TLabel;
    LblReplaceAlbumBy: TLabel;
    cbReplaceArtistBy: TComboBox;
    cbReplaceTitleBy: TComboBox;
    cbReplaceAlbumBy: TComboBox;
    CBShowHintsInTitlelists: TCheckBox;
    CB_ShowAdvancedHints: TCheckBox;
    CBFullRowSelect: TCheckBox;
    Lbl_Framerate: TLabel;
    CB_visual: TCheckBox;
    TB_Refresh: TTrackBar;
    CB_ScrollTitelTaskBar: TCheckBox;
    CB_TaskBarDelay: TComboBox;
    tabFileManagement: TTabSheet;
    CBAutoScan: TCheckBox;
    BtnAutoScanAdd: TButton;
    BtnAutoScanDelete: TButton;
    CBAutoAddNewDirs: TCheckBox;
    CBAskForAutoAddNewDirs: TCheckBox;
    LBAutoscan: TListBox;
    cb_AutoDeleteFiles: TCheckBox;
    cb_AutoDeleteFilesShowInfo: TCheckBox;
    BtnAutoScanNow: TButton;
    LblConst_OnlythefollowingTypes: TLabel;
    cbIncludeAll: TCheckBox;
    cbIncludeFiles: TCheckListBox;
    BtnRecommendedFiletypes: TButton;
    tabMetadata: TTabSheet;
    cb_RatingActive: TCheckBox;
    cb_RatingIgnoreShortFiles: TCheckBox;
    cb_RatingChangeCounter: TCheckBox;
    cb_RatingIncreaseRating: TCheckBox;
    cb_RatingDecreaseRating: TCheckBox;
    cb_AccessMetadata: TCheckBox;
    cb_IgnoreLyrics: TCheckBox;
    CBAutoDetectCharCode: TCheckBox;
    cb_AutoResolveInconsistencies: TCheckBox;
    cb_AskForAutoResolveInconsistencies: TCheckBox;
    cb_ShowAutoResolveInconsistenciesHints: TCheckBox;
    CB_CoverSearch_inDir: TCheckBox;
    CB_CoverSearch_inSubDir: TCheckBox;
    CB_CoverSearch_inParentDir: TCheckBox;
    CB_CoverSearch_inSisterDir: TCheckBox;
    EDTCoverSubDirName: TEdit;
    EDTCoverSisterDirName: TEdit;
    tabSearch: TTabSheet;
    CB_AccelerateSearch: TCheckBox;
    CB_AccelerateSearchIncludePath: TCheckBox;
    CB_AccelerateSearchIncludeComment: TCheckBox;
    CB_AccelerateLyricSearch: TCheckBox;
    CB_QuickSearchWhileYouType: TCheckBox;
    CB_QuickSearchAllowErrorsWhileTyping: TCheckBox;
    CB_QuickSearchAllowErrorsOnEnter: TCheckBox;
    cb_ChangeCoverflowOnSearch: TCheckBox;
    tabPlayer: TTabSheet;
    tabPlaylist: TTabSheet;
    CB_AutoScanPlaylist: TCheckBox;
    CB_JumpToNextCue: TCheckBox;
    CB_RememberInterruptedPlayPosition: TCheckBox;
    cb_ReplayCue: TCheckBox;
    LblPlaylistDefaultAction: TLabel;
    LblHeadsetDefaultAction: TLabel;
    GrpBox_DefaultAction: TComboBox;
    GrpBox_HeadsetDefaultAction: TComboBox;
    cb_AutoStopHeadsetSwitchTab: TCheckBox;
    CB_AutoMixPlaylist: TCheckBox;
    CB_DisableAutoDeleteAtUserInput: TCheckBox;
    CB_AutoDeleteFromPlaylist: TCheckBox;
    LblLogDuration: TLabel;
    LblLogDuration2: TLabel;
    cbSaveLogToFile: TCheckBox;
    seLogDuration: TSpinEdit;
    tabWebradio: TTabSheet;
    LblConst_DownloadDir: TLabel;
    LblConst_FilenameFormat: TLabel;
    LblConst_FilenameExtension: TLabel;
    LblConst_MaxSize: TLabel;
    LblConst_MaxTime: TLabel;
    LblConst_WebradioHint: TLabel;
    BtnChooseDownloadDir: TButton;
    cbAutoSplitByTitle: TCheckBox;
    cbAutoSplitByTime: TCheckBox;
    SE_AutoSplitMaxSize: TSpinEdit;
    cbAutoSplitBySize: TCheckBox;
    SE_AutoSplitMaxTime: TSpinEdit;
    EdtDownloadDir: TEdit;
    cbFilenameFormat: TComboBox;
    cbUseStreamnameAsDirectory: TCheckBox;
    tabEffects: TTabSheet;
    CB_UseDefaultEffects: TCheckBox;
    CB_UseDefaultEqualizer: TCheckBox;
    LblJingleReduce: TLabel;
    LblConst_JingleVolume: TLabel;
    LblConst_JingleVolumePercent: TLabel;
    CBJingleReduce: TCheckBox;
    SEJingleReduce: TSpinEdit;
    SEJingleVolume: TSpinEdit;
    cb_UseWalkmanMode: TCheckBox;
    tabBirthday: TTabSheet;
    lblCountDownTitel: TLabel;
    LBlCountDownWarning: TLabel;
    CBStartCountDown: TCheckBox;
    BtnCountDownSong: TButton;
    BtnGetCountDownTitel: TButton;
    EditCountdownSong: TEdit;
    Lbl_Const_EventTime: TLabel;
    lblBirthdayTitel: TLabel;
    LblEventWarning: TLabel;
    BtnBirthdaySong: TButton;
    BtnGetBirthdayTitel: TButton;
    EditBirthdaySong: TEdit;
    CBContinueAfter: TCheckBox;
    mskEdt_BirthdayTime: TMaskEdit;
    tabLastfm: TTabSheet;
    LblScrobble1: TLabel;
    Image2: TImage;
    LblVisitLastFM: TLabel;
    BtnScrobbleWizard: TButton;
    Label5: TLabel;
    CB_AlwaysScrobble: TCheckBox;
    CB_SilentError: TCheckBox;
    CB_ScrobbleThisSession: TCheckBox;
    Btn_ScrobbleAgain: TButton;
    tabWebserver: TTabSheet;
    LblWebServer_Port: TLabel;
    LblWebServerTheme: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LblWebserverAdminURL: TLabel;
    BtnServerActivate: TButton;
    CBAutoStartWebServer: TCheckBox;
    seWebServer_Port: TSpinEdit;
    cbWebserverRootDir: TComboBox;
    EdtUsernameAdmin: TEdit;
    EdtPasswordAdmin: TEdit;
    BtnShowWebserverLog: TButton;
    LblConst_IPWAN: TLabel;
    LabelLANIP: TLabel;
    BtnGetIPs: TButton;
    cbLANIPs: TComboBox;
    EdtGlobalIP: TEdit;
    LblConst_Username2: TLabel;
    LblConst_Password2: TLabel;
    LblWebserverUserURL: TLabel;
    cbAllowRemoteControl: TCheckBox;
    cbPermitVote: TCheckBox;
    cbPermitLibraryAccess: TCheckBox;
    cbPermitPlaylistDownload: TCheckBox;
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    Panel2: TPanel;
    BTNok: TButton;
    BTNCancel: TButton;
    BTNApply: TButton;
    cb_limitMarkerToCurrentFiles: TCheckBox;
    cb_AutoStopHeadsetAddToPlayist: TCheckBox;
    BtnActivateBirthdayMode: TButton;
    cb_PlaylistManagerAutoSave: TCheckBox;
    cb_PlaylistManagerAutoSaveUserInput: TCheckBox;
    lblPlaylistTitle: TLabel;
    cbPlaylistTitle: TComboBox;
    cbPlaylistTitleFB: TComboBox;
    cbPlaylistTitleCueAlbum: TComboBox;
    cbPlaylistTitleCueTitle: TComboBox;
    lblPlaylistTitleFB: TLabel;
    lblPlaylistTitleCueAlbum: TLabel;
    lblPlaylistTitleCueTitle: TLabel;
    lblPlaylistWebradioTitle: TLabel;
    cbPlaylistWebradioTitle: TComboBox;
    LblConst_TitleChange: TLabel;
    LblConst_Titlefade: TLabel;
    LblConst_ms1: TLabel;
    LblConst_ms2: TLabel;
    CB_Fading: TCheckBox;
    SE_SeekFade: TSpinEdit;
    SE_Fade: TSpinEdit;
    CB_IgnoreFadingOnShortTracks: TCheckBox;
    CB_IgnoreFadingOnPause: TCheckBox;
    CB_IgnoreFadingOnStop: TCheckBox;
    Lbl_SilenceThreshold: TLabel;
    Lbl_SilenceDB: TLabel;
    CB_SilenceDetection: TCheckBox;
    SE_SilenceThreshold: TSpinEdit;
    lblDefaultGainValue: TLabel;
    lblReplayGainDefault: TLabel;
    lblDefaultGainValue2: TLabel;
    lblRG_Preamp1: TLabel;
    lblRG_Preamp2: TLabel;
    cb_ApplyReplayGain: TCheckBox;
    cb_PreferAlbumGain: TCheckBox;
    tp_DefaultGain: TNempTrackBar;
    tp_DefaultGain2: TNempTrackBar;
    cb_ReplayGainPreventClipping: TCheckBox;
    Label4: TLabel;
    BtnRegistryUpdate: TButton;
    cb_AddBreakBetweenTracks: TCheckBox;
    SE_BreakBetweenTracks: TSpinEdit;
    lblBreakBetweenTracks: TLabel;
    lblNempPortable: TLabel;
    cb_EnableUSBMode: TCheckBox;
    cb_EnableCloudMode: TCheckBox;
    tabCoverflow: TTabSheet;
    tbCoverZMain: TNempTrackBar;
    lblCoverZMain: TLabel;
    LblCoverZLeft: TLabel;
    tbCoverZLeft: TNempTrackBar;
    LblCoverZRight: TLabel;
    tbCoverZRight: TNempTrackBar;
    tbCoverGapFirstLeft: TNempTrackBar;
    tbCoverGapFirstRight: TNempTrackBar;
    tbCoverGapLeft: TNempTrackBar;
    tbCoverGapRight: TNempTrackBar;
    lblCoverFlowGapLeft: TLabel;
    lblCoverFlowGapRight: TLabel;
    lblCoverFlowAngleLeft: TLabel;
    tbCoverAngleLeft: TNempTrackBar;
    lblCoverFlowAngleRight: TLabel;
    tbCoverAngleRight: TNempTrackBar;
    cbCoverFlowUseReflection: TCheckBox;
    lblCoverFlowIntensity: TLabel;
    tbCoverReflexionIntensity: TNempTrackBar;
    lblCoverflowReflexionGap: TLabel;
    tbCoverReflexionGap: TNempTrackBar;
    tbCoverAngleMain: TNempTrackBar;
    lblCoverFlowAngleMain: TLabel;
    PnlCoverFlowControl: TPanel;
    BtnUndoCoverFlowSettings: TButton;
    BtnCoverFlowDefault: TButton;
    cb_UseClassicCoverflow: TCheckBox;
    lblCoverflowTextures: TLabel;
    seCoverflowTextureCache: TSpinEdit;
    CB_AccelerateSearchIncludeGenre: TCheckBox;
    cb_ShowIndexInTreeview: TCheckBox;
    tabCategories: TTabSheet;
    VSTCategories: TVirtualStringTree;
    lblDefaultCategory: TLabel;
    cbDefaultCategory: TComboBox;
    cbNewFilesCategory: TComboBox;
    VSTSortings: TVirtualStringTree;
    btnCategoryEdit: TButton;
    btnLayerEdit: TButton;
    lblPlaylistCaptionMode: TLabel;
    lblPlaylistSortMode: TLabel;
    cbPlaylistCaptionMode: TComboBox;
    cbPlaylistSortMode: TComboBox;
    lblRecentlyAddedCategory: TLabel;
    editCDNames: TLabeledEdit;
    cbIgnoreCDDirectories: TCheckBox;
    cbAlbumKeymode: TComboBox;
    cbMissingCoverMode: TComboBox;
    btnEditCoverflow: TButton;
    edtCoverFlowSortings: TLabeledEdit;
    cbPlaylistSortDirection: TComboBox;
    lblDefineAlbum: TLabel;
    ActionList1: TActionList;
    ActionAddCategory: TAction;
    ActionDeleteCategory: TAction;
    ActionAddRootLayer: TAction;
    ActionAddLayer: TAction;
    ActionDeleteLayer: TAction;
    ActionEditLayer: TAction;
    ActionEditCategory: TAction;
    ActionLayerMoveDown: TAction;
    ActionLayerMoveUp: TAction;
    ActionMoveCategoryUp: TAction;
    ActionMoveCategoryDown: TAction;
    PopupCategories: TPopupMenu;
    Editcategory1: TMenuItem;
    Addcategory1: TMenuItem;
    Deletecategory1: TMenuItem;
    N2: TMenuItem;
    Moveup2: TMenuItem;
    Movedown2: TMenuItem;
    PopupLayers: TPopupMenu;
    Editlayer1: TMenuItem;
    Addrootlayer1: TMenuItem;
    Addlayer1: TMenuItem;
    Deletelayer1: TMenuItem;
    N1: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    clbViewMainColumns: TCheckListBox;
    cpgDisplaySettings: TCategoryPanelGroup;
    cpPartyMode: TCategoryPanel;
    cpFontSettings: TCategoryPanel;
    cpgPlayerMain: TCategoryPanelGroup;
    cpOutputDevices: TCategoryPanel;
    cpFading: TCategoryPanel;
    LblConst_MainDevice: TLabel;
    MainDeviceCB: TComboBox;
    LblConst_Headphones: TLabel;
    HeadphonesDeviceCB: TComboBox;
    BtnRefreshDevices: TButton;
    cpSilenceDetection: TCategoryPanel;
    cpAdvanced: TCategoryPanel;
    LblSoundFont: TLabel;
    editSoundFont: TEdit;
    BtnSelectSoundFontFile: TButton;
    LblConst_Buffersize: TLabel;
    SEBufferSize: TSpinEdit;
    LblConst_ms: TLabel;
    LblConst_UseFloatingPoint: TLabel;
    CB_FloatingPoint: TComboBox;
    LblConst_Mixing: TLabel;
    CB_Mixing: TComboBox;
    Lbl_FloatingPoints_Status: TLabel;
    cb_SafePlayback: TCheckBox;
    lblFontBrowselists: TLabel;
    lblFontPlaylistMedialist: TLabel;
    cpVisualisation: TCategoryPanel;
    cpgCategories: TCategoryPanelGroup;
    cpCategories: TCategoryPanel;
    cpCategoryPlaylists: TCategoryPanel;
    cpCategoryCoverflow: TCategoryPanel;
    cpgViewingSettings: TCategoryPanelGroup;
    cpVisibleColumns: TCategoryPanel;
    cpMissingMetaData: TCategoryPanel;
    lblMissingMetaData: TLabel;
    cpPlaylistFormatting: TCategoryPanel;
    cpExtendedViewingSettings: TCategoryPanel;
    cpgPlaylistSettings: TCategoryPanelGroup;
    cpPlaylistDefaultActions: TCategoryPanel;
    cpPlaylistBehaviour: TCategoryPanel;
    cpRandomPlayback: TCategoryPanel;
    cpPlaylistLog: TCategoryPanel;
    cpgFileManagement: TCategoryPanelGroup;
    cpScanDirectories: TCategoryPanel;
    cpLibraryFileTypes: TCategoryPanel;
    lbl_DefaultCover: TLabel;
    img_DefaultCover: TImage;
    lbl_DefaultCoverHint: TLabel;
    btn_DefaultCover: TButton;
    btn_DefaultCoverReset: TButton;
    cpLibraryCoverArt: TCategoryPanel;
    lblSearchCoverArt: TLabel;
    CB_CoverSearch_LastFM: TCheckBox;
    BtnClearCoverCache: TButton;
    cb_CoverSize: TComboBox;
    lblCoverArtQuality: TLabel;
    CBAutoScanPlaylistFilesOnView: TCheckBox;
    cpgCoverFlowView: TCategoryPanelGroup;
    cpCoverflowPosition: TCategoryPanel;
    cpCoverflowViewPosition: TCategoryPanel;
    tbCoverViewPosition: TNempTrackBar;
    cpCoverflowSpacing: TCategoryPanel;
    cpCoverflowAngles: TCategoryPanel;
    cpCoverflowReflection: TCategoryPanel;
    cpCoverflowMixedSettings: TCategoryPanel;
    cpgMainOptions: TCategoryPanelGroup;
    cpStarting: TCategoryPanel;
    CBAutoLoadMediaList: TCheckBox;
    CBAutoSaveMediaList: TCheckBox;
    CB_StartMinimized: TCheckBox;
    cb_ShowSplashScreen: TCheckBox;
    cbPauseOnSuspend: TCheckBox;
    cbReInitAfterSuspend: TCheckBox;
    Btn_ReinitPlayerEngine: TButton;
    cbShowTrayIcon: TCheckBox;
    cpNempUpdates: TCategoryPanel;
    cpHibernate: TCategoryPanel;
    cpPortable: TCategoryPanel;
    lblNempPortable1: TLabel;
    lblNempStartPlayer: TLabel;
    lblNempStartLibrary: TLabel;
    lblNempStartSystem: TLabel;
    cpgControlSettings: TCategoryPanelGroup;
    cpMediaKeys: TCategoryPanel;
    cpHotkeys: TCategoryPanel;
    cpTabulatorKeys: TCategoryPanel;
    cpUpdateThread_FAILSAFE: TCategoryPanel;
    XXX_CB_BetaDontUseThreadedUpdate: TCheckBox;
    cpgWebstreams: TCategoryPanelGroup;
    cpWebstreamsPlaylists: TCategoryPanel;
    Label1: TLabel;
    rbWebRadioParseFile: TRadioButton;
    rbWebRadioHandledByBass: TRadioButton;
    cpWebstremRecording: TCategoryPanel;
    lblSplitWebRadioStreams: TLabel;
    cpgEffects: TCategoryPanelGroup;
    cpReplayGain: TCategoryPanel;
    cpEffects: TCategoryPanel;
    lblJingles: TLabel;
    cpgBirthday: TCategoryPanelGroup;
    cpBirthdayMain: TCategoryPanel;
    lblHappyBirthday: TLabel;
    cpgScrobble: TCategoryPanelGroup;
    cpScrobbleSetup: TCategoryPanel;
    cpScrobbleSettings: TCategoryPanel;
    cpScrobbleLog: TCategoryPanel;
    MemoScrobbleLog: TMemo;
    cpgWebserverConfiguration: TCategoryPanelGroup;
    cpWebserverConfiguration: TCategoryPanel;
    cbWebserverUserRights: TCategoryPanel;
    cpWebServerUrls: TCategoryPanel;
    cbWebserverAdminQRCode: TCheckBox;
    imgQRCode: TImage;
    lblQRCode: TLabel;
    lblCurrentQRCodeURL: TLabel;
    cbWebserverInternetQRCode: TCheckBox;
    cpgMetadata: TCategoryPanelGroup;
    cpMetaData: TCategoryPanel;
    lblQuickAccess: TLabel;
    lblMetaDataLyrics: TLabel;
    lblMetaDataAutomaticRating: TLabel;
    lblExtendedTags: TLabel;
    lbMetaDataAutoDetectCharset: TLabel;
    cpgSearchSettings: TCategoryPanelGroup;
    cpGeneralSearchSettings: TCategoryPanel;
    lblSearchSettingsHint: TLabel;
    Label2: TLabel;
    cpgFileTypesRegistration: TCategoryPanelGroup;
    cpFileTypeRegistration: TCategoryPanel;
    lblFileTyperegistrationExplorer: TLabel;
    ImageList1: TImageList;
    cpViewCategoriesSettings: TCategoryPanel;
    cbShowCoverForAlbum: TCheckBox;
    cbShowElementCount: TCheckBox;
    lblCategories: TLabel;
    lblTreeViewLayers: TLabel;
    cbLibConfigShowPlaylistCategories: TCheckBox;
    cbLibConfigShowWebradioCategory: TCheckBox;
    ColorDlgCoverflow: TColorDialog;
    edtCoverFlowColor: TEdit;
    btnSelectCoverFlowColor: TButton;
    shapeCoverflowColor: TShape;
    lblCoverFlowColor: TLabel;
    BtnHelp: TButton;
    cpCategorySettings: TCategoryPanel;
    lblSamplerSorting: TLabel;
    cbSamplerSortingIgnoreReleaseYear: TCheckBox;
    lblAlbumArtist: TLabel;
    cbPreferAlbumArtist: TCheckBox;
    cpIgnoreAlbumArtistVariousArtists: TCheckBox;
    lblAlbumDefinition: TLabel;
    ImgHelp: TImage;
    CB_AccelerateSearchIncludeAlbumArtist: TCheckBox;
    CB_AccelerateSearchIncludeComposer: TCheckBox;
    cpCDDB: TCategoryPanel;
    cbUseCDDB: TCheckBox;
    cbPreferCDDB: TCheckBox;
    edtCDDBServer: TLabeledEdit;
    edtCDDBEMail: TLabeledEdit;
    lblInvalidCDDBMail: TLabel;
    cbAutoCheckNewCDs: TCheckBox;
    lblLocalCDDBCache: TLabel;
    btnClearCDDBCache: TButton;
    cbPermitHtmlAudio: TCheckBox;
    cbUseDefaultActionOnCoverFlowDoubleClick: TCheckBox;
    cbApplyDefaultActionToWholeList: TCheckBox;
    cbIgnoreFadingOnLiveRecordings: TCheckBox;
    lblIdentifyLiveTracksBy: TLabel;
    edtLiveRecordingCheckIdentifier: TEdit;
    cbLiveRecordingCheckTitle: TCheckBox;
    cbLiveRecordingCheckAlbum: TCheckBox;
    cbLiveRecordingCheckTags: TCheckBox;
    cbCombineLayers: TCheckBox;
    cbShowFilesRecursively: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OptionsVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormDestroy(Sender: TObject);
    procedure OptionsVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure FormShow(Sender: TObject);
    procedure BTNokClick(Sender: TObject);
    procedure TB_RefreshChange(Sender: TObject);
    procedure CB_FadingClick(Sender: TObject);
    procedure CB_visualClick(Sender: TObject);
    procedure CB_AutoPlayOnStartClick(Sender: TObject);
    procedure CB_CoverSearch_inSubDirClick(Sender: TObject);
    procedure CB_CoverSearch_inSisterDirClick(Sender: TObject);
    procedure CBChangeFontOnCbrVbrClick(Sender: TObject);
    procedure BtnRegistryUpdateClick(Sender: TObject);
    procedure Btn_SelectAllClick(Sender: TObject);
    procedure cbIncludeAllClick(Sender: TObject);
    procedure CBJingleReduceClick(Sender: TObject);
    procedure CB_AutoDeleteFromPlaylistClick(Sender: TObject);
    procedure BtnCountDownSongClick(Sender: TObject);
    procedure BtnBirthdaySongClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnGetCountDownTitelClick(Sender: TObject);
    procedure BtnGetBirthdayTitelClick(Sender: TObject);
    function GetFocussedAudioFileName: UnicodeString;
    procedure BTNCancelClick(Sender: TObject);
    procedure BTNApplyClick(Sender: TObject);
    procedure CBStartCountDownClick(Sender: TObject);
    procedure Btn_ReinitPlayerEngineClick(Sender: TObject);
    procedure EditCountdownSongChange(Sender: TObject);
    procedure EditBirthdaySongChange(Sender: TObject);
    procedure CBAutoScanClick(Sender: TObject);
    procedure BtnAutoScanAddClick(Sender: TObject);
    procedure BtnAutoScanDeleteClick(Sender: TObject);
    procedure LBAutoscanKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CBRegisterHotKeysClick(Sender: TObject);
    procedure cbFilenameFormatChange(Sender: TObject);
    procedure BtnChooseDownloadDirClick(Sender: TObject);
    procedure CB_AccelerateSearchClick(Sender: TObject);
    procedure CB_AutoCheckClick(Sender: TObject);
    procedure Btn_CHeckNowForUpdatesClick(Sender: TObject);
    procedure cbAutoSplitBySizeClick(Sender: TObject);
    procedure cbAutoSplitByTimeClick(Sender: TObject);
    procedure ResetScrobbleButton;
    Procedure SetScrobbleButtonOnError;
    procedure BtnScrobbleWizardClick(Sender: TObject);
    procedure Btn_ScrobbleAgainClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure BtnServerActivateClick(Sender: TObject);
    procedure EdtUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure BtnGetIPsClick(Sender: TObject);
    procedure cb_RatingActiveClick(Sender: TObject);
    procedure CBAlwaysSortAnzeigeListClick(Sender: TObject);
    procedure BtnClearCoverCacheClick(Sender: TObject);
    procedure BtnRefreshDevicesClick(Sender: TObject);
    procedure EdtUsernameAdminKeyPress(Sender: TObject; var Key: Char);
    procedure BtnShowWebserverLogClick(Sender: TObject);
    procedure LblWebserverAdminURLClick(Sender: TObject);
    procedure LblWebserverUserURLClick(Sender: TObject);
    procedure ChangeWebserverLinks(Sender: TObject);
    procedure CB_SilenceDetectionClick(Sender: TObject);
    procedure RecommendedFiletypesClick(Sender: TObject);
    procedure btn_DefaultCoverClick(Sender: TObject);
    procedure btn_DefaultCoverResetClick(Sender: TObject);
    procedure mskEdt_BirthdayTimeExit(Sender: TObject);
    procedure cb_UseWeightedRNGClick(Sender: TObject);
    procedure RandomWeight05Exit(Sender: TObject);
    procedure BtnCountRatingClick(Sender: TObject);
    procedure BtnSelectSoundFontFileClick(Sender: TObject);
    procedure BtnAutoScanNowClick(Sender: TObject);
    procedure cbSaveLogToFileClick(Sender: TObject);
    procedure cb_IgnoreLyricsClick(Sender: TObject);
    procedure cb_ApplyReplayGainClick(Sender: TObject);
    procedure tp_DefaultGainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tp_DefaultGainChange(Sender: TObject);
    procedure tp_DefaultGain2Change(Sender: TObject);
    procedure tp_DefaultGain2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnActivateBirthdayModeClick(Sender: TObject);
    procedure cb_PlaylistManagerAutoSaveClick(Sender: TObject);
    procedure tbCoverZMainChange(Sender: TObject);
    procedure BtnUndoCoverFlowSettingsClick(Sender: TObject);
    procedure BtnCoverFlowDefaultClick(Sender: TObject);
    procedure cbDefaultCategoryChange(Sender: TObject);
    procedure cbNewFilesCategoryChange(Sender: TObject);
    procedure ActionAddCategoryExecute(Sender: TObject);
    procedure ActionDeleteCategoryExecute(Sender: TObject);
    procedure ActionAddRootLayerExecute(Sender: TObject);
    procedure ActionAddLayerExecute(Sender: TObject);
    procedure ActionDeleteLayerExecute(Sender: TObject);
    procedure ActionEditLayerExecute(Sender: TObject);
    procedure ActionEditCategoryExecute(Sender: TObject);
    procedure ActionLayerMoveDownExecute(Sender: TObject);
    procedure ActionLayerMoveUpExecute(Sender: TObject);
    procedure ActionMoveCategoryUpExecute(Sender: TObject);
    procedure ActionMoveCategoryDownExecute(Sender: TObject);
    procedure PopupCategoriesPopup(Sender: TObject);
    procedure PopupLayersPopup(Sender: TObject);
    procedure btnEditCoverflowClick(Sender: TObject);
    procedure VSTCategoriesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTCategoriesNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
    procedure VSTCategoriesPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VSTCategoriesEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCategoriesDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCategoriesDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTCategoriesDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTSortingsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTSortingsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VSTSortingsFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure VSTSortingsDragAllowed(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTSortingsDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTSortingsDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure btnCategoryEditClick(Sender: TObject);
    procedure btnLayerEditClick(Sender: TObject);
    procedure OptionsVSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure CategoryPanelGroupMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure OptionsVSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure OptionsVSTMeasureTextWidth(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      const Text: string; var Extent: Integer);
    procedure btnSelectCoverFlowColorClick(Sender: TObject);
    procedure shapeCoverflowColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure clbViewMainColumnsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BtnHelpClick(Sender: TObject);
    procedure VSTSortingsGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: string);
    procedure cbPreferAlbumArtistClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtCDDBEMailExit(Sender: TObject);
    procedure btnClearCDDBCacheClick(Sender: TObject);

  private
    { Private-Deklarationen }
    DetailRatingHelper: TRatingHelper;

    FileCategories: TLibraryCategoryList;
    RootCollections: TAudioCollectionList;
    OrganizerSettings: TOrganizerSettings;
    fCategoriesChanged: Boolean;
    fCollectionsChanged: Boolean;
    fCoverFlowGUIUpdating: Boolean;

    // Hilfsprozeduren für das Hotkey-Laden/Speichern
    Function ModToIndex(aMod: Cardinal): Integer;
    Function IndexToMod(aIndex: Integer): Cardinal;
    Function KeyToIndex(aKey: Byte): Integer;
    Function IndexToKey(aIndex: Integer): byte;
    function ValidTime(aText: String): Boolean;

    procedure LoadDefaultCover;

    // Show/Apply Settings
    procedure FillMainTreeView;

    procedure ShowNempSettings;
    procedure ApplyNempSettings;
    procedure ShowControlsSettings;
    procedure ApplyControls;
    procedure ShowPlayerSettings;
    procedure ApplyPlayerSettings;
    procedure ShowPlaylistSettings;
    procedure ApplyPlaylistSettings;
    procedure ShowWebServerSettings;
    procedure ApplyWebServerSettings;
    procedure ShowEffectReplayGainSettings;
    procedure ApplyEffectReplayGainSettings;
    procedure ShowBirthdaySettings;
    procedure ApplyBirthdaySettings;
    procedure ShowFontsAndPartyMode;
    procedure ApplyFontsAndPartyMode;
    procedure ShowFileSearchSettings;
    procedure ApplyFileSearchSettings;
    procedure SynchMediaListColumns;
    procedure ShowListViewSettings;
    procedure ApplyListViewSettings;
    procedure ShowWebRadioSettings;
    procedure ApplyWebRadioSettings;
    procedure ShowMetadataSettings;
    procedure ApplyMetadataSettings;
    procedure ShowSearchSettings;
    function ApplySearchSettings: Boolean;
    procedure ShowLastFMSettings;
    procedure ApplyLastFMSettings;
    procedure ShowRegisteredFiles;
    procedure ShowCoverFlowSettings;
    procedure ApplyCoverFlowSettings;
    procedure ShowMediaLibraryConfiguration;
    function ApplyMediaLibraryConfiguration: Boolean;

    procedure SelectCoverFlowColor;

    function SettingsChanged: Boolean;
      function NempSettingsChanged: Boolean;
      function ControlsChanged: Boolean;
      function PlayerSettingsChanged: Boolean;
      function PlaylistSettingsChanged: Boolean;
      function WebServerSettingsChanged: Boolean;
      function EffectReplayGainSettingsChanged: Boolean;
      function BirthdaySettingsChanged: Boolean;
      function FontsAndPartyModeChanged: Boolean;
      function FileSearchSettingsChanged: Boolean;
      function ListViewSettingsChanged: Boolean;
      function WebRadioSettingsChanged: Boolean;
      function MetadataSettingsChanged: Boolean;
      function SearchSettingsChanged: Boolean;
      function LastFMSettingsChanged: Boolean;
      function CoverFlowSettingsChanged: Boolean;
      function MediaLibraryConfigurationChanged: Boolean;

    procedure EnableHotKeyControls;
    procedure EnableFadingControls;
    procedure EnableSilenceControls;
    procedure EnableReplayGainControls;
    procedure EnableBirthdayControls;
    procedure EnableFontControls;
    procedure EnableVisualizationControls;
    procedure EnableRandomPlaybackControls;
    procedure EnableDirectoryScanControls;
    procedure EnableMediaLibraryFileTypeControls;
    procedure EnableAutomaticRatingControls;
    procedure EnableSearchControls;
    procedure EnableListViewControls;

    procedure RefreshQRCode(aURL: String);

    // Media Library Configuration
    procedure FillCategoryTree;
    procedure FillCategoryComboBoxes;
    procedure FillCollectionTree;
    procedure RefreshCategoryButtons;
    procedure RefreshLayerActions(Node: PVirtualNode; rc: TRootCollection);
    procedure FillCoverFlowSortingLabel(aConfig: TCollectionConfig);
    procedure PrepareNewLayerForm(isRoot: Boolean);
    procedure PrepareEditLayerForm(AllowDirectory: Boolean; aConfig: TCollectionConfig);
    procedure PrepareEditCoverflowForm(aConfig: TCollectionConfig);
    function CategoryNameExists(aName: String; Categories: TLibraryCategoryList): Boolean;
    function NewUniqueCategoryName(Categories: TLibraryCategoryList): String;
    function CategoryIndexExists(aIndex: Integer; CatEdit, CatLibrary: TLibraryCategoryList): Boolean; overload;
    function CategoryIndexExists(aIndex: Integer; Categories: TLibraryCategoryList): Boolean; overload;
    function NewUniqueCategoryIndex(CatEdit, CatLibrary: TLibraryCategoryList): Integer;
    procedure EnsureDefaultCategoryIsSet;
    procedure EnsureNewCategoryIsSet;
    procedure MoveLayer(Direction: teMoveDirection);
    procedure MoveCategory(Direction: teMoveDirection);

  protected
    Procedure ScrobblerMessage(Var aMsg: TMessage); message WM_Scrobbler;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public-Deklarationen }

    // CBSpalten: Array of TCheckBox;
    PlaylistNode: PVirtualNode;
    BirthdayNode: PVirtualNode;
    ScrobbleNode: PVirtualNode;
    WebServerNode: PVirtualNode;
    VorauswahlNode: pVirtualNode;
    CategoriesNode: PVirtualNode;


    //procedure LoadStarGraphics;
    procedure RefreshStarGraphics;

  end;

var
  OptionsCompleteForm: TOptionsCompleteForm;

implementation

uses NempMainUnit, Details, SplitForm_Hilfsfunktionen, WindowsVersionInfo,
  WebServerLog, MedienBibliothekClass, DriveRepairTools, WebQRCodes,
  AudioDisplayUtils, unitFlyingCow, RedeemerQR, NempHelp, cddaUtils;

{$R *.dfm}

var
  BackUpCoverFlowSettings: TCoverFlowSettings;

const
  HelpContexts: Array[0..16] of Integer = (
    HELP_SettingsGeneral, // General
    HELP_SettingsControls, // Controls
    HELP_SettingsListView, // View
    HELP_SettingsFonts, // Fonts and PartyMode
    HELP_SettingsFileManagement, // FileManagement
    Help_Categories, // MediaLib Configuration
    HELP_SettingsMetadata, // MetaData
    HELP_SettingsSearch, // Search
    HELP_SettingsPlayback, // Player
    HELP_SettingsPlaylist, // Playlist
    HELP_SettingsWebradio, // Webradio
    Help_EqualizerAndEffects, // Effects
    HELP_HappyBirthdayTimer, // Birthday
    HELP_Scrobbeln, // LastFM
    HELP_Webserver, // Webserver
    HELP_SettingsCoverflow, // Coverflow
    HELP_WindowsRegistry // Filetypes
  );


function getNextIdx(const aIdx: Integer; Button: teMoveDirection): Integer;
begin
  case Button of
    mdUp:   result := aIdx - 1;
    mdDown: result := aIdx + 1;
  else
    result := aIdx + 1;
  end;
end;

function ValidRange(aIdx, bIdx, maxIdx: Integer): Boolean;
begin
  result := (aIdx >= 0) and (bIdx >= 0)
        and (aIdx <= maxIdx) and (bIdx <= maxIdx);
end;

procedure TOptionsCompleteForm.BTNCancelClick(Sender: TObject);
begin
  MedienBib.NewCoverFlow.Settings := BackUpCoverFlowSettings;
  ShowCoverFlowSettings;
  MedienBib.NewCoverFlow.ApplySettings;

  OnCloseQuery := Nil;
  close;
  OnCloseQuery := FormCloseQuery;
end;


procedure TOptionsCompleteForm.RefreshStarGraphics;
begin
    LoadStarGraphics(DetailRatingHelper);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(1, RatingImage05.Picture.Bitmap, RatingImage05.Width, RatingImage05.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(36 + 1, RatingImage10.Picture.Bitmap, RatingImage10.Width, RatingImage10.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(51 + 1, RatingImage15.Picture.Bitmap, RatingImage15.Width, RatingImage15.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(51+26 + 1, RatingImage20.Picture.Bitmap, RatingImage20.Width, RatingImage20.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(2*51 + 1, RatingImage25.Picture.Bitmap, RatingImage25.Width, RatingImage25.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(2*51+26 + 1, RatingImage30.Picture.Bitmap, RatingImage30.Width, RatingImage30.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(3*51 + 1, RatingImage35.Picture.Bitmap, RatingImage35.Width, RatingImage35.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(3*51+26 + 1, RatingImage40.Picture.Bitmap, RatingImage40.Width, RatingImage40.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(4*51 + 1, RatingImage45.Picture.Bitmap, RatingImage45.Width, RatingImage45.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(4*51+26 + 1, RatingImage50.Picture.Bitmap, RatingImage50.Width, RatingImage50.Height);
end;

procedure TOptionsCompleteForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not SettingsChanged then
    CanClose := True
  else begin

      case TranslateMessageDLG((OptionsForm_UnSavedChangesQuery), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
          mrYes   : begin
                BtnApply.Click;   // save Changes
                CanClose := True;
          end;
          mrNo    : CanClose := True;
          mrAbort : CanClose := False;
        end;
  end;
end;

procedure TOptionsCompleteForm.FormCreate(Sender: TObject);
var i, count: integer;
  BassInfo: BASS_DEVICEINFO;
begin
  fCoverFlowGUIUpdating := False;

  BackUpComboBoxes(self);
  TranslateComponent(self);
  RestoreComboboxes(self);

  HelpContext := HELP_Einstellungen;
  for i := 0 to 16 do
    PageControl1.Pages[i].HelpContext := HelpContexts[i];

  DetailRatingHelper := TRatingHelper.Create;
  LoadStarGraphics(DetailRatingHelper);

  DetailRatingHelper.DrawRatingInStarsOnBitmap(1, RatingImage05.Picture.Bitmap, RatingImage05.Width, RatingImage05.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(36 + 1, RatingImage10.Picture.Bitmap, RatingImage10.Width, RatingImage10.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(51 + 1, RatingImage15.Picture.Bitmap, RatingImage15.Width, RatingImage15.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(51+26 + 1, RatingImage20.Picture.Bitmap, RatingImage20.Width, RatingImage20.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(2*51 + 1, RatingImage25.Picture.Bitmap, RatingImage25.Width, RatingImage25.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(2*51+26 + 1, RatingImage30.Picture.Bitmap, RatingImage30.Width, RatingImage30.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(3*51 + 1, RatingImage35.Picture.Bitmap, RatingImage35.Width, RatingImage35.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(3*51+26 + 1, RatingImage40.Picture.Bitmap, RatingImage40.Width, RatingImage40.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(4*51 + 1, RatingImage45.Picture.Bitmap, RatingImage45.Width, RatingImage45.Height);
  DetailRatingHelper.DrawRatingInStarsOnBitmap(4*51+26 + 1, RatingImage50.Picture.Bitmap, RatingImage50.Width, RatingImage50.Height);

  cbIncludeFiles.Items.BeginUpdate;
  CBFileTypes.Items.BeginUpdate;
  for i := 0 to NempPlayer.ValidExtensions.Count - 1 do
  begin
    CBFileTypes.Items.Add(NempPlayer.ValidExtensions[i]);
    CBFileTypes.Checked[i] := True;
    cbIncludeFiles.Items.Add(NempPlayer.ValidExtensions[i]);
    cbIncludeFiles.Checked[i] := True;
  end;
  cbIncludeFiles.Items.EndUpdate;
  CBFileTypes.Items.BeginUpdate;

  for i := 0 to PageControl1.PageCount - 1 do
    PageControl1.Pages[i].TabVisible := False;

  // Fill Tree
  OptionsVST.NodeDataSize := SizeOf(TTabSheet);
  FillMainTreeView;

  count := 1;
  while (Bass_GetDeviceInfo(count, BassInfo)) do
  begin
    MainDeviceCB.Items.Add(String(BassInfo.Name));
    HeadPhonesDeviceCB.Items.Add(String(BassInfo.Name));
    inc(count);
  end;

  if MainDeviceCB.Items.Count > Integer(NempPlayer.MainDevice) then
    MainDeviceCB.ItemIndex := NempPlayer.MainDevice
  else
    if Count >= 1 then
        MainDeviceCB.ItemIndex := 0;

  if (HeadPhonesDeviceCB.Items.Count > Integer(NempPlayer.HeadsetDevice)) then
    HeadPhonesDeviceCB.ItemIndex := NempPlayer.HeadsetDevice
  else
    if Count >= 1 then
        HeadPhonesDeviceCB.ItemIndex := Count - 1
    else
    begin
        HeadPhonesDeviceCB.Enabled := False;
        LblConst_Headphones.Enabled := False;
    end;

  CBFontNameCBR.Items := Screen.Fonts;
  CBFontNameVBR.Items := Screen.Fonts;

  clbViewMainColumns.Items.BeginUpdate;
  for i := 0 to cLibraryColumnCount - 1 do
    clbViewMainColumns.Items.Add('');
  SynchMediaListColumns;
  clbViewMainColumns.Items.EndUpdate;

  OpenDlg_DefaultCover.Filter :=  //FileFormatList.GetGraphicFilter([ftRaster], fstBoth, [foCompact, foIncludeAll,foIncludeExtension], Nil);
      'All images|*.bmp; *.dib; *.gif; *.jfif; *.jpe; *.jpeg; *.jpg; *.png; *.rle|'
      + 'JPG images (*.jfif; *.jpe; *.jpeg; *.jpg)|*.jfif; *.jpe; *.jpeg; *.jpg|'
      + 'Portable network graphic images (*.png)|*.png|'
      + 'Windows bitmaps (*.bmp; *.dib; *.rle)|*.bmp; *.dib; *.rle|'
      + 'CompuServe images (*.gif)|*.gif';

  OpenDlg_CountdownSongs.Filter := Nemp_MainForm.PlaylistDateienOpenDialog.Filter;

  // MediaLibrary-Configuration
  FileCategories := TLibraryCategoryList.Create(False);
  OrganizerSettings := TOrganizerSettings.create;
  RootCollections := TAudioCollectionList.Create(False);
  VSTCategories.NodeDataSize := SizeOf(TLibraryCategory);
  VSTSortings.NodeDataSize := SizeOf(TAudioCollection);
end;


procedure TOptionsCompleteForm.FormShow(Sender: TObject);
begin
  // Beta-Option
  // cb_BetaDontUseThreadedUpdate.Checked := MedienBib.BetaDontUseThreadedUpdate;
  // cbFixCoverFlowOnStart.Checked := NempOptions.FixCoverFlowOnStart;
  ShowNempSettings;
  ShowControlsSettings;
  ShowPlayerSettings;
  ShowPlaylistSettings;
  ShowSearchSettings;
  ShowWebRadioSettings;
  ShowMetadataSettings;
  ShowFileSearchSettings;
  ShowListViewSettings;
  ShowFontsAndPartyMode;
  ShowWebServerSettings;
  ShowEffectReplayGainSettings;
  ShowBirthdaySettings;
  ShowLastFMSettings;
  ShowRegisteredFiles;

  BackUpCoverFlowSettings := MedienBib.NewCoverFlow.Settings;
  ShowCoverFlowSettings;
  ShowMediaLibraryConfiguration;
end;


procedure TOptionsCompleteForm.FillMainTreeView;
begin
  OptionsVST.BeginUpdate;
  OptionsVST.Clear;
  OptionsVST.AddChild(nil, tabGeneral);   // General Settings
  OptionsVST.AddChild(nil, tabPlayer);   // Player
  PlaylistNode := OptionsVST.AddChild(nil, tabPlaylist);   // Playlist
  OptionsVST.AddChild(nil, tabFileManagement);    // File Management
  CategoriesNode := OptionsVST.AddChild(nil, tabCategories);    // Media Library, Categories
  VorauswahlNode := OptionsVST.AddChild(nil, tabViewingSettings); // Viewing settings
  OptionsVST.AddChild(nil, tabFontSizes); // Display (Fonts+PartyMode)
  OptionsVST.AddChild(nil, tabCoverflow); // 3D-Coverflow
  OptionsVST.AddChild(nil, tabMetadata); // MetaData
  OptionsVST.AddChild(nil, tabSearch); // Search
  OptionsVST.AddChild(nil, tabWebradio); // Webradio
  OptionsVST.AddChild(nil, tabEffects); // Effects
  BirthdayNode := OptionsVST.AddChild(nil, tabBirthday); // Birthday mode
  ScrobbleNode := OptionsVST.AddChild(nil, tabLastfm); // Scrobbler
  WebServerNode := OptionsVST.AddChild(nil, tabWebserver); // Webserver
  OptionsVST.AddChild(nil, tabControl);   // Controls
  OptionsVST.AddChild(nil, tabFiletypes); // File Type Registration
  OptionsVST.EndUpdate;

  OptionsVST.FocusedNode := OptionsVST.GetFirst;
  PageControl1.ActivePageIndex := 0;
end;

procedure TOptionsCompleteForm.ShowNempSettings;
begin
  // Player and Playlist
  CB_AutoPlayOnStart.Checked  := NempPlaylist.AutoPlayOnStart;
  cb_SavePositionInTrack.Checked := NempPlaylist.SavePositionInTrack;
  cb_SavePositionInTrack.Enabled := CB_AutoPlayOnStart.Checked;
  CB_AutoPlayNewTitle.Checked     := NempPlaylist.AutoPlayNewTitle;
  CB_AutoPlayEnqueueTitle.Checked := NempPlaylist.AutoPlayEnqueuedTitle;
  // MediaLibrary
  CBAutoLoadMediaList.Checked := MedienBib.AutoLoadMediaList;
  CBAutoSaveMediaList.Checked := MedienBib.AutoSaveMediaList;
  // Windows
    cb_ShowSplashScreen.Checked := NempOptions.ShowSplashScreen;
  CB_AllowMultipleInstances.Checked := Not NempOptions.AllowOnlyOneInstance;
  CB_StartMinimized.Checked := NempOptions.StartMinimized;
  cbShowTrayIcon.Checked := NempOptions.ShowTrayIcon;
  // Portable settings
  cb_EnableUSBMode.Checked := TDrivemanager.EnableUSBMode;
  cb_EnableCloudMode.Checked := TDrivemanager.EnableCloudMode;
  // Update settings
  CB_AutoCheck.Checked := NempUpdater.AutoCheck;
  CB_AutoCheckNotifyOnBetas.Checked := NempUpdater.NotifyOnBetas;
  CBBOX_UpdateInterval.Enabled := CB_AutoCheck.Checked;
  case NempUpdater.CheckInterval of
      0: CBBOX_UpdateInterval.ItemIndex := 0;
      1: CBBOX_UpdateInterval.ItemIndex := 1;
      7: CBBOX_UpdateInterval.ItemIndex := 2;
      14: CBBOX_UpdateInterval.ItemIndex := 3;
      30: CBBOX_UpdateInterval.ItemIndex := 4;
  else
      CBBOX_UpdateInterval.ItemIndex := 2;
  end;
  // Hibernate/Standby
  cbReInitAfterSuspend.Checked := NempPlayer.ReInitAfterSuspend;
  cbPauseOnSuspend.Checked := NempPlayer.PauseOnSuspend;
end;


procedure TOptionsCompleteForm.ShowControlsSettings;

  procedure SetHotKeyControl(aIDx: TEHotKeyTypes; cbActive: TCheckBox; cbMod, cbKey: TComboBox);
  begin
    cbActive.Checked := NempOptions.HotKeys[aIDx].Activate;
    cbMod.ItemIndex    := ModToIndex(NempOptions.HotKeys[aIDx].Modifier);
    cbKey.ItemIndex    := KeyToIndex(NempOptions.HotKeys[aIDx].Key);
  end;

begin
  cb_RegisterMediaHotkeys.Checked := NempOptions.RegisterMediaHotkeys;
  CB_IgnoreVolume.Checked := NempOptions.IgnoreVolumeUpDownKeys;
  cb_UseG15Display.Checked := NempOptions.UseDisplayApp;
  CB_TabStopAtPlayerControls.Checked := NempOptions.TabStopAtPlayerControls;
  CB_TabStopAtTabs          .Checked := NempOptions.TabStopAtTabs;

  CBRegisterHotKeys.Checked := NempOptions.RegisterHotKeys;
  // set individual Hotkeys Controls
  SetHotKeyControl(hkPlay, CB_Activate_Play, CB_Mod_Play, CB_Key_Play);
  SetHotKeyControl(hkStop, CB_Activate_Stop, CB_Mod_Stop, CB_Key_Stop);
  SetHotKeyControl(hkNext, CB_Activate_Next, CB_Mod_Next, CB_Key_Next);
  SetHotKeyControl(hkPrev, CB_Activate_Prev, CB_Mod_Prev, CB_Key_Prev);
  SetHotKeyControl(hkSlideForward, CB_Activate_JumpForward, CB_Mod_JumpForward, CB_Key_JumpForward);
  SetHotKeyControl(hkSlideBack, CB_Activate_JumpBack, CB_Mod_JumpBack, CB_Key_JumpBack);
  SetHotKeyControl(hkIncVol, CB_Activate_IncVol, CB_Mod_IncVol, CB_Key_IncVol);
  SetHotKeyControl(hkDecVol, CB_Activate_DecVol, CB_Mod_DecVol, CB_Key_DecVol);
  SetHotKeyControl(hkMute, CB_Activate_Mute, CB_Mod_Mute, CB_Key_Mute);
  EnableHotKeyControls;
end;

procedure TOptionsCompleteForm.ShowPlayerSettings;
begin
  // Devices
  if NempPlayer.MainDevice > 0 then
    MainDeviceCB.ItemIndex := NempPlayer.MainDevice - 1
  else
    MainDeviceCB.ItemIndex := 0;
  if NempPlayer.HeadSetDevice > 0 then
    HeadPhonesDeviceCB.ItemIndex := NempPlayer.HeadsetDevice - 1
  else
    HeadPhonesDeviceCB.ItemIndex := 0;
  // Fading
  CB_Fading.Checked := NempPlayer.UseFading;
  SE_Fade.Value := NempPlayer.FadingInterval;
  SE_SeekFade.Value := NempPlayer.SeekFadingInterval;
  CB_IgnoreFadingOnShortTracks.Checked := NempPlayer.IgnoreFadingOnShortTracks;
  CB_IgnoreFadingOnPause.Checked := NempPlayer.IgnoreFadingOnPause;
  CB_IgnoreFadingOnStop.Checked := NempPlayer.IgnoreFadingOnStop;

  cbIgnoreFadingOnLiveRecordings.Checked := NempPlayer.IgnoreFadingOnLiveRecordings;
  cbLiveRecordingCheckTitle.Checked := NempPlayer.LiveRecordingCheckTitle;
  cbLiveRecordingCheckAlbum.Checked := NempPlayer.LiveRecordingCheckAlbum;
  cbLiveRecordingCheckTags.Checked := NempPlayer.LiveRecordingCheckTags;
  edtLiveRecordingCheckIdentifier.Text := NempPlayer.LiveRecordingCheckIdentifier;

  EnableFadingControls;
  // Skip silence
  CB_SilenceDetection.Checked  := NempPlayer.DoSilenceDetection;
  SE_SilenceThreshold.Value    := NempPlayer.SilenceThreshold;
  cb_AddBreakBetweenTracks.Checked := NempPlayer.DoPauseBetweenTracks;
  SE_BreakBetweenTracks.Value      := NempPlayer.PauseBetweenTracksDuration;
  EnableSilenceControls;
  // buffer
  SEBufferSize.Value := BASS_GetConfig(BASS_CONFIG_BUFFER);
  // floating point channels
  CB_FloatingPoint.ItemIndex := NempPlayer.UseFloatingPointChannels;
  if NempPlayer.Floatable then
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_On
  else
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_Off;
  // hardware-mixing
  if NempPlayer.UseHardwareMixing then
    CB_Mixing.ItemIndex := 0
  else
    CB_Mixing.ItemIndex := 1;
  // midi soundfonts
  editSoundFont.Text := NempPlayer.SoundfontFilename;
  // safe playback
  cb_SafePlayback.Checked := NempPlayer.SafePlayback;
  // visualization
  CB_visual.Checked := NempPlayer.UseVisualization;
  TB_Refresh.Position := 100 - NempPlayer.VisualizationInterval;
  Lbl_Framerate.Caption := inttostr(1000 DIV NempPlayer.VisualizationInterval) + ' fps';
  CB_ScrollTitelTaskBar.Checked := NempPlayer.ScrollTaskbarTitel;
  case NempPlayer.ScrollTaskbarDelay of
    0..5  : CB_TaskbarDelay.ItemIndex := 4;
    6..10 : CB_TaskbarDelay.ItemIndex := 3;
    11..15 : CB_TaskbarDelay.ItemIndex := 2;
    16..20 : CB_TaskbarDelay.ItemIndex := 1;
  else
    CB_TaskbarDelay.ItemIndex := 0
  end;
  EnableVisualizationControls;
end;

procedure TOptionsCompleteForm.ShowPlaylistSettings;
begin
  // "Verhalten der Playlist"
  CB_AutoScanPlaylist.checked := NempPlaylist.AutoScan;
  CB_JumpToNextCue.Checked          := NempPlaylist.JumpToNextCueOnNextClick;
  cb_ReplayCue.Checked              := NempPlaylist.RepeatCueOnRepeatTitle;
  CB_RememberInterruptedPlayPosition.Checked := NempPlaylist.RememberInterruptedPlayPosition;
  // Settings for favorite Playlists
  cb_PlaylistManagerAutoSave.Checked := NempPlaylist.PlaylistManager.AutoSaveOnPlaylistChange;
  cb_PlaylistManagerAutoSaveUserInput.Checked := NempPlaylist.PlaylistManager.UserInputOnPlaylistChange;
  cb_PlaylistManagerAutoSaveUserInput.Enabled := NOT cb_PlaylistManagerAutoSave.Checked;
  // Standard-Aktionen
  GrpBox_DefaultAction.ItemIndex := NempPlaylist.DefaultAction;
  cbApplyDefaultActionToWholeList.Checked := NempPlaylist.ApplyDefaultActionToWholeList;
  cbUseDefaultActionOnCoverFlowDoubleClick.Checked := NempPlaylist.UseDefaultActionOnCoverFlowDoubleClick;
  GrpBox_HeadsetDefaultAction.ItemIndex := NempPlaylist.HeadSetAction;
  cb_AutoStopHeadsetSwitchTab.Checked := NempPlaylist.AutoStopHeadsetSwitchTab;
  cb_AutoStopHeadsetAddToPlayist.Checked := NempPlaylist.AutoStopHeadsetAddToPlayist;
  // löschen und Mischen
  CB_AutoDeleteFromPlaylist.Checked := NempPlaylist.AutoDelete;
  CB_DisableAutoDeleteAtUserInput.Checked := NempPlaylist.DisableAutoDeleteAtUserInput ;
  CB_DisableAutoDeleteAtUserInput.Enabled := NempPlaylist.AutoDelete                   ;
  CB_AutoMixPlaylist.Checked        := NempPlaylist.AutoMix;
  // Playlist-Log
  cbSaveLogToFile.Checked      := NempPlayer.NempLogFile.DoLogToFile;
  seLogDuration.Value          := NempPlayer.NempLogFile.KeepLogRangeInDays;
  seLogDuration    .Enabled := NempPlayer.NempLogFile.DoLogToFile;
  LblLogDuration   .Enabled := NempPlayer.NempLogFile.DoLogToFile;
  LblLogDuration2  .Enabled := NempPlayer.NempLogFile.DoLogToFile;
  // Random Playback
  TBRandomRepeat.Position := NempPlaylist.RandomRepeat;
  cb_UseWeightedRNG.Checked := NempPlaylist.UseWeightedRNG;
  RandomWeight05.Text := IntToStr(NempPlaylist.RNGWeights[1]);
  RandomWeight10.Text := IntToStr(NempPlaylist.RNGWeights[2]);
  RandomWeight15.Text := IntToStr(NempPlaylist.RNGWeights[3]);
  RandomWeight20.Text := IntToStr(NempPlaylist.RNGWeights[4]);
  RandomWeight25.Text := IntToStr(NempPlaylist.RNGWeights[5]);
  RandomWeight30.Text := IntToStr(NempPlaylist.RNGWeights[6]);
  RandomWeight35.Text := IntToStr(NempPlaylist.RNGWeights[7]);
  RandomWeight40.Text := IntToStr(NempPlaylist.RNGWeights[8]);
  RandomWeight45.Text := IntToStr(NempPlaylist.RNGWeights[9]);
  RandomWeight50.Text := IntToStr(NempPlaylist.RNGWeights[10]);
  EnableRandomPlaybackControls;
end;

procedure TOptionsCompleteForm.ShowWebServerSettings;
begin
  NempWebServer.LoadSettings;
  NempWebServer.GetThemes(cbWebServerRootDir.Items);
  if cbWebServerRootDir.Items.IndexOf(NempWebServer.Theme) > -1 then
    cbWebServerRootDir.ItemIndex := cbWebServerRootDir.Items.IndexOf(NempWebServer.Theme);

  EdtUsername.Text      := NempWebServer.UsernameU;
  EdtPassword.Text      := NempWebServer.PasswordU;
  EdtUsernameAdmin.Text := NempWebServer.UsernameA;
  EdtPasswordAdmin.Text := NempWebServer.PasswordA;
  seWebServer_Port.Value := NempWebServer.Port;
  cbPermitLibraryAccess.Checked    := NempWebServer.AllowLibraryAccess;
  cbPermitHtmlAudio.Checked        := NempWebServer.AllowHtmlAudio;
  cbPermitPlaylistDownload.Checked := NempWebServer.AllowFileDownload;
  cbAllowRemoteControl.Checked     := NempWebServer.AllowRemoteControl;
  cbPermitVote.Checked             := NempWebServer.AllowVotes;
  getIPs(cbLANIPs.Items);
  if cbLANIPs.Items.Count > 0 then
    cbLANIPs.ItemIndex := 0;

  EdtUsername.Enabled := NOT NempWebServer.Active;
  EdtPassword.Enabled := NOT NempWebServer.Active;
  EdtUsernameAdmin.Enabled := NOT NempWebServer.Active;
  EdtPasswordAdmin.Enabled := NOT NempWebServer.Active;
  cbWebServerRootDir.Enabled := NOT NempWebServer.Active;
  seWebServer_Port.Enabled := NOT NempWebServer.Active;
  if NempWebServer.Active then
    BtnServerActivate.Caption := WebServer_DeActivateServer
  else
    BtnServerActivate.Caption := WebServer_ActivateServer;
  CBAutoStartWebServer.Checked := MedienBib.AutoActivateWebServer;
  ChangeWebserverLinks(Nil);
end;

procedure TOptionsCompleteForm.ShowEffectReplayGainSettings;
begin
  // Effects/Equalizer/Jingles
  CBJingleReduce.Checked := NempPlayer.ReduceMainVolumeOnJingle;
  SEJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;
  LblJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;

  SEJingleReduce.Value := NempPlayer.ReduceMainVolumeOnJingleValue;
  SEJingleVolume.Value := NempPlayer.JingleVolume;
  cb_UseWalkmanMode.Checked := NempPlayer.UseWalkmanMode;
  CB_UseDefaultEffects.Checked := NempPlayer.UseDefaultEffects;
  CB_UseDefaultEqualizer.Checked := NempPlayer.UseDefaultEqualizer;
  // replayGain
  cb_ApplyReplayGain.Checked   := NempPlayer.ApplyReplayGain;
  cb_PreferAlbumGain.Checked           := NempPlayer.PreferAlbumGain;
  cb_ReplayGainPreventClipping.Checked := NempPlayer.PreventClipping;
  tp_DefaultGain.Position  := Round(NempPlayer.DefaultGainWithoutRG * 10);
  tp_DefaultGain2.Position := Round(NempPlayer.DefaultGainWithRG * 10);

  EnableReplayGainControls;
end;


procedure TOptionsCompleteForm.ShowBirthdaySettings;
begin
  CBStartCountDown.Checked := NempPlayer.NempBirthdayTimer.UseCountDown;
  EditCountdownSong.Text := NempPlayer.NempBirthdayTimer.CountDownFileName;
  EditBirthdaySong.Text := NempPlayer.NempBirthdayTimer.BirthdaySongFilename;
  mskEdt_BirthdayTime.Text := TimeToStr(TimeOf(NempPlayer.NempBirthdayTimer.StartTime));
  CBContinueAfter.Checked := NempPlayer.NempBirthdayTimer.ContinueAfter;
  LBlCountDownWarning.Visible := NOT FileExists(NempPlayer.NempBirthdayTimer.CountDownFileName);
  LblEventWarning.Visible := NOT FileExists(NempPlayer.NempBirthdayTimer.BirthdaySongFilename);
  if Nemp_MainForm.BirthdayTimer.Enabled then
    BtnActivateBirthdayMode.Caption := MenuItem_Deactivate
  else
    BtnActivateBirthdayMode.Caption := MenuItem_Activate;

  EnableBirthdayControls;
end;

procedure TOptionsCompleteForm.ShowFontsAndPartyMode;
begin
  // Font settings
  SEFontSize.Value := NempOptions.DefaultFontSize;
  SERowHeight.Value := NempOptions.RowHeight;
  cb_Medialist_FontStyle.ItemIndex := NempOptions.DefaultFontStyle ;
  SEArtistAlbenSize.Value := NempOptions.ArtistAlbenFontSize;
  SEArtistAlbenRowHeight.Value := NempOptions.ArtistAlbenRowHeight;
  cb_Browselist_FontStyle.ItemIndex := NempOptions.ArtistAlbenFontStyle ;
  CBChangeFontColorOnBitrate.Checked := NempOptions.ChangeFontColorOnBitrate;
  CBChangeFontSizeOnLength.Checked := NempOptions.ChangeFontSizeOnLength;
  CBChangeFontStyleOnMode.Checked := NempOptions.ChangeFontStyleOnMode;
  CBChangeFontOnCbrVbr.Checked := NempOptions.ChangeFontOnCbrVbr;
  CBFontNameCBR.ItemIndex := CBFontNameCBR.Items.IndexOf(NempOptions.FontNameCBR);
  CBFontNameVBR.ItemIndex := CBFontNameVBR.Items.IndexOf(NempOptions.FontNameVBR);
  EnableFontControls;
  // PartyMode
  CB_PartyMode_ResizeFactor.ItemIndex := Nemp_MainForm.NempSkin.NempPartyMode.FactorToIndex;
  cb_PartyMode_BlockTreeEdit          .Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit            ;
  cb_PartyMode_BlockCurrentTitleRating.Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating  ;
  cb_PartyMode_BlockTools             .Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockTools               ;
  cb_PartyMode_ShowPasswordOnActivate .Checked := Nemp_MainForm.NempSkin.NempPartyMode.ShowPasswordOnActivate   ;
  Edt_PartyModePassword.Text := Nemp_MainForm.NempSkin.NempPartyMode.password;
end;

procedure TOptionsCompleteForm.ShowFileSearchSettings;
var
  i: Integer;
begin
  // Scan Directories
  CBAutoScan.Checked := MedienBib.AutoScanDirs;
  LBAutoScan.Items.BeginUpdate;
  LBAutoScan.Items.Clear;
  for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
    LBAutoScan.Items.Add(MedienBib.AutoScanDirList[i]);
  LBAutoScan.Items.EndUpdate;
  CBAutoAddNewDirs.Checked       := MedienBib.AutoAddNewDirs;
  CBAskForAutoAddNewDirs.Checked := MedienBib.AskForAutoAddNewDirs;
  cb_AutoDeleteFiles        .checked := MedienBib.AutoDeleteFiles;
  cb_AutoDeleteFilesShowInfo.checked := MedienBib.AutoDeleteFilesShowInfo;
  CBAutoScanPlaylistFilesOnView.Checked := MedienBib.AutoScanPlaylistFilesOnView;
  EnableDirectoryScanControls;
  // File types for the media library
  cbIncludeAll.Checked := MedienBib.IncludeAll;
  cbIncludeFiles.Items.BeginUpdate;
  for i := 0 to CBIncludeFiles.Count - 1 do
    CBIncludeFiles.Checked[i] := Pos('*' + CBIncludeFiles.Items[i], MedienBib.IncludeFilter) > 0;
  cbIncludeFiles.Items.EndUpdate;
  EnableMediaLibraryFileTypeControls;
  // Search for Cover art
  CB_CoverSearch_inDir.Checked       := TCoverArtSearcher.UseDir;
  CB_CoverSearch_inParentDir.Checked := TCoverArtSearcher.UseParentDir;
  CB_CoverSearch_inSubDir.Checked    := TCoverArtSearcher.UseSubDir;
  EDTCoverSubDirName.Enabled := CB_CoverSearch_inSubDir.Checked;
  CB_CoverSearch_inSisterDir.Checked := TCoverArtSearcher.UseSisterDir;
  EDTCoverSisterDirName.Enabled := CB_CoverSearch_inSisterDir.Checked;
  EDTCoverSubDirName.Text    := TCoverArtSearcher.SubDirName;
  EDTCoverSisterDirName.Text := TCoverArtSearcher.SisterDirName;
  cb_CoverSize.ItemIndex := TCoverArtSearcher.CoverSizeIndex;
  CB_CoverSearch_LastFM.Checked := MedienBib.CoverSearchLastFM;
end;

procedure TOptionsCompleteForm.SynchMediaListColumns;
var
  i, colIdx: Integer;
begin
  for i := 0 to cLibraryColumnCount - 1 do begin
    colIdx := Nemp_MainForm.VST.Header.Columns.ColumnFromPosition(i);
    clbViewMainColumns.Items[i] := Nemp_MainForm.VST.Header.Columns[colIdx].Text;
    clbViewMainColumns.Checked[i] := coVisible in Nemp_MainForm.VST.Header.Columns[colIdx].Options;
  end;
end;

procedure TOptionsCompleteForm.ShowListViewSettings;
begin
  // Visible Columns in media list (main VST)
  SynchMediaListColumns;
  // not available meta data
  cbReplaceArtistBy.ItemIndex := Integer(NempDisplay.ArtistSubstitute);
  cbReplaceTitleBy .ItemIndex := Integer(NempDisplay.TitleSubstitute) ;
  cbReplaceAlbumBy .ItemIndex := Integer(NempDisplay.AlbumSubstitute) ;
  LoadDefaultCover;
  // playlist formatting
  cbPlaylistTitle.Text         := NempDisplay.PlaylistTitleFormat;
  cbPlaylistTitleFB.Text       := NempDisplay.PlaylistTitleFormatFB;
  cbPlaylistTitleCueAlbum.Text := NempDisplay.PlaylistCueAlbumFormat;
  cbPlaylistTitleCueTitle.Text := NempDisplay.PlaylistCueTitleFormat;
  cbPlaylistWebradioTitle.Text := NempDisplay.PlaylistWebradioFormat;
  cb_ShowIndexInTreeview.Checked := NempPlaylist.ShowIndexInTreeview;
  // extended viewing settings
  cbAlwaysSortAnzeigeList.Checked := MedienBib.AlwaysSortAnzeigeList;
  CBSkipSortOnLargeLists.Enabled := CBAlwaysSortAnzeigeList.Checked;
  CBSkipSortOnLargeLists.Checked := MedienBib.SkipSortOnLargeLists;
  cb_limitMarkerToCurrentFiles.Checked := MedienBib.limitMarkerToCurrentFiles;
  CBShowHintsInTitlelists.Checked := MedienBib.ShowHintsInMedialist;
  CB_ShowAdvancedHints.Checked := MedienBib.ShowAdvancedHints;
  // CB_ShowHintsInPlaylist.Checked := NempPlaylist.ShowHintsInPlaylist;
  cbFullRowSelect.Checked := NempOptions.FullRowSelect;

  EnableListViewControls;
end;

procedure TOptionsCompleteForm.ShowWebRadioSettings;
begin
  // record
  EdtDownloadDir.Text := NempPlayer.DownloadDir;
  cbFilenameFormat.Text := NempPlayer.FilenameFormat;
  cbUseStreamnameAsDirectory.Checked := NempPlayer.UseStreamnameAsDirectory;
  //Split by title
  cbAutoSplitByTitle.Checked := NempPlayer.AutoSplitByTitle;
  // ... by size
  cbAutoSplitBySize.Checked := NempPlayer.AutoSplitByTime;
  SE_AutoSplitMaxSize.Value := NempPlayer.AutoSplitMaxSize;
  SE_AutoSplitMaxSize.Enabled := NempPlayer.AutoSplitByTime;
  LblConst_MaxSize.Enabled := NempPlayer.AutoSplitByTime;
  // ... by duration
  cbAutoSplitByTime.Checked := NempPlayer.AutoSplitBySize;
  SE_AutoSplitMaxTime.Value := NempPlayer.AutoSplitMaxTime;
  SE_AutoSplitMaxTime.Enabled := NempPlayer.AutoSplitBySize;
  LblConst_MaxTime.Enabled := NempPlayer.AutoSplitBySize;
  // Playlist parsing
  if NempPlaylist.BassHandlePlaylist then
    rbWebRadioHandledByBass.Checked := True
  else
    rbWebRadioParseFile.Checked := True;
end;

procedure TOptionsCompleteForm.ShowMetadataSettings;
begin
  // quick access to metadata
  cb_AccessMetadata.checked := NempOptions.AllowQuickAccessToMetadata;
  // Ignore Lyrics (for HUGE collections)
  cb_IgnoreLyrics.checked := MedienBib.IgnoreLyrics;
  // Automatic ratings
  cb_RatingActive.checked := NempPlayer.PostProcessor.Active;
  cb_RatingIgnoreShortFiles.checked := NempPlayer.PostProcessor.IgnoreShortFiles;
  cb_RatingChangeCounter.checked := NempPlayer.PostProcessor.ChangeCounter;
  cb_RatingIncreaseRating.checked := NempPlayer.PostProcessor.IncPlayedFiles;
  cb_RatingDecreaseRating.checked := NempPlayer.PostProcessor.DecAbortedFiles;
  EnableAutomaticRatingControls;
  // extended Tags
  cb_AutoResolveInconsistencies.checked := MedienBib.AutoResolveInconsistencies;
  cb_AskForAutoResolveInconsistencies.checked := MedienBib.AskForAutoResolveInconsistencies;
  cb_ShowAutoResolveInconsistenciesHints.checked := MedienBib.ShowAutoResolveInconsistenciesHints;
  // Char code detection
  CBAutoDetectCharCode.Checked := NempCharCodeOptions.AutoDetectCodePage;
  // CDDB-Settings
  cbAutoCheckNewCDs.Checked := NempOptions.AutoScanNewCDs;
  cbUseCDDB.Checked := NempOptions.UseCDDB;
  cbPreferCDDB.checked := NempOptions.PreferCDDB;
  edtCDDBServer.Text := NempOptions.CDDBServer;
  edtCDDBEMail.Text := NempOptions.CDDBEMail;
  lblInvalidCDDBMail.Visible := not ValidEmail(NempOptions.CDDBEMail);
end;

procedure TOptionsCompleteForm.ShowLastFMSettings;
begin
  ResetScrobbleButton;
  MemoScrobbleLog.Lines.Assign(NempPlayer.NempScrobbler.LogList);

  CB_AlwaysScrobble     .Checked := NempPlayer.NempScrobbler.AlwaysScrobble;
  CB_ScrobbleThisSession.Checked := NempPlayer.NempScrobbler.DoScrobble;
  CB_SilentError        .Checked := NempPlayer.NempScrobbler.IgnoreErrors;

  if NempPlayer.NempScrobbler.DoScrobble then begin
    if NempPlayer.NempScrobbler.Working then
      cpScrobbleLog.Caption := Scrobble_Active
    else
      cpScrobbleLog.Caption := Scrobble_InActive;
  end else
    cpScrobbleLog.Caption := Scrobble_Offline;
end;

procedure TOptionsCompleteForm.ShowSearchSettings;
begin
  // Media library, search settings
  CB_AccelerateSearch                 .Checked := MedienBib.BibSearcher.AccelerateSearch;
  CB_AccelerateSearchIncludePath      .Checked := MedienBib.BibSearcher.AccelerateSearchIncludePath;
  CB_AccelerateSearchIncludeComment   .Checked := MedienBib.BibSearcher.AccelerateSearchIncludeComment;
  CB_AccelerateSearchIncludeGenre     .Checked := MedienBib.BibSearcher.AccelerateSearchIncludeGenre;
  CB_AccelerateSearchIncludeAlbumArtist .Checked := MedienBib.BibSearcher.AccelerateSearchIncludeAlbumArtist;
  CB_AccelerateSearchIncludeComposer   .Checked := MedienBib.BibSearcher.AccelerateSearchIncludeComposer;
  CB_AccelerateLyricSearch            .Checked := MedienBib.BibSearcher.AccelerateLyricSearch;
  CB_QuickSearchWhileYouType          .Checked := MedienBib.BibSearcher.QuickSearchOptions.WhileYouType;
  CB_QuickSearchAllowErrorsOnEnter    .Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter;
  CB_QuickSearchAllowErrorsWhileTyping.Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType;
  cb_ChangeCoverflowOnSearch          .Checked := MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow;
  EnableSearchControls;
end;

procedure TOptionsCompleteForm.ShowRegisteredFiles;
var
  i: integer;
  ftr: TFileTypeRegistration;
begin
  ftr := TFileTypeRegistration.Create;
  try
    for i := 0 to CBFileTypes.Count - 1 do
      CBFileTypes.Checked[i] := ftr.ExtensionOpensWithApplication(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', ParamStr(0));
    for i := 0 to CBPlaylistTypes.Count - 1 do
      CBPlaylistTypes.Checked[i] := ftr.ExtensionOpensWithApplication(CBPlaylistTypes.Items[i], 'Nemp.Playlist', ParamStr(0));
  finally
    ftr.Free;
  end;
end;



procedure TOptionsCompleteForm.OptionsVSTFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var aNode: PVirtualNode;
begin
  aNode := OptionsVST.FocusedNode;
  if not Assigned(aNode) then
      Exit;
  PageControl1.ActivePage := OptionsVST.GetNodeData<TTabSheet>(aNode);

  if PageControl1.ActivePageIndex in [0..16] then
    HelpContext := HelpContexts[PageControl1.ActivePageIndex]
  else
    HelpContext := HELP_Einstellungen;
end;

procedure TOptionsCompleteForm.FormDestroy(Sender: TObject);
begin
  DetailRatingHelper.Free;
  OptionsVST.Clear;

  FileCategories.OwnsObjects := True;
  FileCategories.Free;
  OrganizerSettings.Free;
  RootCollections.OwnsObjects := True;
  RootCollections.Free;
end;

procedure TOptionsCompleteForm.OptionsVSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  case Kind of
    ikNormal,
    ikSelected: ImageIndex := OptionsVST.GetNodeData<TTabSheet>(Node).ImageIndex;
    ikState: ;
    ikOverlay: ;
  end;
end;

procedure TOptionsCompleteForm.OptionsVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
  case OptionsVST.GetNodeData<TTabSheet>(Node).ImageIndex of
    0: CellText := OptionsTree_SystemGeneral;
    1: CellText := OptionsTree_SystemControl;
    2: CellText := OptionsTree_PlayerSettings;
    3: CellText := OptionsTree_Playlist;
    4: CellText := OptionsTree_FilesMain;
    5: CellText := OptionsTree_Categories;
    6: CellText := OptionsTree_ViewMain;
    7: CellText := OptionsTree_FontsAndPartyMode;
    8: CellText := OptionsTree_CoverFlow;
    9: CellText := OptionsTree_MetaData;
    10: CellText := OptionsTree_MediabibSearch;
    11: CellText := OptionsTree_PlayerWebradio;
    12: CellText := OptionsTree_PlayerEffects;
    13: CellText := OptionsTree_PlayerEvents;
    14: CellText := OptionsTree_PlayerScrobbler;
    15: CellText := OptionsTree_PlayerWebServer;
    16: CellText := OptionsTree_SystemFiletyps;
  else
    CellText := '';
  end;

end;

procedure TOptionsCompleteForm.OptionsVSTMeasureTextWidth(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  Column: TColumnIndex; const Text: string; var Extent: Integer);
begin
  Node.States := Node.States + [vsMultiline];
end;

procedure TOptionsCompleteForm.OptionsVSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;


function TOptionsCompleteForm.ValidTime(aText: String): Boolean;
var
  h, min: Integer;
begin
    //txt_time := mskEdt_BirthdayTime.Text;
    h := StrToInt(TrimRight(Copy(aText, 0, 2)));
    min := StrToInt(TrimRight(Copy(aText, 4, 2)));

    result := (min >= 0) AND (min < 60)
            AND (h >= 0) AND (h < 24);
end;


procedure TOptionsCompleteForm.mskEdt_BirthdayTimeExit(Sender: TObject);
begin
    if not ValidTime(mskEdt_BirthdayTime.Text) then
    begin
        MessageDlg((OptionsForm_InvalidTime), mtWarning, [MBOK], 0);
        mskEdt_BirthdayTime.Text := TimeToStr(TimeOf(NempPlayer.NempBirthdayTimer.StartTime));
        mskEdt_BirthdayTime.SetFocus;
    end;
end;

procedure TOptionsCompleteForm.tp_DefaultGain2Change(Sender: TObject);
begin
    if tp_DefaultGain2.Position = 0 then
        lblDefaultgainValue2.Caption := '0.00 dB'
    else
        lblDefaultgainValue2.Caption := GainValueToString(tp_DefaultGain2.Position / 10);
end;

procedure TOptionsCompleteForm.tp_DefaultGain2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tp_DefaultGain2.Position := 0;
end;

procedure TOptionsCompleteForm.tp_DefaultGainChange(Sender: TObject);
begin
    if tp_DefaultGain.Position = 0 then
        lblDefaultgainValue.Caption := '0.00 dB'
    else
        lblDefaultgainValue.Caption := GainValueToString(tp_DefaultGain.Position / 10);
    //Format('%6.2f dB', [tp_DefaultGain.Position / 10]);
end;

procedure TOptionsCompleteForm.tp_DefaultGainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
        tp_DefaultGain.Position := 0;
end;

Function TOptionsCompleteForm.ModToIndex(aMod: Cardinal): Integer;
begin
  case aMod of
    MOD_ALT or MOD_CONTROL: result := 0;
    MOD_ALT or MOD_SHIFT: result := 1;
    MOD_CONTROL or MOD_SHIFT: result := 2
  else
    result := 2;
  end;
end;


Function TOptionsCompleteForm.IndexToMod(aIndex: Integer): Cardinal;
begin
  case aIndex of
    0: result := MOD_ALT or MOD_CONTROL;
    1: result := MOD_ALT or MOD_SHIFT;
    2: result := MOD_CONTROL or MOD_SHIFT;
  else
    result := MOD_ALT or MOD_CONTROL;
  end;
end;


Function TOptionsCompleteForm.KeyToIndex(aKey: Byte): Integer;
begin
  case aKey of
    ord('A')..Ord('Z'): result := aKey - ord('A');
    ord('0')..ord('9'): result := aKey - ord('0') + 26;
    $BB: result := 36;
    $BD: result := 37;
    VK_F1..VK_F12: result := aKey - VK_F1 + 38
  else
    result := 0;
  end;
end;
Function TOptionsCompleteForm.IndexToKey(aIndex: Integer): byte;
begin
  case aIndex of
    0..25: result := aIndex + Ord('A');
    26..35: result := aIndex - 26 + Ord('0');
    36: result := $BB;
    37: result := $BD;
    38..49: result := aIndex - 38 + VK_F1;
  else
    result := ord('A');
  end;
end;


procedure TOptionsCompleteForm.TB_RefreshChange(Sender: TObject);
begin
  Lbl_Framerate.Caption := inttostr(1000 DIV (100 - TB_Refresh.Position)) + ' fps';
end;

procedure TOptionsCompleteForm.EnableFadingControls;
begin
  SE_Fade.Enabled := CB_Fading.Checked;
  SE_SeekFade.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnShortTracks.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnPause.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnStop.Enabled := CB_Fading.Checked;
  LblConst_TitleChange.Enabled := CB_Fading.Checked;
  LblConst_TitleFade.Enabled := CB_Fading.Checked;
  LblConst_ms1.Enabled := CB_Fading.Checked;
  LblConst_ms2.Enabled := CB_Fading.Checked;
  cbIgnoreFadingOnLiveRecordings.Enabled := CB_Fading.Checked;
  lblIdentifyLiveTracksBy.Enabled := CB_Fading.Checked and cbIgnoreFadingOnLiveRecordings.Checked;
  cbLiveRecordingCheckTitle.Enabled := CB_Fading.Checked and cbIgnoreFadingOnLiveRecordings.Checked;
  cbLiveRecordingCheckAlbum.Enabled := CB_Fading.Checked and cbIgnoreFadingOnLiveRecordings.Checked;
  cbLiveRecordingCheckTags.Enabled := CB_Fading.Checked and cbIgnoreFadingOnLiveRecordings.Checked;
  edtLiveRecordingCheckIdentifier.Enabled := CB_Fading.Checked and cbIgnoreFadingOnLiveRecordings.Checked;
end;

procedure TOptionsCompleteForm.CB_FadingClick(Sender: TObject);
begin
  EnableFadingControls;
end;

procedure TOptionsCompleteForm.EnableSilenceControls;
begin
  Lbl_SilenceThreshold.Enabled := CB_SilenceDetection.Checked;
  SE_SilenceThreshold.Enabled  := CB_SilenceDetection.Checked;
  Lbl_SilenceDB.Enabled        := CB_SilenceDetection.Checked;
  SE_BreakBetweenTracks.Enabled := cb_AddBreakBetweenTracks.Checked;
  lblBreakBetweenTracks.Enabled := cb_AddBreakBetweenTracks.Checked;
end;

procedure TOptionsCompleteForm.CB_SilenceDetectionClick(Sender: TObject);
begin
  EnableSilenceControls;
end;

procedure TOptionsCompleteForm.EnableReplayGainControls;
begin
  cb_PreferAlbumGain   .Enabled   := cb_ApplyReplayGain.Checked;
  lblReplayGainDefault .Enabled   := cb_ApplyReplayGain.Checked;
  tp_DefaultGain       .Enabled   := cb_ApplyReplayGain.Checked;
  tp_DefaultGain2      .Enabled   := cb_ApplyReplayGain.Checked;
  lblDefaultGainValue  .Enabled   := cb_ApplyReplayGain.Checked;
  lblDefaultGainValue2 .Enabled   := cb_ApplyReplayGain.Checked;
  cb_ReplayGainPreventClipping.Enabled := cb_ApplyReplayGain.Checked;
  lblRG_Preamp1.Enabled                := cb_ApplyReplayGain.Checked;
  lblRG_Preamp2.Enabled                := cb_ApplyReplayGain.Checked;
end;

procedure TOptionsCompleteForm.cb_ApplyReplayGainClick(Sender: TObject);
begin
  EnableReplayGainControls;
end;

procedure TOptionsCompleteForm.RandomWeight05Exit(Sender: TObject);
begin
    if (Sender as TEdit).Text = '' then
        (Sender as TEdit).Text := '1';
end;

procedure TOptionsCompleteForm.EnableRandomPlaybackControls;
var
  enbld: Boolean;
begin
  enbld := cb_UseWeightedRNG.Checked;
  RandomWeight05.Enabled := enbld;
  RandomWeight10.Enabled := enbld;
  RandomWeight15.Enabled := enbld;
  RandomWeight20.Enabled := enbld;
  RandomWeight25.Enabled := enbld;
  RandomWeight30.Enabled := enbld;
  RandomWeight35.Enabled := enbld;
  RandomWeight40.Enabled := enbld;
  RandomWeight45.Enabled := enbld;
  RandomWeight50.Enabled := enbld;
end;

procedure TOptionsCompleteForm.cb_UseWeightedRNGClick(Sender: TObject);
begin
  EnableRandomPlaybackControls;
end;

procedure TOptionsCompleteForm.cb_IgnoreLyricsClick(Sender: TObject);
var currentLibraryLyricsUsage: TLibraryLyricsUsage;
begin
          if (cb_IgnoreLyrics.Checked) AND (NOT MedienBib.IgnoreLyrics) then
          begin
              // show a warning about this.
              // get lyrics information (total size of lyrics in MB?)
              // explain what this means (reloading all data necessary etc.)

              currentLibraryLyricsUsage := MedienBib.GetLyricsUsage;

              if  (currentLibraryLyricsUsage.FilesWithLyrics = 0) OR
                  (TranslateMessageDlg ( Format(Warning_LyricsUsage,
                                        [currentLibraryLyricsUsage.FilesWithLyrics,
                                        currentLibraryLyricsUsage.TotalFiles,
                                        SizeToString2(currentLibraryLyricsUsage.TotalLyricSize)]),
                          mtWarning, [mbYes, MBNo, MBAbort], 0, mbAbort )
                  = mrYes) then
              begin
                  // ok, accept settings later
              end else
              begin
                  // cancel, reset checkbox
                  cb_IgnoreLyrics.Checked := False;
              end;
          end else
          ;
              // ok, setting IgnoreLyrics back to "false" (=using lyrics in the library) is fine.
              //MedienBib.IgnoreLyrics := cb_IgnoreLyrics.Checked;
end;

procedure TOptionsCompleteForm.cb_PlaylistManagerAutoSaveClick(Sender: TObject);
begin
    //
    cb_PlaylistManagerAutoSaveUserInput.Enabled := NOT cb_PlaylistManagerAutoSave.Checked;
end;

procedure TOptionsCompleteForm.EnableAutomaticRatingControls;
begin
  cb_RatingIgnoreShortFiles.Enabled := cb_RatingActive.Checked;
  cb_RatingChangeCounter.Enabled := cb_RatingActive.Checked;
  cb_RatingIncreaseRating.Enabled := cb_RatingActive.Checked;
  cb_RatingDecreaseRating.Enabled := cb_RatingActive.Checked;
end;

procedure TOptionsCompleteForm.cb_RatingActiveClick(Sender: TObject);
begin
  EnableAutomaticRatingControls;
end;

procedure TOptionsCompleteForm.EnableVisualizationControls;
begin
  TB_Refresh.Enabled := CB_Visual.Checked;
  Lbl_Framerate.Enabled := CB_Visual.Checked;
  CB_TaskbarDelay.Enabled := CB_ScrollTitelTaskBar.Checked;
end;

procedure TOptionsCompleteForm.CB_visualClick(Sender: TObject);
begin
  EnableVisualizationControls;
end;

procedure TOptionsCompleteForm.CB_AutoPlayOnStartClick(Sender: TObject);
begin
  cb_SavePositionInTrack.Enabled := CB_AutoPlayOnStart.Checked;
end;

procedure TOptionsCompleteForm.CB_CoverSearch_inSubDirClick(Sender: TObject);
begin
  EDTCoverSubDirName.Enabled := CB_CoverSearch_inSubDir.Checked;
end;

procedure TOptionsCompleteForm.CB_CoverSearch_inSisterDirClick(Sender: TObject);
begin
  EDTCoverSisterDirName.Enabled := CB_CoverSearch_inSisterDir.Checked;
end;

procedure TOptionsCompleteForm.EnableFontControls;
begin
  LblConst_FontVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  LblConst_FontCBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  CBFontNameVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  CBFontNameCBR.Enabled := CBChangeFontOnCbrVbr.Checked;
end;

procedure TOptionsCompleteForm.CBChangeFontOnCbrVbrClick(Sender: TObject);
begin
  EnableFontControls;
end;


procedure TOptionsCompleteForm.Btn_SelectAllClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to CBFileTypes.Count - 1 do
    CBFileTypes.Checked[i] := True;
  for i := 0 to CBPlaylistTypes.Count-1 do
    CBPlaylistTypes.Checked[i] := True;
end;


procedure TOptionsCompleteForm.BtnRefreshDevicesClick(Sender: TObject);
var count: Integer;
    BassInfo: BASS_DEVICEINFO;
begin
    NempPlaylist.RepairBassEngine(True);
    MainDeviceCB.Items.Clear;
    HeadPhonesDeviceCB.Items.Clear;

    count := 1;
    while (Bass_GetDeviceInfo(count, BassInfo)) do
    begin
        MainDeviceCB.Items.Add(String(BassInfo.Name));
        HeadPhonesDeviceCB.Items.Add(String(BassInfo.Name));
        inc(count);
    end;

    if MainDeviceCB.Items.Count > Integer(NempPlayer.MainDevice) then
        MainDeviceCB.ItemIndex := NempPlayer.MainDevice - 1
    else
      if Count >= 1 then
          MainDeviceCB.ItemIndex := 0;

    if (HeadPhonesDeviceCB.Items.Count > Integer(NempPlayer.HeadsetDevice)) then
        HeadPhonesDeviceCB.ItemIndex := NempPlayer.HeadsetDevice //- 1
    else
        if Count >= 1 then
            HeadPhonesDeviceCB.ItemIndex := Count - 1
    else
    begin
        HeadPhonesDeviceCB.Enabled := False;
        LblConst_Headphones.Enabled := False;
    end;

end;

procedure TOptionsCompleteForm.BtnRegistryUpdateClick(Sender: TObject);
var ftr: TFileTypeRegistration;
  i: integer;
begin
  ftr := TFileTypeRegistration.Create;

  // Einzelne Endungen registrieren
  for i := 0 to NempPlayer.ValidExtensions.Count - 1 do
    if CBFileTypes.Checked[i] then
      ftr.RegisterType(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', 'Nemp Audiofile', Paramstr(0), 0);

  // Operationen für Nemp.AudioFile hinzufügen
  ftr.AddHandler('open','"' +  Paramstr(0) + '" "%1"');
  ftr.AddHandler('enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_AudioFileEnqueue));
  if CBEnqueueStandard.Checked then
    ftr.SetDefaultHandler;
  ftr.AddHandler('play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_AudioFilePlay));
  if NOT CBEnqueueStandard.Checked then
    ftr.SetDefaultHandler;

  // Playlisten-Typen hinzufügen
  for i := 0 to CBPlaylistTypes.Count - 1 do
    if CBPlaylistTypes.Checked[i] then
      ftr.RegisterType(CBPlaylistTypes.Items[i], 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);

  ftr.AddHandler('open','"' +  Paramstr(0) + '" "%1"');
  ftr.AddHandler('enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_PlaylistEnqueue));
  if CBEnqueueStandardLists.Checked then
    ftr.SetDefaultHandler;
  ftr.AddHandler('play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_PlaylistPlay));
  if NOT CBEnqueueStandardLists.Checked then
    ftr.SetDefaultHandler;

  // Kontextmenüs der Ordner ergänzen oder teilweise löschen
  if CBDirectorySupport.Checked then
  begin
    ftr.AddDirectoryHandler('Nemp.Enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_DirEnqueue));
    ftr.AddDirectoryHandler('Nemp.Play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_DirPlay));
  end else
  begin
    ftr.DeleteDirectoryHandler('Nemp.Enqueue');
    ftr.DeleteDirectoryHandler('Nemp.Play');
  end;

  ftr.UpdateShell;
  ftr.free;
end;

procedure TOptionsCompleteForm.EnableMediaLibraryFileTypeControls;
begin
  cbIncludeFiles.Enabled := NOT cbIncludeAll.Checked;
  BtnRecommendedFiletypes.Enabled := NOT cbIncludeAll.Checked;
  LblConst_OnlythefollowingTypes.Enabled := NOT cbIncludeAll.Checked;
end;

procedure TOptionsCompleteForm.cbIncludeAllClick(Sender: TObject);
begin
  EnableMediaLibraryFileTypeControls;
end;


procedure TOptionsCompleteForm.RecommendedFiletypesClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to CBIncludeFiles.Count - 1 do
    begin
        CBIncludeFiles.Checked[i] :=
            (CBIncludeFiles.Items[i] = '.mp3')
            or (CBIncludeFiles.Items[i] = '.ogg')
            or (CBIncludeFiles.Items[i] = '.mp1')
            or (CBIncludeFiles.Items[i] = '.mp2')
            or (CBIncludeFiles.Items[i] = '.flac')
            or (CBIncludeFiles.Items[i] = '.fla')
            or (CBIncludeFiles.Items[i] = '.opus')
            or (CBIncludeFiles.Items[i] = '.oga')
            or (CBIncludeFiles.Items[i] = '.wma')
            or (CBIncludeFiles.Items[i] = '.mp4')
            or (CBIncludeFiles.Items[i] = '.m4a')
            or (CBIncludeFiles.Items[i] = '.ape')
            or (CBIncludeFiles.Items[i] = '.mpc')
            or (CBIncludeFiles.Items[i] = '.ofr')
            or (CBIncludeFiles.Items[i] = '.ofs')
            or (CBIncludeFiles.Items[i] = '.tta')
            or (CBIncludeFiles.Items[i] = '.wv');
    end;
end;

procedure TOptionsCompleteForm.CBJingleReduceClick(Sender: TObject);
begin
  SEJingleReduce.Enabled := CBJingleReduce.Checked;
  LblJingleReduce.Enabled := CBJingleReduce.Checked;
end;

procedure TOptionsCompleteForm.CB_AutoDeleteFromPlaylistClick(
  Sender: TObject);
begin
      CB_DisableAutoDeleteAtUserInput.Enabled := CB_AutoDeleteFromPlaylist.Checked  ;
end;


procedure TOptionsCompleteForm.FormActivate(Sender: TObject);
begin
  SynchMediaListColumns;
end;

// GeburtstagsOptionen
procedure TOptionsCompleteForm.BtnCountDownSongClick(Sender: TObject);
begin
  If OpenDlg_CountdownSongs.Execute then
    EditCountDownSong.Text := OpenDlg_CountdownSongs.FileName;
end;

procedure TOptionsCompleteForm.BtnSelectSoundFontFileClick(Sender: TObject);
begin
    if OpenDlg_SoundFont.Execute then
        editSoundFont.Text := OpenDlg_SoundFont.FileName;
end;


procedure TOptionsCompleteForm.BtnCountRatingClick(Sender: TObject);
var aList: TAudioFileList;
    i, rawRating: Integer;
    RatingCounts: Array[0..10] of Integer;
begin
    aList := TAudioFileList.Create(False);
    try
        if cbCountRatingOnlyPlaylist.Checked then
        begin
            // copy the playlist
            for i := 0 to NempPlaylist.Playlist.Count-1 do
                aList.Add(NempPlaylist.Playlist.Items[i]);
        end
        else
        begin
            if MedienBib.StatusBibUpdate <> 0 then
                TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
            else
                MedienBib.FillListWithMedialibrary(aList);
        end;

        // do the counting
        for i := 0 to 10 do
            RatingCounts[i] := 0;

        for i := 0 to aList.Count-1 do
        begin
            rawRating := aList[i].Rating;
            if rawRating = 0 then
                inc(RatingCounts[0]);
            // that one as well (always), because a rating of "0" is treated as "127" in general
            inc(RatingCounts[RatingToArrayIndex(rawRating)]);
        end;

        // show the results
        lblCount00.caption := Format(OptionsForm_UnratedFilesHint, [RatingCounts[0]]);

        lblCount05.Caption := '(' + IntToStr(RatingCounts[1]) + ')';
        lblCount10.Caption := '(' + IntToStr(RatingCounts[2]) + ')';
        lblCount15.Caption := '(' + IntToStr(RatingCounts[3]) + ')';
        lblCount20.Caption := '(' + IntToStr(RatingCounts[4]) + ')';
        if RatingCounts[0] > 0 then
            lblCount25.Caption := '(' + IntToStr(RatingCounts[5]) + ')*'
        else
            lblCount25.Caption := '(' + IntToStr(RatingCounts[5]) + ')';
        lblCount30.Caption := '(' + IntToStr(RatingCounts[6]) + ')';
        lblCount35.Caption := '(' + IntToStr(RatingCounts[7]) + ')';
        lblCount40.Caption := '(' + IntToStr(RatingCounts[8]) + ')';
        lblCount45.Caption := '(' + IntToStr(RatingCounts[9]) + ')';
        lblCount50.Caption := '(' + IntToStr(RatingCounts[10]) + ')';

        lblCount00.Visible := RatingCounts[0] > 0;
        lblCount05.Visible := True;
        lblCount10.Visible := True;
        lblCount15.Visible := True;
        lblCount20.Visible := True;
        lblCount25.Visible := True;
        lblCount30.Visible := True;
        lblCount35.Visible := True;
        lblCount40.Visible := True;
        lblCount45.Visible := True;
        lblCount50.Visible := True;

    finally
        aList.Free;
    end;
end;


procedure TOptionsCompleteForm.BtnBirthdaySongClick(Sender: TObject);
begin
  If OpenDlg_CountdownSongs.Execute then
    EditBirthdaySong.Text := OpenDlg_CountdownSongs.FileName;
end;

function TOptionsCompleteForm.GetFocussedAudioFileName: UnicodeString;
begin
  // result := '';
  // if assigned(MedienBib.CurrentAudioFile) then
  //    result := MedienBib.CurrentAudioFile.Pfad;
  result := Nemp_MainForm.CurrentlySelectedFile.Pfad;
end;

procedure TOptionsCompleteForm.BtnGetCountDownTitelClick(Sender: TObject);
begin
  EditCountDownSong.Text := GetFocussedAudioFileName;
end;


procedure TOptionsCompleteForm.BtnGetBirthdayTitelClick(Sender: TObject);
begin
  EditBirthdaySong.Text := GetFocussedAudioFileName;
end;


procedure TOptionsCompleteForm.BtnActivateBirthdayModeClick(Sender: TObject);
begin
    // Apply Birthday-Mode settings
    if ValidTime(mskEdt_BirthdayTime.Text) then
    begin
        with NempPlayer.NempBirthdayTimer do
        begin
            if (CountDownFileName <> EditCountdownSong.Text)
              or (BirthdaySongFilename <> EditBirthdaySong.Text)
              or (UseCountDown <> CBStartCountDown.Checked)
              or (StartTime <> StrToTime(mskEdt_BirthdayTime.Text))
            then
            begin
                CountDownFileName := EditCountdownSong.Text;
                BirthdaySongFilename := EditBirthdaySong.Text;
                StartTime := StrToTime(mskEdt_BirthdayTime.Text);
                UseCountDown := CBStartCountDown.Checked AND (Trim(EditCountdownSong.Text)<> '');

                if UseCountDown then
                    StartCountDownTime := IncSecond(StartTime, - NempPlayer.GetCountDownLength(CountDownFileName))
                else
                    StartCountDownTime := StartTime;
            end;
            ContinueAfter := CBContinueAfter.Checked;
        end;
    end;

    // Check settings
    if (NOT Nemp_MainForm.BirthdayTimer.Enabled) AND (Not NempPlayer.CheckBirthdaySettings) then
        // abort activating
        TranslateMessageDLG((BirthdaySettings_IncompleteSettingsDialog), mtWarning, [mbOk], 0)
    else
    begin
        // Activate Birthday-Mode (or cancel it)
         Nemp_MainForm.MM_T_BirthdayActivate.click;
    end;
end;


procedure TOptionsCompleteForm.cbSaveLogToFileClick(Sender: TObject);
begin
  seLogDuration   .Enabled := cbSaveLogToFile.Checked;
  LblLogDuration  .Enabled := cbSaveLogToFile.Checked;
  LblLogDuration2 .Enabled := cbSaveLogToFile.Checked;
end;


procedure TOptionsCompleteForm.BTNApplyClick(Sender: TObject);
var
  allSettingsDone: Boolean;
begin
  allSettingsDone := True;

  ApplyNempSettings;
  ApplyControls;
  ApplyPlayerSettings;
  ApplyPlaylistSettings;
  ApplyListViewSettings;
  ApplyFontsAndPartyMode;
  ApplyWebRadioSettings;
  ApplyEffectReplayGainSettings;
  ApplyBirthdaySettings;
  ApplyLastFMSettings;
  ApplyWebServerSettings;
  ApplyFileSearchSettings;
  ApplyMetadataSettings;

  if cb_UseClassicCoverflow.Checked then begin
    if MedienBib.NewCoverFlow.Mode <> cm_Classic then
      MedienBib.NewCoverFlow.Mode := cm_Classic
  end
  else begin
    if MedienBib.NewCoverFlow.Mode <> cm_OpenGL then
      MedienBib.NewCoverFlow.Mode := cm_OpenGL;
  end;
  ApplyCoverFlowSettings;
  MedienBib.NewCoverFlow.ApplySettings;
  if not Nemp_MainForm.NempSkin.isActive then
    MedienBib.NewCoverFlow.SetColor(MedienBib.NewCoverFlow.Settings.DefaultColor);
  BackUpCoverFlowSettings := MedienBib.NewCoverFlow.Settings;

  if not ApplySearchSettings then
    allSettingsDone := False;
  if not ApplyMediaLibraryConfiguration then
    allSettingsDone := False;

  NempOptions.SaveSettings;
  NempSettingsManager.WriteToDisk;
  ReArrangeToolImages;

  // Show MessageDlg, if not all settings were saved
  if not allSettingsDone then
    MessageDLG((Warning_MedienBibIsBusy_Options), mtWarning, [MBOK], 0);
end;

procedure TOptionsCompleteForm.BTNokClick(Sender: TObject);
begin
  BTNApplyClick(Nil);
  Close;
end;

procedure TOptionsCompleteForm.ApplyNempSettings;
begin
  // Player and Playlist
  NempPlaylist.AutoPlayOnStart  := CB_AutoPlayOnStart.Checked;
  NempPlaylist.SavePositionInTrack := cb_SavePositionInTrack.Checked;
  NempPlaylist.AutoPlayNewTitle := CB_AutoPlayNewTitle.Checked;
  NempPlaylist.AutoPlayEnqueuedTitle := CB_AutoPlayEnqueueTitle.Checked;
  // Media library
  MedienBib.AutoLoadMediaList := CBAutoLoadMediaList.Checked;
  MedienBib.AutoSaveMediaList := CBAutoSaveMediaList.Checked;
  // Windows
  NempOptions.ShowSplashScreen := cb_ShowSplashScreen.Checked;
  NempOptions.AllowOnlyOneInstance := Not CB_AllowMultipleInstances.Checked;
  NempOptions.StartMinimized  := CB_StartMinimized.Checked;
  NempOptions.ShowTrayIcon := cbShowTrayIcon.Checked;
  Nemp_MainForm.NempTrayIcon.Visible := NempOptions.ShowTrayIcon;
  // Nemp portable
  // CloudMode affects how the MediaLibrary is saved into a gmp-File.
  // If we changed this setting, the library should be saved when Nemp is closed
  if TDrivemanager.EnableCloudMode <> cb_EnableCloudMode.Checked then
      MedienBib.Changed := True;
  TDrivemanager.EnableUSBMode   := cb_EnableUSBMode.Checked   ;
  TDrivemanager.EnableCloudMode := cb_EnableCloudMode.Checked ;
  // Update settings
  NempUpdater.AutoCheck := CB_AutoCheck.Checked;
  NempUpdater.NotifyOnBetas := CB_AutoCheckNotifyOnBetas.Checked;
  case CBBOX_UpdateInterval.ItemIndex  of
    0: NempUpdater.CheckInterval := 0;
    1: NempUpdater.CheckInterval := 1;
    2: NempUpdater.CheckInterval := 7;
    3: NempUpdater.CheckInterval := 14;
    4: NempUpdater.CheckInterval := 30;
  else
    NempUpdater.CheckInterval := 7;
  end;
  // Hibernate, StandBy
  NempPlayer.ReInitAfterSuspend := cbReInitAfterSuspend.Checked;
  NempPlayer.PauseOnSuspend := cbPauseOnSuspend.Checked;
end;

procedure TOptionsCompleteForm.ApplyControls;
var
  tmp: String;
begin
  // multmedia keys
  NempOptions.RegisterMediaHotkeys   := cb_RegisterMediaHotkeys.Checked;
  NempOptions.IgnoreVolumeUpDownKeys := CB_IgnoreVolume.Checked;
  // Keyboard-Display-App
  if cb_UseG15Display.Checked and (NOT NempOptions.UseDisplayApp) then begin
    // G15 App is not currently active -> activate it!
    if NempOptions.DisplayApp = '' then
      tmp := 'NempG15App.exe'
    else
      tmp := ExtractFilepath(paramStr(0)) + NempOptions.DisplayApp;
      if FileExists(tmp) then
        shellexecute(Handle, 'open', pchar('"' + tmp + '"'), 'userstart', NIL, sw_hide)
      else
        TranslateMessageDLG((StartG15AppNotFound), mtWarning, [mbOK], 0)
  end;
  NempOptions.UseDisplayApp := cb_UseG15Display.Checked;
  // global Hotkeys
  NempOptions.RegisterHotKeys := CBRegisterHotKeys.Checked;
  // Uninstall global hotkeys
  NempOptions.UnInstallHotKeys;
  NempOptions.UninstallMediakeyHotkeys;
  // Set new values
  NempOptions.DefineHotKey(hkPlay,         CB_Activate_Play.Checked, IndexToMod(CB_Mod_Play.ItemIndex), IndexToKey(CB_Key_Play.ItemIndex));
  NempOptions.DefineHotKey(hkStop,         CB_Activate_Stop.Checked, IndexToMod(CB_Mod_Stop.ItemIndex), IndexToKey(CB_Key_Stop.ItemIndex));
  NempOptions.DefineHotKey(hkNext,         CB_Activate_Next.Checked, IndexToMod(CB_Mod_Next.ItemIndex), IndexToKey(CB_Key_Next.ItemIndex));
  NempOptions.DefineHotKey(hkPrev,         CB_Activate_Prev.Checked, IndexToMod(CB_Mod_Prev.ItemIndex), IndexToKey(CB_Key_Prev.ItemIndex));
  NempOptions.DefineHotKey(hkSlideForward, CB_Activate_JumpForward.Checked, IndexToMod(CB_Mod_JumpForward.ItemIndex), IndexToKey(CB_Key_JumpForward.ItemIndex));
  NempOptions.DefineHotKey(hkSlideBack,    CB_Activate_JumpBack.Checked, IndexToMod(CB_Mod_JumpBack.ItemIndex), IndexToKey(CB_Key_JumpBack.ItemIndex));
  NempOptions.DefineHotKey(hkIncVol,       CB_Activate_IncVol.Checked, IndexToMod(CB_Mod_IncVol.ItemIndex), IndexToKey(CB_Key_IncVol.ItemIndex));
  NempOptions.DefineHotKey(hkDecVol,       CB_Activate_DecVol.Checked, IndexToMod(CB_Mod_DecVol.ItemIndex), IndexToKey(CB_Key_DecVol.ItemIndex));
  NempOptions.DefineHotKey(hkMute,         CB_Activate_Mute.Checked, IndexToMod(CB_Mod_Mute.ItemIndex), IndexToKey(CB_Key_Mute.ItemIndex));
  // Register them again
  if NempOptions.RegisterHotKeys then
      NempOptions.InstallHotkeys;
  if NempOptions.RegisterMediaHotkeys then
      NempOptions.InstallMediakeyHotkeys(NempOptions.IgnoreVolumeUpDownKeys);
  // Set TabStops
  NempOptions.TabStopAtPlayerControls := CB_TabStopAtPlayerControls.Checked;
  NempOptions.TabStopAtTabs           := CB_TabStopAtTabs          .Checked;
  SetTabStopsPlayer;
  SetTabStopsTabs;
end;

procedure TOptionsCompleteForm.ApplyPlayerSettings;
begin
  // Output Devices
  Bass_SetDevice(MainDeviceCB.ItemIndex + 1);
  NempPlayer.MainDevice := MainDeviceCB.ItemIndex + 1;
  NempPlayer.HeadsetDevice := HeadPhonesDeviceCB.ItemIndex +1;
  // SoundFont for MIDI
  if (editSoundFont.Text <> NempPlayer.SoundfontFilename) and FileExists(editSoundFont.Text) then begin
    NempPlayer.SoundfontFilename := editSoundFont.Text;
    NempPlayer.SetSoundFont(editSoundFont.Text);
  end;
  // Buffer size, Floating point channels and Mixing
  BASS_SetConfig(BASS_CONFIG_BUFFER, SEBufferSize.Value);
  NempPlayer.PlayBufferSize := SEBufferSize.Value;
  NempPlayer.UseFloatingPointChannels := CB_FloatingPoint.ItemIndex;
  NempPlayer.UseHardwareMixing := CB_Mixing.ItemIndex = 0;
  NempPlayer.UpdateFlags;
  if NempPlayer.Floatable then
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_On
  else
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_Off;
  // Fading, Silence between Tracks
  NempPlayer.UseFading := CB_Fading.Checked;
  NempPlayer.FadingInterval := SE_Fade.Value;
  NempPlayer.SeekFadingInterval := SE_SeekFade.Value;
  NempPlayer.IgnoreFadingOnShortTracks := CB_IgnoreFadingOnShortTracks.Checked;
  NempPlayer.IgnoreFadingOnPause := CB_IgnoreFadingOnPause.Checked;
  NempPlayer.IgnoreFadingOnStop := CB_IgnoreFadingOnStop.Checked;
  NempPlayer.IgnoreFadingOnLiveRecordings  := cbIgnoreFadingOnLiveRecordings.Checked;
  NempPlayer.LiveRecordingCheckTitle       := cbLiveRecordingCheckTitle.Checked;
  NempPlayer.LiveRecordingCheckAlbum       := cbLiveRecordingCheckAlbum.Checked;
  NempPlayer.LiveRecordingCheckTags        := cbLiveRecordingCheckTags.Checked;
  NempPlayer.LiveRecordingCheckIdentifier  := Trim(edtLiveRecordingCheckIdentifier.Text);

  NempPlayer.DoSilenceDetection := CB_SilenceDetection.Checked ;
  NempPlayer.SilenceThreshold   := SE_SilenceThreshold.Value   ;
  NempPlayer.DoPauseBetweenTracks       := cb_AddBreakBetweenTracks.Checked;
  NempPlayer.PauseBetweenTracksDuration := SE_BreakBetweenTracks.Value;
  // Visualization
  NempPlayer.UseVisualization := CB_Visual.Checked;
  if not NempPlayer.UseVisualization then
    spectrum.DrawClear;
  NempPlayer.VisualizationInterval := 100 - TB_Refresh.Position;
  Nemp_MainForm.BassTimer.Interval := NempPlayer.VisualizationInterval;
  Nemp_MainForm.HeadsetTimer.Interval := NempPlayer.VisualizationInterval;
  // Taskbar scrolling
  NempPlayer.ScrollTaskbarTitel := CB_ScrollTitelTaskBar.Checked;
  NempPlayer.ScrollTaskbarDelay :=  (4 - CB_TaskbarDelay.ItemIndex + 1)* 5;
  if not NempPlayer.ScrollTaskbarTitel then
    Application.Title := NempPlayer.GenerateTaskbarTitel;
  // Safe playback
  NempPlayer.SafePlayback := cb_SafePlayback.Checked;
end;

procedure TOptionsCompleteForm.ApplyListViewSettings;
var
  i, colIdx: Integer;
begin
  // visible columns
  for i := 0 to cLibraryColumnCount - 1 do begin
    colIdx := Nemp_MainForm.VST.Header.Columns.ColumnFromPosition(i);
    if clbViewMainColumns.Checked[i] then
      Nemp_MainForm.VST.Header.Columns[colIdx].Options := Nemp_MainForm.VST.Header.Columns[colIdx].Options + [coVisible]
    else
      Nemp_MainForm.VST.Header.Columns[colIdx].Options := Nemp_MainForm.VST.Header.Columns[colIdx].Options - [coVisible];
  end;

  // missing metadata
  NempDisplay.ArtistSubstitute := TESubstituteValue(cbReplaceArtistBy.ItemIndex);
  NempDisplay.TitleSubstitute  := TESubstituteValue(cbReplaceTitleBy .ItemIndex);
  NempDisplay.AlbumSubstitute  := TESubstituteValue(cbReplaceAlbumBy .ItemIndex);
  // (default Cover is applied directly)
  // playlist formatting
  NempDisplay.PlaylistTitleFormat    := cbPlaylistTitle.Text         ;
  NempDisplay.PlaylistTitleFormatFB  := cbPlaylistTitleFB.Text       ;
  NempDisplay.PlaylistCueAlbumFormat := cbPlaylistTitleCueAlbum.Text ;
  NempDisplay.PlaylistCueTitleFormat := cbPlaylistTitleCueTitle.Text ;
  NempDisplay.PlaylistWebradioFormat := cbPlaylistWebradioTitle.Text ;
  NempPlaylist.ShowIndexInTreeview := cb_ShowIndexInTreeview.Checked;
  RefreshPlaylistVSTHeader;
  Nemp_MainForm.PlaylistVST.Invalidate;
  // Extended viewing settings
  MedienBib.AlwaysSortAnzeigeList := cbAlwaysSortAnzeigeList.Checked;
  MedienBib.SkipSortOnLargeLists := CBSkipSortOnLargeLists.Checked;
  MedienBib.limitMarkerToCurrentFiles := cb_limitMarkerToCurrentFiles.Checked;
  MedienBib.ShowHintsInMedialist := CBShowHintsInTitlelists.Checked;
  MedienBib.ShowAdvancedHints := CB_ShowAdvancedHints.Checked;
  // NempPlaylist.ShowHintsInPlaylist := CB_ShowHintsInPlaylist.Checked;
  NempOptions.FullRowSelect := cbFullRowSelect.Checked;
  Nemp_MainForm.VST.ShowHint := MedienBib.ShowHintsInMedialist;
  Nemp_MainForm.PlaylistVST.ShowHint := MedienBib.ShowHintsInMedialist;
  if NempOptions.FullRowSelect then
    Nemp_MainForm.VST.TreeOptions.SelectionOptions := Nemp_MainForm.VST.TreeOptions.SelectionOptions + [toFullRowSelect]
  else
    Nemp_MainForm.VST.TreeOptions.SelectionOptions := Nemp_MainForm.VST.TreeOptions.SelectionOptions - [toFullRowSelect];
end;

procedure TOptionsCompleteForm.ApplyFontsAndPartyMode;
var
  ReDrawVorauswahlTrees, ReDrawPlaylistTree, ReDrawMedienlistTree: Boolean;
  maxFont: Integer;
begin
    // Set new Values in NempOptions
  NempOptions.DefaultFontSize := SEFontSize.Value;
  NempOptions.RowHeight := SERowHeight.Value;
  NempOptions.DefaultFontStyle := cb_Medialist_FontStyle.ItemIndex ;
  NempOptions.DefaultFontStyles := FontSelectorItemIndexToStyle(NempOptions.DefaultFontStyle);
  NempOptions.ArtistAlbenFontSize := SEArtistAlbenSIze.Value;
  NempOptions.ArtistAlbenRowHeight := SEArtistAlbenRowHeight.Value;
  NempOptions.ArtistAlbenFontStyle := cb_Browselist_FontStyle.ItemIndex;
  NempOptions.ArtistAlbenFontStyles := FontSelectorItemIndexToStyle(NempOptions.ArtistAlbenFontStyle);
  NempOptions.ChangeFontColorOnBitrate := CBChangeFontColorOnBitrate.Checked;
  NempOptions.ChangeFontSizeOnLength := CBChangeFontSizeOnLength.Checked;
  NempOptions.ChangeFontStyleOnMode := CBChangeFontStyleOnMode.Checked;
  NempOptions.ChangeFontOnCbrVbr := CBChangeFontOnCbrVbr.Checked;
  NempOptions.FontNameCBR := CBFontNameCBR.Items[CBFontNameCBR.itemindex];
  NempOptions.FontNameVBR := CBFontNameVBR.Items[CBFontNameVBR.itemindex];
  // Set new Values to the actual Trees
  ReDrawVorauswahlTrees := Nemp_MainForm.ArtistsVST.DefaultNodeHeight <> Cardinal(NempOptions.ArtistAlbenRowHeight);
  ReDrawPlaylistTree := Nemp_MainForm.PlaylistVST.DefaultNodeHeight <> Cardinal(NempOptions.RowHeight);
  ReDrawMedienlistTree := Nemp_MainForm.VST.DefaultNodeHeight <> Cardinal(NempOptions.RowHeight);
  Nemp_MainForm.ArtistsVST.DefaultNodeHeight := NempOptions.ArtistAlbenRowHeight;
  Nemp_MainForm.AlbenVST.DefaultNodeHeight := NempOptions.ArtistAlbenRowHeight;
  Nemp_MainForm.ArtistsVST.Font.Size := NempOptions.ArtistAlbenFontSize;
  Nemp_MainForm.AlbenVST.Font.Size := NempOptions.ArtistAlbenFontSize;
  Nemp_MainForm.VST.DefaultNodeHeight := NempOptions.RowHeight;
  Nemp_MainForm.PlaylistVST.DefaultNodeHeight := NempOptions.RowHeight;
  Nemp_MainForm.VST.Font.Size := NempOptions.DefaultFontSize;
  Nemp_MainForm.PlaylistVST.Font.Size := NempOptions.DefaultFontSize;
  // adjust width of the Duration column in the PlaylistVST
  if NempOptions.ChangeFontSizeOnLength then
    maxFont := MaxFontSize(NempOptions.DefaultFontSize)
  else
    maxFont := NempOptions.DefaultFontSize;
  Nemp_MainForm.PlaylistVST.Canvas.Font.Size := maxFont;
  Nemp_MainForm.PlaylistVST.Header.Columns[2].Width := Nemp_MainForm.PlaylistVST.Canvas.TextWidth('@99:99hm');
  // Nemp_MainForm.PlaylistVSTResize(Nil);
  Nemp_MainForm.PlaylistVST.Invalidate;
  Nemp_MainForm.VST.Invalidate;
  Nemp_MainForm.ArtistsVST.Invalidate;
  Nemp_MainForm.AlbenVST.Invalidate;
  // Redraw Trees
  if ReDrawVorauswahlTrees then begin
    Nemp_MainForm.ReFillCategoryTree(True);
    Nemp_MainForm.FillCollectionTree(Nil ,True);
  end;
  if ReDrawMedienlistTree then
    FillTreeView(MedienBib.AnzeigeListe, Nil);
  if ReDrawPlaylistTree then begin
    Nemp_MainForm.PlaylistChangedCompletely(NempPlaylist);
    NempPlaylist.ReInitPlaylist;
  end;
  // Partymode settings
  Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor := Nemp_MainForm.NempSkin.NempPartyMode.IndexToFactor(CB_PartyMode_ResizeFactor.ItemIndex);
  Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit := cb_PartyMode_BlockTreeEdit.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating := cb_PartyMode_BlockCurrentTitleRating.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockTools := cb_PartyMode_BlockTools.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.ShowPasswordOnActivate := cb_PartyMode_ShowPasswordOnActivate.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.password := Edt_PartyModePassword.Text;
end;

procedure TOptionsCompleteForm.ApplyWebRadioSettings;
begin
  NempPlayer.DownloadDir := IncludeTrailingPathDelimiter(EdtDownloadDir.Text);
  NempPlayer.UseStreamnameAsDirectory := cbUseStreamnameAsDirectory.Checked;
  NempPlayer.FilenameFormat := cbFilenameFormat.Text;
  NempPlayer.AutoSplitByTitle := cbAutoSplitByTitle.Checked;
  NempPlayer.AutoSplitByTime := cbAutoSplitBySize.Checked;
  NempPlayer.AutoSplitBySize := cbAutoSplitByTime.Checked;
  NempPlayer.AutoSplitMaxSize := SE_AutoSplitMaxSize.Value;
  NempPlayer.AutoSplitMaxTime := SE_AutoSplitMaxTime.Value;
  NempPlaylist.BassHandlePlaylist := rbWebRadioHandledByBass.Checked;
end;

procedure TOptionsCompleteForm.ApplyEffectReplayGainSettings;
begin
  // ReplayGain
  NempPlayer.ApplyReplayGain  := cb_ApplyReplayGain.Checked;
  NempPlayer.PreferAlbumGain  := cb_PreferAlbumGain.Checked;
  NempPlayer.DefaultGainWithoutRG := tp_DefaultGain.Position / 10;
  NempPlayer.DefaultGainWithRG    := tp_DefaultGain2.Position / 10;
  NempPlayer.PreventClipping      := cb_ReplayGainPreventClipping.Checked;
  // Effects
  NempPlayer.UseDefaultEffects := CB_UseDefaultEffects.Checked;
  NempPlayer.UseDefaultEqualizer := CB_UseDefaultEqualizer.Checked;
  NempPlayer.UseWalkmanMode := cb_UseWalkmanMode.Checked;
  Nemp_MainForm.WalkmanModeTimer.Enabled := cb_UseWalkmanMode.Checked;
  if Not NempPlayer.UseWalkmanMode then
    StopFluttering;
  // Jingles, Push-To-Talk
  NempPlayer.ReduceMainVolumeOnJingle := CBJingleReduce.Checked;
  NempPlayer.ReduceMainVolumeOnJingleValue := SEJingleReduce.Value;
  NempPlayer.JingleVolume := SEJingleVolume.Value;
end;

procedure TOptionsCompleteForm.ApplyBirthdaySettings;
begin
  // Happy-Birthday-Timer
  NempPlayer.NempBirthdayTimer.CountDownFileName := EditCountdownSong.Text;
  NempPlayer.NempBirthdayTimer.BirthdaySongFilename := EditBirthdaySong.Text;
  if not ValidTime(mskEdt_BirthdayTime.Text) then
    mskEdt_BirthdayTime.Text := '00:00';
  NempPlayer.NempBirthdayTimer.StartTime := StrToTime(mskEdt_BirthdayTime.Text);
  NempPlayer.NempBirthdayTimer.UseCountDown := CBStartCountDown.Checked AND (Trim(EditCountdownSong.Text) <> '');
  if NempPlayer.NempBirthdayTimer.UseCountDown then
    NempPlayer.NempBirthdayTimer.StartCountDownTime := IncSecond(NempPlayer.NempBirthdayTimer.StartTime, - NempPlayer.GetCountDownLength(NempPlayer.NempBirthdayTimer.CountDownFileName))
  else
    NempPlayer.NempBirthdayTimer.StartCountDownTime := NempPlayer.NempBirthdayTimer.StartTime;
  NempPlayer.NempBirthdayTimer.ContinueAfter := CBContinueAfter.Checked;
end;

procedure TOptionsCompleteForm.ApplyLastFMSettings;
begin
  NempPlayer.NempScrobbler.IgnoreErrors := CB_SilentError.Checked;
  NempPlayer.NempScrobbler.AlwaysScrobble := CB_AlwaysScrobble.Checked;
  // if scrobble-now-setting has changed:
  if NempPlayer.NempScrobbler.DoScrobble <> CB_ScrobbleThisSession.Checked then begin
    NempPlayer.NempScrobbler.DoScrobble := CB_ScrobbleThisSession.Checked;
    // refresh caption
    if NempPlayer.NempScrobbler.DoScrobble then begin
      if NempPlayer.NempScrobbler.Working then
        cpScrobbleLog.Caption := Scrobble_Active
      else
        cpScrobbleLog.Caption := Scrobble_InActive;
    end else
      cpScrobbleLog.Caption := Scrobble_Offline;
    // notify Scrobbler
    if assigned(NempPlayer.MainAudioFile)
      and (NempPlayer.MainAudioFile.IsFile )
      and (NempPlayer.Status = PLAYER_ISPLAYING)
    then begin
      NempPlayer.NempScrobbler.ChangeCurrentPlayingFile(NempPlayer.MainAudioFile);
      NempPlayer.NempScrobbler.PlaybackStarted;
    end;
  end;
end;

procedure TOptionsCompleteForm.ApplyWebServerSettings;
begin
  // Webserver
  NempWebServer.UsernameU := EdtUsername.Text;
  NempWebServer.PasswordU := EdtPassword.Text;
  NempWebServer.UsernameA := EdtUsernameAdmin.Text;
  NempWebServer.PasswordA := EdtPasswordAdmin.Text;
  NempWebServer.Theme := cbWebServerRootDir.Text;

  if (NempWebServer.Port <> seWebServer_Port.Value) and (NempWebServer.Active) then
    MessageDLG((WebServer_PortChangeFailed), mtInformation, [MBOK], 0);

  NempWebServer.Port := seWebServer_Port.Value;
  NempWebServer.AllowLibraryAccess    := cbPermitLibraryAccess.Checked;
  NempWebServer.AllowFileDownload     := cbPermitPlaylistDownload.Checked;
  NempWebServer.AllowHtmlAudio        := cbPermitHtmlAudio.Checked;
  NempWebServer.AllowRemoteControl    := cbAllowRemoteControl.Checked;
  MedienBib.AutoActivateWebServer     := CBAutoStartWebServer.Checked;
  NempWebServer.AllowVotes            := cbPermitVote.Checked;
  NempWebServer.SaveSettings;
end;

procedure TOptionsCompleteForm.ApplyPlaylistSettings;
begin
  // default actions
  NempPlaylist.DefaultAction := GrpBox_DefaultAction.ItemIndex;
  NempPlaylist.ApplyDefaultActionToWholeList := cbApplyDefaultActionToWholeList.Checked;
  NempPlaylist.UseDefaultActionOnCoverFlowDoubleClick := cbUseDefaultActionOnCoverFlowDoubleClick.Checked;
  NempPlaylist.HeadSetAction := GrpBox_HeadsetDefaultAction.ItemIndex;
  NempPlaylist.AutoStopHeadsetSwitchTab := cb_AutoStopHeadsetSwitchTab.Checked;
  NempPlaylist.AutoStopHeadsetAddToPlayist := cb_AutoStopHeadsetAddToPlayist.Checked;
  // General playlist settings
  NempPlaylist.AutoScan := CB_AutoScanPlaylist.checked;
  NempPlaylist.JumpToNextCueOnNextClick := CB_JumpToNextCue.Checked;
  NempPlaylist.RepeatCueOnRepeatTitle := cb_ReplayCue.Checked;
  NempPlaylist.RememberInterruptedPlayPosition := CB_RememberInterruptedPlayPosition.Checked;
  NempPlaylist.AutoDelete := CB_AutoDeleteFromPlaylist.Checked;
  NempPlaylist.DisableAutoDeleteAtUserInput := CB_DisableAutoDeleteAtUserInput.Checked;
  NempPlaylist.AutoMix := CB_AutoMixPlaylist.Checked;
  // Auto-save favorite Playlists
  NempPlaylist.PlaylistManager.AutoSaveOnPlaylistChange := cb_PlaylistManagerAutoSave.Checked;
  NempPlaylist.PlaylistManager.UserInputOnPlaylistChange := cb_PlaylistManagerAutoSaveUserInput.Checked;
  // Random playback
  NempPlaylist.RandomRepeat := TBRandomRepeat.Position;
  NempPlaylist.UseWeightedRNG := cb_UseWeightedRNG.Checked;
  NempPlaylist.RNGWeights[1]  := StrToIntDef(RandomWeight05.Text, 1);
  NempPlaylist.RNGWeights[2]  := StrToIntDef(RandomWeight10.Text, 1);
  NempPlaylist.RNGWeights[3]  := StrToIntDef(RandomWeight15.Text, 1);
  NempPlaylist.RNGWeights[4]  := StrToIntDef(RandomWeight20.Text, 1);
  NempPlaylist.RNGWeights[5]  := StrToIntDef(RandomWeight25.Text, 1);
  NempPlaylist.RNGWeights[6]  := StrToIntDef(RandomWeight30.Text, 1);
  NempPlaylist.RNGWeights[7]  := StrToIntDef(RandomWeight35.Text, 1);
  NempPlaylist.RNGWeights[8]  := StrToIntDef(RandomWeight40.Text, 1);
  NempPlaylist.RNGWeights[9]  := StrToIntDef(RandomWeight45.Text, 1);
  NempPlaylist.RNGWeights[10] := StrToIntDef(RandomWeight50.Text, 1);
  // flag the playlist to re-initiate the fWeightedRandomIndices
  if NempPlaylist.UseWeightedRNG then
    NempPlaylist.PlaylistHasChanged := True;
  // Playlist log
  NempPlayer.NempLogFile.DoLogToFile := cbSaveLogToFile.Checked ;
  NempPlayer.NempLogFile.KeepLogRangeInDays  := seLogDuration.Value;
end;

procedure TOptionsCompleteForm.ApplyFileSearchSettings;
var
  i: Integer;
begin
  // Directories mointored by Nemp
  MedienBib.AutoScanDirs := CBAutoScan.Checked;
  MedienBib.AutoScanDirList.Clear;
  for i := 0 to LBAutoScan.Items.Count - 1 do
    MedienBib.AutoScanDirList.Add(LBAutoScan.Items[i]);
  MedienBib.AskForAutoAddNewDirs := CBAskForAutoAddNewDirs.Checked;
  MedienBib.AutoAddNewDirs := CBAutoAddNewDirs.Checked;
  MedienBib.AutoDeleteFiles := cb_AutoDeleteFiles.checked;
  MedienBib.AutoDeleteFilesShowInfo := cb_AutoDeleteFilesShowInfo.checked;
  MedienBib.AutoScanPlaylistFilesOnView := CBAutoScanPlaylistFilesOnView.Checked;
  // file types that should be added to the media library
  MedienBib.IncludeAll := cbIncludeAll.Checked;
  if not MedienBib.IncludeAll then begin
    MedienBib.IncludeFilter := '';
    for i := 0 to CBIncludeFiles.Count - 1 do begin
      if CBIncludeFiles.Checked[i] then
        MedienBib.IncludeFilter := MedienBib.IncludeFilter + ';*' + CBIncludeFiles.Items[i];
    end;
    // delete first ';'
    if (MedienBib.IncludeFilter <> '') AND (MedienBib.IncludeFilter[1] = ';') then
      MedienBib.IncludeFilter := copy(MedienBib.IncludeFilter, 2, length(MedienBib.IncludeFilter));
    if MedienBib.IncludeFilter = '' then
      MedienBib.IncludeFilter := '*.mp3'
  end;
  // cover art search settings
  TCoverArtSearcher.UseDir       := CB_CoverSearch_inDir.Checked;
  TCoverArtSearcher.UseParentDir := CB_CoverSearch_inParentDir.Checked;
  TCoverArtSearcher.UseSubDir    := CB_CoverSearch_inSubDir.Checked;
  TCoverArtSearcher.UseSisterDir := CB_CoverSearch_inSisterDir.Checked;
  TCoverArtSearcher.SubDirName := EDTCoverSubDirName.Text ;
  TCoverArtSearcher.SisterDirName := EDTCoverSisterDirName.Text;
  TCoverArtSearcher.CoverSizeIndex := cb_CoverSize.ItemIndex;
  TCoverArtSearcher.InitCoverArtCache(Savepath, TCoverArtSearcher.CoverSizeIndex);
  // clear coverflow, if setting is changed
  if MedienBib.CoverSearchLastFM <> CB_CoverSearch_LastFM.Checked then begin
    MedienBib.CoverSearchLastFM := CB_CoverSearch_LastFM.Checked;
    MedienBib.NewCoverFlow.ClearTextures;
  end;
end;

procedure TOptionsCompleteForm.ApplyMetadataSettings;
begin
  NempOptions.AllowQuickAccessToMetadata := cb_AccessMetadata.checked;
  // Automatic rating
  NempPlayer.PostProcessor.Active := cb_RatingActive.checked;
  NempPlayer.PostProcessor.IgnoreShortFiles := cb_RatingIgnoreShortFiles.checked;
  NempPlayer.PostProcessor.WriteToFiles := cb_AccessMetadata.checked;
  NempPlayer.PostProcessor.ChangeCounter := cb_RatingChangeCounter.checked;
  NempPlayer.PostProcessor.IncPlayedFiles := cb_RatingIncreaseRating.checked;
  NempPlayer.PostProcessor.DecAbortedFiles := cb_RatingDecreaseRating.checked;
  // Extended tags
  MedienBib.AutoResolveInconsistencies := cb_AutoResolveInconsistencies.checked;
  MedienBib.AskForAutoResolveInconsistencies := cb_AskForAutoResolveInconsistencies.checked;
  MedienBib.ShowAutoResolveInconsistenciesHints := cb_ShowAutoResolveInconsistenciesHints.checked;
  // Heuristics for charcode detections
  NempCharCodeOptions.AutoDetectCodePage := CBAutoDetectCharCode.Checked;
  // CDDB-Settings
  NempOptions.AutoScanNewCDs := cbAutoCheckNewCDs.Checked;
  NempOptions.UseCDDB := cbUseCDDB.Checked;
  NempOptions.PreferCDDB := cbPreferCDDB.checked;
  NempOptions.CDDBServer := trim(edtCDDBServer.Text);
  NempOptions.CDDBEMail := trim(edtCDDBEMail.Text);
  BASS_ApplyCDDBSettings(NempOptions.CDDBServer, NempOptions.CDDBEMail);
end;

function TOptionsCompleteForm.ApplySearchSettings: Boolean;
var
  NeedTotalStringUpdate, NeedTotalLyricStringUpdate: boolean;
begin
  NeedTotalLyricStringUpdate := (MedienBib.BibSearcher.AccelerateLyricSearch <> CB_AccelerateLyricSearch.Checked)
                          or ((cb_IgnoreLyrics.Checked) and (not MedienBib.IgnoreLyrics));
  NeedTotalStringUpdate := (MedienBib.BibSearcher.AccelerateSearch <> CB_AccelerateSearch.Checked)
                          or (MedienBib.BibSearcher.AccelerateSearchIncludePath <> CB_AccelerateSearchIncludePath.Checked)
                          or (MedienBib.BibSearcher.AccelerateSearchIncludeComment <> CB_AccelerateSearchIncludeComment.Checked)
                          or (MedienBib.BibSearcher.AccelerateSearchIncludeGenre <> CB_AccelerateSearchIncludeGenre.Checked)
                          or (MedienBib.BibSearcher.AccelerateSearchIncludeAlbumArtist <> CB_AccelerateSearchIncludeAlbumArtist.Checked)
                          or (MedienBib.BibSearcher.AccelerateSearchIncludeComposer <> CB_AccelerateSearchIncludeComposer.Checked);
  result := (MedienBib.StatusBibUpdate = 0) or ((not NeedTotalLyricStringUpdate) and (not NeedTotalStringUpdate));

  if (MedienBib.StatusBibUpdate <> 0) then
    exit;

  // Library is NOT busy, making changes is safe
  MedienBib.BibSearcher.QuickSearchOptions.WhileYouType := CB_QuickSearchWhileYouType.Checked;
  MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow := cb_ChangeCoverflowOnSearch.Checked;
  MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter := CB_QuickSearchAllowErrorsOnEnter.Checked;
  MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType := CB_QuickSearchAllowErrorsWhileTyping.Checked;

  MedienBib.IgnoreLyrics := cb_IgnoreLyrics.Checked;
  if MedienBib.IgnoreLyrics then begin
    MedienBib.RemoveAllLyrics;
    CB_AccelerateLyricSearch.Checked := False;
    MedienBib.Changed := True;
  end;

  MedienBib.BibSearcher.AccelerateSearch := CB_AccelerateSearch .Checked;
  MedienBib.BibSearcher.AccelerateSearchIncludePath := CB_AccelerateSearchIncludePath.Checked;
  MedienBib.BibSearcher.AccelerateSearchIncludeComment := CB_AccelerateSearchIncludeComment.Checked;
  MedienBib.BibSearcher.AccelerateSearchIncludeGenre := CB_AccelerateSearchIncludeGenre.Checked;
  MedienBib.BibSearcher.AccelerateSearchIncludeAlbumArtist := CB_AccelerateSearchIncludeAlbumArtist.Checked;
  MedienBib.BibSearcher.AccelerateSearchIncludeComposer := CB_AccelerateSearchIncludeComposer.Checked;

  MedienBib.BibSearcher.AccelerateLyricSearch := CB_AccelerateLyricSearch.Checked;

  // update the quicksearch strings
  if NeedTotalLyricStringUpdate then Medienbib.BuildTotalLyricString;
  if NeedTotalStringUpdate then MedienBib.BuildTotalString;
end;



procedure TOptionsCompleteForm.EnableBirthdayControls;
begin
  lblCountDownTitel.Enabled := CBStartCountDown.Checked;
  EditCountdownSong.Enabled := CBStartCountDown.Checked;
  BtnCountDownSong.Enabled := CBStartCountDown.Checked;
  BtnGetCountDownTitel.Enabled := CBStartCountDown.Checked;
  LBlCountDownWarning.Enabled := CBStartCountDown.Checked;
end;

procedure TOptionsCompleteForm.CBStartCountDownClick(Sender: TObject);
begin
  EnableBirthdayControls;
end;

procedure TOptionsCompleteForm.Btn_ReinitPlayerEngineClick(Sender: TObject);
begin
//  showmessage('vorher: ' + IntToStr(CBFileTypes.Count) + ', ' + IntToStr(NempPlayer.ValidExtensions.Count) );
  NempPlaylist.RepairBassEngine(True);
//  showmessage('nachher: ' + IntToStr(CBFileTypes.Count) + ', ' + IntToStr(NempPlayer.ValidExtensions.Count) );
end;

procedure TOptionsCompleteForm.EditCountdownSongChange(Sender: TObject);
begin
  LBlCountDownWarning.Visible := NOT FileExists(EditCountdownSong.Text);
end;

procedure TOptionsCompleteForm.edtCDDBEMailExit(Sender: TObject);
begin
  lblInvalidCDDBMail.Visible := not ValidEmail(trim(edtCDDBEMail.Text));
end;

procedure TOptionsCompleteForm.EditBirthdaySongChange(Sender: TObject);
begin
  LblEventWarning.Visible := Not FileExists(EditBirthdaySong.Text);
end;

procedure TOptionsCompleteForm.EnableListViewControls;
begin
  CBSkipSortOnLargeLists.Enabled := CBAlwaysSortAnzeigeList.Checked;
  CB_ShowAdvancedHints.Enabled := CBShowHintsInTitlelists.Checked;
end;

procedure TOptionsCompleteForm.CBAlwaysSortAnzeigeListClick(Sender: TObject);
begin
  EnableListViewControls;
end;

procedure TOptionsCompleteForm.EnableDirectoryScanControls;
begin
    LBAutoScan.Enabled := CBAutoScan.Checked;
    BtnAutoScanDelete.Enabled := CBAutoScan.Checked;
    BtnAutoScanAdd.Enabled := CBAutoScan.Checked;
    cb_AutoDeleteFilesShowInfo.Enabled := cb_AutoDeleteFiles.Checked;
    BtnAutoScanNow.Enabled := cb_AutoDeleteFiles.Checked or CBAutoScan.Checked;
end;

procedure TOptionsCompleteForm.CBAutoScanClick(Sender: TObject);
begin
  EnableDirectoryScanControls;
end;

procedure TOptionsCompleteForm.BtnAutoScanAddClick(Sender: TObject);
var tmp: UnicodeString;
    i: Integer;
    OpenDlg: TFileOpenDialog;
begin
  if MedienBib.InitialDialogFolder = '' then
      MedienBib.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);

  OpenDlg := TFileOpenDialog.Create(self);
  try
    OpenDlg.Options := OpenDlg.Options + [fdoPickFolders];
    OpenDlg.DefaultFolder := MedienBib.InitialDialogFolder;

    if OpenDlg.Execute then begin
      // save selected dir for next call of this dialog
      MedienBib.InitialDialogFolder := OpenDlg.FileName;

      // Parentdir schon drin? - Nicht einfügen
      if MedienBib.ScanListContainsParentDir(OpenDlg.FileName) <> '' then
        MessageDLG((AutoScanDir_AlreadyExists), mtInformation, [MBOK], 0)
      else begin
        // parentdir noch nicht drin.
        // Überprüfen auf SubDirs:
        tmp := MedienBib.ScanListContainsSubDirs(OpenDlg.FileName);
        if  tmp <> '' then
          MessageDLG((AutoSacnDir_SubDirExisted) + #13#10 + tmp, mtInformation, [MBOK], 0);

        MedienBib.AutoScanDirList.Add(IncludeTrailingPathDelimiter(OpenDlg.FileName));
        LBAutoScan.Items.Clear;
        for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
          LBAutoScan.Items.Add(MedienBib.AutoScanDirList[i]);
      end;
    end;
  finally
    OpenDlg.Free;
  end;
end;

procedure TOptionsCompleteForm.BtnAutoScanDeleteClick(Sender: TObject);
var i: Integer;
begin
  LBAutoScan.DeleteSelected;
  MedienBib.AutoScanDirList.Clear;
  for i := 0 to LBAutoScan.Count - 1 do
    MedienBib.AutoScanDirList.Add(LBAutoScan.Items[i]);
end;

procedure TOptionsCompleteForm.BtnAutoScanNowClick(Sender: TObject);
var i: Integer;
begin
    if (MedienBib.StatusBibUpdate = 0) then
    begin

        if CBAutoScan.Checked then
        begin
            // refill scandirectories
            MedienBib.AutoScanToDoList.clear;
            for i := 0 to MedienBib.AutoScanDirList.count - 1 do
                MedienBib.AutoScanToDoList.Add(MedienBib.AutoScanDirList[i]);
            // add the scanJob to the ToDo-List
            Medienbib.AddStartJob(JOB_AutoScanNewFiles, '');
        end;

        if cb_AutoDeleteFiles.checked then
            Medienbib.AddStartJob(JOB_AutoScanMissingFiles, '');
        MedienBib.AddStartJob(JOB_Finish, '');
        // start working
        MedienBib.ProcessNextStartJob;
    end else
        MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
end;


procedure TOptionsCompleteForm.LBAutoscanKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE: BtnAutoScanDeleteClick(nil);
  end;
end;


procedure TOptionsCompleteForm.RefreshQRCode(aURL: String);
var QR: TRedeemerQR;
    QRBitmap: TBitmap;
begin
    QR := TRedeemerQR.Create();
    try
        QR.LoadFromString(AnsiString(aURL), ecHigh);
        QRBitmap := TBitmap.Create;
        try
            QRBitmap.Width := QR.Width + 2;
            QRBitmap.Height := QR.Height + 2;
            QRBitmap.Canvas.Draw(1,1, QR);
            imgQRCode.Picture.Assign(QRBitmap);
        finally
            QRBitmap.Free;
        end;
    finally
        QR.Free();
    end;
end;

procedure TOptionsCompleteForm.ChangeWebserverLinks(Sender: TObject);
var newUrl, QRURL: String;
begin
    if cbLanIPs.Items.Count > 0 then
    begin
        newUrl := 'http://' + cbLanIPs.Items[cbLanIPs.ItemIndex];
        if seWebServer_Port.Value <> 80 then
            newUrl := newUrl + ':' + IntToStr(seWebServer_Port.Value);
    end else
    begin
        // use localhost
        if seWebServer_Port.Value = 80 then
            newUrl := 'http://localhost'
        else
            newUrl := 'http://localhost:'  + IntToStr(seWebServer_Port.Value)
    end;

    LblWebserverUserURL.Caption  := newURL;
    LblWebserverAdminURL.Caption := newURL + '/admin';

    if cbWebserverInternetQRCode.Checked then begin
      QRURL := 'http://' + EdtGlobalIP.Text;
      if seWebServer_Port.Value <> 80 then
        QRURL := QRURL + ':' + IntToStr(seWebServer_Port.Value);
    end else
      QRURL := newURL;

    if cbWebserverAdminQRCode.Checked then
      QRURL := QRURL + '/admin';

    lblCurrentQRCodeURL.Caption := Format(WebServer_CurrentURLInQRCode, [QRURL]);
    RefreshQRCode(QRURL);
end;


procedure TOptionsCompleteForm.clbViewMainColumnsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Flags: Longint;
begin
  with (Control as TCustomListBox) do
  begin
    Canvas.FillRect(Rect);
    // modifying the Canvas.Font.Color here will adjust the item font color

    if enabled then
      Canvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
    else
      Canvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clGrayText);

    Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
    if not UseRightToLeftAlignment then
      Inc(Rect.Left, 2)
    else
      Dec(Rect.Right, 2);
    DrawText(Canvas.Handle, Items[Index], Length(Items[Index]), Rect, Flags);
  end;
end;

procedure TOptionsCompleteForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  // Params.WndParent := Application.Handle;
end;

procedure TOptionsCompleteForm.LblWebserverUserURLClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(LblWebserverUserURL.Caption), nil, nil, SW_SHOW);
end;

procedure TOptionsCompleteForm.LblWebserverAdminURLClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(LblWebserverAdminURL.Caption), nil, nil, SW_SHOW);
end;

procedure TOptionsCompleteForm.EnableHotKeyControls;
var
  doRegisterChecked: Boolean;
begin
  doRegisterChecked := CBRegisterHotKeys.Checked;
  // Main CheckBoxes for each HotKey
  LockWindowUpdate(cpHotkeys.Handle);
  CB_Activate_Play.Enabled := doRegisterChecked;
  CB_Activate_Stop.Enabled := doRegisterChecked;
  CB_Activate_Next.Enabled := doRegisterChecked;
  CB_Activate_Prev.Enabled := doRegisterChecked;
  CB_Activate_JumpForward.Enabled := doRegisterChecked;
  CB_Activate_JumpBack.Enabled := doRegisterChecked;
  CB_Activate_IncVol.Enabled := doRegisterChecked;
  CB_Activate_DecVol.Enabled := doRegisterChecked;
  CB_Activate_Mute.Enabled := doRegisterChecked;
  // ComboBoxes for the individual Controls
  CB_MOD_Play.Enabled := CB_Activate_Play.Checked AND doRegisterChecked;
  CB_Key_Play.Enabled := CB_Activate_Play.Checked AND doRegisterChecked;
  CB_MOD_Stop.Enabled := CB_Activate_Stop.Checked AND doRegisterChecked;
  CB_Key_Stop.Enabled := CB_Activate_Stop.Checked AND doRegisterChecked;
  CB_MOD_Next.Enabled := CB_Activate_Next.Checked AND doRegisterChecked;
  CB_Key_Next.Enabled := CB_Activate_Next.Checked AND doRegisterChecked;
  CB_MOD_Prev.Enabled := CB_Activate_Prev.Checked AND doRegisterChecked;
  CB_Key_Prev.Enabled := CB_Activate_Prev.Checked AND doRegisterChecked;
  CB_MOD_JumpForward.Enabled := CB_Activate_JumpForward.Checked AND doRegisterChecked;
  CB_Key_JumpForward.Enabled := CB_Activate_JumpForward.Checked AND doRegisterChecked;
  CB_MOD_JumpBack.Enabled := CB_Activate_JumpBack.Checked AND doRegisterChecked;
  CB_Key_JumpBack.Enabled := CB_Activate_JumpBack.Checked AND doRegisterChecked;
  CB_MOD_IncVol.Enabled := CB_Activate_IncVol.Checked AND doRegisterChecked;
  CB_Key_IncVol.Enabled := CB_Activate_IncVol.Checked AND doRegisterChecked;
  CB_MOD_DecVol.Enabled := CB_Activate_DecVol.Checked AND doRegisterChecked;
  CB_Key_DecVol.Enabled := CB_Activate_DecVol.Checked AND doRegisterChecked;
  CB_MOD_Mute.Enabled := CB_Activate_Mute.Checked AND doRegisterChecked;
  CB_Key_Mute.Enabled := CB_Activate_Mute.Checked AND doRegisterChecked;
  LockWindowUpdate(0);
end;


procedure TOptionsCompleteForm.CBRegisterHotKeysClick(Sender: TObject);
begin
  EnableHotKeyControls;
end;


procedure TOptionsCompleteForm.cbFilenameFormatChange(Sender: TObject);
begin
  if IsValidFilenameFormat(cbFilenameFormat.Text) then
    cbFilenameFormat.Font.Color := clWindowText
  else
    cbFilenameFormat.Font.Color := clRed;
end;

procedure TOptionsCompleteForm.BtnChooseDownloadDirClick(Sender: TObject);
var
  adir: UnicodeString;
  OpenDlg: TFileOpenDialog;
begin
  aDir := NempPlayer.DownloadDir;

  // try to create the directory, if it not exist already
  // --- this behaviour should be OK.
  //     The default directory is savePath + \webradio, so it's in the same directory as "Cover\",
  //     which is created automatically anyway.
  if NOT DirectoryExists(ExtractFilePath(aDir)) then
  try
    ForceDirectories(aDir);
  except
    TranslateMessageDLG((Warning_RecordingDirNotFoundCreationFailed), mtWarning, [mbOk], 0);
  end;

  OpenDlg := TFileOpenDialog.Create(self);
  try
    OpenDlg.Options := OpenDlg.Options + [fdoPickFolders];
    OpenDlg.DefaultFolder := NempPlayer.DownloadDir;
    if OpenDlg.Execute then
      EdtDownloadDir.Text := IncludeTrailingPathDelimiter(OpenDlg.FileName);
  finally
    OpenDlg.Free;
  end;
end;

procedure TOptionsCompleteForm.btnClearCDDBCacheClick(Sender: TObject);
begin
  ClearAllLocalCDDBData;
end;

procedure TOptionsCompleteForm.BtnClearCoverCacheClick(Sender: TObject);
begin
  CoverDownloadThread.ClearCacheList;
  MedienBib.NewCoverFlow.ClearTextures;
end;

procedure TOptionsCompleteForm.EnableSearchControls;
begin
  CB_AccelerateSearchIncludePath.Enabled    := CB_AccelerateSearch.Checked;
  CB_AccelerateSearchIncludeComment.Enabled := CB_AccelerateSearch.Checked;
  CB_AccelerateSearchIncludeGenre.Enabled   := CB_AccelerateSearch.Checked;
  CB_AccelerateSearchIncludeAlbumArtist.Enabled := CB_AccelerateSearch.Checked;
  CB_AccelerateSearchIncludeComposer.Enabled := CB_AccelerateSearch.Checked;
end;

procedure TOptionsCompleteForm.CB_AccelerateSearchClick(Sender: TObject);
begin
  EnableSearchControls;
end;


procedure TOptionsCompleteForm.CB_AutoCheckClick(Sender: TObject);
begin
    CBBOX_UpdateInterval.Enabled := CB_AutoCheck.Checked;
end;



procedure TOptionsCompleteForm.Btn_CHeckNowForUpdatesClick(
  Sender: TObject);
begin
    NempUpdater.CheckForUpdatesManually;
end;

procedure TOptionsCompleteForm.btn_DefaultCoverClick(Sender: TObject);
var fs: TFileStream;
begin
    if OpenDlg_DefaultCover.Execute then
    begin
        fs := TFileStream.Create(OpenDlg_DefaultCover.FileName, fmOpenRead);
        try
            if TCoverArtSearcher.ScalePicStreamToFile_AllSizes(fs, '_default_cover', Nil, True) then
                LoadDefaultCover
            else
                MessageDLG((OptionsForm_DefaultCoverChangeFailed), mtWarning, [MBOK], 0);
        finally
            fs.Free;
        end;
    end;
end;

procedure TOptionsCompleteForm.btn_DefaultCoverResetClick(Sender: TObject);
var FileName: UnicodeString;
    fs: TFileStream;
begin
    FileName := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.jpg';
    if not FileExists(FileName) then
        FileName := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.png';

    if Not FileExists(FileName) then
        MessageDLG((OptionsForm_DefaultCoverResetFailed), mtWarning, [MBOK], 0)
    else
    begin
        fs := TFileStream.Create(FileName, fmOpenRead);
        try
            if TCoverArtSearcher.ScalePicStreamToFile_AllSizes(fs, '_default_cover', Nil, True) then
                LoadDefaultCover
            else
                MessageDLG((OptionsForm_DefaultCoverChangeFailed), mtWarning, [MBOK], 0);

        finally
            fs.Free;
        end;
    end;
end;

procedure TOptionsCompleteForm.LoadDefaultCover;
begin
  img_DefaultCover.Picture.Bitmap.Width := img_DefaultCover.Width;
  img_DefaultCover.Picture.Bitmap.Height := img_DefaultCover.Height;
  TCoverArtSearcher.GetDefaultCover(dcFile, img_DefaultCover.Picture, 0);
  img_DefaultCover.Refresh;
end;

procedure TOptionsCompleteForm.cbAutoSplitBySizeClick(Sender: TObject);
begin
  SE_AutoSplitMaxSize.Enabled := cbAutoSplitBySize.Checked;
  LblConst_MaxSize.Enabled    := cbAutoSplitBySize.Checked;
end;

procedure TOptionsCompleteForm.cbAutoSplitByTimeClick(Sender: TObject);
begin
  SE_AutoSplitMaxTime.Enabled := cbAutoSplitByTime.Checked;
  LblConst_MaxTime.Enabled   := cbAutoSplitByTime.Checked;
end;

Procedure TOptionsCompleteForm.SetScrobbleButtonOnError;
begin
    LblScrobble1.Caption := ScrobbleWizardError;
    BtnScrobbleWizard.Caption := 'Ok';
    BtnScrobbleWizard.Tag := 100;
    BtnScrobbleWizard.Enabled := True;
end;


procedure TOptionsCompleteForm.ResetScrobbleButton;
begin
    //Setzt Label, Button etc. auf Start, je nach NempScrobbler-Status.
    If (NempPlayer.NempScrobbler.Username = '') or (NempPlayer.NempScrobbler.SessionKey = '') then
    begin
        // Der Scrobbler wurde noch nicht initialisiert.
        LblScrobble1.Caption := ScrobbleWizardIntro;
        BtnScrobbleWizard.Caption := 'Start';
    end else
    begin
        LblScrobble1.Caption := ScrobbleWizardIntroRestart;
        BtnScrobbleWizard.Caption := 'Restart';
    end;
    BtnScrobbleWizard.Tag := 0;
    BtnScrobbleWizard.Enabled := True;
end;


procedure TOptionsCompleteForm.BtnScrobbleWizardClick(Sender: TObject);
var aScrobbler: TScrobbler;
    authUrl: AnsiString;
begin
    case (Sender as TButton).Tag of
        0: begin
            LblScrobble1.Caption := ScrobbleWizardGetToken;
            BtnScrobbleWizard.Tag := 1;
            BtnScrobbleWizard.Caption := 'Next';
        end;

        1: begin
            // Nur einmal drücken erlauben
            BtnScrobbleWizard.Enabled := False;
            BtnScrobbleWizard.Caption := 'Please Wait';
            // Token holen
            NempPlayer.NempScrobbler.JobStarts;
            aScrobbler := TScrobbler.Create(Handle);
            aScrobbler.Parent := NempPlayer.NempScrobbler;
            aScrobbler.GetToken;
            // Auf Message warten -> Dann enablen und Tag auf 2 setzen
        end;

        2: begin
            // Token ist da. Browser öffnen
            authUrl := 'https://www.last.fm/api/auth/?api_key=' + NempPlayer.NempScrobbler.ApiKey + '&token=' + NempPlayer.NempScrobbler.Token;
            ShellExecuteA(Handle, 'open', PAnsiChar(authUrl), nil, nil, SW_SHOW);
            // User muss im Browser arbeiten
            LblScrobble1.Caption := ScrobbleWizardYesIDid;
            // Hier arbeitet kein Thread. ;-)
            BtnScrobbleWizard.Enabled := True;
            BtnScrobbleWizard.Caption := 'Next';
            BtnScrobbleWizard.Tag := 3;
        end;

        3: begin
            LblScrobble1.Caption := ScrobbleWizardGetSessionKey;
            BtnScrobbleWizard.Enabled := True;
            BtnScrobbleWizard.Caption := 'Next';
            BtnScrobbleWizard.Tag := 4;
        end;
        4: begin
            // Nur einmal drücken erlauben
            BtnScrobbleWizard.Enabled := False;
            BtnScrobbleWizard.Caption := 'Please Wait';
            NempPlayer.NempScrobbler.JobStarts;
            aScrobbler := TScrobbler.Create(Handle);
            aScrobbler.Parent := NempPlayer.NempScrobbler;
            aScrobbler.Token := NempPlayer.NempScrobbler.Token;
            aScrobbler.GetSession;
            // Auf Message warten
        end;
        5: begin
            ResetScrobbleButton;
            // activate scrobbling now automatically
            // (this seems to make sense to me here)
            CB_ScrobbleThisSession.Checked := True;
        end;

        100: begin
            ResetScrobbleButton;
        end;
    end;
end;



procedure TOptionsCompleteForm.Btn_ScrobbleAgainClick(Sender: TObject);
begin
    NempPlayer.NempScrobbler.ProblemSolved;
    NempPlayer.NempScrobbler.DoScrobble := True;
    CB_ScrobbleThisSession.Checked := True;

    NempPlayer.NempScrobbler.ScrobbleAgain(NempPlayer.Status = PLAYER_ISPLAYING);
end;

Procedure TOptionsCompleteForm.ScrobblerMessage(Var aMsg: TMessage);
var ini: TMemIniFile;
    solved: Boolean;
begin
    Case aMsg.WParam of

        SC_Message,
        SC_Hint,
        SC_Error: begin
                MemoScrobbleLog.Lines.Add(PChar(aMsg.LParam));
                NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
        end;

        SC_BeginWork: cpScrobbleLog.Caption := Scrobble_Active;
        SC_EndWork: cpScrobbleLog.Caption := Scrobble_InActive;
        SC_JobIsDone: NempPlayer.NempScrobbler.JobDone;

        SC_GetAuthException: begin
            // LParam: ErrorMessage
            MemoScrobbleLog.Lines.Add(PChar(aMsg.LParam));
            NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
            SetScrobbleButtonOnError;
        end;
        SC_InvalidToken: SetScrobbleButtonOnError;

        SC_GetToken: begin
            //fToken aus Antwort bestimmen
            NempPlayer.NempScrobbler.Token := PAnsiChar(aMsg.LParam);
            if NempPlayer.NempScrobbler.Token <> '' then
            begin
                MemoScrobbleLog.Lines.Add('GetToken: OK ... ' + UnicodeString(NempPlayer.NempScrobbler.Token));
                NempPlayer.NempScrobbler.LogList.Add('GetToken: OK ... ' + UnicodeString(NempPlayer.NempScrobbler.Token));
                BtnScrobbleWizard.Enabled := True;
                BtnScrobbleWizard.Caption := 'Next';
                BtnScrobbleWizard.Tag := 2;
                LblScrobble1.Caption := ScrobbleWizardAuthorize;
            end
            else
            begin
                MemoScrobbleLog.Lines.Add('GetToken: FAILED ... ');
                NempPlayer.NempScrobbler.LogList.Add('GetToken: FAILED ... ');
                SetScrobbleButtonOnError;
                // zurück zum Anfang
            end;
        end;

        SC_GetSession: begin
                NempPlayer.NempScrobbler.Username := PSessionResponse(aMsg.LParam).Username;
                NempPlayer.NempScrobbler.SessionKey := PSessionResponse(aMsg.LParam).SessionKey;
                solved := True;
                if NempPlayer.NempScrobbler.Username <> '' then
                begin
                    MemoScrobbleLog.Lines.Add('GetUserName: OK ... ' + NempPlayer.NempScrobbler.Username);
                    NempPlayer.NempScrobbler.LogList.Add('GetUserName: OK ... ' + NempPlayer.NempScrobbler.Username);
                end
                else
                begin
                    MemoScrobbleLog.Lines.Add('GetUserName: FAILED ... ');
                    NempPlayer.NempScrobbler.LogList.Add('GetUserName: FAILED ... ');
                end;

                if NempPlayer.NempScrobbler.SessionKey <> '' then
                begin
                    MemoScrobbleLog.Lines.Add('GetSessionKey: OK ... ' + UnicodeString(NempPlayer.NempScrobbler.SessionKey));
                    NempPlayer.NempScrobbler.LogList.Add('GetSessionKey: OK ... ' + UnicodeString(NempPlayer.NempScrobbler.SessionKey));
                end
                else
                begin
                    solved := False;
                    MemoScrobbleLog.Lines.Add('GetSessionKey: FAILED ... ');
                    NempPlayer.NempScrobbler.LogList.Add('GetSessionKey: FAILED ... ');
                end;

                if solved then
                begin
                    NempPlayer.NempScrobbler.ProblemSolved;

                    // Daten in Ini speichern. Die braucht man später wieder. ;-)
                    ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.UTF8);
                    try
                        ini.Encoding := TEncoding.UTF8;
                        NempPlayer.NempScrobbler.SaveToIni(Ini);
                        ini.Encoding := TEncoding.UTF8;
                        try
                            Ini.UpdateFile;
                        except

                        end;
                    finally
                        Ini.Free;
                    end;
                end;

                LblScrobble1.Caption := ScrobbleWizardComplete;
                BtnScrobbleWizard.Tag := BtnScrobbleWizard.Tag + 1; 
                BtnScrobbleWizard.Enabled := True;
                BtnScrobbleWizard.Caption := 'Ok';
        end;
    end;
end;

procedure TOptionsCompleteForm.Image2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.last.fm', nil, nil, SW_SHOW);
end;


{
    --------------------------------------------------------
    Methods for WebServer-Page
    --------------------------------------------------------
}

procedure TOptionsCompleteForm.BtnServerActivateClick(Sender: TObject);
begin
    //GetLocaleFormatSettings(LOCALE_USER_DEFAULT, LocalFormatSettings);

    if not NempWebServer.Active then
    begin
        // Server aktivieren
        // 1.) Daten übernehmen
        NempWebServer.UsernameU := EdtUsername.Text;
        NempWebServer.PasswordU := EdtPassword.Text;
        NempWebServer.UsernameA := EdtUsernameAdmin.Text;
        NempWebServer.PasswordA := EdtPasswordAdmin.Text;

        NempWebServer.Theme    := cbWebServerRootDir.Text;
        NempWebServer.Port     := seWebServer_Port.Value;
        // NempWebServer.OnlyLAN := cbOnlyLAN.Checked;
        NempWebServer.AllowLibraryAccess := cbPermitLibraryAccess.Checked;
        NempWebServer.AllowFileDownload := cbPermitPlaylistDownload.Checked;
        NempWebServer.AllowHtmlAudio := cbPermitHtmlAudio.Checked;
        NempWebServer.AllowRemoteControl := cbAllowRemoteControl.Checked;
        NempWebServer.AllowVotes := cbPermitVote.Checked;
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
            NempWebServer.SaveSettings;
            NempSettingsManager.WriteToDisk;
            // Anzeige setzen
            BtnServerActivate.Caption := WebServer_DeActivateServer;
            EdtUsername.Enabled := False;
            EdtPassword.Enabled := False;
            EdtUsernameAdmin.Enabled := False;
            EdtPasswordAdmin.Enabled := False;

            seWebServer_Port.Enabled := False;
            cbWebServerRootDir.Enabled := False;
            //BtnUpdateAuth.Enabled := False;
            //LogMemo.Lines.Add(DateTimeToStr(Now, LocalFormatSettings) + ', Server acticated, Files in library: ' + IntToStr(NempWebserver.Count));
        end else
        begin
            // OOps, an error occured
            MessageDLG('Server activation failed:' + #13#10 + NempWebServer.LastErrorString, mtError, [mbOK], 0);
            //LogMemo.Lines.Add(DateTimeToStr(Now, LocalFormatSettings) + ',Server activation failed.');
            //LogMemo.Lines.Add('Reason: ' + NempWebServer.LastErrorString);
        end;
    end else
    begin
        // Server deaktivieren
        NempWebServer.Active := False;
        // Anzeige setzen
        BtnServerActivate.Caption := WebServer_ActivateServer;
        EdtUsername.Enabled := True;
        EdtPassword.Enabled := True;
        EdtUsernameAdmin.Enabled := True;
        EdtPasswordAdmin.Enabled := True;

        seWebServer_Port.Enabled := True;
        cbWebServerRootDir.Enabled := True;
        //BtnUpdateAuth.Enabled := True;
        //LogMemo.Lines.Add(DateTimeToStr(Now, LocalFormatSettings) + ', Server shutdown.');
        ReArrangeToolImages;
    end;
end;


procedure TOptionsCompleteForm.BtnShowWebserverLogClick(Sender: TObject);
begin
    if not assigned(WebServerLogForm) then
        Application.CreateForm(TWebServerLogForm, WebServerLogForm);
    WebServerLogForm.Show;
end;



procedure TOptionsCompleteForm.EdtUsernameAdminKeyPress(Sender: TObject;
  var Key: Char);
begin
    case Word(key) of
        VK_RETURN: begin
            key:=#0;
            ActiveControl := EdtPasswordAdmin;
        end;
    end;
end;

procedure TOptionsCompleteForm.EdtUsernameKeyPress(Sender: TObject;
  var Key: Char);
begin
    case Word(key) of
        VK_RETURN: begin
            key:=#0;
            ActiveControl := EdtPassword;
        end;
    end;
end;

procedure TOptionsCompleteForm.EdtPasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
    case Word(key) of
        VK_RETURN: begin
            key:=#0;
        end;
    end;
end;


procedure TOptionsCompleteForm.BtnGetIPsClick(Sender: TObject);
var aText: String;
    a,b: Integer;
begin
  EdtGlobalIP.Text := WebServer_GettingIP;
  try
      aText := GetURLAsString('https://www.gausi.de/deine_ip.php');
      a := pos('<body>', aText);
      b := pos('</body>', aText);
      if (a > 0) and (b > 0) then begin
          EdtGlobalIP.Text := trim(copy(aText, a + 6, b-a-6));
          cbWebserverInternetQRCode.Enabled := True;
      end
      else
          EdtGlobalIP.Text := WebServer_GetIPFailedShort;
  except
      EdtGlobalIP.Text := WebServer_GetIPFailedShort;
  end;
end;


procedure TOptionsCompleteForm.BtnHelpClick(Sender: TObject);
begin
  if PageControl1.ActivePageIndex in [0..16] then
    Application.HelpContext(HelpContexts[PageControl1.ActivePageIndex])
  else
    Application.HelpContext(HELP_Einstellungen);
end;

{$REGION 'Customizable Coverflow'}
procedure TOptionsCompleteForm.ShowCoverFlowSettings;
begin

  fCoverFlowGUIUpdating := True;
  // z-axis
  tbCoverZMain.Position := MedienBib.NewCoverFlow.Settings.zMain;
  tbCoverZLeft.Position := MedienBib.NewCoverFlow.Settings.zLeft;
  tbCoverZRight.Position := MedienBib.NewCoverFlow.Settings.zRight;
  // gaps
  tbCoverGapRight      .Position := MedienBib.NewCoverFlow.Settings.GapRight;
  tbCoverGapLeft       .Position := MedienBib.NewCoverFlow.Settings.GapLeft;
  tbCoverGapFirstRight .Position := MedienBib.NewCoverFlow.Settings.GapFirstRight;
  tbCoverGapFirstLeft  .Position := MedienBib.NewCoverFlow.Settings.GapFirstLeft;
  // Angles
  tbCoverAngleRight    .Position := MedienBib.NewCoverFlow.Settings.AngleRight;
  tbCoverAngleLeft     .Position := MedienBib.NewCoverFlow.Settings.AngleLeft;
  tbCoverAngleMain     .Position := MedienBib.NewCoverFlow.Settings.AngleMain;
  // view
  tbCoverViewPosition.Position  := MedienBib.NewCoverFlow.Settings.ViewPosX;
  // Reflexion
  cbCoverFlowUseReflection .Checked := MedienBib.NewCoverFlow.Settings.UseReflection;
	tbCoverReflexionIntensity.Position := MedienBib.NewCoverFlow.Settings.ReflexionBlendFaktor;
	tbCoverReflexionGap      .Position := MedienBib.NewCoverFlow.Settings.GapReflexion;
  // reflexion, Enabled/Disabled
  lblCoverFlowIntensity.Enabled      := MedienBib.NewCoverFlow.Settings.UseReflection;
	lblCoverflowReflexionGap.Enabled   := MedienBib.NewCoverFlow.Settings.UseReflection;
	tbCoverReflexionIntensity.Enabled  := MedienBib.NewCoverFlow.Settings.UseReflection;
	tbCoverReflexionGap.Enabled        := MedienBib.NewCoverFlow.Settings.UseReflection;
  // mixed settings
  seCoverflowTextureCache.Value := MedienBib.NewCoverFlow.Settings.MaxTextures;
  cb_UseClassicCoverflow.Checked := MedienBib.NewCoverFlow.Mode = cm_Classic;
  edtCoverFlowColor.Text := ColorToString(MedienBib.NewCoverFlow.Settings.DefaultColor);
  shapeCoverflowColor.Brush.Color := MedienBib.NewCoverFlow.Settings.DefaultColor;
  ColorDlgCoverflow.Color := MedienBib.NewCoverFlow.Settings.DefaultColor;

  fCoverFlowGUIUpdating := False;
end;

procedure TOptionsCompleteForm.ApplyCoverFlowSettings;
begin
  MedienBib.NewCoverFlow.Settings.zMain  := tbCoverZMain.Position ;
  MedienBib.NewCoverFlow.Settings.zLeft  := tbCoverZLeft.Position ;
  MedienBib.NewCoverFlow.Settings.zRight := tbCoverZRight.Position;
  // gaps
  MedienBib.NewCoverFlow.Settings.GapRight      := tbCoverGapRight      .Position;
  MedienBib.NewCoverFlow.Settings.GapLeft       := tbCoverGapLeft       .Position;
  MedienBib.NewCoverFlow.Settings.GapFirstRight := tbCoverGapFirstRight .Position;
  MedienBib.NewCoverFlow.Settings.GapFirstLeft  := tbCoverGapFirstLeft  .Position;
  // Angles
  MedienBib.NewCoverFlow.Settings.AngleRight    := tbCoverAngleRight    .Position;
  MedienBib.NewCoverFlow.Settings.AngleLeft     := tbCoverAngleLeft     .Position;
  MedienBib.NewCoverFlow.Settings.AngleMain     := tbCoverAngleMain     .Position;
  // View
  MedienBib.NewCoverFlow.Settings.ViewPosX := tbCoverViewPosition.Position  ;
  // Reflexion
  MedienBib.NewCoverFlow.Settings.UseReflection        := cbCoverFlowUseReflection .Checked;
	MedienBib.NewCoverFlow.Settings.ReflexionBlendFaktor := tbCoverReflexionIntensity.Position;
	MedienBib.NewCoverFlow.Settings.GapReflexion         := tbCoverReflexionGap      .Position;
  lblCoverFlowIntensity.Enabled      := MedienBib.NewCoverFlow.Settings.UseReflection;
	lblCoverflowReflexionGap.Enabled   := MedienBib.NewCoverFlow.Settings.UseReflection;
	tbCoverReflexionIntensity.Enabled  := MedienBib.NewCoverFlow.Settings.UseReflection;
	tbCoverReflexionGap.Enabled        := MedienBib.NewCoverFlow.Settings.UseReflection;
  // mixed settings
  MedienBib.NewCoverFlow.Settings.MaxTextures := seCoverflowTextureCache.Value;
  MedienBib.NewCoverFlow.Settings.DefaultColor := StringToColorDef(edtCoverFlowColor.Text, clWhite);
  // Correct color display, if the user entered an invalid color
  edtCoverFlowColor.Text := ColorToString(MedienBib.NewCoverFlow.Settings.DefaultColor);
  shapeCoverflowColor.Brush.Color := MedienBib.NewCoverFlow.Settings.DefaultColor;
  ColorDlgCoverflow.Color := MedienBib.NewCoverFlow.Settings.DefaultColor;
end;

procedure TOptionsCompleteForm.tbCoverZMainChange(Sender: TObject);
begin
  if fCoverFlowGUIUpdating then exit;
  ApplyCoverFlowSettings;
  MedienBib.NewCoverFlow.ApplySettings;
end;

procedure TOptionsCompleteForm.BtnUndoCoverFlowSettingsClick(Sender: TObject);
begin
  MedienBib.NewCoverFlow.Settings := BackUpCoverFlowSettings;
  ShowCoverFlowSettings;
  MedienBib.NewCoverFlow.ApplySettings;
end;

procedure TOptionsCompleteForm.BtnCoverFlowDefaultClick(Sender: TObject);
begin
  MedienBib.NewCoverFlow.Settings := DefaultCoverFlowSettings;
  ShowCoverFlowSettings;
  MedienBib.NewCoverFlow.ApplySettings;
end;

procedure TOptionsCompleteForm.SelectCoverFlowColor;
begin
  if ColorDlgCoverflow.Execute then begin
    edtCoverFlowColor.Text := ColorToString(ColorDlgCoverflow.Color);
    shapeCoverflowColor.Brush.Color := ColorDlgCoverflow.Color;
  end;
end;

procedure TOptionsCompleteForm.shapeCoverflowColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SelectCoverFlowColor;
end;


procedure TOptionsCompleteForm.btnSelectCoverFlowColorClick(Sender: TObject);
begin
  SelectCoverFlowColor;
end;

{$ENDREGION}

{$REGION 'MediaLibrary: Category, Configuration'}
procedure TOptionsCompleteForm.ShowMediaLibraryConfiguration;
var
  i, iRC: Integer;
  newCat: TLibraryFileCategory;
  newRoot: TRootCollection;
  aRootConfig: TCollectionConfigList;
begin
  OrganizerSettings.Assign(NempOrganizerSettings);
  fCategoriesChanged  := False;
  fCollectionsChanged := False;

  RootCollections.OwnsObjects := True;
  RootCollections.Clear;
  for iRC := 0 to OrganizerSettings.RootCollectionCount - 1 do begin
    aRootConfig := OrganizerSettings.RootCollectionConfig[iRC];
    newRoot := TRootCollection.Create(Nil);
    for i := 0 to aRootConfig.Count - 1 do
      newRoot.AddSubCollectionType(aRootConfig[i]);
    RootCollections.Add(newRoot);
  end;
  RootCollections.OwnsObjects := False;

  FileCategories.OwnsObjects := True;
  FileCategories.Clear;
  for i := 0 to MedienBib.FileCategories.Count - 1 do begin
    newCat := TLibraryFileCategory.Create;
    newCat.AssignSettings(MedienBib.FileCategories[i]);
    FileCategories.Add(newCat);
  end;
  FileCategories.OwnsObjects := False;

  FillCategoryTree;
  FillCategoryComboBoxes;
  FillCollectionTree;
  FillCoverFlowSortingLabel(OrganizerSettings.CoverFlowRootCollectionConfig[0]);
  cbMissingCoverMode.ItemIndex := Integer(MedienBib.MissingCoverMode);

  cbAlbumKeymode.ItemIndex := Integer(OrganizerSettings.AlbumKeyMode);
  cbIgnoreCDDirectories.Checked := OrganizerSettings.TrimCDFromDirectory;
  cbSamplerSortingIgnoreReleaseYear.Checked := OrganizerSettings.SamplerSortingIgnoreReleaseYear;
  cbPreferAlbumArtist.Checked := OrganizerSettings.PreferAlbumArtist;
  cpIgnoreAlbumArtistVariousArtists.Checked := OrganizerSettings.IgnoreVariousAlbumArtists;
  cpIgnoreAlbumArtistVariousArtists.Enabled := OrganizerSettings.PreferAlbumArtist;
  editCDNames.Text := OrganizerSettings.CDNames.DelimitedText;
  cbShowElementCount.Checked := OrganizerSettings.ShowElementCount;
  cbShowCoverForAlbum.Checked := OrganizerSettings.ShowCoverArtOnAlbum;
  cbCombineLayers.Checked := OrganizerSettings.CombineLayers;
  cbShowFilesRecursively.Checked := OrganizerSettings.ShowFilesRecursively;
  cbLibConfigShowPlaylistCategories.Checked := OrganizerSettings.ShowPlaylistCategories;
  cbLibConfigShowWebRadioCategory.Checked := OrganizerSettings.ShowWebradioCategory;
  cbPlaylistCaptionMode.ItemIndex := Integer(OrganizerSettings.PlaylistCaptionMode);
  cbPlaylistSortMode.ItemIndex := Integer(OrganizerSettings.PlaylistSorting);
  cbPlaylistSortDirection.ItemIndex := Integer(OrganizerSettings.PlaylistSortDirection);
end;

procedure TOptionsCompleteForm.cbPreferAlbumArtistClick(Sender: TObject);
begin
  cpIgnoreAlbumArtistVariousArtists.Enabled := cbPreferAlbumArtist.Checked;
end;

function TOptionsCompleteForm.ApplyMediaLibraryConfiguration: boolean;
var
  i: Integer;
  newCat: TLibraryFileCategory;
begin
  result := (MedienBib.StatusBibUpdate = 0) or (not MediaLibraryConfigurationChanged);

  if (MedienBib.StatusBibUpdate <> 0) then
    exit;

  if fCategoriesChanged then begin
    MedienBib.ClearFileCategories;
    // create new Categories in Medienbib
    for i := 0 to FileCategories.Count - 1 do begin
      newCat := TLibraryFileCategory.Create;
      newCat.AssignSettings(FileCategories[i]);
      MedienBib.FileCategories.Add(newCat);
    end;
    MedienBib.DefaultFileCategory := TLibraryFileCategory(GetDefaultCategory(MedienBib.FileCategories));
    MedienBib.NewFilesCategory := TLibraryFileCategory(GetNewCategory(MedienBib.FileCategories));
    MedienBib.Changed := True;
  end;

  if fCollectionsChanged then begin
    // Convert RootCollections to OrganizerSettings
    OrganizerSettings.Clear;
    for i := 0 to RootCollections.Count - 1 do
      OrganizerSettings.AddConfig(TRootCollection(RootCollections[i]).CollectionConfigList);
  end;

  fCategoriesChanged := False;
  fCollectionsChanged := False;

  MedienBib.MissingCoverMode := teMissingCoverPreSorting(cbMissingCoverMode.ItemIndex);
  OrganizerSettings.AlbumKeyMode := teAlbumKeyMode(cbAlbumKeymode.ItemIndex);
  OrganizerSettings.SamplerSortingIgnoreReleaseYear := cbSamplerSortingIgnoreReleaseYear.Checked;
  OrganizerSettings.PreferAlbumArtist := cbPreferAlbumArtist.Checked;
  OrganizerSettings.IgnoreVariousAlbumArtists := cpIgnoreAlbumArtistVariousArtists.Checked;
  OrganizerSettings.TrimCDFromDirectory := cbIgnoreCDDirectories.Checked;
  OrganizerSettings.CDNames.DelimitedText := editCDNames.Text;
  OrganizerSettings.ShowElementCount := cbShowElementCount.Checked;
  OrganizerSettings.ShowCoverArtOnAlbum := cbShowCoverForAlbum.Checked;
  OrganizerSettings.CombineLayers := cbCombineLayers.Checked;
  OrganizerSettings.ShowFilesRecursively := cbShowFilesRecursively.Checked;
  OrganizerSettings.ShowPlaylistCategories := cbLibConfigShowPlaylistCategories.Checked;
  OrganizerSettings.ShowWebradioCategory := cbLibConfigShowWebRadioCategory.Checked;
  OrganizerSettings.PlaylistCaptionMode := tePlaylistCaptionMode(cbPlaylistCaptionMode.ItemIndex);
  OrganizerSettings.PlaylistSorting := tePlaylistCollectionSorting(cbPlaylistSortMode.ItemIndex);
  OrganizerSettings.PlaylistSortDirection := teSortDirection(cbPlaylistSortDirection.ItemIndex);
  NempOrganizerSettings.Assign(OrganizerSettings);
  MedienBib.ChangePlaylistCollectionSorting(NempOrganizerSettings.PlaylistSorting, NempOrganizerSettings.PlaylistSortDirection);
  // if hide Playlist/WebRadioCategory now, we should switch to a FileCategory
  if (MedienBib.CurrentCategory is TLibraryPlaylistCategory) and (not OrganizerSettings.ShowPlaylistCategories) then
    MedienBib.CurrentCategory := MedienBib.DefaultFileCategory;
  if (MedienBib.CurrentCategory is TLibraryWebradioCategory) then
    MedienBib.CurrentCategory := MedienBib.DefaultFileCategory;
  MedienBib.ReFillFileCategories;
end;

function TOptionsCompleteForm.SettingsChanged: Boolean;
begin
  result :=
      NempSettingsChanged or
      ControlsChanged or
      PlayerSettingsChanged or
      PlaylistSettingsChanged or
      WebServerSettingsChanged or
      EffectReplayGainSettingsChanged or
      BirthdaySettingsChanged or
      FontsAndPartyModeChanged or
      FileSearchSettingsChanged or
      ListViewSettingsChanged or
      WebRadioSettingsChanged or
      MetadataSettingsChanged or
      SearchSettingsChanged or
      LastFMSettingsChanged or
      CoverFlowSettingsChanged or
      MediaLibraryConfigurationChanged;
end;

function TOptionsCompleteForm.NempSettingsChanged: Boolean;
begin
  result :=
  (NempPlaylist.AutoPlayOnStart <> CB_AutoPlayOnStart.Checked) or
  (NempPlaylist.SavePositionInTrack <> cb_SavePositionInTrack.Checked) or
  (NempPlaylist.AutoPlayNewTitle <> CB_AutoPlayNewTitle.Checked) or
  (NempPlaylist.AutoPlayEnqueuedTitle <> CB_AutoPlayEnqueueTitle.Checked) or
  (MedienBib.AutoLoadMediaList <> CBAutoLoadMediaList.Checked) or
  (MedienBib.AutoSaveMediaList <> CBAutoSaveMediaList.Checked) or
  (NempOptions.ShowSplashScreen <> cb_ShowSplashScreen.Checked) or
  (NempOptions.AllowOnlyOneInstance <> Not CB_AllowMultipleInstances.Checked) or
  (NempOptions.StartMinimized  <> CB_StartMinimized.Checked) or
  (NempOptions.ShowTrayIcon <> cbShowTrayIcon.Checked) or
  (Nemp_MainForm.NempTrayIcon.Visible <> NempOptions.ShowTrayIcon) or
  (TDrivemanager.EnableUSBMode <> cb_EnableUSBMode.Checked) or
  (TDrivemanager.EnableCloudMode <> cb_EnableCloudMode.Checked) or
  (NempUpdater.AutoCheck <> CB_AutoCheck.Checked) or
  (NempUpdater.NotifyOnBetas <> CB_AutoCheckNotifyOnBetas.Checked) or
  (NempPlayer.ReInitAfterSuspend <> cbReInitAfterSuspend.Checked) or
  (NempPlayer.PauseOnSuspend <> cbPauseOnSuspend.Checked);
end;

function TOptionsCompleteForm.ControlsChanged: Boolean;
begin
  result :=
  (NempOptions.RegisterMediaHotkeys <> cb_RegisterMediaHotkeys.Checked) or
  (NempOptions.IgnoreVolumeUpDownKeys <> CB_IgnoreVolume.Checked) or
  (cb_UseG15Display.Checked <> NempOptions.UseDisplayApp) or
  (NempOptions.UseDisplayApp <> cb_UseG15Display.Checked) or
  (NempOptions.RegisterHotKeys <> CBRegisterHotKeys.Checked) or
  (NempOptions.TabStopAtPlayerControls <> CB_TabStopAtPlayerControls.Checked) or
  (NempOptions.TabStopAtTabs <> CB_TabStopAtTabs.Checked);
end;

function TOptionsCompleteForm.PlayerSettingsChanged: Boolean;
begin
  Result :=
  (NempPlayer.MainDevice <> MainDeviceCB.ItemIndex + 1) or
  (NempPlayer.HeadsetDevice <> HeadPhonesDeviceCB.ItemIndex +1) or
  (NempPlayer.SoundfontFilename <> editSoundFont.Text) or
  (NempPlayer.PlayBufferSize <> SEBufferSize.Value) or
  (NempPlayer.UseFloatingPointChannels <> CB_FloatingPoint.ItemIndex) or
  (NempPlayer.UseHardwareMixing <> (CB_Mixing.ItemIndex = 0)) or
  (NempPlayer.UseFading <> CB_Fading.Checked) or
  (NempPlayer.FadingInterval <> SE_Fade.Value) or
  (NempPlayer.SeekFadingInterval <> SE_SeekFade.Value) or
  (NempPlayer.IgnoreFadingOnShortTracks <> CB_IgnoreFadingOnShortTracks.Checked) or
  (NempPlayer.IgnoreFadingOnPause <> CB_IgnoreFadingOnPause.Checked) or
  (NempPlayer.IgnoreFadingOnStop <> CB_IgnoreFadingOnStop.Checked) or
  (NempPlayer.IgnoreFadingOnLiveRecordings  <> cbIgnoreFadingOnLiveRecordings.Checked) or
  (NempPlayer.LiveRecordingCheckTitle       <> cbLiveRecordingCheckTitle.Checked) or
  (NempPlayer.LiveRecordingCheckAlbum       <> cbLiveRecordingCheckAlbum.Checked) or
  (NempPlayer.LiveRecordingCheckTags        <> cbLiveRecordingCheckTags.Checked) or
  (NempPlayer.LiveRecordingCheckIdentifier  <> edtLiveRecordingCheckIdentifier.Text) or
  (NempPlayer.DoSilenceDetection <> CB_SilenceDetection.Checked ) or
  (NempPlayer.SilenceThreshold   <> SE_SilenceThreshold.Value) or
  (NempPlayer.DoPauseBetweenTracks  <> cb_AddBreakBetweenTracks.Checked) or
  (NempPlayer.PauseBetweenTracksDuration <> SE_BreakBetweenTracks.Value) or
  (NempPlayer.UseVisualization <> CB_Visual.Checked) or
  (NempPlayer.VisualizationInterval <> 100 - TB_Refresh.Position) or
  (Nemp_MainForm.BassTimer.Interval <> NempPlayer.VisualizationInterval) or
  (Nemp_MainForm.HeadsetTimer.Interval <> NempPlayer.VisualizationInterval) or
  (NempPlayer.ScrollTaskbarTitel <> CB_ScrollTitelTaskBar.Checked) or
  (NempPlayer.ScrollTaskbarDelay <>  (4 - CB_TaskbarDelay.ItemIndex + 1)* 5) or
  (NempPlayer.SafePlayback <> cb_SafePlayback.Checked);
end;
function TOptionsCompleteForm.PlaylistSettingsChanged: Boolean;
begin
  result :=
  (NempPlaylist.DefaultAction <> GrpBox_DefaultAction.ItemIndex) or
  (NempPlaylist.ApplyDefaultActionToWholeList <> cbApplyDefaultActionToWholeList.Checked) or
  (NempPlaylist.UseDefaultActionOnCoverFlowDoubleClick <> cbUseDefaultActionOnCoverFlowDoubleClick.Checked) or
  (NempPlaylist.HeadSetAction <> GrpBox_HeadsetDefaultAction.ItemIndex) or
  (NempPlaylist.AutoStopHeadsetSwitchTab <> cb_AutoStopHeadsetSwitchTab.Checked) or
  (NempPlaylist.AutoStopHeadsetAddToPlayist <> cb_AutoStopHeadsetAddToPlayist.Checked) or
  (NempPlaylist.AutoScan <> CB_AutoScanPlaylist.checked) or
  (NempPlaylist.JumpToNextCueOnNextClick <> CB_JumpToNextCue.Checked) or
  (NempPlaylist.RepeatCueOnRepeatTitle <> cb_ReplayCue.Checked) or
  (NempPlaylist.RememberInterruptedPlayPosition <> CB_RememberInterruptedPlayPosition.Checked) or
  (NempPlaylist.AutoDelete <> CB_AutoDeleteFromPlaylist.Checked) or
  (NempPlaylist.DisableAutoDeleteAtUserInput <> CB_DisableAutoDeleteAtUserInput.Checked) or
  (NempPlaylist.AutoMix <> CB_AutoMixPlaylist.Checked) or
  (NempPlaylist.PlaylistManager.AutoSaveOnPlaylistChange <> cb_PlaylistManagerAutoSave.Checked) or
  (NempPlaylist.PlaylistManager.UserInputOnPlaylistChange <> cb_PlaylistManagerAutoSaveUserInput.Checked) or
  (NempPlaylist.RandomRepeat <> TBRandomRepeat.Position) or
  (NempPlaylist.UseWeightedRNG <> cb_UseWeightedRNG.Checked) or
  (NempPlaylist.RNGWeights[1]  <> StrToIntDef(RandomWeight05.Text, 1)) or
  (NempPlaylist.RNGWeights[2]  <> StrToIntDef(RandomWeight10.Text, 1)) or
  (NempPlaylist.RNGWeights[3]  <> StrToIntDef(RandomWeight15.Text, 1)) or
  (NempPlaylist.RNGWeights[4]  <> StrToIntDef(RandomWeight20.Text, 1)) or
  (NempPlaylist.RNGWeights[5]  <> StrToIntDef(RandomWeight25.Text, 1)) or
  (NempPlaylist.RNGWeights[6]  <> StrToIntDef(RandomWeight30.Text, 1)) or
  (NempPlaylist.RNGWeights[7]  <> StrToIntDef(RandomWeight35.Text, 1)) or
  (NempPlaylist.RNGWeights[8]  <> StrToIntDef(RandomWeight40.Text, 1)) or
  (NempPlaylist.RNGWeights[9]  <> StrToIntDef(RandomWeight45.Text, 1)) or
  (NempPlaylist.RNGWeights[10] <> StrToIntDef(RandomWeight50.Text, 1)) or
  (NempPlayer.NempLogFile.DoLogToFile <> cbSaveLogToFile.Checked) or
  (NempPlayer.NempLogFile.KeepLogRangeInDays <> seLogDuration.Value);
end;
function TOptionsCompleteForm.WebServerSettingsChanged: Boolean;
begin
  result :=
  (NempWebServer.UsernameU <> EdtUsername.Text) or
  (NempWebServer.PasswordU <> EdtPassword.Text) or
  (NempWebServer.UsernameA <> EdtUsernameAdmin.Text) or
  (NempWebServer.PasswordA <> EdtPasswordAdmin.Text) or
  (NempWebServer.Theme <> cbWebServerRootDir.Text) or
  (NempWebServer.Port <> seWebServer_Port.Value) or
  (NempWebServer.AllowLibraryAccess    <> cbPermitLibraryAccess.Checked) or
  (NempWebServer.AllowFileDownload     <> cbPermitPlaylistDownload.Checked) or
  (NempWebServer.AllowHtmlAudio        <> cbPermitHtmlAudio.Checked) or
  (NempWebServer.AllowRemoteControl    <> cbAllowRemoteControl.Checked) or
  (MedienBib.AutoActivateWebServer     <> CBAutoStartWebServer.Checked) or
  (NempWebServer.AllowVotes            <> cbPermitVote.Checked);
end;
function TOptionsCompleteForm.EffectReplayGainSettingsChanged: Boolean;
begin
  result :=
  (NempPlayer.ApplyReplayGain  <> cb_ApplyReplayGain.Checked) or
  (NempPlayer.PreferAlbumGain  <> cb_PreferAlbumGain.Checked) or
  (NempPlayer.DefaultGainWithoutRG <> tp_DefaultGain.Position / 10) or
  (NempPlayer.DefaultGainWithRG    <> tp_DefaultGain2.Position / 10) or
  (NempPlayer.PreventClipping      <> cb_ReplayGainPreventClipping.Checked) or
  (NempPlayer.UseDefaultEffects <> CB_UseDefaultEffects.Checked) or
  (NempPlayer.UseDefaultEqualizer <> CB_UseDefaultEqualizer.Checked) or
  (NempPlayer.UseWalkmanMode <> cb_UseWalkmanMode.Checked) or
  (Nemp_MainForm.WalkmanModeTimer.Enabled <> cb_UseWalkmanMode.Checked) or
  (NempPlayer.ReduceMainVolumeOnJingle <> CBJingleReduce.Checked) or
  (NempPlayer.ReduceMainVolumeOnJingleValue <> SEJingleReduce.Value) or
  (NempPlayer.JingleVolume <> SEJingleVolume.Value)
end;
function TOptionsCompleteForm.BirthdaySettingsChanged: Boolean;
begin
  result := (NempPlayer.NempBirthdayTimer.CountDownFileName <> EditCountdownSong.Text)
      or (NempPlayer.NempBirthdayTimer.BirthdaySongFilename <> EditBirthdaySong.Text)
      or (NempPlayer.NempBirthdayTimer.StartTime <> StrToTime(mskEdt_BirthdayTime.Text))
      or (NempPlayer.NempBirthdayTimer.UseCountDown <> CBStartCountDown.Checked)
      or (NempPlayer.NempBirthdayTimer.ContinueAfter <> CBContinueAfter.Checked);
end;
function TOptionsCompleteForm.FontsAndPartyModeChanged: Boolean;
begin
  result :=
  (NempOptions.DefaultFontSize <> SEFontSize.Value) or
  (NempOptions.RowHeight <> SERowHeight.Value) or
  (NempOptions.DefaultFontStyle <> cb_Medialist_FontStyle.ItemIndex) or
  (NempOptions.DefaultFontStyles <> FontSelectorItemIndexToStyle(NempOptions.DefaultFontStyle)) or
  (NempOptions.ArtistAlbenFontSize <> SEArtistAlbenSIze.Value) or
  (NempOptions.ArtistAlbenRowHeight <> SEArtistAlbenRowHeight.Value) or
  (NempOptions.ArtistAlbenFontStyle <> cb_Browselist_FontStyle.ItemIndex) or
  (NempOptions.ArtistAlbenFontStyles <> FontSelectorItemIndexToStyle(NempOptions.ArtistAlbenFontStyle)) or
  (NempOptions.ChangeFontColorOnBitrate <> CBChangeFontColorOnBitrate.Checked) or
  (NempOptions.ChangeFontSizeOnLength <> CBChangeFontSizeOnLength.Checked) or
  (NempOptions.ChangeFontStyleOnMode <> CBChangeFontStyleOnMode.Checked) or
  (NempOptions.ChangeFontOnCbrVbr <> CBChangeFontOnCbrVbr.Checked) or
  (NempOptions.FontNameCBR <> CBFontNameCBR.Items[CBFontNameCBR.itemindex]) or
  (NempOptions.FontNameVBR <> CBFontNameVBR.Items[CBFontNameVBR.itemindex]) or
  (Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor <> Nemp_MainForm.NempSkin.NempPartyMode.IndexToFactor(CB_PartyMode_ResizeFactor.ItemIndex)) or
  (Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit <> cb_PartyMode_BlockTreeEdit.Checked) or
  (Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating <> cb_PartyMode_BlockCurrentTitleRating.Checked) or
  (Nemp_MainForm.NempSkin.NempPartyMode.BlockTools <> cb_PartyMode_BlockTools.Checked) or
  (Nemp_MainForm.NempSkin.NempPartyMode.ShowPasswordOnActivate <> cb_PartyMode_ShowPasswordOnActivate.Checked) or
  (Nemp_MainForm.NempSkin.NempPartyMode.password <> Edt_PartyModePassword.Text);
end;
function TOptionsCompleteForm.FileSearchSettingsChanged: Boolean;
begin
  result :=
  (MedienBib.AutoScanDirs <> CBAutoScan.Checked) or
  (MedienBib.AskForAutoAddNewDirs <> CBAskForAutoAddNewDirs.Checked) or
  (MedienBib.AutoAddNewDirs <> CBAutoAddNewDirs.Checked) or
  (MedienBib.AutoDeleteFiles <> cb_AutoDeleteFiles.checked) or
  (MedienBib.AutoDeleteFilesShowInfo <> cb_AutoDeleteFilesShowInfo.checked) or
  (MedienBib.AutoScanPlaylistFilesOnView <> CBAutoScanPlaylistFilesOnView.Checked) or
  (MedienBib.IncludeAll <> cbIncludeAll.Checked) or
  (TCoverArtSearcher.UseDir       <> CB_CoverSearch_inDir.Checked) or
  (TCoverArtSearcher.UseParentDir <> CB_CoverSearch_inParentDir.Checked) or
  (TCoverArtSearcher.UseSubDir    <> CB_CoverSearch_inSubDir.Checked) or
  (TCoverArtSearcher.UseSisterDir <> CB_CoverSearch_inSisterDir.Checked) or
  (TCoverArtSearcher.SubDirName <> EDTCoverSubDirName.Text ) or
  (TCoverArtSearcher.SisterDirName <> EDTCoverSisterDirName.Text) or
  (TCoverArtSearcher.CoverSizeIndex <> cb_CoverSize.ItemIndex) or
  (MedienBib.CoverSearchLastFM <> CB_CoverSearch_LastFM.Checked);
end;
function TOptionsCompleteForm.ListViewSettingsChanged: Boolean;
begin
  result :=
  (NempDisplay.ArtistSubstitute <> TESubstituteValue(cbReplaceArtistBy.ItemIndex)) or
  (NempDisplay.TitleSubstitute  <> TESubstituteValue(cbReplaceTitleBy .ItemIndex)) or
  (NempDisplay.AlbumSubstitute  <> TESubstituteValue(cbReplaceAlbumBy .ItemIndex)) or
  (NempDisplay.PlaylistTitleFormat    <> cbPlaylistTitle.Text         ) or
  (NempDisplay.PlaylistTitleFormatFB  <> cbPlaylistTitleFB.Text       ) or
  (NempDisplay.PlaylistCueAlbumFormat <> cbPlaylistTitleCueAlbum.Text ) or
  (NempDisplay.PlaylistCueTitleFormat <> cbPlaylistTitleCueTitle.Text ) or
  (NempDisplay.PlaylistWebradioFormat <> cbPlaylistWebradioTitle.Text ) or
  (NempPlaylist.ShowIndexInTreeview <> cb_ShowIndexInTreeview.Checked) or
  (MedienBib.AlwaysSortAnzeigeList <> cbAlwaysSortAnzeigeList.Checked) or
  (MedienBib.SkipSortOnLargeLists <> CBSkipSortOnLargeLists.Checked) or
  (MedienBib.limitMarkerToCurrentFiles <> cb_limitMarkerToCurrentFiles.Checked) or
  (MedienBib.ShowHintsInMedialist <> CBShowHintsInTitlelists.Checked) or
  (MedienBib.ShowAdvancedHints <> CB_ShowAdvancedHints.Checked) or
  //(NempPlaylist.ShowHintsInPlaylist <> CB_ShowHintsInPlaylist.Checked) or
  (NempOptions.FullRowSelect <> cbFullRowSelect.Checked) or
  (Nemp_MainForm.VST.ShowHint <> MedienBib.ShowHintsInMedialist) or
  (Nemp_MainForm.PlaylistVST.ShowHint <> MedienBib.ShowHintsInMedialist);
end;
function TOptionsCompleteForm.WebRadioSettingsChanged: Boolean;
begin
  result :=
  (NempPlayer.DownloadDir <> IncludeTrailingPathDelimiter(EdtDownloadDir.Text)) or
  (NempPlayer.UseStreamnameAsDirectory <> cbUseStreamnameAsDirectory.Checked) or
  (NempPlayer.FilenameFormat <> cbFilenameFormat.Text) or
  (NempPlayer.AutoSplitByTitle <> cbAutoSplitByTitle.Checked) or
  (NempPlayer.AutoSplitByTime <> cbAutoSplitBySize.Checked) or
  (NempPlayer.AutoSplitBySize <> cbAutoSplitByTime.Checked) or
  (NempPlayer.AutoSplitMaxSize <> SE_AutoSplitMaxSize.Value) or
  (NempPlayer.AutoSplitMaxTime <> SE_AutoSplitMaxTime.Value) or
  (NempPlaylist.BassHandlePlaylist <> rbWebRadioHandledByBass.Checked);
end;
function TOptionsCompleteForm.MetadataSettingsChanged: Boolean;
begin
  result :=
  (NempOptions.AllowQuickAccessToMetadata <> cb_AccessMetadata.checked) or
  (NempPlayer.PostProcessor.Active <> cb_RatingActive.checked) or
  (NempPlayer.PostProcessor.IgnoreShortFiles <> cb_RatingIgnoreShortFiles.checked) or
  (NempPlayer.PostProcessor.WriteToFiles <> cb_AccessMetadata.checked) or
  (NempPlayer.PostProcessor.ChangeCounter <> cb_RatingChangeCounter.checked) or
  (NempPlayer.PostProcessor.IncPlayedFiles <> cb_RatingIncreaseRating.checked) or
  (NempPlayer.PostProcessor.DecAbortedFiles <> cb_RatingDecreaseRating.checked) or
  (MedienBib.AutoResolveInconsistencies <> cb_AutoResolveInconsistencies.checked) or
  (MedienBib.AskForAutoResolveInconsistencies <> cb_AskForAutoResolveInconsistencies.checked) or
  (MedienBib.ShowAutoResolveInconsistenciesHints <> cb_ShowAutoResolveInconsistenciesHints.checked) or
  (NempCharCodeOptions.AutoDetectCodePage <> CBAutoDetectCharCode.Checked) or
  (NempOptions.AutoScanNewCDs <> cbAutoCheckNewCDs.Checked) or
  (NempOptions.UseCDDB <> cbUseCDDB.Checked) or
  (NempOptions.PreferCDDB <> cbPreferCDDB.checked) or
  (NempOptions.CDDBServer <> edtCDDBServer.Text) or
  (NempOptions.CDDBEMail <> edtCDDBEMail.Text);
end;
function TOptionsCompleteForm.SearchSettingsChanged: Boolean;
begin
  result :=
  (MedienBib.BibSearcher.QuickSearchOptions.WhileYouType <> CB_QuickSearchWhileYouType.Checked) or
  (MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow <> cb_ChangeCoverflowOnSearch.Checked) or
  (MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter <> CB_QuickSearchAllowErrorsOnEnter.Checked) or
  (MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType <> CB_QuickSearchAllowErrorsWhileTyping.Checked) or
  (MedienBib.IgnoreLyrics <> cb_IgnoreLyrics.Checked) or
  (MedienBib.BibSearcher.AccelerateSearch <> CB_AccelerateSearch .Checked) or
  (MedienBib.BibSearcher.AccelerateSearchIncludePath <> CB_AccelerateSearchIncludePath.Checked) or
  (MedienBib.BibSearcher.AccelerateSearchIncludeComment <> CB_AccelerateSearchIncludeComment.Checked) or
  (MedienBib.BibSearcher.AccelerateSearchIncludeGenre <> CB_AccelerateSearchIncludeGenre.Checked) or
  (MedienBib.BibSearcher.AccelerateSearchIncludeAlbumArtist <> CB_AccelerateSearchIncludeAlbumArtist.Checked) or
  (MedienBib.BibSearcher.AccelerateSearchIncludeComposer <> CB_AccelerateSearchIncludeComposer.Checked) or
  (MedienBib.BibSearcher.AccelerateLyricSearch <> CB_AccelerateLyricSearch.Checked);
end;
function TOptionsCompleteForm.LastFMSettingsChanged: Boolean;
begin
  result :=
  (NempPlayer.NempScrobbler.IgnoreErrors <> CB_SilentError.Checked) or
  (NempPlayer.NempScrobbler.AlwaysScrobble <> CB_AlwaysScrobble.Checked) or
  (NempPlayer.NempScrobbler.DoScrobble <> CB_ScrobbleThisSession.Checked);
end;
function TOptionsCompleteForm.CoverFlowSettingsChanged: Boolean;
begin
  result :=
  (MedienBib.NewCoverFlow.Settings.zMain  <> tbCoverZMain.Position ) or
  (MedienBib.NewCoverFlow.Settings.zLeft  <> tbCoverZLeft.Position) or
  (MedienBib.NewCoverFlow.Settings.zRight <> tbCoverZRight.Position) or
  (MedienBib.NewCoverFlow.Settings.GapRight      <> tbCoverGapRight      .Position) or
  (MedienBib.NewCoverFlow.Settings.GapLeft       <> tbCoverGapLeft       .Position) or
  (MedienBib.NewCoverFlow.Settings.GapFirstRight <> tbCoverGapFirstRight .Position) or
  (MedienBib.NewCoverFlow.Settings.GapFirstLeft  <> tbCoverGapFirstLeft  .Position) or
  (MedienBib.NewCoverFlow.Settings.AngleRight    <> tbCoverAngleRight    .Position) or
  (MedienBib.NewCoverFlow.Settings.AngleLeft     <> tbCoverAngleLeft     .Position) or
  (MedienBib.NewCoverFlow.Settings.AngleMain     <> tbCoverAngleMain     .Position) or
  (MedienBib.NewCoverFlow.Settings.ViewPosX <> tbCoverViewPosition.Position) or
  (MedienBib.NewCoverFlow.Settings.UseReflection        <> cbCoverFlowUseReflection .Checked) or
	(MedienBib.NewCoverFlow.Settings.ReflexionBlendFaktor <> tbCoverReflexionIntensity.Position) or
	(MedienBib.NewCoverFlow.Settings.GapReflexion         <> tbCoverReflexionGap      .Position) or
  (lblCoverFlowIntensity.Enabled      <> MedienBib.NewCoverFlow.Settings.UseReflection) or
	(lblCoverflowReflexionGap.Enabled   <> MedienBib.NewCoverFlow.Settings.UseReflection) or
	(tbCoverReflexionIntensity.Enabled  <> MedienBib.NewCoverFlow.Settings.UseReflection) or
	(tbCoverReflexionGap.Enabled        <> MedienBib.NewCoverFlow.Settings.UseReflection) or
  (MedienBib.NewCoverFlow.Settings.MaxTextures <> seCoverflowTextureCache.Value) or
  (MedienBib.NewCoverFlow.Settings.DefaultColor <> StringToColorDef(edtCoverFlowColor.Text, clWhite)) or
  (edtCoverFlowColor.Text <> ColorToString(MedienBib.NewCoverFlow.Settings.DefaultColor)) or
  (shapeCoverflowColor.Brush.Color <> MedienBib.NewCoverFlow.Settings.DefaultColor) or
  (ColorDlgCoverflow.Color <> MedienBib.NewCoverFlow.Settings.DefaultColor);
end;
function TOptionsCompleteForm.MediaLibraryConfigurationChanged: Boolean;
begin
    result :=
      fCategoriesChanged or fCollectionsChanged
      or (MedienBib.MissingCoverMode <> teMissingCoverPreSorting(cbMissingCoverMode.ItemIndex))
      or (OrganizerSettings.AlbumKeyMode <> teAlbumKeyMode(cbAlbumKeymode.ItemIndex))
      or (OrganizerSettings.TrimCDFromDirectory <> cbIgnoreCDDirectories.Checked)
      or (OrganizerSettings.SamplerSortingIgnoreReleaseYear <> cbSamplerSortingIgnoreReleaseYear.Checked)
      or (OrganizerSettings.PreferAlbumArtist <> cbPreferAlbumArtist.Checked)
      or (OrganizerSettings.IgnoreVariousAlbumArtists <> cpIgnoreAlbumArtistVariousArtists.Checked)
      or (OrganizerSettings.CDNames.DelimitedText <> editCDNames.Text)
      or (OrganizerSettings.ShowElementCount <> cbShowElementCount.Checked)
      or (OrganizerSettings.ShowCoverArtOnAlbum <> cbShowCoverForAlbum.Checked)
      or (OrganizerSettings.ShowFilesRecursively <> cbShowFilesRecursively.Checked)
      or (OrganizerSettings.CombineLayers <> cbCombineLayers.Checked)
      or (OrganizerSettings.ShowPlaylistCategories <> cbLibConfigShowPlaylistCategories.Checked)
      or (OrganizerSettings.ShowWebradioCategory <> cbLibConfigShowWebRadioCategory.Checked)
      or (OrganizerSettings.PlaylistCaptionMode <> tePlaylistCaptionMode(cbPlaylistCaptionMode.ItemIndex))
      or (OrganizerSettings.PlaylistSorting <> tePlaylistCollectionSorting(cbPlaylistSortMode.ItemIndex))
      or (OrganizerSettings.PlaylistSortDirection <> teSortDirection(cbPlaylistSortDirection.ItemIndex));
end;


procedure TOptionsCompleteForm.FillCategoryComboBoxes;
var
  i: Integer;
begin
  cbDefaultCategory.OnChange := Nil;
  cbNewFilesCategory.OnChange := Nil;

  cbDefaultCategory.Items.Clear;
  cbNewFilesCategory.Items.Clear;

  cbNewFilesCategory.Items.Add(CategoryRecentlyAddedEmpty);
  for i := 0 to FileCategories.Count - 1 do begin
    cbDefaultCategory.Items.Add(FileCategories[i].Caption);
    cbNewFilesCategory.Items.Add(FileCategories[i].Caption);
  end;

  cbDefaultCategory.ItemIndex := GetDefaultCategoryIndex(FileCategories);
  cbNewFilesCategory.ItemIndex := GetNewCategoryIndex(FileCategories) + 1;

  cbDefaultCategory.OnChange := cbDefaultCategoryChange;
  cbNewFilesCategory.OnChange := cbNewFilesCategoryChange;
end;

procedure TOptionsCompleteForm.FillCategoryTree;
var
  i: Integer;
begin
  VSTCategories.BeginUpdate;
  VSTCategories.Clear;
  for i := 0 to FileCategories.Count - 1 do
    VSTCategories.AddChild(Nil, FileCategories[i]);

  if FileCategories.Count > 0 then begin
    VSTCategories.FocusedNode := VSTCategories.GetFirst;
    VSTCategories.Selected[VSTCategories.GetFirst] := True;
  end;
  VSTCategories.EndUpdate;
end;

procedure TOptionsCompleteForm.FillCollectionTree;
var
  i, iLevel: Integer;
  newNode: PVirtualNode;
begin
  VSTSortings.BeginUpdate;
  VSTSortings.Clear;
  for i := 0 to RootCollections.Count - 1 do begin
    NewNode := VSTSortings.AddChild(nil, RootCollections[i]);
    for iLevel := 0 to TRootCollection(RootCollections[i]).LayerDepth - 1 do
      newNode := VSTSortings.AddChild(newNode, RootCollections[i]);
  end;

  VSTSortings.FullExpand;
  VSTSortings.EndUpdate;
end;

procedure TOptionsCompleteForm.FillCoverFlowSortingLabel(aConfig: TCollectionConfig);
var
  s: String;
begin
  s := _(CollectionSortingNames[aConfig.PrimarySorting]);
  if aConfig.SecondarySorting <> csDefault then begin
    s := s + ', ' + _(CollectionSortingNames[aConfig.SecondarySorting]);
    if aConfig.TertiarySorting <> csDefault then
      s := s + ', ' + _(CollectionSortingNames[aConfig.TertiarySorting]);
  end;
  edtCoverFlowSortings.Text := s;
end;

procedure TOptionsCompleteForm.RefreshCategoryButtons;
begin
  ActionAddCategory.Enabled := FileCategories.Count < 32;
  ActionDeleteCategory.Enabled  := FileCategories.Count > 1;
end;

procedure TOptionsCompleteForm.RefreshLayerActions(Node: PVirtualNode;
  rc: TRootCollection);
var
  nLevel: Integer;
begin
  nLevel := VSTSortings.GetNodeLevel(Node);
  ActionEditLayer.Enabled := nLevel > 0;
  ActionAddLayer.Enabled := rc.SpecialContent = scRegular; //NOT rc.IsDirectoryCollection;
  ActionDeleteLayer.Enabled := ((nLevel = 0) and (RootCollections.Count > 1) )or (rc.LayerDepth > 1)
end;

procedure TOptionsCompleteForm.PrepareEditLayerForm(AllowDirectory: Boolean; aConfig: TCollectionConfig);
begin
  if not assigned(FormNewLayer) then
    Application.CreateForm(TFormNewLayer, FormNewLayer);
  FormNewLayer.FillPropertiesSelection(AllowDirectory);
  FormNewLayer.SetDefaultValues(aConfig);// (aType, aSorting);
  FormNewLayer.EditMode := LibraryOrganizer.Configuration.NewLayer.teEdit;
end;

procedure TOptionsCompleteForm.PrepareEditCoverflowForm(aConfig: TCollectionConfig);
begin
  if not assigned(FormNewLayer) then
    Application.CreateForm(TFormNewLayer, FormNewLayer);
  FormNewLayer.FillPropertiesSelection(False);
  FormNewLayer.SetDefaultValues(aConfig);
  FormNewLayer.EditMode := teCoverFlow;
end;

procedure TOptionsCompleteForm.PrepareNewLayerForm(isRoot: Boolean);
begin
  if not assigned(FormNewLayer) then
    Application.CreateForm(TFormNewLayer, FormNewLayer);
  FormNewLayer.FillPropertiesSelection(isRoot);
  FormNewLayer.EditMode := teNew;
end;

function TOptionsCompleteForm.CategoryNameExists(aName: String; Categories: TLibraryCategoryList): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to Categories.Count - 1 do
    if Categories[i].Name = aName then begin
      result := True;
      break;
    end;
end;

procedure TOptionsCompleteForm.CategoryPanelGroupMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
   code: Cardinal;
   i, n: Integer;
begin

  if WheelDelta > 0 then
    code := SB_LINEUP
  else
    code := SB_LINEDOWN;

  n:= Mouse.WheelScrollLines;
  for i:= 1 to n do
    (Sender as TCategoryPanelGroup).Perform(WM_VSCROLL, code, 0);
  (Sender as TCategoryPanelGroup).Perform(WM_VSCROLL, SB_ENDSCROLL, 0);
end;

function TOptionsCompleteForm.CategoryIndexExists(aIndex: Integer; CatEdit, CatLibrary: TLibraryCategoryList): Boolean;
begin
  result := CategoryIndexExists(aIndex, CatEdit);
  if not result then
    result := CategoryIndexExists(aIndex, CatLibrary);
end;

function TOptionsCompleteForm.CategoryIndexExists(aIndex: Integer; Categories: TLibraryCategoryList): Boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to Categories.Count - 1 do
    if Categories[i].Index = aIndex then begin
      result := True;
      break;
    end;
end;

function TOptionsCompleteForm.NewUniqueCategoryName(Categories: TLibraryCategoryList): String;
var
  c: Integer;
begin
  result := rsNewCategoryName;
  c := 0;
  while CategoryNameExists(result, Categories) do begin
    inc(c);
    result := rsNewCategoryName + ' (' + IntToStr(c) + ')';
  end;
end;

function TOptionsCompleteForm.NewUniqueCategoryIndex(CatEdit, CatLibrary: TLibraryCategoryList): Integer;
begin
  result := 0;
  while CategoryIndexExists(result, CatEdit, CatLibrary) do begin
    inc(result);
  end;
end;

procedure TOptionsCompleteForm.EnsureDefaultCategoryIsSet;
begin
  if GetDefaultCategoryIndex(FileCategories) = -1 then
    SetDefaultCategoryIndex(FileCategories, 0);
end;

procedure TOptionsCompleteForm.EnsureNewCategoryIsSet;
begin
  if GetNewCategoryIndex(FileCategories) = -1 then
    SetNewCategoryIndex(FileCategories, -1);
end;

procedure TOptionsCompleteForm.btnCategoryEditClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btnCategoryEdit.ClientToScreen(Point(0,0));
  PopupCategories.Popup(pt.X, pt.Y + btnCategoryEdit.Height);
end;

procedure TOptionsCompleteForm.btnLayerEditClick(Sender: TObject);
var
  pt: TPoint;
begin
  pt := btnLayerEdit.ClientToScreen(Point(0,0));
  PopupLayers.Popup(pt.X, pt.Y + btnLayerEdit.Height);
end;

procedure TOptionsCompleteForm.MoveCategory(Direction: teMoveDirection);
var
  aNode: PVirtualNode;
  curIdx, newIdx: Integer;
begin
  fCategoriesChanged := True;
  aNode := VSTCategories.FocusedNode;
  curIdx := aNode.Index;
  newIdx := getNextIdx(curIdx, Direction);

  if ValidRange(curIdx, newIdx, FileCategories.Count-1) then begin
    FileCategories.Move(curIdx, newIdx);
    case Direction of
      mdUp: VSTCategories.MoveTo(aNode, VSTCategories.GetPreviousSibling(aNode), amInsertBefore, false );
      mdDown: VSTCategories.MoveTo(aNode, VSTCategories.GetNextSibling(aNode), amInsertAfter, false );
    end;
    VSTCategories.Invalidate;
  end;
end;

procedure TOptionsCompleteForm.MoveLayer(Direction: teMoveDirection);
var
  aNode: PVirtualNode;
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;

  fCollectionsChanged := True;
  rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
  level := VSTSortings.GetNodeLevel(aNode);

  if level = 0 then begin
    curIdx := aNode.Index;
    newIdx := getNextIdx(curIdx, Direction);

    if ValidRange(curIdx, newIdx, RootCollections.Count-1) then begin
      RootCollections.Move(curIdx, newIdx);
      case Direction of
        mdUp: VSTSortings.MoveTo(aNode, VSTSortings.GetPreviousSibling(aNode), amInsertBefore, false );
        mdDown: VSTSortings.MoveTo(aNode, VSTSortings.GetNextSibling(aNode), amInsertAfter, false );
      end;
      VSTSortings.Invalidate;
    end;
  end
  else begin
    curIdx := level - 1;
    newIdx := getNextIdx(curIdx, Direction);
    if ValidRange(curIdx, newIdx, rc.LayerDepth-1) then begin
      rc.MoveSubCollectionType(curIdx, newIdx);

      case Direction of
        mdUp: VSTSortings.FocusedNode := aNode.Parent;
        mdDown: VSTSortings.FocusedNode := aNode.FirstChild;
      end;
      VSTSortings.Selected[aNode] := False;
      VSTSortings.Selected[VSTSortings.FocusedNode] := True;

      VSTSortings.Invalidate;
    end;
  end;
end;

procedure TOptionsCompleteForm.cbDefaultCategoryChange(Sender: TObject);
begin
  SetDefaultCategoryIndex(FileCategories, cbDefaultCategory.ItemIndex);
  VSTCategories.Invalidate;
  fCategoriesChanged := True;
end;

procedure TOptionsCompleteForm.cbNewFilesCategoryChange(Sender: TObject);
begin
  SetNewCategoryIndex(FileCategories, cbNewFilesCategory.ItemIndex - 1);
  VSTCategories.Invalidate;
  fCategoriesChanged := True;
end;


procedure TOptionsCompleteForm.PopupCategoriesPopup(Sender: TObject);
var
  aNode: PVirtualNode;
  curIdx, newIdx: Integer;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then begin
    ActionMoveCategoryUp.Enabled := False;
    ActionMoveCategoryDown.Enabled := False;
  end else
  begin
    curIdx := aNode.Index;
    newIdx := getNextIdx(curIdx, mdUp);
    ActionMoveCategoryUp.Enabled := ValidRange(curIdx, newIdx, FileCategories.Count-1);
    newIdx := getNextIdx(curIdx, mdDown);
    ActionMoveCategoryDown.Enabled := ValidRange(curIdx, newIdx, FileCategories.Count-1);
  end;
end;

procedure TOptionsCompleteForm.PopupLayersPopup(Sender: TObject);
var
  aNode: PVirtualNode;
  level, curIdx, newIdx: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then begin
    ActionLayerMoveUp.Enabled := False;
    ActionLayerMoveDown.Enabled := False;
    ActionAddLayer.Enabled := False;
    ActionEditLayer.Enabled := False;
    ActionDeleteLayer.Enabled := False;
  end else begin
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    level := VSTSortings.GetNodeLevel(aNode);

    if level = 0 then begin
      curIdx := aNode.Index;
      newIdx := getNextIdx(curIdx, mdUp);
      ActionLayerMoveUp.Enabled := ValidRange(curIdx, newIdx, RootCollections.Count-1);
      newIdx := getNextIdx(curIdx, mdDown);
      ActionLayerMoveDown.Enabled := ValidRange(curIdx, newIdx, RootCollections.Count-1);
    end
    else begin
      curIdx := level - 1;
      newIdx := getNextIdx(curIdx, mdUp);
      ActionLayerMoveUp.Enabled := ValidRange(curIdx, newIdx, rc.LayerDepth-1);
      newIdx := getNextIdx(curIdx, mdDown);
      ActionLayerMoveDown.Enabled := ValidRange(curIdx, newIdx, rc.LayerDepth-1)
    end;
  end;
end;

{
  ActionAddCategoryExecute
  Add a new Category to the list
}
procedure TOptionsCompleteForm.ActionAddCategoryExecute(Sender: TObject);
var
  newCat: TLibraryFileCategory;
begin
  fCategoriesChanged := True;
  newCat := TLibraryFileCategory.Create;
  newCat.Name := NewUniqueCategoryName(FileCategories);
  newCat.Index := NewUniqueCategoryIndex(self.FileCategories, MedienBib.FileCategories);
  newCat.IsUserDefined := True;
  if newCat.Index < 32 then begin
    FileCategories.Add(newCat);
    VSTCategories.AddChild(Nil, newCat);
  end else
  begin
    newCat.Free;
    TranslateMessageDLG(LibraryOrganizer_NoMoreCategoriesPossible, mtInformation, [MBOK], 0);
  end;

  RefreshCategoryButtons;
  FillCategoryComboBoxes;
end;

{
  ActionAddRootLayerExecute
  Add a new RootLayer to the list
}
procedure TOptionsCompleteForm.ActionAddRootLayerExecute(Sender: TObject);
var
  newRoot: TRootCollection;
  NewNode: PVirtualNode;
  iLevel: Integer;
begin
  PrepareNewLayerForm(True);
  if FormNewLayer.ShowModal = mrOk then begin
    fCollectionsChanged := True;
    newRoot := TRootCollection.Create(Nil);
    newRoot.AddSubCollectionType(FormNewLayer.NewConfig);
    RootCollections.Add(newRoot);
    NewNode := VSTSortings.AddChild(nil, newRoot);
    for iLevel := 0 to TRootCollection(newRoot).LayerDepth - 1 do
      newNode := VSTSortings.AddChild(newNode, newRoot);
  end;
end;

{
  ActionAddLayerExecute
  Add a new Layer to the list
}
procedure TOptionsCompleteForm.ActionAddLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;

  PrepareNewLayerForm(False);
  if FormNewLayer.ShowModal = mrOk then begin
    fCollectionsChanged := True;
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    rc.InsertSubCollectionType(VSTSortings.GetNodeLevel(aNode), FormNewLayer.NewConfig);
    // The data assigned to each node under one RootCollectionNode is all the same, so we can just add a new child
    // at the end of the current subtree and trigger a repaint of the Tree
    while aNode.ChildCount > 0 do
      aNode := aNode.FirstChild;
    VSTSortings.AddChild(aNode, rc);
    VSTSortings.Expanded[aNode] := True;
    VSTSortings.Invalidate;
  end;
end;

{
  ActionDeleteCategoryExecute
  Removes the selected Category from the list
}
procedure TOptionsCompleteForm.ActionDeleteCategoryExecute(Sender: TObject);
var
  aNode, reselectNode: PVirtualNode;
  lc: TLibraryCategory;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCategoriesChanged := True;
  // get the next node that should be selected after the current one is removed
  reselectNode := VSTCategories.GetNextSibling(aNode);
  if not assigned(reselectNode) then
    VSTCategories.GetPreviousSibling(aNode);
  // remove the Category and its node
  lc := VSTCategories.GetNodeData<TLibraryCategory>(aNode);
  VSTCategories.DeleteNode(aNode);
  FileCategories.Remove(lc);
  lc.Free;
  // select another node
  if assigned(reselectNode) then begin
    VSTCategories.FocusedNode := reselectNode;
    VSTCategories.Selected[reselectNode] := True;
  end;
  EnsureDefaultCategoryIsSet;
  EnsureNewCategoryIsSet;
  RefreshCategoryButtons;
  FillCategoryComboBoxes;
end;

{
  ActionDeleteLayerExecute
  Removes the selected Layer from the list
}
procedure TOptionsCompleteForm.ActionDeleteLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  level: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCollectionsChanged := True;
  level := VSTSortings.GetNodeLevel(aNode);
  if level = 0 then begin
    // delete the RootCollection
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    VSTSortings.DeleteNode(aNode);
    VSTSortings.Invalidate;
    RootCollections.Remove(rc);
    rc.Free;
  end else
  begin
    // delete a sub-layer from the RootCollection
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    // delete the node first (i.e. the last child in this subtree)
    while aNode.ChildCount > 0 do
      aNode := aNode.FirstChild;
    VSTSortings.DeleteNode(aNode);
    // delete the collection layer
    rc.RemoveSubCollection(level-1);
    VSTSortings.Invalidate;
  end;
end;

procedure TOptionsCompleteForm.ActionEditCategoryExecute(Sender: TObject);
var
  aNode: PVirtualNode;
begin
  aNode := VSTCategories.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCategoriesChanged := True;
  VSTCategories.EditNode(aNode, 0);
end;

procedure TOptionsCompleteForm.ActionEditLayerExecute(Sender: TObject);
var
  aNode: PVirtualNode;
  level: Integer;
  rc: TRootCollection;
begin
  aNode := VSTSortings.FocusedNode;
  if not assigned(aNode) then
    exit;
  fCollectionsChanged := True;
  level := VSTSortings.GetNodeLevel(aNode);
  if level > 0 then begin
    rc := VSTSortings.GetNodeData<TRootCollection>(aNode);
    PrepareEditLayerForm(rc.LayerDepth <= 1, rc.CollectionConfigList[level-1] );
    if FormNewLayer.ShowModal = mrOk then begin
      rc.ChangeSubCollectionType(level-1, FormNewLayer.NewConfig );
      RefreshLayerActions(aNode, rc);
      VSTSortings.Invalidate;
    end;
  end;
end;

procedure TOptionsCompleteForm.ActionLayerMoveDownExecute(Sender: TObject);
begin
  MoveLayer(mdDown);
end;

procedure TOptionsCompleteForm.ActionLayerMoveUpExecute(Sender: TObject);
begin
  MoveLayer(mdUp);
end;

procedure TOptionsCompleteForm.ActionMoveCategoryDownExecute(Sender: TObject);
begin
  MoveCategory(mdDown);
end;

procedure TOptionsCompleteForm.ActionMoveCategoryUpExecute(Sender: TObject);
begin
  MoveCategory(mdUp);
end;


procedure TOptionsCompleteForm.btnEditCoverflowClick(Sender: TObject);
begin
  PrepareEditCoverflowForm(OrganizerSettings.CoverFlowRootCollectionConfig[0]);
  if FormNewLayer.ShowModal = mrOk then begin
    fCollectionsChanged := True;

    OrganizerSettings.CoverFlowRootCollectionConfig[0] := FormNewLayer.NewConfig;
    FillCoverFlowSortingLabel(OrganizerSettings.CoverFlowRootCollectionConfig[0]);
  end;
end;

procedure TOptionsCompleteForm.VSTCategoriesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
   CellText := Sender.GetNodeData<TLibraryCategory>(Node).Caption;
end;

procedure TOptionsCompleteForm.VSTCategoriesEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TOptionsCompleteForm.VSTCategoriesNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  lc: TLibraryCategory;
begin
  lc := Sender.GetNodeData<TLibraryCategory>(Node);
  lc.Name := NewText;
  lc.IsUserDefined := True;
  fCategoriesChanged := True;
end;

procedure TOptionsCompleteForm.VSTCategoriesPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;

procedure TOptionsCompleteForm.VSTCategoriesDragAllowed(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TOptionsCompleteForm.VSTCategoriesDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := Source = VSTCategories;
end;

procedure TOptionsCompleteForm.VSTCategoriesDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  aNode, focusNode: PVirtualNode;
  lc: TLibraryCategory;
begin
  fCategoriesChanged := True;
  focusNode := VSTCategories.FocusedNode;
  case Mode of
    dmNowhere: VSTCategories.MoveTo(focusNode, VSTCategories.RootNode, amInsertAfter, False);
    dmAbove: VSTCategories.MoveTo(focusNode, VSTCategories.DropTargetNode, amInsertBefore, False);
    dmOnNode,
    dmBelow: VSTCategories.MoveTo(focusNode, VSTCategories.DropTargetNode, amInsertAfter, False);
  end;
  VSTCategories.Invalidate;

  // Fill the FileCategories according to the new Node order.
  // Don't use "Move" here, as Index-Calculation would be a lot trickier here
  aNode := Sender.GetFirst;
  while assigned(aNode) do begin
    lc := Sender.GetNodeData<TLibraryCategory>(aNode);
    FileCategories[aNode.Index] := lc;
    aNode := Sender.GetNextSibling(aNode);
  end;
end;

procedure TOptionsCompleteForm.VSTSortingsGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
var
  rc: TRootCollection;
  aConfig: TCollectionConfig;
  level: Integer;
begin
  rc := Sender.GetNodeData<TRootCollection>(Node);
  level := Sender.GetNodeLevel(Node);

  if level = 0 then begin
    HintText := Format(LibConfigHint_Root, [rc.Caption]);
  end else
  begin
    aConfig := rc.CollectionConfigList[level-1];

    HintText := Format(LibConfigHint_LayerMain, [rc.LevelCaption[level-1]])
      + #13#10 + LibConfigHint_LayerSorting + #13#10;

    if aConfig.PrimarySorting = csDefault then
      HintText := HintText + _(CollectionSorting_Default)
    else
    begin
      HintText := HintText + _(CollectionSortingNames[aConfig.PrimarySorting]);
      if aConfig.SecondarySorting <> csDefault then begin
        HintText := HintText + #13#10 + _(CollectionSortingNames[aConfig.SecondarySorting]);
        if aConfig.TertiarySorting <> csDefault then
          HintText := HintText + #13#10 + _(CollectionSortingNames[aConfig.TertiarySorting]);
      end;
    end;
  end;

end;

procedure TOptionsCompleteForm.VSTSortingsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  rc: TRootCollection;
  level: Integer;
begin
  rc := Sender.GetNodeData<TRootCollection>(Node);

  level := Sender.GetNodeLevel(Node);
  if Level = 0 then
    CellText := rc.Caption
  else begin
    if rc.GetCollectionCompareType(level-1) = csDefault then
      CellText := rc.LevelCaption[level-1]
    else
      CellText := Format(LibConfigText_LayerSortedBy, [rc.LevelCaption[level-1], _(CollectionSortingNames[rc.GetCollectionCompareType(level-1)]) ])

       //CellText + ' (' + _(CollectionSortingNames[rc.GetCollectionCompareType(level-1)])  + ')';
  end;
end;

procedure TOptionsCompleteForm.VSTSortingsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;

procedure TOptionsCompleteForm.VSTSortingsFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if not assigned(Node) then exit;
  RefreshLayerActions(Node, Sender.GetNodeData<TRootCollection>(Node));
end;

procedure TOptionsCompleteForm.VSTSortingsDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
  rcD: TRootCollection;
begin
  rcD := Sender.GetNodeData<TRootCollection>(Node);
  Allowed := (Sender.GetNodeLevel(Node) = 0) or (rcD.LayerDepth > 1);
end;

procedure TOptionsCompleteForm.VSTSortingsDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
  rcF, rcD: TRootCollection;
begin
  Accept := Source = VSTSortings;
  if not accept then
    exit;  // nothing more to test

  rcF := Sender.GetNodeData<TRootCollection>(Sender.FocusedNode);
  if assigned(Sender.DropTargetNode) then
    rcD := Sender.GetNodeData<TRootCollection>(Sender.DropTargetNode)
  else
    rcD := Sender.GetNodeData<TRootCollection>(Sender.GetLast);

  // Accept within the same RootCollection ( => change Layer order)
  // or move the complete RootCollection (=> Change order of RootCollections)
  accept := (rcF = rCD) or (Sender.GetNodeLevel(Sender.FocusedNode) = 0);
end;

procedure TOptionsCompleteForm.VSTSortingsDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  rcF, rcD: TRootCollection;
  focusNode, aNode, DropRoot: PVirtualNode;
  curIdx, targetIdx, idxModifier: Integer;
begin
  rcF := Sender.GetNodeData<TRootCollection>(Sender.FocusedNode);
  fCollectionsChanged := True;

  focusNode := Sender.FocusedNode;
  DropRoot := VSTSortings.DropTargetNode;
  while Sender.GetNodeLevel(DropRoot) > 0 do
    DropRoot := DropRoot.Parent;

  if (Sender.GetNodeLevel(focusNode) = 0) then begin
    // correct DropMode if the user drops a "Level-0-Node" over a node which higher level
    if assigned(VSTSortings.DropTargetNode) then begin
      if (DropRoot.Index < focusNode.Index) and (Sender.GetNodeLevel(VSTSortings.DropTargetNode) > 0)  then
        Mode := dmAbove;
      if (DropRoot.Index > focusNode.Index) and (Sender.GetNodeLevel(VSTSortings.DropTargetNode) > 0) then
        Mode := dmBelow;
    end;
    // Move the RootCollection to another position in the list
    case Mode of
      dmNowhere: VSTSortings.MoveTo(focusNode, VSTSortings.RootNode, amInsertAfter, False);
      dmAbove: VSTSortings.MoveTo(focusNode, DropRoot, amInsertBefore, False);
      dmOnNode,
      dmBelow: VSTSortings.MoveTo(focusNode, DropRoot, amInsertAfter, False);
    end;
    // Fill the Category-Layers according to the new Node order.
    aNode := Sender.GetFirst;
    while assigned(aNode) do begin
      rcD := Sender.GetNodeData<tRootCollection>(aNode);
      RootCollections[aNode.Index] := rcD;
      aNode := Sender.GetNextSibling(aNode);
    end;
  end else
  begin
    // we are moving a Layer within the same RootCollection
    curIdx := Sender.GetNodeLevel(focusNode) - 1;
    targetIdx := Sender.GetNodeLevel(VSTSortings.DropTargetNode) - 1;
    // modify the targetIdx according to Drop-Direction
    if (targetIdx < curIdx) then
      idxModifier := 1
    else
      idxModifier := 0;

    case Mode of
      dmNowhere: targetIdx := rcF.LayerDepth - 1;
      dmAbove: targetIdx := targetIdx + idxModifier - 1;
      dmOnNode,
      dmBelow: targetIdx := targetIdx + idxModifier;
    end;

    if targetIdx < 0 then
      targetIdx := 0;

    rcF.MoveSubCollectionType(curIdx, targetIdx);

    // Repaint the tree and set the focussed node to the just moved node
    VSTSortings.Invalidate;
    aNode := DropRoot;
    while assigned(aNode) and (Sender.GetNodeLevel(aNode) <= targetIdx) do
      aNode := aNode.FirstChild;
    Sender.FocusedNode := aNode;
    Sender.Selected[aNode] := True;
  end;

end;

{$ENDREGION}


end.

