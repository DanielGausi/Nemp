{
Txxx_Checkbox = class(TCheckBox) 
private 
 Procedure CMWantspecialKey(var Msg : TWMKey); message CM_WANT 
SpecialKey; 
End; 


Procedure Txxx_Checkbox.CMWantSpecialKey (var Msg : TWMKey); 
Begin 
  inherited;
  with msg do
   Case Charcode of
     vk_left, vk_up, vk_right, vk_down : Result:=1;
   End;
End;

}



{
Notes:


NumGlyph: Property von BitBtn
NumGlyphX: Dasselbe, aber für den Skin-Modus
  ==> Einmal setzen (für Nemp auf 2 bzw. 5), nie ändern
----------------------
NumGlyphsY: Bleibt für jeden Button auch konstant
  ==> Trotzdem: Für X/Y-Change: Glyph neu setzen!

NempGlyph: Kompletter Glyph mit ggf. mehreren Zeilen.
  ==> Im Windows-Modus bei Änderung des States
      - Glyph ändern
  ==> Bei State-Änderung: Invalidate
  ==> Bei Zuweisung an NempGlyph:
      - im Windows-Modus: Glyph setzen
      - Invalidate
}

{

Todo
IDE: Kein neuzeichnen bei MouseOver etc.
X-Factor: Rückfall, falls weniger als 5 Glyphs in X-Richtung

FocusRectMode: einige Standard-Alternativen anbieten

}



unit SkinButtons;


interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, System.Types;


type

  TRGBArray = array[0..32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;

  TDrawButtonEvent = procedure(Control: TWinControl;
    aRect: TRect; State: TOwnerDrawState) of object;

  TDrawMode = (dm_Windows, dm_Skin);

  TFocusDrawMode = (fdm_Windows, fdm_Triangle, fdm_Custom);


  TSkinButton = class(TBitBtn)
  private
    FCanvas2: TCanvas;
    IsFocused: Boolean;
    FIsMouseOver: Boolean;
    FOnDrawButton: TDrawButtonEvent;
    FOnCustomDrawFocusRect: TDrawButtonEvent;
    // FDrawCustomFocusRect: Boolean;

    FFocusDrawMode: TFocusDrawMode;
    FColor1: TColor;
    FColor2: TColor;
    FNempGlyph: TBitmap;

    FNumGlyphsX: Integer;
    FNumGlyphsY: Integer;
    FGlyphLine: Integer;
    FCustomRegion: Boolean;
    FDrawMode: TDrawMode;

    FAcceptArrowKeys: Boolean;

    procedure SetNempGlyph(Value: TBitmap);
    function GetNempGlyph: TBitmap;


    procedure SetNumGlyphsX(Value: Integer);
    procedure SetNumGlyphsY(Value: Integer);
    procedure SetGlyphLine(Value: Integer);
    procedure SetCustomRegion(Value: Boolean);
    procedure SetDrawMode(Value: TDrawMode);

    function CreateRegion(Bmp: TBitmap): THandle;

    procedure SetWidth(Value: Integer);
    function GetWidth: Integer;
    procedure SetHeight(Value: Integer);
    function GetHeight: Integer;



  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;

    Procedure CMWantspecialKey(var Msg : TWMKey); message CM_WANTSpecialKey;

    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
//    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
//    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
//    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;

    // procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure DrawButton(aRect: TRect; State: UINT);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read FCanvas2;
    property IsMouseOver: Boolean read FIsMouseOver;

    Procedure ResetGlyph;
//    procedure SetCustomRegion(Value: Boolean);
  published
    property OnDrawButton: TDrawButtonEvent read FOnDrawButton write FOnDrawButton;
    property OnCustomDrawFocusRect: TDrawButtonEvent read FOnCustomDrawFocusRect write FOnCustomDrawFocusRect;
    property DrawMode: TDrawMode read FDrawMode write SetDrawMode;
    //property DrawCustomFocusRect: Boolean read FDrawCustomFocusRect write FDrawCustomFocusRect;
    // Save the Bitmap which is drawn on Canvas
    property NempGlyph: TBitmap read GetNempGlyph write SetNempGlyph;
    // Specifies the numbers of horizontal/vertical Glyphs
    property NumGlyphsX: Integer read FNumGlyphsX write SetNumGlyphsX;
    property NumGlyphsY: Integer read FNumGlyphsY write SetNumGlyphsY;
    // specifies the line (e.g. "Play" or "Pause")
    property GlyphLine: Integer read FGlyphLine write SetGlyphLine;
    property CustomRegion: Boolean read FCustomRegion write SetCustomRegion;

    property FocusDrawMode: TFocusDrawMode read FFocusDrawMode write FFocusDrawMode;
    property Color1: TColor read FColor1 write FColor1;
    property Color2: TColor read FColor2 write FColor2;

    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;

    property AcceptArrowKeys: Boolean read FAcceptArrowKeys write FAcceptArrowKeys default false;



  end;




procedure Register;


implementation







constructor TSkinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNumGlyphsX := 5;
  FNumGlyphsY := 1;
  FCanvas2 := TCanvas.Create;

  FIsMouseOver := False;
  FNempGlyph := TBitmap.Create;
end;


destructor TSkinButton.Destroy;
begin
  inherited Destroy;
  FCanvas2.Free;
  FNempGlyph.Free;
end;


procedure TSkinButton.CreateParams(var Params: TCreateParams);
begin 
  inherited CreateParams(Params); 
  with Params do Style := Style or BS_OWNERDRAW;
end; 


procedure TSkinButton.SetButtonStyle(ADefault: Boolean);
begin
  if FDrawMode = dm_Windows then
      inherited SetButtonStyle(ADefault)
  else
  begin
      if ADefault <> IsFocused then
      begin
        IsFocused := ADefault;
        Refresh;
      end;
  end;
end;


{procedure TSkinButton.CNMeasureItem(var Message: TWMMeasureItem);
begin
  if FDrawMode = dm_Windows then
      inherited
  else
      with Message.MeasureItemStruct^ do
      begin
        itemWidth  := Width - 2;
        itemHeight := Height - 2;
      end;
end;}


// Setzt das Glyph neu, wenn
// - NempGlyph neu gesetzt wird
// - Wenn NumGlyphY verändert wird
// - Wenn GlyphLine geändert wird
Procedure TSkinButton.ResetGlyph;
var bmp: TBitmap;
    //ms: TMemorystream;
begin
    bmp := TBitmap.Create;
    try
        bmp.Width := fNempGlyph.Width;
        bmp.Height := FNempGlyph.Height Div FNumGlyphsY;
        bmp.Canvas.CopyRect(Rect(0,0,bmp.Width, bmp.Height), fNempGlyph.Canvas,
              Rect(0 , (fNempGlyph.Height Div FNumGlyphsY) * FGlyphLine,
                   bmp.Width , (fNempGlyph.Height Div FNumGlyphsY) * FGlyphLine + bmp.Height) );

        Glyph.Assign(bmp);
        invalidate;

       // ms := TMemorystream.Create;
       // fNempGlyph.SaveToStream(ms);
       // ms.free;
    finally
        bmp.Free;
    end;
end;

function TSkinButton.GetNempGlyph: TBitmap;
begin
  Result := FNempGlyph;
end;

procedure TSkinButton.SetNempGlyph(Value: TBitmap);
begin
  FNempGlyph.Assign(Value);

  if FCustomRegion then
      SetCustomRegion(FCustomRegion);

  ResetGlyph;

//  if not (csLoading in ComponentState) then
      Invalidate;
end;


procedure TSkinButton.SetNumGlyphsX(Value: Integer);
begin
    if Value > 0 then
        FNumGlyphsX := Value
    else
        FNumGlyphsX := 1;
    // Glyph bleibt gleich, und NumGlyph (BitBtn) soll hiervon unabhängig sein
    // Also: Nothing more...;-)
end;
procedure TSkinButton.SetNumGlyphsY(Value: Integer);
begin
    if Value > 0 then
        FNumGlyphsY := Value
    else
        FNumGlyphsY := 1;
    // Todo: Glyph anpassen
    ResetGlyph;
end;
procedure TSkinButton.SetGlyphLine(Value: Integer);
begin
    if (Value >= 0) and (Value <= FNumGlyphsY) then
        FGlyphLine := Value
    else
        FGlyphLine := 0;

    ResetGlyph;
    // Todo: Glyph anpassen
end;

procedure TSkinButton.SetDrawMode(Value: TDrawMode);
begin
    FDrawMode := Value;
    ResetGlyph;
    // Todo: Glyph anpassen
end;

procedure TSkinButton.SetWidth(Value: Integer);
begin
    inherited Width := Value;
    SetCustomRegion(fCustomRegion);
end;
function TSkinButton.GetWidth: Integer;
begin
   result := inherited width;
end;
procedure TSkinButton.SetHeight(Value: Integer);
begin
    inherited Height := Value;
    SetCustomRegion(fCustomRegion);
end;
function TSkinButton.GetHeight: Integer;
begin
   result := inherited Height;
end;

//  http://www.delphi-forum.de/viewtopic.php?t=7428&highlight=region+farbe
function TSkinButton.CreateRegion(Bmp: TBitmap): THandle;
var
  X, Y, StartX: Integer;
  Excl: THandle;
  Row: PRGBArray;
  TransparentColor: TRGBTriple;
begin
  Bmp.PixelFormat := pf24Bit;
  Result := CreateRectRGN(0, 0, 0, 0);

  for Y := 0 to Bmp.Height - 1 do  
  begin  
    Row := Bmp.Scanline[Y];
    StartX := -1;  
    if Y = 0 then  
      TransparentColor := Row[0];

    for X := 0 to Bmp.Width - 1 do
    begin
      if (Row[X].rgbtRed <> TransparentColor.rgbtRed) or
        (Row[X].rgbtGreen <> TransparentColor.rgbtGreen) or
        (Row[X].rgbtBlue <> TransparentColor.rgbtBlue) then
      begin
        if StartX = -1 then StartX := X;
      end
      else
      begin
        if StartX > -1 then
        begin
            // d.h  start definiert und transparente Color erreicht
              Excl := CreateRectRGN(StartX, Y, X , Y + 1);
              try
                CombineRGN(Result, Result, Excl, RGN_OR);
                StartX := -1;
              finally
                DeleteObject(Excl);
              end;

        end;
      end;
    end;

    if StartX <> -1 then
    begin
      Excl := CreateRectRGN(StartX, Y, Bmp.Width, Y + 1);
      try
        CombineRGN(Result, Result, Excl, RGN_OR);
      finally
        DeleteObject(Excl);
      end;
    end;

  end;  
end;


procedure TSkinButton.SetCustomRegion(Value: Boolean);
var rgn: HRGN;
    Mask: TBitmap;
begin
    FCustomRegion := Value;

    if Not (csDesigning	in ComponentState) then
    begin
        if Value then
        begin
            if assigned(fNempGlyph) and (fDrawMode = dm_Skin) then
            begin
                Mask := TBitmap.Create;
                try
                    Mask.Height := Height;
                    Mask.Width := Width;
                    Mask.Canvas.Draw(0,0, fNempGlyph);
                    rgn := CreateRegion(Mask);
                    SetWindowRGN(Handle, rgn, True);
                finally
                    Mask.Free;
                end;
            end else
            begin
                rgn := CreateRectRgn(0,0,Width,Height);
                SetWindowRgn(Handle, rgn, True);
            end;
        end else
        begin
            rgn := CreateRectRgn(0,0,Width,Height);
            SetWindowRgn(Handle, rgn, True);
        end;
        Invalidate;
    end;
end;

Procedure TSkinButton.CMWantspecialKey(var Msg : TWMKey);
begin
  inherited;
  if AcceptArrowKeys then
  begin
      with msg do
        case Charcode of
            vk_left, vk_up, vk_right, vk_down : Result:=1;
        end;
  end;
end;


procedure TSkinButton.CNDrawItem(var Message: TWMDrawItem);
var
  SaveIndex: Integer;
begin
    if (FDrawMode = dm_Windows) or (csDesigning	in ComponentState) then
    begin
        inherited;
        Message.Result := 1;
    end
    else
    begin
        with Message.DrawItemStruct^ do
        begin
          SaveIndex := SaveDC(hDC);
          FCanvas2.Lock;
          try
            FCanvas2.Handle := hDC;
            FCanvas2.Font := Font;
            FCanvas2.Brush := Brush;
            DrawButton(rcItem, itemState);
          finally
            FCanvas2.Handle := 0;
            FCanvas2.Unlock;
            RestoreDC(hDC, SaveIndex);
          end;
        end;
        Message.Result := 1;
    end;
end;


{procedure TSkinButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;


procedure TSkinButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;
 }

//procedure TSkinButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
//begin
//  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
//end;

procedure TSkinButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  //if not (csLoading in ComponentState) then
  //begin
      FIsMouseOver := True;
      Invalidate;
  //end;
end;

procedure TSkinButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  //if not (csLoading in ComponentState) then
  //begin
      FIsMouseOver := False;
      Invalidate;
  //end;
end;


procedure TSkinButton.DrawButton(aRect: TRect; State: UINT);
var
  IsDown, IsDefault, IsDisabled: Boolean;
  OrgRect: TRect;

  function XFactor: Integer;
  begin
      if (csDesigning in ComponentState) then
          result := 0
      else
      begin
          if IsMouseOver then
          begin
              // Hover-Graphics
              if IsDown then result := 3
              else result := 1;
          end else
          begin
              // Nicht Hover
              result := 0;
          end;
          if IsDisabled then
              result := 4;
      end;

      if result >= FNumGlyphsX then
          result := FNumGlyphsX  - 1;

  end;
begin
  OrgRect := aRect;
  IsDown := State and ODS_SELECTED <> 0;
  IsDefault := State and ODS_FOCUS <> 0;
  IsDisabled := State and ODS_DISABLED <> 0;

  if assigned(fNempGlyph) then
  begin
      fCanvas2.CopyRect(aRect, fNempGlyph.Canvas,
          Rect((fNempGlyph.Width Div FNumGlyphsX) * XFactor , (fNempGlyph.Height Div FNumGlyphsY) * FGlyphLine,
               (fNempGlyph.Width Div FNumGlyphsX) * XFactor  + (aRect.Right - aRect.Left), (fNempGlyph.Height Div FNumGlyphsY) * FGlyphLine + (aRect.Bottom - aRect.Top) )
      );
  end;

  if Assigned(FOnDrawButton) then
      FOnDrawButton(Self, OrgRect, TOwnerDrawState(LongRec(State).Lo));

  // Focus-Rahmen zeichnen
  if IsFocused and IsDefault then
  begin
      Case FFocusDrawMode of
        fdm_Windows: begin
            //aRect := OrgRect;
            InflateRect(aRect, -2, -2);
            FCanvas2.Pen.Color := clWindowFrame;
            FCanvas2.Brush.Color := clBtnFace;
            DrawFocusRect(FCanvas2.Handle, aRect);
        end;

        fdm_Triangle: begin
            FCanvas2.Pen.Color := FColor1;
            FCanvas2.Brush.Color := FColor2;
            FCanvas2.Polygon([
                Point(Width Div 2 - 3, 3),
                Point(Width Div 2 + 3, 3),
                Point(Width Div 2 , 6)
                ]);

            FCanvas2.Polygon([
                Point(Width Div 2 - 3, Height - 3),
                Point(Width Div 2 + 3, Height - 3),
                Point(Width Div 2 , Height - 6)
                ]);

            FCanvas2.Polygon([
                Point(3, Height Div 2 - 3),
                Point(3, Height Div 2 + 3),
                Point(6, Height Div 2)
                ]);

            FCanvas2.Polygon([
                Point(Width - 3, Height Div 2 - 3),
                Point(Width - 3, Height Div 2 + 3),
                Point(Width - 6, Height Div 2)
                ]);

        end;

        fdm_Custom: begin
            if Assigned(FOnCustomDrawFocusRect) then
                FOnCustomDrawFocusRect(Self, OrgRect, TOwnerDrawState(LongRec(State).Lo));
        end;
      end;


  end;

end;



procedure Register;
begin
  RegisterComponents('Beispiele', [TSkinButton]);
end;

end.
