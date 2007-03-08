Attribute VB_Name = "win32api"

Option Explicit
Option Compare Text

Public Declare Function GetDesktopWindow Lib "user32" () As Long

Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Declare Function GetClassName& Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long)
Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Declare Function SendMessageByNum Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Integer, ByVal lParam As Long) As Long
Declare Function SendMessageByString Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As String) As Long

Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Declare Function GetSubMenu Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long
Declare Function GetMenuItemID Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long

Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Declare Function GetWindowDC Lib "user32" (ByVal hwnd As Long) As Long
Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long

Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long

Public Const GWW_HINSTANCE = (-6)
Public Const GWW_ID = (-12)
Public Const GWL_STYLE = (-16)


'*************************
'** GetWindow Constants **
'*************************

Public Const GW_CHILD = 5
Public Const GW_HWNDFIRST = 0
Public Const GW_HWNDLAST = 1
Public Const GW_HWNDNEXT = 2
Public Const GW_HWNDPREV = 3
Public Const GW_MAX = 5
Public Const GW_OWNER = 4

Public Const HWND_TOP = 0
Public Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOSIZE = &H1
Public Const FLAGS = SWP_NOMOVE Or SWP_NOSIZE

Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_KEYDOWN = &H100
Public Const WM_KEYUP = &H101
Public Const WM_CHAR = &H102
Public Const WM_SETTEXT = &HC
Public Const WM_COMMAND = &H111

Public Const VK_HOME = &H24
Public Const VK_RIGHT = &H27
Public Const VK_CONTROL = &H11
Public Const VK_DELETE = &H2E
Public Const VK_DOWN = &H28
Public Const VK_LEFT = &H25
Public Const VK_RETURN = &HD
Public Const VK_SPACE = &H20
Public Const VK_TAB = &H9

Public Const WS_BORDER = &H800000
Public Const WS_CAPTION = &HC00000
Public Const WS_CHILD = &H40000000
Public Const WS_CHILDWINDOW = &H40000000
Public Const WS_CLIPCHILDREN = &H2000000
Public Const WS_CLIPSIBLINGS = &H4000000
Public Const WS_DISABLED = &H8000000
Public Const WS_DLGFRAME = &H400000
Public Const WS_GROUP = &H20000
Public Const WS_HSCROLL = &H100000
Public Const WS_ICONIC = &H20000000
Public Const WS_MAXIMIZE = &H1000000
Public Const WS_MAXIMIZEBOX = &H10000
Public Const WS_MINIMIZE = &H20000000
Public Const WS_MINIMIZEBOX = &H20000
Public Const WS_OVERLAPPED = &H0
Public Const WS_OVERLAPPEDWINDOW = &HCF0000
Public Const WS_POPUP = &H80000000
Public Const WS_POPUPWINDOW = &H80880000
Public Const WS_SIZEBOX = &H40000
Public Const WS_SYSMENU = &H80000
Public Const WS_TABSTOP = &H10000
Public Const WS_THICKFRAME = &H40000
Public Const WS_TILED = &H0
Public Const WS_TILEDWINDOW = &HCF0000
Public Const WS_VISIBLE = &H10000000
Public Const WS_VSCROLL = &H200000






      
      
Sub ClickButton(Handle As Long)
    Call SendMessageByNum(Handle, WM_LBUTTONDOWN, 0, 0) 'VK_SPACE, 0)
    'Sleep (1000)
    Call SendMessageByNum(Handle, WM_LBUTTONUP, 0, 0) 'VK_SPACE, 0)
End Sub


Function FindChildByClass(ParentHandle As Long, FindClass As String) As Long
    Dim TestHndl As Long
    Dim match As Long
    
    match = False
    TestHndl = GetWindow(ParentHandle, GW_CHILD)
    
    Do While TestHndl <> 0: DoEvents
    
    If GetClassString(TestHndl) = FindClass Then
    match = True
    Exit Do
    End If
    
    TestHndl = GetWindow(TestHndl, GW_HWNDNEXT)
    Loop
    
    If match = True Then
    FindChildByClass = TestHndl
    Else
    FindChildByClass = 0
    End If
    
End Function



Sub StayOnTop(TopForm As Form)
    Call SetWindowPos(TopForm.hwnd, HWND_TOPMOST, 0, 0, 0, 0, FLAGS)
End Sub

Function FindChildByTitleSuffix(ParentHandle As Long, FindTitle As String) As Long
    Dim TestHndl As Long
    Dim match As Long
    
    match = False
    TestHndl = GetWindow(ParentHandle, GW_CHILD)
    
    Do While TestHndl <> 0: DoEvents
    
    If Right(GetTitle(TestHndl), Len(FindTitle)) = FindTitle Then
    match = True
    Exit Do
    End If
    
    TestHndl = GetWindow(TestHndl, GW_HWNDNEXT)
    Loop
    
    If match = True Then
    FindChildByTitleSuffix = TestHndl
    Else
    FindChildByTitleSuffix = 0
    End If
    

End Function

Function FindChildByTitlePrefix(ParentHandle As Long, FindTitle As String) As Long
    Dim TestHndl As Long
    Dim match As Long
    
    match = False
    TestHndl = GetWindow(ParentHandle, GW_CHILD)
    
    Do While TestHndl <> 0: DoEvents
    
    If Left(GetTitle(TestHndl), Len(FindTitle)) = FindTitle Then
    match = True
    Exit Do
    End If
    
    TestHndl = GetWindow(TestHndl, GW_HWNDNEXT)
    Loop
    
    If match = True Then
    FindChildByTitlePrefix = TestHndl
    Else
    FindChildByTitlePrefix = 0
    End If
    

End Function

Function FindChildByTitle(ParentHandle As Long, FindTitle As String) As Long
    Dim TestHndl As Long
    Dim match As Long
    
    match = False
    TestHndl = GetWindow(ParentHandle, GW_CHILD)
    
    Do While TestHndl <> 0: DoEvents
    
    If GetTitle(TestHndl) = FindTitle Then
    match = True
    Exit Do
    End If
    
    TestHndl = GetWindow(TestHndl, GW_HWNDNEXT)
    Loop
    
    If match = True Then
    FindChildByTitle = TestHndl
    Else
    FindChildByTitle = 0
    End If
    

End Function
Function GetClassString(Handle) As String
    Dim className As String * 128
    Dim i As Long
    i = GetClassName(Handle, className, 128)
    
    GetClassString = Trim(className)
End Function


Function GetTitle(Handle) As String
    Dim title As String * 128
    Dim i As Long
    i = GetWindowText(Handle, title, 128)
    
    GetTitle = Trim(title)

End Function




