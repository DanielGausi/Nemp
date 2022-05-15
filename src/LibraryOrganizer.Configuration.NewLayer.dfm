object FormNewLayer: TFormNewLayer
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: New category layer'
  ClientHeight = 249
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object PnlButtons: TPanel
    Left = 0
    Top = 208
    Width = 420
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      420
      41)
    object BtnOK: TButton
      Left = 226
      Top = 6
      Width = 85
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnCancel: TButton
      Left = 325
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
    Width = 420
    Height = 208
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      420
      208)
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
    object lblSecondarySorting: TLabel
      Left = 16
      Top = 126
      Width = 92
      Height = 13
      Caption = 'Secondary sortings'
    end
    object cbProperties: TComboBox
      Left = 16
      Top = 51
      Width = 392
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = cbPropertiesChange
    end
    object cbPrimarySorting: TComboBox
      Left = 16
      Top = 99
      Width = 180
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object cbPrimaryDirection: TComboBox
      AlignWithMargins = True
      Left = 216
      Top = 99
      Width = 192
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 2
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
    end
    object cbSecondaryDirection: TComboBox
      AlignWithMargins = True
      Left = 216
      Top = 147
      Width = 192
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 4
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
    end
    object cbTertiaryDirection: TComboBox
      AlignWithMargins = True
      Left = 216
      Top = 174
      Width = 192
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 6
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
    end
    object cbSecondarySorting: TComboBox
      Left = 16
      Top = 147
      Width = 180
      Height = 21
      Style = csDropDownList
      TabOrder = 3
    end
    object cbTertiarySorting: TComboBox
      Left = 16
      Top = 174
      Width = 180
      Height = 21
      Style = csDropDownList
      TabOrder = 5
    end
  end
end
