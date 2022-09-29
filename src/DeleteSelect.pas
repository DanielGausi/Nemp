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
  System.ImageList, Generics.Collections, VirtualTrees, PNGImage,CommCtrl ;


type
    TDeleteTreeData = record
        fDeleteData : TDeleteData;
    end;
    PDeleteTreeData = ^TDeleteTreeData;

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
    DriveImage: TImage;
    LblExplaination: TLabel;
    LblWhatToDo: TLabel;
    LblExplaination2: TLabel;
    ImageList1: TImageList;
    HintImage: TImage;
    VSTDrives: TVirtualStringTree;
    checkImages: TImageList;
    ImgHelp: TImage;
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
    procedure AddPngToImageList(aFilename: String; aImageList: TImageList);

  public
    { Public-Deklarationen }
    DataFromMedienBib: TObjectList;

    procedure ReloadScheckBoxImages(aBaseDir: String; TryDefaultAgain: Boolean=False);

  end;

var
  DeleteSelection: TDeleteSelection;

implementation

{$R *.dfm}

uses Nemp_RessourceStrings, NempMainUnit, BibHelper, TreeHelper, Nemp_SkinSystem, NempFileUtils;


procedure TDeleteSelection.FormCreate(Sender: TObject);
var filename: String;
begin
    TranslateComponent (self);
    HelpContext := HELP_CleanupLibrary;

    VSTPlaylistFiles.NodeDataSize  := SizeOf(TLibraryPlaylist);
    VSTFiles.NodeDataSize  := SizeOf(TAudioFile);
    VSTDrives.NodeDataSize := SizeOf(TDeleteTreeData);

    filename := ExtractFilePath(ParamStr(0)) + 'Images\alert.png';
    if FileExists(filename) then
        HintImage.Picture.LoadFromFile(filename);

    // Load CheckBoxImages for the DriveVST
    if Nemp_MainForm.NempSkin.IsACtive then
        self.ReloadScheckBoxImages(Nemp_MainForm.NempSkin.Path, True)
    else
        self.ReloadScheckBoxImages(ExtractFilePath(ParamStr(0)) + 'Images\');
end;

function AddVSTDrive(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aDeleteData: TDeleteData): PVirtualNode;
var Data: PDeleteTreeData;
begin
  Result:= AVST.AddChild(aNode); // meistens wohl Nil
  Data:=AVST.GetNodeData(Result);
  Data^.fDeleteData := aDeleteData;

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
        begin
            AddVSTDrive(VSTDrives, Nil, TDeleteData(DataFromMedienBib[i]));
        end;
    end;
    VSTDrives.EndUpdate;

    VSTDrivesChange(VSTDrives, VSTDrives.GetFirst);
end;


procedure TDeleteSelection.ReloadScheckBoxImages(aBaseDir: String; TryDefaultAgain: Boolean=False);
var filename: String;
    i: Integer;
    FileIsMissing: Boolean;
begin
    aBaseDir := IncludeTrailingPathDelimiter(aBaseDir);
    FileIsMissing := False;
    checkImages.Clear;

    // index 0..7: Unused
    // 8: normal
    // 9: hot
    //10: pressed
    //11: disabled
    filename := aBaseDir + 'cbClean-UnCheckNormal.png';
    if FileExists(filename) then
    begin
        for i := 0 to 11 do
          AddPngToImageList(filename, checkImages);
    end else
        FileIsMissing := True;

    // index 16..23: Unused
    filename := aBaseDir + 'cbClean-CheckNormal.png';
    if FileExists(filename) then
    begin
        for i := 12 to 23 do
          AddPngToImageList(filename, checkImages);
    end else
        FileIsMissing := True;

    if FileIsMissing and TryDefaultAgain then
    begin
        // if Skin doesn't support Checkimages: load default ones
        ReloadScheckBoxImages(ExtractFilePath(ParamStr(0)) + 'Images\', False);
        exit;
    end;

    // if still something is missing: Use System default CheckBoxes
    if FileIsMissing then
    begin
        VSTDrives.CustomCheckImages := Nil;
        VSTDrives.CheckImageKind := ckSystemDefault;
    end else
    begin
        // success, use custom Images
        VSTDrives.CustomCheckImages := checkImages;
        VSTDrives.CheckImageKind := ckCustom;
    end;
end;

procedure TDeleteSelection.VSTDrivesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var currentDataP: PDeleteTreeData;
    currentData: TDeleteData;
    imgidx: Integer;
    aType: String;
begin
    currentDataP := Sender.GetNodeData(Node);
    if not assigned(currentDataP) then
    begin
        LblExplaination.Caption := '' ;
        LblWhatToDo.Caption := '';
        FillTreeViews(Nil);
        exit;
    end;

    currentData := currentDataP^.fDeleteData;
    FillTreeViews(currentData);

    if Node.CheckState = csCheckedNormal then
        LblFiles.Caption := DeleteSelect_FilesWillBeDeleted
    else
        LblFiles.Caption := DeleteSelect_FilesWillRemain;

    imgidx := 0;
    aType := TDeleteData(DataFromMedienBib[Node.Index]).DriveType;
    if aType = DriveTypeTexts[DRIVE_REMOVABLE] then
        imgidx := 2;
    if aType = DriveTypeTexts[DRIVE_REMOTE] then
        imgidx := 4;
    if aType = DriveTypeTexts[DRIVE_CDROM] then
        imgidx := 6;

    case currentData.Hint of
        dh_DivePresent    : begin
                      LblExplaination.Caption  := DeleteHelper_DrivePresent  ;
                      LblExplaination2.Caption := DeleteHelper_DrivePresentFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithDrivePresent;
        end;
        dh_DriveMissing   : begin
                      inc(imgIdx);
                      LblExplaination.Caption  := DeleteHelper_DriveMissing    ;
                      LblExplaination2.Caption := '';//DeleteHelper_DriveMissingFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithDriveMissing;
        end;
        dh_NetworkPresent : begin
                      LblExplaination.Caption  := DeleteHelper_NetworkPresent  ;
                      LblExplaination2.Caption := DeleteHelper_DrivePresentFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithNetworkPresent;
        end;
        dh_NetworkMissing : begin
                      inc(imgIdx);
                      LblExplaination.Caption  := DeleteHelper_NetworkMissing  ;
                      LblExplaination2.Caption := '';//DeleteHelper_DriveMissingFileMissing;
                      LblWhatToDo.Caption      := DeleteHelper_DoWithNetworkMissing;
        end;
    end;

    ImageList1.GetBitmap(imgIdx, DriveImage.Picture.Bitmap);
    DriveImage.Refresh;
end;

procedure TDeleteSelection.VSTDrivesChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var currentDataP: PDeleteTreeData;
    currentData: TDeleteData;
begin
    currentDataP := Sender.GetNodeData(Node);
    currentData := currentDataP^.fDeleteData;

    currentData.DoDelete := (Node.CheckState = csCheckedNormal);

    // Refresh View
    VSTDrivesChange(Sender, Node);
end;

procedure TDeleteSelection.VSTDrivesGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PDeleteTreeData;
begin
    Data := Sender.GetNodeData(Node);
    if not assigned(Data) then exit;

    case Column of
        0: cellText := Data^.fDeleteData.DriveString;
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

procedure TDeleteSelection.AddPngToImageList(aFilename: String;
  aImageList: TImageList);
var pngbmp: TPngImage;
    bmp: TBitmap;
begin
  pngbmp := TPNGImage.Create;
  try
      pngbmp.LoadFromFile(aFilename);
      bmp := TBitmap.Create;
      try
          pngbmp.AssignTo(bmp);
          bmp.AlphaFormat:=afIgnored;
          aImageList.Add(bmp, Nil);
      finally
          bmp.Free;
      end;
  finally
      pngbmp.Free;
  end;
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
