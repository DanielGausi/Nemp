object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 399
  ClientWidth = 516
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    516
    399)
  PixelsPerInch = 96
  TextHeight = 13
  object lblMinTagCount: TLabel
    Left = 16
    Top = 31
    Width = 191
    Height = 13
    Caption = 'Show only tags with a minimum count of'
  end
  object LblUpdateWarning: TLabel
    Left = 8
    Top = 366
    Width = 109
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'CountInconsistentFiles'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    ExplicitTop = 279
  end
  object TagVST: TVirtualStringTree
    Left = 8
    Top = 78
    Width = 387
    Height = 282
    Anchors = [akLeft, akTop, akRight, akBottom]
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
    OnBeforeItemErase = TagVSTBeforeItemErase
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
    Checked = True
    State = cbChecked
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
    Left = 401
    Top = 78
    Width = 107
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Rename Tag'
    TabOrder = 3
    OnClick = BtnTagRenameClick
  end
  object BtnUpdateID3Tags: TButton
    Left = 401
    Top = 366
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Update files now'
    Enabled = False
    TabOrder = 4
    OnClick = BtnUpdateID3TagsClick
  end
  object BtnMerge: TButton
    Left = 401
    Top = 109
    Width = 107
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Merge Tags'
    TabOrder = 5
    OnClick = BtnMergeClick
  end
  object BtnDeleteTags: TButton
    Left = 401
    Top = 140
    Width = 107
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete Tags'
    TabOrder = 6
    OnClick = BtnDeleteTagsClick
  end
  object BtnBugFix: TButton
    Left = 401
    Top = 335
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BugFix'
    TabOrder = 7
    OnClick = BtnBugFixClick
  end
end
