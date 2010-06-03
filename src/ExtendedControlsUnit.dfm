object ExtendedControlForm: TExtendedControlForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'ExtendedControlForm'
  ClientHeight = 188
  ClientWidth = 234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ContainerPanelExtendedControlsForm: TNempPanel
    Tag = 6
    Left = 0
    Top = 0
    Width = 234
    Height = 188
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnPaint = ContainerPanelExtendedControlsFormPaint
    OwnerDraw = False
    DesignSize = (
      234
      188)
    object CloseImage: TSkinButton
      Left = 222
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close medialist window'
      Anchors = [akTop, akRight]
      DoubleBuffered = True
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
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
