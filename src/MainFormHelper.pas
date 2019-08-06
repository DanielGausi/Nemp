{

    Unit MainFormHelper

    - Some Helpers for MainUnit
      Written in separate Unit to shorten MainUnit a bit

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
unit MainFormHelper;

interface

uses Windows, Classes, Controls, StdCtrls, Forms, SysUtils, ContNrs, VirtualTrees,
    NempAudioFiles, Nemp_ConstantsAndTypes, Nemp_RessourceStrings, dialogs,
    MyDialogs, System.UITypes, math, Vcl.ExtCtrls;

type TWindowSection = (ws_none, ws_Library, ws_Playlist, ws_Controls);


// passt die VCL an die Player-Werte an
    //procedure CorrectEQButton(band: Integer; ResetCaption: Boolean = True);
    //procedure CorrectHallButton;
    //procedure CorrectEchoButtons;
    //procedure CorrectSpeedButton;
    procedure CorrectVolButton;
    // Berechnet aus den VCL-Werten die Player-Werte
    //function VCLEQToPlayer(idx: Integer): Single;
    function APIEQToPlayer(Value: Integer): Single;
    //function VCLHallToPlayer: Single;
    //function VCLSpeedToPlayer: Single;
    function VCLVolToPlayer: Integer;
    //function VCLEchoMixToPlayer: Single;
    //function VCLEchoTimeToPlayer: Single;

    procedure SetProgressButtonPosition(aProgress: Double);
    function ProgressButtonPositionToProgress: Double;

    procedure StopFluttering;

    procedure HandleNewConnectedDrive;

    procedure FillTreeView(MP3Liste: TObjectlist; AudioFile:TAudioFile);
    procedure FillTreeViewQueryTooShort;//(Dummy: TAudioFile);

    //function ObjectIsPlaylist(aName:string): Boolean;
    //function ObjectIsHeadphone(aName:string): Boolean;

    function GetDropWindowSection(aControl: TWinControl): TWindowSection;

    // Blockiert GUI-Elemente, die ein Hinzufügen/Löschen von Elementen in der Medienbib verursachen
    procedure BlockGUI(aBlockLevel: Integer);
    procedure UnBlockGUI;

    procedure SetTabStopsPlayer;
    procedure SetTabStopsTabs;

    procedure ReArrangeToolImages;

    procedure ResetBrowsePanels;
    // Switch MediaLibrary: Umschalten zwischen Listen/Coverflow/Tagwolke
    procedure SwitchMediaLibrary(NewMode: Integer);
    // SwitchBrowsePanel: entsprechendes Anzeigen der Liste
    procedure SwitchBrowsePanel(NewMode: Integer);

    procedure RestoreCoverFlowAfterSearch(ForceUpdate: Boolean = False);

    procedure ReTranslateNemp(LanguageCode: String);

    procedure ClearShortCuts;
    procedure SetShortCuts;

    function HandleSingleFileTagChange(aAudioFile: TAudioFile; TagToReplace: String; Out newTag: String; out IgnoreWarnings: Boolean): Boolean;
    function HandleIgnoreRule(aTag: String): Boolean;
    function HandleMergeRule(aTag: String; out newTag: String): Boolean;
    // Select all files with the same path as MedienBib.CurrentAudioFile
    function GetListOfAudioFileCopies(Original: TAudioFile; Target:TObjectList): Boolean;
    procedure CorrectVCLAfterAudioFileEdit(aFile: TAudioFile; CheckTrees: Boolean=True);
    procedure SyncAudioFilesWith(aAudioFile: TAudioFile);
    procedure DoSyncStuffAfterTagEdit(aAudioFile: TAudiofile; backupTag: UTF8String);

    procedure CorrectVCLForABRepeat;
    procedure SwapABImagesIfNecessary(FixedImage: TImage);

    procedure SetBrowseTabWarning(ShowWarning: Boolean);
    procedure SetBrowseTabCloudWarning(ShowWarning: Boolean);
    procedure SetGlobalWarningID3TagUpdate;

    // procedure CheckAndDoCoverDownloaderQuery;

    procedure HandleStopAfterTitleClick;
    procedure HandleStopNowClick;

    procedure VSTSelectionToAudiofileList(aTree: TVirtualStringTree; aSelection: TNodeArray; Target: TObjectList);

    function GetFileListForClipBoardFromTree(aTree: TVirtualStringTree): String;
    // WritePlaylistForClipBoard: Create a temporary Playlist with the fileNAMES (EXcluding the path)
    // this playlist is added to the Clipboard in a Copy&Paste-Process
    // (e.g.: use it to copy the playlist to a USB-Stick or portable player
    function WritePlaylistForClipBoard(aTree: TVirtualStringTree): String;

    procedure AddErrorLog(aString: String);
    procedure HandleError(aAction: TAudioFileAction; aFile: TAudioFile; aErr: TNempAudioError; Important: Boolean = false);


    function GetSpecialPermissionToChangeMetaData:Boolean;

    procedure SetSkinRadioBox(aName: String);

implementation

uses NempMainUnit, Splash, BibSearch, TreeHelper,  GnuGetText,
    PlayListUnit, AuswahlUnit, MedienListeUnit, Details,
    NewPicture, NewStation, OptionsComplete, RandomPlaylist,
    Shutdown, ShutDownEdit, StreamVerwaltung, BirthdayShow, fspTaskbarMgr,
    spectrum_vis, PlayerClass, PartymodePassword, CloudEditor, PlaylistToUSB,
    ErrorForm, CoverHelper, BasicSettingsWizard, DeleteSelect, CDSelection,
    CDOpenDialogs, LowBattery, PlayWebstream, Taghelper, MedienbibliothekClass,
    PlayerLog, progressUnit, Hilfsfunktionen, EffectsAndEqualizer;

procedure CorrectVolButton;
begin
    with Nemp_MainForm do
      //VolButton.Top := Round((100-NempPlayer.Volume)/ (100/VolShape.Height) {3.125}) + (VolShape.Top - (VolButton.Height Div 2));
      //VolButton.Left := Round(({100-}NempPlayer.Volume)/ (100/VolShape.Width) {3.125}) + (VolShape.Left - (VolButton.Width Div 2));

      VolButton.Left := Round(NempPlayer.Volume/ (100/(VolShape.Width - VolButton.Width) )) + VolShape.Left;

    with Nemp_MainForm do
      VolButtonHeadset.Left := Round(NempPlayer.HeadsetVolume/ (100/(VolShapeHeadset.Width - VolButtonHeadset.Width) )) + VolShapeHeadset.Left;
      //:= Round((100-NempPlayer.HeadsetVolume)/ (100/VolShapeHeadset.Height) {3.125}) + (VolShapeHeadset.Top - (VolButtonHeadset.Height Div 2));
end;
function VCLVolToPlayer: Integer;
begin
    with Nemp_MainForm do
        //result := Round(100-((VolButton.Top - VolShape.Top + (VolButton.Height Div 2))* (100/VolShape.Height){3.125}));
        //result := Round({100-}((VolButton.Left - VolShape.Left + (VolButton.Width Div 2))* (100/VolShape.Width){3.125}));

        result := Round(
        (VolButton.Left - VolShape.Left)  * (100/(VolShape.Width - VolButton.Width))
        );
end;

procedure SetProgressButtonPosition(aProgress: Double);
var newLeft: Integer;
begin
    with Nemp_MainForm do begin
        newLeft  := SlideBarShape.Left - (SlideBarButton.Width Div 2)  // initial position
                + Round(SlideBarShape.Width * aProgress);
        // Set position only, if there is a change. that wil reduce repaints and flickering
        if newLeft <> SlideBarButton.Left then
            SlideBarButton.Left := newLeft;
    end;
end;

function ProgressButtonPositionToProgress: Double;
begin
    with Nemp_MainForm do
    begin
        result := (SlideBarButton.Left + (SlideBarButton.Width Div 2) - SlideBarShape.Left) / (SlideBarShape.Width);
    end;

end;


function APIEQToPlayer(Value: Integer): Single;
begin
    result := EQ_NEW_MAX - ( Value / EQ_NEW_FACTOR );
end;



procedure StopFluttering;
begin
    Nemp_MainForm.WalkmanModeTimer.Interval := 60000; //120000; // 1 minute
    Nemp_MainForm.WalkmanModeTimer.Tag := 0;
    NempPlayer.Flutter(1, 1000);
    NempPlayer.Speed := 1;

    if assigned(FormEffectsAndEqualizer) then
        FormEffectsAndEqualizer.CorrectSpeedButton;
end;


// TODO: Event bei "neues Drive angeschlossen"
procedure HandleNewConnectedDrive;
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

              FSplash.Close;
              Nemp_MainForm.Enabled := True;
              Nemp_MainForm.SetFocus;
        end;

        if Medienbib.AutoScanDirs then
            Medienbib.AddStartJob(JOB_AutoScanNewFiles, '');
        if Medienbib.AutoDeleteFiles then
            Medienbib.AddStartJob(JOB_AutoScanMissingFiles, '');
        //Finalization
        MedienBib.AddStartJob(JOB_Finish, '');

        // Start the work
        // status should be still = 0 here, so it's save to start the jobs now
        MedienBib.ProcessNextStartJob;
    end;
end;


// Diese Prozedur soll aufgerufen werden, wenn die Liste nach einem
// Sortieren neu gefüllt wurde. Es existiert ein Node mit Data=AudioFile!!!
procedure FillTreeView(MP3Liste: TObjectlist; AudioFile:TAudioFile);
var i: integer;
  NewNode:PVirtualNode;
  Data:PTreeData;
  tmpAudioFile: TAudioFile;

        function SameFile(File1, File2: TAudioFile): Boolean;
        begin
            if assigned(File1) and assigned(File2) then
                result := (File1.Dateiname = File2.Dateiname) AND (File1.Ordner = File2.Ordner)
            else
                result := False;
        end;

begin
    with Nemp_MainForm do
    begin
        VST.BeginUpdate;
        VST.Clear;

        // testing 08.2017: Filling Label-Doubleclick-Search results (e.g.)
        if not assigned(AudioFile) then
            AudioFile := MedienBib.CurrentAudioFile;

        if (Not MedienBib.AnzeigeListIsCurrentlySorted) then
            VST.Header.SortColumn := -1
        else
            VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);


        if (MP3Liste.Count = 0) then
        begin
            // just add a Dummyfile showing "No results"
            AddVSTMp3(VST, NIL, MedienBib.BibSearcher.DummyAudioFile);
            ShowVSTDetails(Nil);
        end else
        begin
            for i := 0 to MP3Liste.Count-1 do
                AddVSTMp3(VST,Nil,TAudioFile(MP3Liste.Items[i]));

            // Knoten mit AudioFile suchen und focussieren
            NewNode := VST.GetFirst;
            if assigned(Newnode) then
            begin
                Data := VST.GetNodeData(NewNode);
                tmpAudioFile := Data^.FAudioFile;

                if Not SameFile(tmpAudioFile, AudioFile) then
                repeat
                    NewNode := VST.GetNext(NewNode);
                    if assigned(NewNode) then
                    begin
                        Data := VST.GetNodeData(NewNode);
                        tmpAudioFile := Data^.FAudioFile;
                    end;
                until SameFile(tmpAudioFile, AudioFile) OR (NewNode=NIL);

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
                    ShowVSTDetails(tmpAudioFile, SD_MEDIENBIB);
                end
            end else
            begin
                // no file in view
                ShowVSTDetails(Nil);
            end;
        end;

        VST.EndUpdate;
    end;
end;


procedure FillTreeViewQueryTooShort;//(Dummy: TAudioFile);
begin
    with Nemp_MainForm do
    begin
        MedienBib.BibSearcher.DummyAudioFile.Titel := MainForm_SearchQueryTooShort;

        VST.BeginUpdate;
        VST.Clear;
        AddVSTMp3(VST, NIL, MedienBib.BibSearcher.DummyAudioFile);
        VST.EndUpdate;
        // AktualisiereDetailForm(NIL, SD_MEDIENBIB);
        ShowVSTDetails(Nil);
    end;
end;

// TWindowSection = (ws_none, ws_Library, ws_Playlist, ws_Controls);
function GetDropWindowSection(aControl: TWinControl): TWindowSection;
begin
    result := ws_none;

    while (result = ws_none) and assigned(aControl) and (aControl <> Nemp_MainForm) do
    begin
        if aControl = Nemp_MainForm._ControlPanel then
            result := ws_Controls
        else
        if aControl = Nemp_MainForm.PlaylistPanel then
            result := ws_Playlist
        else
        if aControl = Nemp_MainForm._TopMainPanel then
            result := ws_Library
        else
        if aControl = Nemp_MainForm._VSTPanel then
            result := ws_Library;

        aControl := aControl.Parent;
    end;
end;

{
function ObjectIsPlaylist(aName:string): Boolean;
begin
  result := (aName = 'PlaylistVST') or (aName = 'PlaylistVST_IMG');
end;

function ObjectIsHeadphone(aName:string): Boolean;
begin
  result := (aName = 'GRPBOXHeadset');
end;
}


procedure BlockGUI(aBlockLevel: Integer);
begin
    // todo: API access ???

    if aBlockLEvel >= 1 then
    begin
        // Block "Update" access
        // all done by Menu.OnPopup ;-)
    end;

    if aBlockLEvel >= 2 then
    begin
        // Block "Write" access
        // Classic Browsing
        Nemp_MainForm.ArtistsVST         .Enabled := False;
        Nemp_MainForm.AlbenVST           .Enabled := False;
        // Coverflow
        Nemp_MainForm.PanelCoverBrowse   .Enabled := False;
        // TagCloud
        Nemp_MainForm.PanelTagCloudBrowse.Enabled := False;
        // Switch-Buttons
        Nemp_MainForm.TabBtn_CoverFlow.Enabled := False;
        Nemp_MainForm.TabBtn_Browse   .Enabled := False;
        Nemp_MainForm.TabBtn_TagCloud .Enabled := False;
        // VST Panel (Complete)
        Nemp_MainForm._VSTPanel.Enabled := False;

        if assigned(FormBibSearch) then
           FormBibSearch.EnableControls(False);
        if assigned(FDetails) then
            FDetails.Enabled := False;
        if assigned(CloudEditorForm) then
            CloudEditorForm.Enabled := False;
    end;

    if aBlockLEvel >= 3 then
    begin
        Nemp_MainForm.VST.OnHeaderClick := NIL;
        Nemp_MainForm.ReadyForGetFileApiCommands := False;
        // Block "Read" access = Block (almost) everything
    end;
end;

procedure UnBlockGUI;
begin
    // Classic Browsing
    Nemp_MainForm.ArtistsVST         .Enabled := True;
    Nemp_MainForm.AlbenVST           .Enabled := True;
    // Coverflow
    Nemp_MainForm.PanelCoverBrowse   .Enabled := True;
    // TagCloud
    Nemp_MainForm.PanelTagCloudBrowse.Enabled := True;
    // Switch-Buttons
    Nemp_MainForm.TabBtn_CoverFlow.Enabled := True;
    Nemp_MainForm.TabBtn_Browse   .Enabled := True;
    Nemp_MainForm.TabBtn_TagCloud .Enabled := True;
    // VST Panel (Complete)
    Nemp_MainForm._VSTPanel.Enabled := True;

    // Other Forms
    if assigned(FormBibSearch) then
       FormBibSearch.EnableControls(True);
    if assigned(FDetails) then
        FDetails.Enabled := True;
    if assigned(CloudEditorForm) then
        CloudEditorForm.Enabled := True;

    // some additional Stuff from BlockLevel 3
    Nemp_MainForm.ReadyForGetFileApiCommands := True;
    Nemp_MainForm.VST.OnHeaderClick := Nemp_MainForm.VSTHeaderClick;
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
        (* !!!!!!!!!!!!!! GUI !!!!!!!!!!!!!!!!!
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
        *)
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
        TabBtn_MainPlayerControl  .TabStop := NempOptions.TabStopAtTabs;
    end;
end;

procedure ReArrangeToolImages;
var currentLeft: Integer;
    decvalue: Integer;
    newtop: Integer;
    MenuString: String;
begin

    with Nemp_MainForm do
    begin
        decvalue := ScrobblerImage.Width + 2;
        currentLeft := 8; // RatingImage.Left;

        newTop := 3; // RatingImage.Top + RatingImage.Height + 2;//TextAnzeigeIMAGE.Top + TextAnzeigeIMAGE.Height + 16;

        if NempPlayer.NempScrobbler.DoScrobble then
        begin
            ScrobblerImage.Top := newTop;
            ScrobblerImage.Left := currentLeft;
            ScrobblerImage.Visible := True;
            inc(currentLeft, decvalue);
            MenuString := MenuItem_Deactivate;
        end else
        begin
            ScrobblerImage.Visible := False;
            MenuString := MenuItem_Activate;
        end;
        // Set Scrobble-Menu
        MM_T_ScrobblerActivate.Caption := MenuString;
        PM_P_ScrobblerActivate.Caption := MenuString;
        PM_S_ScrobblerActivate.Caption := MenuString;


        If assigned(NempWebserver) and NempWebserver.Active then
        begin
            WebserverImage.Top := newTop;
            WebserverImage.Left := currentLeft;
            WebserverImage.Visible := True;
            inc(currentLeft, decvalue);
            MenuString := MenuItem_Deactivate;
        end else
        begin
            WebserverImage.Visible := False;
            MenuString := MenuItem_Activate;
        end;
        // Set the Webserver-Menu
        MM_T_WebServerActivate.Caption := MenuString;
        PM_P_WebServerActivate.Caption := MenuString;
        PM_W_WebServerActivate.Caption := MenuString;

        if BirthdayTimer.Enabled then
        begin
            BirthdayImage.Top := newTop;
            BirthdayImage.Left := currentLeft;
            BirthdayImage.Visible := True;
            inc(currentLeft, decvalue);
            MenuString := MenuItem_Deactivate;
        end else
        begin
            BirthdayImage.Visible := False;
            MenuString := MenuItem_Activate;
        end;
        // Set the Birthday-Menu
        MM_T_BirthdayActivate.Caption := MenuString;
        PM_P_BirthdayActivate.Caption := MenuString;
        PM_B_BirthdayActivate.Caption := MenuString;

        if (SleepTimer.Enabled) or (NempOptions.ShutDownAtEndOfPlaylist) then
        begin
            SleepImage.Top := newTop;
            SleepImage.Left := currentLeft;
            SleepImage.Visible := True;
            inc(currentLeft, decvalue);
        end else
            SleepImage.Visible := False;

        if WalkmanModeTimer.Tag = 1 then
        begin
            WalkmanImage.Top := newTop;
            WalkmanImage.Left := currentLeft;
            WalkmanImage.Visible := True;
        end else
            WalkmanImage.Visible := False;

    end;
end;

procedure ResetBrowsePanels;
begin
    with Nemp_MainForm do
    begin
          PanelStandardBrowse.Visible := (MedienBib.BrowseMode = 0) and (MedienBib.Count > 0);
          PanelCoverBrowse.Visible    := (MedienBib.BrowseMode = 1) and (MedienBib.Count > 0);
          PanelTagCloudBrowse.Visible := (MedienBib.BrowseMode = 2) and (MedienBib.Count > 0);

          if MedienBib.Count = 0 then
              LblEmptyLibraryHint.Caption := MainForm_LibraryIsEmpty;
    end;
end;

procedure SwitchMediaLibrary(NewMode: Integer);
begin
    with Nemp_MainForm do
    begin
        // Bib umschalten.
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

            ResetBrowsePanels;

        FSplash.Close;
        Nemp_MainForm.Enabled := True;
        Nemp_MainForm.SetFocus;
    end;
end;

procedure SwitchBrowsePanel(NewMode: Integer);
begin
    with Nemp_MainForm do
    begin
        {if MedienBib.Count = 0 then
        begin
                PanelCoverBrowse.visible := False;
                PanelStandardBrowse.Visible := False;
                PanelTagCloudBrowse.Visible := False;
        end

        else }

        case Newmode of
            0: begin
                // Zeige Browse-Listen
                PanelCoverBrowse.visible := False;
                PanelStandardBrowse.Visible := MedienBib.Count > 0;
                PanelTagCloudBrowse.Visible := False;

                PanelStandardBrowse.Left := 2;
                PanelStandardBrowse.Width := AuswahlPanel.Width - 4;
                PanelStandardBrowse.Top := 2;
                PanelStandardBrowse.Height := GRPBOXArtistsAlben.Height - 4;
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
                PanelCoverBrowse.Visible := MedienBib.Count > 0;

                PanelCoverBrowse.Left := 2;
                PanelCoverBrowse.Width := AuswahlPanel.Width - 4;
                PanelCoverBrowse.Top := 2;
                PanelCoverBrowse.Height := GRPBOXArtistsAlben.Height - 4;
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
                PanelTagCloudBrowse.Visible := MedienBib.Count > 0;
                PanelCoverBrowse.Visible := False;

                PanelTagCloudBrowse.Left := 2;
                PanelTagCloudBrowse.Width := AuswahlPanel.Width - 4;
                PanelTagCloudBrowse.Top := 2;
                PanelTagCloudBrowse.Height := GRPBOXArtistsAlben.Height - 4;
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
        //MedienBib.NewCoverFlow.SetNewHandle(PanelCoverBrowse.Handle);
    end;
end;

procedure RestoreCoverFlowAfterSearch(ForceUpdate: Boolean = False);
var aCover: tNempCover;
begin
    with Nemp_MainForm do
    begin
        if (MedienBib.BrowseMode = 1) and
        ( MedienBib.BibSearcher.QuickSearchOptions.ChangeCoverFlow or ForceUpdate)
        then
        begin
            RefreshCoverFlowTimer.Enabled := False;
            MedienBib.ReBuildCoverList(False);
            MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
            GetRandomCover(MedienBib.Coverlist);

            If MedienBib.Coverlist.Count > 3 then
                CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
            else
                CoverScrollbar.Max := 3;
            CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;

            if (CoverScrollbar.Position > 0) and (CoverScrollbar.Position < MedienBib.CoverList.Count) then
            begin
                aCover := TNempCover(MedienBib.CoverList[CoverScrollbar.Position]);
                Lbl_CoverFlow.Caption := aCover.InfoString;
            end else
                Lbl_CoverFlow.Caption := '';
        end;
    end;

end;

procedure ReTranslateNemp(LanguageCode: String);
var i, c: Integer;
begin
    with Nemp_MainForm do
    begin
        Uselanguage(LanguageCode);

        //c := Nemp_MainForm.CBHeadSetControlInsertMode.ItemIndex;
        //ReTranslateComponent (Nemp_MainForm);
        //Nemp_MainForm.CBHeadSetControlInsertMode.ItemIndex := c;

        NempPlayer.RefreshPlayingTitel;
        DisplayPlayerMainTitleInformation(True);
        DisplayHeadsetTitleInformation(True);

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

            (* !!!!!!!!!!!!!! GUI !!!!!!!!!!!!!!!!!
        if NempPlayer.MainStreamIsReverseStream then
            DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayNormal)
        else
            DirectionPositionBTN.Hint := (MainForm_ReverseBtnHint_PlayReverse);

        Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
            *)

        if SleepTimer.Enabled then SleepTimerTimer(Nil);
        if BirthdayTimer.Enabled then BirthdayTimerTimer(Nil);


        //RestoreComboboxes;

        ReTranslateComponent (PlaylistForm    );
        ReTranslateComponent (AuswahlForm     );
        ReTranslateComponent (MedienlisteForm );
        ReTranslateComponent (ProgressFormLibrary    );
        ReTranslateComponent (ProgressFormPlaylist   );

        if assigned(FNewPicture          ) then ReTranslateComponent(FNewPicture         );
        if assigned(FSplash              ) then ReTranslateComponent(FSplash             );
        if assigned(PasswordDlg          ) then ReTranslateComponent(PasswordDlg         );
        if assigned(FormBibSearch        ) then ReTranslateComponent(FormBibSearch       );
        if assigned(CloudEditorForm      ) then ReTranslateComponent(CloudEditorForm     );
        if assigned(Wizard               ) then ReTranslateComponent(Wizard              );
        if assigned(PlayerLogForm        ) then ReTranslateComponent(PlayerLogForm       );
        if assigned(FormEffectsAndEqualizer) then ReTranslateComponent(FormEffectsAndEqualizer);

        if assigned(FDetails) then
        begin
            BackUpComboBoxes(FDetails);
            ReTranslateComponent(FDetails);
            RestoreComboboxes(FDetails);
        end;
        if assigned(OptionsCompleteForm  ) then
        begin
           BackUpComboBoxes(OptionsCompleteForm);
           ReTranslateComponent(OptionsCompleteForm );
           OptionsCompleteForm.OptionsVST.Invalidate;
           RestoreComboboxes(OptionsCompleteForm);
        end;
        if assigned(FormStreamVerwaltung ) then
        begin
            BackUpComboBoxes(FormStreamVerwaltung);
            ReTranslateComponent(FormStreamVerwaltung);
            RestoreComboboxes(FormStreamVerwaltung);
        end;
        if assigned(ShutDownForm         ) then ReTranslateComponent(ShutDownForm        );
        //if assigned(HeadsetControlForm   ) then ReTranslateComponent(HeadsetControlForm  );
        if assigned(BirthdayForm         ) then ReTranslateComponent(BirthdayForm        );
        if assigned(RandomPlaylistForm   ) then
        begin
          BackupComboboxes(RandomPlaylistForm);
          ReTranslateComponent(RandomPlaylistForm  );
          RestoreComboboxes(RandomPlaylistForm);
        end;

        if assigned(ShutDownEditForm     ) then ReTranslateComponent(ShutDownEditForm    );
        if assigned(NewStationForm       ) then ReTranslateComponent(NewStationForm      );

        if assigned(PlaylistCopyForm     ) then
        begin
            BackUpComboBoxes(PlaylistCopyForm);
            ReTranslateComponent(PlaylistCopyForm     );
            RestoreComboBoxes(PlaylistCopyForm);
        end;

        if assigned(FormCDDBSelect)  then ReTranslateComponent(FormCDDBSelect  );
        if assigned(CDOpenDialog)    then
        begin
            BackupComboboxes(CDOpenDialog);
            ReTranslateComponent(CDOpenDialog    );
            RestoreComboboxes(CDOpenDialog);
        end;

        if assigned(DeleteSelection) then ReTranslateComponent(DeleteSelection );

        if assigned(FormLowBattery) then
        begin
            BackUpComboBoxes(FormLowBattery);
            ReTranslateComponent(FormLowBattery);
            RestoreComboboxes(FormLowBattery);
        end;

        if assigned(FPlayWebstream) then ReTranslateComponent(FPlayWebstream);

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

        // refill playlist headers
        NempPlaylist.ShowPlayListSummary;

        if Medienbib.BrowseMode = 1 then
            CoverScrollbarChange(Nil); // trigger redraw of label

        if Medienbib.BrowseMode = 2 then
            MedienBib.TagCloud.CloudPainter.Paint(MedienBib.TagCloud.CurrentTagList);


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



function HandleSingleFileTagChange(aAudioFile: TAudioFile; TagToReplace: String; Out newTag: String; out IgnoreWarnings: Boolean): Boolean;
// TagToReplace =  '' -> add new tag (commas allowed)
// TagToReplace <> '' -> rename a existing tag (no cammas allowed)
var ClickedOK, askNoMore: Boolean;
    dlgresult: Integer;
begin
    result := False;
    if not assigned(aAudioFile) then
        exit;

    if aAudioFile.HasSupportedTagFormat then
    begin
        if TagToReplace = '' then
            ClickedOK := InputQuery(MainForm_AddTagQueryCaption, MainForm_AddTagQueryLabel, NewTag)
        else
            ClickedOK := InputQuery(MainForm_RenameTagQueryCaption, Format(MainForm_RenameTagQueryLabel, [TagToReplace]), NewTag);

        if ClickedOK and (Trim(NewTag) <> '') and (Trim(NewTag) <> TagToReplace) then
        // the third if is maybe just a duplicate, if we want to add a new tag
        begin
            if (TagToReplace <> '') and CommasInString(NewTag) then
                TranslateMessageDLG((TagManagement_RenameTagNoCommas), mtWarning, [MBOK], 0)
            else
            begin
                if (MedienBib.StatusBibUpdate <= 1)
                    and (MedienBib.CurrentThreadFilename <> aAudioFile.Pfad)
                then
                begin
                    case MedienBib.AddNewTagConsistencyCheck(aAudioFile, newTag) of

                        CONSISTENCY_OK:  begin
                                result := True;
                                if (TagToReplace <> '') then
                                    aAudioFile.RemoveTag( TagToReplace);
                                MedienBib.AddNewTag(aAudioFile, newTag, False);
                                IgnoreWarnings := False;
                        end;

                        CONSISTENCY_HINT: begin
                                result := True;
                                if (TagToReplace <> '') then
                                    aAudioFile.RemoveTag(TagToReplace);
                                MedienBib.AddNewTag(aAudioFile, newTag, False);
                                IgnoreWarnings := False;
                                // show information about changes, no user action  required, just "OK"
                                if MedienBib.ShowAutoResolveInconsistenciesHints then
                                begin
                                    askNoMore := not MedienBib.ShowAutoResolveInconsistenciesHints;
                                    MessageDlgWithNoMorebox
                                          ((TagManagementDialogOnlyHint_Caption),
                                          (TagManagementDialogOnlyHint_Text) + MedienBib.TagPostProcessor.LogList.Text ,
                                           mtInformation,
                                           [mbOK], mrOK, 0,
                                           asknomore, (TagManagementDialogOnlyHint_ShowAgain));
                                    MedienBib.ShowAutoResolveInconsistenciesHints := not asknomore;
                                end;
                        end;

                        CONSISTENCY_WARNING: begin
                                if MedienBib.AskForAutoResolveInconsistencies then
                                begin
                                    askNoMore := not MedienBib.AskForAutoResolveInconsistencies;
                                    dlgresult := MessageDlgWithNoMorebox
                                          ((TagManagementDialog_Caption),
                                          (TagManagementDialog_Text) + MedienBib.TagPostProcessor.LogList.Text ,
                                           mtWarning,
                                           [mbIgnore, mbCancel, mbOK], mrOK, 0,
                                           asknomore, (TagManagementDialog_ShowAgain));

                                    case dlgresult of
                                        mrIgnore: begin
                                            MedienBib.AutoResolveInconsistencies := False;
                                            result := True;
                                            if (TagToReplace <> '') then
                                                aAudioFile.RemoveTag(TagToReplace);
                                            MedienBib.AddNewTag(aAudioFile, newTag, True);
                                            IgnoreWarnings := True;
                                            MedienBib.AskForAutoResolveInconsistencies := not asknomore;
                                        end;
                                        mrOK: begin
                                            MedienBib.AutoResolveInconsistencies := True;
                                            result := True;
                                            if (TagToReplace <> '') then
                                                aAudioFile.RemoveTag(TagToReplace);
                                            MedienBib.AddNewTag(aAudioFile, newTag, False);
                                            IgnoreWarnings := False;
                                            MedienBib.AskForAutoResolveInconsistencies := not asknomore;
                                        end;
                                        mrCancel: begin
                                            result := False;
                                        end;
                                    end;
                                end else
                                begin
                                    // just da as the settings say
                                    result := true; //MedienBib.AutoResolveInconsistencies;
                                    if (TagToReplace <> '') then
                                        aAudioFile.RemoveTag(TagToReplace);
                                    MedienBib.AddNewTag(aAudioFile, newTag, not MedienBib.AutoResolveInconsistencies);
                                    IgnoreWarnings := not MedienBib.AutoResolveInconsistencies;
                                end;
                        end;
                    end;
                end else
                    TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
            end;
        end;
    end else
        TranslateMessageDLG((MainForm_TagNotSupportedFileFormat), mtWarning, [MBOK], 0);
end;

function HandleIgnoreRule(aTag: String): Boolean;
var askNoMore: Boolean;
    c, dlgresult: Integer;
begin
    result  := False;

    c := Medienbib.CountFilesWithTag(aTag);
    if c>1 then
    begin
        if TranslateMessageDLG((Format(TagManagement_FileCountWarning, [c])), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;
    end;

    case MedienBib.TagPostProcessor.AddIgnoreRuleConsistencyCheck(aTag) of

        CONSISTENCY_OK: begin
                result := True;
                MedienBib.TagPostProcessor.AddIgnoreRule(aTag, False);
        end;

        CONSISTENCY_HINT,
        CONSISTENCY_WARNING: begin
                if MedienBib.AskForAutoResolveInconsistenciesRules then
                begin
                    askNoMore := not MedienBib.AskForAutoResolveInconsistenciesRules;
                    dlgresult := MessageDlgWithNoMorebox
                          ((TagManagementDialog_Caption),
                          (TagManagementDialog_TextRules) + MedienBib.TagPostProcessor.LogList.Text ,
                           mtWarning,
                           [mbIgnore, mbCancel, mbOK], mrOK, 0,
                           asknomore, (TagManagementDialog_ShowAgain));

                    case dlgresult of
                        mrIgnore: begin
                            MedienBib.AutoResolveInconsistenciesRules := False;
                            MedienBib.TagPostProcessor.AddIgnoreRule(aTag, True);
                            result := True;
                            MedienBib.AskForAutoResolveInconsistenciesRules := not asknomore;
                        end;
                        mrOK: begin
                            MedienBib.AutoResolveInconsistenciesRules := True;
                            MedienBib.TagPostProcessor.AddIgnoreRule(aTag, False);
                            result := True;
                            MedienBib.AskForAutoResolveInconsistenciesRules := not asknomore;
                        end;
                        mrCancel: begin
                            result := False;
                        end;
                    end;
                end else
                begin
                    // just do as the settings say
                    result := true; //MedienBib.AutoResolveInconsistencies;
                    MedienBib.TagPostProcessor.AddIgnoreRule(aTag, not MedienBib.AutoResolveInconsistenciesRules);
                end;
        end;
    end;

    if result and assigned(CloudEditorForm) then
    begin
        CloudEditorForm.FillIgnoreTree;
        CloudEditorForm.FillMergeTree;
    end;
end;

function HandleMergeRule(aTag: String; out newTag: String): Boolean;
var ClickedOK, askNoMore: Boolean;
    c, dlgResult: Integer;
begin
    result := False;
    c := Medienbib.CountFilesWithTag(aTag);
    if c>1 then
    begin
        if TranslateMessageDLG((Format(TagManagement_FileCountWarning, [c])), mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            exit;
    end;

    ClickedOK := InputQuery(MainForm_RenameTagQueryCaption, Format(MainForm_RenameTagQueryLabel, [aTag]), NewTag);

    if ClickedOK and (Trim(NewTag) <> '') and (Trim(NewTag) <> aTag) then
    begin
        // seems to be a valid input at first sight
        if CommasInString(NewTag) then
            // ... but we do not allow a comma separated list of tags here
            TranslateMessageDLG((TagManagement_RenameTagNoCommas), mtWarning, [MBOK], 0)
        else
        begin
            // Actually try to update the merge rules
            case MedienBib.TagPostProcessor.AddMergeRuleConsistencyCheck(aTag, newTag) of

                CONSISTENCY_OK: begin
                        result := True;
                        MedienBib.TagPostProcessor.AddMergeRule(aTag, newTag, False)
                end;

                CONSISTENCY_HINT,
                CONSISTENCY_WARNING: begin
                        if MedienBib.AskForAutoResolveInconsistenciesRules then
                        begin
                            askNoMore := not MedienBib.AskForAutoResolveInconsistenciesRules;
                            dlgresult := MessageDlgWithNoMorebox
                                  ((TagManagementDialog_Caption),
                                  (TagManagementDialog_TextRules) + MedienBib.TagPostProcessor.LogList.Text ,
                                   mtWarning,
                                   [mbIgnore, mbCancel, mbOK], mrOK, 0,
                                   asknomore, (TagManagementDialog_ShowAgain));

                            case dlgresult of
                                mrIgnore: begin
                                    MedienBib.AutoResolveInconsistenciesRules := False;
                                    MedienBib.TagPostProcessor.AddMergeRule(aTag, newTag, True);
                                    result := True;
                                    MedienBib.AskForAutoResolveInconsistenciesRules := not asknomore;
                                end;
                                mrOK: begin
                                    MedienBib.AutoResolveInconsistenciesRules := True;
                                    MedienBib.TagPostProcessor.AddMergeRule(aTag, newTag, False);
                                    result := True;
                                    MedienBib.AskForAutoResolveInconsistenciesRules := not asknomore;
                                end;
                                mrCancel: begin
                                    result := False;
                                end;
                            end;
                        end else
                        begin
                            // just do as the settings say
                            result := True; //MedienBib.AutoResolveInconsistencies;
                            MedienBib.TagPostProcessor.AddMergeRule(aTag, newTag, not MedienBib.AutoResolveInconsistenciesRules);
                        end;
                end;
            end;
        end;
    end;
    if result and assigned(CloudEditorForm) then
    begin
        CloudEditorForm.FillIgnoreTree;
        CloudEditorForm.FillMergeTree;
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
    originalPath := Original.Pfad;

    // 1. Add Original itself
    Target.Add(Original);

    // 2. The Player-File
    if NeededFile(NempPlayer.MainAudioFile) then
        Target.Add(NempPlayer.MainAudioFile);

    // 3. The Detailform-File
    if assigned(fDetails) and NeededFile(fDetails.CurrentAudioFile) then
        Target.Add(fDetails.CurrentAudioFile);

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

procedure SyncAudioFilesWith(aAudioFile: TAudioFile);
var i: Integer;
    ListOfFiles: TObjectList;
begin
    ListOfFiles := TObjectList.Create(False);
    try
        GetListOfAudioFileCopies(aAudioFile, ListOfFiles);
        for i := 0 to ListOfFiles.Count - 1 do
            TAudioFile(ListOfFiles[i]).Assign(aAudioFile);
    finally
        ListOfFiles.Free;
    end;
end;

procedure DoSyncStuffAfterTagEdit(aAudioFile: TAudiofile; backupTag: UTF8String);
var aErr: TNempAudioError;
    BibFile: TAudioFile;
    newTags: UTF8String;
begin
    newTags := aAudioFile.RawTagLastFM;
    // Sync with ID3tags (to be sure, that no ID3Tags are deleted)
    aAudioFile.GetAudioData(aAudioFile.Pfad);
    aAudioFile.RawTagLastFM := newTags;

    aErr := aAudioFile.SetAudioData(Nemp_MainForm.NempOptions.AllowQuickAccessToMetadata);
    if aErr = AUDIOERR_None then
    begin
        aAudioFile.ID3TagNeedsUpdate := False;
        SyncAudioFilesWith(aAudioFile);
        // Correct GUI (player, Details, Detailform, VSTs))
        CorrectVCLAfterAudioFileEdit(aAudioFile);
        // Update the TagCloud
        BibFile := MedienBib.GetAudioFileWithFilename(aAudioFile.Pfad);
        if assigned(BibFile) then
            MedienBib.TagCloud.UpdateAudioFile(BibFile);
    end else
    begin
        aAudioFile.RawTagLastFM := backupTag;
        HandleError(afa_EditingDetails, aAudioFile, aErr);
        TranslateMessageDLG(AudioErrorString[aErr], mtWarning, [MBOK], 0);
    end;
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
procedure CorrectVCLAfterAudioFileEdit(aFile: TAudioFile; CheckTrees: Boolean=True);
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
        //Nemp_MainForm.ShowPlayerDetails(NempPlayer.MainAudioFile);
        Nemp_MainForm.DisplayPlayerMainTitleInformation(True);
        NempPlayer.RefreshPlayingTitel;
        Application.Title := NempPlayer.GenerateTaskbarTitel;
        Spectrum.DrawRating(NempPlayer.MainAudioFile.Rating);
        Nemp_MainForm.PaintFrame.Hint := NempPlayer.MainAudioFile.GetHint(Nemp_MainForm.NempOptions.ReplaceNAArtistBy,
                           Nemp_MainForm.NempOptions.ReplaceNATitleBy,
                           Nemp_MainForm.NempOptions.ReplaceNAAlbumBy);
    end;

    // ... VST-Details
    if SameFile(MedienBib.CurrentAudioFile) then
        Nemp_MainForm.ShowVSTDetails(MedienBib.CurrentAudioFile, -1);  // -1: Do not change Source (playlist/medienbib)) of audiofile

    // ... Detail-Form
    if assigned(fDetails)
        and Nemp_MainForm.AutoShowDetailsTMP
        and SameFile(fDetails.CurrentAudioFile)
    then
        // Note: a call of AktualisiereDetailForm(af, SD_MEDIENBIB)
        //       will produce some strange AVs here - so we do it quick&dirty with a timer
        //       (Probably some issues with VST.Edited and stuff. Don't know.)
        FDetails.ReloadTimer.Enabled := True;

    // TabWarning
    if CheckTrees then
    begin
        bibFile := MedienBib.GetAudioFileWithFilename(aFile.Pfad);
        if SameFile(bibFile) then
        begin
            if Not MedienBib.ValidKeys(bibFile) then
                SetBrowseTabWarning(True);
        end;
    end;
end;

procedure CorrectVCLForABRepeat;
var EnableControls: Boolean;
begin
    with Nemp_MainForm do
    begin
        ab1.Left := Round(NempPlayer.ABRepeatA * (SlideBarShape.Width)) + SlideBarShape.Left;
        ab2.Left := Round(NempPlayer.ABRepeatB * (SlideBarShape.Width)) + SlideBarShape.Left - ab2.Width;

        ab1.Visible := NempPlayer.ABRepeatActive and Nemp_MainForm.MainPlayerControlsActive;
        ab2.Visible := NempPlayer.ABRepeatActive and Nemp_MainForm.MainPlayerControlsActive;
        PM_ABRepeat.Checked := NempPlayer.ABRepeatActive;
    end;

    EnableControls   := Assigned(NempPlayer.MainAudioFile) and (not NempPlayer.MainAudioFile.isStream);
    Nemp_MainForm.PM_ABRepeat      .Enabled := EnableControls;
    Nemp_MainForm.PM_ABRepeatSetA  .Enabled := EnableControls;
    Nemp_MainForm.PM_ABRepeatSetB  .Enabled := EnableControls;

    if assigned(FormEffectsAndEqualizer) then
    begin
        // Hints anders setzen, wenn Headset-Anzeige? Buttons disabledn?
        //(* !!!!!!!!!!!!!! GUI !!!!!!!!!!!!!!!!!
        FormEffectsAndEqualizer.BtnABRepeatUnSet .Enabled := NempPlayer.ABRepeatActive and EnableControls;
        FormEffectsAndEqualizer.BtnABRepeatSetA  .Enabled := EnableControls;
        FormEffectsAndEqualizer.BtnABRepeatSetB  .Enabled := EnableControls;
        //*)
    end;
end;

procedure SwapABImagesIfNecessary(FixedImage: TImage);
var swapImg: TImage;
    ProgressStart, ProgressEnd: double;
begin
    /// The Snyc-Positions for the two buttons are different
    ///  We cannot work just with left/right here
    /// Start:    (ABRepeatStartImg.Left - SlideBarShape.Left) / (SlideBarShape.Width),
    /// End:      (ABRepeatEndImg.Left + ABRepeatEndImg.Width - SlideBarShape.Left) / (SlideBarShape.Width)

    with Nemp_MainForm do
    begin
        ProgressStart := (ABRepeatStartImg.Left - SlideBarShape.Left) / (SlideBarShape.Width);
        ProgressEnd   := (ABRepeatEndImg.Left + ABRepeatEndImg.Width - SlideBarShape.Left) / (SlideBarShape.Width);

        if ProgressStart > ProgressEnd then
        begin

            if FixedImage = ABRepeatStartImg then
                // we are dragging the (old, current) StartImage beyond the EndImage
                // => EndImage becomes the new StartImage
                ABRepeatEndImg.Left := ABRepeatEndImg.Left + ABRepeatEndImg.Width
            else
                //we are dragging the (old, current) EndImage before the StartImage
                ABRepeatStartImg.Left := ABRepeatStartImg.Left - ABRepeatStartImg.Width;

            // swap AB-Images
            swapImg := ABRepeatStartImg;
            ABRepeatStartImg := ABRepeatEndImg;
            ABRepeatEndImg := swapImg;

            ABRepeatStartImg.Picture.Assign(Nil);
            ABRepeatEndImg.Picture.Assign(Nil);

            ABRepeatStartImg.Picture.Assign(NempSkin.ABRepeatBitmapA);
            ABRepeatEndImg.Picture.Assign(NempSkin.ABRepeatBitmapB);
        end;
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
                // Browsing by tagcloud activated
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

procedure SetGlobalWarningID3TagUpdate;
var c: Integer;
begin
    c := Medienbib.CountInconsistentFiles;
    Nemp_MainForm.MM_Warning_ID3Tags.Caption := Format(MediaLibrary_InconsistentFilesCaption, [c]);
    Nemp_MainForm.MM_Warning_ID3Tags.Visible := c > 0;
    Nemp_MainForm.MM_Warning_ID3Tags.Tag := c;

    if assigned(CloudEditorForm) then
    begin
        CloudEditorForm.LblUpdateWarning.Caption := Format(TagEditor_FilesNeedUpdate, [c]);
        CloudEditorForm.LblUpdateWarning.Visible := c > 0;
        CloudEditorForm.BtnUpdateID3Tags.Enabled := c > 0;
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
          //Spectrum.DrawText(NempPlayer.PlayingTitel,False);
          PlayerTimeLbl.Caption := '00:00'; //Spectrum.DrawTime('00:00');
          fspTaskbarPreviews1.InvalidatePreview;
        end;
        Application.Title := NempPlayer.GenerateTaskbarTitel;
        PlaylistVST.Invalidate;
        CorrectVCLForABRepeat;
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

function GetFileListForClipBoardFromTree(aTree: TVirtualStringTree): String;
var
  idx, maxC: integer;
  SelectedMP3s: TNodeArray;
  Data: PTreeData;
begin
    result := '';
    SelectedMP3s := aTree.GetSortedSelection(False);

    maxC := min(Nemp_MainForm.NempOptions.maxDragFileCount, length(SelectedMp3s));
    if length(SelectedMp3s) > Nemp_MainForm.NempOptions.maxDragFileCount then
        AddErrorLog(Format(Warning_TooManyFiles, [Nemp_MainForm.NempOptions.maxDragFileCount]));

    for idx := 0 to maxC - 1 do
    begin
        Data := aTree.GetNodeData(SelectedMP3s[idx]);
        if FileExists(Data^.FAudioFile.Pfad) then
            result := result + Data^.FAudioFile.Pfad + #0;
        if (  (assigned(Data^.FAudioFile.CueList)) or (Data^.FAudioFile.Duration >  MIN_CUESHEET_DURATION)  )
           AND FileExists(ChangeFileExt(Data^.FAudioFile.Pfad, '.cue'))
        then
            result := result + ChangeFileExt(Data^.FAudioFile.Pfad, '.cue') + #0;
    end;
end;

// this is called after a succesful call of GetFileListForClipBoardFromTree
// so we do not need the MAX_DRAGFILECOUNT-Check here
function WritePlaylistForClipBoard(aTree: TVirtualStringTree): String;
var
    idx: integer;
    SelectedMP3s: TNodeArray;
    Data: PTreeData;
    af: TAudioFile;
    tmpPlaylist: TStringList;
    m3u8Needed: Boolean;
    tmpAnsi: AnsiString;
    tmpUnicode: UnicodeString;
    fn: String;
begin
    SelectedMP3s := aTree.GetSortedSelection(False);

    // we save the files as an m3u-List (or m3u8, if needed)
    tmpPlaylist := TStringList.Create;
    try
        tmpPlaylist.Add('#EXTM3U');
        for idx := 0 to length(SelectedMP3s)-1 do
        begin

            Data := aTree.GetNodeData(SelectedMP3s[idx]);
            af := Data^.FAudioFile;
            if FileExists(af.Pfad) then
            begin
                // Add File to Playlist
                tmpPlaylist.add('#EXTINF:' + IntTostr(af.Duration) + ','
                    + af.Artist + ' - ' + af.Titel);
                // but only the filename here, without the path
                // all the files (including this playlist-file) will be copied to the same directory
                tmpPlaylist.Add(af.Dateiname);
            end;
        end;

        // save Playlist
        tmpUnicode := tmpPlaylist.Text;
        tmpAnsi := AnsiString(tmpUnicode);
        m3u8Needed := (tmpUnicode <> UnicodeString(tmpAnsi));

        try
            if m3u8Needed then
            begin
                fn := SavePath + '000-Playlist.m3u8';
                tmpPlaylist.SaveToFile(fn, TEncoding.UTF8);
            end
            else
            begin
                fn := SavePath + '000-Playlist.m3u';
                tmpPlaylist.SaveToFile(fn, TEncoding.Default);
            end;
        except
            // we couldnt save the temporary file
            // return empty filename
            fn := '';
        end;

        result := fn;
    finally
        tmpPlaylist.Free;
    end;

end;


procedure AddErrorLog(aString: String);
begin
    ErrorLog.Add(aString);

    if assigned(FError) and Ferror.Visible then
    begin
        if ErrorLogCount = 0 then
            FError.Memo_Error.Lines.Clear;
        FError.Memo_Error.Lines.Add(aString);
    end;

    inc(ErrorLogCount);
    //Nemp_MainForm.MM_H_ErrorLog.Caption := Format(MainForm_MainMenu_Messages, [ErrorLogCount]);
    if not Nemp_MainForm.MM_H_ErrorLog.Visible then
        Nemp_MainForm.MM_H_ErrorLog.Visible := True;
end;

procedure HandleError(aAction: TAudioFileAction; aFile: TAudioFile; aErr: TNempAudioError; Important: Boolean = false);  overload;
var s: String;
begin
    if aErr <> AUDIOERR_None then
    begin

        case aAction of
          afa_None:           s := '';
          afa_SaveRating:     s := 'Note: Rating Not saved into file: '  ;
          afa_RefreshingFileInformation: s := 'Error while refreshing file information: '  ;
          afa_AddingFileToLibrary: s := 'Error while adding file to library: '  ;
          afa_PasteFromClipboard:  s := 'Error while Copy&Paste from clipboard: '  ;
          afa_DroppedFiles:        s := 'Error while Drag&Drop files: '  ;
          afa_NewFile:             s := 'Error with new found file: '  ;
          afa_DirectEdit:          s := 'Error while editing file properties directly: '  ;
          afa_EditingDetails:      s := 'Error while editing file properties '  ;
          afa_LyricSearch:         s := 'Error while searching lyrics: ' ;
          afa_TagSearch:           s := 'Error while searching additional Tags: ';
          afa_TagCloud:            s := 'Error while updating the Tagcloud: '
        end;
        if assigned(aFile) then
            s := s + aFile.Pfad;
        s := s + #13#10;
        s := s + 'Errormessage: ' + AudioErrorString[aErr] + #13#10
           + '------';

        case aErr of
          AUDIO_FILEERR_NoFile,
          AUDIO_FILEERR_FOpenCrt,
          AUDIO_FILEERR_FOpenR,
          AUDIO_FILEERR_FOpenRW,
          AUDIO_FILEERR_FOpenW,
          AUDIO_FILEERR_SRead,
          AUDIO_FILEERR_SWrite,
          AUDIO_ID3ERR_Cache,
          AUDIO_ID3ERR_NoTag,
          AUDIO_ID3ERR_Invalid_Header,
          AUDIO_ID3ERR_Compression,
          AUDIO_ID3ERR_Unclassified,
          AUDIO_MPEGERR_NoFrame,
          AUDIO_OVErr_InvalidFirstPageHeader,
          AUDIO_OVErr_InvalidFirstPage,
          AUDIO_OVErr_InvalidSecondPageHeader,
          AUDIO_OVErr_InvalidSecondPage,
          AUDIO_OVErr_CommentTooLarge,
          AUDIO_OVErr_BackupFailed,
          AUDIO_OVErr_DeleteBackupFailed,
          AUDIO_FlacErr_InvalidFlacFile,
          AUDIO_FlacErr_MetaDataTooLarge,
          AUDIOERR_DriveNotReady,
          AUDIOERR_NoAudioTrack,
          AUDIOERR_Unkown:            AddErrorLog(s);   // Post always, this is something strange


          AUDIOERR_UnsupportedMediaFile,
          AUDIOERR_EditingDenied: if Important then AddErrorLog(s);
          else
              AddErrorLog(s);
        end;
    end;
end;

function GetSpecialPermissionToChangeMetaData:Boolean;
begin
    with Nemp_MainForm do
    begin
        if Not NempOptions.AllowQuickAccessToMetadata then
        begin
            // User dont want Files to be changed. But this is necessary here.
            // so get a special permission (or cancel the process)
            if TranslateMessageDLG((MediaLibrary_PermissionToChangeTagsRequired)
               , mtConfirmation, [MBYes, MBNo], 0, mbNo) = mrYes
            then
                result := True
            else
            begin
                result := False;
                TranslateMessageDLG(MediaLibrary_OperationCancelled, mtInformation, [mbOK], 0);
            end;
        end else
            result := True;
    end;
end;


procedure SetSkinRadioBox(aName: String);
var i: Integer;
    captionString: String;
begin
    with Nemp_MainForm do
    begin
        if aName = '' then
        begin
            MM_O_Skins_WindowsStandard.Checked := True;
            PM_P_Skins_WindowsStandard.Checked := True;

            for i := 3 to MM_O_Skins.Count - 1 do
                MM_O_Skins.Items[i].Checked := False;

            for i := 3 to PM_P_Skins.Count - 1 do
                PM_P_Skins.Items[i].Checked := False;
        end else
        begin
            captionString := StringReplace(aName,'&','&&',[rfReplaceAll]);
            MM_O_Skins_WindowsStandard.Checked := False;
            PM_P_Skins_WindowsStandard.Checked := False;

            for i := 3 to MM_O_Skins.Count - 1 do
            begin
                if MM_O_Skins.Items[i].Caption = captionString then
                    MM_O_Skins.Items[i].Checked := True;
            end;

            for i := 3 to PM_P_Skins.Count - 1 do
            begin
                if PM_P_Skins.Items[i].Caption = captionString then
                    PM_P_Skins.Items[i].Checked := True;
            end;
        end;
    end;
end;


end.
