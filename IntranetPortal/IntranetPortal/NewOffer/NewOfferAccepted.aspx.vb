
Imports IntranetPortal.Data

Public Class NewOfferAccepted
    Inherits LeadsBasePage

    Public Property Address As String
    Public Property AcceptedDate As DateTime?
    Public Property AcceptedBy As String

    Protected Overrides Sub LoadLeadsData(bble As String)
        bble = Request.QueryString("bble").ToString
        Dim ss = ShortSaleCase.GetCaseByBBLE(bble)
        If ss IsNot Nothing Then
            Address = ss.CaseName
            AcceptedDate = ss.AcceptedDate
            AcceptedBy = ss.AcceptedBy
        End If
    End Sub

End Class