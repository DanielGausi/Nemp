{

    Unit OptionsComplete
    Form OptionsCompleteForm

    - Settings-Form.
      Three longer methods (Create, Show, Apply),
      Many Enable/Disable-Controls-Stuff
      Message-Handler for ScobblerUtils-Setup

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
unit OptionsComplete;

interface

{$I xe.inc}

uses
  Windows, Messages, SysUtils,  Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees,  ComCtrls, StdCtrls, Spin, CheckLst, ExtCtrls, shellapi,
  DateUtils,  IniFiles, jpeg, PNGImage, GifImg, math,
  bass, fldbrows, StringHelper, MainFormHelper,

   NempAudioFiles, Spectrum_vis, Hilfsfunktionen, Systemhelper, TreeHelper,
  CoverHelper, U_Charcode,
  Nemp_SkinSystem, UpdateUtils,

  Nemp_ConstantsAndTypes, filetypes,   Buttons,
  gnuGettext, languageCodes, 
  Nemp_RessourceStrings,  ScrobblerUtils, ExtDlgs, NempCoverFlowClass,
  SkinButtons, NempPanel, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, MyDialogs
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF};

type

  //TVirtualStringTree = VirtualTrees.TVirtualStringTree;

  //TGroupbox = StdCtrls.TGroupBox;

  TOptionsCompleteForm = class(TForm)
    OptionsVST: TVirtualStringTree;
    TabView0: TTabSheet;
    TabSystem0: TTabSheet;
    BTNok: TButton;
    BTNCancel: TButton;
    BTNApply: TButton;
    ColorDialog1: TColorDialog;
    PageControl1: TPageControl;
    TabPlayer0: TTabSheet;
    TabSystem2: TTabSheet;
    TabView3: TTabSheet;
    GrpBox_Fonts: TGroupBox;
    LblConst_FontVBR: TLabel;
    LblConst_FontCBR: TLabel;
    CBChangeFontStyleOnMode: TCheckBox;
    CBChangeFontOnCbrVbr: TCheckBox;
    CBFontNameVBR: TComboBox;
    CBFontNameCBR: TComboBox;
    TabPlayer5: TTabSheet;
    TabSystem3: TTabSheet;
    BtnRegistryUpdate: TButton;
    TabSystem1: TTabSheet;
    GrpBox_TaskTray: TRadioGroup;
    GrpBox_MickyMouse: TRadioGroup;
    GrpBox_Deskband: TGroupBox;
    CBShowDeskbandOnStart: TCheckBox;
    CBShowDeskbandOnMinimize: TCheckBox;
    CBHideDeskbandOnRestore: TCheckBox;
    CBHideDeskbandOnClose: TCheckBox;
    GrpBox_Effects: TGroupBox;
    CB_UseDefaultEffects: TCheckBox;
    CB_UseDefaultEqualizer: TCheckBox;
    TabPlayer2: TTabSheet;
    GrpBox_PlaylistBehaviour: TGroupBox;
    CB_AutoSavePlaylist: TCheckBox;
    CB_AutoScanPlaylist: TCheckBox;
    TabView4: TTabSheet;
    TabFiles0: TTabSheet;
    TabFiles4: TTabSheet;
    GrpBox_TabMedia5_ID3: TGroupBox;
    CBAutoDetectCharCode: TCheckBox;
    GrpBox_TabMedia5_Charsets: TGroupBox;
    LblConst_Arabic: TLabel;
    LblConst_hebrew: TLabel;
    LblConst_cyrillic: TLabel;
    LblConst_Thai: TLabel;
    LblConst_Korean: TLabel;
    LblConst_Chinese: TLabel;
    LblConst_Greek: TLabel;
    LblConst_Japanese: TLabel;
    TabPlayer6: TTabSheet;
    GrpBox_TabAudio7_Countdown: TGroupBox;
    lblCountDownTitel: TLabel;
    CBStartCountDown: TCheckBox;
    BtnCountDownSong: TButton;
    BtnGetCountDownTitel: TButton;
    GrpBox_TabAudio7_Event: TGroupBox;
    Lbl_Const_EventTime: TLabel;
    lblBirthdayTitel: TLabel;
    DTPBirthdayTime: TDateTimePicker;
    BtnBirthdaySong: TButton;
    BtnGetBirthdayTitel: TButton;
    CBContinueAfter: TCheckBox;
    TabView2: TTabSheet;
    LBlCountDownWarning: TLabel;
    LblEventWarning: TLabel;
    GrpBox_Hotkeys: TGroupBox;
    CB_Activate_Play: TCheckBox;
    CB_Activate_Stop: TCheckBox;
    CB_Activate_JumpBack: TCheckBox;
    CB_Activate_Prev: TCheckBox;
    CB_Activate_Next: TCheckBox;
    CB_Activate_JumpForward: TCheckBox;
    CB_Activate_IncVol: TCheckBox;
    CB_Activate_DecVol: TCheckBox;
    CB_Activate_Mute: TCheckBox;
    TabPlayer4: TTabSheet;
    GrpBox_WebradioRecording: TGroupBox;
    LblConst_DownloadDir: TLabel;
    BtnChooseDownloadDir: TButton;
    cbAutoSplitByTitle: TCheckBox;
    LblConst_FilenameFormat: TLabel;
    LblConst_FilenameExtension: TLabel;
    Btn_InstallDeskband: TButton;
    Btn_UninstallDeskband: TButton;
    TabFiles2: TTabSheet;
    CB_JumpToNextCue: TCheckBox;
    TabFiles3: TTabSheet;
    GrpBox_TabMedia4_GlobalSearchOptions: TGroupBox;
    CB_AccelerateSearch: TCheckBox;
    LblConst_AccelerateSearchNote: TLabel;
    GrpBox_TabMedia4_QuickSearchOptions: TGroupBox;
    CB_QuickSearchWhileYouType: TCheckBox;
    CB_QuickSearchAllowErrorsWhileTyping: TCheckBox;
    CB_QuickSearchAllowErrorsOnEnter: TCheckBox;
    CB_AccelerateSearchIncludePath: TCheckBox;
    CB_AccelerateSearchIncludeComment: TCheckBox;
    LblConst_AccelerateSearchNote2: TLabel;
    CB_AccelerateLyricSearch: TCheckBox;
    LblConst_QuickSearchNote: TLabel;
    cbAutoSplitByTime: TCheckBox;
    LblConst_MaxSize: TLabel;
    SE_AutoSplitMaxSize: TSpinEdit;
    cbAutoSplitBySize: TCheckBox;
    SE_AutoSplitMaxTime: TSpinEdit;
    LblConst_MaxTime: TLabel;
    LblConst_WebradioNote: TLabel;
    LblConst_WebradioHint: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GrpBox_FontSizePreselection: TGroupBox;
    Label34: TLabel;
    Label32: TLabel;
    SEArtistAlbenRowHeight: TSpinEdit;
    SEArtistAlbenSIze: TSpinEdit;
    GrpBox_FontSize: TGroupBox;
    LblConst_RowHeight: TLabel;
    LblConst_BasicFontSize: TLabel;
    SERowHeight: TSpinEdit;
    SEFontSize: TSpinEdit;
    GrpBox_NempUpdater: TGroupBox;
    CB_AutoCheck: TCheckBox;
    Btn_CHeckNowForUpdates: TButton;
    GrpBox_StartingNemp: TGroupBox;
    CB_AllowMultipleInstances: TCheckBox;
    CBRegisterHotKeys: TCheckBox;
    GrpBox_MultimediaKeys: TGroupBox;
    GrpBox_FileFormats: TGroupBox;
    lbl_AudioFormats: TLabel;
    CBFileTypes: TCheckListBox;
    lbl_PlaylistFormats: TLabel;
    CBPlaylistTypes: TCheckListBox;
    Btn_SelectAll: TButton;
    GrpBoxFileFormatOptions: TGroupBox;
    CBEnqueueStandard: TCheckBox;
    CBEnqueueStandardLists: TCheckBox;
    CBDirectorySupport: TCheckBox;
    CB_AutoPlayNewTitle: TCheckBox;
    CB_SavePositionInTrack: TCheckBox;
    CB_AutoPlayOnStart: TCheckBox;
    GrpBox_ViewVis_Scrolling: TGroupBox;
    Lbl_Framerate: TLabel;
    CB_visual: TCheckBox;
    TB_Refresh: TTrackBar;
    CB_ScrollTitelTaskBar: TCheckBox;
    CB_ScrollTitleInMainWindow: TCheckBox;
    GrpBox_Devices: TGroupBox;
    LblConst_MainDevice: TLabel;
    LblConst_Headphones: TLabel;
    GrpBox_TabAudio2_Fading: TGroupBox;
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
    GrpBox_Jingles: TGroupBox;
    LblJingleReduce: TLabel;
    LblConst_JingleVolume: TLabel;
    LblConst_JingleVolumePercent: TLabel;
    CBJingleReduce: TCheckBox;
    SEJingleReduce: TSpinEdit;
    SEJingleVolume: TSpinEdit;
    GrpBox_FilesMain_Directories: TGroupBox;
    CBAutoScan: TCheckBox;
    BtnAutoScanAdd: TButton;
    BtnAutoScanDelete: TButton;
    CBAutoAddNewDirs: TCheckBox;
    CBAskForAutoAddNewDirs: TCheckBox;
    GrpBox_FilesMain_FileTypes: TGroupBox;
    LblConst_OnlythefollowingTypes: TLabel;
    cbIncludeAll: TCheckBox;
    CB_IgnoreVolume: TCheckBox;
    CB_AutoCheckNotifyOnBetas: TCheckBox;
    TabPlayer7: TTabSheet;
    GrpBox_Scrobble: TGroupBox;
    LblScrobble1: TLabel;
    BtnScrobbleWizard: TButton;
    GrpBox_ScrobbleLog: TGroupBox;
    GrpBox_ScrobbleSettings: TGroupBox;
    CB_AlwaysScrobble: TCheckBox;
    CB_SilentError: TCheckBox;
    CB_ScrobbleThisSession: TCheckBox;
    Label5: TLabel;
    Btn_ScrobbleAgain: TButton;
    Image2: TImage;
    LblVisitLastFM: TLabel;
    GrpBox_TabulatorOptions: TGroupBox;
    CB_TabStopAtPlayerControls: TCheckBox;
    CB_TabStopAtTabs: TCheckBox;
    OpenDlg_CountdownSongs: TOpenDialog;
    EdtDownloadDir: TEdit;
    EditCountdownSong: TEdit;
    EditBirthdaySong: TEdit;
    CBBOX_UpdateInterval: TComboBox;
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
    CB_TaskBarDelay: TComboBox;
    CB_AnzeigeDelay: TComboBox;
    HeadphonesDeviceCB: TComboBox;
    MainDeviceCB: TComboBox;
    cbFilenameFormat: TComboBox;
    CBArabic: TComboBox;
    CBChinese: TComboBox;
    CBHebrew: TComboBox;
    CBJapanese: TComboBox;
    CBGreek: TComboBox;
    CBKorean: TComboBox;
    CBCyrillic: TComboBox;
    CBThai: TComboBox;
    MemoScrobbleLog: TMemo;
    OpenDlg_DefaultCover: TOpenPictureDialog;
    LBAutoscan: TListBox;
    RGroup_Playlist: TRadioGroup;
    TabPlayer8: TTabSheet;
    GrpBoxConfig: TGroupBox;
    BtnServerActivate: TButton;
    cbOnlyLAN: TCheckBox;
    GrpBoxIP: TGroupBox;
    LblConst_IPWAN: TLabel;
    LabelLANIP: TLabel;
    BtnGetIPs: TButton;
    cbLANIPs: TComboBox;
    EdtGlobalIP: TEdit;
    IDHttpWebServerGetIP: TIdHTTP;
    CBAutoStartWebServer: TCheckBox;
    TabView1: TTabSheet;
    GrpBox_ViewPartymode_Amplification: TGroupBox;
    Lbl_PartyMode_ResizeFactor: TLabel;
    CB_PartyMode_ResizeFactor: TComboBox;
    TabFiles1: TTabSheet;
    GrpBox_AutoRating: TGroupBox;
    cb_RatingActive: TCheckBox;
    cb_RatingIgnoreShortFiles: TCheckBox;
    cb_RatingChangeCounter: TCheckBox;
    cb_RatingIncreaseRating: TCheckBox;
    cb_RatingDecreaseRating: TCheckBox;
    StaticText1: TLabel;
    StaticText2: TLabel;
    CB_RememberInterruptedPlayPosition: TCheckBox;
    LblTaskbarWin7: TLabel;
    cbIncludeFiles: TCheckListBox;
    CBChangeFontColoronBitrate: TCheckBox;
    GrpBox_ViewVis_CoverDetails: TGroupBox;
    LblConst_CoverMode: TLabel;
    LblConst_DetailMode: TLabel;
    cbCoverMode: TComboBox;
    cbDetailMode: TComboBox;
    cb_ChangeCoverflowOnSearch: TCheckBox;
    LblWebServer_Port: TLabel;
    seWebServer_Port: TSpinEdit;
    cbUseStreamnameAsDirectory: TCheckBox;
    cb_RegisterMediaHotkeys: TCheckBox;
    GrpBox_Metadata: TGroupBox;
    cb_AccessMetadata: TCheckBox;
    Lbl_QuickMetadataHint: TLabel;
    GrpBox_CDAudio: TGroupBox;
    cb_UseCDDB: TCheckBox;
    BtnRefreshDevices: TButton;
    cbWebserverRootDir: TComboBox;
    LblWebServerTheme: TLabel;
    Label7: TLabel;
    EdtUsernameAdmin: TEdit;
    Label8: TLabel;
    EdtPasswordAdmin: TEdit;
    GrpBoxWebserverUserRights: TGroupBox;
    cbAllowRemoteControl: TCheckBox;
    cbPermitVote: TCheckBox;
    cbPermitLibraryAccess: TCheckBox;
    cbPermitPlaylistDownload: TCheckBox;
    LblConst_Username2: TLabel;
    EdtUsername: TEdit;
    LblConst_Password2: TLabel;
    EdtPassword: TEdit;
    BtnShowWebserverLog: TButton;
    LblWebserverAdminURL: TLabel;
    LblWebserverUserURL: TLabel;
    GrpBox_TabAudio2_Silence: TGroupBox;
    CB_SilenceDetection: TCheckBox;
    Lbl_SilenceThreshold: TLabel;
    SE_SilenceThreshold: TSpinEdit;
    Lbl_SilenceDB: TLabel;
    CB_AutoPlayEnqueueTitle: TCheckBox;
    GrpBox_StartingExtended: TGroupBox;
    CBAutoLoadMediaList: TCheckBox;
    CBAutoSaveMediaList: TCheckBox;
    cb_ShowSplashScreen: TCheckBox;
    CB_StartMinimized: TCheckBox;
    cb_StayOnTop: TCheckBox;
    GrpBox_ViewMain_Columns: TGroupBox;
    GrpBox_ViewMain_BrowseClassic: TGroupBox;
    Label44: TLabel;
    CBSortArray1: TComboBox;
    CBSortArray2: TComboBox;
    GrpBox_ViewMain_Sorting: TGroupBox;
    CBAlwaysSortAnzeigeList: TCheckBox;
    CBSkipSortOnLargeLists: TCheckBox;
    GrpBox_TabMedia3_Cover: TGroupBox;
    CB_CoverSearch_inDir: TCheckBox;
    CB_CoverSearch_inSubDir: TCheckBox;
    CB_CoverSearch_inParentDir: TCheckBox;
    CB_CoverSearch_inSisterDir: TCheckBox;
    EDTCoverSubDirName: TEdit;
    EDTCoverSisterDirName: TEdit;
    GrpBox_Files_Cover_LastFM: TGroupBox;
    CB_CoverSearch_LastFM: TCheckBox;
    BtnClearCoverCache: TButton;
    GrpBox_FilesMain_Playlists: TGroupBox;
    CBAutoScanPlaylistFilesOnView: TCheckBox;
    TabSystem4: TTabSheet;
    GrpBox_ViewMain_BrowseCoverflow: TGroupBox;
    Label61: TLabel;
    Label6: TLabel;
    cbCoverSortOrder: TComboBox;
    cbMissingCoverMode: TComboBox;
    cbHideNACover: TCheckBox;
    LblNACoverHint: TLabel;
    Label9: TLabel;
    GrpBox_ViewPartymode_Functions: TGroupBox;
    GrpBox_ViewPartymode_Password: TGroupBox;
    cb_PartyMode_BlockTreeEdit: TCheckBox;
    cb_PartyMode_BlockCurrentTitleRating: TCheckBox;
    cb_PartyMode_BlockTools: TCheckBox;
    Edt_PartyModePassword: TLabeledEdit;
    cb_PartyMode_ShowPasswordOnActivate: TCheckBox;
    GrpBox_ViewExt_NoMetadata: TGroupBox;
    LblReplaceArtistBy: TLabel;
    LblReplaceTitletBy: TLabel;
    LblReplaceAlbumBy: TLabel;
    cbReplaceArtistBy: TComboBox;
    cbReplaceTitleBy: TComboBox;
    cbReplaceAlbumBy: TComboBox;
    GrpBox_ViewExt_Select: TGroupBox;
    CBFullRowSelect: TCheckBox;
    CB_EditOnClick: TCheckBox;
    GrpBox_ViewExt_Hints: TGroupBox;
    CBShowHintsInMedialist: TCheckBox;
    CB_ShowHintsInPlaylist: TCheckBox;
    TabPlayer1: TTabSheet;
    GrpBox_ExtendedAudio: TGroupBox;
    LblConst_Buffersize: TLabel;
    LblConst_ms: TLabel;
    LblConst_UseFloatingPoint: TLabel;
    LblConst_Mixing: TLabel;
    Lbl_FloatingPoints_Status: TLabel;
    SEBufferSize: TSpinEdit;
    CB_FloatingPoint: TComboBox;
    CB_Mixing: TComboBox;
    _XXX_cb_SettingsMode: TComboBox;
    GrpBox_PlayerExt_SafePlayback: TGroupBox;
    cb_SafePlayback: TCheckBox;
    GrpBox_HeadsetBehaviour: TGroupBox;
    GrpBox_DefaultAction: TComboBox;
    Label10: TLabel;
    GroupBox1: TGroupBox;
    cb_UseWalkmanMode: TCheckBox;
    BtnRecommendedFiletypes: TButton;
    grpBoxUseAdvancedSkin: TGroupBox;
    cbUseAdvancedSkin: TCheckBox;
    cb_UseG15Display: TCheckBox;
    cb_ReplayCue: TCheckBox;
    GrpBox_Hibernate: TGroupBox;
    LBlConst_ReInitPlayerEngine_Hint: TLabel;
    cbPauseOnSuspend: TCheckBox;
    cbReInitAfterSuspend: TCheckBox;
    Btn_ReinitPlayerEngine: TButton;
    GrpBox_BetaOptions: TGroupBox;
    XXX_CB_BetaDontUseThreadedUpdate: TCheckBox;
    GrpBox_RandomOptions: TGroupBox;
    LblConst_ReallyRandom: TLabel;
    LblConst_AvoidRepetitions: TLabel;
    TBRandomRepeat: TTrackBar;
    GrpBox_PlayerExt2_Playlist: TGroupBox;
    CB_AutoMixPlaylist: TCheckBox;
    CB_DisableAutoDeleteAtUserInput: TCheckBox;
    CB_AutoDeleteFromPlaylist: TCheckBox;
    LblHeadsetDefaultAction: TLabel;
    GrpBox_HeadsetDefaultAction: TComboBox;
    cb_AutoStopHeadset: TCheckBox;
    GrpBox_Files_Cover_Default: TGroupBox;
    lbl_DefaultCover: TLabel;
    img_DefaultCover: TImage;
    lbl_DefaultCoverHint: TLabel;
    btn_DefaultCover: TButton;
    btn_DefaultCoverReset: TButton;
    GrpBox_ViewVis_CoverFlow: TGroupBox;
    cb_UseClassicCoverflow: TCheckBox;
    cbFixCoverFlowOnStart: TCheckBox;
    cb_Medialist_FontStyle: TComboBox;
    lbl_Medialist_FontStyle: TLabel;
    lbl_Browselist_FontStyle: TLabel;
    cb_Browselist_FontStyle: TComboBox;
    CBChangeFontSizeOnLength: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure OptionsVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormDestroy(Sender: TObject);
    procedure OptionsVSTGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
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
    procedure cbSkinAuswahlChange(Sender: TObject);
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
    procedure CB_Activate_PlayClick(Sender: TObject);
    procedure CB_Activate_StopClick(Sender: TObject);
    procedure CB_Activate_NextClick(Sender: TObject);
    procedure CB_Activate_PrevClick(Sender: TObject);
    procedure CB_Activate_JumpForwardClick(Sender: TObject);
    procedure CB_Activate_JumpBackClick(Sender: TObject);
    procedure CB_Activate_IncVolClick(Sender: TObject);
    procedure CB_Activate_DecVolClick(Sender: TObject);
    procedure CB_Activate_MuteClick(Sender: TObject);
    procedure CBRegisterHotKeysClick(Sender: TObject);
    procedure cbFilenameFormatChange(Sender: TObject);
    procedure BtnChooseDownloadDirClick(Sender: TObject);
    procedure Btn_InstallDeskbandClick(Sender: TObject);
    procedure Btn_UninstallDeskbandClick(Sender: TObject);
    procedure CB_AccelerateSearchClick(Sender: TObject);
    //procedure Btn_DeleteCustomCoverClick(Sender: TObject);
    //procedure Btn_Edit_CustomCoverClick(Sender: TObject);
    //procedure LV_Select_DefaultCoverChange(Sender: TObject;
    //  Item: TListItem; Change: TItemChange);
    //procedure cb_UseDefaultCoversClick(Sender: TObject);
    //procedure cb_CustomizeAllFilesCoverClick(Sender: TObject);
    procedure CB_AutoCheckClick(Sender: TObject);
    procedure Btn_CHeckNowForUpdatesClick(Sender: TObject);
    procedure cbAutoSplitBySizeClick(Sender: TObject);
    procedure cbAutoSplitByTimeClick(Sender: TObject);
    procedure CB_ScrollTitelTaskBarClick(Sender: TObject);
    procedure CB_ScrollTitleInMainWindowClick(Sender: TObject);
    procedure ResetScrobbleButton;
    Procedure SetScrobbleButtonOnError;
    procedure InitScrobblerWizard;
    procedure BtnScrobbleWizardClick(Sender: TObject);
    procedure Btn_ScrobbleAgainClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure NewPlayerPanelOptionsPaint(Sender: TObject);
    procedure BtnServerActivateClick(Sender: TObject);
    procedure EdtUsernameKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure BtnGetIPsClick(Sender: TObject);
    procedure cbOnlyLANClick(Sender: TObject);
    procedure cbPermitPlaylistDownloadClick(Sender: TObject);
    procedure cbPermitLibraryAccessClick(Sender: TObject);
    procedure cbAllowRemoteControlClick(Sender: TObject);
    procedure cb_RatingActiveClick(Sender: TObject);
    procedure cb_RatingChangeCounterClick(Sender: TObject);
    procedure CBAlwaysSortAnzeigeListClick(Sender: TObject);
    procedure BtnClearCoverCacheClick(Sender: TObject);
    procedure BtnRefreshDevicesClick(Sender: TObject);
    procedure EdtUsernameAdminKeyPress(Sender: TObject; var Key: Char);
    procedure BtnShowWebserverLogClick(Sender: TObject);
    procedure LblWebserverAdminURLClick(Sender: TObject);
    procedure LblWebserverUserURLClick(Sender: TObject);
    procedure ChangeWebserverLinks(Sender: TObject);
    procedure CB_SilenceDetectionClick(Sender: TObject);
    procedure _XXX_cb_SettingsModeChange(Sender: TObject);
    procedure RecommendedFiletypesClick(Sender: TObject);
    procedure OptionsVSTBeforeItemErase(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect;
      var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure btn_DefaultCoverClick(Sender: TObject);
    procedure btn_DefaultCoverResetClick(Sender: TObject);
  private
    { Private-Deklarationen }
    OldFontSize: integer;
    //CurrentScanDir: String;
    procedure GetSkins;
    // Hilfsprozeduren für das Hotkey-Laden/Speichern
    Function ModToIndex(aMod: Cardinal): Integer;
    Function IndexToMod(aIndex: Integer): Cardinal;
    Function KeyToIndex(aKey: Byte): Integer;
    Function IndexToKey(aIndex: Integer): byte;

    procedure LoadDefaultCover;
  protected
    Procedure ScrobblerMessage(Var aMsg: TMessage); message WM_Scrobbler;
  public
    { Public-Deklarationen }

    CBSpalten: Array of TCheckBox;
    BirthdayNode: PVirtualNode;
    ScrobbleNode: PVirtualNode;
    WebServerNode: PVirtualNode;
    VorauswahlNode: pVirtualNode;
    procedure BackupComboboxes;
    procedure RestoreComboboxes;

    procedure ShowSettings(ExtendedSettings: Boolean);

  end;

  TOptionData = record
    Eintrag: String;
    TabSheet: TTabsheet;
  end;

  TOptionsTreeData = record
    FOptionData: TOptionData;
  end;

  POptionsTreeData = ^TOptionsTreeData;



var
  OptionsCompleteForm: TOptionsCompleteForm;

implementation

uses NempMainUnit, Details, SplitForm_Hilfsfunktionen, WindowsVersionInfo,
  WebServerLog;

{$R *.dfm}

var
 OptionsArraySystem : array[0..2] of TOptionData;
 OptionsArrayAnzeige: array[0..4] of TOptionData;
 OptionsArrayAudio  : array[0..7] of TOptionData;
 OptionsArrayFiles  : Array[0..5] of TOptionData;
 Testskin: TNempSkin;



function AddVSTOptions(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aOption: TOptionData): PVirtualNode;
var Data: POptionsTreeData;
begin
  Result:= AVST.AddChild(aNode); // meistens wohl Nil
  AVST.ValidateNode(Result,false);
  Data:=AVST.GetNodeData(Result);
  Data^.FOptionData := aOption;
end;

procedure TOptionsCompleteForm.BTNCancelClick(Sender: TObject);
begin
  close;
end;

procedure TOptionsCompleteForm.FormCreate(Sender: TObject);
var i, s, count: integer;
  BassInfo: BASS_DEVICEINFO;
begin

//optionsVST.StyleElements := [];


//optionsVST.TreeOptions.PaintOptions
//Header.Options := optionsVST.Header.Options + [hoOwnerDraw];

//optionsVST.Color := clWhite;
//optionsVST.Font.Color := clred;

//BtnOK.StyleElements := [];


//UnSkinForm(self);


  BackUpComboBoxes;
  TranslateComponent (self);
  RestoreComboboxes;

  Testskin := TNempSkin.create;

  DTPBirthdayTime.Format := 'HH:mm';

  for i := 0 to NempPlayer.ValidExtensions.Count - 1 do
  begin
    CBFileTypes.Items.Add(NempPlayer.ValidExtensions[i]);
    CBFileTypes.Checked[i] := True;

    cbIncludeFiles.Items.Add(NempPlayer.ValidExtensions[i]);
    cbIncludeFiles.Checked[i] := True;
  end;

  for i := 0 to CBPlaylistTypes.Count - 1 do
      CBPlaylistTypes.Checked[i] := True;


  OptionsVST.NodeDataSize := SizeOf(TOptionsTreeData);


  // MAIN
  OptionsArraySystem[0].Eintrag := OptionsTree_SystemGeneral;
  OptionsArraySystem[0].TabSheet:= TabSystem0;
      OptionsArraySystem[1].Eintrag := OptionsTree_SystemControl;
      OptionsArraySystem[1].TabSheet:= TabSystem1;
      OptionsArraySystem[2].Eintrag  := OptionsTree_SystemSystem;
      OptionsArraySystem[2].TabSheet := TabSystem3;
      //OptionsArraySystem[3].Eintrag  := OptionsTree_SystemHibernate;
      //OptionsArraySystem[3].TabSheet := TabSystem4;

  // VIEW
  OptionsArrayAnzeige[0].Eintrag := OptionsTree_ViewMain;
  OptionsArrayAnzeige[0].TabSheet:= TabView0;

      OptionsArrayAnzeige[1].Eintrag := OptionsTree_ViewPlayer;
      OptionsArrayAnzeige[1].TabSheet:= TabView2;

      OptionsArrayAnzeige[2].Eintrag := OptionsTree_PartyMode;
      OptionsArrayAnzeige[2].TabSheet:= TabView1;

      OptionsArrayAnzeige[3].Eintrag := OptionsTree_ViewFonts;
      OptionsArrayAnzeige[3].TabSheet:= TabView3;

      OptionsArrayAnzeige[4].Eintrag  := OptionsTree_ViewExtended;//'[leer]'; //OptionsTree_PlayerMedialibrary
      OptionsArrayAnzeige[4].TabSheet := TabView4;

  // PLAYER
  OptionsArrayAudio[0].Eintrag  := OptionsTree_PlayerMain;
  OptionsArrayAudio[0].TabSheet := TabPlayer0;

      OptionsArrayAudio[1].Eintrag  := OptionsTree_PlayerPlaylist;
      OptionsArrayAudio[1].TabSheet := TabPlayer2;

      //OptionsArrayAudio[3].Eintrag  := OptionsTree_PlayerExtendedPlaylist;
      //OptionsArrayAudio[3].TabSheet := TabPlayer3;

      OptionsArrayAudio[2].Eintrag  := OptionsTree_PlayerWebradio;
      OptionsArrayAudio[2].TabSheet := TabPlayer4;
      OptionsArrayAudio[3].Eintrag  := OptionsTree_PlayerEffects;
      OptionsArrayAudio[3].TabSheet := TabPlayer5;
      OptionsArrayAudio[4].Eintrag  := OptionsTree_PlayerEvents;
      OptionsArrayAudio[4].TabSheet := TabPlayer6;            // Birthday
      OptionsArrayAudio[5].Eintrag  := OptionsTree_PlayerScrobbler;
      OptionsArrayAudio[5].TabSheet := TabPlayer7;          // Scrobbler
      OptionsArrayAudio[6].Eintrag  := OptionsTree_PlayerWebServer;
      OptionsArrayAudio[6].TabSheet := TabPlayer8;          // WebServer

      OptionsArrayAudio[7].Eintrag  := OptionsTree_PlayerExtendedPlayer;
      OptionsArrayAudio[7].TabSheet := TabPlayer1;        // extended settings

  // FILE MANAGEMENT

  OptionsArrayFiles[0].Eintrag  := OptionsTree_FilesMain;
  OptionsArrayFiles[0].TabSheet := TabFiles0;

      OptionsArrayFiles[1].Eintrag := OptionsTree_SystemFiletyps;
      OptionsArrayFiles[1].TabSheet:= TabSystem2;

      OptionsArrayFiles[2].Eintrag  := OptionsTree_PlayerMetaDataAccess;
      OptionsArrayFiles[2].TabSheet := TabFiles1;

      OptionsArrayFiles[3].Eintrag := OptionsTree_FilesCover;
      OptionsArrayFiles[3].TabSheet:= TabFiles2;

      OptionsArrayFiles[4].Eintrag  := OptionsTree_MediabibSearch;
      OptionsArrayFiles[4].TabSheet := TabFiles3;
      OptionsArrayFiles[5].Eintrag  := OptionsTree_MediabibUnicode;
      OptionsArrayFiles[5].TabSheet := TabFiles4;


  // Fill Tree
  ShowSettings(True);

  OptionsVST.FullExpand(Nil);

  TabSystem0.TabVisible := False;
  TabSystem1.TabVisible := False;
  TabSystem2.TabVisible := False;
  TabSystem3.TabVisible := False;
  TabSystem4.TabVisible := False;

  TabView0.TabVisible := False;
  TabView1.TabVisible := False;
  TabView2.TabVisible := False;
  TabView3.TabVisible := False;
  TabView4.TabVisible := False;


  TabPlayer0.TabVisible := False;
  TabPlayer1.TabVisible := False;
  TabPlayer2.TabVisible := False;
  //TabPlayer3.TabVisible := False;
  TabPlayer4.TabVisible := False;
  TabPlayer5.TabVisible := False;
  TabPlayer6.TabVisible := False;
  TabPlayer7.TabVisible := False;
  TabPlayer8.TabVisible := False;

  TabFiles0.TabVisible := False;
  TabFiles1.TabVisible := False;
  TabFiles2.TabVisible := False;
  TabFiles3.TabVisible := False;
  TabFiles4.TabVisible := False;



  // Die Auswahlboxen mit den entsprechenden Zeichensätzen füllen
  for i := 0 to High(ArabicEncodings) do
    CBArabic.Items.Add(ArabicEncodings[i].Description);
  for i := 0 to High(ChineseEncodings) do
    CBChinese.Items.Add(ChineseEncodings[i].Description);
  for i := 0 to High(CyrillicEncodings) do
    CBCyrillic.Items.Add(CyrillicEncodings[i].Description);
  for i := 0 to High(GreekEncodings) do
    CBGreek.Items.Add(GreekEncodings[i].Description);
  for i := 0 to High(HebrewEncodings) do
    CBHebrew.Items.Add(HebrewEncodings[i].Description);
  for i := 0 to High(JapaneseEncodings) do
    CBJapanese.Items.Add(JapaneseEncodings[i].Description);
  for i := 0 to High(KoreanEncodings) do
    CBKorean.Items.Add(KoreanEncodings[i].Description);
  for i := 0 to High(ThaiEncodings) do
    CBThai.Items.Add(ThaiEncodings[i].Description);


  //----------------------------------
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

  CB_FloatingPoint.ItemIndex := NempPlayer.UseFloatingPointChannels;
  if NempPlayer.UseHardwareMixing then
      CB_Mixing.ItemIndex := 0
  else
      CB_Mixing.ItemIndex := 1;

  if NempPlayer.Floatable then
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_On
  else
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_Off;

  //-----------------------------------------------
  CBFontNameCBR.Items := Screen.Fonts;
  CBFontNameVBR.Items := Screen.Fonts;

  // Spalten-Checkboxen erzeugen
  SetLength(CBSpalten, Spaltenzahl);
  for i := 0 to Length(CBSpalten)-1 do
  begin
    CBSpalten[i] := TCheckBox.Create(self);
    CBSpalten[i].Parent := GrpBox_ViewMain_Columns;
    s := GetColumnIDfromPosition(Nemp_MainForm.VST, i);
    CBSpalten[i].Caption := Nemp_MainForm.VST.Header.Columns[s].Text;
    CBSpalten[i].Checked := coVisible in Nemp_MainForm.VST.Header.Columns[s].Options;
    CBSpalten[i].Top := 20 + (i mod 6)*16;
    CBSpalten[i].Left := 16 + (i div 6) * 100;
  end;

  cbCoverMode.ItemIndex := Nemp_MainForm.NempOptions.CoverMode;
  cbDetailMode.ItemIndex := Nemp_MainForm.NempOptions.DetailMode;

  PageControl1.ActivePageIndex := 0;

  OpenDlg_DefaultCover.Filter :=  //FileFormatList.GetGraphicFilter([ftRaster], fstBoth, [foCompact, foIncludeAll,foIncludeExtension], Nil);
      'All images|*.bmp; *.dib; *.gif; *.jfif; *.jpe; *.jpeg; *.jpg; *.png; *.rle|'
      + 'JPG images (*.jfif; *.jpe; *.jpeg; *.jpg)|*.jfif; *.jpe; *.jpeg; *.jpg|'
      + 'Portable network graphic images (*.png)|*.png|'
      + 'Windows bitmaps (*.bmp; *.dib; *.rle)|*.bmp; *.dib; *.rle|'
      + 'CompuServe images (*.gif)|*.gif';

  OpenDlg_CountdownSongs.Filter := Nemp_MainForm.PlaylistDateienOpenDialog.Filter;
end;


procedure TOptionsCompleteForm.ShowSettings(ExtendedSettings: Boolean);
var MainNode, Firstnode : PVirtualNode;
    i: Integer;
begin
    GrpBox_StartingExtended.Visible := ExtendedSettings;
    GrpBox_TabulatorOptions.Visible := ExtendedSettings;
    GrpBox_PlayerExt_SafePlayback.Visible := ExtendedSettings;

    OptionsVST.Clear;

    // MAIN
    MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArraySystem[0]);
    Firstnode := MainNode;
    //if ExtendedSettings then
        for i := 1 to High(OptionsArraySystem) do
            AddVSTOptions(OptionsVST, MainNode, OptionsArraySystem[i]);
    //else
    //    for i := 1 to High(OptionsArraySystem) - 1 do            // Dont show Hibernate-Page
    //        AddVSTOptions(OptionsVST, MainNode, OptionsArraySystem[i]);

    // VIEW
    MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayAnzeige[0]);
    VorauswahlNode := MainNode;
        //if ExtendedSettings then
        for i := 1 to High(OptionsArrayAnzeige) do
            AddVSTOptions(OptionsVST, MainNode, OptionsArrayAnzeige[i]);
        //else
        //    AddVSTOptions(OptionsVST, MainNode, OptionsArrayAnzeige[1]);

    // PLAYER
    MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayAudio[0]);
          AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[1]); // Playlist
          AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[2]); // Webradio
          AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[3]); // Effects
          BirthdayNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[4]); // Birthday
          ScrobbleNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[5]); // Scrobbler
          WebServerNode := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[6]); // Webserver
          AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[7]); // extended

    //if ExtendedSettings then AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[1]);
    //AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[2]);
    //if ExtendedSettings then AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[3]);
    //AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[4]);
    //AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[5]);
    //BirthdayNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[6]);
    //ScrobbleNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[7]);
    //WebServerNode := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[8]);

    {for i := 1 to High(OptionsArrayAudio) do
    begin
        case i of
            4: BirthdayNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
            5: ScrobbleNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
            6: WebServerNode := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
        else
            AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
        end;
    end;}

    // FILE MANAGEMENT
    MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayFiles[0]);
    AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[1]);

    AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[2]);
    AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[3]);
    //if ExtendedSettings then
    if ExtendedSettings then AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[4]);
    if ExtendedSettings then AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[5]);

    //for i := 2 to High(OptionsArrayFiles) do
    //    AddVSTOptions(OptionsVST, MainNode, OptionsArrayFiles[i]);

    OptionsVST.FullExpand(Nil);

    OptionsVST.FocusedNode := Firstnode;
    PageControl1.ActivePage := TabSystem0;
end;


procedure TOptionsCompleteForm._XXX_cb_SettingsModeChange(Sender: TObject);
begin
    // ShowSettings(cb_SettingsMode.ItemIndex = 1);
    // removed june 2017. always show all settings
end;



procedure TOptionsCompleteForm.OptionsVSTBeforeItemErase(
  Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
  ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  exit;
  with TargetCanvas do
  begin
      if Node.Index mod 2 = 0 then
        ItemColor := $EEEEEE  //$49DDEF // $70A33F // $436BFF
      else
        ItemColor := Graphics.clWindow;
      EraseAction := eaColor;
  end;
end;


procedure TOptionsCompleteForm.OptionsVSTFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var aNode: PVirtualNode;
  OptionsData: POptionsTreeData;
begin
  aNode := OptionsVST.FocusedNode;
  if not Assigned(aNode) then
      Exit;
  OptionsData := OptionsVST.GetNodeData(aNode);
  PageControl1.ActivePage := OptionsData.FOptionData.TabSheet;
end;

procedure TOptionsCompleteForm.FormDestroy(Sender: TObject);
var Data: POptionsTreeData;
    node: PVirtualNode;
begin
    try
        node :=  OptionsVST.GetFirst;
        while assigned(node) do
        begin
            Data := OptionsVST.GetNodeData(Node);
            if assigned(Data) then
                Data^.FOptionData.Eintrag := '';
            node := OptionsVST.GetNext(node);
        end;
    finally
        OptionsVST.Clear;
        // VerlaufBitmap.Free;
        Testskin.Free;
    end;
end;

procedure TOptionsCompleteForm.OptionsVSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var Data: POptionsTreeData;
begin
  Data:=Sender.GetNodeData(Node);
  CellText := _((Data^.FOptionData).Eintrag);
end;


procedure TOptionsCompleteForm.FormShow(Sender: TObject);
var i,s: integer;
    Ini: TMemIniFile;
    hMod: Cardinal;
    hKey: Byte;
    //aBmp: TBitmap;
    ftr: TFileTypeRegistration;
    tmpIPs, tmpThemes: TStrings;
    Coverbmp: tBitmap;
begin
  // Beta-Option
//  cb_BetaDontUseThreadedUpdate.Checked := MedienBib.BetaDontUseThreadedUpdate;

  cb_UseClassicCoverflow.Checked := MedienBib.NewCoverFlow.Mode = cm_Classic;
  cbFixCoverFlowOnStart.Checked := Nemp_MainForm.NempOptions.FixCoverFlowOnStart;

  //---PLAYER----
  GrpBox_DefaultAction.ItemIndex := NempPlaylist.DefaultAction;
  GrpBox_HeadsetDefaultAction.ItemIndex := NempPlaylist.HeadSetAction;

  cb_AutoStopHeadset.Checked := NempPlaylist.AutoStopHeadset;

  CB_Fading.Checked := NempPlayer.UseFading;
  CB_visual.Checked := NempPlayer.UseVisualization;
  TB_Refresh.Enabled := CB_visual.Checked;
  Lbl_Framerate.Enabled := CB_visual.Checked;

  CB_ScrollTitelTaskBar.Checked := NempPlayer.ScrollTaskbarTitel;
  CB_ScrollTitleInMainWindow.Checked := NempPlayer.ScrollAnzeigeTitel;
  CB_AnzeigeDelay.Enabled := CB_ScrollTitleInMainWindow.Checked;
  CB_TaskBarDelay.Enabled := CB_ScrollTitelTaskBar.Checked;

  cbReInitAfterSuspend.Checked := NempPlayer.ReInitAfterSuspend;
  cbPauseOnSuspend.Checked := NempPlayer.PauseOnSuspend;

  ftr := TFileTypeRegistration.Create;
  try
      for i := 0 to CBFileTypes.Count - 1 do
          CBFileTypes.Checked[i] := ftr.ExtensionOpensWithApplication(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', ParamStr(0));

      for i := 0 to CBPlaylistTypes.Count - 1 do
          CBPlaylistTypes.Checked[i] := ftr.ExtensionOpensWithApplication(CBPlaylistTypes.Items[i], 'Nemp.Playlist', ParamStr(0));
  finally
      ftr.Free;
  end;


  for i := 0 to CBIncludeFiles.Count - 1 do
  begin
      CBIncludeFiles.Checked[i] := Pos('*' + CBIncludeFiles.Items[i], MedienBib.IncludeFilter) > 0;
  end;



  SE_Fade.Value := NempPlayer.FadingInterval;
  SE_SeekFade.Value := NempPlayer.SeekFadingInterval;

  CB_IgnoreFadingOnShortTracks.Checked := NempPlayer.IgnoreFadingOnShortTracks;
  CB_IgnoreFadingOnPause.Checked := NempPlayer.IgnoreFadingOnPause;
  CB_IgnoreFadingOnStop.Checked := NempPlayer.IgnoreFadingOnStop;

  SE_Fade.Enabled := CB_Fading.Checked;
  SE_SeekFade.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnShortTracks.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnPause.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnStop.Enabled := CB_Fading.Checked;
  LblConst_ms1.Enabled := CB_Fading.Checked;
  LblConst_ms2.Enabled := CB_Fading.Checked;
  LblConst_TitleChange.Enabled := CB_Fading.Checked;
  LblConst_TitleFade.Enabled := CB_Fading.Checked;

  CB_SilenceDetection.Checked  := NempPlayer.DoSilenceDetection;
  SE_SilenceThreshold.Value    := NempPlayer.SilenceThreshold;
  Lbl_SilenceThreshold.Enabled := NempPlayer.DoSilenceDetection;
  SE_SilenceThreshold.Enabled  := NempPlayer.DoSilenceDetection;
  Lbl_SilenceDB.Enabled        := NempPlayer.DoSilenceDetection;

  if NempPlayer.MainDevice > 0 then
      MainDeviceCB.ItemIndex := NempPlayer.MainDevice - 1
  else
      MainDeviceCB.ItemIndex := 0;

  if NempPlayer.HeadSetDevice > 0 then
      HeadPhonesDeviceCB.ItemIndex := NempPlayer.HeadsetDevice - 1
  else
      HeadPhonesDeviceCB.ItemIndex := 0;

  TB_Refresh.Position := 100 - NempPlayer.VisualizationInterval;

  case NempPlayer.ScrollTaskbarDelay of
      0..5  : CB_TaskbarDelay.ItemIndex := 4;
      6..10 : CB_TaskbarDelay.ItemIndex := 3;
      11..15 : CB_TaskbarDelay.ItemIndex := 2;
      16..20 : CB_TaskbarDelay.ItemIndex := 1;
  else
      CB_TaskbarDelay.ItemIndex := 0
  end;

  case NempPlayer.ScrollAnzeigeDelay of
      0..1   : CB_AnzeigeDelay.ItemIndex := 4;
      2..3   : CB_AnzeigeDelay.ItemIndex := 3;
      4..5   : CB_AnzeigeDelay.ItemIndex := 2;
      6..7  : CB_AnzeigeDelay.ItemIndex := 1;
  else
      CB_AnzeigeDelay.ItemIndex := 0
  end;

  Lbl_Framerate.Caption := inttostr(1000 DIV NempPlayer.VisualizationInterval) + ' fps';

  SEBufferSize.Value := BASS_GetConfig(BASS_CONFIG_BUFFER);

  CB_AutoScanPlaylist.checked := NempPlaylist.AutoScan;
  CB_AutoPlayOnStart.Checked  := NempPlaylist.AutoPlayOnStart;
  cb_SavePositionInTrack.Checked := NempPlaylist.SavePositionInTrack;
  cb_SavePositionInTrack.Enabled := CB_AutoPlayOnStart.Checked;

  CB_AutoPlayNewTitle.Checked     := NempPlaylist.AutoPlayNewTitle;
  CB_AutoPlayEnqueueTitle.Checked := NempPlaylist.AutoPlayEnqueuedTitle;

  CB_AutoSavePlaylist.Checked := NempPlaylist.AutoSave;

  CB_AutoDeleteFromPlaylist.Checked := NempPlaylist.AutoDelete;

      CB_DisableAutoDeleteAtUserInput.Checked := NempPlaylist.DisableAutoDeleteAtUserInput ;
      CB_DisableAutoDeleteAtUserInput.Enabled := NempPlaylist.AutoDelete                   ;

      //CB_DisableAutoDeleteAtSlide.Checked         := NempPlaylist.DisableAutoDeleteAtSlide          ;
      //CB_DisableAutoDeleteAtPause.Checked         := NempPlaylist.DisableAutoDeleteAtPause          ;
      //CB_DisAbleAutoDeleteAtStop.Checked          := NempPlaylist.DisAbleAutoDeleteAtStop           ;
      //CB_DisableAutoDeleteAtTitleChange.Checked   := NempPlaylist.DisableAutoDeleteAtTitleChange    ;
      //CB_DisableAutoDeleteAtPause.Enabled         := NempPlaylist.AutoDelete          ;
      //CB_DisAbleAutoDeleteAtStop.Enabled          := NempPlaylist.AutoDelete           ;
      //CB_DisableAutoDeleteAtTitleChange.Enabled   := NempPlaylist.AutoDelete    ;

  CB_AutoMixPlaylist.Checked        := NempPlaylist.AutoMix;
  CB_JumpToNextCue.Checked          := NempPlaylist.JumpToNextCueOnNextClick;
  cb_ReplayCue.Checked              := NempPlaylist.RepeatCueOnRepeatTitle;
  CB_RememberInterruptedPlayPosition.Checked := NempPlaylist.RememberInterruptedPlayPosition;

  CB_ShowHintsInPlaylist.Checked    := NempPlaylist.ShowHintsInPlaylist;

  TBRandomRepeat.Position := NempPlaylist.RandomRepeat;

  CBJingleReduce.Checked := NempPlayer.ReduceMainVolumeOnJingle;
  SEJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;
  LblJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;

  SEJingleReduce.Value := NempPlayer.ReduceMainVolumeOnJingleValue;
  SEJingleVolume.Value := NempPlayer.JingleVolume;

  cb_UseWalkmanMode.Checked := NempPlayer.UseWalkmanMode;


  if NempPlayer.AvoidMickyMausEffect then
    GrpBox_MickyMouse.ItemIndex := 0
  else
    GrpBox_MickyMouse.ItemIndex := 1;

  CB_UseDefaultEffects.Checked := NempPlayer.UseDefaultEffects;
  CB_UseDefaultEqualizer.Checked := NempPlayer.UseDefaultEqualizer;

  // Webradio
  EdtDownloadDir.Text := NempPlayer.DownloadDir;
  cbFilenameFormat.Text := NempPlayer.FilenameFormat;
  cbAutoSplitByTitle.Checked := NempPlayer.AutoSplitByTitle;
  cbUseStreamnameAsDirectory.Checked := NempPlayer.UseStreamnameAsDirectory;

  cbAutoSplitBySize.Checked := NempPlayer.AutoSplitByTime;
  SE_AutoSplitMaxSize.Enabled := NempPlayer.AutoSplitByTime;
  LblConst_MaxSize.Enabled := NempPlayer.AutoSplitByTime;

  cbAutoSplitByTime.Checked := NempPlayer.AutoSplitBySize;
  SE_AutoSplitMaxTime.Enabled := NempPlayer.AutoSplitBySize;
  LblConst_MaxTime.Enabled := NempPlayer.AutoSplitBySize;

  SE_AutoSplitMaxSize.Value := NempPlayer.AutoSplitMaxSize;
  SE_AutoSplitMaxTime.Value := NempPlayer.AutoSplitMaxTime;

  if NempPlaylist.BassHandlePlaylist then
      RGroup_Playlist.ItemIndex := 1
  else
      RGroup_Playlist.ItemIndex := 0;

  //----------ALLGEMEIN_:______________

  OldFontSize := Nemp_MainForm.NempOptions.DefaultFontSize;
  CBChangeFontColorOnBitrate.Checked := Nemp_MainForm.NempOptions.ChangeFontColorOnBitrate;
  CBChangeFontSizeOnLength.Checked := Nemp_MainForm.NempOptions.ChangeFontSizeOnLength;

  CBChangeFontStyleOnMode.Checked := Nemp_MainForm.NempOptions.ChangeFontStyleOnMode;
  CBChangeFontOnCbrVbr.Checked := Nemp_MainForm.NempOptions.ChangeFontOnCbrVbr;
  SEFontSize.Value := Nemp_MainForm.NempOptions.DefaultFontSize;
  SERowHeight.Value := Nemp_MainForm.NempOptions.RowHeight;

  cb_Medialist_FontStyle.ItemIndex := Nemp_MainForm.NempOptions.DefaultFontStyle ;
  cb_Browselist_FontStyle.ItemIndex := Nemp_MainForm.NempOptions.ArtistAlbenFontStyle ;

  CBFontNameCBR.ItemIndex := CBFontNameCBR.Items.IndexOf(Nemp_MainForm.NempOptions.FontNameCBR);
  CBFontNameVBR.ItemIndex := CBFontNameVBR.Items.IndexOf(Nemp_MainForm.NempOptions.FontNameVBR);
  LblConst_FontVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  LblConst_FontCBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  CBFontNameVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  CBFontNameCBR.Enabled := CBChangeFontOnCbrVbr.Checked;

  // Checkboxen der Spalten ggf. aktualisieren
  for i := 0 to Length(CBSpalten)-1 do
  begin
    s := GetColumnIDfromPosition(Nemp_MainForm.VST, i);
    CBSpalten[i].Caption := Nemp_MainForm.VST.Header.Columns[s].Text;
    CBSpalten[i].Checked := coVisible in Nemp_MainForm.VST.Header.Columns[s].Options;
 end;

 cbHideNACover.Checked := MedienBib.HideNACover;
 cbMissingCoverMode.ItemIndex := MedienBib.MissingCoverMode;
 cbCoverMode.ItemIndex := Nemp_MainForm.NempOptions.CoverMode;
 cbDetailMode.ItemIndex := Nemp_MainForm.NempOptions.DetailMode;

  CB_CoverSearch_inDir.Checked       := MedienBib.CoverSearchInDir;
  CB_CoverSearch_inParentDir.Checked := MedienBib.CoverSearchInParentDir;
  CB_CoverSearch_inSubDir.Checked    := MedienBib.CoverSearchInSubDir;
  EDTCoverSubDirName.Enabled := CB_CoverSearch_inSubDir.Checked;

  CB_CoverSearch_inSisterDir.Checked := MedienBib.CoverSearchInSisterDir;
  EDTCoverSisterDirName.Enabled := CB_CoverSearch_inSisterDir.Checked;

  EDTCoverSubDirName.Text    := MedienBib.CoverSearchSubDirName;
  EDTCoverSisterDirName.Text := MedienBib.CoverSearchSisterDirName;

  CB_CoverSearch_LastFM.Checked := MedienBib.CoverSearchLastFM;

  //cbDenyId3Edit.Checked := Nemp_MainForm.NempOptions.DenyId3Edit;

  cbFullRowSelect.Checked := Nemp_MainForm.NempOptions.FullRowSelect;
  CB_EditOnClick.Checked  := Nemp_MainForm.NempOptions.EditOnClick;


  cbAlwaysSortAnzeigeList.Checked := MedienBib.AlwaysSortAnzeigeList;
  CBSkipSortOnLargeLists.Enabled := CBAlwaysSortAnzeigeList.Checked;
  CBSkipSortOnLargeLists.Checked := MedienBib.SkipSortOnLargeLists;

  CBAutoScanPlaylistFilesOnView.Checked := MedienBib.AutoScanPlaylistFilesOnView;
  CBShowHintsInMedialist.Checked := MedienBib.ShowHintsInMedialist;

  CBSortArray1.ItemIndex := integer(MedienBib.NempSortArray[1]);
  CBSortArray2.ItemIndex := integer(MedienBib.NempSortArray[2]);
  cbCoverSortOrder.ItemIndex := MedienBib.CoverSortOrder - 1;

  cbReplaceArtistBy.ItemIndex := Nemp_MainForm.NempOptions.ReplaceNAArtistBy;
  cbReplaceTitleBy .ItemIndex := Nemp_MainForm.NempOptions.ReplaceNATitleBy ;
  cbReplaceAlbumBy .ItemIndex := Nemp_MainForm.NempOptions.ReplaceNAAlbumBy ;


  CBAutoScan.Checked := MedienBib.AutoScanDirs;
  LBAutoScan.Enabled := MedienBib.AutoScanDirs;
  BtnAutoScanDelete.Enabled  := CBAutoScan.Checked;
  BtnAutoScanAdd.Enabled  := CBAutoScan.Checked;
  LBAutoScan.Items.Clear;
  for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
      LBAutoScan.Items.Add(MedienBib.AutoScanDirList[i]);

  CBAskForAutoAddNewDirs.Checked := MedienBib.AskForAutoAddNewDirs;
  CBAutoAddNewDirs.Checked       := MedienBib.AutoAddNewDirs;

  cb_ShowSplashScreen.Checked := Nemp_MainForm.NempOptions.ShowSplashScreen;
  CB_AllowMultipleInstances.Checked := Not Nemp_MainForm.NempOptions.AllowOnlyOneInstance;
  CB_StartMinimized.Checked := Nemp_MainForm.NempOptions.StartMinimized;
  CBRegisterHotKeys.Checked := Nemp_MainForm.NempOptions.RegisterHotKeys;

  cb_RegisterMediaHotkeys.Checked := Nemp_MainForm.NempOptions.RegisterMediaHotkeys;
  CB_IgnoreVolume.Checked := Nemp_MainForm.NempOptions.IgnoreVolumeUpDownKeys;
  cb_UseG15Display.Checked := Nemp_MainForm.NempOptions.UseDisplayApp;

  cb_SafePlayback.Checked := NempPlayer.SafePlayback;

  CB_TabStopAtPlayerControls.Checked := Nemp_MainForm.NempOptions.TabStopAtPlayerControls;
  CB_TabStopAtTabs          .Checked := Nemp_MainForm.NempOptions.TabStopAtTabs;

  cbIncludeAll.Checked := MedienBib.IncludeAll;
  cbIncludeFiles.Enabled := NOT cbIncludeAll.Checked;
  BtnRecommendedFiletypes.Enabled := NOT cbIncludeAll.Checked;
  LblConst_OnlythefollowingTypes.Enabled := NOT cbIncludeAll.Checked;

  CBAutoLoadMediaList.Checked := MedienBib.AutoLoadMediaList;
  CBAutoSaveMediaList.Checked := MedienBib.AutoSaveMediaList;

  // MedienBib, Suchoptionen
  CB_AccelerateSearch                 .Checked := MedienBib.BibSearcher.AccelerateSearch;
          CB_AccelerateSearchIncludePath.Enabled    := CB_AccelerateSearch.Checked;
          CB_AccelerateSearchIncludeComment.Enabled := CB_AccelerateSearch.Checked;
          LblConst_AccelerateSearchNote2.Enabled    := CB_AccelerateSearch.Checked;
  CB_AccelerateSearchIncludePath      .Checked := MedienBib.BibSearcher.AccelerateSearchIncludePath;
  CB_AccelerateSearchIncludeComment   .Checked := MedienBib.BibSearcher.AccelerateSearchIncludeComment;
  CB_AccelerateLyricSearch            .Checked := MedienBib.BibSearcher.AccelerateLyricSearch;
  CB_QuickSearchWhileYouType          .Checked := MedienBib.BibSearcher.QuickSearchOptions.WhileYouType;
  cb_ChangeCoverflowOnSearch          .Checked := MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow;
  CB_QuickSearchAllowErrorsOnEnter    .Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter;
  CB_QuickSearchAllowErrorsWhileTyping.Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType;

  GrpBox_TaskTray.ItemIndex := Nemp_MainForm.NempOptions.NempWindowView;

  CBShowDeskbandOnMinimize.Checked := Nemp_MainForm.NempOptions.ShowDeskbandOnMinimize;
  CBShowDeskbandOnStart.Checked    := Nemp_MainForm.NempOptions.ShowDeskbandOnStart;
  CBHideDeskbandOnRestore.Checked  := Nemp_MainForm.NempOptions.HideDeskbandOnRestore;
  CBHideDeskbandOnClose.Checked    := Nemp_MainForm.NempOptions.HideDeskbandOnClose;


  // Artist/alben-Größen
  SEArtistAlbenSIze.Value := Nemp_MainForm.NempOptions.ArtistAlbenFontSize;
  SEArtistAlbenRowHeight.Value := Nemp_MainForm.NempOptions.ArtistAlbenRowHeight;

  // Zeichensätze
  With MedienBib do
  begin
      CBArabic.ItemIndex   := NempCharCodeOptions.Arabic.Index;
      CBChinese.ItemIndex  := NempCharCodeOptions.Chinese.Index;
      CBCyrillic.ItemIndex := NempCharCodeOptions.Cyrillic.Index;
      CBGreek.ItemIndex    := NempCharCodeOptions.Greek.Index;
      CBHebrew.ItemIndex   := NempCharCodeOptions.Hebrew.Index;
      CBJapanese.ItemIndex := NempCharCodeOptions.Japanese.Index;
      CBKorean.ItemIndex   := NempCharCodeOptions.Korean.Index;
      CBThai.ItemIndex     := NempCharCodeOptions.Thai.Index;
      CBAutoDetectCharCode.Checked := NempCharCodeOptions.AutoDetectCodePage;
  end;

  // Geburtstags-Optionen
  DTPBirthdayTime.Date := TDate(Now);
  // Daten aus Ini lesen
  NempPlayer.ReadBirthdayOptions(SavePath + NEMP_NAME + '.ini');
  //Controls setzen
  with NempPlayer.NempBirthdayTimer do
  begin
    CBStartCountDown.Checked := UseCountDown;
       lblCountDownTitel.Enabled := CBStartCountDown.Checked;
       EditCountdownSong.Enabled := CBStartCountDown.Checked;
       BtnCountDownSong.Enabled := CBStartCountDown.Checked;
       BtnGetCountDownTitel.Enabled := CBStartCountDown.Checked;
       LBlCountDownWarning.Enabled := CBStartCountDown.Checked;

    EditCountdownSong.Text := CountDownFileName;
    EditBirthdaySong.Text := BirthdaySongFilename;
    DTPBirthdayTime.Time := TimeOf(StartTime);
    CBContinueAfter.Checked := ContinueAfter;

    LBlCountDownWarning.Visible := NOT FileExists(CountDownFileName);
    LblEventWarning.Visible := NOT FileExists(BirthdaySongFilename);
  end;

  // Suche nach Skin-Ordnern
  GetSkins;
  // Anzeige anpassen
  cbSkinAuswahlChange(Nil);

  // Hotkeys setzen
  ini := TMeminiFile.Create(SavePath + 'Hotkeys.ini', TEncoding.UTF8);
  try
       ini.Encoding := TEncoding.UTF8;
       CB_Activate_Play.Checked := Ini.ReadBool('HotKeys','InstallHotkey_Play'       , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Play' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Play', ord('P'));
         CB_Mod_Play.ItemIndex := ModToIndex(hMod);
         CB_Key_Play.ItemIndex := KeyToIndex(hkey);

       CB_Activate_Stop.Checked := Ini.ReadBool('HotKeys','InstallHotkey_Stop'       , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Stop' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Stop', ord('S'));
         CB_Mod_Stop.ItemIndex := ModToIndex(hMod);
         CB_Key_Stop.ItemIndex := KeyToIndex(hkey);

       CB_Activate_Next.Checked := Ini.ReadBool('HotKeys','InstallHotkey_Next'       , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Next' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Next', ord('N'));
         CB_Mod_Next.ItemIndex := ModToIndex(hMod);
         CB_Key_Next.ItemIndex := KeyToIndex(hkey);

       CB_Activate_Prev.Checked := Ini.ReadBool('HotKeys','InstallHotkey_Prev'       , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Prev' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Prev', ord('B'));
         CB_Mod_Prev.ItemIndex := ModToIndex(hMod);
         CB_Key_Prev.ItemIndex := KeyToIndex(hkey);

       CB_Activate_JumpForward.Checked := Ini.ReadBool('HotKeys','InstallHotkey_JumpForward', True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpForward' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpForward', ord('M'));
         CB_Mod_JumpForward.ItemIndex := ModToIndex(hMod);
         CB_Key_JumpForward.ItemIndex := KeyToIndex(hkey);

       CB_Activate_JumpBack.Checked := Ini.ReadBool('HotKeys','InstallHotkey_JumpBack'   , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_JumpBack' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_JumpBack', ord('V'));
         CB_Mod_JumpBack.ItemIndex := ModToIndex(hMod);
         CB_Key_JumpBack.ItemIndex := KeyToIndex(hkey);

       CB_Activate_IncVol.Checked := Ini.ReadBool('HotKeys','InstallHotkey_IncVol'     , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_IncVol' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_IncVol', $BB);
         CB_Mod_IncVol.ItemIndex := ModToIndex(hMod);
         CB_Key_IncVol.ItemIndex := KeyToIndex(hkey);

       CB_Activate_DecVol.Checked := Ini.ReadBool('HotKeys','InstallHotkey_DecVol'     , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_DecVol' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_DecVol', $BD);
         CB_Mod_DecVol.ItemIndex := ModToIndex(hMod);
         CB_Key_DecVol.ItemIndex := KeyToIndex(hkey);

       CB_Activate_mute.Checked := Ini.ReadBool('HotKeys','InstallHotkey_Mute'       , True);
         hMod := ini.ReadInteger('HotKeys', 'HotkeyMod_Mute' , 6);
         hKey := Ini.ReadInteger('HotKeys', 'HotkeyKey_Mute', ord('0'));
         CB_Mod_Mute.ItemIndex := ModToIndex(hMod);
         CB_Key_Mute.ItemIndex := KeyToIndex(hkey);
  finally
    ini.Free;
  end;
  CBRegisterHotKeysClick(Nil);


  cb_StayOnTop.Checked := Nemp_MainForm.NempOptions.MiniNempStayOnTop;

  // Update-Optionen
  CB_AutoCheck.Checked := NempUpdater.AutoCheck;
  CB_AutoCheckNotifyOnBetas.Checked := NempUpdater.NotifyOnBetas;

  cbUseAdvancedSkin.Checked := Nemp_MainForm.GlobalUseAdvancedSkin;

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

  InitScrobblerWizard;
  CB_AlwaysScrobble     .Checked := NempPlayer.NempScrobbler.AlwaysScrobble;
  CB_ScrobbleThisSession.Checked := NempPlayer.NempScrobbler.DoScrobble;
  CB_SilentError        .Checked := NempPlayer.NempScrobbler.IgnoreErrors;

  if NempPlayer.NempScrobbler.DoScrobble then
  begin
      if NempPlayer.NempScrobbler.Working then
          GrpBox_ScrobbleLog.Caption := Scrobble_Active
      else
          GrpBox_ScrobbleLog.Caption := Scrobble_InActive;
  end else
      GrpBox_ScrobbleLog.Caption := Scrobble_Offline;

  // Webserver-Daten auslesen und Controls setzen

  NempWebServer.LoadfromIni;
  tmpThemes := tStringList.Create;
  try
      NempWebServer.GetThemes(tmpThemes);
      cbWebServerRootDir.Items.Assign(tmpThemes);
  finally
      tmpThemes.Free;
  end;

  if cbWebServerRootDir.Items.IndexOf(NempWebServer.Theme) >-1 then
      cbWebServerRootDir.ItemIndex := cbWebServerRootDir.Items.IndexOf(NempWebServer.Theme);

  EdtUsername.Text      := NempWebServer.UsernameU;
  EdtPassword.Text      := NempWebServer.PasswordU;
  EdtUsernameAdmin.Text := NempWebServer.UsernameA;
  EdtPasswordAdmin.Text := NempWebServer.PasswordA;

  seWebServer_Port.Value := NempWebServer.Port;
  cbOnlyLAN.Checked := NempWebServer.OnlyLAN;
  cbPermitLibraryAccess.Checked    := NempWebServer.AllowLibraryAccess;
  cbPermitPlaylistDownload.Checked := NempWebServer.AllowFileDownload;
  cbAllowRemoteControl.Checked     := NempWebServer.AllowRemoteControl;
  cbPermitVote.Checked             := NempWebServer.AllowVotes;

  tmpIPs := getIPs;
  cbLANIPs.Items.Assign(tmpIPs);
  tmpIps.Free;
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

  // Partymode-Optionen
  CB_PartyMode_ResizeFactor.ItemIndex := Nemp_MainForm.NempSkin.NempPartyMode.FactorToIndex;
  cb_PartyMode_BlockTreeEdit          .Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit            ;
  cb_PartyMode_BlockCurrentTitleRating.Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating  ;
  cb_PartyMode_BlockTools             .Checked := Nemp_MainForm.NempSkin.NempPartyMode.BlockTools               ;
  cb_PartyMode_ShowPasswordOnActivate .Checked := Nemp_MainForm.NempSkin.NempPartyMode.ShowPasswordOnActivate   ;

  Edt_PartyModePassword.Text := Nemp_MainForm.NempSkin.NempPartyMode.password;


  // quick access to metadata
  cb_AccessMetadata                     .checked := Nemp_MainForm.NempOptions.AllowQuickAccessToMetadata;
  cb_UseCDDB                            .checked := Nemp_MainForm.NempOptions.UseCDDB                   ;
  // Automatic ratings
  // Set settings:
  cb_RatingActive                       .checked := NempPlayer.PostProcessor.Active                       ;
  cb_RatingIgnoreShortFiles             .checked := NempPlayer.PostProcessor.IgnoreShortFiles             ;
  // cb_RatingWriteToFiles                 .checked := NempPlayer.PostProcessor.WriteToFiles;
  cb_RatingChangeCounter                .checked := NempPlayer.PostProcessor.ChangeCounter                ;
  // (nonsense?? ) cb_RatingIgnoreCounterOnAbortedTracks .checked := NempPlayer.PostProcessor.IgnoreCounterOnAbortedTracks ;
  cb_RatingIncreaseRating               .checked := NempPlayer.PostProcessor.IncPlayedFiles               ;
  cb_RatingDecreaseRating               .checked := NempPlayer.PostProcessor.DecAbortedFiles              ;
  // Set Enabled/Disabled
  cb_RatingIgnoreShortFiles             .Enabled := NempPlayer.PostProcessor.Active;
  // cb_RatingWriteToFiles                 .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingChangeCounter                .Enabled := NempPlayer.PostProcessor.Active;
  // cb_RatingIgnoreCounterOnAbortedTracks .Enabled := NempPlayer.PostProcessor.Active and NempPlayer.PostProcessor.ChangeCounter;
  cb_RatingIncreaseRating               .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingDecreaseRating               .Enabled := NempPlayer.PostProcessor.Active;

  ChangeWebserverLinks(Nil);

  LoadDefaultCover;

  //SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
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

procedure TOptionsCompleteForm.GetSkins;
begin
end;

procedure TOptionsCompleteForm.FormHide(Sender: TObject);
begin


    exit;



  if Nemp_MainForm.NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
  begin
    ShowWindow( Application.Handle, SW_HIDE );
    {SetWindowLong( Nemp_MainForm.Handle, GWL_EXSTYLE,
                 Nemp_MainForm.NempWindowDefault
                 //GetWindowLong(Application.Handle, GWL_EXSTYLE)
                 or WS_EX_TOOLWINDOW
                 //and (not WS_ICONIC)
                 and not WS_EX_APPWINDOW);}

                 SetWindowLong( Application.Handle, GWL_STYLE,
                 //Nemp_MainForm.NempWindowDefault
                 GetWindowLong(Application.Handle, GWL_STYLE)
                   or WS_EX_TOOLWINDOW
                   and not WS_EX_APPWINDOW
                 );


    ShowWindow( Application.Handle, SW_SHOW );
  end else
  begin
    ShowWindow( Application.Handle, SW_HIDE );
    SetWindowLong( Application.Handle, GWL_EXSTYLE,
                 Nemp_MainForm.NempWindowDefault );
    ShowWindow( Application.Handle, SW_SHOW );
  end;
end;


procedure TOptionsCompleteForm.TB_RefreshChange(Sender: TObject);
begin
  Lbl_Framerate.Caption := inttostr(1000 DIV (100 - TB_Refresh.Position)) + ' fps';
end;

procedure TOptionsCompleteForm.CB_FadingClick(Sender: TObject);
begin
  SE_Fade.Enabled := CB_Fading.Checked;
  SE_SeekFade.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnShortTracks.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnPause.Enabled := CB_Fading.Checked;
  CB_IgnoreFadingOnStop.Enabled := CB_Fading.Checked;
  LblConst_TitleChange.Enabled := CB_Fading.Checked;
  LblConst_TitleFade.Enabled := CB_Fading.Checked;
  LblConst_ms2.Enabled := CB_Fading.Checked;
  LblConst_ms2.Enabled := CB_Fading.Checked;
end;

procedure TOptionsCompleteForm.CB_SilenceDetectionClick(Sender: TObject);
begin
  Lbl_SilenceThreshold.Enabled := CB_SilenceDetection.Checked;
  SE_SilenceThreshold.Enabled  := CB_SilenceDetection.Checked;
  Lbl_SilenceDB.Enabled        := CB_SilenceDetection.Checked;
end;

procedure TOptionsCompleteForm.cb_RatingActiveClick(Sender: TObject);
begin
  cb_RatingIgnoreShortFiles             .Enabled := cb_RatingActive.Checked;
  // cb_RatingWriteToFiles                 .Enabled := cb_RatingActive.Checked;
  cb_RatingChangeCounter                .Enabled := cb_RatingActive.Checked;
  // cb_RatingIgnoreCounterOnAbortedTracks .Enabled := cb_RatingActive.Checked and cb_RatingChangeCounter.Checked;
  cb_RatingIncreaseRating               .Enabled := cb_RatingActive.Checked;
  cb_RatingDecreaseRating               .Enabled := cb_RatingActive.Checked;
end;

procedure TOptionsCompleteForm.cb_RatingChangeCounterClick(Sender: TObject);
begin
  // cb_RatingIgnoreCounterOnAbortedTracks .Enabled := cb_RatingActive.Checked and cb_RatingChangeCounter.Checked;
end;


procedure TOptionsCompleteForm.CB_visualClick(Sender: TObject);
begin
  TB_Refresh.Enabled := CB_Visual.Checked;
  Lbl_Framerate.Enabled := CB_Visual.Checked;
end;

procedure TOptionsCompleteForm.CB_ScrollTitelTaskBarClick(Sender: TObject);
begin
    CB_TaskbarDelay.Enabled := CB_ScrollTitelTaskBar.Checked;
end;

procedure TOptionsCompleteForm.CB_ScrollTitleInMainWindowClick(
  Sender: TObject);
begin
    CB_AnzeigeDelay.Enabled := CB_ScrollTitleInMainWindow.Checked;
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

procedure TOptionsCompleteForm.CBChangeFontOnCbrVbrClick(Sender: TObject);
begin
  LblConst_FontVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  LblConst_FontCBR.Enabled := CBChangeFontOnCbrVbr.Checked;

  CBFontNameVBR.Enabled := CBChangeFontOnCbrVbr.Checked;
  CBFontNameCBR.Enabled := CBChangeFontOnCbrVbr.Checked;
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
    //showmessage(inttostr(NempPlayer.MainDevice) + ' - ' + inttostr(NempPlayer.HeadsetDevice));

    NempPlaylist.RepairBassEngine(True);

    MainDeviceCB.Items.Clear;
    HeadPhonesDeviceCB.Items.Clear;

    count := 1;
    while (Bass_GetDeviceInfo(count, BassInfo)) do
    begin
        // BASS_Init(count, 44100, 0, Nemp_MainForm.Handle, nil);
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
      begin
          ftr.DeleteUserChoice(NempPlayer.ValidExtensions[i]);
          ftr.RegisterType(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', 'Nemp Audiofile', Paramstr(0), 0);
          ftr.DeleteSpecialSetting(NempPlayer.ValidExtensions[i]);
      end;

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
    begin
        ftr.RegisterType(CBPlaylistTypes.Items[i], 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
        ftr.DeleteSpecialSetting(CBPlaylistTypes.Items[i]);
    end;

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

  // iTouch-Player setzen
  // removed 2017
  // if CBiTouch.Checked then
  //  ftr.SetITouchMediaPlayer('"' +  Paramstr(0) + '"');

  ftr.UpdateShell;
  ftr.free;
end;


procedure TOptionsCompleteForm.cbIncludeAllClick(Sender: TObject);
begin
  cbIncludeFiles.Enabled := NOT cbIncludeAll.Checked;
  BtnRecommendedFiletypes.Enabled := NOT cbIncludeAll.Checked;
  LblConst_OnlythefollowingTypes.Enabled := NOT cbIncludeAll.Checked;
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
      //CB_DisableAutoDeleteAtSlide.Enabled         := CB_AutoDeleteFromPlaylist.Checked  ;
      //CB_DisableAutoDeleteAtPause.Enabled         := CB_AutoDeleteFromPlaylist.Checked  ;
      //CB_DisAbleAutoDeleteAtStop.Enabled          := CB_AutoDeleteFromPlaylist.Checked  ;
      //CB_DisableAutoDeleteAtTitleChange.Enabled   := CB_AutoDeleteFromPlaylist.Checked  ;
end;


procedure TOptionsCompleteForm.FormActivate(Sender: TObject);
var i, s: Integer;
begin
  // Checkboxen der Spalten ggf. aktualisieren
  // Nötig, weil wir wegen dem Geburtstag Kein Modales Show machen
  for i := 0 to Length(CBSpalten)-1 do
  begin
    s := GetColumnIDfromPosition(Nemp_MainForm.VST, i);
    CBSpalten[i].Caption := Nemp_MainForm.VST.Header.Columns[s].Text;
    CBSpalten[i].Checked := coVisible in Nemp_MainForm.VST.Header.Columns[s].Options;
 end;
 //CBCoverColumn.Checked := Nemp_MainForm.VDTCover.Visible;
 cbCoverMode.ItemIndex := Nemp_MainForm.NempOptions.CoverMode;
 cbDetailMode.ItemIndex := Nemp_MainForm.NempOptions.DetailMode;
end;

// GeburtstagsOptionen
procedure TOptionsCompleteForm.BtnCountDownSongClick(Sender: TObject);
begin
  If OpenDlg_CountdownSongs.Execute then
    EditCountDownSong.Text := OpenDlg_CountdownSongs.FileName;
end;

procedure TOptionsCompleteForm.BtnBirthdaySongClick(Sender: TObject);
begin
  If OpenDlg_CountdownSongs.Execute then
    EditBirthdaySong.Text := OpenDlg_CountdownSongs.FileName;
end;

function TOptionsCompleteForm.GetFocussedAudioFileName: UnicodeString;
var aNode: PVirtualNode;
  Data: PTreeData;
begin
  result := '';
  if Nemp_MainForm.AktiverTree = NIL then exit;
  aNode := Nemp_MainForm.AktiverTree.FocusedNode;
  if not assigned(aNode) then exit;

  Data := Nemp_MainForm.AktiverTree.GetNodeData(aNode);
  result := Data^.FAudioFile.Pfad;
end;

procedure TOptionsCompleteForm.BtnGetCountDownTitelClick(Sender: TObject);
begin
  EditCountDownSong.Text := GetFocussedAudioFileName;
end;


procedure TOptionsCompleteForm.BtnGetBirthdayTitelClick(Sender: TObject);
begin
  EditBirthdaySong.Text := GetFocussedAudioFileName;
end;



procedure TOptionsCompleteForm.cbSkinAuswahlChange(Sender: TObject);

begin
end;

(*
procedure TOptionsCompleteForm.GRPBOXControlPaint(Sender: TObject);
begin
  //TestSkin.DrawAOptionsGroupbox((Sender as TNempGroupbox));
end;*)

procedure TOptionsCompleteForm.NewPlayerPanelOptionsPaint(Sender: TObject);
begin
    //TestSkin.DrawAPanel((Sender as TNempPanel), TestSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
    TestSkin.DrawPreview(Sender as TNempPanel);
end;

procedure TOptionsCompleteForm.BTNApplyClick(Sender: TObject);
var i,s,l, maxfont:integer;
  NeedUpdate, NeedTotalStringUpdate, NeedTotalLyricStringUpdate, NeedCoverFlowSearchUpdate: boolean;
  newLanguage, tmp: String;
  ReDrawVorauswahlTrees, ReDrawPlaylistTree, ReDrawMedienlistTree: Boolean;
  Ini: TMemIniFile;
    hMod: Cardinal;
    hKey: Byte;
  oldfactor: single;
begin
  // Beta-Optionen
//  MedienBib.BetaDontUseThreadedUpdate := cb_BetaDontUseThreadedUpdate.Checked;



  if cb_UseClassicCoverflow.Checked then
  begin
      if MedienBib.NewCoverFlow.Mode <> cm_Classic then
          MedienBib.NewCoverFlow.Mode := cm_Classic
  end else
  begin
      if MedienBib.NewCoverFlow.Mode <> cm_OpenGL then
          MedienBib.NewCoverFlow.Mode := cm_OpenGL;
  end;


  Nemp_MainForm.NempOptions.FixCoverFlowOnStart := cbFixCoverFlowOnStart.Checked;


// ----------------------Player------------------------------
  Bass_SetDevice(MainDeviceCB.ItemIndex + 1);
  BASS_SetConfig(BASS_CONFIG_BUFFER,SEBufferSize.Value);
  NempPlayer.PlayBufferSize := SEBufferSize.Value;

//  if (HeadPhonesDeviceCB.Items.Count > 0) AND (MainDeviceCB.ItemIndex = HeadPhonesDeviceCB.ItemIndex) then
//  begin
//    HeadPhonesDeviceCB.ItemIndex := (MainDeviceCB.ItemIndex + 1) MOD (HeadPhonesDeviceCB.Items.Count);
    //MessageDlg('Identische Angaben für Hauptdevice/Kopfhörer. Auswahl wurde automatisch korrigiert.', mtWarning, [mbOK], 0);
//  end;
  NempPlayer.MainDevice := MainDeviceCB.ItemIndex + 1;
  NempPlayer.HeadsetDevice := HeadPhonesDeviceCB.ItemIndex +1;

  NempPlayer.UseFloatingPointChannels := CB_FloatingPoint.ItemIndex;
  NempPlayer.UseHardwareMixing := CB_Mixing.ItemIndex = 0;
  NempPlayer.UpdateFlags;
  // Anzeige aktualisieren
  if NempPlayer.Floatable then
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_On
  else
    Lbl_FloatingPoints_Status.Caption := FloatingPointChannels_Off;

  NempPlaylist.DefaultAction := GrpBox_DefaultAction.ItemIndex;
  NempPlaylist.HeadSetAction := GrpBox_HeadsetDefaultAction.ItemIndex;
  NempPlaylist.AutoStopHeadset := cb_AutoStopHeadset.Checked;

  NempPlayer.UseFading := CB_Fading.Checked;
  NempPlayer.UseVisualization := CB_Visual.Checked;
  if not NempPlayer.UseVisualization then
    spectrum.DrawClear;
  NempPlayer.FadingInterval := SE_Fade.Value;
  NempPlayer.SeekFadingInterval := SE_SeekFade.Value;
  NempPlayer.IgnoreFadingOnShortTracks := CB_IgnoreFadingOnShortTracks.Checked;
  NempPlayer.IgnoreFadingOnPause := CB_IgnoreFadingOnPause.Checked;
  NempPlayer.IgnoreFadingOnStop := CB_IgnoreFadingOnStop.Checked;

  NempPlayer.DoSilenceDetection := CB_SilenceDetection.Checked ;
  NempPlayer.SilenceThreshold   := SE_SilenceThreshold.Value   ;

  NempPlayer.VisualizationInterval := 100 - TB_Refresh.Position;
  NempPlayer.ScrollTaskbarTitel := CB_ScrollTitelTaskBar.Checked;
  NempPlayer.ScrollAnzeigeTitel := CB_ScrollTitleInMainWindow.Checked;

  NempPlayer.ScrollTaskbarDelay :=  (4 - CB_TaskbarDelay.ItemIndex + 1)* 5;
  NempPlayer.ScrollAnzeigeDelay := (4 - CB_AnzeigeDelay.ItemIndex) * 2;
  Spectrum.ScrollDelay := (4 - CB_AnzeigeDelay.ItemIndex) * 2;


  NempPlayer.ReInitAfterSuspend := cbReInitAfterSuspend.Checked;
  NempPlayer.PauseOnSuspend := cbPauseOnSuspend.Checked;

  NempPlayer.AvoidMickyMausEffect := GrpBox_MickyMouse.ItemIndex = 0;

  NempPlayer.UseDefaultEffects := CB_UseDefaultEffects.Checked;
  NempPlayer.UseDefaultEqualizer := CB_UseDefaultEqualizer.Checked;


  NempPlayer.ReduceMainVolumeOnJingle := CBJingleReduce.Checked;
  NempPlayer.ReduceMainVolumeOnJingleValue := SEJingleReduce.Value;
  NempPlayer.JingleVolume := SEJingleVolume.Value;

  NempPlayer.UseWalkmanMode := cb_UseWalkmanMode.Checked;
  Nemp_MainForm.WalkmanModeTimer.Enabled := cb_UseWalkmanMode.Checked;
  if Not NempPlayer.UseWalkmanMode then
      StopFluttering;

  if Not NempPlayer.ScrollAnzeigeTitel then
  begin
    Spectrum.TextPosX := 0;
    Spectrum.DrawText;
  end;

  if not NempPlayer.ScrollTaskbarTitel then
      Application.Title := NempPlayer.GenerateTaskbarTitel;
  Nemp_MainForm.BassTimer.Interval := NempPlayer.VisualizationInterval;

  NempPlaylist.AutoScan         := CB_AutoScanPlaylist.checked;
  NempPlaylist.AutoPlayOnStart  := CB_AutoPlayOnStart.Checked;
  NempPlaylist.SavePositionInTrack := cb_SavePositionInTrack.Checked;
  NempPlaylist.AutoPlayNewTitle := CB_AutoPlayNewTitle.Checked;
  NempPlaylist.AutoPlayEnqueuedTitle := CB_AutoPlayEnqueueTitle.Checked;

  NempPlaylist.AutoSave         := CB_AutoSavePlaylist.Checked;
  //NempPlaylist.AutoSaveInterval := SEAutoSavePlaylistInterval.Value;
  Nemp_MainForm.AutoSavePlaylistTimer.Enabled := CB_AutoSavePlaylist.Checked;
  Nemp_MainForm.AutoSavePlaylistTimer.Interval := 5 * 60000;

  NempPlaylist.AutoDelete                   := CB_AutoDeleteFromPlaylist.Checked       ;
  NempPlaylist.DisableAutoDeleteAtUserInput := CB_DisableAutoDeleteAtUserInput.Checked ;

        //NempPlaylist.DisableAutoDeleteAtSlide        := CB_DisableAutoDeleteAtSlide.Checked         ;
        //NempPlaylist.DisableAutoDeleteAtPause        := CB_DisableAutoDeleteAtPause.Checked         ;
        //NempPlaylist.DisAbleAutoDeleteAtStop         := CB_DisAbleAutoDeleteAtStop.Checked          ;
        //NempPlaylist.DisableAutoDeleteAtTitleChange  := CB_DisableAutoDeleteAtTitleChange.Checked   ;

  NempPlaylist.AutoMix                         := CB_AutoMixPlaylist.Checked;
  NempPlaylist.JumpToNextCueOnNextClick        := CB_JumpToNextCue.Checked;
  NempPlaylist.RepeatCueOnRepeatTitle          := cb_ReplayCue.Checked;
  NempPlaylist.RememberInterruptedPlayPosition := CB_RememberInterruptedPlayPosition.Checked;
  NempPlaylist.ShowHintsInPlaylist := CB_ShowHintsInPlaylist.Checked;
  Nemp_MainForm.PlaylistVST.ShowHint := NempPlaylist.ShowHintsInPlaylist;

  NempPlaylist.RandomRepeat := TBRandomRepeat.Position;

  NempPlayer.DownloadDir := IncludeTrailingPathDelimiter(EdtDownloadDir.Text);
  NempPlayer.FilenameFormat := cbFilenameFormat.Text;
  NempPlayer.AutoSplitByTitle := cbAutoSplitByTitle.Checked;
  NempPlayer.UseStreamnameAsDirectory := cbUseStreamnameAsDirectory.Checked;

  NempPlayer.AutoSplitByTime := cbAutoSplitBySize.Checked;
  NempPlayer.AutoSplitBySize := cbAutoSplitByTime.Checked;
  NempPlayer.AutoSplitMaxSize := SE_AutoSplitMaxSize.Value;
  NempPlayer.AutoSplitMaxTime := SE_AutoSplitMaxTime.Value;

  NempPlaylist.BassHandlePlaylist := (RGroup_Playlist.ItemIndex = 1);

//----------------------allgemein---------------------
  Nemp_MainForm.NempOptions.ChangeFontColorOnBitrate := CBChangeFontColorOnBitrate.Checked;
  Nemp_MainForm.NempOptions.ChangeFontSizeOnLength := CBChangeFontSizeOnLength.Checked;
  Nemp_MainForm.NempOptions.ChangeFontStyleOnMode := CBChangeFontStyleOnMode.Checked;
  Nemp_MainForm.NempOptions.ChangeFontOnCbrVbr := CBChangeFontOnCbrVbr.Checked;


  Nemp_MainForm.NempOptions.DefaultFontSize := SEFontSize.Value;
  Nemp_MainForm.NempOptions.DefaultFontStyle      := cb_Medialist_FontStyle.ItemIndex ;
  Nemp_MainForm.NempOptions.ArtistAlbenFontStyle  := cb_Browselist_FontStyle.ItemIndex;
  // translate into actual font styles
  Nemp_MainForm.NempOptions.DefaultFontStyles     := FontSelectorItemIndexToStyle(Nemp_MainForm.NempOptions.DefaultFontStyle);
  Nemp_MainForm.NempOptions.ArtistAlbenFontStyles := FontSelectorItemIndexToStyle(Nemp_MainForm.NempOptions.ArtistAlbenFontStyle);



  for i := 0 to Spaltenzahl-1 do
  begin
    s := GetColumnIDfromPosition(Nemp_MainForm.VST, i);

    //if CBSpaltenSetup.Checked[i] then
    if CBSpalten[i].Checked then
      Nemp_MainForm.VST.Header.Columns[s].Options := Nemp_MainForm.VST.Header.Columns[s].Options + [coVisible]
    else
      Nemp_MainForm.VST.Header.Columns[s].Options := Nemp_MainForm.VST.Header.Columns[s].Options - [coVisible];
  end;

  Nemp_MainForm.NempOptions.CoverMode := cbCoverMode.ItemIndex;

  if Nemp_MainForm.NempOptions.DetailMode <> cbDetailMode.ItemIndex then
  begin
      Nemp_MainForm.NempOptions.DetailMode := cbDetailMode.ItemIndex;
  end;

  Nemp_MainForm.ActualizeVDTCover;

  Nemp_MainForm.NempOptions.FontNameCBR := CBFontNameCBR.Items[CBFontNameCBR.itemindex];
  Nemp_MainForm.NempOptions.FontNameVBR := CBFontNameVBR.Items[CBFontNameVBR.itemindex];

  MedienBib.CoverSearchInDir       := CB_CoverSearch_inDir.Checked;
  MedienBib.CoverSearchInParentDir := CB_CoverSearch_inParentDir.Checked;
  MedienBib.CoverSearchInSubDir    := CB_CoverSearch_inSubDir.Checked;
  MedienBib.CoverSearchInSisterDir := CB_CoverSearch_inSisterDir.Checked;

  // clear coverflow, if setting is changed
  if MedienBib.CoverSearchLastFM <> CB_CoverSearch_LastFM.Checked then
  begin
      MedienBib.CoverSearchLastFM := CB_CoverSearch_LastFM.Checked;
      MedienBib.NewCoverFlow.ClearTextures;
  end;
  {if CB_CoverSearch_LastFM.Checked then
  begin
      if MedienBib.CoverSearchLastFM <> BoolTrue then // i.e. false ore undefined
      begin
          MedienBib.CoverSearchLastFM  := BoolTrue;   // set it to true
          MedienBib.NewCoverFlow.ClearTextures;
      end;
  end
  else
      if MedienBib.CoverSearchLastFM = BoolTrue then  // really true, if undef: it remains undef
      begin
          MedienBib.CoverSearchLastFM  := BoolFalse;
          MedienBib.NewCoverFlow.ClearTextures;
      end;
  }

  MedienBib.CoverSearchSubDirName := EDTCoverSubDirName.Text ;
  MedienBib.CoverSearchSisterDirName := EDTCoverSisterDirName.Text;
  MedienBib.HideNACover := cbHideNACover.Checked;


  //Nemp_MainForm.NempOptions.DenyId3Edit := cbDenyId3Edit.Checked;
  Nemp_MainForm.NempOptions.FullRowSelect := cbFullRowSelect.Checked;
  Nemp_MainForm.NempOptions.EditOnClick   := CB_EditOnClick.Checked;
  MedienBib.AlwaysSortAnzeigeList := cbAlwaysSortAnzeigeList.Checked;
  MedienBib.SkipSortOnLargeLists := CBSkipSortOnLargeLists.Checked;
  MedienBib.AutoScanPlaylistFilesOnView := CBAutoScanPlaylistFilesOnView.Checked;
  MedienBib.ShowHintsInMedialist := CBShowHintsInMedialist.Checked;
  Nemp_MainForm.VST.ShowHint := MedienBib.ShowHintsInMedialist;

  NeedUpdate := False;
  NeedTotalStringUpdate := False;
  NeedTotalLyricStringUpdate := False;
  NeedCoverFlowSearchUpdate := False;

  if MedienBib.StatusBibUpdate = 0 then
  begin
      if ((
          (CBSortArray1.ItemIndex <> integer(MedienBib.NempSortArray[1]))
          OR (CBSortArray2.ItemIndex <> integer(MedienBib.NempSortArray[2]))
          )
          AND
          (MedienBib.BrowseMode = 0)
          )
          OR
          (
          ((cbCoverSortOrder.ItemIndex + 1) <> MedienBib.CoverSortOrder)
          AND
          (MedienBib.BrowseMode = 1)
          )
          OR
          (
          ((cbMissingCoverMode.ItemIndex) <> MedienBib.MissingCoverMode)
          AND
          (MedienBib.BrowseMode = 1)
          )
      then
      begin
          // We have changed something with the current Browse-Values
          // Update needed
          NeedUpdate := True;
      end;
      if (MedienBib.BrowseMode = 1)  AND
          (cb_ChangeCoverflowOnSearch.Checked <> MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow) 
      then
            NeedCoverFlowSearchUpdate := True;
            
      // However, we can synchronize VCL and Data here always. ;-)
      MedienBib.NempSortArray[1] := TAudioFileStringIndex(CBSortArray1.ItemIndex);
      MedienBib.NempSortArray[2] := TAudioFileStringIndex(CBSortArray2.ItemIndex);
      MedienBib.CoverSortOrder := cbCoverSortOrder.ItemIndex + 1;
      MedienBib.MissingCoverMode := cbMissingCoverMode.ItemIndex;

      Nemp_MainForm.NempOptions.ReplaceNAArtistBy := cbReplaceArtistBy.ItemIndex;
      Nemp_MainForm.NempOptions.ReplaceNATitleBy := cbReplaceTitleBy .ItemIndex;
      Nemp_MainForm.NempOptions.ReplaceNAAlbumBy := cbReplaceAlbumBy .ItemIndex;

      // MedienBib, Suchoptionen
      NeedTotalLyricStringUpdate := MedienBib.BibSearcher.AccelerateLyricSearch <> CB_AccelerateLyricSearch.Checked;

      NeedTotalStringUpdate := (MedienBib.BibSearcher.AccelerateSearch <> CB_AccelerateSearch.Checked)
                             or (MedienBib.BibSearcher.AccelerateSearchIncludePath <> CB_AccelerateSearchIncludePath.Checked)
                             or (MedienBib.BibSearcher.AccelerateSearchIncludeComment <> CB_AccelerateSearchIncludeComment.Checked);
      MedienBib.BibSearcher.AccelerateSearch               := CB_AccelerateSearch                 .Checked;
      MedienBib.BibSearcher.AccelerateSearchIncludePath    := CB_AccelerateSearchIncludePath      .Checked;
      MedienBib.BibSearcher.AccelerateSearchIncludeComment := CB_AccelerateSearchIncludeComment   .Checked;
      MedienBib.BibSearcher.AccelerateLyricSearch          := CB_AccelerateLyricSearch            .Checked;

      MedienBib.BibSearcher.QuickSearchOptions.WhileYouType       := CB_QuickSearchWhileYouType          .Checked;
      MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow    := cb_ChangeCoverflowOnSearch          .Checked;
      MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter := CB_QuickSearchAllowErrorsOnEnter    .Checked;
      MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType  := CB_QuickSearchAllowErrorsWhileTyping.Checked;
  end else
  begin
    MessageDLG((Warning_MedienBibIsBusy_Options), mtWarning, [MBOK], 0);
    CBSortArray1.ItemIndex := integer(MedienBib.NempSortArray[1]);
    CBSortArray2.ItemIndex := integer(MedienBib.NempSortArray[2]);
    cbCoverSortOrder.ItemIndex := MedienBib.CoverSortOrder - 1;
    cbMissingCoverMode.ItemIndex := MedienBib.MissingCoverMode;
  end;

  MedienBib.AutoScanDirs := CBAutoScan.Checked;
  MedienBib.AutoScanDirList.Clear;
  for i := 0 to LBAutoScan.Items.Count - 1 do
      MedienBib.AutoScanDirList.Add(LBAutoScan.Items[i]);
  MedienBib.AskForAutoAddNewDirs := CBAskForAutoAddNewDirs.Checked;
  MedienBib.AutoAddNewDirs       := CBAutoAddNewDirs.Checked      ;

  if Nemp_MainForm.NempOptions.FullRowSelect then
    Nemp_MainForm.VST.TreeOptions.SelectionOptions := Nemp_MainForm.VST.TreeOptions.SelectionOptions + [toFullRowSelect]
  else
    Nemp_MainForm.VST.TreeOptions.SelectionOptions := Nemp_MainForm.VST.TreeOptions.SelectionOptions - [toFullRowSelect];

  if Nemp_MainForm.NempOptions.EditOnClick then
      Nemp_MainForm.VST.TreeOptions.MiscOptions := Nemp_MainForm.VST.TreeOptions.MiscOptions + [toEditOnClick]
  else
      Nemp_MainForm.VST.TreeOptions.MiscOptions := Nemp_MainForm.VST.TreeOptions.MiscOptions - [toEditOnClick];

  Nemp_MainForm.NempOptions.ShowSplashScreen := cb_ShowSplashScreen.Checked;
  Nemp_MainForm.NempOptions.AllowOnlyOneInstance := Not CB_AllowMultipleInstances.Checked;
  Nemp_MainForm.NempOptions.StartMinimized  := CB_StartMinimized.Checked;
  Nemp_MainForm.NempOptions.RegisterHotKeys := CBRegisterHotKeys.Checked;

  Nemp_MainForm.NempOptions.TabStopAtPlayerControls := CB_TabStopAtPlayerControls.Checked;
  Nemp_MainForm.NempOptions.TabStopAtTabs           := CB_TabStopAtTabs          .Checked;
  SetTabStopsPlayer;
  SetTabStopsTabs;

  Nemp_MainForm.NempOptions.RegisterMediaHotkeys   := cb_RegisterMediaHotkeys.Checked;
  Nemp_MainForm.NempOptions.IgnoreVolumeUpDownKeys := CB_IgnoreVolume.Checked;

  if cb_UseG15Display.Checked and (NOT Nemp_MainForm.NempOptions.UseDisplayApp) then
  begin
      // G15 App is not currently active -> activate it!
      if Nemp_MainForm.NempOptions.DisplayApp = '' then
            tmp := 'NempG15App.exe'
        else
            tmp := Nemp_MainForm.NempOptions.DisplayApp;

        tmp := ExtractFilepath(paramStr(0)) + tmp;
        if FileExists(tmp) then
            shellexecute(Handle,'open',pchar('"' + tmp + '"'),'userstart',NIL,sw_hide)
        else
            TranslateMessageDLG((StartG15AppNotFound), mtWarning, [mbOK], 0)
  end;

  Nemp_MainForm.NempOptions.UseDisplayApp          := cb_UseG15Display.Checked;

  NempPlayer.SafePlayback := cb_SafePlayback.Checked;

  MedienBib.IncludeAll := cbIncludeAll.Checked;

  if Not MedienBib.IncludeAll then
  begin
      MedienBib.IncludeFilter := '';
      for i := 0 to CBIncludeFiles.Count - 1 do
      begin
          if CBIncludeFiles.Checked[i] then
              MedienBib.IncludeFilter := MedienBib.IncludeFilter + ';*' + CBIncludeFiles.Items[i];
      end;
      // delete first ';'
      if (MedienBib.IncludeFilter <> '') AND (MedienBib.IncludeFilter[1] = ';') then
            MedienBib.IncludeFilter := copy(MedienBib.IncludeFilter, 2, length(MedienBib.IncludeFilter));

      if MedienBib.IncludeFilter = '' then
          MedienBib.IncludeFilter := '*.mp3'
  end;


  MedienBib.AutoLoadMediaList := CBAutoLoadMediaList.Checked;
  MedienBib.AutoSaveMediaList := CBAutoSaveMediaList.Checked;

  if not assigned(FDetails) then
      Application.CreateForm(TFDetails, FDetails);

  //FDetails.UpdateID3ReadOnlyStatus;//SetID3EditsWritable(False);

  // Fensterverhalten:
  if Nemp_MainForm.NempOptions.NempWindowView <> GrpBox_TaskTray.ItemIndex then
  begin
      // Hide Taskbar-entry

      {NEMPWINDOW_ONLYTASKBAR = 0;
    NEMPWINDOW_TASKBAR_MIN_TRAY = 1;
    NEMPWINDOW_TRAYONLY = 2;
    NEMPWINDOW_BOTH = 3;
    NEMPWINDOW_BOTH_MIN_TRAY = 4;}

      if      (GrpBox_TaskTray.ItemIndex = NEMPWINDOW_TRAYONLY) // user want no taskbar-entry at all ...
          and (Nemp_MainForm.NempOptions.NempWindowView in
               [  NEMPWINDOW_ONLYTASKBAR,
                  NEMPWINDOW_TASKBAR_MIN_TRAY,
                  NEMPWINDOW_BOTH,
                  NEMPWINDOW_BOTH_MIN_TRAY ])                   // .. and there is currently an entry
      then
      begin
          // Change it (and loose the Taskbarbuttons on Win7)
          ShowWindow( Application.Handle, SW_HIDE );
          SetWindowLong( Application.Handle, GWL_STYLE,
                     GetWindowLong(Application.Handle, GWL_STYLE)
                         or WS_EX_TOOLWINDOW
                         and not WS_EX_APPWINDOW
                     );
          ShowWindow( Application.Handle, SW_SHOW );
      end else
          if (Nemp_MainForm.NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY)   // user has no entry
              and (GrpBox_TaskTray.ItemIndex in
                  [ NEMPWINDOW_ONLYTASKBAR,
                    NEMPWINDOW_TASKBAR_MIN_TRAY,
                    NEMPWINDOW_BOTH,
                    NEMPWINDOW_BOTH_MIN_TRAY ])                                 // but wants some
          then
          // User want a taskbar-entry
          begin
              ShowWindow( Application.Handle, SW_HIDE );
              SetWindowLong( Application.Handle, GWL_EXSTYLE,
                         Nemp_MainForm.NempWindowDefault );
              ShowWindow( Application.Handle, SW_SHOW );
          end;
      // Set new value
      Nemp_MainForm.NempOptions.NempWindowView := GrpBox_TaskTray.ItemIndex;

        // TrayIcon erzeugen, behalten oder löschen
      if GrpBox_TaskTray.ItemIndex in [NEMPWINDOW_TRAYONLY, NEMPWINDOW_BOTH, NEMPWINDOW_BOTH_MIN_TRAY] then
      begin
        // TrayIcon erzeugen oder beibehalten
        Nemp_MainForm.NempTrayIcon.Visible := True;
      end else
      begin
        // TrayIcon löschen
        Nemp_MainForm.NempTrayIcon.Visible := False;
      end;
  end;

  Nemp_MainForm.NempOptions.ShowDeskbandOnMinimize := CBShowDeskbandOnMinimize.Checked;
  Nemp_MainForm.NempOptions.ShowDeskbandOnStart    := CBShowDeskbandOnStart.Checked;
  Nemp_MainForm.NempOptions.HideDeskbandOnRestore  := CBHideDeskbandOnRestore.Checked;
  Nemp_MainForm.NempOptions.HideDeskbandOnClose    := CBHideDeskbandOnClose.Checked;

  ReDrawVorauswahlTrees := (Nemp_MainForm.ArtistsVST.DefaultNodeHeight <> Cardinal(SEArtistAlbenRowHeight.Value));

  Nemp_MainForm.NempOptions.ArtistAlbenFontSize := SEArtistAlbenSIze.Value;
  Nemp_MainForm.NempOptions.ArtistAlbenRowHeight := SEArtistAlbenRowHeight.Value;

  Nemp_MainForm.ArtistsVST.DefaultNodeHeight := Nemp_MainForm.NempOptions.ArtistAlbenRowHeight;
  Nemp_MainForm.AlbenVST.DefaultNodeHeight := Nemp_MainForm.NempOptions.ArtistAlbenRowHeight;
  Nemp_MainForm.ArtistsVST.Font.Size := Nemp_MainForm.NempOptions.ArtistAlbenFontSize;
  Nemp_MainForm.AlbenVST.Font.Size := Nemp_MainForm.NempOptions.ArtistAlbenFontSize;


  if NeedTotalLyricStringUpdate then Medienbib.BuildTotalLyricString;
  if NeedTotalStringUpdate then MedienBib.BuildTotalString;

  if NeedCoverFlowSearchUpdate then
      RestoreCoverFlowAfterSearch(True);

      
  if NeedUpdate then
  begin
      // Browse-Listen neu aufbauen
      case MedienBib.BrowseMode of
          0: begin
              MedienBib.ReBuildBrowseLists;
          end;
          1: begin
                MedienBib.ReBuildCoverList;
                If MedienBib.Coverlist.Count > 3 then
                    Nemp_MainForm.CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                else
                    Nemp_MainForm.CoverScrollbar.Max := 3;
                MedienBib.NewCoverFlow.FindCurrentItemAgain;
          end;
          2: begin
              // nothing to do.
          end;
      end;
      Nemp_MainForm.ShowSummary;
  end else
  begin
    if ReDrawVorauswahlTrees then
    begin
        // Artist/Alben-Bäume nur neu füllen
        // (aber nur bei anderen Zeilenhöhen - sonst ist auch das nicht nötig.)
        if MedienBib.NempSortArray[1] = siOrdner then
          FillStringTreeWithSubNodes(MedienBib.AlleArtists, Nemp_MainForm.ArtistsVST)
        else
          FillStringTree(MedienBib.AlleArtists, Nemp_MainForm.ArtistsVST);

        if MedienBib.NempSortArray[2] = siOrdner then
          FillStringTreeWithSubNodes(Medienbib.Alben, Nemp_MainForm.AlbenVST)
        else
          FillStringTree(Medienbib.Alben, Nemp_MainForm.AlbenVST);
    end;
  end;

  //Nemp_MainForm.NempOptions.MinFontColor    := ShapeMinColor.Brush.Color;
  //Nemp_MainForm.NempOptions.MiddleFontColor := ShapeMittelColor.Brush.Color;
  //Nemp_MainForm.NempOptions.MaxFontColor    := ShapeMaxColor.Brush.Color;
  //Nemp_MainForm.NempOptions.MiddleToMinComputing := CBMiddleToMinComputing.ItemIndex;
  //Nemp_MainForm.NempOptions.MiddleToMaxComputing := CBMiddleToMaxComputing.ItemIndex;

  // Basis-Value für [3] nehmen
  /// Nemp_MainForm.NempOptions.FontSize[3] :=  SEFontSize.Value;

  /// Nemp_MainForm.NempOptions.FontSize[1] :=  max(4,
  ///                 Nemp_MainForm.NempOptions.FontSize[3] - (Nemp_MainForm.NempOptions.FontSize[3] Div 2));

  /// Nemp_MainForm.NempOptions.FontSize[2] :=  max(4,
  ///                 Nemp_MainForm.NempOptions.FontSize[3] - (Nemp_MainForm.NempOptions.FontSize[3] Div 4));

  /// Nemp_MainForm.NempOptions.FontSize[4] :=  Nemp_MainForm.NempOptions.FontSize[3] + (Nemp_MainForm.NempOptions.FontSize[3] Div 4);
  /// Nemp_MainForm.NempOptions.FontSize[5] :=  Nemp_MainForm.NempOptions.FontSize[3] + (Nemp_MainForm.NempOptions.FontSize[3] Div 2);
  Nemp_MainForm.NempOptions.RowHeight := SERowHeight.Value;

  if Nemp_MainForm.NempOptions.ChangeFontSizeOnLength then
      maxFont := MaxFontSize(Nemp_MainForm.NempOptions.DefaultFontSize)
  else
      maxFont := Nemp_MainForm.NempOptions.DefaultFontSize;

  ReDrawPlaylistTree := Nemp_MainForm.PlaylistVST.DefaultNodeHeight <> Cardinal(Nemp_MainForm.NempOptions.RowHeight);
  ReDrawMedienlistTree := Nemp_MainForm.VST.DefaultNodeHeight <> Cardinal(Nemp_MainForm.NempOptions.RowHeight);

  Nemp_MainForm.VST.DefaultNodeHeight := Nemp_MainForm.NempOptions.RowHeight;
  Nemp_MainForm.PlaylistVST.DefaultNodeHeight := Nemp_MainForm.NempOptions.RowHeight;

  with Nemp_MainForm do
  begin
      VST.Font.Size := NempOptions.DefaultFontSize;

      PlaylistVST.Canvas.Font.Size := maxFont;
      PlaylistVST.Header.Columns[1].Width := PlaylistVST.Canvas.TextWidth('@99:99hm');
      PlaylistVSTResize(Nil);

      PlaylistVST.Font.Size := NempOptions.DefaultFontSize;

      PlaylistVST.Invalidate;
      VST.Invalidate;
      ArtistsVST.Invalidate;
      AlbenVST.Invalidate;
  end;

  // Zeichensätze
  with MedienBib do
  begin
      NempCharCodeOptions.Arabic    := ArabicEncodings[CBArabic.Itemindex];
      NempCharCodeOptions.Chinese   := ChineseEncodings[CBChinese.Itemindex];
      NempCharCodeOptions.Cyrillic  := CyrillicEncodings[CBCyrillic.Itemindex];
      NempCharCodeOptions.Greek     := GreekEncodings[CBGreek.Itemindex];
      NempCharCodeOptions.Hebrew    := HebrewEncodings[CBHebrew.Itemindex];
      NempCharCodeOptions.Japanese  := JapaneseEncodings[CBJapanese.Itemindex];
      NempCharCodeOptions.Korean    := KoreanEncodings[CBKorean.Itemindex];
      NempCharCodeOptions.Thai      := ThaiEncodings[CBThai.Itemindex];
      NempCharCodeOptions.AutoDetectCodePage := CBAutoDetectCharCode.Checked;
  end;

  if ReDrawMedienlistTree then FillTreeView(MedienBib.AnzeigeListe, Nil); //1);
  if ReDrawPlaylistTree then
  begin
    NempPlaylist.FillPlaylistView;
    NempPlaylist.ReInitPlaylist;
  end;

  // Geburtstags-Optionen
  with NempPlayer.NempBirthdayTimer do
  begin
    if (CountDownFileName <> EditCountdownSong.Text)
      or (BirthdaySongFilename <> EditBirthdaySong.Text)
      or (UseCountDown <> CBStartCountDown.Checked)
      or (StartTime <> DTPBirthdayTime.Time)
    then
    begin
        CountDownFileName := EditCountdownSong.Text;
        BirthdaySongFilename := EditBirthdaySong.Text;
        StartTime := (DTPBirthdayTime.Time);
        UseCountDown := CBStartCountDown.Checked AND (Trim(EditCountdownSong.Text)<> '');

        if UseCountDown then
            StartCountDownTime := IncSecond(StartTime, - NempPlayer.GetCountDownLength(CountDownFileName))
        else
            StartCountDownTime := StartTime;
    end;

    ContinueAfter := CBContinueAfter.Checked;
    NempPlayer.WriteBirthdayOptions(SavePath + NEMP_NAME + '.ini');
  end;

  // Hotkeys neu setzen, Ini Speichern
  UnInstallHotKeys(Nemp_MainForm.Handle);
  UninstallMediakeyHotkeys(Nemp_MainForm.Handle);

  ini := TMeminiFile.Create(SavePath + 'Hotkeys.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;
        Ini.WriteBool('HotKeys','InstallHotkey_Play'       , CB_Activate_Play.Checked);
          hMod := IndexToMod(CB_Mod_Play.ItemIndex);
          hKey := IndexToKey(CB_Key_Play.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Play', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Play', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Stop'       , CB_Activate_Stop.Checked);
          hMod := IndexToMod(CB_Mod_Stop.ItemIndex);
          hKey := IndexToKey(CB_Key_Stop.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Stop', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Stop', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Next'       , CB_Activate_Next.Checked);
          hMod := IndexToMod(CB_Mod_Next.ItemIndex);
          hKey := IndexToKey(CB_Key_Next.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Next', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Next', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Prev'       , CB_Activate_Prev.Checked);
          hMod := IndexToMod(CB_Mod_Prev.ItemIndex);
          hKey := IndexToKey(CB_Key_Prev.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Prev', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Prev', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_JumpForward', CB_Activate_JumpForward.Checked);
          hMod := IndexToMod(CB_Mod_JumpForward.ItemIndex);
          hKey := IndexToKey(CB_Key_JumpForward.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_JumpForward', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_JumpForward', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_JumpBack'   , CB_Activate_JumpBack.Checked);
          hMod := IndexToMod(CB_Mod_JumpBack.ItemIndex);
          hKey := IndexToKey(CB_Key_JumpBack.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_JumpBack', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_JumpBack', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_IncVol'     , CB_Activate_IncVol.Checked);
          hMod := IndexToMod(CB_Mod_IncVol.ItemIndex);
          hKey := IndexToKey(CB_Key_IncVol.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_IncVol', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_IncVol', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_DecVol'     , CB_Activate_DecVol.Checked);
          hMod := IndexToMod(CB_Mod_DecVol.ItemIndex);
          hKey := IndexToKey(CB_Key_DecVol.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_DecVol', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_DecVol', hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Mute'       , CB_Activate_mute.Checked);
          hMod := IndexToMod(CB_Mod_Mute.ItemIndex);
          hKey := IndexToKey(CB_Key_Mute.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Mute', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Mute', hKey);
        try
            Ini.UpdateFile;
        except

        end;
  finally
    Ini.Free;
  end;

  if Nemp_MainForm.NempOptions.RegisterHotKeys then
      InstallHotkeys(SavePath, Nemp_MainForm.Handle);
  if Nemp_MainForm.NempOptions.RegisterMediaHotkeys then
      InstallMediakeyHotkeys(Nemp_MainForm.NempOptions.IgnoreVolumeUpDownKeys, Nemp_MainForm.Handle);


  //========================================================

  Nemp_MainForm.NempOptions.MiniNempStayOnTop := cb_StayOnTop.Checked;
  // Todo: Menu-Check-Einträge umsetzen

  with Nemp_MainForm do
  begin
    PM_P_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelformOptions.ErweiterteControlsVisible;
    MM_O_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelformOptions.ErweiterteControlsVisible;

    PM_P_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
    MM_O_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

    PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
    MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
  end;

  Nemp_MainForm.RepairZOrder;
  Show;


  //========================================================

  // Update-Optionen
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

  NempPlayer.NempScrobbler.IgnoreErrors      := CB_SilentError        .Checked;
  NempPlayer.NempScrobbler.AlwaysScrobble    := CB_AlwaysScrobble     .Checked;

  Nemp_MainForm.MM_T_Scrobbler.Checked := CB_ScrobbleThisSession.Checked;
  Nemp_MainForm.PM_P_Scrobbler.Checked := CB_ScrobbleThisSession.Checked;

  if NempPlayer.NempScrobbler.DoScrobble <> CB_ScrobbleThisSession.Checked then
  begin
      NempPlayer.NempScrobbler.DoScrobble := CB_ScrobbleThisSession.Checked;

      if NempPlayer.NempScrobbler.DoScrobble then
      begin
          if NempPlayer.NempScrobbler.Working then
              GrpBox_ScrobbleLog.Caption := Scrobble_Active
          else
              GrpBox_ScrobbleLog.Caption := Scrobble_InActive;
      end else
          GrpBox_ScrobbleLog.Caption := Scrobble_Offline;


      if assigned(NempPlayer.MainAudioFile) and (NempPlayer.Status = PLAYER_ISPLAYING) then
      begin
          // nur neu Scrobbeln, wenn es vorher nicht getan wurde.
          // Sonst wird der Zeitzähler zurückgesetzt, und Submitten ggf. unterbunden
          if NempPlayer.MainAudioFile.IsFile then
          begin
              NempPlayer.NempScrobbler.ChangeCurrentPlayingFile(NempPlayer.MainAudioFile);
              NempPlayer.NempScrobbler.PlaybackStarted;
          end;
      end;
  end;

  // Webserver
  NempWebServer.UsernameU := EdtUsername.Text;
  NempWebServer.PasswordU := EdtPassword.Text;
  NempWebServer.UsernameA := EdtUsernameAdmin.Text;
  NempWebServer.PasswordA := EdtPasswordAdmin.Text;
  NempWebServer.Theme := cbWebServerRootDir.Text;

  NempWebServer.OnlyLAN  := cbOnlyLAN.Checked;

  if (NempWebServer.Port <> seWebServer_Port.Value) and (NempWebServer.Active) then
      MessageDLG((WebServer_PortChangeFailed), mtInformation, [MBOK], 0);

  NempWebServer.Port := seWebServer_Port.Value;

  NempWebServer.AllowLibraryAccess    := cbPermitLibraryAccess.Checked;
  NempWebServer.AllowFileDownload     := cbPermitPlaylistDownload.Checked;
  NempWebServer.AllowRemoteControl    := cbAllowRemoteControl.Checked;
  MedienBib.AutoActivateWebServer     := CBAutoStartWebServer.Checked;
  NempWebServer.AllowVotes            := cbPermitVote.Checked;

  NempWebServer.SaveToIni;

  oldfactor := Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor;

  Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor :=
  Nemp_MainForm.NempSkin.NempPartyMode.IndexToFactor(CB_PartyMode_ResizeFactor.ItemIndex);

  Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit           := cb_PartyMode_BlockTreeEdit          .Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating := cb_PartyMode_BlockCurrentTitleRating.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockTools              := cb_PartyMode_BlockTools             .Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.ShowPasswordOnActivate  := cb_PartyMode_ShowPasswordOnActivate .Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.password := Edt_PartyModePassword.Text;

  Nemp_MainForm.NempOptions.AllowQuickAccessToMetadata  := cb_AccessMetadata                     .checked;
  Nemp_MainForm.NempOptions.UseCDDB                     := cb_UseCDDB                            .checked;

  // automatic rating
  NempPlayer.PostProcessor.Active                       := cb_RatingActive                       .checked ;
  NempPlayer.PostProcessor.IgnoreShortFiles             := cb_RatingIgnoreShortFiles             .checked ;
  NempPlayer.PostProcessor.WriteToFiles                 := cb_AccessMetadata                 .checked ;
  NempPlayer.PostProcessor.ChangeCounter                := cb_RatingChangeCounter                .checked ;
  // NempPlayer.PostProcessor.IgnoreCounterOnAbortedTracks := cb_RatingIgnoreCounterOnAbortedTracks .checked ;
  NempPlayer.PostProcessor.IncPlayedFiles               := cb_RatingIncreaseRating               .checked ;
  NempPlayer.PostProcessor.DecAbortedFiles              := cb_RatingDecreaseRating               .checked ;

  if Nemp_MainForm.GlobalUseAdvancedSkin <> cbUseAdvancedSkin.Checked then
  begin
      Nemp_MainForm.GlobalUseAdvancedSkin := cbUseAdvancedSkin.Checked;

      Nemp_MainForm.MM_O_Skin_UseAdvanced.Checked := Nemp_MainForm.GlobalUseAdvancedSkin;
      Nemp_MainForm.PM_P_Skin_UseAdvancedSkin.Checked := Nemp_MainForm.GlobalUseAdvancedSkin;

      {$IFDEF USESTYLES}
      // deactivate it immediately
      if Not Nemp_MainForm.GlobalUseAdvancedSkin then
      begin
          TStyleManager.SetStyle('Windows');
          Nemp_MainForm.CorrectSkinRegionsTimer.Enabled := True;
      end else
      begin
          // refresh skin, if a skin is used, and it supports advanced skinning
          if Nemp_MainForm.UseSkin then
          begin
              if Nemp_MainForm.NempSkin.UseAdvancedSkin then
                  Nemp_MainForm.ActivateSkin(GetSkinDirFromSkinName(Nemp_MainForm.SkinName))
              else
                  TranslateMessageDLG((AdvancedSkinActivateHint), mtInformation, [MBOK], 0);
          end;
      end;
      {$ENDIF}
  end;


  ReArrangeToolImages;
end;

procedure TOptionsCompleteForm.BTNokClick(Sender: TObject);
begin
  BTNApplyClick(Nil);
  Close;
end;

procedure TOptionsCompleteForm.CBStartCountDownClick(Sender: TObject);
begin
  lblCountDownTitel.Enabled := CBStartCountDown.Checked;
  EditCountdownSong.Enabled := CBStartCountDown.Checked;
  BtnCountDownSong.Enabled := CBStartCountDown.Checked;
  BtnGetCountDownTitel.Enabled := CBStartCountDown.Checked;
  LBlCountDownWarning.Enabled := CBStartCountDown.Checked;
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

procedure TOptionsCompleteForm.EditBirthdaySongChange(Sender: TObject);
begin
  LblEventWarning.Visible := Not FileExists(EditBirthdaySong.Text);
end;

procedure TOptionsCompleteForm.CBAlwaysSortAnzeigeListClick(Sender: TObject);
begin
    CBSkipSortOnLargeLists.Enabled := CBAlwaysSortAnzeigeList.Checked;
end;

procedure TOptionsCompleteForm.CBAutoScanClick(Sender: TObject);
begin
  LBAutoScan.Enabled  := CBAutoScan.Checked;
  BtnAutoScanDelete.Enabled  := CBAutoScan.Checked;
  BtnAutoScanAdd.Enabled  := CBAutoScan.Checked;
end;

procedure TOptionsCompleteForm.BtnAutoScanAddClick(Sender: TObject);
var tmp, newdir: UnicodeString;
    i: Integer;
    FB: TFolderBrowser;
begin
  if MedienBib.InitialDialogFolder = '' then
      MedienBib.InitialDialogFolder := GetShellFolder(CSIDL_MYMUSIC);


  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_BibCaption, MedienBib.InitialDialogFolder);
  try
      if fb.Execute then
      begin
          newdir := Fb.SelectedItem;
          // save selected dir for next call of this dialog
          MedienBib.InitialDialogFolder := Fb.SelectedItem;

          // Parentdir schon drin? - Nicht einfügen
          if MedienBib.ScanListContainsParentDir(newdir) <> '' then
            MessageDLG((AutoScanDir_AlreadyExists), mtInformation, [MBOK], 0)
          else
          begin
            // parentdir noch nicht drin.
            // Überprüfen auf SubDirs:
            tmp := MedienBib.ScanListContainsSubDirs(newdir);
            if  tmp <> '' then
              MessageDLG((AutoSacnDir_SubDirExisted) + #13#10
                          + tmp
              , mtInformation, [MBOK], 0);

              MedienBib.AutoScanDirList.Add(IncludeTrailingPathDelimiter(newdir));
              LBAutoScan.Items.Clear;
              for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
                LBAutoScan.Items.Add(MedienBib.AutoScanDirList[i]);
          end;
      end;
  finally
      fb.Free;
  end;

end;

procedure TOptionsCompleteForm.BtnAutoScanDeleteClick(Sender: TObject);
var i: Integer;
begin
  LBAutoScan.DeleteSelected;
// hier besser:
// mit  LBAutoScan.itemIndex arbeiten, und nur das gelöscht aus der Liste entfernen
  MedienBib.AutoScanDirList.Clear;
  for i := 0 to LBAutoScan.Count - 1 do
    MedienBib.AutoScanDirList.Add(LBAutoScan.Items[i]);
end;

procedure TOptionsCompleteForm.LBAutoscanKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_DELETE: BtnAutoScanDeleteClick(nil);
  end;
end;


procedure TOptionsCompleteForm.ChangeWebserverLinks(Sender: TObject);
var newUrl: String;
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
    LblWebserverAdminURL.Caption := newURL + '/admin'
end;


procedure TOptionsCompleteForm.LblWebserverUserURLClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(LblWebserverUserURL.Caption), nil, nil, SW_SHOW);
end;



procedure TOptionsCompleteForm.LblWebserverAdminURLClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(LblWebserverAdminURL.Caption), nil, nil, SW_SHOW);
end;

procedure TOptionsCompleteForm.CB_Activate_PlayClick(Sender: TObject);
begin
  CB_MOD_Play.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_Play.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_StopClick(Sender: TObject);
begin
  CB_MOD_Stop.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_Stop.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_NextClick(Sender: TObject);
begin
  CB_MOD_Next.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_Next.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_PrevClick(Sender: TObject);
begin
  CB_MOD_Prev.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_Prev.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_JumpForwardClick(
  Sender: TObject);
begin
  CB_MOD_JumpForward.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_JumpForward.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_JumpBackClick(Sender: TObject);
begin
  CB_MOD_JumpBack.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_JumpBack.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_IncVolClick(Sender: TObject);
begin
  CB_MOD_IncVol.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_IncVol.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_DecVolClick(Sender: TObject);
begin
  CB_MOD_DecVol.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_DecVol.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CB_Activate_MuteClick(Sender: TObject);
begin
  CB_MOD_Mute.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
  CB_Key_Mute.Enabled := (Sender as TCheckBox).Checked AND (Sender as TCheckBox).Enabled;
end;

procedure TOptionsCompleteForm.CBRegisterHotKeysClick(Sender: TObject);
begin
  CB_Activate_Play.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_Stop.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_Next.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_Prev.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_JumpForward.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_JumpBack.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_IncVol.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_DecVol.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_Mute.Enabled := CBRegisterHotKeys.Checked;
  CB_Activate_PlayClick(CB_Activate_Play);
  CB_Activate_StopClick(CB_Activate_Stop);
  CB_Activate_NextClick(CB_Activate_Next);
  CB_Activate_PrevClick(CB_Activate_Prev);
  CB_Activate_JumpForwardClick(CB_Activate_JumpForward);
  CB_Activate_JumpBackClick(CB_Activate_JumpBack);
  CB_Activate_IncVolClick(CB_Activate_IncVol);
  CB_Activate_DecVolClick(CB_Activate_DecVol);
  CB_Activate_MuteClick(CB_Activate_Mute);
end;

procedure TOptionsCompleteForm.cbFilenameFormatChange(Sender: TObject);
begin
  if IsValidFilenameFormat(cbFilenameFormat.Text) then
    cbFilenameFormat.Font.Color := clWindowText
  else
    cbFilenameFormat.Font.Color := clRed;
end;

procedure TOptionsCompleteForm.BtnChooseDownloadDirClick(Sender: TObject);
var adir: UnicodeString;
    FB: TFolderBrowser;
begin
  aDir := NempPlayer.DownloadDir;
  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_Webradio_Caption, NempPlayer.DownloadDir);
  try
      if fb.Execute then
      begin
          aDir := fb.SelectedItem;
          EdtDownloadDir.Text := IncludeTrailingPathDelimiter(aDir);
      end;
  finally
      fb.Free;
  end;
end;

procedure TOptionsCompleteForm.BtnClearCoverCacheClick(Sender: TObject);
begin
    MedienBib.NewCoverFlow.ClearCoverCache;
    MedienBib.NewCoverFlow.ClearTextures;
end;

procedure TOptionsCompleteForm.Btn_InstallDeskbandClick(Sender: TObject);
var WinVersionInfo: TWindowsVersionInfo;
begin
    WinVersionInfo := TWindowsVersionInfo.Create;
    try
        if WinVersionInfo.ProcessorArchitecture = pax64 then
            MessageDLG((WinX64WarningDeskband), mtWarning, [MBOK], 0)
        else
        begin
            if WinVersionInfo.MajorVersion >= 6 then
            begin
                if (WinVersionInfo.MajorVersion = 6) and (WinVersionInfo.MinorVersion = 0) then
                    // Vista
                    MessageDLG((WinVistaWarningDeskband), mtWarning, [MBOK], 0)
                else
                    if (WinVersionInfo.MajorVersion = 6) and (WinVersionInfo.MinorVersion = 1) then
                        // Windows 7
                        MessageDLG((Win7WarningDeskband), mtWarning, [MBOK], 0)
                    else
                        // unknown Windows
                        MessageDLG((WinVistaWarningDeskband), mtWarning, [MBOK], 0)
            end else
            begin
                // Windows XP/2000/...
                if FileExists(ExtractFilePath(ParamStr(0)) + 'NempDeskband.dll') then
                    ShellExecute(Handle, 'open' ,'regsvr32.exe',
                                    PChar('"' + ExtractFilePath(ParamStr(0)) + 'NempDeskband.dll"'),
                                     '', sw_ShowNormal)
                else
                  MessageDlg(_('NempDeskband.dll not found.'), mtError, [mbOK], 0);
            end;
        end;
    finally
        WinVersionInfo.Free;
    end;
end;

procedure TOptionsCompleteForm.Btn_UninstallDeskbandClick(Sender: TObject);
var WinVersionInfo: TWindowsVersionInfo;
begin
    WinVersionInfo := TWindowsVersionInfo.Create;
    try
        //if WinVersionInfo.ProcessorArchitecture = pax64 then
        //    MessageDLG((WinX64WarningDeskband), mtWarning, [MBOK], 0)
        //else
        // uninstalling should be allowed. ;-)
        begin
            if FileExists(ExtractFilePath(ParamStr(0)) + 'NempDeskband.dll') then
                ShellExecute(Handle, 'open' ,'regsvr32.exe',
                                PChar('/u "' + ExtractFilePath(ParamStr(0)) + 'NempDeskband.dll"'),
                                 '', sw_ShowNormal)
            else
              MessageDlg(_('NempDeskband.dll not found.'), mtError, [mbOK], 0);
        end;
    finally
        WinVersionInfo.Free;
    end;
end;


procedure TOptionsCompleteForm.BackupComboboxes;
var i: Integer;
begin
    for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        Components[i].Tag := (Components[i] as TComboBox).ItemIndex;
end;

procedure TOptionsCompleteForm.RestoreComboboxes;
var i: Integer;
begin
  for i := 0 to self.ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        (Components[i] as TComboBox).ItemIndex := Components[i].Tag;
end;

procedure TOptionsCompleteForm.CB_AccelerateSearchClick(Sender: TObject);
begin
    CB_AccelerateSearchIncludePath.Enabled    := CB_AccelerateSearch.Checked;
    CB_AccelerateSearchIncludeComment.Enabled := CB_AccelerateSearch.Checked;
    LblConst_AccelerateSearchNote2.Enabled    := CB_AccelerateSearch.Checked;
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
var aGraphic: TPicture;
begin
    if OpenDlg_DefaultCover.Execute then
    begin
        aGraphic := TPicture.Create;
        try
            aGraphic.LoadFromFile(OpenDlg_DefaultCover.FileName);
            if SafeResizedGraphic(aGraphic.Graphic, Medienbib.CoverSavePath + '_default_cover.jpg', 240, 240, True) then
                LoadDefaultCover
            else
                MessageDLG((OptionsForm_DefaultCoverChangeFailed), mtWarning, [MBOK], 0);
        finally
            aGraphic.Free;
        end;
    end;
end;

procedure TOptionsCompleteForm.btn_DefaultCoverResetClick(Sender: TObject);
var aGraphic: TPicture;
    FileName: UnicodeString;
begin
    FileName := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.png';
    if not FileExists(FileName) then
        FileName := ExtractFilePath(ParamStr(0)) + 'Images\default_cover.jpg';

    aGraphic := TPicture.Create;
    try
        aGraphic.LoadFromFile(FileName);
        if SafeResizedGraphic(aGraphic.Graphic, Medienbib.CoverSavePath + '_default_cover.jpg', aGraphic.Width, aGraphic.Height, True) then
            LoadDefaultCover
        else
            MessageDLG((OptionsForm_DefaultCoverChangeFailed), mtWarning, [MBOK], 0);
    finally
        aGraphic.Free;
    end;
end;

procedure TOptionsCompleteForm.LoadDefaultCover;
var Coverbmp: TBitmap;
begin
  Coverbmp := tBitmap.Create;
  try
      Coverbmp.Width := img_DefaultCover.Width;
      Coverbmp.Height := img_DefaultCover.Height;
      GetDefaultCover(dcFile, Coverbmp, 0);

      img_DefaultCover.Picture.Bitmap.Assign(Coverbmp);
      img_DefaultCover.Refresh;
  finally
      Coverbmp.Free;
  end;
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

procedure TOptionsCompleteForm.InitScrobblerWizard;
begin
    ResetScrobbleButton;
    MemoScrobbleLog.Lines.Assign(NempPlayer.NempScrobbler.LogList);
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
            authUrl := 'http://www.last.fm/api/auth/?api_key=' + NempPlayer.NempScrobbler.ApiKey + '&token=' + NempPlayer.NempScrobbler.Token;
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

        SC_BeginWork: GrpBox_ScrobbleLog.Caption := Scrobble_Active;
        SC_EndWork: GrpBox_ScrobbleLog.Caption := Scrobble_InActive;
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
  ShellExecute(Handle, 'open', 'http://www.last.fm', nil, nil, SW_SHOW);
end;


{
    --------------------------------------------------------
    Methods for WebServer-Page
    --------------------------------------------------------
}

procedure TOptionsCompleteForm.BtnServerActivateClick(Sender: TObject);
//var //success: Boolean;
    //s: String;
    //LocalFormatSettings: TFormatSettings;
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
        NempWebServer.OnlyLAN := cbOnlyLAN.Checked;
        NempWebServer.AllowLibraryAccess := cbPermitLibraryAccess.Checked;
        NempWebServer.AllowFileDownload := cbPermitPlaylistDownload.Checked;
        NempWebServer.AllowRemoteControl := cbAllowRemoteControl.Checked;
        NempWebServer.AllowVotes := cbPermitVote.Checked;
        // 2.) Medialib kopieren
        NempWebServer.CopyLibrary(MedienBib);
        NempWebServer.Active := True;
        // Control: Is it Active now?
        if NempWebServer.Active  then
        begin
            // Ok, Activation complete
            ReArrangeToolImages;
            // Save current settings
            NempWebServer.SaveToIni;
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
      aText := String(IDHttpWebServerGetIP.get('http://www.gausi.de/deine_ip.php'));
      a := pos('<body>', aText);
      b := pos('</body>', aText);
      EdtGlobalIP.Text := trim(copy(aText, a + 6, b-a-6));
  except
      //MessageDlg((WebServer_GetIPFailes), mtWarning, [mbOK], 0);
      EdtGlobalIP.Text := WebServer_GetIPFailedShort;
  end;
end;

procedure TOptionsCompleteForm.cbOnlyLANClick(Sender: TObject);
begin
//    NempWebServer.OnlyLAN := cbOnlyLAN.Checked;
end;
procedure TOptionsCompleteForm.cbPermitLibraryAccessClick(Sender: TObject);
begin
//    NempWebServer.AllowLibraryAccess := cbPermitLibraryAccess.Checked;
end;
procedure TOptionsCompleteForm.cbPermitPlaylistDownloadClick(Sender: TObject);
begin
//    NempWebServer.AllowPlaylistDownload := cbPermitPlaylistDownload.Checked;
end;
procedure TOptionsCompleteForm.cbAllowRemoteControlClick(Sender: TObject);
begin
//    NempWebServer.AllowRemoteControl := cbAllowRemoteControl.Checked;
end;


end.

