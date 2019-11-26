{

    Unit BirthdayShow
    Form TBirthdayForm

    Little form showing on "Birthday"

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

unit BirthdayShow;

interface

uses
  Windows, Messages, SysUtils,  Classes,  Forms,
  StdCtrls, Controls, gnuGettext, Vcl.ExtCtrls, Vcl.ComCtrls, NempTrackBar;

type
  TBirthdayForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    imgParty: TImage;
    BtnClose: TButton;
    tbVolume: TNempTrackBar;
    VolumeImage: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure tbVolumeChange(Sender: TObject);
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
var fn: String;
begin
    TranslateComponent (self);

    fn := ExtractFilePath(ParamStr(0)) + 'Images\congratulations.jpg';
    if FileExists(fn) then
        imgParty.Picture.LoadFromFile(fn);
end;

procedure TBirthdayForm.FormShow(Sender: TObject);
var fn: String;
begin
   SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);

   // default volume here: MainVolume
   tbVolume.Position := Round(NempPlayer.Volume);
   NempPlayer.BirthdayVolume := NempPlayer.Volume;

   if NempPlayer.NempBirthdayTimer.UseCountDown then
     NempPlayer.PlayCountDown
   else
     NempPlayer.PlayBirthday;

   if Nemp_MainForm.NempSkin.isActive then
   begin
      fn := IncludeTrailingPathDelimiter(Nemp_MainForm.NempSkin.Path) + 'VolumeBirthday.png';
      if not FileExists(fn) then fn := IncludeTrailingPathDelimiter(Nemp_MainForm.NempSkin.Path) + 'VolumeBirthday.jpg';
      if not FileExists(fn) then fn := IncludeTrailingPathDelimiter(Nemp_MainForm.NempSkin.Path) + 'Volume.png';
      if not FileExists(fn) then fn := IncludeTrailingPathDelimiter(Nemp_MainForm.NempSkin.Path) + 'Volume.jpg';
      if not FileExists(fn) then fn := ExtractFilePath(ParamStr(0)) + 'Images\Volume.png';
   end else
      fn := ExtractFilePath(ParamStr(0)) + 'Images\Volume.png';

    if FileExists(fn) then
        VolumeImage.Picture.LoadFromFile(fn);
end;

procedure TBirthdayForm.tbVolumeChange(Sender: TObject);
begin
    NempPlayer.BirthdayVolume := tbVolume.Position;
end;

procedure TBirthdayForm.BtnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TBirthdayForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  NempPlayer.AbortBirthday;
  ReArrangeToolImages;
end;


end.
