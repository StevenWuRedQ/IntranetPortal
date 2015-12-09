Public Class ShowReport
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not String.IsNullOrEmpty(Request.QueryString("id")) Then
            Dim id As String = Request.QueryString("id")

            If Not String.IsNullOrEmpty(Request.QueryString("t")) Then
                Dim type = Request.QueryString("t").ToString
                If type = "log" Then
                    Dim logReport = New ActivityLogReport
                    logReport.BindData(id)

                    ASPxDocumentViewer1.Report = logReport
                    ASPxDocumentViewer1.Visible = True
                End If

            Else
                Dim leadReport As New LeaderReport
                leadReport.BindData(id)
                ASPxDocumentViewer1.Report = leadReport
                ASPxDocumentViewer1.Visible = True
            End If

        Else
            'ASPxDocumentViewer1.Visible = False
        End If

       
    End Sub

End Class