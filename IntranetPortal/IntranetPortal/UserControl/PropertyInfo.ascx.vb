Public Class PropertyInfo
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
      
    End Sub

    Public Property LeadsInfoData As LeadsInfo = New LeadsInfo
    Public Function BindData() As Boolean
        UpatingPanel.Visible = LeadsInfoData.IsUpdating
        If LeadsInfoData.LisPens IsNot Nothing Then
            gridLiens.DataSource = LeadsInfoData.LisPens
            gridLiens.DataBind()
        End If
    End Function
End Class