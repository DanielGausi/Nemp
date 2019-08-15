object FormEffectsAndEqualizer: TFormEffectsAndEqualizer
  AlignWithMargins = True
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Nemp: Equalizer and effects'
  ClientHeight = 301
  ClientWidth = 891
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnMouseDown = TrackBarMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GRPBOXEqualizer: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 426
    Height = 250
    Caption = 'Equalizer'
    TabOrder = 0
    object EQLBL1: TLabel
      Left = 21
      Top = 173
      Width = 12
      Height = 13
      Caption = '30'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL10: TLabel
      Left = 378
      Top = 173
      Width = 18
      Height = 13
      Caption = '16K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL2: TLabel
      Left = 61
      Top = 173
      Width = 12
      Height = 13
      Caption = '60'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL3: TLabel
      Left = 99
      Top = 173
      Width = 18
      Height = 13
      Caption = '120'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL4: TLabel
      Left = 138
      Top = 173
      Width = 18
      Height = 13
      Caption = '250'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL5: TLabel
      Left = 178
      Top = 173
      Width = 18
      Height = 13
      Caption = '500'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL6: TLabel
      Left = 221
      Top = 173
      Width = 12
      Height = 13
      Caption = '1K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL7: TLabel
      Left = 261
      Top = 173
      Width = 12
      Height = 13
      Caption = '2K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL8: TLabel
      Left = 301
      Top = 173
      Width = 12
      Height = 13
      Caption = '4K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object EQLBL9: TLabel
      Left = 338
      Top = 173
      Width = 18
      Height = 13
      Caption = '12K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Pitch = fpVariable
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object tbEQ0: TNempTrackBar
      Left = 8
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 0
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ1: TNempTrackBar
      Tag = 1
      Left = 48
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ2: TNempTrackBar
      Tag = 2
      Left = 88
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 2
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ3: TNempTrackBar
      Tag = 3
      Left = 128
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 3
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ4: TNempTrackBar
      Tag = 4
      Left = 168
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 4
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ5: TNempTrackBar
      Tag = 5
      Left = 208
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 5
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ6: TNempTrackBar
      Tag = 6
      Left = 248
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 6
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ7: TNempTrackBar
      Tag = 7
      Left = 288
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 7
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ8: TNempTrackBar
      Tag = 8
      Left = 328
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 8
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object tbEQ9: TNempTrackBar
      Tag = 9
      Left = 368
      Top = 24
      Width = 40
      Height = 150
      Max = 100
      Min = -100
      Orientation = trVertical
      TabOrder = 9
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEQ0Change
      OnMouseDown = TrackBarMouseDown
    end
    object Btn_EqualizerPresets: TButton
      Left = 237
      Top = 210
      Width = 126
      Height = 25
      Caption = 'Select'
      PopupMenu = Equalizer_PopupMenu
      TabOrder = 10
      OnClick = Btn_EqualizerPresetsClick
    end
    object ButtonPrevEQ: TButton
      Left = 363
      Top = 210
      Width = 25
      Height = 25
      Hint = 'Previous preset'
      Caption = '<'
      TabOrder = 11
      OnClick = ButtonPrevEQClick
    end
    object ButtonNextEQ: TButton
      Tag = 1
      Left = 388
      Top = 210
      Width = 25
      Height = 25
      Hint = 'Next preset'
      Caption = '>'
      TabOrder = 12
      OnClick = ButtonPrevEQClick
    end
    object BtnDisableEqualizer: TButton
      Left = 16
      Top = 210
      Width = 129
      Height = 25
      Hint = 'Disable equalizer'
      Caption = 'Disable equalizer'
      TabOrder = 13
      OnClick = PM_EQ_DisabledClick
    end
  end
  object GrpBoxHall: TGroupBox
    AlignWithMargins = True
    Left = 440
    Top = 8
    Width = 217
    Height = 250
    Caption = 'Reverb and echo'
    TabOrder = 1
    object HallLBL: TLabel
      Left = 171
      Top = 37
      Width = 12
      Height = 13
      Caption = '...'
      Transparent = True
    end
    object EchoTimeLBL: TLabel
      Left = 171
      Top = 138
      Width = 12
      Height = 13
      Caption = '...'
      Transparent = True
    end
    object EchoMixLBL: TLabel
      Left = 171
      Top = 98
      Width = 12
      Height = 13
      Caption = '...'
      Transparent = True
    end
    object tbReverb: TNempTrackBar
      Left = 16
      Top = 24
      Width = 150
      Height = 40
      Hint = 'Reverb'
      Max = 0
      Min = -96
      Position = -2
      TabOrder = 0
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbReverbChange
      OnMouseDown = tbReverbMouseDown
    end
    object tbEchoTime: TNempTrackBar
      Left = 16
      Top = 126
      Width = 150
      Height = 40
      Hint = 'Echo delay'
      Max = 2000
      Min = 100
      Position = 100
      TabOrder = 2
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbEchoTimeChange
      OnMouseDown = tbEchoTimeMouseDown
    end
    object tbWetDryMix: TNempTrackBar
      Left = 16
      Top = 86
      Width = 150
      Height = 40
      Hint = 'Echo mix'
      Max = 50
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbWetDryMixChange
      OnMouseDown = tbWetDryMixMouseDown
    end
    object Btn_EffectsOff: TBitBtn
      Left = 16
      Top = 210
      Width = 129
      Height = 25
      Hint = 'Disable effects'
      Caption = 'Disable effects'
      TabOrder = 3
      OnClick = Btn_EffectsOffClick
    end
  end
  object grpBoxPlayback: TGroupBox
    AlignWithMargins = True
    Left = 663
    Top = 8
    Width = 210
    Height = 178
    Caption = 'Playback'
    TabOrder = 2
    object SampleRateLBL: TLabel
      Left = 171
      Top = 85
      Width = 12
      Height = 13
      Caption = '...'
      Transparent = True
    end
    object DirectionPositionBTN: TButton
      Left = 16
      Top = 25
      Width = 150
      Height = 25
      Hint = 'Play backwards'
      Caption = 'Play backwards'
      TabOrder = 0
      OnClick = __DirectionPositionBTNClick
    end
    object tbSpeed: TNempTrackBar
      Left = 15
      Top = 72
      Width = 150
      Height = 40
      Hint = 'Playback speed'
      Max = 100
      Min = -100
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsManual
      OnChange = tbSpeedChange
      OnMouseDown = tbSpeedMouseDown
    end
    object BitBtn1: TBitBtn
      Left = 16
      Top = 137
      Width = 129
      Height = 25
      Hint = 'Disable effects'
      Caption = 'Disable effects'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object grpBoxABRepeat: TGroupBox
    AlignWithMargins = True
    Left = 663
    Top = 192
    Width = 210
    Height = 66
    Caption = 'A-B repeat'
    TabOrder = 3
    object BtnABRepeatSetA: TButton
      Left = 16
      Top = 24
      Width = 49
      Height = 25
      Hint = 'Set start point for A-B repeat'
      Caption = '[ A ]'
      TabOrder = 0
      OnClick = BtnABRepeatSetAClick
    end
    object BtnABRepeatSetB: TButton
      Left = 71
      Top = 24
      Width = 49
      Height = 25
      Hint = 'Set end point for A-B repeat'
      Caption = '[ B ]'
      TabOrder = 1
      OnClick = BtnABRepeatSetBClick
    end
    object BtnABRepeatUnset: TButton
      Left = 151
      Top = 24
      Width = 49
      Height = 25
      Hint = 'Disable A-B repeat'
      Caption = 'Off'
      TabOrder = 2
      OnClick = BtnABRepeatUnsetClick
    end
  end
  object BtnClose: TButton
    Left = 752
    Top = 267
    Width = 121
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = BtnCloseClick
  end
  object Equalizer_PopupMenu: TPopupMenu
    AutoHotkeys = maManual
    Left = 183
    Top = 207
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
end
