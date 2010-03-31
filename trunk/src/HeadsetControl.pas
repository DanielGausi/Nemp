{

    Unit HeadsetControl
    Form THeadsetControlForm

    - a little form for controlling the playback on a seperate sound-device

    Note to self: The Drag&Drop-stuff here should be replaced by the newer
                  methods used in MainForm.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit HeadsetControl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, VirtualTrees,
  Nemp_ConstantsAndTypes, AudioFileClass,
   gnuGettext, SkinButtons;

type
  THeadsetControlForm = class(TForm)
    PlayBTN: TSkinButton;
    StopBTN: TSkinButton;
    SlideBackBTN: TSkinButton;
    SlideForwardBTN: TSkinButton;
    VolButton: TSkinButton;
    VolShape: TShape;
    SlideBarButton: TSkinButton;
    SlideBarShape: TShape;
    Timer1: TTimer;
    Lbl_HeadSetTitle: TLabel;
    procedure PlayBTNClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VolButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure VolButtonDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure VolButtonDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StopBTNClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SlideForwardBTNClick(Sender: TObject);
    procedure SlideBackBTNClick(Sender: TObject);
    procedure SlideBarShapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SlideBarButtonDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure SlideBarButtonStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure SlideBarButtonDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  HeadsetControlForm: THeadsetControlForm;

implementation

uses NempMainUnit;

{$R *.dfm}

procedure THeadsetControlForm.PlayBTNClick(Sender: TObject);
var aNode: PVirtualNode;
  Data: PTreeData;
  aAudiofile: TAudiofile;
begin
  if Nemp_MainForm.AktiverTree = NIL then exit;
  aNode := Nemp_MainForm.AktiverTree.FocusedNode;
  if not assigned(aNode) then exit;

  Data := Nemp_MainForm.AktiverTree.GetNodeData(aNode);
  aAudiofile := Data^.FAudioFile;
  NempPlayer.StopHeadset;
  NempPlayer.PlayInHeadset(aAudiofile);

  Lbl_HeadSetTitle.Caption := NempPlayer.GenerateTitelString(aAudiofile, 0);
  Timer1.Enabled := True;
end;

procedure THeadsetControlForm.FormCreate(Sender: TObject);
var BaseDir: String;
begin
    TranslateComponent (self);

    baseDir := ExtractFilePath(ParamStr(0)) + 'Images\';
    if FileExists(baseDir + 'BtnPlayPause.bmp') then
        PlayBTN.NempGlyph.LoadFromFile(baseDir + 'BtnPlayPause.bmp');
    if FileExists(baseDir + 'BtnSlidebackward.bmp') then
        SlideBackBTN.NempGlyph.LoadFromFile(baseDir + 'BtnSlidebackward.bmp');
    if FileExists(baseDir + 'BtnStop.bmp') then
        StopBTN.NempGlyph.LoadFromFile(baseDir + 'BtnStop.bmp');
    if FileExists(baseDir + 'BtnSlideForward.bmp') then
        SlideForwardBTN.NempGlyph.LoadFromFile(baseDir + 'BtnSlideForward.bmp');
    PlayBtn.GlyphLine := 0;
    SlideBackBTN.GlyphLine := 0;
    StopBtn.GlyphLine := 0;
    SlideForwardBtn.GlyphLine := 0;
 end;

procedure THeadsetControlForm.VolButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var Arect: TRect;
begin
  with VolButton do Begindrag(false);
  //Arect := Button2.ClientRect;
  ARect.TopLeft :=  (HeadsetControlForm.ClientToScreen(Point(VolButton.Left, VolButton.Top)));
  ARect.BottomRight :=  (HeadsetControlForm.ClientToScreen(Point(VolButton.Left + VolButton.Width, VolButton.Top + VolButton.Height)));
  ClipCursor(@Arect);
end;      

procedure THeadsetControlForm.VolButtonDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
Var newpos: integer;
  AREct: TRect;
begin
  NewPos := VolButton.Top + y - 12;
  if NewPos <= VolShape.Top then
      VolButton.Top := VolShape.Top
    else
      if NewPos >= VolShape.Top + VolShape.Height - VolButton.Height  then
        VolButton.Top := VolShape.Top + VolShape.Height - VolButton.Height
      else
        VolButton.Top := NewPos;

    NempPlayer.HeadsetVolume := Round(100-((VolButton.Top - VolShape.Top)*3));
    ARect.TopLeft :=  (HeadsetControlForm.ClientToScreen(Point(VolButton.Left, VolButton.Top)));
    ARect.BottomRight :=  (HeadsetControlForm.ClientToScreen(Point(VolButton.Left + VolButton.Width, VolButton.Top + VolButton.Height)));
    ClipCursor(@Arect);
end;

procedure THeadsetControlForm.VolButtonDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  ClipCursor(Nil);
end;

procedure THeadsetControlForm.StopBTNClick(Sender: TObject);
begin
  NempPlayer.StopHeadset;
  Timer1.Enabled := False;
end;

procedure THeadsetControlForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  StopBTNClick(Nil);
end;

procedure THeadsetControlForm.SlideForwardBTNClick(Sender: TObject);
begin
  NempPlayer.HeadsetTime := NempPlayer.HeadsetTime + 5;
end;

procedure THeadsetControlForm.SlideBackBTNClick(Sender: TObject);
begin
  NempPlayer.HeadsetTime := NempPlayer.HeadsetTime - 5;
end;

procedure THeadsetControlForm.SlideBarShapeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var NewPos: Integer;
begin
  NewPos := SlideBarShape.Left + x - 12;
  if NewPos <= SlideBarShape.Left then
      SlideBarButton.Left := SlideBarShape.Left
    else
      if NewPos >= SlideBarShape.Left + SlideBarShape.Width - 25 then
        SlideBarButton.Left := SlideBarShape.Left + SlideBarShape.Width - 25
      else
        SlideBarButton.Left := NewPos;
  NempPlayer.HeadsetProgress := (SlideBarButton.Left-8) / (SlideBarShape.Width-25);
end;

procedure THeadsetControlForm.SlideBarButtonDragDrop(Sender,
  Source: TObject; X, Y: Integer);
begin
  NempPlayer.HeadsetProgress := (SlideBarButton.Left-8) / (SlideBarShape.Width-25);
  SlideBarButton.Tag := 0; 
  ClipCursor(NIL);   
end;

procedure THeadsetControlForm.SlideBarButtonStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var AREct: tRect;
begin
  with SlideBarButton do Begindrag(false);
  ARect.TopLeft :=  (HeadsetControlForm.ClientToScreen(Point(SlideBarButton.Left, SlideBarButton.Top)));
  ARect.BottomRight :=  (HeadsetControlForm.ClientToScreen(Point(SlideBarButton.Left + SlideBarButton.Width, SlideBarButton.Top + SlideBarButton.Height)));
  SlideBarButton.Tag := 1;
  ClipCursor(@Arect);
end;

procedure THeadsetControlForm.SlideBarButtonDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
Var newpos: integer;
  AREct: TRect;
begin
  if source <> SlideBarButton then exit;

  NewPos := SlideBarButton.Left + x - 12;
  if NewPos <= SlideBarShape.Left then
      SlideBarButton.Left := SlideBarShape.Left
    else
      if NewPos >= SlideBarShape.Width  + SlideBarShape.Left - 25 then
        SlideBarButton.Left := SlideBarShape.Width + SlideBarShape.Left - 25
      else
        SlideBarButton.Left := NewPos;
    ARect.TopLeft :=  (HeadsetControlForm.ClientToScreen(Point(SlideBarButton.Left, SlideBarButton.Top)));
    ARect.BottomRight :=  (HeadsetControlForm.ClientToScreen(Point(SlideBarButton.Left + SlideBarButton.Width, SlideBarButton.Top + SlideBarButton.Height)));
    ClipCursor(@Arect);
end;

procedure THeadsetControlForm.Timer1Timer(Sender: TObject);
begin
  if SlideBarButton.Tag = 0 then
    SlideBarButton.Left := 8 + Round((SlideBarShape.Width-25) * NempPlayer.HeadsetProgress);
end;

procedure THeadsetControlForm.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

end.
