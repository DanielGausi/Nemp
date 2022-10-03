{

    Unit BaseForms

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
unit BaseForms;

interface

uses Windows, Messages, Graphics, Forms, Classes, Controls, WinApi.ShellApi,
Nemp_ConstantsAndTypes ;


  type

    TNempForm = class(TForm)
      public
        NempRegionsDistance: TNempRegionsDistance;
    end;

    TNempCustomMainForm = class(TNempForm)
      public
        procedure SaveWindowPosition(aMode: Integer);
        procedure LoadWindowPosition;
    end;

    TNempSubForm = class(TNempForm)
      private

      protected
        fNempFormID: TENempFormIDs;
        MainForm: TNempForm;
        DownX: Integer;
        DownY: Integer;
        BLeft: Integer;
        BTop: Integer;
        BWidth: Integer;
        BHeight: Integer;

        procedure CreateParams(var Params: TCreateParams); override;

      public
        procedure InitForm(aID: TENempFormIDs; aMainForm: TNempForm);
        procedure SaveWindowPosition;
        procedure LoadWindowPosition;
        procedure DoFormResize;
    end;

implementation

uses gnuGettext;

{ TNempSubForm }

procedure TNempSubForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := Application.Handle;
end;

procedure TNempSubForm.DoFormResize;
begin
  if assigned(OnResize) then
    OnResize(self);
end;

procedure TNempSubForm.InitForm(aID: TENempFormIDs; aMainForm: TNempForm);
begin
  TranslateComponent (self);
  DragAcceptFiles (Handle, True);

  fNempFormID := aID;
  MainForm := aMainForm;

  LoadWindowPosition;

  Top     := NempOptions.FormPositions[fNempFormID].Top;
  Left    := NempOptions.FormPositions[fNempFormID].Left;
  Height  := NempOptions.FormPositions[fNempFormID].Height;
  Width   := NempOptions.FormPositions[fNempFormID].Width;

  BTop    := NempOptions.FormPositions[fNempFormID].Top;
  BLeft   := NempOptions.FormPositions[fNempFormID].Left;
  BHeight := NempOptions.FormPositions[fNempFormID].Height;
  BWidth  := NempOptions.FormPositions[fNempFormID].Width;

  NempRegionsDistance.docked := NempOptions.FormPositions[fNempFormID].Docked;

  NempRegionsDistance.RelativPositionX := Left - NempOptions.FormPositions[nfMainMini].Left;
  NempRegionsDistance.RelativPositionY := Top - NempOptions.FormPositions[nfMainMini].Top;

  Caption := NEMP_CAPTION;
end;

procedure TNempSubForm.LoadWindowPosition;
var rawIniString: String;
begin
  rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[fNempFormID].Key, '');
  NempOptions.FormPositions[fNempFormID].GetDataFromString(rawIniString);
end;

procedure TNempSubForm.SaveWindowPosition;
begin
  // Copy Data into the Settings-Object
  NempOptions.FormPositions[fNempFormID].Top     := Top;
  NempOptions.FormPositions[fNempFormID].Left    := Left;
  NempOptions.FormPositions[fNempFormID].Width   := Width;
  NempOptions.FormPositions[fNempFormID].Height  := Height;
  NempOptions.FormPositions[fNempFormID].Docked  := NempRegionsDistance.docked ;
  // store settings in the SettingsManager
  NempSettingsManager.WriteString('NempForms', cDefaultWindowData[fNempFormID].Key,
      NempOptions.FormPositions[fNempFormID].SetDataToString );
end;

{ TNempCustomMainForm }

procedure TNempCustomMainForm.LoadWindowPosition;
var rawIniString: String;
begin
    rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[nfMain].Key, '');
    NempOptions.FormPositions[nfMain].GetDataFromString(rawIniString);
    rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[nfMainMini].Key, '');
    NempOptions.FormPositions[nfMainMini].GetDataFromString(rawIniString);
    NempOptions.MainFormMaximized := NempSettingsManager.ReadBool('NempForms', 'MainFormMaximized' , False);
end;

procedure TNempCustomMainForm.SaveWindowPosition(aMode: Integer);
var aFormID: TENempFormIDs;
begin
  case aMode of
    0: aFormID := nfMain;
    1: aFormID := nfMainMini;
  else
    aFormID := nfMain;
  end;

  NempOptions.FormPositions[aFormID].Top     := Top;
  NempOptions.FormPositions[aFormID].Left    := Left;
  NempOptions.FormPositions[aFormID].Width   := Width;
  NempOptions.FormPositions[aFormID].Height  := Height;

  NempSettingsManager.WriteString('NempForms', cDefaultWindowData[aFormID].Key,
      NempOptions.FormPositions[aFormID].SetDataToString );

  if aMode = 0 then
    NempSettingsManager.WriteBool('NempForms', 'MainFormMaximized' , NempOptions.MainFormMaximized);

end;

end.
