object BirthdayForm: TBirthdayForm
  Left = 537
  Top = 348
  BorderStyle = bsSingle
  Caption = 'Nemp: Event-mode'
  ClientHeight = 172
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_Congratulations: TLabel
    Left = 8
    Top = 16
    Width = 309
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = 'Congratulations!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 64
    Width = 301
    Height = 49
    AutoSize = False
    Caption = 
      'You have activated the event-mode of Nemp. The playlist was paus' +
      'ed automatically.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 112
    Width = 301
    Height = 41
    AutoSize = False
    Caption = 'Close this window to continue with the normal playlist.'
    WordWrap = True
  end
end
