object AuswahlForm: TAuswahlForm
  Left = 401
  Top = 118
  Anchors = [akTop, akRight]
  BorderStyle = bsNone
  ClientHeight = 422
  ClientWidth = 411
  Color = clBtnFace
  Constraints.MinHeight = 150
  Constraints.MinWidth = 222
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ContainerPanelAuswahlform: TNempPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 411
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = ContainerPanelAuswahlformMouseDown
    OnMouseMove = ContainerPanelAuswahlformMouseMove
    OnMouseUp = ContainerPanelAuswahlformMouseUp
    OnPaint = ContainerPanelAuswahlformPaint
    OwnerDraw = False
    DesignSize = (
      411
      422)
    object CloseImage: TSkinButton
      Left = 399
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close browse window'
      Anchors = [akTop, akRight]
      DoubleBuffered = True
      ParentDoubleBuffered = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImageClick
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
