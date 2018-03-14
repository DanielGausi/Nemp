unit DeleteSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ContNrs, NempAudioFiles, DeleteHelper,
  DriveRepairTools, ExtCtrls, ImgList, GnuGetText;

type
  TDeleteSelection = class(TForm)
    MemoFiles: TMemo;
    cbDrives: TCheckListBox;
    LblDrives: TLabel;
    LblFiles: TLabel;
    BtnOk: TButton;
    Btncancel: TButton;
    BtnHelp: TButton;
    ImageList1: TImageList;
    DriveImage: TImage;
    LblExplaination: TLabel;
    LblWhatToDo: TLabel;
    LblExplaination2: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure cbDrivesClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    DataFromMedienBib: TObjectList;
    DriveData: TObjectList;
    DummyDrive: TDrive;
  end;

var
  DeleteSelection: TDeleteSelection;

implementation

{$R *.dfm}

uses Nemp_RessourceStrings, NempMainUnit, BibHelper;

procedure TDeleteSelection.FormShow(Sender: TObject);
var i: Integer;
    currentData: TDeleteData;
    Drives: TObjectList;
    aDrive: TDrive;
begin
    cbDrives.Clear;
    MemoFiles.Clear;
    DriveData.Clear;

    Drives := TObjectList.Create(True);
    try
        //GetLogicalDrives(Drives);

        if assigned(DataFromMedienBib) then
        begin
            for i := 0 to DataFromMedienBib.Count - 1 do
            begin
                currentData := TDeleteData(DataFromMedienBib[i]);
                if (length(currentData.DriveString) > 0)
                and (currentData.DriveString[1] <> '\') then
                begin
                    aDrive := MedienBib.GetDriveFromUsedDrives(currentData.DriveString[1]);
                    if assigned(aDrive) then
                    begin
                        cbDrives.Items.Add(Format('%s (%s)',[currentData.DriveString, aDrive.Name]));
                        DriveData.Add(aDrive);
                    end
                    else
                    begin
                        // should not happen at all
                        cbDrives.Items.Add(currentData.DriveString);
                        DriveData.Add(DummyDrive);
                    end;
                end else
                begin
                    cbDrives.Items.Add(currentData.DriveString);
                    DriveData.Add(DummyDrive);
                end;
                cbDrives.Checked[i] := currentData.DoDelete;
            end;

            if cbDrives.Count > 0 then
            begin
                cbDrives.ItemIndex := 0;
                cbDrives.Selected[0] := True;
                cbDrivesClick(Nil);
            end;
        end;
    finally
        Drives.Free;
    end;
end;


procedure TDeleteSelection.BtnHelpClick(Sender: TObject);
begin
    MessageDlg(DeleteHelper_Readme, mtInformation, [mbOK], 0);
end;

procedure TDeleteSelection.cbDrivesClick(Sender: TObject);
var currentData: TDeleteData;
    i: Integer;
    sl: Tstrings;
    imgidx: Integer;
    aType: String;
begin
    if cbDrives.ItemIndex >= 0 then
    begin
        currentData := TDeleteData(DataFromMedienBib[cbDrives.ItemIndex]);
        MemoFiles.Clear;

        sl := tStringList.Create;
        try
            for i := 0 to currentData.Files.Count - 1 do
                sl.Add(TAudioFile(currentData.Files[i]).Pfad);

            for i := 0 to currentData.PlaylistFiles.Count - 1 do
                sl.Add(TJustaString(currentData.PlaylistFiles[i]).AnzeigeString);

            MemoFiles.Lines.Assign(sl);
        finally
            sl.Free;
        end;

        imgidx := 0;

        aType := TDrive(DriveData[cbDrives.ItemIndex]).Typ;

        if aType = DriveTypeTexts[DRIVE_REMOVABLE] then
            imgidx := 2;
        if aType = DriveTypeTexts[DRIVE_REMOTE] then
            imgidx := 4;
        if aType = DriveTypeTexts[DRIVE_CDROM] then
            imgidx := 6;

        case currentData.Hint of
          dh_DivePresent: ;
          dh_DriveMissing: inc(imgIdx);
          dh_NetworkPresent: ;
          dh_NetworkMissing: inc(imgIdx);
        end;

        ImageList1.GetBitmap(imgIdx, DriveImage.Picture.Bitmap);
        DriveImage.Refresh;

        case currentData.Hint of
            dh_DivePresent    : begin
                          LblExplaination.Caption  := DeleteHelper_DrivePresent  ;
                          LblExplaination2.Caption := DeleteHelper_DrivePresentFileMissing;
                          LblWhatToDo.Caption      := DeleteHelper_DoWithDrivePresent;
            end;
            dh_DriveMissing   : begin
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
                          LblExplaination.Caption  := DeleteHelper_NetworkMissing  ;
                          LblExplaination2.Caption := '';//DeleteHelper_DriveMissingFileMissing;
                          LblWhatToDo.Caption      := DeleteHelper_DoWithNetworkMissing;
            end;
        end;
    end else
    begin
        MemoFiles.Clear;
        LblExplaination.Caption := '' ;
        LblWhatToDo.Caption := '';

    end;
end;

procedure TDeleteSelection.FormClose(Sender: TObject; var Action: TCloseAction);
var i: Integer;
    currentData: TDeleteData;
begin
    if assigned(DataFromMedienBib) then
    begin
        for i := 0 to DataFromMedienBib.Count - 1 do
        begin
            currentData := TDeleteData(DataFromMedienBib[i]);
            currentData.DoDelete := cbDrives.Checked[i];
        end;
    end;

    // delete Reference - it will be invalid after closing the form
    DataFromMedienBib := Nil;
end;



procedure TDeleteSelection.FormCreate(Sender: TObject);
begin
    TranslateComponent (self);
    DriveData := TObjectList.Create(False);
    DummyDrive := TDrive.Create;
    DummyDrive.Typ := DriveTypeTexts[DRIVE_REMOTE];
end;

procedure TDeleteSelection.FormDestroy(Sender: TObject);
begin
    DriveData.Free;
    DummyDrive.Free;
end;

end.
