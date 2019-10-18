unit NempReplayGainCalculation;

interface

uses
  Winapi.Windows, System.Classes, System.Contnrs, System.SysUtils, Generics.Collections, Generics.Defaults,
  NempAudioFiles, ReplayGainAnalysis, Nemp_ConstantsAndTypes;

type

  TAudioFileList = class(TObjectList<TAudioFile>);


  TRGAudioFileSynchEvent = Procedure(aFile: TAudioFile; aTrackGain, aAlbumGain: Double) of Object;

  TNempReplayGainCalculator = class(TThread)
  private
      { Private declarations }
      fAudioFiles: TAudioFileList;
      fPaths: TStringList;
      fAlbums: TStringList;

      ReplayGainCalculator: TReplayGainCalculator;


      fCurrentAlbumList: TStringList;

      fSynchOnStreamInit          : TRGEvent;
      fSynchOnError               : TRGEvent;
      fSynchOnStreamProgress      : TRGProgressEvent;
      fSynchOnSingleTrackComplete : TRGCompleteEvent;
      fSynchOnTrackComplete       : TRGCompleteEvent;
      fSynchOnAlbumComplete       : TRGCompleteEvent;

      fFileSynchOffset : Integer;
      fAlbumGain       : Double ;
      fOnSynchAudioFile: TRGAudioFileSynchEvent;

      fCurrentProgress  : Single  ;
      fCurrentIndex     : Integer ;
      fcurrentPeak      : Integer ;
      fCurrentGain      : Double  ;
      fCurrentErrorCode : Integer ;

      procedure DoSynchOnStreamInit          ;
      procedure DoSynchOnError               ;
      procedure DoSynchOnStreamProgress      ;
      procedure DoSynchOnSingleTrackComplete ;
      procedure DoSynchOnTrackComplete       ;
      procedure DoSynchOnAlbumComplete       ;

      procedure DoSynchAudioFile ;

      // internal EventHandler
      Procedure fOnStreamInit(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);
      procedure fOnTrackProgress(Sender: TReplayGainCalculator; aProgress: Single);
      procedure fOnSingleTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnTrackComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnAlbumComplete(aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double; aPeak: SmallInt);
      procedure fOnCalculationError(aReplayGainCalculator: TReplayGainCalculator; ErrorCode: Integer);

      //procedure fSortAudioFiles;

      function fPrepareNextAlbum(StartIndex: Integer): Integer;

      procedure fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain: Double);

  protected
      procedure Execute; override;

  public

      MainWindowHandle: DWord;
      CurrentAlbumTrackGains: Array of Single;

      property OnSynchStreamInit          : TRGEvent read fSynchOnStreamInit write fSynchOnStreamInit;
      property OnSynchError               : TRGEvent read fSynchOnError write fSynchOnError;
      property OnSynchStreamProgress      : TRGProgressEvent read fSynchOnStreamProgress write fSynchOnStreamProgress;
      property OnSynchSingleTrackComplete : TRGCompleteEvent read fSynchOnSingleTrackComplete write fSynchOnSingleTrackComplete;
      property OnSynchTrackComplete       : TRGCompleteEvent read fSynchOnTrackComplete write fSynchOnTrackComplete;
      property OnSynchAlbumComplete       : TRGCompleteEvent read fSynchOnAlbumComplete write fSynchOnAlbumComplete;

      property OnSynchAudioFile: TRGAudioFileSynchEvent read fOnSynchAudioFile write fOnSynchAudioFile;

      constructor Create;
      destructor Destroy; override;

      procedure AddAudioFile(aAudioFile: TAudioFile);

  end;

implementation

{ 
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);  

  and UpdateCaption could look like,

    procedure TNempReplayGainCalculator.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; 
    
    or 
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method' 
      end
      )
    );
    
  where an anonymous method is passed.
  
  Similarly, the developer can call the Queue method with similar parameters as 
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.
    
}

{ TNempReplayGainCalculator }

constructor TNempReplayGainCalculator.Create;
begin
    inherited create(True);

    FreeOnTerminate := True;

    fAudioFiles := TAudioFileList.Create(False);  // Do NOT owns the objects!
    fPaths := TStringList.Create;
    fAlbums := TStringList.Create;

    fCurrentAlbumList := TStringList.Create;

    ReplayGainCalculator := TReplayGainCalculator.create;
    ReplayGainCalculator.OnStreamProgress := fOnTrackProgress;
    ReplayGainCalculator.OnStreamInit     := fOnStreamInit;
    ReplayGainCalculator.OnSingleTrackComplete  := fOnSingleTrackComplete;

    ReplayGainCalculator.OnTrackComplete := fOnTrackComplete;
    ReplayGainCalculator.OnAlbumComplete := fOnAlbumComplete;

    ReplayGainCalculator.OnError := fOnCalculationError;
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

procedure TNempReplayGainCalculator.fUpdateMetaData(aFile: String; aTrackGain, aAlbumGain: Double);
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
            // set Gain values
            localAudioFile.TrackGain := aTrackGain;
            localAudioFile.AlbumGain := aAlbumGain;
            // Write Data back to the file
            aErr:= localAudioFile.SetAudioData(True);

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
    fSynchOnSingleTrackComplete(ReplayGainCalculator, fCurrentIndex, fCurrentGain, fCurrentPeak);
end;
procedure TNempReplayGainCalculator.DoSynchOnTrackComplete;
begin
    fSynchOnTrackComplete(ReplayGainCalculator, fCurrentIndex, fCurrentGain, fCurrentPeak);
end;
procedure TNempReplayGainCalculator.DoSynchOnAlbumComplete;
begin
    fSynchOnAlbumComplete(ReplayGainCalculator, fCurrentIndex, fCurrentGain, fCurrentPeak);
end;

procedure TNempReplayGainCalculator.DoSynchAudioFile;
begin
    fOnSynchAudioFile(
        fAudioFiles[ fFileSynchOffset + fCurrentIndex ],
        CurrentAlbumTrackGains[fCurrentIndex],
        fAlbumGain
    );
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


    // do something with aReplayGainCalculator.CurrentFilename;
    // Create Errorlog ?

    //
    if assigned(fSynchOnError) then
        Synchronize(DoSynchOnError);
end;

procedure TNempReplayGainCalculator.fOnTrackProgress(
  Sender: TReplayGainCalculator; aProgress: Single);
begin

    // prepare external event Handler (progress display ...)
    fCurrentProgress := aProgress;
    //
    if assigned(fSynchOnStreamProgress) then
        Synchronize(DoSynchOnStreamProgress);
end;

procedure TNempReplayGainCalculator.fOnSingleTrackComplete(
  aReplayGainCalculator: TReplayGainCalculator; aIndex: Integer; aGain: Double;
  aPeak: SmallInt);
begin

    // prepare external event Handler (progress display ...)
    fCurrentIndex := aIndex;
    fCurrentGain  := aGain;
    fCurrentPeak  := aPeak;
    //
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
    fCurrentGain  := aGain;
    fCurrentPeak  := aPeak;
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
    fCurrentGain  := aGain;  // this is the AlbumGain now!
    fCurrentPeak  := aPeak;
    //
    if assigned(fSynchOnAlbumComplete) then
        Synchronize(DoSynchOnAlbumComplete);
end;




procedure TNempReplayGainCalculator.Execute;
var FilesDone: Integer;
    NewAlbumCount, i: Integer;

begin

        FilesDone := 0;
        while FilesDone < fAudioFiles.Count do
        begin
            // collect file for the next album
            NewAlbumCount := fPrepareNextAlbum(FilesDone);

            // 1.) calculate TrackGain + AlbumGain for this Album
            fAlbumGain := ReplayGainCalculator.CalculateAlbumGain(self.fCurrentAlbumList);

            // 2.) Write the Data into the MetaTags of the Files (threaded, using Message-concept with CurrentThreadFilename) and
            //     set the values in the Audiofile-Objects (another synchronize- job. Also an additional handler , to change all copies of the audiofile)
            fFileSynchOffset := FilesDone;
            for i := 0 to fCurrentAlbumList.Count - 1 do
            begin
                self.fCurrentIndex := i;
                // Update MetaData, similar to UpdateTags in Medialibrary for the TagCloud-stuff
                fUpdateMetaData(fCurrentAlbumList[i], CurrentAlbumTrackGains[i], fAlbumGain);
            end;
            // clear thread-used filename
            SendMessage(MainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate, Integer(PWideChar('')));

            FilesDone := FilesDone + NewAlbumCount;
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
