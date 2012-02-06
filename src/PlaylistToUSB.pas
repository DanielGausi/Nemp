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

//


unit PlaylistToUSB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, IniFiles, MyDialogs,

  Nemp_ConstantsAndTypes, gnuGettext, Nemp_RessourceStrings, DriveRepairTools,
  SystemHelper, fldBrows, AudioFileClass, Hilfsfunktionen

  ;

type
  TPlaylistCopyForm = class(TForm)
    BtnCopyFiles: TButton;
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
    procedure BackupComboboxes;
    procedure RestoreComboboxes;

    procedure WndProc(var Msg: TMessage); override;
  end;

  TReplacePattern = (
      rp_NoRename = 0,
      rp_OriginalNumbered,
      rp_Playlist,
      rp_Numbered );

var
  PlaylistCopyForm: TPlaylistCopyForm;

  function GetUSBDrive: String;

implementation

uses NempMainUnit;

{$R *.dfm}

type
  TCopyEx = class
      public
          SourceFiles: TStringList;
          DestinationDirectoy: String;
          Handle: THandle;
          ReplacePattern: TReplacePattern;
          CreatePlaylistFile: Boolean;
          IncludeCuesheets: Boolean;
          ConvertSpaces: Boolean;
          constructor Create;
          destructor Destroy; Override;
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


{ TCopyEx }

constructor TCopyEx.Create;
begin
    SourceFiles := TStringList.Create;
end;

destructor TCopyEx.Destroy;
begin
    SourceFiles.Free;
    inherited;
end;



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

function CopyExThread(p: TCopyEx): Integer;
var
  Source, Dest, BaseDir: String;
  Handle : THandle;
  Cancel : PBool;
  i : integer;
  af: TAudioFile;
  NumberLength: Integer;
  tmpPlaylist: TStringList;
  m3u8Needed: Boolean;
  tmpAnsi: AnsiString;
  tmpUnicode: UnicodeString;
  LastError: Cardinal;
  fn: String;

      function MakeEnoughDigits(aInt: Integer): String;
      begin
          result := IntToStr(aInt);
          while length(result) < NumberLength do
              result := '0' + result;
      end;

      // rename a File, input: Complete Path. output: NO PATH, just the filename
      function RenameFile(oldFile: String; Index: Integer; rp: TReplacePattern; replaceSpaces: Boolean): String;
      begin
          case rp of
            rp_NoRename: result := ExtractFilename(oldFile);
            rp_OriginalNumbered: result := MakeEnoughDigits(Index) + ' - ' + ExtractFilename(oldFile);
            rp_Playlist: begin
                            af := TAudioFile.Create;
                            try
                                af.GetAudioData(oldFile);
                                result := af.FilenameForUSBCopy;
                            finally
                                af.Free;
                            end;
                         end;
            rp_Numbered: begin
                            af := TAudioFile.Create;
                            try
                                af.GetAudioData(oldFile);
                                result := MakeEnoughDigits(Index) + ' - ' + af.FilenameForUSBCopy;
                            finally
                                af.Free;
                            end;
                         end;
          end;

          if replaceSpaces then
              result := StringReplace(result, ' ', '_', [rfReplaceAll]);
      end;
begin
    ThreadIsActive := True;
    BaseDir := IncludeTrailingPathDelimiter(p.DestinationDirectoy);

    NumberLength := Length(IntToStr(p.SourceFiles.Count));

    tmpPlaylist := TStringList.Create;   // always create the playlist-stringlist, even if its not needed
    try
        tmpPlaylist.Add('#EXTM3U');      // Add header to m3u-list
        for i := 0 to p.SourceFiles.Count - 1 do
        begin
            if CancelCopy then
                break;
            // Send Message to GUI
            SendMessage(p.Handle, CEXM_FILEINDEX, wparam(i), lParam(p.SourceFiles[i]));

            // Set CopyEx-parameters
            Source := p.SourceFiles[i];
            Dest   := BaseDir + RenameFile(p.SourceFiles[i], i+1, p.ReplacePattern, p.ConvertSpaces);
            Handle := p.Handle;
            Cancel := PBOOL(False);

            // copy the audiofile with progress
            if not CopyFileEx(PChar(Source), PChar(Dest), @CopyFileProgress, Pointer(Handle), Cancel, 0) then
            begin
                // some error occurred
                LastError := GetLastError;
                if SendMessage(p.Handle, CEXM_ERROR, wParam(LastError), 0) = 0 then
                begin
                    CancelCopy := True;
                    break;
                end;
            end;

            // check for a matching Cuesheet
            if p.IncludeCuesheets then
            begin
                if FileExists(ChangeFileExt(Source, '.cue')) then
                begin
                    // just copy the (very small) cuesheetfile - no use for CopyEx
                    CopyFile(PChar(ChangeFileExt(Source, '.cue')), PChar(ChangeFileExt(Dest, '.cue')), False);
                    // repair the cuesheet, i.e. change the File-Entry in it
                    RepairCueSheet(ChangeFileExt(Dest, '.cue'), ExtractFileName(Source));
                end;
            end;

            // add file to playlist (if needed)
            if p.CreatePlaylistFile then
            begin
                af := TAudioFile.Create;
                try
                    af.GetAudioData(Dest);
                    // Add File to Playlist
                    tmpPlaylist.add('#EXTINF:' + IntTostr(af.Duration) + ','
                            + af.Artist + ' - ' + af.Titel);
                    // only the filename here
                    tmpPlaylist.Add(af.Dateiname);
                finally
                    af.Free;
                end;
            end;
        end; // for i := 0 to p.SourceFiles.Count - 1 do

        // save Playlist
        if (Not CancelCopy) and p.CreatePlaylistFile then
        begin
            tmpUnicode := tmpPlaylist.Text;
            tmpAnsi := AnsiString(tmpUnicode);
            m3u8Needed := (tmpUnicode <> UnicodeString(tmpAnsi));

            try
                if m3u8Needed then
                begin
                    if p.ConvertSpaces then
                        fn := BaseDir + MakeEnoughDigits(0) +  '_-_Playlist.m3u8'
                    else
                        fn := BaseDir + MakeEnoughDigits(0) +  ' - Playlist.m3u8';

                    tmpPlaylist.SaveToFile(fn, TEncoding.UTF8);
                end
                else
                begin
                    if p.ConvertSpaces then
                        fn := BaseDir + MakeEnoughDigits(0) +  '_-_Playlist.m3u'
                    else
                        fn := BaseDir + MakeEnoughDigits(0) +  ' - Playlist.m3u';

                    tmpPlaylist.SaveToFile(fn, TEncoding.Default);
                end;
            except
                on E: Exception do
                    SendMessage(p.Handle, CEXM_PLAYLISTFAILED, wParam(E.Message), 0);
            end;
        end;

    finally
        tmpPlaylist.Free;
    end;
    // free the Copy-Job
    p.Free;
    result := 0;

    ThreadIsActive := False;
    SendMessage(p.Handle, CEXM_COPYCOMPLETE, wParam(CancelCopy), 0);
end;


{ TPlaylistCopyForm }

procedure TPlaylistCopyForm.FormCreate(Sender: TObject);
var Ini: TMeminiFile;
    tmpPattern: Integer;
begin
    BackupComboboxes;
    TranslateComponent (self);
    RestoreComboboxes;

    EditDirectory.Text := GetUSBDrive;

    Ini := TMeminiFile.Create(SavePath + 'PlaylistCopy.ini', TEncoding.Utf8);
    try
        Ini.Encoding := TEncoding.UTF8;

        EditDirectory.Text := Ini.ReadString ('CopySettings', 'DestinationDirectoy', GetUSBDrive);
        tmpPattern         := Ini.ReadInteger('CopySettings', 'ReplacePattern'     , 3);
        if tmpPattern in [0..3] then
            cbRenameSetting.ItemIndex := tmpPattern
        else
            cbRenameSetting.ItemIndex := 3;

        cbCreatePlaylistFile.Checked := Ini.ReadBool('CopySettings', 'CreatePlaylistFile'  , True);
        cbIncludeCuesheets  .Checked := Ini.ReadBool('CopySettings', 'IncludeCuesheets'    , True);
        cbConvertSpaces     .Checked := Ini.ReadBool('CopySettings', 'ConvertSpaces'       , False);
        cbCloseWindow       .Checked := Ini.ReadBool('CopySettings', 'CloseWindowAfterCopy', False);

    finally
        Ini.Free;
    end;
end;


procedure TPlaylistCopyForm.FormShow(Sender: TObject);
begin
    LblProgressFile.Caption := CopyToUSB_Idle;

    PBComplete.Position := 0;
    PBCurrentFile.Position := 0;
    BtnCopyFiles.Caption := CopyToUSB_Copy;
    BtnCopyFiles.Tag := 0;
end;

procedure TPlaylistCopyForm.BackupComboboxes;
var i: Integer;
begin
    for i := 0 to self.ComponentCount - 1 do
        if (Components[i] is TComboBox) then
            Components[i].Tag := (Components[i] as TComboBox).ItemIndex;
end;
procedure TPlaylistCopyForm.RestoreComboboxes;
var i: Integer;
begin
    for i := 0 to self.ComponentCount - 1 do
        if (Components[i] is TComboBox) then
            (Components[i] as TComboBox).ItemIndex := Components[i].Tag;
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
var Ini: TMemIniFile;
begin
    Ini := TMeminiFile.Create(SavePath + 'PlaylistCopy.ini', TEncoding.Utf8);
    try
        Ini.Encoding := TEncoding.UTF8;
        Ini.WriteString ('CopySettings', 'DestinationDirectoy' , EditDirectory.Text          );
        Ini.WriteInteger('CopySettings', 'ReplacePattern'      , cbRenameSetting.ItemIndex   );
        Ini.WriteBool   ('CopySettings', 'CreatePlaylistFile'  , cbCreatePlaylistFile.Checked);
        Ini.WriteBool   ('CopySettings', 'IncludeCuesheets'    , cbIncludeCuesheets  .Checked);
        Ini.WriteBool   ('CopySettings', 'ConvertSpaces'       , cbConvertSpaces     .Checked);
        Ini.WriteBool   ('CopySettings', 'CloseWindowAfterCopy', cbCloseWindow       .Checked);
    finally
        Ini.UpdateFile;
        Ini.Free;
    end;
end;

procedure TPlaylistCopyForm.WndProc(var Msg: TMessage);
begin
  inherited;
  case Msg.Msg of
    CEXM_MAXBYTES:
      begin
        PBCurrentFile.Max := (Msg.LParam shl 32) + Msg.WParam;
      end;
    CEXM_CONTINUE:
      begin
        PBCurrentFile.Position := (Int64(Msg.LParam) shl 32) + Msg.WParam;
        // Caption := IntToStr(Msg.WParam + Msg.LParam);
      end;
    CEXM_CANCEL:
    begin
      PBCurrentFile.Position := 0;
      // Caption := '0';
    end;

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
    CEXM_PLAYLISTFAILED: begin
        TranslateMessageDLG(Format((CopyToUSB_SavingPlaylistFailed), [pChar(Msg.wParam)] ), mtWarning, [mbOk], 0);
    end;

    CEXM_ERROR: begin
        // display sme known errors that might occur
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
    FB: TFolderBrowser;
begin
    FB := TFolderBrowser.Create(self.Handle, SelectDirectoryDialog_BibCaption, EditDirectory.Text);
    try
        fb.NewFolderButton := True;
        if fb.Execute then
        begin
            EditDirectory.Text := FB.SelectedItem;
        end;
    finally
        fb.Free;
    end;
end;



procedure TPlaylistCopyForm.BtnCopyFilesClick(Sender: TObject);
var
    Params: TCopyEx;
    ThreadID: Cardinal;
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

            Params := TCopyEx.Create; // Params will be freed by the Thread

            // 1. fill Source-List
            for i := 0 to NempPlaylist.Count - 1 do
                if FileExists( TAudioFile(NempPlaylist.Playlist[i]).Pfad) then
                    Params.SourceFiles.Add(TAudioFile(NempPlaylist.Playlist[i]).Pfad);
            // 2. Set Parameters
            Params.DestinationDirectoy := EditDirectory.Text;
            Params.Handle              := self.Handle;
            Params.ReplacePattern      := TReplacePattern(cbRenameSetting.ItemIndex);
            Params.CreatePlaylistFile  := cbCreatePlaylistFile.Checked;
            Params.IncludeCuesheets    := cbIncludeCuesheets.Checked;
            Params.ConvertSpaces       := cbConvertSpaces.Checked;

            // Set GUI
            PBComplete.Max := Params.SourceFiles.Count;
            PBComplete.Position := 0;
            PBCurrentFile.Position := 0;

            // Start copying in secondary thread
            CloseHandle(BeginThread(nil, 0, @CopyExThread, Params, 0, ThreadID));
        end;
        1: begin
            (Sender as TButton).Tag := 0;
            // Cancel copying
            BtnCopyFiles.Caption := CopyToUSB_Copy;
            CancelCopy := True;

        end;
    end;
end;




end.
