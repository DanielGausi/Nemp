{

    Unit ReplayGainAnalysis

    A wrapper class for the ReplayGain.dll by David Robinson and Glen Sawyer

    ---------------------------------------------------------------
    Copyright (C) 2019, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------
}

unit ReplayGainAnalysis;

interface

uses System.Classes, ReplayGain, math, bass;

const
    SampleBufferSize = 4096;

    // some error Values
    RG_ERR_None                  = 0; // everything is ok :)
    // I do not start with 1, so theses codes differ from the BASS ErrorCodes
    RG_ERR_TooManyChannels       = 101;  // The audiostream contains more than 2 channels
    RG_ERR_No16Bit               = 102;  // the audiostream does not contain 16bit samples
    RG_ERR_InitGainAnalysisError = 103;  // error from the original ReplayGain-Unit,
                                         // probably the samplerate of the audiostream is not supported
    RG_ERR_AlbumGainFreqChanged  = 104;  // the list of audiofiles contains different samplerates
                                         // in that case, calculation of AlbumGain is not possible and will be skipped
                                         // at the end of the method CalculateAlbumGain


type

    TMonoSample = SmallInt;

    TStereoSample = record
        Left:  SmallInt;
        Right: SmallInt;
    end;

    TReplayGainCalculator = class;

    TRGEvent         = Procedure(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer) of Object;
    TRGProgressEvent = Procedure(aReplayGainCalculator: TReplayGainCalculator; aProgress: Single) of Object;
    TRGCompleteEvent  = Procedure(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt) of Object;


    TReplayGainCalculator = class
    private

        fStream: HSTREAM;
        fChannelLength    : Cardinal;
        fChannelCount     : Cardinal;
        fChannelFreq      : Cardinal;
        fChannelIs16Bit   : Boolean;
        fLastGainInitFreq : Cardinal;
        fCurrentFilename  : UnicodeString;

        fAlbumGainCalculationFailed: Boolean;
        fSomeCalculationsDone: Boolean;

        fFileCount: Integer;

        fPeakTrack: SmallInt;
        fPeakAlbum: SmallInt;
        fTrackGain: TFloat;
        fAlbumGain: TFloat;
        fCurrentIndex: Integer;
        fLastErrorCode: Integer;

        fLeftSamples:  array[0..SampleBufferSize-1] of TFloat;
        fRightSamples: array[0..SampleBufferSize-1] of TFloat;

        fStereoBuffer: array[0..SampleBufferSize-1] of TStereoSample;
        fMonoBuffer  : array[0..SampleBufferSize-1] of TMonoSample;

        // Event handler (description: see properties)
        fOnStreamInit          : TRGEvent;
        fOnError               : TRGEvent;
        fOnStreamProgress      : TRGProgressEvent;
        fOnSingleTrackComplete : TRGCompleteEvent;
        fOnTrackComplete       : TRGCompleteEvent;
        fOnAlbumComplete       : TRGCompleteEvent;


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
        function fCalculateTrack(aIndex: Integer; AlbumGainWanted, SingleTrack: Boolean): TFloat;

    public
        property PeakTrack: SmallInt read fPeakTrack;
        property PeakAlbum : SmallInt read fPeakAlbum ;
        property TrackGain: TFloat read fTrackGain;
        property AlbumGain: TFloat read fAlbumGain;

        property AlbumGainCalculationFailed: Boolean read fAlbumGainCalculationFailed;
        property SomeCalculationsDone: Boolean read fSomeCalculationsDone;

        property LastErrorCode: Integer read fLastErrorCode;
        property CurrentIndex: Integer read fCurrentIndex;

        property ChannelLength : Cardinal read fChannelLength ;
        property ChannelCount  : Cardinal read fChannelCount  ;
        property ChannelFreq   : Cardinal read fChannelFreq   ;
        property CurrentFilename : UnicodeString read fCurrentFilename;

        // the number of files in the AlbumList for CalculateAlbumGain
        property FileCount : Integer read fFileCount;


        ///  some Events triggered during the GainCalculation
        ///  ------------------------------------------------
        ///  OnStreamInit: After creation of a Stream by the BASS.dll
        ///                ErrorCode: 0 if everything is fine,
        ///                           one of the constants used by BASS_ErrorGetCode
        ///  OnError:      (a) The Stream does not match the requirements to be analyses
        ///                    Errorcode contains one of the RG_ERR_** constants defined in this Unit
        ///                (b) Reading sampledata from the stream fails
        ///                    ErrorCode: BASS_ErrorGetCode
        ///                    (Note: BASS_ERROR_ENDED is possible, but that should not be considered as an actual error)
        ///  OnStreamProgress      : Progress of the calculation of the current Title, ranged from 0 to 1
        ///  OnSingleTrackComplete : The TrackGain calculation of a single track has been comleted
        ///  OnTrackComplete       : The TrackGain calculation of one Track during the calculation
        ///                          of the AlbumGain for a list of tracks has been completed
        ///  OnAlbumComplete       : The calculation of AlbumGain has been completed.
        ///                          Note: This is also triggered, when the calculation has been aborted.

        property OnStreamInit          : TRGEvent read fOnStreamInit write fOnStreamInit;
        property OnError               : TRGEvent read fOnError write fOnError;
        property OnStreamProgress      : TRGProgressEvent read fOnStreamProgress write fOnStreamProgress;
        property OnSingleTrackComplete : TRGCompleteEvent read fOnSingleTrackComplete write fOnSingleTrackComplete;
        property OnTrackComplete       : TRGCompleteEvent read fOnTrackComplete write fOnTrackComplete;
        property OnAlbumComplete       : TRGCompleteEvent read fOnAlbumComplete write fOnAlbumComplete;

        constructor create;
        destructor Destroy; Override;

        ///  Calculate TrackGain for a single Title
        function CalculateTrackGain(aAudioFile: UnicodeString): TFloat;    overload;
        function CalculateTrackGain(aAudioFile: UnicodeString; aIndex: Integer): TFloat; overload;

        ///  Calculate TrackGain and AlbumGain for a List of Titles
        ///  Use the Events from above to get the result values for the different Tracks
        function CalculateAlbumGain(AudioFiles: TStringList): TFloat;
    end;


implementation


{ TReplayGainCalculator }

constructor TReplayGainCalculator.create;
begin
    inherited create;
end;

destructor TReplayGainCalculator.Destroy;
begin
    // free an existing stream, if necessary
    if fStream <> 0 then
        BASS_StreamFree(fStream);

    inherited;
end;


function TReplayGainCalculator.fInitGainCalculation(aFreq: Longint): Longint;
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

        if assigned(fOnError) then
            fOnError(self, RG_ERR_InitGainAnalysisError);
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
function TReplayGainCalculator.InitStreamFromFilename(aFilename: UnicodeString): Integer;
var Channelinfo: Bass_ChannelInfo;
begin
    if fStream <> 0 then
        BASS_StreamFree(fStream);
    fStream := BASS_StreamCreateFile(false, PChar(aFilename), 0, 0, BASS_UNICODE OR BASS_STREAM_DECODE);
    if (fStream = 0) then
    begin
        fLastErrorCode   := Bass_ErrorGetCode;
        fCurrentFilename := aFilename;
        fPeakTrack       := 0;
        fChannelLength   := 0;
        fChannelCount    := 0;
        fChannelFreq     := 0;
        fChannelIs16Bit  := False;
    end
    else
    begin
        fLastErrorCode := 0;
        fPeakTrack := 0;
        fCurrentFilename := aFilename;
        fChannelLength := BASS_ChannelGetLength(fStream, BASS_POS_BYTE);
        BASS_ChannelGetInfo(fStream, Channelinfo);
        fChannelCount   := ChannelInfo.chans;
        fChannelFreq    := ChannelInfo.freq;
        fChannelIs16Bit := NOT (
                ((ChannelInfo.flags AND BASS_SAMPLE_8BITS) = BASS_SAMPLE_8BITS) or
                ((ChannelInfo.flags AND BASS_SAMPLE_FLOAT) = BASS_SAMPLE_FLOAT)     );
    end;

    result := fLastErrorCode;

    // trigger event to display Information about the current stream .... fChannelCount, fChannelFreq, ...
    if assigned(fOnStreamInit) then
        fOnStreamInit(self, fLastErrorCode);
end;

procedure TReplayGainCalculator.FreeStream;
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
function TReplayGainCalculator.CheckNewStreamProperties(AlbumGainWanted: Boolean): Integer;
begin
    fLastErrorCode := RG_ERR_None;
    result := fLastErrorCode;

    if fchannelCount > 2 then
    begin
        fLastErrorCode := RG_ERR_TooManyChannels;
        result := fLastErrorCode;
        if assigned(fOnError) then
            fOnError(self, RG_ERR_TooManyChannels);
    end
    else
        if Not fChannelIs16Bit then
        begin
            fLastErrorCode := RG_ERR_No16Bit;
            result := fLastErrorCode;
            if assigned(fOnError) then
                fOnError(self, RG_ERR_No16Bit);
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
                    // however: do trigger an event to notify the main application // user
                    if assigned(fOnError) then
                        fOnError(self, RG_ERR_AlbumGainFreqChanged);
                end;
            end;
end;

function TReplayGainCalculator.fReadMonoSamplesFromStream: Integer;
begin
    result := BASS_ChannelGetData(fStream, @fMonoBuffer, sizeof(fMonoBuffer)); // div sizeof(TMonoSample);
end;
function TReplayGainCalculator.fReadStereoSamplesFromStream: Integer;
begin
    result := BASS_ChannelGetData(fStream, @fStereoBuffer, sizeof(fStereoBuffer)); // div sizeof(TStereoSample);
end;
function TReplayGainCalculator.ReadAudioSamplesFromStream: Integer;
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
            fOnError(self, flastErrorCode);
    end else
    begin
        case fChannelCount  of
            1: result := bytesread div sizeof(TMonoSample);
            2: result := bytesread div sizeof(TStereoSample);
        end;
    end;
end;

procedure TReplayGainCalculator.fPrepareRGAnalyseMono(nSamples: Integer);
var k: Integer;
begin
    for k := 0 to pred(nSamples) do
    begin
        fLeftSamples[k]  := fMonoBuffer[k];
        fPeakTrack := Max(fPeakTrack, Abs(fMonoBuffer[k]));
        fRightSamples[k] := 0;
    end;
end;
procedure TReplayGainCalculator.fPrepareRGAnalyseStereo(nSamples: Integer);
var k: Integer;
begin
    for k := 0 to pred(nSamples) do
    begin
        fLeftSamples[k]  := fStereoBuffer[k].Left  ;
        fPeakTrack := Max(fPeakTrack, Abs(fStereoBuffer[k].Left));
        fRightSamples[k] := fStereoBuffer[k].Right ;
        fPeakTrack := Max(fPeakTrack, Abs(fStereoBuffer[k].Right));
    end;
end;
function TReplayGainCalculator.RGAnalyse(nSamples: Integer): LongInt;
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


function TReplayGainCalculator.fCalculateTrack(aIndex: Integer; AlbumGainWanted, SingleTrack: Boolean): TFloat;
var LastProgressReport, currentProgress: Cardinal;
begin
    ///  First, check the properties of the stream.
    ///  Within CheckNewStreamProperties, the OnError-Event is triggered if something goes wrong.
    ///  The Parameter ErrorCode contains one of the RG_ERR_** constants defined in this Unit.
    if CheckNewStreamProperties(AlbumGainWanted) <> RG_ERR_None then
    begin
        result := 0;
        // Error-Event was triggered in CheckNewStreamProperties, if an error occured
    end
    else
    begin
        // Channel properties are supported, continue
        LastProgressReport := 0;
        fPeakTrack := 0;
        while (BASS_ChannelIsActive(fStream) > 0) do
        begin
            // read some samples and analyse them
            RGAnalyse(ReadAudioSamplesFromStream);

            // Trigger the OnProgress event.
            // But not *every* time, but only if some significant progress is done
            if assigned(fOnStreamProgress) then
            begin
                currentProgress := BASS_ChannelGetPosition(fStream, BASS_POS_BYTE);
                if (currentProgress - LastProgressReport) > (fChannelLength Div 100)  then
                begin
                    LastProgressReport := currentProgress;
                    fOnStreamProgress(self, currentProgress / fChannelLength );
                end;
            end;
        end;

        fTrackGain := GetTitleGain;
        result := fTrackGain;

        fSomeCalculationsDone := True;

        /// trigger the proper "OnComplete" event
        if SingleTrack then
        begin
            if assigned(fOnSingleTrackComplete) then
                fOnSingleTrackComplete(self, 0, fTrackGain, fPeakTrack)
        end else
        begin
            if assigned(self.fOnTrackComplete) then
                fOnTrackComplete(self, aIndex, fTrackGain, fPeakTrack)
        end;
    end;
end;

function TReplayGainCalculator.CalculateTrackGain(aAudioFile: UnicodeString): TFloat;
begin
    result := 0;
    fFileCount := 1;
    ///  For Error handling during calculation use the event OnStreamInit,
    ///  which is triggered by InitStreamFromFilename
    ///  The Parameter ErrorCode contains the result from BASS_ErrorGetCode
    if InitStreamFromFilename(aAudioFile) = 0 then
        result := fCalculateTrack(0, False, True);

    FreeStream;
end;

function TReplayGainCalculator.CalculateTrackGain(aAudioFile: UnicodeString; aIndex: Integer): TFloat;
begin
    result := 0;
    fFileCount := 1;
    ///  For Error handling during calculation use the event OnStreamInit,
    ///  which is triggered by InitStreamFromFilename
    ///  The Parameter ErrorCode contains the result from BASS_ErrorGetCode
    if InitStreamFromFilename(aAudioFile) = 0 then
        result := fCalculateTrack(aIndex, False, False);
    FreeStream;
end;

function TReplayGainCalculator.CalculateAlbumGain(
  AudioFiles: TStringList): TFloat;
var i: Integer;
begin
    result     := 0;
    fTrackGain := 0;
    fAlbumGain := 0;
    fPeakAlbum := 0;
    fFileCount := 0;

    fLastGainInitFreq := 0;
    fAlbumGainCalculationFailed := False;
    fSomeCalculationsDone       := False;

    if (not assigned(AudioFiles)) or (AudioFiles.Count = 0) then
        exit;

    fFileCount := AudioFiles.Count;

    // initiate AlbumGain calculation with the first AudioFile in the list.
    if InitStreamFromFilename(AudioFiles[0]) = 0 then
    begin
        // difference to the for-loop:
        // we call fInitGainCalculation directly, not only indirectly through
        // fCalculateTrack->CheckNewStreamProperties->"if freq changed"
        if fInitGainCalculation(fChannelFreq) = RG_ERR_None then
            fCalculateTrack(0, True, False);

        fPeakAlbum := Max(fPeakAlbum, fPeakTrack);
    end;
    FreeStream;

    // for the rest of the titles do *not* call fInitGainCalculation again
    //  ... unless it is needed due to a samplerate change.
    //  ... which is the case, if the first title failed (by InitStreamFromFilename OR fInitGainCalculation)
    //      But in that case AlbumGain is kinda pointless, therefore it is skipped later
    for i := 1 to AudioFiles.Count - 1 do
    begin
        if InitStreamFromFilename(AudioFiles[i]) = 0 then
        begin
            fCalculateTrack(i, True, False);
            fPeakAlbum := Max(fPeakAlbum, fPeakTrack);
        end;
        FreeStream;
    end;

    // trigger the event OnAlbumComplete
    if Not fAlbumGainCalculationFailed then
    begin
        if fSomeCalculationsDone then
            fAlbumGain := GetAlbumGain
        else
            fAlbumGain := 0;

        result := fAlbumGain;
        if assigned(fOnAlbumComplete) then
            fOnAlbumComplete(self, AudioFiles.Count, fAlbumGain, fPeakAlbum);
    end else
    begin
        fAlbumGain := 0;
        if assigned(fOnAlbumComplete) then
            fOnAlbumComplete(self, -1, 0, 0);
    end;


end;

end.
