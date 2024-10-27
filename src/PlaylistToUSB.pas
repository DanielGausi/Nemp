{

    Unit PlaylistToUSB
    Form PlaylistCopyForm

    Copies the playlist to an USB-Drive (or another Directory)
    with possibility to rename the files
    (e.g. alphabetical order matches order in the playlist)

    CopyFileEx-Stuff partially copied from Michael Puff aka Luckie,
    http://www.michael-puff.de/Programmierung/Delphi/Code-Snippets/CopyFileEx.shtml

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

//


unit PlaylistToUSB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, MyDialogs, System.Contnrs,
  System.StrUtils,
  gnuGettext, Nemp_RessourceStrings, DriveRepairTools,
  SystemHelper, NempAudioFiles, Hilfsfunktionen, AudioDisplayUtils,
  Vcl.Mask;

type
  TPlaylistCopyForm = class(TForm)
    cbCloseWindow: TCheckBox;
    GrpboxSettings: TGroupBox;
    BtnSelectDirectory: TButton;
    cbRenameSetting: TComboBox;
    EditDirectory: TLabeledEdit;
    LblRenameSetting: TLabel;
    cbCreatePlaylistFile: TCheckBox;
    GrpboxStatus: TGroupBox;
    LblProgressFile: TLabel;
    PBCurrentFile: TProgressBar;
    LblCompleteProgress: TLabel;
    PBComplete: TProgressBar;
    cbIncludeCuesheets: TCheckBox;
    cbConvertSpaces: TCheckBox;
    pnlButtons: TPanel;
    BtnCopyFiles: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnSelectDirectoryClick(Sender: TObject);
    procedure BtnCopyFilesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure LoadSettings;
    procedure SaveSettings;

    procedure WndProc(var Msg: TMessage); override;
  end;


var
  PlaylistCopyForm: TPlaylistCopyForm;

  function GetUSBDrive: String;

implementation

uses NempMainUnit, Nemp_ConstantsAndTypes, math, DuplicateFilesDialogs;

{$R *.dfm}

type

  TCopyExThread = class (TThread)
    private
      FCurrentAudioFile: TAudioFile;
      FM3UPlaylist: TStringList;

      fCurrentDuplicateFilename: String;
      fApplyForAll: Boolean;
      fLastCopyAction: TECopyAction;

      procedure PrepareCurrentAudioFile(aFilename: String);
      function DoCopyFile(Source: String; var Dest: String): Boolean;
      function DoCopyCueSheet(Source, Dest: String): Boolean;
      procedure DoAddPlaylistEntry(aFilename: String);

      procedure InitPlaylist;
      procedure DoSavePlaylist;

      function FindUniqueFilename(aExistingFilename: String): String;
      function IntToStrLeadingZeros(aInt, maxCount: Integer): String;
      function RenameFile(originalFilename: String; newIndex: Integer): String;

      procedure SyncDuplicateFiles;

    protected
      procedure Execute; override;

    public
      Formater: TAudioFormatString;

      SourceFiles: TStringList;
      DestinationDirectoy: String;
      Handle: THandle;
      ReplacePatternString: String;

      CreatePlaylistFile: Boolean;
      IncludeCuesheets: Boolean;
      ConvertSpaces: Boolean;

      constructor Create;
      destructor Destroy; override;
  end;


const
  CEXM_CANCEL            = WM_USER + 1;
  CEXM_CONTINUE          = WM_USER + 2; // wParam: lopart, lParam: hipart
  CEXM_MAXBYTES          = WM_USER + 3; // wParam: lopart; lParam: hipart
  CEXM_FILEINDEX         = WM_User + 4;
  CEXM_COPYCOMPLETE      = WM_User + 5;
  CEXM_PLAYLISTFAILED    = WM_User + 6;
  CEXM_ERROR             = WM_User + 7;

  CEXM_TEST = WM_User + 42;

var
  CancelCopy     : Boolean = False;
  ThreadIsActive : Boolean = False;


function GetUSBDrive: String;
var
  FoundDrives, CurrentDrive  : PChar;
  len   : DWord;
  t: Integer;
begin
    result := GetShellFolder(CSIDL_MYMUSIC);
    GetMem(FoundDrives, 255);
    len := GetLogicalDriveStrings(255, FoundDrives);
    if len > 0 then
    begin
      try
          CurrentDrive := FoundDrives;
          while (CurrentDrive[0] <> #0) do
          begin
              if CurrentDrive <> '' then
              begin
                  t := GetDriveType(CurrentDrive);
                  if t = DRIVE_REMOVABLE then
                  begin
                      result := CurrentDrive;
                      break;
                  end;
              end;
              CurrentDrive := PChar(@CurrentDrive[lstrlen(CurrentDrive) + 1]);
          end;
      finally
          FreeMem(FoundDrives, len);
      end;
    end;
end;

// newfile: Complete path to the new Cue-Sheet
// OldFilename: the old Filename of the mp3-File
procedure RepairCueSheet(newCueFile: String; OldFilename: String);
var sl: TStringList;
    i: Integer;
    testFile: String;
    newMp3Name: String;
begin
    if FileExists(newCueFile) then
    begin
        sl := TStringList.Create;
        try
            sl.LoadFromFile(newCueFile);
            for i := 0 to sl.Count - 1 do
            begin
                if GetCueID(sl[i]) = CUE_ID_FILE then
                begin
                    // we have a "FILE"-Entry here, get the filename
                    testFile := GetFileNameFromCueString(sl[i]);

                    if AnsiSameText(trim(testFile), OldFilename) then
                    begin
                        // we found our matching entry
                        // replace it by the new Filename
                        newMp3Name := ChangeFileExt(
                              ExtractFilename(newCueFile),
                              ExtractFileExt(OldFilename));
                        sl[i] := StringReplace(sl[i], OldFilename, newMp3Name, [rfReplaceAll, rfIgnoreCase]);
                    end;
                end;
            end;
            sl.SaveToFile(newCueFile);
        finally
            sl.Free;
        end;
    end;
end;

function CopyFileProgress(TotalFileSize, TotalBytesTransferred, StreamSize,
  StreamBytesTransferred: LARGE_INTEGER; dwStreamNumber, dwCallbackReason,
  hSourceFile, hDestinationFile: DWORD; lpData: Pointer): DWORD; stdcall;
begin
  if CancelCopy = True then
  begin
    SendMessage(THandle(lpData), CEXM_CANCEL, 0, 0);
    result := PROGRESS_CANCEL;
    exit;
  end;
  case dwCallbackReason of
    CALLBACK_CHUNK_FINISHED:
      begin
        SendMessage(THandle(lpData), CEXM_CONTINUE, TotalBytesTransferred.LowPart, TotalBytesTransferred.HighPart);
        result := PROGRESS_CONTINUE;
      end;
    CALLBACK_STREAM_SWITCH:
      begin
        SendMessage(THandle(lpData), CEXM_MAXBYTES, TotalFileSize.LowPart, TotalFileSize.HighPart);
        result := PROGRESS_CONTINUE;
      end;
  else
    result := PROGRESS_CONTINUE;
  end;
end;



{ TPlaylistCopyForm }

procedure TPlaylistCopyForm.FormCreate(Sender: TObject);
begin
    BackupComboboxes(self);
    TranslateComponent (self);
    RestoreComboboxes(self);

    EditDirectory.Text := GetUSBDrive;

    LoadSettings;
end;


procedure TPlaylistCopyForm.FormShow(Sender: TObject);
begin
    LblProgressFile.Caption := CopyToUSB_Idle;

    PBComplete.Position := 0;
    PBCurrentFile.Position := 0;
    BtnCopyFiles.Caption := CopyToUSB_Copy;
    BtnCopyFiles.Tag := 0;
end;


procedure TPlaylistCopyForm.LoadSettings;
begin
  EditDirectory.Text           := NempSettingsManager.ReadString ('PlaylistCopy', 'DestinationDirectoy', GetUSBDrive);
  cbRenameSetting.Text         := NempSettingsManager.ReadString ('PlaylistCopy', 'ReplacePattern', '<index> - <filename>');
  cbCreatePlaylistFile.Checked := NempSettingsManager.ReadBool('PlaylistCopy', 'CreatePlaylistFile'  , True);
  cbIncludeCuesheets  .Checked := NempSettingsManager.ReadBool('PlaylistCopy', 'IncludeCuesheets'    , True);
  cbConvertSpaces     .Checked := NempSettingsManager.ReadBool('PlaylistCopy', 'ConvertSpaces'       , False);
  cbCloseWindow       .Checked := NempSettingsManager.ReadBool('PlaylistCopy', 'CloseWindowAfterCopy', False);
end;

procedure TPlaylistCopyForm.SaveSettings;
begin
  NempSettingsManager.WriteString ('PlaylistCopy', 'DestinationDirectoy' , EditDirectory.Text          );
  NempSettingsManager.WriteString ('PlaylistCopy', 'ReplacePattern', cbRenameSetting.Text);
  NempSettingsManager.WriteBool   ('PlaylistCopy', 'CreatePlaylistFile'  , cbCreatePlaylistFile.Checked);
  NempSettingsManager.WriteBool   ('PlaylistCopy', 'IncludeCuesheets'    , cbIncludeCuesheets  .Checked);
  NempSettingsManager.WriteBool   ('PlaylistCopy', 'ConvertSpaces'       , cbConvertSpaces     .Checked);
  NempSettingsManager.WriteBool   ('PlaylistCopy', 'CloseWindowAfterCopy', cbCloseWindow       .Checked);
  NempSettingsManager.WriteToDisk;

  if FileExists(NempSettingsManager.SavePath + 'PlaylistCopy.ini') then
    DeleteFile(NempSettingsManager.SavePath + 'PlaylistCopy.ini');
end;

procedure TPlaylistCopyForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if ThreadIsActive then
    begin
        case TranslateMessageDLG((CopyToUSB_AbortQuery), mtWarning, [MBYes, MBNO], 0) of
            mrYes: begin
                CancelCopy := True;
                CanClose := True;
            end;
            mrNo: begin
                CanClose := False;
            end;
        end;
    end else
        canClose := True;
end;

procedure TPlaylistCopyForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveSettings;
end;

procedure TPlaylistCopyForm.WndProc(var Msg: TMessage);
begin
  inherited;
  case Msg.Msg of
    CEXM_MAXBYTES: PBCurrentFile.Max := (Msg.LParam shl 32) + Integer(Msg.WParam);

    CEXM_CONTINUE: PBCurrentFile.Position := (Int64(Msg.LParam) shl 32) + Msg.WParam;
    CEXM_CANCEL: PBCurrentFile.Position := 0;

    CEXM_FILEINDEX:
    begin
        PBComplete.Position := Msg.WParam;
        LblProgressFile.Caption := Format((CopyToUSB_FileProgress), [pChar(Msg.LParam)] );
    end;

    CEXM_COPYCOMPLETE:
    begin
        if Boolean(Msg.wParam) then
            LblProgressFile.Caption := (CopyToUSB_Aborted)
        else
            LblProgressFile.Caption := (CopyToUSB_Complete);

        PBComplete.Position := PBComplete.Max;
        PBCurrentFile.Position := PBCurrentFile.Max;
        BtnCopyFiles.Caption := CopyToUSB_Copy;
        BtnCopyFiles.Tag := 0;

        if (not Boolean(Msg.wParam)) and (cbCloseWindow.Checked) then
            close;
    end;
    CEXM_PLAYLISTFAILED: TranslateMessageDLG(Format((CopyToUSB_SavingPlaylistFailed), [pChar(Msg.wParam)] ), mtWarning, [mbOk], 0);

    CEXM_ERROR: begin
        // display some known errors that might occur
        case Integer(Msg.wParam) of
            ERROR_FILE_NOT_FOUND:
                Msg.Result := Integer(TranslateMessageDLG((CopyToUSB_ERROR_FILE_NOT_FOUND), mtError, [mbOk, mbCancel], 0) = mrOK);

            ERROR_PATH_NOT_FOUND:
                Msg.Result := Integer(TranslateMessageDLG((CopyToUSB_ERROR_PATH_NOT_FOUND), mtError, [mbOk, mbCancel], 0) = mrOK);

            ERROR_TOO_MANY_OPEN_FILES:
                Msg.Result := Integer(TranslateMessageDLG((CopyToUSB_ERROR_TOO_MANY_OPEN_FILES), mtError, [mbOk, mbCancel], 0) = mrOK);

            ERROR_ACCESS_DENIED:
                Msg.Result := Integer(TranslateMessageDLG((CopyToUSB_ERROR_ACCESS_DENIED), mtError, [mbOk, mbCancel], 0) = mrOK);

            ERROR_NOT_ENOUGH_MEMORY:
                Msg.Result := Integer(TranslateMessageDLG((CopyToUSB_ERROR_NOT_ENOUGH_MEMORY), mtError, [mbOk, mbCancel], 0) = mrOK);
        else
            Msg.Result := Integer(TranslateMessageDLG( Format(CopyToUSB_ERROR_UNKOWN, [Integer(Msg.wparam)]), mtError, [mbOk, mbCancel], 0) = mrOK);
        end;
    end;

    CEXM_TEST: begin
        // test test
    end;
  end;
end;

{
    BtnSelectDirectoryClick
    Show Dialog to choose an directory
}
procedure TPlaylistCopyForm.BtnSelectDirectoryClick(Sender: TObject);
var
  OpenDlg: TFileOpenDialog;
begin
  OpenDlg := TFileOpenDialog.Create(self);
  try
    OpenDlg.Options := OpenDlg.Options + [fdoPickFolders];
    OpenDlg.DefaultFolder := EditDirectory.Text;
    if OpenDlg.Execute then
      EditDirectory.Text := OpenDlg.FileName;
  finally
    OpenDlg.Free;
  end;
end;

procedure TPlaylistCopyForm.BtnCopyFilesClick(Sender: TObject);
var
  newCopyThread: TCopyExThread;
  i: Integer;
begin
    case (Sender as TButton).Tag of
        0: begin
            if Trim(EditDirectory.Text) = '' then
            begin
                // note: ForceDirectories will raise an exception with an empty string.
                TranslateMessageDLG(CopyToUSB_ChooseDestination, mtWarning, [mbOk], 0);
                exit;
            end;
            // check the destination directory
            if Not DirectoryExists(EditDirectory.Text) then
            begin
                if TranslateMessageDLG(CopyToUSB_DestinationDirDoesNotexist, mtConfirmation, [mbYes, mbNo, mbAbort], 0) = mrYes then
                begin
                    if not ForceDirectories(EditDirectory.Text) then
                    begin
                        // Directory couldnt be created. Probably the user entered some crap in the edit
                        TranslateMessageDLG(CopyToUSB_DestinationDirCreateFailed, mtError, [mbOk], 0);
                        exit;
                    end;
                end else
                    // User choosed Abort or No - Do NOT copy anything
                    exit;
            end;


            (Sender as TButton).Tag := 1;
            // Start the Copy-process
            BtnCopyFiles.Caption := CopyToUSB_Abort;

            cancelCopy := False;
            newCopyThread := TCopyExThread.Create;

            // 1. fill Source-List
            for i := 0 to NempPlaylist.Count - 1 do
                if FileExists(NempPlaylist.Playlist[i].Pfad) then
                    newCopyThread.SourceFiles.Add(NempPlaylist.Playlist[i].Pfad);
            // 2. Set Parameters
            newCopyThread.DestinationDirectoy := IncludeTrailingPathDelimiter(EditDirectory.Text);
            newCopyThread.Handle              := self.Handle;
            newCopyThread.ReplacePatternString:= cbRenameSetting.Text;
            newCopyThread.CreatePlaylistFile  := cbCreatePlaylistFile.Checked;
            newCopyThread.IncludeCuesheets    := cbIncludeCuesheets.Checked;
            newCopyThread.ConvertSpaces       := cbConvertSpaces.Checked;

            // Set GUI
            PBComplete.Max := newCopyThread.SourceFiles.Count;
            PBComplete.Position := 0;
            PBCurrentFile.Position := 0;

            // Start copying
            newCopyThread.Start;
        end;
        1: begin
            (Sender as TButton).Tag := 0;
            // Cancel copying
            BtnCopyFiles.Caption := CopyToUSB_Copy;
            CancelCopy := True;
        end;
    end;
end;


{ TCopyExTHread }

constructor TCopyExThread.Create;
begin
  inherited create(True);

  SourceFiles := TStringList.Create;
  FM3UPlaylist := TStringList.Create;
  Formater := TAudioFormatString.Create('');
  FCurrentAudioFile := Nil;

  FreeOnTerminate := True;
end;

destructor TCopyExThread.Destroy;
begin
  if Assigned(FCurrentAudioFile) then
    FCurrentAudioFile.Free;
  FM3UPlaylist.Free;
  SourceFiles.Free;
  Formater.Free;
  inherited;
end;

procedure TCopyExThread.PrepareCurrentAudioFile(aFilename: String);
begin
  // destroy existing object
  if assigned(FCurrentAudioFile) then
    FCurrentAudioFile.Free;
  // create a new one and read metadata from it
  FCurrentAudioFile := TAudioFile.Create;
  FCurrentAudioFile.GetAudioData(aFilename);
end;


function TCopyExThread.IntToStrLeadingZeros(aInt, maxCount: Integer): String;
begin
  result := IntToStr(aInt);
  while length(result) <= log10(maxCount) do
    result := '0' + result;
end;


function TCopyExThread.RenameFile(originalFilename: String;
  newIndex: Integer): String;
begin
  if not assigned(FCurrentAudioFile) then
    result := originalFilename // this should never happen ...
  else
  begin
    result := Formater.ParsedTitle(FCurrentAudioFile);

    if not AnsiEndsText(FCurrentAudioFile.Extension, result) then
      result := result + '.' + FCurrentAudioFile.Extension;

    // a little bit more formating
    result := Stringreplace(result, '<Index>', IntToStrLeadingZeros(newIndex, SourceFiles.count), [rfIgnoreCase, rfReplaceAll]);
    result := ReplaceForbiddenFilenameChars(result);
    if ConvertSpaces then
      result := StringReplace(result, ' ', '_', [rfReplaceAll]);
  end;
end;

procedure TCopyExThread.SyncDuplicateFiles;
begin
  if fApplyForAll then // no change needed
    exit;

  if Not Assigned(DuplicateFilesDialog) then
    Application.CreateForm(TDuplicateFilesDialog, DuplicateFilesDialog);

  DuplicateFilesDialog.Filename := fCurrentDuplicateFilename;

  DuplicateFilesDialog.ApplyForAll := False;
  DuplicateFilesDialog.CopyAction := fLastCopyAction;

  case DuplicateFilesDialog.ShowModal of
    mrOK: begin
      fApplyForAll := DuplicateFilesDialog.ApplyForAll;
      fLastCopyAction := DuplicateFilesDialog.CopyAction;
    end;
    mrCancel: begin
      fLastCopyAction := caCancel;
    end;
  else
    fLastCopyAction := caCancel;
  end;
end;

function TCopyExThread.FindUniqueFilename(aExistingFilename: String): String;
var
  aPath, aExt, aFileName, newName: String;
  i: Integer;
begin
  aExt := ExtractFileExt(aExistingFilename);
  aPath := ExtractFilePath(aExistingFilename);
  aFileName := ChangeFileExt(ExtractFilename(aExistingFilename), '');
  i := 0;
  repeat
    inc(i);
    newName := aPath + aFileName + '('+ IntToStr(i)+ ')' + aExt;
  until not FileExists(newName);

  result := newName;
end;


function TCopyExThread.DoCopyFile(Source: String; var Dest: String): Boolean;
var
  Cancel: PBool;
  LastError: Cardinal;
  p: String;
begin
  Cancel := PBOOL(False);
  result := True;

  if FileExists(Dest) then
  begin
    fCurrentDuplicateFilename := Dest;
    Synchronize(SyncDuplicateFiles);

    case self.fLastCopyAction of
      caSkip: result := False;
      caRename: Dest := FindUniqueFilename(Dest);
      caOverwrite: ; // nothing to do, just overwrite the file
      caCancel: begin
        result := False;
        CancelCopy := True;
      end;
    end;
  end;

  p := dest;
  // copy the audiofile with progress
  if result and (not CopyFileEx(PChar(Source), PChar(p), @CopyFileProgress, Pointer(Handle), Cancel, 0)) then
  begin
    // some error occurred
    LastError := GetLastError;
    if SendMessage(Handle, CEXM_ERROR, wParam(LastError), 0) = 0 then
    begin
      CancelCopy := True;
      result := False;
    end;
  end;
end;


function TCopyExThread.DoCopyCueSheet(Source, Dest: String): Boolean;
begin
  if FileExists(ChangeFileExt(Source, '.cue')) then
  begin
    // just copy the (very small) cuesheetfile - no use for CopyEx
    CopyFile(PChar(ChangeFileExt(Source, '.cue')), PChar(ChangeFileExt(Dest, '.cue')), False);
    // repair the cuesheet, i.e. change the file-entry in it
    RepairCueSheet(ChangeFileExt(Dest, '.cue'), ExtractFileName(Source));
    result := True;
  end else
    result := False;
end;

procedure TCopyExThread.InitPlaylist;
begin
  FM3UPlaylist.Clear;
  FM3UPlaylist.Add('#EXTM3U');
end;

procedure TCopyExThread.DoAddPlaylistEntry(aFilename: String);
begin
  // Add File to Playlist
  FM3UPlaylist.add('#EXTINF:' + IntTostr(FCurrentAudioFile.Duration) + ','
          + FCurrentAudioFile.Artist + ' - ' + FCurrentAudioFile.Titel);
  // only the filename here
  FM3UPlaylist.Add(ExtractFilename(aFilename));
end;

procedure TCopyExThread.DoSavePlaylist;
var
  m3u8Needed: Boolean;
  tmpAnsi: AnsiString;
  tmpUnicode: UnicodeString;
  fn: String;
begin
  tmpUnicode := FM3UPlaylist.Text;
  tmpAnsi := AnsiString(tmpUnicode);
  m3u8Needed := (tmpUnicode <> UnicodeString(tmpAnsi));

  fn := IncludeTrailingPathDelimiter(DestinationDirectoy) + IntToStrLeadingZeros(0, SourceFiles.Count) + '_Playlist';
  try
    if m3u8Needed then
    begin
      fn := fn + '.m3u8';
      FM3UPlaylist.SaveToFile(fn, TEncoding.UTF8);
    end else
    begin
      fn := fn + '.m3u';
      FM3UPlaylist.SaveToFile(fn, TEncoding.Default);
    end;
  except
    on E: Exception do
      SendMessage(Handle, CEXM_PLAYLISTFAILED, wParam(E.Message), 0);
  end;
end;

procedure TCopyExThread.Execute;
var
  i, CurrentFileNumber: Integer;
  DestFile: String;

begin
  inherited;
  ThreadIsActive := True;
  // re-init copy-actions
  fApplyForAll := False;      // Ask again, if there are duplicate files
  fLastCopyAction := caSkip;  // default: Skip

  Formater.parseString := ReplacePatternString;
  // clear Playlist and add header
  InitPlaylist;
  CurrentFileNumber := 0;
  for i := 0 to SourceFiles.Count - 1 do
  begin
    if CancelCopy then
      break;

    // Send status message to GUI
    SendMessage(Handle, CEXM_FILEINDEX, wparam(i), lParam(SourceFiles[i]));

    // Read Audiofile information from the current File
    // this imformation will be used by RenameFile and DoAddPlaylistEntry
    PrepareCurrentAudioFile(SourceFiles[i]);
    DestFile := DestinationDirectoy + RenameFile(SourceFiles[i], CurrentFileNumber+1);

    // Copy the file. Note: the filename "DestFile" may be changed during this operation
    if DoCopyFile(SourceFiles[i], DestFile) then
    begin
      inc(CurrentFileNumber);
      if IncludeCueSheets then
        DoCopyCueSheet(SourceFiles[i], DestFile);

      if CreatePlaylistFile then
        DoAddPlaylistEntry(DestFile);
    end;
  end;

  if not CancelCopy and CreatePlaylistFile then
    DoSavePlaylist;

  // Finish Thread
  ThreadIsActive := False;
  SendMessage(Handle, CEXM_COPYCOMPLETE, wParam(CancelCopy), 0);
end;



end.
