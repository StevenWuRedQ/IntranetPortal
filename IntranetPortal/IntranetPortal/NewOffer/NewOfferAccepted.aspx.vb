
Imports IntranetPortal.Data

Public Class NewOfferAccepted
    Inherits System.Web.UI.Page

    Public Property Address As String
    Public Property AcceptedDate As DateTime?
    Public Property AcceptedBy As String

    Public Property BBLE As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack() Then
            If Not String.IsNullOrEmpty(Request.QueryString("bble")) Then
                BBLE = Request.QueryString("bble").ToString
                Dim ss = ShortSaleCase.GetCaseByBBLE(bble)
                If ss IsNot Nothing Then
                    Address = ss.CaseName
                    AcceptedDate = ss.AcceptedDate
                    AcceptedBy = ss.AcceptedBy
                End If
            End If
        End If
    End Sub

End Class