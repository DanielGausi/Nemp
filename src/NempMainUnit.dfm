object Nemp_MainForm: TNemp_MainForm
  Left = 0
  Top = 0
  Caption = 'Nemp - Noch ein MP3-Player'
  ClientHeight = 749
  ClientWidth = 1090
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = Nemp_MainMenu
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = TntFormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = TntFormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyUp = PlaylistVSTKeyUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object __MainContainerPanel: TNempPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 1090
    Height = 749
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = __MainContainerPanelMouseDown
    OnMouseMove = __MainContainerPanelMouseMove
    OnMouseUp = __MainContainerPanelMouseUp
    OnResize = __MainContainerPanelResize
    OwnerDraw = False
    object MainSplitter: TSplitter
      Left = 0
      Top = 240
      Width = 1090
      Height = 4
      Cursor = crVSplit
      Align = alTop
      Color = clBtnFace
      MinSize = 150
      ParentColor = False
      ResizeStyle = rsUpdate
      StyleElements = [seFont, seBorder]
      OnCanResize = SplitterFileOverviewCanResize
      OnMoved = MainSplitterMoved
      ExplicitWidth = 1047
    end
    object _TopMainPanel: TPanel
      Tag = 200
      Left = 0
      Top = 0
      Width = 1090
      Height = 240
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 240
      TabOrder = 0
      OnResize = _TopMainPanelResize
      object SubSplitter1: TSplitter
        Left = 540
        Top = 0
        Width = 4
        Height = 240
        MinSize = 100
        ResizeStyle = rsUpdate
        StyleElements = [seFont, seBorder]
        OnCanResize = SplitterFileOverviewCanResize
        OnMoved = SubSplitter1Moved
        ExplicitLeft = 385
        ExplicitHeight = 425
      end
      object AuswahlPanel: TPanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 540
        Height = 240
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        OnMouseDown = AuswahlPanelMouseDown
        OnResize = AuswahlPanelResize
        object GRPBOXArtistsAlben: TNempPanel
          Tag = 2
          Left = 0
          Top = 28
          Width = 540
          Height = 212
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          OnResize = GRPBOXArtistsAlbenResize
          OnPaint = GRPBOXArtistsAlbenPaint
          OwnerDraw = False
          DesignSize = (
            540
            212)
          object LblEmptyLibraryHint: TLabel
            Left = 60
            Top = 4
            Width = 205
            Height = 116
            AutoSize = False
            Caption = 'Library is empty'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            WordWrap = True
            StyleElements = [seClient, seBorder]
          end
          object PanelCoverBrowse: TNempPanel
            Tag = 2
            Left = 98
            Top = 6
            Width = 167
            Height = 175
            Anchors = []
            BevelOuter = bvNone
            PopupMenu = Medialist_Browse_PopupMenu
            TabOrder = 1
            Visible = False
            OnDblClick = PanelCoverBrowseDblClick
            OnMouseDown = PanelCoverBrowseMouseDown
            OnMouseMove = IMGMedienBibCoverMouseMove
            OnMouseUp = IMGMedienBibCoverMouseUp
            OnResize = PanelCoverBrowseResize
            OnPaint = PanelCoverBrowsePaint
            OnAfterPaint = PanelCoverBrowseAfterPaint
            OwnerDraw = False
            OnMouseWheelUp = PanelCoverBrowseMouseWheelUp
            OnMouseWheelDown = PanelCoverBrowseMouseWheelDown
            DesignSize = (
              167
              175)
            object IMGMedienBibCover: TImage
              Left = 3
              Top = 6
              Width = 164
              Height = 24
              Anchors = [akLeft, akTop, akRight, akBottom]
              Center = True
              DragCursor = crDefault
              Proportional = True
              OnMouseDown = IMGMedienBibCoverMouseDown
              OnMouseMove = IMGMedienBibCoverMouseMove
              OnMouseUp = IMGMedienBibCoverMouseUp
            end
            object ImgScrollCover: TImage
              Left = 1
              Top = 36
              Width = 164
              Height = 75
              Anchors = [akLeft, akRight, akBottom]
              Transparent = True
              OnMouseDown = ImgScrollCoverMouseDown
              ExplicitWidth = 297
            end
            object CoverScrollbar: TScrollBar
              Left = 8
              Top = 156
              Width = 159
              Height = 17
              Anchors = [akLeft, akRight, akBottom]
              LargeChange = 3
              Max = 3
              PageSize = 3
              TabOrder = 0
              OnChange = CoverScrollbarChange
              OnEnter = CoverScrollbarEnter
              OnKeyDown = CoverScrollbarKeyDown
            end
            object Pnl_CoverFlowLabel: TNempPanel
              Tag = 2
              Left = 30
              Top = 117
              Width = 100
              Height = 33
              Anchors = [akLeft, akRight, akBottom]
              BevelOuter = bvNone
              Caption = 'Pnl_CoverFlowLabel'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindow
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowCaption = False
              TabOrder = 1
              OnMouseDown = Lbl_CoverFlowMouseDown
              OnPaint = Pnl_CoverFlowLabelPaint
              OwnerDraw = False
              DesignSize = (
                100
                33)
              object Lbl_CoverFlow: TLabel
                Left = 38
                Top = 10
                Width = 62
                Height = 13
                Alignment = taCenter
                Anchors = [akLeft, akTop, akRight]
                AutoSize = False
                ShowAccelChar = False
                Transparent = True
                StyleElements = [seClient, seBorder]
                OnMouseDown = Lbl_CoverFlowMouseDown
              end
              object TabBtnCoverCategory: TSkinButton
                Tag = 1
                Left = 8
                Top = 5
                Width = 24
                Height = 24
                Hint = 'Select category'
                ParentShowHint = False
                PopupMenu = Medialist_Browse_Categories_PopupMenu
                ShowHint = True
                TabOrder = 0
                TabStop = False
                OnClick = TabBtnCoverCategoryClick
                DrawMode = dm_Skin
                NumGlyphsX = 5
                NumGlyphsY = 1
                GlyphLine = 0
                CustomRegion = False
                FocusDrawMode = fdm_Windows
                Color1 = clBlack
                Color2 = clBlack
              end
            end
          end
          object PanelStandardBrowse: TPanel
            Tag = 2
            Left = 318
            Top = -10
            Width = 216
            Height = 140
            Anchors = []
            BevelOuter = bvNone
            PopupMenu = Medialist_Browse_PopupMenu
            TabOrder = 0
            object SplitterBrowse: TSplitter
              Left = 73
              Top = 0
              Width = 4
              Height = 140
              StyleElements = [seFont, seBorder]
              OnMoved = SplitterBrowseMoved
              ExplicitHeight = 59
            end
            object ArtistsVST: TVirtualStringTree
              Tag = 1
              Left = 0
              Top = 0
              Width = 73
              Height = 140
              Align = alLeft
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Constraints.MinWidth = 20
              DefaultNodeHeight = 14
              DragOperations = []
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Header.AutoSizeIndex = 0
              Header.Background = clWindow
              Header.Height = 21
              Header.Options = [hoAutoResize, hoDrag, hoVisible]
              IncrementalSearch = isAll
              Indent = 14
              Margin = 0
              ParentFont = False
              PopupMenu = Medialist_Browse_PopupMenu
              ScrollBarOptions.ScrollBars = ssVertical
              StyleElements = [seClient, seBorder]
              TabOrder = 0
              TextMargin = 2
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
              TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
              TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
              OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
              OnAfterItemErase = VSTAfterItemErase
              OnClick = ArtistsVSTClick
              OnDragAllowed = ArtistsVSTDragAllowed
              OnFocusChanged = ArtistsVSTFocusChanged
              OnGetText = StringVSTGetText
              OnPaintText = ArtistsVSTPaintText
              OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
              OnIncrementalSearch = ArtistsVSTIncrementalSearch
              OnResize = ArtistsVSTResize
              Columns = <
                item
                  MinWidth = 0
                  Position = 0
                  Width = 73
                end>
            end
            object AlbenVST: TVirtualStringTree
              Tag = 2
              Left = 77
              Top = 0
              Width = 139
              Height = 140
              Align = alClient
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              Constraints.MinWidth = 20
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Header.AutoSizeIndex = 0
              Header.Background = clWindow
              Header.Height = 22
              Header.Options = [hoAutoResize, hoDrag, hoVisible]
              Images = DummyImageList
              IncrementalSearch = isAll
              Indent = 14
              Margin = 0
              ParentFont = False
              PopupMenu = Medialist_Browse_PopupMenu
              ScrollBarOptions.ScrollBars = ssVertical
              StyleElements = [seClient, seBorder]
              TabOrder = 1
              TextMargin = 2
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
              TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
              TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
              OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
              OnAfterItemErase = VSTAfterItemErase
              OnClick = AlbenVSTClick
              OnColumnDblClick = AlbenVSTColumnDblClick
              OnDragAllowed = AlbenVSTDragAllowed
              OnDrawText = AlbenVSTDrawText
              OnFocusChanged = AlbenVSTFocusChanged
              OnGetText = AlbenVSTGetText
              OnPaintText = ArtistsVSTPaintText
              OnGetImageIndex = AlbenVSTGetImageIndex
              OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
              OnIncrementalSearch = AlbenVSTIncrementalSearch
              OnKeyDown = StringVSTKeyDown
              OnMeasureItem = AlbenVSTMeasureItem
              OnResize = AlbenVSTResize
              OnStartDrag = AlbenVSTStartDrag
              Columns = <
                item
                  MinWidth = 0
                  Position = 0
                  Width = 139
                end>
            end
          end
          object PanelTagCloudBrowse: TNempPanel
            Tag = 2
            Left = 318
            Top = 46
            Width = 119
            Height = 160
            BevelOuter = bvNone
            TabOrder = 2
            Visible = False
            OnClick = PanelTagCloudBrowseClick
            OnResize = PanelTagCloudBrowseResize
            OnPaint = PanelPaint
            OwnerDraw = False
          end
        end
        object AuswahlHeaderPanel: TNempPanel
          Tag = 2
          Left = 0
          Top = 0
          Width = 540
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 1
          OnPaint = PanelPaint
          OwnerDraw = False
          DesignSize = (
            540
            28)
          object TabBtn_Preselection: TSkinButton
            Tag = 1
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            ParentShowHint = False
            PopupMenu = Medialist_Browse_PopupMenu
            ShowHint = True
            TabOrder = 0
            TabStop = False
            OnClick = TabBtn_PreselectionClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object TabBtn_Browse: TSkinButton
            Left = 30
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Browse your medialibrary'
            ParentShowHint = False
            PopupMenu = Medialist_Browse_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TABPanelAuswahlClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 3
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clPurple
            Color2 = clGreen
          end
          object TabBtn_CoverFlow: TSkinButton
            Tag = 1
            Left = 58
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Coverflow'
            ParentShowHint = False
            PopupMenu = Medialist_Browse_PopupMenu
            ShowHint = True
            TabOrder = 2
            OnClick = TABPanelAuswahlClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object AuswahlFillPanel: TNempPanel
            Tag = 2
            Left = 114
            Top = 2
            Width = 426
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = Medialist_Browse_PopupMenu
            TabOrder = 3
            OnPaint = TABPanelPaint
            OwnerDraw = False
            DesignSize = (
              426
              24)
            object AuswahlStatusLBL: TLabel
              Left = 10
              Top = 5
              Width = 410
              Height = 13
              Anchors = [akLeft, akTop, akRight, akBottom]
              AutoSize = False
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
              StyleElements = [seClient, seBorder]
              ExplicitWidth = 170
            end
          end
          object TabBtn_TagCloud: TSkinButton
            Tag = 2
            Left = 86
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Tag cloud'
            ParentShowHint = False
            PopupMenu = Medialist_Browse_PopupMenu
            ShowHint = True
            TabOrder = 4
            OnClick = TABPanelAuswahlClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 3
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
      end
      object PlaylistPanel: TNempPanel
        Tag = 1
        Left = 544
        Top = 0
        Width = 546
        Height = 240
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        OnResize = PlaylistPanelResize
        OwnerDraw = False
        object GRPBOXPlaylist: TNempPanel
          Tag = 1
          Left = 0
          Top = 28
          Width = 546
          Height = 212
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = PlayListPOPUP
          TabOrder = 1
          OnPaint = NewPanelPaint
          OwnerDraw = False
          object PlaylistVST: TVirtualStringTree
            Left = 2
            Top = 2
            Width = 542
            Height = 208
            Align = alClient
            BevelEdges = []
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Ctl3D = True
            DefaultPasteMode = amInsertAfter
            DragImageKind = diMainColumnOnly
            DragWidth = 10
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.AutoSizeIndex = 1
            Header.Background = clWindow
            Header.MainColumn = 1
            Header.Options = [hoAutoResize, hoDrag, hoVisible]
            Header.PopupMenu = PlaylistVST_HeaderPopup
            HintMode = hmHint
            Images = PlayListImageList
            Margin = 0
            ParentCtl3D = False
            ParentFont = False
            ParentShowHint = False
            PopupMenu = PlayListPOPUP
            ScrollBarOptions.ScrollBars = ssVertical
            ShowHint = True
            StyleElements = [seClient, seBorder]
            TabOrder = 0
            TextMargin = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking]
            TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
            OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
            OnAfterItemErase = VSTAfterItemErase
            OnAfterItemPaint = PlaylistVSTAfterItemPaint
            OnBeforeItemErase = VSTBeforeItemErase
            OnChange = PlaylistVSTChange
            OnCollapsed = PlaylistVSTCollapsAndExpanded
            OnColumnDblClick = PlaylistVSTColumnDblClick
            OnDragAllowed = PlaylistVSTDragAllowed
            OnDragOver = PlaylistVSTDragOver
            OnDragDrop = PlaylistVSTDragDrop
            OnEndDrag = VSTEndDrag
            OnExpanded = PlaylistVSTCollapsAndExpanded
            OnGetText = PlaylistVSTGetText
            OnPaintText = VSTPaintText
            OnGetImageIndex = PlaylistVSTGetImageIndex
            OnGetHint = PlaylistVSTGetHint
            OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
            OnKeyDown = PlaylistVSTKeyDown
            OnKeyUp = PlaylistVSTKeyUp
            OnResize = PlaylistVSTResize
            OnStartDrag = PlaylistVSTStartDrag
            Columns = <
              item
                Alignment = taRightJustify
                Margin = 0
                Position = 0
                Spacing = 0
                Width = 30
                WideText = '#'
              end
              item
                Position = 1
                Spacing = 0
                Width = 472
                WideText = 'Title'
              end
              item
                Alignment = taRightJustify
                Margin = 0
                Position = 2
                Spacing = 50
                Width = 40
                WideText = 'Time'
              end>
          end
        end
        object PlayerHeaderPanel: TNempPanel
          Tag = 1
          Left = 0
          Top = 0
          Width = 546
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          OnPaint = PanelPaint
          OwnerDraw = False
          DesignSize = (
            546
            28)
          object PlaylistFillPanel: TNempPanel
            Tag = 1
            Left = 129
            Top = 2
            Width = 417
            Height = 24
            Anchors = [akLeft, akTop, akRight]
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = PlayListPOPUP
            TabOrder = 3
            OnPaint = TABPanelPaint
            OwnerDraw = False
            DesignSize = (
              417
              24)
            object PlayListStatusLBL: TLabel
              Left = 10
              Top = 5
              Width = 400
              Height = 13
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              ShowAccelChar = False
              Transparent = True
              StyleElements = [seClient, seBorder]
              ExplicitWidth = 426
            end
          end
          object TabBtn_Playlist: TSkinButton
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = False
            OnClick = TabPanelPlaylistClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object EditPlaylistSearch: TEdit
            Left = 58
            Top = 3
            Width = 65
            Height = 21
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = 'Search'
            OnEnter = EditPlaylistSearchEnter
            OnExit = EditPlaylistSearchExit
            OnKeyDown = EditPlaylistSearchKeyDown
            OnKeyPress = EditPlaylistSearchKeyPress
          end
          object TabBtn_Favorites: TSkinButton
            Left = 28
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Favorite playlists'
            TabOrder = 1
            TabStop = False
            OnClick = TabBtn_FavoritesClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
      end
    end
    object _VSTPanel: TNempPanel
      Tag = 3
      Left = 0
      Top = 244
      Width = 1090
      Height = 405
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      OnResize = _TopMainPanelResize
      OwnerDraw = False
      object SubSplitter2: TSplitter
        Left = 607
        Top = 0
        Width = 4
        Height = 405
        Align = alRight
        MinSize = 50
        ResizeStyle = rsUpdate
        StyleElements = [seFont, seBorder]
        OnCanResize = SplitterFileOverviewCanResize
        OnMoved = SubSplitter2Moved
        ExplicitLeft = 720
        ExplicitHeight = 196
      end
      object MedialistPanel: TNempPanel
        Left = 0
        Top = 0
        Width = 607
        Height = 405
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = MedialistPanelResize
        OwnerDraw = False
        object MedienBibHeaderPanel: TNempPanel
          Tag = 3
          Left = 0
          Top = 0
          Width = 607
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 0
          OnPaint = PanelPaint
          OwnerDraw = False
          DesignSize = (
            607
            28)
          object EDITFastSearch: TEdit
            Left = 58
            Top = 3
            Width = 198
            Height = 21
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            PopupMenu = QuickSearchHistory_PopupMenu
            TabOrder = 2
            OnEnter = EDITFastSearchEnter
            OnExit = EDITFastSearchExit
            OnKeyPress = EDITFastSearchKeyPress
          end
          object MedienlisteFillPanel: TNempPanel
            Tag = 3
            Left = 262
            Top = 2
            Width = 339
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = Medialist_View_PopupMenu
            TabOrder = 3
            OnPaint = TABPanelPaint
            OwnerDraw = False
            DesignSize = (
              339
              23)
            object MedienListeStatusLBL: TLabel
              Left = 14
              Top = 5
              Width = 325
              Height = 13
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              ShowAccelChar = False
              Transparent = True
              StyleElements = [seClient, seBorder]
              ExplicitWidth = 326
            end
          end
          object TabBtn_Medialib: TSkinButton
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = False
            OnClick = TabPanelMedienlisteClick
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object TabBtn_Marker: TSkinButton
            Left = 28
            Top = 2
            Width = 24
            Height = 24
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = False
            OnClick = TabBtn_MarkerClick
            OnKeyPress = TabBtn_MarkerKeyPress
            OnMouseDown = TabBtn_MarkerMouseDown
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 5
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
        object GRPBOXVST: TNempPanel
          Tag = 3
          Left = 0
          Top = 28
          Width = 607
          Height = 377
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = False
          ParentDoubleBuffered = False
          PopupMenu = Medialist_View_PopupMenu
          TabOrder = 1
          OnPaint = NewPanelPaint
          OwnerDraw = False
          object VST: TVirtualStringTree
            Left = 2
            Top = 2
            Width = 603
            Height = 373
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Colors.SelectionTextColor = clWindowText
            Constraints.MinHeight = 26
            DragImageKind = diMainColumnOnly
            DragMode = dmAutomatic
            DragOperations = [doMove]
            DragWidth = 10
            EditDelay = 50
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.AutoSizeIndex = -1
            Header.Background = clWindow
            Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoRestrictDrag, hoShowSortGlyphs, hoVisible]
            Header.SortColumn = 0
            HintMode = hmHint
            IncrementalSearch = isAll
            Indent = 0
            Margin = 0
            ParentFont = False
            ParentShowHint = False
            PopupMenu = Medialist_View_PopupMenu
            ShowHint = True
            StyleElements = [seClient, seBorder]
            TabOrder = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
            TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
            OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
            OnAfterCellPaint = VSTAfterCellPaint
            OnAfterGetMaxColumnWidth = VSTAfterGetMaxColumnWidth
            OnAfterItemErase = VSTAfterItemErase
            OnBeforeItemErase = VSTBeforeItemErase
            OnChange = VSTChange
            OnColumnClick = VSTColumnClick
            OnColumnDblClick = VSTColumnDblClick
            OnCreateEditor = VSTCreateEditor
            OnEditCancelled = VSTEditCancelled
            OnEdited = VSTEdited
            OnEditing = VSTEditing
            OnEndDrag = VSTEndDrag
            OnFocusChanging = VSTFocusChanging
            OnGetText = VSTGetText
            OnPaintText = VSTPaintText
            OnGetImageIndex = VSTGetImageIndex
            OnGetHint = PlaylistVSTGetHint
            OnHeaderClick = VSTHeaderClick
            OnHeaderDblClick = VSTHeaderDblClick
            OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
            OnIncrementalSearch = VSTIncrementalSearch
            OnInitNode = VSTInitNode
            OnKeyDown = VSTKeyDown
            OnKeyUp = PlaylistVSTKeyUp
            OnNewText = VSTNewText
            OnStartDrag = VSTStartDrag
            Columns = <
              item
                Position = 0
                Width = 10
              end
              item
                Position = 1
              end
              item
                Position = 2
              end
              item
                Position = 3
              end
              item
                Position = 4
              end
              item
                Position = 5
              end
              item
                Position = 6
              end
              item
                Position = 7
              end
              item
                Position = 8
              end
              item
                Position = 9
              end
              item
                Position = 10
              end
              item
                Position = 11
              end
              item
                Position = 12
              end
              item
                Position = 13
              end
              item
                Position = 14
              end
              item
                Position = 15
              end
              item
                Position = 16
              end
              item
                Position = 17
              end
              item
                Position = 18
              end
              item
                Position = 19
              end
              item
                Position = 20
              end
              item
                Position = 21
              end
              item
                Position = 22
              end
              item
                Position = 23
              end
              item
                Position = 24
              end
              item
                Position = 25
              end
              item
                Position = 26
              end
              item
                Position = 27
              end>
          end
        end
      end
      object MedienBibDetailPanel: TNempPanel
        Left = 611
        Top = 0
        Width = 479
        Height = 405
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        OnResize = MedienBibDetailPanelResize
        OwnerDraw = False
        object ContainerPanelMedienBibDetails: TNempPanel
          Left = 0
          Top = 28
          Width = 479
          Height = 377
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          OwnerDraw = False
          object SplitterFileOverview: TSplitter
            Left = 248
            Top = 0
            Width = 4
            Height = 377
            ResizeStyle = rsUpdate
            StyleElements = [seFont, seBorder]
            OnCanResize = SplitterFileOverviewCanResize
            OnMoved = SplitterFileOverviewMoved
            ExplicitLeft = 250
            ExplicitTop = 4
            ExplicitHeight = 279
          end
          object DetailCoverLyricsPanel: TNempPanel
            Tag = 3
            Left = 0
            Top = 0
            Width = 248
            Height = 377
            Align = alLeft
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = PopupEditExtendedTags
            TabOrder = 0
            OnResize = DetailID3TagPanelResize
            OnPaint = NewPanelPaint
            OwnerDraw = False
            DesignSize = (
              248
              377)
            object ImgDetailCover: TImage
              Left = 4
              Top = 8
              Width = 240
              Height = 359
              Anchors = [akLeft, akTop, akRight, akBottom]
              Proportional = True
              Stretch = True
              OnDblClick = ImgDetailCoverDblClick
              OnMouseDown = ImgDetailCoverMouseDown
              OnMouseMove = ImgDetailCoverMouseMove
            end
            object LyricsMemo: TMemo
              Left = 4
              Top = 6
              Width = 240
              Height = 359
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelInner = bvNone
              BevelOuter = bvNone
              BorderStyle = bsNone
              PopupMenu = Player_PopupMenu
              ReadOnly = True
              TabOrder = 0
              Visible = False
              StyleElements = [seBorder]
              OnKeyDown = LyricsMemoKeyDown
            end
          end
          object DetailID3TagPanel: TNempPanel
            Tag = 3
            Left = 252
            Top = 0
            Width = 227
            Height = 377
            Align = alClient
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = PopupEditExtendedTags
            TabOrder = 1
            OnResize = DetailID3TagPanelResize
            OnPaint = NewPanelPaint
            OwnerDraw = False
            DesignSize = (
              227
              377)
            object ImgBibRating: TImage
              Left = 8
              Top = 129
              Width = 70
              Height = 14
              Hint = 'Click to change rating'
              Visible = False
              OnMouseDown = ImgBibRatingMouseDown
              OnMouseLeave = ImgBibRatingMouseLeave
              OnMouseMove = ImgBibRatingMouseMove
            end
            object LblBibAlbum: TLabel
              Tag = 2
              Left = 8
              Top = 42
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
              OnDblClick = DetailLabelDblClick
              OnMouseEnter = DetailLabelMouseOver
              OnMouseLeave = DetailLabelMouseLeave
            end
            object LblBibArtist: TLabel
              Left = 8
              Top = 8
              Width = 54
              Height = 13
              Caption = '                  '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
              OnDblClick = DetailLabelDblClick
              OnMouseEnter = DetailLabelMouseOver
              OnMouseLeave = DetailLabelMouseLeave
            end
            object LblBibDuration: TLabel
              Left = 8
              Top = 93
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object LblBibGenre: TLabel
              Tag = 5
              Left = 8
              Top = 76
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
              OnDblClick = DetailLabelDblClick
              OnMouseEnter = DetailLabelMouseOver
              OnMouseLeave = DetailLabelMouseLeave
            end
            object LblBibPlayCounter: TLabel
              Left = 84
              Top = 129
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object LblBibQuality: TLabel
              Left = 8
              Top = 110
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object LblBibTitle: TLabel
              Tag = 1
              Left = 8
              Top = 25
              Width = 54
              Height = 13
              Caption = '                  '
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object LblBibYear: TLabel
              Tag = 4
              Left = 8
              Top = 59
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
              OnDblClick = DetailLabelDblClick
              OnMouseEnter = DetailLabelMouseOver
              OnMouseLeave = DetailLabelMouseLeave
            end
            object Bevel1: TBevel
              Left = 8
              Top = 206
              Width = 209
              Height = 5
              Anchors = [akLeft, akTop, akRight]
              Shape = bsBottomLine
            end
            object LblBibReplayGain: TLabel
              Left = 9
              Top = 149
              Width = 54
              Height = 13
              Hint = 'ReplayGain values'
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object lblBibFilename: TLabel
              Left = 8
              Top = 174
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object lblBibDirectory: TLabel
              Tag = 6
              Left = 8
              Top = 189
              Width = 54
              Height = 13
              Caption = '                  '
              ShowAccelChar = False
              StyleElements = [seClient, seBorder]
            end
            object Bevel2: TBevel
              Left = 9
              Top = 165
              Width = 209
              Height = 5
              Anchors = [akLeft, akTop, akRight]
              Shape = bsBottomLine
            end
          end
        end
        object MedienBibDetailHeaderPanel: TNempPanel
          Tag = 3
          Left = 0
          Top = 0
          Width = 479
          Height = 28
          Align = alTop
          BevelOuter = bvNone
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
          OnPaint = PanelPaint
          OwnerDraw = False
          DesignSize = (
            479
            28)
          object MedienBibDetailFillPanel: TNempPanel
            Tag = 3
            Left = 58
            Top = 3
            Width = 415
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            BevelInner = bvRaised
            BevelOuter = bvLowered
            PopupMenu = Medialist_View_PopupMenu
            TabOrder = 2
            StyleElements = [seClient, seBorder]
            OnPaint = TABPanelPaint
            OwnerDraw = False
            object MedienBibDetailStatusLbl: TLabel
              Left = 14
              Top = 4
              Width = 63
              Height = 13
              Caption = 'File overview'
              StyleElements = [seClient, seBorder]
            end
          end
          object TabBtn_Cover: TSkinButton
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Toggle Cover/Lyrics'
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = PlayerTabsClick
            OnMouseMove = TabBtn_CoverMouseMove
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object TabBtn_SummaryLock: TSkinButton
            Tag = 2
            Left = 28
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Toggle File Overview (player only vs. selected file)'
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TabBtn_SummaryLockClick
            OnMouseMove = TabBtn_CoverMouseMove
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
      end
    end
    object _ControlPanel: TNempPanel
      Left = 0
      Top = 649
      Width = 1090
      Height = 100
      Align = alBottom
      BevelOuter = bvNone
      PopupMenu = Player_PopupMenu
      TabOrder = 2
      OnMouseMove = _ControlPanelMouseMove
      OnResize = _ControlPanelResize
      OwnerDraw = False
      object ControlContainer2: TNempPanel
        Left = 481
        Top = 0
        Width = 609
        Height = 100
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        OwnerDraw = False
        object NewPlayerPanel: TNempPanel
          Tag = 4
          Left = 0
          Top = 0
          Width = 609
          Height = 100
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = Player_PopupMenu
          TabOrder = 0
          OnDragOver = GRPBOXControlDragOver
          OnMouseDown = PaintFrameMouseDown
          OnMouseMove = PaintFrameMouseMove
          OnMouseUp = PaintFrameMouseUp
          OnResize = NewPlayerPanelResize
          OnPaint = ControlPanelPaint
          OwnerDraw = False
          DesignSize = (
            609
            100)
          object SlideBarShape: TProgressShape
            Left = 100
            Top = 78
            Width = 451
            Height = 6
            Anchors = [akLeft, akTop, akRight]
            Brush.Color = clGradientActiveCaption
            DragCursor = crSizeWE
            Shape = stRoundRect
            OnDragOver = GRPBOXControlDragOver
            OnMouseDown = SlideBarShapeMouseDown
            OnMouseEnter = SlideBarShapeMouseEnter
            OnMouseLeave = SlideBarShapeMouseLeave
            ProgressPen.Color = 12678971
            ProgressBrush.Color = clMaroon
            Progress = 0.500000000000000000
          end
          object RatingImage: TImage
            Left = 11
            Top = 45
            Width = 70
            Height = 14
            OnDragOver = GRPBOXControlDragOver
            OnMouseDown = RatingImageMouseDown
            OnMouseLeave = RatingImageMouseLeave
            OnMouseMove = RatingImageMouseMove
          end
          object ab2: TImage
            Left = 200
            Top = 57
            Width = 20
            Height = 22
            Hint = 'A-B Repeat'
            DragCursor = crSizeWE
            DragMode = dmAutomatic
            PopupMenu = PopupRepeatAB
            Proportional = True
            Stretch = True
            Visible = False
            OnDragOver = GRPBOXControlDragOver
            OnEndDrag = ab1EndDrag
            OnStartDrag = ab1StartDrag
          end
          object PlayerTimeLbl: TLabel
            Left = 566
            Top = 74
            Width = 34
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = '00:00'
            StyleElements = [seClient, seBorder]
            OnClick = BassTimeLBLClick
            OnDragOver = GRPBOXControlDragOver
            ExplicitLeft = 767
          end
          object ab1: TImage
            Left = 156
            Top = 57
            Width = 20
            Height = 22
            Hint = 'A-B Repeat'
            DragCursor = crSizeWE
            DragMode = dmAutomatic
            PopupMenu = PopupRepeatAB
            Proportional = True
            Stretch = True
            Visible = False
            OnDragOver = GRPBOXControlDragOver
            OnEndDrag = ab1EndDrag
            OnStartDrag = ab1StartDrag
          end
          object PaintFrame: TImage
            Left = 525
            Top = 34
            Width = 75
            Height = 25
            Anchors = [akRight]
            OnClick = NewPlayerPanelClick
            OnDblClick = PaintFrameDblClick
            OnDragOver = GRPBOXControlDragOver
            OnMouseDown = PaintFrameMouseDown
            OnMouseMove = PaintFrameMouseMove
            OnMouseUp = PaintFrameMouseUp
            ExplicitLeft = 386
          end
          object PlayerTitleLabel: TLabel
            Left = 11
            Top = 26
            Width = 9
            Height = 13
            Caption = '...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
            StyleElements = [seClient, seBorder]
            OnDblClick = PlayerArtistLabelDblClick
            OnDragOver = GRPBOXControlDragOver
          end
          object PlayerArtistLabel: TLabel
            Left = 11
            Top = 6
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            StyleElements = [seClient, seBorder]
            OnDblClick = PlayerArtistLabelDblClick
            OnDragOver = GRPBOXControlDragOver
          end
          object SlideBarButton: TSkinButton
            Left = 303
            Top = 76
            Width = 25
            Height = 10
            DragCursor = crSizeWE
            DragMode = dmAutomatic
            TabOrder = 3
            Visible = False
            OnDragOver = GRPBOXControlDragOver
            OnEndDrag = SlideBarButtonEndDrag
            OnKeyDown = SlideBarButtonKeyDown
            OnStartDrag = SlideBarButtonStartDrag
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = True
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
            AcceptArrowKeys = True
          end
          object SlideForwardBTN: TSkinButton
            Tag = 1
            Left = 58
            Top = 69
            Width = 22
            Height = 22
            Hint = 'Slide forward'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = SlideForwardBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object SlideBackBTN: TSkinButton
            Tag = -1
            Left = 37
            Top = 69
            Width = 22
            Height = 22
            Hint = 'Slide backward'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = SlideBackBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object RecordBtn: TSkinButton
            Left = 11
            Top = 69
            Width = 20
            Height = 20
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Visible = False
            OnClick = RecordBtnIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object BtnClose: TSkinButton
            Left = 591
            Top = 4
            Width = 12
            Height = 12
            Hint = 'Close Nemp'
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            TabStop = False
            Visible = False
            OnClick = BtnCloseClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object BtnMinimize: TSkinButton
            Left = 576
            Top = 4
            Width = 12
            Height = 12
            Hint = 'Minimize Nemp'
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            TabStop = False
            Visible = False
            OnClick = BtnMinimizeClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
      end
      object ControlContainer1: TNempPanel
        Left = 0
        Top = 0
        Width = 481
        Height = 100
        Align = alLeft
        BevelOuter = bvNone
        PopupMenu = Player_PopupMenu
        TabOrder = 0
        OnMouseDown = PaintFrameMouseDown
        OnMouseMove = PaintFrameMouseMove
        OnMouseUp = PaintFrameMouseUp
        OwnerDraw = False
        object HeadsetControlPanel: TNempPanel
          Tag = 3
          Left = 305
          Top = 0
          Width = 165
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 3
          OnClick = HeadsetControlPanelClick
          OnDragOver = GRPBOXControlDragOver
          OnPaint = ControlPanelPaint
          OwnerDraw = False
          OnMouseWheelUp = HeadsetControlPanelMouseWheelUp
          OnMouseWheelDown = HeadsetControlPanelMouseWheelDown
          object VolShapeHeadset: TShape
            Left = 37
            Top = 78
            Width = 117
            Height = 6
            Brush.Color = clGradientActiveCaption
            DragCursor = crSizeNS
            Shape = stRoundRect
            OnDragOver = GRPBOXControlDragOver
          end
          object VolumeImageHeadset: TImage
            Left = 9
            Top = 73
            Width = 20
            Height = 18
            OnDragOver = GRPBOXControlDragOver
          end
          object lblHeadphoneControl: TLabel
            Left = 8
            Top = 6
            Width = 98
            Height = 13
            Caption = 'Headphone Controls'
            StyleElements = [seClient, seBorder]
            OnDragOver = GRPBOXControlDragOver
          end
          object VolButtonHeadset: TSkinButton
            Left = 47
            Top = 76
            Width = 25
            Height = 10
            Hint = 'Volume'
            DragCursor = crSizeWE
            DragMode = dmAutomatic
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnDragOver = GRPBOXControlDragOver
            OnEndDrag = VolButtonEndDrag
            OnKeyDown = VolButtonHeadsetKeyDown
            OnStartDrag = VolButton_HeadsetStartDrag
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = True
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
            AcceptArrowKeys = True
          end
          object PlayPauseHeadSetBtn: TSkinButton
            Left = 5
            Top = 25
            Width = 32
            Height = 32
            TabOrder = 1
            OnClick = PLayPauseBtnHeadsetClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object StopHeadSetBtn: TSkinButton
            Left = 37
            Top = 31
            Width = 20
            Height = 20
            TabOrder = 2
            OnClick = StopHeadSetBtnClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object BtnLoadHeadset: TSkinButton
            Left = 74
            Top = 48
            Width = 24
            Height = 24
            Hint = 'Load selected file into headset (Ctrl+H)'
            TabOrder = 3
            Visible = False
            OnClick = BtnLoadHeadsetClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object BtnHeadsetToPlaylist: TSkinButton
            Left = 131
            Top = 29
            Width = 24
            Height = 24
            Hint = 'Add current file to playlist (Right click for options)'
            PopupMenu = PopupHeadset
            TabOrder = 4
            OnClick = BtnHeadsetToPlaylistClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object BtnHeadsetPlaynow: TSkinButton
            Left = 104
            Top = 29
            Width = 24
            Height = 24
            Hint = 'Add file to playlist and begin playback from current position'
            TabOrder = 5
            OnClick = BtnHeadsetPlaynowClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
        object PlayerControlCoverPanel: TNempPanel
          Tag = 2
          Left = 40
          Top = 0
          Width = 100
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          OnPaint = ControlPanelPaint
          OwnerDraw = False
          object CoverImage: TImage
            Left = 6
            Top = 6
            Width = 88
            Height = 88
            Center = True
            PopupMenu = Player_PopupMenu
            Proportional = True
            Stretch = True
            OnDblClick = CoverImageDblClick
            OnMouseDown = ImgDetailCoverMouseDown
            OnMouseMove = ImgDetailCoverMouseMove
          end
        end
        object OutputControlPanel: TNempPanel
          Tag = 1
          Left = 0
          Top = 0
          Width = 40
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = PlayListPOPUP
          TabOrder = 0
          OnPaint = ControlPanelPaint
          OwnerDraw = False
          object TabBtn_MainPlayerControl: TSkinButton
            Tag = 4
            Left = 8
            Top = 8
            Width = 24
            Height = 24
            Hint = 'Show main player controls'
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = TabBtn_MainPlayerControlClick
            OnMouseMove = TabBtn_CoverMouseMove
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object TabBtn_Equalizer: TSkinButton
            Tag = 3
            Left = 8
            Top = 68
            Width = 24
            Height = 24
            Hint = 'Show equalizer and effect controls'
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 2
            OnClick = TabBtn_EqualizerClick
            OnMouseMove = TabBtn_CoverMouseMove
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object TabBtn_Headset: TSkinButton
            Tag = 5
            Left = 8
            Top = 38
            Width = 24
            Height = 24
            Hint = 'Show headset controls'
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TabBtn_HeadsetClick
            OnMouseMove = TabBtn_CoverMouseMove
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
        end
        object PlayerControlPanel: TNempPanel
          Tag = 3
          Left = 140
          Top = 0
          Width = 165
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 2
          OnClick = PlayerControlPanelClick
          OnDragOver = GRPBOXControlDragOver
          OnPaint = ControlPanelPaint
          OwnerDraw = False
          OnMouseWheelUp = PlayerControlPanelMouseWheelUp
          OnMouseWheelDown = PlayerControlPanelMouseWheelDown
          object VolShape: TShape
            Left = 37
            Top = 78
            Width = 117
            Height = 6
            Brush.Color = clGradientActiveCaption
            DragCursor = crSizeNS
            Shape = stRoundRect
            OnDragOver = GRPBOXControlDragOver
          end
          object VolumeImage: TImage
            Left = 9
            Top = 73
            Width = 20
            Height = 18
            OnDragOver = GRPBOXControlDragOver
          end
          object WalkmanImage: TImage
            Left = 88
            Top = 4
            Width = 16
            Height = 16
            Hint = 'Low battery. Click for more information.'
            ParentShowHint = False
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              0000100000000100180000000000000300000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              0000000000FFFFFFCED6DFA7B3C6AAB3CAA7B2CCA2B0CBA3B2CBA5B3CBA3B0C9
              A5B0C79FAECA91A7C9C4CEDBFFFFFF000000000000FFFFFF5F90C90D6BD31076
              D72186D83A96D9459CD9469CD94298D7298AD5137AD90072E26496C9FFFFFF00
              0000000000FFFFFF96B5DC0072E70088FF159EFF2FB3FF79D3FF8BDBFF3CB8FF
              20A5FF0B9BFF007EEC99B6D9FFFFFF000000000000FFFFFFF4EFEE679FD40988
              F50787FC0082FC80C2FAA8D8FA038CFC0A8CFD008DFB3A86D1F1EDECFFFFFF00
              0000000000FFFFFFFFFFFFC7D3E33693DC26A2FC007DFC3A9EFB55ADFA0074FD
              028CFE0887EDA6B5CFFFFFFFFFFFFF000000000000FFFFFFF8FAFCFBF9F979A7
              D1369EEA0C8AF0B3DAFAEDEEFA0059F0008DFF4689CBFDFAF8FDFEFEFFFFFF00
              0000000000FFFFFFFAFBFCFFFFFFD7DEE84B97D71A8DE7AAD4F3D9E7F90277F7
              0780E9C3CEDDFFFFFFFCFDFEFFFFFF000000000000FFFFFFFFFFFFFDFDFDFFFF
              FF90B2D22892E1A0CFF0C3E6FB0898FA6EA7D4F9F7F7FCFDFEFDFDFDFFFFFF00
              0000000000FFFFFFFEFEFEFDFDFDFEFEFEE7EBF14E94CE4FACEF41B1FD359BE3
              CBD4E1FFFFFFFBFCFDFEFEFEFFFFFF000000000000FFFFFFFFFFFFFEFEFEFCFD
              FEFDFDFDA2BFDB3EA3EC3CB2FD7CABD8FCFAFAFBFCFDFEFEFDFFFFFFFFFFFF00
              0000000000FFFFFFFFFFFFFFFFFFFCFDFDFDFEFEE5E8F060ACE54BA7E7DADEE6
              FEFFFFFCFDFDFFFFFFFEFEFEFFFFFF000000000000FFFFFFFFFFFFFFFFFFFEFE
              FEFCFDFDFFFFFFC2D8EDADC8E2FFFFFFFDFDFDFEFEFEFEFEFEFFFFFFFFFFFF00
              0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000}
            Proportional = True
            ShowHint = True
            Stretch = True
            Visible = False
            OnClick = WalkmanImageClick
            OnDragOver = GRPBOXControlDragOver
          end
          object WebserverImage: TImage
            Left = 66
            Top = 4
            Width = 16
            Height = 16
            Hint = 'Nemp Webserver'
            ParentShowHint = False
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              0000100000000100180000000000000300000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF0040C51544FF0550FF304E8CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF194CBE004DFF004EE7586D98
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF7896D20051DC0042B69B9FC9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
              0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8193B20042BC00369ABAC1CA
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFC07931FFFFFFFFFF
              FFFFFFFFADB6CD003896002F80FFFFFFFFFFFFFFFFFFFFFFFFC07931FFFFFF00
              0000000000CC9059FFC995FFFFFFFFFFFFFFFFFFFFFFFF00306C002967FFFFFF
              FFFFFFFFFFFFFFFFFFFFC995CC9059000000000000D58E43FFFFFFFFFFFFD488
              3AFFFFFFFFFFFF0028520B284FFFFFFFFFFFFFD4883AFFFFFFFFFFFFD58E4300
              0000C29F7DFFD2A2FFFFFFE6BE94E6CBAEFFFFFFFFFFFF001E3B304459FFFFFF
              FFFFFFE6CBAEE6BE94FFFFFFFFD2A2C29F7DC08A56FFD19BFFFFFFC37523FFFF
              FFFFFFFF6783B9265EF81F57E78DA4CEFFFFFFFFFFFFC37523FFFFFFFFD19BC0
              8A56BF8853FFD09BFFFFFFC47622FFFFFFFFFFFF3C5ACB2960FE0051F396AACD
              FFFFFFFFFFFFC47622FFFFFFFFD09BBF8853C29A73FFD09DFFFFFFE8B989E6C7
              A6FFFFFFFFFFFF2851CD144FD0FFFFFFFFFFFFE6C7A6E8B989FFFFFFFFD09DC2
              9A73000000D5944CFFFFFFFFFFFFC88039FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFC88039FFFFFFFFFFFFD5944C000000000000D9914FFFDDBBFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDBBD9914F00
              0000000000FFFFFFC27C37FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFC27C37FFFFFF0000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000}
            Proportional = True
            ShowHint = True
            Stretch = True
            OnClick = ToolImageClick
            OnDblClick = MM_T_WebServerOptionsClick
            OnDragOver = GRPBOXControlDragOver
          end
          object SleepImage: TImage
            Left = 44
            Top = 4
            Width = 16
            Height = 16
            ParentShowHint = False
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              0000100000000100180000000000000300000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              000000000000000000000000000000000000000000FFFFFFFFFFFFE2CDBCD48A
              52D3763BDE875AEF9B74F19D77E18B5FD3773FCF874FE2CDBBFFFFFFFFFFFF00
              0000000000FFFFFFD7B7A1CB692B9E3E108B300BA1431CB3532BB6552DA64821
              9035109A3A0EC16125D7B6A0FFFFFF000000000000E0CBBFC26229822C07751A
              00802501A76449C99A86CA9B87A9664A812602771B007F2905B45722E0CABF00
              0000000000C2754C7E320E5D130081371DDFC7BEFFFFFFFEFFFFFEFEFFFFFFFF
              DFC8BF83371D611400742B09B66D46000000000000A04C1F4A13005D1D09E0D1
              CBFEFEFEAB7C6A80341B81341AAB7C6AFDFEFEE0D2CB5F1E094A12008B3F1700
              00000000007032132D0200876657FFFFFF9F76665A08006A1A006C1B005F0A00
              A47865FFFFFF8A675730020059250C00000000000051220C360600B79D92FFFF
              FF9144248B320F913610923711903611984827FFFFFFC4A3955E160161260B00
              00000000009743198B2D06CFA28FFFFFFFB26443A14219B1603EB1613FA24219
              B36645FFFFFFD1A49197350BA6481B000000000000C06230A3451EBF795BFFFF
              FFDEB9A9B15129EFDBD3EFDBD2B45730E4C5B7FEFFFFC0785AA74A23B75C2F00
              0000000000D3794AC96F48C86A43EDC9BAFFFFFFFEA581F7E4DDF7E6DFFEA581
              FFFFFFE9BEABCB6C45CC724CCB7246000000000000C0785FF39C71E88B64E990
              6AF8C4AFFEA581FCEBE4FCECE5FEA581F7BEA6EA8D65EB8E68F49C72BB745D00
              0000000000D9C2C2E29068FFB691FEA885FDA27EFEA682FFEFE9FFEFE9FEA581
              FDA480FFAA88FFB793DD8A66D8C2C2000000000000FFFFFFC9A7A4DF9B79FFCE
              B2FFC8AFFFC2A9FFCCB7FFCCB7FFC2A9FFC9B1FFCFB4DB9778C8A5A3FFFFFF00
              0000000000FFFFFFFFFFFFD7C0BFC28776ECB89EFFD6C0FFDBC7FFDCC7FFD6C1
              EAB69EBF8575D7BFBFFFFFFFFFFFFF0000000000000000000000000000000000
              0000000000000000000000000000000000000000000000000000000000000000
              0000}
            Proportional = True
            ShowHint = True
            Stretch = True
            OnClick = ToolImageClick
            OnDragOver = GRPBOXControlDragOver
          end
          object BirthdayImage: TImage
            Left = 22
            Top = 3
            Width = 16
            Height = 16
            ParentShowHint = False
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              0000100000000100180000000000000300000000000000000000000000000000
              000000000000000000000000000089E2F757D6F330CDF116C7EF16C7EF30CDF1
              57D6F389E2F7000000000000000000000000000000FFFFFF78DEF614C6EF47D3
              F360D9F473DEF680E1F780E1F773DEF660D9F447D3F314C6EF78DEF6FFFFFF00
              000000000066DAF44FD5F381E1F786E2F786E2F786E2F786E2F786E2F786E2F7
              86E2F786E2F781E1F74FD5F366DAF400000000000013C6EF82E1F775BEF1659A
              EB577CE64C63E24554E04554E04C63E2577CE6659AEB75BEF182E1F713C6EF00
              000000000016B4ED5F8FEA5372E56396EB71B4F07CCDF483DCF683DCF67CCDF4
              71B4F06396EB5372E55F8FEA16B4ED0000000000002C80E667A0EC89DCF4C2E3
              EBA4E2F186E2F786E2F786E2F78DE2F6A8E3F08CE2F583DCF667A0EC2C80E600
              00000000000FC5EF84E1F7D7DBDCECECECE7E7E7DFE2E3E3E4E4E3E4E4E3E3E3
              EBEBEBDCDFE09BE1F184E1F70FC5EF00000000000073CEE3D7D9DAE3E3E3FFFF
              FFFFFFFFFCFCFCE7B098E39E78EDC2B2FFFFFFEEEEEED6D8D9B5DEE82BC7EB00
              0000000000B5C2C5FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFE5A47EE9B493E3A278
              FFFFFFFFFFFFFDFDFDEAEAEA7DC9DB000000000000BEC2C3FCFCFCEEC1A6EAB2
              92F1CEBBFFFFFFE6AA85EAB898E5A57FFFFFFFE8AF98E39D76EABEAFBAC3C500
              0000000000CDD8DBE3E3E3EBB999EEC3AAEBB495FFFFFF94B3A155BFBC86B1A0
              FFFFFFE5A37BE9B292DE9A72CDD8DB000000000000FFFFFFDDDDDDEDBB9DEFC8
              AFE8B696F6F6F607D2D867F5F607D2D7ECECECE5A983EAB798DD9D74FFFFFF00
              0000000000FFFFFFFFFFFF97BCAD57C4C386B7AACACACA07D2D930F1F368C2C9
              D4D4D494B19F55BFBC85AF9EFFFFFF000000000000FFFFFFFFFFFF07D2D867F5
              F606D2D8FFFFFFFFFFFF38D3DCFFFFFFFFFFFF07D2D867F5F606D1D7FFFFFF00
              0000000000FFFFFFFFFFFF08D4DB30F1F383DDE3FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFF08D4DB30F1F383DDE3FFFFFF00000000000000000000000000000038D3
              DC00000000000000000000000000000000000000000038D3DC00000000000000
              0000}
            Proportional = True
            ShowHint = True
            Stretch = True
            OnClick = ToolImageClick
            OnDblClick = PM_P_BirthdayOptionsClick
            OnDragOver = GRPBOXControlDragOver
          end
          object ScrobblerImage: TImage
            Left = 9
            Top = 3
            Width = 15
            Height = 16
            Hint = 'Nemp LastFM Scrobbler'
            ParentShowHint = False
            Picture.Data = {
              07544269746D617036030000424D360300000000000036000000280000001000
              000010000000010018000000000000030000C40E0000C40E0000000000000000
              00009C9C9C2E319E060992060992060992060992060992060992060992060992
              0609920609920609920609922E319E9C9C9C3134A3080D9F0B12AF0D15B90D15
              B90D15B90D15B90D15B90D15B90D15B90D15B90D15B90D15B90B12AF080D9F31
              34A3090EA20E16B51019BE1019BE1019BE1019BE1019BE1019BE1019BE1019BE
              1019BE1019BE1019BE1019BE0E16B5090EA20B11AA121DC3121DC3151DC31B24
              C3161FC3121DC3121DC3121DC3121DC31C25C32029C31F28C3121DC3121DC30B
              11AA0D14B11521C68C8FCFFCFCFEFFFFFFFFFFFFD4D5ED1D24C65055C6DFE0F1
              FFFFFFFFFFFFFFFFFFE2E3F23C41C60D14B10E17B95B60C6FFFFFFA1A4D5151D
              96252C9D969AD72D34C1F6F7FBCCCDE8242C9B0F1795272E98F9F9FCA7AADA0E
              17B7111AC0A2A6D9FFFFFF1C27BD1927C61825C0121DB69A9ED5FCFCFE353DB1
              1825BD2833C5565EC1FFFFFF9499D6101AB8121DC7B1B5E0EEEFF81A2BC91C2D
              D51C2DD41929C2E6E7F4C7CAE73741BFD5D7EEFFFFFFFFFFFFACB0E02C37C112
              1DBE1521CE9A9FDAFCFCFE2B38CF1F31DA1F31DA565FCEFFFFFF7980CBACB1DF
              F7F7FB6870C52E3ABB1826BA1D2ECE1521CD1725D43B4AD3FFFFFFB6BAE3303E
              DE3848DDDCDEF1ECEDF81F30BFABB1E1E9EAF63945CC4754D2E4E6F67983DC17
              25D41A28DB2236D77580D8F4F5FBFFFFFFFFFFFFD9DCF24E5DD02034CF3F4FD0
              DFE1F4FFFFFFFFFFFFE2E4F53F4FD91A28DB1C2CE2263DE61F32BD1C2CA82635
              A72A3BB71E30B72135CB243ADD1F31BE1B2BA52837A62837A91F31BA253BE21C
              2CE21F30E72941EB283FE5273EE0273DDF273DDF273EE0283FE52940EA283FE5
              273EE0273DDF273EE0283FE52941EB1F30E72135EE4459F22B45F12B45F12B45
              F12B45F12B45F12B45F12B45F12B45F12B45F12B45F12B45F12B45F14459F221
              35EE5263ED3E51F66375F96577F96577F96577F96577F96577F96577F96577F9
              6577F96577F96577F96375F93E51F65263ED9C9C9C5466F1263EF9263EF9263E
              F9263EF9263EF9263EF9263EF9263EF9263EF9263EF9263EF9263EF95466F19C
              9C9C}
            Proportional = True
            ShowHint = True
            Stretch = True
            OnClick = ToolImageClick
            OnDblClick = PM_P_ScrobblerOptionsClick
            OnDragOver = GRPBOXControlDragOver
          end
          object PlayPauseBTN: TSkinButton
            Left = 5
            Top = 25
            Width = 32
            Height = 32
            Hint = 'Play/Pause'
            PopupMenu = PopupPlayPause
            TabOrder = 0
            OnClick = PlayPauseBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object StopBTN: TSkinButton
            Left = 37
            Top = 31
            Width = 20
            Height = 20
            Hint = 'Stop'
            PopupMenu = PopupStop
            TabOrder = 1
            OnClick = StopBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 2
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object PlayPrevBTN: TSkinButton
            Left = 72
            Top = 31
            Width = 22
            Height = 22
            Hint = 'Previous title'
            Spacing = 14
            TabOrder = 2
            OnClick = PlayPrevBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object PlayNextBTN: TSkinButton
            Left = 93
            Top = 31
            Width = 22
            Height = 22
            Hint = 'Next title'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = PlayNextBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object RandomBtn: TSkinButton
            Left = 126
            Top = 28
            Width = 28
            Height = 28
            ParentShowHint = False
            PopupMenu = PopupRepeat
            ShowHint = True
            TabOrder = 4
            OnClick = RepeatBitBTNIMGClick
            OnDragOver = GRPBOXControlDragOver
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 4
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object VolButton: TSkinButton
            Left = 74
            Top = 76
            Width = 25
            Height = 10
            Hint = 'Volume'
            DragCursor = crSizeWE
            DragMode = dmAutomatic
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnDragOver = GRPBOXControlDragOver
            OnEndDrag = VolButtonEndDrag
            OnKeyDown = VolButtonKeyDown
            OnStartDrag = VolButtonStartDrag
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = True
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
            AcceptArrowKeys = True
          end
        end
      end
    end
  end
  object BassTimer: TTimer
    Enabled = False
    Interval = 20
    OnTimer = BassTimerTimer
    Left = 512
    Top = 280
  end
  object Nemp_MainMenu: TMainMenu
    AutoHotkeys = maManual
    Images = MenuImages
    Left = 40
    Top = 80
    object MM_Medialibrary: TMenuItem
      Caption = '&Media library'
      OnClick = MM_MedialibraryClick
      object MM_ML_SearchDirectory: TMenuItem
        Caption = '&Scan hard disk for audio files'
        ImageIndex = 3
        ShortCut = 16462
        OnClick = MM_ML_SearchDirectoryClick
      end
      object MM_ML_Webradio: TMenuItem
        Caption = 'Manage webradio stations'
        ShortCut = 16471
        OnClick = MM_ML_WebradioClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object MM_ML_BrowseBy: TMenuItem
        Caption = '&Browse by'
        object MM_ML_BrowseByArtistAlbum: TMenuItem
          Caption = 'Artists - Albums'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByAlbumArtists: TMenuItem
          Tag = 6
          Caption = 'Album - Artists'
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByDirectoryArtist: TMenuItem
          Tag = 1
          Caption = 'Directories - Artists'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByDirectoryAlbum: TMenuItem
          Tag = 2
          Caption = 'Directories - Albums'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByGenreArtist: TMenuItem
          Tag = 3
          Caption = 'Genres - Artists'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByGenreYear: TMenuItem
          Tag = 4
          Caption = 'Genres - Years'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByYearArtist: TMenuItem
          Tag = 7
          Caption = 'Year - Artist'
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByFileageAlbum: TMenuItem
          Tag = 8
          Caption = 'Fileage - Album'
          OnClick = SortierAuswahl1POPUPClick
        end
        object MM_ML_BrowseByFileageArtist: TMenuItem
          Tag = 9
          Caption = 'Fileage - Artist'
          OnClick = SortierAuswahl1POPUPClick
        end
        object N29: TMenuItem
          Caption = '-'
        end
        object MM_ML_BrowseByMore: TMenuItem
          Tag = 100
          Caption = 'More...'
          RadioItem = True
          OnClick = PM_ML_BrowseByMoreClick
        end
      end
      object MM_ML_Search: TMenuItem
        Caption = 'Search'
        ImageIndex = 10
        ShortCut = 24646
        OnClick = MM_ML_SearchClick
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object MM_ML_Load: TMenuItem
        Caption = '&Load'
        ImageIndex = 0
        OnClick = MM_ML_LoadClick
      end
      object MM_ML_Save: TMenuItem
        Caption = 'Sa&ve'
        ImageIndex = 1
        OnClick = MM_ML_SaveClick
      end
      object MM_ML_ExportAsCSV: TMenuItem
        Caption = '&Export as csv'
        ShortCut = 16453
        OnClick = PM_ML_MedialibraryExportClick
      end
      object MM_ML_Delete: TMenuItem
        Caption = '&Delete'
        ImageIndex = 12
        OnClick = MM_ML_DeleteClick
      end
      object N71: TMenuItem
        Caption = '-'
      end
      object MM_ML_RefreshAll: TMenuItem
        Caption = '&Refresh (rescan all files)'
        ImageIndex = 39
        ShortCut = 16500
        OnClick = MM_ML_RefreshAllClick
      end
      object MM_ML_DeleteMissingFiles: TMenuItem
        Caption = 'Cleanup (remove &missing files)'
        ImageIndex = 38
        OnClick = DatenbankUpdateTBClick
      end
      object MM_T_CloudEditor: TMenuItem
        Caption = 'Tag cloud editor'
        ImageIndex = 19
        ShortCut = 24660
        OnClick = PM_ML_CloudEditorClick
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object MM_ML_CloseNemp: TMenuItem
        Caption = 'Close Nemp'
        ImageIndex = 21
        OnClick = PM_P_CloseClick
      end
    end
    object MM_Playlist: TMenuItem
      Caption = '&Playlist'
      OnClick = MM_PlaylistClick
      object MM_PL_Files: TMenuItem
        Caption = 'Add &files'
        OnClick = MM_PL_FilesClick
      end
      object MM_PL_Directory: TMenuItem
        Caption = 'Add &directory'
        OnClick = MM_PL_DirectoryClick
      end
      object MM_PL_WebStream: TMenuItem
        Caption = 'Add &webradio'
        ShortCut = 16457
        OnClick = PM_PlayWebstreamClick
      end
      object MM_PL_SortBy: TMenuItem
        Caption = 'Sort &by'
        ImageIndex = 11
        object MM_PL_SortByFilename: TMenuItem
          Tag = 1
          Caption = '&Filename'
          OnClick = PlaylistSortClick
        end
        object MM_PL_SortByArtist: TMenuItem
          Tag = 2
          Caption = '&Artist'
          OnClick = PlaylistSortClick
        end
        object MM_PL_SortByTitle: TMenuItem
          Tag = 3
          Caption = '&Title'
          OnClick = PlaylistSortClick
        end
        object MM_PL_SortByAlbumTrack: TMenuItem
          Tag = 4
          Caption = 'A&lbum, Tracknr.'
          OnClick = PlaylistSortClick
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object MM_PL_SortByInverse: TMenuItem
          Caption = '&Inverse'
          OnClick = PM_PL_SortByInverseClick
        end
        object MM_PL_SortByMix: TMenuItem
          Caption = '&Mix'
          OnClick = PM_PL_SortByMixClick
        end
      end
      object N69: TMenuItem
        Caption = '-'
      end
      object MM_PL_GenerateRandomPlaylist: TMenuItem
        Caption = '&Generate random playlist'
        OnClick = MitzuflligenEintrgenausderMedienbibliothekfllen1Click
      end
      object MM_PL_Load: TMenuItem
        Caption = '&Load (and clear current list)'
        ImageIndex = 0
        ShortCut = 16463
        OnClick = PM_PL_LoadPlaylistClick
      end
      object MM_PL_AddPlaylist: TMenuItem
        Caption = 'L&oad (add files to current list)'
        OnClick = MM_PL_AddPlaylistClick
      end
      object MM_PL_RecentPlaylists: TMenuItem
        Caption = '&Recent playlists'
      end
      object MM_PL_Save: TMenuItem
        Caption = '&Save'
        ImageIndex = 1
        ShortCut = 16467
        OnClick = PM_PL_SavePlaylistClick
      end
      object MM_PL_SaveAsPlaylist: TMenuItem
        Caption = 'Save As'
        OnClick = PM_PL_SaveAsPlaylistClick
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object MM_PL_ExtendedScanFiles: TMenuItem
        Caption = 'Refresh files'
        ImageIndex = 39
        OnClick = PM_PL_ExtendedScanFilesClick
      end
      object MM_PL_DeleteMissingFiles: TMenuItem
        Caption = 'Cleanup (remove missing files)'
        ImageIndex = 38
        OnClick = Nichtvorhandenelschen1Click
      end
      object MM_PL_ClearPlaylist: TMenuItem
        Caption = 'Clear'
        OnClick = PM_PL_ClearPlaylistClick
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object MM_PL_ExtendedAddToMedialibrary: TMenuItem
        Caption = 'Add all files to the media library'
        OnClick = PM_PL_ExtendedAddToMedialibraryClick
      end
      object MM_PL_CopyPlaylistToUSB: TMenuItem
        Caption = 'Copy files'
        OnClick = PM_PL_CopyPlaylistToUSBClick
      end
    end
    object MM_Options: TMenuItem
      Caption = '&Settings'
      OnClick = MM_OptionsClick
      object MM_O_Preferences: TMenuItem
        Caption = '&Preferences'
        ImageIndex = 5
        OnClick = MM_O_PreferencesClick
      end
      object MM_O_Wizard: TMenuItem
        Caption = 'Wizard'
        ImageIndex = 32
        OnClick = MM_O_WizardClick
      end
      object MM_O_View: TMenuItem
        Caption = '&View'
        object MM_O_ViewCompact: TMenuItem
          Caption = '[--- Compact view ---]'
          OnClick = PM_P_ViewCompactClick
        end
        object MM_O_ViewCompactComplete: TMenuItem
          Caption = '&Complete'
          Checked = True
          OnClick = MM_O_ViewCompactCompleteClick
        end
        object N34: TMenuItem
          Caption = '-'
        end
        object MM_O_ViewSeparateWindows: TMenuItem
          Tag = 1
          Caption = '[--- Seperate windows ---]'
          OnClick = MM_O_ViewCompactCompleteClick
        end
        object MM_O_ViewSeparateWindows_Equalizer: TMenuItem
          Caption = 'Show file information'
          ShortCut = 8304
          OnClick = PM_P_ViewSeparateWindows_EqualizerClick
        end
        object MM_O_ViewSeparateWindows_Playlist: TMenuItem
          Caption = 'Show &playlist'
          Checked = True
          ShortCut = 8305
          OnClick = PM_P_ViewSeparateWindows_PlaylistClick
        end
        object MM_O_ViewSeparateWindows_Medialist: TMenuItem
          Caption = 'Show &media library (title list)'
          Checked = True
          ShortCut = 8306
          OnClick = PM_P_ViewSeparateWindows_MedialistClick
        end
        object MM_O_ViewSeparateWindows_Browse: TMenuItem
          Caption = 'Show media libary (&browse list)'
          Checked = True
          ShortCut = 8307
          OnClick = PM_P_ViewSeparateWindows_BrowseClick
        end
        object MM_O_ViewStayOnTop: TMenuItem
          Caption = 'Stay on &top'
          ShortCut = 16468
          OnClick = PM_P_ViewStayOnTopClick
        end
      end
      object MM_O_FormBuilder: TMenuItem
        Caption = 'Form designer'
        OnClick = MM_O_FormBuilderClick
      end
      object MM_O_Skins: TMenuItem
        Caption = '&Skins'
        ImageIndex = 8
        object MM_O_Skins_WindowsStandard: TMenuItem
          Caption = 'Windows default'
          RadioItem = True
          OnClick = WindowsStandardClick
        end
        object MM_O_Skin_UseAdvanced: TMenuItem
          Caption = 'Use advanced skinning'
          GroupIndex = 1
          OnClick = MM_O_Skin_UseAdvancedClick
        end
        object N38: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
      end
      object MM_O_Languages: TMenuItem
        Caption = 'Languages'
        object MM_O_Defaultlanguage: TMenuItem
          Tag = -1
          Caption = 'English'
          OnClick = ChangeLanguage
        end
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object MM_O_PartyMode: TMenuItem
        Caption = 'Party mode'
        OnClick = PM_P_PartyModeClick
      end
    end
    object MM_Tools: TMenuItem
      Caption = '&Tools'
      OnClick = Player_PopupMenuPopup
      object MM_T_Shutdown: TMenuItem
        Caption = '&Shutdown'
        ImageIndex = 16
        object MM_T_ShutdownOff: TMenuItem
          Caption = '&Disable'
          OnClick = Schlafmodusdeaktivieren1Click
        end
        object MM_T_ShutdownSettings: TMenuItem
          Caption = 'Settings'
          OnClick = ActivateShutDownMode
        end
        object MM_T_ShutdownInfo: TMenuItem
          Caption = '(not active)'
          Enabled = False
        end
      end
      object MM_T_Birthday: TMenuItem
        Caption = '&Birthday mode'
        ImageIndex = 2
        object MM_T_BirthdayActivate: TMenuItem
          Caption = 'Activate'
          OnClick = MenuBirthdayStartClick
        end
        object MM_T_BirthdayOptions: TMenuItem
          Caption = 'Settings'
          OnClick = PM_P_BirthdayOptionsClick
        end
      end
      object MM_T_RemoteNemp: TMenuItem
        Caption = 'Nemp &Webserver'
        ImageIndex = 9
        object MM_T_WebServerActivate: TMenuItem
          Caption = 'Activate'
          OnClick = MM_T_WebServerActivateClick
        end
        object MM_T_WebServerOptions: TMenuItem
          Caption = 'Settings'
          OnClick = MM_T_WebServerOptionsClick
        end
        object MM_T_WebServerShowLog: TMenuItem
          Caption = 'Show log'
          OnClick = __PM_W_WebServerShowLogClick
        end
      end
      object MM_T_Scrobbler: TMenuItem
        Caption = 'Scro&bbler'
        ImageIndex = 18
        object MM_T_ScrobblerActivate: TMenuItem
          Caption = 'Activate'
          OnClick = PM_P_ScrobblerActivateClick
        end
        object MM_T_ScrobblerOptions: TMenuItem
          Caption = 'Settings'
          OnClick = PM_P_ScrobblerOptionsClick
        end
      end
      object MM_T_KeyboardDisplay: TMenuItem
        Caption = 'Keyboard display'
        ImageIndex = 31
        OnClick = PM_P_KeyboardDisplayClick
      end
      object MM_T_EqualizerEffects: TMenuItem
        Caption = 'Equalizer && Effects'
        ImageIndex = 40
        OnClick = TabBtn_EqualizerClick
      end
      object MM_T_Directories: TMenuItem
        Caption = '&Directories'
        object MM_T_DirectoriesRecordings: TMenuItem
          Caption = '&Recordings (webradio)'
          OnClick = PM_P_DirectoriesRecordingsClick
        end
        object MM_T_DirectoriesData: TMenuItem
          Caption = '&Data (cover, preferences, ...)'
          OnClick = PM_P_DirectoriesDataClick
        end
      end
      object MM_T_PlaylistLog: TMenuItem
        Caption = 'Playlist log'
        OnClick = MM_T_PlaylistLogClick
      end
    end
    object MM_Help: TMenuItem
      Caption = '&Help'
      object MM_H_About: TMenuItem
        Caption = '&About Nemp'
        ImageIndex = 17
        OnClick = MM_H_AboutClick
      end
      object MM_H_Help: TMenuItem
        Caption = 'Documentation and user guide'
        ImageIndex = 4
        OnClick = ToolButton7Click
      end
      object MM_H_CheckForUpdates: TMenuItem
        Caption = 'Check for updates'
        ImageIndex = 22
        OnClick = MM_H_CheckForUpdatesClick
      end
    end
    object MM_H_ErrorLog: TMenuItem
      Caption = 'Messages'
      ImageIndex = 33
      Visible = False
      OnClick = MM_H_ErrorLogClick
    end
    object MM_Warning_ID3Tags: TMenuItem
      Caption = 'Warning'
      ImageIndex = 33
      Visible = False
      OnClick = MM_Warning_ID3TagsClick
    end
  end
  object PlayListImageList: TImageList
    Height = 14
    Width = 14
    Left = 1008
    Top = 64
    Bitmap = {
      494C01011800000A04000E000E00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000038000000620000000100200000000000C055
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001A232800303A
      40000000000000000000000000000000000000000000696D7000030507000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006F85A400436190004B6896004D6A9700506B9700546E9700577096005972
      9800556F9500526B92004B6795003F69A8003665AA00637EA2007C6FA4005743
      90005F4B9600604D970063509700655497006757960069599800655595006252
      92005E4B9500583FA8005336AA007263A20000000000000000004E575B000066
      A300060A0D007274760000000000000000002A323A000B376400091016000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000444442006F6F6D000000
      00002A69AC00007FFF003AB8FF003AB8FF0055C7FF0066D2FF0066D2FF0066D2
      FF0066D2FF0055C7FF003AB8FF003AB8FF00007FFF002C6BA800402AAC002700
      FF003C3AFF003C3AFF005559FF00666FFF00666FFF00666FFF00666FFF005559
      FF003C3AFF003C3AFF002700FF003E2CA8000000000000000000000000000F3D
      52000196F2000D3C580030394000060A0D000063C4000066CA00252C34000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000444444005F5D5D00000000000000
      00002C73C500007FFF00018AFF0014A1FF0032B4FF0055C7FF0060CDFF0066D2
      FF005DCDFF003AB8FF0019A2FF000593FF000594FF003E73AF00492CC5002700
      FF001D01FF002014FF003532FF005559FF006066FF00666FFF005D64FF003C3A
      FF002619FF001905FF001905FF00523EAF000000000000000000000000000306
      070001B9FF0001A7FF000075BE000087FF000081FF00043E7600727476000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000048484800504F4D0000000000000000000000
      000097ACCC000D79DF000180FF000487FF001898FF0022A2FF00A1D9FF009DD7
      FF0021A2FF001C9BFF000A8EFF000995FF000773D700A4ADC000A697CC002A0D
      DF002701FF002404FF002E18FF003222FF00A6A1FF00A39DFF003021FF00311C
      FF00250AFF001D09FF002207D700AEA4C0000000000000000000000000003340
      43000191BB0001BAFF0001B5FF00019DFF000081FF000F223400000000000000
      000000000000000000000000000000000000000000007C7A7A008D807900A288
      800097857D0099959500515151005B5B5A000000000000000000000000000000
      0000F9FAFC003F7AB90028A0FD000686FD000087FF000A91FE00A0D4F90098D2
      FA000991FF00078CFF00078DFF000E97FC003968A300FAFAFB00FAF9FC00543F
      B9003A28FD002706FD001F00FF00220AFE00A6A0F9009E98FA002109FF002307
      FF002207FF00200EFC004E39A300FBFAFB0000000000000000006E7273000E24
      280002D8FF0002D8FF0002D8FF0001B3FF000094FF00083B6D00252C34000000
      000000000000000000000000000000000000A3999600FFFDEA00FFFFFF00FFFF
      FF00FFFFFF00FFF4DF00958C8800ACADAD000000000000000000000000000000
      0000000000009FAFCC003797DF0032A9FD001491FC00007BFF002C9FFC002FA4
      FC000080FE000082FE000694FF000E78D600A8B0C3000000000000000000AB9F
      CC004437DF003F32FD002E14FC002B00FF00402CFC003F2FFC002500FE002300
      FE001A06FF00260ED600B2A8C30000000000000000004B5658000F4A550002CF
      F50002E3FF0002E3FF0002DEFF0001CBFF00019FFF00008CFF000066CA000305
      07007B7B7C0000000000000000007F7E7E00FFF9E800FFFFFF00FFFFEB00FFFF
      FD00FFFFFF00FFFFFF00FFE2C80095908D000000000000000000000000000000
      000000000000F0F2F6004A7DB60042ADF900339EF200098AF600B6DEFE00B0D8
      FD00006DF6000080FE000A95FF00426EA400F5F5F7000000000000000000F2F0
      F6005D4AB6004E42F9004433F2002209F600BDB6FE00BAB0FD003300F6002500
      FE001E0AFF005642A400F6F5F700000000001D292B000663730002A5C10002C9
      E50017D1E70023E7FF0010E5FF0002CFFF0001B1FF00018CE2000066B200005C
      B200102A43005D62670000000000A0949000FFFFFF00FFFFFC00FFFFEE00FFFF
      FF00FFFFFD00FFFFFF00FFFFFF00A79790000000000000000000000000000000
      000000000000000000009BAAC7004097DD00369FF0001388E700BEE1F800B3D8
      F7000068EF000088FF000C7AD600ACB2C0000000000000000000000000000000
      0000A89BC7004F40DD004636F0002813E700C1BEF800BAB3F7003300EF001E00
      FF00210CD600B3ACC00000000000000000003D4A4C003D4A4C002D3B3D000F17
      19000F181900095F6D0002D8FF0001C6FF000C1A1F0011181C003D464C003D46
      4C003D464C0052595E0000000000AEA09C00FFFFFF00FFFFFF00FFFFFF00FFFF
      FB00FFFFFF00FFFFFF00FFFFFF00A59590000000000000000000000000000000
      00000000000000000000F6F7F900497AB20049ABF000228CE300C7E2F700C4E4
      FA000A8CF7001098FD00466FA200FDFDFD000000000000000000000000000000
      0000F8F6F9005C49B2005449F0003522E300CBC7F700C7C4FA00220AF7002210
      FD005946A200FDFDFD0000000000000000000000000000000000000000000000
      0000000000000914160002D8FF00025E7C005A61640000000000000000000000
      00000000000000000000000000008F878500FFFFFF00FFFFFF00FFFFFD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF008F847F000000000000000000000000000000
      0000000000000000000000000000A6B5CE004191D300389EEA00C6E2F500BDE3
      FC0020A8FF002689D800B5BAC900000000000000000000000000000000000000
      000000000000B2A6CE005041D3004638EA00C9C6F500C0BDFC002920FF003626
      D800BDB5C9000000000000000000000000000000000000000000000000000000
      00000000000033414300019DBB0010323D000000000000000000000000000000
      00000000000000000000000000009B9B9B00F0E9E700FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00838080000000000000000000000000000000
      0000000000000000000000000000F5F6F900517FB3004FA9E9004BA9EB0044AE
      F80038B2FF005478A50000000000000000000000000000000000000000000000
      000000000000F7F5F9006351B300594FE900554BEB004F44F8003F38FF006554
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000009D9D9D000C53610011191C000000000000000000000000000000
      0000000000000000000000000000000000008F8D8F00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0085807F00000000000000000000000000000000000000
      000000000000000000000000000000000000B2BED4004696D50043ACF8003CB4
      FF003391D900C3C7D40000000000000000000000000000000000000000000000
      00000000000000000000BCB2D4005346D5005043F800433CFF004133D900CAC3
      D400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000001010100656B6D000000000000000000000000000000
      00000000000000000000000000000000000000000000A9A9A900848383009290
      8F00908E8E008B8B8C0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFE005885B90058BEFF004FBE
      FE006284B0000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE006A58B9005F58FF00524FFE007262B0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000076797900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDC6DA004AA5E700459A
      DB00CCCED9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6BDDA00554AE7005245DB00D2CCD9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000000C0000000C000000000000000C0000000C000000000000000C0000000C0
      0000000000000000000000000000717171007171710000000000717171007171
      7100000000007171710071717100000000007171710071717100000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000000C0000000C000000000000000C0000000C000000000000000C0000000C0
      0000000000000000000000000000717171007171710000000000717171007171
      7100000000007171710071717100000000007171710071717100000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F0000000000000000000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004BC94E004BC94E000000
      000000C0000000C000000000000000C0000000C000000000000000C0000000C0
      0000000000000000000000000000969696009696960000000000717171007171
      7100000000007171710071717100000000007171710071717100000000000000
      00007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000000000000000000000000000000000007F7F7F000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006BD7BF006BD7BF000000
      00000000000000000000000000006BD7BF006BD7BF00000000006BD7BF006BD7
      BF00000000000000000000000000C4C4C400C4C4C40000000000000000000000
      000000000000C4C4C400C4C4C40000000000C4C4C400C4C4C400000000000000
      00007F7F7F00000000000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F0000000000000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000000000000000000000000000000000007F7F7F000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000277FFF00277FFF000000
      0000000000000000000000000000277FFF00277FFF0000000000000000000000
      00000000000000000000000000009B9B9B009B9B9B0000000000000000000000
      0000000000009B9B9B009B9B9B00000000000000000000000000000000000000
      00007F7F7F0000000000000000000000000000000000000000007F7F7F000000
      0000000000000000000000000000000000007F7F7F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00000000000000000000000000000000007F7F7F000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000241CED00241CED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000005B5B5B005B5B5B00000000000000000000000000000000000000
      000000000000000000007F7F7F000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007F7F7F000000000000000000000000000000
      0000000000007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F00CC483F00CC48
      3F00CC483F00CC483F00CC483F007F7F7F000000000000000000000000000000
      00000000000000000000000000007F7F7F00241CED00241CED00241CED00241C
      ED00241CED007F7F7F0000000000000000000000000000000000000000000000
      0000000000007F7F7F004CB122004CB122004CB122004CB122004CB122007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F7F000000
      0000000000000000000000000000000000007F7F7F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F007F7F7F0000000000000000000000
      000000000000000000007F7F7F00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED007F7F7F00000000000000000000000000000000000000
      00007F7F7F004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22007F7F7F00000000000000000000000000000000007F7F7F00C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F
      7F000000000000000000000000007F7F7F00CC483F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F00CC483F007F7F7F00000000000000
      0000000000007F7F7F00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED007F7F7F000000000000000000000000007F7F
      7F004CB122004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22004CB122007F7F7F000000000000000000000000007F7F7F00C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F
      7F000000000000000000000000007F7F7F00CC483F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F00CC483F007F7F7F00000000000000
      0000000000007F7F7F00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED007F7F7F000000000000000000000000007F7F
      7F004CB122004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22004CB122007F7F7F000000000000000000000000007F7F7F00C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F
      7F000000000000000000000000007F7F7F00CC483F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F00CC483F007F7F7F00000000000000
      0000000000007F7F7F00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED007F7F7F000000000000000000000000007F7F
      7F004CB122004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22004CB122007F7F7F000000000000000000000000007F7F7F00C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F
      7F000000000000000000000000007F7F7F00CC483F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F00CC483F007F7F7F00000000000000
      0000000000007F7F7F00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED007F7F7F000000000000000000000000007F7F
      7F004CB122004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22004CB122007F7F7F000000000000000000000000007F7F7F00C3C3C300C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F
      7F000000000000000000000000007F7F7F00CC483F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F00CC483F007F7F7F00000000000000
      0000000000007F7F7F00241CED00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED00241CED007F7F7F000000000000000000000000007F7F
      7F004CB122004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22004CB122007F7F7F00000000000000000000000000000000007F7F7F00C3C3
      C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F7F000000
      0000000000000000000000000000000000007F7F7F00CC483F00CC483F00CC48
      3F00CC483F00CC483F00CC483F00CC483F007F7F7F0000000000000000000000
      000000000000000000007F7F7F00241CED00241CED00241CED00241CED00241C
      ED00241CED00241CED007F7F7F00000000000000000000000000000000000000
      00007F7F7F004CB122004CB122004CB122004CB122004CB122004CB122004CB1
      22007F7F7F000000000000000000000000000000000000000000000000007F7F
      7F00C3C3C300C3C3C300C3C3C300C3C3C300C3C3C3007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F00CC483F00CC48
      3F00CC483F00CC483F00CC483F007F7F7F000000000000000000000000000000
      00000000000000000000000000007F7F7F00241CED00241CED00241CED00241C
      ED00241CED007F7F7F0000000000000000000000000000000000000000000000
      0000000000007F7F7F004CB122004CB122004CB122004CB122004CB122007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F0000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      000000000000000000007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000040
      C5001544FF000550FF00304E8C00000000000000000000000000000000000000
      0000FDFDFD00FFFFFF00FFFFFF00E8E8E800C9C9C9008E8E8E00848382007978
      770073727B00AFB0B200EAE9E900FFFFFF00FFFFFF00FEFDFE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840042424200000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000194C
      BE00004DFF00004EE700586D9800000000000000000000000000000000000000
      0000FDFDFD00FEFEFE00D2D2D100A7A7A700DCDCDC00FAFAF900DFDFD700BBB8
      BD008F8AB300747C890068777400C3C3C400FEFDFE00FCFDFC0000000000080B
      815F060A94EF070B9BF5070B9BF5070B9BF5070B9BF5070B9BF5070B9BF5070B
      9BF5070B9BF5060A94EF080B815F000000000000000000000000000000000000
      000000000000C6C6C60084848400424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007896
      D2000051DC000042B6009B9FC900000000000000000000000000000000000000
      0000F9F9F900D2D2D200B9B9B800FFFFFF00FEFEFE00F3F2F300D9D8CF00A49F
      B9008984A60085A09E007A9D92005B6E5A00BEC1BE00FBFBFB0000000000090E
      9DF00C13B2FF0D16BDFF0D15BDFF0D16BDFF0E17BEFF0E17BEFF0D16BDFF0C15
      BDFF0C15BDFF0B13B2FF090E9DF0000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008193
      B2000042BC0000369A00BAC1CA00000000000000000000000000000000000000
      0000E9E9E900AFAFAF00FFFFFF00F8F8F800FFFFFF00FFFFFE00D9D5DC009792
      BF009EB3BD008FB3AB00779D78007D9A7100716C6500EDECED00000000000B13
      B0F70E1AC3FF1E27C5FF2C35CAFF232CC7FF121DC2FF0D18C0FF242EC7FF323A
      CAFF2A33C9FF121DC4FF0B12B0F7000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C07931000000000000000000ADB6
      CD0000389600002F8000000000000000000000000000C0793100000000000000
      0000DBDBDB00E4E2E200FCFCFC00FDFDFD00F1F0EF00DBDAD500DDDAE300CDCA
      DE00A9C8C4008EC29A008DAE8500A18A810094727000B4B1B00000000000070F
      B5F55E65CFFFE2E1EFFFBFC0E0FFD0D2E8FF4046CCFF8388D9FFD9DBEDFFB9BA
      DDFFCDCFE8FFA0A3E2FF121AB5F5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CC905900FFC9950000000000000000000000
      000000306C0000296700000000000000000000000000FFC99500CC9059000000
      0000B0B0B000FAF9F900F6F4F400FBFAFA00DBD9DA00EFEFEF00CFCFCE00CCCB
      C800EEF6F300B7C7A900BF999400B58B8F00B7AAA50081807F00000000001F28
      BDF5D7D8EEFF8B90D7FF020DA3FF2F38B6FF6F74CFFFECEDF6FF3C45B4FF0000
      9CFF6469BDFFEFF0F5FF2C35BDF5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3DCD300D58E43000000000000000000D4883A000000
      0000002852000B284F0000000000D4883A000000000000000000D58E4300E3DC
      D3009B9A9A00F3F3F300DADAD800EDEFED00F6F7F800CECECE00E0E0E000E4E3
      E300CACCCC00F0DCE000D0AAAC00BCBFBB00C4C6C4008D8C8B0000000000343D
      CAF5EDEDF2FF4652D3FF1021D3FF0315C4FFB3B7E3FFAFB3DFFF5F68CBFFCACD
      F3FFD5D7F0FF787FD4FF131EBCF5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C29F7D00FFD2A20000000000E6BE9400E6CBAE000000
      0000001E3B003044590000000000E6CBAE00E6BE940000000000FFD2A200C29F
      7D009D9D9B00ECEDEB00CBCDCB00EAE3E300FFFEFF00BFBFC000E9E9E900F5F5
      F500BDBDBD00F9F8F900EDF0EE00D3D6D300D8D7D60099999800000000002531
      CEF5DADCF1FF7C84E0FF0418D6FF3C4AD6FFE5E5F3FF7D86CFFFE4E6F2FF868D
      D6FF3642C1FF414ECDFF1A28CFF5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001010
      10000000000000000000C08A5600FFD19B0000000000C3752300000000006783
      B900265EF8001F57E7008DA4CE0000000000C375230000000000FFD19B00C08A
      560095969500EAE9E800C5AEAD00E8C2C300F4EFED00FBFCFC00C5C5C500BFBF
      BF00F8F8F800EFF0F000FFFFFF00EFF0EE00F6F6F40096959500000000001020
      D4F5737FE0FFEAEBF5FFA1A7F2FFD2D6F6FFADB4E7FF2639C8FFBDC2EBFFB9BD
      F0FFC5CAF3FFB8BDEDFF1D2CD6F5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808000000
      00000000000000000000BF885300FFD09B0000000000C4762200000000003C5A
      CB002960FE000051F30096AACD0000000000C476220000000000FFD09B00BF88
      5300B4B5B300DBC6C700D0A7A900BEC2A900D2EFD500EFF6F500F8F8F700F8F7
      F700EFEEEF00FAF9F900FDFDFD00F8F8F800FAFAFA00B4B4B400000000001D2E
      E4F52238D2FF4B59BCFF6C77C2FF5E6BC9FF273ACAFF1C31D5FF3141BBFF6570
      BDFF6570C2FF384BD4FF1B2CE2F5000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C29A7300FFD09D0000000000E8B98900E6C7A6000000
      00002851CD00144FD00000000000E6C7A600E8B9890000000000FFD09D00C29A
      7300E7E6E600A6999800DDE0CF00A3C6A100B0D5C100D6ECEE00D5D3E800EEED
      EF00FFFFFF00FDFDFD00F7F7F700FFFFFF00BEBEBE00E5E5E500000000002436
      EAF82942EAFF1831DEFF1831DCFF1931DEFF2039E5FF253DEAFF1D36E1FF1830
      DCFF1730DEFF253EE8FF2436EAF8000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800000000000000
      00000000000000000000E3DCD300D5944C000000000000000000C88039000000
      0000000000000000000000000000C88039000000000000000000D5944C00E3DC
      D300F6F6F700C2C4C300A3B3A000D0E7D900B9D2CF00B1B8CB00C3BEDB00E8E7
      E700F5F5F300F8F8F800FFFFFF00D3D3D300BABABA00F4F4F400000000002A3E
      EFEC4A5EF6FF4D62F6FF4C62F7FF4C62F6FF4C62F6FF4C62F6FF4C62F6FF4C62
      F7FF4D62F6FF4A5EF6FF2A3EEFEC000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000D9914F00FFDDBB0000000000000000000000
      00000000000000000000000000000000000000000000FFDDBB00D9914F000000
      0000FDFDFD00FEFDFD00BDBEBD009CA9A700C8D4DB00D1CDE800D8D6E000EDEB
      E700FFFFFF00FFFFFF00BEBEBE00B8B8B800F8F8F800FEFEFE0000000000263E
      DF573249F6EA3B50FAF53A50FAF53A50FAF53A50FAF53A50FAF53A50FAF53A50
      FAF53B50FAF53249F6EA263EDF57000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C27C370000000000000000000000
      00000000000000000000000000000000000000000000C27C3700000000000000
      0000FDFDFD00FEFEFE00FFFFFF00E3E3E200B0B1B40092929B00AFAEB000B9B8
      B500A4A4A500B0B0B000E0E0E000FAFAFA00FFFFFF00FDFDFD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000006AC1
      6B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF0000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000041DC450031DA
      300047873F000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004DE1470024DB1F001EDD
      2200238416000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002117
      FF002115FF000000000000000000000000000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005DB7570054CF4900000000000000
      000049C83600487E5B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000066B85900487E5B00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF00000000000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006C9D6B00487E5B000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000FF000000FF000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000062A977003A774B0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006EA96C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400424242000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400424242000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600848484004242420000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C00000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001010
      1000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010101000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000080808000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C00000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000038000000620000000100010000000000100300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      CF9FFFF000000000C31FFF9000000000E01FFF3000000000E01FFE7000000000
      E03F80F000000000C01F00F800600100800600F800600100000200FC00F00300
      000200FC00F00300F87E00FE01F80700F8FE00FE03F80F00F8FF01FF03FC0F00
      FCFF83FF07FC1F00FDFFFFFF87FE1F00FFFFFFFFFFFFFF00924E493F07FFFF00
      FFFFFFFEFBFFFF00924E493DFDFFFF00FFFFFFFBFEFFFF00924E4937FF7FFF00
      FFFFFFF7DF7FFF009E4E7937837FFF00FFFFFFF7DF7FFF009E7E79F7DF7FFF00
      FFFFFFFBDEFFFF00FE7FF9FDDDFFFF00FFFFFFFEFBFFFF00FFFFFFFF07FFFF00
      FFFFFFFFFFFFFF00FFFFFFFFFFFFFF00F07FC1FF07FC1F00E03F80FE03F80F00
      C01F007C01F00700800E003800E00300800E003800E00300800E003800E00300
      800E003800E00300800E003800E00300C01F007C01F00700E03F80FE03F80F00
      F07FC1FF07FC1F00FFFFFFFFFFFFFF00F8FFE1F000000000F07FE1F000000000
      F07FE1F000000000F87FE1F000000000FF6F63B000000000DF76739000000000
      FF74D2C000000000DF74924000000000DF6CA14000000000EF5CA14000000000
      F73C924000000000B73CDEC000000000CF7E7F9000000000FF7F7FB000000000
      FFFFFFFFFFFF3C00E01FFFFFEFFF9900C00FFFFFC7FFC3008FC7BF7F87FFE700
      9FE7DEFF33FFC3009FE6EDFFF9FF99009FE4F3F91CE53C009FE6F3FFFE7FFF00
      9FE7EDF87F63FF009FE7DEFFFFFFFF008FC7BF7A9FEA7F00C00FFFFFFFFFFF00
      E01FFFF85FE17F00FFFFFFFFFFFFFF00F8FFE3FFFFFFFF00F07FC1FCFFF1E300
      F07FC1F83FE0C100F87FE1F90FE4C900FF6FFDB9C3E4C900FF77FDD9F0E4C900
      FF751DD9FC64C900FF77FDD9FC64C900FF6C5DB9F0E4C900FF5FFD79C3E4C900
      FF3C9CF90FE4C900FF3FFCF83FE0C100FF7C1DFCFFF1E300FF7FFDFFFFFFFF00
      00000000000000000000000000000000000000000000}
  end
  object AutoSavePlaylistTimer: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = AutoSavePlaylistTimerTimer
    Left = 848
    Top = 56
  end
  object DragFilesSrc1: TDragFilesSrc
    DropEffect = deCopy
    VerifyFiles = False
    OnDropping = DragFilesSrc1Dropping
    Left = 120
    Top = 312
  end
  object SleepTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = SleepTimerTimer
    Left = 32
    Top = 488
  end
  object BirthdayTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = BirthdayTimerTimer
    Left = 88
    Top = 488
  end
  object MenuImages: TImageList
    ShareImages = True
    Left = 24
    Top = 280
    Bitmap = {
      494C01012A00300B040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000B0000000010020000000000000B0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000000C0000000C000000000000000C0000000C000000000000000C0000000C0
      00000000000000C0000000C00000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000000C0000000C000000000000000C0000000C000000000000000C0000000C0
      00000000000000C0000000C00000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E8A20000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006BD7BF006BD7BF000000
      00006BD7BF006BD7BF00000000006BD7BF006BD7BF00000000006BD7BF006BD7
      BF00000000006BD7BF006BD7BF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E8A20000000000000000
      000000000000000000000000000000000000000000006BD7BF006BD7BF000000
      00006BD7BF006BD7BF00000000006BD7BF006BD7BF00000000006BD7BF006BD7
      BF00000000006BD7BF006BD7BF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E8A2
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000277FFF00277FFF000000
      0000000000000000000000000000277FFF00277FFF0000000000277FFF00277F
      FF0000000000277FFF00277FFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E8A200000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000277FFF00277FFF000000
      0000000000000000000000000000277FFF00277FFF0000000000000000000000
      000000000000277FFF00277FFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000241CED00241CED0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFE00FAFAFB00F6F6F800F4F4F600F5F5F700F9F9FA00FCFCFD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00FAFAFA00F7F7F700F5F5F500F1F1F100EFEFEF00F0F0F000F4F4
      F400F8F8F800FCFCFC000000000000000000000000000000000000000000FDFD
      FD00FAFAFA00F7F7F700F4F4F400F3F3F300F3F3F300F4F4F400F7F7F700FAFA
      FA00FDFDFD000000000000000000000000000000000000000000FEFEFE00F7F7
      FA00E7E7F200D6D6E700CACADE00CBCBDD00CACADC00D2D2E300E2E2EE00F3F3
      F700FDFDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FDFDFD00F6F6
      F600EBEBEB00E1E1E100C2D3D700A0CAD300AEC8CE00C1C7C900CDCDCD00D3D3
      D300DCDCDC00E7E7E700F3F3F300FBFBFB0000000000FDFDFD00F7F7F700EDED
      ED00E4E4E400DDDDDD00D9D9D900D4D4D400D2D0CE00D5D2CF00DAD9D700E4E4
      E400EDEDED00F4F4F400FCFCFC000000000000000000FEFEFE00F1F1F800CBCB
      E900A3A3D9009393D5009797D700A0A0D9009B9BD7009292D3009A9AD600BDBD
      E200E9E9F400FDFDFE0000000000000000000000000000000000000000000000
      00000000000000000000FAFAFA00F4F6F400F8F9F80000000000000000000000
      00000000000000000000000000000000000000000000FEFEFE00F5F5F500E6E6
      E600D7D7D700BDC6C80065BECF003EC2D90041BFD4005AB9CB007BAFBA00ABB5
      B700C5C5C500D2D2D200E1E1E100F0F0F000FEFEFE00EFEBE800DCD0C800DCDC
      DC00D2D2D200C4C0BE00BBAB9E00BB9C8300BD967300BE936C00BF967200C3A7
      8F00D4CBC400E6E6E600F1F1F100FBFBFB0000000000F6F6FB00C1C1EA007777
      DC005D5DDF006868E5007979EB008282EB007D7DEA006B6BE7005B5BDF006666
      D800A8A8E200EEEEF70000000000000000000000000000000000000000000000
      0000D8E6D80094C5940098D09800A9D9A900A6D3A60098C69800C5DAC500FAFB
      FA000000000000000000000000000000000000000000FEFEFE00F5F5F500E6E6
      E600D9D9D90090C2CC0037C2D80021C1D90026C5DD0038C7DD003AC0D8004DB6
      C9009CBEC500D2D2D200E2E2E200F0F0F00000000000EBE3DE00C8A58A00CFC3
      BA00C7B8AD00C09B7B00C5946800C9956400CA946100C9925E00C88F5A00C389
      5300BF8F6400D8CABE00F3F3F300FBFBFB00FEFEFE00DBDBF2007373E0002B2B
      E7002E2EF3004242F6004F4FF5005555F4005151F4004444F6003131F4002525
      EA005454DC00C2C2EA00FAFAFC00000000000000000000000000FEFEFE00B0DF
      B00055D455006CEE6C0083F083008EEE8E008DEC8D007EEA7E005ED45E008FCE
      8F00F5F9F5000000000000000000000000000000000000000000FDFDFD00F7F7
      F700E3E7E90065C8DA0020C5DD001BC5DF002ECDE40027C1DA0017BED70036CA
      E0004CC1D7009BD1DC00EFF1F100FCFCFC0000000000F3ECE700D6B59A00D0AD
      8F00CFA88700CF9F7300CC996900CA976700C7946500C5936600C18A5A00C28B
      5900C2885300C69A7200F4EFEB0000000000F9F9FC00B1B1E8003232E2000808
      F6000D0DFB001717FB001E1EFA002222FA001F1FFA001818FB000E0EFB000606
      F9001A1AE4008A8AE000F1F1F900000000000000000000000000C5E5C50022DD
      220029F7290043F5430054EE54005CE95C005BE55B0050E350003AE23A001FD1
      1F007DC87D000000000000000000000000000000000000000000000000000000
      0000DAF0F50044CADF001CCCE50026D2EC0026C9E4001AC1DB001BC3DA0034C5
      DC0059CCDF0093D9E700F4FAFB000000000000000000F5EEE900D8B79B00DEBD
      9D00DCB99800D7B08C00CDA27A00D4B29400E3D0C200EBE1D900E7D2C000DCB9
      9B00D4B09200BF8A5A00E7D5C70000000000F4F4FB008E8EE5000F0FE5000101
      FD000000FE000202FD000404FD000505FD000404FD000202FD000000FD000000
      FD000505EE006060DE00E2E2F3000000000000000000FEFEFE0030C4300000FB
      000005FB05000EF00E001AE51A0020DD20001FD71F0016D316000AD20A0002D5
      020008BE0800D4E6D40000000000000000000000000000000000000000000000
      0000C3EAF2003DD2E70030DAF20034D8F10022CDE70016C5DD0028C4DB0063CF
      E100BBE7F000F8FBFD00000000000000000000000000F5EEE900D8B79B00DDBA
      9A00DDBB9A00D3AE9000E6D5C800FCFBFA00000000000000000000000000F3E5
      DA00F6EDE500D4B49A00DCC3AF0000000000F2F2FB008080E6000303E7000000
      FE000000FE000101FE000606FD000C0CFC000D0DFC000A0AFC000303FE000000
      FE000101F4004F4FDF00D6D6ED000000000000000000D7E8D70000E5000000FD
      000000F4000000E5000000D8000000CD000000C4000000BF000000BF000000C4
      000000C700008DCA8D000000000000000000000000000000000000000000F4F4
      F70091B9D80048D6ED004EE5F90043DDF40024D3EC0021C7DE0060CEE000CDEC
      F3000000000000000000000000000000000000000000F5EEE800D7B79C00DDBC
      9D00DDBB9C00D7B59600E0CAB800FDFBFB00000000000000000000000000FCFA
      F700FEFEFD00ECDED400E1CCBC0000000000F3F3FB008787E5000808E5000101
      FD000808FC001717FB002121F9002727F9002929F9002828F8002121FA001010
      FC000505F2005858E000DDDDF1000000000000000000B7DCB70000F4000000FA
      000000EB000000DC000004CD04000BC10B000DB70D000CB10C0004AF040000B4
      000000BD000070C070000000000000000000000000000000000000000000ACAE
      D6000F16A700325FC3005FC0E4004EE4F90034D5EC0063D0E200D5EFF5000000
      00000000000000000000000000000000000000000000F7F2EE00DABEA900DCC1
      AA00DCC0AA00DBBFA800D5B79F00F3EAE400FBF9F700E6D4C600E5D2C300E5D3
      C400E6D4C500E0CBBA00ECE0D60000000000F7F7FC00A3A3E6002323E4000C0C
      F9002525F9003838F7003E3EF6004141F6004444F6004545F5004444F6003434
      F6001F1FE7007979E000ECECF7000000000000000000C5E0C50000F0000000F6
      000000E5000014D6140027CA27002BBD2B002EB32E0030AC30002CAB2C000FAB
      0F0000B2000081C4810000000000000000000000000000000000E5F5F90061BF
      D9002470C0002A38C2003B45C9003C7FC70083D3E600E0F4F800000000000000
      00000000000000000000000000000000000000000000F3EBE500DFC7B500F6EE
      E800F7F1ED00FCFBFB00FDFCFB00FEFDFD00FDFCFB00DCC3AF00CFA68300D0A4
      7E00CFA27B00CFA58000E6D4C60000000000FCFCFD00CDCDEE005858E1002727
      ED004343F4005252F4005555F4005757F4005A5AF4005B5BF3005C5CF2005050
      EC005353DE00B0B0E600F8F8FC000000000000000000F4F8F40010D1100001F4
      01001CE31C003FD63F0043CA430045BF450047B347004AAA4A004CAB4C0048B3
      48000BA50B00BBD9BB0000000000000000000000000000000000EAF7FA006FC9
      DD0048CBE20065C3E5004168C5005A5EB800EDEEF40000000000000000000000
      00000000000000000000000000000000000000000000EFE4DB00C59A7700DAB9
      9F00DFC6B300FDFCFB00000000000000000000000000F7F2EE00D1AF9200D2A7
      7E00CFA07300CFA27B00E6D4C5000000000000000000EFEFF800A5A5E6005858
      DF005353E8006363F0006969F1006C6CF2006E6EF1006E6EEF006868E8006666
      DE009494DF00E1E1F300FEFEFE0000000000000000000000000091D791000CE4
      0C0042E4420058D9580059CE59005CC45C005EBB5E0061B3610063B463005DB7
      5D005BAC5B00F9FAF90000000000000000000000000000000000F2F6F800649F
      C300157EB20054BCD70074D1E400DCE8F1000000000000000000000000000000
      00000000000000000000000000000000000000000000F4EDE800CAA38400BC88
      5F00BF8F6A00EFE4DB00FEFEFE00F9F6F300EDE0D600DABEA600D1A98500D2A6
      7C00D1A27600CFA27A00E5D3C4000000000000000000FEFEFE00E5E5F500A8A8
      E5007A7ADD006E6EDF006C6CDF006E6EDF007070DD007777DD008080DB00A1A1
      E000D9D9F000FAFAFC0000000000000000000000000000000000F6FAF60065D5
      650038DC38006CDC6C006FD46F0071CD710074C6740075C2750073BE730067AE
      6700E6F0E60000000000000000000000000000000000FEFEFE009CC1D9002382
      BC00247EB600B1CFE000D5F0F600F9FCFD000000000000000000000000000000
      00000000000000000000000000000000000000000000FCFAF900DCC1AC00D7B6
      9A00C4977200C79F7E00D9BDA700DBBEA600D9BB9F00DEBEA100DCB89700D4AB
      8500CEA37E00CFA57F00E5D2C300000000000000000000000000FDFDFE00EBEB
      F700CCCCEC00ADADE1009B9BDB009B9BDB009D9DDB00ACACDE00C7C7E800E7E7
      F500FBFBFD00000000000000000000000000000000000000000000000000ECF5
      EC0071CD710052D0520078D278007CCE7C0080C9800083C4830086BC8600E0EC
      E0000000000000000000000000000000000000000000D1E1EB004591C0001E83
      C20062A1C800F3F6F90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EEE3DA00DABD
      A400E5CDB700E5CCB600E4CAB300E5CAB200E4C9AF00E1C3A800D9B89B00D8BA
      A200E4D0C100CEA88800E3CEBE0000000000000000000000000000000000FEFE
      FE00F9F9FC00F0F0F800EBEBF600EAEAF600EBEBF600EFEFF700F8F8FB00FEFE
      FE00000000000000000000000000000000000000000000000000000000000000
      0000FCFDFC00CFE7CF00ABDAAB00AED8AE00B8D8B800CDE1CD00F6F9F6000000
      00000000000000000000000000000000000000000000B2CEDF004389B5003D89
      B900B0CDDF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFE4
      DB00DCC2AD00DBBEA500DCBFA500DBBCA200D9BA9E00DABEA700E7D6C800F9F6
      F30000000000EBDDD300EADBD000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E0EBF20076A8C8008EB7
      D000EFF4F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FBF8F700F1E7E000EBDDD200ECDED400F2E9E200FBF9F700000000000000
      000000000000FEFEFE00FDFDFC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FEFEFE00FCFCFC00FDFDFD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F4F4F400E1E1E100CECECE00C9C9C900CBCBCA00D7D7D700EBEBEB00FAFA
      FA000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000F8F8F800DFDFDF00D4D4D400DCDCDC00F5F5F500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F8F6F600EFE8E800E9DFDF00E4DBDB00E6DDDD00ECE4E400F5F2F2000000
      0000000000000000000000000000000000000000000000000000ECECEC009696
      9600292A2A002525280045444600686462005A56550039383A00222223005252
      5200CACACA00FAFAFA00000000000000000000000000FFFFFF00CED6DF00A7B3
      C600AAB3CA00A7B2CC00A2B0CB00A3B2CB00A5B3CB00A3B0C900A5B0C7009FAE
      CA0091A7C900C4CEDB00FFFFFF0000000000000000000000000000000000FCFC
      FC00C2C2C2007C7C7C00828282008A8A8A007D7D7D0074747400B8B8B800FAFA
      FA00000000000000000000000000000000000000000000000000FEFEFE00F2EA
      EA00DDBDBD00D2A0A000D09D9D00D3A6A600D0A4A400CE9F9F00D6B1B100E8DB
      DB00FCFCFC000000000000000000000000000000000000000000616161000000
      0000181819004242440069696B008D8A88007F7B7A005C5B5C00343435000707
      07000C0C0D00C7C7C700000000000000000000000000FFFFFF005F90C9000D6B
      D3001076D7002186D8003A96D900459CD900469CD9004298D700298AD500137A
      D9000072E2006496C900FFFFFF00000000000000000000000000FEFEFE00A8A8
      A8004E4E4E00818181009E9E9E00A7A7A7009C9C9C007C7C7C00444444009393
      9300FDFDFD000000000000000000000000000000000000000000F3E7E700D99A
      9A00D8686800E46F6F00E8828200E98F8F00E78C8C00E57C7C00DA696900CE7C
      7C00E4CCCC00FEFEFE0000000000000000000000000000000000343534000404
      0400141415003A3A3C00666566008B8786007B7878005656570029292A000B0B
      0B0007070700BDBDBD00000000000000000000000000FFFFFF0096B5DC000072
      E7000088FF00159EFF002FB3FF0079D3FF008BDBFF003CB8FF0020A5FF000B9B
      FF00007EEC0099B6D900FFFFFF00000000000000000000000000ADADAD002222
      22004C4C4C0068686800787878007E7E7E007777770065656500464646001B1B
      1B0096969600FCFCFC00000000000000000000000000F9F4F400E1A4A400DD3F
      3F00F0343400F54C4C00F45E5E00F3676700F3646400F4575700F4424200E432
      3200D4707000EEDEDE0000000000000000000000000000000000969696001111
      1100101011003B3B3D00666567008B8886007B78780057575800282828000E0E
      0E002121210000000000000000000000000000000000FFFFFF00F4EFEE00679F
      D4000988F5000787FC000082FC0080C2FA00A8D8FA00038CFC000A8CFD00008D
      FB003A86D100F1EDEC00FFFFFF000000000000000000E3E3E300313131000C0C
      0C002222220038383800464646004A4A4A0045454500353535001D1D1D000707
      070024242400D5D5D500000000000000000000000000F0DADA00DD5D5D00EE0B
      0B00FB0F0F00FA1E1E00F92A2A00F9303000F92F2F00FA252500FB161600F70A
      0A00E02D2D00E2AAAA00FBF9F900000000000000000000000000D3D3D3001212
      12001616160037373900605F60008784820075727200504E5100292729001919
      19003B3B3B0000000000000000000000000000000000FFFFFF00FFFFFF00C7D3
      E3003693DC0026A2FC00007DFC003A9EFB0055ADFA000074FD00028CFE000887
      ED00A6B5CF00FFFFFF00FFFFFF000000000000000000AAAAAA000D0D0D000000
      000002020200070707000D0D0D000F0F0F000C0C0C0005050500010101000000
      0000080808009B9B9B000000000000000000FDFDFD00E9BDBD00E0353500FA01
      0100FE010100FE030300FD060600FD070700FD070700FE040400FE020200FD01
      0100EC161600DF818100F4EBEB00000000000000000000000000FCFCFC001212
      13000C0C0D0040414200787778009695930093929100706E6F00232223000909
      0A005454540000000000000000000000000000000000FFFFFF00F8FAFC00FBF9
      F90079A7D100369EEA000C8AF000B3DAFA00EDEEFA000059F000008DFF004689
      CB00FDFAF800FDFEFE00FFFFFF00000000000000000087878700030303000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101007C7C7C00FCFCFC0000000000FDFBFB00E5AAAA00E1212100FD00
      0000FF000000FF000000FE000000FE030300FE050500FE030300FE000000FE00
      0000F00F0F00E06E6E00F3E3E300000000000000000000000000F4F4F4003A3A
      3A005A5A5A009C9D9B00B4B4B400BEC0BE00C0C0C000CDCCCB00B9B8B7006867
      65007979790000000000000000000000000000000000FFFFFF00FAFBFC00FFFF
      FF00D7DEE8004B97D7001A8DE700AAD4F300D9E7F9000277F7000780E900C3CE
      DD00FFFFFF00FCFDFE00FFFFFF00000000000000000081818100010101000000
      000000000000040404000E0E0E00131313001515150010101000040404000000
      00000101010077777700FBFBFB0000000000FDFBFB00E4ABAB00E0212100FD00
      0000FF000000FE070700FB1A1A00FB212100FA252500FA252500FB1A1A00FD04
      0400F00F0F00E06E6E00F3E3E30000000000DEDEDE0039383B00414242004D4E
      5000252427002B2A2E00292A2D00363538004B4A4C005F5E6100636262007675
      7400A5A6A50000000000000000000000000000000000FFFFFF00FFFFFF00FDFD
      FD00FFFFFF0090B2D2002892E100A0CFF000C3E6FB000898FA006EA7D400F9F7
      F700FCFDFE00FDFDFD00FFFFFF00000000000000000095959500070707000000
      00000A0A0A00262626002F2F2F003333330035353500363636002C2C2C000606
      0600040404008D8D8D000000000000000000FDFDFD00E8C1C100E03A3A00F901
      0100FC121200F9303000F7393900F73C3C00F63E3E00F6404000F7424200F732
      3200EB232300E0878700F5EDED0000000000565657004342450054535500DBDB
      DB00A3A3A300131314000F0F100012121300141416001F1E2100353438003E3D
      3F003A3A3B00ADADAE00000000000000000000000000FFFFFF00FEFEFE00FDFD
      FD00FEFEFE00E7EBF1004E94CE004FACEF0041B1FD00359BE300CBD4E100FFFF
      FF00FBFCFD00FEFEFE00FFFFFF000000000000000000C4C4C400161616000505
      05003131310046464600484848004B4B4B004D4D4D004F4F4F00525252003737
      370014141400BFBFBF00000000000000000000000000F3E2E200DD6B6B00EA18
      1800F6353500F54C4C00F5505000F5535300F4545400F4575700F4595900EE54
      5400DB5A5A00E5B6B600FCFCFC00000000007C7C7E00434145002D2D2E001515
      1500292B29006B6B6A0065656500292A29000C0C0C000C0D0C00131412002222
      22002E2D3000343336002D2C2F008685860000000000FFFFFF00FFFFFF00FEFE
      FE00FCFDFE00FDFDFD00A2BFDB003EA3EC003CB2FD007CABD800FCFAFA00FBFC
      FD00FEFEFD00FFFFFF00FFFFFF000000000000000000F7F7F700575757001010
      1000555555005C5C5C005E5E5E00616161006262620065656500656565003737
      37005A5A5A00F5F5F500000000000000000000000000FBF8F800E6B4B400DC52
      5200E9494900F25F5F00F3656500F3686800F36A6A00F16C6C00EC696900DC67
      6700D9969600F3E8E8000000000000000000D4D4D5005D5D5F00444246004141
      4000333433002A2C2B00363635006F6F6F00717170004B4B4A001B1C1B001C1D
      1C0031303400313033004C4B4E007E7E800000000000FFFFFF00FFFFFF00FFFF
      FF00FCFDFD00FDFEFE00E5E8F00060ACE5004BA7E700DADEE600FEFFFF00FCFD
      FD00FFFFFF00FEFEFE00FFFFFF00000000000000000000000000DDDDDD003E3E
      3E00444444006F6F6F0073737300757575007777770077777700545454004C4C
      4C00E0E0E0000000000000000000000000000000000000000000F7EEEE00E1A9
      A900DA6C6C00DC616100E46B6B00E9757500E5757500DC737300D67C7C00D69B
      9B00EEDDDD00FEFEFE00000000000000000000000000AEAEB0006C6B6E005656
      590053535400505051004D4E4F00464647004A4A4B0078787900828182004545
      430032323300A7A7A800000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FEFEFE00FCFDFD00FFFFFF00C2D8ED00ADC8E200FFFFFF00FDFDFD00FEFE
      FE00FEFEFE00FFFFFF00FFFFFF0000000000000000000000000000000000E4E4
      E4004E4E4E003D3D3D00737373007D7D7D00777777004848480063636300EBEB
      EB0000000000000000000000000000000000000000000000000000000000F8F2
      F200E9CBCB00DBA0A000D7929200D5919100D5989800D7A7A700E1C3C300F4EB
      EB00FEFEFE000000000000000000000000000000000000000000E6E5E600A8A8
      AA008D8C8E0088878900908F92009F9FA100A3A3A400C1C1C100DCDCDC00A4A4
      A50073737400908F8E00B2B2B100C9C9C90000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000F2F2F200B0B0B000777777006D6D6D0081818100BFBFBF00F9F9F9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FDFDFD00FCF9F900F1E9E900EADEDE00EEE5E500F9F5F500FDFCFC000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FEFEFE00FBFBFB0000000000000000000000000000000000000000000000
      000000000000EAE9E900C4C3C300C8C8C8000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C4BBB400B8ADA500B6AB
      A200B5A9A000B3A79E00B3A69D00B2A49B00B2A49B00B4A69E00B2A49B00B4A6
      9E00B6A9A200BDAFA900C2B8B000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C4BBB400B8ADA500B6AB
      A200B5A9A000B3A79E00B3A69D00B2A49B00B2A49B00B4A69E00B2A49B00B4A6
      9E00B6A9A200BDAFA900C2B8B00000000000C4BBB400B8ADA500B6ABA200B5A9
      A000B3A79E00B3A69D00B2A49B00B2A49B00B4A69E00B3A69D00B2A49B00B2A4
      9B00B4A69E00B6A9A200BDAFA900C2B8B00000000000A5999200F9F9FB00F7F7
      F800F7F7F700F6F6F700F6F6F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B4AAA100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5999200F9F9FB00F7F7
      F800F7F7F700F6F6F700F6F6F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B4AAA10000000000A5999200F9F9FB00F7F7F800F7F7
      F700F6F6F700F6F6F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B4AAA10000000000A69B9400FDFDFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A69B9400FDFDFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A69B9400FDFDFE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000B3A9A000FFFFFF00C9C9
      CA00D1D1D100D5D5D600D1D1D100D1D1D100D1D1D100FFFFFF00D1D1D100FFFF
      FF00FFFFFF00FFFFFF00B3A9A000000000000000000000000000000000000000
      00000000000000000000FDFDFD00FBFBFB00FAFAFA00FAFAFA00FCFCFC00FEFE
      FE000000000000000000000000000000000000000000A69B9400FEFEFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A69B9400FEFEFE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D1D1D100D5D5D600DFDF
      DF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000A69B9400FEFEFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000C8C8C80095959500767776007171
      71007A7A7A007879790074747400747474007273720075757600777777006D6D
      6C0069686800666666008A898900C8C8C80000000000A69B9400FFFFFF00FFFF
      FF00FFFFFF006B6AC0006B6AC000A7A6DA008E8E8E008E8E8E00B5B5B500FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A69B9400FFFFFF006B6AC0006B6A
      C000A7A6DA008E8E8E008E8E8E00B5B5B500FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000A69B9400FFFFFF00C9C9
      CA00CFCFCF00D1D1D100D5D5D600DFDFDF00FFFFFF00D1D1D100D1D1D100D1D1
      D100FFFFFF00FFFFFF00B3A9A000000000009796950000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFE000000
      0000000000000000000000000000736F6C0000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF008782E8008782E800B5B3F200A6A6A600A6A6A600BDBDBD00FFFF
      FF00FFFFFF00FFFFFF00B4AAA10000000000A79B9400FFFFFF008782E8008782
      E800B5B3F200A6A6A600A6A6A600BDBDBD00FFFFFF00C9C9CA00CFCFCF00D1D1
      D100D5D5D600DFDFDF00FFFFFF00B4AAA10000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B4AAA1000000000087868500E5E8E700727171009A9E
      9D009A9A9D008F929200A6A5A400ABB2B100B4B4B300BDBDBC00C8CBCB008383
      8600A4A5A10078777800E5E8E7007572730000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF00A7A2ED00A7A2ED00C6C1F200C1C1C100C1C1C100CFCFCF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00A7A2ED00A7A2
      ED00C6C1F200C1C1C100C1C1C100CFCFCF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF006B6A
      C0006B6AC000A7A6DA008E8E8E008E8E8E00B5B5B500FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A8A8A700ECE9EB00F6FAF700DFDC
      DF009B9B9B00E3E3E300A1A1A100E5E3E500A4A4A500E3E3E3009D9D9D00E6E6
      E6008D8D8D00EDF1F100ECE9EB00A5A5A40000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF00D3AB8600D3AB8600E3C6AB0087B8720087B872007BCD7600FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00D3AB8600D3AB
      8600E3C6AB0087B8720087B872007BCD7600FFFFFF00C9C9CA00D1D1D100D5D5
      D600DFDFDF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF008782
      E8008782E800B5B3F200A6A6A600A6A6A600BDBDBD00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000B3B3B200E9E9E700CFD2CF00999B
      9900E2E2E2009A9D9A00DDDBDD009E9E9E00DCDCDC00B0B0B000E2E1E200B3B5
      B300DBDCDB009EA29E00E9E9E700A4A2A30000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF00DAB89300DAB89300E3C4A70098C2860098C2860081CA7200FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00DAB89300DAB8
      9300E3C4A70098C2860098C2860081CA7200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00A7A2
      ED00A7A2ED00C6C1F200C1C1C100C1C1C100CFCFCF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A9A9A800EDE9EC00CDCCCD00E8E8
      E800ABACAB00E6E8E600AEB2AE00EBEAEB00B3B6B300E9E8E900B3B3B300EAE9
      EA00BEBEBE00F1F1F100EDE9EC00A7A7A70000000000A79B9400FFFFFF00FFFF
      FF00FFFFFF00E5C8AA00E5C8AA00E8CFB400B2CBA200B2CBA20096CC8800FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00E5C8AA00E5C8
      AA00E8CFB400B2CBA200B2CBA20096CC8800FFFFFF00C9C9CA00CFCFCF00D1D1
      D100D5D5D600DFDFDF00FFFFFF00B3A9A00000000000A79B9400FFFFFF00D3AB
      8600D3AB8600E3C6AB0087B8720087B872007BCD7600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000AEAEAE00F0F5F00088888800C1C1
      C100AFAFAF00ABABAB00BCBCBC00ABABAB00B7B6B700B4B8B400A4A3A400AFAF
      AF00B3B3B300BBB8BB00F0F5F000B0AFB00000000000A79C9500FEFEFE00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000A79C9500FEFEFE00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00B3A9A00000000000B3A9A000FFFFFF00DAB8
      9300DAB89300E3C4A70098C2860098C2860081CA7200FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000BBBBBB0000000000D0D0D200BEBE
      BE00C9CDC900E1E1E100DBDBDB00CACACA00DBDBDB00D7D6D700D4D8D400DEDD
      DE00B1B1B100C8CDC80000000000BABABA0000000000A2969000E1E1E200E3E2
      E200E4E4E400E5E5E500E6E7E700E8E7E800E9E9E900EAEAEA00ECECEC00ECED
      EC00EDEDED00F0F1F100AFA69E0000000000A2969000E1E1E200E3E2E200E4E4
      E400E5E5E500E6E7E700E8E7E800E9E9E900EAEAEA00EBEBEB00EBECEC00ECEC
      EC00ECEDEC00EDEDED00F0F1F100AFA69E0000000000A79C9500FEFEFE00E5C8
      AA00E5C8AA00E8CFB400B2CBA200B2CBA20096CC8800FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00B3A9A00000000000B1B1B10000000000000000000000
      000000000000BDBDBD00FAFAFA00C9C9C900F1F1F100F9F9F900CDCACB000000
      0000000000000000000000000000A4A4A40000000000A0918700D2C7BE00CDC0
      B600C8BAAF00C4B4A800BFAFA300BCAA9D00B9A69800B9A69900C3B3A700CDC0
      B700D2C7BF00D7CDC600AB9D920000000000A0918700D2C7BE00CDC0B600C8BA
      AF00C4B4A800BFAFA300BCAA9D00B9A69800B9A69900BCAA9E00BFAEA300C3B3
      A700CDC0B700D2C7BF00D7CDC600AB9D920000000000A2969000E1E1E200E3E2
      E200E4E4E400E5E5E500E6E7E700E8E7E800E9E9E900EAEAEA00ECECEC00ECED
      EC00EDEDED00F0F1F100AFA69E0000000000C8C8C800DAD9D900CCCCCB00CFCE
      CE00D2D2D200CFCFCF00D1D1D100D3D3D300D3D3D300D1D1D100CDCDCF00D2D3
      D200D1CFCF00CDCDCD00D5D5D500D4D4D40000000000C7BEB600B9ADA500B8AB
      A300B6AAA100B5A89F00B4A79D00B3A59C00B2A49A00B2A49A00B4A89E00B7AB
      A200B8ACA400BAAEA600C4BAB20000000000C7BEB600B9ADA500B8ABA300B6AA
      A100B5A89F00B4A79D00B3A59C00B2A49A00B2A49A00B3A59C00B3A69D00B4A8
      9E00B7ABA200B8ACA400BAAEA600C4BAB20000000000A0918700D2C7BE00CDC0
      B600C8BAAF00C4B4A800BFAFA300BCAA9D00B9A69800B9A69900C3B3A700CDC0
      B700D2C7BF00D7CDC600AB9D9200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C7BEB600B9ADA500B8AB
      A300B6AAA100B5A89F00B4A79D00B3A59C00B2A49A00B2A49A00B4A89E00B7AB
      A200B8ACA400BAAEA600C4BAB200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E5DFDC00A99F
      9C00ABA2A000ABA2A000ABA29F00ABA29F00ABA29F00ABA19E00ABA19E00ABA1
      9E00A89E9A00B4ACAA0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A23
      2800303A40000000000000000000000000000000000000000000707070000707
      0700000000000000000000000000000000000000000000000000E3DBD800F2F0
      EE00F2F0EF00F2F0EF00F2F0EE00F2EFEE00F2EFEE00F2EFED00F1EEED00F1EE
      ED00F1EEEC00A499960000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004E57
      5B000066A300060A0D007274760000000000000000003A3A3A00646464001616
      1600000000000000000000000000000000000000000000000000EAE2DF00FDFC
      FB00C4C4C400C8C8C800C8C8C800C2C2C100B9B8B700B6B4B400B2B0AF00C0B9
      B700FCFAF900ABA09D00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E9007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      00000F3D52000196F2000D3C5800303940000D0D0D00C4C4C400CACACA003434
      3400000000000000000000000000000000000000000000000000E9E2DF00FCFB
      FA00F4F3F200F4F3F300F3F3F200FBFAF900FDFBFA00FAF8F600F9F6F500F8F5
      F400F7F3F100ABA09D00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E9007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      00000306070001B9FF0001A7FF000075BE00F2F2F200F2F2F200767676007676
      7600000000000000000000000000000000000000000000000000E9E2DF00FDFC
      FB00C5C5C500C8C7C600C6C4C300C5C2C10000000000FDFCFB00FDFBFA00FBF8
      F700F7F3F100ABA09D00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000334043000191BB0001BAFF0001B5FF00F2F2F200F2F2F200343434000000
      0000000000000000000000000000000000000000000000000000E9E2DF00FCFB
      FA000000000000000000000000000000000000000000FDFCFB00FDFBFA00FBF8
      F700F7F2F100AAA09D00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F7F000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000006E72
      73000E24280002D8FF0002D8FF0002D8FF00F2F2F200F2F2F2006D6D6D003434
      3400000000000000000000000000000000000000000000000000E9E2DF00FAF9
      F800C4C4C400C8C8C800C8C8C800C2C2C100B9B8B700B6B4B400B2B0AF00C0B9
      B700F6F2F100ABA09E00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000004B5658000F4A
      550002CFF50002E3FF0002E3FF0002DEFF00F2F2F200F2F2F200F2F2F200CACA
      CA00070707007C7C7C0000000000000000000000000000000000E9E1DF00F3F1
      F100EFEDED00EFEDED00EFEDED00EFEDED00F1EFEF00FCFAF800FCF9F800FAF7
      F600FCFBFA00AAA09D00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F000000000000000000000000001D292B000663730002A5
      C10002C9E50017D1E70023E7FF0010E5FF00F2F2F200F2F2F200E2E2E200B2B2
      B200B2B2B2004343430067676700000000000000000000000000E9E1DF00FDFC
      FB00C4C4C400C8C8C800C8C8C800C2C2C100B9B8B700B6B4B400B2B0AF00C0B9
      B700FCFBFA00AAA09C00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F000000000000000000000000003D4A4C003D4A4C002D3B
      3D000F1719000F181900095F6D0002D8FF00F2F2F2001F1F1F001C1C1C004C4C
      4C004C4C4C004C4C4C005E5E5E00000000000000000000000000E9E1DF00FCFB
      FB00F4F3F200F4F3F300F3F3F200FBFAF900FDFBFA00FAF8F600F9F6F500F8F5
      F400F8F5F400A99F9C00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000000914160002D8FF007C7C7C0064646400000000000000
      0000000000000000000000000000000000000000000000000000E9E1DF000000
      0000C5C5C500C8C7C600C6C4C300C5C2C10000000000FDFCFB00FDFBFA00FBF8
      F700FAF7F600A89E9B00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000033414300019DBB003D3D3D0000000000000000000000
      0000000000000000000000000000000000000000000000000000E9E1DF000000
      00000000000000000000000000000000000000000000FDFCFB00FDFBFA00FBF8
      F700FAF7F600A89E9C00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000009D9D9D000C5361001C1C1C0000000000000000000000
      0000000000000000000000000000000000000000000000000000E9E1DF00FBFA
      F900C4C4C400C8C8C800C8C8C800C2C2C100B9B8B700B6B4B400B2B0AF00C0B9
      B700FDFBFA00ABA09E00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F8007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      000000000000000000000000000001010100656B6D0000000000000000000000
      0000000000000000000000000000000000000000000000000000E9E2DF000000
      00000000000000000000000000000000000000000000FDFCFB00FDFBFA00FBF8
      F700FAF7F600A49B9800000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F8007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000767979000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EAE3E000E9E1
      DF00E9E1DF00E9E1DE00E7DFDD00E3DAD800E1D8D400E1D8D400E0D7D400DFD5
      D200DED3D000DED5D30000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EFE8E000D5C6BD00CBBCB500CBBCB500D5C6BD00EFE8E0000000
      000000000000000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF000000FF6AA4CCFF70D1FCFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001A23
      2800303A40000000000000000000000000000000000000000000696D70000305
      070000000000000000000000000000000000000000000000000000000000F0E8
      E4009B8BB3007B7CE300ADB3FF00DEE3FF00E1E5FF00AFB5FF007A7BE4009989
      B200F0E8E300000000000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
      00FF000000FF74B1DBFF74CFF6FF4097D7FF0000000000000000000000002828
      2800404040000000000000000000000000000000000000000000707070000707
      0700000000000000000000000000000000000000000000000000000000004E57
      5B000066A300060A0D007274760000000000000000002A323A000B3764000910
      1600000000000000000000000000000000000000000000000000E1D3D000504D
      C3003A48FF007880FF00B5B8FF00E2E3FF00E4E5FF00B7BBFF007880FF003543
      FC004A46BD00E1D3D0000000000000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FF000000FF998A90FFBCAB9DFFC1B1
      ACFFC0C5CEFF66A6D1FF419FE1FF000000FF0000000000000000000000005B5B
      5B00A3A3A3000D0D0D007676760000000000000000003A3A3A00646464001616
      1600000000000000000000000000000000000000000000000000000000000000
      00000F3D52000196F2000D3C580030394000060A0D000063C4000066CA00252C
      34000000000000000000000000000000000000000000F0E8E5004540BA00212E
      E1003139E300575FFC00A2A6FF00D0D2FF00D0D2FF00A2A7FF00575EFC002C34
      DE001825D7003D38B200EFE6E30000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FF000000FFDEC393FFFEFEB7FFFEFEDBFFF8F7
      E2FFBFA39AFFBBB3B7FF000000FF000000FF0000000000000000000000000000
      000052525200F2F2F20058585800404040000D0D0D00C4C4C400CACACA003434
      3400000000000000000000000000000000000000000000000000000000000000
      00000306070001B9FF0001A7FF000075BE000087FF000081FF00043E76007274
      760000000000000000000000000000000000000000008572A6000E1CD1001A22
      CB002932DA00A2A6F700FCFCFF000000000000000000FCFCFF00A0A4F700242C
      D400141CC4000312C700806CA20000000000000000FF000000FF000000FF0000
      00FF000000FF000000FF000000FFF6D696FFFEE398FFFEF5B7FFFEFED2FFFEFE
      F1FFFBF7E9FFCBC2C2FF010005FF000000FF0000000000000000000000000000
      000007070700F2F2F200F2F2F200BEBEBE00F2F2F200F2F2F200767676007676
      7600000000000000000000000000000000000000000000000000000000000000
      0000334043000191BB0001BAFF0001B5FF00019DFF000081FF000F2234000000
      000000000000000000000000000000000000EBE0E0001719B000050FBA000E16
      C200A5A8EC0000000000B3B6F3006C72EF006C72EE00B2B5F20000000000A1A4
      E9000810BD000009B0000F119F00EAE0DF00000004FF010106FF000004FF3434
      38FFCDCDCFFFF2F2F2FF8F8F94FFE8C088FFFEE7A1FFFCF1B8FFFEFDD2FFFEFE
      DBFFFEFEE2FFCDC0B6FF01010FFF000003FF0000000000000000000000000000
      000043434300BBBBBB00F2F2F200F2F2F200F2F2F200F2F2F200343434000000
      0000000000000000000000000000000000000000000000000000000000006E72
      73000E24280002D8FF0002D8FF0002D8FF0001B3FF000094FF00083B6D00252C
      340000000000000000000000000000000000BDA8B9000008A2000002A4003C42
      C800000000009EA2EA00151ED0001E26D5001D26D400131CCE009EA1E8000000
      0000373EC3000001950000058500BBA6B50001010AFF03032FFF01010EFF0303
      24FF31305FFFC8C8D0FF03032CFFF6CC8CFFFEEEAAFFFEFDDAFFFDF6C4FFFEFC
      C2FFFEFEC6FFDACFC0FF020219FF02010FFF0000000000000000000000007373
      730028282800F2F2F200F2F2F200F2F2F200F2F2F200F2F2F2006D6D6D003434
      34000000000000000000000000000000000000000000000000004B5658000F4A
      550002CFF50002E3FF0002E3FF0002DEFF0001CBFF00019FFF00008CFF000066
      CA00030507007B7B7C0000000000000000009C85A8000006820000008C007478
      D300000000003A41CF00131BC8001C24CC001B23CB001119C6003940CD000000
      00007276D1000000880000057B009B84A40001010BFF060636FF030318FF0202
      12FF1B1B25FFCDCDE1FF060635FFFEE3B0FFF8D28CFFFEF5BBFFFCEBACFFFEEE
      A2FFF9E8A6FF04044CFF232373FF060636FF0000000000000000555555005858
      5800F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200F2F2F200CACA
      CA00070707007C7C7C000000000000000000000000001D292B000663730002A5
      C10002C9E50017D1E70023E7FF0010E5FF0002CFFF0001B1FF00018CE2000066
      B200005CB200102A43005D626700000000009B84AA000009A100000099007075
      D300000000003940CB000C15C300272FCD00272ECD000911C000393FC9000000
      00006E72CD00000095000008A4009A82A8000A0A14FF07076CFF050531FF0302
      18FF1D1D3DFFC9C9E7FF282865FFD2D4D4FFFBDAABFFF2CA8CFFFEDB90FFEDD0
      A0FF1A1A92FF0C0B50FF0F0F92FF161666FF000000002525250073737300B2B2
      B200DCDCDC00E5E5E500F2F2F200F2F2F200F2F2F200F2F2F200E2E2E200B2B2
      B200B2B2B200434343006767670000000000000000003D4A4C003D4A4C002D3B
      3D000F1719000F181900095F6D0002D8FF0001C6FF000C1A1F0011181C003D46
      4C003D464C003D464C0052595E0000000000BBA4BA00020FBC000002A9003037
      BD00000000009B9FE7001720D400C4C6F500C1C3F5001A22D300AAADE900FEFE
      FD002C32BB000002AA00000CB800B9A2B8001D1D21FF1C1C4DFF090933FF0303
      0EFF1C1C23FFDADADEFF86868FFFDEDEDFFF757577FF0F0F17FFC7C7D1FF2727
      8DFF030319FF020211FF04031EFF040328FF000000004C4C4C004C4C4C004C4C
      4C0022222200191919006D6D6D00F2F2F200F2F2F2001F1F1F001C1C1C004C4C
      4C004C4C4C004C4C4C005E5E5E00000000000000000000000000000000000000
      000000000000000000000914160002D8FF00025E7C005A616400000000000000
      000000000000000000000000000000000000E7DBDF00191CB600050FBA000008
      B400A1A5E700000000008E93F800DCDEFF00DEDFFF00B5B8FA00000000008C90
      E1000006B4000610BA001619B300E6DADE002B2C2CFF2D2D30FF29292DFF1818
      19FF363636FFF9F9F9FFE6E6E6FF979797FF161616FF131313FFCCCCCDFF1C1C
      28FF010005FF000001FF000001FF000004FF0000000000000000000000000000
      0000000000000000000016161600F2F2F2007C7C7C0064646400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000033414300019DBB0010323D0000000000000000000000
      000000000000000000000000000000000000000000007C65A7000D1CCE00121A
      C200333BDF00A8ACFE009FA3FF00E5E6FF00E7E7FF00B6B9FF009A9EFC002932
      DD00121AC1000B1BCC007861A500000000003B3C3CFF3C3D3DFF3D3E3EFF6364
      64FFE4E4E4FFFEFEFEFFBEBEBEFF202020FF1A1A1AFF979797FFF3F3F3FFB7B7
      B7FF1F1F1FFF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000043434300BBBBBB003D3D3D0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009D9D9D000C53610011191C0000000000000000000000
      00000000000000000000000000000000000000000000EADEE1003933B8002230
      DE004149F2006269FF00969BFF00F3F4FF00F2F2FF009499FF00676EFF00464E
      F500222FDF003430B600E9DEE10000000000494A4AFF4D4E4EFF4D4E4EFF4D4E
      4EFF4E4E4EFF4B4C4CFF3D3E3EFF2F2F2FFF161616FF030303FF000000FF0000
      00FF000000FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000616161001C1C1C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000001010100656B6D0000000000000000000000
      0000000000000000000000000000000000000000000000000000D7C5CD004843
      C800505FFF00838AFF00AFB3FF00D8DAFF00D7DAFF00B0B3FF008890FF005866
      FF004844CA00D6C4CC000000000000000000585959FF5B5B5BFF5B5B5BFF5B5B
      5BFF5B5B5BFF5B5B5BFF5B5C5CFF595959FF4E4E4EFF414141FF2D2D2DFF1313
      13FF030303FF000000FF000000FF000000FF0000000000000000000000000000
      0000000000000000000000000000010101006D6D6D0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000767979000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E8DC
      DF008C76B5007879E800A3ACFF00C1CAFF00C2CAFF00A6AFFF007C7EE9008D78
      B500E8DCDF000000000000000000000000005D5D5DFF5E5E5EFF5E5E5EFF5E5E
      5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5D5D5DFF5D5D5DFF595959FF5454
      54FF4C4C4CFF3F3F3FFF292929FF131313FF0000000000000000000000000000
      0000000000000000000000000000797979000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E5D8DD00C1AABC00B299B600B299B600C1A9BC00E5D8DD000000
      0000000000000000000000000000000000005E5E5EFF5E5E5EFF5E5E5EFF5E5E
      5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E
      5EFF5E5E5EFF5E5E5EFF5E5E5EFF5E5E5EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E5D1B900DDB68900E1B27D00E1B27D00DDB68900E5D1B9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000002E319E00060992000609
      9200060992000609920006099200060992000609920006099200060992000609
      920006099200060992002E319E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E2CD
      BC00D48A5200D3763B00DE875A00EF9B7400F19D7700E18B5F00D3773F00CF87
      4F00E2CDBB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003134A300080D9F000B12AF000D15
      B9000D15B9000D15B9000D15B9000D15B9000D15B9000D15B9000D15B9000D15
      B9000D15B9000B12AF00080D9F003134A3000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D7B7A100CB69
      2B009E3E10008B300B00A1431C00B3532B00B6552D00A6482100903510009A3A
      0E00C1612500D7B6A00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000090EA2000E16B5001019BE001019
      BE001019BE001019BE001019BE001019BE001019BE001019BE001019BE001019
      BE001019BE001019BE000E16B500090EA2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E0CBBF00C2622900822C
      0700751A000080250100A7644900C99A8600CA9B8700A9664A0081260200771B
      00007F290500B4572200E0CABF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000B11AA00121DC300121DC300151D
      C3001B24C300161FC300121DC300121DC300121DC300121DC3001C25C3002029
      C3001F28C300121DC300121DC3000B11AA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2754C007E320E005D13
      000081371D00DFC7BE00FFFFFF00FEFFFF00FEFEFF00FFFFFF00DFC8BF008337
      1D0061140000742B0900B66D4600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001000500010109000100
      0500000005000101090001000500000000000D14B1001521C6008C8FCF00FCFC
      FE00FFFFFF00FFFFFF00D4D5ED001D24C6005055C600DFE0F100FFFFFF00FFFF
      FF00FFFFFF00E2E3F2003C41C6000D14B100000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000000000000000000000000000DDC4BC00A04C1F004A1300005D1D
      0900E0D1CB00FEFEFE00AB7C6A0080341B0081341A00AB7C6A00FDFEFE00E0D2
      CB005F1E09004A1200008B3F1700DCC3BB000000040001010600000004003434
      3800CDCDCF00F2F2F2008F8F940013121E0002020D0084838D00F1F1F5001D1D
      2B000202110016165B0001010F00000003000E17B9005B60C600FFFFFF00A1A4
      D500151D9600252C9D00969AD7002D34C100F6F7FB00CCCDE800242C9B000F17
      9500272E9800F9F9FC00A7AADA000E17B7000000000000000000FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000C6948200703213002D0200008766
      5700FFFFFF009F7666005A0800006A1A00006C1B00005F0A0000A4786500FFFF
      FF008A6757003002000059250C00C0907F0001010A0003032F0001010E000303
      240031305F00C8C8D00003032C0006061E005D5C7200DBDBDE00FEFEFE001D1D
      300004045600020233000202190002010F00111AC000A2A6D900FFFFFF001C27
      BD001927C6001825C000121DB6009A9ED500FCFCFE00353DB1001825BD002833
      C500565EC100FFFFFF009499D600101AB8000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000B97C670051220C0036060000B79D
      9200FFFFFF00914424008B320F0091361000923711009036110098482700FFFF
      FF00C4A395005E16010061260B00B177640001010B0006063600030318000202
      12001B1B2500CDCDE100060635004F4FAA00C6C6CC00CFCFDB00F1F1F7001F1E
      41003030B10004044C002323730006063600121DC700B1B5E000EEEFF8001A2B
      C9001C2DD5001C2DD4001929C200E6E7F400C7CAE7003741BF00D5D7EE00FFFF
      FF00FFFFFF00ACB0E0002C37C100121DBE0000000000FFFFFF00FFFFFF000000
      0000FFFFFF00000000000000000000000000FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000BB7D6900974319008B2D0600CFA2
      8F00FFFFFF00B2644300A1421900B1603E00B1613F00A2421900B3664500FFFF
      FF00D1A4910097350B00A6481B00B77A66000A0A140007076C00050531000302
      18001D1D3D00C9C9E70028286500CFCFE800D7D7DA006D6D8E00D4D4EB00201F
      4C001A1A92000C0B50000F0F9200161666001521CE009A9FDA00FCFCFE002B38
      CF001F31DA001F31DA00565FCE00FFFFFF007980CB00ACB1DF00F7F7FB006870
      C5002E3ABB001826BA001D2ECE001521CD0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000C28E8400C0623000A3451E00BF79
      5B00FFFFFF00DEB9A900B1512900EFDBD300EFDBD200B4573000E4C5B700FEFF
      FF00C0785A00A74A2300B75C2F00BE8C82001D1D21001C1C4D00090933000303
      0E001C1C2300DADADE0086868F00DEDEDF00757577000F0F1700C7C7D1002727
      8D00030319000202110004031E00040328001725D4003B4AD300FFFFFF00B6BA
      E300303EDE003848DD00DCDEF100ECEDF8001F30BF00ABB1E100E9EAF6003945
      CC004754D200E4E6F6007983DC001725D400000000000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF000000000000000000D7BDBD00D3794A00C96F4800C86A
      4300EDC9BA00FFFFFF00FEA58100F7E4DD00F7E6DF00FEA58100FFFFFF00E9BE
      AB00CB6C4500CC724C00CB724600D6BCBC002B2C2C002D2D300029292D001818
      190036363600F9F9F900E6E6E600979797001616160013131300CCCCCD001C1C
      2800010005000000010000000100000004001A28DB002236D7007580D800F4F5
      FB00FFFFFF00FFFFFF00D9DCF2004E5DD0002034CF003F4FD000DFE1F400FFFF
      FF00FFFFFF00E2E4F5003F4FD9001A28DB00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000C0785F00F39C7100E88B
      6400E9906A00F8C4AF00FEA58100FCEBE400FCECE500FEA58100F7BEA600EA8D
      6500EB8E6800F49C7200BB745D00000000003B3C3C003C3D3D003D3E3E006364
      6400E4E4E400FEFEFE00BEBEBE00202020001A1A1A0097979700F3F3F300B7B7
      B7001F1F1F000000000000000000000000001C2CE200263DE6001F32BD001C2C
      A8002635A7002A3BB7001E30B7002135CB00243ADD001F31BE001B2BA5002837
      A6002837A9001F31BA00253BE2001C2CE2000000000000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000000000000000000000000000D9C2C200E2906800FFB6
      9100FEA88500FDA27E00FEA68200FFEFE900FFEFE900FEA58100FDA48000FFAA
      8800FFB79300DD8A6600D8C2C20000000000494A4A004D4E4E004D4E4E004D4E
      4E004E4E4E004B4C4C003D3E3E002F2F2F001616160003030300000000000000
      0000000000000000000000000000000000001F30E7002941EB00283FE500273E
      E000273DDF00273DDF00273EE000283FE5002940EA00283FE500273EE000273D
      DF00273EE000283FE5002941EB001F30E7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9A7A400DF9B
      7900FFCEB200FFC8AF00FFC2A900FFCCB700FFCCB700FFC2A900FFC9B100FFCF
      B400DB977800C8A5A3000000000000000000585959005B5B5B005B5B5B005B5B
      5B005B5B5B005B5B5B005B5C5C00595959004E4E4E00414141002D2D2D001313
      1300030303000000000000000000000000002135EE004459F2002B45F1002B45
      F1002B45F1002B45F1002B45F1002B45F1002B45F1002B45F1002B45F1002B45
      F1002B45F1002B45F1004459F2002135EE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D7C0
      BF00C2877600ECB89E00FFD6C000FFDBC700FFDCC700FFD6C100EAB69E00BF85
      7500D7BFBF000000000000000000000000005D5D5D005E5E5E005E5E5E005E5E
      5E005E5E5E005E5E5E005E5E5E005E5E5E005D5D5D005D5D5D00595959005454
      54004C4C4C003F3F3F0029292900131313005263ED003E51F6006375F9006577
      F9006577F9006577F9006577F9006577F9006577F9006577F9006577F9006577
      F9006577F9006375F9003E51F6005263ED000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6BDBD00C1969100BE8D8500BE8D8400C0969000D6BDBD000000
      0000000000000000000000000000000000005E5E5E005E5E5E005E5E5E005E5E
      5E005E5E5E005E5E5E005E5E5E005E5E5E005E5E5E005E5E5E005E5E5E005E5E
      5E005E5E5E005E5E5E005E5E5E005E5E5E00EFF1FC005466F100263EF900263E
      F900263EF900263EF900263EF900263EF900263EF900263EF900263EF900263E
      F900263EF900263EF9005466F100EFF1FC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A2A2A2008C8C8C009595
      95009A9996009F9F9800969695009494940094939300959594009E9D96009896
      9300939191008A898900A1A1A100000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084B094002472
      4100196B37002472410084B09400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094AFE300225C
      C1000442BC001E59C00086A6DD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099999900F1F1F100FFFF
      FF00D0CEEB008D8ACF00EAE8F400FFFFFB00FFFFFA00E8E5EE008B85CA00CDC6
      E000FCF3EF00FCF9F700999898000000000000000000DFB49200D49D7400D196
      6800CE926300CB8E5E00C98A5B00C7875600C38452006B774400288C530064BA
      8D0095D2B20064BA8D00288C530080AD910000000000DFB49200D49D7400D196
      6800CE926300CB8E5E00C98A5B00C7875600C38452006E6D8B002765C7002177
      E6000579EA000164DD00054DBC0086A6DD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000424241009C9B9A0000000000000000009A9A9A00FBFBF500CCCC
      EA003A39BB000002BF005450B900F0ECEE00EFEBEC00534FB7000000C1003E3C
      BC00C4BCD900FCF9F7009A9999000000000000000000D7A17500F8F2ED00F7F0
      EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D80022703E0062BA8B0060BA
      8700FFFFFF0060B9870067BC8F00206F3D0000000000D7A17500F8F2ED00F7F0
      EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D8001D56BC00639DF400187F
      FF000076F8000076EE000368E1001D58C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424242007B7A7A000000000000000000000000009A9A9A00FBFCF500CCCA
      E8003637C7002B33DE000000BC005550B9005651B8000000BC002021D8002F2D
      C800BFB7D600FCF9F7009A9999000000000000000000D9A47A00F9F3EE00EBD2
      BE00FFFFFF00EBD3BF00FFFFFF00FFFFFF00FFFFFF00317B4C009CD4B600FFFF
      FF00FFFFFF00FFFFFF0095D2B200196B370000000000D9A47A00F9F3EE00EBD2
      BE00FFFFFF00EBD3BF00FFFFFF00FFFFFF00FFFFFF000543BC00AECDFE00FFFF
      FF00FFFFFF00FFFFFF00187FEF000442BC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004444
      42006F6F6D00000000000000000000000000000000009A9A9A00F0F0F000FFFF
      FF00C2BFDF003B3CCA002D33D7000508B2000406B2002629D7003636CA00BAB2
      D600FFF7EE00FCF9F7009A9999000000000000000000DDA87E00F9F3EF00EBD0
      BA00EBD0BB00EBD0BB00EBD0BB00EBD0BB00EBD1BD004989600090D3B10092D6
      B100FFFFFF0065BC8C0067BC8F00206F3D0000000000DDA87E00F9F3EF00EBD0
      BA00EBD0BB00EBD0BB00EBD0BB00EBD0BB00EBD1BD002256B8008DB5F6004D92
      FF001177FF002186FF00408AEB00235CC2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000444444005F5D
      5D0000000000000000000000000000000000000000009A9A9A00F1F1F100FFFF
      FE00FFFFFD008982C4001A26CB001520C4000A12C4000F18CC00857EBE00FFFD
      F000F2E9E800FCF9F7009A9999000000000000000000DFAA8200F9F3EF00EACE
      B700FFFFFF00EBD0BB00FFFFFF00FFFFFF00FFFFFF009DAF910061AB810095D4
      B400BAE6D0006ABB8F002D8F570080AD910000000000DFAA8200F9F3EF00EACE
      B700FFFFFF00EBD0BB00FFFFFF00FFFFFF00FFFFFF008B97BF003D76D2008DB5
      F700B8D6FE0072A8F5002F6BCA0093AEE1000000000000000000000000000000
      0000000000000000000000000000000000000000000048484800504F4D000000
      000000000000000000000000000000000000000000009A9A9A00F0F0F100FFFF
      FF00EAE9F1005D5ABA002235DA00475AE6003F52E5000C1DD9005955B800E5DD
      E100F8EFE800FCF9F7009A9999000000000000000000E1AE8700FAF4F000EACB
      B200EACCB300EACCB300EACCB300EACCB300EACEB700E8C7AC00A2AE8E005F97
      71004F8E660049895F007B7F4F000000000000000000E1AE8700FAF4F000EACB
      B200EACCB300EACCB300EACCB300EACCB300EACEB700E8C7AC008993B700285B
      BE000543BC001E57BD0069678400000000000000000000000000000000007C7A
      7A008D807900A288800097857D0099959500515151005B5B5A00000000000000
      000000000000000000000000000000000000000000009A9A9A00F6F6F300EFEF
      FA005A59BE003547DC005C74F7004048C8003D45C7004055EF000618DB00504C
      B500DED6DE00FCF9F7009A9999000000000000000000E3B18C00FAF6F100EAC9
      AE00FFFFFF00EAC9B000FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F1E5DB00C68655000000000000000000E3B18C00FAF6F100EAC9
      AE00FFFFFF00EAC9B000FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F1E5DB00C6865500000000000000000000000000A3999600FFFD
      EA00FFFFFF00FFFFFF00FFFFFF00FFF4DF00958C8800ACADAD00000000000000
      000000000000000000000000000000000000000000009A9A9A00FFFFF700AEAB
      DC002932C3006E84F700444BC900979AE100999BDF003E47C9003D55F100000D
      C700A49BC500FCF9F700999998000000000000000000E5B48F00FAF6F200E9C6
      AA00E9C6AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E8C8
      B000E8CCB500F2E7DE00C88A59000000000000000000E5B48F00FAF6F200E9C6
      AA00E9C6AC00EAC7AC00E9C7AD00E9C9AE00E9C9B000E8C7AC00E9C9B000E8C8
      B000E8CCB500F2E7DE00C88A590000000000000000007F7E7E00FFF9E800FFFF
      FF00FFFFEB00FFFFFD00FFFFFF00FFFFFF00FFE2C80095908D00000000000000
      000000000000000000000000000000000000000000009A9A9A00F6F6F200EDEE
      FC006664C2003A3DBF00989DE500FFFFFF00FFFFFD009597DD002F36C0006663
      BF00D6CDD600FCF9F700989797000000000000000000E7B79400FBF7F400E9C3
      A600FFFFFF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F7F1EB00CB8F5F000000000000000000E7B79400FBF7F400E9C3
      A600FFFFFF00E8C4A900FFFFFF00FFFFFF00FFFFFF00E8C7AC00FFFFFF00FFFF
      FF00FFFFFF00F7F1EB00CB8F5F000000000000000000A0949000FFFFFF00FFFF
      FC00FFFFEE00FFFFFF00FFFFFD00FFFFFF00FFFFFF00A7979000000000000000
      000000000000000000000000000000000000000000009A9A9A00F0F0F000FFFF
      FF00F3F3F900D5D4EC00FFFFFF00FEFEFE00FEFDFA00FCF9F700CEC6DD00E5DF
      E100E6DBD500FCF9F700989898000000000000000000E9BA9800FBF7F400E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600E9C3A600FBF7F400CE9364000000000000000000E9BA9800FBF7F400E9C3
      A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3A600E9C3
      A600E9C3A600FBF7F400CE9364000000000000000000AEA09C00FFFFFF00FFFF
      FF00FFFFFF00FFFFFB00FFFFFF00FFFFFF00FFFFFF00A5959000000000000000
      000000000000000000000000000000000000000000009A9A9A00F0F0F000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FEFEFD00FCFBFA00FBF7F400FFFCF500FAF8
      F400ECE4E100FCF9F700979796000000000000000000EBBD9B00FBF7F400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FBF7F400D1976A000000000000000000EBBD9B00FBF7F400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FBF7F400D1976A0000000000000000008F878500FFFFFF00FFFF
      FF00FFFFFD00FFFFFF00FFFFFF00FFFFFF00FFFFFF008F847F00000000000000
      000000000000000000000000000000000000000000009A9A9A00F0F0F000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FDFDFC00FBF9F800FCFAF900FCFAF900FBFA
      F900F5F0EF00FCF9F700999797000000000000000000ECBF9E00FBF7F4009CD5
      A50098D3A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1
      800076BE7C00FBF7F400D49B6F000000000000000000ECBF9E00FBF7F4009CD5
      A50098D3A10094D09D0090CE98008BCB930087C98E0082C689007EC384007AC1
      800076BE7C00FBF7F400D49B6F0000000000000000009B9B9B00F0E9E700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083808000000000000000
      000000000000000000000000000000000000000000009A9A9A00F0F0F000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FDFDFC00FBF8F600FBF8F600FBF8F600FBF8
      F700FCF9F700FCF9F7009A9999000000000000000000EFC5A800FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400D8A277000000000000000000EFC5A800FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400D8A277000000000000000000000000008F8D8F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0085807F0000000000000000000000
      0000000000000000000000000000000000000000000099999900F0F0F000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFDFC00FDF9F600FDF9F600FDF9F600FDF9
      F600FFFCF900F3EEEE00999999000000000000000000F7E0D100F0C7AC00EDC0
      9F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC
      8400DDA98000DCA57D00E1B695000000000000000000F7E0D100F0C7AC00EDC0
      9F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC
      8400DDA98000DCA57D00E1B6950000000000000000000000000000000000A9A9
      A9008483830092908F00908E8E008B8B8C000000000000000000000000000000
      00000000000000000000000000000000000000000000A2A2A2008C8C8C009595
      9500959595009595950095959500949493009492920094929200949292009492
      9200939292008B8A8A00A2A1A100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008C9BAA0072869700637B8E00637B8F00BCC2C500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008B99
      A500557E930056A5CA0055A7CF0057AAD20057ABD400427E9D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000040C5001544FF000550FF00304E8C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000424241009C9B9A000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000597F940057AC
      D400489AC5003788B5003788B4003685B200489AC50058799300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000194CBE00004DFF00004EE700586D9800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000424242007B7A7A00000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000000000000000000000005858
      58000000000058585800000000000000000000000000507F980053A6D1003E8C
      B7003D90BA003A8CB8003A8CB8003D91BD004C9EC9006D829600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007896D2000051DC000042B6009B9FC900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004444
      42006F6F6D000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000093A3AC003DA3D5000CC1E6000EC1
      E400328FC0003F93BD00426C81003E647B004FA6D1004087AA004F829D00497B
      980042789600477693008296A100000000000000000000000000000000000000
      000000000000000000008193B2000042BC0000369A00BAC1CA00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000444444005F5D
      5D00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000585858000A0A
      0A000A0B0A000A0A0A0058585800000000006691A80045BFEB000CDCFD0001D4
      F8002AA5D9004D9BC400456F8600395F750039759900499EC9004A9EC9005EB4
      DF005CB4DF005CB4DF005CB3DE007A94A3000000000000000000C07931000000
      00000000000000000000ADB6CD0000389600002F800000000000000000000000
      000000000000C079310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000048484800504F4D000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000171818001717
      1700171717001717170017181700000000006D9CB40060AFD70059B1D6005CB6
      E2005FACDD005CABD5005BACD3004D86A200E4EAED007BA1B3003084AC004A7E
      98004298C20042A2D10048A5D50048809F0000000000CC905900FFC995000000
      000000000000000000000000000000306C000029670000000000000000000000
      000000000000FFC99500CC905900000000000000000000000000000000007C7A
      7A008D807900A288800097857D0099959500515151005B5B5A00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000000000000000000000000000
      00002727260000000000000000000000000093ABB8006FC0E9005EADCD0047A5
      610042A24F004A9F91005DAEDD005AA6C9006AA1BA00EAEEF0005B8EA7005693
      B2005D6F7A006D76770053A4C900608AA300E3DCD300D58E4300000000000000
      0000D4883A000000000000000000002852000B284F000000000000000000D488
      3A000000000000000000D58E4300E3DCD3000000000000000000A3999600FFFD
      EA00FFFFFF00FFFFFF00FFFFFF00FFF4DF00958C8800ACADAD00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000038383800000000000000000000000000000000006DAFD50063B7AF003FA3
      2500349E1D0036993F006AB9E30066BADE005DAFCF0092A4AB00EEF2F300915E
      3E00CF5A1000B96928005DA1BD00A9B5C000C29F7D00FFD2A20000000000E6BE
      9400E6CBAE000000000000000000001E3B00304459000000000000000000E6CB
      AE00E6BE940000000000FFD2A200C29F7D00000000007F7E7E00FFF9E800FFFF
      FF00FFFFEB00FFFFFD00FFFFFF00FFFFFF00FFE2C80095908D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00004C4B4C0000000000000000000000000000000000D4DBDF0064A6C7006CBD
      C0006CBEBB006DC0E40062B5E200266CC3001D37D0002E4EDC0060CAEB0030D5
      E7007198A80078BCD40091A5B30000000000C08A5600FFD19B0000000000C375
      230000000000000000006783B900265EF8001F57E7008DA4CE00000000000000
      0000C375230000000000FFD19B00C08A560000000000A0949000FFFFFF00FFFF
      FC00FFFFEE00FFFFFF00FFFFFD00FFFFFF00FFFFFF00A7979000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      00006060600000000000000000000000000000000000000000000000000098C7
      E1006DB8E00076C6E9006AB9E5002C4CE4001C3DDF001E43DE00448BB3004FD0
      F50031C1D7007B94AA000000000000000000BF885300FFD09B0000000000C476
      220000000000000000003C5ACB002960FE000051F30096AACD00000000000000
      0000C476220000000000FFD09B00BF88530000000000AEA09C00FFFFFF00FFFF
      FF00FFFFFF00FFFFFB00FFFFFF00FFFFFF00FFFFFF00A5959000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000757575000000000000000000000000000000000000000000000000000000
      000000000000AEC9D9007CA5BF0072A1BD006E9FBD0074A3BE0088A9C0007093
      AC003AE2F700889CB0000000000000000000C29A7300FFD09D0000000000E8B9
      8900E6C7A60000000000000000002851CD00144FD0000000000000000000E6C7
      A600E8B9890000000000FFD09D00C29A7300000000008F878500FFFFFF00FFFF
      FF00FFFFFD00FFFFFF00FFFFFF00FFFFFF00FFFFFF008F847F00000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00008A8A8A000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CFD7
      DF0039CADE003AD6EA00A9B7C50000000000E3DCD300D5944C00000000000000
      0000C8803900000000000000000000000000000000000000000000000000C880
      39000000000000000000D5944C00E3DCD300000000009B9B9B00F0E9E700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0083808000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF00000000000000000000000000000000000000000000000000
      0000A09F9F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000A9B7C5004AE7F800A2C9DA000000000000000000D9914F00FFDDBB000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFDDBB00D9914F000000000000000000000000008F8D8F00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0085807F0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      000000000000FF00000000000000000000000000000000000000000000000000
      0000B3B3B3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A4B5C50052EDFC00C6D5DE000000000000000000C27C37000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C27C37000000000000000000000000000000000000000000A9A9
      A9008483830092908F00908E8E008B8B8C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000C7C7C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C2D3DE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000D8D8D9000000000000000000000000000000000000000000000000000000
      0000ECE3DC00C0A18B00A47555008E552D008E552D00A5775700C1A18B00ECE3
      DC00000000000000000000000000000000000000000000000000000000000000
      000000000000EFE7DE00D7C4AE00CAB39600CAB29500D6C4AC00EEE6DC000000
      00000000000000000000000000000000000000000000B1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FEFEFD00C6A9
      9500935B3500CBAF9B00E5D6CB00F8F4F100F9F5F200E8DBD100D3BAA700955E
      3800C7AB9700FEFEFD000000000000000000000000000000000000000000EFE7
      E100AD8E760099725F00A9837700AF897F00AF887F00AB8479009A746200AE8F
      7700EEE6DF0000000000000000000000000000000000B1B1B1FFFAF7F5FFEDE4
      DFFFE7E1DFFFEAE3E0FFEDE6E3FFF0EAE9FFF7F4F3FFFDFDFDFFFCFBFAFFF1E8
      E5FFF0E7E4FFFAF7F5FFADA8A6FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FEFEFD00A3745400AF86
      6900F3EDE900DDC9BA00C7A58B00BB917100C1997900D5B79F00E9DACD00F8F3
      EF00B7917500A6785800FEFEFD00000000000000000000000000E2D3CB007E55
      41007A5347008B6559009A746800A17A6D00A17B6E009D776B008F695D007D57
      4C007A544100E0D0C700000000000000000000000000B1B1B1FFFAF7F5FFEDE4
      DFFFE7E1DFFFEAE3E0FFEDE6E3FFF0EAE9FFF7F4F3FFFDFDFDFFFCFBFAFFF1E8
      E5FFF0E7E4FFFAF7F5FFACA8A6FF000000000000000000000000B2B2B2009F9F
      9F00CBCBCB00CDCDCD00CDCDCD00CCCCCC00CCCCCC00CDCDCD00CFCFCF00CBCB
      CB009F9F9F00B4B4B400000000000000000000000000C7AA9600AE856900F3EE
      E900B78F7200A5724C00B38765000000000000000000C1977400C59B7800D7B9
      A000F9F5F100B48C7000C7AB97000000000000000000EFE7E300754B3800643D
      3100643D300071493C007D544700E2D9D500E3DAD6007F574A00744C3F006640
      3300633E320070483800EEE4E0000000000000000000B1B1B1FFF5F0ECFFDED8
      D5FFDDD8D6FFE6E2E1FFD9CEC8FFCAAD9CFFDDC7B4FFF2EFEBFFF2F2F2FFE8E1
      DEFFEEE7E4FFF5F0ECFFADA8A6FF00000000000000009D9D9D00797979001A1A
      1A00BDBDBD00D9D9D900D3D3D300D3D3D300D3D3D300D3D3D300DBDBDB00BABA
      BA001B1B1B007B7B7B009F9F9F0000000000ECE3DC00925B3400F2EBE600B187
      69009D674000A36F4900B28462000000000000000000BD926F00C1967200C59B
      7800D6B79D00F7F1ED00935D3600ECE3DC00000000009B776900593123005731
      2400C7BAB500DBD3CE00B2908400F1F0EC00F2F0ED00B3908400DBD3CE00C8BC
      B6005932250057322500957264000000000000000000B1B1B1FFF4EFECFFDAD6
      D5FFE3E1E0FFBC977FFFB7612AFFD17A4CFFD57C50FFB45925FFCFA07EFFEAE1
      DDFFF2EAE7FFF4EFECFFB0AAA8FF00000000949494006C6C6C00DADADA001818
      1800D9D9D900000000000000000000000000000000000000000000000000D5D5
      D50016161600DADADA006B6B6B0092929200C0A18B00C3A69100D3BCAD00945C
      33009A643C00A16C4500A9785200C8A88F00CCAD9400B7896500BB8F6B00BF93
      7000C1967300E7D7C900CFB5A100C1A18B00EBE1DE00582D1C004E291C004E26
      1900D7CFCB00FDFFFC00FAFBF800E2DCD800E1DCD700FAFBF800FDFFFC00D9D1
      CD0050281B004F2A1D00522A1B00E9DEDB0000000000B1B1B1FFF5EFEDFFE6E2
      E1FFC5A18DFF943E11FF741600FFFFFFFFFFFFFFFFFF7C1F00FF7E2700FFBF86
      65FFF9F3F1FFF5EFEDFFB1AEACFF000000009898980083838300DADADA002B2B
      2B00D6D6D600000000000000000000000000000000000000000000000000D0D0
      D00028282800DADADA008585850097979700A2735300DDCCC000AF866A009158
      2F00976038009D674000A7765100E4D4C800E5D6CA00B4866200B6876300B98B
      6700BA8E6A00D1B29B00E6D7CC00A5765600C3A9A500461E0E0046201400431B
      0D00B0948900FDFDFC00B09E9700613C3000613C2F00AE9C9400FDFDFC00B296
      8B00451D0F0047211400411C0E00C0A5A10000000000B1B1B1FFF9F3F0FFE8DD
      D9FF975432FF4E1400FF5F0F00FFFFFFFFFFFFFFFFFF681800FF541500FF6B2C
      0CFFE9D3C9FFF9F3F0FFB1B0AFFF000000009B9B9B0091919100DADADA003A3A
      3A00D6D6D600000000000000000000000000000000000000000000000000D1D1
      D10038383800DADADA0095959500999999008D532B00F5F0ED00945E38008E53
      2A00945B330099623A009F694200F3EDE80000000000D0B5A000B07F5A00B283
      5E00B4856000BD947500F8F3F0008E542D00AA8984003B1404003F180B00EAE6
      E300F8F7F500E5E0DC006843370060392B00613A2C0068433600E3DDDA00F8F7
      F500D8D0CC004B241700411D0E00A584800000000000B1B1B1FFFBF7F5FFE6D1
      C7FF63290FFF521903FF711E03FFFFFFFFFFFFFFFFFF812C0AFF722809FF5E21
      07FFDEB8A9FFFBF7F5FFB2B0AFFF00000000B8B8B800A4A4A400DADADA004343
      4300D5D5D500000000000000000000000000000000000000000000000000CFCF
      CF0044444400DADADA00A6A5A500B8B8B8008D532B00F5F0ED00935C36008A4F
      250090562D00955D34009A633B00B58B6D00FCFBF900FEFEFE00C19D8200AC7A
      5400AD7C5600B78D6C00F7F3EF008E542C00A98886004D281800552E2100EDE9
      E600FAFAF800E6E1DD006F4A3E0068413400694234006F493C00E4DEDB00FBFB
      FA00DED7D3005B35280056322400A584810000000000B1B1B1FFFCFBFBFFEBDA
      D1FFA94F27FFA54922FFAA4C23FFCB8C71FFDDB19EFFAE5129FFAB4F28FFA84B
      22FFE8C4B5FFFCFBFBFFB5B0AFFF0000000000000000C4C4C400858585006B6B
      6B00E4E4E400000000000000000000000000000000000000000000000000E0E0
      E0006A6A6A0086868600C2C3C30000000000A2735300DDCCC000AC826500874A
      20008B50270090562D00955C340099623A00C2A1890000000000F3ECE800A572
      4B00A6734D00C3A18600E1D2C600A4755500C0A4A500613C2C00653F3200623A
      2C00B99D9200FFFFFE00B9A7A0007651440076514400B7A49D00FEFEFE00BA9F
      9500653E300068423500613D2F00BCA0A00000000000B1B1B1FFFFFFFFFFEFEA
      E9FFDB9673FFDA8059FFDB7B54FFFFFFFFFFFFFFFFFFDD8058FFDD825CFFCC75
      51FFFAEAE4FFFFFFFFFFB6B2B0FF000000000000000000000000B0B0B0000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ADADAD000000000000000000C0A18B00C3A59000D0B9A900874A
      2000874A20009F6E4B00A06F4D00945B3200A87A590000000000FDFCFB00A16D
      46009F6A4300DAC6B700C6AA9500C0A18B00E8DCDE00764F4100805B4E007B53
      4500E2D9D6000000000000000000EAE4E100E9E3E1000000000000000000E3DC
      D8007D564800835D5000744F4400E5D8DA0000000000B1B1B1FFFFFFFFFFF4F4
      F4FFDBC2BAFFF5A881FFFFB696FFFFFFFFFFFFFFFFFFFFB696FFF5A583FFE9C1
      B4FFFFFBFAFFFFFFFFFFB3AFADFF000000000000000000000000979797000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000989899000000000000000000ECE3DC00925C3500F1EAE500A578
      5800874A2000B0886C00FEFDFD00E9DED600F6F2EF0000000000DCCABD009860
      3800B3896B00F2EBE600915B3400ECE3DC00000000009E787700A07D6D009871
      6400DED2CD00EBE3E000C4A99F00FDFEFD00FEFFFE00C5AAA000EBE3E000DFD3
      CE009A736500A17E6F009B7675000000000000000000B1B1B1FFFFFFFFFFF6F6
      F6FFF7F7F7FFD8C0BBFFDEAA92FFF5C4AEFFF4C2AEFFE7B8A6FFEDD3CBFFFEFC
      FAFFFFFAF7FFFFFFFFFFB0B0B0FF000000000000000000000000949494004141
      4100DADADA00000000000000000000000000000000000000000000000000D7D7
      D7003D3D3D009D9D9D00000000000000000000000000C6A99500AD836700F2EB
      E700A67859009C694700DECEC200F7F3F000F1EAE600D0B8A700A06F4D00AD82
      6400F3EDE800AB806200C6A995000000000000000000EADFE0009A756C00BE9A
      8B00B28B7E00B0897B00B0887A00F0E8E500F0E9E600B2897C00B18A7C00B38C
      7E00BF9B8C009B776D00E8DDDE000000000000000000B1B1B1FFFFFFFFFFF7F7
      F7FFF8F8F8FFF9F9F9FFF9F8F8FFE9DCD9FFEDDFDBFFF7F1EFFFFBF8F7FFF8F3
      F1FFF9F5F5FFFFFFFFFFB1B1B1FF000000000000000000000000000000008484
      84003B3B3B0066666600A6A6A600C2C2C200C2C2C200A5A5A500636363003B3B
      3B008787870000000000000000000000000000000000FEFEFD00A3745400AA7F
      6100F0E8E300D0B9A900AC82650096603B0096603B00AC826500D1BAAA00F0E9
      E400AA806200A3745400FEFEFD00000000000000000000000000D9C8C900AA85
      7D00D4B2A300D2AC9F00CDA79A00CBA49700CBA49700CEA79A00D3AD9F00D5B3
      A400AB877F00D7C4C500000000000000000000000000B1B1B1FFFFFFFFFFF8F8
      F8FFF9F9F9FFFAFAFAFFFBFBFBFFFBFBFBFFFDFDFDFFFDFCFCFFFBF8F8FFFCFB
      FBFFFFFFFFFFFFFFFFFFB1B1B1FF000000000000000000000000000000000000
      0000BFBFBF00656565004D4D4D0057575700575757004D4D4D0066666600C3C3
      C300000000000000000000000000000000000000000000000000FEFEFD00C6A9
      9500915B3400C1A28D00DBC9BD00F4EFEB00F4EFEB00DBC9BD00C1A38D00915A
      3300C7AA9600FEFEFD000000000000000000000000000000000000000000E9DE
      DE00B18E8C00C5A29600DFBDAE00E5C3B500E6C4B500DFBEAF00C6A39800B08E
      8C00E7DCDD0000000000000000000000000000000000B1B1B1FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB1B1B1FF000000000000000000000000000000000000
      00000000000000000000ADADAD008181810081818100AEAEAE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000ECE3DC00C0A18B00A27353008D532B008D532B00A2735300C0A18B00ECE3
      DC00000000000000000000000000000000000000000000000000000000000000
      000000000000E6DADB00C8AEAF00BD9D9E00BD9D9E00C8ADAF00E5D8DA000000
      00000000000000000000000000000000000000000000B1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000EEEEEE00EAEAEA00EAEAEA0000000000000000000000000000000000DBD7
      D30096816B00E2DED90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000089E2F70057D6F30030CDF10016C7EF0016C7EF0030CDF10057D6F30089E2
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BEBE
      BE00A1A1A100D1D1D100C3C3C400C8C8CA00CCCCCC000000000000000000D8D8
      D700A7795200A6805C00DFDBD50000000000000000001E1B1900040000000D0C
      0B007D7C7B008C8B8A006C6968008B8989009C9C9C0099999900A4A5A5006F6B
      6B000A080700010000000700000000000000000000000000000078DEF60014C6
      EF0047D3F30060D9F40073DEF60080E1F70080E1F70073DEF60060D9F40047D3
      F30014C6EF0078DEF60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B4CBDF005A90BE00508ABA000000000000000000B5B5B6007575
      7600C1C1C200FFFFFF00F5F5F500E7E7E800E1E1E100C6C6C600B1B4B6009895
      9000AC835F00D2844100AB7F5200EBDDCE0000000000191412001F1815002721
      1E00C5C6C600534E4D0010090800C5C6C600C5C6C600C5C6C600C5C6C6007F7B
      7B00251C1A001F1814002A221F00000000000000000066DAF4004FD5F30081E1
      F70086E2F70086E2F70086E2F70086E2F70086E2F70086E2F70086E2F70086E2
      F70081E1F7004FD5F30066DAF400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B7CCE0006B9ECC0092B9DE005087B80000000000E3E3E400ABABAC008F8F
      9000B6B6B700FDFDFD00F1F1F100F4F4F400F4F4F400F4F4F300EFF1F200DBD9
      D500C49E7B00D4A06F00DEAA7100A2826000000000001F1A1800241D19002C25
      2200C5C6C6005F5A59001C121000C5C6C600C5C6C600C5C6C600C5C6C6008381
      800029211E00221B18002B232000000000000000000013C6EF0082E1F70075BE
      F100659AEB00577CE6004C63E2004554E0004554E0004C63E200577CE600659A
      EB0075BEF10082E1F70013C6EF00000000000000000000000000000000000000
      000000000000000000000000000000000000EFDCCC00E6C6AB00E6C5A900DFBA
      9B00B6A397009CB8D300669ACA00B5CCE000F1F1F100D0D0D100C9C9C900ADAD
      AE00B7B7B800FEFEFE00F2F2F200F1F1F100F1F1F100F2F2F200E6E7E900C4C1
      BC00C6A58200DCAE7E00E6BE9200A085670000000000231E1C002A221E00332C
      2800C5C6C60077747200352C2800C5C6C600C5C6C600C5C6C600C5C6C6009392
      90002F282400271E1B002C252100000000000000000016B4ED005F8FEA005372
      E5006396EB0071B4F0007CCDF40083DCF60083DCF6007CCDF40071B4F0006396
      EB005372E5005F8FEA0016B4ED0000000000A2C9ED0076B1E5003E90DB00338B
      D900338BD900338BD900338BD900A9AFB500F2DCC900F8E3CE00F7E0C700F8E2
      CB00F3D1B300B2A39900B9CEE400000000000000000000000000F7F7F700D2D2
      D200BCBCBF00FFFFFF00F8F8F800F6F6F600F5F5F500F1F1F100E3E4E600BDBB
      B900D2B79700E3B68700E8BF8F00A38867000000000028222000372E2900372E
      2A00605E5E0086858400868481008F8D8C009392910093929200979697006965
      6400312925002B232000332A270000000000000000002C80E60067A0EC0089DC
      F400C2E3EB00A4E2F10086E2F70086E2F70086E2F7008DE2F600A8E3F0008CE2
      F50083DCF60067A0EC002C80E600000000004799DC00DEF0FA00A7DDF4009EDB
      F40096DAF3008ED8F30086D7F300E5C4A800F5E5D600F4DAC100F3D8BD00F3D8
      BD00F8E3CC00D9B69A0000000000000000000000000000000000000000000000
      0000AAAAAA00F8F8F800FCFCFC00FBFBFB00FCFCFC00F2F2F300DCDEDF00C2B8
      A800E6CCAF00EBCAA200EDC69500A48B6900000000002C27240039302B002D24
      2100231B1900241D1B002B22220028201F00261E1C00241E1C00221A1900241D
      1B002D252200342C29003C33300000000000000000000FC5EF0084E1F700D7DB
      DC00ECECEC00E7E7E700DFE2E300E3E4E400E3E4E400E3E3E300EBEBEB00DCDF
      E0009BE1F10084E1F7000FC5EF00000000003B97DB00EFFAFE00A1E9F90091E5
      F80081E1F70072DEF60063DAF500E0BD9E00F8EADC00F4DDC600F4DCC400F3D8
      BD00F8E2CD00E4C1A40000000000000000000000000000000000000000000000
      0000BBBBBB00DFDFDF00FFFFFF00FBFBFB00FDFDFD00F6F6F600E0E0E100C6B7
      A300F3D9B900EFD6B800F3D3AA00A68B6B000000000029222000363330006562
      5F006F6A67006C6763006C6763006D6764006D6764006C6764006C676300706B
      670064605D0033302E00392F2C00000000000000000073CEE300D7D9DA00E3E3
      E300FFFFFF00FFFFFF00FCFCFC00E7B09800E39E7800EDC2B200FFFFFF00EEEE
      EE00D6D8D900B5DEE8002BC7EB00000000003B9CDB00F2FAFD00B3EDFA00A4E9
      F90095E6F80085E2F70076DEF600E6C6AA00F3E4D600F6E0CA00F5DEC600F5DE
      C500F8E6D300E0C2A80000000000000000000000000000000000000000000000
      0000B9B9B900E1E1E100FFFFFF00FCFCFC00FDFDFD00F6F6F600E1E2E200CCBC
      AB00F6DEC000F2DCBF00F9E2C200A88F720000000000221B1A005E595600EEE4
      DD00F2E8E100EEE3DC00EEE3DC00EEE3DC00EEE3DC00EEE3DC00EDE2DB00F5EB
      E300E8E0D80056525000322826000000000000000000B5C2C500FAFAFA00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00E5A47E00E9B49300E3A27800FFFFFF00FFFF
      FF00FDFDFD00EAEAEA007DC9DB00000000003AA3DA00F6FCFE00C8F2FC00B9EF
      FB00ACECFA009CE8F9008BE3F700A3D2D300E9CDB400F5E7DB00F8ECDF00F2DD
      C900EBD0B800A8B3B20000000000000000000000000000000000000000000000
      0000B9B9B900E3E3E300FFFFFF00FDFDFD00FEFEFE00F7F7F700E2E2E300CDBD
      AC00FEE8CB00F6E3C700FDEACF00AA957B0000000000251F1C0064605C00EDE5
      DE00E4DCD600E1D9D300E2DAD500E2DAD500E2DAD500E2DAD500E1D9D300E8E0
      DA00E9E1DB005C575600372D2B000000000000000000BEC2C300FCFCFC00EEC1
      A600EAB29200F1CEBB00FFFFFF00E6AA8500EAB89800E5A57F00FFFFFF00E8AF
      9800E39D7600EABEAF00BAC3C500000000003AA7DA00FEFFFF00F8FDFF00F6FD
      FF00F5FCFF00F3FCFE00D8F6FC0095E6F800A9D4D400C8C6B300E0BD9E00E5C4
      A700E2CFBA004CA9D50000000000000000000000000000000000000000000000
      0000B9B9B900E4E4E400FFFFFF00FDFDFD00FFFFFF00F8F8F800E3E3E400CEC1
      B000FFEDD300FCEAD000FFF0D700AB9981000000000028221F0066625F00F1ED
      E600ECE7E100E9E3DE00EAE4DF00EAE4DF00EAE4DF00EAE4DF00E9E3DE00F0EA
      E500ECE8E3005E5A58003B322F000000000000000000CDD8DB00E3E3E300EBB9
      9900EEC3AA00EBB49500FFFFFF0094B3A10055BFBC0086B1A000FFFFFF00E5A3
      7B00E9B29200DE9A7200CDD8DB000000000038ACDA00E8F6FB0094D4EF0088CE
      EE0073C1E900C9E9F600F2FCFE00F3FCFE00F2FCFE00F0FCFE00EFFBFE00EEFB
      FE00FEFFFF003CADDB0000000000000000000000000000000000000000000000
      0000BABABA00E5E5E500FFFFFF00FEFEFE00FFFFFF00F8F8F800E2E2E300CEC1
      B100FFF1D900FFEFD700FFF5DF00AC998300000000002B25220068646300F3F2
      F000F2EDEB00EFEAE700F0EBE800F0EBE800F0EBE800F0EBE800EFEAE700F6F1
      EE00EDEDEB005F5D5B0040373300000000000000000000000000DDDDDD00EDBB
      9D00EFC8AF00E8B69600F6F6F60007D2D80067F5F60007D2D700ECECEC00E5A9
      8300EAB79800DD9D7400000000000000000040AEDB00F1FAFD0094DEF50093DC
      F40081D5F2006ACAED006CCBEA0085D3EF0080D2EF007AD0EF0076CFEE0072CF
      EE00E9F7FB003DB1DB0000000000000000000000000000000000000000000000
      0000B9B9B900E5E5E500FFFFFF00FEFEFE00FEFEFE00FBFBFC00E8E8E900D5C7
      B700FFF4DD00FFF4E100FFFAE800AD9B850000000000312A28006C676500F4F3
      F400F8F6F500F5F3F100F6F3F100F6F3F100F6F3F100F6F3F100F5F2F000FBF9
      F700EEEEEF00625F5E00433936000000000000000000000000000000000097BC
      AD0057C4C30086B7AA00CACACA0007D2D90030F1F30068C2C900D4D4D40094B1
      9F0055BFBC0085AF9E00000000000000000040B3DC00F7FCFE008EE4F80091DE
      F5009FE0F500ACE1F600EFFBFE00F4FDFE00F3FCFE00F1FCFE00EFFBFE00EEFB
      FE00FAFDFF0057BCE00000000000000000000000000000000000000000000000
      0000B6B6B600EEEEEE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FBFAFA00D6C5
      B000EBD9C100FEF4E200FFFFF200AD9C88000000000027211F006A686600F8F9
      F900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00EFEFF10062605F004A403B000000000000000000000000000000000007D2
      D80067F5F60006D2D800000000000000000038D3DC00000000000000000007D2
      D80067F5F60006D1D70000000000000000003BB5DB00FDFEFE00FEFFFF00FEFE
      FF00FDFEFF00FEFFFF00EAF7FB006EC8E4006FC8E3006FC8E3006FC8E3007DCE
      E60084D0E8000000000000000000000000000000000000000000000000000000
      000000000000B9B9B900C7C7C700C6C6C600DDDDDD00FFFFFF00FFFFFF00F9F4
      EC00DDD0BE00E4D2BE00FFFFF400B1A290000000000034312F006D6B6900BDBD
      BC00BDBDBC00BCBBBB00BCBBBB00BCBBBB00BCBBBB00BCBBBB00BCBBBB00BDBC
      BD00BBBBBA00787675004F4A48000000000000000000000000000000000008D4
      DB0030F1F30083DDE300000000000000000000000000000000000000000008D4
      DB0030F1F30083DDE300000000000000000059C1E00061C3E10063C4E20063C4
      E20063C4E20062C4E20056BFDF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBDBD00BCBCBC00B5B5B500B3B4
      B400B0B0AF00ADABAA00BAB1A800AC9F8E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000038D3DC000000000000000000000000000000000000000000000000000000
      000038D3DC000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000B00000000100010000000000800500000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      EDB7924900000000EDB7FFFF00000000E8B7924900000000E8B7FFFF00000000
      E8B7924900000000ED17FFFF00000000ED17924900000000C517FFFF00000000
      C5A39E4900000000C5A3FFFF00000000EDA39E7900000000EDB7FFFF00000000
      FFFFFE7F00000000FFFFFFFF00000000F01FFFFFF003E007C007FFFFC0008001
      8003FC7F800000008003F00F800080000001C007C00080010001C007F0018001
      00018003F00380E100018003E00F80E100018003E01F800100018003C03F8001
      00018003C07F83818001C003C0FF80018003C00780FF8001C007E00F83FFC001
      E00FF01F87FFE009FEFFFFFF87FFF039FFFF0000FFFFFC7FF00F0000F83FF01F
      C0030000E00FC007C0030000C007C003C0030000C0038003C007000080038001
      C007000080030001C007000080010001C0070000800100010007000080030001
      0003000080038001000000008003800300000000C007C00380030000E00FE007
      C0000000F01FF01FF3F80000FFFFFFFFFFFFFFFF8001FFFF800100008001FFFF
      800100008001FFFF800100008001FC0F80010000800100008001000080017FDE
      8001000080010000800100008001000080010000800100008001000080010000
      80010000800100008001000080014002800100008001781E8001000080010000
      800100008001FFFFFFFFFFFF8001FFFFFFFFC003FFFFFFFFE7CFC003E7FFFFFF
      E18FC003C1FFE007F00FC003C0FFC003F00FC083C03FC003F01FCF83C01FC003
      E00FC003C007C003C003C003C003C0038001C003C003C0038001C003C007C003
      FC3FD083C01FC003FC7FDF83C03FC003FC7FC003C0FFC003FE7FDF83C1FFE007
      FEFFC003E7FFFFFFFFFFFFFFFFFFFFFFFFFFF81F0000FFFFE7CFE0070000E7CF
      E18FC0030000E18FF00F80010000F00FF00F81810000F00FF01F04200000F01F
      E00F08100000E00FC00308100000C00380010810000080018001080000008001
      FC3F04200000FC3FFC7F80010000FC7FFC7F80010000FE7FFE7FC0030000FE7F
      FEFFE0070000FEFFFFFFF81F0000FFFFF81F00008001FFFFE00700000000FFFF
      C00300000000FFFF800100000000E43F800100000000C0070000000000008003
      0000000000008001000000000000000000000000000000000000000000008001
      000000000000C001800100000000E003800100000000FD87C00300000000FFFF
      E00700000000FFFFF81F00000000FFFF8001FFC1FFC1FFFF800180008000FFF9
      800180008000FFF3800180008000FFE7800180008000FFCF800180008000FF9F
      800180018001E03F800180018001C03F800180018001803F800180018001803F
      800180018001803F800180018001803F800180018001803F800180018001C07F
      800180018001E0FF8001FFFFFFFFFFFFF83FFFFFFFFFFFFFE03FFC3FFFF9C1F7
      C03FFC3FFFF3DDE3803FFC3FFFE7EFE30001FC3FFFCFF7C10000DC7BFF9FFBC1
      00009E79E03FDDF70000366CC03FC1F780002664803FFFF780012C34803FDDF7
      E0032C34803FDDF7F8032664803FC1F7FFE137EC803FEBF7FFF19FF9C07FEBF7
      FFF8DFFBE0FFF7F7FFFDFFFFFFFFF7F7F00FF81F0000FFFFC003E0070000FFFF
      8001C0030000C003818180010000800101808001000007E000000000000007E0
      00000000000007E000800000000007E000000000000087E1004000000000DFFB
      004006600000DFFB004080010000C7E3800180010000E0078001C0030000F00F
      C003E0070000FC3FF00FF81F0000FFFFF1E3FFFFF00FFFFFE0618001C003FFF8
      C00080018001FFF0800080018001FF000000800180010001C000800180010003
      F000800180010003F000800180010003F000800180010003F000800180010003
      F000800180010003F0008001C0030003F0008001E0030003F0008001E3630007
      F8008001E3E301FFFF00FFFFF7F7FFFF00000000000000000000000000000000
      000000000000}
  end
  object PlayListOpenDialog: TOpenDialog
    Filter = 
      'All supported files|*.m3u;*.m3u8;*.pls;*.npl;*.asx;*.wax|m3u-lis' +
      'ts|*.m3u|m3u8-lists (unicode-capable)|*.m3u8|pls-lists|*.pls|Nem' +
      'p playlists|*.npl|WindowsMedia|*.asx;*.wax'
    Left = 961
    Top = 1
  end
  object PlaylistDateienOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 776
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'gmp'
    Filter = 'Nemp medialibrary (*.gmp)|*.gmp'
    FilterIndex = 0
    Left = 32
    Top = 312
  end
  object PlayListSaveDialog: TSaveDialog
    DefaultExt = 'm3u8'
    Filter = 
      'm3u-list|*.m3u|m3u8-list (unicode-capable)|*.m3u8|pls-list|*.pls' +
      '|Nemp playlists|*.npl'
    FilterIndex = 2
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = PlayListSaveDialogTypeChange
    Left = 873
    Top = 1
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'gmp'
    Filter = 'Nemp medialibrary (*.gmp)|*.gmp'
    FilterIndex = 0
    Left = 64
    Top = 312
  end
  object Medialist_View_PopupMenu: TPopupMenu
    Images = MenuImages
    OnPopup = Medialist_View_PopupMenuPopup
    Left = 480
    Top = 120
    object PM_ML_Enqueue: TMenuItem
      Caption = 'Enqueue (at the end of the playlist)'
      OnClick = PM_ML_FilesPlayEnqueueClick
    end
    object PM_ML_Play: TMenuItem
      Tag = 1
      Caption = 'Play (and clear current playlist)'
      OnClick = PM_ML_FilesPlayEnqueueClick
    end
    object PM_ML_PlayNext: TMenuItem
      Tag = 2
      Caption = 'Enqueue (after the current title)'
      OnClick = PM_ML_FilesPlayEnqueueClick
    end
    object PM_ML_PlayNow: TMenuItem
      Tag = 3
      Caption = 'Just play focussed file (don'#39't change the playlist)'
      OnClick = PM_ML_FilesPlayNowClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object PM_ML_PlayHeadset: TMenuItem
      Caption = 'Play in headset'
      ImageIndex = 7
      ShortCut = 16456
      OnClick = PM_PL_PlayInHeadsetClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PM_ML_SortBy: TMenuItem
      Caption = 'Sort by'
      ImageIndex = 11
      object PM_ML_SortArtistTitle: TMenuItem
        Caption = 'Artist, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortArtistAlbumTitle: TMenuItem
        Tag = 117
        Caption = 'Artist, Album, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortTitleArtist: TMenuItem
        Tag = 1
        Caption = 'Title, Artist'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortAlbumArtistTitle: TMenuItem
        Tag = 2
        Caption = 'Album, Artist, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortAlbumTitleArtist: TMenuItem
        Tag = 118
        Caption = 'Album, Title, Artist'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortAlbumTracknr: TMenuItem
        Tag = 119
        Caption = 'Album, Tracknr.'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortFilename: TMenuItem
        Tag = 12
        Caption = 'Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortPathFilename: TMenuItem
        Tag = 10
        Caption = 'Path && Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortLyricsexists: TMenuItem
        Tag = 15
        Caption = 'Lyrics exists'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortGenre: TMenuItem
        Tag = 14
        Caption = 'Genre'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N7: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortDuration: TMenuItem
        Tag = 3
        Caption = 'Duration'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortFilesize: TMenuItem
        Tag = 9
        Caption = 'Filesize'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N4: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortDescending: TMenuItem
        Caption = 'Descending'
        GroupIndex = 1
        RadioItem = True
        OnClick = MM_ML_SortDescendingClick
      end
      object PM_ML_SortAscending: TMenuItem
        Caption = 'Ascending'
        Checked = True
        GroupIndex = 1
        RadioItem = True
        OnClick = MM_ML_SortAscendingClick
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object PM_ML_HideSelected: TMenuItem
      Caption = 'Hide selected files'
      ShortCut = 46
      OnClick = PM_ML_HideSelectedClick
    end
    object PM_ML_DeleteSelected: TMenuItem
      Caption = 'Remove selected files'
      ImageIndex = 38
      ShortCut = 16430
      OnClick = PM_ML_DeleteSelectedClick
    end
    object N72: TMenuItem
      Caption = '-'
    end
    object PM_ML_SetRatingsOfSelectedFilesCHOOSE: TMenuItem
      Caption = 'Set rating of selected files to'
      ImageIndex = 20
      object PM_ML_SetRatingsOfSelectedFiles1: TMenuItem
        Tag = 100
        Caption = '0.5 stars'
        ImageIndex = 23
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles2: TMenuItem
        Tag = 101
        Caption = '1 star'
        ShortCut = 16433
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles3: TMenuItem
        Tag = 102
        Caption = '1.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles4: TMenuItem
        Tag = 103
        Caption = '2 stars'
        ShortCut = 16434
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles5: TMenuItem
        Tag = 104
        Caption = '2.5 stars'
        ImageIndex = 24
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles6: TMenuItem
        Tag = 105
        Caption = '3 stars'
        ShortCut = 16435
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles7: TMenuItem
        Tag = 106
        Caption = '3.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles8: TMenuItem
        Tag = 107
        Caption = '4 stars'
        ShortCut = 16436
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles9: TMenuItem
        Tag = 108
        Caption = '4.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_ML_SetRatingsOfSelectedFiles10: TMenuItem
        Tag = 109
        Caption = '5 stars'
        ImageIndex = 20
        ShortCut = 16437
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object N73: TMenuItem
        Caption = '-'
      end
      object PM_ML_ResetRating: TMenuItem
        Tag = 110
        Caption = 'Reset rating/playcounter'
        ImageIndex = 24
        ShortCut = 16432
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
    end
    object PM_ML_MarkFile: TMenuItem
      Tag = 150
      Caption = 'Flag selected files with'
      ImageIndex = 34
      object PM_ML_Mark1: TMenuItem
        Tag = 101
        Caption = 'Mark 1'
        ImageIndex = 35
        ShortCut = 24625
        OnClick = PM_ML_SetmarkerClick
      end
      object PM_ML_Mark2: TMenuItem
        Tag = 102
        Caption = 'Mark 2'
        ImageIndex = 36
        ShortCut = 24626
        OnClick = PM_ML_SetmarkerClick
      end
      object PM_ML_Mark3: TMenuItem
        Tag = 103
        Caption = 'Mark 3'
        ImageIndex = 37
        ShortCut = 24627
        OnClick = PM_ML_SetmarkerClick
      end
      object N81: TMenuItem
        Caption = '-'
      end
      object PM_ML_Mark0: TMenuItem
        Tag = 100
        Caption = 'Unmarked'
        ImageIndex = 34
        ShortCut = 24661
        OnClick = PM_ML_SetmarkerClick
      end
    end
    object PM_ML_GetLyrics: TMenuItem
      Caption = 'Get lyrics for selected files'
      ImageIndex = 25
      ShortCut = 16460
      OnClick = PM_ML_GetLyricsClick
    end
    object PM_ML_GetTags: TMenuItem
      Caption = 'Get additional tags for selected files'
      ImageIndex = 18
      ShortCut = 16468
      OnClick = PM_ML_GetTagsClick
    end
    object PM_ML_RefreshSelected: TMenuItem
      Caption = 'Refresh selected'
      ImageIndex = 39
      ShortCut = 116
      OnClick = PM_ML_RefreshSelectedClick
    end
    object PM_ML_ReplayGain: TMenuItem
      Caption = 'ReplayGain'
      ImageIndex = 41
      object PM_ML_ReplayGain_SingleTracks: TMenuItem
        Caption = 'Single tracks'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_ML_ReplayGain_OneAlbum: TMenuItem
        Tag = 1
        Caption = 'As one album'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_ML_ReplayGain_MultiAlbum: TMenuItem
        Tag = 2
        Caption = 'Multiple albums (by tags)'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_ML_ReplayGain_Clear: TMenuItem
        Tag = 3
        Caption = 'Clear ReplayGain'
        OnClick = PM_PL_ReplayGain_Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object PM_ML_CopyToClipboard: TMenuItem
      Caption = 'Copy to clipboard'
      ShortCut = 16451
      OnClick = PM_ML_CopyToClipboardClick
    end
    object PM_ML_MagicCopyToClipboard: TMenuItem
      Caption = '... and include a proper playlist-file'
      OnClick = PM_PL_MagicCopyToClipboardClick
    end
    object PM_ML_PasteFromClipboard: TMenuItem
      Caption = 'Paste from clipboard'
      ShortCut = 16470
      OnClick = PM_ML_PasteFromClipboardClick
    end
    object PM_ML_Extended: TMenuItem
      Caption = 'Extended'
      object PM_ML_ExtendedShowAllFilesInDir: TMenuItem
        Caption = 'Show all files within this directory'
        OnClick = PM_ML_ExtendedShowAllFilesInDirClick
      end
      object PM_ML_ExtendedAddAllFilesInDir: TMenuItem
        Caption = 'Add all files within this directory'
        OnClick = PM_ML_ExtendedShowAllFilesInDirClick
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object PM_ML_ExtendedSearchTitle: TMenuItem
        Tag = 1
        Caption = 'Search for this title'
        OnClick = NachDiesemDingSuchen1Click
      end
      object PM_ML_ExtendedSearchArtist: TMenuItem
        Tag = 2
        Caption = 'Search for this artist'
        OnClick = NachDiesemDingSuchen1Click
      end
      object PM_ML_ExtendedSearchAlbum: TMenuItem
        Tag = 3
        Caption = 'Search for this album'
        OnClick = NachDiesemDingSuchen1Click
      end
      object N76: TMenuItem
        Caption = '-'
      end
      object PM_ML_ShowAllIncompleteTaggedFiles: TMenuItem
        Caption = 'Show all files where Artist/Title/Album is missing'
        OnClick = PM_ML_ShowAllIncompleteTaggedFilesClick
      end
    end
    object N55: TMenuItem
      Caption = '-'
    end
    object PM_ML_ShowInExplorer: TMenuItem
      Caption = 'Show in Windows Explorer'
      OnClick = PM_ML_ShowInExplorerClick
    end
    object PM_ML_Properties: TMenuItem
      Caption = 'Properties'
      ImageIndex = 6
      ShortCut = 16452
      OnClick = PM_ML_PropertiesClick
    end
  end
  object PlayListPOPUP: TPopupMenu
    Images = MenuImages
    OnPopup = PlayListPOPUPPopup
    Left = 624
    Top = 56
    object PM_PL_AddFiles: TMenuItem
      Caption = 'Add files'
      OnClick = MM_PL_FilesClick
    end
    object PM_PL_AddDirectories: TMenuItem
      Caption = 'Add directory'
      OnClick = MM_PL_DirectoryClick
    end
    object PM_PL_AddCDAudio: TMenuItem
      Caption = 'Add CD-Audio'
      OnClick = PM_PL_AddCDAudioClick
    end
    object PM_PL_AddWebstream: TMenuItem
      Caption = 'Add webradio'
      ShortCut = 16457
      OnClick = PM_PlayWebstreamClick
    end
    object PM_PL_SortBy: TMenuItem
      Caption = 'Sort by'
      ImageIndex = 11
      object PM_PL_SortByFilename: TMenuItem
        Tag = 1
        Caption = 'Filename'
        OnClick = PlaylistSortClick
      end
      object PM_PL_SortByArtist: TMenuItem
        Tag = 2
        Caption = 'Artist'
        OnClick = PlaylistSortClick
      end
      object PM_PL_SortByTitle: TMenuItem
        Tag = 3
        Caption = 'Title'
        OnClick = PlaylistSortClick
      end
      object PM_PL_SortByAlbumTrack: TMenuItem
        Tag = 4
        Caption = 'Album, Tracknr.'
        OnClick = PlaylistSortClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object PM_PL_SortByInverse: TMenuItem
        Caption = 'Inverse'
        OnClick = PM_PL_SortByInverseClick
      end
      object PM_PL_SortByMix: TMenuItem
        Caption = 'Mix'
        OnClick = PM_PL_SortByMixClick
      end
    end
    object PM_PL_StopAfterCurrentTitle: TMenuItem
      Caption = 'Stop after current title'
      OnClick = PM_StopAfterTitleClick
    end
    object N25: TMenuItem
      Caption = '-'
    end
    object PM_PL_GeneraterandomPlaylist: TMenuItem
      Caption = 'Generate random playlist'
      OnClick = MitzuflligenEintrgenausderMedienbibliothekfllen1Click
    end
    object PM_PL_LoadPlaylist: TMenuItem
      Caption = 'Load (and clear current list)'
      ImageIndex = 0
      ShortCut = 16463
      OnClick = PM_PL_LoadPlaylistClick
    end
    object PM_PL_AddPlaylist: TMenuItem
      Caption = 'Load (add files to current list)'
      OnClick = MM_PL_AddPlaylistClick
    end
    object PM_PL_RecentPlaylists: TMenuItem
      Caption = 'Recent playlists'
    end
    object PM_PL_SavePlaylist: TMenuItem
      Caption = 'Save'
      ImageIndex = 1
      ShortCut = 16467
      OnClick = PM_PL_SavePlaylistClick
    end
    object PM_PL_SaveAsPlaylist: TMenuItem
      Caption = 'Save as'
      ShortCut = 24659
      OnClick = PM_PL_SaveAsPlaylistClick
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object PM_PL_ClearPlaylist: TMenuItem
      Caption = 'Clear'
      Visible = False
      OnClick = PM_PL_ClearPlaylistClick
    end
    object PM_PL_DeleteSelected: TMenuItem
      Caption = 'Remove selected'
      ShortCut = 46
      OnClick = PM_PL_DeleteSelectedClick
    end
    object PM_PL_DeleteMissingFiles: TMenuItem
      Caption = 'Cleanup (remove missing files)'
      ImageIndex = 38
      OnClick = Nichtvorhandenelschen1Click
    end
    object PM_PL_ScanForDuplicates: TMenuItem
      Caption = 'Scan for duplicates'
      OnClick = PM_PL_ScanForDuplicatesClick
    end
    object PM_PL_SetRatingofSelectedFilesTo: TMenuItem
      Caption = 'Set rating of selected files to'
      ImageIndex = 20
      object PM_PL_SetRatingsOfSelectedFiles1: TMenuItem
        Caption = '0.5 stars'
        ImageIndex = 23
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles2: TMenuItem
        Tag = 1
        Caption = '1 star'
        ShortCut = 16433
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles3: TMenuItem
        Tag = 2
        Caption = '1.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles4: TMenuItem
        Tag = 3
        Caption = '2 stars'
        ShortCut = 16434
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles5: TMenuItem
        Tag = 4
        Caption = '2.5 stars'
        ImageIndex = 24
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles6: TMenuItem
        Tag = 5
        Caption = '3 stars'
        ShortCut = 16435
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles7: TMenuItem
        Tag = 6
        Caption = '3.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles8: TMenuItem
        Tag = 7
        Caption = '4 stars'
        ShortCut = 16436
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles9: TMenuItem
        Tag = 8
        Caption = '4.5 stars'
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object PM_PL_SetRatingsOfSelectedFiles10: TMenuItem
        Tag = 9
        Caption = '5 stars'
        ImageIndex = 20
        ShortCut = 16437
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
      object N75: TMenuItem
        Caption = '-'
      end
      object PM_PL_ResetRating: TMenuItem
        Tag = 10
        Caption = 'Reset rating/playcounter'
        ImageIndex = 24
        ShortCut = 16432
        OnClick = PM_ML_SetRatingsOfSelectedFilesClick
      end
    end
    object PM_PL_MarkFiles: TMenuItem
      Tag = 150
      Caption = 'Flag selected files with'
      ImageIndex = 34
      object PM_PL_Mark1: TMenuItem
        Tag = 1
        Caption = 'Mark 1'
        ImageIndex = 35
        OnClick = PM_ML_SetmarkerClick
      end
      object PM_PL_Mark2: TMenuItem
        Tag = 2
        Caption = 'Mark 2'
        ImageIndex = 36
        OnClick = PM_ML_SetmarkerClick
      end
      object PM_PL_Mark3: TMenuItem
        Tag = 3
        Caption = 'Mark 3'
        ImageIndex = 37
        OnClick = PM_ML_SetmarkerClick
      end
      object N86: TMenuItem
        Caption = '-'
      end
      object PM_PL_Mark0: TMenuItem
        Caption = 'Unmarked'
        ImageIndex = 34
        OnClick = PM_ML_SetmarkerClick
      end
    end
    object PM_PL_ReplayGain: TMenuItem
      Caption = 'ReplayGain (selected files)'
      ImageIndex = 41
      object PM_PL_ReplayGain_SingleTracks: TMenuItem
        Tag = 100
        Caption = 'Single tracks'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_PL_ReplayGain_OneAlbum: TMenuItem
        Tag = 101
        Caption = 'As one album'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_PL_ReplayGain_MultiAlbums: TMenuItem
        Tag = 102
        Caption = 'Multiple albums (by tags)'
        OnClick = PM_PL_ReplayGain_Click
      end
      object PM_PL_ReplayGain_Clear: TMenuItem
        Tag = 103
        Caption = 'Clear ReplayGain'
        OnClick = PM_PL_ReplayGain_Click
      end
    end
    object N48: TMenuItem
      Caption = '-'
    end
    object PM_PL_PlayInHeadset: TMenuItem
      Caption = 'Play in headset'
      ImageIndex = 7
      ShortCut = 16456
      OnClick = PM_PL_PlayInHeadsetClick
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object PM_PL_ExtendedAddToMedialibrary: TMenuItem
      Caption = 'Add all files to the media library'
      OnClick = PM_PL_ExtendedAddToMedialibraryClick
    end
    object PM_PL_ExtendedCopyToClipboard: TMenuItem
      Caption = 'Copy selected files to clipboard'
      ShortCut = 16451
      OnClick = PM_ML_CopyToClipboardClick
    end
    object PM_PL_MagicCopyToClipboard: TMenuItem
      Caption = '... and include a proper playlist file'
      OnClick = PM_PL_MagicCopyToClipboardClick
    end
    object PM_PL_ExtendedPasteFromClipboard: TMenuItem
      Caption = 'Paste from clipboard'
      ShortCut = 16470
      OnClick = PM_ML_PasteFromClipboardClick
    end
    object PM_PL_CopyPlaylistToUSB: TMenuItem
      Caption = 'Copy files'
      OnClick = PM_PL_CopyPlaylistToUSBClick
    end
    object N24: TMenuItem
      Caption = '-'
    end
    object PM_PL_ExtendedScanFiles: TMenuItem
      Caption = 'Refresh files'
      ImageIndex = 39
      ShortCut = 116
      OnClick = PM_PL_ExtendedScanFilesClick
    end
    object PM_PL_ShowInExplorer: TMenuItem
      Caption = 'Show in Windows Explorer'
      OnClick = PM_PL_ShowInExplorerClick
    end
    object PM_PL_Properties: TMenuItem
      Caption = 'Properties'
      ImageIndex = 6
      ShortCut = 16452
      OnClick = PM_PL_PropertiesClick
    end
  end
  object TNAMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = TaskBarImages
    OnPopup = TNAMenuPopup
    Left = 993
    Top = 408
    object PM_TNA_PlayPause: TMenuItem
      Caption = 'Pause'
      ImageIndex = 1
      OnClick = PlayPauseBTNIMGClick
    end
    object PM_TNA_Stop: TMenuItem
      Caption = 'Stop'
      ImageIndex = 7
      OnClick = StopBTNIMGClick
    end
    object PM_TNA_Next: TMenuItem
      Caption = 'Next track'
      ImageIndex = 3
      OnClick = PlayNextBTNIMGClick
    end
    object PM_TNA_Previous: TMenuItem
      Caption = 'Previous track'
      ImageIndex = 0
      OnClick = PlayPrevBTNIMGClick
    end
    object PM_TNA_Playlist: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Playlist'
      ImageIndex = 6
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object PM_TNA_Restore: TMenuItem
      Caption = 'Restore'
      OnClick = PM_TNA_RestoreClick
    end
    object PM_TNA_Close: TMenuItem
      Caption = 'Close'
      OnClick = PM_TNA_CloseClick
    end
  end
  object Player_PopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = MenuImages
    OnPopup = Player_PopupMenuPopup
    Left = 624
    Top = 114
    object PM_P_Preferences: TMenuItem
      Caption = 'Preferences'
      ImageIndex = 5
      OnClick = MM_O_PreferencesClick
    end
    object PM_P_Wizard: TMenuItem
      Caption = 'Wizard'
      ImageIndex = 32
      OnClick = MM_O_WizardClick
    end
    object PM_P_View: TMenuItem
      Caption = 'View'
      object PM_P_ViewCompact: TMenuItem
        Caption = '[--- Compact view ---]'
        OnClick = PM_P_ViewCompactClick
      end
      object PM_P_ViewCompactComplete: TMenuItem
        Caption = 'Complete'
        Checked = True
        OnClick = MM_O_ViewCompactCompleteClick
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object PM_P_ViewSeparateWindows: TMenuItem
        Tag = 1
        Caption = '[--- Seperate windows ---]'
        OnClick = MM_O_ViewCompactCompleteClick
      end
      object PM_P_ViewSeparateWindows_Equalizer: TMenuItem
        Caption = 'Show file information'
        ShortCut = 8304
        OnClick = PM_P_ViewSeparateWindows_EqualizerClick
      end
      object PM_P_ViewSeparateWindows_Playlist: TMenuItem
        Caption = 'Show playlist'
        Checked = True
        ShortCut = 8305
        OnClick = PM_P_ViewSeparateWindows_PlaylistClick
      end
      object PM_P_ViewSeparateWindows_Medialist: TMenuItem
        Caption = 'Show media library (title list)'
        Checked = True
        ShortCut = 8306
        OnClick = PM_P_ViewSeparateWindows_MedialistClick
      end
      object PM_P_ViewSeparateWindows_Browse: TMenuItem
        Caption = 'Show media library (browse list)'
        Checked = True
        ShortCut = 8307
        OnClick = PM_P_ViewSeparateWindows_BrowseClick
      end
      object PM_P_ViewStayOnTop: TMenuItem
        Caption = 'Stay on top'
        ShortCut = 16468
        OnClick = PM_P_ViewStayOnTopClick
      end
    end
    object PM_P_FormBuilder: TMenuItem
      Caption = 'Form designer'
      OnClick = MM_O_FormBuilderClick
    end
    object PM_P_Skins: TMenuItem
      Caption = 'Skins'
      ImageIndex = 8
      object PM_P_Skins_WindowsStandard: TMenuItem
        Caption = 'Windows standard'
        RadioItem = True
        OnClick = WindowsStandardClick
      end
      object PM_P_Skin_UseAdvancedSkin: TMenuItem
        Caption = 'Use advanced skinning'
        OnClick = MM_O_Skin_UseAdvancedClick
      end
      object N30: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
    end
    object PM_P_Languages: TMenuItem
      Caption = 'Languages'
      object PM_P_Defaultlanguage: TMenuItem
        Tag = -1
        Caption = 'English'
        OnClick = ChangeLanguage
      end
    end
    object N35: TMenuItem
      Caption = '-'
    end
    object PM_P_PartyMode: TMenuItem
      Caption = 'Party mode'
      OnClick = PM_P_PartyModeClick
    end
    object N36: TMenuItem
      Caption = '-'
    end
    object PM_P_ShutDown: TMenuItem
      Caption = 'Shutdown'
      ImageIndex = 16
      object PM_P_ShutDownOff: TMenuItem
        Caption = 'Activate'
        OnClick = Schlafmodusdeaktivieren1Click
      end
      object PM_P_ShutDownSettings: TMenuItem
        Caption = 'Settings'
        OnClick = ActivateShutDownMode
      end
      object PM_P_ShutdownInfo: TMenuItem
        Caption = '(not active)'
        Enabled = False
      end
    end
    object PM_P_Birthday: TMenuItem
      Caption = 'Birthday mode'
      ImageIndex = 2
      object PM_P_BirthdayActivate: TMenuItem
        Caption = 'Activate'
        OnClick = MenuBirthdayStartClick
      end
      object PM_P_BirthdayOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_BirthdayOptionsClick
      end
    end
    object PM_P_RemoteNemp: TMenuItem
      Caption = 'Nemp &Webserver'
      ImageIndex = 9
      object PM_P_WebServerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = MM_T_WebServerActivateClick
      end
      object PM_P_WebServerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = MM_T_WebServerOptionsClick
      end
      object PM_P_WebServerShowLog: TMenuItem
        Caption = 'Show log'
        OnClick = __PM_W_WebServerShowLogClick
      end
    end
    object PM_P_Scrobbler: TMenuItem
      Caption = 'Scrobbler'
      ImageIndex = 18
      object PM_P_ScrobblerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = PM_P_ScrobblerActivateClick
      end
      object PM_P_ScrobblerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_ScrobblerOptionsClick
      end
    end
    object PM_P_EqualizerEffects: TMenuItem
      Caption = 'Equalizer && Effects'
      ImageIndex = 40
      OnClick = TabBtn_EqualizerClick
    end
    object PM_P_KeyboardDisplay: TMenuItem
      Caption = 'Keyboard display'
      ImageIndex = 31
      OnClick = PM_P_KeyboardDisplayClick
    end
    object PM_P_Directories: TMenuItem
      Caption = 'Directories'
      object PM_P_DirectoriesRecordings: TMenuItem
        Caption = 'Recordings (webradio)'
        OnClick = PM_P_DirectoriesRecordingsClick
      end
      object PM_P_DirectoriesData: TMenuItem
        Caption = 'Data (cover, preferences, ...)'
        OnClick = PM_P_DirectoriesDataClick
      end
    end
    object PM_P_PlaylistLog: TMenuItem
      Caption = 'Playlist log'
      OnClick = MM_T_PlaylistLogClick
    end
    object N17: TMenuItem
      Caption = '-'
    end
    object Help1: TMenuItem
      Caption = 'Help'
      ImageIndex = 4
      object PM_P_About: TMenuItem
        Caption = 'About Nemp'
        ImageIndex = 17
        OnClick = MM_H_AboutClick
      end
      object PM_P_CheckForUpdates: TMenuItem
        Caption = 'Check for updates'
        ImageIndex = 22
        OnClick = MM_H_CheckForUpdatesClick
      end
      object PM_P_Help: TMenuItem
        Caption = 'Documentation and user guide'
        ImageIndex = 4
        OnClick = ToolButton7Click
      end
    end
  end
  object VST_ColumnPopup: TPopupMenu
    OnPopup = VST_ColumnPopupPopup
    Left = 388
    Top = 313
  end
  object PopupPlayPause: TPopupMenu
    Left = 253
    Top = 560
    object PM_PlayFiles: TMenuItem
      Caption = 'Play files'
      OnClick = PM_PlayFilesClick
    end
    object PM_PlayWebstream: TMenuItem
      Caption = 'Play webstream'
      OnClick = PM_PlayWebstreamClick
    end
    object PM_PlayCDAudio: TMenuItem
      Caption = 'Play CD-Audio'
      OnClick = PM_PlayCDAudioClick
    end
  end
  object PopupStop: TPopupMenu
    OnPopup = PopupStopPopup
    Left = 325
    Top = 570
    object PM_StopNow: TMenuItem
      Caption = 'Stop'
      OnClick = PM_StopNowClick
    end
    object PM_StopAfterTitle: TMenuItem
      Caption = 'Stop after title (Shift+Click)'
      OnClick = PM_StopAfterTitleClick
    end
  end
  object PopupRepeat: TPopupMenu
    OnPopup = PopupRepeatPopup
    Left = 389
    Top = 570
    object PM_RepeatAll: TMenuItem
      Caption = 'Repeat all'
      RadioItem = True
      OnClick = PM_RepeatMenuClick
    end
    object PM_RepeatTitle: TMenuItem
      Tag = 1
      Caption = 'Repeat title'
      RadioItem = True
      OnClick = PM_RepeatMenuClick
    end
    object PM_RandomMode: TMenuItem
      Tag = 2
      Caption = 'Random mode'
      RadioItem = True
      OnClick = PM_RepeatMenuClick
    end
    object PM_RepeatOff: TMenuItem
      Tag = 3
      Caption = 'Repeat off'
      RadioItem = True
      OnClick = PM_RepeatMenuClick
    end
    object N70: TMenuItem
      Caption = '-'
    end
    object PM_ABRepeat: TMenuItem
      Caption = 'A-B repeat'
      OnClick = BtnABRepeatClick
    end
    object PM_ABRepeatSetA: TMenuItem
      Caption = 'Set start point (A)'
      OnClick = PM_ABRepeatSetAClick
    end
    object PM_ABRepeatSetB: TMenuItem
      Caption = 'Set end point (B)'
      OnClick = PM_ABRepeatSetBClick
    end
  end
  object NempTrayIcon: TTrayIcon
    Hint = 'Nemp - Noch ein mp3-Player'
    PopupMenu = TNAMenu
    OnClick = NempTrayIconClick
    Left = 992
    Top = 448
  end
  object TaskBarImages: TImageList
    Left = 1008
    Top = 248
    Bitmap = {
      494C010108006C07040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000000000
      00005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      000000000000000000005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000000000
      000000000000000000005F5F5F00C3C3C3005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000005F5F5F00C3C3C3005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005F5F5F00C3C3
      C3005F5F5F000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00005F5F5F000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      00005F5F5F000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00F8F8F8007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00F8F8F8007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F000000000000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      000000000000000000000000000000000000000000007F7F7F007F7F7F007F7F
      7F007F7F7F00F8F8F8007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00F8F8F8007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F00F8F8F8007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F00000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E9007F7F7F007F7F7F00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E9007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F0000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F000000000000000000000000007F7F7F00D8D8D800D8D8
      D8007F7F7F0000000000000000000000000000000000000000007F7F7F00D8D8
      D800D8D8D8007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00D8D8
      D800D8D8D8007F7F7F0000000000000000000000000000000000000000007F7F
      7F00D8D8D800D8D8D8007F7F7F0000000000000000007F7F7F00D8D8D800D8D8
      D8007F7F7F00000000000000000000000000000000007F7F7F00D8D8D800D8D8
      D800D8D8D8007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F7F000000
      00000000000000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00D8D8
      D800D8D8D800D8D8D8007F7F7F00000000000000000000000000000000007F7F
      7F00D8D8D800D8D8D8007F7F7F0000000000000000007F7F7F00D8D8D800D8D8
      D8007F7F7F000000000000000000000000007F7F7F00D8D8D800D8D8D800D8D8
      D800D8D8D8007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E9007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00D8D8
      D800D8D8D800D8D8D800D8D8D8007F7F7F000000000000000000000000007F7F
      7F00D8D8D800D8D8D8007F7F7F0000000000000000007F7F7F00D8D8D800D8D8
      D8007F7F7F0000000000000000007F7F7F00D8D8D800D8D8D800D8D8D800D8D8
      D800D8D8D8007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00E9E9
      E900E9E9E900E9E9E9007F7F7F0000000000000000007F7F7F00E9E9E900E9E9
      E900E9E9E9007F7F7F00000000000000000000000000000000007F7F7F00D8D8
      D800D8D8D800D8D8D800D8D8D800D8D8D8007F7F7F0000000000000000007F7F
      7F00D8D8D800D8D8D8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F8007F7F7F00000000007F7F7F00F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F00000000007F7F
      7F00F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F
      7F00F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F8007F7F7F000000000000000000000000007F7F7F00F8F8F800F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F8007F7F7F000000000000000000000000007F7F
      7F00F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F800F8F8F8007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F00000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F8007F7F7F0000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F800F8F8F8007F7F7F000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F00000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000007F7F
      7F00F8F8F800F8F8F8007F7F7F000000000000000000000000007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F0000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F8007F7F7F007F7F7F00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F00F8F8
      F800F8F8F800F8F8F8007F7F7F0000000000000000007F7F7F00F8F8F800F8F8
      F800F8F8F8007F7F7F0000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F00000000000000000000000000000000007F7F7F007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      F007F007F01FE007FC07FC07E00FC003FF07FF07E00FC003FFC7FFC7E00FC003
      FFF7F1F7E00FC003FFFFF1FFE00FC003FFFFF1FFE00FC003803F803FE00FC003
      803F803FE00FC003803F803FE00FC003FFFFF1FFF01FC003FFFFF1FFFFFFE007
      FFFFF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7FFE3C7FFFF
      FFFFC1FFC183FFFFCFE7C0FFC183E7F387C3C03FC183C3E18783C01FC183C1E1
      8703C007C183C0E18603C003C183C0618403C003C183C0218603C007C183C061
      8703C01FC183C0E18783C03FC183C1E187C3C0FFC183C3E1CFE7C1FFC183E7F3
      FFFFE7FFE3C7FFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object Win7TaskBarPopup: TPopupMenu
    OnPopup = Win7TaskBarPopupPopup
    Left = 992
    Top = 368
    object N67: TMenuItem
      Caption = '-'
    end
    object test1: TMenuItem
      Caption = 'Close this menu'
    end
  end
  object HeadSetTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = HeadSetTimerTimer
    Left = 512
    Top = 344
  end
  object RefreshCoverFlowTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = RefreshCoverFlowTimerTimer
    Left = 232
    Top = 336
  end
  object PopupRepeatAB: TPopupMenu
    Left = 448
    Top = 568
    object PM_SetA: TMenuItem
      Caption = 'Set start point (A)'
      OnClick = PM_ABRepeatSetAClick
    end
    object PM_SetB: TMenuItem
      Caption = 'Set end point (B)'
      OnClick = PM_ABRepeatSetBClick
    end
    object N78: TMenuItem
      Caption = '-'
    end
    object PM_StopABrepeat: TMenuItem
      Caption = 'Disable A-B repeat'
      OnClick = BtnABRepeatClick
    end
  end
  object WalkmanModeTimer: TTimer
    Interval = 60000
    OnTimer = WalkmanModeTimerTimer
    Left = 160
    Top = 488
  end
  object CoverFlowRefreshViewTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = CoverFlowRefreshViewTimerTimer
    Left = 232
    Top = 288
  end
  object PopupEditExtendedTags: TPopupMenu
    OnPopup = PopupEditExtendedTagsPopup
    Left = 760
    Top = 528
    object PM_TagAudiofile: TMenuItem
      Caption = 'This audio file'
      Enabled = False
      Visible = False
    end
    object PM_AddTagThisFile: TMenuItem
      Caption = 'Add new tag to this file'
      OnClick = DetailLabelDblClickNewTag
    end
    object PM_RenameTagThisFile: TMenuItem
      Caption = 'Rename tag in this file'
      OnClick = PM_RenameTagThisFileClick
    end
    object PM_RemoveTagThisFile: TMenuItem
      Caption = 'Remove tag from this file'
      OnClick = PM_RemoveTagThisFileClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object PM_TagTagCloud: TMenuItem
      Caption = 'Nemp Tagcloud (Ignore/Rename rules)'
      Enabled = False
      Visible = False
    end
    object PM_TagIgnoreList: TMenuItem
      Caption = 'Add "Ignore rule" and remove this tag from all files'
      OnClick = PM_TagIgnoreListClick
    end
    object PM_TagMergeList: TMenuItem
      Caption = 'Add "Rename rule" and rename this tag in all files'
      OnClick = PM_TagMergeListClick
    end
    object N79: TMenuItem
      Caption = '-'
    end
    object pm_TagDetails: TMenuItem
      Caption = 'Properties'
      OnClick = pm_TagDetailsClick
    end
  end
  object QuickSearchHistory_PopupMenu: TPopupMenu
    OnPopup = QuickSearchHistory_PopupMenuPopup
    Left = 96
    Top = 388
    object pmRecentSearches: TMenuItem
      Caption = 'Recent searches'
      Enabled = False
    end
    object N80: TMenuItem
      Caption = '-'
    end
    object pmQuickSeachHistory0: TMenuItem
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory1: TMenuItem
      Tag = 1
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory2: TMenuItem
      Tag = 2
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory3: TMenuItem
      Tag = 3
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory4: TMenuItem
      Tag = 4
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory5: TMenuItem
      Tag = 5
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory6: TMenuItem
      Tag = 6
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory7: TMenuItem
      Tag = 7
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory8: TMenuItem
      Tag = 8
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
    object pmQuickSeachHistory9: TMenuItem
      Tag = 9
      AutoHotkeys = maManual
      Caption = '.'
      OnClick = pmQuickSeachHistoryClick
    end
  end
  object Medialist_Browse_PopupMenu: TPopupMenu
    Images = MenuImages
    OnPopup = Medialist_Browse_PopupMenuPopup
    Left = 400
    Top = 46
    object PM_ML_EnqueueBrowse: TMenuItem
      Caption = 'Enqueue (at the end of the playlist)'
      OnClick = PM_ML_CollectionPlayEnqueueClick
    end
    object PM_ML_PlayBrowse: TMenuItem
      Tag = 1
      Caption = 'Play (and clear current playlist)'
      OnClick = PM_ML_CollectionPlayEnqueueClick
    end
    object PM_ML_PlayNextBrowse: TMenuItem
      Tag = 2
      Caption = 'Enqueue (after the current title)'
      OnClick = PM_ML_CollectionPlayEnqueueClick
    end
    object N27: TMenuItem
      Caption = '-'
    end
    object PM_ML_SortCollectionBy: TMenuItem
      Caption = 'Sort Collection by'
      object PM_ML_SortCollectionByName: TMenuItem
        Caption = 'Name'
        RadioItem = True
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByAlbum: TMenuItem
        Tag = 1
        Caption = 'Album'
        RadioItem = True
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByArtistAlbum: TMenuItem
        Tag = 2
        Caption = 'Artist and Album'
        RadioItem = True
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByCount: TMenuItem
        Tag = 3
        Caption = 'Count'
        RadioItem = True
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByReleaseYear: TMenuItem
        Tag = 4
        Caption = 'Release Year'
        RadioItem = True
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByFileage: TMenuItem
        Tag = 5
        Caption = 'Fileage'
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByGenre: TMenuItem
        Tag = 6
        Caption = 'Genre'
        OnClick = PM_ML_SortCollectionByClick
      end
      object PM_ML_SortCollectionByDirectory: TMenuItem
        Tag = 7
        Caption = 'Directory'
        OnClick = PM_ML_SortCollectionByClick
      end
    end
    object PM_ML_SortLayerBy: TMenuItem
      Caption = 'Sort layer by'
      object PM_ML_SortLayerByName: TMenuItem
        Caption = 'Name'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByAlbum: TMenuItem
        Tag = 1
        Caption = 'Album'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByArtistAlbum: TMenuItem
        Tag = 2
        Caption = 'Artist and Album'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByCount: TMenuItem
        Tag = 3
        Caption = 'Count'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByReleaseYear: TMenuItem
        Tag = 4
        Caption = 'Release Year'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByFileAge: TMenuItem
        Tag = 5
        Caption = 'Fileage'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByGenre: TMenuItem
        Tag = 6
        Caption = 'Genre'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByDirectory: TMenuItem
        Tag = 7
        Caption = 'Directory'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
    end
    object PM_ML_ConfigureMedialibrary: TMenuItem
      Caption = 'Configure Media library'
      OnClick = PM_ML_ConfigureMedialibraryClick
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object PM_ML_SearchDirectory: TMenuItem
      Caption = 'Search directory for new files'
      ImageIndex = 3
      ShortCut = 16462
      OnClick = MM_ML_SearchDirectoryClick
    end
    object PM_ML_Medialibrary: TMenuItem
      Caption = 'Media library'
      object PM_ML_MedialibraryLoad: TMenuItem
        Caption = 'Load'
        ImageIndex = 0
        OnClick = MM_ML_LoadClick
      end
      object PM_ML_MedialibrarySave: TMenuItem
        Caption = 'Save'
        ImageIndex = 1
        OnClick = MM_ML_SaveClick
      end
      object PM_ML_MedialibraryExport: TMenuItem
        Caption = 'Export as csv'
        ShortCut = 16453
        OnClick = PM_ML_MedialibraryExportClick
      end
      object PM_ML_MedialibraryDelete: TMenuItem
        Caption = '&Delete'
        ImageIndex = 12
        OnClick = MM_ML_DeleteClick
      end
      object N82: TMenuItem
        Caption = '-'
      end
      object PM_ML_MedialibraryRefresh: TMenuItem
        Caption = 'Refresh (rescan all files)'
        ImageIndex = 39
        ShortCut = 16500
        OnClick = MM_ML_RefreshAllClick
      end
      object PM_ML_MedialibraryDeleteNotExisting: TMenuItem
        Caption = 'Cleanup (remove missing files)'
        ImageIndex = 38
        OnClick = DatenbankUpdateTBClick
      end
      object PM_ML_CloudEditor: TMenuItem
        Caption = 'Tag cloud editor'
        ImageIndex = 19
        ShortCut = 24660
        OnClick = PM_ML_CloudEditorClick
      end
    end
    object PM_ML_Webradio: TMenuItem
      Caption = 'Manage webradio stations'
      ShortCut = 16471
      OnClick = MM_ML_WebradioClick
    end
    object PM_ML_RemoveSelectedPlaylists: TMenuItem
      Caption = 'Remove selected playlist'
      ShortCut = 16430
      OnClick = PM_ML_RemoveSelectedPlaylistsClick
    end
  end
  object PopupTools: TPopupMenu
    AutoHotkeys = maManual
    Images = MenuImages
    OnPopup = Player_PopupMenuPopup
    Left = 32
    Top = 546
    object PM_T_ShutDown: TMenuItem
      Caption = 'Shutdown'
      ImageIndex = 16
      object PM_T_ShutDownActivate: TMenuItem
        Caption = 'Activate'
        OnClick = Schlafmodusdeaktivieren1Click
      end
      object PM_T_ShutDownSettings: TMenuItem
        Caption = 'Settings'
        OnClick = ActivateShutDownMode
      end
      object PM_T_ShutdownInfo: TMenuItem
        Caption = '(not active)'
        Enabled = False
      end
    end
    object PM_T_Birthday: TMenuItem
      Caption = 'Birthday mode'
      ImageIndex = 2
      object PM_T_BirthdayActivate: TMenuItem
        Caption = 'Activate'
        OnClick = MenuBirthdayStartClick
      end
      object PM_T_BirthdayOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_BirthdayOptionsClick
      end
    end
    object PM_T_WebServer: TMenuItem
      Caption = 'Nemp &Webserver'
      ImageIndex = 9
      object PM_T_WebServerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = MM_T_WebServerActivateClick
      end
      object PM_T_WebServerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = MM_T_WebServerOptionsClick
      end
      object PM_T_WebServerShowLog: TMenuItem
        Caption = 'Show log'
        OnClick = __PM_W_WebServerShowLogClick
      end
    end
    object PM_T_Scrobbler: TMenuItem
      Caption = 'Scrobbler'
      ImageIndex = 18
      object PM_T_ScrobblerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = PM_P_ScrobblerActivateClick
      end
      object PM_T_ScrobblerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_ScrobblerOptionsClick
      end
    end
  end
  object PopupHeadset: TPopupMenu
    Left = 176
    Top = 560
    object PM_H_EnqueueEndOfPlaylist: TMenuItem
      Caption = 'Enqueue (at the end of the playlist)'
      OnClick = InsertHeadsetToPlaylistClick
    end
    object PM_H_PlayAndClearPlaylist: TMenuItem
      Tag = 1
      Caption = 'Play (and clear current playlist)'
      OnClick = InsertHeadsetToPlaylistClick
    end
    object PM_H_EnqueueAfterCurrentTitle: TMenuItem
      Tag = 2
      Caption = 'Enqueue (after the current title)'
      OnClick = InsertHeadsetToPlaylistClick
    end
    object PM_H_JustPlay: TMenuItem
      Tag = 3
      Caption = 'Just play the track (don'#39't change the playlist)'
      OnClick = InsertHeadsetToPlaylistClick
    end
  end
  object PlaylistManagerPopup: TPopupMenu
    OnPopup = PlaylistManagerPopupPopup
    Left = 696
    Top = 56
    object PM_PLM_Default: TMenuItem
      Tag = -1
      Caption = 'Default playlist'
      RadioItem = True
      OnClick = PM_PLM_SwitchToDefaultPlaylistClick
    end
    object N19: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object PM_PLM_SaveAsExistingFavorite: TMenuItem
      Tag = -1
      Caption = 'Save playlist ""'
      OnClick = PM_PLM_SaveAsExistingFavoriteClick
    end
    object PM_PLM_SaveAsNewFavorite: TMenuItem
      Tag = -1
      Caption = 'Save current playlist as new favorite'
      OnClick = PM_PLM_SaveAsNewFavoriteClick
    end
    object N10: TMenuItem
      Tag = -1
      Caption = '-'
    end
    object PM_PLM_RecentPlaylists: TMenuItem
      Tag = -1
      Caption = 'Recent playlists'
    end
    object PM_PLM_EditFavourites: TMenuItem
      Tag = -1
      Caption = 'Edit favorites'
      OnClick = PM_PLM_EditFavouritesClick
    end
  end
  object NempTaskbarManager: TTaskbar
    Tag = 1
    TaskBarButtons = <
      item
      end
      item
      end
      item
      end
      item
        ButtonState = [Enabled, NoBackground]
      end
      item
      end
      item
      end>
    ProgressMaxValue = 100
    TabProperties = [CustomizedPreview]
    OnThumbPreviewRequest = NempTaskbarManagerThumbPreviewRequest
    OnThumbButtonClick = fspTaskbarManagerThumbButtonClick
    Left = 824
    Top = 164
  end
  object PlaylistVST_HeaderPopup: TPopupMenu
    Left = 744
    Top = 116
    object pmShowColumnIndex: TMenuItem
      Caption = 'Show column "Index"'
      OnClick = pmShowColumnIndexClick
    end
  end
  object DummyImageList: TImageList
    Width = 128
    Left = 464
    Top = 40
  end
  object Medialist_Browse_Categories_PopupMenu: TPopupMenu
    Left = 456
    Top = 180
  end
end
