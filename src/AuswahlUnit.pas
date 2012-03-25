{

    Unit AuswahlUnit
    Form AuswahlForm

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
unit AuswahlUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, shellApi,
  ImgList, VirtualTrees, 
  Dialogs, ExtCtrls, StdCtrls, Buttons,  Nemp_ConstantsAndTypes,
  NempAudioFiles, Hilfsfunktionen, Menus,
  gnuGettext, Nemp_RessourceStrings, SkinButtons, NempPanel;

type
  TAuswahlForm = class(TNempForm)
    ContainerPanelAuswahlform: TNempPanel;
    CloseImage: TSkinButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);

    procedure FormResize(Sender: TObject);
    procedure CloseImageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure ContainerPanelAuswahlformPaint(Sender: TObject);
    procedure ContainerPanelAuswahlformMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelAuswahlformMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ContainerPanelAuswahlformMouseUp(Sender: TObject;
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

    procedure InitForm;
  end;

var
  AuswahlForm: TAuswahlForm;

implementation

{$R *.dfm}

uses NempMainUnit, SplitForm_Hilfsfunktionen, MedienlisteUnit,
  PlaylistUnit, MessageHelper, ExtendedControlsUnit;

procedure TAuswahlForm.InitForm;
begin
  TranslateComponent (self);
  DragAcceptFiles (Handle, True);
  Top    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheTop;
  Left   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheLeft;
  Height := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheHeight;
  Width  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheWidth;

  BTop    := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheTop;
  BLeft   := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheLeft;
  BHeight := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheHeight;
  BWidth  := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlSucheWidth;


  NempRegionsDistance.docked := Nemp_MainForm.NempOptions.NempEinzelFormOptions.AuswahlListeDocked;
  NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
  NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
  Caption := NEMP_CAPTION;
end;

// Zur Zeit wird das nicht automatisch aufgerufen!!!!
procedure TAuswahlForm.FormShow(Sender: TObject);
begin
  Left   := BLeft   ;
  Top    := BTop    ;
  Height := BHeight ;
  Width  := BWidth  ;

  Nemp_MainForm.AuswahlFillPanel.Width := Nemp_MainForm.AuswahlPanel.Width - Nemp_MainForm.AuswahlFillPanel.Left - 16;//26;
  CloseImage.Left := Nemp_MainForm.AuswahlPanel.Width - CloseImage.Width;// - 5;//10;
  CloseImage.Top := 3;
  CloseImage.Parent := Nemp_MainForm.AuswahlPanel;
  CloseImage.BringToFront;

  SetRegion(ContainerPanelAuswahlForm, self, NempRegionsDistance, handle);

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

end;

procedure TAuswahlForm.ContainerPanelAuswahlformMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    Resizing := True;
    ReleaseCapture;
    PerForm(WM_SysCommand, ResizeFlag , 0);
  end;
end;


// Hierfür ne Eigene Funktion, die den Cursor setzt und ResizeFlag als Ergebnis liefert
procedure TAuswahlForm.ContainerPanelAuswahlformMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    ResizeFlag := GetResizeDirection(Sender, Shift, X, Y);
end;

procedure TAuswahlForm.ContainerPanelAuswahlformMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    Resizing := False;
end;

procedure TAuswahlForm.ContainerPanelAuswahlformPaint(Sender: TObject);
begin
    Nemp_MainForm.NempSkin.DrawAPanel((Sender as TNempPanel),
    Nemp_MainForm.NempSkin.UseBackgroundImages[(Sender as TNempPanel).Tag]);
end;

procedure TAuswahlForm.FormActivate(Sender: TObject);
begin
  Nemp_MainForm.AuswahlFillPanel.Width := Nemp_MainForm.AuswahlPanel.Width
                                        - Nemp_MainForm.AuswahlFillPanel.Left - 16;//26;
  CloseImage.Left := Nemp_MainForm.AuswahlPanel.Width - CloseImage.Width;// - 5;//10;
  CloseImage.Top := 3;
  CloseImage.Parent := Nemp_MainForm.AuswahlPanel;
  CloseImage.BringToFront;
end;

procedure TAuswahlForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  BLeft   := Left  ;
  BTop    := Top   ;
  BHeight := Height;
  BWidth  := Width ;
  CloseImage.Parent := Auswahlform.ContainerPanelAuswahlform;
  if MedienlisteForm.Visible then
  begin
    MedienBib.GenerateAnzeigeListe(BROWSE_ALL, BROWSE_ALL);
  end;
end;

procedure TAuswahlForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DownX := X;
  DownY := Y;
  NempRegionsDistance.docked := False;
  Resizing := False;
end;


procedure TAuswahlForm.FormResize(Sender: TObject);
begin
   // Größenkorrekturen
  if (Nemp_MainForm.ArtistsVST.Width > Nemp_MainForm.AuswahlPanel.width - 40)
      OR (Nemp_MainForm.ArtistsVST.Width < 40) then
          Nemp_MainForm.ArtistsVST.Width := Nemp_MainForm.AuswahlPanel.width DIV 2;
  SetRegion(ContainerPanelAuswahlForm, self, NempRegionsDistance, handle);
  If Nemp_MainForm.NempSkin.isActive then
  begin
      Nemp_MainForm.NempSkin.SetArtistAlbumOffsets;
      Repaint;
  end;
end;

procedure TAuswahlForm.CloseImageClick(Sender: TObject);
begin
  with Nemp_MainForm do
  begin
    NempOptions.NempEinzelFormOptions.AuswahlSucheVisible := NOT NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
    PM_P_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
    MM_O_ViewSeparateWindows_Browse.Checked := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;
  end;
  close;
end;

procedure TAuswahlForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
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
      Nemp_MainForm.NempSkin.SetArtistAlbumOffsets;
      Repaint;
    end;
  end;
end;

procedure TAuswahlForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var tmp: boolean;
begin
    BLeft   := Left  ;
    BTop    := Top   ;
    BHeight := Height;
    BWidth  := Width ;  
    tmp := false;
    if IsDocked2(AuswahlForm, Nemp_MainForm) then tmp := True;

    if (IsDocked2(AuswahlForm, MedienlisteForm))
        AND (MedienlisteForm.NempRegionsDistance.docked) then tmp := True;

    if (IsDocked2(AuswahlForm, PlaylistForm))
        AND (PlaylistForm.NempRegionsDistance.docked) then tmp := True;

    NempRegionsDistance.docked := tmp;

    If Nemp_MainForm.NempSkin.isActive then
    begin
      Nemp_MainForm.NempSkin.RepairSkinOffset;
      Nemp_MainForm.NempSkin.SetArtistAlbumOffsets;
      Repaint;
      Nemp_MainForm.AuswahlPanel.Repaint;
      Nemp_MainForm.AuswahlFillPanel.Repaint;
      Nemp_MainForm.GRPBOXArtistsAlben.Repaint;
      Nemp_MainForm.PanelCoverBrowse.Repaint;
      Nemp_MainForm.PanelStandardBrowse.Repaint;
      Nemp_MainForm.PanelTagCloudBrowse.Repaint;
    end;

end;

procedure TAuswahlForm.WMWindowPosChanging(var Message: TWMWINDOWPOSCHANGING);
var tmp: Boolean;
begin
  tmp := SnapForm(Message, AuswahlForm, Nemp_MainForm);
  
  if (Not tmp) and (not NempRegionsDistance.docked) then
      tmp := SnapForm(Message, AuswahlForm, NIL);

  if not tmp and (not NempRegionsDistance.docked) AND assigned(ExtendedControlForm)
      AND (ExtendedControlForm.Visible)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      then
        tmp := SnapForm(Message, AuswahlForm, ExtendedControlForm);

  if (Not tmp) and (not NempRegionsDistance.docked) AND assigned(MedienlisteForm)
      //AND (NOT MedienlisteForm.NempRegionsDistance.docked)
      And MedienlisteForm.Visible
      then
        tmp := SnapForm(Message, AuswahlForm, MedienlisteForm);

  if (Not tmp) and (not NempRegionsDistance.docked) AND assigned(PlaylistForm)
      //AND (NOT PlaylistForm.NempRegionsDistance.docked)
      And PlaylistForm.Visible
      then
        SnapForm(Message, AuswahlForm, PlaylistForm);

  if Resizing then
  begin
      NempRegionsDistance.RelativPositionX := Left - Nemp_MainForm.Left;
      NempRegionsDistance.RelativPositionY := Top - Nemp_MainForm.Top;
  end;

  Message.Result := 0;
end;


Procedure TAuswahlForm.WMDropFiles (Var aMsg: tMessage);
Begin
    Inherited;
    Handle_DropFilesForLibrary(aMsg);
end;


procedure TAuswahlForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Nemp_MainForm.FormKeyDown(Sender, Key, Shift);
end;



end.

