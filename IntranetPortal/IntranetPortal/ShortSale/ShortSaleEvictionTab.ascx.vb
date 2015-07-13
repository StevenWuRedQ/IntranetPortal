Imports IntranetPortal.ShortSale
Public Class ShortSaleEvictionTab
    Inherits System.Web.UI.UserControl
    Public Property evictionData As New ShortSaleCase
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    

    Protected Sub AddOccupantNotes_WindowCallback(source As Object, e As DevExpress.Web.ASPxPopupControl.PopupWindowCallbackArgs)
        Dim OccupantId = CInt(e.Parameter.Split("|")(0))
        Dim Notes = e.Parameter.Split("|")(1)
        Using context As New ShortSaleEntities
            Dim occupant = context.PropertyOccupants.Where(Function(o) o.OccupantId = OccupantId).FirstOrDefault
            occupant.Notes = Notes
            context.SaveChanges()
        End Using
    End Sub
End Class