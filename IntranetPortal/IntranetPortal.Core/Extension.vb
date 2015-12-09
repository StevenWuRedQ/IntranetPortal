Imports System.Runtime.CompilerServices
Imports System.IO
Imports System.Text

Public Module JsonExtension

    <Extension()>
    Public Function ToJsonString(ByVal obj As Object) As String
        Dim json = Newtonsoft.Json.JsonConvert.SerializeObject(obj)
        Return json
    End Function
End Module