Attribute VB_Name = "modExpose"
Option Explicit
Option Base 1

Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long
Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long

Private Const WS_BORDER = &H800000
Private Const WS_CAPTION = &HC00000
Private Const WS_CHILD = &H40000000
Private Const WS_CHILDWINDOW = &H40000000
Private Const WS_CLIPCHILDREN = &H2000000
Private Const WS_CLIPSIBLINGS = &H4000000
Private Const WS_DISABLED = &H8000000
Private Const WS_DLGFRAME = &H400000
Private Const WS_GROUP = &H20000
Private Const WS_HSCROLL = &H100000
Private Const WS_ICONIC = &H20000000
Private Const WS_MAXIMIZE = &H1000000
Private Const WS_MAXIMIZEBOX = &H10000
Private Const WS_MINIMIZE = &H20000000
Private Const WS_MINIMIZEBOX = &H20000
Private Const WS_OVERLAPPED = &H0
Private Const WS_OVERLAPPEDWINDOW = &HCF0000
Private Const WS_POPUP = &H80000000
Private Const WS_POPUPWINDOW = &H80880000
Private Const WS_SIZEBOX = &H40000
Private Const WS_SYSMENU = &H80000
Private Const WS_TABSTOP = &H10000
Private Const WS_THICKFRAME = &H40000
Private Const WS_TILED = &H0
Private Const WS_TILEDWINDOW = &HCF0000
Private Const WS_VISIBLE = &H10000000
Private Const WS_VSCROLL = &H200000

Private Const GWW_HINSTANCE = (-6)
Private Const GWW_ID = (-12)
Private Const GWL_STYLE = (-16)


Type WinInfo
    className As String
    hwnd As Long
    title As String
    
    origRect As RECT
    destPos As POINT_TYPE
End Type

Public infoList() As WinInfo
Public winCount As Long

Public Function StripNulls(OriginalStr As String) As String
    ' This removes the extra Nulls so String comparisons will work
    If (InStr(OriginalStr, Chr(0)) > 0) Then
        OriginalStr = Left(OriginalStr, InStr(OriginalStr, Chr(0)) - 1)
    End If
    StripNulls = OriginalStr
End Function

    
Function EnumWinProc(ByVal lhWnd As Long, ByVal lParam As Long) As Long
    Dim retVal As Long, ProcessID As Long, ThreadID As Long
    Dim WinClassBuf As String * 255, WinTitleBuf As String * 255
    Dim WinClass As String, WinTitle As String

    Dim info As WinInfo

    info.hwnd = lhWnd
    retVal = GetClassName(lhWnd, WinClassBuf, 255)
    info.className = StripNulls(WinClassBuf) ' remove extra Nulls & spaces
    retVal = GetWindowText(lhWnd, WinTitleBuf, 255)
    info.title = StripNulls(WinTitleBuf)
    
    ' find window style, skip it if we don't need to move it
    Dim style As Long
    Dim maskinc As Long  ' included bits
    Dim maskexc As Long  ' excluded bits
    
    maskinc = (WS_VISIBLE Or WS_OVERLAPPED)
    maskexc = (WS_MINIMIZE) ' Or WS_CLIPSIBLINGS)
    
    style = GetWindowLong(info.hwnd, GWL_STYLE)
    
    If ((style And maskinc) = maskinc) And ((style And maskexc) = 0) Then
        retVal = GetWindowRect(info.hwnd, info.origRect)
        ReDim Preserve infoList(winCount)
        infoList(winCount) = info
    
        winCount = winCount + 1
        'Debug.Print "added "; Hex(info.hwnd); ": " + info.title + " / " + info.className
    End If
    
    
    EnumWinProc = True
End Function

Sub getToplevelWins()
    Dim retVal As Long
    
    winCount = 1
    retVal = EnumWindows(AddressOf EnumWinProc, 0)
End Sub

Sub computeNewGeom_Edges()
    Dim i As Integer
    Dim screenCenter As POINT_TYPE
    Dim newPos As POINT_TYPE

    screenCenter.x = GetDesktopMaximumWidth / 2
    screenCenter.y = GetDesktopMaximumHeight / 2

    For i = LBound(infoList) To UBound(infoList)
        With infoList(i)
            newPos = nearestOffscreenPoint(screenCenter, .origRect)
            .destPos.x = newPos.x
            .destPos.y = newPos.y
            ' would .destPost = newPos work?
        End With
    Next i
End Sub

Sub computeNewGeom_Top()
    Dim i As Integer
    
    For i = LBound(infoList) To UBound(infoList)
        With infoList(i)
            .destPos.y = (.origRect.Top - .origRect.Bottom) + 20
            .destPos.x = .origRect.Left
        End With
    Next i
End Sub

Sub moveWins(interval As Double)
    Dim i As Integer
    
    For i = LBound(infoList) To UBound(infoList)
        With infoList(i)
        Call MoveWindow(.hwnd, .origRect.Left + (.destPos.x - .origRect.Left) * interval, _
                               .origRect.Top + (.destPos.y - .origRect.Top) * interval, _
                               .origRect.Right - .origRect.Left, _
                               .origRect.Bottom - .origRect.Top, _
                               True)
        End With
    Next i

End Sub

' The origin is at the top left corner of the screen, x increases
' rightward but y increases downward. As a consequence, the coordinate
' system is flipped.
' However, the coordinates are still named according to the signs
' of the components: for x/y, +/+ is 1, -/+ is 2, -/- is 3, +/- is 4
Function nearestOffscreenPoint(screenCenter As POINT_TYPE, origRect As RECT) As POINT_TYPE
    Dim mVec As POINT_TYPE
    Dim slope As Double
    Dim xEdge As POINT_TYPE
    Dim yEdge As POINT_TYPE
    
    Dim edgeMargin As Integer
    edgeMargin = 30
    
    ' use the center of the window
    mVec.x = (origRect.Left + origRect.Right) / 2 - screenCenter.x
    mVec.y = (origRect.Top + origRect.Bottom) / 2 - screenCenter.y
    ' includes cheapass hack to prevent div by 0
    slope = (mVec.y + 0.5) / (mVec.x + 0.5)
    
    Select Case quadrant(mVec)
        Case 1
        ' slope is positive
            xEdge.x = GetDesktopMaximumWidth - edgeMargin
            yEdge.y = GetDesktopMaximumHeight - edgeMargin
            
        Case 2
        ' slope is negative
            xEdge.x = edgeMargin - (origRect.Right - origRect.Left)
            yEdge.y = GetDesktopMaximumHeight - edgeMargin
            
        Case 3
        ' slope is positive
            xEdge.x = edgeMargin - (origRect.Right - origRect.Left)
            yEdge.y = edgeMargin - (origRect.Bottom - origRect.Top)
        Case 4
        ' slope is negative
            xEdge.x = GetDesktopMaximumWidth - edgeMargin
            yEdge.y = edgeMargin - (origRect.Bottom - origRect.Top)
            
    End Select
            
    ' compute the other component using the delta and the ratio (slope)
    xEdge.y = origRect.Top + (xEdge.x - origRect.Left) * slope
    yEdge.x = origRect.Left + (yEdge.y - origRect.Top) * (1 / slope)
    
    ' choose and return the one with less delta
    nearestOffscreenPoint = closerPoint(screenCenter, xEdge, yEdge)
End Function


Function quadrant(vec As POINT_TYPE) As Integer
    If (vec.x > 0) And (vec.y > 0) Then quadrant = 1
    If Not (vec.x > 0) And (vec.y > 0) Then quadrant = 2
    If Not (vec.x > 0) And Not (vec.y > 0) Then quadrant = 3
    If (vec.x > 0) And Not (vec.y > 0) Then quadrant = 4
End Function

' Basic Pythagorean theorem but this function skips the square-root
' operation because that might make it more efficient
Function closerPoint(ref As POINT_TYPE, p1 As POINT_TYPE, p2 As POINT_TYPE) As POINT_TYPE
    Dim dist1 As Double
    Dim dist2 As Double
    
    dist1 = (p1.x - ref.x) ^ 2 + (p1.y - ref.y) ^ 2
    dist2 = (p2.x - ref.x) ^ 2 + (p2.y - ref.y) ^ 2
    
    If dist1 < dist2 Then
        closerPoint = p1
    Else
        closerPoint = p2
    End If
End Function
