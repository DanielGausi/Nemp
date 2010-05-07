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
unit spectrum_vis;
{
}

interface
  uses Windows, Dialogs, Graphics, SysUtils,  Classes, Nemp_Skinsystem, ExtCtrls;

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

    const NempOriginalSpectrumSpecs: TSpectrumSpecs =
    (
        Width       : 114;
        Height      : 38;
        TextWidth   : 216;
        TextHeight  : 18;
        TimeWidth   : 53;
        TimeHeight  : 18;
        StarHeight  : 14;
        StarWidth   : 70;
        ColumnWidth : 4;
        PreviewColumn: 2;
        GradientHeight : 38;
        TimeFontSize: 10;
        TextFontSize: 10;
        FFTDataMultiplikator: 500;
    );

    const PREVIEW_COLUMN_WIDTH = 3;
          PREVIEW_COLUMN_HEIGHT = 38;

    type TSpectrum = Class(TObject)
    private
        VisBuff : TBitmap;
        TxtBuff : TBitmap;
        BackBmp : TBitmap;
        BackTimeBmp : TBitmap;
        BackTextBMP : TBitmap;
        BackStarBMP : TBitmap;
        BackPreViewBuf: TBitmap;

        GradientBMP: TBitmap;
        GradientBMPPreView: TBitmap;


        BkgColor : TColor;
        TitelBkgCOlor: TColor;
        TimeBkgColor: TColor;
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

        FTextStyle: TFontStyles;
        FTextColor: TColor;

        FTimeStyle: TFontStyles;
        FTimeColor: TColor;

        FPreviewArtistColor: TColor;
        FPreviewTitleColor: TColor;
        FPreviewTimeColor: TColor;


        fTimeFontSize: Integer;
        fTextFontSize: Integer;

        fFFTDataMultiplikator: Integer;
        fFFTDataMultiplikatorPreView: Integer;

        FTimeTextBackground: TBrushStyle;
        FTitelTextBackground: TBrushStyle;

        FTimeString: String;
        FTextString: UnicodeString;

        FFTPeacks  : array [0..30] of Integer;
        FFTFallOff : array [0..30] of Integer;

        FFTPeacksPreView  : array [0..30] of Integer;
        FFTFallOffPreView : array [0..30] of Integer;

        fTextPosX: Integer;
        fTextPosY: Integer;

        fScrollDelay: Integer;
        fDelayCounter: Integer;


    public
        MainImage: TImage;
        TextImage: TImage;
        TimeImage: TImage;
        StarImage: TImage;

        PreViewBuf: TBitmap; // Buffer for Win7-Preview


        Constructor Create (Width, Height : Integer);
        Destructor Destroy; override;


        procedure Draw(FFTData : TFFTData);
        procedure DrawText(aString: UnicodeString = ''; Scroll: Boolean = True);

        procedure DrawTime(aString: String);

        procedure DrawRating(aRating: Integer);

        procedure DrawClear;
        procedure SetBackGround (Active : Boolean);
        procedure SetTimeBackGround (Active : Boolean);
        procedure SetTextBackGround (Active : Boolean);

        procedure SetStarBackGround (Active: Boolean);
        procedure SetGradientBitmap;

        procedure SetScale(aStretchFactor: Single);

        property BackColor : TColor read BkgColor write BkgColor;
        property TimebackColor : tColor read TimeBkgColor write TimeBkgColor;
        property TitelbackColor : tColor read TitelBkgColor write TitelBkgColor;

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
        property TextStyle  : TFontStyles read FTextStyle write FTextStyle;
        property TextColor  : TColor read FTextColor write FTextColor;
        property TimeTextBackground : TBrushStyle read FTimeTextBackground write FTimeTextBackground;
        property TitelTextBackground: TBrushStyle read FTitelTextBackground write FTitelTextBackground;

        property TimeStyle  : TFontStyles read FTimeStyle write FTimeStyle;
        property TimeColor  : TColor read FTimeColor write FTimeColor;
        property UseBackGround: Boolean read Usebkg write UseBkg;

        property PreviewArtistColor: TColor read FPreviewArtistColor write FPreviewArtistColor;
        property PreviewTitleColor: TColor read FPreviewTitleColor write FPreviewTitleColor;
        property PreviewTimeColor: tColor read FPreviewTimeColor write FPreviewTimeColor;


        // Dieser wird bei DrawTime gesetzt, so dass man nach einem Pause-Klick beim verschieben der Form
        // Die Zeit neu malen kann
        property TimeString: String Read fTimeString;
        property TextString: UnicodeString read FTextString;

        property TextPosX: Integer read fTextPosX write fTextPosX;
        property TextPosY: Integer read fTextPosY write fTextPosY;

        property ScrollDelay: Integer read fScrollDelay write fScrollDelay;
        //Property OffSetY    : Integer read SpecOffSetY write SpecOffSetY;
    end;

  TGradientOrientation = (goVertical, goHorizontal);

  TPixelRec = packed record 
    case Boolean of 
      true:  (Color: TColor); 
      false: (r, g, b, Reserved: Byte);
  end;


var Spectrum : TSpectrum;

implementation

uses NempMainUnit, VSTEditControls;

procedure DrawGradient(const Canvas: TCanvas; Color1, Color2: TColor;
                       ARect: TRect; GradientOrientation: TGradientOrientation; aHeight: Integer);
var 
  c1, c2, c: TPixelRec;  //for easy access to RGB values as well as TColor value 
  x, y: Integer;         //current pixel position to be set 
  OldPenWidth: Integer;  //Save old settings to restore them properly 
  OldPenStyle: TPenStyle;//see above 
begin 
  c1.Color := ColorToRGB(Color1);  //convert system colors to RGB values
  c2.Color := ColorToRGB(Color2);  //if neccessary 
  OldPenWidth := Canvas.Pen.Width; //get old settings 
  OldPenStyle := Canvas.Pen.Style; 
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
        Canvas.Brush.Color := c.Color; 
        Canvas.FillRect(Classes.Rect(ARect.Left, (ARect.Bottom {- Arect.Top}) - y,
                                     ARect.Right,(ARect.Bottom {- Arect.Top}) - y - 1));
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
end;




Constructor TSpectrum.Create(Width, Height : Integer);
begin
    VisBuff := TBitmap.Create;
    BackBmp := TBitmap.Create;
    PreViewBuf  := TBitmap.Create;
    BackPreViewBuf := TBitmap.Create;
    BackTimeBmp := TBitmap.Create;
    BackTextBMP := TBitmap.Create;
    BackStarBMP := TBitmap.Create;

    PreViewBuf.Height := 38; // something like that should be ok
    PreViewBuf.Width  := 92; //  --""--
    BackPreViewBuf.Height := 38;
    BackPreViewBuf.Width := 92;
    SpecHeightPreview := 38;

    TxtBuff := tBitmap.Create;
    GradientBMP := TBitmap.Create;
    GradientBMPPreView := TBitmap.Create;
//    GradientBmp.Height := 65;
//    GradientBMP.Width := 4;


    VisBuff.Width := Width;
    VisBuff.Height := Height;

//    BackBmp.Width := Width;
//    BackBmp.Height := Height;
//    TxtBuff.Width := 216; //TextAnzeigeIMAGE.Width  // Width - 3;
//    TxtBuff.Height := 14;//16 ; // ??
//    BackTextBMP.Width := 216; //TextAnzeigeIMAGE.Width  // Width - 3;
//    BackTextBMP.Height := 14;

//    BackTimeBMP.Width := 53;
//    BackTimeBMP.Height:= 14;


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
    PreViewBuf.Free;
    BackPreViewBuf.Free;
    BackBmp.Free;
    BackTimeBmp.Free;
    BackTextBMP.Free;
    BackStarBMP.Free;
    TxtBuff.Free;
    GradientBMP.Free;
    GradientBMPPreView.Free;
    inherited destroy;
end;

procedure TSpectrum.SetBackGround (Active : Boolean);
var grpPoint, OffsetPoint: TPoint;
 sourceBmp: TBitmap;
 localOffsetX, localOffsetY: Integer;
 stretch: Boolean;
begin
UseBkg := Active;

if active then
  with Nemp_MainForm do
  begin
      grpPoint := PaintFrame.ClientToScreen(Point(0,0));
      OffsetPoint := PlayerPanel.ClientToScreen(Point(0,0));
      if NempSkin.UseSeparatePlayerBitmap then
      begin
          localOffsetX := 0;
          localOffsetY := 0;
          sourceBmp := NempSkin.PlayerBitmap;
          stretch := NempSkin.NempPartyMode.Active;
      end else
      begin
          localOffsetX := NempSkin.PlayerPageOffsetX;
          localOffsetY := NempSkin.PlayerPageOffsetY;
          sourceBmp := NempSkin.CompleteBitmap;
          stretch := False;
      end;

      NempSkin.TileGraphic(sourceBmp, BackBmp.Canvas,
          localOffsetX + (grpPoint.X - OffsetPoint.X) ,
          localOffsetY + (grpPoint.Y - OffsetPoint.Y), stretch);

      // Same vor the Win7Preview
      localOffsetX := 102;  // Must be the same as in NempPlayer.DrawPreview
      localOffsetY := 57;
      NempSkin.TileGraphic(NempPlayer.PreviewBackGround, BackPreViewBuf.Canvas,
              localOffsetX, localOffsetY, false);
  end;

end;

procedure TSpectrum.SetTextBackGround (Active : Boolean);
var grpPoint, OffsetPoint: TPoint;
  sourceBmp: TBitmap;
  localOffsetX, localOffsetY: Integer;
  stretch: Boolean;
begin
UseBkg := Active;
if active then
  with Nemp_MainForm do
  begin
    grpPoint := TextAnzeigeIMAGE.ClientToScreen(Point(0,0));
    OffsetPoint := PlayerPanel.ClientToScreen(Point(0,0));
    if NempSkin.UseSeparatePlayerBitmap then
    begin
        localOffsetX := 0;
        localOffsetY := 0;
        sourceBmp := NempSkin.PlayerBitmap;
        stretch := NempSkin.NempPartyMode.Active;
    end else
    begin
        localOffsetX := NempSkin.PlayerPageOffsetX;
        localOffsetY := NempSkin.PlayerPageOffsetY;
        sourceBmp := NempSkin.CompleteBitmap;
        stretch := False;
    end;
    NempSkin.TileGraphic(sourceBmp, BackTextBMP.Canvas,
        localOffsetX + (grpPoint.X - OffsetPoint.X) ,
        localOffsetY + (grpPoint.Y - OffsetPoint.Y), stretch);
  end;
end;

procedure TSpectrum.SetTimeBackGround (Active : Boolean);
var grpPoint, OffsetPoint: TPoint;
  sourceBmp: TBitmap;
  localOffsetX, localOffsetY: Integer;
  stretch: Boolean;
begin
UseBkg := Active;
if active then
  with Nemp_MainForm do
  begin
    grpPoint := TimePaintBox.ClientToScreen(Point(0,0));
    OffsetPoint := PlayerPanel.ClientToScreen(Point(0,0));
    if NempSkin.UseSeparatePlayerBitmap then
    begin
        localOffsetX := 0;
        localOffsetY := 0;
        sourceBmp := NempSkin.PlayerBitmap;
        stretch := NempSkin.NempPartyMode.Active;
    end else
    begin
        localOffsetX := NempSkin.PlayerPageOffsetX;
        localOffsetY := NempSkin.PlayerPageOffsetY;
        sourceBmp := NempSkin.CompleteBitmap;
        stretch := False;
    end;
    NempSkin.TileGraphic(sourceBmp, BackTimeBMP.Canvas,
        localOffsetX + (grpPoint.X - OffsetPoint.X) ,
        localOffsetY + (grpPoint.Y - OffsetPoint.Y), stretch);
  end;
end;

procedure TSpectrum.SetStarBackGround(Active: Boolean);
var grpPoint, OffsetPoint: TPoint;
  sourceBmp: TBitmap;
  localOffsetX, localOffsetY: Integer;
  stretch: Boolean;
begin
UseBkg := Active;
if active then
  with Nemp_MainForm do
  begin
    grpPoint := RatingImage.ClientToScreen(Point(0,0));
    OffsetPoint := PlayerPanel.ClientToScreen(Point(0,0));
    if NempSkin.UseSeparatePlayerBitmap then
    begin
        localOffsetX := 0;
        localOffsetY := 0;
        sourceBmp := NempSkin.PlayerBitmap;
        stretch := NempSkin.NempPartyMode.Active;
    end else
    begin
        localOffsetX := NempSkin.PlayerPageOffsetX;
        localOffsetY := NempSkin.PlayerPageOffsetY;
        sourceBmp := NempSkin.CompleteBitmap;
        stretch := False;
    end;
    NempSkin.TileGraphic(sourceBmp, BackStarBMP.Canvas,
        localOffsetX + (grpPoint.X - OffsetPoint.X) ,
        localOffsetY + (grpPoint.Y - OffsetPoint.Y), stretch);
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
              GradientBMP.Height
             ) ;

  GradientBMPPreView.Height := PREVIEW_COLUMN_HEIGHT;
  GradientBMPPreView.Width := PREVIEW_COLUMN_WIDTH;
  DrawGradient(GradientBMPPreView.Canvas,
                  PenColor, PenColor2,
                  Rect( 0, 0, GradientBMPPreView.Width, GradientBMPPreView.Height),
              goVertical,
              GradientBMPPreView.Height
             ) ;

  //GradientBMPPreView.SaveToFile('C:\Users\Daniel\Delphi\Nemp SVN\Nemp\trunk\bin\grad.bmp');

end;

procedure TSpectrum.SetScale(aStretchFactor: Single);
begin
    Height := Round(NempOriginalSpectrumSpecs.Height * aStretchFactor);
    BackBmp.Width := Round(NempOriginalSpectrumSpecs.Width * aStretchFactor);
    BackBmp.Height := Height;
    VisBuff.Width  := BackBmp.Width ;
    VisBuff.Height := Height;

    SetBackGround(UseBkg);

    BackTextBMP.Width := Round(NempOriginalSpectrumSpecs.TextWidth * aStretchFactor);
    BackTextBMP.Height := Round(NempOriginalSpectrumSpecs.TextHeight * aStretchFactor);
    TxtBuff.Width  := BackTextBMP.Width ;
    TxtBuff.Height := BackTextBMP.Height;
    SetTextBackGround(UseBkg);

    BackTimeBmp.Width := Round(NempOriginalSpectrumSpecs.TimeWidth * aStretchFactor);
    BackTimeBmp.Height := Round(NempOriginalSpectrumSpecs.TimeHeight * aStretchFactor);
    SetTimeBackGround(UseBkg);

    BackStarBMP.Width := Round(NempOriginalSpectrumSpecs.StarWidth * aStretchFactor);
    BackStarBMP.Height := Round(NempOriginalSpectrumSpecs.StarHeight * aStretchFactor);
    SetStarBackground(UseBkg);

    ColWidth := Round(NempOriginalSpectrumSpecs.ColumnWidth * aStretchFactor);
    GradientBMP.Width := Round(NempOriginalSpectrumSpecs.ColumnWidth * aStretchFactor);
    GradientBMP.Height := Round(NempOriginalSpectrumSpecs.GradientHeight * aStretchFactor);
    SetGradientBitmap;

    fTimeFontSize := Round(NempOriginalSpectrumSpecs.TimeFontSize * aStretchFactor);
    fTextFontSize := Round(NempOriginalSpectrumSpecs.TextFontSize * aStretchFactor);

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

      PreViewBuf.Canvas.Pen.Color := BkgColor;
      PreViewBuf.Canvas.Brush.Style := bsSolid;
      PreViewBuf.Canvas.Brush.Color := BkgColor;
      PreViewBuf.Canvas.Rectangle(0, 0, PreViewBuf.Width, PreViewBuf.Height);

      if UseBkg then
      begin
          VisBuff.Canvas.CopyRect(
              Rect(0, 0, BackBmp.Width, BackBmp.Height),
              BackBmp.Canvas,
              Rect(0, 0, BackBmp.Width, BackBmp.Height));

          PreViewBuf.Canvas.CopyRect(
              Rect(0, 0, BackPreViewBuf.Width, BackPreViewBuf.Height),
              BackPreViewBuf.Canvas,
              Rect(0, 0, BackPreViewBuf.Width, BackPreViewBuf.Height));
      end;
    end;



    VisBuff.Canvas.Pen.Color := PenColor;
    for i := 0 to 30 do
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

     // if (VisBuff.Height - FFTPeacks[i]) > VisBuff.Height then FFTPeacks[i] := 0;
     // if (VisBuff.Height - FFTFallOff[i]) > VisBuff.Height then FFTFallOff[i] := 0;

     // if (SpecHeightPreview - FFTPeacksPreview[i]) > SpecHeightPreview then FFTPeacksPreview[i] := 0;
     // if (SpecHeightPreview - FFTFallOffPreview[i]) > SpecHeightPreview then FFTFallOffPreview[i] := 0;

      case DrawType of
          0 : begin
                 VisBuff.Canvas.MoveTo(i, VisBuff.Height);
                 VisBuff.Canvas.LineTo(i, VisBuff.Height - FFTFallOff[i]);
                 if ShowPeak then VisBuff.Canvas.Pixels[i, VisBuff.Height - FFTPeacks[i]] := Pen;
          end;

          1 : begin
               VisBuff.Canvas.Pen.Color := PenColor;
               VisBuff.Canvas.Brush.Color := PenColor;
               VisBuff.Canvas.CopyRect(Rect(i * (ColWidth + 1),            VisBuff.Height - FFTFallOff[i],
                                            i * (ColWidth + 1) + ColWidth, VisBuff.Height),
                                       GradientBMP.Canvas,
                                       Rect(0, VisBuff.Height - FFTFallOff[i], ColWidth, VisBuff.Height)
               );

               if ShowPeak then
               begin
                  VisBuff.Canvas.Pen.Color := PeakColor;
                  VisBuff.Canvas.MoveTo(i * (ColWidth + 1), VisBuff.Height - FFTPeacks[i]);
                  VisBuff.Canvas.LineTo(i * (ColWidth + 1) + ColWidth, VisBuff.Height - FFTPeacks[i]);
               end;


               PreViewBuf.Canvas.Pen.Color := PenColor;
               PreViewBuf.Canvas.Brush.Color := PenColor;
               PreViewBuf.Canvas.CopyRect(Rect(i * (PREVIEW_COLUMN_WIDTH + 1),                     PreViewBuf.Height - FFTFallOffPreview[i],
                                            i * (PREVIEW_COLUMN_WIDTH + 1) + PREVIEW_COLUMN_WIDTH, PreViewBuf.Height),
                                       GradientBMPPreview.Canvas,
                                       Rect(0, PreViewBuf.Height - FFTFallOffPreview[i], PREVIEW_COLUMN_WIDTH, PreViewBuf.Height)
               );

               if ShowPeak then
               begin
                  PreViewBuf.Canvas.Pen.Color := PeakColor;
                  PreViewBuf.Canvas.MoveTo(i * (PREVIEW_COLUMN_WIDTH + 1), PreViewBuf.Height - FFTPeacksPreview[i]);
                  PreViewBuf.Canvas.LineTo(i * (PREVIEW_COLUMN_WIDTH + 1) + PREVIEW_COLUMN_WIDTH, PreViewBuf.Height - FFTPeacksPreview[i]);
               end;



          end;
      end;
    end;

    MainImage.Picture.
    Assign(VisBuff);

   // BitBlt(MainImage.Canvas.Handle, 0,   0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0,  0, srccopy);
    MainImage.Refresh;
end;

procedure TSpectrum.DrawText(aString: UnicodeString = ''; Scroll: Boolean = True);
var textwidth: integer;
begin
    if Not Scroll then fTextPosX := 4;

    TxtBuff.Canvas.Font.Size := fTextFontSize;
    TxtBuff.Canvas.Pen.Color := TitelBkgColor;
    TxtBuff.Canvas.Brush.Style := bsSolid;
    TxtBuff.Canvas.Brush.Color := TitelBkgColor;
    if UseBkg then
        TxtBuff.Canvas.CopyRect(Rect(0, 0, BackTextBmp.Width, BackTextBmp.Height),
        BackTextBmp.Canvas,
        Rect(0, 0, BackTextBmp.Width, BackTextBmp.Height))
    else
        TxtBuff.Canvas.Rectangle(0, 0, TxtBuff.Width, TxtBuff.Height);

  TxtBuff.Canvas.Font.Color := TextColor;
  TxtBuff.Canvas.Font.Style := TextStyle;

  TxtBuff.Canvas.Brush.Color := TitelBkgColor;
  Textwidth := TxtBuff.Canvas.TextWidth(aString);

  if Textwidth > TxtBuff.Width - 16 then
  begin
      TxtBuff.Canvas.Brush.Style := TitelTextBackground; //bsSolid;

      TxtBuff.Canvas.TextOut(fTextPosX, fTextPosY, aString);
      TxtBuff.Canvas.TextOut(fTextPosX + TextWidth,fTextPosY,'     ...     '  );
      TxtBuff.Canvas.TextOut(fTextPosX - Textwidth -
                        TxtBuff.Canvas.TextWidth('     ...     '),
                        fTextPosY, aString);
      TxtBuff.Canvas.TextOut(fTextPosX -
                        TxtBuff.Canvas.TextWidth('     ...     '),
                        fTextPosY,'     ...     ');

      if Scroll then
      begin
          inc(fDelayCounter);
          if fDelayCounter >= fScrollDelay then
          begin
              fDelayCounter := 0;
              dec(fTextPosX, 1);
          end;
      end;
  end else
  begin
      TxtBuff.Canvas.Brush.Style := TitelTextBackground;// bsSolid;//bsDiagCross;
      TxtBuff.Canvas.TextOut(4,fTextPosY,aString);
  end;

  if fTextPosX < 0 then
    fTextPosX := TextWidth + TxtBuff.Canvas.TextWidth('     ...     ');

    TextImage.Picture.Assign(TxtBuff);
  //BitBlt(TextImage.Canvas.Handle, 0,   0, TxtBuff.Width, TxtBuff.Height, TxtBuff.Canvas.Handle, 0,  0, srccopy);
  TextImage.refresh;
  FTextString := aString;
end;

procedure TSpectrum.DrawTime(aString: String);
var timeWidth: integer;
begin
  TxtBuff.Canvas.Pen.Color := TimeBkgColor;
  TxtBuff.Canvas.Brush.Style := bsSolid;
  TxtBuff.Canvas.Brush.Color := TimeBkgColor;
  TxtBuff.Canvas.Font.Size := fTimeFontSize;

  if UseBkg then
      TxtBuff.Canvas.CopyRect(Rect(0, 0, BackTimeBMP.Width, BackTimeBMP.Height),
          BackTimeBmp.Canvas,
          Rect(0, 0, BackTimeBMP.Width, BackTimeBMP.Height))
  else
      TxtBuff.Canvas.Rectangle(0, 0, BackTimeBMP.Width, BackTimeBMP.Height);

  TxtBuff.Canvas.Font.Color := TimeColor;
  TxtBuff.Canvas.Font.Style := TimeStyle;

  timeWidth := TxtBuff.Canvas.TextWidth(aString);

  TxtBuff.Canvas.Brush.Color := TimeBkgColor;
  TxtBuff.Canvas.Brush.Style := TimeTextBackground; //bsSolid;//bsDiagCross;
  //TxtBuff.Canvas.TextOut(BackTimeBMP.Width - timeWidth ,0,aString);
  TxtBuff.Canvas.TextOut(0 ,0,aString);

  TimeImage.Picture.Assign(TxtBuff);
  //BitBlt(TimeImage.Canvas.Handle, 0,   0, BackTimeBMP.Width, BackTimeBMP.Height, TxtBuff.Canvas.Handle, 0,  0, srccopy);
  TimeImage.Refresh;
  fTimeString := aString;
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


    PreViewBuf.Canvas.Pen.Color := BkgColor;
    PreViewBuf.Canvas.Brush.Color := BkgColor;
    PreViewBuf.Canvas.Rectangle(0, 0, PreViewBuf.Width, PreViewBuf.Height);
    if UseBkg then
        PreViewBuf.Canvas.CopyRect(
              Rect(0, 0, BackPreViewBuf.Width, BackPreViewBuf.Height),
              BackPreViewBuf.Canvas,
              Rect(0, 0, BackPreViewBuf.Width, BackPreViewBuf.Height));

    for i := 0 to 30 do
    begin
        FFTPeacks[i] := 1;
        FFTFallOff[i] := 0;
        if ShowPeak then
        begin
            VisBuff.Canvas.Pen.Color := PeakColor;
            VisBuff.Canvas.MoveTo(0 + i * (ColWidth + 1), 0 + VisBuff.Height - 1);
            VisBuff.Canvas.LineTo(0 + i * (ColWidth + 1) + ColWidth, 0 + VisBuff.Height - 1);


             PreViewBuf.Canvas.Pen.Color := PeakColor;
             PreViewBuf.Canvas.MoveTo(i * (PREVIEW_COLUMN_WIDTH + 1), PreViewBuf.Height - 1);
             PreViewBuf.Canvas.LineTo(i * (PREVIEW_COLUMN_WIDTH + 1) + PREVIEW_COLUMN_WIDTH, PreViewBuf.Height - 1);
        end;
    end;

    BitBlt(MainImage.Canvas.Handle, 0, 0, VisBuff.Width, VisBuff.Height, VisBuff.Canvas.Handle, 0, 0, srccopy);
    MainImage.Refresh;
end;

procedure TSpectrum.DrawRating(aRating: Integer);
var aBmp: TBitmap;
begin
    if aRating = 0 then
        aRating := 127;
    aBmp := TBitmap.Create;
    try
        //aBmp.Width := RatingImage.Width;
        //aBmp.Height := RatingImage.Height;



        TxtBuff.Canvas.Font.Size := fTextFontSize;
    TxtBuff.Canvas.Pen.Color := TitelBkgColor;
    TxtBuff.Canvas.Brush.Style := bsSolid;
    TxtBuff.Canvas.Brush.Color := TitelBkgColor;
    if UseBkg then
        TxtBuff.Canvas.CopyRect(Rect(0, 0, BackTextBmp.Width, BackTextBmp.Height),
        BackTextBmp.Canvas,
        Rect(0, 0, BackTextBmp.Width, BackTextBmp.Height))
    else
        TxtBuff.Canvas.Rectangle(0, 0, TxtBuff.Width, TxtBuff.Height);


        if UseBkg then
            aBmp.Assign(BackStarBMP)
        else
        begin
            aBmp.Width := StarImage.Width;
            aBmp.Height := StarImage.Height;
            aBmp.Canvas.Brush.Style := bsSolid;
            aBmp.Canvas.Brush.Color := BkgColor;
            aBmp.Canvas.Rectangle(0, 0, aBmp.Width, aBmp.Height);
        end;

        PlayerRatingGraphics.DrawRatingInStars(aRating, aBmp.canvas, aBmp.Height);
         //aBmp.Transparent := True;

         StarImage.Picture.Assign(aBmp);
         StarImage.Tag := aRating;
        //RatingImage.Picture.Bitmap.Assign(aBmp);
    finally
        aBmp.Free;
    end;



end;

end.

