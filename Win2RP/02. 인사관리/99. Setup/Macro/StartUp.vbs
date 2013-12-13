Dim WSHShell
Dim RetVal
Dim path
'On Error Resume next
Set WSHShell = WScript.CreateObject("WScript.Shell")
Set fs = WScript.CreateObject("Scripting.FileSystemObject")
RetVal = WSHShell.Run ("iGen.xla" , 1 , false)
WScript.Sleep 5000
