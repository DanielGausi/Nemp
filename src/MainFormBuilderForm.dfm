object MainFormBuilder: TMainFormBuilder
  Left = 0
  Top = 0
  Caption = 'Nemp: Customize main window'
  ClientHeight = 619
  ClientWidth = 870
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    870
    619)
  PixelsPerInch = 96
  TextHeight = 13
  object ___FormSimulatorPanel: TPanel
    Left = 8
    Top = 8
    Width = 640
    Height = 554
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvLowered
    BevelKind = bkFlat
    BevelOuter = bvSpace
    BevelWidth = 3
    TabOrder = 0
    StyleElements = []
    object __MainContainer: TPanel
      Left = 6
      Top = 6
      Width = 624
      Height = 490
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      StyleElements = []
      object MainSplitter: TSplitter
        Left = 0
        Top = 248
        Width = 624
        Height = 3
        Cursor = crVSplit
        Align = alTop
        MinSize = 100
        ResizeStyle = rsUpdate
        OnCanResize = SplitterTopCanResize
        OnMoved = MainSplitterMoved
        ExplicitLeft = 1
        ExplicitTop = 209
        ExplicitWidth = 95
      end
      object _BottomMainPanel: TPanel
        Left = 0
        Top = 251
        Width = 624
        Height = 239
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object SplitterBottom: TSplitter
          Left = 232
          Top = 0
          Height = 239
          MinSize = 100
          ResizeStyle = rsUpdate
          OnCanResize = SplitterTopCanResize
          OnMoved = SplitterTopMoved
          ExplicitLeft = 264
          ExplicitTop = 72
          ExplicitHeight = 100
        end
        object BlockMedialist: TPanel
          Left = 0
          Top = 0
          Width = 232
          Height = 239
          Align = alLeft
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 0
          StyleElements = []
          OnResize = BlockMedialistResize
          object HeaderMedialist: TPanel
            Left = 0
            Top = 0
            Width = 228
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentMedialist: TPanel
            Left = 0
            Top = 17
            Width = 228
            Height = 218
            Align = alClient
            Caption = 'Medialist'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockMedialistResize
            DesignSize = (
              228
              218)
            object ImgMediaListDown: TImage
              Left = 96
              Top = 190
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 212
            end
            object ImgMediaListLeft: TImage
              Left = 4
              Top = 104
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgMediaListRight: TImage
              Left = 198
              Top = 104
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
              ExplicitLeft = 202
            end
            object ImgMediaListUp: TImage
              Left = 96
              Top = 4
              Width = 24
              Height = 24
              OnClick = ImgUpClick
            end
          end
        end
        object BlockFileOverview: TPanel
          Left = 235
          Top = 0
          Width = 389
          Height = 239
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 1
          StyleElements = []
          OnResize = BlockFileOverviewResize
          object HeaderFileOverview: TPanel
            Left = 0
            Top = 0
            Width = 385
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentFileOverview: TPanel
            Left = 0
            Top = 17
            Width = 385
            Height = 218
            Align = alClient
            Caption = 'File overview'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockFileOverviewResize
            DesignSize = (
              385
              218)
            object ImgFileOverviewDown: TImage
              Left = 184
              Top = 190
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 212
            end
            object ImgFileOverviewLeft: TImage
              Left = 4
              Top = 104
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgFileOverviewRight: TImage
              Left = 356
              Top = 112
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
              ExplicitLeft = 431
            end
            object ImgFileOverviewUp: TImage
              Left = 120
              Top = 4
              Width = 24
              Height = 24
              OnClick = ImgUpClick
            end
          end
        end
      end
      object _TopMainPanel: TPanel
        Left = 0
        Top = 0
        Width = 624
        Height = 248
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object SplitterTop: TSplitter
          Left = 280
          Top = 0
          Height = 248
          MinSize = 100
          ResizeStyle = rsUpdate
          OnCanResize = SplitterTopCanResize
          OnMoved = SplitterTopMoved
          ExplicitLeft = 321
          ExplicitTop = 17
          ExplicitHeight = 246
        end
        object BlockBrowse: TPanel
          Left = 0
          Top = 0
          Width = 280
          Height = 248
          Align = alLeft
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 0
          StyleElements = []
          OnResize = BlockBrowseResize
          object HeaderBrowse: TPanel
            Left = 0
            Top = 0
            Width = 276
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentBrowse: TPanel
            Left = 0
            Top = 17
            Width = 276
            Height = 227
            Align = alClient
            Caption = 'Coverflow'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockBrowseResize
            DesignSize = (
              276
              227)
            object ImgCoverFlowDown: TImage
              Left = 112
              Top = 198
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 217
            end
            object ImgCoverFlowLeft: TImage
              Left = 4
              Top = 112
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgCoverFlowRight: TImage
              Left = 246
              Top = 112
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
              ExplicitLeft = 250
            end
            object ImgCoverFlowUp: TImage
              Left = 112
              Top = 4
              Width = 24
              Height = 24
              OnClick = ImgUpClick
            end
          end
        end
        object BlockPlaylist: TPanel
          Left = 283
          Top = 0
          Width = 341
          Height = 248
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 1
          StyleElements = []
          OnResize = BlockPlaylistResize
          object HeaderPlaylist: TPanel
            Left = 0
            Top = 0
            Width = 337
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentPlaylist: TPanel
            Left = 0
            Top = 17
            Width = 337
            Height = 227
            Align = alClient
            Caption = 'Playlist'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockPlaylistResize
            DesignSize = (
              337
              227)
            object ImgPlaylistDown: TImage
              Left = 152
              Top = 198
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 217
            end
            object ImgPlaylistLeft: TImage
              Left = 4
              Top = 112
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgPlaylistRight: TImage
              Left = 308
              Top = 120
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
              ExplicitLeft = 320
            end
            object ImgPlaylistUp: TImage
              Left = 96
              Top = 4
              Width = 24
              Height = 24
              OnClick = ImgUpClick
            end
          end
        end
      end
    end
    object _ControlPanel: TPanel
      Left = 6
      Top = 496
      Width = 624
      Height = 48
      Align = alBottom
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Player Controls'
      TabOrder = 1
      StyleElements = []
    end
  end
  object GrpBoxSettings: TGroupBox
    Left = 663
    Top = 8
    Width = 185
    Height = 65
    Anchors = [akTop, akRight]
    Caption = 'Main Layout'
    TabOrder = 1
    object cbMainLayout: TComboBox
      Left = 16
      Top = 22
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = '2 Rows'
      OnChange = cbMainLayoutChange
      Items.Strings = (
        '2 Rows'
        '2 Columns')
    end
  end
  object Apply: TButton
    Left = 727
    Top = 586
    Width = 121
    Height = 25
    Hint = 'Assign the current layout to the Nemp window'
    Anchors = [akRight, akBottom]
    Caption = 'Apply'
    TabOrder = 2
    OnClick = ApplyClick
  end
  object GroupBox1: TGroupBox
    Left = 663
    Top = 79
    Width = 185
    Height = 217
    Anchors = [akTop, akRight]
    Caption = 'Position of Player Controls'
    TabOrder = 3
    object LblSubPanelPosition: TLabel
      Left = 16
      Top = 159
      Width = 95
      Height = 13
      Caption = 'Position in SubPanel'
    end
    object cbControlPosition: TComboBox
      Left = 16
      Top = 21
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Top'
      OnChange = cbControlPositionChange
      Items.Strings = (
        'Top'
        'Center (if reasonable)'
        'Bottom'
        'Sub-Panel')
    end
    object RGrpControlSubPanel: TRadioGroup
      Left = 16
      Top = 48
      Width = 153
      Height = 105
      Caption = 'SubPanel for Controls'
      ItemIndex = 1
      Items.Strings = (
        'Cowerflow'
        'Playlist'
        'Medialist'
        'File Overview')
      TabOrder = 1
      OnClick = RGrpControlSubPanelClick
    end
    object cbControlPositionSubPanel: TComboBox
      Left = 16
      Top = 178
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemIndex = 1
      TabOrder = 2
      Text = 'Bottom'
      OnChange = cbControlPositionSubPanelChange
      Items.Strings = (
        'Top'
        'Bottom')
    end
  end
  object GroupBox2: TGroupBox
    Left = 663
    Top = 302
    Width = 185
    Height = 99
    Anchors = [akTop, akRight]
    Caption = 'Player Control Configuration'
    TabOrder = 4
    object cbControlPanelRows: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = '2 rows instead of 1'
      TabOrder = 0
      OnClick = cbControlPanelRowsClick
    end
    object cbControlPanelShowCover: TCheckBox
      Left = 16
      Top = 47
      Width = 145
      Height = 17
      Caption = 'Show Cover'
      TabOrder = 1
      OnClick = cbControlPanelShowCoverClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 663
    Top = 407
    Width = 185
    Height = 122
    Anchors = [akTop, akRight]
    Caption = 'Other Options'
    TabOrder = 5
    object cbHideFileOverview: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Hide Block "File Overview"'
      TabOrder = 0
      OnClick = cbHideFileOverviewClick
    end
  end
  object BtnUndo: TButton
    Left = 589
    Top = 586
    Width = 121
    Height = 25
    Hint = 'Revert to current layout in the Nemp window'
    Anchors = [akRight, akBottom]
    Caption = 'Undo'
    TabOrder = 6
    OnClick = BtnUndoClick
  end
  object BtnResetToDefault: TButton
    Left = 453
    Top = 586
    Width = 121
    Height = 25
    Hint = 'Restore the default settings'
    Anchors = [akRight, akBottom]
    Caption = 'Reset to Default'
    TabOrder = 7
    OnClick = BtnResetToDefaultClick
  end
end
