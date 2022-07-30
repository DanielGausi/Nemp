object PlaylistEditorForm: TPlaylistEditorForm
  Left = 0
  Top = 0
  Caption = 'Nemp: Playlist editor'
  ClientHeight = 261
  ClientWidth = 554
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 570
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ShowHint = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 220
    Top = 0
    Height = 261
    ResizeStyle = rsUpdate
    ExplicitLeft = 384
    ExplicitTop = 336
    ExplicitHeight = 100
  end
  object PnlPlaylistSelection: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 261
    Align = alLeft
    BevelOuter = bvNone
    Constraints.MinWidth = 220
    TabOrder = 0
    DesignSize = (
      220
      261)
    object PlaylistSelectionVST: TVirtualStringTree
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 214
      Height = 220
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      Header.AutoSizeIndex = 0
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Indent = 4
      Margin = 2
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnDragAllowed = PlaylistSelectionVSTDragAllowed
      OnDragOver = PlaylistSelectionVSTDragOver
      OnDragDrop = PlaylistSelectionVSTDragDrop
      OnEdited = PlaylistSelectionVSTEdited
      OnEditing = PlaylistSelectionVSTEditing
      OnEndDrag = PlaylistSelectionVSTEndDrag
      OnFocusChanged = PlaylistSelectionVSTFocusChanged
      OnFocusChanging = PlaylistSelectionVSTFocusChanging
      OnGetText = PlaylistSelectionVSTGetText
      OnPaintText = PlaylistSelectionVSTPaintText
      OnNewText = PlaylistSelectionVSTNewText
      OnStartDrag = PlaylistSelectionVSTStartDrag
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <
        item
          Position = 0
          Text = 'Favorite playlists'
          Width = 210
        end>
    end
    object BtnNew: TButton
      AlignWithMargins = True
      Left = 3
      Top = 232
      Width = 100
      Height = 25
      Hint = 'Create a new favorite playlist'
      Anchors = [akLeft, akBottom]
      Caption = 'New'
      TabOrder = 1
      OnClick = BtnNewClick
    end
    object BtnRemove: TButton
      AlignWithMargins = True
      Left = 109
      Top = 232
      Width = 100
      Height = 25
      Hint = 'Remove selected favorite playlist'
      Anchors = [akLeft, akBottom]
      Caption = 'Delete'
      TabOrder = 2
      OnClick = BtnRemoveClick
    end
  end
  object PnlPlaylistFiles: TPanel
    Left = 223
    Top = 0
    Width = 331
    Height = 261
    Align = alClient
    BevelOuter = bvNone
    Constraints.MinWidth = 320
    TabOrder = 1
    DesignSize = (
      331
      261)
    object PlaylistFilesVST: TVirtualStringTree
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 325
      Height = 220
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DefaultPasteMode = amInsertAfter
      DragWidth = 10
      Header.AutoSizeIndex = 0
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
      HintMode = hmHint
      Indent = 4
      Margin = 2
      ParentShowHint = False
      PopupMenu = PopUpPlaylist
      ScrollBarOptions.ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking, toAutoChangeScale]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
      OnDragAllowed = PlaylistFilesVSTDragAllowed
      OnDragOver = PlaylistFilesVSTDragOver
      OnDragDrop = PlaylistFilesVSTDragDrop
      OnEndDrag = PlaylistFilesVSTEndDrag
      OnGetText = PlaylistFilesVSTGetText
      OnPaintText = PlaylistFilesVSTPaintText
      OnGetHint = PlaylistFilesVSTGetHint
      OnGetUserClipboardFormats = PlaylistFilesVSTGetUserClipboardFormats
      OnRenderOLEData = PlaylistFilesVSTRenderOLEData
      OnStartDrag = PlaylistFilesVSTStartDrag
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <
        item
          Position = 0
          Text = 'Title'
          Width = 257
        end
        item
          Alignment = taRightJustify
          CaptionAlignment = taRightJustify
          Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
          Position = 1
          Text = 'Duration'
          Width = 64
        end>
    end
    object BtnSave: TButton
      AlignWithMargins = True
      Left = 215
      Top = 232
      Width = 100
      Height = 25
      Hint = 'Save current playlist'
      Anchors = [akLeft, akBottom]
      Caption = 'Save'
      TabOrder = 3
      OnClick = PM_PL_SaveClick
    end
    object BtnImport: TButton
      AlignWithMargins = True
      Left = 109
      Top = 232
      Width = 100
      Height = 25
      Hint = 'Import files from an existing playlist'
      Anchors = [akLeft, akBottom]
      Caption = 'Import'
      TabOrder = 2
      OnClick = PM_PL_ImportClick
    end
    object BtnAdd: TButton
      AlignWithMargins = True
      Left = 3
      Top = 232
      Width = 100
      Height = 25
      Hint = 'Add files to the current playlist'
      Anchors = [akLeft, akBottom]
      Caption = 'Add'
      TabOrder = 1
      OnClick = PM_PL_AddFilesClick
    end
  end
  object PlayListOpenDialog: TOpenDialog
    Filter = 
      'All supported files|*.m3u;*.m3u8;*.pls;*.npl;*.asx;*.wax|m3u-lis' +
      'ts|*.m3u|m3u8-lists (unicode-capable)|*.m3u8|pls-lists|*.pls|Nem' +
      'p playlists|*.npl|WindowsMedia|*.asx;*.wax'
    Left = 41
    Top = 89
  end
  object PopUpPlaylist: TPopupMenu
    OnPopup = PopUpPlaylistPopup
    Left = 176
    Top = 32
    object PM_PL_AddFiles: TMenuItem
      Caption = 'Add files'
      OnClick = PM_PL_AddFilesClick
    end
    object PM_PL_AddPlaylist: TMenuItem
      Caption = 'Add playlist'
      OnClick = PM_PL_ImportClick
    end
    object PM_PL_Delete: TMenuItem
      Caption = 'Remove selected'
      ShortCut = 46
      OnClick = PM_PL_DeleteClick
    end
    object PM_PL_Save: TMenuItem
      Caption = 'Save'
      ShortCut = 16467
      OnClick = PM_PL_SaveClick
    end
    object PM_PL_ShowinExplorer: TMenuItem
      Caption = 'Show in Windows Explorer'
      OnClick = PM_PL_ShowinExplorerClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PM_PL_Copy: TMenuItem
      Caption = 'Copy'
      ShortCut = 16451
      OnClick = PM_PL_CopyClick
    end
    object PM_PL_Paste: TMenuItem
      Caption = 'Paste'
      ShortCut = 16470
      OnClick = PM_PL_PasteClick
    end
  end
  object PlaylistDateienOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 41
    Top = 144
  end
end
