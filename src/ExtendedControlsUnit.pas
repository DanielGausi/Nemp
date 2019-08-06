{

    Unit ExtendedControlsUnit
    Form ExtendedControls

    This is one of the forms showing on viewing mode "Seperate Windows"
    The playercontrol stays in the Mainform, the other parts switch to other
    forms.

    This one has a fixed size.

    The three other forms are
      - AuswahlUnit
      - MedienlisteUnit
      - PlaylistUnit
    Changes made in one of these forms should probably done in the
    other ones too.

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

unit ExtendedControlsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Nemp_ConstantsAndTypes, SplitForm_Hilfsfunktionen, gnuGettext,
  StdCtrls, Buttons, SkinButtons, ExtCtrls, NempPanel, System.Types;

type
  TExtendedControlForm = class(TNempForm)
    ContainerPanelExtendedControlsForm: TNempPanel;
    CloseImageE: TSkinButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ContainerPanelExtendedControlsFormPaint(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CloseImageEClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ContainerPanelExtendedControlsFormMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelExtendedControlsFormMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelExtendedControlsFormMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
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

  public
    { Public-Deklarationen }
    Resizing: Boolean;
    procedure SetPartySize(w,h: Integer);
    procedure InitForm;
    procedure RepaintForm;
  end;

var
  ExtendedControlForm: TExtendedControlForm;

implementation

uses NempMainUnit, MedienlisteUnit, AuswahlUnit, PlaylistUnit;

{$R *.dfm}


procedure TExtendedControlForm.CloseImageEClick(Sender: TObject);
begin
    with Nemp_MainForm do
    begin
      NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible := NOT NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
      PM_P_ViewSeparateWindows_Equalizer.Checked := NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
      MM_O_ViewSeparateWindows_Equalizer.Checked := NempFormBuildOptions.WindowSizeAndPositions.ErweiterteControlsVisible;
    end;
    close;
end;

procedure TExtendedControlForm.ContainerPanelExtendedControlsFormMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if button = mbLeft then
    begin
      Resizing := True;
      ReleaseCapture;
      PerForm(WM_SysCommand, ResizeFlag , 0);
    end;
end;

procedure TExtendedControlForm.ContainerPanelExtendedControlsFormMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TExtendedControlForm.ContainerPanelExtendedControlsFormMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    Resizing := False;
end;

procedure TExtendedControlForm.ContainerPanelExtendedControlsFormPaint(
  Sender: TObject);
begin
    Nemp_MainForm.NempSkin.DrawARegularPanel((Sender as TNempPanel),
    Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

procedure TExtendedControlForm.FormActivate(Sender: TObject);
begin
  {
  Copied from MedíenListeForm, do something equivalent here
  Nemp_MainForm.MedienlisteFillPanel.Width := Nemp_MainForm.MedialistPanel.Width - Nemp_MainForm.MedienlisteFillPanel.Left - 16;
  CloseImageM.Left := Nemp_MainForm.MedialistPanel.Width - CloseImageM.Width;
  CloseImageM.Top := 3;
  CloseImageM.Parent := Nemp_MainForm.MedialistPanel;
  CloseImageM.BringToFront;
  }
end;

procedure TExtendedControlForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BLeft   := Left  ;
  BTop    := Top   ;
  BHeight := Height;
  BWidth  := Width ;
  CloseImageE.Parent := ExtendedControlForm.ContainerPanelExtendedControlsForm;
end;

procedure TExtendedControlForm.InitForm;
begin
  TranslateComponent (self);
  Top     := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsTop;
  Left    := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsLeft;
  Height  := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsHeight;
  Width   := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsWidth;

  BTop    := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsTop;
  BLeft   := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsLeft;
  BHeight := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsHeight;
  BWidth  := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsWidth;

  // BHeight := Height;
  // BWidth := Width;

  NempRegionsDistance.docked := Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.ExtendedControlsDocked;
  NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormLeft;
  NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.NempFormBuildOptions.WindowSizeAndPositions.MiniMainFormTop;

  Caption := NEMP_CAPTION;
end;


procedure TExtendedControlForm.FormHide(Sender: TObject);
begin
    CloseImageE.Parent := ExtendedControlForm.ContainerPanelExtendedControlsForm;
end;

procedure TExtendedControlForm.SetPartySize(w, h: Integer);
begin
  Height := h;
  Width := w;
  BHeight := Height;
  BWidth := Width;
end;

procedure TExtendedControlForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Nemp_MainForm.FormKeyDown(Sender, Key, Shift);
end;

procedure TExtendedControlForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DownX := X;
  DownY := Y;
  NempRegionsDistance.docked := False;
  Resizing := False;
end;

procedure TExtendedControlForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin

    if (ssLeft in Shift) then
    begin
        Left := Left + X - DownX;
        Top := Top +  Y - DownY;
        NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
        NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;

        if (Nemp_MainForm.NempSkin.isActive) and (NOT Nemp_MainForm.NempSkin.FixedBackGround) then
        begin
            Nemp_MainForm.NempSkin.RepairSkinOffset;
            RepaintForm;
        end;

    end;
end;

procedure TExtendedControlForm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmp: boolean;
begin
    BLeft   := Left  ;
    BTop    := Top   ;
    BHeight := Height;
    BWidth  := Width ;
    tmp := false;
    if IsDocked2(ExtendedControlForm, Nemp_MainForm) then tmp := True;

    if (IsDocked2(ExtendedControlForm, MedienlisteForm))
        AND (MedienlisteForm.NempRegionsDistance.docked) then tmp := True;

    if (IsDocked2(ExtendedControlForm, AuswahlForm))
        AND (AuswahlForm.NempRegionsDistance.docked) then tmp := True;

    NempRegionsDistance.docked := tmp;

    if (Nemp_MainForm.NempSkin.isActive) and (NOT Nemp_MainForm.NempSkin.FixedBackGround) then
    begin
        Nemp_MainForm.NempSkin.RepairSkinOffset;
        RepaintForm;
    end;
end;

procedure TExtendedControlForm.FormResize(Sender: TObject);
begin

    SetRegion(ContainerPanelExtendedControlsForm, self, NempRegionsDistance, handle);
    If Nemp_MainForm.NempSkin.isActive then
    begin
        Nemp_MainForm.NempSkin.SetVSTOffsets;
        //Repaint;
    end;
end;

procedure TExtendedControlForm.RepaintForm;
begin
    Repaint;

    // todo: Repaint subpanels of FileOverview ??

    //Nemp_MainForm.AudioPanel.Repaint;
    //Nemp_MainForm.GRPBOXHeadset.Repaint;
    //Nemp_MainForm.GRPBOXLyrics.Repaint;
    //Nemp_MainForm.GRPBOXCover.Repaint
end;

procedure TExtendedControlForm.FormShow(Sender: TObject);
var formregion: HRGN;
    xpbottom, xptop, xpleft, xpright: integer;
begin

  Left   := BLeft   ;
  Top    := BTop    ;
  Height := BHeight ;
  Width  := BWidth  ;

  // rework needed .... somethin like in the other forms as well
  // the different code for "regions" is due to the "header" in the other forms


  Nemp_MainForm.MedienBibDetailFillPanel.Width := Nemp_MainForm.MedienBibDetailPanel.Width -  Nemp_MainForm.MedienBibDetailFillPanel.Left - 16;

  CloseImageE.Left := Nemp_MainForm.MedienBibDetailPanel.Width - CloseImageE.Width;// - 10;
  CloseImageE.Top := 3;
  CloseImageE.Parent := Nemp_MainForm.MedienBibDetailPanel;
  CloseImageE.BringToFront;

  SetRegion(ContainerPanelExtendedControlsForm, self, NempRegionsDistance, handle);

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



procedure TExtendedControlForm.WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING);
var tmp: Boolean;
begin

  tmp := SnapForm(Message, ExtendedControlForm, Nemp_MainForm);

  if Not tmp and not NempRegionsDistance.docked then
      tmp := SnapForm(Message, ExtendedControlForm, NIL);

  if Not tmp and(not NempRegionsDistance.docked) AND assigned(PlaylistForm)
      //AND (NOT PlaylistForm.NempRegionsDistance.docked)
      And PlaylistForm.Visible
       then
        SnapForm(Message, ExtendedControlForm, PlaylistForm);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(MedienlisteForm)
      AND (MedienlisteForm.Visible)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      then
        tmp := SnapForm(Message, ExtendedControlForm, MedienlisteForm);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(AuswahlForm)
      //AND (NOT AuswahlForm.NempRegionsDistance.docked)
       AND Auswahlform.Visible
       then
        SnapForm(Message, ExtendedControlForm, AuswahlForm);

  if Resizing then
  begin
      NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
      NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;
  end;


  Message.Result := 0;
end;

end.
