object ProgressForm: TProgressForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Nemp: Work in progress ...'
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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 200
    Width = 494
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object BtnCancel: TButton
      AlignWithMargins = True
      Left = 411
      Top = 8
      Width = 75
      Height = 25
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = BtnCancelClick
    end
    object cbAutoClose: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 0
      Width = 387
      Height = 41
      Margins.Left = 8
      Margins.Top = 0
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alClient
      Caption = 'Close window after completion'
      TabOrder = 1
      OnClick = cbAutoCloseClick
    end
  end
  object pnlProgress: TPanel
    Left = 0
    Top = 103
    Width = 494
    Height = 97
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object ImgFail: TVirtualImage
      Left = 86
      Top = 47
      Width = 16
      Height = 16
      ImageCollection = DataModuleGui.ICIcons
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 71
      ImageName = 'MenuCancel'
    end
    object ImgOk: TVirtualImage
      Left = 8
      Top = 47
      Width = 16
      Height = 16
      ImageCollection = DataModuleGui.ICIcons
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 42
      ImageName = 'MenuOk'
    end
    object lblCurrentItem: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 478
      Height = 28
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alTop
      AutoSize = False
      Caption = 'Current item ... reading ....'
      ShowAccelChar = False
      WordWrap = True
      ExplicitLeft = 40
      ExplicitWidth = 394
    end
    object lblFailCount: TLabel
      Left = 108
      Top = 47
      Width = 6
      Height = 13
      Caption = '0'
    end
    object LblSuccessCount: TLabel
      Left = 30
      Top = 47
      Width = 6
      Height = 13
      Caption = '0'
    end
    object MainProgressBar: TProgressBar
      Left = 0
      Top = 72
      Width = 494
      Height = 25
      Align = alBottom
      Position = 50
      MarqueeInterval = 50
      Step = 1
      TabOrder = 0
      TabStop = True
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 494
    Height = 103
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object LblMain: TLabel
      AlignWithMargins = True
      Left = 88
      Top = 16
      Width = 398
      Height = 79
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      AutoSize = False
      Caption = 
        'Nemp is updating your Media Library right now. '#13#10#13#10'Some function' +
        's are disabled during this process. You can cancel the current o' +
        'peration at any time.'
      WordWrap = True
      ExplicitLeft = 92
      ExplicitTop = 24
      ExplicitWidth = 394
      ExplicitHeight = 145
    end
    object pnlImage: TPanel
      Left = 0
      Top = 0
      Width = 80
      Height = 103
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object MainImage: TVirtualImage
        AlignWithMargins = True
        Left = 8
        Top = 16
        Width = 64
        Height = 64
        Margins.Left = 8
        Margins.Top = 16
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alTop
        ImageCollection = DataModuleGui.ICGraphics
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 8
        ImageName = 'imgNempLogo'
        ExplicitTop = 8
      end
    end
  end
  object CloseTimer: TTimer
    Enabled = False
    OnTimer = CloseTimerTimer
    Left = 16
    Top = 96
  end
end
