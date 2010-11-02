{

    Unit NewPicture
    Form FNewPicture

    Used for adding a Picture-Frame to the ID3Tag of a MP3-File.
    The User can select Picture, Type and Description for the new frame.

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
unit NewPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mp3FileUtils, id3v2Frames, ExtDlgs, JPEG,
  PNGImage, GifImg, gnuGettext,  CoverHelper,
  Nemp_RessourceStrings;

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
    procedure FormCreate(Sender: TObject);
    procedure Btn_ChoosePictureClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);

    function CheckDescription:boolean;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FNewPicture: TFNewPicture;

implementation

uses Details;

{$R *.dfm}

procedure TFNewPicture.FormCreate(Sender: TObject);
var i:integer;
begin
  TranslateComponent (self);
  for i := 0 to 20 do
      cbPicturetype.Items.Add(Picture_Types[i]);
  cbPictureType.ItemIndex := 0;
end;

procedure TFNewPicture.FormShow(Sender: TObject);
begin
  cbPictureType.ItemIndex := 0;
  EdtPictureDescription.Text := '';
  Image1.Picture.Assign(NIL);
  Image1.Visible := False;
  Btn_OK.Enabled := False;
  if CheckDescription then
  begin
      Btn_OK.Enabled := Image1.Visible;
      PnlWarnung.Visible := False;
  end else
  begin
      Btn_OK.Enabled := False;
      PnlWarnung.Visible := True;
  end;
end;


function TFNewPicture.CheckDescription:boolean;
begin
  result := False;

  if FDetails.ValidMp3File then
      result := FDetails.ID3v2Tag.ValidNewPictureFrame(EdtPictureDescription.Text);

  if FDetails.ValidFlacFile then
      result := True; // No restrictions here
end;

procedure TFNewPicture.Btn_ChoosePictureClick(Sender: TObject);
var
    aStream: TFileStream;
begin
  if OpenPictureDialog1.Execute then
  begin
      try
          aStream := TFileStream.Create(OpenPictureDialog1.FileName, fmOpenRead or fmShareDenyWrite);
          try
              if (AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.png') then
                  PicStreamToImage(aStream, 'image/png', Image1.Picture.Bitmap)
              else
                  PicStreamToImage(aStream, 'image/jpeg', Image1.Picture.Bitmap);
          finally
              aStream.Free;
          end;
          Image1.Visible := True;

          if CheckDescription then
          begin
              Btn_OK.Enabled := Image1.Visible;
              PnlWarnung.Visible := False;
          end else
          begin
              Btn_OK.Enabled := False;
              PnlWarnung.Visible := True;
          end;
      except
          Image1.Picture.Assign(NIL);
          Image1.Visible := False;
          Btn_OK.Enabled := False;
      end;
  end;
end;

procedure TFNewPicture.Btn_CancelClick(Sender: TObject);
begin
    ModalResult := MRCANCEL;
end;

procedure TFNewPicture.Btn_OKClick(Sender: TObject);
var str: TFilestream;
    mime: AnsiString;
begin
  try
      str := TFilestream.Create(OpenPictureDialog1.FileName, fmOpenread);
      try
          if (AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.png') then
              mime := AnsiString('image/png')
          else
              mime := AnsiString('image/jpeg');

          if FDetails.ValidMp3File then
              FDetails.ID3v2Tag.SetPicture(mime,
                                       cbPicturetype.Itemindex,
                                       EdtPictureDescription.Text,
                                       str);

          if FDetails.ValidFlacFile then
              FDetails.FlacFile.AddPicture(str, cbPicturetype.Itemindex, mime, EdtPictureDescription.Text);
      finally
          str.Free;
      end;
  except
      on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
  end;
  ModalResult := MROK;
end;

end.
