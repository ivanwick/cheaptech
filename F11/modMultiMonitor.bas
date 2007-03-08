Attribute VB_Name = "modMultiMonitor"
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Copyright ©1996-2006 VBnet, Randy Birch, All Rights Reserved.
' Some pages may also contain other copyrights by the author.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Distribution: You can freely use this code in your own
'               applications, but you may not reproduce
'               or publish this code on any web site,
'               online service, or distribute as source
'               on any media without express permission.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Private Const SM_XVIRTUALSCREEN As Long = 76
Private Const SM_YVIRTUALSCREEN As Long = 77
Private Const SM_CXVIRTUALSCREEN As Long = 78
Private Const SM_CYVIRTUALSCREEN As Long = 79
Private Const SM_CMONITORS As Long = 80
         
         
         
Private Declare Function GetSystemMetrics Lib "user32" _
   (ByVal nIndex As Long) As Long

         
Function GetDesktopMaximumWidth() As Long

  'Return the maximum width of
  'all monitors on the desktop. If
  'only one monitor, return screen
  'width.
  
   If IsMultiMonitorSystem() Then
      GetDesktopMaximumWidth = GetSystemMetrics(SM_CXVIRTUALSCREEN)
   Else
      GetDesktopMaximumWidth = Screen.Width \ Screen.TwipsPerPixelX
   End If

End Function
Function GetDesktopMaximumHeight() As Long

  'Return the maximum width of
  'all monitors on the desktop. If
  'only one monitor, return screen
  'width.
  
   If IsMultiMonitorSystem() Then
      GetDesktopMaximumHeight = GetSystemMetrics(SM_CYVIRTUALSCREEN)
   Else
      GetDesktopMaximumHeight = Screen.Height \ Screen.TwipsPerPixelY
   End If

End Function


Private Function IsMultiMonitorSystem() As Boolean

  'Returns True if a multi-monitor system
   IsMultiMonitorSystem = GetSystemMetrics(SM_CMONITORS) > 1

End Function



