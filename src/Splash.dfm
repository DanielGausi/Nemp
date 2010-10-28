object FSplash: TFSplash
  Left = 1257
  Top = 83
  BorderStyle = bsNone
  Caption = 'Nemp'
  ClientHeight = 178
  ClientWidth = 222
  Color = clWhite
  TransparentColorValue = clMaroon
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 220
    Height = 173
    OnClick = Image1Click
  end
  object Label2: TLabel
    Left = 184
    Top = 8
    Width = 25
    Height = 13
    AutoSize = False
    Caption = '...'
    Transparent = True
  end
  object StatusLBL: TLabel
    Left = 8
    Top = 8
    Width = 169
    Height = 13
    AutoSize = False
    Caption = '...'
    Transparent = True
  end
end
