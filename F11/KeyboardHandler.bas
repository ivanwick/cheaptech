Attribute VB_Name = "KeyboardHandler"
Option Explicit

Private Declare Function UnhookWindowsHookEx Lib "user32" _
  (ByVal hHook As Long) As Long

Private Declare Function SetWindowsHookEx Lib "user32" _
  Alias "SetWindowsHookExA" (ByVal idHook As Long, _
                             ByVal lpfn As Long, _
                             ByVal hmod As Long, _
                             ByVal dwThreadId As Long) As Long

Private Declare Sub CopyMemory Lib "kernel32" _
   Alias "RtlMoveMemory" _
  (pDest As Any, _
   pSource As Any, _
   ByVal cb As Long)

Private Declare Function GetAsyncKeyState Lib "user32" _
  (ByVal vKey As Long) As Integer

Private Declare Function CallNextHookEx Lib "user32" _
   (ByVal hHook As Long, _
   ByVal nCode As Long, _
   ByVal wParam As Long, _
   ByVal lParam As Long) As Long


Private Type KBDLLHOOKSTRUCT
  vkCode As Long
  scanCode As Long
  flags As Long
  time As Long
  dwExtraInfo As Long
End Type

' Low-Level Keyboard Constants
Private Const HC_ACTION = 0
Private Const LLKHF_EXTENDED = &H1
Private Const LLKHF_INJECTED = &H10
Private Const LLKHF_ALTDOWN = &H20
Private Const LLKHF_UP = &H80

' Virtual Keys
Public Const VK_TAB = &H9
Public Const VK_CONTROL = &H11
Public Const VK_ESCAPE = &H1B
Public Const VK_DELETE = &H2E
Public Const VK_F11 = &H7A


Private Const WH_KEYBOARD_LL = 13&
Public KeyboardHandle As Long


Public KeyboardHook As KeyboardHook

Public Function IsHooked(ByRef Hookstruct As KBDLLHOOKSTRUCT) _
            As Boolean

  If (KeyboardHook Is Nothing) Then
    IsHooked = False
    Exit Function
  End If

  If (Hookstruct.vkCode = VK_F11) Then

    IsHooked = KeyboardHook.actionF11((Hookstruct.flags And LLKHF_UP) = 0)
    'Debug.Print "flags: "; Hex(Hookstruct.flags)
    'Debug.Print Hex(LLKHF_UP)
    'Debug.Print Hex(LLKHF_UP And Hookstruct.flags)
    Exit Function
  End If

End Function



Public Function KeyboardCallback(ByVal Code As Long, _
  ByVal wParam As Long, ByVal lParam As Long) As Long

  Static Hookstruct As KBDLLHOOKSTRUCT

  If (Code = HC_ACTION) Then
    ' Copy the keyboard data out of the lParam (which is a pointer)
    Call CopyMemory(Hookstruct, ByVal lParam, Len(Hookstruct))

    If (IsHooked(Hookstruct)) Then
      KeyboardCallback = 1
      Exit Function
    End If

  End If

  KeyboardCallback = CallNextHookEx(KeyboardHandle, _
    Code, wParam, lParam)

End Function

Public Sub HookKeyboard()
  KeyboardHandle = SetWindowsHookEx( _
    WH_KEYBOARD_LL, AddressOf KeyboardCallback, _
    App.hInstance, 0&)

  If (KeyboardHandle <> 0) Then
    Debug.Print "Keyboard hooked"
  Else
    Debug.Print "Keyboard hook failed: " & Err.LastDllError
  End If
End Sub


Public Sub UnhookKeyboard()
  If (KeyboardHandle <> 0) Then
    Call UnhookWindowsHookEx(KeyboardHandle)
  End If
End Sub

