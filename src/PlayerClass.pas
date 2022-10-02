
{

    Unit PlayerClass

    One of the Basic-Units - The Player

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

unit PlayerClass;

interface

uses  Windows, Classes,  Controls, StdCtrls, ExtCtrls, Buttons, SysUtils, Contnrs,
      ShellApi, IniFiles, Dialogs, Graphics, cddaUtils, math, CoverHelper,
      bass, bass_fx, basscd, spectrum_vis, DateUtils, bassmidi,
      NempAudioFiles,  Nemp_ConstantsAndTypes, NempAPI, ShoutCastUtils, PostProcessorUtils,
      Hilfsfunktionen, gnuGettext, Nemp_RessourceStrings, OneINst,
      Easteregg, ScrobblerUtils, CustomizedScrobbler, SilenceDetection, System.UITypes;

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

  TPrescanMode = (ps_None, ps_Now, ps_Later);

  TPlayerMessageEvent = procedure(Sender: TObject; aMessage: String) of object;

  TNempPlayer = class
    private

      fMainVolume: Single;          // the main volume of the player
      fHeadsetVolume: Single;       // the volume of the secondary player (headset)
      fBirthdayVolume: Single;
      fSampleRateFaktor: Single;    // Factor to multiply the samplerate with (0.5 to 2)

      // values for Echo and Hall
      fEchoWetDryMix: single;
      fEchoTime: single;
      fReverbMix: single; // 0..96

      // fPlayingTitel: UnicodeString; // the title of the current file, i.e. "interpret - title"
      // fPlayingTitle is not used any more, only for Metadata stuff on Streams therefor:
      fCurrentStreamMetaData: String;

      fIsURLStream: Boolean;
      fHeadsetIsURLStream: Boolean;

      // in some cases, fading must be disabled (e.g. cda, backward)
      fReallyUseFading: Boolean;

      // handles for sliding, crossfading, ...
      // *M / *S: Mainstream/SlideStream
      fFileEndSyncHandleM: DWord;  // really the end of the file
      fFileEndSyncHandleS: DWord;  // set it always, in case the other syncs are missed

      fSilenceBeginSyncHandleM: DWord; // Syncs where the Silence begin
      fSilenceBeginSyncHandleS: DWord; //

      fFileNearEndSyncHandleM: DWord; // for fading into the next track
      fFileNearEndSyncHandleS: DWord; // (x seconds before file end OR SilenceBegin)

      fTrackDelayStartTime: Cardinal;
      fTrackDelayTimer: THandle;
      fSoundfont  : HSOUNDFONT;
      fSoundfontFilename : String;

      fCueSyncHandleM: DWord;
      fCueSyncHandleS: DWord;

      fSlideEndSyncM: DWord;
      fSlideEndSyncS: DWord;
      fABRepeatSyncM: DWord;
      fABRepeatSyncS: DWord;
      fABRepeatStartPosition: Double;
      fABRepeatEndPosition: Double;
      fABRepeatActive: Boolean;

      fHeadsetFileEndSyncHandle: DWord;

      fSilenceDetected: Boolean;
      fSilenceStart: Double;     // Position in Seconds

      fDoSilenceDetection: Boolean;
      fSilenceThreshold: Integer;

      fDoPauseBetweenTracks: Boolean;
      fPauseBetweenTracks: Integer;

      fApplyReplayGain      : Boolean;
      fPreferAlbumGain      : Boolean;
      fDefaultGainWithoutRG : Single;
      fDefaultGainWithRG    : Single;
      fPreventClipping      : Boolean;


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
      fSafePlayback: Boolean;

      fAvoidMickyMausEffect: LongBool; // this is also used in the Prescan-Thread: therefore: InterLockedExchange

      fMainWindowHandle: HWND;    // the main window, where some messages are sent to
      fPathToDlls: String;        // the path to the bass.dll-addons

      fNemp_BassUserAgent: String;

      fDefaultCoverIsLoaded: Boolean;

      fPrescanFiles: TAudioFileList;  // a List of AudioFiles, marked for threaded Prescan.
      fPrescanInProgress: Boolean; // Flag, whether Precan-Thread is already running
      ThreadedMainStream: DWord;
      ThreadedSlideStream: DWord;

      // (new 4.11) ok, we'll get a mixture of SendMessages and Events by that, but
      // it's working, wo why not. maybe change the code to events anyway later ...
      fOnPlayerStopped: TNotifyEvent;
      fOnMessage: TPlayerMessageEvent;


      // Basic method for creating a stream from a given file   //filename
      function NEMP_CreateStream(aFile: TAudioFile; //UnicodeString;
                           aNoMickyMaus: boolean;
                           aReverse: boolean;
                           PrescanMode: TPrescanMode;
                           checkEasterEgg: boolean = False): DWord;

      function EqualizerIsNeeded: boolean;
      procedure InitStreamEqualizer(aStream: DWord);
      procedure ApplyReplayGainToStream(aStream: DWord; aAudioFile: TAudioFile);


      // Setter/getter for some properties
      procedure SetVolume(Value: Single);         // Volume
      function GetVolume: Single;
      procedure SetPosition(Value: Longword);     // Position
      function GetTime: Double;
      procedure SetTime(Value: Double);
      function GetProgress: Double;               // Progress
      procedure SetProgress(Value: Double);
      function GetLength: Double;                 // Length of a song

      function fGetSeconds: Integer; // current Progress, rounded to full seconds
      function fGetSecondsHeadset: Integer;


      function GetAvoidMickyMausEffect: LongBool;
      procedure SetAvoidMickyMausEffect(aValue: LongBool);

      function GetBirthdayVolume: Single;
      procedure SetBirthdayVolume(Value: Single);

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
      /// procedure SetPlayingTitelMode(Value: Word);     // Playing-title-mode
      procedure SetAutoSplitMaxSize(Value: Integer);  // Split size for webstream recording
      function GetFloatable: Boolean;

      procedure GetURLDetails;  // Get Data from a webstream and set syncs for Meta-information

      // ResetPlayerVCL: Send a Message to the main window to restore some buttons (rewind-button)
      // also: Display the new title, the new cover, ...
      // This is done on beginning of a new song
      // param GetCoverWasSuccessful: used to start an online search for the cover, if no cover has been found
      procedure ResetPlayerVCL(GetCoverWasSuccessful: boolean);
      // set the play/pause button according to the current state of the player
      procedure ActualizePlayPauseBtn(wParam, lParam: Integer);

      procedure StartPrescanThread;
      function GetTimeString: String;
      function GetTimeStringHeadset: String;

      {function fGetPlayerLine1: UnicodeString;
      function fGetPlayerLine2: UnicodeString;
      }

      function GetCurrentAudioFile: TPlaylistFile;

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

        UseDefaultEffects: Boolean;
        UseDefaultEqualizer: Boolean;
        PlayBufferSize: DWORD;

        UseVisualization: Boolean;
        VisualizationInterval: Integer;

        TimeMode: Byte;
        ScrollTaskbarTitel: Boolean;
        ScrollTaskbarDelay: Integer;
        //ScrollAnzeigeDelay: Integer;

        ReInitAfterSuspend: Boolean;
        PauseOnSuspend    : Boolean;

        ReduceMainVolumeOnJingle: Boolean;
        ReduceMainVolumeOnJingleValue: Integer;
        JingleVolume: Integer;
        UseWalkmanMode: Boolean;

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

        // ReplayGain
        RGVolumeMain,
        RGVolumeSlide : BASS_BFX_VOLUME;

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
        NempLogFile  : TNempLogFile;     // the LogFile-thingy
        PostProcessor: TPostProcessor;   // the Postprocessor: change rating of the file and scrobble it

        MainPlayerPicture: TPicture;    // The Cover of the current file
        HeadsetPicture: TPicture;    // The Cover of the current file in Headset
        PreviewBackGround: TBitmap; // The BackGroundImage for the Win7-Preview

        CoverArtSearcher: TCoverArtSearcher;

        property Volume: Single read GetVolume write SetVolume;
        property HeadSetVolume: Single read GetHeadsetVolume write SetHeadsetVolume;
        property BirthdayVolume: Single read GetBirthdayVolume write SetBirthdayVolume;
        property Time: Double read GetTime write SetTime;              // time in seconds
        property TimeInSec: Integer read fGetSeconds;
        property TimeInSecHeadset: Integer read fGetSecondsHeadset;
        property TimeString: String read GetTimeString;
        property TimeStringHeadset: String read GetTimeStringHeadset;
        property Progress: Double read GetProgress write SetProgress;  // 0..1
        property Dauer: Double read Getlength;

        property Speed: Single read fSampleRateFaktor write SetSamplerateFactor;
        property EchoWetDryMix: single  read fEchoWetDryMix write SetEchoMix  ;
        property EchoTime: single       read fEchoTime      write SetEchoTime;
        property ReverbMix: single      read fReverbMix     write SetReverbMix  ;

        //property PlayerLine1: UnicodeString read fGetPlayerLine1;
        //property PlayerLine2: UnicodeString read fGetPlayerLine2;

        property URLStream: Boolean read fIsUrlStream;

        property Status: Integer read fStatus;
        property StopStatus: Integer read fStopStatus;
        property BassStatus: DWord read GetBassStatus;
        property BassHeadSetStatus: DWord read GetBassHeadSetStatus;

        property CurrentFile: TPlaylistFile read GetCurrentAudioFile;

        property LastUserWish: Integer read fLastUserWish write fLastUserWish;

        property AutoSplitMaxSize: Integer read fAutoSplitMaxSizeMB write SetAutoSplitMaxSize;

        property Floatable: Boolean read GetFloatable;
        property UseFloatingPointChannels: Integer read fUseFloatingPointChannels write fUseFloatingPointChannels;
        property UseHardwareMixing: Boolean read fUseHardwareMixing write fUseHardwareMixing;
        property SafePlayback: Boolean read fSafePlayback write fSafePlayback;

        property AvoidMickyMausEffect: LongBool read GetAvoidMickyMausEffect write SetAvoidMickyMausEffect;

        property ABRepeatA: Double read fABRepeatStartPosition;
        property ABRepeatB: Double read fABRepeatEndPosition;
        property ABRepeatActive: Boolean read fABRepeatActive;

        property DoSilenceDetection: Boolean read fDoSilenceDetection write fDoSilenceDetection;
        property SilenceThreshold: Integer read fSilenceThreshold write fSilenceThreshold;

        property DoPauseBetweenTracks: Boolean read fDoPauseBetweenTracks write fDoPauseBetweenTracks;
        property PauseBetweenTracksDuration  : Integer read fPauseBetweenTracks   write fPauseBetweenTracks  ;

        property ApplyReplayGain     : Boolean read fApplyReplayGain      write fApplyReplayGain     ;
        property PreferAlbumGain     : Boolean read fPreferAlbumGain      write fPreferAlbumGain     ;
        property DefaultGainWithoutRG: Single  read fDefaultGainWithoutRG write fDefaultGainWithoutRG;
        property DefaultGainWithRG   : Single  read fDefaultGainWithRG    write fDefaultGainWithRG   ;
        property PreventClipping     : Boolean read fPreventClipping      write fPreventClipping     ;

        property PrescanInProgress: Boolean read fPrescanInProgress;

        property Nemp_BassUserAgent: String read fNemp_BassUserAgent;

        property SoundfontFilename : String read fSoundfontFilename write fSoundfontFilename;

        property OnPlayerStopped: TNotifyEvent read fOnPlayerStopped write fOnPlayerStopped;
        property OnMessage: TPlayerMessageEvent read fOnMessage write fOnMessage;

        constructor Create(AHnd: HWND);
        destructor Destroy; override;

        procedure InitBassEngine(HND: HWND; PathToDlls: String; var Filter: UnicodeString);

        procedure SetSoundFont(aFilename: String);

        // Nötig z.B. bei meinem Notebook, wenn man aus dem Ruhezustand hochkommt
        procedure ReInitBassEngine;
        procedure UpdateFlags;

        procedure LoadSettings;
        procedure SaveSettings;

        // Play: Spielt ein Audiofile ab.
        procedure play(aAudioFile: TPlaylistFile; Interval: Integer; StartPlay: Boolean; StartPos: Double = 0);
        // Hält die Wiedergabe an.
        // Bei Streams wird gestoppt, bei Dateien pausiert
        procedure pause;
        // Hält die Wiedergabe an
        // The parameter is used to cancel the "IgnoreFadingOnStop"-setting
        // if the player stops current playback to start a new one, there should be fading!
        procedure stop(StartPlayAfterStop: Boolean = False);
        // Setzt eine angehaltene Wiedergabe wieder fort
        procedure resume(ResumeAfterBreakBetweenTracks: Boolean = False);
        // Langsam ausfaden bei einem ShutDown. Keine neuen Titel anfangen. Max. Fade-Zeit aTime in Sekunden
        procedure FadeOut(aTime: Integer);
        // FadeOut Abbrechen
        procedure CancelFadeOut;

        // Stoppt die wiedergabe und gibt die streams frei,
        // setzt mainstream und slidestream auf 0
        procedure StopAndFree(StartPlayAfterStop: Boolean = False);
        // Kehrt die Richtung der Wiedergabe um
        procedure PlayReverse(fromPos: QWord);
        procedure ReversePlayback(FromBeginning: Boolean);
        procedure ForceForwardPlayback;

        // change the property AvoidMickyMouseEffect and apllies it to the current playback
        procedure ChangeMickyMouseEffect(aValue: Boolean);

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

        // Aktualisiert den String, der in der Anzeige durchläuft
        function GenerateTaskbarTitel: UnicodeString;

        // Aktualisiert den Text, die Zeit und das Spectrum in der Anzeige
        procedure DrawMainPlayerVisualisation; //(IncludingTime: Boolean = True);
        procedure DrawHeadsetVisualisation; //(IncludingTime: Boolean = True);
        //procedure DrawTimeFromProgress(aProgress: Single);
        function GetTimeStringFromProgress(aProgress: Single): String;

        //procedure DrawHeadsetTimeFromProgress(aProgress: Single);
        function GetHeadsetTimeStringFromProgress(aProgress: Single) : String;

        function RefreshCoverBitmap: Boolean;
        function RefreshHeadsetCoverBitmap: Boolean;

        function DrawPreview( DestWidth : Integer; DestHeight : Integer;
                            SkinActive : Boolean = True) : HBITMAP;

        procedure DrawPreviewNew( DestWidth : Integer; DestHeight : Integer;
                            destBitmap: TBitmap; SkinActive : Boolean = True);

        procedure SetCueSyncs;

        procedure SetEndSyncs(dest: DWord); // Stream, in dem sie gesetzt werden sollen
        procedure SetNoEndSyncs(dest: DWord); // NoEnd: Kein AutoplayNext.
        // eben diese Sync entfernen - sonst kann es bei Pause/Stop mit Fading
        // zu einem Playnext kommen ;-)
        procedure RemoveEndSyncs;
        procedure SetSlideEndSyncs;

        procedure SetABSyncs(p1, p2: Double);
        procedure SetASync(p1: Double);
        procedure SetBSync(p1: Double);
        procedure RemoveABSyncs;
        procedure ClearABSyncs;

        function GetActiveCue: TAudioFile;
        function GetActiveCueIndex: Integer;

        function JumpToNextCue: Boolean;
        function JumpToPrevCue: Boolean;

        procedure Flutter(aValue: single; t: Integer);

        Procedure SetEqualizer(band: Integer; gain: Single);

        //procedure ReadBirthdayOptions(aIniFilename: UnicodeString);
        //procedure WriteBirthdayOptions(aIniFilename: UnicodeString);
        function GetCountDownLength(aFilename: UnicodeString): Integer;
        procedure PauseForBirthday; // the same as nomale pause, but force fading
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

        procedure StartSilenceDetection;
        procedure ProcessSilenceDetection(aSilenceDetector: TSilenceDetector);

        procedure ProgressDelayedPlayNext;
        procedure StopPauseBetweenTracksTimer;
        function StartPauseBetweenTracksTimer: Boolean;

        function SwapStreams(ScannedFile: TAudioFile): Integer;
  end;

var CSPrescanList: RTL_CRITICAL_SECTION;


Const
  // Kopie aus der bass.dll - nicht ändern!!!
  // BASS_ChannelIsActive return values
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED  = 3;



implementation

Uses NempMainUnit, AudioFileHelper, ID3v2Tags, AudioDisplayUtils;


procedure EndFileProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
var aPlayer: TNempPlayer;
begin
  aPlayer := TNempPlayer(User);
  // If this is called, the file is on its end.
  aPlayer.EndFileProcReached := True;

  if aPlayer.DoPauseBetweenTracks then
    SendMessage(aPlayer.MainWindowHandle, WM_PrepareNextFile, 0, 0)
  else
    SendMessage(aPlayer.MainWindowHandle, WM_NextFile, 0, 0);
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
var aPlayer: TNempPlayer;
begin
  aPlayer := TNempPlayer(User);
  SendMessage(aPlayer.MainWindowHandle, WM_SlideComplete, 0, 0);

  if aPlayer.fSlideIsStopSlide then
      SendMessage(aPlayer.MainWindowHandle, WM_PlayerStop, 0, 0);
  aPlayer.fSlideIsStopSlide := False;
end;

procedure ABRepeatProc(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
begin
    TNempPlayer(User).Progress := TNempPlayer(User).fABRepeatStartPosition;
    // refresh Cue stuff
    SendMessage(TNempPlayer(User).MainWindowHandle, WM_NextCue, 0, 0);
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
  newStreamMetadata: String;
  newDataReceived: Boolean;
begin
  newStreamMetadata := String(BASS_ChannelGetTags(channel, BASS_TAG_META));
  newDataReceived := newStreamMetadata <> TNempPlayer(User).fCurrentStreamMetadata;
  // DetectUTF8Encoding ?? somehow ?

  if (newStreamMetadata <> '') AND (TNempPlayer(User).MainAudioFile <> NIL) then
  begin
        p := Pos('StreamTitle=', newStreamMetadata);
        if (p > 0) then
        begin
              p := p + 13;
              TNempPlayer(User).MainAudioFile.Titel := Copy(newStreamMetadata, p, Pos(';', newStreamMetadata) - p - 1);
        end;

        if TNempPlayer(User).StreamRecording
            AND newDataReceived
            AND TNempPlayer(User).AutoSplitByTitle
        then
            TNempPlayer(User).StartRecording;

        if newDataReceived then
            TNempPlayer(User).fCurrentStreamMetadata := newStreamMetadata;

        SendMessage(TNempPlayer(User).MainWindowHandle, WM_NewMetaData, 0, 0);
  end;
end;

procedure DoOggMeta(handle: HWND; Channel, Data: DWord; User: Pointer); stdcall;
var
  meta: PAnsiChar;
  metaStr: String;
  newStreamMetadata: String;
  newDataReceived: Boolean;
begin
  newStreamMetadata := ''; // Concatenation of all the 0-terminated metaStr

  meta := BASS_ChannelGetTags(channel, BASS_TAG_OGG);

  if (meta <> nil) AND (TNempPlayer(User).MainAudioFile <> NIL) then
  begin
      // nach Ogg-Daten suchen
      if (meta <> nil) then
          try
              while (meta^ <> #0) do
              begin
                  metaStr := String(meta);
                  newStreamMetadata := newStreamMetadata + metaStr;
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

      newDataReceived := newStreamMetadata <> TNempPlayer(User).fCurrentStreamMetadata;

      if TNempPlayer(User).StreamRecording
          AND newDataReceived
          AND TNempPlayer(User).AutoSplitByTitle
      then
          TNempPlayer(User).StartRecording;

      if newDataReceived then
          TNempPlayer(User).fCurrentStreamMetadata := newStreamMetadata;

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

    NempLogFile  := TNempLogFile.create(aHnd);;

    PostProcessor := TPostProcessor.Create(aHnd);
    PostProcessor.NempScrobbler := NempScrobbler;
    PostProcessor.NempLogFile := NempLogFile;

    MainPlayerPicture := TPicture.Create;
    HeadsetPicture    := TPicture.Create;

    PreviewBackGround := TBitmap.Create;
    PreviewBackGround.Width :=200;
    PreviewBackGround.Height := 145;
    fABRepeatActive := False;

    fPrescanFiles := TAudioFileList.Create(True);
    fPrescanInProgress := False;

    CoverArtSearcher := TCoverArtSearcher.create;
    fTrackDelayTimer := 0;
end;

procedure DelayedPlayNext(lpParameter: Pointer; TimerOrWaitFired: Boolean); stdcall;
begin
  //postMessage(aPlayer.MainWindowHandle, WM_PlayerDelayedPlayNext, 0, 0);
  SendMessage(Integer(lpParameter), WM_PlayerDelayedPlayNext, 0, 0);
end;

procedure TNempPlayer.ProgressDelayedPlayNext;
var
  timeElapsed: Integer;
begin
  timeElapsed := getTickCount - fTrackDelayStartTime;
  if (PauseBetweenTracksDuration = 0) or (timeElapsed > PauseBetweenTracksDuration) then
  begin
    resume(True);
    SendMessage(MainWindowHandle, WM_PlayerPlay, 0, 0);
    SendMessage(MainWindowHandle, WM_PlayerDelayCompleted, 0, 0);
  end
  else
  begin
     Spectrum.DrawWaitingProgress(round(timeElapsed/PauseBetweenTracksDuration * 100));
  end;
end;

procedure TNempPlayer.StopPauseBetweenTracksTimer;
begin
  if fTrackDelayTimer <> 0 then
  begin
    DeleteTimerQueueTimer(0, fTrackDelayTimer, 0);
    fTrackDelayTimer := 0;
  end;
end;

function TNempPlayer.StartPauseBetweenTracksTimer: Boolean;
begin
  // clear old timer, if there is one
  StopPauseBetweenTracksTimer;
  fTrackDelayStartTime := GetTickCount;
  // start a new timer
  result := CreateTimerQueueTimer(
      fTrackDelayTimer,
      0,
      DelayedPlayNext,
      Pointer(MainWindowHandle),
      25,  // 25ms should be ok here
      // PauseBetweenTracksDuration,
      25,
      0
      );
  if not result then
    fTrackDelayTimer := 0;
end;

destructor TNempPlayer.Destroy;
var i: Integer;
    BassInfo: BASS_DEVICEINFO;
begin
    MainPlayerPicture.Free;
    HeadsetPicture.Free;
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
    NempLogFile.Free;

    if assigned(HeadSetAudioFile) then
        HeadSetAudioFile.Free;

    fPrescanInProgress := False;
    EnterCriticalSection(CSPrescanList);
    fPrescanFiles.Free;
    fPrescanFiles := Nil;
    LeaveCriticalSection(CSPrescanList);

    CoverArtSearcher.Free;

    inherited Destroy;
end;

{
    --------------------------------------------------------
    Initialization of the bass-engine
    --------------------------------------------------------
}

procedure TNempPlayer.SetSoundFont(aFilename: String);
var NewSoundfont  : BASS_MIDI_FONT;
begin
    NewSoundfont.font := BASS_MIDI_FontInit(PChar(aFilename), BASS_UNICODE);  // open new soundfont
    if (NewSoundfont.font <> 0) and (NewSoundfont.font <> fSoundfont) then
    begin
        NewSoundfont.preset := -1;                                  // use all presets
        NewSoundfont.bank   := 0;                                   // use default bank(s)
        BASS_MIDI_FontFree(fSoundfont);                             // free old soundfont
        BASS_MIDI_StreamSetFonts(0, NewSoundfont, 1);               // set default soundfont
        BASS_MIDI_StreamSetFonts(MainStream, NewSoundfont, 1);      // set for current stream too
        BASS_MIDI_StreamSetFonts(SlideStream, NewSoundfont, 1);
        fSoundfont := NewSoundfont.font;
        fSoundfontFilename := aFilename;
    end;
end;

procedure TNempPlayer.InitBassEngine(HND: HWND; PathToDlls: String; var Filter: UnicodeString);
var count: LongWord;
    fh: THandle;
    fd: TWin32FindData;
    plug: DWORD;
    i: integer;
    tmpfilter: String;
    BassInfo: BASS_DEVICEINFO;
    sf  : BASS_MIDI_FONT;

    procedure ProcessPLugin(aPlug: Dword);
    var Info: PBass_PluginInfo;
        a, j: Integer;
        tmpext: TStringList;
        newExt: String;
    begin
      Info := BASS_PluginGetInfo(aPlug); // get plugin info to add to the file selector filter...
      tmpext := TStringList.Create;
      try
        for a := 0 to Info.formatc - 1 do begin
          // Set The OpenDialog additional, to the supported PlugIn Formats
          Filter := Filter
            + '|' + String(Info.Formats[a].name) + ' ' + '(' +
            String(Info.Formats[a].exts) + ')' { , ' + fd.cFileName} + '|' + String(Info.Formats[a].exts);
          //ValidExtensions
          Explode(';', String(Info.Formats[a].exts), tmpext  );
          for j := 0 to tmpext.Count - 1 do begin
            newExt := StringReplace(tmpext.Strings[j],'*', '',[]);
            if ValidExtensions.IndexOf(newExt) = -1 then
              ValidExtensions.Add(newExt);
          end;
        end;
      finally
        tmpext.Free;
      end;
    end;

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
    BASS_SetConfig(BASS_CONFIG_DEV_DEFAULT, 1);

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

    // Init SoundFonts for MIDI
    if (BASS_MIDI_StreamGetFonts(0, sf, 1) >= 1) then
        fSoundfont  := sf.font
    else
    begin
        if (fSoundfontFilename <> '') and FileExists(fSoundfontFilename) then
            SetSoundFont(fSoundfontFilename)
        else
        begin
            fh := FindFirstFile(PChar(PathToDlls + '*.sf2'), fd);
            if (fh <> INVALID_HANDLE_VALUE) then
                SetSoundFont(PathToDlls + fd.cFileName);
        end;
    end;

    BASS_SetConfigPtr(BASS_CONFIG_NET_AGENT or BASS_UNICODE, PChar(Nemp_BassUserAgent));
    BASS_SetConfig(BASS_CONFIG_BUFFER, PlayBufferSize);

    // more stable Webradio? (2019) ---
    BASS_SetConfig(BASS_CONFIG_NET_BUFFER, 10000);
    BASS_SetConfig(BASS_CONFIG_NET_READTIMEOUT, 2000);
    // ---

    UpdateFlags;
    Filter := '|Standard formats (*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.aif)' + '|'
                    + '*.mp3;*.mp2;*.mp1;*.ogg;*.wav*;*.aif';

    // load MIDI plugin first (which is stored in the main directory now)
    if FileExists(PChar(ExtractFilePath(ParamStr(0)) + 'bass\bassmidi.dll')) then
    begin
        plug := BASS_PluginLoad(PChar(ExtractFilePath(ParamStr(0)) + 'bass\bassmidi.dll'), BASS_UNICODE);
        if Plug <> 0 then
            ProcessPLugin(Plug);
    end;

    // weitere Plugins laden. Code aus dem PLugin-Beipsiel -Projekt
    fh := FindFirstFile(PChar(PathToDlls + 'bass*.dll'), fd);
    if (fh <> INVALID_HANDLE_VALUE) then
    try
        repeat
            if fd.cFileName <> 'bassmidi.dll' then
            begin
                plug := BASS_PluginLoad(PChar(PathToDlls + fd.cFileName), BASS_UNICODE);
                if Plug <> 0 then
                    ProcessPLugin(Plug);
            end;
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
                                     + Filter;
                                       // + '|CD-Audio|*.cda' ;
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
procedure TNempPlayer.LoadSettings;
var i: Integer;
begin
  MainDevice := NempSettingsManager.ReadInteger('Player','MainDevice',1);
  HeadsetDevice := NempSettingsManager.ReadInteger('Player','HeadsetDevice',2);
  fMainVolume := NempSettingsManager.ReadInteger('Player','MainVolume',50);
  fMainVolume := fMainVolume / 100;
  fHeadsetVolume := NempSettingsManager.ReadInteger('Player','HeadsetVolume',50);
  fHeadsetVolume := fHeadsetVolume / 100;

  fSoundfontFilename := NempSettingsManager.ReadString('Player', 'SoundfontFilename', '');

  fUseFloatingPointChannels := NempSettingsManager.ReadInteger('Player', 'FloatingPointChannels', 0);// 0: Auto-Detect, 1: Aus, 2: An
  if fUseFloatingPointChannels > 2 then fUseFloatingPointChannels := 0;
  if fUseFloatingPointChannels < 0 then fUseFloatingPointChannels := 0;

  fUseHardwareMixing := NempSettingsManager.ReadBool('Player', 'HardwareMixing', True);  // False: OR BASS_SAMPLE_SOFTWARE
  fSafePlayback := NempSettingsManager.ReadBool('Player', 'SafePlayback', False);

  UseFading             := NempSettingsManager.ReadBool('Player','UseFading',True);
  FadingInterval        := NempSettingsManager.ReadInteger('Player','FadingInterval',2000);
  SeekFadingInterval    := NempSettingsManager.ReadInteger('Player','SeekFadingInterval',300);
  IgnoreFadingOnShortTracks := NempSettingsManager.ReadBool('Player', 'IgnoreOnShortTracks', True);
  IgnoreFadingOnPause   := NempSettingsManager.ReadBool('Player', 'IgnoreOnPause', True);
  IgnoreFadingOnStop    := NempSettingsManager.ReadBool('Player', 'IgnoreOnStop', True);

  DoSilenceDetection    := NempSettingsManager.ReadBool('Player', 'DoSilenceDetection', True);
  SilenceThreshold      := NempSettingsManager.ReadInteger('Player', 'SilenceThreshold', -40);

  DoPauseBetweenTracks  :=  NempSettingsManager.ReadBool('Player', 'DoPauseBetweenTracks', False);
  PauseBetweenTracksDuration :=  NempSettingsManager.ReadInteger('Player', 'PauseBetweenTracksDuration', 2000);

  ApplyReplayGain       := NempSettingsManager.ReadBool('Player', 'ApplyReplayGain', True);
  PreferAlbumGain       := NempSettingsManager.ReadBool('Player', 'PreferAlbumGain', True);
  PreventClipping       := NempSettingsManager.ReadBool('Player', 'PreventClipping', True);
  DefaultGainWithoutRG  := NempSettingsManager.ReadFloat('Player', 'DefaultGain', 0);
  DefaultGainWithRG     := NempSettingsManager.ReadFloat('Player', 'DefaultGainWithRG', 0);


  UseVisualization      := NempSettingsManager.ReadBool('Player','UseVisual',True);
  VisualizationInterval := NempSettingsManager.ReadInteger('Player','Visualinterval',40);
  TimeMode              := NempSettingsManager.ReadInteger('Player', 'ShowTime', 0);
  ScrollTaskbarTitel    := NempSettingsManager.ReadBool('Player','ScrollTaskbarTitel',False);
  ScrollTaskbarDelay    := NempSettingsManager.ReadInteger('Player', 'ScrollTaskbarDelay', 10);
  if ScrollTaskbarDelay < 5 then ScrollTaskbarDelay := 5;

  ReInitAfterSuspend    := NempSettingsManager.ReadBool('Player','ReInitAfterSuspend',False);
  PauseOnSuspend        := NempSettingsManager.ReadBool('Player','PauseOnSuspend',True);

  PlayBufferSize        := NempSettingsManager.ReadInteger('Player','PlayBufferSize',500);

  AvoidMickyMausEffect  := NempSettingsManager.ReadBool('Player', 'KeinMickyMausEffekt', False);
  UseDefaultEffects   := NempSettingsManager.ReadBool('Player', 'UseDefaultEffects', True);
  UseDefaultEqualizer := NempSettingsManager.ReadBool('Player', 'UseDefaultEqualizer', False);

  ReduceMainVolumeOnJingle      := NempSettingsManager.ReadBool('Player','ReduceMainVolumeOnJingle', True);
  ReduceMainVolumeOnJingleValue := NempSettingsManager.ReadInteger('Player','ReduceMainVolumeOnJingleValue',50);
  JingleVolume                  := NempSettingsManager.ReadInteger('Player','JingleVolume',100);
  UseWalkmanMode                := NempSettingsManager.ReadBool('Player','WalkmanMode',True);

  DownloadDir    := (IncludeTrailingPathDelimiter(NempSettingsManager.ReadString('Player', 'WebradioDownloadDir', Savepath + 'Webradio\')));


  FilenameFormat := NempSettingsManager.ReadString('Player', 'WebRadioFilenameFormat', '<date>, <time> - <title>');
  UseStreamnameAsDirectory := NempSettingsManager.ReadBool('Player', 'UseStreamnameAsDirectory', False);
  AutoSplitByTitle := NempSettingsManager.ReadBool('Player', 'WebRadioAutoSplitFiles', True);
  AutoSplitByTime  := NempSettingsManager.ReadBool('Player', 'WebRadioAutoSplitByTime', False);
  AutoSplitBySize  := NempSettingsManager.ReadBool('Player', 'WebRadioAutoSplitBySize', False);

  AutoSplitMaxTime := NempSettingsManager.ReadInteger('Player', 'WebRadioAutoSplitMaxTime', 30);
  if (AutoSplitMaxTime < 0) or (AutoSplitMaxTime > 1440) then AutoSplitMaxTime := 30;

  AutoSplitMaxSize := NempSettingsManager.ReadInteger('Player', 'WebRadioAutoSplitMaxSize', 10);
  if (AutoSplitMaxSize < 0) or (AutoSplitMaxSize > 2000) then AutoSplitMaxSize := 10;

  if Not UseDefaultEffects then
  begin
      ReverbMix     := NempSettingsManager.ReadFloat('Player','Hall', -96);
      if Reverbmix > 0 then Reverbmix := -96;
      EchoWetDryMix := NempSettingsManager.ReadFloat('Player','EchoMix',0);
      if EchoWetDryMix > 50 then EchoWetDryMix := 0;
      EchoTime      := NempSettingsManager.ReadFloat('Player','EchoTime',100);
      if EchoTime < 100 then EchoTime := 100;
      fSampleRateFaktor := NempSettingsManager.ReadFloat('Player','Samplerate', 1);
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
      fxGain[i] := NempSettingsManager.ReadInteger('Player','EQ' + IntToStr(i+1), 0) / EQ_NEW_FACTOR;
      // Vorsicht. In den Inis hatte ich früher immer Button.Top (sogar ohne - Shape.Top!!) gespeichert -- Korrektur erforderlich!
      if fxgain[i] > 15 then fxGain[i] := 0;
    end;
    EQSettingName := NempSettingsManager.ReadString('Player', 'EQ-Settings', 'Auswahl');
  end else
  begin
    for i := 0 to 9 do fxgain[i] := 0;
    EQSettingName := 'Auswahl';
  end;

  // hidden feature: user agent
  fNemp_BassUserAgent := NempSettingsManager.ReadString('Player', 'UserAgent', NEMP_BASS_DEFAULT_USERAGENT);

  NempBirthdayTimer.UseCountDown := NempSettingsManager.ReadBool('Event', 'UseCountDown', False);
  NempBirthdayTimer.StartTime := NempSettingsManager.ReadTime('Event', 'StartTime', 0 );
  // NempBirthdayTimer.StartCountDownTime := Ini.ReadTime('Event', 'StartCountDownTime',0);
  NempBirthdayTimer.BirthdaySongFilename := (NempSettingsManager.ReadString('Event', 'BirthdaySongFilename', ''));
  NempBirthdayTimer.CountDownFileName := (NempSettingsManager.ReadString('Event', 'CountDownFileName', ''));
  NempBirthdayTimer.ContinueAfter :=NempSettingsManager.ReadBool('Event', 'ContinueAfter', True);

  NempScrobbler.LoadFromIni(NempSettingsManager);
  NempLogFile.LoadFromIni(NempSettingsManager);
  PostProcessor.LoadFromIni(NempSettingsManager);
end;

procedure TNempPlayer.SaveSettings;
begin
  NempSettingsManager.WriteInteger('Player','HeadsetDevice',HeadsetDevice);
  NempSettingsManager.WriteInteger('Player','MainDevice',MainDevice);
  NempSettingsManager.WriteInteger('Player','MainVolume',Round(fMainVolume * 100));
  NempSettingsManager.WriteInteger('Player','HeadsetVolume',Round(fHeadsetVolume * 100));

  NempSettingsManager.WriteString('Player', 'SoundfontFilename', fSoundfontFilename);

  NempSettingsManager.WriteInteger('Player', 'FloatingPointChannels', fUseFloatingPointChannels);
  NempSettingsManager.WriteBool('Player', 'HardwareMixing', fUseHardwareMixing);
  NempSettingsManager.WriteBool('Player', 'SafePlayback', fSafePlayback);

  NempSettingsManager.WriteBool('Player','UseFading',UseFading);
  NempSettingsManager.WriteInteger('Player','FadingInterval',FadingInterval);
  NempSettingsManager.WriteInteger('Player','SeekFadingInterval',SeekFadingInterval);
  NempSettingsManager.WriteBool('Player', 'IgnoreOnShortTracks', IgnoreFadingOnShortTracks);
  NempSettingsManager.WriteBool('Player', 'IgnoreOnPause', IgnoreFadingOnPause);
  NempSettingsManager.WriteBool('Player', 'IgnoreOnStop', IgnoreFadingOnStop);

  NempSettingsManager.WriteBool('Player', 'DoSilenceDetection', DoSilenceDetection);
  NempSettingsManager.WriteInteger('Player', 'SilenceThreshold', SilenceThreshold);
  NempSettingsManager.WriteBool('Player', 'DoPauseBetweenTracks', DoPauseBetweenTracks);
  NempSettingsManager.WriteInteger('Player', 'PauseBetweenTracksDuration', PauseBetweenTracksDuration);

  NempSettingsManager.WriteBool('Player', 'ApplyReplayGain', ApplyReplayGain);
  NempSettingsManager.WriteBool('Player', 'PreferAlbumGain', PreferAlbumGain);
  NempSettingsManager.WriteBool('Player', 'PreventClipping', PreventClipping);
  NempSettingsManager.WriteFloat('Player', 'DefaultGainWithRG', DefaultGainWithRG);
  NempSettingsManager.WriteFloat('Player', 'DefaultGain', DefaultGainWithoutRG);

  NempSettingsManager.WriteBool('Player','UseVisual', UseVisualization);
  NempSettingsManager.WriteInteger('Player','Visualinterval', VisualizationInterval);
  NempSettingsManager.WriteInteger('Player', 'ShowTime', TimeMode);
  NempSettingsManager.WriteBool('Player','ScrollTaskbarTitel', ScrollTaskbarTitel);
  NempSettingsManager.WriteInteger('Player', 'ScrollTaskbarDelay', ScrollTaskbarDelay);


  NempSettingsManager.WriteBool('Player','ReInitAfterSuspend',ReInitAfterSuspend);
  NempSettingsManager.WriteBool('Player','PauseOnSuspend',PauseOnSuspend);

  NempSettingsManager.WriteInteger('Player','PlayBufferSize',PlayBufferSize);

  NempSettingsManager.WriteBool('Player', 'KeinMickyMausEffekt', AvoidMickyMausEffect);
  NempSettingsManager.WriteBool('Player', 'UseDefaultEffects', UseDefaultEffects);
  NempSettingsManager.WriteBool('Player', 'UseDefaultEqualizer', UseDefaultEqualizer);

  NempSettingsManager.WriteBool('Player','ReduceMainVolumeOnJingle', ReduceMainVolumeOnJingle);
  NempSettingsManager.WriteInteger('Player','ReduceMainVolumeOnJingleValue', ReduceMainVolumeOnJingleValue);
  NempSettingsManager.WriteInteger('Player','JingleVolume', JingleVolume);
  NempSettingsManager.WriteBool('Player','WalkmanMode', UseWalkmanMode);

  NempSettingsManager.WriteString('Player', 'WebradioDownloadDir', (DownloadDir));
  NempSettingsManager.WriteBool('Player', 'UseStreamnameAsDirectory', UseStreamnameAsDirectory);
  NempSettingsManager.WriteString('Player', 'WebRadioFilenameFormat', FilenameFormat);
  NempSettingsManager.WriteBool('Player', 'WebRadioAutoSplitFiles', AutoSplitByTitle);

  NempSettingsManager.WriteBool('Player', 'WebRadioAutoSplitByTime', AutoSplitByTime);
  NempSettingsManager.WriteBool('Player', 'WebRadioAutoSplitBySize', AutoSplitBySize);
  NempSettingsManager.WriteInteger('Player', 'WebRadioAutoSplitMaxTime', AutoSplitMaxTime);
  NempSettingsManager.WriteInteger('Player', 'WebRadioAutoSplitMaxSize', AutoSplitMaxSize);


  if Not UseDefaultEffects then
  begin
      NempSettingsManager.WriteFloat('Player','Hall',ReverbMix);
      NempSettingsManager.WriteFloat('Player','EchoMix',EchoWetDryMix);
      NempSettingsManager.WriteFloat('Player','EchoTime',EchoTime);
      NempSettingsManager.WriteFloat('Player','Samplerate', fSampleRateFaktor);
  end;

  if NOT UseDefaultEqualizer then
  begin                                            // 111111
      NempSettingsManager.WriteInteger('Player','EQ1',Round(fxGain[0] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ2',Round(fxGain[1] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ3',Round(fxGain[2] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ4',Round(fxGain[3] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ5',Round(fxGain[4] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ6',Round(fxGain[5] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ7',Round(fxGain[6] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ8',Round(fxGain[7] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ9',Round(fxGain[8] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteInteger('Player','EQ10',Round(fxGain[9] * EQ_NEW_FACTOR));
      NempSettingsManager.WriteString('Player', 'EQ-Settings', EQSettingName);
  end;

  NempSettingsManager.WriteBool('Event', 'UseCountDown', NempBirthdayTimer.UseCountDown);
  NempSettingsManager.WriteTime('Event', 'StartTime'            , NempBirthdayTimer.StartTime);
  // StartCountDownTime will be calculated when the event is activated
  // Ini.WriteTime('Event', 'StartCountDownTime'   , NempBirthdayTimer.StartCountDownTime);
  NempSettingsManager.WriteString('Event', 'BirthdaySongFilename' , (NempBirthdayTimer.BirthdaySongFilename));
  NempSettingsManager.WriteString('Event', 'CountDownFileName'    , (NempBirthdayTimer.CountDownFileName));
  NempSettingsManager.WriteBool('Event', 'ContinueAfter'        , NempBirthdayTimer.ContinueAfter);

  NempScrobbler.SaveToIni(NempSettingsManager);
  NempLogFile.WriteToIni(NempSettingsManager);
  PostProcessor.WriteToIni(NempSettingsManager);
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
                           PrescanMode: TPrescanMode;
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
  if  (PrescanMode = ps_Now)
      AND
      (   (extension = '.mp3')
      OR (extension = '.mp2')
      OR (extension = '.mp1')  )
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


          //showmessage('Create Done: ' + Inttostr(BASS_ErrorGetCode) + ' ---  ' + InttoStr(Bass_ChannelGetlength(result, BASS_POS_BYTE)));

          // Vorgang oben fehlgeschlagen? Dann mit Music probieren
          if result = 0 then
              result := BASS_MusicLoad(FALSE, PChar(Pointer(localPath)), 0, 0, BASS_MUSIC_RAMP or DecodeFlag or BASS_MUSIC_PRESCAN or BASS_UNICODE ,0);
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
          result := BASS_StreamCreateURL(PChar(Pointer(localPath)), 0, BASS_STREAM_STATUS or BASS_UNICODE , @StatusProc, nil);
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
    RemoveABSyncs;
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


    if assigned(fOnPlayerStopped) then
        fOnPlayerStopped(self);

    MainStream := 0;
    SlideStream := 0;
    ActualizePlayPauseBtn(NEMP_API_STOPPED, 0);
end;

{
    --------------------------------------------------------
    Playn a Audiofile
    --------------------------------------------------------
}
procedure TNempPlayer.Play(aAudioFile: TPlaylistFile; Interval: Integer; StartPlay: Boolean; StartPos: Double = 0);
var
  extension: String;
  ChannelInfo: BASS_CHANNELINFO;
  basstime: Double;
  basslen: DWord;
  ScanMode: TPrescanMode;
  CoverIsLoaded: Boolean;
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
  StopPauseBetweenTracksTimer;

  //if not JustCDChange then
      StopAndFree(StartPlay);

  MainAudioFile := aAudioFile;
  // First: Think pessimistic. The AudioFile is not present atm.
  MainAudioFileIsPresentAndPlaying := False;
  // We begin a new File:
  EndFileProcReached := False;
  fSilenceDetected := False;
  fSilenceStart := 0;

  if MainAudioFile <> NIL then
  begin
      MainAudioFile.VoteCounter := 0; // We play this file now, so all votes are deleted
      extension := AnsiLowerCase(ExtractFileExt(MainAudioFile.Pfad));

      if assigned(fOnMessage) then
      begin
          case MainAudioFile.AudioType of
              at_File   : fOnMessage(self, 'Starting ' +  MainAudioFile.Dateiname);
              at_Stream : fOnMessage(self, 'Connecting to ' +  MainAudioFile.Pfad );
              at_CDDA   : fOnMessage(self, 'Starting ' +  MainAudioFile.Pfad);
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

      if (StartPos <> 0) or (fSafePlayback) then
          ScanMode := ps_Now
      else
        if (extension = '.mp3')
        OR (extension = '.mp2')
        OR (extension = '.mp1')  then
            ScanMode := ps_Later
        else
            ScanMode := ps_None;


      // ScanMode := ps_Now;

      Mainstream := NEMP_CreateStream(MainAudioFile, AvoidMickyMausEffect, False, ScanMode, True);

      // Fehlerbehandlung
      if (MainStream = 0) {or (not CDChangeSuccess)} then
      begin
          if (BassErrorString(Bass_ErrorGetCode) <> '') and assigned(fOnMessage) then
              fOnMessage(Self, BassErrorString(Bass_ErrorGetCode));
          // something is wrong
          MainAudioFileIsPresentAndPlaying := False;
      end;

      SetEndSyncs(mainstream);

      // Originale Samplerate des Streams bestimmen
      // braucht man beim verändern der Geschwindigkeit
      BASS_ChannelGetAttribute(Mainstream, BASS_ATTRIB_FREQ, OrignalSamplerate{!!});
      InitStreamEqualizer(MainStream);

      ApplyReplayGainToStream(Mainstream, MainAudioFile);

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
                SlideStream := NEMP_CreateStream(MainAudioFile, AvoidMickyMausEffect, False, ScanMode);
                SetEndSyncs(SlideStream);
                InitStreamEqualizer(SlideStream);
                ApplyReplayGainToStream(SlideStream, MainAudioFile);

                if MainStreamIsTempoStream then
                    BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100)
                else
                    BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
                BASS_ChannelSetAttribute(SlideStream, BASS_ATTRIB_VOL, 0);
                fReallyUseFading := True;

                if DoSilenceDetection then
                    case Scanmode of
                        ps_None: StartSilenceDetection;
                        ps_Now: StartSilenceDetection;
                        ps_Later: ; // SilenceDetection is done after
                    end;
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
              fIsURLStream := False;
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
          SynchNewFileWithBib(MainAudioFile, False);

      if ScanMode <> ps_Later then
      begin
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
      end;

      case ScanMode of
        ps_None: ; // no prescan needed (i.e. no mp3 file)
        ps_Now: ;  // prescan already done
        ps_Later: StartPrescanThread;
      end;

      SetCueSyncs;
      // wurde direkt nach der Erzeugung gemacht SetEndSyncs;
      SetSlideEndSyncs;

      // get the cover for the currently playing file
      CoverIsLoaded := RefreshCoverBitmap;
      // display information in the VCL, reset some Buttons (enabled/disabled, directionBtn, ...)
      ResetPlayerVCL(CoverIsLoaded);

      if StartPlay and (Mainstream <> 0) then
      begin
          fstatus := PLAYER_ISPLAYING;
          SendMessage(MainWindowHandle, WM_PlayerPlay, 0, 0);
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
procedure TNempPlayer.resume(ResumeAfterBreakBetweenTracks: Boolean = False);
begin
  if mainstream = 0 then exit;
  StopPauseBetweenTracksTimer;
  // Ende-Syncs wieder setzen
  SetEndSyncs(MainStream);
  SetEndSyncs(SlideStream);
  if UseFading AND fReallyUseFading
      AND NOT (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
      And ((NOT IgnoreFadingOnPause) or ResumeAfterBreakBetweenTracks)
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
procedure TNempPlayer.PlayReverse(fromPos: QWord);
var tmpMain: DWord;
begin
    tmpMain := NEMP_CreateStream(MainAudiofile,
                         //False, // kein Tempostream
                         AvoidMickyMausEffect,
                         True,  // ReverseStream
                         ps_Now );
    MainStreamIsTempoStream := AvoidMickyMausEffect;

    MainStream := tmpMain;

    //if Not FromBeginning then
    BASS_ChannelSetPosition(Mainstream, fromPos, BASS_POS_BYTE);

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

    // No fading for ReverseStreams
    fReallyUseFading := False;
end;

procedure TNempPlayer.ForceForwardPlayback;
begin
    if fIsURLStream then exit;

    if MainStreamIsReverseStream then
        ReversePlayback(False);
    // else: nothing todo
end;
procedure TNempPlayer.ReversePlayback(FromBeginning: Boolean);
var OldPosition: QWord;
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

          if FromBeginning then
              PlayReverse(0)
          else
              PlayReverse(OldPosition)

      end;
      ResetPlayerVCL(True); // same song, cover remains the same
  end;
end;

procedure TNempPlayer.ChangeMickyMouseEffect(aValue: Boolean);
var OldPosition: QWord;
begin
    if aValue = self.AvoidMickyMausEffect then
        exit;

    // set the new value
    AvoidMickyMausEffect := aValue;

    // cancel if there is no "valid" audiofile for changing playback speed
    if fIsURLStream then
        exit;

    if Not assigned(MainAudiofile) then
        exit;

    // even if fSamplerateFaktor = 1 here (= normal speed), we still need to recreate the playback!

    if NOT MainStreamIsReverseStream then
    begin
        // regular playback
        // remember current position
        OldPosition := BASS_ChannelGetPosition(MainStream, BASS_POS_BYTE);
        fReallyUseFading := False;
        // stop playback
        StopAndFree;
        // play again (with new settings, speed is applied there as well)
        Play(MainAudiofile, 0, True);
        // set the position to preovious position
        BASS_ChannelSetPosition(Mainstream, OldPosition, BASS_POS_BYTE);
        fReallyUseFading := True;
        MainStreamIsReverseStream := False;
    end else
    begin
        // reverse playback
        OldPosition := BASS_ChannelGetPosition(MainStream, BASS_POS_BYTE);
        fReallyUseFading := False;
        // stop playback
        StopAndFree;
        // play again
        PlayReverse(OldPosition);
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
                           ps_None,
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

procedure TNempPlayer.ProcessSilenceDetection(
  aSilenceDetector: TSilenceDetector);
begin
    if aSilenceDetector.SilenceStart > 0 then
    begin
        fSilenceDetected := True;
        fSilenceStart := aSilenceDetector.SilenceStart;

        SetEndSyncs(MainStream);
        SetEndSyncs(SlideStream);
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

  // before we start, we should check some cdda-stuff, as only one stream per cd can be created
  if assigned(MainAudioFile) and MainAudioFile.isCDDA then
  begin
      if SameDrive(MainAudioFile.Pfad, aAudioFile.Pfad) then
      begin
          MessageDlg(CDDA_NoHeadsetPossible, mtInformation, [mbOK], 0);
          exit;
      end;
  end;

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
      fHeadsetIsURLStream := HeadSetAudioFile.isStream;
      Bass_ChannelStop(HeadsetStream);
      HeadsetStream := NEMP_CreateStream(HeadSetAudioFile, False, False, ps_Now, True);
      BASS_ChannelFlags(HeadsetStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);

      BASS_ChannelSetAttribute(HeadsetStream, BASS_ATTRIB_VOL, fHeadSetVolume);
      Bass_ChannelPlay(HeadsetStream, True);

      fHeadsetFileEndSyncHandle := Bass_ChannelSetSync(HeadsetStream,
                    BASS_SYNC_END, 0,
                    @EndHeadSetFileProc, Self);


      Bass_SetDevice(MainDevice);
      ActualizePlayPauseBtn(NEMP_API_PLAYING, 1);
  end;

  // get the cover for the current Headset-File
  RefreshHeadsetCoverBitmap;
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

function TNempPlayer.GetBirthdayVolume: Single;
begin
    result := fBirthdayVolume * 100;
end;

procedure TNempPlayer.SetBirthdayVolume(Value: Single);
begin
    Value := Value / 100;
    if Value < 0 then Value := 0;
    if Value > 1 then Value := 1;
    fBirthdayVolume := Value;
    BASS_ChannelSetAttribute(CountDownStream, BASS_ATTRIB_VOL, fBirthdayVolume);
    BASS_ChannelSetAttribute(BirthdayStream, BASS_ATTRIB_VOL, fBirthdayVolume);
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
function TNempPlayer.GetTimeString: String;
begin
    Case TimeMode of
        0: result := SecToStr(Time);
        1: result := '-' + SecToStr(Dauer - Time );
    end;
end;

function TNempPlayer.fGetSeconds;
begin
    result := Round(Time + 0.5);
end;

function TNempPlayer.fGetSecondsHeadset: Integer;
begin
    result := Round(HeadsetTime + 0.5);
end;

function TNempPlayer.GetTimeStringHeadset: String;
begin
    Case TimeMode of
        0: result := SecToStr(HeadsetTime);
        1: result := '-' + SecToStr(HeadsetDauer - HeadsetTime );
    end;
end;

(*
function TNempPlayer.fGetPlayerLine1: UnicodeString;
begin
    if not assigned(MainAudioFile) then
        result := ''
    else
    begin
        // get a proper display string for the player
        // 1st line (in most cases: "Artist")
        case MainAudioFile.AudioType of
            at_Undef: result := '';
            at_File,
            at_CDDA: begin
                    if assigned(MainAudioFile.CueList) and (MainAudioFile.CueList.Count > 0) then
                    begin
                        // when playing a file with a cuesheet:
                        // MainTitle + CueSheet-Title
                        result := NempDisplay.PlaylistTitle(MainAudioFile);//.PlaylistTitle;
                    end else
                    begin
                        // usual case: just the "Artist"
                        if MainAudioFile.Artist <> '' then
                            result := MainAudioFile.Artist
                        else
                            result := Player_UnkownArtist;
                    end;
            end;

            at_Stream: begin
                    if (MainAudioFile.artist <> '') and (MainAudioFile.titel <> '') then  // could be the case on remote ogg-files (through "DoOggMeta")
                        result := MainAudioFile.Artist
                    else
                        result := MainAudioFile.Description;
            end;
        else
            // at_CUE should not happen here
            result := '';
        end;
    end;
end;

function TNempPlayer.fGetPlayerLine2: UnicodeString;
begin
    if not assigned(MainAudioFile) then
        result := ''
    else
    begin
        // get a proper display string for the player
        // 2nd line (in most cases: "Title")
        case MainAudioFile.AudioType of
            at_Undef  : result := '';
            at_File,
            at_CDDA   : begin
                    if assigned(MainAudioFile.CueList) and (MainAudioFile.CueList.Count > 0) then
                        // when playing a file with a cuesheet:
                        // "MainTitle + CueSheet-Title"
                        // note: there should be no issue with the cuesheet-index here, as GetIndex runs through the CueList
                        result := NempDisplay.PlaylistTitle(MainAudioFile.CueList[GetActiveCueIndex])
                    else
                        // usual case: just the "Title"
                        result := MainAudioFile.NonEmptyTitle;
            end;
            at_Stream : begin
                        result := MainAudioFile.Titel
            end
        else
            //at_CUE should not happen here
            result := '';
        end;
    end;
end;
*)

function TNempPlayer.GetCurrentAudioFile: TPlaylistFile;
begin
  result := Nil;
  if assigned(MainAudioFile) and assigned(MainAudioFile.CueList) then
    result := self.GetActiveCue;

  if not assigned(result) then
    result := MainAudioFile;
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

function TNempPlayer.GetAvoidMickyMausEffect: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fAvoidMickyMausEffect));
end;

procedure TNempPlayer.SetAvoidMickyMausEffect(aValue: LongBool);
begin
    InterLockedExchange(Integer(fAvoidMickyMausEffect), Integer(aValue));
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

procedure TNempPlayer.ApplyReplayGainToStream(aStream: DWord; aAudioFile: TAudioFile);
var localRGVolume: BASS_BFX_VOLUME;
    rgHandle: HFX;
    localPeak, aGain: Double;

begin
    if not ApplyReplayGain then
        // do nothing
        exit;

    aGain := 0;
    localPeak := 1;

    if PreferAlbumGain then
    begin
        aGain := aAudioFile.AlbumGain;
        localPeak := aAudioFile.AlbumPeak;
    end;

    if IsZero(aGain) then
    begin
        aGain := aAudioFile.TrackGain;
        localPeak := aAudioFile.TrackPeak;
    end;

    // this should not happen, as the default peak should be set to 1, not zero.
    // however, to be sure:
    if isZero(localPeak) then
        localPeak := 1;

    if isZero(aGain) then
        // No replayGain-Value available, use only pre-amp
        aGain := fDefaultGainWithoutRG
    else
        // replayGain value available,
        // add pre-amp
        aGain := aGain + fDefaultGainWithRG;

    if not isZero(aGain) then
    begin
        rgHandle := BASS_ChannelSetFX(astream, BASS_FX_BFX_VOLUME, 1);
        localRGVolume.lChannel := 0;
        if fPreventClipping then
            localRGVolume.fVolume := min(power(10, aGain/20),  1/localPeak)
        else
            localRGVolume.fVolume := power(10, aGain/20);
        BASS_FXSetParameters(rgHandle, @localRGVolume);
    end;
end;

procedure TNempPlayer.Flutter(aValue: single; t: Integer);
begin
    if fIsURLStream then exit;
    if aValue > 3 then aValue := 3;
    if aValue < 0.33 then aValue := 0.33;

    if MainStreamIsTempoStream then
    begin
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_TEMPO, aValue * 100 - 100, t);
        BASS_ChannelSlideAttribute(SlideStream, BASS_ATTRIB_TEMPO, aValue * 100 - 100, t);
    end else
    begin
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * aValue, t);
        BASS_ChannelSlideAttribute(SlideStream, BASS_ATTRIB_FREQ, OrignalSamplerate * aValue, t);
    end;
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
      NewCueIdx := GetActiveCueIndex;//(MainAudioFile, Bass_ChannelBytes2Seconds(NempPlayer.mainstream,Bass_ChannelGetPosition(NempPlayer.mainstream)) + 0.5 );

      // altes Sync-Handle entfernen
      BASS_ChannelRemoveSync(mainstream, fCueSyncHandleM);
      BASS_ChannelRemoveSync(mainstream, fCueSyncHandleS);

      // das auch??     z
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
var silencepos, syncposFading: LongWord;
begin

    // ruhig die Dauer des mainstreams nehmen - sonst is eh was verkehrt ;-)
    if fSilenceDetected then
    begin
        syncposFading := Bass_ChannelSeconds2Bytes(mainstream, fSilenceStart - (FadingInterval / 1000));
        silencepos := Bass_ChannelSeconds2Bytes(mainstream, fSilenceStart);
    end
    else
    begin
        syncposFading := Bass_ChannelSeconds2Bytes(mainstream, Dauer - (FadingInterval / 1000));
        silencepos := 0;
    end;

    if dest = Mainstream then
    begin
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleM); //then
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleM);
          BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleS);
          BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleS);
          BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleM);
          BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleS);
          // Sync im Mainstream setzen
          if UseFading And fReallyUsefading
                AND (Dauer > FadingInterval DIV 200)
                AND (Not MainStreamIsReverseStream)
          then
              fFileNearEndSyncHandleM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_POS, syncposFading,
                    @EndFileProc, Self)
          else
          begin
              // no fading, so set sync at the beginning of silence (if detected)
              if fSilenceDetected then
                  fSilenceBeginSyncHandleM := Bass_ChannelSetSync(MainStream,
                      BASS_SYNC_POS, silencepos,
                      @EndFileProc, Self)
          end;
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
          BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleS);
          // Sync im SlideStream setzen
          if UseFading And fReallyUsefading
              AND (Dauer > FadingInterval DIV 200)
              AND (Not MainStreamIsReverseStream)
          then
              fFileNearEndSyncHandleS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_POS, syncposFading,
                    @EndFileProc, Self)
          else
          begin
              // no fading, so set sync at the beginning of silence (if detected)
              if fSilenceDetected then
                  fSilenceBeginSyncHandleS := Bass_ChannelSetSync(SlideStream,
                      BASS_SYNC_POS, silencepos,
                      @EndFileProc, Self)
          end;

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
          BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleM);
          BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleS);
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
          BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleM);
          BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleS);
         // Sync im SlideStream setzen
         fFileEndSyncHandleS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_END, 0,
                    @StopPlaylistProc, Self);
    end;
    SendMessage(MainWindowHandle, WM_ChangeStopBtn, 1, 0);
    fStopStatus := PLAYER_STOP_AFTERTITLE;
end;

procedure TNempPlayer.SetABSyncs(p1, p2: Double);
var tmp: Double;
    syncpos: LongWord;
    ByteLength: LongWord;

begin

    ByteLength := BASS_ChannelGetLength(Mainstream, BASS_POS_BYTE);
    if ByteLength > 0 then
    begin
        if p2 = -1 then
        begin
            // get automatic p2: p1 + 10 seconds
            //t1 := BASS_ChannelBytes2seconds(MainStream,
            //      Round(ByteLength * p1)) + 10;
            //SyncPos := BASS_ChannelSeconds2bytes(MainStream, t1);
            //if SyncPos > ByteLength then
            //    SyncPos := ByteLength;
            //fABRepeatEndPosition := SyncPos / ByteLength;
            //
            // change 2019: set it just to the end of the file  as default
            fABRepeatEndPosition := 0.999;
            SyncPos := (Round(ByteLength * p2));
        end else
        begin
            if p1 > p2 then
            begin
                // swap
                tmp := p1;
                p1 := p2;
                p2 := tmp;
            end;
            if p2 > 0.999 then
                p2 := 0.999;
            fABRepeatEndPosition := p2;
            SyncPos := (Round(ByteLength * p2));
        end;
        fABRepeatStartPosition := p1;
        fABRepeatActive := True;
    end else
    begin
        SyncPos := 0;
        fABRepeatStartPosition := 0;
        fABRepeatEndPosition := 0;
        fABRepeatActive := False;
    end;

    RemoveEndSyncs; // no automatic title change in AB-repeat mode
    // delete old AB Syncs
    ClearABSyncs;

    if fABRepeatActive then
    begin
        fABRepeatSyncM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_POS, SyncPos,
                    @ABRepeatProc, Self);
        fABRepeatSyncS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_POS, SyncPos,
                    @ABRepeatProc, Self);
    end;
end;

procedure TNempPlayer.SetASync(p1: Double);
var ByteLength: Integer;
begin
    if p1 < 0 then p1 := 0;
    if p1 > 0.999 then p1 := 0.999;

    ByteLength := BASS_ChannelGetLength(Mainstream, BASS_POS_BYTE);
    if ByteLength > 0 then
    begin
        // Start position is here
        fABRepeatStartPosition := p1;
        fABRepeatActive := True;

        if fABRepeatEndPosition < fABRepeatStartPosition then
        begin
            // the new Start-Positon is after the current End-Position
            // (or B is not set yet)
            SetBSync(0.999);
            fABRepeatEndPosition := 0.999;
            // old version
            // so, remove AB syncs (if necessary)
            //ClearABSyncs;
            // and
            //fABRepeatEndPosition := p1;
        end;
    end else
    begin
        // otherwise the channel is invalid
        fABRepeatStartPosition := 0;
        fABRepeatEndPosition := 0;
        fABRepeatActive := False;
    end;
end;


procedure TNempPlayer.SetBSync(p1: Double);
var ByteLength: Integer;
    SyncPos: LongWord;
begin
    if p1 < 0 then p1 := 0;
    if p1 > 0.999 then p1 := 0.999;

    ByteLength := BASS_ChannelGetLength(Mainstream, BASS_POS_BYTE);
    if ByteLength > 0 then
    begin
        // Channel is valid
        fABRepeatEndPosition := p1;
        fABRepeatActive := True;
        if fABRepeatStartPosition > fABRepeatEndPosition then
        begin
            //SetASync(0);
            fABRepeatStartPosition := 0;
            //(sync hier auch neu setzen???)


            //ClearABSyncs;
            //fABRepeatStartPosition := p1;
        end else
        begin
            // clear old syncs
            ClearABSyncs;

            // no automatic title change in AB-repeat mode
            RemoveEndSyncs;

            // set new syncs
            SyncPos := Round(fABRepeatEndPosition * ByteLength);
            fABRepeatSyncM := Bass_ChannelSetSync(MainStream,
                    BASS_SYNC_POS, SyncPos,
                    @ABRepeatProc, Self);
            fABRepeatSyncS := Bass_ChannelSetSync(SlideStream,
                    BASS_SYNC_POS, SyncPos,
                    @ABRepeatProc, Self);
            // and start loop
            Progress := fABRepeatStartPosition;
            // refresh Cue stuff
            SendMessage(MainWindowHandle, WM_NextCue, 0, 0);
        end;
    end else
    begin
        fABRepeatStartPosition := 0;
        fABRepeatEndPosition := 0;
        fABRepeatActive := False;
    end;
end;

procedure TNempPlayer.ClearABSyncs;
begin
    BASS_ChannelRemoveSync(MainStream, fABRepeatSyncM);
    BASS_ChannelRemoveSync(MainStream, fABRepeatSyncS);
    BASS_ChannelRemoveSync(SlideStream, fABRepeatSyncM);
    BASS_ChannelRemoveSync(SlideStream, fABRepeatSyncS);
end;

procedure TNempPlayer.RemoveABSyncs;
begin
    ClearABSyncs;
    SetEndSyncs(MainStream);
    SetEndSyncs(SlideStream);
    fABRepeatActive := False;
    fABRepeatEndPosition := 0;
    fABRepeatStartPosition := 0;
end;

procedure TNempPlayer.RemoveEndSyncs;
begin
    BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleM);
    BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleM);
    BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleS);
    BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleS);
    BASS_ChannelRemoveSync(SlideStream, fFileNearEndSyncHandleM);
    BASS_ChannelRemoveSync(SlideStream, fFileEndSyncHandleM);
    BASS_ChannelRemoveSync(MainStream, fFileNearEndSyncHandleS);
    BASS_ChannelRemoveSync(MainStream, fFileEndSyncHandleS);
    BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleM);
    BASS_ChannelRemoveSync(MainStream, fSilenceBeginSyncHandleS);
    BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleM);
    BASS_ChannelRemoveSync(SlideStream, fSilenceBeginSyncHandleS);
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
function TNempPlayer.GetActiveCueIndex: Integer;
var i:Integer;
    aPos: Double;
begin
  result := 0;
  aPos := self.Time + 0.5;// evtl. + 0.5;?? hatte ich früher so1 Ja !! Sonst: Probleme mit der Aktualisierung bei Doppelklick auf einen Eintrag (also: wenn der dann abgelaufen ist)
  if assigned(MainAudioFile) AND assigned(MainAudioFile.CueList) AND ((MainAudioFile.CueList).Count > 0) then
  begin
      i := MainAudioFile.CueList.Count - 1;
      while (i > 0) AND (MainAudioFile.CueList[i].Index01 >= aPos) do
          dec(i);
      result := i;
  end;
end;

function TNempPlayer.GetActiveCue: TAudioFile;
begin
  if assigned(MainAudioFile) AND assigned(MainAudioFile.CueList) AND ((MainAudioFile.CueList).Count > 0) then
      result := MainAudioFile.CueList[GetActiveCueIndex]
  else
      result := Nil;
end;

// jump to next/previous cue.
// result = false: There is no next cue, so playlist should jump to the next track
function TNempPlayer.JumpToNextCue: Boolean;
var NextCueIdx: Integer;
begin
  NextCueIdx := GetActiveCueIndex + 1;
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
    if assigned(MainAudioFile) and assigned(MainAudioFile.CueList) and (MainAudioFile.CueList.Count > 0)  then
    begin
        // we have a MainAudioFile and we have a (valid) cuelist
        // determine, where we are right now
        CurrentCueIdx := GetActiveCueIndex;
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

function TNempPlayer.GenerateTaskbarTitel: UnicodeString;
begin
  if NOT assigned(MainAudioFile) then
      result := NEMP_NAME_TASK
  else
  begin
      result := NempDisplay.PlaylistTitle(MainAudioFile);
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



procedure TNempPlayer.DrawHeadsetVisualisation;
var FFTFata : TFFTData;
begin
    if UseVisualization then
    begin
        if BassHeadSetStatus = BASS_ACTIVE_PLAYING then
        begin
            BASS_ChannelGetData(HeadsetStream, @FFTFata, BASS_DATA_FFT1024);
            Spectrum.Draw (FFTFata);
        end else
            Spectrum.DrawClear;
    end;
end;

procedure TNempPlayer.DrawMainPlayerVisualisation; //(IncludingTime: Boolean = True);
var FFTFata : TFFTData;
begin

    if UseVisualization then
    begin
        if BassStatus = BASS_ACTIVE_PLAYING then
        begin
            BASS_ChannelGetData(MainStream, @FFTFata, BASS_DATA_FFT1024);
            Spectrum.Draw (FFTFata);
        end else
        begin
            Spectrum.DrawClear;
        end;
    end;
end;

(*
procedure TNempPlayer.DrawTimeFromProgress(aProgress: Single);
var tmpTime: Integer;
begin
    tmpTime :=  Round(Dauer * aProgress);
    Case TimeMode of
      0: Spectrum.DrawTime(SecToStr(tmpTime));
      1: Spectrum.DrawTime('-' + SecToStr(Dauer - tmpTime ));
    end;
end;

procedure TNempPlayer.DrawHeadsetTimeFromProgress(aProgress: Single);
var tmpTime: Integer;
begin
    tmpTime :=  Round(HeadsetDauer * aProgress);
    Case TimeMode of
      0: Spectrum.DrawTime(SecToStr(tmpTime));
      1: Spectrum.DrawTime('-' + SecToStr(Dauer - tmpTime ));
    end;
end;
*)

function TNempPlayer.GetTimeStringFromProgress(aProgress: Single) : String;
var tmpTime: Integer;
begin
    tmpTime :=  Round(Dauer * aProgress);
    case TimeMode of
        0: result := SecToStr(tmpTime);
        1: result := '-' + SecToStr(Dauer - tmpTime )
    end;

end;

function TNempPlayer.GetHeadsetTimeStringFromProgress(aProgress: Single) : String;
var tmpTime: Integer;
begin
    tmpTime :=  Round(HeadsetDauer * aProgress);
    case TimeMode of
        0: result := SecToStr(tmpTime);
        1: result := '-' + SecToStr(Dauer - tmpTime );
    end;
end;


function TNempPlayer.RefreshCoverBitmap: Boolean;
begin
    result := True;
    MainPlayerPicture.Bitmap.Width := NEMP_PLAYER_COVERSIZE;
    MainPlayerPicture.Bitmap.Height := NEMP_PLAYER_COVERSIZE;

    if assigned(MainAudioFile) then
    begin
        result := CoverArtSearcher.GetCover_Complete(MainAudioFile, MainPlayerPicture)
        // GetCover(MainAudioFile, MainPlayerPicture, True)
    end else
        CoverArtSearcher.GetDefaultCover(dcFile, MainPlayerPicture, 0);
        //result := True; // no audiofile, no downloading. ;-)
end;

function TNempPlayer.RefreshHeadsetCoverBitmap: Boolean;

        procedure LoadHeadSetGraphic;
        var fn: String;
        begin
            fn := ExtractFilePath(ParamStr(0)) + 'Images\default_cover_headphone.png';
            if FileExists(fn) then
                HeadsetPicture.LoadFromFile(fn);
        end;
begin
    result := True;
    HeadsetPicture.Bitmap.Width := NEMP_PLAYER_COVERSIZE;
    HeadsetPicture.Bitmap.Height := NEMP_PLAYER_COVERSIZE;

    LoadHeadSetGraphic;

    exit;

    { // note, do not show proper Cover in HeadsetControls? or do it?
    if assigned(HeadSetAudioFile) then
    begin
        result := GetCover(HeadSetAudioFile, HeadsetPicture, True);
        if not result then
            LoadHeadSetGraphic;
    end else
    begin
        LoadHeadSetGraphic;
        result := False;
    end;
    }
end;

procedure TNempPlayer.DrawPreviewNew( DestWidth : Integer; DestHeight : Integer;
                            destBitmap: TBitmap; SkinActive : Boolean = True);
var
  h,pw  : Integer;
  s: String;
  r: TRect;
begin

        destBitmap.Width := 200; // DestWidth; // 200;
        destBitmap.Height := 100; // DestHeight; // 100;

        destBitmap.PixelFormat := pf32bit;

        destBitmap.Canvas.Pen.Color := clBtnFace;
        destBitmap.Canvas.Brush.Style := bsSolid;
        destBitmap.Canvas.Brush.Color := clBtnFace;
        destBitmap.Canvas.Rectangle(0, 0, destBitmap.Width, destBitmap.Height);

        if SkinActive then
        begin
            //destBitmap.Canvas.Draw(0,0, PreviewBackGround);

            SetStretchBltMode(destBitmap.Canvas.Handle, HALFTONE);
            StretchBlt(destBitmap.Canvas.Handle, 0, 0, //5 + 45 - (MainPlayerPicture.Height Div 4),
                  //MainPlayerPicture.Width Div 2, MainPlayerPicture.Height Div 2,
                  PreviewBackGround.Width , PreviewBackGround.Height ,
                  PreviewBackGround.Canvas.Handle, 0,0 ,
                  PreviewBackGround.Width, PreviewBackGround.Height,
                  SRCCOPY);
        end;

        if (not assigned(MainAudioFile)) and (not fDefaultCoverIsLoaded) then
        begin
            fDefaultCoverIsLoaded := True;
            RefreshCoverBitmap;
        end;

        SetStretchBltMode(destBitmap.Canvas.Handle, HALFTONE);
        StretchBlt(destBitmap.Canvas.Handle, 6, 6, //5 + 45 - (MainPlayerPicture.Height Div 4),
                  //MainPlayerPicture.Width Div 2, MainPlayerPicture.Height Div 2,
                  MainPlayerPicture.Bitmap.Width , MainPlayerPicture.Bitmap.Height ,
                  MainPlayerPicture.Bitmap.Canvas.Handle, 0,0 ,
                  MainPlayerPicture.Bitmap.Width, MainPlayerPicture.Bitmap.Height,
                  SRCCOPY);

        if assigned(MainAudioFile) then
        begin
            fDefaultCoverIsLoaded := False;
            destBitmap.Canvas.Brush.Style := bsClear;
            destBitmap.Canvas.Font.Size := 8;
            destBitmap.Canvas.Font.Style := [];

            if Not UnKownInformation(MainAudioFile.Artist) then
            begin
                s := StringReplace(NempDisplay.GetNonEmptyTitle(MainAudioFile),'&','&&',[rfReplaceAll]);
                r := Rect(102, 4, 198, 70);
                destBitmap.Canvas.TextRect(r, s, [tfWordBreak, tfCalcRect]);
                // get needed Height of the Artist-String
                h := r.Bottom - r.Top;
                if h > 39 then
                    h := 39;

                // but draw 3 lines maximum
                destBitmap.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 43);
                destBitmap.Canvas.TextRect(r, s, [tfWordBreak]);

                s := StringReplace(MainAudioFile.Artist,'&','&&',[rfReplaceAll]);
                destBitmap.Canvas.Font.Color := Spectrum.PreviewArtistColor;
                r := Rect(102, 4 + h, 198, 70);
                destBitmap.Canvas.TextRect(r, s, [tfWordBreak]);
               // b.Canvas.TextOut(102,6, MainAudioFile.Artist);
               // b.Canvas.TextOut(102,20, MainAudioFile.Titel);
               destBitmap.Canvas.Font.Color := Spectrum.PreviewTimeColor;
               if MainAudioFile.isStream then
                  destBitmap.Canvas.TextOut(102,72, '(Webradio)')
               else
                   destBitmap.Canvas.TextOut(102,72, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );

            end else
            begin
                // just the title
                s := StringReplace(NempDisplay.GetNonEmptyTitle(MainAudioFile),'&','&&',[rfReplaceAll]);
                destBitmap.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 70);
                destBitmap.Canvas.TextRect(r, s, [tfWordBreak]);
                destBitmap.Canvas.Font.Color := Spectrum.PreviewTimeColor;
                if MainAudioFile.isStream then
                    destBitmap.Canvas.TextOut(102,72, '(Webradio)')
                else
                    destBitmap.Canvas.TextOut(102,72, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );
            end;

            // Draw progress
            if MainAudioFile.isStream then
            begin
                {
                b.canvas.Pen.color := Spectrum.PreviewShapePenColor;
                b.Canvas.Pen.Width := 1;
                b.Canvas.Brush.Color := Spectrum.PreviewShapeBrushColor;
                b.Canvas.Brush.Style := bsSolid;
                pw := 88;
                b.Canvas.Rectangle(102, 80, 102+pw, 86 );
                }
            end else
            begin

                destBitmap.canvas.Pen.color := Spectrum.PreviewShapePenColor;
                destBitmap.Canvas.Pen.Width := 1;
                destBitmap.Canvas.Brush.Color := Spectrum.PreviewShapeBrushColor;
                destBitmap.Canvas.Brush.Style := bsSolid;
                pw := 88;
                destBitmap.Canvas.Rectangle(102, 87, 102+pw, 93 );
                destBitmap.canvas.Pen.color :=   Spectrum.PreviewShapeProgressPenColor;
                destBitmap.Canvas.Brush.Color := Spectrum.PreviewShapeProgressBrushColor;
                destBitmap.Canvas.Rectangle(102, 87, 102 + round(Progress*pw), 93 );

            end;

        end else
        begin

        end;

end;


function TNempPlayer.DrawPreview( DestWidth : Integer; DestHeight : Integer;
                            SkinActive : Boolean = True) : HBITMAP;
var
  ddc   : HDC;
  dbmi  : BITMAPINFO;
  dBits : PInteger;
  h,pw  : Integer;
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
        StretchBlt(b.Canvas.Handle, 6, 6, //5 + 45 - (MainPlayerPicture.Height Div 4),
                  //MainPlayerPicture.Width Div 2, MainPlayerPicture.Height Div 2,
                  MainPlayerPicture.Bitmap.Width , MainPlayerPicture.Bitmap.Height ,
                  MainPlayerPicture.Bitmap.Canvas.Handle, 0,0 ,
                  MainPlayerPicture.Bitmap.Width, MainPlayerPicture.Bitmap.Height,
                  SRCCOPY);

        if assigned(MainAudioFile) then
        begin
            fDefaultCoverIsLoaded := False;
            b.Canvas.Brush.Style := bsClear;
            b.Canvas.Font.Size := 8;

            if Not UnKownInformation(MainAudioFile.Artist) then
            begin
                s := StringReplace(NempDisplay.GetNonEmptyTitle(MainAudioFile),'&','&&',[rfReplaceAll]);
                r := Rect(102, 4, 198, 70);
                b.Canvas.TextRect(r, s, [tfWordBreak, tfCalcRect]);
                // get needed Height of the Artist-String
                h := r.Bottom - r.Top;
                if h > 39 then
                    h := 39;

                // but draw 3 lines maximum
                b.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 43);
                b.Canvas.TextRect(r, s, [tfWordBreak]);

                s := StringReplace(MainAudioFile.Artist,'&','&&',[rfReplaceAll]);
                b.Canvas.Font.Color := Spectrum.PreviewArtistColor;
                r := Rect(102, 4 + h, 198, 70);
                b.Canvas.TextRect(r, s, [tfWordBreak]);
               // b.Canvas.TextOut(102,6, MainAudioFile.Artist);
               // b.Canvas.TextOut(102,20, MainAudioFile.Titel);
               b.Canvas.Font.Color := Spectrum.PreviewTimeColor;
               if MainAudioFile.isStream then
                  b.Canvas.TextOut(102,72, '(Webradio)')
               else
                   b.Canvas.TextOut(102,72, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );

            end else
            begin
                // just the title
                s := StringReplace(NempDisplay.GetNonEmptyTitle(MainAudioFile),'&','&&',[rfReplaceAll]);
                b.Canvas.Font.Color := Spectrum.PreviewTitleColor;
                r := Rect(102, 4, 198, 70);
                b.Canvas.TextRect(r, s, [tfWordBreak]);
                b.Canvas.Font.Color := Spectrum.PreviewTimeColor;
                if MainAudioFile.isStream then
                    b.Canvas.TextOut(102,72, '(Webradio)')
                else
                    b.Canvas.TextOut(102,72, SecToStr(Time) + ' (' + SecToStr(MainAudioFile.Duration) + ')'   );
            end;

            // Draw progress
            if MainAudioFile.isStream then
            begin
                {
                b.canvas.Pen.color := Spectrum.PreviewShapePenColor;
                b.Canvas.Pen.Width := 1;
                b.Canvas.Brush.Color := Spectrum.PreviewShapeBrushColor;
                b.Canvas.Brush.Style := bsSolid;
                pw := 88;
                b.Canvas.Rectangle(102, 80, 102+pw, 86 );
                }
            end else
            begin

                b.canvas.Pen.color := Spectrum.PreviewShapePenColor;
                b.Canvas.Pen.Width := 1;
                b.Canvas.Brush.Color := Spectrum.PreviewShapeBrushColor;
                b.Canvas.Brush.Style := bsSolid;
                pw := 88;
                b.Canvas.Rectangle(102, 87, 102+pw, 93 );
                b.canvas.Pen.color :=   Spectrum.PreviewShapeProgressPenColor;
                b.Canvas.Brush.Color := Spectrum.PreviewShapeProgressBrushColor;
                b.Canvas.Rectangle(102, 87, 102 + round(Progress*pw), 93 );

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


procedure TNempPlayer.ResetPlayerVCL(GetCoverWasSuccessful: boolean);
begin
  SendMessage(MainWindowHandle, WM_ResetPlayerVCL, wParam(GetCoverWasSuccessful), 0);
  // this leads to a call of ReInitPlayerVCL(GetCoverWasSuccessful: Boolean);
end;

procedure TNempPlayer.ActualizePlayPauseBtn(wParam, lParam: Integer);
begin
  SendMessage(MainWindowHandle, WM_ActualizePlayPauseBtn, wParam, lParam);
end;

 (*
{
    --------------------------------------------------------
    Birthday-settings
    --------------------------------------------------------
}
procedure TNempPlayer.WriteBirthdayOptions(aIniFilename: UnicodeString);
var ini: TMemIniFile;
begin
    EXIT ;
    ini := TMeminiFile.Create(aIniFilename, TEncoding.UTF8);
    try
        ini.Encoding := TEncoding.UTF8;
        Ini.WriteBool('Event', 'UseCountDown', NempBirthdayTimer.UseCountDown);
        Ini.WriteTime('Event', 'StartTime'            , NempBirthdayTimer.StartTime);
        // StartCountDownTime will be calculated when the event is activated
        // Ini.WriteTime('Event', 'StartCountDownTime'   , NempBirthdayTimer.StartCountDownTime);
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
  EXIT;
    ini := TMeminiFile.Create(aIniFilename, TEncoding.UTF8);
    try
        ini.Encoding := TEncoding.UTF8;
        NempBirthdayTimer.UseCountDown := Ini.ReadBool('Event', 'UseCountDown', True);
        NempBirthdayTimer.StartTime := Ini.ReadTime('Event', 'StartTime', 0 );
        // NempBirthdayTimer.StartCountDownTime := Ini.ReadTime('Event', 'StartCountDownTime',0);
        NempBirthdayTimer.BirthdaySongFilename := (Ini.ReadString('Event', 'BirthdaySongFilename', ''));
        NempBirthdayTimer.CountDownFileName := (Ini.ReadString('Event', 'CountDownFileName', ''));
        NempBirthdayTimer.ContinueAfter :=Ini.ReadBool('Event', 'ContinueAfter', True);

        showmessage(NempBirthdayTimer.BirthdaySongFilename);
    finally
      ini.Free
    end;
end;
*)

function TNempPlayer.GetCountDownLength(aFilename: UnicodeString): Integer;
var tmpstream: DWord;
    af: TAudioFile;
begin
    af := TAudioFile.Create;
    try
        af.Pfad := aFilename; // set path, determine AudioType

        tmpStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False,  // ReverseStream
                                 ps_Now
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

procedure TNempPlayer.PauseForBirthday;
begin
    if fIsURLStream then
        Stop
    else
    begin
        PostProcessor.PlaybackPaused;
        RemoveEndSyncs;
        //if UseFading AND fReallyUseFading
        //    AND NOT (IgnoreFadingOnShortTracks AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
        //    AND NOT IgnoreFadingOnPause
        //then
        BASS_ChannelSlideAttribute(MainStream, BASS_ATTRIB_VOL,-2,FadingInterval);
        //else
        //begin
        //  BASS_ChannelPause(MainStream);
        //end;
        fStatus := PLAYER_ISPAUSED;
        ActualizePlayPauseBtn(NEMP_API_PAUSED, 0);
    end;
end;

Procedure TNempPlayer.PlayCountDown; // Countdown abspielen mit setzen der Syncs
var af: TAudioFile;
begin
    af := TAudioFile.Create;
    try
        af.Pfad := NempBirthdayTimer.CountDownFileName; // set path, determine AudioType
        // read file information (needed for ReplayGain)
        af.GetAudioData(NempBirthdayTimer.CountDownFileName);

        CountDownStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False,  // ReverseStream
                                 ps_Now
                                 );
        BASS_ChannelFlags(CountDownStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);
          // Attribute setzen
        // BASS_ChannelSetAttribute(CountDownStream, BASS_ATTRIB_VOL, fMainVolume);
        // no. fading is better
        BASS_ChannelSetAttribute(CountDownStream, BASS_ATTRIB_VOL, 0);

        // apply ReplayGain, if wanted
        ApplyReplayGainToStream(CountDownStream, af);

        BirthdayCountDownSyncHandle :=
          Bass_ChannelSetSync(CountDownStream, BASS_SYNC_END, 0, @EndCountdownProc, self);

        BASS_ChannelPlay(CountDownStream, true);
        BASS_ChannelSlideAttribute(CountDownStream, BASS_ATTRIB_VOL, fBirthdayVolume, FadingInterval);

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
        // read file information (needed for ReplayGain)
        af.GetAudioData(NempBirthdayTimer.BirthdaySongFilename);

        BirthdayStream := NEMP_CreateStream(af,
                                 False, // kein Tempostream
                                 False,  // ReverseStream
                                 ps_Now
                                 );
        BASS_ChannelFlags(BirthdayStream, BASS_STREAM_AUTOFREE, BASS_STREAM_AUTOFREE);
        if NempBirthdayTimer.ContinueAfter then
            BirthdaySyncHandle :=
                Bass_ChannelSetSync(BirthdayStream, BASS_SYNC_END, 0, @EndBirthdayProc, self);

        // Attribute setzen
        BASS_ChannelSetAttribute(BirthdayStream, BASS_ATTRIB_VOL, 0);
        // apply ReplayGain, if wanted
        ApplyReplayGainToStream(BirthdayStream, af);

        BASS_ChannelPlay(BirthdayStream, true);
        BASS_ChannelSlideAttribute(BirthdayStream, BASS_ATTRIB_VOL, fBirthdayVolume, FadingInterval);
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
        aTitel := ReplaceForbiddenFilenameChars(NempDisplay.GetNonEmptyTitle(MainAudioFile))
     else
        aTitel := ReplaceForbiddenFilenameChars(MainAudioFile.Artist + ' - ' + NempDisplay.GetNonEmptyTitle(MainAudioFile));

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

procedure TNempPlayer.StartSilenceDetection;
var aSilenceDetector: TSilenceDetector;
begin
    if assigned(MainAudioFile)
        and (MainStream <> 0)
        and (Bass_ChannelBytes2Seconds(MainStream, Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) >= 2)
    then
    begin
        aSilenceDetector := TSilenceDetector.Create(MainWindowHandle, MainAudioFile.Pfad);
        try
            aSilenceDetector.GetSilenceLength(fSilenceThreshold);
        finally
            // dont free it, there is a secondary Thread running!
        end;
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


procedure DoPrescan(aPlayer: TNempPlayer);
var aFile: TAudioFile;
    c: Integer;
begin
    aFile := TAudioFile.Create;
    try
        repeat
            // get last Element in Prescan-List (others are not needed any more)
            EnterCriticalSection(CSPrescanList);
            c := aPlayer.fPrescanFiles.Count;
            if c > 0 then
                aFile.Assign(aPlayer.fPrescanFiles[c-1]);
            aPlayer.fPrescanFiles.Clear;
            LeaveCriticalSection(CSPrescanList);

            //sleep(2000);

            BASS_SetDevice(aPlayer.MainDevice);

            //aPlayer.ThreadedMainStream  := aPlayer.NEMP_CreateStream(aFile, false, false, ps_now);
            //aPlayer.ThreadedSlideStream := aPlayer.NEMP_CreateStream(aFile, false, false, ps_now);
            // bugfix März 2016: mp3s mit "No-Micky-Maus" laufen falsch.
            aPlayer.ThreadedMainStream  := aPlayer.NEMP_CreateStream(aFile, aPlayer.AvoidMickyMausEffect , false, ps_now);
            aPlayer.ThreadedSlideStream := aPlayer.NEMP_CreateStream(aFile, aPlayer.AvoidMickyMausEffect, false, ps_now);

            c := SendMessage(aPlayer.MainWindowHandle, WM_PlayerPrescanComplete, wParam(aFile), 0);
        until c = 0;
    finally
        aFile.Free;
    end;
end;

procedure TNempPlayer.StartPrescanThread;
var FileCopy: TAudioFile;
    Dummy: Cardinal;
begin
    if assigned(MainAudioFile) and MainAudioFile.IsFile then
    begin
        FileCopy := TAudioFile.Create;
        FileCopy.Assign(MainAudioFile);

        EnterCriticalSection(CSPrescanList);
        fPrescanFiles.Add(FileCopy);
        LeaveCriticalSection(CSPrescanList);

        if not fPrescanInProgress then
        begin
            fPrescanInProgress := True;
            CloseHandle(BeginThread(Nil, 0, @DoPrescan, Self, 0, Dummy));
        end;
    end;
end;

// This runs in VCL
function TNempPlayer.SwapStreams(ScannedFile: TAudioFile): Integer;
var oldMain, oldSlide: Dword;
    oldVol: Single;
    oldPosition: QWord;
begin

    EnterCriticalSection(CSPrescanList);
    result := fPrescanFiles.Count;
    LeaveCriticalSection(CSPrescanList);

    if result = 0 then
    begin
        if (not assigned(MainAudioFile))
           or (ScannedFile.Pfad <> MainAudioFile.Pfad)
        then
            result := -1;
    end;

    if result = 0 then
    begin
        oldMain  := MainStream;
        oldSlide := SlideStream;

        if MainStreamIsTempoStream then
        begin
            BASS_ChannelSetAttribute(ThreadedMainStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100);
            BASS_ChannelSetAttribute(ThreadedSlideStream, BASS_ATTRIB_TEMPO, fSampleRateFaktor * 100 - 100);
        end
        else
        begin
            BASS_ChannelSetAttribute(ThreadedMainStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
            BASS_ChannelSetAttribute(ThreadedSlideStream, BASS_ATTRIB_FREQ, OrignalSamplerate * fSampleRateFaktor);
        end;

        InitStreamEqualizer(ThreadedMainStream);
        InitStreamEqualizer(ThreadedSlideStream);

        ApplyReplayGainToStream(ThreadedMainStream, MainAudioFile);
        ApplyReplayGainToStream(ThreadedSlideStream, MainAudioFile);

        // Set Volume
        //if UseFading AND fReallyUseFading
        //            AND NOT (IgnoreFadingOnShortTracks
        //                      AND (Bass_ChannelBytes2Seconds(MainStream,Bass_ChannelGetLength(MainStream, BASS_POS_BYTE)) < FadingInterval DIV 200))
        //then
        begin
            BASS_ChannelGetAttribute(MainStream, BASS_ATTRIB_VOL, oldVol);
            BASS_ChannelSetAttribute(ThreadedMainStream, BASS_ATTRIB_VOL, oldVol);
        end;

        //Set Position
        oldPosition := BASS_ChannelGetPosition(MainStream, BASS_POS_BYTE);
        BASS_ChannelSetPosition(ThreadedMainStream, oldPosition, BASS_POS_BYTE);

        MainStream := ThreadedMainStream;
        if Status = PLAYER_ISPLAYING then
            Bass_ChannelPlay(MainStream, False);
        BASS_ChannelStop(oldMain);
        if fMainVolume <> 0 then
            BASS_ChannelSlideAttribute (ThreadedMainStream,
                      BASS_ATTRIB_VOL, fMainVolume,
                      Round((fMainVolume - oldVol)/(fMainVolume) * FadingInterval));
        BASS_StreamFree(oldMain);

        SlideStream := ThreadedSlideStream;
        BASS_ChannelStop(oldSlide);
        BASS_StreamFree(oldSlide);

        SetCueSyncs;
        SetEndSyncs(MainStream);
        SetEndSyncs(SlideStream);
        SetSlideEndSyncs;

        fPrescanInProgress := False;

        // todo: Controls enable/Disable
        // Dauer korrigieren in VCL??
    end;
end;


initialization

  InitializeCriticalSection(CSPrescanList);

finalization

  DeleteCriticalSection(CSPrescanList);

end.
