{

    Unit PlaylistClass

    One of the Basic-Units - The Playlist

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

unit PlaylistClass;

interface

uses Windows, Forms, Contnrs, SysUtils,  VirtualTrees, IniFiles, Classes, 
    Dialogs, MMSystem, oneinst, math, RatingCtrls,
    Hilfsfunktionen, Nemp_ConstantsAndTypes,

    NempAudioFiles, AudioFileHelper, PlayerClass, Playlistmanagement,
    gnuGettext, Nemp_RessourceStrings, System.UITypes, System.Types,
    System.Generics.Defaults,

    MainFormHelper, CoverHelper, DriveRepairTools, cddaUtils;

type
  DWORD = cardinal;

  TNempPlaylist = class;

  TPlaylistNotifyEvent = procedure(Sender: TNempPlaylist) of object;
  TPlaylistAudioFileEvent = procedure(Sender: TNempPlaylist; aFile: TAudioFile; aIndex: Integer) of object;
  TPlaylistAudioFileMoveEvent = procedure(Sender: TNempPlaylist; aFile: TAudioFile; oldIndex, newIndex: Integer) of object;

  TPreBookInsertMode = (pb_Beginning, pb_End);

  TIndexArray = Array of Array of Integer;

  TNempPlaylist = Class
    private
      fDauer: Int64;                      // Duration of the Playlist in seconds
      fPlayingFile: TPlaylistFile;        // the current Audiofile
      fPlayingCue: TPlaylistFile;
      fBackupFile : TPlaylistFile;        // if we delete the playingfile from the playlist, we store a copy of it here

      fStartIndex: Integer;               // The Index of the PlayingFile. (v4.14: Used only for Saving/Loading)

      fPlayingFileUserInput: Boolean;     // True, after the user slides/paused/... the current audiofile.
                                          // Then the file should (depending on settings) not be deleted after playback
      fWiedergabeMode: Integer;           // One after the other, Random, ...
      fAutoMix: Boolean;                  // Mix playlist after the last title
      fJumpToNextCueOnNextClick: Boolean; // Jump only to next cue on "Next"
      fRepeatCueOnRepeatTitle: Boolean;   // repeat the current entry in cuesheet wehn "repeat title" is selected
      // fShowHintsInPlaylist: Boolean;
      fPlayCounter: Integer;              // used for a "better random" selection

      fInsertIndex: Integer;              // The Index where files are inserted during adding files (e.g. Drag&Drop)

      fErrorCount: Integer;               // Stop "nextfile" after one cycle if all files in the playlist could not be found
      fFirstAction: Boolean;              // used for inserting files (ProcessBufferStringlist). On Nemp-Start the playback should bes started.
                                          // see "AutoPlayNewTitle"

      fInterruptedPlayPosition: Double;   // the Position in the track that was played just before the
                                          // user played a title directly from the library
      fInterruptedFile : TAudioFile;      // The track itself
      fRememberInterruptedPlayPosition: Boolean; // Use this position and start playback of the track there

      fLastEditedAudioFile: TAudioFile;   // the last edited AudioFile when manually sorting the PrebookList by keypress
      fLastKeypressTick: Int64;           // TickCount when the last keypress occured

      fFileSearchCounter: Integer;        // used during a search for new files to display the progress

      fShowIndexInTreeview: Boolean;

      // PrebookList: Stores the prebooked AudioFiles,
      // i.e. the files that are marked as "play next"
      PrebookList: TAudioFileList;

      /// History: When playing a new File, the file played before this file is added to the historylist
      /// and fCurrentHistoryFile points to this last played file.
      ///  GetNext/GetPrevious-Index Call "UpdateHistory" first
      ///     There is checked, whether we are currently "browsing in the history" or leaving it
      ///     (in this case the last played file ist added at the end/at the beginning of the history list)
      /// After this, GetNext/GetPreviousIndex will get the new index through the history (if needed)
      ///  or get a "New" index
      fCurrentHistoryFile: TAudioFile;
      HistoryList: TAudioFileList;

      // for  weighted random
      fUseWeightedRNG: Boolean;
      // first column : "RNG value" which is significant for the Random value
      // second column: actual index of the file in the playlist
      // size: Length(Playlist) x 2, but not all fields are necessarily filled,
      //       as some files in the playlist may have no entry in this array
      //       (meaning: probability to play this file is 0
      //        ... well, almost, as it could be played in backup-mode)
      fWeightedRandomIndices: TIndexArray;
      // The maximum of the values in the first column of the array
      fMaxWeightedValue: Integer;
      fMaxWeightedIndex: Integer;
      // Flag whether the playlist has been changed and a re-init of fWeightedRandomIndices is necessary
      fPlaylistHasChanged: Boolean;

      // (new 4.11) ok, we'll get a mixture of SendMessages and Events by that, but
      // it's working, wo why not. maybe change the code to events anyway later ...
      // More events in 4.14, and existing events get more functionality
      fOnCueChanged: TPlaylistNotifyEvent;
      fOnUserChangedTitle: TPlaylistNotifyEvent;
      fOnBeforeDeleteAudiofile: TPlaylistAudioFileEvent;
      fOnAddAudioFile: TPlaylistAudioFileEvent;
      // fOnFilePropertiesChanged: Some Properties of the AudioFiles in the Playlist have changed
      fOnFilePropertiesChanged: TPlaylistNotifyEvent;
      fOnPropertiesChanged: TPlaylistNotifyEvent;
      fOnSearchResultsChanged: TPlaylistNotifyEvent;
      fOnCueListFound: TPlaylistAudioFileEvent;
      // todO: onMoveItems: TMoveEvent  (...Sender + two Index-Paramaters?)
      fOnFileMoved: TPlaylistAudioFileMoveEvent;
      fOnPlaylistChangedCompletely: TPlaylistNotifyEvent;
      fOnPlaylistCleared: TPlaylistNotifyEvent;

      fDriveManager: TDriveManager;

      function fGetPreBookCount: Integer;

      procedure SetInsertIndex(Value: Integer);
      function GetAnAudioFile: TPlaylistFile;
      function GetNextAudioFileIndex: Integer;
      function GetPrevAudioFileIndex: Integer;

      function GetCount: Integer;

      function GetPlayingIndex: Integer;
      function GetPlayingFileName: String;
      function fGetPlayingTrackPos: Double;

      // Kapselungen der entsprechenden Player-Routinen
      // bei den Settern zusätzlich Cue-Zeug-Handling dabei.
      function GetTime: Double;
      procedure SetTime(Value: Double);
      function GetProgress: Double;
      procedure SetProgress(Value: Double);

      // UpdateHistory
      // called from GetNext- GetPrevAudioFileIndex
      // Inserts (if needed) currentfile at the end of the Historylist
      procedure UpdateHistory(Backwards: Boolean = False);

      // for  weighted random
      procedure RebuildWeighedArray;
      procedure SetUseWeightedRNG(aValue: Boolean);

      function GetRandomPlaylistIndex: Integer;


    public
      Playlist: TAudioFileList;              // the list with the audiofiles
      Player: TNempPlayer;                // the player-object

      PlaylistManager: TPlaylistManager;

      // Some settings for the playlist, stored in the Ini-File
      AutoPlayOnStart: Boolean;     // begin playback when Nemp starts
      SavePositionInTrack: Boolean; // save current position in track and restore it on next start
      PositionInTrack: Integer;
      AutoPlayNewTitle: Boolean;    // Play new title when the user selects "Enqueue in Nemp" in the explorer (and Nemp is not running, yet)
      AutoPlayEnqueuedTitle: Boolean; // PLay the enqueued track (even if Nemp is already running)
      // AutoSave: Boolean;            // Save Playlist every 5 minutes
      AutoScan: Boolean;            // Scan files with Mp3fileUtils
      AutoDelete: Boolean;                  // Delete File after playback
          DisableAutoDeleteAtUserInput: Boolean;
      BassHandlePlaylist: Boolean;      // let the bass.dll handle webstream-playlists
      RandomRepeat: Integer;   // 0..100% - which part of the Playlist should be played before a song is selected "randomly" again?

      // default-action when the user doubleclick an item in the medialibrary
      DefaultAction: Integer;
      ApplyDefaultActionToWholeList: Boolean;
      UseDefaultActionOnCoverFlowDoubleClick: Boolean;
      // default-action when the user clicks "Add current Headphone-title to playlist"
      HeadSetAction: Integer;
      AutoStopHeadsetSwitchTab: Boolean;
      AutoStopHeadsetAddToPlayist: Boolean;

      TNA_PlaylistCount: Integer; // number of files displayed in the TNA-menu

      AcceptInput: Boolean;     // Block inputs after a successful beginning of playback for a short time.
                                // Multimediakeys seems to do some weird things otherwise

      MainWindowHandle: DWord;  // The Handle to the Nemp main window

      ST_Ordnerlist: TStringList; // Joblist for SearchTools
      InitialDialogFolder: String;

      CurrentSearchDir: String;

      Status: Integer;

      LastCommandWasPlay: Boolean;      // some vars needed for Explorer-stuff
      ProcessingBufferlist: Boolean;    //like "play/enqueue in Nemp"
      BufferStringList: TStringList;

      // The weights for files with rating from (0?- ) 0.5 - 5 stars
      RNGWeights: Array[0..10] of Integer;

      property Dauer: Int64 read fDauer;
      property Count: Integer read GetCount;

      property Time: Double read GetTime write SetTime;             // Do some Cue-Stuff here!
      property Progress: Double read GetProgress write SetProgress;

      property PlayingFile: TPlaylistFile read fPlayingFile;
      property PlayingFileName: string read GetPlayingFileName;
      property PlayingIndex: Integer read GetPlayingIndex;

      property PlayingCue: TPlaylistFile read fPlayingCue;
      // PlayingTrackPos: The Position in the current file.
      //      Note: That's not always Player.Time, as the Player may be playing something different (not part of the playlist)
      //      Used for the PlaylistManager
      property PlayingTrackPos: Double read fGetPlayingTrackPos;

      property PlayingFileUserInput: Boolean read fPlayingFileUserInput write fPlayingFileUserInput;
      property WiedergabeMode: Integer read fWiedergabeMode write fWiedergabeMode;
      property AutoMix: Boolean read fAutoMix write fAutoMix;
      property JumpToNextCueOnNextClick: Boolean read fJumpToNextCueOnNextClick write fJumpToNextCueOnNextClick;
      property RepeatCueOnRepeatTitle: Boolean read fRepeatCueOnRepeatTitle write fRepeatCueOnRepeatTitle;
      property RememberInterruptedPlayPosition: Boolean read fRememberInterruptedPlayPosition write fRememberInterruptedPlayPosition;
      property ShowIndexInTreeview: Boolean read fShowIndexInTreeview write fShowIndexInTreeview;
      //property ShowHintsInPlaylist: Boolean read fShowHintsInPlaylist write fShowHintsInPlaylist;

      property PlayCounter: Integer read fPlayCounter;

      property OnCueChanged: TPlaylistNotifyEvent read fOnCueChanged write fOnCueChanged;
      property OnUserChangedTitle: TPlaylistNotifyEvent read fOnUserChangedTitle write fOnUserChangedTitle;
      property OnBeforeDeleteAudiofile: TPlaylistAudioFileEvent read fOnBeforeDeleteAudiofile write fOnBeforeDeleteAudiofile;
      property OnAddAudioFile: TPlaylistAudioFileEvent read fOnAddAudioFile write fOnAddAudioFile;

      property OnFilePropertiesChanged: TPlaylistNotifyEvent read fOnFilePropertiesChanged write fOnFilePropertiesChanged;
      property OnPropertiesChanged: TPlaylistNotifyEvent read fOnPropertiesChanged write fOnPropertiesChanged;
      property OnSearchResultsChanged: TPlaylistNotifyEvent read fOnSearchResultsChanged write fOnSearchResultsChanged;
      property OnCueListFound: TPlaylistAudioFileEvent read fOnCueListFound write fOnCueListFound;
      property OnFileMoved: TPlaylistAudioFileMoveEvent read fOnFileMoved write fOnFileMoved;
      property OnPlaylistChangedCompletely: TPlaylistNotifyEvent read fOnPlaylistChangedCompletely write fOnPlaylistChangedCompletely;
      property OnPlaylistCleared: TPlaylistNotifyEvent read fOnPlaylistCleared write fOnPlaylistCleared;

      property InsertIndex: Integer read fInsertIndex write SetInsertIndex;
      property PrebookCount: Integer read fGetPreBookCount;
      property FileSearchCounter: Integer read fFileSearchCounter write fFileSearchCounter;

      property UseWeightedRNG: Boolean read fUseWeightedRNG write SetUseWeightedRNG;
      property PlaylistHasChanged: Boolean read fPlaylistHasChanged write fPlaylistHasChanged;

      constructor Create;
      destructor Destroy; override;

      procedure LoadSettings;
      procedure SaveSettings;

      procedure OverwritePlayingIndexWithMaxCount;
      procedure InitPlayingFile(StartAtOldPosition: Boolean = False);
      // the most important methods: Play, Playnext, ...
      procedure Play(aIndex: Integer; aInterval: Integer; Startplay: Boolean; Startpos: Double = 0);
      procedure PlayBibFile(aFile: TAudioFile; aInterval: Integer);

      procedure PlayHeadsetFile(aFile: TAudioFile; aInterval: Integer; aPosition: Double);

      procedure PlayNextFile(aUserinput: Boolean = False);
      procedure PlayNext(aUserinput: Boolean = False);
      // PreparePlayNext will be called automatically at the end of a Track if the user wants a little break between two tracks
      // There is no user interaction reasonable here. If the User does interact, he couldd alos use "pause" as well
      procedure PreparePlayNext;

      procedure PlayPrevious(aUserinput: Boolean = False);
      procedure PlayPreviousFile(aUserinput: Boolean = False);
      procedure PlayFocussed(MainIndex, CueIndex: Integer);
      procedure PlayAgain(ForcePlay: Boolean = False);
      procedure PreparePlayAgain;
      procedure Pause;
      procedure Stop;
      procedure TogglePlayPause(DirectUserInput: Boolean);

      procedure ClearPlaylist(StopPlayer: Boolean = True);      // Delete whole playlist
      procedure DeleteDeadFiles;    // Delete dead (non existing) files
      procedure RemovePlayingFile;  // Remove the current file from the list
      procedure RemoveFileFromHistory(aFile: TAudioFile);

      function InitInsertIndexFromPlayPosition(ConsiderPrebookList: Boolean): Integer;
      procedure ResetInsertIndex;



      // Set CueNode and invalidate TreeView
      procedure RefreshCue;

      procedure RefreshAudioFile(aIndex: Integer; ReloadDataFromFile: Boolean);

      function CalculateDuration: Int64;

      procedure ReInitPlaylist;     // correct the NodeIndex and stuff after a sorting of the playlist
      procedure Sort(Compare: IComparer<TAudioFile>);
      Procedure ReverseSortOrder;
      Procedure Mix;
      procedure GetSortOrderFromList(aList: TAudioFileList);

      // adding files into the playlist
      // return value: the new node in the treeeview. Used for scrolling to this node
      procedure AddFileToPlaylist(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''); overload;
      function AddFileToPlaylistWebServer(aAudiofile: TAudioFile; aCueName: UnicodeString = ''): TAudioFile;
      function InsertFileToPlayList(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''): TAudioFile; overload;
      procedure AddFileToPlaylist(Audiofile: TAudioFile; aCueName: UnicodeString = ''); overload;
      procedure InsertFileToPlayList(Audiofile: TAudioFile; aCueName: UnicodeString = ''); overload;
      procedure ProcessBufferStringlist;

      procedure DeleteAudioFileFromPlaylist(aIndex: Integer); overload;
      procedure DeleteAudioFileFromPlaylist(af: TAudioFile); overload;

      procedure ReIndexPrebookedFiles;
      procedure SetNewPrebookIndex(aFile: TAudioFile; NewIndex: Integer);
      procedure ProcessKeypress(aDigit: Byte; af: TAudioFile);

      function SuggestSaveLocation(out Directory: String; out Filename: String): Boolean;
      // load/save playlist
      procedure LoadFromFile(aFilename: UnicodeString);
      procedure LoadCueSheet(filename: UnicodeString);
      procedure LoadManagedPlayList(aIndex: Integer);

      procedure SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
      // copy it from Winamp
      // procedure GetFromWinamp; No. Not any more. *g*

      // The user wants us something todo => Set ErrorCount to 0
      procedure UserInput;

      // Reinit Bass-Engine. Needed sometimes after suspending the system.
      procedure RepairBassEngine(StartPlay: Boolean);

      // when the user change the rating of a audiofile-object, it should be
      // changed in the whole playlist. (It could be multiply times in the playlist!)
      procedure UnifyRating(aFilename: String; aRating: Byte; aCounter: Integer);

      procedure CollectFilesWithSameFilename(aFilename: String; Target: TAudioFileList);

      // Search the Playlist for an ID. Used by Nemp Webserver
      // The links in the html-code will contain these IDs, so they will be valid
      // until the "real" Nemp-User deletes a file from the playlist.
      function GetPlaylistIndexByWebServerID(aID: Int64): Integer;
      function SwapFiles(a, b: Integer): Boolean;   // a and b must be siblings!!
      procedure ResortVotedFile(aFile: TAudioFile; aIndex: Integer);

      // Searching in the playlist (changed in 4.14, much simpler code now)
      procedure ClearSearch(complete: Boolean = False);
      procedure Search(aString: String; SearchNext: Boolean = False);

      // new in 4.14: just as in the media library
      procedure ReSynchronizeDrives;

      procedure SynchFilesWithCDDrive(CDDADrive: TCDDADrive);
  end;

implementation

uses NempMainUnit, spectrum_vis, BibSearchClass, StringHelper, LibraryOrganizer.Base, LibraryOrganizer.Files;

var tid      : Cardinal;

procedure APM(TimerID, Msg: Uint; dwUser, dw1, dw2: DWORD); pascal;
begin
  SendMessage(dwUser, WM_PlayerAcceptInput, 0, 0);
end;


{
    --------------------------------------------------------
    Create, Destroy
    --------------------------------------------------------
}
constructor TNempPlaylist.Create;
begin
  inherited create;
  Playlist := TAudioFileList.Create;
  fDriveManager := TDriveManager.Create;
  PlaylistManager := TPlaylistManager.Create(fDriveManager);
  ST_Ordnerlist := TStringList.Create;
  PrebookList := TAudioFileList.Create(False);
  HistoryList := TAudioFileList.Create(False);
  fCurrentHistoryFile := Nil;
  fPlayingFile := Nil;
  fPlayingCue := Nil;
  fBackupFile := TPlayListFile.Create;
  AcceptInput := True;
  Status := 0;
  BufferStringList := TStringList.Create;
  ProcessingBufferlist := False;
  fFirstAction := True;
end;

destructor TNempPlaylist.Destroy;
begin
  HistoryList.Free;
  PrebookList.Free;
  PlaylistManager.Free;
  fDriveManager.Free;
  Playlist.Free;
  ST_Ordnerlist.Free;
  BufferStringList.Free;
  fBackupFile.Free;
  inherited Destroy;
end;

{
    --------------------------------------------------------
    Load/Save Inifile
    --------------------------------------------------------
}
procedure TNempPlaylist.LoadSettings;
begin
  DefaultAction         := NempSettingsManager.ReadInteger('Playlist','DefaultAction',0);
  ApplyDefaultActionToWholeList := NempSettingsManager.ReadBool('Playlist','ApplyDefaultActionToWholeList',False);
  UseDefaultActionOnCoverFlowDoubleClick := NempSettingsManager.ReadBool('Playlist','UseDefaultActionOnCoverFlowDoubleClick', False);
  HeadSetAction         := NempSettingsManager.ReadInteger('Playlist','HeadSetAction',0);
  AutoStopHeadsetSwitchTab       := NempSettingsManager.ReadBool('Playlist','AutoStopHeadset',True);
  AutoStopHeadsetAddToPlayist    := NempSettingsManager.ReadBool('Playlist','AutoStopHeadsetAddToPlayist',False);

  WiedergabeMode        := NempSettingsManager.ReadInteger('Playlist','WiedergabeModus',0);
  AutoScan              := NempSettingsManager.ReadBool('Playlist','AutoScan', True);
  AutoPlayOnStart       := NempSettingsManager.ReadBool('Playlist','AutoPlayOnStart', True);
  AutoPlayNewTitle      := NempSettingsManager.ReadBool('Playlist','AutoPlayNewTitle', True);
  AutoPlayEnqueuedTitle := NempSettingsManager.ReadBool('Playlist','AutoPlayEnqueuedTitle', False);
  // AutoSave              := ini.ReadBool('Playlist','AutoSave', True);
  AutoDelete            := NempSettingsManager.ReadBool('Playlist','AutoDelete', False);
  DisableAutoDeleteAtUserInput    := NempSettingsManager.ReadBool('Playlist','DisableAutoDeleteAtUserInput', True);
  fAutoMix                        := NempSettingsManager.ReadBool('Playlist','AutoMix', False);
  fJumpToNextCueOnNextClick       := NempSettingsManager.ReadBool('Playlist', 'JumpToNextCueOnNextClick', True);
  fRepeatCueOnRepeatTitle         := NempSettingsManager.ReadBool('Playlist', 'RepeatCueOnRepeatTitle', True);
  fRememberInterruptedPlayPosition:= NempSettingsManager.ReadBool('Playlist', 'RememberInterruptedPlayPosition', True);
  // fShowHintsInPlaylist  := NempSettingsManager.ReadBool('Playlist', 'ShowHintsInPlaylist', True);
  RandomRepeat          := NempSettingsManager.ReadInteger('Playlist', 'RandomRepeat', 25);
  TNA_PlaylistCount     := NempSettingsManager.ReadInteger('Playlist','TNA_PlaylistCount',30);
  fStartIndex         := NempSettingsManager.ReadInteger('Playlist','IndexinList',0);
  SavePositionInTrack   := NempSettingsManager.ReadBool('Playlist', 'SavePositionInTrack', True);
  PositionInTrack       := NempSettingsManager.ReadInteger('Playlist', 'PositionInTrack', 0);
  BassHandlePlaylist    := NempSettingsManager.ReadBool('Playlist', 'BassHandlePlaylist', True);
  InitialDialogFolder   := NempSettingsManager.ReadString('Playlist', 'InitialDialogFolder', '');
  ShowIndexInTreeview := NempSettingsManager.ReadBool('Playlist', 'ShowIndexInTreeview', True);

  fUseWeightedRNG := NempSettingsManager.ReadBool   ('Playlist', 'UseWeightedRNG', False);
  RNGWeights[1]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights05', 0  );
  RNGWeights[2]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights10', 0  );
  RNGWeights[3]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights15', 1  );
  RNGWeights[4]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights20', 2  );
  RNGWeights[5]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights25', 4  );
  RNGWeights[6]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights30', 7  );
  RNGWeights[7]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights35', 12 );
  RNGWeights[8]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights40', 20 );
  RNGWeights[9]   := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights45', 35 );
  RNGWeights[10]  := NempSettingsManager.ReadInteger('Playlist', 'RNGWeights50', 60 );

  PlaylistManager.LoadSettings;
end;

procedure TNempPlaylist.SaveSettings;
begin
  NempSettingsManager.WriteInteger('Playlist','DefaultAction', DefaultAction);
  NempSettingsManager.WriteBool('Playlist','ApplyDefaultActionToWholeList',ApplyDefaultActionToWholeList);
  NempSettingsManager.WriteBool('Playlist','UseDefaultActionOnCoverFlowDoubleClick', UseDefaultActionOnCoverFlowDoubleClick);
  NempSettingsManager.WriteInteger('Playlist','HeadSetAction',HeadSetAction);
  NempSettingsManager.WriteBool('Playlist','AutoStopHeadset',AutoStopHeadsetSwitchTab);
  NempSettingsManager.WriteBool('Playlist','AutoStopHeadsetAddToPlayist',AutoStopHeadsetAddToPlayist);

  NempSettingsManager.WriteInteger('Playlist','WiedergabeModus',WiedergabeMode);
  NempSettingsManager.WriteInteger('Playlist','TNA_PlaylistCount',TNA_PlaylistCount);

  NempSettingsManager.WriteBool('Playlist', 'SavePositionInTrack', SavePositionInTrack);

  if assigned(fPlayingFile) then
  begin
      NempSettingsManager.WriteInteger('Playlist','IndexinList', PlayList.IndexOf(fPlayingFile));
      if fPlayingFile.PrebookIndex = 0 then
          NempSettingsManager.WriteInteger('Playlist', 'PositionInTrack', Round(Player.Time))
      else
          // this should be the case when we play a bibfile right now
          NempSettingsManager.WriteInteger('Playlist', 'PositionInTrack', Round(fInterruptedPlayPosition));
  end
  else
  begin
      NempSettingsManager.WriteInteger('Playlist','IndexinList', 0);
      NempSettingsManager.WriteInteger('Playlist', 'PositionInTrack', 0);
  end;

  NempSettingsManager.WriteBool('Playlist','AutoScan', AutoScan);
  NempSettingsManager.WriteBool('Playlist','AutoPlayOnStart', AutoPlayOnStart);
  NempSettingsManager.WriteBool('Playlist','AutoPlayNewTitle', AutoPlayNewTitle);
  NempSettingsManager.WriteBool('Playlist','AutoPlayEnqueuedTitle', AutoPlayEnqueuedTitle);

  NempSettingsManager.WriteBool('Playlist','AutoDelete', AutoDelete);
  NempSettingsManager.WriteBool('Playlist','DisableAutoDeleteAtUserInput', DisableAutoDeleteAtUserInput);

  NempSettingsManager.WriteBool('Playlist','AutoMix', fAutoMix);
  NempSettingsManager.WriteBool('Playlist', 'JumpToNextCueOnNextClick', fJumpToNextCueOnNextClick);
  NempSettingsManager.WriteBool('Playlist', 'RepeatCueOnRepeatTitle', fRepeatCueOnRepeatTitle);
  NempSettingsManager.WriteBool('Playlist', 'RememberInterruptedPlayPosition', fRememberInterruptedPlayPosition);

  // NempSettingsManager.WriteBool('Playlist', 'ShowHintsInPlaylist', fShowHintsInPlaylist);
  NempSettingsManager.WriteInteger('Playlist', 'RandomRepeat', RandomRepeat);
  NempSettingsManager.WriteBool('Playlist', 'BassHandlePlaylist', BassHandlePlaylist);
  NempSettingsManager.WriteString('Playlist', 'InitialDialogFolder', InitialDialogFolder);
  NempSettingsManager.WriteBool('Playlist', 'ShowIndexInTreeview', ShowIndexInTreeview);

  NempSettingsManager.WriteBool   ('Playlist', 'UseWeightedRNG', fUseWeightedRNG);
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights05', RNGWeights[1]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights10', RNGWeights[2]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights15', RNGWeights[3]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights20', RNGWeights[4]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights25', RNGWeights[5]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights30', RNGWeights[6]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights35', RNGWeights[7]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights40', RNGWeights[8]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights45', RNGWeights[9]  );
  NempSettingsManager.WriteInteger('Playlist', 'RNGWeights50', RNGWeights[10] );

  PlaylistManager.SaveSettings;
end;


{
    --------------------------------------------------------
    main methods. Play, Playnext, ...
    --------------------------------------------------------
}

///  In case Nemp starts by opening a file or playlist, the user may want
///  to play the NEW inserted files on start - not the one where the playback
///  ended in the last session.
///  Index is Set to Count (not Count-1), as we will add some files after that
procedure TNempPlaylist.OverwritePlayingIndexWithMaxCount;
begin
    if AutoPlayNewTitle then
        fStartIndex := Playlist.Count;
end;

procedure TNempPlaylist.InitPlayingFile(StartAtOldPosition: Boolean = False);
begin
    if AutoPlayOnStart then
        Player.LastUserWish := USER_WANT_PLAY
    else
        Player.LastUserWish := USER_WANT_STOP;
    if (fStartIndex > -1) AND (fStartIndex <= PlayList.Count-1) then
    begin
        if SavePositionInTrack AND StartAtOldPosition then
            Play(fStartIndex, Player.FadingInterval, AutoPlayOnStart, PositionInTrack)
        else
            Play(fStartIndex, Player.FadingInterval, AutoPlayOnStart);

        if assigned(fOnUserChangedTitle) then
            fOnUserChangedTitle(Self)
    end;
end;


procedure TNempPlaylist.Play(aIndex: Integer; aInterval: Integer; Startplay: Boolean; Startpos: Double = 0);
var  NewFile: TPlaylistFile;
     OriginalLength: Int64;
     BackupFileIsPlayedAgain: Boolean;
begin
  // wir haben was getan. Der erste Start ist vorbei.
  fFirstAction := False;
  if not AcceptInput then exit;

  OriginalLength := 0;
  NewFile := Nil;
  BackupFileIsPlayedAgain := False;
  // neues AudioFile aus dem Index bestimmen
  try
      if aIndex = -1 then
      begin
          // Playlist soll selbst entscheiden, was abgespielt werden soll - GetAnAudioFile!
          NewFile := GetAnAudioFile;
          BackupFileIsPlayedAgain := NewFile = fBackupFile;
      end else
          if (aIndex < Playlist.Count) AND (Playlist.Count > 0) then
              NewFile := TPlaylistFile(Playlist[aIndex]);

  except
      MessageDlg((BadError_Play), mtError, [mbOK], 0) ;
  end;

   if      AutoDelete                               // User enabled AutoDelete
      And (not fPlayingFileUserInput)               // User did not interact with the player during playback
      And (Player.MainAudioFileIsPresentAndPlaying) // Current file exists and was played
      and ((newFile <> PlayingFile)                 // NewFile is not the current one
           or Player.EndFileProcReached)            //    or lastfile has reached its end
   then
   begin
        if newFile = PlayingFile then   // We will delete the current file
        begin                           // and so the newfile will become
            RemovePlayingFile;          // invalid
            newFile := NIL;
        end
        else
            RemovePlayingFile;          // just delete the current file
   end;

  // Eingaben kurzfristig blocken
  AcceptInput := False;

      if Assigned(NewFile) then
      begin
        SetNewPrebookIndex(NewFile, 0);

        OriginalLength := NewFile.Duration;
        fPlayingFile := NewFile;
        fPlayingFileUserInput := False;
        Player.play(fPlayingFile, aInterval, Startplay, Startpos);  // da wird die Dauer geändert
        // reset the interruptedPlayPosition
        if not BackupFileIsPlayedAgain then
            fInterruptedPlayPosition := 0;

        // ScrollToPlayingNode;
        // Anzeige Im Baum aktualisieren
        if assigned(OnFilePropertiesChanged) then
            OnFilePropertiesChanged(self);

        // Knoten aktualisieren
        RefreshCue;
      end;

  // Wenn was schiefgelaufen ist, d.h. der mainstream = 0 ist
  if (Player.MainStream = 0) And (Not Player.URLStream) then
  begin
    try
        if fErrorCount < Playlist.Count then
        begin
          AcceptInput := True;
          inc(fErrorCount);
          fDauer := fDauer  - OriginalLength;
          SendMessage(MainWindowHandle, WM_NextFile, 0, 0);
        end else
        begin
          AcceptInput := True;
          fDauer := fDauer  - OriginalLength;
          Stop;

          if assigned(fOnFilePropertiesChanged) then
              fOnFilePropertiesChanged(self);
          if assigned(fOnPropertiesChanged) then
              fOnPropertiesChanged(self);
        end;
    except
        MessageDlg((BadError_Play1) + ' (2)', mtError, [mbOK], 0) ;
    end;
  end
  else
  begin
    try
        fErrorCount := 0;
        // ggf Daten des AudioFiles anpassen
        // Unterschied zu oben: Hier werden die Daten der bass.dll genommen!!
        if assigned(fPlayingFile) then
        begin
          fPlayingFile.LastPlayed := fPlayCounter;
          inc(fPlayCounter);
          fPlayingFile.Duration := Round(Player.Dauer);
          fDauer := fDauer + (fPlayingFile.Duration - OriginalLength);

          if assigned(fOnFilePropertiesChanged) then
              fOnFilePropertiesChanged(self);
          if assigned(fOnPropertiesChanged) then
              fOnPropertiesChanged(self);
        end;
    except
        MessageDlg((BadError_Play1) + ' (3).', mtError, [mbOK], 0) ;
    end;

    // Aufgestaute Nachrichten abarbeiten
    // Grml. Die Multimediakeys machen da wieder Ärger.
    // Scheinbar gehts wirklich nur, wenn man AcceptInput erst nach einer gewissen Zeit
    // wieder freigibt...
    tid := timeSetEvent(300, 50, @APM, MainWindowHandle, TIME_ONESHOT);
  end;
end;

procedure TNempPlaylist.PlayBibFile(aFile: TAudioFile; aInterval: Integer);
var idx: Integer;
begin
    if not AcceptInput then exit;


    idx := Playlist.IndexOf(fPlayingFile);
    if assigned(fPlayingFile) and (idx >= 0) then
    begin
        // we will backup the index AND the current playposition, so we can
        // start next playback right where we are NOW
        fInterruptedPlayPosition := Player.Time;
        fInterruptedFile := fPlayingFile;

        // additionally, we set the current track on the beginning of the prebook-list
        PrebookList.Insert(0, fPlayingFile);
        if PrebookList.Count > 99 then
        begin
            PrebookList[PrebookList.Count-1].PrebookIndex := 0;
            PrebookList.Delete(PrebookList.Count-1);
        end;
        ReIndexPrebookedFiles;
    end;

    // Eingaben kurzfristig blocken
    AcceptInput := False;

    if Assigned(aFile) then
    begin
      fBackUpFile.Assign(aFile);

      // Change 4.14. We do NOT change fPlayingFile here
      // fPlayingFile := fBackUpFile;

      fPlayingFileUserInput := False;
      // Player.play, not self.play!
      Player.play(fBackUpFile, aInterval, True, 0);  // da wird die Dauer geändert
      // Anzeige Im Baum aktualisieren
      if assigned(fOnFilePropertiesChanged) then
          fOnFilePropertiesChanged(self);
    end;

  // Wenn was schiefgelaufen ist, d.h. der mainstream = 0 ist
  if (Player.MainStream = 0) And (Not Player.URLStream) then
     // nothing
  else
  begin
      // Aufgestaute Nachrichten abarbeiten
      // Grml. Die Multimediakeys machen da wieder Ärger.
      // Scheinbar gehts wirklich nur, wenn man AcceptInput erst nach einer gewissen Zeit
      // wieder freigibt...
      tid := timeSetEvent(300, 50, @APM, MainWindowHandle, TIME_ONESHOT);
  end;

end;

procedure TNempPlaylist.PlayHeadsetFile(aFile: TAudioFile; aInterval: Integer; aPosition: Double);
var i: Integer;
begin
    InitInsertIndexFromPlayPosition(False);
    InsertFileToPlayList(aFile);
    // The actual position of the file may vary, therefore: BruteForce the actual Index here
    i := Playlist.IndexOf(aFile);
    Play(i, Player.FadingInterval, True, aPosition);

    // Trigger Event (= ScrollIntoView)
  if assigned(fOnUserChangedTitle) then
      fOnUserChangedTitle(Self)
end;

procedure TNempPlaylist.PlayNext(aUserinput: Boolean = False);
var nextIdx: Integer;
begin
  if not AcceptInput then exit;

  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtTitleChange;

  if fJumpToNextCueOnNextClick and (Player.JumpToNextCue) then
  begin
      RefreshCue;  // nothing else todo. Jump complete :D
  end else
  begin
      Player.stop(Player.LastUserWish = USER_WANT_PLAY);
      // GetNextAudioFileIndex can modify fInterruptedPlayPosition
      nextIdx := GetNextAudioFileIndex;
      if fRememberInterruptedPlayPosition then
          Play(nextIdx, Player.FadingInterval, Player.LastUserWish = USER_WANT_PLAY, fInterruptedPlayPosition)
      else
          Play(nextIdx, Player.FadingInterval, Player.LastUserWish = USER_WANT_PLAY, 0)
  end;

  // Trigger Event (= ScrollIntoView)
  if aUserinput and assigned(fOnUserChangedTitle) then
      fOnUserChangedTitle(Self)
end;

procedure TNempPlaylist.PreparePlayNext;
var nextIdx: Integer;
begin
  if not AcceptInput then exit;

  Player.stop(Player.LastUserWish = USER_WANT_PLAY);
  // GetNextAudioFileIndex can modify fInterruptedPlayPosition
  nextIdx := GetNextAudioFileIndex;
  Play(nextIdx, Player.FadingInterval, false, 0);
end;

procedure TNempPlaylist.PreparePlayAgain;
begin
   if not AcceptInput then exit;
  Player.stop(Player.LastUserWish = USER_WANT_PLAY);
  if assigned(fPlayingFile) then
    Player.Play(fPlayingFile, Player.FadingInterval, False)
  else
    Play(0, Player.FadingInterval, False);
end;


procedure TNempPlaylist.PlayNextFile(aUserinput: Boolean = False);
var sPos: Double;
    nextIdx: Integer;
begin
  if not AcceptInput then exit;

  Player.stop; // Neu im Oktober 2008
  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtTitleChange;

  // GetNextAudioFileIndex can modify fInterruptedPlayPosition
  nextIdx := GetNextAudioFileIndex;

  if fRememberInterruptedPlayPosition then
      sPos := fInterruptedPlayPosition
  else
      sPos := 0;

  if Player.Status = PLAYER_ISPLAYING then
      Play(nextIdx, Player.FadingInterval, True, sPos)
  else
      Play(nextIdx, Player.FadingInterval, False, sPos);

  // Trigger Event (= ScrollIntoView)
  if aUserinput and assigned(fOnUserChangedTitle) then
      fOnUserChangedTitle(Self)
end;

procedure TNempPlaylist.PlayPrevious(aUserinput: Boolean = False);
begin
  if not AcceptInput then exit;
  if aUserInput then
    fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtTitleChange;
  if fJumpToNextCueOnNextClick and (Player.JumpToPrevCue) then
  begin
      RefreshCue;   // nothing else todo. Jump complete :D
  end else
  begin
      if Player.Time > 5  then
          // just jump to beginning of the current file
          Player.Time := 0
      else
      begin
          if Player.Status = PLAYER_ISPLAYING then
              Play(GetPrevAudioFileIndex, Player.FadingInterval, True)
          else
              Play(GetPrevAudioFileIndex, Player.FadingInterval, False);
      end;
  end;
  // Trigger Event (= ScrollIntoView)
  if aUserinput and assigned(fOnUserChangedTitle) then
      fOnUserChangedTitle(Self)
end;

procedure TNempPlaylist.PlayPreviousFile(aUserinput: Boolean = False);
begin
  if not AcceptInput then exit;
  Player.stop; // Neu im Oktober 2008
  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtTitleChange;

  if Player.Time > 5  then
      // just jump to beginning of the current file
      Player.Time := 0
  else
  begin
      if Player.Status = PLAYER_ISPLAYING then
          Play(GetPrevAudioFileIndex, Player.FadingInterval, True)
      else
          Play(GetPrevAudioFileIndex, Player.FadingInterval, False);
  end;
  // Trigger Event (= ScrollIntoView)
  if aUserinput and assigned(fOnUserChangedTitle) then
      fOnUserChangedTitle(Self)
end;

procedure TNempPlaylist.PlayFocussed(MainIndex, CueIndex: Integer);
var CueTime: Single;
    af: TAudioFile;
begin
    if (MainIndex < 0) or (MainIndex >= Playlist.Count) then
        exit;

    // add the current title into the history
    UpdateHistory;
    // set flag "UserInput"
    fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput;

    if CueIndex = -1 then
        // just play the new title
        Play(MainIndex, Player.FadingInterval, True)
    else
    begin
        // we want to play a specific CueEntry of the File
        af := Playlist[MainIndex];
        if assigned(af.CueList) then
        begin
            if (CueIndex > 0) and (CueIndex < Playlist[MainIndex].CueList.Count) then
                CueTime := af.CueList[CueIndex].Index01
            else
                CueTime := 0;
        end else
            CueTime := 0;

        // if the AudioFile is the currently playing file: Just slide to the wanted position
        // otherwise: play the new title and start at CueTime
        if af = fPlayingFile then
            Player.Time := CueTime
        else
            Play(MainIndex, Player.FadingInterval, True, CueTime );
    end;

    if CueIndex >= 0 then
      RefreshCue;

    if assigned(self.fOnFilePropertiesChanged) then
        fOnFilePropertiesChanged(self);
end;

procedure TNempPlaylist.PlayAgain(ForcePlay: Boolean = False);
begin
  if not AcceptInput then exit;

  if assigned(fPlayingFile) then
  begin
      // play it again (eventually it is a file from the library)
      // we should NOT reset the  fInterruptedPlayPosition here (which would be done in self.play)
      if (Player.Status = PLAYER_ISSTOPPED_MANUALLY) and not Forceplay then
          Player.Play(fPlayingFile, Player.FadingInterval, False)
      else
          Player.Play(fPlayingFile, Player.FadingInterval, True);
  end else
  begin
      if (Player.Status = PLAYER_ISSTOPPED_MANUALLY) and not Forceplay then
          Play(0 {fPlayingIndex}, Player.FadingInterval, False)
      else
          Play(0 {fPlayingIndex}, Player.FadingInterval, True);
  end;
end;


procedure TNempPlaylist.Pause;
begin
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtPause;
  Player.pause;
end;

procedure TNempPlaylist.Stop;
begin
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtStop;
  Player.stop;
end;

procedure TNempPlaylist.TogglePlayPause(DirectUserInput: Boolean);
begin
  case Player.BassStatus of
      BASS_ACTIVE_PAUSED  : begin
            if DirectUserInput then
              Player.LastUserWish := USER_WANT_PLAY;
            Player.resume;
      end;
      BASS_ACTIVE_STOPPED : begin
            if DirectUserInput then
              NempPlayer.LastUserWish := USER_WANT_PLAY;
            // Der Stream-Status ist also STOPPED
            // Da kann durch echten Stop passiert sein,
            // oder durch ein ausfaden nach Klick auf den Pause-Button.
            if Player.Status = PLAYER_ISPAUSED then
              Player.resume
            else
              PlayAgain(True);
      end;
      BASS_ACTIVE_PLAYING: begin
            if Player.Status = PLAYER_ISPLAYING then begin
              if DirectUserInput then
                Player.LastUserWish := USER_WANT_STOP;
              Pause;
            end
            else
              if Player.Status = PLAYER_ISPAUSED then begin
                  if DirectUserInput then
                    Player.LastUserWish := USER_WANT_PLAY;
                  Player.resume;
              end;
      end;
    end;
end;




{
    --------------------------------------------------------
    Delete files from the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.DeleteAudioFileFromPlaylist(af: TAudioFile);
begin
  if assigned(af) then
    DeleteAudioFileFromPlaylist(Playlist.IndexOf(af));
end;


procedure TNempPlaylist.DeleteAudioFileFromPlaylist(aIndex: Integer);
var af: TAudioFile;
begin
    if aIndex < 0 then
        exit;
    if aIndex >= Playlist.Count then
        exit;

    af := Playlist[aIndex];

    if af = fPlayingFile then
    begin
        // Backup playing file
        fBackUpFile.Assign(fPlayingFile);
        // Set the pointer to the backup-file
        fPlayingFile := fBackUpFile;
        Player.MainAudioFile := fBackUpFile;
    end;

    // adjust Duration of the Playlist
    fDauer := fDauer - af.Duration;

    // trigger event to remove the Node from the Treeview (and do some other stuff)
    if assigned(fOnBeforeDeleteAudiofile) then
        fOnBeforeDeleteAudiofile(self, af, aIndex);

    // remove the file from other lists
    PrebookList.Remove(af);
    RemoveFileFromHistory(af);
    // Renumber the Prebook files
    ReIndexPrebookedFiles;

    // actually delete the file from the playlist
    Playlist.Delete(aIndex);

    if assigned(fOnPropertiesChanged)then
        fOnPropertiesChanged(Self);

end;


procedure TNempPlaylist.ClearPlaylist(StopPlayer: Boolean = True);
begin
    if StopPlayer then
    begin
        Player.StopAndFree;
        Player.MainAudioFile := Nil;
        fPlayingFile := Nil;
    end else
    begin
        fBackUpFile.Assign(fPlayingFile);
        fPlayingFile := fBackUpFile;
        Player.MainAudioFile := fBackUpFile;
    end;

    HistoryList.Clear;
    PrebookList.Clear;
    Playlist.Clear;
    fDriveManager.Clear;

    fCurrentHistoryFile := Nil;
    fStartIndex := 0;
    fDauer := 0;
    fPlaylistHasChanged := True;

    if assigned(fOnPlaylistCleared) then
        fOnPlaylistCleared(self);
    if assigned(fOnPropertiesChanged) then
        fOnPropertiesChanged(Self);

    SendMessage(MainWindowHandle, WM_PlayerStop, 0, 0);
end;



procedure TNempPlaylist.DeleteDeadFiles;
var i: Integer;
begin
  for i := Playlist.Count - 1 downto 0 do
  begin
      if not Playlist.Items[i].ReCheckExistence then
      begin
          if assigned(fOnBeforeDeleteAudiofile) then
              fOnBeforeDeleteAudiofile(self, Playlist.Items[i], i);

          PrebookList.Remove(Playlist.Items[i]);
          HistoryList.Remove(Playlist.Items[i]);
          RemoveFileFromHistory(Playlist.Items[i]);
          Playlist.Delete(i);
      end;
  end;
  ReIndexPrebookedFiles;
  fDauer := CalculateDuration;
  fPlaylistHasChanged := True;

  // Trigger events
  if assigned(self.fOnPropertiesChanged) then
      fOnPropertiesChanged(self);
  if assigned(self.fOnFilePropertiesChanged) then
      fOnFilePropertiesChanged(self);
end;

procedure TNempPlaylist.removePlayingFile;
var idx: Integer;
begin
    idx := Playlist.IndexOf(fPlayingFile);
    if idx >= 0 then
        DeleteAudioFileFromPlaylist(idx);
end;

{
    --------------------------------------------------------
    RemoveFileFromHistory
    - Delete the entry from the list and set a new fCurrentHistoryFile
    --------------------------------------------------------
}
procedure TNempPlaylist.RemoveFileFromHistory(aFile: TAudioFile);
var aIdx: Integer;
begin
    if aFile = fCurrentHistoryFile then
    begin
        aIdx := HistoryList.IndexOf(fCurrentHistoryFile);
        if aIdx < HistoryList.Count-1 then
        begin
            if aIdx >= 0 then
                fCurrentHistoryFile := HistoryList[aIdx]
            else
                fCurrentHistoryFile := Nil;
        end
        else
            if aIdx - 1 >= 0 then
                fCurrentHistoryFile := HistoryList[aIdx - 1]
            else
                fCurrentHistoryFile := Nil;
    end;
    HistoryList.Remove(aFile);
end;


procedure TNempPlaylist.ClearSearch(complete: Boolean = False);
var i: Integer;
begin
    for i := 0 to Playlist.Count - 1 do
        Playlist[i].IsSearchResult := False;

    if assigned(fOnFilePropertiesChanged) then
        fOnFilePropertiesChanged(Self);
end;


procedure TNempPlaylist.Search(aString: String; SearchNext: Boolean = False);
var Keywords: TStringList;
    i: Integer;
begin
  Keywords := TStringList.Create;
  try
    ExplodeWithQuoteMarks(' ', aString, Keywords);
    for i := 0 to Playlist.Count - 1 do
      Playlist[i].IsSearchResult := AudioFileMatchesKeywordsPlaylist(Playlist[i], Keywords);
  finally
    Keywords.Free;
  end;

  if assigned(fOnFilePropertiesChanged) then
    fOnFilePropertiesChanged(Self);

  if assigned(fOnSearchResultsChanged) then
    fOnSearchResultsChanged(Self);
end;



{
    --------------------------------------------------------
    Some GUI-stuff
    --------------------------------------------------------
}
procedure TNempPlaylist.SetInsertIndex(Value: Integer);
begin
    if Value < Playlist.Count then
        fInsertIndex := Value
    else
        fInsertIndex := -1;
end;

function TNempPlaylist.InitInsertIndexFromPlayPosition(ConsiderPrebookList: Boolean): Integer;
var lastPrebookFile: TAudioFile;
begin
    if (PrebookList.Count > 0) and ConsiderPrebookList then
    begin
        lastPrebookFile := PrebookList[PrebookList.Count - 1];
        result := Playlist.IndexOf(lastPrebookFile) + 1;
    end else
    begin
        if assigned(fPlayingFile) then
            result := Playlist.IndexOf(fPlayingFile) + 1
        else
          result := 0;
    end;
    // if we are with playback at the end of the playlist, set InsertIndex to -1.
    // This will switch to "add files at the end"
    if result >= Playlist.Count then
        result := -1;

    fInsertIndex := result;
end;

procedure TNempPlaylist.ResetInsertIndex;
begin
    fInsertIndex := -1;
end;


procedure TNempPlaylist.RefreshCue;
begin
    fPlayingCue := Player.GetActiveCue;
    if assigned(fOnCueChanged) then
        fOnCueChanged(Self);
end;

procedure TNempPlaylist.RefreshAudioFile(aIndex: Integer; ReloadDataFromFile: Boolean);
var AudioFile: TAudioFile;
    OldLength: Int64;

begin
    if (aIndex < 0) or (aIndex >= Playlist.Count)  then
        exit;

    AudioFile := Playlist[aIndex];
    OldLength := AudioFile.Duration;

    AudioFile.ReCheckExistence;

    case AudioFile.AudioType of
        at_File   : begin
            if not AudioFile.FileIsPresent then
                AudioFile.Duration := 0;

            if ReloadDataFromFile then
                SynchAFileWithDisc(AudioFile, True);

            if not assigned(AudioFile.CueList) then
            begin
                // nach einer Liste suchen und erstellen
                // yes, always, also on short tracks
                if AudioFile.GetCueList then
                begin
                    if assigned(fOnCueListFound) then
                        fOnCueListFound(self, AudioFile, aIndex);
                end;
            end;
        end;

        at_Stream : begin
            AudioFile.Duration := 0;
        end;

        at_CDDA   : begin
            // todo
            if ReloadDataFromFile then
            begin
                if NempOptions.UseCDDB then
                    AudioFile.GetAudioData(AudioFile.Pfad, GAD_CDDB)
                else
                    AudioFile.GetAudioData(AudioFile.Pfad, 0);
            end;
        end;
    end;

    // Trigger events to refresh the TreeView
    if assigned(fOnFilePropertiesChanged) then
        fOnFilePropertiesChanged(self);

    if AudioFile.Duration <> OldLength then
    begin
        fDauer := fDauer + (AudioFile.Duration - OldLength);
        if assigned(fOnPropertiesChanged) then
            fOnPropertiesChanged(self)
    end;
end;

function TNempPlaylist.CalculateDuration: Int64;
var i: Integer;
begin
    result := 0;
    for i:= 0 to PlayList.Count - 1 do
        result := result + PlayList[i].Duration;
end;

{
    --------------------------------------------------------
    Sorting/Mixing the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.ReInitPlaylist;
begin
  RefreshCue;

  if assigned(fOnFilePropertiesChanged) then
      fOnFilePropertiesChanged(self);
end;

procedure TNempPlaylist.Sort(Compare: IComparer<TAudioFile>);
begin
    Playlist.Sort(Compare);
    if assigned(fOnPlaylistChangedCompletely) then
        fOnPlaylistChangedCompletely(self);

    ReInitPlaylist;
    fPlaylistHasChanged := True;
end;

Procedure TNempPlaylist.ReverseSortOrder;
var i : integer;
begin
    for i := 0 to (Playlist.Count-1) DIV 2 do
        Playlist.Exchange(i,Playlist.Count-1-i);
    if assigned(fOnPlaylistChangedCompletely) then
        fOnPlaylistChangedCompletely(self);

    ReInitPlaylist;
    fPlaylistHasChanged := True;
end;

Procedure TNempPlaylist.Mix;
var i : integer;
begin
    for i := 0 to Playlist.Count-1 do
        Playlist.Exchange(i,i + random(PlayList.Count-i));
    if assigned(fOnPlaylistChangedCompletely) then
        fOnPlaylistChangedCompletely(self);

    ReInitPlaylist;
    fPlaylistHasChanged := True;
end;

///  GetSortOrderFromList
///  after a Drag&Drop-Move-Operation in the Playlist, we need to adapt the "Tree-Sorting"
///  Maybe that could be done more elegant, but this way it is more likely to be fail-proof
///  Note: aList contains just the same AudioFiles as the "real" playlist
procedure TNempPlaylist.GetSortOrderFromList(aList: TAudioFileList);
var i: Integer;
begin
    // 1. Clear the Playlist without freeing the objects
    Playlist.OwnsObjects := False;
    Playlist.Clear;
    Playlist.OwnsObjects := True;
    // 2. Add them again
    for i := 0 to aList.Count -1 do
        Playlist.Add(aList[i]);
end;


{
    --------------------------------------------------------
    Adding Files to the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.AddFileToPlaylist(Audiofile: TAudioFile; aCueName: UnicodeString = '');
begin
    // Add the File to the Playlist
    Playlist.Add(Audiofile);
    // Search for a CueSheet
    if (Audiofile.Duration > MIN_CUESHEET_DURATION) and (not assigned(Audiofile.CueList)) then
        Audiofile.GetCueList(aCueName, Audiofile.Pfad);

    fDauer := fDauer + Audiofile.Duration;
    fPlaylistHasChanged := True;

    // Trigger events
    if assigned(fOnAddAudioFile) then
        fOnAddAudioFile(self, AudioFile, -1); // -1 => Add Nodes at the End
    if assigned(self.fOnPropertiesChanged) then
        fOnPropertiesChanged(self);
end;

function TNempPlaylist.AddFileToPlaylistWebServer(aAudiofile: TAudioFile; aCueName: UnicodeString = ''): TAudioFile;
begin
    // Create a copy of the Audiofile ...
    result := TAudioFile.Create;
    result.Assign(aAudioFile);
    // ... and add it to the playlist
    AddFileToPlaylist(result, aCueName);
end;

procedure TNempPlaylist.AddFileToPlaylist(aAudiofileName: UnicodeString; aCueName: UnicodeString = '');
var NewFile: TAudioFile;
begin
    // Create a new File for this aAudiofileName ...
    NewFile := TAudioFile.Create;
    NewFile.Pfad := aAudiofileName;
    // ... GetAudioData for this file ...
    case NewFile.AudioType of
        at_File: SynchNewFileWithBib(NewFile);
        at_CDDA: begin
                  if NempOptions.UseCDDB then
                    NewFile.GetAudioData(NewFile.Pfad, GAD_CDDB)
                  else
                    NewFile.GetAudioData(NewFile.Pfad, 0);
        end;
    end;
    // ... and add it to the playlist
    AddFileToPlaylist(NewFile, aCueName);
end;


procedure TNempPlaylist.InsertFileToPlayList(Audiofile: TAudioFile; aCueName: UnicodeString = '');
begin
    if fInsertIndex = -1 then
        AddFileToPlaylist(Audiofile, aCueName)
    else
    begin
        // Insert the File into the Playlist
        Playlist.Insert(fInsertIndex, Audiofile);
        // Search for a CueSheet
        if AudioFile.Duration > MIN_CUESHEET_DURATION then
            Audiofile.GetCueList(aCueName, Audiofile.Pfad);

        fDauer := fDauer + Audiofile.Duration;
        fPlaylistHasChanged := True;

        // Trigger events
        if assigned(fOnAddAudioFile) then
            fOnAddAudioFile(self, AudioFile, fInsertIndex);
        if assigned(fOnPropertiesChanged) then
            fOnPropertiesChanged(self);

        // increase FInsertIndex for correctly inserting the next file in the queue
        Inc(fInsertIndex);
    end;
end;

function TNempPlaylist.InsertFileToPlayList(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''): TAudioFile;
var NewFile: TAudioFile;
begin
  NewFile := TAudioFile.Create;
  NewFile.Pfad := aAudiofileName;

  case NewFile.AudioType of
      at_File: SynchNewFileWithBib(NewFile);
      at_CDDA: begin
                  if NempOptions.UseCDDB then
                    NewFile.GetAudioData(NewFile.Pfad, GAD_CDDB)
                  else
                    NewFile.GetAudioData(NewFile.Pfad, 0);
        end;
  end;
  InsertFileToPlayList(NewFile, aCueName);

  result := NewFile;
end;


function TNempPlaylist.fGetPreBookCount: Integer;
begin
    result := PrebookList.Count;
end;

procedure TNempPlaylist.ReIndexPrebookedFiles;
var i:Integer;
begin
    for i := 0 to PrebookList.Count - 1 do
        PrebookList[i].PrebookIndex := i+1;
    // Refresh Treeview
    if assigned(fOnFilePropertiesChanged) then
        fOnFilePropertiesChanged(self);
end;

procedure TNempPlaylist.ProcessKeypress(aDigit: Byte; af: TAudioFile);
var oldIndex, newIndex: Integer;
    tc: Int64;
begin
    // possible values for keys are 48..57, 96..105, which should be mapped to 0..9
    // as 2*48=96 we can do this by
    while aDigit >= 48 do
        aDigit := aDigit - 48;

    if assigned(af) then
    begin
        tc := GetTickCount;
        if (af = fLastEditedAudioFile) and (tc - fLastKeypressTick < 1000) then
        begin
            oldIndex := fLastEditedAudioFile.PrebookIndex;
            newIndex := (oldIndex mod 10) * 10 + aDigit;
            // But: if NewIndex is bigger than max: Just use the Digit
            //      e.g. max Idx is 15, and we want to change 15 to 1.
            //      newIndex would be set to 51, which will be corrected to 15 in SetNewPrebookIndex
            if (oldIndex=PrebookList.Count) and (newIndex > PrebookList.Count) then
                newIndex := aDigit;
        end else
        begin
            fLastEditedAudioFile := af;
            newIndex := aDigit;
        end;
        fLastKeypressTick := tc;
        SetNewPrebookIndex(af, newIndex);
    end;
end;

procedure TNempPlaylist.SetNewPrebookIndex(aFile: TAudioFile;
  NewIndex: Integer);
begin
    // Set the Prebook-Index of the AudioFile to NewIndex
    if aFile.PrebookIndex > 0 then
    begin
        // the file is already in the PrebookList
        if NewIndex <= 0 then
        begin
            // delete the File from the Prebooklist
            aFile.PrebookIndex := 0;
            PrebookList.Remove(aFile);
        end else
        begin
            // Move it in the list to the new position
            if NewIndex-1 > PrebookList.Count-1 then
                PrebookList.Move(aFile.PrebookIndex-1, PrebookList.Count-1)
            else
                PrebookList.Move(aFile.PrebookIndex-1, NewIndex-1);
        end;
    end
    else
    begin
        // the file is NOT already in the prebooklist
        if (NewIndex > 0) and (PrebookList.Count < 99) then
        begin
            // if the index is > 0: insert. Otherwise: Do nothing
            if NewIndex-1 > PrebookList.Count then
                PrebookList.Insert(PrebookList.Count, aFile)
            else
                PrebookList.Insert(NewIndex-1, aFile);
        end;
    end;
    ReIndexPrebookedFiles;
end;

procedure TNempPlaylist.ProcessBufferStringlist;
var i, oldCount: Integer;
begin

  if LastCommandWasPlay then
  begin
      if PlaylistManager.PreparePlaylistLoading(
                      -2,
                      Playlist,
                      PlayingIndex,
                      Round(PlayingTrackPos) )
      then
      begin
          PlaylistManager.Reset;
          ClearPlaylist;
      end else
          exit;
  end;

  ProcessingBufferlist := True;
  oldCount := Playlist.Count;

  for i := 0 to BufferStringList.Count - 1 do
  begin
    AddFileToPlaylist(Bufferstringlist.Strings[i]);
  end;
  BufferStringList.Clear;
  ProcessingBufferlist := False;

  if fFirstAction then   // fFirstAction wird bei Play auf False gesetzt
  begin
      Play(fStartIndex, NempPlayer.FadingInterval, AutoPlayOnStart);
  end else
  begin
      if LastCommandWasPlay and (Playlist.Count  > 0) then
          Play(0, NempPlayer.FadingInterval, true)
      else
      begin
          if AutoPlayEnqueuedTitle and (Playlist.Count > oldCount) then
              Play(oldCount, NempPlayer.FadingInterval, true)
      end;
  end;
end;


{
    --------------------------------------------------------
    Loading/Saving the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.LoadFromFile(aFilename: UnicodeString);
begin
    // Load the new Playlist and display it
    LoadPlaylistFromFile(aFilename, Playlist, AutoScan, fDriveManager);
    if assigned(fOnPlaylistChangedCompletely) then
        fOnPlaylistChangedCompletely(self);

    fDauer := CalculateDuration;
    fPlaylistHasChanged := True;

    // Trigger events
    if assigned(self.fOnPropertiesChanged) then
        fOnPropertiesChanged(self);
end;

procedure TNempPlaylist.LoadCueSheet(filename: UnicodeString);
var tmplist: TStringList;
    i: Integer;
    AudioFilename: UnicodeString;
begin
  if Not FileExists(filename) then
    exit;
  tmplist := TStringList.Create;
  try
      tmplist.LoadFromFile(filename);
      for i:=0 to tmplist.Count - 1 do
      begin
          // nach einem "FILE"-Eintrag suchen
          if (GetCueID(tmplist[i]) = CUE_ID_FILE) then
          begin
            // FILE-Eintrag gefunden.
            AudioFilename := ExtractFilePath(filename) + GetFileNameFromCueString(tmplist[i]);
            // Wenn diese Datei existiert, dann Audiofile createn und in die Playlist einfügen
            // Sämtliches Einfügen wird in der Insert-Prozedur erledigt!
            if FileExists(AudioFilename) then
              AddFileToPlaylist(AudioFilename, filename);
          end;
      end;
  finally
      tmplist.Free;
  end;
end;

procedure TNempPlaylist.LoadManagedPlayList(aIndex: Integer);
begin
    PlaylistManager.LoadPlaylist(aIndex, Playlist, AutoScan);
    if assigned(fOnPlaylistChangedCompletely) then
        fOnPlaylistChangedCompletely(self);

    fDauer := CalculateDuration;
    fPlaylistHasChanged := True;

    // Trigger events
    if assigned(self.fOnPropertiesChanged) then
        fOnPropertiesChanged(self);
end;

function TNempPlaylist.SuggestSaveLocation(out Directory: String; out Filename: String): Boolean;
var
  i: integer;
  afc: TAudioFileCollection;

begin
    if count = 0 then
    begin
        Directory := '';
        Filename := '';
        result := False;
    end
    else
    begin
      afc := TAudioFileCollection.Create(nil, nil, 0, cmDefault);
      try
        afc.ChildContent := ccNone;
        // Add all *Files* to the Collection ...
        for i := 0 to Playlist.Count - 1 do
          if Playlist[i].IsFile then
            afc.AddAudioFile(Playlist[i]);
        // ... and analyse it
        afc.Analyse(False, True);
        // Showmessage(afc.Artist + #13#10 + afc.Album  + #13#10 + afc.Directory)

        Directory := afc.Directory;
        result := Directory <> '';

        if afc.Album <> ''  then
          Filename := afc.Artist + ' - ' + afc.Album
        else
          Filename := afc.Artist;

        Filename := ConvertToFileName(Filename);
      finally
        afc.Free;
      end;
    end;
end;

procedure TNempPlaylist.SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
var
  myAList: tStringlist;
  i: integer;
  aAudiofile: TPlaylistfile;
  ini: TMemIniFile;
begin
  if (AnsiLowerCase(ExtractFileExt(aFilename)) = '.m3u')
     or (AnsiLowerCase(ExtractFileExt(aFilename)) = '.m3u8') then
  begin
      // Mit Delphi 2009 ist das alles gleich, bis auf die Kodierung am Ende
      myAList := TStringList.Create;
      myAList.Add('#EXTM3U');

      for i := 0 to PlayList.Count - 1 do
      begin
          aAudiofile := Playlist[i] as TPlaylistfile;

          case aAudioFile.AudioType of
              at_File: begin
                  myAList.add('#EXTINF:' + IntTostr(aAudiofile.Duration) + ','
                      + aAudioFile.Artist + ' - ' + aAudioFile.Titel);
                  // myAList.Add(ExtractRelativePathNew(aFilename, aAudioFile.Pfad ));
                  myAList.Add(ExtractRelativePath(aFilename, aAudioFile.Pfad ));

              end;
              at_Stream: begin
                  myAList.add('#EXTINF:' + '0,' + aAudioFile.Description);
                  myAList.Add(aAudioFile.Pfad);
              end;
              at_CDDA: begin
                  myAList.add('#EXTINF:' + IntTostr(aAudiofile.Duration) + ','
                      + aAudioFile.Artist + ' - ' + aAudioFile.Titel);
                  myAList.Add(aAudioFile.Pfad);
              end;
          end;
      end;
      try
          if (AnsiLowerCase(ExtractFileExt(aFilename)) = '.m3u') then
              myAList.SaveToFile(aFilename, TEncoding.Default)
          else
              myAList.SaveToFile(aFilename, TEncoding.UTF8);
      except
              on E: Exception do
              if not Silent then
                  MessageDLG(E.Message, mtError, [mbOK], 0);
      end;
      FreeAndNil(myAList);
  end
  else
  // als pls speichern
  if AnsiLowerCase(ExtractFileExt(aFilename)) = '.pls' then
  begin
      ini := TMeminiFile.Create(aFilename);
      try
          ini.Clear;
          for i := 1 to PlayList.Count do
          // erster Index in pls ist 1, nicht 0
          begin
              aAudiofile := Playlist[i-1] as TPlaylistfile;
              case aAudioFile.AudioType of
                  at_File: begin
                      //ini.WriteString ('playlist', 'File'  + IntToStr(i), ExtractRelativePathNew(aFilename, aAudioFile.Pfad ));
                      ini.WriteString ('playlist', 'File'  + IntToStr(i), ExtractRelativePath(aFilename, aAudioFile.Pfad ));
                      ini.WriteString ('playlist', 'Title' + IntToStr(i), aAudioFile.Artist + ' - ' + aAudioFile.Titel);
                      ini.WriteInteger('playlist', 'Length'+ IntToStr(i), aAudioFile.Duration);
                  end;
                  at_Stream: begin
                      ini.WriteString ('playlist', 'File'  + IntToStr(i), aAudioFile.Pfad );
                      ini.WriteString ('playlist', 'Title' + IntToStr(i), aAudioFile.Description);
                      ini.WriteInteger('playlist', 'Length'+ IntToStr(i), 0);
                  end;
                  at_CDDA:  begin
                      ini.WriteString ('playlist', 'File'  + IntToStr(i), aAudioFile.Pfad );
                      ini.WriteString ('playlist', 'Title' + IntToStr(i), aAudioFile.Artist + ' - ' + aAudioFile.Titel);
                      ini.WriteInteger('playlist', 'Length'+ IntToStr(i), aAudioFile.Duration);
                  end;
              end;
          end;
          ini.WriteInteger('playlist', 'NumberOfEntries', PlayList.Count);
          ini.WriteInteger('playlist', 'Version', 2);
          try
              Ini.UpdateFile;
          except
              on E: Exception do
                  if not Silent then
                      MessageDLG(E.Message, mtError, [mbOK], 0);
          end;
      finally
          ini.Free
      end;
  end
  else
  // Im Nemp-Playlist-Foramt speichern. Ähnlich zu dem Medienbib-Format.
  if AnsiLowerCase(ExtractFileExt(aFilename)) = '.npl' then
  begin
      SavePlaylistToNPL(aFilename, Playlist, fDriveManager, Silent);
  end;
end;

(*
procedure TNempPlaylist.GetFromWinamp;
var maxW,i : integer;
    Dateiname: String;
begin
  maxW := GetWinampPlayListLength;

  if maxW = -1 then
      MessageDlg('Winamp not found', mtError, [mbOk], 0)
  else
  begin
      // Bestehende Liste löschen
      ClearPlaylist;
      // Neu füllen
      for i:=0 to maxW-1 do
      begin
          Dateiname := GetWinampFileName(i);
          // Wenn Datei nicht existiert, diese auch nicht aufnehmen:
          if Not FileExists(Dateiname) then continue;
          AddFileToPlaylist(Dateiname);
      end;
  end;
end;
*)

 {
    --------------------------------------------------------
    Getter/Setter for some properties
    --------------------------------------------------------
}
function TNempPlaylist.GetCount: Integer;
begin
  result := Playlist.Count;
end;
function TNempPlaylist.GetTime: Double;
begin
  result := Player.Time;
end;
procedure TNempPlaylist.SetTime(Value: Double);
begin
  Player.Time := Value;
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtSlide;
  // Cue-Zeug neu setzen
  RefreshCue;
end;


function TNempPlaylist.GetProgress: Double;
begin
  result := Player.Progress;
end;

procedure TNempPlaylist.SetProgress(Value: Double);
begin
  Player.Progress := Value;
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtUserInput; //DisableAutoDeleteAtSlide;
  // Cue-Zeug neu setzen
  RefreshCue;
end;

{
    --------------------------------------------------------
    Some stuff for the nodes in the TreeView
    --------------------------------------------------------
}

function TNempPlaylist.GetPlayingIndex: Integer;
begin
    if assigned(fPlayingFile) then
        result := Playlist.IndexOf(fPlayingFile)
    else
        result := -1;
end;
function TNempPlaylist.GetPlayingFileName: String;
begin
    if assigned(fPlayingFile) then
        result := fPlayingFile.Pfad
    else
        result := '';
end;

function TNempPlaylist.fGetPlayingTrackPos: Double;
begin
  if (assigned(fPlayingFile)) and (PlayList.IndexOf(fPlayingFile) >= 0) then
  begin
      if fPlayingFile.PrebookIndex = 0 then
          result := Player.Time
      else
          result := fInterruptedPlayPosition;
  end
  else
      result := 0;
end;

{
    --------------------------------------------------------
    UpdateHistory
    - add current playingfile to the history
      if we are at the beginning of the historylist, we insert the new file
      at the beginning of the list
      otherwise we add it at the end of the historylist
    --------------------------------------------------------
}
procedure TNempPlaylist.UpdateHistory(Backwards: Boolean = False);
begin
    if backwards then
    begin
        if assigned(fPlayingFile)
        and ((fCurrentHistoryFile = nil) or (HistoryList.IndexOf(fCurrentHistoryFile) = 0 ) )
        then
        begin
            HistoryList.Remove(fPlayingFile); // we MUST NOT have duplicates in this list
            HistoryList.Insert(0, fPlayingFile);
            if HistoryList.Count > 25 then
                HistoryList.Delete(HistoryList.Count-1);
            fCurrentHistoryFile := fPlayingFile;
        end;
    end else
    begin
        if assigned(fPlayingFile)
        and ((fCurrentHistoryFile = nil) or (HistoryList.IndexOf(fCurrentHistoryFile) = HistoryList.Count-1 ) )
        then
        begin
            HistoryList.Remove(fPlayingFile); // we MUST NOT have duplicates in this list
            HistoryList.Add(fPlayingFile);
            if HistoryList.Count > 25 then
                HistoryList.Delete(0);
            fCurrentHistoryFile := fPlayingFile;
        end;
    end;
end;

{
    --------------------------------------------------------
    rebuild the weighted index array used for the weighted RNG
    --------------------------------------------------------
}

procedure TNempPlaylist.SetUseWeightedRNG(aValue: Boolean);
begin
    fUseWeightedRNG := aValue;
    if fUseWeightedRNG then
        RebuildWeighedArray;
end;

procedure TNempPlaylist.RebuildWeighedArray;
var i, curIdx, totalWeight, curWeight: Integer;
    af: TAudiofile;
begin
    SetLength(fWeightedRandomIndices, Playlist.Count, 2);
    curIdx := -1;
    totalWeight := 0;
    // fill the array
    for i := 0 to Playlist.Count-1 do
    begin
        af := Playlist[i];
        curWeight := RNGWeights[RatingToArrayIndex(af.Rating)];
        if curWeight > 0 then
        begin
            // it should be possible to randomly play this file
            totalWeight := totalWeight + curWeight;
            inc(curIdx);
            fWeightedRandomIndices[curIdx, 0] := i; // the index of the current file in the playlist
            fWeightedRandomIndices[curIdx, 1] := totalWeight;
        end // else: Weight is 0, it should not be randomly played
    end;

    fMaxWeightedValue := totalWeight;  // used for Random()
    fMaxWeightedIndex := curIdx;       // used for binary search

    fPlaylistHasChanged := False;
end;

function BinIndexSearch(aArray: TIndexArray; aValue: Integer; l, r: Integer): Integer;
var m, mValue, c: Integer;
begin
    if r < l then
    begin
        if r > -1 then
            result := r
        else
            // we do not want -1 as a result!
            result := 0;
    end else
    begin
        m := (l + r) DIV 2;
        mValue := aArray[m, 1];
        c := CompareValue(aValue, mValue);
        if l = r then
            // Suche endet. l Zurückgeben - Egal ob das an der Stelle stimmt oder nicht
            result := l
        else
        begin
            if  c = 0 then
                result := m
            else if c > 0 then
                result := BinIndexSearch(aArray, aValue, m+1, r)
                else
                    result := BinIndexSearch(aArray, aValue, l, m-1);
        end;
    end;
end;

function TNempPlaylist.GetRandomPlaylistIndex: Integer;
var rawIndex, searchL, searchR, weightedIndex: Integer;
begin
    if not fUseWeightedRNG then
        result := Random(Playlist.Count)
    else
    begin
        if fPlaylistHasChanged then
            RebuildWeighedArray;

        searchL := 0;
        searchR := fMaxWeightedIndex; // length(fWeightedRandomIndices) - 1;

        // get a weighted result
        rawIndex := Random(fMaxWeightedValue);
        // get the playlist-Index from that index
        weightedIndex := BinIndexSearch(fWeightedRandomIndices, rawIndex, searchL, searchR);

        // binary search may not find the exact rawIndex, probably the first bigger or smaller entry
        // we need always the bigger (or equal) one
        if (fWeightedRandomIndices[weightedIndex, 1] < rawIndex)
            and (length(fWeightedRandomIndices) > weightedIndex + 1)
        then
            inc(weightedIndex);

        result := fWeightedRandomIndices[weightedIndex, 0];
        // to be sure: range check
        if (result < 0) or (result >= Playlist.Count ) then
        begin
            // fallback to regular random
            result := Random(Playlist.Count);
            // set flag to force rebuild of the index array the next time.
            fPlaylistHasChanged := False;
        end;
    end;
end;

{
    --------------------------------------------------------
    Getting an Audiofile
    --------------------------------------------------------
}
function TNempPlaylist.GetAnAudioFile: TPlaylistFile;
begin
  if assigned(PlayingFile) and (Playlist.IndexOf(PlayingFile) >= 0) then
      result := PlayingFile
  else
  begin
      if Playlist.Count > 0 then
          result := Playlist[0]
      else
          result := Nil;
  end;
end;

function TNempPlaylist.GetNextAudioFileIndex: Integer;
var i:integer;
  tmpAudioFile: TPlaylistfile;
  c: Integer;
  historySuccess: Boolean;
begin
    // 1. add current file to the history, if needed
    // i.e. we are at the end (or the beginning) of the HistoryList
    UpdateHistory;
    // 2. if we are currently "browsing" in the Historylist, get the next one
    if assigned(fCurrentHistoryFile) and (HistoryList.IndexOf(fCurrentHistoryFile) < HistoryList.Count-1 ) then
    begin
        // we are "browsing in the history list"
        c := HistoryList.IndexOf(fCurrentHistoryFile);
        // get the next one
        if (fPlayingFile = fCurrentHistoryFile) and (c < HistoryList.Count-1) then
        begin
            fCurrentHistoryFile := TPlaylistfile(HistoryList[c+1]);
            result := Playlist.IndexOf(fCurrentHistoryFile);
            historySuccess := result > -1
        end else
        begin
            if (c >= 0) then
            begin
                // this occurs, when we browse backwards further than the first "real history file"
                // so the UpdateHistory will add the file, currentHistoryFile is valid and at first position
                // then another title was played
                // and now we want this previous played song, So, we do not change position in HistoryList
                fCurrentHistoryFile := TPlaylistfile(HistoryList[c]);
                result := Playlist.IndexOf(fCurrentHistoryFile);
                historySuccess := result > -1
            end else
            begin
                historySuccess := False;
                result := 0; // dummy, so the compiler dont show a warning
            end;
        end;
    end else
    begin
        historySuccess := False;
        result := 0; // dummy, so the compiler dont show a warning
    end;

    if not historySuccess then
    begin
        if PrebookList.Count > 0 then
        begin
            tmpAudioFile := PrebookList[0];
            // the new selected file IS NOT equal to the interrupted file
            // => set the interruptedPLayPosition to 0
            if fInterruptedFile <> tmpAudioFile then
                fInterruptedPlayPosition := 0;

            result := Playlist.IndexOf(tmpAudioFile);
            PrebookList.Delete(0);
            tmpAudioFile.PrebookIndex := 0;
            ReIndexPrebookedFiles;
        end
        else
        begin
            fInterruptedPlayPosition := 0;
            if WiedergabeMode <> 2 then  //  kein Zufall , +1 Mod Count, ggf. Liste neu mischen
            begin
                // Index auf aktuellen  + 1
                if (fPlayingFile <> NIL) and (fPlayingFile <> fBackupFile) then
                    result := PlayList.IndexOf(fPlayingFile) + 1
                else
                    result := 0; //fPlayingIndex ; // nicht um eins erhöhen !!

                if result > PlayList.Count-1 then
                begin
                    result := 0;
                    if fAutoMix then
                    begin // Playlist neu durchmischen
                        for i := 0 to Playlist.Count-1 do
                          Playlist.Move(i,i + random(PlayList.Count-i));
                        // Trigger Refill-Event
                        if assigned(fOnPlaylistChangedCompletely) then
                            fOnPlaylistChangedCompletely(self);
                    end;
                end
            end else
            // shufflemode
            begin
                if Playlist.Count = 0 then
                    result := -1
                else begin
                    result := GetRandomPlaylistIndex;

                    // 1st round: Do some more random trials
                    c := 0;
                    tmpAudioFile := PlayList[result] as TPlaylistfile;
                    while ((fPlayCounter - tmpAudioFile.LastPlayed) <= Round(RandomRepeat * Playlist.Count/100))
                          AND (tmpAudioFile.LastPlayed <> 0)
                          AND (c <= 5) do
                    begin
                        inc(c);
                        result := GetRandomPlaylistIndex;
                        tmpAudioFile := PlayList[result] as TPlaylistfile;
                    end;

                    //2nd round: just get the next file
                    c := 0;
                    tmpAudioFile := PlayList[result] as TPlaylistfile;
                    while ((fPlayCounter - tmpAudioFile.LastPlayed) <= Round(RandomRepeat * Playlist.Count/100))
                          AND (tmpAudioFile.LastPlayed <> 0)
                          AND (c <= PlayList.Count) do
                    begin
                        inc(c);
                        result := (result + 1) MOD Playlist.Count;
                        tmpAudioFile := PlayList[result] as TPlaylistfile;
                    end;
                end;
            end;
        end;
    end;
end;

function TNempPlaylist.GetPrevAudioFileIndex: Integer;
var c: Integer;
    historySuccess: Boolean;
begin
    UpdateHistory(True);
    if assigned(fCurrentHistoryFile) and (HistoryList.IndexOf(fCurrentHistoryFile) >= 0 ) then
    begin
        // we are "browsing in the history list"
        c := HistoryList.IndexOf(fCurrentHistoryFile);
        // get the previous one
        if (fPlayingFile = fCurrentHistoryFile) and (c > 0) then
        begin
            fCurrentHistoryFile := TPlaylistfile(HistoryList[c-1]);
            result := Playlist.IndexOf(fCurrentHistoryFile);
            historySuccess := result > -1
        end else
        begin
            if (c > 0) then
            begin
                fCurrentHistoryFile := TPlaylistfile(HistoryList[c]);
                result := Playlist.IndexOf(fCurrentHistoryFile);
                historySuccess := result > -1
            end else
            begin
                historySuccess := False;
                result := 0; // dummy, so the compiler dont show a warning
            end;
        end;
    end else
    begin
        historySuccess := False;
        result := 0; // dummy, so the compiler dont show a warning
    end;

    if not historySuccess then
    begin // fallback to "normal previous"
        if (fPlayingFile <> NIL)  and (fPlayingFile <> fBackupFile) then
            result := PlayList.IndexOf(fPlayingFile) - 1
        else
            result := 0; // fPlayingIndex-1;
        if (result < 0) then
            result := Playlist.Count - 1;
        if (result < 0) then
            result := 0;
    end;
end;


procedure TNempPlaylist.UserInput;
begin
  fErrorCount := 0;
  // cancel the delayed "play next" timer
  Player.StopPauseBetweenTracksTimer;
end;

procedure TNempPlaylist.RepairBassEngine(StartPlay: Boolean);
var OldTime: Single;
begin
  OldTime := Player.Time;
  StartPlay := StartPlay AND (Player.Status = PLAYER_ISPLAYING);
  // Wiedergabe stoppen
  Player.StopAndFree;
  // BassEngine wieder herstellen
  Player.ReInitBassEngine;
  // Altes Lied wieder starten
  if assigned(PlayingFile) then
  begin
    Play(PlayingIndex, 0, StartPlay, OldTime);
    Player.Time := OldTime;
  end
end;


{
    --------------------------------------------------------
    Getting an Adiofile with the given ID
    Used by the Nemp Webserver
    --------------------------------------------------------
}
function TNempPlaylist.GetPlaylistIndexByWebServerID(aID: Int64): Integer;
var i: Integer;
begin
    result := -1;
    for i := 0 to Playlist.Count - 1 do
    begin
        if Playlist[i].WebServerID = aID then
        begin
            result := i;
            break;
        end;
    end;
end;


///  SwapFiles is called By the Webserver when the User clicks on "MoveUp/MoveDown"
///  a and b differs by exactly 1, =>  a = b +/- 1
function TNempPlaylist.SwapFiles(a, b: Integer): Boolean;
var tmp: Integer;
begin
    if a > b then
    begin
        tmp := a;
        a := b;
        b := tmp;
    end;
    // now: a < b, with a+1 = b

    if (a > -1) and (b > -1) and (a < Playlist.Count) and (b < Playlist.Count) then
    begin
        Playlist.Move(b, a);
        // Trigger event to move the nodes in the TreeView
        // we want Node [b] to move one position up, so before [a]
        if assigned(fOnFileMoved) then
            fOnFileMoved(self, Playlist[b], b, a);

        result := True;
    end else
        result := False;

    fPlaylistHasChanged := True;
end;

procedure TNempPlaylist.ResortVotedFile(aFile: TAudioFile; aIndex: Integer);
var newIdx: Integer;
begin
    // aFile: the AudioFile we want to move now
    // aIndex: The index of this file in the Playlist

    // nothing to do if we voted for the current PlayingFile.
    if aFile = fPlayingFile then
        exit;

    newIDx := InitInsertIndexFromPlayPosition(True);
    if newIDX < 0 then
        newIDX := Playlist.Count;

    while (newIdx < Playlist.Count) and (Playlist[newIdx].VoteCounter >= aFile.VoteCounter) do
        inc(newIdx);

    ///  now:     (newIdx = Playlist.Count) or (Playlist[newIdx]) has smaller VoteCounter
    ///  => aFile should be moved *before* the File placed currently on Playlist[newIDX]
    ///     (or at the very end of the playlist, if newIdx = Playlist.Count)

    // Trigger event to move the nodes in the TreeView
    if assigned(fOnFileMoved) then
        fOnFileMoved(self, aFile, aIndex, newIdx);

    // In the List, we don't want to place the file at a specific *index*.
    // Instead, we want it before the entry with the newIdx. Therefore:
    if aIndex < newIdx then
        dec(newIdx);

    // move the File in the list
    Playlist.Move(aIndex, newIdx);
    fPlaylistHasChanged := True;
end;

procedure TNempPlaylist.ReSynchronizeDrives;
var i: Integer;
begin
    if TDriveManager.EnableUSBMode then
    begin
        fDriveManager.ReSynchronizeDrives;
        if fDriveManager.DrivesHaveChanged then
            // repair the files
            fDrivemanager.RepairDriveCharsAtAudioFiles(Playlist);

        // recheck file existence anyway
        // A new drive with the "orignal" letter could have been connected right now!
        for i := 0 to Playlist.Count-1 do
        begin
            if not Playlist[i].FileIsPresent then
                Playlist[i].FileIsPresent := FileExists(Playlist[i].Pfad);
        end;
    end;
end;

procedure TNempPlaylist.SynchFilesWithCDDrive(CDDADrive: TCDDADrive);
var
  i: Integer;
  TrackData: TCDTrackData;
begin
  for i := 0 to Playlist.Count - 1 do begin
    if (length(Playlist[i].Pfad) > 0) and (Playlist[i].Pfad[1] = CDDADrive.Letter) then begin
      CDDADrive.GetTrackData(Playlist[i].Pfad, TrackData);
      Playlist[i].AssignCDTrackData(TrackData);
    end;
  end;
  fDauer := CalculateDuration;
  if assigned(fOnFilePropertiesChanged) then
    fOnFilePropertiesChanged(self);
  if assigned(fOnPropertiesChanged) then
    fOnPropertiesChanged(self);
end;

{
    --------------------------------------------------------
    Unify the rating for a given Audiofile (identified by its filename)
    Used when the user changes the rating of a file
    --------------------------------------------------------
}
procedure TNempPlaylist.UnifyRating(aFilename: String; aRating: Byte; aCounter: Integer);
var i: Integer;
    af: TAudioFile;
begin
    for i := 0 to Playlist.Count - 1 do
    begin
        af := Playlist[i];
        if af.Pfad = aFilename then
        begin
            af.Rating := aRating;
            af.PlayCounter := aCounter;
        end;
        if af = Player.MainAudioFile then
            Spectrum.DrawRating(af.Rating);
    end;
end;

procedure TNempPlaylist.CollectFilesWithSameFilename(aFilename: String;
  Target: TAudioFileList);
var i: Integer;
    af: TAudioFile;
begin
    for i := 0 to Playlist.Count - 1 do
    begin
        af := Playlist[i];
        if af.Pfad = aFilename then
            Target.Add(af);
    end;
end;


end.
