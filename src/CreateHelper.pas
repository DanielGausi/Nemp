{

    Unit CreateHelper

    - Things that need to be done on Create of the mainform

    The previous methods has been really confusing, and caused some trouble
    with the Win7-Buttons in the taskbar.

    This here should work properly.

    Note: "StuffToDoAfterCreate" is called from the project-file

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

unit CreateHelper;

interface

    uses Forms, Windows, Graphics, Classes, Menus, Controls, SysUtils, IniFiles, VirtualTrees,

    dialogs;


    procedure UpdateSplashScreen(status: String);

    procedure StuffToDoAfterCreate;

implementation

uses NempMainUnit, Splash, gnugettext, PlaylistClass, PlayerClass,
    MedienbibliothekClass, Nemp_SkinSystem, Spectrum_vis,
    Nemp_ConstantsAndTypes, AudioFileClass, Nemp_RessourceStrings,
    MainFormHelper, UpdateUtils, SystemHelper, TreeHelper, languagecodes,
    SplitForm_Hilfsfunktionen, Mp3FileUtils,

    MedienListeUnit, AuswahlUnit, ExtendedControlsUnit, PlaylistUnit;


procedure UpdateSplashScreen(status: String);
begin
    if Assigned(FSplash) then
    begin
        FSplash.StatusLBL.Caption := (status);
        FSplash.Update;
    end;
end;

function LoadSettings: Boolean;
var i, s: Integer;
    ini: TMemIniFile;
    // tmpLastExitOK: boolean;
    aMenuItem: TMenuItem;
    tmpwstr: UnicodeString;
begin
    UpdateSplashScreen(SplashScreen_LoadingPreferences);
    with Nemp_MainForm do
    begin
        ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
        try
            ini.Encoding := TEncoding.UTF8;

            // result is the lastExit-Value
            result := ini.ReadBool('Allgemein', 'LastExitOK', True);

            ReadNempOptions(ini, NempOptions);
            if (NempOptions.Language <> '') and (NempOptions.Language <> GetCurrentLanguage) then
                Uselanguage(NempOptions.Language);

            //Player-Einstellungen lesen
            NempPlayer.LoadFromIni(Ini);

            //Player initialisieren, Load Plugins.
            NempPlayer.InitBassEngine(Handle, ExtractFilePath(ParamStr(0)) + 'Bass\', tmpwstr);
            // VCL an den Player anpassen
            PlaylistDateienOpenDialog.Filter := tmpwstr;

            //Playlist-Einstellungen laden
            NempPlaylist.LoadFromIni(Ini);
            // MedienBib-Einstellungen laden
            MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
            MedienBib.LoadFromIni(Ini);

            UseSkin             := ini.ReadBool('Fenster', 'UseSkin', True);
            SkinName            := ini.ReadString('Fenster','SkinName','<public> Nemp3');

            for i:=0 to Spaltenzahl-1 do
            begin
                s := ini.ReadInteger('Spalten','Inhalt' + IntToStr(i), DefaultSpalten[i].Inhalt);
                VST.Header.Columns[i].Text := _(DefaultSpalten[s].Bezeichnung);
                VST.Header.Columns[i].Tag := s;

                if ini.readbool('Spalten','visible' + IntToStr(i), DefaultSpalten[i].visible) then
                    VST.Header.Columns[i].Options := VST.Header.Columns[i].Options + [coVisible]
                else
                    VST.Header.Columns[i].Options := VST.Header.Columns[i].Options - [coVisible];

                VST.Header.Columns[i].Width := ini.ReadInteger('Spalten','Breite' + IntToStr(i), DefaultSpalten[i].width);

                aMenuItem := TMenuItem.Create(Nemp_MainForm);
                aMenuItem.AutoHotkeys := maManual;
                aMenuItem.AutoCheck := True;
                aMenuItem.Tag := i;
                aMenuItem.OnClick := VST_ColumnPopupOnClick;
                aMenuItem.Caption := _(DefaultSpalten[s].Bezeichnung);
                VST_ColumnPopup.Items.Insert(i, aMenuItem);
            end;

            // Hook-Funktionen initialisieren
            lib := LoadLibraryW(PWideChar(ExtractFilePath(Paramstr(0))+'KBHook.dll'));
            if lib <> INVALID_HANDLE_VALUE then
            begin
                InstallHook := GetProcAddress(lib, 'InstallHook');
                UnInstallHook := GetProcAddress(lib, 'UninstallHook');
            end;
            // Initialisierung des Hooks
            if lib <> INVALID_HANDLE_VALUE then
            begin
                SchonMalEineMediaTasteGedrueckt := ini.ReadBool('Multimediatasten','BereitsGedrueckt',False);
                DoHookInstall := ini.ReadBool('Multimediatasten','HookInstall',False);
                if DoHookInstall then
                begin
                    InstallHook(Nemp_MainForm.Handle);
                    HookIsInstalled := True;
                end else
                    HookIsInstalled := False;
            end
            else begin
                SchonMalEineMediaTasteGedrueckt := True;
                DoHookInstall := False;
            end;

            NempUpdater.LoadFromIni(Ini);
            NempSkin.NempPartyMode.LoadFromIni(ini);

            // AnzeigeModus (Das "i" in der NempFormAufteilung)
            AnzeigeMode := (Ini.ReadInteger('Fenster', 'Anzeigemode', 0)) Mod 2; // 0 oder 1, was anderes gibts nicht mehr.

            Tag := -1;

            // Jetzt: False reinschreiben
            // Das wird erst am Ende wieder "gut gemacht" ;-)
            ini.WriteBool('Allgemein', 'LastExitOK', False);
            ini.Encoding := TEncoding.UTF8;
            try
                Ini.UpdateFile;
                NempOptions.WriteAccessPossible := True;
            except
                // Silent Exception
                NempOptions.WriteAccessPossible := False;
            end;

            NempUpdater.WriteAccessPossible := NempOptions.WriteAccessPossible;
        finally
            ini.Free
        end;

        {// Now: Get LastExitOK from the file (test for writeaccess)
        ini := TMeminiFile.Create(SavePath + NEMP_NAME + '.ini', TEncoding.Utf8);
        try
            NempOptions.WriteAccessPossible := Not (Ini.ReadBool('Allgemein', 'LastExitOK', True));

            if NempOptions.WriteAccessPossible then
                showmessage('ok')
            else
                showmessage('nicht ok');

        finally
            ini.Free;
        end;
        }


        ini := TMeminiFile.Create(SavePath + 'Nemp_EQ.ini');
        try
            InitEqualizerMenuFormIni(ini);
            Btn_EqualizerPresets.Caption := NempPlayer.EQSettingName;
        finally
            ini.Free
        end;

        SetRecentPlaylistsMenuItems;

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
        // Skin-MenuItems setzen
        if (FindFirst(GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\'+'*',faDirectory,SR)=0) then
        repeat
          if (SR.Name<>'.') and (SR.Name<>'..') and ((SR.Attr AND faDirectory)= faDirectory) then
          begin
              tmpstr :=  StringReplace('<private> ' + Sr.Name,'&','&&',[rfReplaceAll]);
              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
              aMenuItem.Caption := tmpstr; //'<private> ' + Sr.Name;
              PM_P_Skins.Add(aMenuItem);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
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
              aMenuItem.Caption := tmpstr; ///'<public> ' + Sr.Name;
              PM_P_Skins.Add(aMenuItem);

              aMenuItem := TMenuItem.Create(Nemp_MainForm);
              aMenuItem.AutoHotkeys := maManual;
              aMenuItem.OnClick := SkinAn1Click;
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
            MedienBib.LoadFromFile(SavePath + NEMP_NAME + '.gmp')
        else
        begin
            case MedienBib.BrowseMode of
                0: MedienBib.ReBuildBrowseLists;
                1: begin
                    MedienBib.ReBuildCoverList;
                    MedienBib.CurrentArtist := BROWSE_ALL;
                    MedienBib.CurrentAlbum := BROWSE_ALL;
                    If MedienBib.Coverlist.Count > 3 then
                        CoverScrollbar.Max := MedienBib.Coverlist.Count - 1
                    else
                        CoverScrollbar.Max := 3;
                    CoverScrollbarChange(Nil);
                end;
                2: begin
                    MedienBib.ReBuildTagCloud;
                    MedienBib.TagCloud.ShowTags;
                    MedienBib.GenerateAnzeigeListeFromTagCloud(MedienBib.TagCloud.ClearTag, True);
                end;
            end;
            if FileExists(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl') then
                MedienBib.ImportFavorites(ExtractFilePath(ParamStr(0)) + 'Data\default.nwl')
            else
                if FileExists(SavePath + 'default.nwl') then
                    MedienBib.ImportFavorites(SavePath + 'default.nwl');
            ReFillBrowseTrees(False);
        end;
    end;
end;


procedure ApplySettings;
var i: integer;
    maxFont: integer;
begin
    UpdateSplashScreen(SplashScreen_InitPlayer);
    with Nemp_MainForm do
    begin
        // EQ-Buttons-Array bef�llen
        EqualizerButtons[0] := EqualizerButton1;
        EqualizerButtons[1] := EqualizerButton2;
        EqualizerButtons[2] := EqualizerButton3;
        EqualizerButtons[3] := EqualizerButton4;
        EqualizerButtons[4] := EqualizerButton5;
        EqualizerButtons[5] := EqualizerButton6;
        EqualizerButtons[6] := EqualizerButton7;
        EqualizerButtons[7] := EqualizerButton8;
        EqualizerButtons[8] := EqualizerButton9;
        EqualizerButtons[9] := EqualizerButton10;

        CorrectVolButton;
        CorrectHallButton;
        CorrectEchoButtons;
        CorrectSpeedButton;
        for i := 0 to 9 do CorrectEQButton(i);
        // TabStops setzen
        SetTabStopsPlayer;
        SetTabStopsTabs;

        // Hier auch Scrobbler.Checked setzen
        MM_T_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;
        PM_P_Scrobbler.Checked := NempPlayer.NempScrobbler.DoScrobble;

        CB_MedienBibGlobalQuickSearch.OnClick := Nil;
        CB_MedienBibGlobalQuickSearch.OnClick := CB_MedienBibGlobalQuickSearchClick;
        EditFastSearch.Text := MainForm_GlobalQuickSearch;

        // Optionen verarbeiten, Variablen entsprechend setzen
        PM_P_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;
        MM_O_ViewStayOnTop.Checked := NempOptions.MiniNempStayOnTop;

        AutoShowDetailsTMP := False; /// NempOptions.AutoShowDetails;

        // Men�eintr�ge checken//unchecken
        PM_P_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
        PM_P_ViewSeparateWindows_Playlist.Checked  := NempOptions.NempEinzelFormOptions.PlaylistVisible;
        PM_P_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
        PM_P_ViewSeparateWindows_Browse.Checked    := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

        MM_O_ViewSeparateWindows_Equalizer.Checked := NempOptions.NempEinzelFormOptions.ErweiterteControlsVisible;
        MM_O_ViewSeparateWindows_Playlist.Checked  := NempOptions.NempEinzelFormOptions.PlaylistVisible;
        MM_O_ViewSeparateWindows_Medialist.Checked := NempOptions.NempEinzelFormOptions.MedienlisteVisible;
        MM_O_ViewSeparateWindows_Browse.Checked    := NempOptions.NempEinzelFormOptions.AuswahlSucheVisible;

        if NempOptions.FullRowSelect then
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions + [toFullRowSelect]
        else
            VST.TreeOptions.SelectionOptions := VST.TreeOptions.SelectionOptions - [toFullRowSelect];

        if NempOptions.EditOnClick then
            VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions + [toEditOnClick]
        else
            VST.TreeOptions.MiscOptions := VST.TreeOptions.MiscOptions - [toEditOnClick];


        VST.ShowHint := MedienBib.ShowHintsInMedialist;
        PlaylistVST.ShowHint := NempPlaylist.ShowHintsInPlaylist;
        ArtistsVST.DefaultNodeHeight := NempOptions.ArtistAlbenRowHeight;
        AlbenVST.DefaultNodeHeight   := NempOptions.ArtistAlbenRowHeight;
        ArtistsVST.Font.Size         := NempOptions.ArtistAlbenFontSize;
        AlbenVST.Font.Size           := NempOptions.ArtistAlbenFontSize;
        VST.DefaultNodeHeight         := NempOptions.RowHeight;
        PlaylistVST.DefaultNodeHeight := NempOptions.RowHeight;
        if NempOptions.ChangeFontSizeOnLength then
        begin
            maxFont := NempOptions.FontSize[1];
            if NempOptions.FontSize[2] > maxFont then maxFont := NempOptions.FontSize[2];
            if NempOptions.FontSize[3] > maxFont then maxFont := NempOptions.FontSize[3];
            if NempOptions.FontSize[4] > maxFont then maxFont := NempOptions.FontSize[4];
            if NempOptions.FontSize[5] > maxFont then maxFont := NempOptions.FontSize[5];
        end
        else
            maxFont := NempOptions.DefaultFontSize;

        PlaylistVST.Canvas.Font.Size := maxFont;
        PlaylistVST.Header.Columns[1].Width := PlaylistVST.Canvas.TextWidth('@99:99');
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
        AutoSavePlaylistTimer.Enabled := NempPlaylist.AutoSave;
        AutoSavePlaylistTimer.Interval := 5 * 60000;

        // Anzeige oben links initialisieren
        SwitchBrowsePanel(MedienBib.BrowseMode);

        if NempOptions.RegisterHotKeys then
            InstallHotkeys (SavePath, Handle);

        Spectrum.Mode := 1;
        Spectrum.LineFallOff := 7;
        Spectrum.PeakFallOff := 1;
        Spectrum.Pen := clActiveCaption;
        Spectrum.Peak := clBackground;
        Spectrum.BackColor := clBtnFace;
        Spectrum.TimebackColor := Spectrum.BackColor;
        Spectrum.TitelbackColor := Spectrum.BackColor;
        Spectrum.TextColor := clWindowText;
        Spectrum.TextPosY := 0;
        Spectrum.TextPosX := 0;
        Spectrum.ScrollDelay := NempPlayer.ScrollAnzeigeDelay;
        Spectrum.DrawClear;

        AuswahlForm.InitForm;
        ExtendedControlForm.InitForm;
        MedienlisteForm.InitForm;
        PlaylistForm.InitForm;
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

        if Useskin then
        begin
            tmpstr := StringReplace(SkinName,
                    '<public> ', ExtractFilePath(Paramstr(0)) + 'Skins\', []);
            tmpstr := StringReplace(tmpstr,
                    '<private> ', GetShellFolder(CSIDL_APPDATA) + '\Gausi\Nemp\Skins\',[]);
            Nempskin.LoadFromDir(tmpstr);
            NempSkin.ActivateSkin(False);
            RandomBtn.GlyphLine := NempPlaylist.WiedergabeMode;
        end else
        begin
            NempSkin.DeActivateSkin(False);
            TabBtn_Equalizer.ResetGlyph;
        end;

        NempOptions.StartMinimizedByParameter := False;
        if (ParamCount = 0) or (trim(paramstr(1)) = '/minimized') or (trim(paramstr(1)) = '/safemode') then
        begin
            if trim(paramstr(1)) = '/minimized' then
                NempOptions.StartMinimizedByParameter := True;
            InitPlayingFile(NempPlaylist.AutoplayOnStart, True);
        end else
        begin
            if NempPlaylist.AutoPlayNewTitle then
            begin
                // Letzten Index merken
                BackupPlayingIndex := NempPlaylist.PlayingIndex;
                // Index auf den neuen Titel setzen, der aber nicht nicht in der Liste drin ist!
                NempPlaylist.PlayingIndex := NempPlaylist.Count; // Ja, nicht ..-1, es kommt ja wahrscheinlich einer dazu ;-)
            end;

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
    with Nemp_MainForm do
    begin
        TmpLastExitWasOK := LoadSettings;
        SearchSkins;
        SearchLanguages;
        AutoLoadPlaylist(TmpLastExitWasOK);
        ApplySettings;
        ApplyLayout;
        AutoLoadBib;

        UpdateSplashScreen(SplashScreen_GenerateWindows);
        // Place some controls correctly
        GRPBoxCover      .Parent := AudioPanel;
        GRPBoxEffekte    .Parent := AudioPanel;
        GRPBoxEqualizer  .Parent := AudioPanel;
        GRPBoxLyrics     .Parent := AudioPanel;
        GRPBOXHeadset    .Parent := AudioPanel;
        GRPBoxCover      .Align := alLeft;
        GRPBoxEffekte    .Align := alLeft;
        GRPBoxEqualizer  .Align := alLeft;
        GRPBoxLyrics     .Align := alLeft;
        GRPBOXHeadset    .Align := alLeft;
        GRPBoxCover      .Width := 191;
        GRPBoxEffekte    .Width := 191;
        GRPBoxEqualizer  .Width := 191;
        GRPBoxLyrics     .Width := 191;
        GRPBOXHeadset    .Width := 191;
        GRPBoxLyrics     .Visible := False;
        GRPBoxEffekte    .Visible := False;
        GRPBoxEqualizer  .Visible := False;
        GRPBOXHeadset    .Visible := False;
        TopMainPanel.Constraints.MinHeight := TOP_MIN_HEIGHT;
        GRPBOXArtistsAlben.Height := GRPBOXPlaylist.Height;
        GRPBOXArtistsAlben.Anchors := [akleft, aktop, akright, akBottom];

        UpdateFormDesignNeu;


        if NempSkin.isActive then
            MedienBib.NewCoverFlow.SetColor(NempSkin.SkinColorScheme.FormCL)
        else
            MedienBib.NewCoverFlow.SetColor(clWhite);

        ActualizeVDTCover;

        ReTranslateNemp(GetCurrentLanguage);

        Spectrum.DrawClear;
        if NempPlayer.MainStream = 0 then
            ReInitPlayerVCL; // otherwise it has been done in player.play
        ReArrangeToolImages;

        if NempSkin.isActive then
            NempSkin.SetVSTOffsets;

        ReadyForgetFileApiCommands := True;
        AcceptApiCommands := True;
        EditFastSearch.OnChange := EDITFastSearchChange;
        NempPlaylist.UpdatePlayListHeader(PlaylistVST, NempPlaylist.Count, NempPlaylist.Dauer);
        EdtBibGenre.Items := Genres;
    end;

end;



end.