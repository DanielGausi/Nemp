{

    Unit BirthdayShow
    Form TBirthdayForm

    Little form showing on "Birthday"

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

unit BirthdayShow;

interface

uses
  Windows, Messages, SysUtils,  Classes,  Forms,
  StdCtrls, Controls, gnuGettext;

type
  TBirthdayForm = class(TForm)
    Lbl_Congratulations: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }

  public
    { Public-Deklarationen }

  end;

var
  BirthdayForm: TBirthdayForm;

implementation

uses NempMainUnit, MainFormHelper;
{$R *.dfm}


procedure TBirthdayForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
end;

procedure TBirthdayForm.FormShow(Sender: TObject);
begin
   SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
   if NempPlayer.NempBirthdayTimer.UseCountDown then
     NempPlayer.PlayCountDown
   else
     NempPlayer.PlayBirthday;
end;

procedure TBirthdayForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  NempPlayer.AbortBirthday;
  ReArrangeToolImages;
end;


end.
