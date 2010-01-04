program nemp;

{.$R 'Nemp_Graphics.res' 'Nemp_Graphics.rc'}

// dontTouchUses  <- this tells madExcept to not touch the uses clause
// note to self: publish nemp.mes (this contains the MadExcept setting)


{$R *.dres}

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
  WinampFunctions in 'WinampFunctions.pas',
  Details in 'Details.pas' {FDetails},
  AudioFileClass in 'AudioFileClass.pas',
  NewPicture in 'NewPicture.pas' {FNewPicture},
  Splash in 'Splash.pas' {FSplash},
  spectrum_vis in 'spectrum_vis.pas',
  Hilfsfunktionen in 'Hilfsfunktionen.pas',
  TreeHelper in 'TreeHelper.pas',
  MultimediaKeys in 'MultimediaKeys.pas' {FormMediaKeyInit},
  About in 'About.pas' {AboutForm},
  StreamVerwaltung in 'StreamVerwaltung.pas' {FormStreamVerwaltung},
  Nemp_ConstantsAndTypes in 'Nemp_ConstantsAndTypes.pas',
  PlaylistUnit in 'PlaylistUnit.pas' {PlaylistForm},
  AuswahlUnit in 'AuswahlUnit.pas' {AuswahlForm},
  MedienlisteUnit in 'MedienlisteUnit.pas' {MedienlisteForm},
  SplitForm_Hilfsfunktionen in 'SplitForm_Hilfsfunktionen.pas',
  ShutDown in 'ShutDown.pas' {ShutDownForm},
  HeadsetControl in 'HeadsetControl.pas' {HeadsetControlForm},
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
  OptionsComplete in 'OptionsComplete.pas' {OptionsCompleteForm},
  VSTEditControls in 'VSTEditControls.pas',
  ClassicCoverflowClass in 'ClassicCoverflowClass.pas',
  NempCoverFlowClass in 'NempCoverFlowClass.pas',
  ExtendedControlsUnit in 'ExtendedControlsUnit.pas' {ExtendedControlForm},
  PartyModeClass in 'PartyModeClass.pas',
  NoLyricWikiApi in 'NoLyricWikiApi.pas' {NoLyricWikiApiForm},
  PostProcessorUtils in 'PostProcessorUtils.pas',
  RatingCtrls in 'RatingCtrls.pas',
  TagClouds in 'TagClouds.pas';

{$R *.res}


begin
    ReportMemoryLeaksOnShutdown := True;

    Application.Initialize;

        Graphics.DefFontData.Name := 'Tahoma';



        Application.Title := 'Nemp';
  Application.CreateForm(TNemp_MainForm, Nemp_MainForm);
  FSplash := TFSplash.Create (Application);

        try
          FSplash.Show;
          FSplash.Update;
          Nemp_MainForm.StuffToDoOnCreate;

          Application.CreateForm(TPlaylistForm   , PlaylistForm   );
          Application.CreateForm(TAuswahlForm    , AuswahlForm    );
          Application.CreateForm(TMedienlisteForm, MedienlisteForm);
          Application.CreateForm(TExtendedControlForm, ExtendedControlForm);

          Nemp_MainForm.StuffToDoAfterCreate ;

          if (Nemp_MainForm.NempOptions.StartMinimized) or (Nemp_MainForm.NempOptions.StartMinimizedByParameter) then
          begin
             Nemp_MainForm.Hide;
             Application.ShowMainForm := False;
             PostMessage(Nemp_MainForm.Handle, WM_Command, COMMAND_RESTORE, 0);
          end;


         // FSplash.Visible := False;
        finally
          //FreeAndNil(FSplash);
        end;

        Application.Run;

end.
