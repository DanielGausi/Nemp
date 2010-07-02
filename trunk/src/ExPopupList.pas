{
    Unit ExPopupList

    Gives information, when a Popup-Menu is opened/closed
    Used for the Menu in the Win7-Taskbar - otherwise the Menu will flicker a lot
    when the Menu-Button is clicked twice.

    This Unit is completely Copy&Paste from
    http://www.delphipraxis.net/26787-pruefen-ob-ein-popupmenue-geoeffnet-ist.html

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

unit ExPopupList;

interface

uses Controls;

const
  CM_MENUCLOSED   = CM_BASE - 1;
  CM_ENTERMENULOOP = CM_BASE - 2;
  CM_EXITMENULOOP = CM_BASE - 3;

implementation

uses Messages, Forms, Menus;

Type
  TExPopupList = class( TPopupList )
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

procedure TExPopupList.WndProc(var Message: TMessage);
  Procedure Send( msg: Integer );
  Begin
    If Assigned( Screen.Activeform ) Then
      Screen.ActiveForm.Perform( msg, Message.wparam,
Message.lparam );
  End;
begin
  Case message.Msg Of
    WM_ENTERMENULOOP: Send( CM_ENTERMENULOOP );
    WM_EXITMENULOOP : Send( CM_EXITMENULOOP );
    WM_MENUSELECT  :
      With TWMMenuSelect( Message ) Do
        If (Menuflag = $FFFF) and (Menu = 0) Then
          Send( CM_MENUCLOSED );
  End;
  inherited;
end;

Initialization
  PopupList.Free;
  PopupList:= TExPopupList.Create;

end.
