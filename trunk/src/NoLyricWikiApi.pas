{

    Unit NoLyricWikiApi
    Form NoLyricWikiApiForm

    A statement about the deactivated LyricWiki-API

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
unit NoLyricWikiApi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, ExtCtrls;

type
  TNoLyricWikiApiForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Label2: TLabel;
    Memo4: TMemo;
    Bevel1: TBevel;
    Button1: TButton;
    procedure Label3Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  NoLyricWikiApiForm: TNoLyricWikiApiForm;

implementation

{$R *.dfm}

procedure TNoLyricWikiApiForm.Label3Click(Sender: TObject);
begin
    Shellexecute(0, 'open', PChar('http://www.gausi.de/nemp/lyricwiki.php'), nil, nil, SW_SHOW);
end;

end.
