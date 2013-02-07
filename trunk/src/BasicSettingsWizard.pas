unit BasicSettingsWizard;

interface

{$I xe.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, gnuGettext, Nemp_SkinSystem, MyDialogs
  ;

const
    //WIZ_SHOW_AGAIN     = 41;
    WIZ_CURRENT_VERSION = 42;

    WIZ_CURRENT_SKINVERSION = 46;

type


  TWizard = class(TForm)
    pc_Wizard: TPageControl;
    TabSheet1: TTabSheet;
    Lbl_Welcome: TLabel;
    st_Introduction: TStaticText;
    ImgWelcome: TImage;
    Lbl_Version: TLabel;
    BtnContinue: TButton;
    BtnCancel: TButton;
    TabSheet2: TTabSheet;
    Lbl_CheckUpdates: TLabel;
    st_Updates: TStaticText;
    Lbl_QeryUpdate: TLabel;
    BtnUpdateYes: TButton;
    BtnUpdateNo: TButton;
    ImageUpdate: TImage;
    BtnUpdateBack: TButton;
    TabSheet3: TTabSheet;
    Btn_MetaBack: TButton;
    ImageMetaData: TImage;
    Btn_MetaYes: TButton;
    Lbl_QueryMetadata: TLabel;
    st_Metadata: TStaticText;
    Btn_MetaNo: TButton;
    Lbl_SaveMetadata: TLabel;
    TabSheet4: TTabSheet;
    ImageRating: TImage;
    Lbl_Rating: TLabel;
    st_Rating: TStaticText;
    Lbl_QueryRating: TLabel;
    Btn_AutoBack: TButton;
    Btn_AutoNo: TButton;
    Btn_AutoYes: TButton;
    TabSheet5: TTabSheet;
    ImageLastFM: TImage;
    Lbl_LastFM: TLabel;
    st_LastFM: TStaticText;
    Lbl_QueryLastFM: TLabel;
    Btn_LastFMBack: TButton;
    Btn_LastFMNo: TButton;
    Btn_LastFMYes: TButton;
    TabSheet7: TTabSheet;
    ImgSummary: TImage;
    Lbl_summary: TLabel;
    Lbl_QuerySummary: TLabel;
    Btn_CompleteBack: TButton;
    Btn_CompleteCancel: TButton;
    Btn_CompleteOK: TButton;
    TabSheet6: TTabSheet;
    ImageFiletypes: TImage;
    Lbl_Filetypes: TLabel;
    Lbl_QueryFiletypes: TLabel;
    st_filetypes: TStaticText;
    Btn_FiletypesBack: TButton;
    Btn_FiletypesNo: TButton;
    Btn_FiletypesYes: TButton;
    lbl_sumUpdates: TLabel;
    lbl_sumFiletypes: TLabel;
    lbl_sumLastFM: TLabel;
    lbl_sumRating: TLabel;
    lbl_sumMetadata: TLabel;
    img_sumUpdates: TImage;
    img_sumFiletypes: TImage;
    img_sumLastFM: TImage;
    img_sumMetadata: TImage;
    img_sumRating: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnContinueClick(Sender: TObject);
    procedure BtnUpdateBackClick(Sender: TObject);
    procedure BtnUpdateYesClick(Sender: TObject);
    procedure BtnUpdateNoClick(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_CompleteOKClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

  TAnswers = record
      Updates: Boolean;
      MetaData: Boolean;
      Rating: Boolean;
      LastFM: Boolean;
      FileTypes: Boolean;
  end;

var
  Wizard: TWizard;
  Answers: TAnswers;


procedure RunWizard;

implementation

{$R *.dfm}

uses NempMainUnit, Nemp_ConstantsAndTypes, SystemHelper, Nemp_RessourceStrings,
    UpdateUtils, PlayerClass, MedienBibliothekClass, filetypes;

procedure RunWizard;
begin
    if Nemp_MainForm.NempOptions.LastKnownVersion < WIZ_CURRENT_VERSION then
    begin
        // Show Wizard only if Writeaccess is possible (i.e. dont show it everytime when starting from CD/DVD)
        if Nemp_MainForm.NempOptions.WriteAccessPossible then
        begin
            if not assigned(Wizard) then
                Application.CreateForm(TWizard, Wizard);
            Wizard.Show;
        end;
    end;

    if Nemp_MainForm.NempOptions.LastKnownVersion < WIZ_CURRENT_SKINVERSION then
    begin
        if (Nemp_MainForm.SkinName <> '<public> Nemp 4.6') and  Nemp_MainForm.NempOptions.WriteAccessPossible then
        begin
          if TranslateMessageDLG((Wizard_NewSkin), mtInformation, [MBYES, MBNO], 0) = mrYES then
          begin
              Nemp_MainForm.UseSkin := True;
              Nemp_MainForm.SkinName := '<public> Nemp 4.6';
              Nemp_MainForm.ActivateSkin(ExtractFilePath(ParamStr(0)) + 'Skins\Nemp 4.6');
          end;
        end;
    end;
end;

procedure TWizard.BtnCancelClick(Sender: TObject);
begin
    //MessageDLG((WizardCancel), mtInformation, [mbOK], 0);
    Close;
end;


procedure TWizard.FormCreate(Sender: TObject);
var filename: String;

begin
    TranslateComponent (self);

    TabSheet1.TabVisible := False;
    TabSheet2.TabVisible := False;
    TabSheet3.TabVisible := False;
    TabSheet4.TabVisible := False;
    TabSheet5.TabVisible := False;
    TabSheet6.TabVisible := False;
    TabSheet7.TabVisible := False;

    filename := ExtractFilePath(ParamStr(0)) + 'Images\Wizard.png';
    if FileExists(filename) then
    begin
        ImgWelcome.Picture.LoadFromFile(filename);
        ImgSummary.Picture.LoadFromFile(filename);
    end;

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardUpate.png';
    if FileExists(filename) then
        ImageUpdate.Picture.LoadFromFile(filename);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardMetadata.png';
    if FileExists(filename) then
        ImageMetadata.Picture.LoadFromFile(filename);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardRating.png';
    if FileExists(filename) then
        ImageRating.Picture.LoadFromFile(filename);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardLastFM.png';
    if FileExists(filename) then
        ImageLastFM.Picture.LoadFromFile(filename);


    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardFiletypes.png';
    if FileExists(filename) then
        ImageFiletypes.Picture.LoadFromFile(filename);


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
end;

procedure TWizard.BtnContinueClick(Sender: TObject);
begin
    pc_Wizard.ActivePage := TabSheet2;
end;

procedure TWizard.BtnUpdateBackClick(Sender: TObject);
begin
    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex-1;
end;

procedure TWizard.BtnUpdateNoClick(Sender: TObject);
var QuestionNumber: Integer;
begin
    QuestionNumber := pc_Wizard.ActivePageIndex;
    //Showmessage(Inttostr(QuestionNumber)) ;

    case QuestionNumber of
        1: Answers.Updates   := False;
        2: Answers.Metadata  := False;
        3: Answers.Rating    := False;
        4: Answers.LastFM    := False;
        5: Answers.Filetypes := False;
    end;

    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
end;

procedure TWizard.BtnUpdateYesClick(Sender: TObject);
var QuestionNumber: Integer;
begin
    QuestionNumber := pc_Wizard.ActivePageIndex;
    //Showmessage(Inttostr(QuestionNumber));

    case QuestionNumber of
        1: Answers.Updates   := True;
        2: Answers.Metadata  := True;
        3: Answers.Rating    := True;
        4: Answers.LastFM    := True;
        5: Answers.Filetypes := True;
    end;

    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
end;


procedure TWizard.TabSheet7Show(Sender: TObject);
var fNo, fYes: String;
begin
    fYes := ExtractFilePath(ParamStr(0)) + 'Images\WizardOk.png';
    fNo  := ExtractFilePath(ParamStr(0)) + 'Images\WizardCancel.png';

    if FileExists(fYes) and FileExists(fNo) then
    begin


        if Answers.Updates then
            img_sumUpdates.Picture.LoadFromFile(fYes)
        else
            img_sumUpdates.Picture.LoadFromFile(fNo);

        if Answers.MetaData then
            img_sumMetadata.Picture.LoadFromFile(fYes)
        else
            img_sumMetadata.Picture.LoadFromFile(fNo);

        if Answers.Rating then
            img_sumRating.Picture.LoadFromFile(fYes)
        else
            img_sumRating.Picture.LoadFromFile(fNo);

        if Answers.LastFM then
            img_sumLastFM.Picture.LoadFromFile(fYes)
        else
            img_sumLastFM.Picture.LoadFromFile(fNo);

        if Answers.FileTypes then
            img_sumFiletypes.Picture.LoadFromFile(fYes)
        else
            img_sumFiletypes.Picture.LoadFromFile(fNo);
    end;
end;


procedure TWizard.Btn_CompleteOKClick(Sender: TObject);
var ftr: TFileTypeRegistration;
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

    Nemp_MainForm.NempOptions.AllowQuickAccessToMetadata  := Answers.MetaData;
    NempPlayer.PostProcessor.WriteToFiles                 := Answers.MetaData;

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
                    ftr.DeleteUserChoice(NempPlayer.ValidExtensions[i]);
                    ftr.RegisterType(NempPlayer.ValidExtensions[i], 'Nemp.AudioFile', 'Nemp Audiofile', Paramstr(0), 0);
                    ftr.DeleteSpecialSetting(NempPlayer.ValidExtensions[i]);
                end;
            end;
            // register actions
            ftr.AddHandler('open','"' +  Paramstr(0) + '" "%1"');
            ftr.AddHandler('enqueue','"' +  Paramstr(0) + '" /enqueue "%1"', (FiletypeRegistration_AudioFileEnqueue));
            ftr.SetDefaultHandler; // enqueue file as default
            ftr.AddHandler('play','"' +  Paramstr(0) + '" /play "%1"', (FiletypeRegistration_AudioFilePlay));

            // set playlistfile extensions
            ftr.RegisterType('.m3u', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            ftr.DeleteSpecialSetting('.m3u');
            ftr.RegisterType('.m3u8', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            ftr.DeleteSpecialSetting('.m3u8');
            ftr.RegisterType('.pls', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            ftr.DeleteSpecialSetting('.pls');
            ftr.RegisterType('.npl', 'Nemp.Playlist', 'Nemp Playlist', Paramstr(0), 1);
            ftr.DeleteSpecialSetting('.npl');
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

    Close;
end;

end.
