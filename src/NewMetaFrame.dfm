object NewMetaFrameForm: TNewMetaFrameForm
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Add new meta data'
  ClientHeight = 168
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClick = BtnOKClick
  OnCreate = FormCreate
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 133
    Width = 363
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      363
      35)
    object Btn_Cancel: TButton
      Left = 250
      Top = 6
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 266
    end
    object Btn_OK: TButton
      Left = 138
      Top = 6
      Width = 97
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      Enabled = False
      TabOrder = 1
      OnClick = BtnOKClick
      ExplicitLeft = 154
    end
  end
  object pnlData: TPanel
    Left = 0
    Top = 0
    Width = 363
    Height = 133
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lbl_FrameType: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 16
      Width = 347
      Height = 13
      Margins.Left = 8
      Margins.Top = 16
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Frame key/description'
      ExplicitWidth = 106
    end
    object lbl_FrameValue: TLabel
      AlignWithMargins = True
      Left = 8
      Top = 82
      Width = 347
      Height = 13
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Frame content'
      ExplicitWidth = 70
    end
    object edt_FrameValue: TEdit
      AlignWithMargins = True
      Left = 8
      Top = 99
      Width = 347
      Height = 21
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 363
    end
    object pnlMeta: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 33
      Width = 355
      Height = 37
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object cbTagTypeSelection: TComboBox
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 85
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alLeft
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbTagTypeSelectionChange
      end
      object cbFrameType: TComboBox
        AlignWithMargins = True
        Left = 97
        Top = 4
        Width = 254
        Height = 29
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alClient
        Style = csDropDownList
        TabOrder = 1
      end
    end
  end
end
