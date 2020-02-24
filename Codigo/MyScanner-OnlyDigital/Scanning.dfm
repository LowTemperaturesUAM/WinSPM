object Form3: TForm3
  Left = 79
  Top = 210
  Width = 989
  Height = 586
  Caption = 'Form3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 264
    Width = 55
    Height = 13
    Caption = 'Delete after'
  end
  object Label4: TLabel
    Left = 16
    Top = 248
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label5: TLabel
    Left = 56
    Top = 248
    Width = 6
    Height = 13
    Caption = '1'
  end
  object Label2: TLabel
    Left = 48
    Top = 130
    Width = 25
    Height = 13
    Caption = 'Jump'
  end
  object Label3: TLabel
    Left = 8
    Top = 130
    Width = 27
    Height = 13
    Caption = 'Mean'
  end
  object Label6: TLabel
    Left = 128
    Top = 528
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ScrollBox1: TScrollBox
    Left = 696
    Top = 8
    Width = 273
    Height = 265
    TabOrder = 0
    object PaintBox1: TPaintBox
      Left = 4
      Top = 4
      Width = 256
      Height = 256
      Color = clNavy
      ParentColor = False
    end
  end
  object ScrollBox2: TScrollBox
    Left = 696
    Top = 272
    Width = 273
    Height = 273
    TabOrder = 1
    object PaintBox2: TPaintBox
      Left = 4
      Top = 12
      Width = 256
      Height = 256
      Color = clNavy
      ParentColor = False
    end
  end
  object Button1: TButton
    Left = 6
    Top = 40
    Width = 75
    Height = 25
    Caption = 'STOP'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 15
    Top = 312
    Width = 73
    Height = 57
    Caption = 'Show'
    ItemIndex = 0
    Items.Strings = (
      'Topo'
      'Current')
    TabOrder = 3
  end
  object SpinEdit1: TSpinEdit
    Left = 15
    Top = 280
    Width = 41
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 4
    Value = 2
  end
  object Button2: TButton
    Left = 6
    Top = 72
    Width = 75
    Height = 25
    Caption = 'PAUSE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 19
    Top = 376
    Width = 65
    Height = 25
    Caption = 'IN'
    TabOrder = 6
    Visible = False
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 19
    Top = 405
    Width = 65
    Height = 25
    Caption = 'OUT'
    TabOrder = 7
    Visible = False
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 19
    Top = 443
    Width = 65
    Height = 25
    Caption = 'UP'
    TabOrder = 8
    Visible = False
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 19
    Top = 472
    Width = 65
    Height = 25
    Caption = 'DOWN'
    TabOrder = 9
    Visible = False
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 18
    Top = 512
    Width = 66
    Height = 25
    Caption = 'RESET'
    TabOrder = 10
    Visible = False
    OnClick = Button7Click
  end
  object TrackBar1: TTrackBar
    Left = 8
    Top = 143
    Width = 33
    Height = 106
    Max = 100
    Min = 1
    Orientation = trVertical
    Frequency = 10
    Position = 1
    SelEnd = 100
    SelStart = 1
    TabOrder = 11
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object TrackBar2: TTrackBar
    Left = 48
    Top = 143
    Width = 33
    Height = 106
    Max = 10000
    Min = 1
    Orientation = trVertical
    Frequency = 10
    Position = 1
    SelEnd = 10000
    SelStart = 1
    TabOrder = 12
    TickStyle = tsNone
    OnChange = TrackBar2Change
  end
  object CheckBox1: TCheckBox
    Left = 7
    Top = 104
    Width = 73
    Height = 17
    Caption = 'Scan Loop'
    TabOrder = 14
  end
  object CheckBox2: TCheckBox
    Left = 552
    Top = 528
    Width = 137
    Height = 17
    Caption = 'Separate when finished'
    TabOrder = 13
  end
  object ChartLine: TChart
    Left = 84
    Top = 8
    Width = 609
    Height = 521
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
      'Result of Scan')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Maximum = 25.000000000000000000
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = 2.500000000000000000
    DepthAxis.Minimum = -0.500000000000000000
    Legend.Visible = False
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    TopAxis.Automatic = False
    TopAxis.AutomaticMaximum = False
    TopAxis.AutomaticMinimum = False
    View3D = False
    Color = clWhite
    TabOrder = 15
  end
  object chkFlatten: TCheckBox
    Left = 16
    Top = 376
    Width = 61
    Height = 17
    Caption = 'Flatten'
    Checked = True
    State = cbChecked
    TabOrder = 16
  end
  object CheckBox3: TCheckBox
    Left = 208
    Top = 528
    Width = 145
    Height = 17
    Caption = 'Show remaining time'
    Checked = True
    State = cbChecked
    TabOrder = 17
  end
end
