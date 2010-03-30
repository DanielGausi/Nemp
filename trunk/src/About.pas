{

    Unit About
    Form AboutForm

    A simple form displaying copyright notices

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


unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, jpeg, ExtCtrls, StdCtrls, ShellApi, Nemp_ConstantsAndTypes, gnuGettext,
  Nemp_RessourceStrings, Credits, ImgList;

type
  TAboutForm = class(TForm)
    BtnOK: TButton;
    NempCredits: TACredits;
    ImageList1: TImageList;

    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure NempCreditsAnchorClicked(Sender: TObject; Anchor: String);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  AboutForm: TAboutForm;

implementation

uses Systemhelper;

{$R *.dfm}

procedure TAboutForm.BtnOKClick(Sender: TObject);
begin
  modalResult := mrOK;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var filename: String;
    tmpbmp: TBitmap;
begin
    filename := ExtractFilePath(ParamStr(0)) + 'Data\img\about_title.bmp';
    if FileExists(filename) then
    begin
        tmpbmp := TBitmap.Create;
        try
            tmpbmp.LoadFromFile(filename);
            ImageList1.Add(tmpbmp, Nil);
        finally
            tmpbmp.Free;
        end;
    end;

   NempCredits.Credits.Insert(3, 'Version ' + GetFileVersionString('') + ' (2k9)');
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  NempCredits.Animate := True;
  NempCredits.Position := NempCredits.Height Div 2;
end;

procedure TAboutForm.FormHide(Sender: TObject);
begin
  NempCredits.Animate := False;
end;

procedure TAboutForm.NempCreditsAnchorClicked(Sender: TObject;
  Anchor: String);
begin
  if Anchor = 'gpl' then
  begin
      if NOT FileExists(ExtractFilePath(Paramstr(0)) + 'licence.txt') then
        MessageDLG((Error_LGPLFileNotFound), mtError, [mbOK], 0)
      else
        ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'licence.txt')
                      , nil, nil, SW_SHOWNORMAl);
  end;
end;


end.
