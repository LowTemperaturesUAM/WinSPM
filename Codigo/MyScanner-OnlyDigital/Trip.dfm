object TripForm: TTripForm
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
  object SpeedName: TLabel
    Left = 16
    Top = 120
    Width = 31
    Height = 13
    Caption = 'Speed'
  end
  object SizeName: TLabel
    Left = 16
    Top = 152
    Width = 20
    Height = 13
    Caption = 'Size'
  end
  object SpeedLbl: TLabel
    Left = 200
    Top = 120
    Width = 24
    Height = 13
    Caption = '1000'
  end
  object SizeLbl: TLabel
    Left = 200
    Top = 152
    Width = 6
    Height = 13
    Caption = '1'
  end
  object StepsLbl: TLabel
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
  object ApproachBtn: TButton
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
    OnClick = ApproachBtnClick
  end
  object SeparateBtn: TButton
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
    OnClick = SeparateBtnClick
  end
  object Separate100Btn: TButton
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
    OnClick = Separate100BtnClick
  end
  object AutoApproachBtn: TButton
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
    OnClick = AutoApproachBtnClick
  end
  object StepsEdit: TSpinEdit
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
    OnChange = StepsEditChange
  end
  object SpeedBar: TScrollBar
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
    OnChange = SpeedBarChange
  end
  object SizeBar: TScrollBar
    Left = 72
    Top = 152
    Width = 121
    Height = 17
    Max = 10
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 6
    OnChange = SizeBarChange
  end
  object ConfigBtn: TButton
    Left = 240
    Top = 84
    Width = 75
    Height = 22
    Caption = 'Config'
    TabOrder = 7
    OnClick = ConfigBtnClick
  end
  object StopBtn: TButton
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
    OnClick = StopBtnClick
  end
  object StepsDiv10Btn: TButton
    Left = 102
    Top = 84
    Width = 33
    Height = 22
    Caption = '/10'
    TabOrder = 9
    OnClick = StepsDiv10BtnClick
  end
  object StepsMul10Btn: TButton
    Left = 200
    Top = 84
    Width = 33
    Height = 22
    Caption = 'x10'
    TabOrder = 10
    OnClick = StepsMul10BtnClick
  end
end
