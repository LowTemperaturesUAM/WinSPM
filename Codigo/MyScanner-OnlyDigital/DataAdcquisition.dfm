object Form10: TForm10
  Left = -7
  Top = 867
  Width = 1857
  Height = 171
  Caption = 'DAC and ADC handling'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 22
    Height = 13
    Caption = 'DAC'
  end
  object Label2: TLabel
    Left = 90
    Top = 18
    Width = 22
    Height = 13
    Caption = 'ADC'
  end
  object Label3: TLabel
    Left = 344
    Top = 18
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label4: TLabel
    Left = 159
    Top = 18
    Width = 51
    Height = 13
    Caption = 'Mean over'
  end
  object Label5: TLabel
    Left = 1083
    Top = 16
    Width = 6
    Height = 13
    Alignment = taRightJustify
    Caption = '0'
  end
  object Label6: TLabel
    Left = 1096
    Top = 16
    Width = 7
    Height = 13
    Caption = 'V'
  end
  object Label7: TLabel
    Left = 1304
    Top = 16
    Width = 62
    Height = 13
    Caption = 'Not saving'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 1720
    Top = 16
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Button1: TButton
    Left = 8
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Initialize All'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 14
    Width = 57
    Height = 22
    Caption = 'Read'
    TabOrder = 1
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 119
    Top = 14
    Width = 33
    Height = 22
    MaxValue = 7
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 40
    Top = 51
    Width = 33
    Height = 22
    MaxValue = 7
    MinValue = 0
    TabOrder = 3
    Value = 6
  end
  object ScrollBar1: TScrollBar
    Left = 87
    Top = 51
    Width = 1700
    Height = 22
    LargeChange = 100
    Max = 32767
    Min = -32767
    PageSize = 0
    TabOrder = 4
    OnChange = ScrollBar1Change
  end
  object SpinEdit3: TSpinEdit
    Left = 216
    Top = 14
    Width = 49
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 5
    Value = 10
  end
  object Button3: TButton
    Left = 896
    Top = 10
    Width = 81
    Height = 25
    Caption = 'DAC to 0'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 1384
    Top = 8
    Width = 137
    Height = 33
    Caption = 'Save ADC data'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 1536
    Top = 8
    Width = 57
    Height = 33
    Cursor = crArrow
    Caption = 'STOP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button5Click
  end
  object Edit1: TEdit
    Left = 1600
    Top = 14
    Width = 113
    Height = 21
    TabOrder = 9
    Text = 'Test'
    OnChange = Edit1Change
  end
  object tmr55: TTimer
    Enabled = False
    Interval = 10
    Left = 528
    Top = 8
  end
end
