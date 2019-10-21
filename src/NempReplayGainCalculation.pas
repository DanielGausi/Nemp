unit NempReplayGainCalculation;

interface

uses
  Winapi.Windows, System.Classes, System.Contnrs, System.SysUtils, math, Generics.Collections, Generics.Defaults,
  NempAudioFiles, ReplayGainAnalysis, Nemp_ConstantsAndTypes;

type

  TAudioFileList = class(TObjectList<TAudioFile>);
  TNempReplayGainCalculator = class;

  TRGStatus = ( RGStatus_StartCalculationSingleTracks,
                RGStatus_StartCalculationSingleAlbum,
                RGStatus_StartCalculationMultiAlbum,
                RGStatus_StartSync,
                RGStatus_StartDeleteValues,
                RGStatus_Finished );

  TRGCalculationMode = (RG_Calculate_SingleTracks, RG_Calculate_SingleAlbum, RG_Calculate_MultiAlbums, RG_Delete_ReplayGainValues);

  TRGMainProgressEvent = Procedure(RGThread: TNempReplayGainCalculator; AlbumName: String; FileCount: Integer; Progress: TRGStatus) of Object;

  TRGAudioFileSynchEvent = Procedure(aFile: TAudioFile; aTrackGain, aAlbumGain: Double) of Object;

  // internal Data for preparing the TRGOverallProgressEvent
  TMainProgressData = record
      AlbumName: String;
      FileCount: Integer;
      Progress: TRGStatus;
  end;

  ///  General concept of this Thread
  ///  1.) The fOn*** methods are the Eventhandler for the TReplayGainCalculator
  ///      these run in the context of the Thread
  ///  2.) The properties SynchOn*** and the corresponding fSynchOn*** fields
  ///      are VCL-methods from the calling form/class/whatever
  ///  3.) As methods with parameters cannot be called by "Synchronize" directly,
  ///      we have the DoSynchOn*** methods, which will call the matching fSynchOn**
  ///      EventHandler with proper parameters
  ///  In addition to the TReplayGainCalculator-Events, we have
  ///     DoSynchAudioFile and DOSynchRGOverallProgress
  ///  These Methods are used for additional Events
  ///     - Metadata has been written to an file (and should be set in teh AudioFile Object now)
  ///     - Progress of a Multi-Album-Calculation is starting / start synching / finished
  ///

  TNempReplayGainCalculator = class(TThread)
  private
      { Private declarations }
      fAudioFiles: TAudioFileList;
      fPaths     : TStringList;
      fAlbums    : TStringList;

      ReplayGainCalculator: TReplayGainCalculator;
      fCurrentAlbumList: TStringList;

      ///  Forward Eventhandlers for the (threaded) ReplayGainCalculator for the VCL ...
      ///  See comments below in the property-section
      fSynchOnStreamInit          : TRGEvent;
      fSynchOnError               : TRGEvent;
      fSynchOnStreamProgress      : TRGProgressEvent;
      fSynchOnSingleTrackComplete : TRGCompleteEvent;
      fSynchOnTrackComplete       : TRGCompleteEvent;
      fSynchOnAlbumComplete       : TRGCompleteEvent;
      ///  ... and some additional Eventhandlers
      fSynchOnWriteMetaDataProgress: TRGProgressEvent;
      fMainProgressData            : TMainProgressData;
      fSynchRGMainProgress         : TRGMainProgressEvent;


      fFileSynchOffset : Integer;
      fAlbumGain       : Double ;
      fOnSynchAudioFile: TRGAudioFileSynchEvent;

      fCurrentProgress  : Single  ;
      fCurrentWriteMetaDataProgress: Single;
      fCurrentIndex     : Integer ;
      fCurrentErrorCode : Integer ;

      fCalculationMode: TRGCalculationMode;

      procedure HandleMainProgress(AlbumName: String; FileCount: Integer; Progress: TRGStatus);

      procedure DoSynchOnStreamInit          ;
      procedure DoSynchOnError               ;
      procedure DoSynchOnStreamProgress      ;
      procedure DoSynchOnSingleTrackComplete ;
      procedure DoSynchOnTrackComplete       ;
      procedure DoSynchOnAlbumComplete       ;
      /// -----------
      procedure DoSynchOnWriteMetaDataProgress;
      procedure DoSynchAudioFile ;
      procedure DOSynchRGOverallProgress;

      ///  internal EventHandlers for ReplayGainCalculator
      ///  These methods basically set some internal variables, so that the parameters from the
      ///  ReplayGainCalculator can be passed through the VCL by the DoSynch*** methods
      ///  (using Synchronize(DoSynch***)
      Procedure fOnStreamInit(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
      procedure fOnTrackProgress(Sender: TReplayGainCalculator; aProgress: Single);
      procedure fOnSingleTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnCalculationError(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);


      function fPrepareNextAlbum(StartIndex: Integer): Integer;
      procedure fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain: Double; Flags: Integer);

  protected
      procedure Execute; override;
      ///  Execute different Tasks, based on fCalculationMode
      procedure ExecuteSingleTracks;
      procedure ExecuteSingleAlbum;
      procedure ExecuteMultiAlbums;
      procedure ExecuteDeleteReplayGAinValues;

  public

      MainWindowHandle: DWord;
      CurrentAlbumTrackGains: Array of Single;

      property CalculationMode: TRGCalculationMode read fCalculationMode write fCalculationMode;

      ///  Forward Eventhandlers of the TReplayGainCalculator
      ///  --------------------------------------------------
      ///  OnSynchStreamInit   : Display a "Starting (filename) (streamproperties)" Message (e.g. on a TLabel)
      ///                        or: log the error message (depending on ErrorCode)
      ///  OnSynchError        : Log an error message ("invalid file, frequenzy, no 16Bit, ...")
      ///  OnSynchStreamProgress : Display progress of the Calculation of a Track (e.g. on a Progressbar)
      ///  OnSynchSingleTrackComplete : Calculation of a single track is completed
      ///  OnSynchTrackComplete : a Track during a multi-track-calculation has been completed
      ///                         display TrackGain-Values
      ///                         (and, with knowledge of the VCL-Lists and previous Events: Show "overall progress"
      ///  OnSynchAlbumComplete : One Album during a Multi-Album-Calculation has been completed
      ///                         Display AlbumGain values
      ///
      property OnSynchStreamInit          : TRGEvent read fSynchOnStreamInit write fSynchOnStreamInit;
      property OnSynchError               : TRGEvent read fSynchOnError write fSynchOnError;
      property OnSynchStreamProgress      : TRGProgressEvent read fSynchOnStreamProgress write fSynchOnStreamProgress;
      property OnSynchSingleTrackComplete : TRGCompleteEvent read fSynchOnSingleTrackComplete write fSynchOnSingleTrackComplete;
      property OnSynchTrackComplete       : TRGCompleteEvent read fSynchOnTrackComplete write fSynchOnTrackComplete;
      property OnSynchAlbumComplete       : TRGCompleteEvent read fSynchOnAlbumComplete write fSynchOnAlbumComplete;

      ///  Additional Eventhandlers
      ///  ------------------------
      ///  OnSynchMainProgress          : Overall Progress has reached a new state
      ///                                 e.g. Display a message like "Begin calculating ReplayGain for %d files ..."
      ///  OnSynchAudioFile             : after saving ReplayGain-MetaData to the file (within this thread!)
      ///                                 Properties of the actual AudioFile-Object should be set in VCL-Context
      ///  OnSynchWriteMetaDataProgress : For some operations, it makes sense to update MetaData in multiples files after
      ///                                 the calculations are done. This is in most cases pretty fast, but when there is no
      ///                                 ID3v2Tag or not enough padding, the complete file must be rewritten. This may take a
      ///                                 while when calculating many files. Therefore this event.
      ///                                 e.g. refesh a ProgressBar
      ///
      property OnSynchMainProgress          : TRGMainProgressEvent read fSynchRGMainProgress write fSynchRGMainProgress;
      property OnSynchAudioFile             : TRGAudioFileSynchEvent read fOnSynchAudioFile write fOnSynchAudioFile;
      property OnSynchWriteMetaDataProgress : TRGProgressEvent read fSynchOnWriteMetaDataProgress write fSynchOnWriteMetaDataProgress;


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
    fPaths := TStringList.Create;
    fAlbums := TStringList.Create;

    fCurrentAlbumList := TStringList.Create;

    ReplayGainCalculator := TReplayGainCalculator.create;
    ReplayGainCalculator.OnStreamProgress     := fOnTrackProgress;
    ReplayGainCalculator.OnStreamInit         := fOnStreamInit;
    ReplayGainCalculator.OnSingleTrackComplete:= fOnSingleTrackComplete;
    ReplayGainCalculator.OnTrackComplete      := fOnTrackComplete;
    ReplayGainCalculator.OnAlbumComplete      := fOnAlbumComplete;
    ReplayGainCalculator.OnError              := fOnCalculationError;
end;

destructor TNempReplayGainCalculator.Destroy;
begin
    fPaths.Free;
    fAlbums.Free;
    fCurrentAlbumList.Free;
    ReplayGainCalculator.Free;
    fAudioFiles.Free;
    inherited;
end;



procedure TNempReplayGainCalculator.AddAudioFile(aAudioFile: TAudioFile);
begin
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
    SetLength(CurrentAlbumTrackGains, fCurrentAlbumList.Count);
    for i := 0 to Length(CurrentAlbumTrackGains)-1 do
        CurrentAlbumTrackGains[i] := 0;

    result := fCurrentAlbumList.Count;
end;

procedure TNempReplayGainCalculator.fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain: Double; Flags: Integer);
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
            if (Flags AND RG_ClearTrack) = RG_ClearTrack then localAudioFile.TrackGain := 0;
            if (Flags AND RG_SetAlbum)   = RG_SetAlbum   then localAudioFile.AlbumGain := aAlbumGain;
            if (Flags AND RG_ClearAlbum) = RG_ClearAlbum then localAudioFile.AlbumGain := 0;

            // Write Data into the metatags of the file
            aErr := localAudioFile.WriteReplayGainToMetaData(aTrackGain, aAlbumGain, Flags, True);
            //aErr:= localAudioFile.SetAudioData(True);

            if aErr <> AUDIOERR_None then
            begin
                ErrorLog := TErrorLog.create(afa_ReplayGain, localAudioFile, aErr, false);
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
///  Call the external Event Handlers
///  These methods MUST be called with Synchronize
///  -------------------------------------------------
procedure TNempReplayGainCalculator.DoSynchOnStreamInit;
begin
    fSynchOnStreamInit(ReplayGainCalculator, fCurrentErrorCode);
end;
procedure TNempReplayGainCalculator.DoSynchOnError;
begin
    fSynchOnError(ReplayGainCalculator, fCurrentErrorCode);
end;
procedure TNempReplayGainCalculator.DoSynchOnStreamProgress;
begin
    fSynchOnStreamProgress(ReplayGainCalculator, fCurrentProgress);
end;
procedure TNempReplayGainCalculator.DoSynchOnSingleTrackComplete;
begin
    fSynchOnSingleTrackComplete(ReplayGainCalculator, fCurrentIndex, ReplayGainCalculator.TrackGain, ReplayGainCalculator.PeakTrack);
end;
procedure TNempReplayGainCalculator.DoSynchOnTrackComplete;
begin
    fSynchOnTrackComplete(ReplayGainCalculator, fCurrentIndex, ReplayGainCalculator.TrackGain, ReplayGainCalculator.PeakTrack);
end;
procedure TNempReplayGainCalculator.DoSynchOnAlbumComplete;
begin
    fSynchOnAlbumComplete(ReplayGainCalculator, fCurrentIndex, ReplayGainCalculator.AlbumGain, ReplayGainCalculator.PeakAlbum);
end;

procedure TNempReplayGainCalculator.DoSynchOnWriteMetaDataProgress;
begin
    self.fSynchOnWriteMetaDataProgress(ReplayGainCalculator, fCurrentWriteMetaDataProgress);
end;

procedure TNempReplayGainCalculator.DoSynchAudioFile;
begin
    fOnSynchAudioFile(
        fAudioFiles[ fFileSynchOffset + fCurrentIndex ],
        CurrentAlbumTrackGains[fCurrentIndex],
        fAlbumGain
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
    if assigned(fSynchRGMainProgress) then
    begin
        fMainProgressData.AlbumName := AlbumName;
        fMainProgressData.FileCount := FileCount;
        fMainProgressData.Progress := Progress;
        Synchronize(DoSynchRGOverallProgress);
    end;
end;
procedure TNempReplayGainCalculator.DoSynchRGOverallProgress;
begin
    fSynchRGMainProgress(self, fMainProgressData.AlbumName, fMainProgressData.FileCount, fMainProgressData.Progress);
end;


///  -------------------------------------------------
///  Internal Event Handlers
///  Do some internal stuff, and call external EventHandlers, if they're assigned
///  -------------------------------------------------
procedure TNempReplayGainCalculator.fOnStreamInit(
  aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
begin
    // prepare external event Handler (progress display ...)
    fCurrentErrorCode := ErrorCode;
    //
    if assigned(fSynchOnStreamInit) then
        Synchronize(DoSynchOnStreamInit);
end;

procedure TNempReplayGainCalculator.fOnCalculationError(
  aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
begin
    // prepare external event Handler (progress display ...)
    fCurrentErrorCode := ErrorCode;
    if assigned(fSynchOnError) then
        Synchronize(DoSynchOnError);
end;

procedure TNempReplayGainCalculator.fOnTrackProgress(
  Sender: TReplayGainCalculator; aProgress: Single);
begin
    // prepare external event Handler (progress display ...)
    fCurrentProgress := aProgress;
    if assigned(fSynchOnStreamProgress) then
        Synchronize(DoSynchOnStreamProgress);
end;

procedure TNempReplayGainCalculator.fOnSingleTrackComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double;
  aPeak: SmallInt);
begin
    // prepare external event Handler (progress display ...)
    fCurrentIndex := aIndex; // is always 0 on "SingleTrackComplete"
    if assigned(fSynchOnSingleTrackComplete) then
        Synchronize(DoSynchOnSingleTrackComplete);
end;

procedure TNempReplayGainCalculator.fOnTrackComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double;
  aPeak: SmallInt);
begin
    // handle this internally, we have more work to do
    CurrentAlbumTrackGains[aIndex] := aGain;
    // prepare external event Handler (progress display ...)
    fCurrentIndex := aIndex;    /// INDEX des TReplayGainCalculator-Objectes.
                                /// NICHT der INdex des Audiofiles in der (globalen) ThreadListe !!!

    //
    if assigned(fSynchOnTrackComplete) then
        Synchronize(DoSynchOnTrackComplete);
end;

procedure TNempReplayGainCalculator.fOnAlbumComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double;
  aPeak: SmallInt);
begin
    // now set all fCurrentAlbumTrackGains
    // todo ...

    // prepare external event Handler (progress display ...)
    fCurrentIndex := aIndex;
    //
    if assigned(fSynchOnAlbumComplete) then
        Synchronize(DoSynchOnAlbumComplete);
end;

procedure TNempReplayGainCalculator.ExecuteSingleTracks;
var i: Integer;
begin
    fFileSynchOffset := 0;
    if fAudioFiles.Count > 0 then
    begin
        // prepare the TrackGain-Value array
        SetLength(CurrentAlbumTrackGains, fAudioFiles.Count);
        for i := 0 to Length(CurrentAlbumTrackGains)-1 do
            CurrentAlbumTrackGains[i] := 0;

        //SetLength(CurrentAlbumTrackGains, 1);
        //CurrentAlbumTrackGains[0] := 0;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartCalculationSingleTracks);

        for i := 0 to fPaths.Count - 1 do
        begin
            // calculate TrackGain
            CurrentAlbumTrackGains[i] := ReplayGainCalculator.CalculateTrackGain(fPaths[i], i);

            // Calculation complete, notify MainThread, // NO, not here.
            // HandleMainProgress('', 1, RGStatus_StartSync);

            fCurrentIndex := i;
            // Update MetaData
            if not isZero(CurrentAlbumTrackGains[i]) then
                fUpdateMetaData(fPaths[i], CurrentAlbumTrackGains[i], 0, RG_SetTrack);
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

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
        SetLength(CurrentAlbumTrackGains, fAudioFiles.Count);
        for i := 0 to Length(CurrentAlbumTrackGains)-1 do
            CurrentAlbumTrackGains[i] := 0;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartCalculationSingleAlbum);

        // calculate TrackGain + AlbumGain
        fAlbumGain := ReplayGainCalculator.CalculateAlbumGain(fPaths);

        // Calculation complete, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartSync);

        Flags := RG_SetTrack;
        if NOT ReplayGainCalculator.AlbumGainCalculationFailed then
            Flags := RG_SetBoth;

        // Write the Data into the MetaTags of the Files
        for i := 0 to fPaths.Count - 1 do
        begin
            fCurrentIndex := i;
            // Update MetaData
            if not isZero(CurrentAlbumTrackGains[i]) then
                fUpdateMetaData(fPaths[i], CurrentAlbumTrackGains[i], fAlbumGain, Flags);

            if assigned(fSynchOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fPaths.Count;
                DoSynchOnWriteMetaDataProgress;
            end;
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

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
    while FilesDone < fAudioFiles.Count do
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
        fAlbumGain := ReplayGainCalculator.CalculateAlbumGain(self.fCurrentAlbumList);

        // Calculation complete, notify MainThread
        HandleMainProgress(fCurrentAlbum, NewAlbumCount, RGStatus_StartSync);

        Flags := RG_SetTrack;
        if NOT ReplayGainCalculator.AlbumGainCalculationFailed then
            Flags := RG_SetBoth;

        // Write the Data into the MetaTags of the Files (threaded, using Message-concept with CurrentThreadFilename) and
        // set the values in the Audiofile-Objects (another synchronize- job. Also an additional handler , to change all copies of the audiofile)
        fFileSynchOffset := FilesDone;
        for i := 0 to fCurrentAlbumList.Count - 1 do
        begin
            fCurrentIndex := i;
            // Update MetaData, similar to UpdateTags in Medialibrary for the TagCloud-stuff
            if not isZero(CurrentAlbumTrackGains[i])  then
                fUpdateMetaData(fCurrentAlbumList[i], CurrentAlbumTrackGains[i], fAlbumGain, Flags);

            if assigned(fSynchOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fCurrentAlbumList.Count;
                DoSynchOnWriteMetaDataProgress;
            end;
        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        // File Synch complete, notify MainThread
        FilesDone := FilesDone + NewAlbumCount;
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
        // this array is needed in DoSynchAudioFile
        SetLength(CurrentAlbumTrackGains, fAudioFiles.Count);
        for i := 0 to Length(CurrentAlbumTrackGains)-1 do
            CurrentAlbumTrackGains[i] := 0;

        // Starting calculation, notify MainThread
        HandleMainProgress('', fAudioFiles.Count, RGStatus_StartDeleteValues);

        for i := 0 to fPaths.Count - 1 do
        begin
            fCurrentIndex := i;
            // Update MetaData
            fUpdateMetaData(fPaths[i], 0, 0, RG_ClearBoth);

            if assigned(fSynchOnWriteMetaDataProgress)  then
            begin
                fCurrentWriteMetaDataProgress := (i+1) / fPaths.Count;
                DoSynchOnWriteMetaDataProgress;
            end;

        end;
        // clear thread-used filename
        SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

        // Fily Synch complete, notify MainThread
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




(*
procedure TNempReplayGainCalculator.fSortAudioFiles;
begin
    // !!!!! Checken, ob das überhaupt sinnvoll ist .....
    // !!!!!!!!!!!!!!!!
    // in den VCL Thread verlagern? Sonst muss man Bib (fast) komplett sperren ....
    //!!!!!!!!!!!!!!!

    fAudioFiles.Sort(TComparer<TAudioFile>.Construct(
        function(const a1, a2: TAudioFile): integer
        begin
            Result := AnsiCompareText(a1.Album, a2.Album)
        end
    ));
end;
*)



end.
