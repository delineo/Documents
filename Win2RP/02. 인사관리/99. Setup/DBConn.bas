Attribute VB_Name = "DBConn"

Function getList(code As String)

    Dim wbCodes As Workbook
    
    Set wbCodes = Application.Workbooks.Open("00.�����ڵ�.xlsx")
    
    wbCodes.Worksheets("�����ڵ�").Active
    
    
End Function

Sub ����3_Click()
'
' ����3_Click ��ũ��
'
    MsgBox "a���� ������ �ٸ��ų� �ڷᰡ ����...!"
    
    getList (1)

End Sub

