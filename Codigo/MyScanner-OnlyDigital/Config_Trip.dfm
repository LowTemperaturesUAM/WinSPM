object TripConfig: TTripConfig
  Left = 653
  Top = 326
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ConfigCoarseApproach'
  ClientHeight = 124
  ClientWidth = 289
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
    object OutLabel: TLabel
      Left = 24
      Top = 12
      Width = 60
      Height = 13
      Caption = 'Z prime DAC'
    end
    object InLabel: TLabel
      Left = 24
      Top = 36
      Width = 59
      Height = 13
      Caption = 'Current ADC'
    end
    object lblCurrentLimit: TLabel
      Left = 24
      Top = 60
      Width = 74
      Height = 13
      Caption = 'Current limit (%):'
    end
    object MeanLbl: TLabel
      Left = 152
      Top = 60
      Width = 27
      Height = 13
      Caption = 'Mean'
    end
    object OutDacEdit: TSpinEdit
      Left = 104
      Top = 8
      Width = 42
      Height = 22
      MaxValue = 7
      MinValue = 0
      TabOrder = 0
      Value = 4
      OnChange = OutDacEditChange
    end
    object InADCEdit: TSpinEdit
      Left = 104
      Top = 32
      Width = 42
      Height = 22
      MaxValue = 5
      MinValue = 0
      TabOrder = 1
      Value = 0
      OnChange = InADCEditChange
    end
    object InvertZPChk: TCheckBox
      Left = 152
      Top = 10
      Width = 81
      Height = 17
      Caption = 'ZP times -1'
      TabOrder = 2
      OnClick = InvertZPChkClick
    end
    object InvertCurChk: TCheckBox
      Left = 152
      Top = 34
      Width = 97
      Height = 17
      Caption = 'Detect I times -1'
      TabOrder = 3
      OnClick = InvertCurChkClick
    end
    object spinCurrentLimit: TSpinEdit
      Left = 104
      Top = 56
      Width = 42
      Height = 22
      MaxValue = 99
      MinValue = 0
      TabOrder = 4
      Value = 50
    end
    object MeanSpin: TSpinEdit
      Left = 184
      Top = 56
      Width = 42
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 5
      Value = 10
      OnChange = MeanSpinChange
    end
  end
end
