Imports System.ComponentModel
Imports System.Reflection
Imports System.Runtime.CompilerServices
Imports IntranetPortal.Data
Imports Humanizer

Public Class UnderWriterItem
    Inherits SummaryItemBase
    ' this should be underwriter status
    Public Property CaseStatus As LeadInfoDocumentSearch.UnderWriterStatus ' As UnderWriter.Status
    Public Property ViewName As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Overrides Sub BindData()
        LeadInfoDocumentSearch.UnderWriterStatus.PendingUnderwriting.Humanize()
        If Parameters IsNot Nothing Then
            CaseStatus = CType(Parameters("caseStatus"), LeadInfoDocumentSearch.UnderWriterStatus)
        End If

    End Sub

    Public Function HumanizeEnum(e As LeadInfoDocumentSearch.UnderWriterStatus) As String
        Return e.Humanize()
    End Function



End Class