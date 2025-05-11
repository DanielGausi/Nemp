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
  gnuGettext, Nemp_RessourceStrings, Nemp_ConstantsAndTypes, Vcl.VirtualImage;

type

  TJobType = (jt_WorkingPlaylist, jt_WorkingLibrary, jt_Idle);

  TProgressForm = class(TForm)

    MainProgressBar: TProgressBar;
    LblMain: TLabel;
    lblCurrentItem: TLabel;
    LblSuccessCount: TLabel;
    lblFailCount: TLabel;

    BtnCancel: TButton;
    MainImage: TVirtualImage;
    ImgFail: TVirtualImage;
    ImgOk: TVirtualImage;

    cbAutoClose: TCheckBox;
    CloseTimer: TTimer;
    pnlButtons: TPanel;
    pnlProgress: TPanel;
    pnlHeader: TPanel;
    pnlImage: TPanel;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbAutoCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fCurrentVisibleJobType: TJobType;

  public
    { Public declarations }
    // can be set to TRUE to automatically close the window (like during AutoScan on startup)
    AutoClose: Boolean;

    procedure ShowWarning;
    procedure FinishProcess(aJobType: TJobType);
    procedure InitiateProcess(ShowImages: Boolean; aAction: TEProgressActions);
  end;

  function ProgressFormLibrary: TProgressForm;
  function ProgressFormPlaylist: TProgressForm;

implementation

{$R *.dfm}

uses NempMainUnit, MedienbibliothekClass, PlaylistClass, dmGui;

const BTN_TAG_CANCEL = 10;
      BTN_TAG_CLOSE = 11;

var
  fProgressFormLibrary: TProgressForm;
  fProgressFormPlaylist: TProgressForm;

function ProgressFormLibrary: TProgressForm;
begin
  if not assigned(fProgressFormLibrary) then
    Application.CreateForm(TProgressForm, fProgressFormLibrary);
  result := fProgressFormLibrary
end;

function ProgressFormPlaylist: TProgressForm;
begin
  if not assigned(fProgressFormPlaylist) then
    Application.CreateForm(TProgressForm, fProgressFormPlaylist);
  result := fProgressFormPlaylist
end;

procedure TProgressForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  fCurrentVisibleJobType := jt_Idle;
  //TStyleManager.Engine.RegisterStyleHook(TProgressBar, TStyleHook);
end;

procedure TProgressForm.FormDestroy(Sender: TObject);
begin
  if self = fProgressFormLibrary then
    fProgressFormLibrary := Nil;

  if self = fProgressFormPlaylist then
    fProgressFormPlaylist := Nil;
end;

procedure TProgressForm.FormShow(Sender: TObject);
var
  MainMonitor: TMonitor;
begin
  MainMonitor := Screen.MonitorFromWindow(Nemp_MainForm.handle);
  Top := MainMonitor.WorkareaRect.Height - height;
  Left := MainMonitor.WorkareaRect.Right - width;

  cbAutoClose.OnClick := Nil;
  cbAutoClose.Checked := NempOptions.AutoCloseProgressWindow or AutoClose;
  cbAutoClose.OnClick := cbAutoCloseClick;
end;

procedure TProgressForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
end;

procedure TProgressForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (fCurrentVisibleJobType = jt_Idle) or (BtnCancel.Tag = BTN_TAG_CLOSE);
end;

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
          MainImage.ImageName := cImgNempLogo;
          SetLabelWithHint(ProgressForm_DefaultAction);
      end;
      pa_SearchFiles   : begin
          MainImage.ImageName := cImgSearchMusic;
          SetLabelWithHint(ProgressForm_SearchFiles);
      end;
      pa_SearchFilesForPlaylist: begin
          MainImage.ImageName := cImgNempLogo;
          SetLabelWithHint(ProgressForm_SearchFilesPlaylist);
      end;
      pa_RefreshFiles  : begin
          MainImage.ImageName := cImgRefresh;
          SetLabelWithHint(ProgressForm_RefreshFiles);
      end;
      pa_CleanUp       : begin
          MainImage.ImageName := cImgCleanUp;
          SetLabelWithHint(ProgressForm_CleanUp);
      end;
      {pa_Searchlyrics  : begin
          LoadImage('SearchLyrics.png');
          SetLabelWithHint(ProgressForm_Searchlyrics);
      end;}
      pa_SearchTags    : begin
          MainImage.ImageName := cImgSearchTags;
          SetLabelWithHint(ProgressForm_SearchTags);
      end;
      pa_UpdateMetaData: begin
          MainImage.ImageName := cImgWizardMetadata;
          SetLabelWithHint(ProgressForm_UpdateMetaData);
      end;

      pa_DeleteFiles: begin
          MainImage.ImageName := cImgCleanUp;
          SetLabelWithHint(ProgressForm_DeleteFiles);
      end;

      pa_ScanNewFiles: begin
          MainImage.ImageName := cImgScanFiles;
          SetLabelWithHint(ProgressForm_ScanNewFiles);
      end;

      pa_ScanNewPlaylistFiles: begin
          MainImage.ImageName := cImgScanFiles;
          SetLabelWithHint(ProgressForm_ScanNewPlaylistFiles);
      end;

      pa_RefreshPlaylistFiles: begin
        MainImage.ImageName := cImgRefresh;
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

procedure TProgressForm.ShowWarning;
begin
  MainImage.ImageName := cImgAlert;
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

initialization

  fProgressFormLibrary  := Nil;
  fProgressFormPlaylist := Nil;

end.
