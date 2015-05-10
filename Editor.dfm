object frmEditor: TfrmEditor
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Channel Editor'
  ClientHeight = 439
  ClientWidth = 402
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Groups'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 175
    Top = 8
    Width = 51
    Height = 13
    Caption = 'Channels'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBoxGroups: TListBox
    Left = 8
    Top = 27
    Width = 161
    Height = 334
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBoxGroupsClick
  end
  object ListBoxSender: TListBox
    Left = 175
    Top = 27
    Width = 217
    Height = 334
    ItemHeight = 13
    TabOrder = 2
  end
  object btnNewGroup: TButton
    Left = 8
    Top = 367
    Width = 65
    Height = 25
    Caption = 'New Group'
    TabOrder = 3
    OnClick = btnNewGroupClick
  end
  object btnDelGroup: TButton
    Left = 97
    Top = 367
    Width = 72
    Height = 25
    Caption = 'Delete Group'
    TabOrder = 4
    OnClick = btnDelGroupClick
  end
  object btnNewChannel: TButton
    Left = 175
    Top = 367
    Width = 89
    Height = 25
    Caption = 'New Channel'
    TabOrder = 5
    OnClick = btnNewChannelClick
  end
  object btnDelChannel: TButton
    Left = 295
    Top = 367
    Width = 97
    Height = 25
    Caption = 'Delete Channel'
    TabOrder = 6
    OnClick = btnDelChannelClick
  end
  object btnClose: TButton
    Left = 168
    Top = 408
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
end
