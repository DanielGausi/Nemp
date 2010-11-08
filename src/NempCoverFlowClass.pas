{

    Unit NempCoverFlowClass

    -  This is a Container-Class for different Types of Coverflows.
       The classicFlow and FlyingCow are that different, that a common
       ParentClass would not work
       Also I would like to switch at runtime between the two (or later more)
       modes


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

unit NempCoverFlowClass;

interface

uses Windows, Messages, SysUtils, Graphics, ExtCtrls, ContNrs, Classes,
    ClassicCoverFlowClass, unitFlyingCow, CoverHelper, dialogs, CoverDownloads,
    AudioFileClass;

type

    TCoverFlowMode = (cm_None, cm_Classic, cm_OpenGL);


    TNempCoverFlow = class
        private
            fClassicFlow: TClassicCoverFlow;
            fFlyingCow: TFlyingCow;
            fMode: TCoverFlowMode;

            fCoverList: TObjectList;

            fDownloadThread: TCoverDownloadWorkerThread;

            fCurrentItem: Integer;  // Index of the current selected cover

            fCurrentCoverID: String;     // currently selected coverID
            // Note: I'm not using a NempCover-object here, to remember the idx, even
            //       if a Cover is deleted.

            function fGetCurrentItem: Integer;
            // SetCurrentItem: Set the current Item and draws cover and scrollcover
            procedure fSetCurrentItem(aValue: Integer);

            procedure fSetMode(aValue: TCoverFlowMode);


        public
            CoverSavePath: String;

            // needed for ClassicFlow
            MainImage: TImage;
            ScrollImage: TImage;

            // Needed for FlyingCow
            window: HWND;
            events_window: HWND;

            property Mode: TCoverFlowMode read fMode write fSetMode;

            property CurrentItem: Integer read fGetCurrentItem write fSetCurrentItem;
            property CurrentCoverID: String read fCurrentCoverID write fCurrentCoverID;

            Constructor Create;
            Destructor Destroy; override;
            procedure Clear;

            // After a reinit of the library (swapping lists)
            // we need to correct the CoverList-Pointer
            procedure SetNewList(aList: TObjectList);

            // Clear Textures and force redrawing
            procedure ClearTextures;

            // Setpreview is only needed by FlyingCow.
            // In ClassicMode this will do nothing
            procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);

            // After a sorting of the Coverlist, the current selected cover should be selected
            // again. FindCurrentItemAgain finds it in the List and Set the CurrentItem properly
            procedure FindCurrentItemAgain;

            // ReInitAfterSort: Used by ClassicMode.
            // FlyingCow doesnt need a sorted copy of the NempCoverList
            procedure ReInitAfterSort;

            procedure SelectItemAt(x, y: Integer);

            // Repaint
            // used by repaint/Onresize
            procedure Paint(i: Integer = 1);

            procedure SetNewHandle(aWnd: HWND);
            procedure SetColor(aColor: TColor);

            procedure DownloadCover(aCover: TNempCover; aIdx: Integer);
            procedure DownloadPlayerCover(aAudioFile: TAudioFile);

            procedure ClearCoverCache;

    end;

implementation

uses NempMainUnit;

{ TNempCoverFlow }

procedure TNempCoverFlow.fSetMode(aValue: TCoverFlowMode);
var i: integer;
begin
    // fallback to classic-mode, if opengl was not initialized
    if (aValue = cm_OpenGL) and (not OPENGL_InitOK) then
        aValue := cm_Classic;

    case aValue of
        cm_None: begin
            fMode := aValue;
            FreeAndNil(fFlyingCow);
            FreeAndNil(fClassicFlow);
            Nemp_MainForm.IMGMedienBibCover.Visible := False;
            Nemp_MainForm.Lbl_CoverFlow.Visible     := False;
            Nemp_MainForm.ImgScrollCover.Visible    := False;
        end;

        cm_Classic :
        begin
            fMode := aValue;
            if Not Assigned(fClassicFlow) then
            begin
                fClassicFlow := TClassicCoverFlow.Create;
            end;
                fClassicFlow.MainImage := MainImage;
                fClassicFlow.ScrollImage := ScrollImage;
                fClassicFlow.CoverList := fCoverList;
                fClassicFlow.CoverSavePath := CoverSavePath;

            fClassicFlow.CurrentItem := fCurrentItem;
            Nemp_MainForm.IMGMedienBibCover.Visible := True;
            Nemp_MainForm.Lbl_CoverFlow.Visible     := True;
            Nemp_MainForm.ImgScrollCover.Visible    := True;
            Nemp_MainForm.PanelCoverBrowse.DoubleBuffered := True;
            Nemp_MainForm.CoverScrollbar.DoubleBuffered := False;


            //FreeAndNil(fFlyingCow);
        end;

        cm_OpenGL  :
        begin
            fMode := aValue;
            if Not Assigned(fFlyingCow) then
            begin
                fFlyingCow := tFlyingCow.Create(window, events_Window);
            end;
                fFlyingCow.BeginUpdate;
                for i := 0 to fCoverList.Count - 1 do
                begin
                    fFlyingCow.Add(TFlyingCowItem.Create(TNempCover(fCoverList[i]).ID,
                                      TNempCover(fCoverList[i]).Artist,
                                      TNempCover(fCoverList[i]).Album));
                end;
                fFlyingCow.EndUpdate;


            Nemp_MainForm.IMGMedienBibCover.Visible := False;
            Nemp_MainForm.Lbl_CoverFlow.Visible     := True;
            Nemp_MainForm.ImgScrollCover.Visible    := False;

            Nemp_MainForm.PanelCoverBrowse.DoubleBuffered := False;
            Nemp_MainForm.CoverScrollbar.DoubleBuffered := False;

            Nemp_MainForm.PanelCoverBrowse.BringToFront;
            SetNewHandle(Nemp_MainForm.PanelCoverBrowse.Handle);

            fFlyingCow.CurrentItem := fCurrentItem;


            //FreeAndNil(fClassicFlow);
        end;
    end;

end;

procedure TNempCoverFlow.Paint(i: Integer = 1);
begin
    case fMode of
      cm_Classic : ;
      cm_OpenGL  : fFlyingCow.DoSomeDrawing(i);
    end;
end;

procedure TNempCoverFlow.FindCurrentItemAgain;
var i, newItem: Integer;
begin
    newItem := -1;
    for i := 0 to fCoverlist.Count -  1 do
    if tNempCover(fCoverlist[i]).ID = fCurrentCoverID then
    begin
        newItem := i;
        break;
    end;
    if newItem = -1 then
        // Change item, so there is a "change" notified by the main window. ;-)
        newItem := fCurrentItem - 1;
    if (newItem >= fCoverlist.Count) or (newItem < 0) then
        newItem := 0;


    Currentitem := newItem;
    if fMode = cm_OpenGL then
        fFlyingCow.Cleartextures;

end;

procedure TNempCoverFlow.ReInitAfterSort;
begin
    case fMode of
        cm_Classic : begin
            // Altes Cover wieder finden
            fClassicFlow.ScrollToCurrentItem;
        end;
        cm_OpenGL  : begin

        end;
    end;
end;

procedure TNempCoverFlow.Clear;
begin
    case fMode of
      cm_Classic : fClassicFlow.CoverList := NIL;  // nothing more to do (?)
      cm_OpenGL  : fFlyingCow.Clear;
    end;
end;


constructor TNempCoverFlow.Create;
begin
  inherited;
  fClassicFlow := Nil;
  fFlyingCow := Nil;
  fMode := cm_None;
  fDownloadThread := TCoverDownloadWorkerThread.Create;
end;

destructor TNempCoverFlow.Destroy;
begin
    Mode := cm_None; // This will also free the sub-coverflows

    fDownloadThread.Terminate;
    fDownloadThread.WaitFor;
    fDownloadThread.Free;

    inherited Destroy;
end;

procedure TNempCoverFlow.DownloadCover(aCover: TNempCover; aIdx: Integer);
begin
    if (aCover.Album <> 'Unknown compilation')
        and (not UnKownInformation(aCover.Artist))
        and (not UnKownInformation(aCover.Album))
    then
        fDownloadThread.AddJob(aCover, aIdx);
end;

procedure TNempCoverFlow.DownloadPlayerCover(aAudioFile: TAudioFile);
begin
    fDownloadThread.AddJob(aAudioFile, 0);
end;

procedure TNempCoverFlow.ClearCoverCache;
begin
    fDownloadThread.ClearCacheList;
end;

function TNempCoverFlow.fGetCurrentItem: Integer;
begin
    result := fCurrentItem;
{    case fMode of
        cm_Classic : result := fClassicFlow.CurrentItem;
        cm_OpenGL  : result := fFlyingCow.CurrentItem;
    else
        begin
            result := 0;
        end;
    end;  }
end;

procedure TNempCoverFlow.fSetCurrentItem(aValue: Integer);
begin
    //if (aValue >= 0) and (aValue <= fCoverList.Count-1) then
    begin
        if aValue < 0 then
            aValue := 0;
        if aValue > fCoverList.Count - 1 then
            aValue := fCoverList.Count - 1;

        case fMode of
            cm_Classic : fClassicFlow.CurrentItem := aValue;
            cm_OpenGL  : fFlyingCow.CurrentItem := aValue;
        end;

        fDownloadThread.MostImportantIndex := aValue;
        fCurrentitem := aValue;
        if (aValue >= 0) and (aValue <= fCoverList.Count-1) then
        begin
            fCurrentCoverID := TNempCover(fCoverList[aValue]).ID;
        end //else
            //fCurrentCoverID := 'all';
    end;
end;

procedure TNempCoverFlow.SelectItemAt(x, y: Integer);
begin
    case fMode of
        cm_Classic : begin
                  fClassicFlow.SelectItemAt(x, y);
                  CurrentItem := fClassicFlow.CurrentItem;
        end;
        cm_OpenGL  : begin
                  fFlyingCow.SelectItemAt(x, y);
                  CurrentItem := fFlyingCow.CurrentItem;
        end;
    end;
end;

procedure TNempCoverFlow.SetNewHandle(aWnd: HWND);
begin
    case fMode of
        cm_Classic : ; // nothing to do here
        cm_OpenGL  : begin
            fFlyingCow.SetNewHandle(aWnd);
        end;
    end;
end;
procedure TNempCoverFlow.SetColor(aColor: TColor);
var r,g,b: Integer;
begin
    r := GetRValue(aColor);
    g := GetGValue(aColor);
    b := GetBValue(aColor);

    case fMode of
        cm_Classic : ; // nothing to do here
        cm_OpenGL  : begin
            fFlyingCow.SetColor(r,g,b);
        end;
    end;
end;

procedure TNempCoverFlow.SetNewList(aList: TObjectList);
var i: Integer;
begin
    fCoverList := aList;
    case fMode of
        cm_Classic : fClassicFlow.CoverList := aList;
        cm_OpenGL  : begin
              fFlyingCow.BeginUpdate;
              fFlyingCow.Clear;
              fFlyingCow.Cleartextures;
              for i := 0 to aList.Count - 1 do
              begin
                  fFlyingCow.Add(TFlyingCowItem.Create(//'' , '' , ''
                                      TNempCover(aList[i]).ID,
                                      TNempCover(aList[i]).Artist,
                                      TNempCover(aList[i]).Album
                                      ));
              end;
              fFlyingCow.EndUpdate;

              fFlyingCow.DoSomeDrawing(10);
        end;
    end;
    FindCurrentItemAgain;
end;

procedure TNempCoverFlow.ClearTextures;
begin
    case fMode of
        cm_Classic : ; // nothing to do here
        cm_OpenGL  : begin
              fFlyingCow.BeginUpdate;
              fFlyingCow.Cleartextures;
              fFlyingCow.EndUpdate;
              fFlyingCow.DoSomeDrawing(10);
        end;
    end;

end;


procedure TNempCoverFlow.SetPreview(index, width, height: Integer;
  pixels: PByteArray);
begin
    case fMode of
        cm_Classic : ; // Nothing to do here.
        cm_OpenGL  : fFlyingCow.SetPreview(index, width, height, pixels);
    end;
end;

end.
