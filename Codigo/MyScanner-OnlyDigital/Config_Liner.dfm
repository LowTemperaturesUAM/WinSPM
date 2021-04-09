object Form7: TForm7
  Left = 190
  Top = 583
  Width = 472
  Height = 231
  Caption = 'BiasConfig'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
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
    object Label3: TLabel
      Left = 240
      Top = 24
      Width = 22
      Height = 13
      Caption = 'ADC'
    end
    object Label4: TLabel
      Left = 240
      Top = 48
      Width = 41
      Height = 13
      Caption = 'Multiplier'
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
    object SpinEdit2: TSpinEdit
      Left = 296
      Top = 16
      Width = 49
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = SpinEdit2Change
    end
    object Edit1: TEdit
      Left = 296
      Top = 40
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '10'
      OnChange = Edit1Change
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Reverse'
      TabOrder = 4
      OnClick = CheckBox4Click
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
    Caption = 'Pane3'
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
end
