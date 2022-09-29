{

    Unit NewPicture
    Form FNewPicture

    Used for adding a Picture-Frame to the ID3Tag of a MP3-File.
    The User can select Picture, Type and Description for the new frame.

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
unit NewPicture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,  id3v2Frames, ExtDlgs, JPEG,
  PNGImage, gnuGettext,  CoverHelper,  M4aAtoms, AudioFiles.Base,
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
    procedure FormCreate(Sender: TObject);
    procedure Btn_ChoosePictureClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);

    function CheckDescription:boolean;
    procedure FormShow(Sender: TObject);
    procedure EdtPictureDescriptionChange(Sender: TObject);
  private
    { Private-Deklarationen }
    fCurrentTagObject: TBaseAudioFile;
    procedure UpdateWarning;
  public
    { Public-Deklarationen }

    property CurrentTagObject: TBaseAudioFile read fCurrentTagObject write fCurrentTagObject;
  end;

var
  FNewPicture: TFNewPicture;

const picKeys: Array [0..20] of String =
      ( 'Cover Art (other)',
        'Cover Art (icon)',
        'Cover Art (other icon)',
        'Cover Art (front)',
        'Cover Art (back)',
        'Cover Art (leaflet)',
        'Cover Art (media)',
        'Cover Art (lead)',
        'Cover Art (artist)',
        'Cover Art (conductor)',
        'Cover Art (band)',
        'Cover Art (composer)',
        'Cover Art (lyricist)',
        'Cover Art (studio)',
        'Cover Art (recording)',
        'Cover Art (performance)',
        'Cover Art (movie scene)',
        'Cover Art (colored fish)',
        'Cover Art (illustration)',
        'Cover Art (band logo)',
        'Cover Art (publisher logo)'
      );

implementation

uses AudioFiles.Declarations, Mp3Files, FlacFiles,
  M4AFiles, BaseApeFiles;

{$R *.dfm}

procedure TFNewPicture.FormCreate(Sender: TObject);
var i:integer;
begin
    TranslateComponent (self);
    for i := 0 to 20 do
        cbPicturetype.Items.Add(picKeys[i]);
    cbPictureType.ItemIndex := 0;
end;

procedure TFNewPicture.FormShow(Sender: TObject);
begin
    cbPictureType.ItemIndex := 0;
    EdtPictureDescription.Text := '';
    Image1.Picture.Bitmap.Assign(NIL);
    Image1.Visible := False;
    Btn_OK.Enabled := False;
    UpdateWarning;
end;


function TFNewPicture.CheckDescription:boolean;
begin
    case CurrentTagObject.FileType of
        at_mp3: result := TMP3File(CurrentTagObject).ID3v2Tag.ValidNewPictureFrame(EdtPictureDescription.Text);
        at_Flac: result := True;
        at_M4a: result := True;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: result := True;
    else
        result := False;
    end;
end;

procedure TFNewPicture.EdtPictureDescriptionChange(Sender: TObject);
begin
    UpdateWarning;
end;

procedure TFNewPicture.UpdateWarning;
begin
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



procedure TFNewPicture.Btn_ChoosePictureClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
      try
          Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
          Image1.Visible := True;
          UpdateWarning;
       except
          Image1.Picture.Bitmap.Assign(NIL);
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
    m4aPictype: TM4APicTypes;
begin
  try
      str := TFilestream.Create(OpenPictureDialog1.FileName, fmOpenread);
      try
          if (AnsiLowerCase(ExtractFileExt(OpenPictureDialog1.FileName))='.png') then
          begin
              mime := AnsiString('image/png');
              m4aPictype := M4A_PNG;
          end
          else
          begin
              mime := AnsiString('image/jpeg');
              m4aPictype := M4A_JPG;
          end;

          case CurrentTagObject.FileType of
              at_mp3: TMp3File(CurrentTagObject).ID3v2Tag.SetPicture(mime,
                                       cbPicturetype.Itemindex,
                                       EdtPictureDescription.Text,
                                       str);

              at_Flac: TFlacFile(CurrentTagObject).AddPicture(str,
                                       cbPicturetype.Itemindex,
                                       mime,
                                       EdtPictureDescription.Text);

              at_M4a: TM4aFile(CurrentTagObject).SetPicture(str, m4aPictype);

              at_Monkey,
              at_WavPack,
              at_MusePack,
              at_OptimFrog,
              at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.SetPicture(
                                      AnsiString(cbPictureType.Text),
                                      EdtPictureDescription.Text,
                                      str) ;
          end;
      finally
          str.Free;
      end;
  except
      on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
  end;
  ModalResult := MROK;
end;

end.
