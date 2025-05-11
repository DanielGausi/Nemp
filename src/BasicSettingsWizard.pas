{

    Unit BasicSettingsWizard
    Form Wizard

    * A Settings Wizard for some basic settings, which are
      quite useful, but OPT-IN

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
unit BasicSettingsWizard;

interface

{$I xe.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, gnuGettext, Nemp_SkinSystem, MyDialogs,
  MainFormHelper, NempHelp, Vcl.VirtualImage ;

const
    //WIZ_SHOW_AGAIN     = 41;
    WIZ_CURRENT_VERSION = 42;
    WIZ_CURRENT_SKINVERSION = 46;
    // WIZ_CURRENT_TAGSVERSION = 50;

type


  TWizard = class(TForm)
    pc_Wizard: TPageControl;
    TabSheet1: TTabSheet;
    Lbl_Welcome: TLabel;
    st_Introduction: TLabel;
    ImgWelcome: TVirtualImage;
    Lbl_Version: TLabel;
    TabSheet2: TTabSheet;
    Lbl_CheckUpdates: TLabel;
    st_Updates: TLabel;
    Lbl_QeryUpdate: TLabel;
    ImageUpdate: TVirtualImage;
    TabSheet3: TTabSheet;
    ImageMetaData: TVirtualImage;
    Lbl_QueryMetadata: TLabel;
    st_Metadata: TLabel;
    Lbl_SaveMetadata: TLabel;
    TabSheet4: TTabSheet;
    ImageRating: TVirtualImage;
    Lbl_Rating: TLabel;
    st_Rating: TLabel;
    Lbl_QueryRating: TLabel;
    TabSheet5: TTabSheet;
    ImageLastFM: TVirtualImage;
    Lbl_LastFM: TLabel;
    st_LastFM: TLabel;
    Lbl_QueryLastFM: TLabel;
    TSSummary: TTabSheet;
    ImgSummary: TVirtualImage;
    Lbl_summary: TLabel;
    Lbl_QuerySummary: TLabel;
    TabSheet6: TTabSheet;
    ImageFiletypes: TVirtualImage;
    Lbl_Filetypes: TLabel;
    Lbl_QueryFiletypes: TLabel;
    st_filetypes: TLabel;
    lbl_sumUpdates: TLabel;
    lbl_sumFiletypes: TLabel;
    lbl_sumLastFM: TLabel;
    lbl_sumRating: TLabel;
    lbl_sumMetadata: TLabel;
    img_sumUpdates: TVirtualImage;
    img_sumFiletypes: TVirtualImage;
    img_sumLastFM: TVirtualImage;
    img_sumMetadata: TVirtualImage;
    img_sumRating: TVirtualImage;
    pnlButtons: TPanel;
    BtnBack: TButton;
    BtnNo: TButton;
    BtnYes: TButton;
    LblProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnUpdateBackClick(Sender: TObject);
    procedure BtnUpdateYesClick(Sender: TObject);
    procedure BtnUpdateNoClick(Sender: TObject);
    procedure TSSummaryShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure RefreshNavigation;
    procedure ApplyWizardSettings;
  public
    { Public-Deklarationen }
  end;



var
  Wizard: TWizard;



procedure RunWizard;

implementation

{$R *.dfm}

uses NempMainUnit, Nemp_ConstantsAndTypes, SystemHelper, Nemp_RessourceStrings,
    UpdateUtils, PlayerClass, MedienBibliothekClass, filetypes, UpdateCleaning,
    fUpdateCleaning, dmGui;

resourcestring
  rsBtnNo = 'No';
  rsBtnYes = 'Yes';
  rsBtnOk = 'Ok';
  rsBtnContinue = 'Continue';
  rsBtnCancel = 'Cancel';

type
  TAnswers = record
    Updates: Boolean;
    MetaData: Boolean;
    Rating: Boolean;
    LastFM: Boolean;
    FileTypes: Boolean;
  end;

var
  Answers: TAnswers;

procedure RunWizard;
var
  WizardShown: Boolean;
begin
    WizardShown := False;
    if NempOptions.LastKnownVersion < WIZ_CURRENT_VERSION then
    begin
        // Show Wizard only if Writeaccess is possible (i.e. dont show it everytime when starting from CD/DVD)
        if NempSettingsManager.WriteAccessPossible then
        begin
            if not assigned(Wizard) then
                Application.CreateForm(TWizard, Wizard);
            WizardShown := True;
            Wizard.Show;
        end;
    end;

    if (NempOptions.LastKnownVersion < WIZ_CURRENT_SKINVERSION) then
    begin
        if (NempOptions.SkinName <> 'Dark') and  NempSettingsManager.WriteAccessPossible then
        begin
          if TranslateMessageDLG((Wizard_NewSkin), mtInformation, [MBYES, MBNO], 0) = mrYES then
          begin
              NempOptions.UseSkin := True;
              NempOptions.SkinName := 'Dark';
              Nemp_MainForm.ActivateSkin(ExtractFilePath(ParamStr(0)) + 'Skins\Dark');
              SetSkinRadioBox(NempOptions.SkinName);
          end;
        end;
    end;

    if not WizardShown then begin // do NOT show both dialogs, Wizard and UdateCleaner
      if (NempOptions.LastUpdateCleaningCheck < cCurrentCleanUpdate) and NempSettingsManager.WriteAccessPossible then begin
        // There has been no Check so far: Its the first start after the Update
        NempOptions.LastUpdateCleaningCheck := cCurrentCleanUpdate;
        if (CountOutDatedFiles + CountOutDatedDirectories = 0) then
          // everything is ok, obsolete files have been deleted by setup
          NempOptions.LastUpdateCleaningSuccess := cCurrentCleanUpdate
        else begin
          if not assigned(FormUpdateCleaning) then
              Application.CreateForm(TFormUpdateCleaning, FormUpdateCleaning);
            FormUpdateCleaning.Show;
        end;
      end;
    end;

    //if (NempOptions.LastKnownVersion < WIZ_CURRENT_TAGSVERSION) and (NempOptions.LastKnownVersion > 0) then begin
    //  if NempSettingsManager.WriteAccessPossible then
    //    TranslateMessageDLG((Wizard_NewTags), mtInformation, [MBOK], 0)
end;

procedure TWizard.BtnCancelClick(Sender: TObject);
begin
    Close;
end;


procedure TWizard.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  HelpContext := HELP_Wizard;
  for var i: Integer := 0 to pc_Wizard.PageCount - 1 do
    pc_Wizard.Pages[i].TabVisible := False;

  Lbl_Version.Caption := 'Version ' + GetFileVersionString('');
  pc_Wizard.ActivePage := TabSheet1;
  {$IFDEF USESTYLES}
  // UnskinForm(self);
  {$ENDIF}
end;

procedure TWizard.FormShow(Sender: TObject);
begin
    st_Introduction.Caption := StringReplace(st_Introduction.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_Updates.Caption := StringReplace(st_Updates.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_MetaData.Caption := StringReplace(st_MetaData.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_Rating.Caption := StringReplace(st_Rating.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_LastFM.Caption := StringReplace(st_LastFM.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_Filetypes.Caption := StringReplace(st_Filetypes.Caption, '#13#10', #13#10, [rfReplaceAll] );
    pc_Wizard.ActivePage := TabSheet1;
    RefreshNavigation;
end;

procedure TWizard.RefreshNavigation;
begin
  LblProgress.Visible := pc_Wizard.ActivePageIndex >= 1;
  LblProgress.Caption := pc_Wizard.ActivePageIndex.ToString + '/6';

  BtnBack.Visible := pc_Wizard.ActivePageIndex >= 1;

  case pc_Wizard.ActivePageIndex of
    0: begin
      BtnNo.Caption := rsBtnCancel;
      BtnYes.Caption := rsBtnContinue;
    end;
    6: begin
      BtnNo.Caption := rsBtnCancel;
      BtnYes.Caption := rsBtnOk;
    end;
    else begin
      BtnNo.Caption := rsBtnNo;
      BtnYes.Caption := rsBtnYes;
    end;
  end;
end;

procedure TWizard.BtnUpdateBackClick(Sender: TObject);
begin
    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex-1;
    RefreshNavigation;
end;

procedure TWizard.BtnUpdateNoClick(Sender: TObject);
begin
  case pc_Wizard.ActivePageIndex of
    0: Close;
    1: Answers.Updates   := False;
    2: Answers.Metadata  := False;
    3: Answers.Rating    := False;
    4: Answers.LastFM    := False;
    5: Answers.Filetypes := False;
    6: Close;
  end;

  pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
  RefreshNavigation;
end;

procedure TWizard.BtnUpdateYesClick(Sender: TObject);
begin
  case pc_Wizard.ActivePageIndex of
    1: Answers.Updates   := True;
    2: Answers.Metadata  := True;
    3: Answers.Rating    := True;
    4: Answers.LastFM    := True;
    5: Answers.Filetypes := True;
    6: begin
      ApplyWizardSettings;
      Close;
    end;
  end;

  pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
  RefreshNavigation;
end;

procedure TWizard.TSSummaryShow(Sender: TObject);

  function GetImgName(aAnswer: Boolean): String;
  begin
    if aAnswer then
      result := cMenuOk
    else
      result := cMenuCancel;
  end;

begin
  img_sumUpdates.ImageName := GetImgName(Answers.Updates);
  img_sumMetadata.ImageName := GetImgName(Answers.MetaData);
  img_sumRating.ImageName := GetImgName(Answers.Rating);
  img_sumLastFM.ImageName := GetImgName(Answers.LastFM);
  img_sumFiletypes.ImageName := GetImgName(Answers.FileTypes);
end;

procedure TWizard.ApplyWizardSettings;
var
  ftr: TFileTypeRegistration;
  i: integer;
begin
  NempUpdater.AutoCheck  := Answers.Updates;
    if Answers.Updates then
    begin
        // subsettings to default
        NempUpdater.CheckInterval := 7;
        NempUpdater.NotifyOnBetas := False;
        NempUpdater.LastCheck := 0;
    end;

    NempOptions.AllowQuickAccessToMetadata  := Answers.MetaData;
    NempPlayer.PostProcessor.WriteToFiles   := Answers.MetaData;

    NempPlayer.PostProcessor.Active := Answers.Rating;
    if Answers.Rating then
    begin
          // subsettings to default
          NempPlayer.PostProcessor.IgnoreShortFiles := True;
          NempPlayer.PostProcessor.ChangeCounter    := True;
          NempPlayer.PostProcessor.IncPlayedFiles   := True;
          NempPlayer.PostProcessor.DecAbortedFiles  := True;
    end;

    if MedienBib.CoverSearchLastFM <> Answers.LastFM then
    begin
        MedienBib.CoverSearchLastFM := Answers.LastFM;
        MedienBib.NewCoverFlow.ClearTextures;
    end;

    // Register filetypes
    if Answers.FileTypes then
    begin
        ftr := TFileTypeRegistration.Create;
        try
            // Set musicfile extensions
            for i := 0 to NempPlayer.ValidExtensions.Count - 1 do
            begin
                // dont register .mp4 as default. These files are playable, but
                // include more often a video file, afaik
                if NempPlayer.ValidExtensions[i] <> '.mp4' then
                begin
                    // ftr.DeleteUserChoice(NempPlayer.ValidExtensions[i]);
                    ftr.RegisterType(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', 'Nemp Audiofile', Paramstr(0), 0);
                    // ftr.DeleteSpecialSetting(NempPlayer.ValidExtensions[i]);
                end;
            end;
            // register actions
            ftr.AddHandler('open','"' +  Paramstr(0) + '" "%1"');
            ftr.AddHandler('enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_AudioFileEnqueue));
            ftr.SetDefaultHandler; // enqueue file as default
            ftr.AddHandler('play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_AudioFilePlay));

            // set playlistfile extensions
            ftr.RegisterType('.m3u', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            // ftr.DeleteSpecialSetting('.m3u');
            ftr.RegisterType('.m3u8', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            // ftr.DeleteSpecialSetting('.m3u8');
            ftr.RegisterType('.pls', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            // ftr.DeleteSpecialSetting('.pls');
            ftr.RegisterType('.npl', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            // ftr.DeleteSpecialSetting('.npl');
            // register actions
            ftr.AddHandler('open','"' +  Paramstr(0) + '" "%1"');
            ftr.AddHandler('enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_PlaylistEnqueue));
            ftr.AddHandler('play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_PlaylistPlay));
            ftr.SetDefaultHandler;  // play playlist as default

            // rightclick menu in the explorer for directories
            ftr.AddDirectoryHandler('Nemp.Enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_DirEnqueue));
            ftr.AddDirectoryHandler('Nemp.Play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_DirPlay));
        finally
            ftr.UpdateShell;
            ftr.Free;
        end;
    end;
end;

end.
