Attribute VB_Name = "modMain"
Option Explicit

Public keyhook As KeyboardHook

Sub Main()
    Set keyhook = New KeyboardHook
    
    '''' put an icon in the systray
    With nid
        .cbSize = Len(nid)
        .hwnd = frmMain.hwnd
        .uId = vbNull
        .uFlags = NIF_ICON Or NIF_TIP Or NIF_MESSAGE
        .uCallBackMessage = WM_MOUSEMOVE
        .hIcon = frmMain.Icon
        .szTip = "F11 Active" & vbNullChar
    End With
    
    Shell_NotifyIcon NIM_ADD, nid

    '''' setup keyboard hook
    Set KeyboardHandler.KeyboardHook = keyhook
    HookKeyboard

End Sub


Sub Cleanup()
    UnhookKeyboard
    Shell_NotifyIcon NIM_DELETE, nid

End Sub
