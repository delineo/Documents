VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OraDb"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private sConnDO  As String
Private sConnTO  As String
Private sConnStr As String

Private adoConn As ADODB.Connection


Private Sub Class_Initialize()

    ' 테스트계
    sConnTO = "Provider=OraOLEDB.Oracle;Data Source=TOERP;User Id=POSMGERP;Password=toerp1;FetchSize=200;"
    
    ' 개발계
    sConnDO = "Provider=OraOLEDB.Oracle;Data Source=DOERP;User Id=POSERP;Password=doerp1;FetchSize=200;"


    Set adoConn = Nothing

End Sub

' DB 연결
Public Function OpenDb()

    If adoConn Is Nothing Then
        Set adoConn = New ADODB.Connection
        adoConn.CursorLocation = adUseClient
    End If

    If adoConn.State = adStateOpen Then ' 디비가 연결 되었다면
        OpenDb = True
        Exit Function
    End If

    OpenDb = False
   
    adoConn.Open sConnTO

    If adoConn.State = adStateOpen Then
        OpenDb = True
    End If

End Function

' 쿼리실행
Public Function Execute(qry As String) As ADODB.Recordset

    If Not OpenDb() Then
        Set Execute = Nothing
        Exit Function
    End If
    
    Set Execute = adoConn.Execute(qry)

End Function

' DB 연결 종료
Public Function CloseDb()

    If adoConn Is Nothing Then
        Exit Function
    End If

    adoConn.Close
    Set adoConn = Nothing

End Function


