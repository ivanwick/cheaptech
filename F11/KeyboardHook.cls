VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "KeyboardHook"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private curState As Integer 'local copy
Private enableRescan As Boolean

'Public Property Let state(ByVal vData As Integer)
'    curState = vData
'End Property

'Public Property Get state() As Integer
'    Set state = curState
'End Property


Public Property Let okToRescan(ByVal vData As Integer)
    enableRescan = vData
End Property

Public Property Get okToRescan() As Integer
    okToRescan = enableRescan
End Property


Public Function actionF11(keyDown As Boolean) As Boolean

    If keyDown Then
        Select Case curState
        Case -1
            If activate Then
                curState = 1
            End If
        Case 1
            curState = 2
        
        Case 3
            If deactivate Then
                curState = -2
            End If
        End Select
    Else  ' key release
        Select Case curState
        Case -2
            curState = -1
        Case 1
            curState = 3
        Case 2
            If deactivate Then
                curState = -1
            End If
        End Select
    End If
    
    actionF11 = True
End Function

Private Function activate() As Long
    'Debug.Print "Activate "; enableRescan
    
    ' don't ever rescan for windows unless we are completely
    ' deactivated.
    If (enableRescan) Then
        Call getToplevelWins
        If frmMain.optTopEdge.Value = True Then
            Call computeNewGeom_Top
        Else
            Call computeNewGeom_Edges
        End If
        
        frmMain.expIntv = 0
        enableRescan = False
    End If
    
    frmMain.Timer1.Enabled = True
    frmMain.expDelta = 0.1
    
    activate = True
End Function

Private Function deactivate() As Long
    'Debug.Print "Deactivate"
    
    enableRescan = False
    With frmMain
        .expDelta = -0.1
        .Timer1.Enabled = True
    End With
    
    deactivate = True
End Function


Private Sub Class_Initialize()
    enableRescan = True
    curState = -1
End Sub
