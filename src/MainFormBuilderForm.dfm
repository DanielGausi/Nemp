object MainFormBuilder: TMainFormBuilder
  Left = 0
  Top = 0
  Caption = 'Nemp: Form designer'
  ClientHeight = 544
  ClientWidth = 825
  Color = clBtnFace
  Constraints.MinHeight = 540
  Constraints.MinWidth = 800
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
    825
    544)
  PixelsPerInch = 96
  TextHeight = 13
  object ___FormSimulatorPanel: TPanel
    Left = 8
    Top = 8
    Width = 611
    Height = 492
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
      Width = 595
      Height = 428
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      StyleElements = []
      object MainSplitter: TSplitter
        Left = 0
        Top = 248
        Width = 595
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
        Width = 595
        Height = 177
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object SplitterBottom: TSplitter
          Left = 232
          Top = 0
          Height = 177
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
          Height = 177
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
            Height = 156
            Align = alClient
            Caption = 'Medialist'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockMedialistResize
            DesignSize = (
              228
              156)
            object ImgMediaListDown: TImage
              Left = 96
              Top = 128
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 212
            end
            object ImgMediaListLeft: TImage
              Left = 4
              Top = 56
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgMediaListRight: TImage
              Left = 200
              Top = 48
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
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
          Width = 360
          Height = 177
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          TabOrder = 1
          StyleElements = []
          OnResize = BlockFileOverviewResize
          object HeaderFileOverview: TPanel
            Left = 0
            Top = 0
            Width = 356
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentFileOverview: TPanel
            Left = 0
            Top = 17
            Width = 356
            Height = 156
            Align = alClient
            Caption = 'File overview'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockFileOverviewResize
            DesignSize = (
              356
              156)
            object ImgFileOverviewDown: TImage
              Left = 184
              Top = 128
              Width = 24
              Height = 24
              Anchors = [akLeft, akBottom]
              OnClick = ImgDownClick
              ExplicitTop = 212
            end
            object ImgFileOverviewLeft: TImage
              Left = 1
              Top = 48
              Width = 24
              Height = 24
              OnClick = ImgLeftClick
            end
            object ImgFileOverviewRight: TImage
              Left = 327
              Top = 48
              Width = 24
              Height = 24
              Anchors = [akTop, akRight]
              OnClick = ImgRightClick
              ExplicitLeft = 357
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
        Width = 595
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
          Width = 312
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
            Width = 308
            Height = 17
            Align = alTop
            TabOrder = 0
          end
          object ContentPlaylist: TPanel
            Left = 0
            Top = 17
            Width = 308
            Height = 227
            Align = alClient
            Caption = 'Playlist'
            TabOrder = 1
            StyleElements = []
            OnResize = BlockPlaylistResize
            DesignSize = (
              308
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
              Left = 279
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
      Top = 434
      Width = 595
      Height = 48
      Align = alBottom
      BevelKind = bkFlat
      BevelOuter = bvNone
      Caption = 'Control panel'
      TabOrder = 1
      StyleElements = []
    end
  end
  object GrpBoxSettings: TGroupBox
    Left = 632
    Top = 8
    Width = 185
    Height = 65
    Anchors = [akTop, akRight]
    Caption = 'Main layout'
    TabOrder = 1
    object cbMainLayout: TComboBox
      Left = 16
      Top = 22
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Two Rows'
      OnChange = cbMainLayoutChange
      Items.Strings = (
        'Two Rows'
        'Two Columns')
    end
  end
  object BtnApply: TButton
    Left = 721
    Top = 511
    Width = 96
    Height = 25
    Hint = 'Assign the current layout to the Nemp window'
    Anchors = [akRight, akBottom]
    Caption = 'Apply'
    TabOrder = 2
    OnClick = BtnApplyClick
  end
  object GroupBox1: TGroupBox
    Left = 632
    Top = 79
    Width = 185
    Height = 217
    Anchors = [akTop, akRight]
    Caption = 'Position of control panel'
    TabOrder = 3
    object LblSubPanelPosition: TLabel
      Left = 16
      Top = 159
      Width = 94
      Height = 13
      Caption = 'Position in subpanel'
    end
    object cbControlPosition: TComboBox
      Left = 16
      Top = 21
      Width = 153
      Height = 21
      Style = csDropDownList
      ItemIndex = 2
      TabOrder = 0
      Text = 'Bottom'
      OnChange = cbControlPositionChange
      Items.Strings = (
        'Top'
        'Center (if reasonable)'
        'Bottom'
        'Subpanel')
    end
    object RGrpControlSubPanel: TRadioGroup
      Left = 16
      Top = 48
      Width = 153
      Height = 105
      Caption = 'Subpanel for control panel'
      ItemIndex = 1
      Items.Strings = (
        'Cowerflow'
        'Playlist'
        'Medialist'
        'File overview')
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
    Left = 632
    Top = 302
    Width = 185
    Height = 75
    Anchors = [akTop, akRight]
    Caption = 'Control panel configuration'
    TabOrder = 4
    object cbControlPanelRows: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Two rows instead of one'
      TabOrder = 0
      OnClick = cbControlPanelRowsClick
    end
    object cbControlPanelShowCover: TCheckBox
      Left = 16
      Top = 47
      Width = 145
      Height = 17
      Caption = 'Show cover'
      TabOrder = 1
      OnClick = cbControlPanelShowCoverClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 632
    Top = 383
    Width = 185
    Height = 58
    Anchors = [akTop, akRight]
    Caption = 'Other settings'
    TabOrder = 5
    object cbHideFileOverview: TCheckBox
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = 'Hide block "File overview"'
      TabOrder = 0
      OnClick = cbHideFileOverviewClick
    end
  end
  object BtnUndo: TButton
    Left = 617
    Top = 511
    Width = 96
    Height = 25
    Hint = 'Revert to current layout in the Nemp window'
    Anchors = [akRight, akBottom]
    Caption = 'Undo'
    TabOrder = 6
    OnClick = BtnUndoClick
  end
  object BtnResetToDefault: TButton
    Left = 8
    Top = 511
    Width = 125
    Height = 25
    Hint = 'Restore the default settings'
    Anchors = [akLeft, akBottom]
    Caption = 'Reset to default'
    TabOrder = 7
    OnClick = BtnResetToDefaultClick
  end
  object BtnOK: TButton
    Left = 507
    Top = 511
    Width = 96
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 8
    OnClick = BtnOKClick
  end
end
