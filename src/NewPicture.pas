{

    Unit NewPicture
    Form FNewPicture

    Used for adding a Picture-Frame to the ID3Tag of a MP3-File.
    The User can select Picture, Type and Description for the new frame.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2024, Daniel Gaussmann
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
unit NewPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,  id3v2Frames, ExtDlgs, JPEG,
  PNGImage, gnuGettext,  CoverHelper,  M4aAtoms,
  AudioFiles.Base, AudioFiles.BaseTags, AudioFiles.Declarations,
  Nemp_RessourceStrings, System.UITypes;

type
  TFNewPicture = class(TForm)
    Image1: TImage;
    cbPictureType: TComboBox;
    LblConst_PictureType: TLabel;
    LblConst_PictureDescription: TLabel;
    EdtPictureDescription: TEdit;
    PnlWarnung: TPanel;
    Image2: TImage;
    Lbl_Warnings: TLabel;
    Btn_ChoosePicture: TButton;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    pnlButtons: TPanel;
    EdtFilename: TEdit;
    LblConst_PictureFilename: TLabel;
    pnlMain: TPanel;
    grpData: TGroupBox;
    grpPreview: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure Btn_ChoosePictureClick(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);

    function CheckDescription:boolean;
    procedure FormShow(Sender: TObject);
    procedure EdtPictureDescriptionChange(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure EdtFilenameExit(Sender: TObject);
    procedure EdtFilenameEnter(Sender: TObject);
  private
    { Private-Deklarationen }
    fCurrentTagObject: TBaseAudioFile;
    fValidFileSelected: Boolean;
    fLastCheckedFilename: String;
    procedure UpdateWarning;
    procedure SelectImage;
    procedure PreviewPicture(aFilename: String);
  public
    { Public-Deklarationen }

    property CurrentTagObject: TBaseAudioFile read fCurrentTagObject write fCurrentTagObject;
  end;

var
  FNewPicture: TFNewPicture;

implementation

uses
  Mp3Files;

{$R *.dfm}

procedure TFNewPicture.FormCreate(Sender: TObject);
var
  i: TPictureType;
begin
  TranslateComponent(self);
  for i := Low(cPictureTypes) to High(cPictureTypes) do
    cbPicturetype.Items.Add(cPictureTypes[i]);
  cbPictureType.ItemIndex := 3;
  fValidFileSelected := False;
end;

procedure TFNewPicture.FormShow(Sender: TObject);
begin
  //cbPictureType.ItemIndex := 3;
  //fValidFileSelected := False;
  //EdtPictureDescription.Text := '';
  // Image1.Picture.Bitmap.Assign(NIL);
  // Image1.Visible := False;
  //Btn_OK.Enabled := False;
  // (do NOT reset the GUI on the next "Show")
  UpdateWarning;
end;

function TFNewPicture.CheckDescription:boolean;
begin
  case CurrentTagObject.FileType of
    at_mp3: result := TMP3File(CurrentTagObject).ID3v2Tag.ValidNewPictureFrame(EdtPictureDescription.Text);
    at_Flac,
    at_Ogg,
    at_Opus,
    at_M4a,
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: result := True;
  else
    result := False;
  end;
end;

procedure TFNewPicture.EdtFilenameEnter(Sender: TObject);
begin
  fLastCheckedFilename := EdtFilename.Text;
end;

procedure TFNewPicture.EdtFilenameExit(Sender: TObject);
begin
  if FileExists(EdtFilename.Text) then
    PreviewPicture(EdtFilename.Text)
  else
    EdtFilename.Text := fLastCheckedFilename;
end;

procedure TFNewPicture.EdtPictureDescriptionChange(Sender: TObject);
begin
  UpdateWarning;
end;

procedure TFNewPicture.UpdateWarning;
begin
  if CheckDescription then begin
    Btn_OK.Enabled := fValidFileSelected;
    PnlWarnung.Visible := False;
  end else begin
    Btn_OK.Enabled := False;
    Lbl_Warnings.Caption := DetailForm_DuplicatePictureDescription;
    PnlWarnung.Visible := True;
  end;
end;

procedure TFNewPicture.PreviewPicture(aFilename: String);
begin
  try
    EdtFilename.Text := aFileName;
    Image1.Picture.LoadFromFile(aFileName);
    fValidFileSelected := True;
    UpdateWarning;
  except
    Image1.Picture.Bitmap.Assign(NIL);
    fValidFileSelected := False;
    Btn_OK.Enabled := False;
  end;
end;

procedure TFNewPicture.SelectImage;
begin
  if OpenPictureDialog1.Execute then
    PreviewPicture(OpenPictureDialog1.FileName);
end;

procedure TFNewPicture.Btn_ChoosePictureClick(Sender: TObject);
begin
  SelectImage;
end;

procedure TFNewPicture.Image1DblClick(Sender: TObject);
begin
  SelectImage;
end;

procedure TFNewPicture.Btn_OKClick(Sender: TObject);
var
  str: TFilestream;
  mime: AnsiString;
begin
  try
    str := TFilestream.Create(EdtFilename.Text, fmOpenread);
    try
      if (AnsiLowerCase(ExtractFileExt(EdtFilename.Text))='.png') then
        mime := AWB_MimePNG // AnsiString('image/png');
      else
        mime := AWB_MimeJpeg; //AnsiString('image/jpeg');

      CurrentTagObject.SetPicture(str, mime, TPictureType(cbPicturetype.Itemindex), EdtPictureDescription.Text);
    finally
      str.Free;
    end;
  except
    on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
  end;
  ModalResult := MROK;
end;

end.
