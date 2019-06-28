unit ProgressUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, VCL.Themes,
  gnuGettext, Nemp_RessourceStrings, Nemp_ConstantsAndTypes;

type

  TProgressForm = class(TForm)
    MainProgressBar: TProgressBar;
    BtnCancel: TButton;
    MainImage: TImage;
    LblMain: TLabel;
    ImgFail: TImage;
    ImgOk: TImage;
    lblCurrentItem: TLabel;
    LblSuccessCount: TLabel;
    lblFailCount: TLabel;
    cbAutoClose: TCheckBox;
    CloseTimer: TTimer;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAutoCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseTimerTimer(Sender: TObject);
  private
    { Private declarations }
    procedure LoadImage(aFilename: String);
  public
    { Public declarations }
    // can be set to TRUE to automatically close the window (like during AutScan on startup)
    AutoClose: Boolean;

    procedure FinishProcess;
    procedure InitiateProcess(ShowImages: Boolean; aAction: TProgressActions=pa_Default);

    procedure ShowWarning;
  end;

var
  ProgressForm: TProgressForm;

implementation

{$R *.dfm}

uses NempMainUnit;

const BTN_TAG_CANCEL = 10;
      BTN_TAG_CLOSE = 11;

procedure TProgressForm.BtnCancelClick(Sender: TObject);
begin
    case BtnCancel.Tag of
        BTN_TAG_CLOSE: Close;
        BTN_TAG_CANCEL: begin
            Nemp_MainForm.StopMENUClick(Nil);
        end;
    end;
end;

procedure TProgressForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := MedienBib.StatusBibUpdate = 0;
end;

procedure TProgressForm.FormCreate(Sender: TObject);
var filename: String;
begin
    TranslateComponent (self);

    //filename := ExtractFilePath(ParamStr(0)) + 'Images\MetaData64.png';
    //if FileExists(filename) then
    //    MainImage.Picture.LoadFromFile(filename);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardOk.png';
    if FileExists(filename) then
        ImgOK.Picture.LoadFromFile(filename);
    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardCancel.png';
    if FileExists(filename) then
        ImgFail.Picture.LoadFromFile(filename);

    //TStyleManager.Engine.RegisterStyleHook(TProgressBar, TStyleHook);
end;

procedure TProgressForm.FormShow(Sender: TObject);
var MainMonitor: TMonitor;
begin
    MainMonitor := Screen.MonitorFromWindow(Nemp_MainForm.handle);
    Top := MainMonitor.WorkareaRect.Height - height;
    Left := MainMonitor.WorkareaRect.Right - width;


    cbAutoClose.OnClick := Nil;
    self.cbAutoClose.Checked := Nemp_MainForm.NempOptions.AutoCloseProgressWindow or AutoClose;
    cbAutoClose.OnClick := cbAutoCloseClick;
end;

procedure TProgressForm.InitiateProcess(ShowImages: Boolean; aAction: TProgressActions = pa_Default);

    procedure SetLabelWithHint(aCaption: String);
    begin
        LblMain.Caption := _(aCaption) + #13#10#13#10 + _(ProgressForm_DefaultHint);
    end;

begin
    ImgOK.Visible := ShowImages;
    ImgFail         .Visible := ShowImages;
    lblFailCount    .Visible := ShowImages;
    LblSuccessCount .Visible := ShowImages;

    MainProgressBar.Position := 0;
    lblFailCount.Caption    := '0';
    LblSuccessCount.Caption := '0';
    //LblMain.Caption := ProgressForm_DefaultAction;
    Caption := ProgressForm_WorkingCaption;
    lblCurrentItem.Caption := '';

    BtnCancel.Tag := BTN_TAG_CANCEL;
    BtnCancel.Caption := XcmbCancel;

    cbAutoClose.Caption := MediaLibrary_OperationComplete_CBClose_NoTimer;

    case aAction of
      pa_Default       : begin
            LoadImage('NempLogo.png');
            SetLabelWithHint(ProgressForm_DefaultAction);
      end;
      pa_SearchFiles   : begin
          LoadImage('SearchMusic.png');
          SetLabelWithHint(ProgressForm_SearchFiles);
      end;
      pa_SearchFilesForPlaylist: begin
          LoadImage('NempLogo.png');
          SetLabelWithHint(ProgressForm_SearchFilesPlaylist);
      end;
      pa_RefreshFiles  : begin
          LoadImage('Refresh.png');
          SetLabelWithHint(ProgressForm_RefreshFiles);
      end;
      pa_CleanUp       : begin
          LoadImage('CleanUp.png');
          SetLabelWithHint(ProgressForm_CleanUp);
      end;
      pa_Searchlyrics  : begin
          LoadImage('SearchLyrics.png');
          SetLabelWithHint(ProgressForm_Searchlyrics);
      end;
      pa_SearchTags    : begin
          LoadImage('SearchTags.png');
          SetLabelWithHint(ProgressForm_SearchTags);
      end;
      pa_UpdateMetaData: begin
          LoadImage('UpdateMetadata.png');
          SetLabelWithHint(ProgressForm_UpdateMetaData);
      end;

      pa_DeleteFiles: begin
          LoadImage('CleanUp.png');
          SetLabelWithHint(ProgressForm_DeleteFiles);
      end;

    end;

    Visible := True;
    self.BringToFront;
end;

procedure TProgressForm.LoadImage(aFilename: String);
var aPath: String;
begin
    aPath := ExtractFilePath(ParamStr(0)) + 'Images\' + aFilename;
    if FileExists(aPath) then
        MainImage.Picture.LoadFromFile(aPath)
    else
        MainImage.Picture.Assign(Nil);
end;

procedure TProgressForm.ShowWarning;
var filename: String;
begin
    filename := ExtractFilePath(ParamStr(0)) + 'Images\alert.png';
    if FileExists(filename) then
        MainImage.Picture.LoadFromFile(filename);
end;

procedure TProgressForm.cbAutoCloseClick(Sender: TObject);
begin
    // if actual User-Input: Overwrite autoclose
    Nemp_MainForm.NempOptions.AutoCloseProgressWindow := cbAutoClose.Checked;
    self.AutoClose := cbAutoClose.Checked;
    // deactivate Timer
    CloseTimer.Enabled := False;
    cbAutoClose.Caption := MediaLibrary_OperationComplete_CBClose_NoTimer;
end;

procedure TProgressForm.CloseTimerTimer(Sender: TObject);
begin
    CloseTimer.Tag := CloseTimer.Tag - 1;
    cbAutoClose.Caption := Format(MediaLibrary_OperationComplete_CBClose_TimerActive, [CloseTimer.Tag]);
    if CloseTimer.Tag <= 0 then
    begin
        CloseTimer.Enabled := False;
        close;
    end;
end;

procedure TProgressForm.FinishProcess;
begin
    lblCurrentItem.Caption := MediaLibrary_OperationComplete_CloseWindowNow ;
    Caption := ProgressForm_CompleteCaption;

    ImgOK.Visible := False;
    ImgFail         .Visible := False;
    lblFailCount    .Visible := False;
    LblSuccessCount .Visible := False;

    BtnCancel.Tag := BTN_TAG_CLOSE;
    BtnCancel.Caption := XcmbOK;

    if cbAutoClose.Checked or AutoClose then
    begin
        // set AutoClose to False again
        AutoClose := False;
        // close the window
        //Close;
        // start the closeTimer
        CloseTimer.Tag := 5;
        cbAutoClose.Caption := Format(MediaLibrary_OperationComplete_CBClose_TimerActive, [CloseTimer.Tag]);
        CloseTimer.Enabled := True;
    end;
end;


end.
