Public Class PropertyInfo
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Property LeadsInfoData As LeadsInfo = New LeadsInfo
    Public Function BindData() As Boolean
        UpatingPanel.Visible = LeadsInfoData.IsUpdating
        hfBBLE.Value = LeadsInfoData.BBLE

        If LeadsInfoData.LisPens IsNot Nothing Then
            gridLiens.DataSource = LeadsInfoData.LisPens
            gridLiens.DataBind()
        End If
    End Function

    Protected Sub leadsCommentsCallbackPanel_Callback(sender As Object, e As DevExpress.Web.ASPxClasses.CallbackEventArgsBase)
        If LeadsInfoData.BBLE Is Nothing AndAlso hfBBLE.Value IsNot Nothing Then
            LeadsInfoData = LeadsInfo.GetInstance(hfBBLE.Value)
        End If

        If e.Parameter.StartsWith("Add") Then
            Using Context As New Entities
                Dim lc As New LeadsComment
                lc.Comments = e.Parameter.Split("|")(1)
                lc.CreateBy = Page.User.Identity.Name
                lc.CreateTime = DateTime.Now
                lc.BBLE = LeadsInfoData.BBLE

                Context.LeadsComments.Add(lc)
                Context.SaveChanges()
            End Using
        End If

        If e.Parameter.StartsWith("Delete") Then
            Using Context As New Entities
                Dim commentId = CInt(e.Parameter.Split("|")(1))
                Dim lc = Context.LeadsComments.Find(commentId)
                If lc IsNot Nothing Then
                    Context.LeadsComments.Remove(lc)
                    Context.SaveChanges()
                End If
            End Using
        End If
        
    End Sub
End Class