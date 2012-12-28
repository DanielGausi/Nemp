program nemp;

{.$R 'Nemp_Graphics.res' 'Nemp_Graphics.rc'}

// dontTouchUses  <- this tells madExcept to not touch the uses clause
// note to self: publish nemp.mes (this contains the MadExcept setting)




{$R *.dres}
{$I xe.inc}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  OneInst in '3rd Party Units\OneInst.pas',
  gnuGettext,
  Forms,
  Windows,
  SysUtils,
  Graphics,
  NempMainUnit in 'NempMainUnit.pas' {Nemp_MainForm},
  Details in 'Details.pas' {FDetails},
  NempAudioFiles in 'NempAudioFiles.pas',
  NewPicture in 'NewPicture.pas' {FNewPicture},
  Splash in 'Splash.pas' {FSplash},
  spectrum_vis in 'spectrum_vis.pas',
  Hilfsfunktionen in 'Hilfsfunktionen.pas',
  TreeHelper in 'TreeHelper.pas',
  About in 'About.pas' {AboutForm},
  StreamVerwaltung in 'StreamVerwaltung.pas' {FormStreamVerwaltung},
  Nemp_ConstantsAndTypes in 'Nemp_ConstantsAndTypes.pas',
  PlaylistUnit in 'PlaylistUnit.pas' {PlaylistForm},
  AuswahlUnit in 'AuswahlUnit.pas' {AuswahlForm},
  MedienlisteUnit in 'MedienlisteUnit.pas' {MedienlisteForm},
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
  Messages,
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
  ExtendedControlsUnit in 'ExtendedControlsUnit.pas' {ExtendedControlForm},
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
  CreateHelper in 'CreateHelper.pas',
  ExPopupList in 'ExPopupList.pas',
  PlaylistToUSB in 'PlaylistToUSB.pas' {PlaylistCopyForm},
  ErrorForm in 'ErrorForm.pas' {FError},
  BasicSettingsWizard in 'BasicSettingsWizard.pas' {Wizard},
  cddaUtils in 'cddaUtils.pas',
  CDSelection in 'CDSelection.pas' {FormCDDBSelect},
  CDOpenDialogs in 'CDOpenDialogs.pas' {CDOpenDialog},
  DeleteHelper in 'DeleteHelper.pas',
  DeleteSelect in 'DeleteSelect.pas' {DeleteSelection},
  CustomizedScrobbler in 'CustomizedScrobbler.pas',
  Votings in 'Votings.pas',
  WebServerLog in 'WebServerLog.pas' {WebServerLogForm},
  SilenceDetection in 'SilenceDetection.pas',
  Lowbattery in 'Lowbattery.pas' {FormLowBattery}
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF}
  ;
//,  classes;

{$R *.res}

var EVILHACKX, EVILHACKY: INTEGER;



begin

    ReportMemoryLeaksOnShutdown := False;

    Application.Initialize;


    //Application.MainFormOnTaskBar := True;
{
SetWindowLong mit Application.handle funktioniert, wenn MainFormOnTaskbar = False;
Ist das True, funktioniert es mit MainForm.Handle
Aber, mit "richtigem handle" funktioniert das Win7-Gedöns nicht mehr!!!!
=> Unter WIN 7 die TASKLEISTE IN RUHE LASSEN!!!

Mit MainForm.handle funktioniert das Splash- gedöns nicht mehr!! und Win 7

suchen nach SetWindowLong
ShowWindow
 }

  {$IFDEF USESTYLES}
    TStyleManager.Engine.RegisterStyleHook(TNemp_MainForm, TFormStyleHookFix);
  {$ENDIF}

  Application.CreateForm(TNemp_MainForm, Nemp_MainForm);
  Graphics.DefFontData.Name := 'Tahoma';

    Application.Title := NEMP_NAME_TASK;
    Application.Name  := NEMP_NAME;

    // Show Mainform, but beyond all visible area
    Nemp_MainForm.Top := 10000;
    Nemp_MainForm.Visible := True;
    Nemp_MainForm.Top := 10000;

    Application.CreateForm(TFSplash, FSplash);
//X//    FSplash.Show;
//X//    FSplash.Update;

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

    if (Nemp_MainForm.NempOptions.StartMinimized) or (Nemp_MainForm.NempOptions.StartMinimizedByParameter) then
    begin
        // DAS HIER DIENT DEM VERSTECKEN, NICHT DEM ANZEIGEN
       PostMessage(Nemp_MainForm.FOwnMessageHandler, WM_Command, COMMAND_RESTORE, 0);
    end;

    FSplash.Visible := False;

    RunWizard;

    Application.Run;

end.
