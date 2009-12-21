object ShutDownEditForm: TShutDownEditForm
  Left = 401
  Top = 845
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Countdown'
  ClientHeight = 111
  ClientWidth = 178
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOk: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object BtnCancel: TButton
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GrpBox_CounbtdownLength: TGroupBox
    Left = 8
    Top = 8
    Width = 161
    Height = 65
    Caption = 'Countdown length'
    TabOrder = 2
    object LblConst_Hour: TLabel
      Left = 8
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Hours'
    end
    object LblConst_Minute: TLabel
      Left = 88
      Top = 16
      Width = 37
      Height = 13
      Caption = 'Minutes'
    end
    object SE_Hours: TSpinEdit
      Left = 8
      Top = 32
      Width = 65
      Height = 22
      MaxValue = 24
      MinValue = 0
      TabOrder = 0
      Value = 2
    end
    object SE_Minutes: TSpinEdit
      Left = 88
      Top = 32
      Width = 65
      Height = 22
      MaxValue = 59
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
end
