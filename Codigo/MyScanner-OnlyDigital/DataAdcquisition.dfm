object DataForm: TDataForm
  Left = 12
  Top = 282
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DAC and ADC handling'
  ClientHeight = 131
  ClientWidth = 1366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
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
    Left = 803
    Top = 16
    Width = 6
    Height = 13
    Alignment = taRightJustify
    Caption = '0'
  end
  object Label6: TLabel
    Left = 816
    Top = 16
    Width = 7
    Height = 13
    Caption = 'V'
  end
  object Label7: TLabel
    Left = 920
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
    Left = 1336
    Top = 16
    Width = 6
    Height = 13
    Caption = '1'
  end
  object SetDACCorrLbl: TLabel
    Left = 128
    Top = 94
    Width = 71
    Height = 13
    AutoSize = False
    Caption = 'DAC Number'
  end
  object OffsetVoltLbl: TLabel
    Left = 328
    Top = 94
    Width = 50
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0 mV'
  end
  object GainVoltLbl: TLabel
    Left = 544
    Top = 94
    Width = 55
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = '0 mV'
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
    Left = 79
    Top = 51
    Width = 1250
    Height = 22
    LargeChange = 100
    Max = 32767
    Min = -32768
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
    Left = 664
    Top = 10
    Width = 81
    Height = 25
    Caption = 'DAC to 0'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 1000
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
    Left = 1152
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
    Left = 1216
    Top = 14
    Width = 113
    Height = 21
    TabOrder = 9
    Text = 'Test'
    OnChange = Edit1Change
  end
  object OffsetBtn: TButton
    Left = 392
    Top = 88
    Width = 80
    Height = 25
    Caption = 'Apply Offset'
    TabOrder = 10
    OnClick = OffsetBtnClick
  end
  object GainBtn: TButton
    Left = 608
    Top = 88
    Width = 80
    Height = 25
    Caption = 'Apply Gain'
    TabOrder = 11
    OnClick = GainBtnClick
  end
  object SetDACCorrection: TSpinEdit
    Left = 200
    Top = 90
    Width = 57
    Height = 22
    MaxValue = 7
    MinValue = 0
    TabOrder = 12
    Value = 0
    OnChange = SetDACCorrectionChange
  end
  object OffsetValue: TSpinEdit
    Left = 264
    Top = 90
    Width = 60
    Height = 22
    EditorEnabled = False
    MaxValue = 255
    MinValue = -256
    TabOrder = 13
    Value = 0
    OnChange = OffsetValueChange
  end
  object GainValue: TSpinEdit
    Left = 480
    Top = 90
    Width = 60
    Height = 22
    EditorEnabled = False
    MaxValue = 127
    MinValue = -128
    TabOrder = 14
    Value = 0
    OnChange = GainValueChange
  end
  object DIOButton: TButton
    Left = 480
    Top = 16
    Width = 121
    Height = 25
    Caption = 'DIOButton'
    TabOrder = 15
    Visible = False
    OnClick = DIOButtonClick
  end
  object OSReadBtn: TButton
    Left = 368
    Top = 14
    Width = 57
    Height = 22
    Caption = 'Read'
    TabOrder = 16
    Visible = False
    OnClick = OSReadClick
  end
  object OSspin: TSpinEdit
    Left = 432
    Top = 16
    Width = 41
    Height = 22
    MaxValue = 64
    MinValue = 0
    TabOrder = 17
    Value = 0
    Visible = False
  end
end
