unit BasicSettingsWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

const
    //WIZ_SHOW_AGAIN     = 41;
    WIZ_CURRENT_VERSION = 42;

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
    TabSheet6: TTabSheet;
    ImageSummary: TImage;
    Lbl_summary: TLabel;
    StaticText1: TStaticText;
    Lbl_QuerySummary: TLabel;
    Btn_CompleteBack: TButton;
    Btn_CompleteCancel: TButton;
    Btn_CompleteOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnContinueClick(Sender: TObject);
    procedure BtnUpdateBackClick(Sender: TObject);
    procedure BtnUpdateYesClick(Sender: TObject);
    procedure BtnUpdateNoClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Wizard: TWizard;


procedure RunWizard;

implementation

{$R *.dfm}

uses NempMainUnit, Nemp_ConstantsAndTypes, SystemHelper, Nemp_RessourceStrings;

procedure RunWizard;
begin
    if Nemp_MainForm.NempOptions.LastKnownVersion < WIZ_CURRENT_VERSION then
    begin
        if not assigned(Wizard) then
            Application.CreateForm(TWizard, Wizard);
        Wizard.Show;
    end;

end;

procedure TWizard.BtnCancelClick(Sender: TObject);
begin
    MessageDLG((WizardCancel), mtInformation, [mbOK], 0);
    Close;
end;


procedure TWizard.FormCreate(Sender: TObject);
var filename: String;

begin
    TabSheet1.TabVisible := False;
    TabSheet2.TabVisible := False;
    TabSheet3.TabVisible := False;
    TabSheet4.TabVisible := False;
    TabSheet5.TabVisible := False;
    TabSheet6.TabVisible := False;

    filename := ExtractFilePath(ParamStr(0)) + 'Images\Wizard.png';
    if FileExists(filename) then
        ImgWelcome.Picture.LoadFromFile(filename);

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


    Lbl_Version.Caption := 'Version ' + GetFileVersionString('');

    st_Introduction.Caption := StringReplace(st_Introduction.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_Updates.Caption := StringReplace(st_Updates.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_MetaData.Caption := StringReplace(st_MetaData.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_Rating.Caption := StringReplace(st_Rating.Caption, '#13#10', #13#10, [rfReplaceAll] );
    st_LastFM.Caption := StringReplace(st_LastFM.Caption, '#13#10', #13#10, [rfReplaceAll] );


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

    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
end;

procedure TWizard.BtnUpdateYesClick(Sender: TObject);
var QuestionNumber: Integer;
begin
    QuestionNumber := pc_Wizard.ActivePageIndex;
    //Showmessage(Inttostr(QuestionNumber));

    pc_Wizard.ActivePageIndex := pc_Wizard.ActivePageIndex+1;
end;

end.
