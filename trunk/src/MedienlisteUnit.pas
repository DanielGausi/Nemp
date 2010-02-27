{

    Unit MedienlisteUnit
    Form MedienlisteForm

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
unit MedienlisteUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ShellApi, VirtualTrees,
  Dialogs, ExtCtrls, ImgList, Nemp_ConstantsAndTypes, AudioFileClass, Hilfsfunktionen,
  Menus,gnuGettext,
  Nemp_RessourceStrings,  StdCtrls, Buttons, SkinButtons, NempPanel;

type
  TMedienlisteForm = class(TNempForm)
    ContainerPanelMedienBibForm: TNempPanel;
    CloseImage: TSkinButton;
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
    procedure ContainerPanelMedienBibFormPaint(Sender: TObject);
    procedure ContainerPanelMedienBibFormMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelMedienBibFormMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelMedienBibFormMouseUp(Sender: TObject;
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
  MedienlisteForm: TMedienlisteForm;

implementation

uses NempMainUnit, SplitForm_Hilfsfunktionen, AuswahlUnit,
  PlaylistUnit, MessageHelper, ExtendedControlsUnit;

{$R *.dfm}

procedure TMedienlisteForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  DragAcceptFiles (Handle, True);
  Top    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteTop;
  Left   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteLeft;
  Height := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteHeight;
  Width  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteWidth;

  BTop    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteTop;
  BLeft   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteLeft;
  BHeight := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteHeight;
  BWidth  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteWidth;

  NempRegionsDistance.docked := Nemp_MainForm.NempOptions.NempEinzelFormOptions.MedienlisteDocked;
  NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
  NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
  Caption := NEMP_CAPTION;
end;

// Zur Zeit wird das nicht automatisch aufgerufen!!!!
procedure TMedienlisteForm.FormShow(Sender: TObject);
begin
  Left   := BLeft   ;
  Top    := BTop    ;
  Height := BHeight ;
  Width  := BWidth  ;

  Nemp_MainForm.MedienlisteFillPanel.Width := Nemp_MainForm.VSTPanel.Width - Nemp_MainForm.MedienlisteFillPanel.Left - 16;
  CloseImage.Left := Nemp_MainForm.VSTPanel.Width - CloseImage.Width;// - 10;
  CloseImage.Top := 3;
  CloseImage.Parent := Nemp_MainForm.VSTPanel;
  CloseImage.BringToFront;

  SetRegion(ContainerPanelMedienBibForm, self, NempRegionsDistance, handle);

  // Das ist n�tig, um z.B. zu korrigieren, dass die Form komplett unter Form1 versteckt ist!!
  if (Top + NempRegionsDistance.Top >= Nemp_MainForm.Top + Nemp_MainForm.NempRegionsDistance.Top)
     AND
     (Top + NempRegionsDistance.Bottom <= Nemp_MainForm.Top + Nemp_MainForm.NempRegionsDistance.Bottom)
     AND
     (Left + NempRegionsDistance.left >= Nemp_MainForm.Left + Nemp_MainForm.NempRegionsDistance.Left)
     AND
     (Left + NempRegionsDistance.Right <= Nemp_MainForm.Left + Nemp_MainForm.NempRegionsDistance.Right)
  then
    NempRegionsDistance.docked := False;

end;

procedure TMedienlisteForm.ContainerPanelMedienBibFormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    Resizing := True;
    ReleaseCapture;
    PerForm(WM_SysCommand, ResizeFlag , 0);
  end;
end;

procedure TMedienlisteForm.ContainerPanelMedienBibFormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TMedienlisteForm.ContainerPanelMedienBibFormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    Resizing := False;
end;

procedure TMedienlisteForm.ContainerPanelMedienBibFormPaint(Sender: TObject);
begin
    Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel),
    Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

procedure TMedienlisteForm.FormActivate(Sender: TObject);
begin
  Nemp_MainForm.MedienlisteFillPanel.Width := Nemp_MainForm.VSTPanel.Width - Nemp_MainForm.MedienlisteFillPanel.Left - 16;
  CloseImage.Left := Nemp_MainForm.VSTPanel.Width - CloseImage.Width;
  CloseImage.Top := 3;
  CloseImage.Parent := Nemp_MainForm.VSTPanel;
  CloseImage.BringToFront;
end;

procedure TMedienlisteForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BLeft   := Left  ;
  BTop    := Top   ;
  BHeight := Height;
  BWidth  := Width ;
  CloseImage.Parent := MedienlisteForm;
end;


procedure TMedienlisteForm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DownX := X;
  DownY := Y;
  NempRegionsDistance.docked := False;
  Resizing := False;
end;

procedure TMedienlisteForm.CloseImageClick(Sender: TObject);
begin
  with Nemp_MainForm do
  begin
    NempOptions.NempEinzelFormOptions.MedienlisteVisible := False;
    PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
    MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
  end;
  close;
end;


procedure TMedienlisteForm.FormResize(Sender: TObject);
begin
  SetRegion(ContainerPanelMedienBibForm, self, NempRegionsDistance, handle);
  If Nemp_MainForm.NempSkin.isActive then
  begin
      Nemp_MainForm.NempSkin.SetVSTOffsets;
      Repaint;
  end;
end;

procedure TMedienlisteForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    Left := Left + X - DownX;
    Top := Top +  Y - DownY;
    NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
    NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;
    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.SetVSTOffsets;
      Repaint;
    end;
  end;
end;

procedure TMedienlisteForm.FormMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmp: boolean;
begin
    BLeft   := Left  ;
    BTop    := Top   ;
    BHeight := Height;
    BWidth  := Width ;
    tmp := false;
    if IsDocked2(MedienlisteForm, Nemp_MainForm) then tmp := True;

    if (IsDocked2(MedienlisteForm, PlaylistForm))
        AND (PlaylistForm.NempRegionsDistance.docked) then tmp := True;

    if (IsDocked2(MedienlisteForm, AuswahlForm))
        AND (AuswahlForm.NempRegionsDistance.docked) then tmp := True;

    NempRegionsDistance.docked := tmp;

    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.RepairSkinOffset;
      Nemp_MainForm.NempSkin.SetVSTOffsets;
      Repaint;
      Nemp_MainForm.VSTPanel.Repaint;
      //Nemp_MainForm.TabPanelMedienliste.Repaint;
      Nemp_MainForm.MedienlisteFillPanel.Repaint;
      Nemp_MainForm.GRPBOXVST.Repaint;
    end;

end;

procedure TMedienlisteForm.WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING);
var tmp: Boolean;
begin
  tmp := SnapForm(Message, MedienlisteForm, Nemp_MainForm);

  if Not tmp and (not NempRegionsDistance.docked) then
    tmp := SnapForm(Message, MedienlisteForm, NIL);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(ExtendedControlForm)
      AND (ExtendedControlForm.Visible)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      then
        tmp := SnapForm(Message, MedienlisteForm, ExtendedControlForm);

  if Not tmp and(not NempRegionsDistance.docked) AND assigned(AuswahlForm)
      //AND (NOT AuswahlForm.NempRegionsDistance.docked)
      And AuswahlForm.Visible
      then
        tmp := SnapForm(Message, MedienlisteForm, AuswahlForm);

  if Not tmp and(not NempRegionsDistance.docked) AND assigned(PlaylistForm)
      //AND (NOT PlaylistForm.NempRegionsDistance.docked)
      And PlaylistForm.Visible
       then
        SnapForm(Message, MedienlisteForm, PlaylistForm);

  if Resizing then
  begin
      NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
      NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;
  end;

  Message.Result := 0;
end;

Procedure TMedienlisteForm.WMDropFiles (Var aMsg: tMessage);
Begin
    Inherited;
    Handle_DropFilesForLibrary(aMsg);
end;



procedure TMedienlisteForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Nemp_MainForm.FormKeyDown(Sender, Key, Shift);
end;



end.
