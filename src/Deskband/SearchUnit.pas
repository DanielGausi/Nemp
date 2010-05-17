unit SearchUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, NempApi, Menus, XPMan, TaskBarStuff;

type
  TSuchForm = class(TForm)
    SearchEdit: TEdit;
    CloseImage2: TImage;
    SearchTimer: TTimer;
    PopupMenu1: TPopupMenu;
    Einfgen1: TMenuItem;
    Einfgen2: TMenuItem;
    Alsnchstesabspielen1: TMenuItem;
    Jetztabspiuelen1: TMenuItem;
    NempVoreinstellung1: TMenuItem;
    XPManifest1: TXPManifest;
    LblSearchCount: TLabel;
    Image3: TImage;
    Image2: TImage;
    Image1: TImage;
    ImgBack: TImage;
    ImgNext: TImage;
    procedure FormCreate(Sender: TObject);
    procedure CorrectPosition;
    procedure FormShow(Sender: TObject);
    procedure HideTimerTimer(Sender: TObject);
    procedure SearchEditKeyPress(Sender: TObject; var Key: Char);
    Procedure SearchListItemClick(Sender: TObject);
    procedure SearchTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CloseImage2Click(Sender: TObject);

    procedure ShowSearchResults(Start, Ende: Integer);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnPrevClick(Sender: TObject);
    procedure NempVoreinstellung1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    parentform: TForm;
  end;

  

var
  SuchForm: TSuchForm;
  FileList: TStringlist;
  InsertMode: Integer = 0;

implementation

{$R *.dfm}

uses InfoUnit;

procedure TSuchForm.ShowSearchResults(Start, Ende: Integer);
var TitelLabel, ArtistLabel, TimeLabel, AlbumLabel: TLabel;
  i: Integer;
  OFFSET, gesHeight: Integer;
  SearchCount: Integer;
  oldHeight: Integer;
  aStyle: TFontStyles;
  newFilename: WideString;

begin
  OFFSET := 4;
  gesHeight := 50;
  oldHeight := ClientHeight;

  SearchCount := GetNempSearchListLength;

  ImgBack.Visible := True;
  ImgNext.Visible := True;

  ImgBack.Enabled := Start > 0;
  ImgBack.Tag := Start;
  ImgNext.Enabled := Ende < SearchCount -1;
  ImgNext.Tag := Ende;

  for i := ComponentCount - 1 downto 0 do
    if (Components[i] is TLabel) AND (Components[i] <> LblSearchCount) then
      Components[i].Free;

  FileList.Clear;

  if SearchCount = 0 then
  begin
    LblSearchCount.Caption := 'Keine Treffer.';
    ClientHeight := 50;
  end
  else
  begin
    LblSearchCount.Caption := 'Ergebnisse ' + IntToStr(Start+1) + ' bis ' + IntToStr(Ende+1) + ' von ' + IntToStr(SearchCount);
    ClientHeight := gesHeight*(Ende-Start + 1) + 16 + 20 + 8;
  end;

  if GetTaskbarPosition <> tbTop then
    Top := Top - (ClientHeight - oldHeight);

  // evtl. notwendige Korrekturen
  if Top < 0 then Top := 0;
  // Und
  if Top + Height > Screen.Height then
    Top := Screen.Height - Height;

  for i := Start to Ende do
  begin
    newFilename := GetNempSearchListFileNameW(i);
    FileList.Add(newFilename);

    if FileExists(newFilename) then
      astyle := []
    else aStyle := [fsStrikeOut];

    TitelLabel := TLabel.Create(self);
    with TitelLabel do
    begin
      ShowAccelChar := False;
      Parent := SuchForm;
      Font.Style := {[fsBold] + }aStyle;
      Font.Color := $00EFEFEF;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4;
      Top := (i-Start) * gesHeight + OFFSET;
      Width := SuchForm.Width - 8;
      Caption := GetNempSearchListTitleOnlyW(i);
      Tag := i - Start;
      OnDblClick := SearchListItemClick;
    end;
    ArtistLabel := TLabel.Create(SuchForm);
    with ArtistLabel do
    begin
      ShowAccelChar := False;
      Parent := SuchForm;
      Font.Style := aStyle;
      Font.Color := $00999999;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4;
      Top := (i-Start) * gesHeight + 13 + OFFSET;
      Width := SuchForm.Width - 8 - 32 ;
      Caption := GetNempSearchlistArtistW(i);
      Tag := i - Start;
      OnDblClick := SearchListItemClick;
    end;
    TimeLabel := TLabel.Create(SuchForm);
    with TimeLabel do
    begin
      ShowAccelChar := False;
      Parent := SuchForm;
      Font.Style := aStyle;
      Font.Color := $00999999;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4 + ArtistLabel.Width;
      Top := (i-Start) * gesHeight + 13 + OFFSET;
      Width := 32;
      Caption := SekIntToMinStr(GetNempSearchlistTrackLength(i));//  '3:23'; // GetNempSearchListTitel(i);
      Tag := i - Start;
      Alignment := taRightJustify;
      OnDblClick := SearchListItemClick;
    end;

    AlbumLabel := TLabel.Create(SuchForm);
    with AlbumLabel do
    begin
      ShowAccelChar := False;
      Parent := SuchForm;
      Font.Style := aStyle;
      Font.Color := $00999999;
      Transparent := True;
      AutoSize := False;
      Height := 13;
      Left := 4 ;
      Top := (i-Start) * gesHeight + 2*13 + OFFSET;
      Width := SuchForm.width - 8;
      Caption := GetNempSearchlistAlbumW(i);
      Tag := i - Start;
      OnDblClick := SearchListItemClick;
    end;
  end;

end;

procedure TSuchForm.FormCreate(Sender: TObject);
begin
  FileList := tStringlist.Create;
end;

procedure TSuchForm.CorrectPosition;
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

procedure TSuchForm.FormShow(Sender: TObject);
var i: Integer;
begin
  SetWindowLong(Handle, GWL_ExStyle, WS_EX_TOOLWINDOW);
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  Height := 50;
  LblSearchCount.Caption := 'Suchbegriff eingeben:';

  CorrectPosition;

  for i := ComponentCount - 1 downto 0 do
    if (Components[i] is TLabel) AND (Components[i] <> LblSearchCount) then
      Components[i].Free;

  ImgBack.Visible := False;
  ImgNext.Visible := False;
  ImgBack.Enabled := False;
  ImgNext.Enabled := False;
end;

procedure TSuchForm.HideTimerTimer(Sender: TObject);
begin
  close;
end;

procedure TSuchForm.SearchEditKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = VK_RETURN then
  begin
    key := #0;
    LblSearchCount.Caption := 'Suche...';
    Nemp_SendSearchStringW(Handle, SearchEdit.Text);
    SearchTimer.Enabled := True;
  end;
end;

Procedure TSuchForm.SearchListItemClick(Sender: TObject);
begin
  if Sender is TLabel then
  begin
    if FileList.Count > (Sender as TLabel).Tag then
    begin
      Nemp_SendFileForPlaylistW(Handle, FileList.Strings[(Sender as TLabel).Tag], InsertMode);
    end;
  end;
end;

procedure TSuchForm.SearchTimerTimer(Sender: TObject);
var maxW : integer;
begin
  if Nemp_GetSearchStatus = 1 then
  begin
    SearchTimer.Enabled := False;

    maxW := GetNempSearchListLength;
    if maxW < 0 then exit;
    if maxW > 10 then maxW := 10;

    ShowSearchResults(0, maxW-1);
  end;
end;


procedure TSuchForm.FormDestroy(Sender: TObject);
begin
  FileList.Free;
end;

procedure TSuchForm.CloseImage2Click(Sender: TObject);
begin
  close;
end;

procedure TSuchForm.BtnNextClick(Sender: TObject);
var maxW: Integer;
  Start, Ende: Integer;
begin
  MaxW := GetNempSearchListLength;
  Start := ImgNext.Tag +1;

  Ende := ImgNext.Tag + 11;
  if Ende > MaxW then Ende := MaxW;
  ShowSearchResults(Start, Ende-1);

end;

procedure TSuchForm.BtnPrevClick(Sender: TObject);
var maxW: Integer;
  Start, Ende: Integer;
begin
  MaxW := GetNempSearchListLength;
  Start := ImgBack.Tag - 10;
  if Start < 0 then Start := 0;
  Ende := ImgBack.Tag;
  if Ende > MaxW then Ende := MaxW;
  ShowSearchResults(Start, Ende-1);
end;

procedure TSuchForm.NempVoreinstellung1Click(Sender: TObject);
begin
  If Sender is TMenuItem then
    InsertMode := (Sender as TMenuItem).Tag;
end;

end.
