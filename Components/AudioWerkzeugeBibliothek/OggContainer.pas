{
    -----------------------------------
    Audio Werkzeuge Bibliothek
    -----------------------------------
    (c) 2010-2024, Daniel Gaussmann
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

    Unit OggContainer

    Process physical Ogg Streams as can be found in OggVorbis- or Opus-Files

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

unit OggContainer;

interface

uses
  Windows, Messages, SysUtils, Variants, ContNrs, Classes,
  VorbisComments, ID3Basics,
  AudioFiles.Base, AudioFiles.Declarations;

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

  TLacingValues = Array of Byte;
  TOggHeader = packed record   // (size: 27 Bytes)
    // Note: This is only the "constant part" of the header.
    //       The lacing values have variable length and are NOT part of this record
    ID: array [1..4] of AnsiChar;    // "OggS"
    StreamVersion: Byte;             // Stream structure version
    TypeFlag: Byte;                  // Header type flag
    AbsolutePosition: Int64;         // Absolute granule position
    Serial: Cardinal;                // Stream serial number
    PageNumber: Cardinal;            // Page sequence number
    Checksum: Cardinal;              // Page checksum
    Segments: Byte;                  // Number of page segments
  end;

  TOggPacket = class
    private
      fData: TMemoryStream;
      fStartPage: Integer;
      fEndPage: Integer;
      fFinishesPage: Boolean;
    public
      property Data: TMemoryStream read fData;
      property StartPage: Integer read fStartPage;
      property EndPage: Integer read fEndPage;
      property FinishesPage: Boolean read fFinishesPage;

      constructor Create;
      destructor Destroy; override;
      procedure Clear; virtual;
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
      fCurrentLacingIndex: Byte;
      fFinished: Boolean;   // used during writing. No more data allowed if the page is finished
      fData: TMemoryStream; // internal, temporary Stream
      fCurrentPackageComplete: Boolean;

      procedure WriteHeader(Target: TStream);

      function GetDataSize: Cardinal;
      function GetCurrentPacketSize: Cardinal;

      function GetHasContinuedPacket: Boolean;
      function GetIsFirstPage: Boolean;
      function GetIsLastPage: Boolean;

      procedure SetHasContinuedPacket(Value: Boolean);
      procedure SetIsFirstPage(Value: Boolean);
      procedure SetIsLastPage(Value: Boolean);


      function GetAbsolutePosition: Int64;
      function GetSerial: Cardinal;
      function GetPageNumber: Integer;
      function GetChecksum: Cardinal;
      function GetSegmentCount: Byte;

      procedure SetSerial(Value: Cardinal);
      procedure SetPageNumber(Value: Integer);
      procedure SetSegmentCount(Value: Byte);

      function AllDataProcessed: Boolean;


    public
      property ValidHeader: Boolean read fValidHeader;
      property ValidPage: Boolean read fValidPage;

      property HasContinuedPacket: Boolean read GetHasContinuedPacket write SetHasContinuedPacket;
      property IsFirstPage: Boolean read GetIsFirstPage write SetIsFirstPage;
      property IsLastPage: Boolean read GetIsLastPage write SetIsLastPage;

      property AbsolutePosition: Int64 read  GetAbsolutePosition;
      property Serial: Cardinal        read  GetSerial write SetSerial;
      property PageNumber: Integer     read  GetPageNumber write SetPageNumber;
      property Checksum: Cardinal      read  GetChecksum;
      property SegmentCount: Byte      read  GetSegmentCount write SetSegmentCount;

      property DataSize: Cardinal read GetDataSize;
      property CurrentPacketSize: Cardinal read GetCurrentPacketSize;

      property DataStream: TMemoryStream read fData;

      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      procedure ClearHeader; overload;
      procedure ClearHeader(aSerial: Cardinal; aPageNumber: Integer); overload;
      procedure Assign(Value: TOggPage);

      function CalculateChecksum: Cardinal;
      function ReadFromStream(Source: TStream): TAudioError;
      function WriteToStream(Target: TStream): TAudioError;

      function ReadHeader(Source: TStream): TAudioError;
      function ReadData(Source, Target: TStream): TAudioError;
      function ReadPacketData(Source, Target: TStream): TAudioError;

      function SkipData(Source: TStream): TAudioError;
  end;


  TOggContainer = class
    private
      fPhysicalStream: TStream;
      fCurrentPage: TOggPage;
      fMainSerial: Cardinal;

      procedure DoReplacePacket(Source: TOggPacket; Target: TOggPage);

    public
      property CurrentPage: TOggPage read fCurrentPage;
      property MainSerial: Cardinal read fMainSerial write fMainSerial;

      constructor Create(aStream: TStream); overload;
      constructor Create(aFilename: String); overload;
      destructor Destroy; override;

      procedure Reset;
      function KeepSerial: Cardinal;

      function ReadPacket(Target: TOggPacket; PageBuffer: TOggPage = Nil): TAudioError;
      function ReadPackets(Target: TObjectList): TAudioError;
      function ReadPage(Target: TOggPage): TAudioError;
      function ReadPages(Target: TObjectList): TAudioError;
      function GetMaxGranulePosition(StartPos: Int64 = -1): Int64;

      // ReplacePacket tries to replace the following Packet in the PhysicalStream with the Source Packet
      // This is possible, if the size of the Source Packet is of the same size as the following Packet,
      // or if the Source Packet is smaller, and we allow some padding to fill up the remaining space
      function ReplacePacket(Source: TOggPacket; maxPadding: Integer): Boolean;

      procedure WritePage(Source: TOggPage; PrepareNextPage: Boolean);
      procedure WritePacket(Source: TOggPacket; FinishPage: Boolean; PageBuffer: TOggPage = Nil);
      procedure CopyRemainsTo(Target: TStream); // Copy remaining parts of the Stream into Target
      procedure CopyRemainsFrom(Source: TStream; ReNumberPages: Boolean);
      procedure SetEndOfStream;
  end;


implementation

procedure CalculateCRC(var CRC: Cardinal; const Data; Size: Cardinal);
var
  Buffer: ^Byte;
  i: Cardinal;
begin
    Buffer := Addr(Data);
    for i := 1 to Size do begin
      CRC := (CRC shl 8) xor CRC_TABLE[((CRC shr 24) and $FF) xor Buffer^];
      inc(Buffer);
    end;
end;


{ TOggPage }

constructor TOggPage.Create;
begin
  inherited Create;
  fData := TMemoryStream.Create;
  fCurrentLacingIndex := 0;
  fFinished := False;
end;

destructor TOggPage.Destroy;
begin
  fData.Free;
  inherited;
end;

procedure TOggPage.Clear;
begin
  fData.Clear;
  ClearHeader;

  fValidHeader := False;
  fValidPage := False;

  fPositionInStream := 0;
  fCurrentLacingIndex := 0;
  fFinished := False;
end;


procedure TOggPage.ClearHeader;
begin
  ClearHeader(0, 0);
end;

procedure TOggPage.ClearHeader(aSerial: Cardinal; aPageNumber: Integer);
begin
  fHeader.ID := 'OggS';
  fHeader.StreamVersion := 0;
  fHeader.TypeFlag := 0;
  fHeader.AbsolutePosition := 0;
  fHeader.Serial := aSerial;
  fHeader.PageNumber := aPageNumber;
  fHeader.Checksum := 0;
  fHeader.Segments := 0;
  SetLength(fLacingValues, 0);
end;


procedure TOggPage.Assign(Value: TOggPage);
var
  i: Integer;

begin
  fHeader := Value.fHeader;
  SetLength(fLacingValues, Length(Value.fLacingValues));
  for i := Low(fLacingValues) to High(fLacingValues) do
    fLacingValues[i] := Value.fLacingValues[i];

  fValidHeader := Value.fValidHeader;
  fValidPage := Value.fValidPage;
  fPositionInStream := Value.fPositionInStream;
  fCurrentLacingIndex := Value.fCurrentLacingIndex;
  fCurrentPackageComplete := Value.fCurrentPackageComplete;
  fFinished := Value.fFinished;

  fData.Clear;
  fData.CopyFrom(Value.fData);
end;

function TOggPage.CalculateChecksum: Cardinal;
var
  crc: Cardinal;
  DataBuffer: TBuffer;
begin
  fData.Position := 0;
  SetLength(DataBuffer, fData.Size);
  fData.Read(DataBuffer[0], fData.Size);
  fHeader.Checksum := 0;
  crc := 0;

  CalculateCRC(crc, fHeader, 27);
  CalculateCRC(crc, fLacingValues[0], Length(fLacingValues));
  CalculateCRC(crc, DataBuffer[0], fData.Size);

  fHeader.Checksum := crc;
  result := crc;
end;

function TOggPage.AllDataProcessed: Boolean;
begin
  result := (fCurrentLacingIndex >= length(fLacingValues) );
end;


function TOggPage.GetCurrentPacketSize: Cardinal;
begin
  result := 0;
  fCurrentPackageComplete := False;

  while (not fCurrentPackageComplete) and (fCurrentLacingIndex < length(fLacingValues)) do begin
    result := result + fLacingValues[fCurrentLacingIndex];
    fCurrentPackageComplete := fLacingValues[fCurrentLacingIndex] < 255;
    inc(fCurrentLacingIndex);
  end;
end;

function TOggPage.GetDataSize: Cardinal;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to Length(fLacingValues)-1 do
    result := result + fLacingValues[i];
end;

function TOggPage.GetHasContinuedPacket: Boolean;
begin
  result := (fHeader.TypeFlag and 1) = 1;
end;

function TOggPage.GetIsFirstPage: Boolean;
begin
  result := (fHeader.TypeFlag and 2) = 2;
end;

function TOggPage.GetIsLastPage: Boolean;
begin
  result := (fHeader.TypeFlag and 4) = 4;
end;

procedure TOggPage.SetHasContinuedPacket(Value: Boolean);
begin
  if Value then
    fHeader.TypeFlag := fHeader.TypeFlag or 1
  else
    fHeader.TypeFlag := fHeader.TypeFlag and not 1
end;

procedure TOggPage.SetIsFirstPage(Value: Boolean);
begin
  if Value then
    fHeader.TypeFlag := fHeader.TypeFlag or 2
  else
    fHeader.TypeFlag := fHeader.TypeFlag and not 2
end;

procedure TOggPage.SetIsLastPage(Value: Boolean);
begin
  if Value then
    fHeader.TypeFlag := fHeader.TypeFlag or 4
  else
    fHeader.TypeFlag := fHeader.TypeFlag and not 4
end;

function TOggPage.GetAbsolutePosition: Int64;
begin
  result := fHeader.AbsolutePosition;
end;

function TOggPage.GetChecksum: Cardinal;
begin
  result := fHeader.Checksum;
end;

function TOggPage.GetPageNumber: Integer;
begin
  result := fHeader.PageNumber;
end;

function TOggPage.GetSegmentCount: Byte;
begin
  result := fHeader.Segments;
end;

function TOggPage.GetSerial: Cardinal;
begin
  result := fHeader.Serial;
end;

procedure TOggPage.SetSerial(Value: Cardinal);
begin
  fHeader.Serial := Value;
end;

procedure TOggPage.SetPageNumber(Value: Integer);
begin
  fHeader.PageNumber := Value;
end;

procedure TOggPage.SetSegmentCount(Value: Byte);
begin
  fHeader.Segments := Value;
  SetLength(fLacingValues, fHeader.Segments);
end;

function TOggPage.ReadHeader(Source: TStream): TAudioError;
begin
  result := FileErr_None;

  fPositionInStream := Source.Position;
  // read the constant part of the OggHeader from the current position in the stream
  if Source.Read(fHeader, SizeOf(fHeader)) <> SizeOf(fHeader) then
    result := OggErr_InvalidPageHeader
  else begin
    // read LacingValues
    Setlength(fLacingValues, fHeader.Segments);
    if fHeader.Segments > 0 then begin
      if Source.Read(fLacingValues[0], length(fLacingValues)) <> length(fLacingValues) then
        result := OggErr_InvalidPageHeader;
    end;
    fCurrentLacingIndex := 0;
    // Check for valid ID
    fValidHeader := fHeader.ID = OGG_PAGE_ID;
    if not fValidHeader then
      result := OggErr_InvalidPageHeader;
  end;
end;

function TOggPage.ReadPacketData(Source, Target: TStream): TAudioError;
begin
  try
    Target.CopyFrom(Source, CurrentPacketSize);
    Result := FileErr_None;
  except
    result := OggErr_InvalidPage;
  end;
end;

function TOggPage.ReadData(Source, Target: TStream): TAudioError;
begin
  try
    Target.CopyFrom(Source, DataSize);
    fCurrentLacingIndex := fHeader.Segments;
    Result := FileErr_None;
  except
    result := OggErr_InvalidPage;
  end;
end;

function TOggPage.SkipData(Source: TStream): TAudioError;
begin
  Result := FileErr_None;
  try
    Source.Seek(DataSize, soFromCurrent);
  except
    result := OggErr_InvalidPage;
  end;
end;

function TOggPage.ReadFromStream(Source: TStream): TAudioError;
begin
  Result := ReadHeader(Source);
  fData.Clear;
  if Result = FileErr_None then
    Result := ReadData(Source, fData);
end;

function TOggPage.WriteToStream(Target: TStream): TAudioError;
begin
  result := FileErr_None;
  try
    WriteHeader(Target);
    fData.Position := 0;
    Target.CopyFrom(fData);
  except
    result := FileErr_StreamWrite;
  end;
end;

procedure TOggPage.WriteHeader(Target: TStream);
begin
  // Note: The Header should be valid here, including the Checksum
  Target.Write(fHeader, SizeOf(fHeader));
  Target.Write(fLacingValues[0], length(fLacingValues));
end;


{ TOggContainer }

constructor TOggContainer.Create(aStream: TStream);
begin
  inherited Create;
  fPhysicalStream := aStream;
  fCurrentPage := TOggPage.Create;
end;

constructor TOggContainer.Create(aFilename: String);
begin
  inherited Create;
  fPhysicalStream := TFileStream.Create(aFilename, fmOpenread);
  fCurrentPage := TOggPage.Create;
end;

destructor TOggContainer.Destroy;
begin
  fCurrentPage.Free;
  inherited;
end;

procedure TOggContainer.Reset;
begin
  fPhysicalStream.Position := 0;
  fCurrentPage.Clear;
  fCurrentPage.Serial := MainSerial;
  fCurrentPage.IsFirstPage := True;
  fCurrentPage.IsLastPage := False;
  fCurrentPage.HasContinuedPacket := False;
end;

function TOggContainer.KeepSerial: Cardinal;
begin
  fMainSerial := fCurrentPage.Serial;
  result := fMainSerial;
end;

procedure TOggContainer.CopyRemainsTo(Target: TStream);
var
  p: Int64;
begin
  p := fPhysicalStream.Position;
  Target.CopyFrom(fPhysicalStream, fPhysicalStream.Size - fPhysicalStream.Position);
  fPhysicalStream.Position := p;
end;

procedure TOggContainer.CopyRemainsFrom(Source: TStream; ReNumberPages: Boolean);
var
  BackupContainer: TOggContainer;
  BackupPage: TOggPage;
  aErr: TAudioError;
  pn: Integer;
begin
  BackupContainer := TOggContainer.Create(Source);
  BackupPage := TOggPage.Create;
  try
    aErr := BackupContainer.ReadPage(BackupPage);
    if (fCurrentPage.PageNumber = BackupPage.PageNumber) or not ReNumberPages then begin
      // just copy all the data
      fPhysicalStream.CopyFrom(Source);
    end else begin
      // renumbering the Pages is necessary (and wanted)
      BackupPage.PageNumber := fCurrentPage.PageNumber;
      pn := BackupPage.PageNumber;
      WritePage(BackupPage, False); // Checksum-Calculation is done in WritePage

      while (aErr = FileErr_None) and not BackupPage.IsLastPage do begin
        inc(pn);
        aErr := BackupContainer.ReadPage(BackupPage);
        if aErr = FileErr_None then begin
          BackupPage.PageNumber := pn;
          WritePage(BackupPage, False);
        end;
      end;
      // if there is more data (e.g. nother logical stream?): just copy the rest of the backup
      if BackupContainer.fPhysicalStream.Position < BackupContainer.fPhysicalStream.Size then
        fPhysicalStream.CopyFrom(Source, BackupContainer.fPhysicalStream.Size - BackupContainer.fPhysicalStream.Position);
    end;
  finally
    BackupContainer.Free;
  end;
end;

procedure TOggContainer.SetEndOfStream;
begin
  SetStreamEnd(fPhysicalStream);
end;

function TOggContainer.ReadPacket(Target: TOggPacket; PageBuffer: TOggPage = Nil): TAudioError;
begin
  result := FileErr_None;

  if PageBuffer = Nil then
    PageBuffer := fCurrentPage;

  // read next header if needed
  if PageBuffer.AllDataProcessed then begin
    PageBuffer.Clear;
    result := PageBuffer.ReadHeader(fPhysicalStream);
  end;

  if result = FileErr_None then begin
    Target.fStartPage := PageBuffer.PageNumber;
    // read PacketData from the current page
    result := PageBuffer.ReadPacketData(fPhysicalStream, Target.fData);
    // read more data until the packet is finished
    while (result = FileErr_None)
        and PageBuffer.AllDataProcessed
        and (not PageBuffer.fCurrentPackageComplete)
        and (not (PageBuffer.IsLastPage))
    do begin
      result := PageBuffer.ReadHeader(fPhysicalStream);

      if result = FileErr_None then
        // check for Continued-packet-Flag
        if not PageBuffer.HasContinuedPacket then
          result := OggErr_InvalidPacket;

      if result = FileErr_None then
        // read next packet segment
        result := PageBuffer.ReadPacketData(fPhysicalStream, Target.fData)
    end;

    Target.fEndPage := PageBuffer.PageNumber;
    Target.fFinishesPage := PageBuffer.AllDataProcessed;
  end else
  begin
      result := result;
  end;
end;

function TOggContainer.ReadPackets(Target: TObjectList): TAudioError;
var
  LastError: TAudioError;
  newPacket: TOggPacket;

  function CreateNewPacket: TOggPacket;
  begin
    result := TOggPacket.Create;
    try
      LastError := ReadPacket(result);
      // Packets are usually rather small. FData is a MemoryStream, which has a default Capacity of 8k
      // This is a huge overload, and can lead to OutOfMemory Exceptions on larger files with many packets
      // Therefore: The Data is complete here, set the size (and the capacity!) to its current size.
      result.fData.SetSize(result.fData.Size);
    except
      FreeAndNil(result);
    end;
  end;

begin
  Target.Clear;
  LastError := FileErr_None;

  newPacket := CreateNewPacket;
  if LastError = FileErr_None then
    Target.Add(newPacket);

  while assigned(newPacket)
        and not (newPacket.FinishesPage and CurrentPage.IsLastPage)
        and (LastError = FileErr_None)
  do begin
    newPacket := CreateNewPacket;
    if LastError = FileErr_None then
      Target.Add(newPacket);
  end;
  result := LastError;
end;

function TOggContainer.ReadPage(Target: TOggPage): TAudioError;
begin
  if not assigned(Target) then
    Target := fCurrentPage;

  Target.Clear;
  result := Target.ReadFromStream(fPhysicalStream);
end;

function TOggContainer.ReadPages(Target: TObjectList): TAudioError;
var
  newPage: TOggPage;
  LastError: TAudioError;

  function CreateNewPage: TOggPage;
  begin
    result := TOggPage.Create;
    try
      LastError := result.ReadFromStream(fPhysicalStream);
    except
      FreeAndNil(result);
    end;
  end;

begin
  Target.Clear;
  LastError := FileErr_None;

  newPage := CreateNewPage;
  if LastError = FileErr_None then
    Target.Add(newPage);

  while assigned(newPage)
        and not (newPage.IsLastPage)
        and (LastError = FileErr_None)
  do begin
    newPage := CreateNewPage;
    if LastError = FileErr_None then
      Target.Add(newPage);
  end;

  result := LastError;
end;

function TOggContainer.GetMaxGranulePosition(StartPos: Int64 = -1): Int64;
var
  aPage: TOggPage;
  oldPos: Int64;
  LastError: TAudioError;
begin
  oldPos := fPhysicalStream.Position;
  if StartPos >= 0 then
    fPhysicalStream.Position := StartPos;

  LastError := FileErr_None;
  result := 0;
  aPage := TOggPage.Create;
  try
    while (LastError = FileErr_None) and (fPhysicalStream.Position < fPhysicalStream.Size) do begin
      LastError := aPage.ReadHeader(fPhysicalStream);
      if (LastError = FileErr_None) then begin
        if aPage.AbsolutePosition > result then
          result := aPage.AbsolutePosition;
        LastError := aPage.SkipData(fPhysicalStream);
        aPage.Clear;
      end;
    end;
  finally
    aPage.Free;
  end;
  fPhysicalStream.Position := oldPos;
end;


procedure TOggContainer.DoReplacePacket(Source: TOggPacket; Target: TOggPage);
var
  nextChunk: Cardinal;
  BytesWritten: Int64;
  currentWorkingPos: Int64;
  tmpPage: TOggPage;

begin
  // This is a private method. We actually do overwrite existing data here, without checking anything
  // Note: The existing packet we are going to overwrite here has
  //       the exact same size as the new Source packet

  if Target.AllDataProcessed then begin
    Target.Clear;
    Target.ReadHeader(fPhysicalStream); // yes, READ a new PageHeader
  end;

  BytesWritten := 0;
  Source.Data.Position := 0;
  tmpPage := TOggPage.Create;
  try
    nextChunk := Target.GetCurrentPacketSize;
    while (BytesWritten < Source.Data.Size) do begin
      BytesWritten := BytesWritten + fPhysicalStream.CopyFrom(Source.Data, nextChunk);
      // remember current Position
      currentWorkingPos := fPhysicalStream.Position;
      // jump back to the beginning of the current Page (it should be complete now)
      fPhysicalStream.Position := Target.fPositionInStream;
      // read the freshly written page again and re-calculate the checksum
      ReadPage(tmpPage);
      tmpPage.CalculateChecksum;
      // Back to the beginning of the page and rewrite the header (the important part is the checksum!)
      fPhysicalStream.Position := tmpPage.fPositionInStream;
      tmpPage.WriteHeader(fPhysicalStream);
      // back to the current working position
      fPhysicalStream.Position := currentWorkingPos;

      if (BytesWritten < Source.Data.Size) then begin
        // prepare writing the next Chunk of Data
        Target.Clear;
        Target.ReadHeader(fPhysicalStream);
        nextChunk := Target.GetCurrentPacketSize;
      end;
    end;
  finally
    tmpPage.Free;
  end;
end;


function TOggContainer.ReplacePacket(Source: TOggPacket; maxPadding: Integer): Boolean;
var
  BackupPos: Int64;
  tmpOggPage: TOggPage;
  existingPacket: TOggPacket;
begin
  // Note: If this function fails, it MUST NOT change the internal position in fPhysicalStream
  // If it is successful, the desired operation is usually completed
  result := False;
  BackupPos := fPhysicalStream.Position;

  tmpOggPage := TOggPage.Create;
  existingPacket := TOggPacket.Create;
  try
    // Switch to a temporary PageBuffer, we don't want to change internal fCurrentPage for now
    tmpOggPage.Assign(fCurrentPage);
    // Read the existing Packet
    if ReadPacket(existingPacket, tmpOggPage) <> FileErr_None then
      fPhysicalStream.Position := BackupPos
    else begin
      if (maxPadding > 0)
        and (ExistingPacket.Data.Size > Source.Data.Size)
        and (ExistingPacket.Data.Size - Source.Data.Size < maxPadding)
      then
        AddZeroPadding(Source.Data, ExistingPacket.Data.Size - Source.Data.Size);

      fPhysicalStream.Position := BackupPos;
      if (ExistingPacket.Data.Size = Source.Data.Size) then begin
        // now actually replace the Packet, using fCurrentPage
        DoReplacePacket(Source, fCurrentPage);
        result := True;
      end;
    end;
  finally
    existingPacket.Free;
    tmpOggPage.Free;
  end;
end;

procedure TOggContainer.WritePacket(Source: TOggPacket; FinishPage: Boolean; PageBuffer: TOggPage = Nil);
var
  AllNewLacingValues: TLacingValues;
  AllNewLacingIdx, PageLacingIdx: Integer;
  i, NextChunkCount: Integer;
begin
  if PageBuffer = Nil then
    PageBuffer := fCurrentPage;

  Source.Data.Position := 0;
  AllNewLacingIdx := 0;
  SetLength(AllNewLacingValues, (Source.Data.Size Div 255) + 1);

  // ... write Values for new Comments
  for i := 0 to Length(AllNewLacingValues) - 2 do
    AllNewLacingValues[i] := 255;
  AllNewLacingValues[Length(AllNewLacingValues) -1] := (Source.Data.Size Mod 255);


  if PageBuffer.fFinished or (Length(PageBuffer.fLacingValues) = 255 ) then begin
    // this should be NEVER the case
    // However, to be safe: Actually write the Page into the PhysicalStream and prepare the PageBuffer for more data to come
    WritePage(PageBuffer, true);
    PageBuffer.HasContinuedPacket := False;
  end;

  // Now we can start writing the PacketData into the PageBuffer.
  // Note that there may be already some data in the PageBuffer
  while AllNewLacingIdx < Length(AllNewLacingValues) do begin

    // write as many data as possible into the PageBuffer
    NextChunkCount := 255 - Length(PageBuffer.fLacingValues); // maximum possible
    if NextChunkCount > (Length(AllNewLacingValues) - AllNewLacingIdx) then
      NextChunkCount := Length(AllNewLacingValues) - AllNewLacingIdx; // remaining amount of available data

    // Set newLacingValues in PageBuffer
    SetLength(PageBuffer.fLacingValues, Length(PageBuffer.fLacingValues) + NextChunkCount);
    PageLacingIdx := PageBuffer.fCurrentLacingIndex;
    for i := 0 to NextChunkCount - 1 do begin
      PageBuffer.fLacingValues[i + PageLacingIdx] := AllNewLacingValues[i + AllNewLacingIdx];
      // Note: a lacingValue can be 0 (to indicate the end of a segment with a size of n*255)
      // In that case, we do NOT copy the complete Source.Data into the stream.
      // Just do not write anything at all.
      if AllNewLacingValues[i + AllNewLacingIdx] > 0 then
        PageBuffer.DataStream.CopyFrom(Source.Data, AllNewLacingValues[i + AllNewLacingIdx]);
    end;
    // increase Indexes
    AllNewLacingIdx := AllNewLacingIdx + NextChunkCount;
    PageBuffer.fCurrentLacingIndex := PageBuffer.fCurrentLacingIndex + NextChunkCount;

    if (AllNewLacingIdx < Length(AllNewLacingValues)) then begin
      // Packet is NOT completely written
      // Write Page and continue
      WritePage(PageBuffer, true);
      PageBuffer.HasContinuedPacket := True;
    end else begin
      // Packet IS completely written
      // Change it from -1 to 0, as there is a Packet that ends on this page.
      // Doesn't matter if we write the Page NOW, or in (one of) the next call of WritePackets (which MUST follow!)
      PageBuffer.fHeader.AbsolutePosition := 0;
      Source.fEndPage := PageBuffer.PageNumber;
      if FinishPage or (PageBuffer.fCurrentLacingIndex >= 250) // Page is (almost) full anyway
      then begin
        WritePage(PageBuffer, true);
        PageBuffer.HasContinuedPacket := False;
      end;
    end;
  end;  // while

end;

procedure TOggContainer.WritePage(Source: TOggPage; PrepareNextPage: Boolean);
var
  pn: Integer;
begin
  // Calculate the Checksum and write the page into the PhysicalStream
  Source.fHeader.Segments := Length(Source.fLacingValues);
  Source.CalculateChecksum;
  Source.WriteToStream(fPhysicalStream);
  // Prepare the Pagebuffer (Source) for more data
  if PrepareNextPage then begin
    pn := Source.PageNumber;
    Source.Clear;
    Source.Serial := MainSerial;
    Source.IsFirstPage := False;
    Source.IsLastPage := False; // unless we want to manually write the last packet into the stream. But we do not want that.
    Source.HasContinuedPacket := False; // well, actually this is unknown here
    Source.PageNumber := pn + 1;

    Source.fHeader.AbsolutePosition := -1;
  end;
end;

{ TOggPacket }

procedure TOggPacket.Clear;
begin
  fData.Clear;
  fStartPage := 0;
  fEndPage := 0;
  fFinishesPage := False;
end;

constructor TOggPacket.Create;
begin
  inherited Create;
  fData := TMemoryStream.Create;
end;

destructor TOggPacket.Destroy;
begin
  fData.Free;
  inherited;
end;

end.
