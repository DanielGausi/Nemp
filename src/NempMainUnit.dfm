object Nemp_MainForm: TNemp_MainForm
  Left = 701
  Top = 286
  Caption = 'Nemp - Noch ein MP3-Player'
  ClientHeight = 1008
  ClientWidth = 845
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
  Scaled = False
  ShowHint = True
  OnActivate = FormActivate
  OnClose = TntFormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = TntFormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = PlaylistVSTKeyUp
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 505
    Width = 845
    Height = 4
    Cursor = crVSplit
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    OnMoved = Splitter1Moved
    ExplicitTop = 425
    ExplicitWidth = 971
  end
  object TopMainPanel: TPanel
    Tag = 200
    Left = 0
    Top = 0
    Width = 845
    Height = 505
    Align = alTop
    BevelOuter = bvNone
    Constraints.MinHeight = 240
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 300
      Top = 0
      Width = 4
      Height = 505
      OnMoved = Splitter2Moved
      ExplicitLeft = 385
      ExplicitHeight = 425
    end
    object AuswahlPanel: TPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 300
      Height = 505
      Align = alLeft
      BevelOuter = bvNone
      Constraints.MinWidth = 250
      TabOrder = 0
      OnMouseDown = AuswahlPanelMouseDown
      OnResize = AuswahlPanelResize
      object GRPBOXArtistsAlben: TNempPanel
        Tag = 2
        Left = 0
        Top = 28
        Width = 300
        Height = 477
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        DragMode = dmAutomatic
        TabOrder = 0
        OnPaint = NewPanelPaint
        OwnerDraw = False
        DesignSize = (
          300
          477)
        object PanelCoverBrowse: TNempPanel
          Tag = 2
          Left = 0
          Top = 71
          Width = 300
          Height = 175
          Anchors = []
          BevelOuter = bvNone
          PopupMenu = Medialist_PopupMenu
          TabOrder = 1
          Visible = False
          OnMouseDown = PanelCoverBrowseMouseDown
          OnMouseMove = IMGMedienBibCoverMouseMove
          OnMouseUp = IMGMedienBibCoverMouseUp
          OnResize = PanelCoverBrowseResize
          OnPaint = PanelCoverBrowsePaint
          OnAfterPaint = PanelCoverBrowseAfterPaint
          OwnerDraw = False
          DesignSize = (
            300
            175)
          object IMGMedienBibCover: TImage
            Left = 0
            Top = 6
            Width = 297
            Height = 24
            Anchors = [akLeft, akTop, akRight, akBottom]
            Center = True
            DragCursor = crDefault
            Proportional = True
            OnMouseDown = IMGMedienBibCoverMouseDown
            OnMouseMove = IMGMedienBibCoverMouseMove
            OnMouseUp = IMGMedienBibCoverMouseUp
            ExplicitWidth = 353
            ExplicitHeight = 59
          end
          object ImgScrollCover: TImage
            Left = 0
            Top = 36
            Width = 297
            Height = 75
            Anchors = [akLeft, akRight, akBottom]
            Transparent = True
            OnMouseDown = ImgScrollCoverMouseDown
            ExplicitTop = 71
            ExplicitWidth = 353
          end
          object CoverScrollbar: TScrollBar
            Left = 6
            Top = 156
            Width = 292
            Height = 17
            Anchors = [akLeft, akRight, akBottom]
            LargeChange = 3
            Max = 3
            PageSize = 3
            TabOrder = 0
            OnChange = CoverScrollbarChange
            OnKeyDown = CoverScrollbarKeyDown
          end
          object Panel1: TNempPanel
            Tag = 2
            Left = 30
            Top = 117
            Width = 233
            Height = 33
            Anchors = [akLeft, akRight, akBottom]
            BevelOuter = bvNone
            Caption = 'Panel1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindow
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowCaption = False
            TabOrder = 1
            OnPaint = NewPanelPaint
            OwnerDraw = False
            DesignSize = (
              233
              33)
            object Lbl_CoverFlow: TLabel
              Left = 0
              Top = 8
              Width = 233
              Height = 13
              Alignment = taCenter
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              ShowAccelChar = False
              Transparent = False
              OnMouseDown = Lbl_CoverFlowMouseDown
              ExplicitWidth = 289
            end
          end
        end
        object PanelStandardBrowse: TPanel
          Tag = 2
          Left = 4
          Top = 6
          Width = 290
          Height = 59
          Anchors = []
          BevelOuter = bvNone
          PopupMenu = Medialist_PopupMenu
          TabOrder = 0
          object Splitter3: TSplitter
            Left = 73
            Top = 0
            Height = 59
            OnMoved = Splitter3Moved
            ExplicitHeight = 178
          end
          object ArtistsVST: TVirtualStringTree
            Tag = 1
            Left = 0
            Top = 0
            Width = 73
            Height = 59
            Align = alLeft
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Constraints.MinWidth = 20
            DefaultNodeHeight = 14
            DragMode = dmAutomatic
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.AutoSizeIndex = 0
            Header.Background = clWindow
            Header.DefaultHeight = 17
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoDrag, hoVisible]
            Header.Style = hsXPStyle
            IncrementalSearch = isAll
            Indent = 12
            Margin = 0
            ParentFont = False
            PopupMenu = Medialist_PopupMenu
            ScrollBarOptions.ScrollBars = ssVertical
            TabOrder = 0
            TextMargin = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
            OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
            OnAfterItemErase = VSTAfterItemErase
            OnClick = ArtistsVSTClick
            OnFocusChanged = ArtistsVSTFocusChanged
            OnGetText = StringVSTGetText
            OnPaintText = ArtistsVSTPaintText
            OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
            OnIncrementalSearch = ArtistsVSTIncrementalSearch
            OnKeyDown = StringVSTKeyDown
            OnResize = ArtistsVSTResize
            OnStartDrag = ArtistsVSTStartDrag
            Columns = <
              item
                MinWidth = 0
                Position = 0
                Width = 73
              end>
          end
          object AlbenVST: TVirtualStringTree
            Tag = 2
            Left = 76
            Top = 0
            Width = 214
            Height = 59
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            Constraints.MinWidth = 20
            DefaultNodeHeight = 14
            DragMode = dmAutomatic
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Header.AutoSizeIndex = 0
            Header.Background = clWindow
            Header.DefaultHeight = 17
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Options = [hoAutoResize, hoDrag, hoVisible]
            Header.Style = hsXPStyle
            IncrementalSearch = isAll
            Indent = 12
            Margin = 0
            ParentFont = False
            PopupMenu = Medialist_PopupMenu
            ScrollBarOptions.ScrollBars = ssVertical
            TabOrder = 1
            TextMargin = 0
            TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
            TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
            TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
            OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
            OnAfterItemErase = VSTAfterItemErase
            OnClick = AlbenVSTClick
            OnColumnDblClick = AlbenVSTColumnDblClick
            OnFocusChanged = AlbenVSTFocusChanged
            OnGetText = StringVSTGetText
            OnPaintText = ArtistsVSTPaintText
            OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
            OnIncrementalSearch = ArtistsVSTIncrementalSearch
            OnKeyDown = StringVSTKeyDown
            OnResize = AlbenVSTResize
            OnStartDrag = AlbenVSTStartDrag
            Columns = <
              item
                MinWidth = 0
                Position = 0
                Width = 214
              end>
          end
        end
        object PanelTagCloudBrowse: TNempPanel
          Tag = 2
          Left = 6
          Top = 286
          Width = 275
          Height = 114
          BevelOuter = bvNone
          TabOrder = 2
          Visible = False
          OnResize = PanelTagCloudBrowseResize
          OnPaint = PanelPaint
          OwnerDraw = False
        end
      end
      object AuswahlHeaderPanel: TNempPanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 300
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        OnPaint = PanelPaint
        OwnerDraw = False
        DesignSize = (
          300
          28)
        object TabBtn_Preselection: TSkinButton
          Tag = 1
          Left = 2
          Top = 2
          Width = 24
          Height = 24
          Hint = 'Show context menu'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Medialist_PopupMenu
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
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Medialist_PopupMenu
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
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Medialist_PopupMenu
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
          Tag = 3
          Left = 114
          Top = 2
          Width = 186
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 3
          OnPaint = TABPanelPaint
          OwnerDraw = False
          DesignSize = (
            186
            24)
          object AuswahlStatusLBL: TLabel
            Left = 10
            Top = 7
            Width = 170
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
            Transparent = False
          end
        end
        object TabBtn_TagCloud: TSkinButton
          Tag = 2
          Left = 86
          Top = 2
          Width = 24
          Height = 24
          Hint = 'Tag cloud'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Medialist_PopupMenu
          ShowHint = True
          TabOrder = 4
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
      end
    end
    object PlayerPanel: TNempPanel
      Left = 304
      Top = 0
      Width = 234
      Height = 505
      Align = alLeft
      BevelOuter = bvNone
      DragCursor = crSizeWE
      TabOrder = 1
      OnMouseDown = PaintFrameMouseDown
      OnMouseMove = PaintFrameMouseMove
      OnMouseUp = PaintFrameMouseUp
      OnPaint = PanelPaint
      OwnerDraw = False
      object GRPBOXCover: TNempPanel
        Tag = 5
        Left = 2
        Top = 150
        Width = 191
        Height = 180
        BevelOuter = bvNone
        PopupMenu = Player_PopupMenu
        TabOrder = 6
        OnMouseDown = PaintFrameMouseDown
        OnMouseMove = PaintFrameMouseMove
        OnMouseUp = PaintFrameMouseUp
        OnPaint = PanelPaint
        OwnerDraw = False
        object CoverImage: TImage
          Left = 0
          Top = 0
          Width = 191
          Height = 180
          Align = alClient
          Center = True
          PopupMenu = Player_PopupMenu
          Proportional = True
          Stretch = True
          OnDblClick = CoverImageDblClick
          ExplicitTop = 2
          ExplicitWidth = 189
          ExplicitHeight = 175
        end
      end
      object TabBtn_Nemp: TSkinButton
        Left = 10
        Top = 377
        Width = 24
        Height = 24
        Hint = 'Show context menu'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        PopupMenu = Player_PopupMenu
        ShowHint = True
        TabOrder = 3
        TabStop = False
        OnClick = PlayerTabsClick
        OnMouseMove = TabBtn_CoverMouseMove
        DrawMode = dm_Skin
        NumGlyphsX = 5
        NumGlyphsY = 1
        GlyphLine = 0
        CustomRegion = False
        FocusDrawMode = fdm_Windows
        Color1 = clBlack
        Color2 = clBlack
      end
      object NewPlayerPanel: TNempPanel
        Left = 2
        Top = 2
        Width = 230
        Height = 116
        BevelInner = bvRaised
        BevelOuter = bvLowered
        PopupMenu = Player_PopupMenu
        TabOrder = 4
        OnDragOver = GRPBOXControlDragOver
        OnMouseDown = PaintFrameMouseDown
        OnMouseMove = PaintFrameMouseMove
        OnMouseUp = PaintFrameMouseUp
        OnPaint = PanelPaint
        OwnerDraw = False
        DesignSize = (
          230
          116)
        object PaintFrame: TImage
          Left = 96
          Top = 25
          Width = 113
          Height = 38
          OnDragOver = GRPBOXControlDragOver
          OnMouseDown = PaintFrameMouseDown
          OnMouseMove = PaintFrameMouseMove
          OnMouseUp = PaintFrameMouseUp
        end
        object TextAnzeigeIMAGE: TImage
          Left = 4
          Top = 5
          Width = 216
          Height = 14
          Anchors = [akLeft, akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          OnClick = AnzeigeBTNClick
          OnMouseDown = AnzeigeBTNMouseDown
        end
        object TimePaintBox: TImage
          Left = 8
          Top = 49
          Width = 53
          Height = 14
          ParentShowHint = False
          ShowHint = True
          OnClick = BassTimeLBLClick
          OnDragOver = GRPBOXControlDragOver
        end
        object SlideBarShape: TShape
          Left = 16
          Top = 68
          Width = 193
          Height = 6
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeWE
          Shape = stRoundRect
          OnDragOver = GRPBOXControlDragOver
          OnMouseDown = SlideBarShapeMouseDown
        end
        object VolShape: TShape
          Left = 214
          Top = 29
          Width = 6
          Height = 34
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
          OnDragOver = GRPBOXControlDragOver
        end
        object SleepImage: TImage
          Left = 167
          Top = 47
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
          PopupMenu = SleepPopup
          Proportional = True
          ShowHint = True
          Stretch = True
          OnClick = SleepImageClick
        end
        object WebserverImage: TImage
          Left = 189
          Top = 47
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
          PopupMenu = WebServerPopup
          Proportional = True
          ShowHint = True
          Stretch = True
          OnClick = WebserverImageClick
        end
        object BirthdayImage: TImage
          Left = 145
          Top = 47
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
          PopupMenu = BirthdayPopup
          Proportional = True
          ShowHint = True
          Stretch = True
          OnClick = BirthdayImageClick
        end
        object ScrobblerImage: TImage
          Left = 67
          Top = 47
          Width = 16
          Height = 16
          Hint = 'Nemp LastFM Scrobbler'
          ParentShowHint = False
          Picture.Data = {
            07544269746D617036030000424D360300000000000036000000280000001000
            0000100000000100180000000000000300000000000000000000000000000000
            0000000000000000000000000000000000000000111111222222222222111111
            000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFF3333
            336666999999CC9999FF9999FF9999CC6666CC333366000011FFFFFFFFFFFF00
            0000000000FFFFFF0000113333999999FF9999FF9999FF9999FF9999FF9999FF
            9999FF9999FF666699111111FFFFFF000000000000FFFFFF3333996666FF6666
            CC6666CC6666CC9966CC9966CC9966CC6666CC6666CC6666FF6633CC00001100
            00000000003333666666FF6666CC9999FFCCCCFFCCCCFF9966CC6666CC6666CC
            9999FFCCCCFF9999CC6666FF3333990000000000113333CC6633CCCCCCFFCCCC
            FF9966CC9999FFEEEEEE6666CC9999CCCCCCFF9966CCCCCCFFCC99FF3333CC00
            00220000443333CC9999FF9999FF3300CC3333CC3333CC6633CC6633CCCCCCFF
            6633CC3300CC6633CCCCCCFF3333CC3300663300663333CCCCCCFF6633CC3333
            CC3333CC6633CC3333CC9999CCCCCCFF6633CC9966CCCCCCFF9999FF3300CC33
            00993300666633CCCCCCFF9999CC6666CC6666CC6666CC6666CCCCCCFF9999FF
            CCCCFFCCCCFF9999FF6666CC6666CC3333CC3300666666FFCC99FFCCCCFF6666
            CC6666CC6666CCCC99FFCCCCFF9999FFCCCCFF6666CC6666CC6666CC9966FF33
            33990000336666CC9966CCCCCCFFEEEEEECCCCFFCCCCFFEEEEEE9999CC9999CC
            EEEEEECCCCFFCCCCFF9999CC9966FF3333990000006666CC9999FF9966CC9999
            FFCCCCFFCC99FF9999CC9999CC9999CC9999FFCC99FF9999FF9999FF6666CC33
            33CC0000003300669999FF9999FF9999FF9999FF9999FF9999FF9999FF9999FF
            9999FF9999FF9999FF9999FF6633CC000000000000FFFFFF3333999999FFCC99
            FF9999FF9999FF9999FF9999FF9999FF9999FF9999FFCC99FF6666CC3300CC00
            0000000000FFFFFFFFFFFF6633CC9999FFCC99FFCC99FFCC99FFCC99FFCC99FF
            CCCCFF9999FF6633CC3300CCFFFFFF0000000000000000000000000000003333
            CC6633CC6666CC9966CC9999CC9966CC6633CC3333CC00000000000000000000
            0000}
          PopupMenu = ScrobblerPopup
          Proportional = True
          ShowHint = True
          Stretch = True
          OnClick = ScrobblerImageClick
        end
        object RatingImage: TImage
          Left = 8
          Top = 25
          Width = 70
          Height = 14
          Transparent = True
          OnDragOver = GRPBOXControlDragOver
          OnMouseDown = RatingImageMouseDown
          OnMouseLeave = RatingImageMouseLeave
          OnMouseMove = RatingImageMouseMove
        end
        object LblPlayerTitle: TLabel
          Left = 42
          Top = 103
          Width = 12
          Height = 13
          Caption = '...'
          Visible = False
          OnDragOver = GRPBOXControlDragOver
        end
        object LblPlayerArtist: TLabel
          Left = 4
          Top = 96
          Width = 12
          Height = 13
          Caption = '...'
          Visible = False
          OnDragOver = GRPBOXControlDragOver
        end
        object LblPlayerAlbum: TLabel
          Left = 22
          Top = 96
          Width = 12
          Height = 13
          Caption = '...'
          Visible = False
          OnDragOver = GRPBOXControlDragOver
        end
        object SlideBarButton: TSkinButton
          Left = 20
          Top = 66
          Width = 25
          Height = 10
          DoubleBuffered = True
          DragCursor = crSizeWE
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 0
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
        object SlideBackBTN: TSkinButton
          Tag = -1
          Left = 20
          Top = 88
          Width = 14
          Height = 14
          Hint = 'Slide backward'
          DoubleBuffered = True
          ParentDoubleBuffered = False
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
        object PlayPrevBTN: TSkinButton
          Left = 60
          Top = 88
          Width = 14
          Height = 14
          Hint = 'Previous title'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
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
        object PlayPauseBTN: TSkinButton
          Left = 80
          Top = 88
          Width = 14
          Height = 20
          Hint = 'Play'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = PopupPlayPause
          ShowHint = True
          TabOrder = 3
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
          Left = 120
          Top = 88
          Width = 14
          Height = 14
          Hint = 'Stop'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = PopupStop
          ShowHint = True
          TabOrder = 4
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
        object RecordBtn: TSkinButton
          Left = 140
          Top = 88
          Width = 14
          Height = 14
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
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
        object PlayNextBTN: TSkinButton
          Left = 100
          Top = 88
          Width = 14
          Height = 14
          Hint = 'Next title'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
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
        object SlideForwardBTN: TSkinButton
          Tag = 1
          Left = 40
          Top = 88
          Width = 14
          Height = 14
          Hint = 'Slide forward'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
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
        object RandomBtn: TSkinButton
          Left = 160
          Top = 88
          Width = 14
          Height = 14
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = PopupRepeat
          ShowHint = True
          TabOrder = 8
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
          Left = 211
          Top = 54
          Width = 12
          Height = 12
          Hint = 'Volume'
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
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
        object BtnMenu: TSkinButton
          Left = 196
          Top = 79
          Width = 12
          Height = 12
          Hint = 'Show menu'
          Anchors = [akTop, akRight]
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 10
          TabStop = False
          OnClick = BtnMenuClick
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
          Left = 200
          Top = 7
          Width = 12
          Height = 12
          Hint = 'Minimize'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 11
          TabStop = False
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
        object BtnClose: TSkinButton
          Left = 214
          Top = 7
          Width = 12
          Height = 12
          Hint = 'Close Nemp'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
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
      end
      object AudioPanel: TNempPanel
        Tag = 5
        Left = 2
        Top = 121
        Width = 230
        Height = 184
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 5
        OnPaint = PanelPaint
        OwnerDraw = True
        object TabBtn_Cover: TSkinButton
          Tag = 1
          Left = 197
          Top = 32
          Width = 24
          Height = 24
          Hint = 'Show cover'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Player_PopupMenu
          ShowHint = True
          TabOrder = 0
          OnClick = PlayerTabsClick
          OnMouseMove = TabBtn_CoverMouseMove
          DrawMode = dm_Skin
          NumGlyphsX = 5
          NumGlyphsY = 2
          GlyphLine = 1
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
        end
        object TabBtn_Lyrics: TSkinButton
          Tag = 2
          Left = 197
          Top = 62
          Width = 24
          Height = 24
          Hint = 'Show lyrics'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Player_PopupMenu
          ShowHint = True
          TabOrder = 1
          OnClick = PlayerTabsClick
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
        object TabBtn_Equalizer: TSkinButton
          Tag = 3
          Left = 197
          Top = 92
          Width = 24
          Height = 24
          Hint = 'Show equalizer'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Player_PopupMenu
          ShowHint = True
          TabOrder = 2
          OnClick = PlayerTabsClick
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
        object TabBtn_Effects: TSkinButton
          Tag = 4
          Left = 197
          Top = 122
          Width = 24
          Height = 24
          Hint = 'Show effects'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Player_PopupMenu
          ShowHint = True
          TabOrder = 3
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
      end
      object GRPBOXEqualizer: TNempPanel
        Tag = 5
        Left = 37
        Top = 377
        Width = 191
        Height = 180
        BevelOuter = bvNone
        TabOrder = 1
        OnDragOver = GRPBOXEqualizerDragOver
        OnPaint = PanelPaint
        OwnerDraw = False
        object EqualizerShape5: TShape
          Left = 88
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape2: TShape
          Left = 40
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape3: TShape
          Left = 56
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape4: TShape
          Left = 72
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape6: TShape
          Left = 104
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape7: TShape
          Left = 120
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape8: TShape
          Left = 136
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape9: TShape
          Left = 152
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerShape10: TShape
          Left = 168
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EQLBL1: TLabel
          Left = 20
          Top = 100
          Width = 8
          Height = 10
          Caption = '30'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL2: TLabel
          Left = 37
          Top = 100
          Width = 8
          Height = 10
          Caption = '60'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL3: TLabel
          Left = 50
          Top = 100
          Width = 12
          Height = 10
          Caption = '120'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL4: TLabel
          Left = 67
          Top = 100
          Width = 12
          Height = 10
          Caption = '250'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL5: TLabel
          Left = 84
          Top = 100
          Width = 12
          Height = 10
          Caption = '500'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL6: TLabel
          Left = 102
          Top = 100
          Width = 9
          Height = 10
          Caption = '1K'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL7: TLabel
          Left = 118
          Top = 100
          Width = 9
          Height = 10
          Caption = '2K'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL8: TLabel
          Left = 132
          Top = 100
          Width = 9
          Height = 10
          Caption = '4K'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL9: TLabel
          Left = 148
          Top = 100
          Width = 13
          Height = 10
          Caption = '12K'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EQLBL10: TLabel
          Left = 164
          Top = 100
          Width = 13
          Height = 10
          Caption = '16K'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Tahoma'
          Font.Pitch = fpVariable
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object EqualizerShape1: TShape
          Left = 24
          Top = 8
          Width = 4
          Height = 85
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
        end
        object EqualizerDefaultShape: TShape
          Left = 16
          Top = 50
          Width = 163
          Height = 1
          Pen.Color = clGradientActiveCaption
        end
        object EqualizerButton1: TSkinButton
          Left = 21
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 0
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton2: TSkinButton
          Tag = 1
          Left = 37
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 1
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 2
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton3: TSkinButton
          Tag = 2
          Left = 53
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 2
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton5: TSkinButton
          Tag = 4
          Left = 85
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 4
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton4: TSkinButton
          Tag = 3
          Left = 69
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 3
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton6: TSkinButton
          Tag = 5
          Left = 101
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 5
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton7: TSkinButton
          Tag = 6
          Left = 117
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 6
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton8: TSkinButton
          Tag = 7
          Left = 133
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 7
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton9: TSkinButton
          Tag = 8
          Left = 149
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 8
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EqualizerButton10: TSkinButton
          Tag = 9
          Left = 165
          Top = 38
          Width = 10
          Height = 25
          DoubleBuffered = True
          DragCursor = crSizeNS
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 9
          OnDragOver = EqualizerButton1DragOver
          OnEndDrag = EqualizerButton1EndDrag
          OnKeyDown = EqualizerButton9KeyDown
          OnMouseDown = EqualizerButton1MouseDown
          OnStartDrag = EqualizerButton1StartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object Btn_EqualizerPresets: TSkinButton
          Left = 24
          Top = 116
          Width = 147
          Height = 21
          Caption = 'Select'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 10
          OnClick = Btn_EqualizerPresetsClick
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
      object GRPBOXLyrics: TNempPanel
        Tag = 5
        Left = 8
        Top = 150
        Width = 218
        Height = 81
        BevelOuter = bvNone
        PopupMenu = Player_PopupMenu
        TabOrder = 0
        OnMouseDown = PaintFrameMouseDown
        OnMouseMove = PaintFrameMouseMove
        OnMouseUp = PaintFrameMouseUp
        OnPaint = PanelPaint
        OwnerDraw = False
        object LyricsMemo: TMemo
          Left = 0
          Top = 0
          Width = 218
          Height = 81
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Lines.Strings = (
            'LyricsMemo')
          PopupMenu = Player_PopupMenu
          ReadOnly = True
          TabOrder = 0
          OnKeyDown = LyricsMemoKeyDown
        end
      end
      object GRPBOXEffekte: TNempPanel
        Tag = 5
        Left = 8
        Top = 199
        Width = 191
        Height = 180
        BevelOuter = bvNone
        TabOrder = 2
        OnDragOver = GRPBOXEffekteDragOver
        OnPaint = PanelPaint
        OwnerDraw = False
        object HallShape: TShape
          Left = 13
          Top = 19
          Width = 125
          Height = 4
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
          OnMouseDown = HallShapeMouseDown
        end
        object HallLBL: TLabel
          Left = 149
          Top = 14
          Width = 3
          Height = 13
          Transparent = True
        end
        object EchoWetDryMixShape: TShape
          Left = 13
          Top = 51
          Width = 125
          Height = 4
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
          OnMouseDown = EchoWetDryMixShapeMouseDown
        end
        object EchoTimeShape: TShape
          Left = 13
          Top = 67
          Width = 125
          Height = 4
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
          OnMouseDown = EchoTimeShapeMouseDown
        end
        object EchoTimeLBL: TLabel
          Left = 149
          Top = 62
          Width = 3
          Height = 13
          Transparent = True
        end
        object EchoMixLBL: TLabel
          Left = 149
          Top = 46
          Width = 3
          Height = 13
          Transparent = True
        end
        object EffekteLBL2: TLabel
          Left = 13
          Top = 35
          Width = 23
          Height = 13
          Caption = 'Echo'
          Transparent = True
        end
        object EffekteLBL1: TLabel
          Left = 13
          Top = 3
          Width = 17
          Height = 13
          Caption = 'Hall'
          Transparent = True
        end
        object SampleRateShape: TShape
          Left = 13
          Top = 99
          Width = 125
          Height = 4
          Brush.Color = clGradientActiveCaption
          DragCursor = crSizeNS
          Shape = stRoundRect
          OnMouseDown = SampleRateShapeMouseDown
        end
        object SampleRateLBL: TLabel
          Left = 149
          Top = 94
          Width = 3
          Height = 13
          Transparent = True
        end
        object EffekteLBL3: TLabel
          Left = 13
          Top = 83
          Width = 30
          Height = 13
          Caption = 'Speed'
          Transparent = True
        end
        object DirectionPositionBTN: TSkinButton
          Left = 9
          Top = 115
          Width = 24
          Height = 24
          Hint = 'Play backwards'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = DirectionPositionBTNClick
          DrawMode = dm_Skin
          NumGlyphsX = 5
          NumGlyphsY = 2
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
        end
        object Btn_EffectsOff: TBitBtn
          Left = 66
          Top = 113
          Width = 99
          Height = 25
          Caption = 'Disable effects'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 5
          OnClick = Btn_EffectsOffClick
        end
        object EchoWetDryMixButton: TSkinButton
          Tag = 1
          Left = 13
          Top = 48
          Width = 25
          Height = 10
          DoubleBuffered = True
          DragCursor = crSizeWE
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 1
          OnDragOver = GRPBOXEffekteDragOver
          OnEndDrag = EffectsButtonEndDrag
          OnKeyDown = EchoWetDryMixButtonKeyDown
          OnMouseDown = EchoWetDryMixButtonMouseDown
          OnStartDrag = EchoWetDryMixButtonStartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object HallButton: TSkinButton
          Tag = 1
          Left = 13
          Top = 16
          Width = 25
          Height = 10
          DoubleBuffered = True
          DragCursor = crSizeWE
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 0
          OnDragOver = GRPBOXEffekteDragOver
          OnEndDrag = EffectsButtonEndDrag
          OnKeyDown = HallButtonKeyDown
          OnMouseDown = HallButtonMouseDown
          OnStartDrag = HallButtonStartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object EchoTimeButton: TSkinButton
          Tag = 1
          Left = 13
          Top = 64
          Width = 25
          Height = 10
          DoubleBuffered = True
          DragCursor = crSizeWE
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 2
          OnDragOver = GRPBOXEffekteDragOver
          OnEndDrag = EffectsButtonEndDrag
          OnKeyDown = EchoTimeButtonKeyDown
          OnMouseDown = EchoTimeButtonMouseDown
          OnStartDrag = EchoWetDryMixButtonStartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
        object SampleRateButton: TSkinButton
          Tag = 1
          Left = 63
          Top = 96
          Width = 25
          Height = 10
          DoubleBuffered = True
          DragCursor = crSizeWE
          DragMode = dmAutomatic
          ParentDoubleBuffered = False
          TabOrder = 3
          OnDragOver = GRPBOXEffekteDragOver
          OnEndDrag = EffectsButtonEndDrag
          OnKeyDown = SampleRateButtonKeyDown
          OnMouseDown = SampleRateButtonMouseDown
          OnStartDrag = SampleRateButtonStartDrag
          DrawMode = dm_Windows
          NumGlyphsX = 5
          NumGlyphsY = 1
          GlyphLine = 0
          CustomRegion = False
          FocusDrawMode = fdm_Windows
          Color1 = clBlack
          Color2 = clBlack
          AcceptArrowKeys = True
        end
      end
    end
    object PlaylistPanel: TNempPanel
      Tag = 1
      Left = 538
      Top = 0
      Width = 307
      Height = 505
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 2
      OnResize = PlaylistPanelResize
      OnPaint = PanelPaint
      OwnerDraw = False
      object GRPBOXPlaylist: TNempPanel
        Tag = 1
        Left = 0
        Top = 28
        Width = 307
        Height = 477
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        OnPaint = NewPanelPaint
        OwnerDraw = False
        DesignSize = (
          307
          477)
        object PlaylistVST: TVirtualStringTree
          Left = 4
          Top = 2
          Width = 299
          Height = 469
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          DefaultPasteMode = amInsertAfter
          DragImageKind = diMainColumnOnly
          DragMode = dmAutomatic
          DragWidth = 10
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.AutoSizeIndex = -1
          Header.Background = clWindow
          Header.DefaultHeight = 17
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoDrag, hoVisible]
          Header.Style = hsXPStyle
          HintMode = hmHint
          Images = PlayListImageList
          Indent = 12
          Margin = 0
          ParentFont = False
          ParentShowHint = False
          PopupMenu = PlayListPOPUP
          ScrollBarOptions.ScrollBars = ssVertical
          ShowHint = True
          TabOrder = 0
          TextMargin = 0
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
          TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
          OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
          OnAfterItemErase = VSTAfterItemErase
          OnAfterItemPaint = PlaylistVSTAfterItemPaint
          OnBeforeItemErase = VSTBeforeItemErase
          OnChange = PlaylistVSTChange
          OnCollapsed = PlaylistVSTCollapsAndExpanded
          OnColumnDblClick = PlaylistVSTColumnDblClick
          OnDragOver = PlaylistVSTDragOver
          OnDragDrop = PlaylistVSTDragDrop
          OnEnter = PlaylistVSTEnter
          OnExpanded = PlaylistVSTCollapsAndExpanded
          OnGetText = PlaylistVSTGetText
          OnPaintText = VSTPaintText
          OnGetImageIndex = PlaylistVSTGetImageIndex
          OnGetHint = PlaylistVSTGetHint
          OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
          OnKeyDown = PlaylistVSTKeyDown
          OnKeyUp = PlaylistVSTKeyUp
          OnMouseDown = PlaylistVSTMouseDown
          OnMouseUp = PlaylistVSTMouseUp
          OnResize = PlaylistVSTResize
          OnScroll = PlaylistVSTScroll
          OnStartDrag = PlaylistVSTStartDrag
          Columns = <
            item
              Margin = 0
              Position = 0
              Spacing = 0
              Width = 250
              WideText = 'Title'
            end
            item
              Alignment = taRightJustify
              Margin = 0
              Position = 1
              Spacing = 0
              Width = 40
              WideText = 'Time'
            end>
        end
      end
      object PlayerHeaderPanel: TNempPanel
        Tag = 1
        Left = 0
        Top = 0
        Width = 307
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        OnPaint = PanelPaint
        OwnerDraw = False
        DesignSize = (
          307
          28)
        object PlaylistFillPanel: TNempPanel
          Tag = 1
          Left = 28
          Top = 2
          Width = 279
          Height = 24
          Anchors = [akLeft, akTop, akRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          OnPaint = TABPanelPaint
          OwnerDraw = False
          DesignSize = (
            279
            24)
          object PlayListStatusLBL: TLabel
            Left = 8
            Top = 5
            Width = 262
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            ShowAccelChar = False
            Transparent = False
            ExplicitWidth = 302
          end
        end
        object TabBtn_Playlist: TSkinButton
          Left = 2
          Top = 2
          Width = 24
          Height = 24
          Hint = 'Show context menu'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
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
      end
    end
  end
  object VSTPanel: TPanel
    Tag = 3
    Left = 0
    Top = 509
    Width = 845
    Height = 499
    Align = alClient
    BevelOuter = bvNone
    Caption = '3'
    TabOrder = 1
    OnResize = VSTPanelResize
    object GRPBOXVST: TNempPanel
      Tag = 3
      Left = 0
      Top = 28
      Width = 845
      Height = 471
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      DoubleBuffered = True
      ParentDoubleBuffered = False
      PopupMenu = Medialist_PopupMenu
      TabOrder = 1
      OnPaint = NewPanelPaint
      OwnerDraw = False
      DesignSize = (
        845
        471)
      object VSTSubPanel: TNempPanel
        Left = 4
        Top = 4
        Width = 837
        Height = 461
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 0
        OwnerDraw = False
        object Splitter4: TSplitter
          Left = 400
          Top = 0
          Width = 4
          Height = 461
          OnCanResize = Splitter4CanResize
          OnMoved = Splitter1Moved
          ExplicitLeft = 250
          ExplicitHeight = 175
        end
        object VST: TVirtualStringTree
          Left = 404
          Top = 0
          Width = 433
          Height = 461
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Constraints.MinHeight = 50
          DragImageKind = diMainColumnOnly
          DragMode = dmAutomatic
          DragWidth = 10
          EditDelay = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.AutoSizeIndex = -1
          Header.Background = clWindow
          Header.DefaultHeight = 17
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoRestrictDrag, hoShowSortGlyphs, hoVisible]
          Header.SortColumn = 0
          Header.Style = hsXPStyle
          HintMode = hmHint
          IncrementalSearch = isAll
          Indent = 0
          Margin = 0
          ParentFont = False
          ParentShowHint = False
          PopupMenu = Medialist_PopupMenu
          ShowHint = True
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
          OnColumnDblClick = VSTColumnDblClick
          OnColumnWidthDblClickResize = VSTColumnWidthDblClickResize
          OnCreateEditor = VSTCreateEditor
          OnEditCancelled = VSTEditCancelled
          OnEdited = VSTEdited
          OnEditing = VSTEditing
          OnEnter = VSTEnter
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
          OnMouseMove = VSTMouseMove
          OnNewText = VSTNewText
          OnStartDrag = VSTStartDrag
          Columns = <
            item
              Position = 0
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
            end>
        end
        object VDTCover: TNempPanel
          Tag = 3
          Left = 0
          Top = 0
          Width = 400
          Height = 461
          Align = alLeft
          BevelOuter = bvNone
          Constraints.MinWidth = 20
          PopupMenu = Medialist_PopupMenu
          TabOrder = 1
          OnClick = VDTCoverClick
          OnResize = VDTCoverResize
          OnPaint = PanelPaint
          OwnerDraw = False
          object ImgDetailCover: TImage
            Left = 2
            Top = 2
            Width = 150
            Height = 150
            Center = True
            Proportional = True
            Stretch = True
            OnClick = VDTCoverClick
          end
          object LblBibArtist: TLabel
            Left = 158
            Top = 2
            Width = 65
            Height = 13
            Caption = 'LblBibArtist'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibTitle: TLabel
            Tag = 1
            Left = 158
            Top = 19
            Width = 58
            Height = 13
            Caption = 'LblBibTitle'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibAlbum: TLabel
            Tag = 2
            Left = 158
            Top = 36
            Width = 56
            Height = 13
            Caption = 'LblBibAlbum'
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibYear: TLabel
            Tag = 4
            Left = 158
            Top = 70
            Width = 49
            Height = 13
            Caption = 'LblBibYear'
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibTrack: TLabel
            Tag = 3
            Left = 158
            Top = 53
            Width = 53
            Height = 13
            Caption = 'LblBibTrack'
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibGenre: TLabel
            Tag = 5
            Left = 158
            Top = 87
            Width = 56
            Height = 13
            Caption = 'LblBibGenre'
            ShowAccelChar = False
            OnClick = LblBibArtistClick
          end
          object LblBibDuration: TLabel
            Left = 158
            Top = 104
            Width = 68
            Height = 13
            Caption = 'LblBibDuration'
            ShowAccelChar = False
          end
          object LblBibQuality: TLabel
            Left = 158
            Top = 121
            Width = 61
            Height = 13
            Caption = 'LblBibQuality'
            ShowAccelChar = False
          end
          object ImgBibRating: TImage
            Left = 158
            Top = 140
            Width = 70
            Height = 14
            OnMouseDown = ImgBibRatingMouseDown
            OnMouseLeave = ImgBibRatingMouseLeave
            OnMouseMove = ImgBibRatingMouseMove
          end
          object LblBibTags: TLabel
            Left = 157
            Top = 177
            Width = 50
            Height = 59
            AutoSize = False
            Caption = 'LblBibTags'
            ShowAccelChar = False
            WordWrap = True
          end
          object LblBibPlayCounter: TLabel
            Left = 157
            Top = 160
            Width = 86
            Height = 13
            Caption = 'LblBibPlayCounter'
            ShowAccelChar = False
          end
          object EdtBibArtist: TEdit
            Left = 244
            Top = 2
            Width = 121
            Height = 21
            TabOrder = 0
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object EdtBibAlbum: TEdit
            Tag = 2
            Left = 244
            Top = 53
            Width = 121
            Height = 21
            TabOrder = 1
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object EdtBibTitle: TEdit
            Tag = 1
            Left = 244
            Top = 29
            Width = 121
            Height = 21
            TabOrder = 2
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object EdtBibYear: TEdit
            Tag = 4
            Left = 244
            Top = 107
            Width = 121
            Height = 21
            NumbersOnly = True
            TabOrder = 3
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object EdtBibTrack: TEdit
            Tag = 3
            Left = 244
            Top = 80
            Width = 121
            Height = 21
            NumbersOnly = True
            TabOrder = 4
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object EdtBibGenre: TComboBox
            Tag = 5
            Left = 244
            Top = 134
            Width = 150
            Height = 21
            ItemHeight = 13
            Sorted = True
            TabOrder = 5
            Visible = False
            OnExit = EdtBibArtistExit
            OnKeyPress = EdtBibArtistKeyPress
          end
          object Button1: TButton
            Left = 3
            Top = 2
            Width = 75
            Height = 25
            Caption = 'Get Tags'
            TabOrder = 6
            Visible = False
            OnClick = Button1Click
          end
        end
      end
    end
    object MedienBibHeaderPanel: TNempPanel
      Tag = 3
      Left = 0
      Top = 0
      Width = 845
      Height = 28
      Align = alTop
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnPaint = PanelPaint
      OwnerDraw = False
      DesignSize = (
        845
        28)
      object EDITFastSearch: TEdit
        Left = 32
        Top = 3
        Width = 194
        Height = 21
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnEnter = EDITFastSearchEnter
        OnExit = EDITFastSearchExit
        OnKeyPress = EDITFastSearchKeyPress
      end
      object MedienlisteFillPanel: TNempPanel
        Tag = 3
        Left = 232
        Top = 2
        Width = 605
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        OnPaint = TABPanelPaint
        OwnerDraw = False
        DesignSize = (
          605
          23)
        object MedienListeStatusLBL: TLabel
          Left = 8
          Top = 5
          Width = 591
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          ShowAccelChar = False
          Transparent = False
        end
      end
      object TabBtn_Medialib: TSkinButton
        Left = 4
        Top = 2
        Width = 24
        Height = 24
        Hint = 'Show context menu'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
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
      object CB_MedienBibGlobalQuickSearch: TSkinButton
        Left = 206
        Top = 6
        Width = 16
        Height = 16
        Hint = 
          'Search in whole library (checked) or just in the current list (u' +
          'nchecked)'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Spacing = 2
        TabOrder = 1
        TabStop = False
        OnClick = CB_MedienBibGlobalQuickSearchClick
        DrawMode = dm_Skin
        NumGlyphsX = 1
        NumGlyphsY = 1
        GlyphLine = 0
        CustomRegion = False
        FocusDrawMode = fdm_Windows
        Color1 = clWhite
        Color2 = clWhite
      end
    end
  end
  object BassTimer: TTimer
    Enabled = False
    Interval = 20
    OnTimer = BassTimerTimer
    Left = 560
    Top = 56
  end
  object Nemp_MainMenu: TMainMenu
    AutoHotkeys = maManual
    Images = MenuImages
    Left = 32
    Top = 376
    object MM_Medialibrary: TMenuItem
      Caption = '&Medialibrary'
      object MM_ML_SearchDirectory: TMenuItem
        Caption = '&Search directory for new files'
        ImageIndex = 3
        ShortCut = 16462
        OnClick = MM_ML_SearchDirectoryClick
      end
      object MM_ML_Webradio: TMenuItem
        Caption = 'Manage webradio stations'
        ShortCut = 16471
        OnClick = MM_PL_WebStreamClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object MM_ML_SortBy: TMenuItem
        Caption = 'So&rt by'
        ImageIndex = 11
        object MM_ML_SortByArtistTitle: TMenuItem
          Caption = '&Artist, Title'
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByArtistAlbumTitle: TMenuItem
          Tag = 117
          Caption = 'A&rtist, Album, Title'
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByTitleArtist: TMenuItem
          Tag = 1
          Caption = '&Title, Artist'
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByAlbumArtistTitle: TMenuItem
          Tag = 2
          Caption = 'A&lbum, Artist, Title'
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByAlumTitleArtist: TMenuItem
          Tag = 118
          Caption = 'Al&bum, Title, Artist'
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByAlbumTrack: TMenuItem
          Tag = 119
          Caption = 'Alb&um, Tracknr.'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object N10: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object MM_ML_SortByFilename: TMenuItem
          Tag = 12
          Caption = '&Filename'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByPath: TMenuItem
          Tag = 10
          Caption = '&Path && filename'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByLyrics: TMenuItem
          Tag = 15
          Caption = 'L&yrics exists'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByGenre: TMenuItem
          Tag = 14
          Caption = '&Genre'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object N11: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object MM_ML_SortByDuration: TMenuItem
          Tag = 3
          Caption = 'Du&ration'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object MM_ML_SortByFilesize: TMenuItem
          Tag = 9
          Caption = 'File&size'
          GroupIndex = 1
          OnClick = AnzeigeSortMENUClick
        end
        object N4: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object MM_ML_SortAscending: TMenuItem
          Caption = '&Ascending'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = MM_ML_SortAscendingClick
        end
        object MM_ML_SortDescending: TMenuItem
          Caption = 'D&escending'
          GroupIndex = 1
          RadioItem = True
          OnClick = MM_ML_SortDescendingClick
        end
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
        object N29: TMenuItem
          Caption = '-'
        end
        object MM_ML_BrowseByMore: TMenuItem
          Tag = 100
          Caption = 'More...'
          RadioItem = True
          OnClick = SortierAuswahl1POPUPClick
        end
      end
      object MM_ML_Search: TMenuItem
        Caption = 'Search'
        ShortCut = 16454
        OnClick = MM_ML_SearchClick
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object MM_ML_Delete: TMenuItem
        Caption = '&Delete'
        ImageIndex = 12
        OnClick = MM_ML_DeleteClick
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
      object N21: TMenuItem
        Caption = '-'
      end
      object MM_ML_DeleteMissingFiles: TMenuItem
        Caption = 'Delete &missing files'
        OnClick = DatenbankUpdateTBClick
      end
      object MM_ML_RefreshAll: TMenuItem
        Caption = '&Refresh all'
        ShortCut = 16500
        OnClick = MM_ML_RefreshAllClick
      end
      object MM_ML_ResetRatings: TMenuItem
        Caption = 'Reset Ratings'
        OnClick = MM_ML_ResetRatingsClick
      end
    end
    object MM_Playlist: TMenuItem
      Caption = '&Playlist'
      object MM_PL_Add: TMenuItem
        Caption = '&Add'
        ImageIndex = 13
        object MM_PL_Files: TMenuItem
          Caption = '&Files'
          OnClick = MM_PL_FilesClick
        end
        object MM_PL_Directory: TMenuItem
          Caption = '&Directory'
          OnClick = MM_PL_DirectoryClick
        end
        object MM_PL_WebStream: TMenuItem
          Caption = '&Webradio'
          ShortCut = 16457
          OnClick = MM_PL_WebStreamClick
        end
      end
      object MM_PL_Delete: TMenuItem
        Caption = '&Delete'
        ImageIndex = 14
        object MM_PL_DeleteAll: TMenuItem
          Caption = '&All'
          OnClick = PM_PL_DeleteAllClick
        end
        object MM_PL_DeleteSelected: TMenuItem
          Caption = '&Selected'
          OnClick = PM_PL_DeleteSelectedClick
        end
        object MM_PL_DeleteMissingFiles: TMenuItem
          Caption = '&Missing files'
          OnClick = Nichtvorhandenelschen1Click
        end
      end
      object MM_PL_RecentPlaylists: TMenuItem
        Caption = '&Recent playlists'
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
      object N18: TMenuItem
        Caption = '-'
      end
      object MM_PL_GenerateRandomPlaylist: TMenuItem
        Caption = '&Generate random playlist'
        OnClick = MitzuflligenEintrgenausderMedienbibliothekfllen1Click
      end
      object MM_PL_Load: TMenuItem
        Caption = '&Load playlist'
        ImageIndex = 0
        ShortCut = 16463
        OnClick = PM_PL_LoadPlaylistClick
      end
      object MM_PL_Save: TMenuItem
        Caption = '&Save playlist'
        ImageIndex = 1
        ShortCut = 16467
        OnClick = PM_PL_SavePlaylistClick
      end
      object MM_PL_AddPlaylist: TMenuItem
        Caption = 'A&dd  playlist'
        OnClick = MM_PL_AddPlaylistClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MM_PL_PlaySelectedNext: TMenuItem
        Caption = '&Play selected title next'
        OnClick = PM_PL_AddToPrebookListEndClick
      end
      object MM_PL_PlayInHeadset: TMenuItem
        Caption = 'Play in &headset'
        ImageIndex = 7
        ShortCut = 16456
        OnClick = PM_PL_PlayInHeadsetClick
      end
      object MM_PL_StopHeadset: TMenuItem
        Caption = 'S&top headset'
        ShortCut = 49224
        OnClick = PM_PL_StopHeadsetClick
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object MM_PL_Extended: TMenuItem
        Caption = 'E&xtended'
        object MM_PL_ExtendedAddToMedialibrary: TMenuItem
          Caption = '&Add to medialibrary'
          OnClick = PM_PL_ExtendedAddToMedialibraryClick
        end
        object MM_PL_ExtendedCopyFromWinamp: TMenuItem
          Caption = 'Copy playlist from &Winamp'
          OnClick = PM_PL_ExtendedCopyFromWinampClick
        end
        object MM_PL_ExtendedScanFiles: TMenuItem
          Caption = '&Scan files'
          OnClick = PM_PL_ExtendedScanFilesClick
        end
        object MM_PL_ExtendedCopyToClipboard: TMenuItem
          Caption = '&Copy to clipboard'
          OnClick = PM_ML_CopyToClipboardClick
        end
        object MM_PL_ExtendedPasteFromClipboard: TMenuItem
          Caption = '&Paste from clipboard'
          OnClick = PM_ML_PasteFromClipboardClick
        end
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object MM_PL_Properties: TMenuItem
        Caption = 'Properties'
        ShortCut = 16452
        OnClick = PM_PL_PropertiesClick
      end
    end
    object MM_Options: TMenuItem
      Caption = '&Options'
      object MM_O_Preferences: TMenuItem
        Caption = '&Preferences'
        ImageIndex = 5
        OnClick = MM_O_PreferencesClick
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
          Caption = 'Show &effects/equalizer/...'
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
          Caption = 'Show &medialist'
          Checked = True
          ShortCut = 8306
          OnClick = PM_P_ViewSeparateWindows_MedialistClick
        end
        object MM_O_ViewSeparateWindows_Browse: TMenuItem
          Caption = 'Show &browselists'
          Checked = True
          ShortCut = 8307
          OnClick = PM_P_ViewSeparateWindows_BrowseClick
        end
        object MM_O_ViewStayOnTop: TMenuItem
          Caption = 'Stay on &top'
          ShortCut = 16468
          OnClick = PM_P_ViewStayOnTopClick
        end
        object N32: TMenuItem
          Caption = '-'
        end
        object MM_O_PartyMode: TMenuItem
          Caption = 'Party-Mode'
          OnClick = PM_P_PartyModeClick
        end
      end
      object MM_O_Skins: TMenuItem
        Caption = '&Skins'
        ImageIndex = 8
        object MM_O_Skins_OpenEditor: TMenuItem
          Caption = '&Open skin editor'
          OnClick = SkinEditorstarten1Click
        end
        object MM_O_Skins_WindowsStandard: TMenuItem
          Caption = 'Windows standard'
          OnClick = WindowsStandardClick
        end
        object N38: TMenuItem
          Caption = '-'
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
    end
    object MM_Tools: TMenuItem
      Caption = '&Tools'
      OnClick = Player_PopupMenuPopup
      object MM_T_Shutdown: TMenuItem
        Caption = '&Shutdown'
        ImageIndex = 16
        object MM_T_ShutdownOff: TMenuItem
          Caption = '&Disable'
          Checked = True
          RadioItem = True
          OnClick = Schlafmodusdeaktivieren1Click
        end
        object N56: TMenuItem
          Caption = '-'
        end
        object MM_T_ShutDownModeStop: TMenuItem
          Caption = 'Sto&p Nemp'
          RadioItem = True
          object MM_T_Shutdown_5Minutes0: TMenuItem
            Caption = '5 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_15Minutes0: TMenuItem
            Tag = 1
            Caption = '15 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_30Minutes0: TMenuItem
            Tag = 2
            Caption = '30 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_45minutes0: TMenuItem
            Tag = 3
            Caption = '45 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_60Minutes0: TMenuItem
            Tag = 4
            Caption = '1 hour'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_90Minutes0: TMenuItem
            Tag = 5
            Caption = '1.5 hours'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_120Minutes0: TMenuItem
            Tag = 6
            Caption = '2 hours'
            OnClick = StundenClick
          end
          object N44: TMenuItem
            Caption = '-'
          end
          object MM_T_ShutDown_Custom0: TMenuItem
            Tag = 7
            Caption = 'Custom'
            OnClick = StundenClick
          end
        end
        object MM_T_ShutdownModeCloseNemp: TMenuItem
          Caption = '&Close Nemp'
          RadioItem = True
          object MM_T_Shutdown_5Minutes1: TMenuItem
            Tag = 100
            Caption = '5 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_15Minutes1: TMenuItem
            Tag = 101
            Caption = '15 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_30Minutes1: TMenuItem
            Tag = 102
            Caption = '30 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_45minutes1: TMenuItem
            Tag = 103
            Caption = '45 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_60Minutes1: TMenuItem
            Tag = 104
            Caption = '1 hour'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_90Minutes1: TMenuItem
            Tag = 105
            Caption = '1.5 hours'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_120Minutes1: TMenuItem
            Tag = 106
            Caption = '2 hours'
            OnClick = StundenClick
          end
          object N60: TMenuItem
            Caption = '-'
          end
          object MM_T_ShutDown_Custom1: TMenuItem
            Tag = 107
            Caption = 'Custom'
            OnClick = StundenClick
          end
          object MM_T_ShutDown_EndofPlaylist1: TMenuItem
            Tag = 100
            Caption = 'After the last file'
            OnClick = ShutDown_EndofPlaylistClick
          end
        end
        object MM_T_ShutdownModeSuspend: TMenuItem
          Tag = 1
          Caption = '&Suspend Windows'
          RadioItem = True
          object MM_T_Shutdown_5Minutes2: TMenuItem
            Tag = 200
            Caption = '5 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_15Minutes2: TMenuItem
            Tag = 201
            Caption = '15 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_30Minutes2: TMenuItem
            Tag = 202
            Caption = '30 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_45minutes2: TMenuItem
            Tag = 203
            Caption = '45 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_60Minutes2: TMenuItem
            Tag = 204
            Caption = '1 hour'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_90Minutes2: TMenuItem
            Tag = 205
            Caption = '1.5 hours'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_120Minutes2: TMenuItem
            Tag = 206
            Caption = '2 hours'
            OnClick = StundenClick
          end
          object N46: TMenuItem
            Caption = '-'
          end
          object MM_T_ShutDown_Custom2: TMenuItem
            Tag = 207
            Caption = 'Custom'
            OnClick = StundenClick
          end
          object MM_T_ShutDown_EndofPlaylist2: TMenuItem
            Tag = 200
            Caption = 'After the last file'
            OnClick = ShutDown_EndofPlaylistClick
          end
        end
        object MM_T_ShutdownModeHibernate: TMenuItem
          Tag = 2
          Caption = '&Hibernate Windows'
          RadioItem = True
          object MM_T_Shutdown_5Minutes3: TMenuItem
            Tag = 300
            Caption = '5 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_15Minutes3: TMenuItem
            Tag = 301
            Caption = '15 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_30Minutes3: TMenuItem
            Tag = 302
            Caption = '30 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_45minutes3: TMenuItem
            Tag = 303
            Caption = '45 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_60Minutes3: TMenuItem
            Tag = 304
            Caption = '1 hour'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_90Minutes3: TMenuItem
            Tag = 305
            Caption = '1.5 hours'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_120Minutes3: TMenuItem
            Tag = 306
            Caption = '2 hours'
            OnClick = StundenClick
          end
          object N47: TMenuItem
            Caption = '-'
          end
          object MM_T_ShutDown_Custom3: TMenuItem
            Tag = 307
            Caption = 'Custom'
            OnClick = StundenClick
          end
          object MM_T_ShutDown_EndofPlaylist3: TMenuItem
            Tag = 300
            Caption = 'After the last file'
            OnClick = ShutDown_EndofPlaylistClick
          end
        end
        object MM_T_ShutdownModeShutDownWindows: TMenuItem
          Tag = 3
          Caption = '&Shutdown Windows'
          RadioItem = True
          object MM_T_Shutdown_5Minutes4: TMenuItem
            Tag = 400
            Caption = '5 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_15Minutes4: TMenuItem
            Tag = 401
            Caption = '15 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_30Minutes4: TMenuItem
            Tag = 402
            Caption = '30 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_45minutes4: TMenuItem
            Tag = 403
            Caption = '45 minutes'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_60Minutes4: TMenuItem
            Tag = 404
            Caption = '1 hour'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_90Minutes4: TMenuItem
            Tag = 405
            Caption = '1.5 hours'
            OnClick = StundenClick
          end
          object MM_T_Shutdown_120Minutes4: TMenuItem
            Tag = 406
            Caption = '2 hours'
            OnClick = StundenClick
          end
          object N49: TMenuItem
            Caption = '-'
          end
          object MM_T_ShutDown_Custom4: TMenuItem
            Tag = 407
            Caption = 'Custom'
            OnClick = StundenClick
          end
          object MM_T_ShutDown_EndofPlaylist4: TMenuItem
            Tag = 400
            Caption = 'After the last file'
            OnClick = ShutDown_EndofPlaylistClick
          end
        end
      end
      object MM_T_Birthday: TMenuItem
        Caption = '&Birthday mode'
        ImageIndex = 2
        object MM_T_BirthdayActivate: TMenuItem
          Caption = 'Activate'
          OnClick = MenuBirthdayStartClick
        end
        object MM_T_BirthdayDeactivate: TMenuItem
          Caption = 'Deactivate'
          OnClick = MenuBirthdayAusClick
        end
        object N24: TMenuItem
          Caption = '-'
        end
        object MM_T_BirthdayOptions: TMenuItem
          Caption = 'Options'
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
        object MM_T_WebServerDeactivate: TMenuItem
          Caption = 'Deactivate'
          OnClick = MM_T_WebServerDeactivateClick
        end
        object N64: TMenuItem
          Caption = '-'
        end
        object MM_T_WebServerOptions: TMenuItem
          Caption = 'Options'
          OnClick = MM_T_WebServerOptionsClick
        end
      end
      object MM_T_Scrobbler: TMenuItem
        Caption = 'Scro&bbler'
        ImageIndex = 18
        object MM_T_ScrobblerActivate: TMenuItem
          Caption = 'Activate'
          OnClick = PM_P_ScrobblerActivateClick
        end
        object MM_T_ScrobblerDeactivate: TMenuItem
          Caption = 'Deactivate'
          OnClick = PM_P_ScrobblerDeactivateClick
        end
        object N62: TMenuItem
          Caption = '-'
        end
        object MM_T_ScrobblerOptions: TMenuItem
          Caption = 'Options'
          OnClick = PM_P_ScrobblerOptionsClick
        end
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
    end
    object MM_Help: TMenuItem
      Caption = '&Help'
      object MM_H_About: TMenuItem
        Caption = '&About Nemp'
        ImageIndex = 6
        OnClick = MM_H_AboutClick
      end
      object MM_H_ShowReadme: TMenuItem
        Caption = '&Show readme'
        OnClick = MM_H_ShowReadmeClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object MM_H_Help: TMenuItem
        Caption = '&Help'
        ImageIndex = 4
        OnClick = ToolButton7Click
      end
      object MM_H_CheckForUpdates: TMenuItem
        Caption = 'Check for updates'
        ImageIndex = 17
        OnClick = MM_H_CheckForUpdatesClick
      end
    end
  end
  object MMKeyTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = MMKeyTimerTimer
    Left = 560
    Top = 248
  end
  object PlayListImageList: TImageList
    Height = 14
    Width = 14
    Left = 744
    Top = 208
    Bitmap = {
      494C01011100130068020E000E00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000038000000460000000100200000000000403D
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      4000000000000000000000000000000000000000000070707000070707000000
      0000000000000000000000000000000000002828280040404000000000000000
      0000000000000000000000000000707070000707070000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004E575B000066
      A300060A0D007274760000000000000000003A3A3A0064646400161616000000
      0000000000000000000000000000000000005B5B5B00A3A3A3000D0D0D007676
      760000000000000000003A3A3A00646464001616160000000000000000000000
      000000000000080B815F060A94EF070B9BF5070B9BF5070B9BF5070B9BF5070B
      9BF5070B9BF5070B9BF5070B9BF5060A94EF080B815F00000000000000009DB0
      C300303E4E002E3C4B002E3C4B002E3C4B002E3C4B002E3C4B002E3C4B002E3C
      4B002E3C4B00303E4E009DB0C300000000000000000000000000000000000F3D
      52000196F2000D3C5800303940000D0D0D00C4C4C400CACACA00343434000000
      0000000000000000000000000000000000000000000052525200F2F2F2005858
      5800404040000D0D0D00C4C4C400CACACA003434340000000000000000000000
      000000000000090E9DF00C13B2FF0D16BDFF0D15BDFF0D16BDFF0E17BEFF0E17
      BEFF0D16BDFF0C15BDFF0C15BDFF0B13B2FF090E9DF000000000000000003342
      5300324152003646580035455600364658003747590037475900364658003545
      5600354556003241520033425300000000000000000000000000000000000306
      070001B9FF0001A7FF000075BE00F2F2F200F2F2F20076767600767676000000
      0000000000000000000000000000000000000000000007070700F2F2F200F2F2
      F200BEBEBE00F2F2F200F2F2F200767676007676760000000000000000000000
      0000000000000B13B0F70E1AC3FF1E27C5FF2C35CAFF232CC7FF121DC2FF0D18
      C0FF242EC7FF323ACAFF2A33C9FF121DC4FF0B12B0F700000000000000003545
      5600394A5D00405469004960780043586E003A4C5F0037485A00455A70004C63
      7C00485E75003B4D600035455600000000000000000000000000000000003340
      43000191BB0001BAFF0001B5FF00F2F2F200F2F2F20034343400000000000000
      0000000000000000000000000000000000000000000043434300BBBBBB00F2F2
      F200F2F2F200F2F2F200F2F2F200343434000000000000000000000000000000
      000000000000070FB5F55E65CFFFE2E1EFFFBFC0E0FFD0D2E8FF4046CCFF8388
      D9FFD9DBEDFFB9BADDFFCDCFE8FFA0A3E2FF121AB5F500000000000000003646
      58006682A100DEE4EB00BBC8D500CED7E100536C8700889EB600D7DFE700B5C3
      D200CBD5DF00A2B4C6003B4D60000000000000000000000000006E7273000E24
      280002D8FF0002D8FF0002D8FF00F2F2F200F2F2F2006D6D6D00343434000000
      0000000000000000000000000000000000007373730028282800F2F2F200F2F2
      F200F2F2F200F2F2F200F2F2F2006D6D6D003434340000000000000000000000
      0000000000001F28BDF5D7D8EEFF8B90D7FF020DA3FF2F38B6FF6F74CFFFECED
      F6FF3C45B4FF00009CFF6469BDFFEFF0F5FF2C35BDF500000000000000004459
      6F00D5DDE5008FA3BA002B384600465C7300738DA900EBEFF3004C647D00242E
      3A006380A000ECF0F4004A61790000000000000000004B5658000F4A550002CF
      F50002E3FF0002E3FF0002DEFF00F2F2F200F2F2F200F2F2F200CACACA000707
      07007C7C7C0000000000000000005555550058585800F2F2F200F2F2F200F2F2
      F200F2F2F200F2F2F200F2F2F200F2F2F200CACACA00070707007C7C7C000000
      000000000000343DCAF5EDEDF2FF4652D3FF1021D3FF0315C4FFB3B7E3FFAFB3
      DFFF5F68CBFFCACDF3FFD5D7F0FF787FD4FF131EBCF50000000000000000526B
      8500E9EDF1005A7593004053680036465800B5C3D200B0BFCF006783A200CED7
      E100D5DDE5007F96B0003E516500000000001D292B000663730002A5C10002C9
      E50017D1E70023E7FF0010E5FF00F2F2F200F2F2F200E2E2E200B2B2B200B2B2
      B20043434300676767002525250073737300B2B2B200DCDCDC00E5E5E500F2F2
      F200F2F2F200F2F2F200F2F2F200E2E2E200B2B2B200B2B2B200434343006767
      6700000000002531CEF5DADCF1FF7C84E0FF0418D6FF3C4AD6FFE5E5F3FF7D86
      CFFFE4E6F2FF868DD6FF3642C1FF414ECDFF1A28CFF500000000000000004C63
      7C00DAE1E800879DB6003C4E620056708D00E3E8EE008299B300E3E8EE008BA0
      B8004E667F0056708D00475D7400000000003D4A4C003D4A4C002D3B3D000F17
      19000F181900095F6D0002D8FF00F2F2F2001F1F1F001C1C1C004C4C4C004C4C
      4C004C4C4C005E5E5E004C4C4C004C4C4C004C4C4C0022222200191919006D6D
      6D00F2F2F200F2F2F2001F1F1F001C1C1C004C4C4C004C4C4C004C4C4C005E5E
      5E00000000001020D4F5737FE0FFEAEBF5FFA1A7F2FFD2D6F6FFADB4E7FF2639
      C8FFBDC2EBFFB9BDF0FFC5CAF3FFB8BDEDFF1D2CD6F500000000000000004459
      6F008299B300E9EDF100ACBCCC00D6DEE600B2C1D0004A617900C1CDD900BFCB
      D800CBD5DF00BECAD7004B627A00000000000000000000000000000000000000
      0000000000000914160002D8FF007C7C7C006464640000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001616
      1600F2F2F2007C7C7C0064646400000000000000000000000000000000000000
      0000000000001D2EE4F52238D2FF4B59BCFF6C77C2FF5E6BC9FF273ACAFF1C31
      D5FF3141BBFF6570BDFF6570C2FF384BD4FF1B2CE2F500000000000000004F67
      80004C637C0059739100708AA7006884A3004B627A00495F77004C637C006884
      A3006A85A30056708D004D657E00000000000000000000000000000000000000
      00000000000033414300019DBB003D3D3D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004343
      4300BBBBBB003D3D3D0000000000000000000000000000000000000000000000
      0000000000002436EAF82942EAFF1831DEFF1831DCFF1931DEFF2039E5FF253D
      EAFF1D36E1FF1830DCFF1730DEFF253EE8FF2436EAF80000000000000000536D
      8800566F8C004A617900496078004A61790050698300536D88004D657E004960
      780049607800536D8800536D8800000000000000000000000000000000000000
      0000000000009D9D9D000C5361001C1C1C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000616161001C1C1C0000000000000000000000000000000000000000000000
      0000000000002A3EEFEC4A5EF6FF4D62F6FF4C62F7FF4C62F6FF4C62F6FF4C62
      F6FF4C62F6FF4C62F7FF4D62F6FF4A5EF6FF2A3EEFEC00000000000000005D79
      98006C87A500708AA700708AA700708AA700708AA700708AA700708AA700708A
      A700708AA7006C87A5005D799800000000000000000000000000000000000000
      0000000000000000000001010100656B6D000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000010101006D6D6D0000000000000000000000000000000000000000000000
      000000000000263EDF573249F6EA3B50FAF53A50FAF53A50FAF53A50FAF53A50
      FAF53A50FAF53A50FAF53B50FAF53249F6EA263EDF570000000000000000BFCB
      D8006682A1006783A2006783A2006783A2006783A2006783A2006783A2006783
      A2006783A2006682A100BFCBD800000000000000000000000000000000000000
      0000000000000000000076797900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000797979000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001A232800303A40000000000000000000000000000000000000000000696D
      7000030507000000000000000000000000000000000000000000000000000000
      0000000000008484840042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484004242420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484004242
      4200000000000000000000000000000000000000000000000000000000000000
      00004E575B000066A300060A0D007274760000000000000000002A323A000B37
      6400091016000000000000000000000000000000000000000000000000000000
      000000000000C6C6C60084848400424242000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C6008484840042424200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6008484
      8400424242000000000000000000000000000000000000000000000000000000
      0000000000000F3D52000196F2000D3C580030394000060A0D000063C4000066
      CA00252C34000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000306070001B9FF0001A7FF000075BE000087FF000081FF00043E
      7600727476000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000334043000191BB0001BAFF0001B5FF00019DFF000081FF000F22
      3400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006E7273000E24280002D8FF0002D8FF0002D8FF0001B3FF000094FF00083B
      6D00252C34000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004B56
      58000F4A550002CFF50002E3FF0002E3FF0002DEFF0001CBFF00019FFF00008C
      FF000066CA00030507007B7B7C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001D292B000663
      730002A5C10002C9E50017D1E70023E7FF0010E5FF0002CFFF0001B1FF00018C
      E2000066B200005CB200102A43005D6267000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001010
      100000000000000000000000000000000000804000004080800000808000C0C0
      C000000000000000000000000000000000000000000000000000101010000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010101000000000003D4A4C003D4A
      4C002D3B3D000F1719000F181900095F6D0002D8FF0001C6FF000C1A1F001118
      1C003D464C003D464C003D464C0052595E000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000080808000000
      000000000000000000000000000000000000C0C0C00040808000804000008040
      0000008080000000000000000000000000000000000008080800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000080808000000000000000000000000000000
      00000000000000000000000000000914160002D8FF00025E7C005A6164000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800040808000408080008040
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000033414300019DBB0010323D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000008080800000000000000
      00000000000000000000FFFFFF0000000000FF000000C0C0C000FF000000C0C0
      C000000000000000000000000000000000000808080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008080800000000000000000000000000000000000000
      00000000000000000000000000009D9D9D000C53610011191C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000001010100656B6D00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007679790000000000000000000000
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
      2800000038000000460000000100010000000000300200000000000000000000
      000000000000000000000000FFFFFF00FFFC000000000000FFFC000000000000
      FFFC000000000000FFFC000000000000FFFC000000000000FFFC000000000000
      FFFC000000000000FFFC000000000000FFFC000000000000FFFC000000000000
      FFFC000000000000FFFC000000000000FFFC000000000000FFFC000000000000
      CF9F3E7000000000C31F0C7000000000E01F807000000000E01F807000000000
      E03F80F000000000C01F00700000000080060010000000000000000000000000
      0000000000000000F87FE1F000000000F8FFE3F000000000F8FFF3F000000000
      FCFFF3F000000000FDFFF7F000000000F8FFF1FFC7F3E700F07FE0FF83F0C700
      F07FE0FF83F80700F87FF0FFC3F80700FF6FFEDFFB780F00DF77FEEF4BB00700
      FF779EEFFBA00100DF7706EF4B800000DF6F06DFFB400000EF5F02BF4AFE1F00
      F73F027FF9FE3F00B73C067F49FE3F00CF7F06FFFBFF3F00FF7F9EFF4BFF7F00
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
    Left = 760
    Top = 56
  end
  object DragFilesSrc1: TDragFilesSrc
    DropEffect = deCopy
    VerifyFiles = False
    OnDropping = DragFilesSrc1Dropping
    Left = 112
    Top = 432
  end
  object DragDropTimer: TTimer
    OnTimer = DragDropTimerTimer
    Left = 432
    Top = 672
  end
  object SleepTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = SleepTimerTimer
    Left = 560
    Top = 104
  end
  object BirthdayTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = BirthdayTimerTimer
    Left = 560
    Top = 152
  end
  object VolTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = VolTimerTimer
    Left = 560
    Top = 200
  end
  object ReallyClearPlaylistTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = ReallyClearPlaylistTimerTimer
    Left = 760
    Top = 104
  end
  object MenuImages: TImageList
    Left = 112
    Top = 376
    Bitmap = {
      494C010113001800540210001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E5D1B900DDB68900E1B27D00E1B27D00DDB68900E5D1B9000000
      0000000000000000000000000000000000003728190037281900372819003728
      1900372819003728190037281900372819003728190037281900372819003728
      1900372819003728190037281900372819000000000000000000000000000000
      0000000000000000000011111100222222002222220011111100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E2CD
      BC00D48A5200D3763B00DE875A00EF9B7400F19D7700E18B5F00D3773F00CF87
      4F00E2CDBB000000000000000000000000003728190037281900372819003728
      1900372819003728190037281900372819003728190037281900372819003728
      1900372819003728190037281900372819000000000000000000000000000000
      000033333300666699009999CC009999FF009999FF009999CC006666CC003333
      6600000011000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D7B7A100CB69
      2B009E3E10008B300B00A1431C00B3532B00B6552D00A6482100903510009A3A
      0E00C1612500D7B6A00000000000000000003728190037281900372819003728
      1900372819003728190037281900372819003728190037281900372819003728
      1900372819003728190037281900372819000000000000000000000011003333
      99009999FF009999FF009999FF009999FF009999FF009999FF009999FF009999
      FF00666699001111110000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E0CBBF00C2622900822C
      0700751A000080250100A7644900C99A8600CA9B8700A9664A0081260200771B
      00007F290500B4572200E0CABF00000000000808240037281900372819003728
      1900372819000808220037281900372819003728190037281900372819003728
      1900372819003728190037281900372819000000000000000000333399006666
      FF006666CC006666CC006666CC009966CC009966CC009966CC006666CC006666
      CC006666FF006633CC0000001100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C2754C007E320E005D13
      000081371D00DFC7BE00FFFFFF00FEFFFF00FEFEFF00FFFFFF00DFC8BF008337
      1D0061140000742B0900B66D46000000000007072200474B4B00A3B5B500A7B9
      B9006E727200080828003728190037281900AAB3B300C7DFDF00372819003728
      19003728190037281900372819003728190000000000333366006666FF006666
      CC009999FF00CCCCFF00CCCCFF009966CC006666CC006666CC009999FF00CCCC
      FF009999CC006666FF0033339900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDC4BC00A04C1F004A1300005D1D
      0900E0D1CB00FEFEFE00AB7C6A0080341B0081341A00AB7C6A00FDFEFE00E0D2
      CB005F1E09004A1200008B3F1700DCC3BB000A0A360037281900707373007E80
      80001A1846000D0E450037281900A2A4A400E8EFEF00EBF4F400372819003728
      190037281900151570003728190037281900000011003333CC006633CC00CCCC
      FF00CCCCFF009966CC009999FF00EEEEEE006666CC009999CC00CCCCFF009966
      CC00CCCCFF00CC99FF003333CC00000022000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6948200703213002D0200008766
      5700FFFFFF009F7666005A0800006A1A00006C1B00005F0A0000A4786500FFFF
      FF008A6757003002000059250C00C0907F000F0F52000F0F4900828282009090
      900013135E00121259006F6E7A00FFFFFF00FEFEFE00FFFFFF000D0D38001515
      70003728190015157000151570000E0E4B00000044003333CC009999FF009999
      FF003300CC003333CC003333CC006633CC006633CC00CCCCFF006633CC003300
      CC006633CC00CCCCFF003333CC00330066000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B97C670051220C0036060000B79D
      9200FFFFFF00914424008B320F0091361000923711009036110098482700FFFF
      FF00C4A395005E16010061260B00B17764001212610015157000909090009C9D
      9D0014145F00595A7800FDFDFD00FCFCFC00C0C1C100FDFEFE0013135A001414
      6C0015157100151570001716700016167600330066003333CC00CCCCFF006633
      CC003333CC003333CC006633CC003333CC009999CC00CCCCFF006633CC009966
      CC00CCCCFF009999FF003300CC00330099000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BB7D6900974319008B2D0600CFA2
      8F00FFFFFF00B2644300A1421900B1603E00B1613F00A2421900B3664500FFFF
      FF00D1A4910097350B00A6481B00B77A660014146600151570009A9B9B00A6A7
      A70041416900E9EDED00F1F5F500D2D4D40053536F00F4F9F900141564001616
      730017177800171775001717770018187C00330066006633CC00CCCCFF009999
      CC006666CC006666CC006666CC006666CC00CCCCFF009999FF00CCCCFF00CCCC
      FF009999FF006666CC006666CC003333CC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C28E8400C0623000A3451E00BF79
      5B00FFFFFF00DEB9A900B1512900EFDBD300EFDBD200B4573000E4C5B700FEFF
      FF00C0785A00A74A2300B75C2F00BE8C82001414630015157000A3A6A600ACAF
      AF00C5CACA00E2E9E900E2ECEC00454664004C4C6500E8F2F20012124E001816
      5700141358001515710029204D0013135D00330066006666FF00CC99FF00CCCC
      FF006666CC006666CC006666CC00CC99FF00CCCCFF009999FF00CCCCFF006666
      CC006666CC006666CC009966FF00333399000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D7BDBD00D3794A00C96F4800C86A
      4300EDC9BA00FFFFFF00FEA58100F7E4DD00F7E6DF00FEA58100FFFFFF00E9BE
      AB00CB6C4500CC724C00CB724600D6BCBC001515700015157000A9ADAD00B5BB
      BB00CAD4D400D6E4E4006B666600593C1A00846A4500DBEBEB00493118001515
      7100927868001515710092786800774C1A00000033006666CC009966CC00CCCC
      FF00EEEEEE00CCCCFF00CCCCFF00EEEEEE009999CC009999CC00EEEEEE00CCCC
      FF00CCCCFF009999CC009966FF00333399000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0785F00F39C7100E88B
      6400E9906A00F8C4AF00FEA58100FCEBE400FCECE500FEA58100F7BEA600EA8D
      6500EB8E6800F49C7200BB745D00000000001515700064441B00ABB0B000C1D0
      D000C3D3D3007A7A7F0092786800927868008A6B3E00D0E4E400927868009278
      680092786800151571009278680092786800000000006666CC009999FF009966
      CC009999FF00CCCCFF00CC99FF009999CC009999CC009999CC009999FF00CC99
      FF009999FF009999FF006666CC003333CC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D9C2C200E2906800FFB6
      9100FEA88500FDA27E00FEA68200FFEFE900FFEFE900FEA58100FDA48000FFAA
      8800FFB79300DD8A6600D8C2C2000000000015157000A7ABAB00C6DCDC00C9E0
      E000A0A6A600151570009278680092786800AEBFBF00C9E0E000A9BABA009278
      68009278680015157100927868009278680000000000330066009999FF009999
      FF009999FF009999FF009999FF009999FF009999FF009999FF009999FF009999
      FF009999FF009999FF006633CC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C9A7A400DF9B
      7900FFCEB200FFC8AF00FFC2A900FFCCB700FFCCB700FFC2A900FFC9B100FFCF
      B400DB977800C8A5A3000000000000000000151570009B8274009B8274009B82
      74009B827400151570009B8274009B8274009B8274009B8274009B8274009B82
      74009B8274009B8274009B8274009B8274000000000000000000333399009999
      FF00CC99FF009999FF009999FF009999FF009999FF009999FF009999FF009999
      FF00CC99FF006666CC003300CC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D7C0
      BF00C2877600ECB89E00FFD6C000FFDBC700FFDCC700FFD6C100EAB69E00BF85
      7500D7BFBF00000000000000000000000000A8918300A8918300A8918300A891
      8300A8918300A8918300A8918300A8918300A8918300A8918300A8918300A891
      8300A8918300A8918300A8918300A89183000000000000000000000000006633
      CC009999FF00CC99FF00CC99FF00CC99FF00CC99FF00CC99FF00CCCCFF009999
      FF006633CC003300CC0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6BDBD00C1969100BE8D8500BE8D8400C0969000D6BDBD000000
      000000000000000000000000000000000000A8918300A8918300A8918300A891
      8300A8918300A8918300A8918300A8918300A8918300A8918300A8918300A891
      8300A8918300A8918300A8918300A89183000000000000000000000000000000
      00003333CC006633CC006666CC009966CC009999CC009966CC006633CC003333
      CC00000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000DB9A7200D5835100D17D
      4B00DFA37F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6B9A100B6845A00AC734500AB714300B17E5300D2B49B000000
      000000000000000000000000000000000000E0A78300DFA48100EAC2AB00EAC0
      A800DC997100DFA4800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CAAA9B00A16A50008F583D008D573D0099685100C5A99B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E6D5
      C600BA885F00D7BBA300E9DACA00ECE0D100ECE0D100E8D8C800D3B59C00AF7A
      4D00E2CEBE00000000000000000000000000DB976F00EDC8B300E7B89B00E6B4
      9800EAC3AB00DE9C7300DFA58200000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DFC7
      BC00A3654700B2805700D5B79300DBC3A600DAC3A600D2B49000AB7A52009160
      4700D8C6BD000000000000000000000000000000000000000000B2B2B2009F9F
      9F00CBCBCB00CDCDCD00CDCDCD00CCCCCC00CCCCCC00CDCDCD00CFCFCF00CBCB
      CB009F9F9F00B4B4B40000000000000000000000000000000000E9D8CA00BD8C
      6200E7D5C400E5D2BF00C9A68500B88E6700B68A6500C5A18000E0CCBA00E3D0
      BE00AE764800E3CFBF000000000000000000DD9F7900EDCCB700E8BDA300E4B1
      9200E6B69A00EAC3AC00DE9C7400E1A886000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E2CBBC00A35C
      3B00CBA77D00D8BB9F00C39C7700B68A6200B4866000BE967200D1B39700C5A3
      770089563D00D8C6BD000000000000000000000000009D9D9D00797979001A1A
      1A00BDBDBD00D9D9D900D3D3D300D3D3D300D3D3D300D3D3D300DBDBDB00BABA
      BA001B1B1B007B7B7B009F9F9F00000000000000000000000000C99D7900EAD8
      C900E3CDBA00C0946B00BA8C6200CFB09400CFB09400B7895F00B2876100DAC0
      AA00E4D1C000B68358000000000000000000ECCBB500E6B39400EECCB800E9BE
      A500E5B39400E6B79B00EAC4AD00DE9E7800E1AA880000000000000000000000
      0000000000000000000000000000000000000000000000000000B3784900CFAA
      8100DABCA200BE916600BA8C6200B7895F00B3845E00B1835D00B0835C00CDAA
      8D00C6A57900956148000000000000000000949494006C6C6C00DADADA001818
      1800D9D9D900000000000000000000000000000000000000000000000000D5D5
      D50016161600DADADA006B6B6B009292920000000000E5CFBC00E4CCB900EAD6
      C500C7997100BF906600BF906600F7F1EC00F6F0EA00B7895F00B7895F00B589
      6300E2CEBB00D9BDA600D8BDA7000000000000000000ECCBB800E6B49800EECD
      BA00E9BFA500E5B49600E7B99D00EBC6AE00DE9F7900E3AC8B00000000000000
      00000000000000000000000000000000000000000000DBBC9B00BF915E00E0C2
      A800C5966C00C2916900E1CBB800FEFDFC00FFFFFE00EADCD000B4855E00B385
      5E00D4B59900AE7B5600C7A99B00000000009898980083838300DADADA002B2B
      2B00D6D6D600000000000000000000000000000000000000000000000000D0D0
      D00028282800DADADA00858585009797970000000000D9B39500EFE1D300D9B5
      9500C7986C00C3956900C1936700BF906600BF906600BB8B6300B98A6300B88A
      6200CBA78600EADCCC00C2946E00000000000000000000000000EDCCB900E6B7
      9900EECEBB00E9C0A700E8BDA300ECC8B300DFA48100DBA17F00000000000000
      00000000000000000000000000000000000000000000C5905100DBBC9C00D5AD
      8900C7986C00C3956900C1936700EDDFD300FAF7F400BB8B6300B98A6300B88A
      6200C59D7800D2B893009F695100000000009B9B9B0091919100DADADA003A3A
      3A00D6D6D600000000000000000000000000000000000000000000000000D1D1
      D10038383800DADADA00959595009999990000000000DAB29200F2E4D900D1A5
      7A00C5996B00C4976A00C4966900FAF6F200F3EAE100C2956D00BE8F6500BE8F
      6400C0956D00EFE3D500C190660000000000000000000000000000000000EDCD
      BA00E6B79C00EFCFBC00EECEBA00E2AE8C00D29B7B008B8B8B00EEEEEE000000
      00000000000000000000000000000000000000000000C1823C00E3C7AF00D0A2
      7600C5996B00C4976A00C4966900EEE0D400FBF7F400BF906600BE8F6500BE8F
      6400BE926900DFC6AA0095563B0000000000B8B8B800A4A4A400DADADA004343
      4300D5D5D500000000000000000000000000000000000000000000000000CFCF
      CF0044444400DADADA00A6A5A500B8B8B80000000000E1BB9C00F2E5DA00D1A6
      7E00CC9D7100C79A6C00C5986B00E2CCB600F8F3EE00F6EEE800D9BDA100C294
      6800C59B7100F0E2D600C7987100000000000000000000000000000000000000
      0000EDCDBB00E7B99C00E6B69800D8A98C00D2D2D200B5B5B500898989008888
      88008686860096969600C7C7C7000000000000000000C7894100E4C9B000D0A3
      7A00CC9D7100C79A6C00C5986B00FFFFFF00FFFFFE00C3966900C1946800C294
      6800C3986D00DFC5AB0098593B000000000000000000C4C4C400858585006B6B
      6B00E4E4E400000000000000000000000000000000000000000000000000E0E0
      E0006A6A6A0086868600C2C3C3000000000000000000E9C9AF00F3E5D900DFBB
      9E00CFA07500CD9E7200F5EBE300E4CBB400E7D3BF00FBF8F600E5D3BF00C498
      6B00D6B49100EEE0D200D3AB8B00000000000000000000000000000000000000
      000000000000EED0BC00E0B79E0093939300C7C7C700CCCCCC00C7C7C700C6C6
      C600C3C3C300C0C0C00088888800C8C8C80000000000D29D5B00E0BC9F00DBB3
      9300CFA07500CD9E7200CB9C7100DDBFA300DDBFA200C5996B00C5996B00C498
      6B00D1AB8500D8BA9700AB6D5100000000000000000000000000B0B0B0000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000ADADAD00000000000000000000000000F5E4D600F4E3D400EFDC
      CD00D5A87E00D0A07700FBF8F500FCF8F500FCF8F500FBF8F500D1A88100CFA4
      7B00EAD5C300EAD4C200E8D3C100000000000000000000000000000000000000
      0000000000000000000000000000E1E1E10093939300D4D4D400C8C8C800BCBC
      BC00BABABA00C2C2C200C4C4C4009898980000000000E6C8A400CD9C6800E7CB
      B400D4A57A00D0A07700CF9E7400FBF8F500FBF8F500CB9E7100CB9D7100CDA1
      7700DFC0A500B98A5B00D2AE9A00000000000000000000000000979797000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009898990000000000000000000000000000000000F0D2BA00F6E9
      DD00ECD8C600D7AC8100DCBB9A00F6ECE300F5ECE200E4C8AE00D2A77B00E6CE
      BA00F1E2D500DEBA9C0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000097979700DDDDDD00C5C5C500AAAA
      AA00A7A7A700ACACAC00D7D7D700888888000000000000000000D2995900D9B2
      8C00E6CAB300D6A97D00D1A57900E2C4A800E1C3A800D0A27600D1A47700DDBD
      A200D0AC8500B375490000000000000000000000000000000000949494004141
      4100DADADA00000000000000000000000000000000000000000000000000D7D7
      D7003D3D3D009D9D9D0000000000000000000000000000000000FBF1E800F2D3
      BB00F7EADF00EEDED000E3C1A700D8AE8900D7AC8600DDBB9C00EBD6C700F3E6
      D900E4C0A300F5E8DE0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000099999900E4E4E400CFCFCF00ACAC
      AC00000000008E8E8E008C8C8C008B8B8B000000000000000000F1DCC500D191
      4E00D9B28C00E6CDB800E0BA9D00D7AB8500D6A98200D9B39100E1C2AB00D4AE
      8600B4713D00E5D0BD0000000000000000000000000000000000000000008484
      84003B3B3B0066666600A6A6A600C2C2C200C2C2C200A5A5A500636363003B3B
      3B0087878700000000000000000000000000000000000000000000000000FCF2
      EA00F5DAC300F9E9DC00F6E8DD00F3E5DA00F3E5DA00F5E7DC00F5E4D600ECCD
      B400F7ECE3000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ABABAB00E2E2E200E7E7E700B9B9
      B90093939300000000000000000000000000000000000000000000000000F1DD
      C500D59B5A00D0A06A00E0BFA000E3C5AE00E3C5AE00DFBC9F00C8976200C389
      4800E9D5BD000000000000000000000000000000000000000000000000000000
      0000BFBFBF00656565004D4D4D0057575700575757004D4D4D0066666600C3C3
      C300000000000000000000000000000000000000000000000000000000000000
      000000000000FBECE100F8DDC800F6D8C100F4D6BF00F4D9C200F8E8DB000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D3D3D3009E9E9E00E4E4E400EEEE
      EE00969696000000000000000000000000000000000000000000000000000000
      000000000000E9CBA700D8A16500CF914D00CD904900D09B5A00E3C6A1000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000ADADAD008181810081818100AEAEAE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D4D4D400ABABAB009C9C
      9C009A9A9A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF00F81F0000FC3F0000E0070000F0070000
      C0030000C003000080010000C001000080010000800100000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000080010000800000008001000080010000C0030000C0010000
      E0070000E0030000F81F0000F00F00008001FFC1FFC1FFFF800180008000FFF9
      800180008000FFF3800180008000FFE7800180008000FFCF800180008000FF9F
      800180018001E03F800180018001C03F800180018001803F800180018001803F
      800180018001803F800180018001803F800180018001803F800180018001C07F
      800180018001E0FF8001FFFFFFFFFFFFF83FFFFFFFFFFFFFE03FFC3FFFF9C1F7
      C03FFC3FFFF3DDE3803FFC3FFFE7EFE30001FC3FFFCFF7C10000DC7BFF9FFBC1
      00009E79E03FDDF70000366CC03FC1F780002664803FFFF780012C34803FDDF7
      E0032C34803FDDF7F8032664803FC1F7FFE137EC803FEBF7FFF19FF9C07FEBF7
      FFF8DFFBE0FFF7F7FFFDFFFFFFFFF7F7FFFF87FFFFFFFFFFF81F03FFF81FFFFF
      E00701FFE007C003C00300FFC0038001C003007FC00307E08001803F800107E0
      8001C03F800107E08001E01F800107E08001F001800187E18001F8008001DFFB
      8001FE008001DFFBC003FF00C003C7E3C003FF08C003E007E007FF07E007F00F
      F81FFF07F81FFC3FFFFFFF87FFFFFFFFF1E3FFFFF00FFFFFE0618001C003FFF8
      C00080018001FFF0800080018001FF000000800180010001C000800180010003
      F000800180010003F000800180010003F000800180010003F000800180010003
      F000800180010003F0008001C0030003F0008001E0030003F0008001E3630007
      F8008001E3E301FFFF00FFFFF7F7FFFF00000000000000000000000000000000
      000000000000}
  end
  object VDTCoverTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = VDTCoverTimerTimer
    Left = 436
    Top = 617
  end
  object PlayListOpenDialog: TOpenDialog
    Filter = 
      'All supported files|*.m3u;*.m3u8;*.pls;*.npl;*.asx;*.wax|m3u-lis' +
      'ts|*.m3u|m3u8-lists (unicode-capable)|*.m3u8|pls-lists|*.pls|Nem' +
      'p playlists|*.npl|WindowsMedia|*.asx;*.wax'
    Left = 625
    Top = 9
  end
  object PlaylistDateienOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 656
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'gmp'
    Filter = 'Nemp medialibrary (*.gmp)|*.gmp'
    FilterIndex = 0
    Left = 24
    Top = 432
  end
  object PlayListSaveDialog: TSaveDialog
    DefaultExt = 'm3u8'
    Filter = 
      'm3u-list|*.m3u|m3u8-list (unicode-capable)|*.m3u8|pls-list|*.pls' +
      '|Nemp playlists|*.npl'
    FilterIndex = 2
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = PlayListSaveDialogTypeChange
    Left = 689
    Top = 9
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'gmp'
    Filter = 'Nemp medialibrary (*.gmp)|*.gmp'
    FilterIndex = 0
    Left = 56
    Top = 432
  end
  object Medialist_PopupMenu: TPopupMenu
    Images = MenuImages
    OnPopup = Medialist_PopupMenuPopup
    Left = 456
    Top = 568
    object PM_ML_Enqueue: TMenuItem
      Caption = 'Enqueue at the end of the playlist'
      OnClick = EnqueueTBClick
    end
    object PM_ML_Play: TMenuItem
      Caption = 'Play (and clear current playlist)'
      OnClick = PM_ML_PlayClick
    end
    object PM_ML_PlayNext: TMenuItem
      Caption = 'Enqueue (at the end of the prebook-list)'
      OnClick = PM_ML_PlayNextClick
    end
    object PM_ML_PlayNow: TMenuItem
      Caption = 'Just play focussed file (don'#39't change the playlist)'
      OnClick = PM_ML_PlayNowClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object PM_ML_PlayHeadset: TMenuItem
      Caption = 'Play in headset'
      ImageIndex = 7
      ShortCut = 16456
      OnClick = PM_ML_PlayHeadsetClick
    end
    object PM_ML_StopHeadset: TMenuItem
      Caption = 'Stop headset'
      ShortCut = 49224
      OnClick = PM_PL_StopHeadsetClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PM_ML_SortBy: TMenuItem
      Caption = 'Sort by'
      ImageIndex = 11
      object PM_ML_SortByArtistTitel: TMenuItem
        Caption = 'Artist, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByArtistAlbumTitle: TMenuItem
        Tag = 117
        Caption = 'Artist, Album, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByTitleArtist: TMenuItem
        Tag = 1
        Caption = 'Title, Artist'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByAlbumArtistTitle: TMenuItem
        Tag = 2
        Caption = 'Album, Artist, Title'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByAlbumTitleArtist: TMenuItem
        Tag = 118
        Caption = 'Album, Title, Artist'
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByAlbumTrack: TMenuItem
        Tag = 119
        Caption = 'Album, Tracknr.'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N7: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortByFilename: TMenuItem
        Tag = 12
        Caption = 'Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByPath: TMenuItem
        Tag = 10
        Caption = 'Path && Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByLyrics: TMenuItem
        Tag = 15
        Caption = 'Lyrics exists'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByGenre: TMenuItem
        Tag = 14
        Caption = 'Genre'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortByDuration: TMenuItem
        Tag = 3
        Caption = 'Duration'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortByFileSize: TMenuItem
        Tag = 9
        Caption = 'Filesize'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N90: TMenuItem
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
    object PM_ML_BrowseBy: TMenuItem
      Caption = 'Browse by'
      object PM_ML_BrowseByArtistAlbum: TMenuItem
        Caption = 'Artists - Albums'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByDirArtist: TMenuItem
        Tag = 1
        Caption = 'Directories - Artists'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByDirAlbum: TMenuItem
        Tag = 2
        Caption = 'Directories - Albums'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByGenreArtist: TMenuItem
        Tag = 3
        Caption = 'Genres - Artists'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByGenreYear: TMenuItem
        Tag = 4
        Caption = 'Genres - Years'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByAlbumArtists: TMenuItem
        Tag = 6
        Caption = 'Album - Artists'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_BrowseByYearArtist: TMenuItem
        Tag = 7
        Caption = 'Year - Artist'
        OnClick = SortierAuswahl1POPUPClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object PM_ML_BrowseByMore: TMenuItem
        Tag = 100
        Caption = 'More...'
        RadioItem = True
        OnClick = SortierAuswahl1POPUPClick
      end
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object PM_ML_Medialibrary: TMenuItem
      Caption = 'Medialibrary'
      object PM_ML_MedialibraryDeleteNotExisting: TMenuItem
        Caption = 'Delete missing files'
        OnClick = DatenbankUpdateTBClick
      end
      object PM_ML_MedialibraryRefresh: TMenuItem
        Caption = 'Refresh all'
        ShortCut = 16500
        OnClick = MM_ML_RefreshAllClick
      end
      object PM_ML_ResetRatings: TMenuItem
        Caption = 'Reset Ratings'
        OnClick = MM_ML_ResetRatingsClick
      end
      object PM_ML_MedialibrarySave: TMenuItem
        Caption = 'Save'
        OnClick = MM_ML_SaveClick
      end
      object PM_ML_MedialibraryLoad: TMenuItem
        Caption = 'Load'
        OnClick = MM_ML_LoadClick
      end
      object PM_ML_MedialibraryExport: TMenuItem
        Caption = 'Export as csv'
        ShortCut = 16453
        OnClick = PM_ML_MedialibraryExportClick
      end
      object PM_ML_MedialibraryDelete: TMenuItem
        Caption = 'Delete'
        OnClick = MM_ML_DeleteClick
      end
    end
    object PM_ML_SearchDirectory: TMenuItem
      Caption = 'Search directory for new files'
      ImageIndex = 3
      ShortCut = 16462
      OnClick = MM_ML_SearchDirectoryClick
    end
    object PM_ML_Webradio: TMenuItem
      Caption = 'Manage webradio stations'
      ShortCut = 16471
      OnClick = MM_PL_WebStreamClick
    end
    object PM_ML_RefreshSelected: TMenuItem
      Caption = 'Refresh selected'
      ShortCut = 116
      OnClick = PM_ML_RefreshSelectedClick
    end
    object PM_ML_HideSelected: TMenuItem
      Caption = 'Hide selected'
      ShortCut = 46
      OnClick = PM_ML_HideSelectedClick
    end
    object PM_ML_DeleteSelected: TMenuItem
      Caption = 'Delete selected'
      ShortCut = 16430
      OnClick = PM_ML_DeleteSelectedClick
    end
    object PM_ML_GetLyrics: TMenuItem
      Caption = 'Get lyrics'
      ShortCut = 16460
      OnClick = PM_ML_GetLyricsClick
    end
    object PM_ML_GetTags: TMenuItem
      Caption = 'Get Tags'
      ShortCut = 16468
      OnClick = PM_ML_GetTagsClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object PM_ML_ShowInExplorer: TMenuItem
      Caption = 'Show in explorer'
      OnClick = PM_ML_ShowInExplorerClick
    end
    object PM_ML_CopyToClipboard: TMenuItem
      Caption = 'Copy to clipboard'
      ShortCut = 16451
      OnClick = PM_ML_CopyToClipboardClick
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
    end
    object N55: TMenuItem
      Caption = '-'
    end
    object PM_ML_Properties: TMenuItem
      Caption = 'Properties'
      ShortCut = 16452
      OnClick = PM_ML_PropertiesClick
    end
  end
  object PlayListPOPUP: TPopupMenu
    Images = MenuImages
    OnPopup = PlayListPOPUPPopup
    Left = 656
    Top = 208
    object PM_PL_Add: TMenuItem
      Caption = 'Add'
      ImageIndex = 13
      object PM_PL_AddFiles: TMenuItem
        Caption = 'Files'
        OnClick = MM_PL_FilesClick
      end
      object PM_PL_AddDirectories: TMenuItem
        Caption = 'Directory'
        OnClick = MM_PL_DirectoryClick
      end
      object PM_PL_AddWebstream: TMenuItem
        Caption = 'Webradio'
        ShortCut = 16457
        OnClick = MM_PL_WebStreamClick
      end
    end
    object PM_PL_Delete: TMenuItem
      Caption = 'Delete'
      ImageIndex = 14
      object PM_PL_DeleteAll: TMenuItem
        Caption = 'All'
        ShortCut = 16462
        OnClick = PM_PL_DeleteAllClick
      end
      object PM_PL_DeleteSelected: TMenuItem
        Caption = 'Selected'
        ShortCut = 46
        OnClick = PM_PL_DeleteSelectedClick
      end
      object PM_PL_DeleteMissingFiles: TMenuItem
        Caption = 'Missing files'
        OnClick = Nichtvorhandenelschen1Click
      end
    end
    object PM_PL_RecentPlaylists: TMenuItem
      Caption = 'Recent playlists'
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
    object N25: TMenuItem
      Caption = '-'
    end
    object PM_PL_GeneraterandomPlaylist: TMenuItem
      Caption = 'Generate random playlist'
      OnClick = MitzuflligenEintrgenausderMedienbibliothekfllen1Click
    end
    object PM_PL_LoadPlaylist: TMenuItem
      Caption = 'Load playlist'
      ImageIndex = 0
      ShortCut = 16463
      OnClick = PM_PL_LoadPlaylistClick
    end
    object PM_PL_SavePlaylist: TMenuItem
      Caption = 'Save playlist'
      ImageIndex = 1
      ShortCut = 16467
      OnClick = PM_PL_SavePlaylistClick
    end
    object PM_PL_AddPlaylist: TMenuItem
      Caption = 'Add playlist'
      OnClick = MM_PL_AddPlaylistClick
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object PM_PL_AddToPrebookListEnd: TMenuItem
      Caption = 'Add selection to prebook-list (end)'
      OnClick = PM_PL_AddToPrebookListEndClick
    end
    object PM_PL_AddToPrebookListBeginning: TMenuItem
      Caption = 'Add selection to prebook-list (beginning)'
      OnClick = PM_PL_AddToPrebookListBeginningClick
    end
    object PM_PL_RemoveFromPrebookList: TMenuItem
      Caption = 'Remove selection from prebook-list'
      OnClick = PM_PL_RemoveFromPrebookListClick
    end
    object PM_PL_PlayInHeadset: TMenuItem
      Caption = 'Play in headset'
      ImageIndex = 7
      ShortCut = 16456
      OnClick = PM_PL_PlayInHeadsetClick
    end
    object PM_PL_StopHeadset: TMenuItem
      Caption = 'Stop headset'
      ShortCut = 49224
      OnClick = PM_PL_StopHeadsetClick
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object PM_PL_Extended: TMenuItem
      Caption = 'Extended'
      object PM_PL_ExtendedAddToMedialibrary: TMenuItem
        Caption = 'Add to medialibrary'
        OnClick = PM_PL_ExtendedAddToMedialibraryClick
      end
      object PM_PL_ExtendedCopyFromWinamp: TMenuItem
        Caption = 'Copy playlist from Winamp'
        OnClick = PM_PL_ExtendedCopyFromWinampClick
      end
      object PM_PL_ExtendedScanFiles: TMenuItem
        Caption = 'Scan files'
        ShortCut = 116
        OnClick = PM_PL_ExtendedScanFilesClick
      end
      object PM_PL_ExtendedCopyToClipboard: TMenuItem
        Caption = 'Copy to clipboard'
        ShortCut = 16451
        OnClick = PM_ML_CopyToClipboardClick
      end
      object PM_PL_ExtendedPasteFromClipboard: TMenuItem
        Caption = 'Paste from clipboard'
        ShortCut = 16470
        OnClick = PM_ML_PasteFromClipboardClick
      end
    end
    object N48: TMenuItem
      Caption = '-'
    end
    object PM_PL_Properties: TMenuItem
      Caption = 'Properties'
      ShortCut = 16452
      OnClick = PM_PL_PropertiesClick
    end
  end
  object TNAMenu: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = TNAMenuPopup
    Left = 745
    Top = 568
    object PM_TNA_Play: TMenuItem
      Caption = 'Play'
      OnClick = PlayPauseBTNIMGClick
    end
    object PM_TNA_Pause: TMenuItem
      Caption = 'Pause'
      OnClick = PlayPauseBTNIMGClick
    end
    object PM_TNA_Stop: TMenuItem
      Caption = 'Stop'
      OnClick = StopBTNIMGClick
    end
    object PM_TNA_Next: TMenuItem
      Caption = 'Next track'
      OnClick = PlayNextBTNIMGClick
    end
    object PM_TNA_Previous: TMenuItem
      Caption = 'Previous track'
      OnClick = PlayPrevBTNIMGClick
    end
    object PM_TNA_Playlist: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Playlist'
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
  object Equalizer_PopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 652
    Top = 452
    object PM_EQ_Disabled: TMenuItem
      Caption = 'Disable equalizer'
      OnClick = PM_EQ_DisabledClick
    end
    object N27: TMenuItem
      Caption = '-'
    end
    object PM_EQ_Load: TMenuItem
      Caption = 'Load preset'
    end
    object PM_EQ_Save: TMenuItem
      Caption = 'Save current setting as'
    end
    object PM_EQ_Delete: TMenuItem
      Caption = 'Delete preset'
    end
    object N45: TMenuItem
      Caption = '-'
    end
    object PM_EQ_RestoreStandard: TMenuItem
      Caption = 'Restore default settings'
      OnClick = PM_EQ_RestoreStandardClick
    end
  end
  object Player_PopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = MenuImages
    OnPopup = Player_PopupMenuPopup
    Left = 552
    Top = 314
    object PM_P_Options: TMenuItem
      Caption = 'Preferences'
      ImageIndex = 5
      OnClick = MM_O_PreferencesClick
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
        Caption = 'Show effects/equalizer/...'
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
        Caption = 'Show medialist'
        Checked = True
        ShortCut = 8306
        OnClick = PM_P_ViewSeparateWindows_MedialistClick
      end
      object PM_P_ViewSeparateWindows_Browse: TMenuItem
        Caption = 'Show browselists'
        Checked = True
        ShortCut = 8307
        OnClick = PM_P_ViewSeparateWindows_BrowseClick
      end
      object PM_P_ViewStayOnTop: TMenuItem
        Caption = 'Stay on top'
        ShortCut = 16468
        OnClick = PM_P_ViewStayOnTopClick
      end
      object N35: TMenuItem
        Caption = '-'
      end
      object PM_P_PartyMode: TMenuItem
        Caption = 'Party-Mode'
        OnClick = PM_P_PartyModeClick
      end
    end
    object PM_P_Skins: TMenuItem
      Caption = 'Skins'
      ImageIndex = 8
      object PM_P_Skins_OpenEditor: TMenuItem
        Caption = 'Open skin editor'
        OnClick = SkinEditorstarten1Click
      end
      object PM_P_Skins_WindowsStandard: TMenuItem
        Caption = 'Windows standard'
        OnClick = WindowsStandardClick
      end
      object N30: TMenuItem
        Caption = '-'
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
    object N36: TMenuItem
      Caption = '-'
    end
    object PM_P_ShutDown: TMenuItem
      Caption = 'Shutdown'
      ImageIndex = 16
      object PM_P_ShutDownOff: TMenuItem
        Caption = 'Disable'
        Checked = True
        RadioItem = True
        OnClick = Schlafmodusdeaktivieren1Click
      end
      object N57: TMenuItem
        Caption = '-'
      end
      object PM_P_ShutDownModeStop: TMenuItem
        Caption = 'Stop Nemp'
        RadioItem = True
        object PM_P_ShutDown_5Minutes0: TMenuItem
          Caption = '5 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_15Minutes0: TMenuItem
          Tag = 1
          Caption = '15 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_30Minutes0: TMenuItem
          Tag = 2
          Caption = '30 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_45Minutes0: TMenuItem
          Tag = 3
          Caption = '45 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_60Minutes0: TMenuItem
          Tag = 4
          Caption = '1 hour'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_90Minutes0: TMenuItem
          Tag = 5
          Caption = '1.5 hours'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_120Minutes0: TMenuItem
          Tag = 6
          Caption = '2 hours'
          OnClick = StundenClick
        end
        object N39: TMenuItem
          Caption = '-'
        end
        object PM_P_ShutDown_Custom0: TMenuItem
          Tag = 7
          Caption = 'Custom'
          OnClick = StundenClick
        end
      end
      object PM_P_ShutDownModeCloseNemp: TMenuItem
        Caption = 'Close Nemp'
        RadioItem = True
        object PM_P_ShutDown_5Minutes1: TMenuItem
          Tag = 100
          Caption = '5 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_15Minutes1: TMenuItem
          Tag = 101
          Caption = '15 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_30Minutes1: TMenuItem
          Tag = 102
          Caption = '30 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_45Minutes1: TMenuItem
          Tag = 103
          Caption = '45 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_60Minutes1: TMenuItem
          Tag = 104
          Caption = '1 hour'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_90Minutes1: TMenuItem
          Tag = 105
          Caption = '1.5 hours'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_120Minutes1: TMenuItem
          Tag = 106
          Caption = '2 hours'
          OnClick = StundenClick
        end
        object N40: TMenuItem
          Caption = '-'
        end
        object PM_P_ShutDown_Custom1: TMenuItem
          Tag = 107
          Caption = 'Custom'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_EndofPlaylist1: TMenuItem
          Tag = 100
          Caption = 'After the last file'
          OnClick = ShutDown_EndofPlaylistClick
        end
      end
      object PM_P_ShutDownModeSuspend: TMenuItem
        Tag = 1
        Caption = 'Suspend Windows'
        RadioItem = True
        object PM_P_ShutDown_5Minutes2: TMenuItem
          Tag = 200
          Caption = '5 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_15Minutes2: TMenuItem
          Tag = 201
          Caption = '15 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_30Minutes2: TMenuItem
          Tag = 202
          Caption = '30 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_45Minutes2: TMenuItem
          Tag = 203
          Caption = '45 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_60Minutes2: TMenuItem
          Tag = 204
          Caption = '1 hour'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_90Minutes2: TMenuItem
          Tag = 205
          Caption = '1.5 hours'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_120Minutes2: TMenuItem
          Tag = 206
          Caption = '2 hours'
          OnClick = StundenClick
        end
        object N59: TMenuItem
          Caption = '-'
        end
        object PM_P_ShutDown_Custom2: TMenuItem
          Tag = 207
          Caption = 'Custom'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_EndofPlaylist2: TMenuItem
          Tag = 200
          Caption = 'After the last file'
          OnClick = ShutDown_EndofPlaylistClick
        end
      end
      object PM_P_ShutDownModeHibernate: TMenuItem
        Tag = 2
        Caption = 'Hibernate Windows'
        RadioItem = True
        object PM_P_ShutDown_5Minutes3: TMenuItem
          Tag = 300
          Caption = '5 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_15Minutes3: TMenuItem
          Tag = 301
          Caption = '15 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_30Minutes3: TMenuItem
          Tag = 302
          Caption = '30 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_45Minutes3: TMenuItem
          Tag = 303
          Caption = '45 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_60Minutes3: TMenuItem
          Tag = 304
          Caption = '1 hour'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_90Minutes3: TMenuItem
          Tag = 305
          Caption = '1.5 hours'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_120Minutes3: TMenuItem
          Tag = 306
          Caption = '2 hours'
          OnClick = StundenClick
        end
        object N42: TMenuItem
          Caption = '-'
        end
        object PM_P_ShutDown_Custom3: TMenuItem
          Tag = 307
          Caption = 'Custom'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_EndofPlaylist3: TMenuItem
          Tag = 300
          Caption = 'After the last file'
          OnClick = ShutDown_EndofPlaylistClick
        end
      end
      object PM_P_ShutDownModeShutDownWindows: TMenuItem
        Tag = 3
        Caption = 'Shutdown Windows'
        RadioItem = True
        object PM_P_ShutDown_5Minutes4: TMenuItem
          Tag = 400
          Caption = '5 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_15Minutes4: TMenuItem
          Tag = 401
          Caption = '15 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_30Minutes4: TMenuItem
          Tag = 402
          Caption = '30 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_45Minutes4: TMenuItem
          Tag = 403
          Caption = '45 minutes'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_60Minutes4: TMenuItem
          Tag = 404
          Caption = '1 hour'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_90Minutes4: TMenuItem
          Tag = 405
          Caption = '1.5 hours'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_120Minutes4: TMenuItem
          Tag = 406
          Caption = '2 hours'
          OnClick = StundenClick
        end
        object N43: TMenuItem
          Caption = '-'
        end
        object PM_P_ShutDown_Custom4: TMenuItem
          Tag = 407
          Caption = 'Custom'
          OnClick = StundenClick
        end
        object PM_P_ShutDown_EndofPlaylist4: TMenuItem
          Tag = 400
          Caption = 'After the last file'
          OnClick = ShutDown_EndofPlaylistClick
        end
      end
    end
    object PM_P_Birthday: TMenuItem
      Caption = 'Birthday mode'
      ImageIndex = 2
      object PM_P_BirthdayActivate: TMenuItem
        Caption = 'Activate'
        OnClick = MenuBirthdayStartClick
      end
      object PM_P_BirthdayDeactivate: TMenuItem
        Caption = 'Deactivate'
        OnClick = MenuBirthdayAusClick
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object PM_P_BirthdayOptions: TMenuItem
        Caption = 'Options'
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
      object PM_P_WebServerDeactivate: TMenuItem
        Caption = 'Deactivate'
        OnClick = MM_T_WebServerDeactivateClick
      end
      object N65: TMenuItem
        Caption = '-'
      end
      object PM_P_WebServerOptions: TMenuItem
        Caption = 'Options'
        OnClick = MM_T_WebServerOptionsClick
      end
    end
    object PM_P_Scrobbler: TMenuItem
      Caption = 'Scrobbler'
      ImageIndex = 18
      object PM_P_ScrobblerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = PM_P_ScrobblerActivateClick
      end
      object PM_P_ScrobblerDectivate: TMenuItem
        Caption = 'Deactivate'
        OnClick = PM_P_ScrobblerDeactivateClick
      end
      object N61: TMenuItem
        Caption = '-'
      end
      object PM_P_ScrobblerOptions: TMenuItem
        Caption = 'Options'
        OnClick = PM_P_ScrobblerOptionsClick
      end
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
    object N17: TMenuItem
      Caption = '-'
    end
    object PM_P_About: TMenuItem
      Caption = 'About Nemp'
      ImageIndex = 6
      OnClick = MM_H_AboutClick
    end
    object PM_P_ShowReadme: TMenuItem
      Caption = 'Show readme'
      OnClick = MM_H_ShowReadmeClick
    end
    object PM_P_Help: TMenuItem
      Caption = 'Help'
      ImageIndex = 4
      OnClick = ToolButton7Click
    end
    object PM_P_CheckForUpdates: TMenuItem
      Caption = 'Check for updates'
      ImageIndex = 17
      OnClick = MM_H_CheckForUpdatesClick
    end
    object N28: TMenuItem
      Caption = '-'
    end
    object PM_P_Minimize: TMenuItem
      Caption = 'Minimize'
      OnClick = PM_P_MinimizeClick
    end
    object PM_P_Close: TMenuItem
      Caption = 'Close'
      OnClick = PM_P_CloseClick
    end
  end
  object SleepPopup: TPopupMenu
    OnPopup = Player_PopupMenuPopup
    Left = 749
    Top = 309
    object _Shutdown: TMenuItem
      Caption = 'Shutdown'
      Enabled = False
    end
    object PM_S_ShutDownOff: TMenuItem
      Caption = 'Disable'
      Checked = True
      RadioItem = True
      OnClick = Schlafmodusdeaktivieren1Click
    end
    object N37: TMenuItem
      Caption = '-'
    end
    object PM_S_ShutDownModeStop: TMenuItem
      Caption = 'Stop Nemp'
      RadioItem = True
      object PM_S_ShutDown_5Minutes0: TMenuItem
        Caption = '5 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_15Minutes0: TMenuItem
        Tag = 1
        Caption = '15 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_30Minutes0: TMenuItem
        Tag = 2
        Caption = '30 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_45Minutes0: TMenuItem
        Tag = 3
        Caption = '45 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_60Minutes0: TMenuItem
        Tag = 4
        Caption = '1 hour'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_90Minutes0: TMenuItem
        Tag = 5
        Caption = '1.5 hours'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_120Minutes0: TMenuItem
        Tag = 6
        Caption = '2 hours'
        OnClick = StundenClick
      end
      object N50: TMenuItem
        Caption = '-'
      end
      object PM_S_ShutDown_Custom0: TMenuItem
        Tag = 7
        Caption = 'Custom'
        OnClick = StundenClick
      end
    end
    object PM_S_ShutDownModeCloseNemp: TMenuItem
      Caption = 'Close Nemp'
      RadioItem = True
      object PM_S_ShutDown_5Minutes1: TMenuItem
        Tag = 100
        Caption = '5 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_15Minutes1: TMenuItem
        Tag = 101
        Caption = '15 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_30Minutes1: TMenuItem
        Tag = 102
        Caption = '30 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_45Minutes1: TMenuItem
        Tag = 103
        Caption = '45 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_60Minutes1: TMenuItem
        Tag = 104
        Caption = '1 hour'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_90Minutes1: TMenuItem
        Tag = 105
        Caption = '1.5 hours'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_120Minutes1: TMenuItem
        Tag = 106
        Caption = '2 hours'
        OnClick = StundenClick
      end
      object N51: TMenuItem
        Caption = '-'
      end
      object PM_S_ShutDown_Custom1: TMenuItem
        Tag = 107
        Caption = 'Custom'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_EndofPlaylist1: TMenuItem
        Tag = 100
        Caption = 'After the last file'
        OnClick = ShutDown_EndofPlaylistClick
      end
    end
    object PM_S_ShutDownModeSuspend: TMenuItem
      Tag = 1
      Caption = 'Suspend Windows'
      RadioItem = True
      object PM_S_ShutDown_5Minutes2: TMenuItem
        Tag = 200
        Caption = '5 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_15Minutes2: TMenuItem
        Tag = 201
        Caption = '15 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_30Minutes2: TMenuItem
        Tag = 202
        Caption = '30 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_45Minutes2: TMenuItem
        Tag = 203
        Caption = '45 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_60Minutes2: TMenuItem
        Tag = 204
        Caption = '1 hour'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_90Minutes2: TMenuItem
        Tag = 205
        Caption = '1.5 hours'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_120Minutes2: TMenuItem
        Tag = 206
        Caption = '2 hours'
        OnClick = StundenClick
      end
      object N52: TMenuItem
        Caption = '-'
      end
      object PM_S_ShutDown_Custom2: TMenuItem
        Tag = 207
        Caption = 'Custom'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_EndofPlaylist2: TMenuItem
        Tag = 200
        Caption = 'After the last file'
        OnClick = ShutDown_EndofPlaylistClick
      end
    end
    object PM_S_ShutDownModeHibernate: TMenuItem
      Tag = 2
      Caption = 'Hibernate Windows'
      RadioItem = True
      object PM_S_ShutDown_5Minutes3: TMenuItem
        Tag = 300
        Caption = '5 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_15Minutes3: TMenuItem
        Tag = 301
        Caption = '15 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_30Minutes3: TMenuItem
        Tag = 302
        Caption = '30 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_45Minutes3: TMenuItem
        Tag = 303
        Caption = '45 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_60Minutes3: TMenuItem
        Tag = 304
        Caption = '1 hour'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_90Minutes3: TMenuItem
        Tag = 305
        Caption = '1.5 hours'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_120Minutes3: TMenuItem
        Tag = 306
        Caption = '2 hours'
        OnClick = StundenClick
      end
      object N53: TMenuItem
        Caption = '-'
      end
      object PM_S_ShutDown_Custom3: TMenuItem
        Tag = 307
        Caption = 'Custom'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_EndofPlaylist3: TMenuItem
        Tag = 300
        Caption = 'After the last file'
        OnClick = ShutDown_EndofPlaylistClick
      end
    end
    object PM_S_ShutDownModeShutDownWindows: TMenuItem
      Tag = 3
      Caption = 'Shutdown Windows'
      RadioItem = True
      object PM_S_ShutDown_5Minutes4: TMenuItem
        Tag = 400
        Caption = '5 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_15Minutes4: TMenuItem
        Tag = 401
        Caption = '15 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_30Minutes4: TMenuItem
        Tag = 402
        Caption = '30 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_45Minutes4: TMenuItem
        Tag = 403
        Caption = '45 minutes'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_60Minutes4: TMenuItem
        Tag = 404
        Caption = '1 hour'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_90Minutes4: TMenuItem
        Tag = 405
        Caption = '1.5 hours'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_120Minutes4: TMenuItem
        Tag = 406
        Caption = '2 hours'
        OnClick = StundenClick
      end
      object N54: TMenuItem
        Caption = '-'
      end
      object PM_S_ShutDown_Custom4: TMenuItem
        Tag = 407
        Caption = 'Custom'
        OnClick = StundenClick
      end
      object PM_S_ShutDown_EndofPlaylist4: TMenuItem
        Tag = 400
        Caption = 'After the last file'
        OnClick = ShutDown_EndofPlaylistClick
      end
    end
  end
  object BirthdayPopup: TPopupMenu
    Left = 749
    Top = 404
    object _Birthdaymode: TMenuItem
      Caption = 'Birthday mode'
      Enabled = False
    end
    object PM_B_BirthdayActivate: TMenuItem
      Caption = 'Activate'
      OnClick = MenuBirthdayStartClick
    end
    object PM_B_BirthdayDeactivate: TMenuItem
      Caption = 'Deactivate'
      OnClick = MenuBirthdayAusClick
    end
    object N461: TMenuItem
      Caption = '-'
    end
    object PM_B_BirthdayOptions: TMenuItem
      Caption = 'Options'
      OnClick = PM_P_BirthdayOptionsClick
    end
  end
  object VST_ColumnPopup: TPopupMenu
    OnPopup = VST_ColumnPopupPopup
    Left = 532
    Top = 569
    object N58: TMenuItem
      Caption = '-'
    end
    object VST_ColumnPopupCover: TMenuItem
      AutoHotkeys = maManual
      Caption = 'Cover'
      object VST_ColumnPopupCoverOff: TMenuItem
        AutoCheck = True
        Caption = 'Disabled'
        RadioItem = True
        OnClick = VST_ColumnPopupCoverOnClick
      end
      object VST_ColumnPopupCoverLeft: TMenuItem
        Tag = 1
        AutoCheck = True
        Caption = 'Left'
        RadioItem = True
        OnClick = VST_ColumnPopupCoverOnClick
      end
      object VST_ColumnPopupCoverRight: TMenuItem
        Tag = 2
        AutoCheck = True
        Caption = 'Right'
        RadioItem = True
        OnClick = VST_ColumnPopupCoverOnClick
      end
    end
  end
  object PopupPlayPause: TPopupMenu
    Left = 653
    Top = 312
    object PM_PlayFiles: TMenuItem
      Caption = 'Play files'
      OnClick = PM_PlayFilesClick
    end
    object PM_PlayWebstream: TMenuItem
      Caption = 'Play webstream'
      OnClick = PM_PlayWebstreamClick
    end
  end
  object PopupStop: TPopupMenu
    OnPopup = PopupStopPopup
    Left = 653
    Top = 354
    object PM_StopNow: TMenuItem
      Caption = 'Stop'
      OnClick = PM_StopNowClick
    end
    object PM_StopAfterTitle: TMenuItem
      Caption = 'Stop after title'
      OnClick = PM_StopAfterTitleClick
    end
  end
  object PopupRepeat: TPopupMenu
    OnPopup = PopupRepeatPopup
    Left = 653
    Top = 402
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
  end
  object ScrobblerPopup: TPopupMenu
    Left = 749
    Top = 452
    object _Scrobbler: TMenuItem
      Caption = 'Scrobbler'
      Enabled = False
    end
    object PM_S_ScrobblerActivate: TMenuItem
      Caption = 'Activate'
      OnClick = PM_P_ScrobblerActivateClick
    end
    object PM_S_ScrobblerDeactivate: TMenuItem
      Caption = 'Deactivate'
      OnClick = PM_P_ScrobblerDeactivateClick
    end
    object N63: TMenuItem
      Caption = '-'
    end
    object PM_S_ScrobblerOptions: TMenuItem
      Caption = 'Options'
      OnClick = PM_P_ScrobblerOptionsClick
    end
  end
  object WebServerPopup: TPopupMenu
    Left = 749
    Top = 356
    object _Webserver: TMenuItem
      Caption = 'Nemp Webserver'
      Enabled = False
    end
    object PM_W_WebServerActivate: TMenuItem
      Caption = 'Activate'
      OnClick = MM_T_WebServerActivateClick
    end
    object PM_W_WebServerDeactivate: TMenuItem
      Caption = 'Deactivate'
      OnClick = MM_T_WebServerDeactivateClick
    end
    object N66: TMenuItem
      Caption = '-'
    end
    object PM_W_WebServerOptions: TMenuItem
      Caption = 'Options'
      OnClick = MM_T_WebServerOptionsClick
    end
  end
  object NempTrayIcon: TTrayIcon
    Hint = 'Nemp - Noch ein mp3-Player'
    PopupMenu = TNAMenu
    OnClick = NempTrayIconClick
    Left = 672
    Top = 568
  end
  object fspTaskbarManager: TfspTaskbarMgr
    Active = False
    ProgressValue = 0
    ProgressValueMax = 100
    ProgressState = fstpsNoProgress
    ThumbButtons = <
      item
        ImageIndex = -1
        Id = 0
        Hint = 'Play previous'
        ShowHint = True
        Flags = []
      end
      item
        ImageIndex = -1
        Id = 1
        Hint = 'Play/Pause'
        ShowHint = True
        Flags = []
      end
      item
        ImageIndex = -1
        Id = 2
        Hint = 'Stop'
        ShowHint = True
        Flags = []
      end
      item
        ImageIndex = -1
        Id = 3
        Hint = 'Play next'
        ShowHint = True
        Flags = []
      end>
    OnThumbButtonClick = fspTaskbarManagerThumbButtonClick
    Left = 664
    Top = 632
  end
  object fspTaskbarPreviews1: TfspTaskbarPreviews
    Active = True
    CustomLiveView = False
    OnNeedIconicBitmap = fspTaskbarPreviews1NeedIconicBitmap
    Left = 720
    Top = 632
  end
end
