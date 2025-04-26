object FormHeadsetControl: TFormHeadsetControl
  Left = 0
  Top = 0
  Caption = 'Nemp: Headset control'
  ClientHeight = 149
  ClientWidth = 418
  Color = clBtnFace
  Constraints.MaxHeight = 188
  Constraints.MinHeight = 188
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlBars: TPanel
    Left = 0
    Top = 117
    Width = 418
    Height = 32
    Align = alBottom
    TabOrder = 0
    object HeadsetTimeLbl: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 34
      Height = 16
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alLeft
      Alignment = taRightJustify
      AutoSize = False
      Caption = '00:00'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 48
    end
    object rbHeadsetTrack: TProgressRangeBar
      AlignWithMargins = True
      Left = 43
      Top = 7
      Width = 245
      Height = 18
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      OnScroll = rbHeadsetTrackScroll
      OnStep = rbHeadsetTrackStep
      OnEndScroll = rbHeadsetTrackEndScroll
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
      Align = alClient
    end
    object BtnMute: TSkinButton
      AlignWithMargins = True
      Left = 292
      Top = 4
      Width = 24
      Height = 24
      Margins.Left = 4
      Margins.Right = 0
      Align = alRight
      DoubleBuffered = True
      DrawMode = dm_Windows
      ParentDoubleBuffered = False
      TabOrder = 1
      Caption = 'SkinButton1'
    end
    object rbVolume: TProgressRangeBar
      AlignWithMargins = True
      Left = 316
      Top = 7
      Width = 89
      Height = 18
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 12
      Margins.Bottom = 6
      OnScroll = rbVolumeScroll
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
  object pnlContainer: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 418
    Height = 117
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    TabOrder = 1
    object imgCover: TImage
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 99
      Height = 99
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alLeft
      Proportional = True
      Stretch = True
      OnMouseDown = imgCoverMouseDown
      OnMouseMove = imgCoverMouseMove
    end
    object pnlInfo: TPanel
      Left = 116
      Top = 1
      Width = 301
      Height = 115
      Align = alClient
      BevelOuter = bvNone
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      OnMouseDown = pnlInfoMouseDown
      ExplicitLeft = 117
      ExplicitWidth = 300
      object PlayerTitleLabel: TLabel
        Left = 8
        Top = 28
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
      end
      object PlayerArtistLabel: TLabel
        Left = 8
        Top = 8
        Width = 9
        Height = 15
        Caption = '...'
        ShowAccelChar = False
      end
      object BtnHeadsetPlaynow: TSkinButton
        Left = 99
        Top = 75
        Width = 32
        Height = 32
        Hint = 'Add file to playlist and begin playback from current position'
        DoubleBuffered = True
        DrawMode = dm_Windows
        ParentDoubleBuffered = False
        TabOrder = 0
        OnClick = BtnHeadsetPlaynowClick
      end
      object BtnHeadsetToPlaylist: TSkinButton
        Left = 137
        Top = 75
        Width = 32
        Height = 32
        Hint = 'Add current file to playlist (Right click for options)'
        DoubleBuffered = True
        DrawMode = dm_Windows
        ParentDoubleBuffered = False
        PopupMenu = PopupHeadset
        TabOrder = 1
        OnClick = BtnHeadsetToPlaylistClick
      end
      object BtnLoadHeadset: TSkinButton
        Left = 193
        Top = 75
        Width = 32
        Height = 32
        Hint = 'Load selected file into headset (Ctrl+H)'
        DoubleBuffered = True
        DrawMode = dm_Windows
        ParentDoubleBuffered = False
        TabOrder = 2
        Visible = False
      end
      object PlayPauseHeadSetBtn: TSkinButton
        Left = 8
        Top = 75
        Width = 32
        Height = 32
        DoubleBuffered = True
        DrawMode = dm_Windows
        ParentDoubleBuffered = False
        TabOrder = 3
        OnClick = PlayPauseHeadSetBtnClick
      end
      object StopHeadSetBtn: TSkinButton
        Left = 46
        Top = 75
        Width = 32
        Height = 32
        DoubleBuffered = True
        DrawMode = dm_Windows
        Images = vilIcons
        ParentDoubleBuffered = False
        TabOrder = 4
        OnClick = StopHeadSetBtnClick
      end
      object BtnHeadsetRating: TRatingButton
        Left = 8
        Top = 51
        Width = 80
        Height = 16
        DoubleBuffered = True
        DrawMode = dm_Windows
        Images = vilIcons
        ParentDoubleBuffered = False
        TabOrder = 5
        TransparentBackground = True
        Visible = False
        StyleElements = [seFont, seBorder]
        Rating = 120
        AllowChangeRating = True
        OnRatingChanged = BtnHeadsetRatingRatingChanged
        StarFullImageIndex = 29
        StarHalfImageIndex = 30
        StarEmptyImageIndex = 28
        StarFullImageName = 'MenuStarFull'
        StarHalfImageName = 'MenuStarHalf'
        StarEmptyImageName = 'MenuStarEmpty'
      end
    end
  end
  object HeadsetTimer: TTimer
    OnTimer = HeadsetTimerTimer
    Left = 32
    Top = 32
  end
  object vilIcons: TVirtualImageList
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
        CollectionName = 'ToolBtnStream'
        Name = 'ToolBtnStream'
      end
      item
        CollectionIndex = 61
        CollectionName = 'ToolBtnWarning'
        Name = 'ToolBtnWarning'
      end
      item
        CollectionIndex = 62
        CollectionName = 'ToolBtnwinamp'
        Name = 'ToolBtnwinamp'
      end
      item
        CollectionIndex = 63
        CollectionName = 'SysBtnCloseForm'
        Name = 'SysBtnCloseForm'
      end
      item
        CollectionIndex = 64
        CollectionName = 'SysBtnCloseNemp'
        Name = 'SysBtnCloseNemp'
      end
      item
        CollectionIndex = 65
        CollectionName = 'SysBtnMinimize'
        Name = 'SysBtnMinimize'
      end>
    ImageCollection = DataModuleGui.ICIcons
    Left = 217
    Top = 17
  end
  object PopupHeadset: TPopupMenu
    Left = 315
    Top = 18
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
end
