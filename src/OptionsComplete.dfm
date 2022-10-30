object OptionsCompleteForm: TOptionsCompleteForm
  Left = 968
  Top = 125
  HelpContext = 30
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 676
  ClientWidth = 684
  Color = clWindow
  Constraints.MinHeight = 520
  Constraints.MinWidth = 594
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClick = BtnHelpClick
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 678
    Height = 632
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object OptionsVST: TVirtualStringTree
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 203
      Height = 626
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      BorderWidth = 1
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DefaultNodeHeight = 36
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.AutoSizeIndex = 0
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages]
      Images = ImageList1
      Indent = 8
      ParentFont = False
      ScrollBarOptions.ScrollBars = ssNone
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toVariableNodeHeight, toEditOnClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnFocusChanged = OptionsVSTFocusChanged
      OnGetText = OptionsVSTGetText
      OnPaintText = OptionsVSTPaintText
      OnGetImageIndex = OptionsVSTGetImageIndex
      OnMeasureTextWidth = OptionsVSTMeasureTextWidth
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <
        item
          Position = 0
          Width = 201
        end>
    end
    object PageControl1: TPageControl
      Left = 209
      Top = 0
      Width = 469
      Height = 632
      ActivePage = tabBirthday
      Align = alClient
      MultiLine = True
      TabOrder = 1
      TabStop = False
      object tabGeneral: TTabSheet
        Caption = 'General'
        object cpgMainOptions: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpUpdateThread_FAILSAFE: TCategoryPanel
            Top = 808
            Height = 80
            Caption = 'Failsafe'
            TabOrder = 4
            Visible = False
            ExplicitWidth = 457
            object XXX_CB_BetaDontUseThreadedUpdate: TCheckBox
              Left = 16
              Top = 16
              Width = 417
              Height = 17
              Hint = 'Beta-Settings. Do not change, unless you know what yo are doing!'
              Caption = 'Update library in Mainthread'
              TabOrder = 0
            end
          end
          object cpHibernate: TCategoryPanel
            Top = 680
            Height = 128
            Caption = 'Hibernate/standby'
            TabOrder = 3
            ExplicitWidth = 457
            object Btn_ReinitPlayerEngine: TButton
              Left = 16
              Top = 59
              Width = 197
              Height = 25
              Hint = 'Reinit player engine now.'
              Caption = 'Reinit player engine now'
              TabOrder = 2
              OnClick = Btn_ReinitPlayerEngineClick
            end
            object cbPauseOnSuspend: TCheckBox
              Left = 16
              Top = 13
              Width = 397
              Height = 17
              Hint = 
                'Stop the player when the system hibernates, so the playback is s' +
                'topped when the PC is turned on again.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Stop player when system hibernates'
              Checked = True
              State = cbChecked
              TabOrder = 0
            end
            object cbReInitAfterSuspend: TCheckBox
              Left = 16
              Top = 36
              Width = 397
              Height = 17
              Hint = 
                'Use this, if the playback don'#39't work after hibernating the syste' +
                'm.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Reinitialize player engine on wakeup'
              TabOrder = 1
            end
          end
          object cpNempUpdates: TCategoryPanel
            Top = 520
            Height = 160
            Caption = 'Search for Updates'
            TabOrder = 2
            object Btn_CHeckNowForUpdates: TButton
              Left = 16
              Top = 92
              Width = 161
              Height = 25
              Caption = 'Check now'
              TabOrder = 3
              OnClick = Btn_CHeckNowForUpdatesClick
            end
            object CB_AutoCheck: TCheckBox
              Left = 16
              Top = 16
              Width = 401
              Height = 17
              Hint = 
                'Check for updates and show a message if a newer version is avail' +
                'able'
              Caption = 'Automatically check for new versions of Nemp'
              TabOrder = 0
              OnClick = CB_AutoCheckClick
            end
            object CB_AutoCheckNotifyOnBetas: TCheckBox
              Left = 16
              Top = 67
              Width = 409
              Height = 17
              Hint = 
                'Notify on Beta-releases. As Beta-software is normally instable, ' +
                'this is recommended for advanced users only.'
              Caption = 'Notify on Beta-releases'
              TabOrder = 2
            end
            object CBBOX_UpdateInterval: TComboBox
              Left = 16
              Top = 39
              Width = 177
              Height = 21
              Style = csDropDownList
              ItemIndex = 2
              TabOrder = 1
              Text = 'Weekly'
              Items.Strings = (
                'On every start'
                'Daily'
                'Weekly'
                'Bi-weekly'
                'Monthly')
            end
          end
          object cpPortable: TCategoryPanel
            Top = 340
            Height = 180
            Caption = 'Nemp portable'
            TabOrder = 1
            ExplicitWidth = 457
            object lblNempPortable: TLabel
              Left = 16
              Top = 113
              Width = 420
              Height = 44
              AutoSize = False
              Caption = 
                'If you want to use Nemp only on one device, then these settings ' +
                'have no effect. Please refer to the documentation for more infor' +
                'mation.'
              WordWrap = True
            end
            object lblNempPortable1: TLabel
              Left = 16
              Top = 16
              Width = 410
              Height = 57
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'If you want to use Nemp and the media library on multiple device' +
                's, then Nemp has to consider some things when managing the files' +
                '. Please choose the way you share the media library on your devi' +
                'ces.'
              WordWrap = True
              ExplicitWidth = 433
            end
            object cb_EnableCloudMode: TCheckBox
              Left = 16
              Top = 84
              Width = 378
              Height = 17
              Hint = 
                'Use relative paths in the library, if you use Nemp in a cloud dr' +
                'ive on different computers'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Enable cloud mode'
              TabOrder = 1
            end
            object cb_EnableUSBMode: TCheckBox
              Left = 16
              Top = 61
              Width = 378
              Height = 17
              Hint = 
                'Nemp will try to adjust drive letters, when USB drives with your' +
                ' music are used at different computers.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Enable USB mode'
              TabOrder = 0
            end
          end
          object cpStarting: TCategoryPanel
            Top = 0
            Height = 340
            Caption = 'Starting Nemp'
            TabOrder = 0
            ExplicitWidth = 457
            object lblNempStartPlayer: TLabel
              Left = 16
              Top = 16
              Width = 95
              Height = 14
              Caption = 'Player and Playlist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblNempStartLibrary: TLabel
              Left = 16
              Top = 129
              Width = 66
              Height = 14
              Caption = 'Media library'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblNempStartSystem: TLabel
              Left = 16
              Top = 200
              Width = 50
              Height = 14
              Caption = 'Windows'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object CB_AllowMultipleInstances: TCheckBox
              Left = 16
              Top = 240
              Width = 397
              Height = 17
              Hint = 'Allow multiple instances of Nemp.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Allow multiple instances'
              TabOrder = 7
            end
            object CB_AutoPlayEnqueueTitle: TCheckBox
              Left = 16
              Top = 96
              Width = 390
              Height = 17
              Hint = 
                'Stop playback of the current file, when the user double-clicks a' +
                ' new file in the Windows explorer'
              Anchors = [akLeft, akTop, akRight]
              Caption = 
                'Switch to enqueued file (even if another track is already playin' +
                'g)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
            end
            object CB_AutoPlayNewTitle: TCheckBox
              Left = 16
              Top = 76
              Width = 390
              Height = 17
              Hint = 
                'When starting Nemp by double-clicking a file in the Windows-Expl' +
                'orer: Use this file instead of the last one.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'If applicable: Start playback with new file'
              TabOrder = 2
            end
            object CB_AutoPlayOnStart: TCheckBox
              Left = 16
              Top = 36
              Width = 390
              Height = 17
              Hint = 'Automatically begin playback when Nemp starts'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Begin playback on start'
              TabOrder = 0
              OnClick = CB_AutoPlayOnStartClick
            end
            object CB_SavePositionInTrack: TCheckBox
              Left = 16
              Top = 56
              Width = 390
              Height = 17
              Hint = 'Begin playback at the last known position within the track'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Remember last track position'
              TabOrder = 1
            end
            object CBAutoLoadMediaList: TCheckBox
              Left = 16
              Top = 149
              Width = 397
              Height = 17
              Hint = 'Automatically load the Nemp medialibrary.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Load media library on start'
              TabOrder = 4
            end
            object CBAutoSaveMediaList: TCheckBox
              Left = 16
              Top = 169
              Width = 397
              Height = 17
              Hint = 'Automatically save the Nemp medialibrary.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Save media library on close'
              TabOrder = 5
            end
            object CB_StartMinimized: TCheckBox
              Left = 16
              Top = 260
              Width = 397
              Height = 17
              Hint = 'Do not show Nemp window on start - directly minimize it.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Start minimized (you can also use the parameter "/minimized")'
              TabOrder = 8
            end
            object cb_ShowSplashScreen: TCheckBox
              Left = 16
              Top = 220
              Width = 397
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Show splash screen'
              TabOrder = 6
            end
            object cbShowTrayIcon: TCheckBox
              Left = 16
              Top = 280
              Width = 397
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Show tray icon'
              TabOrder = 9
            end
          end
        end
      end
      object tabControl: TTabSheet
        Caption = 'Controls'
        ImageIndex = 1
        object cpgControlSettings: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpTabulatorKeys: TCategoryPanel
            Top = 405
            Height = 100
            Caption = 'Tabulator key'
            TabOrder = 2
            object CB_TabStopAtPlayerControls: TCheckBox
              Left = 16
              Top = 13
              Width = 401
              Height = 17
              Caption = 'Tabstop at player controls'
              TabOrder = 0
            end
            object CB_TabStopAtTabs: TCheckBox
              Left = 16
              Top = 36
              Width = 401
              Height = 17
              Caption = 'Tabstop at tool buttons (cover, lyrics, ...)'
              TabOrder = 1
            end
          end
          object cpHotkeys: TCategoryPanel
            Top = 120
            Height = 285
            Caption = 'Global Hotkeys'
            TabOrder = 1
            object CB_Activate_DecVol: TCheckBox
              Left = 34
              Top = 200
              Width = 135
              Height = 17
              Caption = 'Decrease volume'
              Checked = True
              State = cbChecked
              TabOrder = 22
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_IncVol: TCheckBox
              Left = 34
              Top = 177
              Width = 135
              Height = 17
              Caption = 'Increase volume'
              Checked = True
              State = cbChecked
              TabOrder = 19
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_JumpBack: TCheckBox
              Left = 34
              Top = 154
              Width = 135
              Height = 17
              Caption = 'Slide backwards'
              Checked = True
              State = cbChecked
              TabOrder = 16
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_JumpForward: TCheckBox
              Left = 34
              Top = 131
              Width = 135
              Height = 17
              Caption = 'Slide forward'
              Checked = True
              State = cbChecked
              TabOrder = 13
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_Mute: TCheckBox
              Left = 34
              Top = 223
              Width = 135
              Height = 17
              Caption = 'mute/unmute'
              Checked = True
              State = cbChecked
              TabOrder = 25
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_Next: TCheckBox
              Left = 34
              Top = 85
              Width = 135
              Height = 17
              Caption = 'Next title'
              Checked = True
              State = cbChecked
              TabOrder = 7
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_Play: TCheckBox
              Left = 34
              Top = 39
              Width = 135
              Height = 17
              Caption = 'Play/Pause'
              Checked = True
              State = cbChecked
              TabOrder = 1
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_Prev: TCheckBox
              Left = 34
              Top = 108
              Width = 135
              Height = 17
              Caption = 'Previous title'
              Checked = True
              State = cbChecked
              TabOrder = 10
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Activate_Stop: TCheckBox
              Left = 34
              Top = 62
              Width = 135
              Height = 17
              Caption = 'Stop'
              Checked = True
              State = cbChecked
              TabOrder = 4
              OnClick = CBRegisterHotKeysClick
            end
            object CB_Key_DecVol: TComboBox
              Left = 290
              Top = 200
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 24
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_IncVol: TComboBox
              Left = 290
              Top = 177
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 21
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_JumpBack: TComboBox
              Left = 290
              Top = 154
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 18
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_JumpForward: TComboBox
              Left = 290
              Top = 131
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 15
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_Mute: TComboBox
              Left = 290
              Top = 223
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 27
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_Next: TComboBox
              Left = 290
              Top = 85
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 9
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_Play: TComboBox
              Left = 290
              Top = 39
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 3
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_Prev: TComboBox
              Left = 290
              Top = 108
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 12
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Key_Stop: TComboBox
              Left = 290
              Top = 62
              Width = 65
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 6
              Text = 'A'
              Items.Strings = (
                'A'
                'B'
                'C'
                'D'
                'E'
                'F'
                'G'
                'H'
                'I'
                'J'
                'K'
                'L'
                'M'
                'N'
                'O'
                'P'
                'Q'
                'R'
                'S'
                'T'
                'U'
                'V'
                'W'
                'X'
                'Y'
                'Z'
                '0'
                '1'
                '2'
                '3'
                '4'
                '5'
                '6'
                '7'
                '8'
                '9'
                '+'
                '-'
                'F1'
                'F2'
                'F3'
                'F5'
                'F5'
                'F6'
                'F7'
                'F8'
                'F9'
                'F10'
                'F11'
                'F12')
            end
            object CB_Mod_DecVol: TComboBox
              Left = 178
              Top = 200
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 23
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_IncVol: TComboBox
              Left = 178
              Top = 177
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 20
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_JumpBack: TComboBox
              Left = 178
              Top = 154
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 17
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_JumpForward: TComboBox
              Left = 178
              Top = 131
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 14
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_Mute: TComboBox
              Left = 178
              Top = 223
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 26
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_Next: TComboBox
              Left = 178
              Top = 85
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 8
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_Play: TComboBox
              Left = 178
              Top = 39
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 2
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_Prev: TComboBox
              Left = 178
              Top = 108
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 11
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CB_Mod_Stop: TComboBox
              Left = 178
              Top = 62
              Width = 97
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 5
              Text = 'Alt + Ctrl'
              Items.Strings = (
                'Alt + Ctrl'
                'Alt + Shift'
                'Ctrl + Shift')
            end
            object CBRegisterHotKeys: TCheckBox
              Left = 16
              Top = 16
              Width = 377
              Height = 17
              Hint = 
                'Install global hotkeys. You should use some values that are not ' +
                'used as shortcuts by your favorite software.'
              Caption = 'Install global hotkeys'
              TabOrder = 0
              OnClick = CBRegisterHotKeysClick
            end
          end
          object cpMediaKeys: TCategoryPanel
            Top = 0
            Height = 120
            Caption = 'Media keys'
            TabOrder = 0
            object CB_IgnoreVolume: TCheckBox
              Left = 16
              Top = 36
              Width = 413
              Height = 17
              Hint = 
                'If checked, Nemp will ignore volume keys, to allow global volume' +
                ' control by these keys.'
              Caption = 'Use volume up/down keys for system-wide volume control'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object cb_RegisterMediaHotkeys: TCheckBox
              Left = 16
              Top = 16
              Width = 413
              Height = 17
              Caption = 'Use media keys, even if Nemp is in the background'
              TabOrder = 0
            end
            object cb_UseG15Display: TCheckBox
              Left = 16
              Top = 56
              Width = 401
              Height = 17
              Caption = 
                'Use keyboard display (Logitech G15 keyboard or compatible requir' +
                'ed)'
              TabOrder = 2
            end
          end
        end
      end
      object tabViewingSettings: TTabSheet
        Caption = 'View'
        ImageIndex = 6
        object cpgViewingSettings: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpExtendedViewingSettings: TCategoryPanel
            Top = 905
            Height = 175
            Caption = 'Extended viewing settings'
            TabOrder = 0
            ExplicitWidth = 457
            object cb_limitMarkerToCurrentFiles: TCheckBox
              Left = 16
              Top = 56
              Width = 402
              Height = 17
              Caption = 'Show marked files only from the current preselection'
              TabOrder = 2
            end
            object CBAlwaysSortAnzeigeList: TCheckBox
              Left = 16
              Top = 16
              Width = 402
              Height = 17
              Hint = 'Always sort the displayed files in the library.'
              Caption = 'Always sort view (slower)'
              TabOrder = 0
              OnClick = CBAlwaysSortAnzeigeListClick
            end
            object CBSkipSortOnLargeLists: TCheckBox
              Left = 16
              Top = 36
              Width = 402
              Height = 17
              Hint = 'Skip this sorting when the list is too large.'
              Caption = 'Skip sort on large lists (> 5000)'
              TabOrder = 1
            end
            object CB_ShowHintsInPlaylist: TCheckBox
              Left = 16
              Top = 96
              Width = 402
              Height = 17
              Hint = 'Show hints in the playlist or not.'
              Caption = 'Show hints in playlist'
              TabOrder = 4
            end
            object CBFullRowSelect: TCheckBox
              Left = 16
              Top = 116
              Width = 402
              Height = 17
              Hint = 'Select full row or just a single cell in the library.'
              Caption = 'Select full row in media list'
              TabOrder = 5
            end
            object CBShowHintsInMedialist: TCheckBox
              Left = 16
              Top = 76
              Width = 402
              Height = 17
              Hint = 'Show hints in the library or not.'
              Caption = 'Show hints in the media list'
              TabOrder = 3
            end
          end
          object cpPlaylistFormatting: TCategoryPanel
            Top = 715
            Height = 190
            Caption = 'Playlist formatting'
            TabOrder = 1
            object lblPlaylistTitle: TLabel
              Left = 16
              Top = 16
              Width = 125
              Height = 13
              AutoSize = False
              Caption = 'Regular title'
            end
            object lblPlaylistTitleCueAlbum: TLabel
              Left = 16
              Top = 60
              Width = 125
              Height = 13
              AutoSize = False
              Caption = 'Cue (Album)'
            end
            object lblPlaylistTitleCueTitle: TLabel
              Left = 16
              Top = 82
              Width = 125
              Height = 13
              AutoSize = False
              Caption = 'Cue (Title)'
            end
            object lblPlaylistTitleFB: TLabel
              Left = 16
              Top = 38
              Width = 125
              Height = 13
              AutoSize = False
              Caption = 'Regular title (fallback)'
            end
            object lblPlaylistWebradioTitle: TLabel
              Left = 16
              Top = 104
              Width = 125
              Height = 13
              AutoSize = False
              Caption = 'Webradio'
            end
            object cb_ShowIndexInTreeview: TCheckBox
              Left = 16
              Top = 128
              Width = 409
              Height = 17
              Caption = 'Show column "Index"'
              TabOrder = 5
            end
            object cbPlaylistTitle: TComboBox
              AlignWithMargins = True
              Left = 168
              Top = 11
              Width = 250
              Height = 21
              AutoComplete = False
              Color = clBtnFace
              ItemIndex = 0
              TabOrder = 0
              Text = '<artist> - <title>'
              Items.Strings = (
                '<artist> - <title>'
                '<artist> - <title> (<year>)'
                '<artist> - <title> (<album>)'
                '<artist> - <title> (<album>, Track <track>)'
                '<artist> - <title> (Track <track>)'
                '<artist> - <album>'
                '<filename>'
                '<subdir>\<filename>'
                '<fullpath>')
            end
            object cbPlaylistTitleCueAlbum: TComboBox
              AlignWithMargins = True
              Left = 168
              Top = 57
              Width = 250
              Height = 21
              AutoComplete = False
              Color = clBtnFace
              ItemIndex = 5
              TabOrder = 2
              Text = '<artist> - <album>'
              Items.Strings = (
                '<artist> - <title>'
                '<artist> - <title> (<year>)'
                '<artist> - <title> (<album>)'
                '<artist> - <title> (<album>, Track <track>)'
                '<artist> - <title> (Track <track>)'
                '<artist> - <album>'
                '<filename>'
                '<subdir>\<filename>'
                '<fullpath>')
            end
            object cbPlaylistTitleCueTitle: TComboBox
              AlignWithMargins = True
              Left = 168
              Top = 79
              Width = 250
              Height = 21
              AutoComplete = False
              Color = clBtnFace
              ItemIndex = 4
              TabOrder = 3
              Text = '<artist> - <title> (Track <track>)'
              Items.Strings = (
                '<artist> - <title>'
                '<artist> - <title> (<year>)'
                '<artist> - <title> (<album>)'
                '<artist> - <title> (<album>, Track <track>)'
                '<artist> - <title> (Track <track>)'
                '<artist> - <album>'
                '<filename>'
                '<subdir>\<filename>'
                '<fullpath>')
            end
            object cbPlaylistTitleFB: TComboBox
              AlignWithMargins = True
              Left = 168
              Top = 35
              Width = 250
              Height = 21
              AutoComplete = False
              Color = clBtnFace
              ItemIndex = 2
              TabOrder = 1
              Text = '<artist> - <title> (<album>)'
              Items.Strings = (
                '<artist> - <title>'
                '<artist> - <title> (<year>)'
                '<artist> - <title> (<album>)'
                '<artist> - <title> (<album>, Track <track>)'
                '<artist> - <title> (Track <track>)'
                '<artist> - <album>'
                '<filename>'
                '<subdir>\<filename>'
                '<fullpath>')
            end
            object cbPlaylistWebradioTitle: TComboBox
              AlignWithMargins = True
              Left = 168
              Top = 101
              Width = 250
              Height = 21
              AutoComplete = False
              Color = clBtnFace
              ItemIndex = 0
              TabOrder = 4
              Text = '<station>: <title>'
              Items.Strings = (
                '<station>: <title>'
                '<title>')
            end
          end
          object cpMissingMetaData: TCategoryPanel
            Top = 293
            Height = 422
            Caption = 'Not available metadata'
            TabOrder = 2
            object LblReplaceAlbumBy: TLabel
              Left = 16
              Top = 126
              Width = 201
              Height = 13
              AutoSize = False
              Caption = 'Album'
            end
            object LblReplaceArtistBy: TLabel
              Left = 16
              Top = 36
              Width = 201
              Height = 13
              AutoSize = False
              Caption = 'Artist'
            end
            object LblReplaceTitletBy: TLabel
              Left = 16
              Top = 81
              Width = 201
              Height = 13
              AutoSize = False
              Caption = 'Title'
            end
            object lblMissingMetaData: TLabel
              Left = 16
              Top = 16
              Width = 385
              Height = 13
              AutoSize = False
              Caption = 'If property ... is not available, display ... instead.'
              WordWrap = True
            end
            object img_DefaultCover: TImage
              Left = 16
              Top = 204
              Width = 137
              Height = 137
            end
            object lbl_DefaultCover: TLabel
              Left = 16
              Top = 181
              Width = 401
              Height = 17
              AutoSize = False
              Caption = 'Default cover (used when no proper cover art can be found.)'
              WordWrap = True
            end
            object lbl_DefaultCoverHint: TLabel
              Left = 16
              Top = 347
              Width = 401
              Height = 38
              AutoSize = False
              Caption = 
                'Note: Cover art already displayed in the player will not change ' +
                'until the cover art is loaded again.'
              WordWrap = True
            end
            object cbReplaceAlbumBy: TComboBox
              Left = 16
              Top = 144
              Width = 201
              Height = 21
              Style = csDropDownList
              ItemIndex = 3
              TabOrder = 2
              Text = 'Directory (last part)'
              Items.Strings = (
                '(Empty string)'
                #39'N/A'#39
                'Filename'
                'Directory (last part)'
                'Directory'
                'Complete path'
                'Filename(with extension)')
            end
            object cbReplaceArtistBy: TComboBox
              Left = 16
              Top = 54
              Width = 201
              Height = 21
              Style = csDropDownList
              ItemIndex = 2
              TabOrder = 0
              Text = 'Filename'
              Items.Strings = (
                '(Empty string)'
                #39'N/A'#39
                'Filename'
                'Directory (last part)'
                'Directory'
                'Complete path'
                'Filename(with extension)')
            end
            object cbReplaceTitleBy: TComboBox
              Left = 16
              Top = 99
              Width = 201
              Height = 21
              Style = csDropDownList
              ItemIndex = 2
              TabOrder = 1
              Text = 'Filename'
              Items.Strings = (
                '(Empty string)'
                #39'N/A'#39
                'Filename'
                'Directory (last part)'
                'Directory'
                'Complete path'
                'Filename(with extension)')
            end
            object btn_DefaultCover: TButton
              Left = 168
              Top = 204
              Width = 110
              Height = 25
              Hint = 'Select a file you want to use as cover art'
              Caption = 'Select'
              TabOrder = 3
              OnClick = btn_DefaultCoverClick
            end
            object btn_DefaultCoverReset: TButton
              Left = 168
              Top = 235
              Width = 110
              Height = 25
              Hint = 'Reset the default cover to the Nemp default cover'
              Caption = 'Reset'
              TabOrder = 4
              OnClick = btn_DefaultCoverResetClick
            end
          end
          object cpViewCategoriesSettings: TCategoryPanel
            Top = 200
            Height = 93
            Caption = 'Display of Albums, Directories, ...'
            TabOrder = 3
            ExplicitWidth = 457
            object cbShowCoverForAlbum: TCheckBox
              Left = 16
              Top = 16
              Width = 421
              Height = 17
              Caption = 'Show cover art for albums in tree view'
              TabOrder = 0
            end
            object cbShowElementCount: TCheckBox
              Left = 16
              Top = 36
              Width = 421
              Height = 17
              Caption = 'Show number of contained elements'
              TabOrder = 1
            end
          end
          object cpVisibleColumns: TCategoryPanel
            Top = 0
            Caption = 'Visible columns in the medialist'
            TabOrder = 4
            object clbViewMainColumns: TCheckListBox
              Left = 0
              Top = 0
              Width = 438
              Height = 174
              Align = alClient
              Columns = 3
              ItemHeight = 13
              Style = lbOwnerDrawFixed
              TabOrder = 0
              OnDrawItem = clbViewMainColumnsDrawItem
            end
          end
        end
      end
      object tabFontSizes: TTabSheet
        Caption = 'Fontsizes'
        ImageIndex = 7
        object cpgDisplaySettings: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          ChevronColor = clWindowText
          ChevronHotColor = clHighlightText
          Color = clWindow
          GradientBaseColor = clBtnFace
          GradientColor = clBtnShadow
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -13
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          ParentBackground = True
          TabOrder = 0
          object cpPartyMode: TCategoryPanel
            Top = 329
            Height = 255
            Caption = 'Party mode'
            TabOrder = 1
            object Lbl_PartyMode_ResizeFactor: TLabel
              Left = 16
              Top = 16
              Width = 92
              Height = 13
              Caption = 'Amplification factor'
            end
            object CB_PartyMode_ResizeFactor: TComboBox
              Left = 16
              Top = 35
              Width = 165
              Height = 21
              Style = csDropDownList
              ItemIndex = 1
              TabOrder = 0
              Text = '1.5 (moderate amplification)'
              Items.Strings = (
                '1 (no amplification)'
                '1.5 (moderate amplification)'
                '2 (double sized)'
                '2.5 (really huge)')
            end
            object cb_PartyMode_ShowPasswordOnActivate: TCheckBox
              Left = 16
              Top = 118
              Width = 409
              Height = 17
              Caption = 'Show password when activating the Nemp Party Mode'
              TabOrder = 2
            end
            object Edt_PartyModePassword: TLabeledEdit
              Left = 16
              Top = 91
              Width = 121
              Height = 21
              EditLabel.Width = 139
              EditLabel.Height = 13
              EditLabel.Caption = 'Password to exit Party-Mode'
              TabOrder = 1
              Text = ''
            end
            object cb_PartyMode_BlockCurrentTitleRating: TCheckBox
              Left = 16
              Top = 174
              Width = 409
              Height = 17
              Caption = 'Block rating of current title'
              TabOrder = 4
            end
            object cb_PartyMode_BlockTools: TCheckBox
              Left = 16
              Top = 194
              Width = 409
              Height = 17
              Caption = 'Block tools'
              TabOrder = 5
            end
            object cb_PartyMode_BlockTreeEdit: TCheckBox
              Left = 16
              Top = 154
              Width = 409
              Height = 17
              Caption = 'Block editing file information in the media list'
              TabOrder = 3
            end
          end
          object cpFontSettings: TCategoryPanel
            Top = 0
            Height = 329
            Caption = 'Font settings'
            TabOrder = 0
            object lblFontBrowselists: TLabel
              Left = 16
              Top = 16
              Width = 125
              Height = 14
              Caption = 'Tree view (categories)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label32: TLabel
              Left = 16
              Top = 36
              Width = 43
              Height = 13
              Caption = 'Font size'
              ParentShowHint = False
              ShowHint = True
            end
            object Label34: TLabel
              Left = 152
              Top = 36
              Width = 54
              Height = 13
              Caption = 'Row height'
            end
            object lbl_Browselist_FontStyle: TLabel
              Left = 262
              Top = 36
              Width = 48
              Height = 13
              Caption = 'Font style'
            end
            object lblFontPlaylistMedialist: TLabel
              Left = 16
              Top = 88
              Width = 109
              Height = 14
              Caption = 'Playlist and medialist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lbl_Medialist_FontStyle: TLabel
              Left = 262
              Top = 108
              Width = 48
              Height = 13
              Caption = 'Font style'
            end
            object LblConst_BasicFontSize: TLabel
              Left = 16
              Top = 108
              Width = 43
              Height = 13
              Caption = 'Font size'
              ParentShowHint = False
              ShowHint = True
            end
            object LblConst_RowHeight: TLabel
              Left = 152
              Top = 108
              Width = 54
              Height = 13
              Caption = 'Row height'
            end
            object LblConst_FontCBR: TLabel
              Left = 226
              Top = 250
              Width = 119
              Height = 13
              Caption = 'Font for constant bitrate'
            end
            object LblConst_FontVBR: TLabel
              Left = 35
              Top = 252
              Width = 115
              Height = 13
              Caption = 'Font for variable bitrate'
            end
            object cb_Browselist_FontStyle: TComboBox
              Left = 262
              Top = 55
              Width = 129
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 2
              Text = 'normal'
              Items.Strings = (
                'normal'
                'bold'
                'italic'
                'bold italic')
            end
            object SEArtistAlbenRowHeight: TSpinEdit
              Left = 152
              Top = 52
              Width = 49
              Height = 22
              MaxValue = 144
              MinValue = 4
              TabOrder = 1
              Value = 16
            end
            object SEArtistAlbenSIze: TSpinEdit
              Left = 16
              Top = 53
              Width = 49
              Height = 22
              MaxValue = 72
              MinValue = 4
              TabOrder = 0
              Value = 16
            end
            object cb_Medialist_FontStyle: TComboBox
              Left = 262
              Top = 124
              Width = 129
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 5
              Text = 'normal'
              Items.Strings = (
                'normal'
                'bold'
                'italic'
                'bold italic')
            end
            object SEFontSize: TSpinEdit
              Left = 16
              Top = 127
              Width = 49
              Height = 22
              MaxValue = 72
              MinValue = 4
              TabOrder = 3
              Value = 8
            end
            object SERowHeight: TSpinEdit
              Left = 152
              Top = 124
              Width = 49
              Height = 22
              MaxValue = 144
              MinValue = 4
              TabOrder = 4
              Value = 16
            end
            object CBChangeFontColoronBitrate: TCheckBox
              Left = 16
              Top = 210
              Width = 400
              Height = 17
              Hint = 'Use different colors for different bitrates.'
              Caption = 'Change font color according to bitrate'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 8
              WordWrap = True
            end
            object CBChangeFontOnCbrVbr: TCheckBox
              Left = 16
              Top = 229
              Width = 400
              Height = 17
              Hint = 'Use different fonts for files with fixed or variable bitrate.'
              Caption = 'Change font according to constant/variable bitrate'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 9
              WordWrap = True
              OnClick = CBChangeFontOnCbrVbrClick
            end
            object CBChangeFontSizeOnLength: TCheckBox
              Left = 16
              Top = 191
              Width = 400
              Height = 17
              Hint = 
                'User bigger fonts for long tracks and smaller ones for short tra' +
                'cks.'
              Caption = 'Change font size according to track length'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 7
              WordWrap = True
            end
            object CBChangeFontStyleOnMode: TCheckBox
              Left = 16
              Top = 172
              Width = 400
              Height = 17
              Hint = 'Normal: Joint Stereo, Bold: Full Stereo, Italic: Mono'
              Caption = 'Change font style according to channel mode'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 6
              WordWrap = True
            end
            object CBFontNameCBR: TComboBox
              Left = 226
              Top = 269
              Width = 161
              Height = 21
              Style = csDropDownList
              TabOrder = 11
            end
            object CBFontNameVBR: TComboBox
              Left = 35
              Top = 269
              Width = 161
              Height = 21
              Style = csDropDownList
              TabOrder = 10
            end
          end
        end
      end
      object tabFileManagement: TTabSheet
        Caption = 'Filemanagement'
        ImageIndex = 4
        object cpgFileManagement: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpLibraryCoverArt: TCategoryPanel
            Top = 495
            Height = 280
            Caption = 'Cover art'
            TabOrder = 2
            object lblSearchCoverArt: TLabel
              Left = 16
              Top = 16
              Width = 106
              Height = 13
              Caption = 'Search cover art in ...'
            end
            object lblCoverArtQuality: TLabel
              Left = 16
              Top = 128
              Width = 188
              Height = 13
              Caption = 'Quality of cover art in the media library'
            end
            object CB_CoverSearch_inDir: TCheckBox
              Left = 16
              Top = 34
              Width = 201
              Height = 17
              Hint = 'Search for coverfiles within the directory of the audiofile'
              Caption = 'Directory itself'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
            end
            object CB_CoverSearch_inParentDir: TCheckBox
              Left = 16
              Top = 54
              Width = 201
              Height = 17
              Hint = 'Search for coverfiles in the parent directory of the audiofile.'
              Caption = 'Parent directory'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
            end
            object CB_CoverSearch_inSisterDir: TCheckBox
              Left = 16
              Top = 94
              Width = 201
              Height = 17
              Hint = 
                'Search for coverfiles in the specified subdirectory of the paren' +
                't directory.'
              Caption = 'Sister directory (name)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = CB_CoverSearch_inSisterDirClick
            end
            object CB_CoverSearch_inSubDir: TCheckBox
              Left = 16
              Top = 74
              Width = 201
              Height = 17
              Hint = 'Search for coverfiles in the specified subdirectory.'
              Caption = 'Subdirectory (name)'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = CB_CoverSearch_inSubDirClick
            end
            object EDTCoverSisterDirName: TEdit
              Left = 223
              Top = 94
              Width = 105
              Height = 21
              TabOrder = 5
              Text = 'cover'
            end
            object EDTCoverSubDirName: TEdit
              Left = 223
              Top = 74
              Width = 105
              Height = 21
              TabOrder = 3
              Text = 'cover'
            end
            object CB_CoverSearch_LastFM: TCheckBox
              Left = 16
              Top = 188
              Width = 273
              Height = 17
              Hint = 'Allow Nemp downloading missing cover files from the internet'
              Caption = 'Download missing covers from LastFM'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 7
            end
            object BtnClearCoverCache: TButton
              Left = 16
              Top = 211
              Width = 99
              Height = 25
              Hint = 'Clear the list of unsuccessfully checked covers'
              Caption = 'Clear cache'
              TabOrder = 8
              OnClick = BtnClearCoverCacheClick
            end
            object cb_CoverSize: TComboBox
              Left = 16
              Top = 147
              Width = 201
              Height = 21
              Style = csDropDownList
              ItemIndex = 1
              TabOrder = 6
              Text = 'Normal (500x500)'
              Items.Strings = (
                'Low (240x240)'
                'Normal (500x500)'
                'High (750x750)'
                'Highest (1000x1000)')
            end
          end
          object cpLibraryFileTypes: TCategoryPanel
            Top = 260
            Height = 235
            Caption = 'File types for the media library'
            TabOrder = 1
            object LblConst_OnlythefollowingTypes: TLabel
              Left = 16
              Top = 39
              Width = 120
              Height = 13
              Caption = 'Only the following types:'
            end
            object BtnRecommendedFiletypes: TButton
              Left = 16
              Top = 171
              Width = 128
              Height = 21
              Hint = 'Select recommended filetypes only'
              Caption = 'Recommended'
              TabOrder = 2
              OnClick = RecommendedFiletypesClick
            end
            object cbIncludeAll: TCheckBox
              Left = 16
              Top = 16
              Width = 397
              Height = 17
              Hint = 
                'When searching for files: Add every supported file or just some ' +
                'special types.'
              Caption = 'All types supported by the player'
              TabOrder = 0
              OnClick = cbIncludeAllClick
            end
            object cbIncludeFiles: TCheckListBox
              Left = 16
              Top = 54
              Width = 402
              Height = 111
              Hint = 'List of supported audio files.'
              Anchors = [akLeft, akTop, akRight]
              Columns = 4
              ItemHeight = 13
              Style = lbOwnerDrawFixed
              TabOrder = 1
              OnDrawItem = clbViewMainColumnsDrawItem
            end
          end
          object cpScanDirectories: TCategoryPanel
            Top = 0
            Height = 260
            Caption = 'Directories'
            TabOrder = 0
            object BtnAutoScanAdd: TButton
              AlignWithMargins = True
              Left = 303
              Top = 39
              Width = 125
              Height = 21
              Anchors = [akTop, akRight]
              Caption = 'Add'
              TabOrder = 2
              OnClick = BtnAutoScanAddClick
            end
            object BtnAutoScanDelete: TButton
              AlignWithMargins = True
              Left = 303
              Top = 64
              Width = 125
              Height = 21
              Anchors = [akTop, akRight]
              Caption = 'Delete'
              TabOrder = 3
              OnClick = BtnAutoScanDeleteClick
            end
            object BtnAutoScanNow: TButton
              AlignWithMargins = True
              Left = 303
              Top = 88
              Width = 125
              Height = 21
              Hint = 'Scan now for new or missing files, according to the settings'
              Anchors = [akTop, akRight]
              Caption = 'Scan now'
              TabOrder = 4
              OnClick = BtnAutoScanNowClick
            end
            object cb_AutoDeleteFiles: TCheckBox
              Left = 16
              Top = 156
              Width = 397
              Height = 17
              Hint = 
                'Check for missing files in your music directories when starting ' +
                'Nemp and remove them from the media library.'
              Caption = 'Automatically delete missing files from the media library'
              TabOrder = 7
              OnClick = CBAutoScanClick
            end
            object cb_AutoDeleteFilesShowInfo: TCheckBox
              Left = 16
              Top = 176
              Width = 397
              Height = 17
              Hint = 'Create a log message about missing files'
              Caption = 'Log summary about deleted files'
              TabOrder = 8
            end
            object CBAskForAutoAddNewDirs: TCheckBox
              Left = 16
              Top = 136
              Width = 397
              Height = 17
              Hint = 
                'When selecting a new directory: Show query whether it should be ' +
                'added to this list or not.'
              Caption = 'Show query dialog when adding new directories'
              TabOrder = 6
            end
            object CBAutoAddNewDirs: TCheckBox
              Left = 16
              Top = 115
              Width = 397
              Height = 17
              Hint = 'Add new directories to this list'
              Caption = 'Automatically monitor new directories'
              TabOrder = 5
            end
            object CBAutoScan: TCheckBox
              Left = 16
              Top = 16
              Width = 409
              Height = 17
              Hint = 
                'Check for new files in your music directories when starting Nemp' +
                '.'
              Caption = 'Scan the following directories for new files on start'
              TabOrder = 0
              OnClick = CBAutoScanClick
            end
            object LBAutoscan: TListBox
              Left = 28
              Top = 39
              Width = 261
              Height = 70
              Style = lbOwnerDrawVariable
              Anchors = [akLeft, akTop, akRight]
              ItemHeight = 13
              TabOrder = 1
              OnDrawItem = clbViewMainColumnsDrawItem
              OnKeyDown = LBAutoscanKeyDown
            end
            object CBAutoScanPlaylistFilesOnView: TCheckBox
              Left = 16
              Top = 196
              Width = 401
              Height = 17
              Hint = 
                'When browsing in playlists: Get the meta-data from the included ' +
                'audiofiles'
              Caption = 'Scan files in playlists on view'
              TabOrder = 9
            end
          end
        end
      end
      object tabCategories: TTabSheet
        Caption = 'Medialib Configuration'
        ImageIndex = 5
        object cpgCategories: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpCategoryPlaylists: TCategoryPanel
            Top = 787
            Height = 145
            Caption = 'Category "Playlists"'
            TabOrder = 0
            object lblPlaylistCaptionMode: TLabel
              Left = 16
              Top = 16
              Width = 89
              Height = 13
              Caption = 'Display playlists as'
            end
            object lblPlaylistSortMode: TLabel
              Left = 16
              Top = 62
              Width = 35
              Height = 13
              Caption = 'Sort by'
            end
            object cbPlaylistCaptionMode: TComboBox
              Left = 16
              Top = 35
              Width = 225
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 0
              Text = 'Filename'
              Items.Strings = (
                'Filename'
                'Folder'
                'Folder\Filename'
                'Complete path')
            end
            object cbPlaylistSortDirection: TComboBox
              AlignWithMargins = True
              Left = 247
              Top = 81
              Width = 121
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 2
              Text = 'Ascending'
              Items.Strings = (
                'Ascending'
                'Descending')
            end
            object cbPlaylistSortMode: TComboBox
              Left = 16
              Top = 81
              Width = 225
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 1
              Text = 'Filename'
              Items.Strings = (
                'Filename'
                'Folder'
                'Complete path')
            end
          end
          object cpCategorySettings: TCategoryPanel
            Top = 454
            Height = 333
            Caption = 'Group and sort settings'
            TabOrder = 1
            object lblSamplerSorting: TLabel
              Left = 16
              Top = 248
              Width = 43
              Height = 14
              Caption = 'Sampler'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblAlbumArtist: TLabel
              Left = 16
              Top = 167
              Width = 67
              Height = 14
              Caption = 'Album-Artist'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblDefineAlbum: TLabel
              Left = 16
              Top = 36
              Width = 101
              Height = 13
              Caption = 'Define an "Album" by'
            end
            object lblAlbumDefinition: TLabel
              Left = 16
              Top = 16
              Width = 39
              Height = 14
              Caption = 'Albums'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object cbSamplerSortingIgnoreReleaseYear: TCheckBox
              Left = 16
              Top = 268
              Width = 401
              Height = 17
              Caption = 
                'Use "Album name" instead of "Release Year" for sorting (where ap' +
                'propriate)'
              TabOrder = 5
            end
            object cbPreferAlbumArtist: TCheckBox
              Left = 16
              Top = 187
              Width = 401
              Height = 17
              Caption = 'Prefer Album-Artist when grouping by "Artist"'
              TabOrder = 3
              OnClick = cbPreferAlbumArtistClick
            end
            object cpIgnoreAlbumArtistVariousArtists: TCheckBox
              Left = 16
              Top = 207
              Width = 401
              Height = 17
              Caption = 'Ignore Album-Artist "Various Artists"'
              TabOrder = 4
            end
            object cbAlbumKeymode: TComboBox
              Left = 16
              Top = 53
              Width = 273
              Height = 21
              Style = csDropDownList
              ItemIndex = 2
              TabOrder = 0
              Text = 'Property "Album" and Directory'
              Items.Strings = (
                'Property "Album"'
                'Properties "Album" and "Artist"'
                'Property "Album" and Directory'
                'Directory'
                'Cover')
            end
            object cbIgnoreCDDirectories: TCheckBox
              Left = 16
              Top = 80
              Width = 401
              Height = 17
              Caption = 'Allow multi-folder albums (e.g. "CD 1" and "CD 2")'
              TabOrder = 1
            end
            object editCDNames: TLabeledEdit
              Left = 16
              Top = 123
              Width = 154
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              EditLabel.Width = 325
              EditLabel.Height = 13
              EditLabel.Caption = 'Folder names not forming an album of their own (comma separated)'
              TabOrder = 2
              Text = ''
              ExplicitWidth = 188
            end
          end
          object cpCategoryCoverflow: TCategoryPanel
            Top = 329
            Height = 125
            Caption = 'Display as "Coverflow"'
            TabOrder = 2
            object btnEditCoverflow: TButton
              Left = 375
              Top = 32
              Width = 28
              Height = 21
              Caption = '...'
              TabOrder = 1
              OnClick = btnEditCoverflowClick
            end
            object cbMissingCoverMode: TComboBox
              Left = 16
              Top = 59
              Width = 353
              Height = 21
              Style = csDropDownList
              ItemIndex = 1
              TabOrder = 2
              Text = 'No special handling of missing cover'
              Items.Strings = (
                'All missing cover at the beginning'
                'No special handling of missing cover'
                'All missing cover at the end')
            end
            object edtCoverFlowSortings: TLabeledEdit
              Left = 16
              Top = 32
              Width = 353
              Height = 21
              EditLabel.Width = 87
              EditLabel.Height = 13
              EditLabel.Caption = 'Sort Coverflow by'
              ReadOnly = True
              TabOrder = 0
              Text = ''
            end
          end
          object cpCategories: TCategoryPanel
            Top = 0
            Height = 329
            Caption = 'Categories and tree view layers'
            TabOrder = 3
            object lblDefaultCategory: TLabel
              Left = 16
              Top = 190
              Width = 81
              Height = 13
              Anchors = [akLeft, akBottom]
              Caption = 'Default category'
              ExplicitTop = 166
            end
            object lblRecentlyAddedCategory: TLabel
              Left = 232
              Top = 190
              Width = 131
              Height = 13
              Anchors = [akLeft, akBottom]
              Caption = 'Category "Recently added"'
              ExplicitTop = 166
            end
            object lblCategories: TLabel
              Left = 16
              Top = 16
              Width = 52
              Height = 13
              Caption = 'Categories'
            end
            object lblTreeViewLayers: TLabel
              Left = 232
              Top = 16
              Width = 79
              Height = 13
              Caption = 'Tree view layers'
            end
            object VSTCategories: TVirtualStringTree
              Left = 16
              Top = 32
              Width = 196
              Height = 112
              Anchors = [akLeft, akTop, akBottom]
              Colors.UnfocusedSelectionColor = clHighlight
              Colors.UnfocusedSelectionBorderColor = clHighlight
              DragOperations = [doMove]
              Header.AutoSizeIndex = 0
              Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
              Indent = 4
              PopupMenu = PopupCategories
              TabOrder = 0
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
              TreeOptions.MiscOptions = [toAcceptOLEDrop, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toFullRowDrag, toEditOnClick]
              TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
              OnDragAllowed = VSTCategoriesDragAllowed
              OnDragOver = VSTCategoriesDragOver
              OnDragDrop = VSTCategoriesDragDrop
              OnEditing = VSTCategoriesEditing
              OnGetText = VSTCategoriesGetText
              OnPaintText = VSTCategoriesPaintText
              OnNewText = VSTCategoriesNewText
              Touch.InteractiveGestures = [igPan, igPressAndTap]
              Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
              Columns = <
                item
                  Position = 0
                  Width = 196
                end>
            end
            object btnCategoryEdit: TButton
              Left = 16
              Top = 150
              Width = 99
              Height = 21
              Anchors = [akLeft, akBottom]
              Caption = 'Edit'
              TabOrder = 1
              OnClick = btnCategoryEditClick
            end
            object cbDefaultCategory: TComboBox
              Left = 16
              Top = 208
              Width = 179
              Height = 21
              Style = csDropDownList
              Anchors = [akLeft, akBottom]
              TabOrder = 4
              OnChange = cbDefaultCategoryChange
            end
            object cbNewFilesCategory: TComboBox
              Left = 232
              Top = 208
              Width = 177
              Height = 21
              Style = csDropDownList
              Anchors = [akLeft, akBottom]
              TabOrder = 5
              OnChange = cbNewFilesCategoryChange
            end
            object btnLayerEdit: TButton
              Left = 232
              Top = 150
              Width = 99
              Height = 21
              Anchors = [akLeft, akBottom]
              Caption = 'Edit'
              TabOrder = 3
              OnClick = btnLayerEditClick
            end
            object VSTSortings: TVirtualStringTree
              Left = 232
              Top = 31
              Width = 196
              Height = 113
              Anchors = [akLeft, akTop, akBottom]
              BevelInner = bvNone
              BevelOuter = bvNone
              Colors.UnfocusedSelectionColor = clHighlight
              Colors.UnfocusedSelectionBorderColor = clHighlight
              DragOperations = [doMove]
              Header.AutoSizeIndex = 0
              Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
              HintMode = hmHint
              PopupMenu = PopupLayers
              TabOrder = 2
              TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
              TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
              OnDragAllowed = VSTSortingsDragAllowed
              OnDragOver = VSTSortingsDragOver
              OnDragDrop = VSTSortingsDragDrop
              OnFocusChanged = VSTSortingsFocusChanged
              OnGetText = VSTSortingsGetText
              OnPaintText = VSTSortingsPaintText
              OnGetHint = VSTSortingsGetHint
              Touch.InteractiveGestures = [igPan, igPressAndTap]
              Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
              Columns = <
                item
                  Position = 0
                  Width = 196
                end>
            end
            object cbLibConfigShowPlaylistCategories: TCheckBox
              Left = 16
              Top = 245
              Width = 378
              Height = 17
              Anchors = [akLeft, akBottom]
              Caption = 'Show playlist categories'
              TabOrder = 6
            end
            object cbLibConfigShowWebradioCategory: TCheckBox
              Left = 16
              Top = 268
              Width = 378
              Height = 17
              Anchors = [akLeft, akBottom]
              Caption = 'Show web radio category'
              TabOrder = 7
            end
          end
        end
      end
      object tabMetadata: TTabSheet
        Caption = 'Metadata'
        ImageIndex = 9
        object cpgMetadata: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpMetaData: TCategoryPanel
            Top = 0
            Height = 445
            Caption = 'Meta data (e.g. ID3-Tags)'
            TabOrder = 0
            object lblQuickAccess: TLabel
              Left = 16
              Top = 16
              Width = 214
              Height = 14
              Caption = 'Quick access to metadata ("ID3-Tags")'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblMetaDataLyrics: TLabel
              Left = 16
              Top = 72
              Width = 136
              Height = 14
              Caption = 'Lyrics in the media library'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblMetaDataAutomaticRating: TLabel
              Left = 16
              Top = 128
              Width = 91
              Height = 14
              Caption = 'Automatic rating'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblExtendedTags: TLabel
              Left = 16
              Top = 264
              Width = 154
              Height = 14
              Caption = 'Extended tags for tag cloud'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lbMetaDataAutoDetectCharset: TLabel
              Left = 16
              Top = 360
              Width = 202
              Height = 14
              Caption = 'Heuristics for obsolete character sets'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object cb_AccessMetadata: TCheckBox
              Left = 16
              Top = 36
              Width = 414
              Height = 17
              Caption = 'Write changes directly to the metadata'
              TabOrder = 0
            end
            object cb_IgnoreLyrics: TCheckBox
              Left = 16
              Top = 92
              Width = 414
              Height = 17
              Caption = 'Ignore Lyrics (recommended for very large  music collections)'
              TabOrder = 1
              OnClick = cb_IgnoreLyricsClick
            end
            object cb_RatingActive: TCheckBox
              Left = 16
              Top = 148
              Width = 397
              Height = 17
              Hint = '(De)activate automatic rating/playcounter'
              Caption = 'Change rating and play counter of played files'
              TabOrder = 2
              OnClick = cb_RatingActiveClick
            end
            object cb_RatingChangeCounter: TCheckBox
              Left = 33
              Top = 188
              Width = 397
              Height = 17
              Hint = 'Increase the playcounter of a file after it was played'
              Caption = 'Increase play counter'
              TabOrder = 4
            end
            object cb_RatingDecreaseRating: TCheckBox
              Left = 33
              Top = 228
              Width = 397
              Height = 17
              Hint = 
                'Automatically decrease rating on aborted tracks. The change will' +
                ' be smaller the higher the playcounter is.'
              Caption = 'Decrease rating on aborted tracks'
              TabOrder = 6
            end
            object cb_RatingIgnoreShortFiles: TCheckBox
              Left = 33
              Top = 168
              Width = 397
              Height = 17
              Hint = 'Do not change rating and playcounter on short tracks.'
              Caption = 'Ignore short tracks (i.e. less than 30 seconds)'
              TabOrder = 3
            end
            object cb_RatingIncreaseRating: TCheckBox
              Left = 33
              Top = 208
              Width = 397
              Height = 17
              Hint = 
                'Automatically increase rating on played tracks. The change will ' +
                'be smaller the higher the playcounter is.'
              Caption = 'Increase rating on played tracks'
              TabOrder = 5
            end
            object cb_AskForAutoResolveInconsistencies: TCheckBox
              Left = 33
              Top = 304
              Width = 397
              Height = 17
              Caption = 'If not: Show query dialog when inconsistencies occur'
              TabOrder = 8
            end
            object cb_AutoResolveInconsistencies: TCheckBox
              Left = 16
              Top = 284
              Width = 397
              Height = 17
              Caption = 'Automatically resolve inconsistencies when entering new tags'
              TabOrder = 7
            end
            object cb_ShowAutoResolveInconsistenciesHints: TCheckBox
              Left = 33
              Top = 324
              Width = 397
              Height = 17
              Caption = 
                'If not: Show information dialog when minor inconsistencies occur' +
                ' '
              TabOrder = 9
            end
            object CBAutoDetectCharCode: TCheckBox
              Left = 16
              Top = 380
              Width = 397
              Height = 17
              Hint = 
                'Use a uber-ingenious special method for better tag-reading in fi' +
                'les with "unicode-filenames".'
              Caption = 'Auto-detect (probably) used character sets'
              TabOrder = 10
            end
          end
        end
      end
      object tabSearch: TTabSheet
        Caption = 'Search'
        ImageIndex = 10
        object cpgSearchSettings: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpGeneralSearchSettings: TCategoryPanel
            Top = 0
            Height = 481
            Caption = 'Search settings'
            TabOrder = 0
            object lblSearchSettingsHint: TLabel
              Left = 16
              Top = 16
              Width = 418
              Height = 33
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'Nemp can increase the speed of the quick search, but this also i' +
                'ncreases the memory usage.'
              WordWrap = True
              ExplicitWidth = 441
            end
            object Label2: TLabel
              Left = 16
              Top = 217
              Width = 142
              Height = 14
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Quick search performance'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object CB_AccelerateLyricSearch: TCheckBox
              Left = 16
              Top = 176
              Width = 414
              Height = 17
              Hint = 'Use some tricky algorithms to accelerate the search for lyrics.'
              Caption = 'Accelerate lyrics search'
              TabOrder = 6
            end
            object CB_AccelerateSearch: TCheckBox
              Left = 16
              Top = 55
              Width = 414
              Height = 17
              Hint = 'Use some tricky algorithms to accelerate the search.'
              Caption = 'Accelerate search'
              TabOrder = 0
              OnClick = CB_AccelerateSearchClick
            end
            object CB_AccelerateSearchIncludeComment: TCheckBox
              Left = 35
              Top = 95
              Width = 414
              Height = 17
              Hint = 'Include comments to the accelerated search algorithms.'
              Caption = 'Including comments'
              TabOrder = 2
            end
            object CB_AccelerateSearchIncludeGenre: TCheckBox
              Left = 35
              Top = 115
              Width = 414
              Height = 17
              Hint = 'Include genres to the accelerated search algorithms.'
              Caption = 'Including genre'
              TabOrder = 3
            end
            object CB_AccelerateSearchIncludePath: TCheckBox
              Left = 35
              Top = 75
              Width = 414
              Height = 17
              Hint = 'Include filenames to the accelerated search algorithms.'
              Caption = 'Including filenames'
              TabOrder = 1
            end
            object cb_ChangeCoverflowOnSearch: TCheckBox
              Left = 16
              Top = 301
              Width = 397
              Height = 17
              Caption = 'Change coverflow according to results'
              TabOrder = 10
            end
            object CB_QuickSearchAllowErrorsOnEnter: TCheckBox
              Left = 16
              Top = 261
              Width = 397
              Height = 17
              Hint = 
                'Do a fuzzy search after pressing "enter" (e.g. show files from "' +
                'Amy MacDonald" when you search for "Amy McDonald")'
              Caption = 'Allow errors on [Enter]'
              TabOrder = 8
            end
            object CB_QuickSearchAllowErrorsWhileTyping: TCheckBox
              Left = 16
              Top = 281
              Width = 397
              Height = 17
              Hint = 
                'Always use a fuzzy search (e.g. show files from "Amy MacDonald" ' +
                'when you search for "Amy McDonald")'
              Caption = 'Allow errors while typing'
              TabOrder = 9
            end
            object CB_QuickSearchWhileYouType: TCheckBox
              Left = 16
              Top = 241
              Width = 397
              Height = 17
              Hint = 
                'Show search results in "real time" or just after pressing the "e' +
                'nter"-key.'
              Caption = '"While you type"'
              TabOrder = 7
            end
            object CB_AccelerateSearchIncludeAlbumArtist: TCheckBox
              Left = 35
              Top = 135
              Width = 398
              Height = 17
              Hint = 'Include the album-artist to the accelerated search algorithms.'
              Caption = 'Including album-artist'
              TabOrder = 4
            end
            object CB_AccelerateSearchIncludeComposer: TCheckBox
              Left = 35
              Top = 155
              Width = 406
              Height = 17
              Hint = 'Include the composer to the accelerated search algorithms.'
              Caption = 'Including composer'
              TabOrder = 5
            end
          end
        end
      end
      object tabPlayer: TTabSheet
        Caption = 'Player'
        ImageIndex = 2
        object cpgPlayerMain: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpAdvanced: TCategoryPanel
            Top = 887
            Height = 76
            Caption = 'Advanced'
            TabOrder = 4
            ExplicitWidth = 457
            object cb_SafePlayback: TCheckBox
              Left = 16
              Top = 16
              Width = 420
              Height = 17
              Caption = 'Use safe playback'
              TabOrder = 0
            end
          end
          object cpVisualisation: TCategoryPanel
            Top = 725
            Height = 162
            Caption = 'Visualization'
            TabOrder = 3
            object Lbl_Framerate: TLabel
              Left = 191
              Top = 42
              Width = 12
              Height = 13
              Caption = '...'
            end
            object CB_ScrollTitelTaskBar: TCheckBox
              Left = 16
              Top = 72
              Width = 401
              Height = 17
              Caption = 'Scroll title in taskbar'
              TabOrder = 2
              OnClick = CB_visualClick
            end
            object CB_TaskBarDelay: TComboBox
              Left = 40
              Top = 95
              Width = 145
              Height = 21
              Style = csDropDownList
              ItemIndex = 4
              TabOrder = 3
              Text = 'Very fast'
              Items.Strings = (
                'Very slow'
                'Slower'
                'Normal'
                'Faster'
                'Very fast')
            end
            object CB_visual: TCheckBox
              Left = 16
              Top = 16
              Width = 409
              Height = 17
              Caption = 'Visualization'
              TabOrder = 0
              OnClick = CB_visualClick
            end
            object TB_Refresh: TTrackBar
              Left = 32
              Top = 36
              Width = 153
              Height = 33
              Max = 90
              Frequency = 10
              Position = 20
              TabOrder = 1
              OnChange = TB_RefreshChange
            end
          end
          object cpSilenceDetection: TCategoryPanel
            Top = 538
            Height = 187
            Caption = 'Pause between tracks'
            TabOrder = 2
            ExplicitWidth = 457
            object Lbl_SilenceDB: TLabel
              Left = 95
              Top = 59
              Width = 12
              Height = 13
              Caption = 'dB'
            end
            object Lbl_SilenceThreshold: TLabel
              Left = 32
              Top = 39
              Width = 47
              Height = 13
              Caption = 'Threshold'
            end
            object lblBreakBetweenTracks: TLabel
              Left = 95
              Top = 124
              Width = 13
              Height = 13
              Hint = 'Fading length between two songs.'
              Caption = 'ms'
            end
            object cb_AddBreakBetweenTracks: TCheckBox
              Left = 16
              Top = 96
              Width = 409
              Height = 17
              Hint = 'Add a little break between two tracks'
              Caption = 'Add extra silence between tracks'
              TabOrder = 2
              OnClick = CB_SilenceDetectionClick
            end
            object CB_SilenceDetection: TCheckBox
              Left = 16
              Top = 16
              Width = 409
              Height = 17
              Hint = 
                'Automatically detect and skip the silent parts at the end of the' +
                ' tracks '
              Caption = 'Skip silence at the end of tracks'
              TabOrder = 0
              OnClick = CB_SilenceDetectionClick
            end
            object SE_BreakBetweenTracks: TSpinEdit
              Left = 32
              Top = 119
              Width = 57
              Height = 22
              Hint = 'Length of the break between tracks'
              Increment = 100
              MaxValue = 20000
              MinValue = 0
              TabOrder = 3
              Value = 2000
            end
            object SE_SilenceThreshold: TSpinEdit
              Left = 32
              Top = 55
              Width = 57
              Height = 22
              Hint = 
                'Threshold for "silence". A threshold of -5dB to -10dB will skip ' +
                'a lot, -40dB and below will skip only really quiet parts.'
              MaxValue = -5
              MinValue = -100
              TabOrder = 1
              Value = -40
            end
          end
          object cpFading: TCategoryPanel
            Top = 350
            Height = 188
            Caption = 'Fading'
            TabOrder = 1
            ExplicitWidth = 457
            object LblConst_ms1: TLabel
              Left = 90
              Top = 64
              Width = 13
              Height = 13
              Hint = 'Fading length between two songs.'
              Caption = 'ms'
            end
            object LblConst_ms2: TLabel
              Left = 202
              Top = 64
              Width = 13
              Height = 13
              Hint = 'Fading length when scrolling inside a song.'
              Caption = 'ms'
            end
            object LblConst_TitleChange: TLabel
              Left = 32
              Top = 40
              Width = 73
              Height = 13
              Hint = 'Fading length between two songs.'
              Caption = 'On title change'
            end
            object LblConst_Titlefade: TLabel
              Left = 144
              Top = 40
              Width = 92
              Height = 13
              Hint = 'Fading length when scrolling inside a song.'
              Caption = 'On position change'
            end
            object CB_Fading: TCheckBox
              Left = 16
              Top = 16
              Width = 401
              Height = 17
              Hint = 'Use crossfading.'
              Caption = 'Fade in/out'
              TabOrder = 0
              OnClick = CB_FadingClick
            end
            object CB_IgnoreFadingOnPause: TCheckBox
              Left = 32
              Top = 108
              Width = 385
              Height = 17
              Hint = 'Ignore fading when clicking on "Pause".'
              Caption = 'Ignore on pause'
              TabOrder = 4
            end
            object CB_IgnoreFadingOnShortTracks: TCheckBox
              Left = 32
              Top = 88
              Width = 385
              Height = 17
              Hint = 'Ignore fading on short tracks.'
              Caption = 'Ignore on short tracks'
              TabOrder = 3
            end
            object CB_IgnoreFadingOnStop: TCheckBox
              Left = 32
              Top = 128
              Width = 393
              Height = 17
              Hint = 'Ignore fading when stopping the player.'
              Caption = 'Ignore on stop'
              TabOrder = 5
            end
            object SE_Fade: TSpinEdit
              Left = 32
              Top = 59
              Width = 57
              Height = 22
              Hint = 'Fading length between two songs.'
              Increment = 100
              MaxValue = 10000
              MinValue = 0
              TabOrder = 1
              Value = 2000
            end
            object SE_SeekFade: TSpinEdit
              Left = 144
              Top = 59
              Width = 57
              Height = 22
              Hint = 'Fading length when scrolling inside a song.'
              Increment = 100
              MaxValue = 10000
              MinValue = 0
              TabOrder = 2
              Value = 2000
            end
          end
          object cpOutputDevices: TCategoryPanel
            Top = 0
            Height = 350
            Caption = 'Output devices'
            TabOrder = 0
            object LblConst_MainDevice: TLabel
              Left = 16
              Top = 16
              Width = 385
              Height = 13
              AutoSize = False
              Caption = 'Main'
            end
            object LblConst_Headphones: TLabel
              Left = 16
              Top = 62
              Width = 305
              Height = 13
              AutoSize = False
              Caption = 'Headphones'
            end
            object LblSoundFont: TLabel
              Left = 16
              Top = 116
              Width = 250
              Height = 13
              AutoSize = False
              Caption = 'SoundFont file for MIDI playback'
            end
            object LblConst_Buffersize: TLabel
              Left = 16
              Top = 172
              Width = 401
              Height = 13
              Hint = 'Increase this value, if the playback stutters sometimes.'
              AutoSize = False
              Caption = 'Buffer size'
            end
            object LblConst_ms: TLabel
              Left = 79
              Top = 191
              Width = 13
              Height = 13
              Hint = 'Increase this value, if the playback stutters sometimes.'
              Caption = 'ms'
            end
            object LblConst_UseFloatingPoint: TLabel
              Left = 16
              Top = 220
              Width = 401
              Height = 13
              Hint = 'Try to change this, if the playback is distorted.'
              AutoSize = False
              Caption = 'Floating-point channels'
            end
            object LblConst_Mixing: TLabel
              Left = 16
              Top = 268
              Width = 409
              Height = 13
              Hint = 'Try to change this, if the playback is distorted.'
              AutoSize = False
              Caption = 'Mixing'
            end
            object Lbl_FloatingPoints_Status: TLabel
              Left = 167
              Top = 239
              Width = 12
              Height = 13
              Hint = 'Try to change this, if the playback is distorted.'
              Caption = '...'
            end
            object MainDeviceCB: TComboBox
              Left = 16
              Top = 35
              Width = 250
              Height = 21
              Hint = 'The main device.'
              Style = csDropDownList
              TabOrder = 0
            end
            object HeadphonesDeviceCB: TComboBox
              Left = 16
              Top = 81
              Width = 250
              Height = 21
              Hint = 'The secondary device.'
              Style = csDropDownList
              TabOrder = 1
            end
            object BtnRefreshDevices: TButton
              Left = 272
              Top = 79
              Width = 89
              Height = 25
              Caption = 'Refresh'
              TabOrder = 2
              OnClick = BtnRefreshDevicesClick
            end
            object editSoundFont: TEdit
              Left = 16
              Top = 135
              Width = 250
              Height = 21
              Hint = 'The SoundFont file used for MIDI playback'
              TabOrder = 3
            end
            object BtnSelectSoundFontFile: TButton
              Left = 272
              Top = 135
              Width = 25
              Height = 21
              Hint = 'Select file'
              Caption = '...'
              TabOrder = 4
              OnClick = BtnSelectSoundFontFileClick
            end
            object SEBufferSize: TSpinEdit
              Left = 16
              Top = 188
              Width = 57
              Height = 22
              Hint = 'Increase this value, if the playback stutters sometimes.'
              Increment = 100
              MaxValue = 5000
              MinValue = 100
              TabOrder = 5
              Value = 500
            end
            object CB_FloatingPoint: TComboBox
              Left = 16
              Top = 236
              Width = 145
              Height = 21
              Hint = 'Try to change this, if the playback is distorted.'
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 6
              Text = 'Auto-detect'
              Items.Strings = (
                'Auto-detect'
                'Off'
                'On')
            end
            object CB_Mixing: TComboBox
              Left = 16
              Top = 287
              Width = 145
              Height = 21
              Hint = 'Try to change this, if the playback is distorted.'
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 7
              Text = 'Hardware'
              Items.Strings = (
                'Hardware'
                'Software')
            end
          end
        end
      end
      object tabPlaylist: TTabSheet
        Caption = 'Playlist'
        ImageIndex = 3
        object cpgPlaylistSettings: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpPlaylistLog: TCategoryPanel
            Top = 770
            Height = 120
            Caption = 'Playlist log'
            TabOrder = 3
            ExplicitWidth = 457
            object LblLogDuration: TLabel
              Left = 36
              Top = 39
              Width = 144
              Height = 13
              Caption = 'Remove log entries older than'
            end
            object LblLogDuration2: TLabel
              Left = 104
              Top = 61
              Width = 143
              Height = 13
              Caption = 'days (0 for unlimited logging).'
            end
            object cbSaveLogToFile: TCheckBox
              Left = 16
              Top = 16
              Width = 417
              Height = 17
              Caption = 'Use logfile on hard disk to log previous sessions'
              TabOrder = 0
              OnClick = cbSaveLogToFileClick
            end
            object seLogDuration: TSpinEdit
              Left = 37
              Top = 58
              Width = 61
              Height = 22
              MaxValue = 366
              MinValue = 0
              TabOrder = 1
              Value = 7
            end
          end
          object cpRandomPlayback: TCategoryPanel
            Top = 420
            Height = 350
            Caption = 'Random playback'
            TabOrder = 2
            ExplicitWidth = 457
            object lbl_WeightedRandom: TLabel
              Left = 34
              Top = 100
              Width = 170
              Height = 13
              Caption = 'Indivdual weights, based on rating.'
            end
            object lblCount00: TLabel
              Left = 34
              Top = 261
              Width = 383
              Height = 13
              AutoSize = False
              Caption = '* Including 1000 unrated files'
              Visible = False
            end
            object lblCount05: TLabel
              Left = 159
              Top = 124
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount10: TLabel
              Left = 159
              Top = 151
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount15: TLabel
              Left = 159
              Top = 180
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount20: TLabel
              Left = 159
              Top = 208
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount25: TLabel
              Left = 159
              Top = 235
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount30: TLabel
              Left = 350
              Top = 124
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount35: TLabel
              Left = 350
              Top = 151
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount40: TLabel
              Left = 350
              Top = 180
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount45: TLabel
              Left = 350
              Top = 208
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object lblCount50: TLabel
              Left = 350
              Top = 235
              Width = 38
              Height = 13
              Caption = '(99999)'
              Visible = False
            end
            object RatingImage05: TImage
              Left = 34
              Top = 124
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage10: TImage
              Left = 34
              Top = 152
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage15: TImage
              Left = 34
              Top = 180
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage20: TImage
              Left = 34
              Top = 208
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage25: TImage
              Left = 34
              Top = 236
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage30: TImage
              Left = 224
              Top = 124
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage35: TImage
              Left = 224
              Top = 152
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage40: TImage
              Left = 224
              Top = 180
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage45: TImage
              Left = 224
              Top = 208
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object RatingImage50: TImage
              Left = 224
              Top = 236
              Width = 70
              Height = 14
              ParentShowHint = False
              ShowHint = False
              Transparent = True
            end
            object LblConst_AvoidRepetitions: TLabel
              Left = 252
              Top = 16
              Width = 162
              Height = 13
              Alignment = taRightJustify
              AutoSize = False
              Caption = 'Avoid repetitions'
            end
            object LblConst_ReallyRandom: TLabel
              Left = 16
              Top = 16
              Width = 153
              Height = 13
              AutoSize = False
              Caption = 'Really random'
            end
            object BtnCountRating: TButton
              Left = 16
              Top = 282
              Width = 137
              Height = 25
              Hint = 
                'Count how many files in the media library (or the playlist) exis' +
                't with the specific rating.'
              Caption = 'Count Ratings'
              TabOrder = 12
              OnClick = BtnCountRatingClick
            end
            object cb_UseWeightedRNG: TCheckBox
              Left = 16
              Top = 77
              Width = 401
              Height = 17
              Caption = 'Use weighted random'
              TabOrder = 1
              OnClick = cb_UseWeightedRNGClick
            end
            object cbCountRatingOnlyPlaylist: TCheckBox
              Left = 159
              Top = 286
              Width = 258
              Height = 17
              Caption = 'Restrict counting to playlist'
              TabOrder = 13
            end
            object RandomWeight05: TEdit
              Left = 110
              Top = 121
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 2
              Text = '0'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight10: TEdit
              Left = 110
              Top = 148
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 3
              Text = '0'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight15: TEdit
              Left = 110
              Top = 177
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 4
              Text = '1'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight20: TEdit
              Left = 110
              Top = 205
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 5
              Text = '2'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight25: TEdit
              Left = 110
              Top = 232
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 6
              Text = '4'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight30: TEdit
              Left = 300
              Top = 121
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 7
              Text = '7'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight35: TEdit
              Left = 301
              Top = 150
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 8
              Text = '12'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight40: TEdit
              Left = 300
              Top = 177
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 9
              Text = '20'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight45: TEdit
              Left = 300
              Top = 205
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 10
              Text = '35'
              OnExit = RandomWeight05Exit
            end
            object RandomWeight50: TEdit
              Left = 301
              Top = 232
              Width = 43
              Height = 21
              NumbersOnly = True
              TabOrder = 11
              Text = '60'
              OnExit = RandomWeight05Exit
            end
            object TBRandomRepeat: TTrackBar
              Left = 12
              Top = 32
              Width = 409
              Height = 33
              Max = 75
              Frequency = 5
              Position = 23
              TabOrder = 0
            end
          end
          object cpPlaylistBehaviour: TCategoryPanel
            Top = 185
            Height = 235
            Caption = 'General playlist settings'
            TabOrder = 1
            ExplicitWidth = 457
            object CB_AutoScanPlaylist: TCheckBox
              Left = 16
              Top = 16
              Width = 415
              Height = 17
              Hint = 
                'Read metadata from the audiofiles or just use the data stored in' +
                ' the playlistfile.'
              Caption = 'Check files when loading a playlist'
              TabOrder = 0
            end
            object CB_JumpToNextCue: TCheckBox
              Left = 16
              Top = 36
              Width = 415
              Height = 17
              Hint = 'When clicking "next", jump to the next cuesheet (if available)'
              Caption = 'Jump to next entry in cuesheet on "next"'
              TabOrder = 1
            end
            object cb_PlaylistManagerAutoSave: TCheckBox
              Left = 16
              Top = 96
              Width = 415
              Height = 17
              Caption = 'Autosave favorite playlists'
              TabOrder = 4
              OnClick = cb_PlaylistManagerAutoSaveClick
            end
            object cb_PlaylistManagerAutoSaveUserInput: TCheckBox
              Left = 28
              Top = 116
              Width = 415
              Height = 17
              Caption = 'Decide individually when loading a new playlist '
              TabOrder = 5
            end
            object CB_RememberInterruptedPlayPosition: TCheckBox
              Left = 16
              Top = 76
              Width = 415
              Height = 17
              Hint = 'Used in combination with "Just play focussed file"'
              Caption = 
                'Remember track position when playing a song directly from the li' +
                'brary'
              TabOrder = 3
            end
            object cb_ReplayCue: TCheckBox
              Left = 16
              Top = 56
              Width = 415
              Height = 17
              Hint = 
                'Repeat only the current part of a file instead of the whole trac' +
                'k when "Repeat title" is selected'
              Caption = 'Repeat current entry in cuesheet on "Repeat title"'
              TabOrder = 2
            end
            object CB_AutoDeleteFromPlaylist: TCheckBox
              Left = 16
              Top = 136
              Width = 415
              Height = 17
              Hint = 'remove a track from the playlist after it is completely played.'
              Caption = 'Delete completely played tracks from the playlist'
              TabOrder = 6
              OnClick = CB_AutoDeleteFromPlaylistClick
            end
            object CB_AutoMixPlaylist: TCheckBox
              Left = 16
              Top = 176
              Width = 415
              Height = 17
              Hint = 'Randomize playlist after the last track.'
              Caption = 'Mix playlist after last track'
              TabOrder = 8
            end
            object CB_DisableAutoDeleteAtUserInput: TCheckBox
              Left = 36
              Top = 156
              Width = 415
              Height = 17
              Hint = 'Exceptions for deleting a file from the playlist.'
              Caption = 'Do not delete after manual stop/pause/slide/next/previous'
              TabOrder = 7
            end
          end
          object cpPlaylistDefaultActions: TCategoryPanel
            Top = 0
            Height = 185
            Caption = 'Default actions'
            TabOrder = 0
            object LblPlaylistDefaultAction: TLabel
              Left = 16
              Top = 16
              Width = 405
              Height = 13
              AutoSize = False
              Caption = 'Insert mode from media list into the playlist'
            end
            object LblHeadsetDefaultAction: TLabel
              Left = 16
              Top = 64
              Width = 405
              Height = 13
              AutoSize = False
              Caption = 'Insert mode from headset to playlist'
            end
            object cb_AutoStopHeadsetAddToPlayist: TCheckBox
              Left = 16
              Top = 128
              Width = 405
              Height = 17
              Caption = 'Stop headset when adding headset file to playlist'
              TabOrder = 3
            end
            object cb_AutoStopHeadsetSwitchTab: TCheckBox
              Left = 16
              Top = 108
              Width = 413
              Height = 17
              Caption = 'Stop headset when switching to another tab'
              TabOrder = 2
            end
            object GrpBox_DefaultAction: TComboBox
              Left = 16
              Top = 33
              Width = 285
              Height = 21
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 0
              Text = 'Enqueue at the end of the playlist'
              Items.Strings = (
                'Enqueue at the end of the playlist'
                'Play (and clear current playlist)'
                'Enqueue after current track'
                'Just play (don'#39't change the playlist)')
            end
            object GrpBox_HeadsetDefaultAction: TComboBox
              Left = 16
              Top = 81
              Width = 285
              Height = 21
              Hint = 'Insert mode for files from the headset'
              Style = csDropDownList
              ItemIndex = 0
              TabOrder = 1
              Text = 'Enqueue at the end of the playlist'
              Items.Strings = (
                'Enqueue at the end of the playlist'
                'Play (and clear current playlist)'
                'Enqueue after current track'
                'Just play (don'#39't change the playlist)')
            end
          end
        end
      end
      object tabWebradio: TTabSheet
        Caption = 'Webradio'
        ImageIndex = 11
        object cpgWebstreams: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpWebstreamsPlaylists: TCategoryPanel
            Top = 345
            Height = 121
            Caption = 'Playlist parsing'
            TabOrder = 1
            object Label1: TLabel
              Left = 16
              Top = 16
              Width = 233
              Height = 13
              Caption = 'Playlist files (e.g. http://myradio.com/tunein.pls)'
            end
            object rbWebRadioParseFile: TRadioButton
              Left = 16
              Top = 37
              Width = 418
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Parse stream playlist and add all contained streams to playlist'
              TabOrder = 0
            end
            object rbWebRadioHandledByBass: TRadioButton
              Left = 16
              Top = 60
              Width = 418
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Just add playlist URL to the playlist (recommended)'
              Checked = True
              TabOrder = 1
              TabStop = True
            end
          end
          object cpWebstremRecording: TCategoryPanel
            Top = 0
            Height = 345
            Caption = 'Recording settings'
            TabOrder = 0
            object LblConst_DownloadDir: TLabel
              Left = 16
              Top = 16
              Width = 93
              Height = 13
              Caption = 'Download directory'
            end
            object LblConst_FilenameExtension: TLabel
              Left = 16
              Top = 117
              Width = 231
              Height = 13
              Caption = '(A proper extension will be added automatically)'
            end
            object LblConst_FilenameFormat: TLabel
              Left = 16
              Top = 80
              Width = 101
              Height = 13
              Caption = 'Pattern for filenames'
            end
            object LblConst_MaxSize: TLabel
              Left = 96
              Top = 215
              Width = 50
              Height = 13
              Caption = 'MB per file'
            end
            object LblConst_MaxTime: TLabel
              Left = 96
              Top = 263
              Width = 73
              Height = 13
              Caption = 'Minutes per file'
            end
            object LblConst_WebradioHint: TLabel
              Left = 16
              Top = 288
              Width = 410
              Height = 33
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'These values are approximate values. Resulting length/size may v' +
                'ary.'
              WordWrap = True
              ExplicitWidth = 433
            end
            object lblSplitWebRadioStreams: TLabel
              Left = 16
              Top = 152
              Width = 47
              Height = 14
              Caption = 'Split files'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object BtnChooseDownloadDir: TButton
              Left = 416
              Top = 32
              Width = 25
              Height = 21
              Hint = 'Choose a download directory'
              Caption = '...'
              TabOrder = 1
              OnClick = BtnChooseDownloadDirClick
            end
            object cbAutoSplitBySize: TCheckBox
              Left = 16
              Top = 192
              Width = 420
              Height = 17
              Hint = 'Split recordings by size.'
              Caption = 'Split files by size'
              TabOrder = 5
              OnClick = cbAutoSplitBySizeClick
            end
            object cbAutoSplitByTime: TCheckBox
              Left = 16
              Top = 240
              Width = 420
              Height = 17
              Hint = 'Split recordings by time.'
              Caption = 'Split files by time'
              TabOrder = 7
              OnClick = cbAutoSplitByTimeClick
            end
            object cbAutoSplitByTitle: TCheckBox
              Left = 16
              Top = 172
              Width = 420
              Height = 17
              Hint = 
                'Try to split the stream when a new title begins. This will work ' +
                'only if the station submits proper title information.'
              Caption = 'Begin new file for every title'
              Checked = True
              State = cbChecked
              TabOrder = 4
            end
            object cbFilenameFormat: TComboBox
              Left = 16
              Top = 95
              Width = 393
              Height = 21
              TabOrder = 3
              Text = '<date>, <time> - <title>'
              OnChange = cbFilenameFormatChange
              Items.Strings = (
                '<date>, <time> - <title>'
                '<date>, <time> - <streamname> - <title>'
                '<title>'
                '<streamname> - <title>')
            end
            object cbUseStreamnameAsDirectory: TCheckBox
              Left = 16
              Top = 56
              Width = 420
              Height = 17
              Caption = 'Use streamname as directory'
              TabOrder = 2
            end
            object EdtDownloadDir: TEdit
              Left = 16
              Top = 32
              Width = 394
              Height = 21
              TabOrder = 0
            end
            object SE_AutoSplitMaxSize: TSpinEdit
              Left = 16
              Top = 212
              Width = 65
              Height = 22
              MaxValue = 2000
              MinValue = 1
              TabOrder = 6
              Value = 10
            end
            object SE_AutoSplitMaxTime: TSpinEdit
              Left = 16
              Top = 260
              Width = 65
              Height = 22
              MaxValue = 1440
              MinValue = 1
              TabOrder = 8
              Value = 10
            end
          end
        end
      end
      object tabEffects: TTabSheet
        Caption = 'Effects'
        ImageIndex = 12
        object cpgEffects: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpReplayGain: TCategoryPanel
            Top = 0
            Height = 190
            Caption = 'ReplayGain'
            TabOrder = 0
            object lblDefaultGainValue: TLabel
              Left = 376
              Top = 128
              Width = 37
              Height = 13
              Caption = '0.00 dB'
            end
            object lblDefaultGainValue2: TLabel
              Left = 376
              Top = 104
              Width = 37
              Height = 13
              Caption = '0.00 dB'
            end
            object lblReplayGainDefault: TLabel
              Left = 16
              Top = 82
              Width = 88
              Height = 14
              Caption = 'Pre-amplification'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblRG_Preamp1: TLabel
              Left = 16
              Top = 104
              Width = 39
              Height = 13
              Caption = 'With RG'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblRG_Preamp2: TLabel
              Left = 16
              Top = 128
              Width = 55
              Height = 13
              Caption = 'Without RG'
            end
            object cb_ApplyReplayGain: TCheckBox
              Left = 16
              Top = 16
              Width = 420
              Height = 17
              Hint = 
                'Use ReplayGain values to achieve a more consistent loudness duri' +
                'ng playback.'
              Caption = 'Use ReplayGain for a more consistent loudness during playback'
              TabOrder = 0
              OnClick = cb_ApplyReplayGainClick
            end
            object cb_PreferAlbumGain: TCheckBox
              Left = 16
              Top = 34
              Width = 420
              Height = 17
              Hint = 
                'Use AlbumGain values to maintain intentional loudness changes wi' +
                'thin albums'
              Caption = 'Prefer AlbumGain'
              TabOrder = 1
            end
            object cb_ReplayGainPreventClipping: TCheckBox
              Left = 16
              Top = 52
              Width = 420
              Height = 17
              Hint = 'Limit amplification to prevent playback from clipping, if needed'
              Caption = 'Prevent clipping'
              TabOrder = 2
            end
            object tp_DefaultGain: TNempTrackBar
              Left = 104
              Top = 123
              Width = 266
              Height = 24
              Hint = 'Pre-amplification for tracks without ReplayGain information'
              Max = 200
              Min = -200
              PageSize = 10
              TabOrder = 4
              TickMarks = tmBoth
              TickStyle = tsNone
              OnChange = tp_DefaultGainChange
              OnMouseDown = tp_DefaultGainMouseDown
            end
            object tp_DefaultGain2: TNempTrackBar
              Left = 104
              Top = 100
              Width = 266
              Height = 24
              Hint = 'Pre-amplification for tracks with ReplayGain information'
              Max = 200
              Min = -200
              PageSize = 10
              TabOrder = 3
              TickMarks = tmBoth
              TickStyle = tsNone
              OnChange = tp_DefaultGain2Change
              OnMouseDown = tp_DefaultGain2MouseDown
            end
          end
          object cpEffects: TCategoryPanel
            Top = 190
            Height = 245
            Caption = 'Equalizer and Effects'
            TabOrder = 1
            object lblJingles: TLabel
              Left = 16
              Top = 88
              Width = 238
              Height = 14
              Caption = 'Jingles (playback via F9, Push-to-talk via F8)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object LblConst_JingleVolume: TLabel
              Left = 16
              Top = 159
              Width = 80
              Height = 13
              Hint = 'Volume of the jingle in relation to main volume.'
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Volume of jingles'
            end
            object LblConst_JingleVolumePercent: TLabel
              Left = 91
              Top = 183
              Width = 86
              Height = 13
              Hint = 'Volume of the jingle in relation to main volume.'
              Caption = '% of main volume'
            end
            object LblJingleReduce: TLabel
              Left = 91
              Top = 135
              Width = 11
              Height = 13
              Caption = '%'
            end
            object CB_UseDefaultEffects: TCheckBox
              Left = 16
              Top = 36
              Width = 414
              Height = 17
              Hint = 'Disable effects when Nemp starts'
              Caption = 'Reset effects on start'
              Checked = True
              State = cbChecked
              TabOrder = 1
            end
            object CB_UseDefaultEqualizer: TCheckBox
              Left = 16
              Top = 16
              Width = 414
              Height = 17
              Hint = 'Disable equalizer when Nemp starts'
              Caption = 'Reset equalizer on start'
              TabOrder = 0
            end
            object cb_UseWalkmanMode: TCheckBox
              Left = 16
              Top = 56
              Width = 414
              Height = 17
              Hint = 'Just as those cassette players did before "mp3" was invented.'
              Caption = 'Flutter playback when battery is low ("Walkman mode")'
              TabOrder = 2
            end
            object CBJingleReduce: TCheckBox
              Left = 16
              Top = 108
              Width = 414
              Height = 17
              Hint = 'Reduce main volume before when playing a jingle'
              Caption = 'Reduce main volume to'
              TabOrder = 3
              OnClick = CBJingleReduceClick
            end
            object SEJingleReduce: TSpinEdit
              Left = 35
              Top = 131
              Width = 49
              Height = 22
              Hint = 'Reduce main volume before when playing a jingle'
              MaxValue = 100
              MinValue = 0
              TabOrder = 4
              Value = 50
            end
            object SEJingleVolume: TSpinEdit
              Left = 35
              Top = 178
              Width = 49
              Height = 22
              Hint = 'Volume of the jingle in relation to main volume.'
              MaxValue = 200
              MinValue = 0
              TabOrder = 5
              Value = 100
            end
          end
        end
      end
      object tabBirthday: TTabSheet
        Caption = 'Birthday'
        ImageIndex = 13
        object cpgBirthday: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpBirthdayMain: TCategoryPanel
            Top = 0
            Height = 409
            Caption = 'Happy Birthday timer'
            TabOrder = 0
            object Lbl_Const_EventTime: TLabel
              Left = 16
              Top = 80
              Width = 22
              Height = 13
              Hint = 
                'Time when the birthday song should be played. The optional count' +
                'down will end at this time.'
              Caption = 'Time'
            end
            object lblBirthdayTitel: TLabel
              Left = 16
              Top = 111
              Width = 100
              Height = 13
              Caption = 'Happy Birthday song'
            end
            object LblEventWarning: TLabel
              Left = 329
              Top = 111
              Width = 76
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = 'File not found'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ExplicitLeft = 352
            end
            object lblCountDownTitel: TLabel
              Left = 16
              Top = 218
              Width = 76
              Height = 13
              Caption = 'Countdown title'
            end
            object LBlCountDownWarning: TLabel
              Left = 329
              Top = 218
              Width = 76
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              Caption = 'File not found'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ExplicitLeft = 352
            end
            object lblHappyBirthday: TLabel
              Left = 16
              Top = 16
              Width = 426
              Height = 55
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'If you are celebrating into a birthday, or celebrating into the ' +
                'New Year and you don'#39't want to miss midnight, then you can activ' +
                'ate the Happy Birthday timer. Nemp will then pause the playlist ' +
                'at the specified time to play a special song.'
              WordWrap = True
              ExplicitWidth = 449
            end
            object BtnActivateBirthdayMode: TButton
              AlignWithMargins = True
              Left = 316
              Top = 337
              Width = 131
              Height = 25
              Anchors = [akTop, akRight]
              Caption = 'Activate'
              TabOrder = 9
              OnClick = BtnActivateBirthdayModeClick
            end
            object BtnBirthdaySong: TButton
              Left = 414
              Top = 127
              Width = 25
              Height = 21
              Hint = 'Select file'
              Anchors = [akTop, akRight]
              Caption = '...'
              TabOrder = 2
              OnClick = BtnBirthdaySongClick
            end
            object BtnGetBirthdayTitel: TButton
              Left = 16
              Top = 153
              Width = 281
              Height = 25
              Hint = 'Use the current selected file in player as birthday song.'
              Caption = 'Use selected file in mainwindow'
              TabOrder = 3
              OnClick = BtnGetBirthdayTitelClick
            end
            object CBContinueAfter: TCheckBox
              Left = 16
              Top = 314
              Width = 410
              Height = 17
              Hint = 'Continue with the playlist after the birthday song.'
              Caption = 'Continue with the playlist after playing the birthday song'
              TabOrder = 8
            end
            object EditBirthdaySong: TEdit
              Left = 16
              Top = 127
              Width = 392
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnChange = EditBirthdaySongChange
            end
            object mskEdt_BirthdayTime: TMaskEdit
              Left = 64
              Top = 77
              Width = 41
              Height = 21
              EditMask = '!90:00;1;_'
              MaxLength = 5
              TabOrder = 0
              Text = '  :  '
              OnExit = mskEdt_BirthdayTimeExit
            end
            object BtnCountDownSong: TButton
              Left = 414
              Top = 234
              Width = 25
              Height = 21
              Hint = 'Select file'
              Anchors = [akTop, akRight]
              Caption = '...'
              TabOrder = 6
              OnClick = BtnCountDownSongClick
            end
            object BtnGetCountDownTitel: TButton
              Left = 16
              Top = 261
              Width = 281
              Height = 25
              Hint = 'Use the current selected file in player as countdown.'
              Caption = 'Use selected file in mainwindow'
              TabOrder = 7
              OnClick = BtnGetCountDownTitelClick
            end
            object CBStartCountDown: TCheckBox
              Left = 16
              Top = 196
              Width = 417
              Height = 17
              Hint = 'Signalize birthday song with a countdown.'
              Caption = 'Start a countdown before the actual time'
              TabOrder = 4
              OnClick = CBStartCountDownClick
            end
            object EditCountdownSong: TEdit
              Left = 16
              Top = 234
              Width = 392
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 5
              OnChange = EditCountdownSongChange
            end
          end
        end
      end
      object tabLastfm: TTabSheet
        Caption = 'LastFM'
        ImageIndex = 14
        object cpgScrobble: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpScrobbleLog: TCategoryPanel
            Top = 313
            Height = 240
            Caption = 'Scrobble log (this session only)'
            TabOrder = 2
            object MemoScrobbleLog: TMemo
              Left = 0
              Top = 0
              Width = 455
              Height = 214
              Align = alClient
              Lines.Strings = (
                'MemoScrobbleLog')
              ReadOnly = True
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
          object cpScrobbleSettings: TCategoryPanel
            Top = 153
            Height = 160
            Caption = 'Scrobble settings'
            TabOrder = 1
            object Label5: TLabel
              Left = 32
              Top = 72
              Width = 343
              Height = 13
              Caption = 
                'In case scrobbling was paused automatically and you fixed the re' +
                'ason: '
            end
            object Btn_ScrobbleAgain: TButton
              Left = 32
              Top = 88
              Width = 145
              Height = 25
              Hint = 'Restart scrobbling.'
              Caption = 'Scrobble again!'
              TabOrder = 3
              OnClick = Btn_ScrobbleAgainClick
            end
            object CB_AlwaysScrobble: TCheckBox
              Left = 16
              Top = 16
              Width = 414
              Height = 17
              Hint = 'Always begin scrobbling when nemp starts.'
              Caption = 'Scrobble always'
              TabOrder = 0
            end
            object CB_ScrobbleThisSession: TCheckBox
              Left = 16
              Top = 32
              Width = 414
              Height = 17
              Hint = 'Begin scrobbling now.'
              Caption = 'Scrobble this session'
              TabOrder = 1
            end
            object CB_SilentError: TCheckBox
              Left = 16
              Top = 49
              Width = 414
              Height = 17
              Hint = 
                'Ignore hard failures like "no internet connection", "invalid use' +
                'rname/password", ...'
              Caption = 
                'Ignore hard failures - just stop scrobbling if something goes wr' +
                'ong'
              TabOrder = 2
            end
          end
          object cpScrobbleSetup: TCategoryPanel
            Top = 0
            Height = 153
            Caption = 'last.fm Scrobbler setup'
            TabOrder = 0
            object Image2: TImage
              AlignWithMargins = True
              Left = 364
              Top = 73
              Width = 80
              Height = 28
              Cursor = crHandPoint
              Anchors = [akTop, akRight]
              Picture.Data = {
                07544269746D6170761A0000424D761A00000000000036000000280000005000
                00001C0000000100180000000000401A00000000000000000000000000000000
                0000D0D2F63339D9040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1
                040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040C
                D1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD104
                0CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1
                040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040C
                D1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD104
                0CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1040CD1
                040CD1040CD1040CD1040CD13339D9D0D2F6343CD9060FD1060FD1060FD1060F
                D1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD106
                0FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1
                060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060F
                D1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD106
                0FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1
                060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060F
                D1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD1060FD134
                3CD90811D20811D20811D20811D20811D20811D20811D20811D20811D20811D2
                0811D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811
                D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811D208
                11D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811D2
                0811D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811
                D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811D208
                11D20811D20811D20811D20811D20811D20811D20811D20811D20811D20811D2
                0811D20811D20811D20811D20811D20811D20A13D20A13D20A13D20A13D20A13
                D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A
                13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D2
                0A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13
                D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A
                13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D2
                0A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13
                D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A13D20A
                13D20D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D3
                0D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15
                D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D
                15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D3
                0D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15
                D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D
                15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D30D15D3
                0D15D30D15D30D15D30D15D30D15D30D15D30F18D30F18D30F18D30F18D30F18
                D30F18D30F18D30F18D33C43DB787DE64B52DE2D35D90F18D30F18D30F18D32D
                35D9696FE4878CE9878CE95A60E11E26D60F18D30F18D30F18D30F18D30F18D3
                4B52DE878CE9878CE9878CE9696FE43C43DB0F18D30F18D30F18D30F18D30F18
                D30F18D35A60E1878CE9878CE9696FE42D35D90F18D30F18D32D35D94B52DE2D
                35D90F18D30F18D30F18D34B52DE4B52DE3C43DB0F18D30F18D30F18D31E26D6
                4B52DE4B52DE2D35D90F18D30F18D30F18D32D35D94B52DE4B52DE1E26D60F18
                D30F18D30F18D33C43DB4B52DE4B52DE0F18D30F18D30F18D30F18D30F18D30F
                18D3111AD4111AD4111AD4111AD4111AD4111AD4111AD4969AECFFFFFFFFFFFF
                FFFFFF888DEA111AD42028D7B4B7F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FF969AEC111AD4111AD4888DEAF0F1FCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFC3C6F42028D7111AD4111AD4111AD4C3C6F4FFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFF2028D72028D7F0F1FCFFFFFFFFFFFF4D53DF111AD4111AD4FFFFFFFFFF
                FFC3C6F4111AD4111AD4111AD44D53DFFFFFFFFFFFFF888DEA111AD4111AD411
                1AD4888DEAFFFFFFFFFFFF4D53DF111AD4111AD4111AD4C3C6F4FFFFFFFFFFFF
                111AD4111AD4111AD4111AD4111AD4111AD4131CD4131CD4131CD4131CD4131C
                D4131CD43138D9FFFFFFFFFFFFFFFFFFFFFFFF898EEA131CD4C4C6F4FFFFFFFF
                FFFFFFFFFFE1E3FAE1E3FAFFFFFFFFFFFFE1E3FA131CD4A6AAEFFFFFFFFFFFFF
                FFFFFFF0F1FCC4C6F4C4C6F4FFFFFFFFFFFFFFFFFFC4C6F4131CD4131CD46C71
                E4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0F1FC131CD44E55DFFFFFFFFFFFFFFF
                FFFF898EEA131CD4131CD4FFFFFFFFFFFFC4C6F4131CD4131CD4131CD44E55DF
                FFFFFFFFFFFF898EEA131CD4131CD4131CD4898EEAFFFFFFFFFFFF4E55DF131C
                D4131CD4131CD4C4C6F4FFFFFFFFFFFF131CD4131CD4131CD4131CD4131CD413
                1CD4161ED4161ED4161ED4161ED4161ED4161ED45056DFFFFFFFFFFFFFE2E3FA
                5056DF333AD95056DFFFFFFFFFFFFFFFFFFF5F65E1161ED4161ED4333AD9D3D5
                F78B8FEA5056DFFFFFFFFFFFFFFFFFFF7C81E7161ED4161ED4161ED4252CD7E2
                E3FAFFFFFFFFFFFF161ED4161ED48B8FEAFFFFFFFFFFFFB6B8F2161ED4333AD9
                7C81E7161ED44248DCFFFFFFFFFFFFFFFFFF6E73E4161ED4161ED4FFFFFFFFFF
                FFC5C7F4161ED4161ED4161ED45056DFFFFFFFFFFFFF8B8FEA161ED4161ED416
                1ED48B8FEAFFFFFFFFFFFF5056DF161ED4161ED4161ED4C5C7F4FFFFFFFFFFFF
                161ED4161ED4161ED4161ED4161ED4161ED41821D51821D51821D51821D51821
                D51821D55259E0FFFFFFFFFFFFC5C7F41821D51821D58C90EAFFFFFFFFFFFF9A
                9DED1821D51821D51821D51821D51821D5262FD8B7B9F2FFFFFFFFFFFF8C90EA
                1821D51821D51821D51821D5262FD8E2E3FAFFFFFFFFFFFF1821D51821D58C90
                EAFFFFFFFFFFFF5259E01821D51821D51821D51821D51821D55259E08C90EA6F
                75E51821D51821D51821D5FFFFFFFFFFFFC5C7F41821D51821D51821D55259E0
                FFFFFFFFFFFF8C90EA1821D51821D51821D58C90EAFFFFFFFFFFFF5259E01821
                D51821D51821D5C5C7F4FFFFFFFFFFFF1821D51821D51821D51821D51821D518
                21D51A23D61A23D61A23D61A23D61A23D61A23D6535AE0FFFFFFFFFFFFC6C8F5
                1A23D61A23D6C6C8F5FFFFFFFFFFFF535AE01A23D61A23D61A23D61A23D61A23
                D62831D9FFFFFFFFFFFFF1F1FC2831D91A23D6373FDB7076E5A9ACF0F1F1FCFF
                FFFFFFFFFFE2E3FA1A23D61A23D68D91EBFFFFFFFFFFFF535AE01A23D61A23D6
                1A23D61A23D61A23D61A23D61A23D61A23D61A23D61A23D61A23D6FFFFFFFFFF
                FFC6C8F51A23D61A23D61A23D6535AE0FFFFFFFFFFFF8D91EB1A23D61A23D61A
                23D68D91EBFFFFFFFFFFFF535AE01A23D61A23D61A23D6C6C8F5FFFFFFFFFFFF
                1A23D61A23D61A23D61A23D61A23D61A23D61D25D61D25D61D25D61D25D61D25
                D61D25D6565CE0FFFFFFFFFFFFC6C8F51D25D61D25D6C6C8F5FFFFFFFFFFFF56
                5CE01D25D61D25D61D25D61D25D61D25D67277E5FFFFFFFFFFFFAAADF02B33D9
                C6C8F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1FC484EDE1D25D61D25D68E92
                EBFFFFFFFFFFFF565CE01D25D61D25D61D25D61D25D61D25D61D25D61D25D61D
                25D61D25D61D25D61D25D6FFFFFFFFFFFFC6C8F51D25D61D25D61D25D6565CE0
                FFFFFFFFFFFF8E92EB1D25D61D25D61D25D68E92EBFFFFFFFFFFFF565CE01D25
                D61D25D61D25D6C6C8F5FFFFFFFFFFFF1D25D61D25D61D25D61D25D61D25D61D
                25D61F27D71F27D71F27D71F27D71F27D71F27D7575DE1FFFFFFFFFFFFC7C9F5
                1F27D71F27D7C7C9F5FFFFFFFFFFFF575DE11F27D71F27D71F27D71F27D71F27
                D7B9BBF2FFFFFFFFFFFF656BE4ABAEF0FFFFFFFFFFFFFFFFFFFFFFFFC7C9F59D
                A0ED3B42DC1F27D71F27D71F27D78F93EBFFFFFFFFFFFF575DE11F27D71F27D7
                1F27D71F27D71F27D71F27D71F27D71F27D71F27D71F27D71F27D7FFFFFFFFFF
                FFC7C9F51F27D71F27D71F27D7575DE1FFFFFFFFFFFFABAEF01F27D71F27D71F
                27D78F93EBFFFFFFFFFFFF575DE11F27D71F27D71F27D7C7C9F5FFFFFFFFFFFF
                1F27D71F27D71F27D71F27D71F27D71F27D7212AD7212AD7212AD7212AD7212A
                D7212AD7595FE1FFFFFFFFFFFFC7CAF5212AD7212AD79095EBFFFFFFFFFFFF83
                88E9212AD7212AD7212AD7212AD73D45DCFFFFFFFFFFFFF1F2FC2F37DAF1F2FC
                FFFFFFFFFFFF757AE6212AD7212AD7212AD7212AD7212AD7212AD7212AD79095
                EBFFFFFFFFFFFF595FE1212AD7212AD7212AD7212AD7212AD7212AD7212AD721
                2AD7212AD7212AD7212AD7FFFFFFFFFFFFC7CAF5212AD7212AD7212AD7595FE1
                FFFFFFFFFFFFD5D7F7212AD7212AD7212AD79095EBFFFFFFFFFFFF8388E9212A
                D7212AD7212AD7D5D7F7FFFFFFFFFFFF212AD7212AD7212AD7212AD7212AD721
                2AD7232CD8232CD8232CD8232CD8232CD8232CD85A61E2FFFFFFFFFFFFC8CAF5
                232CD8232CD84C54DFFFFFFFFFFFFFF1F2FD3139DA232CD8232CD8232CD8BABD
                F3FFFFFFFFFFFFACB0F0232CD8F1F2FDFFFFFFD6D7F8232CD8232CD8232CD8E3
                E5FAC8CAF5C8CAF5232CD8232CD89196ECFFFFFFFFFFFF5A61E2232CD8232CD8
                232CD8232CD8232CD8232CD8232CD8232CD8232CD8232CD8232CD8FFFFFFFFFF
                FFC8CAF5232CD8232CD8232CD85A61E2FFFFFFFFFFFFFFFFFF5A61E2232CD823
                2CD8D6D7F8FFFFFFFFFFFFE3E5FA3139DA232CD84C54DFFFFFFFFFFFFFFFFFFF
                232CD8232CD8232CD8232CD8232CD8232CD8262ED8262ED8262ED8262ED8262E
                D8262ED85C62E2FFFFFFFFFFFFC9CBF5262ED8262ED8262ED8C9CBF5FFFFFFFF
                FFFFF1F2FDA0A3EE9397ECE4E5FAFFFFFFFFFFFFF1F2FD4148DD262ED8BBBDF3
                FFFFFFFFFFFFBBBDF39397ECBBBDF3FFFFFFFFFFFFD6D8F84F55DFC9CBF5E4E5
                FAFFFFFFFFFFFFD6D8F8C9CBF5C9CBF5A0A3EE262ED8262ED8262ED8262ED826
                2ED8262ED8A0A3EEC9CBF5FFFFFFFFFFFFF1F2FDC9CBF5C9CBF5A0A3EE5C62E2
                FFFFFFFFFFFFF1F2FDFFFFFFC9CBF5E4E5FAFFFFFFFFFFFFFFFFFFFFFFFFF1F2
                FDC9CBF5F1F2FDFFFFFFFFFFFFE4E5FA262ED8262ED8262ED8262ED8262ED826
                2ED82830D92830D92830D92830D92830D92830D95E64E3FFFFFFFFFFFFC9CBF5
                2830D92830D92830D9353DDBD7D8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFF2F2FD5057E02830D92830D95057E0F2F2FDFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFF5E64E35E64E3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                C9CBF52830D92830D92830D92830D92830D92830D9C9CBF5FFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFC9CBF55E64E3FFFFFFFFFFFF868BEAF2F2FDFFFFFFFF
                FFFFFFFFFFFFFFFFA1A4EEA1A4EEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797EE7
                2830D92830D92830D92830D92830D92830D92A33D92A33D92A33D92A33D92A33
                D92A33D95F66E3FFFFFFFFFFFFCACCF52A33D92A33D92A33D92A33D92A33D97A
                80E7AFB2F1CACCF5CACCF5BCBFF3888DEA3740DB2A33D92A33D92A33D92A33D9
                3740DB888DEACACCF5CACCF5CACCF5A1A5EE454DDE2A33D9454DDE9599ECCACC
                F5FFFFFFFFFFFFAFB2F19599EC9599EC7A80E72A33D92A33D92A33D92A33D92A
                33D92A33D97A80E79599ECFFFFFFFFFFFFE4E5FA9599EC9599EC7A80E7454DDE
                9599EC9599EC454DDE454DDEAFB2F1CACCF5CACCF5888DEA2A33D92A33D96D73
                E5BCBFF3CACCF5BCBFF36D73E52A33D92A33D92A33D92A33D92A33D92A33D92A
                33D92D35DA2D35DA2D35DA2D35DA2D35DA2D35DA6268E3FFFFFFFFFFFFCACCF6
                2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35
                DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D
                35DA2D35DA2D35DA2D35DA2D35DA969AEDFFFFFFFFFFFF6268E32D35DA2D35DA
                2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DAFFFFFFFFFF
                FFCACCF62D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D
                35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA
                2D35DA2D35DA2D35DA2D35DA2D35DA2D35DA2F37DA2F37DA2F37DA2F37DA2F37
                DA2F37DA6369E3FFFFFFFFFFFFCBCDF62F37DA2F37DA2F37DA2F37DA2F37DA2F
                37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA
                2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA979B
                EDFFFFFFFFFFFF6369E32F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F
                37DA2F37DA2F37DA2F37DAFFFFFFFFFFFFFFFFFF3C44DC2F37DA2F37DA4950DF
                2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37
                DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F37DA2F
                37DA3139DB3139DB3139DB3139DB3139DB3139DB656BE4FFFFFFFFFFFFCBCDF6
                3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139
                DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB31
                39DB3139DB3139DB3139DB3139DB3139DB3139DB585EE23E45DD3139DB3139DB
                3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DBBEC1F4FFFF
                FFFFFFFFE5E6FACBCDF6E5E6FAA5A8EF3139DB3139DB3139DB3139DB3139DB31
                39DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB3139DB
                3139DB3139DB3139DB3139DB3139DB3139DB333CDB333CDB333CDB333CDB333C
                DB333CDB666DE4FFFFFFFFFFFFCCCEF6333CDB333CDB333CDB333CDB333CDB33
                3CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB
                333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333C
                DB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB33
                3CDB333CDB333CDB333CDB5961E2F2F3FDFFFFFFFFFFFFFFFFFFFFFFFFCCCEF6
                333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333C
                DB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB333CDB33
                3CDB363EDC363EDC363EDC363EDC363EDC363EDC4F56E09B9FEE9B9FEE8287E9
                363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363E
                DC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC36
                3EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC
                363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC434A
                DE9B9FEECDCFF6CDCFF6C0C2F4757BE7363EDC363EDC363EDC363EDC363EDC36
                3EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC363EDC
                363EDC363EDC363EDC363EDC363EDC363EDC3840DC3840DC3840DC3840DC3840
                DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC38
                40DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC
                3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840
                DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC38
                40DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC
                3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840
                DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC3840DC38
                40DC3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD
                3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42
                DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A
                42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD
                3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42
                DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A
                42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD
                3A42DD3A42DD3A42DD3A42DD3A42DD3A42DD3C45DD3C45DD3C45DD3C45DD3C45
                DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C
                45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD
                3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45
                DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C
                45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD
                3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45
                DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C45DD3C
                45DD6369E43F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE
                3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47
                DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F
                47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE
                3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47
                DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F
                47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE3F47DE
                3F47DE3F47DE3F47DE3F47DE3F47DE6369E4DBDCF8646BE44149DE4149DE4149
                DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE41
                49DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE
                4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149
                DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE41
                49DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE
                4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149
                DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE4149DE646BE4DB
                DCF8}
              OnClick = Image2Click
              ExplicitLeft = 370
            end
            object LblScrobble1: TLabel
              Left = 16
              Top = 16
              Width = 426
              Height = 57
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              Caption = 
                'Nemp can scrobble what you hear to your account on LastFM. To do' +
                ' this, Nemp needs your permission to access your account. Go onl' +
                'ine and click the button below to start the configuration.'
              WordWrap = True
              ExplicitWidth = 432
            end
            object LblVisitLastFM: TLabel
              AlignWithMargins = True
              Left = 188
              Top = 80
              Width = 172
              Height = 13
              Alignment = taRightJustify
              Anchors = [akTop, akRight]
              AutoSize = False
              Caption = 'For details visit'
              ExplicitLeft = 194
            end
            object BtnScrobbleWizard: TButton
              Left = 16
              Top = 76
              Width = 75
              Height = 25
              Caption = 'Start'
              TabOrder = 0
              OnClick = BtnScrobbleWizardClick
            end
          end
        end
      end
      object tabWebserver: TTabSheet
        Caption = 'Webserver'
        ImageIndex = 15
        object cpgWebserverConfiguration: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          OnMouseWheel = CategoryPanelGroupMouseWheel
          object cpWebServerUrls: TCategoryPanel
            Top = 409
            Height = 650
            Caption = 'Webserver URLs'
            TabOrder = 2
            object LabelLANIP: TLabel
              Left = 16
              Top = 16
              Width = 121
              Height = 13
              AutoSize = False
              Caption = 'Your IP (LAN)'
              Transparent = True
            end
            object LblConst_IPWAN: TLabel
              Left = 16
              Top = 59
              Width = 86
              Height = 13
              Caption = 'Your IP (Internet)'
              Transparent = True
            end
            object imgQRCode: TImage
              Left = 17
              Top = 204
              Width = 400
              Height = 400
              Stretch = True
            end
            object lblQRCode: TLabel
              Left = 17
              Top = 118
              Width = 44
              Height = 14
              Caption = 'QRCode'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object lblCurrentQRCodeURL: TLabel
              Left = 17
              Top = 185
              Width = 120
              Height = 13
              Caption = 'Current URL in QRCode: '
            end
            object BtnGetIPs: TButton
              Left = 222
              Top = 73
              Width = 159
              Height = 25
              Hint = 
                'Get your Internet-IP (done via a little php-script on www.gausi.' +
                'de).'
              Caption = 'Get IP-address'
              TabOrder = 2
              OnClick = BtnGetIPsClick
            end
            object cbLANIPs: TComboBox
              Left = 17
              Top = 32
              Width = 200
              Height = 21
              Hint = 'Your IP(s) inside the local area network (LAN).'
              Style = csDropDownList
              TabOrder = 0
              OnChange = ChangeWebserverLinks
              Items.Strings = (
                '')
            end
            object EdtGlobalIP: TEdit
              Left = 16
              Top = 75
              Width = 200
              Height = 21
              Hint = 
                'Your IP "in the internet". You have to configure your router and' +
                '/or firewall properly (e.g. forwarding Port80 to your machine) '
              ReadOnly = True
              TabOrder = 1
              Text = '?'
            end
            object cbWebserverAdminQRCode: TCheckBox
              AlignWithMargins = True
              Left = 17
              Top = 138
              Width = 315
              Height = 17
              Caption = 'Include "\admin" in QRCode URL'
              TabOrder = 3
              OnClick = ChangeWebserverLinks
            end
            object cbWebserverInternetQRCode: TCheckBox
              AlignWithMargins = True
              Left = 17
              Top = 158
              Width = 315
              Height = 17
              Caption = 'Use Internet-IP'
              Enabled = False
              TabOrder = 4
              OnClick = ChangeWebserverLinks
            end
          end
          object cbWebserverUserRights: TCategoryPanel
            Top = 209
            Caption = 'User rights'
            TabOrder = 1
            ExplicitWidth = 457
            object LblConst_Password2: TLabel
              Left = 224
              Top = 16
              Width = 46
              Height = 13
              Hint = 'Set username and password to access your library'
              Caption = 'Password'
            end
            object LblConst_Username2: TLabel
              Left = 16
              Top = 16
              Width = 48
              Height = 13
              Hint = 'Set username and password to access your library.'
              Caption = 'Username'
            end
            object LblWebserverUserURL: TLabel
              Left = 17
              Top = 59
              Width = 74
              Height = 13
              Cursor = crHandPoint
              Caption = 'http://localhost'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsUnderline]
              ParentFont = False
              OnClick = LblWebserverUserURLClick
            end
            object cbAllowRemoteControl: TCheckBox
              Left = 16
              Top = 130
              Width = 397
              Height = 15
              Hint = 'Let the user control the player (play/stop/next/volume/...)'
              Caption = 'Permit remote control of the player'
              TabOrder = 5
              OnClick = ChangeWebserverLinks
            end
            object cbPermitLibraryAccess: TCheckBox
              Left = 16
              Top = 98
              Width = 397
              Height = 15
              Hint = 'Let the user search and browse in your library'
              Caption = 'Permit access to the media library (read only)'
              TabOrder = 3
            end
            object cbPermitPlaylistDownload: TCheckBox
              Left = 16
              Top = 114
              Width = 397
              Height = 15
              Hint = 'Let the user download files from your playlist and/or library'
              Caption = 'Permit downloading files from the playlist'
              TabOrder = 4
            end
            object cbPermitVote: TCheckBox
              Left = 16
              Top = 80
              Width = 397
              Height = 15
              Hint = 
                'Let the user vote for files - files with many votes will be play' +
                'ed first'
              Caption = 'Permit voting for files'
              TabOrder = 2
            end
            object EdtPassword: TEdit
              Left = 223
              Top = 32
              Width = 200
              Height = 21
              TabOrder = 1
              OnKeyPress = EdtPasswordKeyPress
            end
            object EdtUsername: TEdit
              Left = 17
              Top = 32
              Width = 200
              Height = 21
              TabOrder = 0
              OnKeyPress = EdtUsernameKeyPress
            end
          end
          object cpWebserverConfiguration: TCategoryPanel
            Top = 0
            Height = 209
            Caption = 'Webserver configuration'
            TabOrder = 0
            object Label7: TLabel
              Left = 16
              Top = 85
              Width = 88
              Height = 13
              Hint = 'Set username and password to access your library.'
              Caption = 'Username (Admin)'
            end
            object Label8: TLabel
              Left = 224
              Top = 85
              Width = 86
              Height = 13
              Hint = 'Set username and password to access your library'
              Caption = 'Password (Admin)'
            end
            object LblWebServer_Port: TLabel
              Left = 183
              Top = 16
              Width = 20
              Height = 13
              Caption = 'Port'
            end
            object LblWebserverAdminURL: TLabel
              Left = 16
              Top = 127
              Width = 106
              Height = 13
              Cursor = crHandPoint
              Caption = 'http://localhost/admin'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlue
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsUnderline]
              ParentFont = False
              OnClick = LblWebserverAdminURLClick
            end
            object LblWebServerTheme: TLabel
              Left = 16
              Top = 16
              Width = 32
              Height = 13
              Caption = 'Theme'
            end
            object BtnServerActivate: TButton
              Left = 298
              Top = 145
              Width = 125
              Height = 25
              Caption = 'Activate server'
              TabOrder = 6
              OnClick = BtnServerActivateClick
            end
            object BtnShowWebserverLog: TButton
              Left = 165
              Top = 145
              Width = 125
              Height = 25
              Caption = 'Show Log'
              TabOrder = 5
              OnClick = BtnShowWebserverLogClick
            end
            object CBAutoStartWebServer: TCheckBox
              Left = 16
              Top = 62
              Width = 393
              Height = 17
              Hint = 'Automatically activate the webserver when Nemp starts.'
              Caption = 'Activate webserver on start'
              TabOrder = 2
            end
            object cbWebserverRootDir: TComboBox
              Left = 16
              Top = 32
              Width = 155
              Height = 21
              Style = csDropDownList
              TabOrder = 0
            end
            object EdtPasswordAdmin: TEdit
              Left = 223
              Top = 100
              Width = 200
              Height = 21
              TabOrder = 4
              OnKeyPress = EdtPasswordKeyPress
            end
            object EdtUsernameAdmin: TEdit
              Left = 16
              Top = 100
              Width = 200
              Height = 21
              TabOrder = 3
              OnKeyPress = EdtUsernameAdminKeyPress
            end
            object seWebServer_Port: TSpinEdit
              Left = 183
              Top = 31
              Width = 75
              Height = 22
              MaxValue = 65535
              MinValue = 0
              TabOrder = 1
              Value = 80
              OnChange = ChangeWebserverLinks
            end
          end
        end
      end
      object tabCoverflow: TTabSheet
        Caption = '3D-CoverFlow'
        ImageIndex = 8
        object PnlCoverFlowControl: TPanel
          Left = 0
          Top = 538
          Width = 461
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            461
            30)
          object BtnUndoCoverFlowSettings: TButton
            AlignWithMargins = True
            Left = 328
            Top = 3
            Width = 123
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Undo'
            TabOrder = 0
            OnClick = BtnUndoCoverFlowSettingsClick
          end
          object BtnCoverFlowDefault: TButton
            AlignWithMargins = True
            Left = 189
            Top = 3
            Width = 123
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Default'
            TabOrder = 1
            OnClick = BtnCoverFlowDefaultClick
          end
        end
        object cpgCoverFlowView: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 538
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpCoverflowMixedSettings: TCategoryPanel
            Top = 570
            Height = 150
            Caption = 'Mixed settings'
            TabOrder = 5
            ExplicitWidth = 457
            object lblCoverflowTextures: TLabel
              Left = 92
              Top = 19
              Width = 159
              Height = 13
              Caption = 'max. number of displayed covers'
            end
            object shapeCoverflowColor: TShape
              Left = 16
              Top = 88
              Width = 21
              Height = 21
              OnMouseDown = shapeCoverflowColorMouseDown
            end
            object lblCoverFlowColor: TLabel
              Left = 16
              Top = 69
              Width = 243
              Height = 13
              Caption = 'Default background color (Windows standard only)'
            end
            object cb_UseClassicCoverflow: TCheckBox
              Left = 16
              Top = 44
              Width = 409
              Height = 17
              Hint = 'Classic coverflow for systems without OpenGL-support'
              Caption = 'Use classic 2D coverflow'
              TabOrder = 1
            end
            object seCoverflowTextureCache: TSpinEdit
              Left = 16
              Top = 16
              Width = 67
              Height = 22
              MaxValue = 200
              MinValue = 20
              TabOrder = 0
              Value = 20
            end
            object edtCoverFlowColor: TEdit
              Left = 43
              Top = 88
              Width = 121
              Height = 21
              TabOrder = 2
            end
            object btnSelectCoverFlowColor: TButton
              Left = 170
              Top = 88
              Width = 31
              Height = 21
              Caption = '...'
              TabOrder = 3
              OnClick = btnSelectCoverFlowColorClick
            end
          end
          object cpCoverflowReflection: TCategoryPanel
            Top = 445
            Height = 125
            Caption = 'Reflection'
            TabOrder = 4
            ExplicitWidth = 457
            object lblCoverFlowIntensity: TLabel
              Left = 16
              Top = 37
              Width = 43
              Height = 13
              Caption = 'Intenisty'
            end
            object lblCoverflowReflexionGap: TLabel
              Left = 248
              Top = 37
              Width = 56
              Height = 13
              Anchors = [akTop, akRight]
              Caption = 'Vertical gap'
              ExplicitLeft = 240
            end
            object cbCoverFlowUseReflection: TCheckBox
              Left = 16
              Top = 16
              Width = 217
              Height = 17
              Caption = 'Enabled'
              TabOrder = 0
              OnClick = tbCoverZMainChange
            end
            object tbCoverReflexionGap: TNempTrackBar
              AlignWithMargins = True
              Left = 253
              Top = 56
              Width = 185
              Height = 22
              Anchors = [akTop, akRight]
              Max = 100
              PageSize = 5
              Frequency = 10
              Position = 20
              TabOrder = 2
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverReflexionIntensity: TNempTrackBar
              AlignWithMargins = True
              Left = 16
              Top = 56
              Width = 185
              Height = 22
              Max = 100
              PageSize = 5
              Frequency = 10
              Position = 15
              TabOrder = 1
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
          end
          object cpCoverflowAngles: TCategoryPanel
            Top = 345
            Height = 100
            Caption = 'Angles'
            TabOrder = 3
            ExplicitWidth = 457
            object lblCoverFlowAngleLeft: TLabel
              Left = 16
              Top = 16
              Width = 19
              Height = 13
              Caption = 'Left'
            end
            object lblCoverFlowAngleMain: TLabel
              Left = 159
              Top = 16
              Width = 67
              Height = 13
              Caption = 'Current cover'
            end
            object lblCoverFlowAngleRight: TLabel
              Left = 296
              Top = 16
              Width = 25
              Height = 13
              Anchors = [akTop, akRight]
              Caption = 'Right'
              ExplicitLeft = 298
            end
            object tbCoverAngleLeft: TNempTrackBar
              AlignWithMargins = True
              Left = 16
              Top = 30
              Width = 137
              Height = 22
              Max = 180
              Min = -180
              PageSize = 5
              Frequency = 30
              Position = -85
              TabOrder = 0
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverAngleMain: TNempTrackBar
              AlignWithMargins = True
              Left = 159
              Top = 30
              Width = 123
              Height = 22
              Max = 45
              Min = -45
              PageSize = 5
              Frequency = 10
              TabOrder = 1
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverAngleRight: TNempTrackBar
              AlignWithMargins = True
              Left = 301
              Top = 30
              Width = 137
              Height = 22
              Anchors = [akTop, akRight]
              Max = 180
              Min = -180
              PageSize = 5
              Frequency = 30
              Position = 85
              TabOrder = 2
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
          end
          object cpCoverflowSpacing: TCategoryPanel
            Top = 215
            Height = 130
            Caption = 'Spacing between cover art'
            TabOrder = 2
            ExplicitWidth = 457
            object lblCoverFlowGapLeft: TLabel
              Left = 16
              Top = 16
              Width = 19
              Height = 13
              Caption = 'Left'
            end
            object lblCoverFlowGapRight: TLabel
              Left = 248
              Top = 16
              Width = 25
              Height = 13
              Anchors = [akTop, akRight]
              Caption = 'Right'
              ExplicitLeft = 271
            end
            object tbCoverGapFirstLeft: TNempTrackBar
              AlignWithMargins = True
              Left = 16
              Top = 30
              Width = 185
              Height = 22
              Max = 500
              Min = 10
              PageSize = 5
              Frequency = 50
              Position = 100
              TabOrder = 0
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverGapFirstRight: TNempTrackBar
              AlignWithMargins = True
              Left = 253
              Top = 30
              Width = 185
              Height = 22
              Anchors = [akTop, akRight]
              Max = 500
              Min = 10
              PageSize = 5
              Frequency = 50
              Position = 100
              TabOrder = 1
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverGapLeft: TNempTrackBar
              AlignWithMargins = True
              Left = 16
              Top = 60
              Width = 185
              Height = 22
              Max = 500
              Min = 10
              PageSize = 5
              Frequency = 50
              Position = 100
              TabOrder = 2
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverGapRight: TNempTrackBar
              AlignWithMargins = True
              Left = 253
              Top = 58
              Width = 185
              Height = 22
              Anchors = [akTop, akRight]
              Max = 500
              Min = 10
              PageSize = 5
              Frequency = 50
              Position = 100
              TabOrder = 3
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
          end
          object cpCoverflowViewPosition: TCategoryPanel
            Top = 135
            Height = 80
            Caption = 'Viewing position (x-axis)'
            TabOrder = 1
            ExplicitWidth = 457
            object tbCoverViewPosition: TNempTrackBar
              AlignWithMargins = True
              Left = 16
              Top = 16
              Width = 427
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              Max = 180
              Min = -180
              PageSize = 5
              Frequency = 50
              Position = -85
              TabOrder = 0
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
          end
          object cpCoverflowPosition: TCategoryPanel
            Top = 0
            Height = 135
            Caption = 'Position of cover art (z-axis)'
            TabOrder = 0
            ExplicitWidth = 457
            object LblCoverZLeft: TLabel
              Left = 16
              Top = 41
              Width = 19
              Height = 13
              Caption = 'Left'
            end
            object lblCoverZMain: TLabel
              Left = 16
              Top = 16
              Width = 67
              Height = 13
              Caption = 'Current cover'
            end
            object LblCoverZRight: TLabel
              Left = 16
              Top = 66
              Width = 25
              Height = 13
              Caption = 'Right'
            end
            object tbCoverZLeft: TNempTrackBar
              AlignWithMargins = True
              Left = 88
              Top = 42
              Width = 350
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              Max = 150
              Min = -800
              PageSize = 10
              Frequency = 50
              Position = 100
              TabOrder = 1
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverZMain: TNempTrackBar
              AlignWithMargins = True
              Left = 88
              Top = 16
              Width = 350
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              Max = 150
              Min = -800
              PageSize = 10
              Frequency = 50
              Position = 100
              TabOrder = 0
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
            object tbCoverZRight: TNempTrackBar
              AlignWithMargins = True
              Left = 88
              Top = 68
              Width = 350
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              Max = 150
              Min = -800
              PageSize = 10
              Frequency = 50
              Position = 100
              TabOrder = 2
              ThumbLength = 15
              OnChange = tbCoverZMainChange
            end
          end
        end
      end
      object tabFiletypes: TTabSheet
        Caption = 'Filetypes'
        ImageIndex = 16
        object cpgFileTypesRegistration: TCategoryPanelGroup
          Left = 0
          Top = 0
          Width = 461
          Height = 568
          VertScrollBar.Tracking = True
          Align = alClient
          HeaderFont.Charset = DEFAULT_CHARSET
          HeaderFont.Color = clWindowText
          HeaderFont.Height = -12
          HeaderFont.Name = 'Segoe UI'
          HeaderFont.Style = []
          TabOrder = 0
          object cpFileTypeRegistration: TCategoryPanel
            Top = 0
            Height = 467
            Caption = 'Register file types'
            TabOrder = 0
            object lbl_AudioFormats: TLabel
              Left = 16
              Top = 16
              Width = 49
              Height = 13
              Caption = 'Audio files'
            end
            object lbl_PlaylistFormats: TLabel
              Left = 312
              Top = 16
              Width = 73
              Height = 13
              Caption = 'Playlist formats'
            end
            object lblFileTyperegistrationExplorer: TLabel
              Left = 16
              Top = 241
              Width = 145
              Height = 14
              Caption = 'Windows Explorer settings'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 16
              Top = 341
              Width = 449
              Height = 36
              AutoSize = False
              Caption = 
                'You need to confirm changes on this page separately. This ensure' +
                's that your Windows Registry is not changed by an oversight.'
              WordWrap = True
            end
            object Btn_SelectAll: TButton
              Left = 16
              Top = 195
              Width = 145
              Height = 25
              Caption = 'Select all'
              TabOrder = 2
              OnClick = Btn_SelectAllClick
            end
            object CBFileTypes: TCheckListBox
              Left = 16
              Top = 31
              Width = 290
              Height = 158
              Hint = 'List of supported audio files.'
              Columns = 4
              ItemHeight = 13
              TabOrder = 0
            end
            object CBPlaylistTypes: TCheckListBox
              Left = 312
              Top = 31
              Width = 113
              Height = 158
              Hint = 'List of supported playlist files.'
              ItemHeight = 13
              Items.Strings = (
                '.m3u'
                '.m3u8'
                '.pls'
                '.npl'
                '.asx'
                '.wax'
                '.cue')
              TabOrder = 1
            end
            object CBDirectorySupport: TCheckBox
              Left = 16
              Top = 300
              Width = 420
              Height = 17
              Hint = 
                'Add "Play/Enqueue in Nemp" to the context menu in the Windows Ex' +
                'plorer.'
              Caption = 'Context menus on directories'
              Checked = True
              State = cbChecked
              TabOrder = 5
            end
            object CBEnqueueStandard: TCheckBox
              Left = 16
              Top = 260
              Width = 420
              Height = 17
              Hint = 
                'Add a file to the playlist when double-clicking it in the Window' +
                's-Explorer. Otherwise the current playlist will be deleted.'
              Caption = '"Enqueue" as default action for audio files'
              Checked = True
              State = cbChecked
              TabOrder = 3
            end
            object CBEnqueueStandardLists: TCheckBox
              Left = 16
              Top = 280
              Width = 420
              Height = 17
              Hint = 
                'Add the files of a playlist to the current playlist when double-' +
                'clicking it in the Windows-Explorer. Otherwise the current playl' +
                'ist will be deleted.'
              Caption = '"Enqueue" as default action for playlists'
              Checked = True
              State = cbChecked
              TabOrder = 4
            end
            object BtnRegistryUpdate: TButton
              Left = 16
              Top = 391
              Width = 170
              Height = 25
              Hint = 'Register Nemp as default application for the selected filetypes.'
              Caption = 'Apply changes'
              TabOrder = 6
              OnClick = BtnRegistryUpdateClick
            end
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 638
    Width = 684
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      684
      38)
    object ImgHelp: TImage
      Left = 6
      Top = 0
      Width = 32
      Height = 32
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF40000001974455874536F6674776172650041646F62
        6520496D616765526561647971C9653C000008F34944415478DA9D570950D4D7
        19FFED0DAC2CB0BBC825720822201ED0AE1123F1AE6722B1029A38365E89699B
        B44E278E899D761233D1B4D369DA999878744C44BC8889F1A095E89826D18282
        9C02A2C0022E2CBBDC2C0B7BF67B8F5D5C10129337F32DC3FBDEFFBDDFFB7DE7
        13E0098772E5FB0A81EFA46D0E8178B3C3299CE1743A877502818004100A1C65
        42A7FD13674FD391F6CB6FF43CC9BE821FD2ABD30F463B64AA2FC412C9F4D4E4
        28C44C562326420DA94404BBDD0987C30EBBC30993D98A075A23EA9BDB71A75A
        0787CD5A21301BD71A3EDF5947FB387F0A00912AEBF48722897447D6CAD9484D
        8E80B71498E00D787BD16DD9AECE21A1F361B303DD26078CDD16749014DF7D88
        6B376A189043869319AFD272FB8F012009C83CAB4D8C0D0D79699D0661816228
        FD8082AA2E1454EA5159D70E43D700A71DAEEBA9FDBD9030598994B889489AA2
        44539B1935DA2E5CF9A606CDBA8E1663CEBA085A667D120012BF8C330DEB57CC
        0E5D362F06616AE081AE1F7FCF2D4157AF05129110429180EC2D18FED8C9D970
        7253D8EC0EF8C965D8B22A01214A394A6B3B70ABBC198577EA74ED27D7478E06
        311A00DDFC4CE3BAE5B383D9E19121C027FFAEC37F0A1A21239B8BE970B7C38D
        35864C3204C44236499B198667E74D4141851E8515CD2829D3B61A727E39D913
        84E756225546F6C7F171915B7FFD622AA6840AF0F1F95ADCAC68E5870B85427E
        B0DBEECE517EC5F8607AF71A87730844726C20D63D138BAF8B75C8FFB606FAD6
        B6A386531B5F76FB841B80C07FD1DE69D2B094BBEFFC6E0512A264C8BDAEC5B5
        A226C8A462888443CB98B35989E2419B83FEB20818022124BD84442A1642CACC
        E35ECF9970604E7C109E4E0AC395C226E47F5D09EBC3A2848EABFBAA19696E00
        5265E6A992ACD59AF8956951E83299F17E4E3179BD0822917078B301DA4C3D41
        8A03EB63911CA118C14091B607FB2FD5A3B6AD1F5E04C40D9A9BC36AC7E6E509
        14AA367C75A30E1577B5551419B3486DE1AB7CA6AD0A95FF6CFBC3BFEE5E8D69
        E122EC395C04F3A01D62DA48E072328BD58148B5174EBD3203DF37320F96A1A1
        7D80CC261CA69739A6974C8C1DAB9270F1463DB15085BEC2C361A6EA4B3AB646
        A44C3FB427756ECA3B9BD7CE44A7C984A317AAE025153DA292109808D0D99D49
        04C29BCFD5B49AB03FAF81DBFEE567C23027DACF756340B3AF00BE5E62B83EE7
        FE6025F6D6A446C3D069C6D51BF7A1AB7FF047C367DBDF634BBC0332728A5E48
        9F1BBF3A2D12976F6A5152DB06895834ECED8CFE3E0250B057C3FF67F65FF897
        DB3CF9307EBA89DA2BBB5210AE94717DF2DB05F0F77EE43B6E166226F9232E5C
        8DCFAF56A1F65E2399212B85AD08F0CFCAED78F3D5259837DD0FFB4F9412FD0E
        B2FDA38F995733C74B89F0457C881CBAAE417C55D5C91D8E39A58DF479AFCF84
        826ECD86E6DD5BF01B0580F9026375FD82381CCFAB44595923DAB2D3956C45A0
        5F666EDB9F5F5B8E390972EC39749B9C4F3C4CBF7B30166C24CC1C4CC5F43662
        82E1CCD99E08B5AF94AF6B683763D3D12A4CE026F4F89E451051B6654512FE75
        B11C65E58D3064A74F64A74C2400FA37772EC5BC2405FE74AC88908A79A67B2C
        D17830C22865517C625B3C5472E9F09AEDC7ABD1D831C043D27307270F613B36
        2D49C4E1F365A8AA6A660C047100FE04E08D1D8B317FA63FF61D2FA1D8178D09
        C0934EE613E75E4982BF8F88CF197AAD78EB7C1DB4ED833C0C3D6FEF09206B61
        3C3EFAA204F76B741E00B272F5BFDFBA100B662929FE4B5D996F6C008C05E6D1
        D342E538901ECDE7DAE8F02D9F5643404AA9E8F1C31FB166C7F36971F8F05C31
        EAEFEB1F01506EF84CBF63432A966882712CAF1A0316FB08071A0D609072C24B
        A9C1786EA69ACFBD7D498BDB9488BC28F6C7638E85A24C2CC6FC1993F0D1B93B
        D03519A13F3E0420509991FDDDB245C9B16B17C4A0ACAE0DF79BBB79E1F93E06
        E6442BF0872593F8DCAEDC0768EE6495727CB331270E51C92197497136FF2EBA
        F4FA5AFDC98DF37818062C7F6FEFF43969BBD2972642211722BFA89997DDB12E
        C30030EF37114BA641079F9B2013C287FC663C004E0EC08119514128AE694561
        49137AB5A57F6BCFDBBD8F272249605CBC72C581A24DCF6BB0282504E7BEB98F
        C171CCC06CC96AC28B3F9F88D5494A3E77B1BC03D9B7DAB8F38D057A887E1166
        C504530494A0E5613B3A2FEF4EB1186AAA782A260956679CF8AF46131FBD6C6E
        34FC15525E0945AEC6632495401F813BB3356EC47CC6D19AC762DF0D98F50889
        5181A87C60C0F55B0D307718EB5A4F6E4C2375AB7B777FEF98C54F2BE6FEF6C2
        8A458958F65438EA75DDA86BE9E62C083C40B0DB30EA4FFC6AEA88835E38768F
        EC3BD209DD9D5250809C6896528D29457F672F7A6EFE734D7FEDD56F49DD355C
        8E494294CFFEE383E0A8F8E7E66B62F00B02515E6784CED03BDC8CB86FC4D272
        66B21ACBE2FDF9DC15EA154F171B8966E1883E911D1EE0EB8330952F8E7C598A
        367D27AC46ED79C3F9DFBC4EEA16B8CB31861A93092451EA0DA7AF4D9B1AAE4A
        981A8CA59A708A882E34197A6863A147711A6A4C58516283391F735A77E0385D
        BF2A5F39E5791F7C9A578E96D66E584DBDEDADD9198B48594FD2078F86042E5F
        509144AB334F5E88890D574747AAB17876389CB47175A391F70443F9D5D525B8
        73B34783CAB211ABA4A12A05FAA94A9EC9AF4247671F6C7D3DC6D69CCC35B482
        BD13DA31AA25730F0909CB2E518159A72E04A80294119181488E0B4252B41A3D
        FD83E8EC1D40AF7990CC601FA68EFD4845227A2F48A90F90F166E47F952DB85E
        D4089B7900CEC1FE8ED613FC70767323C6694A47838850AFF960AF3820625548
        5800D44A052607F952A7ACA077829C129598DBD8EDE566AB0D0DBA1E7A0B1851
        ADED808980DA062CB077692F19BE7C6D1FEDA71D7DF87800DC200258787A45CE
        9BEEFBD4CE778512DF48859F37643209245E125E5EED94DB798966423E61B1D8
        E0A0FECF366885D3DADBD073F3E05BE686EF2A58B89174E2091F269E3EE1E3F2
        8B40B1223448A1D9B646AC9ABA542095478DDC44C077725AFAEAADC67BF93D85
        472ED87A747A52195CF6EEC78F7C9A79EA252E207212D60AB3E68F3586A38B05
        CBCB66926E12F63236B90EB6E2273E4EC76284E50B7A9A423CC6B7BC4C900C90
        58C6BBF1E8F17F3F8FF30A7AACC85E0000000049454E44AE426082}
      OnClick = BtnHelpClick
    end
    object BTNok: TButton
      Left = 441
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = BTNokClick
    end
    object BTNCancel: TButton
      Left = 522
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = BTNCancelClick
    end
    object BTNApply: TButton
      Left = 603
      Top = 4
      Width = 77
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 2
      OnClick = BTNApplyClick
    end
    object BtnHelp: TButton
      AlignWithMargins = True
      Left = 72
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Help'
      TabOrder = 3
      Visible = False
      OnClick = BtnHelpClick
    end
  end
  object OpenDlg_CountdownSongs: TOpenDialog
    Left = 88
    Top = 32
  end
  object OpenDlg_DefaultCover: TOpenPictureDialog
    Left = 88
    Top = 136
  end
  object OpenDlg_SoundFont: TOpenDialog
    Filter = 'Soundfonts (sf2/sf2pack)|*.sf2;*.sf2pack|All files|*.*'
    Left = 88
    Top = 88
  end
  object ActionList1: TActionList
    Left = 52
    Top = 232
    object ActionAddCategory: TAction
      Category = 'Categories'
      Caption = 'Add category'
      OnExecute = ActionAddCategoryExecute
    end
    object ActionDeleteCategory: TAction
      Category = 'Categories'
      Caption = 'Delete category'
      OnExecute = ActionDeleteCategoryExecute
    end
    object ActionAddRootLayer: TAction
      Category = 'Layers'
      Caption = 'Add root layer'
      OnExecute = ActionAddRootLayerExecute
    end
    object ActionAddLayer: TAction
      Category = 'Layers'
      Caption = 'Add layer'
      OnExecute = ActionAddLayerExecute
    end
    object ActionDeleteLayer: TAction
      Category = 'Layers'
      Caption = 'Delete layer'
      OnExecute = ActionDeleteLayerExecute
    end
    object ActionEditLayer: TAction
      Category = 'Layers'
      Caption = 'Edit layer'
      OnExecute = ActionEditLayerExecute
    end
    object ActionEditCategory: TAction
      Category = 'Categories'
      Caption = 'Edit category'
      OnExecute = ActionEditCategoryExecute
    end
    object ActionLayerMoveDown: TAction
      Category = 'Layers'
      Caption = 'Move down'
      OnExecute = ActionLayerMoveDownExecute
    end
    object ActionLayerMoveUp: TAction
      Category = 'Layers'
      Caption = 'Move up'
      OnExecute = ActionLayerMoveUpExecute
    end
    object ActionMoveCategoryUp: TAction
      Category = 'Categories'
      Caption = 'Move up'
      OnExecute = ActionMoveCategoryUpExecute
    end
    object ActionMoveCategoryDown: TAction
      Category = 'Categories'
      Caption = 'Move down'
      OnExecute = ActionMoveCategoryDownExecute
    end
  end
  object PopupCategories: TPopupMenu
    OnPopup = PopupCategoriesPopup
    Left = 52
    Top = 296
    object Editcategory1: TMenuItem
      Action = ActionEditCategory
    end
    object Addcategory1: TMenuItem
      Action = ActionAddCategory
    end
    object Deletecategory1: TMenuItem
      Action = ActionDeleteCategory
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Moveup2: TMenuItem
      Action = ActionMoveCategoryUp
    end
    object Movedown2: TMenuItem
      Action = ActionMoveCategoryDown
    end
  end
  object PopupLayers: TPopupMenu
    OnPopup = PopupLayersPopup
    Left = 132
    Top = 296
    object Editlayer1: TMenuItem
      Action = ActionEditLayer
      ShortCut = 113
    end
    object Addrootlayer1: TMenuItem
      Action = ActionAddRootLayer
    end
    object Addlayer1: TMenuItem
      Action = ActionAddLayer
    end
    object Deletelayer1: TMenuItem
      Action = ActionDeleteLayer
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Moveup1: TMenuItem
      Action = ActionLayerMoveUp
    end
    object Movedown1: TMenuItem
      Action = ActionLayerMoveDown
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Height = 32
    Width = 32
    Left = 43
    Top = 459
    Bitmap = {
      494C010111001800040020002000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000080000000A000000001002000000000000040
      0100000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000010201001C00000004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000100000006000000040000000604040424000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      0001000000082F2111811E100369000000090000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000040000001E020202410C0C0C543D3D3E96F0F0F0FFC9C9C9EA6C6C
      6CAB272727680505052800000000000000000000000000000000000000010000
      00090000001330221183381F078C241404710000000C00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00070101012C0303034F0A0A0B6EE8E8E8FDF0F0F0FFF0F0F0FFF0F0F0FFF0F0
      F0FFF0F0F0FFF0F0F0FFC0C0C0E4626262A32323236303030320000000060000
      001300000015312212833920088C3920088C2917067800000011000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000A0101
      01330303034D030304510D0D0D73F1F1F1FFF0F0F1FFEDEDEFFFECECEEFFEEEE
      EFFFEFEFF0FFEDEDEFFFEBEBEDFFECECEEFFEFEFF0FFEFEFEFFFAFAFAFE15858
      58A4212121693E2E1C9139210A8C39220A8C39210A8C2E1B077D010100180000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000B0101
      0133020203480303034A0C0C0D6EEEEEF0FFE7E6EBFFDEDEE5FFDEDEE5FFE6E5
      EAFFEAEAEDFFE4E4E9FFDCDCE4FFDFDFE6FFE7E7EBFFEEEEEFFFE4E4E4FFDFDF
      DFFFDFDFDFFFD6BA9BFFB99066ED8A6643CF634526B243291095321E09820201
      001E000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000500000005000000170505
      06611112138E131314911C1D1FA6A4A5A8FFB1B1BCFF9796ACFF9494ADFFD2D2
      DDFFC2C2C9FF8D8E93FF686872FFA5A5B3FFDCDCE4FFEAEAEDFFE4E4E4FFDEDE
      DFFFDBDBDDFFD2B89BFFD6AD82FFD8AE82FFD9AF83FFD6AB80FEB38D63E9372A
      1C83000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000011B000001260101033B0909
      0E8636373BD5A5A9A9FC9C9F9FFB717176FF6B6B83FF262671FF666691FFAEAE
      BEFF747578FFBABEBEFF48485FFF777793FFCECEDAFFE6E6EAFFE1E1E3FFD8D8
      DBFFD0D0D6FFCEB59AFFD3AA84FFD9AF84FFDBB185FFDAB084FFDCB184FF5644
      33A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000303208E01010754010107590202
      138C07072EB65D5E60F83B3C42E8666673FF69699CFF2E2D73FF383880FF6565
      6DFFBBBEBFFFC5C9C9FF414260FF58587AFFBCBCCDFFD7D7E1FFD6D6DCFFCBCB
      D3FFB9B8C6FFD4B99DFFDCB387FFDBB287FFDDB487FFDAB185FFDDB487FF5646
      33A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000001CCD0202148904041FA90101
      17BD020230E34F5158FA2B2C33D3545471FF7B7BA4FF59597EFF2C2D5CFFB3B6
      B6FFCBCECEFFC9CCCDFF4C4C5CFF5D5D7EFF8F8EB1FFB3B3C4FFBABAC9FFB0B0
      C1FF74738DFFD6BC9FFFE0B78AFFDEB688FFDFB689FFD9B189FFE0B789FF5847
      35A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000EBD030319AB0B0B45CB0000
      26B1040422D54E5060F62B2B32CC707099FF7B7BB3FF52526FFF9EA0A4FFD1D4
      D4FFC1C3C4FF77787EFF404049FF5A5A7CFF5C5C98FF535365FF6B6B96FF8F8E
      A5FF6D6D9BFFDCC1A0FFE2BB8DFFE1B98CFFE1B98CFFDBB48AFFE2BA8CFF5847
      36A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000101189C0B0B6CDA30309CD61818
      56B60909389D60617BF82A2A34C48787E1FF8887B4FF83858AFFD6D9D9FFD3D6
      D6FF67697EFF666787FF505067FF5857B0FF5E5EE4FF4949A8FF5B5BA6FF706F
      A1FFA2A2D1FFE0C8ABFFE6C49CFFE4BD90FFE4BD8FFFDCB68EFFE3BC8EFF5949
      37A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000010011760B0B5EC50B0B57B20E0E
      58B607071A706C6D81FA26262CB68686BFF6707187FFDBDEDEFFDDDFDFFF8081
      89FF7877B2FF5C5D87FF5D5E6FFF4848B7FF4949CCFF6363B7FF5453A7FF706F
      ADFFA69ECDFFEACFADFFEBCFADFFEACCA9FFE6C194FFE0BA90FFE5BF90FF594A
      38A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000003320E0E41950505389C0404
      207202020E53545561E3202024A722222CB3D5D7D8FFE3E6E6FFA2A3A9FF4F4F
      84FF7A79DCFF60617CFF71727DFF8A88D4FF8382C6FF4F4F87FF5F5FBEFF6D6D
      D8FFB8A6ADFFEDD2B0FFEDD1B1FFEED3B2FFEBCEACFFE4BE94FFE8C293FF5B4B
      39A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000150606114C000007420000
      09550000011F494B4DD03A3A3AD4BFC1C1F8E9ECECFFCACCCDFF63638BFF3C3C
      AEFFA7A6D4FF8B8C94FF828287FFAFAFDFFFC8C7DEFFA8A7BFFF7575B5FF5E5E
      A9FFE1CBB2FFEFD4B4FFEED4B5FFEFD6B6FFECD3B5FFEACCA7FFE9C496FF5B4C
      3AA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000050000000B0000000E0000
      000C000000115D5D5ED8DBDDDDFCEFF1F1FFDBDCDCFD87878CFFB5B5DFFF7675
      D8FFB6B6D3FF929295FF89898AFFEFEFF4FFEAEAF0FFD4D4DEFF8F8FACFFBDBD
      CEFFEAD4B8FFF1D8B9FFF0D7B8FFF1D9BAFFEFD7BAFFEFD8BAFFECC99CFF5C4D
      3BA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000100000001000000020000
      00301C1C1C9CCCCDCDF8F6F7F7FFEBEDEDFD5E6060E0EBEBEDFFEAEAF2FFBDBD
      CBFF88888EFFC3C4C5FFBCBDBDFF939393FFD0D0D1FFE5E5E8FFE0E0E4FFE0E0
      E4FFECD6BCFFF5DEBFFFF2DCBDFFF2DBBEFFF2DCBFFFF2DCBFFFF0D4AFFF5C4E
      3CA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001717
      17766B6B6BCF6D6D6DD06C6D6DD0424242B84242429EFCFCFCFFF9F9FBFFA3A3
      A5FFB0B0B0FFB4B4B4FFB4B4B4FFADAFAFFFAFAFAFFFEDEDEDFFEAEAEBFFEAEA
      EBFFEFD9BEFFF8E2C4FFF7E1C3FFF4DEC2FFF4DFC2FFF4DFC3FFF3DDC1FF5D50
      3DA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000045454590FDFDFDFFFDFDFDFFFCFC
      FCFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFAFAFAFFEDEDEDFFEBEBEBFFEBEB
      EBFFEFDABFFFF9E4C7FFFAE5C9FFF7E2C7FFF5E1C6FFF5E1C7FFF5E1C7FF5F54
      44A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000046464690FDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFDFDFDFFFDFDFDFFFAFAFAFFEDEDEDFFECECECFFEBEB
      EBFFF0DCC1FFFBE7CBFFFBE8CCFFFAE8CDFFF6E4CAFFF6E4CAFFF6E4CBFF5F57
      4BA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000046464690FDFDFDFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFEFEFEFFFEFEFEFFFBFBFBFFEEEEEEFFECECECFFECEC
      ECFFF1DEC3FFFCEACEFFFCEACFFFFDEBD1FFFAE8CFFFF8E6CDFFF7E6CEFF6059
      4DA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000046464690FDFDFDFFFDFDFDFFFDFD
      FDFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFBFBFBFFEEEEEEFFECECECFFECEC
      ECFFF2DEC5FFFDECD2FFFDECD3FFFDEDD4FFFDEDD4FFF9E8D1FFF8E9D1FF6159
      4EA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000046464690FDFDFDFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFBFBFBFFEEEEEEFFECECECFFECEC
      ECFFF3E0C7FFFFEED5FFFFEED6FFFFEFD7FFFFEFD8FFFBECD5FFF9EBD4FF615A
      4FA0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000048484890FEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFBFBFBFFEEEEEEFFECECECFFECEC
      ECFFF4E1C9FFFFF0D9FFFFF0DAFFFFF1DBFFFFF1DCFFFDEFDAFFFAEDD8FF625B
      51A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049494990FEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFCFCFCFFF2F2F2FFECECECFFECEC
      ECFFF4E2CBFFFFF1DDFFFFF2DEFFFFF3DFFFFFF3E0FFFEF2DFFFFAEFDCFF625C
      53A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049494990FEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFBFBFBFFF4F4F4FFEEEE
      EEFFF4E2CCFFFFF3E1FFFFF4E2FFFFF5E3FFFFF5E3FFFFF5E4FFFAF0E0FF625C
      54A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049494990FEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFF9F9
      FAFFF4E4CEFFFFF6E5FFFFF6E6FFFFF6E6FFFFF7E7FFFFF6E7FFFBF2E4FF625D
      56A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000049494990FEFEFEFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF3E5D5FFFDF5E8FFFFF8E9FFFFF8EAFFFFF8EAFFFFF8EBFFFBF4E7FF625E
      57A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A1A1A5AE5E5E5F8FCFCFCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF9F2EBFFF6ECE0FFFDF5EAFFFFF9EDFFFFF9EDFFFBF5E9FF625F
      58A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000030202021D0B0B
      0B3C1D1D1D5C3737377C5858589B828282BBB3B3B3DBE8E8E8F9FCFCFCFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F3ECFFF6EDE0FFFCF6EBFFFAF6ECFF625F
      59A0000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000020202021C0B0B
      0B3C1D1D1D5C3636367C5858589B828282BBB7B7B7DDE5E0DBFAF1E8DDFF514F
      4A92000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000030202021E0101
      0114000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000010000000E000000285A5146DB0000
      0016000000010000000000000000000000000000000000000000000000000000
      00020000000A00000021525E61E6000000160000000200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000010000
      0006000000110000001E000000280100002E0100002E00000029000000200000
      0013000000080000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000001000000010000
      0001000000010000000200000002000000020000000200000001000000010000
      0001000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000004000A0E5400293AA1366978EE000B
      0F57000000040000000000000000000000000000000000000000000000000000
      0006000000280100004947656FE90000002B0000000600000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000020000000F0000012E0301
      1374060235B0070156D8080070F009007EFC080080FD080071F3070159DC0602
      38B60301167E0100013500000012000000030000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000100000003000000050000000B0000000F0101011301010115010101170202
      02190202021A0202021A0202021B0202021B0202021A0202021A020202190101
      01170101011501010113000000100000000D0000000700000003000000020000
      0001000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000001000000010000000100000001000000010000
      0001000000010000000100000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000001000000080000001B00131C780075A6F5616156F50014
      1D790000001B0000000800000001000000000000000000000000000000040000
      0013440000A5B40000FC9B1F22FD450000A50000001300000004000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000A0100023605012CA0090074F00A00
      87FF0A0087FF0A0086FF090086FF090086FF090085FF090085FF090084FF0900
      84FF090083FF090076F6060233AD010104410000000E00000001000000000000
      0000000000000000000000000000000000000000000000000002000000050000
      000A010101120202021A080808310C0C0C3B0E0E0E3F0F0F0F42101010441010
      1045111111461010104611111146111111461010104610101046101010451010
      10450F0F0F430E0E0E400C0C0C3B0909093603030320010101130000000C0000
      0005000000020000000000000000000000000000000000000000000000020000
      0006000000070000000A0000000C0000000F0000000E0000000F000000100000
      00110000001300000015000000190000001A0000001900000015000000150000
      0017000000190000001900000016000000110000000D0000000A000000080000
      0007000000030000000100000000000000000000000000000000000000000000
      0000000000010000000E0001023800101776015F89E30381B7FE0283B8FE0060
      8BE300101776000102380000000E00000001000000010000000A0000001F0800
      0050500000B9AB0000FA7A393FFA520000B9080000500000001F0000000A0000
      0001000000000000000000000000000000000000000000000000000000000000
      00000000000000000001000000160401187B0A0078EF0B008CFF0B008CFF0B00
      8BFF0B008BFF0B008AFF0A008AFF0A0089FF0A0089FF0A0088FF0A0087FF0A00
      87FF0A0087FF0A0086FF0A0086FF090079F60501208F0000001C000000020000
      00000000000000000000000000000000000000000001000000050000000D0101
      011A0404042908080839101010521E1E1E692121216E2020206E2021216F2020
      206F2020206E2020206E2020206D2121216E2020206E1F1F1F6E2020206F2020
      206F1F1F206E1F1F1F6D1F1F1F6A1615155C0909093C0505052B0202021B0000
      000E000000060000000100000000000000000000000800000015010101250202
      02320303033A050505550606065F0505054E0202023202020232020202320202
      0232020203350303043C0303054404040647030305420303033A030303380303
      043E04040647040406460303043E020203360505054E07070760050505530303
      03390202022E0101012100000012000000050000000000000000000000000000
      00000000000C0005084C004262C40686C7FF058AD0FF0B90D1FF0A91D1FF038A
      CEFF0383C6FF004261C40006094D0000000D0000000B000000272D0000938205
      00DBBD1509F8CD1E11FECE1C10FEBD1508F8820500DB2D000093000000280000
      000B000000010000000000000000000000000000000000000000000000000000
      0000000000010000001F07023BAE0C0092FF0C0091FF0B0090FF0B0090FF0B00
      8FFF0B008FFF0B008EFF0B008DFF0B008DFF0B008CFF0B008CFF0B008BFF0B00
      8BFF0A008AFF0A008AFF0A0089FF0A0089FF0A0088FF070146C30000012B0000
      00030000000000000000000000000000000000000002000000060000000F0000
      002002020233030303412221219DA7A6A6F0939191F08A8989F0888788F08787
      87F0878687F0878787F0848383F0828183F0838383F0838283F0818080F0807F
      80F07F7E7FF07C7B7BEF9B9B9BF1696968D60606065102020232010101200000
      0010000000060000000200000001000000000000000A0000001B0202022C0505
      064F767676EF626262FB2F2F2FFF333333FE0808096404040544040404420404
      054304040648050509550808106F0D0D1AAA08080F68050507500404064B0606
      09560C0C14AF0A0A138B050508550A0A0C6F333333FF2E2E2EFF666666FB7272
      72ED040404440101012800000016000000070000000000000000000000000000
      000500020235004768C8128DCEFD018DCDFF008FC9FF008EC5FF1697D2FF30A8
      DCFF4EC1EBFF1995D2FD004768C90002033B000000284E0000B8BD0C02FCD518
      0AFFCE0700FFC90100FFC90000FFCB0400FFD31304FFBD0A00FC4E0000B80000
      0025000000070000000000000000000000000000000000000000000000000000
      00010000001D08004ABE0C0097FF0C0096FF0C0095FF0C0095FF0C0094FF0C00
      93FF0C0093FF0C0092FF0C0092FF0C0091FF0C0091FF0C0090FF0B008FFF0B00
      8FFF0B008EFF0B008EFF0B008DFF0B008CFF0B008CFF0A008BFF090059D30000
      012A000000020000000000000000000000000000000000000003000000080000
      0013000000200000002F494848D9DBDBDBFFDADADAFFCECDCDFFD1D1D1FFD1D0
      D1FFCECFCFFFBDBCBCFFE7E6E6FFEDECECFFC8C7C6FFBBBABCFFC8C9CAFFC3C2
      C3FFC3C4C4FFC1C0C1FFD9D8D8FFB2B1B1FF0303035E00000019000000120000
      00080000000300000001000000000000000000000000000000250808086A2020
      2286CDCDCDFF505050FF2F2F2FFF363636FF0A0A0E7703030644030305400302
      053F0303064705050C63131349C6100F32D9090915730303084C030306470404
      0A5A0E0E2ACB0F0F2CB3030308500B0B0E79363636FF2F2F2FFF585858FFCECE
      CEFF19191978070707690000001F000000000000000000000000000000020000
      00160024349A0788CBFF0191CFFF149CCFFF56B8E2FFD0EBF7FFC5EEFBFFA0E9
      FBFF7DE2FAFF58D7F7FF0F91D0FF002739A7340000A4BE0C01FCD51C11FFCB02
      00FFCC0F0FFFCE2729FFDB413BFFE4514FFFED5B60FFE9413FFFBF0F03FC3500
      009B0000001F0000000300000000000000000000000000000000000000000000
      001007023DAC0D009CFF0D009BFF0D009BFF0D009AFF0D0099FF0D0099FF0D00
      98FF0D0097FF0D0097FF0C0096FF0C0095FF0C0095FF0C0094FF0C0094FF0C00
      93FF0C0093FF0C0092FF0C0091FF0C0091FF0C0090FF0C0090FF0C008FFF0801
      4EC6000000180000000000000000000000000000000000000000000000020000
      0004000000090000000C504F50D3C4C4C5FFAFADADFF949494FFADAAAAFF5C5A
      5AFF8E8D8DFF868383FFD7D6D8FFEAEBEBFF9F9E9CFF7E7D7DFF9D9C9EFFA3A2
      A1FF8B8A89FF777676FFC6C5C7FF838284FF0202024500000001000000040000
      00020000000000000000000000000000000000000000272727C23D3D3DFF7878
      79E7E0E0E0FF2F2F2FFF2F2F2FFF313131FF0D0D2DA802020F6D02020B540101
      0644010108530A0A27900A0A6BE00C0C43DC0B0B258C010106420101074E0201
      0B67070731BA090945D30101074606060A68313131FF2F2F2FFF383838FFE1E1
      E1FF727272E63C3C3CFF222222B4000000000000000000000000000000080009
      0D58007DB9FC0895D8FF37B7E1FF8FDFF6FFC5EFFBFFD9F1F9FFBDEBFAFF9DE7
      FAFF7DE1FAFF60E1FCFF30BBEEFF0380BAFD692025F0CF1308FFCF0908FFDD3F
      40FFEC8988FFF8D7D7FFFAC3C6FFFAA2AAFFF9838EFFFB6776FFE7302DFF9B08
      00E8130000650000000D00000000000000000000000000000000000000050401
      19740F00A1FF0F00A1FF0F00A0FF0E009FFF0E009FFF0E009EFF0E009DFF0D00
      9DFF0D009CFF0D009CFF0D009BFF0D009AFF0D009AFF0D0099FF0D0098FF0D00
      98FF0D0097FF0D0096FF0D0095FF0C0095FF0C0094FF0C0094FF0C0093FF0C00
      93FF050128920000000900000000000000000000000000000000000000000000
      000000000000000000004A4A4ACED0D0D0FFB7B8B7FF858585FFB8B7B7FF7374
      73FFACACACFF616060FF636060FF747271FF414040FF919393FF999898FFA8A9
      A8FF8F8C8FFF7C7B7DFFD1D0D1FF8A898AFF0000000000000000000000000000
      000000000000000000000000000000000000000000006F6F6FFF333333FF9D9D
      9EFEC9C9C9FF292929FF313131FF353535FF0D0D47DF030321C4060631AF0202
      1083010110BB07062198070729A8060653DE0E0C2B960101084D01010E7D0505
      2EDC030324C0060633C001010A5907070E79353535FF313131FF282828FFD1D1
      D1FF979797FE333333FF656565EF00000000000000000000000000000013004C
      6CCD1097DBFF44CBF1FF7DE4FAFFA0E7F9FFC5EEFAFFE1F4FBFFB4EBF9FF5FCA
      ECFF26B0E1FF13A8DEFF0A9FDAFF0E94DBFF2B5E83FFC60A09FFEC5F67FFF9A1
      A7FFFBC7CAFFF9D9D9FFFABEC1FFFAA1A8FFFA8590FFFC6979FFFA4A5CFFD81C
      15FE590200BB0200002D00000001000000000000000000000000000001280E01
      8EEE1000A6FF0F00A5FF0F00A5FF0F00A4FF0F00A3FF0F00A3FF0F00A2FF0F00
      A1FF0F00A1FF0F00A0FF0F009FFF0E009FFF0E009EFF0E009DFF0E009DFF0D00
      9CFF0D009BFF0D009BFF0D009AFF0D009AFF0D0099FF0D0098FF0D0098FF0D00
      97FF0D008EF90100053E00000001000000000000000000000000000000000000
      00000000000000000000535252CEE2E2E1FFF6F6F6FFE4E4E4FFF1F1F1FFEBEB
      EBFFF6F6F6FFD0D0D0FF9B9B9BFF9A9A9AFFA5A5A5FFEAEAEAFFD9D9D9FFDDDD
      DDFFD6D6D6FFD1D1D1FFE1E1E1FF989797FF0000000000000000000000000000
      00000000000000000000000000000000000000000000707070FF4A4A4AFFA0A0
      A0FFB4B4B4FF2E2E2EFF363636FF3D3D3DFF0F0F2FF3070645DC0302239B0101
      0C62040421B00404218A04031E9B070741B70A0A299301010954030212741919
      5EEF020221BC060634C60404157A11112FB83D3D3DFF363636FF2E2E2EFFBABA
      BAFF999999FF4A4A4AFF656565EF00000000000000000000000200050743006A
      9EE831BBF0FF5EE2FCFF80E4FAFFA0EAFCFF99E1F5FF3BB8E4FF00A5D7FF00A0
      D5FF009ED4FF0098D1FF0095CFFF1099DCFF1278B1FFB85E72FFF88691FFF9A7
      AEFFFAC9CBFFFBE3E4FFFAB8BEFFED6166FFE22D30FFDD1113FFDB090BFFD70E
      07FFB71008F60E00005900000007000000000000000000000005070134961101
      ACFF1101ABFF1101AAFF1100AAFF1100A9FF1100A8FF1000A8FF1000A7FF1000
      A6FF1000A6FF1000A5FF1000A4FF0F00A4FF0F00A3FF0F00A2FF0F00A1FF0F00
      A1FF0F00A0FF0E00A0FF0E009FFF0E009EFF0E009EFF0E009DFF0E009CFF0E00
      9CFF0D009BFF070045B500000009000000000000000000000000000000000000
      000000000000000000005A5958CEE0DFDFFFF5F5F5FFF0F0F0FFF0F0F0FFF0F0
      F0FFEEEEEEFFF5F5F5FFF8F8F8FFF7F7F7FFF6F6F6FFE8E8E8FFE4E4E4FFDFDF
      DFFFDDDDDDFFD2D2D2FFDFDFDFFF959493FF0000000400000005000000060000
      00000000000000000000000000000000000000000000686868FF828282FF9D9D
      9DFFA5A5A5FF3B3B3BFF3F3F3FFF464646FF0E0E27DE11115BCB050518830101
      0C5B050527920B0B2F9103031D8F161646AB0B0B349A02010C5B040320871515
      51C3050533CE05052BBB070721991F1F44D2464646FF3F3F3FFF393939FFAFAF
      AFFF969696FF878787FF5D5D5DEF00000000000000000000000300151D720480
      C3F73AD2F9FF60E3FDFF77E2FAFF45C7EDFF0AB0E0FF00A8DDFF00AADFFF00A5
      DBFF00A4D9FF009DD5FF0098D1FF0094D3FF0D8AD0FF896A87FFF78792FFFCA6
      AEFFF59BA2FFE43A3EFFD6000BFFD50006FFD40004FFD10002FFD00000FFD207
      05FFD2140AFF3801009900000012000000000000000000000019110198EF1301
      B0FF1201B0FF1201AFFF1201AEFF4134B9FF928BCCFFB9B6D6FFC0BDD7FFAFAB
      D3FF827AC7FF3325B3FF1100A9FF1100A9FF1100A8FF2B1DAEFF776FC2FFA6A1
      CEFFBCB9D4FFBEBCD5FFB3B0D1FF908AC7FF4A3FB3FF0F00A2FF0F00A1FF0E00
      A0FF0E00A0FF0E0099FB0000032F000000000000000000000000000000000000
      00000000000000000001595858CFE0E0E0FFEDEDEDFFE3E3E3FFEBEBEBFFEDED
      EDFFECECECFFEBEBEBFFECECECFFEBEBEBFFE9E9E9FFE7E7E7FFE5E5E5FFE3E3
      E3FFDDDDDDFFD8D8D8FFE0E0E0FF969595FF0000000000000000000000000000
      00000000000000000000000000000000000000000000636363FF8C8C8CFF9696
      96FF9F9F9FFF474747FF484848FF4D4D4DFF101033AE4242A4D60A0A20710201
      0A4C222264AC1D1C388A05042891343474BC0B0B42A3030214690F0F3B902929
      7DC1171762CB0C0A56B71F1F61B73F3F8CE44D4D4DFF494949FF464646FFA6A6
      A6FF909090FF919191FF585858EF00000000000000000000000300202C871C9D
      DFFE41E0FDFF51DBF9FF1ABAE6FF00AFE3FF02B4E5FF00B3E5FF00B0E2FF1EB7
      E5FF56CCEEFF66D6F4FF58DAF7FF3DD6F7FF1DA0E1FF736F90FFF67885FFEC48
      51FFDF0915FFDC0008FFDE0009FFDB0006FFD90006FFD50003FFD20001FFD100
      00FFD70D02FF820500D90000001A0000000000000001030115601401B6FF1401
      B5FF1401B5FF1401B4FF7970CAFFE1E1E1FFE1E1E1FFE1E1E1FFE1E1E1FFE1E1
      E1FFE1E1E1FFDEDEE0FF3F32B9FF1201ADFF695FC3FFDBDBDFFFE0E0E0FFE0E0
      E0FFE0E0E0FFE0E0E0FFE0E0E0FFE0E0E0FFDFDFDFFF8982C8FF1100A6FF1000
      A5FF1000A5FF1000A4FF05012482000000020000000500000006000000070000
      000600000006000000085C5A5AD1DFE3E4FFB4B4B4FF4D4640FF423C41FF5D54
      49FF61634FFF666D55FF676E57FF636B59FF3D423AFF545A55FF5E6658FF6C75
      5FFF7C7152FF828C6AFFD8E0E0FF979696FF0000000000000000000000000000
      00000000000000000000000000000000000000000000737373FF9A9A9AFF9393
      93FFADADADFF505050FF4F4F4FFF555555FF0D0D208F484888C5040418620101
      073C29294B951717358605052F9F4E4EA6DB0A0A56B6030317711A1A3F963E3E
      A3E11F1E54B31C1B65C121216CC532327EE1555555FF505050FF4E4E4EFFB3B3
      B3FF8F8F8FFFA0A0A0FF666666EF00000000000000000000000300212E8922A4
      E4FF3BDCFBFF17BDE9FF03B7E6FF05BAE9FF0CBDEAFF2EC8EDFFA9E8F7FFC9F3
      FDFFA2ECFCFF81E7FBFF61E0FCFF43E1FEFF20A4E4FF6F6687FFE5222FFFE300
      0DFFE4010FFFE3000CFFE2000CFFE20D18FFE7363FFFEA454EFFEC424DFFEB32
      40FFEA2829FFB20A07F70000001D0000000000000003090244A21502BBFF1502
      BAFF1502B9FF493BC4FFE4E4E4FFE4E4E4FFC9C6DEFF5345C4FF2E1EBBFF4B3E
      C2FFA19BD5FFD7D6E1FF1B09B5FF5043C1FFE2E2E3FFE3E3E3FFCBC9DDFF6258
      C4FF2E20B6FF2415B3FF382AB8FF9891D0FFE2E2E2FFE2E2E2FF3123B4FF1100
      AAFF1100AAFF1100A9FF0A015BC20000000600000011000000130000000B0000
      000F00000011000000145E5C5DD4E0E6E7FFB5B5B5FF1F2053FF1F1D42FF534C
      4AFF5B5C4FFF616855FF616857FF5A6156FF272A2DFF4A4F62FF434844FF666E
      5EFF6F785FFF818A6AFFD9E0E1FF989897FF0000000000000000000000000000
      00000000000000000000000000000000000000000000868686FFADADADFF908F
      90F8CCCCCCFF535353FF575757FF5B5B5BFF0B0A177A2F2F57A1010107380000
      032A2020438C0A0A25710403289D393986CB0B0B54BD04031A77171756A70F0D
      48AF0B0B35991E1E56B31C1C95DC23235ACB5B5B5BFF585858FF535353FFD0D0
      D0FF8E8E8EF9B4B4B4FF767676EF00000000000000000000000300212E8924A8
      E7FF11BDEAFF04B5E6FF04BDEAFF26C9EFFF75E2F8FFC8F4FDFFDDF8FEFFBEF0
      FBFF9FEBFCFF81E5FBFF62E1FBFF43DFFCFF22A7E6FF674564FFE20212FFE805
      15FFE70113FFE90D1FFFF27C86FFF8AEB4FFFA9CA4FFFB8793FFFD6E7EFFFD51
      64FFF63941FFC00C09FF0000001E0000000000000007100279D01603BFFF1603
      BEFF1603BEFFA39DDAFFE7E7E7FFE3E3E6FF3626C2FF1502BBFF1502BAFF1502
      BAFF1502B9FF3B2BC1FF1603B8FFC6C3DFFFE6E6E6FFD3D2E2FF2B1ABAFF1401
      B4FF1401B4FF1401B3FF1301B2FF3C2DBCFFE5E5E5FFE5E5E5FF4E42BFFF1201
      AFFF1201AEFF1200AEFF100194EE0000000C0000001700000012000000010000
      00030000000A0000011E605F61D8E1E7E8FFB8B8B8FF050665FF32345BFF4D52
      57FF5D635DFF676E64FF666C64FF5D6361FF313441FF27287CFF43474AFF6D74
      69FF78826DFF858F74FFDBE0E2FF999998FF0000000000000000000000000000
      000000000000000000000000000000000000000000001E1E1E90BABABAFB6060
      60CFDEDEDEFF626262FF5C5C5CFF5F5F5FFF08080E63040415580000011B0000
      011704030A3B0000053202021A7F11114EA708073EA416144EB71E1E4F9E0303
      239F02010B4D0808185F0C0C237011111F8F5F5F5FFF5D5D5DFF676767FFDFDF
      DFFF595959CBC3C3C3FC1A1A1A8600000000000000000000000300202D8829AE
      EBFF02B5E4FF07BBE9FF37D3F4FF81E8FDFFA8EFFDFFC6F4FCFFDBF8FEFFC4F4
      FEFFA1ECFCFF55D2F3FF23BAE7FF11B2E3FF28ADEAFF684160FFE70418FFEB09
      1DFFF35362FFFDCED3FFFEE2E6FFFCC3C8FFFCA4AEFFFA8793FFFB6C7CFFFA4E
      61FFF6373EFFC10C09FF0000001E000000000000000A1503A7EE1803C4FF1803
      C3FF1803C2FFD6D4E6FFEAEAEAFFB1ACDFFF1603C0FF1603BFFF1603BFFF1603
      BEFF1603BDFF1603BDFF493BC7FFE9E9E9FFE9E9E9FF7166CFFF1502BAFF1502
      B9FF1502B9FF1704B8FF3F30C1FFB0ABDBFFE8E8E8FFE8E8E8FF3929BEFF1401
      B4FF1301B3FF1301B3FF1301B2FF0000011B000000080000000E000000000000
      00000000000100000017646265DEE2E7E8FFB7B7B7FF0D0E68FF202163FF4C4F
      72FF575C59FF616661FF4B4F4EFF4B5052FF2B2E48FF0F0F7CFF3D4149FF686F
      69FF757E6EFF838C75FFDAE1E3FF9A9A9AFF0000000000000000000000000000
      00000000000000000000000000000000000000000000000000009D9D9DD61010
      115EE8E8E8FF818181FF606060FF636363FF06060951000000120000000B0000
      000A0000000D000001170000063E0A0A21700F0E58A90E0E4CAB010109470000
      053B0000022602020D49020107350C0B116C636363FF616161FF868686FFE7E7
      E7FF0A0A0A4FB4B4B4E300000000000000000000000000000002001B267B1195
      D7FB11B8EBFF2BCFF3FF67E6FEFF87EBFDFFA8F0FEFFC7F6FEFFC3F0FBFF5AD3
      F1FF07B7E5FF00ADDFFF00A5DAFF08A5E1FF1595D8FF7D3958FFEF1F34FFF96E
      7EFFFEAEB9FFFDC7CDFFFEDADFFFFCC3C9FFFCA7B0FFFA808BFFF65B69FFF53F
      4FFFF43339FFC20D0BFF0000001D000000000000000B1905C3FC1904C8FF1904
      C7FF1904C7FFECECEDFFEDEDEDFF948BDCFF1903C5FF1803C4FF1803C3FF1803
      C3FF1703C2FF1703C1FF9188D9FFECECECFFE8E8EBFF2816C3FF1806BFFF6458
      CEFFADA7DEFFDDDCE8FFECECECFFEBEBEBFFEBEBEBFFA9A3DCFF1502BAFF1502
      B9FF1502B8FF1502B7FF1501B7FF0000032A0000000500000001000000010000
      0000000000000000001A6D6C6DF2E3E8EAFFB7B7B7FF1D1F60FF15166AFF5557
      79FF626668FF565C59FF2D303CFF121321FF1E1F2EFF212374FF3A3E45FF6269
      67FF6F786DFF798372FFDCE1E3FF9A9A9AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000939393CB2626
      27863C3C3C9C656565E7585858F5505051E50101022A00000006000000030000
      0003000000040000000900000014000002261313539F06062F880000042E0000
      0119000000100000000D0000000F0303043B545455EA585859F7656565E33737
      37962A2A2A88919191C9000000000000000000000000000000000006083E006B
      A1E82BBFF8FF45E0FDFF67E4FDFF89EBFEFF8FECFDFF59DCF6FF19C8EFFF04BC
      E9FF04B4E5FF01ACE1FF00A6DCFF24B6F2FF1275B0FFB73852FFFC6477FFFE90
      9DFFFDAAB3FFFDCAD1FFFEE0E2FFF9A2AAFFF25F6CFFEA303DFFE2101BFFDC05
      0AFFE81A17FFB10B09F500000017000000000000000A1A05C7FC1A05CCFF1A05
      CBFF1A05CBFFECECEFFFF0F0F0FF978EDFFF1A04C9FF1904C8FF1904C7FF1904
      C7FF1903C6FF1B05C6FFD7D5EBFFEFEFEFFFB7B1E4FF1903C4FFA7A0E0FFEFEF
      EFFFEFEFEFFFEEEEEEFFEEEEEEFFCFCCE8FF7C72D5FF1C09C0FF1603BEFF1603
      BDFF1602BDFF1602BCFF1602BBFF000003280000000900000001000000010000
      000000000000000000096C6B6EEEE4E9EAFFB7B7B7FF2C2D65FF181977FF5558
      79FF6E7278FF555B5BFF343854FF0C0C3DFF2A2C3CFF191B5AFF3C3F4CFF4F55
      62FF565D68FF6D756EFFDAE2E4FF9B9B9AFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101138181
      81D41515166F0000000F0000000B000000030000000200000001000000000000
      0000000000000000000200000007000000110000042900000532000000150000
      000A000000040000000300000003000000060000000B0000000E0000000D1A1A
      1A7B747575CB0000000F0000000000000000000000000000000000000007003F
      5BB90F9DE1FF48DAFEFF6BE8FEFF69E1FAFF1DCEF2FF0AC9F0FF09C0ECFF08BA
      E9FF04B1E4FF00ABE0FF12AFE8FF0D9CE2FF41628DFFF54E62FFFD6F80FFFD8E
      9CFFFEB2BBFFFCB2BAFFF56070FFED2032FFE60717FFE2010FFFDE0007FFDE06
      0CFFE0160FFF7B0401D10000000E00000000000000071905B1ED1C05D0FF1C05
      D0FF1C05CFFFD4D1EDFFF3F3F3FFB9B4E8FF1B05CDFF1B05CCFF1A05CCFF1A05
      CBFF1A05CAFF4E3ED3FFF2F2F2FFF2F2F2FF7164D9FF4230CFFFF2F2F2FFF2F2
      F2FFBAB4E6FF5A4BD3FF2F1BC9FF1903C4FF1803C4FF1803C3FF1803C3FF1703
      C2FF1703C1FF1703C1FF1703C0FF000000160000000D00000001000000000000
      000000000000000000096B6A6FE9E5EAEBFFB6B6B6FF2D2F66FF24267BFF575A
      7BFF6D7178FF696E73FF35395EFF1F205CFF1E203EFF0D0E37FF3E4351FF494E
      65FF3E435CFF4A5052FFDBE2E4FF9C9C9CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004A4A
      4A93636464C40000000500000001000000010000000000000000000000000000
      000000000000000000000000000100000005000000090000000A000000070000
      0003000000010000000100000001000000010000000300000001000000087172
      72D03B3B3B850000000000000000000000000000000000000000000000000000
      000C00638DE125AFE8FF58DCFCFF09BEEBFF08BDEAFF08BFEBFF07BAE8FF06B4
      E5FF06B2E4FF11B1E9FF15A6E9FF1974A3FFF23B4CFFFD5368FFFD7182FFFE91
      A0FFF96174FFF10E27FFED061BFFE9081BFFE60614FFE2020DFFDD0007FFE510
      12FFDB201BFF23000076000000030000000000000003140485CD1D06D4FF1D06
      D3FF1D05D3FF9F96E7FFF4F4F4FFF0EFF4FF3B27D5FF1C05D0FF1C05D0FF1C05
      CFFF1C06CFFFB8B2E9FFF4F4F4FFEBEAF3FF2B17CFFF5D4ED8FFF4F4F4FFF4F4
      F4FF3A27D0FF1A04CAFF1A04C9FF3623CEFF6D5FD8FF5241D2FF230DC9FF1903
      C6FF1903C6FF1903C5FF1503A6EC000000060000001000000001000000000000
      000000000000000000056C6A74E7E7ECEDFFB6B6B6FF454971FF4141A8FF5456
      8DFF666976FF6C707DFF373A81FF2F3183FF22255BFF0F1035FF3A3D51FF3F42
      76FF30336BFF2B2F3EFFDCE3E4FF9E9D9DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004242
      42977C7C7EDB0000000B00000000000000000000000000000000000000000000
      0000000000000000000000000000000000010000000200000002000000010000
      00000000000000000000000000000000000000000000000000000000000D8787
      87E3393A3A8D0000000000000000000000000000000000000000000000000000
      000000030534055698E41599D8FF12ACECFF21BCF3FF24BDF3FF22BBF1FF1FB8
      F1FF11A8EAFF1799D8FF0D5FC1FF8C143AFFED2624FFFE576AFFFD6A7CFFF43D
      50FFEF0A22FFEF0A22FFEC091DFFE80819FFE40412FFE1000BFFE20A0FFFEC20
      1BFF890400D7050000310000000000000000000000010C034A9A1F06D7FF1E06
      D7FF1E06D6FF4531DCFFF3F2F6FFF6F6F6FFD4D0F1FF503EDBFF250DD4FF3A25
      D7FFA399E8FFF6F6F6FFF6F6F6FF8F84E4FF1C05D0FF402DD6FFF6F6F6FFF6F6
      F6FF8174E0FF210CCFFF2B16D0FFADA5E8FFF5F5F5FFF4F4F5FF301CCFFF1B04
      CAFF1A04CAFF1A04C9FF0E0268BB000000020000011400000001000000000000
      00000000000000000003646466FDE9EFF0FFB7B7B7FF434686FF5556CEFF575A
      8FFF636783FF686C85FF5153C6FF575AC7FF3B3D98FF373A78FF3B3D8EFF5153
      BDFF4E51C0FF32348EFFDCE3E4FF9E9E9EFF0000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000191A
      1A55ACACACF01717177900000004000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000051B1B1B83A3A3
      A4EB1414144C0000000000000000000000000000000000000000000000000000
      00000000001A1E079FDB1529E5FF0067C6FF0883BBFF0988BBFF0988BBFF0882
      BBFF0560C6FF0E24E5FF1708F6FF4900A9FFB40519FFEF3839FFFB444EFFED0E
      1EFFE9081BFFE9081CFFE70718FFE50514FFE70C15FFED1B1EFFED221AFFA206
      01E61300005700000002000000000000000000000000030015532007DBFF2007
      DAFF2007DAFF2007D9FF7869E5FFF5F5F7FFF8F8F8FFF8F8F8FFF7F7F7FFF7F7
      F8FFF8F8F8FFF8F8F8FFB7B0EDFF230BD5FF1E05D4FF1E05D4FFACA3EBFFF8F8
      F8FFF8F8F8FFF7F7F7FFF7F7F7FFF8F8F8FFF8F8F8FFA9A0E9FF1C05CFFF1C05
      CFFF1B05CEFF1B05CDFF05012975000000000000011500000003000000000000
      00000000000000000002545353FEECF1F2FFB5B5B5FF26278AFF4F50D7FF484A
      94FF5E6182FF676B86FF6163C1FF5D5DD3FF5354A4FF454976FF323493FF4F52
      AFFF5659B5FF454992FFDDE4E5FF9F9F9EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001C1C1C723D3D3EFF0E0E0E90000000080000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000A1010109D3F3F3FFF1818
      1868000000000000000000000000000000000000000000000000000000000000
      00000000001D2500D4F7130FFFFF0023FFFF0621FFFF0E0AFFFF0D00FFFF0A00
      FFFF0C00FFFF0E00FFFF0E00FFFF120CF9FF4D15AAFFA90721FFD41410FFEE1B
      18FFF62E2EFFF63233FFF63131FFF52E2DFFEC1B15FFD51611FF900400DE1200
      005500000006000000000000000000000000000000000000000A1D06BCEC2207
      DDFF2107DDFF2107DCFF2107DCFF4E39E2FFABA1EEFFDBD7F5FFE9E7F6FFDFDC
      F5FFBBB4F0FF6C5CE4FF2209D9FF2007D8FF1F07D8FF1F07D7FF220AD7FF7B6D
      E5FFC8C2F1FFE5E3F5FFE5E3F5FFCAC5F1FF8274E5FF220AD4FF1D05D3FF1D05
      D2FF1D05D2FF1C05C9FB0000021E000000000000011500000005000000000000
      00000000000000000002555454FEEDF2F3FFB6B6B6FF292B86FF4C4DD2FF484A
      9AFF5F6386FF666A8AFF5658C3FF5759B5FF5C5EA6FF2D3070FF3E41A7FF3738
      C4FF4748CBFF494D98FFDFE4E6FFA09F9FFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000C212121D4333333FF181818BB0000002700000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000010101012D1B1B1BC3333333FF1E1E1EC90000
      0008000000000000000000000000000000000000000000000000000000000000
      00000000001D2300E3FF0C12FFFF0017FFFF0903FFFF0500FFFF0300FFFF0400
      FFFF0101FFFF4D56FFFF939AFFFF5E6FFFFF3851FCFF1C2DE8FF40159EFF9606
      2EFFB40607FFB70707FFB70706FFB10705FC790301D119000062010000170000
      000300000000000000000000000000000000000000000000000009033A852308
      DFFF2308DFFF2308DFFF2308DFFF2307DEFF2307DEFF2207DDFF2207DDFF2207
      DDFF2207DCFF2107DCFF2107DCFF2107DBFF2007DBFF2007DAFF2007DAFF2007
      D9FF2007D9FF2007D9FF2007D8FF2007D8FF2007D7FF1F06D7FF1F06D6FF1F06
      D6FF1F05D6FF0D035AA700000001000000000000001100000008000000000000
      00000000000000000001545354FEEEF2F4FFB8B8B8FF262876FF3B3CB6FF4547
      8EFF575B83FF6569A0FF3C3CC4FF5A5E8CFF5D6195FF6D738DFF5054A4FF4649
      B1FF5F668FFF3A3E73FFE0E5E7FFA1A0A0FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000202E2E2EE33E3E3EFF383838F314141493010101290000
      0004000000000000000000000000000000000000000000000000000000000000
      0000000000050101012E15151599393939F63E3E3EFF2C2C2CDB000000190000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000001D2300E3FF0C08FFFF0803FFFF0700FFFF0000FFFF0004FFFF182A
      FFFFAFBAFFFFD0D8FFFF9CA7FFFF687DFFFF3852FFFF0C2FFFFF001FFFFF0B11
      FFFF2200E3FF0000001E00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000121F08
      BDEA2409E2FF2409E2FF2409E1FF2409E1FF2309E1FF2308E0FF2308E0FF2308
      DFFF2308DFFF2307DFFF2307DEFF2207DEFF2207DEFF2207DDFF2107DDFF2107
      DCFF2107DCFF2107DCFF2107DBFF2107DBFF2107DAFF2007DAFF2007DAFF2007
      D9FF1E07CBF80000042600000000000000000000000F0000000D000000010000
      00000000000000000001545454FDEFF3F5FFB9B9B9FF323472FF494CA5FF585B
      96FF2C2E78FF6C6FBFFF6B6F9EFF4E526BFF888E98FF9399A3FF7D84ADFF747C
      96FF67707CFF474C65FFE0E6E7FFA2A2A1FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000020303030D34D4D4DFF4C4C4CFF4A4A4AFD2E2E
      2ECB1515158B08080859030303370101012601010127030303380808085B1616
      168D303030CF4C4C4CFE4C4C4CFF4D4D4DFF2C2C2CCB0000001A000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000001C2100E3FF0E00FFFF0800FFFF0000FFFF010FFFFF2E48FFFF758D
      FFFFA3B0FFFFC2CBFFFF9CA9FFFF6B7EFFFF3148FFFF0E25FFFF0519FFFF0B0D
      FFFF2100E3FF0000001D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000401
      1A592509E5FF2509E4FF2509E4FF2409E4FF2409E3FF2409E3FF2409E3FF2409
      E2FF2409E2FF2409E2FF2409E1FF2409E1FF2408E1FF2308E0FF2308E0FF2307
      DFFF2307DFFF2207DFFF2207DEFF2207DEFF2207DDFF2107DDFF2107DCFF2107
      DCFF0802327C000000000000000000000000000000100000000B000000010000
      00000000000000000001545454FDF0F4F6FFBCBCBCFF7B8387FF6F73A5FF4F51
      BCFF363797FF7478A9FF90969DFF979D9FFFA0A8A4FFA2A9A8FF7C82B0FF909B
      95FF88958DFF778286FFE1E6E7FFA2A2A2FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000B17171793535353FB5A5A5AFF5959
      59FF595959FF595959FF595959FF595959FF595959FF595959FF595959FF5959
      59FF595959FF5A5A5AFF515151FA141414890000000700000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000182300DDFC0F00FFFF0400FFFF0010FFFF0E32FFFF4361FFFF7086
      FFFFA7B5FFFFCDD4FFFF7380FFFF3943FFFF0F11FFFF0C00FFFF1C00FFFF1A00
      FFFF2100D1F50000001700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00010E044F972609E6FF2609E6FF2609E6FF2609E6FF2609E5FF2509E5FF2509
      E5FF2509E4FF2509E4FF2509E4FF2509E4FF2409E3FF2409E3FF2409E3FF2409
      E2FF2409E2FF2409E2FF2408E1FF2408E1FF2408E0FF2307E0FF2307E0FF1204
      71B6000000030000000000000000000000000000000700000007000000010000
      00000000000000000001555454FDF1F5F6FFBBBBBBFF9CA498FF99A0A3FF4D4F
      C4FF5457AEFF7A809DFFA2A8A8FFABB3ACFFB1B9AFFFB5BDB1FFB7BFB5FFB5BE
      B4FF96A593FF8D9891FFE2E7E8FFA3A2A2FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000101012A1D1D1DA05151
      51F5666666FF6B6B6BFF6D6D6DFF6D6D6DFF6D6D6DFF6D6D6DFF6B6B6BFF6666
      66FF4F4F4FF31B1B1B9A00000024000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000E1E0099D32000FFFF0210FFFF0022FFFF0F34FFFF4160FFFF7D94
      FFFF8092FFFF3746FFFF1217FFFF0600FFFF0D00FFFF1700FFFF1800FFFF2600
      FFFF1F0097D10000000E00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000004120468AB270AE8FF2709E8FF2709E8FF2609E7FF2609E7FF2609
      E7FF2609E6FF2609E6FF2609E6FF2609E6FF2609E5FF2609E5FF2609E5FF2509
      E4FF2509E4FF2509E4FF2509E4FF2509E3FF2509E3FF2409E3FF160685C50000
      000D000000000000000000000000000000000000000400000003000000000000
      00000000000000000000545252FCF0F4F6FFC2C2C2FFADB6A5FFB0B7B1FF797D
      BAFF9095B4FF8F95A2FFB3BBB3FFBAC4B7FFC0C9BAFFC2CCBBFFC4CEBEFFC6D0
      C1FFB7C4B2FF9AA897FFE5E8E9FFA4A4A3FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000C0404044E14141487242424AA323232BF313131BE232323A9131313840404
      044B000000090000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000309002B751B00F2FF011AFFFF0025FFFF1236FFFF4667FFFF2240
      FFFF0212FFFF0005FFFF0101FFFF0600FFFF0F00FFFF1900FFFF1600FFFF1B00
      F3FF09002C760000000300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000040E044F95290BE9FF290BE9FF280AE9FF280AE9FF280A
      E8FF2809E8FF2709E8FF2709E8FF2709E7FF2709E7FF2609E7FF2609E7FF2609
      E7FF2609E6FF2609E6FF2609E6FF2609E5FF2609E5FF12056BAF0000000C0000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000666564D7ECF0F2FFB7B7B7FFAEB99FFFB5C0AEFFB2BC
      AEFFB0BAADFFB4BFB0FFBAC5B4FFBFCBB8FFC0CDB8FFC3CFBAFFC3D0BBFFC2D0
      BBFFC2CFB6FFA7B6A1FFE3E4E7FFA3A2A2FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000010007312400A4D61605FDFF0026FFFF0C32FFFF091EFFFF000A
      FFFF000AFFFF0001FFFF0200FFFF0A00FFFF0F00FFFF1500FFFF1700FDFF2200
      A6D7010007310000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000005011A562209C2E8290BEBFF290BEAFF290B
      EAFF290BEAFF290BEAFF290BEAFF290AE9FF290AE9FF280AE9FF2809E9FF2809
      E8FF2709E8FF2709E8FF2709E8FF2308CFF20702296D00000001000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000005A5A58CDE4E5E6FFADADADFF4C423BFF504B46FF504B
      46FF514C49FF534F4BFF5D5A56FF605D59FF585550FF504E49FF4F4D48FF504C
      48FF514E49FF53514DFFDDDEE1FF9C9B9BFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000002040016552500BCE5170FFEFF0011FFFF0000FFFF0000
      FFFF0001FFFF0200FFFF0900FFFF0A00FFFF0C00FFFF1B00FEFF2300BEE60400
      1857000000020000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000F0B033A802309C5EA2A0B
      EBFF2A0BEBFF290BEBFF290BEBFF290BEBFF290BEAFF290BEAFF290BEAFF290B
      EAFF290BEAFF2509D0F20D034990000002190000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000535151CFD9D8D8FFE7E7E7FFE5E5E5FFE7E7E7FFE5E5
      E5FFE6E6E6FFF3F3F3FF868686FF262626FFD8D8D8FFE6E6E6FFDBDBDBFFD9D9
      D9FFD6D6D6FFD1D1D1FFDEDDDDFF939292FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000006040017552300ACDD2100F2FF1600FFFF0500
      FFFF0300FFFF0500FFFF0800FFFF1A00FFFF2200F2FF2400AEDE040017550000
      0006000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000060301
      144B0E034D921A068FC7230AC6EA290BE5FC2A0CE7FD250ACAED1C0896CD0F04
      569A05011A560000000B00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000454443C4CECECEFFBFBFBFFFBABABAFFBBBBBBFFB0B0
      B0FFA7A7A7FFC2C2C2FF727272FF404040FFA4A4A4FFBBBBBBFFB7B7B7FFB6B6
      B6FFB4B4B4FFB2B2B2FFC7C6C6FF8C8B8BFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000030000011706001F611C0092D12600
      D6FC2300DDFF2300DDFF2600D6FC1C0092D106001F6200000117000000030000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008080863605F5FC9606060CD5B5B5BCB5B5B5BCB5B5B
      5BCB5B5B5BCB5B5B5BCB5C5B5BCB5B5B5BCB5C5B5BCB5B5B5BCB5B5A5ACB5B5A
      5ACB5A5959CB595959CB6A6A6AD1303030A00000000000000000000000000000
      00000000000000000000000000000000000096B2AB00A7C3BC00AAC3BC00A1BA
      B300AABEB8009AAEA80033474100293D37002F4840006B847C00779189007892
      8A008FA9A100B2CCC400C2DCD400C7E1D900CEE7E0008DA69F007A938C00839C
      950091ABA4008AA49D0089A39C0095AFA80094AEA7008BA59E008EA7A000869F
      9800859B9500819791007D938D00798F8900000000000000001D010101710000
      00430000000E0000000100000000000000020000000300000004000000060000
      0007000000090000000A0000000B0000000C0000000D0000000E0000000E0000
      000E0000000E0000000E0000000D0000000C0000000B0000000A000000080000
      0006000000050000000400000002000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000095B4AC00A2C1B900A8C2BB00A8C2
      BB00AFC5BF00B2C8C20094AAA400293F3900304942007E97900086A099007791
      8A008FA9A200BAD4CD00CCE6DF00C2DCD500A1B7B1008BA19B00849D96006B84
      7D008FA8A10097B0A90093ADA6007B958E00718B8400829C95008EA7A00087A0
      99008BA49D008AA39C007E948E007B918B000000001B0E0E11D439373CFF4B4B
      4BDF0202025A0000000E00000003000000090101011102020218040404210606
      062A0A0A0A330D0D0D3B11111143141414491717174E1A1A1A521B1B1B541C1C
      1C551B1B1B54191919511717174D13131347101010400C0C0C38090909300606
      062804040420020202170000000D000000050000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000A0000000A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000094B5AD00A7C8C000AAC9C100AECD
      C500ACC6BF00B2CCC500CBE4DD0093ACA500293F39007B918B00829A96007D95
      9100A4BCB800B7CFCB0099B1AD007E969200768A8400879B9500607670007389
      8300A6BFB8007F989100506962005E777000839D9600839D96008DA7A00096B0
      A9008EA8A10088A29B0088A19A00809992000303035238373AFF838386FF7373
      75FF515051E20303035F0000001B010101170202021D04040426050505290707
      072F0A0A0A380E0E0E40111111471414144D171717521A1A1A571C1C1C591C1C
      1C591B1B1B581A1A1A56171717521414144C111111480E0E0E420B0B0B3A0808
      08330505052A0303032201010116000000030000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000050303
      0391191918A60000001700000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000092B5AB00A4C7BD00A7CAC000ABCE
      C400AECFC700ABCCC400B8D2CB00C9E3DC00677C79002B403D00435653003E51
      4E00516663006277740059716D006E86820087999300889A940000110B00162A
      24005A706A0043595300617A73009DB6AF00ABC5BE008CA69F008AA49D0095AF
      A80092AEA70096B2AB008FA9A2008AA49D000000000B2625258A757476FF9292
      94FF858385FC615F5FF6050505E5010101D4020202D20E0E0EAF252525BD2B2B
      2BBE2C2C2CBE2E2E2EC02F2F2FC0303131C1323232C1323232C1323232C23232
      32C2323232C1323232C1323232C1323232C12A2A2AC5060505ED050505ED0504
      04ED040303ED030303ED010101ED0202026A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000807070797B3B1
      AFF9F5F4F2FF585857CD00000018000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000096B9AF00A9CCC200AFD2C900A8CB
      C200ABCEC500ABCEC500BCD6CF00C8E2DB00C3D4D1000B1C1900000D0B001F2C
      2A00495A57005B6C6900728784007C918E0099A8A3005E6D680013251F003648
      4200384C460070847E0098B1AA0095AEA7007D9790005A746D007B958E009FB9
      B20099B5AE0092AEA70090ACA50092AEA70000000000000000032D2D2D98817F
      81F2DDDCDAFF979493FF686565FF161210FF17110FFF181514F180807FFC8F8F
      8FFF8E8E8DFF8E8E8EFF8D8D8CFF8E8D8DFF8C8C8CFF8A8A8AFF8A8A8AFF8A8A
      8AFF898989FF8B8B8BFF8A8A8AFF929292FF6B6867FF160F0CFF1A1412FF1B14
      12FF1E1715FF191311FF1A1312FF070605E10000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000A0A0A0A9DBDBCB9FCE1DF
      DDFFFFFFFDFFFFFFFFFF2C2C2B89000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009EBDB400B1D0C700AACDC300A9CC
      C200AACDC400AACDC400AFC9C200C0DAD300D4E2DD002F3D38001C2521005760
      5C0076847F007E8C8700798D8700798D87008D9C97002E3D38003A4C46004456
      5000697D77009EB2AC00A7BDB7009EB4AE008CA69F007D9790006F89820087A1
      9A009EBAB30094B0A90097B3AC0090ACA50000000000000000000000000C4646
      45E6A29F9DFFDEDCDBFF939090FF666261FF171211FF261F1DFF888787FF9A9A
      9BFF534F4DFF322C2AFF37302EFF676260FF828181FF929292FF919191FF8F8F
      8FFF8E8E8EFF8F8F8FFF909090FF979797FF6F6D6CFF1B1412FF1F1816FF1F18
      16FF1D1614FF1F1816FF231C19FF080706E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000C0D0D0DA2C5C5C2FFD7D5D4FFFCFC
      FAFFF2F2F1FF6C6B6BAC0000000F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000010100
      00110000000C010000120100001001010113010101120000000B000000070000
      000B000000060000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A0BAB200B7D1C900A9CAC100A9CA
      C100A4C5BC00A3C4BB00B4CDC500C1DAD2009BA49F0039423D0065686400787B
      77007C858000868F8A00687A7300879992006F7E79002B3A35003C4E48006375
      6F0094A8A200AABEB800AFC5BF00AAC0BA00ADC6BF00A2BBB4009EB8B1009EB8
      B100A9C3BC009CB6AF009DB7B00097B1AA000000000000000000000000000505
      05D1565150FFA3A1A0FFE1DEDDFF9B9999FF63605FFF1F1B1AFF878686FFA1A1
      A1FF211E1DFF1C1411FF211916FF231C19FF838281FF989898FF959595FF9595
      95FF949494FF949494FF959595FF9D9D9DFF767372FF1E1714FF221B19FF221B
      19FF1F1816FF271F1CFF28201DFF0A0907E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000C0F0E0EA3C5C4C2FFCAC8C5FFECEAEAFFEAE9
      E7FF7E7E7DB80000000900000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010000110703
      002B0E0A053C523117919E612ECAB8864FDAB7996AD993764EC35A493098130F
      0A47010100160000000600000000000000000000000000000000000000000000
      000000000000000000000000000000000000ABC4BD00B7D0C900AFCEC500A7C6
      BD00A4C5BC00A3C4BB00B9CFC800546A6300070F08001D251E0061635D00292B
      2500555D56005F676000697C73009BAEA5006B7A7500273631005E706A0097A9
      A300AFC3BD00BCD0CA00B3C9C300A8BEB800ADC6BF00B8D1CA00D2EBE400627B
      740058726B00A3BDB6009CB6AF0098B2AB000000000000000000000000000000
      00CF261F1DFF575351FFA2A09EFFE2DFDEFF9A9897FF676363FF626262FF9C9D
      9DFF242120FF231A17FF28211DFF2A2320FF888786FF9E9E9EFF9A9A9AFF9B9B
      9BFF9B9B9BFF9B9B9BFF9C9C9CFFA2A2A2FF797675FF221A17FF261E1BFF251E
      1BFF201917FF29221FFF2C2421FF0B0908E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000090F0F0FA2C7C5C4FFBCBAB7FFD7D5D5FFDFDDDCFF9290
      90C20000000F0000000000000000000000000000000000000000000000000000
      0000000000010000000400000006000000080000000B0000000B0F080144632F
      0FA5DF520DF4F4660FFFF47E23FFF4BF76FFF4B259FFF4B75FFFF4CD85FFDAB8
      80F14A3F308F0604022C0000000C000000080000000700000005000000030000
      000000000000000000000000000000000000A9CBC500B3D5CF00A9C9CF009CBC
      C200A4B5B200AEBFBC00A5AEA0001C2517000206000011150A002F1F0E002818
      0700524530005649340043555400879998006A7B78001E2F2C007B908D00A3B8
      B500AFC9C200B3CDC6009FB9B1009DB7AF00A1BAB200A5BEB600A4BDB5009FB8
      B000B2CCC400ABC5BD009AB9B10098B7AF000000000000000000000000000000
      00CF251E1BFF28211EFF585452FF9A9795FFE1DEDDFF9A9797FF878585FF7172
      72FF232221FF251D1AFF2B2320FF2D2522FF8E8D8DFFA5A5A5FFA0A0A0FF9F9F
      9FFF9E9E9EFF9E9E9EFF9F9F9FFFA5A6A6FF797775FF241D19FF29211EFF2921
      1EFF201A18FF29221FFF302825FF0A0908E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000040A0A0A98C5C5C2FEACAAA7FFC0BFBDFFD4D2D0FF989898C50000
      0011000000000000000000000000000000000000000000000000000000050000
      00140101012602020235040404470606066F0505055D0906044B82300DCBD740
      0AFFD85611FFD87026FFD8A165FFD8B06EFFD8BC8BFFD8994AFFD89E50FFD89C
      4EFFD7974AFF755532C2070605470505055C0606066F04040445010101310000
      002200000011000000030000000000000000BBD7C600BAD6C500A9BFB9009CB2
      AC00A1ACA200A8B3A9004F503C000B0C000030291600221B0800281605003A28
      17003D30200042352500414A3C0030392B00526360002E3F3C00778C89009FB4
      B100A7C1BA00A4BEB7009EB7AF00A3BCB400B6CCC500B2C8C100BFD5CE00DAF0
      E900DDF7EF00A7C1B900A4C0B90090ACA5000000000000000000000000000000
      00CF29211EFF28211EFF2B2421FF595553FFA09C9BFFE3E2E1FFA29F9FFF8B8B
      8BFF1E1C1BFF261E1BFF2E2623FF312926FF939291FFA8A8A8FFA4A4A4FFA5A5
      A5FFA4A4A4FFA5A5A5FFA3A3A3FFA9AAAAFF7E7B7AFF28201DFF2D2522FF2C24
      21FF231C1AFF29211EFF2C2321FF0B0909E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000003030388B8B6B4F99D9C98FFA8A5A2FFC8C7C5FFA0A0A0CA020202180000
      0000000000000000000000000000000000000000000000000000000000040000
      00120101012518181887808080FA1F1F1FFF232323FF6B2513DED23B0AFFD44E
      11FFD46725FFD4C1A6FFD4BF92FFD4CAAEFFD4CFB8FFD4944CFFD48937FFD48A
      39FFD49D59FFD38B3FFF624329DC232323FF202020FF848484FA1515157E0000
      00210000000F000000030000000000000000BDD3C100C3D9C700B2C2B700A8B8
      AD00A0A9A400A4ADA8003A3A2A002A2A1A00372917002A1C0A002D212000190D
      0C00302F3100444345004347340072766300CCDDDA00C3D4D1008CA09A00A6BA
      B40098B1AA009EB7B000B0C6BF00D3E9E200E5F9F200CFE3DC00C2D6CF00DCF0
      E900C7DDD700AAC0BA009EB8B1009BB5AE000000000000000000000000000000
      00CF2C2421FF2B2320FF2D2521FF322A27FF5D5957FFA9A6A4FFE1DFDEFFA4A2
      A2FF5F5D5DFF211B18FF2E2724FF342C28FF979695FFAEAEAEFFACACACFFADAD
      ADFFAAAAAAFFABABABFFAAAAAAFFB0B0B1FF848180FF2B231FFF2F2724FF2F27
      24FF241E1BFF2A2320FF2D2522FF0C0909E00000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00529E9E9CEF979490FF8F8D8AFFC5C4C2FF909090C001010112000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      024C121212B25E5E5EC0929292FF1C1C1CFF232323FFA82A10FFEF5814FFEF69
      16FFEE9F48FFEEE4CAFFEDE3C9FFEDD5A4FFEDCF98FFED8C28FFEE811AFFEE89
      29FFEFD29EFFF0C389FFA05521FF232323FF1C1C1CFF9A9A9AFF575757BD1212
      12B301010143000000000000000000000000AFCABD00B2CDC0009CABA50096A5
      9F00AABABB008D9D9E00393F3B005B615D00463A380031252300393B54004648
      610043536F0069799500535C4E00B7C0B200C8DAD400A7B9B300C6DAD300B5C9
      C200BBD1CA00C5DBD400D1E5DE00EAFEF700E0F2EB0037494200485A5300CCDE
      D700C1D5CF00AABEB800A2BBB40098B1AA000000000000000000000000000000
      00CF2E2623FF2E2623FF2F2724FF312925FF332C29FF65605DFFB9B7B6FFDFDD
      DDFF959291FF676463FF241F1CFF302724FF9B9999FFB3B3B3FFAEAEAEFFAFAF
      AFFFB0B0B0FFAFAFAFFFB0B0B0FFB6B7B7FF8A8785FF2E2621FF322A27FF332B
      27FF251F1CFF2D2522FF312825FF0E0B09E00000000000000000000000000000
      0000000000000000000000000000000000010000001300000031000000430000
      00440000003300000013000000000000000000000000000000000000003E7979
      78DF95928FFF777471FFCDCCCAFF727272AB0000000B00000000000000000000
      0000000000000000000000000000000000000000000000000000000000003838
      38DE262626FFA8A8A8F4767676FF1E1E1EFF222222FFB65B29FFFF7825FFFF9F
      57FFFF9B53FFFFC281FFFFC28DFFFFAA5FFFFFAF65FFFF922BFFFF8F28FFFFA9
      5EFFFFEFCDFFFFE3C0FFAB5621FF222222FF1E1E1EFF7D7D7DFFA5A5A5F62525
      25FF343434D2000000000000000000000000A8BFB6009EB5AC0095A29A008996
      8E009AA4A4004A54540008090D00292A2E003D3542005D5562004E5380005B60
      8D004C61870054698F00838E8400E8F3E9009FAEA8007E8D8700EBFDF600B4C6
      BF00C9DDD600EAFEF700E4F6EF00EBFDF6008A99930004130D0056655F008C9B
      9500B8CCC600B9CDC700A3BBB7009BB3AF000000000000000000000000000000
      00CF312926FF312926FF322A27FF342C28FF322A26FF413B37FFA7A6A6FFC0BF
      BFFFDEDCDBFF939190FF656463FF3B3735FFA1A1A1FFBEBFBFFFBBBCBCFFBCBC
      BCFFBCBDBDFFBDBDBDFFBDBEBEFFC4C5C6FF93918FFF2F2722FF342C28FF352D
      29FF241D1AFF302825FF332B27FF0E0B0AE00000000000000000000000000000
      00000000000000000000000000290000007F1C1C1EC76F6F6FECA2A2A2F9AAAA
      AAFB878989F33A3A3CD70000009600000031000000000000001A545452CDA29F
      9DFF6A6764FFDAD8D7FF4C4C4C8B000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004949
      49E4262626FFB5B5B5FF5F5F5FFF222222FF292929FFB8724CFFFFB98DFFFF9A
      4CFFFF953BFFFF903CFFFF9238FFFF9032FFFF9A43FFFFD5B2FFFFC393FFFFEF
      DAFFFFE2B4FFFFC58BFFAD4E21FF292929FF222222FF646464FFAEAEAEFF2626
      26FF434343D6000000000000000000000000A0B1A2008FA09100828778008186
      7700838175003230240026202100352F3000352E4900564F6A0058588C004444
      7800465173003A4567009CA79D00F2FDF300A7B6AE00ABBAB200DFEFE700B3C3
      BB00A6B9B000D8EBE200DBEBE300C1D1C90098A6A00084928C00677671000413
      0E0061777100C4DAD400A7C0BC0097B0AC000000000000000000000000000000
      00CF332B28FF342C28FF352D29FF362E2AFF372F2BFF3B322FFF7B7675FFB7B6
      B5FFC3C1C0FFB2B1B0FF999796FF989797FF908F8FFFCBC9C9FFDAD8D8FFDBD9
      D9FFDBD9D9FFDBD9D9FFDAD9D9FFD3D1D0FF696361FF2E2523FF2F2724FF2B23
      21FF292220FF362E2AFF362E2AFF0E0C0BE00000000000000000000000000000
      000000000006000000633D3D3DDCE9E5E5FFFFFFFFFFFFFDF1FFFFF2E1FFFFF1
      DFFFFFFAEAFFFFFFFFFFFFFFFFFF898989F50000007B00000071D8D5D4FF9492
      8FFFDDDBDBF72626266400000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004444
      44E4626262FFADADADFF565656FF2A2A2AFF323232FFBB815FFFFFDEC0FFFFEB
      CAFFFFAB68FFFF8C39FFFF9746FFFFA65AFFFFD5B2FFFFFFFFFFFFFFFFFFFFFD
      F5FFFFE4BAFFFFC999FFB06E47FF323232FF2A2A2AFF5E5E5EFFA6A6A6FF6666
      66FF3E3E3ED6000000000000000000000000A0B0A80095A59D006F736600777B
      6E0080756500322717002A2328003C353A0033356400515382006C6EAB004244
      8100464C6A004A506E00798B8A00E3F5F400B4C3BB00CCDBD300C3D3CB0096A6
      9E00A0B3AA00B9CCC300CADAD200B9C9C100BAC9C300BCCBC500808F8A006B7A
      750078908C00A6BEBA00BAD5D1009FBAB6000000000000000000000000000000
      00CF372F2BFF372F2BFF38302CFF3A312EFF3B322EFF3B322FFF352B28FF372C
      29FF615A58FF989493FFAEADACFF878482FF6F6A69FF28221FFF352A27FF382E
      2AFF382D2AFF382D2AFF372C29FF362B28FF392E2BFF3F3532FF3D3330FF3C33
      2FFF3B322EFF38302CFF39312DFF0F0D0BE00000000000000000000000000000
      00050000007CA0A0A2F9FFFFFFFFFFE2CDFFFFC4A7FFFFC4A4FFFFCAA8FFFFCA
      AAFFFFC5A5FFFFC2A4FFFFD4BDFFFFFFFFFFD9D8D8FDA4A1A1FBC0BEBCF77978
      78B70F0F0E3E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      40E46E6E6EFF9F9F9FFF595959FF353535FF3A3A3AFFBD8F72FFFFE5CFFFFFF4
      DDFFFFB675FFFF9B53FFFF984CFFFFAB67FFFFC698FFFFFFFFFFFFFFFFFFFFF4
      DCFFFFF0D8FFFFBE94FFB36B45FF3A3A3AFF353535FF5F5F5FFF9A9A9AFF7373
      73FF3A3A3AD600000000000000000000000090A7A90089A0A2007A8681006C78
      7300655C51003A3126002A263700363243003D4C9100808FD4009FA5F200454B
      980050557A0062678C0054707C009BB7C300C8D5CD00BCC9C100697870006C7B
      730064756A00A8B9AE00C8D8D000CBDBD300D5E4DE00D3E2DC00CDDFD900D1E3
      DD00A4BCB80097AFAB00B1CFCA009EBCB7000000000000000000000000000000
      00CF39312DFF3B312EFF3B322EFF362C29FF372D2AFF39302DFF3B312EFF3D33
      30FF443A37FF66605EFF9F9C9BFFACAAAAFF898685FF696665FF332C2AFF4037
      34FF433936FF423835FF413734FF3F3532FF3C322FFF3A302DFF382E2BFF382E
      2BFF3C3330FF3C322FFF3D3430FF0F0E0CE00000000000000000000000000000
      0062A8A8A9FAFFFFFCFFFFCAAFFFFFCCAAFFFFDFBFFFFFECCCFFFFF2D0FFFFF2
      D0FFFFEFCDFFFFE4C4FFFFD0AFFFFFBFA0FFFFF4E5FFF5F2F2FF1E1C1CB70000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004F4F
      4FE4818181FFA1A1A1FF6A6A6AFF3F3F3FFF414141FFBF8A6CFFFFC193FFFFF0
      D3FFFFC175FFFFA76AFFFFA666FFFFB074FFFFC191FFFFF6EDFFFFF0E4FFFFD6
      ADFFFFE1C8FFFFC8A1FFB67A58FF414141FF3F3F3FFF6E6E6EFF9C9C9CFF8686
      86FF474747D60000000000000000000000007F99A600809AA700818881006970
      69006251420038271800362E3B003F374400534986008C82BF0096BCFF00395F
      A7004F78A5006F98C500637B8700526A7600969D9800787F7A0088ADA3008CB1
      A7005B6A64008A999300A1BBB3009EB8B000C1D0CB00CBDAD500B2D4CE009EC0
      BA007EA29C00729690009AAEAD0099ADAC000000000000000000000000000000
      00CF3C3330FF3C322FFF3F3532FF2F2A28FF342F2DFF342F2DFF35302EFF3631
      2FFF36322FFF3B3634FF605D5BFF9E9C9BFFB0B0AFFF8A8888FF646261FF2A27
      25FF36312FFF393431FF373330FF36312FFF35302EFF34302DFF342F2DFF2F2A
      28FF403633FF3F3532FF3F3532FF100E0DE00000000000000000000000244B4C
      4DDDFDFDF8FEEBBFA7F5EDD2B7F6EBDFC2F5EBE8C8F5EBEBCFF5EBEBD2F5EBEB
      D2F5EBEBCFF5EBE9CAF5EBDFC0F5EBCBAEF5EBAF93F5EFE9DBF7BABABAFA0201
      0141000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004D4D
      4DDA979797FF949494EE868686FF474747FF484848FFC08260FFFFAD6AFFFFEE
      E0FFFFC695FFFFAF69FFFFB482FFFFB37EFFFFC9A0FFFFEFE1FFFFE2BFFFFFD3
      B8FFFFDABEFFFFC9A4FFB88160FF484848FF474747FF8A8A8AFF949494F29D9D
      9DFF474747CE000000000000000000000000718388006E8085006F787400717A
      76006E6B6900252220001E293800717C8B00303864003A426E0088B6E6004775
      A500628AAD0094BCDF0071819400465669006C727100686E6D007B9D9700ABCD
      C7006A7B780081928F008DADA80090B0AB00B3C7C600C1D5D40096B9B50087AA
      A60074999700688D8B00879B9C008A9E9F000000000000000000000000000000
      00CF403633FF3B312FFF2D2825FFAEA49CFFE4DAD2FFE3D9D1FFE2D8D0FFE2D8
      D0FFE2D8D0FFE2D8D0FFDED5CDFFC2BCB7FFC1BDBBFFB4B1B1FF9D9A99FF9D9A
      97FF96908BFFD4CAC3FFE2D8D0FFE2D8D0FFE2D8D0FFE3D8D1FFE5DBD3FFADA4
      9DFF2B2624FF3E3431FF423734FF100E0EE000000000000000000000007FDFD9
      D6F8B39889D6C6BAA8E1BFBFADDDB8B8A7D9B2B2A3D5B0B0A3D4B0B0A5D4B0B0
      A5D4B0B0A3D4B0B0A2D4B0B09BD4B0A992D4B09681D4AD8470D2D8D8D8EB403F
      3FB8000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      012A7D7D7DD3545454B3A8A8A8FF4C4C4CFF4D4D4DFFC19A83FFFFCA9CFFFFD4
      B8FFFFBD96FFFFBD74FFFFCBA6FFFFC69EFFFFD5B8FFFFF5E9FFFFFFFEFFFFF9
      EEFFFFE6CFFFFFC6A0FFBA8668FF4D4D4DFF4D4D4DFFAEAEAEFF4D4D4DAD8A8A
      8ADA010101260000000000000000000000005867620063726D005B6B6C004C5C
      5D005E6D760065747D00628393008EAFBF0058708700667E95009CD1E40077AC
      BF0083ADC00091BBCE006E7D93004B5A70007A7E7F0050545500466562008EAD
      AA00647675008597960092B7B50098BDBB00ABC8C700B2CFCE0091B5B5007FA3
      A3007B9D9D005F8181007E909500819398000000000000000000000000000000
      00CF423835FF3E3431FF312C29FFD7CCC3FFDFD6CFFFDED5CEFFDED5CEFFDED5
      CEFFDED5CEFFDED5CEFFDED5CEFFDBD3CCFFC2BCB7FFC0BDBBFFB5B4B2FF9D9A
      99FF9C9997FF98928DFFD1C8C2FFDDD4CDFFDED5CEFFDED5CEFFDFD6CFFFD9CE
      C6FF2F2A28FF403633FF453B38FF110F0EE00000000000000019343434CAA99B
      92D09B8C80C7B2B2AFD59E9E9AC992928DC182827BB67F7F79B47F7F7AB47F7F
      7AB47F7F79B47F7F78B47F7F74B47F7F6FB47F7666B47D6252B384776EB8A6A6
      A6EC0101012A0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0002939393D21616176EA6A6A6F4494949FF515151FFB58469F4FFD7AEFFFFD8
      BFFFFFE3D0FFFFE7D0FFFFF0DCFFFFDCC3FFFFCDA9FFFFD6B3FFFFEFE2FFFFEC
      D9FFFFDCC2FFFFBD95FFAB7758F3515151FF4A4A4AFFA8A8A8F21515156C9C9C
      9CD70000000300000000000000000000000052645D005A6C6500657F7F00647E
      7E006A879000728F9800709DA70084B1BB006B848E0070899300A5D8DA009ED1
      D3009FCCD000A0CDD10076909C00647E8A00959A99002F3433004C67630098B3
      AF00536663007C8F8C0094C3BB0090BFB700B1D4D000AFD2CE00A9CECC0098BD
      BB0088A9A70062838100798F9100768C8E000000000000000000000000000000
      00CF453B38FF403634FF332E2BFFDACFC6FFDFD5CEFFC5BAB5FFC5BAB5FFC5BA
      B5FFC5BAB5FFC5BAB5FFC5BAB5FFC5BAB5FFC4B9B4FFB3ABA8FFBAB7B5FFBAB9
      B9FF9F9C9BFF767373FF948B88FFC2B7B2FFC5BAB5FFC5BAB5FFDFD5CEFFDAD0
      C9FF312C2AFF433936FF483D3AFF120F0EE000000000000000407E7C7CE56C59
      51A6A1A1A0CBA0A0A0CA898989BB797979B060605E9D58585496595957975959
      57975959569759595697595954975959519759574A97594C409753423A92B2AA
      A9E00C0C0C630000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000E0E0E445B5B5BC900000020030303460202022C23120A62EFC2A3F8FFE8
      D7FFFFFCF8FFFFF9F2FFFFF7E8FFFFDEB4FFFFCFA9FFFFDFC9FFFFECDBFFFFE0
      C9FFFFCAA8FFE0986CF1160A04500202022C0202024601010123595959C90B0B
      0B3F00000000000000000000000000000000667E7A0079918D0084A3A0008BAA
      A70091B3B3008EB0B00083ABAA0087AFAE00646F75006671770092BAB90086AE
      AD0097C5C10096C4C00095BDB80098C0BB00ADB4AD00272E270058726800B4CE
      C4006B7B73007D8D850092C2B600A4D4C800B3D8CE00B0D5CB00AED1C800A0C3
      BA007A95910069848000667B7800647976000000000000000000000000000000
      00CF473D3AFF433936FF352F2DFFDED4CCFFE5DCD6FFE4DBD5FFE4DBD5FFE4DB
      D5FFE4DBD5FFE4DBD5FFE4DBD5FFE4DBD5FFE4DBD5FFE0D8D2FFC4BEBAFFC5C2
      C0FFBEBDBDFFCAC9CBFF706C6CFFD7CEC8FFE4DBD5FFE4DBD5FFE5DCD6FFDED4
      CDFF322D2BFF453B38FF4B403EFF130F0FE0000000000000005B8C8786E14A3A
      358AADADADD2999999C67F7F7FB46D6D6DA745454585383836783A3A387A3A3A
      387A3A3A387A3A3A387A3A3A377A3A3A357A3A3A327A3A332C7A332822738F83
      80C71C1C1C880000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000878787D00E0E0E5B00000000000000000100001037251778D6C4
      BBEBFFFEFBFFFFFFFEFFFFF8E7FFFFE1AAFFFFDBBAFFFFD2B9FFFFDAC2FFFEBF
      9CFFCC8157E71B0D075600000005000000000000000014141468757575C40000
      00000000000000000000000000000000000093AAA80092A9A70087A39C00839F
      980087A19900829C940087A39C0097B3AC006B6A6C006E6D6F00A3C2BF0092B1
      AE0086B1A70093BEB40092BBAC0098C1B200AAB4A600364032005E756500C8DF
      CF00768276009EAA9E00AEDECC00A6D6C400AFD4C500A0C5B6008AA59B005C77
      6D00455C53004C635A004F655E005D736C000000000000000000000000000000
      00CF493F3CFF453B38FF36302EFFE1D7D0FFE8E1DAFFE7E0D9FFE7E0D9FFE7E0
      D9FFE7E0D9FFE7E0D9FFE7E0D9FFE7E0D9FFE7E0D9FFE7E0D9FFE4DDD6FFADA8
      A6FFBBBBBDFFFFFFFFFFC8C7C8FFA29D98FFE6DFD8FFE7E0D9FFE8E1DAFFE1D8
      D2FF332E2CFF473D3AFF4D4340FF14100FE00000000000000061807B7ADB3127
      2374B7B7B7D8A1A1A1CB7D7D7DB3383838782828276624242360242423602424
      23602424236024242260242422602424216024241F6024201B601E1713586D62
      5FB62120208E0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000808080D2212121800000000000000000000000020202001B0D09
      073C77675FAFDFD3C7EFFFF9EFFFFFFBF5FFFFDFB1FFFECBA2FFD48865EC5D2F
      1B9D0B0501380000000400000000000000000000000125252588737373C80000
      000000000000000000000000000000000000838F8900707C76005D6C66005968
      62005B6A62005F6E66006479700072877E00787671008F8D880089A59D0084A0
      980087AAA00091B4AA00A1BBB100A2BCB200B1C1B0004C5C4B0043594700B7CD
      BB0073796C009DA39600A7D1BE00A3CDBA00A4C3B400809F900062766A00475B
      4F006B7C710078897E00697E750060756C000000000000000000000000000000
      00CF4B413EFF483E3BFF37322FFFE3DAD4FFEAE4DFFFCDC6C2FFCDC6C2FFCDC6
      C2FFCDC6C2FFCDC6C2FFCDC6C2FFCDC6C2FFCDC6C2FFCDC6C2FFCDC6C2FFCBC5
      C1FFABA5A3FFB1AFB0FFFFFFFFFF8D8B8BFFC3BCB8FFCDC6C2FFEAE4DFFFE3DB
      D5FF34302DFF4A403CFF504642FF15110FE000000000000000476C6C6CDA1D17
      1461BDBDBDDCB3B3B3D62A2A296824242460444444841A1A1A53131312461414
      1348141413481414134814141348141412481414114814120F48100B0A406158
      56BB1919197F0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000017171755707171EB0303034D0000000100000000000000010000
      000701000010050403241A1514532D24226C2C1F1C6B1D130A57120C02450403
      00220000000600000000000000000000000103030354737373EC1212124D0000
      0000000000000000000000000000000000004B4F44004F534800505750005158
      5100585E5A005F65610052625A005B6B63005C5E510063655800658473006786
      750075908600809B910090989700868E8D008E9D8E00606F60005A6C5D00AABC
      AD0044463900808275009CC2B10094BAA90099B5A60088A495007F8D82007583
      78007E8B830076837B0060756C0061766D000000000000000000000000000000
      00CF4E4441FF4B403DFF383330FFE6DED8FFEDE7E3FFECE6E2FFECE6E2FFECE6
      E2FFECE6E2FFECE6E2FFECE6E2FFECE6E2FFECE6E2FFECE6E2FFECE6E2FFECE6
      E2FFECE6E2FFECE6E2FFBBB6B3FF8B8989FFC3BEBBFFECE6E2FFEEE8E3FFE6DF
      D9FF36312FFF4D433FFF534844FF151210E0000000000000001D525252D2130E
      0C5D838383B73838377820201F5B696969A44C4C4C8B2121215D0707072D0909
      093109090831090908310909083109090831090907310807062F09060535625F
      5FD4090909510000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000121212A21F1F1FF60505056C00000005000000000000
      0000000000000000000000000000000000010000000100000000000000020000
      0001000000000000000000000006050505751F1F1FF811111198000000000000
      0000000000000000000000000000000000003F3D380042403B004C4A45004947
      42004E4D490052514D00595854005D5C5800525650005C605A00767E7700757D
      76007383780066766B006B7C71007384790094A092006C786A00617A6A009AB3
      A3003B4136006F756A0090AB9E007994870079877C006C7A6F006B7B73007A8A
      820073867D006E8178006877710062716B000000000000000000000000000000
      00CF504642FF4D423FFF393431FFE8E1DBFFEFEAE7FFEEE9E6FFEEE9E6FFEEE9
      E6FFEEE9E6FFEEE9E6FFEEE9E6FFEEE9E6FFEEE9E6FFEEE9E6FFEEE9E6FFEEE9
      E6FFEEE9E6FFEEE9E6FFEEE9E6FFEBE6E3FFEAE5E2FFEEE9E6FFEFEAE7FFE9E2
      DDFF373230FF4F4541FF554B47FF151211E000000000000000001919199A2521
      1F9E0403022529292967A9A9A9D0787878AF4F4F4F8E32323272090909320202
      02180303031D0303031D0303031D0303021D0303021D010101140C0807576565
      66DB000000150000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000010191919D0272727FE131313B80101013B0000
      0004000000000000000000000000000000000000000000000000000000000000
      00000000000402020241141414BF272727FE151515C80000000B000000000000
      0000000000000000000000000000000000003E3931003E393100403B33003C37
      2F00403A350048423D004D484500504B48004E4B480053504D00585A54005658
      5200575E5700666D6600717A70007A8379007D86780079827400788F7F0098AF
      9F003C4035006B6F6400849D8F0070897B0079847A006F7A700067776C006A7A
      6F0061746B0060736A0062716900606F67000000000000000000000000000000
      00CF534945FF4F4541FF3A3533FFEBE4E0FFF3EFECFFD5CFCDFFD5CFCDFFD5CF
      CDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CF
      CDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFD5CFCDFFF3EFECFFEBE6
      E1FF383331FF524844FF584E4AFF151312E00000000000000000000000327171
      72E20000002D58545299F1F1F1F88C8C8CBD5C5C5C993B3B3B7B1D1D1D570202
      0217000000070000000C0000000C0000000C0000000600000011242424BD2827
      268F000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000191E1E1EC9373737FF363636FE2121
      21CA0C0C0C7C0303034100000021000000140000001500000022030303430C0C
      0C7E222222CE373737FE373737FF1C1C1CC20000001400000000000000000000
      0000000000000000000000000000000000004339300040362D0040352E004136
      2F00413531004438340042363200453935004E4240004F43410050494600564F
      4C0057534E005C585300585651005A585300676B5E007276690077897A008496
      87003A3A30006B6B61007E938500677C6E006C766A006A746800657368006270
      65005D6E63005A6B60005B6B60005A6A5F000000000000000000000000000000
      00CF544A46FF514743FF3B3634FFEDE7E2FFF5F1EEFFF4F0EDFFF4F0EDFFF4F0
      EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0
      EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF4F0EDFFF5F1EFFFEEE9
      E5FF393532FF554B47FF5A504CFF151412E00000000000000000000000002D2D
      2D911F1F21C6000000215C5A5AA3C6C6C6E17C7C7CB2484848882B2B2B6A1212
      12450000000F0000000000000000000000000000000100000081767676DF0000
      0015000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000A0F0F0F8C3E3E3EF94545
      45FF454545FF444444FF424242FA3E3E3EF33E3E3EF3424242FA444444FF4545
      45FF454545FF3D3D3DF80D0D0D83000000080000000000000000000000000000
      000000000000000000000000000000000000473A30003F3228003B2E24004134
      2A003F322A0042352D0040322C00493B3500493D39004D413D00544945005348
      44004E4541004A413D00554C48006057530062625600656559006B7A6B006C7B
      6C0036322600666256007C8E7F006A7C6D006E7769006D766800677367005F6B
      5F005D6E610058695C005B6A5D005C6B5E000000000000000000000000000000
      00CF564C48FF544946FF3C3735FFF1EBE8FFFAF9F8FFF9F8F6FFF9F8F6FFF9F8
      F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8
      F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFF9F8F6FFFBFAF8FFF1ED
      EAFF3A3533FF574D49FF5D524EFF161513E00000000000000000000000000000
      00055E5D5DBF101011C20000002A1211115F6D6D6DA7676767A2434343832727
      27641111114201010112000000000000000F00000085878789F3060606420000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000281414
      14943A3A3AE8535353FF5A5A5AFF5C5C5CFF5C5C5CFF595959FF535353FF3737
      37E5121212900000002400000000000000000000000000000000000000000000
      000000000000000000000000000000000000473F3000423A2B003E3528003F36
      29003D33280041372C0041372E00493F36004C423B0050463F0051464200493E
      3A004C413D00524743005E534F00605551005F5C4E006B685A00747F6F00727D
      6D004C443700675F5200718071006A796A0075796C0071756800656F61005E68
      5A005E6D600057665900586458005A665A000000000000000000000000000100
      00CF5B514DFF5E5450FF3D3835FFF2EEEAFFFAF8F7FFDAD6D5FFDAD6D5FFDAD6
      D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6
      D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFDAD6D5FFFBF9F7FFF3EF
      ECFF3B3634FF594F4BFF5F5551FF171514E00000000000000000000000000000
      00000000000B4E4D4DAF484848E70000007100000034020101380605053C0403
      03300101011F000000220000005606090AC4848282E606060642000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000400000032060606600B0B0B760B0B0B760606065E000000300000
      0003000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000040382700443C2B00463E2F00443C
      2D00433B2E004C4437004E453A0051483D00463F36004A433A0049423900534C
      43005A534A005F584F005B544B00534C43005E5C4C0072706000707C6A006E7A
      68006B645500766F6000657564005F6F5E00636859005D625300535C4E00535C
      4E0056625600535F5300545D5100586155000000000000000000000000000000
      00CF5D5450FF675D59FF3C3734FFF4F1EEFFFFFFFFFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFFFFFFFFF4F2
      F0FF3B3735FF5C524EFF615753FF171514E00000000000000000000000000000
      0000000000000000000013131260747373D7414143E3000000BB0000009D0000
      0099000000B01E1E20D86E6E70E73937379D0000001900000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004E443200504634004F473600463E
      2D00453D2E00484031004B4336004D4538004F493C00514B3E00534A3F00554C
      4100514B3E004C463900554D4000585043006665510071705C005C6854005C68
      5400736C5B007C756400647562005E6F5C005D60510056594A00494F42004B51
      44004C564A00515B4F00565E54005C645A000000000000000000000000000101
      01CF544B47FF655E5BFF3D3835FFFBF8F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F7
      F5FF3D3836FF615652FF655B56FF1A1615E00000000000000000000000000000
      00000000000000000000000000000000000708080842282727803D3C3BA14240
      40A832323291131312600101011B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000463A2800473B2900514434005346
      3600544939005146360051493A00564E3F00484132004A4334004C443700433B
      2E004E4738004F483900625B4C0060594A005E5F4B006667530058675100606F
      5900746D5C00766F5E0060715E005C6D5A006366570060635400555B5000585E
      5300545C520058605600585D54005A5F56000000000000000000000000000000
      0021201E1DDE221E1CE0252121DF4E4D4CCB50504FCB504F4FCB504F4FCB504F
      4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F
      4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F4FCB504F4FCB50504FCB4D4C
      4CCB252121DF211E1CDF231F1FE3171615770000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000014262525921F1F1F82000000060000000000000000000000000000
      000000000000000000010000000300000005000000090000000F010101160303
      031D050505250707072B090909300909093209090932090909310707072D0505
      05270404042002020219010101110000000C0000000700000003000000010000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000028060606BA070707B40505
      05AF050505AF040404AF040404AF040404AF040404AF050505B3060606C00000
      0046000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      001A343333A2C2C1BFFCE9E9E8FD262626710000000000000000000000000000
      000000000002000000060000000D02020218060606280C0C0C391616164C2424
      246133333373414141814D4D4D8D51515292525353934F4F4F8F454545853838
      3878282828661C1C1C55101010400808082E0303031E01010111000000080000
      0004000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000320F0F0FEB1E1E1EFC2C2C
      2CFF2B2B2BFF2A2A2AFF282828FF272727FF242424FF161616FB0D0D0DF40000
      0058000000000000000000000000000000000000000000000000000000000000
      0000000000000000000100000008000000110101011903030320040404260505
      052B0606062D0606062E0606062C05050528030303220202021A010101120000
      00090000000200000000000000000000000000000000000000000000001A4141
      41ACBBB9B8FCEDECECFFE4E4E3FE3E3E3D820000000000000000000000010000
      00040000000B0202021706060629101010402121215C3A3A3A7C5555559D6464
      64BA6F6F6FD1787878E27C7B7BEB7E7D7DF07D7D7CF07C7C7CED7B7B7BE57373
      73D76B6B6BC35D5D5DA8464646882A2A2A681515154A090909310303031D0000
      000E0000000600000002000000000000000011100F612C27228F2C27228F2C27
      228F2C27228F2C27228F2C27228F2C27228F2C26228F2C26228F2C26218F2C26
      218F2C26218F2C25218F2C25218F2C25208F2C25208F2C25218F2C25218F2D27
      228F2C25218F2C25218F2C25208F2C25208F2C25218F2C25218F2D27228F2D27
      228F2C27228F2C27228F2C27228F11100F5F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000001000000030000001F0E0E
      0ED82D2D2DFF2A2A2AFF282828FF282828FF0C0C0CDC00000022000000030000
      00020000000000000000000000000000000000000000040404351616167C1919
      19861C1B1B941F1F1F9E282827A8333232B23A3A3ABC424241C4484848CB4D4C
      4BCF4F504ED14F4F4ED24E4D4DD04A4A49CC424241C73A3939C132312FB72827
      27AC1F1E1E9D161615820101012D00000000000000000000001F434342AEBCBB
      B8FEE9E8E7FFE0DFDFFE676767A60000000A0000000000000001000000050000
      000D0303031E0A0A0A351C1C1C553939397F525252B15A5A59DE656463F9827F
      7EFEA7A6A4FFB8B6B5FFA7A39FFF9F9A97FF9F9A98FFA4A19CFFB7B3B1FFAFAE
      ACFF8E8D89FF6B6B69FB5F5E5CE95A5A5AC14545459025252563101010400505
      052601010112000000070000000200000000595047C2EBE7E6FFE2DEDAFFE0DA
      D6FFDDD6D2FFDBD3CEFFD8D0CAFFD6CDC7FFD4CAC3FFD2C8C0FFD0C4BCFFCEC2
      BAFFCCBFB6FFCABDB4FFC8BBB1FFC6B8AEFFC6B9AFFFC8BAB1FFCABDB4FFCEC1
      B9FFCABDB3FFCCBFB6FFCCBFB7FFCFC1BAFFD5C7C2FFD7C9C5FFDFD0CFFFDAD3
      CFFFDDD7D2FFDFDAD7FFE2DFDDFF5B544EBD0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000202
      028F2C2C2CFF2B2B2BFF2A2A2AFF282828FF0202029400000000000000000000
      00000000000000000000000000000000000000000000585858A6DBD9D8FFCECE
      CDFFC9C9C7FFC9C8C6FFC7C7C6FFC7C5C5FFC8C8C6FFC8C8C7FFC9C8C7FFCAC8
      C8FFCBCAC8FFCBCBCAFFCBCACAFFCDCCCBFFC6C5C3FFC9C8C7FFCAC8C7FFCAC9
      C8FFC9C8C7FFE8E8E7FF2A2A2980000000000000001E4C4C4CB3ADACAAFDD5D3
      D2FFD6D5D4FF7E7E7DB70000000C0000000000000001000000040000000C0303
      031E0C0C0C38212121603C3C3CA0525151E642403EFE666360FF9C9A99FFCAC9
      C8FFECEBEBFFEBE9E8FFE7E6E4FFE9E8E9FFE9E9E9FFE7E3E2FFE7E4E3FFEDE9
      E9FFD3D2D1FFACA8A7FF7A7674FF4B4744FF4D4C4BF4484847B72B2B2B721212
      124505050527010101120000000600000001514840BDD3C8D1FFAFAFAFFFAFAF
      AFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAF
      AFFFAFAFAFFFAFAFAFFFAFAFAFFFA9A19CFFA6A29EFFAFAFAFFFAFAFAFFFAFAF
      AFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAFAFFFAFAF
      AFFFAFAFAFFFAFAFAFFFD3C8D1FF544D47B70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      017D2E2E2EFF2D2D2DFF2C2C2CFF292929FF0101018400000000000000000000
      000000000000000000000000000000000000000000004F4F4FA7C2C1C0FFC7C7
      C7FFC7C6C7FFB1B1B1FFB0B0B0FFB3B3B3FFB9B9B9FFBBBCBBFFBEBEBEFFC0C1
      C1FFBFBFC0FFBEBEBEFFC4C4C4FFC5C5C5FFB2B3B2FFBCBCBCFFBCBCBCFFBFC0
      BFFFC0C1C0FFD5D4D3FF353535B21D1D1DEA7A7A79FDB1B0ADFFBCBBB9FFCBC9
      C8FFBABABAFF434343FE1E1E1EC5000000000000000100000008020202170909
      09301A1A1B5B373636B1696766FA4F4A48FF6F6C69FFC5C3C2FFE9E8E8FFF0F0
      EEFFE6E6E6FFDADBDAFFD1D2D2FFCFCFCEFFCFCFCEFFD1D0D1FFD6D6D5FFE0E0
      E0FFE8E9EBFFE6E4E6FFCFCECFFF8D8887FF484340FF64615FFE464646CD2424
      24710E0E0E3D0303031F0000000C00000003514840BDE5E3E5FFEAEAEAFFF7F7
      F7FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF8F9F9FFADA198FFB8B1AAFFF8F8F8FFF3F3F3FFF3F3
      F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3F3FFF3F3
      F3FFF9F9F9FFE5E5E5FFE5E3E5FF534D46B70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      017D2F2F2FFF2F2F2FFF2D2D2DFF2B2B2BFF0101018400000000000000000000
      000000000000000000000000000000000000000000003F3F3E99D3D2D2FFC1C2
      C1FFBDBEBDFFB7B8B7FFB9B9B9FFB6B6B6FFB2B2B2FFB1B2B1FFB3B4B3FFB1B1
      B1FFB6B6B6FFB9BAB9FFB9B9B9FFB6B6B6FFB3B4B3FFB1B1B1FFADADADFFB0B0
      B0FFB7B7B7FFE2E2E1FF383838B8919191F6A5A2A0FFA2A09DFFBAB8B7FFE9E9
      E8FFB8B8B8FFA1A1A1FF595959BB00000000000000030000000E040404211111
      114D343434B9827E7BFE7B7976FFB0AEAEFFF3F3F5FFD8D8D8FFAFAEACFF8B89
      88FF737271FF6C6D6AFF6A6A68FF6B6A69FF6B6B69FF6B6B6AFF6F6E6DFF7475
      74FF878786FFA8A7A6FFCCCCCBFFEBE9E9FFC5C8C6FF6F6B6AFF868280FF4948
      48DA1A1A1A660707072D0101011400000006514840BDD3D3D3FFF4F4F4FFFFFE
      FEFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFA
      FAFFFBFAFAFFFBFAFAFFFFFFFFFFB0A49BFFBEB6AFFFFFFFFFFFFBFAFAFFFBFA
      FAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFAFAFFFBFA
      FAFFFFFFFFFFF2F2F2FFD3D3D3FF524B46B70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      017D313131FF303030FF2F2F2FFF2C2C2CFF0202028400000000000000000000
      000000000000000000000000000000000000000000002A2A2A81E4E4E3FFB5B5
      B5FFB2B2B2FFB6B6B6FFB4B4B4FFB5B6B5FFBABABAFFB9BAB9FFB9B9B9FFB6B7
      B6FFB8B8B8FFB7B7B7FFAEAEAEFFADADADFFB2B3B2FFB8B8B8FFBCBCBCFFBCBC
      BCFFB4B5B4FFDEDDDDFF353534B6ADABA8FF888683FFB4B2B0FFD4D4D4FFB8B9
      B9FFBFBFBFFFB8B8B8FF6A6A6AC60000000000000005000000110505052F2424
      24A37E7876FFC2BEBFFFE7E6E6FFC5C6C8FF8B8B88FF636262FF5B5A59FF716D
      6CFF989695FFB0AFACFFA6A2A0FF9E9A98FF9E9B98FFA19F9AFFB0AFACFFA2A0
      9EFF7C7A78FF636260FF646463FF868584FFB9B8B7FFE0E0E1FFC2BFBFFF9793
      91FF3A3A3ACC0A0A0A440202021900000008514840BDD5D5D5FFF4F4F4FFFFFF
      FEFFF1F1F1FFB1B1B1FFC9C9C9FFC7C7C5FFBBBBC6FF6A68DFFF9995EBFFFBFB
      FAFFFBFBFAFFFBFBFAFFFFFFFFFFB0A39AFFBFB6AFFFFFFFFFFFFBFBFAFFFBFB
      FAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFB
      FAFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      017D323232FF323232FF303030FF2E2E2EFF0202028400000000000000000000
      0000000000000000000000000000000000000000000015151560F3F3F3FFCACB
      CAFFCCCBCCFFC4C4C4FFD0D0D0FFD4D4D4FFD3D3D3FFD0D1D0FFCECECEFFBCBD
      BCFF9B9C9BFF6C6B6BFF737171FF7E7D7DFF797878FF6D6B6AFF8A8A8AFFC7C6
      C7FFD2D2D2FFAEAEADFEA2A19DF2726F6CFFBDBDBAFFE1E1E1FF858082FFACAC
      ACFFC2C2C2FFBABABAFF6A6A6AC60000000000000005000000100707075C6C6A
      68F9CCCBCAFFD8DADBFF828180FF61605EFF474441FF62605DFF9A9795FFCBC9
      C8FFE9E7E7FFE8E6E4FFDEDBD8FFDDDDDCFFDDDDDCFFDDDAD8FFE4E1E0FFEBE9
      E8FFD5D3D1FFA9A8A4FF75726FFF4D4947FF5A5A57FF7E807CFFBFBEBFFFDBDA
      DBFF928F8CFF121212890101011A00000008514840BDD5D5D5FFF4F4F4FFFCFC
      FCFFF0F0F0FFBFBFC0FFFFFFFFFFF5F5F4FFE7E8EFFF5451FBFF6C68F9FFFBFB
      FBFFFBFBFBFFFBFBFBFFFFFFFFFFAFA39AFFBEB5B0FFFFFFFFFFFBFBFBFFFBFB
      FBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFBFBFFFBFB
      FBFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000090000011B0000011A0000011A0000011A0000011A0000011A0000
      011A0000011A0000011A0000011B000000070000000000000000000000000101
      017D343434FF333333FF323232FF2F2F2FFF0202028400000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7BC59696
      96E09C9C9CE4E5E3E3FEF6F5F5FFD3D3D3FFBBBBBBFFBABBBBFFA5A5A5FF8583
      83FFAEADACFFEBE4E0FFFFEDE4FFFFE6DAFFFFEADEFFF8ECE7FFC8C5C4FF8F8E
      8DFE898989EEADACACF68E8C89FFC6C5C3FFD4D4D4FFCBCBCBFFA68683FFB6AE
      AFFFC4C4C5FFBDBDBDFF6C6C6CC600000000000000040000000F171717A4E3E0
      DDFFD1D1D1FF62615EFF7A7876FF575450FF625D5CFFB1AFAFFFDEDDDEFFF3F5
      F5FFE7E7E7FFDBDCDCFFC9C9CAFFBDBEBDFFBCBDBBFFC4C4C4FFD6D5D6FFDEDE
      E0FFECEDECFFE2E1E2FFBDBCBCFF7B7976FF474340FF767272FF6B6B68FFA9A8
      A7FFF7F5F3FF474745D60000002400000006514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFCFCFCFFC0BFC0FFFFFFFFFFF9F9F7FFCCCBF3FF706BFDFF7671F9FFFCFC
      FCFFFCFCFCFFFCFCFCFFFFFFFFFFB0A39BFFBEB7B0FFEDEDEEFFDADADBFFD9D9
      D9FFD7D6D7FFD6D6D6FFD4D4D5FFD2D2D2FFD0D0D2FFCFCFD0FFCFCFCFFFCDCD
      CEFFD0D0D0FFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000011531818B1FF1E1EADFC1A1A9CF217179BF2171799F2161697F21515
      96F2151594F217179FFC10109EFF00000A440000000000000000000000000101
      017D353535FF353535FF333333FF303030FF0202028400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000504040345494947B1A2A1A1F5828282FF535353FF646363FFEBE6
      E4FFFFD4C1FFFFC6A9FFFFCDAFFFFFD2B3FFFFCFB1FFFFC8AAFFFFCAB2FFFAEA
      E3FF9E9D9CF4C1BEBDFB787878CDD5D4D4FFC1C1C1FFCDCDCEFFB9A781FFBBB7
      AFFFCBCCCCFFC3C3C3FF6D6D6DC6000000000000000100000017646361D9F0EE
      EEFF626161FF868380FF797673FF8E8C8CFFE2E1E2FFD8D7D7FFB2B3B3FF9695
      93FF81827EFF787776FF767675FF787776FF787976FF787877FF7B7979FF8381
      80FF939391FFABACABFFCBCCCBFFE0DEE0FFA8A4A6FF64605EFF8D8986FF6764
      62FFC2C0C3FFC0BEBBFA0000003D00000001514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFDFDFCFFCACAC9FFFDFCFCFFFFFFFBFF8886F0FF9790FFFF8680F9FFFDFD
      FCFFFDFDFCFFFDFDFCFFFFFFFFFFB2A59CFFC0B7B0FFFFFFFFFFFDFDFCFFFDFD
      FCFFFDFDFCFFFDFDFCFFFDFDFCFFFDFDFCFFFDFDFCFFFDFDFCFFFDFDFCFFFDFD
      FCFFFEFEFEFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      00000000052D02023690080865C32727B4FF2E2EB5FF2B2BB2FF2929B0FF2929
      AFFF2121AAFF06065FC601013190000003250000000000000000000000000101
      017D363636FF363636FF353535FF323232FF0202028400000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000050000000A00000014000000423F3D3DD1F0E8E1FFFECF
      B6FFFED6B7FFFEE7C5FFFCF0CEFEFCF3D1FEFCF2CFFEFCEAC9FEFCDABAFEFCC3
      A6FEFBE4D9FE8B8A89E910101070CECECFFFC4C4C4FFCFD0D0FFB49881FFBCB6
      B1FFAEAFAEFFB4B4B4FF6D6D6DC6000000000000000000000022ABAAA8EF8E8E
      8DFF787672FFB2B0AFFFD3D2D3FFCBCBCCFF999897FF737471FF61605FFF6766
      63FF838280FF9A9998FF969291FF918F8CFF918F8DFF93918FFF9C9A99FF8C8B
      89FF6E6F6CFF656463FF737371FF939392FFBEBFBEFFD0CFCFFFAEAAABFF938F
      8CFF73726FFFD8D7D6FF0303035100000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFDFDFDFFCCCCCCFFFBFBFBFFFFFFFCFF8C89F0FFAFA7FFFF9791F9FFFDFD
      FDFFFDFDFDFFFDFDFDFFFFFFFFFFB2A59CFFC0B7B1FFECECEDFFD9D9D9FFD7D7
      D8FFD5D5D5FFD5D5D5FFD4D2D4FFD1D1D2FFD0D0D0FFCECECFFFCDCDCEFFCCCC
      CDFFD0D0D0FFF4F4F4FFD5D5D5FF534D46B70000000000000000000000000000
      0000000000000000000000000000080862C02D2DB6FF2A2AB3FF2828B1FF2929
      B0FF070761C50000000100000000000000000000000000000000000000000101
      017D383838FF373737FF363636FF333333FF0202028400000000000000000000
      000000000000000000000000000000000000020202270909094C0A0A0A4B0A0A
      0A4B0B0B0B4B0C0C0C4B0A0A0A4B0808084B09090883CBC8C5FAEAC3AFFFEDDB
      C4FFEAE3C9FFE7E5CBFFD9D9C5F1DADAC7F0DADAC7F0DBDAC3F0DBD7BAF0DBC4
      A9F0DAA98FF0DCCEC9F34F4E4CD1BFBFBFFFC7C7C7FFD2D3D3FF988286FFB6B0
      B2FFCFCFCFFFC7C7C7FF6D6D6DC6000000000000000000000032B3B5B3FB7673
      6FFFB2B0AFFFDADADAFF898B89FF6A6A68FF4E4C4BFF5B5857FF8E8C87FFC2C2
      BEFFEBE8E7FFF0EDECFFDEDBD8FFDDDBD8FFDDDBD8FFDCDAD7FFEBE7E6FFF0ED
      EDFFCFCCCBFF9F9B99FF6C6865FF504E4DFF676564FF868685FFC0C2C3FFC9C8
      C9FF827C7AFFB7B6B5FF0A0A0A6700000000514840BDD3D3D3FFF4F4F4FFFFFF
      FFFFFEFEFEFFCDCDCDFFFDFDFDFFFFFFFFFF908BF3FFC0B9FEFFA19AF9FFFEFE
      FEFFFEFEFEFFFEFEFEFFFFFFFFFFB3A59DFFC2B9B3FFFFFFFFFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFFFFFFFFF4F4F4FFD3D3D3FF524B46B70000000000000000000000000000
      0000000000000000000000000000020230882C2CB8FF2C2CB6FF2A2AB3FF2828
      B1FF0101318D0000000000000000000000000000000000000000000000000101
      017D3C3C3CFF3A3A3AFF373737FF343434FF0202028400000000000000000000
      0000000000000000000000000000000000002A2A2A80DCDBDBFFF0EFEEFFF0EF
      EFFFEEEEEDFFF0EFEEFFF1F1F0FFEDECECFFA6A4A4FFF5E1D8FFFDF0E4FFFCFC
      F0FFFCFCF1FFFBFBEEFFFAFAF0FFFAFAF0FFF8F8EDFFF7F7EAFFF6F5E3FFF5EF
      D6FFF3D7BFFFEFCCBCFFBFBEBCFFA7A6A5FFCBCBCBFFD5D5D6FF818282FFB1B1
      B1FFCFCFCFFFC9C9C9FF6F6F6FC6000000000000000002020245B6B3B1FFBFBD
      BBFFCECECEFF636260FF777774FF5D5957FF5A5652FFA3A19FFFE0DEDEFFE6E7
      E6FFC9CACAFF989899FF8C8C8CFF878788FF878788FF89888BFF8F8F92FFB9B9
      BBFFDEDDDEFFE2E1E0FFB5B2B1FF716C6AFF4A4542FF797774FF696968FFA9A8
      A9FFD6D3D2FFB8B7B3FF1515158000000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFEBEBEBFFC2C2C2FFC4C4C4FF9C99F6FF9C98F2FF9B95F6FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB3A69DFFC2B9B2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      000000000000000000000000000001012D832D2DB9FF2E2EB7FF2C2CB5FF2929
      B3FF01012B840000000000000000000000000000000000000000000000000101
      017D3F3F3FFF3E3E3EFF393939FF363636FF0202028400000000000000000000
      0000000000000000000000000000000000002A2A2A80DADBDCFFE9E6E2FFF0EC
      E8FFEFECE6FFEEEBE6FFECE9E4FFD6D3CDFFBBB8B8FFF5DBCDFFFAF9F6FFF9F8
      F6FFF7F6F4FFF5F3EBFFF4F2EAFFF4F1EBFFF3F1E9FFF3F0E8FFF2F0E5FFF2EF
      DCFFF0E1CBFFE9C6B3FFDFDBD8FF9D9C9BFFC3C3C3FFD1D1D1FF838383FFB2B2
      B2FFD2D2D2FFCCCCCCFF707070C600000000000000000101013FC4C2BFFFE3E1
      E2FF605F5EFF807B79FF807A78FF787473FFBFBEBEFFACACAEFF8C8B8BFF8180
      7EFF8B8988FF989897FFABAAA9FFB5B3B2FFB6B5B3FFB0AFAEFFA2A1A0FF9090
      8EFF858584FF858585FF9E9E9FFFBDBCBDFF8C8988FF65615EFF8E8987FF605E
      5DFFBCBCBBFFE4E1E0FF0F0F0E7800000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFF7F7F7FFFDFCFDFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB3A79EFFC2B9B3FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      000000000000000000000000000001012E842F2FBBFF2F2FB9FF2D2DB8FF2B2B
      B5FF01012D850000000000000000000000000000000000000000000000000101
      017D424242FF414141FF3E3E3EFF383838FF0202028400000000000000000000
      0000000000000000000000000000000000002B2B2B80E2EBF0FF9D6F4FFFA668
      3BFFAB6F3EFFAE7341FFB07443FF9C6A40FFB2A197FFDDB395FFF1E7DDFFEADD
      CCFFE5D3BFFFDAC1A3FFD5B999FFD3B89AFFD2B799FFD2B697FFD1B694FFCDB2
      8DFFC8A681FFBE9477FFD6CCC9FFAAA9A8FFD2D2D2FFCFCFCFFF848484FFB3B3
      B3FFD5D5D5FFCFCFCFFF707070C6000000000000000000000027B6B5B4F58586
      85FF76736FFFAEAAA9FFB3B2B3FF9C9E9FFF7E807EFF989793FFB9B8B6FFCAC8
      C5FFCECCC9FFCBCAC8FFCAC9C9FFCBCAC8FFCBCAC8FFCECCCAFFCECECBFFD2D1
      CFFFD0D1CEFFC5C4C2FFA7A7A4FF858585FF8F9090FFA7A7A8FFA7A3A2FF908D
      89FF686766FFDBDAD8FF0404045900000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB3A79EFFC2B9B3FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      000000000000000000000000000002022F843030BDFF3030BBFF2F2FB9FF2C2C
      B7FF01012E850000000000000000000000000000000000000000000000000101
      017D454545FF444444FF414141FF3D3D3DFF0202028400000000000000000000
      0000000000000000000000000000000000002C2C2C80EBF4FBFF885A37FF8648
      16FF894B17FF8D511BFF8E521CFF824D1FFFA28E80FFC59C7BFFEDE3DBFFDFCF
      BFFFC2A27EFFBF9D77FFB8936AFFB69169FFB28C69FFAA8566FFA37E62FF9C7A
      5DFF987353FF99705BFFC5BDBAFFAFAEAEFFD3D3D3FFD1D1D1FF848484FFB4B4
      B4FFD8D8D8FFD2D2D2FF717171C600000000000000000000002BA7A6A6F8726F
      6CFFAAA8A4FFBBB9BCFF727272FF979592FFBDBCBBFFBBB9B8FFB7B6B3FFB8B9
      B7FFBBB9B8FFBCBCB9FFBEBDBBFFBFBDBCFFBFBEBCFFBFBEBCFFBFBEBCFFBEBD
      BCFFBDBCB9FFBDBCBCFFC0C0BEFFC8C6C4FFACABA8FF777877FF9B9B9CFFC0BD
      BEFF7B7876FFAFAEACFF0707075E00000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFBFBFBFFC1C1C2FFD0D0D0FFDBDCDCFFCECDCCFFDBBA99FFEDD6BFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB3A79EFFC2B9B3FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      000000000000000000000000000002022F843232BFFF3232BDFF3030BBFF2E2E
      BAFF01012E840000000000000000000000000000000000000000000000000202
      027D484848FF474747FF444444FF3F3F3FFF0202028400000000000000000000
      0000000000000000000000000000000000002C2C2C80EFF8FFFF815236FF956C
      50FFB49075FF8F5423FF89501DFF7E4A1BFF9C8D82FFAD805AFFF0E9E2FFBB99
      79FFC1A086FFC8AB94FFAE835DFFA57651FFA17350FF9C6F4EFF94694BFF8D64
      46FF855A3EFF845D4CFFB1ADACFFB1B0B0FFD4D4D4FFD4D4D4FF858585FFB5B5
      B5FFDADADAFFD5D5D5FF707070C6000000000000000002020240B2B1B0FFB2AE
      ACFFABACAEFF686965FFACAAA7FFB2B1AFFFAEACA9FFAFAEACFFB0B1AEFFB2B1
      B0FFB5B3B0FFB7B6B3FFB8B7B5FFB9B8B6FFB9B8B7FFB9B8B7FFB9B8B7FFB8B8
      B6FFB9B8B5FFB7B7B2FFB6B3B1FFB2B1B0FFB6B5B3FFBCBBB8FF7E807BFF8787
      87FFC4C3C0FFB1B0AEFF1313137B00000000514840BDD5D5D5FFF4F4F4FFFEFE
      FEFFEEEEEEFFBCBCBCFFFFFFFFFFF4F5F6FFE6DDD5FFDDAD7AFFE3BE97FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB4A89FFFC3BAB4FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      000000000000000000000000000002022F843434C1FF3434BFFF3232BDFF2F2F
      C3FF040441C60101007A00000011000000000000000000000000000000000202
      027D4A4A4AFF494949FF464646FF424242FF0202028400000000000000000000
      0000000000000000000A01010182000000552D2D2D80F3FBFFFF7C5135FFA681
      6CFFFFFFFFFFC19A76FF854A16FF8A511EFFA39385FF80542FFFB58E68FFC6AA
      90FFDAC6B6FFCBAF97FFB7906EFF9E683CFF9A643BFF955F39FF8B5835FF8051
      31FF774729FF6E4838FFABABABFFADACACFFD6D6D6FFD6D6D6FF868686FFB6B6
      B6FFDDDDDDFFD8D8D8FF6D6D6DC6000000000000000002020240C4C2BEFFD3D3
      D2FF5D5C5CFFA9A8A6FFA4A3A2FFA7A3A1FFA8A7A4FFA9A8A8FFABAAA9FFAEAC
      AAFFAFAEACFFB1B0AEFFB2B1AFFFB3B2B0FFB6B2B0FFB6B2B0FFB3B2B0FFB5B1
      AFFFB3B0B0FFB0AFACFFAFAEAEFFACABA9FFAEAAAAFFAAA9A9FFB8B7B2FF716D
      6DFFA4A3A4FFE3E1DEFF1010107A00000000514840BDD5D5D5FFF4F4F4FFFDFD
      FDFFFFFFFFFFC3C3C4FFFFFFFFFFF5F5F6FFE3D5C7FFE2BD94FFE7C5A1FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB6AAA1FFC5BCB6FFEEEEEEFFDDDDDDFFDBDB
      DCFFD9D9D9FFD9D8D9FFD8D8D9FFD7D7D7FFD5D5D6FFD5D4D5FFD4D4D4FFD1D4
      D4FFD6D6D7FFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000020230843535C3FF3535C1FF3333BFFF2E2E
      C4FF131367FF45453BFF0000003C000000000000000000000000000000000202
      027D4D4D4DFF4C4C4CFF494949FF454545FF0202028400000000000000000000
      00000000000000000036242424FF050505A22D2C2D80F2FAFFFF845935FFA274
      55FFFFFFFFFFC5A992FF8B5017FF90571FFF8D6742FF927D6BFF9B6C43FFF3ED
      E7FFE1D3C5FFD0B8A2FFC2A183FFA7774DFF935929FF8C5227FF824A24FF7440
      20FF693719FF56382DFFABABABFFBABABAFFD8D8D8FFD8D8D8FF858585FFB8B8
      B8FFE0E0E0FFDBDBDBFF6F6F6FC6000000000000000000000028BCBAB9F77777
      76FF92908EFFA09F9CFF9F9E9BFFA0A09CFFA4A39FFFA7A6A2FFA9A8A4FFA9A8
      A8FFACABA8FFAEACAAFFACAEACFFAEACACFFAEAFACFFAEAFACFFAEAFACFFAEAE
      ACFFACAEABFFAEACAAFFACA9A7FFAAA9A7FFA8A7A6FFA7A4A2FFA6A4A0FFA9A8
      A6FF646463FFD6D5D3FF0505055A00000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFC4C4C4FFFFFFFFFFFBFCFDFFE0B88EFFF0D6B6FFEAC9A6FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFB9ADA5FFC7BFB9FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000020230843636C5FF3636C3FF3535C1FF3030
      C6FF121268FF5C5C52FF0404048C000000000000000000000000000000000202
      027D505050FF4F4F4FFF4C4C4CFF474747FF0303038400000000000000000000
      00000000000002020291323232FF040404A02C2C2C80EDF5FDFF896036FF8A50
      12FF874A10FF955C21FF965E1FFF975F21FF955B21FFA18D79FF704E2BFFAE8E
      6DFFEBE1D9FFD9C6B4FFC8AB90FFBA936FFF9F693EFF894B1EFF7D411AFF7038
      16FF53280FFF837774FFBFC2C4FFC2C2C2FFE2E2E2FFE2E2E2FF8C8C8CFFC4C4
      C4FFE7E7E7FFE3E3E3FF757575C60000000000000000000000229A9A9AF37976
      75FFAAA9A6FFA2A19FFFA3A2A0FFA8A4A2FFA8A7A4FFAAA9A7FFACABA9FFAEAC
      ABFFAFAEACFFB0AFACFFB1B0AEFFB1B1AFFFB2B1AFFFB2B1AFFFB2B1AFFFB1B0
      AFFFB1AFAEFFAFAFACFFAFAEABFFACABAAFFABAAA8FFA9A8A7FFAAA7A6FFAEAC
      A9FF8C8B87FFA7A7A6FF0505055300000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFCCCCCCFFFAFAFAFFFBFCFDFFE2BD97FFFAE6CAFFEBCCA9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBDB2A9FFCAC2BCFFF2F2F2FFD6D6D6FFD4D4
      D7FFD5D4D5FFD3D3D3FFD3D3D3FFD2D2D2FFD0CFD0FFCFCFD0FFCECED0FFCDCD
      CEFFD1D1D1FFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000020231843939C7FF3838C5FF3636C3FF3131
      C8FF111168FF66665CFF3E3E3EF60000004E0000000200000000000000000202
      027D535353FF515151FF4F4F4FFF4A4A4AFF0303038300000000000000000000
      00040000005F232323F9363636FF040404A02B2B2B80E7EFF7FF8D6334FFA476
      45FFE3D5C6FFAA804BFFA26C23FFA36C25FFA26924FF9D6B30FFA49687FF6B4F
      2FFF956E45FFC5AB8FFFCDB299FFC2A082FFB18560FF965F36FF7A4119FF5A30
      17FF7E716BFF7D6D65FFD1D7DBFFC4C5C4FFE4E4E4FFE4E4E4FF8F8F8FFFC8C8
      C8FFEAEAEAFFE7E7E7FF777777C600000000000000000202023AAAA9A9FF9392
      91FFAEACA9FFAAA9A6FFABAAAAFFAEACAAFFAEACAAFFAFB0ACFFB1B0B0FFB5B3
      B0FFB6B5B1FFB7B6B3FFB7B5B5FFB8B7B3FFB8B7B6FFB8B7B6FFB8B7B6FFB8B7
      B5FFB7B6B2FFB8B3B3FFB5B2B2FFB3B2AFFFB2AFAEFFAFAEAEFFB0AFABFFAFAE
      ACFFACABA8FF9E9C9BFF1111117300000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFCDCDCDFFFCFCFCFFFDFEFFFFE4C19EFFFFF0D9FFEDD0AFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFBFB4ACFFCCC4BFFFF4F4F4FFF1F1F1FFF0F0
      F1FFF0F0F0FFEEEEEEFFEEEEEEFFEEEEEEFFEDECEDFFECECEDFFECECECFFECEC
      ECFFEDEDEDFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000020232843D3DC9FF3A3AC7FF3737C4FF3232
      CAFF121269FF69695FFF727272FF4C4C4CFE1D1D1DE1131313CB0F0F0FC31D1D
      1DE35A5A5AFF585858FF555555FF515151FF191919E40C0C0CC30E0E0ECB1515
      15E4343434FF404040FF393939FF050505A02B2B2B80DEE5F0FFA27E3DFFC29F
      63FFEDEAF0FFC1A161FFBD922EFFBA8E2FFFB5852EFFAD792AFFA1702FFFAB99
      82FF7B6E62FF5A3A1BFF72471FFF77491FFF6F411BFF5C3418FF5D4739FF9A8E
      89FF785138FF6A442DFFD4DADEFFC7C7C7FFE7E7E7FFE4E4E4FF939393FFCBCB
      CBFFEDEDEDFFE9E9E9FF787878C600000000000000000202023DACABAAFFA1A2
      9FFFB3B0AFFFB0B0AFFFB2B1AFFFB2B2B1FFB6B5B3FFB9B5B5FFB7B8B6FFB8B7
      B7FFB9B8B8FFBCBBB7FFBBBCB9FFBDBCBBFFBDBBBBFFBDBBBBFFBDBBBBFFBDBC
      B8FFBCB9B9FFBCBBB7FFBBB9B8FFB9B8B7FFB8B7B6FFB7B6B3FFB5B3B2FFB6B3
      B1FFB7B6B5FFA2A1A0FF1514147800000000514840BDD5D5D5FFF4F4F4FFFFFF
      FFFFFFFFFFFFCECECEFFFAFAF9FFFFFFFFFFE7C6A3FFF2DDC2FFEBCEADFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC1B6AEFFCDC5C0FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF4F4F4FFD5D5D5FF524B46B70000000000000000000000000000
      0000000000000000000000000000020232844040CBFF3F3FC9FF3A3AC7FF3434
      CCFF0D0D61F938382DF13D3D3DF23F3F3FF3414141F93F3F3FFC3F3F3FFE3A3A
      3AF8323232F1313131F22F2F2FF22D2D2DF1303030F7313131FE2E2E2EFC2C2C
      2CF9272727F3222222F2252525FF020202982A2A2A80D9DEEAFFA58847FFBDA1
      60FFC8C1C8FFBA9D5DFFC19C39FFC29B3BFFC0963AFFBA8E37FFB68935FFAD81
      33FFAB8853FFAB967CFF8F8070FF8C7D72FF8B7C6FFF9A8878FF9E7B60FF804A
      22FF773F17FF6C442CFFD6DDE1FFC9C9C9FFE9E9E9FFE7E7E7FF979797FFCFCF
      CFFFEFEFEFFFECECECFF787878C6000000000000000000000023A09E9DFAAAA9
      A8FFBDBCBBFFB9B8B7FFB8B7B7FFBCB8B7FFBDBCB8FFBEBDBCFFBFBEBDFFC0BD
      BCFFC2BEBDFFC0BFBFFFC0C2BEFFC3C2C0FFC3C0BFFFC3C0BFFFC3C0BFFFC3C2
      C0FFC0C2BEFFC2BFBDFFC0BEBDFFBEBDBCFFBDBCBBFFBCBBBBFFBCBDB9FFBDBC
      BBFFBEBCB9FFA6A4A3FF0707075800000000514840BDD8D8D8FFF2F2F2FFFFFF
      FFFFFFFFFFFFEFEFEFFFD0D0CFFFCECECEFFD2C4B7FFD2C0ADFFE8C9A9FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFC1B6AEFFCEC7C2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFEEEEEEFFD8D8D8FF524B46B70000000000000000000000000000
      0000000000000000000000000000020233844343CEFF4141CBFF3E3EC9FF3939
      CBFF020231920000000C0000001A0000001A0000001A0000001A0000001A0000
      001A0000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A0000001A0000001A0000001B0000001029292980D3D9E4FFA2864DFFB991
      3DFFC49C3BFFC7A241FFCBAA4BFFCCAC4CFFCCA94BFFC69F46FFBC9242FFB185
      3CFFAA7A39FFA67636FFA37237FF9A642DFF8F5420FF8C501EFF86491CFF7C42
      1AFF723916FF69422BFFD9E0E4FFC8C8C8FFE4E4E4FFE8E8E8FFA4A4A4FFD4D4
      D4FFF2F2F2FFF0F0F0FF7A7A7AC60000000000000000000000025F5D5DC6A3A2
      A3FFCCCBC9FFC3C2BFFFC0C2BFFFC4C3C2FFC3C4C3FFC6C5C4FFC6C6C3FFC8C6
      C5FFC6C8C6FFC8C6C5FFC8C6C5FFC8C6C8FFCAC9C6FFC8C9C6FFCAC9C6FFC8C6
      C8FFC8C6C5FFC9C6C6FFC6C5C6FFC8C6C5FFC6C5C4FFC5C4C3FFC5C5C3FFCCCB
      CAFFB3B3B3FF959593F30000001A00000000514940BDCACACAFFE5E5E5FFF3F3
      F3FFF3F3F3FFF4F3F3FFF4F4F3FFF5F4F4FFF5F5F5FFF6F6F5FFF6F6F6FFF7F6
      F6FFF7F7F6FFF8F7F7FFF9F9F9FFC0B5ADFFC6BEB9FFF3F3F3FFF3F3F2FFF4F3
      F3FFF4F4F3FFF4F4F4FFF5F4F4FFF5F5F5FFF6F6F6FFF7F6F6FFF7F7F7FFF8F7
      F7FFF9F9F9FFE5E5E5FFCACACAFF524B46B70000000000000000000000000000
      0000000000000000000000000000020233844545CFFF4545CEFF4141CBFF3D3D
      C8FF020234850000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000029292980CED2DDFFA99055FFC2AE
      88FF9F9185FFC3B088FFC0984BFFBD934BFFBC904AFFBA8E48FFB78A46FFB487
      46FFB08245FFAA7B43FFA87A43FFAB7B44FFA97640FF985F27FF90531BFF8D50
      1EFF83471AFF70482BFFDAE2E7FFA4A4A4EFA0A0A0E0A2A2A2E0909090E09999
      99E0A1A1A1E09F9F9FE1545454AF0000000000000000000000001414144D9E9B
      9CFFCAC9C6FFCFCECBFFCBCAC9FFCBCBCAFFCBCBCAFFCCCECBFFCECCCBFFD0CF
      CCFFCFCECCFFD1D0CFFFD1CFCEFFD0CFCEFFD0CFD0FFD0CFD0FFD0CFD0FFD0CF
      CEFFD1CFCEFFCFD0CFFFD0CECCFFCECFCEFFCFCECBFFCECCCBFFCFCFCBFFD8D8
      D8FF999897FF3B3A3A890000000000000000514940BDB0AEB0FFAFAFAFFFD6D4
      D3FFD6D4D3FFD7D6D5FFD9D7D6FFDAD9D8FFDEDCDBFFDFDEDDFFE1E0DFFFE2E1
      E0FFE4E3E2FFE6E4E3FFECECEBFFBDB3ABFFB5ADA7FFD6D4D4FFD5D3D2FFD7D5
      D4FFD8D7D6FFDAD9D8FFDCDAD9FFDDDCDBFFE0DFDEFFE2E1E0FFE4E2E1FFE5E4
      E3FFECEBEAFFD6D6D6FFB0AEB0FF524B46B70000000000000000000000000000
      0000000000000000000000000000020233844848D1FF4747CFFF4444CEFF4040
      CAFF020231850000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000028282880C7CBD5FFAB955EFFD9C7
      A4FFEDEAF3FFE0CEAAFFCEAE63FFCBAA63FFC8A35FFFC39C5AFFBE9858FFBC94
      57FFBB9257FFB78F54FFB48A52FFB28752FFB18351FFB28452FFA87444FF8C50
      1FFF814517FF70492AFFDDE4EAFF2B2B2B800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004544
      4494A0A09FFFE1E2E0FFD8DAD8FFD8D7D6FFD7D7D6FFD8D7D7FFD8D6D7FFDAD8
      D6FFDAD8D6FFD8DAD8FFDBDAD8FFDBDAD8FFDBDADAFFDBDADAFFDBDADAFFDBDA
      D8FFDBDAD8FFDADAD8FFDAD8D6FFD8D8D7FFDAD8D8FFDADAD8FFE7E6E4FFAFAF
      AEFF747372CA0000000B0000000000000000524A41BDC6BEB9FF8E8885FF918C
      89FF908B88FF908B88FF908B87FF848281FF908B87FF8F8A87FF908A86FF8F8A
      86FF8F8986FF8F8985FF8E8985FF9A8E87FF918882FF8B8582FF8D8683FF8D87
      83FF8E8884FF8E8985FF8F8986FF908A87FF858382FF938E8BFF938E8BFF938F
      8CFF948F8CFF938F8CFFC2B9B3FF534C46B700002D780C0C7CC40000021A0000
      0000000000000000000000000000020234844B4BD3FF4A4AD1FF4747CFFF4242
      CDFF020232850000000000000000000000000000000000000011050560BC0000
      2374000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000027272780C2C5CDFFB49F6BFFD5BA
      77FFD7C086FFDCC482FFDBBF7BFFD5BA79FFCFB070FFC8A365FFC29B5FFFC198
      5EFFC1975DFFC0955EFFBD935DFFBB905BFFB88C5AFFB78A59FFB88959FFB789
      5BFF9F673AFF6E4325FFDFE7ECFF2B2B2B800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00065E5E5EB1B1B2B0FFEDECEBFFE9E7E8FFE2E2E1FFE3E1E0FFE2E2E1FFE1E2
      E2FFE1E2E2FFE2E1E1FFE2E1E1FFE2E1E1FFE2E1E1FFE2E1E1FFE2E1E1FFE2E1
      E1FFE2E1E2FFE1E1E2FFE2E2E3FFE3E2E2FFE6E8E7FFF2F0F1FFC3C3C2FF8484
      82DB0303031F000000000000000000000000574E44C2E5D7CFFFDCCCC1FFD8C7
      BCFFD5C2B6FFD1BEB1FFCEBAACFFCAB6A8FFC7B2A3FFC4AE9EFFC1AA9AFFBEA6
      96FFBBA392FFB9A08FFFB79D8BFFB49A88FFB49A88FFB79D8BFFB9A08EFFBAA2
      91FFBCA594FFBFA898FFC1AB9CFFC4AFA0FFC6B1A3FFE2D9D0FFCFBFB2FFE1D6
      CDFFD2C0B4FFDED2C9FFCAB7A9FF58504ABC060654A15252DFFF0000114A0000
      0000000000000000000000000000020234844D4DD5FF4D4DD3FF4A4AD1FF4545
      CEFF020233850000000000000000000000000000000000000D472A2ABDFF0404
      419B000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000026262680C3C3C4FFABA8A3FFB0AC
      A5FFB3B0A8FFB5B2ABFFB8B5AEFFBAB8B2FFBCB9B3FFBEBBB6FFC0BCB7FFC1BE
      B8FFC1BFB7FFC2BEB6FFC2BDB5FFC1BCB4FFC1BAB3FFC0B9B2FFBFB7B0FFBEB7
      B0FFBDB8B1FFB3B0AEFFDEDFE0FF2B2B2B800000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000337373785B5B5B3FBE4E4E3FFFDFDFCFFF7F6F6FFF1F2F0FFF1EE
      EEFFF0EEEEFFF0F0EEFFF0F0EEFFF0F0EDFFF0F0EDFFF0F0EDFFF0F0EEFFF0F0
      EEFFF0F0EEFFF1F1F0FFF5F5F6FFFEFEFCFFF0EEF0FFC2C2C0FF585855AC0101
      0117000000000000000000000000000000001513116A332C259C312A249B312A
      249B312A249B312A249B312A249B312A239B312A239B3129239B3129239B3129
      239B3029239B3029239B3029239B3029229B3029229B3029239B3029239B3029
      239B3029239B3129239B3129239B3129239B312A239B312A249B312A249B312A
      249B312A249B312A249B322B259C14131168050553A06363E3FF0A0A5AA70000
      0000000000000000000000000000030335845050D6FF5050D5FF4C4CD3FF4747
      D0FF0202338500000000000000000000000000000000060653AD3434C2FF0303
      409A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001A1A1A6E797978D5878686D78A89
      89D78A8A8AD78D8B8BD78D8D8DD78E8E8ED78F8E8ED7908F90D7929292D79392
      93D7949393D7969496D7979797D7989898D79A9898D79B9B9AD79C9C9CD79D9D
      9DD7989898D7909090D7898989D51D1D1D6C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000090909345B5B5BADC8C8C8FBECECECFFFDFDFDFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFFEFEFEFFF2F2F2FFD6D6D6FF767675C614141450000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050554A06969E5FF5252E0FF0202
      398600000424000001190000000C03033F905353D8FF5252D6FF4F4FD5FF4B4B
      D2FF02023E920000000C0000011900000733020242992E2EC3FF3636C3FF0303
      419A000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050505293030307C7B7B7BC5C2C2
      C2F2E4E4E4FFEEEEEEFFF6F7F7FFFCFCFDFFFDFDFDFFF8F8F8FFF0F0F0FFE8E8
      E8FFD1D1D1F98E8E8DD3404040900B0B0B3C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000050555A06A6AE6FF7070E6FF6060
      E3FF4646DCFF3D3DD5FD3A3AD3FD3E3ED4FE5959DBFF5757D9FF5454D7FF5050
      D5FF3434CBFE2D2DC6FD2D2DC6FE3232C8FF3E3ECAFF3F3FC9FF3838C5FF0303
      439B000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01170B0B0B3B1B1B1B5D3A3A3A87525252A0525252A043434291222221670E0E
      0E44030303200000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000002E76111185C70F0F76BC1010
      75BC111176BE121278C0111178C0101074BE0D0D70BC0C0C6EBC0C0C6EBC0B0B
      6DBC0E0E6FBE0D0D70C00C0C6FC00B0B6BBE090968BC090966BC090970C60000
      2371000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000100000001000000020000000200000002000000010000
      0001000000000000000000000001000000010000000200000003000000020000
      0002000000010000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000110F0F0F8B383838CF555555EE6666
      66FC6B6B6BFE686868F85A5A5AEA484848D6333333BD1D1D1D9E090909790000
      004B000000130000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000010000000300000004000000060000000600000005000000030000
      0002000000020000000200000003000000050000000700000007000000070000
      0005000000030000000100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000001B484848D98B8B8BFF797979FFACACACFFB6B6
      B6FFBBBBBBFFC0C0C0FFC2C2C2FFC4C4C4FFC4C4C4FFC2C2C2FFC0C0C0FFAFAF
      AFFF828282FD323232BB0101014A000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FF545454B8555555B9545454B9555555B9555555B9555555B95555
      55B9555555B9555555B9555555B9555555B9555555B9555555B9555555B95555
      55B9555555B9555555B9555555B9555555B9555556BA575757BA555555B90000
      0001000000010000000100000001000000020000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000200000005000000080000000C0000000F0000000F0000000D000000090000
      00060000000500000005000000070000000B0000000E00000011000000100000
      000C000000080000000400000001000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000D4A4A4AD2A7A7A7FF929292FF8F8F8FFFA2A2A2FFCACA
      CAFFBDBDBDFF9E9E9EFF878787FF787878FF787878FF878787FF9E9E9EFFBDBD
      BDFFCACACAFFC3C3C3FFA9A9A9FF3E3E3EC90101014000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFF6F6F6FFF6F6F6FFF6F6F6FFF6F6F6FFF7F7F7FFF8F8F8FFF8F8
      F8FFF9F9F9FFFAFAFAFFFAFAFAFFFBFBFBFFFBFBFBFFFCFCFCFFFDFDFDFFFDFD
      FDFFFDFDFDFFFDFDFDFFFCFCFDFFF9F9FBFFF6F6F9FFF5F5F9FFAAAAADFF0000
      00050000000300000004000000070000000A0000000000000000000000000000
      0001000000010000000100000001000000010000000100000001000000030000
      00070000000C000000130000011A0000011D0000011D00000019000000130000
      000D000000090000000A0000000E000000150000011B0000011D0000011B0000
      00160000000F0000000800000003000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000002A2A2AA8ADADADFFB9B9B9FFA0A0A0FF7E7E7EFF7C7C7CFF4444
      44FF222222FF212121FF242424FF282828FF282828FF242424FF212121FF2222
      22FF444444FF8D8D8DFFC6C6C6FFC4C4C4FFA1A1A1FF252525AB0000001C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFEBEBEBFFECECECFFEBEBEBFFECECECFFECECECFFEDEDEDFFEDED
      EDFFEEEEEEFFEEEEEEFFEFEFEFFFF0F0F0FFEFEFEFFFF0F0F0FFF0F0F0FFF1F1
      F1FFF1F1F1FFEFEFF1FFE9E9EDFFE3E3E9FFDDDDE5FFDEDEE7FFA3A3AAFF0000
      000D000000090000000A00000011000000180000000100000002000000030000
      000C000000100000001100000011000000110000001000000011000000140000
      00180000001B000001220000022C0000044900000548000003340000011F0000
      00160000001000000014000001300000024000000492000005570000033B0000
      0122000000170000000E00000006000000010000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000A0A0A61AAAAAAFFBEBEBEFFCACACAFF949494FF323232FF212121FF2F2F
      2FFF2F2F2FFF252525FF1B1B1BFF161616FF161616FF1B1B1BFF252525FF3030
      30FF2F2F2FFF212121FF323232FF959595FFCACACAFFBEBEBEFF757575F10808
      0867000000010000000000000000000000000000000000000000000000000000
      0000B1B1B1FFECECECFFE1E1E0FFECECECFFEBEBECFFEDEDEDFFEAEAEBFFEBEB
      ECFFECECEDFFEDEDEEFFEDEDEEFFECECEEFFEBEBEDFFEAEAEDFFEBEBEEFFECEC
      EEFFECECEFFFE8E7ECFFDEDEE6FFD2D1DDFFBCBCCAFFA2A1B2FF908F9FFF0000
      011A00000012000000140000011F0000047C0000000600000007000000221A1B
      1CB72B2B2DC52B2B2DC52B2C2CC62B2C2CC62B2B2DC52B2B2DC52B2C2DC62B2C
      2DC70A0A0EA50000043D02010D5B000012B7020216B8020210600000022E0000
      01210000011F0202058A2C2E30D83B3C3EE028292AF402020D9800000BB20000
      0336000001210000001300000009000000030000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      001C878787F0C0C0C0FFC5C5C5FF5F5F5FFF1F1F1FFF2F2F2FFF262626FF1212
      12FF18181BFF26262CFF313238FF37373FFF36373EFF303138FF25262BFF1718
      1BFF121212FF272727FF303030FF1F1F1FFF5F5F5FFFC5C5C5FFC0C0C0FFA6A6
      A6FF292929B30000001200000000000000000000000000000000000000000000
      0000B1B1B1FFEDEDEDFFD5D5D4FFECECECFFC9C5F3FFEFDDCDFFE6D5C9FFE6D4
      C9FFE7D5C9FFE7D6CAFFE6D4C9FFE2D1C7FFDECDC5FFDCCBC5FFDDCCC5FFDFCE
      C5FFDFCEC6FFD7C7C2FFCABBBBFFB0A2ADFF595992FF2F2F4CFF7B7B99FF0000
      022A0000011E000001220000033400000AB90000000F000000110000013B2F30
      32DD58595BEA8F9191F6B7BBBBFEB9BDBDFEB9BDBDFEB8BBBBFE929595F76062
      63EE151519CF0000075D0F0F43B9020235E6030323C4050518740000043C0000
      022E0101047C37383AE1AFB2B2FCB9BDBDFE646667FA0C0C30DB020215A30000
      04430000022B0000011A0000000D000000050000000000000000000000000000
      0000000000000000000200000001000000030000000200000004000000050000
      0004000000060000000600000006000000070000000800000007000000070000
      0008000000070000000700000007000000050000000400000005000000030000
      0002000000010000000200000000000000000000000000000000000000003B3B
      3BAEBFBFBFFFC4C4C4FF4B4B4BFF232323FF2E2E2EFF131313FF1E1E22FF3939
      41FF3F4048FF42424AFF43444CFF44454CFF44444CFF42434BFF404149FF3E3E
      46FF37383FFF1C1D21FF131314FF303030FF232323FF4B4B4BFFC4C4C4FFBFBF
      BFFFAEAEAEFF4F4F4FDC00000025000000000000000000000000000000000000
      0000B1B1B1FFEDEDEDFFEDEDEDFFEDEDEDFFC7C7FAFFECECEDFFD6D6DFFFD5D5
      DEFFD7D7E0FFDADAE2FFD8D8E1FFD1D1DCFFC9C9D6FFC6C6D4FFC9C9D7FFCDCC
      DAFFCFCEDBFFC7C7D6FFB2B2C7FF61618EFF1A1A76FF404064FF6F6E92FF0000
      043A0000022D0000033300000548020212B40000011D00000120000002290000
      05660101078B090A0EC1696A6BF0BDC1C1FEB6BABAFD4B4C4DE807070BBA0101
      079301010A76000022B00A0A69ED00003FF0060621B10B0B258F000006490000
      066E232325D8A9ACADFBBCC0C0FEC0C4C4FF666869FA141441F7010124D50000
      064E000003340000012100000012000000090000000000000000000000000000
      000000000000000000020000000B000000110202021C040404240606062C0A0A
      0A370C0C0C3D0F0F0F441212124B1313134D1616165215151551151515511414
      144F1212124B101010470D0D0D3F0A0A0A380707072F040404250202021D0101
      01150000000C000000060000000200000000000000000000000007070746B5B5
      B5FFC9C9C9FF535353FF242424FF2A2A2AFF101011FF303138FF3E3F47FF4243
      4AFF46464EFF494950FF4B4B52FF4C4C53FF4B4B53FF4A4A51FF47474FFF4444
      4CFF404048FF3B3C44FF2E2F36FF101011FF2B2B2BFF242424FF535353FFC9C9
      C9FFBBBBBBFFAAAAAAFF5C5C5CE40000001A0000000000000000000000000000
      0000B1B1B1FFEEEEEEFFBEBEBEFFEDEDEDFFC8C8FAFFEAEAEBFFBDBDD1FFB6B6
      CFFFC2C2D1FFC5C5D3FFC1C1D0FFB3B3C5FF6464A6FF8585ABFF8989A0FFA8A8
      C1FFAFAFC1FFA8A8B9FF9090AEFF414198FF171778FF282861FF515188FF0000
      06480000043D000006660000096802021BAE00000330000003340000043D0000
      137409093BAA05051C961A1B1EE7B3B6B7FD848586F507070BBD000006530000
      075D0403116B121255CD050562E0020242E905053ED9151548C4000008711112
      15D096999AF7C3C7C7FFC3C7C7FFC3C7C7FF66686CF8080842F701012DE30000
      085B0000043E000002290000011A000000100000000000000000000000000000
      00000000000000000000000000040000000C0000001301010119020202200404
      042A06060632080808390B0B0B3F0D0D0D440E0E0E480F0F0F4A0E0E0E480D0D
      0D450C0C0C420909093B07070737060606320404042902020222010101190000
      0011000000060000000000000000000000000000000000000002666666D1C7C7
      C7FF7C7C7CFF212121FF2B2B2BFF101011FF34353DFF3E3E46FF43434BFF4747
      4FFF4B4B52FF4F4F56FF525258FF535359FF525259FF505056FF4D4D53FF4949
      50FF45454CFF404048FF3B3B44FF31323AFF0F1011FF2D2D2DFF212121FF7C7C
      7CFFAFAFAFFF787878FF858585FF262626960000000000000000000000000000
      0000B1B1B1FFEEEEEEFFEFEFEFFFEEEEEEFFC9C5F3FFE1D0C8FF302C78FF2421
      6AFF9B8FA0FF9A8E99FFA396A1FF675E68FF262371FF595272FF2C294CFF6D65
      8BFF60596AFF443F46FF3E3955FF786F8EFF393972FF1C1C6AFF505086FF0000
      07500000064A010112A2020217DB010114C80000064F0000064C000008640101
      21C9020241CD020217920E0E11FA9FA2A3FB626567F0010109D2000008BD0000
      03E0070620AB04041E8C02011DA2040438DE03034FE4121246C908080EC5787B
      7CF3C1C5C5FEC6CACAFFC6CACAFFC6CACAFF696A6CF9040534E6010127E30000
      09650000064900000335000002260000011C00000000303030A01A1A1A8E2222
      22B7000000AA000000AA000000AE000000B2090A08BA131312C0161616C41718
      17C61A1A19CC1A1B1ACB1D1D1CCB1E1E1ECC1F1F1DCD1E1F1ECC1F1F1ECC1E1E
      1DCD1D1D1CCC1C1C1CCD171816CF0E0F0ECD080707C8050402C5000000BD0000
      00B8000000AD0000007D0606064608080839000000000D0D0D56BEBEBEFFB6B6
      B6FF232323FF303030FF0F0F10FF303038FF3B3C44FF414149FF46464DFF4B4B
      52FF4F4F56FF535359FF57575DFF59595FFF57575DFF54545AFF515057FF4D4C
      53FF48484FFF43434BFF3E3E46FF383941FF2D2E35FF0F0F10FF313131FF2323
      23FF8F8F8FFF838383FF909090FF636363D40000000000000000000000000000
      0000B1B1B1FFEFEFEFFFE5E5E5FFEEEEEEFFC8C8FAFFE8E8EBFF68687AFF2F2F
      65FF77769EFF5B5B7BFF7373A2FF4E4E5FFF10104DFF2D2D67FF1F1F63FF6E6E
      8CFF9B9BB3FF605F80FF686893FF8B8BA3FF4A4A77FF33338AFF4E4E86FF0000
      075501000756050523AA0A0A3EF3010113AA020219B601010E6B01010A820101
      25E5000043EF04042AB00A0A13F79B9EA1FD56585AF001010B9801010C670000
      0BD8080829A201000B6F000010AB04042DB5020258E70F0F31EA646667F0C4C7
      C7FEC9CCCCFFC9CCCCFFC9CCCCFFC9CCCCFF696A6DF604041ACE030322C70100
      0A6D0100095C00000853000003380000022E2D2D2D8DFFFFFFFFFEFDFCFFFFFF
      FFFFFFFFFEFFFFFEFDFFFEFBFBFFFAF9F6FFF5F3F1FFF0EFECFFEFECEBFFEEEB
      EAFFEEEBEBFFECEBE8FFEBEAE8FFEBEAE7FFEBEAE7FFEBEAE7FFEBEAE9FFEBEA
      E9FFEDECE9FFEDECE9FFF0EDECFFF4F1F0FFF7F5F4FFF8F7F7FFFBFBF8FFFDFC
      F9FFFFFEFDFFFFFFFFFFF7F7F7FF36353598000000005E5E5EC7C8C8C8FF6363
      63FF272727FF1B1B1BFF202127FF373840FF3D3E45FF43434AFF48484FFF4D4C
      53FF515157FF55545AFF58575DFF59595EFF59585EFF56565BFF535258FF4F4E
      55FF4A4A51FF45454CFF404048FF3A3B43FF35353EFF1F1F25FF1C1C1CFF2727
      27FF5D5D5DFFA6A6A6FFAAAAAAFF8B8B8BF10000000000000000000000000000
      0000B1B1B1FFEFEFEFFFD8D8D7FFEFEFEFFFC8C8FAFFEAEAECFF9F9DB1FF1B1B
      3BFF67678EFF30305BFF626293FF5E5E79FF1D1C48FF353570FF505083FF8282
      98FF9998B0FF5E5E82FF43438EFF9291A9FF4F4F7AFF504F99FF4D4D89FF0100
      085901000858070729A809093FD601011DC105052DCD0606269B01010C8E0202
      25E2000015FB03033CE5090919F5989B9DFC535557ED01010A8F01011C8E0000
      17D30404289701010A6B00000D980404229D05052BD8434451F8C5C9C9FECCCF
      CFFFCCCFCFFFCCCFCFFFC7CBCCFFCACECEFF6A6D70F603021CEE040429CF0100
      0C78030211750403228E0000075C00000544484848B0FEFEFEFFF7F2F5FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFBFEFFF1F1F1FF2C2C2C8E0000001AB6B6B6FFC1C1C1FF2525
      25FF2E2E2EFF0F0F10FF32333BFF383941FF3E3E46FF43434AFF48484FFF4D4D
      53FF525157FF55545AFF57565CFF58575CFF57565CFF56555BFF535358FF504F
      55FF4B4B51FF46464DFF414148FF3B3B43FF35363EFF2F3039FF0E0F10FF3030
      30FF252525FFC1C1C1FFBCBCBCFFA4A4A4FD0000000000000000000000000000
      0000B1B1B1FFEFEFEFFFEFEFEFFFEFEFEFFFC9C5F3FFEAD8CBFF9E939AFF1110
      1CFF4C4668FF1B1958FF524D92FF595281FF1C1A56FF4D489CFF615BABFF9489
      9CFFA397A6FF7971AFFF6A65B7FF948AA1FF67679BFF7070C6FF4A4AA4FF0101
      0E6A01010C5F0A0A45AF0F0F50BC060639C10B0B51DB0B0B2BA801010E8C0202
      33C000000EDC070732BB090920EE979A9CFA545557EC0101098D010113950100
      1FAE020240BA01000A6700000C96030323B5252632F0B4B7BAFECED1D1FECFD2
      D2FFCFD2D2FFCCCFCFFF77797DFAA6A9ABFC6D6F72F8020213F6040426B30101
      0D8307071C8C0E0E34AC000008C6000009613C3C3CA5FAFAFAFF767270FF4D4F
      4CFF53524FFF595B5AFF4D544EFF5D5C5BFF5C5C5AFF545453FF646463FF5252
      54FF6C6E6AFF616363FF636361FF646463FF60605EFF5E6061FF5E5D5CFF575D
      5AFF585756FF5D605CFF4E484CFF616864FF525251FF575756FF555854FF5150
      54FF343637FF8B8C89FFECECECFF2120207B0F0F0F52C2C2C2FF949494FF2121
      21FF222222FF1B1C21FF32333BFF383840FF3E3E45FF43434AFF48484EFF4D4C
      52FF515056FF515056FF47454BFF3D3B41FF3D3B41FF46454BFF504F54FF4F4F
      54FF4B4A51FF46464CFF414148FF3B3B43FF35363EFF31313AFF1B1C21FF2323
      23FF212121FF949494FFC2C2C2FFADADADFF0000000000000000000000000000
      0000B1B1B1FFF0F0F0FFC0C0C0FFF0F0F0FFC9C9FBFFEBEBEDFFAFAFC8FF4444
      83FF2D2CB4FF4241B0FF5F5FE2FF6665B5FF6565B3FF6D6DD7FF7878E3FFABAA
      CAFFB4B3CFFF8181E1FF9695E0FF9C9CC1FF5755A1FF7575E3FF4E4EA2FF0101
      167A01011065171765B320207AC215145FC8040475F70F0E2EAE01010F8F0000
      54DB000005ED07073AC90A0A2DF1999C9DF9555659EC0101098801010A5F0202
      2291131344A001010E620201199A100F1CDDB5B8B9FCD2D5D5FFD2D5D5FFD2D5
      D5FFD2D5D5FF929497FA0E0F1DEC909196FB6F7073F802020AF6030321AA0000
      0BAD040434B40B0B46C5000008E2030312913535359BF6F6F6FF8F9295FFFFFF
      FFFFCED2D4FFFFFFFFFFEEEAEEFFFFFFFFFFFFFFFFFFEAE9EAFFFFFFFFFFDEDB
      DDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFB8BFBEFFFFFFFFFFFBFBFBFFFFFFFFFFFFFFFFFFCFD3
      CEFFFFFFFFFFA1A1A4FFE7E7E7FF151515622828287FC6C6C6FF686868FF2929
      29FF121212FF292A32FF32333BFF37373FFF3D3D44FF424249FF47474DFF4C4B
      51FF4C4B51FF39373DFF302E34FF343239FF343239FF302E34FF39373DFF4B4A
      4FFF4A494FFF45454BFF404047FF3A3A42FF35363EFF32323BFF292A32FF1212
      12FF2A2A2AFF686868FFC6C6C6FFABABABFA0000000000000000000000000000
      0000B1B1B1FFF1F1F1FFF1F1F1FFF0F0F0FFC8C8FBFFECECEEFFB9B9D1FF5757
      8AFF4B4AABFF3D3CACFF4F4FCCFF5858B8FF8D8CBEFF9593D2FF6F6FE4FFB8B8
      D3FFBFBFD6FFA8A7E0FF9191E1FFA09FC2FF3D3D8EFF6D6DEAFF3C3CA7FF0202
      1A850202136B212169BC3939AAE41D1D5EBF4B4BDDF63535A1D9040429993434
      AFE7020226A0151563B51E1E50F39C9DA0F956575AEB02010B820303287B3030
      B4DF24244D9F02010F690A0A16D68B8D91F7D2D5D6FFD5D8D8FFD5D8D8FFD3D6
      D6FEBDC0C0FB1D1D2FE910103FE295969BFB707178F805042FEC050451B00302
      289F3232AADD4545D1EE02022DBF191993E338383891F1F1F1FF858581FF9A9A
      9AFF828181FFA6A8A6FF626662FF9C989CFF858A85FF777777FFA7A5A7FF6465
      64FFA19FA1FF949294FF8F8F8FFF9CA19DFF8D8A8AFF9E9D9EFF949893FF9191
      91FF9F9D9FFFA2A7A3FF767373FF969696FF727672FF949894FF858285FFABAB
      ABFF969596FFA2A49FFFD7D6D6FF0E0E0E4B474747A4C9C9C9FF494949FF2D2D
      2DFF0E0E0FFF2F3039FF33333CFF36373EFF3B3B42FF404047FF45444BFF4948
      4EFF3E3C42FF302F35FF3B3940FF424048FF424048FF3B3940FF302F35FF3D3C
      42FF48474DFF444349FF3E3E45FF3A3A41FF36373EFF33333CFF2F3039FF0E0E
      0FFF2E2E2EFF494949FFC9C9C9FF9E9E9EEE0000000000000000000000000000
      0000B1B1B1FFF1F1F1FFE7E7E6FFF1F1F1FFC9C5F3FFECDACCFFC3B3BAFF645D
      80FF5B56B6FF4440BBFF4743B8FF4D48B9FF968CB0FF9B92C3FF9089D2FFC2B3
      BAFFC5B6BBFF9E94D1FF807ADBFFA295ACFF45458EFF7171E6FF3939A2FF0202
      1A7E020215701F1F7DCD161656B6101046AD171660B330309ED5040428953131
      73C202021777121249A3313160FC9D9FA2F956575BE901010A7C02020E524D4D
      99CC24244A9D040410AD5F6165F4D5D8D9FFD8DBDBFFD8DBDBFFD8DBDBFFCACD
      CDFD303136E5151543BF0A0A3ED197999FFC74767FFC04041CCA101059B20404
      35B126267BC32A2A99D3050542BD3A3A8FD22E2E2E87EEEEEEFFA8A9A8FFFBF9
      FBFFFFFFFFFFFFFFFFFFC6C5C6FFFFFFFFFFE5E2E5FFF6F6F6FFFFFFFFFFDADA
      DAFFFFFFFFFFD8DCD8FFF6F5F6FFFFFFFFFFC0C0C0FFFFFFFFFFD6D3D6FFF3F1
      F3FFFFFFFFFFB3B3B3FFFFFFFFFFDDE2DDFFF9F7F9FFFFFFFFFFBEBEBEFFFFFF
      FFFFFFFFFFFFCACACCFFCACACAFF07070734666666C3CBCBCBFF3A3A3AFF2D2D
      2DFF0F1011FF2F3039FF33343CFF37373FFF3A3A42FF3E3D44FF424047FF4341
      48FF343238FF36343BFF444149FF504C56FF4F4C56FF444149FF36343BFF3432
      38FF434147FF414047FF3E3D44FF3A3A42FF37373FFF33343CFF2F3039FF0F10
      11FF2E2E2EFF393939FFCBCBCBFF898989DC0000000000000000000000000000
      0000B1B1B1FFF2F2F2FFDDDDDDFFF1F1F1FFC9C9FBFFEFEFF0FFD0D0DEFFBDBC
      D2FF6D6DD9FF7C7BC4FF5959BCFF8080D6FFB7B7D1FF9B9AD8FFC3C3E4FFD8D7
      E5FFDBDAE7FFC0C0E6FFABABE0FFB8B8D2FF4C4B8CFF6363D3FF3B3B96FF0202
      24960E0E35901A1A81D30303219102011C7E0E0E50AC0B0B62B8040447BA1F1F
      64B2020112690F0F2A84353562FE9FA0A3F857585BE80100087602010A485757
      A1D11D1D49C7404046E7D4D5D6FEDCDEDEFFDCDEDEFFDCDEDEFFD4D6D6FE4F50
      56ED030313AA1919449D0F0F57F09B9CA4FD74757BF805041AC024247FCE0403
      4CC627277DCA272791DB06052C930A0A369724242479E9E9E9FFAFAFABFF9899
      98FFC7C6C7FF8C918CFFA19EA1FF939693FFA7ABA7FF9B9A9BFF979B97FFABAB
      ABFF979797FFA9A9A9FF9FA19FFF8F8F8FFFB1B1B1FF8F938FFFAAA9AAFFA1A5
      A1FF8F938FFFB4B3B4FF8E8E8EFFA3A0A3FFA4A8A4FF8C908CFFA6A6A6FF9B9B
      9BFF8C8C8DFFCBCBC9FFC7C7C6FF03030325848484DCCBCBCBFF383838FF2D2D
      2DFF101012FF303039FF33343CFF37373FFF3A3941FF3D3B43FF403D44FF403C
      44FF333137FF37363CFF4E4B53FF636069FF636069FF4E4B53FF37363CFF3331
      37FF403D45FF403E45FF3D3C43FF3B3A41FF37373FFF33343CFF303039FF1010
      12FF2E2E2EFF383838FFCBCBCBFF6C6C6CC30000000000000000000000000000
      0000B1B1B1FFF2F2F2FFF2F2F2FFF2F2F2FFC9C9FCFFF1F1F2FFDDDDE7FFD5D4
      E1FFADADDCFF9C9CD7FF8585BBFF807EB1FFC9C9DAFFBFBFDBFFD7D7E6FFE7E7
      EEFFE8E8EFFFDDDDEBFFCECEE5FFCACADDFF5A5A8FFF7170CCFF56569EFF0505
      50D61717489D06051C730101149D000006430B0A4AA80E0E62BD04046ACD0E0E
      4D9F01010D580E0D267C3A3A5BFAA1A3A4F758595BE70100066E010108405454
      ABF62F2F40EFC4C7C8FBDEE1E1FFDEE1E1FFDEE1E1FFDDE0E0FF7A7B80F60706
      14C702011474161655A70C0C50F097999FFA73757CF704041DCE303089DA0606
      75D62121A8E5161691E1353589C7050543BD1B1B1B69E5E5E5FFD1D1D4FFC1C5
      C5FFFFFFFFFFBFBDC0FFF8F8F8FFBCBDBCFFFEFBFEFFD4D4D4FFD3D2D3FFFBFB
      FBFFC7CAC7FFF8FBF8FFE6E3E6FFC5C6C5FFFFFFFFFFC6C6C6FFF7F7F7FFF5F3
      F5FFBEBDBEFFFFFFFFFFB9B9B9FFEAEAEAFFEDEBEDFFBDBABDFFFFFFFFFFADAD
      ADFFFAFAFBFFEBE7E7FFC0BFBFFF010101149A9A9AEECACACAFF444444FF2D2D
      2DFF0E0E0FFF2F3039FF33333CFF36353DFF39373FFF3B3841FF3E3A42FF3F3B
      42FF36333AFF36353BFF56545AFF6C6A71FF6C6A71FF56545AFF36353BFF3634
      3AFF403C43FF3F3B43FF3C3A42FF393840FF36363EFF33333CFF2F3039FF0E0E
      0FFF2D2D2DFF444444FFCACACAFF4C4C4CA40000000000000000000000000000
      0000B1B1B1FFF3F3F3FFC0C0BFFFF3F3F3FFC9C5F3FFEFDDCEFFE3D2C8FFE0CF
      C7FFD1C2C4FFB9ACC7FFCDBEBEFFB1A4ABFFD4C4C0FFE0CFC7FFE5D4C9FFE7D6
      CAFFE8D7CAFFE7D5C9FFE1D0C7FFD5C5C2FFC0C0D4FFA09FD6FF5353BFFF0606
      57C204041A680000063C000003310000022303032E930B0B56B60D0D76C30202
      125F01000846080821751B1C32D9A0A2A4F559595CE600000466000005471F1F
      3CEAA8AAAEFAE1E4E4FFE1E4E4FFE1E4E4FFE0E3E3FFA8A9ADFB0E0F25E90202
      1682030318721E1E88C606063EED949699F675767AF6040311AB1D1D4B9F0D0D
      69C4101083D303031F80202050A6020236D811111154E0E0E0FFC4C4C0FFA4A4
      A4FFFCFCFCFF7E7D7EFFBABEBAFFA1A3A1FF9D9D9DFFBEBDBEFF8A8E8AFFBDBA
      BDFF9B9F9BFF9E9B9EFFC2C3C2FF898789FFBDBDBDFFA09FA0FF9B9F9BFFC3C3
      C3FF8E8F8EFFB3B1B3FFA7ABA7FF9A9E9AFFC9C6C9FF8F938FFFA8A5A8FFC2C2
      C2FF696D69FFFFFFFEFFBBBBBAFF00000004A9A9A9FAC7C7C7FF5F5F5FFF2A2A
      2AFF101010FF2C2C35FF32323AFF35333CFF37353EFF39363FFF3B3740FF3C38
      40FF3A363DFF323137FF3D3C41FF4E4C52FF4E4C52FF3D3C41FF333137FF3B37
      3EFF3E3A42FF3C3941FF3A3840FF38363FFF35353DFF32333BFF2B2C35FF1010
      10FF2B2B2BFF5F5F5FFFC7C7C7FF2E2E2E7F0000000000000000000000000000
      0000B1B1B1FFF3F3F3FFF4F4F4FFF3F3F3FFC9C9FCFFF3F3F3FFEFEFF2FFEEEE
      F1FFEBEAEFFFE8E8EEFFE8E8EEFFEAEAEFFFEEEDF2FFF1F1F4FFF6F6F8FFF7F7
      F8FFF8F8F9FFF7F7F9FFF5F5F8FFEFEFF4FFE3E3EEFFD6D6E6FF5858C1FF0A09
      4BA30101136700000227000001190000001102022A8E0404369A0403125B0101
      0949000004340101125B0A0A1FC9A2A4A5F4595A5BE40000036B060609A48D8F
      91F2E2E4E4FEE5E7E7FFE5E7E7FFE5E7E7FFBDBFC4FE1D1E2AE503033CC20505
      31A62B2B7BBD2A2A73B9020225DA98999CF7737477F003030C9C10102D7C0505
      16610505166401010C59020229B8010116A40909093EDDDDDDFFDADADAFF9595
      95FFFFFFFFFF959695FFF0EEF0FFC4C3C4FFC6C3C6FFEBEEEBFFABAEABFFE6E5
      E6FFC5C3C5FFC4C8C4FFEEEDEEFFA5AAA5FFE4E4E4FFC4C4C4FFC7C4C7FFF1F1
      F1FFAAAAAAFFE0E0E0FFD0CFD0FFC3C2C3FFF0EEF0FFABAEABFFD0CFD0FFD9D9
      D9FFADACADFFFAFAFAFFB8B8B7FF00000000AEAEAEFFC3C3C3FF8A8A8AFF2222
      22FF1D1D1DFF1F1F25FF313039FF33313BFF35333CFF37343DFF38353DFF3935
      3DFF39353DFF363339FF323036FF323036FF323036FF333137FF38343BFF3B37
      3FFF3B373FFF3A363FFF38353EFF36343DFF34333CFF31313AFF1F1F25FF1D1D
      1DFF232323FF8A8A8AFFC3C3C3FF131313520000000000000000000000000000
      0000B1B1B1FFF4F4F4FFE1E1E0FFF4F4F4FFCACAFCFFF5F5F5FFF3F3F4FFF4F4
      F5FFF3F3F5FFF2F2F4FFF2F2F5FFF3F3F5FFF5F5F7FFF8F8F9FFF9F9F9FFFBFB
      FBFFFBFBFBFFFCFCFCFFFBFBFCFFF7F7F9FFF2F2F7FFE8E8F1FF8383AFFF0202
      0E4C00000640000000160000000D0000000701010D5601011167030225960000
      0960000002240000022B07060BB0A4A6A7F4595A5BE3030305A9616262E6E2E4
      E4FEE7EAEAFFE7EAEAFFE7EAEAFFE2E5E5FE3B3C4AF205051DA4050560D00C0B
      5CDA0F0E2F830201105B02020C9C9B9B9CF8747577EE02020890020212551717
      3A8403030F510000063E01000A5F01010A5603030327D7D8D8FFECEDE9FFCFCF
      D0FF9FA09FFFFDFDFDFFADAFADFFF9F9F9FFD3D3D3FFB6B6B6FFFAF9FAFFBDBC
      BDFFD9DED9FFF7F6F7FFA7A7A7FFFFFEFFFFBBBBBBFFD9D9D9FFEDEDEDFFA3A3
      A3FFF9F9F9FFBABABAFFCCCCCCFFF4F4F4FFA7A7A7FFFAFEFAFFC0BFC0FFFFFF
      FFFF929292FFF5F5F5FFA8A8A7F500000000A6A6A6FEBDBDBDFFB7B7B7FF2121
      21FF2C2C2CFF111113FF2F2E38FF323039FF34313AFF35323BFF36323BFF3633
      3BFF36333AFF353238FF323136FF302F34FF323035FF353238FF37343BFF3834
      3CFF38343DFF37343DFF36333CFF35323CFF32313AFF303039FF111114FF2D2D
      2DFF212121FFB7B7B7FFBBBBBBFE0202021A0000000000000000000000000000
      0000B1B1B1FFF4F4F4FFE8E8E8FFF4F4F4FFC9C5F3FFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFEFDDCDFFEFDDCDFFEFDDCDFFF0DECEFFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFF0DECEFFF0DECEFFEEDCCDFFF9F9FBFFF4F4F8FFA6A6ACFF0000
      0013000000100000000A00000005000000020000022900000223000003310000
      022B0000001600000017060607A7A7A8A8F4646565E7383838DBDBDDDDFCEBED
      EDFFEBEDEDFFEBEDEDFFE0E2E2FD59595CE706061AAC07072C800D0D9AE10504
      3AA0030318650000063F0201088B9A9B9CF2777879ED020205870100115B0000
      094100000223000002270000032E0000074801010118C2C2C1FFFFFFFFFF999A
      99FF9E9C9EFFCACCCAFF8C8C8BFFBDC1BDFFADAAADFF999999FFCCCCCCFF9696
      96FFB8B7B8FFB8B7B8FF8E928EFFCBCBCBFF919291FFB7B7B7FFBBBBBBFF8E8E
      8EFFCECECEFF989798FFB0B5B0FFC2BFC2FF8F908FFFCBC8CBFF919191FFEBEA
      EBFF808081FFF0F0F0FF828383DE00000000929292F1B2B2B2FF9C9C9CFF4646
      46FF2B2B2BFF141414FF23232AFF302E38FF322F39FF333039FF343139FF3431
      39FF343138FF333037FF312F36FF312F35FF323036FF343138FF353239FF3632
      3AFF36323BFF35323BFF34323BFF33313AFF303039FF24242BFF141414FF2D2D
      2DFF4F4F4FFFCACACAFF727272C6000000000000000000000000000000000000
      0000B1B1B1FFF5F5F5FFF5F5F4FFF5F5F5FFCACAFCFFF6F6F6FFF7F7F7FFF7F7
      F7FFF8F8F8FFF8F8F8FFF9F9F9FFFAFAFAFFFAFAFAFFFBFBFBFFFBFBFBFFFCFC
      FCFFFDFDFDFFFDFDFDFFFEFEFEFFFEFEFEFFFEFEFEFFFCFCFDFFADADAFFF0000
      0006000000060000000300000001000000000000001300000013000000120000
      000F0000000C00000011080809ADB0B1B1F4C5C6C6F8CDCECEF9EEEFEFFFEEEF
      EFFFEEEFEFFFE6E8E8FD727274EA0504099E00000434010123721818A7E20606
      37970101156A0000032F02020693A2A3A3F37E7E7FED0202048A000000120000
      001100000013000000170000011D000002250000000DBCBCBDFFFFFFFFFF6F6F
      70FFFFFFFFFF7C8081FFF1F5F5FFB9B6B8FFA1A4A1FFEDEEEDFF898B89FFE2E2
      E2FFC3C3C4FFAEAEAEFFF4F1F4FF8B908BFFDFDCDFFFCFCFCFFFAAAEAAFFF2F1
      F1FF919191FFC3C3C3FFD1D0D1FF919692FFF1F0F1FF9EA29EFFD1D0D1FFB9BD
      BCFFA6A6A2FFEBEBEBFF5A5A5ABA000000006D6D6DD48E8E8EFF9B9B9BFF6F6F
      6FFF202020FF2D2D2DFF0E0E0FFF2C2B35FF302E38FF312F38FF322F38FF332F
      38FF332F38FF322F37FF322F36FF322F36FF322F37FF333038FF343139FF3431
      39FF34313AFF33313AFF323039FF312F39FF2D2C35FF0E0E10FF2E2E2EFF2020
      20FFA6A6A6FFC1C1C1FF15151555000000000000000000000000000000000000
      0000B1B1B1FFF5F5F5FFC2C2C1FFF6F6F6FFCACAFCFFF7F7F7FFF7F7F7FFF8F8
      F8FFF8F8F8FFF9F9F9FFFAFAFAFFFAFAFAFFFBFBFBFFFBFBFBFFFCFCFCFFFDFD
      FDFFFDFDFDFFFEFEFEFFFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFB0B0B0FF0000
      0002000000010000000100000000000000000000000900000009000000080000
      00070000000500000022171717C6D2D4D4FAF0F2F2FFF0F2F2FFF0F2F2FFF0F2
      F2FFF0F2F2FFA4A5A5F20C0C0DB6000001300000011F010119631A1A61A70201
      0D4F00000E610000012507070AABB9BBBBF6969697F0050506A20000000E0000
      0008000000090000000C000000100000001500000002B8B8B7FFFEFEFEFFEDED
      EDFFFFFFFFFFE2E2DEFFDEDDDAFFF4F4F6FFE6E6E6FFFBFBFBFFEFEDEFFFFDFD
      FEFFF5F5F1FFE1E1E1FFF7F8F7FFFBF9FBFFF9FAF9FFEBE8EBFFE6E6E2FFFDFD
      FFFFF2F2F2FFFEFEFEFFF5F5F5FFF0EFECFFF2F3F3FFD8D4D4FFF8F8F9FFFFFF
      FFFFF4F1F0FFE6E6E6FF3131318A0000000037373796969696FF7C7C7CFFA6A6
      A6FF606060FF262626FF232323FF111114FF2E2C36FF302D37FF312E38FF312E
      38FF322F38FF322F37FF322F37FF322F37FF322F38FF332F38FF333039FF3330
      39FF323039FF322F39FF302F38FF2E2D37FF111114FF232323FF272727FF6060
      60FFCACACAFF7F7F7FD000000002000000000000000000000000000000000000
      0000B1B1B1FFF6F6F6FFF7F7F7FFF6F6F6FFC9C5F3FFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFFEFEFEFFFFFFFFFFB1B1B1FF0000
      0000000000000000000000000000000000000000000300000003000000030000
      00070000002503030392646464E5F0F1F1FEF4F5F5FFF4F5F5FFF4F5F5FFF1F2
      F2FEC9CACAF81A1A1AC4000000330000000C0000001300000221000003270000
      083F0000022D00000264272829D3E3E4E4FCD6D7D7FA1E1E1ECF000000500000
      000E0000000500000005000000070000000B00000000717171CBFBFBFBFFE1E1
      DFFFDADAD8FFFFFFFFFFD7D7D6FFF2F3F3FFFFFFFFFFFFFFFFFFF3F3F3FFECEC
      ECFFEFEFEFFFF4F4F4FFF8F8F9FFB9B9B9FFDDDDDDFFF8FBF8FFF1F1F2FFEEEE
      EEFFECEDEDFFF5F3F3FFFFFFFFFFFFFFFFFFE3E4E4FFE8E7E7FFFFFFFFFFCCC9
      CAFFFBFBFCFFE0E0E0FF1010104E000000000101011A828282E4ACACACFFBEBE
      BEFFC2C2C2FF3A3A3AFF2C2C2CFF1F1F1FFF111014FF2C2A34FF2F2D37FF302E
      37FF312E37FF312E38FF322E38FF322F38FF322F38FF322F38FF322F38FF312F
      38FF312F38FF302E38FF2C2B34FF111114FF1F1F1FFF2D2D2DFF3A3A3AFFC2C2
      C2FFBFBFBFFF0E0E0E4500000000000000000000000000000000000000000000
      0000B1B1B1FFF6F6F6FFE2E2E2FFF7F7F7FFCBCBFDFFF8F8F8FFF8F8F8FFF9F9
      F9FFFAFAFAFFFAFAFAFFFBFBFBFFFBFBFBFFFCFCFCFFFDFDFDFFFDFDFDFFFEFE
      FEFFFEFEFEFFFFFFFFFFFFFFFFFFFEFEFEFFFDFDFDFFFFFFFFFFB1B1B1FF0000
      0000000000000000000000000000000000000000000100000001000000130505
      06A41C1D1DCC848686EBF2F3F3FEF7F8F8FFF7F8F8FFF7F8F8FFF4F6F6FED9DA
      DAFA303131D50000004E00000003000000060000000A0000000D000000180202
      03880E0E0FBE353637DAC4C5C5F6F6F7F7FEF5F6F6FEB3B5B5F3262727D30A0A
      0AB8030303940000000F0000000300000005000000003A3A3A94F6F6F6FFFAFA
      FBFFF3F3F4FFFCFCFCFFFAFAFAFFF7F7F7FFF3F2F2FFD5D7D7FFD5D4D6FFD8D8
      D8FFDADADAFFD8D8D9FFD4D4D5FFEFEFEFFFDEDEE0FFD7D4D6FFD8D8D8FFD8D8
      D8FFD8D8D8FFD6D7D6FFD6D6D6FFFBFBFBFFF8F8F8FFF6F6F6FFFCFCFCFFF2F3
      F3FFF5F5F5FFE0E1E1FF04040428000000000000000004040425808080DCB1B1
      B1FFC2C2C2FFB6B6B6FF323232FF2C2C2CFF242424FF0E0E0FFF212027FF2E2D
      37FF2F2D37FF302D37FF302E38FF302E38FF312E38FF302E38FF302E38FF302E
      38FF2F2D37FF212027FF0E0E0FFF252525FF2E2E2EFF323232FFB6B6B6FFC2C2
      C2FF575757AD0000000000000000000000000000000000000000000000000000
      0000B1B1B1FFF7F7F7FFEBEBEBFFF7F7F7FFCACAFDFFF8F8F8FFF9F9F9FFFAFA
      FAFFFAFAFAFFFBFBFBFFFBFBFBFFFCFCFCFFFDFDFDFFFDFDFDFFFEFEFEFFFEFE
      FEFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFCFCFCFFFDFDFDFFB1B1B1FF0000
      00000000000000000000000000000000000000000000000000000000003BB3B4
      B4F3F0F1F1FDF8F9F9FEF9FAFAFFF9FAFAFFF9FAFAFFF9FAFAFFF4F5F5FE5C5C
      5CE20101017B00000003000000000000000100000003000000050000004C4F4F
      4FDEE4E5E5FBF5F6F6FEF8F9F9FEF9FAFAFFF9FAFAFFF8F9F9FEF0F1F1FDDEDF
      DFFA6A6A6AE50000002D00000000000000010000000001010118666565B57F7F
      7FCF777777C9787877CA777777CA767676C8808080D1878787D7888888D68787
      87D6878788D6878788D6868687D6888887D6878787D6878787D6878787D68787
      88D6878788D6878787D6878787D77E7F7FD0767676C8787777CA787877CA7878
      78C9868685D3504F4FA700000000000000000000000000000000010101125959
      59B2B4B4B4FFC3C3C3FFB7B7B7FF3E3E3EFF262626FF2F2F2FFF171717FF0F0F
      11FF1B1A20FF27272FFF2E2D37FF2E2D37FF2E2D37FF2E2D37FF28272FFF1B1B
      21FF0F0F11FF171717FF303030FF282828FF3E3E3EFFB7B7B7FFC3C3C3FFA2A2
      A2F00202021B0000000000000000000000000000000000000000000000000000
      0000B1B1B1FFF7F7F7FFF7F7F7FFF8F8F8FFC9C5F3FFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFF0DE
      CEFFF0DECEFFF0DECEFFF0DECEFFF0DECEFFFBFBFBFFFBFBFBFFB1B1B1FF0000
      0000000000000000000000000000000000000000000000000000000000130808
      08980A0A0A9F0B0B0BA10B0B0BA10B0B0BA10B0B0BA10A0A0A9F0909099D0000
      0064000000050000000000000000000000000000000100000002000000150303
      048A0A0A0B9F0B0B0BA10B0B0BA10B0B0BA10B0B0BA10B0B0BA10B0B0BA10A0A
      0A9F050505910000000D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00011F1F1F66A6A6A6F1C1C1C1FFC4C4C4FF6C6C6CFF232323FF2C2C2CFF2F2F
      2FFF222222FF131313FF0E0E0EFF0F0F10FF0F0F10FF0E0E0EFF131313FF2222
      22FF303030FF2D2D2DFF242424FF6C6C6CFFC4C4C4FFC1C1C1FFB4B4B4FF1B1B
      1B60000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFF8F8F8FFC8C8C7FFF8F8F8FFF8F8F9FFF9F9F9FFFAFAFAFFFBFB
      FBFFFBFBFBFFFCFCFCFFFDFDFDFFFDFDFDFFFEFEFEFFFEFEFEFFFFFFFFFFFFFF
      FFFFFEFEFEFFFEFEFEFFFCFCFCFFFBFBFBFFF9F9F9FFF8F8F8FFB1B1B1FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000010000
      0001000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000202021B565656AABEBEBEFFC8C8C8FFB1B1B1FF626262FF2828
      28FF252525FF2B2B2BFF303030FF313131FF313131FF303030FF2C2C2CFF2626
      26FF282828FF595959FF666666FF8F8F8FFFBDBDBDFFB1B1B1FF4C4C4CA70000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFF9F9F9FFFAFAFAFFF9F9F9FFFAFAFAFFFAFAFAFFFBFBFBFFFBFB
      FBFFFCFCFCFFFDFDFDFFFDFDFDFFFEFEFEFFFEFEFEFFFFFFFFFFFFFFFFFFFEFE
      FEFFFDFDFDFFFCFCFCFFFBFBFBFFF9F9F9FFF7F7F7FFF6F6F6FFB1B1B1FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000C0C0C3F797979C8C0C0C0FFC8C8C8FFC3C3
      C3FF9C9C9CFF757575FF595959FF4D4D4DFF4D4D4DFF595959FF757575FF9C9C
      9CFFC3C3C3FFB3B3B3FF909090FF828282FFABABABFF727272D10000000C0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFFFCFCFCFFB1B1B1FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000111111149686868BABCBC
      BCFCC0C0C0FFC4C4C4FFC7C7C7FFC9C9C9FFC9C9C9FFC7C7C7FFC4C4C4FFC0C0
      C0FFBBBBBBFFB3B3B3FF939393FF979797FF767676D80202021A000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1
      B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FFB1B1B1FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000101
      01131111114A2C2C2C784A4A4A9D6B6B6BBC898989D69F9F9FEAB1B1B1F8B5B5
      B5FEAFAFAFFC979797EE6F6F6FCE313131890000001000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000A00000000100010000000000000A00000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ColorDlgCoverflow: TColorDialog
    Left = 43
    Top = 555
  end
end
