{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2012, Daniel Gaussmann
                   Website : www.gausi.de
                   EMail   : mail@gausi.de
    -----------------------------------
    contains parts of
        Audio Tools Library
        http://mac.sourceforge.net/atl/
        e-mail: macteam@users.sourceforge.net

        Copyright (c) 2000-2002 by Jurgen Faul
        Copyright (c) 2003-2005 by The MAC Team
    -----------------------------------

    Unit OggVorbisFiles

    Manipulate *.ogg files

    Limitations:
      - the Vorbis-Comments must fit into the second Ogg-Page.
        Comments spanning over two or more pages are NOT supported by this unit
      - => ogg files with cover-art, tagged by Mp3tag are probably NOT supported
      - The Vorbis-"Setup-Header" often starts on the second page, so the
        maximum size for comments is smaller than the maximum Ogg-Page-Size of
        255 * 255 Bytes

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

unit OggVorbisFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes,
  AudioFileBasics, VorbisComments, ID3Basics;


const
    OGG_PAGE_ID = 'OggS';

    // CRC table for checksum calculating
    CRC_TABLE: array [0..$FF] of Cardinal = (
        $00000000, $04C11DB7, $09823B6E, $0D4326D9, $130476DC, $17C56B6B,
        $1A864DB2, $1E475005, $2608EDB8, $22C9F00F, $2F8AD6D6, $2B4BCB61,
        $350C9B64, $31CD86D3, $3C8EA00A, $384FBDBD, $4C11DB70, $48D0C6C7,
        $4593E01E, $4152FDA9, $5F15ADAC, $5BD4B01B, $569796C2, $52568B75,
        $6A1936C8, $6ED82B7F, $639B0DA6, $675A1011, $791D4014, $7DDC5DA3,
        $709F7B7A, $745E66CD, $9823B6E0, $9CE2AB57, $91A18D8E, $95609039,
        $8B27C03C, $8FE6DD8B, $82A5FB52, $8664E6E5, $BE2B5B58, $BAEA46EF,
        $B7A96036, $B3687D81, $AD2F2D84, $A9EE3033, $A4AD16EA, $A06C0B5D,
        $D4326D90, $D0F37027, $DDB056FE, $D9714B49, $C7361B4C, $C3F706FB,
        $CEB42022, $CA753D95, $F23A8028, $F6FB9D9F, $FBB8BB46, $FF79A6F1,
        $E13EF6F4, $E5FFEB43, $E8BCCD9A, $EC7DD02D, $34867077, $30476DC0,
        $3D044B19, $39C556AE, $278206AB, $23431B1C, $2E003DC5, $2AC12072,
        $128E9DCF, $164F8078, $1B0CA6A1, $1FCDBB16, $018AEB13, $054BF6A4,
        $0808D07D, $0CC9CDCA, $7897AB07, $7C56B6B0, $71159069, $75D48DDE,
        $6B93DDDB, $6F52C06C, $6211E6B5, $66D0FB02, $5E9F46BF, $5A5E5B08,
        $571D7DD1, $53DC6066, $4D9B3063, $495A2DD4, $44190B0D, $40D816BA,
        $ACA5C697, $A864DB20, $A527FDF9, $A1E6E04E, $BFA1B04B, $BB60ADFC,
        $B6238B25, $B2E29692, $8AAD2B2F, $8E6C3698, $832F1041, $87EE0DF6,
        $99A95DF3, $9D684044, $902B669D, $94EA7B2A, $E0B41DE7, $E4750050,
        $E9362689, $EDF73B3E, $F3B06B3B, $F771768C, $FA325055, $FEF34DE2,
        $C6BCF05F, $C27DEDE8, $CF3ECB31, $CBFFD686, $D5B88683, $D1799B34,
        $DC3ABDED, $D8FBA05A, $690CE0EE, $6DCDFD59, $608EDB80, $644FC637,
        $7A089632, $7EC98B85, $738AAD5C, $774BB0EB, $4F040D56, $4BC510E1,
        $46863638, $42472B8F, $5C007B8A, $58C1663D, $558240E4, $51435D53,
        $251D3B9E, $21DC2629, $2C9F00F0, $285E1D47, $36194D42, $32D850F5,
        $3F9B762C, $3B5A6B9B, $0315D626, $07D4CB91, $0A97ED48, $0E56F0FF,
        $1011A0FA, $14D0BD4D, $19939B94, $1D528623, $F12F560E, $F5EE4BB9,
        $F8AD6D60, $FC6C70D7, $E22B20D2, $E6EA3D65, $EBA91BBC, $EF68060B,
        $D727BBB6, $D3E6A601, $DEA580D8, $DA649D6F, $C423CD6A, $C0E2D0DD,
        $CDA1F604, $C960EBB3, $BD3E8D7E, $B9FF90C9, $B4BCB610, $B07DABA7,
        $AE3AFBA2, $AAFBE615, $A7B8C0CC, $A379DD7B, $9B3660C6, $9FF77D71,
        $92B45BA8, $9675461F, $8832161A, $8CF30BAD, $81B02D74, $857130C3,
        $5D8A9099, $594B8D2E, $5408ABF7, $50C9B640, $4E8EE645, $4A4FFBF2,
        $470CDD2B, $43CDC09C, $7B827D21, $7F436096, $7200464F, $76C15BF8,
        $68860BFD, $6C47164A, $61043093, $65C52D24, $119B4BE9, $155A565E,
        $18197087, $1CD86D30, $029F3D35, $065E2082, $0B1D065B, $0FDC1BEC,
        $3793A651, $3352BBE6, $3E119D3F, $3AD08088, $2497D08D, $2056CD3A,
        $2D15EBE3, $29D4F654, $C5A92679, $C1683BCE, $CC2B1D17, $C8EA00A0,
        $D6AD50A5, $D26C4D12, $DF2F6BCB, $DBEE767C, $E3A1CBC1, $E760D676,
        $EA23F0AF, $EEE2ED18, $F0A5BD1D, $F464A0AA, $F9278673, $FDE69BC4,
        $89B8FD09, $8D79E0BE, $803AC667, $84FBDBD0, $9ABC8BD5, $9E7D9662,
        $933EB0BB, $97FFAD0C, $AFB010B1, $AB710D06, $A6322BDF, $A2F33668,
        $BCB4666D, $B8757BDA, $B5365D03, $B1F740B4);

type

    TPageBuffer = Array of Byte;

   { TOggVorbisError = (OVErr_None, OVErr_NoFile, OVErr_FileCreate,
          OVErr_FileOpenR, OVErr_FileOpenRW,
          OVErr_InvalidFirstPageHeader,
          OVErr_InvalidFirstPage,
          OVErr_InvalidSecondPageHeader,
          OVErr_InvalidSecondPage,
          OVErr_CommentTooLarge,
          OVErr_BackupFailed,
          OVErr_DeleteBackupFailed);

const
  OggVorbisErrorString: Array[TOggVorbisError] of String =
  ( 'No Error',
    'File not found',
    'FileCreate failed.',
    'FileOpenRead failed',
    'FileOpenReadWrite failed',
    'Invalid Ogg-Vorbis File: First Vorbis-Header corrupt',
    'Invalid Ogg-Vorbis File: First Ogg-Page corrupt',
    'Invalid Ogg-Vorbis File: Second Vorbis-Header corrupt',
    'Invalid Ogg-Vorbis File: Second Ogg-Page corrupt',
    'Comment too large (sorry, Flogger limitation)',
    'Backup failed',
    'Delete backup failed'
  );
       }

type

    { Ogg page header }
    TLacingValues = Array of Byte;
    TOggHeader = packed record
        // note: This is only the "constant part" of the header.
        // the lacing values have variable length and are not part of this record
        ID: array [1..4] of AnsiChar;    // "OggS"
        StreamVersion: Byte;             // Stream structure version
        TypeFlag: Byte;                  // Header type flag
        AbsolutePosition: Int64;         // Absolute granule position
        Serial: Integer;                 // Stream serial number
        PageNumber: Integer;             // Page sequence number
        Checksum: Cardinal;              // Page checksum
        Segments: Byte;                  // Number of page segments
    end;

    {
    TOggPage: Baseclass, read Header-Information
     - an Ogg-Header has variable length
    }
    TOggPage = class
        private
            fHeader: TOggHeader;          // the constant part of the OggHeader
            fLacingValues: TLacingValues; // the lacing-values (up to 255) of the OggHeader
            fValidHeader: Boolean;
            fValidPage: Boolean;
            fPositionInStream: Int64;
        public
            property ValidHeader: Boolean read fValidHeader;
            property ValidPage: Boolean read fValidPage;
            procedure ReadHeader(Source: TStream);
            procedure WriteHeader(Destination: TStream);
    end;

    {
    TFirstOggVorbisPage:
        the first page in an ogg-vorbis-bitstream.
        should be always 58 bytes.
    }
    TFirstOggVorbisPage = class(TOggPage)
        private
            fVorbisIdentification: TVorbisIdentification;
        public
            function ReadPage(Source: TStream): TAudioError;
            procedure ClearPage;
    end;

    {
    TSecondOggVorbisPage:
        the second page in an ogg-vorbis-bitstream.
        this page contains the vorbis-comments in the first packet
        and (the beginning of) the third OggVorbis-Header, which is not of interest for us
    }
    TSecondOggVorbisPage = class(TOggPage)
        private
            //fCommentSize is the size of the Vorbis-Comment-Packet in this page
            //  this is Comments.GetSizeInStream + (optional) padding
            //  the size of the padding cannot be computed by the VorbisComments-Class
            fCommentSize: Integer;
            RestOfPage: TPageBuffer;
            fLacingValuesRestOfPage: TLacingValues; // the lacing-values (up to 255) of the second (and other) Packet(s) in this page

        public
            Comments: TVorbisComments;

            constructor Create;
            destructor Destroy; override;
            function ReadPage(Source: TStream): TAudioError;
            function ReadPageForRewrite(Source: TStream): TAudioError;
            procedure ClearPage;
    end;

    {
    MainClass for tagging .ogg-Files
    }
    TOggVorbisFile = class(TBaseAudioFile)
        private
            fMaxSamples: Integer;
            fBitRateNominal: Word;

            fUsePadding: Boolean;

            function GetMaxSample(aStream: TStream): Integer;

            function fGetVersion     : UnicodeString;
            function fGetPerformer   : UnicodeString;
            function fGetCopyright   : UnicodeString;
            function fGetLicense     : UnicodeString;
            function fGetOrganization: UnicodeString;
            function fGetDescription : UnicodeString;
            function fGetLocation    : UnicodeString;
            function fGetContact     : UnicodeString;
            function fGetISRC        : UnicodeString;

            procedure fSetVersion     (value: UnicodeString);
            procedure fSetPerformer   (value: UnicodeString);
            procedure fSetCopyright   (value: UnicodeString);
            procedure fSetLicense     (value: UnicodeString);
            procedure fSetOrganization(value: UnicodeString);
            procedure fSetDescription (value: UnicodeString);
            procedure fSetLocation    (value: UnicodeString);
            procedure fSetContact     (value: UnicodeString);
            procedure fSetISRC        (value: UnicodeString);

            // ReadFirstTwoPages
            // used in the WriteToFile-method to get the existing two pages in the target-file
            function ReadFirstTwoPages(source: TStream; first: TFirstOggVorbisPage; second: TSecondOggVorbisPage): TAudioError;
            function BackUpRestOfFile(source: tStream; BackUpFilename: String): TAudioError;
            function AppendBackup(Destination: tStream; BackUpFilename: String): TAudioError;

        protected
            function fGetFileSize   : Int64;    override;
            function fGetDuration   : Integer;  override;
            function fGetBitrate    : Integer;  override;
            function fGetSamplerate : Integer;  override;
            function fGetChannels   : Integer;  override;
            function fGetValid      : Boolean;  override;

            function fGetTitle       : UnicodeString;  override;
            function fGetAlbum       : UnicodeString;  override;
            function fGetTrack       : UnicodeString;  override;
            function fGetArtist      : UnicodeString;  override;
            function fGetYear        : UnicodeString;  override;
            function fGetGenre       : UnicodeString;  override;

            procedure fSetTitle       (value: UnicodeString);  override;
            procedure fSetAlbum       (value: UnicodeString);  override;
            procedure fSetTrack       (value: UnicodeString);  override;
            procedure fSetArtist      (value: UnicodeString);  override;
            procedure fSetGenre       (value: UnicodeString);  override;
            procedure fSetYear        (value: UnicodeString);  override;

        public

            FirstOggVorbisPage: TFirstOggVorbisPage;
            SecondOggVorbisPage: TSecondOggVorbisPage;

            property Samples: Integer read fMaxSamples;
            //property Duration: Integer read fGetDuration;       // Duration (seconds)
            //property Bitrate: Word read fGetBitrate;
            //property Channels: Byte read FChannelModeID;

            property BitRateNominal: Word read FBitRateNominal; // Nominal bit rate
            //property ChannelModeID: Byte read FChannelModeID;   // Channel mode code

            property UsePadding: Boolean read fUsePadding write fUsePadding;

            //property Title       : UnicodeString read fGetTitle        write fSetTitle       ;
            property Version     : UnicodeString read fGetVersion      write fSetVersion     ;
            //property Album       : UnicodeString read fGetAlbum        write fSetAlbum       ;
            //property TrackNumber : UnicodeString read fGetTrackNumber  write fSetTrackNumber ;
            //property Artist      : UnicodeString read fGetArtist       write fSetArtist      ;
            property Performer   : UnicodeString read fGetPerformer    write fSetPerformer   ;
            property Copyright   : UnicodeString read fGetCopyright    write fSetCopyright   ;
            property License     : UnicodeString read fGetLicense      write fSetLicense     ;
            property Organization: UnicodeString read fGetOrganization write fSetOrganization;
            property Description : UnicodeString read fGetDescription  write fSetDescription ;
            //property Genre       : UnicodeString read fGetGenre        write fSetGenre       ;
            //property Date        : UnicodeString read fGetDate         write fSetDate        ;
            property Location    : UnicodeString read fGetLocation     write fSetLocation    ;
            property Contact     : UnicodeString read fGetContact      write fSetContact     ;
            property ISRC        : UnicodeString read fGetISRC         write fSetISRC        ;

            constructor Create;
            destructor Destroy; override;

            procedure ClearData;
            function ReadFromFile(aFilename: UnicodeString): TAudioError; override;
            function WriteToFile(aFilename: UnicodeString): TAudioError; override;
            function RemoveFromFile(aFilename: UnicodeString): TAudioError; override;

            function GetPropertyByFieldname(aField: String): UnicodeString;
            function SetPropertyByFieldname(aField: String; aValue: UnicodeString): Boolean;

            // Get All FieldNames in the CommentVectorList
            procedure GetAllFields(Target: TStrings);
            // Give Access to these Fields (note: Fieldnames dont have to be unique)
            function GetPropertyByIndex(aIndex: Integer): UnicodeString;
            function SetPropertyByIndex(aIndex: Integer; aValue: UnicodeString): Boolean;
    end;


implementation


procedure CalculateCRC(var CRC: Cardinal; Source: TStream);
var Buffer: Array of Byte;
    i: Integer;
begin
  // Calculate CRC
  SetLength(Buffer, Source.Size);
  Source.Seek(0, soBeginning);
  Source.Read(Buffer[0], Length(Buffer));
  for i := 0 to Length(Buffer) - 1 do
      CRC := (CRC shl 8) xor CRC_TABLE[((CRC shr 24) and $FF) xor Buffer[i]];
end;


{ TOggPage }

procedure TOggPage.ReadHeader(Source: TStream);
begin
    fPositionInStream := Source.Position;
    // read the constant part of the OggHeader from the current position in the stream
    Source.Read(fHeader, SizeOf(fHeader));
    // Check for valid ID
    fValidHeader := fHeader.ID = OGG_PAGE_ID;

    // read LacingValues
    Setlength(fLacingValues, fHeader.Segments);
    Source.Read(fLacingValues[0], length(fLacingValues));
end;

procedure TOggPage.WriteHeader(Destination: TStream);
begin
    Destination.Write(fHeader, SizeOf(fHeader));
    Destination.Write(fLacingValues[0], length(fLacingValues));
end;

{ TFirstOggVorbisPage }

procedure TFirstOggVorbisPage.ClearPage;
begin
    fVorbisIdentification.PacketType := 0;
    fVorbisIdentification.ID := '123456';
    fVorbisIdentification.BitstreamVersion := 0;
    fVorbisIdentification.ChannelMode := 0;
    fVorbisIdentification.SampleRate := 0;
    fVorbisIdentification.BitRateMaximal := 0;
    fVorbisIdentification.BitRateNominal := 0;
    fVorbisIdentification.BitRateMinimal := 0;
    fVorbisIdentification.BlockSize := 0;
    fVorbisIdentification.StopFlag := 0;
end;

function TFirstOggVorbisPage.ReadPage(Source: TStream): TAudioError;
var id3: Integer;
begin
    // check for ID3v2-Tag and skip it
    id3 := GetID3Size(Source);
    Source.Seek(id3, soBeginning);

    ReadHeader(Source);

    // Check some properties
    // - the Header must be Valid
    if not ValidHeader then
    begin
        result := OVErr_InvalidFirstPageHeader;
        fValidPage := False;
        exit;
    end;

    // - the first Vorbis-Header has always 30 Bytes
    if (length(fLacingValues) <> 1) or (fLacingValues[0] <> 30) then
    begin
        result := OVErr_InvalidFirstPage;
        fValidPage := False;
        exit;
    end;

    // ok, the first OggPage seems to be ok
    // Read VorbisIdentification-Header
    Source.Read(fVorbisIdentification, SizeOf(fVorbisIdentification));

    // check the content of the VorbisIdentification-Header
    fValidPage :=
             (fVorbisIdentification.PacketType = 1)
         and (fVorbisIdentification.ID = 'vorbis')
         //and (fVorbisIdentification.BitstreamVersion = 0)
         and (fVorbisIdentification.ChannelMode > 0)
         and (fVorbisIdentification.SampleRate > 0)
         and (fVorbisIdentification.StopFlag <> 0);

    if fValidPage then
        result := FileErr_None
    else
        result := OVErr_InvalidFirstPage;
end;

{ TSecondOggVorbisPage }

procedure TSecondOggVorbisPage.ClearPage;
begin
    fCommentSize := 0;
    SetLength(RestOfPage, 0);
    SetLength(fLacingValuesRestOfPage, 0);
    Comments.Clear;
end;

constructor TSecondOggVorbisPage.Create;
begin
    Comments := TVorbisComments.Create;
end;

destructor TSecondOggVorbisPage.Destroy;
begin
    Comments.Free;
    inherited;
end;

function TSecondOggVorbisPage.ReadPage(Source: TStream): TAudioError;
var i: integer;
begin
    ReadHeader(Source);

    // Check some properties
    // - the Header must be Valid
    if not ValidHeader then
    begin
        result := OVErr_InvalidSecondPageHeader;
        fValidPage := False;
        exit;
    end;
    // ok, the second OggPage seems to be ok
    // read the comments now

    // first: compute the size
    // the size is needed, as sometimes the pure comments are followed by some
    // padding, which cannot be handled by the TVorbisComments class itself
    fCommentSize := 0;
    i := -1;
    repeat
        inc(i);
        fCommentSize := fCommentSize + fLacingValues[i];
    until (i >= length(fLacingValues) - 1) or (fLacingValues[i] <> 255)  ;

    //if (fCommentSize < 255*255) and () then

    if (i < length(fLacingValues)-1) or (fLacingValues[length(fLacingValues)-1] <> 255) then
    begin
        if Comments.ReadFromStream(source, fCommentSize) then
            result := FileErr_None
        else
            result := OVErr_InvalidSecondPage;
    end else
        result := OVErr_CommentTooLarge;
end;


function TSecondOggVorbisPage.ReadPageForRewrite(
  Source: TStream): TAudioError;
var i, first, datasize: Integer;
begin
    // read the first part of the page (i.e. the Vorbis-Comments)
    result := ReadPage(Source);
    // note: It is important that we set the position in the stream properly
    // i.e. the postion in the Stream is now at the first byte after the Comment-Packet
    //      (this includes padding)

    if result = FileErr_None then
    begin
        // store rest of the page in the TPageBuffer
        // get the lacing values for this part
        first := -1;
        for i := 0 to length(fLacingValues) - 1 do
        begin
            if fLacingValues[i] <> 255 then
            begin
                first := i+1;
                break;
            end;
        end;

        if first <= length(fLacingValues) - 1 then
        begin
            // we have other data in this page
            // save the lacingValues of the Rest of the page (we need them later)
            SetLength(fLacingValuesRestOfPage, length(fLacingValues) - first);
            datasize := 0;
            for i := first to length(fLacingValues) - 1 do
            begin
                datasize := datasize + fLacingValues[i];
                fLacingValuesRestOfPage[i - first] := fLacingValues[i];
            end;
            SetLength(RestOfPage, datasize);
            Source.Read(RestOfPage[0], datasize);
        end else
        begin
            // we have no other data in this page
            SetLength(RestOfPage, 0);
            SetLength(fLacingValuesRestOfPage, 0);
        end;
        result := FileErr_None;
    end;
end;

{ TOggVorbisFile }

constructor TOggVorbisFile.Create;
begin
    FirstOggVorbisPage := TFirstOggVorbisPage.Create;
    SecondOggVorbisPage:= TSecondOggVorbisPage.Create;
    ClearData;
end;

destructor TOggVorbisFile.Destroy;
begin
    FirstOggVorbisPage.Free;
    SecondOggVorbisPage.Free;
    inherited;
end;

procedure TOggVorbisFile.ClearData;
begin
    fFileSize       := 0;
    fMaxSamples     := 0;
    fSampleRate     := 0;
    fBitRateNominal := 0;
    fValid          := False;
    //fChannelModeID  := 0;
    fChannels       := 0;
    fUsePadding     := True;
    FirstOggVorbisPage.ClearPage;
    SecondOggVorbisPage.ClearPage;
end;


{
  Getter for properties
}
function TOggVorbisFile.fGetAlbum: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Album;
end;
function TOggVorbisFile.fGetArtist: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Artist;
end;
function TOggVorbisFile.fGetContact: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Contact;
end;
function TOggVorbisFile.fGetCopyright: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Copyright;
end;
function TOggVorbisFile.fGetYear: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Date;
end;
function TOggVorbisFile.fGetDescription: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Description;
end;
function TOggVorbisFile.fGetGenre: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Genre;
end;
function TOggVorbisFile.fGetISRC: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.ISRC;
end;
function TOggVorbisFile.fGetLicense: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.License;
end;
function TOggVorbisFile.fGetLocation: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Location;
end;
function TOggVorbisFile.fGetOrganization: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Organization;
end;
function TOggVorbisFile.fGetPerformer: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Performer;
end;
function TOggVorbisFile.fGetTitle: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Title;
end;
function TOggVorbisFile.fGetTrack: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.TrackNumber;
end;
function TOggVorbisFile.fGetVersion: UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.Version;
end;

{
  Setter for properties
}
procedure TOggVorbisFile.fSetAlbum(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Album := value;
end;
procedure TOggVorbisFile.fSetArtist(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Artist := value;
end;
procedure TOggVorbisFile.fSetContact(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Contact := value;
end;
procedure TOggVorbisFile.fSetCopyright(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Copyright := value;
end;
procedure TOggVorbisFile.fSetYear(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Date := value;
end;
procedure TOggVorbisFile.fSetDescription(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Description := value;
end;
procedure TOggVorbisFile.fSetGenre(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Genre := value;
end;
procedure TOggVorbisFile.fSetISRC(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.ISRC := value;
end;
procedure TOggVorbisFile.fSetLicense(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.License := value;
end;
procedure TOggVorbisFile.fSetLocation(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Location := value;
end;
procedure TOggVorbisFile.fSetOrganization(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Organization := value;
end;
procedure TOggVorbisFile.fSetPerformer(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Performer := value;
end;
procedure TOggVorbisFile.fSetTitle(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Title := value;
end;
procedure TOggVorbisFile.fSetTrack(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.TrackNumber := value;
end;
procedure TOggVorbisFile.fSetVersion(value: UnicodeString);
begin
    SecondOggVorbisPage.Comments.Version := value;
end;

// This function is copied from the "AudioToolsLibrary"
function TOggVorbisFile.GetMaxSample(aStream: TStream): Integer;
var
  Index, DataIndex, Iterator: Integer;
  Data: array [0..250] of AnsiChar;
  Header: TOggHeader;
begin
    // Get total number of samples }
    Result := 0;
    for Index := 1 to 50 do
    begin
      DataIndex := aStream.Size - (SizeOf(Data) - 16) * Index - 16;
      aStream.Seek(DataIndex, soBeginning);
      aStream.Read(Data, SizeOf(Data));
      // Get number of PCM samples from last Ogg packet header
      // Search for an OggPage-ID from the end of the File
      for Iterator := SizeOf(Data) - 16 downto 0 do
          if Data[Iterator] +
             Data[Iterator + 1] +
             Data[Iterator + 2] +
             Data[Iterator + 3] = OGG_PAGE_ID then
          begin
              // found it! Read header and return the AbsolutePosition (=MaxSample in OggVorbis)
              aStream.Seek(DataIndex + Iterator, soBeginning);
              aStream.Read(Header, SizeOf(Header));
              Result := Header.AbsolutePosition;
              exit;
          end;
    end;
end;

procedure TOggVorbisFile.GetAllFields(Target: TStrings);
begin
    SecondOggVorbisPage.Comments.GetAllFields(Target);
end;

function TOggVorbisFile.GetPropertyByFieldname(aField: String): UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.GetPropertyByFieldname(aField);
end;

function TOggVorbisFile.SetPropertyByIndex(aIndex: Integer;
  aValue: UnicodeString): Boolean;
begin
    result := SecondOggVorbisPage.Comments.SetPropertyByIndex(aIndex, aValue);
end;

function TOggVorbisFile.SetPropertyByFieldname(aField: String;
  aValue: UnicodeString): Boolean;
begin
    result := SecondOggVorbisPage.Comments.SetPropertyByFieldname(aField, aValue);
end;

function TOggVorbisFile.GetPropertyByIndex(aIndex: Integer): UnicodeString;
begin
    result := SecondOggVorbisPage.Comments.GetPropertyByIndex(aIndex);
end;

function TOggVorbisFile.fGetFileSize   : Int64;
begin
    result := fFileSize;
end;

function TOggVorbisFile.fGetSamplerate : Integer;
begin
    result := fSampleRate;
end;

function TOggVorbisFile.fGetChannels   : Integer;
begin
    result := fChannels;
end;
function TOggVorbisFile.fGetValid : Boolean;
begin
    result := fValid;
end;

// This function is copied from the "AudioToolsLibrary"
function TOggVorbisFile.fGetDuration: Integer;
begin
  // Calculate duration time
  if fMaxSamples > 0 then
      if fSampleRate > 0 then
          Result := Round(fMaxSamples / fSampleRate)
      else
          Result := 0
  else
      if (fBitRateNominal > 0) and (fChannels > 0) then
          Result := Round((fFileSize {- FID3v2Size}) /
              fBitRateNominal / fChannels / 125 * 2)
      else
          Result := 0;
end;

function TOggVorbisFile.fGetBitrate: Integer;
begin
    // Calculate average bit rate
    if fGetDuration > 0 then
        result := Round((fFileSize * 8 {- FID3v2Size}) / fGetDuration)
    else
        result := fBitRateNominal * 1000;
end;


function TOggVorbisFile.ReadFirstTwoPages(source: TStream;
  first: TFirstOggVorbisPage; second: TSecondOggVorbisPage): TAudioError;
begin
    result := First.ReadPage(Source);
    if result = FileErr_None then
        result := Second.ReadPageForRewrite(Source);
end;

function TOggVorbisFile.BackUpRestOfFile(source: tStream; BackUpFilename: String): TAudioError;
var fs: TFileStream;
begin
    try
        fs := TFileStream.Create(BackupFilename, fmCreate);
        try
            fs.CopyFrom(source, source.Size - source.Position);
            result := FileErr_None;
        finally
            fs.Free;
        end;
    except
        result := FileErr_FileCreate
    end;
end;

function TOggVorbisFile.AppendBackup(Destination: tStream; BackUpFilename: String): TAudioError;
var fs: TFileStream;
begin
    try
        fs := TFileStream.Create(BackupFilename, fmOpenread);
        try
            Destination.CopyFrom(fs, 0);
            result := FileErr_None;
        finally
            fs.Free;
        end;
    except
        result := OVErr_BackupFailed;
    end;
end;

function TOggVorbisFile.ReadFromFile(aFilename: UnicodeString): TAudioError;
var fs: TFileStream;
begin
    ClearData;
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TFileStream.Create(aFileName, fmOpenRead or fmShareDenyWrite);
            try
                fFileSize := fs.Size;

                // read first Ogg-Page
                result := FirstOggVorbisPage.ReadPage(fs);

                // read second Ogg-Page
                if result = FileErr_None then
                    result := SecondOggVorbisPage.ReadPage(fs);

                // set some private variables from these two pages
                if result = FileErr_None then
                begin
                    fSampleRate    := FirstOggVorbisPage.fVorbisIdentification.SampleRate;
                    fChannels      := FirstOggVorbisPage.fVorbisIdentification.ChannelMode;
                    fBitRateNominal:= FirstOggVorbisPage.fVorbisIdentification.BitRateNominal;
                    fMaxSamples := GetMaxSample(fs);
                    fValid := True;
                end else
                    fValid := False;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenR;
        end;
    end else
        result := FileErr_NoFile;
end;


function TOggVorbisFile.WriteToFile(aFilename: UnicodeString): TAudioError;
var fs: TFileStream;
    tmpStream: TMemoryStream;

    localFirstOggVorbisPage: TFirstOggVorbisPage;
    localSecondOggVorbisPage: TSecondOggVorbisPage;

    newSize, oldSize: Integer;
    Buffer: Array of Byte;
    newCRC: Cardinal;
    i, newLacingCount: Integer;
    tmpSegments: Integer;

begin
    if AudioFileExists(aFilename) then
    begin
        try
            fs := TFileStream.Create(aFilename, fmOpenReadWrite or fmShareDenyWrite);
            try
                localFirstOggVorbisPage := TFirstOggVorbisPage.Create;
                localSecondOggVorbisPage:= TSecondOggVorbisPage.Create;
                try
                    result := ReadFirstTwoPages(fs, localFirstOggVorbisPage, localSecondOggVorbisPage);
                    // these two pages contain now the existing content of the file

                    if result = FileErr_None then
                    begin
                        // get the needed size for the current comments we want to write here
                        newSize := SecondOggVorbisPage.Comments.GetSizeInStream;
                        oldSize := localSecondOggVorbisPage.fCommentSize;
                        if (oldSize = newSize) or ((oldSize >= newSize) and fUsePadding) then
                        begin
                            // we dont have to rewrite the whole file
                            // rewrite just the second page
                            tmpStream := TMemoryStream.Create;
                            try
                                SecondOggVorbisPage.fHeader.Checksum := 0;
                                SecondOggVorbisPage.WriteHeader(tmpStream); // Constant Header incl. Lacing values (they remain the same)
                                SecondOggVorbisPage.Comments.WriteToStream(tmpStream);
                                if oldSize <> newSize then
                                begin
                                    // add some padding
                                    SetLength(Buffer, oldSize - newSize);
                                    FillChar(Buffer[0], oldSize - newSize, 0);
                                    tmpStream.Write(Buffer[0], oldSize - newSize);
                                end;
                                tmpStream.Write(localSecondOggVorbisPage.RestOfPage[0], length(localSecondOggVorbisPage.RestOfPage));
                                // Calculate the crc for the new second page
                                newCRC := 0;
                                CalculateCRC(newCRC, tmpStream);
                                // write the new crc into the tmpstream
                                SecondOggVorbisPage.fHeader.Checksum := newCRC;
                                tmpStream.Seek(0, soBeginning);
                                SecondOggVorbisPage.WriteHeader(tmpStream);
                                // copy the tmpStream to fs
                                //fs.Seek(SecondOggVorbisPage.fPositionInStream, soFromBeginning);
                                fs.Seek(localSecondOggVorbisPage.fPositionInStream, soBeginning);
                                fs.CopyFrom(tmpStream, 0)
                            finally
                                tmpStream.Free;
                            end;

                        end else
                        begin
                            // we have to rewrite the whole file :(
                            if fUsePadding then                         // Padding here: 255 bytes (i.e. one more lacing value)
                                newLacingCount := (newSize Div 255) + 2 // +2 = 1 for "mod 255" + 1 extra-size
                            else
                                newLacingCount := (newSize Div 255) + 1; // exact size

                            // the maximum number of segments in a page is 255
                            tmpSegments := newLacingCount + length(localSecondOggVorbisPage.fLacingValuesRestOfPage);
                            if tmpSegments > 255 then
                            begin
                                // Comments too large
                                result := OVErr_CommentTooLarge;
                            end else
                            begin
                                // ok, the comments fit into the second page
                                result := BackUpRestOfFile(fs, aFilename + '~');
                                if result = FileErr_None then
                                begin
                                    // set new lacing values ...
                                    SecondOggVorbisPage.fHeader.Segments := tmpSegments;
                                    SetLength(SecondOggVorbisPage.fLacingValues, tmpSegments);
                                    // ... write Values for new Comments
                                    for i := 0 to newLacingCount - 2 do
                                        SecondOggVorbisPage.fLacingValues[i] := 255;
                                    SecondOggVorbisPage.fLacingValues[newLacingCount-1] := (newSize Mod 255);
                                    // ... copy values from RestOfPage
                                    for i := newLacingCount to SecondOggVorbisPage.fHeader.Segments - 1  do
                                        SecondOggVorbisPage.fLacingValues[i] :=
                                            localSecondOggVorbisPage.fLacingValuesRestOfPage[i-newLacingCount];

                                    // build new SecondPage into tmpStream
                                    tmpStream := TMemoryStream.Create;
                                    try
                                        SecondOggVorbisPage.fHeader.Checksum := 0;
                                        SecondOggVorbisPage.WriteHeader(tmpStream); // Constant Header incl. Lacing values (they remain the same)
                                        SecondOggVorbisPage.Comments.WriteToStream(tmpStream);
                                        if fUsePadding then
                                        begin
                                            // add 255 Bytes of padding
                                            SetLength(Buffer, 255);
                                            FillChar(Buffer[0], 255, 0);
                                            tmpStream.Write(Buffer[0], 255);
                                        end;
                                        tmpStream.Write(localSecondOggVorbisPage.RestOfPage[0], length(localSecondOggVorbisPage.RestOfPage));
                                        // Calculate the crc for the new second page
                                        newCRC := 0;
                                        CalculateCRC(newCRC, tmpStream);
                                        // write the new crc into the tmpstream
                                        SecondOggVorbisPage.fHeader.Checksum := newCRC;
                                        tmpStream.Seek(0, soBeginning);
                                        SecondOggVorbisPage.WriteHeader(tmpStream);

                                        // rewrite the file
                                        // copy the tmpStream to fs
                                        ///  fs.Seek(SecondOggVorbisPage.fPositionInStream, soFromBeginning);
                                        fs.Seek(localSecondOggVorbisPage.fPositionInStream, soBeginning);

                                        fs.CopyFrom(tmpStream, 0);
                                        // append the backup to the file
                                        result := AppendBackup(fs, aFilename + '~');
                                        if result = FileERR_None then
                                        begin
                                            // Set End of File here (in case noPdding and new Comments are smaller)
                                            SetEndOfFile((fs as THandleStream).Handle);

                                            //delete backupfile
                                            if not DeleteFile(aFilename + '~') then
                                                result := OVErr_DeleteBackupFailed;
                                        end;
                                    finally
                                        tmpStream.Free;
                                    end;
                                end;
                            end;
                        end;
                    end;
                finally
                    localFirstOggVorbisPage.Free;
                    localSecondOggVorbisPage.Free;
                end;
            finally
                fs.Free;
            end;
        except
            result := FileErr_FileOpenRW;
        end;
    end
    else
        result := FileErr_NoFile;
end;

function TOggVorbisFile.RemoveFromFile(aFilename: UnicodeString): TAudioError;
begin
    result := OVErr_RemovingNotSupported;
end;

end.
