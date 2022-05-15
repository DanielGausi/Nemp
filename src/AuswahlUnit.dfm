object AuswahlForm: TAuswahlForm
  Left = 401
  Top = 118
  Anchors = [akTop, akRight]
  BorderStyle = bsNone
  ClientHeight = 422
  ClientWidth = 411
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 13
  object ContainerPanelAuswahlform: TNempPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 411
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnMouseDown = ContainerPanelAuswahlformMouseDown
    OnMouseMove = ContainerPanelAuswahlformMouseMove
    OnMouseUp = ContainerPanelAuswahlformMouseUp
    Ratio = 0
    OnPaint = ContainerPanelAuswahlformPaint
    OwnerDraw = False
    DesignSize = (
      411
      422)
    object CloseImageA: TSkinButton
      Left = 399
      Top = 0
      Width = 12
      Height = 12
      Hint = 'Close browse window'
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = CloseImageAClick
      DrawMode = dm_Skin
      NumGlyphsX = 5
      NumGlyphsY = 1
      GlyphLine = 0
      CustomRegion = False
      FocusDrawMode = fdm_Windows
      Color1 = clBlack
      Color2 = clBlack
    end
    object pnlSplit: TPanel
      AlignWithMargins = True
      Left = 7
      Top = 2
      Width = 397
      Height = 413
      Margins.Left = 7
      Margins.Top = 2
      Margins.Right = 7
      Margins.Bottom = 7
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
end
