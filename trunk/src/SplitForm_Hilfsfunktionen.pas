{

    Unit SplitForm_Hilfsfunktionen

    - Helpers for splitting the main form into several windows

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
unit SplitForm_Hilfsfunktionen;

interface

uses Windows, forms, Classes, Controls, StdCtrls, ExtCtrls, Graphics, Nemp_ConstantsAndTypes, Messages, dialogs;

  procedure SetRegion(GrpBox: TPanel; aForm: TForm; var NempRegionsDistance: TNempRegionsDistance;  aHandle: hWnd);
  function IntervalOverlap(left1, right1, left2, right2: integer): boolean;

  function SnapForm(var Message: TWMWINDOWPOSCHANGING; Source: TNempForm; Dest: TNempForm): boolean;

  function IsDocked2(Source: TNempForm; Dest: TNempForm): Boolean;

  procedure FormPosAndSizeCorrect(aForm: TNempForm);
  Procedure ReInitRelativePositions;
  procedure ReInitDocks;

  function GetResizeDirection(Sender: TObject; Shift: TShiftState; X, Y: Integer):Cardinal;

  procedure SplitMainForm;
  procedure JoinMainForm;

  procedure UpdateSmallMainForm;
  procedure UpdateFormDesignNeu;

var

    SnapActive: Boolean;

implementation

uses NempMainUnit, PlaylistUnit, MedienlisteUnit, AuswahlUnit, ExtendedControlsUnit,
     SystemHelper;

procedure SetRegion(GrpBox: TPanel; aForm: TForm; var NempRegionsDistance: TNempRegionsDistance; aHandle: hWnd);
var formregion,
  formregion1: HRGN;
  xpbottom, xptop, xpleft, xpright: integer;
begin
    xptop    := 0;
    xpleft   := 0; //GrpBox.Left + 1 - 2;
    xpRight  := xpleft + GrpBox.Width;// - 2 + 5;  //aForm.width - 10;
    xpbottom := 27; //GrpBox.Top - 2 + 2;

    formRegion := CreateRoundRectRgn
            (xpleft, xptop, xpright, xpbottom, 4, 4);

    NempRegionsDistance.Top := xptop;

    xptop    := 26;//GrpBox.Top + 1 - 2;
    xpleft   := 0;//GrpBox.Left + 1 - 2;
    xpbottom := GrpBox.Height; //xptop + GrpBox.Height - 1 + 4;

    formRegion1 := CreateRoundRectRgn
        (xpleft, xptop, xpright, xpbottom , 4, 4);

    CombineRgn( formregion, formregion, formregion1, RGN_OR );
    SetWindowRgn( ahandle, formregion, true );

    NempRegionsDistance.Left := xpleft;
    NempRegionsDistance.Right := xpright - 1;
    NempRegionsDistance.Bottom := xpbottom - 1;
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
begin

  //Größen korrekturen
  if aForm.NempRegionsDistance.Bottom > Screen.WorkAreaHeight then
    aForm.Height := Screen.WorkAreaHeight;

  if aForm.NempRegionsDistance.Right > Screen.WorkAreaWidth then
    aForm.Width := Screen.WorkAreaWidth;

  // Positionskorrekturen
  // Zu weit unten?
  if aForm.Top + aForm.NempRegionsDistance.Top
          > Screen.DesktopHeight - 50 then
  begin
    aForm.Top := Screen.DesktopHeight - aForm.NempRegionsDistance.Bottom;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit rechts?
  if aForm.Left + aForm.NempRegionsDistance.Left
          > Screen.DesktopWidth - 20 then
  begin
    aForm.Left := Screen.DesktopWidth - aForm.NempRegionsDistance.Right;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit links?
  if aForm.Left + aForm.NempRegionsDistance.Right
          < Screen.DesktopLeft + 20 then
  begin
    aForm.Left := Screen.DesktopLeft - aForm.NempRegionsDistance.Left;
    aForm.NempRegionsDistance.docked := False;
  end;

  // Zu weit oben?
  if aForm.Top + aForm.NempRegionsDistance.Top
          < Screen.DesktopTop + 10 then
  begin
    aForm.Top := Screen.DesktopTop - aForm.NempRegionsDistance.Top;
    aForm.NempRegionsDistance.docked := False;
  end;

  aForm.NempRegionsDistance.RelativPositionX := aForm.Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
  aForm.NempRegionsDistance.RelativPositionY := aForm.Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
end;

Procedure ReInitRelativePositions;
begin
  if PlaylistForm.Visible then
  begin
    PlaylistForm.NempRegionsDistance.RelativPositionX := PlaylistForm.Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
    PlaylistForm.NempRegionsDistance.RelativPositionY := PlaylistForm.Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
  end;

  if MedienlisteForm.Visible then
  begin
    MedienlisteForm.NempRegionsDistance.RelativPositionX := MedienlisteForm.Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
    MedienlisteForm.NempRegionsDistance.RelativPositionY := MedienlisteForm.Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
  end;

  if AuswahlForm.Visible then
  begin
    AuswahlForm.NempRegionsDistance.RelativPositionX := AuswahlForm.Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
    AuswahlForm.NempRegionsDistance.RelativPositionY := AuswahlForm.Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
  end;

  if ExtendedControlForm.Visible then
  begin
    ExtendedControlForm.NempRegionsDistance.RelativPositionX := ExtendedControlForm.Left - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormLeft;
    ExtendedControlForm.NempRegionsDistance.RelativPositionY := ExtendedControlForm.Top - Nemp_MainForm.NempOptions.NempFormAufteilung[1].FormTop;
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


  //if
     PlaylistForm.NempRegionsDistance.docked :=
     PlaylistForm.Visible AND
     fp
    { (fp
     OR (fm AND mp)
     OR (fa AND ap)
     OR (fa AND am AND mp)
     OR (fm AND ma AND ap))  }
     ;
     //then PlaylistForm.NempRegionsDistance.docked := True  ;

  // für die beiden anderen Forms entsprechend
  //if
     AuswahlForm.NempRegionsDistance.docked :=
     Auswahlform.Visible AND  fa
    { (fa
     OR (fm AND ma)
     OR (fp AND pa)
     OR (fp AND pm AND ma)
     OR (fm AND mp AND pa))  }
     ;
     //then AuswahlForm.NempRegionsDistance.docked := True  ;

  //if
  MedienlisteForm.NempRegionsDistance.docked :=
     MedienlisteForm.Visible AND  fm
    { (fm
     OR (fa AND am)
     OR (fp AND pm)
     OR (fp AND pa AND am)
     OR (fa AND ap AND pm)) }
     ;
     //then MedienlisteForm.NempRegionsDistance.docked := True  ;

  ExtendedControlForm.NempRegionsDistance.docked :=
      ExtendedControlForm.Visible and  fe
     { (fe
      OR (fa and ae)
      OR (fp and pe)
      OR (fm and me)

      OR (fp and pa and ae)
      OR (fa and ap and pe)
      OR (fm and ma and)

      )};
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



procedure SplitMainForm;
begin
  with Nemp_MainForm do
  begin
      PlaylistPanel.OnMouseDown :=     PlaylistForm.OnMouseDown;
      GRPBOXPlaylist.OnMouseDown :=    PlaylistForm.OnMouseDown;
      PlaylistFillPanel.OnMouseDown := PlaylistForm.OnMouseDown;
      PlaylistPanel.OnMouseMove := PlaylistForm.OnMouseMove;
      GRPBOXPlaylist.OnMouseMove := PlaylistForm.OnMouseMove;
      PlaylistFillPanel.OnMouseMove := PlaylistForm.OnMouseMove;
      PlaylistPanel.OnMouseUP := PlaylistForm.OnMouseUP;
      GRPBOXPlaylist.OnMouseUP := PlaylistForm.OnMouseUP;
      PlaylistFillPanel.OnMouseUP := PlaylistForm.OnMouseUP;
      AuswahlPanel.OnMouseDown := AuswahlForm.OnMouseDown;
      GRPBOXArtistsAlben.OnMouseDown := AuswahlForm.OnMouseDown;
      AuswahlPanel.OnMouseMove := AuswahlForm.OnMouseMove;
      GRPBOXArtistsAlben.OnMouseMove := AuswahlForm.OnMouseMove;
      AuswahlPanel.OnMouseUP := AuswahlForm.OnMouseUP;
      GRPBOXArtistsAlben.OnMouseUP := AuswahlForm.OnMouseUP;
      AuswahlFillPanel.OnMouseUp := AuswahlForm.OnMouseUp;
      AuswahlFillPanel.OnMouseMove := AuswahlForm.OnMouseMove;
      AuswahlFillPanel.OnMouseDown := AuswahlForm.OnMouseDown;
      AuswahlStatusLBL.OnMouseUp := AuswahlForm.OnMouseUp;
      AuswahlStatusLBL.OnMouseMove := AuswahlForm.OnMouseMove;
      AuswahlStatusLBL.OnMouseDown := AuswahlForm.OnMouseDown;

      VSTPanel.OnMouseDown := MedienlisteForm.OnMouseDown;
      GRPBOXVST.OnMouseDown := MedienlisteForm.OnMouseDown;
      MedienListeFillPanel.OnMouseDown := MedienlisteForm.OnMouseDown;
      VSTPanel.OnMouseMove := MedienlisteForm.OnMouseMove;
      GRPBOXVST.OnMouseMove := MedienlisteForm.OnMouseMove;
      MedienListeFillPanel.OnMouseMove := MedienlisteForm.OnMouseMove;
      VSTPanel.OnMouseUP := MedienlisteForm.OnMouseUP;
      GRPBOXVST.OnMouseUP := MedienlisteForm.OnMouseUP;
      MedienListeFillPanel.OnMouseUP := MedienlisteForm.OnMouseUP;

      MedienListeStatusLBL.OnMouseDown := MedienlisteForm.OnMouseDown;
      MedienListeStatusLBL.OnMouseMove := MedienlisteForm.OnMouseMove;
      MedienListeStatusLBL.OnMouseUP := MedienlisteForm.OnMouseUP;

      PlayListStatusLBL.OnMouseDown := PlaylistForm.OnMouseDown;
      PlayListStatusLBL.OnMouseMove := PlaylistForm.OnMouseMove;
      PlayListStatusLBL.OnMouseUP   := PlaylistForm.OnMouseUP;

      AudioPanel.OnMouseDown := ExtendedControlForm.OnMouseDown;
      AudioPanel.OnMouseMove := ExtendedControlForm.OnMouseMove;
      AudioPanel.OnMouseUp   := ExtendedControlForm.OnMouseUp  ;
      CoverImage.OnMouseDown := ExtendedControlForm.OnMouseDown;
      CoverImage.OnMouseMove := ExtendedControlForm.OnMouseMove;
      CoverImage.OnMouseUp   := ExtendedControlForm.OnMouseUp  ;
      GRPBOXEqualizer.OnMouseDown := ExtendedControlForm.OnMouseDown;
      GRPBOXEqualizer.OnMouseMove := ExtendedControlForm.OnMouseMove;
      GRPBOXEqualizer.OnMouseUp   := ExtendedControlForm.OnMouseUp  ;
      GRPBOXEffekte.OnMouseDown := ExtendedControlForm.OnMouseDown;
      GRPBOXEffekte.OnMouseMove := ExtendedControlForm.OnMouseMove;
      GRPBOXEffekte.OnMouseUp   := ExtendedControlForm.OnMouseUp  ;

      GRPBOXHeadset.OnMouseDown := ExtendedControlForm.OnMouseDown;
      GRPBOXHeadset.OnMouseMove := ExtendedControlForm.OnMouseMove;
      GRPBOXHeadset.OnMouseUp   := ExtendedControlForm.OnMouseUp  ;
  end;
end;

procedure JoinMainForm;
begin

  with Nemp_MainForm do
  begin
    ////GRPBOXVST.Height := GRPBOXVST.Height + (GRPBOXVST.Top - 28);

    AuswahlFillPanel.Width := AuswahlPanel.Width - AuswahlFillPanel.Left;
    PlaylistFillPanel.Width := PlaylistPanel.Width - PlaylistFillPanel.Left;// - 8;

    AuswahlPanel.Align := alleft;
    AuswahlPanel.Left := 0;

    PlaylistPanel.Align := alClient;
    PlaylistPanel.Parent := TopMainPanel;
    AuswahlPanel.Parent := TopMainPanel;

    VSTPanel.Align := alClient;
    VSTPanel.Parent := Nemp_MainForm;

    AudioPanel.Parent := PlayerPanel;
    AudioPanel.Left := 2;
    AudioPanel.Top := NewPlayerPanel.Top + NewPlayerPanel.Height + 3;


    EditFastSearch.Width := 194;
    MedienlisteFillPanel.Left := EditFastSearch.Left + EditFastSearch.Width + 6;
    MedienlisteFillPanel.Width := VSTPanel.Width - MedienlisteFillPanel.Left;// - 8;
    MedienListeStatusLBL.Width := MedienlisteFillPanel.Width - 16;
    PlayListStatusLBL.Width := PlaylistFillPanel.Width - 16;


    AuswahlPanel.OnResize := AuswahlPanelResize;
    Nemp_MainForm.OnResize := FormResize;

    Medienlisteform.Close;
    Playlistform.Close;
    Auswahlform.Close;
    ExtendedControlForm.Close;

    PlaylistPanel.OnMouseDown := NIL;
    PlaylistPanel.OnMouseMove := NIL;
    GRPBOXPlaylist.OnMouseDown := NIL;
    GRPBOXPlaylist.OnMouseMove := NIL;
    PlaylistFillPanel.OnMouseDown := NIL;
    PlaylistFillPanel.OnMouseMove := NIL;

    AuswahlPanel.OnMouseDown := NIL;
    AuswahlPanel.OnMouseMove := NIL;
    GRPBOXArtistsAlben.OnMouseDown := NIL;
    GRPBOXArtistsAlben.OnMouseMove := NIL;

    VSTPanel.OnMouseDown := NIL;
    VSTPanel.OnMouseMove := NIL;
    GRPBOXVST.OnMouseDown := NIL;
    GRPBOXVST.OnMouseMove := NIL;
    MedienListeFillPanel.OnMouseDown := NIL;
    MedienListeFillPanel.OnMouseMove := NIL;
    AuswahlFillPanel.OnMouseDown := Nil;
    AuswahlFillPanel.OnMouseMove := Nil;
    AuswahlStatusLBL.OnMouseMove := Nil;
    AuswahlStatusLBL.OnMouseDown := Nil;

    MedienListeStatusLBL.OnMouseDown := Nil;
    MedienListeStatusLBL.OnMouseMove := Nil;
    MedienListeStatusLBL.OnMouseUP   := Nil;

    PlayListStatusLBL.OnMouseDown := Nil;
    PlayListStatusLBL.OnMouseMove := Nil;
    PlayListStatusLBL.OnMouseUP   := Nil;

    AuswahlStatusLBL.OnMouseDown := Nil;
    AuswahlStatusLBL.OnMouseMove := Nil;
    AuswahlStatusLBL.OnMouseUP   := Nil;

    CoverImage.OnMouseDown := Nil;
    CoverImage.OnMouseMove := Nil;
    CoverImage.OnMouseUp   := Nil;
    // Andere Controls im Equalizer-Teil
    AudioPanel.OnMouseDown := Nil;
    AudioPanel.OnMouseMove := Nil;
    AudioPanel.OnMouseUp   := Nil;

    GRPBOXEqualizer.OnMouseDown := Nil;
    GRPBOXEqualizer.OnMouseMove := Nil;
    GRPBOXEqualizer.OnMouseUp   := Nil;

    GRPBOXEffekte.OnMouseDown :=  Nil;
    GRPBOXEffekte.OnMouseMove :=  Nil;
    GRPBOXEffekte.OnMouseUp   :=  Nil;

    GRPBOXHeadset.OnMouseDown := Nil;
    GRPBOXHeadset.OnMouseMove := Nil;
    GRPBOXHeadset.OnMouseUp   := Nil;
  end;
end;


procedure UpdateSmallMainForm;
var formregion,
  formregion1: HRGN;
  xpbottom, xptop, xpleft, xpright: integer;
begin
    with Nemp_MainForm do
    begin
//      if _IsThemeActive or NempSkin.isActive then
//      begin
              xpleft   := GetSystemMetrics(SM_CXFrame) + - 2 + NewPlayerPanel.Left ;
              xptop    := GetSystemMetrics(SM_CYCAPTION)  - 2 + GetSystemMetrics(SM_CYFrame) + NewPlayerPanel.Top ;
              xpright  := xpleft + NewPlayerPanel.Width - 1 + 4;// - 1 + 4;
              xpbottom := xptop + NewPlayerPanel.Height - 1 + 4;// - 1 + 3;
              formRegion := CreateRectRgn
                  (xpleft, xptop, xpright, xpbottom );

              NempRegionsDistance.Top := xptop;
              NempRegionsDistance.Left := xpleft;
              NempRegionsDistance.Right := xpright ;
              NempRegionsDistance.Bottom := xpbottom ;

             // xptop    := xpBottom - 1;
             // xpbottom := xptop + GRPBOXSpectrum.Height-1 + 2;
             // formRegion1 := CreateRoundRectRgn
             //     (xpleft, xptop, xpright, xpbottom , 4, 4);
             // CombineRgn( formregion, formregion, formregion1, RGN_OR );

             // xptop    := xpBottom - 1;
             // xpbottom := xptop + GRPBOXControl.Height - 1 + 3;

{              if NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible then
                xpbottom := xpbottom + 4; // Hier muss man was weiter runter gehen

              formRegion1 := CreateRoundRectRgn
                  (xpleft, xptop, xpright, xpbottom , 4, 4);
              CombineRgn( formregion, formregion, formregion1, RGN_OR );

              NempRegionsDistance.Bottom := xpbottom - 1;

              // ggf oben und unten was dranhängen
              if NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible then
              begin
                xptop    := GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFrame) ;
                xpBottom := xpTop + NewPlayerPanel.Top;
                formRegion1 := CreateRoundRectRgn
                  (xpleft, xptop, xpright, xpbottom , 4, 4);
                CombineRgn( formregion, formregion, formregion1, RGN_OR );

                NempRegionsDistance.Top := xptop;

                xptop := GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFrame) + GRPBOXEqualizer.Top - 4;
                xpBottom := xpTop + EXTENDED_HEIGHT + 6;//GRPBOXEqualizer.Height + 6;

                formRegion1 := CreateRoundRectRgn
                  (xpleft, xptop, xpright, xpbottom , 4, 4);
                CombineRgn( formregion, formregion, formregion1, RGN_OR );

                NempRegionsDistance.Bottom := xpbottom - 1;
              end;

      end else
      begin // Theme nicht aktiv UND kein Skin aktiv
              xpleft   := 10;
              xpright  := xpleft + NewPlayerPanel.Width  + 4 ;

              if NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible then
              begin
                xptop    := GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFrame) ;
                xpBottom := xpTop + GRPBOXEqualizer.Top + GRPBOXEqualizer.Height + 2;
              end else
              begin
                xptop    := GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFrame) + NewPlayerPanel.Top + 3;  //+ 15 + 18;
                xpbottom := xpTop + NewPlayerPanel.Height -1 ;
              end;
              formRegion := CreateRoundRectRgn
                  (xpleft, xptop, xpright, xpbottom , 4, 4);

              NempRegionsDistance.Top := xptop;
              NempRegionsDistance.Left := xpleft;
              NempRegionsDistance.Right := xpright - 1;
              NempRegionsDistance.Bottom := xpbottom - 1;
      end;
}
      // Regions setzen
      SetWindowRgn( handle, formregion, true );
      stopBtn.BringToFront;
    end;
end;

procedure UpdateFormDesignNeu;
var i: Integer;
begin
  with Nemp_MainForm do
  begin
      SnapActive := False;

      // Beim ersten Mal nach Start der Anwendung ni!cht tun!!
      if Tag in [0,1] then
      begin
        NempOptions.NempFormAufteilung[Tag].Maximized := WindowState=wsMaximized;
        WindowState := wsNormal;
        // aktuelle Aufteilung speichern
        NempOptions.NempFormAufteilung[Tag].FormTop   := Top ;
        NempOptions.NempFormAufteilung[Tag].FormLeft  := Left;
        NempOptions.NempFormAufteilung[Tag].FormHeight:= Height;
        NempOptions.NempFormAufteilung[Tag].FormWidth := Width;
        NempOptions.NempFormAufteilung[Tag].TopMainPanelHeight := TopMainPanel.Height;
        NempOptions.NempFormAufteilung[Tag].AuswahlPanelWidth  := AuswahlPanel.Width;
        NempOptions.NempFormAufteilung[Tag].ArtistWidth   := ArtistsVST.Width;
      end;

      // Zuerst: HauptMenü anzeigen // ausblenden
      // Das macht das Setzen Der Regions im Einzelfenster-Modus einfacher.
      if AnzeigeMode = 1 then
        Nemp_MainForm.Menu := NIL
      else
      begin
        if NOT ({Nempskin.isActive And } NempSkin.HideMainMenu) then
            Nemp_MainForm.Menu := Nemp_MainMenu;
      end;


      // Menu-Einträge Dis-/Enablen
          PM_P_ViewSeparateWindows_Equalizer.Enabled := AnzeigeMode = 1;
          PM_P_ViewSeparateWindows_Playlist.Enabled := AnzeigeMode = 1;
          PM_P_ViewSeparateWindows_Medialist.Enabled := AnzeigeMode = 1;
          PM_P_ViewSeparateWindows_Browse.Enabled := AnzeigeMode = 1;
          PM_P_ViewStayOnTop.Enabled := AnzeigeMode = 1;

          MM_O_ViewSeparateWindows_Equalizer.Enabled := AnzeigeMode = 1;
          MM_O_ViewSeparateWindows_Playlist.Enabled := AnzeigeMode = 1;
          MM_O_ViewSeparateWindows_Medialist.Enabled := AnzeigeMode = 1;
          MM_O_ViewSeparateWindows_Browse.Enabled := AnzeigeMode = 1;
          MM_O_ViewStayOnTop.Enabled := AnzeigeMode = 1;

          PM_P_ViewCompactComplete.Enabled := AnzeigeMode = 0;
          MM_O_ViewCompactComplete.Enabled := AnzeigeMode = 0;

      if AnzeigeMode = 0 then
          JoinMainForm;

      Constraints.MinHeight := 0;
      Constraints.MaxHeight := 0;
      Constraints.MinWidth := 0;
      Constraints.MaxWidth := 0;
      TopMainPanel.Constraints.MaxHeight := 0;

      PanelCoverBrowse.OnResize := Nil;
      // 1. Form: Größen setzen


      if Tag in [0,1] then
      begin
          Top := NempOptions.NempFormAufteilung[AnzeigeMode].FormTop;
          Left := NempOptions.NempFormAufteilung[AnzeigeMode].FormLeft;
      end;

      // 2. Sachenanzeigen und Aligns ggf. wieder umsetzen
      // 3. Positionen korrigieren
      case AnzeigeMode of
        0: begin
            // Kompakte Ansicht

            Height := NempOptions.NempFormAufteilung[AnzeigeMode].FormHeight;
            Width := NempOptions.NempFormAufteilung[AnzeigeMode].FormWidth;

            MM_O_ViewCompactComplete.Checked := True;
            PM_P_ViewCompactComplete.Checked := True;

            AuswahlPanel.Align := alNone;
            AuswahlPanel.Width := NempOptions.NempFormAufteilung[AnzeigeMode].AuswahlPanelWidth;
            AuswahlPanel.Visible := True;
            AuswahlPanel.Left := 0;

            Splitter2.Align := alnone;
            Splitter2.Visible := True;
            Splitter2.Left := AuswahlPanel.Width;
            PlayerPanel.Left := AuswahlPanel.Width + Splitter2.Width;
            Auswahlpanel.Align := alLeft;
            Splitter2.Align := alleft;
            PlayerPanel.Align := alleft;

            VSTPanel.Visible := True; // 23.8
            Splitter1.Visible := True;
            PlaylistPanel.Visible := True;
        end;

        1: begin
            // Einzelfenster-Ansicht
            // In Partymode the size is different here. Use the current values
            // of the components
            // Note: Currently Separate Windows are not allowed in PartyMode
            //       Maybe later. ;-)
            Width := NewPlayerPanel.Width + 4 + 2*GetSystemMetrics(SM_CXFrame);
            Height := NewPlayerPanel.Top + NewPlayerPanel.Height + 40 + 2*GetSystemMetrics(SM_CYFrame);

            Nemp_MainForm.OnResize := NIL;
            TopMainPanel.Height := AudioPanel.Top + AudioPanel.Height + 40; //430; //391;

            // Forms anzeigen
            if NempOptions.NempEinzelFormOptions.PlaylistVisible then
            begin
                PlaylistForm.Show;
                PlaylistPanel.OnResize := NIL;
                if PlaylistForm.Width < Playlistform.Constraints.MinWidth then
                    PlaylistForm.Width := Playlistform.Constraints.MinWidth;
            end else
            begin
                PlaylistForm.Hide;
            end;
            PlaylistPanel.Parent := PlaylistForm.ContainerPanelPlaylistForm;
            PlaylistPanel.Align := alNone;
            PlaylistPanel.Left := 7;
            PlaylistPanel.Width := PlaylistForm.ContainerPanelPlaylistForm.Width - 14;
            PlaylistPanel.Top := 2;
            PlaylistPanel.Height := PlaylistForm.ContainerPanelPlaylistForm.Height - 9;
            PlaylistPanel.Anchors := [akleft, aktop, akright, akBottom];
            PlaylistForm.FormResize(Nil);
            PlaylistForm.FormShow(Nil);

            if NempOptions.NempEinzelFormOptions.AuswahlSucheVisible then
            begin
                AuswahlForm.Show;
                AuswahlPanel.OnResize := NIL;
            end else
            begin
                AuswahlForm.Hide;
            end;
            AuswahlPanel.Parent := AuswahlForm.ContainerPanelAuswahlform;
            AuswahlPanel.Constraints.MaxWidth := 0;

            AuswahlPanel.Align := alNone;
            AuswahlPanel.Left := 7;
            AuswahlPanel.Width := AuswahlForm.ContainerPanelAuswahlform.Width - 14;
            AuswahlPanel.Top := 2;
            AuswahlPanel.Height := AuswahlForm.ContainerPanelAuswahlform.Height - 9;
            AuswahlPanel.Anchors := [akleft, aktop, akright, akBottom];

            AuswahlForm.FormResize(Nil);
            AuswahlForm.FormShow(Nil);

            if NempOptions.NempEinzelFormOptions.MedienlisteVisible then
            begin
                MedienlisteForm.Show;
            end else
            begin
                MedienlisteForm.Hide;
            end;
            VSTPanel.Parent := MedienlisteForm;
            VSTPanel.Align := alNone;
            VSTPanel.Left := 7;
            VSTPanel.Width := MedienListeForm.ContainerPanelMedienBibForm.Width - 14;
            VSTPanel.Top := 2;
            VSTPanel.Height := MedienListeForm.ContainerPanelMedienBibForm.Height - 9;
            VSTPanel.Anchors := [akleft, aktop, akright, akBottom];
            MedienlisteForm.FormResize(Nil);
            MedienlisteForm.FormShow(Nil);


           // ExtendedControlForm.Height := AudioPanel.Height + 4;
           // ExtendedControlForm.Width := AudioPanel.Width + 4;

            ExtendedControlForm.SetPartySize(AudioPanel.Width + 4, AudioPanel.Height + 4);
            if NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible then
            begin
                ExtendedControlForm.Show;
                ExtendedControlForm.FormShow(ExtendedControlForm);
            end else
            begin
                ExtendedControlForm.Hide;
            end;
            AudioPanel.Parent := ExtendedControlForm.ContainerPanelExtendedControlsForm;
            AudioPanel.Left := 2;
            AudioPanel.Top := 2;


            TopMainPanel.Constraints.MaxHeight := 0;
            TopMainPanel.Constraints.MinHeight := 0;

            // MouseMove etc. setzen
            SplitMainForm;
            Splitter2.Visible := False;
            Splitter1.Visible := False;
        end;
      end;
      PanelCoverBrowse.OnResize := PanelCoverBrowseResize;
      //4.  Größen setzen der Controls setzen
      if AnzeigeMode = 0 then
      begin
        TopMainPanel.Height := NempOptions.NempFormAufteilung[AnzeigeMode].TopMainPanelHeight;
      end;
      ArtistsVST.Width := NempOptions.NempFormAufteilung[AnzeigeMode].ArtistWidth;

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
      Constraints.MinHeight := NempOptions.NempFormAufteilung[AnzeigeMode].FormMinHeight;
      Constraints.MaxHeight := NempOptions.NempFormAufteilung[AnzeigeMode].FormMaxHeight;
      Constraints.MinWidth  := NempOptions.NempFormAufteilung[AnzeigeMode].FormMinWidth;
      Constraints.MaxWidth  := NempOptions.NempFormAufteilung[AnzeigeMode].FormMaxWidth;

      if AnzeigeMode = 0 then
      begin
          TopMainPanel.Constraints.MaxHeight := Height - 160;

          NempRegionsDistance.Top := 0;
          NempRegionsDistance.Bottom := height;
          NempRegionsDistance.Right := width;
          NempRegionsDistance.Left := 0;

          TopMainPanel.Constraints.MinHeight := TOP_MIN_HEIGHT;
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
          ReInitRelativePositions;
      end;

      // This seems useless.
      // But the setter will call SetCustomregion, which seems to be
      // necessary, as the ParentForm of these buttons has changed.
      HallButton         .Height := HallButton         .Height;
      EchoWetDryMixButton.Height := EchoWetDryMixButton.Height;
      EchoTimeButton     .Height := EchoTimeButton     .Height;
      SampleRateButton   .Height := SampleRateButton   .Height;
      for i := 0 to 9 do
          EqualizerButtons[i].Height := EqualizerButtons[i].Height;
      VolButtonHeadset        .Height := VolButtonHeadset        .Height;
      SlidebarButton_Headset  .Height := SlidebarButton_Headset  .Height;



      // Größenkorrekturen
      if (ArtistsVST.Width > AuswahlPanel.width - 40)
          OR (ArtistsVST.Width < 40) then
              ArtistsVST.Width := AuswahlPanel.width DIV 2;

      if NempOptions.NempFormAufteilung[Anzeigemode].Maximized then
        WindowState := wsMaximized;

      if NempSkin.isActive then
        NempSkin.FitSkinToNewWindow;

      RepairZOrder;
      // evtl. Form neu zeichnen. Stichwort "Schwarze Ecken"

    // teilweise auskommentiert für Windows 7
      if (AnzeigeMode = 0) AND (Tag in [0,1]) then
      begin
        SetWindowRgn( handle, 0, Not _IsThemeActive );
        InvalidateRect(handle, NIL, TRUE);
      end;


      SnapActive := True;

      if Tag = -1 then
      begin
          Top := NempOptions.NempFormAufteilung[AnzeigeMode].FormTop;
          Left := NempOptions.NempFormAufteilung[AnzeigeMode].FormLeft;

          FormPosAndSizeCorrect(Nemp_MainForm);
          FormPosAndSizeCorrect(AuswahlForm);
          FormPosAndSizeCorrect(PlaylistForm);
          FormPosAndSizeCorrect(MedienlisteForm);
          ReInitRelativePositions;

          if NempOptions.FixCoverFlowOnStart then
          begin
              // this is somehow needed on XP (or only in my virtual machine??)
              if TopMainPanel.Height Mod 2 = 0 then
                  TopMainPanel.Height := TopMainPanel.Height + 1
              else
                  TopMainPanel.Height := TopMainPanel.Height - 1  ;
          end;
      end;

      MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);

      Tag := AnzeigeMode;
  end;
end;





initialization

    SnapActive := False;

end.

