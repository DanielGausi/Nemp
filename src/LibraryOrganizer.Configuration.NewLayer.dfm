object FormNewLayer: TFormNewLayer
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Nemp: New category layer'
  ClientHeight = 249
  ClientWidth = 408
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
    Top = 209
    Width = 408
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 420
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 206
      Top = 8
      Width = 85
      Height = 24
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = BtnOKClick
      ExplicitLeft = 150
      ExplicitTop = 6
      ExplicitHeight = 34
    end
    object BtnCancel: TButton
      AlignWithMargins = True
      Left = 307
      Top = 8
      Width = 85
      Height = 24
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 325
      ExplicitTop = 6
      ExplicitHeight = 25
    end
  end
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 408
    Height = 209
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 420
    ExplicitHeight = 208
    DesignSize = (
      408
      209)
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
      Width = 380
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = cbPropertiesChange
      ExplicitWidth = 392
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
      Width = 180
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 2
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
      ExplicitWidth = 192
    end
    object cbSecondaryDirection: TComboBox
      AlignWithMargins = True
      Left = 216
      Top = 147
      Width = 180
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 4
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
      ExplicitWidth = 192
    end
    object cbTertiaryDirection: TComboBox
      AlignWithMargins = True
      Left = 216
      Top = 174
      Width = 180
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemIndex = 0
      TabOrder = 6
      Text = 'Ascending'
      Items.Strings = (
        'Ascending'
        'Descending')
      ExplicitWidth = 192
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
