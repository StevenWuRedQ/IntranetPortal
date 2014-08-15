Public Class PropertyInfo
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then
            UpatingPanel.Visible = LeadsInfoData.IsUpdating
            If LeadsInfoData.LisPens IsNot Nothing Then
                gridLiens.DataSource = LeadsInfoData.LisPens
                gridLiens.DataBind()
            End If
        End If
    End Sub

    Public Property LeadsInfoData As LeadsInfo = New LeadsInfo



End Class