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
  {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF} , sysutils, System.Types, BaseForms, ActiveX, SkinButtons, MainFormlayout;

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
  procedure UpdateFormDesignNeu(newMode: Integer; NempStarting: Boolean = False);

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
        __MainContainerPanel.Constraints.MinHeight := 10;

        Constraints.MinWidth := 0;
        Constraints.MinHeight := 10;

        NempLayout.PrepareSplitForm;
        _ControlPanel.Align := alNone;
        _ControlPanel.Parent := __MainContainerPanel;

    end;
    // Set Size/position of the Mini-MainForm
    Nemp_MainForm.Borderstyle := bsNone;
    Nemp_MainForm.Top     := NempOptions.FormPositions[nfMainMini].Top;
    Nemp_MainForm.Left    := NempOptions.FormPositions[nfMainMini].Left;
    Nemp_MainForm.Width   := NempOptions.FormPositions[nfMainMini].Width;
    Nemp_MainForm.Height  := Nemp_MainForm._ControlPanel.Height + 4;

    with Nemp_MainForm do
    begin
        // Constraints
        //

        // show other forms
        PlaylistPanel.Parent  := PlaylistForm.pnlSplit;
        PlaylistPanel.Align   := alClient;
        if NempOptions.FormPositions[nfPlaylist].Visible then
          PlaylistForm.Show;
        // Browse
        TreePanel.Parent := AuswahlForm.pnlSplit;
        TreePanel.Align   := alClient;
        TreePanel.Visible := MedienBib.BrowseMode = 0;
        CoverFlowPanel.Parent := AuswahlForm.pnlSplit;
        CoverFlowPanel.Align   := alClient;
        CoverFlowPanel.Visible := MedienBib.BrowseMode = 1;
        CloudPanel.Parent := AuswahlForm.pnlSplit;
        CloudPanel.Align   := alClient;
        CloudPanel.Visible := MedienBib.BrowseMode = 2;
        if NempOptions.FormPositions[nfBrowse].Visible then
          AuswahlForm.Show;
        // MediaList
        MedialistPanel.Parent  := MedienlisteForm.pnlSplit;
        MedialistPanel.Visible := True;
        MedialistPanel.Align   := alClient;
        if NempOptions.FormPositions[nfMediaLibrary].Visible then
          MedienlisteForm.Show;
        // File Overview, "Details"
        MedienBibDetailPanel.Parent  := ExtendedControlForm.pnlSplit;
        MedienBibDetailPanel.Align   := alClient;
        MedienBibDetailPanel.Visible := True;
        if NempOptions.FormPositions[nfExtendedControls].Visible then
          ExtendedControlForm.Show;

        // Set Size and Position of the ControlPanel
        //_ControlPanel.Height := 100;
        _ControlPanel.Left := 4;
        _ControlPanel.Width := __MainContainerPanel.Width - 8;
        _ControlPanel.Top  := 2;
        _ControlPanel.Anchors := [akLeft, akRight, akTop];

        // Set OnMouseEvents for Dragging the forms
        PlaylistFillPanel.OnMouseDown := PlaylistForm.OnMouseDown;
        PlayListStatusLBL.OnMouseDown := PlaylistForm.OnMouseDown;
        PlaylistFillPanel.OnMouseMove := PlaylistForm.OnMouseMove;
        PlayListStatusLBL.OnMouseMove := PlaylistForm.OnMouseMove;
        PlaylistFillPanel.OnMouseUP := PlaylistForm.OnMouseUP;
        PlayListStatusLBL.OnMouseUP   := PlaylistForm.OnMouseUP;

        AuswahlFillPanel0  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlStatusLBL0  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlFillPanel0  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlStatusLBL0  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlFillPanel0  .OnMouseUp := AuswahlForm.OnMouseUp;
        AuswahlStatusLBL0  .OnMouseUp := AuswahlForm.OnMouseUp;

        AuswahlFillPanel1  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlStatusLBL1  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlFillPanel1  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlStatusLBL1  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlFillPanel1  .OnMouseUp := AuswahlForm.OnMouseUp;
        AuswahlStatusLBL1  .OnMouseUp := AuswahlForm.OnMouseUp;

        AuswahlFillPanel2  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlStatusLBL2  .OnMouseDown := AuswahlForm.OnMouseDown;
        AuswahlFillPanel2  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlStatusLBL2  .OnMouseMove := AuswahlForm.OnMouseMove;
        AuswahlFillPanel2  .OnMouseUp := AuswahlForm.OnMouseUp;
        AuswahlStatusLBL2  .OnMouseUp := AuswahlForm.OnMouseUp;

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


         Nemp_MainForm.Borderstyle := bsNone;
    Nemp_MainForm.Top     := NempOptions.FormPositions[nfMainMini].Top;
    Nemp_MainForm.Left    := NempOptions.FormPositions[nfMainMini].Left;
    Nemp_MainForm.Width   := NempOptions.FormPositions[nfMainMini].Width;
    Nemp_MainForm.Height  := Nemp_MainForm._ControlPanel.Height + 4;

    Constraints.MaxHeight := Height;
        //Constraints.MinHeight := Height;
        //if NempFormBuildOptions.ControlPanelTwoRows then
        //    Constraints.MinWidth := 214
        //else
            Constraints.MinWidth := 400;

        FixScrollbar;

        // EditPlaylistSearchExit(Nil);
        EDITFastSearchExit(Nil);
    end;
end;

procedure JoinMainForm;
begin
  with Nemp_MainForm do
  begin

    MedienListeControlPanel.Width := EditFastSearch.Left + EditFastSearch.Width + 6;
    MedienListeStatusLBL.Width := MedienlisteFillPanel.Width - 16;

      Height := _ControlPanel.Height + 2;
      Constraints.MaxHeight := 0;
      Constraints.MinWidth := MAINFORM_MinWidth;
      Constraints.MinHeight := MAINFORM_MinHeight;

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

    AuswahlFillPanel0  .OnMouseDown := Nil;
    AuswahlStatusLBL0  .OnMouseDown := Nil;
    AuswahlFillPanel0  .OnMouseMove := Nil;
    AuswahlStatusLBL0  .OnMouseMove := Nil;
    AuswahlFillPanel0  .OnMouseUP   := Nil;
    AuswahlStatusLBL0  .OnMouseUP   := Nil;

    AuswahlFillPanel1  .OnMouseDown := Nil;
    AuswahlStatusLBL1  .OnMouseDown := Nil;
    AuswahlFillPanel1  .OnMouseMove := Nil;
    AuswahlStatusLBL1  .OnMouseMove := Nil;
    AuswahlFillPanel1  .OnMouseUP   := Nil;
    AuswahlStatusLBL1  .OnMouseUP   := Nil;

    AuswahlFillPanel2  .OnMouseDown := Nil;
    AuswahlStatusLBL2  .OnMouseDown := Nil;
    AuswahlFillPanel2  .OnMouseMove := Nil;
    AuswahlStatusLBL2  .OnMouseMove := Nil;
    AuswahlFillPanel2  .OnMouseUP   := Nil;
    AuswahlStatusLBL2  .OnMouseUP   := Nil;

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
        //aPoint := _ControlPanel.ClientToParent(Point(0,0), Nemp_MainForm );

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
        xpbottom := xptop + _ControlPanel.Height; //+ height; //_ControlPanel.Height  {+ 4};// - 1 + 3;

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

procedure UpdateFormDesignNeu(newMode: Integer; NempStarting: Boolean = False);
begin
  with Nemp_MainForm do
  begin
      RevokeDragFiles;
//LockWindowUpdate (CoverScrollbar.Handle);

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
        try
          Nemp_MainForm.Menu := NIL
        except

        end
      else
      begin
          if NOT NempSkin.HideMainMenu then
              Nemp_MainForm.Menu := Nemp_MainMenu;
      end;

      BtnClose.Visible := newMode = 1;
      BtnMinimize.Visible := newMode = 1;
      // temporary for this procedure
      PanelCoverBrowse.OnResize := Nil;

      NempOptions.Anzeigemode := NewMode;  // here ok?? (2019 rework, tmp comment

      case NempOptions.AnzeigeMode of
        0: begin
            // Compact view, all in one window
            if (Tag in [0,1]) then begin
                // not necessary on start, Mainform is designed in a "joined state"
                // basically: Put all the Panels back on the Mainform
                JoinMainForm;
                NempLayout.PrepareRebuild;
                NempLayout.BuildMainForm(nil);
            end;

            Top    := NempOptions.FormPositions[nfMain].Top ;
            Left   := NempOptions.FormPositions[nfMain].Left;
            Height := NempOptions.FormPositions[nfMain].Height;
            Width  := NempOptions.FormPositions[nfMain].Width;
        end;

        1: begin
            // Einzelfenster-Ansicht
            // at first start: Build two rows here for ControlPanel, if necessary
            //if (Tag = -1) and NempFormBuildOptions.ControlPanelTwoRows then
            //    NempFormBuildOptions.RefreshControlPanel;
            SplitMainForm;
            AfterLayoutBuild(Nil);
        end;
      end;

      // reactivate it again
      PanelCoverBrowse.OnResize := PanelCoverBrowseResize;

      if NempOptions.AnzeigeMode = 0 then
      begin
          //2019 _TopMainPanel.Constraints.MaxHeight := Height - 160;
          NempRegionsDistance.Top := 0;
          NempRegionsDistance.Bottom := height;
          NempRegionsDistance.Right := width;
          NempRegionsDistance.Left := 0;
      end
      else
      begin
          UpdateSmallMainForm;  // just some "NempRegionsDistance"-stuff
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
      end;

      if (NempOptions.AnzeigeMode = 0) AND NempOptions.MainFormMaximized then
          WindowState := wsMaximized;

      if NempSkin.isActive then
          NempSkin.FitSkinToNewWindow;

      RepairZOrder;
      if (NempOptions.AnzeigeMode = 0) AND (Tag in [0,1]) then
      begin
          SetWindowRgn( handle, 0, Not _IsThemeActive );
          InvalidateRect(handle, NIL, TRUE);
      end;

      CorrectSkinRegionsTimer.Enabled := True;
      if not NempStarting then
        MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);
      Tag := NempOptions.AnzeigeMode;

      //CoverScrollbar.WindowProc := NewScrollBarWndProc;
      //SendMessage( CoverScrollbar.Handle, WM_SETREDRAW, 1, 0);
      //CoverScrollbar.StyleElements := [seFont,seClient,seBorder]
      // one attempt to get rid of several AV with this scrollbar
      //CoverScrollbar.Visible := True;

// LockWindowUpdate(0);
  end;
end;

procedure RevokeDragFiles;
begin
  RevokeDragDrop(Nemp_MainForm.PlayerControlPanel.Handle);
  RevokeDragDrop(Nemp_MainForm.TreePanel.Handle);
  RevokeDragDrop(Nemp_MainForm.CloudPanel.Handle);
  RevokeDragDrop(Nemp_MainForm.CoverflowPanel.Handle);
end;

procedure ReAcceptDragFiles;
begin
  DragAcceptFiles (PlaylistForm.Handle, True);
  DragAcceptFiles (AuswahlForm.Handle, True);
  DragAcceptFiles (MedienlisteForm.Handle, True);
  DragAcceptFiles (ExtendedControlForm.Handle, True);
  RegisterDragDrop(Nemp_MainForm._ControlPanel.Handle, Nemp_MainForm.fDropManager as IDropTarget);
  RegisterDragDrop(Nemp_MainForm.TreePanel.Handle, Nemp_MainForm.fDropManager as IDropTarget);
  RegisterDragDrop(Nemp_MainForm.CloudPanel.Handle, Nemp_MainForm.fDropManager as IDropTarget);
  RegisterDragDrop(Nemp_MainForm.CoverflowPanel.Handle, Nemp_MainForm.fDropManager as IDropTarget);
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

