object ShutDownForm: TShutDownForm
  Left = 466
  Top = 125
  BorderIcons = []
  BorderStyle = bsToolWindow
  ClientHeight = 143
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ShutDownLBL: TLabel
    Left = 16
    Top = 72
    Width = 12
    Height = 13
    Caption = '...'
  end
  object LblHinweis: TLabel
    Left = 16
    Top = 16
    Width = 281
    Height = 49
    AutoSize = False
    Caption = '...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Btn_Cancel: TButton
    Left = 160
    Top = 104
    Width = 121
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 0
    OnClick = Btn_CancelClick
  end
  object Btn_ShutDownNow: TButton
    Left = 24
    Top = 104
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
  end
end
