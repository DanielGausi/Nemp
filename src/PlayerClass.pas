{

    Unit PlayerClass

    One of the Basic-Units - The Player

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

unit PlayerClass;

interface

uses  Windows, Classes,  Controls, StdCtrls, ExtCtrls, Buttons, SysUtils, Contnrs,
      ShellApi, IniFiles, Dialogs, Graphics, cddaUtils,
      bass, bass_fx, basscd, spectrum_vis, DateUtils,
      AudioFileClass,  Nemp_ConstantsAndTypes, ShoutCastUtils, PostProcessorUtils,
      Hilfsfunktionen, MP3FileUtils, gnuGettext, Nemp_RessourceStrings, OneINst,
      Easteregg, ScrobblerUtils, CustomizedScrobbler;

const USER_WANT_PLAY = 1;
      USER_WANT_STOP = 2;

type
  TNempBirthdayTimer = record
      UseCountDown: Boolean;
      StartTime: TDateTime;
      StartCountDownTime: TDateTime;
      BirthdaySongFilename: String;
      CountDownFileName: String;
      ContinueAfter: Boolean;
    end;

  TNempPlayer = class
    private

      fMainVolume: Single;          // the main volume of the player
      fHeadsetVolume: Single;       // the volume of the secondary player (headset)
      fSampleRateFaktor: Single;    // Factor to multiply the samplerate with (0.5 to 2)

      // values for Echo and Hall
      fEchoWetDryMix: single;
      fEchoTime: single;
      fReverbMix: single; // 0..96

      fPlayingTitel: UnicodeString; // the title of the current file, i.e. "interpret - title"
      fPlayingTitelMode: Word;      // mode of this string, i.e. title, bitrate, lyrics

      fIsURLStream: Boolean;
      fHeadsetIsURLStream: Boolean;

      // in some cases, fading must be disabled (e.g. cda, backward)
      fReallyUseFading: Boolean;

      // handles for sliding, crossfading, ...
      // *M / *S: Mainstream/SlideStream
      fCueSyncHandleM: DWord;
      fCueSyncHandleS: DWord;
      fFileEndSyncHandleM: DWord;
      fFileEndSyncHandleS: DWord;
      fFileNearEndSyncHandleM: DWord;
      fFileNearEndSyncHandleS: DWord;
      fSlideEndSyncM: DWord;
      fSlideEndSyncS: DWord;

      fHeadsetFileEndSyncHandle: DWord;

      fStatus: Integer;       // Playing, paused, stopped
      fStopStatus: Integer;   // "normal Stop" or "Stop after title"

      ///  fSlideIsStopSlide:
      ///  Used by EndSlideProc. If True, then an additional "StopMessage" is sent
      ///  to set the SlideButton to its initial position.
      ///  Set to True on Stop with fading
      ///  False on SetSlideSyncs and after sending the StopMessage
      fSlideIsStopSlide: Boolean;

      ///  fLastUserWish
      ///  USER_WANT_PLAY or USER_WANT_STOP
      ///  This should be set ONLY after a User-interaction liek buttonclick, doubleclick on a file, ...
      fLastUserWish: Integer;

      // Values for recording a webstream
      fRecordStartTime: TDateTime;
      fAutoSplitMaxSizeMB: Integer;
      fAutoSplitMaxSizeByte: Integer;

      // Flags for creating streams
      fFloatable: DWord;
      fSoftwareFlag: DWord;
      fUseFloatingPointChannels: Integer; // 0: Auto-Detect, 1: Aus, 2: An
      fUseHardwareMixing: Boolean;        // False: OR BASS_SAMPLE_SOFTWARE

      fMainWindowHandle: HWND;    // the main window, where some messages are sent to
      fPathToDlls: String;        // the path to the bass.dll-addons

      fDefaultCoverIsLoaded: Boolean;


      // Basic method for creating a stream from a given file   //filename
      function NEMP_CreateStream(aFile: TAudioFile; //UnicodeString;
                           aNoMickyMaus: boolean;
                           aReverse: boolean;
                           checkEasterEgg: boolean = False): DWord;

      function EqualizerIsNeeded: boolean;
      procedure InitStreamEqualizer(aStream: DWord);

      // Setter/getter for some properties
      procedure SetVolume(Value: Single);         // Volume
      function GetVolume: Single;
      procedure SetPosition(Value: Longword);     // Position
      function GetTime: Double;
      procedure SetTime(Value: Double);
      function GetProgress: Double;               // Progress
      procedure SetProgress(Value: Double);
      function GetLength: Double;                 // Length of a song

      procedure SetHeadsetVolume(Value: Single);    // the same stuff for the
      function GetHeadsetVolume: Single;
      function GetHeadsetTime: Double;              // secondary (headset) stream
      procedure SetHeadsetTime(Value: Double);
      function GetHeadsetProgress: Double;
      procedure SetHeadsetProgress(Value: Double);
      function GetHeadsetLength: Double;

      function GetBassStatus: DWord;    // returns the status of the bass.dll (playing, paused, ..)
                                        // this is NOT the same as fStatus!

      function GetBassHeadSetStatus: DWord;

      Procedure SetSamplerateFactor(Value: Single);   // Samplerate
      Procedure SetEchoMix(Value: Single);            // Echo
      Procedure SetEchoTime(Value: Single);
      Procedure SetEcho(mix, time: Single);
      Procedure SetReverbMix(Value: Single);          // Hall
      procedure SetPlayingTitelMode(Value: Word);     // Playing-title-mode
      procedure SetAutoSplitMaxSize(Value: Integer);  // Split size for webstream recording
      function GetFloatable: Boolean;

      procedure GetURLDetails;  // Get Data from a webstream and set syncs for Meta-information

      // ResetPlayerVCL: Send a Message to the main window to restore some buttons (rewind-button)
      // This is done on beginning of a new song
      procedure ResetPlayerVCL;
      // set the play/pause button according to the current state of the player
      procedure ActualizePlayPauseBtn(wParam, lParam: Integer);
      // send a Message to the Deskband (set play/pause-button there as well)
      procedure UpdateDeskband(wParam, lParam: Integer);

    public
        MainAudioFile: TPlaylistFile;
        HeadSetAudioFile: TPlaylistFile;
        MainWindowHandle: DWord;

        MainStream: DWord;
        SlideStream: DWord;
        Jinglestream: DWORD;
        HeadsetStream: DWord;

        CountDownStream: DWord;
        BirthdayStream: DWord;
        BirthdayCountDownSyncHandle: DWord;
        BirthdaySyncHandle: DWord;

        MainStreamIsReverseStream: Boolean;
        MainStreamIsTempoStream: Boolean;

        ///  MainAudioFileIsPresentAndPlaying:
        ///  Used for Playlist.AutoDelete - FileNotFound-entries in the
        ///  playlist should not be remove from the playlist
        MainAudioFileIsPresentAndPlaying: Boolean;

        ///  Playlist.AutoDelete checks for NewFile = PlayingFile
        ///  and cancel AutoDelete if true (in case the user doubleclicks the same file again)
        ///  This will cause an endless-loop if only one file is in the playlist
        ///  EndFileProcreached will cancel the cancel.
        EndFileProcReached: Boolean;

        // Status-Callback-Proc for CreateURL
        Statusproc: DOWNLOADPROC;

        ValidExtensions: TStringlist; // a list of valid file extensions (mp3, wav, ogg, aac, m4a, ...)

        //Some settings stored in the ini-file
        MainDevice: LongWord;
        HeadsetDevice: LongWord;
        UseFading: Boolean;
        FadingInterval: Integer;
        SeekFadingInterval: Integer;
        IgnoreFadingOnShortTracks: Boolean;
        IgnoreFadingOnPause: Boolean;
        IgnoreFadingOnStop: Boolean;

        AvoidMickyMausEffect: Boolean;
        UseDefaultEffects: Boolean;
        UseDefaultEqualizer: Boolean;
        PlayBufferSize: DWORD;

        UseVisualization: Boolean;
        VisualizationInterval: Integer;

        TimeMode: Byte;
        ScrollTaskbarTitel: Boolean;
        ScrollAnzeigeTitel: Boolean;
        ScrollTaskbarDelay: Integer;
        ScrollAnzeigeDelay: Integer;

        ReInitAfterSuspend: Boolean;
        PauseOnSuspend    : Boolean;

        ReduceMainVolumeOnJingle: Boolean;
        ReduceMainVolumeOnJingleValue: Integer;
        JingleVolume: Integer;

        // settings for webradio
        DownloadDir: UnicodeString;
        FilenameFormat: String;     // Muster für die Dateibenennung. Muss entsprechend geparsed werden
        UseStreamnameAsDirectory: Boolean;
        AutoSplitByTitle: Boolean;  // Jeden Titel in eigene Datei schreiben
        AutoSplitByTime: Boolean;
        AutoSplitBySize: Boolean;
        AutoSplitMaxTime: Integer; // time in minutes
        //AutoSplitMaxSize not here. See SetAutoSplitMaxSize

        // Gain for Equalizer
        fxGain: array[0..9] of single;
        EQSettingName: String;
        // Bass-stuff for equalizer
        BassEQNew  : BASS_BFX_PEAKEQ ;   // dsp peaking equalizer
        EqMainHnd : DWord;
        EqSlideHnd : DWord;

        //Compressor
        BassCompress: BASS_BFX_COMPRESSOR;
        BassFXEcho : BASS_DX8_ECHO;
        EchoMainHnd: DWord;
        EchoSlideHnd: DWord;
        BassFXReverb: BASS_DX8_REVERB;
        ReverbMainHnd: DWord;
        ReverbSlideHnd: DWord;
        OrignalSamplerate: Single;

        EQ_IsActive: Boolean;
        Reverb_IsActive: Boolean;
        Echo_IsActive: Boolean;

        IsMute: Boolean;
        StreamType: String;

        NempBirthdayTimer: TNempBirthdayTimer;

        // when holding the hotkey for volume +/-
        // the "speed" of changing the volume is increased. This value
        // is saved in VolStep
        VolStep: DWord;

        ReadyForRecord: Boolean;   // i.e. we are playing a webstream
        StreamRecording: Boolean;  // recording is active
        RecordStream: TFileStream;

        MainStation: TStation; // used for direct insert of a radiostation

        NempScrobbler: TNempScrobbler;   // the Scrobbler-thingy
        PostProcessor: TPostProcessor;   // the Postprocessor: change rating of the file and scrobble it

        CoverBitmap: TBitmap;    // The Cover of the current file
        PreviewBackGround: TBitmap; // The BackGroundImage for the Win7-Preview

        property Volume: Single read GetVolume write SetVolume;
        property HeadSetVolume: Single read GetHeadsetVolume write SetHeadsetVolume;
        property Time: Double read GetTime write SetTime;              // time in seconds
        property Progress: Double read GetProgress write SetProgress;  // 0..1
        property Dauer: Double read Getlength;

        property Speed: Single read fSampleRateFaktor write SetSamplerateFactor;
        property EchoWetDryMix: single  read fEchoWetDryMix write SetEchoMix  ;
        property EchoTime: single       read fEchoTime      write SetEchoTime;
        property ReverbMix: single      read fReverbMix     write SetReverbMix  ;

        property PlayingTitel: UnicodeString read fPlayingTitel;
        property PlayingTitelMode: Word read fPlayingTitelMode write SetPlayingTitelMode;

        property URLStream: Boolean read fIsUrlStream;

        property Status: Integer read fStatus;
        property StopStatus: Integer read fStopStatus;
        property BassStatus: DWord read GetBassStatus;
        property BassHeadSetStatus: DWord read GetBassHeadSetStatus;

        property LastUserWish: Integer read fLastUserWish write fLastUserWish;

        property AutoSplitMaxSize: Integer read fAutoSplitMaxSizeMB write SetAutoSplitMaxSize;

        property Floatable: Boolean read GetFloatable;
        property UseFloatingPointChannels: Integer read fUseFloatingPointChannels write fUseFloatingPointChannels;
        property UseHardwareMixing: Boolean read fUseHardwareMixing write fUseHardwareMixing;

        constructor Create(AHnd: HWND);
        destructor Destroy; override;

        procedure InitBassEngine(HND: HWND; PathToDlls: String; var Filter: UnicodeString);
        // Nötig z.B. bei meinem Notebook, wenn man aus dem Ruhezustand hochkommt
        procedure ReInitBassEngine;
        procedure UpdateFlags;

        procedure LoadFromIni(Ini: TMemIniFile);
        procedure WriteToIni(Ini: TMemIniFile);

        // Play: Spielt ein Audiofile ab.
        procedure play(aAudioFile: TPlaylistFile; Interval: Integer; StartPlay: Boolean; StartPos: Float = 0);
        // Hält die Wiedergabe an.
        // Bei Streams wird gestoppt, bei Dateien pausiert
        procedure pause;
        // Hält die Wiedergabe an
        // The parameter is used to cancel the "IgnoreFadingOnStop"-setting
        // if the player stops current playback to start a new one, there should be fading!
        procedure stop(StartPlayAfterStop: Boolean = False);
        // Setzt eine angehaltene Wiedergabe wieder fort
        procedure resume;
        // Langsam ausfaden bei einem ShutDown. Keine neuen Titel anfangen. Max. Fade-Zeit aTime in Sekunden
        procedure FadeOut(aTime: Integer);
        // FadeOut Abbrechen
        procedure CancelFadeOut;

        // Stoppt die wiedergabe und gibt die streams frei,
        // setzt mainstream und slidestream auf 0
        procedure StopAndFree(StartPlayAfterStop: Boolean = False);
        // Kehrt die Richtung der Wiedergabe um
        procedure ReversePlayback(FromBeginning: Boolean);

        procedure Mute;
        procedure UnMute;

        // einen Jingle abspielen und wieder stoppen
        procedure PlayJingle(aAudioFile: TAudioFile); // kein PlaylistFile, weil auch aus der Medienliste ein Jingle gespielt werden kann
        procedure StopJingle;

        // eine Datei im Headset abspielen
        procedure PlayInHeadset(aAudioFile: TAudioFile); // kein PlaylistFile, weil auch aus der Medienliste ein Jingle gespielt werden kann
        procedure StopHeadset;
        procedure PauseHeadset;
        procedure ResumeHeadset;
        property HeadsetTime: Double read GetHeadsetTime write SetHeadsetTime;
        // Fortschritt in Bruchteilen (0..1)
        property HeadsetProgress: Double read GetHeadsetProgress write SetHeadsetProgress;
        property HeadsetDauer: Double read GetHeadsetLength;

        function GenerateTitelString(aAudioFile: TAudioFile; aMode: integer): UnicodeString;
        // Aktualisiert den String, der in der Anzeige durchläuft
        procedure RefreshPlayingTitel;
        function GenerateTaskbarTitel: UnicodeString;

        // Aktualisiert den Text, die Zeit und das Spectrum in der Anzeige
        procedure DrawInfo(IncludingTime: Boolean = True);
        procedure DrawTimeFromProgress(aProgress: Single);

        function RefreshCoverBitmap: Boolean;
        function DrawPreview( DestWidth : Integer; DestHeight : Integer;
                            SkinActive : Boolean = True) : HBITMAP;

        procedure SetCueSyncs;

        procedure SetEndSyncs(dest: DWord); // Stream, in dem sie gesetzt werden sollen
        procedure SetNoEndSyncs(dest: DWord); // NoEnd: Kein AutoplayNext.
        // eben diese Sync entfernen - sonst kann es bei Pause/Stop mit Fading
        // zu einem Playnext kommen ;-)
        procedure RemoveEndSyncs;

        procedure SetSlideEndSyncs;
        function GetActiveCue: integer;
        function JumpToNextCue: Boolean;
        function JumpToPrevCue: Boolean;

        Procedure SetEqualizer(band: Integer; gain: Single);

        procedure ReadBirthdayOptions(aIniFilename: UnicodeString);
        procedure WriteBirthdayOptions(aIniFilename: UnicodeString);
        function GetCountDownLength(aFilename: UnicodeString): Integer;
        Procedure PlayCountDown; // Countdown abspielen mit setzen der Syncs
        Procedure PlayBirthday; // Geburttsgalied abspielen
        Procedure AbortBirthday;
        Function CheckBirthdaySettings: Boolean; // Überprüft die Optionen auf Gültigkeit

        // Überprüft, ob ein String ein gültiges Format hat (für Verwendung in der Optionen-Form)
        // function IsValidFilenameFormat(aFormatString: String): Boolean;
        // Baut entsprechend des Vorgabemusters einen Dateinamen
        function GenerateRecordingFilename(Extension: String): UnicodeString;
        function StartRecording: Boolean;
        procedure StopRecording;
        // Ermitteln, ob neue Daten noch in den Stream passen, oder ob ein neuer Angefangen werden soll
        function SplitRecordStreamNow(BufLen: DWORD): Boolean;  // BufLen: Länge des neuen Buffers

  end;


Const
  // Kopie aus der bass.dll - nicht ändern!!!
  // BASS_ChannelIsActive return values
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED  = 3;



implementation

Uses NempMainUnit, AudioFileHelper, CoverHelper;


procedure EndFileProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    // If this is called, the file is on its end.
    TNempPlayer(User).EndFileProcReached := True;
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_NextFile, 0, 0);
end;

procedure EndHeadSetFileProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_PlayerHeadSetEnd, 0, 0);
end;

procedure StopPlaylistProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_StopPlaylist, 0, 0);
end;

procedure NextCueProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_NextCue, 0, 0);
end;

procedure EndSlideProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_SlideComplete, 0, 0);

    if TNempPlayer(User).fSlideIsStopSlide then
        SendMessage(TNempPlayer(User).MainWindowHandle, WM_PlayerStop, 0, 0);
    TNempPlayer(User).fSlideIsStopSlide := False;
end;

procedure EndCountdownProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_COUNTDOWN_FINISH, 0, 0);
end;

procedure EndBirthdayProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_BIRThDAY_FINISH, 0, 0);
end;

procedure DoMeta(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
var
  p: Integer;
  oldTitel: UnicodeString;
  meta: String;
begin
  oldTitel := '';
  meta := String(BASS_ChannelGetTags(channel, BASS_TAG_META));

  if (meta <> '') AND (TNempPlayer(User).MainAudioFile <> NIL) then
  begin
        oldTitel := TNempPlayer(User).PlayingTitel;
        p := Pos('StreamTitle=', meta);
        if (p > 0) then
        begin
              p := p + 13;
              TNempPlayer(User).MainAudioFile.Titel := Copy(meta, p, Pos(';', meta) - p - 1);
        end;

        TNempPlayer(User).RefreshPlayingTitel;
        if TNempPlayer(User).StreamRecording AND (oldTitel<> TNempPlayer(User).PlayingTitel) AND TNempPlayer(User).AutoSplitByTitle then
            TNempPlayer(User).StartRecording;

        SendMessage(TNempPlayer(User).MainWindowHandle, WM_NewMetaData, 0, 0);
  end;
end;

procedure DoOggMeta(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
var
  oldTitel: UnicodeString;
  meta: PAnsiChar;
  metaStr: String;
begin
  oldTitel := '';

  meta := BASS_ChannelGetTags(channel, BASS_TAG_OGG);

  if (meta <> nil) AND (TNempPlayer(User).MainAudioFile <> NIL) then
  begin
      oldTitel := TNempPlayer(User).PlayingTitel;
      // nach Ogg-Daten suchen
      if (meta <> nil) then
          try
              while (meta^ <> #0) do
              begin
                  metaStr := String(meta);
                  if (AnsiUppercase(Copy(metaStr, 1, 7)) = 'ARTIST=') then
                  begin
                    TNempPlayer(User).MainAudioFile.Artist := Copy(metaStr, 8, Length(metaStr) - 7);
                  end else
                    if (AnsiUppercase(Copy(metaStr,1,6)) = 'TITLE=') then
                    begin
                      TNempPlayer(User).MainAudioFile.Titel := trim(Copy(metaStr, 7, Length(metaStr) - 6 ));
                    end;
                  meta := meta + Length(meta) + 1;
              end;
          except
            // Wenn was schief gelaufen ist: Dann gibts halt keine Tags...
          end;

      TNempPlayer(User).RefreshPlayingTitel;
      if TNempPlayer(User).StreamRecording AND (oldTitel<> TNempPlayer(User).PlayingTitel) AND TNempPlayer(User).AutoSplitByTitle then
          TNempPlayer(User).StartRecording;

      SendMessage(TNempPlayer(User).MainWindowHandle, WM_NewMetaData, 0, 0);
  end;
end;


{
    --------------------------------------------------------
    Create, Destroy
    --------------------------------------------------------
}
constructor TNempPlayer.Create(AHnd: HWND);
begin
    inherited create;
    ValidExtensions := TStringlist.Create;
    // Standard-Extensions hinzufügen
    ValidExtensions.CaseSensitive := False;
    ValidExtensions.Add('.mp3'); ValidExtensions.Add('.ogg');
    ValidExtensions.Add('.wav'); ValidExtensions.Add('.mp1');
    ValidExtensions.Add('.mp2'); ValidExtensions.Add('.aiff');
    ValidExtensions.Add('.mo3'); ValidExtensions.Add('.it');
    ValidExtensions.Add('.xm'); ValidExtensions.Add('.s3m');
    ValidExtensions.Add('.mtm'); ValidExtensions.Add('.mod');
    ValidExtensions.Add('.umx');
    ValidExtensions.Add('.cda');

    isMute := False;
    ReadyForRecord := False;
    StreamRecording := False;

    fReallyUseFading := True;
    MainWindowHandle := AHnd;
    MainStation := TStation.Create(aHnd);

    NempScrobbler := TNempScrobbler.Create(aHnd);
    NempScrobbler.InitScrobbler;
    PostProcessor := TPostProcessor.Create(aHnd);
    PostProcessor.NempScrobbler := NempScrobbler;

    CoverBitmap := TBitmap.Create;
    CoverBitmap.Width := 180;
    CoverBitmap.Height := 180;
    PreviewBackGround := TBitmap.Create;
    PreviewBackGround.Width :=200;
    PreviewBackGround.Height := 145;
end;

destructor TNempPlayer.Destroy;
var i: Integer;
    BassInfo: BASS_DEVICEINFO;
begin
    CoverBitmap.Free;
    PreviewBackGround.Free;
    FreeAndNil(ValidExtensions);
    i := 0;
    while (Bass_GetDeviceInfo(i, BassInfo)) do
    begin
        BASS_SetDevice(i);
        BASS_Free;
        inc(i);
    end;
    MainStation.Free;
    PostProcessor.Free;
    NempScrobbler.Free;

    if assigned(HeadSetAudioFile) then
        HeadSetAudioFile.Free;
    inherited Destroy;
end;

{
    --------------------------------------------------------
    Initialization of the bass-engine
    --------------------------------------------------------
}
procedure TNempPlayer.InitBassEngine(HND: HWND; PathToDlls: String; var Filter: UnicodeString);
var count: LongWord;
    fh: THandle;
    fd: TWin32FindData;
    plug: DWORD;
    Info: PBass_PluginInfo;
    a,i: integer;
    tmpext: TStringList;
    tmpfilter: String;
    BassInfo: BASS_DEVICEINFO;

begin
    // diese Werte werden bei einem Re-Init gebraucht!
    fMainWindowHandle := HND;
    fPathToDlls := PathToDlls;

    // Ensure correct Bass-version was loaded
    if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
      MessageDLG((Bass_ErrorStr_BassNotFound), mtError, [MBOK], 0);

    // enable floating-point DSP
    BASS_SetConfig(BASS_CONFIG_FLOATDSP, 1);

    BASS_SetConfig(BASS_CONFIG_NET_PLAYLIST, 1);

    BASS_SetConfig(
    BASS_CONFIG_DEV_DEFAULT,
    1
    );

    if NOT BASS_Init(MainDevice, 44100, 0, HND, nil) then
    begin
      // zweiter Versuch, Standard-Device öffnen
      BASS_Init(-1, 44100, 0, HND, nil);
    end;

    // alle devices initialisieren. evtl. macht man jetzt was doppelt, aber das is
    // mir erstmal wurscht.
    count := 0;

    while (Bass_GetDeviceInfo(count, BassInfo)) do
    begin
        BASS_Init(count, 44100, 0, HND, nil);
        inc(count);
    end;

    // Device für den Hauptthread hier auf MainDevice stellen,
    // bei Fehlschlag auf 1.
    // Schlägt auch das fehl: gute nacht ;-)
    if not Bass_SetDevice(MainDevice) then
        Bass_SetDevice(1);

    if Count < HeadsetDevice then
        HeadsetDevice := MainDevice;

    BASS_SetConfig(BASS_CONFIG_BUFFER, PlayBufferSize);
    UpdateFlags;
    Filter := '|Standard formats (*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.aif)' + '|'
                   + '*.mp3;*.mp2;*.mp1;*.ogg;*.wav*;*.aif';

    // PLugins laden. Code aus dem PLugin-Beipsiel -Projekt
    fh := FindFirstFile(PChar(PathToDlls + 'bass*.dll'), fd);
    if (fh <> INVALID_HANDLE_VALUE) then
    try
        repeat
            plug := BASS_PluginLoad(PChar(PathToDlls + fd.cFileName), BASS_UNICODE);
            if Plug <> 0 then
            begin
                Info := BASS_PluginGetInfo(Plug); // get plugin info to add to the file selector filter...
                for a := 0 to Info.formatc - 1 do
                begin
                    // Set The OpenDialog additional, to the supported PlugIn Formats
                    Filter := Filter
                      + '|' + String(Info.Formats[a].name) + ' ' + '(' +
                      String(Info.Formats[a].exts) + ')' { , ' + fd.cFileName} + '|' + String(Info.Formats[a].exts);

                    //ValidExtensions
                    tmpext := Explode(';', String(Info.Formats[a].exts));
                    for i := 0 to tmpext.Count - 1 do
                        ValidExtensions.Add(StringReplace(tmpext.Strings[i],'*', '',[]));
                    FreeAndNil(tmpext);// im Explode wirds erzeugt
                end;
            end
        until Not FindNextFile(fh, fd);
    finally
        Windows.FindClose(fh);
    end;

    // PLugins geladen
    // Filter "Alle Dateien" hinzufügen
    tmpfilter := '*.mp3';
    for i := 1 to ValidExtensions.Count -1 do
        tmpfilter := tmpfilter + ';*' + ValidExtensions[i];

    Filter := 'All supported files|' + tmpfilter
                                       + Filter
                                       + '|CD-Audio|*.cda'
                                       ;
end;

procedure TNempPlayer.ReInitBassEngine;
var dummy: UnicodeString;
  i: Integer;
  BassInfo: BASS_DEVICEINFO;
begin
  // Bass_freigeben
  BASS_PluginFree(0); // first: clear all Plugins, otherwise Plugin_Load in InitBassEngine will fail
  i := 0;
  while (Bass_GetDeviceInfo(i, BassInfo)) do
  begin
    BASS_SetDevice(i);
    BASS_Free;
    inc(i);
  end;

  ValidExtensions.Clear;
  ValidExtensions.Add('.mp3'); ValidExtensions.Add('.ogg');
  ValidExtensions.Add('.wav'); ValidExtensions.Add('.mp1');
  ValidExtensions.Add('.mp2'); ValidExtensions.Add('.aiff');
  ValidExtensions.Add('.mo3'); ValidExtensions.Add('.it');
  ValidExtensions.Add('.xm'); ValidExtensions.Add('.s3m');
  ValidExtensions.Add('.mtm'); ValidExtensions.Add('.mod');
  ValidExtensions.Add('.umx');
  ValidExtensions.Add('.cda');

  //neu Initialisieren
  InitBassEngine(fMainWindowHandle, fPathToDlls, dummy);
end;


{
    --------------------------------------------------------
    Setting some flags for creating streams
    --------------------------------------------------------
}
function TNempPlayer.GetFloatable: Boolean;
begin
  result := fFloatable = BASS_SAMPLE_FLOAT;
end;

procedure TNempPlayer.UpdateFlags;
begin
  Case fUseFloatingPointChannels of
      0: begin // Auto-Detect
          // check for floating-point capability
          fFloatable := BASS_StreamCreate(44100, 2, BASS_SAMPLE_FLOAT, nil, nil);
          if (fFloatable > 0) then
          begin
            BASS_StreamFree(fFloatable);  //woohoo!
            fFloatable := BASS_SAMPLE_FLOAT;
          end else
            //MessageDLG((Bass_Warning_FloatoingPoint), mtError, [MBOK], 0);
            fFloatable := 0;
      end;
      1: // Off
          fFloatable := 0;
      2: // On
          fFloatable := BASS_SAMPLE_FLOAT;
  end;


  if fUseHardwareMixing then
      fSoftwareFlag := 0
  else
      fSoftwareFlag := BASS_SAMPLE_SOFTWARE;
end;

{
    --------------------------------------------------------
    Load/Save settings into Inifile
    --------------------------------------------------------
}
procedure TNempPlayer.LoadFromIni(Ini: TMemIniFile);
var i: Integer;
begin
  MainDevice := ini.ReadInteger('Player','MainDevice',1);
  HeadsetDevice := ini.ReadInteger('Player','HeadsetDevice',2);
  fMainVolume := ini.ReadInteger('Player','MainVolume',100);
  fMainVolume := fMainVolume / 100;
  fHeadsetVolume := ini.ReadInteger('Player','HeadsetVolume',80);
  fHeadsetVolume := fHeadsetVolume / 100;

  fUseFloatingPointChannels := Ini.ReadInteger('Player', 'FloatingPointChannels', 1);// 0: Auto-Detect, 1: Aus, 2: An
  if fUseFloatingPointChannels > 2 then fUseFloatingPointChannels := 0;
  if fUseFloatingPointChannels < 0 then fUseFloatingPointChannels := 0;

  fUseHardwareMixing := Ini.ReadBool('Player', 'HardwareMixing', True);  // False: OR BASS_SAMPLE_SOFTWARE


  UseFading             := ini.ReadBool('Player','UseFading',True);
  FadingInterval        := ini.ReadInteger('Player','FadingInterval',2000);
  SeekFadingInterval    := ini.ReadInteger('Player','SeekFadingInterval',300);
  IgnoreFadingOnShortTracks := ini.ReadBool('Player', 'IgnoreOnShortTracks', True);
  IgnoreFadingOnPause   := ini.ReadBool('Player', 'IgnoreOnPause', True);
  IgnoreFadingOnStop    := ini.ReadBool('Player', 'IgnoreOnStop', True);

  fPlayingTitelMode     := ini.ReadInteger('Player','AnzeigeModus',0);
  UseVisualization      := ini.ReadBool('Player','UseVisual',True);
  VisualizationInterval := ini.ReadInteger('Player','Visualinterval',40);
  TimeMode              := Ini.ReadInteger('Player', 'ShowTime', 0);
  ScrollTaskbarTitel    := ini.ReadBool('Player','ScrollTaskbarTitel',True);
  ScrollAnzeigeTitel    := ini.ReadBool('Player','ScrollAnzeigeTitel',True);
  ScrollTaskbarDelay    := ini.ReadInteger('Player', 'ScrollTaskbarDelay', 10);
  if ScrollTaskbarDelay < 5 then ScrollTaskbarDelay := 5;
  ScrollAnzeigeDelay    := ini.ReadInteger('Player', 'ScrollAnzeigeDelay', 0);
  if ScrollAnzeigeDelay < 0 then ScrollAnzeigeDelay := 0;


  ReInitAfterSuspend    := ini.ReadBool('Player','ReInitAfterSuspend',False);
  PauseOnSuspend        := ini.ReadBool('Player','PauseOnSuspend',True);

  //ShowCoverOnPlay       := ini.ReadBool('Player','ShowCoverOnPlay',True);

  PlayBufferSize        := ini.ReadInteger('Player','PlayBufferSize',500);

  AvoidMickyMausEffect  := ini.ReadBool('Player', 'KeinMickyMausEffekt', False);
  UseDefaultEffects   := ini.ReadBool('Player', 'UseDefaultEffects', True);
  UseDefaultEqualizer := ini.ReadBool('Player', 'UseDefaultEqualizer', False);

  ReduceMainVolumeOnJingle      := ini.ReadBool('Player','ReduceMainVolumeOnJingle', True);
  ReduceMainVolumeOnJingleValue := ini.ReadInteger('Player','ReduceMainVolumeOnJingleValue',50);
  JingleVolume                  := ini.ReadInteger('Player','JingleVolume',100);

  DownloadDir    := (IncludeTrailingPathDelimiter(ini.ReadString('Player', 'WebradioDownloadDir', Savepath + 'Webradio\')));


  FilenameFormat := ini.ReadString('Player', 'WebRadioFilenameFormat', '<date>, <time> - <title>');
  UseStreamnameAsDirectory := ini.ReadBool('Player', 'UseStreamnameAsDirectory', False);
  AutoSplitByTitle := ini.ReadBool('Player', 'WebRadioAutoSplitFiles', True);
  AutoSplitByTime  := ini.ReadBool('Player', 'WebRadioAutoSplitByTime', False);
  AutoSplitBySize  := ini.ReadBool('Player', 'WebRadioAutoSplitBySize', False);

  AutoSplitMaxTime := Ini.ReadInteger('Player', 'WebRadioAutoSplitMaxTime', 30);
  if (AutoSplitMaxTime < 0) or (AutoSplitMaxTime > 1440) then AutoSplitMaxTime := 30;

  AutoSplitMaxSize := Ini.ReadInteger('Player', 'WebRadioAutoSplitMaxSize', 10);
  if (AutoSplitMaxSize < 0) or (AutoSplitMaxSize > 2000) then AutoSplitMaxSize := 10;

  if Not UseDefaultEffects then
  begin
      ReverbMix     := Ini.ReadFloat('Player','Hall', -96);
      if Reverbmix > 0 then Reverbmix := -96;
      EchoWetDryMix := Ini.ReadFloat('Player','EchoMix',0);
      if EchoWetDryMix > 50 then EchoWetDryMix := 0;
      EchoTime      := Ini.ReadFloat('Player','EchoTime',100);
      if EchoTime < 100 then EchoTime := 100;
      fSampleRateFaktor := Ini.ReadFloat('Player','Samplerate', 1);
      if abs(1-fSampleRateFaktor) > 0.4 then fSampleRateFaktor := 1;
  end else
  begin
      ReverbMix := -96;
      EchoTime := 100;
      EchoWetDryMix := 0;
      fSampleRateFaktor := 1;
  end;

  if Not UseDefaultEqualizer then
  begin
    for i := 0 to 9 do
    begin                                                                  // 111111
      fxGain[i] := ini.ReadInteger('Player','EQ' + IntToStr(i+1), 0) / EQ_NEW_FACTOR;
      // Vorsicht. In den Inis hatte ich früher immer Button.Top (sogar ohne - Shape.Top!!) gespeichert -- Korrektur erforderlich!
      if fxgain[i] > 15 then fxGain[i] := 0;
    end;
    EQSettingName := ini.ReadString('Player', 'EQ-Settings', 'Auswahl');
  end else
  begin
    for i := 0 to 9 do fxgain[i] := 0;
    EQSettingName := 'Auswahl';
  end;

  NempScrobbler.LoadFromIni(Ini);
  PostProcessor.LoadFromIni(Ini);
end;

procedure TNempPlayer.WriteToIni(Ini: TMemIniFile);
begin
  ini.WriteInteger('Player','HeadsetDevice',HeadsetDevice);
  ini.WriteInteger('Player','MainDevice',MainDevice);
  ini.WriteInteger('Player','MainVolume',Round(fMainVolume * 100));
  ini.WriteInteger('Player','HeadsetVolume',Round(fHeadsetVolume * 100));

  Ini.WriteInteger('Player', 'FloatingPointChannels', fUseFloatingPointChannels);
  Ini.WriteBool('Player', 'HardwareMixing', fUseHardwareMixing);

  ini.WriteBool('Player','UseFading',UseFading);
  ini.WriteInteger('Player','FadingInterval',FadingInterval);
  ini.WriteInteger('Player','SeekFadingInterval',SeekFadingInterval);
  ini.WriteBool('Player', 'IgnoreOnShortTracks', IgnoreFadingOnShortTracks);
  ini.WriteBool('Player', 'IgnoreOnPause', IgnoreFadingOnPause);
  ini.WriteBool('Player', 'IgnoreOnStop', IgnoreFadingOnStop);

  ini.WriteInteger('Player','AnzeigeModus', fPlayingTitelMode);
  ini.WriteBool('Player','UseVisual', UseVisualization);
  ini.WriteInteger('Player','Visualinterval', VisualizationInterval);
  Ini.WriteInteger('Player', 'ShowTime', TimeMode);
  ini.WriteBool('Player','ScrollTaskbarTitel', ScrollTaskbarTitel);
  ini.WriteBool('Player','ScrollAnzeigeTitel', ScrollAnzeigeTitel);
  ini.WriteInteger('Player', 'ScrollTaskbarDelay', ScrollTaskbarDelay);
  ini.WriteInteger('Player', 'ScrollAnzeigeDelay', ScrollAnzeigeDelay);


  ini.WriteBool('Player','ReInitAfterSuspend',ReInitAfterSuspend);
  ini.WriteBool('Player','PauseOnSuspend',PauseOnSuspend);

  //ini.WriteBool('Player','ShowCoverOnPlay', ShowCoverOnPlay);

  ini.WriteInteger('Player','PlayBufferSize',PlayBufferSize);

  ini.WriteBool('Player', 'KeinMickyMausEffekt', AvoidMickyMausEffect);
  Ini.WriteBool('Player', 'UseDefaultEffects', UseDefaultEffects);
  Ini.WriteBool('Player', 'UseDefaultEqualizer', UseDefaultEqualizer);

  Ini.WriteBool('Player','ReduceMainVolumeOnJingle', ReduceMainVolumeOnJingle);
  Ini.WriteInteger('Player','ReduceMainVolumeOnJingleValue', ReduceMainVolumeOnJingleValue);
  Ini.WriteInteger('Player','JingleVolume', JingleVolume);

  ini.WriteString('Player', 'WebradioDownloadDir', (DownloadDir));
  ini.WriteBool('Player', 'UseStreamnameAsDirectory', UseStreamnameAsDirectory);
  ini.WriteString('Player', 'WebRadioFilenameFormat', FilenameFormat);
  ini.WriteBool('Player', 'WebRadioAutoSplitFiles', AutoSplitByTitle);

  Ini.WriteBool('Player', 'WebRadioAutoSplitByTime', AutoSplitByTime);
  Ini.WriteBool('Player', 'WebRadioAutoSplitBySize', AutoSplitBySize);
  Ini.WriteInteger('Player', 'WebRadioAutoSplitMaxTime', AutoSplitMaxTime);
  Ini.WriteInteger('Player', 'WebRadioAutoSplitMaxSize', AutoSplitMaxSize);


  if Not UseDefaultEffects then
  begin
      ini.WriteFloat('Player','Hall',ReverbMix);
      ini.WriteFloat('Player','EchoMix',EchoWetDryMix);
      ini.WriteFloat('Player','EchoTime',EchoTime);
      Ini.WriteFloat('Player','Samplerate', fSampleRateFaktor);
  end;

  if NOT UseDefaultEqualizer then
  begin                                            // 111111
      ini.WriteInteger('Player','EQ1',Round(fxGain[0] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ2',Round(fxGain[1] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ3',Round(fxGain[2] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ4',Round(fxGain[3] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ5',Round(fxGain[4] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ6',Round(fxGain[5] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ7',Round(fxGain[6] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ8',Round(fxGain[7] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ9',Round(fxGain[8] * EQ_NEW_FACTOR));
      ini.WriteInteger('Player','EQ10',Round(fxGain[9] * EQ_NEW_FACTOR));
      ini.WriteString('Player', 'EQ-Settings', EQSettingName);
  end;

  NempScrobbler.SaveToIni(Ini);
  PostProcessor.WriteToIni(Ini);
end;


{
    --------------------------------------------------------
    NEMP_CreateStream
    Main-method for creating streams
    --------------------------------------------------------
}
function TNempPlayer.NEMP_CreateStream(aFile: TAudioFile; //UnicodeString;
                           aNoMickyMaus: boolean;
                           aReverse: boolean;
                           checkEasterEgg: boolean = False): DWord;
var extension, localPath: String;
  flags: DWORD;
  DecodeFlag: DWord;
  StreamDec, StreamRev: DWord;
begin
  localPath := aFile.Pfad; // copy pfad here, as the getter has to build the path from filename and Directory

  if checkEasterEgg and CheckForEasteregg(localPath) then
      RepairCorruptFile(localPath);

  // get extension (if its not a file, we need the "else-part", so dont check for AudioType here)
  extension := AnsiLowerCase(ExtractFileExt(localPath));
  if (   (extension = '.mp3')
      OR (extension = '.mp2')
      OR (extension = '.mp1')   )
  then
      flags := BASS_STREAM_PRESCAN OR BASS_UNICODE OR fSoftwareFlag or fFloatable
  else
      flags :=  BASS_UNICODE OR fSoftwareFlag or fFloatable;

  // zunächst nur Decode?
  if aReverse OR aNoMickyMaus then
      DecodeFlag := BASS_STREAM_DECODE
  else
      DecodeFlag := 0;

  case aFile.AudioType of
      at_File: begin
          result := BASS_StreamCreateFile(False, PChar(Pointer(localPath)), 0, 0, DecodeFlag OR flags);
          // Vorgang oben fehlgeschlagen? Dann mit Music probieren
          if result = 0 then
              result := BASS_MusicLoad(FALSE, PChar(Pointer(localPath)), 0, 0, DecodeFlag OR BASS_MUSIC_RAMP or {BASS_SAMPLE_FX OR} BASS_MUSIC_PRESCAN ,0);

          // Decodier-Stream nachbehandeln
          if aReverse AND (result <> 0) then
          begin
              StreamDec := result;
              // einen Reverse-Stream erzeugen
              if aNoMickyMaus then
              begin
                  StreamRev := BASS_FX_ReverseCreate(StreamDec, 1, BASS_FX_FREESOURCE or BASS_STREAM_DECODE);
                  if StreamRev <> 0 then
                      result := BASS_FX_TempoCreate(StreamRev, BASS_FX_FREESOURCE)
                  else result := 0;
              end
              else
                  result := BASS_FX_ReverseCreate(StreamDec, 1, BASS_FX_FREESOURCE);
          end else
              if aNoMickyMaus AND (result <> 0) then
                  // einen TempoStream erzeugen
                  result := BASS_FX_TempoCreate(result, BASS_FX_FREESOURCE);
      end;

      at_Stream: begin
          result := BASS_StreamCreateURL(PAnsiChar(Ansistring(localPath)), 0, BASS_STREAM_STATUS , @StatusProc, nil);
      end;

      at_CDDA: begin
          result := BASS_CD_StreamCreate(AudioDriveNumber(localPath), aFile.Track - 1, DecodeFlag or flags );
          // Decodier-Stream nachbehandeln
          if aReverse AND (result <> 0) then
          begin
              StreamDec := result;
              // einen Reverse-Stream erzeugen
              if aNoMickyMaus then
              begin
                  StreamRev := BASS_FX_ReverseCreate(StreamDec, 1, BASS_FX_FREESOURCE or BASS_STREAM_DECODE);
                  if StreamRev <> 0 then
                      result := BASS_FX_TempoCreate(StreamRev, BASS_FX_FREESOURCE)
                  else result := 0;
              end
              else
                  result := BASS_FX_ReverseCreate(StreamDec, 1, BASS_FX_FREESOURCE);
          end else
              if aNoMickyMaus AND (result <> 0) then
                  // einen TempoStream erzeugen
                  result := BASS_FX_TempoCreate(result, BASS_FX_FREESOURCE);
      end;
      else
          result := 0;
  end;
end;


{
    --------------------------------------------------------
    StopAndFree
    --------------------------------------------------------
}
procedure TNempPlayer.StopAndFree(StartPlayAfterStop: Boolean = False);
begin
    if assigned(MainAudioFile) and ((MainAudioFile.IsFile) or (MainAudioFile.isCDDA)) then
    begin
        PostProcessor.UserStoppedThePlayer := (LastUserWish = USER_WANT_STOP);
        PostProcessor.Process(Status = PLAYER_ISPLAYING);
    end;
    // EndSyncs löschen - Sonst ggf. doppeltes Next
    RemoveEndSyncs;
    StopRecording;
    // Wiedergabe stoppen und Handles freigeben
    if UseFading AND fReallyUseFading
        AND not (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream, Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
        And ((not IgnoreFadingOnStop) or StartPlayAfterStop)
    then
    begin
        fSlideIsStopSlide := True;
        BASS_ChannelFlags(MainStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL,-2,FadingInterval)
    end
    else begin
        BASS_ChannelStop(MainStream);
        BASS_StreamFree(MainStream);
        SendMessage(MainWindowHandle, WM_PlayerStop, 0, 0);
    end;
    BASS_ChannelStop(SlideStream);
    BASS_StreamFree(SlideStream);

    spectrum.DrawClear;
    Spectrum.DrawText('', False);
    Spectrum.DrawTime('  00:00');
    MainStream := 0;
    SlideStream := 0;
  
    UpdateDeskband(NEMP_API_STOPPED, 0);
    ActualizePlayPauseBtn(NEMP_API_STOPPED, 0);
end;

{
    --------------------------------------------------------
    Playn a Audiofile
    --------------------------------------------------------
}
procedure TNempPlayer.Play(aAudioFile: TPlaylistFile; Interval: Integer; StartPlay: Boolean; StartPos: Float = 0);
var
  extension: String;
  ChannelInfo: BASS_CHANNELINFO;
  basstime: Double;
  basslen: DWord;
  //JustCDChange, CDChangeSuccess: Boolean;
begin
  // Alte Wiedergabe stoppen
  // Es macht keinen Sinn, einen neuen Mainstream zu erzeugen,
  // wenn der alte noch läuft!!
  // Vorteil: Das stoppen muss nicht explizit von außen aufgerufen werden!
  //         Aber: Wenn innerhalb einer CD gewechselt werden soll, dann NICHT

  //JustCDChange := assigned(MainAudioFile) and assigned(aAudioFile)   // both files are set
  //                and (Mainstream <> 0)
  //                and (not MainStreamIsReverseStream)
  //                and MainAudioFile.isCDDA and aAudioFile.isCDDA     // both are CDDA
  //                and SameDrive(MainAudioFile.Pfad, aAudioFile.Pfad); // both on the same drive

  //JustCDChange := False;

  //if not JustCDChange then
      StopAndFree(StartPlay);

  MainAudioFile := aAudioFile;
  // First: Think pessimistic. The AudioFile is not present atm.
  MainAudioFileIsPresentAndPlaying := False;
  // We begin a new File:
  EndFileProcReached := False;

  if MainAudioFile <> NIL then
  begin
      extension := AnsiLowerCase(ExtractFileExt(MainAudioFile.Pfad));

      case MainAudioFile.AudioType of
          at_File: begin
              Spectrum.DrawText('Starting ' +  MainAudioFile.Dateiname, False);
          end;
          at_Stream: begin
              Spectrum.DrawText('Connecting to ' +  MainAudioFile.Pfad, False)
          end;
          at_CDDA: begin
              Spectrum.DrawText('Starting ' +  MainAudioFile.Pfad, False);
          end;
      end;

      if MainAudioFile.isCDDA then
      begin
          // check, whether the current cd is valid for the AudioFile-Object
          // this is VERY important for the cover-downloading:
          // if album-Artist-data does not match the cddb-id, a wrong cover will be downloaded
          // and displayed permanently
          if (CddbIDFromCDDA(MainAudioFile.Pfad) <> MainAudioFile.Comment ) then
              MainAudioFile.GetAudioData(MainAudioFile.Pfad, 0);
      end;

      //CDChangeSuccess := True;
      //if JustCDChange then
      //begin
      //    CDChangeSuccess := BASS_CD_StreamSetTrack(MainStream, MainAudioFile.Track - 1);
      //    showmessage('changed ' + inttostr(MainAudioFile.Track - 1));
      //end
      //else
          // Mainstream erzeugen
          Mainstream := NEMP_CreateStream(MainAudioFile, AvoidMickyMausEffect, False, True);

      // Fehlerbehandlung
      if (MainStream = 0) {or (not CDChangeSuccess)} then
      begin
          if BassErrorString(Bass_ErrorGetCode) <> '' then
              Spectrum.DrawText(BassErrorString(Bass_ErrorGetCode), False);
          // something is wrong
          MainAudioFileIsPresentAndPlaying := False;
      end;

      SetEndSyncs(mainstream);

      // Originale Samplerate des Streams bestimmen
      // braucht man beim verändern der Geschwindigkeit
      BASS_ChannelGetAttribute(Mainstream, BASS_ATTRIB_FREQ, OrignalSamplerate{!!});
      InitStreamEqualizer(MainStream);


      // URL oder Dateiname??
      // BEI URLS ist einiges etwas anders - z.B. kein Tempo
      case MainAudioFile.AudioType of
          at_File: begin
              fIsURLStream := False;
              aAudioFile.FileIsPresent := FileExists(MainAudioFile.Pfad);
              MainStreamIsTempoStream := AvoidMickyMausEffect;

              // Bestimmen, ob Faden oder nicht
              if UseFading AND fReallyUseFading
                           // (...Und Titel ist auch lang genug)
                           AND NOT (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
              then // zunächst stummschalten, und dann einfaden
              begin
                    // Attribute setzen
                    if MainStreamIsTempoStream then
                        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100)
                    else
                        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);

                    BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, 0);

                    if StartPos <> 0 then
                      Bass_ChannelSetPosition(Mainstream, BASS_ChannelSeconds2Bytes(MainStream, StartPos), BASS_POS_BYTE);

                    if StartPlay then
                    begin
                      BASS_ChannelPlay(MainStream , False);
                      BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume, Interval);
                    end;
              end else
              begin // also kein Fading
                    if MainStreamIsTempoStream then
                        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100)
                    else
                        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
                    BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);

                    if StartPos <> 0 then
                      Bass_ChannelSetPosition(Mainstream, BASS_ChannelSeconds2Bytes(MainStream, StartPos), BASS_POS_BYTE);

                    if StartPlay then
                      BASS_ChannelPlay(MainStream , False);
              end;
              MainStreamIsReverseStream := False;

              // Anzeige initialisieren
              StreamType := GetStreamType(Mainstream);

              // Bei Audio-CDs kann kein zweiter Stream erzeugt werden!
              //if extension <> '.cda' then
              //begin
                SlideStream := NEMP_CreateStream(MainAudioFile, AvoidMickyMausEffect, False);
                SetEndSyncs(SlideStream);
                InitStreamEqualizer(SlideStream);
                if MainStreamIsTempoStream then
                    BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100)
                else
                    BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
                BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_VOL, 0);
                fReallyUseFading := True;
              //end else
              //begin
              //  Slidestream := 0;
              //  fReallyUseFading := False;
              //end;

          end;

          at_Stream: begin
              fIsURLStream := True;
              MainStreamIsReverseStream := False;

              // Stratplay künstlich auf True setzen!
              // StartPlay := True;          // why ?????

              // Wenn Faden
              if UseFading AND fReallyUseFading then
              begin
                // Lautstärke zunächst auf 0
                BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, 0);
                if StartPlay then
                begin
                    BASS_ChannelPlay(MainStream , True);
                    BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume, FadingInterval);
                end;
              end
              else begin // also kein Fading, Lautstärke mormal
                BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);
                if StartPlay then
                    BASS_ChannelPlay(MainStream , True);
              end;
              fStatus := PLAYER_ISPLAYING;

              // Hier werden die Details ermittelt, Die Hauptform benachrichtigt
              // und MetaSyncs gesetzt, Playingtitel wird da auch gesetzt
              GetURLDetails;
          end;

          at_CDDA: begin
              Slidestream := 0;
              fReallyUseFading := False;
              MainStreamIsReverseStream := False;

              // StartPlay := True;    // why ?????

              // Wenn Faden
              if UseFading then // AND fReallyUseFading then
              begin
                // Lautstärke zunächst auf 0
                BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, 0);
                if StartPos <> 0 then
                    Bass_ChannelSetPosition(Mainstream, BASS_ChannelSeconds2Bytes(MainStream, StartPos), BASS_POS_BYTE);
                if StartPlay then
                begin
                    BASS_ChannelPlay(MainStream , False);
                    BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume, FadingInterval);
                end;
              end
              else begin // also kein Fading, Lautstärke mormal
                BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);
                if StartPos <> 0 then
                      Bass_ChannelSetPosition(Mainstream, BASS_ChannelSeconds2Bytes(MainStream, StartPos), BASS_POS_BYTE);
                if StartPlay then
                    BASS_ChannelPlay(MainStream , False);
              end;
              fStatus := PLAYER_ISPLAYING;
          end;
      end;

      // Stream ist jetzt fertig von der Bass erzeugt.
      // Jetzt das Audiofile ggf. ändern
      // zunächst mit eigenen Methoden rangehen
      if MainAudioFile.IsFile then
          SynchronizeAudioFile(MainAudioFile, MainAudioFile.Pfad, False);
      // dann ggf. von der bass korrigieren lassen
      If Mainstream <> 0 then
      begin
          BASS_ChannelGetInfo(Mainstream, ChannelINfo);
          MainAudioFile.SetSampleRate(ChannelInfo.freq);
          if not MainAudioFile.IsStream then
          begin
              basstime := BASS_ChannelBytes2Seconds(Mainstream,BASS_ChannelGetLength(Mainstream, BASS_POS_BYTE));
              basslen := BASS_StreamGetFilePosition(Mainstream,BASS_FILEPOS_END);
              MainAudioFile.Bitrate := Round((basslen/(125*basstime)+0.5));
          end
      end;

      SetCueSyncs;
      // wurde direkt nach der Erzeugung gemacht SetEndSyncs;
      SetSlideEndSyncs;
      ResetPlayerVCL;
      if StartPlay and (Mainstream <> 0) then
      begin
          fstatus := PLAYER_ISPLAYING;
          SendMessage(MainWindowHandle, WM_PlayerPlay, 0, 0);
          UpdateDeskband(NEMP_API_PLAYING, 0);
          ActualizePlayPauseBtn(NEMP_API_PLAYING, 0);

          if (MainAudioFile.IsFile) or (MainAudioFile.isCDDA)  then
          begin
              PostProcessor.ChangeCurrentPlayingFile(MainAudioFile);
              PostProcessor.PlaybackStarted;
              MainAudioFileIsPresentAndPlaying := True;
          end;
      end else
      begin
          MainAudioFileIsPresentAndPlaying := False;
          // das sorgt sonst auch für "Pause", wenn eine Datei mal nicht gefunden wird!! ----
          if MainAudioFile.isStream then
          begin
              fStatus := PLAYER_ISPAUSED; // Das ist wichtig fürs aufwecken nach einem Suspend und einem Reinit der Engine
              UpdateDeskband(NEMP_API_PAUSED, 0);
              ActualizePlayPauseBtn(NEMP_API_PAUSED, 0);
          end;
      end;

  end;
end;
{
    --------------------------------------------------------
    Pause the mainstream
    --------------------------------------------------------
}
procedure TNempPlayer.pause;
begin
  if fIsURLStream then
      Stop
  else
  begin
      PostProcessor.PlaybackPaused;
      RemoveEndSyncs;
      if UseFading AND fReallyUseFading
          AND NOT (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
          AND NOT IgnoreFadingOnPause
      then
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL,-2,FadingInterval)
      else
      begin
        BASS_ChannelPause(MainStream);
      end;
      fStatus := PLAYER_ISPAUSED;
      UpdateDeskband(NEMP_API_PAUSED, 0);
      ActualizePlayPauseBtn(NEMP_API_PAUSED, 0);
  end;

end;
{
    --------------------------------------------------------
    Stop
    --------------------------------------------------------
}
procedure TNempPlayer.Stop(StartPlayAfterStop: Boolean = False);
begin
  StopAndFree(StartPlayAfterStop);
  fStatus := PLAYER_ISSTOPPED_MANUALLY;
end;
{
    --------------------------------------------------------
    Resume a paused stream
    --------------------------------------------------------
}
procedure TNempPlayer.resume;
begin
  if mainstream = 0 then exit;
  // Ende-Syncs wieder setzen
  SetEndSyncs(MainStream);
  SetEndSyncs(SlideStream);
  if UseFading AND fReallyUseFading
      AND NOT (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
      And NOT IgnoreFadingOnPause
  then
  begin
    // Wegen "Piep/Klick" bei Resume...?   Mal auf PC testen....
    if BASS_ChannelIsActive(mainstream) <> BASS_ACTIVE_PLAYING then
      BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL,0);

    BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume, FadingInterval);
    Delay(50); // Das verhindert Auf einer meiner Soundkarten einen Knackser. Warum? Keine Ahnung!!!
    BASS_ChannelPlay(MainStream, False);
  end
  else
  begin
    BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL,fMainVolume);
    BASS_ChannelPlay(MainStream, False);
  end;

  PostProcessor.PlaybackResumed;
  // MainAudioFile is present (probably, eventually already deletet from Playlist?)
  // and playing. => Set Flag to allow Deleting from Playlist with "AutoDelete"
  MainAudioFileIsPresentAndPlaying := True;
  fStatus := PLAYER_ISPLAYING;
  UpdateDeskband(NEMP_API_PLAYING, 0);
  ActualizePlayPauseBtn(NEMP_API_PLAYING, 0);
end;

{
    --------------------------------------------------------
    Fadeout, CancelFadeout
    --------------------------------------------------------
}
procedure TNempPlayer.FadeOut(aTime: Integer);
begin
  if (Dauer - Time) < aTime then
    aTime := Round(Dauer - Time);

  // Titelwechsel unterbinden
  RemoveEndSyncs;
  BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, 0, aTime*1000);
end;
procedure TNempPlayer.CancelFadeOut;
begin
    if MainStream <> 0 then
    begin
      SetEndSyncs(MainStream);
      SetEndSyncs(SlideStream);
      BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume, FadingInterval);
    end;
end;

{
    --------------------------------------------------------
    Reverse Playback of current stream
    --------------------------------------------------------
}
procedure TNempPlayer.ReversePlayback(FromBeginning: Boolean);
var
  tmpMain: DWord;
  OldPosition: QWord;
begin
  if fIsURLStream then exit;

  if Not assigned(MainAudiofile) then
  begin
      MessageDlg( Player_NoReversePossible, mtInformation, [mbOK], 0);
  end else
  begin
      if MainStreamIsReverseStream then
      begin
        // wieder vorwärtsabspielen
        OldPosition := BASS_ChannelGetPosition(MainStream, BASS_POS_BYTE);
        fReallyUseFading := False;
        StopAndFree;

        Play(MainAudiofile, 0, True);
        if Not FromBeginning then
          BASS_ChannelSetPosition(Mainstream, OldPosition, BASS_POS_BYTE);

        fReallyUseFading := True;
        MainStreamIsReverseStream := False;

      end else
      begin
        // Rückwärts abspielen
          fReallyUseFading := False;
          OldPosition := BASS_ChannelGetPosition(MainStream, BASS_POS_BYTE);
          StopAndFree;

          tmpMain := NEMP_CreateStream(MainAudiofile,
                               //False, // kein Tempostream
                               AvoidMickyMausEffect,
                               True  // ReverseStream
                               );
          MainStreamIsTempoStream := AvoidMickyMausEffect;


          MainStream := tmpMain;

          if Not FromBeginning then
            BASS_ChannelSetPosition(Mainstream, OldPosition, BASS_POS_BYTE);

          InitStreamEqualizer(MainStream);
          BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);

          if MainStreamIsTempoStream then
              BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100)
          else
              BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);

          SetNoEndSyncs(MainStream);
          BASS_ChannelPlay(MainStream , False);
          MainStreamIsReverseStream := True;
          ActualizePlayPauseBtn(NEMP_API_PLAYING, 0);
      end;
      ResetPlayerVCL;
  end;
end;

{
    --------------------------------------------------------
    playback of Jingles, Headset
    --------------------------------------------------------
}
procedure TNempPlayer.PlayJingle(aAudioFile: TAudioFile); // kein PlaylistFile, weil auch aus der Medienliste ein Jingle gespielt werden kann
var tmp: single;
begin
  if JingleStream = 0 then
  begin
    if ReduceMainVolumeOnJingle then
      BASS_ChannelSlideAttribute(MainStream,BASS_ATTRIB_VOL,
                 fMainVolume * ReduceMainVolumeOnJingleValue/100, SeekFadingInterval);

    JingleStream := 1; // <> 0
    if assigned(aAudioFile) then
    begin
        Jinglestream := NEMP_CreateStream(aAudioFile,
                           False, // kein Tempostream
                           False,  // kein ReverseStream
                           true); // Check for Easteregg

        BASS_ChannelFlags(Jinglestream, BASS_STREAM_AUTOFREE OR BASS_SAMPLE_LOOP, BASS_STREAM_AUTOFREE OR BASS_SAMPLE_LOOP);
        // Attribute setzen
        tmp := fMainVolume * JingleVolume/100;
        if tmp > 1 then tmp := 1;
        BASS_ChannelSetAttribute(JingleStream, BASS_ATTRIB_VOL, tmp);
        BASS_ChannelPlay(JingleStream, true);
    end;
  end;
end;

procedure TNempPlayer.StopJingle;
begin
  BASS_ChannelSlideAttribute(MainStream,BASS_ATTRIB_VOL,fMainVolume,SeekFadingInterval);
  BASS_ChannelStop(Jinglestream);
  JingleStream := 0;
end;

procedure TNempPlayer.PlayInHeadset(aAudioFile: TAudioFile); // kein PlaylistFile, weil auch aus der Medienliste ein Jingle gespielt werden kann
begin
  if not Bass_SetDevice(HeadsetDevice) then
      exit;

  if not assigned(HeadSetAudioFile) then
  begin
      if assigned(aAudioFile) then
          HeadSetAudioFile := TAudioFile.Create
      else
          exit;
  end;

  // aAudioFile = NIL: PlayAgain
  if assigned(aAudioFile) then
      HeadSetAudioFile.Assign(aAudioFile);


  if assigned(HeadSetAudioFile) then
  begin
      // before we start, we should check some cdda-stuff, as only one stream per cd can be created
      if assigned(MainAudioFile) and MainAudioFile.isCDDA then
      begin
          if SameDrive(MainAudioFile.Pfad, HeadSetAudioFile.Pfad) then
          begin
              MessageDlg(CDDA_NoHeadsetPossible, mtInformation, [mbOK], 0);
              exit;
          end;
      end;


      fHeadsetIsURLStream := HeadSetAudioFile.isStream;
      Bass_ChannelStop(HeadsetStream);
      HeadsetStream := NEMP_CreateStream(HeadSetAudioFile, False, False, True);
      BASS_ChannelFlags(HeadsetStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);

      BASS_ChannelSetAttribute(HeadsetStream, BASS_ATTRIB_VOL, fHeadSetVolume);
      Bass_ChannelPlay(HeadsetStream, True);

      fHeadsetFileEndSyncHandle := Bass_ChannelSetSync(HeadsetStream,
                    BASS_SYNC_END, 0,
                    @EndHeadSetFileProc, Self);


      Bass_SetDevice(MainDevice);
      ActualizePlayPauseBtn(NEMP_API_PLAYING, 1);
  end;
end;

procedure TNempPlayer.PauseHeadset;
begin
  if not Bass_SetDevice(HeadsetDevice) then
    exit;
  Bass_ChannelPause(HeadsetStream);
  Bass_SetDevice(MainDevice);

  ActualizePlayPauseBtn(NEMP_API_PAUSED, 1);
end;

procedure TNempPlayer.ResumeHeadset;
begin
  if not Bass_SetDevice(HeadsetDevice) then
    exit;
  BASS_ChannelPlay(HeadsetStream, False);
  Bass_SetDevice(MainDevice);
  ActualizePlayPauseBtn(NEMP_API_PLAYING, 1);
end;

procedure TNempPlayer.StopHeadset;
begin
  if not Bass_SetDevice(HeadsetDevice) then
    exit;
  Bass_ChannelStop(HeadsetStream);
  Bass_SetDevice(MainDevice);
  ActualizePlayPauseBtn(NEMP_API_STOPPED, 1);
end;


{
    --------------------------------------------------------
    Volume. Setter, Getter, Mute, UnMute
    --------------------------------------------------------
}
function TNempPlayer.GetVolume: Single;
begin
  result := fMainVolume * 100;
end;
procedure TNempPlayer.SetVolume(Value: Single);
begin
  Value := Value / 100;
  if Value < 0 then Value := 0;
  if Value > 1 then Value := 1;
  fMainVolume := Value;
  BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);
end;

function TNempPlayer.GetHeadsetVolume: Single;
begin
  result := fHeadsetVolume * 100;
end;
procedure TNempPlayer.SetHeadsetVolume(Value: Single);
begin
  Value := Value / 100;
  if Value < 0 then Value := 0;
  if Value > 1 then Value := 1;
  fHeadsetVolume := Value;
  BASS_ChannelSetAttribute(HeadsetStream, BASS_ATTRIB_VOL, fHeadsetVolume);
end;

procedure TNempPlayer.Mute;
begin
  BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, 0);
  isMute := True;
end;
procedure TNempPlayer.UnMute;
begin
  BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_VOL, fMainVolume);
  isMute := False;
end;



{
    --------------------------------------------------------
    Position. Setter/Getter for time/progress in Mainstream/Headsetstream
    --------------------------------------------------------
}
procedure TNempPlayer.SetPosition(Value: Longword);
var tmp: DWord;
    InvalidSlideJump, localFading: Boolean;
begin
  // Value is beyond the "NearEndSyncHandle"
  InvalidSlideJump := (Bass_ChannelSeconds2Bytes(mainstream, Dauer - (FadingInterval / 1000)) <= Value);

  // Current track should and can be faded
  localFading := UseFading AND fReallyUseFading
          AND NOT (IgnoreFadingOnShortTracks AND
          (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200));

  // fading, but beyond the nearendsync => Play next file
  if localFading and InvalidSlideJump then
  begin
      // The same as in EndFileProc
      EndFileProcReached := True;
      SendMessage(MainWindowHandle, WM_NextFile, 0, 0);
  end
  else
  begin
      if localfading then
      begin
        // Position im Slidestream umsetzen
        BASS_ChannelSetPosition(SlideStream, Value, BASS_POS_BYTE);
        // SlideStream stummschalten und ggf. starten
        BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_VOL, 0);

        if Status = PLAYER_ISPLAYING then
          BASS_ChannelPlay(SlideStream , False);
        // Mainstream ausfaden und stoppen
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL, -2, SeekFadingInterval);
        BASS_ChannelSlideAttribute(SlideStream, BASS_ATTRIB_VOL, fMainVolume, SeekFadingInterval);
        // Streams vertauschen
        tmp := Mainstream;
        Mainstream := SlideStream;
        SlideStream := tmp;
      end else
      begin
        // einfach nur umsetzen
        BASS_ChannelSetPosition(MainStream, Value, BASS_POS_BYTE);
      end;
      // CueSyncs neu setzen!!
      SetCueSyncs;
  end;
end;

function TNempPlayer.GetTime: Double;
begin
  if (mainstream <> 0) and not fIsURLStream then
    result := BASS_ChannelBytes2Seconds(mainstream, BASS_ChannelGetPosition(mainstream, BASS_POS_BYTE))
  else
    result := 0;
end;
// Zur angegebenen Zeit im Stream springen
procedure TNempPlayer.SetTime(Value: Double);
begin
  if fIsURLStream then exit;
  if Value < 0 then Value := 0;
  if Value > BASS_ChannelBytes2seconds(mainstream, BASS_ChannelGetLength(mainstream, BASS_POS_BYTE)) then
    Value := BASS_ChannelBytes2seconds(mainstream, BASS_ChannelGetLength(mainstream, BASS_POS_BYTE));
  SetPosition(BASS_ChannelSeconds2Bytes(mainstream, Value));
end;

function TNempPlayer.GetProgress: Double;
begin
  if (mainstream <> 0) and not fIsURLStream then
    result := BASS_ChannelGetPosition(mainstream, BASS_POS_BYTE) / BASS_ChannelGetLength(mainstream, BASS_POS_BYTE)
  else
    result := 0;
end;
procedure TNempPlayer.SetProgress(Value: Double);
begin
  if fIsURLStream then exit;
  if Value < 0 then Value := 0;
  // Note: Do not check for >1 and set it to 1.
  //       Then sliding to the End of a File will not work properly !
  if Value > 0.999 then Value := 0.999;
  SetPosition(Round(BASS_ChannelGetLength(mainstream, BASS_POS_BYTE) * Value));
end;

function TNempPlayer.GetLength: Double;
begin
  if (mainstream <> 0) and not fIsURLStream then
    result := BASS_ChannelBytes2Seconds(mainstream, BASS_ChannelGetLength(mainstream, BASS_POS_BYTE))
  else
    result := 0;
end;
function TNempPlayer.GetHeadsetTime: Double;
begin
  if (HeadsetStream <> 0) and not fHeadsetIsURLStream then
    result := BASS_ChannelBytes2Seconds(HeadsetStream, BASS_ChannelGetPosition(HeadsetStream, BASS_POS_BYTE))
  else
    result := 0;
  end;
procedure TNempPlayer.SetHeadsetTime(Value: Double);
begin
  if fHeadsetIsURLStream then exit;
  if Value < 0 then Value := 0;
  if Value > BASS_ChannelBytes2seconds(HeadsetStream, BASS_ChannelGetLength(HeadsetStream, BASS_POS_BYTE)) then
    Value := BASS_ChannelBytes2seconds(HeadsetStream, BASS_ChannelGetLength(HeadsetStream, BASS_POS_BYTE));
  BASS_ChannelSetPosition(HeadsetStream, BASS_ChannelSeconds2Bytes(HeadsetStream, Value), BASS_POS_BYTE);
end;
function TNempPlayer.GetHeadsetProgress: Double;
begin
  if BASS_ChannelIsActive(HeadsetStream) = BASS_ACTIVE_STOPPED then
      result := 0
  else
  begin
      if (HeadsetStream <> 0) and not fHeadsetIsURLStream then
        result := BASS_ChannelGetPosition(HeadsetStream, BASS_POS_BYTE) / BASS_ChannelGetLength(HeadsetStream, BASS_POS_BYTE)
      else
        result := 0;
  end;
end;
procedure TNempPlayer.SetHeadsetProgress(Value: Double);
begin
  if fHeadsetIsURLStream then exit;
  if Value < 0 then Value := 0;
  if Value > 0.999 then Value := 0.999;
  BASS_ChannelSetPosition(HeadsetStream, Round(BASS_ChannelGetLength(HeadsetStream, BASS_POS_BYTE) * Value), BASS_POS_BYTE);
end;
function TNempPlayer.GetHeadsetLength: Double;
begin
  if (HeadsetStream <> 0) and not fHeadsetIsURLStream then
    result := BASS_ChannelBytes2Seconds(HeadsetStream, BASS_ChannelGetLength(HeadsetStream, BASS_POS_BYTE))
  else
    result := 0;
end;

function TNempPlayer.GetBassStatus: DWord;
begin
  result := BASS_ChannelIsActive(MainStream);
end;

function TNempPlayer.GetBassHeadSetStatus: DWord;
begin
  result := BASS_ChannelIsActive(HeadSetStream);
end;

{
    --------------------------------------------------------
    Equalizer & Effects
    --------------------------------------------------------
}
function TNempPlayer.EqualizerIsNeeded: boolean;
var i: integer;
begin
  result := false;
  for i := 0 to 9 do
  begin
    if abs(fxGain[i]) > 0.01 then
    begin
      result := True;
      break;
    end;
  end;
end;

procedure TNempPlayer.InitStreamEqualizer(aStream: Dword);
var i: integer;
   locCompress, locEq: DWord ;
begin
  if EqualizerIsNeeded then
  begin
      locCompress := BASS_ChannelSetFX(astream, BASS_FX_BFX_COMPRESSOR, 0);

      BASS_FXGetParameters(locCompress, @BassCompress);
      BassCompress.fThreshold := 1.0;
      BASS_FXSetParameters(locCompress, @BassCompress);

      if aStream = MainStream then
      begin
        EqMainHnd := BASS_ChannelSetFX(aStream, BASS_FX_BFX_PEAKEQ, 5);
        locEq := EqMainHnd;
      end
      else
      begin
        EqSlideHnd := BASS_ChannelSetFX(aStream, BASS_FX_BFX_PEAKEQ, 5);
        locEq := EqSlideHnd;
      end;

      BassEQNew.lBand := 0;
      BassEQNew.fBandwidth := EQ_BANDWIDTH;
      BassEQNew.FQ := 0;
      BassEQNew.lChannel := BASS_BFX_CHANALL;

      for i := 0 to 9 do
      begin
        BassEQNew.lBand := i;
        BassEQNew.fCenter := Equalizer_Center[i];
        BassEQNew.fGain := fxGain[i];
        BASS_FXSetParameters(locEq, @BassEQNew);
      end;
      EQ_IsActive := True;
  end else
    EQ_IsActive := False;

  // Reverb setzen
  if ReverbMix > -95 then
  begin
      ReverbMainHnd := BASS_ChannelSetFX(aStream, BASS_FX_DX8_REVERB,1);
      BassFXReverb.fReverbTime := 1200;
      BassFXReverb.fHighFreqRTRatio := 0.1;
      BassFXReverb.fReverbMix := ReverbMix;
      BASS_FXSetParameters(ReverbMainHnd, @BassFXReverb);
      Reverb_IsActive := True;
  end else
      Reverb_IsActive := False;

  // Echo
  if EchoWetDryMix > 0.01 then
  begin
      EchoMainHnd := BASS_ChannelSetFX(aStream, BASS_FX_DX8_ECHO,1);
      BassFXEcho.fFeedback := 50;
      BassFXEcho.fWetDryMix := EchoWetDryMix;
      BassFXEcho.fLeftDelay := EchoTime;
      BassFXEcho.fRightDelay := EchoTime;
      BASS_FXSetParameters(EchoMainHnd, @BassFXEcho);
      Echo_IsActive := True;
  end else
      Echo_IsActive := False;
end;

procedure TNempPlayer.SetEqualizer(band: Integer; gain: Single);
var i: integer;
    locCompress1, locCompress2: DWord;
begin
    if gain > EQ_NEW_MAX then gain := EQ_NEW_MAX;
    if gain < -EQ_NEW_MAX then gain := -EQ_NEW_MAX;

    if band in [0..9] then // gültiges Band
    begin
      // Variable, die die Werte speichert, neu setzen
      fxGain[band] := gain;

      if Not EQ_IsActive then
      // Equalizer einschalten
      begin
          locCompress1 := BASS_ChannelSetFX(MainStream, BASS_FX_BFX_COMPRESSOR, -1);
          locCompress2 := BASS_ChannelSetFX(SlideStream, BASS_FX_BFX_COMPRESSOR, -1);

          BASS_FXGetParameters(locCompress1, @BassCompress);
          BassCompress.fThreshold := 1.0;
          BASS_FXSetParameters(locCompress1, @BassCompress);
          BASS_FXGetParameters(locCompress2, @BassCompress);
          BassCompress.fThreshold := 1.0;
          BASS_FXSetParameters(locCompress2, @BassCompress);

          EqMainHnd := BASS_ChannelSetFX(MainStream, BASS_FX_BFX_PEAKEQ, 0);
          EqSlideHnd := BASS_ChannelSetFX(SlideStream, BASS_FX_BFX_PEAKEQ, 0);

          BassEQNew.lBand := 0;
          BassEQNew.lChannel := BASS_BFX_CHANALL;

          BassEQNew.fBandwidth := EQ_BANDWIDTH;
          BassEQNew.FQ := 0;

          for i := 0 to 9 do
          begin
              BassEQNew.lBand := i;
              BassEQNew.fGain := fxGain[i];
              BassEQNew.fCenter := Equalizer_Center[i];
              BASS_FXSetParameters(EqMainHnd, @BassEQNew);
              BASS_FXSetParameters(EqSlideHnd, @BassEQNew);
          end;
          EQ_IsActive := True;
      end;

      // falls Mainstream läuft, Effekt dort aktualisieren
      if mainstream <> 0 then
      begin
          BassEQNew.lBand := band;
          BASS_FXGetParameters(EqMainHnd, @BassEQNew);
          BassEQNew.fGain := fxGain[band];
          BASS_FXSetParameters(EqMainHnd, @BassEQNew);
      end;
      // falls Slidestream läuft, Effekt dort aktualisieren
      if SlideStream <> 0 then
      begin
          BassEQNew.lBand := band;
          BASS_FXGetParameters(EqSlideHnd, @BassEQNew);
          BassEQNew.fGain := fxGain[band];
          BASS_FXSetParameters(EqSlideHnd, @BassEQNew);
      end;
    end;
    EQSettingName := (EQSetting_Custom);
end;


Procedure TNempPlayer.SetReverbMix(Value: single);
begin
    if Value < -96 then Value := -96;
    if Value > 0 then Value := 0;
    fReverbMix := Value;

    // bei Bedarf Hall-Effekt einschalten
    if Not Reverb_IsActive then
    begin
        ReverbMainHnd := BASS_ChannelSetFX(MainStream, BASS_FX_DX8_REVERB, 1);
        ReverbSlideHnd := BASS_ChannelSetFX(SlideStream, BASS_FX_DX8_REVERB, 1);
        BassFXReverb.fReverbTime := 1200;
        BassFXReverb.fHighFreqRTRatio := 0.1;
        Reverb_IsActive := True;
    end;

    BASS_FXGetParameters(ReverbMainHnd, @BassFXReverb);
    BassFXReverb.fReverbMix := fReverbMix;
    BASS_FXSetParameters(ReverbMainHnd, @BassFXReverb);

    BASS_FXGetParameters(ReverbSlideHnd, @BassFXReverb);
    BassFXReverb.fReverbMix := fReverbMix;
    BASS_FXSetParameters(ReverbSlideHnd, @BassFXReverb);
end;

Procedure TNempPlayer.SetEchoMix(Value: Single);
begin
    SetEcho(Value, -1);
end;
Procedure TNempPlayer.SetEchoTime(Value: Single);
begin
    SetEcho(-1, Value);
end;

Procedure TNempPlayer.SetEcho(mix, time: Single);
begin
      if mix > 50 then mix := 50;                         // kleiner ist egal
      if (time < 100) and (time > - 1) then time := 100;
      if (time > 2000) then time := 2000;

      if mix > -1 then fEchoWetDryMix := mix;
      if time > -1 then fEchoTime := time;

      if Not Echo_IsActive then
      begin
          EchoMainHnd := BASS_ChannelSetFX(MainStream, BASS_FX_DX8_ECHO,1);
          EchoSlideHnd := BASS_ChannelSetFX(SlideStream, BASS_FX_DX8_ECHO,1);
          BassFXEcho.fFeedback := 50;
          BassFXEcho.fWetDryMix := fEchoWetDryMix;
          Echo_IsActive := True;
      end;

      BASS_FXGetParameters(EchoMainHnd, @BassFXEcho);
      BassFXEcho.fWetDryMix := fEchoWetDryMix;
      BassFXEcho.fLeftDelay := fEchoTime;
      BassFXEcho.fRightDelay := fEchoTime;
      BASS_FXSetParameters(EchoMainHnd, @BassFXEcho);

      BASS_FXGetParameters(EchoSlideHnd, @BassFXEcho);
      BassFXEcho.fWetDryMix := fEchoWetDryMix;
      BassFXEcho.fLeftDelay := fEchoTime;
      BassFXEcho.fRightDelay := fEchoTime;
      BASS_FXSetParameters(EchoSlideHnd, @BassFXEcho);
end;

Procedure TNempPlayer.SetSamplerateFactor(Value: Single);
begin
      if fIsURLStream then exit;
      if Value > 3 then Value := 3;
      if Value < 0.33 then Value := 0.33;
      fSamplerateFaktor := Value;

      if MainStreamIsTempoStream then
      begin
        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100);
        BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100);
      end else
      begin
        BASS_ChannelSetAttribute(MainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
        BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
      end;
end;

 {
    --------------------------------------------------------
    Set Syncs used by bass.dll to send some messages
    Cuesheets, End of track, almost end of track
    --------------------------------------------------------
}
procedure TNempPlayer.SetCueSyncs;
var NewCueIdx: Integer;
begin
  if assigned(MainAudioFile) AND assigned(MainAudioFile.CueList) AND (Mainstream <>0) then
  begin
      // Index des neuen Cues bestimmen
      NewCueIdx := GetActiveCue;//(MainAudioFile, Bass_ChannelBytes2Seconds(NempPlayer.mainstream,Bass_ChannelGetPosition(NempPlayer.mainstream)) + 0.5 );

      // altes Sync-Handle entfernen
      BASS_ChannelRemoveSync(mainstream, fCueSyncHandleM);
      BASS_ChannelRemoveSync(mainstream, fCueSyncHandleS);

      // das auch??
      BASS_ChannelRemoveSync(slidestream, fCueSyncHandleM);
      BASS_ChannelRemoveSync(slidestream, fCueSyncHandleS);

      // neues setzen
      if MainAudioFile.CueList.Count-1 > NewCueIdx then
      begin
            fCueSyncHandleM := Bass_ChannelSetSync(Mainstream,
                BASS_SYNC_POS,
                Bass_ChannelSeconds2Bytes(mainstream,(TPlaylistFile(MainAudioFile.CueList[NewCueIdx+1])).Index01),
                @NextCueProc,
                Self);
            fCueSyncHandleS := Bass_ChannelSetSync(Slidestream,
                BASS_SYNC_POS,
                Bass_ChannelSeconds2Bytes(mainstream,(TPlaylistFile(MainAudioFile.CueList[NewCueIdx+1])).Index01),
                @NextCueProc,
                Self);
      end;
  end
end;

procedure TNempPlayer.SetEndSyncs(Dest: DWord);
var syncpos: LongWord;
begin
    // ruhig die Dauer des mainstreams nehmen - sonst is eh was verkehrt ;-)
    syncpos := Bass_ChannelSeconds2Bytes(mainstream, Dauer - (FadingInterval / 1000));
    if dest = Mainstream then
    begin
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleM); //then
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleM);
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleS);
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleS);
          // Sync im Mainstream setzen
          if UseFading And fReallyUsefading
                AND (Dauer > FadingInterval DIV 200)
                AND (Not MainStreamIsReverseStream)
          then
              fFileNearEndSyncHandleM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_POS, syncpos,
                    @EndFileProc, Self);
          // Das hier immer setzen
          fFileEndSyncHandleM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_END, 0,
                    @EndFileProc, Self);
    end
    else begin
          BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleS);
          BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleS);
         // Sync im SlideStream setzen
         if UseFading And fReallyUsefading
              AND (Dauer > FadingInterval DIV 200)
              AND (Not MainStreamIsReverseStream)
         then
              fFileNearEndSyncHandleS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_POS, syncpos,
                    @EndFileProc, Self);
         fFileEndSyncHandleS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_END, 0,
                    @EndFileProc, Self);
    end;
    SendMessage(MainWindowHandle, WM_ChangeStopBtn, 0, 0);
    fStopStatus := PLAYER_STOP_NORMAL
end;

procedure TNempPlayer.SetNoEndSyncs(Dest: DWord);
begin
    if dest = Mainstream then
    begin
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleM); //then
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleM);
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleS);
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleS);
          // Sync im Mainstream setzen
          fFileEndSyncHandleM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_END, 0,
                    @StopPlaylistProc, Self);
    end
    else begin
          BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleS);
          BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleS);
         // Sync im SlideStream setzen
         fFileEndSyncHandleS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_END, 0,
                    @StopPlaylistProc, Self);
    end;
    SendMessage(MainWindowHandle, WM_ChangeStopBtn, 1, 0);
    fStopStatus := PLAYER_STOP_AFTERTITLE;
end;

procedure TNempPlayer.RemoveEndSyncs;
begin
    BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleM); //then
    BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleM);
    BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleS);
    BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleS);
    BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleM);
    BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleM);
    BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleS);
    BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleS);
    SendMessage(MainWindowHandle, WM_ChangeStopBtn, 0, 0);
    fStopStatus := PLAYER_STOP_NORMAL;
end;

procedure TNempPlayer.SetSlideEndSyncs;
begin
  if Mainstream <> 0 then
  begin
    fSlideIsStopSlide := False;
    fSlideEndSyncM := Bass_ChannelSetSync(MainStream,
                  BASS_SYNC_SLIDE, 0,
                  @EndSlideProc, Self);
    fSlideEndSyncS := Bass_ChannelSetSync(SlideStream,
                  BASS_SYNC_SLIDE, 0,
                  @EndSlideProc, Self);
  end;
end;

{
    --------------------------------------------------------
    Jump to another cue in the track
    --------------------------------------------------------
}
// Get the active cue
function TNempPlayer.GetActiveCue: Integer;
var i:Integer;
    aPos: Double;
begin
  result := 0;
  aPos := self.Time + 0.5;// evtl. + 0.5;?? hatte ich früher so1 Ja !! Sonst: Probleme mit der Aktualisierung bei Doppelklick auf einen Eintrag (also: wenn der dann abgelaufen ist)
  if assigned(MainAudioFile) AND assigned(MainAudioFile.CueList) AND ((MainAudioFile.CueList).Count > 0) then
  begin
      i := MainAudioFile.CueList.Count - 1;
      while (i > 0) AND (TPlaylistFile(MainAudioFile.CueList[i]).Index01 >= aPos) do
          dec(i);
      result := i;
  end;
end;
// jump to next/previous cue.
// result = false: There is no next cue, so playlist should jump to the next track
function TNempPlayer.JumpToNextCue: Boolean;
var NextCueIdx: Integer;
begin
  NextCueIdx := GetActiveCue + 1;
  if assigned(MainAudioFile) and assigned(MainAudioFile.CueList) and (MainAudioFile.CueList.Count-1 >= NextCueIdx) then
  begin
      SetTime(TPlaylistFile(MainAudioFile.CueList[NextCueIdx]).Index01);
      result := True;
  end
  else
      result := False;
end;
function TNempPlayer.JumpToPrevCue: Boolean;
var PrevCueIdx, CurrentCueIdx: Integer;
    startTime: Double;
begin

    if assigned(MainAudioFile) and assigned(MainAudioFile.CueList) then
    begin
        // we have a MainAudioFile and we have a cuelist
        // determine, where we are right now
        CurrentCueIdx := GetActiveCue;
        startTime := TPlaylistFile(MainAudioFile.CueList[CurrentCueIdx]).Index01;

        // If last Cue is "far away": jump to the beginning of the current cue
        if self.Time - startTime > 5 then
            PrevCueIdx := CurrentCueIdx
        else
            // else jump one cue back
            PrevCueIdx := CurrentCueIdx - 1;

        if PrevCueIdx >= 0 then
        begin
          SetTime(TPlaylistFile(MainAudioFile.CueList[PrevCueIdx]).Index01);
          result := True;
        end
        else
            result := False;  // this will result in playing the previous file
    end else
        // No cuelist - no jump
        result := False;

{  PrevCueIdx := GetActiveCue - 1;
  if assigned(MainAudioFile) and assigned(MainAudioFile.CueList) and (PrevCueIdx > 0) then
  begin
      SetTime(TPlaylistFile(MainAudioFile.CueList[PrevCueIdx]).Index01);
      result := True;
  end
  else
      result := False;
  }
end;

{
    --------------------------------------------------------
    Stuff for the GUI. Set Playingtitle, Mode, Taskbartitle, Play/Pause-Buttons, ...
    --------------------------------------------------------
}
procedure TNempPlayer.SetPlayingTitelMode(Value: Word);
begin
  fPlayingTitelMode := Value;
  RefreshPlayingTitel;
end;

function TNempPlayer.GenerateTitelString(aAudioFile: TAudioFile; aMode: Integer): UnicodeString;
begin
  if aAudioFile = Nil then
    result := ''
  else
  begin
    case aMode of
      MODE_ARTIST_TITEL: //if isURLtmp then
                         //    result := aAudioFile.Titel   // !! Achtung - bei Ogg-Streams kommen hier nähere Infos!!!
                         //else
                         begin
                            if UnKownInformation(aAudioFile.Artist) then
                                result := aAudioFile.NonEmptyTitle
                            else
                                result := aAudioFile.Artist + ' - ' + aAudioFile.NonEmptyTitle;// + aaudiofile.Pfad;
                         end;
      MODE_PATH        : result := aAudioFile.Pfad;
      MODE_INFO        : case aAudioFile.AudioType of
                            at_File : begin
                                result := Format('%s: %s, ',
                                      [(Infostring_Duration), SekToZeitString(aAudioFile.Duration)]);

                                if aAudioFile.Bitrate > 0 then
                                begin
                                  result := result + Format('%s: %dkbit/s', [(Infostring_Bitrate), aAudioFile.Bitrate]);
                                  if aAudioFile.vbr then
                                    result := result + ' (vbr), '
                                  else
                                    result := result + ', ';
                                end;
                                result := result + Format('%s: %s, %s, ',
                                          [(Infostring_Samplerate),
                                          aAudioFile.Samplerate,
                                          aAudioFile.Channelmode]);
                                result := result + ' (' + self.StreamType + ')';
                            end;

                            at_Stream: begin
                                result := Format('%s, %s: %dkbit/s (%s)'
                                  , [(Infostring_Webstream), (Infostring_Bitrate), aAudioFile.Bitrate, self.StreamType]);
                            end;

                            at_CDDA: begin
                                result := Format('%s: %s, CD-Audio',
                                      [(Infostring_Duration), SekToZeitString(aAudioFile.Duration)]);
                            end;
                         end;

      MODE_LYRICS      : case aAudioFile.AudioType of
                            at_File,
                            at_CDDA: begin
                                if aAudioFile.LyricsExisting then
                                  result := (StringReplace(UTF8ToString(aAudioFile.Lyrics), #13#10, ' ', [rfReplaceAll]))
                                else
                                  result := (Infostring_NoLyrics);
                            end;

                            at_Stream: begin
                                // im Namen steht die Beschreibung des Sender drin, das dürfte
                                // dem am nächsten kommen
                                result := aAudioFile.Description;
                            end;
                         end;
      else
          result := '-';
    end;
  end;

  if result = '' then result := '...';
end;



procedure TNempPlayer.RefreshPlayingTitel;
begin
  Spectrum.TextPosX := 0;
  fPlayingTitel := GenerateTitelString(MainAudioFile, fPlayingTitelMode);
end;

function TNempPlayer.GenerateTaskbarTitel: UnicodeString;
begin
  if NOT assigned(MainAudioFile) then
      result := NEMP_NAME_TASK
  else
  begin
      result := MainAudioFile.PlaylistTitle;
      if length(Result) < 10 then
          result := NEMP_NAME_TASK_LONG + ' - ' + result + ' - '
      else
          result := NEMP_NAME_TASK + ' - ' + result + ' - '
  end;
end;

procedure TNempPlayer.GetURLDetails;
var
  icy: PAnsiChar;
  icyStr: String;
begin
  begin
    // Dies hier wird einmalig beim Starten des Streams aufgerufen!
    // get the broadcast name and bitrate
    icy := BASS_ChannelGetTags(MainStream, BASS_TAG_ICY);
    if icy = Nil then
      icy := BASS_ChannelGetTags(MainStream, BASS_TAG_HTTP);

    if (icy <> nil) then
      try
        while (icy^ <> #0) do
        begin
            icyStr := String(icy);
            if (Copy(icyStr, 1, 9) = 'icy-name:') then
            begin
                MainAudioFile.Description := trim(Copy(icyStr, 10, Length(icyStr) - 9));
            end
            else if (Copy(icyStr, 1, 7) = 'icy-br:') then
            begin
                MainAudioFile.Bitrate := StrTointDef(Copy(icyStr, 8, Length(icyStr) - 7),-1);
            end
            else
                if (Copy(icyStr,1,10) = 'icy-genre:') then
                begin
                    MainAudioFile.Genre := trim(Copy(icyStr, 11, Length(icyStr) - 10 ));
                end;
              icy := icy + Length(icy) + 1;
        end;
      except
        // Wenn was schief gelaufen ist: Dann gibts halt keine Tags...
      end;

     DoMeta(0, Mainstream, 0, self);
     BASS_ChannelSetSync(MainStream, BASS_SYNC_META, 0, @DoMeta, self);

     DoOggMeta(0, Mainstream, 0, self);
     BASS_ChannelSetSync(MainStream, BASS_SYNC_OGG_CHANGE, 0, @DoOggMeta, self);

    StreamType := GetStreamType(MainStream);
  end;
end;

procedure TNempPlayer.DrawInfo(IncludingTime: Boolean = True);
var FFTFata : TFFTData;
begin
  if UseVisualization then
  begin
      BASS_ChannelGetData(MainStream, @FFTFata, BASS_DATA_FFT1024);
      Spectrum.Draw (FFTFata);
  end;
  Spectrum.DrawText(PlayingTitel, ScrollAnzeigeTitel);

  if IncludingTime then
      Case TimeMode of
          0: Spectrum.DrawTime('  '+ SecToStr(Time));
          1: Spectrum.DrawTime(' -' + SecToStr(Dauer - Time ));
      end;
end;

procedure TNempPlayer.DrawTimeFromProgress(aProgress: Single);
var tmpTime: Integer;
begin
    tmpTime :=  Round(Dauer * aProgress);
    Case TimeMode of
      0: Spectrum.DrawTime('  '+ SecToStr(tmpTime));
      1: Spectrum.DrawTime(' -' + SecToStr(Dauer - tmpTime ));
    end;
end;


function TNempPlayer.RefreshCoverBitmap: Boolean;
begin
    result := True;
    CoverBitmap.Width := 180;
    CoverBitmap.Height := 180;

    if assigned(MainAudioFile) then
    begin
        result := GetCover(MainAudioFile, CoverBitmap)
    end else
        GetDefaultCover(dcNoCover, CoverBitmap, cmUseBibDefaults);
        //result := True; // no audiofile, no downloading. ;-)
end;


function TNempPlayer.DrawPreview( DestWidth : Integer; DestHeight : Integer;
                            SkinActive : Boolean = True) : HBITMAP;
var
  ddc   : HDC;
  dbmi  : BITMAPINFO;
  dBits : PInteger;
  h  : Integer;
  SAspect  : Double;
  DAspect  : Double;
  b: TBitmap;
  s: String;
  r: TRect;
begin
    //Result := 0;
    ddc := CreateCompatibleDC(0);

    b := TBitmap.create;
    try
        b.Width := 200;
        b.Height := 100;

        b.Canvas.Pen.Color := clBtnFace;
        b.Canvas.Brush.Style := bsSolid;
        b.Canvas.Brush.Color := clBtnFace;
        b.Canvas.Rectangle(0, 0, b.Width, b.Height);

        if SkinActive then
            b.Canvas.Draw(0,0, PreviewBackGround);

        if (not assigned(MainAudioFile)) and (not fDefaultCoverIsLoaded) then
        begin
            fDefaultCoverIsLoaded := True;
            RefreshCoverBitmap;
        end;

        SetStretchBltMode(b.Canvas.Handle, HALFTONE);
        StretchBlt(b.Canvas.Handle, 6, 5 + 45 - (CoverBitmap.Height Div 4), CoverBitmap.Width Div 2, CoverBitmap.Height Div 2,
                   CoverBitmap.Canvas.Handle, 0,0 ,
                   CoverBitmap.Width, CoverBitmap.Height,
                   SRCCOPY);

        // 1destination.ccordinates must match Spectrum.SetBackground
        StretchBlt(b.Canvas.Handle, 102, 57, Spectrum.PreviewBuf.Width, Spectrum.PreviewBuf.Height,
                   Spectrum.PreviewBuf.Canvas.Handle, 0,0 ,
                   Spectrum.PreviewBuf.Width, Spectrum.PreviewBuf.Height,
                   SRCCOPY);

        if assigned(MainAudioFile) then
        begin
            fDefaultCoverIsLoaded := False;
            b.Canvas.Brush.Style := bsClear;
            b.Canvas.Font.Size := 8;

            if Not UnKownInformation(MainAudioFile.Artist) then
            begin
                s := StringReplace(MainAudioFile.NonEmptyTitle,'&','&&',[rfReplaceAll]);
                r := Rect(102, 4, 198, 44);
                b.Canvas.TextRect(r, s, [tfWordBreak, tfCalcRect]);
                // get needed Height of the Artist-String
                h := r.Bottom - r.Top;
                if h > 26 then
                    h := 26;

                // but draw 2 lines maximum
                b.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 30);
                b.Canvas.TextRect(r, s, [tfWordBreak]);

                s := StringReplace(MainAudioFile.Artist,'&','&&',[rfReplaceAll]);
                b.Canvas.Font.Color := Spectrum.PreviewArtistColor;
                r := Rect(102, 4 + h, 198, 44);
                b.Canvas.TextRect(r, s, [tfWordBreak]);
               // b.Canvas.TextOut(102,6, MainAudioFile.Artist);
               // b.Canvas.TextOut(102,20, MainAudioFile.Titel);
               b.Canvas.Font.Color := Spectrum.PreviewTimeColor;
               if MainAudioFile.isStream then
                  b.Canvas.TextOut(102,44, '(Webradio)')
               else
                   b.Canvas.TextOut(102,44, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );

            end else
            begin
                // just the title
                s := StringReplace(MainAudioFile.NonEmptyTitle,'&','&&',[rfReplaceAll]);
                b.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 44);
                b.Canvas.TextRect(r, s, [tfWordBreak]);
                b.Canvas.Font.Color := Spectrum.PreviewTimeColor;
                if MainAudioFile.isStream then
                    b.Canvas.TextOut(102,44, '(Webradio)')
                else
                    b.Canvas.TextOut(102,44, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );
            end;
        end else
        begin

        end;


        SAspect := (b.Width) /  (b.Height);
        DAspect := DestWidth / DestHeight;
        if SAspect > DAspect then // Source rectangle is wider than the target, correct target height
          DestHeight := Round(DestHeight * DAspect / SAspect)
        else // Source rectangle is higher than the target, correct target witdh
          DestWidth := Round(DestWidth * SAspect / DAspect);

        ZeroMemory(@dbmi.bmiHeader, sizeof(BITMAPINFOHEADER));
        dbmi.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
        dbmi.bmiHeader.biWidth := DestWidth;
        dbmi.bmiHeader.biHeight := -DestHeight;
        dbmi.bmiHeader.biPlanes := 1;
        dbmi.bmiHeader.biBitCount := 32;
        Result := CreateDIBSection(ddc, dbmi, DIB_RGB_COLORS, Pointer(dBits), 0, 0);

        SelectObject(ddc, Result);
        SetStretchBltMode(ddc,HALFTONE);
        StretchBlt(ddc, 0, 0, DestWidth, DestHeight,
                   b.Canvas.Handle, 0,0 ,
                   b.Width, b.Height,
                   SRCCOPY);

    finally
        b.Free;
    end;

    DeleteDC(ddc);
end;

procedure TNempPlayer.UpdateDeskband(wParam, lParam: Integer);
var wnd: THandle;
begin
  wnd :=  FindWindow('Shell_TrayWnd', nil);
  wnd :=  FindWindowEx(wnd, 0, 'ReBarWindow32', nil);
  wnd :=  FindWindowEx(wnd, 0, 'TNempDeskBand', Nil);
  SendMessage(wnd, NempDeskbandUpdateMessage, wParam, lParam);
end;

procedure TNempPlayer.ResetPlayerVCL ;
begin
  SendMessage(MainWindowHandle, WM_ResetPlayerVCL, 0, 0);
end;

procedure TNempPlayer.ActualizePlayPauseBtn(wParam, lParam: Integer);
begin
  SendMessage(MainWindowHandle, WM_ActualizePlayPauseBtn, wParam, lParam);
end;


{
    --------------------------------------------------------
    Birthday-settings
    --------------------------------------------------------
}
procedure TNempPlayer.WriteBirthdayOptions(aIniFilename: UnicodeString);
var ini: TMemIniFile;
begin
    ini := TMeminiFile.Create(aIniFilename, TEncoding.UTF8);
    try
        ini.Encoding := TEncoding.UTF8;
        Ini.WriteBool('Event', 'UseCountDown', NempBirthdayTimer.UseCountDown);
        Ini.WriteTime('Event', 'StartTime'            , NempBirthdayTimer.StartTime);
        Ini.WriteTime('Event', 'StartCountDownTime'   , NempBirthdayTimer.StartCountDownTime);
        Ini.WriteString('Event', 'BirthdaySongFilename' , (NempBirthdayTimer.BirthdaySongFilename));
        Ini.WriteString('Event', 'CountDownFileName'    , (NempBirthdayTimer.CountDownFileName));
        Ini.WriteBool('Event', 'ContinueAfter'        , NempBirthdayTimer.ContinueAfter);
        ini.Encoding := TEncoding.UTF8;
        try
            Ini.UpdateFile;
        except
            // Silent Exception
        end;
    finally
      ini.Free
    end;
end;
procedure TNempPlayer.ReadBirthdayOptions(aIniFilename: UnicodeString);
var ini: TMemIniFile;
begin
    ini := TMeminiFile.Create(aIniFilename, TEncoding.UTF8);
    try
        ini.Encoding := TEncoding.UTF8;
        NempBirthdayTimer.UseCountDown := Ini.ReadBool('Event', 'UseCountDown', True);
        NempBirthdayTimer.StartTime := Ini.ReadTime('Event', 'StartTime', 0 );
        NempBirthdayTimer.StartCountDownTime := Ini.ReadTime('Event', 'StartCountDownTime',0);
        NempBirthdayTimer.BirthdaySongFilename := (Ini.ReadString('Event', 'BirthdaySongFilename', ''));
        NempBirthdayTimer.CountDownFileName := (Ini.ReadString('Event', 'CountDownFileName', ''));
        NempBirthdayTimer.ContinueAfter :=Ini.ReadBool('Event', 'ContinueAfter', True);
    finally
      ini.Free
    end;
end;

function TNempPlayer.GetCountDownLength(aFilename: UnicodeString): Integer;
var tmpstream: DWord;
    af: TAudioFile;
begin
    af := TAudioFile.Create;
    try
        af.Pfad := aFilename; // set path, determine AudioType

        tmpStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False  // ReverseStream
                                 );
        if tmpStream <> 0 then
          Result := Round(Bass_ChannelBytes2Seconds(tmpStream,Bass_ChannelGetLength(tmpStream, BASS_POS_BYTE)))
        else
          Result := 0;

        BASS_StreamFree(tmpstream);
    finally
        af.Free;
    end;
end;

Procedure TNempPlayer.PlayCountDown; // Countdown abspielen mit setzen der Syncs
var af: TAudioFile;
begin
    af := TAudioFile.Create;
    try
        af.Pfad := NempBirthdayTimer.CountDownFileName; // set path, determine AudioType

        CountDownStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False  // ReverseStream
                                 );
        BASS_ChannelFlags(CountDownStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);
          // Attribute setzen
        BASS_ChannelSetAttribute(CountDownStream, BASS_ATTRIB_VOL, fMainVolume);
        BirthdayCountDownSyncHandle :=
          Bass_ChannelSetSync(CountDownStream, BASS_SYNC_END, 0, @EndCountdownProc, self);

        BASS_ChannelPlay(CountDownStream, true);
    finally
        af.Free;
    end;
end;
Procedure TNempPlayer.PlayBirthday; // Geburtstagslied abspielen
var af: TAudioFile;
begin
    af := TAudioFile.Create;
    try
        af.Pfad := NempBirthdayTimer.BirthdaySongFilename; // set path, determine AudioType
        BirthdayStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False  // ReverseStream
                                 );
        BASS_ChannelFlags(BirthdayStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);
        if NempBirthdayTimer.ContinueAfter then
            BirthdaySyncHandle :=
                Bass_ChannelSetSync(BirthdayStream, BASS_SYNC_END, 0, @EndBirthdayProc, self);

          // Attribute setzen
        BASS_ChannelSetAttribute(BirthdayStream, BASS_ATTRIB_VOL, fMainVolume);
        BASS_ChannelPlay(BirthdayStream, true);
    finally
        af.Free;
    end;
end;

Procedure TNempPlayer.AbortBirthday;
begin
  BASS_ChannelStop(CountDownStream);
  Bass_ChannelStop(BirthdayStream);
  if NempBirthdayTimer.ContinueAfter then
    resume;
end;

Function TNempPlayer.CheckBirthdaySettings: Boolean;
begin
  result :=
  (
       // Countdown-Song ist vorhanden ...
      (NempBirthdayTimer.UseCountDown
           AND (NempBirthdayTimer.CountDownFileName <> '')
           AND FileExists(NempBirthdayTimer.CountDownFileName)
           )
      OR  //... oder kein Countdown gewünscht
      (Not NempBirthdayTimer.UseCountDown)
  )
  AND
  (
       // Birthday-Song ist vorhanden
      (NempBirthdayTimer.BirthdaySongFilename <> '')
       AND
      (FileExists(NempBirthdayTimer.BirthdaySongFilename))
  );
end;


{
    --------------------------------------------------------
    Recording of webstreams
    --------------------------------------------------------
}
function TNempPlayer.GenerateRecordingFilename(Extension: String): UnicodeString;
var aTitel, aDate, aTime, aStreamName, MainFilename, localDir: UnicodeString;
    i : Integer;
    tmpResult: UnicodeString;
    newLength: Integer;
begin
  if assigned(MainAudioFile) then
  begin
     if UnKownInformation(MainAudioFile.Artist) then
        aTitel := ReplaceForbiddenFilenameChars(MainAudioFile.NonEmptyTitle)
     else
        aTitel := ReplaceForbiddenFilenameChars(MainAudioFile.Artist + ' - ' + MainAudioFile.NonEmptyTitle);

    aStreamName := ReplaceForbiddenFilenameChars(MainAudioFile.Description);
  end
  else
  begin
    aTitel := '(unknown)';
    aStreamName := '(unknown)';
  end;
  aDate := FormatDateTime('yyyy-mm-dd',Now);
  atime := FormatDateTime('hh.nn',Now);

  MainFilename := StringReplace(FileNameFormat, '<date>',      aDate,       [rfReplaceAll, rfIgnoreCase]);
  MainFilename := StringReplace(MainFilename,   '<time>',    aTime,       [rfReplaceAll, rfIgnoreCase]);
  MainFilename := StringReplace(MainFilename,   '<title>',      aTitel,      [rfReplaceAll, rfIgnoreCase]);
  MainFilename := StringReplace(MainFilename,   '<streamname>', aStreamName, [rfReplaceAll, rfIgnoreCase]);

  MainFilename := ReplaceForbiddenFilenameChars(MainFilename);

  if UseStreamnameAsDirectory then
      localDir := IncludeTrailingPathDelimiter(DownloadDir + aStreamName)
  else
      localDir := DownloadDir;

  // Prüfen, ob Verzeichnis existiert, bei Bedarf erstellen
  // oder ausweich-Ordner nehmen
  if not DirectoryExists(localDir) then
  begin
      try
          ForceDirectories(localDir);
      except
          if Not DirectoryExists(localDir) then
              localDir := Savepath;
      end;
  end;

  tmpResult := localDir + MainFilename + Extension;
  result := '';

  if FileExists(tmpResult) then
  begin
      if (length(tmpResult) < 244) then
      begin
         // (x) dranhängen
         i := 1;
         repeat
            result := localDir + MainFilename + '_' + IntToStr(i) + Extension;
            inc(i);
         until not FileExists(result);
      end else
      begin
          // erst kürzen
          newLength := 244 - length(Extension) - length(localDir);
          if newlength > 0 then
          begin
              MainFilename := Copy(MainFilename, 1, newLength);
              result := localDir + MainFilename + Extension;
              i := 1;
              while FileExists(result) and (i < 100) do
              begin
                 result := localDir + MainFilename + '_' + IntToStr(i) + Extension;
                 inc(i);
              end;
          end else
              // Exception erzeugen
              raise Exception.Create('Filename too long.')
      end
  end
  else
  begin
      // Datei existiert noch nicht
      if length(tmpResult) < 248 then
          result := tmpResult
      else
      begin
          // erst kürzen
          //Showmessage('kürze...');
          newLength := 244 - length(Extension) - length(localDir);
          if newlength > 1 then
          begin
              MainFilename := Copy(MainFilename, 1, newLength);
              result := localDir + MainFilename + Extension;
              i := 1;
              while FileExists(result) and (i < 100) do
              begin
                 result := localDir + MainFilename + '_' + IntToStr(i) + Extension;
                 inc(i);
              end;
          end else
              // Exception erzeugen
              raise Exception.Create('Filename too long.')
      end;
  end;
end;

function TNempPlayer.StartRecording: Boolean;
var newID3v2Tag: TID3v2Tag;
    newArtist, newTitel: UnicodeString;
    idx: Integer;
    Extension: String;
    fn: UnicodeString;
begin
  // laufende Aufnahme Abbrechen
  StreamRecording := False;
  
  if assigned(RecordStream) then
    FreeAndNil(RecordStream);

  result := False;
  if (not assigned(MainAudioFile)) or (not MainAudioFile.isStream) then exit;

  Extension := GetStreamExtension(MainStream);
  RecordStream := Nil;
  fn := '';
  try
      fn := GenerateRecordingFilename(Extension);
      try
          RecordStream := TFileStream.Create(fn, fmCreate or fmOpenWrite or fmShareDenyWrite);
          // Das hier nur bei mp3-Streams machen. Da gibts (?) in den tags keine Trennung von Artist und Titel
          if AnsiLowercase(Extension) = '.mp3' then
          begin
              // Bei mp3-Streams: ID3(v2)-Tag an den Anfang der Datei schreiben
              idx := pos(' - ', MainAudioFile.Titel);
              if idx > 0 then
              begin
                newArtist := copy(MainAudioFile.Titel, 1, idx-1);
                newTitel := copy(MainAudioFile.Titel, idx+3, length(MainAudioFile.Titel) - idx-2);
              end else
              begin
                newArtist := '';
                newTitel := MainAudioFile.Titel;
              end;
              newID3v2Tag := TID3v2Tag.Create;
              if AutoSplitByTitle then
              begin
                  NewId3v2Tag.Title := newTitel;
                  NewID3v2Tag.Artist := newArtist;
              end else
              begin
                  NewId3v2Tag.Title := 'Recording: ' + FormatDateTime('yyyy-mm-dd',Now);
                  NewID3v2Tag.Artist := 'Various Artists';
              end;
              NewID3v2Tag.Album := MainAudioFile.Description;
              NewID3v2Tag.Comment := 'Webradio: ' + MainAudioFile.Pfad + #13#10 + 'Recorded by Nemp - noch ein MP3-Player.';
              NewID3v2Tag.WriteToStream(RecordStream);
              NewID3v2Tag.Free;
          end;
          // Aktuelle Zeit nehmen
          fRecordStartTime := Now;
          StreamRecording := True;
          result := True;
      except
          on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
      end;
  except
      MessageDlg(Player_FilenameWebradioTooLong, mtWarning, [mbOK], 0);
  end;

end;

procedure TNempPlayer.StopRecording;
begin
  FreeandNil(RecordStream);
  StreamRecording := False;
  SendMessage(MainWindowHandle, WM_PlayerStopRecord, 0, 0);
end;

function TNempPlayer.SplitRecordStreamNow(BufLen: DWORD): Boolean;
begin
    result := False;
    if AutoSplitByTime then
    begin
        if SecondsBetween(Now, fRecordStartTime) >= AutoSplitMaxTime * 60 then
            result := True;
    end;
    if AutoSplitBySize then
    begin
        if RecordStream.Size + BufLen >= fAutoSplitMaxSizeByte then
            result := True;
    end;
end;

procedure TNempPlayer.SetAutoSplitMaxSize(Value: Integer);
begin
      fAutoSplitMaxSizeMB   := Value ;
      fAutoSplitMaxSizeByte := Value * 1024 * 1024 ;
end;


end.
