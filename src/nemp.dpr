program nemp;

{.$R 'Nemp_Graphics.res' 'Nemp_Graphics.rc'}

// dontTouchUses  <- this tells madExcept to not touch the uses clause

{$I xe.inc}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  Windows,
  SysUtils,
  Graphics,
  vcl.themes,
  vcl.styles,
  WinApi.Messages,
  NempMainUnit in 'NempMainUnit.pas' {Nemp_MainForm},
  Splash in 'Splash.pas' {FSplash},
  PlaylistUnit in 'PlaylistUnit.pas' {PlaylistForm},
  AuswahlUnit in 'AuswahlUnit.pas' {AuswahlForm},
  MedienlisteUnit in 'MedienlisteUnit.pas' {MedienlisteForm},
  ExtendedControlsUnit in 'ExtendedControlsUnit.pas' {ExtendedControlForm},
  Nemp_ConstantsAndTypes in 'Nemp_ConstantsAndTypes.pas',
  CreateHelper in 'CreateHelper.pas',
  NempApi in 'common\NempApi.pas',
  bass in '3rd Party Units\bass.pas',
  bass_fx in '3rd Party Units\bass_fx.pas',
  basscd in '3rd Party Units\basscd.pas',
  md5 in '3rd Party Units\md5.pas',
  MyDialogs in '3rd Party Units\MyDialogs.pas',
  unitFlyingCow in '3rd Party Units\unitFlyingCow.pas',
  dglOpenGL in '3rd Party Units\dglOpenGL.pas',
  fldbrows in '3rd Party Units\fldbrows.pas',
  SearchTool in '3rd Party Units\SearchTool.pas',
  filetypes in '3rd Party Units\filetypes.pas',
  WindowsVersionInfo in '3rd Party Units\WindowsVersionInfo.pas',
  Windows_Fragment in '3rd Party Units\Windows_Fragment.pas',
  gnugettext in '3rd Party Units\gnugettext.pas',
  languagecodes in '3rd Party Units\languagecodes.pas',
  bassmidi in '3rd Party Units\bassmidi.pas',
  unFastFileStream in '3rd Party Units\unFastFileStream.pas',
  BasicSettingsWizard in 'BasicSettingsWizard.pas' {Wizard},
  Details in 'Details.pas' {FDetails},
  NempAudioFiles in 'NempAudioFiles.pas',
  NewPicture in 'NewPicture.pas' {FNewPicture},
  spectrum_vis in 'spectrum_vis.pas',
  Hilfsfunktionen in 'Hilfsfunktionen.pas',
  TreeHelper in 'TreeHelper.pas',
  About in 'About.pas' {AboutForm},
  StreamVerwaltung in 'StreamVerwaltung.pas' {FormStreamVerwaltung},
  SplitForm_Hilfsfunktionen in 'SplitForm_Hilfsfunktionen.pas',
  ShutDown in 'ShutDown.pas' {ShutDownForm},
  Nemp_SkinSystem in 'Nemp_SkinSystem.pas',
  BirthdayShow in 'BirthdayShow.pas' {BirthdayForm},
  PlaylistClass in 'PlaylistClass.pas',
  PlayerClass in 'PlayerClass.pas',
  MedienbibliothekClass in 'MedienbibliothekClass.pas',
  RandomPlaylist in 'RandomPlaylist.pas' {RandomPlaylistForm},
  Nemp_RessourceStrings in 'Nemp_RessourceStrings.pas',
  ShutDownEdit in 'ShutDownEdit.pas' {ShutDownEditForm},
  DriveRepairTools in 'DriveRepairTools.pas',
  ShoutcastUtils in 'ShoutcastUtils.pas',
  NewStation in 'NewStation.pas' {NewStationForm},
  WebServerClass in 'WebServerClass.pas',
  Easteregg in 'Easteregg.pas',
  UpdateUtils in 'UpdateUtils.pas',
  ScrobblerUtils in 'ScrobblerUtils.pas',
  BibSearch in 'BibSearch.pas' {FormBibSearch},
  BibSearchClass in 'BibSearchClass.pas',
  AudioFileHelper in 'AudioFileHelper.pas',
  CoverHelper in 'CoverHelper.pas',
  Systemhelper in 'Systemhelper.pas',
  StringSearchHelper in 'StringSearchHelper.pas',
  StringHelper in 'StringHelper.pas',
  BibHelper in 'BibHelper.pas',
  MainFormHelper in 'MainFormHelper.pas',
  MessageHelper in 'MessageHelper.pas',
  BassHelper in 'BassHelper.pas',
  VSTEditControls in 'VSTEditControls.pas',
  ClassicCoverflowClass in 'ClassicCoverflowClass.pas',
  NempCoverFlowClass in 'NempCoverFlowClass.pas',
  PartyModeClass in 'PartyModeClass.pas',
  PostProcessorUtils in 'PostProcessorUtils.pas',
  RatingCtrls in 'RatingCtrls.pas',
  TagClouds in 'TagClouds.pas' {/,  classes;},
  CloudEditor in 'CloudEditor.pas' {CloudEditorForm},
  Taghelper in 'Taghelper.pas',
  CoverDownloads in 'CoverDownloads.pas',
  PartymodePassword in 'PartymodePassword.pas' {PasswordDlg},
  Lyrics in 'Lyrics.pas',
  HtmlHelper in 'HtmlHelper.pas',
  OptionsComplete in 'OptionsComplete.pas' {OptionsCompleteForm},
  ExPopupList in 'ExPopupList.pas',
  PlaylistToUSB in 'PlaylistToUSB.pas' {PlaylistCopyForm},
  ErrorForm in 'ErrorForm.pas' {FError},
  cddaUtils in 'cddaUtils.pas',
  CDSelection in 'CDSelection.pas' {FormCDDBSelect},
  CDOpenDialogs in 'CDOpenDialogs.pas' {CDOpenDialog},
  DeleteHelper in 'DeleteHelper.pas',
  DeleteSelect in 'DeleteSelect.pas' {DeleteSelection},
  CustomizedScrobbler in 'CustomizedScrobbler.pas',
  Votings in 'Votings.pas',
  WebServerLog in 'WebServerLog.pas' {WebServerLogForm},
  SilenceDetection in 'SilenceDetection.pas',
  PlayWebstream in 'PlayWebstream.pas',
  PlayerLog in 'PlayerLog.pas' {PlayerLogForm},
  EffectsAndEqualizer in 'EffectsAndEqualizer.pas' {FormEffectsAndEqualizer},
  MainFormBuilderForm in 'MainFormBuilderForm.pas' {MainFormBuilder},
  NempFileUtils in 'NempFileUtils.pas',
  NempReplayGainCalculation in 'NempReplayGainCalculation.pas',
  NewMetaFrame in 'NewMetaFrame.pas' {NewMetaFrameForm},
  MetaTagSorting in 'MetaTagSorting.pas',
  PlaylistManagement in 'PlaylistManagement.pas',
  NewFavoritePlaylist in 'NewFavoritePlaylist.pas' {NewFavoritePlaylistForm},
  PlaylistEditor in 'PlaylistEditor.pas' {PlaylistEditorForm},
  WebQRCodes in 'WebQRCodes.pas' {WebServerQRForm},
  AudioDisplayUtils in 'AudioDisplayUtils.pas',
  BaseForms in 'BaseForms.pas',
  DuplicateFilesDialogs in 'DuplicateFilesDialogs.pas' {DuplicateFilesDialog},
  PlaylistDuplicates in 'PlaylistDuplicates.pas' {FormPlaylistDuplicates},
  LibraryOrganizer.Base in 'LibraryOrganizer.Base.pas',
  Cover.ViewCache in 'Cover.ViewCache.pas',
  LibraryOrganizer.Playlists in 'LibraryOrganizer.Playlists.pas',
  LibraryOrganizer.Files in 'LibraryOrganizer.Files.pas',
  LibraryOrganizer.Webradio in 'LibraryOrganizer.Webradio.pas',
  LibraryOrganizer.Configuration.NewLayer in 'LibraryOrganizer.Configuration.NewLayer.pas' {FormNewLayer},
  NempDragFiles in 'NempDragFiles.pas',
  fChangeFileCategory in 'fChangeFileCategory.pas' {FormChangeCategory},
  ProgressUnit in 'ProgressUnit.pas' {ProgressForm},
  ReplayGainProgress in 'ReplayGainProgress.pas' {ReplayGainProgressForm},
  OneInst in '3rd Party Units\OneInst.pas',
  RedeemerQR in '3rd Party Units\RedeemerQR.pas',
  RedeemerInheritablePNG in '3rd Party Units\RedeemerInheritablePNG.pas',
  ReplayGain in '3rd Party Units\ReplayGain.pas',
  MainFormLayout in 'MainFormLayout.pas',
  NempHelp in 'NempHelp.pas',
  fConfigErrorDlg in 'fConfigErrorDlg.pas' {ConfigErrorDlg};

{$R *.res}

var EVILHACKX, EVILHACKY: INTEGER;



begin

    ReportMemoryLeaksOnShutdown := False;

    Application.Initialize;
    Application.MainFormOnTaskbar := True;


  {$IFDEF USESTYLES}
    //TStyleManager.Engine.RegisterStyleHook(TNemp_MainForm, TFormStyleHookFix);
  {$ENDIF}

  Application.CreateForm(TNemp_MainForm, Nemp_MainForm);
  Application.CreateForm(TProgressForm, ProgressFormPlaylist);
  Application.CreateForm(TProgressForm, ProgressFormLibrary);
  Application.CreateForm(TReplayGainProgressForm, ReplayGainProgressForm);
  Graphics.DefFontData.Name := 'Tahoma';

  Application.Title := NEMP_NAME_TASK;
  Application.Name  := NEMP_NAME;

    // Show Mainform, but beyond all visible area
    Nemp_MainForm.Top := 10000;
    Nemp_MainForm.Visible := True;
    Nemp_MainForm.Top := 10000;

    Application.CreateForm(TFSplash, FSplash);

    Application.CreateForm(TPlaylistForm   , PlaylistForm   );
    Application.CreateForm(TAuswahlForm    , AuswahlForm    );
    Application.CreateForm(TMedienlisteForm, MedienlisteForm);
    Application.CreateForm(TExtendedControlForm, ExtendedControlForm);




    StuffToDoAfterCreate ;

    // TOP scheint hier ok zu sein, aber dann kommen irgendwelche Messages und machen Top wieder auf 10.000
    EVILHACKY := Nemp_MainForm.Top;
    EVILHACKX := Nemp_MainForm.Left;
    Application.ProcessMessages;
    Nemp_MainForm.Top := EVILHACKY;
    Nemp_MainForm.Left := EVILHACKX;

    InitializeCoverflow;
    // for some reasons, there are some controls "unpainted" on startup on some skins
    Nemp_MainForm.RepaintAll;

    if (NempOptions.StartMinimized) or (NempOptions.StartMinimizedByParameter) then
    begin
        // DAS HIER DIENT DEM VERSTECKEN, NICHT DEM ANZEIGEN
       PostMessage(FOwnMessageHandler, WM_Command, COMMAND_RESTORE, 0);
    end;

    FSplash.Visible := False;


    RunWizard;

    Application.Run;

end.
