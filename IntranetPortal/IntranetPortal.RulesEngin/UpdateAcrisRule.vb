Imports IntranetPortal.Core
Imports IntranetPortal.Core.DataLoopRule
Imports IntranetPortal.Data
''' <summary>
''' This rule will scan daily update ACRIS API
''' Then find all exist lead in Portal, put all property to DataLoopRule,
''' The rule engine will run all services automatically to pull all data
''' </summary>
Public Class UpdateAcrisRule
    Inherits BaseRule

    Public Overrides Sub Execute()
        Log("=========== execute update ACRIS Rule ==============")
        PutAcrisUpdateLeadToLoopRule()
        Log("========== end execute update ACRIS Rule ===========")
    End Sub

    ''' <summary>
    ''' Get ACRIS update and lead in portal common BBLE Web API 
    ''' </summary>
    ''' <returns>List OF BBLE</returns>
    Private Function GetNeedUpdateBBLE() As List(Of String)

        ' get all transaction data since yesterday
        Dim range As DateTime = DateTime.Now.AddDays(-1).ToString("yyyyMMdd")

        Dim transaction = New PropertyService().GetAcrisUpdateTransaction(range)
        If transaction Is Nothing Then
            Log("ACRIS transaction is empty")
            Return Nothing
        End If

        Dim leads = Lead.GetLeadsByBBLEs(transaction.Data.ToArray)
        If (leads Is Nothing) Then
            Log("Can not find common lead in Portal")
        End If
        '' find common bble in portal
        Dim bbles = leads.Select(Function(l) l.BBLE.Trim())
        Return transaction.Data.Where(Function(b) bbles.Contains(b)).ToList
    End Function
    ''' <summary>
    ''' Put ACRIS update properties to Data loop rule table
    ''' The Rule engine will automatically get all related data for property 
    ''' </summary>
    Private Sub PutAcrisUpdateLeadToLoopRule()
        Dim list = GetNeedUpdateBBLE()
        If (list IsNot Nothing) Then
            DataLoopRule.AddRulesUnique(list.ToArray, DataLoopType.All, "ACRIS Update")
        End If
    End Sub

End Class
