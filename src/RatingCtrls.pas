{

    Unit RatingCtrls

    - a helper for Star-Rating-Editing

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
unit RatingCtrls;

interface

uses windows, classes, ExtCtrls, Graphics;

    type

    // This class should help us to draw the Star-Controls
    // We have a method to convert a MouseOver-X into a 1..255-Rating
    // and a method to visualize this value on an Image, using three predefined
    // bitmaps.

    TRatingHelper = class
      private
        fUseBackground: Boolean;

        //fLast***: used for Redraw
        fLastRating: Integer;
        fLastWidth: Integer;
        fLastHeight: Integer;

      public
        // Three graphics for the three types of stars
        fSetStar: TBitmap;
        fHalfStar: TBitmap;
        fUnSetStar: TBitmap;

        BackGroundBitmap: TBitmap;

        // Use background for Stars (needed on Win7 in the library)
        property UsebackGround: Boolean read fUseBackground write fUseBackground;

        constructor Create;
        destructor Destroy; override;

        procedure SetStars(full, half, none: TBitmap);

        // MousePosToRating: Get a proper rating from X-Position
        // should be called in OnMouseMove and OnMouseDown
        function MousePosToRating(X: Integer; ImageWidth: Integer): integer;

        // "Translates" a Rating into Stars using the three Bitmaps
        procedure DrawRatingInStars(aRating: Integer; aCanvas: TCanvas; ImageHeight: Integer; Left: Integer=0);
        procedure DrawRatingInStarsOnBitmap(aRating: Integer; aBitmap: TBitmap; ImageWidth: Integer; ImageHeight: Integer);
        procedure ReDrawRatingInStarsOnBitmap(aBitmap: TBitmap);

    end;


implementation

{ TRatingImage }

constructor TRatingHelper.Create;
begin
    fSetStar   := TBitmap.Create;
    fHalfStar  := TBitmap.Create;
    fUnSetStar := TBitmap.Create;
    BackGroundBitmap := TBitmap.Create;
    fLastWidth  := 70;
    fLastHeight := 14;
end;

destructor TRatingHelper.Destroy;
begin
    fSetStar  .Free;
    fHalfStar .Free;
    fUnSetStar.Free;
    BackGroundBitmap.Free;
    inherited;
end;


procedure TRatingHelper.SetStars(full, half, none: TBitmap);
begin
    fSetStar.Assign(full);
    fHalfStar.Assign(half);
    fUnSetStar.Assign(none);
end;
                                          // oder nur ein canvas?
procedure TRatingHelper.DrawRatingInStars(aRating: Integer; aCanvas: TCanvas; ImageHeight: Integer; Left: Integer=0);
var i, p: Integer;
begin
    // note: use the same methond in Audiofile.fGetRoundedRating

    // Draw SetStars
    for i := 1 to (aRating div 51) do
        aCanvas.Draw(Left + (fSetStar.Width)*(i-1) , // left
                          (ImageHeight) Div 2 - (fSetStar.Height Div 2),
                          fSetStar);

    p := aRating Div 51 + 1;

    // Rating Mod 51 > 25: Draw another full star
    if ((aRating mod 51) > 25) and (p <= 5) then
    begin
        aCanvas.Draw(Left + (fSetStar.Width)*(p-1) , // left
                          ImageHeight Div 2 - ((fSetStar.Height Div 2)),
                          fSetStar);
        inc(p);
    end;

    // if <= 25: Draw only a half star
    if ((aRating mod 51) <= 25) and (p <= 5) then
    begin
        aCanvas.Draw(Left + (fHalfStar.Width)*(p-1) ,
                          ImageHeight Div 2 - (fHalfStar.Height Div 2),
                          fHalfStar);
        inc(p);
    end;

    // Draw UnSetStar
    for i := p to 5 do
        aCanvas.Draw(Left + (fUnSetStar.Width)*(i-1) ,
              ImageHeight Div 2 - (fUnSetStar.Height Div 2),
              fUnSetStar);
end;

procedure TRatingHelper.DrawRatingInStarsOnBitmap(aRating: Integer;
  aBitmap: TBitmap; ImageWidth: Integer; ImageHeight: Integer);
var tmpBmp: TBitmap;
begin

    if aRating = 0 then
        aRating := 127;

    fLastRating := aRating;
    fLastWidth  := ImageWidth;
    flastHeight := ImageHeight;

    tmpBmp := TBitmap.Create;
    try
        tmpBmp.Width := ImageWidth;
        tmpBmp.Height := ImageHeight;

        if fUseBackground then
            tmpBmp.canvas.Draw(0,0, BackGroundBitmap)
        else
        begin
            tmpBmp.Canvas.Brush.Style := bsSolid;
            tmpBmp.Canvas.Brush.Color := clBtnFace;
            tmpBmp.canvas.Fillrect(Rect(0, 0, ImageWidth, ImageHeight));
        end;

       DrawRatingInStars(aRating, tmpBmp.canvas, ImageHeight);

       //BackGroundBitmap.SaveToFile(ParamStr(0) + 'img.bmp');
        aBitmap.Assign(tmpBmp);
    finally
        tmpBmp.Free;
    end;
end;

procedure TRatingHelper.ReDrawRatingInStarsOnBitmap(aBitmap: TBitmap);
begin
    DrawRatingInStarsOnBitmap(fLastRating, aBitmap, fLastWidth, flastHeight);
end;

function TRatingHelper.MousePosToRating(X: Integer; ImageWidth: Integer): integer;
var w, rat: Integer;
begin
    w := ImageWidth div 10;  // get Width of "one step"
    rat := ((x div w)) * w;  // convert x to 10-step-value
    // convert this to 1..255
    // adding 20 (set the rating near the upper-bound of )
    result := Round(255 * rat / ImageWidth) + 20;
    if result > 255 then
        result := 255;
end;





end.
