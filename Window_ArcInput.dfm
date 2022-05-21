object Window_Input: TWindow_Input
  Left = 0
  Top = 0
  Caption = 'Window_Input'
  ClientHeight = 85
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlButtomPanel: TPanel
    Left = 0
    Top = 44
    Width = 229
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnOk: TButton
      Left = 139
      Top = 1
      Width = 89
      Height = 39
      HelpType = htKeyword
      HelpKeyword = 'Enter'#13#10
      Align = alRight
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnKeyDown = btnOkKeyDown
      OnMouseDown = btnOkMouseDown
    end
    object btnCancel: TButton
      Left = 1
      Top = 1
      Width = 89
      Height = 39
      Align = alLeft
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
    end
  end
  object pnlTopPanel: TPanel
    Left = 0
    Top = 0
    Width = 229
    Height = 44
    Align = alClient
    TabOrder = 1
    DesignSize = (
      229
      44)
    object lbledtWeight: TLabeledEdit
      Left = 0
      Top = 0
      Width = 229
      Height = 21
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      EditLabel.Width = 60
      EditLabel.Height = 13
      EditLabel.Caption = 'lbledtWeight'
      TabOrder = 0
    end
  end
end
