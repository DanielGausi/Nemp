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
    dialogs, shellApi, ID3GenreList
    {$IFDEF USESTYLES}, vcl.themes, vcl.styles{$ENDIF};


    procedure UpdateSplashScreen(status: String);

    procedure StuffToDoAfterCreate;

implementation

uses NempMainUnit, Splash, gnugettext, PlaylistClass, PlayerClass,
    MedienbibliothekClass, Nemp_SkinSystem, Spectrum_vis,
    Nemp_ConstantsAndTypes, NempApi, NempAudioFiles, Nemp_RessourceStrings,
    MainFormHelper, UpdateUtils, SystemHelper, TreeHelper, languagecodes,
    SplitForm_Hilfsfunktionen, DriveRepairTools,

    MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, PlaylistUnit,
    WindowsVersionInfo, AudioDisplayUtils,
    Cover.ViewCache;


procedure UpdateSplashScreen(status: String);
begin
    if Assigned(FSplash) then
    begin
        FSplash.StatusLBL.Caption := (status);
        FSplash.Update;
    end;
end;

function LoadSettings: Boolean;
var i: Integer;
    aMenuItem: TMenuItem;
    tmpwstr, g15path: UnicodeString;
    // defaultAdvanced: Boolean;
    {$IFDEF USESTYLES}
    WinVersionInfo: TWindowsVersionInfo;
    {$ENDIF}

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

        NempFormBuildOptions.LoadSettings;

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

        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        //  MedienBib.NewCoverFlow.InitList(MedienBib.CoverViewList, MedienBib.CoverCount);
        MedienBib.LoadSettings;

        VSTColumns_LoadSettings(VST);

        for i:=0 to Spaltenzahl-1 do
        begin
            aMenuItem := TMenuItem.Create(Nemp_MainForm);
            aMenuItem.AutoHotkeys := maManual;
            aMenuItem.AutoCheck := True;
            aMenuItem.Tag := i;
            aMenuItem.OnClick := VST_ColumnPopupOnClick;
            aMenuItem.Caption := VST.Header.Columns[i].Text; // _(DefaultSpalten[s].Bezeichnung);
            VST_ColumnPopup.Items.Insert(i, aMenuItem);
        end;

        NempUpdater.LoadSettings;
        NempSkin.NempPartyMode.LoadSettings;

        CoverManager.LoadSettings;
        DummyImageList.Width := CoverManager.CoverSize;

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
        if (FindFirst(GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\'+'*',faDirectory,SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
          begin
              tmpstr :=  StringReplace('<private> ' + Sr.Name,'&','&&',[rfReplaceAll]);
              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr; //'<private> ' + Sr.Name;
              PM_P_Skins.Add(aMenuItem);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr; //'<private> ' + Sr.Name;
              MM_O_Skins.Add(aMenuItem);
          end;
        until FindNext(SR)<>0;
        FindClose(SR);

        if (FindFirst(ExtractFilePath(Paramstr(0)) + 'Skins\' +'*',faDirectory,SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
          begin
              tmpstr :=  StringReplace('<public> ' + Sr.Name,'&','&&',[rfReplaceAll]);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr; ///'<public> ' + Sr.Name;
              PM_P_Skins.Add(aMenuItem);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.RadioItem := True;
              aMenuItem.AutoCheck := True;
              aMenuItem.GroupIndex := 3;
              aMenuItem.Caption := tmpstr; ///'<public> ' + Sr.Name;
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

procedure AutoLoadPlaylist(LastExitOK: Boolean);
begin
    with Nemp_MainForm do
    begin
        if (NOT LastExitOK) AND
           ( FileExists(SavePath + 'temp.npl') or
             FileExists(SavePath + 'temp.m3u8') or
             FileExists(SavePath + 'temp.m3u'))
        then begin
                UpdateSplashScreen(SplashScreen_Loadingplaylist);

                if FileExists(SavePath + 'temp.npl') then
                    NempPlaylist.LoadFromFile(SavePath + 'temp.npl')
                else
                    if FileExists(SavePath + 'temp.m3u8') then
                        NempPlaylist.LoadFromFile(SavePath + 'temp.m3u8')
                    else
                        NempPlaylist.LoadFromFile(SavePath + 'temp.m3u');
        end else // backup existiert nicht oder tmplastexit war False
        begin
            if   (FileExists(SavePath +  NEMP_NAME + '.npl')
               or FileExists(SavePath +  NEMP_NAME + '.m3u8')
               or FileExists(SavePath +  NEMP_NAME + '.m3u') ) then
            begin
                UpdateSplashScreen(SplashScreen_Loadingplaylist);

                if FileExists(SavePath +  NEMP_NAME + '.npl') then
                    NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.npl')
                else
                    if FileExists(SavePath +  NEMP_NAME + '.m3u8') then
                        NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.m3u8')
                    else
                        NempPlaylist.LoadFromFile(SavePath +  NEMP_NAME + '.m3u');
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
            MedienBib.LoadFromFile(SavePath + NEMP_NAME + '.gmp', True);
        end
        else
        begin
            LblEmptyLibraryHint.Caption := MainForm_LibraryIsEmpty;

            if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
                MedienBib.ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
            else
                if FileExists(SavePath + 'default.nwl') then
                    MedienBib.ImportFavorites(SavePath + 'default.nwl');

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
        CorrectVolButton;

        // TabStops setzen
        SetTabStopsPlayer;
        SetTabStopsTabs;

        WalkmanModeTimer.Enabled := NempPlayer.UseWalkmanMode;

        // Hier auch Scrobbler.Checked setzen
        MM_T_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;
        PM_P_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;

        //CB_MedienBibGlobalQuickSearch.OnClick := Nil;
        //CB_MedienBibGlobalQuickSearch.OnClick := CB_MedienBibGlobalQuickSearchClick;
        EditFastSearch.Text := MainForm_GlobalQuickSearch;
        EditFastSearch.Hint := MainForm_GlobalQuickSearchHint;

        EditPlaylistSearch.Hint := MainForm_PlaylistSearchHint;
        TabBtn_Marker.Hint := MainForm_MarkerBtnHint;

        // Optionen verarbeiten, Variablen entsprechend setzen
        PM_P_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
        MM_O_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;

        AutoShowDetailsTMP := False; /// NempOptions.AutoShowDetails;

        // Menüeinträge checken//unchecken
        PM_P_ViewSeparateWindows_Equalizer.Checked := NempOptions.FormPositions[nfExtendedControls].Visible; // .ErweiterteControlsVisible;
        PM_P_ViewSeparateWindows_Playlist.Checked  := NempOptions.FormPositions[nfPlaylist].Visible; //.PlaylistVisible;
        PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.FormPositions[nfMediaLibrary].Visible; //.MedienlisteVisible;
        PM_P_ViewSeparateWindows_Browse.Checked    := NempOptions.FormPositions[nfBrowse].Visible; //.AuswahlSucheVisible;

        MM_O_ViewSeparateWindows_Equalizer.Checked := NempOptions.FormPositions[nfExtendedControls].Visible; //.ErweiterteControlsVisible;
        MM_O_ViewSeparateWindows_Playlist.Checked  := NempOptions.FormPositions[nfPlaylist].Visible; //.PlaylistVisible;
        MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.FormPositions[nfMediaLibrary].Visible; //.MedienlisteVisible;
        MM_O_ViewSeparateWindows_Browse.Checked    := NempOptions.FormPositions[nfBrowse].Visible; //.AuswahlSucheVisible;

        if NempOptions.FullRowSelect then
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions + [toFullRowSelect]
        else
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions - [toFullRowSelect];

        //if NempOptions.EditOnClick then
            VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toEditOnClick];
        //else
        //    VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions - [toEditOnClick];

        VST.ShowHint := MedienBib.ShowHintsInMedialist;
        PlaylistVST.ShowHint := NempPlaylist.ShowHintsInPlaylist;
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
        PlaylistVST.Header.Columns[0].Width := PlaylistVST.Canvas.TextWidth('1234');
        RefreshPlaylistVSTHeader;

        VST.Font.Size := NempOptions.DefaultFontSize;
        PlaylistVST.Font.Size := NempOptions.DefaultFontSize;
        if Screen.Fonts.IndexOf(NempOptions.FontNameVBR) = -1 then
            NempOptions.FontNameVBR := VST.Font.Name;
        if Screen.Fonts.IndexOf(NempOptions.FontNameCBR) = -1 then
            NempOptions.FontNameCBR := VST.Font.Name;
        VST.Header.SortColumn := GetColumnIDfromContent(VST, MedienBib.Sortparams[0].Tag);

        case NempPlaylist.WiedergabeMode of
            0: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatAll);
            1: RandomBtn.Hint := (MainForm_RepeatBtnHint_RepeatTitle);
            2: RandomBtn.Hint := (MainForm_RepeatBtnHint_RandomMode);
            else
                RandomBtn.Hint := (MainForm_RepeatBtnHint_NoRepeat);
        end;
        BassTimer.Interval := NempPlayer.VisualizationInterval;
        HeadsetTimer.Interval := NempPlayer.VisualizationInterval;
        AutoSavePlaylistTimer.Enabled := True; // NempPlaylist.AutoSave;
        AutoSavePlaylistTimer.Interval := 5 * 60000;

        if NempOptions.RegisterHotKeys then
            NempOptions.InstallHotkeys;
        if NempOptions.RegisterMediaHotkeys then
            NempOptions.InstallMediakeyHotkeys(NempOptions.IgnoreVolumeUpDownKeys);

        Spectrum.Mode := 1;
        Spectrum.LineFallOff := 7;
        Spectrum.PeakFallOff := 1;
        Spectrum.Pen := clActiveCaption;
        Spectrum.Peak := clBackground;
        Spectrum.BackColor := clBtnFace;
        // Spectrum.ScrollDelay := NempPlayer.ScrollAnzeigeDelay;
        Spectrum.DrawClear;
        MedienBib.NewCoverFlow.ApplySettings;
    end;
end;

procedure ApplyLayout;
var tmpStr: String;
begin
    with Nemp_MainForm do
    begin
        // Ggf. Tray-Icon erzeugen und das erzeugen in TrayIconAdded merken
        if NempOptions.NempWindowView in [NEMPWINDOW_TRAYONLY, NEMPWINDOW_BOTH, NEMPWINDOW_BOTH_MIN_TRAY] then
          NempTrayIcon.Visible := True
        else
          NempTrayIcon.Visible := False;

        NempWindowDefault := GetWindowLong(Application.Handle, GWL_EXSTYLE);
        if NempOptions.NempWindowView = NEMPWINDOW_TRAYONLY then
        begin
            ShowWindow( Application.Handle, SW_HIDE );
            SetWindowLong( Application.Handle, GWL_EXSTYLE,
                     GetWindowLong(Application.Handle, GWL_EXSTYLE)
                     or WS_EX_TOOLWINDOW
                     and (not WS_EX_APPWINDOW));
        end;
        if NempOptions.ShowDeskbandOnStart then
            NotifyDeskband(NempDeskbandActivateMessage);

        if NempOptions.Useskin then
        begin
            SetSkinRadioBox(NempOptions.SkinName);
            tmpstr := StringReplace(NempOptions.SkinName,
                    '<public> ', ExtractFilePath(Paramstr(0)) + 'Skins\', []);
            tmpstr := StringReplace(tmpstr,
                    '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);
            Nempskin.LoadFromDir(tmpstr);
            NempSkin.ActivateSkin(False);
            RandomBtn.GlyphLine := NempPlaylist.WiedergabeMode;
        end else
        begin
            SetSkinRadioBox('');
            NempSkin.DeActivateSkin(False);
            TabBtn_Equalizer.ResetGlyph;
        end;

        // Anzeige oben links initialisieren
        SwitchBrowsePanel(MedienBib.BrowseMode);

        TabBtn_SummaryLock.Tag       := NempOptions.VSTDetailsLock;
        TabBtn_SummaryLock.GlyphLine := NempOptions.VSTDetailsLock;

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

        ApplySettings;

        AutoLoadPlaylist(TmpLastExitWasOK);
        NempPlaylist.PlaylistManager.InitPlaylistFilenames;

        ApplyLayout;

        UpdateSplashScreen(SplashScreen_GenerateWindows);

        _TopMainPanel.Constraints.MinHeight := NempFormBuildOptions.MainPanelMinHeight;
        _TopMainPanel.Constraints.MinWidth := NempFormBuildOptions.MainPanelMinWidth;

        GRPBOXArtistsAlben.Height := GRPBOXPlaylist.Height;
        GRPBOXArtistsAlben.Anchors := [akleft, aktop, akright, akBottom];

        UpdateFormDesignNeu(NempOptions.AnzeigeMode);
        NempFormBuildOptions.ResizeSubPanel(AuswahlPanel, ArtistsVST, NempFormBuildOptions.BrowseArtistRatio);

        if NempSkin.isActive then
            MedienBib.NewCoverFlow.SetColor(NempSkin.SkinColorScheme.FormCL)
        else
            MedienBib.NewCoverFlow.SetColor(clWhite);

        ReTranslateNemp(GetCurrentLanguage);

        if NempPlayer.MainStream = 0 then
            ReInitPlayerVCL(False); // otherwise it has been done in player.play
        ReArrangeToolImages;

        if NempSkin.isActive then
        begin
            NempSkin.SetVSTOffsets;
        end;

        ReadyForgetFileApiCommands := True;
        AcceptApiCommands := True;
        EditFastSearch.OnChange := EDITFastSearchChange;
        PlaylistPropertiesChanged(NempPlaylist);

        //LockWindowUpdate(0);
        {$IFDEF USESTYLES}
        if NempOptions.UseSkin AND NempOptions.GlobalUseAdvancedSkin {and (Anzeigemode = 1)} then
        begin
            SendMessage(Handle, WM_SETREDRAW, 1, 0);
            Refresh;
        end;
        {$ENDIF}

        AutoLoadBib;
    end;
end;



end.
