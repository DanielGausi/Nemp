{

    Unit MainFormHelper

    - Some Helpers for MainUnit
      Written in separate Unit to shorten MainUnit a bit

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
unit MainFormHelper;

interface

uses Windows, Classes, Controls, StdCtrls, Forms, SysUtils, ContNrs, VirtualTrees,
    AudioFileClass, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, dialogs;


// passt die VCL an die Player-Werte an
    procedure CorrectEQButton(band: Integer);
    procedure CorrectHallButton;
    procedure CorrectEchoButtons;
    procedure CorrectSpeedButton;
    procedure CorrectVolButton;
    // Berechnet aus den VCL-Werten die Player-Werte
    function VCLEQToPlayer(idx: Integer): Single;
    function APIEQToPlayer(Value: Integer): Single;
    function VCLHallToPlayer: Single;
    function VCLSpeedToPlayer: Single;
    function VCLVolToPlayer: Integer;
    function VCLEchoMixToPlayer: Single;
    function VCLEchoTimeToPlayer: Single;

    procedure HandleNewConnectedDrive;

    procedure FillTreeView(MP3Liste: TObjectlist; AudioFile:TAudioFile);

    // Fills the TreeView with 2 Lists (used for Quicksearch)
    procedure FillTreeViewQuickSearch(List1, List2: TObjectList; Dummy: TAudioFile);

    procedure FillTreeViewQueryTooShort(Dummy: TAudioFile);

    // Fills the TreeView with 2 Lists and re-select previous selected one
    procedure FillTreeViewQuickSearchReselect(List1, List2: TObjectList; Dummy: TAudioFile; oldFile: TAudioFile);

    function GetObjectAt(form: TForm; x,y: integer): TControl;
    function ObjectIsPlaylist(aName:string): Boolean;

    // Blockiert GUI-Elemente, die ein Hinzufügen/Löschen von Elementen in der Medienbib verursachen
    procedure BlockeMedienListeUpdate(block: Boolean);
    // Blockiert Schreibzugriffe auf die Medienliste
    procedure BlockeMedienListeWriteAcces(block: Boolean);
    //blockiert auch Lese-Zugriff auf die Medienliste
    procedure BlockeMedienListeReadAccess(block: Boolean);


    procedure StarteLangeAktion(max:integer;text:String; EnableStopButton: Boolean);
    procedure BeendeLangeAktion;

    procedure SetTabStopsPlayer;
    procedure SetTabStopsTabs;

    procedure ReArrangeToolImages;

    // Switch MediaLibrary: Umschalten zwischen Listen/Coverflow/Tagwolke
    procedure SwitchMediaLibrary(NewMode: Integer);
    // SwitchBrowsePanel: entsprechendes Anzeigen der Liste
    procedure SwitchBrowsePanel(NewMode: Integer);

    procedure BackupComboboxes;
    procedure RestoreComboboxes;
    procedure ReTranslateNemp(LanguageCode: String);

    procedure ClearShortCuts;
    procedure SetShortCuts;

    // Select all files with the same path as MedienBib.CurrentAudioFile
    function GetListOfAudioFileCopies(Original: TAudioFile; Target:TObjectList): Boolean;
    procedure CorrectVCLAfterAudioFileEdit(aFile: TAudioFile);

    procedure SetBrowseTabWarning(ShowWarning: Boolean);
    procedure SetBrowseTabCloudWarning(ShowWarning: Boolean);

    procedure CheckAndDoCoverDownloaderQuery;

    procedure HandleStopAfterTitleClick;
    procedure HandleStopNowClick;

    procedure VSTSelectionToAudiofileList(aTree: TVirtualStringTree; aSelection: TNodeArray; Target: TObjectList);


implementation

uses NempMainUnit, Splash, BibSearch, TreeHelper,  GnuGetText,
    PlayListUnit, AuswahlUnit, MedienListeUnit, Details, HeadsetControl,
    MultimediaKeys, NewPicture, NewStation, OptionsComplete, RandomPlaylist,
    Shutdown, ShutDownEdit, StreamVerwaltung, BirthdayShow, fspTaskbarMgr,
    spectrum_vis, PlayerClass, PartymodePassword;

procedure CorrectVolButton;
begin
    with Nemp_MainForm do
      VolButton.Top := Round((100-NempPlayer.Volume)/ (100/VolShape.Height) {3.125}) + (VolShape.Top - (VolButton.Height Div 2));
end;
function VCLVolToPlayer: Integer;
begin
    with Nemp_MainForm do
        result := Round(100-((VolButton.Top - VolShape.Top + (VolButton.Height Div 2))* (100/VolShape.Height){3.125}));
end;


procedure CorrectEQButton(band: Integer);
begin
    with Nemp_MainForm do
    begin
        // Valid values:  EQ_NEW_MAX ... - EQ_NEW_MAX (i.e. 10 ... - 10)
        // Bass allows values in 15 .. -15, but this sounds often bad.
        // So we have to map EQ_NEW_MAX ... - EQ_NEW_MAX into
        //               Shape.Top ...  Shape.Top + Shape.Height - Button.Height
        EqualizerButtons[band].Top := EqualizerShape1.Top  +
            Round((EQ_NEW_MAX - NempPlayer.fxgain[band])
                  * (EqualizerShape1.Height - EqualizerButtons[band].Height)
                  / (2*EQ_NEW_MAX));
        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
    end;
end;
function VCLEQToPlayer(idx: Integer): Single;
begin
    // We have to map Shape.Top ...  Shape.Top + Shape.Height - Button.Height
    //           into EQ_NEW_MAX ... -EQ_NEW_MAX
    with Nemp_MainForm do
        result := EQ_NEW_MAX -
          ((EqualizerButtons[idx].Top - EqualizerShape1.Top)
          * (2*EQ_NEW_MAX)
          / ((EqualizerShape1.Height - EqualizerButtons[idx].Height)));
end;
function APIEQToPlayer(Value: Integer): Single;
begin
    result := EQ_NEW_MAX - ( Value / EQ_NEW_FACTOR );
end;


procedure CorrectHallButton;
begin
    with Nemp_MainForm do
    begin
        HallButton.Left := HallShape.Left +
            Round(sqr((NempPlayer.ReverbMix + 96)
              * sqrt(HallShape.Width - HallButton.Width)
              / 96));
        HallLBL.Caption := Inttostr(Round(NempPlayer.ReverbMix)) + 'dB';
    end;
end;
function VCLHallToPlayer: Single;
begin
  with Nemp_MainForm do
      result := 96/sqrt(HallShape.Width - HallButton.Width) * sqrt(HallButton.Left - HallShape.Left) - 96;
end;


procedure CorrectEchoButtons;
begin
    with Nemp_MainForm do
    begin
        EchoWetDryMixButton.Left := EchoWetDryMixShape.Left +
            Round(NempPlayer.EchoWetDryMix
              * (EchoWetDryMixShape.Width - EchoWetDryMixButton.Width)
              / 50);
        EchoTimeButton.Left := EchoWetDryMixShape.Left
            + Round((NempPlayer.EchoTime - 100)
              * (EchoTimeShape.Width - EchoTimeButton.Width)
              / 1900);
        EchoMixLBL.Caption := Inttostr(Round(NempPlayer.EchoWetDryMix)) + '%';
        EchoTimeLBL.Caption := Inttostr(Round(NempPlayer.EchoTime)) + 'ms';
    end;
end;
function VCLEchoMixToPlayer: Single;
begin
    with Nemp_MainForm do
        result := (EchoWetDryMixButton.Left - EchoWetDryMixShape.Left)
          * 50
          / (EchoWetDryMixShape.Width - EchoWetDryMixButton.Width);
end;
function VCLEchoTimeToPlayer: Single;
begin
    with Nemp_MainForm do
      result := (EchoTimeButton.Left - EchoWetDryMixShape.Left)
          * 1900
          / (EchoTimeShape.Width - EchoTimeButton.Width)
      + 100;
end;



procedure CorrectSpeedButton;
var middle, whole: Integer;
begin
    with Nemp_MainForm do
    begin
        middle := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
        whole := sqr(middle - SampleRateShape.Left);

        if NempPlayer.Speed > 1 then
          SampleRateButton.Left := middle + Round(sqrt((NempPlayer.Speed - 1) / 2 * whole))
        else
          SampleRateButton.Left := middle - Round(sqrt((1 - NempPlayer.Speed) * 3/2 * whole));
        SampleRateLBL.Caption := inttostr(Round(NempPlayer.Speed * 100)) + '%';
    end;
end;
function VCLSpeedToPlayer: Single;
var middle, whole: Integer;
begin
  with Nemp_MainForm do
  begin
      middle := (SampleRateShape.Width DIV 2) - (SampleRateButton.Width Div 2) + SampleRateShape.Left;
      whole := sqr(middle - SampleRateShape.Left);

      if SampleRateButton.Left < middle then
        result := sqr(SampleRateButton.Left - middle) * 0.66 / (-whole) + 1
      else
        result := sqr(SampleRateButton.Left - middle) * 2 / whole + 1;
  end;
end;




// TODO: Event bei "neues Drive angeschlossen"
procedure HandleNewConnectedDrive;
var i: Integer;
begin

  with Nemp_MainForm do
    if MedienBib.StatusBibUpdate <> 0 then
    begin
        inc(NewDrivesNotificationCount);
    end else
    begin
        // Starte Check
        NewDrivesNotificationCount := 0;
        if MedienBib.ReSynchronizeDrives then
        begin
              // uhoh...es gab eine Änderung. Also:
              // Mehr Arbeit nötig - alle Dateien ändern
              // die nötigen Infos stecken in der UsedDrive-Liste der Bib drin
              StarteLangeAktion(-1,'', True);
              Nemp_MainForm.Enabled := False;
              If Not assigned(FSplash) then
                  Application.CreateForm(TFSplash, FSplash);
              FSplash.StatusLBL.Caption := (SplashScreen_NewDriveConnected);
              FSplash.Show;
              SetWindowPos(FSplash.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
              FSplash.Update;

              // Dateien reparieren
              MedienBib.RepairDriveCharsAtAudioFiles;
              MedienBib.RepairDriveCharsAtPlaylistFiles;

              FSplash.StatusLBL.Caption := (SplashScreen_NewDriveConnected2);
              FSplash.Update;

              // Anzeige aktualisieren
              case MedienBib.BrowseMode of
                  0 : MedienBib.ReBuildBrowseLists;

                  1: begin
                      MedienBib.ReBuildCoverList;
                      If MedienBib.Coverlist.Count > 3 then
                        CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                      else
                        CoverScrollbar.Max := 3;
                      CoverScrollbarChange(Nil);
                  end;

              end;
              BeendeLangeAktion;
              FSplash.Close;
              //FreeAndNil(FSplash);

              Nemp_MainForm.Enabled := True;
              Nemp_MainForm.SetFocus;
        end;

        if MedienBib.AutoScanDirs then
        begin
              ST_Medienliste.Mask := GenerateMedienBibSTFilter;
              for i := MedienBib.AutoScanToDoList.Count - 1 downto 0 do
              begin
                  if DirectoryExists(MedienBib.AutoScanToDoList[i]) then
                  begin
                      MedienBib.ST_Ordnerlist.Add(MedienBib.AutoScanToDoList[i]);
                      MedienBib.AutoScanToDoList.Delete(i);
                  end;
              end;
              if MedienBib.ST_Ordnerlist.Count > 0 then
              begin
                  MedienBib.StatusBibUpdate := 1;
                  BlockeMedienListeUpdate(True);
                  ST_Medienliste.SearchFiles(MedienBib.ST_Ordnerlist[0]);
              end;
        end;
    end;
end;


// Diese Prozedur soll aufgerufen werden, wenn die Liste nach einem
// Sortieren neu gefüllt wurde. Es existiert ein Node mit Data=AudioFile!!!
procedure FillTreeView(MP3Liste: TObjectlist; AudioFile:TAudioFile);
var i: integer;
  NewNode:PVirtualNode;
  Data:PTreeData;
  tmpAudioFile: TAudioFile;
begin
    with Nemp_MainForm do
    begin
        VST.BeginUpdate;
        VST.Clear;

        if (Not MedienBib.AnzeigeListIsCurrentlySorted) then
            VST.Header.SortColumn := -1
        else
            VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);

        for i:=0 to MP3Liste.Count-1 do
        begin
          AddVSTMp3(VST,Nil,TAudioFile(MP3Liste.Items[i]));
        end;
        VST.EndUpdate;

        // Knoten mit AudioFile suchen und focussieren
        NewNode := VST.GetFirst;
        if assigned(Newnode) then
        begin
          Data := VST.GetNodeData(NewNode);
          tmpAudioFile := Data^.FAudioFile;
          if tmpAudioFile <> AudioFile then
          repeat
            NewNode := VST.GetNext(NewNode);
            if assigned(NewNode) then
            begin
                Data := VST.GetNodeData(NewNode);
                tmpAudioFile := Data^.FAudioFile;
            end;
          until (tmpAudioFile = AudioFile) OR (NewNode=NIL);

          // Ok, we didn't found our AudioFile.
          // get the first one in the list.
          if not assigned(NewNode) then
          begin
              NewNode := VST.GetFirst;
              // and get the corresponding AudioFile again
              if assigned(NewNode) then
              begin
                  Data := VST.GetNodeData(NewNode);
                  tmpAudioFile := Data^.FAudioFile;
              end;
          end;

          if assigned(Newnode) then // Nur zur Sicherheit!
          begin
            VST.Selected[NewNode] := True;
            VST.FocusedNode := NewNode;
            AktualisiereDetailForm(tmpAudioFile, SD_MEDIENBIB);
            ShowVSTDetails(tmpAudioFile);
          end else
            AktualisiereDetailForm(NIL, SD_MEDIENBIB);
        end
        else
            AktualisiereDetailForm(NIL, SD_MEDIENBIB);
    end;
end;

procedure FillTreeViewQuickSearch(List1, List2: TObjectList; Dummy: TAudioFile);
var i: integer;
begin
    with Nemp_MainForm do
    begin
        VST.BeginUpdate;
        VST.Clear;
        for i:=0 to List1.Count-1 do
            AddVSTMp3(VST,Nil,TAudioFile(List1.Items[i]));

        if ((List1.Count > 0) and (List2.Count > 0))
            or ((List1.Count = 0) and (List2.Count = 0))
        then
            AddVSTMp3(VST, NIL, Dummy);

        for i:=0 to List2.Count-1 do
            AddVSTMp3(VST,Nil,TAudioFile(List2.Items[i]));

        VST.EndUpdate;
        AktualisiereDetailForm(NIL, SD_MEDIENBIB);
    end;
end;

procedure FillTreeViewQueryTooShort(Dummy: TAudioFile);
begin
    with Nemp_MainForm do
    begin
        VST.BeginUpdate;
        VST.Clear;

        AddVSTMp3(VST, NIL, Dummy);

        VST.EndUpdate;
        AktualisiereDetailForm(NIL, SD_MEDIENBIB);
    end;
end;

procedure FillTreeViewQuickSearchReselect(List1, List2: TObjectList; Dummy: TAudioFile; oldFile: TAudioFile);
var NewNode:PVirtualNode;
  Data:PTreeData;
  tmpAudioFile: TAudioFile;
begin
    FillTreeViewQuickSearch(List1, List2, Dummy);
    with Nemp_MainForm do
    begin
        if oldFile = Nil then exit;

        // Knoten mit AudioFile suchen und focussieren
        NewNode := VST.GetFirst;
        if assigned(Newnode) then
        begin
          Data := VST.GetNodeData(NewNode);
          tmpAudioFile := Data^.FAudioFile;
          if tmpAudioFile <> oldFile then
          repeat
            NewNode := VST.GetNext(NewNode);
            Data := VST.GetNodeData(NewNode);
            tmpAudioFile := Data^.FAudioFile;
          until (tmpAudioFile = oldFile) OR (NewNode=NIL);

          if assigned(Newnode) then // Nur zur Sicherheit!
          begin
            VST.Selected[NewNode] := True;
            VST.FocusedNode := NewNode;
            ShowVSTDetails(tmpAudioFile);
            AktualisiereDetailForm(tmpAudioFile, SD_MEDIENBIB);
          end
          else
              AktualisiereDetailForm(NIL, SD_MEDIENBIB);
        end
        else
            AktualisiereDetailForm(NIL, SD_MEDIENBIB);
    end;
end;


function GetObjectAt(form: TForm; x,y: integer): TControl;
var
 i: integer;
begin
 result := nil;
 for i := 0 to form.ComponentCount-1 do
  if form.Components[i] is TControl then        // is TControl
   with TControl(form.Components[i]) do
    if PtInRect(
        Rect(ClientToScreen(clientrect.TopLeft), ClientToScreen(clientrect.BottomRight)),
        point(x,y)) then
              result := TControl(form.Components[i]);
end;

function ObjectIsPlaylist(aName:string): Boolean;
begin
  result := (aName = 'PlaylistVST_IMG') OR (aName = 'PlaylistVST');
end;


procedure BlockeMedienListeUpdate(block: Boolean);
begin
    with Nemp_MainForm do
    begin
        block := not block;
        // Einträge im Hauptmenü
        MM_ML_SearchDirectory.Enabled   := block;
        MM_ML_Delete.Enabled         := block;
        MM_ML_Load.Enabled   := block;
        MM_ML_Save.Enabled := block;
        MM_ML_DeleteMissingFiles.Enabled := block;
        MM_ML_DeleteSelectedFiles.Enabled := block;
        MM_ML_RefreshAll.Enabled := block;
        MM_ML_ResetRatings.Enabled := block;
        // Einträge im Popup-Menü der Medienliste
        PM_ML_MedialibraryDeleteNotExisting.Enabled := block;
        PM_ML_MedialibraryRefresh.Enabled := block;
        PM_ML_ResetRatings.Enabled := block;
        PM_ML_MedialibrarySave.Enabled := block;
        PM_ML_MedialibraryLoad.Enabled := block;
        PM_ML_MedialibraryDelete.Enabled := block;
        PM_ML_SearchDirectory.Enabled := block;
        PM_ML_RefreshSelected.Enabled := block;
        PM_ML_DeleteSelected.Enabled := block;
        PM_ML_PasteFromClipboard.Enabled := block;
    end;
end;

procedure BlockeMedienListeWriteAcces(block: Boolean);
begin
    with Nemp_MainForm do
    begin
        if block then
          BlockeMedienListeUpdate(block);
        block := not block;
        //Sortierauswahl-Menüeinträge
        MM_ML_BrowseBy.Enabled := block;
        PM_ML_BrowseBy.Enabled := block;
    end;
end;

procedure BlockeMedienListeReadAccess(block: Boolean);
begin
    with Nemp_MainForm do
    begin
        if block then
          BlockeMedienListeWriteAcces(block);
        block := not block;
        //Browse-Listen disablen;
        ArtistsVST.Enabled := block;
        AlbenVST.Enabled   := block;

        PanelCoverBrowse.Enabled := Block;

        // Panel Suche//Auswahl disablen
          TabBtn_CoverFlow.Enabled := block;
          TabBtn_Browse.Enabled := block;
          TabBtn_TagCloud.Enabled := block;

          if assigned(FormBibSearch) then
              FormBibSearch.EnableControls(False);
    end;
end;

procedure StarteLangeAktion(max:integer;text:String; EnableStopButton: Boolean);
begin
    with Nemp_MainForm do
    begin
        ReadyForGetFileApiCommands := False;

        MedienListeStatusLBL.Caption := Text;
        MedienListeStatusLBL.Update;
        LangeAktionWeitermachen := True;
        AllowClose := False;

        // Panel Suche//Auswahl disablen
        TabBtn_CoverFlow.Enabled := False;
        TabBtn_Browse.Enabled := False;
        TabBtn_TagCloud.Enabled := False;

        //Gefährliche MainMenüeinträge disablen
        MM_Medialibrary.Enabled := False;
        MM_PL_ExtendedAddToMedialibrary.Enabled := False;
        MM_PL_Directory.Enabled := False;
        MM_ML_Delete.Enabled:=False;
        MM_ML_Load.Enabled:=False;
        MM_ML_Save.Enabled:=False;
        MM_ML_SortBy.Enabled:=False;
        //SuchenMAINMENU.Enabled:=False;

        // Gefährliche PopupMenüeinträge disablen
        PM_ML_SortBy.Enabled:=False;
        PM_ML_RefreshSelected.Enabled:=False;
        PM_ML_HideSelected.Enabled:=False;
        PM_ML_DeleteSelected.Enabled:=False;
        PM_ML_Extended.Enabled := False;
        //Dateienhinzufgen2.Enabled := False;
        PM_PL_AddDirectories.Enabled := False;
        PM_PL_ExtendedAddToMedialibrary.Enabled := False;
        PM_PL_ExtendedCopyFromWinamp.Enabled := False;
        //Dateienhinzufgen3.Enabled := False;


        PM_ML_Medialibrary.Enabled := False;
        PM_ML_SearchDirectory.Enabled := False;

        // SuchDinger disablen
        if assigned(FormBibSearch) then
            FormBibSearch.EnableControls(False);
        // Browse-Listen Disablen
        ArtistsVST.Enabled := False;
        AlbenVST.Enabled := False;

        VST.OnHeaderClick:=NIL;
    end;
end;

procedure BeendeLangeAktion;
begin
    with Nemp_MainForm do
    begin
        ShowSummary;
        MM_ML_SortBy.Enabled:=True;
        PM_ML_SortBy.Enabled:=True;
        LangeAktionWeitermachen := False; // Suche fertig
        AllowClose:= True;

        // Panel Suche//Auswahl enablen
        TabBtn_CoverFlow.Enabled := True;
        TabBtn_Browse.Enabled := True;
        TabBtn_TagCloud.Enabled := True;

        //Gefährliche MainMenüeinträge enablen
        MM_Medialibrary.Enabled := True;
        MM_PL_ExtendedAddToMedialibrary.Enabled := True;
        MM_PL_Directory.Enabled := True;

        //OptionenMAINMENU.Enabled := True;
        //AboutMAINMENU.Enabled := True;
        MM_ML_Delete.Enabled:=True;
        MM_ML_Load.Enabled:=True;
        MM_ML_Save.Enabled:=True;
        MM_ML_SortBy.Enabled:=True;
        //SuchenMAINMENU.Enabled:=True;

        // Gefährliche PopupMenüeinträge enablen
        PM_ML_SortBy.Enabled:=True;
        PM_ML_RefreshSelected.Enabled:=True;
        PM_ML_HideSelected.Enabled:=True;
        PM_ML_DeleteSelected.Enabled:=True;
        PM_ML_Extended.Enabled := True;
        //Dateienhinzufgen2.Enabled := True;
        PM_PL_AddDirectories.Enabled := True;
        PM_PL_ExtendedAddToMedialibrary.Enabled := True;
        PM_PL_ExtendedCopyFromWinamp.Enabled := True;
        PM_ML_Medialibrary.Enabled := True;
        PM_ML_SearchDirectory.Enabled := True;
        //Dateienhinzufgen3.Enabled := True;

        // SuchDinger enablen
        if assigned(FormBibSearch) then
            FormBibSearch.EnableControls(True);

        // Browse-Listen Enablen
        ArtistsVST.Enabled := True;
        AlbenVST.Enabled := True;

        VST.OnHeaderClick:=VSTHeaderClick;
        ReadyForGetFileApiCommands := True;

        fspTaskbarManager.ProgressState := fstpsNoProgress;
    end;
end;


procedure SetTabStopsPlayer;
begin
    with Nemp_MainForm do
    begin
        VolButton           .TabStop := NempOptions.TabStopAtPlayerControls;
        SlideBarButton      .TabStop := NempOptions.TabStopAtPlayerControls;
        SlideBackBTN        .TabStop := NempOptions.TabStopAtPlayerControls;
        PlayPrevBTN         .TabStop := NempOptions.TabStopAtPlayerControls;
        PlayPauseBTN        .TabStop := NempOptions.TabStopAtPlayerControls;
        StopBTN             .TabStop := NempOptions.TabStopAtPlayerControls;
        RecordBtn           .TabStop := NempOptions.TabStopAtPlayerControls;
        PlayNextBTN         .TabStop := NempOptions.TabStopAtPlayerControls;
        SlideForwardBTN     .TabStop := NempOptions.TabStopAtPlayerControls;
        RandomBtn           .TabStop := NempOptions.TabStopAtPlayerControls;
        //
        HallButton          .TabStop := NempOptions.TabStopAtPlayerControls;
        EchoWetDryMixButton .TabStop := NempOptions.TabStopAtPlayerControls;
        EchoTimeButton      .TabStop := NempOptions.TabStopAtPlayerControls;
        SampleRateButton    .TabStop := NempOptions.TabStopAtPlayerControls;
        DirectionPositionBTN.TabStop := NempOptions.TabStopAtPlayerControls;
        //PosRewindCB         .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton1    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton2    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton3    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton4    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton5    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton6    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton7    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton8    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton9    .TabStop := NempOptions.TabStopAtPlayerControls;
        EqualizerButton10   .TabStop := NempOptions.TabStopAtPlayerControls;
    end;
end;

procedure SetTabStopsTabs;
begin
    with Nemp_MainForm do
    begin
        TabBtn_Browse   .TabStop := NempOptions.TabStopAtTabs;
        TabBtn_CoverFlow.TabStop := NempOptions.TabStopAtTabs;
        TabBtn_TagCloud .TabStop := NempOptions.TabStopAtTabs;
        TabBtn_Cover    .TabStop := NempOptions.TabStopAtTabs;
        TabBtn_Lyrics   .TabStop := NempOptions.TabStopAtTabs;
        TabBtn_Equalizer.TabStop := NempOptions.TabStopAtTabs;
        TabBtn_Effects  .TabStop := NempOptions.TabStopAtTabs;
    end;
end;

procedure ReArrangeToolImages;
var currentLeft: Integer;
    decvalue: Integer;
    newtop: Integer;
begin

    with Nemp_MainForm do
    begin
        decvalue := ScrobblerImage.Width + 2;
        currentLeft := RatingImage.Left;

        newTop := RatingImage.Top + RatingImage.Height + 2;//TextAnzeigeIMAGE.Top + TextAnzeigeIMAGE.Height + 16;

        if NempPlayer.NempScrobbler.DoScrobble then
        begin
            ScrobblerImage.Top := newTop;
            ScrobblerImage.Left := currentLeft;
            ScrobblerImage.Visible := True;
            inc(currentLeft, decvalue);
        end else
            ScrobblerImage.Visible := False;

        If assigned(NempWebserver) and NempWebserver.Active then
        begin
            WebserverImage.Top := newTop;
            WebserverImage.Left := currentLeft;
            WebserverImage.Visible := True;
            inc(currentLeft, decvalue);
        end else
            WebserverImage.Visible := False;

        if BirthdayTimer.Enabled then
        begin
            BirthdayImage.Top := newTop;
            BirthdayImage.Left := currentLeft;
            BirthdayImage.Visible := True;
            inc(currentLeft, decvalue);
        end else
            BirthdayImage.Visible := False;

        if (SleepTimer.Enabled) or (NempOptions.ShutDownAtEndOfPlaylist) then
        begin
            SleepImage.Top := newTop;
            SleepImage.Left := currentLeft;
            SleepImage.Visible := True;
            //dec(currentLeft, 18);
        end else
            SleepImage.Visible := False;
    end;
end;


procedure SwitchMediaLibrary(NewMode: Integer);
begin
    with Nemp_MainForm do
    begin
        // Bib umschalten.
        StarteLangeAktion(-1,'', True);
        Nemp_MainForm.Enabled := False;
        If Not assigned(FSplash) then
            Application.CreateForm(TFSplash, FSplash);
        FSplash.StatusLBL.Caption := (SplashScreen_PleasewaitaMoment);
        FSplash.Show;
        SetWindowPos(FSplash.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
        FSplash.Update;

        MedienBib.BrowseMode := NewMode;
        case NewMode of
            0: begin
                MedienBib.ReBuildBrowseLists;
            end;
            1: begin
                MedienBib.CurrentArtist := BROWSE_ALL;
                MedienBib.CurrentAlbum := BROWSE_ALL;
                MedienBib.ReBuildCoverList;

                MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);

                If MedienBib.Coverlist.Count > 3 then
                    CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                else
                    CoverScrollbar.Max := 3;
                CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
            end;
            2: begin
                // 1. Backup Breadcrumbs (current navigation)
                MedienBib.TagCloud.BackUpNavigation;
                // 2. Rebuild TagCloud
                MedienBib.ReBuildTagCloud;
                // 3. Restore BreadCrumbs
                MedienBib.RestoreTagCloudNavigation;
                // 4. Show Files for the current Tag
                MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.FocussedTag, False);
            end;
        end;

        PanelStandardBrowse.Visible := NewMode = 0;
        PanelCoverBrowse.Visible    := NewMode = 1;
        PanelTagCloudBrowse.Visible := NewMode = 2;

        BeendeLangeAktion;
        FSplash.Close;
        Nemp_MainForm.Enabled := True;
        Nemp_MainForm.SetFocus;
    end;
end;

procedure SwitchBrowsePanel(NewMode: Integer);
begin
    with Nemp_MainForm do
    begin
        case Newmode of
            0: begin
                // Zeige Browse-Listen
                PanelCoverBrowse.visible := False;
                PanelStandardBrowse.Visible := True;
                PanelTagCloudBrowse.Visible := False;

                PanelStandardBrowse.Left := 4;
                PanelStandardBrowse.Width := AuswahlPanel.Width - 8;
                PanelStandardBrowse.Top := 4;
                PanelStandardBrowse.Height := GRPBOXArtistsAlben.Height - 8;
                PanelStandardBrowse.Anchors := [akleft, aktop, akright, akBottom];

                // TabButtons-Glyphs neu setzen
                TabBtn_Browse.GlyphLine := 1;
                TabBtn_CoverFlow.GlyphLine := 0;
                TabBtn_TagCloud.GlyphLine := 0;
                TabBtn_Browse.Refresh;
                TabBtn_CoverFlow.Refresh;
                TabBtn_CoverFlow.Refresh;
            end;
            1: begin
                // Zeige CoverFlow
                PanelStandardBrowse.Visible := False;
                PanelTagCloudBrowse.Visible := False;
                PanelCoverBrowse.Visible := True;

                PanelCoverBrowse.Left := 4;
                PanelCoverBrowse.Width := AuswahlPanel.Width - 8;
                PanelCoverBrowse.Top := 4;
                PanelCoverBrowse.Height := GRPBOXArtistsAlben.Height - 8;
                PanelCoverBrowse.Anchors := [akleft, aktop, akright, akBottom];

                // TabButtons-Glyphs neu setzen
                TabBtn_Browse.GlyphLine := 0;
                TabBtn_CoverFlow.GlyphLine := 1;
                TabBtn_TagCloud.GlyphLine := 0;
                TabBtn_Browse.Refresh;
                TabBtn_CoverFlow.Refresh;
                TabBtn_CoverFlow.Refresh;
            end;
            2: begin
                // Hier Code für Tagwolke einfügen
                // Zeige CoverFlow
                PanelStandardBrowse.Visible := False;
                PanelTagCloudBrowse.Visible := True;
                PanelCoverBrowse.Visible := False;

                PanelTagCloudBrowse.Left := 4;
                PanelTagCloudBrowse.Width := AuswahlPanel.Width - 8;
                PanelTagCloudBrowse.Top := 4;
                PanelTagCloudBrowse.Height := GRPBOXArtistsAlben.Height - 8;
                PanelTagCloudBrowse.Anchors := [akleft, aktop, akright, akBottom];

                // TabButtons-Glyphs neu setzen
                TabBtn_Browse.GlyphLine := 0;
                TabBtn_CoverFlow.GlyphLine := 0;
                TabBtn_TagCloud.GlyphLine := 1;
                TabBtn_Browse.Refresh;
                TabBtn_CoverFlow.Refresh;
                TabBtn_CoverFlow.Refresh;

            end;
        end;
    end;
end;

procedure BackupComboboxes;
var i: Integer;
begin
    with Nemp_MainForm do
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        Components[i].Tag := (Components[i] as TComboBox).ItemIndex;
end;

procedure RestoreComboboxes;
var i: Integer;
begin
  with Nemp_MainForm do
  begin
    for i := 0 to ComponentCount - 1 do
      if (Components[i] is TComboBox) then
        (Components[i] as TComboBox).ItemIndex := Components[i].Tag;

    // We need this tag for Editing purposes!
    EdtBibGenre.Tag := 5;
  end;

end;

procedure ReTranslateNemp(LanguageCode: String);
var i, c: Integer;
begin
    with Nemp_MainForm do
    begin
        Uselanguage(LanguageCode);

        BackupComboboxes;
        ReTranslateComponent (Nemp_MainForm);
        NempPlayer.RefreshPlayingTitel;

        // refresh Hints und sonstige Anzeigen
        case NempPlaylist.WiedergabeMode of
            0: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatAll);
            1: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatTitle);
            2: RandomBtn.Hint := (MainForm_RepeatBtnHint_RandomMode);
            else
               RandomBtn.Hint := (MainForm_RepeatBtnHint_NoRepeat);
        end;

        if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
            StopBTN.Hint    := MainForm_StopBtn_NormalHint
        else
            StopBTN.Hint    := MainForm_StopBtn_StopAfterTitleHint;

        if NempPlayer.StreamRecording then
            RecordBtn.Hint := (MainForm_RecordBtnHint_Recording)
        else
            RecordBtn.Hint := (MainForm_RecordBtnHint_Start);

        if NempPlayer.MainStreamIsReverseStream then
            DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayNormal)
        else
            DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayReverse);

        if SleepTimer.Enabled then SleepTimerTimer(Nil);
        if BirthdayTimer.Enabled then BirthdayTimerTimer(Nil);


        RestoreComboboxes;

        ReTranslateComponent (PlaylistForm    );
        ReTranslateComponent (AuswahlForm     );
        ReTranslateComponent (MedienlisteForm );

        if assigned(FDetails             ) then ReTranslateComponent(FDetails            );
        if assigned(FNewPicture          ) then ReTranslateComponent(FNewPicture         );
        if assigned(FSplash              ) then ReTranslateComponent(FSplash             );
        if assigned(FormMediaKeyInit     ) then ReTranslateComponent(FormMediaKeyInit    );
        if assigned(PasswordDlg          ) then ReTranslateComponent(PasswordDlg         );

        //if assigned(AboutForm            ) then ReTranslateComponent(AboutForm           );
        if assigned(OptionsCompleteForm  ) then
        begin
           OptionsCompleteForm.BackUpComboBoxes;
           ReTranslateComponent(OptionsCompleteForm );
           OptionsCompleteForm.OptionsVST.Invalidate;
           OptionsCompleteForm.RestoreComboboxes;
        end;
        if assigned(FormStreamVerwaltung ) then
        begin
            FormStreamVerwaltung.BackUpComboBoxes;
            ReTranslateComponent(FormStreamVerwaltung);
            FormStreamVerwaltung.RestoreComboboxes;
        end;
        if assigned(ShutDownForm         ) then ReTranslateComponent(ShutDownForm        );
        if assigned(HeadsetControlForm   ) then ReTranslateComponent(HeadsetControlForm  );
        {if assigned(SkinEditorForm       ) then
        begin
          SkinEditorForm.BackupComboboxes;
          ReTranslateComponent(SkinEditorForm      );
          SkinEditorForm.RestoreComboboxes;
        end; }
        if assigned(BirthdayForm         ) then ReTranslateComponent(BirthdayForm        );
        if assigned(RandomPlaylistForm   ) then
        begin
          RandomPlaylistForm.BackupComboboxes;
          ReTranslateComponent(RandomPlaylistForm  );
          RandomPlaylistForm.RestoreComboboxes;
        end;
        //if assigned(FormWebServer        ) then ReTranslateComponent(FormWebServer       );

        if assigned(ShutDownEditForm     ) then ReTranslateComponent(ShutDownEditForm    );
        if assigned(NewStationForm       ) then ReTranslateComponent(NewStationForm      );

         // Todo:
        // - Alle Comboboxen auf ihren alten Itemindex zurücksetzen (also die, die schon zu Beginn gefüllt sind)
        // - Einige Comboboxen ggf. neu füllen ("Alte suchergebnisse")


        for i := 0 to Spaltenzahl - 1 do
           VST.Header.Columns[i].Text := _(DefaultSpalten[VST.Header.Columns[i].Tag].Bezeichnung);
        VST.Invalidate;

        if MedienBib.AlleArtists.Count = 0 then
          c := 0
        else
          c := MedienBib.AlleArtists.Count - 1;

        case MedienBib.NempSortArray[1] of
            siAlbum:  ArtistsVST.Header.Columns[0].Text := (TreeHeader_Albums)      + ' (' + inttostr(c) + ')' ;
            siArtist: ArtistsVST.Header.Columns[0].Text := (TreeHeader_Artists)     + ' (' + inttostr(c) + ')' ;
            siOrdner: ArtistsVST.Header.Columns[0].Text := (TreeHeader_Directories) + ' (' + inttostr(c) + ')' ;
            siGenre:  ArtistsVST.Header.Columns[0].Text := (TreeHeader_Genres)      + ' (' + inttostr(c) + ')' ;
            siJahr:   ArtistsVST.Header.Columns[0].Text := (TreeHeader_Years)       + ' (' + inttostr(c) + ')' ;
            siFileage:ArtistsVST.Header.Columns[0].Text := (TreeHeader_FileAges)    + ' (' + inttostr(c) + ')' ;
          else ArtistsVST.Header.Columns[0].Text := '(N/A)';
        end;
        ArtistsVST.Invalidate;

        if MedienBib.Alben.Count = 0 then
          c := 0
        else
          c := MedienBib.Alben.Count - 1;

        if MedienBib.CurrentArtist = BROWSE_PLAYLISTS then
            AlbenVST.Header.Columns[0].Text := TreeHeader_Playlists + ' (' + inttostr(c) + ')'
        else
        if MedienBib.CurrentArtist = BROWSE_RADIOSTATIONS then
            AlbenVST.Header.Columns[0].Text := TreeHeader_Webradio + ' (' + inttostr(c) + ')'
        else
        case MedienBib.NempSortArray[2] of
            siAlbum:  AlbenVST.Header.Columns[0].Text := (TreeHeader_Albums)      + ' (' + inttostr(c) + ')' ;
            siArtist: AlbenVST.Header.Columns[0].Text := (TreeHeader_Artists)     + ' (' + inttostr(c) + ')' ;
            siOrdner: AlbenVST.Header.Columns[0].Text := (TreeHeader_Directories) + ' (' + inttostr(c) + ')' ;
            siGenre:  AlbenVST.Header.Columns[0].Text := (TreeHeader_Genres)      + ' (' + inttostr(c) + ')' ;
            siJahr:   AlbenVST.Header.Columns[0].Text := (TreeHeader_Years)       + ' (' + inttostr(c) + ')' ;
            siFileage:AlbenVST.Header.Columns[0].Text := (TreeHeader_FileAges)    + ' (' + inttostr(c) + ')' ;
          else AlbenVST.Header.Columns[0].Text := '(N/A)';
        end;
        AlbenVST.Invalidate;

        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
    end;
end;

procedure ClearShortCuts;
begin
    with Nemp_MainForm do
    begin
        PM_ML_HideSelected.ShortCut := 0;
        PM_ML_CopyToClipboard.ShortCut := 0;
        PM_ML_PasteFromClipboard.ShortCut := 0;
    end;
end;

procedure SetShortCuts;
begin
    with Nemp_MainForm do
    begin
        PM_ML_HideSelected.ShortCut := 46;             // Entf
        PM_ML_CopyToClipboard.ShortCut := 16451;       // Strg + C
        PM_ML_PasteFromClipboard.ShortCut := 16470;    // Strg + V
    end;
end;

{
    GetListOfAudioFileCopies
    Collect all Files ithin the Nemp-Universe with the same filename.
    These files must be updated when the user edits a file
    ( in the tree, in the detail-listing within the mainform, in the detailform
      or just the Player-rating )

    !!! Important Note !!!
    Use this function only in VCL-Thread and only after a test for
     - Medienbib.status <= 1  (searching for new files or GetTags should be ok)
       and MedienBib.CurrentThreadFilename
}
function GetListOfAudioFileCopies(Original: TAudioFile; Target:TObjectList): Boolean;
var bibFile: TAudioFile;
    originalPath: String;

      function NeededFile(af: TAudioFile): boolean;
      begin
          result := assigned(af) and (af.Pfad = originalPath);
      end;

begin
    result := False;
    originalPath := Original.Pfad;

    // 1. Add Original itself
    Target.Add(Original);

    // 2. The Player-File
    if NeededFile(NempPlayer.MainAudioFile) then
        Target.Add(NempPlayer.MainAudioFile);

    // 3. The Detailform-File
    if assigned(fDetails) and NeededFile(fDetails.AktuellesAudioFile) then
        Target.Add(fDetails.AktuellesAudioFile);

    // 4. The "currentfile" from the library (this is the one displayed in the VST-Details)
    if NeededFile(Medienbib.CurrentAudioFile) then
        Target.Add(MedienBib.CurrentAudioFile);

    // 5. Add files from the Playlist
    NempPlaylist.CollectFilesWithSameFilename(Original.Pfad, Target);

    // 4. Add File from the library (if possible)
    // !!! this must be the last one in the list (see keymatching-test in the calling method)
    //if (MedienBib.StatusBibUpdate > 0) then
    //    MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0)
    //else
    //begin
        bibFile := MedienBib.GetAudioFileWithFilename(Original.Pfad);
        if assigned(bibFile) then
        begin
            Target.Add(bibFile);
            result := True;
        end else
            result := False;
    //end;
end;
{
    CorrectVCLAfterAudioFileEdit
    After a File has been edited (and all of its copies)
    The GUI has to be updated:
        Player (Rating)
        VST-Details
        VST
        PlaylistVST
        Detailform
}
procedure CorrectVCLAfterAudioFileEdit(aFile: TAudioFile);
var OriginalPath: String;
    bibFile: TAudioFile;

      function SameFile(af: TAudioFile): boolean;
      begin
          result := assigned(af) and (af.Pfad = originalPath);
      end;

begin
    OriginalPath := aFile.Pfad;

    Nemp_MainForm.PlaylistVST.Invalidate;
    Nemp_MainForm.Vst.Invalidate;

    // Actualise Player (Rating, Title, Taskbar)
    if SameFile(NempPlayer.MainAudioFile) then
    begin
        Nemp_MainForm.ShowPlayerDetails(NempPlayer.MainAudioFile);
        NempPlayer.RefreshPlayingTitel;
        Application.Title := NempPlayer.GenerateTaskbarTitel;
        Spectrum.DrawRating(NempPlayer.MainAudioFile.Rating);
    end;

    // ... VST-Details
    if SameFile(MedienBib.CurrentAudioFile) then
        Nemp_MainForm.ShowVSTDetails(MedienBib.CurrentAudioFile);

    // ... Detail-Form
    if assigned(fDetails)
        and Nemp_MainForm.AutoShowDetailsTMP
        and SameFile(fDetails.AktuellesAudioFile)
    then
        // Note: a call of AktualisiereDetailForm(af, SD_MEDIENBIB)
        //       will produce some strange AVs here - so we do it quick&dirty with a timer
        //       (Probably some issues with VST.Edited and stuff. Don't know.)
        FDetails.ReloadTimer.Enabled := True;

    // TabWarning
    bibFile := MedienBib.GetAudioFileWithFilename(aFile.Pfad);
    if SameFile(bibFile) then
    begin
        if Not MedienBib.ValidKeys(bibFile) then
            SetBrowseTabWarning(True);
    end;
end;

// When editing audiofiles, the browse-lists may become invalid
// in this case, a Warning-Icon should be displayed in the first Browse-Button
procedure SetBrowseTabWarning(ShowWarning: Boolean);
begin
    With Nemp_MainForm do
    begin
        if ShowWarning then
        begin
            // Show a warning-sign
            if Medienbib.BrowseMode = 0 then
            begin
                // Browsing by artist-album activated
                TabBtn_Browse.GlyphLine := 2;
            end else
                // Browsing by cover (or something else) activated
                TabBtn_Browse.GlyphLine := 0;
            TabBtn_Browse.Hint := TabBtnBrowse_Hint1 + #13#10 + TabBtnBrowse_Hint2;

        end else
        begin
            // Show Default-Button
            if Medienbib.BrowseMode = 0 then
            begin
                // Browsing by artist-album activated
                TabBtn_Browse.GlyphLine := 1;
            end else
                // Browsing by cover (or something else) activated
                TabBtn_Browse.GlyphLine := 0;
            TabBtn_Browse.Hint := TabBtnBrowse_Hint1;
        end;
        // Refresh the Button
        TabBtn_Browse.Refresh;
    end;
end;

procedure SetBrowseTabCloudWarning(ShowWarning: Boolean);
begin
    With Nemp_MainForm do
    begin
        if ShowWarning then
        begin
            // Show a warning-sign
            if Medienbib.BrowseMode = 2 then
            begin
                // Browsing by artist-album activated
                TabBtn_TagCloud.GlyphLine := 2;
            end else
                // Browsing by cover (or something else) activated
                TabBtn_TagCloud.GlyphLine := 0;
            TabBtn_TagCloud.Hint := TabBtnTagCloud_Hint1 + #13#10 + TabBtnTagCloud_Hint2;

        end else
        begin
            // Show Default-Button
            if Medienbib.BrowseMode = 2 then
            begin
                // Browsing by artist-album activated
                TabBtn_TagCloud.GlyphLine := 1;
            end else
                // Browsing by cover (or something else) activated
                TabBtn_TagCloud.GlyphLine := 0;
            TabBtn_TagCloud.Hint := TabBtnTagCloud_Hint1;
        end;
        // Refresh the Button
        TabBtn_TagCloud.Refresh;
    end;
end;

procedure CheckAndDoCoverDownloaderQuery;
begin
          if (MedienBib.CoverSearchLastFM = BoolUnDef)
              and MedienBib.CoverSearchLastFMInit
          then
          begin
              MedienBib.CoverSearchLastFMInit := False;
              if MessageDlg(CoverFlowLastFM_Confirmation, mtConfirmation, [mbYes,MBNo], 0) = mrYes then
                  MedienBib.CoverSearchLastFM := BoolTrue
              else
                  MedienBib.CoverSearchLastFM := BoolFalse;
          end;

end;

procedure HandleStopAfterTitleClick;
begin
    With Nemp_MainForm do
    begin
        if NempPlayer.StopStatus = PLAYER_STOP_NORMAL then
        begin
            NempPlayer.SetNoEndSyncs(NempPlayer.MainStream);
            NempPlayer.SetNoEndSyncs(NempPlayer.SlideStream);
            NempPlayer.LastUserWish := USER_WANT_STOP;
        end else
        begin
            NempPlayer.SetEndSyncs(NempPlayer.MainStream);
            NempPlayer.SetEndSyncs(NempPlayer.SlideStream);
            NempPlayer.LastUserWish := USER_WANT_PLAY;
        end;
    end;
end;
procedure HandleStopNowClick;
begin
    With Nemp_MainForm do
    begin
        NempPlayer.LastUserWish := USER_WANT_STOP;
        NempPlaylist.stop;
        if NempPlayer.BassStatus <> BASS_ACTIVE_PLAYING then
        begin
          Spectrum.DrawClear;
          Spectrum.DrawText(NempPlayer.PlayingTitel,False);
          Spectrum.DrawTime('  00:00');
          fspTaskbarPreviews1.InvalidatePreview;
        end;
        Application.Title := NempPlayer.GenerateTaskbarTitel;
        PlaylistVST.Invalidate;
        Basstimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
    end;
end;

procedure VSTSelectionToAudiofileList(aTree: TVirtualStringTree; aSelection: TNodeArray; Target: TObjectList);
var i: Integer;
    Data: PTreeData;
begin
    for i := 0 to length(aSelection) - 1 do
    begin
        Data := aTree.GetNodeData(aSelection[i]);
        Target.Add(Data^.FAudioFile);
    end;
end;


end.
