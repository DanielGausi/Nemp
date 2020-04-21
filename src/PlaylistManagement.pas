{

    Unit PlaylistManagement

    - Managing User-defined Playlists for QuickLoad/Save

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
              fFilenName  : String;  // the filename, based on the Description, but cropped by forbidden characters (like :,/,\, etc.)
                                     // note: just the filename, not the full path
              fPlayIndex           : Integer  ;
              fPlayPositionInTrack : Integer  ;
          public
              property Description: String read fDescription write fDescription ;
              property Filename   : String read fFilenName   write fFilenName   ;
              property PlayIndex           : Integer  read fPlayIndex           write fPlayIndex          ;
              property PlayPositionInTrack : Integer  read fPlayPositionInTrack write fPlayPositionInTrack;

              procedure ReadFromIni(aIni: TMemIniFile; aListIndex: Integer);
              procedure WriteToIni(aIni: TMemIniFile; aListIndex: Integer);
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
              fCurrentIndex: Integer;

              fUserInputOnPlaylistChange: Boolean;
              fAutoSaveOnPlaylistChange: Boolean;

              fDriveManager: TDrivemanager;
              fCurrentPlaylistFilenames: TStringList;

              fOnReset: TNotifyEvent;
              fOnRecentPlaylistChange: TNotifyEvent;
              fOnFavouritePlaylistChange: TNotifyEvent;

              // returns the proper filename for automatic savin of the playlist
              //function fGetAutoSaveFileName: String;
              procedure fSetSavePath(aValue: String);

              function fGetCount: Integer;
              procedure fSetCurrentIndex(aValue: Integer);

              function fGetCurrentDescription: String;
              function fGetCurrentFileName: String;
              function fGetCurrentPlaylistTrackPos: Integer;
              function fGetCurrentPlaylistIndex: Integer;

              procedure BackupPlaylistFilenames(aList: TAudioFileList);


          public
              // RecentPlaylist:
              // Moved here from "NempOptions"
              RecentPlaylists: TStringList;


              constructor Create(aDriveManager: TDriveManager);
              destructor Destroy; override;

              property SavePath: String read fSavePathDefault write fSetSavePath;
              property QuickLoadPlaylists: TQuickLoadPlaylistCollection read fQuickLoadPlaylists;
              property Count: Integer read fGetCount;
              // CurrentIndex: The Index of the current Playlist in QuickLoadPlaylists
              property CurrentIndex: Integer read fCurrentIndex write fSetCurrentIndex;
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
              function LoadPlaylist(aIndex: Integer; DestinationPlaylist: TAudioFileList; AutoScan: Boolean): Boolean;

              // Reset:
              // * Set the currentIndex back to -1,
              // * clear the Stringlit of Filenames
              procedure Reset;

              // SaveCurrentPlaylist
              // SaveCurrentPlaylistPosition
              // * Saves information about the current playlist
              procedure SaveCurrentPlaylist(SourcePlaylist: TAudioFileList; Silent: Boolean = True);
              procedure SaveCurrentPlaylistPosition(aIndex, aTrackPos: Integer);

              // Check, whether the PlaylistFile (*.npl) to a given Index exists
              // (should always be the case, unless the user fiddled in the Data-Directory
              function PlaylistFileExists(aIndex: Integer): Boolean;
              // Initialise a list of filenames of the currently loaded playlist.
              // This list is used to check for changes before the user loads another playlist
              procedure InitPlaylistFilenames;
              function CurrentPlaylistHasChanged(aPlaylist: TAudioFileList): Boolean;
              // Check whether the user wants to save the (changed) playlist before loading another one
              function UserWantAutoSave: Integer;
              // Prepare the loading process.
              // if the user clicks "abort" in the Dialog shown (optionally) during UserWantAutoSave,
              // then the whole process is aborted, and the "OpenDialog" for selecting a new Playlist is not shown.
              function PreparePlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;

              function PrepareSamePlaylistLoading(aOldPlaylist: TAudioFileList; aFilename: String; aTrackPos: Integer): Boolean;


              procedure ReadFromIni(aIni: TMemIniFile);
              procedure WriteToIni(aIni: TMemIniFile);

              procedure AddNewPlaylist(aDescription, aFilename: String; aSource: TAudioFileList);
              procedure DeletePlaylist(aQuickLoadPlaylist: TQuickLoadPlaylist);

              // PlaylistExist, GetUnusedPlaylistFile
              // used for the "New Playlist"-Form
              function PlaylistExist(aDescription, aFilename: String): Integer;
              function GetUnusedPlaylistFile: String;

              function AddRecentPlaylist(NewFile: UnicodeString): boolean;
              function DeleteRecentPlaylist(aIdx: Integer): boolean;

        end;

implementation

uses AudioFileHelper, Nemp_RessourceStrings, gnuGetText;

{ TQuickLoadPlaylist }

procedure TQuickLoadPlaylist.ReadFromIni(aIni: TMemIniFile;
  aListIndex: Integer);
begin
    description := aIni.ReadString('PlaylistManager', 'Description' + IntToStr(aListIndex), 'Playlist' + IntToStr(aListIndex));
    Filename    := aIni.ReadString('PlaylistManager', 'Filename' + IntToStr(aListIndex), '');
    PlayIndex           := aIni.ReadInteger('PlaylistManager', 'PlayIndex' + IntToStr(aListIndex)          , 0);
    PlayPositionInTrack := aIni.ReadInteger('PlaylistManager', 'PlayPositionInTrack' + IntToStr(aListIndex), 0);
end;

procedure TQuickLoadPlaylist.WriteToIni(aIni: TMemIniFile; aListIndex: Integer);
begin
    aIni.WriteString('PlaylistManager', 'Description' + IntToStr(aListIndex), Description );
    aIni.WriteString('PlaylistManager', 'Filename'    + IntToStr(aListIndex), Filename    );
    aIni.WriteInteger('PlaylistManager', 'PlayIndex' + IntToStr(aListIndex)          , PlayIndex           );
    aIni.WriteInteger('PlaylistManager', 'PlayPositionInTrack' + IntToStr(aListIndex), PlayPositionInTrack );
end;


{ TPlaylistmanager }

constructor TPlaylistManager.Create(aDriveManager: TDriveManager);
begin
    fQuickLoadPlaylists := TQuickLoadPlaylistCollection.Create(True);
    fCurrentIndex       := -1;
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
///  fSetCurrentIndex
///  ----------------------------
///  Getter/Setter for "Current<Stuff>"
function TPlaylistManager.fGetCurrentDescription: String;
begin
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
        result := ''
    else
        result := fQuickLoadPlaylists[fCurrentIndex].Description;
end;
function TPlaylistManager.fGetCurrentFileName: String;
begin
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
        result := ''
    else
        result := fQuickLoadPlaylists[fCurrentIndex].Filename;
end;
function TPlaylistManager.fGetCurrentPlaylistIndex: Integer;
begin
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
        result := 0
    else
        result := fQuickLoadPlaylists[fCurrentIndex].fPlayIndex;
end;

function TPlaylistManager.fGetCurrentPlaylistTrackPos: Integer;
begin
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
        result := 0
    else
        result := fQuickLoadPlaylists[fCurrentIndex].fPlayPositionInTrack;
end;

procedure TPlaylistManager.fSetCurrentIndex(aValue: Integer);
begin
    if (aValue >= 0) and (aValue < Count) then
        fCurrentIndex := aValue
    else
        fCurrentIndex := -1;
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
procedure TPlaylistManager.ReadFromIni(aIni: TMemIniFile);
var ManagerCount, i: Integer;
    newQuickLoadPlaylist: TQuickLoadPlaylist;
    tmpString: String;
begin
    fQuickLoadPlaylists.Clear;
    fCurrentIndex := aIni.ReadInteger('PlaylistManager', 'CurrentIndex', -1);

    fAutoSaveOnPlaylistChange  := aIni.ReadBool('PlaylistManager', 'AutoSaveOnPlaylistChange' , False );
    fUserInputOnPlaylistChange := aIni.ReadBool('PlaylistManager', 'UserInputOnPlaylistChange', True  );


    ManagerCount := aIni.ReadInteger('PlaylistManager', 'Count', 0);
    for i := 0 to ManagerCount-1 do
    begin
        newQuickLoadPlaylist := TQuickLoadPlaylist.Create;
        newQuickLoadPlaylist.ReadFromIni(aIni, i);
        fQuickLoadPlaylists.Add(newQuickLoadPlaylist);
    end;

    for i := 1 to 10 do
    begin
        tmpString := aIni.ReadString('RecentPlaylists', 'Playlist'+ IntToStr(i), '');
        if tmpString <> '' then
            RecentPlaylists.Add(tmpString);
    end;

    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
    if assigned(fOnFavouritePlaylistChange) then
        fOnFavouritePlaylistChange(Self);
end;


procedure TPlaylistManager.WriteToIni(aIni: TMemIniFile);
var i: Integer;
begin
    aIni.WriteInteger('PlaylistManager', 'CurrentIndex', fCurrentIndex);
    aIni.WriteBool('PlaylistManager', 'AutoSaveOnPlaylistChange' , fAutoSaveOnPlaylistChange  );
    aIni.WriteBool('PlaylistManager', 'UserInputOnPlaylistChange', fUserInputOnPlaylistChange );

    aIni.WriteInteger('PlaylistManager', 'Count', Count);
    for i := 0 to fQuickLoadPlaylists.Count - 1 do
        fQuickLoadPlaylists[i].WriteToIni(aIni, i);

    // Write RecentPlaylists
    for i := 0 to RecentPlaylists.Count - 1 do
        aIni.WriteString('RecentPlaylists', 'Playlist'+ IntToStr(i+1), RecentPlaylists[i]);
    for i := RecentPlaylists.Count to 10 do
        aIni.WriteString('RecentPlaylists', 'Playlist'+ IntToStr(i+1), '');
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
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
    begin
        // nothing todo, except (maybe) clearing the Filenames-List
        fCurrentPlaylistFilenames.Clear;
        exit;
    end;

    tmpPlaylist := TAudioFileList.Create(True);
    try
        fn := fSavePathUserDefined + fQuickLoadPlaylists[fCurrentIndex].fFilenName;
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
    if not UserInputOnPlaylistChange then
    begin
        if AutoSaveOnPlaylistChange then
            result := mrYes
        else
            result := mrNo;
    end
    else
    begin
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

///  PlaylistFileExists
///  -------------------------
///  Check, whether the PlaylistFil (*.npl) to a given Index exists
///  (should always be the case, unless the user fiddled in the Data-Directory
function TPlaylistManager.PlaylistFileExists(aIndex: Integer): Boolean;
begin
    if aIndex = -2 then
        result := True  // used when a file is selected by an OpenDialog
    else
        if aIndex = -1 then
            result := FileExists(fSavePathDefault + 'nemp.npl')
        else
        begin
            if (aIndex >= 0) and (aIndex < fQuickLoadPlaylists.Count) then
                result := FileExists(fSavePathUserDefined + fQuickLoadPlaylists[aIndex].fFilenName)
            else
                // Index is Out of Range
                result := false;
        end;
end;


///  PreparePlaylistLoading
///  -------------------------
///  Called before loading a new playlist (and clearing the current one)
///  Return Value:
///   * True: Preparation complete, Loading the new playlist should be ok
///   * False: The User aborted the MesseagDlg whether the current playlist
///            should be saved or discarded. Do not proceed loading
function TPlaylistManager.PreparePlaylistLoading(newPlaylistIndex: Integer; aOldPlaylist: TAudioFileList; aIndex, aTrackPos: Integer): Boolean;
begin
    if not PlaylistFileExists(newPlaylistIndex) then
    begin
        TranslateMessageDLG((PlaylistManager_PlaylistNoFound), mtWarning, [MBOK], 0);
        result := False;
        exit;
    end;

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
                // no saving, and also not saving the current position (as it doesn't make sense for a different Playlist)
                // However, prearation is complete
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
    if not PlaylistFileExists(fCurrentIndex) then
    begin
        TranslateMessageDLG((PlaylistManager_PlaylistNoFound), mtWarning, [MBOK], 0);
        result := False;
        exit;
    end;

    if (not CurrentPlaylistHasChanged(aOldPlaylist)) or (fCurrentIndex = -1) then
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
            for i := 0 to fCurrentPlaylistFilenames.Count - 1 do
            begin
                if fCurrentPlaylistFilenames[i] = aFilename then
                begin
                    // we found our currently playing file!
                    fQuickLoadPlaylists[fCurrentIndex].fPlayIndex := i;
                    fQuickLoadPlaylists[fCurrentIndex].fPlayPositionInTrack := aTrackPos;
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
    fCurrentIndex := -1;
    self.fCurrentPlaylistFilenames.Clear;

    if assigned(fOnReset) then
        fOnReset(self);
end;


///  LoadPlaylist
///  ------------
///  Load a QuickLoadPlaylist into the DestinationList
///  And: Automatically call "BackupPlaylistFilenames"
function TPlaylistManager.LoadPlaylist(aIndex: Integer; DestinationPlaylist: TAudioFileList; AutoScan: Boolean): Boolean;
var fn: String;
begin

    // todo: Special Case: aIndex = CurrentIndex
    //---------------------------------------------

    if (aIndex < 0) or (aIndex >= fQuickLoadPlaylists.Count) then
    begin
        fn := fSavePathDefault + 'nemp.npl';
        fCurrentIndex       := -1;
    end
    else
    begin
        fn := fSavePathUserDefined + fQuickLoadPlaylists[aIndex].fFilenName;
        fCurrentIndex       := aIndex;
    end;

    LoadPlaylistFromFile(fn, DestinationPlaylist, AutoScan, fDrivemanager);
    // Refresh Filenames-StringList
    BackupPlaylistFilenames(DestinationPlaylist);

    result := aIndex = fCurrentIndex;   // or FileExists(fn) ??;
end;

///  SavePlaylist
///  ------------
///  Saves a Playlist "SourcePlaylist" as a QuickLoadPlaylist
///  And: Automatically call "BackupPlaylistFilenames"
procedure TPlaylistManager.SaveCurrentPlaylist(SourcePlaylist: TAudioFileList; Silent: Boolean = True);
var fn: String;
begin
    if (fCurrentIndex < 0) or (fCurrentIndex >= fQuickLoadPlaylists.Count) then
    begin
        fn := fSavePathDefault + 'nemp.npl';
    end else
    begin
        fn := fSavePathUserDefined + fQuickLoadPlaylists[fCurrentIndex].fFilenName
    end;
    // Save the list to the file
    SavePlaylistToNPL(fn, SourcePlaylist, fDriveManager, Silent);
    // Refresh Filenames-StringList
    BackupPlaylistFilenames(SourcePlaylist);
end;

procedure TPlaylistManager.SaveCurrentPlaylistPosition(aIndex, aTrackPos: Integer);
begin
    if (fCurrentIndex >= 0) AND (fCurrentIndex < fQuickLoadPlaylists.Count) then
    begin
        fQuickLoadPlaylists[fCurrentIndex].fPlayIndex := aIndex;
        fQuickLoadPlaylists[fCurrentIndex].fPlayPositionInTrack := aTrackPos;
    end;
end;

{function TPlaylistManager.fGetAutoSaveFileName: String;
begin
    if fCurrentFileName = '' then
        result := IncludeTrailingPathDelimiter(SavePath) + 'nemp.npl'
    else
        result := fCurrentFileName;
end;
}



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
    result := 0;
    for i := 0 to fQuickLoadPlaylists.Count - 1 do
    begin
        if fQuickLoadPlaylists[i].Description = aDescription then
            result := result OR PLAYLIST_MANAGER_DESCRIPTION_EXISTS;

        if fQuickLoadPlaylists[i].Filename = aFilename then
            result := result OR PLAYLIST_MANAGER_FILE_EXISTS;
    end;
end;


procedure TPlaylistManager.AddNewPlaylist(aDescription, aFilename: String; aSource: TAudioFileList);
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

    // Set the active Playlist to the one we just added
    CurrentIndex := Count - 1;

    // Save the Playlist
    SaveCurrentPlaylist(aSource, False );

    // after that: GUI should be renewed:
    if assigned(fOnFavouritePlaylistChange) then
        fOnFavouritePlaylistChange(Self);
end;



procedure TPlaylistManager.DeletePlaylist(
  aQuickLoadPlaylist: TQuickLoadPlaylist);
begin
    {

    !! Fix CurrentIndex after that!


    // delete the File from Disk
    DeleteFile(fSavePathUserDefined + aQuickLoadPlaylist.Filename);
    // remove it from the internal List
    fQuickLoadPlaylists.Remove(aQuickLoadPlaylist);

    // after that: GUI should be renewed:
    // Form should recreate MenuItems (or whatever is used to display the QuickLoadPlaylists)


    }
end;


function TPlaylistManager.AddRecentPlaylist(NewFile: UnicodeString): boolean;
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

    // fire OnChange-Event to refresh the GUI
    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
end;

function TPlaylistManager.DeleteRecentPlaylist(aIdx: Integer): boolean;
begin
    RecentPlaylists.Delete(aIdx);

    // fire OnChange-Event to refresh the GUI
    if assigned(fOnRecentPlaylistChange) then
        fOnRecentPlaylistChange(Self);
end;

{procedure TPlaylistManager.AutoSave(aPlaylist: TObjectList);
begin
    // todo
end;
}


end.
