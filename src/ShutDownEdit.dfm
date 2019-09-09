object ShutDownEditForm: TShutDownEditForm
  Left = 401
  Top = 845
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Nemp: Countdown'
  ClientHeight = 182
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    473
    182)
  PixelsPerInch = 96
  TextHeight = 13
  object ImgShutDown: TImage
    AlignWithMargins = True
    Left = 33
    Top = 15
    Width = 64
    Height = 64
  end
  object lblShutDownMode: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 85
    Width = 114
    Height = 53
    Alignment = taCenter
    AutoSize = False
    Caption = '...'
    WordWrap = True
  end
  object lblCurrentStatus: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 149
    Width = 265
    Height = 25
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = '...'
    WordWrap = True
    ExplicitTop = 167
  end
  object BtnOk: TButton
    AlignWithMargins = True
    Left = 296
    Top = 149
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BtnOkClick
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 377
    Top = 149
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object grpBoxSettings: TGroupBox
    AlignWithMargins = True
    Left = 128
    Top = 8
    Width = 331
    Height = 130
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Settings'
    TabOrder = 0
    object lblIntendedAction: TLabel
      Left = 16
      Top = 76
      Width = 76
      Height = 13
      Caption = 'Intended action'
    end
    object lblCountDownLength: TLabel
      Left = 16
      Top = 24
      Width = 88
      Height = 13
      Caption = 'Countdown length'
    end
    object LblConst_Minute: TLabel
      Left = 265
      Top = 24
      Width = 37
      Height = 13
      Caption = 'Minutes'
      Enabled = False
    end
    object LblConst_Hour: TLabel
      Left = 206
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Hours'
      Enabled = False
    end
    object cbIntendedAction: TComboBox
      Left = 16
      Top = 95
      Width = 297
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 3
      Text = 'Hibernate Windows'
      OnChange = cbIntendedActionChange
      Items.Strings = (
        'Stop Nemp'
        'Close Nemp'
        'Suspend Windows'
        'Hibernate Windows'
        'Shutdown Windows')
    end
    object cbCountdownLength: TComboBox
      Left = 16
      Top = 43
      Width = 177
      Height = 21
      Style = csDropDownList
      ItemIndex = 4
      TabOrder = 0
      Text = '1 hour'
      OnChange = cbCountdownLengthChange
      Items.Strings = (
        '5 minutes'
        '15 minutes'
        '30 minutes'
        '45 minutes'
        '1 hour'
        '1.5 hours'
        '2 hours'
        'Custom'
        'After the last title')
    end
    object SE_Hours: TSpinEdit
      Left = 206
      Top = 43
      Width = 51
      Height = 22
      Enabled = False
      MaxValue = 24
      MinValue = 0
      TabOrder = 1
      Value = 2
    end
    object SE_Minutes: TSpinEdit
      Left = 265
      Top = 43
      Width = 51
      Height = 22
      Enabled = False
      MaxValue = 59
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
end
