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

uses Windows, Messages, SysUtils, Graphics, ExtCtrls, ContNrs, Classes, System.StrUtils,
    ClassicCoverFlowClass, unitFlyingCow, CoverHelper, dialogs, CoverDownloads,
    NempAudioFiles, LibraryOrganizer.Base, LibraryOrganizer.Files, LibraryOrganizer.Playlists;

type

    TCoverFlowMode = (cm_None, cm_Classic, cm_OpenGL);


    TNempCoverFlow = class
        private
            fClassicFlow: TClassicCoverFlow;
            fFlyingCow: TFlyingCow;
            fMode: TCoverFlowMode;

            fCoverCategory: TLibraryCategory;
            fCoverCount: Integer;

            fDownloadThread: TCoverDownloadWorkerThread;

            fCurrentItem: Integer;  // Index of the current selected cover

            fCurrentCoverID: String;     // currently selected coverID
            fCurrentCoverKey: String;
            // Note: I'm not using a NempCover-object here, to remember the idx, even
            //       if a Cover is deleted.

            function fGetCurrentItem: Integer;
            // SetCurrentItem: Set the current Item and draws cover and scrollcover
            procedure fSetCurrentItem(aValue: Integer);

            procedure fSetMode(aValue: TCoverFlowMode);

            function GetCollection(Index: Integer): TAudioCollection;


        public
            // needed for ClassicFlow
            MainImage: TImage;
            ScrollImage: TImage;

            Settings: TCoverFlowSettings;

            // Needed for FlyingCow
            window: HWND;
            events_window: HWND;

            property Mode: TCoverFlowMode read fMode write fSetMode;

            property CoverCount: Integer read fCoverCount;
            property CurrentItem: Integer read fGetCurrentItem write fSetCurrentItem;
            property CurrentCoverID: String read fCurrentCoverID write fCurrentCoverID;

            property Collection[Index: Integer]: TAudioCollection read GetCollection;

            property DownloadThread: TCoverDownloadWorkerThread read fDownloadThread write fDownloadThread;

            Constructor Create;
            Destructor Destroy; override;
            procedure Clear;

            Procedure LoadSettings;
            Procedure SaveSettings;
            procedure ApplySettings;

            procedure SetNewList(aCategory: TLibraryCategory; FallBackToZero: Boolean = False); Overload;

            // Clear Textures and force redrawing
            procedure ClearTextures;

            // Setpreview is only needed by FlyingCow.
            // In ClassicMode this will do nothing
            procedure SetPreview (index : Integer; width, height : Integer; pixels : PByteArray);

            procedure SetMainPickCoverPreview(width, height : Integer; pixels : PByteArray);

            // After a sorting of the Coverlist, the current selected cover should be selected
            // again. FindCurrentItemAgain finds it in the List and Set the CurrentItem properly
            procedure FindCurrentItemAgain(FallBackToZero: Boolean = False);

            function FindItemWithPrefix(aPrefix: UnicodeString; Startidx: Integer): Integer;

            function GetCollectionIndex(aCollection: TAudioCollection): Integer;

            // ReInitAfterSort: Used by ClassicMode.
            // FlyingCow doesnt need a sorted copy of the NempCoverList
            procedure ReInitAfterSort;

            procedure SelectItemAt(x, y: Integer);

            // Repaint
            // used by repaint/Onresize
            procedure Paint(i: Integer = 1);

            procedure SetNewHandle(aWnd: HWND);
            procedure SetColor(aColor: TColor);

            //procedure DownloadCover(aCover: TNempCover; aIdx: Integer); overload;
            //procedure DownloadCover(aCollection: TAudioCollection; aIdx: Integer; QuerySource: TQueryType); overload;
            //procedure DownloadPlayerCover(aAudioFile: TAudioFile);
            // procedure ClearCoverCache;

    end;

implementation

uses NempMainUnit, Nemp_ConstantsAndTypes, Nemp_RessourceStrings;

{ TNempCoverFlow }

procedure TNempCoverFlow.fSetMode(aValue: TCoverFlowMode);
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
                fClassicFlow := TClassicCoverFlow.Create(events_Window);
            end;
                fClassicFlow.MainImage := MainImage;
                fClassicFlow.ScrollImage := ScrollImage;
                fClassicFlow.CoverCategory := fCoverCategory;
                fClassicFlow.CoverCount := fCoverCount;

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
                fFlyingCow := tFlyingCow.Create(window, events_Window);

            fFlyingCow.BeginUpdate;
            fFlyingCow.AddItems(fCoverCount);
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

function TNempCoverFlow.FindItemWithPrefix(aPrefix: UnicodeString; Startidx: Integer): Integer;
var nextidx: Integer;
    aCollection: TAudioCollection;
    erfolg: Boolean;
begin
  nextIdx := Startidx;
  result := StartIdx;

  erfolg := False;
  repeat
    aCollection := Collection[nextIdx];
    if aCollection.MatchPrefix(aPrefix) then
    begin
      result := nextIdx;
      erfolg := True;
    end;
    nextIdx := (nextIdx + 1) Mod fCoverCount;
  until erfolg or (nextIdx = StartIdx);

end;


procedure TNempCoverFlow.FindCurrentItemAgain(FallBackToZero: Boolean = False);
var i, newItem: Integer;
begin
    newItem := -1;
    for i := 0 to fCoverCount - 1 do
        if Collection[i].key = fCurrentCoverKey then
        begin
            newItem := i;
            break;
        end;
    if newItem = -1 then
    begin
        // Change item, so there is a "change" notified by the main window. ;-)
        if FallBackToZero then
            newItem := 0
        else
        begin
            newItem := fCurrentItem; // - 1;  2019: change: Just show the "currentitem" again.
            if (newItem >= fCoverCount) or (newItem < 0) then
                newItem := 0;
        end;
    end;

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
  fCoverCount := 0;

    case fMode of
      cm_Classic : ;// fClassicFlow.CoverList := NIL;  // nothing more to do (?)
      cm_OpenGL  : fFlyingCow.Clear;
    end;
end;


constructor TNempCoverFlow.Create;
begin
  inherited;
  fClassicFlow := Nil;
  fFlyingCow := Nil;
  fMode := cm_None;
  fDownloadThread := Nil; // TCoverDownloadWorkerThread.Create;
end;

destructor TNempCoverFlow.Destroy;
begin
    //fDownloadThread.Terminate;
    //fDownloadThread.WaitFor;
    //fDownloadThread.Free;

    Mode := cm_None; // This will also free the sub-coverflows
    inherited Destroy;
end;

procedure TNempCoverFlow.SaveSettings;
begin
    NempSettingsManager.WriteInteger('CoverFlow', 'zMain'         , Settings.zMain            );
    NempSettingsManager.WriteInteger('CoverFlow', 'zLeft'         , Settings.zLeft            );
    NempSettingsManager.WriteInteger('CoverFlow', 'zRight'        , Settings.zRight           );

    NempSettingsManager.WriteInteger('CoverFlow', 'GapLeft'       , Settings.GapLeft          );
    NempSettingsManager.WriteInteger('CoverFlow', 'GapFirstLeft'  , Settings.GapFirstLeft     );
    NempSettingsManager.WriteInteger('CoverFlow', 'GapFirstRight' , Settings.GapFirstRight    );
    NempSettingsManager.WriteInteger('CoverFlow', 'GapRight'      , Settings.GapRight         );

    NempSettingsManager.WriteInteger('CoverFlow', 'AngleMain'     , Settings.AngleMain        );
    NempSettingsManager.WriteInteger('CoverFlow', 'AngleLeft'     , Settings.AngleLeft        );
    NempSettingsManager.WriteInteger('CoverFlow', 'AngleRight'    , Settings.AngleRight       );

    NempSettingsManager.WriteBool('CoverFlow', 'UseReflection'    , Settings.UseReflection  );
    NempSettingsManager.WriteInteger('CoverFlow', 'ReflexionBlendFaktor', Settings.ReflexionBlendFaktor  );
    NempSettingsManager.WriteInteger('CoverFlow', 'MaxTextures', Settings.MaxTextures  );
    NempSettingsManager.WriteInteger('CoverFlow', 'GapReflexion', Settings.GapReflexion  );
    NempSettingsManager.WriteInteger('CoverFlow', 'ViewPosX', Settings.ViewPosX);
    NempSettingsManager.WriteInteger('CoverFlow', 'ViewDirX', Settings.ViewDirX);
end;

procedure TNempCoverFlow.LoadSettings;
begin
    Settings.zMain         := NempSettingsManager.ReadInteger('CoverFlow', 'zMain'         , DefaultCoverFlowSettings.zMain       );
    Settings.zLeft         := NempSettingsManager.ReadInteger('CoverFlow', 'zLeft'         , DefaultCoverFlowSettings.zLeft       );
    Settings.zRight        := NempSettingsManager.ReadInteger('CoverFlow', 'zRight'        , DefaultCoverFlowSettings.zRight      );
    // Gap between two covers
    Settings.GapLeft       := NempSettingsManager.ReadInteger('CoverFlow', 'GapLeft'       , DefaultCoverFlowSettings.GapLeft     );
    Settings.GapFirstLeft  := NempSettingsManager.ReadInteger('CoverFlow', 'GapFirstLeft'  , DefaultCoverFlowSettings.GapFirstLeft);
    Settings.GapFirstRight := NempSettingsManager.ReadInteger('CoverFlow', 'GapFirstRight' , DefaultCoverFlowSettings.GapFirstRight);
    Settings.GapRight      := NempSettingsManager.ReadInteger('CoverFlow', 'GapRight'      , DefaultCoverFlowSettings.GapRight    );
    // Angles, -180 ... +180
    Settings.AngleMain     := NempSettingsManager.ReadInteger('CoverFlow', 'AngleMain'     , DefaultCoverFlowSettings.AngleMain   );
    Settings.AngleLeft     := NempSettingsManager.ReadInteger('CoverFlow', 'AngleLeft'     , DefaultCoverFlowSettings.AngleLeft   );
    Settings.AngleRight    := NempSettingsManager.ReadInteger('CoverFlow', 'AngleRight'    , DefaultCoverFlowSettings.AngleRight  );
    // Reflection
    Settings.UseReflection := NempSettingsManager.ReadBool('CoverFlow', 'UseReflection'    , DefaultCoverFlowSettings.UseReflection  );
    Settings.ReflexionBlendFaktor := NempSettingsManager.ReadInteger('CoverFlow', 'ReflexionBlendFaktor', DefaultCoverFlowSettings.ReflexionBlendFaktor  );
    Settings.MaxTextures := NempSettingsManager.ReadInteger('CoverFlow', 'MaxTextures', DefaultCoverFlowSettings.MaxTextures  );
    Settings.GapReflexion := NempSettingsManager.ReadInteger('CoverFlow', 'GapReflexion', DefaultCoverFlowSettings.GapReflexion  );

    Settings.ViewPosX := NempSettingsManager.ReadInteger('CoverFlow', 'ViewPosX', DefaultCoverFlowSettings.ViewPosX);
    Settings.ViewDirX := NempSettingsManager.ReadInteger('CoverFlow', 'ViewDirX', DefaultCoverFlowSettings.ViewDirX);
end;

procedure TNempCoverFlow.ApplySettings;
begin
  case fMode of
        cm_Classic : ; // nothing to do here
        cm_OpenGL  : begin
            fFlyingCow.ApplySettings(Settings);
        end;
    end;
end;
(*
procedure TNempCoverFlow.DownloadCover(aCover: TNempCover; aIdx: Integer);
begin
    if (aCover.Album <> 'Unknown compilation')
        and (not UnKownInformation(aCover.Artist))
        and (not UnKownInformation(aCover.Album))
    then
        fDownloadThread.AddJob(aCover, aIdx);
end;

procedure TNempCoverFlow.DownloadCover(aCollection: TAudioCollection;
  aIdx: Integer; QuerySource: TQueryType);
var
  afc: TAudioFileCollection;
begin
  if (aCollection is TAudioFileCollection) then begin
    afc := TAudioFileCollection(aCollection);
    if  (afc.CollectionType = ctAlbum)
        and (afc.Album <> CoverFlowText_VariousArtists)
        and (not UnKownInformation(afc.Artist))
        and (not UnKownInformation(afc.Album))
    then
      fDownloadThread.AddJob(afc, aIdx, QuerySource);
  end;
end;

procedure TNempCoverFlow.DownloadPlayerCover(aAudioFile: TAudioFile);
begin
    fDownloadThread.AddJob(aAudioFile, 0);
end;

procedure TNempCoverFlow.ClearCoverCache;
begin
    // this will set a flag to delete the list inside the context of the thread before downloading the next cover.
    if assigned(fDownloadThread) then
      fDownloadThread.ClearCacheList;
end;      *)

function TNempCoverFlow.GetCollection(Index: Integer): TAudioCollection;
begin
  if (Index < 0) or (Index >= fCoverCount) then begin
    result := Nil;
    exit;
  end;

  if Index = 0 then
    result := fCoverCategory.Collections[0]
  else
  begin
    // Index >= 1, and valid
    if fCoverCategory.CollectionCount = 1 then
      result := fCoverCategory.Collections[0].Collection[Index-1]
    else
      result := fCoverCategory.Collections[Index];
  end;
end;

function TNempCoverFlow.GetCollectionIndex(aCollection: TAudioCollection): Integer;
begin
  result := 0;
  if not assigned(aCollection) then
    exit;

  case aCollection.CollectionClass of
    ccFiles: begin
          if fCoverCategory.CollectionCount = 1 then
            result := 1 + fCoverCategory.Collections[0].IndexOf(aCollection)
          else
            result := 0; // invalid/empty
    end;
    ccPlaylists,
    ccWebStations: begin
      result := fCoverCategory.IndexOf(aCollection);
      if result = -1 then
        result := 0;
    end;
  end;

end;

function TNempCoverFlow.fGetCurrentItem: Integer;
begin
  result := fCurrentItem;
end;

procedure TNempCoverFlow.fSetCurrentItem(aValue: Integer);
begin
    //if (aValue >= 0) and (aValue <= fCoverList.Count-1) then
    begin
        if aValue < 0 then
            aValue := 0;
        if aValue > fCoverCount - 1 then
            aValue := fCoverCount - 1;

        case fMode of
            cm_Classic : fClassicFlow.CurrentItem := aValue;
            cm_OpenGL  : fFlyingCow.CurrentItem := aValue;
        end;
        if assigned(fDownloadThread) then
          fDownloadThread.MostImportantIndex := aValue;
        fCurrentitem := aValue;
        if (aValue >= 0) and (aValue <= fCoverCount - 1) then
        begin
            fCurrentCoverKey := Collection[aValue].Key;
            fCurrentCoverID := Collection[aValue].CoverID;
        end
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
                  // ?? 2020 Hier steckt u.U. eine unnötige Doppelung drin
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

procedure TNempCoverFlow.SetNewList(aCategory: TLibraryCategory; FallBackToZero: Boolean = False);

    function LCItemCount: Integer;
    begin
      case aCategory.CollectionCount of
        0: result := 0; // empty;
        1: begin
          // Files: [RootCollection] + [List of Albums]
          result := 1 + aCategory.Collections[0].CollectionCount;
        end
      else
        // Playlists: [Lists of Playlist]
        result := aCategory.CollectionCount;
      end;
    end;

begin
  fCoverCategory := aCategory;
  fCoverCount := LCItemCount;

  case fMode of
        cm_Classic : begin
          fClassicFlow.CoverCategory := aCategory;
          fClassicFlow.CoverCount := fCoverCount;
        end;
        cm_OpenGL  : begin
              fFlyingCow.BeginUpdate;
              fFlyingCow.AddItems(fCoverCount);
              fFlyingCow.EndUpdate;
              fFlyingCow.DoSomeDrawing(10);
        end;
    end;
    // FindCurrentItemAgain(FallBackToZero);
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

procedure TNempCoverFlow.SetMainPickCoverPreview(width, height : Integer; pixels : PByteArray);
begin
  case fMode of
    cm_Classic : ; // Nothing to do here.
    cm_OpenGL  : fFlyingCow.SetMainPickCoverPreview(width, height, pixels);
  end;
end;

end.
