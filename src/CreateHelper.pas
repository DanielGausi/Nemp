{

    Unit CreateHelper

    - Things that need to be done on Create of the mainform

    The previous methods has been really confusing, and caused some trouble
    with the Win7-Buttons in the taskbar.

    This here should work properly.

    Note: "StuffToDoAfterCreate" is called from the project-file

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

unit CreateHelper;

{$I xe.inc}

interface

    uses Forms, Windows, Graphics, Classes, Menus, Controls, SysUtils, IniFiles, VirtualTrees, Messages,
    dialogs, shellApi, ID3GenreList, ActiveX, OneInst, MainFormlayout, System.IOUtils, System.Types
    {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF};


    procedure UpdateSplashScreen(status: String);

    procedure StuffToDoAfterCreate;

    procedure InitializeCoverflow;

    procedure InitializeNempSkin;

implementation

uses NempMainUnit, Splash, gnugettext, PlaylistClass, PlayerClass,
    MedienbibliothekClass, Nemp_SkinSystem, NempPanel,
    Nemp_ConstantsAndTypes, NempApi, NempAudioFiles, Nemp_RessourceStrings,
    MainFormHelper, UpdateUtils, SystemHelper, TreeHelper, languagecodes,
    SplitForm_Hilfsfunktionen, DriveRepairTools, NempCoverFlowClass,

    MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, PlaylistUnit, FHeadsetControl,
    WindowsVersionInfo, AudioDisplayUtils, MyDialogs, NempHelp, NempSpectrum,
    Cover.ViewCache, fConfigErrorDlg;


procedure UpdateSplashScreen(status: String);
begin
    if Assigned(FSplash) then
    begin
        FSplash.StatusLBL.Caption := (status);
        FSplash.Update;
    end;
end;

function LoadSettings: Boolean;
var colIdx: Integer;
    aMenuItem: TMenuItem;
    tmpwstr, g15path: UnicodeString;

begin
    UpdateSplashScreen(SplashScreen_LoadingPreferences);
    with Nemp_MainForm do
    begin
        // result is the lastExit-Value
        result := NempSettingsManager.LastExitOK;

        NempOptions.LoadSettings(FOwnMessageHandler);
        if NempOptions.ShowSplashScreen then
        begin
            FSplash.Show;
            FSplash.Update;
        end;
        LoadWindowPosition; // Nemp_MainForm

        NempLayout.LoadSettings;

        TDrivemanager.LoadSettings;
        NempDisplay.LoadSettings;

        if NempOptions.Language = '' then
            // overwrite the default setting with the curent system language
            NempOptions.Language := GetCurrentLanguage;

        if (NempOptions.Language <> GetCurrentLanguage) then // and (NempOptions.Language <> '') and
            Uselanguage(NempOptions.Language);

        g15path := ExtractFilepath(paramStr(0)) + NempOptions.DisplayApp;
        if NempOptions.UseDisplayApp and (NempOptions.DisplayApp <> '') and FileExists(g15Path) then
            shellexecute(Handle,'open',pchar('"' + g15Path + '"'),'autostart', Nil, sw_hide);

        //Player-Einstellungen lesen
        NempPlayer.LoadSettings;
        // Copy AllowQuickAccessToMetadata-Setting to the PostProcessor
        NempPlayer.PostProcessor.WriteToFiles := NempOptions.AllowQuickAccessToMetadata;

        //Player initialisieren, Load Plugins.
        NempPlayer.InitBassEngine(FOwnMessageHandler, ExtractFilePath(ParamStr(0)) + 'Bass\', tmpwstr);



        // VCL an den Player anpassen
        PlaylistDateienOpenDialog.Filter := tmpwstr;

        //Playlist-Einstellungen laden
        NempPlaylist.LoadSettings;
        // MedienBib-Einstellungen laden
        MedienBib.LoadSettings;
        NempLayout.BrowseMode := MedienBib.BrowseMode;

        VSTColumns_LoadSettings(VST);

        colIdx := VST.Header.Columns.GetFirstColumn;
        while colIdx >= 0 do begin
          aMenuItem := TMenuItem.Create(Nemp_MainForm);
          aMenuItem.AutoHotkeys := maManual;
          aMenuItem.AutoCheck := True;
          aMenuItem.Tag := colIdx;
          aMenuItem.OnClick := VST_ColumnPopupOnClick;
          aMenuItem.Caption := VST.Header.Columns[colIdx].Text; // _(DefaultSpalten[s].Bezeichnung);
          VST_ColumnPopup.Items.Insert(VST.Header.Columns[colIdx].Position, aMenuItem);

          colIdx := VST.Header.Columns.GetNextColumn(colIdx);
        end;

        NempUpdater.LoadSettings;
        NempSkin.NempPartyMode.LoadSettings;

        CoverManager.LoadSettings;
        DummyImageList.Width := CoverManager.CoverSize;
        CoverManagerHint.LoadSettingsHintCover;

        Tag := -1;

        // Jetzt: False in die Ini reinschreiben
        // Das wird erst am Ende wieder "gut gemacht" ;-)
        NempSettingsManager.LastExitOK := False;
        NempSettingsManager.WriteToDisk;
    end;
end;

procedure SearchSkins;
var SR: TSearchrec;
    aMenuItem: TMenuItem;
    tmpstr: String;
begin
    UpdateSplashScreen(SplashScreen_SearchSkins);
    with Nemp_MainForm do
    begin
        MM_O_Skin_UseAdvanced.Checked := NempOptions.GlobalUseAdvancedSkin;
        PM_P_Skin_UseAdvancedSkin.Checked := NempOptions.GlobalUseAdvancedSkin;
        // Skin-MenuItems setzen
        if (FindFirst(ExtractFilePath(Paramstr(0)) + 'Skins\' +'*',faDirectory,SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
          begin
              tmpstr :=  StringReplace(Sr.Name, '&', '&&', [rfReplaceAll]);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr;
              PM_P_Skins.Add(aMenuItem);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr;
              MM_O_Skins.Add(aMenuItem);
          end;
        until FindNext(SR)<>0;
        FindClose(SR);
    end;
end;

procedure SearchLanguages;
var aMenuItem: TMenuItem;
    tmpstr: String;
    i: Integer;
begin
    UpdateSplashScreen(SplashScreen_SearchSkins);
    with Nemp_MainForm do
    begin
        // installierte Sprachen suchen
        LanguageList := TStringlist.Create;
        DefaultInstance.GetListOfLanguages ('default',LanguageList);
        for i := 0 to LanguageList.Count - 1 do
        begin
            tmpstr := getlanguagename(LanguageList[i]);

            aMenuItem := TMenuItem.Create(Nemp_MainForm);
            aMenuItem.AutoHotkeys := maManual;
            aMenuItem.OnClick := ChangeLanguage;
            if  tmpstr <> '' then
              aMenuItem.Caption := tmpstr
            else
              aMenuItem.Caption := '(?)';
            aMenuItem.Tag := i;
            MM_O_Languages.Add(aMenuItem);

            aMenuItem := TMenuItem.Create(Nemp_MainForm);
            aMenuItem.AutoHotkeys := maManual;
            aMenuItem.OnClick := ChangeLanguage;
            if  tmpstr <> '' then
              aMenuItem.Caption := tmpstr
            else
              aMenuItem.Caption := '(?)';
            aMenuItem.Tag := i;
            PM_P_Languages.Add(aMenuItem);
        end;
    end;
end;

procedure SaveResourceAsFile(resID, TargetFilename: String);
var
  Stream: TResourceStream;
begin
  Stream := TResourceStream.Create(HInstance, resID, RT_RCDATA);
  try
    Stream.SaveToFile(TargetFilename);
  finally
    Stream.Free;
  end;
end;

procedure SearchDSPPlugins;
var
  aMenuItem: TMenuItem;
  i: Integer;
  pluginPath: String;


  procedure ClearMenu(aMenuItem: TMenuItem);
  const
    FixedMenuItemCount = 4;
  begin
    for var i:Integer := aMenuItem.Count - 1 - FixedMenuItemCount downto 0 do
      aMenuItem.Delete(0);
  end;

begin
  if not NempPlayer.ActivateDSPPlugins then begin
    with Nemp_MainForm do begin
      MM_T_Plugins.Visible := False;
      PM_P_Plugins.Visible := False;
    end;

  end else begin
    with Nemp_MainForm do begin
      TStyleManager.SystemHooks := [shMenus, shToolTips]; // no shDialogs, that will interfere with Plugin Forms

      pluginPath := IncludeTrailingPathdelimiter(NempSettingsManager.SavePath) + 'Plugins\';

      if not DirectoryExists(pluginPath) then
        ForceDirectories(pluginPath);
      if DirectoryExists(PluginPath) and (not FileExists(pluginPath + 'How to add Winamp DSP Plugins.txt')) then
        SaveResourceAsFile('WinampDSP', pluginPath + 'How to add Winamp DSP Plugins.txt');

      NempPlayer.InitWinampDSPPlugins(Application.Handle, pluginPath);
      MM_T_Plugins.Visible := True;
      PM_P_Plugins.Visible := True;
      PM_T_Plugins.Visible := True;
      // MM_T_Plugins.Clear;
      // PM_P_Plugins.Clear;
      ClearMenu(MM_T_Plugins);
      ClearMenu(PM_P_Plugins);
      ClearMenu(PM_T_Plugins);

      for i := 0 to NempPlayer.DSPPluginFilenames.Count - 1 do begin
        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := ActivateDSPPlugin;
        aMenuItem.Caption := NempPlayer.DSPPluginFilenames.ValueFromIndex[i];
        aMenuItem.Tag := i;
        MM_T_Plugins.Insert(i, aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := ActivateDSPPlugin;
        aMenuItem.Caption := NempPlayer.DSPPluginFilenames.ValueFromIndex[i];
        aMenuItem.Tag := i;
        PM_P_Plugins.Insert(i, aMenuItem);

        aMenuItem := TMenuItem.Create(Nemp_MainForm);
        aMenuItem.AutoHotkeys := maManual;
        aMenuItem.OnClick := ActivateDSPPlugin;
        aMenuItem.Caption := NempPlayer.DSPPluginFilenames.ValueFromIndex[i];
        aMenuItem.Tag := i;
        PM_T_Plugins.Insert(i, aMenuItem);
      end;
    end;
  end;
end;

procedure AutoLoadPlaylist(LastExitOK: Boolean);
begin
    with Nemp_MainForm do
    begin
        if (NOT LastExitOK) AND
           ( FileExists(NempSettingsManager.SavePath + 'temp.npl') or
             FileExists(NempSettingsManager.SavePath + 'temp.m3u8') or
             FileExists(NempSettingsManager.SavePath + 'temp.m3u'))
        then begin
                UpdateSplashScreen(SplashScreen_Loadingplaylist);

                if FileExists(NempSettingsManager.SavePath + 'temp.npl') then
                    NempPlaylist.LoadFromFile(NempSettingsManager.SavePath + 'temp.npl')
                else
                    if FileExists(NempSettingsManager.SavePath + 'temp.m3u8') then
                        NempPlaylist.LoadFromFile(NempSettingsManager.SavePath + 'temp.m3u8')
                    else
                        NempPlaylist.LoadFromFile(NempSettingsManager.SavePath + 'temp.m3u');
        end else // backup existiert nicht oder tmplastexit war False
        begin
            if   (FileExists(NempSettingsManager.SavePath +  NEMP_NAME + '.npl')
               or FileExists(NempSettingsManager.SavePath +  NEMP_NAME + '.m3u8')
               or FileExists(NempSettingsManager.SavePath +  NEMP_NAME + '.m3u') ) then
            begin
                UpdateSplashScreen(SplashScreen_Loadingplaylist);

                if FileExists(NempSettingsManager.SavePath +  NEMP_NAME + '.npl') then
                    NempPlaylist.LoadFromFile(NempSettingsManager.SavePath +  NEMP_NAME + '.npl')
                else
                    if FileExists(NempSettingsManager.SavePath +  NEMP_NAME + '.m3u8') then
                        NempPlaylist.LoadFromFile(NempSettingsManager.SavePath +  NEMP_NAME + '.m3u8')
                    else
                        NempPlaylist.LoadFromFile(NempSettingsManager.SavePath +  NEMP_NAME + '.m3u');
            end;
        end;
    end;
end;

procedure AutoLoadBib;
begin
    UpdateSplashScreen(SplashScreen_LoadingMediaLib);
    with Nemp_MainForm do
    begin
        if MedienBib.AutoLoadMediaList then
        begin
            // create the jobs first - just in case "loading" (which runs in another thread) is veeeery fast
            if Medienbib.AutoScanDirs then
                Medienbib.AddStartJob(JOB_AutoScanNewFiles, '');
            if Medienbib.AutoDeleteFiles then
                Medienbib.AddStartJob(JOB_AutoScanMissingFiles, '');
            if Medienbib.AutoActivateWebServer then
                MedienBib.AddStartJob(JOB_StartWebServer, '');
            //Finalization
            MedienBib.AddStartJob(JOB_Finish, '');

            LblEmptyLibraryHint.Caption := MainForm_LibraryIsLoading;
            MedienBib.LoadFromFile(NempSettingsManager.SavePath + NEMP_NAME + '.gmp', True);
        end
        else
        begin
            LblEmptyLibraryHint.Caption := MainForm_LibraryIsEmpty;

            if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
                MedienBib.ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
            else
                if FileExists(NempSettingsManager.SavePath + 'default.nwl') then
                    MedienBib.ImportFavorites(NempSettingsManager.SavePath + 'default.nwl');

            MedienBib.ReBuildCategories;
            ReFillBrowseTrees(False);
        end;
    end;
end;


procedure ApplySettings;
var maxFont: integer;
begin
    UpdateSplashScreen(SplashScreen_InitPlayer);

    AuswahlForm.InitForm(nfBrowse, Nemp_MainForm);
    ExtendedControlForm.InitForm(nfExtendedControls, Nemp_MainForm);
    MedienlisteForm.InitForm(nfMediaLibrary, Nemp_MainForm);
    PlaylistForm.InitForm(nfPlaylist, Nemp_MainForm);


    with Nemp_MainForm do
    begin
        // TabStops setzen
        SetTabStopsPlayer;
        SetTabStopsTabs;

        WalkmanModeTimer.Enabled := NempPlayer.UseWalkmanMode;

        // Hier auch Scrobbler.Checked setzen
        MM_T_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;
        PM_P_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;

        //CB_MedienBibGlobalQuickSearch.OnClick := Nil;
        //CB_MedienBibGlobalQuickSearch.OnClick := CB_MedienBibGlobalQuickSearchClick;
        // EditFastSearch.Text := MainForm_GlobalQuickSearch;
        EditFastSearch.Hint := MainForm_GlobalQuickSearchHint;

        EditPlaylistSearch.Hint := MainForm_PlaylistSearchHint;
        TabBtn_Marker.Hint := MainForm_MarkerBtnHint;

        // Optionen verarbeiten, Variablen entsprechend setzen
        actToggleStayOnTop.Checked := NempOptions.MiniNempStayOnTop;

        if NempOptions.FullRowSelect then
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions + [toFullRowSelect]
        else
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions - [toFullRowSelect];

        //if NempOptions.EditOnClick then
            VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toEditOnClick];
        //else
        //    VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions - [toEditOnClick];

        VST.ShowHint := MedienBib.ShowHintsInMedialist;
        PlaylistVST.ShowHint := MedienBib.ShowHintsInMedialist; //NempPlaylist.ShowHintsInPlaylist;
        ArtistsVST.DefaultNodeHeight := NempOptions.ArtistAlbenRowHeight;
        AlbenVST.DefaultNodeHeight   := NempOptions.ArtistAlbenRowHeight;
        ArtistsVST.Font.Size         := NempOptions.ArtistAlbenFontSize;
        AlbenVST.Font.Size           := NempOptions.ArtistAlbenFontSize;
        VST.DefaultNodeHeight         := NempOptions.RowHeight;
        PlaylistVST.DefaultNodeHeight := NempOptions.RowHeight;
        if NempOptions.ChangeFontSizeOnLength then
            maxFont := MaxFontSize(NempOptions.DefaultFontSize)
        else
            maxFont := NempOptions.DefaultFontSize;

        PlaylistVST.Canvas.Font.Size := maxFont;
        PlaylistVST.Header.Columns[2].Width := PlaylistVST.Canvas.TextWidth('@99:99hm');
        PlaylistVST.Header.Columns[0].Width := PlaylistVST.Canvas.TextWidth('12345');
        RefreshPlaylistVSTHeader;

        VST.Font.Size := NempOptions.DefaultFontSize;
        PlaylistVST.Font.Size := NempOptions.DefaultFontSize;
        if Screen.Fonts.IndexOf(NempOptions.FontNameVBR) = -1 then
            NempOptions.FontNameVBR := VST.Font.Name;
        if Screen.Fonts.IndexOf(NempOptions.FontNameCBR) = -1 then
            NempOptions.FontNameCBR := VST.Font.Name;
        VST.Header.SortColumn := MedienBib.Sortparams[0].Tag;

        RandomBtn.Hint := NempPlaylist.WiedergabeModeHint;
        BassTimer.Interval := NempPlayer.VisualizationInterval;
        AutoSavePlaylistTimer.Enabled := True; // NempPlaylist.AutoSave;
        AutoSavePlaylistTimer.Interval := 5 * 60000;

        if NempOptions.RegisterHotKeys then
            NempOptions.InstallHotkeys;
        if NempOptions.RegisterMediaHotkeys then
            NempOptions.InstallMediakeyHotkeys(NempOptions.IgnoreVolumeUpDownKeys);

        NempSpectrum.DrawMode := sdmGradientBars;
        NempSpectrum.FallSpeedBars := 3;
        NempSpectrum.FallSpeedPeaks := 1;
        NempSpectrum.ColorPeak := clBackground;
        NempSpectrum.ColorBar1 := clBackground;
        NempSpectrum.ColorBar2 := clActiveCaption;

        // Spectrum.Mode := 1;
        (*Spectrum.LineFallOff := 7;
        Spectrum.PeakFallOff := 1;
        Spectrum.Pen := clActiveCaption;
        Spectrum.Peak := clBackground;
        Spectrum.BackColor := clBtnFace;
        // Spectrum.ScrollDelay := NempPlayer.ScrollAnzeigeDelay;
        Spectrum.DrawClear;
        *)
        // moved to CreateHelper.InitializeCoverflow
        // MedienBib.NewCoverFlow.ApplySettings;
    end;
end;

procedure InitializeNempSkin;
var
  i: Integer;
begin

  Nemp_MainForm.NempSkin.ArtistsVST   := Nemp_MainForm.ArtistsVST ;
  Nemp_MainForm.NempSkin.AlbenVST     := Nemp_MainForm.AlbenVST   ;
  Nemp_MainForm.NempSkin.MainVST      := Nemp_MainForm.VST        ;
  Nemp_MainForm.NempSkin.PlaylistVST  := Nemp_MainForm.PlaylistVST;

  Nemp_MainForm.NempSkin.VclMenuImages  := Nemp_MainForm.vilIconsWindows;
  Nemp_MainForm.NempSkin.SkinMenuImages := Nemp_MainForm.vilIconsSkin;

  Nemp_MainForm.NempSkin.PanelList.Clear;
  Nemp_MainForm.NempSkin.MenuList.Clear;
  Nemp_MainForm.NempSkin.ControlButtonList.Clear;

  for i := 0 to Nemp_MainForm.ComponentCount - 1 do
  begin
    if Nemp_MainForm.Components[i] is TNempPanel then
      Nemp_MainForm.NempSkin.PanelList.Add(TNempPanel(Nemp_MainForm.Components[i]))
    else
      if Nemp_MainForm.Components[i] is TMenu then
        Nemp_MainForm.NempSkin.MenuList.Add(TMenu(Nemp_MainForm.Components[i]))
  end;
  Nemp_MainForm.NempSkin.PanelList.Add(AuswahlForm.ContainerPanelAuswahlform);
  Nemp_MainForm.NempSkin.PanelList.Add(MedienListeForm.ContainerPanelMedienBibForm);
  Nemp_MainForm.NempSkin.PanelList.Add(PlaylistForm.ContainerPanelPlaylistForm);
  Nemp_MainForm.NempSkin.PanelList.Add(ExtendedControlForm.ContainerPanelExtendedControlsForm);

  // Player control Buttons
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.PlayPauseBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.StopBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.PlayPrevBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.PlayNextBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.SlideBackBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.SlideForwardBTN);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.RecordBtn);
  Nemp_MainForm.NempSkin.ControlButtonList.Add(Nemp_MainForm.RandomBtn);

  // Tab Buttons
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Cover);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_SummaryLock);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Equalizer);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Playlist);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Medialib);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Headset);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_mainForm.TabBtn_Marker);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_mainForm.TabBtn_Favorites);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_mainForm.TabBtnCoverCategory);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_mainForm.TabBtnTagCloudCategory);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Browse0);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_CoverFlow0);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_TagCloud0);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Preselection0);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Browse1);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_CoverFlow1);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_TagCloud1);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Preselection1);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Browse2);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_CoverFlow2);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_TagCloud2);
  Nemp_MainForm.NempSkin.TabButtonList.Add(Nemp_MainForm.TabBtn_Preselection2);

end;

procedure ApplyLayout;
begin
    NempLayout.BuildMainForm(nil);
    with Nemp_MainForm do
    begin
        // Ggf. Tray-Icon erzeugen und das erzeugen in TrayIconAdded merken
        NempTrayIcon.Visible := NempOptions.ShowTrayIcon;

        InitializeNempSkin;
        ActivateSkinAfterStart;
       (* if NempOptions.Useskin then
        begin
            SetSkinRadioBox(NempOptions.SkinName);
            Nempskin.LoadFromDir(GetSkinDirFromSkinName(NempOptions.SkinName));
            NempSkin.ActivateSkin(False);
            RandomBtn.ImageName := cBtnRepeatNames[NempPlaylist.WiedergabeMode];
        end else
        begin
            SetSkinRadioBox('');
            NempSkin.DeActivateSkin(False);
            // TabBtn_Equalizer.ResetGlyph;  // SKIN_UMBAU_CHECK
        end;
        *)

        // Anzeige oben links initialisieren
        SwitchBrowsePanel(MedienBib.BrowseMode, True);

        TabBtn_SummaryLock.Tag       := NempOptions.VSTDetailsLock;
        TabBtn_SummaryLock.ImageName := cTabBtnLockViewImgNames[TabBtn_SummaryLock.Tag];

        NempOptions.StartMinimizedByParameter := False;

        if (ParamCount = 0) or (trim(paramstr(1)) = '/minimized') or (trim(paramstr(1)) = '/safemode') then
        begin
            if trim(paramstr(1)) = '/minimized' then
                NempOptions.StartMinimizedByParameter := True;
            NempPlaylist.InitPlayingFile(True);
        end else
        begin
            // Forget the Loaded fPlayingIndex from the Ini (if wanted)
            NempPlaylist.OverwritePlayingIndexWithMaxCount;

            if ParamCount >= 2 then
            begin
                if trim(paramstr(1)) = '/play' then                             // Hier wirklich Startplay = True
                    ProcessCommandline(paramstr(2), True, False)               // Das bewirkt, dass das Playingfile gesetzt
                else                                                            // wird. Wenn Autoplay True ist, wird
                    if trim(paramstr(1)) = '/enqueue' then                      // die Wiedergabe gestartet, sonst nicht!!
                        ProcessCommandline(paramstr(2), True, True);
            end else
            begin
                if paramstr(1) = '/safemode' then
                    // nothing
                else
                    ProcessCommandline(paramstr(1), True, True);
            end;
        end;
    end;
end;

procedure CheckWriteAccess;
var
  cfgIni: TMemIniFile;
begin
    if NempSettingsManager.WriteAccessPossible then
    exit;

  // write access is not possible: Nemp will not function as intended
  if UseUserAppData then
    // rather unlikely. UserPath should be always accessible
    AddErrorLog(WriteAccessNotPossibleUserPath)
  else
  begin
    // the file "UseLocalData.cfg" exists, indicating portable mode
    // - likely cause for this issue: The user unzipped the portable archive to "c:\progam files"
    // - a warning should be displayed, unless the user explicitly knows what he's doing.
    //   For that case, he can edit the UseLocalData.cfg to "ShowWarning=0"
    cfgIni := TMemIniFile.Create(ExtractFilePath(Paramstr(0)) + 'UseLocalData.cfg');
    try
      if cfgIni.ReadBool('Settings', 'ShowWarning', True) then begin
        // AddErrorLog(WriteAccessNotPossiblePortable);
        // TranslateMessageDlg(WriteAccessNotPossiblePortable, mtWarning, [mbOK, mbHelp], HELP_Install);
        if not assigned(ConfigErrorDlg) then
          Application.CreateForm(TConfigErrorDlg, ConfigErrorDlg);
        ConfigErrorDlg.ShowModal;
      end;
    finally
      cfgIni.Free;
    end;
  end;
end;

procedure StuffToDoAfterCreate;
var TmpLastExitWasOK: Boolean;
begin
    Formatsettings.LongTimeFormat := 'HH:mm';
    with Nemp_MainForm do
    begin
        //LockWindowUpdate(Handle);

        TmpLastExitWasOK := LoadSettings;

        {$IFDEF USESTYLES}
        //this seems to solve some issues with HINT-Windows in the VST
        // in single-window-mode
        // !!!! another call MUST be done at the end of this procedure !!!
        if NempOptions.UseSkin AND NempOptions.GlobalUseAdvancedSkin {and (Anzeigemode = 0)} then
        begin
            SendMessage( Handle, WM_SETREDRAW, 0, 0);
        end;
        {$ENDIF}

        SearchSkins;
        SearchLanguages;
        SearchDSPPlugins;

        ApplySettings;

        AutoLoadPlaylist(TmpLastExitWasOK);
        NempPlaylist.PlaylistManager.InitPlaylistFilenames;

        __MainContainerPanel.ID := 'A';
        ApplyLayout;
        UpdateSplashScreen(SplashScreen_GenerateWindows);

        UpdateFormDesignNeu(NempOptions.AnzeigeMode);
        NempLayout.ResizeSubPanel(TreePanel, ArtistsVST, NempLayout.TreeViewRatio);

        ReTranslateNemp(GetCurrentLanguage);

        if NempPlayer.MainStream = 0 then
          ReInitPlayerVCL(False); // otherwise it has been done in player.play
        ReArrangeToolImages;

        if NempSkin.isActive then
        begin
            NempSkin.RefreshTreeBackgrounds;
        end;

        ReadyForgetFileApiCommands := True;
        AcceptApiCommands := True;
        EditFastSearch.OnChange := EDITFastSearchChange;
        PlaylistPropertiesChanged(NempPlaylist);

        FormHeadsetControl.DropManager := fDropManager;

        //LockWindowUpdate(0);
        {$IFDEF USESTYLES}
        if NempOptions.UseSkin AND NempOptions.GlobalUseAdvancedSkin {and (Anzeigemode = 1)} then
        begin
            SendMessage(Handle, WM_SETREDRAW, 1, 0);
            Refresh;
        end;
        {$ENDIF}

        AutoLoadBib;
        CheckWriteAccess;
    end;
end;

// InitializeCoverflow: Used in .dpr after moving the MainWindow into view
procedure InitializeCoverflow;
begin
  if (ParamCount >= 1) and (ParamStr(1) = '/safemode') then
    MedienBib.NewCoverFlow.Mode := cm_Classic
  else
    MedienBib.NewCoverFlow.Mode := TCoverFlowMode(NempSettingsManager.ReadInteger('MedienBib', 'CoverFlowMode', Integer(cm_OpenGL)));

  if Nemp_MainForm.NempSkin.isActive then
    MedienBib.NewCoverFlow.SetColor(Nemp_MainForm.NempSkin.SkinColorScheme.CoverFlowCl)
  else
    MedienBib.NewCoverFlow.SetColor(MedienBib.NewCoverFlow.Settings.DefaultColor);

  MedienBib.NewCoverFlow.ApplySettings;
  if MedienBib.BrowseMode = 1  then
    MedienBib.NewCoverFlow.Paint(50);
end;



end.
