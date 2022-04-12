object FormPID: TFormPID
  Left = 1452
  Top = 24
  Width = 352
  Height = 475
  Caption = 'WinPID'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 336
    Width = 24
    Height = 13
    Caption = 'Input'
  end
  object Label2: TLabel
    Left = 16
    Top = 360
    Width = 32
    Height = 13
    Caption = 'Output'
  end
  object Label3: TLabel
    Left = 16
    Top = 264
    Width = 43
    Height = 13
    Caption = 'Gain 10^'
  end
  object Label4: TLabel
    Left = 128
    Top = 336
    Width = 9
    Height = 13
    Caption = 'In'
  end
  object Label5: TLabel
    Left = 128
    Top = 360
    Width = 17
    Height = 13
    Caption = 'Out'
  end
  object Label6: TLabel
    Left = 32
    Top = 248
    Width = 18
    Height = 13
    Caption = '100'
  end
  object Label7: TLabel
    Left = 24
    Top = 88
    Width = 7
    Height = 13
    Caption = 'P'
  end
  object Label8: TLabel
    Left = 72
    Top = 248
    Width = 18
    Height = 13
    Caption = '100'
  end
  object Label9: TLabel
    Left = 64
    Top = 88
    Width = 3
    Height = 13
    Caption = 'I'
  end
  object Label10: TLabel
    Left = 112
    Top = 248
    Width = 18
    Height = 13
    Caption = '100'
  end
  object Label11: TLabel
    Left = 104
    Top = 88
    Width = 8
    Height = 13
    Caption = 'D'
  end
  object Label12: TLabel
    Left = 176
    Top = 248
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label13: TLabel
    Left = 168
    Top = 88
    Width = 21
    Height = 13
    Caption = 'SET'
  end
  object Label14: TLabel
    Left = 256
    Top = 248
    Width = 20
    Height = 13
    Caption = 'Live'
  end
  object Label15: TLabel
    Left = 184
    Top = 336
    Width = 9
    Height = 13
    Caption = 'In'
  end
  object Label16: TLabel
    Left = 184
    Top = 360
    Width = 17
    Height = 13
    Caption = 'Out'
  end
  object Label17: TLabel
    Left = 256
    Top = 320
    Width = 40
    Height = 13
    Caption = 'Average'
  end
  object Label19: TLabel
    Left = 24
    Top = 8
    Width = 72
    Height = 13
    Caption = 'Digital (TIMER)'
  end
  object lbl1: TLabel
    Left = 240
    Top = 152
    Width = 53
    Height = 13
    Caption = 'Timer in ms'
  end
  object lblCurrentLabel: TLabel
    Left = 16
    Top = 408
    Width = 105
    Height = 13
    Caption = 'Current set point (nA) :'
    Visible = False
  end
  object lblCurrentSetPoint: TLabel
    Left = 128
    Top = 408
    Width = 34
    Height = 13
    Caption = 'Current'
    Visible = False
  end
  object CheckBox1: TCheckBox
    Left = 128
    Top = 304
    Width = 65
    Height = 17
    Caption = 'ShowIt'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object spinPID_In: TSpinEdit
    Left = 56
    Top = 328
    Width = 41
    Height = 22
    MaxValue = 5
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnChange = spinPID_InChange
  end
  object SpinEdit2: TSpinEdit
    Left = 56
    Top = 352
    Width = 41
    Height = 22
    MaxValue = 7
    MinValue = 0
    TabOrder = 2
    Value = 6
    OnChange = SpinEdit2Change
  end
  object SpinEdit3: TSpinEdit
    Left = 16
    Top = 280
    Width = 33
    Height = 22
    MaxValue = 3
    MinValue = -3
    TabOrder = 3
    Value = -1
    OnChange = SpinEdit3Change
  end
  object ScrollBar1: TScrollBar
    Left = 24
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    Position = 31
    TabOrder = 4
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 64
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    TabOrder = 5
    OnChange = ScrollBar2Change
  end
  object ScrollBar3: TScrollBar
    Left = 104
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    TabOrder = 6
    OnChange = ScrollBar3Change
  end
  object scrlbrSetPoint: TScrollBar
    Left = 168
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    LargeChange = 10
    Max = 1000
    PageSize = 0
    Position = 6
    TabOrder = 7
    OnChange = scrlbrSetPointChange
  end
  object CheckBox2: TCheckBox
    Left = 24
    Top = 376
    Width = 65
    Height = 17
    Caption = 'Reverse'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = CheckBox2Click
  end
  object SpinEdit4: TSpinEdit
    Left = 240
    Top = 264
    Width = 65
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 9
    Value = 1
    OnChange = SpinEdit4Change
  end
  object Button3: TButton
    Left = 232
    Top = 112
    Width = 75
    Height = 17
    Caption = 'RESET'
    TabOrder = 10
    OnClick = Button3Click
  end
  object SpinEdit5: TSpinEdit
    Left = 240
    Top = 336
    Width = 65
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 11
    Value = 1
    OnChange = SpinEdit5Change
  end
  object Button4: TButton
    Left = 240
    Top = 360
    Width = 35
    Height = 17
    Caption = 'x10'
    TabOrder = 12
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 272
    Top = 360
    Width = 35
    Height = 17
    Caption = '/10'
    TabOrder = 13
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 240
    Top = 288
    Width = 33
    Height = 17
    Caption = 'x10'
    TabOrder = 14
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 272
    Top = 288
    Width = 33
    Height = 17
    Caption = '/10'
    TabOrder = 15
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 16
    Top = 24
    Width = 41
    Height = 17
    Caption = 'ON'
    TabOrder = 16
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 56
    Top = 24
    Width = 41
    Height = 17
    Caption = 'OFF'
    TabOrder = 17
    OnClick = Button9Click
  end
  object Gain_I: TSpinEdit
    Left = 64
    Top = 280
    Width = 33
    Height = 22
    MaxValue = 3
    MinValue = -3
    TabOrder = 18
    Value = 0
    OnChange = Gain_IChange
  end
  object Gain_D: TSpinEdit
    Left = 104
    Top = 280
    Width = 41
    Height = 22
    MaxValue = 3
    MinValue = -3
    TabOrder = 19
    Value = 0
    OnChange = Gain_DChange
  end
  object se1: TSpinEdit
    Left = 232
    Top = 168
    Width = 65
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 20
    Value = 1
    OnChange = se1Change
  end
  object Button1: TButton
    Left = 152
    Top = 8
    Width = 75
    Height = 25
    Caption = 'SleepCtrl'
    TabOrder = 21
    OnClick = Button1Click
  end
  object SpinEdit6: TSpinEdit
    Left = 152
    Top = 40
    Width = 65
    Height = 22
    MaxValue = 10000
    MinValue = 1
    TabOrder = 22
    Value = 1
  end
  object thrdtmr1: TThreadedTimer
    AllowZero = True
    Interval = 1
    OnTimer = thrdtmr1Timer
    ThreadPriority = tpLowest
    Left = 272
    Top = 24
  end
end
