object frmNewChannel: TfrmNewChannel
  Left = 660
  Top = 457
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'New Channel'
  ClientHeight = 122
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 89
    Top = 83
    Width = 149
    Height = 25
    Caption = 'Copy URL from Clipboard'
    TabOrder = 4
    OnClick = btn1Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 56
    Top = 8
    Width = 257
    Height = 21
    EditLabel.Width = 38
    EditLabel.Height = 13
    EditLabel.Caption = 'Name: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 0
  end
  object LabeledEdit2: TLabeledEdit
    Left = 56
    Top = 48
    Width = 257
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'URL: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    LabelPosition = lpLeft
    ParentFont = False
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 8
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnClose: TButton
    Left = 244
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
end
