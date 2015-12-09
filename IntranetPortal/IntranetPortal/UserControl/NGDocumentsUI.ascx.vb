Imports System.Security
Imports System.Web.Services
Imports IntranetPortal.Core

Public Class NGDocumentsUI
    Inherits System.Web.UI.UserControl

    Public Property ViewMode As Boolean = False
    Public Property LeadsName As String
    Public Property LeadsBBLE As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

End Class