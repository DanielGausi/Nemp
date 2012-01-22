object WebServerLogForm: TWebServerLogForm
  Left = 0
  Top = 0
  Caption = 'Webserver: Logfile'
  ClientHeight = 368
  ClientWidth = 475
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    475
    368)
  PixelsPerInch = 96
  TextHeight = 13
  object LogMemo: TMemo
    Left = 0
    Top = 0
    Width = 475
    Height = 326
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
    ExplicitWidth = 496
    ExplicitHeight = 403
  end
  object BtnSave: TButton
    Left = 392
    Top = 335
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 1
    OnClick = BtnSaveClick
    ExplicitLeft = 413
    ExplicitTop = 409
  end
  object BtnRefresh: TButton
    Left = 311
    Top = 335
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Refresh'
    TabOrder = 2
    OnClick = BtnRefreshClick
    ExplicitLeft = 332
    ExplicitTop = 409
  end
  object cbAutoRefresh: TCheckBox
    Left = 8
    Top = 335
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Auto refresh'
    Checked = True
    State = cbChecked
    TabOrder = 3
    OnClick = cbAutoRefreshClick
    ExplicitTop = 409
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'log'
    Filter = 'Loglist (*.log)|*.log'
    Left = 16
    Top = 16
  end
  object Timer1: TTimer
    Interval = 1500
    OnTimer = Timer1Timer
    Left = 64
    Top = 16
  end
end
