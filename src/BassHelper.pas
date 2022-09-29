{

    Unit BassHelper

    Methods for Bass.dll
    - StatusProc, DoMeta

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

unit BassHelper;

interface

uses Windows, Forms, Classes, SysUtils, hilfsfunktionen;


  procedure StatusProc(buffer: Pointer; length: DWORD; user: Pointer); stdcall;


implementation

uses NempMainUnit, Spectrum_Vis, PlayerClass;


procedure StatusProc(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
begin
  if (buffer <> nil) then
  begin
      if (length = 0) and assigned(NempPlayer.OnMessage) then
          //Spectrum.DrawText(String(PAnsiChar(buffer)))
          NempPlayer.OnMessage(NempPlayer, String(PAnsiChar(buffer)) )
      else
      begin
          if NempPlayer.StreamRecording and assigned(NempPlayer.RecordStream) then
          begin
              if NempPlayer.SplitRecordStreamNow(length) then
                  NempPlayer.StartRecording;
              // Write auf jeden Fall durchführen, dann halt ggf. in den neuen Stream.
              // aber: unter Umständen wurde kein neuer Stream erzeugt (Exception in StartRecording)
              if Assigned(NempPlayer.RecordStream) then
                  NempPlayer.RecordStream.Write(buffer^, length);
          end;
      end;
  end else
      if assigned(NempPlayer.RecordStream) then
          FreeandNil(NempPlayer.RecordStream);
end;


end.
