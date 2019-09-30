{*******************************************************}
{                                                       }
{                   fspWintaskbar  v 0.8                }
{                                                       }
{                                                       }
{             Copyright (c) 2010 FSPro Labs             }
{              http://delphi.fsprolabs.com              }
{                                                       }
{*******************************************************}
{                                                       }
{ with one additional line by gausi for better preview  }
{                                                       }
{*******************************************************}

unit fspControlsExt;

{$I fspWinTaskbar.inc}

interface
uses Windows, Messages, Classes, Controls;

//Global variables
//Some controls cannot draw themself on a DC via WM_PRINT
//Some of them require WM_PAINT or WM_PAINT+WM_PRINT
var
  fspPatch_Paint : TStringList; //WM_Paint
  fspPatch_PrintCNC : TStringList; //WM_Print (Clinet+NonClient)
  fspPatch_PaintPrintNC : TStringList; //WM_Paint, then WM_Print (NonClinet)
  fspPatch_CanvasRedir  : TStringList; //Change Canvas DC

procedure fspPaintTo(Control : TWinControl; DC : HDC; X, Y : Integer);
function fspControl2DIBPreview(Control : TWinControl; ControlRect : TRect;
                              DestWidth : Integer; DestHeight : Integer;
                              PreserveAspectRatio : Boolean = True;
                              UsePrintWindow : Boolean = False) : HBITMAP;

function fspControl2DIB(Control : TWinControl; UsePrintWindow : Boolean = False) : HBITMAP;


implementation
uses fspSys, fspTaskbarApi, Graphics;

// RichEdit
type

  TCustomControlHack = class(TCustomControl)
  protected
    property Canvas; //make this property and procedure visible here
    procedure PaintWindow(DC : HDC); override;
  end;

  TCharRange = packed record
    cpMin : Integer;
    cpMax : Integer;
  end;

  TFormatRange = packed record
    hdc : HDC;
    hdcTarget : HDC;
    rc : TRect;
    rcPage : TRect;
    chrg : TCharRange;
  end;

const
  EM_FORMATRANGE = WM_USER + 57;

procedure TCustomControlHack.PaintWindow(DC: HDC);
begin
  inherited;
end;

procedure fspPaintTo(Control : TWinControl; DC : HDC; X, Y : Integer);

  procedure DrawBorder(Control : TWinControl; DC : HDC; EdgeFlags, BorderFlags : Integer);
  var
    R: TRect;
  begin
    if BorderFlags > 0 then
    begin
      SetRect(R, 0, 0, Control.Width, Control.Height);
      DrawEdge(DC, R, EdgeFlags, BorderFlags);
      MoveWindowOrg(DC, R.Left, R.Top);
      IntersectClipRect(DC, 0, 0, R.Right - R.Left, R.Bottom - R.Top);
    end;
  end;

  procedure RichEditPaintTo(Control : TWinControl; DC : HDC);
  var
    FR : TFormatRange;
    XRate, YRate : Integer;
  begin
    XRate := GetDeviceCaps(dc, LOGPIXELSX);
    YRate := GetDeviceCaps(dc, LOGPIXELSY);
    if XRate = 0 then XRate := 120;
    if YRate = 0 then YRate := 120;
    ZeroMemory(@FR, SizeOf(FR));
    FR.hdc := DC;
    FR.hdcTarget := DC;
    FR.rc := Control.ClientRect;
    FR.rc.Left := (FR.rc.Left + 4) * 1440 div XRate;
    FR.rc.Right := (FR.rc.Right - 4) * 1440 div XRate;
    FR.rc.Top := (FR.rc.Top + 4) * 1440 div YRate;
    FR.rc.Bottom := (FR.rc.Bottom - 4) * 1440 div YRate;
    FR.chrg.cpMin := 0;
    FR.chrg.cpMax := -1;
    FR.rcPage := FR.rc;
    Control.Perform(EM_FORMATRANGE, 1, DWORD(@FR));
    Control.Perform(EM_FORMATRANGE, 0, 0);
  end;

  procedure CanvasControlPaintTo(Control : TWinControl; DC : HDC);
  //some controls can be painted on a DC only via PaintWindow
  //  (or directly change Canvas.Handle anc call Paint
  begin
    if Control is TCustomControl then
      TCustomControlHack(Control).PaintWindow(DC);
  end;

  procedure ControlPaintTo(Control : TWinControl; DC : HDC; EdgeFlags, BorderFlags : Integer);
  begin
    Control.Perform(WM_ERASEBKGND, DC, 0);

    //On old delphi, minimized form cannot draw itself!!!

    if fspObjectIsClass(Control,'TRichEdit') then begin
    // TRichEdit, doesn't accept WM_PRINT or WM_PAINT messages
    // so we will draw it manually.
      if BorderFlags = -1 then
        Control.Perform(WM_PRINT, DC, PRF_NONCLIENT)
      else
        DrawBorder(Control, DC, EdgeFlags, BorderFlags);
      RichEditPaintTo(Control, DC);
    end
    else if fspObjectIsClass(Control, fspPatch_PrintCNC) then begin
    //TB2000
      Control.Perform(WM_PRINT, DC, PRF_CLIENT or PRF_NONCLIENT);
    end
    else if fspObjectIsClass(Control, fspPatch_PaintPrintNC) then begin
    //grids...
      Control.Perform(WM_PAINT, DC, 0);
      Control.Perform(WM_PRINT, DC, PRF_NONCLIENT);
    end
    else if fspObjectIsClass(Control, fspPatch_Paint) then begin
     // Form, Tasbsheet, Panel...
      DrawBorder(Control, DC, EdgeFlags, BorderFlags);
      Control.Perform(WM_PAINT, DC, 0);
    end
    else if fspObjectIsClass(Control, fspPatch_CanvasRedir) then begin
    //Groupboxes...
      CanvasControlPaintTo(Control, DC);
    end
    else begin //default - send WM_PRINT. If a control has a scroll bar,
      //it can print NONClient area, in other case, draw border manually.
      if BorderFlags = -1 then
        Control.Perform(WM_PRINT, DC, PRF_NONCLIENT or PRF_CLIENT)
      else begin
        DrawBorder(Control, DC, EdgeFlags, BorderFlags);
        Control.Perform(WM_PRINT, DC, PRF_CLIENT)
      end;
    end;
  end;

var
  I, EdgeFlags, BorderFlags, SaveIndex: Integer;
  R1, R2: TRect;
  DeltaX, DeltaY : Integer;
begin
  Control.ControlState := Control.ControlState + [csPaintCopy];
  SaveIndex := SaveDC(DC);
  MoveWindowOrg(DC, X, Y);
  IntersectClipRect(DC, 0, 0, Control.Width, Control.Height);
  BorderFlags := 0;
  EdgeFlags := 0;
  if GetWindowLong(Control.Handle, GWL_STYLE) and (WS_VSCROLL or WS_HSCROLL) <> 0 then
    BorderFlags := -1
  else begin
    if GetWindowLong(Control.Handle, GWL_EXSTYLE) and WS_EX_CLIENTEDGE <> 0 then
    begin
      EdgeFlags := EDGE_SUNKEN;
      BorderFlags := BF_RECT or BF_ADJUST
    end else
    if GetWindowLong(Control.Handle, GWL_STYLE) and WS_BORDER <> 0 then
    begin
      EdgeFlags := BDR_OUTER;
      BorderFlags := BF_RECT or BF_ADJUST or BF_MONO;
    end;
  end;

  ControlPaintTo(Control, DC, EdgeFlags, BorderFlags);

  if GetWindowLong(Control.Handle, GWL_STYLE) and WS_CAPTION = 0 then begin
    GetWindowRect(Control.Handle, R1);
    GetClientRect(Control.Handle, R2);
    R2.TopLeft := Control.ClientToScreen(R2.TopLeft);
    R2.BottomRight := Control.ClientToScreen(R2.BottomRight);
    DeltaX := R2.Left - R1.left;
    DeltaY := R2.Top - R1.Top;
  end
  else begin
   DeltaX := 0;
   DeltaY := 0;
  end;

  for I := 0 to Control.ControlCount - 1 do
    if Control.Controls[i] is TWinControl then
      with TWinControl(Control.Controls[I]) do
        if Visible then fspPaintTo(TWinControl(Control.Controls[I]), DC, Left + DeltaX, Top + DeltaY);
  RestoreDC(DC, SaveIndex);
  Control.ControlState := Control.ControlState - [csPaintCopy];
end;

function fspControl2DIBPreview(Control : TWinControl; ControlRect : TRect;
                            DestWidth : Integer; DestHeight : Integer;
                            PreserveAspectRatio : Boolean = True;
                            UsePrintWindow : Boolean = False) : HBITMAP;
var
  sdc   : HDC;
  sbmi  : BITMAPINFO;
  sBits : PInteger;
  sBitmap : HBITMAP;
  ddc   : HDC;
  dbmi  : BITMAPINFO;
  dBits : PInteger;
  i, j  : Integer;
  SAspect  : Double;
  DAspect  : Double;
begin
  Result := 0;
  If (ControlRect.Left = ControlRect.Right) or (ControlRect.Top = ControlRect.Bottom) or
     (DestWidth = 0) or (DestHeight = 0) then
     Exit;
  sdc := CreateCompatibleDC(0);
  ddc := CreateCompatibleDC(0);
  if (sdc <> 0) and (ddc <> 0) then begin
    ZeroMemory(@sbmi.bmiHeader, sizeof(BITMAPINFOHEADER));
    sbmi.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
    sbmi.bmiHeader.biWidth := Control.ClientWidth;
    sbmi.bmiHeader.biHeight := -Control.ClientHeight;
    sbmi.bmiHeader.biPlanes := 1;
    sbmi.bmiHeader.biBitCount := 32;

    sBitmap := CreateDIBSection(sdc, sbmi, DIB_RGB_COLORS, Pointer(sBits), 0, 0);

    if PreserveAspectRatio then begin
      SAspect := (ControlRect.Right - ControlRect.Left) /  (ControlRect.Bottom - ControlRect.Top);
      DAspect := DestWidth / DestHeight;
      if SAspect > DAspect then // Source rectangle is wider than the target, correct target height
        DestHeight := Round(DestHeight * DAspect / SAspect)
      else // Source rectangle is higher than the target, correct target witdh
        DestWidth := Round(DestWidth * SAspect / DAspect);
    end;

    ZeroMemory(@dbmi.bmiHeader, sizeof(BITMAPINFOHEADER));
    dbmi.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
    dbmi.bmiHeader.biWidth := DestWidth;
    dbmi.bmiHeader.biHeight := -DestHeight;
    dbmi.bmiHeader.biPlanes := 1;
    dbmi.bmiHeader.biBitCount := 32;

    Result := CreateDIBSection(ddc, dbmi, DIB_RGB_COLORS, Pointer(dBits), 0, 0);

    SelectObject(sdc, sBitmap);
    SelectObject(ddc, Result);

    if UsePrintWindow and Assigned(fspPrintWindow) then
      //this works better, but only if a Windows is visible
      fspPrintWindow(Control.Handle, sdc, 1)
    else
      fspPaintTo(Control, sdc, 0, 0);

    // Added by Gausi - gives better results in the preview. :D
    SetStretchBltMode(ddc,HALFTONE);

    StretchBlt(ddc, 0, 0, DestWidth, DestHeight,
               sdc, ControlRect.Left, ControlRect.Top,
               ControlRect.Right - ControlRect.Left, ControlRect.Bottom - ControlRect.Top,
               SRCCOPY);


    for i := 0 to DestHeight - 1 do
      for j := 0 to DestWidth - 1 do begin
        //Bits - is a raw RGBA array
        // we should reset transparency byte (and optionally can change other colors)
        dBits^ := dBits^ and $00ffffff;
        Inc(dBits);
      end;

    DeleteDC(sdc);
    DeleteDC(ddc);
    DeleteObject(sBitmap);
  end;
end;



function fspControl2DIB(Control : TWinControl; UsePrintWindow : Boolean = False) : HBITMAP;
var
  dc   : HDC;
  bmi  : BITMAPINFO;
  Bits : PInteger;
  i, j : Integer;
begin
  Result := 0;
  dc := CreateCompatibleDC(0);
  if (dc <> 0) then begin
    ZeroMemory(@bmi.bmiHeader, sizeof(BITMAPINFOHEADER));
    bmi.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth := Control.ClientWidth;
    bmi.bmiHeader.biHeight := -Control.ClientHeight;
    bmi.bmiHeader.biPlanes := 1;
    bmi.bmiHeader.biBitCount := 32;

    Result := CreateDIBSection(dc, bmi, DIB_RGB_COLORS, Pointer(Bits), 0, 0);

    SelectObject(dc, Result);

    if UsePrintWindow and Assigned(fspPrintWindow) then
      //this works better, but only if a Windows is visible
      fspPrintWindow(Control.Handle, dc, 1)
    else
      fspPaintTo(Control, dc, 0, 0);

    for i := 0 to Control.ClientWidth - 1 do
      for j := 0 to Control.ClientHeight - 1 do begin
      //Bits - is a raw RGBA array
      // we should reset transparency byte (and optionally can change other colors)
        Bits^ := Bits^ and $00ffffff;
        Inc(Bits);
      end;
    DeleteDC(dc);
  end;
end;



{ TCustomControlHack }


initialization
  fspPatch_Paint := TStringList.Create;
  fspPatch_PrintCNC := TStringList.Create;
  fspPatch_PaintPrintNC := TStringList.Create;
  fspPatch_CanvasRedir := TStringList.Create;

  fspPatch_Paint.Add('TCustomForm');
  fspPatch_Paint.Add('TCustomPanel');
  fspPatch_Paint.Add('TTabSheet');
  //some known third-party components may follow here
  //e.g. fspPatch_Paint.Add('TAdvOfficePager');
  fspPatch_Paint.Sorted := True;

  //I know about a problem with TB2000 dockable window - it must be drawn
  //with WM_PRINT (client+nonclient)
  fspPatch_PrintCNC.Add('TTBCustomDockableWindow');
  //  fspPatch_PrintCNC.Add('....');
  fspPatch_Paint.Sorted := True;

  //Grid controls look better when WM_Print + WM_Print(NC).
  fspPatch_PaintPrintNC.Add('TCustomGrid');
  fspPatch_PaintPrintNC.Add('TCustomGridEh'); //the same for EhLib grid
  //  fspPatch_PaintPrintNC.Add('....');
  fspPatch_PaintPrintNC.Sorted := True;

  //Some controld don't understand anything but setting the Canvas DC
  fspPatch_CanvasRedir.Add('TCustomForm');
  fspPatch_CanvasRedir.Add('TCustomGroupBox');
  //fspPatch_CanvasRedir.Add('....');
  fspPatch_CanvasRedir.Sorted := True;

finalization
  fspPatch_Paint.Free;
  fspPatch_PrintCNC.Free;
  fspPatch_PaintPrintNC.Free;
  fspPatch_CanvasRedir.Free;

end.
