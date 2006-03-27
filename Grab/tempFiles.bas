Attribute VB_Name = "Module2"
Private Declare Function GetTempPath _
    Lib "kernel32" _
    Alias "GetTempPathA" _
    (ByVal nBufferLength As Long, _
    ByVal lpBuffer As String) As Long

Private Declare Function GetTempFileName _
    Lib "kernel32" _
    Alias "GetTempFileNameA" _
    (ByVal lpszPath As String, _
    ByVal lpPrefixString As String, _
    ByVal wUnique As Long, _
    ByVal lpTempFileName As String) As Long

Public Function GetWinTempPath() As String
Dim strTempPath As String, lngTempPath As Long
    strTempPath = Space(255)
    lngTempPath = GetTempPath(Len(strTempPath), strTempPath)
    If lngTempPath > 1 Then GetWinTempPath = Left(strTempPath, lngTempPath)
End Function

Public Function GetWinTempFileName(strPrefix As String) As String
    Dim strTempFileName As String, lngRes As Long
    strTempFileName = Space(255)
    lngRes = GetTempFileName(ByVal GetWinTempPath, strPrefix, 0&, _
    strTempFileName)
    GetWinTempFileName = StripNull(strTempFileName)
End Function

Public Function StripNull(ByVal strIn As String) As String
'Removes Trailing Null character(s) from a string
    Dim lngNull As Long
    lngNull = InStr(strIn, Chr$(0))
    If lngNull > 0 Then StripNull = Left$(strIn, lngNull - 1)
End Function

