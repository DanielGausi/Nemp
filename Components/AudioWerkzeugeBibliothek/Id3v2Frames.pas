{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2012, Daniel Gaussmann
              Website : www.gausi.de
              EMail   : mail@gausi.de
    -----------------------------------

    Unit ID3v2Frames

    Helper class for the ID3v2Tag-Frames

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

unit ID3v2Frames;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, dialogs, U_CharCode
  {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF};


type

  {$IFDEF USE_TNT_COMPOS}
      TMPFUFileStream = TTNTFileStream;
  {$ELSE}
      TMPFUFileStream = TFileStream;
  {$ENDIF}

  {$IFNDEF UNICODE}
      UnicodeString = WideString;
  {$ENDIF}

  TID3v2FrameTypes = (FT_INVALID, FT_UNKNOWN,
                      FT_TextFrame,
                      FT_CommentFrame,
                      FT_LyricFrame,
                      FT_UserDefinedURLFrame,
                      FT_PictureFrame,
                      FT_PopularimeterFrame,
                      FT_URLFrame,
                      FT_UserTextFrame
                      );

  TID3v2FrameVersions = (FV_2 = 2, FV_3, FV_4);

    // flags in frame-header
    // the unknown-flags are used to clear the flags on writing
  TFrameFlags = (FF_TagAlter, FF_FileAlter, FF_ReadOnly, FF_UnknownStatus,
                 FF_Compression, FF_Encryption, FF_GroupID, FF_Unsync, FF_DataLength, FF_UnknownFormat);

const TFrameFlagValues : Array [TID3v2FrameVersions] of Array [TFrameFlags] of Byte =
             (
              (0,0,0,0,0,0,0,0,0,0),  // no flags in subversion 2.2
              (128, 64, 32, 31, 128, 64, 32, 0, 0, 31 ),
              (128, 64, 32, 31,   8,  4, 64, 2, 1, 176)
             );
Type TFrameIDs = (
  IDv2_UNKNOWN,
  IDv2_MP3FileUtilsExperimental, // WARNING. DO NOT USE THIS FRAME. It's for testing only!
  // Text-Frames
  IDv2_ARTIST, IDv2_TITEL, IDv2_ALBUM, IDv2_YEAR, IDv2_GENRE,  // ----
  IDv2_TRACK, IDv2_COMPOSER, IDv2_ORIGINALARTIST, IDv2_COPYRIGHT, IDv2_ENCODEDBY, // ----
  IDv2_LANGUAGES, IDv2_SOFTWARESETTINGS, IDv2_MEDIATYPE, IDv2_LENGTH, IDv2_PUBLISHER,  // ----
  IDv2_ORIGINALFILENAME, IDv2_ORIGINALLYRICIST, IDv2_ORIGINALRELEASEYEAR, IDv2_ORIGINALALBUMTITEL,// ---- // til here: textframes from mp3fileutils 0.3
  IDv2_BPM, IDv2_PLAYLISTDELAY, IDv2_FILETYPE, IDv2_INITIALKEY, IDv2_BANDACCOMPANIMENT, // ----
  IDv2_CONDUCTORREFINEMENT, IDv2_INTERPRETEDBY, IDv2_PARTOFASET, IDv2_ISRC, IDv2_CONTENTGROUPDESCRIPTION,  // ----
  IDv2_SUBTITLEREFINEMENT, IDv2_LYRICIST, IDv2_FILEOWNER, IDv2_INTERNETRADIONAME, IDv2_INTERNETRADIOOWNER, // ----
  // following textframes exists only in subversion 2.4
  IDv2_ENCODINGTIME, IDv2_RECORDINGTIME, IDv2_RELEASETIME, IDv2_TAGGINGTIME, IDv2_MUSICIANCREDITLIST, //----
  IDv2_MOOD, IDv2_PRODUCEDNOTICE, IDv2_ALBUMSORTORDER, IDv2_PERFORMERSORTORDER, IDv2_TITLESORTORDER, IDv2_SETSUBTITLE,
  //---
  // User-defined Text-Frames
  IDv2_USERDEFINEDTEXT,
  //----//----//----
  // URL-Frames
  IDv2_AUDIOFILEURL, IDv2_ARTISTURL, IDv2_AUDIOSOURCEURL, IDv2_COMMERCIALURL, IDv2_COPYRIGHTURL,
  IDv2_PUBLISHERSURL, IDv2_RADIOSTATIONURL, IDv2_PAYMENTURL,
  //----//----
  // more Frames
  IDv2_PICTURE, IDv2_LYRICS, IDv2_COMMENT, IDv2_RATING, IDv2_USERDEFINEDURL, IDv2_RECOMMENDEDBUFFERSIZE, //----
  IDv2_PLAYCOUNTER, IDv2_AUDIOENCRYPTION, IDv2_EVENTTIMINGCODES, IDv2_EQUALIZATION, IDv2_GENERALOBJECT, //----
  IDv2_LINKEDINFORMATION, IDv2_MUSICCDID, IDv2_MPEGLOOKUPTABLE, IDv2_REVERB, IDv2_VOLUMEADJUSTMENT,    //----
  IDv2_SYNCHRONIZEDLYRICS, IDv2_SYNCEDTEMPOCODES, IDv2_UNIQUEFILEID,
  // Frames, which exists only in some subversions
  IDv2_COMMERCIALFRAME, IDv2_ENCRYPTIONMETHODREGISTRATION, IDv2_GROUPIDREGISTRATION, IDv2_OWNERSHIP,
  IDv2_PRIVATE, IDv2_POSITIONSYNCHRONISATION, IDv2_TERMSOFUSE, IDv2_SEEKPOINTINDEX, IDv2_SEEKFRAME,
  IDv2_SIGNATURE,
  // more frames, should NOT be created
  IDv2_INVOLVEDPEOPLE, IDv2_ENCRYPTEDMETAFRAME, IDv2_RECORDINGDATES, IDv2_DATE, IDv2_TIME, IDv2_SIZE
  )  ;


type

  TTextEncoding = (TE_Ansi, TE_UTF16, TE_UTF16BE, UTF8);

  // Type for this one big const-array "ID3v2KnownFrames" (scroll down to see it)
  TID3v2FrameDescriptionData = record
      IDs: Array[TID3v2FrameVersions] of AnsiString;           // MUST be AnsiString
      Description: String;                                     // Doesn't matter, use Delphi-Default
  end;


  TBuffer = Array of byte;

  TID3v2Frame = class(TObject)
      private

          fVersion: TID3v2FrameVersions;  //(2,3,4)
          fIDString: AnsiString;          // e.g. 'TALB', must be AnsiString
          fID: TFrameIDs;                 // e.G. IDv2_ARTIST
          fHeader: TBuffer;
          fData: TBuffer;
          fGroupID: Byte;
          fDataLength: Integer; // this is the size given in v2.4, in case the according flag is set

          fAlwaysWriteUnicode: Boolean;
          fAutoCorrectCodepage: Boolean; // formerly fAcceptAllEncodings
          fCharCode: TCodePage;

          fParsable: Boolean;

          function ValidFrameID: Boolean;
          function GetFrameType: TID3v2FrameTypes;    // Textframe, URLFrame, Picture-Frame, etc...
          function GetFrameTypeDescription: String;   // Description of content according to ID3.org
                                                      // use Delphi-Default-String, its just for displaying the info
          function GetFrameTypeID: TFrameIDs;

          // Get teh flags of the frame
          // "Unimportant Flags"
          // Note for future versions: Do what they want me to do ;-)
          function GetFlagTagAlterPreservation: Boolean;
          function GetFlagFileAlterPreservation: Boolean;
          function GetFlagReadOnly: Boolean;
          // "Important Flags", they change the way how the frame must be parsed
          function GetFlagCompression: Boolean;
          function GetFlagEncryption : Boolean;
          function GetFlagGroupingIdentity : Boolean;
          procedure SetFlagGroupingIdentity(Value: Boolean);
          function GetFlagUnsynchronisation : Boolean;
          function GetFlagDataLengthIndicator : Boolean;
          function GetUnknownStatusFlags: Boolean;
          function GetUnknownEncodingFlags: Boolean;

          procedure SetFlag(aFlag: TFrameFlags);
          procedure UnSetFlag(aFlag: TFrameFlags);

          procedure UnSetFlagSomeFlagsAfterDataSet;

          function GetDataSize: Integer;

          procedure SyncStream(Source, Target: TStream; aSize: Integer);
          procedure UpdateHeader(aSize: Integer = -1); // Update the size-field in frame-header

          function IsUnicodeNeeded(aString: UnicodeString): Boolean;   // Must be Unicodestring - otherwise senseless. ;-)

          // Reads Bytes from "Start" to "Ende" into an UnicodeString
          // Must be UnicodeString
          function GetConvertedUnicodeText(Start, Ende: integer; TextEncoding: TTextEncoding): UnicodeString;
          // Write Value to fData
          function WideStringToData(Value: UnicodeString; start: integer; UnicodeIsNeeded: Boolean): integer;
          function AnsiStringToData(Value: AnsiString; start: integer): integer;

      public
          property FrameType: TID3v2FrameTypes read GetFrameType;
          property FrameTypeDescription: String read GetFrameTypeDescription;   // Delphi-Default-String
          property FrameIDString: AnsiString read fIDString;                    // Must be AnsiString
          property FrameID: TFrameIDs read GetFrameTypeID;

          property FlagTagAlterPreservation : Boolean read  GetFlagTagAlterPreservation;
          property FlagFileAlterPreservation: Boolean read  GetFlagFileAlterPreservation;
          property FlagReadOnly             : Boolean read  GetFlagReadOnly;

          property FlagCompression          : Boolean read  GetFlagCompression;
          property FlagEncryption           : Boolean read  GetFlagEncryption;
          property FlagGroupingIndentity    : Boolean read  GetFlagGroupingIdentity write SetFlagGroupingIdentity;
          property FlagUnsynchronisation    : Boolean read  GetFlagUnsynchronisation;
          property FlagDataLengthIndicator  : Boolean read  GetFlagDataLengthIndicator;
          property FlagUnknownStatus        : Boolean read  GetUnknownStatusFlags;
          property FlagUnknownEncoding      : Boolean read  GetUnknownEncodingFlags;

          property GroupID  : Byte read fGroupID write fGroupID;

          // The size of Data after a Re-Synchronisation
          // On Parsable-Frames:  GroupID and DataLength are NOT included,
          //                      otherwise included
          property DataSize : Integer read  GetDataSize;

          property AlwaysWriteUnicode: Boolean read fAlwaysWriteUnicode write fAlwaysWriteUnicode;

          property CharCode: TCodePage read fCharCode write fCharCode;
          property AutoCorrectCodepage: Boolean read fAutoCorrectCodepage write fAutoCorrectCodepage;

          constructor Create(aID: AnsiString; aVersion: TID3v2FrameVersions); // must be AnsiString

          procedure ReadFromStream(aStream: tStream); // Note: Read only data - Header is already readed
          procedure WriteToStream(aStream: tStream);  // Write (including header)
          // WARNING: Use WriteUnsyncedToStream ONLY FOR subversion 2.4 !
          // on 2.2/2.3 unsynchronisation is done on Tag-Level, i.e. frames will
          // be written NOT unsynched
          procedure WriteUnsyncedToStream(aStream: TStream);

          // Texts, Lyrics: Unicode
          // Language-IDs, Mime: Ansi
          // Descriptions: Unicode
          // URLs: Ansi
          function GetText: UnicodeString;
          procedure SetText(Value: UnicodeString);

          function GetUserText(out Description: UnicodeString): UnicodeString;
          procedure SetUserText(Description, Value: UnicodeString);

          function GetCommentsLyrics(out Language: AnsiString; out Description: UnicodeString): UnicodeString;
          procedure SetCommentsLyrics(Language: AnsiString; Description, Value: UnicodeString);

          function GetUserdefinedURL(out Description: UnicodeString): AnsiString;
          procedure SetUserdefinedURL(Description: UnicodeString; URL: AnsiString);

          function GetURL: AnsiString;
          procedure SetURL(Value: AnsiString);

          function GetPicture(out Mime: AnsiString; out PicType: Byte; out Description: UnicodeString; PictureData: TStream): Boolean;
          procedure SetPicture(Mime: AnsiString; PicType: Byte; Description: UnicodeString; PictureData: TStream);

          function GetRating(out UserEMail: AnsiString): Byte;
          procedure SetRating(UserEMail: AnsiString; Value: Byte);

          // PersonalCounter:
          // This is the Counter within the Popularimeter(=Rating)-Frames
          // NOT the PCNT-Frame!
          function GetPersonalPlayCounter(out UserEMail: AnsiString): Cardinal;
          procedure SetPersonalPlayCounter(UserEMail: AnsiString; Value: Cardinal);

          // Private Frames
          function GetPrivateFrame(out OwnerID: AnsiString; Data: TStream): Boolean;
          procedure SetPrivateFrame(aOwnerID: AnsiString; Data: TStream);

          procedure GetData(Data: TStream);
          // WARNING. Use SetData only, when you exactly know what you are doing
          // Seriously. Do not use it!
          procedure SetData(Data: TStream);
  end;





const  ID3v2KnownFrames : Array[TFrameIDs] of TID3v2FrameDescriptionData =

        (  //  DO NOT CHANGE ORDER (without changing the enum-type as well)
           // Text-Frames
           ( IDs: ('XXX', 'XXXX', 'XXXX') ; Description : 'Unknown/experimental Frame'),
           ( IDs: ('XMP', 'XMP3', 'XMP3') ; Description : 'Mp3FileUtils experimental Frame'),
           ( IDs: ('TP1', 'TPE1', 'TPE1') ; Description : 'Lead artist(s)/Lead performer(s)/Soloist(s)/Performing group'),
           ( IDs: ('TT2', 'TIT2', 'TIT2') ; Description : 'Title/Songname/Content description'),
           ( IDs: ('TAL', 'TALB', 'TALB') ; Description : 'Album/Movie/Show title'),
           ( IDs: ('TYE', 'TYER', 'TDRC') ; Description : 'Year'),
           ( IDs: ('TCO', 'TCON', 'TCON') ; Description : 'Content type'),
           // ----
           ( IDs: ('TRK', 'TRCK', 'TRCK') ; Description : 'Track number/Position in set'),
           ( IDs: ('TCM', 'TCOM', 'TCOM') ; Description : 'Composer'),
           ( IDs: ('TOA', 'TOPE', 'TOPE') ; Description : 'Original artist(s)/performer(s)'),
           ( IDs: ('TCR', 'TCOP', 'TCOP') ; Description : 'Copyright message'),
           ( IDs: ('TEN', 'TENC', 'TENC') ; Description : 'Encoded by'),
           // ----
           ( IDs: ('TLA', 'TLAN', 'TLAN') ; Description : 'Language(s)'),
           ( IDs: ('TSS', 'TSSE', 'TSSE') ; Description : 'Software/hardware and settings used for encoding'),
           ( IDs: ('TMT', 'TMED', 'TMED') ; Description : 'Media type'),
           ( IDs: ('TLE', 'TLEN', 'TLEN') ; Description : 'Length'),
           ( IDs: ('TPB', 'TPUB', 'TPUB') ; Description : 'Publisher'),
           // ----
           ( IDs: ('TOF', 'TOFN', 'TOFN') ; Description : 'Original filename'),
           ( IDs: ('TOL', 'TOLY', 'TOLY') ; Description : 'Original Lyricist(s)/text writer(s)'),
           ( IDs: ('TOR', 'TORY', 'TDOR') ; Description : 'Original release year'),

           ( IDs: ('TOT', 'TOAL', 'TOAL') ; Description : 'Original album/Movie/Show title'),
           // ----//til here textframes existed in mp3fileutils 0.3
           ( IDs: ('TBP', 'TBPM', 'TBPM') ; Description : 'BPM (Beats Per Minute)'),
           ( IDs: ('TDY', 'TDLY', 'TDLY') ; Description : 'Playlist delay'),
           ( IDs: ('TFT', 'TFLT', 'TFLT') ; Description : 'File type'),
           ( IDs: ('TKE', 'TKEY', 'TKEY') ; Description : 'Initial key'),
           ( IDs: ('TP2', 'TPE2', 'TPE2') ; Description : 'Band/Orchestra/Accompaniment'),
           // ----
           ( IDs: ('TP3', 'TPE3', 'TPE3') ; Description : 'Conductor/Performer refinement'),
           ( IDs: ('TP4', 'TPE4', 'TPE4') ; Description : 'Interpreted, remixed, or otherwise modified by'),
           ( IDs: ('TPA', 'TPOS', 'TPOS') ; Description : 'Part of a set'),
           ( IDs: ('TRC', 'TSRC', 'TSRC') ; Description : 'ISRC (International Standard Recording Code)'),
           ( IDs: ('TT1', 'TIT1', 'TIT1') ; Description : 'Content group description'),
           // ----
           ( IDs: ('TT3', 'TIT3', 'TIT3') ; Description : 'Subtitle/Description refinement'),
           ( IDs: ('TXT', 'TEXT', 'TEXT') ; Description : 'Lyricist/text writer'),
           ( IDs: ('---', 'TOWN', 'TOWN') ; Description : 'File owner/licensee'),
           ( IDs: ('---', 'TRSN', 'TRSN') ; Description : 'Internet radio station name'),
           ( IDs: ('---', 'TRSO', 'TRSO') ; Description : 'Internet radio station owner'),
           // ----
           ( IDs: ('---', '----', 'TDEN') ; Description : 'Encoding time'),
           ( IDs: ('---', '----', 'TDRC') ; Description : 'Recording time'),
           ( IDs: ('---', '----', 'TDRL') ; Description : 'Release time'),
           ( IDs: ('---', '----', 'TDTG') ; Description : 'Tagging time'),
           ( IDs: ('---', '----', 'TMCL') ; Description : 'Musician credits list'),
           //----
           ( IDs: ('---', '----', 'TMOO') ; Description : 'Mood'),
           ( IDs: ('---', '----', 'TPRO') ; Description : 'Produced notice'),
           ( IDs: ('---', '----', 'TSOA') ; Description : 'Album sort order'),
           ( IDs: ('---', '----', 'TSOP') ; Description : 'Performer sort order'),
           ( IDs: ('---', '----', 'TSOT') ; Description : 'Title sort order'),
           ( IDs: ('---', '----', 'TSST') ; Description : 'Set subtitle'),
           ( IDs: ('TXX', 'TXXX', 'TXXX') ; Description : 'User defined text information frame'),
           //----//----//----
           // URL-Frames
           ( IDs: ('WAF', 'WOAF', 'WOAF') ; Description : 'Official audio file webpage'),
           ( IDs: ('WAR', 'WOAR', 'WOAR') ; Description : 'Official artist/performer webpage'),
           ( IDs: ('WAS', 'WOAS', 'WOAS') ; Description : 'Official audio source webpage'),
           ( IDs: ('WCM', 'WCOM', 'WCOM') ; Description : 'Commercial information'),
           ( IDs: ('WCP', 'WCOP', 'WCOP') ; Description : 'Copyright/Legal information'),
           ( IDs: ('WPB', 'WPUB', 'WPUB') ; Description : 'Publishers official webpage'),
           ( IDs: ('---', 'WORS', 'WORS') ; Description : 'Official internet radio station homepage'),
           ( IDs: ('---', 'WPAY', 'WPAY') ; Description : 'Payment'),
            // more Frames
           ( IDs: ('PIC', 'APIC', 'APIC') ; Description : 'Attached picture'),
           ( IDs: ('ULT', 'USLT', 'USLT') ; Description : 'Unsychronized lyric/text transcription'),
           ( IDs: ('COM', 'COMM', 'COMM') ; Description : 'Comments'),
           ( IDs: ('POP', 'POPM', 'POPM') ; Description : 'Popularimeter'),
           ( IDs: ('WXX', 'WXXX', 'WXXX') ; Description : 'User defined URL link frame'),
           ( IDs: ('BUF', 'RBUF', 'RBUF') ; Description : 'Recommended buffer size'),
           //----
           ( IDs: ('CNT', 'PCNT', 'PCNT') ; Description : 'Play counter'),
           ( IDs: ('CRA', 'AENC', 'AENC') ; Description : 'Audio encryption'),
           ( IDs: ('ETC', 'ETCO', 'ETCO') ; Description : 'Event timing codes'),
           ( IDs: ('EQU', 'EQUA', 'EQU2') ; Description : 'Equalization'),
           ( IDs: ('GEO', 'GEOB', 'GEOB') ; Description : 'General encapsulated object'),
           //----
           ( IDs: ('LNK', 'LINK', 'LINK') ; Description : 'Linked information'),
           ( IDs: ('MCI', 'MCDI', 'MCDI') ; Description : 'Music CD Identifier'),
           ( IDs: ('MLL', 'MLLT', 'MLLT') ; Description : 'MPEG location lookup table'),
           ( IDs: ('REV', 'RVRB', 'RVRB') ; Description : 'Reverb'),
           ( IDs: ('RVA', 'RVAD', 'RVA2') ; Description : 'Relative volume adjustment'),
            //----
           ( IDs: ('SLT', 'SYLT', 'SYLT') ; Description : 'Synchronized lyric/text'),
           ( IDs: ('STC', 'SYTC', 'SYTC') ; Description : 'Synced tempo codes'),
           ( IDs: ('UFI', 'UFID', 'UFID') ; Description : 'Unique file identifier'),
           // Frames, which do not exist in every subversion
           ( IDs: ('---', 'COMR', 'COMR') ; Description : 'Commercial frame'),
           ( IDs: ('---', 'ENCR', 'ENCR') ; Description : 'Encryption method registration'),
           ( IDs: ('---', 'GRID', 'GRID') ; Description : 'Group identification registration'),
           ( IDs: ('---', 'OWNE', 'OWNE') ; Description : 'Ownership frame'),
                   // Note: PRV is not defined in ID3v2.2! I added this by myself!
           ( IDs: ('PRV', 'PRIV', 'PRIV') ; Description : 'Private frame'),
           ( IDs: ('---', 'POSS', 'POSS') ; Description : 'Position synchronisation frame'),
           ( IDs: ('---', 'USER', 'USER') ; Description : 'Terms of use'),
           ( IDs: ('---', '----', 'ASPI') ; Description : 'Audio seek point index'),
           ( IDs: ('---', '----', 'SEEK') ; Description : 'Seek frame'),
           ( IDs: ('---', '----', 'SIGN') ; Description : 'Signature frame'),
           // even more Frames, deprecated, do not create
           ( IDs: ('IPL', 'IPLS', 'TIPL') ; Description : 'Involved people list'),
           ( IDs: ('CRM', '----', '----') ; Description : 'Encrypted meta frame'),
           ( IDs: ('TRD', 'TRDA', '----') ; Description : 'Recording dates'),
           ( IDs: ('TDA', 'TDAT', '----') ; Description : 'Date'),
           ( IDs: ('TIM', 'TIME', '----') ; Description : 'Time'),

           ( IDs: ('TSI', 'TSIZ', '----') ; Description : 'Size')
        );

        Picture_Types: Array[0..20] of string =      // Delphi-Default-String. Doesn't matter
          (	'Other',
            '32x32 pixels file icon (PNG only)',
            'Other file icon',
            'Cover (front)',
            'Cover (back)',
            'Leaflet page',
            'Media (e.g. lable side of CD)',
            'Lead artist/lead performer/soloist',
            'Artist/performer',
            'Conductor',
            'Band/Orchestra',
            'Composer',
            'Lyricist/text writer',
            'Recording Location',
            'During recording',
            'During performance',
            'Movie/video screen capture',
            'A bright coloured fish',
            'Illustration',
            'Band/artist logotype',
            'Publisher/Studio logotype' );


function UnSyncStream(Source, Target: TStream): Boolean;
procedure SetStreamEnd(aStream: TStream);

implementation

function ByteToTextEncoding(Value: Byte): TTextEncoding;
begin
  case Value of
    0: result := TE_Ansi;
    1: result := TE_UTF16;
    2: result := TE_UTF16BE;
    3: result := UTF8
  else
    result := TE_Ansi;
  end;
end;

// Delete Syncs from the Stream.
// i.e. FF Ex => FF 00 Ex  (FF E: Mpeg-Header-Identifier)
//      FF 00 => FF 00 00
// return value:
//    True: changes were necessary
//    False: no changes
function UnSyncStream(Source, Target: TStream): Boolean;
var buf: TBuffer;
    i, last: Int64;
const
    zero: byte = 0;
begin
    result := false;
    setlength(buf, Source.Size);
    Source.Read(buf[0], length(buf));
    i := 0;
    last := 0;

    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2)
              and
              ( (buf[i] <> $FF)
                 or
               ( (buf[i+1] <> $00) and (buf[i+1] < $E0) )
              )
        do
            inc(i);

        // buf[i] buf[i+1] is  $FF Ex or $FF 00
        if (buf[i] = $FF) and
               ( (buf[i+1] = $00) or (buf[i+1] >= $E0) )
        then
        begin
            // critical position found - unsynch it!
            Target.Write(buf[last], i - last + 1);
            Target.Write(zero, SizeOf(Zero));
            last := i + 1;
            inc(i, 1);   // i.e. last = i
            result := True;
        end else
        begin
            // End of Stream
            Target.Write(buf[last], length(buf) - last);
            // if last byte = $FF: Append $00
            if buf[length(buf)-1] = $FF then
            begin
                result := True;
                Target.Write(zero, SizeOf(Zero));
            end;
            i := length(buf);

        end;
    end;
end;

//--------------------------------------------------------------------
// Set end of Stream
//--------------------------------------------------------------------
procedure SetStreamEnd(aStream: TStream);
begin
  if aStream is THandleStream then
    SetEndOfFile((aStream as THandleStream).Handle)
  else
    if aStream is TMemoryStream then
      TMemoryStream(aStream).SetSize(aStream.Position);
end;



constructor TID3v2Frame.Create(aID: AnsiString; aVersion: TID3v2FrameVersions);
begin
    inherited Create;
    fVersion := aVersion;
    fIDString := aID;
    fID := IDv2_UNKNOWN;
    fParsable := True;
    if fVersion = FV_2 then
    begin
        Setlength(fHeader, 6);
        if not ValidFrameID then
          fIDString := 'XXX';
    end
    else
    begin
        Setlength(fHeader, 10);
        if not ValidFrameID  then
          fIDString := 'XXXX';
    end;

    move(fIDString[1], fHeader[0], length(fIDString));

    fAlwaysWriteUnicode := False;
    fCharCode := DefaultCharCode;
    fAutoCorrectCodepage := False;
end;

// similar to Tag.SyncStream
procedure TID3v2Frame.SyncStream(Source, Target: TStream; aSize: Integer);
var buf: TBuffer;
    i, last: Int64;
begin
    setlength(buf, aSize);
    Source.Read(buf[0], aSize);
    Target.Size := aSize;
    i := 0;
    last := 0;
    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2) and ((buf[i] <> $FF) or (buf[i+1] <> $00)) do
            inc(i);
        // i ist hier maximal length(buf)-2, d.h. buf[i] ist das vorletzte gültige Element
        // oder buf[i] = 255 und buf[i+1] = 0
        // also: vom letzten Fund bis zu i in den neuen Stream kopieren und buf[i+1] überspringen
        if (buf[i] = $FF) and (buf[i+1] = $00) then
        begin
            Target.Write(buf[last], i - last + 1);
            last := i + 2;
            inc(i, 2);   // d.h. last = i
        end else
        begin
            // wir sind am Ende des Streams und haben da kein FF 00
            Target.Write(buf[last], length(buf) - last);
            i := length(buf); // End.
        end;
    end;
    SetStreamEnd(Target);
end;



procedure TID3v2Frame.ReadFromStream(aStream: tStream);
var locSize: Integer;
    DataOffset: Integer;
    SyncedStream: TStream;
begin
  // Note: IDStr was read by mp3fileutils in the TID3v2Tag.ReadFrames-method
  locSize := 0;
  fParsable := True;
  // read the rest of the header
  aStream.Read(fHeader[length(fIDString)], length(fHeader) - length(fIDString));
  case fVersion of
    FV_2: begin  locSize := 65536 * fHeader[3]
                + 256 * fHeader[4]
                + fHeader[5];
                fParsable := True;
                // no Header-Flags
    end;
    FV_3: begin  locSize := 16777216 * fHeader[4]
                + 65536 * fHeader[5]
                + 256 * fHeader[6]
                + fHeader[7];
                if (fHeader[9] and $DF) <> 0 then
                    // frame is not readable for mp3fileUtils
                    // (Compression or Encryption are used)
                    fParsable := False;
    end;
    FV_4: begin  locSize := 2097152 * fHeader[4]
                + 16384 * fHeader[5]
                + 128 * fHeader[6]
                + fHeader[7];
                if (fHeader[9] and $BC) <> 0 then
                    // frame is not readable for mp3fileUtils
                    // (Compression or Encryption are used)
                    fParsable := False;
    end;
  end;

  // read data
  // first: eventually synch . (yes, GroupID and other stuff has been unsynched, too!)
  if FlagUnsynchronisation then
  begin
      SyncedStream := TMemoryStream.Create;
      SyncStream(aStream, SyncedStream, locSize);
      locSize := SyncedStream.Size;
      SyncedStream.Position := 0;
  end else
      SyncedStream := aStream;

  DataOffset := 0;
  if fParsable then
  begin
      if FlagGroupingIndentity then
      begin
          inc(DataOffset);
          SyncedStream.Read(fGroupID, SizeOf(fGroupID));
      end;
      if FlagDataLengthIndicator then
      begin
          inc(DataOffset, 4);
          SyncedStream.Read(fDataLength, SizeOf(fDataLength));
      end;
      SetLength(fData, locSize - DataOffset);
      if length(fData) <> 0 then
          SyncedStream.ReadBuffer(fData[0], length(fData))
      else
          fData := NIL;
  end else
  begin
      // read data as the are
      SetLength(fData, SyncedStream.Size);
      if length(fData) <> 0 then
          SyncedStream.ReadBuffer(fData[0], length(fData))
      else
          fData := NIL;
  end;

  if aStream <> SyncedStream then
      SyncedStream.Free;
end;

// note: after reading the situation is as follows
// if the frame is parsable (i.e. not encrypted and not compressed)
// fData contains just the data of the frame. Datalength-Indicator and Group-ID
// are stored separately.
// If it is not parsable, "everything" is contained in fData

procedure TID3v2Frame.WriteToStream(aStream: tStream);
begin
    //No unsynchronisation here (use WriteUnsyncedToStream instead)
    UnsetFlag(FF_Unsync);

    if fParsable then
    begin
        UnsetFlag(FF_DataLength); // do not write DataLength

        if FlagGroupingIndentity then
            Updateheader(length(fData) + 1);
        // write Header
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        // write GroupID (if flag is set)
        if  FlagGroupingIndentity then
            aStream.Write(fGroupID, SizeOf(fGroupID));
        // write data
        aStream.WriteBuffer(fData[0],length(fData));
    end else
    begin
        UpdateHeader; // note: maybe changes in unsynch
        // write Header
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        // write data
        aStream.WriteBuffer(fData[0],length(fData));
    end;
end;

procedure TID3v2Frame.WriteUnsyncedToStream(aStream: TStream);
var tmpStream, UnsyncedStream: TMemoryStream;
begin
    UnsyncedStream := TMemoryStream.Create;
    tmpStream := TMemoryStream.Create;

    if fParsable then
    begin
        UnsetFlag(FF_DataLength);

        if  FlagGroupingIndentity then
            tmpStream.Write(fGroupID, SizeOf(fGroupID));

        tmpStream.WriteBuffer(fData[0],length(fData));
        tmpStream.Position := 0;

        // Set flag only if changes are neccessary in the stream
        if UnsyncStream(tmpStream, UnsyncedStream) then
        begin
            SetFlag(FF_Unsync)
        end else
            UnSetFlag(FF_Unsync);

        UpdateHeader(UnsyncedStream.Size);
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        aStream.CopyFrom(UnsyncedStream, 0);

    end else
    begin
        tmpStream.WriteBuffer(fData[0],length(fData));
        tmpStream.Position := 0;
        if UnsyncStream(tmpStream, UnsyncedStream) then
        begin
            SetFlag(FF_Unsync)
        end else
            UnsetFlag(FF_Unsync);

        UpdateHeader(UnsyncedStream.Size);
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        aStream.CopyFrom(UnsyncedStream, 0);
    end;
    UnsyncedStream.Free;
    tmpStream.Free;
end;


// Basic Validation. A Frame-ID consists only of capital letters A..Z and numbers 0..9
function TID3v2Frame.ValidFrameID: Boolean;
var  i: Integer;
begin
    result := True;
    if ((fVersion = FV_2) and (length(fIDString) <> 3))
        OR
       ((fVersion <> FV_2) and (length(fIDString) <> 4)) then
    begin
       result := False;
       exit;
    end;

    for i := 1 to length(fIDString) do
        if not (fIDString[i] in ['0'..'9', 'A'..'Z']) then
        begin
            result := False;
            Break;
        end;
end;


function TID3v2Frame.GetFrameType: TID3v2FrameTypes;
begin
    if Not ValidFrameID then
    begin
       result := FT_INVALID;
       exit;
    end;

    case self.fVersion of
      FV_2: begin
        if (fIDString[1] = 'T') and (fIDString <> 'TXX') then
          result := FT_TextFrame
        else
          if (fIDString = 'TXX') then
            result := FT_UserTextFrame
          else
            if (fIDString = 'WXX') then
              result := FT_UserDefinedURLFrame
            else
              if (fIDString = 'COM') then
                result := FT_CommentFrame
              else
                if (fIDString = 'ULT') then
                  result := FT_LyricFrame
                else
                  if (fIDString = 'PIC') then
                    result := FT_PictureFrame
                  else
                    if (fIDString = 'POP') then
                      result := FT_PopularimeterFrame
                    else
                          if (fIDString = 'WCM') OR (fIDString = 'WCP') OR (fIDString = 'WAF') OR
                             (fIDString = 'WAR') OR (fIDString = 'WAS') OR (fIDString = 'WPB') then
                            result := FT_URLFrame
                          else
                            result := FT_UNKNOWN;
      end
      else begin
        if (fIDString[1] = 'T') and (fIDString <> 'TXXX') then
          result := FT_TextFrame
        else
          if (fIDString = 'TXXX') then
            result := FT_UserTextFrame
          else
            if (fIDString = 'WXXX') then
              result := FT_UserDefinedURLFrame
            else
              if (fIDString = 'COMM') then
                result := FT_CommentFrame
              else
                if (fIDString = 'USLT') then
                  result := FT_LyricFrame
                else
                  if (fIDString = 'APIC') then
                    result := FT_PictureFrame
                  else
                    if (fIDString = 'POPM') then
                      result := FT_PopularimeterFrame
                    else
                          if (fIDString = 'WCOM') OR (fIDString = 'WCOP') OR (fIDString = 'WOAF') OR (fIDString = 'WOAR') OR
                             (fIDString = 'WOAS') OR (fIDString = 'WORS') OR (fIDString = 'WPAY') OR (fIDString = 'WPUB') then
                            result := FT_URLFrame
                          else
                            result := FT_UNKNOWN;
      end;
    end; //case
end;

function TID3v2Frame.GetFrameTypeDescription: String;    // Delphi-Default-String.
var i: TFrameIDs;
begin
    if fID <> IDv2_UNKNOWN then
        result := ID3v2KnownFrames[fID].Description
    else
    begin
        {$IFDEF UNICODE}
            // Explicit typecast
            result := 'Unknown Frame (' + String(fIDString) + ')';
        {$ELSE}
            result := 'Unknown Frame (' + fIDString + ')';
        {$ENDIF}
        for i := low(TFrameIDs) to High(TFrameIDs) do
            if  ID3v2KnownFrames[i].IDs[fVersion] = fIDString then
            begin
                result := ID3v2KnownFrames[i].Description;
                break;
            end;
    end;
end;

function TID3v2Frame.GetFrameTypeID: TFrameIDs;
var i: TFrameIDs;
begin
    if fID <> IDv2_UNKNOWN then
        result := fID
    else
    begin
        result := IDv2_UNKNOWN;
        for i := low(TFrameIDs) to High(TFrameIDs) do
        if  ID3v2KnownFrames[i].IDs[fVersion] = fIDString then
        begin
            result := i;
            fID := i;
            break;
        end;
    end;
end;

// Flag-scheme:
// Version 2.3: abc00000 ijk00000
// Version 2.4: 0abc0000 0h00kmnp
// see id3.org for details
function TID3v2Frame.GetFlagTagAlterPreservation: Boolean;
begin
    case fVersion of
      FV_2: result := True;
      FV_3: result := (fHeader[8] and 128) = 0;
      FV_4: result := (fHeader[8] and 128) = 0
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagFileAlterPreservation: Boolean;
begin
    case fVersion of
      FV_2: result := True;
      FV_3: result := (fHeader[8] and 64) = 0;
      FV_4: result := (fHeader[8] and 64) = 0
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagReadOnly: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[8] and 32) = 32;
      FV_4: result := (fHeader[8] and 32) = 32
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagCompression: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 128) = 128;
      FV_4: result := (fHeader[9] and 8) = 8
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagEncryption : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 64) = 64;
      FV_4: result := (fHeader[9] and 4) = 4
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagGroupingIdentity : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 32) = 32;
      FV_4: result := (fHeader[9] and 64) = 64
    else result := True;
    end;
end;
procedure TID3v2Frame.SetFlagGroupingIdentity(Value: Boolean);
begin
    if Value then
      SetFlag(FF_GroupID)
    else
      UnsetFlag(FF_GroupID);
end;
function TID3v2Frame.GetFlagUnsynchronisation : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := False;
      FV_4: result := (fHeader[9] and 2) = 2
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagDataLengthIndicator : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := False;
      FV_4: result := (fHeader[9] and 1) = 1
    else result := True;
    end;
end;
function TID3v2Frame.GetUnknownStatusFlags: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[8] and 31) <> 0;
      FV_4: result := (fHeader[8] and 143) <> 0  // 143 = %10001111
    else result := True;
    end;
end;
function TID3v2Frame.GetUnknownEncodingFlags: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 31) <> 0;
      FV_4: result := (fHeader[9] and 176) = 176 // = %1011 0000
    else result := True;
    end;
end;

procedure TID3v2Frame.SetFlag(aFlag: TFrameFlags);
begin
    if fVersion <> FV_2 then
    begin
        if aFlag <= FF_UnknownStatus then
          fHeader[8] := fHeader[8] or TFrameFlagValues[fVersion][aFlag]
        else
          fHeader[9] := fHeader[9] or TFrameFlagValues[fVersion][aFlag];
    end;
end;

procedure TID3v2Frame.UnSetFlag(aFlag: TFrameFlags);
begin
    if fVersion <> FV_2 then
    begin
        if aFlag <= FF_UnknownStatus then
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][aFlag])
        else
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][aFlag]);
    end;
end;

procedure TID3v2Frame.UnSetFlagSomeFlagsAfterDataSet;
begin
    if fVersion <> FV_2 then
    begin
          // delete all flags except "Preserve-Flags" and GroupID
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][FF_ReadOnly]);
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][FF_UnknownStatus]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Compression]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Encryption]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Unsync]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_DataLength]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_UnknownFormat]);
    end;
end;


function TID3v2Frame.GetDataSize: Integer;
begin
  if fData <> NIL then
    result := length(fData)
  else
    result  := 0;
end;

procedure TID3v2Frame.UpdateHeader(aSize: Integer = -1);
begin
  if aSize = -1 then
    aSize := length(fData);

  case fVersion of
    FV_2: begin
      fHeader[3] := aSize DIV 65536;
      aSize := aSize MOD 65536;
      fHeader[4] := aSize DIV 256;
      aSize := aSize MOD 256;
      fHeader[5] := aSize;
    end;
    FV_3: begin
      fHeader[4] := aSize DIV 16777216;
      aSize := aSize MOD 16777216;
      fHeader[5] := aSize DIV 65536;
      aSize := aSize MOD 65536;
      fHeader[6] := aSize DIV 256;
      aSize := aSize MOD 256;
      fHeader[7] := aSize;
    end;
    FV_4: begin
      fHeader[4] := aSize DIV 2097152;
      aSize := aSize MOD 2097152;
      fHeader[5] := aSize DIV 16384;
      aSize := aSize MOD 16384;
      fHeader[6] := aSize DIV 128;
      aSize := aSize MOD 128;
      fHeader[7] := aSize;
    end;
  end;
end;

function TID3v2Frame.IsUnicodeNeeded(aString: UnicodeString): Boolean;
var i:integer;
begin
  result := False;
  for i := 1 to length(aString) do
    if Word(aString[i]) > 255 then
    begin
      result := True;
      break;
    end;
end;


function TID3v2Frame.GetConvertedUnicodeText(Start, Ende: integer; TextEncoding: TTextEncoding): UnicodeString;
var
  L, i:integer;
  tmp: AnsiString;
  tmpbuf: TBuffer;
  aLength: Integer;

begin
    if Ende >= length(fData) then Ende := length(fData) - 1;
    if Start < 0 then Start := 0;
    if Start > Ende  then
    begin
        result := '';
        exit;
    end;
    aLength := Ende-Start+1;
    Setlength(result, aLength);
    Fillchar(result[1], length(result)*2, 0);

    case TextEncoding of  // TE_Ansi, TE_UTF16, TE_UTF16BE, UTF8
        TE_Ansi: begin
            // No Unicode, but Ansi
            // It _should_ be encoded as Iso8859-1, but sometimes it's not.
            // => Decode it, if wanted
            if (fAutoCorrectCodepage)  then
            begin
                // Use the probably correct CodePage to convert the Data
                setlength(tmp, aLength);
                move(fData[start], tmp[1], length(tmp));

                L := MultiByteToWideChar( FCharCode.CodePage,
                          MB_PRECOMPOSED,// Flags
                          @tmp[1],       // data to convert
                          length(tmp),   // Size in bytes
                          nil,           // output - not used here
                          0);            // 0=> Get required BufferSize

                if L = 0 then
                begin
                    // Something's wrong => Fall back to ANSI
                    setlength(tmp, aLength);
                    move(fData[start], tmp[1], length(tmp));
                    {$IFDEF UNICODE}
                        // use explicit typecast
                        result := trim(String(tmp));
                    {$ELSE}
                        result := trim(tmp);
                    {$ENDIF}
                end else
                begin
                    // SetBuffer, Size in WChars, not Bytes.
                    SetLength(Result, L);
                    // Convert
                    MultiByteToWideChar(FCharCode.CodePage,
                              MB_PRECOMPOSED,
                              @tmp[1],
                              length(tmp),
                              @Result[1],
                              L);
                end;
            end else
            begin
                // Just get the data as an AnsiString and let Delphi convert it.
                setlength(tmp, aLength);
                move(fData[start], tmp[1], length(tmp));
                {$IFDEF UNICODE}
                    // use explicit typecast
                    result := trim(String(tmp));
                {$ELSE}
                    result := trim(tmp);
                {$ENDIF}
            end;
            result := trim(result);
        end;
        TE_UTF16: begin
            { UTF-16 [UTF-16] encoded Unicode [UNICODE] __with__ BOM. All
             strings in the same frame SHALL have the same byteorder.
             Terminated with $00 00. }
            setlength(result, aLength DIV 2 - 1);
            if (fData[start] = $FE) and (fData[start + 1] = $FF) then
            begin
              // byteorder is different to delphi-byteorder. => Swap bytes
              setlength(tmpbuf, alength - 2);
              for i := 1 to length(result) do
              begin
                  tmpbuf[2*i - 2] := fData[start + 2*i + 1];
                  tmpbuf[2*i - 1] := fData[start + 2*i];
                  move(tmpbuf[0], result[1], 2*length(result));
              end;
            end else
                if (fData[start] = $FF) and (fData[start + 1] = $FE) then
                begin
                  // ByteOrder as in wideStrings. Just copy it.
                  setlength(result, alength DIV 2 - 1);       // -1
                  if length(result) > 0 then
                      move(fData[start+2], result[1], 2*length(result))
                  else
                      result := '';
                end else
                begin
                    // june 2013
                    // no BOM detected. Just copy it as in TE_UTF16BE
                    // Todo for the future: Try to guess whether it is probably FF FE or FE FF
                    setlength(result, alength DIV 2);
                    move(fData[start], result[1], 2*length(result));
                end;
            result := trim(result);
        end;
        TE_UTF16BE: begin
           { UTF-16BE [UTF-16] encoded Unicode [UNICODE] __without__ BOM.
             Terminated with $00 00 }
            setlength(result, alength DIV 2);
            move(fData[start], result[1], 2*length(result));
            result := trim(result);
        end;
        UTF8: begin
            {03   UTF-8 [UTF-8] encoded Unicode [UNICODE]. Terminated with $00.}
            setlength(tmp,alength);
            move(fData[start], tmp[1], alength);
            {$IFDEF UNICODE}
                result := UTF8ToString(tmp);    // Bugfix 03.2010: "result := "
            {$ELSE}
                result := UTF8Decode(tmp); // Deprecated in Delphi 2009
            {$ENDIF}
            result := trim(result);
        end;
        else result := '';
    end;
end;


function TID3v2Frame.WideStringToData(Value: UnicodeString; start: integer; UnicodeIsNeeded: Boolean): integer;
var tmpstr: AnsiString;
begin
  if UnicodeIsNeeded then
  begin
      // ByteOrder
      fData[start] := $FF;
      fData[start+1] := $FE;
      // copy to fData
      if length(value) > 0 then
        move(value[1], fData[start+2], length(Value) * SizeOf(Widechar));

      result := 2 + SizeOf(WideChar)*length(Value);
  end else
  begin
      // Convert Value to AnsiString
      {$IFDEF UNICODE}
          // use explicit typecast
          tmpstr := AnsiString(Value);
      {$ELSE}
          tmpstr := Value;
      {$ENDIF}

      // copy to fDate
      if length(tmpstr) > 0 then
          move(tmpstr[1], fData[start], length(tmpstr));
      result := length(tmpstr);
  end;
end;

function TID3v2Frame.AnsiStringToData(Value: AnsiString; start: integer): integer;
begin
    if length(Value) > 0 then
      move(Value[1], fData[start], length(Value));
    result := length(Value);
end;


function TID3v2Frame.GetText: UnicodeString;
begin
    if fParsable then
      result :=
        GetConvertedUnicodeText(
        1,                            // start at second byte
        length(fData)-1,              // read to the end
        ByteToTextEncoding(fData[0])  // first byte contains the "TextEncoding"
        )
    else
      result := '';
end;


      {
 <Header for 'User defined text information frame', ID: "TXXX">
     Text encoding     $xx
     Description       <text string according to encoding> $00 (00)
     Value             <text string according to encoding>

 <Header for 'Comment', ID: "COMM">
     Text encoding          $xx
     Language               $xx xx xx
     Short content descrip. <text string according to encoding> $00 (00)
     The actual text        <full text string according to encoding>
             }




procedure TID3v2Frame.SetText(Value: UnicodeString);
var UseUnicode: Boolean;
begin
    UseUnicode := fAlwaysWriteUnicode OR IsUnicodeNeeded(Value);
    If UseUnicode then
    begin
        // 2 bytes per character + 1 byte TextEncoding + 2 bytes byteorder (FF FE)
        Setlength(fData, length(Value) * SizeOf(WideChar) + 3);
        // TextEncoding "UTF-16 with BOM"
        fData[0] := 1;
    end else
    begin
        // 1 byte per character + 1 byte TextEncoding
        Setlength(fData, length(Value)+1);
        // TextEncoding "IS0-8859-1"
        fData[0] := 0;
    end;
    // write data. Conversion "Unicodestring <-> Ansistring"
    // will be done in method WideStringToData
    WideStringToData(Value, 1, UseUnicode);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetUserText(out Description: UnicodeString): UnicodeString;
var enc: TTextEncoding;
  i: Integer;
begin
    if fParsable then
    begin
        if length(fData) < 3 then
        begin
            Description := '';
            result := '';
            exit;
        end;
        // get TextEncoding
        enc := ByteToTextEncoding(fData[0]);
        i := 1;
        if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
        begin
            While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                inc(i,2);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,2) // 2 bytes termination (00 00)
        end
        else
        begin
            While (i < length(fData)) and (fData[i] <> 0) do
                inc(i);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,1); // 1 byte termination (00)
        end;

        result := GetConvertedUnicodetext(i, length(fData)-1, enc);
    end
    else
    begin
        result := '';
        Description := '';
    end;
end;

procedure TID3v2Frame.SetUserText(Description, Value: UnicodeString);
var UseUnicode: Boolean;
    BytesWritten: Integer;
begin
    UseUnicode := AlwaysWriteUnicode OR IsUnicodeNeeded(Value) OR IsUnicodeNeeded(Description);

    If UseUnicode then
    begin
        Setlength(fData,
              1                                             // Text-Encoding
            + 4 + length(Description) * SizeOf(WideChar)    // 2 Bytes BOM + 2Bytes per character + 2 Bytes termination (Description)
            + 2 + length(Value) * SizeOf(WideChar)  );      // 2 Bytes BOM + 2Bytes per character (Value)
        fData[0] := 1;                                      // TextEncodingg "UTF-16 with BOM"
    end else
    begin
      Setlength(fData,
            1                           // Text-Encoding
          + 1 + length(Description)     // 1 Byte per character + 1 Byte termination (Description)
          + length(Value) );            // 1 Byte per character
      fData[0] := 0;                    // TextEncoding "IS0-8859-1"
    end;

    // Set description
    BytesWritten := WideStringToData(Description, 1, UseUnicode);
    // Set termination
    fData[1 + BytesWritten] := 0;
    inc(BytesWritten);
    if UseUnicode then
    begin // Termination with two zeros (00 00)
      fData[1 + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    // set value
    WideStringToData(Value, 1 + BytesWritten, UseUnicode);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;


function TID3v2Frame.GetCommentsLyrics(out Language: AnsiString; out Description: UnicodeString): UnicodeString;
var enc: TTextEncoding;
  i: Integer;
begin
    // frame structure:
    // 1 Byte Encoding
    // 3 Byte Language
    // <..> 00 (00) Description (enc)
    // <..> Value (enc)

    if fParsable then
    begin
        if length(fData) < 5 then
        begin
            Language := '';
            Description := '';
            result := '';
            exit;
        end;

        // get TextEncoding
        enc := ByteToTextEncoding(fData[0]);
        // get language
        setlength(Language, 3);
        Move(fData[1], Language[1], 3);
        //get description
        i := 4;

        if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
        begin
            While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                inc(i,2);
            Description := GetConvertedUnicodetext(4, i, enc);
            inc(i,2) // 2 bytes termination (00 00)
        end
        else
        begin
            While (i < length(fData)) and (fData[i] <> 0) do
                inc(i);
            Description := GetConvertedUnicodetext(4, i, enc);
            inc(i,1); // 1 byte termination (00)
        end;

        result := GetConvertedUnicodetext(i, length(fData)-1, enc);
    end else
    begin
        Language := '';
        Description := '';
        Result := '';
    end;
end;

procedure TID3v2Frame.SetCommentsLyrics(Language: AnsiString; Description, Value: UnicodeString);
var UseUnicode: Boolean;
    BytesWritten: Integer;
begin
    UseUnicode := AlwaysWriteUnicode OR IsUnicodeNeeded(Value) OR IsUnicodeNeeded(Description);
    if length(Language) <> 3 then Language := 'eng';

    If UseUnicode then
    begin
        Setlength(fData,
              4                                             // Text-Encoding + Language
            + 4 + length(Description) * SizeOf(WideChar)    // 2 Bytes BOM + 2Bytes per character + 2 Bytes termination (Description)
            + 2 + length(Value) * SizeOf(WideChar)  );      // 2 Bytes BOM + 2Bytes per character (Value)
        fData[0] := 1;                                      // TextEncodingg "UTF-16 with BOM"
    end else
    begin
      Setlength(fData,
            4                           // Text-Encoding + Language                    
          + 1 + length(Description)     // 1 Byte per character + 1 Byte termination (Description)
          + length(Value) );            // 1 Byte per character
      fData[0] := 0;                    // TextEncoding "IS0-8859-1"
    end;
    // Set language
    move(Language[1], fData[1], 3);
    // Set description
    BytesWritten := WideStringToData(Description, 4, UseUnicode);
    // Set termination
    fData[4 + BytesWritten] := 0;
    inc(BytesWritten);
    if UseUnicode then
    begin // Termination with two zeros (00 00)
      fData[4 + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    // set value
    WideStringToData(Value, 4 + BytesWritten, UseUnicode);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetUserdefinedURL(out Description: UnicodeString): AnsiString;
var enc: TTextEncoding;
  i: Integer;
begin
    // frame structure:
    // 1 Byte Encoding
    // <..> 00 (00) Description (enc)
    // <..> Value (ansii)
    if fParsable then
    begin
        if length(fData) < 2 then
        begin
            Description := '';
            result := '';
            exit;
        end;

        // get TextEncoding (for description)
        enc := ByteToTextEncoding(fData[0]);
        //get description
        i := 1;

        if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
        begin
            While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                inc(i,2);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,2) //  2 bytes termination
        end
        else
        begin
            While (i < length(fData)) and (fData[i] <> 0) do
                inc(i);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,1); // 1 byte termination
        end;

        setlength(result, length(fData) - i);
        move(fData[i], result[1], length(result));
        {$IFDEF UNICODE}
            // use explicit typecasts
            result := AnsiString(trim(String(result)));
        {$ELSE}
            result := trim(result);
        {$ENDIF}
    end else
    begin
        Description := '';
        result := '';
    end;
end;

procedure TID3v2Frame.SetUserdefinedURL(Description: UnicodeString; URL: AnsiString);
var UseUnicode: Boolean;
    BytesWritten: Integer;
begin
    UseUnicode := IsUnicodeNeeded(Description);
    If UseUnicode then
    begin
        Setlength(fData,
              1                                             // Text-Encoding + Language
            + 4 + length(Description) * SizeOf(WideChar)    // 2 Bytes BOM + 2Bytes per character + 2 Bytes termination (Description)
            + length(URL)   );                              // 1 Byte per character (Value)
        fData[0] := 1;                                      // TextEncoding "UTF16 with BOM"
    end else
    begin
      Setlength(fData,
            1                           // Text-Encoding + Language
          + 1 + length(Description)     // 1 Byte per character + 1 Byte termination (Description)
          + length(URL) );              // 1 Byte per character
      fData[0] := 0;                    // TextEncoding "IS0-8859-1"
    end;
    // Set description
    BytesWritten := WideStringToData(Description, 1, UseUnicode);
    // Set termination
    fData[1 + BytesWritten] := 0;
    inc(BytesWritten);
    if UseUnicode then
    begin
      fData[1 + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    // Set Value
    AnsiStringToData(URL, 1 + BytesWritten);

    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetURL: AnsiString;
begin
    if fParsable then
    begin
        setlength(result, length(fData));
        if length(result) > 0 then
          move(fData[0], result[1], length(result))
        else
          result := '';
    end else
        result := '';
end;

procedure TID3v2Frame.SetURL(Value: AnsiString);
begin
  if Value = '' then
    Value := ' ';
  Setlength(fData, length(Value));
  move(Value[1], fData[0], length(Value));
  UnSetFlagSomeFlagsAfterDataSet;
  UpdateHeader;
end;

function TID3v2Frame.GetPicture(out Mime: AnsiString; out PicType: Byte; out Description: UnicodeString; PictureData: TStream): Boolean;
var
    enc: TTextEncoding;
    i, dStart: Integer;
begin
    if fParsable then
    begin
        result := True;
        case fVersion of
            FV_2: begin
                if length(fData) <= 6 then  // 1 Enc, 3 Mime, 1 PicTyp, 1 Descr.-Terminierung -> 6 is minimum
                begin
                    Mime := '';
                    PicType := 0;
                    Description := '';
                    result := False;
                end else
                begin
                    // at least 7 Bytes in fData, so index of 6 will be ok
                    enc := ByteToTextEncoding(fData[0]);
                    // Mime-Type always 3 characters in subversion 2.2
                    SetLength(Mime, 3);
                    Move(fData[1], Mime[1], 3);
                    // PicType
                    PicType := fData[4];

                    // description is terminated with 00 (00)
                    i := 5;
                    if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
                    begin
                        While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                            inc(i,2);
                        Description := GetConvertedUnicodetext(5, i, enc);
                        inc(i,2) // 2 Bytes termination
                    end
                    else
                    begin
                        While (i < length(fData)) and (fData[i] <> 0) do
                            inc(i);
                        Description := GetConvertedUnicodetext(5, i, enc);
                        inc(i,1); // 1 Byte termination
                    end;

                    // here the image-data starts
                    if i < length(fData) then
                      PictureData.Write(fData[i], length(fData) - i)
                    else
                      result := False;
                end;
            end
        else begin
                // subversion 2.3 or 2.4
                if length(fData) <= 4 then  // 1 Enc, 1 mime-termination, 1 PicTyp, 1 Descr.-Terminierung -> this is minimum
                begin
                    Mime := '';
                    PicType := 0;
                    Description := '';
                    result := False;
                end else
                begin
                    enc := ByteToTextEncoding(fData[0]);
                    i := 1;
                    // get termination of mime-Type
                    While (i < length(fData)) and (fData[i] <> 0) do
                      inc(i);
                    // get mime-type
                    Setlength(Mime, i-1);
                    Move(fData[1], Mime[1], i-1);
                    // 1 byte termination
                    inc(i);

                    // PicType
                    if i < length(fData) then
                        PicType := fData[i]
                    else result := False;

                    inc(i);
                    //  get termination of description
                    dStart := i;

                    if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
                    begin
                        While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                            inc(i,2);
                        Description := GetConvertedUnicodetext(dStart, i, enc);
                        inc(i,2) // 2 Bytes
                    end
                    else
                    begin
                        While (i < length(fData)) and (fData[i] <> 0) do
                            inc(i);
                        Description := GetConvertedUnicodetext(dStart, i, enc);
                        inc(i,1); // 1 Byte
                    end;

                    // here the image-data starts
                    if i < length(fData) then
                      PictureData.Write(fData[i], length(fData) - i)
                    else
                      result := False;
                end
            end; // else
        end;
    end else
    begin
      result := False;
      Mime := '';
      PicType := 0;
      Description := '';
    end;
end;


procedure TID3v2Frame.SetPicture(Mime: AnsiString; PicType: Byte; Description: UnicodeString; PictureData: TStream);
var UseUnicode: Boolean;
    BytesWritten, helpIdx: Integer;
begin
    UseUnicode :=  IsUnicodeNeeded(Description);
    if Pictype > 20 then PicType := 0;

    case fVersion of
        FV_2: begin
            // adjust mime-type for subversion 2.2
            If length(Mime) <> 3 then
            begin
                if Mime = 'image/png'  then
                    Mime := 'PNG'
                else
                    Mime := 'JPG';
            end;
            if UseUnicode then
            begin
                setlength(fData, 1 + 3 + 1 + (length(Description) + 1) * SizeOf(Widechar) + PictureData.size);
                fData[0] := 1;
            end else
            begin
                setlength(fData, 1 + 3 + 1 + length(Description) + 1 + PictureData.size);
                fData[0] := 0;
            end;
            move(Mime[1], fData[1], 3);
            fData[4] := PicType;
            helpIdx := 5;
        end
        else
        begin
            // subversion 2.3 or 2.4
            if UseUnicode then
            begin
                setlength(fData, 1 + length(Mime) + 1 + 1 + (length(Description) + 1) * SizeOf(Widechar) + PictureData.size);
                fData[0] := 1;
            end else
            begin
                setlength(fData, 1 + length(Mime) + 1 + 1 + length(Description) + 1 + PictureData.size);
                fData[0] := 0;
            end;
            move(Mime[1], fData[1], length(Mime));
            fData[1 + length(Mime)] := 0; // termination
            fData[2 + length(Mime)] := PicType;
            helpIdx := 3 + length(Mime);
        end; // else
    end;  // Case

    BytesWritten := WideStringToData(Description, helpIdx, UseUnicode);
    fData[helpIdx + BytesWritten] := 0;
    inc(BytesWritten);
    if UseUnicode then
    begin
      fData[helpIdx + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    PictureData.Seek(0, soFromBeginning);
    PictureData.Read(fData[helpIdx + BytesWritten], PictureData.Size);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;


function TID3v2Frame.GetRating(out UserEMail: AnsiString): Byte;
var i: Integer;
begin
    if fParsable then
    begin
        i := 0;
        result := 0; // undef.

        //get length of user-mail
        While (i < length(fData)) and (fData[i] <> 0) do
            inc(i);
        // get user-mail
        Setlength(UserEMail, i);
        Move(fData[0], UserEMail[1], i);
        inc(i);   // termination byte
        // get rating
        if i < length(fData) then
            result := fData[i];
    end else
    begin
        result := 0;
        UserEMail := '';
    end;
end;

procedure TID3v2Frame.SetRating(UserEMail: AnsiString; Value: Byte);
var tmpmail: AnsiString;
    BackUpCounter: Cardinal;
    i: Integer;
begin
    // Todo:
    // Check for an PlayCounter after the rating, backup it, write it
    BackUpCounter := GetPersonalPlayCounter(tmpmail);

    // Set length of Data. If a Counter is present, we need 4 additional bytes.
    if BackUpCounter = 0 then
        Setlength(fData, length(UserEMail) + 2)
    else
        Setlength(fData, length(UserEMail) + 2 + 4);

    move(UserEMail[1], fData[0], length(UserEMail));
    fData[length(UserEMail)] := 0;
    fData[length(UserEMail) + 1] := Value;

    if BackUpCounter <> 0 then
    begin
        // Write the existing counter into the frame
        i := length(UserEMail) + 2;
        fData[i] := BackUpCounter DIV 16777216;
        BackUpCounter := BackUpCounter MOD 16777216;
        fData[i+1] := BackUpCounter DIV 65536;
        BackUpCounter := BackUpCounter MOD 65536;
        fData[i+2] := BackUpCounter DIV 256;
        BackUpCounter := BackUpCounter MOD 256;
        fData[i+3] := BackUpCounter;
    end;

    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetPersonalPlayCounter(out UserEMail: AnsiString): Cardinal;
var i: Integer;
begin
    if fParsable then
    begin
        i := 0;
        //get length of user-mail
        While (i < length(fData)) and (fData[i] <> 0) do
            inc(i);
        // get user-mail
        Setlength(UserEMail, i);
        Move(fData[0], UserEMail[1], i);
        inc(i);   // termination byte
        inc(i);   // Rating byte
        if i < length(fData) then
        begin
            // We have information after the rating byte.
            case (length(fData) - i) of
                0..3: begin
                    // Invalid Counter
                    result := 0;
                end;
                4: begin
                    // valid Counter
                    result :=  fData[i] * 16777216
                             + fData[i+1] * 65536
                             + fData[i+2] * 256
                             + fData[i+3];
                end;
            else
                begin
                    // Counter to large, but valid
                    // Note: We read only counters smaller then 4.294.967.295
                    //       - this should be enough for all cases
                    // Edit: No. Some POPM-Frames are kinda invalid (only several zero-bytes),
                    //       which will cause unexpected results here.
                    //       So: Set these Counts to zero
                    result := 0; // ... and NOT to high(Cardinal);
                end;
            end;
        end else
        begin
            // No Counter-Information in the Rating-Frame
            result := 0;
        end;
    end else
    begin
        result := 0;
        UserEMail := '';
    end;
end;

procedure TID3v2Frame.SetPersonalPlayCounter(UserEMail: AnsiString; Value: Cardinal);
var tmpmail: AnsiString;
    BackUpRating: Byte;
    i: Integer;
begin
    // Read the rating, backup it
    BackUpRating := GetRating(tmpmail);

    // if Value = 0, the write no Counting-information into the frame
    if Value = 0 then
        Setlength(fData, length(UserEMail) + 2)
    else
        Setlength(fData, length(UserEMail) + 2 + 4);

    move(UserEMail[1], fData[0], length(UserEMail));
    fData[length(UserEMail)] := 0;
    fData[length(UserEMail) + 1] := BackUpRating;

    if Value <> 0 then
    begin
        // Write the existing counter into the frame
        i := length(UserEMail) + 2;
        fData[i] := Value DIV 16777216;
        Value := Value MOD 16777216;
        fData[i+1] := Value DIV 65536;
        Value := Value MOD 65536;
        fData[i+2] := Value DIV 256;
        Value := Value MOD 256;
        fData[i+3] := Value;
    end;
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;


function TID3v2Frame.GetPrivateFrame(out OwnerID: AnsiString;
  Data: TStream): Boolean;
var i: Integer;
begin
    if fParsable then
    begin
        i := 0;
        result := True;
        //get length of OwnerID
        While (i < length(fData)) and (fData[i] <> 0) do
            inc(i);
        // get OwnerID
        Setlength(OwnerID, i);
        Move(fData[0], OwnerID[1], i);
        inc(i);   // termination byte

        if i < length(fData) then
            Data.Write(fData[i], length(fData) - i)
        else
            result := False;

    end else
        result := False;

end;
procedure TID3v2Frame.SetPrivateFrame(aOwnerID: AnsiString; Data: TStream);
begin
    SetLength(fData, Length(aOwnerID) + 1 + Data.Size);
    // write OwnerID to fData
    Move(aOwnerID[1], fData[0], length(aOwnerID));
    // Termination Byte
    fData[length(aOwnerID)] := 0;
    // Write Data
    Data.Seek(0, soFromBeginning);
    Data.Read(fData[length(aOwnerID) + 1], Data.Size);

    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;



procedure TID3v2Frame.GetData(Data: TStream);
begin
  if length(fData) > 0 then
    Data.Write(fData[0], length(fData));
end;

procedure TID3v2Frame.SetData(Data: TStream);
begin
  Data.Seek(0, soFromBeginning);
  setlength(fData, Data.Size);
  Data.Read(fData[0], Data.Size);
  UpdateHeader;
end;


end.
