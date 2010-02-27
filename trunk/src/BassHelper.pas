{

    Unit BassHelper

    Methods for Bass.dll
    - StatusProc, DoMeta

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

unit BassHelper;

interface

uses Windows, Forms, Classes, SysUtils, hilfsfunktionen;


  procedure StatusProc(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
 // procedure DoMeta(meta: PAnsiChar);

implementation

uses NempMainUnit, Spectrum_Vis, PlayerClass;


procedure StatusProc(buffer: Pointer; length: DWORD; user: Pointer); stdcall;
begin
  if (buffer <> nil) then
  begin
      if (length = 0) then
          Spectrum.DrawText(String(PAnsiChar(buffer)))
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
   (*
procedure DoMeta(meta: PAnsiChar);
var
  p: Integer;
  oldTitel: UnicodeString;
begin
  oldTitel := '';

  if (meta <> nil) AND (NempPlaylist.PlayingFile <> NIL) then
  begin
        wuppdi;
        oldTitel := NempPlayer.PlayingTitel;
        p := Pos('StreamTitle=', meta);
        if (p > 0) then
        begin
            p := p + 13;
            NempPlaylist.PlayingFile.Titel := Copy(meta, p, Pos(';', meta) - p - 1);
        end else
        begin
            // nach Ogg-Daten suchen
            if (meta <> nil) then
                try
                    while (meta^ <> #0) do
                    begin
                      if (AnsiUppercase(Copy(meta, 1, 7)) = 'ARTIST=') then
                          NempPlaylist.PlayingFile.Artist := Copy(meta, 8, Length(meta) - 7)
                      else
                          if (AnsiUppercase(Copy(meta,1,6)) = 'TITLE=') then
                              NempPlaylist.PlayingFile.Titel := trim(Copy(meta, 7, Length(meta) - 6 ));
                      meta := meta + Length(meta) + 1;
                    end;
                except
                  // Wenn was schief gelaufen ist: Dann gibts halt keine Tags...
                end;
        end;
        NempPlayer.RefreshPlayingTitel;// := Nemp_MainForm.GeneratePlayingTitel(Nemp_MainForm.PlayingFile, Nemp_MainForm.NempOptions.PlayingTitelMode);
        Application.Title := NempPlayer.GenerateTaskbarTitel;

        if NempPlayer.StreamRecording AND (oldTitel<> NempPlayer.PlayingTitel) AND NempPlayer.AutoSplitByTitle then
            NempPlayer.StartRecording;

        Nemp_MainForm.NempTrayIcon.Hint := StringReplace(NempPlaylist.PlayingFile.Titel, '&', '&&&', [rfReplaceAll]);
  end;
end;   *)

end.
