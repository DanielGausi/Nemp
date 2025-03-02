unit AudioFileManagement;

interface

uses
  System.Classes, System.Generics.Defaults, System.Generics.Collections, NempAudioFiles;

type
  TEventClass = class
  private
    FNotifyEvent: TNotifyEvent;
  public
    constructor Create(ANotifyEvent: TNotifyEvent);
    property NotifyEvent: TNotifyEvent read FNotifyEvent write FNotifyEvent;
  end;

  TEventList = class
  private
    FList: TObjectList<TEventClass>;
    function IndexOf(EventHandler: TNotifyEvent): Integer;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(EventHandler: TNotifyEvent);
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(EventHandler: TNotifyEvent); overload;
    procedure Fire(Sender: TObject);
    property Count: Integer read GetCount;
  end;


  TAudioFileManager = class
  strict private
    class constructor Create;
    class destructor Destroy;
  private
    class var FFilesToChange: TAudioFileList;
    class var FOnAudioFileChanged: TEventList;
    class var FOnPrepareAudioFileChange: TEventList;

  public
    class property OnPrepareAudioFileChange: TEventList read FOnPrepareAudioFileChange;
    class property OnAudioFileChanged: TEventList read FOnAudioFileChanged;
    class property FilesToChange: TAudioFileList read FFilesToChange;

    class function SameFile(fileA, fileB: TAudioFile): Boolean;
    class function AddFileIfNeeded(NeededFile, newCandidate: TAudioFile): Boolean;

    // PrepareAudioFileChange:
    // - Fire all OnPrepareAudioFileChange-Events
    // - EventHandlers should fill FilesToChange as needed
    class procedure PrepareAudioFileChange(FileToChange: TAudioFile);

    // FinalizeAudioFileChange
    // - Fire all OnAudioFileChanged-Events
    // - EventHandlers should refresh the GUI as needed
    class procedure FinalizeAudioFileChange(ChangedFile: TAudioFile);

    class procedure SyncFilesAfterEdit(EditedFile: TAudioFile);

  end;

implementation

constructor TEventClass.Create(ANotifyEvent: TNotifyEvent);
begin
  inherited Create;
  FNotifyEvent := ANotifyEvent;
end;

{ TEventList }

constructor TEventList.Create;
begin
  inherited Create;
  FList := TObjectList<TEventClass>.create(True);
end;

destructor TEventList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TEventList.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TEventList.Add(EventHandler: TNotifyEvent);
begin
  if IndexOf(EventHandler) = -1 then
    FList.Add(TEventClass.Create(EventHandler));
end;

function TEventList.IndexOf(EventHandler: TNotifyEvent): Integer;
var
  i: Integer;
  ACode, AData: Pointer;
begin
  Result := -1;
  ACode := TMethod(EventHandler).Code;
  AData := TMethod(EventHandler).Data;
  for i := 0 to FList.Count - 1 do begin
    if (ACode = TMethod(FList[i].NotifyEvent).Code) and (AData = TMethod(FList[i].NotifyEvent).Data) then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TEventList.Delete(AIndex: Integer);
begin
  if AIndex <> -1 then
    FList.Delete(AIndex);
end;

procedure TEventList.Delete(EventHandler: TNotifyEvent);
begin
  Delete(IndexOf(EventHandler));
end;

procedure TEventList.Fire(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    FList[i].NotifyEvent(Sender);
end;

{ TAudioFileManager }

class constructor TAudioFileManager.Create;
begin
  FOnPrepareAudioFileChange := TEventList.Create;
  FOnAudioFileChanged := TEventList.Create;
  FFilesToChange := TAudioFileList.Create(False);
end;

class destructor TAudioFileManager.Destroy;
begin
  FOnAudioFileChanged.Free;
  FOnPrepareAudioFileChange.Free;
  FFilesToChange.Free;
end;

class function TAudioFileManager.SameFile(fileA, fileB: TAudioFile): Boolean;
begin
  result := assigned(fileA) and assigned(fileB) and (fileA.Pfad = fileB.Pfad);
end;

class function TAudioFileManager.AddFileIfNeeded(NeededFile,
  newCandidate: TAudioFile): Boolean;
begin
  result := SameFile(NeededFile, newCandidate);
  if result then
    FilesToChange.Add(newCandidate);
end;

{
    PrepareAudioFileChange
    Collect all Files ithin the Nemp-Universe with the same filename.
    These files must be updated when the user edits a file
    ( in the tree, in the detail-listing within the mainform, in the detailform
      or just the Player-rating )

    !!! Important Note !!!
    The MediaLibrary adds "GetAudioFileWithFilename(EditFile.Pfad);" to that.
    Therefore: Use this function only in VCL-Thread and only after a test for
     - Medienbib.status <= 1  (searching for new files or GetTags should be ok) and
     - MedienBib.CurrentThreadFilename
}
class procedure TAudioFileManager.PrepareAudioFileChange(
  FileToChange: TAudioFile);
begin
  FFilesToChange.Clear;
  FFilesToChange.Add(FileToChange);
  FOnPrepareAudioFileChange.Fire(FileToChange);
end;

class procedure TAudioFileManager.FinalizeAudioFileChange(
  ChangedFile: TAudioFile);
begin
  FOnAudioFileChanged.Fire(ChangedFile);
  FFilesToChange.Clear;
end;

class procedure TAudioFileManager.SyncFilesAfterEdit(EditedFile: TAudioFile);
var
  i: Integer;
begin
  PrepareAudioFileChange(EditedFile);
  for i := 0 to FilesToChange.Count - 1 do
    FilesToChange.Items[i].Assign(EditedFile);
  FinalizeAudioFileChange(EditedFile);
end;

end.
