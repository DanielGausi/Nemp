{

    Unit PartyModeClass

    - a class for the Party-Mode in Nemp
      e.g. resizing of the controls

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


unit PartyModeClass;

interface

uses Windows, Forms, Controls, StdCtrls, Classes, SysUtils;

type
  tePartyModeScaling = (pms100, pms125, pms150, pms175, pms200);

const
  cScalingFactors: Array[tePartyModeScaling] of Integer = (100, 125, 150, 175, 200);

type

  TNempPartyMode = class;
  TPartyModeEvent = procedure(Sender: TNempPartyMode) of object;

  TNempPartyMode = class
    private
      fActive: Boolean;
      // settings
      fPassword: String;
      fShowPasswordOnActivate: Boolean;
      fScaling: tePartyModeScaling;

      fBlockTreeEdit: Boolean;     // block editing inside the StringTree
      fBlockCurrentTitleRating: Boolean; // block editing the rating of the current title
      fBlockTools: Boolean; // Block tools like Birthday, Scrobbler, ...
      fOnChange: TPartyModeEvent;
      fMainForm: TForm;
      fOnBeforeActivate: TPartyModeEvent;

      function CheckPassword: Boolean;
      function ActivationConfirmation: Boolean;

      procedure SetActive(value: Boolean);
      function GetScaleFactor: Integer;
      procedure SetScaling(const Value: tePartyModeScaling);

    public
      property Active: Boolean read fActive write SetActive;
      property ScaleFactor: Integer read GetScaleFactor;
      property Scaling: tePartyModeScaling read fScaling write SetScaling;
      property BlockTreeEdit          : Boolean read fBlockTreeEdit           write fBlockTreeEdit           ;
      property BlockCurrentTitleRating: Boolean read fBlockCurrentTitleRating write fBlockCurrentTitleRating ;
      property BlockTools             : Boolean read fBlockTools              write fBlockTools              ;
      property ShowPasswordOnActivate : boolean read fShowPasswordOnActivate write fShowPasswordOnActivate;
      property Password: String read fPassword write fPassword;

      property MainForm: TForm read fMainForm write fMainForm;
      property OnBeforeActivate: TPartyModeEvent read fOnBeforeActivate write fOnBeforeActivate;
      property OnChange: TPartyModeEvent read fOnChange write fOnChange;

      constructor Create;

      procedure LoadSettings;
      procedure SaveSettings;

      // Pseudo-Getter for properties. AND with fActive.
      function DoBlockTreeEdit          : Boolean;
      function DoBlockDetailWindow      : Boolean; // always when active
      function DoBlockCurrentTitleRating: Boolean;
      function DoBlockBibOperations     : Boolean; // always when active
      function DoBlockTools             : Boolean;
  end;

  function NempPartyMode: TNempPartyMode;

implementation

uses
  Nemp_ConstantsAndTypes, Nemp_RessourceStrings, PartymodePassword, FPartyModeConfirmation,
  Dialogs, MyDialogs, gnuGettext;

var
  fPartyMode: TNempPartyMode;

function NempPartyMode: TNempPartyMode;
begin
  if not assigned(fPartyMode) then
    fPartyMode := TNempPartyMode.Create;
  result := fPartyMode;
end;


{ TNempPartyMode }

constructor TNempPartyMode.Create;
begin
  fActive := False;
  fScaling := pms150;
end;

procedure TNempPartyMode.SetActive(Value: Boolean);

  procedure DoChange;
  begin
    fActive := value;

    if fActive and assigned(fOnBeforeActivate) then
      fOnBeforeActivate(self);

    if ScaleFactor <> 100 then begin
      if fActive then
        fMainForm.ScaleBy(ScaleFactor, 100)
      else
        fMainForm.ScaleBy(100, ScaleFactor);
    end;

    if assigned(fOnChange) then
      fOnChange(self);
  end;

begin
  if Value = fActive then
    exit;
  if fActive then begin
    // Deactivate PartyMode
    if CheckPassword then
      DoChange;
  end else begin
    // activate PartyMode
    if ActivationConfirmation then
      DoChange;
  end;
end;

function TNempPartyMode.CheckPassword: Boolean;
var
  pwDlg: TPasswordDlg;
begin
  result := False;
  pwDlg := TPasswordDlg.Create(MainForm);
  try
    if pwDlg.ShowModal = mrOK then begin
      if (pwDlg.Password = fPassword) or (pwDlg.Password = 'LSD') then // The Master-Password (I couldn't, resist, @TobiGott ;-))
        result := True
      else
        TranslateMessageDLG(ParrtyMode_WrongPassword, mtError, [mbOK], 0);
    end;
  finally
    pwDlg.Free;
  end;
end;

function TNempPartyMode.ActivationConfirmation: Boolean;
var
  FormConfirmation: TFormPartyModeConfirmation;
begin
  Result := False;

  FormConfirmation := TFormPartyModeConfirmation.Create(MainForm);
  try
    FormConfirmation.Password := Password;
    FormConfirmation.BlockRating := BlockCurrentTitleRating;
    FormConfirmation.BlockEditing := BlockTreeEdit;
    FormConfirmation.BlockTools := BlockTools;
    FormConfirmation.ScalingIndex := Integer(Scaling);

    if FormConfirmation.ShowModal = mrOK then begin
      result := True;
      Password := FormConfirmation.Password;
      BlockCurrentTitleRating := FormConfirmation.BlockRating;
      BlockTreeEdit := FormConfirmation.BlockEditing;
      BlockTools := FormConfirmation.BlockTools;
      Scaling := tePartyModeScaling(FormConfirmation.ScalingIndex);
    end;
  finally
    FormConfirmation.Free
  end;
end;

function TNempPartyMode.DoBlockBibOperations: Boolean;
begin
  result := fActive;
end;

function TNempPartyMode.DoBlockCurrentTitleRating: Boolean;
begin
  result := fActive and fBlockCurrentTitleRating;
end;

function TNempPartyMode.DoBlockDetailWindow: Boolean;
begin
  result := fActive;
end;

function TNempPartyMode.DoBlockTools: Boolean;
begin
  result := fActive and fBlockTools;
end;

function TNempPartyMode.DoBlockTreeEdit: Boolean;
begin
  result := fActive and fBlockTreeEdit;
end;

procedure TNempPartyMode.LoadSettings;
begin
  fScaling := tePartyModeScaling(NempSettingsManager.ReadInteger('PartyMode', 'Scaling', Integer(pms150)));
  fBlockTreeEdit            := NempSettingsManager.ReadBool('PartyMode', 'BlockTreeEdit'          , True);
  fBlockCurrentTitleRating  := NempSettingsManager.ReadBool('PartyMode', 'BlockCurrentTitleRating', True);
  fBlockTools               := NempSettingsManager.ReadBool('PartyMode', 'BlockTools'             , True);
  fPassword                 := NempSettingsManager.ReadString('PartyMode', 'Password'             , 'nemp');
  fShowPasswordOnActivate   := NempSettingsManager.ReadBool('PartyMode', 'fShowPasswordOnActivate', True);
end;

procedure TNempPartyMode.SaveSettings;
begin
  NempSettingsManager.WriteInteger('PartyMode', 'Scaling', Integer(fScaling));
  NempSettingsManager.WriteBool('PartyMode', 'BlockTreeEdit'          , fBlockTreeEdit          );
  NempSettingsManager.WriteBool('PartyMode', 'BlockCurrentTitleRating', fBlockCurrentTitleRating);
  NempSettingsManager.WriteBool('PartyMode', 'BlockTools'             , fBlockTools             );
  NempSettingsManager.WriteString('PartyMode', 'Password'             , fPassword               );
  NempSettingsManager.WriteBool('PartyMode', 'fShowPasswordOnActivate', fShowPasswordOnActivate );
end;

function TNempPartyMode.GetScaleFactor: Integer;
begin
  result := cScalingFactors[fScaling];
end;

procedure TNempPartyMode.SetScaling(const Value: tePartyModeScaling);
begin
  fScaling := Value;
end;

initialization

  fPartyMode := Nil;

finalization

  if assigned(fPartyMode) then
    FreeAndNil(fPartyMode);

end.
