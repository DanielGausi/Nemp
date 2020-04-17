object NewFavoritePlaylistForm: TNewFavoritePlaylistForm
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'New favorite playlist'
  ClientHeight = 176
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    405
    176)
  PixelsPerInch = 96
  TextHeight = 13
  object edit_PlaylistName: TLabeledEdit
    AlignWithMargins = True
    Left = 16
    Top = 32
    Width = 377
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 62
    EditLabel.Height = 13
    EditLabel.Caption = 'Playlist name'
    TabOrder = 0
    OnChange = edit_PlaylistNameChange
    ExplicitWidth = 385
  end
  object edit_PlaylistFilename: TLabeledEdit
    AlignWithMargins = True
    Left = 16
    Top = 80
    Width = 377
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Filename'
    Enabled = False
    TabOrder = 1
    OnChange = edit_PlaylistFilenameChange
    ExplicitWidth = 385
  end
  object cb_AutoCreateFilename: TCheckBox
    AlignWithMargins = True
    Left = 16
    Top = 107
    Width = 377
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Automatically choose filename'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = cb_AutoCreateFilenameClick
    ExplicitWidth = 402
  end
  object BtnOK: TButton
    AlignWithMargins = True
    Left = 318
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 3
    ExplicitLeft = 304
    ExplicitTop = 139
  end
  object BtnCancel: TButton
    AlignWithMargins = True
    Left = 224
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
    ExplicitLeft = 210
    ExplicitTop = 139
  end
end
