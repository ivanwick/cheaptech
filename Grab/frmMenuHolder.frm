VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMenuHolder 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog comDlg 
      Left            =   1200
      Top             =   240
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu mnuActions 
      Caption         =   "Actions"
      Begin VB.Menu mnuCopy 
         Caption         =   "Copy to Clipboard"
      End
      Begin VB.Menu mnuOpenPaint 
         Caption         =   "Copy and Open Paint"
      End
      Begin VB.Menu mnuSaveAs 
         Caption         =   "Save As..."
      End
   End
End
Attribute VB_Name = "frmMenuHolder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub mnuCopy_Click()
    Clipboard.Clear
'    Clipboard.SetData CaptureBox(startPoint, endPoint)
    ' this used to be a call to a function "CaptureBox" which was a further parameterized
    ' version of CaptureScreen, but it became unnecessary when i found the CaptureWindow
    ' function which can capture any rectangular part of a window.
    
    Clipboard.SetData frmPreview.selPicture
    
End Sub

Private Sub mnuOpenPaint_Click()
    ' the way this works is that it saves the image in a computer-generated
    ' file name and then opens it in paint via the command line option,
    ' then deletes the file.
    
    ' i also considered writing this with a windows API call to locate the newly
    ' opened paint window, then send a paste message to it, but that is more
    ' involved.
    
    'Dim tempFilename As String
    'tempFilename = GetWinTempFileName("grb")
    
    'SavePicture frmPreview.selPicture, tempFilename
    'MsgBox Shell("""C:\Program Files\Accessories\mspaint.exe"" ") '& tempFilename, vbNormalFocus)
    'Call Shell("""C:\Program Files\Accessories\mspaint.exe""", vbNormalFocus)
    'Kill tempFilename
    
    ''''''
    '' actually, let's just copy, open paint, and have the user paste it
    Call mnuCopy_Click
    Call Shell("""mspaint.exe""", vbNormalFocus)
    
End Sub

Private Sub mnuSaveAs_Click()
    Dim askAgain As Boolean
    Dim askReplace As Integer
    
    ' this is needed in order to detect whether the user clicked
    ' the "Cancel" button in the common dialog box
    On Error GoTo ErrHndl

    comDlg.DefaultExt = "bmp"
    comDlg.Filter = "Bitmap (*.bmp)|*.bmp"
    comDlg.CancelError = True
    
    askAgain = True
    
    
    While askAgain
        comDlg.ShowSave
        
        ' if the user clicks "Cancel", that is handled by the ErrHndl
        ' block down below.
        
    
        ' the user might have selected a file that already exists
        If (Dir(comDlg.FileName) <> "") Then
            askReplace = MsgBox(comDlg.FileName & " already exists." & vbCrLf _
                & "Do you want to replace it?", vbYesNo Or vbExclamation)
        End If
    
        askAgain = (askReplace = vbNo)
    
    Wend
    
       
    If (comDlg.FileName <> "") Then
         SavePicture frmPreview.selPicture, comDlg.FileName
    End If

    Exit Sub
    
ErrHndl:
    If Err.Number = cdlCancel Then
        Exit Sub
    Else
        MsgBox "An error occurred while saving your image." & vbCrLf _
            & "This error message ought to be more helpful.", vbCritical
    End If
    
    
    
End Sub
