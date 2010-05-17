unit PlaylistUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, NempApi, TaskbarStuff;

type
  TPlaylistForm = class(TForm)
    Image3: TImage;
    Image2: TImage;
    Image1: TImage;
    CloseImage2: TImage;
    ImgBack: TImage;
    ImgNext: TImage;
    QuickAndDirtyTimer: TTimer;
    Label1: TLabel;
    procedure CloseImage2Click(Sender: TObject);
    procedure CorrectPosition;
    procedure FormShow(Sender: TObject);
    procedure ShowPlaylistFiles(start, Ende: Integer);
    procedure UpdatePlaylistFiles;
    procedure LabelClick(Sender: TObject);
    procedure ImgNextClick(Sender: TObject);
    procedure ImgBackClick(Sender: TObject);
    procedure QuickAndDirtyTimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    currentMin: Integer;
    currentMax: Integer;
  public
    { Public-Deklarationen }
    parentform: TForm;
  end;

var
  PlaylistForm: TPlaylistForm;

implementation

uses  InfoUnit;

{$R *.dfm}

procedure TPlaylistForm.CloseImage2Click(Sender: TObject);
begin
  close;
end;

procedure TPlaylistForm.ShowPlaylistFiles(start, Ende: Integer);
var TitelLabel, ArtistLabel, TimeLabel: TLabel;
  i: Integer;
  OFFSET, gesHeight: Integer;
  PlaylistCount: Integer;
  oldHeight: Integer;
  aStyle: TFontStyles;
  newFilename: String;
  PlayingIndex: Integer;

begin
  OFFSET := 4;
  gesHeight := 35;

  oldHeight := ClientHeight;

  PlaylistCount := GetNempPlaylistLength;
  PlayingIndex := GetNempPlayListPos;

  ImgBack.Visible := True;
  ImgNext.Visible := True;

  ImgBack.Enabled := Start > 0;
  ImgBack.Tag := Start;
  ImgNext.Enabled := Ende < PlaylistCount -1;
  ImgNext.Tag := Ende;

  for i := ComponentCount - 1 downto 0 do
    if (Components[i] is TLabel) AND (Components[i] <> Label1) then
      Components[i].Free;


  if PlaylistCount = 0 then
  begin
    Label1.Caption := 'Keine Titel in der Playlist';
    ClientHeight := 30;
  end
  else
  begin
    Label1.Caption := IntToStr(Start+1) + ' - ' + IntToStr(Ende+1) + ' (' + IntToStr(PlaylistCount)+ ')';
    ClientHeight := gesHeight*(Ende-Start + 1) + 8 + 20;
  end;

  if GetTaskbarPosition <> tbTop then
    Top := Top - (ClientHeight - oldHeight);

  // evtl. notwendige Korrekturen
  if Top < 0 then Top := 0;
  // Und
  if Top + Height > Screen.Height then
    Top := Screen.Height - Height;

  currentMin := Start;
  currentMax := Ende;

  for i := Start to Ende do
  begin
    newFilename := GetNempPlayListFileNameW(i);

    if FileExists(newFilename) or (pos('://', newFilename) > 0) then
      astyle := []
    else aStyle := [fsStrikeOut];

    TitelLabel := TLabel.Create(self);
    with TitelLabel do
    begin
      ShowAccelChar := False;
      Parent := PlaylistForm;
      Font.Style := {[fsBold] + }aStyle;
      if i=PlayingIndex then
        Font.Color := clred
      else
        Font.Color := $00EFEFEF;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4;
      Top := (i-Start) * gesHeight + OFFSET;
      Width := PlaylistForm.Width - 8;
      Caption := GetNempPlayListTitleOnlyW(i);
      Tag := i;
      OnDblClick := LabelClick;
    end;
    ArtistLabel := TLabel.Create(self);
    with ArtistLabel do
    begin
      ShowAccelChar := False;
      Parent := PlaylistForm;
      Font.Style := aStyle;
      Font.Color := $00999999;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4;
      Top := (i-Start) * gesHeight + 13 + OFFSET;
      Width := PlaylistForm.Width - 8 - 32 ;
      Caption := GetNempPlaylistArtistW(i);
      Tag := i;
      OnDblClick := LabelClick;
    end;
    TimeLabel := TLabel.Create(self);
    with TimeLabel do
    begin
      ShowAccelChar := False;
      Parent := PlaylistForm;
      Font.Style := aStyle;
      Font.Color := $00999999;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4 + ArtistLabel.Width;
      Top := (i-Start) * gesHeight + 13 + OFFSET;
      Width := 32;
      Caption := SekIntToMinStr(GetNempPlaylistTrackLength(i));
      Tag := i;
      Alignment := taRightJustify;
      OnDblClick := LabelClick;
    end;
  end;
end;

procedure TPlaylistForm.UpdatePlaylistFiles;
var centerIdx,  PlaylistMax: Integer;
begin

  PlaylistMax := GetNempPlayListLength;
  if PlaylistMax < CurrentMax then
      CurrentMax := PlaylistMax;

  centerIdx := GetNempPlayListPos;
  if (centerIdx >= CurrentMin) and (centerIdx <= CurrentMax) then
  begin
      ShowPlaylistFiles(CurrentMin, CurrentMax)
  end;

    {
  // min Idx Count.halbe vor dem aktuellen Lied
  minIdx := centerIdx - (20 DIV 2);
  // ggf. auf 0 korrigieren
  if MinIDX < 0 then MinIdx := 0;

  // maxIdx Count mehr
  maxIdx := minIdx + 20;
  if MaxIdx >= PlaylistMax then MaxIdx := PlaylistMax;

  // ggf. den minIdx korrigieren, so dass immer count Einträge da sind
  minIdx := maxIdx - 20;
  if minIdx < 0 then minIdx := 0;

  ShowPlaylistFiles(minIdx, maxIdx-1);   }

end;

procedure TPlaylistForm.LabelClick(Sender: TObject);
begin
  if Sender is TLabel then
  begin
    QuickAndDirtyTimer.Tag := (Sender as TLabel).Tag;
    QuickAndDirtyTimer.Enabled := True;
  end;
end;                     

procedure TPlaylistForm.CorrectPosition;
begin
  case GetTaskbarPosition of
    tbBottom: begin
      Left := parentform.Clienttoscreen(Point(0,0)).X;

      Top := parentform.Clienttoscreen(Point( 0,0)).Y - Height;
      Width := parentform.Width;
    end;

    tbTop: begin
      Left := parentform.Clienttoscreen(Point(0,0)).X;
      Top := parentform.Clienttoscreen(Point( 0,0 )).Y + parentform.Height;
      Width := parentform.Width;
    end;

    tbLeft: begin
      Left := parentform.Clienttoscreen(Point(0,0)).X + parentform.Width;
      Top := parentform.Clienttoscreen(Point( 0,0 )).Y
                - (Height - Parentform.Height);
      Width := parentform.Height;
    end;

    tbRight: begin
      Left := parentform.Clienttoscreen(Point(0,0)).X - parentform.Height;
      Top := parentform.Clienttoscreen(Point( 0,0 )).Y
                - (Height - Parentform.Height);
      Width := parentform.Height;
    end;
  end;

  // evtl. notwendige Korrekturen
  if Top < 0 then Top := 0;
  // Und
  if Top + Height > Screen.Height then
    Top := Screen.Height - Height;

end;

procedure TPlaylistForm.FormShow(Sender: TObject);
var i: Integer;
  centerIdx, minIdx, maxIdx, PlaylistMax: Integer;
begin
  SetWindowLong(Handle, GWL_ExStyle, WS_EX_TOOLWINDOW);
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

  Height := 50;
  CorrectPosition;

  for i := ComponentCount - 1 downto 0 do
    if (Components[i] is TLabel) AND (Components[i] <> Label1) then
      Components[i].Free;

  PlaylistMax := GetNempPlayListLength;
  centerIdx := GetNempPlayListPos;

  // min Idx Count.halbe vor dem aktuellen Lied
  minIdx := centerIdx - (20 DIV 2);
  // ggf. auf 0 korrigieren
  if MinIDX < 0 then MinIdx := 0;

  // maxIdx Count mehr
  maxIdx := minIdx + 20;
  if MaxIdx >= PlaylistMax then MaxIdx := PlaylistMax;

  // ggf. den minIdx korrigieren, so dass immer count Einträge da sind
  minIdx := maxIdx - 20;
  if minIdx < 0 then minIdx := 0;

  ShowPlaylistFiles(minIdx, maxIdx-1);
end;

procedure TPlaylistForm.ImgNextClick(Sender: TObject);
var maxW: Integer;
  Start, Ende: Integer;
begin
  MaxW := GetNempPlayListLength;
  Start := ImgNext.Tag + 1;

  Ende := ImgNext.Tag + 21;
  if Ende > MaxW then Ende := MaxW;
  ShowPlaylistFiles(Start, Ende-1);
end;


procedure TPlaylistForm.ImgBackClick(Sender: TObject);
var maxW: Integer;
  Start, Ende: Integer;
begin
  MaxW := GetNempPlayListLength;
  Start := ImgBack.Tag - 20;
  if Start < 0 then Start := 0;
  Ende := ImgBack.Tag;
  if Ende > MaxW then Ende := MaxW;
  ShowPlaylistFiles(Start, Ende-1);
end;


procedure TPlaylistForm.QuickAndDirtyTimerTimer(Sender: TObject);
begin
  QuickAndDirtyTimer.Enabled := False;

  SetNempPlayListPos((Sender as TTimer).Tag);
  // Liste aktualisieren
//  ShowPlaylistFiles(ImgBack.Tag, ImgNext.Tag);
end;

end.
