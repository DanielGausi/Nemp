{

    Unit ProgressUnit
    Form ProgressFormLibrary
         ProgressFormPlaylist

    A Progress Form for longer operations like
    getting Lyrics, Refreshing the Library and some more.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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

unit ProgressUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls, VCL.Themes,
  gnuGettext, Nemp_RessourceStrings, Nemp_ConstantsAndTypes;

type

  TJobType = (jt_WorkingPlaylist, jt_WorkingLibrary, jt_Idle);

  TProgressForm = class(TForm)

    MainProgressBar: TProgressBar;
    LblMain: TLabel;
    lblCurrentItem: TLabel;
    LblSuccessCount: TLabel;
    lblFailCount: TLabel;

    BtnCancel: TButton;
    MainImage: TImage;
    ImgFail: TImage;
    ImgOk: TImage;

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

    fCurrentVisibleJobType: TJobType;

    procedure LoadImage(aFilename: String);
  public
    { Public declarations }
    // can be set to TRUE to automatically close the window (like during AutoScan on startup)
    AutoClose: Boolean;

    procedure FinishProcess(aJobType: TJobType);
    procedure InitiateProcess(ShowImages: Boolean; aAction: TEProgressActions);

    procedure ShowWarning;
  end;

var
  ProgressFormLibrary: TProgressForm;
  ProgressFormPlaylist: TProgressForm;


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
              if self.fCurrentVisibleJobType = jt_WorkingPlaylist then
              begin
                  // stop the playlist action
                  Nemp_MainForm.ContinueWithPlaylistAdding := False;
                  NempPlaylist.ST_Ordnerlist.Clear;
                  ST_Playlist.Break;
                  // kann sein, dass der Player ab und zu mal blockiert - hier dann umsetzen ;-)
                  NempPlaylist.AcceptInput := True;
              end else
              begin
                  // stop the media library action
                  MedienBib.Abort;
                  Medienbib.ST_Ordnerlist.Clear;
                  ST_Medienliste.Break;
                  Nemp_MainForm.KeepOnWithLibraryProcess := False;
              end;
              BtnCancel.Tag := BTN_TAG_CLOSE;
        end;
    end;
end;

procedure TProgressForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := (self.fCurrentVisibleJobType = jt_Idle) or (BtnCancel.Tag = BTN_TAG_CLOSE);
end;

procedure TProgressForm.FormCreate(Sender: TObject);
var filename: String;
begin
    TranslateComponent (self);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardOk.png';
    if FileExists(filename) then
        ImgOK.Picture.LoadFromFile(filename);
    filename := ExtractFilePath(ParamStr(0)) + 'Images\WizardCancel.png';
    if FileExists(filename) then
        ImgFail.Picture.LoadFromFile(filename);

    fCurrentVisibleJobType := jt_Idle;

    //TStyleManager.Engine.RegisterStyleHook(TProgressBar, TStyleHook);
end;

procedure TProgressForm.FormShow(Sender: TObject);
var MainMonitor: TMonitor;
begin
    MainMonitor := Screen.MonitorFromWindow(Nemp_MainForm.handle);
    Top := MainMonitor.WorkareaRect.Height - height;
    Left := MainMonitor.WorkareaRect.Right - width;


    cbAutoClose.OnClick := Nil;
    self.cbAutoClose.Checked := NempOptions.AutoCloseProgressWindow or AutoClose;
    cbAutoClose.OnClick := cbAutoCloseClick;
end;

procedure TProgressForm.InitiateProcess(ShowImages: Boolean; aAction: TEProgressActions);

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

    Caption := ProgressForm_WorkingCaption;
    lblCurrentItem.Caption := '';

    BtnCancel.Tag := BTN_TAG_CANCEL;
    BtnCancel.Caption := XcmbCancel;

    cbAutoClose.Caption := MediaLibrary_OperationComplete_CBClose_NoTimer;
    CloseTimer.Enabled := False;

    if aAction = pa_SearchFilesForPlaylist then
        // special case: We have aPlaylist-Job to do (a folder has been dropped)
        fCurrentVisibleJobType := jt_WorkingPlaylist
    else
        // the media library has something to do ...
        fCurrentVisibleJobType := jt_WorkingLibrary;

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
      {pa_Searchlyrics  : begin
          LoadImage('SearchLyrics.png');
          SetLabelWithHint(ProgressForm_Searchlyrics);
      end;}
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

      pa_ScanNewFiles: begin
          LoadImage('scanFiles.png');
          SetLabelWithHint(ProgressForm_ScanNewFiles);
      end;

      pa_ScanNewPlaylistFiles: begin
          LoadImage('scanFiles.png');
          SetLabelWithHint(ProgressForm_ScanNewPlaylistFiles);
      end;

      pa_RefreshPlaylistFiles: begin
        LoadImage('Refresh.png');
        SetLabelWithHint(ProgressForm_RefreshFiles);
      end;


    end;

    Visible := True;
    self.BringToFront;
end;


procedure TProgressForm.FinishProcess(aJobType: TJobType);
begin
    self.fCurrentVisibleJobType := jt_Idle;

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
        // start the closeTimer
        CloseTimer.Tag := 5;
        cbAutoClose.Caption := Format(MediaLibrary_OperationComplete_CBClose_TimerActive, [CloseTimer.Tag]);
        CloseTimer.Enabled := True;
    end;
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
    NempOptions.AutoCloseProgressWindow := cbAutoClose.Checked;
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




end.
