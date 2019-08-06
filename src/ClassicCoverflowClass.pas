{

    Unit ClassicCoverflowClass

    - The Classic Coverflow
      This could be done more efficient (e.g. caching the small covers)


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
unit ClassicCoverflowClass;

interface

uses Windows, Messages, SysUtils, Graphics, ExtCtrls, ContNrs, Classes,
    Jpeg, PNGImage, dialogs;

const
    // the same as in FlyingCow
    WM_FLYINGCOW = WM_USER + $1000;
    WM_FC_NEEDPREVIEW = WM_FLYINGCOW + 0;

type
    TClassicCoverFlow = class
        private
            fEventsWindow : HWND;
            fCurrentItem: Integer;  // Index of the current selected cover
            fCurrentCoverID: String;     // currently selected coverID
            // Note: I'm not using a NempCover-object here to remember the idx
            //       Otherwise AVs could occur when deleting covers ;-)

           // fCaption: String; // caption for the current Cover

            function fGetCurrentItem: Integer;
            // SetCurrentItem: Set the current Item and draws cover and scrollcover
            procedure fSetCurrentItem(aValue: Integer);

            procedure DrawScrollCover(aIdx: Integer; aWidth, aHeight: Integer);
        public
            MainImage: TImage;
            ScrollImage: TImage;
            CoverList: TObjectList;
            CoverSavePath: String;

            property CurrentItem: Integer read fGetCurrentItem write fSetCurrentItem;
           // property Caption: String read fcaption;

           constructor Create(events_window : HWND);

            // ScrollToCurrentItem:
            // Searches the cover with fCurrentCoverID and shows it
            // used after a resort of the coverlist
            procedure ScrollToCurrentItem;

            // SelectItemAt: X/Y-Coordinates of the MouseDown-Event of the ScrollImage
            procedure SelectItemAt(x, y: Integer);
    end;

implementation

uses CoverHelper, Nemp_ConstantsAndTypes, gnuGettext, Nemp_RessourceStrings;

{ TClassicCoverFlow }

function TClassicCoverFlow.fGetCurrentItem: Integer;
begin
    result := fCurrentItem;
end;

procedure TClassicCoverFlow.ScrollToCurrentItem;
var i, newItem: Integer;
begin
    newItem := -1;
    for i := 0 to Coverlist.Count -  1 do
    if tNempCover(Coverlist[i]).ID = fCurrentCoverID then
    begin
        newItem := i;
        break;
    end;
    if newItem = -1 then
        newItem := fCurrentItem;
    if newItem >= Coverlist.Count then
        newItem := 0;

    // Set item and draw the stuff.
    Currentitem := newItem;
end;

procedure TClassicCoverFlow.SelectItemAt(x, y: Integer);
var mitte, newItem: Integer;
begin
  mitte := (ScrollImage.Width Div 2) - 37;
  if x > mitte then
    newItem := fCurrentItem + ((x - mitte) Div 85)
  else
    newItem := fCurrentItem + ((x - mitte) Div 85) - 1;

  // Set item and draw the stuff.
  if (newItem >= 0) and (newItem <= Coverlist.Count-1) then
      Currentitem := newItem;
end;

procedure TClassicCoverFlow.fSetCurrentItem(aValue: Integer);
var aCover: tNempCover;
begin
    fCurrentItem := aValue;
    if fCurrentItem < 0 then
        fCurrentItem := 0;
    if fCurrentItem >= CoverList.Count then
        fCurrentItem := CoverList.Count-1;

    if fCurrentItem = -1 then exit;

    aCover := TNempCover(CoverList[fCurrentItem]);

    fCurrentCoverID := aCover.ID;

    // Set the bitmap size (is this really necessary?)
    MainImage.Picture.Bitmap.Height := MainImage.Height;
    MainImage.Picture.Bitmap.Width := MainImage.Width;

    if not GetCoverBitmapFromID(aCover.ID, MainImage.Picture, CoverSavePath) then
        // cover is missing - try again to get it ?
        SendMessage(fEventsWindow, WM_FC_NEEDPREVIEW, fCurrentItem, 0);

    // after that: try again
    // yes, we called this in the MessageHandler for WM_FC_NEEDPREVIEW as well
    // not the best solution, but I hope the classic flow is not used that often^^
    GetCoverBitmapFromID(aCover.ID, MainImage.Picture, CoverSavePath);

    DrawScrollCover(fCurrentItem, ScrollImage.Width, ScrollImage.Height);
end;




constructor TClassicCoverFlow.Create(events_window: HWND);
begin
    fEventsWindow := events_window;
end;

procedure TClassicCoverFlow.DrawScrollCover(aIdx: Integer; aWidth, aHeight: Integer);
var mitte, minidx, maxidx, i: Integer;
    abmp: TBitmap;
    ajpg: TJpegImage;
    xfactor, yfactor:double;
    NewHeight, NewWidth: Integer;
    bigbmp: TBitmap;
    aCover: TNempCover;
begin
  mitte := aWidth Div 2;

  minidx := aIdx - ((Mitte Div 75) + 1);
  maxidx := aIdx + ((Mitte Div 75) + 1);
  if minidx < 0 then minidx := 0;
  if maxidx >= Coverlist.Count-1 then maxidx := Coverlist.Count - 1;

  ajpg := TJpegImage.Create;
  abmp := TBitmap.Create;
  bigbmp := TBitmap.Create;
  bigbmp.Width := aWidth;
  Bigbmp.Height := aHeight;
  bigbmp.TransparentColor := cllime;
  Bigbmp.Canvas.Brush.Color := clLime;
  bigbmp.Canvas.FillRect(Rect(0,0,bigbmp.Width, bigbmp.Height));

  (* TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  for i := minidx to maxidx do
  begin
          aCover := TNempCover(Coverlist[i]);

          GetCoverBitmapFromID(aCover.ID, aBmp, CoverSavePath);

          if (abmp.Width > 0) AND (abmp.Height > 0) then
          begin
              xfactor:= (75) / abmp.Width;
              yfactor:= (75) / abmp.Height;
              if xfactor > yfactor then
                begin
                  NewWidth := round(abmp.Width * yfactor);
                  NewHeight := round(abmp.Height * yfactor);
                end else
                begin
                  NewWidth := round(abmp.Width * xfactor);
                  NewHeight := round(abmp.Height * xfactor);
                end;

              SetStretchBltMode(bigbmp.Canvas.Handle, HALFTONE);
              StretchBlt(bigbmp.Canvas.Handle,
                          (mitte - 37)  - (aIdx - i) * 85 + ( (75-NewWidth) Div 2)
                          ,
                         (75 - Newheight) Div 2, NewWidth, NewHeight,

                          abmp.Canvas.Handle, 0, 0, abmp.Width, abmp.Height, SRCCopy);

          end;
  end;
  *)
  ScrollImage.Picture.Assign(bigbmp);
  ScrollImage.Refresh;
  bigbmp.Free;
  ajpg.Free;
  abmp.Free;
end;

end.
