Imports System.Web.Services
Imports System.Web.Script.Services

Public Class Management1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function GetCallLogs() As Object
        Return (From obj In {New With {.Name = "Test1", .Count = 123}, New EmpData With {.Name = "Test2", .Count = 343}}
            Select obj).ToList
    End Function

End Class