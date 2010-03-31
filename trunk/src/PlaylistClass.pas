{

    Unit PlaylistClass

    One of the Basic-Units - The Playlist

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}

unit PlaylistClass;

interface

uses Windows, Forms, Contnrs, SysUtils,  VirtualTrees, IniFiles, Classes, 
    Dialogs, MMSystem, oneinst,
    Hilfsfunktionen, Nemp_ConstantsAndTypes,

    AudioFileClass, AudioFileHelper, WinampFunctions,  PlayerClass,
    gnuGettext, Nemp_RessourceStrings;

type
  DWORD = cardinal;

  TPreBookInsertMode = (pb_Beginning, pb_End);

  TNempPlaylist = Class
    private
      fDauer: Int64;                      // Duration of the Playlist in seconds
      fPlayingFile: TPlaylistFile;        // the current Audiofile
      fBackupFile : TPlaylistFile;        // if we delete the playingfile from the playlist, we store a copy of it here
      fPlayingIndex: Integer;             // ... its index in the list
      fPlayingNode: PVirtualNode;         // ... and its node in the Treeview
      fActiveCueNode: PVirtualNode;       // ... the active cuenode

      fPlayingFileUserInput: Boolean;     // True, after the user slides/paused/... the current audiofile.
                                          // Then the file should (depending on settings) not be deleted after playback
      fWiedergabeMode: Integer;           // One after the other, Random, ...
      fAutoMix: Boolean;                  // Mix playlist after the last title
      fJumpToNextCueOnNextClick: Boolean; // Jump only to next cue on "Next"
      fShowHintsInPlaylist: Boolean;
      fPlayCounter: Integer;              // used for a "better random" selection

      fVST: TVirtualStringTree;           // the Playlist-VirtualStringTree
      fInsertNode: PVirtualNode;          // InsertNode/-Index: used for insertion of Files
      fInsertIndex: Integer;              //    (e.g. on DropFiles)

      fErrorCount: Integer;               // Stop "nextfile" after one cycle if all files in the playlist could not be found
      fFirstAction: Boolean;              // used for inserting files (ProcessBufferStringlist). On Nemp-Start the playback should bes started.
                                          // see "AutoPlayNewTitle"


      fInterruptedPlayPosition: Double;   // the Position in the track that was played just before the
                                          // user played a title directly from the library
      fInterruptedFile : TAudioFile;      // The track itself
      fRememberInterruptedPlayPosition: Boolean; // Use this position and start playback of the track there

      fLastEditedAudioFile: TAudioFile;   // the last edited AudioFile when manually sorting the PrebookList by keypress
      fLastKeypressTick: Int64;           // TickCount when the last keypress occured

      // PrebookList: Stores the prebooked AudioFiles,
      // i.e. the files that are marked as "play next"
      PrebookList: TObjectList;
      function fGetPreBookCount: Integer;

      procedure SetInsertNode(Value: PVirtualNode);
      function GetAnAudioFile: TPlaylistFile;
      function GetNextAudioFileIndex: Integer;
      function GetPrevAudioFileIndex: Integer;

      function GetNodeWithPlayingFile: PVirtualNode;
      Procedure ScrollToPlayingNode;

      procedure AddCueListNodes(aAudioFile: TAudioFile; aNode: PVirtualNode);
      function GetActiveCueNode(aIndex: Integer): PVirtualNode;
      function GetCount: Integer;

      function GetPlayingIndex: Integer;

      // Kapselungen der entsprechenden Player-Routinen
      // bei den Settern zus�tzlich Cue-Zeug-Handling dabei.
      function GetTime: Double;
      procedure SetTime(Value: Double);
      function GetProgress: Double;
      procedure SetProgress(Value: Double);



    public
      Playlist: TObjectlist;              // the list with the audiofiles
      Player: TNempPlayer;                // the player-object

      // Some settings for the playlist, stored in the Ini-File
      AutoPlayOnStart: Boolean;     // begin playback when Nemp starts
      SavePositionInTrack: Boolean; // save current position in track and restore it on next start
      PositionInTrack: Integer;
      AutoPlayNewTitle: Boolean;    // Play new title when the user selects "Enqueue in Nemp" in the explorer (and Nemp is not running, yet)
      AutoSave: Boolean;            // Save Playlist every 5 minutes
      AutoScan: Boolean;            // Scan files with Mp3fileUtils
      AutoDelete: Boolean;                  // Delete File after playback
        DisableAutoDeleteAtSlide: Boolean;  // ... but not after slide
        DisableAutoDeleteAtPause: Boolean;  // ... after the user paused the title once
        DisAbleAutoDeleteAtStop: Boolean;   // ... when the user clicks "stop"
        DisableAutoDeleteAtTitleChange: Boolean;  // ...when the user clicks "next"
      BassHandlePlaylist: Boolean;      // let the bass.dll handle webstream-playlists
      RandomRepeat: Integer;   // 0..100% - which part of the Playlist should be played before a song is selected "randomly" again?

      // default-action when the user doubleclick an item in the medialibrary
      DefaultAction: Integer;

      TNA_PlaylistCount: Integer; // number of files displayed in the TNA-menu

      YMouseDown: Integer;      // Needed for dragging inside the playlist
      AcceptInput: Boolean;     // Block inputs after a successful beginning of playback for a short time.
                                // Multimediakeys seems to do some weird things otherwise

      MainWindowHandle: DWord;  // The Handle to the Nemp main window

      ST_Ordnerlist: TStringList; // Joblist for SearchTools

      Status: Integer;

      LastCommandWasPlay: Boolean;      // some vars needed for Explorer-stuff
      ProcessingBufferlist: Boolean;    //like "play/enqueue in Nemp"
      BufferStringList: TStringList;

      property Dauer: Int64 read fDauer;
      property Count: Integer read GetCount;

      property Time: Double read GetTime write SetTime;             // Do some Cue-Stuff here!
      property Progress: Double read GetProgress write SetProgress;

      property PlayingFile: TPlaylistFile read fPlayingFile;
      property PlayingIndex: Integer read GetPlayingIndex write fplayingIndex;
      property PlayingNode: PVirtualNode read fPlayingNode;
      property ActiveCueNode: PVirtualNode read fActiveCueNode;
      property PlayingFileUserInput: Boolean read fPlayingFileUserInput write fPlayingFileUserInput;
      property WiedergabeMode: Integer read fWiedergabeMode write fWiedergabeMode;
      property AutoMix: Boolean read fAutoMix write fAutoMix;
      property JumpToNextCueOnNextClick: Boolean read fJumpToNextCueOnNextClick write fJumpToNextCueOnNextClick;
      property RememberInterruptedPlayPosition: Boolean read fRememberInterruptedPlayPosition write fRememberInterruptedPlayPosition;

      property ShowHintsInPlaylist: Boolean read fShowHintsInPlaylist write fShowHintsInPlaylist;

      property PlayCounter: Integer read fPlayCounter;
      property VST: TVirtualStringTree read fVST write fVST;

      property InsertNode: PVirtualNode read fInsertNode write SetInsertNode;
      property InsertIndex: Integer read fInsertIndex;
      property PrebookCount: Integer read fGetPreBookCount;


      constructor Create;
      destructor Destroy; override;

      procedure LoadFromIni(Ini: TMemIniFile);
      procedure WriteToIni(Ini: TMemIniFile);

      // the most important methods: Play, Playnext, ...
      procedure Play(aIndex: Integer; aInterval: Integer; Startplay: Boolean; Startpos: Double = 0);
      procedure PlayBibFile(aFile: TAudioFile; aInterval: Integer);

      procedure PlayNextFile(aUserinput: Boolean = False);
      procedure PlayNext(aUserinput: Boolean = False);
      procedure PlayPrevious(aUserinput: Boolean = False);
      procedure PlayPreviousFile(aUserinput: Boolean = False);
      procedure PlayFocussed;
      procedure PlayAgain(ForcePlay: Boolean = False);
      procedure Pause;
      procedure Stop;

      procedure DeleteMarkedFiles;  // Delete selected files
      procedure ClearPlaylist;      // Delete whole playlist
      procedure DeleteDeadFiles;    // Delete dead (non existing) files
      procedure RemovePlayingFile;  // Remove the current file from the list

      //// Some GUI-Stuff
      // Get the InsertNode from current playing position
      // Note: The PlayingNode can be NIL, so this is a little bit more complicated. ;-)
      procedure GetInsertNodeFromPlayPosition;
      procedure FillPlaylistView;   // Fill the playist-Tree
      // Set CueNode and invalidate TreeView
      procedure ActualizeCue;
      // Get Audiodata from the current selected Node and repaint it
      // used e.g. in OnChange of the TreeView
      procedure ActualizeNode(aNode: pVirtualNode);
      procedure UpdatePlayListHeader(aVST: TVirtualStringTree; Anzahl: Integer; Dauer: Int64);
      function ShowPlayListSummary: Int64;

      //// Sorting the playlist
      procedure ReInitPlaylist;     // correct the NodeIndex and stuff after a sorting of the playlist
      procedure Sort(Compare: TListSortCompare);
      Procedure ReverseSortOrder;
      Procedure Mix;

      // adding files into the playlist
      // return value: the new node in the treeeview. Used for scrolling to this node
      function AddFileToPlaylist(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''):PVirtualNode; overload;
      function InsertFileToPlayList(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''):PVirtualNode; overload;
      function AddFileToPlaylist(Audiofile: TAudioFile; aCueName: UnicodeString = ''):PVirtualNode; overload;
      function InsertFileToPlayList(Audiofile: TAudioFile; aCueName: UnicodeString = ''):PVirtualNode; overload;
      procedure ProcessBufferStringlist;

      // adding a node to the PrebookList.
      // (not an Audiofile, so we can use this method directly from the Playlist-VST
      //  and after adding a file from the library to the playlist)
      procedure AddNodeToPrebookList(aNode: PVirtualnode);
      procedure ReIndexPrebookedFiles;
      procedure SetNewPrebookIndex(aFile: TAudioFile; NewIndex: Integer);
      procedure ProcessKeypress(aDigit: Byte; aNode: PVirtualNode);
      // Adding/removing selected Nodes form the PrebookList
      procedure AddSelectedNodesToPreBookList(Mode: TPreBookInsertMode);
      procedure RemoveSelectedNodesFromPreBookList;

      // load/save playlist
      procedure LoadFromFile(aFilename: UnicodeString);
      procedure SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
      // copy it from Winamp
      procedure GetFromWinamp;

      // The user wants us something todo => Set ErrorCount to 0
      procedure UserInput;

      // Reinit Bass-Engine. Needed sometimes after suspending the system.
      procedure RepairBassEngine(StartPlay: Boolean);

      // when the user change the rating of a audiofile-object, it should be
      // changed in the whole playlist. (It could be multiply times in the playlist!)
      procedure UnifyRating(aFilename: String; aRating: Byte);

      procedure CollectFilesWithSameFilename(aFilename: String; Target: TObjectList);

      // Search the Playlist for an ID. Used by Nemp Webserver
      // The links in the html-code will contain these IDs, so they will be valid
      // until the "real" Nemp-User deletes a file from the playlist.
      function GetPlaylistIndex(aID: Int64): Integer;
  end;

implementation

uses NempMainUnit, spectrum_vis;

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
  Playlist := TObjectList.Create;
  ST_Ordnerlist := TStringList.Create;
  PrebookList := TObjectList.Create(False);
  fPlayingFile := Nil;
  fBackupFile := TPlayListFile.Create;
  AcceptInput := True;
  Status := 0;
  BufferStringList := TStringList.Create;
  ProcessingBufferlist := False;
  fFirstAction := True;
end;

destructor TNempPlaylist.Destroy;
begin
  PrebookList.Free;
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
procedure TNempPlaylist.LoadFromIni(Ini: TMemIniFile);
begin
  DefaultAction         := ini.ReadInteger('Playlist','DefaultAction',0);
  WiedergabeMode        := ini.ReadInteger('Playlist','WiedergabeModus',0);
  AutoScan              := ini.ReadBool('Playlist','AutoScan', True);
  AutoPlayOnStart       := ini.ReadBool('Playlist','AutoPlayOnStart', True);
  AutoPlayNewTitle      := ini.ReadBool('Playlist','AutoPlayNewTitle', True);
  AutoSave              := ini.ReadBool('Playlist','AutoSave', True);
  AutoDelete            := ini.ReadBool('Playlist','AutoDelete', False);
  DisableAutoDeleteAtSlide        := ini.ReadBool('Playlist','DisableAutoDeleteAtSlide', True);
  DisableAutoDeleteAtPause        := ini.ReadBool('Playlist','DisableAutoDeleteAtPause', True);
  DisAbleAutoDeleteAtStop         := ini.ReadBool('Playlist','DisAbleAutoDeleteAtStop', True);
  DisableAutoDeleteAtTitleChange  := ini.ReadBool('Playlist','DisableAutoDeleteAtTitleChange', True);
  fAutoMix                        := ini.ReadBool('Playlist','AutoMix', False);
  fJumpToNextCueOnNextClick       := Ini.ReadBool('Playlist', 'JumpToNextCueOnNextClick', True);
  fRememberInterruptedPlayPosition:= Ini.ReadBool('Playlist', 'RememberInterruptedPlayPosition', True);
  fShowHintsInPlaylist  := Ini.ReadBool('Playlist', 'ShowHintsInPlaylist', True);
  RandomRepeat          := Ini.ReadInteger('Playlist', 'RandomRepeat', 25);
  TNA_PlaylistCount     := ini.ReadInteger('Playlist','TNA_PlaylistCount',30);
  fPlayingIndex         := ini.ReadInteger('Playlist','IndexinList',-1);
  SavePositionInTrack   := ini.ReadBool('Playlist', 'SavePositionInTrack', True);
  PositionInTrack       := ini.ReadInteger('Playlist', 'PositionInTrack', 0);
  BassHandlePlaylist    := Ini.ReadBool('Playlist', 'BassHandlePlaylist', False);
end;

procedure TNempPlaylist.WriteToIni(Ini: TMemIniFile);
var idx: Integer;
begin
  ini.WriteInteger('Playlist','DefaultAction', DefaultAction);
  ini.WriteInteger('Playlist','WiedergabeModus',WiedergabeMode);
  ini.WriteInteger('Playlist','TNA_PlaylistCount',TNA_PlaylistCount);
  //if PlayingFile <> NIL then
  //    idx := PlayList.IndexOf(fPlayingFile)
  //else
      idx := fPlayingIndex;
  ini.WriteInteger('Playlist','IndexinList',idx);
  ini.WriteBool('Playlist', 'SavePositionInTrack', SavePositionInTrack);

  if (assigned(fPlayingFile)) and (idx = PlayList.IndexOf(fPlayingFile)) then
      ini.WriteInteger('Playlist', 'PositionInTrack', Round(Player.Time))
  else
  // this should be the case when we play a bibfile right now
      ini.WriteInteger('Playlist', 'PositionInTrack', Round(fInterruptedPlayPosition));

  ini.WriteBool('Playlist','AutoScan', AutoScan);
  ini.WriteBool('Playlist','AutoPlayOnStart', AutoPlayOnStart);
  ini.WriteBool('Playlist','AutoPlayNewTitle', AutoPlayNewTitle);
  Ini.WriteBool('Playlist','AutoSave', AutoSave);

  Ini.WriteBool('Playlist','AutoDelete', AutoDelete);
  ini.WriteBool('Playlist','DisableAutoDeleteAtSlide', DisableAutoDeleteAtSlide);
  ini.WriteBool('Playlist','DisableAutoDeleteAtPause', DisableAutoDeleteAtPause);
  ini.WriteBool('Playlist','DisAbleAutoDeleteAtStop', DisAbleAutoDeleteAtStop);
  ini.WriteBool('Playlist','DisableAutoDeleteAtTitleChange', DisableAutoDeleteAtTitleChange);

  Ini.WriteBool('Playlist','AutoMix', fAutoMix);
  Ini.WriteBool('Playlist', 'JumpToNextCueOnNextClick', fJumpToNextCueOnNextClick);
  Ini.WriteBool('Playlist', 'RememberInterruptedPlayPosition', fRememberInterruptedPlayPosition);

  Ini.WriteBool('Playlist', 'ShowHintsInPlaylist', fShowHintsInPlaylist);
  Ini.WriteInteger('Playlist', 'RandomRepeat', RandomRepeat);
  Ini.WriteBool('Playlist', 'BassHandlePlaylist', BassHandlePlaylist);
end;


{
    --------------------------------------------------------
    main methods. Play, Playnext, ...
    --------------------------------------------------------
}
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
          // Note GetAnAudioFile will return the "backupFile" from the medialibrary if it is set!
          if NewFile <> fBackupFile then
              fPlayingIndex := Playlist.IndexOf(NewFile);
          BackupFileIsPlayedAgain := NewFile = fBackupFile;
      end else
          if (aIndex < Playlist.Count) AND (Playlist.Count > 0) then
          begin
              NewFile := TPlaylistFile(Playlist[aIndex]);
              fplayingIndex := aIndex;
          end;
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
        OriginalLength := NewFile.Duration;
        fPlayingFile := NewFile;
        fPlayingFileUserInput := False;
        Player.play(fPlayingFile, aInterval, Startplay, Startpos);  // da wird die Dauer ge�ndert
        // reset the interruptedPlayPosition
        if not BackupFileIsPlayedAgain then
            fInterruptedPlayPosition := 0;

        fPlayingNode := GetNodeWithPlayingFile;
        ScrollToPlayingNode;
        // Anzeige Im Baum aktualisieren
        VST.Invalidate;
        // Knoten aktualisieren - u.A. AudioDaten neu einlesen
        // bei Player.Play() kommt zuerst GetAudioData, dann Korrekturen der bass dran
        // d.h. Hier wird dann GetAudioData nicht erneut ausgef�hrt!
        ActualizeNode(fPlayingNode);
        ActualizeCue;
      end;

  // Wenn was schiefgelaufen ist, d.h. der mainstream = 0 ist
  if (Player.MainStream = 0) And (Not Player.URLStream) then
  begin
    try
        if fErrorCount < Playlist.Count then
        begin
          AcceptInput := True;
          if assigned(fPlayingNode) then VST.InvalidateNode(fPlayingNode);
          inc(fErrorCount);

          fDauer := fDauer  - OriginalLength;

          PlayNext; // bei der n�chsten Datei einen neuen verusch starten
        end else
        begin
          AcceptInput := True;
          if assigned(fPlayingNode) then VST.InvalidateNode(fPlayingNode);
          fDauer := fDauer  - OriginalLength;
          Stop;
          VST.Header.Columns[1].Text := SekToPlaylistZeitString(fDauer);
          //showmessage(Inttostr(fDauer));
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
          //OldLength := fPlayingFile.Dauer;
          fPlayingFile.Duration := Round(Player.Dauer);
          fDauer := fDauer + (fPlayingFile.Duration - OriginalLength);
          VST.Header.Columns[1].Text := SekToPlaylistZeitString(fDauer);
          VST.Invalidate;
        end;
    except
        MessageDlg((BadError_Play1) + ' (3).', mtError, [mbOK], 0) ;
    end;

    // Aufgestaute Nachrichten abarbeiten
    // Grml. Die Multimediakeys machen da wieder �rger.
    // Scheinbar gehts wirklich nur, wenn man AcceptInput erst nach einer gewissen Zeit
    // wieder freigibt...
    tid := timeSetEvent(300, 10, @APM, MainWindowHandle, TIME_ONESHOT);
  end;
end;

procedure TNempPlaylist.PlayBibFile(aFile: TAudioFile; aInterval: Integer);
begin
    if not AcceptInput then exit;

    // increase fPlayingIndex, so we will play the next file in the playlist after this one // no
    if assigned(fPlayingFile) and (fPlayingIndex = Playlist.IndexOf(fPlayingFile)) then
    begin
        // we will backup the index AND the current playposition, so we can
        // start next playback right where we are NOW
        fInterruptedPlayPosition := Player.Time;
        fInterruptedFile := fPlayingFile;

        // additionally, we set the current track on the beginning of the prebook-list
        PrebookList.Insert(0, fPlayingFile);
        if PrebookList.Count > 99 then
        begin
            TAudioFile(PrebookList[PrebookList.Count-1]).PrebookIndex := 0;
            PrebookList.Delete(PrebookList.Count-1);
        end;
        ReIndexPrebookedFiles;
    end;

    if (not assigned(fPlayingFile)) and (fPlayingIndex = -1) then
        fPlayingIndex := 0;

    // Eingaben kurzfristig blocken
    AcceptInput := False;

    if Assigned(aFile) then
    begin
      fBackUpFile.Assign(aFile);
      fPlayingFile := fBackUpFile;

      fPlayingFileUserInput := False;
      // Player.play, not self.play!
      Player.play(fPlayingFile, aInterval, True, 0);  // da wird die Dauer ge�ndert

      fPlayingNode := GetNodeWithPlayingFile;
      // Anzeige Im Baum aktualisieren
      VST.Invalidate;
    end;

  // Wenn was schiefgelaufen ist, d.h. der mainstream = 0 ist
  if (Player.MainStream = 0) And (Not Player.URLStream) then
     // nothing
  else
  begin
      // Aufgestaute Nachrichten abarbeiten
      // Grml. Die Multimediakeys machen da wieder �rger.
      // Scheinbar gehts wirklich nur, wenn man AcceptInput erst nach einer gewissen Zeit
      // wieder freigibt...
      tid := timeSetEvent(300, 10, @APM, MainWindowHandle, TIME_ONESHOT);
  end;

end;

procedure TNempPlaylist.PlayNext(aUserinput: Boolean = False);
var nextIdx: Integer;
begin
  if not AcceptInput then exit;

  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtTitleChange;

  if fJumpToNextCueOnNextClick and (Player.JumpToNextCue) then
  begin
      ActualizeCue;  // nothing else todo. Jump complete :D
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
end;

procedure TNempPlaylist.PlayNextFile(aUserinput: Boolean = False);
var sPos: Double;
    nextIdx: Integer;
begin
  if not AcceptInput then exit;

  Player.stop; // Neu im Oktober 2008
  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtTitleChange;

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
end;

procedure TNempPlaylist.PlayPrevious(aUserinput: Boolean = False);
begin
  if not AcceptInput then exit;
  if aUserInput then
    fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtTitleChange;
  if fJumpToNextCueOnNextClick and (Player.JumpToPrevCue) then
  begin
      ActualizeCue;   // nothing else todo. Jump complete :D
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
end;

procedure TNempPlaylist.PlayPreviousFile(aUserinput: Boolean = False);
begin
  if not AcceptInput then exit;
  Player.stop; // Neu im Oktober 2008
  if aUserInput then
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtTitleChange;

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

procedure TNempPlaylist.PlayFocussed;
var Node, NewCueNode: PVirtualNode;
    Data: PTreeData;
    CueTime: Single;
begin
  if not AcceptInput then exit;
  Node := VST.FocusedNode;
  if Not Assigned(Node) then Exit;
  if Not VST.Selected[Node] then Exit;

  if VST.GetNodeLevel(Node)=0 then
  begin
      Play(Node.Index, Player.FadingInterval, True);
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtTitleChange;
  end else
  begin
      fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtSlide;
      Data := VST.GetNodeData(Node);
      if assigned(Data) then
          CueTime := Data^.FAudioFile.Index01
      else CueTime := 0;

      NewCueNode := Node;
      node := VST.NodeParent[Node];
      Data := VST.GetNodeData(Node);

      if assigned(Data) and (Data^.FAudioFile = PlayingFile) then
      begin
          Player.Time := CueTime;
          fActiveCueNode := NewCueNode;
          VST.Invalidate;
      end else
      begin
          if assigned(Data) then
              Play(Node.Index, Player.FadingInterval, True, CueTime );
      end;
  end;
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
          Play(fPlayingIndex, Player.FadingInterval, False)
      else
          Play(fPlayingIndex, Player.FadingInterval, True);
  end;
end;


procedure TNempPlaylist.Pause;
begin
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtPause;
  Player.pause;
end;

procedure TNempPlaylist.Stop;
begin
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtStop;
  Player.stop;
end;


{
    --------------------------------------------------------
    Deleteing files from the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.DeleteMarkedFiles;
var i:integer;
  Selectedmp3s: TNodeArray;
  aData: PTreeData;
  NewSelectNode: PVirtualNode;
  allNodesDeleted: Boolean;
begin
  Selectedmp3s := VST.GetSortedSelection(False);
  if length(SelectedMp3s) = 0 then exit;

        VST.BeginUpdate;
        allNodesDeleted := True;

        NewSelectNode := VST.GetNextSibling(Selectedmp3s[length(Selectedmp3s)-1]);
        if not Assigned(NewSelectNode) then
          NewSelectNode := VST.GetPreviousSibling(Selectedmp3s[0]);

        for i := 0 to length(Selectedmp3s)-1 do
        begin
          // Nodes mit Level 1 (CueInfos) werden nicht gel�scht
          if VST.GetNodeLevel(Selectedmp3s[i])=0 then
          begin
              if Selectedmp3s[i] = fPlayingNode then fPlayingNode := Nil;
              aData := VST.GetNodeData(Selectedmp3s[i]);
              if (aData^.FAudioFile) = fPlayingFile then
              begin
                fPlayingIndex := Selectedmp3s[i].Index;
                // Backup playing file
                fBackUpFile.Assign(fPlayingFile);
                // Set the pointer to the backup-file
                fPlayingFile := fBackUpFile;
                Player.MainAudioFile := fBackUpFile;
              end;
              PrebookList.Remove(aData^.FAudioFile);
              Playlist.Delete(Selectedmp3s[i].Index);
              VST.DeleteNode(Selectedmp3s[i],True);
          end else
            allNodesDeleted := False;
        end;

        if assigned(NewSelectNode) AND allNodesDeleted then
        begin
          VST.Selected[NewSelectNode] := True;
          VST.FocusedNode := NewSelectNode;
        end;
        ReIndexPrebookedFiles;

        VST.EndUpdate;
        VST.Invalidate;

        fDauer := ShowPlayListSummary;
end;

procedure TNempPlaylist.ClearPlaylist;
begin
    Player.StopAndFree;
    PrebookList.Clear;
    Playlist.Clear;
    fPlayingFile := Nil;
    fPlayingNode := Nil;
    Player.MainAudioFile := Nil;
    fPlayingIndex := 0;
    FillPlaylistView;
    fDauer := ShowPlayListSummary;
    SendMessage(MainWindowHandle, WM_PlayerStop, 0, 0);
end;


procedure TNempPlaylist.DeleteDeadFiles;
var i: Integer;
begin
  for i := Playlist.Count - 1 downto 0 do
  begin
    if (NOT TPlaylistFile(Playlist.Items[i]).isStream)
        AND (NOT FileExists(TPlaylistFile(Playlist.Items[i]).Pfad))
        then
        begin
            PrebookList.Remove(TPlaylistFile(Playlist.Items[i]));
            Playlist.Delete(i);
        end;
  end;
  ReIndexPrebookedFiles;
  FillPlaylistView;
  fDauer := ShowPlayListSummary;
end;

procedure TNempPlaylist.removePlayingFile;
var aNode: PVirtualNode;
begin
  aNode := GetNodeWithPlayingFile;
  if assigned(aNode) then
  begin
    PrebookList.Remove(fPlayingFile);
    Playlist.Remove(fPlayingfile);
    VST.DeleteNode(aNode,True);
    ReIndexPrebookedFiles;
  end;
end;

{
    --------------------------------------------------------
    Some GUI-stuff
    --------------------------------------------------------
}
// Setter for property InsertNode
procedure TNempPlaylist.SetInsertNode(Value: PVirtualNode);
begin
  if Assigned(Value) then
  begin
    if VST.GetNodeLevel(Value) = 1 then
      fInsertNode := Value.Parent
    else
      fInsertNode := Value;
  end
  else fInsertNode := NIL;

  if assigned(fInsertNode) then
    fInsertIndex := fInsertNode.Index
  else
    fInsertindex := Playlist.Count;
end;



//Set fInsertNode/fInsertIndex from current position in the list
procedure TNempPlaylist.GetInsertNodeFromPlayPosition;
var i, PrebookIdx: Integer;
    lastPrebookFile: TAudioFile;
begin
    if PrebookList.Count > 0 then
    begin
        lastPrebookFile := TAudioFile(PrebookList[PrebookList.Count - 1]);
        PrebookIdx := Playlist.IndexOf(lastPrebookFile);
        InsertNode := VST.GetFirst;
        for i := 0 to PrebookIdx do
        begin
            if assigned(InsertNode) then
                InsertNode := {f}InsertNode.NextSibling;
        end;
    end else
    begin
        // InsertIndex wird vom InsertNode-Setter (eine Proc weiter oben) entsprechend gesetzt
        // d.h. PlayingNode ist noch in der Liste;
        if fPlayingNode <> NIL then
        begin
          InsertNode := fPlayingNode.NextSibling;
        end else
        begin
          // Playingfile gel�scht - Dateien an der Position einf�gen, die
          // GetNextAudioFile ermitteln wird.
          InsertNode := VST.GetFirst;
          for i := 0 to fPlayingIndex-1 do
          begin
            if assigned(InsertNode) then
              InsertNode := {f}InsertNode.NextSibling;
          end;
        end;
    end;
end;

procedure TNempPlaylist.FillPlaylistView;
var i,c: integer;
  aNode,CueNode: PVirtualNode;
  aData: PTreeData;
begin
  if not assigned(fVST) then exit;
  fVST.BeginUpdate;
  fVST.Clear;
  for i:=0 to Playlist.Count-1 do
  begin
    aNode := VST.AddChild(Nil, TPlaylistFile(Playlist.Items[i]));
    // ggf. Cuelist einf�gen
    if Assigned(TPlaylistFile(Playlist.Items[i]).CueList) AND (TPlaylistFile(Playlist.Items[i]).CueList.Count > 0) then
            for c := 0 to TPlaylistFile(Playlist.Items[i]).CueList.Count - 1 do
            begin
              CueNode := fVST.AddChild(aNode);
              fVST.ValidateNode(CueNode,false);
              aData := fVST.GetNodeData(CueNode);
              aData^.FAudioFile := TPlaylistFile(TPlaylistFile(Playlist.Items[i]).Cuelist[c]);
            end;
  end;
  fVST.EndUpdate;
end;

procedure TNempPlaylist.ActualizeCue;
var NewCueIndex: Integer;
begin
    NewCueIndex := Player.GetActiveCue;
    fActiveCueNode := GetActiveCueNode(NewCueIndex);
    VST.Invalidate;
end;

procedure TNempPlaylist.ActualizeNode(aNode: pVirtualNode);
var Data: PTreeData;
    AudioFile: TPlaylistFile;
    OldLength: Int64;
begin
    if not assigned(aNode) then exit;
    Data := VST.GetNodeData(aNode);
    AudioFile := Data^.FAudioFile;
    OldLength := AudioFile.Duration;
    if not (FileExists(AudioFile.Pfad) OR AudioFile.isStream) then
    begin
      AudioFile.FileIsPresent := False;
      AudioFile.Duration := 0;
    end
    else
    begin
      AudioFile.FileIsPresent := True;
      if (Not AudioFile.FileChecked) AND (Not AudioFile.isStream) then
      begin
          SynchronizeAudioFile(AudioFile, AudioFile.Pfad, False);
          {AudioFile.GetAudioData(AudioFile.Pfad, GAD_Cover OR GAD_RATING);

          mbAf := MedienBib.GetAudioFileWithFilename(AudioFile.Pfad);
          if assigned(mbAF) then
              AudioFile.Rating := mbAf.Rating;
          }
      end;
      if (Not AudioFile.isStream) and (not assigned(AudioFile.CueList)) then
      begin
        // nach einer Liste suchen und erstellen
        AudioFile.GetCueList;
        AddCueListNodes(AudioFile, aNode);
      end;
    end;
    fDauer := fDauer + (AudioFile.Duration - OldLength);
    VST.Header.Columns[1].Text := SekToPlaylistZeitString(fDauer);
    VST.Invalidate;
end;

procedure TNempPlaylist.UpdatePlayListHeader(aVST: TVirtualStringTree; Anzahl: Integer; Dauer: Int64);
begin
  aVST.Header.Columns[0].Text := Format('%s (%d)', [(TreeHeader_Titles), Playlist.Count]);// 'Titel (' + IntToStr(Playlist.Count) + ')';
  aVST.Header.Columns[1].Text := SekToPlaylistZeitString(fdauer);
end;

function TNempPlaylist.ShowPlayListSummary: Int64;
var i: integer;
begin
  result := 0;
  for i:= 0 to PlayList.Count - 1 do
    result := result + (PlayList[i] as TAudioFile).Duration;
  VST.Header.Columns[0].Text := Format('%s (%d)', [(TreeHeader_Titles), Playlist.Count]);//'Titel (' + inttostr(PlayList.Count) + ')';
  VST.Header.Columns[1].Text := SekToPlaylistZeitString(result);
end;



{
    --------------------------------------------------------
    Sorting/Mixing the playlist
    --------------------------------------------------------
}
// Diese Prozedur findet nach einem Neuaufbau der Playlist
// den PlayingNode wieder und setzt PlayingIndex um
procedure TNempPlaylist.ReInitPlaylist;
begin
  fPlayingNode := GetNodeWithPlayingFile;
  if assigned(fPlayingNode) then
    fPlayingIndex := fPlayingNode.Index
  else
    fPlayingIndex := -1;
  ActualizeCue;
  VST.Invalidate;
end;

procedure TNempPlaylist.Sort(Compare: TListSortCompare);
begin
  Playlist.Sort(Compare);
  FillPlayListView;
  ReInitPlaylist;
end;

Procedure TNempPlaylist.ReverseSortOrder;
var i : integer;
begin
  for i := 0 to (Playlist.Count-1) DIV 2 do
    Playlist.Exchange(i,Playlist.Count-1-i);
  FillPlayListView;
  ReInitPlaylist;
end;

Procedure TNempPlaylist.Mix;
var i : integer;
begin
  for i := 0 to Playlist.Count-1 do
    Playlist.Exchange(i,i + random(PlayList.Count-i));
  FillPlayListView;
  ReInitPlaylist;
end;


{
    --------------------------------------------------------
    Adding Files to the playlist
    --------------------------------------------------------
}
function TNempPlaylist.AddFileToPlaylist(Audiofile: TAudioFile; aCueName: UnicodeString = ''):PVirtualNode;
var NewNode: PVirtualNode;
    newAudiofile: TAudioFile;
begin
  newAudiofile := TAudioFile.Create;
  newAudiofile.Assign(AudioFile);
  newAudiofile.FileChecked := True;

  Playlist.Add(newAudiofile);
  NewNode := VST.AddChild(Nil, newAudiofile); // Am Ende einf�gen
  if not assigned(newAudiofile.CueList) then
  begin
    // nach einer Liste suchen und erstellen
    newAudiofile.GetCueList(aCueName, newAudiofile.Pfad);
    AddCueListNodes(newAudiofile, NewNode);
  end;

  VST.Invalidate;
  Result := NewNode;
  fDauer := fDauer + newAudiofile.Duration;
  UpdatePlayListHeader(VST, Playlist.Count, fDauer);
end;

function TNempPlaylist.AddFileToPlaylist(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''):PVirtualNode;
var NewFile: TPlaylistfile;
begin
  NewFile := TPlaylistfile.Create;

  if not PathSeemsToBeURL(aAudiofileName) then
  begin
      SynchronizeAudioFile(NewFile, aAudioFileName);
      {NewFile.GetAudioData(aAudiofileName, GAD_Cover OR GAD_Rating);
      Medienbib.InitCover(NewFile);
      mbAf := MedienBib.GetAudioFileWithFilename(aAudiofileName);
      if assigned(mbAF) then
          NewFile.Rating := mbAf.Rating;
      }
  end
  else
  begin
      NewFile.isStream := True;
      NewFile.Pfad := aAudiofileName;
  end;
  result := AddFileToPlaylist(NewFile, aCueName);
  NewFile.Free;
end;

function TNempPlaylist.InsertFileToPlayList(Audiofile: TAudioFile; aCueName: UnicodeString = ''):PVirtualNode;
var NewNode: PVirtualNode;
    newAudiofile: TAudioFile;
begin
  newAudiofile := TAudioFile.Create;
  newAudiofile.Assign(AudioFile);

  newAudiofile.FileChecked := True;

  if InsertNode <> NIL then
  begin
    fInsertIndex := InsertNode.Index;
    Playlist.Insert(fInsertIndex, newAudiofile);
    Inc(fInsertIndex);
    NewNode := VST.InsertNode(fInsertNode, amInsertBefore, newAudiofile);

    newAudiofile.GetCueList(aCueName, newAudiofile.Pfad);
    AddCueListNodes(newAudiofile, NewNode);
    VST.Invalidate;
  end else
  begin
    Playlist.Add(newAudiofile);
    // indexnode ist NIL, also am Ende einf�gen
    NewNode := VST.AddChild(Nil, newAudiofile);
    newAudiofile.GetCueList(aCueName, newAudiofile.Pfad);
    AddCueListNodes(newAudiofile, NewNode);
  end;
  Result := NewNode;
  fDauer := fDauer + newAudiofile.Duration;
  UpdatePlayListHeader(VST, Playlist.Count, fDauer);
end;

function TNempPlaylist.InsertFileToPlayList(aAudiofileName: UnicodeString; aCueName: UnicodeString = ''):PVirtualNode;
var NewFile: TPlaylistfile;
begin
  NewFile := TPlaylistfile.Create;
  if not PathSeemsToBeURL(aAudiofileName) then
  begin
      SynchronizeAudioFile(NewFile, aAudioFileName);
      {NewFile.GetAudioData(aAudiofileName, GAD_Cover OR GAD_Rating);
      Medienbib.InitCover(NewFile);
      mbAf := MedienBib.GetAudioFileWithFilename(aAudiofileName);
      if assigned(mbAF) then
          NewFile.Rating := mbAf.Rating;
      }
  end
  else
  begin
      NewFile.isStream := True;
      NewFile.Pfad := aAudiofileName;
  end;

  result := InsertFileToPlayList(NewFile, aCueName);
  NewFile.Free;
end;


function TNempPlaylist.fGetPreBookCount: Integer;
begin
    result := PrebookList.Count;
end;

procedure TNempPlaylist.AddNodeToPrebookList(aNode: PVirtualnode);
var Data: PTreeData;
    af: TAudioFile;
begin
    if assigned(aNode) and (VST.GetNodeLevel(aNode)=0) then
    begin
        Data := VST.GetNodeData(aNode);
        af := Data^.FAudioFile;
        if PrebookList.IndexOf(af) > -1 then
        begin
            PrebookList.Move(PrebookList.IndexOf(af), 0);
            ReIndexPrebookedFiles;
            VST.Invalidate;
        end else
        begin
            if PrebookList.Count < 99 then
            begin
                PrebookList.Add(af);
                af.PrebookIndex := PreBookList.Count;
                VST.InvalidateNode(aNode);
            end;
        end;

    end;
end;

procedure TNempPlaylist.RemoveSelectedNodesFromPreBookList;
var i:integer;
  Selectedmp3s: TNodeArray;
  aData: PTreeData;
begin
    Selectedmp3s := VST.GetSortedSelection(False);
    if length(SelectedMp3s) = 0 then exit;

    VST.BeginUpdate;

    for i := 0 to length(Selectedmp3s)-1 do
    begin
      // We dont need to handle Cue-Nodes here
      if VST.GetNodeLevel(Selectedmp3s[i])=0 then
      begin
          aData := VST.GetNodeData(Selectedmp3s[i]);
          aData^.FAudioFile.PrebookIndex := 0;
          PrebookList.Remove(aData^.FAudioFile);
      end
    end;

    ReIndexPrebookedFiles;

    VST.EndUpdate;
    VST.Invalidate;
end;

procedure TNempPlaylist.AddSelectedNodesToPreBookList(Mode: TPreBookInsertMode);
var i:integer;
  Selectedmp3s: TNodeArray;
  aData: PTreeData;
  af: TAudioFile;
begin

    Selectedmp3s := VST.GetSortedSelection(False);
    if length(SelectedMp3s) = 0 then exit;

    for i := 0 to length(Selectedmp3s)-1 do
    begin
      // We dont need to handle Cue-Nodes here
      if VST.GetNodeLevel(Selectedmp3s[i])=0 then
      begin
          aData := VST.GetNodeData(Selectedmp3s[i]);
          af := aData^.FAudioFile;

          case Mode of
              pb_Beginning: begin
                    if PrebookList.IndexOf(af) > -1 then
                        PrebookList.Move(PrebookList.IndexOf(af), i)
                    else
                        if PrebookList.Count < 99 then
                            PrebookList.Insert(i, af);
              end;

              pb_End: begin
                    if PrebookList.IndexOf(af) > -1 then
                        PrebookList.Move(PrebookList.IndexOf(af), PrebookList.Count-1)
                    else
                        if PrebookList.Count < 99 then
                            PrebookList.Add(af);
              end;
          end;

      end
    end;

    ReIndexPrebookedFiles;
    VST.Invalidate;
end;

procedure TNempPlaylist.ReIndexPrebookedFiles;
var i:Integer;
begin
    for i := 0 to PrebookList.Count - 1 do
        TAudioFile(PrebookList[i]).PrebookIndex := i+1;
end;

procedure TNempPlaylist.ProcessKeypress(aDigit: Byte; aNode: PVirtualNode);
var Data: PTreeData;
    oldIndex, newIndex: Integer;
    af: TAudioFile;
    tc: Int64;
begin

    if assigned(aNode) and (VST.GetNodeLevel(aNode)=0) then
    begin
        Data := VST.GetNodeData(aNode);
        af := Data^.FAudioFile;
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
        VST.Invalidate;
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
var i: Integer;
begin
  ProcessingBufferlist := True;
  if LastCommandWasPlay then ClearPlaylist;

  for i := 0 to BufferStringList.Count - 1 do
  begin
    AddFileToPlaylist(Bufferstringlist.Strings[i]);
  end;
  BufferStringList.Clear;
  ProcessingBufferlist := False;

  if fFirstAction then   // fFirstAction wird bei Play auf False gesetzt
  begin
      NempPlaylist.Play(PlayingIndex, NempPlayer.FadingInterval, AutoPlayOnStart);
  end else
  begin
      if LastCommandWasPlay and (Playlist.Count  > 0) then
        NempPlaylist.Play(0, NempPlayer.FadingInterval, true);
  end;
end;


{
    --------------------------------------------------------
    Loading/Saving the playlist
    --------------------------------------------------------
}
procedure TNempPlaylist.LoadFromFile(aFilename: UnicodeString);
begin
  LoadPlaylistFromFile(aFilename, Playlist, AutoScan);
  FillPlaylistView;
  fDauer := ShowPlayListSummary;
  UpdatePlayListHeader(VST, Playlist.Count, fDauer);
end;

procedure TNempPlaylist.SaveToFile(aFilename: UnicodeString; Silent: Boolean = True);
var
  myAList: tStringlist;
  i, c: integer;
  aAudiofile: TPlaylistfile;
  ini: TMemIniFile;
  tmpStream: TMemoryStream;
  tmp: AnsiString;
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

          if PathSeemsToBeURL(aAudioFile.Pfad) then
          begin
              myAList.add('#EXTINF:' + '0,' + aAudioFile.Description);
              myAList.Add(aAudioFile.Pfad);
          end
          else
          begin
              myAList.add('#EXTINF:' + IntTostr(aAudiofile.Duration) + ','
                  + aAudioFile.Artist + ' - ' + aAudioFile.Titel);
              myAList.Add(ExtractRelativePathNew(aFilename, aAudioFile.Pfad ));
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
              if PathSeemsToBeURL(aAudioFile.Pfad) then
              begin
                  ini.WriteString ('playlist', 'File'  + IntToStr(i), aAudioFile.Pfad );
                  ini.WriteString ('playlist', 'Title' + IntToStr(i), aAudioFile.Description);
                  ini.WriteInteger('playlist', 'Length'+ IntToStr(i), 0);
              end
              else
              begin
                  ini.WriteString ('playlist', 'File'  + IntToStr(i), ExtractRelativePathNew(aFilename, aAudioFile.Pfad ));
                  ini.WriteString ('playlist', 'Title' + IntToStr(i), aAudioFile.Artist + ' - ' + aAudioFile.Titel);
                  ini.WriteInteger('playlist', 'Length'+ IntToStr(i), aAudioFile.Duration);
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
  // Im Nemp-Playlist-Foramt speichern. �hnlich zu dem Medienbib-Format.
  if AnsiLowerCase(ExtractFileExt(aFilename)) = '.npl' then
  begin
      tmpStream := TMemoryStream.Create;
      try
          // VersionsInfo schreiben
          tmp := 'NempPlaylist';
          tmpStream.Write(tmp[1], length(tmp));
          tmp := '3.1';
          tmpStream.Write(tmp[1], length(tmp));
          c := Playlist.Count;
          tmpStream.Write(c, SizeOf(Integer));
          for i := 0 to Playlist.Count - 1 do
          begin
              aAudioFile := TAudioFile(Playlist[i]);
              if PathSeemsToBeURL(aAudioFile.Pfad) then
                  aAudioFile.SaveToStream(tmpStream, aAudioFile.Pfad)
              else
                  aAudioFile.SaveToStream(tmpStream, ExtractRelativePathNew(aFilename, TAudioFile(Playlist[i]).Pfad ) );
          end;
          try
              tmpStream.SaveToFile(aFilename);
          except
              on E: Exception do
                  if not Silent then
                      MessageDLG(E.Message, mtError, [mbOK], 0);
          end;
      finally
          tmpStream.Free;
      end;
  end;
end;

procedure TNempPlaylist.GetFromWinamp;
var maxW,i : integer;
    Dateiname: String;
begin
  maxW := GetWinampPlayListLength;

  if maxW = -1 then
      MessageDlg('Winamp not found', mtError, [mbOk], 0)
  else
  begin
      // Bestehende Liste l�schen
      ClearPlaylist;
      // Neu f�llen
      for i:=0 to maxW-1 do
      begin
          Dateiname := GetWinampFileName(i);
          // Wenn Datei nicht existiert, diese auch nicht aufnehmen:
          if Not FileExists(Dateiname) then continue;
          AddFileToPlaylist(Dateiname);
      end;
  end;
end;

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
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtSlide;
  // Cue-Zeug neu setzen
  ActualizeCue;
end;
function TNempPlaylist.GetProgress: Double;
begin
  result := Player.Progress;
end;
procedure TNempPlaylist.SetProgress(Value: Double);
begin
  Player.Progress := Value;
  fPlayingFileUserInput := fPlayingFileUserInput OR DisableAutoDeleteAtSlide;
  // Cue-Zeug neu setzen
  ActualizeCue;
end;

{
    --------------------------------------------------------
    Some stuff for the nodes in the TreeView
    --------------------------------------------------------
}
function TNempPlaylist.GetNodeWithPlayingFile: PVirtualNode;
var k: integer;
    aData: PTreeData;
    aNode: PVirtualNode;
begin
  result := Nil;
  aNode := VST.GetFirst;
  //result := aNode;
  if assigned(aNode) then
  begin
      // Suche den Knoten, der das PlayingFile enth�lt
      for k := 0 to Playlist.Count - 1 do
      begin
        if assigned(aNode) then
        begin
          aData := VST.GetNodeData(aNode);
          if aData^.FAudioFile = fPlayingFile then
          begin
            result := aNode;
            break;
          end else
            aNode := VST.GetNextSibling(aNode);
        end;
      end;
  end;
end;

function TNempPlaylist.GetPlayingIndex: Integer;
var aNode: PVirtualNode;
begin
  aNode := GetNodeWithPlayingFile;
  if assigned(aNode) then
    result := aNode.Index
  else
    result := fPlayingIndex;
end;


procedure TNempPlaylist.ScrollToPlayingNode;
var
  nextnode:PVirtualnode;
begin
  if assigned(fplayingNode) then
  begin
      nextnode := VST.GetFirst;
      While (nextnode <> NIL) AND (NOT (nextnode = fplayingNode)) do
        nextnode := VST.GetNextSibling(nextnode);

      if (nextnode <> Nil) and VST.ScrollIntoView(Nextnode,False) then
        VST.ScrollIntoView(Nextnode,True);
  end;
  // else: No scrolling
end;

procedure TNempPlaylist.AddCueListNodes(aAudioFile: TAudioFile; aNode: PVirtualNode);
var  i:integer;
begin

  if assigned(aNode) and assigned(aAudioFile.CueList) and
    (VST.ChildCount[aNode]=0) then
  begin
      for i := 0 to aAudioFile.CueList.Count - 1 do
        VST.AddChild(aNode, TAudiofile(aAudioFile.Cuelist[i]));
  end;
end;

function TNempPlaylist.GetActiveCueNode(aIndex: Integer): PVirtualNode;
var i: Integer;
    aNode: PVirtualNode;
begin
  result := Nil;
  aNode := fPlayingNode;

  if assigned(aNode) then
    result := VST.GetFirstChild(aNode);

  for i := 1 to aIndex do
  begin
    if assigned(result) then
      result := VST.GetNextSibling(result);
  end;
end;

{
    --------------------------------------------------------
    Getting an Audiofile
    --------------------------------------------------------
}
function TNempPlaylist.GetAnAudioFile: TPlaylistFile;
var Node: PVirtualNode;
  Data: PTreeData;
begin
  if assigned(PlayingFile) then
    result := PlayingFile
  else
  begin
    // liefert den fokussierten oder den ersten Titel zur�ck
    result := NIL;
    Node := VST.FocusedNode;
    if not Assigned(Node) then
      Node := VST.GetFirst;
    if Assigned(Node) then
    begin
      Data := VST.GetNodeData(Node);
      result := Data^.FAudioFile;
    end;
  end;

end;

function TNempPlaylist.GetNextAudioFileIndex: Integer;
var i:integer;
  tmpAudioFile: TPlaylistfile;
  c: Integer;
begin
    if PrebookList.Count > 0 then
    begin
        tmpAudioFile := TAudioFile(PrebookList[0]);
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
                result := fPlayingIndex ; // nicht um eins erh�hen !!

            if result > PlayList.Count-1 then
            begin
              result := 0;
              if fAutoMix then
              begin // Playlist neu durchmischen
                for i := 0 to Playlist.Count-1 do
                  Playlist.Move(i,i + random(PlayList.Count-i));
                FillPlaylistView;
              end;
            end
        end else
        // shufflemode
        begin
            if Playlist.Count = 0 then
                result := -1
            else begin
                result := Random(Playlist.Count);
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

function TNempPlaylist.GetPrevAudioFileIndex: Integer;
begin
  if (fPlayingFile <> NIL)  and (fPlayingFile <> fBackupFile) then
    result := PlayList.IndexOf(fPlayingFile) - 1
  else
    result := fPlayingIndex-1;
  if (result < 0) then
    result := 0;
end;


procedure TNempPlaylist.UserInput;
begin
  fErrorCount := 0;
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
  if PlayingFile <> NIL then
  begin
    Play(fPlayingIndex, 0, StartPlay, OldTime);
    Player.Time := OldTime;
  end
end;

{
    --------------------------------------------------------
    Getting an Adiofile with the given ID
    Used by the Nemp Webserver
    --------------------------------------------------------
}
function TNempPlaylist.GetPlaylistIndex(aID: Int64): Integer;
var i: Integer;
    af: TAudioFile;
begin
    result := -1;
    for i := 0 to Playlist.Count - 1 do
    begin
        af := TAudioFile(Playlist[i]);
        if af.WebServerID = aID then
        begin
            result := i;
            break;
        end;
    end;
end;

{
    --------------------------------------------------------
    Unify the rating for a given Audiofile (identified by its filename)
    Used when the user changes the rating of a file
    --------------------------------------------------------
}
procedure TNempPlaylist.UnifyRating(aFilename: String; aRating: Byte);
var i: Integer;
    af: TAudioFile;
begin
    for i := 0 to Playlist.Count - 1 do
    begin
        af := TAudioFile(Playlist[i]);
        if af.Pfad = aFilename then
            af.Rating := aRating;
        if af = Player.MainAudioFile then
            Spectrum.DrawRating(af.Rating);
    end;
end;

procedure TNempPlaylist.CollectFilesWithSameFilename(aFilename: String;
  Target: TObjectList);
var i: Integer;
    af: TAudioFile;
begin
    for i := 0 to Playlist.Count - 1 do
    begin
        af := TAudioFile(Playlist[i]);
        if af.Pfad = aFilename then
            Target.Add(af);
    end;
end;


end.