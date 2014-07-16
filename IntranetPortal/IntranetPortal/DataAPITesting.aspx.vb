Public Class DataAPITesting
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim client As New PortalDataService
        ' client.CompleteDataLoad("10045455", 1, "PROP_TAX", "Task-Done", DateTime.Now)
    End Sub

    Public Sub GetData()
        'Dim dataApi = dataApi.WCFMacrosClient


    End Sub

End Class