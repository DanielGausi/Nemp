object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 425
  ClientWidth = 521
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
    521
    425)
  PixelsPerInch = 96
  TextHeight = 13
  object LblUpdateWarning: TLabel
    Left = 8
    Top = 392
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
  object BtnUpdateID3Tags: TButton
    Left = 406
    Top = 392
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Update files now'
    Enabled = False
    TabOrder = 0
    OnClick = BtnUpdateID3TagsClick
  end
  object BtnBugFix: TButton
    Left = 293
    Top = 392
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BugFix'
    TabOrder = 1
    OnClick = BtnBugFixClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 504
    Height = 378
    ActivePage = TS_DeleteTags
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TS_ExistingTags: TTabSheet
      Caption = 'Existing tags'
      DesignSize = (
        496
        350)
      object lblMinTagCount: TLabel
        Left = 63
        Top = 31
        Width = 408
        Height = 13
        AutoSize = False
        Caption = 'Minimum count of shown tags'
      end
      object cbHideAutoTags: TCheckBox
        Left = 3
        Top = 8
        Width = 468
        Height = 17
        Hint = 
          'Do not show Nemp-Auto-Tags like artist, albumname, genre, year a' +
          'nd decade.'
        Caption = 'Hide Auto-Tags'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbHideAutoTagsClick
      end
      object seMinTagCount: TSpinEdit
        Left = 3
        Top = 28
        Width = 54
        Height = 22
        MaxValue = 10
        MinValue = 1
        TabOrder = 1
        Value = 1
        OnChange = seMinTagCountChange
      end
      object TagVST: TVirtualStringTree
        Left = 3
        Top = 96
        Width = 377
        Height = 251
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
        TabOrder = 2
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
      object BtnTagRename: TButton
        Left = 386
        Top = 96
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Rename Tag'
        TabOrder = 3
        OnClick = BtnTagRenameClick
      end
      object BtnMerge: TButton
        Left = 386
        Top = 127
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Merge Tags'
        TabOrder = 4
        OnClick = BtnMergeClick
      end
      object BtnDeleteTags: TButton
        Left = 386
        Top = 158
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete Tags'
        TabOrder = 5
        OnClick = BtnDeleteTagsClick
      end
      object cbAutoAddMergeTags: TCheckBox
        Left = 3
        Top = 55
        Width = 468
        Height = 17
        Caption = 'Remember merged/renamed tags'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object cbAutoAddIgnoreTags: TCheckBox
        Left = 3
        Top = 73
        Width = 468
        Height = 17
        Caption = 'Remember deleted tags'
        Checked = True
        State = cbChecked
        TabOrder = 7
      end
    end
    object TS_MergedTags: TTabSheet
      Caption = 'Merged/renamed tags'
      ImageIndex = 2
      object MergeTagVST: TVirtualStringTree
        Left = 24
        Top = 16
        Width = 364
        Height = 305
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        TabOrder = 0
        Columns = <>
      end
    end
    object TS_DeleteTags: TTabSheet
      Caption = 'Deleted tags'
      ImageIndex = 1
      object IgnoreTagVST: TVirtualStringTree
        Left = 24
        Top = 16
        Width = 364
        Height = 305
        Header.AutoSizeIndex = 0
        Header.DefaultHeight = 17
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.MainColumn = -1
        TabOrder = 0
        Columns = <>
      end
    end
  end
end
