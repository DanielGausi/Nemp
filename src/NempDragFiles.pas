unit NempDragFiles;

interface

uses Windows, Graphics, SysUtils,  Forms, Controls, NempAudioFiles, Types,
   Classes, math, WinApi.ActiveX, ShlObj, ComObj, ShellApi,
   dialogs;


type

  TDragResult = (drInvalid, drCancelled, drDropped);

  //From SHLOBJ unit
  PDropFiles = ^TDropFiles;
  TDropFiles = packed record
    pFiles: DWORD;                       { offset of file list }
    pt: TPoint;                          { drop point (client coords) }
    fNC: BOOL;                           { is it on NonClient area }
    fWide: BOOL;                         { WIDE character switch }
  end;


  TNempDragOverEvent = procedure(Shift: TShiftState; State: TDragState;
    Pt: TPoint; var Effect: Integer; var Accept: Boolean) of object;

  TNempDropEvent = procedure(const DataObject: IDataObject; Shift: TShiftState;
    Pt: TPoint; var Effect: Integer) of object;


  // OLE drag'n drop support
  TFormatEtcArray = array of TFormatEtc;
  TFormatArray = array of Word;

  // IDataObject.SetData support
  TInternalStgMedium = packed record
    Format: TClipFormat;
    Medium: TStgMedium;
  end;
  TInternalStgMediumArray = array of TInternalStgMedium;

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FComponent: TComponent;
    FFormatEtcArray: TFormatEtcArray;
    FCurrentIndex: Integer;
  public
    constructor Create(Component: TComponent; const AFormatEtcArray: TFormatEtcArray);

    function Clone(out Enum: IEnumFormatEtc): HResult; stdcall;
    function Next(celt: Integer; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Skip(celt: Integer): HResult; stdcall;
  end;


  INempDragManager = interface(IUnknown)
    ['{9F7A449C-E1BF-4470-84E8-D1B850381A4C}']
    procedure ForceDragLeave; stdcall;
    function GetDataObject: IDataObject; stdcall;
    //function GetDragSource: TBaseVirtualTree; stdcall;
    function GetDropTargetHelperSupported: Boolean; stdcall;
    function GetIsDropTarget: Boolean; stdcall;

    property DataObject: IDataObject read GetDataObject;
    // property DragSource: TBaseVirtualTree read GetDragSource;
    property DropTargetHelperSupported: Boolean read GetDropTargetHelperSupported;
    property IsDropTarget: Boolean read GetIsDropTarget;
  end;


  // This data object is used in two different places. One is for clipboard operations and the other while dragging.
  TNempDataObject = class(TInterfacedObject, IDataObject)
  private
    FOwner: TComponent;          // The tree which provides clipboard or drag data.
    //fFileListBytes: Integer;
    fFileNames: TStringList;
    FFormatEtcArray: TFormatEtcArray;
    FInternalStgMediumArray: TInternalStgMediumArray;  // The available formats in the DataObject
    FAdviseHolder: IDataAdviseHolder;  // Reference to an OLE supplied implementation for advising.
  protected
    function CanonicalIUnknown(const TestUnknown: IUnknown): IUnknown;
    function EqualFormatEtc(FormatEtc1, FormatEtc2: TFormatEtc): Boolean;
    function FindFormatEtc(TestFormatEtc: TFormatEtc; const FormatEtcArray: TFormatEtcArray): integer;
    function FindInternalStgMedium(Format: TClipFormat): PStgMedium;
    function HGlobalClone(HGlobal: THandle): THandle;
    function RenderInternalOLEData(const FormatEtcIn: TFormatEtc; var Medium: TStgMedium; var OLEResult: HResult): Boolean;
    function StgMediumIncRef(const InStgMedium: TStgMedium; var OutStgMedium: TStgMedium;
      CopyInMedium: Boolean; const DataObject: IDataObject): HRESULT;

    property FormatEtcArray: TFormatEtcArray read FFormatEtcArray write FFormatEtcArray;
    property InternalStgMediumArray: TInternalStgMediumArray read FInternalStgMediumArray write FInternalStgMediumArray;
    property Owner: TComponent read FOwner;
  public
    constructor Create(AOwner: TComponent; FileList: TStringList); virtual;
    destructor Destroy; override;

    function DAdvise(const FormatEtc: TFormatEtc; advf: Integer; const advSink: IAdviseSink; out dwConnection: Integer):
      HResult; virtual; stdcall;
    function DUnadvise(dwConnection: Integer): HResult; virtual; stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult; virtual; stdcall;
    function EnumFormatEtc(Direction: Integer; out EnumFormatEtc: IEnumFormatEtc): HResult; virtual; stdcall;
    function GetCanonicalFormatEtc(const FormatEtc: TFormatEtc; out FormatEtcOut: TFormatEtc): HResult; virtual; stdcall;
    function GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HResult; virtual; stdcall;
    function GetDataHere(const FormatEtc: TFormatEtc; out Medium: TStgMedium): HResult; virtual; stdcall;
    function QueryGetData(const FormatEtc: TFormatEtc): HResult; virtual; stdcall;
    function SetData(const FormatEtc: TFormatEtc; var Medium: TStgMedium; DoRelease: BOOL): HResult; virtual; stdcall;
  end;



  TNempDragManager = class(TInterfacedObject, INempDragManager, IDropSource, IDropTarget)
  private
    FOwner: TCustomControl;                            // The tree which is responsible for drag management.
    // FDragSource: TBaseVirtualTree;     // Reference to the source tree if the source was a VT, might be different than
                                       // the owner tree.
    FIsDropTarget: Boolean;            // True if the owner is currently the drop target.
    //FDataObject: IDataObject;          // A reference to the data object passed in by DragEnter (only used when the owner
                                       // tree is the current drop target).
    FDropTargetHelper: IDropTargetHelper; // Win2k > Drag image support
    FFullDragging: BOOL;               // True, if full dragging is currently enabled in the system.
    fValidSource: Boolean;
    FDataObject: IDataObject;

    FDragSource: TControl; // replaces the old "DragSource"-Integer from the NempMainForm

    IsWinVistaOrAbove: Boolean;
    fListFilenames: TStringList;
    // fListAudioFiles: TAudioFileList;
    fDragBitmap: TBitmap;
    fUseDragBitmap: Boolean;

    fOnDragOver: TNempDragOverEvent;
    fOnDrop: TNempDropEvent;

    // fMaxDropFiles: Integer;

    function DoDragOver(KeyState: Integer; Pt: TPoint; State: TDragState; var Effect: LongInt): HResult;
    function DoDrop(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint; var Effect: Integer): HResult;

    function GetDataObject: IDataObject; stdcall;
    //function GetDragSource: TBaseVirtualTree; stdcall;
    function GetDropTargetHelperSupported: Boolean; stdcall;
    function GetIsDropTarget: Boolean; stdcall;
    //function GetAudioFilesCount: Integer;
    function GetFileNameCount: Integer;
    // function GetAudioFile(Index: Integer): TAudioFile;
    function GetFileName(Index: Integer): String;

    procedure ClearFiles;
    procedure AddCueFile(aFile: TAudioFile);
  public
    property OnDragOver: TNempDragOverEvent read fOnDragOver write fOnDragOver;
    property OnDrop: TNempDropEvent read fOnDrop write fOnDrop;
    property DataObject: IDataObject read GetDataObject; //FDataObject;
    //property AudioFilesCount: Integer read GetAudioFilesCount;
    property FileNameCount: Integer read GetFileNameCount;
    //property AudioFiles[Index: Integer]: TAudioFile read GetAudioFile;
    property FileNames[Index: Integer]: String read GetFileName;
    property DragSource: TControl read FDragSource write FDragSource;
    //property MaxDropFiles: Integer read fMaxDropFiles write fMaxDropFiles;
    property Files: tStringList read fListFilenames;

    constructor Create(AOwner: TCustomControl); virtual;
    destructor Destroy; override;

    // Managing the Files to DragDrop
    procedure AddFile(aFile: TAudioFile; IncludeCue: Boolean); overload;
    procedure AddFile(Filename: String); overload;
    procedure AddFiles(FileList: TStrings); overload;
    procedure AddFiles(FileList: TAudioFileList; IncludeCue: Boolean); overload;
    // procedure IncludeCueFiles(MinDuration: Integer = MIN_CUESHEET_DURATION);
    procedure SetDragGraphic(Source: TPicture);

    function RenderFilenames(out Medium: TStgMedium): HResult;

    procedure InitDrag(Source: TControl);
    procedure FinishDrag;
    function Execute: TDragResult;


    function DragEnter(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint;
      var Effect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function DragOver(KeyState: Integer; Pt: TPoint; var Effect: LongInt): HResult; stdcall;
    function Drop(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint; var Effect: Integer): HResult; stdcall;


    procedure ForceDragLeave; stdcall;
    function GiveFeedback(Effect: Integer): HResult; stdcall;
    function QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult; stdcall;



    //function _AddRef: Integer; stdcall;
    //function _Release: Integer; stdcall;
  end;


  procedure SetDragHint(DataObject: IDataObject; const szMessage, szInsert: string; Effect: Integer);
  procedure GetFileListFromObj(const DataObj: IDataObject; FileList: TStringList);
  function ObjContainsFiles(const DataObj: IDataObject): Boolean;
  function OLERenderFilenames(const Filenames: TStringList; out Medium: TStgMedium): HResult;

implementation

var
  FDragDescriptionFormat: LongInt;

  StandardOLEFormat: TFormatEtc = (
    // Format must later be set.
    cfFormat: 0;
    // No specific target device to render on.
    ptd: nil;
    // Normal content to render.
    dwAspect: DVASPECT_CONTENT;
    // No specific page of multipage data (we don't use multipage data by default).
    lindex: -1;
    // Acceptable storage formats are IStream and global memory. The first is preferred.
    tymed: TYMED_ISTREAM or TYMED_HGLOBAL;
  );

function ObjContainsFiles(const DataObj: IDataObject): Boolean;
var
  FmtEtc: TFormatEtc;
begin
  // Get required storage medium from data object
  FmtEtc.cfFormat := CF_HDROP;
  FmtEtc.ptd := nil;
  FmtEtc.dwAspect := DVASPECT_CONTENT;
  FmtEtc.lindex := -1;
  FmtEtc.tymed := TYMED_HGLOBAL;
  result := DataObj.QueryGetData(FmtEtc) = S_OK;
end;

procedure GetFileListFromObj(const DataObj: IDataObject;
  FileList: TStringList);
var
  FmtEtc: TFormatEtc;                   // specifies required data format
  Medium: TStgMedium;                   // storage medium containing file list
  DroppedFileCount: Integer;            // number of dropped files
  I: Integer;                           // loops thru dropped files
  FileNameLength: Integer;              // length of a dropped file name
  FileName: string;                 // name of a dropped file
begin
  // Get required storage medium from data object
  FmtEtc.cfFormat := CF_HDROP;
  FmtEtc.ptd := nil;
  FmtEtc.dwAspect := DVASPECT_CONTENT;
  FmtEtc.lindex := -1;
  FmtEtc.tymed := TYMED_HGLOBAL;
  try
    OleCheck(DataObj.GetData(FmtEtc, Medium));
  except
  end;

  try
    try
      // Get count of files dropped
      DroppedFileCount := DragQueryFile(
        Medium.hGlobal, $FFFFFFFF, nil, 0
        );
      // Get name of each file dropped and process it
      for I := 0 to Pred(DroppedFileCount) do
        begin
          // get length of file name, then name itself
          FileNameLength := DragQueryFile(Medium.hGlobal, I, nil, 0);
          SetLength(FileName, FileNameLength);
          DragQueryFileW(
            Medium.hGlobal, I, PWideChar(FileName), FileNameLength + 1
            );
          // add file name to list
          FileList.Append(FileName);
        end;
    finally
      // Tidy up - release the drop handle
      // don't use DropH again after this
      DragFinish(Medium.hGlobal);
    end;
  finally
    ReleaseStgMedium(Medium);
  end;
end;

function OLERenderFilenames(const Filenames: TStringList; out Medium: TStgMedium): HResult;
var
  I, offset, DataLength: Integer;
  ptrDropFile: pdropfiles;
begin
  DataLength := 2;
  for i := 0 to Filenames.count - 1 do
    inc(DataLength, length(Filenames[i])*SizeOf(Char) + SizeOf(Char)); // String#0

  //Result := DV_E_FORMATETC;
  Medium.hGlobal := GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, DataLength + sizeof(tdropfiles));
  if Medium.hGlobal = 0 then begin
    ZeroMemory (@Medium, SizeOf(Medium));
    Result:= E_OUTOFMEMORY;
    exit;
  end;

  ptrdropfile := globallock(Medium.hGlobal);
  with ptrdropfile^ do begin
    pfiles := SizeOf(Tdropfiles);
    pt.x := 0;
    pt.y := 0;
    longint(fnc) := 0;
    Fwide := True;
  end;

  //Add the filenames after header
  offset := sizeof(tdropfiles);
  for i := 1 to FileNames.count do begin
    if i = FileNames.count then
      StrPcopy( PChar(longint(ptrdropfile) + offset), FileNames[i-1] + #0#0)
    else
      StrPcopy( PChar(longint(ptrdropfile) + offset), FileNames[i-1] + #0);
    offset := offset + length(FileNames[i-1]) * SizeOf(Char) + SizeOf(Char);
  end;

  globalunlock(Medium.hGlobal);
  Medium.tymed := TYMED_HGLOBAL;
  Medium.unkForRelease := nil;
  Result := S_OK;
end;


procedure SetDragHint(DataObject: IDataObject; const szMessage, szInsert: string; Effect: Integer);
var
  FormatEtc: TFormatEtc;
  Medium: TStgMedium;
  Data: Pointer;
  Descr: DROPDESCRIPTION;
  s: WideString;
  maxL: Integer;
begin
  ZeroMemory(@Descr, SizeOf(DROPDESCRIPTION));
  {Do not set Descr.&type to DROPIMAGE_INVALID - this value ignore any custom hint}
  {use same image as dropeffect type}
  Descr.&type := DROPIMAGE_LABEL;
  case Effect of
    DROPEFFECT_NONE:
      Descr.&type := DROPIMAGE_NONE;
    DROPEFFECT_COPY:
      Descr.&type := DROPIMAGE_COPY;
    DROPEFFECT_MOVE:
      Descr.&type := DROPIMAGE_MOVE;
    DROPEFFECT_LINK:
      Descr.&type := DROPIMAGE_LINK;
  end;
  {format message for system}

  maxL := min(Length(szMessage), MAX_PATH-1);
  s := Copy(szMessage, 1, maxL);
  Move(s[1], Descr.szMessage[0], maxL * SizeOf(WideChar));

  maxL := min(Length(szInsert), MAX_PATH-1);
  s := Copy(szInsert, 1, maxL);
  Move(s[1], Descr.szInsert[0], maxL * SizeOf(WideChar));

  {prepare structures to set DROPDESCRIPTION data}
  FormatEtc.cfFormat := FDragDescriptionFormat; {registered clipboard format}
  FormatEtc.ptd := nil;
  FormatEtc.dwAspect := DVASPECT_CONTENT;
  FormatEtc.lindex := -1;
  FormatEtc.tymed := TYMED_HGLOBAL;

  ZeroMemory(@Medium, SizeOf(TStgMedium));
  Medium.tymed := TYMED_HGLOBAL;
  Medium.HGlobal := GlobalAlloc(GHND or GMEM_SHARE, SizeOf(DROPDESCRIPTION));
  Data := GlobalLock(Medium.HGlobal);
  Move(Descr, Data^, SizeOf(DROPDESCRIPTION));
  GlobalUnlock(Medium.HGlobal);

  DataObject.SetData(FormatEtc, Medium, True);
end;


  //----------------- TEnumFormatEtc -------------------------------------------------------------------------------------

constructor TEnumFormatEtc.Create(Component: TComponent; const AFormatEtcArray: TFormatEtcArray);

var
  I: Integer;

begin
  inherited Create;

  FComponent := Component;
  // Make a local copy of the format data.
  SetLength(FFormatEtcArray, Length(AFormatEtcArray));
  for I := 0 to High(AFormatEtcArray) do
    FFormatEtcArray[I] := AFormatEtcArray[I];
end;

//----------------------------------------------------------------------------------------------------------------------

function TEnumFormatEtc.Clone(out Enum: IEnumFormatEtc): HResult;

var
  AClone: TEnumFormatEtc;

begin
  Result := S_OK;
  try
    AClone := TEnumFormatEtc.Create(nil, FFormatEtcArray);
    AClone.FCurrentIndex := FCurrentIndex;
    Enum := AClone as IEnumFormatEtc;
  except
    Result := E_FAIL;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TEnumFormatEtc.Next(celt: Integer; out elt; pceltFetched: PLongint): HResult;

var
  CopyCount: Integer;

begin
  Result := S_FALSE;
  CopyCount := Length(FFormatEtcArray) - FCurrentIndex;
  if celt < CopyCount then
    CopyCount := celt;
  if CopyCount > 0 then
  begin
    Move(FFormatEtcArray[FCurrentIndex], elt, CopyCount * SizeOf(TFormatEtc));
    Inc(FCurrentIndex, CopyCount);
    Result := S_OK;
  end;
  if Assigned(pceltFetched) then
    pceltFetched^ := CopyCount;
end;

//----------------------------------------------------------------------------------------------------------------------

function TEnumFormatEtc.Reset: HResult;

begin
  FCurrentIndex := 0;
  Result := S_OK;
end;

//----------------------------------------------------------------------------------------------------------------------

function TEnumFormatEtc.Skip(celt: Integer): HResult;
begin
  if FCurrentIndex + celt < High(FFormatEtcArray) then
  begin
    Inc(FCurrentIndex, celt);
    Result := S_Ok;
  end
  else
    Result := S_FALSE;
end;



constructor TNempDataObject.Create(AOwner: TComponent; FileList: TStringList);
begin
  inherited Create;
  FOwner := AOwner;
  SetLength(FFormatEtcArray, 1);
  FFormatEtcArray[0].cfFormat := CF_HDROP;
  FFormatEtcArray[0].ptd := nil;
  FFormatEtcArray[0].dwAspect := DVASPECT_CONTENT;
  FFormatEtcArray[0].lindex := -1;
  FFormatEtcArray[0].tymed := TYMED_HGLOBAL;

  fFileNames := TStringList.Create;
  fFileNames.Assign(FileList);
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TNempDataObject.Destroy;
var
  I: Integer;
  StgMedium: PStgMedium;
begin
  // Release any internal clipboard formats
  for I := 0 to High(FormatEtcArray) do
  begin
    StgMedium := FindInternalStgMedium(FormatEtcArray[I].cfFormat);
    if Assigned(StgMedium) then
      ReleaseStgMedium(StgMedium^);
  end;

  fFileNames.Free;
  FormatEtcArray := nil;
  inherited;
end;

function TNempDataObject.CanonicalIUnknown(const TestUnknown: IUnknown): IUnknown;
// Uses COM object identity: An explicit call to the IUnknown::QueryInterface method, requesting the IUnknown
// interface, will always return the same pointer.
begin
  if Assigned(TestUnknown) then
  begin
    if TestUnknown.QueryInterface(IUnknown, Result) = 0 then
      Result._Release // Don't actually need it just need the pointer value
    else
      Result := TestUnknown;
  end
  else
    Result := TestUnknown;
end;

function TNempDataObject.EqualFormatEtc(FormatEtc1, FormatEtc2: TFormatEtc): Boolean;
begin
  Result := (FormatEtc1.cfFormat = FormatEtc2.cfFormat) and (FormatEtc1.ptd = FormatEtc2.ptd) and
    (FormatEtc1.dwAspect = FormatEtc2.dwAspect) and (FormatEtc1.lindex = FormatEtc2.lindex) and
    (FormatEtc1.tymed and FormatEtc2.tymed <> 0);
end;

function TNempDataObject.FindFormatEtc(TestFormatEtc: TFormatEtc; const FormatEtcArray: TFormatEtcArray): integer;
var
  I: integer;
begin
  Result := -1;
  for I := 0 to High(FormatEtcArray) do
  begin
    if EqualFormatEtc(TestFormatEtc, FormatEtcArray[I]) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TNempDataObject.FindInternalStgMedium(Format: TClipFormat): PStgMedium;
var
  I: integer;
begin
  Result := nil;
  for I := 0 to High(InternalStgMediumArray) do
  begin
    if Format = InternalStgMediumArray[I].Format then
    begin
      Result := @InternalStgMediumArray[I].Medium;
      Break;
    end;
  end;
end;

function TNempDataObject.HGlobalClone(HGlobal: THandle): THandle;
// Returns a global memory block that is a copy of the passed memory block.
var
  Size: Cardinal;
  Data,
  NewData: PByte;

begin
  Size := GlobalSize(HGlobal);
  Result := GlobalAlloc(GPTR, Size);
  Data := GlobalLock(hGlobal);
  try
    NewData := GlobalLock(Result);
    try
      Move(Data^, NewData^, Size);
    finally
      GlobalUnLock(Result);
    end;
  finally
    GlobalUnLock(hGlobal);
  end;
end;

function TNempDataObject.RenderInternalOLEData(const FormatEtcIn: TFormatEtc; var Medium: TStgMedium;
  var OLEResult: HResult): Boolean;
// Tries to render one of the formats which have been stored via the SetData method.
// Since this data is already there it is just copied or its reference count is increased (depending on storage medium).
var
  InternalMedium: PStgMedium;

begin
  Result := True;
  InternalMedium := FindInternalStgMedium(FormatEtcIn.cfFormat);
  if Assigned(InternalMedium) then
    OLEResult := StgMediumIncRef(InternalMedium^, Medium, False, Self as IDataObject)
  else
    Result := False;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.StgMediumIncRef(const InStgMedium: TStgMedium; var OutStgMedium: TStgMedium;
  CopyInMedium: Boolean; const DataObject: IDataObject): HRESULT;

// InStgMedium is the data that is requested, OutStgMedium is the data that we are to return either a copy of or
// increase the IDataObject's reference and send ourselves back as the data (unkForRelease). The InStgMedium is usually
// the result of a call to find a particular FormatEtc that has been stored locally through a call to SetData.
// If CopyInMedium is not true we already have a local copy of the data when the SetData function was called (during
// that call the CopyInMedium must be true). Then as the caller asks for the data through GetData we do not have to make
// copy of the data for the caller only to have them destroy it then need us to copy it again if necessary.
// This way we increase the reference count to ourselves and pass the STGMEDIUM structure initially stored in SetData.
// This way when the caller frees the structure it sees the unkForRelease is not nil and calls Release on the object
// instead of destroying the actual data.

var
  Len: Integer;

begin
  Result := S_OK;

  // Simply copy all fields to start with.
  OutStgMedium := InStgMedium;
  // The data handled here always results from a call of SetData we got. This ensures only one storage format
  // is indicated and hence the case statement below is safe (IDataObject.GetData can optionally use several
  // storage formats).
  case InStgMedium.tymed of
    TYMED_HGLOBAL:
      begin
        if CopyInMedium then
        begin
          // Generate a unique copy of the data passed
          OutStgMedium.hGlobal := HGlobalClone(InStgMedium.hGlobal);
          if OutStgMedium.hGlobal = 0 then
            Result := E_OUTOFMEMORY;
        end
        else
          // Don't generate a copy just use ourselves and the copy previously saved.
          OutStgMedium.unkForRelease := Pointer(DataObject); // Does not increase RefCount.
      end;
    TYMED_FILE:
      begin
        Len := lstrLenW(InStgMedium.lpszFileName) + 1; // Don't forget the terminating null character.
        OutStgMedium.lpszFileName := CoTaskMemAlloc(2 * Len);
        Move(InStgMedium.lpszFileName^, OutStgMedium.lpszFileName^, 2 * Len);
      end;
    TYMED_ISTREAM:
      IUnknown(OutStgMedium.stm)._AddRef;
    TYMED_ISTORAGE:
      IUnknown(OutStgMedium.stg)._AddRef;
    TYMED_GDI:
      if not CopyInMedium then
        // Don't generate a copy just use ourselves and the previously saved data.
        OutStgMedium.unkForRelease := Pointer(DataObject) // Does not increase RefCount.
      else
        Result := DV_E_TYMED; // Don't know how to copy GDI objects right now.
    TYMED_MFPICT:
      if not CopyInMedium then
        // Don't generate a copy just use ourselves and the previously saved data.
        OutStgMedium.unkForRelease := Pointer(DataObject) // Does not increase RefCount.
      else
        Result := DV_E_TYMED; // Don't know how to copy MetaFile objects right now.
    TYMED_ENHMF:
      if not CopyInMedium then
        // Don't generate a copy just use ourselves and the previously saved data.
        OutStgMedium.unkForRelease := Pointer(DataObject) // Does not increase RefCount.
      else
        Result := DV_E_TYMED; // Don't know how to copy enhanced metafiles objects right now.
  else
    Result := DV_E_TYMED;
  end;

  if (Result = S_OK) and Assigned(OutStgMedium.unkForRelease) then
    IUnknown(OutStgMedium.unkForRelease)._AddRef;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.DAdvise(const FormatEtc: TFormatEtc; advf: Integer; const advSink: IAdviseSink;
  out dwConnection: Integer): HResult;
// Advise sink management is greatly simplified by the IDataAdviseHolder interface.
// We use this interface and forward all concerning calls to it.
begin
  Result := S_OK;
  if FAdviseHolder = nil then
    Result := CreateDataAdviseHolder(FAdviseHolder);
  if Result = S_OK then
    Result := FAdviseHolder.Advise(Self as IDataObject, FormatEtc, advf, advSink, dwConnection);
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.DUnadvise(dwConnection: Integer): HResult;

begin
  if FAdviseHolder = nil then
    Result := E_NOTIMPL
  else
    Result := FAdviseHolder.Unadvise(dwConnection);
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.EnumDAdvise(out enumAdvise: IEnumStatData): HResult;

begin
  if FAdviseHolder = nil then
    Result := OLE_E_ADVISENOTSUPPORTED
  else
    Result := FAdviseHolder.EnumAdvise(enumAdvise);
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.EnumFormatEtc(Direction: Integer; out EnumFormatEtc: IEnumFormatEtc): HResult;

var
  NewList: TEnumFormatEtc;

begin
  Result := E_FAIL;
  if Direction = DATADIR_GET then
  begin
    NewList := TEnumFormatEtc.Create(FOwner, FormatEtcArray);
    EnumFormatEtc := NewList as IEnumFormatEtc;
    Result := S_OK;
  end
  else
    EnumFormatEtc := nil;
  if EnumFormatEtc = nil then
    Result := OLE_S_USEREG;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDataObject.GetCanonicalFormatEtc(const FormatEtc: TFormatEtc; out FormatEtcOut: TFormatEtc): HResult;

begin
  Result := DATA_S_SAMEFORMATETC;
end;

function TNempDataObject.GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HResult;
var
  i: Integer;
begin
    if FormatEtcIn.cfFormat = CF_HDROP then
    begin
      // Render the Filenames
      if Succeeded(QueryGetData(formatetcIn)) then
        result := OLERenderFilenames(fFilenames, Medium)
      else
        Result := E_FAIL;
    end
    else
    try
      // See if we accept this type and if not get the correct return value.
      Result := QueryGetData(FormatEtcIn);
      if (Result = S_OK) then
      begin
        for i := 0 to High(FormatEtcArray) do
        begin
          if EqualFormatEtc(FormatEtcIn, FormatEtcArray[i]) then
          begin
            RenderInternalOLEData(FormatEtcIn, Medium, Result);
            Break;
          end;
        end;
      end;
    except
      ZeroMemory (@Medium, SizeOf(Medium));
      Result := E_FAIL;
    end;
end;

function TNempDataObject.GetDataHere(const FormatEtc: TFormatEtc; out Medium: TStgMedium): HResult;
begin
  Result := E_NOTIMPL;
end;

function TNempDataObject.QueryGetData(const FormatEtc: TFormatEtc): HResult;
var
  i: Integer;
begin
  Result := DV_E_CLIPFORMAT;
  for i := 0 to High(FFormatEtcArray) do
  begin
    if FormatEtc.cfFormat = FFormatEtcArray[i].cfFormat then
    begin
      if (FormatEtc.tymed and FFormatEtcArray[i].tymed) <> 0 then
      begin
        if FormatEtc.dwAspect = FFormatEtcArray[i].dwAspect then
        begin
          if FormatEtc.lindex = FFormatEtcArray[i].lindex then
          begin
            Result := S_OK;
            Break;
          end
          else
            Result := DV_E_LINDEX;
        end
        else
          Result := DV_E_DVASPECT;
      end
      else
        Result := DV_E_TYMED;
    end;
  end;
end;

function TNempDataObject.SetData(const FormatEtc: TFormatEtc; var Medium: TStgMedium; DoRelease: BOOL): HResult;
var
  Index: Integer;
  LocalStgMedium: PStgMedium;
begin
  // See if we already have a format of that type available.
  Index := FindFormatEtc(FormatEtc, FormatEtcArray);
  if Index > - 1 then
  begin
    // Just use the TFormatEct in the array after releasing the data.
    LocalStgMedium := FindInternalStgMedium(FormatEtcArray[Index].cfFormat);
    if Assigned(LocalStgMedium) then
    begin
      ReleaseStgMedium(LocalStgMedium^);
      ZeroMemory(LocalStgMedium, SizeOf(LocalStgMedium^));
    end;
  end
  else
  begin
    // It is a new format so create a new TFormatCollectionItem, copy the
    // FormatEtc parameter into the new object and and put it in the list.
    SetLength(FFormatEtcArray, Length(FormatEtcArray) + 1);
    FormatEtcArray[High(FormatEtcArray)] := FormatEtc;

    // Create a new InternalStgMedium and initialize it and associate it with the format.
    SetLength(FInternalStgMediumArray, Length(InternalStgMediumArray) + 1);
    InternalStgMediumArray[High(InternalStgMediumArray)].Format := FormatEtc.cfFormat;
    LocalStgMedium := @InternalStgMediumArray[High(InternalStgMediumArray)].Medium;
    ZeroMemory(LocalStgMedium, SizeOf(LocalStgMedium^));
  end;

  if DoRelease then
  begin
    // We are simply being given the data and we take control of it.
    LocalStgMedium^ := Medium;
    Result := S_OK;
  end
  else
  begin
    // We need to reference count or copy the data and keep our own references to it.
    Result := StgMediumIncRef(Medium, LocalStgMedium^, True, Self as IDataObject);

    // Can get a circular reference if the client calls GetData then calls SetData with the same StgMedium.
    // Because the unkForRelease for the IDataObject can be marshalled it is necessary to get pointers that
    // can be correctly compared. See the IDragSourceHelper article by Raymond Chen at MSDN.
    if Assigned(LocalStgMedium.unkForRelease) then
    begin
      if CanonicalIUnknown(Self) = CanonicalIUnknown(IUnknown(LocalStgMedium.unkForRelease)) then
        IUnknown(LocalStgMedium.unkForRelease) := nil; // release the interface
    end;
  end;

  // Tell all registered advice sinks about the data change.
  if Assigned(FAdviseHolder) then
    FAdviseHolder.SendOnDataChange(Self as IDataObject, 0, 0);
end;



constructor TNempDragManager.Create(AOwner: TCustomControl);

begin
  inherited Create;
  FOwner := AOwner;
  fListFilenames := TStringList.Create;
  fDragBitmap := TBitmap.Create;
  IsWinVistaOrAbove := (Win32MajorVersion >= 6);
  // Create an instance  of the drop target helper interface. This will fail but not harm on systems which do
  // not support this interface (everything below Windows 2000);
  CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER, IID_IDropTargetHelper, FDropTargetHelper);
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TNempDragManager.Destroy;
begin
  // Set the owner's reference to us to nil otherwise it will access an invalid pointer
  // after our desctruction is complete.
  // Pointer(FOwner.FDragManager) := nil;
  try
    FDropTargetHelper._Release;
    FOwner := Nil;
    fListFilenames.Free;
    fDragBitmap.Free;
    inherited;
  except

  end;
end;

function TNempDragManager.GetFileName(Index: Integer): String;
begin
  if (Index >= 0) and (Index < fListFilenames.Count) then
    result := fListFilenames[Index]
  else
    result := '';
end;

function TNempDragManager.GetFileNameCount: Integer;
begin
  result := fListFilenames.Count;
end;

function TNempDragManager.GetDataObject: IDataObject;
begin
  // When the owner tree starts a drag operation then it gets a data object here to pass it to the OLE subsystem.
  // In this case there is no local reference to a data object and one is created (but not stored).
  // If there is a local reference then the owner tree is currently the drop target and the stored interface is
  // that of the drag initiator.
  if Assigned(FDataObject) then
    Result := FDataObject
  else
  begin
    Result := TNempDataObject.Create(FOwner, fListFilenames) as IDataObject;
  end;
end;

function TNempDragManager.GetDropTargetHelperSupported: Boolean;
begin
  Result := Assigned(FDropTargetHelper);
end;

function TNempDragManager.GetIsDropTarget: Boolean;
begin
  Result := FIsDropTarget;
end;


{
  Managing the List of Filenames that should be dragged
}
procedure TNempDragManager.ClearFiles;
begin
  fListFilenames.Clear;
end;

procedure TNempDragManager.AddCueFile(aFile: TAudioFile);
var
  cueFile: String;
begin
  if (aFile.Duration > MIN_CUESHEET_DURATION) then begin
    cueFile := ChangeFileExt(aFile.Pfad, '.cue');
    if FileExists(cueFile) then
      fListFilenames.Add(cueFile);
  end;
end;

procedure TNempDragManager.AddFile(aFile: TAudioFile; IncludeCue: Boolean);
begin
  fListFilenames.Add(aFile.Pfad);
  if IncludeCue then
    AddCueFile(aFile);
end;

procedure TNempDragManager.AddFiles(FileList: TStrings);
var
  i: Integer;
begin
  for i := 0 to FileList.Count - 1 do
    fListFilenames.Add(FileList[i]);
end;

procedure TNempDragManager.AddFile(Filename: String);
begin
  fListFilenames.Add(Filename);
end;

procedure TNempDragManager.AddFiles(FileList: TAudioFileList; IncludeCue: Boolean);
var
  i: Integer;
begin
  for i := 0 to FileList.Count - 1 do begin
    fListFilenames.Add(FileList[i].Pfad);
    if IncludeCue then
      AddCueFile(FileList[i]);
  end;
end;

procedure TNempDragManager.SetDragGraphic(Source: TPicture);
begin
  if assigned(Source) then begin
    fDragBitmap.PixelFormat := pf32Bit;

    fDragBitmap.Width := Source.Width;
    fDragBitmap.Height := Source.Height;
    fDragBitmap.Transparent := False;

    fDragBitmap.Canvas.Brush.Color := $00EFEFEF;
    fDragBitmap.Canvas.FillRect(Rect(0, 0, fDragBitmap.Width, fDragBitmap.Height));

    SetStretchBltMode(fDragBitmap.Canvas.Handle, HALFTONE);
        StretchBlt(fDragBitmap.Canvas.Handle,
                  0,0, fDragBitmap.Width, fDragBitmap.Height,
                  Source.Bitmap.Canvas.Handle,
                  0, 0, Source.Bitmap.Width, Source.Bitmap.Height, SRCAND);

    fUseDragBitmap := True;
  end else begin
    fUseDragbitmap := False;
  end;
end;

function TNempDragManager.RenderFilenames(out Medium: TStgMedium): HResult;
begin
  result := OLERenderFilenames(fListFilenames, Medium);
end;


procedure TNempDragManager.InitDrag(Source: TControl);
begin
  ClearFiles;
  FDragSource := Source;
end;

procedure TNempDragManager.FinishDrag;
begin
  FDragSource := Nil;
  FDataObject := Nil;
  ClearFiles;
end;


function TNempDragManager.Execute: TDragResult;
var
  DragSourceHelper: IDragSourceHelper;
  DragInfo: TSHDragImage;
  lDragSourceHelper2: IDragSourceHelper2;// Needed to get Windows Vista+ style drag hints.

  FLastDragEffect, AllowedEffects: Integer;
  lDragEffect: DWord; // required for type compatibility with SHDoDragDrop

  lNullPoint: TPoint;
  Width, Height: Integer;

begin
  Result := drInvalid;
  if (fListFilenames.count = 0) or (fListFilenames[0] = '') then
    exit;

  FDataObject := TNempDataObject.Create(FOwner, fListFilenames) as IDataObject;
  try
      FLastDragEffect := DROPEFFECT_NONE;
      AllowedEffects := DROPEFFECT_COPY;

      // Determine whether the system supports the drag helper interfaces.
      if Assigned(FDataObject) and Succeeded(CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER,
        IDragSourceHelper, DragSourceHelper)) then
      begin
        //Include(FStates, disSystemSupport);
        lNullPoint := Point(0,0);
        if Supports(DragSourceHelper, IDragSourceHelper2, lDragSourceHelper2) then
          lDragSourceHelper2.SetFlags(DSH_ALLOWDROPDESCRIPTIONTEXT);// Show description texts


        if fUseDragBitmap then
        begin
            // Supply the drag source helper with our drag image.
            Width := fDragBitmap.Width;
            Height := fDragBitmap.Height;

            DragInfo.sizeDragImage.cx := Width;
            DragInfo.sizeDragImage.cy := Height;
            DragInfo.ptOffset.x := Width div 2;
            DragInfo.ptOffset.y := Height div 2;
            DragInfo.hbmpDragImage := CopyImage(fDragBitmap.Handle, IMAGE_BITMAP, Width, Height, LR_COPYRETURNORG);
            DragInfo.crColorKey := ColorToRGB(clNone);
            if not Succeeded(DragSourceHelper.InitializeFromBitmap(@DragInfo, DataObject)) then
            begin
              DeleteObject(DragInfo.hbmpDragImage);
            end;
        end else begin
          StandardOLEFormat.cfFormat := CF_HDROP;
          if Succeeded(FDataObject.QueryGetData(StandardOLEFormat)) then
            DragSourceHelper.InitializeFromWindow(0, lNullPoint, FDataObject);
        end;
      end;

      if IsWinVistaOrAbove then
      begin
        lDragEffect := DWord(FLastDragEffect);
        SHDoDragDrop(fOwner.Handle, DataObject, nil, AllowedEffects, lDragEffect); // supports drag hints on Windows Vista and later
        FLastDragEffect := Integer(lDragEffect);
      end
      else
      Winapi.ActiveX.DoDragDrop(DataObject, self as IDropSource, AllowedEffects, FLastDragEffect);

      ForceDragLeave;

  finally
    FinishDrag;
  end;

end;

function TNempDragManager.DoDragOver(KeyState: Integer; Pt: TPoint; State: TDragState; var Effect: LongInt): HResult;
var
  Shift: TShiftState;
  Accept: Boolean;

begin
  try
    Shift := KeysToShiftState(KeyState);
    Effect := DROPEFFECT_COPY;

    //Accept := DoDragOver(DragManager.DragSource, Shift, dsDragEnter, Pt, FLastDropMode, Effect);
  	Accept := False;
	  if Assigned(FOnDragOver) then
		  FOnDragOver(Shift, State, Pt, Effect, Accept);

    if not Accept then
      Effect := DROPEFFECT_NONE;

    Result := NOERROR;
  except
    Result := E_UNEXPECTED;
  end;
end;

function TNempDragManager.DoDrop(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint; var Effect: Integer): HResult;
var
  Shift: TShiftState;
begin
  try
    Shift := KeysToShiftState(KeyState);

    if assigned(fOnDrop) then
      fOnDrop(DataObject, Shift, Pt, Effect);

    Result := S_OK;
  except
    Result := E_UNEXPECTED;
  end;

end;


//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.DragEnter(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint;
  var Effect: Integer): HResult;
begin

  FIsDropTarget := True;
  FDataObject := DataObject;
  SystemParametersInfo(SPI_GETDRAGFULLWINDOWS, 0, @FFullDragging, 0);

  if Assigned(FDropTargetHelper) and FFullDragging then begin
    FDropTargetHelper.DragEnter(0, DataObject, Pt, Effect);// Do not pass handle, otherwise the IDropTargetHelper will perform autoscroll. Issue #486
  end;

  result := DoDragOver(KeyState, Pt, dsDragEnter, Effect);
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.DragLeave: HResult;

begin
  if Assigned(FDropTargetHelper) and FFullDragging then
    FDropTargetHelper.DragLeave;

  //FOwner.DragLeave;
  FIsDropTarget := False;
  //FDragSource := nil;
  FDataObject := nil;
  Result := NOERROR;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.DragOver(KeyState: Integer; Pt: TPoint; var Effect: Integer): HResult;

begin
  if Assigned(FDropTargetHelper) and FFullDragging then
    FDropTargetHelper.DragOver(Pt, Effect);

  // TDragState = (dsDragEnter, dsDragLeave, dsDragMove);
  result := DoDragOver(KeyState, Pt, dsDragMove, Effect);

  {if fValidSource then begin
    Effect := DROPEFFECT_COPY;
    Result := NOERROR;
  end else
  begin
    Effect := DROPEFFECT_NONE;
    Result := NOERROR;
  end;  }
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.Drop(const DataObject: IDataObject; KeyState: Integer; Pt: TPoint;
  var Effect: Integer): HResult;

begin
  if Assigned(FDropTargetHelper) and FFullDragging then
    FDropTargetHelper.Drop(DataObject, Pt, Effect);

  result := DoDrop(DataObject, KeyState, Pt, Effect);

  {
  TNempDragOverEvent = procedure(Shift: TShiftState; State: TDragState;
    Pt: TPoint; var Effect: Integer; var Accept: Boolean) of object;
  }

  FIsDropTarget := False;
  FDataObject := nil;
end;


procedure TNempDragManager.ForceDragLeave;

// Some drop targets, e.g. Internet Explorer leave a drag image on screen instead removing it when they receive
// a drop action. This method calls the drop target helper's DragLeave method to ensure it removes the drag image from
// screen. Unfortunately, sometimes not even this does help (e.g. when dragging text from VT to a text field in IE).

begin
  if Assigned(FDropTargetHelper) and FFullDragging then
    FDropTargetHelper.DragLeave;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.GiveFeedback(Effect: Integer): HResult;
begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

//----------------------------------------------------------------------------------------------------------------------

function TNempDragManager.QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult;

var
  RButton,
  LButton: Boolean;

begin
  LButton := (KeyState and MK_LBUTTON) <> 0;
  RButton := (KeyState and MK_RBUTTON) <> 0;

  // Drag'n drop canceled by pressing both mouse buttons or Esc?
  if (LButton and RButton) or EscapePressed then
    Result := DRAGDROP_S_CANCEL
  else
    // Drag'n drop finished?
    if not (LButton or RButton) then
      Result := DRAGDROP_S_DROP
    else
      Result := S_OK;
end;




{
function TNempDropManager._AddRef: Integer;
begin
  Result := 1;

end;

function TNempDropManager._Release: Integer;
begin
  Result := 1;
end;}

//----------------------------------------------------------------------------------------------------------------------
(*
procedure TNempDropManager.ForceDragLeave;

// Some drop targets, e.g. Internet Explorer leave a drag image on screen instead removing it when they receive
// a drop action. This method calls the drop target helper's DragLeave method to ensure it removes the drag image from
// screen. Unfortunately, sometimes not even this does help (e.g. when dragging text from VT to a text field in IE).

begin
  if Assigned(FDropTargetHelper) and FFullDragging then
    FDropTargetHelper.DragLeave;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVTDragManager.GiveFeedback(Effect: Integer): HResult;

begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

//----------------------------------------------------------------------------------------------------------------------

function TVTDragManager.QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult;

var
  RButton,
  LButton: Boolean;

begin
  LButton := (KeyState and MK_LBUTTON) <> 0;
  RButton := (KeyState and MK_RBUTTON) <> 0;

  // Drag'n drop canceled by pressing both mouse buttons or Esc?
  if (LButton and RButton) or EscapePressed then
    Result := DRAGDROP_S_CANCEL
  else
    // Drag'n drop finished?
    if not (LButton or RButton) then
      Result := DRAGDROP_S_DROP
    else
      Result := S_OK;
end;
*)

initialization

FDragDescriptionFormat := RegisterClipboardFormat(PChar(CFSTR_DROPDESCRIPTION));


end.
