object ReplayGainProgressForm: TReplayGainProgressForm
  Left = 0
  Top = 0
  Caption = 'Nemp: Calculating ReplayGain'
  ClientHeight = 241
  ClientWidth = 494
  Color = clBtnFace
  Constraints.MinHeight = 280
  Constraints.MinWidth = 510
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    494
    241)
  TextHeight = 13
  object MainImage: TImage
    Left = 8
    Top = 8
    Width = 64
    Height = 64
    Proportional = True
    Stretch = True
    Transparent = True
  end
  object LblMain: TLabel
    Left = 88
    Top = 8
    Width = 394
    Height = 56
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Nemp is calculating ReplayGain values right now. This may take a' +
      ' while. '#13#10#13#10
    WordWrap = True
    ExplicitWidth = 398
  end
  object LblStatus: TLabel
    Left = 88
    Top = 73
    Width = 394
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Current item ... reading ....'
    ShowAccelChar = False
    WordWrap = True
    ExplicitWidth = 398
  end
  object pbTrack: TProgressBar
    Left = 8
    Top = 72
    Width = 60
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 64
  end
  object BtnCancel: TButton
    Left = 407
    Top = 176
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BtnCancelClick
    ExplicitLeft = 411
    ExplicitTop = 177
  end
  object pbComplete: TProgressBar
    Left = 8
    Top = 207
    Width = 474
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    ExplicitTop = 208
    ExplicitWidth = 478
  end
  object LogMemo: TMemo
    Left = 8
    Top = 94
    Width = 474
    Height = 76
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
    WordWrap = False
    ExplicitWidth = 478
    ExplicitHeight = 77
  end
  object cbAutoClose: TCheckBox
    Left = 8
    Top = 180
    Width = 337
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Close window after completion'
    TabOrder = 4
    OnClick = cbAutoCloseClick
    ExplicitTop = 181
  end
  object CloseTimer: TTimer
    Enabled = False
    OnTimer = CloseTimerTimer
    Left = 32
    Top = 112
  end
end
