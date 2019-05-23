VERSION 5.00
Object = "{D940E4E4-6079-11CE-88CB-0020AF6845F6}#1.6#0"; "cwui.ocx"
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Test USBSPI-DAC-ADC"
   ClientHeight    =   9975
   ClientLeft      =   150
   ClientTop       =   780
   ClientWidth     =   12315
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   ScaleHeight     =   9975
   ScaleWidth      =   12315
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text5 
      Height          =   285
      Left            =   10920
      TabIndex        =   87
      Top             =   120
      Width           =   1215
   End
   Begin VB.TextBox Text4 
      Height          =   1575
      Left            =   1800
      MultiLine       =   -1  'True
      TabIndex        =   76
      Top             =   8160
      Width           =   2295
   End
   Begin VB.CommandButton Command5 
      Caption         =   "LeerADC"
      Height          =   375
      Left            =   240
      TabIndex        =   75
      Top             =   8640
      Width           =   1215
   End
   Begin VB.TextBox Text3 
      Height          =   375
      Left            =   480
      TabIndex        =   70
      Top             =   7320
      Width           =   855
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   480
      TabIndex        =   69
      Top             =   6840
      Width           =   855
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Reloj    a 0"
      Height          =   855
      Left            =   1560
      TabIndex        =   68
      Top             =   6840
      Width           =   855
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Escribir ATT"
      Height          =   375
      Left            =   2400
      TabIndex        =   67
      Top             =   6960
      Width           =   1695
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Conf DIO"
      Height          =   255
      Left            =   10320
      TabIndex        =   66
      Top             =   6720
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   5880
      TabIndex        =   65
      Top             =   6720
      Width           =   3855
   End
   Begin VB.CheckBox BIT1_DIO 
      Caption         =   "Check1"
      Height          =   255
      Left            =   9000
      TabIndex        =   64
      Top             =   6120
      Value           =   1  'Checked
      Width           =   255
   End
   Begin VB.CommandButton Salida_digital 
      Caption         =   "Salida Digital 1"
      Height          =   255
      Left            =   9600
      TabIndex        =   63
      Top             =   6120
      Width           =   1215
   End
   Begin VB.CheckBox dac1_dac2 
      Caption         =   "ADC1_ADC2"
      Height          =   385
      Left            =   2160
      TabIndex        =   61
      Top             =   1200
      Value           =   1  'Checked
      Width           =   1575
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   492
      Left            =   3840
      TabIndex        =   58
      Top             =   5940
      Width           =   1332
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   492
      Left            =   2400
      TabIndex        =   55
      Top             =   5940
      Width           =   1332
   End
   Begin VB.Frame frScan 
      Caption         =   "Scan"
      ForeColor       =   &H00FF0000&
      Height          =   1188
      Left            =   4380
      TabIndex        =   47
      Top             =   60
      Width           =   5892
      Begin VB.CheckBox chkADCEnabled 
         BackColor       =   &H00FEFFDF&
         Caption         =   "ADC Enabled"
         Height          =   312
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   54
         Top             =   720
         Value           =   1  'Checked
         Width           =   1224
      End
      Begin VB.CheckBox chkDACEnabled 
         BackColor       =   &H00FFE3FF&
         Caption         =   "DAC Enabled"
         Height          =   312
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   53
         Top             =   300
         Value           =   1  'Checked
         Width           =   1224
      End
      Begin CWUIControlsLib.CWNumEdit neLoops 
         Height          =   252
         Left            =   2280
         TabIndex        =   51
         Top             =   300
         Width           =   492
         _Version        =   524288
         _ExtentX        =   868
         _ExtentY        =   444
         _StockProps     =   4
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.14
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Reset_0         =   0   'False
         CompatibleVers_0=   524288
         NumEdit_0       =   1
         ClassName_1     =   "CCWNumEdit"
         opts_1          =   393278
         BorderStyle_1   =   1
         ButtonPosition_1=   1
         TextAlignment_1 =   2
         format_1        =   2
         ClassName_2     =   "CCWFormat"
         scale_1         =   3
         ClassName_3     =   "CCWScale"
         opts_3          =   65536
         dMax_3          =   10
         discInterval_3  =   1
         ValueVarType_1  =   5
         Value_Val_1     =   3
         IncValueVarType_1=   5
         IncValue_Val_1  =   1
         AccelIncVarType_1=   5
         AccelInc_Val_1  =   5
         RangeMinVarType_1=   5
         RangeMin_Val_1  =   1
         RangeMaxVarType_1=   5
         RangeMax_Val_1  =   10
         ButtonStyle_1   =   0
         Bindings_1      =   4
         ClassName_4     =   "CCWBindingHolderArray"
         Editor_4        =   5
         ClassName_5     =   "CCWBindingHolderArrayEditor"
         Owner_5         =   1
      End
      Begin VB.CheckBox chkTurbo 
         Caption         =   "Turbo Mode"
         Height          =   312
         Left            =   1560
         Style           =   1  'Graphical
         TabIndex        =   50
         Top             =   720
         Width           =   1224
      End
      Begin VB.OptionButton opStartStop 
         BackColor       =   &H00C0FFC0&
         Caption         =   "&Start"
         Height          =   312
         Index           =   1
         Left            =   4200
         Style           =   1  'Graphical
         TabIndex        =   49
         Top             =   300
         Width           =   1452
      End
      Begin VB.OptionButton opStartStop 
         BackColor       =   &H00C0C0FF&
         Caption         =   "S&top"
         Height          =   312
         Index           =   0
         Left            =   4200
         Style           =   1  'Graphical
         TabIndex        =   48
         Top             =   720
         Value           =   -1  'True
         Width           =   1452
      End
      Begin VB.Timer TimerLoop 
         Enabled         =   0   'False
         Interval        =   2000
         Left            =   3660
         Top             =   720
      End
      Begin VB.Label lblPoints 
         Alignment       =   1  'Right Justify
         Caption         =   "400"
         Height          =   252
         Left            =   2820
         TabIndex        =   57
         Top             =   360
         Width           =   432
      End
      Begin VB.Label Label18 
         Caption         =   "Pts/Loop"
         Height          =   252
         Left            =   3300
         TabIndex        =   56
         Top             =   360
         Width           =   732
      End
      Begin VB.Label Label10 
         Caption         =   "Loops"
         Height          =   252
         Left            =   1560
         TabIndex        =   52
         Top             =   360
         Width           =   492
      End
   End
   Begin VB.CheckBox chkSimulADCRead 
      Caption         =   "Lect. simultánea ADC"
      Height          =   252
      Left            =   120
      TabIndex        =   33
      Top             =   5940
      Width           =   1935
   End
   Begin VB.CheckBox chkSimulDACRead 
      Caption         =   "Lect. simultánea DAC"
      Height          =   252
      Left            =   120
      TabIndex        =   32
      Top             =   6240
      Width           =   1935
   End
   Begin VB.Frame frADC 
      Caption         =   "ADC's  (Last Loop)"
      ForeColor       =   &H00FF0000&
      Height          =   4452
      Left            =   4380
      TabIndex        =   30
      Top             =   1320
      Width           =   7875
      Begin CWUIControlsLib.CWGraph cwGrf 
         Height          =   1572
         Index           =   0
         Left            =   120
         TabIndex        =   31
         Top             =   660
         Width           =   3792
         _Version        =   524288
         _ExtentX        =   6694
         _ExtentY        =   2778
         _StockProps     =   71
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Reset_0         =   0   'False
         CompatibleVers_0=   524288
         Graph_0         =   1
         ClassName_1     =   "CCWGraphFrame"
         opts_1          =   62
         C[0]_1          =   0
         C[1]_1          =   14737632
         Event_1         =   2
         ClassName_2     =   "CCWGFPlotEvent"
         Owner_2         =   1
         Plots_1         =   3
         ClassName_3     =   "CCWDataPlots"
         Array_3         =   1
         Editor_3        =   4
         ClassName_4     =   "CCWGFPlotArrayEditor"
         Owner_4         =   1
         Array[0]_3      =   5
         ClassName_5     =   "CCWDataPlot"
         opts_5          =   4194367
         Name_5          =   "Plot-1"
         C[0]_5          =   65280
         C[1]_5          =   65535
         C[2]_5          =   16711680
         C[3]_5          =   16776960
         Event_5         =   2
         X_5             =   6
         ClassName_6     =   "CCWAxis"
         opts_6          =   1599
         Name_6          =   "XAxis"
         C[3]_6          =   2105376
         C[4]_6          =   2105376
         Orientation_6   =   2560
         format_6        =   7
         ClassName_7     =   "CCWFormat"
         Scale_6         =   8
         ClassName_8     =   "CCWScale"
         opts_8          =   90112
         rMin_8          =   38
         rMax_8          =   235
         dMax_8          =   10
         discInterval_8  =   1
         Radial_6        =   0
         Enum_6          =   9
         ClassName_9     =   "CCWEnum"
         Editor_9        =   10
         ClassName_10    =   "CCWEnumArrayEditor"
         Owner_10        =   6
         Font_6          =   11
         ClassName_11    =   "CCWFont"
         bFont_11        =   -1  'True
         BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Small Fonts"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_6      =   2807
         major_6         =   2
         minor_6         =   1
         Caption_6       =   12
         ClassName_12    =   "CCWDrawObj"
         opts_12         =   62
         C[0]_12         =   -2147483640
         Image_12        =   13
         ClassName_13    =   "CCWTextImage"
         font_13         =   0
         Animator_12     =   0
         Blinker_12      =   0
         Y_5             =   14
         ClassName_14    =   "CCWAxis"
         opts_14         =   1599
         Name_14         =   "YAxis-1"
         C[3]_14         =   2105376
         C[4]_14         =   2105376
         Orientation_14  =   2067
         format_14       =   15
         ClassName_15    =   "CCWFormat"
         Scale_14        =   16
         ClassName_16    =   "CCWScale"
         opts_16         =   122880
         rMin_16         =   12
         rMax_16         =   92
         dMax_16         =   10
         discInterval_16 =   1
         Radial_14       =   0
         Enum_14         =   17
         ClassName_17    =   "CCWEnum"
         Editor_17       =   18
         ClassName_18    =   "CCWEnumArrayEditor"
         Owner_18        =   14
         Font_14         =   19
         ClassName_19    =   "CCWFont"
         bFont_19        =   -1  'True
         BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_14     =   2807
         major_14        =   5
         minor_14        =   2.5
         Caption_14      =   20
         ClassName_20    =   "CCWDrawObj"
         opts_20         =   62
         C[0]_20         =   -2147483640
         Image_20        =   21
         ClassName_21    =   "CCWTextImage"
         font_21         =   0
         Animator_20     =   0
         Blinker_20      =   0
         PointStyle_5    =   18
         LineStyle_5     =   1
         LineWidth_5     =   1
         BasePlot_5      =   0
         DefaultXInc_5   =   1
         DefaultPlotPerRow_5=   -1  'True
         Axes_1          =   22
         ClassName_22    =   "CCWAxes"
         Array_22        =   2
         Editor_22       =   23
         ClassName_23    =   "CCWGFAxisArrayEditor"
         Owner_23        =   1
         Array[0]_22     =   6
         Array[1]_22     =   14
         DefaultPlot_1   =   24
         ClassName_24    =   "CCWDataPlot"
         opts_24         =   4194367
         Name_24         =   "[Template]"
         C[0]_24         =   65280
         C[1]_24         =   255
         C[2]_24         =   16711680
         C[3]_24         =   16776960
         Event_24        =   2
         X_24            =   6
         Y_24            =   14
         LineStyle_24    =   1
         LineWidth_24    =   1
         BasePlot_24     =   0
         DefaultXInc_24  =   1
         DefaultPlotPerRow_24=   -1  'True
         Cursors_1       =   25
         ClassName_25    =   "CCWCursors"
         Editor_25       =   26
         ClassName_26    =   "CCWGFCursorArrayEditor"
         Owner_26        =   1
         TrackMode_1     =   2
         GraphFrameStyle_1=   1
         GraphBackground_1=   0
         GraphFrame_1    =   27
         ClassName_27    =   "CCWDrawObj"
         opts_27         =   62
         C[0]_27         =   14737632
         C[1]_27         =   14737632
         Image_27        =   28
         ClassName_28    =   "CCWPictImage"
         opts_28         =   1280
         Rows_28         =   1
         Cols_28         =   1
         Pict_28         =   450
         F_28            =   14737632
         B_28            =   14737632
         ColorReplaceWith_28=   8421504
         ColorReplace_28 =   8421504
         Tolerance_28    =   2
         Animator_27     =   0
         Blinker_27      =   0
         PlotFrame_1     =   29
         ClassName_29    =   "CCWDrawObj"
         opts_29         =   62
         C[0]_29         =   14737632
         C[1]_29         =   0
         Image_29        =   30
         ClassName_30    =   "CCWPictImage"
         opts_30         =   1280
         Rows_30         =   1
         Cols_30         =   1
         Pict_30         =   1
         F_30            =   14737632
         B_30            =   0
         ColorReplaceWith_30=   8421504
         ColorReplace_30 =   8421504
         Tolerance_30    =   2
         Animator_29     =   0
         Blinker_29      =   0
         Caption_1       =   31
         ClassName_31    =   "CCWDrawObj"
         opts_31         =   62
         C[0]_31         =   -2147483640
         Image_31        =   32
         ClassName_32    =   "CCWTextImage"
         font_32         =   0
         Animator_31     =   0
         Blinker_31      =   0
         DefaultXInc_1   =   1
         DefaultPlotPerRow_1=   -1  'True
         Bindings_1      =   33
         ClassName_33    =   "CCWBindingHolderArray"
         Editor_33       =   34
         ClassName_34    =   "CCWBindingHolderArrayEditor"
         Owner_34        =   1
         Annotations_1   =   35
         ClassName_35    =   "CCWAnnotations"
         Editor_35       =   36
         ClassName_36    =   "CCWAnnotationArrayEditor"
         Owner_36        =   1
         AnnotationTemplate_1=   37
         ClassName_37    =   "CCWAnnotation"
         opts_37         =   63
         Name_37         =   "[Template]"
         Plot_37         =   38
         ClassName_38    =   "CCWDataPlot"
         opts_38         =   4194367
         Name_38         =   "[Template]"
         C[0]_38         =   65280
         C[1]_38         =   255
         C[2]_38         =   16711680
         C[3]_38         =   16776960
         Event_38        =   2
         X_38            =   6
         Y_38            =   14
         LineStyle_38    =   1
         LineWidth_38    =   1
         BasePlot_38     =   0
         DefaultXInc_38  =   1
         DefaultPlotPerRow_38=   -1  'True
         Text_37         =   "[Template]"
         TextXPoint_37   =   6.7
         TextYPoint_37   =   6.7
         TextColor_37    =   16777215
         TextFont_37     =   39
         ClassName_39    =   "CCWFont"
         bFont_39        =   -1  'True
         BeginProperty Font_39 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ShapeXPoints_37 =   40
         ClassName_40    =   "CDataBuffer"
         Type_40         =   5
         m_cDims;_40     =   1
         m_cElts_40      =   1
         Element[0]_40   =   3.3
         ShapeYPoints_37 =   41
         ClassName_41    =   "CDataBuffer"
         Type_41         =   5
         m_cDims;_41     =   1
         m_cElts_41      =   1
         Element[0]_41   =   3.3
         ShapeFillColor_37=   16777215
         ShapeLineColor_37=   16777215
         ShapeLineWidth_37=   1
         ShapeLineStyle_37=   1
         ShapePointStyle_37=   10
         ShapeImage_37   =   42
         ClassName_42    =   "CCWDrawObj"
         opts_42         =   62
         Image_42        =   43
         ClassName_43    =   "CCWPictImage"
         opts_43         =   1280
         Rows_43         =   1
         Cols_43         =   1
         Pict_43         =   7
         F_43            =   -2147483633
         B_43            =   -2147483633
         ColorReplaceWith_43=   8421504
         ColorReplace_43 =   8421504
         Tolerance_43    =   2
         Animator_42     =   0
         Blinker_42      =   0
         ArrowVisible_37 =   -1  'True
         ArrowColor_37   =   16777215
         ArrowWidth_37   =   1
         ArrowLineStyle_37=   1
         ArrowHeadStyle_37=   1
      End
      Begin VB.ComboBox cboADCFilter 
         Height          =   288
         ItemData        =   "frmMain.frx":0000
         Left            =   3120
         List            =   "frmMain.frx":0019
         Style           =   2  'Dropdown List
         TabIndex        =   59
         Top             =   300
         Width           =   1512
      End
      Begin VB.CheckBox chkCanalADC 
         BackColor       =   &H00FEFFDF&
         Caption         =   "Channel 4"
         Height          =   312
         Index           =   3
         Left            =   6360
         Style           =   1  'Graphical
         TabIndex        =   45
         Top             =   2400
         Value           =   1  'Checked
         Width           =   1092
      End
      Begin VB.CheckBox chkCanalADC 
         BackColor       =   &H00FEFFDF&
         Caption         =   "Channel 3"
         Height          =   312
         Index           =   2
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   44
         Top             =   2400
         Value           =   1  'Checked
         Width           =   1092
      End
      Begin VB.CheckBox chkCanalADC 
         BackColor       =   &H00FEFFDF&
         Caption         =   "Channel 2"
         Height          =   312
         Index           =   1
         Left            =   6360
         Style           =   1  'Graphical
         TabIndex        =   43
         Top             =   300
         Value           =   1  'Checked
         Width           =   1092
      End
      Begin VB.CheckBox chkCanalADC 
         BackColor       =   &H00FEFFDF&
         Caption         =   "Channel 1"
         Height          =   312
         Index           =   0
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   42
         Top             =   300
         Value           =   1  'Checked
         Width           =   1092
      End
      Begin CWUIControlsLib.CWGraph cwGrf 
         Height          =   1572
         Index           =   1
         Left            =   3960
         TabIndex        =   39
         Top             =   660
         Width           =   3792
         _Version        =   524288
         _ExtentX        =   6694
         _ExtentY        =   2778
         _StockProps     =   71
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Reset_0         =   0   'False
         CompatibleVers_0=   524288
         Graph_0         =   1
         ClassName_1     =   "CCWGraphFrame"
         opts_1          =   62
         C[0]_1          =   0
         C[1]_1          =   14737632
         Event_1         =   2
         ClassName_2     =   "CCWGFPlotEvent"
         Owner_2         =   1
         Plots_1         =   3
         ClassName_3     =   "CCWDataPlots"
         Array_3         =   1
         Editor_3        =   4
         ClassName_4     =   "CCWGFPlotArrayEditor"
         Owner_4         =   1
         Array[0]_3      =   5
         ClassName_5     =   "CCWDataPlot"
         opts_5          =   4194367
         Name_5          =   "Plot-1"
         C[0]_5          =   65280
         C[1]_5          =   65535
         C[2]_5          =   16711680
         C[3]_5          =   16776960
         Event_5         =   2
         X_5             =   6
         ClassName_6     =   "CCWAxis"
         opts_6          =   1599
         Name_6          =   "XAxis"
         C[3]_6          =   2105376
         C[4]_6          =   2105376
         Orientation_6   =   2560
         format_6        =   7
         ClassName_7     =   "CCWFormat"
         Scale_6         =   8
         ClassName_8     =   "CCWScale"
         opts_8          =   90112
         rMin_8          =   38
         rMax_8          =   235
         dMax_8          =   10
         discInterval_8  =   1
         Radial_6        =   0
         Enum_6          =   9
         ClassName_9     =   "CCWEnum"
         Editor_9        =   10
         ClassName_10    =   "CCWEnumArrayEditor"
         Owner_10        =   6
         Font_6          =   11
         ClassName_11    =   "CCWFont"
         bFont_11        =   -1  'True
         BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Small Fonts"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_6      =   2807
         major_6         =   2
         minor_6         =   1
         Caption_6       =   12
         ClassName_12    =   "CCWDrawObj"
         opts_12         =   62
         C[0]_12         =   -2147483640
         Image_12        =   13
         ClassName_13    =   "CCWTextImage"
         font_13         =   0
         Animator_12     =   0
         Blinker_12      =   0
         Y_5             =   14
         ClassName_14    =   "CCWAxis"
         opts_14         =   1599
         Name_14         =   "YAxis-1"
         C[3]_14         =   2105376
         C[4]_14         =   2105376
         Orientation_14  =   2067
         format_14       =   15
         ClassName_15    =   "CCWFormat"
         Scale_14        =   16
         ClassName_16    =   "CCWScale"
         opts_16         =   122880
         rMin_16         =   12
         rMax_16         =   92
         dMax_16         =   10
         discInterval_16 =   1
         Radial_14       =   0
         Enum_14         =   17
         ClassName_17    =   "CCWEnum"
         Editor_17       =   18
         ClassName_18    =   "CCWEnumArrayEditor"
         Owner_18        =   14
         Font_14         =   19
         ClassName_19    =   "CCWFont"
         bFont_19        =   -1  'True
         BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_14     =   2807
         major_14        =   5
         minor_14        =   2.5
         Caption_14      =   20
         ClassName_20    =   "CCWDrawObj"
         opts_20         =   62
         C[0]_20         =   -2147483640
         Image_20        =   21
         ClassName_21    =   "CCWTextImage"
         font_21         =   0
         Animator_20     =   0
         Blinker_20      =   0
         PointStyle_5    =   21
         LineStyle_5     =   1
         LineWidth_5     =   1
         BasePlot_5      =   0
         DefaultXInc_5   =   1
         DefaultPlotPerRow_5=   -1  'True
         Axes_1          =   22
         ClassName_22    =   "CCWAxes"
         Array_22        =   2
         Editor_22       =   23
         ClassName_23    =   "CCWGFAxisArrayEditor"
         Owner_23        =   1
         Array[0]_22     =   6
         Array[1]_22     =   14
         DefaultPlot_1   =   24
         ClassName_24    =   "CCWDataPlot"
         opts_24         =   4194367
         Name_24         =   "[Template]"
         C[0]_24         =   65280
         C[1]_24         =   255
         C[2]_24         =   16711680
         C[3]_24         =   16776960
         Event_24        =   2
         X_24            =   6
         Y_24            =   14
         LineStyle_24    =   1
         LineWidth_24    =   1
         BasePlot_24     =   0
         DefaultXInc_24  =   1
         DefaultPlotPerRow_24=   -1  'True
         Cursors_1       =   25
         ClassName_25    =   "CCWCursors"
         Editor_25       =   26
         ClassName_26    =   "CCWGFCursorArrayEditor"
         Owner_26        =   1
         TrackMode_1     =   2
         GraphFrameStyle_1=   1
         GraphBackground_1=   0
         GraphFrame_1    =   27
         ClassName_27    =   "CCWDrawObj"
         opts_27         =   62
         C[0]_27         =   14737632
         C[1]_27         =   14737632
         Image_27        =   28
         ClassName_28    =   "CCWPictImage"
         opts_28         =   1280
         Rows_28         =   1
         Cols_28         =   1
         Pict_28         =   450
         F_28            =   14737632
         B_28            =   14737632
         ColorReplaceWith_28=   8421504
         ColorReplace_28 =   8421504
         Tolerance_28    =   2
         Animator_27     =   0
         Blinker_27      =   0
         PlotFrame_1     =   29
         ClassName_29    =   "CCWDrawObj"
         opts_29         =   62
         C[0]_29         =   14737632
         C[1]_29         =   0
         Image_29        =   30
         ClassName_30    =   "CCWPictImage"
         opts_30         =   1280
         Rows_30         =   1
         Cols_30         =   1
         Pict_30         =   1
         F_30            =   14737632
         B_30            =   0
         ColorReplaceWith_30=   8421504
         ColorReplace_30 =   8421504
         Tolerance_30    =   2
         Animator_29     =   0
         Blinker_29      =   0
         Caption_1       =   31
         ClassName_31    =   "CCWDrawObj"
         opts_31         =   62
         C[0]_31         =   -2147483640
         Image_31        =   32
         ClassName_32    =   "CCWTextImage"
         font_32         =   0
         Animator_31     =   0
         Blinker_31      =   0
         DefaultXInc_1   =   1
         DefaultPlotPerRow_1=   -1  'True
         Bindings_1      =   33
         ClassName_33    =   "CCWBindingHolderArray"
         Editor_33       =   34
         ClassName_34    =   "CCWBindingHolderArrayEditor"
         Owner_34        =   1
         Annotations_1   =   35
         ClassName_35    =   "CCWAnnotations"
         Editor_35       =   36
         ClassName_36    =   "CCWAnnotationArrayEditor"
         Owner_36        =   1
         AnnotationTemplate_1=   37
         ClassName_37    =   "CCWAnnotation"
         opts_37         =   63
         Name_37         =   "[Template]"
         Plot_37         =   24
         Text_37         =   "[Template]"
         TextXPoint_37   =   6.7
         TextYPoint_37   =   6.7
         TextColor_37    =   16777215
         TextFont_37     =   38
         ClassName_38    =   "CCWFont"
         bFont_38        =   -1  'True
         BeginProperty Font_38 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ShapeXPoints_37 =   39
         ClassName_39    =   "CDataBuffer"
         Type_39         =   5
         m_cDims;_39     =   1
         m_cElts_39      =   1
         Element[0]_39   =   3.3
         ShapeYPoints_37 =   40
         ClassName_40    =   "CDataBuffer"
         Type_40         =   5
         m_cDims;_40     =   1
         m_cElts_40      =   1
         Element[0]_40   =   3.3
         ShapeFillColor_37=   16777215
         ShapeLineColor_37=   16777215
         ShapeLineWidth_37=   1
         ShapeLineStyle_37=   1
         ShapePointStyle_37=   10
         ShapeImage_37   =   41
         ClassName_41    =   "CCWDrawObj"
         opts_41         =   62
         Image_41        =   42
         ClassName_42    =   "CCWPictImage"
         opts_42         =   1280
         Rows_42         =   1
         Cols_42         =   1
         Pict_42         =   7
         F_42            =   -2147483633
         B_42            =   -2147483633
         ColorReplaceWith_42=   8421504
         ColorReplace_42 =   8421504
         Tolerance_42    =   2
         Animator_41     =   0
         Blinker_41      =   0
         ArrowVisible_37 =   -1  'True
         ArrowColor_37   =   16777215
         ArrowWidth_37   =   1
         ArrowLineStyle_37=   1
         ArrowHeadStyle_37=   1
      End
      Begin CWUIControlsLib.CWGraph cwGrf 
         Height          =   1572
         Index           =   2
         Left            =   96
         TabIndex        =   40
         Top             =   2760
         Width           =   3792
         _Version        =   524288
         _ExtentX        =   6694
         _ExtentY        =   2778
         _StockProps     =   71
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Reset_0         =   0   'False
         CompatibleVers_0=   524288
         Graph_0         =   1
         ClassName_1     =   "CCWGraphFrame"
         opts_1          =   62
         C[0]_1          =   0
         C[1]_1          =   14737632
         Event_1         =   2
         ClassName_2     =   "CCWGFPlotEvent"
         Owner_2         =   1
         Plots_1         =   3
         ClassName_3     =   "CCWDataPlots"
         Array_3         =   1
         Editor_3        =   4
         ClassName_4     =   "CCWGFPlotArrayEditor"
         Owner_4         =   1
         Array[0]_3      =   5
         ClassName_5     =   "CCWDataPlot"
         opts_5          =   4194367
         Name_5          =   "Plot-1"
         C[0]_5          =   65280
         C[1]_5          =   65535
         C[2]_5          =   16711680
         C[3]_5          =   16776960
         Event_5         =   2
         X_5             =   6
         ClassName_6     =   "CCWAxis"
         opts_6          =   1599
         Name_6          =   "XAxis"
         C[3]_6          =   2105376
         C[4]_6          =   2105376
         Orientation_6   =   2560
         format_6        =   7
         ClassName_7     =   "CCWFormat"
         Scale_6         =   8
         ClassName_8     =   "CCWScale"
         opts_8          =   90112
         rMin_8          =   38
         rMax_8          =   235
         dMax_8          =   10
         discInterval_8  =   1
         Radial_6        =   0
         Enum_6          =   9
         ClassName_9     =   "CCWEnum"
         Editor_9        =   10
         ClassName_10    =   "CCWEnumArrayEditor"
         Owner_10        =   6
         Font_6          =   11
         ClassName_11    =   "CCWFont"
         bFont_11        =   -1  'True
         BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Small Fonts"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_6      =   2807
         major_6         =   2
         minor_6         =   1
         Caption_6       =   12
         ClassName_12    =   "CCWDrawObj"
         opts_12         =   62
         C[0]_12         =   -2147483640
         Image_12        =   13
         ClassName_13    =   "CCWTextImage"
         font_13         =   0
         Animator_12     =   0
         Blinker_12      =   0
         Y_5             =   14
         ClassName_14    =   "CCWAxis"
         opts_14         =   1599
         Name_14         =   "YAxis-1"
         C[3]_14         =   2105376
         C[4]_14         =   2105376
         Orientation_14  =   2067
         format_14       =   15
         ClassName_15    =   "CCWFormat"
         Scale_14        =   16
         ClassName_16    =   "CCWScale"
         opts_16         =   122880
         rMin_16         =   12
         rMax_16         =   92
         dMax_16         =   10
         discInterval_16 =   1
         Radial_14       =   0
         Enum_14         =   17
         ClassName_17    =   "CCWEnum"
         Editor_17       =   18
         ClassName_18    =   "CCWEnumArrayEditor"
         Owner_18        =   14
         Font_14         =   19
         ClassName_19    =   "CCWFont"
         bFont_19        =   -1  'True
         BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_14     =   2807
         major_14        =   5
         minor_14        =   2.5
         Caption_14      =   20
         ClassName_20    =   "CCWDrawObj"
         opts_20         =   62
         C[0]_20         =   -2147483640
         Image_20        =   21
         ClassName_21    =   "CCWTextImage"
         font_21         =   0
         Animator_20     =   0
         Blinker_20      =   0
         PointStyle_5    =   21
         LineStyle_5     =   1
         LineWidth_5     =   1
         BasePlot_5      =   0
         DefaultXInc_5   =   1
         DefaultPlotPerRow_5=   -1  'True
         Axes_1          =   22
         ClassName_22    =   "CCWAxes"
         Array_22        =   2
         Editor_22       =   23
         ClassName_23    =   "CCWGFAxisArrayEditor"
         Owner_23        =   1
         Array[0]_22     =   6
         Array[1]_22     =   14
         DefaultPlot_1   =   24
         ClassName_24    =   "CCWDataPlot"
         opts_24         =   4194367
         Name_24         =   "[Template]"
         C[0]_24         =   65280
         C[1]_24         =   255
         C[2]_24         =   16711680
         C[3]_24         =   16776960
         Event_24        =   2
         X_24            =   6
         Y_24            =   14
         LineStyle_24    =   1
         LineWidth_24    =   1
         BasePlot_24     =   0
         DefaultXInc_24  =   1
         DefaultPlotPerRow_24=   -1  'True
         Cursors_1       =   25
         ClassName_25    =   "CCWCursors"
         Editor_25       =   26
         ClassName_26    =   "CCWGFCursorArrayEditor"
         Owner_26        =   1
         TrackMode_1     =   2
         GraphFrameStyle_1=   1
         GraphBackground_1=   0
         GraphFrame_1    =   27
         ClassName_27    =   "CCWDrawObj"
         opts_27         =   62
         C[0]_27         =   14737632
         C[1]_27         =   14737632
         Image_27        =   28
         ClassName_28    =   "CCWPictImage"
         opts_28         =   1280
         Rows_28         =   1
         Cols_28         =   1
         Pict_28         =   450
         F_28            =   14737632
         B_28            =   14737632
         ColorReplaceWith_28=   8421504
         ColorReplace_28 =   8421504
         Tolerance_28    =   2
         Animator_27     =   0
         Blinker_27      =   0
         PlotFrame_1     =   29
         ClassName_29    =   "CCWDrawObj"
         opts_29         =   62
         C[0]_29         =   14737632
         C[1]_29         =   0
         Image_29        =   30
         ClassName_30    =   "CCWPictImage"
         opts_30         =   1280
         Rows_30         =   1
         Cols_30         =   1
         Pict_30         =   1
         F_30            =   14737632
         B_30            =   0
         ColorReplaceWith_30=   8421504
         ColorReplace_30 =   8421504
         Tolerance_30    =   2
         Animator_29     =   0
         Blinker_29      =   0
         Caption_1       =   31
         ClassName_31    =   "CCWDrawObj"
         opts_31         =   62
         C[0]_31         =   -2147483640
         Image_31        =   32
         ClassName_32    =   "CCWTextImage"
         font_32         =   0
         Animator_31     =   0
         Blinker_31      =   0
         DefaultXInc_1   =   1
         DefaultPlotPerRow_1=   -1  'True
         Bindings_1      =   33
         ClassName_33    =   "CCWBindingHolderArray"
         Editor_33       =   34
         ClassName_34    =   "CCWBindingHolderArrayEditor"
         Owner_34        =   1
         Annotations_1   =   35
         ClassName_35    =   "CCWAnnotations"
         Editor_35       =   36
         ClassName_36    =   "CCWAnnotationArrayEditor"
         Owner_36        =   1
         AnnotationTemplate_1=   37
         ClassName_37    =   "CCWAnnotation"
         opts_37         =   63
         Name_37         =   "[Template]"
         Plot_37         =   24
         Text_37         =   "[Template]"
         TextXPoint_37   =   6.7
         TextYPoint_37   =   6.7
         TextColor_37    =   16777215
         TextFont_37     =   38
         ClassName_38    =   "CCWFont"
         bFont_38        =   -1  'True
         BeginProperty Font_38 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ShapeXPoints_37 =   39
         ClassName_39    =   "CDataBuffer"
         Type_39         =   5
         m_cDims;_39     =   1
         m_cElts_39      =   1
         Element[0]_39   =   3.3
         ShapeYPoints_37 =   40
         ClassName_40    =   "CDataBuffer"
         Type_40         =   5
         m_cDims;_40     =   1
         m_cElts_40      =   1
         Element[0]_40   =   3.3
         ShapeFillColor_37=   16777215
         ShapeLineColor_37=   16777215
         ShapeLineWidth_37=   1
         ShapeLineStyle_37=   1
         ShapePointStyle_37=   10
         ShapeImage_37   =   41
         ClassName_41    =   "CCWDrawObj"
         opts_41         =   62
         Image_41        =   42
         ClassName_42    =   "CCWPictImage"
         opts_42         =   1280
         Rows_42         =   1
         Cols_42         =   1
         Pict_42         =   7
         F_42            =   -2147483633
         B_42            =   -2147483633
         ColorReplaceWith_42=   8421504
         ColorReplace_42 =   8421504
         Tolerance_42    =   2
         Animator_41     =   0
         Blinker_41      =   0
         ArrowVisible_37 =   -1  'True
         ArrowColor_37   =   16777215
         ArrowWidth_37   =   1
         ArrowLineStyle_37=   1
         ArrowHeadStyle_37=   1
      End
      Begin CWUIControlsLib.CWGraph cwGrf 
         Height          =   1572
         Index           =   3
         Left            =   3960
         TabIndex        =   41
         Top             =   2760
         Width           =   3792
         _Version        =   524288
         _ExtentX        =   6694
         _ExtentY        =   2778
         _StockProps     =   71
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Reset_0         =   0   'False
         CompatibleVers_0=   524288
         Graph_0         =   1
         ClassName_1     =   "CCWGraphFrame"
         opts_1          =   62
         C[0]_1          =   0
         C[1]_1          =   14737632
         Event_1         =   2
         ClassName_2     =   "CCWGFPlotEvent"
         Owner_2         =   1
         Plots_1         =   3
         ClassName_3     =   "CCWDataPlots"
         Array_3         =   1
         Editor_3        =   4
         ClassName_4     =   "CCWGFPlotArrayEditor"
         Owner_4         =   1
         Array[0]_3      =   5
         ClassName_5     =   "CCWDataPlot"
         opts_5          =   4194367
         Name_5          =   "Plot-1"
         C[0]_5          =   65280
         C[1]_5          =   65535
         C[2]_5          =   16711680
         C[3]_5          =   16776960
         Event_5         =   2
         X_5             =   6
         ClassName_6     =   "CCWAxis"
         opts_6          =   1599
         Name_6          =   "XAxis"
         C[3]_6          =   2105376
         C[4]_6          =   2105376
         Orientation_6   =   2560
         format_6        =   7
         ClassName_7     =   "CCWFormat"
         Scale_6         =   8
         ClassName_8     =   "CCWScale"
         opts_8          =   90112
         rMin_8          =   38
         rMax_8          =   235
         dMax_8          =   10
         discInterval_8  =   1
         Radial_6        =   0
         Enum_6          =   9
         ClassName_9     =   "CCWEnum"
         Editor_9        =   10
         ClassName_10    =   "CCWEnumArrayEditor"
         Owner_10        =   6
         Font_6          =   11
         ClassName_11    =   "CCWFont"
         bFont_11        =   -1  'True
         BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "Small Fonts"
            Size            =   6
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_6      =   2807
         major_6         =   2
         minor_6         =   1
         Caption_6       =   12
         ClassName_12    =   "CCWDrawObj"
         opts_12         =   62
         C[0]_12         =   -2147483640
         Image_12        =   13
         ClassName_13    =   "CCWTextImage"
         font_13         =   0
         Animator_12     =   0
         Blinker_12      =   0
         Y_5             =   14
         ClassName_14    =   "CCWAxis"
         opts_14         =   1599
         Name_14         =   "YAxis-1"
         C[3]_14         =   2105376
         C[4]_14         =   2105376
         Orientation_14  =   2067
         format_14       =   15
         ClassName_15    =   "CCWFormat"
         Scale_14        =   16
         ClassName_16    =   "CCWScale"
         opts_16         =   122880
         rMin_16         =   12
         rMax_16         =   92
         dMax_16         =   10
         discInterval_16 =   1
         Radial_14       =   0
         Enum_14         =   17
         ClassName_17    =   "CCWEnum"
         Editor_17       =   18
         ClassName_18    =   "CCWEnumArrayEditor"
         Owner_18        =   14
         Font_14         =   19
         ClassName_19    =   "CCWFont"
         bFont_19        =   -1  'True
         BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         tickopts_14     =   2807
         major_14        =   5
         minor_14        =   2.5
         Caption_14      =   20
         ClassName_20    =   "CCWDrawObj"
         opts_20         =   62
         C[0]_20         =   -2147483640
         Image_20        =   21
         ClassName_21    =   "CCWTextImage"
         font_21         =   0
         Animator_20     =   0
         Blinker_20      =   0
         PointStyle_5    =   21
         LineStyle_5     =   1
         LineWidth_5     =   1
         BasePlot_5      =   0
         DefaultXInc_5   =   1
         DefaultPlotPerRow_5=   -1  'True
         Axes_1          =   22
         ClassName_22    =   "CCWAxes"
         Array_22        =   2
         Editor_22       =   23
         ClassName_23    =   "CCWGFAxisArrayEditor"
         Owner_23        =   1
         Array[0]_22     =   6
         Array[1]_22     =   14
         DefaultPlot_1   =   24
         ClassName_24    =   "CCWDataPlot"
         opts_24         =   4194367
         Name_24         =   "[Template]"
         C[0]_24         =   65280
         C[1]_24         =   255
         C[2]_24         =   16711680
         C[3]_24         =   16776960
         Event_24        =   2
         X_24            =   6
         Y_24            =   14
         LineStyle_24    =   1
         LineWidth_24    =   1
         BasePlot_24     =   0
         DefaultXInc_24  =   1
         DefaultPlotPerRow_24=   -1  'True
         Cursors_1       =   25
         ClassName_25    =   "CCWCursors"
         Editor_25       =   26
         ClassName_26    =   "CCWGFCursorArrayEditor"
         Owner_26        =   1
         TrackMode_1     =   2
         GraphFrameStyle_1=   1
         GraphBackground_1=   0
         GraphFrame_1    =   27
         ClassName_27    =   "CCWDrawObj"
         opts_27         =   62
         C[0]_27         =   14737632
         C[1]_27         =   14737632
         Image_27        =   28
         ClassName_28    =   "CCWPictImage"
         opts_28         =   1280
         Rows_28         =   1
         Cols_28         =   1
         Pict_28         =   450
         F_28            =   14737632
         B_28            =   14737632
         ColorReplaceWith_28=   8421504
         ColorReplace_28 =   8421504
         Tolerance_28    =   2
         Animator_27     =   0
         Blinker_27      =   0
         PlotFrame_1     =   29
         ClassName_29    =   "CCWDrawObj"
         opts_29         =   62
         C[0]_29         =   14737632
         C[1]_29         =   0
         Image_29        =   30
         ClassName_30    =   "CCWPictImage"
         opts_30         =   1280
         Rows_30         =   1
         Cols_30         =   1
         Pict_30         =   1
         F_30            =   14737632
         B_30            =   0
         ColorReplaceWith_30=   8421504
         ColorReplace_30 =   8421504
         Tolerance_30    =   2
         Animator_29     =   0
         Blinker_29      =   0
         Caption_1       =   31
         ClassName_31    =   "CCWDrawObj"
         opts_31         =   62
         C[0]_31         =   -2147483640
         Image_31        =   32
         ClassName_32    =   "CCWTextImage"
         font_32         =   0
         Animator_31     =   0
         Blinker_31      =   0
         DefaultXInc_1   =   1
         DefaultPlotPerRow_1=   -1  'True
         Bindings_1      =   33
         ClassName_33    =   "CCWBindingHolderArray"
         Editor_33       =   34
         ClassName_34    =   "CCWBindingHolderArrayEditor"
         Owner_34        =   1
         Annotations_1   =   35
         ClassName_35    =   "CCWAnnotations"
         Editor_35       =   36
         ClassName_36    =   "CCWAnnotationArrayEditor"
         Owner_36        =   1
         AnnotationTemplate_1=   37
         ClassName_37    =   "CCWAnnotation"
         opts_37         =   63
         Name_37         =   "[Template]"
         Plot_37         =   24
         Text_37         =   "[Template]"
         TextXPoint_37   =   6.7
         TextYPoint_37   =   6.7
         TextColor_37    =   16777215
         TextFont_37     =   38
         ClassName_38    =   "CCWFont"
         bFont_38        =   -1  'True
         BeginProperty Font_38 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ShapeXPoints_37 =   39
         ClassName_39    =   "CDataBuffer"
         Type_39         =   5
         m_cDims;_39     =   1
         m_cElts_39      =   1
         Element[0]_39   =   3.3
         ShapeYPoints_37 =   40
         ClassName_40    =   "CDataBuffer"
         Type_40         =   5
         m_cDims;_40     =   1
         m_cElts_40      =   1
         Element[0]_40   =   3.3
         ShapeFillColor_37=   16777215
         ShapeLineColor_37=   16777215
         ShapeLineWidth_37=   1
         ShapeLineStyle_37=   1
         ShapePointStyle_37=   10
         ShapeImage_37   =   41
         ClassName_41    =   "CCWDrawObj"
         opts_41         =   62
         Image_41        =   42
         ClassName_42    =   "CCWPictImage"
         opts_42         =   1280
         Rows_42         =   1
         Cols_42         =   1
         Pict_42         =   7
         F_42            =   -2147483633
         B_42            =   -2147483633
         ColorReplaceWith_42=   8421504
         ColorReplace_42 =   8421504
         Tolerance_42    =   2
         Animator_41     =   0
         Blinker_41      =   0
         ArrowVisible_37 =   -1  'True
         ArrowColor_37   =   16777215
         ArrowWidth_37   =   1
         ArrowLineStyle_37=   1
         ArrowHeadStyle_37=   1
      End
      Begin VB.CheckBox chkGrfZoom 
         BackColor       =   &H00E0E0E0&
         Caption         =   "+"
         Height          =   252
         Left            =   1260
         Style           =   1  'Graphical
         TabIndex        =   60
         Top             =   360
         Width           =   252
      End
   End
   Begin VB.Frame frDAC 
      Caption         =   "DAC's"
      ForeColor       =   &H00FF0000&
      Height          =   4452
      Left            =   120
      TabIndex        =   5
      Top             =   1320
      Width           =   4152
      Begin VB.Frame frDACAuto 
         Caption         =   "Automatic"
         ForeColor       =   &H00FF0000&
         Height          =   2472
         Left            =   60
         TabIndex        =   16
         Top             =   1860
         Width           =   4032
         Begin VB.OptionButton opWaveForm 
            BackColor       =   &H00FFE3FF&
            Caption         =   "Senoidal"
            Height          =   312
            Index           =   3
            Left            =   2940
            Style           =   1  'Graphical
            TabIndex        =   46
            Top             =   300
            Width           =   912
         End
         Begin VB.HScrollBar hsScanDelay 
            Height          =   252
            LargeChange     =   10
            Left            =   1080
            Max             =   1000
            TabIndex        =   34
            Top             =   2076
            Value           =   100
            Width           =   2715
         End
         Begin VB.HScrollBar hsDACAmplitud 
            Height          =   252
            LargeChange     =   100
            Left            =   1080
            Max             =   9500
            Min             =   100
            SmallChange     =   10
            TabIndex        =   21
            Top             =   996
            Value           =   5000
            Width           =   2715
         End
         Begin VB.HScrollBar hsDACResolucion 
            Height          =   252
            LargeChange     =   10
            Left            =   1080
            Max             =   100
            Min             =   1
            TabIndex        =   20
            Top             =   1536
            Value           =   50
            Width           =   2715
         End
         Begin VB.OptionButton opWaveForm 
            BackColor       =   &H00FFE3FF&
            Caption         =   "Triangular"
            Height          =   312
            Index           =   0
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   19
            Top             =   300
            Value           =   -1  'True
            Width           =   852
         End
         Begin VB.OptionButton opWaveForm 
            BackColor       =   &H00FFE3FF&
            Caption         =   "Cuadrada"
            Height          =   312
            Index           =   1
            Left            =   960
            Style           =   1  'Graphical
            TabIndex        =   18
            Top             =   300
            Width           =   912
         End
         Begin VB.OptionButton opWaveForm 
            BackColor       =   &H00FFE3FF&
            Caption         =   "Diente Sierra"
            Height          =   312
            Index           =   2
            Left            =   1860
            Style           =   1  'Graphical
            TabIndex        =   17
            Top             =   300
            Width           =   1080
         End
         Begin VB.Label Label17 
            Caption         =   "Velocidad"
            Height          =   252
            Left            =   120
            TabIndex        =   38
            Top             =   2076
            Width           =   852
         End
         Begin VB.Label Label16 
            Caption         =   "Máx"
            Height          =   192
            Left            =   3480
            TabIndex        =   37
            Top             =   1896
            Width           =   372
         End
         Begin VB.Label Label15 
            Caption         =   "Mín"
            Height          =   192
            Left            =   1080
            TabIndex        =   36
            Top             =   1896
            Width           =   732
         End
         Begin VB.Label lblScanDelay 
            Alignment       =   2  'Center
            Caption         =   "100"
            Height          =   192
            Left            =   2100
            TabIndex        =   35
            Top             =   1860
            Width           =   672
         End
         Begin VB.Label Label8 
            Caption         =   "+9.5V"
            Height          =   192
            Left            =   3360
            TabIndex        =   29
            Top             =   816
            Width           =   468
         End
         Begin VB.Label Label9 
            Caption         =   "0.1V"
            Height          =   192
            Left            =   1080
            TabIndex        =   28
            Top             =   816
            Width           =   372
         End
         Begin VB.Label lblDACAmpli 
            Alignment       =   2  'Center
            Caption         =   "5.000 V"
            Height          =   192
            Left            =   2160
            TabIndex        =   27
            Top             =   780
            Width           =   672
         End
         Begin VB.Label Label11 
            Caption         =   "Amplitud"
            Height          =   192
            Left            =   120
            TabIndex        =   26
            Top             =   996
            Width           =   672
         End
         Begin VB.Label Label12 
            Caption         =   "Resolución"
            Height          =   252
            Left            =   120
            TabIndex        =   25
            Top             =   1536
            Width           =   852
         End
         Begin VB.Label Label13 
            Caption         =   "100mV"
            Height          =   192
            Left            =   3300
            TabIndex        =   24
            Top             =   1356
            Width           =   492
         End
         Begin VB.Label Label14 
            Caption         =   "1mV"
            Height          =   192
            Left            =   1080
            TabIndex        =   23
            Top             =   1356
            Width           =   372
         End
         Begin VB.Label lblDACResol 
            Alignment       =   2  'Center
            Caption         =   "50 mV"
            Height          =   192
            Left            =   2160
            TabIndex        =   22
            Top             =   1320
            Width           =   672
         End
      End
      Begin VB.Frame frDACManual 
         Caption         =   "Manual"
         ForeColor       =   &H00FF0000&
         Height          =   1032
         Left            =   60
         TabIndex        =   10
         Top             =   720
         Width           =   4032
         Begin VB.CheckBox Check10 
            Caption         =   "Check10"
            Height          =   195
            Left            =   720
            TabIndex        =   86
            Top             =   840
            Width           =   495
         End
         Begin VB.CommandButton cmdReSend 
            Caption         =   "Reeenviar"
            Height          =   255
            Left            =   2760
            TabIndex        =   62
            Top             =   720
            Width           =   855
         End
         Begin VB.HScrollBar hsDACVolt 
            Height          =   252
            LargeChange     =   100
            Left            =   480
            Max             =   9999
            Min             =   -10000
            SmallChange     =   10
            TabIndex        =   11
            Top             =   420
            Width           =   3012
         End
         Begin VB.Label lblMaxDACVolt 
            Caption         =   "+10V"
            Height          =   192
            Left            =   3540
            TabIndex        =   15
            Top             =   480
            Width           =   372
         End
         Begin VB.Label lblMinDACVolt 
            Caption         =   "-10V"
            Height          =   192
            Left            =   120
            TabIndex        =   14
            Top             =   480
            Width           =   372
         End
         Begin VB.Label lblDACCode 
            Alignment       =   2  'Center
            Caption         =   "0 Hex"
            Height          =   192
            Left            =   1620
            TabIndex        =   13
            Top             =   720
            Width           =   852
         End
         Begin VB.Label lblDACVoltage 
            Alignment       =   2  'Center
            Caption         =   "0.000 V"
            Height          =   192
            Left            =   1680
            TabIndex        =   12
            Top             =   180
            Width           =   672
         End
      End
      Begin VB.OptionButton opDAC 
         BackColor       =   &H00FFE3FF&
         Caption         =   "Axis X"
         Height          =   312
         Index           =   0
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   9
         Top             =   300
         Value           =   -1  'True
         Width           =   852
      End
      Begin VB.OptionButton opDAC 
         BackColor       =   &H00FFE3FF&
         Caption         =   "Axis Y"
         Height          =   312
         Index           =   1
         Left            =   1140
         Style           =   1  'Graphical
         TabIndex        =   8
         Top             =   300
         Width           =   852
      End
      Begin VB.OptionButton opDAC 
         BackColor       =   &H00FFE3FF&
         Caption         =   "Axis Z"
         Height          =   312
         Index           =   2
         Left            =   2160
         Style           =   1  'Graphical
         TabIndex        =   7
         Top             =   300
         Width           =   852
      End
      Begin VB.OptionButton opDAC 
         BackColor       =   &H00FFE3FF&
         Caption         =   "Bias"
         Height          =   312
         Index           =   3
         Left            =   3180
         Style           =   1  'Graphical
         TabIndex        =   6
         Top             =   300
         Width           =   852
      End
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "&Exit"
      Height          =   312
      Left            =   10920
      TabIndex        =   4
      Top             =   540
      Width           =   1212
   End
   Begin VB.Frame frDevices 
      Caption         =   "Devices"
      ForeColor       =   &H00FF0000&
      Height          =   1188
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   4152
      Begin VB.CommandButton cmdRefresh 
         BackColor       =   &H00E0E0E0&
         Caption         =   "&Refresh"
         Height          =   312
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   3
         Top             =   720
         Width           =   1128
      End
      Begin VB.CommandButton cmdOpen 
         BackColor       =   &H00E0E0E0&
         Caption         =   "&Open"
         Height          =   312
         Left            =   120
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   240
         Width           =   1128
      End
      Begin VB.ListBox lstDevices 
         Height          =   645
         Left            =   1356
         TabIndex        =   1
         Top             =   240
         Width           =   2652
      End
   End
   Begin CWUIControlsLib.CWGraph cwGrf 
      Height          =   1575
      Index           =   4
      Left            =   4440
      TabIndex        =   71
      Top             =   7560
      Width           =   3795
      _Version        =   524288
      _ExtentX        =   6694
      _ExtentY        =   2778
      _StockProps     =   71
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Reset_0         =   0   'False
      CompatibleVers_0=   524288
      Graph_0         =   1
      ClassName_1     =   "CCWGraphFrame"
      opts_1          =   62
      C[0]_1          =   0
      C[1]_1          =   14737632
      Event_1         =   2
      ClassName_2     =   "CCWGFPlotEvent"
      Owner_2         =   1
      Plots_1         =   3
      ClassName_3     =   "CCWDataPlots"
      Array_3         =   1
      Editor_3        =   4
      ClassName_4     =   "CCWGFPlotArrayEditor"
      Owner_4         =   1
      Array[0]_3      =   5
      ClassName_5     =   "CCWDataPlot"
      opts_5          =   4194367
      Name_5          =   "Plot-1"
      C[0]_5          =   65280
      C[1]_5          =   65535
      C[2]_5          =   16711680
      C[3]_5          =   16776960
      Event_5         =   2
      X_5             =   6
      ClassName_6     =   "CCWAxis"
      opts_6          =   1599
      Name_6          =   "XAxis"
      C[3]_6          =   2105376
      C[4]_6          =   2105376
      Orientation_6   =   2560
      format_6        =   7
      ClassName_7     =   "CCWFormat"
      Scale_6         =   8
      ClassName_8     =   "CCWScale"
      opts_8          =   90112
      rMin_8          =   38
      rMax_8          =   235
      dMax_8          =   10
      discInterval_8  =   1
      Radial_6        =   0
      Enum_6          =   9
      ClassName_9     =   "CCWEnum"
      Editor_9        =   10
      ClassName_10    =   "CCWEnumArrayEditor"
      Owner_10        =   6
      Font_6          =   11
      ClassName_11    =   "CCWFont"
      bFont_11        =   -1  'True
      BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      tickopts_6      =   2807
      major_6         =   2
      minor_6         =   1
      Caption_6       =   12
      ClassName_12    =   "CCWDrawObj"
      opts_12         =   62
      C[0]_12         =   -2147483640
      Image_12        =   13
      ClassName_13    =   "CCWTextImage"
      font_13         =   0
      Animator_12     =   0
      Blinker_12      =   0
      Y_5             =   14
      ClassName_14    =   "CCWAxis"
      opts_14         =   1599
      Name_14         =   "YAxis-1"
      C[3]_14         =   2105376
      C[4]_14         =   2105376
      Orientation_14  =   2067
      format_14       =   15
      ClassName_15    =   "CCWFormat"
      Scale_14        =   16
      ClassName_16    =   "CCWScale"
      opts_16         =   122880
      rMin_16         =   12
      rMax_16         =   92
      dMax_16         =   10
      discInterval_16 =   1
      Radial_14       =   0
      Enum_14         =   17
      ClassName_17    =   "CCWEnum"
      Editor_17       =   18
      ClassName_18    =   "CCWEnumArrayEditor"
      Owner_18        =   14
      Font_14         =   19
      ClassName_19    =   "CCWFont"
      bFont_19        =   -1  'True
      BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      tickopts_14     =   2807
      major_14        =   5
      minor_14        =   2.5
      Caption_14      =   20
      ClassName_20    =   "CCWDrawObj"
      opts_20         =   62
      C[0]_20         =   -2147483640
      Image_20        =   21
      ClassName_21    =   "CCWTextImage"
      font_21         =   0
      Animator_20     =   0
      Blinker_20      =   0
      PointStyle_5    =   21
      LineStyle_5     =   1
      LineWidth_5     =   1
      BasePlot_5      =   0
      DefaultXInc_5   =   1
      DefaultPlotPerRow_5=   -1  'True
      Axes_1          =   22
      ClassName_22    =   "CCWAxes"
      Array_22        =   2
      Editor_22       =   23
      ClassName_23    =   "CCWGFAxisArrayEditor"
      Owner_23        =   1
      Array[0]_22     =   6
      Array[1]_22     =   14
      DefaultPlot_1   =   24
      ClassName_24    =   "CCWDataPlot"
      opts_24         =   4194367
      Name_24         =   "[Template]"
      C[0]_24         =   65280
      C[1]_24         =   255
      C[2]_24         =   16711680
      C[3]_24         =   16776960
      Event_24        =   2
      X_24            =   6
      Y_24            =   14
      LineStyle_24    =   1
      LineWidth_24    =   1
      BasePlot_24     =   0
      DefaultXInc_24  =   1
      DefaultPlotPerRow_24=   -1  'True
      Cursors_1       =   25
      ClassName_25    =   "CCWCursors"
      Editor_25       =   26
      ClassName_26    =   "CCWGFCursorArrayEditor"
      Owner_26        =   1
      TrackMode_1     =   2
      GraphFrameStyle_1=   1
      GraphBackground_1=   0
      GraphFrame_1    =   27
      ClassName_27    =   "CCWDrawObj"
      opts_27         =   62
      C[0]_27         =   14737632
      C[1]_27         =   14737632
      Image_27        =   28
      ClassName_28    =   "CCWPictImage"
      opts_28         =   1280
      Rows_28         =   1
      Cols_28         =   1
      Pict_28         =   450
      F_28            =   14737632
      B_28            =   14737632
      ColorReplaceWith_28=   8421504
      ColorReplace_28 =   8421504
      Tolerance_28    =   2
      Animator_27     =   0
      Blinker_27      =   0
      PlotFrame_1     =   29
      ClassName_29    =   "CCWDrawObj"
      opts_29         =   62
      C[0]_29         =   14737632
      C[1]_29         =   0
      Image_29        =   30
      ClassName_30    =   "CCWPictImage"
      opts_30         =   1280
      Rows_30         =   1
      Cols_30         =   1
      Pict_30         =   1
      F_30            =   14737632
      B_30            =   0
      ColorReplaceWith_30=   8421504
      ColorReplace_30 =   8421504
      Tolerance_30    =   2
      Animator_29     =   0
      Blinker_29      =   0
      Caption_1       =   31
      ClassName_31    =   "CCWDrawObj"
      opts_31         =   62
      C[0]_31         =   -2147483640
      Image_31        =   32
      ClassName_32    =   "CCWTextImage"
      font_32         =   0
      Animator_31     =   0
      Blinker_31      =   0
      DefaultXInc_1   =   1
      DefaultPlotPerRow_1=   -1  'True
      Bindings_1      =   33
      ClassName_33    =   "CCWBindingHolderArray"
      Editor_33       =   34
      ClassName_34    =   "CCWBindingHolderArrayEditor"
      Owner_34        =   1
      Annotations_1   =   35
      ClassName_35    =   "CCWAnnotations"
      Editor_35       =   36
      ClassName_36    =   "CCWAnnotationArrayEditor"
      Owner_36        =   1
      AnnotationTemplate_1=   37
      ClassName_37    =   "CCWAnnotation"
      opts_37         =   63
      Name_37         =   "[Template]"
      Plot_37         =   24
      Text_37         =   "[Template]"
      TextXPoint_37   =   6.7
      TextYPoint_37   =   6.7
      TextColor_37    =   16777215
      TextFont_37     =   38
      ClassName_38    =   "CCWFont"
      bFont_38        =   -1  'True
      BeginProperty Font_38 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ShapeXPoints_37 =   39
      ClassName_39    =   "CDataBuffer"
      Type_39         =   5
      m_cDims;_39     =   1
      m_cElts_39      =   1
      Element[0]_39   =   3.3
      ShapeYPoints_37 =   40
      ClassName_40    =   "CDataBuffer"
      Type_40         =   5
      m_cDims;_40     =   1
      m_cElts_40      =   1
      Element[0]_40   =   3.3
      ShapeFillColor_37=   16777215
      ShapeLineColor_37=   16777215
      ShapeLineWidth_37=   1
      ShapeLineStyle_37=   1
      ShapePointStyle_37=   10
      ShapeImage_37   =   41
      ClassName_41    =   "CCWDrawObj"
      opts_41         =   62
      Image_41        =   42
      ClassName_42    =   "CCWPictImage"
      opts_42         =   1280
      Rows_42         =   1
      Cols_42         =   1
      Pict_42         =   7
      F_42            =   -2147483633
      B_42            =   -2147483633
      ColorReplaceWith_42=   8421504
      ColorReplace_42 =   8421504
      Tolerance_42    =   2
      Animator_41     =   0
      Blinker_41      =   0
      ArrowVisible_37 =   -1  'True
      ArrowColor_37   =   16777215
      ArrowWidth_37   =   1
      ArrowLineStyle_37=   1
      ArrowHeadStyle_37=   1
   End
   Begin CWUIControlsLib.CWGraph cwGrf 
      Height          =   1575
      Index           =   5
      Left            =   8400
      TabIndex        =   72
      Top             =   7560
      Width           =   3795
      _Version        =   524288
      _ExtentX        =   6694
      _ExtentY        =   2778
      _StockProps     =   71
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Reset_0         =   0   'False
      CompatibleVers_0=   524288
      Graph_0         =   1
      ClassName_1     =   "CCWGraphFrame"
      opts_1          =   62
      C[0]_1          =   0
      C[1]_1          =   14737632
      Event_1         =   2
      ClassName_2     =   "CCWGFPlotEvent"
      Owner_2         =   1
      Plots_1         =   3
      ClassName_3     =   "CCWDataPlots"
      Array_3         =   1
      Editor_3        =   4
      ClassName_4     =   "CCWGFPlotArrayEditor"
      Owner_4         =   1
      Array[0]_3      =   5
      ClassName_5     =   "CCWDataPlot"
      opts_5          =   4194367
      Name_5          =   "Plot-1"
      C[0]_5          =   65280
      C[1]_5          =   65535
      C[2]_5          =   16711680
      C[3]_5          =   16776960
      Event_5         =   2
      X_5             =   6
      ClassName_6     =   "CCWAxis"
      opts_6          =   1599
      Name_6          =   "XAxis"
      C[3]_6          =   2105376
      C[4]_6          =   2105376
      Orientation_6   =   2560
      format_6        =   7
      ClassName_7     =   "CCWFormat"
      Scale_6         =   8
      ClassName_8     =   "CCWScale"
      opts_8          =   90112
      rMin_8          =   38
      rMax_8          =   235
      dMax_8          =   10
      discInterval_8  =   1
      Radial_6        =   0
      Enum_6          =   9
      ClassName_9     =   "CCWEnum"
      Editor_9        =   10
      ClassName_10    =   "CCWEnumArrayEditor"
      Owner_10        =   6
      Font_6          =   11
      ClassName_11    =   "CCWFont"
      bFont_11        =   -1  'True
      BeginProperty Font_11 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Small Fonts"
         Size            =   6
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      tickopts_6      =   2807
      major_6         =   2
      minor_6         =   1
      Caption_6       =   12
      ClassName_12    =   "CCWDrawObj"
      opts_12         =   62
      C[0]_12         =   -2147483640
      Image_12        =   13
      ClassName_13    =   "CCWTextImage"
      font_13         =   0
      Animator_12     =   0
      Blinker_12      =   0
      Y_5             =   14
      ClassName_14    =   "CCWAxis"
      opts_14         =   1599
      Name_14         =   "YAxis-1"
      C[3]_14         =   2105376
      C[4]_14         =   2105376
      Orientation_14  =   2067
      format_14       =   15
      ClassName_15    =   "CCWFormat"
      Scale_14        =   16
      ClassName_16    =   "CCWScale"
      opts_16         =   122880
      rMin_16         =   12
      rMax_16         =   92
      dMax_16         =   10
      discInterval_16 =   1
      Radial_14       =   0
      Enum_14         =   17
      ClassName_17    =   "CCWEnum"
      Editor_17       =   18
      ClassName_18    =   "CCWEnumArrayEditor"
      Owner_18        =   14
      Font_14         =   19
      ClassName_19    =   "CCWFont"
      bFont_19        =   -1  'True
      BeginProperty Font_19 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      tickopts_14     =   2807
      major_14        =   5
      minor_14        =   2.5
      Caption_14      =   20
      ClassName_20    =   "CCWDrawObj"
      opts_20         =   62
      C[0]_20         =   -2147483640
      Image_20        =   21
      ClassName_21    =   "CCWTextImage"
      font_21         =   0
      Animator_20     =   0
      Blinker_20      =   0
      PointStyle_5    =   21
      LineStyle_5     =   1
      LineWidth_5     =   1
      BasePlot_5      =   0
      DefaultXInc_5   =   1
      DefaultPlotPerRow_5=   -1  'True
      Axes_1          =   22
      ClassName_22    =   "CCWAxes"
      Array_22        =   2
      Editor_22       =   23
      ClassName_23    =   "CCWGFAxisArrayEditor"
      Owner_23        =   1
      Array[0]_22     =   6
      Array[1]_22     =   14
      DefaultPlot_1   =   24
      ClassName_24    =   "CCWDataPlot"
      opts_24         =   4194367
      Name_24         =   "[Template]"
      C[0]_24         =   65280
      C[1]_24         =   255
      C[2]_24         =   16711680
      C[3]_24         =   16776960
      Event_24        =   2
      X_24            =   6
      Y_24            =   14
      LineStyle_24    =   1
      LineWidth_24    =   1
      BasePlot_24     =   0
      DefaultXInc_24  =   1
      DefaultPlotPerRow_24=   -1  'True
      Cursors_1       =   25
      ClassName_25    =   "CCWCursors"
      Editor_25       =   26
      ClassName_26    =   "CCWGFCursorArrayEditor"
      Owner_26        =   1
      TrackMode_1     =   2
      GraphFrameStyle_1=   1
      GraphBackground_1=   0
      GraphFrame_1    =   27
      ClassName_27    =   "CCWDrawObj"
      opts_27         =   62
      C[0]_27         =   14737632
      C[1]_27         =   14737632
      Image_27        =   28
      ClassName_28    =   "CCWPictImage"
      opts_28         =   1280
      Rows_28         =   1
      Cols_28         =   1
      Pict_28         =   450
      F_28            =   14737632
      B_28            =   14737632
      ColorReplaceWith_28=   8421504
      ColorReplace_28 =   8421504
      Tolerance_28    =   2
      Animator_27     =   0
      Blinker_27      =   0
      PlotFrame_1     =   29
      ClassName_29    =   "CCWDrawObj"
      opts_29         =   62
      C[0]_29         =   14737632
      C[1]_29         =   0
      Image_29        =   30
      ClassName_30    =   "CCWPictImage"
      opts_30         =   1280
      Rows_30         =   1
      Cols_30         =   1
      Pict_30         =   1
      F_30            =   14737632
      B_30            =   0
      ColorReplaceWith_30=   8421504
      ColorReplace_30 =   8421504
      Tolerance_30    =   2
      Animator_29     =   0
      Blinker_29      =   0
      Caption_1       =   31
      ClassName_31    =   "CCWDrawObj"
      opts_31         =   62
      C[0]_31         =   -2147483640
      Image_31        =   32
      ClassName_32    =   "CCWTextImage"
      font_32         =   0
      Animator_31     =   0
      Blinker_31      =   0
      DefaultXInc_1   =   1
      DefaultPlotPerRow_1=   -1  'True
      Bindings_1      =   33
      ClassName_33    =   "CCWBindingHolderArray"
      Editor_33       =   34
      ClassName_34    =   "CCWBindingHolderArrayEditor"
      Owner_34        =   1
      Annotations_1   =   35
      ClassName_35    =   "CCWAnnotations"
      Editor_35       =   36
      ClassName_36    =   "CCWAnnotationArrayEditor"
      Owner_36        =   1
      AnnotationTemplate_1=   37
      ClassName_37    =   "CCWAnnotation"
      opts_37         =   63
      Name_37         =   "[Template]"
      Plot_37         =   24
      Text_37         =   "[Template]"
      TextXPoint_37   =   6.7
      TextYPoint_37   =   6.7
      TextColor_37    =   16777215
      TextFont_37     =   38
      ClassName_38    =   "CCWFont"
      bFont_38        =   -1  'True
      BeginProperty Font_38 {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ShapeXPoints_37 =   39
      ClassName_39    =   "CDataBuffer"
      Type_39         =   5
      m_cDims;_39     =   1
      m_cElts_39      =   1
      Element[0]_39   =   3.3
      ShapeYPoints_37 =   40
      ClassName_40    =   "CDataBuffer"
      Type_40         =   5
      m_cDims;_40     =   1
      m_cElts_40      =   1
      Element[0]_40   =   3.3
      ShapeFillColor_37=   16777215
      ShapeLineColor_37=   16777215
      ShapeLineWidth_37=   1
      ShapeLineStyle_37=   1
      ShapePointStyle_37=   10
      ShapeImage_37   =   41
      ClassName_41    =   "CCWDrawObj"
      opts_41         =   62
      Image_41        =   42
      ClassName_42    =   "CCWPictImage"
      opts_42         =   1280
      Rows_42         =   1
      Cols_42         =   1
      Pict_42         =   7
      F_42            =   -2147483633
      B_42            =   -2147483633
      ColorReplaceWith_42=   8421504
      ColorReplace_42 =   8421504
      Tolerance_42    =   2
      Animator_41     =   0
      Blinker_41      =   0
      ArrowVisible_37 =   -1  'True
      ArrowColor_37   =   16777215
      ArrowWidth_37   =   1
      ArrowLineStyle_37=   1
      ArrowHeadStyle_37=   1
   End
   Begin VB.Frame Frame1 
      Caption         =   "Salidas DIO"
      Height          =   1455
      Left            =   5640
      TabIndex        =   73
      Top             =   5880
      Width           =   6135
      Begin VB.CheckBox Check9 
         Caption         =   "Check9"
         Height          =   255
         Left            =   1800
         TabIndex        =   85
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check8 
         Caption         =   "Check8"
         Height          =   375
         Left            =   1560
         TabIndex        =   84
         Top             =   300
         Width           =   255
      End
      Begin VB.CheckBox Check7 
         Caption         =   "Check7"
         Height          =   255
         Left            =   1320
         TabIndex        =   83
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check6 
         Caption         =   "Check6"
         Height          =   255
         Left            =   1080
         TabIndex        =   82
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check5 
         Caption         =   "Check5"
         Height          =   255
         Left            =   840
         TabIndex        =   81
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check4 
         Caption         =   "Check4"
         Height          =   255
         Left            =   600
         TabIndex        =   80
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check3 
         Caption         =   "Check3"
         Height          =   255
         Left            =   360
         TabIndex        =   79
         Top             =   360
         Width           =   255
      End
      Begin VB.CheckBox Check2 
         Caption         =   "Check2"
         Height          =   255
         Left            =   120
         TabIndex        =   78
         Top             =   360
         Width           =   255
      End
   End
   Begin VB.Frame ATT 
      Caption         =   "ATT"
      Height          =   1215
      Left            =   120
      TabIndex        =   74
      Top             =   6600
      Width           =   4095
   End
   Begin VB.Frame Frame3 
      Caption         =   "Lectura ADC"
      Height          =   1935
      Left            =   120
      TabIndex        =   77
      Top             =   7920
      Width           =   4095
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&Archivo"
      Begin VB.Menu mnuSalir 
         Caption         =   "&Salir"
      End
   End
   Begin VB.Menu mnuTrastear 
      Caption         =   "&Trastear"
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' PENDIENTE:

' En ADC_Read hay dos formas de convertir los datos devueltos por el convertidor y que están en el buffer,
' una con conversiones de caracteres ASCII y otra con CVIb, dejar sólo una, la más eficiente

' Recablear en prototipo Busy ADC que no sirve para nada y añadir filtro OS2, OS1 y OS0, rasterar código con 'xxxxx

' Están repetidas rutinas como Volt2TwoComplement y ADCdata2Volt... limpiar

' Calcular nº de  muestras bytes que salen por SPI con Clock 2MHz
' Calcular cuantos puntos se pueden enviara para llenar buffer FIFO 2KB

' Para renerar retrasos para tiempos de conversión o muestreos se están enviando datos datos inútiles, mejor cambiarlo por comandos
' que generen muchos clock de SPI (facilmente cuantificables) y que no llene mucho el buffer FIFO como el cmd MPSSE 0x28,
' 65536 byte de entrada con CKK de 2MHz serían 260mseg, abría que limpiar buffer luego...
' Se podría cambiar la frec. del reloj para ralentizar o escribir/leer 0en otro puerto del FT4232 no usado.
' Hay un comando el 0x8F descrito en AN_108 para modo MCU Host bus que sólo genera clocks "inútiles"
' Estudiar tema del ruido analógigo en ADC por generar clocks...

' Mejorar gestión errores en SPI quitar on error resume next se puede usar SPI_ErrorReport

   'Public Declare Function SPI_GetNumHiSpeedDevices Lib "ftcspi" (ByRef NumHiSpeedDevices As Long) As Long
  

 
Option Explicit

Private Declare Function lstrlen Lib "kernel32.dll" Alias "lstrlenA" (ByVal lpString As Any) As Long
'Private Declare Function StartDoc Lib "D:\usuarios\JavierBlanco\Desktop\2000964 D Amplificador LHA-Modulo Digital\Visual Basic\LHA_DigiMod_Javier\Proyecto2.dll" (DocName As String) As Long
'Private Declare Function LHA_WriteDACdll Lib "D:\usuarios\JavierBlanco\Desktop\2000964 D Amplificador LHA-Modulo Digital\Visual Basic\LHA_DigiMod_Javier\Proyecto2.dll" (ByVal DACchannel As Byte, ByVal WriteData As Integer, ByVal selDAC As Boolean, ByVal maneja As Long) As Long
'Private Declare Function Suma Lib "D:\usuarios\JavierBlanco\Desktop\2000964 D Amplificador LHA-Modulo Digital\Visual Basic\LHA_DigiMod_Javier\Proyecto2.dll" (ByVal n1 As Double, ByVal n2 As Long, ByVal maneja As Long, ByVal entrada As String) As String

Private Declare Function LHA_WriteDAC2 Lib "D:\usuarios\JavierBlanco\Desktop\TestDLL\LHADLL.dll" (ByVal DACchannel As Byte, ByVal WriteData As Integer, ByVal selDAC As Boolean, ByRef entrada As Long) As Long
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" _
                   (ByVal hwnd As Long, ByVal lpszOp As String, _
                    ByVal lpszFile As String, ByVal lpszParams As String, _
                    ByVal LpszDir As String, ByVal FsShowCmd As Long) _
                    As Long
Private Declare Function GetDesktopWindow Lib "user32" () As Long
                



Private Const PI = 3.14159
Private DACAmpliCode As Integer
Private DACResolCode As Integer
Private ErrLHA As Long

Private IgnoreEvents As Boolean

Private numADCChannels As Byte         ' Numero de canales de entrada que tiene el convertidor ADC

Private Enum WaveForms
   wf_Triangular
   wf_Cuadrada
   wf_Senoidal
   wf_Diente
End Enum

Private Type IntegerType
   Int As Integer
End Type
Private Type Bytes2Type
   L As Byte
   H As Byte
End Type




Private Sub cmdReSend_Click()
'    hsDACVolt_Change

Dim DACCode As Integer, chDAC As Byte
Dim cadenadatos As String
Dim cadena2 As String
Dim longituddatos As Long
Dim BytesWritten As Long
Dim r As Long
Dim cadena3 As String
Dim longituu As Long
cadena3 = "C:\h.jpg"
   
   Dim Scr_hDC As Long
          'Scr_hDC = GetDesktopWindow()
          
        Scr_hDC = Me.hwnd
          
   
   
 longituu = lstrlen(cadena3)
 longituu = Len("C:\h.jpg.")
   
   
 longituu = LHA_WriteDAC2(0, 0, True, SPI_Hdl)
   
      
   cadena3 = "D:\usuarios\JavierBlanco\Desktop\TestDLL\testdll.exe"
   longituu = ShellExecute(Scr_hDC, "Open", cadena3, "", "C:\", 1)
   
' r = StartDoc(cadena3)
   
 '  r = StartDoc("D:\usuarios\JavierBlanco\Desktop\TestDLL\testdll.exe.")
             
   
   
   lblDACVoltage.Caption = Format(hsDACVolt.Value / 1000, "0.000 V")
   DACCode = Volt2TwoComplement(hsDACVolt.Value / 1000)
   lblDACCode = Hex(DACCode) & " Hex"
   
' Lectura del canal DAC activo (0 a 3)
   For chDAC = 0 To 3
      If opDAC(chDAC).Value = True Then Exit For
   Next chDAC
   
            
 ' chDAC = Suma(6, 2)
  
' Prepara buffer

cadenadatos = PreparaDatos(chDAC, DACCode, dac1_dac2.Value)

longituddatos = Len(cadenadatos)

' Escribe desde dll

Debug.Print "Arguments DLLver: "; HexString(cadenadatos)


'If Check10.Value Then
'FT_Sta = FT_Write(SPI_Hdl, cadenadatos, longituddatos, BytesWritten)
'Else
'cadena2 = Suma(6, longituddatos, SPI_Hdl, cadenadatos)
'Debug.Print "Arguments conver: "; HexString(cadena2)
'End If
                   
 '  ErrLHA = LHA_WriteDACdll(chDAC, DACCode, dac1_dac2.Value, SPI_Hdl)
   
 '  LHA_WriteDACdll(
   
 '   ErrLHA = LHA_WriteDAC(chDAC, DACCode, dac1_dac2.Value)
   
  ' LHA_WriteDAC


End Sub

Private Sub Command2_Click()
   Dim H As Byte, L As Byte
   Dim i As Integer, c As Integer
   Dim T1!, T2!, T3!, T4!
   
   

   T1! = Timer
   For c = 1 To 1000
   For i = 1 To 20000
      Test i, H, L
   Next i
   Next c
   T2! = Timer
   
   T3! = Timer
   For c = 1 To 1000
   For i = 1 To 20000
      Test2 i, H, L
   Next i
   Next c
   T4! = Timer
   
   MsgBox Format(T2! - T1!, "0.00seg") & vbCrLf & Format(T4! - T3, "0.00seg")
   
End Sub

Private Sub Test(Dat As Integer, H As Byte, L As Byte)
   Dim Dato2B As Bytes2Type
   Dim DatoI As IntegerType
   
   DatoI.Int = Dat
   LSet Dato2B = DatoI
   H = Dato2B.H
   L = Dato2B.L
End Sub

Private Sub Test2(Dat As Integer, H As Byte, L As Byte)
   Dim Dato2B As Bytes2Type
   Dim DatoI As IntegerType
   
   L = Dat And &HFF             ' Byte Bajo
   H = ((Dat \ 256) And &HFF)   ' Byte Alto
   
End Sub

Private Sub Command1_Click()
   Dim WaveWRData() As Integer
   Dim WaveRDData() As Integer
   Dim ADCVolt() As Single
   Dim ADC1() As Integer, ADC2() As Integer, ADC3() As Integer, ADC4() As Integer
   Dim X() As Single
   
   ReDim X(10, 100)
   X(0, 0) = 1
   
   FrameEnable frDAC, True: FrameEnable frDACAuto, True: FrameEnable frDACManual, True
   
' Forma de onda seleccionada
   If opWaveForm(0).Value = True Then WaveGenerator WaveWRData(), wf_Triangular
   If opWaveForm(2).Value = True Then WaveGenerator WaveWRData(), wf_Diente
   If opWaveForm(1).Value = True Then WaveGenerator WaveWRData(), wf_Cuadrada
   If opWaveForm(3).Value = True Then WaveGenerator WaveWRData(), wf_Senoidal
   
   lblPoints = CStr(UBound(WaveWRData))
   ADCData2Volt WaveWRData(), ADCVolt()
   cwGrf(0).Plots(1).ClearData
   cwGrf(0).Plots(1).PlotY ADCVolt
   
End Sub



Private Sub Command3_Click()
  ErrLHA = LHA_WriteDIO(&H40, &H0)
End Sub

Private Sub Command4_Click()

 Dim Ctrl2 As Byte
   Dim Data2 As Integer



 Ctrl2 = Val("&H" & Text2.Text)
   Data2 = Val("&H" & Text3.Text)
   ' SPI_Ret = USBSPI_Write(Ctrl, Data)


    If Check1.Value Then
    
   '''bueno ErrLHA = LHA_WriteAtt(Ctrl2, Data2)
   
   Reloja0
   
       ' ErrLHA = LHA_WriteAtt(&H0, &H400)

    Else
       ' ErrLHA = LHA_WriteAtt(&H1, &HC00)
     
      ErrLHA = LHA_WriteAtt(Ctrl2, Data2)
     
    End If

End Sub

Private Sub Command5_Click()

   Dim c As Integer
   Dim ADCsData() As Integer
   Dim WaveRDData() As Integer
   Dim X() As Single

   ReDim ADCsData(numADCChannels - 1)
 ' ReDim WaveRDData(numADCChannels - 1)

            
   ErrLHA = LHA_ReadADC(ADCsData())
    
 '  For c = 0 To numADCChannels - 1              ' Separación de datos por canal
 '     WaveRDData(c) = ADCsData(c)
 '  Next c
    
   If hsScanDelay.Value <> 0 Then ScanDelay     ' Meto el retraso oportuno entre muestras


   Text4.Text = " " ' Borrar texto valores convertidos
    

   ReDim X(UBound(ADCsData, 1))            ' Ajusto tamaño de datos en voltios a representar
       
       
   For c = 0 To numADCChannels - 1           ' Rastreo canales ADC (0 a 5)
    
      X(c) = TwoComplement2Volt(ADCsData(c))    ' Las convierto en voltios
      Text4.Text = Text4.Text & vbCrLf & X(c)
   
   Next c

End Sub

Private Sub Form_Load()
   cmdOpen.Enabled = False
   cmdOpen.Tag = False
   
   numADCChannels = 6                     ' En la placa de Evalucióntengo un 7606-6 con 6 canales de 16 bits
   
   DACAmpliCode = Volt2TwoComplement(5)
   DACResolCode = Volt2TwoComplement(0.05)
   
   FrameEnable frDAC, False: FrameEnable frDACAuto, False: FrameEnable frDACManual, False
   FrameEnable frADC, False
   FrameEnable frScan, False
  
   SPI_ErrorReport_Mode ErrorMode_Msg     ' Configuro Modo de presentación de mensajes de librería
   cboADCFilter.ListIndex = 0
   
   RefreshDevices
End Sub


Private Sub RefreshDevices()
   Dim NumDevices As Long
   Dim DeviceIndex As Long, LocationID As Long, DeviceType As Long
   Dim DeviceName As String, DeviceChannel As String
         
   On Error Resume Next
   
   Me.MousePointer = vbHourglass
   lstDevices.Clear
   lstDevices.Refresh
   
         
   SPI_Ret = SPI_GetNumHiSpeedDevices(NumDevices)
   If SPI_Ret <> FT_SUCCESS Then
      MsgBox "Se produjo un error al buscar dispositivos, Cód.:" & CStr(SPI_Ret), vbExclamation, "Error de Dispositivo"
   End If
  
   If NumDevices = 0 Then
      MsgBox "No se encontraron dispositivos." & vbCrLf & _
      "Pulsa Refrescar o reconecta el cable del dispositivo.", vbCritical, "Error de Dispositivo"
      lstDevices.AddItem "No hay dispositivos"
      cmdOpen.Enabled = False
   Else
      DeviceIndex = 0
      Do
         SPI_Ret = USBSPI_GetDeviceInfo(DeviceIndex, DeviceName, LocationID, DeviceChannel, DeviceType)
         If (SPI_Ret = FT_OK) Then
            lstDevices.AddItem DeviceName & ", sn:" & DeviceChannel
         End If
         DeviceIndex = DeviceIndex + 1
      Loop While (DeviceIndex < NumDevices) And (SPI_Ret = FT_OK)
      lstDevices.ListIndex = 0
      cmdOpen.Enabled = True
   End If
   
   Me.MousePointer = vbDefault

   
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
   If TimerLoop.Enabled = True Then
      MsgBox "Hay un barrido en curso, debes desactivarlo antes de cerrar.", vbExclamation, "Cerrando..."
      Cancel = True
   End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
   SPI_Ret = SPI_Close(SPI_Hdl)
End Sub

Private Sub cmdExit_Click()
   Unload Me
End Sub

Private Sub FrameEnable(CtrlFrame As Frame, Enabled As Boolean)
   Dim Ctrl As Control
   
   On Error Resume Next
   
   CtrlFrame.Enabled = Enabled
   For Each Ctrl In frmMain
      If Ctrl.Container Is CtrlFrame Then
         If Err.Number = 0 Then              ' Para saltar controles como Timer que no deben activarse
            Ctrl.Enabled = Enabled
         Else
            Err.Clear
         End If
      End If
   Next
   
   
End Sub



'================================================================================
' DISPOSITIVOS
'================================================================================

Private Sub cmdOpen_Click()
   Dim DeviceIndex As Long, LocationID As Long, DeviceType As Long
   Dim DeviceName As String, DeviceChannel As String


   If CBool(cmdOpen.Tag) = True Then
      opStartStop(0).Value = True         ' Antes de cerrar desactivo el barrido en curso
      
      SPI_Ret = SPI_Close(SPI_Hdl)
      If SPI_Ret <> FT_OK Then
         MsgBox "Se produjo un error al cerrar el dispositivo, Cód.:" & CStr(SPI_Ret), vbExclamation, "Error de Dispositivo"
         Exit Sub
      End If
      cmdOpen.Tag = False
      cmdOpen.Caption = "&Open"
      FrameEnable frDAC, False: FrameEnable frDACAuto, False: FrameEnable frDACManual, False
      FrameEnable frADC, False
      FrameEnable frScan, False
   Else
      If lstDevices.ListIndex >= 0 Then
         DeviceIndex = lstDevices.ListIndex
         SPI_Ret = USBSPI_GetDeviceInfo(DeviceIndex, DeviceName, LocationID, DeviceChannel, DeviceType)
         If SPI_Ret = FT_OK Then
            SPI_Ret = SPI_OpenHiSpeedDevice(DeviceName, LocationID, DeviceChannel, SPI_Hdl)
            If (SPI_Ret = FT_OK) And (SPI_Hdl <> 0) Then
               cmdOpen.Tag = True
               cmdOpen.Caption = "&Close"
               FrameEnable frDAC, True: FrameEnable frDACAuto, True: FrameEnable frDACManual, True
               FrameEnable frADC, True
               FrameEnable frScan, True
               SPI_Ret = LHA_Config(SPI_Hdl, 2000000#)
            Else
               SPI_ErrorReport "SPI_OpenHiSpeedDevice", SPI_Ret
               'MsgBox "Se produjo un error al abrir el dispositivo, Cód.:" & CStr(SPI_Ret), vbExclamation, "Error de Dispositivo"
            End If
   
         End If
      End If
   End If

  Text5.Text = SPI_Hdl
End Sub

Private Sub cmdRefresh_Click()
   RefreshDevices
End Sub








Private Sub hsScanDelay_Change()
   lblScanDelay = hsScanDelay.Value
End Sub




Private Sub mnuTrastear_Click()
   frmSPITest.Show vbModal
End Sub

Private Sub chkGrfZoom_Click()
   If chkGrfZoom.Value = vbChecked Then
      cwGrf(0).Height = frADC.Height - cwGrf(0).Top - 120
      cwGrf(0).Width = frADC.Width - cwGrf(0).Left - 120
   Else
      cwGrf(0).Height = 1572
      cwGrf(0).Width = 3792
   End If
   
End Sub

Private Sub opStartStop_Click(Index As Integer)
   If Index = 0 Then
      TimerLoop.Enabled = False
      cmdOpen.Enabled = True
   Else
      TimerLoop.Enabled = True
      cmdOpen.Enabled = False
   End If
End Sub

Private Sub opWaveForm_Click(Index As Integer)
   chkSimulDACRead.Enabled = opWaveForm(3).Value
End Sub







'================================================================================
' DAC MANUAL
'================================================================================

Private Sub hsDACVolt_Change()
   Dim DACCode As Integer, chDAC As Byte
   
   lblDACVoltage.Caption = Format(hsDACVolt.Value / 1000, "0.000 V")
   DACCode = Volt2TwoComplement(hsDACVolt.Value / 1000)
   lblDACCode = Hex(DACCode) & " Hex"
   
' Lectura del canal DAC activo (0 a 3)
   For chDAC = 0 To 3
      If opDAC(chDAC).Value = True Then Exit For
   Next chDAC
   
   ErrLHA = LHA_WriteDAC(chDAC, DACCode, dac1_dac2.Value)
   
End Sub


'================================================================================
' DAC AUTOMATICO
'================================================================================

Private Sub hsDACAmplitud_Change()
   DACAmpliCode = Volt2TwoComplement(hsDACAmplitud.Value / 1000)
   lblDACAmpli = Format(hsDACAmplitud.Value / 1000, "0.000 V")
End Sub

Private Sub hsDACResolucion_Change()
   DACResolCode = Volt2TwoComplement(hsDACResolucion.Value / 1000)
   lblDACResol = Format(hsDACResolucion.Value, "0 mV")
End Sub


Private Sub WaveGenerator(WaveData() As Integer, WaveForm As WaveForms)
   Dim Inc As Integer, Dato As Integer
   Dim i As Long, NLoop As Integer, NDat As Long
   Dim Ang As Single
   
   On Error Resume Next
   
   i = 0
   
   Select Case WaveForm
      Case wf_Triangular
         NDat = ((4& * DACAmpliCode) / DACResolCode) + 100   ' Estimación del tamaño de la matriz (100 de reserva)
         If NDat > 65635 Then NDat = 65535
         ReDim WaveData(NDat)             ' Amplio matriz, luego recortaré
         NLoop = 0
         Inc = DACResolCode
         Dato = 0                ' La onda empieza en 0
         WaveData(0) = Dato      ' El primer dato que se 0
         Do
            i = i + 1
            Dato = Dato + Inc
            WaveData(i) = Dato
            If Inc > 0 Then
               If NLoop > 0 And Dato >= 0 Then Exit Do
               If Dato >= DACAmpliCode Then Inc = -Inc
            Else
               If Dato <= -DACAmpliCode Then
                  Inc = -Inc
                  NLoop = NLoop + 1
               End If
            End If
         Loop
         WaveData(i) = 0               ' Fuerzo el último dato de la onda a 0
         ReDim Preserve WaveData(i)    ' Ajusto la matriz al tamaño preciso
      
      Case wf_Diente
         NDat = ((2& * DACAmpliCode) / DACResolCode) + 100   ' Estimación del tamaño de la matriz (100 de reserva)
         If NDat > 65635 Then
            DACResolCode = 2 * DACAmpliCode / 65000
            NDat = 65535
            MsgBox "El numero de puntos es muy elevado, se ha bajado la resolución del DAC", vbExclamation
         End If
         ReDim WaveData(NDat)             ' Amplio matriz, luego recortaré
         For Dato = -DACAmpliCode To DACAmpliCode Step DACResolCode
            WaveData(i) = Dato
            i = i + 1
         Next Dato
         WaveData(i) = -DACAmpliCode      ' El último dato bajando el diente de sierra
         ReDim Preserve WaveData(i)       ' Ajusto la matriz al tamaño preciso

      Case wf_Cuadrada
         NDat = (DACAmpliCode / DACResolCode)
         ReDim WaveData((2& * NDat) + 100)      ' Amplio matriz, luego recortaré
         NLoop = 0
         Dato = DACAmpliCode           ' La onda empieza en DACAmpliCode
         WaveData(0) = 0               ' El primer dato que se 0
         Do
            i = i + 1
            WaveData(i) = Dato
            If i Mod NDat = 0 Then
               NLoop = NLoop + 1
               Dato = -DACAmpliCode
               If NLoop = 2 Then Exit Do
            End If
         Loop
         WaveData(i) = 0                  ' El último dato a 0
         ReDim Preserve WaveData(i)       ' Ajusto la matriz al tamaño preciso
         
      Case wf_Senoidal
         NDat = ((2& * DACAmpliCode) / DACResolCode)
         If NDat > 65535 Then
            DACResolCode = 2 * DACAmpliCode / 65000
            NDat = 65400
            MsgBox "El numero de puntos es muy elevado, se ha bajado la resolución del DAC", vbExclamation
         End If
         ReDim WaveData(NDat + 100)           ' Amplio matriz, luego recortaré
         For Ang = 0 To 2 * PI Step (2 * PI) / NDat
            WaveData(i) = Sin(Ang) * DACAmpliCode
            i = i + 1
         Next Ang
         WaveData(i) = 0                  ' El último dato 0
         ReDim Preserve WaveData(i)       ' Ajusto la matriz al tamaño preciso

      End Select

End Sub

Private Sub Salida_digital_Click()
    
        Dim i As Integer, Dato As Integer
    
    
  '  ErrLHA = LHA_WriteDIO(&H40, &H0)       ' Primero configuramos puertos como salida. JB: HACER EN CONFIG INICIAL
                                            ' ¿Habilitar pin HH también -pg. 15-?
    
    'Sleep (2)
    
    If BIT1_DIO.Value Then                  ' Y luego se cambia el valor del bit en función del check
    ErrLHA = LHA_WriteDIO(&H40, &HA01)
'     ErrLHA = LHA_WriteDIO(&H40, &H901)
'   ErrLHA = LHA_WriteDIO(&H40, &HA51)
    Else
       ErrLHA = LHA_WriteDIO(&H40, &HA00)  ' Registro 10

' ErrLHA = LHA_WriteDIO(&H40, &HA15)  ' Registro 10

    End If
    
    Text1.Text = "0"
    Dato = 0
   
 
      If Check9.Value = vbChecked Then Dato = Dato + 1
      If Check8.Value = vbChecked Then Dato = Dato + 2
      If Check7.Value = vbChecked Then Dato = Dato + 4
      If Check6.Value = vbChecked Then Dato = Dato + 8
      If Check5.Value = vbChecked Then Dato = Dato + 16
      If Check4.Value = vbChecked Then Dato = Dato + 32
      If Check3.Value = vbChecked Then Dato = Dato + 64
      If Check2.Value = vbChecked Then Dato = Dato + 128
 
      
      Text1.Text = Dato
      
      Dato = Dato + 2560 ' Registro 10
      

      
      ErrLHA = LHA_WriteDIO(&H40, Dato)
 
'   txtCmdRD.Text = Str(Dato)
           
End Sub

Public Sub Text1_Change()

End Sub

Private Sub TimerLoop_Timer()
   Dim Dato As Integer, Inc As Integer
   Dim NLoop As Integer, LoopMax As Integer
   Dim chDAC As Byte, i As Long, c As Integer
   Dim ADCsData() As Integer
   Dim WaveWRData() As Integer
   Dim WaveRDData() As Integer
   Dim X() As Single
   
   Dim seleccion As Boolean
   
   On Error Resume Next
   
   cwGrf(0).Plots(1).ClearData
   
' Lectura del canal DAC activo (0 a 3)
   For chDAC = 0 To 3
      If opDAC(chDAC).Value = True Then Exit For
   Next chDAC
   
   seleccion = dac1_dac2.Value
   
' JB: OJO
' JB: Cambiado para llamada a función sin proto en el nombre
   
' Preparación de filtro digital ADC
'''JB   LHAProto_SetADCFilter (cboADCFilter.ListIndex)
   
   LHA_SetADCFilter (cboADCFilter.ListIndex) '''JB: escrito yo
   
' Forma de onda seleccionada
   If opWaveForm(0).Value = True Then WaveGenerator WaveWRData(), wf_Triangular
   If opWaveForm(2).Value = True Then WaveGenerator WaveWRData(), wf_Diente
   If opWaveForm(1).Value = True Then WaveGenerator WaveWRData(), wf_Cuadrada
   If opWaveForm(3).Value = True Then WaveGenerator WaveWRData(), wf_Senoidal
   
' Preparación de parámetros
   ReDim ADCsData(numADCChannels - 1)
   ReDim WaveRDData(numADCChannels - 1, UBound(WaveWRData))
   lblPoints = CStr(UBound(WaveWRData))
   LoopMax = neLoops.Value          ' Lectura del num. de bucles a realizar
   Inc = DACResolCode
   Dato = 0
   NLoop = 0
      
   
   If chkTurbo.Value = vbUnchecked Then
      ' Bucle de barrido modo Normal (en cada transferencia USB sólo va un dato DAC ó ADC)
      Do
         For i = 0 To UBound(WaveWRData)
            ' Envío nuevo Dato DAC
            chkDACEnabled.Value = vbChecked
            If chkDACEnabled.Value = vbChecked Then ErrLHA = LHA_WriteDAC(chDAC, WaveWRData(i), seleccion)
            ' Conversión ADC de todos los canales
            If chkADCEnabled.Value = vbChecked Then ErrLHA = LHA_ReadADC(ADCsData())
            For c = 0 To numADCChannels - 1              ' Separación de datos por canal
               WaveRDData(c, i) = ADCsData(c)
            Next c
            If hsScanDelay.Value <> 0 Then ScanDelay     ' Meto el retraso oportuno entre muestras
         Next i
         NLoop = NLoop + 1
      Loop Until NLoop >= LoopMax
      
   Else
      ' Bucle de barrido modo Turbo (en cada trnasferencia USB se envía toda la onda DAC y se lee ADC)
      Do
         If chkDACEnabled.Value = vbUnchecked And chkADCEnabled.Value = vbUnchecked Then     ' Ni DAC ni ADC
         
         End If
         
         If chkDACEnabled.Value = vbChecked And chkADCEnabled.Value = vbUnchecked Then      ' con DAC pero sin ADC
         
         End If
         
         If chkDACEnabled.Value = vbUnchecked And chkADCEnabled.Value = vbChecked Then      ' sin DAC pero con ADC
         
         End If
         
         If chkDACEnabled.Value = vbChecked And chkADCEnabled.Value = vbChecked Then        ' con DAC y ADC
            ErrLHA = LHA_Scan(chDAC, WaveWRData(), WaveRDData(), hsScanDelay.Value / 6)
         End If
         
         NLoop = NLoop + 1
         DoEvents
      Loop Until NLoop >= LoopMax
      
   End If
   
   'JB: cambio de 3 por 5 en c
   
' Presentación de datos del último bucle
   ReDim X(UBound(WaveRDData, 2))            ' Ajusto tamaño de datos en voltios a representar
   For c = 0 To 5                            ' Rastreo 4 canales ADC (0 a 3) (según datasheet V1 a V4)
      For i = 0 To UBound(WaveRDData, 2)     ' Rastreo todos los muestars tomadas
         X(i) = TwoComplement2Volt(WaveRDData(c, i))    ' Las convierto en voltios
      Next i
      cwGrf(c).PlotY X()                     ' Y las grafico
   Next c

End Sub


Public Sub ScanDelay()
   Dim i As Integer
   
   For i = 1 To hsScanDelay.Value
      DoEvents
   Next i
End Sub


Private Function Volt2TwoComplement(Volt As Single)
   
   If Volt > 9.999695 Then Volt = 9.999695
   If Volt < -10 Then Volt = -10
   
   'Data = (((Volt - 10!) * 65536#) / 20#) + 32768#
   Volt2TwoComplement = Volt * 3276.8
End Function

Private Function TwoComplement2Volt(Data As Integer)
   TwoComplement2Volt = Data / 3276.8
End Function




