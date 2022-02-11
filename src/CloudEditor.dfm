object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 465
  ClientWidth = 551
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
    551
    465)
  PixelsPerInch = 96
  TextHeight = 13
  object LblUpdateWarning: TLabel
    Left = 8
    Top = 432
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
    Left = 389
    Top = 432
    Width = 138
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Update files now'
    Enabled = False
    TabOrder = 0
    OnClick = BtnUpdateID3TagsClick
  end
  object BtnBugFix: TButton
    Left = 266
    Top = 432
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
    Width = 534
    Height = 418
    ActivePage = TS_ExistingTags
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TS_ExistingTags: TTabSheet
      Caption = 'Existing tags'
      DesignSize = (
        526
        390)
      object lbl_ExistingTagsExplain: TLabel
        Left = 378
        Top = 112
        Width = 137
        Height = 242
        Anchors = [akTop, akRight, akBottom]
        AutoSize = False
        Caption = '..'
        WordWrap = True
        ExplicitLeft = 370
        ExplicitHeight = 296
      end
      object cbHideAutoTags: TCheckBox
        Left = 15
        Top = 360
        Width = 468
        Height = 17
        Hint = 
          'Do not show Nemp-Auto-Tags like artist, albumname, genre, year a' +
          'nd decade.'
        Anchors = [akLeft, akBottom]
        Caption = 'Hide Tags automatically added by Nemp'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbHideAutoTagsClick
      end
      object TagVST: TVirtualStringTree
        Left = 3
        Top = 3
        Width = 358
        Height = 351
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Header.AutoSizeIndex = 0
        Header.Options = [hoColumnResize, hoDrag, hoVisible]
        IncrementalSearch = isAll
        Indent = 4
        PopupMenu = PopupExistingTags
        TabOrder = 1
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
            Width = 217
            WideText = 'Tag'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Count'
          end>
      end
      object BtnMerge: TButton
        Left = 378
        Top = 9
        Width = 137
        Height = 25
        Hint = 'Rename an existing tag and add a "Rename rule"'
        Anchors = [akTop, akRight]
        Caption = 'Add "Rename rule"'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = BtnAddRenameRuleClick
      end
      object BtnDeleteTags: TButton
        Left = 378
        Top = 40
        Width = 137
        Height = 25
        Hint = 'Remove an existing tag and add a "Ignore rule"'
        Anchors = [akTop, akRight]
        Caption = 'Add "Ignore rule"'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = BtnAddIgnoreRuleClick
      end
      object BtnJustRemoveTags: TButton
        Left = 378
        Top = 71
        Width = 138
        Height = 25
        Hint = 
          'Just remove an existing tag from all files in the media library,' +
          ' without a new "Ignore rule"'
        Anchors = [akTop, akRight]
        Caption = 'Just remove tags'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = BtnJustRemoveTagsClick
      end
    end
    object TS_MergedTags: TTabSheet
      Caption = 'Rename rules'
      ImageIndex = 2
      DesignSize = (
        526
        390)
      object LblMergeTagHint: TLabel
        Left = 378
        Top = 40
        Width = 126
        Height = 333
        Anchors = [akTop, akRight, akBottom]
        AutoSize = False
        Caption = '..'
        WordWrap = True
      end
      object MergeTagVST: TVirtualStringTree
        Left = 3
        Top = 3
        Width = 358
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Header.AutoSizeIndex = 0
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 4
        PopupMenu = PopupRenameRules
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
      object BtnDeleteMergeTag: TButton
        Left = 378
        Top = 9
        Width = 137
        Height = 25
        Hint = 'Delete the selected "Rename rules"'
        Anchors = [akTop, akRight]
        Caption = 'Delete "Rename rule"'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BtnDeleteRenameRuleClick
      end
    end
    object TS_DeleteTags: TTabSheet
      Caption = 'Ignore rules'
      ImageIndex = 1
      DesignSize = (
        526
        390)
      object Lbl_IgnoreTagHint: TLabel
        Left = 378
        Top = 40
        Width = 126
        Height = 333
        Anchors = [akTop, akRight, akBottom]
        AutoSize = False
        Caption = '..'
        WordWrap = True
      end
      object IgnoreTagVST: TVirtualStringTree
        Left = 3
        Top = 3
        Width = 358
        Height = 384
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderWidth = 1
        Colors.UnfocusedSelectionColor = clHighlight
        Colors.UnfocusedSelectionBorderColor = clHighlight
        Header.AutoSizeIndex = 0
        Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 4
        PopupMenu = PopupIgnoreRules
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
      object BtnDeleteIgnoreTag: TButton
        Left = 378
        Top = 9
        Width = 137
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Delete "Ignore rule"'
        TabOrder = 1
        OnClick = BtnDeleteIgnoreRuleClick
      end
    end
  end
  object PopupExistingTags: TPopupMenu
    Left = 48
    Top = 80
    object pm_AddRenameRule: TMenuItem
      Caption = 'Add "Rename rule"'
      ShortCut = 113
      OnClick = BtnAddRenameRuleClick
    end
    object pm_AddIgnoreRule: TMenuItem
      Caption = 'Add "Ignore rule"'
      ShortCut = 16430
      OnClick = BtnAddIgnoreRuleClick
    end
    object pm_JustRemoveTags: TMenuItem
      Caption = 'Just remove tags'
      ShortCut = 46
      OnClick = BtnJustRemoveTagsClick
    end
  end
  object PopupRenameRules: TPopupMenu
    Left = 40
    Top = 160
    object pm_DeleteRenameRule: TMenuItem
      Caption = 'Delete "Rename rule"'
      OnClick = BtnDeleteRenameRuleClick
    end
  end
  object PopupIgnoreRules: TPopupMenu
    Left = 40
    Top = 248
    object pm_DeleteIgnoreRule: TMenuItem
      Caption = 'Delete "Ignore rule"'
      OnClick = BtnDeleteIgnoreRuleClick
    end
  end
end
