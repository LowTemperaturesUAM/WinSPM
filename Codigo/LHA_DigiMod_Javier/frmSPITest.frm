VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmSPITest 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Test SPI"
   ClientHeight    =   6510
   ClientLeft      =   30
   ClientTop       =   360
   ClientWidth     =   5385
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6510
   ScaleWidth      =   5385
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCerrar 
      Caption         =   "&Cerrar"
      Height          =   372
      Left            =   4260
      TabIndex        =   118
      Top             =   6000
      Width           =   972
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5868
      Left            =   120
      TabIndex        =   0
      Top             =   60
      Width           =   5112
      _ExtentX        =   9022
      _ExtentY        =   10345
      _Version        =   393216
      Style           =   1
      TabHeight       =   420
      ForeColor       =   255
      TabCaption(0)   =   "SPI"
      TabPicture(0)   =   "frmSPITest.frx":0000
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "frWrite"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "frRead"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "frReg"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).ControlCount=   3
      TabCaption(1)   =   "DAC"
      TabPicture(1)   =   "frmSPITest.frx":001C
      Tab(1).ControlEnabled=   0   'False
      Tab(1).ControlCount=   0
      TabCaption(2)   =   "ADC"
      TabPicture(2)   =   "frmSPITest.frx":0038
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "frADCManual"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "chkTestADC"
      Tab(2).Control(1).Enabled=   0   'False
      Tab(2).Control(2)=   "chkUseDACSPI"
      Tab(2).Control(2).Enabled=   0   'False
      Tab(2).ControlCount=   3
      Begin VB.Frame frReg 
         Caption         =   "Registros DAC8734"
         ForeColor       =   &H00FF0000&
         Height          =   3285
         Left            =   60
         TabIndex        =   51
         Top             =   2460
         Width           =   4932
         Begin VB.CheckBox chkBitMon 
            Height          =   252
            Index           =   15
            Left            =   1680
            TabIndex        =   87
            Top             =   900
            Width           =   192
         End
         Begin VB.CheckBox chkBitMon 
            Height          =   252
            Index           =   14
            Left            =   1860
            TabIndex        =   86
            Top             =   900
            Width           =   192
         End
         Begin VB.CheckBox chkBitMon 
            Height          =   252
            Index           =   13
            Left            =   2040
            TabIndex        =   85
            Top             =   900
            Width           =   192
         End
         Begin VB.CheckBox chkBitMon 
            Height          =   252
            Index           =   12
            Left            =   2220
            TabIndex        =   84
            Top             =   900
            Width           =   192
         End
         Begin VB.CheckBox chkBitMon 
            Height          =   252
            Index           =   11
            Left            =   2460
            TabIndex        =   83
            Top             =   900
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   15
            Left            =   1680
            TabIndex        =   82
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   14
            Left            =   1860
            TabIndex        =   81
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   13
            Left            =   2040
            TabIndex        =   80
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   12
            Left            =   2220
            TabIndex        =   79
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   11
            Left            =   2460
            TabIndex        =   78
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   10
            Left            =   2640
            TabIndex        =   77
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   9
            Left            =   2820
            TabIndex        =   76
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   8
            Left            =   3000
            TabIndex        =   75
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   7
            Left            =   3300
            TabIndex        =   74
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   6
            Left            =   3480
            TabIndex        =   73
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   5
            Left            =   3660
            TabIndex        =   72
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   4
            Left            =   3840
            TabIndex        =   71
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   3
            Left            =   4080
            TabIndex        =   70
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   2
            Left            =   4260
            TabIndex        =   69
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   1
            Left            =   4440
            TabIndex        =   68
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBitCmd 
            Height          =   252
            Index           =   0
            Left            =   4620
            TabIndex        =   67
            Top             =   420
            Width           =   192
         End
         Begin VB.CommandButton cmdActualizarRegistros 
            BackColor       =   &H00E0E0E0&
            Caption         =   "&Actualizar"
            Height          =   312
            Left            =   1800
            Style           =   1  'Graphical
            TabIndex        =   66
            Top             =   2670
            Width           =   1572
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   15
            Left            =   3900
            TabIndex        =   65
            Text            =   "0000"
            Top             =   2160
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   14
            Left            =   3900
            TabIndex        =   64
            Text            =   "0000"
            Top             =   1860
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   13
            Left            =   3900
            TabIndex        =   63
            Text            =   "0000"
            Top             =   1560
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   12
            Left            =   3900
            TabIndex        =   62
            Text            =   "0000"
            Top             =   1260
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   11
            Left            =   2280
            TabIndex        =   61
            Text            =   "0000"
            Top             =   2160
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   10
            Left            =   2280
            TabIndex        =   60
            Text            =   "0000"
            Top             =   1860
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   9
            Left            =   2280
            TabIndex        =   59
            Text            =   "0000"
            Top             =   1560
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   8
            Left            =   2280
            TabIndex        =   58
            Text            =   "0000"
            Top             =   1260
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   7
            Left            =   660
            TabIndex        =   57
            Text            =   "0000"
            Top             =   2160
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   6
            Left            =   660
            TabIndex        =   56
            Text            =   "0000"
            Top             =   1860
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   5
            Left            =   660
            TabIndex        =   55
            Text            =   "0000"
            Top             =   1560
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   4
            Left            =   660
            TabIndex        =   54
            Text            =   "0000"
            Top             =   1260
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   1
            Left            =   660
            TabIndex        =   53
            Text            =   "0000"
            Top             =   840
            Width           =   492
         End
         Begin VB.TextBox txtRegisterHex 
            Alignment       =   1  'Right Justify
            Height          =   288
            Index           =   0
            Left            =   660
            TabIndex        =   52
            Text            =   "0000"
            Top             =   420
            Width           =   492
         End
         Begin VB.Label Label7 
            Caption         =   "D3 D2 D1 D0 AIN"
            BeginProperty Font 
               Name            =   "Franklin Gothic Medium Cond"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   192
            Left            =   1620
            TabIndex        =   117
            Top             =   720
            Width           =   1092
         End
         Begin VB.Label Label6 
            Caption         =   "AB LD RS PA  PB RV GPIO    DS NO --GAIN0-3--  DB0-1"
            BeginProperty Font 
               Name            =   "Franklin Gothic Medium Cond"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   1650
            TabIndex        =   116
            Top             =   240
            Width           =   3225
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   13
            Left            =   4440
            TabIndex        =   115
            Top             =   2220
            Width           =   372
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   12
            Left            =   4440
            TabIndex        =   114
            Top             =   1920
            Width           =   372
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   11
            Left            =   4440
            TabIndex        =   113
            Top             =   1620
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Gain-3"
            Height          =   192
            Index           =   13
            Left            =   3360
            TabIndex        =   112
            Top             =   2220
            Width           =   552
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   10
            Left            =   4440
            TabIndex        =   111
            Top             =   1320
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Gain-2"
            Height          =   192
            Index           =   12
            Left            =   3360
            TabIndex        =   110
            Top             =   1920
            Width           =   492
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   9
            Left            =   2820
            TabIndex        =   109
            Top             =   2220
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Gain-1"
            Height          =   192
            Index           =   11
            Left            =   3360
            TabIndex        =   108
            Top             =   1620
            Width           =   552
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   8
            Left            =   2820
            TabIndex        =   107
            Top             =   1920
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Gain-0"
            Height          =   192
            Index           =   10
            Left            =   3360
            TabIndex        =   106
            Top             =   1320
            Width           =   552
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   7
            Left            =   2820
            TabIndex        =   105
            Top             =   1620
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Zero-3"
            Height          =   192
            Index           =   9
            Left            =   1680
            TabIndex        =   104
            Top             =   2220
            Width           =   492
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   6
            Left            =   2820
            TabIndex        =   103
            Top             =   1320
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Zero-2"
            Height          =   192
            Index           =   8
            Left            =   1680
            TabIndex        =   102
            Top             =   1920
            Width           =   552
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   5
            Left            =   1200
            TabIndex        =   101
            Top             =   2220
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Zero-1"
            Height          =   192
            Index           =   7
            Left            =   1680
            TabIndex        =   100
            Top             =   1620
            Width           =   492
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   4
            Left            =   1200
            TabIndex        =   99
            Top             =   1920
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "Zero-0"
            Height          =   192
            Index           =   6
            Left            =   1680
            TabIndex        =   98
            Top             =   1320
            Width           =   552
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   3
            Left            =   1200
            TabIndex        =   97
            Top             =   1620
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "DAC-3"
            Height          =   192
            Index           =   5
            Left            =   120
            TabIndex        =   96
            Top             =   2220
            Width           =   672
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   2
            Left            =   1200
            TabIndex        =   95
            Top             =   1320
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "DAC-2"
            Height          =   192
            Index           =   4
            Left            =   120
            TabIndex        =   94
            Top             =   1920
            Width           =   672
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   1
            Left            =   1200
            TabIndex        =   93
            Top             =   900
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "DAC-1"
            Height          =   192
            Index           =   3
            Left            =   120
            TabIndex        =   92
            Top             =   1620
            Width           =   672
         End
         Begin VB.Label Label5 
            Caption         =   "Hex"
            Height          =   192
            Index           =   0
            Left            =   1200
            TabIndex        =   91
            Top             =   480
            Width           =   372
         End
         Begin VB.Label Label4 
            Caption         =   "DAC-0"
            Height          =   192
            Index           =   2
            Left            =   120
            TabIndex        =   90
            Top             =   1320
            Width           =   672
         End
         Begin VB.Label Label4 
            Caption         =   "Monitor"
            Height          =   192
            Index           =   1
            Left            =   120
            TabIndex        =   89
            Top             =   900
            Width           =   612
         End
         Begin VB.Label Label4 
            Caption         =   "Comnd"
            Height          =   192
            Index           =   0
            Left            =   120
            TabIndex        =   88
            Top             =   480
            Width           =   732
         End
      End
      Begin VB.Frame frRead 
         Caption         =   "Leer"
         ForeColor       =   &H00FF0000&
         Height          =   1245
         Left            =   60
         TabIndex        =   19
         Top             =   1200
         Width           =   4932
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   0
            Left            =   4620
            TabIndex        =   46
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   1
            Left            =   4440
            TabIndex        =   45
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   2
            Left            =   4260
            TabIndex        =   44
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   3
            Left            =   4080
            TabIndex        =   43
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   4
            Left            =   3840
            TabIndex        =   42
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   5
            Left            =   3660
            TabIndex        =   41
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   6
            Left            =   3480
            TabIndex        =   40
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   7
            Left            =   3300
            TabIndex        =   39
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   8
            Left            =   3000
            TabIndex        =   38
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   9
            Left            =   2820
            TabIndex        =   37
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   10
            Left            =   2640
            TabIndex        =   36
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   11
            Left            =   2460
            TabIndex        =   35
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   12
            Left            =   2220
            TabIndex        =   34
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   13
            Left            =   2040
            TabIndex        =   33
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   14
            Left            =   1860
            TabIndex        =   32
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   15
            Left            =   1680
            TabIndex        =   31
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   16
            Left            =   1380
            TabIndex        =   30
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   17
            Left            =   1200
            TabIndex        =   29
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   18
            Left            =   1020
            TabIndex        =   28
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   19
            Left            =   840
            TabIndex        =   27
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   20
            Left            =   600
            TabIndex        =   26
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   21
            Left            =   420
            TabIndex        =   25
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   22
            Left            =   240
            TabIndex        =   24
            Top             =   420
            Width           =   192
         End
         Begin VB.CheckBox chkBit 
            Height          =   252
            Index           =   23
            Left            =   60
            TabIndex        =   23
            Top             =   420
            Width           =   192
         End
         Begin VB.TextBox txtCmdRDHex 
            Alignment       =   1  'Right Justify
            Height          =   312
            Left            =   2640
            TabIndex        =   22
            Text            =   "80"
            Top             =   750
            Width           =   555
         End
         Begin VB.TextBox txtCmdRD 
            Alignment       =   1  'Right Justify
            Height          =   312
            Left            =   1590
            TabIndex        =   21
            Text            =   "128"
            Top             =   780
            Width           =   585
         End
         Begin VB.CommandButton cmdRead 
            BackColor       =   &H00E0E0E0&
            Caption         =   "Leer  ->"
            Height          =   372
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   20
            Top             =   750
            Width           =   1152
         End
         Begin MSComCtl2.UpDown udCmdRD 
            Height          =   315
            Left            =   2190
            TabIndex        =   47
            Top             =   750
            Width           =   285
            _ExtentX        =   503
            _ExtentY        =   556
            _Version        =   393216
            OrigLeft        =   2580
            OrigTop         =   360
            OrigRight       =   2832
            OrigBottom      =   672
            Max             =   16777215
            Enabled         =   -1  'True
         End
         Begin VB.Label Label3 
            Caption         =   "RD                     A3 A2 A1 A0   AB LD RS PAPB RV GPIO   DS NO --GAIN0-3--  DB0-1"
            BeginProperty Font 
               Name            =   "Franklin Gothic Medium Cond"
               Size            =   8.25
               Charset         =   0
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Left            =   60
            TabIndex        =   50
            Top             =   240
            Width           =   4785
         End
         Begin VB.Label lblDatoRD 
            Alignment       =   1  'Right Justify
            BorderStyle     =   1  'Fixed Single
            Height          =   315
            Left            =   3930
            TabIndex        =   49
            Top             =   750
            Width           =   885
         End
         Begin VB.Label Label1 
            Caption         =   "Hex"
            Height          =   255
            Index           =   0
            Left            =   3210
            TabIndex        =   48
            Top             =   810
            Width           =   375
         End
      End
      Begin VB.Frame frWrite 
         Caption         =   "Escribir"
         ForeColor       =   &H00FF0000&
         Height          =   912
         Left            =   60
         TabIndex        =   10
         Top             =   300
         Width           =   4932
         Begin VB.TextBox txtCmdWR 
            Alignment       =   1  'Right Justify
            Height          =   312
            Left            =   1860
            TabIndex        =   14
            Text            =   "4"
            Top             =   180
            Width           =   732
         End
         Begin VB.CheckBox ChkWriteLoop 
            BackColor       =   &H00C0E0FF&
            Caption         =   "Escribir en bucle"
            Height          =   408
            Left            =   3360
            Style           =   1  'Graphical
            TabIndex        =   13
            Top             =   300
            Width           =   1368
         End
         Begin VB.TextBox txtDatoWR 
            Alignment       =   1  'Right Justify
            Height          =   312
            Left            =   1860
            TabIndex        =   12
            Text            =   "1234"
            Top             =   480
            Width           =   732
         End
         Begin VB.CommandButton cmdWrite 
            BackColor       =   &H00E0E0E0&
            Caption         =   "&Escribir   ->"
            Height          =   408
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   11
            Top             =   300
            Width           =   1128
         End
         Begin VB.Timer TimerWRLoop 
            Enabled         =   0   'False
            Interval        =   500
            Left            =   2940
            Top             =   270
         End
         Begin VB.Label Label1 
            Caption         =   "Hex"
            Height          =   252
            Index           =   2
            Left            =   2640
            TabIndex        =   18
            Top             =   540
            Width           =   372
         End
         Begin VB.Label Label1 
            Caption         =   "Hex"
            Height          =   252
            Index           =   1
            Left            =   2640
            TabIndex        =   17
            Top             =   240
            Width           =   372
         End
         Begin VB.Label Label2 
            Caption         =   "Dato:"
            Height          =   192
            Index           =   1
            Left            =   1380
            TabIndex        =   16
            Top             =   540
            Width           =   432
         End
         Begin VB.Label Label2 
            Caption         =   "Cmd:"
            Height          =   192
            Index           =   0
            Left            =   1380
            TabIndex        =   15
            Top             =   240
            Width           =   432
         End
      End
      Begin VB.CheckBox chkUseDACSPI 
         Caption         =   "Usar el mismo SPI que el DAC"
         Height          =   525
         Left            =   -74580
         TabIndex        =   9
         Top             =   630
         Value           =   1  'Checked
         Width           =   2565
      End
      Begin VB.CheckBox chkTestADC 
         Caption         =   "Test ADC "
         Height          =   465
         Left            =   -71760
         Style           =   1  'Graphical
         TabIndex        =   8
         ToolTipText     =   "Sólo en modo diente de sierra"
         Top             =   690
         Width           =   1515
      End
      Begin VB.Frame frADCManual 
         Caption         =   "Manual"
         ForeColor       =   &H00FF0000&
         Height          =   1725
         Left            =   -74970
         TabIndex        =   1
         Top             =   1290
         Width           =   4932
         Begin VB.OptionButton opADC 
            BackColor       =   &H00E0E0E0&
            Caption         =   "ADC 3"
            Height          =   312
            Index           =   3
            Left            =   3720
            Style           =   1  'Graphical
            TabIndex        =   6
            Top             =   240
            Width           =   1092
         End
         Begin VB.OptionButton opADC 
            BackColor       =   &H00E0E0E0&
            Caption         =   "ADC 2"
            Height          =   312
            Index           =   2
            Left            =   2520
            Style           =   1  'Graphical
            TabIndex        =   5
            Top             =   240
            Width           =   1092
         End
         Begin VB.OptionButton opADC 
            BackColor       =   &H00E0E0E0&
            Caption         =   "ADC 1"
            Height          =   312
            Index           =   1
            Left            =   1320
            Style           =   1  'Graphical
            TabIndex        =   4
            Top             =   240
            Width           =   1092
         End
         Begin VB.OptionButton opADC 
            BackColor       =   &H00E0E0E0&
            Caption         =   "ADC 0"
            Height          =   312
            Index           =   0
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   3
            Top             =   240
            Value           =   -1  'True
            Width           =   1092
         End
         Begin VB.CommandButton cmdADCRead 
            BackColor       =   &H00C0E0FF&
            Caption         =   "Leer ADC"
            Height          =   465
            Left            =   120
            Style           =   1  'Graphical
            TabIndex        =   2
            Top             =   1110
            Width           =   4695
         End
         Begin VB.Label lblADCVolt 
            Alignment       =   1  'Right Justify
            BorderStyle     =   1  'Fixed Single
            Caption         =   "??? V"
            Height          =   285
            Left            =   120
            TabIndex        =   7
            Top             =   720
            Width           =   1095
         End
      End
   End
End
Attribute VB_Name = "frmSPITest"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdCerrar_Click()
   Unload Me
End Sub

Private Sub TimerWRLoop_Timer()
   Dim Ctrl As Byte
   Static Data As Integer
   Dim i As Integer
   
   Ctrl = &H2           ' Escribir en el registro 2 no tiene efectos
   For i = 1 To 10
      SPI_Ret = USBSPI_Write(Ctrl, Data)
      Data = Data + 1
      If Data > 512 Then Data = 0
   Next i
   
End Sub

Private Sub chkTestADC_Click()
   Dim DeviceIndex As Long, LocationID As Long, DeviceType As Long
   Dim DeviceName As String, DeviceChannel As String
   
' Uso del mismo SPI que el DAC
   If chkUseDACSPI.Value = vbChecked Then
      SPI2_Hdl = SPI_Hdl                  ' Sólo hay que igualar los handles
      'Exit Sub
   End If
   
' Apertura y cierre del segundo SPI si fuera necesario
   If chkTestADC.Value = vbChecked Then
      If chkUseDACSPI.Value = vbUnchecked Then     ' Si se usan 2 SPI tengo que abrir el 2º
         DeviceIndex = lstDevices.ListIndex        ' Miro cual es el canal SPI del DAC
         If DeviceIndex = 0 Then DeviceIndex = 1 Else DeviceIndex = 0   ' y eligo el otro SPI
         SPI_Ret = USBSPI_GetDeviceInfo(DeviceIndex, DeviceName, LocationID, DeviceChannel, DeviceType)
         If SPI_Ret = FT_OK Then
            SPI_Ret = SPI_OpenHiSpeedDevice(DeviceName, LocationID, DeviceChannel, SPI2_Hdl)
            If (SPI_Ret = FT_OK) And (SPI2_Hdl <> 0) Then
               SPI_Ret = LHA_Config(SPI2_Hdl, 2000000#)
            End If
         End If
      End If
      frADCManual.Enabled = True
   Else
      If chkUseDACSPI.Value = vbUnchecked Then     ' Si se usaban 2 SPI tengo que cerrar el 2º
         SPI_Ret = SPI_Close(SPI2_Hdl)
      End If
      frADCManual.Enabled = False
   End If

End Sub


Private Sub cmdADCRead_Click()
   Dim ADCData() As Integer
   
'''   lblDACVoltage.Caption = Format(hsDACVolt.Value / 1000, "0.000 V")
'''   DACCode = Volt2TwoComplement(hsDACVolt.Value / 1000)
'''   lblDACCode = Hex(DACCode) & " Hex"
'''
'''   For i = 0 To 3
'''      If opDAC(i).Value = True Then Exit For
'''   Next i
'''   NumReg = 4 + i
'''   SPI_Ret = USBSPI_WriteADC(NumReg, DACCode)
   ReDim ADCData(numADCChannels - 1)
   SPI_Ret = ADC_Read(ADCData())
   lblADCVolt = ADCData(0)
   
End Sub



'================================================================================
' ESCRIBIR
'================================================================================
Private Sub CmdWrite_Click()
   Dim Ctrl As Byte
   Dim Data As Integer
   
   Ctrl = Val("&H" & txtCmdWR.Text)
   Data = Val("&H" & txtDatoWR.Text)
   SPI_Ret = USBSPI_Write(Ctrl, Data)
      
End Sub

Private Sub ChkWriteLoop_Click()
   If ChkWriteLoop.Value = vbChecked Then
      TimerWRLoop.Enabled = True
   Else
      TimerWRLoop.Enabled = False
   End If
End Sub


'================================================================================
' LEER
'================================================================================
Private Sub chkBit_Click(Index As Integer)
   Dim i As Integer, Dato As Long
   
   For i = 0 To 23
      If chkBit(i).Value = vbChecked Then Dato = Dato + 2 ^ i
   Next i
   txtCmdRD.Text = Str(Dato)
   
End Sub

Private Sub cmdRead_Click()
   Dim ReadData As Long
   
   'DAC_Read_Config
   'SPI_Ret = USBSPI_Write(Val(txtCmdRD), &H0)
   'SPI_Ret = DAC_Read2(Val(txtCmdRD), ReadData)
   SPI_Ret = DAC_ReadCmd(Val(txtCmdRD), ReadData)
   lblDatoRD.Caption = Hex(ReadData)
End Sub

Private Sub txtCmdRD_Change()
   txtCmdRDHex.Text = Hex(txtCmdRD.Text)
End Sub

Private Sub txtCmdRDHex_Change()
   txtCmdRD.Text = Val("&H" & txtCmdRDHex.Text)
End Sub



'================================================================================
' REGISTROS
'================================================================================
Private Sub cmdActualizarRegistros_Click()
   Dim NumReg As Byte, ReadData As Long
   
   For NumReg = 0 To 15
      If NumReg >= 4 Or NumReg <= 1 Then
         'SPI_Ret = USBSPI_Write(&H80 + NumReg, &H0)
         'If SPI_Ret <> FT_OK Then Exit For
         'SPI_Ret = DAC_Read32(&H80 + NumReg, ReadData)
         SPI_Ret = DAC_ReadCmd(&H80 + NumReg, ReadData)
         If NumReg = 0 Then SetCheckBoxBit ReadData, chkBitCmd
         If NumReg = 1 Then SetCheckBoxBit ReadData, chkBitMon
         txtRegisterHex(NumReg).Text = Hex(ReadData)
      End If
   Next NumReg
   
End Sub

Private Sub SetCheckBoxBit(Data As Long, CheckCtrl As Object)
   Dim b As Integer, N As Long, Peso As Long
   
   On Error Resume Next
   
   IgnoreEvents = True
   
   N = Data
   For b = 15 To 0 Step -1
      Peso = 2 ^ b
      If N >= Peso Then
         CheckCtrl(b).Value = vbChecked
         N = N - Peso
      Else
         CheckCtrl(b).Value = vbUnchecked
      End If
   Next b
   
   IgnoreEvents = False
   
End Sub

Private Sub chkBitCmd_Click(Index As Integer)
   Dim i As Integer, Dato As Long
   
   If IgnoreEvents = True Then Exit Sub
   
   For i = 0 To 15
      If chkBitCmd(i).Value = vbChecked Then Dato = Dato + 2 ^ i
   Next i
   txtRegisterHex(0).Text = Hex(Dato)
   txtRegisterHex_KeyPress 0, 13
   
End Sub

Private Sub chkBitMon_Click(Index As Integer)
   Dim i As Integer, Dato As Long
   
   If IgnoreEvents = True Then Exit Sub
   
   For i = 11 To 15
      If chkBitMon(i).Value = vbChecked Then Dato = Dato + 2 ^ i
   Next i
   txtRegisterHex(1).Text = Hex(Dato)
   txtRegisterHex_KeyPress 1, 13
   
End Sub

Private Sub txtRegisterHex_KeyPress(Index As Integer, KeyAscii As Integer)
   Dim WriteData As Integer, NumReg As Byte
   
   If KeyAscii = 13 Then
      WriteData = "&H" & Trim(txtRegisterHex(Index).Text)
      NumReg = Index
      SPI_Ret = USBSPI_Write(NumReg, WriteData)
   End If
End Sub

