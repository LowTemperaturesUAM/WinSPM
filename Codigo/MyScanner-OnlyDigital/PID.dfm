object FormPID: TFormPID
  Left = 1452
  Top = 24
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WinPID'
  ClientHeight = 436
  ClientWidth = 336
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
    Top = 332
    Width = 24
    Height = 13
    Caption = 'Input'
  end
  object Label2: TLabel
    Left = 16
    Top = 356
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
  object lblInValue: TLabel
    Left = 158
    Top = 332
    Width = 3
    Height = 13
    Alignment = taRightJustify
    Caption = '-'
  end
  object lblOutValue: TLabel
    Left = 158
    Top = 356
    Width = 3
    Height = 13
    Alignment = taRightJustify
    Caption = '-'
  end
  object lblPValue: TLabel
    Left = 28
    Top = 248
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = '10'
  end
  object Label7: TLabel
    Left = 28
    Top = 88
    Width = 7
    Height = 13
    Caption = 'P'
  end
  object lblIValue: TLabel
    Left = 66
    Top = 248
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = '10'
  end
  object Label9: TLabel
    Left = 70
    Top = 88
    Width = 3
    Height = 13
    Alignment = taRightJustify
    Caption = 'I'
  end
  object lblDValue: TLabel
    Left = 108
    Top = 248
    Width = 12
    Height = 13
    Alignment = taRightJustify
    Caption = '10'
  end
  object Label11: TLabel
    Left = 108
    Top = 88
    Width = 8
    Height = 13
    Caption = 'D'
  end
  object Label12: TLabel
    Left = 178
    Top = 248
    Width = 6
    Height = 13
    Alignment = taRightJustify
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
    Left = 104
    Top = 332
    Width = 9
    Height = 13
    Caption = 'In'
  end
  object Label16: TLabel
    Left = 104
    Top = 356
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
  object chkShowValues: TCheckBox
    Left = 104
    Top = 308
    Width = 57
    Height = 17
    Caption = 'ShowIt'
    TabOrder = 0
    OnClick = chkShowValuesClick
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
  object spinPID_Out: TSpinEdit
    Left = 56
    Top = 352
    Width = 41
    Height = 22
    MaxValue = 7
    MinValue = 0
    TabOrder = 2
    Value = 6
    OnChange = spinPID_OutChange
  end
  object Gain_P: TSpinEdit
    Left = 16
    Top = 280
    Width = 32
    Height = 22
    MaxValue = 3
    MinValue = -3
    TabOrder = 3
    Value = -1
    OnChange = Gain_PChange
  end
  object scrlbrP: TScrollBar
    Left = 24
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    Position = 31
    TabOrder = 4
    OnChange = scrlbrPChange
  end
  object scrlbrI: TScrollBar
    Left = 64
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    TabOrder = 5
    OnChange = scrlbrIChange
  end
  object scrlbrD: TScrollBar
    Left = 104
    Top = 112
    Width = 17
    Height = 121
    Kind = sbVertical
    PageSize = 0
    TabOrder = 6
    OnChange = scrlbrDChange
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
  object ReversePIDChk: TCheckBox
    Left = 24
    Top = 376
    Width = 65
    Height = 17
    Caption = 'Reverse'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = ReversePIDChkClick
  end
  object LiveSpin: TSpinEdit
    Left = 240
    Top = 264
    Width = 65
    Height = 22
    MaxValue = 1000000
    MinValue = 1
    TabOrder = 9
    Value = 1
    OnChange = LiveSpinChange
  end
  object ResetPIDBtn: TButton
    Left = 232
    Top = 112
    Width = 75
    Height = 17
    Caption = 'RESET'
    TabOrder = 10
    OnClick = ResetPIDBtnClick
  end
  object AvgSpin: TSpinEdit
    Left = 240
    Top = 336
    Width = 65
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 11
    Value = 1
    OnChange = AvgSpinChange
  end
  object Avg10MultBtn: TButton
    Left = 240
    Top = 360
    Width = 35
    Height = 17
    Caption = 'x10'
    TabOrder = 12
    OnClick = Avg10MultBtnClick
  end
  object Avg10DivBtn: TButton
    Left = 272
    Top = 360
    Width = 35
    Height = 17
    Caption = '/10'
    TabOrder = 13
    OnClick = Avg10DivBtnClick
  end
  object Live10MultBtn: TButton
    Left = 240
    Top = 288
    Width = 33
    Height = 17
    Caption = 'x10'
    TabOrder = 14
    OnClick = Live10MultBtnClick
  end
  object Live10DivBtn: TButton
    Left = 272
    Top = 288
    Width = 33
    Height = 17
    Caption = '/10'
    TabOrder = 15
    OnClick = Live10DivBtnClick
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
    Left = 56
    Top = 280
    Width = 32
    Height = 22
    MaxValue = 6
    MinValue = -6
    TabOrder = 18
    Value = 0
    OnChange = Gain_IChange
  end
  object Gain_D: TSpinEdit
    Left = 96
    Top = 280
    Width = 32
    Height = 22
    MaxValue = 6
    MinValue = -6
    TabOrder = 19
    Value = 0
    OnChange = Gain_DChange
  end
  object TimerSpin: TSpinEdit
    Left = 232
    Top = 168
    Width = 65
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 20
    Value = 0
    OnChange = TimerSpinChange
  end
  object SleepCtrlBtn: TButton
    Left = 152
    Top = 8
    Width = 75
    Height = 25
    Caption = 'SleepCtrl'
    TabOrder = 21
    OnClick = SleepCtrlBtnClick
  end
  object SleepCtrlEdit: TSpinEdit
    Left = 152
    Top = 40
    Width = 65
    Height = 22
    MaxValue = 10000
    MinValue = 1
    TabOrder = 22
    Value = 1
  end
  object LockPIDChk: TCheckBox
    Left = 232
    Top = 80
    Width = 85
    Height = 17
    Hint = 'Locks PID controls to avoid unintended changes'
    Caption = 'Lock controls'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 23
    OnClick = LockPIDChkClick
  end
  object thrdtmr1: TThreadedTimer
    AllowZero = True
    Interval = 0
    OnTimer = thrdtmr1Timer
    ThreadPriority = tpLowest
    Left = 272
    Top = 24
  end
end
