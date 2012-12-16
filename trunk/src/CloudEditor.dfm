object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 425
  ClientWidth = 523
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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    523
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
    Left = 408
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
    Left = 295
    Top = 392
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BugFix'
    TabOrder = 1
    Visible = False
    OnClick = BtnBugFixClick
  end
  object PC_Select: TPageControl
    Left = 8
    Top = 8
    Width = 506
    Height = 378
    ActivePage = TS_ExistingTags
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TS_ExistingTags: TTabSheet
      Caption = 'Existing tags'
      DesignSize = (
        498
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
        ParentShowHint = False
        ShowHint = True
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
        Width = 379
        Height = 251
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Header.AutoSizeIndex = 0
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
        Left = 388
        Top = 96
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Rename Tag'
        TabOrder = 3
        OnClick = BtnTagRenameClick
      end
      object BtnMerge: TButton
        Left = 388
        Top = 127
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Merge Tags'
        TabOrder = 4
        OnClick = BtnMergeClick
      end
      object BtnDeleteTags: TButton
        Left = 388
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
        Hint = 
          'When getting new tags from LastFM, this list is used to correct ' +
          'some tags'
        Caption = 'Remember merged/renamed tags'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 6
      end
      object cbAutoAddIgnoreTags: TCheckBox
        Left = 3
        Top = 73
        Width = 468
        Height = 17
        Hint = 
          'When getting new tags from LastFM, this list is used to ignore s' +
          'ome tags'
        Caption = 'Remember deleted tags'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 7
      end
    end
    object TS_MergedTags: TTabSheet
      Caption = 'Merged/renamed tags'
      ImageIndex = 2
      DesignSize = (
        498
        350)
      object MergeTagVST: TVirtualStringTree
        Left = 3
        Top = 55
        Width = 379
        Height = 292
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 4
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
        OnGetText = MergeTagVSTGetText
        OnHeaderClick = MergeTagVSTHeaderClick
        Columns = <
          item
            Position = 0
            Width = 150
            WideText = 'Original key'
          end
          item
            Position = 1
            Width = 150
            WideText = 'Replace with'
          end>
      end
      object LblMergeTagHint: TStaticText
        Left = 3
        Top = 3
        Width = 492
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'This list is used to adjust new tags from LastFM. Tags in this l' +
          'ist are automatically replaced when getting new tags.'
        TabOrder = 1
      end
      object BtnDeleteMergeTag: TButton
        Left = 388
        Top = 55
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete from list'
        TabOrder = 2
        OnClick = BtnDeleteMergeTagClick
      end
    end
    object TS_DeleteTags: TTabSheet
      Caption = 'Deleted tags'
      ImageIndex = 1
      DesignSize = (
        498
        350)
      object IgnoreTagVST: TVirtualStringTree
        Left = 3
        Top = 55
        Width = 379
        Height = 292
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 4
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
        OnGetText = IgnoreTagVSTGetText
        Columns = <
          item
            Position = 0
            Width = 200
            WideText = 'Key'
          end>
      end
      object LblDeleteTagHint: TStaticText
        Left = 3
        Top = 3
        Width = 492
        Height = 46
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'This list is used to adjust new tags from LastFM. Tags in this l' +
          'ist are automatically deleted when getting new tags.'
        TabOrder = 1
      end
      object BtnDeleteIgnoreTag: TButton
        Left = 388
        Top = 55
        Width = 107
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete from list'
        TabOrder = 2
        OnClick = BtnDeleteIgnoreTagClick
      end
    end
  end
end
