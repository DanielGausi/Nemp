object UpdateForm: TUpdateForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Nemp: Update'
  ClientHeight = 296
  ClientWidth = 500
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object RichEdit1: TRichEdit
    AlignWithMargins = True
    Left = 3
    Top = 92
    Width = 494
    Height = 201
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    StyleElements = [seBorder]
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      500
      89)
    object ImgLogo: TImage
      AlignWithMargins = True
      Left = 9
      Top = 12
      Width = 64
      Height = 64
    end
    object LblNewVersion: TLabel
      Left = 86
      Top = 6
      Width = 153
      Height = 19
      Caption = 'New version available'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblCurrentVersion: TLabel
      Left = 86
      Top = 31
      Width = 127
      Height = 13
      Caption = 'Your current version: x.xx'
    end
    object BtnDownload: TButton
      Left = 86
      Top = 50
      Width = 194
      Height = 31
      Caption = 'Download now'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = BtnDownloadClick
    end
    object BtnClose: TButton
      Left = 363
      Top = 56
      Width = 129
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Maybe later'
      TabOrder = 1
      OnClick = BtnCloseClick
    end
  end
end
