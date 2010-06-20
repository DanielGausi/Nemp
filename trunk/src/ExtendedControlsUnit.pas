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
    Copyright (C) 2005-2010, Daniel Gaussmann
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
  StdCtrls, Buttons, SkinButtons, ExtCtrls, NempPanel;

type
  TExtendedControlForm = class(TNempForm)
    ContainerPanelExtendedControlsForm: TNempPanel;
    CloseImage: TSkinButton;
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
  private
    { Private-Deklarationen }
    DownX: Integer;
    DownY: Integer;
    BLeft: Integer;
    BTop: Integer;
    BWidth: Integer;
    BHeight: Integer;
    procedure WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;

  public
    { Public-Deklarationen }
    procedure SetPartySize(w,h: Integer);
    procedure InitForm;
  end;

var
  ExtendedControlForm: TExtendedControlForm;

implementation

uses NempMainUnit, MedienlisteUnit, AuswahlUnit, PlaylistUnit;

{$R *.dfm}


procedure TExtendedControlForm.ContainerPanelExtendedControlsFormPaint(
  Sender: TObject);
begin
    Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel),
    Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

procedure TExtendedControlForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BLeft   := Left  ;
  BTop    := Top   ;
  BHeight := Height;
  BWidth  := Width ;

  if Nemp_MainForm.AnzeigeMode = 1 then
      // still in seperate-window-mode
      NempPlayer.StopHeadset;
end;

procedure TExtendedControlForm.InitForm;
begin
  TranslateComponent (self);
  Top    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsTop;
  Left   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsLeft;
//  Height := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsHeight;
//  Width  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsWidth;

  BTop    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsTop;
  BLeft   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsLeft;
//  BHeight := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsHeight;
//  BWidth  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsWidth;

BHeight := Height;
BWidth := Width;

  NempRegionsDistance.docked := Nemp_MainForm.NempOptions.NempEinzelFormOptions.ExtendedControlsDocked;
  NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
  NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;

  Caption := NEMP_CAPTION;
end;

procedure TExtendedControlForm.FormHide(Sender: TObject);
begin
  if Nemp_MainForm.AnzeigeMode = 1 then
      // still in seperate-window-mode
      NempPlayer.StopHeadset;
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

 //   If Nemp_MainForm.NempSkin.isActive then
 //   begin
 //     Nemp_MainForm.NempSkin.SetPlaylistOffsets;
 //     Repaint;
 //   end;

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

    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.RepairSkinOffset;
      //Nemp_MainForm.NempSkin.SetPlaylistOffsets;
      Repaint;
      //Nemp_MainForm.PlaylistPanel.Repaint;
      //Nemp_MainForm.GRPBOXPlaylist.Repaint;
      //Nemp_MainForm.PlaylistFillPanel.Repaint;
      //Nemp_MainForm.TabPanelPlaylist.Repaint;
    end;

end;

procedure TExtendedControlForm.FormShow(Sender: TObject);
var formregion: HRGN;
    xpbottom, xptop, xpleft, xpright: integer;
begin

  Left   := BLeft   ;
  Top    := BTop    ;
  Height := BHeight ;
  Width  := BWidth  ;

  //Nemp_MainForm.PlaylistFillPanel.Width := Nemp_MainForm.PlaylistPanel.Width - Nemp_MainForm.PlaylistFillPanel.Left - 26;

 { CloseImage.Parent := Nemp_MainForm.PlaylistPanel;
  CloseImage.Left := Nemp_MainForm.PlaylistPanel.Width - CloseImage.Width - 10;
  CloseImage.Top := 3; //6              // PlaylistPanel
  CloseImage.BringToFront;
 }
  //

  //SetRegion(Nemp_MainForm.AudioPanel, self, NempRegionsDistance, handle);

  xpleft   := 0; //GetSystemMetrics(SM_CXFrame) + NewPlayerPanel.Left - 1;
  xptop    := 0; // GetSystemMetrics(SM_CYCAPTION)  + GetSystemMetrics(SM_CYFrame) + NewPlayerPanel.Top - 1;
  xpright  :=  Width - 1;
  xpbottom := Height - 1;
  formRegion := CreateRectRgn
                  (xpleft, xptop, xpright, xpbottom);
  SetWindowRgn(handle, formregion, true );


NempRegionsDistance.Left := 0;
NempRegionsDistance.Top := 0;
NempRegionsDistance.Bottom := Height-1;
NempRegionsDistance.Right := Width-1;



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

  Message.Result := 0;
end;

end.
