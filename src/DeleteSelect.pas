{

    Unit DeleteSelect
    Form DeleteSelection

    A Form for selecting which files should be removed from the
    Media Library (and which not)

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
unit DeleteSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ContNrs, NempAudioFiles, DeleteHelper,
  DriveRepairTools, ExtCtrls, ImgList, GnuGetText, System.UITypes, NempHelp,
  System.ImageList, Generics.Collections, VirtualTrees, PNGImage, CommCtrl, dmGui,
  Vcl.VirtualImageList, Vcl.VirtualImage ;

type
  TDeleteSelection = class(TForm)
    LblFiles: TLabel;
    BtnOk: TButton;
    Btncancel: TButton;
    BtnHelp: TButton;
    Panel1: TPanel;
    VSTPlaylistFiles: TVirtualStringTree;
    Splitter1: TSplitter;
    VSTFiles: TVirtualStringTree;
    lblMainExplanation: TLabel;
    grpBoxDrives: TGroupBox;
    DriveImage: TVirtualImage;
    LblExplaination: TLabel;
    LblWhatToDo: TLabel;
    LblExplaination2: TLabel;
    HintImage: TVirtualImage;
    VSTDrives: TVirtualStringTree;
    ImgHelp: TVirtualImage;
    checkImages: TVirtualImageList;
    pnlHeader: TPanel;
    Splitter2: TSplitter;
    pnlFiles: TPanel;
    pnlButtons: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VSTFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTPlaylistFilesGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure VSTDrivesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTDrivesChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTDrivesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    { Private-Deklarationen }
    procedure FillTreeViews(currentData: TDeleteData);

  public
    { Public-Deklarationen }
    DataFromMedienBib: TObjectList;
    procedure ReloadScheckBoxImages(UseSkin: Boolean);
  end;

//var
//  DeleteSelection: TDeleteSelection;

implementation

{$R *.dfm}

uses Nemp_RessourceStrings, Nemp_ConstantsAndTypes, NempMainUnit, BibHelper, TreeHelper, Nemp_SkinSystem, NempFileUtils;


procedure TDeleteSelection.FormCreate(Sender: TObject);
var filename: String;
begin
    TranslateComponent (self);
    HelpContext := HELP_CleanupLibrary;

    VSTPlaylistFiles.NodeDataSize  := SizeOf(TLibraryPlaylist);
    VSTFiles.NodeDataSize  := SizeOf(TAudioFile);
    VSTDrives.NodeDataSize := SizeOf(TDeleteData);

    ReloadScheckBoxImages(NempSkin.isActive);
end;

function AddVSTDrive(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aDeleteData: TDeleteData): PVirtualNode;
begin
  Result:= AVST.AddChild(Nil, aDeleteData);
  Result.CheckType := ctCheckbox;
  if aDeleteData.DoDelete then
    Result.CheckState := csCheckedNormal
  else
    Result.CheckState := csUnCheckedNormal;

  AVST.ValidateNode(Result,false);
end;


procedure TDeleteSelection.FormShow(Sender: TObject);
var i: Integer;
begin
    lblMainExplanation.Caption := DeleteHelper_Explanation;

    VSTDrives.Clear;
    VSTDrives.BeginUpdate;
    if assigned(DataFromMedienBib) then
    begin
        for i := 0 to DataFromMedienBib.Count - 1 do
          AddVSTDrive(VSTDrives, Nil, TDeleteData(DataFromMedienBib[i]));
    end;
    VSTDrives.EndUpdate;

    VSTDrivesChange(VSTDrives, VSTDrives.GetFirst);
end;


procedure TDeleteSelection.ReloadScheckBoxImages(UseSkin: Boolean);
var
  i: Integer;
begin
    checkImages.Clear;

    if UseSkin then
      checkImages.ImageCollection := DataModuleGui.ICSkinIcons
    else
      checkImages.ImageCollection := DataModuleGui.ICIcons;

    // index 0..7: Unused
    // 8: normal
    // 9: hot
    //10: pressed
    //11: disabled
    for i := 0 to 11 do
      checkImages.Add(i.ToString, cTreeCleanUnChecked);
    // index 16..23: Unused
    for i := 12 to 23 do
      checkImages.Add(i.ToString, cTreeCleanChecked);

    VSTDrives.CustomCheckImages := checkImages;
    VSTDrives.CheckImageKind := ckCustom;
end;

procedure TDeleteSelection.VSTDrivesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  currentData: TDeleteData;
  aType, imgName: String;
begin
    currentData := Sender.GetNodeData<TDeleteData>(Node);
    if not assigned(currentData) then
    begin
        LblExplaination.Caption := '' ;
        LblWhatToDo.Caption := '';
        FillTreeViews(Nil);
        exit;
    end;

    FillTreeViews(currentData);

    if Node.CheckState = csCheckedNormal then
        LblFiles.Caption := DeleteSelect_FilesWillBeDeleted
    else
        LblFiles.Caption := DeleteSelect_FilesWillRemain;

    aType := TDeleteData(DataFromMedienBib[Node.Index]).DriveType;
    imgName := 'imgHDD';
    if aType = DriveTypeTexts[DRIVE_REMOVABLE] then
      imgName := 'imgUSB'
    else
      if aType = DriveTypeTexts[DRIVE_REMOTE] then
        imgName := 'imgNetwork'
      else
        if aType = DriveTypeTexts[DRIVE_CDROM] then
          imgName := 'imgCD';


    case currentData.Hint of
        dh_DivePresent    : begin
                      imgName := imgName + 'Mount';
                      LblExplaination.Caption  := DeleteHelper_DrivePresent  ;
                      LblExplaination2.Caption := DeleteHelper_DrivePresentFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithDrivePresent;
        end;
        dh_DriveMissing   : begin
                      imgName := imgName + 'Unmount';
                      LblExplaination.Caption  := DeleteHelper_DriveMissing    ;
                      LblExplaination2.Caption := '';//DeleteHelper_DriveMissingFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithDriveMissing;
        end;
        dh_NetworkPresent : begin
                      imgName := imgName + 'Mount';
                      LblExplaination.Caption  := DeleteHelper_NetworkPresent  ;
                      LblExplaination2.Caption := DeleteHelper_DrivePresentFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithNetworkPresent;
        end;
        dh_NetworkMissing : begin
                      imgName := imgName + 'Unmount';
                      LblExplaination.Caption  := DeleteHelper_NetworkMissing  ;
                      LblExplaination2.Caption := '';//DeleteHelper_DriveMissingFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithNetworkMissing;
        end;
    end;

    DriveImage.ImageName := imgName;
end;

procedure TDeleteSelection.VSTDrivesChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  currentData: TDeleteData;
begin
    currentData := Sender.GetNodeData<TDeleteData>(Node);
    currentData.DoDelete := (Node.CheckState = csCheckedNormal);
    // Refresh View
    VSTDrivesChange(Sender, Node);
end;

procedure TDeleteSelection.VSTDrivesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: TDeleteData;
begin
    Data := Sender.GetNodeData<TDeleteData>(Node);
    if not assigned(Data) then exit;
    case Column of
        0: cellText := Data.DriveString;
    end;
end;

procedure TDeleteSelection.VSTFilesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var af: TAudioFile;
begin
    af := Sender.GetNodeData<TAudioFile>(Node);
    case Column of
        0: cellText := af.Pfad;
    end;
end;

procedure TDeleteSelection.VSTPlaylistFilesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var pl: TLibraryPlaylist;
begin
    pl := Sender.GetNodeData<TLibraryPlaylist>(Node);
    if assigned(pl) then
      CellText := pl.Path;
end;

procedure TDeleteSelection.BtnHelpClick(Sender: TObject);
begin
  Application.HelpContext(HELP_CleanupLibrary);
end;

procedure TDeleteSelection.FillTreeViews(currentData: TDeleteData);
var i: Integer;
begin
    VSTFiles.Clear;
    VSTPlaylistFiles.Clear;

    if assigned(currentData) then
    begin
        // Fill Audio Files
        VSTFiles.Clear;
        VSTFiles.BeginUpdate;
        for i := 0 to currentData.Files.Count-1 do
            VSTFiles.AddChild(Nil, currentData.Files.Items[i]);
        VSTFiles.EndUpdate;

        // Fill Playlist Files
        VSTPlaylistFiles.BeginUpdate;
        for i := 0 to currentData.PlaylistFiles.Count-1 do
          VSTPlaylistFiles.AddChild(Nil, currentData.PlaylistFiles[i]);
        VSTPlaylistFiles.EndUpdate;
    end;
end;

procedure TDeleteSelection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    // delete Reference - it will be invalid after closing the form
    DataFromMedienBib := Nil;
end;


end.
