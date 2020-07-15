object Form4: TForm4
  Left = 602
  Top = 77
  Width = 834
  Height = 621
  Caption = 'Liner'
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
  object Mean: TLabel
    Left = 704
    Top = 464
    Width = 27
    Height = 13
    Caption = 'Mean'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Jump: TLabel
    Left = 704
    Top = 490
    Width = 25
    Height = 13
    Caption = 'Jump'
  end
  object Label4: TLabel
    Left = 752
    Top = 352
    Width = 52
    Height = 13
    Caption = 'Der. Points'
  end
  object Label12: TLabel
    Left = 600
    Top = 32
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label13: TLabel
    Left = 16
    Top = 562
    Width = 91
    Height = 13
    Caption = 'TEMPERATURE ='
  end
  object Label14: TLabel
    Left = 176
    Top = 562
    Width = 7
    Height = 13
    Caption = 'K'
  end
  object Label15: TLabel
    Left = 224
    Top = 562
    Width = 98
    Height = 13
    Caption = 'MAGNETIC FIELD ='
  end
  object Label16: TLabel
    Left = 392
    Top = 562
    Width = 7
    Height = 13
    Caption = 'T'
  end
  object lblColorPID: TLabel
    Left = 699
    Top = 64
    Width = 3
    Height = 13
  end
  object Label11: TLabel
    Left = 419
    Top = 562
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 704
    Top = 112
    Width = 81
    Height = 13
    Caption = 'Number of Points'
  end
  object Label17: TLabel
    Left = 608
    Top = 526
    Width = 20
    Height = 13
    Caption = 'Size'
  end
  object Label18: TLabel
    Left = 640
    Top = 526
    Width = 18
    Height = 13
    Caption = '100'
  end
  object Button1: TButton
    Left = 16
    Top = 8
    Width = 75
    Height = 41
    Caption = 'Do'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 8
    Width = 83
    Height = 41
    Caption = 'DoDo'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 8
    Width = 83
    Height = 41
    Caption = 'Abort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 616
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Save present'
    TabOrder = 3
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 624
    Top = 34
    Width = 65
    Height = 17
    Caption = 'Save All'
    TabOrder = 4
  end
  object ComboBox1: TComboBox
    Left = 704
    Top = 128
    Width = 105
    Height = 21
    Hint = 'Point Number'
    ItemHeight = 13
    ItemIndex = 9
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = '2048'
    OnChange = ComboBox1Change
    Items.Strings = (
      '4'
      '8'
      '16'
      '32'
      '64'
      '128'
      '256'
      '512'
      '1024'
      '2048')
  end
  object Edit1: TEdit
    Left = 408
    Top = 8
    Width = 137
    Height = 21
    Cursor = crIBeam
    TabOrder = 6
    Text = 'FileName'
  end
  object SpinEdit1: TSpinEdit
    Left = 552
    Top = 8
    Width = 57
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 7
    Value = 1
    OnChange = SpinEdit1Change
  end
  object Button5: TButton
    Left = 296
    Top = 8
    Width = 81
    Height = 41
    Caption = 'Config'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = Button5Click
  end
  object Panel1: TPanel
    Left = 704
    Top = 152
    Width = 105
    Height = 121
    TabOrder = 9
    object Label1: TLabel
      Left = 24
      Top = 0
      Width = 56
      Height = 13
      Caption = 'Accumulate'
    end
    object lblAccumulate: TLabel
      Left = 24
      Top = 20
      Width = 18
      Height = 13
      Alignment = taRightJustify
      Caption = '1 of'
    end
    object Label2: TLabel
      Left = 25
      Top = 76
      Width = 56
      Height = 13
      Alignment = taRightJustify
      Caption = 'Time for Ctrl'
    end
    object SpinEdit2: TSpinEdit
      Left = 48
      Top = 16
      Width = 41
      Height = 22
      MaxValue = 1000
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object Button6: TButton
      Left = 16
      Top = 40
      Width = 73
      Height = 25
      Caption = 'Finish'
      TabOrder = 1
      OnClick = Button6Click
    end
    object SpinEdit6: TSpinEdit
      Left = 32
      Top = 88
      Width = 41
      Height = 22
      MaxValue = 1000
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 704
    Top = 288
    Width = 105
    Height = 49
    Caption = 'Plot'
    ItemIndex = 0
    Items.Strings = (
      'Direct'
      'Derivative')
    TabOrder = 10
    OnClick = RadioGroup1Click
  end
  object Button7: TButton
    Left = 704
    Top = 84
    Width = 41
    Height = 17
    Caption = 'Hold'
    TabOrder = 11
    OnClick = Button7Click
  end
  object CheckBox2: TCheckBox
    Left = 752
    Top = 84
    Width = 65
    Height = 17
    Caption = 'On Take'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object RadioGroup2: TRadioGroup
    Left = 704
    Top = 376
    Width = 105
    Height = 81
    Hint = 'Show in Graph'
    Caption = 'Plot'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -5
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'I'
      'Z'
      'Other')
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = RadioGroup2Click
  end
  object SpinEdit3: TSpinEdit
    Left = 744
    Top = 460
    Width = 49
    Height = 22
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 42
    MinValue = 1
    ParentFont = False
    TabOrder = 14
    Value = 1
    OnChange = SpinEdit3Change
  end
  object SpinEdit4: TSpinEdit
    Left = 744
    Top = 486
    Width = 49
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 15
    Value = 1
    OnChange = SpinEdit4Change
  end
  object SpinEdit5: TSpinEdit
    Left = 704
    Top = 348
    Width = 41
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 17
    Value = 1
    OnChange = SpinEdit5Change
  end
  object Button8: TButton
    Left = 704
    Top = 544
    Width = 75
    Height = 17
    Caption = 'Delete Graph'
    TabOrder = 18
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 408
    Top = 32
    Width = 177
    Height = 17
    Caption = 'Set File Name'
    TabOrder = 19
    OnClick = Button9Click
  end
  object Edit5: TEdit
    Left = 112
    Top = 558
    Width = 57
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 20
    Text = '1'
    OnEnter = Edit5Enter
  end
  object Edit6: TEdit
    Left = 328
    Top = 558
    Width = 57
    Height = 21
    TabOrder = 22
    Text = '0'
    OnEnter = Edit6Enter
  end
  object scrollSizeBias: TScrollBar
    Left = 16
    Top = 520
    Width = 577
    Height = 25
    PageSize = 0
    Position = 100
    TabOrder = 21
    OnChange = scrollSizeBiasChange
  end
  object chartLine: TChart
    Left = 16
    Top = 56
    Width = 681
    Height = 457
    AllowPanning = pmVertical
    AnimatedZoom = True
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Font.Charset = DEFAULT_CHARSET
    Title.Font.Color = clBlack
    Title.Font.Height = -11
    Title.Font.Name = 'Arial'
    Title.Font.Style = [fsBold, fsItalic]
    Title.Text.Strings = (
      'Ramp')
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = 0.500000000000000000
    DepthAxis.Minimum = -0.500000000000000000
    LeftAxis.ExactDateTime = False
    Legend.Visible = False
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    TopAxis.Automatic = False
    TopAxis.AutomaticMaximum = False
    TopAxis.AutomaticMinimum = False
    View3D = False
    View3DWalls = False
    Color = clWhite
    TabOrder = 23
    object ChartLineSerie0: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      PercentFormat = '##0,## %'
      SeriesColor = clRed
      ValueFormat = '#,##0,###'
      LinePen.Color = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
    object ChartLineSerie1: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clBlue
      LinePen.Color = clBlue
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object chkAcquireBlock: TCheckBox
    Left = 704
    Top = 512
    Width = 113
    Height = 17
    Caption = 'Buffered acquisition'
    Checked = True
    State = cbChecked
    TabOrder = 16
    OnClick = chkAcquireBlockClick
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text files (*.txt)|*.txt|Data files (*.dat)|*.dat'
    InitialDir = 'c:\Results'
    Left = 744
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 704
    Top = 8
  end
end
