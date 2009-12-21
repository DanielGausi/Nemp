{

    Unit Splash
    Form FSplash

    - Splashscreen showing on startup

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
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}
unit Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, Nemp_ConstantsAndTypes, gnuGettext, Nemp_RessourceStrings;

type
  TFSplash = class(TForm)
    Label2: TLabel;
    Image1: TImage;
    StatusLBL: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FSplash: TFSplash;

implementation


{$R *.dfm}

procedure TFSplash.FormCreate(Sender: TObject);
var
  formregion,
  formregion1: HRGN;
  xpbottom, xptop, xpleft, xpright: integer;
  filename: String;
begin
  TranslateComponent (self);

  filename := ExtractFilePath(ParamStr(0)) + 'img\splash.jpg';

  if FileExists(filename) then
      image1.Picture.LoadFromFile(filename);


  xpleft   := 0;
        xptop    := 0; //+ 5 ;// + 19;
        xpright  := xpleft + 218 {GRPBOXSpectrum.Width} - 1 + 4;  //width-8;  //-14
        xpbottom := xptop + 25 {GRPBOXTextAnzeige.Height} -1 + 3;
        formRegion := CreateRoundRectRgn
            (xpleft, xptop, xpright, xpbottom , 4, 4);

        xptop    := xpBottom - 1; // + 1;
        xpbottom := xptop + 77{GRPBOXSpectrum.Height} - 1 + 2;
        formRegion1 := CreateRoundRectRgn
            (xpleft, xptop, xpright, xpbottom , 4, 4);
        CombineRgn( formregion, formregion, formregion1, RGN_OR );

        xptop    := xpBottom - 1;// + 1;
        xpbottom := xptop + 69 {GRPBOXControl.Height} - 1 + 3;

        formRegion1 := CreateRoundRectRgn
            (xpleft, xptop, xpright, xpbottom , 4, 4);
        CombineRgn( formregion, formregion, formregion1, RGN_OR );

        SetWindowRgn( handle, formregion, true );

  LAbel2.Caption := NEMP_VERSION_SPLASH;

end;

end.
