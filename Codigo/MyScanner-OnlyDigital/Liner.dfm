object LinerForm: TLinerForm
  Left = 24
  Top = 24
  Width = 852
  Height = 649
  HorzScrollBar.Visible = False
  Caption = 'Bias Module'
  Color = clBtnFace
  Constraints.MinHeight = 649
  Constraints.MinWidth = 852
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    836
    610)
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel
    Left = 16
    Top = 516
    Width = 682
    Height = 85
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      682
      85)
    object TempLbl: TLabel
      Left = 16
      Top = 52
      Width = 91
      Height = 13
      Caption = 'TEMPERATURE ='
    end
    object KelvinLbl: TLabel
      Left = 176
      Top = 52
      Width = 7
      Height = 13
      Caption = 'K'
    end
    object MagFieldLbl: TLabel
      Left = 224
      Top = 52
      Width = 98
      Height = 13
      Caption = 'MAGNETIC FIELD ='
    end
    object TeslaLbl: TLabel
      Left = 392
      Top = 52
      Width = 7
      Height = 13
      Caption = 'T'
    end
    object SizeLbl: TLabel
      Left = 604
      Top = 14
      Width = 20
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Size'
    end
    object xAxisRange: TLabel
      Left = 630
      Top = 14
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = '100'
    end
    object ZAttText: TLabel
      Left = 552
      Top = 48
      Width = 64
      Height = 13
      AutoSize = False
      Caption = 'Z Attenuation'
      Visible = False
    end
    object BiasAttText: TLabel
      Left = 552
      Top = 64
      Width = 77
      Height = 13
      AutoSize = False
      Caption = 'Bias Attenuation'
      Visible = False
    end
    object ZAttDispValue: TLabel
      Left = 640
      Top = 48
      Width = 20
      Height = 13
      AutoSize = False
      Caption = '1'
      Visible = False
    end
    object BiasAttDispValue: TLabel
      Left = 640
      Top = 64
      Width = 20
      Height = 13
      AutoSize = False
      Caption = '1'
      Visible = False
    end
    object chkPainYesNo: TCheckBox
      Left = 424
      Top = 50
      Width = 70
      Height = 17
      Caption = 'Paint Lines'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = chkPainYesNoClick
    end
    object TemperatureEdit: TEdit
      Left = 112
      Top = 48
      Width = 57
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '1'
      OnChange = TemperatureEditEnter
    end
    object MagFieldEdit: TEdit
      Left = 328
      Top = 48
      Width = 57
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = MagFieldEditEnter
    end
    object scrollSizeBias: TScrollBar
      Left = 16
      Top = 8
      Width = 577
      Height = 25
      PageSize = 0
      Position = 100
      TabOrder = 3
      OnChange = scrollSizeBiasChange
    end
  end
  object RightPanel: TPanel
    Left = 700
    Top = 56
    Width = 129
    Height = 537
    Anchors = [akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 1
    object ptsNumberLbl: TLabel
      Left = 16
      Top = 56
      Width = 81
      Height = 13
      Caption = 'Number of Points'
    end
    object DerivPtsLbl: TLabel
      Left = 61
      Top = 296
      Width = 52
      Height = 13
      Caption = 'Der. Points'
    end
    object MeanLbl: TLabel
      Left = 16
      Top = 408
      Width = 41
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Mean'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object JumpLbl: TLabel
      Left = 16
      Top = 434
      Width = 41
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Jump'
    end
    object lblColorPID: TLabel
      Left = 10
      Top = 30
      Width = 3
      Height = 13
    end
    object OSRatioLbl: TLabel
      Left = 14
      Top = 510
      Width = 64
      Height = 13
      AutoSize = False
      Caption = 'Oversampling'
      Enabled = False
      Visible = False
    end
    object ReEnablePIDchk: TCheckBox
      Left = 64
      Top = 28
      Width = 65
      Height = 17
      Caption = 'On Take'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object HoldBtn: TButton
      Left = 16
      Top = 28
      Width = 41
      Height = 17
      Caption = 'Hold'
      TabOrder = 1
      OnClick = HoldFeedback
    end
    object ptnNumberSelect: TComboBox
      Left = 16
      Top = 72
      Width = 105
      Height = 21
      Hint = 'Point Number'
      AutoComplete = False
      Ctl3D = False
      DropDownCount = 10
      ItemHeight = 13
      ItemIndex = 9
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '2048'
      OnChange = ptnNumberSelectChange
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
    object Panel1: TPanel
      Left = 16
      Top = 104
      Width = 105
      Height = 121
      TabOrder = 3
      object AccumLbl: TLabel
        Left = 24
        Top = 0
        Width = 56
        Height = 13
        Caption = 'Accumulate'
      end
      object progressIVLbl: TLabel
        Left = 24
        Top = 20
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = '1 of'
      end
      object CtrlTimeLbl: TLabel
        Left = 25
        Top = 76
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Time for Ctrl'
      end
      object AccumEdit: TSpinEdit
        Left = 48
        Top = 16
        Width = 41
        Height = 22
        MaxValue = 1000
        MinValue = 1
        TabOrder = 0
        Value = 1
      end
      object FinishIVBtn: TButton
        Left = 16
        Top = 40
        Width = 73
        Height = 25
        Caption = 'Finish'
        TabOrder = 1
        OnClick = FinishIVBtnClick
      end
      object CtrlTimeEdit: TSpinEdit
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
    object DerivRadioG: TRadioGroup
      Left = 16
      Top = 232
      Width = 105
      Height = 49
      Caption = 'Plot'
      ItemIndex = 0
      Items.Strings = (
        'Direct'
        'Derivative')
      TabOrder = 4
      OnClick = DerivRadioGClick
    end
    object DerivPtsSpin: TSpinEdit
      Left = 16
      Top = 292
      Width = 41
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 5
      Value = 2
      OnChange = DerivPtsSpinChange
    end
    object CurveTypeRadioG: TRadioGroup
      Left = 16
      Top = 320
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
      TabOrder = 6
      OnClick = ChangePlotType
    end
    object MeanEdit: TSpinEdit
      Left = 56
      Top = 404
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
      TabOrder = 7
      Value = 1
      OnChange = MeanEditChange
    end
    object JumpEdit: TSpinEdit
      Left = 56
      Top = 430
      Width = 49
      Height = 22
      MaxValue = 100
      MinValue = 1
      TabOrder = 8
      Value = 1
      OnChange = JumpEditChange
    end
    object chkAcquireBlock: TCheckBox
      Left = 16
      Top = 464
      Width = 113
      Height = 17
      Caption = 'Buffered acquisition'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = chkAcquireBlockClick
    end
    object DeleteBtn: TButton
      Left = 30
      Top = 488
      Width = 75
      Height = 17
      Caption = 'Delete Graph'
      TabOrder = 10
      OnClick = DeleteBtnClick
    end
    object OSRatioEdit: TSpinEdit
      Left = 84
      Top = 506
      Width = 36
      Height = 22
      AutoSize = False
      EditorEnabled = False
      Enabled = False
      MaxValue = 64
      MinValue = 0
      TabOrder = 11
      Value = 0
      Visible = False
      OnChange = OSRatioEditChange
    end
  end
  object TopPanel: TPanel
    Left = 16
    Top = 0
    Width = 793
    Height = 57
    BevelOuter = bvNone
    TabOrder = 2
    object lblCurveCount: TLabel
      Left = 584
      Top = 35
      Width = 6
      Height = 13
      Alignment = taRightJustify
      Caption = '0'
    end
    object DoBtn: TButton
      Left = 8
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
      OnClick = doIV_reduce
    end
    object DoRepeatBtn: TButton
      Left = 85
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
      OnClick = doOnRepeat
    end
    object AbortButton: TButton
      Left = 170
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
    end
    object ConfigBtn: TButton
      Left = 280
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
      TabOrder = 3
      OnClick = OpenConfig
    end
    object curveNameEdit: TEdit
      Left = 392
      Top = 8
      Width = 137
      Height = 21
      Cursor = crIBeam
      AutoSize = False
      MaxLength = 24
      TabOrder = 4
      Text = 'FileName'
    end
    object setNameBtn: TButton
      Left = 392
      Top = 32
      Width = 137
      Height = 17
      Caption = 'Set File Name'
      TabOrder = 5
      OnClick = setFileName
    end
    object FileNumberSpin: TSpinEdit
      Left = 536
      Top = 8
      Width = 57
      Height = 22
      MaxValue = 999
      MinValue = 1
      TabOrder = 6
      Value = 1
      OnChange = FileNumberSpinChange
    end
    object SaveCurveBtn: TButton
      Left = 600
      Top = 8
      Width = 75
      Height = 22
      Caption = 'Save present'
      TabOrder = 7
      OnClick = saveBLQ
    end
    object chkSaveAllCurves: TCheckBox
      Left = 608
      Top = 34
      Width = 65
      Height = 17
      Caption = 'Save All'
      TabOrder = 8
    end
    object DoOSbtn: TButton
      Left = 256
      Top = 8
      Width = 17
      Height = 25
      Caption = 'DoOSbtn'
      Enabled = False
      TabOrder = 9
      Visible = False
      OnClick = doIV_reduce
    end
  end
  object GraphPanel: TPanel
    Left = 16
    Top = 56
    Width = 682
    Height = 457
    BevelOuter = bvNone
    Caption = 'GraphPanel'
    TabOrder = 3
    object chartLine: TChart
      Left = 0
      Top = 0
      Width = 682
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
      BottomAxis.AxisValuesFormat = '#,##0.#####'
      DepthAxis.Automatic = False
      DepthAxis.AutomaticMaximum = False
      DepthAxis.AutomaticMinimum = False
      DepthAxis.Maximum = 0.500000000000000000
      DepthAxis.Minimum = -0.500000000000000000
      LeftAxis.AxisValuesFormat = '0.####E+0'
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
      Align = alClient
      Color = clWhite
      TabOrder = 0
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
  end
  object SaveDialog1: TSaveDialog
    Ctl3D = False
    Filter = 
      'BLQ files|*.blq|WSxM curve files|*.cur|WSxM spectroscopy files|*' +
      '.gsi|All files|*.*'
    InitialDir = 'c:\Results'
    Left = 768
    Top = 16
  end
  object OpenDialog1: TOpenDialog
    Left = 720
    Top = 16
  end
end
