{

    Unit FPartyModeConfirmation

    - Confirmation Form to start the PartyMode.
      Also contains the settings.

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2025, Daniel Gaussmann
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

unit FPartyModeConfirmation;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.VirtualImage, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, NempControls.ExtCtrls;

type
  TFormPartyModeConfirmation = class(TForm)
    VirtualImage1: TVirtualImage;
    pnlButtons: TPanel;
    BtnCancel: TButton;
    BtnOK: TButton;
    LabelMessage1: TLabel;
    LabelMessage2: TLabel;
    GroupBoxSettings: TGroupBox;
    cb_PartyMode_BlockCurrentTitleRating: TCheckBox;
    cb_PartyMode_BlockTools: TCheckBox;
    cb_PartyMode_BlockTreeEdit: TCheckBox;
    CB_PartyMode_ResizeFactor: TLabeledComboBox;
    Edt_PartyModePassword: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
  private
    function GetBlockEditing: Boolean;
    function GetBlockRating: Boolean;
    function GetBlockTools: Boolean;
    function GetPassword: String;
    function GetScalingIndex: Integer;
    procedure SetBlockEditing(const Value: Boolean);
    procedure SetBlockRating(const Value: Boolean);
    procedure SetBlockTools(const Value: Boolean);
    procedure SetPassword(const Value: String);
    procedure SetScalingIndex(const Value: Integer);
    { Private declarations }
  public
    { Public declarations }
    property Password: String read GetPassword write SetPassword;
    property BlockRating: Boolean read GetBlockRating write SetBlockRating;
    property BlockEditing: Boolean read GetBlockEditing write SetBlockEditing;
    property BlockTools: Boolean read GetBlockTools write SetBlockTools;
    property ScalingIndex: Integer read GetScalingIndex write SetScalingIndex;
  end;

var
  FormPartyModeConfirmation: TFormPartyModeConfirmation;

implementation

uses
  gnuGettext, Hilfsfunktionen, Nemp_RessourceStrings;

{$R *.dfm}

procedure TFormPartyModeConfirmation.FormCreate(Sender: TObject);
begin
  BackUpComboBoxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);

  ClientHeight := pnlButtons.Top + pnlButtons.Height;
end;

function TFormPartyModeConfirmation.GetBlockEditing: Boolean;
begin
  result := cb_PartyMode_BlockTreeEdit.Checked;
end;

function TFormPartyModeConfirmation.GetBlockRating: Boolean;
begin
  result := cb_PartyMode_BlockCurrentTitleRating.Checked;
end;

function TFormPartyModeConfirmation.GetBlockTools: Boolean;
begin
  result := cb_PartyMode_BlockTools.Checked;
end;

function TFormPartyModeConfirmation.GetPassword: String;
begin
  result := Edt_PartyModePassword.Text;
end;

function TFormPartyModeConfirmation.GetScalingIndex: Integer;
begin
  result := CB_PartyMode_ResizeFactor.ItemIndex;
end;

procedure TFormPartyModeConfirmation.SetBlockEditing(const Value: Boolean);
begin
  cb_PartyMode_BlockTreeEdit.Checked := Value;
end;

procedure TFormPartyModeConfirmation.SetBlockRating(const Value: Boolean);
begin
  cb_PartyMode_BlockCurrentTitleRating.Checked := Value;
end;

procedure TFormPartyModeConfirmation.SetBlockTools(const Value: Boolean);
begin
  cb_PartyMode_BlockTools.Checked := Value;
end;

procedure TFormPartyModeConfirmation.SetPassword(const Value: String);
begin
  Edt_PartyModePassword.Text := Value;
end;

procedure TFormPartyModeConfirmation.SetScalingIndex(const Value: Integer);
begin
  CB_PartyMode_ResizeFactor.ItemIndex := Value;
end;

end.
