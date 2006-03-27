VERSION 5.00
Begin VB.Form frmPreview 
   BorderStyle     =   0  'None
   ClientHeight    =   7680
   ClientLeft      =   150
   ClientTop       =   435
   ClientWidth     =   11445
   DrawStyle       =   1  'Dash
   Icon            =   "frmPreview.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   MousePointer    =   2  'Cross
   ScaleHeight     =   512
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   763
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   WindowState     =   2  'Maximized
   Begin VB.Image imgBorderBox 
      Appearance      =   0  'Flat
      BorderStyle     =   1  'Fixed Single
      Height          =   3495
      Left            =   720
      Top             =   720
      Visible         =   0   'False
      Width           =   4095
   End
End
Attribute VB_Name = "frmPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Dim selMin As Point2D
Dim selMax As Point2D
Dim dragStart As Point2D

Public selPicture As Picture



Private Sub Form_KeyPress(KeyAscii As Integer)

    ' close the form if the user presses the escape key
    If KeyAscii = vbKeyEscape Then
        End
    End If
    

End Sub

Private Sub Form_Load()
    ' copy entire screen and set current window to display it
    ' Me.MaxButton
        
    Set Me.Picture = CaptureScreen()
    
    
    
    ' maximize current window to cover entire screen
    
    
End Sub


Private Sub Form_MouseDown(Button As Integer, Shift As Integer, mousex As Single, mousey As Single)

    'set starting point
    dragStart.x = mousex
    dragStart.y = mousey

    imgBorderBox.Visible = True
        
        
    'reset ending point to same
    selMin = dragStart
    selMax = dragStart
    
    imgBorderBox.Left = selMin.x
    imgBorderBox.Top = selMin.y
    
    Form_MouseMove Button, Shift, mousex, mousey
    

End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, mousex As Single, mousey As Single)

    ' update coordinates as the mouse moves
    If Button <> 0 Then
        
        selMin.x = Min(mousex, dragStart.x)
        selMin.y = Min(mousey, dragStart.y)
        
        selMax.x = Max(mousex, dragStart.x)
        selMax.y = Max(mousey, dragStart.y)
    
    ' also set ending point
    '''    endPoint.x = mousex
    '''    endPoint.y = mousey
    
    
        DrawSelectionBox
    End If
    
    
    
    
End Sub

' The way this function is implemented is that it moves and resizes
' a control on the main form which happens to have a single pixel
' black border.
' Change this function using the global selMin and selMax Point2D
' vars in order to implement smarter selection box drawing. (e.g.
' dotted line, color negation.
Private Sub DrawSelectionBox()
        imgBorderBox.Left = selMin.x
        imgBorderBox.Top = selMin.y
        
        imgBorderBox.Width = selMax.x - selMin.x
        imgBorderBox.Height = selMax.y - selMin.y

End Sub

Private Sub Form_MouseUp(Button As Integer, Shift As Integer, mousex As Single, mousey As Single)
    
    ' the user finished dragging the box.
    ' now put the image on the clipboard
    
    imgBorderBox.Visible = False
    
    ' the refresh is needed here because otherwise the setdata to clipboard below will happen
    ' before the window has a chance to redraw itself without the border box.
    Me.Refresh
    
    Set selPicture = CaptureWindow(Me.hWnd, True, _
        selMin.x, selMin.y, _
        selMax.x - selMin.x, selMax.y - selMin.y)
    
    imgBorderBox.Visible = True
    
    ' Allow the user to select the appropriate action from the popup menu
    Call frmMenuHolder.PopupMenu(frmMenuHolder.mnuActions)
    
    ' done.
    End

    

End Sub


