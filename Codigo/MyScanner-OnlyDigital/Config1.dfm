object FormConfig: TFormConfig
  Left = 432
  Top = 633
  ActiveControl = OtherChanEdit
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WinSPMConfig'
  ClientHeight = 375
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SaveCfg: TSpeedButton
    Left = 59
    Top = 336
    Width = 100
    Height = 25
    Hint = 
      'Saves the new configuration to the config file.'#13#10'These are the n' +
      'ew default values.'
    Caption = 'Save Config to File'
    ParentShowHint = False
    ShowHint = True
    OnClick = SaveCfgClick
  end
  object UpdateCfg: TSpeedButton
    Left = 232
    Top = 336
    Width = 100
    Height = 25
    Hint = 
      'Applies the new configuration.'#13#10'Closing the window has the same ' +
      'effect.'
    Caption = 'Update Config'
    ParentShowHint = False
    ShowHint = True
    OnClick = UpdateCfgClick
  end
  object ScanPanel: TPanel
    Left = 16
    Top = 8
    Width = 362
    Height = 145
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 4
      Width = 25
      Height = 13
      Caption = 'Scan'
    end
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 7
      Height = 13
      Caption = 'X'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 7
      Height = 13
      Caption = 'Y'
    end
    object Label4: TLabel
      Left = 24
      Top = 24
      Width = 22
      Height = 13
      Caption = 'DAC'
    end
    object Label5: TLabel
      Left = 24
      Top = 48
      Width = 22
      Height = 13
      Caption = 'DAC'
    end
    object Label6: TLabel
      Left = 200
      Top = 24
      Width = 84
      Height = 13
      Caption = 'Calibration (nm/V)'
    end
    object Label7: TLabel
      Left = 104
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Amplifier'
    end
    object Label10: TLabel
      Left = 104
      Top = 48
      Width = 39
      Height = 13
      Caption = 'Amplifier'
    end
    object Label11: TLabel
      Left = 200
      Top = 48
      Width = 84
      Height = 13
      Caption = 'Calibration (nm/V)'
    end
    object Label19: TLabel
      Left = 8
      Top = 80
      Width = 37
      Height = 13
      Caption = 'Position'
    end
    object Label20: TLabel
      Left = 8
      Top = 96
      Width = 32
      Height = 13
      Caption = 'X DAC'
    end
    object Label21: TLabel
      Left = 8
      Top = 112
      Width = 32
      Height = 13
      Caption = 'Y DAC'
    end
    object Label25: TLabel
      Left = 104
      Top = 96
      Width = 39
      Height = 13
      Caption = 'Amplifier'
    end
    object Label26: TLabel
      Left = 104
      Top = 120
      Width = 39
      Height = 13
      Caption = 'Amplifier'
    end
    object SpinEdit1: TSpinEdit
      Left = 56
      Top = 16
      Width = 33
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object SpinEdit2: TSpinEdit
      Left = 56
      Top = 48
      Width = 33
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 3
      Value = 2
    end
    object Edit1: TEdit
      Left = 296
      Top = 16
      Width = 41
      Height = 21
      TabOrder = 2
      Text = '5'
    end
    object ComboBox1: TComboBox
      Left = 152
      Top = 16
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '14'
      Items.Strings = (
        '14'
        '1.4')
    end
    object SpinEdit6: TSpinEdit
      Left = 56
      Top = 88
      Width = 33
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 7
      Value = 1
    end
    object SpinEdit7: TSpinEdit
      Left = 56
      Top = 112
      Width = 33
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 9
      Value = 3
    end
    object chkAttenuator: TCheckBox
      Left = 104
      Top = 64
      Width = 105
      Height = 13
      Caption = 'Scan attenuator'
      TabOrder = 6
    end
    object ComboBox6: TComboBox
      Left = 152
      Top = 88
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 8
      Text = '14'
      Items.Strings = (
        '14'
        '1.4')
    end
    object ComboBox7: TComboBox
      Left = 152
      Top = 112
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 10
      Text = '14'
      Items.Strings = (
        '14'
        '1.4')
    end
    object ComboBox2: TComboBox
      Left = 152
      Top = 40
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = '14'
      Items.Strings = (
        '14'
        '1.4')
    end
    object Edit2: TEdit
      Left = 296
      Top = 40
      Width = 41
      Height = 21
      TabOrder = 5
      Text = '5'
    end
  end
  object ReadPanel: TPanel
    Left = 16
    Top = 160
    Width = 362
    Height = 145
    TabOrder = 1
    object ReadTitle: TLabel
      Left = 8
      Top = 4
      Width = 26
      Height = 13
      Caption = 'Read'
    end
    object TopoChanLbl: TLabel
      Left = 64
      Top = 24
      Width = 22
      Height = 13
      Caption = 'ADC'
    end
    object TopoAmpLbl: TLabel
      Left = 152
      Top = 24
      Width = 39
      Height = 13
      Caption = 'Amplifier'
    end
    object TopoCalLbl: TLabel
      Left = 240
      Top = 24
      Width = 84
      Height = 13
      Caption = 'Calibration (nm/V)'
    end
    object CurrentChanLbl: TLabel
      Left = 72
      Top = 56
      Width = 22
      Height = 13
      Caption = 'ADC'
    end
    object CurrentAmpLbl: TLabel
      Left = 136
      Top = 56
      Width = 60
      Height = 13
      Caption = 'Amplifier 10^'
    end
    object CurrentMultLbl: TLabel
      Left = 248
      Top = 56
      Width = 41
      Height = 13
      Caption = 'Multiplier'
    end
    object OtherChanLbl: TLabel
      Left = 64
      Top = 88
      Width = 22
      Height = 13
      Caption = 'ADC'
    end
    object OtherAmpLbl: TLabel
      Left = 136
      Top = 88
      Width = 60
      Height = 13
      Caption = 'Amplifier 10^'
    end
    object OtherMultLbl: TLabel
      Left = 248
      Top = 88
      Width = 41
      Height = 13
      Caption = 'Multiplier'
    end
    object LHAVerLbl: TLabel
      Left = 96
      Top = 120
      Width = 114
      Height = 13
      Caption = 'LHA Hardware Revision'
    end
    object TopoChanEdit: TSpinEdit
      Left = 88
      Top = 16
      Width = 33
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 1
      Value = 2
    end
    object TopoAmpBox: TComboBox
      Left = 200
      Top = 16
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = '14'
      Items.Strings = (
        '14'
        '1.4')
    end
    object TopoCheck: TCheckBox
      Left = 8
      Top = 24
      Width = 49
      Height = 17
      Caption = 'Topo'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object TopoCalEdit: TEdit
      Left = 320
      Top = 16
      Width = 33
      Height = 21
      TabOrder = 3
      Text = '1'
    end
    object CurrentCheck: TCheckBox
      Left = 8
      Top = 56
      Width = 57
      Height = 17
      Caption = 'Current'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object CurrentChanEdit: TSpinEdit
      Left = 96
      Top = 48
      Width = 33
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
    object CurrentAmpBox: TComboBox
      Left = 200
      Top = 48
      Width = 41
      Height = 21
      ItemHeight = 13
      ItemIndex = 2
      TabOrder = 6
      Text = '8'
      Items.Strings = (
        '10'
        '9'
        '8'
        '7'
        '6'
        '5'
        '4')
    end
    object CurrentMultEdit: TEdit
      Left = 304
      Top = 48
      Width = 49
      Height = 21
      TabOrder = 7
      Text = '-1'
    end
    object OtherCheck: TCheckBox
      Left = 8
      Top = 88
      Width = 49
      Height = 17
      Caption = 'Other'
      TabOrder = 8
    end
    object OtherChanEdit: TSpinEdit
      Left = 96
      Top = 80
      Width = 33
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 9
      Value = 1
    end
    object OtherAmpBox: TComboBox
      Left = 200
      Top = 80
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 10
      Text = '9'
      Items.Strings = (
        '10'
        '9'
        '8'
        '7'
        '6'
        '5'
        '4'
        '3'
        '2'
        '1'
        '0')
    end
    object OtherMultEdit: TEdit
      Left = 304
      Top = 80
      Width = 49
      Height = 21
      TabOrder = 11
      Text = '1'
    end
    object MakeIVCheck: TCheckBox
      Left = 8
      Top = 120
      Width = 73
      Height = 17
      Caption = 'MakeIV'
      TabOrder = 12
      OnClick = MakeIVCheckClick
    end
    object LHAVersionSel: TComboBox
      Left = 224
      Top = 116
      Width = 90
      Height = 21
      Hint = 
        'rev B: 2 attenuators on channel 0,2'#13#10'rev D: 4 attenuators on cha' +
        'nnel 0,2,5,6'#13#10'rev D 14bit: same 4 attenuators with 14bit scale'
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 13
      OnChange = LHAVersionSelChange
      Items.Strings = (
        'rev B'
        'rev D'
        'rev D 14bit')
    end
  end
end
