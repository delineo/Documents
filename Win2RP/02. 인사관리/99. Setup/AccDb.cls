VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "AccDb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Dim strConn As String
Dim adoConn As ADODB.Connection

' 클래스 초기화
Private Sub Class_Initialize()

    strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + VBA.CurDir + "\Win2RP.accdb"

    Set adoConn = Nothing

End Sub

' DB 연결
Public Function openDB() As Boolean

    If adoConn Is Nothing Then
        Set adoConn = New ADODB.Connection
    End If

    If adoConn.State = adStateOpen Then ' 디비가 연결 되었다면
        openDB = True
        Exit Function
    End If

    openDB = False
   
    adoConn.Open strConn

    If adoConn.State = adStateOpen Then
        openDB = True
    End If

End Function


' DB 연결 종료
Public Function closeDB()

    If adoConn Is Nothing Then
        Exit Function
    End If

    adoConn.Close
    Set adoConn = Nothing

End Function

' 쿼리실행
Public Function execute(qry As String) As Recordset

    If Not openDB() Then
        Set execute = Nothing
        Exit Function
    End If

    Set execute = adoConn.execute(qry)

End Function

' 해당 쿼리의 데이터수 반환
Public Function getCount(query) As Integer

    If Not openDB() Then
        getCount = -1
        Exit Function
    End If

    Dim rs  As Recordset
    Dim sQry As String
    
    sQry = sQry & "select count(*) from          "
    sQry = sQry & "   (                          "
    sQry = sQry & query
    sQry = sQry & "   )                          "

    Set rs = adoConn.execute(sQry)
    
    getCount = rs.Fields(0).value

    rs.Close: Set rs = Nothing

End Function
