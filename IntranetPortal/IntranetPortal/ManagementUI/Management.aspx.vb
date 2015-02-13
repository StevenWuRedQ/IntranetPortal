﻿Imports System.Web.Services
Imports System.Web.Script.Services
Imports System.Web.Script.Serialization
Public Class Management1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Protected Function GetAllTeam() As List(Of String)
        Dim teamList = New List(Of String)
        Using ctx As New Entities
            teamList = ctx.Employees.Where(Function(e) e.Name.Contains("Office")).Select(Function(e) e.Name).ToList
        End Using
        Return teamList
    End Function
    Public Function AllTameJson() As String
        Return (New JavaScriptSerializer()).Serialize(GetAllTeam)
    End Function

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Function GetCallLogs() As Object
        Return (From obj In {New With {.Name = "Test1", .Count = 123}, New EmpData With {.Name = "Test2", .Count = 343}}
            Select obj).ToList
    End Function

End Class