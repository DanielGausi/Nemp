{

    Unit PostProcessorUtils

    - Collect Information during playback (called from NempPlayer)
    - Do something with the file after playing
      e.g. Scrobbling
           Change Rating
           Increase Playcounter

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

unit PostProcessorUtils;

interface

uses Windows, Classes, SysUtils, Contnrs, DateUtils,
      ShellApi, IniFiles,  Dialogs,   math,
      NempAudioFiles, Nemp_ConstantsAndTypes,
      AudioFiles.Base,
      gnuGettext, Nemp_RessourceStrings,
      ScrobblerUtils, CustomizedScrobbler;

// same as in Player.pas
const USER_WANT_PLAY = 1;
      USER_WANT_STOP = 2;

      LOG_SEPARATOR = '|';

type

    TPostProcessor = class; // forward declaration

    TNempLogEntry = class
        private
            fStartTime   : TDateTime;
            fTitle       : UnicodeString;
            fArtist      : UnicodeString;
            //fArtistTitle : UnicodeString;
            fFilename    : UnicodeString;

            fAborted: Boolean;
            fInvalid: Boolean;

        public
            property StartTime   : TDateTime     read fStartTime    ;
            property Title       : UnicodeString read fTitle        ;
            property Artist      : UnicodeString read fArtist       ;
            //property ArtistTitle : UnicodeString read fArtistTitle  ;
            property Filename    : UnicodeString read fFilename     ;

            property Aborted: Boolean read fAborted write fAborted;
            property Invalid: Boolean read fInvalid;

            constructor create(currentAudioFile: TAudioFile); overload;
            constructor create(aLogString: UnicodeString); overload;

            function LogLineDateTime(settings: TFormatSettings) : UnicodeString; overload;

    end;

    TNempLogFile = class
        private
            fLogList: TObjectList;
            fPreviousSessionList: TObjectList;

            fPreviousLogListAlreadyLoaded: Boolean;
            fLocalFormatSettings: TFormatSettings;

            fCurrentLogEntry: TNempLogEntry;
            fMainWindowHandle: Hwnd;

            // settings
            fDoLogToFile         : Boolean;
            fAutoDeleteOldEntries: Boolean;
            fKeepLogRangeInDays  : Integer;
            procedure fSetLogRange(aValue: Integer);

            function fFirstIndexToKeepFromPreviousLogList(aFilename: UnicodeString): Integer;
            procedure fMergeCurrentSessionIntoLogFile(aFilename: UnicodeString; FirstKeepIdxFromPreviousSession: Integer);

        public
            property DoLogToFile         : Boolean read fDoLogToFile          write fDoLogToFile          ;
            property AutoDeleteOldEntries: Boolean read fAutoDeleteOldEntries ;
            property KeepLogRangeInDays  : Integer read fKeepLogRangeInDays   write fSetLogRange   ;

            property LogList: TObjectList read fLogList;
            property PreviousSessionList: TObjectList read fPreviousSessionList;

            constructor create(aHandle: HWND);
            destructor Destroy; override;

            procedure LoadFromIni(Ini: TMemIniFile);
            procedure WriteToIni(Ini: TMemIniFile);

            //procedure ShowCurrentLogList(aLines: TStrings);
            // open the LogFile and create proper Logentries from the textfile.
            // done only when needed (= user action in the player-log-form)
            procedure PreparePreviousLogList(aFilename: UnicodeString);

            procedure UpdateLogfile(aFilename: UnicodeString);
            // add the current Loglist to the logfile (when nemp is closing)




            //
            procedure ChangeCurrentPlayingFile(aAudioFile: TAudioFile);
            procedure FinalizeCurrentLogEntry(PlayedLongEnough: Boolean);
            // Add the currentplayingfile to the loglist (if it makes sense)
            // Do log entries like "aborted" ?
            //procedure DoLog;
    end;

    // Types used in the VirtualStringTree of the Player Log Form
    TLogTreeData = record
      FLogEntry : TNempLogEntry;
    end;

    PLogTreeData = ^TLogTreeData;

    TPostProcessJob = class
        private
            fFilename: String;

            // if the user edits the PlayingFile-Rating, we should set THIS
            // value in Postprocessing. No inc/decreasing of rating in this case.
            fManualRating: Boolean;
            // Nemp tries to modify the file in library instantly
            // if this can be done (i.e. library is not busy)
            // it should not be done at the end again.


            // Write new values into ID3-Tag
            // Setting from NempOptions.AllowQuickAccessToMetadata
            fWriteToFiles: Boolean;
            // 2. Counter
            // Inc PlayCounter after Playback
            fChangeCounter: Boolean;
            // ... but not when the track was aborted to fast
            // (nonsense???) fIgnoreCounterOnAbortedTracks: Boolean;
            // 3. Ratings
            // Increase rating on played files
            fIncPlayedFiles: Boolean;
            // Decrease rating on aborted files
            fDecAbortedFiles: Boolean;

            fUserStoppedThePlayer: Boolean;

            FileWasPlayedLongEnough: Boolean;

            fAudioFile: TAudioFile;
             // Change the rating of an Audiofile as specified in aJob
            procedure ChangeRating;
            // Change the PlayCounter of an Audiofile as specified in aJob
            procedure ChangePlayCounter;
            // Update the File on Harddisk
            function UpdateFile: TNempAudioError;

        public
            //constructor Create(filename: String; IncCounter: Boolean; AddRating: Integer);
            // besser:
            Constructor Create(parent: TPostProcessor);
    end;



    TPostProcessor = class
        private
            StartTimeLocal: TDateTime;
            PlayAmount: Integer; // in Seconds

            // if the user Stops the player, the current track
            // is not assumed as "aborted", so its rating will not be decreased
            fUserStoppedThePlayer: Boolean;

            // We do not need the AudioFile-Object here.
            // In Playlist it could be deleted (so we would have to store a copy)
            // and in the library we have to search it anyway by its filename.
            fPlayingFileName: String;
            fPlayingFileLength: Integer;

            fManualRating: Boolean;

            // We start the Postprocessing in Player.StopAndFree.
            // sometimes this method is called twice, but we do not want
            // do process this file twice. ;-)
            fCurrentFileAdded: Boolean;

            // Stores the files for postprocessing
            fJobList: TObjectList;
            // a Copy of this List, used in the Thread.
            // the Main-Thread needs to copy the fJobList
            fThreadJobList: TObjectList;

            // Settings
            // 1. general settings
            fActive: Boolean;              // Postprocess at all?
            fIgnoreShortFiles: Boolean;    // Ignore short files (i.e. < 30 seconds)
            fWriteToFiles: Boolean;        // Write new values into ID3-Tag
            // 2. Counter
            fChangeCounter: Boolean;                 // Inc PlayCounter after Playback
            // fIgnoreCounterOnAbortedTracks: Boolean;  // ... but not when the track was aborted to fast
            // 3. Ratings
            fIncPlayedFiles: Boolean;    // Increase rating on played files
            fDecAbortedFiles: Boolean;   // Decrease rating on aborted files

            fHND_ProcessThread: DWord;
            fMainWindowHandle: Hwnd;

            // when Nemp is closing, no postprocessing is wanted.
            // The program should be closed as fast as possible.
            fNempIsClosing: LongBool;

            procedure DoJobList;

            procedure SetClosing(Value: LongBool);
            function GetClosing: LongBool;

        public
            // The Scrobbler here is just a pointer to Player.NempScrobbler
            NempScrobbler: TNempScrobbler;
            // Nemplogfile also. Just a Pointer to Plaer.NempLogFile
            NempLogFile: TNempLogFile;

            // Vairable: NempIsClosing, die den ganzen Quatsch abbricht???

            // Settings
            // 1. general settings
            // Postprocess at all?
            property Active: Boolean read fActive write fActive ;
            // Ignore short files?
            property IgnoreShortFiles: Boolean read fIgnoreShortFiles write fIgnoreShortFiles;
            // Write new values into ID3-Tag
            property WriteToFiles: Boolean read fWriteToFiles write fWriteToFiles;
            // 2. Counter
            // Inc PlayCounter after Playback
            property ChangeCounter: Boolean read fChangeCounter write fChangeCounter;
            // ... but not when the track was aborted to fast
            // property IgnoreCounterOnAbortedTracks: Boolean read fIgnoreCounterOnAbortedTracks write fIgnoreCounterOnAbortedTracks;
            // 3. Ratings
            // Increase rating on played files
            property IncPlayedFiles: Boolean read fIncPlayedFiles write fIncPlayedFiles;
            // Decrease rating on aborted files
            property DecAbortedFiles: Boolean read fDecAbortedFiles write fDecAbortedFiles;

            property UserStoppedThePlayer: Boolean read fUserStoppedThePlayer write fUserStoppedThePlayer;

            property NempIsClosing: LongBool read GetClosing write SetClosing;

            property ManualRating: Boolean read fManualRating write fManualRating;
            //property ManualRatingAlreadySet: Boolean read fManualRatingAlreadySet write fManualRatingAlreadySet;

            constructor Create(aHandle: HWND);
            destructor Destroy; override;

            procedure LoadFromIni(Ini: TMemIniFile);
            procedure WriteToIni(Ini: TMemIniFile);

            // methods for counting how long the file was played
            procedure PlaybackStarted;
            procedure PlaybackPaused;
            procedure PlaybackResumed;

            procedure ChangeCurrentPlayingFile(aAudioFile: TAudioFile); // setzt das aktuelle Audiofile um und scrobbelt es ggf.

            // Process Data. Scrobble, change file, whatever.
            function Process(IsJustPlaying: Boolean): Boolean; // result: hinzugefügt oder nicht

    end;

    procedure fDoJobList(ap: TPostProcessor);

implementation

uses NempMainUnit, Hilfsfunktionen;


{ TNempLogEntry }

constructor TNempLogEntry.create(currentAudioFile: TAudioFile);
begin
    if assigned(currentAudioFile) then
    begin
        fStartTime  := Now;
        fTitle      := currentAudioFile.Titel;
        fArtist     := currentAudioFile.Artist;
        //fArtistTitle := currentAudioFile.PlaylistTitle;
        fFilename   := currentAudioFile.Pfad;

        fAborted := False;
        fInvalid := False;
    end else
        fInvalid := True;
end;


constructor TNempLogEntry.create(aLogString: UnicodeString);
var sl: TStringList;
    aDateTime: TDateTime;
begin
    // explode the String, fill fields
    sl := TStringList.Create;
    try
        Explode(LOG_SEPARATOR , aLogString, sl);
        if sl.Count >= 4 then
        begin
            if TryStrToDateTime(sl[0], aDateTime) then
            begin
                fStartTime  := aDateTime;
                fArtist     := sl[1];
                fTitle      := sl[2];
                fFilename   := sl[3];
                fInvalid    := False;
            end else
                fInvalid := True;
        end else
            fInvalid := True;

        if sl.Count >=5 then
            self.fAborted := sl[4] = 'aborted'
        else
            fAborted := False;
    finally
        sl.Free;
    end;
end;


function TNempLogEntry.LogLineDateTime(settings: TFormatSettings): UnicodeString;
begin
    result := DateTimeToStr(fStartTime, settings) + LOG_SEPARATOR
          + StringReplace( fArtist, LOG_SEPARATOR, ',', [rfReplaceAll]) + LOG_SEPARATOR
          + StringReplace( fTitle , LOG_SEPARATOR, ',', [rfReplaceAll]) + LOG_SEPARATOR
          + fFilename;

    if fAborted then
        result := result + LOG_SEPARATOR + 'aborted';   // fixed string here, do not translate
end;

{ TNempLogFile }

constructor TNempLogFile.create(aHandle: HWND);
begin
    fLogList := TObjectList.Create(True);
    fPreviousSessionList := TObjectList.Create(True);
    fPreviousLogListAlreadyLoaded := False;

    fMainWindowHandle := aHandle;
    fCurrentLogEntry := Nil;
    //GetLocaleFormatSettings(LOCALE_USER_DEFAULT, fLocalFormatSettings);
    fLocalFormatSettings := TFormatSettings.Create;
end;

destructor TNempLogFile.destroy;
begin
    fLogList.Free;
    fPreviousSessionList.Free;
    inherited;
end;


procedure TNempLogFile.LoadFromIni(Ini: TMemIniFile);
begin
    DoLogToFile          := Ini.ReadBool('NempLogFile', 'DoLogToFile'           , False);
    KeepLogRangeInDays   := Ini.ReadInteger('NempLogFile', 'KeepLogRangeInDays' , 7);
end;

procedure TNempLogFile.WriteToIni(Ini: TMemIniFile);
begin
    Ini.WriteBool('NempLogFile', 'DoLogToFile'           , fDoLogToFile          );
    Ini.WriteInteger('NempLogFile', 'KeepLogRangeInDays' , fKeepLogRangeInDays   );
end;

procedure TNempLogFile.ChangeCurrentPlayingFile(aAudioFile: TAudioFile);
begin
    // create new log entry and ad it to the loglist
    fCurrentLogEntry := TNempLogEntry.create(aAudioFile);
    fLogList.add(fCurrentLogEntry);
    // Message to refresh "live" log in the window
    SendMessage(fMainWindowHandle, WM_MedienBib, MB_AddNewLogEntry, LParam(fCurrentLogEntry));
end;

procedure TNempLogFile.FinalizeCurrentLogEntry(PlayedLongEnough: Boolean);
begin
    if assigned(fCurrentLogEntry) then
    begin
        fCurrentLogEntry.Aborted := Not PlayedLongEnough;
        // Message to refresh "live" log in the window
        SendMessage(fMainWindowHandle, WM_MedienBib, MB_EditLastLogEntry, LParam(fCurrentLogEntry));
    end;
end;

 procedure TNempLogFile.fSetLogRange(aValue: Integer);
begin
    fKeepLogRangeInDays := aValue;
    fAutoDeleteOldEntries := aValue > 0;
end;

procedure TNempLogFile.PreparePreviousLogList(aFilename: UnicodeString);
var sl: TStringList;
    i: Integer;
    newLogEntry: TNempLogEntry;
begin
    if Not FileExists(aFilename) then
        exit;

    if fPreviousLogListAlreadyLoaded then
        exit;

    // do this only once per session
    fPreviousLogListAlreadyLoaded := True;
    sl := TStringList.Create;
    try
        sl.LoadFromFile(aFilename);
        for i := 0 to sl.Count-1 do
        begin
            newLogEntry := TNempLogEntry.create(sl[i]);
            if not newLogEntry.Invalid then
                fPreviousSessionList.Add(newLogEntry)
            else
              FreeAndNil(newLogEntry);
        end;
    finally
        sl.free;
    end;
end;


function TNempLogFile.fFirstIndexToKeepFromPreviousLogList(aFilename: UnicodeString): Integer;
var firstKeepIdx: Integer;
    aLogEntry: TNempLogEntry;
    currentDate: TDateTime;
begin
    // load old logs (if still necessary)
    PreparePreviousLogList(aFilename);

    if fPreviousSessionList.Count > 0 then
    begin
        aLogEntry := TNempLogEntry(fPreviousSessionList[0]);
        firstKeepIdx := 0;
        currentDate := DateOf(Now);
        while (firstKeepIdx < fPreviousSessionList.Count - 1)
              and (DaysBetween(DateOf(aLogEntry.StartTime), currentDate) > KeepLogRangeInDays)
        do begin
            inc(firstKeepIdx);
            aLogEntry := TNempLogEntry(fPreviousSessionList[firstKeepIdx]);
        end;
        result := firstKeepIdx;
    end else
        result := -1;
end;

procedure TNempLogFile.fMergeCurrentSessionIntoLogFile(aFilename: UnicodeString; FirstKeepIdxFromPreviousSession: Integer);
var newLog: TStringList;
    i: Integer;
begin
    ///  PreparePreviousLogList or better FirstIndexToKeepFromPreviousLogList must be called earlier
    ///  param FirstKeepIdxFromPreviousSession is the first log entry (in fPreviousSessionList) to keep
    ///  Older entries will NOT be saved then.

    newLog := TStringList.Create;
    try
        // write old logs, but discard too old entries
        if fPreviousSessionList.Count > 0 then
            for i := FirstKeepIdxFromPreviousSession to fPreviousSessionList.Count-1 do
                newLog.Add(TNempLogEntry(fPreviousSessionList[i]).LogLineDateTime(fLocalFormatSettings));
        // log from the current session
        for i := 0 to fLogList.Count-1 do
            newLog.Add(TNempLogEntry(fLogList[i]).LogLineDateTime(fLocalFormatSettings));

        newLog.SaveToFile(aFilename);
    finally
        newLog.Free;
    end;
end;


procedure TNempLogFile.UpdateLogfile(aFilename: UnicodeString);
var aIdx: Integer;
begin
    if fDoLogToFile then
    begin
        if fKeepLogRangeInDays > 0 then
            aIdx := fFirstIndexToKeepFromPreviousLogList(aFilename)
        else
            aIdx := 0;

        fMergeCurrentSessionIntoLogFile(aFilename, aIdx);
    end;
end;


{ TPostProcessJob }

constructor TPostProcessJob.Create(parent: TPostProcessor);
//Create(filename: String; IncCounter: Boolean; AddRating: Integer);
begin
    // copy the current settings of the PostProcessor to this job
    // So the job will be done with the current settings.
    // Not with the settings as they are when the job is done.
    // (this is at least imprtant for "fUserStoppedThePlayer")
    fFilename := parent.fPlayingFileName;

    fWriteToFiles := parent.WriteToFiles;

    fChangeCounter := parent.ChangeCounter;
    //fIgnoreCounterOnAbortedTracks := parent.IgnoreCounterOnAbortedTracks;

    fIncPlayedFiles := parent.IncPlayedFiles;
    fDecAbortedFiles := parent.DecAbortedFiles;

    fManualRating           := parent.fManualRating;
    //fManualRatingAlreadySet := parent.fManualRatingAlreadySet;

    fUserStoppedThePlayer := Parent.UserStoppedThePlayer;
end;

procedure TPostProcessJob.ChangeRating;
var CurrentRating, CurrentCount: Integer;
begin
    if fAudioFile.Rating = 0 then
        CurrentRating := 127
    else
        CurrentRating := fAudioFile.Rating;
    CurrentCount := fAudioFile.PlayCounter;

    if fManualRating then
    begin
        //if (not fManualRatingAlreadySet) then
        //begin
        //    fAudioFile.Rating := fManualRating;   // no change needed
        //end; // else: Manualrating was written to File before
             // do not write again, AND do not inc/dec the manual rating (this time)
    end  else
    begin
        if FileWasPlayedLongEnough then
        begin
            if fIncPlayedFiles then
            begin
                fAudioFile.Rating := CurrentRating
                                + Round((255 - CurrentRating) / (4*sqrt(CurrentCount+1) + 2));
                //ShowMessage('Rating increased to ' + IntToStr(fAudioFile.Rating));
            end;
        end else
        begin
            // Note: The "Nemp-Star-System" will give zero stars for Ratings below 25
            //       We do not want to fall below 1/2 star.
            if fDecAbortedFiles and (CurrentRating >= 25)
               and (not fUserStoppedThePlayer)
            then
            begin
                fAudioFile.Rating := CurrentRating
                                   - Round((CurrentRating - 25) / (4*sqrt(CurrentCount+1) + 2));
                //ShowMessage('Rating decreased to ' + IntToStr(fAudioFile.Rating));
            end;
        end;
    end;
end;

procedure TPostProcessJob.ChangePlayCounter;
begin
    if fChangeCounter then
    begin
        if FileWasPlayedLongEnough then // or (not fIgnoreCounterOnAbortedTracks) then
            fAudioFile.PlayCounter := fAudioFile.PlayCounter + 1;
    end;
end;

function TPostProcessJob.UpdateFile: TNempAudioError;
var currentRating: Byte;
    currentPlayCounter: Integer;
begin
    if fWriteToFiles then
    begin
        // fix 2019, Nemp 4.12
        // if the file was uncompletely loaded in the media library (for whatever reasons),
        // or the file was updated by another software in the meantime (since adding it to the library),
        // the previous code removed potentially huge parts of the ID3-Tag.
        // therefore: Reload the meta data from the file, and set only the changed values here again
        // 1. backup the new values
        currentRating      := fAudioFile.Rating      ;
        currentPlayCounter := fAudioFile.PlayCounter ;
        // 2. read all fileinfo from the file (and store it into the "NempAudioFile"-Structure
        fAudioFile.GetAudioData(fAudioFile.Pfad);
        // 3. set the recently calculated values again
        fAudioFile.Rating      := currentRating      ;
        fAudioFile.PlayCounter := currentPlayCounter ;
        // 4. actually update the file
        // (yes, this involves another "readfromfile" ...)
        {result := }fAudioFile.WriteRatingsToMetaData(currentRating, True);
        result := fAudioFile.WritePlayCounterToMetaData(currentPlayCounter, True);
        ////result := fAudioFile.SetAudioData(fWriteToFiles);
    end
    else
        result := AUDIOERR_EditingDenied;
end;



{ TPostProcessor }


constructor TPostProcessor.Create(aHandle: HWND);
begin
    fJobList := TObjectList.Create(False);
    fThreadJobList := TObjectList.Create;
    fCurrentFileAdded := False;
    fMainWindowHandle := aHandle;
    fHND_ProcessThread := 0;
    fNempIsClosing := False;
end;

destructor TPostProcessor.Destroy;
begin
  WaitForSingleObject(fHND_ProcessThread, 1000);
  fJobList.Free;
  fThreadJobList.Free;
  inherited;
end;

procedure TPostProcessor.LoadFromIni(Ini: TMemIniFile);
begin
    fActive        := Ini.ReadBool('PostProcessor', 'Active', False);
    fIgnoreShortFiles := Ini.ReadBool('PostProcessor', 'IgnoreShortFiles', True);
    fChangeCounter := Ini.ReadBool('PostProcessor', 'ChangeCounter', True);
    fIncPlayedFiles  := Ini.ReadBool('PostProcessor', 'IncPlayedFiles', True);
    fDecAbortedFiles := Ini.ReadBool('PostProcessor', 'DecAbortedFiles', True);
end;
procedure TPostProcessor.WriteToIni(Ini: TMemIniFile);
begin
    Ini.WriteBool('PostProcessor', 'Active', fActive);
    Ini.WriteBool('PostProcessor', 'IgnoreShortFiles', fIgnoreShortFiles);
    Ini.WriteBool('PostProcessor', 'ChangeCounter', fChangeCounter);
    Ini.WriteBool('PostProcessor', 'IncPlayedFiles', fIncPlayedFiles);
    Ini.WriteBool('PostProcessor', 'DecAbortedFiles', fDecAbortedFiles);
end;

procedure TPostProcessor.SetClosing(Value: LongBool);
begin
    InterLockedExchange(Integer(fNempIsClosing), Integer(Value));
end;

function TPostProcessor.GetClosing: LongBool;
begin
    InterLockedExchange(Integer(Result), Integer(fNempIsClosing));
end;

procedure TPostProcessor.ChangeCurrentPlayingFile(aAudioFile: TAudioFile);
begin
    fPlayingFileName := aAudioFile.Pfad;
    fPlayingFileLength := aAudioFile.Duration;
    NempScrobbler.ChangeCurrentPlayingFile(aAudioFile);
    NempLogFile.ChangeCurrentPlayingFile(aAudioFile);
    fCurrentFileAdded := False;

    fManualRating := False;     // 0: undefined
    //fManualRatingAlreadySet := False;
end;

procedure TPostProcessor.PlaybackStarted;
begin
    StartTimeLocal := Now;
    PlayAmount := 0;
    NempScrobbler.PlaybackStarted;
end;



procedure TPostProcessor.PlaybackPaused;
begin
  PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);
  NempScrobbler.PlaybackPaused;
end;

procedure TPostProcessor.PlaybackResumed;
begin
    StartTimeLocal := Now;
    NempScrobbler.PlaybackResumed;
end;



function TPostProcessor.Process(IsJustPlaying: Boolean): Boolean;
var NewJob: TPostProcessJob;
    i: Integer;
begin
    result := True;
    if not fCurrentFileAdded then
    begin
        fCurrentFileAdded := True;
        if IsJustPlaying then
            PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);

        // first: Scrobble. This is done in a thread.
        // whether it is really scrobbled or cancelled will be decided there
        NempScrobbler.AddToScrobbleList(IsJustPlaying);
        // Finalize LogEntry: Add a "Aborted" flag, if the file was not "played"
        //                    (meaning: less than 50% and playtime less than 240 seconds)
        NempLogFile.FinalizeCurrentLogEntry(
                  (PlayAmount > 240) or (PlayAmount > (fPlayingFileLength Div 2)) );

        if fActive and (not self.NempIsClosing)       // user-settings
                   and (FileExists(fPlayingFileName)) // there could be non-existing files
                                                      // in the playlist, which are in the library.
                                                      // These should not be touched.
        then
        begin
            if fIgnoreShortFiles and (fPlayingFileLength < 30) then
                // do not add file to the joblist. File should be ignored.
            else
            begin
                // Ok, file is long enough or should NOT be ignored.

                NewJob := TPostProcessJob.Create(self);
                // decide, whether the file was played or aborted
                if ((PlayAmount > 240) or (PlayAmount > (fPlayingFileLength Div 2))) then
                    NewJob.FileWasPlayedLongEnough := True
                else
                    NewJob.FileWasPlayedLongEnough := False;

                fJobList.Add(NewJob);
            end;

            if fJobList.Count > 0 then
                DoJobList;
        end else
        begin
            // Postprocessing is not wanted (any more)
            // so we should clear the Queue (even if it is be empty in very most cases)
            for i := 0 to fJobList.Count - 1 do
                TPostProcessJob(fJobList[i]).Free;
            fJobList.Clear;
        end;
    end;
end;


procedure TPostProcessor.DoJobList;
var Dummy: Cardinal;
    i: Integer;
begin
    if (MedienBib.StatusBibUpdate > 0) then
        // MedienBib is busy. Do not start Update-Stuff.
        exit;

    // Ok, MedienBib is NOT busy (and fHND_ProcessThread is not working!)
    MedienBib.StatusBibUpdate := 1;

    // Fill the Thread-List with JobList
    for i := 0 to fJobList.Count - 1 do
        fThreadJobList.Add(fJobList.Items[i]);
    // clear the "VCL-Joblist"
    fJobList.Clear;

    // Start the Thread
    // for Testing: Just in the same thread
    fHND_ProcessThread := BeginThread(Nil, 0, @fDoJobList, Self, 0, Dummy);
    //fDoJobList(self);
end;



// This is a Thread-Procedure
// Access only the fThreadJobList
procedure fDoJobList(ap: TPostProcessor);
var i: Integer;
    aJob: TPostProcessJob;
    aAudioFile: TAudioFile;
    aErr: TNempAudioError;
    ErrorLog: TErrorLog;
begin
    try
        for i := 0 to ap.fThreadJobList.Count - 1 do
        begin
            if (not ap.NempIsClosing) then
            begin
                aJob := TPostProcessJob(ap.fThreadJobList.items[i]);

                // call VCL, that we will edit the file now
                SendMessage(ap.fMainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar(aJob.fFilename)));

                aAudioFile := MedienBib.GetAudioFileWithFilename(aJob.fFilename);

                // Note: This Code will NOT update files which are not in the library.
                //       Ist this wanted? Yes!
                if assigned(aAudioFile) then
                begin
                    aJob.fAudioFile := aAudioFile;
                    // Decisions (Do/Dont) will be done in the sub-methods
                    // 1. Change the Rating of the File
                    aJob.ChangeRating;
                    // 2. Change the PlayCounter
                    aJob.ChangePlayCounter;
                    // 3. Update The file
                    aErr := aJob.UpdateFile;

                    if aErr <> AUDIOERR_None then
                    begin
                        ErrorLog := TErrorLog.create(afa_SaveRating, aAudioFile, aErr, false);
                        try
                            SendMessage(ap.fMainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(ErrorLog));
                        finally
                            ErrorLog.Free;
                        end;

                    end;


                    // ok. We have processed the file in the library so far.
                    // Now we should unify the ratings for this file in the playlist.
                    // We are in a Thread, and the Playlist is VCL-only, so
                    SendMessage(ap.fMainWindowHandle, WM_MedienBib, MB_UnifyPlaylistRating, LParam(aAudioFile));
                end;
            end else
                break;
        end;
        // clear the used ThreadFile-variable
        SendMessage(ap.fMainWindowHandle, WM_MedienBib, MB_ThreadFileUpdate,
                    Integer(PWideChar('')));

        ap.fThreadJobList.Clear;
        MedienBib.Changed := True;
        ap.fHND_ProcessThread := 0;
        MedienBib.StatusBibUpdate := 0;
    except

    end;
end;





end.
