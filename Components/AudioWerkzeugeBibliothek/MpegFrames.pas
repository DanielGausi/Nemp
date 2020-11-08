{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012-2020, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit MpegFrames

    * Read/Calculate MPEG-information (bitrate, duration, ...)
      in mp3 files

    This Unit contained formerly also classes for ID3v1 and ID3v2-Tags, which are now
    separated into their own units.

    Therefore the former "MP3FileUtils.pas" is now renamed to this "MpegFrames.pas".
    The version history below relates to the old MP3FileUtils and remains here
    for nostalgic reasons. ;-)


    ---------------------------------------------------------------------------

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    ---------------------------------------------------------------------------

    Alternatively, you may use this unit under the terms of the
    MOZILLA PUBLIC LICENSE (MPL):

    The contents of this file are subject to the Mozilla Public License
    Version 1.1 (the "License"); you may not use this file except in
    compliance with the License. You may obtain a copy of the License at
    http://www.mozilla.org/MPL/

    Software distributed under the License is distributed on an "AS IS"
    basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
    License for the specific language governing rights and limitations
    under the License.

    ---------------------------------------------------------------------------
}

{

  Version-History (Mp3FileUtils)
  ========================================================================================================

  August 2020: v0.7
  ==========================
    - added a complete scan of the file for all frames
    - Property TMpegInfo.MpegScanMode
    - Method TMpegInfo.StoreFrames to store all MpegFrames in Array TMpegInfo.fMpegFrames
    - Split unit into several parts, so that it better fits into the overall "AWB" concept.
    - List of Language codes moved to unit LanguageCodeList.pas


  March 2016: v0.6c -> v0.6d
  ==========================
    - added support for the "Info"-variant of the XING-Header in some CBR-files

  June 2012: v0.6b -> v0.6c
  ==========================
  Bugfix
    - getConvertedUnicodeText corrected for TE_UTF16, but actuallay no BOM is present

  June 2012: v0.6a -> v0.6b
  ==========================
  Bugfix
    - correct computation of bitrate and duration in MPEG 2 Layer 3 files
      with varible bitrate (Xing-Header)
    - Renamed "genres" to "ID3Genres" and outsourced it into ID3GenreList.pas

  December 2011: v0.6 -> v0.6a
  ============================
  Bugfix
    - method SetRatingAndCounter didn't work properly, when no POPM-Frame
      was in the file: Instead of writing the Rating and Playcounter into the Tag,
      the Value for "Playcounter" was written as "Rating".


  June 2011: v0.5b -> v0.6
  ========================
  New features
    - Private Frames
    - VBRI-Header-Detection
    - added some more genres to the Genres-List
    - added methods GetUserText, SetUserText, GetAllUserTextFrames,
      deleted TXXX-Frames from GetAllTextFrames
      (see TXXX-Bugfix below)

  Changes
    - ID3v2Tag.ReadFromStream: Copy all frames into a memorystream before reading
    - deleted methods SetRating and SetPersonalPlayCounter
      use SetRatingAndCounter instead to set both values at once
      (both values are stored in the same frame)

  Bugfixes
    - correct reading of UTF8-encoded Textframes with Delphi2009
    - ExtendedHeader-Size has been misinterpreted
    - User defined Textframes (TXXX) have NOT the same structure as other Textframes
    - result of TMpegInfo.GetframeLength is integer (negative value is used as error indication),
      but TMpegHeader.Framelentgh is Word. The direct assignment provided some errors whith
      range checking enabled


  August 2009: v0.5a -> 0.5b
  ========================
    - Fatal Bug fixed: ID3-v1-Tag could not be deleted in Delphi 2009, and every
      write-access (WriteToFile/-Stream) to ID3v1-Tags created a new one at the
      end of the file. (This was the case only in Delphi 2009, it was a
      Char-AnsiChar-thingy.)
    - DefaultRatingDescription is a var now.
    - Added frame-support for PlayCounter. Not the PCNT-Frame, but the
      counter included within Rating-Frames.
      (Use with care, this is not tested very well. This should have come along
      with some more new features (private-frames), but someone showed me
      this ID3v1-bug, which really must be fixed.)

  April 2009: v0.5 -> 0.5a (not published)
  ========================
    - fixed a possible memory-leak in TID3v2Tag.RemoveFromStream

  April 2009: v0.4a -> 0.5
  ========================
    - update to Delphi 2009
    - kicked out DIConverters.
      Conversion will now use the MultiByteToWideChar-Function from the Windows-API
      (-) some codepages are not supported any longer
      (+) easier to use, no third-party-stuff required
      (+) smaller binary
    - kicked out some methods, which were declared "deprecated" in v0.4
    - AcceptAllEncodings replaced by AutoCorrectCodepage
    - CharCode replaced by CodePage
    - GetCharcode replaced by GetCodePage
    - added TMpegInfo.Duration (same as .Dauer, just for the english users ;-) )
    - fixed a bug which possibly caused invalid encoded URLs on "Unicode-filenames"
    - fixed a problem with activated range-checking and PaddingSize of zero
    - translated (most) comments to english

  Dezember 2008: v0.4 -> 0.4a (sorry, from here on only german ;-))
  ===========================
    - Fehler behoben, der bei Tags mit einer bestimmten Text-Kodierung das letzte
      Zeichen der Textfelder abschnitt

  Juni 2008: v0.3b -> 0.4
  =======================
    - Code anders strukturiert - einiges in die Klasse TID3v2Frame ausgelagert
    - Unterstützung von Unsynchronisation
    - Unterstützung von GroupID und DataLength-Flags in Frame-Headern
    - Bei Compression und/oder Encryption wird das Auslesen abgebrochen
    - Unterstützung von URLs
    - Unterstützung von Bewertungen
    - Fehler in der Behandlung bei "Beschreibungen" mit Unicode - das führte u.a. dazu,
      dass viele Cover in Dateien von jamendo.com nicht angezeigt wurden.

  Februar 2008: v0.3a -> 0.3b
  ==========================
    - Funktion GetTrackFromV2TrackString hinzugefügt
    - Bug in der Funktion GetPaddingSize behoben

  Juni 2007: v0.3 -> 0.3a
  ==========================
    - Bei den Gettern des ID3v1-Tags wurden häufig Leerstellen und/oder Nullbytes mit übergeben, was ein Trim() außerhalb
      der Klasse nötig machte. Das wurde korrigiert - das trim() wird jetzt hier intern gemacht.
    - Schönheitsfehler bei der Benennung beseitigt: TPictureFrameDes()ription heißt jetzt TPictureFrameDes(c)ription


  Februar 2007: v0.2a -> 0.3
  ==========================
    - INT/WE- Versionen über Compiler-Schalter vereint.
      Siehe dazu das Ende dieses einleitenden Kommentars
    - Fehler entfernt, die bei einer Verkleinerung des ID3v2-Tags unter gewissen Umständen zu unschönen
      Effekten bei den getaggten mp3s führte - die letzten Frames/Sekunden des Liedes wurden dann doppelt
      abgespielt.
    - intelligenteres Padding-System (abhängig von der Clustergröße)
      für den ID3v1Tag werden 128 Byte im Cluster freigehalten (falls er nicht existiert), so
      dass ein nachträgliches Einfügen keinen Zusatzplatz benötigt.


  ========================================================================================================
  September 2006: v0.2 -> 0.2a (beide Versionen)
  ==============================================
    - katastrophalen Bug behoben, der ungültige ID3v2-TextFrames erzeugt.


  August 2006:  v0.1 -> v0.2(International)
  =========================================

    Kleinere Bugs:
    ==============
    - Der ID3v1-Tag wurde vor dem Lesen nicht gelöscht, so dass u.U noch alte Informationen übrigblieben
    - Unter gewissen Umständen wurden Lyrics und Comments bei ID3v2 nicht richtig ausgelesen.
      Das lag aber an fehlerhaften Language-Informationen, die jetzt ausgebügelt werden.
    - Fehler beim Lesen einer Variante von Unicode behoben (Stichwort: Byte-Order)
    - Finalize-Abschnitt (wieder) hinzugefügt. Der ist zwischendurch mal irgendwo verlorengegangen.

    Updates/Änderungen:
    ===================
       Klasse TID3v1Tag:
       -----------------
       - in der 'International'-Version werden alle Textinformationen als WideString zurückgeliefert
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - beim Schreiben wird ebenfalls dieser Zeichensatz verwendet und der WideString entsprechend konvertiert
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt
         (weder beim schreiben, noch beim lesen).
         Was das für einen Effekt auf Systemen außerhalb Westeuropas hat, kann ich nicht genau sagen.

       Klasse TID3v2Tag:
       -----------------
       - Sämtliche TextInformationen werden jetzt als WideString geliefert.
       - Textinformationen werden automatisch im Unicode-Format gespeichert, falls dies nötig ist.
       - Flag 'AlwaysWriteUnicode' hinzugefügt. Ist dies gesetzt, wird immer im Unicode-Format gespeichert,
         auch wenn das nicht nötig ist (d.h. wenn nur "Standard"-Buchstaben verwendet werden)
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Im Gegensatz zur Klasse ID3v1Tag tritt dies nur dann auf, wenn beim Taggen auf Unicode verzichtet
         wurde. D.h. auch wenn das Flag 'AcceptAllEncodings' nicht gesetzt ist, kann man kyrillische oder asiatische (oder...)
         Zeichen erhalten. Dies sollte eigentlich sogar die Regel sein - ist es aber nicht, weswegen ich den ganzen
         Kram mit der Konvertierung überhaupt implementieren musste.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt

}

unit MpegFrames;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, Contnrs, U_CharCode, AudioFiles.Declarations
  {$IFDEF USE_SYSTEM_TYPES}, System.Types{$ENDIF};

type


//--------------------------------------------------------------------
// Teil 4. Types for MPEG
//--------------------------------------------------------------------

  TMpegHeader = record
    version: byte;
    layer: byte;
    protection: boolean;
    bitrate: LongInt;
    samplerate: LongInt;
    channelmode: byte;
    extension: byte;
    copyright: boolean;
    original: boolean;
    emphasis: byte;
    padding: boolean;
    framelength: word;
    valid: boolean;
  end;

  // two Types for a complete Analysis of the AudioData I use something like
  // that every now and then, so I include it now officially here.
  // Used by method TMpegInfo.StoreFrames
  TMpegFrame = record
    ParsedHeader: TMpegHeader;
    FrameData: TBuffer;
  end;
  TMpegFramesArray = Array of TMpegFrame;

  TXingHeader = record
    Frames: integer;
    Size: integer;
    vbr: boolean;
    valid: boolean;
    corrupted: boolean;
  end;
  TVBRIHeader = TXingHeader;

  // TMpegScanMode
  // Usually a quick scan of the first few Mpeg frames is enough to get all
  // information like (average) bitrate and duration.
  // However, on some files this result in wrong data, usually very low bitrates
  // and therefore long durations.
  // * The "smart" mode (default) tries a quick scan first, and performs a complete
  //   scan, if the calculated bitrate is 32kbit/s or lower
  TMpegScanMode = (MPEG_SCAN_Fast, MPEG_SCAN_Smart, MPEG_SCAN_Complete);

  TMpegInfo = class(TObject)
  Private
    FFilesize: int64;
    Fversion:integer;
    Flayer:integer;
    Fprotection:boolean;
    Fbitrate:word;
    Fsamplerate:integer;
    Fchannelmode:byte;
    Fextension:byte;
    Fcopyright:boolean;
    Foriginal:boolean;
    Femphasis:byte;
    Fframes:Integer;
    Fdauer:Longint;
    Fvbr:boolean;
    Fvalid: boolean;
    FfirstHeaderPosition: int64;
    fMpegScanMode: TMpegScanMode;
    // Array with all mpeg frames of the file. Filled only by StoreFrames()
    // Usually this is not needed, only for a more detailed analysis of the file.s
    fMpegFrames: TMpegFramesArray;

    // Check, wether there is in aBuffer on position a valid MPEG-header
    function GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegHeader;
    // Check, wether the MPEG-header is followed by a Xing-Frame
    function GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
    function GetVBRIHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TVBRIHeader;

    function GetFramelength(version:byte;layer:byte;bitrate:integer;Samplerate:integer;padding:boolean):integer;
    // read frames for MPEG_SCAN_Smart (if needed) or MPEG_SCAN_Complete
    function AnalyseStreamFrameByFrame(aStream: TStream; StartPosition: int64): Integer;
  public

    constructor create;
    destructor Destroy; override;
    function LoadFromStream(stream: tStream): TAudioError;
    function LoadFromFile(FileName: UnicodeString): TAudioError;
    // StoreFrames: This is only for a low level analysis of the file
    //              It is mainly used by myself to have a closer look on "odd" mp3 files
    //              which some properties leading to wrong results in bitrate, duration and stuff.
    function StoreFrames(aStream: TStream): TAudioError;
    property MpegFrames: TMpegFramesArray read fMpegFrames;
    // properties of an mp3file, most of them based on the properties of the MPEG frames
    property Filesize: int64          read   FFilesize;
    property Version: integer         read   Fversion;
    property Layer: integer           read   Flayer;
    property Protection: boolean      read   Fprotection;
    property Bitrate: word            read   Fbitrate;
    property Samplerate: integer      read   Fsamplerate;
    property Channelmode: byte        read   Fchannelmode;
    property Extension: byte          read   Fextension;
    property Copyright: boolean       read   Fcopyright;
    property Original: boolean        read   Foriginal;
    property Emphasis: byte           read   Femphasis;
    property Frames: Integer          read   Fframes;
    property Dauer: Longint           read   Fdauer;
    property Duration: Longint        read   Fdauer; // Same as "Dauer" - for the english user ;-)
    property Vbr: boolean             read   Fvbr;
    property Valid: boolean           read   Fvalid;
    property FirstHeaderPosition: int64 read   FfirstHeaderPosition;

    property MpegScanMode: TMpegScanMode read fMpegScanMode write fMpegScanMode;
  end;


const

 MPEG_BIT_RATES : array[1..3] of array[1..3] of array[0..15] of word =
  { Version 1, Layer I }
    (((0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0),
  { Version 1, Layer II }
    (0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,0),
  { Version 1, Layer III }
    (0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,0)),
  { Version 2, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)),
  { Version 2.5, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2.5, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2.5, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)));

  sample_rates: array[1..3] of array [0..3] of word=
    ((44100,48000,32000,0),
    (22050,24000,16000,0),
    (11025,12000,8000,0));
  channel_modes:array[0..3] of string=('Stereo','Joint stereo','Dual channel (Stereo)','Single channel (Mono)');
  extensions:array[1..3] of array [0..3] of string=
    (('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('IS:off, MS:off','IS:on, MS:off','IS:off, MS:on','IS:on, MS:on'));
  emphasis_values: array[0..3] of string = ('None', '50/15ms','reserved','CCIT J.17');


implementation



//------------------------------------------------------
// TMpegInfo
//------------------------------------------------------

constructor TMpegInfo.create;
begin
  inherited create;
  MpegScanMode := MPEG_SCAN_Smart;
end;

destructor TMpegInfo.Destroy;
begin
  if Length(fMpegFrames) > 0 then
      SetLength(fMpegFrames, 0);
  inherited;
end;

//------------------------------------------------------
// Get the MPEG-Information from a stream
//------------------------------------------------------
function TMpegInfo.LoadFromStream(stream: tStream): TAudioError;
var buffer: TBuffer;
  erfolg, Skip3rdTest: boolean;
  positionInStream, CombinedFrameLength: int64;
  positionInBuffer: integer;
  tmpMpegHeader, tmp2MpegHeader: TMpegHeader;
  tmpXingHeader: TXingHeader;
  BLOCK_SIZE: Integer; // was 512, now it is set to 4096. This should lead to fewer calls to Stream.Read

    function ReadMoreData(StartPosition: Int64; NeededSize: Integer): Integer;
    begin
        if BLOCK_SIZE < NeededSize then
        begin
            BLOCK_SIZE := NeededSize;
            Setlength(Buffer, BLOCK_SIZE);
        end;

        Stream.Position := StartPosition;
        result := Stream.Read(buffer[0], length(buffer));
        if result < BLOCK_SIZE then
            Setlength(Buffer, result);
        positionInBuffer := 0;
    end;


begin
  FFilesize := Stream.Size;

  // be pessimistic first. No mpeg-frame-header found.
  result := MP3ERR_NoMpegFrame;
  Fvalid := False;
  erfolg := False;

  FfirstHeaderPosition := -1;
  positionInStream := Stream.Position - 1 ;

  // read initial Chunk of Data from the Stream, starting at the current position
  BLOCK_SIZE := 4096; // that should be always enough to avoid multiple read access to the file
  setlength(buffer, BLOCK_SIZE);
  ReadMoreData(Stream.Position, BLOCK_SIZE);

  // Initialize positionInStream and positionInBuffer with "-1",
  // so we are at position 0 at first cycle of this while-loop
  // * positionInStream will be the position of the first mpeg-header at the end of this method
  // * positionInBuffer is the same, but relative to the little buffer, not the whole stream
  positionInBuffer := -1 ;

  while ((NOT erfolg) AND (positionInStream + 3 < FFilesize)) do
  begin
      inc(positionInBuffer);
      inc(positionInStream);

      // after a few cycles we may need to to read more data
      if (positionInBuffer+3) = (length(buffer)-1) then
        ReadMoreData(PositionInStream, BLOCK_SIZE);

      tmpXingHeader.valid := False;

      // Step 1: Check for a valid MPEG Header on the current position
      // ---------------------------------------------------------------------------
      tmpMpegHeader := GetValidatedHeader(Buffer, positionInBuffer);
      if (not tmpMpegHeader.valid)
        or (positionInStream + tmpMpegHeader.framelength + 3 > FFilesize) // length exceeds the filesize
      then
          continue;

      // Step 2: Check, wether frame is a XING-Header
      // ---------------------------------------------------------------------------
      // read more data if neccessary
      if (positionInBuffer + tmpMpegHeader.framelength + 3 > length(buffer)-1) then // next header not in buffer yet
          ReadMoreData(PositionInStream, tmpMpegHeader.framelength + 4);
      // read XingHeader and next MPEG-Header from buffer
      tmpXingHeader := GetXingHeader(tmpMpegheader, buffer, positionInBuffer );
      Skip3rdTest := False;
      if (not tmpXingheader.valid) and (not tmpXingheader.corrupted) then
      begin
          // try VBRI
          tmpXingHeader := GetVBRIHeader(tmpMpegheader, buffer, positionInBuffer );
          // Note: Some files with VBRI-Header seem to be invalid
          //       i.e. after the MPEG-Frame containing the VBRI-Header
          //       does not follow directly another MPEG-Frame.
          //       So I skip the "3rd test" in that case.
          Skip3rdTest := tmpXingHeader.valid;
          if tmpXingHeader.valid then
              tmp2MpegHeader.Valid := True
          else
              // no Xing, no VBRI, probably "normal" MPEG-Frame
              tmp2MpegHeader := GetValidatedHeader(buffer, positionInBuffer + tmpMpegHeader.framelength);
      end else
      begin
          if tmpXingHeader.corrupted then
              // technically valid MPEG, but corrupted Xing-Frame. Calculate stuff by the NEXT MPEG-Frame, therefore: continue
              tmp2MpegHeader.valid := False
          else
              tmp2MpegHeader := GetValidatedHeader(buffer, positionInBuffer + tmpMpegHeader.framelength);
      end;

      // if following header is invalid something is wrong - search further. :(
      if not tmp2MpegHeader.valid then
          continue;

      // Step 3. Check for a 3rd MPEG-Header in a row
      // ---------------------------------------------------------------------------
      if Not Skip3rdTest then
      begin
          CombinedFrameLength := tmpMpegHeader.framelength + tmp2MpegHeader.framelength;
          if (positionInStream + CombinedFrameLength + 3 > FFilesize) then
              continue;

          if (positionInBuffer + CombinedFrameLength + 3 > length(buffer)-1) then // next header not in buffer yet
              ReadMoreData(PositionInStream, CombinedFrameLength + 4);
          // only a very basic test here, just check the first 2 bytes of the 3rd header
          if (buffer[positionInBuffer + CombinedFrameLength] <> $FF)
              OR (buffer[positionInBuffer + CombinedFrameLength + 1] < $E0)
          then
              continue;
      end;

      // Step 4. Success! - Set data!
      // ---------------------------------------------------------------------------
      Fversion     := tmpMpegHeader.version;
      Flayer       := tmpMpegHeader.layer;
      Fprotection  := tmpMpegHeader.protection;
      Fsamplerate  := tmpMpegHeader.samplerate;
      Fchannelmode := tmpMpegHeader.channelmode;
      Fextension   := tmpMpegHeader.extension;
      Fcopyright   := tmpMpegHeader.copyright;
      Foriginal    := tmpMpegHeader.original;
      Femphasis    := tmpMpegHeader.emphasis;

      if tmpXingHeader.valid then
        try
            // change 13.03.2016: round instead of trunc
            if Version = 1 then
                Fbitrate := round((tmpMpegheader.samplerate/1000 *
                  (FFilesize - PositionInStream - tmpXingHeader.Size))  / (tmpXingHeader.frames*144))
            else
                Fbitrate := round((tmpMpegheader.samplerate/1000 *
                  (FFilesize - PositionInStream - tmpXingHeader.Size))  / (tmpXingHeader.frames*72));

            Fvbr := tmpXingHeader.vbr;
            // note: Data at the beginning of the file are not audiodata (e.g. ID3v2Tag).
            // these bytes must be subducted from the filesize
            // it would be better, to subduct also the length of id3v1tag (and others?) at the end of the file.
            // But I think, that this would be overkill, and would make only  +/-1 frames in most cases
            // change 13.03.2016: "round /" instead of DIV
            Fdauer := round( ((FFilesize-PositionInStream-tmpXingHeader.Size)*8) / ((Fbitrate)*1000));

            FFrames := tmpXingHeader.Frames;
        except
            continue;
        end
      else
        try
            Fframes := trunc((FFilesize - PositionInStream)/tmpMpegheader.framelength);
            FBitrate := tmpMpegHeader.bitrate;
            Fvbr := False;
            Fdauer := ((FFilesize - PositionInStream)*8) div ((Fbitrate)*1000);
        except
            continue;
        end;

      Fvalid := True;
      FfirstHeaderPosition := PositionInStream;
      result := FileErr_None;
      erfolg := True;
  end;

  // 2020: correct VBR/Bitrate/Duration if wanted
  // DefaultMode is MPEG_SCAN_Smart
  case MpegScanMode of
      MPEG_SCAN_Fast:     ; // nothing to do
      MPEG_SCAN_Complete: begin
            AnalyseStreamFrameByFrame(stream, FfirstHeaderPosition);;
      end;
      MPEG_SCAN_Smart: begin
            if fBitrate <= 32 then
              AnalyseStreamFrameByFrame(stream, FfirstHeaderPosition);;
      end;
  end;
end;


//------------------------------------------------------
// AnalyseStreamFrameByFrame
//------------------------------------------------------
function TMpegInfo.AnalyseStreamFrameByFrame(aStream: TStream; StartPosition: int64): Integer;
var c, bufpos: Integer;
    buffer: TBuffer;
    aMpegHeader: TMpegHeader;
    BitrateSum, lastBitrate, BitrateChanges: Integer;
begin
  if StartPosition >= aStream.Size then
  begin
      result := 0;
      exit;
  end;

  setlength(buffer, aStream.Size - StartPosition);
  aStream.Position := StartPosition;

  c := aStream.Read(buffer[0], length(buffer));
  if c < aStream.Size then
      Setlength(Buffer, c);

  bufpos := 0;
  Result := 0;
  BitrateSum := 0;
  lastBitrate := 0;
  BitrateChanges := 0;
  repeat
      aMpegHeader := GetValidatedHeader(buffer, bufpos);
      if aMpegHeader.valid then
      begin
          inc(Result);
          if lastBitrate <> aMpegHeader.bitrate then
          begin
              lastBitrate := aMpegHeader.bitrate;
              inc(BitrateChanges);
          end;
          BitrateSum := BitrateSum + aMpegHeader.bitrate;
          bufpos := bufpos + aMpegHeader.framelength;
      end else
      begin
          // No valid MPEG-Frame found => Something is wrong here
          // possibly the beginning of APE or ID3v1Tag,
          // but maybe it's just an invalid file
      end;
  until not aMpegHeader.valid;

  // Fill relevant Data fields with our collected data
  Fframes := result;
  FBitrate := round(BitrateSum/result) ;
  Fvbr := BitrateChanges > 2; // We allow 2 changes here
  Fdauer := ((FFilesize - StartPosition)*8) div (FBitrate*1000);
end;

//------------------------------------------------------
//  StoreFrames
//  Analyse the file completely and store all mpeg frames into the fMpegFrames-array
//------------------------------------------------------
function TMpegInfo.StoreFrames(aStream: TStream): TAudioError;
var bufpos, i: Integer;
    buffer: TBuffer;
    aMpegHeader: TMpegHeader;
    StoredScanMode: TMpegScanMode;
begin
    // first: Analyse the stream to get the exact number of frames
    StoredScanMode := fMpegScanMode;
    fMpegScanMode := MPEG_SCAN_Complete; // perform a complete scan of the file
    result := LoadFromStream(aStream);   // AnalyseStreamFrameByFrame will be called from there
    fMpegScanMode := StoredScanMode;     // restore the ScanMode

    if FfirstHeaderPosition = -1 then
    begin
        result := MP3ERR_NoMpegFrame;
        exit;
    end;

    // then: reread the stream, starting at the first header position
    // and store the frame data
    aStream.Position := FfirstHeaderPosition ;
    setlength(buffer, aStream.Size - FfirstHeaderPosition);
    aStream.Read(buffer[0], length(buffer));

    bufpos := 0;
    setlength(fMpegFrames, Fframes);
    for i := 0 to Fframes-1 do
    begin
        aMpegHeader := GetValidatedHeader(buffer, bufpos);
        if aMpegHeader.valid then
        begin
            // Copy Header-Data
            fMpegFrames[i].ParsedHeader.version     := aMpegHeader.version      ;
            fMpegFrames[i].ParsedHeader.layer       := aMpegHeader.layer        ;
            fMpegFrames[i].ParsedHeader.protection  := aMpegHeader.protection   ;
            fMpegFrames[i].ParsedHeader.bitrate     := aMpegHeader.bitrate      ;
            fMpegFrames[i].ParsedHeader.samplerate  := aMpegHeader.samplerate   ;
            fMpegFrames[i].ParsedHeader.channelmode := aMpegHeader.channelmode  ;
            fMpegFrames[i].ParsedHeader.extension   := aMpegHeader.extension    ;
            fMpegFrames[i].ParsedHeader.copyright   := aMpegHeader.copyright    ;
            fMpegFrames[i].ParsedHeader.original    := aMpegHeader.original     ;
            fMpegFrames[i].ParsedHeader.emphasis    := aMpegHeader.emphasis     ;
            fMpegFrames[i].ParsedHeader.padding     := aMpegHeader.padding      ;
            fMpegFrames[i].ParsedHeader.framelength := aMpegHeader.framelength  ;
            fMpegFrames[i].ParsedHeader.valid       := aMpegHeader.valid        ;
            // Copy actual Frame-Data (including the 4 Bytes "unparsed" Header)
            Setlength(fMpegFrames[i].FrameData, aMpegHeader.framelength);
            Move(buffer[bufpos], fMpegFrames[i].FrameData[0], aMpegHeader.framelength);
            bufpos := bufpos + aMpegHeader.framelength;
        end else
        begin
            // No valid MPEG-Frame found => Something is wrong here
            // possibly the beginning of APE or ID3v1Tag,
            // but maybe it's just an invalid file
            break;
        end;
    end;
end;


function TMpegInfo.LoadFromFile(FileName: UnicodeString): TAudioError;
var Stream: TAudioFileStream;
begin
  if AudioFileExists(Filename) then
    try
      stream := TAudioFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
      try
        result := LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := FileErr_FileOpenR;
    end
  else
    result := FileErr_NoFile;
end;

//------------------------------------------------------
// Check, wether buffer contains a valid MPEG-Header
// and returns ist.
// Check property .valid to decide success/no success
//------------------------------------------------------
function TMpegInfo.GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegheader;
var bitrateindex, versionindex: byte;
    samplerateindex:byte;
    tmpLength: Integer;
begin
  // a mpeg-header starts with 11 (eleven) bits
  if (abuffer[position]<>$FF) OR (abuffer[position+1]<$E0)
  then
  begin
    result.valid := False;
    exit;
  end;

  //Byte 1 and 2: AAAAAAAA AAABBCCD
  //A=1 (11 Sync bytes) at the beginning
  //B: version, normally BB=11 (=MPEG1, Layer3), but some others are allowed
  //C: Layer, for layer III is CC=01
  //D: Protection BIT. If set, the header is followed by a 16bit CRC
  Versionindex := (abuffer[position+1] shr 3) and 3;
  case versionindex of
      0: result.version := 3; //version 2.5 actually - but I need an array-index. ;-)
      1: result.version := 0; //Reserved
      2: result.version := 2;
      3: result.version := 1;
  end;
  result.Layer := 4-((abuffer[position+1] shr 1) and 3);
  result.protection := (abuffer[position+1] AND 1)=0;

  // --->
  // bugfix by terryk from delphi-forum.de
  if (Result.version = 0) or (Result.Layer = 4) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  // Byte 3: EEEEFFGH
  // E: Bitrate-index
  // F: Samplerate-index
  // G: Padding bit
  // H: Private bit
  bitrateindex := (abuffer[position+2] shr 4) AND $F;
  result.bitrate := MPEG_BIT_RATES[result.version][result.layer][bitrateindex];
  if bitrateindex=$F then
  begin
    result.valid := false; // Bad Value !
    exit;
  end;
  samplerateindex := (abuffer[position+2] shr 2) AND $3;
  result.samplerate := sample_rates[result.version][samplerateindex];
  result.padding := ((abuffer[position+2] shr 1) AND $1) = 1;

  // Byte 4: IIJJKLMM
  // I: Channel mode
  // J: Mode extension (for Joint Stereo)
  // K: copyright
  // L: original
  // M: Emphasis   =0 in most cases
  result.channelmode := ((abuffer[position+3] shr 6) AND 3);
  result.extension := ((abuffer[position+3] shr 4) AND 3);
  result.copyright := ((abuffer[position+3] shr 3) AND 1)=1;
  result.original := ((abuffer[position+3] shr 2) AND 1)=1;
  result.emphasis := (abuffer[position+3] AND 3);

  // "For Layer II there are some combinations of bitrate and mode which are not allowed."
  if result.layer=2 then
      if ((result.bitrate=32) AND (result.channelmode<>3))
          OR ((result.bitrate=48) AND (result.channelmode<>3))
          OR ((result.bitrate=56) AND (result.channelmode<>3))
          OR ((result.bitrate=80) AND (result.channelmode<>3))
          OR ((result.bitrate=224) AND (result.channelmode=3))
          OR ((result.bitrate=256) AND (result.channelmode=3))
          OR ((result.bitrate=320) AND (result.channelmode=3))
          OR ((result.bitrate=384) AND (result.channelmode=3))
      then begin
        result.valid := false;
        exit;
      end;

  // calculate framelength
  tmpLength := GetFramelength(result.version, result.layer,
                              result.bitrate,
                              result.Samplerate,
                              result.padding);

  if tmpLength > 0 then
  begin
      result.valid := True;
      result.framelength := Word(tmpLength);
  end else
  begin
      result.valid := false;
      result.framelength := high(word);
  end;

end;

//------------------------------------------------------
// Check for a valid XING-header
// and returns ist.
// Check property .valid to decide success/no success
//------------------------------------------------------
function TMpegInfo.GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
var Xing_offset: integer;
  Xing_Flags: byte;
begin
  if aMpegheader.version=1 then
    if aMpegheader.channelmode<>3 then
      xing_offset := 32+4
    else
      xing_offset := 17+4
  else
    if aMpegheader.channelmode<>3 then
      xing_offset := 17+4
    else
      xing_offset := 9+4;

  Result.corrupted := False; // think positive!
  // --->
  // bugfix by terryk from delphi-forum.de
  if Length(abuffer) <= (position + xing_offset + 11) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  if ((abuffer[position+xing_offset]=$58)        {'Xing', vbr}
     AND (abuffer[position+xing_offset+1]=$69)
     AND (abuffer[position+xing_offset+2]=$6E)
     AND (abuffer[position+xing_offset+3]=$67))
     OR
     ((abuffer[position+xing_offset]=$49)        {'Info', cbr}
     AND (abuffer[position+xing_offset+1]=$6E)
     AND (abuffer[position+xing_offset+2]=$66)
     AND (abuffer[position+xing_offset+3]=$6F))

     then // Xing Tag found
  begin
          // the next 4 bytes are flags, the 4th (= pos+7) is interesting here
          Xing_flags := abuffer[position+xing_offset+7];
          if (Xing_flags AND 1)=1 then
          begin //number of frames in the next 4 bytes
              result.frames := 16777216 * abuffer[position+xing_offset+8]
                  + 65536 * abuffer[position+xing_offset+9]
                  + 256 * abuffer[position+xing_offset+10]
                  + abuffer[position+xing_offset+11];
          end
          else
              result.frames := 0;
          // Note 1: possible cause vor failures:
          //      In case the Xing-Header is corrupted here,
          //      the following calculations will base upon the first real mpegframe
          //      which very often has a much lower bitrate on vbr-files
          // Note 2: I never found a mp3file with such a corrupted xing-header.
          //      So this should be no problem. ;-)
          result.Size := aMpegHeader.framelength;
          result.vbr := (abuffer[position+xing_offset]=$58); //'X'
          // change 20.03.2016: Valid only if frames > 0.
          //                    There actually ARE files with a cleared INFO-Frame (nothing left but "Info")
          result.valid := result.frames > 0;
          result.corrupted := result.frames = 0;
  end else
    result.valid := False;
end;

function TMpegInfo.GetVBRIHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer): TVBRIHeader;
var vbriOffset: Integer;
begin
    // Set the new variables for the Xing/Info-Frame to the default values here
    result.corrupted := False;
    result.vbr := True;

    vbriOffset := 4 + 32; // constant offset
    if Length(abuffer) <= (position + vbriOffset + 16) then
    begin
        // buffer too short for valid VBRI-Header
        Result.valid := False;
        Exit;
    end;

    if (abuffer[position+vbriOffset]=$56)       // V
      AND (abuffer[position+vbriOffset+1]=$42)  // B
      AND (abuffer[position+vbriOffset+2]=$52)  // R
      AND (abuffer[position+vbriOffset+3]=$49)  // I
    then // VBRI found
    begin
        result.frames := 16777216 * abuffer[position+vbriOffset+14]
                  + 65536 * abuffer[position+vbriOffset+15]
                  + 256 * abuffer[position+vbriOffset+16]
                  + abuffer[position+vbriOffset+17];
        result.valid := True;
        result.Size := aMpegHeader.framelength;
    end else
        result.valid := False;
end;


function TMpegInfo.GetFramelength(version:byte;layer:byte;bitrate:longint;Samplerate:longint;padding:boolean):integer;
begin
  if samplerate=0 then result := -2
  else
    if Layer=1 then
      result := trunc(12*bitrate*1000 / samplerate+Integer(padding)*4)
    else
      if Version = 1 then
        result :=  144 * bitrate * 1000 DIV samplerate + integer(padding)
      else
        result := 72 * bitrate * 1000 DIV samplerate + integer(padding)

end;


end.
