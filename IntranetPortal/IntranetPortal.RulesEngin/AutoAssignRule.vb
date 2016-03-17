Imports System.Runtime.Serialization

<DataContract>
Public Class AutoAssignRule
    Inherits BaseRule
    Public Class BBLEReslut

        Public Property BBLE As String

    End Class

    Public Class AutoAssignTeam
        Public Property Name As String
        Public Property EmployeeName As String
    End Class
    Public Overrides Sub Execute()
        Log("======================Start Auto Assign Rule==============================")
        Dim assignAmount = CInt(Core.PortalSettings.GetValue("TeamAssignAmount"))
        If (assignAmount <= 0) Then
            Log("Auto assign amount is 0 so do not assign leads out!")
            Return
        End If
        Dim teams = GetAssignTeam()
        If (teams Is Nothing Or teams.Count <= 0) Then
            Log("there are no auto assign team give up assgin")
        End If
        Dim sql = Core.PortalSettings.GetValue("AutoAssignAvailableSql")
        If (String.IsNullOrEmpty(sql)) Then
            Log("can not find auto assign available SQL")
        End If
        Dim resluts = GetAvaibleLeads(sql)
        Dim totalAssign = teams.Count * assignAmount
        If (resluts.Count < totalAssign) Then
            Log("No enough leads to assign!")
        End If
        Dim assLeads = New List(Of IntranetPortal.PendingAssignLead)
        For i = 0 To resluts.Count - 1
            If (i >= totalAssign) Then
                Log("Assign done")
                Exit For
            End If
            Dim bble = resluts(i)
            Dim team = teams(i Mod teams.Count)


            Dim assLead = New IntranetPortal.PendingAssignLead With
                {
                .BBLE = bble,
                .EmployeeName = team,
                .CreateBy = "System",
                .Type = 0,
                .Status = 0,
                .CreateDate = Date.Now()
                }
            assLeads.Add(assLead)
        Next
        If (assLeads.Count > 0) Then
            Using ctx As New Entities
                ctx.PendingAssignLeads.AddRange(assLeads)
                ctx.SaveChanges()
            End Using

            Log("Assign " & assLeads.Count & "to {" & String.Join(",", teams) & "} succeed!")
        End If


        Log("======================End Auto Assign Rule==============================")
    End Sub
    Public Shared Function GetAvaibleLeads(Sql As String) As List(Of String)
        Using ctx As New Entities
            Dim results = ctx.Database.SqlQuery(Of BBLEReslut)(Sql).ToList
            If (results Is Nothing Or results.Count <= 0) Then
                Return Nothing
            End If
            Return results.Select(Function(o) o.BBLE).ToList
        End Using
        Return Nothing
    End Function
    Public Shared Function GetAssignTeam() As List(Of String)
        Dim assignTeamDescription = Core.PortalSettings.GetValue("AssignTeamDescription")
        Dim Sql = String.Format("SELECT * FROM [IntranetPortal].[dbo].[TeamView] where EmployeeName like '%Office%' and Description = '{0}'", assignTeamDescription)
        Using ctx As New Entities
            Dim assTeam = ctx.Database.SqlQuery(Of AutoAssignTeam)(Sql)
            'ctx.Teams.Where(Function(t) t.Description = assignTeamDescription)
            Return assTeam.Select(Function(t) t.EmployeeName).ToList
        End Using
        Return Nothing
    End Function

End Class
