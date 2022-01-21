{

    Unit PlaylistManagement

    - Managing User-defined Playlists for QuickLoad/Save

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2020, Daniel Gaussmann
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
unit PlaylistManagement;

interface

uses Windows, SysUtils, Classes, StrUtils, System.Contnrs, System.UITypes, IniFiles,
  Generics.Collections, DriveRepairTools, Dialogs, myDialogs, NempAudioFiles;

    const PLAYLIST_MANAGER_OK = 0;
          PLAYLIST_MANAGER_FILE_EXISTS = 1;
          PLAYLIST_MANAGER_DESCRIPTION_EXISTS = 2;

    type
        TQuickLoadPlaylist = class
          private
              fDescription: String;  // a short description
              fFileName  : String;  // the filename, based on the Description, but cropped by forbidden characters (like :,/,\, etc.)
                                     // note: just the filename, not the full path
              fPlayIndex           : Integer  ;
              fPlayPositionInTrack : Integer  ;
              function GetPath: String;
          public
              property Description: String read fDescription write fDescription ;
              property Filename   : String read fFileName   write fFileName   ;
              property PlayIndex           : Integer  read fPlayIndex           write fPlayIndex          ;
              property PlayPositionInTrack : Integer  read fPlayPositionInTrack write fPlayPositionInTrack;
              property Path: String read getPath;

              procedure LoadSettings(aListIndex: Integer);
              procedure SaveSettings(aListIndex: Integer);
        end;

        TQuickLoadPlaylistCollection= class(TObjectList<TQuickLoadPlaylist>);


        TPlaylistManager = class
          private
              fQuickLoadPlaylists: TQuickLoadPlaylistCollection;
              // SavePaths:
              // Default: location of the old "nemp.npl" and several tmp and backup-playlists
              // UserDefined: Subdirectory \Playlists\, so these don't interfere with other automatically created playlist files
              fSavePathDefault: String;
              fSavePathUserDefined: String;
              fStartIndex: Integer;

              fCurrentQuickLoadPlaylist: TQuickLoadPlaylist;

              fUserInputOnPlaylistChange: Boolean;
              fAutoSaveOnPlaylistChange: Boolean;

              fDriveManager: TDrivemanager;
              fCurrentPlaylistFilenames: TStringList;

              fOnReset: TNotifyEvent;
              fOnRecentPlaylistChange: TNotifyEvent;
              fOnFavouritePlaylistChange: TNotifyEvent;

              procedure fSetSavePath(aValue: String);

              function fGetCount: Integer;

              function fGetCurrentIndex: Integer;

              function fGetCurrentDescription: String;
              function fGetCurrentFileName: String;
              function fGetCurrentPlaylistTrackPos: Integer;
              function fGetCurrentPlaylistIndex: Integer;

          public
              // RecentPlaylist:
              // Moved here from "NempOptions"
              RecentPlaylists: TStringList;

              constructor Create(aDriveManager: TDriveManager);
              destructor Destroy; override;

              property SavePath: String read fSavePathDefault write fSetSavePath;
              property UserSavePath: String read fSavePathUserDefined;
              property DriveManager: TDrivemanager read fDriveManager;
              property QuickLoadPlaylists: TQuickLoadPlaylistCollection read fQuickLoadPlaylists;
              property Count: Integer read fGetCount;
              // CurrentIndex: The Index of the current Playlist in QuickLoadPlaylists
              property CurrentIndex: Integer read fGetCurrentIndex;
              // The properties of the current Playlist
              property CurrentPlaylistDescription: String read fGetCurrentDescription;
              property CurrentPlaylistFilename: String read fGetCurrentFileName;
              property CurrentPlaylistIndex: Integer read fGetCurrentPlaylistIndex;
              property CurrentPlaylistTrackPos: Integer read fGetCurrentPlaylistTrackPos;

              // some settings (configured by OptionsComplete)
              property UserInputOnPlaylistChange : Boolean read fUserInputOnPlaylistChange write fUserInputOnPlaylistChange;
              property AutoSaveOnPlaylistChange  : Boolean read fAutoSaveOnPlaylistChange  write fAutoSaveOnPlaylistChange ;

              property OnReset                   : TNotifyEvent read fOnReset write fOnReset;
              property OnRecentPlaylistChange    : TNotifyEvent read fOnRecentPlaylistChange write fOnRecentPlaylistChange;
              property OnFavouritePlaylistChange : TNotifyEvent read fOnFavouritePlaylistChange write fOnFavouritePlaylistChange;

              // Load a Playlist-File from Disk into DestinationPlaylist
              // Parameter Index: Index of the item in fQuickLoadPlaylists
              //                  (used by the OnClick-Event from the MenuItems)
              procedure LoadPlaylist(aIndex: Integer; DestinationPlaylist: TAudioFileList; AutoScan: Boolean);

              procedure BackupPlaylistFilenames(aList: TAudioFileList);
              // Reset:
              // * Set the currentIndex back to -1,
              // * clear the Stringlit of Filenames
              procedure Reset;

              // SaveCurrentPlaylist
              // SaveCurrentPlaylistPosition
              // * Saves information about the current playlist
              procedure SaveCurrentPlaylist(SourcePlaylist: TAudioFileList; Silent: Boolean = True);
              procedure SavePlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist;SourcePlaylist: TAudioFileList; Silent: Boolean = True);

              procedure SaveCurrentPlaylistPosition(aIndex, aTrackPos: Integer);

              // Check, whether the PlaylistFile (*.npl) to a given Index exists
              // (should always be the case, unless the user fiddled in the Data-Directory
              function PlaylistFileExists(aIndex: Integer): Boolean;
              function RecentPlaylistFileExists(aIndex: Integer): Boolean;
              // Initialise a list of filenames of the currently loaded playlist.
              // This list is used to check for changes before the user loads another playlist
              procedure InitPlaylistFilenames;
              function CurrentPlaylistHasChanged(aPlaylist: TAudioFileList): Boolean;
              // Check whether the user wants to save the (changed) playlist before loading another one
              function UserWantAutoSave: Integer;

              // Prepare the loading process.
              // if the user clicks "abort" in the Dialog shown (optionally) during UserWantAutoSave,
              // then the whole process is aborted, and the "OpenDialog" for selecting a new Playlist is not shown.
              function CheckSaveSettings(aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
              function PrepareRecentPlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
              function PreparePlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
              function PrepareSamePlaylistLoading(aOldPlaylist: TAudioFileList; aFilename: String; aTrackPos: Integer): Boolean;

              procedure LoadSettings;
              procedure SaveSettings;

              function AddNewPlaylist(aDescription, aFilename: String; aSource: TAudioFileList; RefreshGUI: Boolean): TQuickLoadPlaylist;
              procedure SwitchToPlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist);
              procedure DeletePlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist);

              // PlaylistExist, GetUnusedPlaylistFile
              // used for the "New Playlist"-Form
              function PlaylistExist(aDescription, aFilename: String): Integer;
              function GetUnusedPlaylistFile: String;

              procedure AddRecentPlaylist(NewFile: UnicodeString);
              procedure DeleteRecentPlaylist(aIdx: Integer);

        end;

implementation

uses AudioFileHelper, Nemp_RessourceStrings, gnuGetText, Nemp_ConstantsAndTypes;

{ TQuickLoadPlaylist }

procedure TQuickLoadPlaylist.LoadSettings(aListIndex: Integer);
begin
    description := NempSettingsManager.ReadString('PlaylistManager', 'Description' + IntToStr(aListIndex), 'Playlist' + IntToStr(aListIndex));
    Filename    := NempSettingsManager.ReadString('PlaylistManager', 'Filename' + IntToStr(aListIndex), '');
    PlayIndex           := NempSettingsManager.ReadInteger('PlaylistManager', 'PlayIndex' + IntToStr(aListIndex)          , 0);
    PlayPositionInTrack := NempSettingsManager.ReadInteger('PlaylistManager', 'PlayPositionInTrack' + IntToStr(aListIndex), 0);
end;

procedure TQuickLoadPlaylist.SaveSettings(aListIndex: Integer);
begin
    NempSettingsManager.WriteString('PlaylistManager', 'Description' + IntToStr(aListIndex), Description );
    NempSettingsManager.WriteString('PlaylistManager', 'Filename'    + IntToStr(aListIndex), Filename    );
    NempSettingsManager.WriteInteger('PlaylistManager', 'PlayIndex' + IntToStr(aListIndex)          , PlayIndex           );
    NempSettingsManager.WriteInteger('PlaylistManager', 'PlayPositionInTrack' + IntToStr(aListIndex), PlayPositionInTrack );
end;

function TQuickLoadPlaylist.GetPath: String;
begin
  //
end;


{ TPlaylistmanager }

constructor TPlaylistManager.Create(aDriveManager: TDriveManager);
begin
    fQuickLoadPlaylists := TQuickLoadPlaylistCollection.Create(True);
    fStartIndex       := -1;
    fCurrentQuickLoadPlaylist := Nil;
    fDriveManager := aDriveManager;
    fCurrentPlaylistFilenames := TStringList.Create;
    RecentPlaylists := TStringList.Create;
end;


destructor TPlaylistManager.Destroy;
begin
    fQuickLoadPlaylists.Free;
    fCurrentPlaylistFilenames.Free;
    RecentPlaylists.Free;
end;

///  fGetCurrentDescription
///  fGetCurrentFileName
///  ----------------------------
///  Getter/Setter for "Current<Stuff>"
function TPlaylistManager.fGetCurrentDescription: String;
begin
    if assigned(fCurrentQuickLoadPlaylist) then
        result := fCurrentQuickLoadPlaylist.Description
    else
        result := '';
end;
function TPlaylistManager.fGetCurrentFileName: String;
begin
    if assigned(fCurrentQuickLoadPlaylist) then
        result := fCurrentQuickLoadPlaylist.Filename
    else
        result := '';
end;
function TPlaylistManager.fGetCurrentPlaylistIndex: Integer;
begin
    if assigned(fCurrentQuickLoadPlaylist) then
        result := fCurrentQuickLoadPlaylist.fPlayIndex
    else
        result := 0;
end;

function TPlaylistManager.fGetCurrentPlaylistTrackPos: Integer;
begin
    if assigned(fCurrentQuickLoadPlaylist) then
        result := fCurrentQuickLoadPlaylist.fPlayPositionInTrack
    else
        result := 0;
end;

function TPlaylistManager.fGetCurrentIndex: Integer;
begin
    if assigned(self.fCurrentQuickLoadPlaylist) then
        result := QuickLoadPlaylists.IndexOf(fCurrentQuickLoadPlaylist)
    else
        result := -1;
end;
function TPlaylistManager.fGetCount: Integer;
begin
    result := fQuickLoadPlaylists.Count;
end;


///  fSetSavePath
///  ------------
///  Setter for the SavePath. Internally set the Path for "defaul" and other playlists
procedure TPlaylistManager.fSetSavePath(aValue: String);
begin
    fSavePathDefault     := IncludeTrailingPathDelimiter(aValue) ;
    fSavePathUserDefined := IncludeTrailingPathDelimiter(aValue) + 'Playlists\' ;
end;

///  ReadFromIni
///  WriteToIni
///  -----------
///  Read/Write settings from the IniFile
///  This includes all QuickLoadPlaylists, including their PlayIndex/Trackpos
procedure TPlaylistManager.LoadSettings;
var ManagerCount, i: Integer;
    newQuickLoadPlaylist: TQuickLoadPlaylist;
    tmpString: String;
begin
    fQuickLoadPlaylists.Clear;
    fStartIndex := NempSettingsManager.ReadInteger('PlaylistManager', 'CurrentIndex', -1);
    fAutoSaveOnPlaylistChange  := NempSettingsManager.ReadBool('PlaylistManager', 'AutoSaveOnPlaylistChange' , False );
    fUserInputOnPlaylistChange := NempSettingsManager.ReadBool('PlaylistManager', 'UserInputOnPlaylistChange', True  );

    ManagerCount := NempSettingsManager.ReadInteger('PlaylistManager', 'Count', 0);
    for i := 0 to ManagerCount-1 do
    begin
        newQuickLoadPlaylist := TQuickLoadPlaylist.Create;
        newQuickLoadPlaylist.LoadSettings(i);
        fQuickLoadPlaylists.Add(newQuickLoadPlaylist);
    end;
    // Set the CurrentQuickLoadPlaylist properly to the stored settings
    if (fStartIndex >= 0) and (fStartIndex < fQuickLoadPlaylists.Count) then
        fCurrentQuickLoadPlaylist := fQuickLoadPlaylists[fStartIndex];

    // Load "Recent Playlists"
    // That was part of "nempOptions" before Nemp 4.14, but is located better here, I think
    for i := 1 to 10 do
    begin
        tmpString := NempSettingsManager.ReadString('RecentPlaylists', 'Playlist'+ IntToStr(i), '');
        if tmpString <> '' then
            RecentPlaylists.Add(tmpString);
    end;

    // Trigger events to refresh the GUI
    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
    if assigned(fOnFavouritePlaylistChange) then
        fOnFavouritePlaylistChange(Self);
end;

procedure TPlaylistManager.SaveSettings;
var i: Integer;
begin
    // remove previous entries, in case the number of Playlists has been reduced
    NempSettingsManager.EraseSection('Playlistmanager');

    // write new values
    if assigned(fCurrentQuickLoadPlaylist) then
        NempSettingsManager.WriteInteger('PlaylistManager', 'CurrentIndex', fQuickLoadPlaylists.IndexOf(fCurrentQuickLoadPlaylist))
    else
        NempSettingsManager.WriteInteger('PlaylistManager', 'CurrentIndex', -1);

    NempSettingsManager.WriteBool('PlaylistManager', 'AutoSaveOnPlaylistChange' , fAutoSaveOnPlaylistChange  );
    NempSettingsManager.WriteBool('PlaylistManager', 'UserInputOnPlaylistChange', fUserInputOnPlaylistChange );

    NempSettingsManager.WriteInteger('PlaylistManager', 'Count', Count);
    for i := 0 to fQuickLoadPlaylists.Count - 1 do
        fQuickLoadPlaylists[i].SaveSettings(i);

    // Write RecentPlaylists
    NempSettingsManager.EraseSection('RecentPlaylists');
    for i := 0 to RecentPlaylists.Count - 1 do
        NempSettingsManager.WriteString('RecentPlaylists', 'Playlist'+ IntToStr(i+1), RecentPlaylists[i]);
end;


///  BackupPlaylistFilenames
///  -----------------------
///  Store the Filenames of the most recently loaded/saved Playlist in our Backup-Stringlist.
///  We will use this Stringlist to check, whether the list has changed when we load another one.
///  If Changes occurred, the User may want to save the favourite playlist before deleting them
///  And if no Changes occured, we'll save the current position (Index + TrackPos) in this managed playlist
procedure TPlaylistManager.BackupPlaylistFilenames(aList: TAudioFileList);
var i: Integer;
begin
    fCurrentPlaylistFilenames.Clear;
    for i := 0 to aList.Count - 1 do
        fCurrentPlaylistFilenames.Add(aList[i].Pfad);
end;

///  InitPlaylistFilenames
///  ---------------------
///  When Nemp starts, we load only the default nemp.npl.
///  However, we DO remember the previous "active" Quickload-Playlist and
///  mark it in the GUI (Menu: checked/default, Description in the Header)
///  But: When Nemp closes, only the nemp.npl is written again, not the "activePlaylist.npl" as well
///       => on next start, init the List of Filenames from the previous "activePlaylist.npl".
procedure TPlaylistManager.InitPlaylistFilenames;
var tmpPlaylist: TAudioFileList;
    fn: String;
begin
    if not assigned(fCurrentQuickLoadPlaylist) then
    begin
        // nothing todo, except (maybe) clearing the Filenames-List
        fCurrentPlaylistFilenames.Clear;
        exit;
    end;

    tmpPlaylist := TAudioFileList.Create(True);
    try
        fn := fSavePathUserDefined + fCurrentQuickLoadPlaylist.fFileName;
        LoadPlaylistFromFile(fn, tmpPlaylist, false, fDrivemanager);
        // Put the Filenames of the Audiofiles in this Playlist into our Backup-List
        BackupPlaylistFilenames(tmpPlaylist);
    finally
        tmpPlaylist.Free;
    end;
end;

///  CurrentPlaylistHasChanged
///  -------------------------
///  Compares the currently backup list of Filenames with "aPlaylist"
///  Called when Loading a new Playlist before clearing the current one
///  If there are differences between these two lists, the user has changed something in the list,
///  and he may want to save it first.
function TPlaylistManager.CurrentPlaylistHasChanged(aPlaylist: TAudioFileList): Boolean;
var i: Integer;
begin
    result := False;

    // if there is no actual "CurrentPlaylist", we consider it as "unchanged"
    if fCurrentPlaylistFilenames.Count = 0 then
    begin
        result := False;
        exit;
    end;

    // if the number of items differs, something has definitely changed ...
    if fCurrentPlaylistFilenames.Count <> aPlaylist.Count then
    begin
        result := True;
        exit;
    end;

    // if the number of items matches, then we need to check the filenames
    for i := 0 to aPlaylist.Count - 1 do
    begin
        if fCurrentPlaylistFilenames[i] <> aPlaylist[i].Pfad then
        begin
            result := True;
            // something has changed. No further testing necessary.
            break;
        end;
    end;
end;

///  UserWantAutoSave
///  -------------------------
///  Return Value:
///   * the general setting AutoSaveOnPlaylistChange
///   OR
///   * the User Input from a MessageDialog
function TPlaylistManager.UserWantAutoSave: Integer;
var asknomore: Boolean;
    dlgResult: Integer;
begin
    if AutoSaveOnPlaylistChange then
        // AutoSave is True
        result := mrYes
    else
    begin
        // AutoSave is False
        if not UserInputOnPlaylistChange then
            // No AutoSave, no User Dialog wanted
            result := mrNo
        else
        begin
            // No AutoSave, but User Dialog *IS* wanted
            asknomore := Not UserInputOnPlaylistChange;
            dlgResult := MessageDlgWithNoMorebox
                  ((PlaylistManagerAutoSave_Caption),
                   Format( (PlaylistManagerAutoSave_Text), [CurrentPlaylistDescription]),
                   mtConfirmation, [mbYes, mbNo, mbCancel], mrYes, 0, asknomore,
                  (PlaylistManagerAutoSave_ShowAgain));
            // apply User Input
            AutoSaveOnPlaylistChange := dlgResult = mrYes;
            UserInputOnPlaylistChange := not asknomore;
            result := dlgResult;
        end;
    end;
end;

///  PlaylistFileExists
///  -------------------------
///  Check, whether the PlaylistFil (*.npl) to a given Index exists
///  (should always be the case, unless the user fiddled in the Data-Directory
function TPlaylistManager.PlaylistFileExists(aIndex: Integer): Boolean;
begin
    case aIndex of
        -3: result := (CurrentPlaylistFilename <> '') and FileExists(fSavePathUserDefined + CurrentPlaylistFilename);
        -2: result := True; // used when a file is selected by an OpenDialog
        -1: result := FileExists(fSavePathDefault + 'nemp.npl');
    else
        if (aIndex >= 0) and (aIndex < fQuickLoadPlaylists.Count) then
            result := FileExists(fSavePathUserDefined + fQuickLoadPlaylists[aIndex].fFileName)
        else
            // Index is Out of Range
            result := false;
    end;
end;
function TPlaylistManager.RecentPlaylistFileExists(aIndex: Integer): Boolean;
begin
    if (aIndex >= 0) and (aIndex < RecentPlaylists.Count) then
        result := FileExists(RecentPlaylists[aIndex])
    else
        // Index is Out of Range
        result := false;
end;


///  CheckSaveSettings
///  -------------------------
///  Sub-procedure of the following Prepare*PlaylistLoading
///
function TPlaylistManager.CheckSaveSettings(aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
begin
    if not CurrentPlaylistHasChanged(aOldPlaylist) then
    begin
        // Current playlist has not changed
        // => just save the current position in this list
        SaveCurrentPlaylistPosition(aIndex, aTrackPos);
        result := True
    end
    else
    begin
        // current playlist has changed.
        case UserWantAutoSave of
            mrYes: begin
                SaveCurrentPlaylist(aOldPlaylist, False);
                SaveCurrentPlaylistPosition(aIndex, aTrackPos);
                result := True;
            end;

            mrNo: begin
                // User do NOT want to save the playlist.
                // no saving, and also not saving the current position
                // (as it doesn't make sense, as the playlist has changed)
                // However, preparation is complete
                result := True;
            end;
        else
            begin
                // the user aborted the MessageDlg in UserWantAutoSave.
                // => abort the whole process of Loading a new playlist
                result := False;
            end;
        end;
    end;
end;

///  PrepareRecentPlaylistLoading
///  -------------------------
///  Called before loading a new *recent* playlist (and clearing the current one)
///  Return Value:
///   * True: Preparation complete, Loading the new playlist should be ok
///   * False: The User aborted the MesseagDlg whether the current playlist
///            should be saved or discarded. Do not proceed loading
function TPlaylistManager.PrepareRecentPlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
begin
    if not RecentPlaylistFileExists(newPlaylistIndex) then
    begin
        if TranslateMessageDLG((Playlist_FileNotFound), mtWarning, [MBYES, MBNO, MBABORT], 0) = mrYes then
            DeleteRecentPlaylist(newPlaylistIndex);
        result := false;
        exit;
    end;
    result := CheckSaveSettings(aOldPlaylist, aIndex, aTrackPos);
end;

///  PreparePlaylistLoading
///  -------------------------
///  Called before loading a new *favorite* playlist (and clearing the current one)
///  Return Value: same as in PrepareRecentPlaylistLoading
function TPlaylistManager.PreparePlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
begin
    if not PlaylistFileExists(newPlaylistIndex) then
    begin
        TranslateMessageDLG((PlaylistManager_PlaylistNoFound), mtWarning, [MBOK], 0);
        result := False;
        exit;
    end;
    result := CheckSaveSettings(aOldPlaylist, aIndex, aTrackPos);
end;

///  PrepareSamePlaylistLoading
///  ---------------------------------
///  Called before loading the same playlist again
///  If nothing has changed - erturn false, do nothing.
///  If the current playlist has changed:
///  User has to confirm, that he wants to go back to the previously saved version of this playlist
///  But: Try to remain the current play position
function TPlaylistManager.PrepareSamePlaylistLoading(aOldPlaylist: TAudioFileList; aFilename: String;
    aTrackPos: Integer): Boolean;
var i: Integer;
begin
    if not PlaylistFileExists(-3) then
    begin
        TranslateMessageDLG((PlaylistManager_PlaylistNoFound), mtWarning, [MBOK], 0);
        result := False;
        exit;
    end;

    if (not CurrentPlaylistHasChanged(aOldPlaylist)) or (not assigned(fCurrentQuickLoadPlaylist)) then
    begin
        // nothing to do
        result := False;
    end else
    begin
        if TranslateMessageDLG(Format(PlaylistManager_ReloadPlaylist, [CurrentPlaylistDescription]), mtConfirmation, [mbYes,MBNo,MBCancel], 0) = mrYes then
        begin
            // The user wants to reload this playlist.
            // Bonus Feature: Try to find the currently playing song in the List of Filenames
            //     (which equals the list we will load after this), so that the playlist continues ...
            fCurrentQuickLoadPlaylist.PlayIndex := 0;
            fCurrentQuickLoadPlaylist.PlayPositionInTrack := 0;
            for i := 0 to fCurrentPlaylistFilenames.Count - 1 do
            begin
                if fCurrentPlaylistFilenames[i] = aFilename then
                begin
                    // we found our currently playing file!
                    fCurrentQuickLoadPlaylist.PlayIndex := i;
                    fCurrentQuickLoadPlaylist.PlayPositionInTrack := aTrackPos;
                    break;
                end;
            end;
            result := True;
        end else
            result := False;
    end;
end;

///  Reset
///  ------------
///  Reset the Manager to the "DefaultPlaylist"
///  Used when the a "regular" playlist is loaded, which is not managed by the list of QuickLoadPlaylists
procedure TPlaylistManager.Reset;
begin
    fCurrentQuickLoadPlaylist := Nil;
    fCurrentPlaylistFilenames.Clear;
    if assigned(fOnReset) then
        fOnReset(self);
end;

///  LoadPlaylist
///  ------------
///  Load a QuickLoadPlaylist into the DestinationList
///  And: Automatically call "BackupPlaylistFilenames"
procedure TPlaylistManager.LoadPlaylist(aIndex: Integer; DestinationPlaylist: TAudioFileList; AutoScan: Boolean);
var fn: String;
begin
    if (aIndex < 0) or (aIndex >= fQuickLoadPlaylists.Count) then
    begin
        fn := fSavePathDefault + 'nemp.npl';
        fCurrentQuickLoadPlaylist := Nil;
    end
    else
    begin
        fn := fSavePathUserDefined + fQuickLoadPlaylists[aIndex].fFileName;
        fCurrentQuickLoadPlaylist := fQuickLoadPlaylists[aIndex];
    end;

    fDriveManager.Clear;
    LoadPlaylistFromFile(fn, DestinationPlaylist, AutoScan, fDrivemanager);
    // Refresh Filenames-StringList
    BackupPlaylistFilenames(DestinationPlaylist);
end;

///  SavePlaylist
///  ------------
///  Saves a Playlist "SourcePlaylist" as a QuickLoadPlaylist
///  And: Automatically call "BackupPlaylistFilenames"
procedure TPlaylistManager.SaveCurrentPlaylist(SourcePlaylist: TAudioFileList; Silent: Boolean = True);
begin
    SavePlaylist(fCurrentQuickLoadPlaylist, SourcePlaylist, Silent);
    // Refresh Filenames-StringList
    BackupPlaylistFilenames(SourcePlaylist);
end;

procedure TPlaylistManager.SavePlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist;SourcePlaylist: TAudioFileList; Silent: Boolean = True);
var fn: String;
begin
    if assigned(aQuickLoadPlaylist) then
        fn := fSavePathUserDefined + aQuickLoadPlaylist.fFileName
    else
        fn := fSavePathDefault + 'nemp.npl';

    // Save the list to the file
    SavePlaylistToNPL(fn, SourcePlaylist, fDriveManager, Silent);
end;

///  SaveCurrentPlaylistPosition
///  -----------------------------
///  Save additional information about the Playlist
///  * Current track
///  * Position in Current track (= Player-Time)
procedure TPlaylistManager.SaveCurrentPlaylistPosition(aIndex, aTrackPos: Integer);
begin
    if assigned(fCurrentQuickLoadPlaylist) then
    begin
        fCurrentQuickLoadPlaylist.fPlayIndex := aIndex;
        fCurrentQuickLoadPlaylist.fPlayPositionInTrack := aTrackPos;
    end;
end;


///  GetUnusedPlaylistFile
///  ---------------------
///  Generates an used FileName/Description for the "New FavoritePlaylist"- Dialog
///  (just "New Playlist (x)", nothing serious)
function TPlaylistManager.GetUnusedPlaylistFile: String;
var i: Integer;
    pl: String;
begin
    pl := 'New Playlist';
    i := 0;
    if PlaylistExist(pl, pl) <> PLAYLIST_MANAGER_OK then
        repeat
            inc(i);
            pl := Format('New Playlist (%d)', [i]);
        until (PlaylistExist(pl, pl) = PLAYLIST_MANAGER_OK) or (i > 500);
    result := pl;
end;

///  PlaylistExist
///  ------------------------------
///  Used by the input form for new Quickload-Playlists
function TPlaylistManager.PlaylistExist(aDescription,
  aFilename: String): Integer;
var i: Integer;
begin
    if not AnsiEndsText('.npl', aFilename) then
        aFilename := aFilename + '.npl';

    result := 0;
    for i := 0 to fQuickLoadPlaylists.Count - 1 do
    begin
        if AnsiSameText(fQuickLoadPlaylists[i].Description, aDescription) then
            result := result OR PLAYLIST_MANAGER_DESCRIPTION_EXISTS;

        if AnsiSameText(fQuickLoadPlaylists[i].Filename, aFilename) then
            result := result OR PLAYLIST_MANAGER_FILE_EXISTS;
    end;
end;

///  AddNewPlaylist
///  -----------------------
///  Add a new Favorite Playlist, defined by Description and Filename
///  * return value: The new Favorite Playlist
function TPlaylistManager.AddNewPlaylist(aDescription, aFilename: String; aSource: TAudioFileList; RefreshGUI: Boolean): TQuickLoadPlaylist;
var newQuickLoadPlaylist: TQuickLoadPlaylist;
begin
    // Create the new QuickLoadPlaylist
    newQuickLoadPlaylist := TQuickLoadPlaylist.Create;
    newQuickLoadPlaylist.Description := aDescription;

    if not AnsiEndsText('.npl', aFilename) then
        aFilename := aFilename + '.npl';

    newQuickLoadPlaylist.Filename := aFilename;

    // add it to the List of QuickLoadPlaylists
    fQuickLoadPlaylists.Add(newQuickLoadPlaylist);
    result := newQuickLoadPlaylist;

    // Save the Playlist
    SavePlaylist(newQuickLoadPlaylist, aSource, False);

    // after that: GUI should be renewed (unless SwitchToPlaylist is called right after)
    if RefreshGUI and assigned(OnFavouritePlaylistChange) then
        OnFavouritePlaylistChange(Self);
end;
///  SwitchToPlaylist
///  -----------------------
///  Set the pointer CurrentPlaylist
procedure TPlaylistManager.SwitchToPlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist);
begin
    // Set the active Playlist to the one we just added
    fCurrentQuickLoadPlaylist := aQuickLoadPlaylist;

    // after that: GUI should be renewed:
    if assigned(OnFavouritePlaylistChange) then
        OnFavouritePlaylistChange(Self);
end;

///  DeletePlaylist
///  ---------------------
///  Removes a Playlist from the list of managed Playlists
///  * Also: Rename the original file to "*.backup", so that it may be restored manually
///          (an existing *.backup file will be deleted from Disk first)
procedure TPlaylistManager.DeletePlaylist(
  aQuickLoadPlaylist: TQuickLoadPlaylist);
var fn: String;
begin
    if aQuickLoadPlaylist = fCurrentQuickLoadPlaylist then
        fCurrentQuickLoadPlaylist := Nil;

    fn := fSavePathUserDefined + aQuickLoadPlaylist.fFileName;
    if FileExists(fn) then
    begin
        // delete backup-File
        if FileExists(fn + '.backup') then
            DeleteFile(fn + '.backup');
        // rename actual file to *.backup
        RenameFile(fn, fn + '.backup')
    end;
    fQuickLoadPlaylists.Remove(aQuickLoadPlaylist);

    // after that: GUI should be renewed:
    if assigned(fOnFavouritePlaylistChange) then
        fOnFavouritePlaylistChange(Self);
end;

///  AddRecentPlaylist
///  DeleteRecentPlaylist
///  ---------------------------
///  For the list of "Recent Playlists"
///  (was part of NempOptions in before Nemp 4.14)
procedure TPlaylistManager.AddRecentPlaylist(NewFile: UnicodeString);
var idx: integer;
begin
    // Search for duplicates
    idx := RecentPlaylists.IndexOf(NewFile);
    // delete duplicate
    if idx >= 0 then
        RecentPlaylists.Delete(idx);

    // insert NewFile at first position
    RecentPlaylists.Insert(0, NewFile);

    // delete last item, if we reach the maximum
    if RecentPlaylists.Count > 10 then
        RecentPlaylists.Delete(10);

    // trigger OnChange-Event to refresh the GUI
    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
end;
procedure TPlaylistManager.DeleteRecentPlaylist(aIdx: Integer);
begin
    RecentPlaylists.Delete(aIdx);

    // trigger OnChange-Event to refresh the GUI
    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
end;



end.
