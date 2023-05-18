unit fUpdateCleaning;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Winapi.ShellAPI, MyDialogs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCL.Themes,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList;

type
  TFormUpdateCleaning = class(TForm)
    LBFiles: TListBox;
    LBDirectories: TListBox;
    imgAlert: TImage;
    lblCaption: TLabel;
    lblMessage: TLabel;
    ImageList1: TImageList;
    BtnCleanUp: TButton;
    btnHelp: TButton;
    btnNoCleanUp: TButton;
    pnlContainer: TPanel;
    grpBoxFiles: TGroupBox;
    grpboxDirectories: TGroupBox;
    Splitter1: TSplitter;
    btnOpenDirectory: TButton;
    pnlButtons: TPanel;
    btnClose: TButton;
    procedure LBFilesDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOpenDirectoryClick(Sender: TObject);
    procedure BtnCleanUpClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private-Deklarationen }
    function ShowOutdatedElements: Integer;
  public
    { Public-Deklarationen }
  end;

var
  FormUpdateCleaning: TFormUpdateCleaning;

ResourceString
  rsDlgCleanupIncomplete = 'Some of the files or directories could not be deleted. You can try to remove them manually or reinstall Nemp.';
  rsDlgCleanupComplete = 'The deletion of the files that are no longer needed was successful. You can now continue to use Nemp as before.';

  rsMessageCleanupRecommended = 'With this new version of Nemp, some changes have been implemented, making some files and directories obsolete. It is recommended to delete these files to avoid possible inconsistencies. For more information click on "Help".';
  rsMessageCleanupCompleted = 'With this new version of Nemp, some changes have been implemented, making some files and directories obsolete. However, there are no files left that should be deleted. Everything is ok.';

  rsCaptionCleanupRecommended = 'Update: Cleanup recommended';
  rsCaptionCleanupCompleted =  'Update: No clean up necessary';



implementation

uses Nemp_ConstantsAndTypes, NempHelp, UpdateCleaning, gnugettext;

{$R *.dfm}


procedure TFormUpdateCleaning.FormCreate(Sender: TObject);
var
  filename: String;
begin
  HelpContext := HELP_UpdateCleanup;
  TranslateComponent(self);
  filename := ExtractFilePath(ParamStr(0)) + 'Images\CleanUp.png';
  if FileExists(filename) then
    imgAlert.Picture.LoadFromFile(filename);
end;

procedure TFormUpdateCleaning.FormShow(Sender: TObject);
begin
  NempOptions.LastUpdateCleaningCheck := cCurrentCleanUpdate;
  if ShowOutdatedElements = 0 then begin
    lblCaption.Caption := rsCaptionCleanupCompleted;
    lblMessage.Caption := rsMessageCleanupCompleted;
    NempOptions.LastUpdateCleaningSuccess := cCurrentCleanUpdate;
    BtnCleanUp.Enabled := False;
    btnNoCleanUp.Enabled := False;
  end else
  begin
    lblCaption.Caption := rsCaptionCleanupRecommended;
    lblMessage.Caption := rsMessageCleanupRecommended;
    BtnCleanUp.Enabled := True;
    btnNoCleanUp.Enabled := True;
  end;
end;

function TFormUpdateCleaning.ShowOutdatedElements: Integer;
begin
  LBFiles.Items.BeginUpdate;
  LBDirectories.Items.BeginUpdate;
  try
    ListOutdatedFiles(LBFiles.Items);
    ListOutdatedDirectories(LBDirectories.Items);
  finally
    LBFiles.Items.EndUpdate;
    LBDirectories.Items.EndUpdate;
  end;
  result := LBFiles.Items.Count + LBDirectories.Items.Count;
end;

procedure TFormUpdateCleaning.BtnCleanUpClick(Sender: TObject);
begin
  DeleteOutdatedFiles;
  DeleteOutdatedDirectories;

  if ShowOutdatedElements = 0 then begin
    TranslateMessageDLG(rsDlgCleanupComplete, mtInformation, [MBOK], 0);
    NempOptions.LastUpdateCleaningSuccess := cCurrentCleanUpdate;
    Close;
  end else begin
    TranslateMessageDLG(rsDlgCleanupIncomplete, mtWarning, [MBOK], 0);
    BtnCleanUp.Enabled := True;
    btnNoCleanUp.Enabled := True;
  end;
end;

procedure TFormUpdateCleaning.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormUpdateCleaning.btnOpenDirectoryClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open' ,'explorer.exe', PCHAR('"'+ExtractFilePath(ParamStr(0))+'"'), '', sw_ShowNormal)
end;

procedure TFormUpdateCleaning.btnHelpClick(Sender: TObject);
begin
  Application.HelpContext(HELP_UpdateCleanup);
end;
procedure TFormUpdateCleaning.LBFilesDrawItem(Control: TWinControl;
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

end.
