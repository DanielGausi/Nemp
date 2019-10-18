object TestForm: TTestForm
  Left = 0
  Top = 0
  Caption = 'TestForm'
  ClientHeight = 444
  ClientWidth = 699
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
    699
    444)
  PixelsPerInch = 96
  TextHeight = 13
  object LblStatus: TLabel
    Left = 8
    Top = 402
    Width = 70
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Current status'
  end
  object Memo1: TMemo
    Left = 8
    Top = 13
    Width = 561
    Height = 383
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object BtnGetreplayGainData: TButton
    Left = 575
    Top = 8
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Calculate RG'
    TabOrder = 1
    OnClick = BtnGetreplayGainDataClick
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 420
    Width = 562
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
  end
  object BtnAlbumRG: TButton
    Left = 575
    Top = 48
    Width = 116
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Thread AlbumRG'
    TabOrder = 3
    OnClick = BtnAlbumRGClick
  end
  object Button1: TButton
    Left = 592
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    OnClick = Button1Click
  end
end
