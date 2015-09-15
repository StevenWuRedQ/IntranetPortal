Public Class LeadDocSearch
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        BindCase()
    End Sub

    Sub BindCase()
        If (gridDocSearch.DataSource Is Nothing) Then
            Using ctx As New Entities
                gridDocSearch.DataSource = From c In Data.LeadInfoDocumentSearch.GetAllSearches Join l In ctx.Leads On c.BBLE Equals l.BBLE Select New With {.BBLE = c.BBLE, .Name = l.LeadsName}
                gridDocSearch.DataBind()
            End Using

        End If
    End Sub
    Protected Sub gridDocSearch_DataBinding(sender As Object, e As EventArgs)
        BindCase()
    End Sub
End Class