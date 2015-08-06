Imports IntranetPortal.Data

Public Class VendorsPopUpContent
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub
    Public Function getVenderTypes() As Dictionary(Of Integer, String)
        Return Utility.Enum2Dictinary(GetType(PartyContact.ContactType))
    End Function

End Class