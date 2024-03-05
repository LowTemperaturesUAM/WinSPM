object ScanForm: TScanForm
  Left = 861
  Top = 24
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WinSPM'
  ClientHeight = 595
  ClientWidth = 587
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
  object Label29: TLabel
    Left = 251
    Top = 512
    Width = 36
    Height = 13
    Caption = 'Size (V)'
  end
  object Label30: TLabel
    Left = 296
    Top = 512
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label31: TLabel
    Left = 324
    Top = 512
    Width = 43
    Height = 13
    Caption = 'Size (nm)'
  end
  object Label32: TLabel
    Left = 376
    Top = 512
    Width = 6
    Height = 13
    Caption = '0'
  end
  object ScanButton: TButton
    Left = 56
    Top = 8
    Width = 57
    Height = 41
    Caption = 'Do'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ScanButtonClick
  end
  object TestButton: TButton
    Left = 152
    Top = 8
    Width = 57
    Height = 41
    Caption = 'Test'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = TestButtonClick
  end
  object ConfigBtn: TButton
    Left = 224
    Top = 8
    Width = 49
    Height = 41
    Caption = 'Config'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = ConfigBtnClick
  end
  object SaveAllImg: TCheckBox
    Left = 400
    Top = 32
    Width = 65
    Height = 17
    Caption = 'Save All'
    TabOrder = 3
    OnClick = SaveAllImgClick
  end
  object Panel1: TPanel
    Left = 448
    Top = 56
    Width = 129
    Height = 89
    TabOrder = 4
    object ZoomInLbl: TLabel
      Left = 9
      Top = 38
      Width = 39
      Height = 13
      Caption = 'Zoom In'
    end
    object ComboBox1: TComboBox
      Left = 60
      Top = 35
      Width = 53
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = '1'
      OnChange = ComboBox1Change
      Items.Strings = (
        '1'
        '2'
        '5'
        '10'
        '20'
        '50'
        '100'
        '200'
        '500'
        '1000'
        '2000'
        '5000')
    end
    object ClearBtn: TButton
      Left = 23
      Top = 5
      Width = 75
      Height = 17
      Caption = 'Clear'
      TabOrder = 0
      OnClick = ClearBtnClick
    end
    object btnMarkNow: TButton
      Left = -1
      Top = 64
      Width = 66
      Height = 17
      Caption = 'Mark now'
      TabOrder = 2
      OnClick = btnMarkNowClick
    end
    object MarkRedBtn: TButton
      Left = 72
      Top = 64
      Width = 57
      Height = 17
      Caption = 'Mark Red'
      TabOrder = 3
      OnClick = MarkRedBtnClick
    end
  end
  object Panel2: TPanel
    Left = 448
    Top = 151
    Width = 129
    Height = 329
    TabOrder = 5
    object Label2: TLabel
      Left = 34
      Top = 0
      Width = 53
      Height = 13
      Caption = 'Scan Lines'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 27
      Height = 13
      Caption = 'Mean'
    end
    object Label4: TLabel
      Left = 16
      Top = 216
      Width = 6
      Height = 13
      Caption = '1'
    end
    object Label5: TLabel
      Left = 41
      Top = 48
      Width = 25
      Height = 13
      Caption = 'Jump'
    end
    object Label6: TLabel
      Left = 48
      Top = 216
      Width = 18
      Height = 13
      Caption = '100'
    end
    object Label7: TLabel
      Left = 72
      Top = 48
      Width = 20
      Height = 13
      Caption = 'Size'
    end
    object Label8: TLabel
      Left = 80
      Top = 216
      Width = 12
      Height = 13
      Caption = '10'
    end
    object LblLinesBefore: TLabel
      Left = 8
      Top = 243
      Width = 59
      Height = 13
      AutoSize = False
      Caption = 'Lines Before'
    end
    object ComboBox2: TComboBox
      Left = 28
      Top = 16
      Width = 65
      Height = 21
      ItemHeight = 13
      ItemIndex = 5
      TabOrder = 0
      Text = '256'
      OnChange = ComboBox2Change
      Items.Strings = (
        '8'
        '16'
        '32'
        '64'
        '128'
        '256'
        '512')
    end
    object TrackBar2: TTrackBar
      Left = 41
      Top = 64
      Width = 33
      Height = 150
      Max = 100
      Min = 1
      Orientation = trVertical
      Frequency = 10
      Position = 100
      SelEnd = 100
      SelStart = 1
      TabOrder = 1
      TickStyle = tsNone
      OnChange = TrackBar2Change
    end
    object TrackBar3: TTrackBar
      Left = 74
      Top = 64
      Width = 33
      Height = 150
      Max = 1000
      Min = 2
      Orientation = trVertical
      PageSize = 1
      Frequency = 10
      Position = 200
      SelEnd = 1000
      SelStart = 1
      TabOrder = 2
      TickStyle = tsNone
      OnChange = TrackBar3Change
    end
    object MakeIVChk: TCheckBox
      Left = 0
      Top = 304
      Width = 65
      Height = 17
      Caption = 'Make IV'
      TabOrder = 4
      OnClick = MakeIVChkClick
    end
    object STSConfigBtn: TButton
      Left = 62
      Top = 304
      Width = 65
      Height = 17
      Caption = 'IV Config'
      TabOrder = 5
      OnClick = STSConfigBtnClick
    end
    object btnCenterAtTip: TButton
      Left = 0
      Top = 280
      Width = 65
      Height = 17
      Caption = 'Center at tip'
      TabOrder = 3
      OnClick = btnCenterAtTipClick
    end
    object Panel3: TPanel
      Left = 72
      Top = 280
      Width = 53
      Height = 17
      BevelOuter = bvNone
      Color = clRed
      TabOrder = 6
      object Button9: TSpeedButton
        Left = 0
        Top = 0
        Width = 53
        Height = 17
        Caption = 'Tip reset'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = Button9Click
      end
    end
    object SpinLinesBefore: TSpinEdit
      Left = 70
      Top = 240
      Width = 41
      Height = 22
      MaxValue = 10
      MinValue = 0
      TabOrder = 7
      Value = 0
    end
  end
  object TrackBar1: TTrackBar
    Left = 456
    Top = 215
    Width = 33
    Height = 150
    Max = 100
    Min = 1
    Orientation = trVertical
    Frequency = 10
    Position = 1
    SelEnd = 100
    SelStart = 1
    TabOrder = 6
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object SaveImgButton: TButton
    Left = 464
    Top = 32
    Width = 81
    Height = 17
    Caption = 'Save present'
    TabOrder = 7
    OnClick = SaveImgButtonClick
  end
  object ScrollBox1: TScrollBox
    Left = 16
    Top = 56
    Width = 404
    Height = 404
    Cursor = crCross
    HorzScrollBar.Tracking = True
    TabOrder = 8
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 400
      Height = 400
      Color = clBlack
      ParentColor = False
      OnDblClick = PaintBox1DblClick
      OnPaint = PaintBox1Paint
    end
  end
  object StopBtn: TButton
    Left = 449
    Top = 486
    Width = 128
    Height = 30
    Caption = 'Stop'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = StopBtnClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 41
    Height = 41
    Caption = 'Scan'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemIndex = 0
    Items.Strings = (
      'X'
      'Y')
    ParentFont = False
    TabOrder = 10
  end
  object OpenTripBtn: TButton
    Left = 408
    Top = 528
    Width = 81
    Height = 33
    Caption = 'Open Trip'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = OpenTripBtnClick
  end
  object OpenLinerBtn: TButton
    Left = 320
    Top = 528
    Width = 81
    Height = 33
    Caption = 'Open Liner'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = OpenLinerBtnClick
  end
  object FileNameEdit: TEdit
    Left = 280
    Top = 8
    Width = 113
    Height = 21
    TabOrder = 13
    Text = 'Name'
  end
  object Button3: TButton
    Left = 280
    Top = 32
    Width = 113
    Height = 17
    Caption = 'Set File Name'
    TabOrder = 14
    OnClick = Button3Click
  end
  object ImgNumberSpin: TSpinEdit
    Left = 400
    Top = 8
    Width = 57
    Height = 22
    MaxValue = 999
    MinValue = 1
    TabOrder = 15
    Value = 1
  end
  object HeaderImgBtn: TButton
    Left = 464
    Top = 8
    Width = 81
    Height = 17
    Caption = 'Image Header'
    TabOrder = 16
    OnClick = HeaderImgBtnClick
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 512
    Width = 97
    Height = 17
    Caption = 'Paint Last Img'
    TabOrder = 17
  end
  object ShowDirBtn: TButton
    Left = 320
    Top = 568
    Width = 129
    Height = 17
    Caption = 'Show Full File Directories'
    TabOrder = 18
    OnClick = ShowDirBtnClick
  end
  object InitDACBtn: TButton
    Left = 16
    Top = 560
    Width = 75
    Height = 22
    Caption = 'Init All'
    TabOrder = 19
    OnClick = InitDACBtnClick
  end
  object SpinEdit2: TSpinEdit
    Left = 104
    Top = 560
    Width = 41
    Height = 22
    MaxLength = 7
    MaxValue = 7
    MinValue = 0
    TabOrder = 20
    Value = 0
  end
  object ScrollBar1: TScrollBar
    Left = 152
    Top = 560
    Width = 121
    Height = 20
    LargeChange = 10
    Max = 32767
    Min = -32767
    PageSize = 0
    TabOrder = 21
    OnChange = ScrollBar1Change
  end
  object OpenDataAcqBtn: TButton
    Left = 456
    Top = 568
    Width = 121
    Height = 17
    Caption = 'Open Data Acquisition'
    TabOrder = 22
    OnClick = OpenDataAcqBtnClick
  end
  object CheckBox6: TCheckBox
    Left = 112
    Top = 512
    Width = 89
    Height = 17
    Caption = 'Paint Lines'
    Checked = True
    State = cbChecked
    TabOrder = 23
  end
  object OpenPIDBtn: TButton
    Left = 496
    Top = 528
    Width = 81
    Height = 33
    Caption = 'ShowPID'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 24
    OnClick = OpenPIDBtnClick
  end
  object PasteImgBtn: TButton
    Left = 16
    Top = 533
    Width = 75
    Height = 22
    Caption = 'Paste'
    TabOrder = 25
    OnClick = PasteImgBtnClick
  end
  object ScrollBar2: TScrollBar
    Left = 424
    Top = 56
    Width = 17
    Height = 401
    Kind = sbVertical
    PageSize = 0
    Position = 50
    TabOrder = 26
    OnChange = ScrollBar2Change
  end
  object ScrollBar3: TScrollBar
    Left = 16
    Top = 464
    Width = 401
    Height = 17
    PageSize = 0
    Position = 50
    TabOrder = 27
    OnChange = ScrollBar3Change
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'stp'
    Filter = 'stp|*.stp|All Files|*.*'
    InitialDir = 'c:\resultados'
    Left = 8
    Top = 56
  end
end
