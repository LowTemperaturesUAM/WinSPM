object Form6: TForm6
  Left = 653
  Top = 326
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ConfigCoarseApproach'
  ClientHeight = 173
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 257
    Height = 89
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 60
      Height = 13
      Caption = 'Z prime DAC'
    end
    object Label2: TLabel
      Left = 24
      Top = 40
      Width = 59
      Height = 13
      Caption = 'Current ADC'
    end
    object lblCurrentLimit: TLabel
      Left = 24
      Top = 64
      Width = 74
      Height = 13
      Caption = 'Current limit (%):'
    end
    object SpinEdit1: TSpinEdit
      Left = 104
      Top = 8
      Width = 41
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 0
      Value = 4
      OnChange = SpinEdit1Change
    end
    object SpinEdit2: TSpinEdit
      Left = 104
      Top = 32
      Width = 41
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = SpinEdit2Change
    end
    object CheckBox1: TCheckBox
      Left = 152
      Top = 16
      Width = 81
      Height = 17
      Caption = 'ZP times -1'
      TabOrder = 2
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Left = 152
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Detect I times -1'
      TabOrder = 3
      OnClick = CheckBox2Click
    end
    object spinCurrentLimit: TSpinEdit
      Left = 104
      Top = 60
      Width = 37
      Height = 22
      MaxValue = 99
      MinValue = 0
      TabOrder = 4
      Value = 50
    end
  end
end
