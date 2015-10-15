Public Class ComplaintsDetailNotify
    Inherits EmailTemplateControl

    Protected complaint As Data.CheckingComplain

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData(params As Dictionary(Of String, String))
        MyBase.BindData(params)

        Dim bble = params("BBLE")
        Dim userName = params("UserName")

        complaint = Data.CheckingComplain.Instance(bble)

    End Sub

End Class