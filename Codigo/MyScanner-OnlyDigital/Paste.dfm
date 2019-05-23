object FormPaste: TFormPaste
  Left = 908
  Top = 154
  Width = 172
  Height = 190
  Caption = 'Paste'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblSizeX: TLabel
    Left = 24
    Top = 60
    Width = 57
    Height = 13
    Align = alCustom
    Alignment = taRightJustify
    Caption = 'Size x (nm):'
  end
  object lblSizeY: TLabel
    Left = 24
    Top = 84
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Caption = 'Size y (nm):'
  end
  object lblPosX: TLabel
    Left = 8
    Top = 12
    Width = 75
    Height = 13
    Align = alCustom
    Alignment = taRightJustify
    Caption = 'Position x (nm):'
  end
  object lblPosY: TLabel
    Left = 8
    Top = 36
    Width = 75
    Height = 13
    Alignment = taRightJustify
    Caption = 'Position y (nm):'
  end
  object edtSizeX: TEdit
    Left = 88
    Top = 56
    Width = 61
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object edtSizeY: TEdit
    Left = 88
    Top = 80
    Width = 61
    Height = 21
    TabOrder = 3
    Text = '1'
  end
  object edtPosX: TEdit
    Left = 88
    Top = 8
    Width = 61
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object edtPosY: TEdit
    Left = 88
    Top = 32
    Width = 61
    Height = 21
    TabOrder = 1
    Text = '1'
  end
  object btnOk: TButton
    Left = 8
    Top = 120
    Width = 141
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = btnOkClick
  end
end
