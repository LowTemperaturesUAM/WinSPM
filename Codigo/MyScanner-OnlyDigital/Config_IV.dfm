object FormCITS: TFormCITS
  Left = 1250
  Top = 540
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'IV config'
  ClientHeight = 81
  ClientWidth = 196
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object NrOfPointsLbl: TLabel
    Left = 100
    Top = 9
    Width = 82
    Height = 13
    Caption = 'Number of points'
  end
  object DoForth_CITS: TCheckBox
    Left = 8
    Top = 8
    Width = 57
    Height = 17
    Caption = 'Forth'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object DoBack_CITS: TCheckBox
    Left = 8
    Top = 32
    Width = 57
    Height = 17
    Caption = 'Back'
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object NrOfLines_CITS: TComboBox
    Left = 100
    Top = 27
    Width = 65
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = '256'
    OnChange = NrOfLines_CITSChange
    OnExit = NrOfLines_CITSExit
    Items.Strings = (
      '8'
      '16'
      '32'
      '48'
      '64'
      '96'
      '128'
      '192'
      '256'
      '384'
      '512')
  end
  object chkSaveAsWSxM: TCheckBox
    Left = 8
    Top = 56
    Width = 157
    Height = 17
    Caption = 'Save in WSxM format'
    TabOrder = 3
  end
end
