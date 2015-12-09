Partial Public Class PortalAgent
    Public Shared Function AgentList() As List(Of PortalAgent)
        Using ctx As New PublicSiteEntities
            Return ctx.PortalAgents.Where(Function(a) a.Position = "Finder").ToList
        End Using
    End Function

    Public Shared Function GetAgent(agentId As Integer) As PortalAgent
        Using ctx As New PublicSiteEntities
            Return ctx.PortalAgents.Where(Function(pa) pa.EmployeeID = agentId).FirstOrDefault
        End Using
    End Function
End Class
