{

    Unit NempReplayGainCalculation

    - Calculate ReplayGainValues with external DLL

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
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

unit NempReplayGainCalculation;

interface

uses
  Winapi.Windows, System.Classes, System.Contnrs, System.SysUtils, math, Generics.Collections, Generics.Defaults,
  NempAudioFiles, Nemp_ConstantsAndTypes, ReplayGain, bass;

const

    SampleBufferSize = 16384; //4096;

    // some error Values
    RG_ERR_None                  = 0; // everything is ok :)

    // I do not start with 1, so theses codes differ from the BASS ErrorCodes
    RG_ERR_TooManyChannels       = 101;  // The audiostream contains more than 2 channels
    RG_ERR_InitGainAnalysisError = 102;  // error from the original ReplayGain-Unit,
                                         // probably the samplerate of the audiostream is not supported
    RG_ERR_AlbumGainFreqChanged  = 103;  // the list of audiofiles contains different samplerates
                                         // in that case, calculation of AlbumGain is not possible and will be skipped
                                         // at the end of the method CalculateAlbumGain

type

    TNempReplayGainCalculator = class;

    TRGCalculationMode = (RG_Calculate_SingleTracks, RG_Calculate_SingleAlbum, RG_Calculate_MultiAlbums, RG_Delete_ReplayGainValues);

    TRGStatus = ( RGStatus_StartCalculationSingleTracks,
                  RGStatus_StartCalculationSingleAlbum,
                  RGStatus_StartCalculationMultiAlbum,
                  RGStatus_StartSync,
                  RGStatus_StartDeleteValues,
                  RGStatus_Finished );


    TRGNotifyEvent       = Procedure(aReplayGainCalculator: TNempReplayGainCalculator; ErrorCode: Integer) of Object;
    TRGProgressEvent     = Procedure(aReplayGainCalculator: TNempReplayGainCalculator; aProgress: Single) of Object;
    TRGCompleteEvent     = Procedure(aReplayGainCalculator: TNempReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: Double) of Object;
    TRGMainProgressEvent = Procedure(aReplayGainCalculator: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus) of Object;

    TRGAudioFileSynchEvent = Procedure(aFile: TAudioFile; aTrackGain, aAlbumGain, aTrackPeak, aAlbumPeak: Double) of Object;

  // internal Data for preparing the TRGOverallProgressEvent
  TMainProgressData = record
      AlbumName: String;
      FileCount: Integer;
      Progress: TRGStatus;
  end;

  TGainData = record
      Gain: Double;
      Peak: Double;
  end;

  TMonoSample = Single; // 32Bit values

  TStereoSample = record
      Left:  single; // 32Bit values
      Right: single; // 32Bit values
  end;


  TNempReplayGainCalculator = class(TThread)
  private
      { Private declarations }
      fAudioFiles: TAudioFileList;
      fPaths     : TStringList;
      fAlbums    : TStringList;
      // For automatic Multi-Album-Calculation
      fCurrentAlbumList: TStringList;

      //
      fUseAudioFileCopies : Boolean;

      fLeftSamples:  array[0..SampleBufferSize-1] of TFloat;
      fRightSamples: array[0..SampleBufferSize-1] of TFloat;

      fStereoBuffer: array[0..SampleBufferSize-1] of TStereoSample;
      fMonoBuffer  : array[0..SampleBufferSize-1] of TMonoSample;

      fStream: HSTREAM;

      ///  some properties about the current track//stream
      ///  can be accessed in the fOnStreamInit-Event to display some more info about the track
      fChannelLength    : Int64;
      fChannelCount     : Cardinal;
      fChannelFreq      : Cardinal;
      fCurrentFilename  : UnicodeString;

      //
      fLastGainInitFreq : Cardinal;


      fAlbumGainCalculationFailed: Boolean;
      fSomeCalculationsDone: Boolean;

      ///  internal variables for ReplayGain Calculation
      ///  access through parameters in the OnComplete-Events
      fTrackPeak: TFloat; //SmallInt;
      fAlbumPeak: TFloat; //SmallInt;
      fTrackGain: TFloat;
      fAlbumGain: TFloat;

      ///  the last ErrorCode
      ///  access through prarmeter in the OnError-Event
      fLastErrorCode: Integer;

      ///  For AlbumGain it makes sense to calculate all TrackGains of an Album
      ///  before Updating the MetaData and the AudioFile-Objects
      ///  In this array all TrackGAin-Values for the current Album are stored
      ///  access indirectly throught the parameter of the OnSynchAudioFile-Event
      fCurrentTrackGains: Array of TGainData;

      ///  a little record with some data for the OnMainProgress-Event
      fMainProgressData : TMainProgressData;

      ///  Eventhandlers
      ///  See comments below in the property-section
      fOnStreamInit          : TRGNotifyEvent;
      fOnError               : TRGNotifyEvent;
      fOnTrackProgress       : TRGProgressEvent;
      fOnTrackComplete       : TRGCompleteEvent;
      fOnAlbumComplete       : TRGCompleteEvent;
      ///  ... and some additional Eventhandlers
      fOnWriteMetaDataProgress: TRGProgressEvent;
      fOnMainProgress         : TRGMainProgressEvent;
      fOnSynchAudioFile       : TRGAudioFileSynchEvent;

      /// 2 variables for TrackProgress-Events
      fCurrentTrackProgress  : Single;
      fLastProgressReport    : Int64;

      fCurrentIndex    : Integer ;
      fFileSynchOffset : Integer;

      fCurrentWriteMetaDataProgress: Single;

      fCalculationMode: TRGCalculationMode;


      ///  Init the ReplayGain calculation
      ///  Basically just a call of "ReplayGain.InitGainAnalysis" from the dll-functions,
      ///  and some initialisation of private member variables
      function fInitGainCalculation(aFreq: Longint): Longint;

      ///  InitStreamFromFilename
      ///  Create a Stream using BASS from the filename and
      ///  get Information from the Channel (Channels, 16Bit, Freq)
      ///  returnValue:  BASS_ErrorGetCode if Stream could not be created
      function InitStreamFromFilename(aFilename: UnicodeString): Integer;
      ///  Free the stream again
      procedure FreeStream;

      ///  CheckNewStreamProperties
      ///  Check, whether Channel values are supported
      ///    - 16 Bit Channels
      ///    - 1 or 2 Channels
      ///    - supported Freq
      ///    - if AlbumGainWanted: freq is still the same (as from the last initialisation)
      function CheckNewStreamProperties(AlbumGainWanted: Boolean): Integer;

      ///  Read some AudioSamples from the AudioStream into the Buffer
      function fReadMonoSamplesFromStream: Integer;
      function fReadStereoSamplesFromStream: Integer;
      function ReadAudioSamplesFromStream: Integer;

      ///  Analyse the samples in the buffer
      procedure fPrepareRGAnalyseMono(nSamples: Integer);
      procedure fPrepareRGAnalyseStereo(nSamples: Integer);
      function RGAnalyse(nSamples: Integer): LongInt;

      /// calculate TrackGain for the current track
      function fCalculateTrack(aIndex: Integer; AlbumGainWanted: Boolean): TFloat;

      procedure HandleMainProgress(AlbumName: String; FileCount: Integer; Progress: TRGStatus);

      ///  Synchronize the EventHandlers
      procedure DoSynchOnStreamInit          ;
      procedure DoSynchOnError               ;
      procedure DoSynchOnStreamProgress      ;
      procedure DoSynchOnTrackComplete       ;
      procedure DoSynchOnAlbumComplete       ;
      /// -----------
      procedure DoSynchOnWriteMetaDataProgress;
      procedure DoSynchAudioFile              ;
      procedure DOSynchRGOverallProgress      ;

      function fPrepareNextAlbum(StartIndex: Integer): Integer;
      procedure fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain, aTrackPeak, aAlbumPeak: Double; Flags: Integer);

  protected
      procedure Execute; override;
      ///  Execute different Tasks, based on fCalculationMode
      procedure ExecuteSingleTracks;
      procedure ExecuteSingleAlbum;
      procedure ExecuteMultiAlbums;
      procedure ExecuteDeleteReplayGAinValues;

      ///  Calculate TrackGain only
      function CalculateTrackGain(aAudioFile: UnicodeString; aIndex: Integer): TFloat;

      ///  Calculate TrackGain and AlbumGain for a List of Titles
      ///  Use the Events from above to get the result values for the different Tracks
      function CalculateAlbumGain(AudioFiles: TStringList): TFloat;

  public

      MainWindowHandle: DWord;

      property ChannelLength : Int64    read fChannelLength ;
      property ChannelCount  : Cardinal read fChannelCount  ;
      property ChannelFreq   : Cardinal read fChannelFreq   ;
      property CurrentFilename : UnicodeString read fCurrentFilename;


      property CalculationMode: TRGCalculationMode read fCalculationMode write fCalculationMode;

      // The MediaLibrary can be blocked, so we can work with the actual files from there
      // The Playlist has no blocking ability, so we have to work with copies of the playlist-files here
      // (to avoid AccessViolations and stuff when the user deletes files from the playlist...)
      // NOTE: This MUST be set before adding any audiofiles to the List!
      property UseAudioFileCopies: boolean read fUseAudioFileCopies write fUseAudioFileCopies;

      ///  Eventhandlers
      ///  --------------------------------------------------
      ///  OnStreamInit : Triggered after creation of a Stream by the BASS.dll
      ///                 ErrorCode: - 0 if everything is fine,
      ///                            - one of the constants used by BASS_ErrorGetCode
      ///                 => Display a "Starting (filename) (streamproperties)" Message (e.g. on a TLabel)
      ///                    or: log the error message (depending on ErrorCode)
      ///  OnError:      (a) The Stream does not match the requirements to be analyses
      ///                    Errorcode contains one of the RG_ERR_** constants defined in this Unit
      ///                (b) Reading sampledata from the stream fails
      ///                    ErrorCode: BASS_ErrorGetCode
      ///                    (Note: BASS_ERROR_ENDED is possible, but that should not be considered as an actual error)
      ///                 => Log an error message ("invalid file, frequenzy, no 16Bit, ...")
      ///  OnTrackProgress:   Progress of the calculation of the current Title, ranged from 0 to 1
      ///                     => Display progress of the Calculation of a Track (e.g. on a Progressbar)
      ///  OnTrackComplete:   a Track during a multi-track-calculation has been completed
      ///                     => display TrackGain-Values
      ///                        (and, with knowledge of the VCL-Lists and previous Events: Show "overall progress"
      ///  OnAlbumComplete:   One Album during a Multi-Album-Calculation has been completed
      ///                      => display AlbumGain values
      ///
      property OnStreamInit          : TRGNotifyEvent read fOnStreamInit write fOnStreamInit;
      property OnError               : TRGNotifyEvent read fOnError write fOnError;
      property OnTrackProgress       : TRGProgressEvent read fOnTrackProgress write fOnTrackProgress;
      property OnTrackComplete       : TRGCompleteEvent read fOnTrackComplete write fOnTrackComplete;
      property OnAlbumComplete       : TRGCompleteEvent read fOnAlbumComplete write fOnAlbumComplete;

      ///  Additional Eventhandlers
      ///  ------------------------
      ///  OnMainProgress          : Overall Progress has reached a new state
      ///                            => e.g. Display a message like "Begin calculating ReplayGain for %d files ..."
      ///  OnSynchAudioFile        : triggered after saving ReplayGain to the MetaData of the file (within this thread!)
      ///                            => Properties of the Nemp AudioFile-Object should be set in VCL-Context
      ///  OnWriteMetaDataProgress : For some operations, it makes sense to update MetaData in multiples files after
      ///                            the calculations are done. This is in most cases pretty fast. But when there is no
      ///                            ID3v2Tag or not enough padding, the complete file must be rewritten. This may take a
      ///                            while when calculating many files. Therefore this event.
      ///                            => e.g. refesh a ProgressBar
      ///
      property OnMainProgress          : TRGMainProgressEvent read fOnMainProgress write fOnMainProgress;
      property OnSynchAudioFile        : TRGAudioFileSynchEvent read fOnSynchAudioFile write fOnSynchAudioFile;
      property OnWriteMetaDataProgress : TRGProgressEvent read fOnWriteMetaDataProgress write fOnWriteMetaDataProgress;


      constructor Create;
      destructor Destroy; override;

      procedure AddAudioFile(aAudioFile: TAudioFile);

  end;

implementation

{ TNempReplayGainCalculator }

constructor TNempReplayGainCalculator.Create;
begin
    inherited create(True);

    FreeOnTerminate := True;

    fAudioFiles := TAudioFileList.Create(False);  // do NOT own the objects!
    fPaths   := TStringList.Create;
    fAlbums  := TStringList.Create;
    fCurrentAlbumList := TStringList.Create;
end;

destructor TNempReplayGainCalculator.Destroy;
var i: Integer;
begin
    if fUseAudioFileCopies then
    begin
        for i := 0 to fAudioFiles.Count - 1 do
            fAudioFiles[i].Free;
    end;
    fPaths.Free;
    fAlbums.Free;
    fCurrentAlbumList.Free;
    fAudioFiles.Free;

    if fStream <> 0 then
        BASS_StreamFree(fStream);

    inherited;
end;


procedure TNempReplayGainCalculator.AddAudioFile(aAudioFile: TAudioFile);
var newFile: TAudioFile;
begin
    if fUseAudioFileCopies then
    begin
        newFile := TAudioFile.Create;
        newFile.Assign(aAudioFile);
        fAudioFiles.Add(newFile);
    end else
        fAudioFiles.Add(aAudioFile);

    fPaths.Add(aAudioFile.Pfad);
    fAlbums.Add(aAudioFile.Album);
end;

function TNempReplayGainCalculator.fPrepareNextAlbum(StartIndex: Integer): Integer;
var i: Integer;
    currentAlbum: String;
begin
    fCurrentAlbumList.Clear;

    result := 0;
    if StartIndex >= fAudioFiles.Count  then
        exit;

    i := StartIndex;
    currentAlbum := fAlbums[i];

    fCurrentAlbumList.Add(fPaths[i]);
    inc(i);
    while (i < fAlbums.Count) and (currentAlbum = fAlbums[i]) do
    begin
        fCurrentAlbumList.Add(fPaths[i]);
        inc(i);
    end;

    // prepare the TrackGain-Value array
    SetLength(fCurrentTrackGains, fCurrentAlbumList.Count);
    for i := 0 to Length(fCurrentTrackGains)-1 do
    begin
        fCurrentTrackGains[i].Gain := 0;
        fCurrentTrackGains[i].Peak := 1;
    end;

    result := fCurrentAlbumList.Count;
end;

procedure TNempReplayGainCalculator.fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain, aTrackPeak, aAlbumPeak: Double; Flags: Integer);
var localAudioFile: TAudioFile;
    aErr: TNempAudioError;
    ErrorLog: TErrorLog;
begin
    if FileExists(aFile) then
    begin
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
            Integer(PWideChar(aFile)));

        localAudioFile := TAudioFile.Create;
        try
            // read data
            localAudioFile.GetAudioData(aFile, 0);

            // set Gain values in AudioFile-Object
            if (Flags AND RG_SetTrack)   = RG_SetTrack   then localAudioFile.TrackGain := aTrackGain;
            if (Flags AND RG_SetTrack)   = RG_SetTrack   then localAudioFile.TrackPeak := aTrackPeak;
            if (Flags AND RG_ClearTrack) = RG_ClearTrack then localAudioFile.TrackGain := 0;
            if (Flags AND RG_ClearTrack) = RG_ClearTrack then localAudioFile.TrackPeak := 1;
            if (Flags AND RG_SetAlbum)   = RG_SetAlbum   then localAudioFile.AlbumGain := aAlbumGain;
            if (Flags AND RG_SetAlbum)   = RG_SetAlbum   then localAudioFile.AlbumPeak := aAlbumPeak;
            if (Flags AND RG_ClearAlbum) = RG_ClearAlbum then localAudioFile.AlbumGain := 0;
            if (Flags AND RG_ClearAlbum) = RG_ClearAlbum then localAudioFile.AlbumPeak := 1;

            // Write Data into the metatags of the file
            aErr := localAudioFile.WriteReplayGainToMetaData(aTrackGain, aAlbumGain, aTrackPeak, aAlbumPeak, Flags, True);

            if aErr <> AUDIOERR_None then
            begin
                ErrorLog := TErrorLog.create(afa_ReplayGain, localAudioFile, aErr, False);
                // false: Do not report errors like "MetaData not supported" - that's ok here. ;-)
                try
                    SendMessage(MainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                finally
                    ErrorLog.Free;
                end;
            end;

        finally
            localAudioFile.Free;
        end;

        // finally set the values in the Audiofile-Objects in the Player
        if assigned(fOnSynchAudioFile) then
            Synchronize(DoSynchAudioFile);
    end;
end;


///  -------------------------------------------------
///  Call the EventHandlers
///  These methods MUST be called with Synchronize
///  -------------------------------------------------
procedure TNempReplayGainCalculator.DoSynchOnStreamInit;
begin
    fOnStreamInit(self, fLastErrorCode);
end;
procedure TNempReplayGainCalculator.DoSynchOnError;
begin
    fOnError(self, fLastErrorCode);
end;
procedure TNempReplayGainCalculator.DoSynchOnStreamProgress;
begin
    self.fOnTrackProgress(self, fCurrentTrackProgress);
end;
procedure TNempReplayGainCalculator.DoSynchOnTrackComplete;
begin
    fOnTrackComplete(self, fCurrentIndex, fTrackGain, fTrackPeak);
end;
procedure TNempReplayGainCalculator.DoSynchOnAlbumComplete;
begin
    fOnAlbumComplete(self, fCurrentIndex, fAlbumGain, fAlbumPeak);
end;
procedure TNempReplayGainCalculator.DoSynchOnWriteMetaDataProgress;
begin
    fOnWriteMetaDataProgress(self, fCurrentWriteMetaDataProgress);
end;

procedure TNempReplayGainCalculator.DoSynchAudioFile;
begin
    fOnSynchAudioFile(
        fAudioFiles[ fFileSynchOffset + fCurrentIndex ],
        fCurrentTrackGains[fCurrentIndex].Gain,
        fAlbumGain,
        fCurrentTrackGains[fCurrentIndex].Peak,
        fAlbumPeak
    );
end;

{
   * ------------------------------------------
   * Handle "main progress events" of this ThreadClass
   * like: begin Album Calculation, begin FileSynch, Album complete
   * ------------------------------------------
}
procedure TNempReplayGainCalculator.HandleMainProgress(AlbumName: String; FileCount: Integer; Progress: TRGStatus);
begin
    if assigned(fOnMainProgress) then
    begin
        fMainProgressData.AlbumName := AlbumName;
        fMainProgressData.FileCount := FileCount;
        fMainProgressData.Progress := Progress;
        Synchronize(DoSynchRGOverallProgress);
    end;
end;
procedure TNempReplayGainCalculator.DoSynchRGOverallProgress;
begin
    fOnMainProgress(self, fMainProgressData.AlbumName, fMainProgressData.FileCount, fMainProgressData.Progress);
end;


{
  * ---------------------------------
  * Calculating ReplayGain Values
  * ---------------------------------
}

function TNempReplayGainCalculator.fInitGainCalculation(aFreq: Longint): Longint;
var localRGerr: Integer;
begin
    // the orginal return values from the replaygain.dll does not fit into the system here
    // we use (OK <=> ErrorCode=0)
    // but replaygaion.dll uses
    //  INIT_GAIN_ANALYSIS_ERROR = 0;
    //  INIT_GAIN_ANALYSIS_OK    = 1;
     localRGerr := InitGainAnalysis(aFreq);

    if localRGerr = INIT_GAIN_ANALYSIS_OK then
    begin
        fLastGainInitFreq := aFreq;
        fSomeCalculationsDone := False;
        fLastErrorCode := RG_ERR_None;
    end else
    begin
        fLastGainInitFreq := 0;
        fSomeCalculationsDone := False;
        fLastErrorCode := RG_ERR_InitGainAnalysisError;
        // Handle Error-Event
        if assigned(fOnError) then
            Synchronize(DoSynchOnError);
    end;

    result := fLastErrorCode;
end;

{
    InitStreamFromFilename
    ---------------------------------------------------------------
    Create a Stream using BASS from the filename and
    get Information from the Channel (Channels, 16Bit, Freq)
    - return value:
        0                 if stream was successfully created
        BASS_ErrorGetCode otherwise
}
function TNempReplayGainCalculator.InitStreamFromFilename(aFilename: UnicodeString): Integer;
var Channelinfo: Bass_ChannelInfo;
begin
    if fStream <> 0 then
        BASS_StreamFree(fStream);
    fStream := BASS_StreamCreateFile(false, PChar(aFilename), 0, 0, BASS_UNICODE OR BASS_STREAM_DECODE OR BASS_SAMPLE_FLOAT);
    if (fStream = 0) then
    begin
        fLastErrorCode   := Bass_ErrorGetCode;
        fCurrentFilename := aFilename;
        fTrackPeak       := 0;
        fChannelLength   := 0;
        fChannelCount    := 0;
        fChannelFreq     := 0;
    end
    else
    begin
        fLastErrorCode := 0;
        fTrackPeak := 0;
        fCurrentFilename := aFilename;
        fChannelLength := BASS_ChannelGetLength(fStream, BASS_POS_BYTE);
        BASS_ChannelGetInfo(fStream, Channelinfo);
        fChannelCount   := ChannelInfo.chans;
        fChannelFreq    := ChannelInfo.freq;
    end;

    result := fLastErrorCode;

    // trigger event to display Information about the current stream .... fChannelCount, fChannelFreq, ...
    if assigned(fOnStreamInit) then
        Synchronize(DoSynchOnStreamInit);
end;

procedure TNempReplayGainCalculator.FreeStream;
begin
    if fStream <> 0 then
        BASS_StreamFree(fStream);
end;

{
    CheckNewStreamProperties
    -----------------------------------------------------------------
    Check, whether Channel values are supported
      - 16 Bit Channels
      - 1 or 2 Channels
      - supported Freq
      - if AlbumGainWanted: freq is still the same (as from the last initialisation)
}
function TNempReplayGainCalculator.CheckNewStreamProperties(AlbumGainWanted: Boolean): Integer;
begin
    fLastErrorCode := RG_ERR_None;
    result := fLastErrorCode;

    if fchannelCount > 2 then
    begin
        fLastErrorCode := RG_ERR_TooManyChannels;
        result := fLastErrorCode;
        // trigger OnError-Event
        if assigned(fOnError) then
            Synchronize(DoSynchOnError);
    end
    else
        if self.fChannelFreq <> fLastGainInitFreq then
        begin
            // ReInit GainAnalysis
            if fInitGainCalculation(fChannelFreq) <> RG_ERR_None then
            begin
                // fLastErrorCode was set in fInitGainCalculation
                result := fLastErrorCode;
            end;

            if AlbumGainWanted then
            begin
                fAlbumGainCalculationFailed := True;
                fLastErrorCode := RG_ERR_AlbumGainFreqChanged;
                // DO NOT set result := fLastErrorCode; in this case
                // we will continue calculating TrackGain-Values, but we skip AlbumGain
                // however: do trigger an event to notify the main application // user about it
                if assigned(fOnError) then
                    Synchronize(DoSynchOnError);
            end;
        end;
end;


function TNempReplayGainCalculator.fReadMonoSamplesFromStream: Integer;
begin
    result := BASS_ChannelGetData(fStream, @fMonoBuffer, sizeof(fMonoBuffer)); // div sizeof(TMonoSample);
end;
function TNempReplayGainCalculator.fReadStereoSamplesFromStream: Integer;
begin
    result := BASS_ChannelGetData(fStream, @fStereoBuffer, sizeof(fStereoBuffer) ); // div sizeof(TStereoSample);
end;
function TNempReplayGainCalculator.ReadAudioSamplesFromStream: Integer;
var bytesread: Integer;
begin
    bytesread := 0;
    result := 0;
    case fChannelCount  of
        1: bytesread := fReadMonoSamplesFromStream;
        2: bytesread := fReadStereoSamplesFromStream;
    end;

    if bytesread = -1 then
    begin
        flastErrorCode := BASS_ErrorGetCode;
        // No data was read. One possible cause: BASS_ERROR_ENDED
        // This will result in an error-event, but it should not be treated as one in the EventHandler.
        if assigned(fOnError) then
            Synchronize(DoSynchOnError);
    end else
    begin
        case fChannelCount  of
            1: result := bytesread div sizeof(TMonoSample);
            2: result := bytesread div sizeof(TStereoSample);
        end;
    end;
end;

procedure TNempReplayGainCalculator.fPrepareRGAnalyseMono(nSamples: Integer);
var k: Integer;
begin
    for k := 0 to pred(nSamples) do
    begin
        fLeftSamples[k]  := fMonoBuffer[k] * 32767;
        fTrackPeak := Max(fTrackPeak, Abs(fMonoBuffer[k]));
        fRightSamples[k] := 0;
    end;
end;
procedure TNempReplayGainCalculator.fPrepareRGAnalyseStereo(nSamples: Integer);
var k: Integer;
begin
    for k := 0 to pred(nSamples) do
    begin
        fLeftSamples[k]  := fStereoBuffer[k].Left  * 32767 ;
        fTrackPeak := Max(fTrackPeak, Abs(fStereoBuffer[k].Left));
        fRightSamples[k] := fStereoBuffer[k].Right * 32767 ;
        fTrackPeak := Max(fTrackPeak, Abs(fStereoBuffer[k].Right));
    end;
end;
function TNempReplayGainCalculator.RGAnalyse(nSamples: Integer): LongInt;
begin
    result := GAIN_ANALYSIS_OK;
    if (nSamples > 0) then
    begin
        case fChannelCount of
            1: fPrepareRGAnalyseMono(nSamples);
            2: fPrepareRGAnalyseStereo(nSamples);
        end;
        result := AnalyzeSamples(@fLeftSamples, @fRightSamples, nSamples, fChannelCount);
    end;
end;



function TNempReplayGainCalculator.fCalculateTrack(aIndex: Integer; AlbumGainWanted: Boolean): TFloat;
var currentBassPos: Int64;
begin
    ///  First, check the properties of the stream.
    ///  Within CheckNewStreamProperties, the OnError-Event is triggered if something goes wrong.
    ///  The Parameter ErrorCode contains one of the RG_ERR_** constants defined in this Unit.
    if CheckNewStreamProperties(AlbumGainWanted) <> RG_ERR_None then
    begin
        result := 0;
        fCurrentTrackGains[aIndex].Gain := 0;
        fCurrentTrackGains[aIndex].Peak := 1;
        // Error-Event was triggered in CheckNewStreamProperties, if an error occured
    end
    else
    begin
        // Channel properties are supported, continue
        fTrackPeak := 0;
        fLastProgressReport := 0;

        while (BASS_ChannelIsActive(fStream) > 0) do
        begin
            if terminated then
                break;

            // read some samples and analyse them
            RGAnalyse(ReadAudioSamplesFromStream);

            // Trigger/Sync the OnTrackProgress event.
            // Note: This is not triggered everry time, but only if a significant amount of data has been read.

            if assigned(fOnTrackComplete) then
            begin
                currentBassPos := BASS_ChannelGetPosition(fStream, BASS_POS_BYTE);
                if (currentBassPos - fLastProgressReport) > (fChannelLength Div 100)  then
                begin
                    fLastProgressReport := currentBassPos;
                    fCurrentTrackProgress := currentBassPos / fChannelLength;
                    Synchronize(DoSynchOnStreamProgress);
                end;
            end;

        end;

        if terminated then
            result := 0
        else
        begin
            fSomeCalculationsDone := True;

            fCurrentIndex := aIndex;
            fTrackGain := GetTitleGain;
            fCurrentTrackGains[aIndex].Gain := fTrackGain;
            fCurrentTrackGains[aIndex].Peak := fTrackPeak;

            // trigger Event: OnTrackComplete
            if assigned(fOnTrackComplete) then
                Synchronize(DoSynchOnTrackComplete);

            result := fTrackGain;
        end;
    end;
end;



function TNempReplayGainCalculator.CalculateTrackGain(aAudioFile: UnicodeString; aIndex: Integer): TFloat;
begin
    result := 0;
    ///  For Error handling during calculation use the event OnStreamInit,
    ///  which is triggered by InitStreamFromFilename
    ///  The Parameter ErrorCode contains the result from BASS_ErrorGetCode
    if InitStreamFromFilename(aAudioFile) = 0 then
        result := fCalculateTrack(aIndex, False);
    FreeStream;
end;

function TNempReplayGainCalculator.CalculateAlbumGain(
  AudioFiles: TStringList): TFloat;
var i: Integer;
begin
    result     := 0;
    fTrackGain := 0;
    fAlbumGain := 0;
    fAlbumPeak := 0;

    fLastGainInitFreq := 0;
    fAlbumGainCalculationFailed := False;
    fSomeCalculationsDone       := False;

    if (not assigned(AudioFiles)) or (AudioFiles.Count = 0) then
        exit;

    // initiate AlbumGain calculation with the first AudioFile in the list.
    if InitStreamFromFilename(AudioFiles[0]) = 0 then
    begin
        // difference to the for-loop:
        // we call fInitGainCalculation directly, not only indirectly through
        // fCalculateTrack->CheckNewStreamProperties->"if freq changed"
        if fInitGainCalculation(fChannelFreq) = RG_ERR_None then
            fCalculateTrack(0, True);

        fAlbumPeak := Max(fAlbumPeak, fTrackPeak);
    end;
    FreeStream;

    if terminated then
    begin
        result := 0;
        exit;
    end;

    // for the rest of the titles do *not* call fInitGainCalculation again
    //  ... unless it is needed due to a samplerate change.
    //  ... which is the case, if the first title failed (by InitStreamFromFilename OR fInitGainCalculation)
    //      But in that case AlbumGain is kinda pointless, therefore it is skipped later
    for i := 1 to AudioFiles.Count - 1 do
    begin
        if terminated then
            break;

        if InitStreamFromFilename(AudioFiles[i]) = 0 then
        begin
            fCalculateTrack(i, True);
            fAlbumPeak := Max(fAlbumPeak, fTrackPeak);
        end;
        FreeStream;
    end;

    if terminated then
        result := 0
    else
    begin
        // Fill private member variables needed for the OnComplete-Handler
        if Not fAlbumGainCalculationFailed then
        begin
            if fSomeCalculationsDone then
                fAlbumGain := GetAlbumGain
            else
                fAlbumGain := 0;
            fCurrentIndex := AudioFiles.Count;
        end else
        begin
            fAlbumGain := 0;
            fAlbumPeak := 1;
            fCurrentIndex := -1;
        end;

        result := fAlbumGain;

        // trigger the event OnAlbumComplete
        if assigned(fOnAlbumComplete) then
            Synchronize(DoSynchOnAlbumComplete);
    end;
end;


// TNempReplayGainCalculator
{
======================================
======================================
======================================
" Thread-Level-Stuff" starts here
======================================
======================================
======================================

}

procedure TNempReplayGainCalculator.ExecuteSingleTracks;
var i: Integer;
begin
    fFileSynchOffset := 0;
    if fAudioFiles.Count > 0 then
    begin
        // prepare the TrackGain-Value array
        fAlbumPeak := 1;
        fAlbumGain := 0;
        SetLength(fCurrentTrackGains, fAudioFiles.Count);
        for i := 0 to Length(fCurrentTrackGains)-1 do
        begin
            fCurrentTrackGains[i].Gain := 0;
            fCurrentTrackGains[i].Peak := 1;

        end;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartCalculationSingleTracks);

        for i := 0 to fPaths.Count - 1 do
        begin
            if Terminated then
                break;

            // calculate TrackGain
            fCurrentIndex := i;
            CalculateTrackGain(fPaths[i], i);
            // Note: fCurrentTrackGains-values are set within CalculateTrackGain

            // Update MetaData
            // we can do it her directly after the calculation of the TrackGain,
            // as we do not need AlbumGain information
            if not isZero(fCurrentTrackGains[i].Gain) then
                fUpdateMetaData(fPaths[i], fCurrentTrackGains[i].Gain, 0, fCurrentTrackGains[i].Peak, 1,  RG_SetTrack);
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        if not Terminated then
            // File Synch complete, notify MainThread
            HandleMainProgress('', fAudioFiles.Count, RGStatus_Finished);
    end;

end;

procedure TNempReplayGainCalculator.ExecuteSingleAlbum;
var i, Flags: Integer;
begin
    fFileSynchOffset := 0;
    if fAudioFiles.Count > 0 then
    begin
        // prepare the TrackGain-Value array
        SetLength(fCurrentTrackGains, fAudioFiles.Count);
        for i := 0 to Length(fCurrentTrackGains)-1 do
        begin
            fCurrentTrackGains[i].Gain := 0;
            fCurrentTrackGains[i].Peak := 1;
        end;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartCalculationSingleAlbum);

        // calculate TrackGain + AlbumGain
        // (longer procedure, can be aborted through "Terminated")
        fAlbumGain := CalculateAlbumGain(fPaths);

        // check for termination. If yes, do NOT start updating Metadata
        if terminated then
            exit;

        // Calculation complete, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartSync);

        Flags := RG_SetTrack;
        if NOT fAlbumGainCalculationFailed then
            Flags := RG_SetBoth;

        // Write the Data into the MetaTags of the Files
        for i := 0 to fPaths.Count - 1 do
        begin
            if Terminated then
                break;

            fCurrentIndex := i;
            // Update MetaData
            if not isZero(fCurrentTrackGains[i].Gain) then
                fUpdateMetaData(fPaths[i], fCurrentTrackGains[i].Gain, fAlbumGain, fCurrentTrackGains[i].Peak, fAlbumPeak, Flags);

            if assigned(fOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fPaths.Count;
                DoSynchOnWriteMetaDataProgress;
            end;
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        if not Terminated then
            // File Synch complete, notify MainThread
            HandleMainProgress('', fAudioFiles.Count, RGStatus_Finished);
    end;
end;

procedure TNempReplayGainCalculator.ExecuteMultiAlbums;
var FilesDone: Integer;
    NewAlbumCount, i, Flags: Integer;
    fCurrentAlbum: String;
begin
    FilesDone := 0;
    fFileSynchOffset := 0;
    while (FilesDone < fAudioFiles.Count) and (Not Terminated) do
    begin
        // collect file for the next album
        NewAlbumCount := fPrepareNextAlbum(FilesDone);
        if NewAlbumCount > 0 then
            fCurrentAlbum := fAlbums[FilesDone]
        else
            fCurrentAlbum := '';

        // Starting calculation, notify MainThread
        HandleMainProgress(fCurrentAlbum, NewAlbumCount, RGStatus_StartCalculationMultiAlbum);

        // calculate TrackGain + AlbumGain for this Album
        // (longer procedure, can be aborted through "Terminated")
        fAlbumGain := CalculateAlbumGain(self.fCurrentAlbumList);

        // check for termination. If yes, do NOT start updating Metadata
        if terminated then
            exit;

        // Calculation complete, notify MainThread
        HandleMainProgress(fCurrentAlbum, NewAlbumCount, RGStatus_StartSync);

        Flags := RG_SetTrack;
        if NOT fAlbumGainCalculationFailed then
            Flags := RG_SetBoth;

        // Write the Data into the MetaTags of the Files (threaded, using Message-concept with CurrentThreadFilename) and
        // set the values in the Audiofile-Objects (another synchronize- job. Also an additional handler , to change all copies of the audiofile)
        fFileSynchOffset := FilesDone;
        for i := 0 to fCurrentAlbumList.Count - 1 do
        begin
            if Terminated then
                break;

            fCurrentIndex := i;
            // Update MetaData, similar to UpdateTags in Medialibrary for the TagCloud-stuff
            if not isZero(fCurrentTrackGains[i].Gain)  then
                fUpdateMetaData(fCurrentAlbumList[i], fCurrentTrackGains[i].Gain, fAlbumGain, fCurrentTrackGains[i].Peak, fAlbumPeak, Flags);

            if assigned(fOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fCurrentAlbumList.Count;
                DoSynchOnWriteMetaDataProgress;
            end;
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        // File Synch complete, notify MainThread
        FilesDone := FilesDone + NewAlbumCount;
        if not Terminated then
            HandleMainProgress(fCurrentAlbum, NewAlbumCount, RGStatus_Finished);
    end;

end;

procedure TNempReplayGainCalculator.ExecuteDeleteReplayGAinValues;
var i: Integer;
begin
    fFileSynchOffset := 0;
    if fAudioFiles.Count > 0 then
    begin
        // prepare the TrackGain-Value array
        // this array is needed in DoSynchAudioFile (called from fUpdateMetaData)
        fAlbumPeak := 1;
        fAlbumGain := 0;
        SetLength(fCurrentTrackGains, fAudioFiles.Count);
        for i := 0 to Length(fCurrentTrackGains)-1 do
        begin
            fCurrentTrackGains[i].Gain := 0;
            fCurrentTrackGains[i].Peak := 1;
        end;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartDeleteValues);

        for i := 0 to fPaths.Count - 1 do
        begin
            if Terminated then
                break;

            fCurrentIndex := i;
            // Update MetaData
            fUpdateMetaData(fPaths[i], 0, 0, 1, 1, RG_ClearBoth);

            if assigned(fOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fPaths.Count;
                DoSynchOnWriteMetaDataProgress;
            end;

        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        // File Synch complete, notify MainThread
        if not Terminated then
            HandleMainProgress('', fAudioFiles.Count, RGStatus_Finished);
    end;
end;



procedure TNempReplayGainCalculator.Execute;
begin
    case self.fCalculationMode of
      RG_Calculate_SingleTracks  : ExecuteSingleTracks;
      RG_Calculate_SingleAlbum   : ExecuteSingleAlbum;
      RG_Calculate_MultiAlbums   : ExecuteMultiAlbums;
      RG_Delete_ReplayGainValues : ExecuteDeleteReplayGAinValues;
    end;
end;


end.
