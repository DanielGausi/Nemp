{

    Unit SplitForm_Hilfsfunktionen

    - Helpers for splitting the main form into several windows

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
unit SplitForm_Hilfsfunktionen;

{$I xe.inc}

interface

uses Windows, forms, Classes, Controls, StdCtrls, ExtCtrls, Graphics, Nemp_ConstantsAndTypes, Messages, dialogs, ShellApi
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF} , sysutils, System.Types, BaseForms, ActiveX, SkinButtons;

  procedure SetRegion(GrpBox: TPanel; aForm: TForm; var NempRegionsDistance: TNempRegionsDistance;  aHandle: hWnd);
  function IntervalOverlap(left1, right1, left2, right2: integer): boolean;

  function SnapForm(var Message: TWMWINDOWPOSCHANGING; Source: TNempForm; Dest: TNempForm): boolean;

  function IsDocked2(Source: TNempForm; Dest: TNempForm): Boolean;

  procedure FormPosAndSizeCorrect(aForm: TNempForm);
  Procedure ReInitRelativePositions;
  procedure ReInitDocks;

  function GetResizeDirection(Sender: TObject; Shift: TShiftState; X, Y: Integer):Cardinal;

  procedure SwapWindowMode(newMode: Integer);

  procedure SplitMainForm;
  procedure JoinMainForm;

  procedure FixScrollbar;

  procedure ReAcceptDragFiles;
  procedure RevokeDragFiles;

  procedure UpdateSmallMainForm;
  procedure UpdateFormDesignNeu(newMode: Integer);

  procedure PositionCloseImage(CloseBtn: TSkinButton; ParentPanel: TPanel);

var

    SnapActive: Boolean;

implementation

uses NempMainUnit, PlaylistUnit, MedienlisteUnit, AuswahlUnit, ExtendedControlsUnit,
     SystemHelper, Inifiles, MainFormBuilderForm;

procedure SetRegion(GrpBox: TPanel; aForm: TForm; var NempRegionsDistance: TNempRegionsDistance; aHandle: hWnd);
begin
    NempRegionsDistance.Top    := 0;
    NempRegionsDistance.Left   := 0;
    NempRegionsDistance.Right  := GrpBox.Width;
    NempRegionsDistance.Bottom := GrpBox.Height;
end;

function IntervalOverlap(left1, right1, left2, right2: integer): boolean;
begin
  result := ((left2 <= left1) AND (right2 >= left1))
         OR ((left2 >= left1) AND (left2 <= Right1));
end;


function SnapForm(var Message: TWMWINDOWPOSCHANGING; Source: TNempForm; Dest: TNempForm): Boolean;
const
  distance = 10;

begin

  result := False;

  if not SnapActive then exit;

  if Dest = NIL then
  begin
        { Obere und untere Festerkante }
        if (Message.WindowPos.y + Source.NempRegionsDistance.Top <= distance + Screen.WorkAreaTop) and
           (Message.WindowPos.y + Source.NempRegionsDistance.Top >= -distance + Screen.WorkAreaTop) then
              Message.WindowPos.y := - Source.NempRegionsDistance.Top + Screen.WorkAreaTop
        else
        if (Message.WindowPos.y + Source.NempRegionsDistance.bottom > (Screen.WorkAreaHeight + Screen.WorkAreaTop - distance)) and
           (Message.WindowPos.y + Source.NempRegionsDistance.bottom < (Screen.WorkAreaHeight + Screen.WorkAreaTop + distance)) then
              Message.WindowPos.y := Screen.WorkAreaHeight - Source.NempRegionsDistance.Bottom + Screen.WorkAreaTop;

        { Linke und rechte Fensterkante }
        if (Message.WindowPos.x + Source.NempRegionsDistance.Left <= distance + Screen.WorkAreaLeft) and
           (Message.WindowPos.x + Source.NempRegionsDistance.Left >= -distance + Screen.WorkAreaLeft) then
              Message.WindowPos.x := - Source.NempRegionsDistance.Left + Screen.WorkAreaLeft
        else
        if (Message.WindowPos.x + Source.NempRegionsDistance.Right > (Screen.WorkAreaWidth + Screen.WorkAreaLeft - distance)) and
           (Message.WindowPos.x + Source.NempRegionsDistance.Right < (Screen.WorkAreaWidth + Screen.WorkAreaLeft + distance)) then
              Message.WindowPos.x := Screen.WorkAreaWidth - Source.NempRegionsDistance.Right + Screen.WorkAreaLeft;
  end
  else // if Dest = Form1 then
  begin
      // Obere Quellkante an untere Zielkante
      if      (Message.WindowPos.y + Source.NempRegionsDistance.Top <=
                    Dest.Top + Dest.NempRegionsDistance.Bottom + distance)
          AND
              (Message.WindowPos.y + Source.NempRegionsDistance.Top >=
                    Dest.Top + Dest.NempRegionsDistance.Bottom - distance)

          AND IntervalOverlap(Message.WindowPos.x + Source.NempRegionsDistance.Left,
                    Message.WindowPos.x + Source.NempRegionsDistance.Right,
                    Dest.Left + Dest.NempRegionsDistance.Left,
                    Dest.Left + Dest.NempRegionsDistance.Right)
         then begin
                Message.WindowPos.y := Dest.Top + Dest.NempRegionsDistance.Bottom
                  - Source.NempRegionsDistance.Top;
              result := True;
         end

      else // Änderung

      // Obere Quellkante an obere Zielkante
      if      (Message.WindowPos.y + Source.NempRegionsDistance.Top <=
                    Dest.Top + Dest.NempRegionsDistance.Top + distance)
          AND
              (Message.WindowPos.y + Source.NempRegionsDistance.Top >=
                    Dest.Top + Dest.NempRegionsDistance.Top - distance)

          AND IntervalOverlap(Message.WindowPos.x + Source.NempRegionsDistance.Left,
                    Message.WindowPos.x + Source.NempRegionsDistance.Right,
                    Dest.Left + Dest.NempRegionsDistance.Left,
                    Dest.Left + Dest.NempRegionsDistance.Right)
         then begin
              Message.WindowPos.y := Dest.Top + Dest.NempRegionsDistance.Top
              - Source.NempRegionsDistance.Top;
              result := True;
         end

      else // Änderung

      // Untere Quellkante an obere Zielkante
      if      (Message.WindowPos.y + Source.NempRegionsDistance.Bottom <=
                    Dest.Top + Dest.NempRegionsDistance.Top + distance)
          AND
              (Message.WindowPos.y + Source.NempRegionsDistance.Bottom >=
                    Dest.Top + Dest.NempRegionsDistance.Top - distance)

          AND IntervalOverlap(Message.WindowPos.x + Source.NempRegionsDistance.Left,
                    Message.WindowPos.x + Source.NempRegionsDistance.Right,
                    Dest.Left + Dest.NempRegionsDistance.Left,
                    Dest.Left + Dest.NempRegionsDistance.Right)
         then begin
              Message.WindowPos.y := Dest.Top + Dest.NempRegionsDistance.Top
              - Source.NempRegionsDistance.Bottom;
              result := True;
         end

      else // Änderung

      // Untere Quellkante an untere Zielkante
      if      (Message.WindowPos.y + Source.NempRegionsDistance.Bottom <=
                    Dest.Top + Dest.NempRegionsDistance.Bottom + distance)
          AND
              (Message.WindowPos.y + Source.NempRegionsDistance.Bottom >=
                    Dest.Top + Dest.NempRegionsDistance.Bottom - distance)

          AND IntervalOverlap(Message.WindowPos.x + Source.NempRegionsDistance.Left,
                    Message.WindowPos.x + Source.NempRegionsDistance.Right,
                    Dest.Left + Dest.NempRegionsDistance.Left,
                    Dest.Left + Dest.NempRegionsDistance.Right)
         then begin
              Message.WindowPos.y := Dest.Top + Dest.NempRegionsDistance.Bottom
              - Source.NempRegionsDistance.Bottom;
              result := True;
         end

      ;
      //else // !!!!!!!!!!!!!!!!!!!!!!   nö.

      //links-rechts

      // Linke Quellkante an rechte Zielkante
      if      (Message.WindowPos.x + Source.NempRegionsDistance.Left <=
                    Dest.Left + Dest.NempRegionsDistance.Right + distance)
          AND
              (Message.WindowPos.x + Source.NempRegionsDistance.Left >=
                    Dest.Left + Dest.NempRegionsDistance.Right - distance)

          AND IntervalOverlap(Message.WindowPos.y + Source.NempRegionsDistance.Top,
                    Message.WindowPos.y + Source.NempRegionsDistance.Bottom,
                    Dest.Top + Dest.NempRegionsDistance.Top,
                    Dest.Top + Dest.NempRegionsDistance.Bottom)
         then begin
              Message.WindowPos.x := Dest.Left + Dest.NempRegionsDistance.Right
              - Source.NempRegionsDistance.Left;
              result := True;
         end

      else // Änderung

      // Linke Quellkante an linke Zielkante
      if      (Message.WindowPos.x + Source.NempRegionsDistance.Left <=
                    Dest.Left + Dest.NempRegionsDistance.Left + distance)
          AND
              (Message.WindowPos.x + Source.NempRegionsDistance.Left >=
                    Dest.Left + Dest.NempRegionsDistance.Left - distance)

          AND IntervalOverlap(Message.WindowPos.y + Source.NempRegionsDistance.Top,
                    Message.WindowPos.y + Source.NempRegionsDistance.Bottom,
                    Dest.Top + Dest.NempRegionsDistance.Top,
                    Dest.Top + Dest.NempRegionsDistance.Bottom)
         then begin
              Message.WindowPos.x := Dest.Left + Dest.NempRegionsDistance.Left
              - Source.NempRegionsDistance.Left;
              result := True;
         end

      else // Änderung

      // Rechte Quellkante an linke Zielkante
      if      (Message.WindowPos.x + Source.NempRegionsDistance.Right <=
                    Dest.Left + Dest.NempRegionsDistance.Left + distance)
          AND
              (Message.WindowPos.x + Source.NempRegionsDistance.Right >=
                    Dest.Left + Dest.NempRegionsDistance.Left - distance)

          AND IntervalOverlap(Message.WindowPos.y + Source.NempRegionsDistance.Top,
                    Message.WindowPos.y + Source.NempRegionsDistance.Bottom,
                    Dest.Top + Dest.NempRegionsDistance.Top,
                    Dest.Top + Dest.NempRegionsDistance.Bottom)
         then begin
              Message.WindowPos.x := Dest.Left + Dest.NempRegionsDistance.Left
              - Source.NempRegionsDistance.Right;
              result := True;
         end

      else // Änderung

      // Rechte Quellkante an rechte Zielkante
      if      (Message.WindowPos.x + Source.NempRegionsDistance.Right <=
                    Dest.Left + Dest.NempRegionsDistance.Right + distance)
          AND
              (Message.WindowPos.x + Source.NempRegionsDistance.Right >=
                    Dest.Left + Dest.NempRegionsDistance.Right - distance)

          AND IntervalOverlap(Message.WindowPos.y + Source.NempRegionsDistance.Top,
                    Message.WindowPos.y + Source.NempRegionsDistance.Bottom,
                    Dest.Top + Dest.NempRegionsDistance.Top,
                    Dest.Top + Dest.NempRegionsDistance.Bottom)
         then begin
              Message.WindowPos.x := Dest.Left + Dest.NempRegionsDistance.Right
              - Source.NempRegionsDistance.Right;
              result := True;
         end;
  end;

  if Message.WindowPos.cx < Source.Constraints.Minwidth then
    Message.WindowPos.cx := Source.Constraints.Minwidth;

  if Message.WindowPos.cy < Source.Constraints.MinHeight then
    Message.WindowPos.cy := Source.Constraints.MinHeight;

  if (Message.WindowPos.cx > Source.Constraints.Maxwidth)
    AND (Source.Constraints.MaxWidth > 0)  then
        Message.WindowPos.cx := Source.Constraints.Maxwidth;

  if (Message.WindowPos.cy > Source.Constraints.MaxHeight)
    AND (Source.Constraints.MaxHeight > 0) then
        Message.WindowPos.cy := Source.Constraints.MaxHeight;
end;




function IsDocked2(Source: TNempForm; Dest: TNempForm): Boolean;
const
  distance = 10;
begin

  result := false;
  if Dest = NIL then
  begin
    // nothing
  end
  else // if Dest = Form1 then
  begin
      if Dest.Visible then
      begin
                // Obere Quellkante an untere Zielkante
                if      (Source.Top + Source.NempRegionsDistance.Top <=
                              Dest.Top + Dest.NempRegionsDistance.Bottom + distance)
                    AND
                        (Source.Top + Source.NempRegionsDistance.Top >=
                              Dest.Top + Dest.NempRegionsDistance.Bottom - distance)

                    AND IntervalOverlap(Source.Left + Source.NempRegionsDistance.Left,
                              Source.Left + Source.NempRegionsDistance.Right,
                              Dest.Left + Dest.NempRegionsDistance.Left,
                              Dest.Left + Dest.NempRegionsDistance.Right)
                   then begin
                         // Message.YPos := Dest.Top + Dest.NempRegionsDistance.Bottom
                         //   - Source.NempRegionsDistance.Top;
                        result := True;
                   end;

                // Obere Quellkante an obere Zielkante
                if      (Source.Top + Source.NempRegionsDistance.Top <=
                              Dest.Top + Dest.NempRegionsDistance.Top + distance)
                    AND
                        (Source.Top + Source.NempRegionsDistance.Top >=
                              Dest.Top + Dest.NempRegionsDistance.Top - distance)

                    AND IntervalOverlap(Source.Left + Source.NempRegionsDistance.Left,
                              Source.Left + Source.NempRegionsDistance.Right,
                              Dest.Left + Dest.NempRegionsDistance.Left,
                              Dest.Left + Dest.NempRegionsDistance.Right)
                   then begin
                       // Message.YPos := Dest.Top + Dest.NempRegionsDistance.Top
                       // - Source.NempRegionsDistance.Top;
                        result := True;
                   end;

                // Untere Quellkante an obere Zielkante
                if      (Source.Top + Source.NempRegionsDistance.Bottom <=
                              Dest.Top + Dest.NempRegionsDistance.Top + distance)
                    AND
                        (Source.Top + Source.NempRegionsDistance.Bottom >=
                              Dest.Top + Dest.NempRegionsDistance.Top - distance)

                    AND IntervalOverlap(Source.Left + Source.NempRegionsDistance.Left,
                              Source.Left + Source.NempRegionsDistance.Right,
                              Dest.Left + Dest.NempRegionsDistance.Left,
                              Dest.Left + Dest.NempRegionsDistance.Right)
                   then begin
                       // Message.YPos := Dest.Top + Dest.NempRegionsDistance.Top
                       // - Source.NempRegionsDistance.Bottom;
                        result := True;
                   end;

                // Untere Quellkante an untere Zielkante
                if      (Source.Top + Source.NempRegionsDistance.Bottom <=
                              Dest.Top + Dest.NempRegionsDistance.Bottom + distance)
                    AND
                        (Source.Top + Source.NempRegionsDistance.Bottom >=
                              Dest.Top + Dest.NempRegionsDistance.Bottom - distance)

                    AND IntervalOverlap(Source.Left + Source.NempRegionsDistance.Left,
                              Source.Left + Source.NempRegionsDistance.Right,
                              Dest.Left + Dest.NempRegionsDistance.Left,
                              Dest.Left + Dest.NempRegionsDistance.Right)
                   then begin
                       // Message.YPos := Dest.Top + Dest.NempRegionsDistance.Bottom
                       // - Source.NempRegionsDistance.Bottom;
                        result := True;
                   end;

                //links-rechts

                // Linke Quellkante an rechte Zielkante
                if      (Source.Left + Source.NempRegionsDistance.Left <=
                              Dest.Left + Dest.NempRegionsDistance.Right + distance)
                    AND
                        (Source.Left + Source.NempRegionsDistance.Left >=
                              Dest.Left + Dest.NempRegionsDistance.Right - distance)

                    AND IntervalOverlap(Source.Top + Source.NempRegionsDistance.Top,
                              Source.Top + Source.NempRegionsDistance.Bottom,
                              Dest.Top + Dest.NempRegionsDistance.Top,
                              Dest.Top + Dest.NempRegionsDistance.Bottom)
                   then begin
                        //Message.XPos := Dest.Left + Dest.NempRegionsDistance.Right
                        //- Source.NempRegionsDistance.Left;
                        result := True;
                   end;

                // Linke Quellkante an linke Zielkante
                if      (Source.Left + Source.NempRegionsDistance.Left <=
                              Dest.Left + Dest.NempRegionsDistance.Left + distance)
                    AND
                        (Source.Left + Source.NempRegionsDistance.Left >=
                              Dest.Left + Dest.NempRegionsDistance.Left - distance)

                    AND IntervalOverlap(Source.Top + Source.NempRegionsDistance.Top,
                              Source.Top + Source.NempRegionsDistance.Bottom,
                              Dest.Top + Dest.NempRegionsDistance.Top,
                              Dest.Top + Dest.NempRegionsDistance.Bottom)
                   then begin
                        //Message.XPos := Dest.Left + Dest.NempRegionsDistance.Left
                        //- Source.NempRegionsDistance.Left;
                        result := True;
                   end;

                // Rechte Quellkante an linke Zielkante
                if      (Source.Left + Source.NempRegionsDistance.Right <=
                              Dest.Left + Dest.NempRegionsDistance.Left + distance)
                    AND
                        (Source.Left + Source.NempRegionsDistance.Right >=
                              Dest.Left + Dest.NempRegionsDistance.Left - distance)

                    AND IntervalOverlap(Source.Top + Source.NempRegionsDistance.Top,
                              Source.Top + Source.NempRegionsDistance.Bottom,
                              Dest.Top + Dest.NempRegionsDistance.Top,
                              Dest.Top + Dest.NempRegionsDistance.Bottom)
                   then begin
                       // Message.XPos := Dest.Left + Dest.NempRegionsDistance.Left
                        //- Source.NempRegionsDistance.Right;
                        result := True;
                   end;

                // Rechte Quellkante an rechte Zielkante
                if      (Source.Left + Source.NempRegionsDistance.Right <=
                              Dest.Left + Dest.NempRegionsDistance.Right + distance)
                    AND
                        (Source.Left + Source.NempRegionsDistance.Right >=
                              Dest.Left + Dest.NempRegionsDistance.Right - distance)

                    AND IntervalOverlap(Source.Top + Source.NempRegionsDistance.Top,
                              Source.Top + Source.NempRegionsDistance.Bottom,
                              Dest.Top + Dest.NempRegionsDistance.Top,
                              Dest.Top + Dest.NempRegionsDistance.Bottom)
                   then begin
                        //Message.XPos := Dest.Left + Dest.NempRegionsDistance.Right
                        //- Source.NempRegionsDistance.Right;
                        result := True;
                   end;
      end;

  end;

end;

procedure FormPosAndSizeCorrect(aForm: TNempForm);
var XMax, YMax: Integer;
begin

  //Größen korrekturen
  if aForm.NempRegionsDistance.Bottom > Screen.WorkAreaHeight then
    aForm.Height := Screen.WorkAreaHeight;

  if aForm.NempRegionsDistance.Right > Screen.WorkAreaWidth then
    aForm.Width := Screen.WorkAreaWidth;

  XMax := Screen.DesktopLeft + Screen.DesktopWidth;
  YMax := Screen.DesktopTop + Screen.DesktopHeight;
  // Positionskorrekturen
  // Zu weit unten?
  if aForm.Top + aForm.NempRegionsDistance.Top > YMax - 50 then
  begin
    aForm.Top := YMax - aForm.NempRegionsDistance.Bottom;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit rechts?
  if aForm.Left + aForm.NempRegionsDistance.Left > XMax - 20 then
  begin
    aForm.Left := XMax - aForm.NempRegionsDistance.Right;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit links?
  if aForm.Left + aForm.NempRegionsDistance.Right < Screen.DesktopLeft + 20 then
  begin
    aForm.Left := Screen.DesktopLeft - aForm.NempRegionsDistance.Left;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit oben?
  if aForm.Top + aForm.NempRegionsDistance.Top  < Screen.DesktopTop + 10 then
  begin
    aForm.Top := Screen.DesktopTop - aForm.NempRegionsDistance.Top;
    aForm.NempRegionsDistance.docked := False;
  end;

  aForm.NempRegionsDistance.RelativPositionX := aForm.Left - NempOptions.FormPositions[nfMainMini].Left;
  aForm.NempRegionsDistance.RelativPositionY := aForm.Top - NempOptions.FormPositions[nfMainMini].Top;
end;

Procedure ReInitRelativePositions;
begin
  if PlaylistForm.Visible then
  begin
    PlaylistForm.NempRegionsDistance.RelativPositionX := PlaylistForm.Left - NempOptions.FormPositions[nfMainMini].Left;
    PlaylistForm.NempRegionsDistance.RelativPositionY := PlaylistForm.Top - NempOptions.FormPositions[nfMainMini].Top;
  end;

  if MedienlisteForm.Visible then
  begin
    MedienlisteForm.NempRegionsDistance.RelativPositionX := MedienlisteForm.Left - NempOptions.FormPositions[nfMainMini].Left;
    MedienlisteForm.NempRegionsDistance.RelativPositionY := MedienlisteForm.Top - NempOptions.FormPositions[nfMainMini].Top;
  end;

  if AuswahlForm.Visible then
  begin
    AuswahlForm.NempRegionsDistance.RelativPositionX := AuswahlForm.Left - NempOptions.FormPositions[nfMainMini].Left;
    AuswahlForm.NempRegionsDistance.RelativPositionY := AuswahlForm.Top - NempOptions.FormPositions[nfMainMini].Top;
  end;

  if ExtendedControlForm.Visible then
  begin
    ExtendedControlForm.NempRegionsDistance.RelativPositionX := ExtendedControlForm.Left - NempOptions.FormPositions[nfMainMini].Left;
    ExtendedControlForm.NempRegionsDistance.RelativPositionY := ExtendedControlForm.Top - NempOptions.FormPositions[nfMainMini].Top;
  end;

end;

procedure ReInitDocks;
var fp, fm, fa, fe,
    ma, mp, me, //mf,af,pf
    am, ap, ae,
    pa, pm, pe,
    ea, em, ep: Boolean;
    i: Integer;
begin
    fp := IsDocked2(Nemp_MainForm, PlaylistForm) and PlaylistForm.Visible;
    fm := IsDocked2(Nemp_MainForm, MedienlisteForm) and MedienlisteForm.Visible;
    fa := IsDocked2(Nemp_MainForm, AuswahlForm) and AuswahlForm.Visible;
    fe := IsDocked2(Nemp_MainForm, ExtendedControlForm) and ExtendedControlForm.Visible;

    ma := IsDocked2(MedienlisteForm, AuswahlForm) and AuswahlForm.Visible;
    mp := IsDocked2(MedienlisteForm, PlaylistForm) and PlaylistForm.Visible;
    me := IsDocked2(MedienlisteForm, ExtendedControlForm) and ExtendedControlForm.Visible;

    ap := IsDocked2(AuswahlForm, PlaylistForm) and PlaylistForm.Visible;
    am := IsDocked2(AuswahlForm, MedienlisteForm) and MedienlisteForm.Visible;
    ae := IsDocked2(AuswahlForm, ExtendedControlForm) and ExtendedControlForm.Visible;

    pa := IsDocked2(PlaylistForm, AuswahlForm) and AuswahlForm.Visible;
    pm := IsDocked2(PlaylistForm, MedienlisteForm) and MedienlisteForm.Visible;
    pe := IsDocked2(PlaylistForm, ExtendedControlForm) and ExtendedControlForm.Visible;

    ea := IsDocked2(ExtendedControlForm, AuswahlForm) and AuswahlForm.Visible;
    em := IsDocked2(ExtendedControlForm, MedienlisteForm) and MedienlisteForm.Visible;
    ep := IsDocked2(ExtendedControlForm, PlaylistForm) and PlaylistForm.Visible;

    // Idee hinter diesen Konstrukten:
    // Wie kann ich eine Verbindung zu Playlistform bringen?
    // bzw. Wann soll diese als gedockt gelten?
    // Wenn man direkt andockt, oder wenn man an eine Form andockt, die mit der Playlistform verbunden ist !!

    // Jetzt: Weitere Verbindungen suchen
    for i := 1 to 4 do
    begin
        // 1. e andocken
        if (fa and ae) or (fm and me) or (fp and pe) then
            fe := True;
        // 2. a andocken
        if (fe and ea) or (fp and pa) or (fm and ma) then
            fa := True;
        // 3. p andocken
        if (fa and ap) or (fe and ep) or (fm and mp) then
            fp := True;
        // 4. m andocken
        if (fa and am) or (fe and em) or (fp and pm) then
            fm := True;
    end;

    PlaylistForm.NempRegionsDistance       .docked := PlaylistForm       .Visible AND fp ;
    AuswahlForm.NempRegionsDistance        .docked := Auswahlform        .Visible AND fa ;
    MedienlisteForm.NempRegionsDistance    .docked := MedienlisteForm    .Visible AND fm ;
    ExtendedControlForm.NempRegionsDistance.docked := ExtendedControlForm.Visible AND fe;
end;

function GetResizeDirection(Sender: TObject; Shift: TShiftState; X, Y: Integer):Cardinal;
begin
    if (x < 8) and (y < 8) then
    begin
      // links oben
      (Sender as TControl).Cursor := crSizeNWSE;
      Result := SC_SIZE or WMSZ_TOPLEFT;
    end
    else
    if (x < 8) and (y < (Sender as TControl).Height - 8) then
    begin
      // links mitte
      (Sender as TControl).Cursor := crSizeWE;
      Result := SC_SIZE or WMSZ_LEFT;
    end
    else
    if (x < 8) then
    begin
      // links unten
      (Sender as TControl).Cursor := crSizeNESW;
      Result := SC_SIZE or WMSZ_BOTTOMLEFT;
    end
    else
    if (x < (Sender as TControl).Width - 8) AND (y < 8) then
    begin
      // mitte oben
      (Sender as TControl).Cursor := crSizeNS;
      Result := SC_SIZE or WMSZ_TOP;
    end
    else
    if (x < (Sender as TControl).Width - 8) then
    begin
      // mitte unten (egal)
      (Sender as TControl).Cursor := crSizeNS;
      Result := SC_SIZE or WMSZ_BOTTOM;
    end
    else
    if (y < 8) then
    begin
      // rechts oben
      (Sender as TControl).Cursor := crSizeNESW;
      Result := SC_SIZE or WMSZ_TOPRIGHT;
    end
    else
    if (y < (Sender as TControl).Height - 8) then
    begin
      // rechts mitte
      (Sender as TControl).Cursor := crSizeWE;
      Result := SC_SIZE or WMSZ_RIGHT;
    end
    else
    begin
      // rechts unten
      (Sender as TControl).Cursor := crSizeNWSE;
      Result := SC_SIZE or WMSZ_BOTTOMRIGHT;
    end;

end;


procedure SwapWindowMode(newMode: Integer);
begin
    with Nemp_MainForm do
    begin
        // save current settings
        SaveWindowPosition(NempOptions.AnzeigeMode);
        if NempOptions.AnzeigeMode = 1 then
        begin
          AuswahlForm.SaveWindowPosition;
          ExtendedControlForm.SaveWindowPosition;
          MedienlisteForm.SaveWindowPosition;
          PlaylistForm.SaveWindowPosition;
        end;
        // write current settings to disk
        NempSettingsManager.WriteToDisk;

        newMode := newMode mod 2;
        if newMode = 1 then
            // Party-mode in Separate-Window-Mode is not allowed.
            NempSkin.NempPartyMode.Active := False;

        UpdateFormDesignNeu(newMode);
    end;

    if (newMode = 1) and assigned(MainFormBuilder) then
        MainFormBuilder.Close;
end;


procedure FixScrollbar;
begin
    with Nemp_MainForm do
    begin
        SlidebarShape.Left := 95;
        SlidebarShape.Width := NewPlayerPanel.Width - 95 - 58;
        BtnClose.Left      := NewPlayerPanel.Width - 18;
        BtnMinimize.Left   := BtnClose.Left - 18;
        PaintFrame.Left    := NewPlayerPanel.Width - 84;
        PlayerTimeLbl.Left := NewPlayerPanel.Width - 43;
    end;
end;


procedure SplitMainForm;
begin
    with Nemp_MainForm do
    begin

        NempFormBuildOptions.NilConstraints;
        Constraints.MinWidth := 0;
        Constraints.MinHeight := 10;

        _VSTPanel.OnResize := Nil;
        _TopMainPanel.OnResize := Nil;

        _VSTPanel    .Align := alNone;
        _TopMainPanel.Align := alNone;

        _VSTPanel.Visible := False;
        _TopMainPanel.Visible := False;
        MainSplitter.Visible := False;
    end;

        // Set Size/position of the Mini-MainForm
        Nemp_MainForm.Borderstyle := bsNone;
        Nemp_MainForm.Top     := NempOptions.FormPositions[nfMainMini].Top;
        Nemp_MainForm.Left    := NempOptions.FormPositions[nfMainMini].Left;
        Nemp_MainForm.Width   := NempOptions.FormPositions[nfMainMini].Width;
        Nemp_MainForm.Height  := Nemp_MainForm._ControlPanel.Height + 4;

    with Nemp_MainForm do
    begin
        // Set Size and Position of the ControlPanel
        _ControlPanel.Parent := __MainContainerPanel;
        _ControlPanel.Align := alNone;
        _ControlPanel.Left := 4;
        _ControlPanel.Width := __MainContainerPanel.Width - 8;
        _ControlPanel.Top  := 2;
        _ControlPanel.Anchors := [akLeft, akRight, akTop];

        // Constraints
        Constraints.MaxHeight := Height;
        Constraints.MinHeight := Height;
        if NempFormBuildOptions.ControlPanelTwoRows then
            Constraints.MinWidth := 214
        else
            Constraints.MinWidth := 400;

        FixScrollbar;

        // show other forms
        if NempOptions.FormPositions[nfPlaylist].Visible then
            PlaylistForm.Show
        else
            PlaylistForm.Hide;
        PlaylistPanel.Parent  := PlaylistForm.ContainerPanelPlaylistForm;
        PlaylistPanel.Align   := alNone;
        PlaylistPanel.Left    := 7;
        PlaylistPanel.Width   := PlaylistForm.ContainerPanelPlaylistForm.Width - 14;
        PlaylistPanel.Top     := 2;
        PlaylistPanel.Height  := PlaylistForm.ContainerPanelPlaylistForm.Height - 9;
        PlaylistPanel.Anchors := [akleft, aktop, akright, akBottom];
        PlaylistForm.FormResize(Nil);
        PlaylistForm.FormShow(Nil);


        if NempOptions.FormPositions[nfBrowse].Visible then
            AuswahlForm.Show
        else
            AuswahlForm.Hide;
        AuswahlPanel.Parent := AuswahlForm.ContainerPanelAuswahlform;
        AuswahlPanel.Align   := alNone;
        AuswahlPanel.Left    := 7;
        AuswahlPanel.Width   := AuswahlForm.ContainerPanelAuswahlform.Width - 14;
        AuswahlPanel.Top     := 2;
        AuswahlPanel.Height  := AuswahlForm.ContainerPanelAuswahlform.Height - 9;
        AuswahlPanel.Anchors := [akleft, aktop, akright, akBottom];
        AuswahlForm.FormResize(Nil);
        AuswahlForm.FormShow(Nil);


        if NempOptions.FormPositions[nfMediaLibrary].Visible then
            MedienlisteForm.Show
        else
            MedienlisteForm.Hide;
        MedialistPanel.Parent  := MedienlisteForm;
        MedialistPanel.Align   := alNone;
        MedialistPanel.Left    := 7;
        MedialistPanel.Width   := MedienListeForm.ContainerPanelMedienBibForm.Width - 14;
        MedialistPanel.Top     := 2;
        MedialistPanel.Height  := MedienListeForm.ContainerPanelMedienBibForm.Height - 9;
        MedialistPanel.Anchors := [akleft, aktop, akright, akBottom];
        MedienlisteForm.FormResize(Nil);
        MedienlisteForm.FormShow(Nil);

        if NempOptions.FormPositions[nfExtendedControls].Visible then
            ExtendedControlForm.Show
        else
            ExtendedControlForm.Hide;
        MedienBibDetailPanel.Parent  := ExtendedControlForm;
        MedienBibDetailPanel.Align   := alNone;
        MedienBibDetailPanel.Left    := 7;
        MedienBibDetailPanel.Width   := ExtendedControlForm.ContainerPanelExtendedControlsForm.Width - 14;
        MedienBibDetailPanel.Top     := 2;
        MedienBibDetailPanel.Height  := ExtendedControlForm.ContainerPanelExtendedControlsForm.Height - 9;
        MedienBibDetailPanel.Anchors := [akleft, aktop, akright, akBottom];
        ExtendedControlForm.FormResize(Nil);
        ExtendedControlForm.FormShow(Nil);

        // Set OnMouseEvents for Dragging the forms
        PlaylistFillPanel.OnMouseDown := PlaylistForm.OnMouseDown;
        PlayListStatusLBL.OnMouseDown := PlaylistForm.OnMouseDown;
        PlaylistFillPanel.OnMouseMove := PlaylistForm.OnMouseMove;
        PlayListStatusLBL.OnMouseMove := PlaylistForm.OnMouseMove;
        PlaylistFillPanel.OnMouseUP := PlaylistForm.OnMouseUP;
        PlayListStatusLBL.OnMouseUP   := PlaylistForm.OnMouseUP;

        AuswahlFillPanel  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlStatusLBL  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlFillPanel  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlStatusLBL  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlFillPanel  .OnMouseUp := AuswahlForm.OnMouseUp;
        AuswahlStatusLBL  .OnMouseUp := AuswahlForm.OnMouseUp;

        MedienListeFillPanel.OnMouseDown := MedienlisteForm.OnMouseDown;
        MedienListeStatusLBL.OnMouseDown := MedienlisteForm.OnMouseDown;
        MedienListeFillPanel.OnMouseMove := MedienlisteForm.OnMouseMove;
        MedienListeStatusLBL.OnMouseMove := MedienlisteForm.OnMouseMove;
        MedienListeFillPanel.OnMouseUP := MedienlisteForm.OnMouseUP;
        MedienListeStatusLBL.OnMouseUP := MedienlisteForm.OnMouseUP;

        MedienBibDetailFillPanel      .OnMouseDown := ExtendedControlForm.OnMouseDown;
        MedienBibDetailStatusLbl      .OnMouseDown := ExtendedControlForm.OnMouseDown;
        MedienBibDetailFillPanel      .OnMouseMove := ExtendedControlForm.OnMouseMove;
        MedienBibDetailStatusLbl      .OnMouseMove := ExtendedControlForm.OnMouseMove;
        MedienBibDetailFillPanel      .OnMouseUP := ExtendedControlForm.OnMouseUP;
        MedienBibDetailStatusLbl      .OnMouseUP := ExtendedControlForm.OnMouseUP;

        // EditPlaylistSearchExit(Nil);
        EDITFastSearchExit(Nil);
    end;
end;

procedure JoinMainForm;
begin

  with Nemp_MainForm do
  begin
    AuswahlFillPanel.Width := AuswahlPanel.Width - AuswahlFillPanel.Left;
    AuswahlPanel.Align := alNone;
    AuswahlPanel.Left := 0;
    AuswahlPanel.Parent := _TopMainPanel;

    PlaylistPanel.Align := alNone;
    PlaylistPanel.Parent := _TopMainPanel;

    MedialistPanel.Align := alNone;
    MedialistPanel.Parent := _VSTPanel;

    MedienBibDetailPanel.Align := alNone;
    MedienBibDetailPanel.Parent := _VSTPanel;

    if NempSkin.NempPartyMode.Active then
        EditFastSearch.Width := Round(194 * NempSkin.NempPartyMode.ResizeFactor)
    else
        EditFastSearch.Width := 194;
    MedienlisteFillPanel.Left := EditFastSearch.Left + EditFastSearch.Width + 6;
    MedienlisteFillPanel.Width := MedialistPanel.Width - MedienlisteFillPanel.Left;// - 8;
    MedienListeStatusLBL.Width := MedienlisteFillPanel.Width - 16;


    if NempSkin.NempPartyMode.Active then
        EditplaylistSearch.Width := Round(65 * NempSkin.NempPartyMode.ResizeFactor)
    else
        EditplaylistSearch.Width := 65;

    //PlaylistFillPanel.Left := EditplaylistSearch.Left + EditplaylistSearch.Width + 6;
    //PlaylistFillPanel.Width := PlaylistPanel.Width - PlaylistFillPanel.Left;// - 8;
    //PlayListStatusLBL.Width := PlaylistFillPanel.Width - 16;

    // set Resize-Handler again
    /// Nemp_MainForm.OnResize := FormResize;
    _VSTPanel.OnResize     := _TopMainPanelResize;
    _TopMainPanel.OnResize := _TopMainPanelResize;

    MainSplitter.Visible := True;
    _VSTPanel.Visible := False;
    _TopMainPanel.Visible := False;

      //__MainContainerPanel.Constraints.MinHeight := 0;
      Height := _ControlPanel.Height + 2;
      Constraints.MaxHeight := 0;
      Constraints.MinWidth := 800;
      Constraints.MinHeight := 600;

      //Nemp_MainForm.OnResize := FormResize;
      Nemp_MainForm.Borderstyle := bsSizeable;

    FixScrollbar;


    if Medienlisteform.visible then Medienlisteform.Close;
    if Playlistform.visible then Playlistform.Close;
    if Auswahlform.Visible then Auswahlform.Close;
    if ExtendedControlForm.visible then ExtendedControlForm.Close;

    // to be sure: set the Parent here as well
    Auswahlform.CloseImageA.Parent := Auswahlform.ContainerPanelAuswahlform;
    Medienlisteform.CloseImageM.Parent := Medienlisteform.ContainerPanelMedienBibForm;
    Playlistform.CloseImageP.Parent := Playlistform.ContainerPanelPlaylistForm;
    ExtendedControlForm.CloseImageE.Parent := ExtendedControlForm.ContainerPanelExtendedControlsForm;

    PlaylistFillPanel.OnMouseDown := NIL;
    PlayListStatusLBL.OnMouseDown := Nil;
    PlaylistFillPanel.OnMouseMove := NIL;
    PlayListStatusLBL.OnMouseMove := Nil;
    PlaylistFillPanel.OnMouseUP   := Nil;
    PlayListStatusLBL.OnMouseUP   := Nil;

    AuswahlFillPanel  .OnMouseDown := Nil;
    AuswahlStatusLBL  .OnMouseDown := Nil;
    AuswahlFillPanel  .OnMouseMove := Nil;
    AuswahlStatusLBL  .OnMouseMove := Nil;
    AuswahlFillPanel  .OnMouseUP   := Nil;
    AuswahlStatusLBL  .OnMouseUP   := Nil;

    MedienListeFillPanel.OnMouseDown := NIL;
    MedienListeStatusLBL.OnMouseDown := Nil;
    MedienListeFillPanel.OnMouseMove := NIL;
    MedienListeStatusLBL.OnMouseMove := Nil;
    MedienListeFillPanel.OnMouseUP   := Nil;
    MedienListeStatusLBL.OnMouseUP   := Nil;

    MedienBibDetailFillPanel      .OnMouseDown := NIL;
    MedienBibDetailStatusLbl      .OnMouseDown := Nil;
    MedienBibDetailFillPanel      .OnMouseMove := NIL;
    MedienBibDetailStatusLbl      .OnMouseMove := Nil;
    MedienBibDetailFillPanel      .OnMouseUP   := Nil;
    MedienBibDetailStatusLbl      .OnMouseUP   := Nil;

    //EditPlaylistSearchExit(Nil);
    EDITFastSearchExit(Nil);
  end;
end;


procedure UpdateSmallMainForm;
var //formregion,
  xpbottom, xptop, xpleft, xpright: integer;
  aPoint: TPoint;
begin

    with Nemp_MainForm do
    begin
        aPoint := __MainContainerPanel.ClientToParent(Point(0,0), Nemp_MainForm );

        xpleft   := {GetSystemMetrics(SM_CXFrame) + + - 2} + aPoint.X ;
        xptop    := aPoint.Y;
                             {
        GetSystemMetrics(SM_CYCAPTION)
              + GetSystemMetrics(SM_CYBORDER) - 2
              + GetSystemMetrics(SM_CYFrame) - 1
              + aPoint.Y ;     }


        //xpleft   := GetSystemMetrics(SM_CXFrame) {+ - 2} + _ControlPanel.Left ;
        //xptop    := GetSystemMetrics(SM_CYCAPTION)  - 2 + GetSystemMetrics(SM_CYFrame) + _ControlPanel.Top ;
        xpright  := xpleft + width; //_ControlPanel.Width {+ 1} {+ 4};// - 1 + 4;
        xpbottom := xptop + height; //_ControlPanel.Height  {+ 4};// - 1 + 3;

        //formRegion := CreateRectRgn (xpleft, xptop, xpright, xpbottom );

        NempRegionsDistance.Top := xptop;
        NempRegionsDistance.Left := xpleft;
        NempRegionsDistance.Right := xpright ;
        NempRegionsDistance.Bottom := xpbottom ;

        // Regions setzen
        // SetWindowRgn( handle, formregion, true );
        stopBtn.BringToFront;
    end;
end;

procedure UpdateFormDesignNeu(newMode: Integer);
begin
  with Nemp_MainForm do
  begin
      LockWindowUpdate (CoverScrollbar.Handle);

      // one attempt to get rid of several AV with this scrollbar
      //CoverScrollbar.Visible := False;
      SnapActive := False;

      // Beim ersten Mal nach Start der Anwendung nicht tun!!
      //02.2017 // Bug mit MAXIMIZED-Over Taskleiste????
      if Tag in [0,1] then
      begin
          NempOptions.MainFormMaximized := WindowState=wsMaximized;
          WindowState := wsNormal;
          // aktuelle Aufteilung speichern
          if Tag = 0 then
          begin
              NempOptions.FormPositions[nfMain].Top   := Top ;
              NempOptions.FormPositions[nfMain].Left  := Left;
              NempOptions.FormPositions[nfMain].Height:= Height;
              NempOptions.FormPositions[nfMain].Width := Width;
          end else
          begin
              NempOptions.FormPositions[nfMainMini].Top   := Top ;
              NempOptions.FormPositions[nfMainMini].Left  := Left;
              NempOptions.FormPositions[nfMainMini].Height:= Height;
              NempOptions.FormPositions[nfMainMini].Width := Width;
          end;
      end;

      // Zuerst: HauptMenü anzeigen // ausblenden
      // Das macht das Setzen Der Regions im Einzelfenster-Modus einfacher.
      if newMode = 1 then
          Nemp_MainForm.Menu := NIL
      else
      begin
          if NOT NempSkin.HideMainMenu then
              Nemp_MainForm.Menu := Nemp_MainMenu;
      end;

      // Menu-Einträge Dis-/Enablen
      PM_P_ViewSeparateWindows_Equalizer.Enabled := newMode = 1;
      PM_P_ViewSeparateWindows_Playlist.Enabled := newMode = 1;
      PM_P_ViewSeparateWindows_Medialist.Enabled := newMode = 1;
      PM_P_ViewSeparateWindows_Browse.Enabled := newMode = 1;
      PM_P_ViewStayOnTop.Enabled := newMode = 1;

      MM_O_ViewSeparateWindows_Equalizer.Enabled := newMode = 1;
      MM_O_ViewSeparateWindows_Playlist.Enabled := newMode = 1;
      MM_O_ViewSeparateWindows_Medialist.Enabled := newMode = 1;
      MM_O_ViewSeparateWindows_Browse.Enabled := newMode = 1;
      MM_O_ViewStayOnTop.Enabled := newMode = 1;

      PM_P_ViewCompactComplete.Enabled := newMode = 0;
      MM_O_ViewCompactComplete.Enabled := newMode = 0;

      BtnClose.Visible := newMode = 1;
      BtnMinimize.Visible := newMode = 1;
      // temporary for this procedure
      PanelCoverBrowse.OnResize := Nil;

      NempOptions.Anzeigemode := NewMode;  // here ok?? (2019 rework, tmp comment

      case NempOptions.AnzeigeMode of
        0: begin
            // Compact view, all in one window
            if (Tag in [0,1]) then
                // not necessary on start, Mainform is designed in a "joined state"
                // basically: Put all the Panels back on the Mainform
                JoinMainForm;

            // after joining the MainForm: Apply the FormBuilder-Layout
            NempFormBuildOptions.BeginUpdate;
            NempFormBuildOptions.RefreshBothRowsOrColumns(False);
            NempFormBuildOptions.SwapMainLayout;
            NempFormBuildOptions.ApplyRatios;
            NempFormBuildOptions.EndUpdate;

            Top    := NempOptions.FormPositions[nfMain].Top ;
            Left   := NempOptions.FormPositions[nfMain].Left;
            Height := NempOptions.FormPositions[nfMain].Height;
            Width  := NempOptions.FormPositions[nfMain].Width;
        end;

        1: begin
            // Einzelfenster-Ansicht
            // at first start: Build two rows here for ControlPanel, if necessary
            if (Tag = -1) and NempFormBuildOptions.ControlPanelTwoRows then
                NempFormBuildOptions.RefreshControlPanel;
            SplitMainForm;
        end;
      end;

      // reactivate it again
      PanelCoverBrowse.OnResize := PanelCoverBrowseResize;
      //CoverScrollbar.WindowProc := bckup;
      //SendMessage( CoverScrollbar.Handle, WM_SETREDRAW, 1, 0);


      //Korrektur. Das ist manchmal nötig
      GRPBOXPlaylist.Left   := 4;
      GRPBOXPlaylist.Top    := 28;
      GRPBOXPlaylist.Height := PlaylistPanel.Height - 29;
      GRPBOXPlaylist.Width  := PlaylistPanel.Width - 12;
      PlaylistVST.Left := 8;
      PlaylistVST.Width := GRPBOXPlaylist.Width - 16;
      PlaylistVST.Top := 8;
      PlaylistVST.Height := GRPBOXPlaylist.Height - 16;
      PlaylistForm.FormResize(Nil);

      // 5. Constraints setzen
      {
      Constraints.MinHeight := NempOptions.NempFormAufteilung[AnzeigeMode].FormMinHeight;
      Constraints.MaxHeight := NempOptions.NempFormAufteilung[AnzeigeMode].FormMaxHeight;
      Constraints.MinWidth  := NempOptions.NempFormAufteilung[AnzeigeMode].FormMinWidth;
      Constraints.MaxWidth  := NempOptions.NempFormAufteilung[AnzeigeMode].FormMaxWidth;
      }

      if NempOptions.AnzeigeMode = 0 then
      begin
          //2019 _TopMainPanel.Constraints.MaxHeight := Height - 160;
          NempRegionsDistance.Top := 0;
          NempRegionsDistance.Bottom := height;
          NempRegionsDistance.Right := width;
          NempRegionsDistance.Left := 0;
          _TopMainPanel.Constraints.MinHeight := NempFormBuildOptions.MainPanelMinHeight;
          _TopMainPanel.Constraints.MinWidth := NempFormBuildOptions.MainPanelMinWidth;
      end
      else
      begin
          UpdateSmallMainForm;
      end;

      if Tag in [0,1] then
      begin
          FormPosAndSizeCorrect(Nemp_MainForm);
          FormPosAndSizeCorrect(AuswahlForm);
          FormPosAndSizeCorrect(PlaylistForm);
          FormPosAndSizeCorrect(MedienlisteForm);
          FormPosAndSizeCorrect(ExtendedControlForm);
          ReInitRelativePositions;
      end;

      {// Größenkorrekturen
      if (ArtistsVST.Width > AuswahlPanel.width - 40)
          OR (ArtistsVST.Width < 40) then
              ArtistsVST.Width := AuswahlPanel.width DIV 2;
      }

      SnapActive := True;

      if Tag = -1 then
      begin
          // Note:  WindowState := wsMaximized; MUST be set AFTER this!

          if NempOptions.AnzeigeMode = 0 then
          begin
              Top := NempOptions.FormPositions[nfMain].Top;
              Left := NempOptions.FormPositions[nfMain].Left;
          end else
          begin
              Top := NempOptions.FormPositions[nfMainMini].Top;
              Left := NempOptions.FormPositions[nfMainMini].Left;
          end;

          FormPosAndSizeCorrect(Nemp_MainForm);
          FormPosAndSizeCorrect(AuswahlForm);
          FormPosAndSizeCorrect(PlaylistForm);
          FormPosAndSizeCorrect(MedienlisteForm);
          FormPosAndSizeCorrect(ExtendedControlForm);
          ReInitRelativePositions;
          { removed december 2020
          if NempOptions.FixCoverFlowOnStart then
          begin
              // this is somehow needed on XP (or only in my virtual machine??)
              if _TopMainPanel.Height Mod 2 = 0 then
                  _TopMainPanel.Height := _TopMainPanel.Height + 1
              else
                  _TopMainPanel.Height := _TopMainPanel.Height - 1  ;
          end;
          }
      end;

      //02.2017 // MAXIMIZED-OVer TAskleiste????
      if (NempOptions.AnzeigeMode = 0) AND NempOptions.MainFormMaximized then
          WindowState := wsMaximized;

      if NempSkin.isActive then
          NempSkin.FitSkinToNewWindow;

      RepairZOrder;
      // evtl. Form neu zeichnen. Stichwort "Schwarze Ecken"

      // teilweise auskommentiert für Windows 7
      if (NempOptions.AnzeigeMode = 0) AND (Tag in [0,1]) then
      begin
          SetWindowRgn( handle, 0, Not _IsThemeActive );
          InvalidateRect(handle, NIL, TRUE);
      end;


      MM_O_ViewCompactComplete.Checked := NempOptions.AnzeigeMode = 0;
      PM_P_ViewCompactComplete.Checked := NempOptions.AnzeigeMode = 0;

      CorrectSkinRegionsTimer.Enabled := True;
      //Nemp_MainForm.CorrectSkinRegions;

      MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);
      // necessary on advanced skins
      ReAcceptDragFiles;

      Tag := NempOptions.AnzeigeMode;


      //CoverScrollbar.WindowProc := NewScrollBarWndProc;
      //SendMessage( CoverScrollbar.Handle, WM_SETREDRAW, 1, 0);
      //CoverScrollbar.StyleElements := [seFont,seClient,seBorder]
      // one attempt to get rid of several AV with this scrollbar
      //CoverScrollbar.Visible := True;

      LockWindowUpdate(0);
  end;
end;

procedure RevokeDragFiles;
begin
  RevokeDragDrop(Nemp_MainForm.PlayerControlPanel.Handle);
  RevokeDragDrop(Nemp_MainForm.GRPBOXArtistsAlben.Handle);
end;

procedure ReAcceptDragFiles;
begin
      DragAcceptFiles (PlaylistForm.Handle, True);
      DragAcceptFiles (AuswahlForm.Handle, True);
      DragAcceptFiles (MedienlisteForm.Handle, True);
      DragAcceptFiles (ExtendedControlForm.Handle, True);
      //DragAcceptFiles (Nemp_MainForm.Handle, True);
      //DragAcceptFiles(Nemp_MainForm._ControlPanel.Handle, True);
      RegisterDragDrop(Nemp_MainForm._ControlPanel.Handle, Nemp_MainForm.fDropManager as IDropTarget);
      //RegisterDragDrop(Nemp_MainForm.PanelCoverBrowse.Handle, Nemp_MainForm.fDropManager as IDropTarget);
      RegisterDragDrop(Nemp_MainForm.GRPBOXArtistsAlben.Handle, Nemp_MainForm.fDropManager as IDropTarget);

      {case RegisterDragDrop(Nemp_MainForm._ControlPanel.Handle, Nemp_MainForm.fDropManager as IDropTarget) of
      DRAGDROP_E_INVALIDHWND : ShowMessage('invalid');
      DRAGDROP_E_ALREADYREGISTERED : ShowMessage('already reg');
      E_OUTOFMEMORY : ShowMessage('outofmem');
       S_OK: ShowMessage('ok');
    end;}

end;

procedure PositionCloseImage(CloseBtn: TSkinButton; ParentPanel: TPanel);
begin
  CloseBtn.Left := ParentPanel.Width - CloseBtn.Width - 2;
  CloseBtn.Top := 4;
  CloseBtn.Parent := ParentPanel;
  CloseBtn.BringToFront;
end;



initialization

    SnapActive := False;

end.

