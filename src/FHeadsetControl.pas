unit FHeadsetControl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NempSkinnedTrackbar, Vcl.StdCtrls, Winapi.ActiveX, WinApi.ShellApi,
  SkinButtons, NempDragFiles, Vcl.ExtCtrls, Vcl.VirtualImage, NempAudioFiles, dmGUI,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.Menus;

type
  TFormHeadsetControl = class(TForm)
    rbHeadsetTrack: TProgressRangeBar;
    rbVolume: TProgressRangeBar;
    BtnMute: TSkinButton;
    pnlBars: TPanel;
    HeadsetTimer: TTimer;
    HeadsetTimeLbl: TLabel;
    PlayPauseHeadSetBtn: TSkinButton;
    StopHeadSetBtn: TSkinButton;
    BtnLoadHeadset: TSkinButton;
    BtnHeadsetPlaynow: TSkinButton;
    BtnHeadsetToPlaylist: TSkinButton;
    imgCover: TImage;
    pnlContainer: TPanel;
    pnlInfo: TPanel;
    PlayerTitleLabel: TLabel;
    PlayerArtistLabel: TLabel;
    vilIcons: TVirtualImageList;
    BtnHeadsetRating: TRatingButton;
    PopupHeadset: TPopupMenu;
    PM_H_EnqueueEndOfPlaylist: TMenuItem;
    PM_H_PlayAndClearPlaylist: TMenuItem;
    PM_H_EnqueueAfterCurrentTitle: TMenuItem;
    PM_H_JustPlay: TMenuItem;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure HeadsetTimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbHeadsetTrackEndScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton);
    procedure FormShow(Sender: TObject);
    procedure rbVolumeScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure rbHeadsetTrackScroll(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure rbHeadsetTrackStep(Sender: TProgressRangeBar;
      ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
    procedure imgCoverMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgCoverMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnHeadsetRatingRatingChanged(Sender: TRatingButton;
      aRating: Integer);
    procedure PlayPauseHeadSetBtnClick(Sender: TObject);
    procedure StopHeadSetBtnClick(Sender: TObject);
    procedure BtnHeadsetPlaynowClick(Sender: TObject);
    procedure BtnHeadsetToPlaylistClick(Sender: TObject);
    procedure InsertHeadsetToPlaylistClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private-Deklarationen }

    fLastPaintedTime: Integer;
    fCoverImgDownX: Integer;
    fCoverImgDownY: Integer;
    fDropManager : TNempDragManager;

    procedure OnHeadSetPlayChange(Sender: TObject);
    procedure ClearHeadSetData;
    procedure RefreshTimeLabel(aProgress: Double; aSeconds: Integer);
    procedure ShowHeadsetProgress(aProgress: Double; aSeconds: Integer);
    procedure OnHeadSetFileChanged(Sender: TObject);


    procedure OnTest1(Sender: TObject);
    procedure OnTest2(Sender: TObject);

  public
    { Public-Deklarationen }
    property DropManager : TNempDragManager read fDropManager write fDropManager;
    procedure RefreshHeadSetData;
  end;

var
  FormHeadsetControl: TFormHeadsetControl;

implementation

uses
  Nemp_RessourceStrings, PlayerClass, PlaylistClass, MedienBibliothekClass,
  AudioDisplayUtils, math, TreeHelper, AudioFileManagement;

{$R *.dfm}

procedure TFormHeadsetControl.FormCreate(Sender: TObject);
begin
  fLastPaintedTime := -1;
  OleInitialize(nil);
end;

procedure TFormHeadsetControl.FormShow(Sender: TObject);
begin
  rbVolume.Position := Round(NempPlayer.HeadSetVolume);
  NempPlayer.OnHeadSetPlay := OnHeadSetPlayChange;
  NempPlayer.OnHeadSetPause := OnHeadSetPlayChange;
  NempPlayer.OnHeadSetResume := OnHeadSetPlayChange;
  NempPlayer.OnHeadSetStop := OnHeadSetPlayChange;
  RefreshHeadSetData;
  TAudioFileManager.OnAudioFileChanged.Add(OnHeadSetFileChanged);
end;

procedure TFormHeadsetControl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  NempPlayer.StopHeadset;
  TAudioFileManager.OnAudioFileChanged.Delete(OnHeadSetFileChanged);
end;

procedure TFormHeadsetControl.FormAfterMonitorDpiChanged(Sender: TObject;
  OldDPI, NewDPI: Integer);
begin
  NempPlayer.HeadSetCoverSize := max(imgCover.Height, imgCover.Width);
  RefreshHeadSetData;
end;

procedure TFormHeadsetControl.pnlInfoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SYSCOMMAND, SC_MOVE or HTCAPTION, 0);
end;

procedure TFormHeadsetControl.BtnHeadsetRatingRatingChanged(Sender: TRatingButton;
  aRating: Integer);
var
  i: Integer;
begin
  if assigned(NempPlayer.HeadSetAudioFile) then begin
    TAudioFileManager.PrepareAudioFileChange(NempPlayer.HeadSetAudioFile);
    for i := 0 to TAudioFileManager.FilesToChange.Count - 1 do
      TAudioFileManager.FilesToChange.Items[i].Rating := aRating;
    TAudioFileManager.FinalizeAudioFileChange(NempPlayer.HeadSetAudioFile);
  end;
end;

procedure TFormHeadsetControl.HeadsetTimerTimer(Sender: TObject);
begin
  if NempPlayer.BassHeadSetStatus = BASS_ACTIVE_PLAYING then begin
    // draw visualisation
    //NempPlayer.DrawHeadsetVisualisation;
    // ... progress (Time, SlideButton)
    if rbHeadsetTrack.ScrollingButton <> btnTrack then
      ShowHeadsetProgress(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset);
  end;
end;

procedure TFormHeadsetControl.imgCoverMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fCoverImgDownX := X;
  fCoverImgDownY := Y;
end;

procedure TFormHeadsetControl.imgCoverMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  af: TAudioFile;
  DateiListe: TAudioFileList;
begin
  if ssleft in shift then begin
    if (abs(X - fCoverImgDownX) > 5) or  (abs(Y - fCoverImgDownY) > 5) then begin
      af := NempPlayer.HeadSetAudioFile;
      if Assigned(af) then begin
        Dateiliste := TAudioFileList.Create(False);
        try
          if ssShift in shift then
            MedienBib.GetAlbumTitelListFromAudioFile(Dateiliste, af) // get all files for this "Album"
          else
            Dateiliste.Add(af); // add just the current file

          InitiateDragDrop(DateiListe, imgCover, DropManager, True, False);
        finally
          FreeAndNil(Dateiliste);
        end;
      end;
    end;
  end
  else begin
    fCoverImgDownX := 0;
    fCoverImgDownY := 0;
  end;
end;

procedure TFormHeadsetControl.rbHeadsetTrackScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  if ScrollButton = btnTrack then
    HeadsetTimeLbl.Caption := NempPlayer.GetHeadsetTimeStringFromProgress(ScrollPosNorm);
end;

procedure TFormHeadsetControl.rbHeadsetTrackEndScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton);
begin
  if ScrollButton = btnTrack then
    NempPlayer.HeadsetProgress := Sender.Progress;
end;

procedure TFormHeadsetControl.rbHeadsetTrackStep(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  if ScrollButton = btnTrack then begin
    NempPlayer.HeadsetProgress := ScrollPosNorm;
    RefreshTimeLabel(NempPlayer.HeadsetProgress, NempPlayer.TimeInSecHeadset);
  end;
end;

procedure TFormHeadsetControl.rbVolumeScroll(Sender: TProgressRangeBar;
  ScrollButton: teScrollButton; ScrollPos: Integer; ScrollPosNorm: Double);
begin
  if ScrollButton = btnTrack then
    NempPlayer.HeadSetVolume := ScrollPos;
end;

procedure TFormHeadsetControl.OnHeadSetPlayChange(Sender: TObject);
begin
  RefreshHeadSetData;
end;

procedure TFormHeadsetControl.ClearHeadSetData;
begin
  imgCover.Picture.Assign(NempPlayer.HeadsetPicture);
  PlayerArtistLabel.Caption := Player_NoTitleLoaded;
  PlayerTitleLabel.Caption  := '';
  BtnHeadsetRating.Visible := False;
end;

procedure TFormHeadsetControl.RefreshHeadSetData;
begin
  if not assigned(NempPlayer.HeadSetAudioFile) then begin
    ClearHeadSetData;
    exit;
  end;

  imgCover.Picture.Assign(NempPlayer.HeadsetPicture);
  PlayerArtistLabel.Caption := NempDisplay.PlayerLine1(NempPlayer.HeadSetAudioFile, Nil);
  PlayerTitleLabel.Caption  := NempDisplay.PlayerLine2(NempPlayer.HeadSetAudioFile, Nil);
  BtnHeadsetRating.Visible := True;
  BtnHeadsetRating.Rating := NempPlayer.HeadSetAudioFile.Rating;
end;

procedure TFormHeadsetControl.RefreshTimeLabel(aProgress: Double; aSeconds: Integer);
begin
  if fLastPaintedTime <> aSeconds then begin
    HeadsetTimeLbl.Caption := NempPlayer.TimeStringHeadset;
    fLastPaintedTime := aSeconds;
  end;
end;

procedure TFormHeadsetControl.ShowHeadsetProgress(aProgress: Double;
  aSeconds: Integer);
begin
  rbHeadsetTrack.Progress := aProgress;
  RefreshTimeLabel(aProgress, aSeconds);
end;

procedure TFormHeadsetControl.PlayPauseHeadSetBtnClick(Sender: TObject);
begin
  // play current Headset-Track again
  case NempPlayer.BassHeadSetStatus of
    BASS_ACTIVE_PAUSED  : NempPlayer.resumeHeadset;
    BASS_ACTIVE_STOPPED : NempPlayer.PlayInHeadset(nil);
    BASS_ACTIVE_PLAYING : NempPlayer.PauseHeadset;
  end;
end;

procedure TFormHeadsetControl.StopHeadSetBtnClick(Sender: TObject);
begin
  NempPlayer.StopHeadset;
end;

procedure TFormHeadsetControl.BtnHeadsetPlaynowClick(Sender: TObject);
var
  newPlaylistFile: TAudioFile;
begin
  if assigned(NempPlayer.HeadSetAudioFile) then begin
    newPlaylistFile := TAudioFile.Create;
    newPlaylistFile.Assign(NempPlayer.HeadSetAudioFile);
    NempPlaylist.PlayHeadsetFile(newPlaylistFile, NempPlayer.FadingInterval, NempPlayer.HeadsetTime);
  end;
end;

procedure TFormHeadsetControl.BtnHeadsetToPlaylistClick(Sender: TObject);
begin
  HandleInsertHeadsetToPlaylist(NempPlaylist.HeadSetAction);
end;

procedure TFormHeadsetControl.Button1Click(Sender: TObject);
begin
  TAudioFileManager.OnAudioFileChanged.Add(OnTest1);
  TAudioFileManager.OnAudioFileChanged.Add(OnTest2);

  TAudioFileManager.FinalizeAudioFileChange(NempPlayer.HeadSetAudioFile)
end;

procedure TFormHeadsetControl.Button2Click(Sender: TObject);
begin
  TAudioFileManager.OnAudioFileChanged.Delete(OnTest2);

  TAudioFileManager.FinalizeAudioFileChange(NempPlayer.HeadSetAudioFile)
end;

procedure TFormHeadsetControl.InsertHeadsetToPlaylistClick(Sender: TObject);
begin
  HandleInsertHeadsetToPlaylist((Sender as TMenuItem).Tag);
end;

procedure TFormHeadsetControl.OnHeadSetFileChanged(Sender: TObject);
var
  aFile: TAudioFile;
begin
  if (Sender is TAudioFile) then begin
    aFile := TAudioFile(Sender);
    if TAudioFileManager.SameFile(aFile, NempPlayer.HeadSetAudioFile) then
      RefreshHeadSetData;
  end;
end;


procedure TFormHeadsetControl.OnTest1(Sender: TObject);
begin
  ShowMEssage(TAudioFileManager.OnAudioFileChanged.Count.ToString +  ' Artist ' + TAudioFile(Sender).Artist);
end;

procedure TFormHeadsetControl.OnTest2(Sender: TObject);
begin
  ShowMEssage(TAudioFileManager.OnAudioFileChanged.Count.ToString + ' Titel ' + TAudioFile(Sender).Titel);
end;

end.
