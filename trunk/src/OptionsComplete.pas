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

uses
  Windows, Messages, SysUtils,  Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ComCtrls, StdCtrls, Spin, CheckLst, ExtCtrls, shellapi,
  DateUtils,  IniFiles, jpeg, PNGImage, GifImg, math,
  bass, fldbrows, StringHelper, MainFormHelper,

   AudioFileClass, Spectrum_vis, Hilfsfunktionen, Systemhelper, TreeHelper,
  CoverHelper, U_Charcode,
  Nemp_SkinSystem, UpdateUtils,

  Nemp_ConstantsAndTypes, filetypes,   Buttons,
  gnuGettext, languageCodes, 
  Nemp_RessourceStrings,  ScrobblerUtils, ExtDlgs, NempCoverFlowClass,
  SkinButtons, NempPanel, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP;

type
  TOptionsCompleteForm = class(TForm)
    OptionsVST: TVirtualStringTree;
    TabAnzeige0: TTabSheet;
    TabSystem0: TTabSheet;
    BTNok: TButton;
    BTNCancel: TButton;
    BTNApply: TButton;
    ColorDialog1: TColorDialog;
    PageControl1: TPageControl;
    TabAudio0: TTabSheet;
    TabSystem2: TTabSheet;
    TabAnzeige1: TTabSheet;
    GrpBox_Fonts: TGroupBox;
    LblConst_FontVBR: TLabel;
    LblConst_FontCBR: TLabel;
    CBChangeFontStyleOnMode: TCheckBox;
    CBChangeFontOnCbrVbr: TCheckBox;
    CBFontNameVBR: TComboBox;
    CBFontNameCBR: TComboBox;
    TabAudio5: TTabSheet;
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
    LblConst_DeskbandHint: TLabel;
    LblConst_DeskbandHint2: TLabel;
    GrpBox_Effects: TGroupBox;
    CB_UseDefaultEffects: TCheckBox;
    CB_UseDefaultEqualizer: TCheckBox;
    TabAudio3: TTabSheet;
    GrpBox_PlaylistBehaviour: TGroupBox;
    CB_AutoDeleteFromPlaylist: TCheckBox;
    CB_AutoMixPlaylist: TCheckBox;
    CB_AutoSavePlaylist: TCheckBox;
    GrpBox_RandomOptions: TGroupBox;
    LblConst_ReallyRandom: TLabel;
    LblConst_AvoidRepetitions: TLabel;
    TBRandomRepeat: TTrackBar;
    GrpBox_DefaultAction: TRadioGroup;
    CB_AutoScanPlaylist: TCheckBox;
    TabExtended0: TTabSheet;
    TabAudio8: TTabSheet;
    TabExtended2: TTabSheet;
    GrpBox_TabMedia5_ID3: TGroupBox;
    CBAlwaysWriteUnicode: TCheckBox;
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
    CB_DisableAutoDeleteAtSlide: TCheckBox;
    CB_DisableAutoDeleteAtPause: TCheckBox;
    CB_DisAbleAutoDeleteAtStop: TCheckBox;
    CB_DisableAutoDeleteAtTitleChange: TCheckBox;
    TabAudio7: TTabSheet;
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
    TabAnzeige4: TTabSheet;
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
    TabAudio4: TTabSheet;
    GrpBox_WebradioRecording: TGroupBox;
    LblConst_DownloadDir: TLabel;
    BtnChooseDownloadDir: TButton;
    cbAutoSplitByTitle: TCheckBox;
    LblConst_FilenameFormat: TLabel;
    LblConst_FilenameExtension: TLabel;
    Btn_InstallDeskband: TButton;
    Btn_UninstallDeskband: TButton;
    TabAnzeige5: TTabSheet;
    CB_JumpToNextCue: TCheckBox;
    TabExtended1: TTabSheet;
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
    CBChangeFontSizeOnLength: TCheckBox;
    SEFontSize: TSpinEdit;
    GrpBox_NempUpdater: TGroupBox;
    CB_AutoCheck: TCheckBox;
    Btn_CHeckNowForUpdates: TButton;
    GrpBox_StartingNemp: TGroupBox;
    CB_AllowMultipleInstances: TCheckBox;
    CB_StartMinimized: TCheckBox;
    CBRegisterHotKeys: TCheckBox;
    GrpBox_MultimediaKeys: TGroupBox;
    Btn_ConfigureMediaKeys: TButton;
    LblConst_MultimediaKeys_Hint: TLabel;
    LblConst_MultimediaKeys_Status: TLabel;
    Lbl_MultimediaKeys_Status: TLabel;
    GrpBox_FileFormats: TGroupBox;
    Label1: TLabel;
    CBFileTypes: TCheckListBox;
    Label2: TLabel;
    CBPlaylistTypes: TCheckListBox;
    Btn_SelectAll: TButton;
    GrpBoxFileFormatOptions: TGroupBox;
    CBEnqueueStandard: TCheckBox;
    CBEnqueueStandardLists: TCheckBox;
    CBDirectorySupport: TCheckBox;
    CBiTouch: TCheckBox;
    RGrp_View: TRadioGroup;
    GrpBox_ViewSeperate: TGroupBox;
    cb_ShowEffectsWindow: TCheckBox;
    cb_ShowPlaylistWindow: TCheckBox;
    CB_ShowMedialistWindow: TCheckBox;
    CB_ShowBrowseWindow: TCheckBox;
    CB_AutoPlayNewTitle: TCheckBox;
    CB_SavePositionInTrack: TCheckBox;
    CB_AutoPlayOnStart: TCheckBox;
    CBAutoLoadMediaList: TCheckBox;
    CBAutoSaveMediaList: TCheckBox;
    GrpBox_TabMedia3_Columns: TGroupBox;
    GrpBox_TabMedia3_Browseby: TGroupBox;
    Label44: TLabel;
    Label61: TLabel;
    GrpBox_TabMedia3_Other: TGroupBox;
    CBFullRowSelect: TCheckBox;
    CBShowHintsInMedialist: TCheckBox;
    CB_ShowHintsInPlaylist: TCheckBox;
    GrpBox_Skins: TGroupBox;
    LblConst_Preview: TLabel;
    LblConst_Choose: TLabel;
    GrpBox_TabAudio2_View: TGroupBox;
    Lbl_Framerate: TLabel;
    CB_visual: TCheckBox;
    TB_Refresh: TTrackBar;
    CB_ScrollTitelTaskBar: TCheckBox;
    CB_ScrollTitleInMainWindow: TCheckBox;
    GrpBox_Devices: TGroupBox;
    LblConst_MainDevice: TLabel;
    LblConst_Headphones: TLabel;
    LblConst_VolumeHeadphones: TLabel;
    HeadSetVolumeTRACKBAR: TTrackBar;
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
    LblConst_JinglePlayback: TLabel;
    CBJingleReduce: TCheckBox;
    SEJingleReduce: TSpinEdit;
    SEJingleVolume: TSpinEdit;
    GrpBox_Directories: TGroupBox;
    CBAutoScan: TCheckBox;
    BtnAutoScanAdd: TButton;
    BtnAutoScanDelete: TButton;
    CBAutoAddNewDirs: TCheckBox;
    CBAskForAutoAddNewDirs: TCheckBox;
    GrpBox_TabMedia1_Filetypes: TGroupBox;
    LblConst_OnlythefollowingTypes: TLabel;
    cbIncludeAll: TCheckBox;
    GrpBox_ExtendedAudio: TGroupBox;
    LblConst_Buffersize: TLabel;
    SEBufferSize: TSpinEdit;
    LblConst_ms: TLabel;
    LblConst_UseFloatingPoint: TLabel;
    CB_FloatingPoint: TComboBox;
    LblConst_Mixing: TLabel;
    CB_Mixing: TComboBox;
    Lbl_FloatingPoints_Status: TLabel;
    GrpBox_TabMedia1_Medialist: TGroupBox;
    CBAutoScanPlaylistFilesOnView: TCheckBox;
    CBAlwaysSortAnzeigeList: TCheckBox;
    GrpBox_Hibernate: TGroupBox;
    LBlConst_ReInitPlayerEngine_Hint: TLabel;
    cbPauseOnSuspend: TCheckBox;
    cbReInitAfterSuspend: TCheckBox;
    Btn_ReinitPlayerEngine: TButton;
    GrpBox_Language: TGroupBox;
    cb_Language: TComboBox;
    cb_StayOnTop: TCheckBox;
    CB_IgnoreVolume: TCheckBox;
    CB_AutoCheckNotifyOnBetas: TCheckBox;
    TabAudio9: TTabSheet;
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
    GrpBox_BetaOptions: TGroupBox;
    CB_BetaDontUseThreadedUpdate: TCheckBox;
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
    cbSkinAuswahl: TComboBox;
    CB_TaskBarDelay: TComboBox;
    CB_AnzeigeDelay: TComboBox;
    CBSortArray1: TComboBox;
    CBSortArray2: TComboBox;
    cbCoverSortOrder: TComboBox;
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
    cb_UseClassicCoverflow: TCheckBox;
    NewPlayerPanelOptions: TNempPanel;
    PaintFrame: TImage;
    TextAnzeigeIMAGE: TImage;
    TimePaintBox: TImage;
    SlidebarShape: TShape;
    VolShape: TShape;
    RatingImage: TImage;
    SlideBarButton: TSkinButton;
    SlideBackBTN: TSkinButton;
    PlayPrevBTN: TSkinButton;
    PlayPauseBTN: TSkinButton;
    StopBTN: TSkinButton;
    RecordBtn: TSkinButton;
    PlayNextBTN: TSkinButton;
    SlideForwardBTN: TSkinButton;
    RepeatBitBTN: TSkinButton;
    VolButton: TSkinButton;
    Menu1Img: TSkinButton;
    MinimizeIMG: TSkinButton;
    CloseIMG: TSkinButton;
    TabAudio10: TTabSheet;
    GrpBoxConfig: TGroupBox;
    LblConst_Username2: TLabel;
    LblConst_Password2: TLabel;
    BtnServerActivate: TButton;
    cbOnlyLAN: TCheckBox;
    cbPermitLibraryAccess: TCheckBox;
    cbPermitPlaylistDownload: TCheckBox;
    cbAllowRemoteControl: TCheckBox;
    EdtUsername: TEdit;
    EdtPassword: TEdit;
    GrpBoxIP: TGroupBox;
    LblConst_IPWAN: TLabel;
    LabelLANIP: TLabel;
    BtnGetIPs: TButton;
    cbLANIPs: TComboBox;
    EdtGlobalIP: TEdit;
    GrpBoxLog: TGroupBox;
    WebServerLogMemo: TMemo;
    IDHttpWebServerGetIP: TIdHTTP;
    CBAutoStartWebServer: TCheckBox;
    GrpBox_TabMedia3_Cover: TGroupBox;
    CB_CoverSearch_inDir: TCheckBox;
    CB_CoverSearch_inSubDir: TCheckBox;
    CB_CoverSearch_inParentDir: TCheckBox;
    CB_CoverSearch_inSisterDir: TCheckBox;
    EDTCoverSubDirName: TEdit;
    EDTCoverSisterDirName: TEdit;
    TabAnzeige6: TTabSheet;
    GrpBoxPartyMode: TGroupBox;
    Lbl_PartyMode_ResizeFactor: TLabel;
    CB_PartyMode_ResizeFactor: TComboBox;
    TabAudio2: TTabSheet;
    GroupBox1: TGroupBox;
    cb_RatingActive: TCheckBox;
    cb_RatingIgnoreShortFiles: TCheckBox;
    cb_RatingChangeCounter: TCheckBox;
    cb_RatingWriteToFiles: TCheckBox;
    cb_RatingIgnoreCounterOnAbortedTracks: TCheckBox;
    cb_RatingIncreaseRating: TCheckBox;
    cb_RatingDecreaseRating: TCheckBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    CBSkipSortOnLargeLists: TCheckBox;
    CB_RememberInterruptedPlayPosition: TCheckBox;
    LblTaskbarWin7: TLabel;
    cbIncludeFiles: TCheckListBox;
    CBChangeFontColoronBitrate: TCheckBox;
    cbHideNACover: TCheckBox;
    LblNACoverHint: TLabel;
    CB_CoverSearch_LastFM: TCheckBox;
    cb_PartyMode_BlockTreeEdit: TCheckBox;
    cb_PartyMode_BlockCurrentTitleRating: TCheckBox;
    cb_PartyMode_BlockTools: TCheckBox;
    Edt_PartyModePassword: TLabeledEdit;
    GrpBox_TabMedia3_CoverDetails: TGroupBox;
    LblConst_CoverMode: TLabel;
    cbCoverMode: TComboBox;
    LblConst_DetailMode: TLabel;
    cbDetailMode: TComboBox;
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
    procedure HeadSetVolumeTRACKBARChange(Sender: TObject);
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
    procedure Btn_ConfigureMediaKeysClick(Sender: TObject);
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
    procedure BtnUpdateAuthClick(Sender: TObject);
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
  private
    { Private-Deklarationen }
    OldFontSize: integer;
    //VerlaufBitmap: TBitmap;
    //procedure RePaintVerlauf(Verlauf: Boolean);
    procedure GetSkins;
    // Hilfsprozeduren für das Hotkey-Laden/Speichern
    Function ModToIndex(aMod: Cardinal): Integer;
    Function IndexToMod(aIndex: Integer): Cardinal;
    Function KeyToIndex(aKey: Byte): Integer;
    Function IndexToKey(aIndex: Integer): byte;
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

uses NempMainUnit, Details, SplitForm_Hilfsfunktionen, WindowsVersionInfo;

{$R *.dfm}

var
 OptionsArraySystem : array[0..3] of TOptionData;
 OptionsArrayAnzeige: array[0..4] of TOptionData;
 OptionsArrayAudio  : array[0..8] of TOptionData;
 OptionsArrayExtended: Array[0..2] of TOptionData;
 Testskin: TNempSkin;
    {
const

    oOptionsTree_SystemMain       = 'System';
    oOptionsTree_SystemGeneral    = 'General options';
    oOptionsTree_SystemControl    = 'Controls';
    oOptionsTree_SystemFiletyps   = 'Filetypes (Windows Registry)';
    oOptionsTree_SystemTaskbar    = 'Taskbar';
    oOptionsTree_SystemMediaKeys  = 'Media keys';
    oOptionsTree_SystemOther      = 'Shutdown';
    oOptionsTree_ViewMain         = 'Viewing options';
    oOptionsTree_ViewFonts        = 'Fonts';
    oOptionsTree_ViewFontColor    = 'Font color';
    oOptionsTree_ViewFontsize     = 'Font size';

    oOptionsTree_ViewPlayer        = 'Player and Cover';
    oOptionsTree_ViewView          = 'Lists and Columns';
    oOptionsTree_PlayerMain        = 'Player settings';
    oOptionsTree_PlayerPlaylist    = 'Playlist';
    oOptionsTree_PlayerWebradio    = 'Webstreams';
    oOptionsTree_PlayerEffects     = 'Effects';
    oOptionsTree_PlayerWebServer   = 'WebServer';

    oOptionsTree_PlayerEvents      = 'Events';
    oOptionsTree_PlayerScrobbler   = 'LastFM (scrobble)';
    oOptionsTree_PlayerMedialibrary = 'Media library';
    oOptionsTree_ExtendedMain         = 'Extended settings';
    oOptionsTree_MediabibList         = 'Media list';
    oOptionsTree_MediabibDirectories  = 'Directories';
    oOptionsTree_MediabibView         = 'View';
    oOptionsTree_MediabibSearch       = 'Search options';
    oOptionsTree_MediabibCover        = 'Cover';
    oOptionsTree_MediabibUnicode      = 'Unicode';
}


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
  MainNode : PVirtualNode;
  BassInfo: BASS_DEVICEINFO;
begin
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


//  VerlaufBitmap := TBitmap.Create;
//  VerlaufBitmap.Width := 320;
//  VerlaufBitmap.Height := 17;

// ok

  OptionsVST.NodeDataSize := SizeOf(TOptionsTreeData);

  OptionsArraySystem[0].Eintrag := OptionsTree_SystemGeneral;
  OptionsArraySystem[0].TabSheet:= TabSystem0;
      OptionsArraySystem[1].Eintrag := OptionsTree_SystemFiletyps;
      OptionsArraySystem[1].TabSheet:= TabSystem2;
      OptionsArraySystem[2].Eintrag := OptionsTree_SystemControl;
      OptionsArraySystem[2].TabSheet:= TabSystem1;
      OptionsArraySystem[3].Eintrag  := OptionsTree_SystemTaskbar;
      OptionsArraySystem[3].TabSheet := TabSystem3;

  MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArraySystem[0]);
  for i := 1 to High(OptionsArraySystem) do
    AddVSTOptions(OptionsVST, MainNode, OptionsArraySystem[i]);

  OptionsArrayAnzeige[0].Eintrag := OptionsTree_ViewMain;
  OptionsArrayAnzeige[0].TabSheet:= TabAnzeige0;
      OptionsArrayAnzeige[1].Eintrag := OptionsTree_ViewPlayer;
      OptionsArrayAnzeige[1].TabSheet:= TabAnzeige4;
      OptionsArrayAnzeige[2].Eintrag := OptionsTree_ViewView;
      OptionsArrayAnzeige[2].TabSheet:= TabAnzeige5;
      OptionsArrayAnzeige[3].Eintrag := OptionsTree_ViewFonts;
      OptionsArrayAnzeige[3].TabSheet:= TabAnzeige1;

      OptionsArrayAnzeige[4].Eintrag := OptionsTree_PartyMode;
      OptionsArrayAnzeige[4].TabSheet:= TabAnzeige6;

  MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayAnzeige[0]);
  for i := 1 to High(OptionsArrayAnzeige) do
    AddVSTOptions(OptionsVST, MainNode, OptionsArrayAnzeige[i]);


  OptionsArrayAudio[0].Eintrag  := OptionsTree_PlayerMain;
  OptionsArrayAudio[0].TabSheet := TabAudio0;

      OptionsArrayAudio[1].Eintrag  := OptionsTree_PlayerPlaylist;
      OptionsArrayAudio[1].TabSheet := TabAudio3;
      OptionsArrayAudio[2].Eintrag  := OptionsTree_PlayerMedialibrary;
      OptionsArrayAudio[2].TabSheet := TabAudio8;

      OptionsArrayAudio[3].Eintrag  := OptionsTree_PlayerAutomaticRating;
      OptionsArrayAudio[3].TabSheet := TabAudio2;



      OptionsArrayAudio[4].Eintrag  := OptionsTree_PlayerWebradio;
      OptionsArrayAudio[4].TabSheet := TabAudio4;
      OptionsArrayAudio[5].Eintrag  := OptionsTree_PlayerEffects;
      OptionsArrayAudio[5].TabSheet := TabAudio5;
      OptionsArrayAudio[6].Eintrag  := OptionsTree_PlayerEvents;
      OptionsArrayAudio[6].TabSheet := TabAudio7;            // Birthday
      OptionsArrayAudio[7].Eintrag  := OptionsTree_PlayerScrobbler;
      OptionsArrayAudio[7].TabSheet := TabAudio9;          // Scrobbler
      OptionsArrayAudio[8].Eintrag  := OptionsTree_PlayerWebServer;
      OptionsArrayAudio[8].TabSheet := TabAudio10;          // WebServer

  MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayAudio[0]);
  for i := 1 to High(OptionsArrayAudio) do
  begin
      case i of
          6: BirthdayNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
          7: ScrobbleNode  := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
          8: WebServerNode := AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
      else
          AddVSTOptions(OptionsVST, MainNode, OptionsArrayAudio[i]);
      end;
  end;

  OptionsArrayExtended[0].Eintrag := OptionsTree_ExtendedMain;
  OptionsArrayExtended[0].TabSheet := TabExtended0;
      OptionsArrayExtended[1].Eintrag := OptionsTree_MediabibSearch;
      OptionsArrayExtended[1].TabSheet := TabExtended1;
      OptionsArrayExtended[2].Eintrag := OptionsTree_MediabibUnicode;
      OptionsArrayExtended[2].TabSheet := TabExtended2;

  MainNode := AddVSTOptions(OptionsVST, NIL, OptionsArrayExtended[0]);
  VorauswahlNode := AddVSTOptions(OptionsVST, MainNode, OptionsArrayExtended[1]);
  for i := 2 to High(OptionsArrayExtended) do
    AddVSTOptions(OptionsVST, MainNode, OptionsArrayExtended[i]);


  OptionsVST.FullExpand(Nil);

  TabSystem0.TabVisible := False;
  TabSystem1.TabVisible := False;
  TabSystem2.TabVisible := False;
  TabSystem3.TabVisible := False;

  TabAnzeige0.TabVisible := False;
  TabAnzeige1.TabVisible := False;
  TabAnzeige4.TabVisible := False;
  TabAnzeige5.TabVisible := False;
  TabAnzeige6.TabVisible := False;

  TabAudio0.TabVisible := False;
  TabAudio2.TabVisible := False;
  TabAudio3.TabVisible := False;
  TabAudio4.TabVisible := False;
  TabAudio5.TabVisible := False;
  TabAudio7.TabVisible := False;
  TabAudio8.TabVisible := False;
  TabAudio9.TabVisible := False;
  TabAudio10.TabVisible := False;

  TabExtended0.TabVisible := False;
  TabExtended1.TabVisible := False;
  TabExtended2.TabVisible := False;

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
        HeadSetVolumeTRACKBAR.Enabled := False;
        LblConst_Headphones.Enabled := False;
        LblConst_VolumeHeadphones.Enabled := False;
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
    CBSpalten[i].Parent := GrpBox_TabMedia3_Columns;
    s := GetColumnIDfromPosition(Nemp_MainForm.VST, i);
    CBSpalten[i].Caption := Nemp_MainForm.VST.Header.Columns[s].Text;
    CBSpalten[i].Checked := coVisible in Nemp_MainForm.VST.Header.Columns[s].Options;
    CBSpalten[i].Top := 16 + (i mod 6)*16;
    CBSpalten[i].Left := 8 + (i div 6) * 100;
  end;

  cbCoverMode.ItemIndex := Nemp_MainForm.NempOptions.CoverMode;
  cbDetailMode.ItemIndex := Nemp_MainForm.NempOptions.DetailMode;

  //Sprachen initialisieren
  cb_Language.Items.Add('English');
  for i := 0 to LanguageList.Count - 1 do
    cb_Language.Items.Add(getlanguagename(LanguageList[i]));

  PageControl1.ActivePageIndex := 0;

  OpenDlg_DefaultCover.Filter :=  //FileFormatList.GetGraphicFilter([ftRaster], fstBoth, [foCompact, foIncludeAll,foIncludeExtension], Nil);
      'All images|*.bmp; *.dib; *.gif; *.jfif; *.jpe; *.jpeg; *.jpg; *.png; *.rle|'
      + 'JPG images (*.jfif; *.jpe; *.jpeg; *.jpg)|*.jfif; *.jpe; *.jpeg; *.jpg|'
      + 'Portable network graphic images (*.png)|*.png|'
      + 'Windows bitmaps (*.bmp; *.dib; *.rle)|*.bmp; *.dib; *.rle|'
      + 'CompuServe images (*.gif)|*.gif';

  OpenDlg_CountdownSongs.Filter := Nemp_MainForm.PlaylistDateienOpenDialog.Filter;
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
    tmpIPs: TStrings;
begin
  // Beta-Option
  cb_BetaDontUseThreadedUpdate.Checked := MedienBib.BetaDontUseThreadedUpdate;
  cb_UseClassicCoverflow.Checked := MedienBib.NewCoverFlow.Mode = cm_Classic;

  //---PLAYER----
  GrpBox_DefaultAction.ItemIndex := NempPlaylist.DefaultAction;
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

  if NempPlayer.MainDevice > 0 then
      MainDeviceCB.ItemIndex := NempPlayer.MainDevice - 1
  else
      MainDeviceCB.ItemIndex := 0;

  if NempPlayer.HeadSetDevice > 0 then
      HeadPhonesDeviceCB.ItemIndex := NempPlayer.HeadsetDevice - 1
  else
      HeadPhonesDeviceCB.ItemIndex := 0;
  HeadSetVolumeTRACKBAR.Position := Round(NempPlayer.HeadsetVolume * 100);
                            
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

  CB_AutoPlayNewTitle.Checked := NempPlaylist.AutoPlayNewTitle;
  CB_AutoSavePlaylist.Checked := NempPlaylist.AutoSave;

  CB_AutoDeleteFromPlaylist.Checked := NempPlaylist.AutoDelete;
      CB_DisableAutoDeleteAtSlide.Checked         := NempPlaylist.DisableAutoDeleteAtSlide          ;
      CB_DisableAutoDeleteAtPause.Checked         := NempPlaylist.DisableAutoDeleteAtPause          ;
      CB_DisAbleAutoDeleteAtStop.Checked          := NempPlaylist.DisAbleAutoDeleteAtStop           ;
      CB_DisableAutoDeleteAtTitleChange.Checked   := NempPlaylist.DisableAutoDeleteAtTitleChange    ;

      CB_DisableAutoDeleteAtSlide.Enabled         := NempPlaylist.AutoDelete          ;
      CB_DisableAutoDeleteAtPause.Enabled         := NempPlaylist.AutoDelete          ;
      CB_DisAbleAutoDeleteAtStop.Enabled          := NempPlaylist.AutoDelete           ;
      CB_DisableAutoDeleteAtTitleChange.Enabled   := NempPlaylist.AutoDelete    ;


  CB_AutoMixPlaylist.Checked        := NempPlaylist.AutoMix;
  CB_JumpToNextCue.Checked          := NempPlaylist.JumpToNextCueOnNextClick;
  CB_RememberInterruptedPlayPosition.Checked := NempPlaylist.RememberInterruptedPlayPosition;

  CB_ShowHintsInPlaylist.Checked    := NempPlaylist.ShowHintsInPlaylist;

  TBRandomRepeat.Position := NempPlaylist.RandomRepeat;

  CBJingleReduce.Checked := NempPlayer.ReduceMainVolumeOnJingle;
  SEJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;
  LblJingleReduce.Enabled := NempPlayer.ReduceMainVolumeOnJingle;

  SEJingleReduce.Value := NempPlayer.ReduceMainVolumeOnJingleValue;
  SEJingleVolume.Value := NempPlayer.JingleVolume;



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

  CB_CoverSearch_LastFM.Checked := (MedienBib.CoverSearchLastFM = BoolTrue);

  //cbDenyId3Edit.Checked := Nemp_MainForm.NempOptions.DenyId3Edit;

  cbFullRowSelect.Checked := Nemp_MainForm.NempOptions.FullRowSelect;

  cbAlwaysSortAnzeigeList.Checked := MedienBib.AlwaysSortAnzeigeList;
  CBSkipSortOnLargeLists.Enabled := CBAlwaysSortAnzeigeList.Checked;
  CBSkipSortOnLargeLists.Checked := MedienBib.SkipSortOnLargeLists;

  CBAutoScanPlaylistFilesOnView.Checked := MedienBib.AutoScanPlaylistFilesOnView;
  CBShowHintsInMedialist.Checked := MedienBib.ShowHintsInMedialist;

  CBSortArray1.ItemIndex := integer(MedienBib.NempSortArray[1]);
  CBSortArray2.ItemIndex := integer(MedienBib.NempSortArray[2]);
  cbCoverSortOrder.ItemIndex := MedienBib.CoverSortOrder - 1;

  CBAutoScan.Checked := MedienBib.AutoScanDirs;
  LBAutoScan.Enabled := MedienBib.AutoScanDirs;
  BtnAutoScanDelete.Enabled  := CBAutoScan.Checked;
  BtnAutoScanAdd.Enabled  := CBAutoScan.Checked;
  LBAutoScan.Items.Clear;
  for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
      LBAutoScan.Items.Add(MedienBib.AutoScanDirList[i]);

  CBAskForAutoAddNewDirs.Checked := MedienBib.AskForAutoAddNewDirs;
  CBAutoAddNewDirs.Checked       := MedienBib.AutoAddNewDirs;

  CB_AllowMultipleInstances.Checked := Not Nemp_MainForm.NempOptions.AllowOnlyOneInstance;
  CB_StartMinimized.Checked := Nemp_MainForm.NempOptions.StartMinimized;
  CBRegisterHotKeys.Checked := Nemp_MainForm.NempOptions.RegisterHotKeys;

  CB_IgnoreVolume.Checked := Nemp_MainForm.NempOptions.IgnoreVolumeUpDownKeys;

  CB_TabStopAtPlayerControls.Checked := Nemp_MainForm.NempOptions.TabStopAtPlayerControls;
  CB_TabStopAtTabs          .Checked := Nemp_MainForm.NempOptions.TabStopAtTabs;

  cbIncludeAll.Checked := MedienBib.IncludeAll;
  cbIncludeFiles.Enabled := NOT cbIncludeAll.Checked;
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
  CB_QuickSearchAllowErrorsOnEnter    .Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter;
  CB_QuickSearchAllowErrorsWhileTyping.Checked := MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType;

  GrpBox_TaskTray.ItemIndex := Nemp_MainForm.NempOptions.NempWindowView;

  CBShowDeskbandOnMinimize.Checked := Nemp_MainForm.NempOptions.ShowDeskbandOnMinimize;
  CBShowDeskbandOnStart.Checked    := Nemp_MainForm.NempOptions.ShowDeskbandOnStart;
  CBHideDeskbandOnRestore.Checked  := Nemp_MainForm.NempOptions.HideDeskbandOnRestore;
  CBHideDeskbandOnClose.Checked    := Nemp_MainForm.NempOptions.HideDeskbandOnClose;

  if Nemp_MainForm.DoHookInstall then
    Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Hook)
  else
    Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Standard);

  // Artist/alben-Größen
  SEArtistAlbenSIze.Value := Nemp_MainForm.NempOptions.ArtistAlbenFontSize;
  SEArtistAlbenRowHeight.Value := Nemp_MainForm.NempOptions.ArtistAlbenRowHeight;

  {// Farben
  ShapeMinColor.Enabled          := CBChangeFontColoronBitrate.Checked;
  ShapeMittelColor.Enabled       := CBChangeFontColoronBitrate.Checked;
  ShapeMaxColor.Enabled          := CBChangeFontColoronBitrate.Checked;
  CBMiddleToMinComputing.Enabled := CBChangeFontColoronBitrate.Checked;
  CBMiddleToMaxComputing.Enabled := CBChangeFontColoronBitrate.Checked;

  Label25.Enabled                := CBChangeFontColoronBitrate.Checked;
  Label26.Enabled                := CBChangeFontColoronBitrate.Checked;
  Label27.Enabled                := CBChangeFontColoronBitrate.Checked;
  ShapeMinColor.Brush.Color   := Nemp_MainForm.NempOptions.MinFontColor;
  ShapeMittelColor.Brush.Color:= Nemp_MainForm.NempOptions.MiddleFontColor;
  ShapeMaxColor.Brush.Color   := Nemp_MainForm.NempOptions.MaxFontColor;
  CBMiddleToMinComputing.ItemIndex := Nemp_MainForm.NempOptions.MiddleToMinComputing ;
  CBMiddleToMaxComputing.ItemIndex := Nemp_MainForm.NempOptions.MiddleToMaxComputing ;
  RePaintVerlauf(CBChangeFontColoronBitrate.Checked);
  LblConst_FontColorHint.Enabled                := CBChangeFontColoronBitrate.Checked;
  }

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
      CBAlwaysWriteUnicode.Checked := NempCharCodeOptions.AlwaysWriteUnicode;
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

  // In 3.0 final  neu hinzugekommene Optionen für die Anzeige setzen
  RGrp_View.ItemIndex := Nemp_MainForm.AnzeigeMode Mod 2;

  cb_ShowEffectsWindow.Checked    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
  cb_ShowPlaylistWindow.Checked   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistVisible;
  CB_ShowMedialistWindow.Checked  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteVisible;
  CB_ShowBrowseWindow.Checked     := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

  cb_Language.ItemIndex :=
    cb_Language.Items.IndexOf(getlanguagename(GetCurrentLanguage));

  cb_StayOnTop.Checked := Nemp_MainForm.NempOptions.MiniNempStayOnTop;

  // Update-Optionen
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
  EdtUsername.Text  := NempWebServer.Username;
  EdtPassword.Text  := NempWebServer.Password;
  cbOnlyLAN.Checked := NempWebServer.OnlyLAN;
  cbPermitLibraryAccess.Checked    := NempWebServer.AllowLibraryAccess;
  cbPermitPlaylistDownload.Checked := NempWebServer.AllowPlaylistDownload;
  cbAllowRemoteControl.Checked     := NempWebServer.AllowRemoteControl;
  WebServerLogMemo.Lines.Assign(NempWebServer.LogList);

  tmpIPs := getIPs;
  cbLANIPs.Items.Assign(tmpIPs);
  tmpIps.Free;
  if cbLANIPs.Items.Count > 0 then
      cbLANIPs.ItemIndex := 0;

  EdtUsername.Enabled := NempWebServer.Active;
  EdtPassword.Enabled := NempWebServer.Active;
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
  Edt_PartyModePassword.Text := Nemp_MainForm.NempSkin.NempPartyMode.password;


  // Automatic ratings
  // Set settings:
  cb_RatingActive                       .checked := NempPlayer.PostProcessor.Active                       ;
  cb_RatingIgnoreShortFiles             .checked := NempPlayer.PostProcessor.IgnoreShortFiles             ;
  cb_RatingWriteToFiles                 .checked := NempPlayer.PostProcessor.WriteToFiles;
  cb_RatingChangeCounter                .checked := NempPlayer.PostProcessor.ChangeCounter                ;
  cb_RatingIgnoreCounterOnAbortedTracks .checked := NempPlayer.PostProcessor.IgnoreCounterOnAbortedTracks ;
  cb_RatingIncreaseRating               .checked := NempPlayer.PostProcessor.IncPlayedFiles               ;
  cb_RatingDecreaseRating               .checked := NempPlayer.PostProcessor.DecAbortedFiles              ;
  // Set Enabled/Disabled
  cb_RatingIgnoreShortFiles             .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingWriteToFiles                 .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingChangeCounter                .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingIgnoreCounterOnAbortedTracks .Enabled := NempPlayer.PostProcessor.Active and NempPlayer.PostProcessor.ChangeCounter;
  cb_RatingIncreaseRating               .Enabled := NempPlayer.PostProcessor.Active;
  cb_RatingDecreaseRating               .Enabled := NempPlayer.PostProcessor.Active;




  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
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
var SR: TSearchrec;

begin
  cbSkinAuswahl.Items.Clear;
  cbSkinAuswahl.Items.Add('Windows standard');
  if (FindFirst(GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\'+'*',faDirectory,SR)=0) then
    repeat
      if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
        cbSkinAuswahl.Items.Add('<private> ' +Sr.Name);
    until FindNext(SR)<>0;
  FindClose(SR);

  if (FindFirst(ExtractFilePath(Paramstr(0)) + 'Skins\' +'*',faDirectory,SR)=0) then
    repeat
      if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
        cbSkinAuswahl.Items.Add('<public> ' + Sr.Name);
    until FindNext(SR)<>0;
  FindClose(SR);

  if cbSkinAuswahl.Items.Count = 0 then
    cbSkinAuswahl.Items.Add((Warning_NoSkinFound)); //'keine Skins'

  if Nemp_MainForm.UseSkin then
      cbSkinAuswahl.ItemIndex := cbSkinAuswahl.Items.IndexOf(Nemp_MainForm.SkinName)
  else
      cbSkinAuswahl.ItemIndex := 0;
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

procedure TOptionsCompleteForm.cb_RatingActiveClick(Sender: TObject);
begin
  cb_RatingIgnoreShortFiles             .Enabled := cb_RatingActive.Checked;
  cb_RatingWriteToFiles                 .Enabled := cb_RatingActive.Checked;
  cb_RatingChangeCounter                .Enabled := cb_RatingActive.Checked;
  cb_RatingIgnoreCounterOnAbortedTracks .Enabled := cb_RatingActive.Checked and cb_RatingChangeCounter.Checked;
  cb_RatingIncreaseRating               .Enabled := cb_RatingActive.Checked;
  cb_RatingDecreaseRating               .Enabled := cb_RatingActive.Checked;
end;

procedure TOptionsCompleteForm.cb_RatingChangeCounterClick(Sender: TObject);
begin
  cb_RatingIgnoreCounterOnAbortedTracks .Enabled := cb_RatingActive.Checked and cb_RatingChangeCounter.Checked;
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

procedure TOptionsCompleteForm.HeadSetVolumeTRACKBARChange(
  Sender: TObject);
begin
  NempPlayer.HeadsetVolume := HeadSetVolumeTRACKBAR.Position;
  BASS_ChannelSetAttribute(NempPlayer.HeadsetStream, BASS_ATTRIB_VOL, NempPlayer.HeadSetVolume);
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

(*
procedure TOptionsCompleteForm.RePaintVerlauf(Verlauf: Boolean);
var i: integer;
begin
  for i:=0 to 320 do
  begin
    if Verlauf then
      VerlaufBitmap.Canvas.Pen.Color := BitrateToColor (i,
      ShapeMinColor.Brush.Color,
      ShapeMittelColor.Brush.Color,
      ShapeMaxColor.Brush.Color,
      CBMiddleToMinComputing.ItemIndex,
      CBMiddleToMaxComputing.ItemIndex )
    else
      VerlaufBitmap.Canvas.Pen.Color := clWindowText;
    VerlaufBitmap.Canvas.MoveTo(i,0);
    VerlaufBitmap.Canvas.LineTo(i,17);
  end;
  Image1.Picture.Assign(VerlaufBitmap);
end;
*)

procedure TOptionsCompleteForm.Btn_SelectAllClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to CBFileTypes.Count - 1 do
    CBFileTypes.Checked[i] := True;
  for i := 0 to CBPlaylistTypes.Count-1 do
    CBPlaylistTypes.Checked[i] := True;
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
  if CBiTouch.Checked then
    ftr.SetITouchMediaPlayer('"' +  Paramstr(0) + '"');

  ftr.UpdateShell;
  ftr.free;
end;


procedure TOptionsCompleteForm.cbIncludeAllClick(Sender: TObject);
begin
  cbIncludeFiles.Enabled := NOT cbIncludeAll.Checked;
  LblConst_OnlythefollowingTypes.Enabled := NOT cbIncludeAll.Checked;
end;

procedure TOptionsCompleteForm.CBJingleReduceClick(Sender: TObject);
begin
  SEJingleReduce.Enabled := CBJingleReduce.Checked;
  LblJingleReduce.Enabled := CBJingleReduce.Checked;
end;

procedure TOptionsCompleteForm.CB_AutoDeleteFromPlaylistClick(
  Sender: TObject);
begin
      CB_DisableAutoDeleteAtSlide.Enabled         := CB_AutoDeleteFromPlaylist.Checked  ;
      CB_DisableAutoDeleteAtPause.Enabled         := CB_AutoDeleteFromPlaylist.Checked  ;
      CB_DisAbleAutoDeleteAtStop.Enabled          := CB_AutoDeleteFromPlaylist.Checked  ;
      CB_DisableAutoDeleteAtTitleChange.Enabled   := CB_AutoDeleteFromPlaylist.Checked  ;
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
var SkinDir: UnicodeString;
begin
  //GRPBOXControl.OwnerDraw := CBSkinAuswahl.Itemindex > 0;
  //GRPBOXSpectrum.OwnerDraw := CBSkinAuswahl.Itemindex > 0;
  //GRPBOXTextAnzeige.OwnerDraw := CBSkinAuswahl.Itemindex > 0;
  NewPlayerPanelOptions.OwnerDraw := CBSkinAuswahl.Itemindex > 0;

  if CBSkinAuswahl.Itemindex > 0 then
  begin
      Skindir := StringReplace(CBSkinAuswahl.Items[CBSkinAuswahl.Itemindex],
                  '<public> ', ExtractFilePath(ParamStr(0)) + 'Skins\', []);

      Skindir := StringReplace(Skindir,
                  '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);

      TestSkin.LoadFromDir(SkinDir, False);

      VolShape.Brush.Color := TestSkin.SkinColorScheme.ShapeBrushCL;
      VolShape.Pen.Color := TestSkin.SkinColorScheme.ShapePenCL;
      SlidebarShape.Brush.Color := TestSkin.SkinColorScheme.ShapeBrushCL;
      SlidebarShape.Pen.Color := TestSkin.SkinColorScheme.ShapePenCL;
  end else
  begin
      VolShape.Brush.Color := clGradientActiveCaption;
      VolShape.Pen.Color := clBlack;
      SlidebarShape.Brush.Color := clGradientActiveCaption;
      SlidebarShape.Pen.Color := clBlack;
  end;

  TestSkin.DrawPreview(NewPlayerPanelOptions);
  NewPlayerPanelOptions.Repaint;
  //GRPBOXControl.Repaint;
  //GRPBOXSpectrum.Repaint;
  //GRPBOXTextAnzeige.Repaint;
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
  NeedUpdate, NeedFormUpdate, NeedTotalStringUpdate, NeedTotalLyricStringUpdate: boolean;
  newLanguage: String;
  ReDrawVorauswahlTrees, ReDrawPlaylistTree, ReDrawMedienlistTree: Boolean;
  Ini: TMemIniFile;
    hMod: Cardinal;
    hKey: Byte;
  oldfactor: single;
begin
  // Beta-Optionen
  MedienBib.BetaDontUseThreadedUpdate := cb_BetaDontUseThreadedUpdate.Checked;

  if cb_UseClassicCoverflow.Checked then
      MedienBib.NewCoverFlow.Mode := cm_Classic
  else
      MedienBib.NewCoverFlow.Mode := cm_OpenGL;

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

  NempPlayer.HeadsetVolume := HeadSetVolumeTRACKBAR.Position / 100;

  NempPlaylist.DefaultAction := GrpBox_DefaultAction.ItemIndex;

  NempPlayer.UseFading := CB_Fading.Checked;
  NempPlayer.UseVisualization := CB_Visual.Checked;
  if not NempPlayer.UseVisualization then
    spectrum.DrawClear;
  NempPlayer.FadingInterval := SE_Fade.Value;
  NempPlayer.SeekFadingInterval := SE_SeekFade.Value;
  NempPlayer.IgnoreFadingOnShortTracks := CB_IgnoreFadingOnShortTracks.Checked;
  NempPlayer.IgnoreFadingOnPause := CB_IgnoreFadingOnPause.Checked;
  NempPlayer.IgnoreFadingOnStop := CB_IgnoreFadingOnStop.Checked;

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

  NempPlaylist.AutoSave         := CB_AutoSavePlaylist.Checked;
  //NempPlaylist.AutoSaveInterval := SEAutoSavePlaylistInterval.Value;
  Nemp_MainForm.AutoSavePlaylistTimer.Enabled := CB_AutoSavePlaylist.Checked;
  Nemp_MainForm.AutoSavePlaylistTimer.Interval := 5 * 60000;

  NempPlaylist.AutoDelete     := CB_AutoDeleteFromPlaylist.Checked;
        NempPlaylist.DisableAutoDeleteAtSlide        := CB_DisableAutoDeleteAtSlide.Checked         ;
        NempPlaylist.DisableAutoDeleteAtPause        := CB_DisableAutoDeleteAtPause.Checked         ;
        NempPlaylist.DisAbleAutoDeleteAtStop         := CB_DisAbleAutoDeleteAtStop.Checked          ;
        NempPlaylist.DisableAutoDeleteAtTitleChange  := CB_DisableAutoDeleteAtTitleChange.Checked   ;


  NempPlaylist.AutoMix       := CB_AutoMixPlaylist.Checked;
  NempPlaylist.JumpToNextCueOnNextClick := CB_JumpToNextCue.Checked;
  NempPlaylist.RememberInterruptedPlayPosition := CB_RememberInterruptedPlayPosition.Checked;
  NempPlaylist.ShowHintsInPlaylist := CB_ShowHintsInPlaylist.Checked;
  Nemp_MainForm.PlaylistVST.ShowHint := NempPlaylist.ShowHintsInPlaylist;

  NempPlaylist.RandomRepeat := TBRandomRepeat.Position;

  NempPlayer.DownloadDir := IncludeTrailingPathDelimiter(EdtDownloadDir.Text);
  NempPlayer.FilenameFormat := cbFilenameFormat.Text;
  NempPlayer.AutoSplitByTitle := cbAutoSplitByTitle.Checked;

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
  if CB_CoverSearch_LastFM.Checked then
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

  MedienBib.CoverSearchSubDirName := EDTCoverSubDirName.Text ;
  MedienBib.CoverSearchSisterDirName := EDTCoverSisterDirName.Text;
  MedienBib.HideNACover := cbHideNACover.Checked;

  //Nemp_MainForm.NempOptions.DenyId3Edit := cbDenyId3Edit.Checked;
  Nemp_MainForm.NempOptions.FullRowSelect := cbFullRowSelect.Checked;
  MedienBib.AlwaysSortAnzeigeList := cbAlwaysSortAnzeigeList.Checked;
  MedienBib.SkipSortOnLargeLists := CBSkipSortOnLargeLists.Checked;
  MedienBib.AutoScanPlaylistFilesOnView := CBAutoScanPlaylistFilesOnView.Checked;
  MedienBib.ShowHintsInMedialist := CBShowHintsInMedialist.Checked;
  Nemp_MainForm.VST.ShowHint := MedienBib.ShowHintsInMedialist;

  NeedUpdate := False;
  NeedTotalStringUpdate := False;
  NeedTotalLyricStringUpdate := False;
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
      then
      begin
          // We have changed something with the current Browse-Values
          // Update needed
          NeedUpdate := True;
      end;
      // However, we can synchronize VCL and Data here always. ;-)
      MedienBib.NempSortArray[1] := TAudioFileStringIndex(CBSortArray1.ItemIndex);
      MedienBib.NempSortArray[2] := TAudioFileStringIndex(CBSortArray2.ItemIndex);
      MedienBib.CoverSortOrder := cbCoverSortOrder.ItemIndex + 1;

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
      MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnEnter := CB_QuickSearchAllowErrorsOnEnter    .Checked;
      MedienBib.BibSearcher.QuickSearchOptions.AllowErrorsOnType  := CB_QuickSearchAllowErrorsWhileTyping.Checked;
  end else
  begin
    MessageDLG((Warning_MedienBibIsBusy_Options), mtWarning, [MBOK], 0);
    CBSortArray1.ItemIndex := integer(MedienBib.NempSortArray[1]);
    CBSortArray2.ItemIndex := integer(MedienBib.NempSortArray[2]);
    cbCoverSortOrder.ItemIndex := MedienBib.CoverSortOrder - 1;
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


  Nemp_MainForm.NempOptions.AllowOnlyOneInstance := Not CB_AllowMultipleInstances.Checked;
  Nemp_MainForm.NempOptions.StartMinimized  := CB_StartMinimized.Checked;
  Nemp_MainForm.NempOptions.RegisterHotKeys := CBRegisterHotKeys.Checked;

  Nemp_MainForm.NempOptions.TabStopAtPlayerControls := CB_TabStopAtPlayerControls.Checked;
  Nemp_MainForm.NempOptions.TabStopAtTabs           := CB_TabStopAtTabs          .Checked;
  SetTabStopsPlayer;
  SetTabStopsTabs;


  Nemp_MainForm.NempOptions.IgnoreVolumeUpDownKeys := CB_IgnoreVolume.Checked;

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
  Nemp_MainForm.NempOptions.FontSize[3] :=  SEFontSize.Value;

  Nemp_MainForm.NempOptions.FontSize[1] :=  max(4,
                  Nemp_MainForm.NempOptions.FontSize[3] - (Nemp_MainForm.NempOptions.FontSize[3] Div 2));

  Nemp_MainForm.NempOptions.FontSize[2] :=  max(4,
                  Nemp_MainForm.NempOptions.FontSize[3] - (Nemp_MainForm.NempOptions.FontSize[3] Div 4));

  Nemp_MainForm.NempOptions.FontSize[4] :=  Nemp_MainForm.NempOptions.FontSize[3] + (Nemp_MainForm.NempOptions.FontSize[3] Div 4);
  Nemp_MainForm.NempOptions.FontSize[5] :=  Nemp_MainForm.NempOptions.FontSize[3] + (Nemp_MainForm.NempOptions.FontSize[3] Div 2);
  Nemp_MainForm.NempOptions.RowHeight := SERowHeight.Value;

  if Nemp_MainForm.NempOptions.ChangeFontSizeOnLength then
      maxFont := Nemp_MainForm.NempOptions.FontSize[5]
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
      PlaylistVST.Header.Columns[1].Width := PlaylistVST.Canvas.TextWidth('@99:99');
      PlaylistVSTResize(Nil);

      PlaylistVST.Font.Size := NempOptions.DefaultFontSize;
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
      NempCharCodeOptions.AlwaysWriteUnicode := CBAlwaysWriteUnicode.Checked;
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
    UseCountDown := CBStartCountDown.Checked AND (Trim(EditCountdownSong.Text)<> '');

    if (CountDownFileName <> EditCountdownSong.Text)
      or (BirthdaySongFilename <> EditBirthdaySong.Text)
    then begin
        CountDownFileName := EditCountdownSong.Text;
        BirthdaySongFilename := EditBirthdaySong.Text;
        StartTime := //TimeOf
                    (DTPBirthdayTime.Time);
        if UseCountDown then
          StartCountDownTime := IncSecond(StartTime, - NempPlayer.GetCountDownLength(CountDownFileName))
        else
          StartCountDownTime := StartTime;
    end;

    ContinueAfter := CBContinueAfter.Checked;
    NempPlayer.WriteBirthdayOptions(SavePath + NEMP_NAME + '.ini');
  end;

  // Hotkeys neu setzen, Ini Speichern
  for i := 0 to 9 do
    UnRegisterHotkey(Nemp_MainForm.Handle, i);

  ini := TMeminiFile.Create(SavePath + 'Hotkeys.ini', TEncoding.UTF8);
  try
        ini.Encoding := TEncoding.UTF8;
        Ini.WriteBool('HotKeys','InstallHotkey_Play'       , CB_Activate_Play.Checked);
          hMod := IndexToMod(CB_Mod_Play.ItemIndex);
          hKey := IndexToKey(CB_Key_Play.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Play', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Play', hKey);
        if CB_Activate_Play.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 1, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Stop'       , CB_Activate_Stop.Checked);
          hMod := IndexToMod(CB_Mod_Stop.ItemIndex);
          hKey := IndexToKey(CB_Key_Stop.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Stop', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Stop', hKey);
        if CB_Activate_Stop.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 2, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Next'       , CB_Activate_Next.Checked);
          hMod := IndexToMod(CB_Mod_Next.ItemIndex);
          hKey := IndexToKey(CB_Key_Next.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Next', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Next', hKey);
        if CB_Activate_Next.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 3, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Prev'       , CB_Activate_Prev.Checked);
          hMod := IndexToMod(CB_Mod_Prev.ItemIndex);
          hKey := IndexToKey(CB_Key_Prev.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Prev', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Prev', hKey);
        if CB_Activate_Prev.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 4, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_JumpForward', CB_Activate_JumpForward.Checked);
          hMod := IndexToMod(CB_Mod_JumpForward.ItemIndex);
          hKey := IndexToKey(CB_Key_JumpForward.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_JumpForward', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_JumpForward', hKey);
        if CB_Activate_JumpForward.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 5, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_JumpBack'   , CB_Activate_JumpBack.Checked);
          hMod := IndexToMod(CB_Mod_JumpBack.ItemIndex);
          hKey := IndexToKey(CB_Key_JumpBack.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_JumpBack', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_JumpBack', hKey);
        if CB_Activate_JumpBack.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 6, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_IncVol'     , CB_Activate_IncVol.Checked);
          hMod := IndexToMod(CB_Mod_IncVol.ItemIndex);
          hKey := IndexToKey(CB_Key_IncVol.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_IncVol', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_IncVol', hKey);
        if CB_Activate_IncVol.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 7, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_DecVol'     , CB_Activate_DecVol.Checked);
          hMod := IndexToMod(CB_Mod_DecVol.ItemIndex);
          hKey := IndexToKey(CB_Key_DecVol.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_DecVol', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_DecVol', hKey);
        if CB_Activate_DecVol.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 8, HMod, hKey);

        Ini.WriteBool('HotKeys','InstallHotkey_Mute'       , CB_Activate_mute.Checked);
          hMod := IndexToMod(CB_Mod_Mute.ItemIndex);
          hKey := IndexToKey(CB_Key_Mute.ItemIndex);
          Ini.WriteInteger('HotKeys', 'HotkeyMod_Mute', hMod);
          Ini.WriteInteger('HotKeys', 'HotkeyKey_Mute', hKey);
        if CB_Activate_Mute.Checked AND CBRegisterHotKeys.Checked then
          RegisterHotkey(Nemp_MainForm.Handle, 9, HMod, hKey);
        try
            Ini.UpdateFile;
        except

        end;
  finally
    Ini.Free;
  end;

  //========================================================
  // In 3.0 final neue Optionen für die Anzeige:
  NeedFormUpdate := (RGrp_View.ItemIndex <> (Nemp_MainForm.AnzeigeMode Mod 2))
                    OR (Nemp_MainForm.NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible <> cb_ShowEffectsWindow.Checked   )
                    OR (Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistVisible           <> cb_ShowPlaylistWindow.Checked  )
                    OR (Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteVisible        <> CB_ShowMedialistWindow.Checked )
                    OR (Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheVisible       <> CB_ShowBrowseWindow.Checked    );


  Nemp_MainForm.AnzeigeMode := RGrp_View.ItemIndex;
  Nemp_MainForm.NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible := cb_ShowEffectsWindow.Checked    ;
  Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistVisible           := cb_ShowPlaylistWindow.Checked   ;
  Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteVisible        := CB_ShowMedialistWindow.Checked  ;
  Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheVisible       := CB_ShowBrowseWindow.Checked     ;

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

  // Form an neue Ansicht anpassen
  if NeedFormUpdate then
      UpdateFormDesignNeu;

  Nemp_MainForm.RepairZOrder;
  Show;


  l := cb_Language.ItemIndex - 1;
  if l > -2 then
  begin
      Case l of
          -2,-1: newLanguage := 'en';
          else begin
              if l <= LanguageList.Count -1 then
                newLanguage := LanguageList[l]
              else
                newLanguage := 'en';
              end;
        end;
        Nemp_MainForm.NempOptions.Language := newLanguage;
        ReTranslateNemp(newLanguage);
  end;


  //========================================================

  if CBSkinAuswahl.Itemindex = 0 then
  begin
      Nemp_MainForm.NempSkin.DeActivateSkin;
      Nemp_MainForm.UseSkin := False;
      Nemp_MainForm.RePaintPanels;
      Nemp_MainForm.RepaintOtherForms;
      Nemp_MainForm.RepaintAll;
  end else
  begin
      // Skin komplett laden
      TestSkin.LoadFromDir(Testskin.Path, True);
      // setzen
      Nemp_MainForm.UseSkin := True;
      Nemp_MainForm.NempSkin.copyFrom(TestSkin);
      Nemp_MainForm.NempSkin.ActivateSkin;
      Nemp_MainForm.SkinName := CBSkinAuswahl.Items[CBSkinAuswahl.Itemindex];
      Nemp_MainForm.RePaintPanels;
      Nemp_MainForm.RepaintOtherForms;
      Nemp_MainForm.RepaintAll;
  end;

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
          if not NempPlayer.MainAudioFile.IsStream then
          begin
              NempPlayer.NempScrobbler.ChangeCurrentPlayingFile(NempPlayer.MainAudioFile);
              NempPlayer.NempScrobbler.PlaybackStarted;
          end;
      end;
  end;

  // Webserver
  NempWebServer.Username := EdtUsername.Text;
  NempWebServer.Password := EdtPassword.Text;
  NempWebServer.OnlyLAN  := cbOnlyLAN.Checked;
  NempWebServer.AllowLibraryAccess    := cbPermitLibraryAccess.Checked;
  NempWebServer.AllowPlaylistDownload := cbPermitPlaylistDownload.Checked;
  NempWebServer.AllowRemoteControl    := cbAllowRemoteControl.Checked;
  MedienBib.AutoActivateWebServer     := CBAutoStartWebServer.Checked;
  NempWebServer.SaveToIni;


  oldfactor := Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor;

  Nemp_MainForm.NempSkin.NempPartyMode.ResizeFactor :=
  Nemp_MainForm.NempSkin.NempPartyMode.IndexToFactor(CB_PartyMode_ResizeFactor.ItemIndex);

  Nemp_MainForm.NempSkin.NempPartyMode.BlockTreeEdit           := cb_PartyMode_BlockTreeEdit          .Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockCurrentTitleRating := cb_PartyMode_BlockCurrentTitleRating.Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.BlockTools              := cb_PartyMode_BlockTools             .Checked;
  Nemp_MainForm.NempSkin.NempPartyMode.password := Edt_PartyModePassword.Text;

 { if True then

  NempSkin.NempPartyMode.Active := not NempSkin.NempPartyMode.Active;
  CorrectFormAfterPartyModeChange;
  }

  // automatic rating
  NempPlayer.PostProcessor.Active                       := cb_RatingActive                       .checked ;
  NempPlayer.PostProcessor.IgnoreShortFiles             := cb_RatingIgnoreShortFiles             .checked ;
  NempPlayer.PostProcessor.WriteToFiles                 := cb_RatingWriteToFiles                 .checked ;
  NempPlayer.PostProcessor.ChangeCounter                := cb_RatingChangeCounter                .checked ;
  NempPlayer.PostProcessor.IgnoreCounterOnAbortedTracks := cb_RatingIgnoreCounterOnAbortedTracks .checked ;
  NempPlayer.PostProcessor.IncPlayedFiles               := cb_RatingIncreaseRating               .checked ;
  NempPlayer.PostProcessor.DecAbortedFiles              := cb_RatingDecreaseRating               .checked ;

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

procedure TOptionsCompleteForm.Btn_ConfigureMediaKeysClick(Sender: TObject);
var WinVersionInfo: TWindowsVersionInfo;

    procedure StartConfig;
    begin
        with Nemp_MainForm do
        begin
            // Um die Reaktionen auf die Tasten "umzuschalten"
          SchonMalEineMediaTasteGedrueckt := False;
          // Den Medientasten-Test starten
          MMKeyTimer.Enabled := True;
        end;
    end;

begin
    WinVersionInfo := TWindowsVersionInfo.Create;
    try
        if WinVersionInfo.ProcessorArchitecture = pax64 then
        begin
            if MessageDLG((WinX64WarningHook), mtWarning, [MBYes, MBNO], 0) = mrYes then
                StartConfig
            else
            begin
                Nemp_MainForm.SchonMalEineMediaTasteGedrueckt := True;
                Nemp_MainForm.DoHookInstall := False;
                if HookIsInstalled then
                    UninstallHook;
                HookIsInstalled := False;
                Lbl_MultimediaKeys_Status.Caption := (MediaKeys_Status_Standard);
            end;
        end else
            StartConfig;
    finally
        WinVersionInfo.Free;
    end;
end;

procedure TOptionsCompleteForm.Btn_ReinitPlayerEngineClick(Sender: TObject);
begin
  NempPlaylist.RepairBassEngine(True);
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
  FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_BibCaption );
  try
      if fb.Execute then
      begin
          newdir := Fb.SelectedItem;

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
    authUrl: String;
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
            aScrobbler := TScrobbler.Create(Handle);
            aScrobbler.GetToken;
            // Auf Message warten -> Dann enablen und Tag auf 2 setzen
        end;

        2: begin
            // Token ist da. Browser öffnen
            authUrl := 'http://www.last.fm/api/auth/?api_key=' + api_key + '&token=' + NempPlayer.NempScrobbler.Token;
            ShellExecute(Handle, 'open', PChar(authUrl), nil, nil, SW_SHOW);
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

            aScrobbler := TScrobbler.Create(Handle);
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
    NempPlayer.NempScrobbler.AllowHandShakingAgain;
end;

Procedure TOptionsCompleteForm.ScrobblerMessage(Var aMsg: TMessage);
var aList: TStrings;
    responseString: String;
    ini: TMemIniFile;
begin
    Case aMsg.WParam of

        SC_Message: begin
            aList := TStringlist.Create;
            try
                aList.CommaText := PChar(aMsg.LParam);
                MemoScrobbleLog.Lines.AddStrings(aList);
                NempPlayer.NempScrobbler.LogList.AddStrings(aList);
            finally
                aList.Free;
            end;
        end;

        SC_GetTokenException: begin
            // LParam: ErrorMessage
            MemoScrobbleLog.Lines.Add(PChar(aMsg.LParam));
            NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
            SetScrobbleButtonOnError;
        end;
        SC_GetToken: begin
            responseString := PChar(aMsg.LParam);
            //fToken aus Antwort bestimmen
            NempPlayer.NempScrobbler.Token := GetTokenFromResponse(responseString);
            if NempPlayer.NempScrobbler.Token <> '' then
            begin
                MemoScrobbleLog.Lines.Add('GetToken: OK ... ' + NempPlayer.NempScrobbler.Token);
                NempPlayer.NempScrobbler.LogList.Add('GetToken: OK ... ' + NempPlayer.NempScrobbler.Token);
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

        SC_GetSessionException: begin
            // LParam: ErrorMessage
            MemoScrobbleLog.Lines.Add(PChar(aMsg.LParam));
            NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
            SetScrobbleButtonOnError;
        end;
        SC_GetSession:begin
                responseString := PChar(aMsg.LParam);
                NempPlayer.NempScrobbler.Username := GetUserNameFromResponse(responseString);
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

                NempPlayer.NempScrobbler.SessionKey := GetSessionKeyFromResponse(responseString);
                if NempPlayer.NempScrobbler.SessionKey <> '' then
                begin
                    MemoScrobbleLog.Lines.Add('GetSessionKey: OK ... ' + NempPlayer.NempScrobbler.SessionKey);
                    NempPlayer.NempScrobbler.LogList.Add('GetSessionKey: OK ... ' + NempPlayer.NempScrobbler.SessionKey);
                end
                else
                begin
                    MemoScrobbleLog.Lines.Add('GetSessionKey: FAILED ... ');
                    NempPlayer.NempScrobbler.LogList.Add('GetSessionKey: FAILED ... ');
                end;

                NempPlayer.NempScrobbler.AllowHandShakingAgain;

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
        NempWebServer.Username := EdtUsername.Text;
        NempWebServer.Password := EdtPassword.Text;
        NempWebServer.OnlyLAN := cbOnlyLAN.Checked;
        NempWebServer.AllowLibraryAccess := cbPermitLibraryAccess.Checked;
        NempWebServer.AllowPlaylistDownload := cbPermitPlaylistDownload.Checked;
        NempWebServer.AllowRemoteControl := cbAllowRemoteControl.Checked;
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
        //BtnUpdateAuth.Enabled := True;
        //LogMemo.Lines.Add(DateTimeToStr(Now, LocalFormatSettings) + ', Server shutdown.');
        ReArrangeToolImages;
    end;
end;


procedure TOptionsCompleteForm.EdtUsernameKeyPress(Sender: TObject;
  var Key: Char);
begin
    case Word(key) of
        VK_RETURN: begin
            key:=#0;
            BtnUpdateAuthClick(Sender);
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
            BtnUpdateAuthClick(Sender);
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
procedure TOptionsCompleteForm.BtnUpdateAuthClick(Sender: TObject);
begin
//    NempWebServer.Username := EdtUsername.Text;
//    NempWebServer.Password := EdtPassword.Text;
end;


end.

