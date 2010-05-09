{

    Unit Easteregg

    - OK, this is kinda useless. ;-)
      This is an insider joke from www.entwickler-ecke.de

      On Advent, the "Entwickler-Ecke" does a lottery, whereas the user should
      solve some problems and/or write some little programs in delphi.
      One of the "Paranüsse" (i.e. complicated puzzles) in 2008 was some
      crazy Brainfuck-thing.

      A very special mp3-File was built there. It could be played, but it
      contained only noise. The data inside of the MPEG-Frames should be
      interpreted nibble by nibble (half bytes), and every nibble stands for
      one the 8 possible Brainfuck-instructions.
      The output of the BF-Program then contained the data of the original
      mp3-file, and the name of the song was the correct answer for the puzzle.

      The functions here check a played file for the filename of the corrupted
      file ("kaputtes_Lied.mp3"), if true checks the md5-Hashsum, if true start
      a rudimental BF-Machine and replace the corrupted file with the new one.

      I implemented this in Nemp, just as asked for in this posting by Martok:
      http://www.delphi-forum.de/viewtopic.php?p=540669#540669


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

unit Easteregg;

interface

uses  Windows, Classes, SysUtils, MD5;

function CheckForEasteregg(aFilename: UnicodeString): Boolean;
procedure RepairCorruptFile(aFilename: UnicodeString);

implementation

type TBuffer = Array of Byte;

var
  Container: Array[0..15] of Byte; // Container mit einigen Zeichen, so dass man nicht zuviel Code erzeugt
  PointerPos: Integer;             // Position innerhalb des Containers während der String-Abtastung


procedure ParseMpegFrameToStream(aFrame: TBuffer; aStream: TStream; first: Boolean);
var i, start: integer;
begin
    // Interpretiert die Daten im MPEG-Frame (d.h. ohne den Header)
    // als BF-Dialekt und schreibt die Ausgabe in den Stream.

    // im ersten MPEG-Frame steht auch der BF-Init-Code (Länge 170 Zeichen) drin.
    if first then
        start := (170 div 2) + 4
    else
        start := 4;

    for i := start to length(aFrame)-1 do
    begin
        case aFrame[i] DIV 16 of
            1:  inc(PointerPos)           ; // '>'
            2:  dec(PointerPos)           ; // '<'
            3:  dec(Container[PointerPos]); // '-'
            4:  inc(Container[PointerPos]); // '+'
            5:  ;                           // '['  Hier ignorieren
            6:  ;                           // ']'  - das ist hier nicht vorgesehen
            7:  aStream.Write(Container[PointerPos], SizeOf(Byte)); // '.'
            8:  ;                           //  ','
        else
            ; // nothing
        end;

        // zweite Hälfte des Bytes auswerten
        case aFrame[i] MOD 16 of
            1:  inc(PointerPos)           ; // '>'
            2:  dec(PointerPos)           ; // '<'
            3:  dec(Container[PointerPos]); // '-'
            4:  inc(Container[PointerPos]); // '+'
            5:  ;                           // '['  Hier ignorieren
            6:  ;                           // ']'  - das ist hier nicht vorgesehen
            7:  aStream.Write(Container[PointerPos], SizeOf(Byte)); // '.'
            8:  ;                           //  ','
        else
            ; // nothing
        end;
    end;
end;

procedure Repair2008(aFilename: UnicodeString);
var LoadStream: TFileStream;
    SaveStream: TMemoryStream;
  i: Integer;
  BlockSize: Integer;
  Buffer: TBuffer;
  ok, renameok: Boolean;
  newName: UnicodeString;

begin
    ok := True;
    // Pseudo-BF-Maschine initialisieren
    // Dieser Code ist Teil des Brainfuck-Programms in den MPEG-Frames,
    // den wir hier nach Delphi übersetzen. Einen kompletten
    // BF-Interpreter spare ich mir hier.
    for i := 0 to 15 do
        Container[i] := 16*i;
    PointerPos := 0;

    // Daten aus Stream lesen
    try
        LoadStream := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
        try
            // Blocksize initialisieren
            BlockSize := LoadStream.Size;
            Setlength(Buffer, BlockSize);
            LoadStream.Read(Buffer[0], BlockSize);
        finally
            LoadStream.Free;
        end;
    except
        ok := False;
    end;

    // alte Datei umbenennen
    renameok := False;
    if ok then
    begin
        i := 1;
        repeat
            newName := aFilename + '.bak' + IntToStr(i);
            renameok := RenameFile(aFilename, newName);
            inc(i);
        until renameok or (i=20);
    end;

    if ok and renameok then
    begin
        // SaveStream erzeugen
        SaveStream  := TMemoryStream.Create;
        try
            SaveStream.Size := 1446900;
            SaveStream.Position := 0;

            // Am Anfang: Die Initialisierung der BF-Maschine
            // muss übersprungen werden
            ParseMpegFrameToStream(Buffer, SaveStream, True);
            try
                SaveStream.SaveToFile(aFilename);
            except
                // Umbenennen rückgängig machen
                RenameFile(newName, aFilename);
            end;
        finally
            SaveStream.Free;
        end;
    end;
end;


function CheckForEasteregg(aFilename: UnicodeString): Boolean;
var CheckSum: String;
    fs: TFileStream;
    size: Int64;
begin
    result := False;
    size := 0;
    if ExtractFileName(aFilename) = 'kaputtes_Lied.mp3' then
    begin
        try
            fs := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
            try
                size := fs.Size;
            finally
                fs.Free;
            end;
        except

        end;
        if size = 8354595 then
        begin
          try
            CheckSum := MD5DigestToStr(MD5File(aFileName));
          except
            //on E:Exception do ShowMessage(E.Message)
          end;
            //ShowMessage(Checksum);
            if Checksum = '898D1B52BA47ADB23568EFCF32C4BC49' then
                result := true;
        end;
    end;
end;

procedure RepairCorruptFile(aFilename: UnicodeString);
begin
    Repair2008(aFilename);
end;

end.
