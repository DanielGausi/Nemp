{

    Unit NewMetaFrame

    - Dialog to add a new Frame to the MetaData of a File

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

unit NewMetaFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NempAudioFiles,
  AudioFiles.Base, AudioFiles.Declarations, AudioFiles.BaseTags,
  Mp3Files, FlacFiles, OggVorbisFiles, M4AFiles, BaseApeFiles, ID3v2Tags, Apev2Tags,
  ID3v2Frames, M4aAtoms, Vcl.ExtCtrls;

type
  TNewMetaFrameForm = class(TForm)
    cbFrameType: TComboBox;
    lbl_FrameType: TLabel;
    lbl_FrameValue: TLabel;
    edt_FrameValue: TEdit;
    pnlButtons: TPanel;
    Btn_Cancel: TButton;
    Btn_OK: TButton;
    pnlMeta: TPanel;
    cbTagTypeSelection: TComboBox;
    pnlData: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);

    procedure cbTagTypeSelectionChange(Sender: TObject);
  private
    { Private declarations }

    fCurrentTagObject: TBaseAudioFile;
    fAvailableTagItems: TTagItemInfoDynArray;

    function PrepareFrameSelection(aFileType: TAudioFileType; aTagType: teTagType): Integer;
    procedure SetAllowedTags(Tags: TTagTypes);
    procedure SetCurrentTagObject(Value: TBaseAudioFile);
    function GetSelectedTagType: teTagType;
    function GetAvalailableFrameCount: Integer;

    property AllowedTags: TTagTypes write SetAllowedTags;

  public
    { Public declarations }

    // The Tag-Object currently displayed in FormDetails
    property CurrentTagObject: TBaseAudioFile read fCurrentTagObject write SetCurrentTagObject;
    property SelectedTagType: teTagType read GetSelectedTagType;
    property AvalailableFrameCount: Integer read GetAvalailableFrameCount;

  end;

var
  NewMetaFrameForm: TNewMetaFrameForm;

implementation

uses gnugettext, Nemp_RessourceStrings, MyDialogs;

{$R *.dfm}

procedure TNewMetaFrameForm.FormCreate(Sender: TObject);
begin
  //BackupComboboxes(self);
  TranslateComponent (self);
  //RestoreComboboxes(self);
end;

procedure TNewMetaFrameForm.SetCurrentTagObject(Value: TBaseAudioFile);
begin
  fCurrentTagObject := Value;

  case fCurrentTagObject.FileType of
    at_Invalid: ;
    at_Mp3: begin
        if TMp3File(fCurrentTagObject).ApeTag.ContainsData then
          AllowedTags := [ttID3v2, ttApev2]
        else
          AllowedTags := [ttID3v2];
    end;
    at_Ogg,
    at_Opus,
    at_Flac: AllowedTags := [ttVorbis];
    at_M4A: AllowedTags := [ttM4AAtom];
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: AllowedTags := [ttApev2];
    at_Wma: ;
    at_Wav: ;
    at_AbstractApe: ;
  end;
end;

procedure TNewMetaFrameForm.SetAllowedTags(Tags: TTagTypes);
var
  iTag: teTagType;
begin
  cbTagTypeSelection.Clear;
  for iTag in Tags do
    cbTagTypeSelection.Items.AddObject(cTagTypes[iTag], TObject(iTag));

  cbTagTypeSelection.ItemIndex := 0;
  cbTagTypeSelection.Visible := cbTagTypeSelection.Items.Count > 1;
  PrepareFrameSelection(CurrentTagObject.FileType, SelectedTagType);
end;

function TNewMetaFrameForm.GetAvalailableFrameCount: Integer;
begin
  result := cbFrameType.Items.Count;
end;

function TNewMetaFrameForm.GetSelectedTagType: teTagType;
begin
  result := teTagType(cbTagTypeSelection.Items.Objects[cbTagTypeSelection.ItemIndex]);
end;

procedure TNewMetaFrameForm.cbTagTypeSelectionChange(Sender: TObject);
begin
  PrepareFrameSelection(CurrentTagObject.FileType, SelectedTagType);
end;

function TNewMetaFrameForm.PrepareFrameSelection(aFileType: TAudioFileType; aTagType: teTagType): Integer;
var
  i: Integer;
begin
  cbFrameType.clear;

  if (aFileType = at_Mp3) and (aTagType = ttApev2) then // Special case: APEv2Tags in a mp3file
    fAvailableTagItems := TMp3File(CurrentTagObject).ApeTag.GetUnusedTextTags
  else
    fAvailableTagItems := CurrentTagObject.GetUnusedTextTags;

  // Fill ComboBox with these Items
  for i := Low(fAvailableTagItems) to High(fAvailableTagItems) do begin
    if fAvailableTagItems[i].Description <> '' then
      cbFrameType.Items.Add(_(fAvailableTagItems[i].Description) + ' (' + fAvailableTagItems[i].Key + ')')
    else
      cbFrameType.Items.Add(fAvailableTagItems[i].Key);
  end;

  // adjust GUI
  result := cbFrameType.Items.Count;
  if result > 0 then
    cbFrameType.ItemIndex := 0;
    
  Btn_OK.Enabled := result > 0;
  // clear value-Edit
  edt_FrameValue.Text := '';
end;


procedure TNewMetaFrameForm.BtnOKClick(Sender: TObject);
begin
  if Trim(edt_FrameValue.Text) = '' then begin
    TranslateMessageDLG((DetailForm_NewFrameEmptyValue), mtInformation, [MBOK], 0);
    exit;
  end;


  if (CurrentTagObject.FileType = at_Mp3) and (SelectedTagType = ttApev2) then begin // Special case: APEv2Tags in a mp3file
    TMP3File(CurrentTagObject).ApeTag.SetValueByKey(
          AnsiString(fAvailableTagItems[cbFrameType.ItemIndex].Key),
          edt_FrameValue.Text);
  end
  else begin
    CurrentTagObject.AddTextTagItem(
          fAvailableTagItems[cbFrameType.ItemIndex].Key,
          edt_FrameValue.Text);
  end;

  ModalResult := MROK;
end;


end.
