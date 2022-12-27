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
{ - Added Semaphores for lower CPU-usage                                     }
{ - Added Methods for changing rendering context (switching panels for Nemp) }
{ - Added method "SelectItemAt" to browse the flow by clicking an item       }
{ - Deleted some stuff like Buttons and Captions                             }
{   (this won't work well with Unicode)                                      }
{                                                                            }
{ Modified: 2020-2021 by Daniel Gaussmann (mail@gausi.de)                    }
{ - improved Item selection                                                  }
{ - configuration possible                                                   }
{     X-Position of the middle cover                                         }
{     angles                                                                 }
{     gaps                                                                   }
{     reflexions                                                             }
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

uses Windows, Messages, SysUtils, Graphics, Classes, dglOpenGL, Math;// , unitGLText;

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

  TCoverFlowSettings = record
    // All Integers are divided by 100 before usage. (except Angles: /180)
    // Planes in which the cover will be displayed
    zMain,
    zLeft,
    zRight: Integer;
    xCenter: Integer;  // unused so far
    // Gap between two covers
    GapLeft,
    GapFirstLeft,
    GapFirstRight,
    GapRight: Integer;
    // Angles, -180 ... +180
    AngleMain,
    AngleLeft,
    AngleRight: Integer;
    // Reflexion
    UseReflection: Boolean;
    ReflexionBlendFaktor: Integer;
    GapReflexion: Integer;
    // Position
    ViewPosX: Integer;
    ViewDirX: Integer;
    //
    MaxTextures: Integer;
    DefaultColor: TColor;
  end;

const
  DefaultCoverFlowSettings: TCoverFlowSettings =
  ( zMain: 100;
    zLeft: -90;
    zRight: -90;
    xCenter: 0;
    // Gap between two covers
    GapLeft: 50;
    GapFirstLeft: 180;
    GapFirstRight: 180;
    GapRight: 50;
    // Angles
    AngleMain: 0;
    AngleLeft: -85;
    AngleRight: 85;
    UseReflection: True;
    ReflexionBlendFaktor: 15;
    GapReflexion: 20;
    ViewPosX: 0;
    ViewDirX: 0;
    MaxTextures: 100;
    DefaultColor: clWhite;
  );

type
  TWMFCNeedPreview = TWMFCMessage;

  TWMFCSelect = TWMFCMessage;

  TFlyingCow = class;

  TRenderItem = record
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
    fMainPickItem: TRenderItem;
    fItem : array of TRenderItem;
    fCurrentItem : Integer;
    fSelectedItem : Integer;
    fQueryDeleteTexture : Integer;

    fQueryUpdateTexture : Integer;
    fQueryUpdateTexture_pixels : PByteArray;
    fQueryUpdateTexture_width : Integer;
    fQueryUpdateTexture_height : Integer;

    fQueryUpdateTexturePick : Integer;
    fQueryUpdateTexturePick_pixels : PByteArray;
    fQueryUpdateTexturePick_width : Integer;
    fQueryUpdateTexturePick_height : Integer;

    fQueryUpdateItemCount: Integer;
    fQueryUpdateItems: Boolean;

    fPendingPreview : Boolean;
    fEventsWindow : HWND;
    fr: single;
    fg: single;
    fb: single;
    BL_Cover,
    BL_Reflexion: Single;

    fFirstItemIsCollage: LongBool;

    // fBlendTextureHandle: GLuint;
    Settings: TCoverFlowSettings;

    procedure DrawScene;
    function DrawHitScene(x,y: Integer): Cardinal;

    procedure PrepareMainCoverPickTexture;
    procedure PrepareCoverTexture;
    procedure ClearTextures;

    procedure InitRendering;
    procedure ReInitHandles;

    procedure UpdateItemCount;

    function GetFirstItemIsCollage: LongBool;
    procedure SetFirstItemIsCollage(Value: LongBool);


  protected
    procedure Execute; override;
  public
    property FirstItemIsCollage: LongBool read GetFirstItemIsCollage write SetFirstItemIsCollage;
    constructor Create (instance : TFlyingCow; window, events_window : HWND);
    procedure PauseRender;
    procedure ResumeRender;
    procedure StepItems;
    procedure StepItemsNew(Steps: Integer);
    procedure UpdateItems;
    procedure QueryToClearTextures;
    procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);
    procedure SetMainPickCoverPreview(aWidth, aHeight : Integer; pixels : PByteArray);
    procedure RenderPass (check_missings : Boolean; rc : TRect; RenderReflexion: Boolean);
    procedure RenderClick(check_missings : Boolean; rc: TRect);
  end;
  (*
  TFlyingCowItem = class
  public
    Name, Kind, Tag : String;
    constructor Create (name, kind, tag : String);
  end;
  *)

  TFlyingCowOnPreview = procedure (index : Integer) of object;

  TFlyingCow = class
  private
    fThread : TRenderThread;
    //fItem : TList;
    fCount: Integer;
    fBeginUpdate : Boolean;
    fEventsWindow : HWND;
    // function getItem (index : Integer) : TFlyingCowItem;
    // function getCount : Integer;
    function getCurrentItem: Integer;
    procedure setCurrentItem(index: Integer);
  public
    property Count : Integer read fCount;
    property CurrentItem : Integer read getCurrentItem write setCurrentItem;


    constructor Create (window, events_window : HWND);
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Clear;
    procedure Cleartextures;
    procedure AddItems(ItemCount: Integer; FirstItemIsCollage: Boolean);

    procedure DoSomeDrawing(value: Integer);
    procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);

    procedure SetMainPickCoverPreview(width, height : Integer; pixels : PByteArray);
    procedure SelectItemAt(X,Y: Integer);

    procedure SetNewHandle(aWnd: HWND);
    procedure SetColor(r,g,b: Integer);
    procedure ApplySettings(aSettings: TCoverFlowSettings);
  end;


implementation

{ TFlyingCow }


constructor TFlyingCow.Create (window, events_window : HWND);
begin
  fThread := TRenderThread.Create (self, window, events_window);
  fEventsWindow := events_window;
  fBeginUpdate := False;
  fCount := 0;
  //fThread.Start;
end;

destructor TFlyingCow.Destroy;
begin
    BeginUpdate;
    Clear;
    try
        fThread.Terminate;
        fThread.WaitFor;
        fThread.Free;
    except
        // nothing
    end;
    fThread := Nil;
    inherited destroy;
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
begin
  AddItems(0, True);
end;

procedure TFlyingCow.Cleartextures;
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;

  fThread.QueryToClearTextures;

  If Not fBeginUpdate Then
    fThread.ResumeRender;
end;

procedure TFlyingCow.AddItems(ItemCount: Integer; FirstItemIsCollage: Boolean);
begin
  if not fBeginUpdate then
    fThread.PauseRender;
  fCount := ItemCount;
  fThread.FirstItemIsCollage := FirstItemIsCollage;
  fThread.fQueryUpdateItemCount := ItemCount;
  // This will start TRenderThread.UpdateItemCount through RenderThread-MainMethod

  if not fBeginUpdate then
      fThread.ResumeRender;
end;

procedure TFlyingCow.DoSomeDrawing(value: Integer);
begin
  If Not fBeginUpdate Then
    fThread.PauseRender;
  ReleaseSemaphore(fThread.fSemaphore, value, Nil);
  If Not fBeginUpdate Then
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


function TFlyingCow.getCurrentItem: Integer;
begin
  Result := fThread.fCurrentItem;
end;

procedure TFlyingCow.setCurrentItem (index: Integer);
begin
  fThread.PauseRender;
  fThread.fSelectedItem := -1;
  fThread.fCurrentItem := index;
  fThread.UpdateItems;
  fThread.ResumeRender;
  DoSomeDrawing(20);
end;


procedure TFlyingCow.SetNewHandle(aWnd: HWND);
begin
    if aWnd <> fThread.fWindow then begin
      fThread.PauseRender;
      fThread.fNewHandle := aWnd;
      fThread.fNewHandleNeeded := True;
      // clear textures, we need to reinit rendering completeley
      fThread.QueryToClearTextures;
      fThread.ResumeRender;
      DoSomeDrawing(20);
    end;
end;

procedure TFlyingCow.SetColor(r,g,b: Integer);
begin
    fThread.PauseRender;
    // Clear Textures
    fThread.QueryToClearTextures;

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

procedure TFlyingCow.ApplySettings(aSettings: TCoverFlowSettings);
begin
  fThread.PauseRender;
  fThread.Settings := aSettings;
  fThread.BL_Cover := -0.75;
  fThread.BL_Reflexion := -0.75 - (aSettings.GapReflexion / 100);
  fThread.fQueryUpdateItems := True;
  fThread.ResumeRender;
  DoSomeDrawing(50);
end;

procedure TFlyingCow.SetMainPickCoverPreview(width, height : Integer; pixels : PByteArray);
begin
  fThread.SetMainPickCoverPreview(width, height, pixels);
end;


{ TRenderThread }

constructor TRenderThread.Create(instance: TFlyingCow; window, events_window : HWND);
begin
  inherited Create (False);
  fSemaphore := CreateSemaphore(Nil, 0, maxInt, Nil);
  FreeOnTerminate := False;
  fInstance := instance;
  fWindow := window;
  fDoRender := True;
  fAllowItemAccess := True;
  fFrameDone := False;
  SetLength (fItem, 0);
  fCurrentItem := -1;//0;
  fSelectedItem := -1;
  fQueryDeleteTexture := -1;
  fQueryUpdateTexture := -1;
  fQueryUpdateTexturePick := -1;
  fQueryUpdateItemCount := -1;
  fQueryUpdateItems := False;
  fPendingPreview := False;
  fEventsWindow := events_window;
  fXClicked := -1;
  fYClicked := -1;
  fr := 0.0;
  fg := 0.0;
  fb := 0.0;
  BL_Cover := -0.75;
  BL_Reflexion := -0.85;
end;

procedure TRenderThread.QueryToClearTextures;
const
  zuv: Integer=42;
begin

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryDeleteTexture >= 0 do
	  {$IF CompilerVersion > 15.0}
      InterlockedCompareExchange(LongInt(fQueryDeleteTexture), zuv, -1);
    {$ELSE}
      InterlockedCompareExchange (Pointer(fQueryDeleteTexture), Pointer(zuv), Pointer(-1));
    {$IFEND}

  fQueryDeleteTexture := zuv;
  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryDeleteTexture = zuv do
    Sleep (1);
end;

procedure TRenderThread.ClearTextures;
var
  i: Integer;
begin
  if fMainPickItem.texture.handle <> 0 then
  begin
    glDeleteTextures (1, @fMainPickItem.texture.handle);
    fMainPickItem.texture.handle := 0;
  end;
  for i := 0 to Length(fItem) - 1 do
  begin
    if fItem[i].texture.handle <> 0 then
    begin
      glDeleteTextures (1, @fItem[i].texture.handle);
      fItem[i].texture.handle := 0;
    end;
  end;
  fQueryDeleteTexture := -1;
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
  texture_count : Integer;
  oldest_index : Integer;
  MoreNeeded: Boolean;
  NewSelectedItem: Cardinal;
  localDoRender: Boolean;

  RenderCount: Integer;
begin
  // Iniciar OpenGL
  InitRendering;
  localDoRender := True;

  glGenTextures (1, @fMainPickItem.texture.handle);

  RenderCount := 0;
  // Cargar fuente de letras
  // Oki doki, a laburar se ha dicho
  fTimer := GetTickCount;
  While Not Terminated do
  begin
    if (WaitforSingleObject(fSemaphore, 1000) = WAIT_OBJECT_0) then
      if (not Terminated) then
      begin
        inc(RenderCount);
                if fNewHandleNeeded then
                begin
                    // The Panel-Handle has Changed.
                    ReInitHandles;
                    fNewHandleNeeded := False;
                    localDoRender := True;
                end;

                MoreNeeded := False;

                if fQueryUpdateItemCount >= 0 then
                begin
                  // the itemCount of the Coverflow has been changed
                  UpdateItemCount;
                  localDoRender := True;
                  MoreNeeded := True;
                end;

                if fQueryUpdateItems then
                begin
                  UpdateItems;
                  localDoRender := True;
                  MoreNeeded := True;
                end;

                // Petición de borrar una textura
                If fQueryDeleteTexture >= 0 Then
                begin
                  ClearTextures;
                  localDoRender := True;
                  MoreNeeded := True;
                end;

                if fQueryUpdateTexturePick >= 0 then
                  PrepareMainCoverPickTexture;

                // Petición de actualizar una textura
                If fQueryUpdateTexture >= 0 Then
                begin
                  localDoRender := True;
                  PrepareCoverTexture;
                  MoreNeeded := True;
                end;

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
                    If texture_count > settings.MaxTextures Then
                    begin
                        glDeleteTextures (1, @fItem[oldest_index].texture.handle);
                        fItem[oldest_index].texture.handle := 0;
                    end;
                end;


                If fDoRender and fAllowItemAccess Then
                begin
                    // Animar las imágenes
                    delta_t := GetTickCount - fTimer;
                    {While delta_t >= 10 do
                    begin
                      inc (fTimer);
                      dec (delta_t);
                      StepItems;
                    end;}

                    StepItemsNew(max(delta_t - 10, 1));
                    fTimer := GetTickCount - 10;


                    // Mostrar las imágenes
                    //glClear (GL_DEPTH_BUFFER_BIT);
                    //glClear (GL_COLOR_BUFFER_BIT);

                    glMatrixMode (GL_PROJECTION);
                    glLoadIdentity;
                    GetClientRect (fWindow, fRC);
                    glViewport (0, 0, fRC.Right-fRC.Left, fRC.Bottom-fRC.Top);
                    gluPerspective (45.0, (fRC.Right-fRC.Left) / (fRC.Bottom-fRC.Top), 0.1, 100.0);

                    gluLookAt(-Settings.ViewPosX/100, 0, 1.0, // position
                              -Settings.ViewPosX/100,0,-1,  // viewing direction = position (for now)
                              0,1,0);                      // vector upwards

                    if self.fXClicked <> -1  then
                    begin
                        NewSelectedItem := DrawHitScene(fXClicked, (fRC.Bottom-fRC.Top)-fYClicked);
                        if NewSelectedItem < $007FFFFF then
                        begin
                          fCurrentItem := NewSelectedItem;
                          if fCurrentItem < 0 then
                            fCurrentItem := 0;
                          if fCurrentItem > High(fItem)  then
                            fCurrentItem := High(fItem);
                          if not Terminated then
                            PostMessage (fEventsWindow, WM_FC_SELECT, fCurrentItem, 0);
                        end;
                        fSelectedItem := -1;
                        UpdateItems;
                        fXClicked := -1;
                        fYClicked := -1;
                    end else
                    begin
                      if localDoRender then
                        //DrawHitScene(0,0); // only for testing
                        DrawScene;
                    end;
                end
                else
                begin
                  fTimer := GetTickCount - 10;
                    {delta_t := GetTickCount - fTimer;
                    While delta_t >= 10 do
                    begin
                      inc (fTimer);
                      dec (delta_t);
                    end;
                    }
                end;

                if fDoRender then
                begin
                  // Chequear si se selecciona un item nuevo
                  If (fSelectedItem <> fCurrentItem) And
                     (fCurrentItem >= 0) And
                     (fCurrentItem <= High(fItem)) And
                     (Abs(fItem[fCurrentItem].x) < 0.001) AND
                     (not MoreNeeded) Then
                  begin
                    if not terminated then
                      PostMessage (fEventsWindow, WM_FC_SELECT, fCurrentItem, RenderCount);
                    fSelectedItem := fCurrentItem;
                    localDoRender := False;
                  end else
                  begin
                    // We need more to do. Release Semaphore, so this
                    // will be done again.
                    if (High(fItem) > 0) then begin
                      localDoRender := True;
                      if (fSelectedItem <> fCurrentItem) or (MoreNeeded) then
                        ReleaseSemaphore(fSemaphore, 1, Nil);
                    end;
                  end;

                  if fPendingPreview then
                  begin
                    localDoRender := True;
                    if (fSelectedItem <> fCurrentItem) or (MoreNeeded) then
                      ReleaseSemaphore(fSemaphore, 1, Nil);
                  end;


                end;

                fFrameDone := True;
      end;
  end;
  // Finalizar OpenGL
  wglMakeCurrent (0, 0);
  wglDeleteContext (glrc);
  ReleaseDC (fWindow, fDC);
end;

procedure TRenderThread.DrawScene;
begin
    glClearColor(fr, fg, fb, 0.0);
    glMatrixMode (GL_MODELVIEW);
    glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
    glLoadIdentity;
    glTranslatef (0.0, -0.1, -3.0);
    glInitNames;
    glPushName(0);

    // Filling
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
    glEnable (GL_Blend);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glEnable (GL_POLYGON_OFFSET_FILL);
    glPolygonOffset (1.0, 1.0);
    RenderPass (True, fRC, True);
    glDisable (GL_BLEND);

    glDisable (GL_POLYGON_OFFSET_FILL);

    // Antialiasing
    glEnable (GL_BLEND);
    glHint (GL_LINE_SMOOTH_HINT, GL_NICEST);
    glPolygonMode (GL_FRONT_AND_BACK, GL_LINE);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDepthMask (False);
    glDepthFunc (GL_LEQUAL);
    RenderPass (False, fRC, False);
    glDepthMask (True);
    glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
    glDisable (GL_BLEND);

    SwapBuffers (fDC);
end;

function TRenderThread.DrawHitScene(x,y: Integer): Cardinal;
var PixelData: Cardinal;
begin
  glClearColor(1, 1, 1, 0.0);
  glMatrixMode (GL_MODELVIEW);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glLoadIdentity;
  glTranslatef (0.0, -0.1, -3.0);
  // Filling
  glPolygonMode (GL_FRONT_AND_BACK, GL_FILL);
  glEnable (GL_POLYGON_OFFSET_FILL);
  glPolygonOffset (1.0, 1.0);
  RenderClick(True, fRC);
  glDisable (GL_POLYGON_OFFSET_FILL);
  glFlush();
  glFinish();

  // Get PixelData
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glReadPixels(x, y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, @PixelData);

  PixelData := PixelData and  $00FFFFFF;

  if (PixelData < $00FFFFFF) and FirstItemIsCollage then
  begin
    if ((PixelData shr 23) and 1 ) = 1 then
    begin
      if fCurrentItem = 0 then
        // we clicked the first Cover, and it was already the first one
        // => jump to the clicked cover on this collage
        PixelData := PixelData and $007FFFFF
      else
        // we clicked the first Cover, but it wasn't already selected
        // => jump to the first cover
        PixelData := 0
    end
  end;
  result := PixelData;
  //for testing only:
  //if not terminated and (x*y <> 0)then
  //   PostMessage (fEventsWindow, WM_FLYINGCOWTEST, WParam(PixelData), 0);
  // SwapBuffers (fDC);
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

procedure TRenderThread.RenderPass(check_missings: Boolean; rc : TRect; RenderReflexion: Boolean);
var
  modelMatrix, projMatrix : TGLMatrixd4;
  viewport : TGLVectori4;
  vx_nearest : Single;
  vx_index : Integer;
  i : Integer;
  vx, vy, vz : GLDouble;
  w, h : Single;
  msg : TMSG;

  procedure DoItem;
  begin
      // Determinar si el item cae dentro de la pantalla
    If fItem[i].x > -2.0 Then
        gluProject (fItem[i].x+Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else If fItem[i].x < 2.0 Then
        gluProject (fItem[i].x-Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else
        vx := (rc.Right - rc.Left) / 2.0;
    //If (vx >= (rc.Right-rc.Left) div 8) And (vx < (rc.Right-rc.Left)*7 div 8) Then
    If (vx >= -(rc.Right-rc.Left) {div 2}) And (vx < (rc.Right-rc.Left)*3 div 2) Then
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

        fItem[i].texture.age := 0;
        w := fItem[i].texture.w;
        h := fItem[i].texture.h;

        if check_missings then
          glLoadName(i);
        //-----------------------------
        // reflexion
        if Settings.UseReflection and RenderReflexion then
        begin
            glColor4f(1,1,1, settings.ReflexionBlendFaktor/100);
            glBegin (GL_QUADS);
            glTexCoord2f (fItem[i].texture.su, fItem[i].texture.tv);
            glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Reflexion-h*2, -w*Sin(fItem[i].r) + fItem[i].z);
            glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.tv);
            glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Reflexion-h*2, w*Sin(fItem[i].r) + fItem[i].z);
            glTexCoord2f (fItem[i].texture.tu, fItem[i].texture.sv);
            glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Reflexion, w*Sin(fItem[i].r) + fItem[i].z);
            glTexCoord2f (fItem[i].texture.su, fItem[i].texture.sv);
            glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Reflexion, -w*Sin(fItem[i].r) + fItem[i].z);
            glEnd;
        end;
        //-----------------------------

        //-----------------------------
        // item itself
        glColor3f(1,1,1);
        glBegin (GL_QUADS);
        glTexCoord2f ( fItem[i].texture.tu, fItem[i].texture.sv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Cover, w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( fItem[i].texture.su, fItem[i].texture.sv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Cover, -w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( fItem[i].texture.su, fItem[i].texture.tv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Cover+h*2, -w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( fItem[i].texture.tu, fItem[i].texture.tv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Cover+h*2, w*Sin(fItem[i].r) + fItem[i].z);
        glEnd;
        //-----------------------------
      end;
    end
    else
    begin
      If fItem[i].texture.handle <> 0 Then
        inc (fItem[i].texture.age);
    end;
  end;

begin
  glGetDoublev (GL_MODELVIEW_MATRIX, @modelMatrix);
  glGetDoublev (GL_PROJECTION_MATRIX, @projMatrix);
  glGetIntegerv (GL_VIEWPORT, @viewport);
  vx_index := -1;
  vx_nearest := 0;

  i := fCurrentItem;
  if (fCurrentItem >= 0) and (fCurrentItem <= High(fitem)) then
    DoItem;
  for i := fCurrentItem + 1 to High(fItem) do
    DoItem;
  for i := fCurrentItem - 1 downTo 0 do
    DoItem;

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
      PeekMessage (msg, 0, 0, 0, PM_REMOVE);
    end;
  end;
end;

procedure TRenderThread.RenderClick(check_missings : Boolean; rc: TRect);
var
  modelMatrix, projMatrix : TGLMatrixd4;
  viewport : TGLVectori4;
  i : Integer;
  vx, vy, vz : GLDouble;
  w, h : Single;
  aRenderItem: TRenderItem;

begin
  glGetDoublev (GL_MODELVIEW_MATRIX, @modelMatrix);
  glGetDoublev (GL_PROJECTION_MATRIX, @projMatrix);
  glGetIntegerv (GL_VIEWPORT, @viewport);

  For i := 0 To High(fItem) do
  begin
    // Determinar si el item cae dentro de la pantalla
    If fItem[i].x > -2.0 Then
        gluProject (fItem[i].x+Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else If fItem[i].x < 2.0 Then
        gluProject (fItem[i].x-Cos(fItem[i].r), 0.0, -Abs(Sin(fItem[i].r))-Abs(2.0*Sin(fItem[i].r)), modelMatrix, projMatrix, viewport, @vx, @vy, @vz)
    else
        vx := (rc.Right - rc.Left) / 2.0;
    //If (vx >= (rc.Right-rc.Left) div 8) And (vx < (rc.Right-rc.Left)*7 div 8) Then
    If (vx >= -(rc.Right-rc.Left) div 2) And (vx < (rc.Right-rc.Left)*3 div 2) Then
    begin
        // Item preview
        if (i = 0) and FirstItemIsCollage then
        begin
          // the first cover art needs a texture, filled with the matching colors
          // of the displayed sub cover art on it.
          glEnable(GL_Blend);
          glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

          aRenderItem := fMainPickItem;
          glEnable(GL_TEXTURE_2D);
          glBindTexture (GL_TEXTURE_2D, aRenderItem.texture.handle);

          glColor3f(1,1,1);
        end else
        begin
          aRenderItem := fItem[i];
          glDisable(GL_TEXTURE_2D);
          glDisable(GL_Blend);

          glColor3f(
            (i and $000000FF) / 255,
            ((i and $0000FF00) shr 8) / 255,
            ((i and $00FF0000) shr 16) / 255 );
        end;

        aRenderItem.texture.age := 0;
        w := aRenderItem.texture.w;
        h := aRenderItem.texture.h;

        if check_missings then
          glLoadName(i);

        glBegin (GL_QUADS);
        glTexCoord2f ( aRenderItem.texture.tu, aRenderItem.texture.sv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Cover, w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( aRenderItem.texture.su, aRenderItem.texture.sv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Cover, -w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( aRenderItem.texture.su, aRenderItem.texture.tv);
        glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Cover+h*2, -w*Sin(fItem[i].r) + fItem[i].z);
        glTexCoord2f ( aRenderItem.texture.tu, aRenderItem.texture.tv);
        glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Cover+h*2, w*Sin(fItem[i].r) + fItem[i].z);
        glEnd;

        if Settings.UseReflection then
        begin
          glBegin (GL_QUADS);
          glTexCoord2f (aRenderItem.texture.su, aRenderItem.texture.tv);
          glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Reflexion-h*2, -w*Sin(fItem[i].r) + fItem[i].z);
          glTexCoord2f (aRenderItem.texture.tu, aRenderItem.texture.tv);
          glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Reflexion-h*2, w*Sin(fItem[i].r) + fItem[i].z);
          glTexCoord2f (aRenderItem.texture.tu, aRenderItem.texture.sv);
          glVertex3f (fItem[i].x+w*Cos(fItem[i].r), BL_Reflexion, w*Sin(fItem[i].r) + fItem[i].z);
          glTexCoord2f (aRenderItem.texture.su, aRenderItem.texture.sv);
          glVertex3f (fItem[i].x-w*Cos(fItem[i].r), BL_Reflexion, -w*Sin(fItem[i].r) + fItem[i].z);
          glEnd;
        end;
    end
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

procedure TRenderThread.PrepareCoverTexture;
var
  pw, ph : Integer;
  px, py : Integer;
  ps, pd : PByteArray;
  temp : PByteArray;
  diff: single;
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
  diff := 0.005;
  pw := Pow2(fQueryUpdateTexture_width);
  ph := Pow2(fQueryUpdateTexture_height);
  fItem[fQueryupdateTexture].texture.su :=  0.5/pw + diff;
  fItem[fQueryupdateTexture].texture.sv := (1.0 - fQueryUpdateTexture_height/ph) + 0.5/ph + diff;
  fItem[fQueryupdateTexture].texture.tu := fQueryUpdateTexture_width/pw - 0.5/pw - diff;
  fItem[fQueryupdateTexture].texture.tv := 1.0 - 0.5/ph - diff;
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
end;


procedure TRenderThread.SetMainPickCoverPreview(aWidth, aHeight : Integer; pixels : PByteArray);
var index: Integer;
begin
  ReleaseSemaphore(fSemaphore, 1, Nil);
  index := 0;
  While fQueryUpdateTexturePick <> index do
   {$IF CompilerVersion > 15.0}
    InterlockedCompareExchange (Longint(fQueryUpdateTexturePick), index, -1);
   {$ELSE}
    InterlockedCompareExchange (Pointer(fQueryUpdateTexturePick), Pointer(index), Pointer(-1));
   {$IFEND}

  fQueryUpdateTexturePick_width := aWidth;
  fQueryUpdateTexturePick_height := aHeight;
  fQueryUpdateTexturePick_pixels := pixels;
  fQueryUpdateTexturePick := index;

  ReleaseSemaphore(fSemaphore, 1, Nil);
  While fQueryUpdateTexturePick >= 0 do
    Sleep (1);
end;

procedure TRenderThread.PrepareMainCoverPickTexture;
var
  pw, ph : Integer;
  px, py : Integer;
  ps, pd : PByteArray;
  temp : PByteArray;
begin
  glBindTexture (GL_TEXTURE_2D, fMainPickItem.texture.handle);
  // prepare Pixeldata for TextureData
  If fQueryUpdateTexturePick_Width > fQueryUpdateTexturePick_Height Then
  begin
      fMainPickItem.texture.w := 1.0;
      fMainPickItem.texture.h := fQueryUpdateTexturePick_Height / fQueryUpdateTexturePick_Width;
  end
  else
  begin
      fMainPickItem.texture.w := fQueryUpdateTexturePick_Width / fQueryUpdateTexturePick_Height;
      fMainPickItem.texture.h := 1.0;
  end;

  pw := Pow2(fQueryUpdateTexturePick_Width);
  ph := Pow2(fQueryUpdateTexturePick_Height);
  fMainPickItem.texture.su :=  0.5/pw ;
  fMainPickItem.texture.sv := (1.0 - fQueryUpdateTexturePick_Height/ph) + 0.5/ph ;
  fMainPickItem.texture.tu := fQueryUpdateTexturePick_Width/pw - 0.5/pw;
  fMainPickItem.texture.tv := 1.0 - 0.5/ph ;
  fMainPickItem.texture.age := 0;

  GetMem (temp, pw*ph*4);
  ps := @fQueryUpdateTexturePick_pixels[(fQueryUpdateTexturePick_Height-1)*Align4(fQueryUpdateTexturePick_Width*3)];
  pd := @temp[pw*ph*4-pw*4];
  FillChar (temp^, pw*ph*4, $FF);
  For py := 0 To fQueryUpdateTexturePick_Height-1 do
  begin
      For px := 0 To fQueryUpdateTexturePick_Width-1 do
      begin
          pd[px*4+0] := ps[px*3+2];
          pd[px*4+1] := ps[px*3+1];
          pd[px*4+2] := ps[px*3+0];
      end;
      ps := @ps[-Align4(fQueryUpdateTexturePick_Width*3)];
      pd := @pd[-pw*4];
  end;
  glTexImage2D (GL_TEXTURE_2D, 0, 4, pw, ph, 0, GL_RGBA, GL_UNSIGNED_BYTE, temp);
  FreeMem (temp);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

  fQueryUpdateTexturePick := -1;
end;

function TRenderThread.GetFirstItemIsCollage: LongBool;
begin
  InterLockedExchange(Integer(Result), Integer(fFirstItemIsCollage));
end;

procedure TRenderThread.SetFirstItemIsCollage(Value: LongBool);
begin
  InterLockedExchange(Integer(fFirstItemIsCollage), Integer(Value));
end;


// The number of items in the coverflow has been changed
// reinit Textures, Positions etc. of the fItem-Array
// Thread: OpenGL-RenderThread
procedure TRenderThread.UpdateItemCount;
var i: Integer;
begin
  if fQueryUpdateItemCount < 0 then
    exit;

  ClearTextures; // ??

  SetLength (fItem, fQueryUpdateItemCount);
  UpdateItems;
  for i := 0 to High(fItem) do
  begin
    fItem[i].x := fItem[i].nx;
    fItem[i].r := fItem[i].nr;
    fItem[i].z := fItem[i].nz;
    fItem[i].texture.handle := 0;  // ?? ggf. doppelt gemacht
  end;
  fSelectedItem := 0;
  // the following lines are needed for swapping Categories
  if fCurrentItem > fQueryUpdateItemCount then
    fCurrentItem := 0;

  fQueryUpdateItemCount := -1;
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

procedure TRenderThread.StepItemsNew(Steps: Integer);
var
  i : Integer;
  v1, v2: Double;
begin
  v1 := power(0.995, Steps);
  v2 := 1 - v1;
  for i := 0 to High(fItem) do begin
    fItem[i].x := fItem[i].x * v1 + fItem[i].nx * v2;
    fItem[i].r := fItem[i].r * v1 + fItem[i].nr * v2;
    fItem[i].z := fItem[i].z * v1 + fItem[i].nz * v2;
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
      fItem[i].nx := Settings.xCenter/100 - (Settings.GapFirstLeft/100) - (fCurrentItem - i-1) * Settings.GapLeft/100;
      fItem[i].nr := Settings.AngleLeft/180.0*PI;
      fItem[i].nz := Settings.zLeft/100;
    end else
    If i > fCurrentItem Then
    begin
      fItem[i].nx := Settings.xCenter/100 + Settings.GapFirstRight/100 + (i-1 - fCurrentItem) * Settings.GapRight/100;
      fItem[i].nr := Settings.AngleRight/180.0*PI;
      fItem[i].nz := Settings.zRight/100;
    end else
    begin
      fItem[i].nx := Settings.xCenter/100;
      fItem[i].nr := Settings.AngleMain/180.0*PI;
      fItem[i].nz := Settings.zMain/100;
    end;
  end;
  fQueryUpdateItems := False;
end;


initialization
  OPENGL_InitOK := InitOpenGL;
end.

