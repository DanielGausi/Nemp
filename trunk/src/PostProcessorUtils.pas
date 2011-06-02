{

    Unit PostProcessorUtils

    - Collect Information during playback (called from NempPlayer)
    - Do something with the file after playing
      e.g. Scrobbling
           Change Rating
           Increase Playcounter

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

unit PostProcessorUtils;

interface

uses Windows, Classes, SysUtils, Contnrs, DateUtils,
      ShellApi, IniFiles,  Dialogs,   math,
      AudioFileClass, Nemp_ConstantsAndTypes,
      MP3FileUtils, gnuGettext, Nemp_RessourceStrings,  ScrobblerUtils;


type

    TPostProcessor = class; // forward declaration

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
            function UpdateFile: TAudioError;

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

uses NempMainUnit;


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

function TPostProcessJob.UpdateFile: TAudioError;
begin
    if fWriteToFiles then
        result := fAudioFile.QuickUpdateTag(fWriteToFiles)
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
    //fWriteToFiles  := Ini.ReadBool('PostProcessor', 'WriteToFiles', True);

    fChangeCounter := Ini.ReadBool('PostProcessor', 'ChangeCounter', True);
    // fIgnoreCounterOnAbortedTracks := Ini.ReadBool('PostProcessor', 'IgnoreCounterOnAbortedTracks', False);

    fIncPlayedFiles  := Ini.ReadBool('PostProcessor', 'IncPlayedFiles', True);
    fDecAbortedFiles := Ini.ReadBool('PostProcessor', 'DecAbortedFiles', True);
end;
procedure TPostProcessor.WriteToIni(Ini: TMemIniFile);
begin
    Ini.WriteBool('PostProcessor', 'Active', fActive);
    Ini.WriteBool('PostProcessor', 'IgnoreShortFiles', fIgnoreShortFiles);
    // Ini.WriteBool('PostProcessor', 'WriteToFiles', fWriteToFiles);

    Ini.WriteBool('PostProcessor', 'ChangeCounter', fChangeCounter);
    // Ini.WriteBool('PostProcessor', 'IgnoreCounterOnAbortedTracks', fIgnoreCounterOnAbortedTracks);

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

        // first: Scrobble. This is done in a thread.
        // whether it is really scrobbled or cancelled will be decided there
        NempScrobbler.AddToScrobbleList(IsJustPlaying);

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
                if IsJustPlaying then
                    PlayAmount := PlayAmount + SecondsBetween(Now, StartTimeLocal);
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
    aErr: TAudioError;
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
                        SendMessage(ap.fMainWindowHandle, WM_MedienBib, MB_ErrorLog, LParam(
                            PChar('Note: Automatic Rating/Playcounter NOT saved into file'#13#10 + aAudioFile.Pfad + #13#10
                                + 'Error: ' + AudioErrorString[aErr]
                                + #13#10 + '------'
                    )));

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
