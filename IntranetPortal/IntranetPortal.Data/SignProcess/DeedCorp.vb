
''' <summary>
''' The Model for Deed Corps
''' </summary>
Public Class DeedCorp

    ''' <summary>
    ''' Return the DeepCorps of given team
    ''' </summary>
    ''' <param name="teamName">The Team Name</param>
    ''' <returns>The Corp List</returns>
    Public Shared Function GetTeamDeedCorps(teamName As String) As DeedCorp()
        Using ctx As New PortalEntities

            Return ctx.DeedCorps.Where(Function(a) a.Office = teamName).ToArray

        End Using
    End Function


    ''' <summary>
    ''' Return all the DeepCorps
    ''' </summary>
    ''' <returns>The Corp List</returns>
    Public Shared Function GetDeedCorps() As DeedCorp()
        Using ctx As New PortalEntities
            Return ctx.DeedCorps.ToArray
        End Using
    End Function

    ''' <summary>
    ''' Load the properties assigned to current Deed Corp
    ''' </summary>
    Public Sub LoadProperties()
        Using ctx As New PortalEntities
            Properties = ctx.DeedCorpProperties.Where(Function(d) d.EntityId = Me.EntityId).ToList
        End Using
    End Sub

    ''' <summary>
    ''' Return available active deed corp to assign by randomly
    ''' </summary>
    ''' <returns>The Corp List</returns>
    Public Shared Function GetNextAvailableCorp() As DeedCorp
        Using ctx As New PortalEntities
            Dim result = From dc In ctx.DeedCorps.Where(Function(a) a.Active)
                         Let Amount = ctx.DeedCorpProperties.Where(Function(dcp) dcp.EntityId = dc.EntityId).Count
                         Order By Amount Ascending
                         Select dc
                         Take (1)

            Return result.FirstOrDefault
        End Using
    End Function

    ''' <summary> 
    ''' Return DeepCorp instance by Corp Id
    ''' </summary>
    ''' <param name="id">The Corp identity</param>
    ''' <returns></returns>
    Public Shared Function GetDeedCorp(id As Integer) As DeedCorp
        Using ctx As New PortalEntities
            Dim corp = ctx.DeedCorps.Find(id)
            If corp IsNot Nothing Then
                corp.Properties = ctx.DeedCorpProperties.Where(Function(d) d.EntityId = id).ToList
                Return corp
            End If

            Return Nothing
        End Using
    End Function

    ''' <summary>
    ''' Assign property into this corp
    ''' </summary>
    ''' <param name="BBLE">The property bble</param>
    Public Sub AssignProperty(bble As String, assingBy As String)
        If Properties.Count >= 25 Then
            Throw New DataException("The deed corp is full")
        End If

        DeedCorpProperty.Assign(bble, EntityId, assingBy)
    End Sub

    Public Property Properties As List(Of DeedCorpProperty)
End Class
