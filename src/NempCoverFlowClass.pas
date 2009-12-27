{

    Unit NempCoverFlowClass

    -  This is a Container-Class for different Types of Coverflows.
       The classicFlow and FlyingCow are that different, that a common
       ParentClass would not work
       Also I would like to switch at runtime between the two (or later more)
       modes


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
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit NempCoverFlowClass;

interface

uses Windows, Messages, SysUtils, Graphics, ExtCtrls, ContNrs, Classes,
    ClassicCoverFlowClass, unitFlyingCow, CoverHelper, dialogs;

type

    TCoverFlowMode = (cm_None, cm_Classic, cm_OpenGL);


    TNempCoverFlow = class
        private
            fClassicFlow: TClassicCoverFlow;
            fFlyingCow: TFlyingCow;
            fMode: TCoverFlowMode;

            fCoverList: TObjectList;

            fCurrentItem: Integer;  // Index of the current selected cover

            fCurrentCoverID: String;     // currently selected coverID
            // Note: I'm not using a NempCover-object here, to remember the idx, even
            //       if a Cover is deleted.

            fCaption: String; // caption for the current Cover
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

    end;

implementation

uses NempMainUnit;

{ TNempCoverFlow }

procedure TNempCoverFlow.fSetMode(aValue: TCoverFlowMode);
var i: integer;
begin
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
                fClassicFlow.MainImage := MainImage;
                fClassicFlow.ScrollImage := ScrollImage;
                fClassicFlow.CoverList := fCoverList;
                fClassicFlow.CoverSavePath := CoverSavePath;
            end;
            fClassicFlow.CurrentItem := fCurrentItem;
            Nemp_MainForm.IMGMedienBibCover.Visible := True;
            Nemp_MainForm.Lbl_CoverFlow.Visible     := True;
            Nemp_MainForm.ImgScrollCover.Visible    := True;
            FreeAndNil(fFlyingCow);
        end;

        cm_OpenGL  :
        begin
            fMode := aValue;
            if Not Assigned(fFlyingCow) then
            begin
                fFlyingCow := tFlyingCow.Create(window, events_Window);
                fFlyingCow.BeginUpdate;
                for i := 0 to fCoverList.Count - 1 do
                begin
                    fFlyingCow.Add(TFlyingCowItem.Create(TNempCover(fCoverList[i]).ID,
                                      TNempCover(fCoverList[i]).Artist,
                                      TNempCover(fCoverList[i]).Album));
                end;
                fFlyingCow.EndUpdate;
            end;
            fFlyingCow.CurrentItem := fCurrentItem;
            Nemp_MainForm.IMGMedienBibCover.Visible := False;
            Nemp_MainForm.Lbl_CoverFlow.Visible     := True;
            Nemp_MainForm.ImgScrollCover.Visible    := False;
            FreeAndNil(fClassicFlow);

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
        newItem := fCurrentItem;
    if newItem >= fCoverlist.Count then
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
end;

destructor TNempCoverFlow.Destroy;
begin
    Mode := cm_None; // This will also free the sub-coverflows
    inherited Destroy;
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

procedure TNempCoverFlow.SetPreview(index, width, height: Integer;
  pixels: PByteArray);
begin
    case fMode of
        cm_Classic : ; // Nothing to do here.
        cm_OpenGL  : fFlyingCow.SetPreview(index, width, height, pixels);
    end;
end;

end.
