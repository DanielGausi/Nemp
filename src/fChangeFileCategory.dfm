object FormChangeCategory: TFormChangeCategory
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change Category'
  ClientHeight = 348
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 308
    Width = 467
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object ImgHelp: TVirtualImage
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 32
      Height = 32
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alLeft
      ImageCollection = DataModuleGui.ICGraphics
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 21
      ImageName = 'imgHelp'
      OnClick = ImgHelpClick
      ExplicitLeft = 16
    end
    object BtnCancel: TButton
      AlignWithMargins = True
      Left = 237
      Top = 8
      Width = 107
      Height = 24
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 352
      Top = 8
      Width = 107
      Height = 24
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
  object pnlCurrent: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 308
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblCurrentCategory: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 43
      Width = 435
      Height = 13
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Current category: "%s"'
      ExplicitWidth = 114
    end
    object lblHeadline: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 16
      Width = 435
      Height = 19
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Move/Copy files into another category'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 268
    end
    object lblFiles: TLabel
      AlignWithMargins = True
      Left = 16
      Top = 68
      Width = 435
      Height = 13
      Margins.Left = 16
      Margins.Top = 8
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alTop
      Caption = 'Affected files: %d'
      ExplicitWidth = 88
    end
    object memoFiles: TMemo
      AlignWithMargins = True
      Left = 16
      Top = 85
      Width = 435
      Height = 120
      Margins.Left = 16
      Margins.Top = 0
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
    object cbCategorySelection: TLabeledComboBox
      AlignWithMargins = True
      Left = 16
      Top = 229
      Width = 435
      Height = 21
      Margins.Left = 16
      Margins.Top = 16
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alBottom
      Style = csDropDownList
      TabOrder = 1
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = 'New category'
    end
    object rbCopyFiles: TRadioButton
      AlignWithMargins = True
      Left = 16
      Top = 283
      Width = 435
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 8
      Align = alBottom
      Caption = 'Copy files into the new category'
      TabOrder = 2
    end
    object rbMoveFiles: TRadioButton
      AlignWithMargins = True
      Left = 16
      Top = 258
      Width = 435
      Height = 17
      Margins.Left = 16
      Margins.Top = 4
      Margins.Right = 16
      Margins.Bottom = 4
      Align = alBottom
      Caption = 'Move files into the new category'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
  end
end
