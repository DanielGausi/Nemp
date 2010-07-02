(* Title: unitFlyingCow *)
{****************************************************************************}
{ This file is a part of Flying Cow, a clone of Cover Flow for Windows       }
{ Copyright (C) 2007, Matías Andrés Moreno http://www.matiasmoreno.com.ar/   }
{                                                                            }
{ Projectpage -  http://sourceforge.net/projects/flyingcow/                  }
{                                                                            }
{ Modified: 02-June-2008 by AxelLang  (axellang@gmx.de)                      }
{                                                                            }
{ - Added support for Delphi 2007                                            }
{                                                                            }
{ Modified: July-2009 by Daniel Gaussmann (mail@gausi.de)                    }
{                                                                            }
{ - Added Semaphores for lower CPU-usage                                     }
{ - Added Methods for changing rendering context (switching panels for Nemp) }
{ - Added method "SelectItemAt" to browse the flow by clicking an item       }
{ - Deleted some stuff like Buttons and Captions                             }
{   (this won't work well with Unicode)                                      }
{                                                                            }
{                                                                            }
{****************************************************************************}
{                                                                            }
{ This program is free software: you can redistribute it and/or modify       }
{ it under the terms of the GNU General Public License as published by       }
{ the Free Software Foundation, version 3 of the License.                    }
{ This  program  is  distributed in the hope  that it will  be  useful,      }
{ but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of       }
{ MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the       }
{ GNU General Public License for more details.                               }
{ You should have received  a copy of the  GNU  General Public License       }
{ along with this program. If not, see <http://www.gnu.org/licenses/>.       }
{                                                                            }
{****************************************************************************}

unit unitFlyingCow;

interface

uses Windows, Messages, SysUtils, Graphics, Classes, dglOpenGL;// , unitGLText;

{.$R FlyingCowIcons.res}

var

  OPENGL_InitOK: Boolean;

const
  WM_FLYINGCOW = WM_USER + $1000;

  WM_FC_NEEDPREVIEW = WM_FLYINGCOW + 0;
  WM_FC_SELECT = WM_FLYINGCOW + 1;


 // WM_FC_NEEDMORE = WM_FLYINGCOW + 2;
  WM_FLYINGCOWTEST = WM_FLYINGCOW + 3;

type
  TWMFCMessage = packed record
    Msg : Cardinal;
    index : Integer;
    Unused : Longint;
    Result : Longint;
  end;

  TWMFCNeedPreview = TWMFCMessage;

  TWMFCSelect = TWMFCMessage;

  TFlyingCow = class;

  TRenderThread = class(TThread)
  private
    fInstance : TFlyingCow;
    fSemaphore: THandle;
    fDC : HDC;
    fRC : TRect;

    glrc : HGLRC;

    fNewHandleNeeded: Boolean;
    fNewHandle: Hwnd;

    fXClicked: Integer;
    fYClicked: Integer;
    fWindow : HWND;
    fDoRender : Boolean;
    fAllowItemAccess: Boolean;
    fFrameDone : Boolean;
    fTimer : Cardinal;
    fItem : array of record
      x,  r,  z  : Single;
      nx, nr, nz : Single;
      texture : record
        handle : Integer;
        w, h : Single;
        su, sv : Single;
        tu, tv : Single;
        age : Integer;
      end;
    end;
    fCurrentItem : Integer;
    fSelectedItem : Integer;
    fQueryDeleteTexture : Integer;
    fQueryUpdateTexture : Integer;
    fQueryUpdateTexture_pixels : PByteArray;
    fQueryUpdateTexture_width : Integer;
    fQueryUpdateTexture_height : Integer;
    fPendingPreview : Boolean;
    fEventsWindow : HWND;
    fCaptionCS : Integer;
    fr: single;
    fg: single;
    fb: single;

    // New Caption-Stuff
    //fTextBitmap: tBitmap;
    //fCaptionTexture: Integer;
    //fTextureChanged: Boolean;
    //procedure DrawCaption;

    procedure DrawScene;

    function WinPosTo3DPos(X, Y: Integer): TGLVectord3;

    procedure InitRendering;
    procedure ReInitHandles;

  protected
    procedure Execute; override;
  public
    constructor Create (instance : TFlyingCow; window, events_window : HWND);
    procedure PauseRender;
    procedure ResumeRender;
    procedure StepItems;
    procedure UpdateItems;
    procedure DeleteTexture (index : Integer);
    procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);
    procedure RenderPass (check_missings : Boolean; rc : TRect);
    ////procedure SetCaption (caption, subcaption : String);
  end;

  TFlyingCowItem = class
  public
    Name, Kind, Tag : String;
    constructor Create (name, kind, tag : String);
  end;

  TFlyingCowOnPreview = procedure (index : Integer) of object;

  TFlyingCow = class
  private
    fThread : TRenderThread;
    fItem : TList;
    fBeginUpdate : Boolean;
    fEventsWindow : HWND;
    function getItem (index : Integer) : TFlyingCowItem;
    function getCount : Integer;
    function getCurrentItem: Integer;
    procedure setCurrentItem(index: Integer);
  public
    constructor Create (window, events_window : HWND);
    procedure Clear;
    procedure Cleartextures;
    property Item [index : Integer] : TFlyingCowItem read getItem;
    property Count : Integer read getCount;
    procedure Add (item : TFlyingCowItem);
    procedure Insert (index : Integer; item : TFlyingCowItem);
    procedure Delete (index : Integer);
    procedure DoSomeDrawing(value: Integer);
    property CurrentItem : Integer read getCurrentItem write setCurrentItem;
    procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);
//    function NeedsPreview (var index : Integer) : Boolean;
    procedure SelectItemAt(X,Y: Integer);
    procedure BeginUpdate;
    procedure EndUpdate;

    procedure SetNewHandle(aWnd: HWND);
    procedure SetColor(r,g,b: Integer);

    destructor Destroy; override;


  end;

  function FlyingCowItem (name, kind, tag : String) : TFlyingCowItem;

implementation

{ TFlyingCow }


constructor TFlyingCow.Create (window, events_window : HWND);
begin
  fItem := TList.Create;
  fThread := TRenderThread.Create (self, window, events_window);
  fEventsWindow := events_window;
  fBeginUpdate := False;
end;


procedure TFlyingCow.Add(item: TFlyingCowItem);
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;
  fItem.Add (item);
  SetLength (fThread.fItem, Count);
  fThread.UpdateItems;
  fThread.fItem[Count-1].x := fThread.fItem[Count-1].nx;
  fThread.fItem[Count-1].r := fThread.fItem[Count-1].nr;
  fThread.fItem[Count-1].z := fThread.fItem[Count-1].nz;
  fThread.fItem[Count-1].texture.handle := 0;
  If Not fBeginUpdate Then
      fThread.ResumeRender;
end;

procedure TFlyingCow.BeginUpdate;
begin
  fThread.fAllowItemAccess := False;
  fThread.PauseRender;
  fBeginUpdate := True;
end;

procedure TFlyingCow.EndUpdate;
begin
  fBeginUpdate := False;
  fThread.fAllowItemAccess := True;
  fThread.ResumeRender;
end;

procedure TFlyingCow.Clear;
var
  i : Integer;
begin

  If Not fBeginUpdate Then
  begin
    BeginUpdate;
    For i := Count-1 DownTo 0 do
      Delete (i);
    EndUpdate;
  end
  else
  begin
    For i := Count-1 DownTo 0 do
      Delete (i);
  end;
end;

procedure TFlyingCow.Cleartextures;
var i: Integer;
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;

  for i := 0 to self.Count - 1 do
      If fThread.fItem[i].texture.handle <> 0 Then
          fThread.DeleteTexture (i);

  If Not fBeginUpdate Then
    fThread.ResumeRender;
end;



procedure TFlyingCow.Delete(index: Integer);
var
  i : Integer;
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;
  Item[index].Free;
  fItem.Delete (index);
  If fThread.fItem[index].texture.handle <> 0 Then
    fThread.DeleteTexture (index);
  For i := index To Count-1 do
    fThread.fItem[i] := fThread.fItem[i+1];
  fThread.UpdateItems;
  SetLength (fThread.fItem, Count);
  If Not fBeginUpdate Then
    fThread.ResumeRender;
end;

destructor TFlyingCow.Destroy;
begin
    BeginUpdate;
    Clear;
    fThread.Terminate;
    fThread.WaitFor;
    fThread.Free;
    fItem.Free;
    fThread := Nil;
    inherited destroy;
end;

procedure TFlyingCow.DoSomeDrawing(value: Integer);
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;
  ReleaseSemaphore(fThread.fSemaphore, value, Nil);
  If Not fBeginUpdate Then
    fThread.ResumeRender;
end;



function TFlyingCow.getCount: Integer;
begin
  Result := fItem.Count;
end;

function TFlyingCow.getCurrentItem: Integer;
begin
  Result := fThread.fCurrentItem;
end;

function TFlyingCow.getItem(index: Integer): TFlyingCowItem;
begin
  Result := fItem[index];
end;


procedure TFlyingCow.Insert(index: Integer; item: TFlyingCowItem);
var
  i : Integer;
begin
  fThread.PauseRender;
  fItem.Insert (index, item);
  SetLength (fThread.fItem, fItem.Count);
  For i := fItem.Count-1 DownTo index+1 do
    fThread.fItem[i] := fThread.fItem[i-1];
  fThread.UpdateItems;
  fThread.fItem[index].x := fThread.fItem[index].nx;
  fThread.fItem[index].r := fThread.fItem[index].nr;
  fThread.fItem[index].z := fThread.fItem[index].nz;
  fThread.ResumeRender;
end;

procedure TFlyingCow.SelectItemAt(X, Y: Integer);
begin
  fThread.PauseRender;
  fThread.fXClicked := X;
  fThread.fYClicked := Y;
  // Setting the correct item will be done before the next rendering-loop
  fThread.ResumeRender;
end;

procedure TFlyingCow.setCurrentItem (index: Integer);
begin
  fThread.PauseRender;
  fThread.fSelectedItem := -1;
  fThread.fCurrentItem := index;
  fThread.UpdateItems;
  //if (index >= 0) and (index < fItem.Count ) then
  // try
  //fThread.SetCaption (Item[index].Name, Item[index].Kind);
  //except end;
  fThread.ResumeRender;
end;

procedure TFlyingCow.SetNewHandle(aWnd: HWND);
var i: Integer;
begin
    fThread.PauseRender;

    fThread.fNewHandle := aWnd;
    fThread.fNewHandleNeeded := True;

    // Clear Textures
    for i := 0 to self.Count - 1 do
      If fThread.fItem[i].texture.handle <> 0 Then
          fThread.DeleteTexture (i);

    fThread.ResumeRender;
    DoSomeDrawing(20);
end;

procedure TFlyingCow.SetColor(r,g,b: Integer);
var i: Integer;
begin
    fThread.PauseRender;

    // Clear Textures
    for i := 0 to self.Count - 1 do
      If fThread.fItem[i].texture.handle <> 0 Then
          fThread.DeleteTexture (i);

    fThread.fr := r / 255;
    fThread.fg := g / 255;
    fThread.fb := b / 255;

    fThread.fNewHandleNeeded := True;

    fThread.ResumeRender;
    DoSomeDrawing(20);
end;
procedure TFlyingCow.SetPreview(index, width, height: Integer;
  pixels: PByteArray);
begin
  fThread.SetPreview (index, width, height, pixels);
end;



{ TFlyingCowItem }

constructor TFlyingCowItem.Create(name, kind, tag: String);
begin
  self.Name := name;
  self.Kind := kind;
  self.Tag  := tag;
end;

function FlyingCowItem (name, kind, tag : String) : TFlyingCowItem;
begin
  Result := TFlyingCowItem.Create (name, kind, tag);
end;

{ TRenderThread }

constructor TRenderThread.Create(instance: TFlyingCow; window, events_window : HWND);
begin
  inherited Create (True);
  fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
  FreeOnTerminate := False;
  fInstance := instance;
  fWindow := window;
  fDoRender := True;
  fAllowItemAccess := True;
  fFrameDone := False;
  SetLength (fItem, 0);
  fCurrentItem := 0;
  fSelectedItem := -1;
  fQueryDeleteTexture := -1;
  fQueryUpdateTexture := -1;
  fPendingPreview := False;
  fEventsWindow := events_window;
  fCaptionCS := 0;
  fXClicked := -1;
  fYClicked := -1;
  fr := 0.0;
  fg := 0.0;
  fb := 0.0;
  Resume;
end;

procedure TRenderThread.DeleteTexture (index : LongInt);
begin

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryDeleteTexture >= 0 do

	  {$IF CompilerVersion > 15.0}
      InterlockedCompareExchange(LongInt(fQueryDeleteTexture), index, -1);
    {$ELSE}
      InterlockedCompareExchange (Pointer(fQueryDeleteTexture), Pointer(index), Pointer(-1));
    {$IFEND}

  fQueryDeleteTexture := index;

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryDeleteTexture = index do
    Sleep (1);
end;



function Pow2 (x : Integer) : Integer;
begin
  Result := 1;
  While Result < x do
    Result := Result * 2;
end;

function Align4 (x : Integer) : Integer;
begin
  Result := (x + 3) div 4 * 4;
end;

procedure previewCallback (hwnd : HWND; uMsg : UINT; var fPendingPreview : Boolean; lResult : LRESULT); stdcall;
begin
  fPendingPreview := False;
end;

procedure TRenderThread.Execute;
var
  delta_t : Cardinal;

  i : Integer;
  temp : PByteArray;
  pw, ph : Integer;
  px, py : Integer;
  ps, pd : PByteArray;
  //projMatrix : TGLMatrixd4;
  //viewport : TGLVectori4;
  texture_count : Integer;
  oldest_index : Integer;
  //vx_nearest : Single;
  //vx_index : Integer;
  //msg : TMSG;
  //bmp : TBitmap;
  //////////////////font : TGLFont;
  MoreNeeded: Boolean;
  NewSelectedItem: Integer;

  vec: TGLVectord3;
  vec0: TGLDouble;
begin
  // Iniciar OpenGL
  InitRendering;

  // Cargar fuente de letras
  //////////////////gltLoadFont(font);
  // Oki doki, a laburar se ha dicho
  fTimer := GetTickCount;
  While Not Terminated do
  begin
     if (WaitforSingleObject(fSemaphore, 1000) = WAIT_OBJECT_0) then
    //  WaitforSingleObject(fSemaphore, 2000) ;
    //if True then
      if not Terminated then
      begin
                if fNewHandleNeeded then
                begin
                    // The Panel-Handle has Changed.
                    ReInitHandles;
                    fNewHandleNeeded := False;
                end;

                MoreNeeded := False;
                // Petición de borrar una textura
                If fQueryDeleteTexture >= 0 Then
                begin
                    glDeleteTextures (1, @fItem[fQueryDeleteTexture].texture.handle);
                    fItem[fQueryDeleteTexture].texture.handle := 0;
                    fQueryDeleteTexture := -1;
                end;
                // Petición de actualizar una textura
                If fQueryUpdateTexture >= 0 Then
                begin
                  If fItem[fQueryUpdateTexture].texture.handle = 0 Then
                      glGenTextures (1, @fItem[fQueryUpdateTexture].texture.handle);
                  glBindTexture (GL_TEXTURE_2D, fItem[fQueryUpdateTexture].texture.handle);
                  If fQueryUpdateTexture_width > fQueryUpdateTexture_height Then
                  begin
                      fItem[fQueryUpdateTexture].texture.w := 1.0;
                      fItem[fQueryUpdateTexture].texture.h := fQueryUpdateTexture_height / fQueryUpdateTexture_width;
                  end
                  else
                  begin
                      fItem[fQueryUpdateTexture].texture.w := fQueryUpdateTexture_width / fQueryUpdateTexture_height;
                      fItem[fQueryUpdateTexture].texture.h := 1.0;
                  end;
                  pw := Pow2(fQueryUpdateTexture_width);
                  ph := Pow2(fQueryUpdateTexture_height);
                  fItem[fQueryupdateTexture].texture.su :=  0.5/pw;
                  fItem[fQueryupdateTexture].texture.sv := (1.0 - fQueryUpdateTexture_height/ph) + 0.5/ph;
                  fItem[fQueryupdateTexture].texture.tu := fQueryUpdateTexture_width/pw - 0.5/pw;
                  fItem[fQueryupdateTexture].texture.tv := 1.0 - 0.5/ph;
                  fItem[fQueryupdateTexture].texture.age := 0;
                  GetMem (temp, pw*ph*4);
                  ps := @fQueryUpdateTexture_pixels[(fQueryUpdateTexture_height-1)*Align4(fQueryUpdateTexture_width*3)];
                  pd := @temp[pw*ph*4-pw*4];
                  FillChar (temp^, pw*ph*4, $FF);
                  For py := 0 To fQueryUpdateTexture_height-1 do
                  begin
                      For px := 0 To fQueryUpdateTexture_width-1 do
                      begin
                          pd[px*4+0] := ps[px*3+2];
                          pd[px*4+1] := ps[px*3+1];
                          pd[px*4+2] := ps[px*3+0];
                      end;
                      ps := @ps[-Align4(fQueryUpdateTexture_width*3)];
                      pd := @pd[-pw*4];
                  end;
                  glTexImage2D (GL_TEXTURE_2D, 0, 4, pw, ph, 0, GL_RGBA, GL_UNSIGNED_BYTE, temp);
                  FreeMem (temp);
                  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
                  fQueryUpdateTexture := -1;
                  MoreNeeded := True;
                  //ReleaseSemaphore(fSemaphore, 1, Nil);
                end;


////////////////////////////////77
                // Ir quitando texturas, cuando hay demasiadas
                if fAllowItemAccess then
                begin
                    texture_count := 0;
                    oldest_index := -1;
                    For i := 0 To High(fItem) do
                    begin
                        If fItem[i].texture.handle <> 0 Then
                        begin
                            inc (texture_count);
                            If oldest_index < 0 Then
                                oldest_index := i
                            else
                                If fItem[oldest_index].texture.age < fItem[i].texture.age Then
                                    oldest_index := i;
                        end;
                    end;
                    If texture_count > 50 Then
                    begin
                        glDeleteTextures (1, @fItem[oldest_index].texture.handle);
                        fItem[oldest_index].texture.handle := 0;
                    end;
                end;
//////////////////////////////////////////////77

                If fDoRender and fAllowItemAccess Then
                begin
                    // Animar las imágenes
                    delta_t := GetTickCount - fTimer;
                    While delta_t >= 10 do
                    begin
                      inc (fTimer);
                      dec (delta_t);
                      StepItems;
                    end;
                    // Mostrar las imágenes
                    //glClear (GL_DEPTH_BUFFER_BIT);
                    //glClear (GL_COLOR_BUFFER_BIT);
                    glMatrixMode (GL_PROJECTION);
                    glLoadIdentity;
                    GetClientRect (fWindow, fRC);
                    glViewport (0, 0, fRC.Right-fRC.Left, fRC.Bottom-fRC.Top);
                    gluPerspective (45.0, (fRC.Right-fRC.Left) / (fRC.Bottom-fRC.Top), 0.1, 100.0);

                    if self.fXClicked <> -1  then
                    begin
                        vec := WinPosTo3DPos(fXClicked, fYClicked);
                        vec0 := vec[0]*1000;

                        case abs(round(vec0)) of
                            0..33 : NewSelectedItem := 0;
                            34..52 : NewSelectedItem := 1;
                            53..65 : NewSelectedItem := 2;
                            66..77 : NewSelectedItem := 3;
                            78..90 : NewSelectedItem := 4;
                            91..103: NewSelectedItem := 5;
                            104..116:NewSelectedItem := 6;
                            117..128:NewSelectedItem := 7;
                        else
                            NewSelectedItem := 8;
                        end;

                        if vec0 > 0 then
                            fCurrentItem := fCurrentItem + NewSelectedItem
                        else
                            fCurrentItem := fCurrentItem - NewSelectedItem;

                        if fCurrentItem < 0 then
                            fCurrentItem := 0;
                        if fCurrentItem > High(fItem)  then
                            fCurrentItem := High(fItem);

                        PostMessage (fEventsWindow, WM_FC_SELECT, fCurrentItem, 0);

                        fSelectedItem := -1;
                        UpdateItems;
                        {case round(vec[1]) of
                          0:;
                        end; }
                        fXClicked := -1;
                        fYClicked := -1;
                        //DrawScene;
                    end else
                    begin
                        DrawScene;
                    end;

                end
                else
                begin
                    delta_t := GetTickCount - fTimer;
                    While delta_t >= 10 do
                    begin
                      inc (fTimer);
                      dec (delta_t);
                    end;
                end;

                // Chequear si se selecciona un item nuevo
                If (fSelectedItem <> fCurrentItem) And
                   (fCurrentItem >= 0) And
                   (fCurrentItem <= High(fItem)) And
                   (Abs(fItem[fCurrentItem].x) < 0.001) AND
                   (not MoreNeeded) Then
                begin
 //////////////////XXXX
                    PostMessage (fEventsWindow, WM_FC_SELECT, fCurrentItem, 0);
                    fSelectedItem := fCurrentItem;
                    fDoRender := False;
                    ///////////////////////////////sleep(1);
              //      while (WaitforSingleObject(fSemaphore, 1) = WAIT_OBJECT_0) do
              //      ;    ///sleep(1);
                end else
                begin
                    // We need more to do. Release Semaphore, so this
                    // will be done again.
                   ///////////////////////////////sleep(1);
                   if (fSelectedItem <> fCurrentItem) or (MoreNeeded) then
                        ReleaseSemaphore(fSemaphore, 1, Nil);
                end;

                fFrameDone := True;
                //Sleep (1);
      end else
          ; //ReleaseSemaphore(fSemaphore, 1, Nil); // Backup??
  end;
  //////////////////gltUnloadFont (font);
  // Finalizar OpenGL
  wglMakeCurrent (0, 0);
  wglDeleteContext (glrc);
  ReleaseDC (fWindow, fDC);
end;


      (*
procedure TRenderThread.DrawCaption;
begin

end;    *)

procedure TRenderThread.DrawScene;
begin
    glMatrixMode (GL_MODELVIEW);

    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

    glLoadIdentity;
    glTranslatef (0.0, -0.1, -3.0);

    glInitNames;
    glPushName(0);

    // Filling
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  //  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_DST_ALPHA);

    glEnable (GL_POLYGON_OFFSET_FILL);
    glPolygonOffset (1.0, 1.0);
    RenderPass (True, fRC);
    glDisable (GL_POLYGON_OFFSET_FILL);

    // Antialiasing
    glHint (GL_LINE_SMOOTH_HINT, GL_NICEST);
    glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_DST_ALPHA);


    glDepthMask (False);
    glDepthFunc (GL_LEQUAL);
    RenderPass (False, fRC);
    glDepthMask (True);
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);

 (*
    {$IF CompilerVersion > 15.0}
        If InterlockedCompareExchange (LongInt(fCaptionCS), 1, 0) = 0 Then
    {$ELSE}
        If InterlockedCompareExchange (Pointer(fCaptionCS), Pointer(1), Pointer(0)) = Pointer(0) Then
    {$IFEND}

    begin

        if fTextureChanged then
        begin
            // Textur neu zeichnen
            fTextBitmap := TBitmap.Create;
            fTextBitmap.Width := 400;
            fTextBitmap.Height := 100;

            fTextBitmap.Canvas.Font.Size := 16;
            fTextBitmap.Canvas.Font.Color := clWhite;
            fTextBitmap.Canvas.Brush.Color := clBlack;
            fTextBitmap.Canvas.FillRect(Rect(0,0, fTextBitmap.Width, fTextBitmap.Height));

            //fTextBitmap.Canvas.Brush.Color := #101010;
            fTextBitmap.Canvas.TextOut(10, 10, fCaption);
            fTextBitmap.Canvas.TextOut(10, 70, fSubCaption);

            glGenTextures (1, @fCaptionTexture);
  glBindTexture (GL_TEXTURE_2D, fCaptionTexture);
  glTexImage2D (GL_TEXTURE_2D, 0, 4, fTextBitmap.Width, fTextBitmap.Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, fTextBitmap.Scanline[fTextBitmap.height-1]);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
           fTextBitmap.Free;
           fTextureChanged := False;
        end;

        glEnable (GL_TEXTURE_2D);
        glEnable (GL_BLEND);
        glDisable (GL_DEPTH_TEST);
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glBlendFunc (GL_One, GL_ONE_MINUS_SRC_ALPHA);

        glBindTexture (GL_TEXTURE_2D, fCaptionTexture);
        glColor3f (1.0, 1.0, 1.0);
        glBegin (GL_QUADS);
        glTexCoord2f (0.0, 1.0);
        glVertex3f (-1.0, -0.75+1+ 0.25, 0.0);

        glTexCoord2f (1.0, 1.0);
        glVertex3f ( 1.0, -0.75+1+ 0.25, 0.0);

        glTexCoord2f (1.0, 0.0);
        glVertex3f ( 1.0, -0.75+1- 0.25, 0.0);

        glTexCoord2f (0.0, 0.0);
        glVertex3f (-1.0, -0.75+1- 0.25, 0.0);

        glEnd;
        glDisable (GL_BLEND);
        glEnable (GL_DEPTH_TEST);



        //gltDrawText (font, fCaption, (rc.Right+rc.Left)div 2-gltTextWidth(font,fCaption)div 2, rc.Bottom-50);
        //gltDrawText (font, fSubCaption, (rc.Right+rc.Left)div 2-gltTextWidth(font,fSubCaption)div 2, rc.Bottom-30);
        fCaptionCS := 0;
    end;
    *)
    SwapBuffers (fDC);
end;

function TRenderThread.WinPosTo3DPos(X, Y: Integer): TGLVectord3;
var
  viewport  : TGLVectori4;
  modelview : TGLMatrixd4;
  projection: TGLMatrixd4;
  //Z         : TGLFloat;
  Y_new     : Integer;
begin
  glGetDoublev(GL_MODELVIEW_MATRIX, @modelview ); //Aktuelle Modelview Matrix in einer Variable ablegen
  glGetDoublev(GL_PROJECTION_MATRIX, @projection ); //Aktuelle Projection[s] Matrix in einer Variable ablegen
  glGetIntegerv(GL_VIEWPORT, @viewport ); // Aktuellen Viewport in einer Variable ablegen
  Y_new := viewport[3] - y; // In OpenGL steigt Y von unten (0) nach oben

  // Auslesen des Tiefenpuffers an der Position (X/Y_new)
  ///glReadPixels(X, Y_new, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, @Z );

  //z := 0;

  // Errechnen des Punktes, welcher mit den beiden Matrizen multipliziert (X/Y_new/Z) ergibt:
  gluUnProject(X, Y_new, 0.0, modelview, projection, viewport, @Result[0], @Result[1], @Result[2]);

  if not terminated then

   PostMessage (fEventsWindow, WM_FLYINGCOWTEST, WParam(Round(1000 * Result[0])), LParam(Round(1000*Result[1])));

end;

{
    --------------------------------------------------------
    InitRendering
    - Set fDC, GL-Context,...
    --------------------------------------------------------
}
procedure TRenderThread.InitRendering;
var pfd : TPixelFormatDescriptor;
begin
    fDC := GetDC (fWindow);
    FillChar (pfd, sizeof(pfd), 0);
    pfd.nSize := sizeof(pfd);
    pfd.nVersion := 1;
    pfd.dwFlags := PFD_SUPPORT_OPENGL + PFD_DOUBLEBUFFER + PFD_DRAW_TO_WINDOW;
    pfd.dwLayerMask := PFD_MAIN_PLANE;
    pfd.iPixelType := PFD_TYPE_RGBA;
    pfd.cColorBits := 32;
    pfd.cDepthBits := 16;
    pfd.cAccumBits := 0;
    pfd.cStencilBits := 8;
    SetPixelFormat (fDC, ChoosePixelFormat (fDC, @pfd), @pfd);
    glrc := wglCreateContext (fDC);
    wglMakeCurrent (fDC, glrc);
    glClearColor(fr, fg, fb, 0.0);
    glLineWidth (1.0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_LINE_SMOOTH);
end;

{
    --------------------------------------------------------
    ReInitHandles
    - In Nemp, we need to switch the OpenGL-Panel from on to another window.
      As the handles will change, we need to change them in the render-thread
      as well.
    This method is called from the Execute-Method.
    --------------------------------------------------------
}
procedure TRenderThread.ReInitHandles;
begin
    // clear old stuff
    wglMakeCurrent (0, 0);
    wglDeleteContext (glrc);
    ReleaseDC (fWindow, fDC);
    fWindow := fNewHandle;
    // Re-Init the fDC and stuff.
    InitRendering;
end;

procedure TRenderThread.RenderPass(check_missings: Boolean; rc : TRect);
var
  modelMatrix, projMatrix : TGLMatrixd4;
  viewport : TGLVectori4;
  vx_nearest : Single;
  vx_index : Integer;
  i : Integer;
  vx, vy, vz : GLDouble;
  w, h : Single;
  msg : TMSG;
begin
  glGetDoublev (GL_MODELVIEW_MATRIX, @modelMatrix);
  glGetDoublev (GL_PROJECTION_MATRIX, @projMatrix);
  glGetIntegerv (GL_VIEWPORT, @viewport);
  vx_index := -1;
  vx_nearest := 0;
  For i := 0 To High(fItem) do
  begin
    // Determinar si el item cae dentro de la pantalla
    If fItem[i].x < -2.0 Then
        gluProject (fItem[i].x+Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else If fItem[i].x > 2.0 Then
        gluProject (fItem[i].x-Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else
        vx := (rc.Right - rc.Left) / 2.0;
    //If (vx >= (rc.Right-rc.Left) div 8) And (vx < (rc.Right-rc.Left)*7 div 8) Then
    If (vx >= -(rc.Right-rc.Left) div 2) And (vx < (rc.Right-rc.Left)*3 div 2) Then
    begin

      If fItem[i].texture.handle = 0 Then
      begin
        If check_missings Then
        begin
          // El item no tiene preview
          If fItem[i].nx < -2.0 Then
              gluProject (fItem[i].nx+Cos(fItem[i].nr), 0.0, -Abs(Sin(fItem[i].nr))-Abs(2.0*Sin(fItem[i].nr)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
          else If fItem[i].nx > 2.0 Then
              gluProject (fItem[i].nx-Cos(fItem[i].nr), 0.0, -Abs(Sin(fItem[i].nr))-Abs(2.0*Sin(fItem[i].nr)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
          else
              vx := (rc.Right - rc.Left) / 2.0;

          If (vx_index = -1) Or (Abs(vx-(rc.Right-rc.Left) div 2) < vx_nearest) Then
          begin
              vx_index := i;
              vx_nearest := Abs(vx-(rc.Right-rc.Left) div 2);
          end;
        end;
      end
      else
      begin
        // Item preview
        glEnable (GL_TEXTURE_2D);
        glBindTexture (GL_TEXTURE_2D, fItem[i].texture.handle);

        // for transparent Object
       // glEnable (GL_Blend);


        fItem[i].texture.age := 0;
        w := fItem[i].texture.w;
        h := fItem[i].texture.h;


        // reflexion
        glColor3f (0.85-Abs(fItem[i].x)/7.0*1.5,
                   0.85-Abs(fItem[i].x)/7.0*1.5,
                   0.85-Abs(fItem[i].x)/7.0*1.5);
  //      glColor3f (Abs(fItem[i].x)/7.0*0.5,
  //                 Abs(fItem[i].x)/7.0*0.5,
   //                Abs(fItem[i].x)/7.0*0.5);

        glColor3f ((0.85-Abs(fItem[i].x)/7.0*1.5)*(1-fr)+fr,
                   (0.85-Abs(fItem[i].x)/7.0*1.5)*(1-fg)+fg,
                   (0.85-Abs(fItem[i].x)/7.0*1.5)*(1-fb)+fb);

          //           glColor3f(0.9,0.9,1.0);
        glBegin (GL_QUADS);
        glTexCoord2f (fItem[i].texture.su, fItem[i].texture.tv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), -0.75-h*2, -w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);
        glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.tv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), -0.75-h*2, w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);
        glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.sv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), -0.75, w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);
        glTexCoord2f (fItem[i].texture.su, fItem[i].texture.sv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), -0.75, -w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);
        glEnd;


        // item itsself
        glColor3f (1.0-Abs(fItem[i].x)/7.0,
                   1.0-Abs(fItem[i].x)/7.0,
                   1.0-Abs(fItem[i].x)/7.0);

        glColor3f ((1.0-Abs(fItem[i].x)/7.0)*(1-fr)+fr,
                   (1.0-Abs(fItem[i].x)/7.0)*(1-fg)+fg,
                   (1.0-Abs(fItem[i].x)/7.0)*(1-fb)+fb);

        //glColor3f(1.9,1.9,0.0);

        if check_missings then
            glLoadName(i);

        glBegin (GL_QUADS);
        glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.sv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), -0.75,
                    w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);

        glTexCoord2f (fItem[i].texture.su, fItem[i].texture.sv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), -0.75,
                    -w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);

        glTexCoord2f (fItem[i].texture.su, fItem[i].texture.tv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), -0.75+h*2,
                  -w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);

        glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.tv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), -0.75+h*2,
                 w*Sin(fItem[i].r)-w+Abs(w*Sin(fItem[i].r))-2.0+3.0*fItem[i].z);

        glEnd;
      end;
    end
    else
    begin
      If fItem[i].texture.handle <> 0 Then
        inc (fItem[i].texture.age);
    end;
  end;

  // Pedir algún preview que aún no tenemos
  If check_missings and (not Terminated) Then
  begin
    If (vx_index >= 0) And (Not fPendingPreview) Then
    begin
      fPendingPreview := True;
      SendMessageCallback (fEventsWindow, WM_FC_NEEDPREVIEW, vx_index, 0, @previewCallback, Cardinal(@self.fPendingPreview));
    end
    else
    begin
      // The callback function is called only when the thread that called SendMessageCallback also calls GetMessage, PeekMessage, or WaitMessage.
      PeekMessage (msg, 0, 0, 0, PM_NOREMOVE);
    end;
  end;
end;

procedure TRenderThread.PauseRender;
begin
  fDoRender := False;
  fFrameDone := False;

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While Not fFrameDone do
    Sleep (1);
end;

procedure TRenderThread.ResumeRender;
begin
  fDoRender := True;
  fFrameDone := False;

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While Not fFrameDone do
    Sleep (1);
end;

procedure TRenderThread.SetPreview(Index: Longint; width, height: Integer;
  pixels: PByteArray);
begin

  ReleaseSemaphore(fSemaphore, 1, Nil);

  While fQueryUpdateTexture <> index do

   {$IF CompilerVersion > 15.0}
    InterlockedCompareExchange (Longint(fQueryUpdateTexture), index, -1);
   {$ELSE}
    InterlockedCompareExchange (Pointer(fQueryUpdateTexture), Pointer(index), Pointer(-1));
   {$IFEND}
   
  fQueryUpdateTexture_width := width;
  fQueryUpdateTexture_height := height;
  fQueryUpdateTexture_pixels := pixels;
  fQueryUpdateTexture := index;

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryUpdateTexture >= 0 do
    Sleep (1);
end;

// x,r,z: Aktuelle x/y-Position und Winkel
// nx,nr,nz: Position, wo es hinsoll (next x, next y, next r (?))

procedure TRenderThread.StepItems;
var
  i : Integer;
begin
  // verschiebe die Dinger einen Schritt
  For i := 0 To High(fItem) do
  begin
    fItem[i].x := fItem[i].x * 0.995 + fItem[i].nx * 0.005;
    fItem[i].r := fItem[i].r * 0.995 + fItem[i].nr * 0.005;
    fItem[i].z := fItem[i].z * 0.995 + fItem[i].nz * 0.005;
  end;
end;

procedure TRenderThread.UpdateItems;
var
  i : Integer;
begin
  // nr: Winkel, in dem die hinteren gekippt sind
  // nx: Abstand zur Mitte des Panels (?)
  // nz: Verschiebung nach vorne/hinten
  ///    0: Ebene, in der die cover stehen
  ///    1: Ebene, in der das erste Cover steht
  ///
  For i := 0 To High(fItem) do
  begin
    If i < fCurrentItem Then
    begin
      fItem[i].nx := -1.5 - (fCurrentItem - i) * 0.5;
      fItem[i].nr := -85/180.0*PI;
      fItem[i].nz := 0.0;
    end else
    If i > fCurrentItem Then
    begin
      fItem[i].nx := 1.5 + (i - fCurrentItem) * 0.5;
      fItem[i].nr := 85.0/180.0*PI;
      fItem[i].nz := 0;
    end else
    begin
      fItem[i].nx := 0.0;
      fItem[i].nr := 0.0;
      fItem[i].nz := 1.0;
    end;
  end;
end;
        (*
procedure TRenderThread.SetCaption(caption, subcaption: String);
begin

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While
    {$IF CompilerVersion > 15.0}
      InterlockedCompareExchange (LongInt(fCaptionCS), 1, 0) <> 0
    {$ELSE}
      InterlockedCompareExchange (Pointer(fCaptionCS), Pointer(1), Pointer(0)) <> Pointer(0)
    {$IFEND}
     do
     Sleep (1);

  fCaption := caption;
  fSubCaption := subcaption;
  fTextureChanged := True;

  fCaptionCS := 0;
end;                   *)

initialization
  OPENGL_InitOK := InitOpenGL;
end.





