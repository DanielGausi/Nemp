{

    Unit MessageHelper

    - Message-Handler for MainUnit
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
unit MessageHelper;

interface

uses Windows, Classes, Forms, Messages, SysUtils, Controls, Graphics, Dialogs,
    ContNrs, StrUtils, ShellApi, hilfsfunktionen, VirtualTrees, DeleteHelper;


function Handle_NempAPI_UserCommands(Var aMSG: tMessage): Boolean;
function Handle_MedienBibMessage(Var aMsg: TMessage): Boolean;
function Handle_ShoutcastQueryMessage(Var aMsg: TMessage): Boolean;
function Handle_WebServerMessage(Var aMsg: TMessage): Boolean;
function Handle_UpdaterMessage(Var aMsg: TMessage): Boolean;
function Handle_ScrobblerMessage(Var aMsg: TMessage): Boolean;
function Handle_WndProc(var Message: TMessage): Boolean;

function Handle_DropFilesForPlaylist(Var aMsg: TMessage): Boolean;
function Handle_DropFilesForLibrary(Var aMsg: TMessage): Boolean;
function Handle_DropFilesForHeadPhone(Var aMsg: TMessage): Boolean;

procedure Handle_STStart(var Msg: TMessage);
procedure Handle_STNewFile(var Msg: TMessage);
procedure Handle_STFinish(var Msg: TMessage);


implementation


uses NempMainUnit, Nemp_ConstantsAndTypes, AudioFileClass, Details,
    MainFormHelper, CoverHelper, AudioFileHelper,
    Nemp_RessourceStrings, ShoutCastUtils, WebServerClass,
    UpdateUtils, SystemHelper, ScrobblerUtils, OptionsComplete,
    DriveRepairTools, ShutDown, Spectrum_Vis, PlayerClass, BirthdayShow,
    SearchTool, MMSystem, BibHelper, fspTaskbarMgr, CloudEditor,
    DeleteSelect;

var NEMP_API_InfoString: Array[0..500] of AnsiChar;
    NEMP_API_InfoStringW: Array[0..500] of WideChar;
    tid      : Cardinal;


function Handle_NempAPI_UserCommands(Var aMSG: tMessage): Boolean;
var aAudioFile: tAudioFile;
  max: integer;
  resultString: AnsiString;
  resultStringW: UnicodeString;
  eq_idx, eq_value: integer;
  aList: TObjectList;
  aStream: TMemoryStream;
  Coverbmp: TBitmap;
  MyCopyDataStruct: TCopyDataStruct;
begin
    result := True;
    with Nemp_MainForm do
    Case aMSG.LParam of
        // Status des Players zurückgeben
        IPC_ISPLAYING: if AcceptApiCommands then begin
                    case NempPlayer.Status of
                      PLAYER_ISPLAYING: aMSG.result := NEMP_API_PLAYING;
                      PLAYER_ISPAUSED : aMSG.result := NEMP_API_PAUSED;
                      PLAYER_ISSTOPPED_MANUALLY : aMSG.result := NEMP_API_STOPPED;
                      PLAYER_ISSTOPPED_AUTOMATICALLY : aMSG.result := NEMP_API_STOPPED;
                    end;
        end;

        // Playing-Index zurückgeben
        IPC_GETLISTPOS: if AcceptApiCommands then
                        begin
                        //if (NempPlaylist.PlayingFile <> NIL) AND Assigned(NempPlaylist.PlayList) then
                        //    aMsg.Result := NempPlaylist.PlayList.IndexOf(PlayingFile)
                        //else
                            aMsg.Result := NempPlaylist.PlayingIndex;
                        end;

        IPC_SETPLAYLISTPOS: if AcceptApiCommands then

                        begin
                          if NempPlaylist.Count > aMsg.WParam then
                          begin
                              NempPlayer.LastUserWish := USER_WANT_PLAY;
                              NempPlaylist.Play(aMsg.WParam, NempPlayer.FadingInterval, True);
                          end;
                        end;

        // Playlist-Länge
        IPC_GETLISTLENGTH : if AcceptApiCommands then if assigned(NempPlaylist) then aMsg.Result := NempPlaylist.Count else aMsg.Result := -1;
        IPC_GETSEARCHLISTLENGTH  : if AcceptApiCommands then
                                    if assigned(MedienBib.BibSearcher) and assigned(MedienBib.BibSearcher.IPCSearchResults) then
                                        aMsg.Result := MedienBib.BibSearcher.IPCSearchResults.Count
                                    else
                                        aMsg.Result := -1;

        // Zeiten des aktuellen Titels
        // Position in MilliSec, Dauer in Sec - das ist in Winamp dummerweise auch so - und die Api soll kompatibel dazu sein
        IPC_GETOUTPUTTIME : if AcceptApiCommands then begin
                    if assigned(NempPlayer) then
                      case aMsg.WParam of
                        0: aMsg.Result := Round(1000 * NempPlayer.Time);
                        1: aMsg.Result := Round(NempPlayer.Dauer);
                      else aMsg.Result := -1;
                      end //case
                    else aMsg.Result := -1;
        end;

        IPC_GETPLAYLISTTRACKLENGTH,
        IPC_GETSEARCHLISTTRACKLENGTH: if AcceptApiCommands then begin
                    if aMsg.LParam = IPC_GETPLAYLISTTRACKLENGTH then
                      aList := NempPlaylist.Playlist
                    else
                      aList := MedienBib.AnzeigeListe;
                    if assigned(aList) AND (aList.Count > aMsg.WParam) then
                      aMsg.Result := TAudioFile(aList[aMsg.WParam]).Duration
                    else
                      aMsg.Result := -1;
        end;

        // Position setzen
        IPC_JUMPTOTIME : if AcceptApiCommands then begin
                   if assigned(NempPlayer) then
                     NempPlaylist.Time := aMsg.WParam / 1000;
                   aMsg.Result := 0;
        end;

        // Lautstärke setzen
        // Kompatibel zu Winamp - dort sind Werte von 0..255 im WParam.
        // Hier: Umrechnen auf 0..100
        IPC_SETVOLUME: if AcceptApiCommands then begin
                      //tmp := Round(aMsg.WParam / 2.55);
                      //if tmp < 0  then tmp := 0;
                      //if tmp > 100 then tmp := 100;
                      NempPlayer.Volume := Round(aMsg.WParam / 2.55);
                      CorrectVolButton;
                   end;

        IPC_GETVOLUME: aMsg.Result := Round(NempPlayer.Volume * 2.55);

        // Audio-Infos übers aktuelle File liefern
        IPC_GETINFO: if AcceptApiCommands then Begin
                    if NempPlaylist.PlayingFile = Nil then aMsg.Result := -1
                    else
                    begin
                      case aMsg.WParam of
                        IPC_MODE_SAMPLERATE : aMsg.Result := Nemp_Samplerates_Int[NempPlaylist.PlayingFile.SamplerateInt];
                        IPC_MODE_BITRATE    : aMsg.Result := NempPlaylist.PlayingFile.Bitrate;
                        IPC_MODE_CHANNELS   : aMsg.Result := Nemp_Modes_Int[NempPlaylist.PlayingFile.ChannelModeInt];
                      else aMsg.Result := -1;
                      end;
                    end;
        end;

        // Equalizer setzen
        IPC_SETEQDATA: if AcceptApiCommands then Begin
                // Ankommende Werte zwischen 0 und 60
                if (aMsg.WParam shr 24) AND $FF = $DB then
                begin
                    eq_idx := (aMsg.WParam shr 16) And $FF;
                    eq_value := (aMsg.WParam) AND $FFFF;
                    if (eq_idx in [0..9]) and (eq_Value in [0..60]) then
                    begin
                      NempPlayer.SetEqualizer(eq_idx, APIEQToPlayer(eq_value));
                      CorrectEQButton(eq_idx);
                    end;
                end;
                aMsg.Result := 0;
        end;

        // Equalizer auslesen
        IPC_GETEQDATA: if AcceptApiCommands then begin
                if aMsg.WParam in [0..9] then
                    aMsg.Result := Round( (- NempPlayer.fxgain[aMsg.WParam] + EQ_NEW_MAX) * EQ_NEW_FACTOR)
                else
                  aMsg.Result := -1;
        end;

        // Werte Für den Hall setzen / zurückliefern
        IPC_GETREVERB :   if AcceptApiCommands then aMsg.Result := Round(NempPlayer.ReverbMix);
        IPC_SETREVERB :   if AcceptApiCommands then begin
                              NempPlayer.ReverbMix :=  aMsg.WParam;
                              CorrectHallButton;
                          end;

        // Echo-Daten liefern/setzen
        // Überprüfung auf Gültigkeit wird in den Actualize-Prozeduren erledigt
        IPC_GETECHOTIME : if AcceptApiCommands then aMsg.Result := Round(NempPlayer.EchoTime);
        IPC_SETECHOTIME : if AcceptApiCommands then begin
                              NempPlayer.EchoTime := aMsg.WParam;
                              CorrectEchoButtons;
                          end;
        IPC_GETECHOMIX :  if AcceptApiCommands then aMsg.Result := Round(NempPlayer.EchoWetDryMix);
        IPC_SETECHOMIX :  if AcceptApiCommands then begin
                              NempPlayer.EchoWetDryMix := aMsg.WParam;
                              CorrectEchoButtons;
                          end;
        // Geschwindigkeit setzen/zurückliefern
        IPC_GETSPEED :    if AcceptApiCommands then aMsg.Result := Round(NempPlayer.Speed * 100);
        IPC_SETSPEED :    if AcceptApiCommands then
                          begin
                                NempPlayer.Speed := aMsg.WParam/100;
                                CorrectSpeedButton;
                          end;


        // Dateinamen des Titels liefern, Nummer steht in WParam
        IPC_GETPLAYLISTFILE,
        IPC_GETPLAYLISTTITLE,
        IPC_GETPLAYLISTARTIST,
        IPC_GETPLAYLISTALBUM,
        IPC_GETPLAYLISTTITLEONLY,

        IPC_GETSEARCHLISTFILE,
        IPC_GETSEARCHLISTTITLE,
        IPC_GETSEARCHLISTARTIST,
        IPC_GETSEARCHLISTALBUM,
        IPC_GETSEARCHLISTTITLEONLY : if AcceptApiCommands AND ReadyForGetFileApiCommands then
                      begin
                            FillChar(NEMP_API_InfoString[0], length(NEMP_API_InfoString), #0);
                            case aMsg.LParam of
                                IPC_GETPLAYLISTFILE,
                                IPC_GETPLAYLISTTITLE,
                                IPC_GETPLAYLISTARTIST,
                                IPC_GETPLAYLISTALBUM,
                                IPC_GETPLAYLISTTITLEONLY : aList := NempPLaylist.Playlist
                            else
                              aList := MedienBib.BibSearcher.IPCSearchResults;
                            end;

                            If assigned(aList) AND (aList.Count > aMsg.WParam) AND (aMsg.WParam > -1) then
                            begin
                              aAudioFile := TAudioFile(aList[aMsg.WParam]);          // Stream/Datei Beahndlung i.O.??
                              case aMsg.LParam of
                                IPC_GETPLAYLISTFILE,
                                IPC_GETSEARCHLISTFILE: resultString := AnsiString(aAudiofile.Pfad);  // Ja.

                                IPC_GETPLAYLISTTITLE,
                                IPC_GETSEARCHLISTTITLE: resultString := AnsiString(aAudioFile.PlaylistTitle) ;// Ja.

                                IPC_GETPLAYLISTARTIST,
                                IPC_GETSEARCHLISTARTIST: begin if aAudioFile.isStream then
                                                             begin
                                                               if aAudioFile.Description <> '' then
                                                                 resultString := AnsiString(aAudioFile.Description)
                                                               else
                                                                 resultString := AnsiString('(Webstream)')
                                                             end
                                                            else
                                                              resultString := AnsiString(aAudioFile.Artist); // gibts nicht bei Streams, oder?
                                                        end;

                                IPC_GETPLAYLISTALBUM,
                                IPC_GETSEARCHLISTALBUM: begin
                                                            if aAudioFile.isStream then
                                                               resultString := AnsiString('(Webstream)')
                                                            else
                                                              resultString := AnsiString(aAudioFile.Album)  // gibts nicht bei Streams
                                                        end;

                                else
                                {IPC_GETPLAYLISTTITLEONLY,
                                IPC_GETSEARCHLISTTITLEONLY;}
                                  resultString := AnsiString(aAudioFile.Titel);
                              end;

                              if resultString = '' then resultString := AnsiString(aAudioFile.Pfad);

                              max := length(resultString);
                              if max > length(NEMP_API_InfoString)-1 then
                                max := length(NEMP_API_InfoString)-1;
                              if length(resultString) > 0 then
                                Move(resultString[1],
                                NEMP_API_InfoString[0],
                                max);
                            end;
                            aMsg.result := Integer(@NEMP_API_InfoString[0]);
                      end else
                            aMsg.Result := -1;

        // Dateinamen des Titels liefern, Nummer steht in WParam
        // WIDESTRING - Variante
        IPC_GETPLAYLISTFILE_W,
        IPC_GETPLAYLISTTITLE_W,
        IPC_GETPLAYLISTARTIST_W,
        IPC_GETPLAYLISTALBUM_W,
        IPC_GETPLAYLISTTITLEONLY_W,

        IPC_GETSEARCHLISTFILE_W,
        IPC_GETSEARCHLISTTITLE_W,
        IPC_GETSEARCHLISTARTIST_W,
        IPC_GETSEARCHLISTALBUM_W,
        IPC_GETSEARCHLISTTITLEONLY_W : if AcceptApiCommands AND ReadyForGetFileApiCommands then
                      begin

                            FillChar(NEMP_API_InfoStringW[0], sizeof(WideChar) * length(NEMP_API_InfoStringW), #0);
                            case aMsg.LParam of
                                IPC_GETPLAYLISTFILE_W,
                                IPC_GETPLAYLISTTITLE_W,
                                IPC_GETPLAYLISTARTIST_W,
                                IPC_GETPLAYLISTALBUM_W,
                                IPC_GETPLAYLISTTITLEONLY_W : aList := NempPLaylist.Playlist
                            else
                              aList := MedienBib.BibSearcher.IPCSearchResults
                            end;

                            If assigned(aList) AND (aList.Count > aMsg.WParam) AND (aMsg.WParam > -1) then
                            begin
                              aAudioFile := TAudioFile(aList[aMsg.WParam]);          // Stream/Datei Beahndlung i.O.??
                              case aMsg.LParam of
                                IPC_GETPLAYLISTFILE_W,
                                IPC_GETSEARCHLISTFILE_W: resultStringW := aAudiofile.Pfad;  // Ja.

                                IPC_GETPLAYLISTTITLE_W,
                                IPC_GETSEARCHLISTTITLE_W: resultStringW := aAudioFile.PlaylistTitle; // Ja.

                                IPC_GETPLAYLISTARTIST_W,
                                IPC_GETSEARCHLISTARTIST_W: begin if aAudioFile.isStream then
                                                             begin
                                                               if aAudioFile.Description <> '' then
                                                                 resultStringW := aAudioFile.Description
                                                               else
                                                                 resultStringW := '(Webstream)'
                                                             end
                                                            else
                                                              resultStringW := aAudioFile.Artist; // gibts nicht bei Streams, oder?
                                                        end;

                                IPC_GETPLAYLISTALBUM_W,
                                IPC_GETSEARCHLISTALBUM_W: begin
                                                            if aAudioFile.isStream then
                                                               resultStringW := '(Webstream)'
                                                            else
                                                              resultStringW := aAudioFile.Album  // gibts nicht bei Streams
                                                        end;

                                else
                                {IPC_GETPLAYLISTTITLEONLY,
                                IPC_GETSEARCHLISTTITLEONLY;}
                                  resultStringW := aAudioFile.Titel;
                              end;

                              if resultStringW = '' then resultStringW := aAudioFile.Pfad;

                              max := length(resultStringW);
                              if max > length(NEMP_API_InfoStringW)-1 then
                                max := length(NEMP_API_InfoStringW)-1;
                              if length(resultStringW) > 0 then
                                Move(resultStringW[1],
                                NEMP_API_InfoStringW[0],
                                sizeof(WideChar) * max);
                            end;
                            aMsg.result := Integer(@NEMP_API_InfoStringW[0]);
                      end else
                            aMsg.Result := -1;

        IPC_QUERYCOVER: begin  // Cover liefern
                          if assigned(NempPlayer.MainAudioFile) then
                          begin
                               Coverbmp := tBitmap.Create;
                               try
                                   //Coverbmp.Width := 240;
                                   //Coverbmp.Height := 240;
                                   if GetCover(NempPlayer.MainAudioFile, Coverbmp) then
                                   begin
                                      aMsg.Result := 1;
                                      aStream := TMemoryStream.Create;
                                      try
                                          Coverbmp.SaveToStream(aStream);
                                          with MyCopyDataStruct do
                                          begin
                                            dwData := IPC_SENDCOVER;
                                            cbData := aStream.Size;
                                            lpData := aStream.Memory;
                                          end;
                                          SendMessage(aMsg.WParam, WM_COPYDATA, handle, Longint(@MyCopyDataStruct));
                                      finally
                                          aStream.Free
                                      end;
                                   end else
                                      aMsg.result := -1;
                               finally
                                   CoverBmp.Free;
                               end
                          end else
                              aMsg.result := -1;
        end;
        // Suffle-Modus liefern
        IPC_GET_SHUFFLE: if AcceptApiCommands then begin
          case NempPlaylist.WiedergabeMode of
              NEMP_API_REPEATALL   : aMsg.Result := 0;       //
              NEMP_API_REPEATTITEL : aMsg.Result := 2;       //  !!!
              NEMP_API_NOREPEAT    : aMsg.Result := 3;
              else aMsg.Result := 1;                         //
          end;                                               //
        end;                                                 //
                                                             //
        // Repeat ist bei Nemp immer an!                     //                       // in 3.1 nicht mehr !!!
        IPC_GET_REPEAT: if AcceptApiCommands then aMsg.Result := 1;                    //

        IPC_QUERY_SEARCHSTATUS:  if MedienBib.BibSearcher.IPCSearchIsRunning then
                                    aMsg.Result := 0
                                 else
                                    aMsg.Result := 1;
        else
            result := False;
    end;
end;

function Handle_MedienBibMessage(Var aMsg: TMessage): Boolean;
var i: Integer;
    srList: TObjectList;
    af: TAudiofile;
    aErr: TAudioError;
    ErrorLog : TErrorLog;

    tmpString: String;
    delData: TDeleteData;
begin
  result := True;

  with Nemp_MainForm do
  case aMsg.WParam of
        // Changing the status of the library MUST be done in the VCL-Thread!
        MB_SetStatus: begin
            MedienBib.StatusBibUpdate := aMsG.LParam;
            if (aMsg.LParam = 0) and (MedienBib.CloseAfterUpdate) then
                PostMessage(Nemp_MainForm.Handle, WM_Close, 0,0);
        end;

        MB_BlockUpdateStart: begin
              // Alles deaktivieren, was ein hinzufügen/löschen von Dateien in die Medienbib erwirkt.
              BlockeMedienListeUpdate(True);
        end;

        MB_BlockWriteAccess: begin
            if aMsg.LParam = 0 then BlockeMedienListeWriteAcces(True);
            AuswahlStatusLBL.Caption := (MediaLibrary_Preparing);
        end;

        MB_BlockReadAccess: begin
          if aMsg.LParam = 0 then BlockeMedienListeReadAccess(True);
          AuswahlStatusLBL.Caption :=  (MediaLibrary_AlmostDone);
        end;

        MB_RefillTrees: begin

          ReFillBrowseTrees(LongBool(aMsg.LParam));
          PanelStandardBrowse.Visible := MedienBib.BrowseMode = 0;
          PanelCoverBrowse.Visible    := MedienBib.BrowseMode = 1;
          PanelTagCloudBrowse.Visible := MedienBib.BrowseMode = 2;

         { if MedienBib.BrowseMode = 1 then
          begin
              //Done in    ReFillBrowseTrees
              MedienBib.NewCoverFlow.SetNewList(MedienBib.Coverlist);
              CoverScrollbar.Position := MedienBib.NewCoverFlow.CurrentItem;
          end;
          }
          //MedienBib.NewCoverFlow.DoSomeDrawing(10);

        end;

        MB_Unblock: begin
            AuswahlStatusLbl.Caption := '';
            MedienListeStatusLBL.Caption := '';

            BlockeMedienListeUpdate(False);
            BlockeMedienListeWriteAcces(False);
            BlockeMedienListeReadAccess(False);

            //UnBlockMedienListe;
            LangeAktionWeitermachen := False;
            BeendelangeAktion;

            if NewDrivesNotificationCount > 0 then
                HandleNewConnectedDrive;
        end;

        MB_CheckAnzeigeList: begin
            MedienBib.CleanUpDeadFilesFromVCLLists;
            //FillTreeView(VST, MedienBib.AnzeigeListe);
            FillTreeView(MedienBib.AnzeigeListe, Nil);
            ShowSummary;
        end;

        MB_ReFillAnzeigeList: begin
            //FillTreeView(VST, MedienBib.AnzeigeListe);
            FillTreeView(MedienBib.AnzeigeListe, Nil);
            ShowSummary;
            if aMsg.LParam <> 0 then
                MedienListeStatusLBL.Caption := Warning_FileNotFound
            else
                MedienListeStatusLBL.Caption := '';
        end;

        MB_ShowSearchResults: begin
            srList := TObjectList(aMsg.LParam);
            MedienBib.AnzeigeListe.Clear;
            MedienBib.AnzeigeListe2.Clear;
            MedienBib.AnzeigeListe.Capacity := srList.Count + 1;
            for i := 0 to srList.Count - 1 do
            begin
                MedienBib.AnzeigeListe.Add(srList[i]);
            end;
            MedienBib.AnzeigeListIsCurrentlySorted := False;
            MedienBib.AnzeigeShowsPlaylistFiles := False;
            //FillTreeView(VST, MedienBib.AnzeigeListe);
            FillTreeView(MedienBib.AnzeigeListe, Nil);
            ShowSummary;
        end;

        MB_GetQuickSearchResults: begin
            srList := TObjectList(aMsg.LParam);
            MedienBib.AnzeigeListe.Clear;
            MedienBib.AnzeigeListe.Capacity := srList.Count + 1;
            for i := 0 to srList.Count - 1 do
                MedienBib.AnzeigeListe.Add(srList[i]);

            MedienBib.AnzeigeListIsCurrentlySorted := False;
            MedienBib.AnzeigeShowsPlaylistFiles := False;
        end;
        MB_GetAdditionalQuickSearchResults: begin
            srList := TObjectList(aMsg.LParam);
            MedienBib.AnzeigeListe2.Clear;
            MedienBib.AnzeigeListe2.Capacity := srList.Count + 1;
            for i := 0 to srList.Count - 1 do
                MedienBib.AnzeigeListe2.Add(srList[i]);
        end;

        MB_ShowQuickSearchResults: begin
            af := TAudioFile(aMsg.LParam); // Should be the Dummy-File from BibSearcher
            FillTreeViewQuickSearch(MedienBib.AnzeigeListe, MedienBib.AnzeigeListe2, af);
            ShowSummary;
        end;

        MB_SetWin7TaskbarProgress: begin
            fspTaskbarManager.ProgressState := TfspTaskProgressState(aMsg.LParam);
        end;

        MB_ProgressRefresh: begin
            AuswahlStatusLbl.Caption := Format((MediaLibrary_RefreshingFiles), [aMsg.LParam]);
            fspTaskbarManager.ProgressValue := aMsg.LParam;
        end;

        MB_ProgressRefreshJustProgressbar: begin
            fspTaskbarManager.ProgressValue := aMsg.LParam;
        end;

        MB_RefreshTagCloudFile: begin
            CloudEditorForm.LblUpdateWarning.Caption := PChar(aMsg.LParam);
            if PChar(aMsg.LParam) = '' then
            begin
                CloudEditorForm.LblUpdateWarning.Visible := False;
                CloudEditorForm.RefreshWarningLabel;
            end;
        end;

        MB_ProgressSearchDead: AuswahlStatusLbl.Caption := Format((MediaLibrary_SearchingMissingFiles), [aMsg.LParam]);

        //MB_SearchAutoAbort: MessageDLG((MediaLibrary_PreciseQuery), mtWarning, [MBOK], 0); // Wird aber nie ausgelöst ;-)

        MB_DeadFilesWarning: begin
            //if (aMsg.LParam < 2000) AND (aMsg.LParam < MedienBib.Count DIV 10) then // weniger als 10% fehlen
                MessageDlg(Format((MediaLibrary_FilesNotFound), [aMsg.LParam]), mtWarning, [MBOK], 0)
            //else // mehr als 10% fehlen => Laufwerk fehlt?
            //    MessageDlg(Format((MediaLibrary_FilesNotFoundExternalDrive), [aMsg.LParam]), mtWarning, [MBOK], 0);
        end;

        MB_DuplicateWarning: MessageDlg((MediaLibrary_DuplicatesWarning)
            + #13#10 +
            pWideChar(Integer(aMsg.LParam)) , mtWarning, [MBOK], 0);

        MB_ThreadFileUpdate: begin
                        MedienBib.CurrentThreadFilename := PWideChar(aMsg.LParam);
        end;

        MB_RefreshAudioFile: begin
            af := TAudioFile(aMsg.LParam);
            aErr := af.GetAudioData(af.Pfad, GAD_Cover or GAD_Rating);
            if aErr <> AUDIOERR_None then
                HandleError(afa_RefreshingFileInformation, af, aErr);

            MedienBib.InitCover(af);
        end;

        MB_LyricUpdateStatus: begin
            // WParam: a string like "(found 5/8)"
            MedienListeStatusLBL.Caption :=
                Format((MediaLibrary_SearchingLyrics),
                      [ ExtractFilename(MedienBib.CurrentThreadFilename),
                        PWideChar(aMsg.LParam)]);
            // This will result a string like "Get lyrics for mysong.mp3 (found 5/8)"
        end;

        MB_TagsUpdateStatus: begin
        // WParam: a string like "(found 5/8)"
            MedienListeStatusLBL.Caption :=
                Format((MediaLibrary_SearchingTags),
                      [ ExtractFilename(MedienBib.CurrentThreadFilename),
                        PWideChar(aMsg.LParam)]);
            // This will result a string like "Get lyrics for mysong.mp3 (found 5/8)"
        end;

        MB_TagsSetTabWarning: begin
            SetBrowseTabCloudWarning(True);
        end;

        MB_LyricUpdateFailed: begin
                              MessageDlg(MediaLibrary_LyricsFailed, mtWarning, [MBOK], 0);
                            end;

        MB_LyricUpdateComplete: begin
                              MessageDlg(PWideChar(aMsg.LParam), mtInformation, [mbOK], 0);
                            end;

        MB_ReCheckPlaylingFile: begin
              // this is only called after loading the library.
              // And only to show a proper rating in the player
              // (as the rating in the library can be different from ID3-Rating)
              if assigned(NempPlayer.MainAudioFile) and
                 (NOT NempPlayer.MainAudioFile.isCDDA)
              then
              begin
                  SynchronizeAudioFile(NempPlayer.MainAudioFile, NempPlayer.MainAudioFile.Pfad, False);
                  CorrectVCLAfterAudioFileEdit(NempPlayer.MainAudioFile);
              end;
        end;

        MB_StartAutoScanDirs: begin
            ST_Medienliste.Mask := GenerateMedienBibSTFilter;

            for i := 0 to MedienBib.AutoScanDirList.Count - 1 do
            begin
                if DirectoryExists(MedienBib.AutoScanDirList[i]) then
                    MedienBib.ST_Ordnerlist.Add(MedienBib.AutoScanDirList[i])
                else
                    MedienBib.AutoScanToDoList.Add(MedienBib.AutoScanDirList[i]);
            end;
            if MedienBib.ST_Ordnerlist.Count > 0 then
            begin
                fspTaskbarManager.ProgressValue := 0;
                fspTaskbarManager.ProgressState := fstpsIndeterminate;
                MedienBib.StatusBibUpdate := 1;
                BlockeMedienListeUpdate(True);
                ST_Medienliste.SearchFiles(MedienBib.ST_Ordnerlist[0]);
            end else
            begin
                // If ST_Ordnerlist is empty, the update-process will not start
                // This is good, but in this case we dont run fNewFilesUpdate a
                // second time, so Auto-Activation of the server will not be done
                // So: Start it directly here
                // Anyway, we have te set the status to zero here
                MedienBib.StatusBibUpdate := 0;
                if MedienBib.AutoActivateWebServer then
                begin
                    MedienBib.Initializing := Init_Complete;
                    SendMessage(Nemp_MainForm.Handle, WM_MedienBib, MB_ActivateWebServer, 0);
                end;
                // Anyway, we have te set the status to zero here
                MedienBib.StatusBibUpdate := 0;
            end;
        end;

        MB_ActivateWebServer: begin
            if not NempWebServer.Active then
            begin
                // Server aktivieren
                // 1. Einstellungen laden
                NempWebServer.LoadfromIni;
                // 2.) Medialib kopieren
                NempWebServer.CopyLibrary(MedienBib);
                NempWebServer.Active := True;
                // Control: Is it Active now?
                if NempWebServer.Active  then
                begin
                    // Ok, Activation complete
                    ReArrangeToolImages;
                    // Anzeige setzen
                    if assigned(OptionsCompleteForm) then
                        with OptionsCompleteForm do
                        begin
                            BtnServerActivate.Caption := WebServer_DeActivateServer;
                            EdtUsername.Enabled := False;
                            EdtPassword.Enabled := False;
                        end;
                end else
                begin
                    // OOps, an error occured
                    // MessageDLG('Server activation failed:' + #13#10 + NempWebServer.LastErrorString, mtError, [mbOK], 0);
                    // Nothing here. This is the Auto-Activation
                end;
            end
        end;
        MB_UnifyPlaylistRating: begin
            // im Lparam steckt ein AudioFile drin
            af := TAudioFile(aMsg.LParam);
            NempPlaylist.UnifyRating(af.Pfad, af.Rating, af.PlayCounter);


            if assigned(FDetails)
                and FDetails.Visible
                and assigned(af)
                and assigned(FDetails.CurrentAudioFile)
                and (FDetails.CurrentAudioFile.Pfad = af.Pfad)
            then
                FDetails.ReloadTimer.Enabled := True;

        end;

        MB_ErrorLog: begin
              ErrorLog := TErrorLog(aMsg.LParam);
              HandleError(ErrorLog.Action, ErrorLog.AudioFile, ErrorLog.Error, ErrorLog.Important);
        end;
        MB_ErrorLogHint: begin
            MessageDlg(MediaLibrary_SomeErrorsOccured, mtWarning, [MBOK], 0);
        end;

        MB_UserInputDeadFiles: begin
            srList := TObjectList(aMsg.LParam);
            tmpString := '';

            if not assigned(DeleteSelection) then
                Application.CreateForm(TDeleteSelection, DeleteSelection);


            DeleteSelection.DataFromMedienBib := srList;

            if DeleteSelection.showModal <> mrOK then
            begin
                // the user cancelled the dialog - Do not delete any files
                for i := 0 to srList.Count - 1 do
                begin
                    delData := TDeleteData(srList[i]);
                    delData.DoDelete := False;
                end;
            end;

           { for i := 0 to srList.Count - 1 do
            begin
                delData := TDeleteData(srList[i]);
                tmpString := tmpString + #13#10 + delData.DriveString;
                case delData.DoDelete of
                  False: tmpString := tmpString + ' behalten, denn';
                  True: tmpString := tmpString + ' löschen, denn';
                end;
                case delData.Hint of
                  dh_DivePresent: tmpString := tmpString + ' Laufwerk ist da';
                  dh_DriveMissing: tmpString := tmpString + ' Laufwerk ist nicht da';
                  dh_NetworkPresent: tmpString := tmpString + ' PC ist da';
                  dh_NetworkMissing: tmpString := tmpString + ' PC ist nicht da';
                end;
            end;
            ShowMessage(tmpString);
            }
        end;
  end;
end;

function Handle_ShoutcastQueryMessage(Var aMsg: TMessage): Boolean;
var FS: TFileStream;
    tmpPlaylist: TObjectList;
    tmpAudioFile: TAudioFile;
    filename: String;
    s: AnsiString;
begin
// NOTE: The StreamVerwaktung-Form has its own Handler for this Stuff !!!
    result := True;
    with Nemp_MainForm do
    Case aMsg.WParam of
        ST_PlaylistDownloadConnecting: begin
                                  PlayListStatusLBL.Caption := Shoutcast_Connecting_MainForm;
                               end;
        ST_PlaylistDownloadBegins: begin
                                  PlayListStatusLBL.Caption := Shoutcast_DownloadingPlaylist;
                               end;
        ST_PlaylistDownloadComplete : begin
                                  s := PAnsiChar(aMsg.LParam);
                                  //FS := Nil;
                                  if s <> '' then
                                  begin
                                      filename := GetProperFilenameForPlaylist(s);
                                      try
                                          FS := TFileStream.Create(filename, fmCreate or fmOpenWrite);
                                          try
                                              FS.Write(s[1], length(s));
                                          finally
                                              if assigned(FS) then
                                              begin
                                                  FS.Free;
                                                  tmpPlaylist := TObjectList.Create(True);
                                                  try
                                                      LoadPlaylistFromFile(filename, tmpPlaylist, False);
                                                      HandleFiles(tmpPlaylist, WebRadioInsertMode);
                                                  finally
                                                      tmpPlaylist.Free;
                                                      DeleteFile(PChar(filename));
                                                  end;
                                              end;
                                          end;
                                      except
                                          // saving temporary Playlist failed
                                      end;
                                  end;

                                  WebRadioInsertMode := PLAYER_PLAY_DEFAULT;
                                  PlayListStatusLBL.Caption := Shoutcast_DownloadComplete;
                                  ShowSummary;
                               end;
        ST_PlaylistStreamLink: begin
                                  tmpPlaylist  := TObjectList.Create(True);
                                  try
                                      tmpAudioFile := TAudioFile.Create;
                                      tmpAudioFile.Pfad := String(PChar(aMsg.LParam));

                                      tmpPlaylist.Add(tmpAudioFile);
                                      HandleFiles(tmpPlaylist, WebRadioInsertMode);
                                  finally
                                      tmpPlaylist.Free;
                                  end;
                                  WebRadioInsertMode := PLAYER_PLAY_DEFAULT;
                                  ShowSummary;
                               end;
        ST_PlaylistDownloadFailed   : begin
                                  MessageDlg(Shoutcast_Error_DownloadFailed, mtWarning, [mbOK], 0);
                                  ShowSummary;
                               end;
    end;

end;

function Handle_WebServerMessage(Var aMsg: TMessage): Boolean;
var idx: Integer;
    af: TAudioFile;
    newNode: PVirtualNode;
    NodeData: pTreeData;
begin
    result := True;
    with Nemp_MainForm do
    Case aMsg.WParam of
        WS_PlaylistPlayID: begin
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := 0;
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                  if idx > -1 then
                                  begin
                                      if NempPlaylist.Count > idx then
                                      begin
                                          NempPlayer.LastUserWish := USER_WANT_PLAY;
                                          NempPlaylist.Play(idx, NempPlayer.FadingInterval, True);

                                          if assigned(NempPlaylist.PlayingFile) then
                                              aMsg.Result := NempPlaylist.PlayingFile.WebServerID
                                          else
                                              aMsg.Result := 0;
                                      end;
                                  end else
                                  begin
                                      // file is not in the playlist - insert and play it!
                                      // (this is done in the webserver-class if aMsg.result = 0)
                                  end;
                              end;
                           end;
        WS_PlaylistDownloadID: begin
                              if AcceptApiCommands then
                              begin
                                  // default value: File not found
                                  NempWebserver.QueriedPlaylistFilename := '';
                                  // is the requested ID the current playing file?
                                  if assigned(NempPlayer.MainAudioFile)
                                      and (NempPlayer.MainAudioFile.WebServerID = aMsg.LParam)
                                  then
                                      NempWebserver.QueriedPlaylistFilename := NempPlayer.MainAudioFile.Pfad
                                  else
                                  begin
                                      // it is somewhere in the Playlist?
                                      idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                      if (idx > -1) and (NempPlaylist.Count > idx) then
                                          NempWebserver.QueriedPlaylistFilename := TAudioFile(NempPlaylist.Playlist[idx]).Pfad;
                                  end;
                              end;

                                 {
                                  if aMsg.LParam = -1 then
                                  begin
                                      if assigned(NempPlayer.MainAudioFile) then
                                          NempWebserver.QueriedPlaylistFilename := NempPlayer.MainAudioFile.Pfad
                                      else
                                          NempWebserver.QueriedPlaylistFilename := '';
                                  end else
                                  begin
                                      idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                      if (idx > -1) then
                                      begin
                                          if NempPlaylist.Count > idx then
                                              NempWebserver.QueriedPlaylistFilename := TAudioFile(NempPlaylist.Playlist[idx]).Pfad
                                          else NempWebserver.QueriedPlaylistFilename := '';
                                      end else NempWebserver.QueriedPlaylistFilename := '';
                                  end;
                                  }

                              end;

        WS_InsertNext : begin
                              if AcceptApiCommands then
                              begin
                                  af := TAudioFile(aMsg.LParam);
                                  NempPlaylist.GetInsertNodeFromPlayPosition;
                                  newNode := NempPlaylist.InsertFileToPlayList(af);
                                  // NempPlaylist.AddNodeToPrebookList(newNode);
                                  if (NempPlayer.Mainstream = 0) then
                                      InitPlayingFile(NempPlaylist.AutoplayOnStart);

                                  NodeData := PlaylistVST.GetNodeData(newNode);
                                  af := NodeData^.FAudioFile;
                                  NempWebserver.EnsureFileHasID(af);

                                  aMsg.Result := af.WebServerID;
                                  //result: the new AudioFile-Object
                              end;
                        end;
        WS_AddToPlaylist : begin
                              if AcceptApiCommands then
                              begin
                                  af := TAudioFile(aMsg.LParam);
                                  newNode := NempPlaylist.AddFileToPlaylist(af);
                                  if (NempPlayer.Mainstream = 0) then
                                      InitPlayingFile(NempPlaylist.AutoplayOnStart);

                                  NodeData := PlaylistVST.GetNodeData(newNode);
                                  af := NodeData^.FAudioFile;
                                  NempWebserver.EnsureFileHasID(af);
                                  aMsg.Result := af.WebServerID;
                              end;
                           end;
        WS_PlaylistMoveUpCheck : begin  // returns a copy of the previous file in the playlist
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := -3;   // invalid
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                  if (idx > -1) then
                                  begin
                                      af := TPlaylistFile(NempPlaylist.Playlist[idx]);
                                      if af.PrebookIndex > 0 then
                                      begin
                                          if af.PrebookIndex > 1 then
                                              aMsg.Result := -1  // reload of playlist is recommended
                                          else
                                              aMsg.Result := -2; // move up of the firstfile in prebooklist
                                      end
                                      else
                                      begin
                                          if idx > 0 then
                                              aMsg.Result := TAudioFile(NempPlaylist.Playlist[idx-1]).WebServerID
                                          else
                                          if idx = 0 then
                                              aMsg.Result := -2; // move up of the first title
                                      end;
                                  end;
                              end;
        end;
        WS_PlaylistMoveUp : begin
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := 0;
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);

                                  if (idx > -1) then
                                  begin
                                      af := TPlaylistFile(NempPlaylist.Playlist[idx]);
                                      if af.PrebookIndex > 0 then
                                      begin
                                          if af.PrebookIndex > 1 then
                                          begin
                                              NempPlaylist.SetNewPrebookIndex(af, af.PrebookIndex - 1);
                                              aMsg.Result := 1;
                                          end
                                          else
                                              aMsg.Result := 2; // move up of the firstfile in prebooklist
                                      end
                                      else
                                      begin
                                          if idx > 0 then
                                          begin
                                              if NempPlaylist.SwapFiles(idx, idx-1) then
                                                  aMsg.Result := 1;
                                          end else
                                          if idx = 0 then
                                              aMsg.Result := 2; // move up of the first title
                                      end;
                                  end;
                              end;
                           end;
        WS_PlaylistMoveDownCheck: begin
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := -3;   // invalid
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                  if (idx > -1) then
                                  begin
                                      af := TPlaylistFile(NempPlaylist.Playlist[idx]);
                                      if af.PrebookIndex > 0 then
                                      begin
                                          if af.PrebookIndex < NempPlaylist.PrebookCount then
                                              aMsg.Result := -1  // reload of playlist is recommended
                                          else
                                              aMsg.Result := -1; //reload // move down of the last file in prebooklist
                                      end
                                      else
                                      begin
                                          if (idx < NempPlaylist.Count - 1) then
                                              aMsg.Result := TAudioFile(NempPlaylist.Playlist[idx+1]).WebServerID
                                          else
                                          if idx = NempPlaylist.Count - 1 then
                                              aMsg.Result := -2; // move down of the last title
                                      end;
                                  end;
                              end;
        end;
        WS_PlaylistMoveDown : begin
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := 0;
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);

                                  if (idx > -1) then
                                  begin
                                      af := TPlaylistFile(NempPlaylist.Playlist[idx]);
                                      if af.PrebookIndex > 0 then
                                      begin
                                          if af.PrebookIndex < NempPlaylist.PrebookCount then
                                          begin
                                              NempPlaylist.SetNewPrebookIndex(af, af.PrebookIndex + 1);
                                              aMsg.Result := 1;
                                          end
                                          else
                                          begin
                                              // move down of the last file in prebooklist
                                              // => delete from prebooklist
                                              NempPlaylist.SetNewPrebookIndex(af, 0);
                                              aMsg.Result := 1;
                                          end;
                                      end
                                      else
                                      begin
                                          if (idx > -1) and (idx < NempPlaylist.Count - 1) then
                                          begin
                                              NempPlaylist.SwapFiles(idx, idx+1);
                                              //Playlist.Move(idx, idx+1);
                                              //NempPlaylist.FillPlaylistView;
                                              aMsg.Result := 1;
                                          end else
                                              if idx = NempPlaylist.Count - 1 then
                                                  aMsg.Result := 2;// move down of the last title
                                      end;
                                  end;
                              end;
                           end;
        WS_PlaylistDelete : begin
                              if AcceptApiCommands then
                              begin
                                  aMsg.Result := 0;
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                  if (idx > -1) then
                                  begin
                                      af := TPlaylistFile(NempPlaylist.Playlist[idx]);
                                      if af.PrebookIndex > 0 then
                                      begin
                                          NempPlaylist.SetNewPrebookIndex(af, 0);
                                          aMsg.Result := 2;
                                      end else
                                      begin
                                          NempPlaylist.DeleteAFile(idx);
                                          aMsg.Result := 1;
                                      end;
                                  end;
                              end;
                           end;

        WS_QueryPlayer: NempWebServer.GenerateHTMLfromPlayer(NempPlayer, 0);
        WS_QueryPlayerJS: begin
                        if aMsg.LParam = 1 then
                            NempWebServer.GenerateHTMLfromPlayer(NempPlayer, 1)   // 1: Controls  [[PlayerControls]]
                        else
                            NempWebServer.GenerateHTMLfromPlayer(NempPlayer, 2);  // 2: Playerdata [[ItemPlayer]]
        end;
        WS_QueryPlaylist: begin
                              NempWebServer.GenerateHTMLfromPlaylist_View(NempPlaylist);
                          end;
        WS_QueryPlaylistItem: begin
                              if aMsg.lParam = -1 then
                                  // get ALL items
                                  NempWebServer.GenerateHTMLfromPlaylistItem(NempPlaylist, -1)
                              else
                              begin
                                  idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                  NempWebServer.GenerateHTMLfromPlaylistItem(NempPlaylist, idx);
                              end;
                          end;
        WS_QueryPlaylistDetail: begin
                                // ID aus Lparam lesen
                                idx := NempPlaylist.GetPlaylistIndex(aMsg.LParam);
                                if (idx > -1) then
                                begin
                                      //NempWebserver.QueriedPlaylistFilename := TAudioFile(NempPlaylist.Playlist[idx]).Pfad;
                                    NempWebServer.GenerateHTMLfromPlaylist_Details(TAudioFile(NempPlaylist.Playlist[idx]), idx);
                                end else
                                    NempWebServer.GenerateHTMLfromPlaylist_Details(NIL, 0);
                          end;

        WS_IPC_GETPROGRESS: if AcceptAPICommands then
                                aMsg.Result := Round(100 * NempPlayer.Progress)
                            else
                                aMsg.Result := -1;
        WS_IPC_SETPROGRESS: if AcceptAPICommands then
                                NempPlayer.Progress := aMsg.LParam / 100;

        WS_IPC_GETVOLUME:  if AcceptAPICommands then
                                aMsg.Result := Round(NempPlayer.Volume)
                            else
                                aMsg.Result := 0;

        WS_IPC_SETVOLUME:  if AcceptAPICommands then
                           begin
                                NempPlayer.Volume := aMsg.LParam;
                                CorrectVolButton;
                           end;

        WS_VoteID: begin
                  aMsg.Result := NempWebServer.VoteMachine.VCLDoVote(aMsg.Lparam, NempPlaylist);
        end;

        WS_VoteFilename: begin
                  aMsg.Result := NempWebServer.VoteMachine.VCLDoVoteFilename(UnicodeString(PWideChar(aMsg.Lparam)), NempPlaylist);
        end;

        WS_AddAndVoteThisFile: begin
                  aMsg.Result := NempWebServer.VoteMachine.VCLAddAndVoteFile(TAudioFile(aMsg.Lparam), NempPlaylist);
        end;



        WS_StringLog: begin
                          NempWebServer.LogList.Add(PChar(aMsg.LParam));
                          if NempWebServer.LogList.Count > 500 then
                              NempWebServer.LogList.Delete(0);
                          if assigned(OptionsCompleteForm) then
                          begin
                              OptionsCompleteForm.WebServerLogMemo.Lines.Add(PChar(aMsg.LParam));
                              if OptionsCompleteForm.WebServerLogMemo.Lines.Count > 500 then
                                  OptionsCompleteForm.WebServerLogMemo.Lines.Delete(0);
                          end;
                      end;
    end;
end;


function Handle_UpdaterMessage(Var aMsg: TMessage): Boolean;
begin
    result := True;
    with Nemp_MainForm do
    Case aMsg.WParam of
      // Aktuelle Version oder Fehler: Bei Auto-Check keine Message zeigen.
      UPDATE_CURRENT_VERSION: if NempUpdater.ManualCheck then
                              begin
                                  MessageDlg(NempUpdate_CurrentVersion, mtInformation, [mbOK], 0);
                              end;
      UPDATE_VERSION_ERROR  : if NempUpdater.ManualCheck then
                              begin
                                  MessageDlg(NempUpdate_VersionError, mtError, [mbOK], 0);
                              end;
      UPDATE_CONNECT_ERROR  : if NempUpdater.ManualCheck then
                              begin
                                  MessageDlg(PChar(aMsg.LParam), mtError, [mbOK], 0);
                              end;

      UPDATE_NEWER_VERSION  : begin
                                  // Neue Version: immer anzeigen
                                  if MessageDlg(
                                      NempUpdate_NewerVersion + #13#10#13#10 +
                                      Format(NempUpdate_InfoYourVersion, [GetFileVersionString('')]) + #13#10 +
                                      Format(NempUpdate_InfoNewestVersion, [TNempUpdateInfo(aMsg.LParam).StableRelease ])
                                      , mtInformation, [mbYes, mbNo], 0) = mrYes then

                                      ShellExecute(Handle, 'open', 'http://www.gausi.de/nemp/download.php', nil, nil, SW_SHOW);
                              end;

      UPDATE_TEST_VERSION   : begin
                                  if NempUpdater.NotifyOnBetas then
                                  begin
                                      if MessageDlg(
                                          NempUpdate_TestVersionAvailable + #13#10#13#10 +
                                          Format(NempUpdate_InfoYourVersion, [GetFileVersionString('')]) + #13#10 +
                                          Format(NempUpdate_InfoLastRelease, [TNempUpdateInfo(aMsg.LParam).LastRelease, TNempUpdateInfo(aMsg.LParam).ReleaseStatus ]) + #13#10 +
                                          Format(NempUpdate_InfoNote, [TNempUpdateInfo(aMsg.LParam).ReleaseNote])
                                          , mtInformation, [mbYes, mbNo], 0) = mrYes then
                                              ShellExecute(Handle, 'open', 'http://www.gausi.de/nemp/download.php', nil, nil, SW_SHOW);
                                  end else
                                      // nur bei Manual zeigen - und dann "Current version"
                                      if NempUpdater.ManualCheck then
                                          MessageDlg(NempUpdate_CurrentVersion, mtInformation, [mbOK], 0);
                              end;

      UPDATE_CURRENTTEST_VERSION: begin
                                    if NempUpdater.ManualCheck then
                                    begin
                                        if NempUpdater.NotifyOnBetas then
                                            MessageDlg(NempUpdate_CurrentTestVersion, mtInformation, [mbOK], 0)
                                        else
                                            MessageDlg(NempUpdate_CurrentTestVersion, mtInformation, [mbOK], 0);
                                    end;
                              end;

      UPDATE_NEWERTEST_VERSION: begin
                                  //if NempUpdater.NotifyOnBetas then
                                  //begin
                                  // No. Wenn man schon eine Beta nutzt, werden auch neue gezeigt!
                                      if MessageDlg(
                                          NempUpdate_NewerTestVersionAvailable + #13#10#13#10 +
                                          Format(NempUpdate_InfoLastStableRelease, [TNempUpdateInfo(aMsg.LParam).StableRelease]) + #13#10 +
                                          Format(NempUpdate_InfoYourVersion, [GetFileVersionString('')]) + #13#10 +
                                          Format(NempUpdate_InfoLastRelease, [TNempUpdateInfo(aMsg.LParam).LastRelease, TNempUpdateInfo(aMsg.LParam).ReleaseStatus ]) + #13#10 +
                                          Format(NempUpdate_InfoNote, [TNempUpdateInfo(aMsg.LParam).ReleaseNote])
                                          , mtInformation, [mbYes, mbNo], 0) = mrYes then
                                          ShellExecute(Handle, 'open', 'http://www.gausi.de/nemp/download.php', nil, nil, SW_SHOW)
                                  //end else
                                  //begin
                                  //    if NempUpdater.ManualCheck then
                                  //        MessageDlg(NempUpdate_CurrentTestVersion, mtInformation, [mbOK], 0);
                                  //end;

                              end;

      UPDATE_PRIVATE_VERSION: begin
                                if NempUpdater.ManualCheck then
                                begin
                                     MessageDlg(
                                        NempUpdate_PrivateVersion + #13#10#13#10 +
                                        Format(NempUpdate_InfoLastStableRelease, [TNempUpdateInfo(aMsg.LParam).StableRelease]) + #13#10 +
                                        Format(NempUpdate_InfoYourVersion, [GetFileVersionString('')]) + #13#10 +
                                        Format(NempUpdate_InfoLastRelease, [TNempUpdateInfo(aMsg.LParam).LastRelease, TNempUpdateInfo(aMsg.LParam).ReleaseStatus ])
                                        , mtInformation, [mbOk], 0)
                                end;

                              end;
    end;
end;

function Handle_ScrobblerMessage(Var aMsg: TMessage): Boolean;
begin
    result := True;
    with Nemp_MainForm do
    Case aMsg.WParam of
        SC_Message,
        SC_Hint,
        SC_Error: NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));

        SC_BeginWork: begin
            if Assigned(OptionsCompleteForm) and OptionsCompleteForm.Visible then
                OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_Active;
        end;

        SC_EndWork: begin
            if Assigned(OptionsCompleteForm) and OptionsCompleteForm.Visible then
                OptionsCompleteForm.GrpBox_ScrobbleLog.Caption := Scrobble_InActive;
        end;

        SC_JobIsDone: NempPlayer.NempScrobbler.JobDone;

        SC_ServiceUnavailable: begin
            // try again.
            // - after a few failures scrobbling will stop for a few minutes.
            // LPAram: Mode (sm_auth, sm_nowplaying, sm_Scrobble)
            case TScrobbleMode(aMsg.LParam) of
                sm_auth: ; // Authentification was not possible. User should try again later.
                sm_NowPlaying,
                sm_Scrobble: // try again
                    NempPlayer.NempScrobbler.ScrobbleAgain(NempPlayer.Status = PLAYER_ISPLAYING);
            end;
        end;

        // ======================================================
        // Scrobbling
        // ======================================================
        SC_NowPlayingComplete: begin
            NempPlayer.NempScrobbler.LogList.Add((PChar(aMsg.LParam)));
            NempPlayer.NempScrobbler.ScrobbleNextCurrentFile(NempPlayer.Status = PLAYER_ISPLAYING);
        end;
        SC_SubmissionComplete: begin
            NempPlayer.NempScrobbler.LogList.Add((PChar(aMsg.LParam)));
            NempPlayer.NempScrobbler.ScrobbleNext(NempPlayer.Status = PLAYER_ISPLAYING);
        end;
        SC_ScrobblingSkipped: begin
            NempPlayer.NempScrobbler.LogList.Add(Format(ScrobblingSkipped, [Integer(aMsg.LParam)]));
            AddErrorLog('Scrobbler:'#13#10 + Format(ScrobbleFailureWait, [Integer(aMsg.LParam)]));
            if not NempPlayer.NempScrobbler.IgnoreErrors then
                MessageDlg(Format(ScrobbleFailureWait, [Integer(aMsg.LParam)]), mtWarning, [mbOK], 0);
        end;
        SC_ScrobblingSkippedAgain : begin
            // no Messagebox here
            NempPlayer.NempScrobbler.LogList.Add(Format(ScrobblingSkipped, [Integer(aMsg.LParam)]));
            AddErrorLog('Scrobbler:'#13#10 + Format(ScrobbleFailureWait, [Integer(aMsg.LParam)]));
        end;

        SC_InvalidSessionKey: begin
            NempPlayer.NempScrobbler.DoScrobble := False;
            ReArrangeToolImages;
            AddErrorLog('Scrobbler:'#13#10 + 'LastFM Session Key is missing or invalid');

            if not NempPlayer.NempScrobbler.IgnoreErrors then
            begin
                if MessageDLG((ScrobbleSettings_Incomplete), mtWarning, [mbYes, mbNo], 0) = mrYes then
                begin
                    if Not Assigned(OptionsCompleteForm) then
                        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
                    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.ScrobbleNode;
                    OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.ScrobbleNode] := True;
                    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabAudio9;
                    OptionsCompleteForm.Show;
                end;
            end;
        end;

        SC_IPSpam: ; // nothing.

        SC_UnknownScrobbleError: begin
            NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
            AddErrorLog('Scrobbler:'#13#10 + Scrobble_UnkownError);
            NempPlayer.NempScrobbler.ScrobbleAgain(NempPlayer.Status = PLAYER_ISPLAYING);
        end;
        SC_IndyException: begin
            NempPlayer.NempScrobbler.LogList.Add(PChar(aMsg.LParam));
            AddErrorLog('Scrobbler:'#13#10 + Scrobble_ConnectError);
            NempPlayer.NempScrobbler.ScrobbleAgain(NempPlayer.Status = PLAYER_ISPLAYING);
        end;

        SC_ScrobbleException: begin
            NempPlayer.NempScrobbler.LogList.Add(Scrobble_ErrorPleaseReport);
            NempPlayer.NempScrobbler.LogList.Add('');
            NempPlayer.NempScrobbler.DoScrobble := False;
            ReArrangeToolImages;

            AddErrorLog('Scrobbler:'#13#10 + ScrobbleException);
            if not NempPlayer.NempScrobbler.IgnoreErrors then
                MessageDlg(ScrobbleException, mtWarning, [mbOK], 0);
        end;
    end;

    if Assigned(OptionsCompleteForm) and OptionsCompleteForm.Visible then
    begin
        OptionsCompleteForm.MemoScrobbleLog.Lines.Assign(NempPlayer.NempScrobbler.LogList);

        OptionsCompleteForm.MemoScrobbleLog.selstart := length(OptionsCompleteForm.MemoScrobbleLog.text);
        OptionsCompleteForm.MemoScrobbleLog.SelLength := 1;
    end;
end;


function Handle_WndProc(var Message: TMessage): Boolean;
var devType: Integer;
  Datos: PDevBroadcastHdr;
//  VolInfo: PDevBroadcastVolume;
//  UnitMask: DWord;
begin
  result := True;

  with Nemp_MainForm do
  case Message.Msg of

    WM_POWERBROADCAST: begin
        case Message.WParam of
            PBT_APMRESUMESUSPEND: begin
                                  if assigned(ShutDownForm) then ShutDownForm.Close;
                                  if NempPlayer.ReInitAfterSuspend then NempPlaylist.RepairBassEngine(True);

            end;
            PBT_APMSUSPEND: if NempPlayer.PauseOnSuspend then NempPlayer.pause;
        end;
    end;

    WM_DEVICECHANGE: begin
                      if (Message.wParam = DBT_DEVICEARRIVAL) or (Message.wParam = DBT_DEVICEREMOVECOMPLETE) then
                      begin
                          Datos := PDevBroadcastHdr(Message.lParam);
                          devType := Datos^.dbch_devicetype;

                          {if (devType = DBT_DEVTYP_DEVICEINTERFACE)
                          then showmessage('DBT_DEVTYP_DEVICEINTERFACE');

                          if (devType = DBT_DEVTYP_VOLUME)
                          then showmessage('DBT_DEVTYP_VOLUME');  }

                        {
                          if (devType = DBT_DEVTYP_VOLUME) and (Message.wParam = DBT_DEVICEARRIVAL) then
                          begin
                              //repair playlist
                              // treat lParam now as PDevBroadcastVolume
                              VolInfo := PDevBroadcastVolume(Message.lParam);

                              UnitMask := VolInfo^.dbcv_unitmask;
                              Showmessage(Inttostr(unitmask));

                          end;

                         }

                          if (devType = DBT_DEVTYP_DEVICEINTERFACE) or (devType = DBT_DEVTYP_VOLUME) then
                          begin // USB Device
                            if Message.wParam = DBT_DEVICEARRIVAL then
                            begin
                              //wuppdi;
                              Message.Result := 1;
                              HandleNewConnectedDrive;
                            end
                            else
                                begin
                                    Message.Result := 1;
                                   // if Assigned(FOnUSBRemove) then
                                   //   FOnUSBRemove(Self);
                                end;

                          end;
                      end;

    end;


    WM_NextCue: begin
            // Anzeige in der Playlist aktualisieren
            NempPlaylist.ActualizeCue;
            // Nächsten Sync setzen
            NempPlayer.SetCueSyncs;
          end;

    WM_NextFile: begin
                      ///--// NempPlayer.StopAndFree;  // das hab ich da grade eben (8.Oktober 2008) eingefügt
                                                      /// UND WARUM BITTESCHÖN ????
                      case NempPlaylist.WiedergabeMode of
                          0,2: begin
                                  //NempPlaylist.UpdateHistory;
                                  NempPlaylist.PlayNext
                          end;
                          1: NempPlaylist.PlayAgain;
                          3: begin
                              if // (NempPlaylist.Count > 1) and
                                 (NempPlaylist.PlayingIndex <> NempPlaylist.Count -1)
                              then
                              begin
                                  //NempPlaylist.UpdateHistory;
                                  NempPlaylist.PlayNext;
                              end
                              else
                              begin
                                  if NempOptions.ShutDownAtEndOfPlaylist then
                                      InitShutDown
                                  else
                                  begin
                                      //NempPlaylist.UpdateHistory;
                                      NempPlayer.LastUserWish := USER_WANT_STOP;
                                      NempPlaylist.Stop;
                                  end;
                               end
                          end;
                      end;
                 end;
    WM_StopPlaylist : begin
                        StopBTNIMGClick(Nil);
                      end;

    WM_ChangeStopBtn: begin
                          case Message.WParam of
                             0: begin
                                        // Normales Stop-Bild anzeigen
                                        StopBtn.GlyphLine := 0;
                                        StopBTN.Hint    := MainForm_StopBtn_NormalHint;
                             end;
                             1: begin
                                        // Aktiviertes Stop-Nach-Titel-Bild anzeigen
                                        StopBtn.GlyphLine := 1;
                                        StopBTN.Hint    := MainForm_StopBtn_StopAfterTitleHint;
                             end;
                          end;
                     end;

    WM_SlideComplete : begin
                   BassTimer.Enabled := NempPlayer.Status = PLAYER_ISPLAYING;
                   if NempPlayer.Status <> PLAYER_ISPLAYING then
                   begin
                     spectrum.DrawClear;
                     Spectrum.DrawText(NempPlayer.PlayingTitel,False);
                     if NempPlayer.Status = PLAYER_ISSTOPPED_MANUALLY then
                       Spectrum.DrawTime('  00:00');
                   end;
                 end;

    WM_ResetPlayerVCL: ReInitPlayerVCL;

    WM_ActualizePlayPauseBtn: begin
                            case Message.LParam of
                                0: begin
                                      case Message.WParam of
                                          NEMP_API_STOPPED, NEMP_API_PAUSED: begin
                                                PlayPauseBTN.GlyphLine := 0;
                                                fspTaskbarManager.ThumbButtons.Items[1].ImageIndex := 1;
                                                PM_TNA_PlayPause.Caption := PlayerBtn_Play;
                                                PM_TNA_PlayPause.ImageIndex := 1;
                                          end;
                                          NEMP_API_PLAYING : begin
                                            PlayPauseBTN.GlyphLine := 1;
                                            fspTaskbarManager.ThumbButtons.Items[1].ImageIndex := 2;
                                            PM_TNA_PlayPause.Caption := PlayerBtn_Pause;
                                            PM_TNA_PlayPause.ImageIndex := 2;
                                          end;
                                      end;
                                      //showmessage(Inttostr(Message.wParam));
                                end;
                                1: begin
                                      case Message.WParam of
                                          NEMP_API_STOPPED: begin
                                                PlayPauseHeadSetBtn.GlyphLine := 0;
                                                //PlayPauseHeadSetBtn.Caption := 'Play';
                                                HeadSetTimer.Enabled := False;
                                                SlidebarButton_Headset.Left := SlideBarShapeHeadset.Left;
                                          end;
                                          NEMP_API_PAUSED: begin
                                                PlayPauseHeadSetBtn.GlyphLine := 0;
                                                HeadSetTimer.Enabled := False;
                                          end;
                                          NEMP_API_PLAYING : begin
                                                PlayPauseHeadSetBtn.GlyphLine := 1;
                                                HeadSetTimer.Enabled := True;
                                          end;
                                      end;
                                end;
                            end;
    end;

    WM_NewMetaData: //DoMeta(PChar(Message.wParam));
                    begin
                        Application.Title := NempPlayer.GenerateTaskbarTitel;
                        //if NempPlayer.StreamRecording AND (oldTitel<> NempPlayer.PlayingTitel) AND NempPlayer.AutoSplitFiles then
                        //    NempPlayer.StartRecording;
                        NempTrayIcon.Hint := StringReplace(NempPlaylist.PlayingFile.Titel, '&', '&&&', [rfReplaceAll]);
                    end;

    WM_PlayerStop, WM_PlayerPlay: begin
                                    BassTimer.Enabled := //NempPlayer.BassStatus = BASS_ACTIVE_PLAYING;
                                                         NempPlayer.Status = PLAYER_ISPLAYING;
                                    if assigned(NempPlayer.MainAudioFile) then
                                    begin
                                        RecordBtn.Enabled := NempPlayer.MainAudioFile.isStream
                                                           and (NempPlayer.BassStatus = BASS_ACTIVE_PLAYING)
                                                           and (NempPlayer.StreamType <> 'Ogg')
                                    end;
                                    if  Message.Msg = WM_PlayerStop then
                                    begin
                                      // Set the SlideBtn to its initial position
                                      SlideBarButton.Left := SlideBarShape.Left;
                                    end;

                                  end;
    WM_PlayerHeadSetEnd : begin
          SlidebarButton_Headset.Left := SlidebarShapeHeadset.Left;
          PlayPauseHeadsetBtn.GlyphLine := 0;


    end;
    WM_PlayerStopRecord : begin
                                 // Aufnahme wurde beendet
                                RecordBtn.GlyphLine := 0;
                                RecordBtn.Hint := (MainForm_RecordBtnHint_Start);
    end;

    WM_PlayerAcceptInput: NempPlaylist.AcceptInput := True;

    // wird in der BirthdayShowForm initialisiert
    WM_COUNTDOWN_FINISH: NempPlayer.PlayBirthday;

    WM_BIRTHDAY_FINISH: begin
      PlayPauseBTNIMGClick(Nil);
      if assigned(BirthdayForm) then BirthdayForm.Close;
    end;

    else
        Result := False;
  end;
end;


function Handle_DropFilesForPlaylist(Var aMsg: TMessage): Boolean;
Var
  Idx,
  Size,
  FileCount: Integer;
  Filename: PChar;
  abspielen: Boolean;
  p: TPoint;
Begin
  result := True;
  with Nemp_MainForm do
  begin
    // Größe der Playlist merken
    abspielen := NempPlaylist.Count = 0;

    LangeAktionWeitermachen := True;

    if (DragSource <> DS_VST) then    // Files kommen von Außerhalb
    begin
        p := PlayListVST.ScreenToClient(Mouse.CursorPos);
        NempPlaylist.InsertNode := PlayListVST.GetNodeAt(p.x,p.y);

        ST_Playlist.Mask := GeneratePlaylistSTFilter;
        FileCount := DragQueryFile (aMsg.WParam, $FFFFFFFF, nil, 255);

        For Idx := 0 To FileCount - 1 Do
        begin
            if LangeAktionWeitermachen then
            begin
                Size := DragQueryFile (aMsg.WParam, Idx, nil, 0) + 2;
                Filename := StrAlloc(Size);

                If DragQueryFile (aMsg.WParam, Idx, Filename, Size) = 2 Then
                { nothing } ;
                if (FileGetAttr(UnicodeString(Filename)) AND faDirectory = faDirectory) then
                    NempPlaylist.ST_Ordnerlist.Add(filename)  // SEARCHTOOL
                else // eine Datei in der gedroppten Liste gefunden
                    if ValidAudioFile(filename, true) then
                        // Musik-Datei
                        NempPlaylist.InsertFileToPlayList(filename)
                    else
                    if ((AnsiLowerCase(ExtractFileExt(filename))='.m3u')
                        or (AnsiLowerCase(ExtractFileExt(filename))='.m3u8')
                        OR (AnsiLowerCase(ExtractFileExt(filename))='.pls')
                        OR (AnsiLowerCase(ExtractFileExt(filename))='.npl')
                        OR (AnsiLowerCase(ExtractFileExt(filename))='.asx')
                        OR (AnsiLowerCase(ExtractFileExt(filename))='.wax'))
                        AND (FileCount = 1)
                    then
                        NempPlaylist.LoadFromFile(filename)
                    else
                        if (AnsiLowerCase(ExtractFileExt(filename))='.cue')
                           AND (FileCount = 1)
                        then
                            LoadCueSheet(filename);

                StrDispose(Filename);
            end; //if Not Sucheabgebrochen
        end;
        DragFinish (aMsg.WParam);
        DragSource := DS_EXTERN;

        if (NempPlaylist.ST_Ordnerlist.Count > 0) And (Not ST_Playlist.IsSearching) then
        begin
            NempPlaylist.Status := 1;
            ST_Playlist.SearchFiles(NempPlaylist.ST_Ordnerlist[0]);
        end else
            LangeAktionWeitermachen := False;
    end
    else
    begin   // Quelle ist der VST -> in die Playlist einfügen
        p := PlayListVST.ScreenToClient(Mouse.CursorPos);
        NempPlaylist.InsertNode := PlayListVST.GetNodeAt(p.x,p.y);

        for idx := 0 to DragDropList.Count - 1 do
            NempPlaylist.InsertFileToPlayList(DragDropList[idx]);

        DragDropList.Clear;
        IMGMedienBibCover.EndDrag(true);
        DragFinish (aMsg.WParam);
        DragSource := DS_EXTERN;
        LangeAktionWeitermachen := False;
        // Hier ggf. Abspielen
        if abspielen AND (NempPlaylist.Count > 0) then
        begin
            NempPlayer.LastUserWish := USER_WANT_PLAY;
            NempPlaylist.Play(0, 0, True);
        end;
    end;
  end;
End;

function Handle_DropFilesForLibrary(Var aMsg: TMessage): Boolean;
Var
  Idx,
  Size,
  FileCount: Integer;
  Filename: PChar;
  AudioFile:TAudioFile;
  aErr: TAudioError;
Begin
    result := True;

    if Nemp_MainForm.NempSkin.NempPartyMode.DoBlockBibOperations then
    begin
        DragFinish (aMsg.WParam);
        Nemp_MainForm.DragSource := DS_EXTERN;
        exit;
    end;


    with Nemp_MainForm do
    begin
          if (DragSource <> DS_VST) then    // Files kommen von Außerhalb
          begin
              LangeAktionWeitermachen := True;

              if MedienBib.StatusBibUpdate <> 0 then
              begin
                MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
                DragFinish (aMsg.WParam);
                DragSource := DS_EXTERN;
                exit;
              end;
              ST_Medienliste.Mask := GenerateMedienBibSTFilter;
              MedienBib.StatusBibUpdate := 1;

              FileCount := DragQueryFile(aMsg.WParam, $FFFFFFFF, nil, 255);

              For Idx := 0 To FileCount -1 Do
              Begin
                  if LangeAktionWeitermachen then
                  begin
                      Size := DragQueryFile (aMsg.WParam, Idx, nil, 0) + 2;
                      Filename := StrAlloc (Size);

                      If DragQueryFile (aMsg.WParam, Idx, Filename, Size) = 2 Then
                      { nothing } ;
                      if (FileGetAttr(UnicodeString(Filename)) AND faDirectory = faDirectory) then
                      begin // ein Ordner in der gedroppten Liste gefunden
                        // SEARCHTOOL
                        MedienBib.ST_Ordnerlist.Add(filename);
                      end
                      else // eine Datei in der gedroppten Liste gefunden

                        if ValidAudioFile(filename, False) then
                        begin // Musik-Datei
                              if Not MedienBib.AudioFileExists(filename) then
                              begin
                                AudioFile:=TAudioFile.Create;
                                aErr := AudioFile.GetAudioData(filename, GAD_Cover or GAD_Rating);
                                HandleError(afa_DroppedFiles, AudioFile, aErr);

                                MedienBib.InitCover(AudioFile);
                                MedienBib.UpdateList.Add(AudioFile);
                              end;
                        end;

                      StrDispose(Filename);
                  end; //if Not Sucheabgebrochen
              End;
              DragFinish (aMsg.WParam);
              DragSource := DS_EXTERN;

              if MedienBib.ST_Ordnerlist.Count > 0 then
              begin
                PutDirListInAutoScanList(MedienBib.ST_Ordnerlist);
                BlockeMedienListeUpdate(True);
                ST_Medienliste.SearchFiles(MedienBib.ST_Ordnerlist[0])
              end
              else
                // Die Dateien einpflegen, die evtl. einzeln in die Updatelist geaten sind
                MedienBib.NewFilesUpdateBib;
          end;
    end;
end;

function Handle_DropFilesForHeadPhone(Var aMsg: TMessage): Boolean;
Var
  Size,
  FileCount: Integer;
  Filename: PChar;
  AudioFile:TAudioFile;
  aErr: TAudioError;

      procedure AddFileToHeadSet(af: String);
      begin
          AudioFile := TAudioFile.Create;
          try
              aErr := AudioFile.GetAudioData(af, GAD_Cover or GAD_Rating);
              HandleError(afa_DroppedFiles, AudioFile, aErr);
              // Play new song in headset
              NempPlayer.PlayInHeadset(AudioFile);
              // Show Details
              Nemp_MainForm.ShowHeadsetDetails(AudioFile);
          finally
              AudioFile.Free
          end;
      end;

begin
    result := True;
    with Nemp_MainForm do
    begin
        if (DragSource <> DS_VST) then    // Files kommen von Außerhalb
        begin
            FileCount := DragQueryFile (aMsg.WParam, $FFFFFFFF, nil, 255);

            if FileCount = 1 then
            begin
                // ok, one file for headphone
                // ... TODO
                Size := DragQueryFile (aMsg.WParam, 0, nil, 0) + 2;
                Filename := StrAlloc(Size);
                If DragQueryFile (aMsg.WParam, 0, Filename, Size) = 2 Then { nothing } ;

                if (FileGetAttr(UnicodeString(Filename)) AND faDirectory = faDirectory) then
                begin
                    // Directory, put it into the library
                    Handle_DropFilesForLibrary(aMsg);
                    exit;
                end
                else // eine Datei in der gedroppten Liste gefunden
                begin
                    if ValidAudioFile(filename, true) then
                    begin
                        // AudioFile found, put it into the HeadPhone
                        AddFileToHeadSet(filename);
                    end;
                end;
            end else
            begin
                // more than one file, put them into the library
                Handle_DropFilesForLibrary(aMsg);
                exit;
            end;

            DragFinish (aMsg.WParam);
            DragSource := DS_EXTERN;
        end
        else
        begin   // Quelle ist der VST -> in die Playlist einfügen
            if DragDropList.Count = 1 then
            begin
                // AudioFile found, put it into the HeadPhone
                AddFileToHeadSet(DragDropList[0]);
            end;
            DragDropList.Clear;
            IMGMedienBibCover.EndDrag(true);
            DragFinish (aMsg.WParam);
            DragSource := DS_EXTERN;
        end;
    end;
end;

procedure CurDir(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); pascal;
begin
  Nemp_MainForm.AuswahlStatusLbl.Caption :=
      Format((MediaLibrary_SearchingNewFiles),  [MedienBib.UpdateList.Count, ST_Medienliste.CurrentDir]);
  Nemp_MainForm.AuswahlStatusLbl.Update;
end;

procedure Handle_STStart(var Msg: TMessage);
begin
    if Msg.WParam = ST_ID_Medialist then
    begin
      Nemp_MainForm.AuswahlStatusLbl.Caption := (MediaLibrary_StartSearchingNewFiles);
      Nemp_MainForm.AuswahlStatusLbl.Update;
      tid := timeSetEvent(500, 1, @CurDir, 0, TIME_PERIODIC);
    end;
end;

procedure Handle_STNewFile(var Msg: TMessage);
var NewFile: UnicodeString;
  audioFile: TAudiofile;
  jas: TJustaString;
  ext: String;
  aErr: TAudioError;
begin
    With Nemp_MainForm do
    begin
        NewFile := PWideChar(Msg.LParam);

        if Msg.WParam = ST_ID_Medialist then
        // Datei in die MedienListe aufnehmen
        begin
            ext := AnsiLowerCase(ExtractFileExt(NewFile));
            // Unterscheiden, ob Playlist-Datei oder normal:
            if (ext = '.m3u') or (ext = '.m3u8') or (ext = '.pls') or (ext = '.npl')
                              or (ext = '.asx') or (ext = '.wax')
            then begin
                if Not MedienBib.PlaylistFileExists(NewFile) then
                begin
                    jas := TJustaString.create(NewFile, ExtractFileName(NewFile));
                    MedienBib.PlaylistUpdateList.Add(jas);
                end;
            end else
                if Not MedienBib.AudioFileExists(NewFile) then
                begin
                    AudioFile:=TAudioFile.Create;
                    aErr := AudioFile.GetAudioData(NewFile, GAD_Cover or GAD_Rating);
                    HandleError(afa_NewFile, AudioFile, aErr);

                    MedienBib.InitCover(AudioFile);
                    MedienBib.UpdateList.Add(AudioFile);
                end;
        end else
        begin
          // Datei nur in die Playlist übernehmen
          NempPlaylist.InsertFileToPlayList(NewFile);
          if (NempPlayer.Mainstream = 0) then
          begin
            InitPlayingFile(NempPlaylist.AutoplayOnStart);
          end;
        end;
    end;
end;

procedure Handle_STFinish(var Msg: TMessage);
begin
    With Nemp_MainForm do
    begin
        //wenn PostMessages eingestellt sind, wird so sichergestellt, dass die auch wirklich alle Messages abgearbeitet sind
        Application.ProcessMessages;

        case Msg.WParam of
          ST_ID_Playlist: begin
                if NempPlaylist.ST_Ordnerlist.Count > 0 then
                  NempPlaylist.ST_Ordnerlist.Delete(0);

                if NempPlaylist.ST_Ordnerlist.Count > 0 then
                begin
                  ST_Playlist.SearchFiles(NempPlaylist.ST_Ordnerlist[0])
                end else
                begin
                  NempPlaylist.Status := 0;
                  LangeAktionWeitermachen := False;
                  fspTaskbarManager.ProgressState := fstpsNoProgress;
                end;

          end;
          ST_ID_Medialist: begin
                //Timer stoppen
                timeKillEvent(tid);

                if Medienbib.ST_Ordnerlist.Count > 0 then
                  Medienbib.ST_Ordnerlist.Delete(0);

                if Medienbib.ST_Ordnerlist.Count > 0 then
                begin
                  PutDirListInAutoScanList(MedienBib.ST_Ordnerlist);
                  MedienBib.StatusBibUpdate := 1;
                  BlockeMedienListeUpdate(True);
                  ST_Medienliste.SearchFiles(Medienbib.ST_Ordnerlist[0])
                end
                else
                begin
                    // Dateisuche fertig. Starte Updatekram
                    MedienBib.NewFilesUpdateBib;
                    fspTaskbarManager.ProgressState := fstpsNoProgress;
                end;
          end;
        end;
    end;
end;


initialization

    FillChar(NEMP_API_InfoString[0], length(NEMP_API_InfoString), #0);
    FillChar(NEMP_API_InfoStringW[0], sizeof(WideChar) * length(NEMP_API_InfoStringW), #0);

finalization

end.


