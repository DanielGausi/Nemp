object NewFavoritePlaylistForm: TNewFavoritePlaylistForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'New favorite playlist'
  ClientHeight = 186
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    371
    186)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_Hint: TLabel
    AlignWithMargins = True
    Left = 16
    Top = 165
    Width = 343
    Height = 13
    Alignment = taRightJustify
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'Check: Ok'
    ExplicitTop = 173
    ExplicitWidth = 377
  end
  object edit_PlaylistDescription: TLabeledEdit
    AlignWithMargins = True
    Left = 16
    Top = 32
    Width = 343
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 62
    EditLabel.Height = 13
    EditLabel.Caption = 'Playlist name'
    TabOrder = 0
    OnChange = edit_PlaylistDescriptionChange
    ExplicitWidth = 377
  end
  object edit_PlaylistFilename: TLabeledEdit
    AlignWithMargins = True
    Left = 16
    Top = 80
    Width = 343
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Filename'
    Enabled = False
    TabOrder = 1
    OnChange = edit_PlaylistFilenameChange
    ExplicitWidth = 377
  end
  object cb_AutoCreateFilename: TCheckBox
    AlignWithMargins = True
    Left = 16
    Top = 107
    Width = 343
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Automatically choose filename'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = cb_AutoCreateFilenameClick
    ExplicitWidth = 377
  end
  object BtnOK: TButton
    AlignWithMargins = True
    Left = 288
    Top = 134
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
    ExplicitLeft = 331
    ExplicitTop = 138
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 194
    Top = 134
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
    ExplicitLeft = 237
    ExplicitTop = 138
  end
end
