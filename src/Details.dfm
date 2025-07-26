object FDetails: TFDetails
  Left = 220
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'File properties'
  ClientHeight = 531
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  Position = poMainFormCenter
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  TextHeight = 13
  object MainPageControl: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 8
    Width = 559
    Height = 487
    Margins.Top = 8
    ActivePage = Tab_General
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object Tab_General: TTabSheet
      Caption = 'Overview'
      DoubleBuffered = False
      ParentDoubleBuffered = False
      PopupMenu = PM_FileOverview
      object GrpBox_File: TGroupBox
        Left = 0
        Top = 0
        Width = 551
        Height = 145
        Align = alTop
        Caption = 'File properties'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 0
        DesignSize = (
          551
          145)
        object LBLName: TLabel
          Left = 103
          Top = 31
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          EllipsisPosition = epWordEllipsis
          ShowAccelChar = False
          Transparent = True
        end
        object LBLSize: TLabel
          Left = 103
          Top = 47
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_FileSize: TLabel
          Left = 8
          Top = 48
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Filesize'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Filename: TLabel
          Left = 8
          Top = 32
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Filename'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Path: TLabel
          Left = 8
          Top = 16
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Path'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LBLPfad: TLabel
          Left = 103
          Top = 16
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          EllipsisPosition = epPathEllipsis
          ParentShowHint = False
          ShowAccelChar = False
          ShowHint = True
          Transparent = True
          OnClick = LBLPfadClick
        end
        object LBLSamplerate: TLabel
          Left = 103
          Top = 79
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LlblConst_Samplerate: TLabel
          Left = 8
          Top = 80
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Samplerate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LlblConst_Bitrate: TLabel
          Left = 8
          Top = 96
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Bitrate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LblFormat: TLabel
          Left = 103
          Top = 111
          Width = 126
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LblConst_Format: TLabel
          Left = 8
          Top = 112
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Format'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LBLBitrate: TLabel
          Left = 103
          Top = 95
          Width = 126
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object LblConst_Duration: TLabel
          Left = 8
          Top = 64
          Width = 80
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Duration'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          Transparent = True
        end
        object LblDuration: TLabel
          Left = 103
          Top = 63
          Width = 335
          Height = 13
          AutoSize = False
          Caption = '...'
          ShowAccelChar = False
          Transparent = True
        end
        object CoverLibrary1: TImage
          AlignWithMargins = True
          Left = 408
          Top = 13
          Width = 120
          Height = 120
          Anchors = [akTop, akRight]
          Center = True
          OnDblClick = CoverIMAGEDblClick
          ExplicitLeft = 476
        end
        object PnlWarnung: TPanel
          Left = 235
          Top = 101
          Width = 203
          Height = 24
          BevelOuter = bvNone
          TabOrder = 0
          object ImageWarning: TVirtualImage
            Left = 0
            Top = 0
            Width = 24
            Height = 24
            ImageCollection = DataModuleGui.ICIcons
            ImageWidth = 0
            ImageHeight = 0
            ImageIndex = 33
            ImageName = 'MenuWarning'
          end
          object Lbl_Warnings: TLabel
            Left = 30
            Top = -3
            Width = 170
            Height = 24
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            Transparent = True
            WordWrap = True
          end
        end
      end
      object PnlLibraryMetadata: TPanel
        Left = 0
        Top = 145
        Width = 551
        Height = 314
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object GrpBox_MetaDataLibrary: TGroupBox
          Left = 0
          Top = 0
          Width = 551
          Height = 314
          Align = alClient
          Caption = 'Metadata overview'
          DoubleBuffered = False
          ParentDoubleBuffered = False
          TabOrder = 0
          object pnlExtendedTags: TPanel
            Left = 409
            Top = 15
            Width = 140
            Height = 297
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              140
              297)
            object lblExtendedTags: TLabel
              Left = 6
              Top = 8
              Width = 80
              Height = 13
              AutoSize = False
              Caption = 'Extended tags'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object lb_Tags: TListBox
              AlignWithMargins = True
              Left = 6
              Top = 27
              Width = 111
              Height = 254
              Anchors = [akLeft, akTop, akRight, akBottom]
              ItemHeight = 13
              PopupMenu = PM_EditExtendedTags
              TabOrder = 0
              OnDblClick = lb_TagsDblClick
            end
          end
          object pnlMetadataOverview: TPanel
            Left = 2
            Top = 15
            Width = 407
            Height = 297
            Align = alLeft
            BevelOuter = bvNone
            DoubleBuffered = True
            ParentDoubleBuffered = False
            TabOrder = 0
            object lblAlbumArtist: TLabel
              Left = 14
              Top = 123
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Album-Artist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object lblComposer: TLabel
              Left = 14
              Top = 147
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Composer'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Album: TLabel
              Left = 12
              Top = 75
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Album'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Artist: TLabel
              Left = 10
              Top = 29
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Artist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_CD: TLabel
              Left = 171
              Top = 195
              Width = 14
              Height = 13
              Alignment = taRightJustify
              Caption = 'CD'
            end
            object LblConst_Comment: TLabel
              Left = 14
              Top = 99
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Comment'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Genre: TLabel
              Left = 10
              Top = 171
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Genre'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Rating: TLabel
              Left = 8
              Top = 223
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Rating'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object lblConst_ReplayGain: TLabel
              Left = 8
              Top = 244
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'ReplayGain'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Transparent = True
            end
            object LblConst_Title: TLabel
              Left = 12
              Top = 51
              Width = 80
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Title'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Track: TLabel
              Left = 62
              Top = 195
              Width = 30
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Track'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblConst_Year: TLabel
              Left = 289
              Top = 171
              Width = 48
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Year'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              ShowAccelChar = False
              Transparent = True
            end
            object LblPlayCounter: TLabel
              Left = 179
              Top = 223
              Width = 12
              Height = 13
              Caption = '...'
            end
            object LblReplayGainAlbum: TLabel
              Left = 96
              Top = 263
              Width = 12
              Height = 13
              Caption = '...'
              ParentShowHint = False
              ShowAccelChar = False
              ShowHint = True
              Transparent = True
              OnClick = LBLPfadClick
            end
            object LblReplayGainTitle: TLabel
              Left = 96
              Top = 242
              Width = 12
              Height = 13
              Caption = '...'
              ParentShowHint = False
              ShowAccelChar = False
              ShowHint = True
              Transparent = True
              OnClick = LBLPfadClick
            end
            object CB_LibraryGenre: TComboBox
              Left = 96
              Top = 168
              Width = 146
              Height = 21
              AutoComplete = False
              Sorted = True
              TabOrder = 6
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryAlbum: TEdit
              Left = 96
              Top = 72
              Width = 300
              Height = 21
              TabOrder = 2
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryArtist: TEdit
              Left = 96
              Top = 24
              Width = 300
              Height = 21
              TabOrder = 0
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryCD: TEdit
              Left = 191
              Top = 192
              Width = 51
              Height = 21
              TabOrder = 9
              OnChange = Edit_LibraryYearChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryComment: TEdit
              Left = 96
              Top = 96
              Width = 300
              Height = 21
              TabOrder = 3
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryTitle: TEdit
              Left = 96
              Top = 48
              Width = 300
              Height = 21
              TabOrder = 1
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryTrack: TEdit
              Left = 96
              Top = 192
              Width = 51
              Height = 21
              TabOrder = 8
              OnChange = Edit_LibraryTrackChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryYear: TEdit
              Left = 345
              Top = 168
              Width = 51
              Height = 21
              NumbersOnly = True
              TabOrder = 7
              OnChange = Edit_LibraryYearChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryAlbumArtist: TEdit
              Left = 96
              Top = 120
              Width = 300
              Height = 21
              TabOrder = 4
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Edit_LibraryComposer: TEdit
              Left = 96
              Top = 144
              Width = 300
              Height = 21
              TabOrder = 5
              OnChange = EditLibraryChange
              OnExit = Edit_LibraryExit
            end
            object Btn_LibraryRating: TRatingButton
              Left = 94
              Top = 220
              Width = 80
              Height = 16
              DoubleBuffered = True
              DoubleBufferedMode = dbmRequested
              DrawMode = dm_Windows
              Images = vilIcons
              ParentDoubleBuffered = False
              TabOrder = 10
              TransparentBackground = True
              StyleElements = [seFont, seBorder]
              Rating = 128
              AllowChangeRating = True
              OnRatingChanged = Btn_LibraryRatingRatingChanged
              StarFullImageIndex = 29
              StarHalfImageIndex = 30
              StarEmptyImageIndex = 28
              StarFullImageName = 'MenuStarFull'
              StarHalfImageName = 'MenuStarHalf'
              StarEmptyImageName = 'MenuStarEmpty'
            end
          end
        end
      end
    end
    object Tab_Lyrics: TTabSheet
      Caption = 'Lyrics'
      ImageIndex = 2
      object GrpBox_Lyrics: TGroupBox
        Left = 0
        Top = 0
        Width = 551
        Height = 459
        Align = alClient
        Caption = 'Lyrics'
        TabOrder = 0
        object Memo_Lyrics: TMemo
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 541
          Height = 397
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = Memo_LyricsChange
          OnExit = Memo_LyricsExit
          OnKeyDown = Memo_LyricsKeyDown
        end
        object pnlSearchLyrics: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 421
          Width = 541
          Height = 33
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object lblLyricSearchEngines: TLabel
            AlignWithMargins = True
            Left = 8
            Top = 3
            Width = 369
            Height = 27
            Margins.Left = 8
            Margins.Right = 8
            Align = alClient
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Search Lyrics'
            Layout = tlCenter
            ExplicitLeft = 3
            ExplicitTop = 5
            ExplicitWidth = 444
            ExplicitHeight = 13
          end
          object btnSearchLyrics: TButton
            AlignWithMargins = True
            Left = 389
            Top = 4
            Width = 144
            Height = 25
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 8
            Margins.Bottom = 4
            Align = alRight
            Caption = 'Search Lyrics'
            DropDownMenu = PM_SearchEngines
            Style = bsSplitButton
            TabOrder = 0
            OnClick = btnSearchLyricsClick
          end
        end
      end
    end
    object Tab_Pictures: TTabSheet
      Caption = 'Pictures (cover art)'
      ImageIndex = 3
      PopupMenu = PM_CoverArt
      object PanelCoverArtFile: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 301
        Height = 453
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object gpBoxExistingCoverArt: TGroupBox
          Left = 0
          Top = 0
          Width = 301
          Height = 453
          Align = alClient
          Caption = 'Cover art (meta data and image files)'
          TabOrder = 0
          object lblCoverInfo: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 430
            Width = 281
            Height = 13
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alBottom
            Caption = '...'
            ExplicitWidth = 12
          end
          object VSTCover: TVirtualStringTree
            AlignWithMargins = True
            Left = 10
            Top = 23
            Width = 281
            Height = 102
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 8
            Align = alClient
            Colors.UnfocusedSelectionColor = clHighlight
            Colors.UnfocusedSelectionBorderColor = clHighlight
            Header.AutoSizeIndex = 0
            Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
            Images = imgListCovertypes
            Indent = 4
            TabOrder = 0
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
            TreeOptions.SelectionOptions = [toFullRowSelect]
            OnFocusChanged = VSTCoverFocusChanged
            OnFreeNode = VSTCoverFreeNode
            OnGetText = VSTCoverGetText
            OnPaintText = VSTCoverPaintText
            OnGetImageIndex = VSTCoverGetImageIndex
            Touch.InteractiveGestures = [igPan, igPressAndTap]
            Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
            Columns = <
              item
                Position = 0
                Width = 277
              end>
          end
          object pnlCoverCurrentSelection: TPanel
            AlignWithMargins = True
            Left = 10
            Top = 141
            Width = 281
            Height = 281
            Margins.Left = 8
            Margins.Top = 8
            Margins.Right = 8
            Margins.Bottom = 0
            Align = alBottom
            BevelKind = bkFlat
            BevelOuter = bvNone
            TabOrder = 1
            object ImgCurrentSelection: TImage
              Left = 0
              Top = 0
              Width = 277
              Height = 277
              Align = alClient
              Center = True
              Proportional = True
              Stretch = True
              OnDblClick = ImgCurrentSelectionDblClick
              ExplicitLeft = 33
              ExplicitTop = 24
              ExplicitWidth = 263
              ExplicitHeight = 127
            end
          end
        end
      end
      object GrpBox_CoverLibrary: TGroupBox
        AlignWithMargins = True
        Left = 310
        Top = 3
        Width = 238
        Height = 453
        Align = alRight
        Caption = 'Cover art for the Media library'
        TabOrder = 1
        DesignSize = (
          238
          453)
        object CoverLibrary2: TImage
          AlignWithMargins = True
          Left = 19
          Top = 126
          Width = 201
          Height = 197
          Hint = 'The current cover art used in the media library'
          Center = True
          ParentShowHint = False
          Proportional = True
          ShowHint = True
          Stretch = True
        end
        object lblChangeCoverArt: TLabel
          Left = 19
          Top = 330
          Width = 98
          Height = 13
          Caption = 'Apply changes to ...'
        end
        object cbChangeCoverArt: TComboBox
          Left = 19
          Top = 350
          Width = 201
          Height = 21
          Style = csDropDownList
          Anchors = [akTop, akRight]
          ItemIndex = 0
          TabOrder = 0
          Text = 'this file only'
          Items.Strings = (
            'this file only'
            'all files with this cover art'
            'all files in the same directory')
        end
      end
    end
    object Tab_MetaData: TTabSheet
      Caption = 'Metadata structure'
      ImageIndex = 1
      PopupMenu = PM_TagStructure
      object GrpBox_TextFrames: TGroupBox
        Left = 0
        Top = 0
        Width = 551
        Height = 270
        Align = alClient
        Caption = 'Metadata frames'
        TabOrder = 0
        object VST_MetaData: TVirtualStringTree
          Left = 2
          Top = 15
          Width = 547
          Height = 253
          Align = alClient
          BorderStyle = bsNone
          BorderWidth = 1
          Colors.UnfocusedSelectionColor = clHighlight
          Colors.UnfocusedSelectionBorderColor = clHighlight
          Header.AutoSizeIndex = 3
          Header.MainColumn = 3
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
          Indent = 0
          TabOrder = 0
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
          TreeOptions.PaintOptions = [toShowBackground, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnCompareNodes = VST_MetaDataCompareNodes
          OnEditing = VST_MetaDataEditing
          OnFreeNode = VST_MetaDataFreeNode
          OnGetText = VST_MetaDataGetText
          OnPaintText = VST_MetaDataPaintText
          OnNewText = VST_MetaDataNewText
          Touch.InteractiveGestures = [igPan, igPressAndTap]
          Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
          Columns = <
            item
              Position = 0
              Text = 'Type'
              Width = 59
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 1
              Text = 'Key'
              Width = 56
            end
            item
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coStyleColor]
              Position = 2
              Text = 'Description'
              Width = 105
            end
            item
              Position = 3
              Text = 'Value'
              Width = 325
            end>
        end
      end
      object Pnl_ID3v1_MPEG: TPanel
        Left = 0
        Top = 270
        Width = 551
        Height = 189
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object GrpBox_ID3v1: TGroupBox
          Left = 0
          Top = 0
          Width = 363
          Height = 189
          Align = alClient
          Caption = 'ID3 v1'
          TabOrder = 0
          DesignSize = (
            363
            189)
          object LblConst_ID3v1Artist: TLabel
            Left = 8
            Top = 27
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Artist'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Title: TLabel
            Left = 8
            Top = 51
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Title'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Album: TLabel
            Left = 8
            Top = 75
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Album'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Year: TLabel
            Left = 260
            Top = 123
            Width = 43
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Year'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
            ExplicitLeft = 268
          end
          object LblConst_ID3v1Genre: TLabel
            Left = 8
            Top = 123
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Genre'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Comment: TLabel
            Left = 8
            Top = 99
            Width = 83
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Comment'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_ID3v1Track: TLabel
            Left = 273
            Top = 99
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'Track'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
            ExplicitLeft = 281
          end
          object Lblv1Album: TEdit
            Tag = 3
            Left = 96
            Top = 72
            Width = 254
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 2
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Artist: TEdit
            Tag = 1
            Left = 96
            Top = 24
            Width = 254
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Titel: TEdit
            Tag = 2
            Left = 96
            Top = 48
            Width = 254
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Year: TEdit
            Tag = 7
            Left = 309
            Top = 120
            Width = 41
            Height = 21
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 6
            OnChange = Lblv1YearChange
            OnExit = edtID3v1Exit
          end
          object Lblv1Comment: TEdit
            Tag = 4
            Left = 96
            Top = 96
            Width = 158
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
            OnChange = edtID3v1Change
            OnExit = edtID3v1Exit
          end
          object Lblv1Track: TEdit
            Tag = 5
            Left = 309
            Top = 96
            Width = 41
            Height = 21
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 4
            OnChange = Lblv1TrackChange
            OnExit = edtID3v1Exit
          end
          object cbIDv1Genres: TComboBox
            Tag = 6
            Left = 97
            Top = 120
            Width = 158
            Height = 21
            AutoCloseUp = True
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            Sorted = True
            TabOrder = 5
            OnChange = cbIDv1GenresChange
          end
        end
        object GrpBox_Mpeg: TGroupBox
          AlignWithMargins = True
          Left = 367
          Top = 0
          Width = 184
          Height = 189
          Margins.Left = 4
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alRight
          Caption = 'MPEG'
          TabOrder = 1
          object LblConst_MpegBitrate: TLabel
            Left = 8
            Top = 48
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Bitrate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegSamplerate: TLabel
            Left = 8
            Top = 64
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Samplerate'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegOriginal: TLabel
            Left = 8
            Top = 147
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Original'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegEmphasis: TLabel
            Left = 8
            Top = 163
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Emphasis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegVersion: TLabel
            Left = 6
            Top = 13
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Version'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegCopyright: TLabel
            Left = 8
            Top = 131
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Copyright'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegProtection: TLabel
            Left = 8
            Top = 99
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Protection'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegHeader: TLabel
            Left = 8
            Top = 32
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Header at '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegExtension: TLabel
            Left = 8
            Top = 115
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Extension'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblConst_MpegDuration: TLabel
            Left = 8
            Top = 80
            Width = 82
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Duration'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETBitrate: TLabel
            Left = 100
            Top = 48
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETSamplerate: TLabel
            Left = 100
            Top = 64
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETDauer: TLabel
            Left = 100
            Top = 80
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETVersion: TLabel
            Left = 100
            Top = 16
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETHeaderAt: TLabel
            Left = 100
            Top = 32
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETProtection: TLabel
            Left = 100
            Top = 99
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETExtension: TLabel
            Left = 100
            Top = 115
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETCopyright: TLabel
            Left = 100
            Top = 131
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETOriginal: TLabel
            Left = 100
            Top = 147
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
          object LblDETEmphasis: TLabel
            Left = 100
            Top = 163
            Width = 12
            Height = 13
            Caption = '...'
            ShowAccelChar = False
            Transparent = True
          end
        end
      end
    end
  end
  object pnlButtons: TPanel
    AlignWithMargins = True
    Left = 8
    Top = 498
    Width = 549
    Height = 33
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Btn_Close: TButton
      AlignWithMargins = True
      Left = 300
      Top = 4
      Width = 75
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = Btn_CloseClick
    end
    object BtnUndo: TButton
      AlignWithMargins = True
      Left = 383
      Top = 4
      Width = 75
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Undo'
      TabOrder = 1
      OnClick = BtnUndoClick
    end
    object BtnApply: TButton
      AlignWithMargins = True
      Left = 466
      Top = 4
      Width = 75
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Apply'
      TabOrder = 2
      OnClick = BtnApplyClick
    end
    object cbQuickRefresh: TCheckBox
      AlignWithMargins = True
      Left = 8
      Top = 4
      Width = 167
      Height = 25
      Hint = 
        'Refresh this form whenever you select another file in the main w' +
        'indow.'
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 0
      Margins.Bottom = 4
      Align = alLeft
      Caption = 'Quick refresh'
      TabOrder = 4
      OnClick = cbQuickRefreshClick
    end
    object BtnRefreshCoverflow: TButton
      AlignWithMargins = True
      Left = 135
      Top = 4
      Width = 157
      Height = 25
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alRight
      Caption = 'Refresh Coverflow'
      TabOrder = 3
      Visible = False
      OnClick = BtnRefreshCoverflowClick
    end
  end
  object PM_URLCopy: TPopupMenu
    Left = 144
    Top = 115
    object PM_CopyURLToClipboard: TMenuItem
      Caption = 'Copy URL to clipboard'
      OnClick = PM_CopyURLToClipboardClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'Supported files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png;'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 508
    Top = 96
  end
  object ReloadTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = ReloadTimerTimer
    Left = 320
    Top = 40
  end
  object PM_EditExtendedTags: TPopupMenu
    Left = 48
    Top = 163
    object pm_AddTag: TMenuItem
      Action = ActionTagAdd
    end
    object pm_RenameTag: TMenuItem
      Action = ActionTagRename
    end
    object pm_RemoveTag: TMenuItem
      Action = ActionTagRemove
    end
    object Getextendedtagsfromlastfm1: TMenuItem
      Action = ActionTagGetLastFM
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Opencloudeditor1: TMenuItem
      Action = ActionTagOpenCloudEditor
    end
  end
  object OpenDlgCoverArt: TOpenPictureDialog
    Filter = 
      'Supported files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.' +
      'bmp'
    Left = 504
    Top = 40
  end
  object PM_SearchEngines: TPopupMenu
    Left = 47
    Top = 210
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 67
    object mmFile: TMenuItem
      Caption = 'File'
      OnClick = mmFileClick
      object mmShowInExplorer: TMenuItem
        Action = ActionShowInExplorer
      end
      object mmWindowsProperties: TMenuItem
        Action = ActionWindowsProperties
      end
      object mmResetRating: TMenuItem
        Action = ActionResetRating
      end
      object mmSynchronizeRating: TMenuItem
        Action = ActionSynchronizeRating
      end
      object mmRefresh: TMenuItem
        Action = ActionRefreshFile
      end
    end
    object mmExtendedTags: TMenuItem
      Caption = 'Extended tags'
      OnClick = mmExtendedTagsClick
      object mmAddTag: TMenuItem
        Action = ActionTagAdd
      end
      object mmEditTag: TMenuItem
        Action = ActionTagRename
      end
      object mmRemoveTag: TMenuItem
        Action = ActionTagRemove
      end
      object mmGetExtendedTagsFromLastFM: TMenuItem
        Action = ActionTagGetLastFM
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mmOpenCloudEditor: TMenuItem
        Action = ActionTagOpenCloudEditor
      end
    end
    object mmLyrics: TMenuItem
      Caption = 'Lyrics'
      OnClick = mmLyricsClick
    end
    object mmCoverArt: TMenuItem
      Caption = 'Cover art'
      OnClick = PM_CoverArtPopup
      object mmAddCoverToMetadata: TMenuItem
        Action = ActionCoverNewMetaData
      end
      object mmCoverDelete: TMenuItem
        Action = ActionCoverDeleteMetaData
      end
      object mmCoverSaveToFile: TMenuItem
        Action = ActionCoverMetaDataSaveToFile
      end
      object mmOpenSelectedFile: TMenuItem
        Action = ActionCoverMetaDataOpenFile
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mmCoverUseSelectedForLibrary: TMenuItem
        Action = ActionCoverUseCurrentSelectionForMediaLibrary
      end
      object mmCoverLoadLibrary: TMenuItem
        Action = ActionCoverLoadLibrary
      end
      object mmCoverReset: TMenuItem
        Action = ActionCoverResetMediaLibrary
      end
    end
    object mmMetaData: TMenuItem
      Caption = 'Metadata structure'
      OnClick = mmMetaDataClick
      object mmNewDataFrame: TMenuItem
        Action = ActionMetaNewFrame
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mmCopyfromID3v1: TMenuItem
        Action = ActionMetaCopyFromID3v1
      end
      object mmCopyfromID3v2: TMenuItem
        Action = ActionMetaCopyFromID3v2
      end
    end
  end
  object imgListCovertypes: TImageList
    ColorDepth = cd32Bit
    DrawingStyle = dsTransparent
    Left = 509
    Top = 158
    Bitmap = {
      494C010102000800040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F8F8FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F9F9F9FFC8C5C3FFC1C3BEFFB9C0
      B9FFBABCBBFFC7C7C6FFD9DAD6FFD7D6D6FFD7D4D5FFD7D4D4FFDAD8D9FFDEDD
      DEFFE4E3E3FFD3D8D6FFC5CECBFFFFFFFFFFFBF9F9FF34544DFF41524EFF3454
      4DFF698F83FF8AA79FFF475750FF405650FF507063FF537D77FF6F9296FF779A
      9AFF416762FF29423FFF29423FFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFAFAFFE1E1E1FFDFDFDFFFDEDE
      DEFFE4E4E4FFE6E6E7FFE5E5E6FFDBDBDCFFD8D8D9FFDCDDDEFFDEDFE0FFDFE1
      E1FFE0E1E1FFDCDAD8FFD8D4D2FFFFFFFFFFFBF9F9FF29423FFF29423FFF4167
      62FF779A9AFF6F9296FF537D77FF507063FF405650FF475750FF8AA79FFF698F
      83FF34544DFF41524EFF34544DFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FBFBFBFFCFD0D0FFCFCFD0FFCFCE
      D0FFCFCCD0FFD4D2D6FFE0DFE1FFECEBECFFEEEEEEFF543732FF3B0D00FF3C27
      1CFF320E00FF47200CFF531F00FFFFFFFFFFFBF9F9FF845F55FF845F55FF543E
      37FF271A1EFF311B11FF50363EFF727585FF4F464CFF352130FF2B2233FF664F
      73FF3E3039FF5C4C61FF3E3039FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FDFDFDFFCCCCC9FFCBCBC9FFC9C9
      C9FFC7C7C9FFCECED0FFDFDFE0FFF0F0F0FFF3F3F3FFB6A195FF936F5BFF7E65
      5AFF8B614AFFA98263FFBC987CFFFFFFFFFFFBF9F9FFFFEFC3FFFFEFC3FFFFF1
      BEFF9392A6FF5F6480FF554F4DFF2A373FFF000000FF201601FF6E665DFF524D
      72FF575889FF3F446AFF575889FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFEFEFFE1E1E1FFE0E0E0FFDEDE
      DEFFDCDCDCFFDFE0E0FFE7E8E8FFEFF0F0FFF1F2F2FFE8D5B6FFE5CBACFFB592
      7BFFAB7E5EFFCDAC8EFFD2B8A5FFFFFFFFFFFBF9F9FFFEC593FFFEC593FFFFD7
      9DFFFFE0A3FF6F7095FF7387BBFF886462FFFFD995FFFFF6BCFFFFFBB9FFFFD6
      99FFB69A75FF4B4339FFB69A75FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFD0D1D1FFCFD0D0FFCCCB
      CCFFC8C6C8FFCECCCEFFDDDCDDFFECECECFFEFEFEFFFF8E0B8FFF8E0B6FFF6E5
      CAFFF8DEB5FFF9E0B7FFF9E1B9FFFFFFFFFFFBF9F9FFF8BA84FFF8BA84FFF8BB
      87FFFFCA87FFF6C091FF46527CFFE0A070FFFFE3A2FFFFC28DFFFDBE8CFFFFCD
      95FFFFE09FFFFFDE98FFFFE09FFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFE9E9E9FFE7E7E7FFE7E7
      E7FFF1F1F1FFF3F3F1FFF2F0EDFFF6F3EEFFF7F4EFFFF7F4EFFFF7F4F1FFF7F5
      F2FFF7F5F2FFF9F8F6FFFCFBF9FFFFFFFFFFFBF9F9FFF0AC72FFF0AC72FFF0B2
      78FFF0B077FFFFBA78FFFFBD7AFFFFBD81FFF1AF77FFF2B37CFFEFB47DFFF2B4
      7DFFF3B47EFFF6B279FFF3B47EFFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFD1CECEFFCDCBC9FFC8C8
      C4FFC7C6C7FFD3D2D5FFE7E7E8FFE8E8E9FFE9E9EAFFEBEBEBFFEEEEEEFFF1F1
      F1FFF4F4F4FFF2F2F2FFF1F1F1FFFFFFFFFFFBF9F9FFE79E66FFE79E66FFEAA4
      6AFFEAA46CFFE9A36BFFF0A86DFFEAA46CFFEAA46EFFEAA66CFFECA970FFECA7
      71FFEDAB70FFECA56AFFEDAB70FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFEAEAEAFFE8E8E8FFE7E7
      E7FFE9E9E9FFEDEDEDFFF0F0F0FFEEEEEEFFEDEDEDFFEDEDEDFFEFEFEFFFF1F1
      F1FFF4F4F4FFEFEFEFFFEBEBEBFFFFFFFFFFFBF9F9FFDD925CFFDD925CFFE097
      63FFE19761FFDF9763FFDF9762FFDF9764FFDF9965FFE09864FFE19966FFE29A
      65FFE49D67FFE09561FFE49D67FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFDAE0DEFFD9DAD9FFD6D1
      D1FFC4C5C4FFC9CBCAFFDDDCDCFFCFCFD0FFC5C7C8FFC0C5C3FFC7C8C9FFD0CE
      D0FFDBD9D8FFC4C6C5FFB0B4B4FFFFFFFFFFFBF9F9FFDD925CFFDD925CFFE097
      63FFE19761FFDF9763FFDF9762FFDF9764FFDF9965FFE09864FFE19966FFE29A
      65FFE49D67FFE09561FFE49D67FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9
      F9FFFBF9F9FFFBF9F9FFFBF9F9FFFBF9F9FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ActionList1: TActionList
    Left = 227
    Top = 67
    object ActionShowInExplorer: TAction
      Category = 'File'
      Caption = 'Show in Explorer'
      OnExecute = ActionShowInExplorerExecute
    end
    object ActionWindowsProperties: TAction
      Category = 'File'
      Caption = 'Windows properties'
      OnExecute = ActionWindowsPropertiesExecute
    end
    object ActionResetRating: TAction
      Category = 'File'
      Caption = 'Reset rating and play counter'
      OnExecute = ActionResetRatingExecute
    end
    object ActionSynchronizeRating: TAction
      Category = 'File'
      Caption = 'Synchronize rating'
      OnExecute = ActionSynchronizeRatingExecute
    end
    object ActionRefreshFile: TAction
      Category = 'File'
      Caption = 'Refresh'
      OnExecute = ActionRefreshFileExecute
    end
    object ActionTagAdd: TAction
      Category = 'ExtendedTags'
      Caption = 'Add tag'
      OnExecute = ActionTagAddExecute
    end
    object ActionTagRename: TAction
      Category = 'ExtendedTags'
      Caption = 'Edit tag'
      OnExecute = ActionTagRenameExecute
    end
    object ActionTagRemove: TAction
      Category = 'ExtendedTags'
      Caption = 'Remove tag'
      OnExecute = ActionTagRemoveExecute
    end
    object ActionTagGetLastFM: TAction
      Category = 'ExtendedTags'
      Caption = 'Get extended tags from last.fm'
      OnExecute = ActionTagGetLastFMExecute
    end
    object ActionTagOpenCloudEditor: TAction
      Category = 'ExtendedTags'
      Caption = 'Open cloud editor'
      OnExecute = ActionTagOpenCloudEditorExecute
    end
    object ActionCoverNewMetaData: TAction
      Category = 'Cover'
      Caption = 'Add cover to metadata'
      OnExecute = ActionCoverNewMetaDataExecute
    end
    object ActionCoverDeleteMetaData: TAction
      Category = 'Cover'
      Caption = 'Delete selected cover from metadata'
      OnExecute = ActionCoverDeleteMetaDataExecute
    end
    object ActionCoverMetaDataSaveToFile: TAction
      Category = 'Cover'
      Caption = 'Save selected cover to file'
      OnExecute = ActionCoverMetaDataSaveToFileExecute
    end
    object ActionCoverMetaDataOpenFile: TAction
      Category = 'Cover'
      Caption = 'Open selected image file'
      OnExecute = ActionCoverMetaDataOpenFileExecute
    end
    object ActionCoverLoadLibrary: TAction
      Category = 'Cover'
      Caption = 'Load cover for Media library'
      OnExecute = ActionCoverLoadLibraryExecute
    end
    object ActionCoverUseCurrentSelectionForMediaLibrary: TAction
      Category = 'Cover'
      Caption = 'Use selected cover for Media library'
      OnExecute = ActionCoverUseCurrentSelectionForMediaLibraryExecute
    end
    object ActionCoverResetMediaLibrary: TAction
      Category = 'Cover'
      Caption = 'Reset cover in Media library'
      OnExecute = ActionCoverResetMediaLibraryExecute
    end
    object ActionMetaNewFrame: TAction
      Category = 'MetaData Structure'
      Caption = 'New data frame'
      OnExecute = ActionMetaNewFrameExecute
    end
    object ActionMetaCopyFromID3v1: TAction
      Category = 'MetaData Structure'
      Caption = 'Copy ID3v2/APE from ID3v1'
      OnExecute = ActionMetaCopyFromID3v1Execute
    end
    object ActionMetaCopyFromID3v2: TAction
      Category = 'MetaData Structure'
      Caption = 'Copy ID3v1 from ID3v2/APE'
      OnExecute = ActionMetaCopyFromID3v2Execute
    end
  end
  object PM_CoverArt: TPopupMenu
    OnPopup = PM_CoverArtPopup
    Left = 47
    Top = 257
    object Addcovertometadata1: TMenuItem
      Action = ActionCoverNewMetaData
    end
    object Deleteselectedcoverfrommetadata1: TMenuItem
      Action = ActionCoverDeleteMetaData
    end
    object Saveselectedcovertofile1: TMenuItem
      Action = ActionCoverMetaDataSaveToFile
    end
    object Openselectedimagefile1: TMenuItem
      Action = ActionCoverMetaDataOpenFile
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object LoadcoverforMedialibrary1: TMenuItem
      Action = ActionCoverLoadLibrary
    end
    object UseselectedcoverforMedialibrary1: TMenuItem
      Action = ActionCoverUseCurrentSelectionForMediaLibrary
    end
    object ResetcoverinMedialibrary1: TMenuItem
      Action = ActionCoverResetMediaLibrary
    end
  end
  object PM_TagStructure: TPopupMenu
    Left = 47
    Top = 115
    object Newdataframe1: TMenuItem
      Action = ActionMetaNewFrame
    end
    object CopyID3v2APEfromID3v11: TMenuItem
      Action = ActionMetaCopyFromID3v1
    end
    object CopyID3v1fromID3v2APE1: TMenuItem
      Action = ActionMetaCopyFromID3v2
    end
  end
  object PM_FileOverview: TPopupMenu
    Left = 49
    Top = 67
    object ShowinExplorer1: TMenuItem
      Action = ActionShowInExplorer
    end
    object Windowsproperties1: TMenuItem
      Action = ActionWindowsProperties
    end
    object Resetratingandplaycounter1: TMenuItem
      Action = ActionResetRating
    end
    object Synchronizerating1: TMenuItem
      Action = ActionSynchronizeRating
    end
    object Refresh1: TMenuItem
      Action = ActionRefreshFile
    end
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
      end
      item
        CollectionIndex = 69
        CollectionName = 'MenuPlayNext'
        Name = 'MenuPlayNext'
      end
      item
        CollectionIndex = 70
        CollectionName = 'MenuPlayPrev'
        Name = 'MenuPlayPrev'
      end
      item
        CollectionIndex = 71
        CollectionName = 'MenuCancel'
        Name = 'MenuCancel'
      end
      item
        CollectionIndex = 72
        CollectionName = 'TreeCleanChecked'
        Name = 'TreeCleanChecked'
      end
      item
        CollectionIndex = 73
        CollectionName = 'TreeCleanUnchecked'
        Name = 'TreeCleanUnchecked'
      end>
    ImageCollection = DataModuleGui.ICIcons
    Left = 337
    Top = 193
  end
end
