object OptionsCompleteForm: TOptionsCompleteForm
  Left = 968
  Top = 125
  BorderIcons = [biSystemMenu]
  Caption = 'Preferences'
  ClientHeight = 585
  ClientWidth = 667
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 594
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  DesignSize = (
    667
    585)
  PixelsPerInch = 96
  TextHeight = 13
  object OptionsVST: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 185
    Height = 539
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    Indent = 8
    ScrollBarOptions.ScrollBars = ssNone
    TabOrder = 0
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnFocusChanged = OptionsVSTFocusChanged
    OnGetText = OptionsVSTGetText
    Columns = <>
  end
  object PageControl1: TPageControl
    Left = 200
    Top = 6
    Width = 457
    Height = 543
    ActivePage = TabSystem3
    Anchors = [akTop, akRight, akBottom]
    MultiLine = True
    TabOrder = 1
    TabStop = False
    object TabSystem0: TTabSheet
      Caption = 'System (Main)'
      ImageIndex = 6
      DesignSize = (
        449
        443)
      object GrpBox_NempUpdater: TGroupBox
        Left = 8
        Top = 192
        Width = 434
        Height = 138
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Nemp auto-updater'
        TabOrder = 1
        object CB_AutoCheck: TCheckBox
          Left = 8
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
        object Btn_CHeckNowForUpdates: TButton
          Left = 8
          Top = 96
          Width = 121
          Height = 25
          Caption = 'Check now'
          TabOrder = 3
          OnClick = Btn_CHeckNowForUpdatesClick
        end
        object CB_AutoCheckNotifyOnBetas: TCheckBox
          Left = 8
          Top = 72
          Width = 417
          Height = 17
          Hint = 
            'Notify on Beta-releases. As Beta-software is normally instable, ' +
            'this is recommended for advanced users only.'
          Caption = 'Notify on Beta-releases'
          TabOrder = 2
        end
        object CBBOX_UpdateInterval: TComboBox
          Left = 24
          Top = 40
          Width = 177
          Height = 21
          ItemHeight = 13
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
        Left = 8
        Top = 8
        Width = 433
        Height = 177
        Caption = 'Starting Nemp'
        TabOrder = 0
        DesignSize = (
          433
          177)
        object CB_AllowMultipleInstances: TCheckBox
          Left = 8
          Top = 112
          Width = 409
          Height = 17
          Hint = 'Allow multiple instances of Nemp.'
          Caption = 'Allow multiple instances'
          TabOrder = 5
        end
        object CB_StartMinimized: TCheckBox
          Left = 8
          Top = 128
          Width = 409
          Height = 17
          Hint = 'Do not show Nemp window on start - directly minimize it.'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Start minimized (you can also use the parameter "/minimized")'
          TabOrder = 6
        end
        object CB_AutoPlayNewTitle: TCheckBox
          Left = 8
          Top = 48
          Width = 401
          Height = 17
          Hint = 
            'When starting Nemp by double-clicking a file in the Windows-Expl' +
            'orer: Use this file instead of the last one.'
          Caption = 'If applicable: Start playback with new file'
          TabOrder = 2
        end
        object CB_SavePositionInTrack: TCheckBox
          Left = 8
          Top = 32
          Width = 385
          Height = 17
          Hint = 'Begin playback at the last known position within the track'
          Caption = 'Remember last track position'
          TabOrder = 1
        end
        object CB_AutoPlayOnStart: TCheckBox
          Left = 8
          Top = 16
          Width = 401
          Height = 17
          Hint = 'Automatically begin playback when Nemp starts'
          Caption = 'Begin playback on start'
          TabOrder = 0
          OnClick = CB_AutoPlayOnStartClick
        end
        object CBAutoLoadMediaList: TCheckBox
          Left = 8
          Top = 72
          Width = 409
          Height = 17
          Hint = 'Automatically load the Nemp medialibrary.'
          Caption = 'Load medialibrary on start'
          TabOrder = 3
        end
        object CBAutoSaveMediaList: TCheckBox
          Left = 8
          Top = 88
          Width = 409
          Height = 17
          Hint = 'Automatically save the Nemp medialibrary.'
          Caption = 'Save medialibrary on close'
          TabOrder = 4
        end
        object cb_StayOnTop: TCheckBox
          Left = 8
          Top = 152
          Width = 409
          Height = 17
          Hint = 
            'Hold the Nemp main window in foreground. Works only in seperate-' +
            'window-mode.'
          Caption = 'Stay on top (not in compact view)'
          TabOrder = 7
        end
      end
    end
    object TabSystem1: TTabSheet
      Caption = 'System1'
      ImageIndex = 5
      DesignSize = (
        449
        443)
      object GrpBox_Hotkeys: TGroupBox
        Left = 8
        Top = 208
        Width = 434
        Height = 233
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Hotkeys configuration'
        TabOrder = 1
        object CB_Activate_Play: TCheckBox
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 24
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
          Left = 8
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
        object CB_Mod_Play: TComboBox
          Left = 168
          Top = 40
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_Play: TComboBox
          Left = 280
          Top = 40
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 60
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 5
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_Stop: TComboBox
          Left = 280
          Top = 60
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 80
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 8
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_Next: TComboBox
          Left = 280
          Top = 80
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 100
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 11
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_Prev: TComboBox
          Left = 280
          Top = 100
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 120
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 14
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_JumpForward: TComboBox
          Left = 280
          Top = 120
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 140
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 17
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_JumpBack: TComboBox
          Left = 280
          Top = 140
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 160
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 20
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_IncVol: TComboBox
          Left = 280
          Top = 160
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 180
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 23
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_DecVol: TComboBox
          Left = 280
          Top = 180
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
          Left = 168
          Top = 200
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 26
          Text = 'Alt + Ctrl'
          Items.Strings = (
            'Alt + Ctrl'
            'Alt + Shift'
            'Ctrl + Shift')
        end
        object CB_Key_Mute: TComboBox
          Left = 280
          Top = 200
          Width = 65
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
        Left = 8
        Top = 8
        Width = 433
        Height = 193
        Caption = 'Media keys'
        TabOrder = 0
        object LblConst_MultimediaKeys_Hint: TLabel
          Left = 8
          Top = 16
          Width = 401
          Height = 81
          AutoSize = False
          Caption = 
            'Nemp is able to hook media keys (like play/stop on some keyboard' +
            's). This enables Nemp to react on these keys even if Nemp is not' +
            ' the active window. Unfortunately the hook must not be activated' +
            ' in case of special software like Logitech iTouch is installed. ' +
            'Start the configuration to detect wether the hook can be install' +
            'ed without complications.'
          WordWrap = True
        end
        object LblConst_MultimediaKeys_Status: TLabel
          Left = 8
          Top = 96
          Width = 209
          Height = 13
          Caption = 'Current state of media keys handling'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Lbl_MultimediaKeys_Status: TLabel
          Left = 8
          Top = 112
          Width = 12
          Height = 13
          Caption = '...'
        end
        object Btn_ConfigureMediaKeys: TButton
          Left = 9
          Top = 136
          Width = 233
          Height = 25
          Hint = 'Try to auto-configure mutlimedia keys properly.'
          Caption = 'Configure media keys'
          TabOrder = 0
          OnClick = Btn_ConfigureMediaKeysClick
        end
        object CB_IgnoreVolume: TCheckBox
          Left = 8
          Top = 168
          Width = 417
          Height = 17
          Hint = 
            'If checked, Nemp will ignore volume keys, to allow global volume' +
            ' control by these keys.'
          Caption = 'Ignore volume up/down keys'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object GrpBox_TabulatorOptions: TGroupBox
        Left = 8
        Top = 448
        Width = 433
        Height = 57
        Caption = 'Tabulators'
        TabOrder = 2
        object CB_TabStopAtPlayerControls: TCheckBox
          Left = 8
          Top = 16
          Width = 417
          Height = 17
          Caption = 'Tabstop at player-controls'
          TabOrder = 0
        end
        object CB_TabStopAtTabs: TCheckBox
          Left = 8
          Top = 32
          Width = 417
          Height = 17
          Caption = 'Tabstop at toolbuttons (cover, lyrics, ...)'
          TabOrder = 1
        end
      end
    end
    object TabSystem2: TTabSheet
      Caption = 'System2'
      ImageIndex = 6
      object Label3: TLabel
        Left = 16
        Top = 336
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
        Top = 352
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
        Top = 400
        Width = 170
        Height = 25
        Hint = 'Register Nemp as default application for the selected filetypes.'
        Caption = 'Apply changes'
        TabOrder = 2
        OnClick = BtnRegistryUpdateClick
      end
      object GrpBox_FileFormats: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 201
        Caption = 'Filetypes'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 16
          Width = 43
          Height = 13
          Caption = 'Filetypes'
        end
        object Label2: TLabel
          Left = 312
          Top = 16
          Width = 73
          Height = 13
          Caption = 'Playlist formats'
        end
        object CBFileTypes: TCheckListBox
          Left = 8
          Top = 32
          Width = 297
          Height = 129
          Hint = 'List of supported audio files.'
          Columns = 4
          ItemHeight = 13
          TabOrder = 0
        end
        object CBPlaylistTypes: TCheckListBox
          Left = 312
          Top = 31
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
          Left = 8
          Top = 168
          Width = 113
          Height = 25
          Caption = 'Select all'
          TabOrder = 2
          OnClick = Btn_SelectAllClick
        end
      end
      object GrpBoxFileFormatOptions: TGroupBox
        Left = 8
        Top = 216
        Width = 433
        Height = 105
        Caption = 'Windows Explorer settings'
        TabOrder = 1
        object CBEnqueueStandard: TCheckBox
          Left = 8
          Top = 16
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
          Left = 8
          Top = 32
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
          Left = 8
          Top = 56
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
        object CBiTouch: TCheckBox
          Left = 8
          Top = 80
          Width = 409
          Height = 17
          Hint = 
            'For Logitech Keyboards with installed "iTouch"-Software: Start N' +
            'emp when pressing the "play-key".'
          Caption = 'Nemp as default player for "Logitech iTouch"'
          TabOrder = 3
        end
      end
    end
    object TabSystem3: TTabSheet
      Caption = 'System3'
      ImageIndex = 20
      DesignSize = (
        449
        443)
      object LblTaskbarWin7: TLabel
        Left = 24
        Top = 149
        Width = 417
        Height = 32
        AutoSize = False
        Caption = 
          '(*) Not recommended under Windows7: The buttons in the preview w' +
          'on'#39't work then.'
        WordWrap = True
      end
      object GrpBox_TaskTray: TRadioGroup
        Left = 8
        Top = 8
        Width = 433
        Height = 137
        Hint = 'Behavior of Nemp in the Windows Taskbar'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Taskbar and/or tray'
        ItemIndex = 4
        Items.Strings = (
          'Windows standard (taskbar only)'
          'Taskbar only, trayicon only when minimized (*)'
          'Trayicon only (*)'
          'Taskbar and trayicon'
          'Taskbar and trayicon, trayicon only when minimized (*)')
        TabOrder = 0
      end
      object GrpBox_Deskband: TGroupBox
        Left = 8
        Top = 182
        Width = 432
        Height = 159
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Notification of a deskband'
        TabOrder = 1
        object CBShowDeskbandOnStart: TCheckBox
          Left = 8
          Top = 16
          Width = 401
          Height = 17
          Caption = 'Show deskband on start'
          TabOrder = 0
        end
        object CBShowDeskbandOnMinimize: TCheckBox
          Left = 8
          Top = 32
          Width = 401
          Height = 17
          Caption = 'Show Deskband on minimize'
          TabOrder = 1
        end
        object CBHideDeskbandOnRestore: TCheckBox
          Left = 8
          Top = 48
          Width = 401
          Height = 17
          Caption = 'Hide deskband on restore'
          TabOrder = 2
        end
        object CBHideDeskbandOnClose: TCheckBox
          Left = 8
          Top = 64
          Width = 401
          Height = 17
          Caption = 'Hide deskband on close'
          TabOrder = 3
        end
        object Btn_InstallDeskband: TButton
          Left = 8
          Top = 88
          Width = 161
          Height = 25
          Hint = 'Install the Nemp Deskband.'
          Caption = 'Install deskband'
          TabOrder = 4
          OnClick = Btn_InstallDeskbandClick
        end
        object Btn_UninstallDeskband: TButton
          Left = 8
          Top = 120
          Width = 161
          Height = 25
          Hint = 'Uninstall the Nemp Deskband.'
          Caption = 'Uninstall deskband'
          TabOrder = 5
          OnClick = Btn_UninstallDeskbandClick
        end
      end
    end
    object TabAnzeige0: TTabSheet
      Caption = 'Anzeige (Main)'
      ImageIndex = 1
      object RGrp_View: TRadioGroup
        Left = 8
        Top = 72
        Width = 433
        Height = 49
        Hint = 
          'Window mode: All in one or seperate windows for player, playlist' +
          ', ...'
        Caption = 'Window mode'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Compact view'
          'Seperate windows')
        TabOrder = 1
      end
      object GrpBox_ViewSeperate: TGroupBox
        Left = 8
        Top = 128
        Width = 433
        Height = 89
        Caption = 'Seperate windows'
        TabOrder = 2
        object cb_ShowEffectsWindow: TCheckBox
          Left = 8
          Top = 16
          Width = 385
          Height = 17
          Caption = 'Show effects/equalizer/...'
          TabOrder = 0
        end
        object cb_ShowPlaylistWindow: TCheckBox
          Left = 8
          Top = 32
          Width = 393
          Height = 17
          Caption = 'Show playlist'
          TabOrder = 1
        end
        object CB_ShowMedialistWindow: TCheckBox
          Left = 8
          Top = 48
          Width = 393
          Height = 17
          Caption = 'Show medialist'
          TabOrder = 2
        end
        object CB_ShowBrowseWindow: TCheckBox
          Left = 8
          Top = 64
          Width = 393
          Height = 17
          Caption = 'Show browselists'
          TabOrder = 3
        end
      end
      object GrpBox_Skins: TGroupBox
        Left = 8
        Top = 224
        Width = 433
        Height = 178
        Hint = 'Available skins for Nemp.'
        Caption = 'Available skins'
        TabOrder = 3
        object LblConst_Preview: TLabel
          Left = 184
          Top = 16
          Width = 38
          Height = 13
          Caption = 'Preview'
        end
        object LblConst_Choose: TLabel
          Left = 8
          Top = 16
          Width = 36
          Height = 13
          Caption = 'Choose'
        end
        object cbSkinAuswahl: TComboBox
          Left = 8
          Top = 36
          Width = 161
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbSkinAuswahlChange
        end
        object NewPlayerPanelOptions: TNempPanel
          Left = 183
          Top = 35
          Width = 230
          Height = 131
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          OnPaint = NewPlayerPanelOptionsPaint
          OwnerDraw = False
          DesignSize = (
            230
            131)
          object PaintFrame: TImage
            Left = 96
            Top = 25
            Width = 113
            Height = 38
            Visible = False
          end
          object TextAnzeigeIMAGE: TImage
            Left = 4
            Top = 5
            Width = 216
            Height = 14
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            Visible = False
          end
          object TimePaintBox: TImage
            Left = 8
            Top = 49
            Width = 53
            Height = 14
            ParentShowHint = False
            ShowHint = True
            Visible = False
          end
          object SlidebarShape: TShape
            Left = 16
            Top = 69
            Width = 193
            Height = 4
            Brush.Color = clGradientActiveCaption
            DragCursor = crSizeWE
            Shape = stRoundRect
            Visible = False
          end
          object VolShape: TShape
            Left = 215
            Top = 29
            Width = 4
            Height = 34
            Brush.Color = clGradientActiveCaption
            DragCursor = crSizeNS
            Shape = stRoundRect
            Visible = False
          end
          object RatingImage: TImage
            Left = 8
            Top = 25
            Width = 80
            Height = 16
            Picture.Data = {
              07544269746D6170560D0000424D560D00000000000036000000280000005000
              00000E0000000100180000000000200D0000120B0000120B0000000000000000
              0000FFFFFFFFFFFF282828404040E9E9E9FFFFFFFFFFFFFFFFFFFFFFFF707070
              070707F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF282828404040E9E9
              E9FFFFFFFFFFFFFFFFFFFFFFFF707070070707F7F7F7FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF282828404040E9E9E9FFFFFFFFFFFFFFFFFFFFFFFF707070
              070707F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF282828404040E9E9
              E9FFFFFFFFFFFFFFFFFFFFFFFF707070070707F7F7F7FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF282828404040E9E9E9FFFFFFFFFFFFFFFFFFFFFFFF707070
              070707F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B5B5BA3A3A30D0D
              0D767676FFFFFFE9E9E93A3A3A646464161616E8E8E8FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF5B5B5BA3A3A30D0D0D767676FFFFFFE9E9E93A3A3A646464
              161616E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B5B5BA3A3A30D0D
              0D767676FFFFFFE9E9E93A3A3A646464161616E8E8E8FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF5B5B5BA3A3A30D0D0D767676FFFFFFE9E9E93A3A3A646464
              161616E8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B5B5BA3A3A30D0D
              0D767676FFFFFFE9E9E93A3A3A646464161616E8E8E8FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFACACAC525252F2F2F25858584040400D0D0DC4C4C4CACACA
              343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC525252F2F2
              F25858584040400D0D0DC4C4C4CACACA343434FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFACACAC525252F2F2F25858584040400D0D0DC4C4C4CACACA
              343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFACACAC525252F2F2
              F25858584040400D0D0DC4C4C4CACACA343434FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFACACAC525252F2F2F25858584040400D0D0DC4C4C4CACACA
              343434FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7070707FFFF
              FFFFFFFFBEBEBEFFFFFFFFFFFF767676767676FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFF7F7F7070707FFFFFFFFFFFFBEBEBEFFFFFFFFFFFF767676
              767676FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7070707FFFF
              FFFFFFFFBEBEBEFFFFFFFFFFFF767676767676FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFF7F7F7070707FFFFFFFFFFFFBEBEBEFFFFFFFFFFFF767676
              767676FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7070707FFFF
              FFFFFFFFBEBEBEFFFFFFFFFFFF767676767676FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF434343BBBBBBFFFFFFFFFFFFFFFFFFFFFFFF343434
              CACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343BBBB
              BBFFFFFFFFFFFFFFFFFFFFFFFF343434CACACAFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF434343BBBBBBFFFFFFFFFFFFFFFFFFFFFFFF343434
              CACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343BBBB
              BBFFFFFFFFFFFFFFFFFFFFFFFF343434CACACAFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFF434343BBBBBBFFFFFFFFFFFFFFFFFFFFFFFF343434
              CACACAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF737373282828FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF6D6D6D343434E9E9E9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF737373282828FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6D6D6D
              343434E9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF737373282828FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF6D6D6D343434E9E9E9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF737373282828FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6D6D6D
              343434E9E9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF737373282828FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF6D6D6D343434E9E9E9FFFFFFFFFFFFFFFFFFFF
              FFFFF5F5F5555555585858F5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              CACACA0707077C7C7CFFFFFFFFFFFFFFFFFFF5F5F5555555585858F5F5F5FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA0707077C7C7CFFFFFFFFFFFFFF
              FFFFF5F5F5555555585858F5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              CACACA0707077C7C7CFFFFFFFFFFFFFFFFFFF5F5F5555555585858F5F5F5FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCACACA0707077C7C7CFFFFFFFFFFFFFF
              FFFFF5F5F5555555585858F5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              CACACA0707077C7C7CFFFFFFFFFFFFFFFFFF252525737373B2B2B2DCDCDCE5E5
              E5FFFFFFFFFFFFFFFFFFFFFFFFE2E2E2B2B2B2B2B2B2434343676767FFFFFFFF
              FFFF252525737373B2B2B2DCDCDCE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFE2E2E2
              B2B2B2B2B2B2434343676767FFFFFFFFFFFF252525737373B2B2B2DCDCDCE5E5
              E5FFFFFFFFFFFFFFFFFFFFFFFFE2E2E2B2B2B2B2B2B2434343676767FFFFFFFF
              FFFF252525737373B2B2B2DCDCDCE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFE2E2E2
              B2B2B2B2B2B2434343676767FFFFFFFFFFFF252525737373B2B2B2DCDCDCE5E5
              E5FFFFFFFFFFFFFFFFFFFFFFFFE2E2E2B2B2B2B2B2B2434343676767FFFFFFFF
              FFFF4C4C4C4C4C4C4C4C4C2222221919196D6D6DFFFFFFFFFFFF1F1F1F1C1C1C
              4C4C4C4C4C4C4C4C4C5E5E5EFFFFFFFFFFFF4C4C4C4C4C4C4C4C4C2222221919
              196D6D6DFFFFFFFFFFFF1F1F1F1C1C1C4C4C4C4C4C4C4C4C4C5E5E5EFFFFFFFF
              FFFF4C4C4C4C4C4C4C4C4C2222221919196D6D6DFFFFFFFFFFFF1F1F1F1C1C1C
              4C4C4C4C4C4C4C4C4C5E5E5EFFFFFFFFFFFF4C4C4C4C4C4C4C4C4C2222221919
              196D6D6DFFFFFFFFFFFF1F1F1F1C1C1C4C4C4C4C4C4C4C4C4C5E5E5EFFFFFFFF
              FFFF4C4C4C4C4C4C4C4C4C2222221919196D6D6DFFFFFFFFFFFF1F1F1F1C1C1C
              4C4C4C4C4C4C4C4C4C5E5E5EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8
              E8161616FFFFFF7C7C7C646464FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E8161616FFFFFF7C7C7C646464FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8
              E8161616FFFFFF7C7C7C646464FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E8161616FFFFFF7C7C7C646464FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8
              E8161616FFFFFF7C7C7C646464FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343BBBBBB3D3D3DC1C1C1FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF434343BBBBBB3D3D3DC1C1C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343BBBBBB3D3D3DC1C1C1FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF434343BBBBBB3D3D3DC1C1C1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF434343BBBBBB3D3D3DC1C1C1FFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF9D9D9D6161611C1C1CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9D9D9D6161611C1C1CFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF9D9D9D6161611C1C1CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9D9D9D6161611C1C1CFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FF9D9D9D6161611C1C1CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0101016D6D6DFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF0101016D6D6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0101016D6D6DFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF0101016D6D6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0101016D6D6DFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797979FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797979FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFF797979FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFF}
            Transparent = True
            Visible = False
          end
          object SlideBarButton: TSkinButton
            Left = 20
            Top = 66
            Width = 25
            Height = 10
            DoubleBuffered = True
            DragCursor = crSizeWE
            ParentDoubleBuffered = False
            TabOrder = 0
            Visible = False
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
            Visible = False
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
            Visible = False
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
            ShowHint = True
            TabOrder = 3
            Visible = False
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
            ShowHint = True
            TabOrder = 4
            Visible = False
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
            Visible = False
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
            Visible = False
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
            Visible = False
            DrawMode = dm_Windows
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object RepeatBitBTN: TSkinButton
            Left = 160
            Top = 88
            Width = 14
            Height = 14
            DoubleBuffered = True
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            Visible = False
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
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
            Visible = False
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
          object Menu1Img: TSkinButton
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
            Visible = False
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object MinimizeIMG: TSkinButton
            Left = 214
            Top = 79
            Width = 12
            Height = 12
            Hint = 'Minimize'
            DoubleBuffered = True
            ParentDoubleBuffered = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            TabStop = False
            Visible = False
            DrawMode = dm_Skin
            NumGlyphsX = 5
            NumGlyphsY = 1
            GlyphLine = 0
            CustomRegion = False
            FocusDrawMode = fdm_Windows
            Color1 = clBlack
            Color2 = clBlack
          end
          object CloseIMG: TSkinButton
            Left = 214
            Top = 97
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
      object GrpBox_Language: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 57
        Hint = 'Language settings.'
        Caption = 'Select language'
        TabOrder = 0
        object cb_Language: TComboBox
          Left = 8
          Top = 20
          Width = 169
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
      end
    end
    object TabAnzeige4: TTabSheet
      Caption = 'Anzeige1 (Player)'
      ImageIndex = 20
      DesignSize = (
        449
        443)
      object GrpBox_TabAudio2_View: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 185
        Anchors = [akLeft, akTop, akRight]
        Caption = 'While playing'
        TabOrder = 0
        object Lbl_Framerate: TLabel
          Left = 132
          Top = 42
          Width = 12
          Height = 13
          Caption = '...'
        end
        object CB_visual: TCheckBox
          Left = 8
          Top = 16
          Width = 321
          Height = 17
          Caption = 'Visualization'
          TabOrder = 0
          OnClick = CB_visualClick
        end
        object TB_Refresh: TTrackBar
          Left = 24
          Top = 36
          Width = 105
          Height = 33
          Max = 90
          Frequency = 10
          Position = 20
          TabOrder = 1
          OnChange = TB_RefreshChange
        end
        object CB_ScrollTitelTaskBar: TCheckBox
          Left = 8
          Top = 72
          Width = 401
          Height = 17
          Caption = 'Scroll title in taskbar'
          TabOrder = 2
          OnClick = CB_ScrollTitelTaskBarClick
        end
        object CB_ScrollTitleInMainWindow: TCheckBox
          Left = 8
          Top = 128
          Width = 401
          Height = 17
          Caption = 'Scroll title/path/details/lyrics in mainwindow'
          TabOrder = 4
          OnClick = CB_ScrollTitleInMainWindowClick
        end
        object CB_TaskBarDelay: TComboBox
          Left = 32
          Top = 96
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
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
        object CB_AnzeigeDelay: TComboBox
          Left = 32
          Top = 152
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 4
          TabOrder = 5
          Text = 'Very fast'
          Items.Strings = (
            'Very slow'
            'Slower'
            'Normal'
            'Faster'
            'Very fast')
        end
      end
      object GrpBox_TabMedia3_Cover: TGroupBox
        Left = 8
        Top = 199
        Width = 434
        Height = 137
        Hint = 'Specify, where Nemp should look for cover images.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Search covers in ...'
        TabOrder = 1
        object CB_CoverSearch_inDir: TCheckBox
          Left = 8
          Top = 16
          Width = 209
          Height = 17
          Hint = 'Search for coverfiles within the directory of the audiofile'
          Caption = 'Directory itself'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object CB_CoverSearch_inSubDir: TCheckBox
          Left = 8
          Top = 48
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
          Left = 8
          Top = 32
          Width = 201
          Height = 17
          Hint = 'Search for coverfiles in the parent directory of the audiofile.'
          Caption = 'Parent directory'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object CB_CoverSearch_inSisterDir: TCheckBox
          Left = 224
          Top = 48
          Width = 185
          Height = 17
          Hint = 
            'Search for coverfiles in the specified subdirectory of the paren' +
            't directory.'
          Caption = 'Sisterdirectory (name)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = CB_CoverSearch_inSisterDirClick
        end
        object EDTCoverSubDirName: TEdit
          Left = 24
          Top = 72
          Width = 105
          Height = 21
          TabOrder = 3
          Text = 'cover'
        end
        object EDTCoverSisterDirName: TEdit
          Left = 242
          Top = 72
          Width = 105
          Height = 21
          TabOrder = 5
          Text = 'cover'
        end
        object CB_CoverSearch_LastFM: TCheckBox
          Left = 13
          Top = 106
          Width = 404
          Height = 17
          Hint = 'Allow Nemp downloading missing cover files from the internet'
          Caption = 'Try to get missing covers from LastFM'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
        end
      end
    end
    object TabAnzeige5: TTabSheet
      Caption = 'Anzeige2 (View)'
      ImageIndex = 24
      DesignSize = (
        449
        443)
      object GrpBox_TabMedia3_Columns: TGroupBox
        Left = 8
        Top = 8
        Width = 434
        Height = 127
        Hint = 'Select the visible columns in the library.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Show the following columns in the medialist'
        TabOrder = 0
      end
      object GrpBox_TabMedia3_Browseby: TGroupBox
        Left = 8
        Top = 142
        Width = 434
        Height = 111
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Browsing in the medialibrary'
        TabOrder = 1
        object Label44: TLabel
          Left = 12
          Top = 20
          Width = 131
          Height = 13
          Hint = 'Select the sorting criteria for browsing the library.'
          Caption = 'Sort orders in classic mode:'
        end
        object Label61: TLabel
          Left = 248
          Top = 20
          Width = 114
          Height = 13
          Hint = 'Select the sorting criteria for browsing the library.'
          Caption = 'Sort order in cover-flow'
        end
        object LblNACoverHint: TLabel
          Left = 33
          Top = 86
          Width = 276
          Height = 13
          Caption = '(Changes will take effect after a rebuild of the coverflow)'
        end
        object CBSortArray1: TComboBox
          Left = 12
          Top = 37
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Artists'
          Items.Strings = (
            'Artists'
            'Albums'
            'Directories'
            'Genres'
            'Years'
            'Fileage')
        end
        object CBSortArray2: TComboBox
          Left = 115
          Top = 37
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 1
          Text = 'Albums'
          Items.Strings = (
            'Artists'
            'Albums'
            'Directories'
            'Genres'
            'Years'
            'Fileage')
        end
        object cbCoverSortOrder: TComboBox
          Left = 248
          Top = 37
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'Artists, Albums'
            'Albums, Artists'
            'Genres, Artists'
            'Years, Artists'
            'Genre, Years'
            'Directories, Artists'
            'Directories, Albums'
            'Fileage, Album'
            'Fileage, Artist')
        end
        object cbHideNACover: TCheckBox
          Left = 15
          Top = 69
          Width = 402
          Height = 17
          Caption = 'Hide cover with no tag-information in coverflow'
          TabOrder = 3
        end
      end
      object GrpBox_TabMedia3_Other: TGroupBox
        Left = 8
        Top = 340
        Width = 433
        Height = 93
        Caption = 'Other'
        TabOrder = 3
        object CBFullRowSelect: TCheckBox
          Left = 8
          Top = 16
          Width = 401
          Height = 17
          Hint = 'Select full row or just a single cell in the library.'
          Caption = 'Select full row in medialist'
          TabOrder = 0
        end
        object CBShowHintsInMedialist: TCheckBox
          Left = 8
          Top = 32
          Width = 401
          Height = 17
          Hint = 'Show hints in the library or not.'
          Caption = 'Show hints in medialist'
          TabOrder = 1
        end
        object CB_ShowHintsInPlaylist: TCheckBox
          Left = 8
          Top = 48
          Width = 401
          Height = 17
          Hint = 'Show hints in the playlist or not.'
          Caption = 'Show hints in playlist'
          TabOrder = 2
        end
        object CB_EditOnClick: TCheckBox
          Left = 8
          Top = 64
          Width = 409
          Height = 17
          Hint = 
            'Begin editing file information in the medialist after a slow dou' +
            'bleclick'
          Caption = 'Edit files at click'
          TabOrder = 3
        end
      end
      object GrpBox_TabMedia3_CoverDetails: TGroupBox
        Left = 8
        Top = 255
        Width = 434
        Height = 83
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Cover && Details'
        TabOrder = 2
        object LblConst_CoverMode: TLabel
          Left = 13
          Top = 22
          Width = 56
          Height = 13
          Hint = 'Display the cover and some other details in the library.'
          Caption = 'Show cover'
        end
        object LblConst_DetailMode: TLabel
          Left = 135
          Top = 22
          Width = 154
          Height = 13
          AutoSize = False
          Caption = 'Show additional details'
        end
        object cbCoverMode: TComboBox
          Left = 9
          Top = 39
          Width = 89
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 0
          Text = 'Left'
          Items.Strings = (
            'Disabled'
            'Left'
            'Right')
        end
        object cbDetailMode: TComboBox
          Left = 135
          Top = 41
          Width = 106
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 1
          Text = 'Aside'
          Items.Strings = (
            'Disabled'
            'Aside'
            'Below')
        end
      end
    end
    object TabAnzeige1: TTabSheet
      Caption = 'Anzeige3 (Fonts)'
      ImageIndex = 7
      DesignSize = (
        449
        443)
      object GrpBox_Fonts: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 125
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Fonts'
        TabOrder = 0
        object LblConst_FontVBR: TLabel
          Left = 27
          Top = 75
          Width = 115
          Height = 13
          Caption = 'Font for variable bitrate'
        end
        object LblConst_FontCBR: TLabel
          Left = 219
          Top = 75
          Width = 119
          Height = 13
          Caption = 'Font for constant bitrate'
        end
        object CBChangeFontStyleOnMode: TCheckBox
          Left = 8
          Top = 16
          Width = 409
          Height = 17
          Hint = 'Normal: Joint Stereo, Bold: Full Stereo, Italic: Mono'
          Caption = 'Change style according to channelmode'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          WordWrap = True
        end
        object CBChangeFontOnCbrVbr: TCheckBox
          Left = 8
          Top = 54
          Width = 401
          Height = 17
          Hint = 'Use different fonts for files with fixed or variable bitrate.'
          Caption = 'Change font according to constant/variable bitrate'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          WordWrap = True
          OnClick = CBChangeFontOnCbrVbrClick
        end
        object CBFontNameVBR: TComboBox
          Left = 27
          Top = 91
          Width = 161
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
        end
        object CBFontNameCBR: TComboBox
          Left = 219
          Top = 91
          Width = 161
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
        end
        object CBChangeFontColoronBitrate: TCheckBox
          Left = 8
          Top = 35
          Width = 393
          Height = 17
          Hint = 'Use different colors for different bitrates.'
          Caption = 'Change font color according to bitrate (if skin allows this)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          WordWrap = True
        end
      end
      object GrpBox_FontSizePreselection: TGroupBox
        Left = 8
        Top = 236
        Width = 434
        Height = 70
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Font size (browselists)'
        TabOrder = 2
        object Label34: TLabel
          Left = 144
          Top = 16
          Width = 54
          Height = 13
          Caption = 'Row height'
        end
        object Label32: TLabel
          Left = 8
          Top = 16
          Width = 43
          Height = 13
          Caption = 'Font size'
          ParentShowHint = False
          ShowHint = True
        end
        object SEArtistAlbenRowHeight: TSpinEdit
          Left = 144
          Top = 32
          Width = 49
          Height = 22
          MaxValue = 144
          MinValue = 4
          TabOrder = 1
          Value = 16
        end
        object SEArtistAlbenSIze: TSpinEdit
          Left = 8
          Top = 33
          Width = 49
          Height = 22
          MaxValue = 72
          MinValue = 4
          TabOrder = 0
          Value = 16
        end
      end
      object GrpBox_FontSize: TGroupBox
        Left = 8
        Top = 138
        Width = 434
        Height = 94
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Font size (playlist and medialist)'
        TabOrder = 1
        object LblConst_RowHeight: TLabel
          Left = 144
          Top = 16
          Width = 54
          Height = 13
          Caption = 'Row height'
        end
        object LblConst_BasicFontSize: TLabel
          Left = 8
          Top = 16
          Width = 68
          Height = 13
          Caption = 'Basic font size'
          ParentShowHint = False
          ShowHint = True
        end
        object SERowHeight: TSpinEdit
          Left = 144
          Top = 32
          Width = 49
          Height = 22
          MaxValue = 144
          MinValue = 4
          TabOrder = 1
          Value = 16
        end
        object CBChangeFontSizeOnLength: TCheckBox
          Left = 8
          Top = 64
          Width = 249
          Height = 17
          Hint = 
            'User bigger fonts for long tracks and smaller ones for short tra' +
            'cks.'
          Caption = 'Change font size according to track length'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          WordWrap = True
        end
        object SEFontSize: TSpinEdit
          Left = 8
          Top = 35
          Width = 49
          Height = 22
          MaxValue = 72
          MinValue = 4
          TabOrder = 0
          Value = 8
        end
      end
    end
    object TabAnzeige6: TTabSheet
      Caption = 'Anzeige4 (PartyMode)'
      ImageIndex = 19
      object GrpBoxPartyMode: TGroupBox
        Left = 8
        Top = 8
        Width = 425
        Height = 208
        Caption = 'Partymode'
        TabOrder = 0
        object Lbl_PartyMode_ResizeFactor: TLabel
          Left = 20
          Top = 21
          Width = 92
          Height = 13
          Caption = 'Amplification factor'
        end
        object CB_PartyMode_ResizeFactor: TComboBox
          Left = 20
          Top = 39
          Width = 165
          Height = 21
          ItemHeight = 13
          ItemIndex = 1
          TabOrder = 0
          Text = '1.5 (moderate amplification)'
          Items.Strings = (
            '1 (no amplification)'
            '1.5 (moderate amplification)'
            '2 (double sized)'
            '2.5 (really huge)')
        end
        object cb_PartyMode_BlockTreeEdit: TCheckBox
          Left = 16
          Top = 72
          Width = 350
          Height = 17
          Caption = 'Block editing file information in the treeview'
          TabOrder = 1
        end
        object cb_PartyMode_BlockCurrentTitleRating: TCheckBox
          Left = 16
          Top = 88
          Width = 350
          Height = 17
          Caption = 'Block rating of current title'
          TabOrder = 2
        end
        object cb_PartyMode_BlockTools: TCheckBox
          Left = 16
          Top = 104
          Width = 350
          Height = 17
          Caption = 'Block tools'
          TabOrder = 3
        end
        object Edt_PartyModePassword: TLabeledEdit
          Left = 16
          Top = 144
          Width = 121
          Height = 21
          EditLabel.Width = 139
          EditLabel.Height = 13
          EditLabel.Caption = 'Password to exit Party-Mode'
          TabOrder = 4
        end
        object cb_PartyMode_ShowPasswordOnActivate: TCheckBox
          Left = 16
          Top = 171
          Width = 393
          Height = 17
          Caption = 'Show password when activating the Nemp Party-Mode'
          TabOrder = 5
        end
      end
    end
    object TabAudio0: TTabSheet
      Caption = 'Audio (Main)'
      ImageIndex = 2
      DesignSize = (
        449
        443)
      object GrpBox_Devices: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 90
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Output devices'
        TabOrder = 0
        object LblConst_MainDevice: TLabel
          Left = 16
          Top = 24
          Width = 121
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Main'
        end
        object LblConst_Headphones: TLabel
          Left = 16
          Top = 48
          Width = 121
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Headphones'
        end
        object HeadphonesDeviceCB: TComboBox
          Left = 144
          Top = 48
          Width = 217
          Height = 21
          Hint = 'The secondary device.'
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
        object MainDeviceCB: TComboBox
          Left = 144
          Top = 24
          Width = 217
          Height = 21
          Hint = 'The main device.'
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object GrpBox_TabAudio2_Fading: TGroupBox
        Left = 8
        Top = 102
        Width = 433
        Height = 151
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Fading'
        TabOrder = 1
        object LblConst_TitleChange: TLabel
          Left = 24
          Top = 40
          Width = 73
          Height = 13
          Hint = 'Fading length between two songs.'
          Caption = 'On title change'
        end
        object LblConst_Titlefade: TLabel
          Left = 136
          Top = 40
          Width = 92
          Height = 13
          Hint = 'Fading length when scrolling inside a song.'
          Caption = 'On position change'
        end
        object LblConst_ms1: TLabel
          Left = 82
          Top = 64
          Width = 13
          Height = 13
          Hint = 'Fading length between two songs.'
          Caption = 'ms'
        end
        object LblConst_ms2: TLabel
          Left = 194
          Top = 64
          Width = 13
          Height = 13
          Hint = 'Fading length when scrolling inside a song.'
          Caption = 'ms'
        end
        object CB_Fading: TCheckBox
          Left = 8
          Top = 16
          Width = 161
          Height = 17
          Hint = 'Use crossfading.'
          Caption = 'Fade in/out'
          TabOrder = 0
          OnClick = CB_FadingClick
        end
        object SE_SeekFade: TSpinEdit
          Left = 136
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
        object SE_Fade: TSpinEdit
          Left = 24
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
        object CB_IgnoreFadingOnShortTracks: TCheckBox
          Left = 24
          Top = 88
          Width = 385
          Height = 17
          Hint = 'Ignore fading on short tracks.'
          Caption = 'Ignore on short tracks'
          TabOrder = 3
        end
        object CB_IgnoreFadingOnPause: TCheckBox
          Left = 24
          Top = 104
          Width = 385
          Height = 17
          Hint = 'Ignore fading when clicking on "Pause".'
          Caption = 'Ignore on pause'
          TabOrder = 4
        end
        object CB_IgnoreFadingOnStop: TCheckBox
          Left = 24
          Top = 120
          Width = 393
          Height = 17
          Hint = 'Ignore fading when stopping the player.'
          Caption = 'Ignore on stop'
          TabOrder = 5
        end
      end
    end
    object TabAudio3: TTabSheet
      Caption = 'Audio1 (Playlist)'
      ImageIndex = 19
      DesignSize = (
        449
        443)
      object GrpBox_PlaylistBehaviour: TGroupBox
        Left = 8
        Top = 192
        Width = 432
        Height = 195
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Behaviour of the playlist'
        TabOrder = 2
        object CB_AutoDeleteFromPlaylist: TCheckBox
          Left = 8
          Top = 32
          Width = 401
          Height = 17
          Hint = 'remove a track from the playlist after it is completely played.'
          Caption = 'Delete completely played tracks from the playlist'
          TabOrder = 1
          OnClick = CB_AutoDeleteFromPlaylistClick
        end
        object CB_AutoMixPlaylist: TCheckBox
          Left = 8
          Top = 136
          Width = 409
          Height = 17
          Hint = 'Randomize playlist after the last track.'
          Caption = 'Mix playlist after last track'
          TabOrder = 7
        end
        object CB_AutoSavePlaylist: TCheckBox
          Left = 8
          Top = 120
          Width = 401
          Height = 17
          Hint = 
            'Backup the playlist every 5 minutes. When Nemp crashes, this bac' +
            'kup will be loaded.'
          Caption = 'Automatically save playlist every 5 minutes'
          TabOrder = 6
        end
        object CB_AutoScanPlaylist: TCheckBox
          Left = 8
          Top = 16
          Width = 401
          Height = 17
          Hint = 
            'Read metadata from the audiofiles or just use the data stored in' +
            ' the playlistfile.'
          Caption = 'Check files on start'
          TabOrder = 0
        end
        object CB_DisableAutoDeleteAtSlide: TCheckBox
          Left = 28
          Top = 48
          Width = 381
          Height = 17
          Hint = 'Exceptions for deleting a file from the playlist.'
          Caption = 'Do not delete after manual sliding within the track'
          TabOrder = 2
        end
        object CB_DisableAutoDeleteAtPause: TCheckBox
          Left = 28
          Top = 64
          Width = 373
          Height = 17
          Hint = 'Exceptions for deleting a file from the playlist.'
          Caption = 'Do not delete after pausing the track'
          TabOrder = 3
        end
        object CB_DisAbleAutoDeleteAtStop: TCheckBox
          Left = 28
          Top = 80
          Width = 389
          Height = 17
          Hint = 'Exceptions for deleting a file from the playlist.'
          Caption = 'Do not delete after stopping a track'
          TabOrder = 4
        end
        object CB_DisableAutoDeleteAtTitleChange: TCheckBox
          Left = 28
          Top = 96
          Width = 381
          Height = 17
          Hint = 'Exceptions for deleting a file from the playlist.'
          Caption = 'Do not delete at manual title change'
          TabOrder = 5
        end
        object CB_JumpToNextCue: TCheckBox
          Left = 8
          Top = 152
          Width = 409
          Height = 17
          Hint = 'When clicking "next", jump to the next cuesheet (if available)'
          Caption = 'Jump to next entry in cuesheet on "next"'
          TabOrder = 8
        end
        object CB_RememberInterruptedPlayPosition: TCheckBox
          Left = 8
          Top = 169
          Width = 409
          Height = 17
          Hint = 'Used in combination with "Just play focussed file"'
          Caption = 
            'Remember track position when playing a song directly from the li' +
            'brary'
          TabOrder = 9
        end
      end
      object GrpBox_RandomOptions: TGroupBox
        Left = 8
        Top = 109
        Width = 432
        Height = 77
        Hint = 
          'Random playback: Correct "real randomness" by avoiding repetitio' +
          'ns of the same song.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Random playback'
        TabOrder = 1
        object LblConst_ReallyRandom: TLabel
          Left = 8
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
      object GrpBox_DefaultAction: TRadioGroup
        Left = 8
        Top = 8
        Width = 432
        Height = 97
        Hint = 'Default action for files in the library (doubleclick)'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Default action for audiofiles'
        ItemIndex = 0
        Items.Strings = (
          'Enqueue at the end of the playlist'
          'Play (and clear current playlist)'
          'Enqueue after current track'
          'Just play focussed file (don'#39't change the playlist)')
        TabOrder = 0
      end
    end
    object TabAudio8: TTabSheet
      Caption = 'Audio2 (Medialib)'
      ImageIndex = 22
      DesignSize = (
        449
        443)
      object GrpBox_Directories: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 176
        Caption = 'Directories'
        TabOrder = 0
        DesignSize = (
          433
          176)
        object CBAutoScan: TCheckBox
          Left = 8
          Top = 16
          Width = 409
          Height = 17
          Hint = 
            'Check for new files in your music directories when starting Nemp' +
            '.'
          Caption = 'Search the following directories for new files on start'
          TabOrder = 0
          OnClick = CBAutoScanClick
        end
        object BtnAutoScanAdd: TButton
          Left = 341
          Top = 39
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 2
          OnClick = BtnAutoScanAddClick
        end
        object BtnAutoScanDelete: TButton
          Left = 341
          Top = 70
          Width = 75
          Height = 25
          Caption = 'Delete'
          TabOrder = 3
          OnClick = BtnAutoScanDeleteClick
        end
        object CBAutoAddNewDirs: TCheckBox
          Left = 8
          Top = 134
          Width = 409
          Height = 17
          Hint = 'Add new directories to this list'
          Caption = 'Automatically monitor new directories'
          TabOrder = 4
        end
        object CBAskForAutoAddNewDirs: TCheckBox
          Left = 8
          Top = 151
          Width = 409
          Height = 17
          Hint = 
            'When selecting a new directory: Show query whether it should be ' +
            'added to this list or not.'
          Caption = 'Show query dialog when adding new directories'
          TabOrder = 5
        end
        object LBAutoscan: TListBox
          Left = 8
          Top = 40
          Width = 321
          Height = 89
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
          OnKeyDown = LBAutoscanKeyDown
        end
      end
      object GrpBox_TabMedia1_Filetypes: TGroupBox
        Left = 8
        Top = 190
        Width = 434
        Height = 177
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Filetypes for the library'
        TabOrder = 1
        object LblConst_OnlythefollowingTypes: TLabel
          Left = 24
          Top = 40
          Width = 120
          Height = 13
          Caption = 'Only the following types:'
        end
        object cbIncludeAll: TCheckBox
          Left = 8
          Top = 16
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
          Left = 20
          Top = 57
          Width = 402
          Height = 111
          Hint = 'List of supported audio files.'
          Columns = 4
          ItemHeight = 13
          TabOrder = 1
        end
      end
      object GrpBox_TabMedia1_Medialist: TGroupBox
        Left = 8
        Top = 371
        Width = 434
        Height = 71
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Other'
        TabOrder = 2
        object CBAutoScanPlaylistFilesOnView: TCheckBox
          Left = 8
          Top = 16
          Width = 401
          Height = 17
          Hint = 
            'When browsing in playlists: Get the meta-data from the included ' +
            'audiofiles'
          Caption = 'Scan files in playlists'
          TabOrder = 0
        end
        object CBAlwaysSortAnzeigeList: TCheckBox
          Left = 8
          Top = 32
          Width = 401
          Height = 17
          Hint = 'Always sort the displayed files in the library.'
          Caption = 'Always sort view (slower)'
          TabOrder = 1
          OnClick = CBAlwaysSortAnzeigeListClick
        end
        object CBSkipSortOnLargeLists: TCheckBox
          Left = 32
          Top = 48
          Width = 385
          Height = 17
          Hint = 'Skip this sorting when the list is too large.'
          Caption = 'Skip sort on large lists (> 5000)'
          TabOrder = 2
        end
      end
    end
    object TabAudio2: TTabSheet
      Caption = 'Audio2a (Rating)'
      ImageIndex = 20
      object GroupBox1: TGroupBox
        Left = 13
        Top = 8
        Width = 433
        Height = 322
        Caption = 'Automatic rating/playcounter of played audiofiles'
        TabOrder = 0
        object cb_RatingActive: TCheckBox
          Left = 16
          Top = 24
          Width = 409
          Height = 17
          Hint = '(De)activate automatic rating/playcounter'
          Caption = 'Active'
          TabOrder = 0
          OnClick = cb_RatingActiveClick
        end
        object cb_RatingIgnoreShortFiles: TCheckBox
          Left = 33
          Top = 49
          Width = 376
          Height = 17
          Hint = 'Do not change rating and playcounter on short tracks.'
          Caption = 'Ignore short tracks (i.e. less than 30 seconds)'
          TabOrder = 1
        end
        object cb_RatingChangeCounter: TCheckBox
          Left = 33
          Top = 88
          Width = 384
          Height = 17
          Hint = 'Increase the playcounter of a file after it was played'
          Caption = 'Increase play counter'
          TabOrder = 3
          OnClick = cb_RatingChangeCounterClick
        end
        object cb_RatingWriteToFiles: TCheckBox
          Left = 33
          Top = 65
          Width = 384
          Height = 17
          Hint = 'Write rating and playcounter into the ID3-tags'
          Caption = 'Update ID3-Tags of audiofiles'
          TabOrder = 2
        end
        object cb_RatingIgnoreCounterOnAbortedTracks: TCheckBox
          Left = 51
          Top = 107
          Width = 379
          Height = 17
          Hint = 'Do not increase the counter, if the file was aborted'
          Caption = 'Ignore on aborted tracks'
          TabOrder = 4
        end
        object cb_RatingIncreaseRating: TCheckBox
          Left = 33
          Top = 129
          Width = 376
          Height = 17
          Hint = 
            'Automatically increase rating on played tracks. The change will ' +
            'be smaller the higher the playcounter is.'
          Caption = 'Increase rating on played tracks'
          TabOrder = 5
        end
        object cb_RatingDecreaseRating: TCheckBox
          Left = 33
          Top = 151
          Width = 376
          Height = 17
          Hint = 
            'Automatically decrease rating on aborted tracks. The change will' +
            ' be smaller the higher the playcounter is.'
          Caption = 'Decrease rating on aborted tracks'
          TabOrder = 6
        end
        object StaticText1: TStaticText
          Left = 16
          Top = 179
          Width = 393
          Height = 31
          AutoSize = False
          Caption = 
            'A track is treated as "played", if more than 50% were played or ' +
            'at least 4 minutes. '
          TabOrder = 7
        end
        object StaticText2: TStaticText
          Left = 16
          Top = 209
          Width = 393
          Height = 52
          AutoSize = False
          Caption = 
            'A track is treated as "aborted" if it is not "played" and the pl' +
            'ayer is not stopped. So the rating will not be decreased when yo' +
            'u press the stop-button or close the player.'
          TabOrder = 8
        end
      end
    end
    object TabAudio4: TTabSheet
      Caption = 'Audio3 (Webradio)'
      ImageIndex = 23
      DesignSize = (
        449
        443)
      object GrpBox_WebradioRecording: TGroupBox
        Left = 8
        Top = 91
        Width = 434
        Height = 315
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Recording options'
        TabOrder = 1
        DesignSize = (
          434
          315)
        object LblConst_DownloadDir: TLabel
          Left = 8
          Top = 16
          Width = 93
          Height = 13
          Caption = 'Download directory'
        end
        object LblConst_FilenameFormat: TLabel
          Left = 8
          Top = 64
          Width = 101
          Height = 13
          Caption = 'Pattern for filenames'
        end
        object LblConst_FilenameExtension: TLabel
          Left = 8
          Top = 112
          Width = 231
          Height = 13
          Caption = '(A proper extension will be added automatically)'
        end
        object LblConst_MaxSize: TLabel
          Left = 104
          Top = 182
          Width = 50
          Height = 13
          Caption = 'MB per file'
        end
        object LblConst_MaxTime: TLabel
          Left = 104
          Top = 230
          Width = 73
          Height = 13
          Caption = 'Minutes per file'
        end
        object LblConst_WebradioNote: TLabel
          Left = 32
          Top = 256
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
          Left = 32
          Top = 272
          Width = 385
          Height = 33
          AutoSize = False
          Caption = 
            'These values are approximate values. Resulting length/size may v' +
            'ary.'
          WordWrap = True
        end
        object BtnChooseDownloadDir: TButton
          Left = 401
          Top = 32
          Width = 25
          Height = 21
          Hint = 'Choose a download directory'
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = BtnChooseDownloadDirClick
        end
        object cbAutoSplitByTitle: TCheckBox
          Left = 8
          Top = 136
          Width = 417
          Height = 17
          Hint = 
            'Try to split the stream when a new title begins. This will work ' +
            'only if the station submits proper title information.'
          Caption = 'Save different titles in separate files'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object cbAutoSplitByTime: TCheckBox
          Left = 8
          Top = 208
          Width = 417
          Height = 17
          Hint = 'Split recordings by time.'
          Caption = 'Split files by time'
          TabOrder = 6
          OnClick = cbAutoSplitByTimeClick
        end
        object SE_AutoSplitMaxSize: TSpinEdit
          Left = 32
          Top = 178
          Width = 65
          Height = 22
          MaxValue = 2000
          MinValue = 1
          TabOrder = 5
          Value = 10
        end
        object cbAutoSplitBySize: TCheckBox
          Left = 8
          Top = 160
          Width = 417
          Height = 17
          Hint = 'Split recordings by size.'
          Caption = 'Split files by size'
          TabOrder = 4
          OnClick = cbAutoSplitBySizeClick
        end
        object SE_AutoSplitMaxTime: TSpinEdit
          Left = 32
          Top = 226
          Width = 65
          Height = 22
          MaxValue = 1440
          MinValue = 1
          TabOrder = 7
          Value = 10
        end
        object EdtDownloadDir: TEdit
          Left = 8
          Top = 32
          Width = 386
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
        end
        object cbFilenameFormat: TComboBox
          Left = 8
          Top = 79
          Width = 385
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = '<date>, <time> - <title>'
          OnChange = cbFilenameFormatChange
          Items.Strings = (
            '<date>, <time> - <title>'
            '<date>, <time> - <streamname> - <title>'
            '<title>'
            '<streamname> - <title>')
        end
      end
      object RGroup_Playlist: TRadioGroup
        Left = 8
        Top = 8
        Width = 433
        Height = 74
        Hint = 
          'A webstream-playlist can contain multiple streams (often just al' +
          'ternate URLs) - add all of them to the playlist or let Nemp deci' +
          'de which one to play?'
        Caption = 'Playlists (e.g. http://myradio.com/tunein.pls)'
        ItemIndex = 1
        Items.Strings = (
          'Parse Stream-Playlist and add all contained streams to playlist'
          'Just add playlist-URL to the playlist')
        TabOrder = 0
      end
    end
    object TabAudio5: TTabSheet
      Caption = 'Audio4 (Effekte)'
      ImageIndex = 15
      DesignSize = (
        449
        443)
      object GrpBox_MickyMouse: TRadioGroup
        Left = 8
        Top = 8
        Width = 432
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Caption = 'On changing speed (changes will take effect on next track)'
        ItemIndex = 1
        Items.Strings = (
          'Keep pitch'
          '"Micky Mouse effect"')
        TabOrder = 0
      end
      object GrpBox_Effects: TGroupBox
        Left = 8
        Top = 80
        Width = 432
        Height = 57
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Effects/Equalizer'
        TabOrder = 1
        object CB_UseDefaultEffects: TCheckBox
          Left = 8
          Top = 32
          Width = 417
          Height = 17
          Hint = 'Disable effects when Nemp starts'
          Caption = 'Reset effects on start'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CB_UseDefaultEqualizer: TCheckBox
          Left = 8
          Top = 16
          Width = 409
          Height = 17
          Hint = 'Disable equalizer when Nemp starts'
          Caption = 'Reset equalizer on start'
          TabOrder = 0
        end
      end
      object GrpBox_Jingles: TGroupBox
        Left = 8
        Top = 141
        Width = 432
        Height = 123
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Jingles (playback via F9)'
        TabOrder = 2
        object LblJingleReduce: TLabel
          Left = 92
          Top = 47
          Width = 11
          Height = 13
          Caption = '%'
        end
        object LblConst_JingleVolume: TLabel
          Left = 12
          Top = 71
          Width = 80
          Height = 13
          Hint = 'Volume of the jingle in relation to main volume.'
          Caption = 'Volume of jingles'
        end
        object LblConst_JingleVolumePercent: TLabel
          Left = 92
          Top = 95
          Width = 86
          Height = 13
          Hint = 'Volume of the jingle in relation to main volume.'
          Caption = '% of main volume'
        end
        object CBJingleReduce: TCheckBox
          Left = 12
          Top = 19
          Width = 409
          Height = 17
          Hint = 'Reduce main volume before when playing a jingle'
          Caption = 'Reduce main volume by'
          TabOrder = 0
          OnClick = CBJingleReduceClick
        end
        object SEJingleReduce: TSpinEdit
          Left = 36
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
          Left = 36
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
      object GrpBox_Headset: TGroupBox
        Left = 13
        Top = 270
        Width = 433
        Height = 111
        Caption = 'Headset'
        TabOrder = 3
        object LblHeadsetDefaultAction: TLabel
          Left = 12
          Top = 19
          Width = 405
          Height = 13
          AutoSize = False
          Caption = 'Insert mode for headset files'
        end
        object GrpBox_HeadsetDefaultAction: TComboBox
          Left = 12
          Top = 38
          Width = 285
          Height = 21
          Hint = 'Insert mode for files from the headset'
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Enqueue at the end of the playlist'
          Items.Strings = (
            'Enqueue at the end of the playlist'
            'Play (and clear current playlist)'
            'Enqueue after current track'
            'Just play (don'#39't change the playlist)')
        end
        object cb_AutoStopHeadset: TCheckBox
          Left = 12
          Top = 68
          Width = 389
          Height = 17
          Caption = 'Stop headset when switching to another tab'
          TabOrder = 1
        end
      end
    end
    object TabAudio7: TTabSheet
      Caption = 'Audio5 (Birthday)'
      ImageIndex = 19
      DesignSize = (
        449
        443)
      object GrpBox_TabAudio7_Countdown: TGroupBox
        Left = 8
        Top = 8
        Width = 426
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Countdown'
        TabOrder = 0
        DesignSize = (
          426
          113)
        object lblCountDownTitel: TLabel
          Left = 8
          Top = 40
          Width = 76
          Height = 13
          Caption = 'Countdown title'
        end
        object LBlCountDownWarning: TLabel
          Left = 301
          Top = 40
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
          Left = 8
          Top = 16
          Width = 361
          Height = 17
          Hint = 'Signalize birthday song with a countdown.'
          Caption = 'Start a countdown before the event'
          TabOrder = 0
          OnClick = CBStartCountDownClick
        end
        object BtnCountDownSong: TButton
          Left = 385
          Top = 56
          Width = 25
          Height = 21
          Hint = 'Select file'
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = BtnCountDownSongClick
        end
        object BtnGetCountDownTitel: TButton
          Left = 8
          Top = 80
          Width = 241
          Height = 21
          Hint = 'Use the current selected file in player as countdown.'
          Caption = 'Use selected file in mainwindow'
          TabOrder = 3
          OnClick = BtnGetCountDownTitelClick
        end
        object EditCountdownSong: TEdit
          Left = 8
          Top = 56
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = EditCountdownSongChange
        end
      end
      object GrpBox_TabAudio7_Event: TGroupBox
        Left = 8
        Top = 128
        Width = 426
        Height = 121
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Event'
        TabOrder = 1
        DesignSize = (
          426
          121)
        object Lbl_Const_EventTime: TLabel
          Left = 8
          Top = 24
          Width = 22
          Height = 13
          Hint = 
            'Time when the birthday song should be played. The optional count' +
            'down will end at this time.'
          Caption = 'Time'
        end
        object lblBirthdayTitel: TLabel
          Left = 8
          Top = 48
          Width = 63
          Height = 13
          Caption = 'Birthdaysong'
        end
        object LblEventWarning: TLabel
          Left = 301
          Top = 48
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
        object DTPBirthdayTime: TDateTimePicker
          Left = 64
          Top = 20
          Width = 57
          Height = 21
          Hint = 
            'Time when the birthday song should be played. The optional count' +
            'down will end at this time.'
          Date = 39144.687500000000000000
          Time = 39144.687500000000000000
          Kind = dtkTime
          TabOrder = 0
        end
        object BtnBirthdaySong: TButton
          Left = 385
          Top = 64
          Width = 25
          Height = 21
          Hint = 'Select file'
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 2
          OnClick = BtnBirthdaySongClick
        end
        object BtnGetBirthdayTitel: TButton
          Left = 8
          Top = 88
          Width = 241
          Height = 21
          Hint = 'Use the current selected file in player as birthday song.'
          Caption = 'Use selected file in mainwindow'
          TabOrder = 3
          OnClick = BtnGetBirthdayTitelClick
        end
        object EditBirthdaySong: TEdit
          Left = 8
          Top = 64
          Width = 370
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = EditBirthdaySongChange
        end
      end
      object CBContinueAfter: TCheckBox
        Left = 16
        Top = 256
        Width = 417
        Height = 17
        Hint = 'Continue with the playlist after the birthday song.'
        Caption = 'Continue with the playlist after playing the birthdaysong'
        TabOrder = 2
      end
    end
    object TabAudio9: TTabSheet
      Caption = 'Audio6 (Scrobble)'
      ImageIndex = 17
      object GrpBox_Scrobble: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 113
        Caption = 'LastFM-Scrobbler Setup'
        TabOrder = 0
        object LblScrobble1: TLabel
          Left = 8
          Top = 16
          Width = 417
          Height = 57
          AutoSize = False
          Caption = 
            'Nemp can scrobble what you hear to your account on LastFM. To do' +
            ' this, Nemp needs your permission to access your account. Go onl' +
            'ine and click the button below to start the configuration.'
          WordWrap = True
        end
        object Image2: TImage
          Left = 344
          Top = 77
          Width = 80
          Height = 28
          Cursor = crHandPoint
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
        end
        object LblVisitLastFM: TLabel
          Left = 168
          Top = 84
          Width = 172
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'For details visit'
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
        Left = 8
        Top = 256
        Width = 433
        Height = 169
        Caption = 'Scrobble Log (this session)'
        TabOrder = 2
        DesignSize = (
          433
          169)
        object MemoScrobbleLog: TMemo
          Left = 8
          Top = 16
          Width = 417
          Height = 145
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            'MemoScrobbleLog')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object GrpBox_ScrobbleSettings: TGroupBox
        Left = 8
        Top = 128
        Width = 433
        Height = 121
        Caption = 'Scrobble Settings'
        TabOrder = 1
        object Label5: TLabel
          Left = 24
          Top = 72
          Width = 343
          Height = 13
          Caption = 
            'In case scrobbling was paused automatically and you fixed the re' +
            'ason: '
        end
        object CB_AlwaysScrobble: TCheckBox
          Left = 8
          Top = 16
          Width = 417
          Height = 17
          Hint = 'Always begin scrobbling when nemp starts.'
          Caption = 'Scrobble always'
          TabOrder = 0
        end
        object CB_SilentError: TCheckBox
          Left = 8
          Top = 48
          Width = 417
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
          Left = 8
          Top = 32
          Width = 417
          Height = 17
          Hint = 'Begin scrobbling now.'
          Caption = 'Scrobble this session'
          TabOrder = 1
        end
        object Btn_ScrobbleAgain: TButton
          Left = 24
          Top = 88
          Width = 97
          Height = 25
          Hint = 'Restart scrobbling.'
          Caption = 'Scrobble again!'
          TabOrder = 3
          OnClick = Btn_ScrobbleAgainClick
        end
      end
    end
    object TabAudio10: TTabSheet
      Caption = 'Audio7 (Webserver)'
      ImageIndex = 18
      DesignSize = (
        449
        443)
      object GrpBoxConfig: TGroupBox
        Left = 8
        Top = 8
        Width = 434
        Height = 170
        Caption = 'Configuration'
        TabOrder = 0
        object LblConst_Username2: TLabel
          Left = 16
          Top = 19
          Width = 48
          Height = 13
          Hint = 'Set username and password to access your library.'
          Caption = 'Username'
        end
        object LblConst_Password2: TLabel
          Left = 128
          Top = 19
          Width = 46
          Height = 13
          Hint = 'Set username and password to access your library'
          Caption = 'Password'
        end
        object BtnServerActivate: TButton
          Left = 250
          Top = 30
          Width = 129
          Height = 25
          Caption = 'Activate server'
          TabOrder = 2
          OnClick = BtnServerActivateClick
        end
        object cbOnlyLAN: TCheckBox
          Left = 16
          Top = 67
          Width = 393
          Height = 13
          Hint = 'Deny access to your library from "the internet".'
          Caption = 'Permit access only from LAN'
          TabOrder = 3
          OnClick = cbOnlyLANClick
        end
        object cbPermitLibraryAccess: TCheckBox
          Left = 16
          Top = 99
          Width = 393
          Height = 13
          Hint = 
            'Decide, whether searching and downloading files from your librar' +
            'y is allowed.'
          Caption = 'Permit access to the media library (read only)'
          TabOrder = 5
          OnClick = cbPermitLibraryAccessClick
        end
        object cbPermitPlaylistDownload: TCheckBox
          Left = 16
          Top = 83
          Width = 393
          Height = 13
          Hint = 'Decide, whether downloading files from your playlist is allowed.'
          Caption = 'Permit downloading files from the playlist'
          TabOrder = 4
          OnClick = cbPermitPlaylistDownloadClick
        end
        object cbAllowRemoteControl: TCheckBox
          Left = 16
          Top = 115
          Width = 393
          Height = 13
          Hint = 
            'Permit remote control like "play", "stop", "next file" of the pl' +
            'ayer.'
          Caption = 'Permit remote control of the player'
          TabOrder = 6
          OnClick = cbAllowRemoteControlClick
        end
        object EdtUsername: TEdit
          Left = 16
          Top = 35
          Width = 98
          Height = 21
          TabOrder = 0
          OnKeyPress = EdtUsernameKeyPress
        end
        object EdtPassword: TEdit
          Left = 128
          Top = 35
          Width = 98
          Height = 21
          TabOrder = 1
          OnKeyPress = EdtPasswordKeyPress
        end
        object CBAutoStartWebServer: TCheckBox
          Left = 16
          Top = 137
          Width = 393
          Height = 17
          Hint = 'Automatically activate the webserver when Nemp starts.'
          Caption = 'Activate webserver on start'
          TabOrder = 7
        end
      end
      object GrpBoxIP: TGroupBox
        Left = 8
        Top = 191
        Width = 434
        Height = 83
        Hint = 
          'Your IP-configuration. Tell your friends these IPs to access you' +
          'r library.'
        Caption = 'Own IP-addresses'
        TabOrder = 1
        object LblConst_IPWAN: TLabel
          Left = 153
          Top = 24
          Width = 86
          Height = 13
          Caption = 'Own IP (Internet)'
          Transparent = True
        end
        object LabelLANIP: TLabel
          Left = 16
          Top = 24
          Width = 121
          Height = 13
          AutoSize = False
          Caption = 'Own IP (LAN)'
          Transparent = True
        end
        object BtnGetIPs: TButton
          Left = 295
          Top = 34
          Width = 121
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
          Top = 40
          Width = 113
          Height = 21
          Hint = 'Your IP(s) inside the local area network (LAN).'
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          Items.Strings = (
            '')
        end
        object EdtGlobalIP: TEdit
          Left = 153
          Top = 40
          Width = 121
          Height = 21
          Hint = 
            'Your IP "in the internet". You have to configure your router and' +
            '/or firewall properly (e.g. forwarding Port80 to your machine) '
          ReadOnly = True
          TabOrder = 1
          Text = '?'
        end
      end
      object GrpBoxLog: TGroupBox
        Left = 8
        Top = 275
        Width = 434
        Height = 158
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Log'
        TabOrder = 2
        DesignSize = (
          434
          158)
        object WebServerLogMemo: TMemo
          Left = 4
          Top = 17
          Width = 422
          Height = 133
          Anchors = [akLeft, akTop, akRight, akBottom]
          Lines.Strings = (
            '')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object TabExtended0: TTabSheet
      Caption = 'Extended (Main)'
      ImageIndex = 21
      DesignSize = (
        449
        443)
      object GrpBox_ExtendedAudio: TGroupBox
        Left = 8
        Top = 8
        Width = 433
        Height = 161
        Caption = 'Extended audio settings'
        TabOrder = 0
        object LblConst_Buffersize: TLabel
          Left = 8
          Top = 16
          Width = 121
          Height = 13
          Hint = 'Increase this value, if the playback stutters sometimes.'
          AutoSize = False
          Caption = 'Buffer size'
        end
        object LblConst_ms: TLabel
          Left = 72
          Top = 36
          Width = 13
          Height = 13
          Hint = 'Increase this value, if the playback stutters sometimes.'
          Caption = 'ms'
        end
        object LblConst_UseFloatingPoint: TLabel
          Left = 8
          Top = 64
          Width = 121
          Height = 13
          Hint = 'Try to change this, if the playback is distorted.'
          AutoSize = False
          Caption = 'Floating-point channels'
        end
        object LblConst_Mixing: TLabel
          Left = 8
          Top = 112
          Width = 121
          Height = 13
          Hint = 'Try to change this, if the playback is distorted.'
          AutoSize = False
          Caption = 'Mixing'
        end
        object Lbl_FloatingPoints_Status: TLabel
          Left = 160
          Top = 84
          Width = 12
          Height = 13
          Hint = 'Try to change this, if the playback is distorted.'
          Caption = '...'
        end
        object SEBufferSize: TSpinEdit
          Left = 8
          Top = 32
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
          Left = 8
          Top = 80
          Width = 145
          Height = 21
          Hint = 'Try to change this, if the playback is distorted.'
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'Auto-detect'
          Items.Strings = (
            'Auto-detect'
            'Off'
            'On')
        end
        object CB_Mixing: TComboBox
          Left = 8
          Top = 128
          Width = 145
          Height = 21
          Hint = 'Try to change this, if the playback is distorted.'
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 2
          Text = 'Hardware'
          Items.Strings = (
            'Hardware'
            'Software')
        end
      end
      object GrpBox_Hibernate: TGroupBox
        Left = 7
        Top = 174
        Width = 434
        Height = 108
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Hibernate/standby'
        TabOrder = 1
        object LBlConst_ReInitPlayerEngine_Hint: TLabel
          Left = 28
          Top = 48
          Width = 142
          Height = 13
          Hint = 
            'Use this, if the playback don'#39't work after hibernating the syste' +
            'm.'
          Caption = '(necessary on some systems)'
        end
        object cbPauseOnSuspend: TCheckBox
          Left = 8
          Top = 16
          Width = 409
          Height = 17
          Hint = 
            'Stop the player when the system hibernates, so the playback is s' +
            'topped when the PC is turned on again.'
          Caption = 'Stop player when systems hibernates'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object cbReInitAfterSuspend: TCheckBox
          Left = 8
          Top = 32
          Width = 393
          Height = 17
          Hint = 
            'Use this, if the playback don'#39't work after hibernating the syste' +
            'm.'
          Caption = 'Reinit player engine on wakeup'
          TabOrder = 1
          WordWrap = True
        end
        object Btn_ReinitPlayerEngine: TButton
          Left = 28
          Top = 72
          Width = 161
          Height = 25
          Hint = 'Reinit player engine now.'
          Caption = 'Reinit player engine now'
          TabOrder = 2
          OnClick = Btn_ReinitPlayerEngineClick
        end
      end
      object GrpBox_BetaOptions: TGroupBox
        Left = 8
        Top = 288
        Width = 433
        Height = 62
        Caption = 'Beta-Settings'
        TabOrder = 2
        Visible = False
        object XXX_CB_BetaDontUseThreadedUpdate: TCheckBox
          Left = 13
          Top = 15
          Width = 417
          Height = 17
          Hint = 'Beta-Settings. Do not change, unless you know what yo are doing!'
          Caption = 'Update library in Mainthread'
          TabOrder = 0
        end
        object XXX_cb_UseClassicCoverflow: TCheckBox
          Left = 13
          Top = 33
          Width = 214
          Height = 17
          Hint = 'Beta-Settings. Do not change, unless you know what yo are doing!'
          Caption = 'Use classic coverflow'
          TabOrder = 1
        end
      end
    end
    object TabExtended1: TTabSheet
      Caption = 'Ext1 (Search Options)'
      ImageIndex = 25
      DesignSize = (
        449
        443)
      object GrpBox_TabMedia4_GlobalSearchOptions: TGroupBox
        Left = 8
        Top = 8
        Width = 434
        Height = 153
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Global search options'
        TabOrder = 0
        DesignSize = (
          434
          153)
        object LblConst_AccelerateSearchNote: TLabel
          Left = 24
          Top = 32
          Width = 394
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Note: This will decrease the required time, but will increase th' +
            'e reqired memory (approx. 1mb/4.000 files).'
          WordWrap = True
        end
        object LblConst_AccelerateSearchNote2: TLabel
          Left = 40
          Top = 96
          Width = 378
          Height = 33
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Note: This will affect the search results of "Quicksearch" and "' +
            'General search".'
          WordWrap = True
        end
        object CB_AccelerateSearch: TCheckBox
          Left = 8
          Top = 16
          Width = 410
          Height = 17
          Hint = 'Use some tricky algorithms to accelerate the search.'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Accelerate search'
          TabOrder = 0
          OnClick = CB_AccelerateSearchClick
        end
        object CB_AccelerateSearchIncludePath: TCheckBox
          Left = 24
          Top = 64
          Width = 394
          Height = 17
          Hint = 'Include filenames to the accelerated search algorithms.'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Including filenames'
          TabOrder = 1
        end
        object CB_AccelerateSearchIncludeComment: TCheckBox
          Left = 24
          Top = 80
          Width = 394
          Height = 17
          Hint = 'Include comments to the accelerated search algorithms.'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Including comments'
          TabOrder = 2
        end
        object CB_AccelerateLyricSearch: TCheckBox
          Left = 8
          Top = 128
          Width = 410
          Height = 17
          Hint = 'Use some tricky algorithms to accelerate the search for lyrics.'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Accelerate lyrics search'
          TabOrder = 3
        end
      end
      object GrpBox_TabMedia4_QuickSearchOptions: TGroupBox
        Left = 7
        Top = 168
        Width = 434
        Height = 129
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Quicksearch options'
        TabOrder = 1
        DesignSize = (
          434
          129)
        object LblConst_QuickSearchNote: TLabel
          Left = 24
          Top = 64
          Width = 378
          Height = 41
          Hint = 'Activate this settings only if your machine is fast enough.'
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Note: Accelerated search is strongly recommended if one of these' +
            ' options is activated. The last one is not recommended unless yo' +
            'ur medialibrary is not too big or your computer is really fast.'
          WordWrap = True
        end
        object CB_QuickSearchWhileYouType: TCheckBox
          Left = 8
          Top = 16
          Width = 410
          Height = 17
          Hint = 
            'Show search results in "real time" or just after pressing the "e' +
            'nter"-key.'
          Anchors = [akLeft, akTop, akRight]
          Caption = '"While you type"'
          TabOrder = 0
        end
        object CB_QuickSearchAllowErrorsWhileTyping: TCheckBox
          Left = 8
          Top = 48
          Width = 410
          Height = 17
          Hint = 
            'Always use a fuzzy search (e.g. show files from "Amy MacDonald" ' +
            'when you search for "Amy McDonald")'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Allow errors while typing'
          TabOrder = 2
        end
        object CB_QuickSearchAllowErrorsOnEnter: TCheckBox
          Left = 8
          Top = 32
          Width = 410
          Height = 17
          Hint = 
            'Do a fuzzy search after pressing "enter" (e.g. show files from "' +
            'Amy MacDonald" when you search for "Amy McDonald")'
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Allow errors on [Enter]'
          TabOrder = 1
        end
      end
    end
    object TabExtended2: TTabSheet
      Caption = 'Ext2 (Unicode)'
      ImageIndex = 23
      DesignSize = (
        449
        443)
      object GrpBox_TabMedia5_ID3: TGroupBox
        Left = 8
        Top = 8
        Width = 431
        Height = 65
        Anchors = [akLeft, akTop, akRight]
        Caption = 'ID3-tags'
        TabOrder = 0
        object CBAlwaysWriteUnicode: TCheckBox
          Left = 8
          Top = 16
          Width = 409
          Height = 17
          Hint = 'If you don'#39't know what this means: Just let it unchecked. ;-)'
          Caption = 'Always write Unicode in ID3v2-tags'
          TabOrder = 0
        end
        object CBAutoDetectCharCode: TCheckBox
          Left = 8
          Top = 40
          Width = 409
          Height = 17
          Hint = 
            'Use a uber-ingenious special method for better tag-reading in fi' +
            'les with "unicode-filenames".'
          Caption = 'Auto-detect (probably) used charset'
          TabOrder = 1
        end
      end
      object GrpBox_TabMedia5_Charsets: TGroupBox
        Left = 8
        Top = 78
        Width = 432
        Height = 211
        Hint = 'Adjust charset-detection.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Charsets for auto-detection'
        TabOrder = 1
        object LblConst_Arabic: TLabel
          Left = 8
          Top = 16
          Width = 30
          Height = 13
          Caption = 'Arabic'
        end
        object LblConst_hebrew: TLabel
          Left = 8
          Top = 160
          Width = 37
          Height = 13
          Caption = 'Hebrew'
        end
        object LblConst_cyrillic: TLabel
          Left = 224
          Top = 112
          Width = 30
          Height = 13
          Caption = 'Cyrillic'
        end
        object LblConst_Thai: TLabel
          Left = 224
          Top = 160
          Width = 20
          Height = 13
          Caption = 'Thai'
        end
        object LblConst_Korean: TLabel
          Left = 224
          Top = 64
          Width = 34
          Height = 13
          Caption = 'Korean'
        end
        object LblConst_Chinese: TLabel
          Left = 8
          Top = 64
          Width = 38
          Height = 13
          Caption = 'Chinese'
        end
        object LblConst_Greek: TLabel
          Left = 8
          Top = 112
          Width = 28
          Height = 13
          Caption = 'Greek'
        end
        object LblConst_Japanese: TLabel
          Left = 224
          Top = 16
          Width = 46
          Height = 13
          Caption = 'Japanese'
        end
        object CBArabic: TComboBox
          Left = 8
          Top = 32
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object CBChinese: TComboBox
          Left = 8
          Top = 80
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
        object CBHebrew: TComboBox
          Left = 8
          Top = 176
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
        end
        object CBJapanese: TComboBox
          Left = 224
          Top = 32
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
        end
        object CBGreek: TComboBox
          Left = 8
          Top = 128
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
        end
        object CBKorean: TComboBox
          Left = 224
          Top = 80
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
        end
        object CBCyrillic: TComboBox
          Left = 224
          Top = 128
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
        end
        object CBThai: TComboBox
          Left = 224
          Top = 176
          Width = 200
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 7
        end
      end
    end
  end
  object BTNApply: TButton
    Left = 582
    Top = 555
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Apply'
    TabOrder = 2
    OnClick = BTNApplyClick
  end
  object BTNCancel: TButton
    Left = 502
    Top = 555
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = BTNCancelClick
  end
  object BTNok: TButton
    Left = 422
    Top = 555
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    TabOrder = 4
    OnClick = BTNokClick
  end
  object ColorDialog1: TColorDialog
    Left = 104
    Top = 308
  end
  object OpenDlg_CountdownSongs: TOpenDialog
    Left = 112
    Top = 232
  end
  object OpenDlg_DefaultCover: TOpenPictureDialog
    Left = 112
    Top = 376
  end
  object IDHttpWebServerGetIP: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 624
    Top = 88
  end
end
