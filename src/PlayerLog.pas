unit PlayerLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  ContNrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VirtualTrees, PostProcessorUtils,
  Nemp_RessourceStrings, gnugettext;

type



  TPlayerLogForm = class(TForm)
    BtnClose: TButton;
    BtnSettings: TButton;
    vstPlayerLog: TVirtualStringTree;
    cbSessionSelect: TComboBox;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnSettingsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vstPlayerLogGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure cbSessionSelectChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }

    procedure FillLogTreeView(aList: TObjectList);

  public
    { Public-Deklarationen }
    procedure AddNewLogEntry(aLogEntry: TNempLogEntry);
  end;

var
  PlayerLogForm: TPlayerLogForm;

implementation

uses OptionsComplete, PlayerClass, NempMainUnit, Nemp_ConstantsAndTypes;

{$R *.dfm}


function AddVSTLog(AVST: TCustomVirtualStringTree; aNode: PVirtualNode; aLogEntry: TNempLogEntry): PVirtualNode;
var Data: PLogTreeData;
begin
  Result := AVST.AddChild(aNode);
  AVST.ValidateNode(Result,false);
  Data := AVST.GetNodeData(Result);
  Data^.FLogEntry := aLogEntry;
end;

procedure TPlayerLogForm.vstPlayerLogGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var Data: PLogTreeData;
begin
  Data:=Sender.GetNodeData(Node);
  if not assigned(Data) then exit;

  case Column of
    0: case self.cbSessionSelect.ItemIndex of
          0: cellText := TimeToStr(Data^.FLogEntry.StartTime)     ;
          1: cellText := DateTimeToStr(Data^.FLogEntry.StartTime) ;
       else
          cellText := '';
       end;

    1: cellText := Data^.FLogEntry.Title      ;
    2: cellText := Data^.FLogEntry.Artist     ;
    3: cellText := Data^.FLogEntry.Filename   ;
    4: if Data^.FLogEntry.Aborted then
          cellText := _(Playlist_LogAborted)
       else
          cellText := '';

  end;
end;

procedure TPlayerLogForm.AddNewLogEntry(aLogEntry: TNempLogEntry);
begin
    if cbSessionSelect.ItemIndex = 0 then
        AddVSTLog(vstPlayerLog, Nil, aLogEntry);
    //else: previous sessions are listed in the VST right now. Do not add the new one to the current view
end;


procedure TPlayerLogForm.BtnCloseClick(Sender: TObject);
begin
    Close;
end;


procedure TPlayerLogForm.BtnSettingsClick(Sender: TObject);
begin
    if Not Assigned(OptionsCompleteForm) then
        Application.CreateForm(TOptionsCompleteForm, OptionsCompleteForm);
    OptionsCompleteForm.OptionsVST.FocusedNode := OptionsCompleteForm.PlaylistNode;
    OptionsCompleteForm.OptionsVST.Selected[OptionsCompleteForm.PlaylistNode] := True;
    OptionsCompleteForm.PageControl1.ActivePage := OptionsCompleteForm.TabPlayer2;
    OptionsCompleteForm.Show;
end;

procedure TPlayerLogForm.cbSessionSelectChange(Sender: TObject);
begin
    case cbSessionSelect.ItemIndex of
        0: FillLogTreeView(NempPlayer.NempLogFile.LogList);
        1: begin
              NempPlayer.NempLogFile.PreparePreviousLogList(SavePath + NEMP_NAME + '-PlayerLog.log');
              FillLogTreeView(NempPlayer.NempLogFile.PreviousSessionList);
        end;
    end;
end;

procedure TPlayerLogForm.FillLogTreeView(aList: TObjectList);
var i: Integer;
begin
    vstPlayerLog.Clear;
    for i := 0 to aList.Count - 1 do
        AddVSTLog(vstPlayerLog, Nil, TNempLogEntry(aList[i]));
end;

procedure TPlayerLogForm.FormCreate(Sender: TObject);
var cIdx: Integer;
begin
    cIdx := cbSessionSelect.ItemIndex;
    TranslateComponent (self);
    cbSessionSelect.ItemIndex := cIdx;
end;

procedure TPlayerLogForm.FormShow(Sender: TObject);
begin
    case cbSessionSelect.ItemIndex of
        0: FillLogTreeView(NempPlayer.NempLogFile.LogList);
        1: begin
              NempPlayer.NempLogFile.PreparePreviousLogList(SavePath + NEMP_NAME + '-PlayerLog.log');
              FillLogTreeView(NempPlayer.NempLogFile.PreviousSessionList);
        end;
    end;
end;

end.
