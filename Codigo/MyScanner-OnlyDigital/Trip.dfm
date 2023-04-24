object Form5: TForm5
  Left = 57
  Top = 673
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Coarse Aproach'
  ClientHeight = 175
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 120
    Width = 31
    Height = 13
    Caption = 'Speed'
  end
  object Label2: TLabel
    Left = 16
    Top = 152
    Width = 20
    Height = 13
    Caption = 'Size'
  end
  object Label5: TLabel
    Left = 200
    Top = 120
    Width = 24
    Height = 13
    Caption = '1000'
  end
  object Label6: TLabel
    Left = 200
    Top = 152
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label8: TLabel
    Left = 16
    Top = 88
    Width = 77
    Height = 13
    Caption = 'Number of steps'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 105
    Height = 25
    Caption = 'Approach'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 16
    Width = 89
    Height = 25
    Caption = 'Separate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 232
    Top = 48
    Width = 89
    Height = 25
    Caption = 'Separate 100'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 48
    Width = 105
    Height = 25
    Caption = 'Auto Approach'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button4Click
  end
  object Spinedit1: TSpinEdit
    Left = 136
    Top = 84
    Width = 65
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -5
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 10000
    MinValue = 1
    ParentFont = False
    TabOrder = 4
    Value = 1
    OnChange = Spinedit1Change
  end
  object ScrollBar1: TScrollBar
    Left = 72
    Top = 120
    Width = 121
    Height = 17
    LargeChange = 10
    Max = 1000
    Min = 10
    PageSize = 0
    Position = 1000
    TabOrder = 5
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 72
    Top = 152
    Width = 121
    Height = 17
    Max = 10
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 6
    OnChange = ScrollBar2Change
  end
  object Button5: TButton
    Left = 240
    Top = 84
    Width = 75
    Height = 22
    Caption = 'Config'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 128
    Top = 16
    Width = 97
    Height = 57
    Caption = 'STOP IT'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clFuchsia
    Font.Height = -16
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 102
    Top = 84
    Width = 33
    Height = 22
    Caption = '/10'
    TabOrder = 9
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 200
    Top = 84
    Width = 33
    Height = 22
    Caption = 'x10'
    TabOrder = 10
    OnClick = Button8Click
  end
end
