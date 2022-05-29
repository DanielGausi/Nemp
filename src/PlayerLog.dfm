object PlayerLogForm: TPlayerLogForm
  Left = 0
  Top = 0
  Caption = 'Nemp: Player logfile'
  ClientHeight = 263
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MinHeight = 150
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    584
    263)
  TextHeight = 13
  object BtnClose: TButton
    Left = 478
    Top = 230
    Width = 98
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = BtnCloseClick
  end
  object BtnSettings: TButton
    Left = 366
    Top = 230
    Width = 98
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Settings'
    TabOrder = 1
    OnClick = BtnSettingsClick
  end
  object vstPlayerLog: TVirtualStringTree
    Left = 8
    Top = 8
    Width = 568
    Height = 216
    Anchors = [akLeft, akTop, akRight, akBottom]
    Colors.UnfocusedSelectionColor = clHighlight
    Colors.UnfocusedSelectionBorderColor = clHighlight
    Header.AutoSizeIndex = 0
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Indent = 0
    TabOrder = 2
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnGetText = vstPlayerLogGetText
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <
      item
        Position = 0
        Text = 'Time'
        Width = 85
      end
      item
        Position = 1
        Text = 'Title'
        Width = 120
      end
      item
        Position = 2
        Text = 'Artist'
        Width = 96
      end
      item
        Position = 3
        Text = 'Filename'
        Width = 148
      end
      item
        Position = 4
        Text = 'Remark'
        Width = 69
      end>
  end
  object cbSessionSelect: TComboBox
    Left = 8
    Top = 230
    Width = 249
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemIndex = 0
    TabOrder = 3
    Text = 'Current session'
    OnChange = cbSessionSelectChange
    Items.Strings = (
      'Current session'
      'Previous sessions (from logfile)')
  end
end
