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
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,

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
    procedure FormCreate(Sender: TObject);
    procedure BtnSelectDirectoryClick(Sender: TObject);
    procedure BtnCopyFilesClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    procedure BackupComboboxes;
    procedure RestoreComboboxes;

    procedure WndProc(var Msg: TMessage); override;
  end;

  TReplacePattern = (
      rp_NoRename,
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

          constructor Create;
          destructor Destroy; Override;
  end;


const
  CEXM_CANCEL            = WM_USER + 1;
  CEXM_CONTINUE          = WM_USER + 2; // wParam: lopart, lParam: hipart
  CEXM_MAXBYTES          = WM_USER + 3; // wParam: lopart; lParam: hipart
  CEXM_FILEINDEX         = WM_User + 4;
  CEXM_COPYCOMPLETE      = WM_User + 5;

var
  CancelCopy             : Boolean = False;


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
  Source, Dest, BaseDir : String;
  Handle : THandle;
  Cancel : PBool;
  i : integer;
  af: TAudioFile;

      function Make3Digits(aInt: Integer): String;
      begin
          result := IntToStr(aInt);
          while length(result) < 3 do
              result := '0' + result;
      end;

      // rename a File, input: Complete Path. output: NO PATH, just the filename
      function RenameFile(oldFile: String; Index: Integer; rp: TReplacePattern): String;
      begin
          case rp of
            rp_NoRename: result := ExtractFilename(oldFile);
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
                                result := Make3Digits(Index) + ' - ' + af.FilenameForUSBCopy;
                            finally
                                af.Free;
                            end;
                         end;
          end;


          // ReplaceForbiddenFilenameChars
      end;
begin
    BaseDir := IncludeTrailingPathDelimiter(p.DestinationDirectoy);

    for i := 0 to p.SourceFiles.Count - 1 do
    begin
        if CancelCopy then
            break;


        SendMessage(p.Handle, CEXM_FILEINDEX, wparam(i), lParam(p.SourceFiles[i]));

        Source := p.SourceFiles[i];
        Dest   := BaseDir + RenameFile(p.SourceFiles[i], i, p.ReplacePattern);
        Handle := p.Handle;
        Cancel := PBOOL(False);

        CopyFileEx(PChar(Source), PChar(Dest), @CopyFileProgress, Pointer(Handle), Cancel, 0);

        // search for cue-sheet and copy it, too
        // todo
        d

    end;

    SendMessage(p.Handle, CEXM_COPYCOMPLETE, wParam(CancelCopy), 0);
    // free the Copy-Job
    p.Free;
    result := 0;
 { Source := p.Source;
  Dest := p.Dest;
  Handle := p.Handle;
  Cancel := PBOOL(False);

  CopyFileEx(PChar(Source), PChar(Dest), @CopyFileProgress, Pointer(Handle), Cancel, 0);

  Dispose(p);   // .... p.free
  result := 0;
  }
end;


{ TPlaylistCopyForm }

procedure TPlaylistCopyForm.FormCreate(Sender: TObject);
begin
    BackupComboboxes;
    TranslateComponent (self);
    RestoreComboboxes;

    EditDirectory.Text := GetUSBDrive;
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
        Caption := Inttostr(Msg.WParam);

        LblProgressFile.Caption := Format((CopyToUSB_FileProgress), [pChar(Msg.LParam)] );

    end;

    CEXM_COPYCOMPLETE:
    begin
        if Boolean(Msg.wParam) then
            showmessage('abgebrochen');

        LblProgressFile.Caption := (CopyToUSB_Complete);
        PBComplete.Position := PBComplete.Max;
        PBCurrentFile.Position := PBCurrentFile.Max;
        BtnCopyFiles.Caption := CopyToUSB_Copy;
        BtnCopyFiles.Tag := 0;
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
            Params.Handle := self.Handle;
            Params.ReplacePattern := TReplacePattern(cbRenameSetting.ItemIndex);
            Params.CreatePlaylistFile := cbCreatePlaylistFile.Checked;

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
