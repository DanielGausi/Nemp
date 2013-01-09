unit InfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, NempApi, TaskbarStuff;

type
  TInfoForm = class(TForm)
    SlideButton: TImage;
    SlideBarShape: TShape;
    CloseImage2: TImage;
    LblFileInfo: TLabel;
    LblTime: TLabel;
    Timer1: TTimer;
    HideTimer: TTimer;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    LblTitel: TLabel;
    LblArtist: TLabel;
    CoverImage: TImage;
    procedure ActualizeData;
    procedure CloseImage2Click(Sender: TObject);
    procedure CorrectPosition;
    procedure ShowCoverImage(DoShow: Boolean);

    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SlideButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SlideButtonDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SlideButtonDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HideTimerTimer(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private-Deklarationen }
    CoverPresent: Boolean;
     procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
  public
    { Public-Deklarationen }
    parentform: TForm;
  end;

  function SekIntToMinStr(sek:integer):string;

var
  InfoForm: TInfoForm;
  NempFilename: String;
  NempTrackLength: Integer;

implementation


{$R *.dfm}


function SekIntToMinStr(sek:integer):string;
begin
    result:='';
    result:=inttostr(sek DIV 60);
    sek:=sek Mod 60;
    if sek<10 then result:=result+':0'+inttostr(sek)
        else result:=result+':'+inttostr(sek)
end;

procedure TInfoForm.WMCopyData(var Msg: TWMCopyData);
var ms: TMemoryStream;
begin  
  case Msg.CopyDataStruct.dwData of  
    IPC_SENDCOVER: { Receive Image, Bild empfangen}
      begin  
        ms := TMemoryStream.Create;  
        try  
            with Msg.CopyDataStruct^ do
                ms.Write(lpdata^, cbdata);
            ms.Position := 0;
            CoverImage.Picture.Bitmap.LoadFromStream(ms);
        finally  
            ms.Free;  
        end;  
      end;  
  end;
end;


procedure TInfoForm.ActualizeData;
var NeuerFilename:WideString;
    pos : Integer;

begin
  neuerFilename := GetNempCurrentTitleW(IPC_CF_FILENAME);
  pos := GetNemp_TrackPosition;

  if (NeuerFilename <> NempFilename) then
  begin
      NempFilename := NeuerFilename;
      LblTitel.Caption := GetNempCurrentTitleW(IPC_CF_TITLEONLY); //GetNempPlaylistTitleOnlyW(-1);
      LblArtist.Caption := GetNempCurrentTitleW(IPC_CF_ARTIST);

      LblFileInfo.Caption := GetNempCurrentTitleW(IPC_CF_ALBUM); //ExtractFilename(neuerFilename);
      NempTrackLength := GetNemp_TrackLength;

      CoverPresent := Nemp_QueryCover(Handle) = 1 ;
      ShowCoverImage(CoverPresent);
      CorrectPosition;
  end;
  LblTime.Caption := SekIntToMinStr(pos DIV 1000);
  // Wenn gedraggt wird, dann nicht setzen!
  if SlideButton.Tag = 0 then
      if NempTrackLength<>0 then
          SlideButton.Left := Round(pos/NempTrackLength / 10) + SlideBarShape.Left // /1000 (wegen Millisek von Trackpos, *100 (width des Shapes))
      else
          SlideButton.Left := SlideBarShape.Left;
end;

procedure TInfoForm.ShowCoverImage(DoShow: Boolean);
begin
    if DoShow then
    begin
        CoverImage.Visible := True;
        LblTitel.Left := 88;
        LblArtist.Left := 88;
        LblFileInfo.Left := 88;
        SlideBarShape.Left := 85;
        LblTime.Left := 218;
        SlideButton.Left := SlideBarShape.Left;
    end else
    begin
        CoverImage.Visible := False;
        LblTitel.Left := 8;
        LblArtist.Left := 8;
        LblFileInfo.Left := 8;
        SlideBarShape.Left := 5;
        LblTime.Left := 138;
        SlideButton.Left := SlideBarShape.Left;
    end;
end;

procedure TInfoForm.CorrectPosition;
begin
  case GetTaskbarPosition of
    tbBottom: begin
        if CoverPresent then
        begin
            Left := parentform.Clienttoscreen(Point(0,0)).X - CoverImage.Width - 4;
            Width := parentform.Width + CoverImage.Width + 4;
        end
        else
        begin
            Left := parentform.Clienttoscreen(Point(0,0)).X;
            Width := parentform.Width;
        end;
        if Left < 0 then Left := parentform.Clienttoscreen(Point(0,0)).X;
        Top := parentform.Clienttoscreen(Point( 0,0)).Y - InfoForm.Height;
    end;

    tbTop: begin
        if CoverPresent then
        begin
            Left := parentform.Clienttoscreen(Point(0,0)).X - CoverImage.Width - 4;
            Width := parentform.Width + CoverImage.Width + 4;
        end
        else
        begin
            Left := parentform.Clienttoscreen(Point(0,0)).X;
            Width := parentform.Width;
        end;
        if Left < 0 then Left := parentform.Clienttoscreen(Point(0,0)).X;
        Top := parentform.Clienttoscreen(Point( 0,0 )).Y + parentform.Height;
    end;

    tbLeft: begin
        Left := parentform.Clienttoscreen(Point(0,0)).X + parentform.Width;
        Top := parentform.Clienttoscreen(Point( 0,0 )).Y
                  + (parentform.Height - Height) Div 2;
        if CoverPresent then
            Width := parentform.Height + CoverImage.Width + 4
        else
            Width := parentform.Height;
    end;

    tbRight: begin
        if CoverPresent then
            Width := parentform.Height + CoverImage.Width + 4
        else
            Width := parentform.Height;
        Left := parentform.Clienttoscreen(Point(0,0)).X - width;//parentform.Height;
        Top := parentform.Clienttoscreen(Point( 0,0 )).Y
                  + (parentform.Height - Height) Div 2;
    end;
  end;
end;

procedure TInfoForm.FormShow(Sender: TObject);
begin
  ShowCoverImage(CoverPresent);
  CorrectPosition;
  SetWindowLong(Handle, GWL_ExStyle, WS_EX_TOOLWINDOW);
  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
  NempFilename := '@';
  ActualizeData;
  Timer1.Enabled := True;
  HideTimer.Enabled := True;
end;



procedure TInfoForm.CloseImage2Click(Sender: TObject);
begin
  close;
  Timer1.Enabled := False;
  HideTimer.Enabled := False;
end;

procedure TInfoForm.Timer1Timer(Sender: TObject);
begin
  ActualizeData;
end;

procedure TInfoForm.SlideButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
  with SlideButton do Begindrag(false);
  ARect.TopLeft :=  (ClientToScreen(Point(SlideButton.Left, SlideButton.Top)));
  ARect.BottomRight :=  (ClientToScreen(Point(SlideButton.Left + SlideButton.Width, SlideButton.Top + SlideButton.Height)));
  SlideButton.Tag := 1;
  ClipCursor(@Arect);
  HideTimer.Enabled := False;
end;

procedure TInfoForm.SlideButtonDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
Var newpos: integer;
  AREct: TRect;
begin
  if source <> SlideButton then exit;
  NewPos := SlideButton.Left + x - 12;
  if NewPos <= SlideBarShape.Left then
      SlideButton.Left := SlideBarShape.Left
    else
      if NewPos >= SlideBarShape.Width  + SlideBarShape.Left - 25 then
        SlideButton.Left := SlideBarShape.Width + SlideBarShape.Left - 25
      else
        SlideButton.Left := NewPos;

    ARect.TopLeft :=  (ClientToScreen(Point(SlideButton.Left, SlideButton.Top)));
    ARect.BottomRight :=  (ClientToScreen(Point(SlideButton.Left + SlideButton.Width, SlideButton.Top + SlideButton.Height)));
    ClipCursor(@Arect);
end;


procedure TInfoForm.SlideButtonDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  SetNemp_TrackPosition(Round(NempTrackLength / (SlideBarShape.Width - 25) * (SlideButton.Left - SlideBarShape.Left ) * 1000));

  HideTimer.Enabled := True;
  SlideButton.Tag := 0;
  ClipCursor(Nil);
end;

procedure TInfoForm.HideTimerTimer(Sender: TObject);
begin
  close;
  HideTimer.Enabled := False;
end;

procedure TInfoForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  HideTimer.Enabled := False;
  HideTimer.Enabled := True;
end;

end.

