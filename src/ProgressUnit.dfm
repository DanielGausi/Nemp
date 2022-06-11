object ProgressForm: TProgressForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Nemp: Work in progress ...'
  ClientHeight = 241
  ClientWidth = 503
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
    503
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
    Width = 407
    Height = 106
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 
      'Nemp is updating your Media Library right now. '#13#10#13#10'Some function' +
      's are disabled during this process. You can cancel the current o' +
      'peration at any time.'
    WordWrap = True
    ExplicitWidth = 402
    ExplicitHeight = 133
  end
  object ImgFail: TImage
    Left = 166
    Top = 154
    Width = 16
    Height = 16
    Anchors = [akLeft, akBottom]
    ExplicitTop = 243
  end
  object ImgOk: TImage
    Left = 88
    Top = 154
    Width = 16
    Height = 16
    Anchors = [akLeft, akBottom]
    ExplicitTop = 243
  end
  object lblCurrentItem: TLabel
    Left = 88
    Top = 120
    Width = 407
    Height = 28
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Current item ... reading ....'
    ShowAccelChar = False
    WordWrap = True
    ExplicitTop = 209
    ExplicitWidth = 402
  end
  object LblSuccessCount: TLabel
    Left = 110
    Top = 154
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '0'
    ExplicitTop = 243
  end
  object lblFailCount: TLabel
    Left = 188
    Top = 154
    Width = 6
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '0'
    ExplicitTop = 243
  end
  object MainProgressBar: TProgressBar
    Left = 5
    Top = 207
    Width = 490
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Position = 50
    MarqueeInterval = 50
    Step = 1
    TabOrder = 0
    TabStop = True
  end
  object BtnCancel: TButton
    Left = 420
    Top = 176
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = BtnCancelClick
  end
  object cbAutoClose: TCheckBox
    Left = 8
    Top = 184
    Width = 329
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Close window after completion'
    TabOrder = 2
    OnClick = cbAutoCloseClick
  end
  object CloseTimer: TTimer
    Enabled = False
    OnTimer = CloseTimerTimer
    Left = 384
    Top = 152
  end
end
