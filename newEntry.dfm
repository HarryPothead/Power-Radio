object frmNewGroup: TfrmNewGroup
  Left = 740
  Top = 519
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Name'
  ClientHeight = 85
  ClientWidth = 226
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 8
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnClose: TButton
    Left = 142
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object LabeledEdit1: TLabeledEdit
    Left = 48
    Top = 8
    Width = 169
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Name : '
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clWindowText
    EditLabel.Font.Height = -11
    EditLabel.Font.Name = 'Tahoma'
    EditLabel.Font.Style = [fsBold]
    EditLabel.ParentFont = False
    LabelPosition = lpLeft
    TabOrder = 0
  end
end
