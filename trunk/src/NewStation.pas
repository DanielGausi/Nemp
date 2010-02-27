{

    Unit NewStation
    Form NewStationForm

    Used for adding a new Station to the Favourite-list in Form StreamVerwaltung

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
        - FSPro Windows 7 Taskbar Components
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
unit NewStation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, gnuGettext;

type
  TNewStationForm = class(TForm)
    GrpBox_NewStation: TGroupBox;
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    LblConst_Name: TLabel;
    Edt_Name: TEdit;
    LblConst_URL: TLabel;
    Edt_URL: TEdit;
    LblConst_Format: TLabel;
    CB_Mediatype: TComboBox;
    CB_Bitrate: TComboBox;
    LblConst_Bitrate: TLabel;
    LblConst_Genre: TLabel;
    Edt_Genre: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtChange(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateButtonStatus;
  public
    { Public-Deklarationen }
  end;

var
  NewStationForm: TNewStationForm;

implementation

{$R *.dfm}

procedure TNewStationForm.FormCreate(Sender: TObject);
begin
    TranslateComponent (self);
    CB_Bitrate.ItemIndex := 11;
    CB_Mediatype.ItemIndex := 0;
end;

procedure TNewStationForm.UpdateButtonStatus;
begin
    Btn_OK.Enabled := (Trim(Edt_Name.Text) <> '') and (Trim(Edt_URL.Text) <> '')
end;

procedure TNewStationForm.FormShow(Sender: TObject);
begin
  UpdateButtonStatus;
end;

procedure TNewStationForm.EdtChange(Sender: TObject);
begin
  UpdateButtonStatus;
end;

end.
