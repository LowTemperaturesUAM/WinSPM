object AuxGraph1: TAuxGraph1
  Left = 239
  Top = 51
  Width = 702
  Height = 684
  Caption = 'Graph'
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Active curve'
  end
  object Label7: TLabel
    Left = 8
    Top = 56
    Width = 49
    Height = 13
    Caption = 'MaxGraph'
  end
  object TabbedNotebook1: TTabbedNotebook
    Left = 72
    Top = 8
    Width = 609
    Height = 113
    PageIndex = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TabFont.Charset = DEFAULT_CHARSET
    TabFont.Color = clBtnText
    TabFont.Height = -11
    TabFont.Name = 'MS Sans Serif'
    TabFont.Style = []
    TabOrder = 0
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Curve handling'
      object DeleteCurve: TButton
        Left = 136
        Top = 8
        Width = 81
        Height = 25
        Caption = 'Delete curve'
        TabOrder = 0
        OnClick = DeleteCurveClick
      end
      object PaintCurve: TButton
        Left = 8
        Top = 40
        Width = 81
        Height = 17
        Caption = 'Paint curve'
        TabOrder = 1
        OnClick = PaintCurveClick
      end
      object ChColor: TButton
        Left = 8
        Top = 8
        Width = 113
        Height = 25
        Caption = 'Change Color'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = ChColorClick
      end
      object DeleteAll: TButton
        Left = 376
        Top = 16
        Width = 81
        Height = 25
        Caption = 'Delete All'
        TabOrder = 3
        OnClick = DeleteAllClick
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Axis'
      object Label2: TLabel
        Left = 8
        Top = 24
        Width = 25
        Height = 13
        Caption = 'Titles'
      end
      object xAxisTitle: TEdit
        Left = 56
        Top = 16
        Width = 57
        Height = 21
        TabOrder = 0
        Text = 'Voltage'
      end
      object yAxisTitle: TEdit
        Left = 56
        Top = 40
        Width = 73
        Height = 21
        TabOrder = 1
        Text = 'Conductance'
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Load data'
      object Label3: TLabel
        Left = 200
        Top = 16
        Width = 53
        Height = 13
        Caption = 'File Name: '
      end
      object Label4: TLabel
        Left = 256
        Top = 16
        Width = 39
        Height = 13
        Caption = 'myname'
      end
      object Label5: TLabel
        Left = 312
        Top = 16
        Width = 32
        Height = 13
        Caption = 'Plot Nr'
      end
      object Label6: TLabel
        Left = 352
        Top = 16
        Width = 6
        Height = 13
        Caption = '0'
      end
      object LoadData: TButton
        Left = 8
        Top = 0
        Width = 57
        Height = 25
        Caption = 'LoadData'
        TabOrder = 0
        OnClick = LoadDataClick
      end
      object Button1: TButton
        Left = 80
        Top = 0
        Width = 57
        Height = 25
        Caption = 'Load blq'
        TabOrder = 1
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 200
        Top = 32
        Width = 49
        Height = 17
        Caption = 'Next'
        TabOrder = 2
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 200
        Top = 48
        Width = 49
        Height = 17
        Caption = 'Previous'
        TabOrder = 3
        OnClick = Button3Click
      end
      object SpinEdit1: TSpinEdit
        Left = 264
        Top = 40
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 1
        TabOrder = 4
        Value = 1
      end
      object CheckDeriva: TCheckBox
        Left = 320
        Top = 56
        Width = 65
        Height = 17
        Caption = 'Derivada'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object Button4: TButton
        Left = 432
        Top = 32
        Width = 49
        Height = 17
        Caption = 'Go To'
        TabOrder = 6
        OnClick = Button4Click
      end
      object GotoPlotNr: TEdit
        Left = 432
        Top = 48
        Width = 41
        Height = 21
        TabOrder = 7
        Text = '1'
      end
      object CheckBox2: TCheckBox
        Left = 488
        Top = 40
        Width = 81
        Height = 25
        Caption = 'Ida y Vuelta'
        TabOrder = 8
      end
      object CheckBox3: TCheckBox
        Left = 488
        Top = 64
        Width = 97
        Height = 17
        Caption = 'Promedia i y v'
        Checked = True
        State = cbChecked
        TabOrder = 9
      end
      object RadioGroup3: TRadioGroup
        Left = 8
        Top = 32
        Width = 65
        Height = 49
        Caption = 'Separator'
        ItemIndex = 0
        Items.Strings = (
          'Tab'
          'Space')
        TabOrder = 10
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Save data'
      object Savedata: TButton
        Left = 16
        Top = 16
        Width = 105
        Height = 25
        Caption = 'Save Active Curve'
        TabOrder = 0
        OnClick = SavedataClick
      end
      object Button5: TButton
        Left = 16
        Top = 48
        Width = 105
        Height = 25
        Caption = 'Save all curves'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'Clipboard'
      object CopyClip: TButton
        Left = 16
        Top = 24
        Width = 105
        Height = 25
        Caption = 'Copy to Clipboard'
        TabOrder = 0
        OnClick = CopyClipClick
      end
      object CopyfClip: TButton
        Left = 152
        Top = 24
        Width = 105
        Height = 25
        Caption = 'Copy from Clipboard'
        TabOrder = 1
        OnClick = CopyfClipClick
      end
    end
    object TTabPage
      Left = 4
      Top = 24
      Caption = 'FFT'
      object Label9: TLabel
        Left = 176
        Top = 40
        Width = 24
        Height = 13
        Caption = '2000'
      end
      object Label10: TLabel
        Left = 176
        Top = 64
        Width = 6
        Height = 13
        Caption = '1'
      end
      object Label11: TLabel
        Left = 272
        Top = 8
        Width = 39
        Height = 13
        Caption = 'File Size'
      end
      object RadioGroup1: TRadioGroup
        Left = 0
        Top = 0
        Width = 89
        Height = 65
        Caption = 'Pass'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'Low Pass'
          'High Pass'
          'Band Stop'
          'Band Pass')
        ParentFont = False
        TabOrder = 0
        OnClick = RadioGroup1Click
      end
      object ScrollBar1: TScrollBar
        Left = 216
        Top = 40
        Width = 193
        Height = 17
        Hint = 'Frequency 1'
        LargeChange = 100
        Max = 2000
        Min = 1
        PageSize = 0
        ParentShowHint = False
        Position = 2000
        ShowHint = True
        TabOrder = 1
        OnChange = ScrollBar1Change
      end
      object ScrollBar2: TScrollBar
        Left = 216
        Top = 64
        Width = 193
        Height = 17
        Hint = 'Frequency 2'
        LargeChange = 100
        Max = 2000
        Min = 1
        PageSize = 0
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 2
        OnChange = ScrollBar2Change
      end
      object Button11: TButton
        Left = 424
        Top = 56
        Width = 73
        Height = 25
        Caption = 'Try FFT'
        TabOrder = 3
        OnClick = Button11Click
      end
      object RadioGroup2: TRadioGroup
        Left = 96
        Top = 0
        Width = 73
        Height = 65
        Caption = 'Kind'
        ItemIndex = 3
        Items.Strings = (
          'Bessel'
          'Butterw'
          'Cheby'
          'Fixed')
        TabOrder = 4
        OnClick = RadioGroup2Click
      end
      object SpinEdit2: TSpinEdit
        Left = 176
        Top = 8
        Width = 41
        Height = 22
        Hint = 'Order of Filter'
        MaxValue = 8
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Value = 2
        OnChange = SpinEdit2Change
      end
      object Button12: TButton
        Left = 424
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Try Filter'
        TabOrder = 6
        OnClick = Button12Click
      end
      object Button7: TButton
        Left = 520
        Top = 16
        Width = 73
        Height = 25
        Caption = 'Do Filter All'
        TabOrder = 7
        OnClick = Button7Click
      end
    end
  end
  object ActiveCurveNr: TSpinEdit
    Left = 8
    Top = 24
    Width = 41
    Height = 30
    Color = clTeal
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MaxValue = 100
    MinValue = 1
    ParentFont = False
    TabOrder = 1
    Value = 1
    OnChange = ActiveCurveNrChange
  end
  object Edit2: TEdit
    Left = 8
    Top = 88
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '0.1'
  end
  object CheckBox4: TCheckBox
    Left = 8
    Top = 72
    Width = 65
    Height = 17
    Caption = 'Mult Cur'
    TabOrder = 3
  end
  object Button8: TButton
    Left = 8
    Top = 112
    Width = 57
    Height = 17
    Caption = 'Displace y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button8Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 128
    Width = 689
    Height = 521
    Caption = 'Panel1'
    TabOrder = 5
    object Splitter1: TSplitter
      Left = 673
      Top = 1
      Height = 519
      Beveled = True
      MinSize = 20
    end
    object FilterGraph: TxyyGraph
      Left = 676
      Top = 1
      Width = 12
      Height = 519
      Cursor = crCross
      BackgroundColor = clWhite
      Title = 'FFT Graph'
      AutoScaling = True
      Align = alClient
      AntiFlicker = False
    end
    object GenGraph: TxyyGraph
      Left = 1
      Top = 1
      Width = 672
      Height = 519
      Cursor = crCross
      BackgroundColor = clWhite
      Title = 'All Graph'
      AutoScaling = True
      Align = alLeft
      AntiFlicker = False
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.txt'
    FileName = '*.dat'
    Filter = 'txt|.txt|dat|.dat'
    FilterIndex = 2
    InitialDir = 'c:\hermann'
    Left = 644
    Top = 528
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.dat'
    FileName = 'hola'
    Filter = 'txt|.txt|dat|.dat'
    InitialDir = 'c:\'
    Left = 608
    Top = 528
  end
  object ColorDialog1: TColorDialog
    Color = clTeal
    Left = 572
    Top = 528
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = '.blq'
    FileName = '*.blq'
    Filter = 'blq|*.blq|*|*.*'
    Left = 604
    Top = 568
  end
end
