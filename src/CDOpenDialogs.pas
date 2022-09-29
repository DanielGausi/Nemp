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
  Contnrs, Dialogs, StdCtrls, basscd, NempAudioFiles, cddaUtils, gnuGetText,
  System.UITypes;

type
  TCDOpenDialog = class(TForm)
    BtnCancel: TButton;
    BtnOk: TButton;
    GrpBoxDrives: TGroupBox;
    BtnRefresh: TButton;
    cb_Drives: TComboBox;
    GrpBoxTracklist: TGroupBox;
    BtnCDDB: TButton;
    cb_AutoCddb: TCheckBox;
    lbTracks: TListBox;
    cbInsertMode: TComboBox;
    LblSelectionMode: TLabel;
    procedure FormShow(Sender: TObject);

    procedure cb_DrivesChange(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure cb_AutoCddbClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure lbTracksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnCDDBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    { Private-Deklarationen }
    CurrentDrive: Integer;
    localAudioFiles: TAudioFileList;
    procedure UpdateDriveListView;
    procedure UpdateTrackList(UseCddb: Boolean);
  public
    { Public-Deklarationen }
    Files: TStringList;
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
    Files := TStringList.Create;
end;

procedure TCDOpenDialog.FormDestroy(Sender: TObject);
begin
    localAudioFiles.Free;
    Files.Free;
end;

procedure TCDOpenDialog.FormShow(Sender: TObject);
begin
    // cb_AutoCddb.OnClick := Nil;
    // cb_AutoCddb.checked := NempOptions.UseCDDB;
    // cb_AutoCddb.OnClick := cb_AutoCddbClick;
    // Get list of available drives
    EnsureDriveListIsFilled;     // from cddaUtils
    // Clear Files
    Files.Clear;
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

procedure TCDOpenDialog.BtnCDDBClick(Sender: TObject);
begin
    ClearCDDBCache(cb_Drives.ItemIndex);

    ClearCDDBCache(-1);
    UpdateTrackList(True);
end;


procedure TCDOpenDialog.BtnRefreshClick(Sender: TObject);
begin
    UpdateDriveList;
    UpdateDriveListView;
end;

procedure TCDOpenDialog.cb_DrivesChange(Sender: TObject);
begin
    CurrentDrive := cb_Drives.ItemIndex;
    UpdateTrackList(cb_AutoCddb.Checked);
end;

procedure TCDOpenDialog.BtnSelectAllClick(Sender: TObject);
begin
    lbTracks.SelectAll;
end;

procedure TCDOpenDialog.cb_AutoCddbClick(Sender: TObject);
begin
    //if cb_AutoCddb.Checked then
    //    UpdateTrackList(true); // Update tracklist with cddb-Data
end;


procedure TCDOpenDialog.UpdateDriveListView;
var aDrive: TCDDADrive;
    i: Integer;
begin
    cb_Drives.Items.Clear;
    for i := 0 to CDDriveList.Count - 1 do
    begin
        aDrive := TCDDADrive(CDDriveList[i]);
        cb_Drives.Items.Add(
              aDrive.Letter + ':\ '
            + String(aDrive.Vendor) + ' '
            + String(aDrive.Product)  ); // + ' v' + aDrive.Revision );
    end;
    cb_Drives.ItemIndex := 0;
    CurrentDrive := 0;
    UpdateTrackList(cb_AutoCddb.Checked);
end;


procedure TCDOpenDialog.UpdateTrackList(UseCddb: Boolean);
var l: Integer;
    newAudioFile: TAudioFile;
    TrackCount, i: Integer;
begin
    TrackCount := BASS_CD_GetTracks(CurrentDrive);


    lbTracks.Items.Clear;
    localAudioFiles.Clear;

    if (TrackCount = -1) then // no CD
    begin
        exit;
    end;

    for i := 0 to TrackCount - 1 do
    begin
        l := BASS_CD_GetTrackLength(CurrentDrive, i);
        if l >= 0 then
        begin

            newAudioFile := TAudioFile.Create;
            newAudioFile.Pfad := 'cda://' + TCDDADrive(CDDriveList[CurrentDrive]).Letter + ',' + IntToStr(i+1);

            localAudioFiles.Add(newAudioFile);
            //if UseCddb then
            //    newAudioFile.GetAudioData(newAudioFile.Pfad, GAD_cddb)
            //else
                newAudioFile.GetAudioData(newAudioFile.Pfad, 0);

            lbTracks.Items.Add(IntToStr(newAudioFile.Track) + ' - ' + NempDisplay.PlaylistTitle(newAudioFile));
        end;
    end;
end;


procedure TCDOpenDialog.BtnOkClick(Sender: TObject);
var i: Integer;
begin
    for i := 0 to localAudioFiles.Count - 1 do
        if lbTracks.Selected[i] or (cbInsertMode.ItemIndex = 0) then
            Files.Add(localAudioFiles[i].Pfad);

    // NempOptions.UseCDDB := cb_AutoCddb.checked;
end;

end.
