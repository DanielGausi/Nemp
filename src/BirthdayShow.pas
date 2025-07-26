{

    Unit BirthdayShow
    Form TBirthdayForm

    Little form showing on "Birthday"

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

unit BirthdayShow;

interface

uses
  Windows, Messages, SysUtils,  Classes,  Forms,
  StdCtrls, Controls, gnuGettext, Vcl.ExtCtrls, Vcl.ComCtrls, NempTrackBar,
  Vcl.VirtualImage, dmGui, NempSkinnedTrackbar, NempPanel,
  NempAudioFiles, PlayerClass;

type
  TBirthdayForm = class(TForm)
    LblExplain: TLabel;
    imgParty: TVirtualImage;
    viVolume: TVirtualImage;
    rbVolume: TProgressRangeBar;
    pnlControlSlider: TNempPanel;
    PlayerTimeLbl: TLabel;
    rbTrackProgress: TProgressRangeBar;
    lblTitle: TLabel;
    BassTimer: TTimer;
    LblCountdown: TLabel;
    PageControlMode: TPageControl;
    tsCountDown: TTabSheet;
    tsBirthday: TTabSheet;
    Label1: TLabel;
    grpBoxControls: TGroupBox;
    CBContinueAfter: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rbVolumeScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure rbVolumeMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure rbVolumeMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure viVolumeClick(Sender: TObject);
    procedure BassTimerTimer(Sender: TObject);
    procedure PlayerTimeLblClick(Sender: TObject);
    procedure rbTrackProgressScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure rbTrackProgressEndScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton);
    procedure rbTrackProgressStep(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure CBContinueAfterClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure RefreshVolumeGui;

    procedure OnBirthdayPlay(Sender: TNempPlayer; aAudioFile: TAudioFile);
    procedure OnNempSkinChanged(Sender: TObject);

  public
    { Public-Deklarationen }

  end;

var
  BirthdayForm: TBirthdayForm;

implementation

uses
  NempMainUnit, MainFormHelper, AudioDisplayUtils, Nemp_ConstantsAndTypes,
  Nemp_SkinSystem;
{$R *.dfm}


procedure TBirthdayForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  NempSkin.OnSkinChanged.Add(OnNempSkinChanged);
end;

procedure TBirthdayForm.FormDestroy(Sender: TObject);
begin
  NempSkin.OnSkinChanged.Delete(OnNempSkinChanged);
end;

procedure TBirthdayForm.FormShow(Sender: TObject);
begin
  viVolume.ImageCollection := NempSkin.DefaultIconCollection;

  CBContinueAfter.Checked := NempPlayer.AutoResumePlaylistAfterBirthday;

  PageControlMode.Pages[0].TabVisible := False;
  PageControlMode.Pages[1].TabVisible := False;

   SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
   // default volume here: MainVolume
   NempPlayer.BirthdayVolume := NempPlayer.Volume;
   RefreshVolumeGui;
   NempPlayer.OnBirthdayPlay := OnBirthdayPlay;

   if NempPlayer.NempBirthdayTimer.UseCountDown then
     NempPlayer.PlayCountDown
   else
     NempPlayer.PlayBirthday;
end;

procedure TBirthdayForm.CBContinueAfterClick(Sender: TObject);
begin
  NempPlayer.AutoResumePlaylistAfterBirthday := CBContinueAfter.Checked;
end;

procedure TBirthdayForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  NempPlayer.OnBirthdayPlay := Nil;
  NempPlayer.AbortBirthday;
  ReArrangeToolImages;
end;

// Volume
procedure TBirthdayForm.RefreshVolumeGui;
begin
  if rbVolume.ScrollingButton <> btnTrack then
    rbVolume.Progress := NempPlayer.BirthdayVolume/100;

  if (NempPlayer.BirthdayVolume <= 0.05) then
    viVolume.ImageName := cBtnVolumeMute
  else begin
    if NempPlayer.BirthdayVolume >= 50 then
      viVolume.ImageName := cBtnVolumeHigh
    else
      viVolume.ImageName := cBtnVolumeLow
  end;
end;


procedure TBirthdayForm.rbVolumeMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  NempPlayer.BirthdayVolume := NempPlayer.BirthdayVolume - 1;
  RefreshVolumeGui;
end;

procedure TBirthdayForm.rbVolumeMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  NempPlayer.BirthdayVolume := NempPlayer.BirthdayVolume + 1;
  RefreshVolumeGui;
end;

procedure TBirthdayForm.rbVolumeScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  if ScrollButton = btnTrack then
    NempPlayer.BirthdayVolume := ScrollPos;
end;

procedure TBirthdayForm.viVolumeClick(Sender: TObject);
begin
  if NempPlayer.BirthdayVolume <= 0.05 then
    NempPlayer.BirthdayVolume := 10
  else
    NempPlayer.BirthdayVolume := 0;
  RefreshVolumeGui;
end;

// Title information
procedure TBirthdayForm.OnBirthdayPlay(Sender: TNempPlayer;
  aAudioFile: TAudioFile);
begin
  lblTitle.Caption := NempDisplay.PlaylistTitle(aAudioFile, False);

  case NempPlayer.CurrentBirthdayMode of
    bmCountDown: begin
      PageControlMode.ActivePageIndex := 0;

    end;

    bmBirthday: begin
      PageControlMode.ActivePageIndex := 1;

    end;
  end;

end;


procedure TBirthdayForm.OnNempSkinChanged(Sender: TObject);
begin
  viVolume.ImageCollection := NempSkin.DefaultIconCollection;
end;

// Progress
procedure TBirthdayForm.BassTimerTimer(Sender: TObject);
var
  intTime: Integer;
begin
  if NempPlayer.BassBirthdayStatus <> BASS_ACTIVE_PLAYING then begin
    playerTimeLbl.Caption := '00:00';
    rbTrackProgress.Progress := 0;
  end else begin
    if rbTrackProgress.ScrollingButton = btnNone then
      playerTimeLbl.Caption := NempPlayer.TimeStringBirthday; //RefreshTimeLabel(NempPlayer.BirthdayProgress, NempPlayer.TimeInSecBirthday);
    if rbTrackProgress.ScrollingButton <> btnTrack then
      rbTrackProgress.Progress := NempPlayer.BirthdayProgress;
  end;

  if NempPlayer.CurrentBirthdayMode = bmCountDown then begin
    intTime := round(NempPlayer.BirthdayDauer - Nempplayer.BirthdayTime + 0.5);
    LblCountDown.Caption := intTime.ToString;
  end;

end;



procedure TBirthdayForm.PlayerTimeLblClick(Sender: TObject);
begin
  NempPlayer.TimeMode := (NempPlayer.TimeMode + 1) Mod 2;
end;

procedure TBirthdayForm.rbTrackProgressScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  PlayerTimeLbl.Caption := NempPlayer.GeBirthdayTimeStringFromProgress(ScrollPosNorm);
end;

procedure TBirthdayForm.rbTrackProgressStep(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  if ScrollButton = btnTrack then
    NempPlayer.BirthdayProgress := ScrollPosNorm;
  PlayerTimeLbl.Caption := NempPlayer.GeBirthdayTimeStringFromProgress(ScrollPosNorm);
end;

procedure TBirthdayForm.rbTrackProgressEndScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton);
begin
  if ScrollButton = btnTrack then
    NempPlayer.BirthdayProgress := Sender.Progress;
end;

end.
