object FError: TFError
  Left = 0
  Top = 0
  Caption = 'Nemp: Messages'
  ClientHeight = 361
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    389
    361)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo_Error: TMemo
    Left = 8
    Top = 8
    Width = 373
    Height = 315
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object BtnClear: TButton
    Left = 169
    Top = 329
    Width = 127
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear Messages'
    TabOrder = 1
    OnClick = BtnClearClick
    ExplicitLeft = 205
    ExplicitTop = 353
  end
  object BtnOK: TButton
    Left = 302
    Top = 329
    Width = 79
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 2
    OnClick = BtnOKClick
    ExplicitLeft = 363
    ExplicitTop = 353
  end
end
