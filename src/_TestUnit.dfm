object TestForm: TTestForm
  Left = 0
  Top = 0
  Caption = 'TestForm'
  ClientHeight = 464
  ClientWidth = 698
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    698
    464)
  PixelsPerInch = 96
  TextHeight = 13
  object LblStatus: TLabel
    Left = 8
    Top = 376
    Width = 70
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Current status'
  end
  object Memo1: TMemo
    Left = 8
    Top = 13
    Width = 560
    Height = 348
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object BtnGetreplayGainData: TButton
    Left = 574
    Top = 8
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Calculate RG'
    TabOrder = 1
    OnClick = BtnGetreplayGainDataClick
  end
  object pbTrack: TProgressBar
    Left = 72
    Top = 395
    Width = 497
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
  end
  object BtnAlbumRG: TButton
    Left = 574
    Top = 87
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'RG just Tracks'
    TabOrder = 3
    OnClick = BtnAlbumRGClick
  end
  object Button1: TButton
    Left = 600
    Top = 371
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
  object pbComplete: TProgressBar
    Left = 72
    Top = 418
    Width = 497
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
  end
  object Button2: TButton
    Tag = 1
    Left = 574
    Top = 118
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'RG as one Album'
    TabOrder = 6
    OnClick = BtnAlbumRGClick
  end
  object Button3: TButton
    Tag = 2
    Left = 574
    Top = 149
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'RG MultiAlbum'
    TabOrder = 7
    OnClick = BtnAlbumRGClick
  end
  object Button4: TButton
    Tag = 3
    Left = 574
    Top = 180
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete RG Values'
    TabOrder = 8
    OnClick = BtnAlbumRGClick
  end
end
