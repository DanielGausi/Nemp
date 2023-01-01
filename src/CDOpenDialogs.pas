{

    Unit CDOpenDialogs

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
unit CDOpenDialogs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Contnrs, Dialogs, StdCtrls, basscd, bass, NempAudioFiles, cddaUtils, gnuGetText,
  System.UITypes, Vcl.ExtCtrls;

type
  TCDOpenDialog = class(TForm)
    BtnCancel: TButton;
    BtnOk: TButton;
    GrpBoxDrives: TGroupBox;
    BtnRefreshDrives: TButton;
    cb_Drives: TComboBox;
    GrpBoxTracklist: TGroupBox;
    BtnRefreshTracks: TButton;
    cbUseCDDB: TCheckBox;
    lbTracks: TListBox;
    cbInsertMode: TComboBox;
    LblSelectionMode: TLabel;
    pnlButtons: TPanel;
    cbPreferOnlineData: TCheckBox;
    procedure FormShow(Sender: TObject);

    procedure cb_DrivesChange(Sender: TObject);
    procedure BtnRefreshDrivesClick(Sender: TObject);
    procedure cbUseCDDBClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure lbTracksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnRefreshTracksClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    { Private-Deklarationen }
    CurrentDrive: Integer;
    localAudioFiles: TAudioFileList;
    procedure UpdateDriveListView;
    procedure UpdateTrackList;
  public
    { Public-Deklarationen }
    SelectedFiles: TAudioFileList;
  end;

var
  CDOpenDialog: TCDOpenDialog;

const MAXDRIVES = 10; // maximum number of drives

implementation

uses Nemp_RessourceStrings, Nemp_ConstantsAndTypes, NempMainUnit, Hilfsfunktionen, AudioDisplayUtils;

{$R *.dfm}


procedure TCDOpenDialog.FormCreate(Sender: TObject);
begin
    BackupComboboxes(self);
    TranslateComponent (self);
    RestoreComboboxes(self);
    localAudioFiles := TAudioFileList.Create(True);
    SelectedFiles := TAudioFileList.Create(False);
end;

procedure TCDOpenDialog.FormDestroy(Sender: TObject);
begin
    localAudioFiles.Free;
    SelectedFiles.Free;
end;

procedure TCDOpenDialog.FormShow(Sender: TObject);
begin

  cbUseCDDB.OnClick := Nil;
  cbPreferOnlineData.OnClick := Nil;
  cbUseCDDB.Checked := NempOptions.UseCDDB;
  cbPreferOnlineData.Checked := NempOptions.PreferCDDB;
  cbUseCDDB.OnClick := cbUseCDDBClick;
  cbPreferOnlineData.OnClick := cbUseCDDBClick;

  // Clear Files
  SelectedFiles.Clear;
  if CDDriveList.Count = 0 then
  begin
    MessageDLG(CDDA_NoDrivesFound, mtError, [mbOK], 0);
    PostMessage(self.Handle, WM_Close, 0, 0);
    exit;
  end;
  UpdateDriveListView;
end;


procedure TCDOpenDialog.lbTracksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case Chr(Key) of
        'A': begin
            if ssCtrl in Shift then
                lbTracks.SelectAll;
        end;
    end;
end;

procedure TCDOpenDialog.BtnRefreshTracksClick(Sender: TObject);
begin
  if CDDriveList.Count > CurrentDrive then begin
    RemoveLocalCDDBData(CDDriveList[CurrentDrive]);
    CDDriveList[CurrentDrive].ClearDiscInformation;
    CDDriveList[CurrentDrive].GetDiscInformation(nempOptions.UseCDDB, NempOptions.PreferCDDB);
    UpdateTrackList;
  end;
end;


procedure TCDOpenDialog.BtnRefreshDrivesClick(Sender: TObject);
begin
    BASS_CD_SetInterface(BASS_CD_IF_AUTO);
    UpdateDriveList;
    UpdateDriveListView;
end;

procedure TCDOpenDialog.cb_DrivesChange(Sender: TObject);
begin
    CurrentDrive := cb_Drives.ItemIndex;
    CDDriveList[CurrentDrive].GetDiscInformation(nempOptions.UseCDDB, NempOptions.PreferCDDB);
    UpdateTrackList;
end;

procedure TCDOpenDialog.BtnSelectAllClick(Sender: TObject);
begin
    lbTracks.SelectAll;
end;

procedure TCDOpenDialog.cbUseCDDBClick(Sender: TObject);
begin
  NempOptions.UseCDDB := cbUseCDDB.Checked;
  NempOptions.PreferCDDB := cbPreferOnlineData.Checked;
end;


procedure TCDOpenDialog.UpdateDriveListView;
var aDrive: TCDDADrive;
    i: Integer;
begin
    cb_Drives.Items.Clear;
    for i := 0 to CDDriveList.Count - 1 do
    begin
        aDrive := CDDriveList[i];
        cb_Drives.Items.Add(
              aDrive.Letter + ':\ '
            + String(aDrive.Vendor) + ' '
            + String(aDrive.Product)  ); // + ' v' + aDrive.Revision );
    end;
    if cb_Drives.Items.Count > 0 then begin
      cb_Drives.ItemIndex := 0;
      CurrentDrive := 0;
      CDDriveList[CurrentDrive].GetDiscInformation(nempOptions.UseCDDB, NempOptions.PreferCDDB);
      UpdateTrackList;
    end;
end;


procedure TCDOpenDialog.UpdateTrackList;
var
  newAudioFile: TAudioFile;
  TrackCount, i: Integer;
  TrackData: TCDTrackData;
begin
    lbTracks.Items.Clear;
    localAudioFiles.Clear;
    TrackCount := BASS_CD_GetTracks(CurrentDrive);
    if (TrackCount = -1) then // no CD
      exit;

    for i := 0 to TrackCount - 1 do begin
      if CDDriveList[CurrentDrive].GetTrackData(i+1, TrackData) then begin
        newAudioFile := TAudioFile.Create;
        SetCDDADefaultInformation(newAudioFile);
        newAudioFile.Pfad := CDDriveList[CurrentDrive].Letter + ':\Track' + AddLeadingZeroes(i+1, 2) + '.cda';
        newAudioFile.AssignCDTrackData(TrackData);
        localAudioFiles.Add(newAudioFile);
        lbTracks.Items.Add(IntToStr(newAudioFile.Track) + ' - ' + NempDisplay.PlaylistTitle(newAudioFile));
      end;
    end;
end;


procedure TCDOpenDialog.BtnOkClick(Sender: TObject);
var
  i: Integer;
begin
    for i := 0 to localAudioFiles.Count - 1 do
        if lbTracks.Selected[i] or (cbInsertMode.ItemIndex = 0) then
            SelectedFiles.Add(localAudioFiles[i]);

    NempOptions.UseCDDB := cbUseCDDB.checked;
    NempOptions.PreferCDDB := cbPreferOnlineData.Checked;
end;

end.
