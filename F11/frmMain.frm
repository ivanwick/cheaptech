VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "About F11"
   ClientHeight    =   1875
   ClientLeft      =   11910
   ClientTop       =   1515
   ClientWidth     =   4005
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1875
   ScaleWidth      =   4005
   StartUpPosition =   1  'CenterOwner
   Begin VB.OptionButton optTopEdge 
      Caption         =   "Top edge"
      Height          =   315
      Left            =   720
      TabIndex        =   3
      Top             =   1440
      Width           =   1815
   End
   Begin VB.OptionButton optAwayCenter 
      Caption         =   "Away from center"
      Height          =   315
      Left            =   720
      TabIndex        =   2
      Top             =   1080
      Value           =   -1  'True
      Width           =   1815
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   120
      Top             =   120
   End
   Begin VB.Image Image1 
      Height          =   375
      Left            =   3720
      Top             =   1560
      Width           =   375
   End
   Begin VB.Label Label2 
      Caption         =   "if you think this wack then your on crack!"
      Height          =   495
      Left            =   720
      TabIndex        =   1
      Top             =   480
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "F11 from cheaptech software"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   720
      TabIndex        =   0
      Top             =   120
      Width           =   3015
   End
   Begin VB.Menu mSysTray 
      Caption         =   "SysTray Menu"
      Visible         =   0   'False
      Begin VB.Menu mPopAbout 
         Caption         =   "About"
      End
      Begin VB.Menu mPopExit 
         Caption         =   "Exit"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public expIntv As Double
Public expDelta As Double

' if the form was closed from the "control menu" (icon in top left)
' or the x button (top right), then don't unload the form, just
' hide it.
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    If UnloadMode = vbFormControlMenu Then
        Cancel = True
        Me.Hide
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    modMain.Cleanup
End Sub
'http://support.microsoft.com/kb/176085
Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    'this procedure receives the callbacks from the System Tray icon.
    Dim Result As Long
    Dim msg As Long
    
    'the value of X will vary depending upon the scalemode setting
    If Me.ScaleMode = vbPixels Then
        msg = x
    Else
        msg = x / Screen.TwipsPerPixelX
    End If
    
    Select Case msg
    Case WM_LBUTTONUP        '514 restore form window
        Me.WindowState = vbNormal
        Result = SetForegroundWindow(Me.hwnd)
        Me.Show
    Case WM_LBUTTONDBLCLK    '515 restore form window
        Me.WindowState = vbNormal
        Result = SetForegroundWindow(Me.hwnd)
        Me.Show
    Case WM_RBUTTONUP        '517 display popup menu
        Result = SetForegroundWindow(Me.hwnd)
        Me.PopupMenu Me.mSysTray
    End Select
End Sub



'''
Private Sub Image1_Click()
Timer1.Enabled = True
End Sub

Private Sub mPopExit_Click()
    'called when user clicks the popup menu Exit command
    Unload Me
End Sub

Private Sub mPopAbout_Click()
    'called when the user clicks the popup menu Restore command
    Dim Result As Long
    Me.WindowState = vbNormal
    Result = SetForegroundWindow(Me.hwnd)
    Me.Show
End Sub

Private Sub Timer1_Timer()
    expIntv = expIntv + expDelta
    
    If expIntv >= 1 Then
        Timer1.Enabled = False
        moveWins (1)  ' fully extended
    Else
    If expIntv <= 0 Then
        Timer1.Enabled = False
        moveWins (0)  ' return to original positions
        modMain.keyhook.okToRescan = True
    Else
        moveWins (expIntv)
    End If
    End If
    
    '''
    Timer1.Enabled = False
End Sub

