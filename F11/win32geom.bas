Attribute VB_Name = "win32geom"
Declare Function MoveWindow Lib "user32" (ByVal hwnd As Long, _
    ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, _
    ByVal nHeight As Long, ByVal bRepaint As Long) As Long
       
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, _
    ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, _
    ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Public Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long

Public Declare Function GetWindowRect Lib "user32" (ByVal hwnd _
         As Long, lpRect As RECT) As Long

Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type


Type POINT_TYPE
  x As Long
  y As Long
End Type

