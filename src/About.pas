{

    Unit About
    Form AboutForm

    A simple form displaying copyright notices

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


unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, jpeg, ExtCtrls, StdCtrls, ShellApi, Nemp_ConstantsAndTypes, gnuGettext,
  Nemp_RessourceStrings, Credits, ImgList, System.ImageList,System.UITypes;

type
  TAboutForm = class(TForm)
    BtnOK: TButton;
    NempCredits: TACredits;
    ImageList1: TImageList;
    BtnDonate: TButton;

    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure NempCreditsAnchorClicked(Sender: TObject; Anchor: String);
    procedure BtnDonateClick(Sender: TObject);
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

procedure TAboutForm.BtnDonateClick(Sender: TObject);
begin
ShellExecute(Handle, 'open'
                      ,PChar('https://www.gausi.de/spenden.html')
                      , nil, nil, SW_SHOWNORMAl);
end;

procedure TAboutForm.BtnOKClick(Sender: TObject);
begin
  modalResult := mrOK;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
var filename: String;
    tmpbmp: TBitmap;
begin
    filename := ExtractFilePath(ParamStr(0)) + 'Images\about_title.bmp';
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

   NempCredits.Credits.Insert(3, 'Version ' + GetFileVersionString(''));// + ' (Release Candidate)');
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
      if NOT FileExists(ExtractFilePath(Paramstr(0)) + 'gpl.txt') then
        MessageDLG((Error_LGPLFileNotFound), mtError, [mbOK], 0)
      else
        ShellExecute(Handle, 'open'
                      ,PChar(ExtractFilePath(Paramstr(0)) + 'gpl.txt')
                      , nil, nil, SW_SHOWNORMAl);
  end;
end;


end.
