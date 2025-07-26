unit NempControls.ExtCtrls;

interface

uses
  WinApi.Messages, WinApi.Windows, System.Classes, System.SysUtils, System.Types,
  Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Spin;

type
  TComboBoxLabel = class(TBoundLabel)
  protected
    procedure AdjustBounds; override;
  end;

  TSpinEditLabel = class(TBoundLabel)
  protected
    procedure AdjustBounds; override;
  end;

  TLabeledComboBox = class(TComboBox)
  private
    FEditLabel: TComboBoxLabel;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
    procedure UpdateLabelPosition;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMAllChildrenFlipped(var Message: TMessage); message CM_ALLCHILDRENFLIPPED;
  protected
    class function WithLabel: Boolean; virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;

  published
    property EditLabel: TComboBoxLabel read FEditLabel;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
  end;

  TLabeledSpinEdit = class(TSpinEdit)
  private
    FEditLabel: TSpinEditLabel;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
    procedure UpdateLabelPosition;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMAllChildrenFlipped(var Message: TMessage); message CM_ALLCHILDRENFLIPPED;
  protected
    class function WithLabel: Boolean; virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalLabel;

  published
    property EditLabel: TSpinEditLabel read FEditLabel;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
  end;

  procedure Register;


implementation

procedure Register;
begin
  RegisterComponents('Nemp Components', [TLabeledComboBox]);
  RegisterComponents('Nemp Components', [TLabeledSpinEdit]);
end;

{ TComboBoxLabel }

procedure TComboBoxLabel.AdjustBounds;
begin
  inherited;
  inherited AdjustBounds;
  if (Owner is TLabeledComboBox) and AutoSize then
    TLabeledComboBox(Owner).UpdateLabelPosition;
end;

{ TSpinEditLabel }

procedure TSpinEditLabel.AdjustBounds;
begin
  inherited AdjustBounds;
  if (Owner is TLabeledSpinEdit) and AutoSize then
    TLabeledSpinEdit(Owner).UpdateLabelPosition;
end;


{ TLabeledComboBox }

constructor TLabeledComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabelPosition := lpAbove;
  FLabelSpacing := 3;
  SetupInternalLabel;
end;

class function TLabeledComboBox.WithLabel: Boolean;
begin
  Result := True;
end;

procedure TLabeledComboBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TLabeledComboBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Enabled := Enabled;
end;

procedure TLabeledComboBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Visible := Visible;
end;

procedure TLabeledComboBox.CMAllChildrenFlipped(var Message: TMessage);
begin
  inherited;
  if LabelPosition = lpLeft then
    LabelPosition := lpRight
  else if LabelPosition = lpRight then
    LabelPosition := lpLeft
  else
    UpdateLabelPosition;
end;

procedure TLabeledComboBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
end;

procedure TLabeledComboBox.SetBounds(ALeft, ATop, AWidth,
  AHeight: Integer);
begin
  if Parent <> nil then
    Parent.DisableAlign;
  try
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    UpdateLabelPosition;
  finally
    if Parent <> nil then
      Parent.EnableAlign;
  end;
end;

procedure TLabeledComboBox.SetLabelPosition(const Value: TLabelPosition);
begin
  if FLabelPosition <> Value then
  begin
    FLabelPosition := Value;
    if FEditLabel <> nil then
      FEditLabel.AdjustBounds;
  end;
end;

procedure TLabeledComboBox.SetLabelSpacing(const Value: Integer);
begin
  if FLabelSpacing <> Value then
  begin
    FLabelSpacing := Value;
    UpdateLabelPosition;
  end;
end;

procedure TLabeledComboBox.SetName(const Value: TComponentName);
var
  LClearText: Boolean;
begin
  if (csDesigning in ComponentState) and
     (FEditLabel <> nil) and SameText(FEditLabel.Caption, Name) then
  begin
    FEditLabel.Caption := Value;
    FEditLabel.IsLabelModified := False;
  end;
  LClearText := (csDesigning in ComponentState) and (Text = '');
  inherited SetName(Value);
  if LClearText then
    Text := '';
end;

procedure TLabeledComboBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then Exit;
  FEditLabel.Parent := AParent;
  if not (csDestroying in ComponentState) then
  begin
    FEditLabel.AdjustBounds;
    FEditLabel.Visible := Visible;
  end;
end;

procedure TLabeledComboBox.SetupInternalLabel;
begin
  if (FEditLabel <> nil) or not WithLabel then Exit;
  FEditLabel := TComboBoxLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
end;

function AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
begin
  Result := Alignment;
  if RightToLeftAlignment then
    case Result of
      taLeftJustify: Result := taRightJustify;
      taRightJustify: Result := taLeftJustify;
    end;
end;

procedure TLabeledComboBox.UpdateLabelPosition;
var
  P: TPoint;
  S: TSize;
  L: Integer;
  LSpacing: Integer;
begin
  if FEditLabel = nil then Exit;
  S := TSize.Create(FEditLabel.Width, FEditLabel.Height);
  LSpacing := ScaleValue(FLabelSpacing);
  case LabelPosition of
    lpAbove:
      //case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        //taLeftJustify:
        P := Point(Left, Top - S.Height - LSpacing);
      //  taRightJustify: P := Point(Left + Width - S.Width, Top - S.Height - LSpacing);
      //  taCenter: P := Point(Left + (Width - S.Width) div 2, Top - S.Height - LSpacing);
      //end;
    lpBelow:
      //case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        //taLeftJustify:
        P := Point(Left, Top + Height + LSpacing);
        //taRightJustify: P := Point(Left + Width - S.Width, Top + Height + LSpacing);
        //taCenter: P := Point(Left + (Width - S.Width) div 2, Top + Height + LSpacing);
      //end;
    lpLeft:
      begin
        L := GetSystemMetrics(SM_CYBORDER);
        // if BorderStyle <> bsSingle then // ??
        //  L := ScaleValue(L * 4);
        if not FEditLabel.WordWrap then
          S.Height := Height;
        P := Point(Left - S.Width - LSpacing,
          Top + ((Height - S.Height) div 2) - L);
      end;
    lpRight:
      begin
        L := GetSystemMetrics(SM_CYBORDER);
        // if BorderStyle <> bsSingle then // ??
        //  L := ScaleValue(L * 4);
        if not FEditLabel.WordWrap then
          S.Height := Height;
        P := Point(Left + Width + LSpacing,
          Top + ((Height - S.Height) div 2) - L);
      end;
  end;
  FEditLabel.SetBounds(P.x, P.y, S.Width, S.Height);
  if (Parent <> nil) and Parent.HandleAllocated then
    Parent.Invalidate;
end;

{ TLabeledSpinEdit }

constructor TLabeledSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabelPosition := lpAbove;
  FLabelSpacing := 3;
  SetupInternalLabel;
end;

class function TLabeledSpinEdit.WithLabel: Boolean;
begin
  result := True;
end;

procedure TLabeledSpinEdit.CMAllChildrenFlipped(var Message: TMessage);
begin
  inherited;
  if LabelPosition = lpLeft then
    LabelPosition := lpRight
  else if LabelPosition = lpRight then
    LabelPosition := lpLeft
  else
    UpdateLabelPosition;
end;

procedure TLabeledSpinEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TLabeledSpinEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Enabled := Enabled;
end;

procedure TLabeledSpinEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;
  if FEditLabel <> nil then
    FEditLabel.Visible := Visible;
end;

procedure TLabeledSpinEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
end;

procedure TLabeledSpinEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Parent <> nil then
    Parent.DisableAlign;
  try
    inherited SetBounds(ALeft, ATop, AWidth, AHeight);
    UpdateLabelPosition;
  finally
    if Parent <> nil then
      Parent.EnableAlign;
  end;
end;

procedure TLabeledSpinEdit.SetLabelPosition(const Value: TLabelPosition);
begin
  if FLabelPosition <> Value then
  begin
    FLabelPosition := Value;
    if FEditLabel <> nil then
      FEditLabel.AdjustBounds;
  end;
end;

procedure TLabeledSpinEdit.SetLabelSpacing(const Value: Integer);
begin
  if FLabelSpacing <> Value then
  begin
    FLabelSpacing := Value;
    UpdateLabelPosition;
  end;
end;

procedure TLabeledSpinEdit.SetName(const Value: TComponentName);
var
  LClearText: Boolean;
begin
  if (csDesigning in ComponentState) and
     (FEditLabel <> nil) and SameText(FEditLabel.Caption, Name) then
  begin
    FEditLabel.Caption := Value;
    FEditLabel.IsLabelModified := False;
  end;
  LClearText := (csDesigning in ComponentState) and (Text = '');
  inherited SetName(Value);
end;

procedure TLabeledSpinEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if FEditLabel = nil then Exit;
  FEditLabel.Parent := AParent;
  if not (csDestroying in ComponentState) then
  begin
    FEditLabel.AdjustBounds;
    FEditLabel.Visible := Visible;
  end;
end;

procedure TLabeledSpinEdit.SetupInternalLabel;
begin
  if (FEditLabel <> nil) or not WithLabel then Exit;
  FEditLabel := TSpinEditLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;
end;

procedure TLabeledSpinEdit.UpdateLabelPosition;
var
  P: TPoint;
  S: TSize;
  L: Integer;
  LSpacing: Integer;
begin
  if FEditLabel = nil then Exit;
  S := TSize.Create(FEditLabel.Width, FEditLabel.Height);
  LSpacing := ScaleValue(FLabelSpacing);
  case LabelPosition of
    lpAbove: P := Point(Left, Top - S.Height - LSpacing);
    lpBelow: P := Point(Left, Top + Height + LSpacing);
    lpLeft:
      begin
        L := GetSystemMetrics(SM_CYBORDER);
        // if BorderStyle <> bsSingle then // ??
        //  L := ScaleValue(L * 4);
        if not FEditLabel.WordWrap then
          S.Height := Height;
        P := Point(Left - S.Width - LSpacing,
          Top + ((Height - S.Height) div 2) - L);
      end;
    lpRight:
      begin
        L := GetSystemMetrics(SM_CYBORDER);
        // if BorderStyle <> bsSingle then // ??
        //  L := ScaleValue(L * 4);
        if not FEditLabel.WordWrap then
          S.Height := Height;
        P := Point(Left + Width + LSpacing,
          Top + ((Height - S.Height) div 2) - L);
      end;
  end;
  FEditLabel.SetBounds(P.x, P.y, S.Width, S.Height);
  if (Parent <> nil) and Parent.HandleAllocated then
    Parent.Invalidate;
end;

end.
