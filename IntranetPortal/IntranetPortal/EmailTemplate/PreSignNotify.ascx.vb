Imports IntranetPortal.Data

Public Class PreSignNotify
    Inherits EmailTemplateControl

    Public Property UserName As String
    Public Property Requestor As String

    Public Property IsUpdateMode As Boolean

    Public Property PreSign As New PreSignRecord

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)

        If params IsNot Nothing Then

            Dim id = CInt(params("RecordId"))
            UserName = params("UserName")
            If params.ContainsKey("IsUpdate") Then
                IsUpdateMode = CBool(params("IsUpdate"))
            End If

            PreSign = PreSignRecord.GetInstance(id)
        End If

    End Sub
End Class