object ExtendedControlForm: TExtendedControlForm
  Left = 0
  Top = 0
  Anchors = [akTop, akRight]
  BorderStyle = bsNone
  Caption = 'ExtendedControlForm'
  ClientHeight = 200
  ClientWidth = 400
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ContainerPanelExtendedControlsForm: TNempPanel
    Tag = 6
    Left = 0
    Top = 0
    Width = 400
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = ContainerPanelExtendedControlsFormMouseDown
    OnMouseMove = ContainerPanelExtendedControlsFormMouseMove
    OnMouseUp = ContainerPanelExtendedControlsFormMouseUp
    OnPaint = ContainerPanelExtendedControlsFormPaint
    OwnerDraw = False
    DesignSize = (
      400
      200)
    object CloseImageE: TSkinButton
      Left = 388
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImageEClick
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
