object ShutDownForm: TShutDownForm
  Left = 466
  Top = 125
  BorderIcons = []
  BorderStyle = bsToolWindow
  ClientHeight = 134
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object ShutDownLBL: TLabel
    Left = 88
    Top = 64
    Width = 12
    Height = 13
    Caption = '...'
  end
  object LblHinweis: TLabel
    Left = 88
    Top = 8
    Width = 281
    Height = 49
    AutoSize = False
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object ImgShutDown: TImage
    Left = 8
    Top = 8
    Width = 64
    Height = 64
  end
  object Btn_Cancel: TButton
    Left = 192
    Top = 96
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 0
    OnClick = Btn_CancelClick
  end
  object Btn_ShutDownNow: TButton
    Left = 56
    Top = 96
    Width = 121
    Height = 25
    Caption = 'Shutdown now'
    TabOrder = 1
    OnClick = Btn_ShutDownNowClick
  end
  object Timer1: TTimer
    Tag = 30
    Enabled = False
    OnTimer = Timer1Timer
    Left = 16
    Top = 40
  end
end
