{

  ***** BEGIN LICENSE BLOCK *****
  Version: MPL 1.1/GPL 2.0/LGPL 2.1

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at
  www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the
  License.

  The Original Code is FastFileStream.

  The Initial Developer of the Original Code is Flamefire.
  Portions created by the Initial Developer are Copyright (C) 2010
  the Initial Developer. All Rights Reserved.

  Contributor(s):
    Sebastian Jänicke (2010: MMF File Reader)
    Martok (Patch: https://www.entwickler-ecke.de/viewtopic.php?p=679456#679456 )

  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the GPL or the LGPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.

  ***** END LICENSE BLOCK *****

  Version 1.00
}

unit unFastFileStream;

interface

uses
  Windows, Classes, SysUtils, RTLConsts;

{$IFNDEF FPC}
type
  PtrInt = integer;
  PtrUInt = cardinal;
{$ENDIF}

type
  TFastFileStream = class(TStream)
  private
    FPointer: Pointer;
    FFile, FMapping: THandle;
    FRealSize,//Real size of the file
    FVirtualSize, //Current virtual size of the file (<=FRealSize)
    FBufferPos, //Pos of Buffer in fie
    FBufferSize, //Size of Buffer wanted
    FCurBufferSize, //current size of Buffer
    FAllocationGranularity, //used for efficient alignment
    FPosInBuffer: Int64; //current position in buffer (can be >=F(Cur)BufferSize)

    FReadOnly:Boolean;
    FFileName:String;
    procedure SetFileSize(const NewSize:Int64; reMap:Boolean=True);
    procedure SetBufferSize(const Value: Int64);
    procedure ReInitView;
    procedure AdjustCurBufferSize;
  protected
    function GetSize: Int64; override;
    procedure SetSize(const NewSize: Int64); override;
    procedure SetSizeInternal(const NewSize: Int64; setPosition:Boolean=True);
  public
    constructor Create(const AFileName: string; Mode: Word);  overload;
    constructor Create(const AFileName: string; Mode: Word; Rights: Cardinal); overload;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    property BufferSize: Int64 read FBufferSize write SetBufferSize;
    property FileName:string read FFileName;
    property Handle:THandle read FFile;
  end;

  function OffsetPointer(const Addr: Pointer; const Offset: PtrInt): Pointer;
  function SubtractPointer(const Addr1, Addr2: Pointer): PtrInt;

implementation

function OffsetPointer(const Addr: Pointer; const Offset: PtrInt): Pointer; inline;
begin
  Result:= {%H-}Pointer({%H-}PtrUInt(Addr) + Offset);
end;

function SubtractPointer(const Addr1, Addr2: Pointer): PtrInt; inline;
begin
  Result:= {%H-}PtrUInt(Addr1) - {%H-}PtrUInt(Addr2);
end;

{ TFileReader }

constructor TFastFileStream.Create(const AFileName: string; Mode: Word);
var
  SysInfo: _SYSTEM_INFO;
  access:Cardinal;
begin
  if Mode = fmCreate then begin
    FFile:=FileCreate(AFileName);
    if FFile = INVALID_HANDLE_VALUE then
      raise EFCreateError.CreateResFmt(@SFCreateErrorEx, [ExpandFileName(AFileName), SysErrorMessage(GetLastError)]);
    FReadOnly:=False;
  end else begin
    FFile:=FileOpen(AFileName, Mode);
    if FFile = INVALID_HANDLE_VALUE then
      raise EFOpenError.CreateResFmt(@SFOpenErrorEx, [ExpandFileName(AFileName), SysErrorMessage(GetLastError)]);
    FReadOnly:=(Mode and 3)=0;
  end;
  FFileName:=AFileName;
  if FFile = INVALID_HANDLE_VALUE then
    raise Exception.Create('Es ist ein Fehler aufgetreten:' + #13#10
      + SysErrorMessage(GetLastError()))
  else
  begin
    PCardinal(@FRealSize)^:=GetFileSize(FFile,@Int64Rec(FRealSize).Hi);
    if(FRealSize<>0) then begin
      if(FReadOnly) then access:=PAGE_READONLY
      else access:=PAGE_READWRITE;
      FMapping := CreateFileMapping(FFile, nil, access, 0, 0, nil);
      if(GetLastError()<>0) then
        raise Exception.Create('Es ist ein Fehler aufgetreten:' + #13#10
          + SysErrorMessage(GetLastError()));
    end else FMapping:=INVALID_HANDLE_VALUE;
  end;
  GetSystemInfo(SysInfo);
  FAllocationGranularity := SysInfo.dwAllocationGranularity;
  FBufferPos := 0;
  if FRealSize >= 224 * FAllocationGranularity then
    FBufferSize := 224 * FAllocationGranularity
  else
    FBufferSize := 16 * FAllocationGranularity;
  FCurBufferSize := FBufferSize;
  FVirtualSize:=FRealSize;
  FPosInBuffer := 0;
  ReInitView;
end;

procedure TFastFileStream.SetFileSize(const NewSize: Int64; reMap:Boolean=True);
begin
  if(FReadOnly and reMap) then exit;
  if Assigned(FPointer) then begin
    if(not FReadOnly) then FlushViewOfFile(FPointer,0);
    UnmapViewOfFile(FPointer);
    FPointer:=nil;
  end;
  if(FMapping<>INVALID_HANDLE_VALUE) then begin
    CloseHandle(FMapping);
    FMapping:=INVALID_HANDLE_VALUE;
  end;
  if(FReadOnly) then exit;
  if(NewSize<FRealSize) then begin
    FileSeek(FFile,NewSize,Ord(soBeginning));
    SetEndOfFile(FFile);
  end;
  FRealSize:=NewSize;
  if(reMap) then begin
    FMapping := CreateFileMapping(FFile, nil, PAGE_READWRITE, Int64Rec(FRealSize).Hi,Int64Rec(FRealSize).Lo, nil);
    if(GetLastError()<>0) then
      raise Exception.Create('Es ist ein Fehler aufgetreten:' + #13#10
        + SysErrorMessage(GetLastError()));
    ReInitView;
  end;
end;

constructor TFastFileStream.Create(const AFileName: string; Mode: Word;
  Rights: Cardinal);
begin
  Create(AFileName,Mode);
end;

destructor TFastFileStream.Destroy;
begin
  SetFileSize(FVirtualSize,false);
  CloseHandle(FFile);
  inherited;
end;

procedure TFastFileStream.ReInitView;
var nBuffSize,access:Cardinal;
begin
  if Assigned(FPointer) then begin
    if(not FReadOnly) then FlushViewOfFile(FPointer,0);
    UnmapViewOfFile(FPointer);
    FPointer:=nil;
  end;
  //if FVirtualSize < FBufferPos + FBufferSize then begin
  //  if(FVirtualSize<FBufferPos) then FCurBufferSize:=0
  //  else FCurBufferSize := FVirtualSize - FBufferPos;
  //end else
  //  FCurBufferSize := FBufferSize;
  AdjustCurBufferSize;
  if FRealSize < FBufferPos + FBufferSize then begin
    if(FRealSize<FBufferPos) then nBuffSize:=0
    else nBuffSize := FRealSize - FBufferPos;
  end else
    nBuffSize := FBufferSize;
  if(nBuffSize>0) then begin
      if(FReadOnly) then access:=FILE_MAP_READ
      else access:=FILE_MAP_WRITE;
      FPointer := MapViewOfFile(FMapping,access , Int64Rec(FBufferPos).Hi, Int64Rec(FBufferPos).Lo, nBuffSize);
  end;
end;

procedure TFastFileStream.AdjustCurBufferSize;
begin
  if FVirtualSize < FBufferPos + FBufferSize then begin
      if(FVirtualSize<FBufferPos) then FCurBufferSize:=0
      else FCurBufferSize := FVirtualSize - FBufferPos;
    end else
      FCurBufferSize := FBufferSize;
end;


function TFastFileStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var newPos:Int64;
begin
  case Origin of
    soBeginning: newPos := Offset;
    soCurrent: newPos:=FBufferPos + FPosInBuffer+Offset;
    soEnd: newPos := Size + Offset;
    else newPos:=-1;
  end;
  if(newPos>=0) then begin
    //if (newPos < FBufferPos) or (newPos >= FBufferPos + FCurBufferSize) then  begin
    if (newPos < FBufferPos) or (newPos >= FBufferPos + FBufferSize) then  begin
      FBufferPos := newPos - (newPos mod FAllocationGranularity);
      FPosInBuffer := newPos mod FAllocationGranularity;
      ReInitView;
    end else
      FPosInBuffer := newPos - FBufferPos;
    AdjustCurBufferSize;
  end;
  Result := FBufferPos + FPosInBuffer;
end;

procedure TFastFileStream.SetBufferSize(const Value: Int64);
begin
  if(Value<0) then exit;
  FBufferSize := Succ(Value div FAllocationGranularity) * FAllocationGranularity;
  ReInitView;
end;

function TFastFileStream.GetSize: Int64;
begin
  Result:=FVirtualSize;
end;

procedure TFastFileStream.SetSize(const NewSize: Int64);
begin
  SetSizeInternal(NewSize);
end;

procedure TFastFileStream.SetSizeInternal(const NewSize: Int64;
  setPosition: Boolean);
var newSizeWanted:Int64;
begin
  //size changed?
  if(NewSize<>FVirtualSize) then begin
    if(FReadOnly) then begin
      SetLastError(ERROR_ACCESS_DENIED);
      exit;
    end;
    FVirtualSize:=NewSize;
    newSizeWanted:=FVirtualSize+FBufferSize*4;
    newSizeWanted := Succ(newSizeWanted div FAllocationGranularity) * FAllocationGranularity;
    if(FVirtualSize>FRealSize) or (newSizeWanted-FBufferSize*2>FRealSize) then
      SetFileSize(newSizeWanted);
  end;
  if(setPosition) then Seek(NewSize,soFromBeginning);
end;

function TFastFileStream.Read(var Buffer; Count: Integer): Longint;
var pTarget,pSrc:PByte;
    iRemain:Int64;
begin
  pTarget:=@Buffer;
  while(Count>0) do begin
    iRemain:=FCurBufferSize-FPosInBuffer;
    if(iRemain<Count) then begin
      if(Position>=Size) then break;
      if(iRemain>0) then begin
        //pSrc:=Ptr(Cardinal(FPointer)+FPosInBuffer);
        pSrc:= OffsetPointer(FPointer, FPosInBuffer);
        Move(pSrc^,pTarget^,iRemain);
        Inc(pTarget,iRemain);
        Dec(Count,iRemain);
      end;
      Seek(iRemain,soFromCurrent);
    end else begin
      //pSrc:=Ptr(Cardinal(FPointer)+FPosInBuffer);
      pSrc:=OffsetPointer(FPointer, FPosInBuffer);
      Move(pSrc^,pTarget^,Count);
      Seek(Count,soFromCurrent);
      Inc(pTarget,Count);
      Count:=0;
    end;
  end;
  //Result:=Cardinal(pTarget)-Cardinal(@Buffer);
  Result:=SubtractPointer(pTarget, @Buffer);
end;

function TFastFileStream.Write(const Buffer; Count: Integer): Longint;
var pTarget,pSrc:PByte;
    iRemain,curPos:Int64;
begin
  if(FReadOnly) then begin
    SetLastError(ERROR_ACCESS_DENIED);
    exit(0);
  end;

  //Resize if needed
  curPos:=Position;
  if(curPos+Count>Size) then begin
    SetSizeInternal(curPos+Count,False);
  end;

  pSrc:=@Buffer;
  while(Count>0) do begin
    iRemain:=FCurBufferSize-FPosInBuffer;
    if(iRemain<Count) then begin
      if(iRemain>0) then begin
        //pTarget:=Ptr(Cardinal(FPointer)+FPosInBuffer);
        pTarget:=OffsetPointer(FPointer, FPosInBuffer);
        Move(pSrc^,pTarget^,iRemain);
        Inc(pSrc,iRemain);
        Dec(Count,iRemain);
      end;
      Seek(iRemain,soFromCurrent);
    end else begin
      //pTarget:=Ptr(Cardinal(FPointer)+FPosInBuffer);
      pTarget:=OffsetPointer(FPointer, FPosInBuffer);
      Move(pSrc^,pTarget^,Count);
      Seek(Count,soFromCurrent);
      Inc(pSrc,Count);
      Count:=0;
    end;
  end;
  //Result:=Cardinal(pSrc)-Cardinal(@Buffer);
  Result:=SubtractPointer(pSrc, @Buffer);
end;

end.
