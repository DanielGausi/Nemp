object FormNewLayer: TFormNewLayer
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: New category layer'
  ClientHeight = 170
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlButtons: TPanel
    Left = 0
    Top = 129
    Width = 400
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      400
      41)
    object BtnOK: TButton
      Left = 206
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object BtnCancel: TButton
      Left = 305
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 129
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      400
      129)
    object lblGroupBy: TLabel
      Left = 16
      Top = 32
      Width = 179
      Height = 13
      Caption = 'Property used to group the audiofiles'
    end
    object lblMain: TLabel
      Left = 16
      Top = 8
      Width = 279
      Height = 18
      Caption = 'Add a new layer to organize your audiofiles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblSortBy: TLabel
      Left = 16
      Top = 80
      Width = 62
      Height = 13
      Caption = 'Sort layer by'
    end
    object cbProperties: TComboBox
      Left = 16
      Top = 51
      Width = 372
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = cbPropertiesChange
    end
    object cbSortings: TComboBox
      Left = 16
      Top = 99
      Width = 372
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
  end
end
