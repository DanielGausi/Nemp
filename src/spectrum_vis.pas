{

    Unit Spectrum_Vis

    Original Unit:
    ----------------------------------
        Spectrum Visualyzation by Alessandro Cappellozza
        version 0.8 05/2002
        http://digilander.iol.it/Kappe/audioobject
    ----------------------------------
     This is from one of the Sample-Projects of the bass.dll
     Modified/extended for Nemp.

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
unit spectrum_vis;

interface
  uses Windows, Dialogs, Graphics, SysUtils,  Classes, Nemp_Skinsystem,
      ExtCtrls, System.Types;

  // Type TWaveData = array [ 0..2048] of DWORD;
    type TFFTData  = array [0..512] of Single;

    // TSpectrumSpecs: Values which need a change on Partymode
    type TSpectrumSpecs = record
        Width, Height: Integer;
        TextWidth, TextHeight: Integer;
        TimeWidth, TimeHeight: Integer;
        StarHeight, StarWidth: Integer;
        ColumnWidth: Integer;
        PreviewColumn: Integer;
        GradientHeight: Integer;
        TimeFontSize: Integer;
        TextFontSize: Integer;
        FFTDataMultiplikator: Integer;
    end;

    // change this as well, if PaintFrame.Height/Width is changed in the MainForm
    const NempOriginalSpectrumSpecs: TSpectrumSpecs =
    (
        Width       : 75;
        Height      : 25;//88;
        TextWidth   : 216;
        TextHeight  : 18;
        TimeWidth   : 53;
        TimeHeight  : 14;
        StarHeight  : 14;
        StarWidth   : 70;
        ColumnWidth : 2;
        //PreviewColumn: 2;
        GradientHeight : 88;
        TimeFontSize: 10;
        TextFontSize: 10;
        FFTDataMultiplikator: 500;
    );

    //const PREVIEW_COLUMN_WIDTH = 3;
    //      PREVIEW_COLUMN_HEIGHT = 38;

    type TSpectrum = Class(TObject)
    private
        VisBuff : TBitmap;
        BackBmp : TBitmap;
        BackStarBMP : TBitmap;
        GradientBMP: TBitmap;

        BkgColor : TColor;

        SpecHeight : Integer;
        SpecHeightPreview: Integer;
        PenColor : TColor;
        PenColor2 : TColor;
        PeakColor: TColor;
        DrawType : Integer;
        DrawRes  : Integer;
        FrmClear : Boolean;
        UseBkg   : Boolean;
        PeakFall : Integer;
        LineFall : Integer;
        ColWidth : Integer;
        ShowPeak : Boolean;

        FPreviewArtistColor: TColor;
        FPreviewTitleColor: TColor;
        FPreviewTimeColor: TColor;

        fPreviewShapePenColor          : TColor;
        fPreviewShapeBrushColor        : TColor;
        fPreviewShapeProgressPenColor  : TColor;
        fPreviewShapeProgressBrushColor: TColor;

        fFFTDataMultiplikator: Integer;
        fFFTDataMultiplikatorPreView: Integer;

        FFTPeacks  : array [0..30] of Integer;
        FFTFallOff : array [0..30] of Integer;

        FFTPeacksPreView  : array [0..30] of Integer;
        FFTFallOffPreView : array [0..30] of Integer;

        fScrollDelay: Integer;
        fDelayCounter: Integer;

    public
        MainImage: TImage;
        StarImage: TImage;

        Constructor Create (Width, Height : Integer);
        Destructor Destroy; override;

        procedure Draw(FFTData : TFFTData);
        procedure DrawRating(aRating: Integer);
        procedure DrawClear;

        procedure SetBackGround (Active : Boolean);
        procedure SetStarBackGround (Active: Boolean);
        procedure SetGradientBitmap;

        procedure SetScale(aStretchFactor: Single);

        property BackColor : TColor read BkgColor write BkgColor;

        property Height : Integer read SpecHeight write SpecHeight;
        property Width  : Integer read ColWidth write ColWidth;
        property Pen  : TColor read PenColor write PenColor;
        property Pen2  : TColor read PenColor2 write PenColor2;

        property Peak : TColor read PeakColor write PeakColor;
        property Mode : Integer read DrawType write DrawType;
        property Res  : Integer read DrawRes write DrawRes;
        property FrameClear : Boolean read FrmClear write FrmClear;
        property PeakFallOff: Integer read PeakFall write PeakFall;
        property LineFallOff: Integer read LineFall write LineFall;
        property DrawPeak   : Boolean read ShowPeak write ShowPeak;
        property UseBackGround: Boolean read Usebkg write UseBkg;

        property PreviewArtistColor: TColor read FPreviewArtistColor write FPreviewArtistColor;
        property PreviewTitleColor: TColor read FPreviewTitleColor write FPreviewTitleColor;
        property PreviewTimeColor: tColor read FPreviewTimeColor write FPreviewTimeColor;

        property PreviewShapePenColor          : TColor read fPreviewShapePenColor           write fPreviewShapePenColor           ;
        property PreviewShapeBrushColor        : TColor read fPreviewShapeBrushColor         write fPreviewShapeBrushColor         ;
        property PreviewShapeProgressPenColor  : TColor read fPreviewShapeProgressPenColor   write fPreviewShapeProgressPenColor   ;
        property PreviewShapeProgressBrushColor: TColor read fPreviewShapeProgressBrushColor write fPreviewShapeProgressBrushColor ;
    end;

  TGradientOrientation = (goVertical, goHorizontal);

  TPixelRec = packed record 
    case Boolean of 
      true:  (Color: TColor); 
      false: (r, g, b, Reserved: Byte);
  end;


var Spectrum : TSpectrum;

implementation

uses NempMainUnit, VSTEditControls, system.UITypes;

procedure DrawGradient(const Canvas: TCanvas; Color1, Color2: TColor;
                       ARect: TRect; GradientOrientation: TGradientOrientation; aHeight: Integer);
var 
  c1, c2, c: TPixelRec;  //for easy access to RGB values as well as TColor value
  x, y: Integer;         //current pixel position to be set 
  OldPenWidth: Integer;  //Save old settings to restore them properly 
  OldPenStyle: TPenStyle;//see above
  OldPenColor: TColor;
begin 
  c1.Color := ColorToRGB(Color1);  //convert system colors to RGB values
  c2.Color := ColorToRGB(Color2);  //if neccessary 
  OldPenWidth := Canvas.Pen.Width; //get old settings 
  OldPenStyle := Canvas.Pen.Style;
  OldPenColor := Canvas.Pen.Color;
  Canvas.Pen.Width:=1;             //ensure correct pen settings 
  Canvas.Pen.Style:=psInsideFrame;

  case GradientOrientation of 
    goVertical: 
    begin 
      for y :=  (ARect.Bottom - Arect.Top) downto (0) do
      begin
        c.r := Round(c1.r + (c2.r - c1.r) * (y) / aHeight);//(ARect.Bottom - ARect.Top));
        c.g := Round(c1.g + (c2.g - c1.g) * (y) / aHeight);//(ARect.Bottom - ARect.Top));
        c.b := Round(c1.b + (c2.b - c1.b) * (y) / aHeight);//(ARect.Bottom - ARect.Top));
        Canvas.Pen.Color := 256*256 * c.b + 256*c.g + c.r;
        // c.color doesnt work ... some issues with transparency ??
        Canvas.MoveTo(ARect.Left, ARect.Bottom-y);
        Canvas.LineTo(ARect.Right, ARect.Bottom-y);
      end;
    end; 
    goHorizontal: 
    begin 
      for x := 0 to ARect.Right - ARect.Left do 
      begin 
        c.r := Round(c1.r + (c2.r - c1.r) * x / (ARect.Right - ARect.Left)); 
        c.g := Round(c1.g + (c2.g - c1.g) * x / (ARect.Right - ARect.Left)); 
        c.b := Round(c1.b + (c2.b - c1.b) * x / (ARect.Right - ARect.Left));
        Canvas.Brush.Color := c.Color;
        Canvas.FillRect(Rect(ARect.Left + x, ARect.Top, 
                             ARect.Left + x + 1, ARect.Bottom)); 
      end; 
    end; 
  end; 
  Canvas.Pen.Width := OldPenWidth; //restore old settings 
  Canvas.Pen.Style := OldPenStyle;
  Canvas.Pen.Color := OldPenColor;
end;




Constructor TSpectrum.Create(Width, Height : Integer);
begin
    VisBuff := TBitmap.Create;
    BackBmp := TBitmap.Create;
    BackStarBMP := TBitmap.Create;

    SpecHeightPreview := 38;

    GradientBMP := TBitmap.Create;

    VisBuff.Width := Width;
    VisBuff.Height := Height;

    BkgColor := clBlack;
    SpecHeight := Height;
    PenColor := clWhite;
    PeakColor := clYellow;
    DrawType := 0;
    DrawRes  := 2;
    FrmClear := True;
    UseBkg := False;
    PeakFall := 1;
    LineFall := 3;
///    ColWidth := 4;      //
    ShowPeak := True;

    fDelayCounter := 0;
    fScrollDelay := 0;

    SetScale(1);
end;

Destructor TSpectrum.Destroy;
begin
    VisBuff.Free;
    BackBmp.Free;
    BackStarBMP.Free;
    GradientBMP.Free;
    inherited destroy;
end;

procedure TSpectrum.SetBackGround (Active : Boolean);
var // grpPoint, OffsetPoint: TPoint;
  pnlPoint: TPoint;
 sourceBmp: TBitmap;
 stretch: Boolean;
begin
UseBkg := Active;

if active then
  with Nemp_MainForm do
  begin
      if NempSkin.UseSeparatePlayerBitmap then
      begin
          sourceBmp := NempSkin.PaintedProgressBitmap;
          stretch := False;

          NempSkin.TileGraphic(sourceBmp, False, BackBmp.Canvas,
                PaintFrame.Left,
                PaintFrame.Top,
                stretch);
      end else
      begin
          sourceBmp := NempSkin.CompleteBitmap;
          // stretch := NempSkin.NempPartyMode.Active;
          pnlPoint := PaintFrame.ClientToScreen(Point(0,0));

          NempSkin.TileGraphic(sourceBmp, NempSkin.TileControlBackground, BackBmp.Canvas,
              pnlPoint.X - NempSkin.PlayerPageOffsetX,
              pnlPoint.Y - NempSkin.PlayerPageOffsetY,
              False)
      end;
  end;
end;


procedure TSpectrum.SetStarBackGround(Active: Boolean);
var pnlPoint: TPoint;
    sourceBmp: TBitmap;
    stretch: Boolean;
begin
    UseBkg := Active;
    if active then
        with Nemp_MainForm do
        begin
            if NempSkin.UseSeparatePlayerBitmap then
            begin
                // similar than in NempSkin.DrawAControlPanel
                sourceBmp := NempSkin.PaintedProgressBitmap;
                stretch := False;
                NempSkin.TileGraphic(sourceBmp, False, BackStarBMP.Canvas,
                      RatingImage.Left,
                      RatingImage.Top,
                      stretch)
            end else
            begin
                sourceBmp := NempSkin.CompleteBitmap;
                // stretch := False;
                pnlPoint := RatingImage.ClientToScreen(Point(0,0));

                NempSkin.TileGraphic(sourceBmp, NempSkin.TileControlBackground, BackStarBMP.Canvas,
                      pnlPoint.X - NempSkin.PlayerPageOffsetX,
                      pnlPoint.Y - NempSkin.PlayerPageOffsetY,
                      False)
            end;
        end;
end;

procedure TSpectrum.SetGradientBitmap;
begin
    GradientBMP.Height := Visbuff.Height;
    GradientBMP.Width := ColWidth;
    DrawGradient(GradientBMP.Canvas,
                    PenColor, PenColor2,
                    Rect( 0, 0, GradientBMP.Width, GradientBMP.Height),
                    goVertical,
                    GradientBMP.Height );
end;

procedure TSpectrum.SetScale(aStretchFactor: Single);
begin
    Height := Round(NempOriginalSpectrumSpecs.Height * aStretchFactor);
    BackBmp.Width := Round(NempOriginalSpectrumSpecs.Width * aStretchFactor);
    BackBmp.Height := Height;
    VisBuff.Width  := BackBmp.Width ;
    VisBuff.Height := Height;

    SetBackGround(UseBkg);

    BackStarBMP.Width := Round(NempOriginalSpectrumSpecs.StarWidth * aStretchFactor);
    BackStarBMP.Height := Round(NempOriginalSpectrumSpecs.StarHeight * aStretchFactor);
    SetStarBackground(UseBkg);

    ColWidth := Round(NempOriginalSpectrumSpecs.ColumnWidth * aStretchFactor);
    GradientBMP.Width := Round(NempOriginalSpectrumSpecs.ColumnWidth * aStretchFactor);
    GradientBMP.Height := Round(NempOriginalSpectrumSpecs.GradientHeight * aStretchFactor);
    SetGradientBitmap;

    fFFTDataMultiplikator := Round(NempOriginalSpectrumSpecs.FFTDataMultiplikator * aStretchFactor);
    fFFTDataMultiplikatorPreView := NempOriginalSpectrumSpecs.FFTDataMultiplikator;

end;



procedure TSpectrum.Draw(FFTData : TFFTData);
var i, YPos, YPosPreview : LongInt; YVal : Single;
begin

    if FrmClear then
    begin
        VisBuff.Canvas.Pen.Color := BkgColor;
        VisBuff.Canvas.Brush.Style := bsSolid;
        VisBuff.Canvas.Brush.Color := BkgColor;
        VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height);

        if UseBkg then
        begin
            VisBuff.Canvas.CopyRect(
                Rect(0, 0, BackBmp.Width, BackBmp.Height),
                BackBmp.Canvas,
                Rect(0, 0, BackBmp.Width, BackBmp.Height));
        end;
    end;


    VisBuff.Canvas.Pen.Color := PenColor;
    //for i := 0 to 30 do
    for i := 0 to 24 do
    begin
      YVal := Abs(FFTData[(i * DrawRes) + 5]);
      YPos := Trunc((YVal) * fFFTDataMultiplikator);
      if YPos > Height then YPos := SpecHeight;

      if YPos >= FFTPeacks[i] then FFTPeacks[i] := YPos
        else FFTPeacks[i] := FFTPeacks[i] - PeakFall;

      if YPos >= FFTFallOff[i] then
        FFTFallOff[i] := YPos - 1
      else
        FFTFallOff[i] := FFTFallOff[i] - LineFall;


      YPosPreview := Trunc((YVal) * fFFTDataMultiplikatorPreView);
      if YPosPreview > SpecHeightPreview then YPosPreview := SpecHeightPreview;

      if YPosPreview >= FFTPeacksPreview[i] then FFTPeacksPreview[i] := YPosPreview
        else FFTPeacksPreview[i] := FFTPeacksPreview[i] - PeakFall;

      if YPosPreview >= FFTFallOffPreview[i] then
        FFTFallOffPreview[i] := YPosPreview - 1
      else
        FFTFallOffPreview[i] := FFTFallOffPreview[i] - LineFall;


      // ----------------------------------------
      if FFTPeacks[i] < 1 then   // damit die Peaks nicht verschwinden, sondern untern liegen bleiben
        FFTPeacks[i] := 1;

      if FFTPeacks[i] > VisBuff.Height then // damit die Peaks nicht nach oben hin verschwinden
        FFTPeacks[i] := VisBuff.Height;
      //----------------------
      // ----------------------------------------
      if FFTPeacksPreview[i] < 1 then   // damit die Peaks nicht verschwinden, sondern untern liegen bleiben
        FFTPeacksPreview[i] := 1;

      if FFTPeacksPreview[i] > SpecHeightPreview then // damit die Peaks nicht nach oben hin verschwinden
        FFTPeacksPreview[i] := SpecHeightPreview;
      //----------------------


      case DrawType of
          0 : begin
                 VisBuff.Canvas.MoveTo(i, VisBuff.Height);
                 VisBuff.Canvas.LineTo(i, VisBuff.Height - FFTFallOff[i]);
                 if ShowPeak then VisBuff.Canvas.Pixels[i, VisBuff.Height - FFTPeacks[i]] := Pen;
          end;

          1 : begin
               VisBuff.Canvas.Pen.Color := PenColor;
               VisBuff.Canvas.Brush.Color := PenColor;
               VisBuff.Canvas.CopyRect(Rect((i * (ColWidth + 1))+1,            VisBuff.Height - FFTFallOff[i],
                                           (i * (ColWidth + 1))+1 + ColWidth, VisBuff.Height),
                                       GradientBMP.Canvas,
                                       Rect(0, VisBuff.Height - FFTFallOff[i], ColWidth, VisBuff.Height)
               );

               if ShowPeak then
               begin
                  VisBuff.Canvas.Pen.Color := PeakColor;
                  VisBuff.Canvas.MoveTo((i * (ColWidth + 1))+1, VisBuff.Height - FFTPeacks[i]);
                  VisBuff.Canvas.LineTo((i * (ColWidth + 1))+1 + ColWidth, VisBuff.Height - FFTPeacks[i]);
               end;
          end;
      end;
    end;

    MainImage.Picture.Assign(VisBuff);

   // BitBlt(MainImage.Canvas.Handle, 0,   0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0,  0, srccopy);
    // MainImage.Refresh;      ??? commented out 2019
end;


procedure TSpectrum.DrawClear;
var i: integer;
begin

    VisBuff.Canvas.Pen.Color := BkgColor;
    VisBuff.Canvas.Brush.Color := BkgColor;
    VisBuff.Canvas.Rectangle(0, 0, VisBuff.Width, VisBuff.Height);
    if UseBkg then
        VisBuff.Canvas.CopyRect(Rect(0, 0, BackBmp.Width, BackBmp.Height),
              BackBmp.Canvas,
              Rect(0, 0, BackBmp.Width, BackBmp.Height));


    for i := 0 to 30 do
    begin
        FFTPeacks[i] := 1;
        FFTFallOff[i] := 0;
        if ShowPeak then
        begin
            VisBuff.Canvas.Pen.Color := PeakColor;
            VisBuff.Canvas.MoveTo(0 + i * (ColWidth + 1), 0 + VisBuff.Height - 1);
            VisBuff.Canvas.LineTo(0 + i * (ColWidth + 1) + ColWidth, 0 + VisBuff.Height - 1);
        end;
    end;

    //BitBlt(MainImage.Canvas.Handle, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy);
    MainImage.Picture.Assign(VisBuff);
    MainImage.Refresh;
end;

procedure TSpectrum.DrawRating(aRating: Integer);
var aBmp: TBitmap;
begin
    if aRating = 0 then
        aRating := 127;
    aBmp := TBitmap.Create;
    try
        if UseBkg then
            aBmp.Assign(BackStarBMP)
        else
        begin
            aBmp.Width := StarImage.Width;
            aBmp.Height := StarImage.Height;
            aBmp.Canvas.Pen.Color := BkgColor;
            aBmp.Canvas.Brush.Style := bsSolid;
            aBmp.Canvas.Brush.Color := BkgColor;
            aBmp.Canvas.Rectangle(0, 0, aBmp.Width, aBmp.Height);
        end;

        PlayerRatingGraphics.DrawRatingInStars(aRating, aBmp.canvas, aBmp.Height);
         //aBmp.Transparent := True;

         StarImage.Picture.Assign(aBmp);
         StarImage.Tag := aRating;
    finally
        aBmp.Free;
    end;



end;

end.

