object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  Caption = 'About'
  ClientHeight = 231
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmoMainMemo: TMemo
    Left = 0
    Top = 0
    Width = 505
    Height = 231
    Align = alClient
    Lines.Strings = (
      'mmoMainMemo')
    ParentShowHint = False
    ReadOnly = True
    ScrollBars = ssVertical
    ShowHint = False
    TabOrder = 0
  end
end