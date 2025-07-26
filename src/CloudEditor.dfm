object CloudEditorForm: TCloudEditorForm
  Left = 0
  Top = 0
  Caption = 'Tagcloud: Editor'
  ClientHeight = 460
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
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object PC_Select: TPageControl
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 535
    Height = 412
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 0
    ActivePage = TS_ExistingTags
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 534
    ExplicitHeight = 265
    object TS_ExistingTags: TTabSheet
      Caption = 'Existing tags'
      object pnlExistingTags: TPanel
        Left = 0
        Top = 0
        Width = 355
        Height = 384
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 257
        ExplicitHeight = 395
        object cbHideAutoTags: TCheckBox
          AlignWithMargins = True
          Left = 8
          Top = 359
          Width = 339
          Height = 17
          Hint = 
            'Do not show Nemp-Auto-Tags like artist, albumname, genre, year a' +
            'nd decade.'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alBottom
          Caption = 'Hide Tags automatically added by Nemp'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbHideAutoTagsClick
          ExplicitLeft = 57
          ExplicitTop = 325
          ExplicitWidth = 468
        end
        object TagVST: TVirtualStringTree
          Left = 0
          Top = 0
          Width = 355
          Height = 351
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 0
          Align = alClient
          BorderWidth = 1
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Header.AutoSizeIndex = 0
          Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
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
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          ExplicitLeft = 195
          ExplicitTop = 32
          ExplicitWidth = 178
          ExplicitHeight = 247
          Columns = <
            item
              Position = 0
              Text = 'Tag'
              Width = 217
            end
            item
              Position = 1
              Text = 'Count'
              Width = 100
            end>
        end
      end
      object pnlExistingTagsButtons: TPanel
        Left = 355
        Top = 0
        Width = 172
        Height = 384
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 395
        object lbl_ExistingTagsExplain: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 107
          Width = 156
          Height = 269
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          AutoSize = False
          Caption = '..'
          WordWrap = True
          ExplicitLeft = 3
          ExplicitTop = 115
          ExplicitWidth = 137
          ExplicitHeight = 247
        end
        object BtnDeleteTags: TButton
          AlignWithMargins = True
          Left = 8
          Top = 41
          Width = 156
          Height = 25
          Hint = 'Remove an existing tag and add a "Ignore rule"'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Add "Ignore rule"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = BtnAddIgnoreRuleClick
          ExplicitLeft = 17
          ExplicitTop = 39
          ExplicitWidth = 137
        end
        object BtnJustRemoveTags: TButton
          AlignWithMargins = True
          Left = 8
          Top = 74
          Width = 156
          Height = 25
          Hint = 
            'Just remove an existing tag from all files in the media library,' +
            ' without a new "Ignore rule"'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Just remove tags'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BtnJustRemoveTagsClick
          ExplicitLeft = 16
          ExplicitTop = 70
          ExplicitWidth = 138
        end
        object BtnMerge: TButton
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 156
          Height = 25
          Hint = 'Rename an existing tag and add a "Rename rule"'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Add "Rename rule"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = BtnAddRenameRuleClick
          ExplicitLeft = 17
          ExplicitWidth = 137
        end
      end
    end
    object TS_MergedTags: TTabSheet
      Caption = 'Rename rules'
      ImageIndex = 2
      object MergeTagVST: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 355
        Height = 384
        Align = alClient
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
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitWidth = 118
        ExplicitHeight = 389
        Columns = <
          item
            Position = 0
            Text = 'Original key'
            Width = 150
          end
          item
            Position = 1
            Text = 'Replace with'
            Width = 150
          end>
      end
      object pnlRenameRulesButtons: TPanel
        Left = 355
        Top = 0
        Width = 172
        Height = 384
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitHeight = 395
        object LblMergeTagHint: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 41
          Width = 156
          Height = 335
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          AutoSize = False
          Caption = '..'
          WordWrap = True
          ExplicitLeft = 51
          ExplicitTop = 78
          ExplicitWidth = 126
          ExplicitHeight = 338
        end
        object BtnDeleteMergeTag: TButton
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 156
          Height = 25
          Hint = 'Delete the selected "Rename rules"'
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Delete "Rename rule"'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = BtnDeleteRenameRuleClick
          ExplicitLeft = 48
          ExplicitTop = 9
          ExplicitWidth = 137
        end
      end
    end
    object TS_DeleteTags: TTabSheet
      Caption = 'Ignore rules'
      ImageIndex = 1
      object IgnoreTagVST: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 355
        Height = 384
        Align = alClient
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
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        ExplicitLeft = 3
        ExplicitTop = 3
        ExplicitWidth = 94
        ExplicitHeight = 389
        Columns = <
          item
            Position = 0
            Text = 'Key'
            Width = 200
          end>
      end
      object pnlIgnoreRulesButtons: TPanel
        Left = 355
        Top = 0
        Width = 172
        Height = 384
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitLeft = 152
        ExplicitTop = 9
        ExplicitHeight = 383
        object Lbl_IgnoreTagHint: TLabel
          AlignWithMargins = True
          Left = 8
          Top = 41
          Width = 156
          Height = 335
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 8
          Align = alClient
          AutoSize = False
          Caption = '..'
          WordWrap = True
          ExplicitLeft = 59
          ExplicitTop = 40
          ExplicitWidth = 126
          ExplicitHeight = 338
        end
        object BtnDeleteIgnoreTag: TButton
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 156
          Height = 25
          Margins.Left = 8
          Margins.Top = 8
          Margins.Right = 8
          Margins.Bottom = 0
          Align = alTop
          Caption = 'Delete "Ignore rule"'
          TabOrder = 0
          OnClick = BtnDeleteIgnoreRuleClick
          ExplicitLeft = 48
          ExplicitTop = 9
          ExplicitWidth = 137
        end
      end
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 420
    Width = 551
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 24
    ExplicitTop = 408
    ExplicitWidth = 473
    object LblUpdateWarning: TLabel
      Left = 47
      Top = 12
      Width = 109
      Height = 13
      Margins.Top = 8
      Margins.Bottom = 8
      Caption = 'CountInconsistentFiles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
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
      OnClick = BtnHelpClick
      ExplicitLeft = 16
      ExplicitTop = 16
      ExplicitHeight = 24
    end
    object BtnBugFix: TButton
      AlignWithMargins = True
      Left = 320
      Top = 8
      Width = 77
      Height = 24
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alRight
      Caption = 'BugFix'
      TabOrder = 0
      Visible = False
      OnClick = BtnBugFixClick
      ExplicitLeft = 216
      ExplicitTop = -1
      ExplicitHeight = 25
    end
    object BtnUpdateID3Tags: TButton
      AlignWithMargins = True
      Left = 405
      Top = 8
      Width = 138
      Height = 24
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Update files now'
      Enabled = False
      TabOrder = 1
      OnClick = BtnUpdateID3TagsClick
      ExplicitLeft = 335
      ExplicitTop = 7
      ExplicitHeight = 25
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
