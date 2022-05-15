object OptionsCompleteForm: TOptionsCompleteForm
  Left = 968
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 656
  ClientWidth = 689
  Color = clBtnFace
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 683
    Height = 618
    Align = alClient
    BevelEdges = []
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitWidth = 655
    object OptionsVST: TVirtualStringTree
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 203
      Height = 612
      Align = alLeft
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      BorderWidth = 1
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      Header.AutoSizeIndex = 0
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      Indent = 8
      ScrollBarOptions.ScrollBars = ssNone
      TabOrder = 0
      TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnBeforeItemErase = OptionsVSTBeforeItemErase
      OnFocusChanged = OptionsVSTFocusChanged
      OnGetText = OptionsVSTGetText
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Columns = <>
    end
    object PageControl1: TPageControl
      AlignWithMargins = True
      Left = 212
      Top = 3
      Width = 468
      Height = 612
      ActivePage = TabFiles4
      Align = alClient
      TabOrder = 1
      TabStop = False
      ExplicitLeft = 198
      ExplicitWidth = 454
      object TabSystem0: TTabSheet
        Caption = 'Sys (Main)'
        ImageIndex = 6
        object GrpBox_NempUpdater: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 238
          Width = 454
          Height = 134
          Align = alTop
          Caption = 'Nemp auto-updater'
          TabOrder = 2
          ExplicitWidth = 440
          object CB_AutoCheck: TCheckBox
            Left = 16
            Top = 17
            Width = 401
            Height = 17
            Hint = 
              'Check for updates and show a message if a newer version is avail' +
              'able'
            Caption = 'Automatically check for new versions of Nemp'
            TabOrder = 0
            OnClick = CB_AutoCheckClick
          end
          object Btn_CHeckNowForUpdates: TButton
            Left = 16
            Top = 93
            Width = 161
            Height = 25
            Caption = 'Check now'
            TabOrder = 3
            OnClick = Btn_CHeckNowForUpdatesClick
          end
          object CB_AutoCheckNotifyOnBetas: TCheckBox
            Left = 16
            Top = 68
            Width = 417
            Height = 17
            Hint = 
              'Notify on Beta-releases. As Beta-software is normally instable, ' +
              'this is recommended for advanced users only.'
            Caption = 'Notify on Beta-releases'
            TabOrder = 2
          end
          object CBBOX_UpdateInterval: TComboBox
            Left = 28
            Top = 40
            Width = 177
            Height = 21
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
        object GrpBox_StartingNemp: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 117
          Align = alTop
          Caption = 'Starting Nemp'
          TabOrder = 0
          ExplicitWidth = 440
          object CB_AllowMultipleInstances: TCheckBox
            Left = 16
            Top = 90
            Width = 409
            Height = 17
            Hint = 'Allow multiple instances of Nemp.'
            Caption = 'Allow multiple instances'
            TabOrder = 4
          end
          object CB_AutoPlayNewTitle: TCheckBox
            Left = 16
            Top = 52
            Width = 401
            Height = 17
            Hint = 
              'When starting Nemp by double-clicking a file in the Windows-Expl' +
              'orer: Use this file instead of the last one.'
            Caption = 'If applicable: Start playback with new file'
            TabOrder = 2
          end
          object CB_SavePositionInTrack: TCheckBox
            Left = 16
            Top = 36
            Width = 385
            Height = 17
            Hint = 'Begin playback at the last known position within the track'
            Caption = 'Remember last track position'
            TabOrder = 1
          end
          object CB_AutoPlayOnStart: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Automatically begin playback when Nemp starts'
            Caption = 'Begin playback on start'
            TabOrder = 0
            OnClick = CB_AutoPlayOnStartClick
          end
          object CB_AutoPlayEnqueueTitle: TCheckBox
            Left = 33
            Top = 69
            Width = 389
            Height = 17
            Hint = 
              'Stop playback of the current file, when the user double-clicks a' +
              ' new file in the Windows explorer'
            Caption = 
              'Switch to enqueued file (even if another track is already playin' +
              'g)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
          end
        end
        object GrpBox_StartingExtended: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 378
          Width = 454
          Height = 135
          Align = alTop
          Caption = 'Extended start settings'
          TabOrder = 3
          ExplicitWidth = 440
          DesignSize = (
            454
            135)
          object CBAutoLoadMediaList: TCheckBox
            Left = 16
            Top = 88
            Width = 409
            Height = 17
            Hint = 'Automatically load the Nemp medialibrary.'
            Caption = 'Load media library on start'
            TabOrder = 3
          end
          object CBAutoSaveMediaList: TCheckBox
            Left = 16
            Top = 104
            Width = 409
            Height = 17
            Hint = 'Automatically save the Nemp medialibrary.'
            Caption = 'Save media library on close'
            TabOrder = 4
          end
          object cb_ShowSplashScreen: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Caption = 'Show splash screen'
            TabOrder = 0
          end
          object CB_StartMinimized: TCheckBox
            Left = 16
            Top = 46
            Width = 430
            Height = 17
            Hint = 'Do not show Nemp window on start - directly minimize it.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Start minimized (you can also use the parameter "/minimized")'
            TabOrder = 1
            ExplicitWidth = 416
          end
          object cb_StayOnTop: TCheckBox
            Left = 16
            Top = 63
            Width = 409
            Height = 17
            Hint = 
              'Hold the Nemp main window in foreground. Works only in seperate-' +
              'window-mode.'
            Caption = 'Stay on top (not in compact view)'
            TabOrder = 2
          end
        end
        object GrpBoxPortable: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 126
          Width = 454
          Height = 106
          Align = alTop
          Caption = 'Nemp portable'
          TabOrder = 1
          ExplicitWidth = 440
          object lblNempPortable: TLabel
            Left = 16
            Top = 61
            Width = 420
            Height = 44
            AutoSize = False
            Caption = 
              'In most cases these two settings have no noticeable effect. Plea' +
              'se refer to the documentation for more information.'
            WordWrap = True
          end
          object cb_EnableUSBMode: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 
              'Nemp will try to adjust drive letters, when USB drives with your' +
              ' music are used at different computers.'
            Caption = 'Enable USB mode'
            TabOrder = 0
          end
          object cb_EnableCloudMode: TCheckBox
            Left = 16
            Top = 38
            Width = 401
            Height = 17
            Hint = 
              'Use relative paths in the library, if you use Nemp in a cloud dr' +
              'ive on different computers'
            Caption = 'Enable cloud mode'
            TabOrder = 1
          end
        end
      end
      object TabSystem1: TTabSheet
        Caption = 'Sys (Control)'
        ImageIndex = 5
        object GrpBox_Hotkeys: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 98
          Width = 454
          Height = 229
          Align = alTop
          Caption = 'Hotkeys configuration'
          TabOrder = 1
          ExplicitWidth = 440
          object CB_Activate_Play: TCheckBox
            Left = 34
            Top = 40
            Width = 97
            Height = 17
            Caption = 'Play/Pause'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = CB_Activate_PlayClick
          end
          object CB_Activate_Stop: TCheckBox
            Left = 34
            Top = 60
            Width = 97
            Height = 17
            Caption = 'Stop'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnClick = CB_Activate_StopClick
          end
          object CB_Activate_JumpBack: TCheckBox
            Left = 34
            Top = 140
            Width = 97
            Height = 17
            Caption = 'Slide backwards'
            Checked = True
            State = cbChecked
            TabOrder = 16
            OnClick = CB_Activate_JumpBackClick
          end
          object CB_Activate_Prev: TCheckBox
            Left = 34
            Top = 100
            Width = 97
            Height = 17
            Caption = 'Previous title'
            Checked = True
            State = cbChecked
            TabOrder = 10
            OnClick = CB_Activate_PrevClick
          end
          object CB_Activate_Next: TCheckBox
            Left = 34
            Top = 80
            Width = 97
            Height = 17
            Caption = 'Next title'
            Checked = True
            State = cbChecked
            TabOrder = 7
            OnClick = CB_Activate_NextClick
          end
          object CB_Activate_JumpForward: TCheckBox
            Left = 34
            Top = 120
            Width = 97
            Height = 17
            Caption = 'Slide forward'
            Checked = True
            State = cbChecked
            TabOrder = 13
            OnClick = CB_Activate_JumpForwardClick
          end
          object CB_Activate_IncVol: TCheckBox
            Left = 34
            Top = 160
            Width = 121
            Height = 17
            Caption = 'Increase volume'
            Checked = True
            State = cbChecked
            TabOrder = 19
            OnClick = CB_Activate_IncVolClick
          end
          object CB_Activate_DecVol: TCheckBox
            Left = 34
            Top = 180
            Width = 121
            Height = 17
            Caption = 'Decrease volume'
            Checked = True
            State = cbChecked
            TabOrder = 22
            OnClick = CB_Activate_DecVolClick
          end
          object CB_Activate_Mute: TCheckBox
            Left = 34
            Top = 200
            Width = 97
            Height = 17
            Caption = 'mute/unmute'
            Checked = True
            State = cbChecked
            TabOrder = 25
            OnClick = CB_Activate_MuteClick
          end
          object CBRegisterHotKeys: TCheckBox
            Left = 16
            Top = 20
            Width = 377
            Height = 17
            Hint = 
              'Install global hotkeys. You should use some values that are not ' +
              'used as shortcuts by your favorite software.'
            Caption = 'Install global hotkeys'
            TabOrder = 0
            OnClick = CBRegisterHotKeysClick
          end
          object CB_Mod_Play: TComboBox
            Left = 178
            Top = 40
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
          object CB_Key_Play: TComboBox
            Left = 290
            Top = 40
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
          object CB_Mod_Stop: TComboBox
            Left = 178
            Top = 60
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
          object CB_Key_Stop: TComboBox
            Left = 290
            Top = 60
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
          object CB_Mod_Next: TComboBox
            Left = 178
            Top = 80
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
          object CB_Key_Next: TComboBox
            Left = 290
            Top = 80
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
          object CB_Mod_Prev: TComboBox
            Left = 178
            Top = 100
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
          object CB_Key_Prev: TComboBox
            Left = 290
            Top = 100
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
          object CB_Mod_JumpForward: TComboBox
            Left = 178
            Top = 120
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
          object CB_Key_JumpForward: TComboBox
            Left = 290
            Top = 120
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
          object CB_Mod_JumpBack: TComboBox
            Left = 178
            Top = 140
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
          object CB_Key_JumpBack: TComboBox
            Left = 290
            Top = 140
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
          object CB_Mod_IncVol: TComboBox
            Left = 178
            Top = 160
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
          object CB_Key_IncVol: TComboBox
            Left = 290
            Top = 160
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
          object CB_Mod_DecVol: TComboBox
            Left = 178
            Top = 180
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
          object CB_Key_DecVol: TComboBox
            Left = 290
            Top = 180
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
          object CB_Mod_Mute: TComboBox
            Left = 178
            Top = 200
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
          object CB_Key_Mute: TComboBox
            Left = 290
            Top = 200
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
        end
        object GrpBox_MultimediaKeys: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 89
          Align = alTop
          Caption = 'Media keys and special keyboards'
          TabOrder = 0
          ExplicitWidth = 440
          object CB_IgnoreVolume: TCheckBox
            Left = 16
            Top = 40
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
            Top = 20
            Width = 413
            Height = 17
            Caption = 'Use media keys, even if Nemp is in the background'
            TabOrder = 0
          end
          object cb_UseG15Display: TCheckBox
            Left = 16
            Top = 60
            Width = 401
            Height = 17
            Caption = 
              'Use keyboard display (Logitech G15 keyboard or compatible requir' +
              'ed)'
            TabOrder = 2
          end
        end
        object GrpBox_TabulatorOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 333
          Width = 454
          Height = 65
          Align = alTop
          Caption = 'Tabulators'
          TabOrder = 2
          ExplicitWidth = 440
          object CB_TabStopAtPlayerControls: TCheckBox
            Left = 16
            Top = 20
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
      end
      object TabSystem2: TTabSheet
        Caption = 'Sys (Files)'
        ImageIndex = 6
        object GrpBox_FileFormats: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 203
          Align = alTop
          Caption = 'Filetypes'
          TabOrder = 0
          ExplicitWidth = 440
          object lbl_AudioFormats: TLabel
            Left = 16
            Top = 20
            Width = 49
            Height = 13
            Caption = 'Audio files'
          end
          object lbl_PlaylistFormats: TLabel
            Left = 312
            Top = 20
            Width = 73
            Height = 13
            Caption = 'Playlist formats'
          end
          object CBFileTypes: TCheckListBox
            Left = 16
            Top = 35
            Width = 290
            Height = 129
            Hint = 'List of supported audio files.'
            Columns = 4
            ItemHeight = 13
            TabOrder = 0
          end
          object CBPlaylistTypes: TCheckListBox
            Left = 312
            Top = 35
            Width = 113
            Height = 130
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
          object Btn_SelectAll: TButton
            Left = 16
            Top = 170
            Width = 145
            Height = 25
            Caption = 'Select all'
            TabOrder = 2
            OnClick = Btn_SelectAllClick
          end
        end
        object GrpBoxFileFormatOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 212
          Width = 454
          Height = 88
          Align = alTop
          Caption = 'Windows Explorer settings'
          TabOrder = 1
          ExplicitWidth = 440
          object CBEnqueueStandard: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'Add a file to the playlist when double-clicking it in the Window' +
              's-Explorer. Otherwise the current playlist will be deleted.'
            Caption = '"Enqueue" as default action for audio files'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object CBEnqueueStandardLists: TCheckBox
            Left = 16
            Top = 36
            Width = 409
            Height = 17
            Hint = 
              'Add the files of a playlist to the current playlist when double-' +
              'clicking it in the Windows-Explorer. Otherwise the current playl' +
              'ist will be deleted.'
            Caption = '"Enqueue" as default action for playlists'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object CBDirectorySupport: TCheckBox
            Left = 16
            Top = 60
            Width = 409
            Height = 17
            Hint = 
              'Add "Play/Enqueue in Nemp" to the context menu in the Windows Ex' +
              'plorer.'
            Caption = 'Context menus on directories'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
        end
        object PnlFileRegHints: TPanel
          AlignWithMargins = True
          Left = 3
          Top = 306
          Width = 454
          Height = 110
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 2
          ExplicitWidth = 440
          object Label3: TLabel
            Left = 16
            Top = 10
            Width = 29
            Height = 13
            Caption = 'Note:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 16
            Top = 29
            Width = 420
            Height = 41
            AutoSize = False
            Caption = 
              'You need to confirm changes on this page separately. This ensure' +
              's that your Windows-registry is not changed by an oversight.'
            WordWrap = True
          end
          object BtnRegistryUpdate: TButton
            Left = 16
            Top = 76
            Width = 170
            Height = 25
            Hint = 'Register Nemp as default application for the selected filetypes.'
            Caption = 'Apply changes'
            TabOrder = 0
            OnClick = BtnRegistryUpdateClick
          end
        end
      end
      object TabSystem3: TTabSheet
        Caption = 'Sys (System)'
        ImageIndex = 20
        object GrpBox_Deskband: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 217
          Width = 454
          Height = 163
          Align = alTop
          Caption = 'Notification of a deskband'
          TabOrder = 1
          ExplicitWidth = 440
          object CBShowDeskbandOnStart: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Caption = 'Show deskband on start'
            TabOrder = 0
          end
          object CBShowDeskbandOnMinimize: TCheckBox
            Left = 16
            Top = 36
            Width = 401
            Height = 17
            Caption = 'Show Deskband on minimize'
            TabOrder = 1
          end
          object CBHideDeskbandOnRestore: TCheckBox
            Left = 16
            Top = 52
            Width = 401
            Height = 17
            Caption = 'Hide deskband on restore'
            TabOrder = 2
          end
          object CBHideDeskbandOnClose: TCheckBox
            Left = 16
            Top = 68
            Width = 401
            Height = 17
            Caption = 'Hide deskband on close'
            TabOrder = 3
          end
          object Btn_InstallDeskband: TButton
            Left = 16
            Top = 92
            Width = 161
            Height = 25
            Hint = 'Install the Nemp Deskband.'
            Caption = 'Install deskband'
            TabOrder = 4
            OnClick = Btn_InstallDeskbandClick
          end
          object Btn_UninstallDeskband: TButton
            Left = 16
            Top = 124
            Width = 161
            Height = 25
            Hint = 'Uninstall the Nemp Deskband.'
            Caption = 'Uninstall deskband'
            TabOrder = 5
            OnClick = Btn_UninstallDeskbandClick
          end
        end
        object GrpBox_Hibernate: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 98
          Width = 454
          Height = 113
          Align = alTop
          Caption = 'Hibernate/standby'
          TabOrder = 2
          ExplicitWidth = 440
          object LBlConst_ReInitPlayerEngine_Hint: TLabel
            Left = 36
            Top = 52
            Width = 142
            Height = 13
            Hint = 
              'Use this, if the playback don'#39't work after hibernating the syste' +
              'm.'
            Caption = '(necessary on some systems)'
          end
          object cbPauseOnSuspend: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'Stop the player when the system hibernates, so the playback is s' +
              'topped when the PC is turned on again.'
            Caption = 'Stop player when system hibernates'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object cbReInitAfterSuspend: TCheckBox
            Left = 16
            Top = 36
            Width = 393
            Height = 17
            Hint = 
              'Use this, if the playback don'#39't work after hibernating the syste' +
              'm.'
            Caption = 'Reinitialize player engine on wakeup'
            TabOrder = 1
            WordWrap = True
          end
          object Btn_ReinitPlayerEngine: TButton
            Left = 36
            Top = 76
            Width = 197
            Height = 25
            Hint = 'Reinit player engine now.'
            Caption = 'Reinit player engine now'
            TabOrder = 2
            OnClick = Btn_ReinitPlayerEngineClick
          end
        end
        object GrpBox_TaskTray: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 89
          Align = alTop
          Caption = 'Taskbar and/or tray'
          TabOrder = 0
          ExplicitWidth = 440
          object LblTaskbarWin7: TLabel
            Left = 16
            Top = 51
            Width = 401
            Height = 32
            AutoSize = False
            Caption = 
              '(*) Not recommended under Windows7 or later: The buttons in the ' +
              'preview won'#39't work then.'
            WordWrap = True
          end
          object cb_TaskTray: TComboBox
            Left = 16
            Top = 24
            Width = 401
            Height = 21
            Hint = 'Behavior of Nemp in the Windows Taskbar'
            Style = csDropDownList
            ItemIndex = 3
            TabOrder = 0
            Text = 'Taskbar and trayicon'
            Items.Strings = (
              'Windows standard (taskbar only)'
              'Taskbar only, trayicon only when minimized (*)'
              'Trayicon only (*)'
              'Taskbar and trayicon'
              'Taskbar and trayicon, trayicon only when minimized (*)')
          end
        end
      end
      object TabPlaylistRandom: TTabSheet
        Caption = 'Random'
        ImageIndex = 21
        object GrpBox_BetaOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 355
          Width = 454
          Height = 45
          Align = alTop
          Caption = 'Beta-Settings'
          TabOrder = 0
          Visible = False
          ExplicitWidth = 440
          object XXX_CB_BetaDontUseThreadedUpdate: TCheckBox
            Left = 11
            Top = 25
            Width = 417
            Height = 17
            Hint = 'Beta-Settings. Do not change, unless you know what yo are doing!'
            Caption = 'Update library in Mainthread'
            TabOrder = 0
          end
        end
        object GrpBox_RandomOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 77
          Hint = 
            'Random playback: Correct "real randomness" by avoiding repetitio' +
            'ns of the same song.'
          Align = alTop
          Caption = 'Random playback'
          TabOrder = 1
          ExplicitWidth = 440
          object LblConst_ReallyRandom: TLabel
            Left = 12
            Top = 16
            Width = 153
            Height = 13
            AutoSize = False
            Caption = 'Really random'
          end
          object LblConst_AvoidRepetitions: TLabel
            Left = 248
            Top = 16
            Width = 162
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Avoid repetitions'
          end
          object TBRandomRepeat: TTrackBar
            Left = 8
            Top = 32
            Width = 409
            Height = 33
            Max = 75
            Frequency = 5
            Position = 25
            TabOrder = 0
          end
        end
        object grpBox_WeightedRandom: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 86
          Width = 454
          Height = 263
          Align = alTop
          Caption = 'Weighted randomness'
          TabOrder = 2
          ExplicitWidth = 440
          object lbl_WeightedRandom: TLabel
            Left = 34
            Top = 43
            Width = 170
            Height = 13
            Caption = 'Indivdual weights, based on rating.'
          end
          object RatingImage05: TImage
            Left = 34
            Top = 67
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage10: TImage
            Left = 34
            Top = 95
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage15: TImage
            Left = 34
            Top = 123
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage20: TImage
            Left = 34
            Top = 151
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage25: TImage
            Left = 34
            Top = 179
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage30: TImage
            Left = 224
            Top = 67
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage35: TImage
            Left = 224
            Top = 95
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage40: TImage
            Left = 224
            Top = 123
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage45: TImage
            Left = 224
            Top = 151
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object RatingImage50: TImage
            Left = 224
            Top = 179
            Width = 70
            Height = 14
            ParentShowHint = False
            ShowHint = False
            Transparent = True
          end
          object lblCount30: TLabel
            Left = 350
            Top = 67
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount35: TLabel
            Left = 350
            Top = 94
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount40: TLabel
            Left = 350
            Top = 123
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount45: TLabel
            Left = 350
            Top = 151
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount50: TLabel
            Left = 350
            Top = 178
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount05: TLabel
            Left = 159
            Top = 67
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount10: TLabel
            Left = 159
            Top = 94
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount15: TLabel
            Left = 159
            Top = 123
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount20: TLabel
            Left = 159
            Top = 151
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount25: TLabel
            Left = 159
            Top = 178
            Width = 38
            Height = 13
            Caption = '(99999)'
            Visible = False
          end
          object lblCount00: TLabel
            Left = 34
            Top = 204
            Width = 383
            Height = 13
            AutoSize = False
            Caption = '* Including 1000 unrated files'
            Visible = False
          end
          object cb_UseWeightedRNG: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Caption = 'Use weighted random'
            TabOrder = 0
            OnClick = cb_UseWeightedRNGClick
          end
          object RandomWeight05: TEdit
            Left = 110
            Top = 64
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 1
            Text = '0'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight10: TEdit
            Left = 110
            Top = 91
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 2
            Text = '0'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight15: TEdit
            Left = 110
            Top = 120
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 3
            Text = '1'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight20: TEdit
            Left = 110
            Top = 148
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 4
            Text = '2'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight25: TEdit
            Left = 110
            Top = 175
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 5
            Text = '4'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight30: TEdit
            Left = 300
            Top = 64
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 6
            Text = '7'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight35: TEdit
            Left = 300
            Top = 93
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 7
            Text = '12'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight40: TEdit
            Left = 300
            Top = 120
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 8
            Text = '20'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight45: TEdit
            Left = 300
            Top = 148
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 9
            Text = '35'
            OnExit = RandomWeight05Exit
          end
          object RandomWeight50: TEdit
            Left = 300
            Top = 175
            Width = 43
            Height = 21
            NumbersOnly = True
            TabOrder = 10
            Text = '60'
            OnExit = RandomWeight05Exit
          end
          object BtnCountRating: TButton
            Left = 16
            Top = 225
            Width = 137
            Height = 25
            Hint = 
              'Count how many files in the media library (or the playlist) exis' +
              't with the specific rating.'
            Caption = 'Count Ratings'
            TabOrder = 11
            OnClick = BtnCountRatingClick
          end
          object cbCountRatingOnlyPlaylist: TCheckBox
            Left = 159
            Top = 229
            Width = 258
            Height = 17
            Caption = 'Restrict counting to playlist'
            TabOrder = 12
          end
        end
      end
      object TabView0: TTabSheet
        Caption = 'View (Main)'
        ImageIndex = 1
        object GrpBox_ViewMain_Columns: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 162
          Hint = 'Select the visible columns in the library.'
          Align = alTop
          Caption = 'Show the following columns in the medialist'
          TabOrder = 0
          ExplicitWidth = 440
        end
        object GrpBox_ViewMain_Sorting: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 171
          Width = 454
          Height = 101
          Align = alTop
          Caption = 'File list'
          TabOrder = 1
          ExplicitTop = 365
          ExplicitWidth = 440
          object CBAlwaysSortAnzeigeList: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Always sort the displayed files in the library.'
            Caption = 'Always sort view (slower)'
            TabOrder = 0
            OnClick = CBAlwaysSortAnzeigeListClick
          end
          object CBSkipSortOnLargeLists: TCheckBox
            Left = 34
            Top = 39
            Width = 385
            Height = 17
            Hint = 'Skip this sorting when the list is too large.'
            Caption = 'Skip sort on large lists (> 5000)'
            TabOrder = 1
          end
          object cb_limitMarkerToCurrentFiles: TCheckBox
            Left = 16
            Top = 62
            Width = 409
            Height = 17
            Caption = 'Show marked files only from the current list'
            TabOrder = 2
          end
        end
      end
      object TabView1: TTabSheet
        Caption = 'View (Party)'
        ImageIndex = 19
        object GrpBox_ViewPartymode_Amplification: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 73
          Align = alTop
          Caption = 'View'
          TabOrder = 0
          ExplicitWidth = 440
          object Lbl_PartyMode_ResizeFactor: TLabel
            Left = 16
            Top = 20
            Width = 92
            Height = 13
            Caption = 'Amplification factor'
          end
          object CB_PartyMode_ResizeFactor: TComboBox
            Left = 16
            Top = 39
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
        end
        object GrpBox_ViewPartymode_Functions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 82
          Width = 454
          Height = 83
          Align = alTop
          Caption = 'Functions'
          TabOrder = 1
          ExplicitWidth = 440
          object cb_PartyMode_BlockTreeEdit: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Caption = 'Block editing file information in the media list'
            TabOrder = 0
          end
          object cb_PartyMode_BlockCurrentTitleRating: TCheckBox
            Left = 16
            Top = 36
            Width = 409
            Height = 17
            Caption = 'Block rating of current title'
            TabOrder = 1
          end
          object cb_PartyMode_BlockTools: TCheckBox
            Left = 16
            Top = 52
            Width = 409
            Height = 17
            Caption = 'Block tools'
            TabOrder = 2
          end
        end
        object GrpBox_ViewPartymode_Password: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 171
          Width = 454
          Height = 98
          Align = alTop
          Caption = 'Password'
          TabOrder = 2
          ExplicitWidth = 440
          object Edt_PartyModePassword: TLabeledEdit
            Left = 16
            Top = 36
            Width = 121
            Height = 21
            EditLabel.Width = 139
            EditLabel.Height = 13
            EditLabel.Caption = 'Password to exit Party-Mode'
            TabOrder = 0
            Text = ''
          end
          object cb_PartyMode_ShowPasswordOnActivate: TCheckBox
            Left = 16
            Top = 63
            Width = 409
            Height = 17
            Caption = 'Show password when activating the Nemp Party Mode'
            TabOrder = 1
          end
        end
      end
      object TabView3: TTabSheet
        Caption = 'View (Fonts)'
        ImageIndex = 7
        object GrpBox_Fonts: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 155
          Width = 454
          Height = 153
          Align = alTop
          Caption = 'Font variations according to audio data'
          TabOrder = 2
          ExplicitWidth = 440
          object LblConst_FontVBR: TLabel
            Left = 35
            Top = 100
            Width = 115
            Height = 13
            Caption = 'Font for variable bitrate'
          end
          object LblConst_FontCBR: TLabel
            Left = 227
            Top = 98
            Width = 119
            Height = 13
            Caption = 'Font for constant bitrate'
          end
          object CBChangeFontStyleOnMode: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 'Normal: Joint Stereo, Bold: Full Stereo, Italic: Mono'
            Caption = 'Change style according to channel mode'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            WordWrap = True
          end
          object CBChangeFontOnCbrVbr: TCheckBox
            Left = 16
            Top = 77
            Width = 401
            Height = 17
            Hint = 'Use different fonts for files with fixed or variable bitrate.'
            Caption = 'Change font according to constant/variable bitrate'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            WordWrap = True
            OnClick = CBChangeFontOnCbrVbrClick
          end
          object CBFontNameVBR: TComboBox
            Left = 35
            Top = 114
            Width = 161
            Height = 21
            Style = csDropDownList
            TabOrder = 4
          end
          object CBFontNameCBR: TComboBox
            Left = 227
            Top = 114
            Width = 161
            Height = 21
            Style = csDropDownList
            TabOrder = 5
          end
          object CBChangeFontColoronBitrate: TCheckBox
            Left = 16
            Top = 58
            Width = 409
            Height = 17
            Hint = 'Use different colors for different bitrates.'
            Caption = 'Change font color according to bitrate'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            WordWrap = True
          end
          object CBChangeFontSizeOnLength: TCheckBox
            Left = 16
            Top = 39
            Width = 420
            Height = 17
            Hint = 
              'User bigger fonts for long tracks and smaller ones for short tra' +
              'cks.'
            Caption = 'Change font size according to track length'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            WordWrap = True
          end
        end
        object GrpBox_FontSizePreselection: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 79
          Width = 454
          Height = 70
          Align = alTop
          Caption = 'Font settings for browselists'
          TabOrder = 1
          ExplicitWidth = 440
          object Label34: TLabel
            Left = 152
            Top = 20
            Width = 54
            Height = 13
            Caption = 'Row height'
          end
          object Label32: TLabel
            Left = 16
            Top = 20
            Width = 43
            Height = 13
            Caption = 'Font size'
            ParentShowHint = False
            ShowHint = True
          end
          object lbl_Browselist_FontStyle: TLabel
            Left = 262
            Top = 20
            Width = 48
            Height = 13
            Caption = 'Font style'
          end
          object SEArtistAlbenRowHeight: TSpinEdit
            Left = 152
            Top = 36
            Width = 49
            Height = 22
            MaxValue = 144
            MinValue = 4
            TabOrder = 1
            Value = 16
          end
          object SEArtistAlbenSIze: TSpinEdit
            Left = 16
            Top = 37
            Width = 49
            Height = 22
            MaxValue = 72
            MinValue = 4
            TabOrder = 0
            Value = 16
          end
          object cb_Browselist_FontStyle: TComboBox
            Left = 262
            Top = 39
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
        end
        object GrpBox_FontSize: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 70
          Align = alTop
          Caption = 'Font settings for playlist and medialist'
          TabOrder = 0
          ExplicitWidth = 440
          object LblConst_RowHeight: TLabel
            Left = 152
            Top = 20
            Width = 54
            Height = 13
            Caption = 'Row height'
          end
          object LblConst_BasicFontSize: TLabel
            Left = 16
            Top = 20
            Width = 43
            Height = 13
            Caption = 'Font size'
            ParentShowHint = False
            ShowHint = True
          end
          object lbl_Medialist_FontStyle: TLabel
            Left = 262
            Top = 20
            Width = 48
            Height = 13
            Caption = 'Font style'
          end
          object SERowHeight: TSpinEdit
            Left = 152
            Top = 36
            Width = 49
            Height = 22
            MaxValue = 144
            MinValue = 4
            TabOrder = 1
            Value = 16
          end
          object SEFontSize: TSpinEdit
            Left = 16
            Top = 39
            Width = 49
            Height = 22
            MaxValue = 72
            MinValue = 4
            TabOrder = 0
            Value = 8
          end
          object cb_Medialist_FontStyle: TComboBox
            Left = 262
            Top = 36
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
        end
      end
      object TabView5: TTabSheet
        Caption = 'View (Ext)'
        ImageIndex = 21
        object GrpBox_ViewExt_NoMetadata: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 234
          Width = 454
          Height = 82
          Align = alTop
          Caption = 
            'Not available metadata (If ... is not available, use ... instead' +
            ')'
          TabOrder = 2
          ExplicitWidth = 440
          object LblReplaceArtistBy: TLabel
            Left = 12
            Top = 24
            Width = 97
            Height = 13
            AutoSize = False
            Caption = 'Artist'
          end
          object LblReplaceTitletBy: TLabel
            Left = 153
            Top = 24
            Width = 97
            Height = 13
            AutoSize = False
            Caption = 'Title'
          end
          object LblReplaceAlbumBy: TLabel
            Left = 297
            Top = 24
            Width = 97
            Height = 13
            AutoSize = False
            Caption = 'Album'
          end
          object cbReplaceArtistBy: TComboBox
            Left = 12
            Top = 42
            Width = 125
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
            Left = 153
            Top = 42
            Width = 125
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
          object cbReplaceAlbumBy: TComboBox
            Left = 297
            Top = 42
            Width = 125
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
        end
        object GrpBox_ViewExt_Hints: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 146
          Width = 454
          Height = 82
          Align = alTop
          Caption = 'Extended settings'
          TabOrder = 1
          ExplicitWidth = 440
          object CBShowHintsInMedialist: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Show hints in the library or not.'
            Caption = 'Show hints in the media list'
            TabOrder = 0
          end
          object CB_ShowHintsInPlaylist: TCheckBox
            Left = 16
            Top = 36
            Width = 401
            Height = 17
            Hint = 'Show hints in the playlist or not.'
            Caption = 'Show hints in playlist'
            TabOrder = 1
          end
          object CBFullRowSelect: TCheckBox
            Left = 16
            Top = 53
            Width = 401
            Height = 17
            Hint = 'Select full row or just a single cell in the library.'
            Caption = 'Select full row in media list'
            TabOrder = 2
          end
        end
        object GrpBox_ViewVis_Scrolling: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 137
          Align = alTop
          Caption = 'While playing'
          TabOrder = 0
          ExplicitWidth = 440
          object Lbl_Framerate: TLabel
            Left = 191
            Top = 46
            Width = 12
            Height = 13
            Caption = '...'
          end
          object CB_visual: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Caption = 'Visualization'
            TabOrder = 0
            OnClick = CB_visualClick
          end
          object TB_Refresh: TTrackBar
            Left = 32
            Top = 40
            Width = 153
            Height = 33
            Max = 90
            Frequency = 10
            Position = 20
            TabOrder = 1
            OnChange = TB_RefreshChange
          end
          object CB_ScrollTitelTaskBar: TCheckBox
            Left = 16
            Top = 76
            Width = 401
            Height = 17
            Caption = 'Scroll title in taskbar'
            TabOrder = 2
            OnClick = CB_ScrollTitelTaskBarClick
          end
          object CB_TaskBarDelay: TComboBox
            Left = 40
            Top = 100
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
        end
        object grpBox_PlaylistFormat: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 322
          Width = 454
          Height = 167
          Align = alTop
          Caption = 'Playlist formatting'
          TabOrder = 3
          ExplicitWidth = 440
          DesignSize = (
            454
            167)
          object lblPlaylistTitle: TLabel
            Left = 16
            Top = 27
            Width = 125
            Height = 13
            AutoSize = False
            Caption = 'Regular title'
          end
          object lblPlaylistTitleFB: TLabel
            Left = 16
            Top = 49
            Width = 125
            Height = 13
            AutoSize = False
            Caption = 'Regular title (fallback)'
          end
          object lblPlaylistTitleCueAlbum: TLabel
            Left = 16
            Top = 71
            Width = 125
            Height = 13
            AutoSize = False
            Caption = 'Cue (Album)'
          end
          object lblPlaylistTitleCueTitle: TLabel
            Left = 16
            Top = 93
            Width = 125
            Height = 13
            AutoSize = False
            Caption = 'Cue (Title)'
          end
          object lblPlaylistWebradioTitle: TLabel
            Left = 16
            Top = 115
            Width = 125
            Height = 13
            AutoSize = False
            Caption = 'Webradio'
          end
          object cbPlaylistTitle: TComboBox
            AlignWithMargins = True
            Left = 172
            Top = 24
            Width = 272
            Height = 21
            Anchors = [akTop, akRight]
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
            ExplicitLeft = 158
          end
          object cbPlaylistTitleFB: TComboBox
            AlignWithMargins = True
            Left = 172
            Top = 46
            Width = 272
            Height = 21
            Anchors = [akTop, akRight]
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
            ExplicitLeft = 158
          end
          object cbPlaylistTitleCueAlbum: TComboBox
            AlignWithMargins = True
            Left = 172
            Top = 68
            Width = 272
            Height = 21
            Anchors = [akTop, akRight]
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
            ExplicitLeft = 158
          end
          object cbPlaylistTitleCueTitle: TComboBox
            AlignWithMargins = True
            Left = 172
            Top = 90
            Width = 272
            Height = 21
            Anchors = [akTop, akRight]
            ItemIndex = 4
            ParentColor = True
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
            ExplicitLeft = 158
          end
          object cbPlaylistWebradioTitle: TComboBox
            AlignWithMargins = True
            Left = 172
            Top = 112
            Width = 272
            Height = 21
            Anchors = [akTop, akRight]
            ItemIndex = 0
            TabOrder = 4
            Text = '<station>: <title>'
            Items.Strings = (
              '<station>: <title>'
              '<title>')
            ExplicitLeft = 158
          end
          object cb_ShowIndexInTreeview: TCheckBox
            Left = 16
            Top = 139
            Width = 409
            Height = 17
            Caption = 'Show column "Index"'
            TabOrder = 5
          end
        end
      end
      object TabFiles0: TTabSheet
        Caption = 'Files (Main)'
        ImageIndex = 22
        object GrpBox_FilesMain_Directories: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 206
          Align = alTop
          Caption = 'Directories'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            206)
          object CBAutoScan: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'Check for new files in your music directories when starting Nemp' +
              '.'
            Caption = 'Scan the following directories for new files on start'
            TabOrder = 0
            OnClick = CBAutoScanClick
          end
          object BtnAutoScanAdd: TButton
            AlignWithMargins = True
            Left = 319
            Top = 43
            Width = 125
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Add'
            TabOrder = 2
            OnClick = BtnAutoScanAddClick
            ExplicitWidth = 111
          end
          object BtnAutoScanDelete: TButton
            AlignWithMargins = True
            Left = 319
            Top = 68
            Width = 125
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Delete'
            TabOrder = 3
            OnClick = BtnAutoScanDeleteClick
            ExplicitWidth = 111
          end
          object CBAutoAddNewDirs: TCheckBox
            Left = 16
            Top = 119
            Width = 409
            Height = 17
            Hint = 'Add new directories to this list'
            Caption = 'Automatically monitor new directories'
            TabOrder = 4
          end
          object CBAskForAutoAddNewDirs: TCheckBox
            Left = 16
            Top = 137
            Width = 409
            Height = 17
            Hint = 
              'When selecting a new directory: Show query whether it should be ' +
              'added to this list or not.'
            Caption = 'Show query dialog when adding new directories'
            TabOrder = 5
          end
          object LBAutoscan: TListBox
            Left = 28
            Top = 43
            Width = 300
            Height = 70
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 1
            OnKeyDown = LBAutoscanKeyDown
            ExplicitWidth = 286
          end
          object cb_AutoDeleteFiles: TCheckBox
            Left = 16
            Top = 155
            Width = 393
            Height = 17
            Hint = 
              'Check for missing files in your music directories when starting ' +
              'Nemp and remove them from the media library.'
            Caption = 'Automatically delete missing files from the media library'
            TabOrder = 6
            OnClick = cb_AutoDeleteFilesClick
          end
          object cb_AutoDeleteFilesShowInfo: TCheckBox
            Left = 33
            Top = 173
            Width = 384
            Height = 17
            Hint = 'Create a log message about missing files'
            Caption = 'Log summary about deleted files'
            TabOrder = 7
          end
          object BtnAutoScanNow: TButton
            AlignWithMargins = True
            Left = 319
            Top = 92
            Width = 125
            Height = 21
            Hint = 'Scan now for new or missing files, according to the settings'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Scan now'
            TabOrder = 8
            OnClick = BtnAutoScanNowClick
            ExplicitWidth = 111
          end
        end
        object GrpBox_FilesMain_FileTypes: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 215
          Width = 454
          Height = 205
          Align = alTop
          Caption = 'File types for the media library'
          TabOrder = 1
          ExplicitWidth = 440
          object LblConst_OnlythefollowingTypes: TLabel
            Left = 16
            Top = 43
            Width = 120
            Height = 13
            Caption = 'Only the following types:'
          end
          object cbIncludeAll: TCheckBox
            Left = 16
            Top = 20
            Width = 401
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
            Top = 58
            Width = 408
            Height = 111
            Hint = 'List of supported audio files.'
            Columns = 4
            ItemHeight = 13
            TabOrder = 1
          end
          object BtnRecommendedFiletypes: TButton
            Left = 16
            Top = 175
            Width = 128
            Height = 21
            Hint = 'Select recommended filetypes only'
            Caption = 'Recommended'
            TabOrder = 2
            OnClick = RecommendedFiletypesClick
          end
        end
        object GrpBox_FilesMain_Playlists: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 426
          Width = 454
          Height = 50
          Align = alTop
          Caption = 'Playlists'
          TabOrder = 2
          ExplicitWidth = 440
          object CBAutoScanPlaylistFilesOnView: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 
              'When browsing in playlists: Get the meta-data from the included ' +
              'audiofiles'
            Caption = 'Scan files in playlists'
            TabOrder = 0
          end
        end
      end
      object TabFiles4: TTabSheet
        Caption = 'Files (Categories)'
        ImageIndex = 22
        object ScrollBox1: TScrollBox
          Left = 0
          Top = 0
          Width = 460
          Height = 584
          HorzScrollBar.Visible = False
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          BorderStyle = bsNone
          TabOrder = 0
          object grpBoxSortLevels: TGroupBox
            Left = 0
            Top = 128
            Width = 443
            Height = 217
            Align = alTop
            Caption = 'Treeview: Category layers'
            Constraints.MinWidth = 180
            DefaultHeaderFont = False
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            TabOrder = 0
            object pnlLayerSettings: TPanel
              Left = 181
              Top = 15
              Width = 260
              Height = 200
              Align = alRight
              BevelOuter = bvNone
              DoubleBuffered = True
              ParentDoubleBuffered = False
              TabOrder = 0
              ExplicitLeft = 184
              ExplicitHeight = 107
              DesignSize = (
                260
                200)
              object cbShowCoverForAlbum: TCheckBox
                Left = 8
                Top = 0
                Width = 233
                Height = 17
                Anchors = [akLeft, akTop, akRight]
                Caption = 'Show cover art on layer "Album"'
                TabOrder = 0
              end
              object cbShowElementCount: TCheckBox
                Left = 8
                Top = 22
                Width = 233
                Height = 17
                Anchors = [akLeft, akTop, akRight]
                Caption = 'Show number of elements'
                TabOrder = 1
              end
            end
            object pnlCategoryLayerTree: TPanel
              Left = 2
              Top = 15
              Width = 179
              Height = 200
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 182
              ExplicitHeight = 107
              object VSTSortings: TVirtualStringTree
                Left = 0
                Top = 0
                Width = 179
                Height = 174
                Align = alClient
                BevelInner = bvNone
                BevelOuter = bvNone
                Colors.UnfocusedSelectionColor = clHighlight
                Colors.UnfocusedSelectionBorderColor = clHighlight
                DragOperations = [doMove]
                Header.AutoSizeIndex = 0
                Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
                PopupMenu = PopupLayers
                TabOrder = 0
                TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
                TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
                OnDragAllowed = VSTSortingsDragAllowed
                OnDragOver = VSTSortingsDragOver
                OnDragDrop = VSTSortingsDragDrop
                OnFocusChanged = VSTSortingsFocusChanged
                OnGetText = VSTSortingsGetText
                OnPaintText = VSTSortingsPaintText
                Touch.InteractiveGestures = [igPan, igPressAndTap]
                Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
                ExplicitWidth = 182
                ExplicitHeight = 81
                Columns = <
                  item
                    Position = 0
                    Width = 175
                  end>
              end
              object pnlLayerEdit: TPanel
                Left = 0
                Top = 174
                Width = 179
                Height = 26
                Align = alBottom
                BevelOuter = bvNone
                TabOrder = 1
                ExplicitTop = 81
                ExplicitWidth = 182
                object btnLayerEdit: TButton
                  Left = 80
                  Top = 1
                  Width = 99
                  Height = 21
                  Caption = 'Edit'
                  TabOrder = 0
                  OnClick = btnLayerEditClick
                end
              end
            end
          end
          object grpBoxCategories: TGroupBox
            Left = 0
            Top = 0
            Width = 443
            Height = 128
            Align = alTop
            Caption = 'Categories'
            Constraints.MinWidth = 180
            DefaultHeaderFont = False
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            TabOrder = 1
            object pnlCategorySettings: TPanel
              Left = 181
              Top = 15
              Width = 260
              Height = 111
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitLeft = 180
              ExplicitTop = 11
              DesignSize = (
                260
                111)
              object lblDefaultCategory: TLabel
                Left = 8
                Top = 0
                Width = 81
                Height = 13
                Caption = 'Default category'
              end
              object lblRecentlyAddedCategory: TLabel
                Left = 8
                Top = 45
                Width = 131
                Height = 13
                Caption = 'Category "Recently added"'
              end
              object cbDefaultCategory: TComboBox
                Left = 6
                Top = 18
                Width = 238
                Height = 21
                Style = csDropDownList
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 0
                OnChange = cbDefaultCategoryChange
              end
              object cbNewFilesCategory: TComboBox
                Left = 8
                Top = 63
                Width = 238
                Height = 21
                Style = csDropDownList
                Anchors = [akLeft, akTop, akRight]
                TabOrder = 1
                OnChange = cbNewFilesCategoryChange
              end
            end
            object pnlCategoryTree: TPanel
              Left = 2
              Top = 15
              Width = 179
              Height = 111
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 182
              object VSTCategories: TVirtualStringTree
                Left = 0
                Top = 0
                Width = 179
                Height = 85
                Align = alClient
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
                ExplicitWidth = 182
                Columns = <
                  item
                    Position = 0
                    Width = 175
                  end>
              end
              object pnlCategoryEdit: TPanel
                Left = 0
                Top = 85
                Width = 179
                Height = 26
                Align = alBottom
                BevelOuter = bvNone
                TabOrder = 1
                ExplicitWidth = 182
                object btnCategoryEdit: TButton
                  Left = 80
                  Top = 1
                  Width = 99
                  Height = 21
                  Caption = 'Edit'
                  TabOrder = 0
                  OnClick = btnCategoryEditClick
                end
              end
            end
          end
          object grpBoxAlbumDefinition: TGroupBox
            Left = 0
            Top = 345
            Width = 443
            Height = 152
            Align = alTop
            Caption = 'Definition of an "Album", used for layer "Album" and "Coverflow"'
            TabOrder = 2
            DesignSize = (
              443
              152)
            object lblDefineAlbum: TLabel
              Left = 16
              Top = 24
              Width = 101
              Height = 13
              Caption = 'Define an "Album" by'
            end
            object editCDNames: TLabeledEdit
              Left = 16
              Top = 111
              Width = 335
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              EditLabel.Width = 325
              EditLabel.Height = 13
              EditLabel.Caption = 'Folder names not forming an album of their own (comma separated)'
              TabOrder = 0
              Text = ''
            end
            object cbIgnoreCDDirectories: TCheckBox
              Left = 16
              Top = 73
              Width = 406
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Combine directories like "CD 1" and "CD 2"'
              TabOrder = 1
            end
            object cbAlbumKeymode: TComboBox
              Left = 16
              Top = 41
              Width = 201
              Height = 21
              Style = csDropDownList
              ItemIndex = 2
              TabOrder = 2
              Text = 'Property "Album" and Directory'
              Items.Strings = (
                'Property "Album"'
                'Properties "Album" and "Artist"'
                'Property "Album" and Directory'
                'Directory'
                'Cover')
            end
          end
          object grpBoxPlaylists: TGroupBox
            Left = 0
            Top = 497
            Width = 443
            Height = 130
            Align = alTop
            Caption = 'Category "Playlists"'
            DefaultHeaderFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            HeaderFont.Charset = DEFAULT_CHARSET
            HeaderFont.Color = clWindowText
            HeaderFont.Height = -11
            HeaderFont.Name = 'Tahoma'
            HeaderFont.Style = []
            ParentFont = False
            TabOrder = 3
            object lblPlaylistCaptionMode: TLabel
              Left = 16
              Top = 24
              Width = 89
              Height = 13
              Caption = 'Display playlists as'
            end
            object lblPlaylistSortMode: TLabel
              Left = 16
              Top = 70
              Width = 35
              Height = 13
              Caption = 'Sort by'
            end
            object cbPlaylistCaptionMode: TComboBox
              Left = 16
              Top = 43
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
            object cbPlaylistSortMode: TComboBox
              Left = 16
              Top = 89
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
            object cbPlaylistSortDirection: TComboBox
              AlignWithMargins = True
              Left = 247
              Top = 89
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
          end
          object grpBoxCoverflow: TGroupBox
            Left = 0
            Top = 627
            Width = 443
            Height = 109
            Align = alTop
            Caption = 'Display as "Coverflow"'
            TabOrder = 4
            object cbMissingCoverMode: TComboBox
              Left = 16
              Top = 67
              Width = 353
              Height = 21
              Style = csDropDownList
              ItemIndex = 1
              TabOrder = 0
              Text = 'No special handling of missing cover'
              Items.Strings = (
                'All missing cover at the beginning'
                'No special handling of missing cover'
                'All missing cover at the end')
            end
            object btnEditCoverflow: TButton
              Left = 375
              Top = 40
              Width = 28
              Height = 21
              Caption = '...'
              TabOrder = 1
              OnClick = btnEditCoverflowClick
            end
            object edtCoverFlowSortings: TLabeledEdit
              Left = 16
              Top = 40
              Width = 353
              Height = 21
              EditLabel.Width = 87
              EditLabel.Height = 13
              EditLabel.Caption = 'Sort Coverflow by'
              TabOrder = 2
              Text = ''
            end
          end
        end
      end
      object TabFiles1: TTabSheet
        Caption = 'Files (Metadata)'
        ImageIndex = 20
        object GrpBox_AutoRating: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 170
          Width = 454
          Height = 130
          Align = alTop
          Caption = 'Automatic rating and play counter'
          TabOrder = 2
          ExplicitWidth = 440
          object cb_RatingActive: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = '(De)activate automatic rating/playcounter'
            Caption = 'Change rating and play counter of played files'
            TabOrder = 0
            OnClick = cb_RatingActiveClick
          end
          object cb_RatingIgnoreShortFiles: TCheckBox
            Left = 33
            Top = 45
            Width = 376
            Height = 17
            Hint = 'Do not change rating and playcounter on short tracks.'
            Caption = 'Ignore short tracks (i.e. less than 30 seconds)'
            TabOrder = 1
          end
          object cb_RatingChangeCounter: TCheckBox
            Left = 33
            Top = 65
            Width = 384
            Height = 17
            Hint = 'Increase the playcounter of a file after it was played'
            Caption = 'Increase play counter'
            TabOrder = 2
          end
          object cb_RatingIncreaseRating: TCheckBox
            Left = 33
            Top = 85
            Width = 392
            Height = 17
            Hint = 
              'Automatically increase rating on played tracks. The change will ' +
              'be smaller the higher the playcounter is.'
            Caption = 'Increase rating on played tracks'
            TabOrder = 3
          end
          object cb_RatingDecreaseRating: TCheckBox
            Left = 33
            Top = 105
            Width = 384
            Height = 17
            Hint = 
              'Automatically decrease rating on aborted tracks. The change will' +
              ' be smaller the higher the playcounter is.'
            Caption = 'Decrease rating on aborted tracks'
            TabOrder = 4
          end
        end
        object GrpBox_Metadata: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 65
          Align = alTop
          Caption = 'Access to meta data (e.g. Id3-Tags)'
          TabOrder = 0
          ExplicitWidth = 440
          object cb_AccessMetadata: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Caption = 'Allow quick access to metadata'
            TabOrder = 0
          end
          object cb_IgnoreLyrics: TCheckBox
            Left = 16
            Top = 40
            Width = 401
            Height = 17
            Caption = 'Ignore Lyrics (recommended for very large  music collections)'
            TabOrder = 1
            OnClick = cb_IgnoreLyricsClick
          end
        end
        object GrpBox_CDAudio: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 306
          Width = 454
          Height = 50
          Align = alTop
          Caption = 'CD-Audio'
          TabOrder = 3
          ExplicitWidth = 440
          object cb_UseCDDB: TCheckBox
            Left = 16
            Top = 20
            Width = 420
            Height = 17
            Caption = 'Use CDDB/freeDB to get disc information'
            TabOrder = 0
          end
        end
        object GrpBox_TabMedia5_ID3: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 362
          Width = 454
          Height = 50
          Align = alTop
          Caption = 'Unicode'
          TabOrder = 4
          ExplicitWidth = 440
          object CBAutoDetectCharCode: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'Use a uber-ingenious special method for better tag-reading in fi' +
              'les with "unicode-filenames".'
            Caption = 'Auto-detect (probably) used charset'
            TabOrder = 0
          end
        end
        object grpBox_AdditionalTags: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 74
          Width = 454
          Height = 90
          Align = alTop
          Caption = 'Extended tags (for tag cloud)'
          TabOrder = 1
          ExplicitWidth = 440
          object cb_AutoResolveInconsistencies: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Caption = 'Automatically resolve inconsistencies when entering new tags'
            TabOrder = 0
          end
          object cb_AskForAutoResolveInconsistencies: TCheckBox
            Left = 33
            Top = 43
            Width = 384
            Height = 17
            Caption = 'If not: Show query dialog when inconsistencies occur'
            TabOrder = 1
          end
          object cb_ShowAutoResolveInconsistenciesHints: TCheckBox
            Left = 33
            Top = 63
            Width = 384
            Height = 17
            Caption = 
              'If not: Show information dialog when minor inconsistencies occur' +
              ' '
            TabOrder = 2
          end
        end
      end
      object TabFiles2: TTabSheet
        Caption = 'Files (Cover)'
        ImageIndex = 24
        object GrpBox_TabMedia3_Cover: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 113
          Hint = 'Specify, where Nemp should look for cover images.'
          Align = alTop
          Caption = 'Search covers in ...'
          TabOrder = 0
          ExplicitWidth = 440
          object CB_CoverSearch_inDir: TCheckBox
            Left = 16
            Top = 20
            Width = 385
            Height = 17
            Hint = 'Search for coverfiles within the directory of the audiofile'
            Caption = 'Directory itself'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object CB_CoverSearch_inSubDir: TCheckBox
            Left = 16
            Top = 64
            Width = 201
            Height = 17
            Hint = 'Search for coverfiles in the specified subdirectory.'
            Caption = 'Subdirectory (name)'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = CB_CoverSearch_inSubDirClick
          end
          object CB_CoverSearch_inParentDir: TCheckBox
            Left = 16
            Top = 42
            Width = 393
            Height = 17
            Hint = 'Search for coverfiles in the parent directory of the audiofile.'
            Caption = 'Parent directory'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object CB_CoverSearch_inSisterDir: TCheckBox
            Left = 16
            Top = 86
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
          object EDTCoverSubDirName: TEdit
            Left = 223
            Top = 62
            Width = 105
            Height = 21
            TabOrder = 3
            Text = 'cover'
          end
          object EDTCoverSisterDirName: TEdit
            Left = 223
            Top = 84
            Width = 105
            Height = 21
            TabOrder = 5
            Text = 'cover'
          end
        end
        object GrpBox_Files_Cover_LastFM: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 122
          Width = 454
          Height = 55
          Align = alTop
          Caption = 'Online cover'
          TabOrder = 1
          ExplicitWidth = 440
          object CB_CoverSearch_LastFM: TCheckBox
            Left = 16
            Top = 20
            Width = 305
            Height = 17
            Hint = 'Allow Nemp downloading missing cover files from the internet'
            Caption = 'Try to get missing covers from LastFM'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
          end
          object BtnClearCoverCache: TButton
            Left = 327
            Top = 16
            Width = 99
            Height = 25
            Hint = 'Clear the list of unsuccessfully checked covers'
            Caption = 'Clear cache'
            TabOrder = 1
            OnClick = BtnClearCoverCacheClick
          end
        end
        object GrpBox_Files_Cover_Default: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 253
          Width = 454
          Height = 194
          Align = alTop
          Caption = 'Default cover'
          TabOrder = 3
          ExplicitWidth = 440
          object lbl_DefaultCover: TLabel
            Left = 16
            Top = 24
            Width = 401
            Height = 17
            AutoSize = False
            Caption = 'Used when no proper cover art can be found.'
            WordWrap = True
          end
          object img_DefaultCover: TImage
            Left = 16
            Top = 47
            Width = 137
            Height = 137
          end
          object lbl_DefaultCoverHint: TLabel
            Left = 168
            Top = 109
            Width = 241
            Height = 76
            AutoSize = False
            Caption = 
              'Note: Cover art already displayed in the player will not change ' +
              'until the cover art is loaded again.'
            WordWrap = True
          end
          object btn_DefaultCover: TButton
            Left = 168
            Top = 47
            Width = 110
            Height = 25
            Hint = 'Select a file you want to use as cover art'
            Caption = 'Select'
            TabOrder = 0
            OnClick = btn_DefaultCoverClick
          end
          object btn_DefaultCoverReset: TButton
            Left = 168
            Top = 78
            Width = 110
            Height = 25
            Hint = 'Reset the default cover to the Nemp default cover'
            Caption = 'Reset'
            TabOrder = 1
            OnClick = btn_DefaultCoverResetClick
          end
        end
        object GrpBoxLyrcSettings: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 453
          Width = 454
          Height = 138
          Align = alTop
          Caption = 'Online search for Lyrics'
          TabOrder = 4
          ExplicitWidth = 440
          object LblLyricPriorities: TLabel
            Left = 16
            Top = 79
            Width = 409
            Height = 42
            AutoSize = False
            Caption = 
              'Select the websites you want to download lyrics from. Use the ar' +
              'row buttons to change priority. Double-Click an entry to visit t' +
              'he website for more information.'
            WordWrap = True
          end
          object VSTLyricSettings: TVirtualStringTree
            Left = 16
            Top = 20
            Width = 241
            Height = 53
            Colors.UnfocusedSelectionColor = clHighlight
            Colors.UnfocusedSelectionBorderColor = clHighlight
            Header.AutoSizeIndex = 0
            Header.Options = [hoColumnResize, hoDrag, hoShowImages, hoShowSortGlyphs]
            TabOrder = 0
            TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
            OnChecked = VSTLyricSettingsChecked
            OnGetText = VSTLyricSettingsGetText
            OnInitNode = VSTLyricSettingsInitNode
            OnNodeDblClick = VSTLyricSettingsNodeDblClick
            Touch.InteractiveGestures = [igPan, igPressAndTap]
            Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
            Columns = <
              item
                Position = 0
                Text = 'SearchMethod'
                Width = 200
              end>
          end
          object BtnLyricPriorities: TUpDown
            Left = 263
            Top = 20
            Width = 26
            Height = 41
            Position = 50
            TabOrder = 1
            OnClick = BtnLyricPrioritiesClick
          end
        end
        object GrpBox_Files_CoverSize: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 183
          Width = 454
          Height = 64
          Align = alTop
          Caption = 'Quality of the covers in the media library'
          TabOrder = 2
          ExplicitWidth = 440
          object cb_CoverSize: TComboBox
            Left = 16
            Top = 24
            Width = 201
            Height = 21
            Style = csDropDownList
            ItemIndex = 1
            TabOrder = 0
            Text = 'Normal (500x500)'
            Items.Strings = (
              'Low (240x240)'
              'Normal (500x500)'
              'High (750x750)'
              'Highest (1000x1000)')
          end
        end
      end
      object TabFiles3: TTabSheet
        Caption = 'Files (Search)'
        ImageIndex = 25
        object GrpBox_TabMedia4_GlobalSearchOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 198
          Align = alTop
          Caption = 'Global search options'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            198)
          object LblConst_AccelerateSearchNote: TLabel
            Left = 36
            Top = 37
            Width = 414
            Height = 41
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Note: This will decrease the required time, but will increase th' +
              'e reqired memory (approx. 1mb/4.000 files).'
            WordWrap = True
            ExplicitWidth = 394
          end
          object LblConst_AccelerateSearchNote2: TLabel
            Left = 53
            Top = 135
            Width = 394
            Height = 33
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Note: This will affect the search results of "Quick search" and ' +
              '"General search".'
            WordWrap = True
            ExplicitWidth = 380
          end
          object CB_AccelerateSearch: TCheckBox
            Left = 16
            Top = 20
            Width = 430
            Height = 17
            Hint = 'Use some tricky algorithms to accelerate the search.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Accelerate search'
            TabOrder = 0
            OnClick = CB_AccelerateSearchClick
            ExplicitWidth = 416
          end
          object CB_AccelerateSearchIncludePath: TCheckBox
            Left = 34
            Top = 75
            Width = 415
            Height = 17
            Hint = 'Include filenames to the accelerated search algorithms.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Including filenames'
            TabOrder = 1
            ExplicitWidth = 401
          end
          object CB_AccelerateSearchIncludeComment: TCheckBox
            Left = 34
            Top = 94
            Width = 414
            Height = 17
            Hint = 'Include comments to the accelerated search algorithms.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Including comments'
            TabOrder = 2
            ExplicitWidth = 400
          end
          object CB_AccelerateLyricSearch: TCheckBox
            Left = 16
            Top = 173
            Width = 430
            Height = 17
            Hint = 'Use some tricky algorithms to accelerate the search for lyrics.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Accelerate lyrics search'
            TabOrder = 3
            ExplicitWidth = 416
          end
          object CB_AccelerateSearchIncludeGenre: TCheckBox
            Left = 34
            Top = 114
            Width = 414
            Height = 17
            Hint = 'Include genres to the accelerated search algorithms.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Including genre'
            TabOrder = 4
            ExplicitWidth = 400
          end
        end
        object GrpBox_TabMedia4_QuickSearchOptions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 207
          Width = 454
          Height = 161
          Align = alTop
          Caption = 'Quicksearch options'
          TabOrder = 1
          ExplicitWidth = 440
          DesignSize = (
            454
            161)
          object LblConst_QuickSearchNote: TLabel
            Left = 35
            Top = 69
            Width = 398
            Height = 41
            Hint = 'Activate this settings only if your machine is fast enough.'
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Note: Accelerated search is strongly recommended if one of these' +
              ' options is activated. The last one is not recommended unless yo' +
              'ur medialibrary is not too big or your computer is really fast.'
            WordWrap = True
            ExplicitWidth = 375
          end
          object CB_QuickSearchWhileYouType: TCheckBox
            Left = 16
            Top = 20
            Width = 430
            Height = 17
            Hint = 
              'Show search results in "real time" or just after pressing the "e' +
              'nter"-key.'
            Anchors = [akLeft, akTop, akRight]
            Caption = '"While you type"'
            TabOrder = 0
            ExplicitWidth = 416
          end
          object CB_QuickSearchAllowErrorsWhileTyping: TCheckBox
            Left = 16
            Top = 53
            Width = 430
            Height = 17
            Hint = 
              'Always use a fuzzy search (e.g. show files from "Amy MacDonald" ' +
              'when you search for "Amy McDonald")'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Allow errors while typing'
            TabOrder = 2
            ExplicitWidth = 416
          end
          object CB_QuickSearchAllowErrorsOnEnter: TCheckBox
            Left = 16
            Top = 37
            Width = 430
            Height = 17
            Hint = 
              'Do a fuzzy search after pressing "enter" (e.g. show files from "' +
              'Amy MacDonald" when you search for "Amy McDonald")'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Allow errors on [Enter]'
            TabOrder = 1
            ExplicitWidth = 416
          end
          object cb_ChangeCoverflowOnSearch: TCheckBox
            Left = 16
            Top = 122
            Width = 409
            Height = 17
            Caption = 'Change coverflow according to results'
            TabOrder = 3
          end
        end
      end
      object TabPlayer0: TTabSheet
        Caption = 'Player (Main)'
        ImageIndex = 2
        object GrpBox_Devices: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 118
          Align = alTop
          Caption = 'Output devices'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            118)
          object LblConst_MainDevice: TLabel
            Left = 16
            Top = 20
            Width = 385
            Height = 13
            AutoSize = False
            Caption = 'Main'
          end
          object LblConst_Headphones: TLabel
            Left = 16
            Top = 66
            Width = 305
            Height = 13
            AutoSize = False
            Caption = 'Headphones'
          end
          object HeadphonesDeviceCB: TComboBox
            Left = 16
            Top = 85
            Width = 325
            Height = 21
            Hint = 'The secondary device.'
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            ExplicitWidth = 311
          end
          object MainDeviceCB: TComboBox
            Left = 16
            Top = 35
            Width = 325
            Height = 21
            Hint = 'The main device.'
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            ExplicitWidth = 311
          end
          object BtnRefreshDevices: TButton
            Left = 356
            Top = 83
            Width = 89
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Refresh'
            TabOrder = 2
            OnClick = BtnRefreshDevicesClick
            ExplicitLeft = 342
          end
        end
        object GrpBox_TabAudio2_Fading: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 127
          Width = 454
          Height = 156
          Align = alTop
          Caption = 'Fading'
          TabOrder = 1
          ExplicitWidth = 440
          object LblConst_TitleChange: TLabel
            Left = 32
            Top = 44
            Width = 73
            Height = 13
            Hint = 'Fading length between two songs.'
            Caption = 'On title change'
          end
          object LblConst_Titlefade: TLabel
            Left = 144
            Top = 44
            Width = 92
            Height = 13
            Hint = 'Fading length when scrolling inside a song.'
            Caption = 'On position change'
          end
          object LblConst_ms1: TLabel
            Left = 90
            Top = 68
            Width = 13
            Height = 13
            Hint = 'Fading length between two songs.'
            Caption = 'ms'
          end
          object LblConst_ms2: TLabel
            Left = 202
            Top = 68
            Width = 13
            Height = 13
            Hint = 'Fading length when scrolling inside a song.'
            Caption = 'ms'
          end
          object CB_Fading: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Use crossfading.'
            Caption = 'Fade in/out'
            TabOrder = 0
            OnClick = CB_FadingClick
          end
          object SE_SeekFade: TSpinEdit
            Left = 144
            Top = 63
            Width = 57
            Height = 22
            Hint = 'Fading length when scrolling inside a song.'
            Increment = 100
            MaxValue = 10000
            MinValue = 0
            TabOrder = 2
            Value = 2000
          end
          object SE_Fade: TSpinEdit
            Left = 32
            Top = 63
            Width = 57
            Height = 22
            Hint = 'Fading length between two songs.'
            Increment = 100
            MaxValue = 10000
            MinValue = 0
            TabOrder = 1
            Value = 2000
          end
          object CB_IgnoreFadingOnShortTracks: TCheckBox
            Left = 32
            Top = 92
            Width = 385
            Height = 17
            Hint = 'Ignore fading on short tracks.'
            Caption = 'Ignore on short tracks'
            TabOrder = 3
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
          object CB_IgnoreFadingOnStop: TCheckBox
            Left = 32
            Top = 124
            Width = 393
            Height = 17
            Hint = 'Ignore fading when stopping the player.'
            Caption = 'Ignore on stop'
            TabOrder = 5
          end
        end
        object GrpBox_TabAudio2_Silence: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 289
          Width = 454
          Height = 160
          Align = alTop
          Caption = 'Pause between tracks'
          TabOrder = 2
          ExplicitWidth = 440
          object Lbl_SilenceThreshold: TLabel
            Left = 32
            Top = 43
            Width = 47
            Height = 13
            Caption = 'Threshold'
          end
          object Lbl_SilenceDB: TLabel
            Left = 95
            Top = 63
            Width = 12
            Height = 13
            Caption = 'dB'
          end
          object lblBreakBetweenTracks: TLabel
            Left = 95
            Top = 128
            Width = 13
            Height = 13
            Hint = 'Fading length between two songs.'
            Caption = 'ms'
          end
          object CB_SilenceDetection: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 
              'Automatically detect and skip the silent parts at the end of the' +
              ' tracks '
            Caption = 'Skip silence at the end of tracks'
            TabOrder = 0
            OnClick = CB_SilenceDetectionClick
          end
          object SE_SilenceThreshold: TSpinEdit
            Left = 32
            Top = 59
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
          object cb_AddBreakBetweenTracks: TCheckBox
            Left = 16
            Top = 100
            Width = 409
            Height = 17
            Hint = 'Add a little break between two tracks'
            Caption = 'Add extra silence between tracks'
            TabOrder = 2
            OnClick = cb_AddBreakBetweenTracksClick
          end
          object SE_BreakBetweenTracks: TSpinEdit
            Left = 32
            Top = 123
            Width = 57
            Height = 22
            Hint = 'Length of the break between tracks'
            Increment = 100
            MaxValue = 20000
            MinValue = 0
            TabOrder = 3
            Value = 2000
          end
        end
      end
      object TabPlayer1: TTabSheet
        Caption = 'Player (Ext)'
        ImageIndex = 22
        object GrpBox_ExtendedAudio: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 170
          Align = alTop
          Caption = 'Extended audio settings'
          TabOrder = 0
          ExplicitWidth = 440
          object LblConst_Buffersize: TLabel
            Left = 16
            Top = 20
            Width = 401
            Height = 13
            Hint = 'Increase this value, if the playback stutters sometimes.'
            AutoSize = False
            Caption = 'Buffer size'
          end
          object LblConst_ms: TLabel
            Left = 80
            Top = 40
            Width = 13
            Height = 13
            Hint = 'Increase this value, if the playback stutters sometimes.'
            Caption = 'ms'
          end
          object LblConst_UseFloatingPoint: TLabel
            Left = 16
            Top = 68
            Width = 401
            Height = 13
            Hint = 'Try to change this, if the playback is distorted.'
            AutoSize = False
            Caption = 'Floating-point channels'
          end
          object LblConst_Mixing: TLabel
            Left = 16
            Top = 116
            Width = 409
            Height = 13
            Hint = 'Try to change this, if the playback is distorted.'
            AutoSize = False
            Caption = 'Mixing'
          end
          object Lbl_FloatingPoints_Status: TLabel
            Left = 168
            Top = 88
            Width = 12
            Height = 13
            Hint = 'Try to change this, if the playback is distorted.'
            Caption = '...'
          end
          object SEBufferSize: TSpinEdit
            Left = 16
            Top = 36
            Width = 57
            Height = 22
            Hint = 'Increase this value, if the playback stutters sometimes.'
            Increment = 100
            MaxValue = 5000
            MinValue = 100
            TabOrder = 0
            Value = 500
          end
          object CB_FloatingPoint: TComboBox
            Left = 16
            Top = 84
            Width = 145
            Height = 21
            Hint = 'Try to change this, if the playback is distorted.'
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 1
            Text = 'Auto-detect'
            Items.Strings = (
              'Auto-detect'
              'Off'
              'On')
          end
          object CB_Mixing: TComboBox
            Left = 16
            Top = 132
            Width = 145
            Height = 21
            Hint = 'Try to change this, if the playback is distorted.'
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 2
            Text = 'Hardware'
            Items.Strings = (
              'Hardware'
              'Software')
          end
        end
        object GrpBox_PlayerExt_SafePlayback: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 266
          Width = 454
          Height = 50
          Align = alTop
          Caption = 'Safe playback'
          TabOrder = 2
          ExplicitWidth = 440
          DesignSize = (
            454
            50)
          object cb_SafePlayback: TCheckBox
            Left = 16
            Top = 20
            Width = 432
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Use safe playback'
            TabOrder = 0
            ExplicitWidth = 418
          end
        end
        object grpBoxMidi: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 179
          Width = 454
          Height = 81
          Align = alTop
          Caption = 'MIDI playback'
          TabOrder = 1
          ExplicitWidth = 440
          DesignSize = (
            454
            81)
          object LblSoundFont: TLabel
            Left = 16
            Top = 20
            Width = 391
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'SoundFont file'
            ExplicitWidth = 377
          end
          object editSoundFont: TEdit
            Left = 16
            Top = 39
            Width = 391
            Height = 21
            Hint = 'The SoundFont file used for MIDI playback'
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            ExplicitWidth = 377
          end
          object BtnSelectSoundFontFile: TButton
            Left = 413
            Top = 39
            Width = 25
            Height = 21
            Hint = 'Select file'
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 1
            OnClick = BtnSelectSoundFontFileClick
            ExplicitLeft = 399
          end
        end
      end
      object TabPlayer2: TTabSheet
        Caption = 'Player (Playlist)'
        ImageIndex = 19
        object GrpBox_PlaylistBehaviour: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 142
          Align = alTop
          Caption = 'Behaviour of the playlist'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            142)
          object CB_AutoScanPlaylist: TCheckBox
            Left = 16
            Top = 20
            Width = 424
            Height = 17
            Hint = 
              'Read metadata from the audiofiles or just use the data stored in' +
              ' the playlistfile.'
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Check files when loading a playlist'
            TabOrder = 0
            ExplicitWidth = 410
          end
          object CB_JumpToNextCue: TCheckBox
            Left = 16
            Top = 38
            Width = 409
            Height = 17
            Hint = 'When clicking "next", jump to the next cuesheet (if available)'
            Caption = 'Jump to next entry in cuesheet on "next"'
            TabOrder = 1
          end
          object CB_RememberInterruptedPlayPosition: TCheckBox
            Left = 16
            Top = 74
            Width = 409
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
            Width = 409
            Height = 17
            Hint = 
              'Repeat only the current part of a file instead of the whole trac' +
              'k when "Repeat title" is selected'
            Caption = 'Repeat current entry in cuesheet on "Repeat title"'
            TabOrder = 2
          end
          object cb_PlaylistManagerAutoSave: TCheckBox
            Left = 16
            Top = 92
            Width = 401
            Height = 17
            Caption = 'Autosave favorite playlists'
            TabOrder = 4
            OnClick = cb_PlaylistManagerAutoSaveClick
          end
          object cb_PlaylistManagerAutoSaveUserInput: TCheckBox
            Left = 28
            Top = 110
            Width = 397
            Height = 17
            Caption = 'Decide individually when loading a new playlist '
            TabOrder = 5
          end
        end
        object GrpBox_HeadsetBehaviour: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 151
          Width = 454
          Height = 161
          Align = alTop
          Caption = 'Default actions'
          TabOrder = 1
          ExplicitWidth = 440
          object Label10: TLabel
            Left = 12
            Top = 19
            Width = 405
            Height = 13
            AutoSize = False
            Caption = 'Insert mode from media list into the playlist'
          end
          object LblHeadsetDefaultAction: TLabel
            Left = 12
            Top = 67
            Width = 405
            Height = 13
            AutoSize = False
            Caption = 'Insert mode from headset to playlist'
          end
          object GrpBox_DefaultAction: TComboBox
            Left = 12
            Top = 36
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
            Left = 12
            Top = 84
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
          object cb_AutoStopHeadsetSwitchTab: TCheckBox
            Left = 12
            Top = 111
            Width = 413
            Height = 17
            Caption = 'Stop headset when switching to another tab'
            TabOrder = 2
          end
          object cb_AutoStopHeadsetAddToPlayist: TCheckBox
            Left = 12
            Top = 128
            Width = 405
            Height = 17
            Caption = 'Stop headset when adding headset file to playlist'
            TabOrder = 3
          end
        end
        object GrpBox_PlayerExt2_Playlist: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 318
          Width = 454
          Height = 81
          Align = alTop
          Caption = 'Deleting and mixing'
          TabOrder = 2
          ExplicitWidth = 440
          object CB_AutoMixPlaylist: TCheckBox
            Left = 8
            Top = 56
            Width = 409
            Height = 17
            Hint = 'Randomize playlist after the last track.'
            Caption = 'Mix playlist after last track'
            TabOrder = 2
          end
          object CB_DisableAutoDeleteAtUserInput: TCheckBox
            Left = 28
            Top = 36
            Width = 381
            Height = 17
            Hint = 'Exceptions for deleting a file from the playlist.'
            Caption = 'Do not delete after manual stop/pause/slide/next/previous'
            TabOrder = 1
          end
          object CB_AutoDeleteFromPlaylist: TCheckBox
            Left = 8
            Top = 20
            Width = 401
            Height = 17
            Hint = 'remove a track from the playlist after it is completely played.'
            Caption = 'Delete completely played tracks from the playlist'
            TabOrder = 0
            OnClick = CB_AutoDeleteFromPlaylistClick
          end
        end
        object GrpBoX_LogPlaylist: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 405
          Width = 454
          Height = 98
          Align = alTop
          Caption = 'Playlist Log'
          TabOrder = 3
          ExplicitWidth = 440
          object LblLogDuration: TLabel
            Left = 28
            Top = 43
            Width = 144
            Height = 13
            Caption = 'Remove log entries older than'
          end
          object LblLogDuration2: TLabel
            Left = 96
            Top = 65
            Width = 143
            Height = 13
            Caption = 'days (0 for unlimited logging).'
          end
          object cbSaveLogToFile: TCheckBox
            Left = 8
            Top = 20
            Width = 417
            Height = 17
            Caption = 'Use logfile on hard disk to log previous sessions'
            TabOrder = 0
            OnClick = cbSaveLogToFileClick
          end
          object seLogDuration: TSpinEdit
            Left = 29
            Top = 62
            Width = 61
            Height = 22
            MaxValue = 366
            MinValue = 0
            TabOrder = 1
            Value = 7
          end
        end
      end
      object TabPlayer4: TTabSheet
        Caption = 'Player (Streams)'
        ImageIndex = 23
        object GrpBox_WebradioRecording: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 83
          Width = 454
          Height = 350
          Align = alTop
          Caption = 'Recording settings'
          TabOrder = 1
          ExplicitWidth = 440
          DesignSize = (
            454
            350)
          object LblConst_DownloadDir: TLabel
            Left = 16
            Top = 20
            Width = 93
            Height = 13
            Caption = 'Download directory'
          end
          object LblConst_FilenameFormat: TLabel
            Left = 16
            Top = 84
            Width = 101
            Height = 13
            Caption = 'Pattern for filenames'
          end
          object LblConst_FilenameExtension: TLabel
            Left = 16
            Top = 121
            Width = 231
            Height = 13
            Caption = '(A proper extension will be added automatically)'
          end
          object LblConst_MaxSize: TLabel
            Left = 112
            Top = 203
            Width = 50
            Height = 13
            Caption = 'MB per file'
          end
          object LblConst_MaxTime: TLabel
            Left = 112
            Top = 260
            Width = 73
            Height = 13
            Caption = 'Minutes per file'
          end
          object LblConst_WebradioNote: TLabel
            Left = 40
            Top = 283
            Width = 29
            Height = 13
            Caption = 'Note:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LblConst_WebradioHint: TLabel
            Left = 40
            Top = 299
            Width = 385
            Height = 33
            AutoSize = False
            Caption = 
              'These values are approximate values. Resulting length/size may v' +
              'ary.'
            WordWrap = True
          end
          object BtnChooseDownloadDir: TButton
            Left = 421
            Top = 35
            Width = 25
            Height = 21
            Hint = 'Choose a download directory'
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 1
            OnClick = BtnChooseDownloadDirClick
            ExplicitLeft = 407
          end
          object cbAutoSplitByTitle: TCheckBox
            Left = 16
            Top = 152
            Width = 413
            Height = 17
            Hint = 
              'Try to split the stream when a new title begins. This will work ' +
              'only if the station submits proper title information.'
            Caption = 'Begin new file for every title'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object cbAutoSplitByTime: TCheckBox
            Left = 16
            Top = 237
            Width = 413
            Height = 17
            Hint = 'Split recordings by time.'
            Caption = 'Split files by time'
            TabOrder = 7
            OnClick = cbAutoSplitByTimeClick
          end
          object SE_AutoSplitMaxSize: TSpinEdit
            Left = 40
            Top = 199
            Width = 65
            Height = 22
            MaxValue = 2000
            MinValue = 1
            TabOrder = 6
            Value = 10
          end
          object cbAutoSplitBySize: TCheckBox
            Left = 15
            Top = 180
            Width = 413
            Height = 17
            Hint = 'Split recordings by size.'
            Caption = 'Split files by size'
            TabOrder = 5
            OnClick = cbAutoSplitBySizeClick
          end
          object SE_AutoSplitMaxTime: TSpinEdit
            Left = 40
            Top = 256
            Width = 65
            Height = 22
            MaxValue = 1440
            MinValue = 1
            TabOrder = 8
            Value = 10
          end
          object EdtDownloadDir: TEdit
            Left = 16
            Top = 36
            Width = 399
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            ExplicitWidth = 385
          end
          object cbFilenameFormat: TComboBox
            Left = 16
            Top = 99
            Width = 379
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
            Top = 60
            Width = 393
            Height = 17
            Caption = 'Use streamname as directory'
            TabOrder = 2
          end
        end
        object RGroup_Playlist: TRadioGroup
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 74
          Hint = 
            'A webstream playlist can contain multiple streams (often just al' +
            'ternate URLs) - add all of them to the playlist or let Nemp deci' +
            'de which one to play?'
          Align = alTop
          Caption = 'Playlists (e.g. http://myradio.com/tunein.pls)'
          ItemIndex = 1
          Items.Strings = (
            'Parse stream playlist and add all contained streams to playlist'
            'Just add playlist URL to the playlist (recommended)')
          TabOrder = 0
          ExplicitWidth = 440
        end
      end
      object TabPlayer5: TTabSheet
        Caption = 'Player (Effects)'
        ImageIndex = 15
        object GrpBox_Effects: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 167
          Width = 454
          Height = 69
          Align = alTop
          Caption = 'Effects/Equalizer'
          TabOrder = 1
          ExplicitWidth = 440
          object CB_UseDefaultEffects: TCheckBox
            Left = 16
            Top = 43
            Width = 401
            Height = 17
            Hint = 'Disable effects when Nemp starts'
            Caption = 'Reset effects on start'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object CB_UseDefaultEqualizer: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Disable equalizer when Nemp starts'
            Caption = 'Reset equalizer on start'
            TabOrder = 0
          end
        end
        object GrpBox_Jingles: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 242
          Width = 454
          Height = 129
          Align = alTop
          Caption = 'Jingles (playback via F9, Push-to-talk via F8 )'
          TabOrder = 2
          ExplicitWidth = 440
          object LblJingleReduce: TLabel
            Left = 91
            Top = 47
            Width = 11
            Height = 13
            Caption = '%'
          end
          object LblConst_JingleVolume: TLabel
            Left = 16
            Top = 71
            Width = 80
            Height = 13
            Hint = 'Volume of the jingle in relation to main volume.'
            Caption = 'Volume of jingles'
          end
          object LblConst_JingleVolumePercent: TLabel
            Left = 91
            Top = 95
            Width = 86
            Height = 13
            Hint = 'Volume of the jingle in relation to main volume.'
            Caption = '% of main volume'
          end
          object CBJingleReduce: TCheckBox
            Left = 16
            Top = 20
            Width = 409
            Height = 17
            Hint = 'Reduce main volume before when playing a jingle'
            Caption = 'Reduce main volume to'
            TabOrder = 0
            OnClick = CBJingleReduceClick
          end
          object SEJingleReduce: TSpinEdit
            Left = 35
            Top = 43
            Width = 49
            Height = 22
            Hint = 'Reduce main volume before when playing a jingle'
            MaxValue = 100
            MinValue = 0
            TabOrder = 1
            Value = 50
          end
          object SEJingleVolume: TSpinEdit
            Left = 35
            Top = 90
            Width = 49
            Height = 22
            Hint = 'Volume of the jingle in relation to main volume.'
            MaxValue = 200
            MinValue = 0
            TabOrder = 2
            Value = 100
          end
        end
        object GroupBox1: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 377
          Width = 454
          Height = 57
          Align = alTop
          Caption = '"Walkman" mode'
          TabOrder = 3
          ExplicitWidth = 440
          object cb_UseWalkmanMode: TCheckBox
            Left = 16
            Top = 20
            Width = 401
            Height = 17
            Hint = 'Just as those cassette players did before "mp3" was invented.'
            Caption = 'Flutter playback when battery is low'
            TabOrder = 0
          end
        end
        object GrpBox_TabAudio2_ReplayGain: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 158
          Align = alTop
          Caption = 'ReplayGain'
          TabOrder = 0
          ExplicitWidth = 440
          object lblDefaultGainValue: TLabel
            Left = 376
            Top = 124
            Width = 37
            Height = 13
            Caption = '0.00 dB'
          end
          object lblReplayGainDefault: TLabel
            Left = 16
            Top = 80
            Width = 79
            Height = 13
            Caption = 'Pre-amplification'
          end
          object lblDefaultGainValue2: TLabel
            Left = 376
            Top = 100
            Width = 37
            Height = 13
            Caption = '0.00 dB'
          end
          object lblRG_Preamp1: TLabel
            Left = 16
            Top = 100
            Width = 39
            Height = 13
            Caption = 'With RG'
          end
          object lblRG_Preamp2: TLabel
            Left = 16
            Top = 124
            Width = 55
            Height = 13
            Caption = 'Without RG'
          end
          object cb_ApplyReplayGain: TCheckBox
            Left = 16
            Top = 17
            Width = 409
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
            Top = 35
            Width = 404
            Height = 17
            Hint = 
              'Use AlbumGain values to maintain intentional loudness changes wi' +
              'thin albums'
            Caption = 'Prefer AlbumGain'
            TabOrder = 1
          end
          object tp_DefaultGain: TNempTrackBar
            Left = 104
            Top = 119
            Width = 266
            Height = 24
            Hint = 'Pre-amplification for tracks without ReplayGain information'
            Max = 200
            Min = -200
            PageSize = 10
            TabOrder = 3
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = tp_DefaultGainChange
            OnMouseDown = tp_DefaultGainMouseDown
          end
          object tp_DefaultGain2: TNempTrackBar
            Left = 104
            Top = 96
            Width = 266
            Height = 24
            Hint = 'Pre-amplification for tracks with ReplayGain information'
            Max = 200
            Min = -200
            PageSize = 10
            TabOrder = 4
            TickMarks = tmBoth
            TickStyle = tsNone
            OnChange = tp_DefaultGain2Change
            OnMouseDown = tp_DefaultGain2MouseDown
          end
          object cb_ReplayGainPreventClipping: TCheckBox
            Left = 16
            Top = 53
            Width = 401
            Height = 17
            Hint = 'Limit amplification to prevent playback from clipping, if needed'
            Caption = 'Prevent clipping'
            TabOrder = 2
          end
        end
      end
      object TabPlayer6: TTabSheet
        Caption = 'Player (Event)'
        ImageIndex = 19
        DesignSize = (
          460
          584)
        object GrpBox_TabAudio7_Countdown: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 167
          Width = 454
          Height = 123
          Align = alTop
          Caption = 'Countdown'
          TabOrder = 1
          ExplicitWidth = 440
          DesignSize = (
            454
            123)
          object lblCountDownTitel: TLabel
            Left = 16
            Top = 42
            Width = 76
            Height = 13
            Caption = 'Countdown title'
          end
          object LBlCountDownWarning: TLabel
            Left = 309
            Top = 44
            Width = 76
            Height = 13
            Alignment = taRightJustify
            Caption = 'File not found'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object CBStartCountDown: TCheckBox
            Left = 16
            Top = 20
            Width = 361
            Height = 17
            Hint = 'Signalize birthday song with a countdown.'
            Caption = 'Start a countdown before the actual time'
            TabOrder = 0
            OnClick = CBStartCountDownClick
          end
          object BtnCountDownSong: TButton
            Left = 419
            Top = 58
            Width = 25
            Height = 21
            Hint = 'Select file'
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 2
            OnClick = BtnCountDownSongClick
            ExplicitLeft = 405
          end
          object BtnGetCountDownTitel: TButton
            Left = 16
            Top = 85
            Width = 281
            Height = 25
            Hint = 'Use the current selected file in player as countdown.'
            Caption = 'Use selected file in mainwindow'
            TabOrder = 3
            OnClick = BtnGetCountDownTitelClick
          end
          object EditCountdownSong: TEdit
            Left = 16
            Top = 58
            Width = 397
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = EditCountdownSongChange
            ExplicitWidth = 383
          end
        end
        object GrpBox_TabAudio7_Event: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 158
          Align = alTop
          Caption = 'Event'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            158)
          object Lbl_Const_EventTime: TLabel
            Left = 16
            Top = 20
            Width = 22
            Height = 13
            Hint = 
              'Time when the birthday song should be played. The optional count' +
              'down will end at this time.'
            Caption = 'Time'
          end
          object lblBirthdayTitel: TLabel
            Left = 16
            Top = 43
            Width = 66
            Height = 13
            Caption = 'Birthday song'
          end
          object LblEventWarning: TLabel
            Left = 301
            Top = 45
            Width = 76
            Height = 13
            Alignment = taRightJustify
            Caption = 'File not found'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object BtnBirthdaySong: TButton
            Left = 413
            Top = 58
            Width = 25
            Height = 21
            Hint = 'Select file'
            Anchors = [akTop, akRight]
            Caption = '...'
            TabOrder = 2
            OnClick = BtnBirthdaySongClick
            ExplicitLeft = 399
          end
          object BtnGetBirthdayTitel: TButton
            Left = 16
            Top = 85
            Width = 281
            Height = 25
            Hint = 'Use the current selected file in player as birthday song.'
            Caption = 'Use selected file in mainwindow'
            TabOrder = 3
            OnClick = BtnGetBirthdayTitelClick
          end
          object EditBirthdaySong: TEdit
            Left = 16
            Top = 58
            Width = 391
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 1
            OnChange = EditBirthdaySongChange
            ExplicitWidth = 377
          end
          object CBContinueAfter: TCheckBox
            Left = 16
            Top = 125
            Width = 417
            Height = 17
            Hint = 'Continue with the playlist after the birthday song.'
            Caption = 'Continue with the playlist after playing the birthday song'
            TabOrder = 4
          end
          object mskEdt_BirthdayTime: TMaskEdit
            Left = 64
            Top = 17
            Width = 41
            Height = 21
            EditMask = '!90:00;1;_'
            MaxLength = 5
            TabOrder = 0
            Text = '  :  '
            OnExit = mskEdt_BirthdayTimeExit
          end
        end
        object BtnActivateBirthdayMode: TButton
          AlignWithMargins = True
          Left = 326
          Top = 296
          Width = 131
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Activate'
          TabOrder = 2
          OnClick = BtnActivateBirthdayModeClick
          ExplicitLeft = 312
        end
      end
      object TabPlayer7: TTabSheet
        Caption = 'Player (Scrobble)'
        ImageIndex = 17
        object GrpBox_Scrobble: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 113
          Align = alTop
          Caption = 'LastFM-Scrobbler Setup'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            113)
          object LblScrobble1: TLabel
            Left = 16
            Top = 20
            Width = 425
            Height = 57
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Nemp can scrobble what you hear to your account on LastFM. To do' +
              ' this, Nemp needs your permission to access your account. Go onl' +
              'ine and click the button below to start the configuration.'
            WordWrap = True
            ExplicitWidth = 401
          end
          object Image2: TImage
            AlignWithMargins = True
            Left = 363
            Top = 77
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
            ExplicitLeft = 339
          end
          object LblVisitLastFM: TLabel
            AlignWithMargins = True
            Left = 187
            Top = 84
            Width = 172
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'For details visit'
            ExplicitLeft = 163
          end
          object BtnScrobbleWizard: TButton
            Left = 16
            Top = 80
            Width = 75
            Height = 25
            Caption = 'Start'
            TabOrder = 0
            OnClick = BtnScrobbleWizardClick
          end
        end
        object GrpBox_ScrobbleLog: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 255
          Width = 454
          Height = 169
          Align = alTop
          Caption = 'Scrobble Log (this session)'
          TabOrder = 2
          ExplicitWidth = 440
          DesignSize = (
            454
            169)
          object MemoScrobbleLog: TMemo
            Left = 8
            Top = 16
            Width = 438
            Height = 145
            Anchors = [akLeft, akTop, akRight, akBottom]
            Lines.Strings = (
              'MemoScrobbleLog')
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
            ExplicitWidth = 424
          end
        end
        object GrpBox_ScrobbleSettings: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 122
          Width = 454
          Height = 127
          Align = alTop
          Caption = 'Scrobble Settings'
          TabOrder = 1
          ExplicitWidth = 440
          object Label5: TLabel
            Left = 32
            Top = 76
            Width = 343
            Height = 13
            Caption = 
              'In case scrobbling was paused automatically and you fixed the re' +
              'ason: '
          end
          object CB_AlwaysScrobble: TCheckBox
            Left = 16
            Top = 20
            Width = 411
            Height = 17
            Hint = 'Always begin scrobbling when nemp starts.'
            Caption = 'Scrobble always'
            TabOrder = 0
          end
          object CB_SilentError: TCheckBox
            Left = 16
            Top = 53
            Width = 410
            Height = 17
            Hint = 
              'Ignore hard failures like "no internet connection", "invalid use' +
              'rname/password", ...'
            Caption = 
              'Ignore hard failures - just stop scrobbling if something goes wr' +
              'ong'
            TabOrder = 2
          end
          object CB_ScrobbleThisSession: TCheckBox
            Left = 16
            Top = 36
            Width = 411
            Height = 17
            Hint = 'Begin scrobbling now.'
            Caption = 'Scrobble this session'
            TabOrder = 1
          end
          object Btn_ScrobbleAgain: TButton
            Left = 32
            Top = 92
            Width = 145
            Height = 25
            Hint = 'Restart scrobbling.'
            Caption = 'Scrobble again!'
            TabOrder = 3
            OnClick = Btn_ScrobbleAgainClick
          end
        end
      end
      object TabPlayer8: TTabSheet
        Caption = 'Player (Webserver)'
        ImageIndex = 18
        object GrpBoxConfig: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 185
          Align = alTop
          Caption = 'Configuration'
          TabOrder = 0
          ExplicitWidth = 440
          object LblWebServer_Port: TLabel
            Left = 183
            Top = 20
            Width = 20
            Height = 13
            Caption = 'Port'
          end
          object LblWebServerTheme: TLabel
            Left = 16
            Top = 20
            Width = 32
            Height = 13
            Caption = 'Theme'
          end
          object Label7: TLabel
            Left = 16
            Top = 89
            Width = 88
            Height = 13
            Hint = 'Set username and password to access your library.'
            Caption = 'Username (Admin)'
          end
          object Label8: TLabel
            Left = 224
            Top = 89
            Width = 86
            Height = 13
            Hint = 'Set username and password to access your library'
            Caption = 'Password (Admin)'
          end
          object LblWebserverAdminURL: TLabel
            Left = 16
            Top = 131
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
          object BtnServerActivate: TButton
            Left = 298
            Top = 149
            Width = 125
            Height = 25
            Caption = 'Activate server'
            TabOrder = 0
            OnClick = BtnServerActivateClick
          end
          object CBAutoStartWebServer: TCheckBox
            Left = 16
            Top = 66
            Width = 393
            Height = 17
            Hint = 'Automatically activate the webserver when Nemp starts.'
            Caption = 'Activate webserver on start'
            TabOrder = 3
          end
          object seWebServer_Port: TSpinEdit
            Left = 183
            Top = 35
            Width = 75
            Height = 22
            MaxValue = 65535
            MinValue = 0
            TabOrder = 2
            Value = 80
            OnChange = ChangeWebserverLinks
          end
          object cbWebserverRootDir: TComboBox
            Left = 16
            Top = 36
            Width = 155
            Height = 21
            Style = csDropDownList
            TabOrder = 1
          end
          object EdtUsernameAdmin: TEdit
            Left = 16
            Top = 104
            Width = 200
            Height = 21
            TabOrder = 4
            OnKeyPress = EdtUsernameAdminKeyPress
          end
          object EdtPasswordAdmin: TEdit
            Left = 223
            Top = 104
            Width = 200
            Height = 21
            TabOrder = 5
            OnKeyPress = EdtPasswordKeyPress
          end
          object BtnShowWebserverLog: TButton
            Left = 165
            Top = 149
            Width = 125
            Height = 25
            Caption = 'Show Log'
            TabOrder = 6
            OnClick = BtnShowWebserverLogClick
          end
        end
        object GrpBoxIP: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 364
          Width = 454
          Height = 108
          Hint = 
            'Your IP-configuration. Tell your friends these IPs to access you' +
            'r library.'
          Align = alTop
          Caption = 'Current IP-addresses'
          TabOrder = 2
          ExplicitWidth = 440
          object LblConst_IPWAN: TLabel
            Left = 223
            Top = 20
            Width = 86
            Height = 13
            Caption = 'Your IP (Internet)'
            Transparent = True
          end
          object LabelLANIP: TLabel
            Left = 16
            Top = 20
            Width = 121
            Height = 13
            AutoSize = False
            Caption = 'Your IP (LAN)'
            Transparent = True
          end
          object BtnGetIPs: TButton
            Left = 264
            Top = 67
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
            Left = 16
            Top = 36
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
            Left = 223
            Top = 36
            Width = 200
            Height = 21
            Hint = 
              'Your IP "in the internet". You have to configure your router and' +
              '/or firewall properly (e.g. forwarding Port80 to your machine) '
            ReadOnly = True
            TabOrder = 1
            Text = '?'
          end
        end
        object GrpBoxWebserverUserRights: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 194
          Width = 454
          Height = 164
          Align = alTop
          Caption = 'User rights'
          TabOrder = 1
          ExplicitWidth = 440
          object LblConst_Username2: TLabel
            Left = 16
            Top = 20
            Width = 48
            Height = 13
            Hint = 'Set username and password to access your library.'
            Caption = 'Username'
          end
          object LblConst_Password2: TLabel
            Left = 224
            Top = 20
            Width = 46
            Height = 13
            Hint = 'Set username and password to access your library'
            Caption = 'Password'
          end
          object LblWebserverUserURL: TLabel
            Left = 17
            Top = 63
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
            Top = 134
            Width = 393
            Height = 15
            Hint = 'Let the user control the player (play/stop/next/volume/...)'
            Caption = 'Permit remote control of the player'
            TabOrder = 5
          end
          object cbPermitVote: TCheckBox
            Left = 16
            Top = 84
            Width = 392
            Height = 15
            Hint = 
              'Let the user vote for files - files with many votes will be play' +
              'ed first'
            Caption = 'Permit voting for files'
            TabOrder = 2
          end
          object cbPermitLibraryAccess: TCheckBox
            Left = 16
            Top = 102
            Width = 393
            Height = 15
            Hint = 'Let the user search and browse in your library'
            Caption = 'Permit access to the media library (read only)'
            TabOrder = 3
          end
          object cbPermitPlaylistDownload: TCheckBox
            Left = 16
            Top = 118
            Width = 393
            Height = 15
            Hint = 'Let the user download files from your playlist and/or library'
            Caption = 'Permit downloading files from the playlist'
            TabOrder = 4
          end
          object EdtUsername: TEdit
            Left = 17
            Top = 36
            Width = 200
            Height = 21
            TabOrder = 0
            OnKeyPress = EdtUsernameKeyPress
          end
          object EdtPassword: TEdit
            Left = 223
            Top = 36
            Width = 200
            Height = 21
            TabOrder = 1
            OnKeyPress = EdtPasswordKeyPress
          end
        end
        object BtnQRCode: TButton
          Left = 272
          Top = 488
          Width = 159
          Height = 25
          Caption = 'Show QR-Codes'
          TabOrder = 3
          OnClick = BtnQRCodeClick
        end
      end
      object TabView4: TTabSheet
        Caption = 'View(CoverFlow)'
        ImageIndex = 21
        object grpBox_CoverFlowPositions: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 454
          Height = 110
          Align = alTop
          Caption = 'Position of cover art (z-axis)'
          TabOrder = 0
          ExplicitWidth = 440
          DesignSize = (
            454
            110)
          object lblCoverZMain: TLabel
            Left = 16
            Top = 24
            Width = 67
            Height = 13
            Caption = 'Current cover'
          end
          object LblCoverZLeft: TLabel
            Left = 16
            Top = 49
            Width = 19
            Height = 13
            Caption = 'Left'
          end
          object LblCoverZRight: TLabel
            Left = 16
            Top = 74
            Width = 25
            Height = 13
            Caption = 'Right'
          end
          object tbCoverZMain: TNempTrackBar
            AlignWithMargins = True
            Left = 96
            Top = 24
            Width = 349
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
            ExplicitWidth = 335
          end
          object tbCoverZLeft: TNempTrackBar
            AlignWithMargins = True
            Left = 96
            Top = 50
            Width = 349
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
            ExplicitWidth = 335
          end
          object tbCoverZRight: TNempTrackBar
            AlignWithMargins = True
            Left = 96
            Top = 76
            Width = 349
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
            ExplicitWidth = 335
          end
        end
        object grpBox_CoverFlowGaps: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 178
          Width = 454
          Height = 101
          Align = alTop
          Caption = 'Spacing between cover art'
          TabOrder = 2
          ExplicitWidth = 440
          DesignSize = (
            454
            101)
          object lblCoverFlowGapLeft: TLabel
            Left = 16
            Top = 20
            Width = 19
            Height = 13
            Caption = 'Left'
          end
          object lblCoverFlowGapRight: TLabel
            Left = 264
            Top = 20
            Width = 25
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Right'
            ExplicitLeft = 250
          end
          object tbCoverGapFirstLeft: TNempTrackBar
            AlignWithMargins = True
            Left = 16
            Top = 34
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
            Left = 260
            Top = 34
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
            ExplicitLeft = 246
          end
          object tbCoverGapLeft: TNempTrackBar
            AlignWithMargins = True
            Left = 16
            Top = 64
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
            Left = 260
            Top = 64
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
            ExplicitLeft = 246
          end
        end
        object grpBox_CoverFlowAngles: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 285
          Width = 454
          Height = 58
          Align = alTop
          Caption = 'Angles'
          TabOrder = 3
          ExplicitWidth = 440
          DesignSize = (
            454
            58)
          object lblCoverFlowAngleLeft: TLabel
            Left = 16
            Top = 16
            Width = 19
            Height = 13
            Caption = 'Left'
          end
          object lblCoverFlowAngleRight: TLabel
            Left = 312
            Top = 16
            Width = 25
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Right'
            ExplicitLeft = 298
          end
          object lblCoverFlowAngleMain: TLabel
            Left = 159
            Top = 16
            Width = 67
            Height = 13
            Caption = 'Current cover'
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
          object tbCoverAngleRight: TNempTrackBar
            AlignWithMargins = True
            Left = 308
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
            ExplicitLeft = 294
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
        end
        object grpBox_CoverFlowReflection: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 349
          Width = 454
          Height = 89
          Align = alTop
          Caption = 'Reflection'
          TabOrder = 4
          ExplicitWidth = 440
          DesignSize = (
            454
            89)
          object lblCoverFlowIntensity: TLabel
            Left = 16
            Top = 37
            Width = 43
            Height = 13
            Caption = 'Intenisty'
          end
          object lblCoverflowReflexionGap: TLabel
            Left = 264
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
            Width = 121
            Height = 17
            Caption = 'Enabled'
            TabOrder = 0
            OnClick = tbCoverZMainChange
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
          object tbCoverReflexionGap: TNempTrackBar
            AlignWithMargins = True
            Left = 260
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
            ExplicitLeft = 246
          end
        end
        object grpBox_CoverFlowViewPosition: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 119
          Width = 454
          Height = 53
          Align = alTop
          Caption = 'Viewing position (x-axis)'
          TabOrder = 1
          ExplicitWidth = 440
          DesignSize = (
            454
            53)
          object tbCoverViewPosition: TNempTrackBar
            AlignWithMargins = True
            Left = 16
            Top = 19
            Width = 426
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
            ExplicitWidth = 412
          end
        end
        object PnlCoverFlowControl: TPanel
          Left = 0
          Top = 524
          Width = 460
          Height = 30
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 6
          ExplicitWidth = 446
          DesignSize = (
            460
            30)
          object BtnUndoCoverFlowSettings: TButton
            AlignWithMargins = True
            Left = 327
            Top = 3
            Width = 123
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Undo'
            TabOrder = 0
            OnClick = BtnUndoCoverFlowSettingsClick
            ExplicitLeft = 313
          end
          object BtnCoverFlowDefault: TButton
            AlignWithMargins = True
            Left = 188
            Top = 3
            Width = 123
            Height = 25
            Anchors = [akTop, akRight]
            Caption = 'Default'
            TabOrder = 1
            OnClick = BtnCoverFlowDefaultClick
            ExplicitLeft = 174
          end
        end
        object GrpBoxCoverFlowMixed: TGroupBox
          AlignWithMargins = True
          Left = 3
          Top = 444
          Width = 454
          Height = 77
          Align = alTop
          Caption = 'Mixed settings'
          TabOrder = 5
          ExplicitWidth = 440
          object lblCoverflowTextures: TLabel
            Left = 96
            Top = 23
            Width = 159
            Height = 13
            Caption = 'max. number of displayed covers'
          end
          object cb_UseClassicCoverflow: TCheckBox
            Left = 16
            Top = 48
            Width = 409
            Height = 17
            Hint = 'Classic coverflow for systems without OpenGL-support'
            Caption = 'Use classic 2D coverflow'
            TabOrder = 0
          end
          object seCoverflowTextureCache: TSpinEdit
            Left = 16
            Top = 20
            Width = 67
            Height = 22
            MaxValue = 200
            MinValue = 20
            TabOrder = 1
            Value = 20
          end
        end
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 627
    Width = 683
    Height = 26
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 655
    DesignSize = (
      683
      26)
    object _XXX_cb_SettingsMode: TComboBox
      Left = 3
      Top = 0
      Width = 191
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Commonly used settings'
      Visible = False
      Items.Strings = (
        'Commonly used settings'
        'All settings')
    end
    object BTNok: TButton
      Left = 440
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      TabOrder = 1
      OnClick = BTNokClick
      ExplicitLeft = 412
    end
    object BTNCancel: TButton
      Left = 521
      Top = 0
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = BTNCancelClick
      ExplicitLeft = 493
    end
    object BTNApply: TButton
      Left = 602
      Top = 0
      Width = 77
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Apply'
      TabOrder = 3
      OnClick = BTNApplyClick
      ExplicitLeft = 574
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
end
