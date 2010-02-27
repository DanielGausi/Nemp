{

    Unit PlaylistUnit
    Form PlaylistForm

    This is one of the forms showing on viewing mode "Seperate Windows"
    The playercontrol stays in the Mainform, the other parts switch to other
    forms.

    The three forms are
      - AuswahlUnit
      - MedienlisteUnit
      - PlaylistUnit
    Changes made in one of these forms should probably done in the
    other ones too.

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
unit PlaylistUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ShellApi,
  VirtualTrees, Hilfsfunktionen,   Dialogs, ImgList, ExtCtrls,
  Nemp_ConstantsAndTypes, AudioFileClass, TreeHelper,
  gnuGettext, StdCtrls, Buttons, SkinButtons, NempPanel;

type
  TPlaylistForm = class(TNempForm)
    ContainerPanelPlaylistForm: TNempPanel;
    CloseImage: TSkinButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CloseImageClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure ContainerPanelPlaylistFormMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelPlaylistFormMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelPlaylistFormPaint(Sender: TObject);
    procedure ContainerPanelPlaylistFormMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private-Deklarationen }
    DownX: Integer;
    DownY: Integer;
    BLeft: Integer;
    BTop: Integer;
    BWidth: Integer;
    BHeight: Integer;
    ResizeFlag: Cardinal;

    procedure WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
    Procedure WMDropFiles (Var aMsg: tMessage);  message WM_DROPFILES;
  public
    { Public-Deklarationen }
    // Resizing-Flag: On WMWindowPosChanging the RelativPositions must be changed
    Resizing: Boolean;
    //NempRegionsDistance: TNempRegionsDistance;
  end;

var
  PlaylistForm: TPlaylistForm;

implementation

uses NempMainUnit,  SplitForm_Hilfsfunktionen, MedienlisteUnit,
  AuswahlUnit, MessageHelper, ExtendedControlsUnit;

{$R *.dfm}


procedure TPlaylistForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  DragAcceptFiles (Handle, True);
  Top    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistTop;
  Left   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistLeft;
  Height := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistHeight;
  Width  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistWidth;

  BTop    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistTop;
  BLeft   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistLeft;
  BHeight := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistHeight;
  BWidth  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistWidth;

  NempRegionsDistance.docked := Nemp_MainForm.NempOptions.NempEinzelFormOptions.PlaylistDocked;
  NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
  NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;

  Caption := NEMP_CAPTION;
end;


// Zur Zeit wird das nicht automatisch aufgerufen!!!!
procedure TPlaylistForm.FormShow(Sender: TObject);
begin

  Left   := BLeft   ;
  Top    := BTop    ;
  Height := BHeight ;
  Width  := BWidth  ;

  Nemp_MainForm.PlaylistFillPanel.Width := Nemp_MainForm.PlaylistPanel.Width - Nemp_MainForm.PlaylistFillPanel.Left - 16;

  CloseImage.Parent := Nemp_MainForm.PlaylistPanel;
  CloseImage.Left := Nemp_MainForm.PlaylistPanel.Width - CloseImage.Width;
  CloseImage.Top := 3; //6              // PlaylistPanel
  CloseImage.BringToFront;

  SetRegion(ContainerPanelPlaylistForm, self, NempRegionsDistance, handle);

  // Das ist nötig, um z.B. zu korrigieren, dass die Form komplett unter Form1 versteckt ist!!
  if (Top + NempRegionsDistance.Top >= Nemp_MainForm.Top + Nemp_MainForm.NempRegionsDistance.Top)
     AND
     (Top + NempRegionsDistance.Bottom <= Nemp_MainForm.Top + Nemp_MainForm.NempRegionsDistance.Bottom)
     AND
     (Left + NempRegionsDistance.left >= Nemp_MainForm.Left + Nemp_MainForm.NempRegionsDistance.Left)
     AND
     (Left + NempRegionsDistance.Right <= Nemp_MainForm.Left + Nemp_MainForm.NempRegionsDistance.Right)
  then
    NempRegionsDistance.docked := False;

  Nemp_MainForm.RepairZOrder;
end;

procedure TPlaylistForm.ContainerPanelPlaylistFormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    Resizing := True;
    ReleaseCapture;
    PerForm(WM_SysCommand, ResizeFlag , 0);
  end;
end;

procedure TPlaylistForm.ContainerPanelPlaylistFormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TPlaylistForm.ContainerPanelPlaylistFormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    Resizing := False;
end;

procedure TPlaylistForm.ContainerPanelPlaylistFormPaint(Sender: TObject);
begin
    Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel),
    Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

procedure TPlaylistForm.FormActivate(Sender: TObject);
begin
  Nemp_MainForm.PlaylistFillPanel.Width := Nemp_MainForm.PlaylistPanel.Width - Nemp_MainForm.PlaylistFillPanel.Left - 16;

  CloseImage.Parent := Nemp_MainForm.PlaylistPanel;
  CloseImage.Left := Nemp_MainForm.PlaylistPanel.Width - CloseImage.Width;
  CloseImage.Top := 3; //6              // PlaylistPanel
  CloseImage.BringToFront;
end;

procedure TPlaylistForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BLeft   := Left  ;
  BTop    := Top   ;
  BHeight := Height;
  BWidth  := Width ;
  CloseImage.Parent := PlaylistForm;
end;

Procedure TPlaylistForm.WMDropFiles (Var aMsg: tMessage);
Var
  Idx,
  Size,
  FileCount: Integer;
  Filename: PChar;
  abspielen: Boolean;
  p: TPoint;
Begin
    Inherited;

  Handle_DropFilesForPlaylist(aMsg);
end;


procedure TPlaylistForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DownX := X;
  DownY := Y;
  NempRegionsDistance.docked := False;
  Resizing := False;
end;

procedure TPlaylistForm.CloseImageClick(Sender: TObject);
begin
  with Nemp_MainForm do
  begin
    NempOptions.NempEinzelFormOptions.PlaylistVisible := False;
    PM_P_ViewSeparateWindows_Playlist.Checked := NempOptions.NempEinzelFormOptions.PlaylistVisible;
    MM_O_ViewSeparateWindows_Playlist.Checked := NempOptions.NempEinzelFormOptions.PlaylistVisible;
  end;
  close;
end;


procedure TPlaylistForm.FormResize(Sender: TObject);
begin
  SetRegion(ContainerPanelPlaylistForm, self, NempRegionsDistance, handle);
  If Nemp_MainForm.NempSkin.isActive then
  begin
      Nemp_MainForm.NempSkin.SetPlaylistOffsets;
      Repaint;
  end;
end;



procedure TPlaylistForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    Left := Left + X - DownX;
    Top := Top +  Y - DownY;
    NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
    NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;

    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.SetPlaylistOffsets;
      Repaint;
    end;

  end;
end;

procedure TPlaylistForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var tmp: boolean;
begin
    BLeft   := Left  ;
    BTop    := Top   ;
    BHeight := Height;
    BWidth  := Width ;
    tmp := false;
    if IsDocked2(PlaylistForm, Nemp_MainForm) then tmp := True;

    if (IsDocked2(PlaylistForm, MedienlisteForm))
        AND (MedienlisteForm.NempRegionsDistance.docked) then tmp := True;

    if (IsDocked2(PlaylistForm, AuswahlForm))
        AND (AuswahlForm.NempRegionsDistance.docked) then tmp := True;

    NempRegionsDistance.docked := tmp;

    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.RepairSkinOffset;
      Nemp_MainForm.NempSkin.SetPlaylistOffsets;
      Repaint;
      Nemp_MainForm.PlaylistPanel.Repaint;
      Nemp_MainForm.GRPBOXPlaylist.Repaint;
      Nemp_MainForm.PlaylistFillPanel.Repaint;
      //Nemp_MainForm.TabPanelPlaylist.Repaint;
    end;
end;


procedure TPlaylistForm.WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING);
var tmp: Boolean;
begin
  tmp := SnapForm(Message, PlaylistForm, Nemp_MainForm);

  if Not tmp and not NempRegionsDistance.docked then
      tmp := SnapForm(Message, PlaylistForm, NIL);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(ExtendedControlForm)
      AND (ExtendedControlForm.Visible)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      then
        tmp := SnapForm(Message, PlaylistForm, ExtendedControlForm);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(MedienlisteForm)
      AND (MedienlisteForm.Visible)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      then
        tmp := SnapForm(Message, PlaylistForm, MedienlisteForm);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(AuswahlForm)
      //AND (NOT AuswahlForm.NempRegionsDistance.docked)
       AND Auswahlform.Visible
       then
        SnapForm(Message, PlaylistForm, AuswahlForm);

  if Resizing then
  begin
      NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
      NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;
  end;

  Message.Result := 0;
end;


procedure TPlaylistForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Nemp_MainForm.FormKeyDown(Sender, Key, Shift);
end;


end.
