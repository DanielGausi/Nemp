object Nemp_MainForm: TNemp_MainForm
  Tag = 3
  Left = 0
  Top = 0
  HelpContext = 10000
  Margins.Top = 0
  Caption = 'Nemp - Noch ein MP3-Player'
  ClientHeight = 627
  ClientWidth = 1076
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = Nemp_MainMenu
  Position = poDesigned
  ShowHint = True
  OnActivate = FormActivate
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnClose = TntFormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = TntFormDestroy
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnKeyUp = PlaylistVSTKeyUp
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object __MainContainerPanel: TNempContainerPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 1076
    Height = 627
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnMouseDown = __MainContainerPanelMouseDown
    OnMouseMove = __MainContainerPanelMouseMove
    OnMouseUp = __MainContainerPanelMouseUp
    Ratio = 0
    DrawMode = dm_Windows
    DrawFrame = False
    OwnerDraw = False
    HierarchyLevel = 0
    SplitterMinSize = 110
    object _ControlPanel: TNempPanel
      Left = 0
      Top = 527
      Width = 1076
      Height = 100
      Align = alBottom
      BevelOuter = bvNone
      PopupMenu = Player_PopupMenu
      TabOrder = 0
      OnMouseDown = __MainContainerPanelMouseDown
      OnMouseMove = __MainContainerPanelMouseMove
      OnMouseUp = __MainContainerPanelMouseUp
      OnResize = _ControlPanelResize
      Ratio = 0
      FixedHeight = True
      DrawMode = dm_Windows
      DrawFrame = False
      OwnerDraw = False
      object ControlContainer1: TNempPanel
        Tag = 6
        Left = 0
        Top = 0
        Width = 1076
        Height = 100
        Align = alClient
        BevelOuter = bvNone
        PopupMenu = Player_PopupMenu
        TabOrder = 0
        OnMouseDown = PaintFrameMouseDown
        OnMouseMove = PaintFrameMouseMove
        OnMouseUp = PaintFrameMouseUp
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        BackgroundBasePanel = True
        OwnerDraw = False
        object PlayerControlCoverPanel: TNempPanel
          Tag = 6
          Left = 40
          Top = 0
          Width = 100
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          BackgroundBasePanel = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object CoverImage: TAudioCoverImage
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 88
            Height = 88
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Center = True
            PopupMenu = Player_PopupMenu
            Proportional = True
            Stretch = True
            OnDblClick = CoverImageDblClick
            OnMouseDown = ImgDetailCoverMouseDown
            OnMouseMove = ImgDetailCoverMouseMove
            OnShowHint = CoverImageShowHint
            OnDrawHint = CoverImageDrawHint
            OnGetHintSize = CoverImageGetHintSize
            ExplicitLeft = 7
          end
        end
        object OutputControlPanel: TNempPanel
          Tag = 6
          Left = 0
          Top = 0
          Width = 40
          Height = 100
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = PlayListPOPUP
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object TabBtn_Equalizer: TSkinButton
            Tag = 3
            Left = 8
            Top = 68
            Width = 24
            Height = 24
            Hint = 'Show equalizer and effect controls'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TabBtn_EqualizerClick
            OnMouseMove = TabBtn_CoverMouseMove
            ImageIndex = 8
            ImageName = 'TabBtnEffects'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Headset: TSkinButton
            Tag = 5
            Left = 8
            Top = 38
            Width = 24
            Height = 24
            Hint = 'Show headset controls'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = TabBtn_HeadsetClick
            OnMouseMove = TabBtn_CoverMouseMove
            ImageIndex = 10
            ImageName = 'TabBtnHeadphones'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
        object PlayerControlPanel: TNempPanel
          Tag = 5
          Left = 140
          Top = 0
          Width = 936
          Height = 100
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 2
          OnResize = NewPlayerPanelResize
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          BackgroundBasePanel = True
          OnPaintBackground = PanelPaintBackground
          OnPaintBackgroundEx = PanelPaintBackgroundEx
          OwnerDraw = False
          object pnlControlHead: TNempPanel
            Tag = 5
            Left = 2
            Top = 2
            Width = 932
            Height = 24
            Margins.Left = 1
            Margins.Top = 1
            Margins.Right = 1
            Margins.Bottom = 0
            Align = alTop
            BevelOuter = bvNone
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OnPaintBackgroundEx = PanelPaintBackgroundEx
            OwnerDraw = False
            object viBirthdayTimer: TVirtualImage
              AlignWithMargins = True
              Left = 855
              Top = 4
              Width = 16
              Height = 16
              Hint = 'Birthday timer'
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 56
              ImageName = 'toolbtnbirthday'
              OnClick = ToolImageClick
              OnDblClick = PM_P_BirthdayOptionsClick
              ExplicitLeft = 646
            end
            object viWebServer: TVirtualImage
              AlignWithMargins = True
              Left = 755
              Top = 4
              Width = 16
              Height = 16
              Hint = 'Nemp Webserver'
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 65
              ImageName = 'ToolBtnWebserver'
              OnClick = ToolImageClick
              OnDblClick = MM_T_WebServerOptionsClick
              ExplicitLeft = 646
            end
            object viWalkman: TVirtualImage
              AlignWithMargins = True
              Left = 775
              Top = 4
              Width = 16
              Height = 16
              Hint = 'Low battery'
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 60
              ImageName = 'ToolBtnWarning'
              OnClick = WalkmanImageClick
              ExplicitLeft = 655
              ExplicitTop = 1
            end
            object viSleepTimer: TVirtualImage
              AlignWithMargins = True
              Left = 795
              Top = 4
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 59
              ImageName = 'ToolBtnShutdown'
              OnClick = ToolImageClick
              ExplicitLeft = 646
            end
            object viLastFM: TVirtualImage
              AlignWithMargins = True
              Left = 815
              Top = 4
              Width = 16
              Height = 16
              Hint = 'Nemp Scrobbler'
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 58
              ImageName = 'toolbtnLastfm'
              OnClick = ToolImageClick
              OnDblClick = PM_P_ScrobblerOptionsClick
              ExplicitLeft = 646
            end
            object viWinamp: TVirtualImage
              AlignWithMargins = True
              Left = 835
              Top = 4
              Width = 16
              Height = 16
              Hint = 'Winamp DSP plugins'
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 61
              ImageName = 'ToolBtnWinamp'
              OnClick = ToolImageClick
              ExplicitLeft = 646
            end
            object BtnMainAudioFileRating: TRatingButton
              AlignWithMargins = True
              Left = 8
              Top = 4
              Width = 80
              Height = 16
              Hint = 'Click to change rating'
              Margins.Left = 8
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Align = alLeft
              DoubleBuffered = False
              DoubleBufferedMode = dbmRequested
              DrawMode = dm_Windows
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              TabOrder = 0
              TransparentBackground = True
              StyleElements = [seFont, seBorder]
              Rating = 120
              AllowChangeRating = True
              OnRatingChanged = BtnMainAudioFileRatingRatingChanged
              StarFullImageIndex = 29
              StarHalfImageIndex = 30
              StarEmptyImageIndex = 28
              StarFullImageName = 'MenuStarFull'
              StarHalfImageName = 'MenuStarHalf'
              StarEmptyImageName = 'MenuStarEmpty'
            end
            object pnlSysMain: TNempPanel
              Tag = 5
              AlignWithMargins = True
              Left = 883
              Top = 0
              Width = 45
              Height = 24
              Margins.Left = 8
              Margins.Top = 0
              Margins.Right = 4
              Margins.Bottom = 0
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 1
              Visible = False
              Ratio = 0
              DrawMode = dm_Windows
              DrawFrame = False
              OnPaintBackground = PanelPaintBackground
              OnPaintBackgroundEx = PanelPaintBackgroundEx
              OwnerDraw = False
              object BtnClose: TSkinButton
                AlignWithMargins = True
                Left = 25
                Top = 4
                Width = 16
                Height = 16
                Hint = 'Close Nemp'
                Margins.Left = 0
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alRight
                DoubleBuffered = True
                DrawMode = dm_Skin
                Images = vilIconsWindows
                ParentDoubleBuffered = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                TabStop = False
                StyleElements = [seFont, seBorder]
                OnClick = BtnCloseClick
                ImageIndex = 4
                ImageName = 'MenuCloseNemp'
                BackgroundIndex = 55
                BackgroundIndexHighlight = 54
                BackgroundIndexPressed = 53
                BackgroundIndexDisabled = 52
                BackgroundName = 'ToolBtnBGNormal'
                BackgroundNameHighlight = 'ToolBtnBGHighlight'
                BackgroundNamePressed = 'ToolBtnBGDown'
                BackgroundNameDisabled = 'ToolBtnBGDisabled'
              end
              object BtnMinimize: TSkinButton
                AlignWithMargins = True
                Left = 5
                Top = 4
                Width = 16
                Height = 16
                Hint = 'Minimize Nemp'
                Margins.Left = 0
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alRight
                DoubleBuffered = True
                DrawMode = dm_Skin
                Images = vilIconsWindows
                ParentDoubleBuffered = False
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                TabStop = False
                StyleElements = [seFont, seBorder]
                OnClick = BtnMinimizeClick
                ImageIndex = 64
                ImageName = 'SysBtnMinimize'
                BackgroundIndex = 55
                BackgroundIndexHighlight = 54
                BackgroundIndexPressed = 53
                BackgroundIndexDisabled = 52
                BackgroundName = 'ToolBtnBGNormal'
                BackgroundNameHighlight = 'ToolBtnBGHighlight'
                BackgroundNamePressed = 'ToolBtnBGDown'
                BackgroundNameDisabled = 'ToolBtnBGDisabled'
              end
            end
            object pnlControlTitle: TNempPanel
              Tag = 5
              AlignWithMargins = True
              Left = 92
              Top = 0
              Width = 659
              Height = 24
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 4
              Margins.Bottom = 0
              Align = alClient
              BevelOuter = bvNone
              DoubleBuffered = True
              ParentDoubleBuffered = False
              TabOrder = 2
              Ratio = 0
              DrawMode = dm_Windows
              DrawFrame = False
              OnPaintBackground = PanelPaintBackground
              OnPaintBackgroundEx = PanelPaintBackgroundEx
              OwnerDraw = False
              ExplicitWidth = 357
              object PlayerArtistLabel: TLabel
                AlignWithMargins = True
                Left = 4
                Top = 4
                Width = 12
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alLeft
                Caption = '...'
                ShowAccelChar = False
                StyleElements = [seClient, seBorder]
                OnDblClick = PlayerArtistLabelDblClick
                ExplicitHeight = 13
              end
              object PlayerTitleLabel: TLabel
                AlignWithMargins = True
                Left = 28
                Top = 4
                Width = 12
                Height = 16
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                Align = alLeft
                Caption = '...'
                ExplicitHeight = 13
              end
              object LabelArtistTitleSeparator: TLabel
                AlignWithMargins = True
                Left = 20
                Top = 4
                Width = 4
                Height = 16
                Margins.Left = 0
                Margins.Top = 4
                Margins.Right = 0
                Margins.Bottom = 4
                Align = alLeft
                Caption = '-'
                ExplicitHeight = 13
              end
            end
          end
          object pnlControlButtons: TNempPanel
            Tag = 5
            Left = 2
            Top = 26
            Width = 932
            Height = 40
            Margins.Right = 4
            Align = alClient
            BevelOuter = bvNone
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 1
            OnMouseDown = PaintFrameMouseDown
            OnMouseMove = PaintFrameMouseMove
            OnMouseUp = PaintFrameMouseUp
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OnPaintBackgroundEx = PanelPaintBackgroundEx
            OwnerDraw = False
            object PlayNextBTN: TSkinButton
              AlignWithMargins = True
              Left = 124
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Next title'
              Margins.Left = 0
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = PlayNextBTNIMGClick
              ImageIndex = 4
              ImageName = 'PlayerNext'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object PlayPauseBTN: TSkinButton
              AlignWithMargins = True
              Left = 8
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Play/Pause'
              Margins.Left = 8
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              PopupMenu = PopupPlayPause
              TabOrder = 0
              OnClick = PlayPauseBTNIMGClick
              ImageIndex = 6
              ImageName = 'PlayerPlay'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object PlayPrevBTN: TSkinButton
              AlignWithMargins = True
              Left = 88
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Previous title'
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              TabOrder = 2
              OnClick = PlayPrevBTNIMGClick
              ImageIndex = 8
              ImageName = 'PlayerPrev'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object RandomBtn: TSkinButton
              AlignWithMargins = True
              Left = 280
              Top = 2
              Width = 36
              Height = 36
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              ParentShowHint = False
              PopupMenu = PopupRepeat
              ShowHint = True
              TabOrder = 7
              OnClick = RepeatBitBTNIMGClick
              ImageIndex = 11
              ImageName = 'PlayerRepeatAll'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object SlideBackBTN: TSkinButton
              Tag = -1
              AlignWithMargins = True
              Left = 164
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Slide backward'
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = SlideBackBTNIMGClick
              ImageIndex = 15
              ImageName = 'PlayerSlidebackward'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object SlideForwardBTN: TSkinButton
              Tag = 1
              AlignWithMargins = True
              Left = 200
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Slide forward'
              Margins.Left = 0
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              OnClick = SlideForwardBTNIMGClick
              ImageIndex = 16
              ImageName = 'PlayerSlideForward'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object StopBTN: TSkinButton
              AlignWithMargins = True
              Left = 48
              Top = 2
              Width = 36
              Height = 36
              Hint = 'Stop'
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              PopupMenu = PopupStop
              TabOrder = 1
              OnClick = StopBTNIMGClick
              ImageIndex = 17
              ImageName = 'PlayerStop'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
            object NempSpectrum: TNempSpectrum
              AlignWithMargins = True
              Left = 804
              Top = 4
              Width = 120
              Height = 32
              Margins.Left = 8
              Margins.Top = 4
              Margins.Right = 8
              Margins.Bottom = 4
              BarCount = 30
              BarWidth = 4
              FallSpeedBars = 3
              FallSpeedPeaks = 1
              DrawMode = sdmGradientBars
              DrawPeaks = True
              ColorPeak = clBlack
              ColorBar1 = clBlack
              ColorBar2 = clBlack
              OnShowHint = CoverImageShowHint
              OnDrawHint = CoverImageDrawHint
              OnGetHintSize = CoverImageGetHintSize
              OnDblClick = PaintFrameDblClick
              OnMouseDown = PaintFrameMouseDown
              OnMouseMove = PaintFrameMouseMove
              OnMouseUp = PaintFrameMouseUp
              Align = alRight
            end
            object RecordBtn: TSkinButton
              AlignWithMargins = True
              Left = 240
              Top = 2
              Width = 36
              Height = 36
              Margins.Left = 4
              Margins.Top = 2
              Margins.Right = 0
              Margins.Bottom = 2
              Align = alLeft
              DoubleBuffered = True
              DrawMode = dm_Windows
              Images = viPlayerButtons
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              Visible = False
              OnClick = RecordBtnIMGClick
              ImageIndex = 9
              ImageName = 'PlayerRecordOff'
              BackgroundIndex = 0
              BackgroundIndexHighlight = 1
              BackgroundIndexPressed = 2
              BackgroundIndexDisabled = 3
              BackgroundName = 'BtnBGNormal'
              BackgroundNameHighlight = 'BtnBGHighlight'
              BackgroundNamePressed = 'BtnBGDown'
              BackgroundNameDisabled = 'BtnBGDisabled'
            end
          end
          object pnlControlSlider: TNempPanel
            Tag = 5
            AlignWithMargins = True
            Left = 2
            Top = 66
            Width = 932
            Height = 28
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 4
            Align = alBottom
            BevelOuter = bvNone
            DoubleBuffered = False
            ParentDoubleBuffered = False
            TabOrder = 2
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OnPaintBackgroundEx = PanelPaintBackgroundEx
            OwnerDraw = False
            object PlayerTimeLbl: TLabel
              AlignWithMargins = True
              Left = 4
              Top = 8
              Width = 34
              Height = 12
              Margins.Left = 4
              Margins.Top = 8
              Margins.Right = 0
              Margins.Bottom = 8
              Align = alLeft
              Alignment = taRightJustify
              AutoSize = False
              Caption = '00:00'
              StyleElements = [seClient, seBorder]
              OnClick = BassTimeLBLClick
              ExplicitLeft = 430
              ExplicitTop = 6
              ExplicitHeight = 13
            end
            object viVolume: TVirtualImage
              AlignWithMargins = True
              Left = 784
              Top = 6
              Width = 16
              Height = 16
              Margins.Left = 4
              Margins.Top = 6
              Margins.Right = 0
              Margins.Bottom = 6
              Align = alRight
              ImageCollection = DataModuleGui.ICIcons
              ImageWidth = 0
              ImageHeight = 0
              ImageIndex = 66
              ImageName = 'BtnVolumeHigh'
              OnClick = BtnVolumeClick
              ExplicitLeft = 687
            end
            object rbTrackProgress: TProgressRangeBar
              AlignWithMargins = True
              Left = 38
              Top = 0
              Width = 742
              Height = 28
              Margins.Left = 0
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              OnScroll = rbTrackProgressScroll
              OnStep = rbTrackProgressStep
              OnEndScroll = rbTrackProgressEndScroll
              PopupMenu = PopupRepeatAB
              RangeMin = 0
              RangeMax = 100
              RangeMaxNorm = 1.000000000000000000
              Orientation = trHorizontal
              ButtonMode = bmCentered
              Style = dm_Windows
              TrackBarMargin = 8
              Position = 0
              DefaultPosition = 0
              AllowRange = True
              RangeActive = False
              TrackButton.Colors.FrameColor = clActiveBorder
              TrackButton.Colors.FrameHighlightColor = clActiveBorder
              TrackButton.Colors.FrameDisabledColor = clInactiveBorder
              TrackButton.Colors.BrushColor = clBtnFace
              TrackButton.Colors.BrushHighlightColor = clBtnHighlight
              TrackButton.Colors.BrushDisabledColor = clBtnShadow
              TrackButton.Colors.FocusRectColor = clHighlight
              TrackButton.FrameWidth = 1
              TrackButton.Radius = 4
              TrackButton.VisibleMode = vHover
              TrackButton.Thickness = 12
              TrackButton.Length = 20
              RangeButtonMin.Colors.FrameColor = clActiveBorder
              RangeButtonMin.Colors.FrameHighlightColor = clActiveBorder
              RangeButtonMin.Colors.FrameDisabledColor = clInactiveBorder
              RangeButtonMin.Colors.BrushColor = clBtnFace
              RangeButtonMin.Colors.BrushHighlightColor = clBtnHighlight
              RangeButtonMin.Colors.BrushDisabledColor = clBtnShadow
              RangeButtonMin.Colors.FocusRectColor = clHighlight
              RangeButtonMin.FrameWidth = 1
              RangeButtonMin.Radius = 4
              RangeButtonMin.VisibleMode = vAlways
              RangeButtonMin.Thickness = 12
              RangeButtonMin.Length = 18
              RangeButtonMax.Colors.FrameColor = clActiveBorder
              RangeButtonMax.Colors.FrameHighlightColor = clActiveBorder
              RangeButtonMax.Colors.FrameDisabledColor = clInactiveBorder
              RangeButtonMax.Colors.BrushColor = clBtnFace
              RangeButtonMax.Colors.BrushHighlightColor = clBtnHighlight
              RangeButtonMax.Colors.BrushDisabledColor = clBtnShadow
              RangeButtonMax.Colors.FocusRectColor = clHighlight
              RangeButtonMax.FrameWidth = 1
              RangeButtonMax.Radius = 4
              RangeButtonMax.VisibleMode = vAlways
              RangeButtonMax.Thickness = 12
              RangeButtonMax.Length = 18
              TrackBar.Colors.FrameColor = clActiveBorder
              TrackBar.Colors.FrameHighlightColor = clActiveBorder
              TrackBar.Colors.FrameDisabledColor = clInactiveBorder
              TrackBar.Colors.BrushColor = clBtnFace
              TrackBar.Colors.BrushHighlightColor = clBtnHighlight
              TrackBar.Colors.BrushDisabledColor = clBtnShadow
              TrackBar.Colors.FocusRectColor = clHighlight
              TrackBar.FrameWidth = 1
              TrackBar.Radius = 4
              TrackBar.VisibleMode = vAlways
              TrackBar.Thickness = 8
              ProgressBar.Colors.FrameColor = clActiveBorder
              ProgressBar.Colors.FrameHighlightColor = clActiveBorder
              ProgressBar.Colors.FrameDisabledColor = clInactiveBorder
              ProgressBar.Colors.BrushColor = clHighlight
              ProgressBar.Colors.BrushHighlightColor = clBtnHighlight
              ProgressBar.Colors.BrushDisabledColor = clBtnShadow
              ProgressBar.Colors.FocusRectColor = clHighlight
              ProgressBar.FrameWidth = 1
              ProgressBar.Radius = 4
              ProgressBar.VisibleMode = vAlways
              ProgressBar.Thickness = 8
              RangeBar.Colors.FrameColor = clActiveBorder
              RangeBar.Colors.FrameHighlightColor = clActiveBorder
              RangeBar.Colors.FrameDisabledColor = clInactiveBorder
              RangeBar.Colors.BrushColor = clBtnFace
              RangeBar.Colors.BrushHighlightColor = clBtnHighlight
              RangeBar.Colors.BrushDisabledColor = clBtnShadow
              RangeBar.Colors.FocusRectColor = clHighlight
              RangeBar.FrameWidth = 1
              RangeBar.Radius = 4
              RangeBar.VisibleMode = vAlways
              RangeBar.Thickness = 4
              Align = alClient
              ExplicitWidth = 459
            end
            object rbVolume: TProgressRangeBar
              AlignWithMargins = True
              Left = 800
              Top = 6
              Width = 128
              Height = 16
              Margins.Left = 0
              Margins.Top = 6
              Margins.Right = 4
              Margins.Bottom = 6
              OnScroll = rbVolumeScroll
              OnStep = rbVolumeStep
              OnMouseWheelDown = rbVolumeMouseWheelDown
              OnMouseWheelUp = rbVolumeMouseWheelUp
              RangeMin = 0
              RangeMax = 100
              RangeMaxNorm = 1.000000000000000000
              Orientation = trHorizontal
              ButtonMode = bmNested
              Style = dm_Windows
              TrackBarMargin = 4
              Position = 0
              DefaultPosition = 0
              AllowRange = False
              RangeActive = False
              TrackButton.Colors.FrameColor = clActiveBorder
              TrackButton.Colors.FrameHighlightColor = clActiveBorder
              TrackButton.Colors.FrameDisabledColor = clInactiveBorder
              TrackButton.Colors.BrushColor = clBtnFace
              TrackButton.Colors.BrushHighlightColor = clBtnHighlight
              TrackButton.Colors.BrushDisabledColor = clBtnShadow
              TrackButton.Colors.FocusRectColor = clHighlight
              TrackButton.FrameWidth = 1
              TrackButton.Radius = 4
              TrackButton.VisibleMode = vAlways
              TrackButton.Thickness = 12
              TrackButton.Length = 20
              RangeButtonMin.Colors.FrameColor = clActiveBorder
              RangeButtonMin.Colors.FrameHighlightColor = clActiveBorder
              RangeButtonMin.Colors.FrameDisabledColor = clInactiveBorder
              RangeButtonMin.Colors.BrushColor = clBtnFace
              RangeButtonMin.Colors.BrushHighlightColor = clBtnHighlight
              RangeButtonMin.Colors.BrushDisabledColor = clBtnShadow
              RangeButtonMin.Colors.FocusRectColor = clHighlight
              RangeButtonMin.FrameWidth = 1
              RangeButtonMin.Radius = 4
              RangeButtonMin.VisibleMode = vAlways
              RangeButtonMin.Thickness = 12
              RangeButtonMin.Length = 18
              RangeButtonMax.Colors.FrameColor = clActiveBorder
              RangeButtonMax.Colors.FrameHighlightColor = clActiveBorder
              RangeButtonMax.Colors.FrameDisabledColor = clInactiveBorder
              RangeButtonMax.Colors.BrushColor = clBtnFace
              RangeButtonMax.Colors.BrushHighlightColor = clBtnHighlight
              RangeButtonMax.Colors.BrushDisabledColor = clBtnShadow
              RangeButtonMax.Colors.FocusRectColor = clHighlight
              RangeButtonMax.FrameWidth = 1
              RangeButtonMax.Radius = 4
              RangeButtonMax.VisibleMode = vAlways
              RangeButtonMax.Thickness = 12
              RangeButtonMax.Length = 18
              TrackBar.Colors.FrameColor = clActiveBorder
              TrackBar.Colors.FrameHighlightColor = clActiveBorder
              TrackBar.Colors.FrameDisabledColor = clInactiveBorder
              TrackBar.Colors.BrushColor = clBtnFace
              TrackBar.Colors.BrushHighlightColor = clBtnHighlight
              TrackBar.Colors.BrushDisabledColor = clBtnShadow
              TrackBar.Colors.FocusRectColor = clHighlight
              TrackBar.FrameWidth = 1
              TrackBar.Radius = 4
              TrackBar.VisibleMode = vAlways
              TrackBar.Thickness = 8
              ProgressBar.Colors.FrameColor = clActiveBorder
              ProgressBar.Colors.FrameHighlightColor = clActiveBorder
              ProgressBar.Colors.FrameDisabledColor = clInactiveBorder
              ProgressBar.Colors.BrushColor = clHighlight
              ProgressBar.Colors.BrushHighlightColor = clBtnHighlight
              ProgressBar.Colors.BrushDisabledColor = clBtnShadow
              ProgressBar.Colors.FocusRectColor = clHighlight
              ProgressBar.FrameWidth = 1
              ProgressBar.Radius = 4
              ProgressBar.VisibleMode = vAlways
              ProgressBar.Thickness = 8
              RangeBar.Colors.FrameColor = clActiveBorder
              RangeBar.Colors.FrameHighlightColor = clActiveBorder
              RangeBar.Colors.FrameDisabledColor = clInactiveBorder
              RangeBar.Colors.BrushColor = clBtnFace
              RangeBar.Colors.BrushHighlightColor = clBtnHighlight
              RangeBar.Colors.BrushDisabledColor = clBtnShadow
              RangeBar.Colors.FocusRectColor = clHighlight
              RangeBar.FrameWidth = 1
              RangeBar.Radius = 4
              RangeBar.VisibleMode = vAlways
              RangeBar.Thickness = 4
              Align = alRight
            end
          end
        end
      end
    end
    object PlaylistPanel: TNempPanel
      Tag = 1
      Left = 832
      Top = 32
      Width = 234
      Height = 158
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 1
      OnResize = PlaylistPanelResize
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OnPaintBackground = PanelPaintBackground
      OwnerDraw = False
      object GRPBOXPlaylist: TNempPanel
        Tag = 1
        Left = 0
        Top = 28
        Width = 234
        Height = 130
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        PopupMenu = PlayListPOPUP
        TabOrder = 1
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object PlaylistVST: TVirtualStringTree
          Left = 2
          Top = 2
          Width = 230
          Height = 126
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Ctl3D = True
          DefaultPasteMode = amInsertAfter
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
          Indent = 2
          Margin = 0
          ParentCtl3D = False
          ParentFont = False
          ParentShowHint = False
          PopupMenu = PlayListPOPUP
          ScrollBarOptions.ScrollBars = ssVertical
          ShowHint = True
          StyleElements = [seClient, seBorder]
          TabOrder = 0
          TextMargin = 2
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking, toAutoChangeScale]
          TreeOptions.PaintOptions = [toShowBackground, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
          TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toMultiSelect, toRightClickSelect]
          OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
          OnAfterItemErase = VSTAfterItemErase
          OnAfterItemPaint = PlaylistVSTAfterItemPaint
          OnBeforeItemErase = VSTBeforeItemErase
          OnChange = PlaylistVSTChange
          OnColumnDblClick = PlaylistVSTColumnDblClick
          OnDragAllowed = PlaylistVSTDragAllowed
          OnDragOver = PlaylistVSTDragOver
          OnDragDrop = PlaylistVSTDragDrop
          OnDrawHint = TitlesVSTDrawHint
          OnEndDrag = PlaylistVSTEndDrag
          OnGetText = PlaylistVSTGetText
          OnPaintText = VSTPaintText
          OnGetHintKind = TitlesVSTGetHintKind
          OnGetHintSize = TitlesVSTGetHintSize
          OnGetImageIndex = PlaylistVSTGetImageIndex
          OnGetHint = TitlesVSTGetHint
          OnGetUserClipboardFormats = TreesGetUserClipboardFormats
          OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
          OnKeyDown = PlaylistVSTKeyDown
          OnKeyUp = PlaylistVSTKeyUp
          OnNodeClick = PlaylistVSTNodeClick
          OnRenderOLEData = TreesRenderOLEData
          OnStartDrag = PlaylistVSTStartDrag
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              Alignment = taRightJustify
              Margin = 0
              Position = 0
              Spacing = 0
              Text = '#'
              Width = 30
            end
            item
              Position = 1
              Spacing = 0
              Text = 'Title'
              Width = 160
            end
            item
              Alignment = taRightJustify
              Margin = 0
              Position = 2
              Spacing = 50
              Text = 'Time'
              Width = 40
            end>
        end
      end
      object PlayerHeaderPanel: TNempPanel
        Tag = 1
        Left = 0
        Top = 0
        Width = 234
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object PlaylistFillPanel: TNempPanel
          Tag = 1
          AlignWithMargins = True
          Left = 127
          Top = 2
          Width = 107
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          PopupMenu = PlayListPOPUP
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object PlayListStatusLBL: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 73
            Height = 14
            Align = alClient
            AutoSize = False
            ShowAccelChar = False
            Transparent = True
            StyleElements = [seClient, seBorder]
            ExplicitLeft = 6
            ExplicitTop = 7
            ExplicitWidth = 43
            ExplicitHeight = 13
          end
          object pnlSysPlaylist: TNempPanel
            Tag = 1
            Left = 81
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnClosePlaylist: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object PlaylistControlPanel: TNempPanel
          Tag = 1
          Left = 0
          Top = 0
          Width = 127
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object TabBtn_Playlist: TSkinButton
            Left = 0
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = TabPanelPlaylistClick
            ImageIndex = 17
            ImageName = 'TabBtnNemp'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Favorites: TSkinButton
            Left = 26
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Favorite playlists'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            TabOrder = 1
            OnClick = TabBtn_FavoritesClick
            ImageIndex = 9
            ImageName = 'TabBtnFavorite'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object EditPlaylistSearch: TEdit
            Left = 56
            Top = 3
            Width = 65
            Height = 21
            AutoSize = False
            TabOrder = 2
            TextHint = 'Search'
            OnChange = EditPlaylistSearchChange
            OnEnter = EditPlaylistSearchEnter
            OnKeyDown = EditPlaylistSearchKeyDown
            OnKeyPress = EditPlaylistSearchKeyPress
          end
        end
      end
    end
    object MedienBibDetailPanel: TNempPanel
      Tag = 4
      Left = 728
      Top = 243
      Width = 300
      Height = 230
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 2
      OnResize = MedienBibDetailPanelResize
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OwnerDraw = False
      object ContainerPanelMedienBibDetails: TNempPanel
        Tag = 4
        Left = 0
        Top = 28
        Width = 300
        Height = 202
        Align = alClient
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OwnerDraw = False
        object SplitterFileOverview: TSplitter
          Left = 129
          Top = 0
          Width = 4
          Height = 202
          ResizeStyle = rsUpdate
          StyleElements = [seFont, seBorder]
          OnCanResize = SplitterFileOverviewCanResize
          OnMoved = SplitterFileOverviewMoved
          ExplicitLeft = 250
          ExplicitTop = 3
          ExplicitHeight = 377
        end
        object DetailCoverLyricsPanel: TNempPanel
          Tag = 4
          Left = 0
          Top = 0
          Width = 129
          Height = 202
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = PopupEditExtendedTags
          TabOrder = 0
          OnResize = DetailID3TagPanelResize
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OnPaintBackgroundEx = PanelPaintBackgroundEx
          OwnerDraw = False
          object ImgDetailCover: TImage
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 117
            Height = 190
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
            Center = True
            Proportional = True
            Stretch = True
            OnDblClick = ImgDetailCoverDblClick
            OnMouseDown = ImgDetailCoverMouseDown
            OnMouseMove = ImgDetailCoverMouseMove
            ExplicitTop = 105
            ExplicitHeight = 88
          end
          object LyricsMemo: TMemo
            AlignWithMargins = True
            Left = 6
            Top = 6
            Width = 117
            Height = 190
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            Align = alClient
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
          Tag = 4
          Left = 133
          Top = 0
          Width = 167
          Height = 202
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = True
          ParentDoubleBuffered = False
          PopupMenu = PopupEditExtendedTags
          TabOrder = 1
          OnResize = DetailID3TagPanelResize
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OnPaintBackgroundEx = PanelPaintBackgroundEx
          OwnerDraw = False
          DesignSize = (
            167
            202)
          object LblBibAlbum: TLabel
            Tag = 2
            Left = 8
            Top = 42
            Width = 45
            Height = 13
            Caption = '               '
            ShowAccelChar = False
            StyleElements = [seClient, seBorder]
            OnDblClick = DetailLabelDblClick
            OnMouseEnter = DetailLabelMouseOver
            OnMouseLeave = DetailLabelMouseLeave
          end
          object LblBibArtist: TLabel
            Left = 8
            Top = 8
            Width = 45
            Height = 13
            Caption = '               '
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
            Width = 45
            Height = 13
            Caption = '               '
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
            Left = 94
            Top = 130
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
            Width = 149
            Height = 5
            Anchors = [akLeft, akTop, akRight]
            Shape = bsBottomLine
            ExplicitWidth = 209
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
            Width = 45
            Height = 13
            Caption = '               '
            ShowAccelChar = False
            StyleElements = [seClient, seBorder]
          end
          object Bevel2: TBevel
            Left = 9
            Top = 165
            Width = 149
            Height = 5
            Anchors = [akLeft, akTop, akRight]
            Shape = bsBottomLine
            ExplicitWidth = 209
          end
          object BtnBibRating: TRatingButton
            Left = 8
            Top = 129
            Width = 80
            Height = 16
            Hint = 'Click to change rating'
            DoubleBuffered = False
            DoubleBufferedMode = dbmRequested
            DrawMode = dm_Windows
            Images = vilIconsWindows
            ParentDoubleBuffered = False
            TabOrder = 0
            TransparentBackground = True
            StyleElements = [seFont, seBorder]
            Rating = 120
            AllowChangeRating = True
            OnRatingChanged = BtnBibRatingRatingChanged
            StarFullImageIndex = 29
            StarHalfImageIndex = 30
            StarEmptyImageIndex = 28
            StarFullImageName = 'MenuStarFull'
            StarHalfImageName = 'MenuStarHalf'
            StarEmptyImageName = 'MenuStarEmpty'
          end
        end
      end
      object MedienBibDetailHeaderPanel: TNempPanel
        Tag = 4
        Left = 0
        Top = 0
        Width = 300
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object MedienBibDetailFillPanel: TNempPanel
          Tag = 4
          AlignWithMargins = True
          Left = 56
          Top = 2
          Width = 244
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = Medialist_View_PopupMenu
          TabOrder = 0
          StyleElements = [seClient, seBorder]
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object MedienBibDetailStatusLbl: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 210
            Height = 14
            Align = alClient
            AutoSize = False
            Caption = 'File overview'
            StyleElements = [seClient, seBorder]
            ExplicitLeft = 14
            ExplicitTop = 4
            ExplicitWidth = 115
            ExplicitHeight = 13
          end
          object pnlSysDetails: TNempPanel
            Tag = 4
            Left = 218
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnCloseDetails: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object MedienBibDetailControlPanel: TNempPanel
          Tag = 4
          Left = 0
          Top = 0
          Width = 56
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object TabBtn_Cover: TSkinButton
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Toggle Cover/Lyrics'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = PlayerTabsClick
            OnMouseMove = TabBtn_CoverMouseMove
            ImageIndex = 6
            ImageName = 'TabBtnCover'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_SummaryLock: TSkinButton
            Tag = 2
            Left = 28
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Toggle File Overview (player only vs. selected file)'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Player_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TabBtn_SummaryLockClick
            OnMouseMove = TabBtn_CoverMouseMove
            ImageIndex = 9
            ImageName = 'TabBtnFavorite'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
    end
    object MedialistPanel: TNempPanel
      Tag = 3
      Left = 8
      Top = 263
      Width = 553
      Height = 145
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 3
      OnResize = MedialistPanelResize
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OwnerDraw = False
      object MedienBibHeaderPanel: TNempPanel
        Tag = 3
        Left = 0
        Top = 0
        Width = 553
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object MedienlisteFillPanel: TNempPanel
          Tag = 3
          AlignWithMargins = True
          Left = 236
          Top = 2
          Width = 317
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = Medialist_View_PopupMenu
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object MedienListeStatusLBL: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 283
            Height = 14
            Align = alClient
            AutoSize = False
            ShowAccelChar = False
            Transparent = True
            StyleElements = [seClient, seBorder]
            ExplicitLeft = 14
            ExplicitWidth = 195
            ExplicitHeight = 13
          end
          object pnlSysMediaList: TNempPanel
            Tag = 3
            Left = 291
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnCloseMediaList: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object MedienListeControlPanel: TNempPanel
          Tag = 3
          Left = 0
          Top = 0
          Width = 236
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object EDITFastSearch: TEdit
            Left = 58
            Top = 3
            Width = 172
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
            TextHint = 'Search (Library)'
            OnChange = EDITFastSearchChange
            OnEnter = EDITFastSearchEnter
            OnExit = EDITFastSearchExit
            OnKeyPress = EDITFastSearchKeyPress
          end
          object TabBtn_Marker: TSkinButton
            Left = 28
            Top = 2
            Width = 24
            Height = 24
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = TabBtn_MarkerClick
            OnKeyPress = TabBtn_MarkerKeyPress
            OnMouseDown = TabBtn_MarkerMouseDown
            ImageIndex = 13
            ImageName = 'TabBtnMarkBlack'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Medialib: TSkinButton
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = TabPanelMedienlisteClick
            ImageIndex = 17
            ImageName = 'TabBtnNemp'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
      object GRPBOXVST: TNempPanel
        Tag = 3
        Left = 0
        Top = 28
        Width = 553
        Height = 117
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        DoubleBuffered = False
        ParentDoubleBuffered = False
        PopupMenu = Medialist_View_PopupMenu
        TabOrder = 1
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object VST: TVirtualStringTree
          Left = 2
          Top = 2
          Width = 549
          Height = 113
          AccessibleName = 'Harmonic key'
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Colors.SelectionTextColor = clWindowText
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Constraints.MinHeight = 26
          DragImageKind = diMainColumnOnly
          DragWidth = 10
          EditDelay = 50
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.AutoSizeIndex = -1
          Header.Background = clWindow
          Header.Height = 21
          Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoRestrictDrag, hoShowSortGlyphs, hoVisible]
          Header.SortColumn = 0
          HintMode = hmHint
          Images = vilIconsWindows
          IncrementalSearch = isAll
          Indent = 0
          Margin = 0
          ParentFont = False
          ParentShowHint = False
          PopupMenu = Medialist_View_PopupMenu
          ShowHint = True
          StyleElements = [seClient, seBorder]
          TabOrder = 0
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoChangeScale]
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
          OnDragAllowed = VSTDragAllowed
          OnDragOver = LibraryCollectionTreeDragOver
          OnDragDrop = LibraryCollectionTreeDragDrop
          OnDrawHint = TitlesVSTDrawHint
          OnEditCancelled = VSTEditCancelled
          OnEdited = VSTEdited
          OnEditing = VSTEditing
          OnEndDrag = LibraryVSTEndDrag
          OnGetText = VSTGetText
          OnPaintText = VSTPaintText
          OnGetHintKind = TitlesVSTGetHintKind
          OnGetHintSize = TitlesVSTGetHintSize
          OnGetImageIndex = VSTGetImageIndex
          OnGetHint = TitlesVSTGetHint
          OnGetUserClipboardFormats = TreesGetUserClipboardFormats
          OnHeaderClick = VSTHeaderClick
          OnHeaderDblClick = VSTHeaderDblClick
          OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
          OnIncrementalSearch = VSTIncrementalSearch
          OnKeyDown = VSTKeyDown
          OnKeyUp = PlaylistVSTKeyUp
          OnNewText = VSTNewText
          OnRenderOLEData = TreesRenderOLEData
          OnStartDrag = VSTFilesStartDrag
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              Position = 0
              Text = 'Artist'
              Width = 69
            end
            item
              Position = 1
              Text = 'Title'
            end
            item
              Position = 2
              Text = 'Album'
            end
            item
              Position = 3
              Text = 'Track'
            end
            item
              Position = 4
              Text = 'CD'
            end
            item
              Position = 5
              Text = 'Year'
            end
            item
              Position = 6
              Text = 'Album-Artist'
            end
            item
              Position = 7
              Text = 'Composer'
            end
            item
              Position = 8
              Text = 'Duration'
            end
            item
              Position = 9
              Text = 'Genre'
            end
            item
              Position = 10
              Text = 'Comment'
            end
            item
              Position = 11
              Text = 'Bitrate'
            end
            item
              Position = 12
              Text = 'cbr/vbr'
            end
            item
              Position = 13
              Text = 'Channelmode'
            end
            item
              Position = 14
              Text = 'Samplerate'
            end
            item
              Position = 15
              Text = 'Type'
            end
            item
              Position = 16
              Text = 'Filename'
            end
            item
              Position = 17
              Text = 'Directory'
            end
            item
              Position = 18
              Text = 'Path'
            end
            item
              Position = 19
              Text = 'Filesize'
            end
            item
              Position = 20
              Text = 'File created'
            end
            item
              Position = 21
              Text = 'Rating'
            end
            item
              Position = 22
              Text = 'Play counter'
            end
            item
              Position = 23
              Text = 'Track gain'
            end
            item
              Position = 24
              Text = 'Album gain'
            end
            item
              Position = 25
              Text = 'Track peak'
            end
            item
              Position = 26
              Text = 'Album peak'
            end
            item
              Position = 27
              Text = 'BPM'
            end
            item
              Position = 28
              Text = 'Lyrics'
            end
            item
              Position = 29
              Text = 'Tags'
            end
            item
              Position = 30
              Text = 'Marker'
            end
            item
              Position = 31
              Text = 'Harmonic key'
            end>
        end
      end
    end
    object TreePanel: TNempPanel
      Tag = 2
      Left = 0
      Top = 10
      Width = 226
      Height = 219
      BevelOuter = bvNone
      TabOrder = 4
      OnMouseDown = TreePanelMouseDown
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OnPaintBackground = PanelPaintBackground
      OwnerDraw = False
      object AuswahlHeaderPanel0: TNempPanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 226
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentBackground = False
        ParentDoubleBuffered = False
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object AuswahlFillPanel0: TNempPanel
          Tag = 2
          AlignWithMargins = True
          Left = 121
          Top = 2
          Width = 105
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = True
          ParentDoubleBuffered = False
          PopupMenu = Medialist_Collection_PopupMenu
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object AuswahlStatusLBL0: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 71
            Height = 14
            Align = alClient
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
            ExplicitLeft = 2
            ExplicitTop = 4
            ExplicitWidth = 39
            ExplicitHeight = 16
          end
          object pnlSysBrowse: TNempPanel
            Tag = 2
            Left = 79
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnCloseBrowse: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object AuswahlControlPanel0: TNempPanel
          Tag = 2
          Left = 0
          Top = 0
          Width = 121
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object TabBtn_Browse0: TSkinButton
            Left = 30
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Treeview'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TABPanelAuswahlClick
            ImageIndex = 4
            ImageName = 'TabBtnBrowse'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_CoverFlow0: TSkinButton
            Tag = 1
            Left = 58
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Coverflow'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 2
            OnClick = TABPanelAuswahlClick
            ImageIndex = 7
            ImageName = 'TabBtnCoverflow'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Preselection0: TSkinButton
            Tag = 1
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = TabBtn_Preselection0Click
            ImageIndex = 17
            ImageName = 'TabBtnNemp'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_TagCloud0: TSkinButton
            Tag = 2
            Left = 86
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Tag cloud'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 3
            OnClick = TABPanelAuswahlClick
            ImageIndex = 18
            ImageName = 'TabBtnTagCloud'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
      object PanelStandardBrowse: TNempPanel
        Tag = 2
        Left = 0
        Top = 28
        Width = 226
        Height = 191
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object SplitterBrowse: TSplitter
          Left = 2
          Top = 81
          Width = 222
          Height = 4
          Cursor = crVSplit
          Align = alTop
          ResizeStyle = rsUpdate
          StyleElements = [seFont, seBorder]
          OnMoved = SplitterBrowseMoved
          ExplicitLeft = 4
          ExplicitTop = 75
          ExplicitWidth = 196
        end
        object ArtistsVST: TVirtualStringTree
          Tag = 1
          Left = 2
          Top = 2
          Width = 222
          Height = 79
          Align = alTop
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Constraints.MinWidth = 20
          DefaultNodeHeight = 14
          DragImageKind = diMainColumnOnly
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
          PopupMenu = Medialist_Category_PopupMenu
          ScrollBarOptions.ScrollBars = ssVertical
          StyleElements = [seClient, seBorder]
          TabOrder = 0
          TextMargin = 2
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoChangeScale]
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toEditOnClick]
          TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
          TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
          OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
          OnAfterItemErase = VSTAfterItemErase
          OnClick = ArtistsVSTClick
          OnDragAllowed = ArtistsVSTDragAllowed
          OnDragOver = CategoryVSTDragOver
          OnDragDrop = CategoryVSTDragDrop
          OnFocusChanged = ArtistsVSTFocusChanged
          OnGetText = StringVSTGetText
          OnPaintText = ArtistsVSTPaintText
          OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
          OnIncrementalSearch = ArtistsVSTIncrementalSearch
          OnResize = ArtistsVSTResize
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              MinWidth = 0
              Position = 0
              Width = 222
            end>
        end
        object AlbenVST: TVirtualStringTree
          Tag = 2
          Left = 2
          Top = 85
          Width = 222
          Height = 104
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Constraints.MinWidth = 20
          DragOperations = [doCopy]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.AutoSizeIndex = 0
          Header.Background = clWindow
          Header.Height = 21
          Header.Options = [hoAutoResize, hoDrag, hoVisible]
          Images = DummyImageList
          IncrementalSearch = isAll
          Indent = 14
          Margin = 0
          ParentFont = False
          PopupMenu = Medialist_Collection_PopupMenu
          ScrollBarOptions.ScrollBars = ssVertical
          StyleElements = [seClient, seBorder]
          TabOrder = 1
          TextMargin = 2
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toAutoChangeScale]
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toWheelPanning, toVariableNodeHeight, toEditOnClick]
          TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowRoot, toThemeAware, toUseBlendedImages, toUseBlendedSelection]
          TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
          OnAdvancedHeaderDraw = VSTAdvancedHeaderDraw
          OnAfterItemErase = VSTAfterItemErase
          OnClick = AlbenVSTClick
          OnColumnDblClick = AlbenVSTColumnDblClick
          OnDragAllowed = AlbenVSTDragAllowed
          OnDragOver = LibraryCollectionTreeDragOver
          OnDragDrop = LibraryCollectionTreeDragDrop
          OnDrawText = AlbenVSTDrawText
          OnEndDrag = LibraryVSTEndDrag
          OnFocusChanged = AlbenVSTFocusChanged
          OnGetText = AlbenVSTGetText
          OnPaintText = ArtistsVSTPaintText
          OnGetImageIndex = AlbenVSTGetImageIndex
          OnGetUserClipboardFormats = TreesGetUserClipboardFormats
          OnHeaderDrawQueryElements = VSTHeaderDrawQueryElements
          OnIncrementalSearch = AlbenVSTIncrementalSearch
          OnKeyDown = StringVSTKeyDown
          OnMeasureItem = AlbenVSTMeasureItem
          OnRenderOLEData = TreesRenderOLEData
          OnResize = AlbenVSTResize
          OnStartDrag = AlbenVSTStartDrag
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              MinWidth = 0
              Position = 0
              Width = 222
            end>
        end
      end
    end
    object CoverflowPanel: TNempPanel
      Tag = 2
      Left = 244
      Top = 10
      Width = 237
      Height = 230
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 5
      OnMouseDown = TreePanelMouseDown
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OnPaintBackground = PanelPaintBackground
      OwnerDraw = False
      object AuswahlHeaderPanel1: TNempPanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 237
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentBackground = False
        ParentDoubleBuffered = False
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OnPaintBackgroundEx = PanelPaintBackgroundEx
        OwnerDraw = False
        object AuswahlFillPanel1: TNempPanel
          Tag = 2
          AlignWithMargins = True
          Left = 121
          Top = 2
          Width = 116
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          DoubleBuffered = True
          ParentDoubleBuffered = False
          PopupMenu = Medialist_Collection_PopupMenu
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object AuswahlStatusLBL1: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 82
            Height = 14
            Align = alClient
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
            ExplicitLeft = 2
            ExplicitTop = 4
            ExplicitWidth = 55
            ExplicitHeight = 16
          end
          object pnlSysCoverflow: TNempPanel
            Tag = 2
            Left = 90
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnCloseCoverflow: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object AuswahlControlPanel1: TNempPanel
          Tag = 2
          Left = 0
          Top = 0
          Width = 121
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object TabBtn_Browse1: TSkinButton
            Left = 30
            Top = 3
            Width = 24
            Height = 24
            Hint = 'Treeview'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TABPanelAuswahlClick
            ImageIndex = 4
            ImageName = 'TabBtnBrowse'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_CoverFlow1: TSkinButton
            Tag = 1
            Left = 58
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Coverflow'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 2
            OnClick = TABPanelAuswahlClick
            ImageIndex = 7
            ImageName = 'TabBtnCoverflow'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Preselection1: TSkinButton
            Tag = 1
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = TabBtn_Preselection0Click
            ImageIndex = 17
            ImageName = 'TabBtnNemp'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_TagCloud1: TSkinButton
            Tag = 2
            Left = 86
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Tag cloud'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 3
            OnClick = TABPanelAuswahlClick
            ImageIndex = 18
            ImageName = 'TabBtnTagCloud'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
      object PanelCoverflowContainer: TNempPanel
        Tag = 2
        Left = 0
        Top = 28
        Width = 237
        Height = 202
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        DoubleBuffered = True
        ParentDoubleBuffered = False
        PopupMenu = Medialist_Collection_PopupMenu
        TabOrder = 1
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = True
        OnPaintBackground = PanelPaintBackground
        OnPaintBackgroundEx = PanelPaintBackgroundEx
        OwnerDraw = False
        object PanelCoverBrowse: TNempPanel
          Tag = 2
          AlignWithMargins = True
          Left = 6
          Top = 6
          Width = 225
          Height = 134
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alClient
          BevelOuter = bvNone
          DoubleBuffered = True
          ParentDoubleBuffered = False
          PopupMenu = Medialist_Collection_PopupMenu
          TabOrder = 0
          OnDblClick = PanelCoverBrowseDblClick
          OnMouseDown = PanelCoverBrowseMouseDown
          OnMouseMove = IMGMedienBibCoverMouseMove
          OnMouseUp = IMGMedienBibCoverMouseUp
          OnResize = PanelCoverBrowseResize
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OnPaintBackgroundEx = PanelPaintBackgroundEx
          OnAfterPaint = PanelCoverBrowseAfterPaint
          OwnerDraw = False
          OnMouseWheelUp = PanelCoverBrowseMouseWheelUp
          OnMouseWheelDown = PanelCoverBrowseMouseWheelDown
          object IMGMedienBibCover: TImage
            AlignWithMargins = True
            Left = 0
            Top = 4
            Width = 225
            Height = 77
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 4
            Align = alClient
            Center = True
            DragCursor = crDefault
            Proportional = True
            OnMouseDown = IMGMedienBibCoverMouseDown
            OnMouseMove = IMGMedienBibCoverMouseMove
            OnMouseUp = IMGMedienBibCoverMouseUp
            ExplicitLeft = 1
            ExplicitTop = 6
            ExplicitWidth = 252
            ExplicitHeight = 25
          end
          object ImgScrollCover: TImage
            AlignWithMargins = True
            Left = 0
            Top = 89
            Width = 225
            Height = 41
            Margins.Left = 0
            Margins.Top = 4
            Margins.Right = 0
            Margins.Bottom = 4
            Align = alBottom
            Transparent = True
            OnMouseDown = ImgScrollCoverMouseDown
            ExplicitTop = 88
            ExplicitWidth = 255
          end
        end
        object CoverScrollbar: TScrollBar
          AlignWithMargins = True
          Left = 6
          Top = 179
          Width = 225
          Height = 17
          Margins.Left = 4
          Margins.Top = 0
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alBottom
          LargeChange = 3
          Max = 3
          PageSize = 3
          TabOrder = 1
          OnChange = CoverScrollbarChange
          OnEnter = CoverScrollbarEnter
          OnKeyDown = CoverScrollbarKeyDown
        end
        object Pnl_CoverFlowLabel: TNempPanel
          Tag = 2
          AlignWithMargins = True
          Left = 6
          Top = 144
          Width = 225
          Height = 33
          Margins.Left = 4
          Margins.Top = 0
          Margins.Right = 4
          Margins.Bottom = 2
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'Pnl_CoverFlowLabel'
          DoubleBuffered = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindow
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentDoubleBuffered = False
          ParentFont = False
          ShowCaption = False
          TabOrder = 2
          OnMouseDown = Lbl_CoverFlowMouseDown
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          DesignSize = (
            225
            33)
          object Lbl_CoverFlow: TLabel
            Left = 38
            Top = 10
            Width = 187
            Height = 13
            Alignment = taCenter
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            ShowAccelChar = False
            Transparent = True
            StyleElements = [seClient, seBorder]
            OnMouseDown = Lbl_CoverFlowMouseDown
            ExplicitWidth = 62
          end
          object TabBtnCoverCategory: TSkinButton
            Tag = 1
            Left = 8
            Top = 5
            Width = 24
            Height = 24
            Hint = 'Select category'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Browse_Categories_PopupMenu
            ShowHint = True
            TabOrder = 0
            TabStop = False
            OnClick = TabBtnCoverCategoryClick
            ImageIndex = 5
            ImageName = 'TabBtnCategory'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
    end
    object CloudPanel: TNempPanel
      Tag = 2
      Left = 500
      Top = 10
      Width = 292
      Height = 217
      BevelOuter = bvNone
      TabOrder = 6
      OnMouseDown = TreePanelMouseDown
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      BackgroundBasePanel = True
      OwnerDraw = False
      object AuswahlHeaderPanel2: TNempPanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 292
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = False
        OnPaintBackground = PanelPaintBackground
        OwnerDraw = False
        object AuswahlFillPanel2: TNempPanel
          Tag = 2
          AlignWithMargins = True
          Left = 200
          Top = 2
          Width = 92
          Height = 24
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 0
          Margins.Bottom = 2
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          PopupMenu = Medialist_Collection_PopupMenu
          TabOrder = 0
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = True
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object AuswahlStatusLBL2: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 5
            Width = 58
            Height = 14
            Align = alClient
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
            ExplicitLeft = 3
            ExplicitTop = 0
            ExplicitWidth = 39
            ExplicitHeight = 20
          end
          object pnlSysCloud: TNempPanel
            Tag = 2
            Left = 66
            Top = 2
            Width = 24
            Height = 20
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 0
            Ratio = 0
            DrawMode = dm_Windows
            DrawFrame = False
            OnPaintBackground = PanelPaintBackground
            OwnerDraw = False
            object BtnCloseCloud: TSkinButton
              AlignWithMargins = True
              Left = 4
              Top = 2
              Width = 16
              Height = 16
              Margins.Left = 0
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              Action = ActionCloseSubForm
              DoubleBuffered = True
              DrawMode = dm_Skin
              Images = vilIconsWindows
              ParentDoubleBuffered = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              TabStop = False
              StyleElements = [seFont, seBorder]
              ImageIndex = 62
              ImageName = 'SysBtnCloseForm'
              BackgroundIndex = 55
              BackgroundIndexHighlight = 54
              BackgroundIndexPressed = 53
              BackgroundIndexDisabled = 52
              BackgroundName = 'ToolBtnBGNormal'
              BackgroundNameHighlight = 'ToolBtnBGHighlight'
              BackgroundNamePressed = 'ToolBtnBGDown'
              BackgroundNameDisabled = 'ToolBtnBGDisabled'
            end
          end
        end
        object AuswahlControlPanel2: TNempPanel
          Tag = 2
          Left = 0
          Top = 0
          Width = 200
          Height = 28
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 1
          Ratio = 0
          DrawMode = dm_Windows
          DrawFrame = False
          OnPaintBackground = PanelPaintBackground
          OwnerDraw = False
          object edtCloudSearch: TEdit
            Left = 116
            Top = 3
            Width = 81
            Height = 21
            AutoSize = False
            TabOrder = 4
            TextHint = 'Search (Tags)'
            OnChange = ssdedtCloudSearchChange
            OnKeyPress = ssdedtCloudSearchKeyPress
          end
          object TabBtn_Browse2: TSkinButton
            Left = 30
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Treeview'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 1
            OnClick = TABPanelAuswahlClick
            ImageIndex = 4
            ImageName = 'TabBtnBrowse'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_CoverFlow2: TSkinButton
            Tag = 1
            Left = 58
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Coverflow'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 2
            OnClick = TABPanelAuswahlClick
            ImageIndex = 7
            ImageName = 'TabBtnCoverflow'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_Preselection2: TSkinButton
            Tag = 1
            Left = 2
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Show context menu'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 0
            OnClick = TabBtn_Preselection0Click
            ImageIndex = 17
            ImageName = 'TabBtnNemp'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
          object TabBtn_TagCloud2: TSkinButton
            Tag = 2
            Left = 86
            Top = 2
            Width = 24
            Height = 24
            Hint = 'Tag cloud'
            DoubleBuffered = True
            DrawMode = dm_Windows
            Images = viTabButtons
            ParentDoubleBuffered = False
            ParentShowHint = False
            PopupMenu = Medialist_Collection_PopupMenu
            ShowHint = True
            TabOrder = 3
            OnClick = TABPanelAuswahlClick
            ImageIndex = 18
            ImageName = 'TabBtnTagCloud'
            BackgroundIndex = 0
            BackgroundIndexHighlight = 1
            BackgroundIndexPressed = 2
            BackgroundIndexDisabled = 3
            BackgroundName = 'TabBtnBGNormal'
            BackgroundNameHighlight = 'TabBtnBGHighlight'
            BackgroundNamePressed = 'TabBtnBGDown'
            BackgroundNameDisabled = 'TabBtnBGDisabled'
          end
        end
      end
      object PanelTagCloudBrowse: TNempPanel
        Tag = 2
        Left = 0
        Top = 28
        Width = 292
        Height = 189
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 1
        OnClick = PanelTagCloudBrowseClick
        OnMouseDown = PanelTagCloudBrowseMouseDown
        OnResize = PanelTagCloudBrowseResize
        Ratio = 0
        DrawMode = dm_Windows
        DrawFrame = True
        OnPaintBackground = PanelPaintBackground
        OnPaintBackgroundEx = PanelPaintBackgroundEx
        OnAfterPaint = PanelTagCloudBrowseAfterPaint
        OwnerDraw = False
        object TabBtnTagCloudCategory: TSkinButton
          Tag = 1
          Left = 16
          Top = 13
          Width = 24
          Height = 24
          Hint = 'Select category'
          DoubleBuffered = True
          DrawMode = dm_Windows
          Images = viTabButtons
          ParentDoubleBuffered = False
          ParentShowHint = False
          PopupMenu = Medialist_Browse_Categories_PopupMenu
          ShowHint = True
          TabOrder = 0
          TabStop = False
          OnClick = TabBtnCoverCategoryClick
          ImageIndex = 5
          ImageName = 'TabBtnCategory'
          BackgroundIndex = 0
          BackgroundIndexHighlight = 1
          BackgroundIndexPressed = 2
          BackgroundIndexDisabled = 3
          BackgroundName = 'TabBtnBGNormal'
          BackgroundNameHighlight = 'TabBtnBGHighlight'
          BackgroundNamePressed = 'TabBtnBGDown'
          BackgroundNameDisabled = 'TabBtnBGDisabled'
        end
      end
    end
    object EmptyLibraryPanel: TNempPanel
      Tag = 2
      Left = 676
      Top = 112
      Width = 185
      Height = 92
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 7
      OnResize = EmptyLibraryPanelResize
      Ratio = 0
      DrawMode = dm_Windows
      DrawFrame = False
      OnPaintBackground = PanelPaintBackground
      OwnerDraw = False
      object LblEmptyLibraryHint: TLabel
        Left = 56
        Top = 9
        Width = 161
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
    end
  end
  object BassTimer: TTimer
    Enabled = False
    Interval = 20
    OnTimer = BassTimerTimer
    Left = 424
    Top = 456
  end
  object Nemp_MainMenu: TMainMenu
    AutoHotkeys = maManual
    Images = vilIconsWindows
    Left = 72
    Top = 72
    object MM_Medialibrary: TMenuItem
      Caption = '&Media library'
      OnClick = MM_MedialibraryClick
      object MM_ML_SearchDirectory: TMenuItem
        Action = ActionLibraryAddDirectory
      end
      object MM_ML_SearchDirectoryCurrentCategory: TMenuItem
        Action = ActionLibraryAddDirectoryCurrentCategory
      end
      object MM_ML_Webradio: TMenuItem
        Action = ActionManageWebradio
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object MM_ML_Search: TMenuItem
        Action = ActionSearchLibrary
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object MM_ML_Load: TMenuItem
        Action = ActionLoadLibrary
      end
      object MM_ML_Save: TMenuItem
        Action = ActionSaveLibrary
      end
      object MM_ML_ExportAsCSV: TMenuItem
        Action = ActionExportLibrary
      end
      object MM_ML_Delete: TMenuItem
        Action = ActionDeleteLibrary
      end
      object N71: TMenuItem
        Caption = '-'
      end
      object MM_ML_RefreshAll: TMenuItem
        Action = ActionLibraryRefreshAll
      end
      object MM_ML_RefreshPlaylists: TMenuItem
        Action = ActionLibraryRefreshPlaylists
      end
      object MM_ML_DeleteMissingFiles: TMenuItem
        Action = ActionLibraryCleanup
      end
      object MM_T_CloudEditor: TMenuItem
        Action = ActionLibraryTagCloudEditor
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object MM_ML_CloseNemp: TMenuItem
        Action = ActionCloseNemp
      end
    end
    object MM_Playlist: TMenuItem
      Caption = '&Playlist'
      OnClick = MM_PlaylistClick
      object MM_PL_Files: TMenuItem
        Action = ActionPlaylistAddFiles
      end
      object MM_PL_Directory: TMenuItem
        Action = ActionPlaylistAddDirectory
      end
      object AddCDAudio1: TMenuItem
        Action = ActionPlaylistAddCDAudio
      end
      object MM_PL_WebStream: TMenuItem
        Action = ActionPlaylistAddWebradio
      end
      object MM_PL_SortBy: TMenuItem
        Caption = 'Sort &by'
        ImageIndex = 27
        ImageName = 'MenuSort'
        object MM_PL_SortByFilename: TMenuItem
          Tag = 1
          Action = ActionPlaylistSort
          Caption = 'Filename'
        end
        object MM_PL_SortByArtist: TMenuItem
          Tag = 2
          Action = ActionPlaylistSort
          Caption = 'Artist'
        end
        object MM_PL_SortByTitle: TMenuItem
          Tag = 3
          Action = ActionPlaylistSort
          Caption = 'Title'
        end
        object MM_PL_SortByAlbumTrack: TMenuItem
          Tag = 4
          Action = ActionPlaylistSort
          Caption = 'A&lbum, Tracknr.'
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object MM_PL_SortByInverse: TMenuItem
          Tag = 5
          Action = ActionPlaylistSort
          Caption = '&Inverse'
        end
        object MM_PL_SortByMix: TMenuItem
          Tag = 6
          Action = ActionPlaylistSort
          Caption = '&Mix'
        end
      end
      object N69: TMenuItem
        Caption = '-'
      end
      object MM_PL_GenerateRandomPlaylist: TMenuItem
        Action = ActionPlaylistGenerateRandom
      end
      object MM_PL_Load: TMenuItem
        Action = ActionPlaylistLoad
      end
      object MM_PL_AddPlaylist: TMenuItem
        Action = ActionPlaylistAddPlaylist
      end
      object MM_PL_RecentPlaylists: TMenuItem
        Caption = '&Recent playlists'
      end
      object MM_PL_Save: TMenuItem
        Action = ActionPlaylistSave
      end
      object MM_PL_SaveAsPlaylist: TMenuItem
        Action = ActionPlaylistSaveAs
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object MM_PL_ExtendedScanFiles: TMenuItem
        Action = ActionPlaylistRefresh
      end
      object MM_PL_DeleteMissingFiles: TMenuItem
        Action = ActionPlaylistCleanup
      end
      object MM_PL_ClearPlaylist: TMenuItem
        Action = ActionPlaylistClear
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object MM_PL_ExtendedAddToMedialibrary: TMenuItem
        Action = ActionPlaylistAddFilesToLibrary
      end
      object MM_PL_CopyPlaylistToUSB: TMenuItem
        Action = ActionPlaylistCopyFilesToUSB
      end
    end
    object MM_Options: TMenuItem
      Caption = '&Settings'
      OnClick = MM_OptionsClick
      object MM_O_Preferences: TMenuItem
        Caption = '&Preferences'
        ImageIndex = 24
        ImageName = 'MenuSettings'
        OnClick = MM_O_PreferencesClick
      end
      object MM_ML_ConfigureMediaLibrary: TMenuItem
        Caption = 'Configure Media library'
        OnClick = PM_ML_ConfigureMedialibraryClick
      end
      object MM_O_Wizard: TMenuItem
        Caption = 'Wizard'
        ImageIndex = 35
        ImageName = 'MenuWizard'
        OnClick = MM_O_WizardClick
      end
      object MM_O_Languages: TMenuItem
        Caption = 'Languages'
        object MM_O_Defaultlanguage: TMenuItem
          Tag = -1
          Caption = 'English'
          OnClick = ChangeLanguage
        end
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object MM_O_FormBuilder: TMenuItem
        Caption = 'Form designer'
        OnClick = MM_O_FormBuilderClick
      end
      object MM_O_View: TMenuItem
        Caption = '&View'
        OnClick = PM_P_ViewClick
        object MM_O_JoinWindows: TMenuItem
          Action = actJoinWindows
        end
        object MM_O_SplitWindows: TMenuItem
          Tag = 1
          Action = actSplitWindows
        end
        object N29: TMenuItem
          Caption = '-'
        end
        object MM_O_SplitToggle_Playlist: TMenuItem
          Action = actTogglePlaylist
          ShortCut = 24656
        end
        object MM_O_CompactToggleBrowselist: TMenuItem
          Action = actToggleBrowseList
          ShortCut = 24642
        end
        object MM_O_CompactToggleTitleList: TMenuItem
          Action = actToggleTitleList
          ShortCut = 24660
        end
        object MM_O_CompactToggleFileOverview: TMenuItem
          Action = actToggleFileOverview
          ShortCut = 24644
        end
        object MM_O_ToggleStayOnTop: TMenuItem
          Action = actToggleStayOnTop
        end
        object N40: TMenuItem
          Caption = '-'
        end
        object MM_O_ShowCategorySelection: TMenuItem
          Action = actToggleShowCategorySelection
        end
        object Showcoverinconrtolpanel1: TMenuItem
          Action = actShowControlCover
        end
        object MM_O_Treeview: TMenuItem
          Caption = 'Treeview'
          object MM_O_TreeviewStacked: TMenuItem
            Action = actTreeviewStacked
          end
          object MM_O_TreeviewSideBySide: TMenuItem
            Action = actTreeViewSideBySide
          end
        end
        object MM_O_Overview: TMenuItem
          Caption = 'File overview'
          object MM_O_OverviewCoverAndDetails: TMenuItem
            Action = actFileOverviewBoth
          end
          object MM_O_OverviewOnlyCover: TMenuItem
            Action = actFileOverviewOnlyCover
          end
          object MM_O_OverviewOnlyDetails: TMenuItem
            Action = actFileOverviewOnlyDetails
          end
          object N39: TMenuItem
            Caption = '-'
          end
          object MM_O_OverviewStacked: TMenuItem
            Action = actFileOverviewStacked
          end
          object MM_O_OverviewSideBySide: TMenuItem
            Action = actFileOverviewSideBySide
          end
        end
      end
      object MM_O_Skins: TMenuItem
        Caption = '&Skins'
        ImageIndex = 26
        ImageName = 'MenuSkins'
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
        ImageIndex = 25
        ImageName = 'MenuShutdown'
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
        ImageName = 'MenuBirthday'
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
        ImageIndex = 31
        ImageName = 'MenuStream'
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
        ImageIndex = 11
        ImageName = 'MenuLastFM'
        object MM_T_ScrobblerActivate: TMenuItem
          Caption = 'Activate'
          OnClick = PM_P_ScrobblerActivateClick
        end
        object MM_T_ScrobblerOptions: TMenuItem
          Caption = 'Settings'
          OnClick = PM_P_ScrobblerOptionsClick
        end
      end
      object MM_T_Plugins: TMenuItem
        Caption = 'Winamp DSP Plugins'
        ImageIndex = 34
        ImageName = 'Menuwinamp'
        Visible = False
        OnClick = MM_T_PluginsClick
        object N43: TMenuItem
          Caption = '-'
        end
        object MM_T_PluginConfigure: TMenuItem
          Caption = 'Configure current plugin'
          OnClick = MM_T_PluginConfigureClick
        end
        object MM_T_PluginStop: TMenuItem
          Caption = 'Stop current plugin'
          OnClick = MM_T_PluginStopClick
        end
        object MM_T_PluginOpenFolder: TMenuItem
          Caption = 'Open plugin directory'
          OnClick = MM_T_PluginOpenFolderClick
        end
      end
      object MM_T_KeyboardDisplay: TMenuItem
        Caption = 'Keyboard display'
        ImageIndex = 10
        ImageName = 'MenuKeyboard'
        OnClick = PM_P_KeyboardDisplayClick
      end
      object MM_T_EqualizerEffects: TMenuItem
        Caption = 'Equalizer && Effects'
        ImageIndex = 7
        ImageName = 'MenuEffects'
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
        object MM_T_DirectoriesProgram: TMenuItem
          Caption = 'Program directory'
          OnClick = MM_T_DirectoriesProgramClick
        end
      end
      object MM_T_PlaylistLog: TMenuItem
        Caption = 'Playlist log'
        OnClick = MM_T_PlaylistLogClick
      end
    end
    object MM_Help: TMenuItem
      Caption = '&Help'
      OnClick = MM_HelpClick
      object MM_H_About: TMenuItem
        Caption = '&About Nemp'
        ImageIndex = 17
        ImageName = 'MenuNempLogo'
        OnClick = MM_H_AboutClick
      end
      object MM_H_Help: TMenuItem
        Caption = 'Help'
        ImageIndex = 9
        ImageName = 'MenuHelp'
        OnClick = ToolButton7Click
      end
      object MM_H_HelpOnline: TMenuItem
        Caption = 'Online help'
        OnClick = MM_H_HelpOnlineClick
      end
      object MM_H_CheckForUpdates: TMenuItem
        Caption = 'Check for updates'
        ImageIndex = 48
        ImageName = 'MenuNempUpdate'
        OnClick = MM_H_CheckForUpdatesClick
      end
      object MM_H_CleanupUpdate: TMenuItem
        Caption = 'Clean up update'
        OnClick = MM_H_CleanupUpdateClick
      end
    end
    object MM_H_ErrorLog: TMenuItem
      Caption = 'Messages'
      ImageIndex = 33
      ImageName = 'MenuWarning'
      Visible = False
      OnClick = MM_H_ErrorLogClick
    end
    object MM_Warning_ID3Tags: TMenuItem
      Caption = 'Warning'
      ImageIndex = 33
      ImageName = 'MenuWarning'
      Visible = False
      OnClick = MM_Warning_ID3TagsClick
    end
  end
  object AutoSavePlaylistTimer: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = AutoSavePlaylistTimerTimer
    Left = 848
    Top = 56
  end
  object SleepTimer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = SleepTimerTimer
    Left = 32
    Top = 448
  end
  object BirthdayTimer: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = BirthdayTimerTimer
    Left = 104
    Top = 448
  end
  object PlayListOpenDialog: TOpenDialog
    Filter = 
      'All supported files|*.m3u;*.m3u8;*.pls;*.npl;*.asx;*.wax|m3u-lis' +
      'ts|*.m3u|m3u8-lists (unicode-capable)|*.m3u8|pls-lists|*.pls|Nem' +
      'p playlists|*.npl|WindowsMedia|*.asx;*.wax'
    Left = 1015
    Top = 8
  end
  object PlaylistDateienOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 784
    Top = 8
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
    Left = 909
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'gmp'
    Filter = 'Nemp medialibrary (*.gmp)|*.gmp'
    FilterIndex = 0
    Left = 112
    Top = 312
  end
  object Medialist_View_PopupMenu: TPopupMenu
    Images = vilIconsWindows
    OnPopup = Medialist_View_PopupMenuPopup
    Left = 72
    Top = 224
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
    object PM_ML_ApplyDefaultActionToWholeList: TMenuItem
      Caption = 'Add all displayed titles'
      OnClick = PM_ML_ApplyDefaultActionToWholeListClick
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object PM_ML_PlayNow: TMenuItem
      Tag = 3
      Caption = 'Just play focussed file (don'#39't change the playlist)'
      OnClick = PM_ML_FilesPlayNowClick
    end
    object PM_ML_PlayHeadset: TMenuItem
      Action = ActionLibraryPlayInHeadset
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PM_ML_SortBy: TMenuItem
      Caption = 'Sort by'
      ImageIndex = 27
      ImageName = 'MenuSort'
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
        Tag = 16
        Caption = 'Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortPathFilename: TMenuItem
        Tag = 18
        Caption = 'Path && Filename'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortLyricsexists: TMenuItem
        Tag = 28
        Caption = 'Lyrics exists'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortGenre: TMenuItem
        Tag = 9
        Caption = 'Genre'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N7: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortDuration: TMenuItem
        Tag = 8
        Caption = 'Duration'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_SortFilesize: TMenuItem
        Tag = 19
        Caption = 'Filesize'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object PM_ML_bpm: TMenuItem
        Tag = 27
        Caption = 'BPM (Beats per minute)'
        GroupIndex = 1
        OnClick = AnzeigeSortMENUClick
      end
      object N4: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object PM_ML_SortAscending: TMenuItem
        Caption = 'Ascending'
        Checked = True
        GroupIndex = 1
        OnClick = MM_ML_SortAscendingClick
      end
      object PM_ML_SortDescending: TMenuItem
        Tag = 1
        Caption = 'Descending'
        GroupIndex = 1
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
      ShortCut = 16430
      OnClick = PM_ML_DeleteSelectedClick
    end
    object PM_MLView_ChangeCategory: TMenuItem
      Caption = 'Change category of selected files'
      OnClick = PM_MLView_ChangeCategoryClick
    end
    object PM_MLView_RemoveFromCategory: TMenuItem
      Caption = 'Remove selected files from current category'
      OnClick = PM_MLView_RemoveFromCategoryClick
    end
    object N72: TMenuItem
      Caption = '-'
    end
    object PM_ML_SetRatingsOfSelectedFilesCHOOSE: TMenuItem
      Caption = 'Set rating of selected files to'
      ImageIndex = 29
      ImageName = 'MenuStarFull'
      object PM_ML_SetRatingsOfSelectedFiles1: TMenuItem
        Tag = 100
        Action = ActionFilesSetRating
        Caption = '0.5 stars'
        ImageIndex = 28
        ImageName = 'MenuStarEmpty'
      end
      object PM_ML_SetRatingsOfSelectedFiles2: TMenuItem
        Tag = 101
        Action = ActionFilesSetRating
        Caption = '1 star'
        ShortCut = 16433
      end
      object PM_ML_SetRatingsOfSelectedFiles3: TMenuItem
        Tag = 102
        Action = ActionFilesSetRating
        Caption = '1.5 stars'
      end
      object PM_ML_SetRatingsOfSelectedFiles4: TMenuItem
        Tag = 103
        Action = ActionFilesSetRating
        Caption = '2 stars'
        ShortCut = 16434
      end
      object PM_ML_SetRatingsOfSelectedFiles5: TMenuItem
        Tag = 104
        Action = ActionFilesSetRating
        Caption = '2.5 stars'
        ImageIndex = 30
        ImageName = 'MenuStarHalf'
      end
      object PM_ML_SetRatingsOfSelectedFiles6: TMenuItem
        Tag = 105
        Action = ActionFilesSetRating
        Caption = '3 stars'
        ShortCut = 16435
      end
      object PM_ML_SetRatingsOfSelectedFiles7: TMenuItem
        Tag = 106
        Action = ActionFilesSetRating
        Caption = '3.5 stars'
      end
      object PM_ML_SetRatingsOfSelectedFiles8: TMenuItem
        Tag = 107
        Action = ActionFilesSetRating
        Caption = '4 stars'
        ShortCut = 16436
      end
      object PM_ML_SetRatingsOfSelectedFiles9: TMenuItem
        Tag = 108
        Action = ActionFilesSetRating
        Caption = '4.5 stars'
      end
      object PM_ML_SetRatingsOfSelectedFiles10: TMenuItem
        Tag = 109
        Action = ActionFilesSetRating
        Caption = '5 stars'
        ImageIndex = 29
        ImageName = 'MenuStarFull'
        ShortCut = 16437
      end
      object N73: TMenuItem
        Caption = '-'
      end
      object PM_ML_ResetRating: TMenuItem
        Tag = 110
        Action = ActionFilesSetRating
        Caption = 'Reset rating/playcounter'
        ImageIndex = 30
        ImageName = 'MenuStarHalf'
        ShortCut = 16432
      end
    end
    object PM_ML_MarkFile: TMenuItem
      Tag = 150
      Caption = 'Flag selected files with'
      ImageIndex = 12
      ImageName = 'MenuMarkAll'
      object PM_ML_Mark1: TMenuItem
        Tag = 101
        Action = ActionFilesSetFlag
        Caption = 'Mark 1'
        ImageIndex = 14
        ImageName = 'MenuMarkBlue'
        ShortCut = 24625
      end
      object PM_ML_Mark2: TMenuItem
        Tag = 102
        Action = ActionFilesSetFlag
        Caption = 'Mark 2'
        ImageIndex = 16
        ImageName = 'MenuMarkRed'
        ShortCut = 24626
      end
      object PM_ML_Mark3: TMenuItem
        Tag = 103
        Action = ActionFilesSetFlag
        Caption = 'Mark 3'
        ImageIndex = 15
        ImageName = 'MenuMarkGreen'
        ShortCut = 24627
      end
      object N81: TMenuItem
        Caption = '-'
      end
      object PM_ML_Mark0: TMenuItem
        Tag = 100
        Action = ActionFilesSetFlag
        Caption = 'Unmarked'
        ImageIndex = 13
        ImageName = 'MenuMarkBlack'
        ShortCut = 24661
      end
    end
    object PM_ML_GetTags: TMenuItem
      Caption = 'Get additional tags for selected files'
      ImageIndex = 11
      ImageName = 'MenuLastFM'
      ShortCut = 16468
      OnClick = PM_ML_GetTagsClick
    end
    object PM_ML_RefreshSelected: TMenuItem
      Action = ActionLibraryRefreshSelected
    end
    object PM_ML_ReplayGain: TMenuItem
      Caption = 'ReplayGain'
      ImageIndex = 21
      ImageName = 'MenuReplayGain'
      object PM_ML_ReplayGain_SingleTracks: TMenuItem
        Tag = 100
        Action = ActionFilesCalculateReplayGain
        Caption = 'Single tracks'
      end
      object PM_ML_ReplayGain_OneAlbum: TMenuItem
        Tag = 101
        Action = ActionFilesCalculateReplayGain
        Caption = 'As one album'
      end
      object PM_ML_ReplayGain_MultiAlbum: TMenuItem
        Tag = 102
        Action = ActionFilesCalculateReplayGain
        Caption = 'Multiple albums (by tags)'
      end
      object PM_ML_ReplayGain_Clear: TMenuItem
        Tag = 103
        Action = ActionFilesCalculateReplayGain
        Caption = 'Clear ReplayGain'
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object PM_ML_CopyToClipboard: TMenuItem
      Tag = 100
      Action = ActionFilesCopyToClipboard
    end
    object PM_ML_MagicCopyToClipboard: TMenuItem
      Tag = 101
      Action = ActionFilesCopyToClipboard
      Caption = '... and include a proper playlist-file'
      ShortCut = 24643
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
      Tag = 101
      Action = ActionFileShowInExplorer
    end
    object PM_ML_Properties: TMenuItem
      Tag = 101
      Action = ActionFileShowDetails
    end
  end
  object PlayListPOPUP: TPopupMenu
    Images = vilIconsWindows
    OnPopup = PlayListPOPUPPopup
    Left = 520
    Top = 128
    object PM_PL_AddFiles: TMenuItem
      Action = ActionPlaylistAddFiles
    end
    object PM_PL_AddDirectories: TMenuItem
      Action = ActionPlaylistAddDirectory
    end
    object PM_PL_AddCDAudio: TMenuItem
      Action = ActionPlaylistAddCDAudio
    end
    object PM_PL_AddWebstream: TMenuItem
      Action = ActionPlaylistAddWebradio
    end
    object PM_PL_SortBy: TMenuItem
      Caption = 'Sort by'
      ImageIndex = 27
      ImageName = 'MenuSort'
      object PM_PL_SortByFilename: TMenuItem
        Tag = 1
        Action = ActionPlaylistSort
        Caption = 'Filename'
      end
      object PM_PL_SortByArtist: TMenuItem
        Tag = 2
        Action = ActionPlaylistSort
        Caption = 'Artist'
      end
      object PM_PL_SortByTitle: TMenuItem
        Tag = 3
        Action = ActionPlaylistSort
        Caption = 'Title'
      end
      object PM_PL_SortByAlbumTrack: TMenuItem
        Tag = 4
        Action = ActionPlaylistSort
        Caption = 'Album, Tracknr.'
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object PM_PL_SortByInverse: TMenuItem
        Tag = 5
        Action = ActionPlaylistSort
        Caption = 'Inverse'
      end
      object PM_PL_SortByMix: TMenuItem
        Tag = 6
        Action = ActionPlaylistSort
        Caption = 'Mix'
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
      Action = ActionPlaylistGenerateRandom
    end
    object PM_PL_LoadPlaylist: TMenuItem
      Action = ActionPlaylistLoad
    end
    object PM_PL_AddPlaylist: TMenuItem
      Action = ActionPlaylistAddPlaylist
    end
    object PM_PL_RecentPlaylists: TMenuItem
      Caption = 'Recent playlists'
    end
    object PM_PL_SavePlaylist: TMenuItem
      Action = ActionPlaylistSave
    end
    object PM_PL_SaveAsPlaylist: TMenuItem
      Action = ActionPlaylistSaveAs
    end
    object N12: TMenuItem
      Caption = '-'
    end
    object PM_PL_ClearPlaylist: TMenuItem
      Action = ActionPlaylistClear
    end
    object PM_PL_DeleteSelected: TMenuItem
      Action = ActionPlaylistRemoveSelected
    end
    object PM_PL_DeleteMissingFiles: TMenuItem
      Action = ActionPlaylistCleanup
    end
    object PM_PL_ScanForDuplicates: TMenuItem
      Action = ActionPlaylistScanForDuplicates
    end
    object PM_PL_SetRatingofSelectedFilesTo: TMenuItem
      Caption = 'Set rating of selected files to'
      ImageIndex = 29
      ImageName = 'MenuStarFull'
      object PM_PL_SetRatingsOfSelectedFiles1: TMenuItem
        Action = ActionFilesSetRating
        Caption = '0.5 stars'
        ImageIndex = 28
        ImageName = 'MenuStarEmpty'
      end
      object PM_PL_SetRatingsOfSelectedFiles2: TMenuItem
        Tag = 1
        Action = ActionFilesSetRating
        Caption = '1 star'
        ShortCut = 16433
      end
      object PM_PL_SetRatingsOfSelectedFiles3: TMenuItem
        Tag = 2
        Action = ActionFilesSetRating
        Caption = '1.5 stars'
      end
      object PM_PL_SetRatingsOfSelectedFiles4: TMenuItem
        Tag = 3
        Action = ActionFilesSetRating
        Caption = '2 stars'
        ShortCut = 16434
      end
      object PM_PL_SetRatingsOfSelectedFiles5: TMenuItem
        Tag = 4
        Action = ActionFilesSetRating
        Caption = '2.5 stars'
        ImageIndex = 30
        ImageName = 'MenuStarHalf'
      end
      object PM_PL_SetRatingsOfSelectedFiles6: TMenuItem
        Tag = 5
        Action = ActionFilesSetRating
        Caption = '3 stars'
        ShortCut = 16435
      end
      object PM_PL_SetRatingsOfSelectedFiles7: TMenuItem
        Tag = 6
        Action = ActionFilesSetRating
        Caption = '3.5 stars'
      end
      object PM_PL_SetRatingsOfSelectedFiles8: TMenuItem
        Tag = 7
        Action = ActionFilesSetRating
        Caption = '4 stars'
        ShortCut = 16436
      end
      object PM_PL_SetRatingsOfSelectedFiles9: TMenuItem
        Tag = 8
        Action = ActionFilesSetRating
        Caption = '4.5 stars'
      end
      object PM_PL_SetRatingsOfSelectedFiles10: TMenuItem
        Tag = 9
        Action = ActionFilesSetRating
        Caption = '5 stars'
        ImageIndex = 29
        ImageName = 'MenuStarFull'
        ShortCut = 16437
      end
      object N75: TMenuItem
        Caption = '-'
      end
      object PM_PL_ResetRating: TMenuItem
        Tag = 10
        Action = ActionFilesSetRating
        Caption = 'Reset rating/playcounter'
        ImageIndex = 30
        ImageName = 'MenuStarHalf'
        ShortCut = 16432
      end
    end
    object PM_PL_MarkFiles: TMenuItem
      Tag = 150
      Caption = 'Flag selected files with'
      ImageIndex = 12
      ImageName = 'MenuMarkAll'
      object PM_PL_Mark1: TMenuItem
        Tag = 1
        Action = ActionFilesSetFlag
        Caption = 'Mark 1'
        ImageIndex = 14
        ImageName = 'MenuMarkBlue'
      end
      object PM_PL_Mark2: TMenuItem
        Tag = 2
        Action = ActionFilesSetFlag
        Caption = 'Mark 2'
        ImageIndex = 16
        ImageName = 'MenuMarkRed'
      end
      object PM_PL_Mark3: TMenuItem
        Tag = 3
        Action = ActionFilesSetFlag
        Caption = 'Mark 3'
        ImageIndex = 15
        ImageName = 'MenuMarkGreen'
      end
      object N86: TMenuItem
        Caption = '-'
      end
      object PM_PL_Mark0: TMenuItem
        Action = ActionFilesSetFlag
        Caption = 'Unmarked'
        ImageIndex = 13
        ImageName = 'MenuMarkBlack'
      end
    end
    object PM_PL_ReplayGain: TMenuItem
      Caption = 'ReplayGain (selected files)'
      ImageIndex = 21
      ImageName = 'MenuReplayGain'
      object PM_PL_ReplayGain_SingleTracks: TMenuItem
        Action = ActionFilesCalculateReplayGain
        Caption = 'Single tracks'
      end
      object PM_PL_ReplayGain_OneAlbum: TMenuItem
        Tag = 1
        Action = ActionFilesCalculateReplayGain
        Caption = 'As one album'
      end
      object PM_PL_ReplayGain_MultiAlbums: TMenuItem
        Tag = 2
        Action = ActionFilesCalculateReplayGain
        Caption = 'Multiple albums (by tags)'
      end
      object PM_PL_ReplayGain_Clear: TMenuItem
        Tag = 3
        Action = ActionFilesCalculateReplayGain
        Caption = 'Clear ReplayGain'
      end
    end
    object N48: TMenuItem
      Caption = '-'
    end
    object PM_PL_PlayInHeadset: TMenuItem
      Action = ActionPlaylistPlayInHeadset
    end
    object N13: TMenuItem
      Caption = '-'
    end
    object PM_PL_ExtendedAddToMedialibrary: TMenuItem
      Action = ActionPlaylistAddFilesToLibrary
    end
    object PM_PL_ExtendedCopyToClipboard: TMenuItem
      Action = ActionFilesCopyToClipboard
    end
    object PM_PL_MagicCopyToClipboard: TMenuItem
      Tag = 1
      Action = ActionFilesCopyToClipboard
      Caption = '... and include a proper playlist file'
      ShortCut = 24643
    end
    object PM_PL_ExtendedPasteFromClipboard: TMenuItem
      Caption = 'Paste from clipboard'
      ShortCut = 16470
      OnClick = PM_ML_PasteFromClipboardClick
    end
    object PM_PL_CopyPlaylistToUSB: TMenuItem
      Action = ActionPlaylistCopyFilesToUSB
    end
    object N24: TMenuItem
      Caption = '-'
    end
    object PM_PL_ExtendedScanFiles: TMenuItem
      Action = ActionPlaylistRefresh
    end
    object PM_PL_ShowInExplorer: TMenuItem
      Tag = 1
      Action = ActionFileShowInExplorer
    end
    object PM_PL_Properties: TMenuItem
      Tag = 1
      Action = ActionFileShowDetails
    end
  end
  object TNAMenu: TPopupMenu
    AutoHotkeys = maManual
    Images = TaskBarImages
    OnPopup = TNAMenuPopup
    Left = 993
    Top = 417
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
    Images = vilIconsWindows
    OnPopup = Player_PopupMenuPopup
    Left = 520
    Top = 178
    object PM_P_Preferences: TMenuItem
      Caption = 'Preferences'
      ImageIndex = 24
      ImageName = 'MenuSettings'
      OnClick = MM_O_PreferencesClick
    end
    object PM_P_Wizard: TMenuItem
      Caption = 'Wizard'
      ImageIndex = 35
      ImageName = 'MenuWizard'
      OnClick = MM_O_WizardClick
    end
    object PM_P_View: TMenuItem
      Caption = 'View'
      OnClick = PM_P_ViewClick
      object PM_P_JoinWindows: TMenuItem
        Action = actJoinWindows
      end
      object PM_P_SplitWindows: TMenuItem
        Tag = 1
        Action = actSplitWindows
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object PM_P_SplitTogglePlaylist: TMenuItem
        Action = actTogglePlaylist
        ShortCut = 24656
      end
      object PM_P_CompactToggleBrowseList: TMenuItem
        Action = actToggleBrowseList
        ShortCut = 24642
      end
      object PM_P_CompactToggleTitlelist: TMenuItem
        Action = actToggleTitleList
        ShortCut = 24660
      end
      object PM_P_CompactToggleFileoverview: TMenuItem
        Action = actToggleFileOverview
        ShortCut = 24644
      end
      object PM_P_ToggleStayOnTop: TMenuItem
        Action = actToggleStayOnTop
      end
      object N34: TMenuItem
        Caption = '-'
      end
      object PM_P_ShowCategorySelection: TMenuItem
        Action = actToggleShowCategorySelection
      end
      object Showcoverinconrtolpanel2: TMenuItem
        Action = actShowControlCover
      end
      object PM_P_TreeView: TMenuItem
        Caption = 'Treeview'
        object PM_P_TreeViewStacked: TMenuItem
          Action = actTreeviewStacked
        end
        object PM_P_TreeViewSideBySide: TMenuItem
          Action = actTreeViewSideBySide
        end
      end
      object PM_P_FileOverview: TMenuItem
        Caption = 'File overview'
        object PM_P_OverviewCoverAndDetails: TMenuItem
          Action = actFileOverviewBoth
        end
        object PM_P_OverviewOnlyCover: TMenuItem
          Action = actFileOverviewOnlyCover
        end
        object PM_P_OverviewOnlyDetails: TMenuItem
          Action = actFileOverviewOnlyDetails
        end
        object Onlydetails2: TMenuItem
          Caption = '-'
        end
        object PM_P_OverviewStacked: TMenuItem
          Action = actFileOverviewStacked
        end
        object PM_P_OverviewSideBySide: TMenuItem
          Action = actFileOverviewSideBySide
        end
      end
    end
    object PM_P_FormBuilder: TMenuItem
      Caption = 'Form designer'
      OnClick = MM_O_FormBuilderClick
    end
    object PM_P_Skins: TMenuItem
      Caption = 'Skins'
      ImageIndex = 26
      ImageName = 'MenuSkins'
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
      ImageIndex = 25
      ImageName = 'MenuShutdown'
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
      ImageName = 'MenuBirthday'
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
      ImageIndex = 31
      ImageName = 'MenuStream'
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
      ImageIndex = 11
      ImageName = 'MenuLastFM'
      object PM_P_ScrobblerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = PM_P_ScrobblerActivateClick
      end
      object PM_P_ScrobblerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_ScrobblerOptionsClick
      end
    end
    object PM_P_Plugins: TMenuItem
      Caption = 'Winamp DSP Plugins'
      ImageIndex = 34
      ImageName = 'Menuwinamp'
      Visible = False
      OnClick = PM_P_PluginsClick
      object N44: TMenuItem
        Caption = '-'
      end
      object PM_P_PluginConfigure: TMenuItem
        Caption = 'Configure current plugin'
        OnClick = MM_T_PluginConfigureClick
      end
      object PM_P_PluginStop: TMenuItem
        Caption = 'Stop current plugin'
        OnClick = MM_T_PluginStopClick
      end
      object PM_P_PluginOpenFolder: TMenuItem
        Caption = 'Open plugin directory'
        OnClick = MM_T_PluginOpenFolderClick
      end
    end
    object PM_P_KeyboardDisplay: TMenuItem
      Caption = 'Keyboard display'
      ImageIndex = 10
      ImageName = 'MenuKeyboard'
      OnClick = PM_P_KeyboardDisplayClick
    end
    object PM_P_EqualizerEffects: TMenuItem
      Caption = 'Equalizer && Effects'
      ImageIndex = 7
      ImageName = 'MenuEffects'
      OnClick = TabBtn_EqualizerClick
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
      object PM_P_DirectoriesProgram: TMenuItem
        Caption = 'Program directory'
        OnClick = MM_T_DirectoriesProgramClick
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
      ImageIndex = 9
      ImageName = 'MenuHelp'
      OnClick = MM_HelpClick
      object PM_P_About: TMenuItem
        Caption = 'About Nemp'
        ImageIndex = 17
        ImageName = 'MenuNempLogo'
        OnClick = MM_H_AboutClick
      end
      object PM_P_Help: TMenuItem
        Caption = 'Help'
        ImageIndex = 9
        ImageName = 'MenuHelp'
        OnClick = ToolButton7Click
      end
      object PM_P_OnlineHelp: TMenuItem
        Caption = 'Online help'
        OnClick = MM_H_HelpOnlineClick
      end
      object PM_P_CheckForUpdates: TMenuItem
        Caption = 'Check for updates'
        ImageIndex = 48
        ImageName = 'MenuNempUpdate'
        OnClick = MM_H_CheckForUpdatesClick
      end
      object PM_P_CleanupUpdate: TMenuItem
        Caption = 'Clean up update'
        OnClick = MM_H_CleanupUpdateClick
      end
    end
  end
  object VST_ColumnPopup: TPopupMenu
    OnPopup = VST_ColumnPopupPopup
    Left = 241
    Top = 388
  end
  object PopupPlayPause: TPopupMenu
    Images = vilIconsWindows
    Left = 195
    Top = 514
    object PM_PlayFiles: TMenuItem
      Tag = 1001
      Action = ActionPlaylistAddFiles
    end
    object PM_PlayWebstream: TMenuItem
      Tag = 1002
      Action = ActionPlaylistAddWebradio
    end
    object PM_PlayCDAudio: TMenuItem
      Tag = 1003
      Action = ActionPlaylistAddCDAudio
    end
  end
  object PopupStop: TPopupMenu
    OnPopup = PopupStopPopup
    Left = 275
    Top = 514
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
    Left = 346
    Top = 514
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
    Top = 465
  end
  object TaskBarImages: TImageList
    Left = 992
    Top = 320
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
  object RefreshCoverFlowTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = RefreshCoverFlowTimerTimer
    Left = 840
    Top = 456
  end
  object PopupRepeatAB: TPopupMenu
    Left = 430
    Top = 514
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
    Left = 202
    Top = 448
  end
  object CoverFlowRefreshViewTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = CoverFlowRefreshViewTimerTimer
    Left = 816
    Top = 512
  end
  object PopupEditExtendedTags: TPopupMenu
    OnPopup = PopupEditExtendedTagsPopup
    Left = 816
    Top = 280
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
    object pm_TagShowInExplorer: TMenuItem
      Caption = 'Show in Windows Explorer'
      OnClick = pm_TagShowInExplorerClick
    end
    object N37: TMenuItem
      Caption = '-'
    end
    object pm_FO_FileOverview: TMenuItem
      Caption = 'File overview'
      object pm_FO_CoverAndDetails: TMenuItem
        Action = actFileOverviewBoth
      end
      object pm_FO_OnlyCover: TMenuItem
        Action = actFileOverviewOnlyCover
      end
      object pm_FO_OnlyDetails: TMenuItem
        Action = actFileOverviewOnlyDetails
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object pm_FO_Stacked: TMenuItem
        Action = actFileOverviewStacked
      end
      object pm_FO_SideBySide: TMenuItem
        Action = actFileOverviewSideBySide
      end
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
  object Medialist_Collection_PopupMenu: TPopupMenu
    Images = vilIconsWindows
    OnPopup = Medialist_Collection_PopupMenuPopup
    Left = 72
    Top = 174
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
    object PM_ML_CollectionShowPlaylistInExplorer: TMenuItem
      Caption = 'Show playlist file in Windows Explorer'
      OnClick = PM_ML_CollectionShowPlaylistInExplorerClick
    end
    object N27: TMenuItem
      Caption = '-'
    end
    object PM_ML_SaveAsNewFavorite: TMenuItem
      Caption = 'Save current playlist as new favorite'
      OnClick = PM_PLM_SaveAsNewFavoriteClick
    end
    object PM_ML_EditFavorites: TMenuItem
      Tag = -1
      Caption = 'Edit favorite playlists'
      OnClick = PM_PLM_EditFavouritesClick
    end
    object PM_ML_FavPlaylistSeparator: TMenuItem
      Caption = '-'
    end
    object PM_ML_ChangeCategory: TMenuItem
      Caption = 'Change category'
      OnClick = PM_ML_ChangeCategoryClick
    end
    object PM_ML_RemoveFromCategory: TMenuItem
      Caption = 'Remove from category'
      OnClick = PM_ML_RemoveFromCategoryClick
    end
    object PM_ML_SortLayerBy: TMenuItem
      Caption = 'Sort layer by'
      ImageName = 'Effects'
      object PM_ML_SortLayerByName: TMenuItem
        Caption = 'Name'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByAlbum: TMenuItem
        Tag = 1
        Caption = 'Album'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByArtistAlbum: TMenuItem
        Tag = 50
        Caption = 'Artist, Album'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByArtistReleaseYear: TMenuItem
        Tag = 51
        Caption = 'Artist, Release Year'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByCount: TMenuItem
        Tag = 3
        Caption = 'Count'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByReleaseYear: TMenuItem
        Tag = 4
        Caption = 'Release Year'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByFileAge: TMenuItem
        Tag = 5
        Caption = 'Fileage'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByGenre: TMenuItem
        Tag = 6
        Caption = 'Genre'
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerByDirectory: TMenuItem
        Tag = 7
        Caption = 'Directory'
        OnClick = SortierAuswahl1POPUPClick
      end
      object N11: TMenuItem
        Tag = 9000
        Caption = '-'
      end
      object PM_ML_SortLayerAscending: TMenuItem
        Tag = 100
        Caption = 'Ascending'
        Checked = True
        OnClick = SortierAuswahl1POPUPClick
      end
      object PM_ML_SortLayerDescending: TMenuItem
        Tag = 101
        Caption = 'Descending'
        OnClick = SortierAuswahl1POPUPClick
      end
    end
    object PM_ML_SortPlaylistsBy: TMenuItem
      Caption = 'Sort playlists by'
      ImageName = 'Effects'
      object PM_ML_SortPlaylistsByFilename: TMenuItem
        Caption = 'Filename'
        OnClick = PM_ML_SortPlaylistsDescendingClick
      end
      object PM_ML_SortPlaylistsByFolder: TMenuItem
        Tag = 1
        Caption = 'Folder'
        OnClick = PM_ML_SortPlaylistsDescendingClick
      end
      object PM_ML_SortPlaylistsByPath: TMenuItem
        Tag = 2
        Caption = 'Path'
        OnClick = PM_ML_SortPlaylistsDescendingClick
      end
      object N28: TMenuItem
        Tag = 4211
        Caption = '-'
      end
      object PM_ML_SortPlaylistsAscending: TMenuItem
        Tag = 100
        Caption = 'Ascending'
        OnClick = PM_ML_SortPlaylistsDescendingClick
      end
      object PM_ML_SortPlaylistsDescending: TMenuItem
        Tag = 101
        Caption = 'Descending'
        OnClick = PM_ML_SortPlaylistsDescendingClick
      end
    end
    object PM_ML_ConfigureMedialibrary: TMenuItem
      Caption = 'Configure media library'
      ImageIndex = 42
      ImageName = 'MenuOk'
      OnClick = PM_ML_ConfigureMedialibraryClick
    end
    object PM_ML_ShowCategorySelection: TMenuItem
      Action = actToggleShowCategorySelection
    end
    object PM_ML_Treeview: TMenuItem
      Caption = 'Treeview'
      object PM_ML_TreeViewStacked: TMenuItem
        Action = actTreeviewStacked
      end
      object PM_ML_TreeViewSideBySide: TMenuItem
        Action = actTreeViewSideBySide
      end
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object PM_ML_SearchDirectory: TMenuItem
      Action = ActionLibraryAddDirectory
    end
    object PM_ML_SearchDirectoryCurrentCategory: TMenuItem
      Action = ActionLibraryAddDirectoryCurrentCategory
    end
    object PM_ML_Medialibrary: TMenuItem
      Caption = 'Media library'
      object PM_ML_MedialibraryLoad: TMenuItem
        Action = ActionLoadLibrary
      end
      object PM_ML_MedialibrarySave: TMenuItem
        Action = ActionSaveLibrary
      end
      object PM_ML_MedialibraryExport: TMenuItem
        Action = ActionExportLibrary
      end
      object PM_ML_MedialibraryDelete: TMenuItem
        Action = ActionDeleteLibrary
      end
      object N82: TMenuItem
        Caption = '-'
      end
      object PM_ML_MedialibraryRefresh: TMenuItem
        Action = ActionLibraryRefreshAll
      end
      object PM_ML_MedialibraryDeleteNotExisting: TMenuItem
        Action = ActionLibraryCleanup
      end
      object PM_ML_CloudEditor: TMenuItem
        Action = ActionLibraryTagCloudEditor
      end
    end
    object PM_ML_Webradio: TMenuItem
      Action = ActionManageWebradio
    end
    object PM_ML_RemoveSelectedPlaylists: TMenuItem
      Caption = 'Remove selected playlist'
      ShortCut = 16430
      OnClick = PM_ML_RemoveSelectedPlaylistsClick
    end
    object PM_ML_ResetTagCloudSeparator: TMenuItem
      Caption = '-'
    end
    object PM_ML_ResetTagCloud: TMenuItem
      Caption = 'Reset tag cloud'
      ShortCut = 27
      OnClick = PM_ML_ResetTagCloudClick
    end
  end
  object PopupTools: TPopupMenu
    AutoHotkeys = maManual
    Images = vilIconsWindows
    OnPopup = Player_PopupMenuPopup
    Left = 32
    Top = 514
    object PM_T_ShutDown: TMenuItem
      Caption = 'Shutdown'
      ImageIndex = 25
      ImageName = 'MenuShutdown'
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
      ImageName = 'MenuBirthday'
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
      ImageIndex = 31
      ImageName = 'MenuStream'
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
      ImageIndex = 11
      ImageName = 'MenuLastFM'
      object PM_T_ScrobblerActivate: TMenuItem
        Caption = 'Activate'
        OnClick = PM_P_ScrobblerActivateClick
      end
      object PM_T_ScrobblerOptions: TMenuItem
        Caption = 'Settings'
        OnClick = PM_P_ScrobblerOptionsClick
      end
    end
    object PM_T_Plugins: TMenuItem
      Caption = 'Winamp DSP Plugins'
      ImageIndex = 34
      ImageName = 'Menuwinamp'
      Visible = False
      OnClick = PM_T_PluginsClick
      object N45: TMenuItem
        Caption = '-'
      end
      object PM_T_PluginConfigure: TMenuItem
        Caption = 'Configure current plugin'
        OnClick = MM_T_PluginConfigureClick
      end
      object PM_T_PluginStop: TMenuItem
        Caption = 'Stop current plugin'
        OnClick = MM_T_PluginStopClick
      end
      object PM_T_PluginOpenFolder: TMenuItem
        Caption = 'Open plugin directory'
        OnClick = MM_T_PluginOpenFolderClick
      end
    end
  end
  object PlaylistManagerPopup: TPopupMenu
    Images = vilIconsWindows
    OnPopup = PlaylistManagerPopupPopup
    Left = 520
    Top = 80
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
    Left = 993
    Top = 271
  end
  object PlaylistVST_HeaderPopup: TPopupMenu
    Images = vilIconsWindows
    Left = 653
    Top = 80
    object pmShowColumnIndex: TMenuItem
      Caption = 'Show column "Index"'
      OnClick = pmShowColumnIndexClick
    end
  end
  object Medialist_Browse_Categories_PopupMenu: TPopupMenu
    Images = vilIconsWindows
    OnPopup = Medialist_Browse_Categories_PopupMenuPopup
    Left = 281
    Top = 174
  end
  object ActionListMain: TActionList
    Images = vilIconsWindows
    Left = 360
    Top = 54
    object actJoinWindows: TAction
      Category = 'Layout'
      Caption = 'Join windows'
      OnExecute = actJoinSplitWindowsExecute
    end
    object actSplitWindows: TAction
      Tag = 1
      Category = 'Layout'
      Caption = 'Split windows'
      OnExecute = actJoinSplitWindowsExecute
    end
    object actToggleFileOverview: TAction
      Category = 'Layout'
      Caption = 'Show file overview'
      OnExecute = actToggleFileOverviewExecute
    end
    object actToggleTitleList: TAction
      Category = 'Layout'
      Caption = 'Show title list'
      OnExecute = actToggleTitleListExecute
    end
    object actToggleBrowseList: TAction
      Category = 'Layout'
      Caption = 'Show treeview/coverflow/tagcloud'
      OnExecute = actToggleBrowseListExecute
    end
    object actTogglePlaylist: TAction
      Category = 'Layout'
      Caption = 'Show playlist'
      OnExecute = actTogglePlaylistExecute
    end
    object actToggleStayOnTop: TAction
      Category = 'Layout'
      Caption = 'Stay on top'
      ShortCut = 16468
      OnExecute = actToggleStayOnTopExecute
    end
    object actTreeviewStacked: TAction
      Category = 'Layout'
      Caption = 'Stacked'
      OnExecute = actTreeviewStackedExecute
    end
    object actTreeViewSideBySide: TAction
      Category = 'Layout'
      Caption = 'Side by side'
      OnExecute = actTreeViewSideBySideExecute
    end
    object actToggleShowCategorySelection: TAction
      Category = 'Layout'
      Caption = 'Show category selection'
      OnExecute = actToggleShowCategorySelectionExecute
    end
    object actFileOverviewBoth: TAction
      Category = 'Layout'
      Caption = 'Cover/lyrics and details'
      OnExecute = actFileOverviewBothExecute
    end
    object actFileOverviewOnlyCover: TAction
      Category = 'Layout'
      Caption = 'Only cover/lyrics'
      OnExecute = actFileOverviewOnlyCoverExecute
    end
    object actFileOverviewOnlyDetails: TAction
      Category = 'Layout'
      Caption = 'Only details'
      OnExecute = actFileOverviewOnlyDetailsExecute
    end
    object actFileOverviewStacked: TAction
      Category = 'Layout'
      Caption = 'Stacked'
      OnExecute = actFileOverviewStackedExecute
    end
    object actFileOverviewSideBySide: TAction
      Category = 'Layout'
      Caption = 'Side by side'
      OnExecute = actFileOverviewSideBySideExecute
    end
    object actShowControlCover: TAction
      Category = 'Layout'
      Caption = 'Show cover in control panel'
      OnExecute = actShowControlCoverExecute
    end
    object ActionLoadLibrary: TAction
      Category = 'MediaLibrary'
      Caption = 'Load Media library'
      ImageIndex = 18
      ImageName = 'MenuOpen'
      OnExecute = ActionLoadLibraryExecute
    end
    object ActionSaveLibrary: TAction
      Category = 'MediaLibrary'
      Caption = 'Save Media library'
      ImageIndex = 22
      ImageName = 'MenuSave'
      OnExecute = ActionSaveLibraryExecute
    end
    object ActionExportLibrary: TAction
      Category = 'MediaLibrary'
      Caption = 'Export Media library'
      ShortCut = 16453
      OnExecute = ActionExportLibraryExecute
    end
    object ActionDeleteLibrary: TAction
      Category = 'MediaLibrary'
      Caption = 'Delete Media library'
      ImageIndex = 6
      ImageName = 'MenuDelete'
      OnExecute = ActionDeleteLibraryExecute
    end
    object ActionLibraryAddDirectory: TAction
      Category = 'MediaLibrary'
      Caption = 'Add directory'
      ImageIndex = 1
      ImageName = 'MenuAddFolder'
      ShortCut = 16462
      OnExecute = ActionLibraryAddDirectoryExecute
    end
    object ActionLibraryAddDirectoryCurrentCategory: TAction
      Category = 'MediaLibrary'
      Caption = 'Add directory to the current category'
      ShortCut = 24654
      OnExecute = ActionLibraryAddDirectoryCurrentCategoryExecute
    end
    object ActionManageWebradio: TAction
      Category = 'MediaLibrary'
      Caption = 'Manage Webradio stations'
      ImageIndex = 31
      ImageName = 'MenuStream'
      ShortCut = 16471
      OnExecute = ActionManageWebradioExecute
    end
    object ActionSearchLibrary: TAction
      Category = 'MediaLibrary'
      Caption = 'Search'
      ImageIndex = 23
      ImageName = 'MenuSearch'
      ShortCut = 24646
      OnExecute = ActionSearchLibraryExecute
    end
    object ActionLibraryRefreshAll: TAction
      Category = 'MediaLibrary'
      Caption = 'Refresh (rescan all files)'
      ImageIndex = 20
      ImageName = 'MenuRefresh'
      ShortCut = 16500
      OnExecute = ActionLibraryRefreshAllExecute
    end
    object ActionLibraryRefreshPlaylists: TAction
      Category = 'MediaLibrary'
      Caption = 'Refresh (Playlists only)'
      OnExecute = ActionLibraryRefreshPlaylistsExecute
    end
    object ActionLibraryRefreshSelected: TAction
      Category = 'MediaLibrary'
      Caption = 'Refresh selected'
      ImageIndex = 20
      ImageName = 'MenuRefresh'
      ShortCut = 116
      OnExecute = ActionLibraryRefreshSelectedExecute
    end
    object ActionLibraryCleanup: TAction
      Category = 'MediaLibrary'
      Caption = 'Cleanup (remove missing files)'
      ImageIndex = 3
      ImageName = 'MenuCleanUp'
      OnExecute = ActionLibraryCleanupExecute
    end
    object ActionLibraryTagCloudEditor: TAction
      Category = 'MediaLibrary'
      Caption = 'Tag cloud editor'
      ImageIndex = 32
      ImageName = 'MenuTagCloud'
      OnExecute = ActionLibraryTagCloudEditorExecute
    end
    object ActionCloseNemp: TAction
      Category = 'Nemp'
      Caption = 'Close Nemp'
      ImageIndex = 4
      ImageName = 'MenuCloseNemp'
      OnExecute = ActionCloseNempExecute
    end
    object ActionPlaylistAddFiles: TAction
      Category = 'Playlist'
      Caption = 'Add files'
      ImageIndex = 36
      ImageName = 'MenuAddMusic'
      OnExecute = ActionPlaylistAddFilesExecute
    end
    object ActionPlaylistAddCDAudio: TAction
      Category = 'Playlist'
      Caption = 'Add CD-Audio'
      ImageIndex = 37
      ImageName = 'MenuCDDA'
      OnExecute = ActionPlaylistAddCDAudioExecute
    end
    object ActionPlaylistAddDirectory: TAction
      Category = 'Playlist'
      Caption = 'Add directory'
      ImageIndex = 1
      ImageName = 'MenuAddFolder'
      OnExecute = ActionPlaylistAddDirectoryExecute
    end
    object ActionPlaylistAddWebradio: TAction
      Category = 'Playlist'
      Caption = 'Add webradio'
      ImageIndex = 31
      ImageName = 'MenuStream'
      ShortCut = 16457
      OnExecute = ActionPlaylistAddWebradioExecute
    end
    object ActionPlaylistLoad: TAction
      Category = 'Playlist'
      Caption = 'Load (and clear current list)'
      ImageIndex = 18
      ImageName = 'MenuOpen'
      ShortCut = 16463
      OnExecute = ActionPlaylistLoadExecute
    end
    object ActionPlaylistAddPlaylist: TAction
      Category = 'Playlist'
      Caption = 'Load (add files to current list)'
      OnExecute = ActionPlaylistAddPlaylistExecute
    end
    object ActionPlaylistSort: TAction
      Category = 'Playlist'
      Caption = 'Sort'
      OnExecute = ActionPlaylistSortExecute
    end
    object ActionPlaylistGenerateRandom: TAction
      Category = 'Playlist'
      Caption = 'Generate random playlist'
      OnExecute = ActionPlaylistGenerateRandomExecute
    end
    object ActionPlaylistSave: TAction
      Category = 'Playlist'
      Caption = 'Save'
      ImageIndex = 22
      ImageName = 'MenuSave'
      ShortCut = 16467
      OnExecute = ActionPlaylistSaveExecute
    end
    object ActionPlaylistSaveAs: TAction
      Category = 'Playlist'
      Caption = 'Save as'
      OnExecute = ActionPlaylistSaveAsExecute
    end
    object ActionPlaylistRefresh: TAction
      Category = 'Playlist'
      Caption = 'Refresh files'
      ImageIndex = 20
      ImageName = 'MenuRefresh'
      ShortCut = 116
      OnExecute = ActionPlaylistRefreshExecute
    end
    object ActionPlaylistCleanup: TAction
      Category = 'Playlist'
      Caption = 'Cleanup (remove missing files)'
      ImageIndex = 3
      ImageName = 'MenuCleanUp'
      OnExecute = ActionPlaylistCleanupExecute
    end
    object ActionPlaylistRemoveSelected: TAction
      Category = 'Playlist'
      Caption = 'Remove selected'
      ShortCut = 46
      OnExecute = ActionPlaylistRemoveSelectedExecute
    end
    object ActionPlaylistClear: TAction
      Category = 'Playlist'
      Caption = 'Clear'
      ImageIndex = 6
      ImageName = 'MenuDelete'
      OnExecute = ActionPlaylistClearExecute
    end
    object ActionPlaylistScanForDuplicates: TAction
      Category = 'Playlist'
      Caption = 'Scan for duplicates'
      OnExecute = ActionPlaylistScanForDuplicatesExecute
    end
    object ActionPlaylistAddFilesToLibrary: TAction
      Category = 'Playlist'
      Caption = 'Add all files to the Media library'
      ImageIndex = 38
      ImageName = 'MenuAddToLibrary'
      OnExecute = ActionPlaylistAddFilesToLibraryExecute
    end
    object ActionPlaylistCopyFilesToUSB: TAction
      Category = 'Playlist'
      Caption = 'Copy files'
      ImageIndex = 39
      ImageName = 'MenuUSB'
      OnExecute = ActionPlaylistCopyFilesToUSBExecute
    end
    object ActionFilesSetRating: TAction
      Category = 'AudioFiles'
      Caption = 'Set rating'
      OnExecute = ActionFilesSetRatingExecute
    end
    object ActionFilesSetFlag: TAction
      Category = 'AudioFiles'
      Caption = 'Flag selected files with'
      OnExecute = ActionFilesSetFlagExecute
    end
    object ActionFilesCalculateReplayGain: TAction
      Category = 'AudioFiles'
      Caption = 'Calculate ReplayGain'
      OnExecute = ActionFilesCalculateReplayGainExecute
    end
    object ActionPlaylistPlayInHeadset: TAction
      Category = 'Playlist'
      Caption = 'Play in headset'
      ImageIndex = 8
      ImageName = 'MenuHeadphones'
      ShortCut = 16456
      OnExecute = ActionPlaylistPlayInHeadsetExecute
    end
    object ActionLibraryPlayInHeadset: TAction
      Category = 'MediaLibrary'
      Caption = 'Play in headset'
      ImageIndex = 8
      ImageName = 'MenuHeadphones'
      ShortCut = 16456
      OnExecute = ActionLibraryPlayInHeadsetExecute
    end
    object ActionFilesCopyToClipboard: TAction
      Category = 'AudioFiles'
      Caption = 'Copy selected files to clipboard'
      ShortCut = 16451
      OnExecute = ActionFilesCopyToClipboardExecute
    end
    object ActionFileShowInExplorer: TAction
      Category = 'AudioFiles'
      Caption = 'Show in Windows Explorer'
      OnExecute = ActionFileShowInExplorerExecute
    end
    object ActionFileShowDetails: TAction
      Category = 'AudioFiles'
      Caption = 'Properties'
      ImageIndex = 0
      ImageName = 'MenuInfo'
      ShortCut = 16452
      OnExecute = ActionFileShowDetailsExecute
    end
    object ActionCloseSubForm: TAction
      Category = 'Nemp'
      Caption = 'Close'
      Hint = 'Close window'
      OnExecute = ActionCloseSubFormExecute
    end
  end
  object SplitWindowTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = SplitWindowTimerTimer
    Left = 688
    Top = 504
  end
  object ApplicationEvents1: TApplicationEvents
    OnHelp = ApplicationEvents1Help
    Left = 672
    Top = 416
  end
  object Medialist_Category_PopupMenu: TPopupMenu
    Images = vilIconsWindows
    OnPopup = Medialist_Category_PopupMenuPopup
    Left = 72
    Top = 122
    object PM_ML_ConfigureMediaLibraryCat: TMenuItem
      Caption = 'Configure media library'
      OnClick = PM_ML_ConfigureMedialibraryClick
    end
    object PM_ML_ClearCategory: TMenuItem
      Caption = 'Clear category'
      ImageIndex = 38
      ImageName = 'MenuAddToLibrary'
      OnClick = PM_ML_ClearCategoryClick
    end
    object N42: TMenuItem
      Caption = '-'
    end
    object PM_ML_ShowPlaylistCategories: TMenuItem
      Caption = 'Show playlist categories'
      OnClick = PM_ML_ShowPlaylistCategoriesClick
    end
    object PM_ML_ShowWebradioCategory: TMenuItem
      Caption = 'Show webradio category'
      OnClick = PM_ML_ShowWebradioCategoryClick
    end
  end
  object vilIconsWindows: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'MenuInfo'
        Name = 'MenuInfo'
      end
      item
        CollectionIndex = 1
        CollectionName = 'MenuAddFolder'
        Name = 'MenuAddFolder'
      end
      item
        CollectionIndex = 2
        CollectionName = 'MenuBirthday'
        Name = 'MenuBirthday'
      end
      item
        CollectionIndex = 3
        CollectionName = 'MenuCleanUp'
        Name = 'MenuCleanUp'
      end
      item
        CollectionIndex = 4
        CollectionName = 'MenuCloseNemp'
        Name = 'MenuCloseNemp'
      end
      item
        CollectionIndex = 5
        CollectionName = 'MenuConfigureLibrary'
        Name = 'MenuConfigureLibrary'
      end
      item
        CollectionIndex = 6
        CollectionName = 'MenuDelete'
        Name = 'MenuDelete'
      end
      item
        CollectionIndex = 7
        CollectionName = 'MenuEffects'
        Name = 'MenuEffects'
      end
      item
        CollectionIndex = 8
        CollectionName = 'MenuHeadphones'
        Name = 'MenuHeadphones'
      end
      item
        CollectionIndex = 9
        CollectionName = 'MenuHelp'
        Name = 'MenuHelp'
      end
      item
        CollectionIndex = 10
        CollectionName = 'MenuKeyboard'
        Name = 'MenuKeyboard'
      end
      item
        CollectionIndex = 11
        CollectionName = 'MenuLastFM'
        Name = 'MenuLastFM'
      end
      item
        CollectionIndex = 12
        CollectionName = 'MenuMarkAll'
        Name = 'MenuMarkAll'
      end
      item
        CollectionIndex = 13
        CollectionName = 'MenuMarkBlack'
        Name = 'MenuMarkBlack'
      end
      item
        CollectionIndex = 14
        CollectionName = 'MenuMarkBlue'
        Name = 'MenuMarkBlue'
      end
      item
        CollectionIndex = 15
        CollectionName = 'MenuMarkGreen'
        Name = 'MenuMarkGreen'
      end
      item
        CollectionIndex = 16
        CollectionName = 'MenuMarkRed'
        Name = 'MenuMarkRed'
      end
      item
        CollectionIndex = 17
        CollectionName = 'MenuNempLogo'
        Name = 'MenuNempLogo'
      end
      item
        CollectionIndex = 18
        CollectionName = 'MenuOpen'
        Name = 'MenuOpen'
      end
      item
        CollectionIndex = 19
        CollectionName = 'MenuPlay'
        Name = 'MenuPlay'
      end
      item
        CollectionIndex = 20
        CollectionName = 'MenuRefresh'
        Name = 'MenuRefresh'
      end
      item
        CollectionIndex = 21
        CollectionName = 'MenuReplayGain'
        Name = 'MenuReplayGain'
      end
      item
        CollectionIndex = 22
        CollectionName = 'MenuSave'
        Name = 'MenuSave'
      end
      item
        CollectionIndex = 23
        CollectionName = 'MenuSearch'
        Name = 'MenuSearch'
      end
      item
        CollectionIndex = 24
        CollectionName = 'MenuSettings'
        Name = 'MenuSettings'
      end
      item
        CollectionIndex = 25
        CollectionName = 'MenuShutdown'
        Name = 'MenuShutdown'
      end
      item
        CollectionIndex = 26
        CollectionName = 'MenuSkins'
        Name = 'MenuSkins'
      end
      item
        CollectionIndex = 27
        CollectionName = 'MenuSort'
        Name = 'MenuSort'
      end
      item
        CollectionIndex = 28
        CollectionName = 'MenuStarEmpty'
        Name = 'MenuStarEmpty'
      end
      item
        CollectionIndex = 29
        CollectionName = 'MenuStarFull'
        Name = 'MenuStarFull'
      end
      item
        CollectionIndex = 30
        CollectionName = 'MenuStarHalf'
        Name = 'MenuStarHalf'
      end
      item
        CollectionIndex = 31
        CollectionName = 'MenuStream'
        Name = 'MenuStream'
      end
      item
        CollectionIndex = 32
        CollectionName = 'MenuTagCloud'
        Name = 'MenuTagCloud'
      end
      item
        CollectionIndex = 33
        CollectionName = 'MenuWarning'
        Name = 'MenuWarning'
      end
      item
        CollectionIndex = 34
        CollectionName = 'Menuwinamp'
        Name = 'Menuwinamp'
      end
      item
        CollectionIndex = 35
        CollectionName = 'MenuWizard'
        Name = 'MenuWizard'
      end
      item
        CollectionIndex = 36
        CollectionName = 'MenuAddMusic'
        Name = 'MenuAddMusic'
      end
      item
        CollectionIndex = 37
        CollectionName = 'MenuCDDA'
        Name = 'MenuCDDA'
      end
      item
        CollectionIndex = 38
        CollectionName = 'MenuAddToLibrary'
        Name = 'MenuAddToLibrary'
      end
      item
        CollectionIndex = 39
        CollectionName = 'MenuUSB'
        Name = 'MenuUSB'
      end
      item
        CollectionIndex = 40
        CollectionName = 'MenuFileMissing'
        Name = 'MenuFileMissing'
      end
      item
        CollectionIndex = 41
        CollectionName = 'MenuInfoReplace'
        Name = 'MenuInfoReplace'
      end
      item
        CollectionIndex = 42
        CollectionName = 'MenuOk'
        Name = 'MenuOk'
      end
      item
        CollectionIndex = 43
        CollectionName = 'MenuPause'
        Name = 'MenuPause'
      end
      item
        CollectionIndex = 44
        CollectionName = 'MenuReplayGainDisabled'
        Name = 'MenuReplayGainDisabled'
      end
      item
        CollectionIndex = 45
        CollectionName = 'MenuStop'
        Name = 'MenuStop'
      end
      item
        CollectionIndex = 46
        CollectionName = 'MenuTimer'
        Name = 'MenuTimer'
      end
      item
        CollectionIndex = 47
        CollectionName = 'MenuWarningRed'
        Name = 'MenuWarningRed'
      end
      item
        CollectionIndex = 48
        CollectionName = 'MenuNempUpdate'
        Name = 'MenuNempUpdate'
      end
      item
        CollectionIndex = 49
        CollectionName = 'MenuEmpty'
        Name = 'MenuEmpty'
      end
      item
        CollectionIndex = 50
        CollectionName = 'MenuTreeCollapse'
        Name = 'MenuTreeCollapse'
      end
      item
        CollectionIndex = 51
        CollectionName = 'MenuTreeExpand'
        Name = 'MenuTreeExpand'
      end
      item
        CollectionIndex = 52
        CollectionName = 'ToolBtnBGDisabled'
        Name = 'ToolBtnBGDisabled'
      end
      item
        CollectionIndex = 53
        CollectionName = 'ToolBtnBGDown'
        Name = 'ToolBtnBGDown'
      end
      item
        CollectionIndex = 54
        CollectionName = 'ToolBtnBGHighlight'
        Name = 'ToolBtnBGHighlight'
      end
      item
        CollectionIndex = 55
        CollectionName = 'ToolBtnBGNormal'
        Name = 'ToolBtnBGNormal'
      end
      item
        CollectionIndex = 56
        CollectionName = 'ToolBtnBirthday'
        Name = 'ToolBtnBirthday'
      end
      item
        CollectionIndex = 57
        CollectionName = 'ToolBtnCloseNemp'
        Name = 'ToolBtnCloseNemp'
      end
      item
        CollectionIndex = 58
        CollectionName = 'ToolBtnLastFM'
        Name = 'ToolBtnLastFM'
      end
      item
        CollectionIndex = 59
        CollectionName = 'ToolBtnShutdown'
        Name = 'ToolBtnShutdown'
      end
      item
        CollectionIndex = 60
        CollectionName = 'ToolBtnWarning'
        Name = 'ToolBtnWarning'
      end
      item
        CollectionIndex = 61
        CollectionName = 'ToolBtnwinamp'
        Name = 'ToolBtnwinamp'
      end
      item
        CollectionIndex = 62
        CollectionName = 'SysBtnCloseForm'
        Name = 'SysBtnCloseForm'
      end
      item
        CollectionIndex = 63
        CollectionName = 'SysBtnCloseNemp'
        Name = 'SysBtnCloseNemp'
      end
      item
        CollectionIndex = 64
        CollectionName = 'SysBtnMinimize'
        Name = 'SysBtnMinimize'
      end
      item
        CollectionIndex = 65
        CollectionName = 'ToolBtnWebserver'
        Name = 'ToolBtnWebserver'
      end
      item
        CollectionIndex = 66
        CollectionName = 'BtnVolumeHigh'
        Name = 'BtnVolumeHigh'
      end
      item
        CollectionIndex = 67
        CollectionName = 'BtnVolumeLow'
        Name = 'BtnVolumeLow'
      end
      item
        CollectionIndex = 68
        CollectionName = 'BtnVolumeMute'
        Name = 'BtnVolumeMute'
      end>
    ImageCollection = DataModuleGui.ICIcons
    Left = 505
    Top = 457
  end
  object vilIconsSkin: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'imgStarFull'
        Name = 'imgStarFull'
      end
      item
        CollectionIndex = 1
        CollectionName = 'imgStarHalf'
        Name = 'imgStarHalf'
      end
      item
        CollectionIndex = 2
        CollectionName = 'imgStarEmpty'
        Name = 'imgStarEmpty'
      end
      item
        CollectionIndex = 3
        CollectionName = 'imgPlayCount'
        Name = 'imgPlayCount'
      end>
    ImageCollection = DataModuleGui.ICSkinIcons
    Left = 577
    Top = 457
  end
  object viPlayerButtons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'BtnBGNormal'
        Name = 'BtnBGNormal'
      end
      item
        CollectionIndex = 1
        CollectionName = 'BtnBGHighlight'
        Name = 'BtnBGHighlight'
      end
      item
        CollectionIndex = 2
        CollectionName = 'BtnBGDown'
        Name = 'BtnBGDown'
      end
      item
        CollectionIndex = 3
        CollectionName = 'BtnBGDisabled'
        Name = 'BtnBGDisabled'
      end
      item
        CollectionIndex = 4
        CollectionName = 'PlayerNext'
        Name = 'PlayerNext'
      end
      item
        CollectionIndex = 5
        CollectionName = 'PlayerPause'
        Name = 'PlayerPause'
      end
      item
        CollectionIndex = 6
        CollectionName = 'PlayerPlay'
        Name = 'PlayerPlay'
      end
      item
        CollectionIndex = 7
        CollectionName = 'PlayerPlayReverse'
        Name = 'PlayerPlayReverse'
      end
      item
        CollectionIndex = 8
        CollectionName = 'PlayerPrev'
        Name = 'PlayerPrev'
      end
      item
        CollectionIndex = 9
        CollectionName = 'PlayerRecordOff'
        Name = 'PlayerRecordOff'
      end
      item
        CollectionIndex = 10
        CollectionName = 'PlayerRecordOn'
        Name = 'PlayerRecordOn'
      end
      item
        CollectionIndex = 11
        CollectionName = 'PlayerRepeatAll'
        Name = 'PlayerRepeatAll'
      end
      item
        CollectionIndex = 12
        CollectionName = 'PlayerRepeatOff'
        Name = 'PlayerRepeatOff'
      end
      item
        CollectionIndex = 13
        CollectionName = 'PlayerRepeatRandom'
        Name = 'PlayerRepeatRandom'
      end
      item
        CollectionIndex = 14
        CollectionName = 'PlayerRepeatTitle'
        Name = 'PlayerRepeatTitle'
      end
      item
        CollectionIndex = 15
        CollectionName = 'PlayerSlideBackward'
        Name = 'PlayerSlideBackward'
      end
      item
        CollectionIndex = 16
        CollectionName = 'PlayerSlideForward'
        Name = 'PlayerSlideForward'
      end
      item
        CollectionIndex = 17
        CollectionName = 'PlayerStop'
        Name = 'PlayerStop'
      end>
    ImageCollection = DataModuleGui.ICPlayerButtons
    Width = 36
    Height = 36
    Left = 536
    Top = 520
  end
  object viTabButtons: TVirtualImageList
    AutoFill = True
    Images = <
      item
        CollectionIndex = 0
        CollectionName = 'TabBtnBGNormal'
        Name = 'TabBtnBGNormal'
      end
      item
        CollectionIndex = 1
        CollectionName = 'TabBtnBGHighlight'
        Name = 'TabBtnBGHighlight'
      end
      item
        CollectionIndex = 2
        CollectionName = 'TabBtnBGDown'
        Name = 'TabBtnBGDown'
      end
      item
        CollectionIndex = 3
        CollectionName = 'TabBtnBGDisabled'
        Name = 'TabBtnBGDisabled'
      end
      item
        CollectionIndex = 4
        CollectionName = 'TabBtnBrowse'
        Name = 'TabBtnBrowse'
      end
      item
        CollectionIndex = 5
        CollectionName = 'TabBtnCategory'
        Name = 'TabBtnCategory'
      end
      item
        CollectionIndex = 6
        CollectionName = 'TabBtnCover'
        Name = 'TabBtnCover'
      end
      item
        CollectionIndex = 7
        CollectionName = 'TabBtnCoverflow'
        Name = 'TabBtnCoverflow'
      end
      item
        CollectionIndex = 8
        CollectionName = 'TabBtnEffects'
        Name = 'TabBtnEffects'
      end
      item
        CollectionIndex = 9
        CollectionName = 'TabBtnFavorite'
        Name = 'TabBtnFavorite'
      end
      item
        CollectionIndex = 10
        CollectionName = 'TabBtnHeadphones'
        Name = 'TabBtnHeadphones'
      end
      item
        CollectionIndex = 11
        CollectionName = 'TabBtnLyrics'
        Name = 'TabBtnLyrics'
      end
      item
        CollectionIndex = 12
        CollectionName = 'TabBtnMarkAll'
        Name = 'TabBtnMarkAll'
      end
      item
        CollectionIndex = 13
        CollectionName = 'TabBtnMarkBlack'
        Name = 'TabBtnMarkBlack'
      end
      item
        CollectionIndex = 14
        CollectionName = 'TabBtnMarkBlue'
        Name = 'TabBtnMarkBlue'
      end
      item
        CollectionIndex = 15
        CollectionName = 'TabBtnMarkGreen'
        Name = 'TabBtnMarkGreen'
      end
      item
        CollectionIndex = 16
        CollectionName = 'TabBtnMarkRed'
        Name = 'TabBtnMarkRed'
      end
      item
        CollectionIndex = 17
        CollectionName = 'TabBtnNemp'
        Name = 'TabBtnNemp'
      end
      item
        CollectionIndex = 18
        CollectionName = 'TabBtnTagCloud'
        Name = 'TabBtnTagCloud'
      end
      item
        CollectionIndex = 19
        CollectionName = 'TabBtnViewLocked'
        Name = 'TabBtnViewLocked'
      end
      item
        CollectionIndex = 20
        CollectionName = 'TabBtnViewUnlocked'
        Name = 'TabBtnViewUnlocked'
      end
      item
        CollectionIndex = 21
        CollectionName = 'TabBtnOverlayAlert'
        Name = 'TabBtnOverlayAlert'
      end>
    ImageCollection = DataModuleGui.ICTabButtons
    Width = 24
    Height = 24
    Left = 464
    Top = 376
  end
  object DummyImageList: TVirtualImageList
    Images = <
      item
        CollectionIndex = 49
        CollectionName = 'MenuEmpty'
        Name = 'MenuEmpty'
      end>
    ImageCollection = DataModuleGui.ICIcons
    Width = 128
    Height = 128
    Left = 360
    Top = 248
  end
end
