object LinerConfig: TLinerConfig
  Left = 278
  Top = 411
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'BiasConfig'
  ClientHeight = 259
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 353
    Height = 81
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 25
      Height = 13
      Caption = 'Write'
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 51
      Height = 13
      Caption = 'x axis DAC'
    end
    object Label4: TLabel
      Left = 240
      Top = 56
      Width = 41
      Height = 13
      Caption = 'Multiplier'
    end
    object Label3: TLabel
      Left = 240
      Top = 16
      Width = 22
      Height = 13
      Caption = 'ADC'
    end
    object SpinEdit1: TSpinEdit
      Left = 72
      Top = 16
      Width = 33
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 0
      Value = 5
      OnChange = SpinEdit1Change
    end
    object RadioGroup1: TRadioGroup
      Left = 120
      Top = 8
      Width = 113
      Height = 65
      Caption = 'x axis parameter'
      ItemIndex = 1
      Items.Strings = (
        'Read x axis'
        'Set from DAC')
      TabOrder = 1
      OnClick = RadioGroup1Click
    end
    object xDACMultiplier: TEdit
      Left = 296
      Top = 48
      Width = 49
      Height = 21
      TabOrder = 2
      Text = '10'
      OnChange = xDACMultiplierChange
      OnExit = xDACMultiplierCheck
    end
    object ReverseCheck: TCheckBox
      Left = 8
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Reverse'
      TabOrder = 3
      OnClick = ReverseCheckClick
    end
    object seADCxaxis: TSpinEdit
      Left = 288
      Top = 16
      Width = 49
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 4
      Value = 0
      OnChange = seADCxaxisChange
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 96
    Width = 353
    Height = 89
    TabOrder = 1
    object Label5: TLabel
      Left = 120
      Top = 32
      Width = 191
      Height = 16
      Caption = 'Uses Settings of Config Scanner'
      Color = clCaptionText
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 81
      Height = 17
      Caption = 'Measure Z'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 32
      Width = 81
      Height = 17
      Caption = 'Measure I'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox2Click
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Measure Other'
      TabOrder = 2
      OnClick = CheckBox3Click
    end
  end
  object Pane3: TPanel
    Left = 368
    Top = 8
    Width = 81
    Height = 177
    TabOrder = 2
    object RadioGroup2: TRadioGroup
      Left = 0
      Top = 0
      Width = 81
      Height = 177
      Caption = 'Bias Voltage'
      ItemIndex = 0
      Items.Strings = (
        '10 V'
        '1 V'
        '100 mV'
        '10 mV'
        '1 mV'
        'Other')
      TabOrder = 0
      OnClick = RadioGroup2Click
    end
  end
  object pnl1: TPanel
    Left = 8
    Top = 192
    Width = 441
    Height = 57
    TabOrder = 3
    OnExit = DAC5AttEditCheck
    object seReduceRampFactor: TSpinEdit
      Left = 184
      Top = 18
      Width = 49
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object chkReduceRamp: TCheckBox
      Left = 16
      Top = 20
      Width = 161
      Height = 17
      Caption = 'Reduce Ramp by a factor of'
      TabOrder = 0
    end
    object SetDAC5AttBtn: TButton
      Left = 264
      Top = 8
      Width = 110
      Height = 17
      Caption = 'Set DAC5 Attenuation'
      TabOrder = 2
      OnClick = SetDAC5AttBtnClick
    end
    object SetDAC6AttBtn: TButton
      Left = 264
      Top = 32
      Width = 110
      Height = 17
      Caption = 'Set DAC6 Attenuation'
      TabOrder = 3
      OnClick = SetDAC6AttBtnClick
    end
    object DAC5AttEdit: TEdit
      Left = 384
      Top = 6
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '1'
      OnExit = DAC5AttEditCheck
    end
    object DAC6AttEdit: TEdit
      Left = 384
      Top = 30
      Width = 49
      Height = 21
      TabOrder = 5
      Text = '1'
      OnExit = DAC6AttEditCheck
    end
  end
end
