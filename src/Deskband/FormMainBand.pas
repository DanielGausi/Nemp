unit FormMainBand;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SHDocVw_TLB, ExtCtrls, StdCtrls, XPMan,
  NempApi, Menus,  ImgList, 
  TaskbarStuff, System.ImageList;

type
  TNempDeskBand = class(TForm)
    XPManifest1: TXPManifest;
    Img_Back: TImage;
    Img_next: TImage;
    Img_Play: TImage;
    Img_Vol: TImage;
    Img_Playlist: TImage;
    Image1: TImage;
    PlaylistPopup: TPopupMenu;
    Img_Search: TImage;
    Img_Stop: TImage;
    Img_Nemp: TImage;
    ImageList1: TImageList;
    procedure Img_BackClick(Sender: TObject);
    procedure Img_nextClick(Sender: TObject);
    procedure Img_PlayClick(Sender: TObject);
    procedure Img_VolClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PlaylistPopupPopup(Sender: TObject);
    procedure SuchImageClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Img_PlaylistClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Img_StopClick(Sender: TObject);
    procedure Img_NempClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ReOrderControls;
    procedure UpdateForm(wParam, lParam: Integer);
  private

  public

    procedure PlaylistMenuClick(Sender: TObject);
  protected

  end;

var
  NempDeskBand: TNempDeskBand;

implementation

{$R *.dfm}

uses unitNempDeskBand, VolumeUnit, InfoUnit, SearchUnit, PlaylistUnit;

{ TNempMainBand }


procedure TNempDeskBand.Img_BackClick(Sender: TObject);
begin
  NempPlayPrev;
  if assigned(PlaylistForm) And PlaylistForm.Visible then
    PlaylistForm.QuickAndDirtyTimer.Enabled := True;
end;

procedure TNempDeskBand.Img_nextClick(Sender: TObject);
begin
  NempPlayNext;
  if assigned(PlaylistForm) And PlaylistForm.Visible then
    PlaylistForm.QuickAndDirtyTimer.Enabled := True;
end;

procedure TNempDeskBand.Img_PlayClick(Sender: TObject);
begin
  if GetNempState = NEMP_API_PLAYING then
  begin
    NempPause;
    ImageList1.GetBitmap(1, Img_Play.Picture.Bitmap);
  end
  else
  begin
    NempPlay;
    ImageList1.GetBitmap(0, Img_Play.Picture.Bitmap);
  end;
  Img_Play.Invalidate;
end;

procedure TNempDeskBand.Img_VolClick(Sender: TObject);
begin
  if not assigned(VolumeForm) then
    VolumeForm := TVolumeForm.Create(self);

  VolumeForm.ReOrderControls;
  if GetTaskbarPosition in [tbTop, tbBottom] then
  begin
    VolumeForm.Left := Clienttoscreen(Point(Img_Vol.Left,0)).X - VolumeForm.Width;
    VolumeForm.Top := Clienttoscreen(Point( 0,0 )).Y;
  end else
  begin
    VolumeForm.Left := Clienttoscreen(Point( 0,0 )).X;
    VolumeForm.Top := Clienttoscreen(Point(0,Img_Vol.Top)).Y - VolumeForm.Height;
  end;
  VolumeForm.show;
end;

procedure TNempDeskBand.FormCreate(Sender: TObject);
begin
  Clientheight := 22;
  ClientWidth := 180;
end;

procedure TNempDeskBand.PlaylistPopupPopup(Sender: TObject);
var i: Integer;
  centerIdx, minIdx, maxIdx, PlaylistMax: Integer;
  aMenuItem: TMenuItem;
begin
  // altes Menu mit Playlist-Einträgen erstellen und neues erstellen
  for i := PlaylistPopup.Items.Count - 1 downto 0 do
    PlaylistPopup.Items.Delete(i);

  PlaylistMax := GetNempPlayListLength;
  centerIdx := GetNempPlayListPos;

  // min Idx Count.halbe vor dem aktuellen Lied
  minIdx := centerIdx - (30 DIV 2);
  // ggf. auf 0 korrigieren
  if MinIDX < 0 then MinIdx := 0;

  // maxIdx Count mehr
  maxIdx := minIdx + 30;
  if MaxIdx > PlaylistMax then MaxIdx := PlaylistMax - 1;

  // ggf. den minIdx korrigieren, so dass immer count Einträge da sind
  minIdx := maxIdx - 30;
  if minIdx < 0 then minIdx := 0;

  for i := MinIdx to MaxIdx do
  begin
        aMenuItem := TMenuItem.Create(self);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.RadioItem := True;
        aMenuItem.AutoCheck := True;
        aMenuItem.Checked := (i=centerIdx);
        aMenuItem.OnClick := PlaylistMenuClick;
        aMenuItem.Tag := i;
        aMenuItem.Caption := GetNempPlaylistTitel(i);
        PlaylistPopup.Items.Add(aMenuItem);
  end;
end;

procedure TNempDeskBand.PlaylistMenuClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    SetNempPlayListPos((Sender as TMenuItem).Tag);
end;


procedure TNempDeskBand.SuchImageClick(Sender: TObject);
begin
  if assigned(InfoForm) And InfoForm.Visible then InfoForm.Close;
  if assigned(PlaylistForm) And PlaylistForm.Visible then PlaylistForm.Close;

  if not assigned(SuchForm) then
    SuchForm := TSuchform.Create(self);

  SuchForm.parentform := Self;
  SuchForm.show;
end;

procedure TNempDeskBand.Image1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if     (assigned(Suchform) AND Suchform.Visible)
      OR (assigned(PlaylistForm) AND PlaylistForm.Visible)
  then
    exit;

  if not assigned(InfoForm) then
    InfoForm := TInfoForm.Create(self);
  InfoForm.parentform := self;
  InfoForm.show;
end;

procedure TNempDeskBand.Img_PlaylistClick(Sender: TObject);
begin
  if assigned(InfoForm) And InfoForm.Visible then InfoForm.Close;
  if assigned(SuchForm) And SuchForm.Visible then SuchForm.Close;

  if not assigned(PlaylistForm) then
    PlaylistForm := TPlaylistForm.Create(self);
  PlaylistForm.parentform := Self;
  PlaylistForm.show;
end;

procedure TNempDeskBand.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if assigned(InfoForm) then InfoForm.Free;
  if Assigned(SuchForm) then SuchForm.Free;
  if assigned(VolumeForm) then VolumeForm.Free;
  if assigned(PlaylistForm) then PlaylistForm.Free;
end;

procedure TNempDeskBand.Img_StopClick(Sender: TObject);
begin
  NempStop;
  ImageList1.GetBitmap(1, Img_Play.Picture.Bitmap);
  Img_Play.Invalidate;
end;

procedure TNempDeskBand.Img_NempClick(Sender: TObject);
var hwndNemp, hwndDeskband: THandle;
begin
    hwndNemp := FindWindow(PChar(WINDOW_NAME),nil);
    if hwndNemp = 0 then
    begin
        hwndDeskband :=  FindWindow('Shell_TrayWnd', nil);
        hwndDeskband :=  FindWindowEx(hwndDeskband, 0, 'ReBarWindow32', nil);
        hwndDeskband :=  FindWindowEx(hwndDeskband, 0, 'TNempDeskBand', Nil);
        SendMessage(hwndDeskband, NempDeskbandDeActivateMessage, GetCurrentThreadId, 0);
    end
    else
        SendMessage(hwndNemp, WM_COMMAND, COMMAND_RESTORE, 0);  //NempRestore;
end;

procedure TNempDeskBand.ReOrderControls;
begin
  if GetTaskbarPosition in [tbTop, tbBottom] then
  begin
      // Form waagerecht befüllen
      Constraints.MaxHeight := 22;
      Constraints.MinHeight := 22;
      Constraints.MaxWidth := 178;
      Constraints.MinWidth := 178;
      ClientHeight := 22;
      ClientWidth   := 178;
      Img_Nemp.Top  := 3;
      Img_Nemp.Left := 6;
      Img_Stop.Top  := 4;
      Img_Stop.Left := 32;
      Img_Back.Top  := 4;
      Img_Back.Left := 48;
      Img_Play.Top  := 2;
      Img_Play.Left := 66;
      Img_next.Top  := 4;
      Img_next.Left := 87;
      Img_Vol .Top  :=  4;
      Img_Vol .Left := 105;
      Img_Playlist .Top  := 4;
      Img_Playlist .Left := 140;
      Img_Search   .Top  := 4;
      Img_Search   .Left := 156;
  end else
  begin
      //Senkrechte Form
      Constraints.MaxHeight := 178;
      Constraints.MinHeight := 178;
      Constraints.MaxWidth := 22;
      Constraints.MinWidth := 22;
      ClientWidth := 22;
      ClientHeight := 178;
      Img_Nemp.Left := 3;
      Img_Nemp.Top  := 6;
      Img_Stop.Left := 4;
      Img_Stop.Top  := 32;
      Img_Back.Left := 4;
      Img_Back.Top  := 48;
      Img_Play.Left := 2;
      Img_Play.Top  := 66;
      Img_next.Left := 4;
      Img_next.Top  := 87;
      Img_Vol .Left :=  4;
      Img_Vol .Top  := 105;
      Img_Playlist .Left := 4;
      Img_Playlist .Top  := 140;
      Img_Search   .Left := 4;
      Img_Search   .Top  := 156;
  end;

  If Assigned(PlaylistForm) then
      PlaylistForm.CorrectPosition;
  if Assigned(SuchForm) then
      Suchform.CorrectPosition;
  if Assigned(InfoForm) then
      infoForm.CorrectPosition;
  if Assigned(VolumeForm) then
      VolumeForm.ReOrderControls;
      
end;
       
procedure TNempDeskBand.FormShow(Sender: TObject);
begin

  ReOrderControls;
  
  if GetNempState = NEMP_API_PLAYING then
  begin
    ImageList1.GetBitmap(0, Img_Play.Picture.Bitmap);
  end
  else
  begin
    ImageList1.GetBitmap(1, Img_Play.Picture.Bitmap);
  end;
  Img_Play.Invalidate;
end;

procedure TNempDeskBand.UpdateForm(wParam, lParam: Integer);
begin
  case wparam of
    NEMP_API_STOPPED, NEMP_API_PAUSED: ImageList1.GetBitmap(1, Img_Play.Picture.Bitmap);
    NEMP_API_PLAYING: ImageList1.GetBitmap(0, Img_Play.Picture.Bitmap);
  end;
  Img_Play.Invalidate;

  if assigned(PlaylistForm) and PlaylistForm.Visible then
      PlaylistForm.UpdatePlaylistFiles;
end;

end.
