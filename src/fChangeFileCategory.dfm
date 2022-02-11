object FormChangeCategory: TFormChangeCategory
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change Category'
  ClientHeight = 346
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtons: TPanel
    Left = 0
    Top = 305
    Width = 467
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 352
    ExplicitTop = 184
    ExplicitWidth = 185
    DesignSize = (
      467
      41)
    object BtnCancel: TButton
      AlignWithMargins = True
      Left = 348
      Top = 8
      Width = 107
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 441
    end
    object BtnOK: TButton
      AlignWithMargins = True
      Left = 219
      Top = 8
      Width = 107
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 1
      ExplicitLeft = 312
    end
  end
  object pnlNewCategory: TPanel
    Left = 0
    Top = 209
    Width = 467
    Height = 96
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 384
    ExplicitWidth = 459
    DesignSize = (
      467
      96)
    object lblNewCategory: TLabel
      Left = 16
      Top = 8
      Width = 67
      Height = 13
      Caption = 'New category'
    end
    object cbCategorySelection: TComboBox
      AlignWithMargins = True
      Left = 16
      Top = 27
      Width = 427
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      ExplicitWidth = 419
    end
    object rbMoveFiles: TRadioButton
      AlignWithMargins = True
      Left = 16
      Top = 54
      Width = 427
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Move files into the new category'
      Checked = True
      TabOrder = 1
      TabStop = True
      ExplicitWidth = 419
    end
    object rbCopyFiles: TRadioButton
      AlignWithMargins = True
      Left = 16
      Top = 77
      Width = 427
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Copy files into the new category'
      TabOrder = 2
      ExplicitWidth = 419
    end
  end
  object pnlFiles: TPanel
    Left = 0
    Top = 60
    Width = 467
    Height = 149
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 71
    ExplicitHeight = 234
    DesignSize = (
      467
      149)
    object lblFiles: TLabel
      Left = 16
      Top = 5
      Width = 88
      Height = 13
      Caption = 'Affected files: %d'
    end
    object memoFiles: TMemo
      AlignWithMargins = True
      Left = 16
      Top = 24
      Width = 427
      Height = 119
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
      ExplicitHeight = 154
    end
  end
  object pnlCurrent: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 461
    object lblCurrentCategory: TLabel
      Left = 16
      Top = 41
      Width = 114
      Height = 13
      Caption = 'Current category: "%s"'
    end
    object lblHeadline: TLabel
      Left = 16
      Top = 16
      Width = 268
      Height = 19
      Caption = 'Move/Copy files into another category'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
end
