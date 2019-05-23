object Form1: TForm1
  Left = 534
  Top = 182
  Width = 1032
  Height = 654
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 1016
    Height = 616
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    TabOrder = 0
    object SinSeries: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      PercentFormat = '##0,## %'
      SeriesColor = clRed
      Title = 'y=sin(x)'
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
    object CosSeries: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      PercentFormat = '##0,## %'
      SeriesColor = clBlue
      Title = 'y=cos(x)'
      ValueFormat = '#,##0,###'
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
    object SinCosSeries: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      PercentFormat = '##0,## %'
      SeriesColor = clGreen
      Title = 'y=sin(x)*cos(x)'
      ValueFormat = '#,##0,###'
      LinePen.Color = clGreen
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
