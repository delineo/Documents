Attribute VB_Name = "DBConn"

Function getList(code As String)

    Dim wbCodes As Workbook
    
    Set wbCodes = Application.Workbooks.Open("00.공통코드.xlsx")
    
    wbCodes.Worksheets("공통코드").Active
    
    
End Function

Sub 단추3_Click()
'
' 단추3_Click 매크로
'
    MsgBox "a열의 형식이 다르거나 자료가 없음...!"
    
    getList (1)

End Sub

