object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 593
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblMinTagCount: TLabel
    Left = 16
    Top = 31
    Width = 191
    Height = 13
    Caption = 'Show only tags with a minimum count of'
  end
  object TagVST: TVirtualStringTree
    Left = 8
    Top = 104
    Width = 401
    Height = 481
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    IncrementalSearch = isAll
    Indent = 4
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
    OnColumnDblClick = TagVSTColumnDblClick
    OnGetText = TagVSTGetText
    OnPaintText = TagVSTPaintText
    OnHeaderClick = TagVSTHeaderClick
    OnIncrementalSearch = TagVSTIncrementalSearch
    OnKeyDown = TagVSTKeyDown
    Columns = <
      item
        Position = 0
        Width = 250
        WideText = 'Key'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Count'
      end>
  end
  object cbHideAutoTags: TCheckBox
    Left = 16
    Top = 8
    Width = 97
    Height = 17
    Hint = 
      'Do not show Nemp-Auto-Tags like artist, albumname, genre, year a' +
      'nd decade.'
    Caption = 'Hide Auto-Tags'
    TabOrder = 1
    OnClick = cbHideAutoTagsClick
  end
  object seMinTagCount: TSpinEdit
    Left = 16
    Top = 50
    Width = 65
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 2
    Value = 1
    OnChange = seMinTagCountChange
  end
  object BtnTagRename: TButton
    Left = 424
    Top = 144
    Width = 107
    Height = 25
    Caption = 'Rename Tag'
    TabOrder = 3
    OnClick = BtnTagRenameClick
  end
end
