object PIDControl: TPIDControl
  Left = 841
  Top = 297
  Width = 537
  Height = 249
  Caption = 'PIDControl'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 20
    Width = 44
    Height = 13
    Caption = 'TARGET'
  end
  object Label2: TLabel
    Left = 72
    Top = 20
    Width = 15
    Height = 13
    Caption = '0.1'
  end
  object Label3: TLabel
    Left = 143
    Top = 20
    Width = 35
    Height = 13
    Caption = 'STATE'
  end
  object Label4: TLabel
    Left = 189
    Top = 20
    Width = 15
    Height = 13
    Caption = '0.1'
  end
  object Label5: TLabel
    Left = 306
    Top = 13
    Width = 76
    Height = 24
    Caption = 'LOCKED'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label6: TLabel
    Left = 13
    Top = 46
    Width = 40
    Height = 13
    Caption = 'ACTION'
  end
  object Label7: TLabel
    Left = 59
    Top = 46
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label8: TLabel
    Left = 20
    Top = 85
    Width = 7
    Height = 13
    Caption = 'P'
  end
  object Label9: TLabel
    Left = 20
    Top = 111
    Width = 3
    Height = 13
    Caption = 'I'
  end
  object Label10: TLabel
    Left = 20
    Top = 137
    Width = 8
    Height = 13
    Caption = 'D'
  end
  object Label11: TLabel
    Left = 267
    Top = 52
    Width = 61
    Height = 13
    Caption = 'Present Error'
  end
  object Label12: TLabel
    Left = 345
    Top = 52
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label13: TLabel
    Left = 267
    Top = 78
    Width = 71
    Height = 13
    Caption = 'Accepted Error'
  end
  object SpinEdit1: TSpinEdit
    Left = 39
    Top = 78
    Width = 46
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 39
    Top = 104
    Width = 46
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 39
    Top = 130
    Width = 46
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object SpinEdit4: TSpinEdit
    Left = 345
    Top = 72
    Width = 33
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
end
