Public Class GroupType
    Private Property _subGroups As List(Of GroupType)
    Public ReadOnly Property SubGroups() As List(Of GroupType)
        Get
            If (_subGroups Is Nothing) Then

                Using ctx As New ShortSaleEntities
                    _subGroups = ctx.GroupTypes.Where(Function(l) l.ParentId = Id).ToList()
                End Using
            End If
            Return _subGroups
        End Get
    End Property


    Private Property _contacts As List(Of PartyContact)

    Public ReadOnly Property Contacts() As List(Of PartyContact)
        Get
            If (_contacts Is Nothing) Then
                Dim allGroup = New List(Of Integer)
                allGroup.Add(Id)
                If (HasSubType()) Then
                    allGroup.AddRange(SubGroups.Select(Function(l) l.Id).ToList())
                End If
                Using ctx As New ShortSaleEntities
                    _contacts = ctx.PartyContacts.Where(Function(c) allGroup.Contains(c.GroupId) AndAlso (c.Disable Is Nothing Or c.Disable = False)).ToList()
                End Using
            End If
            Return _contacts
        End Get
    End Property
    Public Function HasSubType() As Boolean
        Return SubGroups IsNot Nothing AndAlso SubGroups.Count > 0
    End Function
    Public Shared Function AddGroups(gid As Integer, groupName As String, addUser As String) As GroupType
        Using ctx As New ShortSaleEntities
            Dim g = New GroupType
            If (gid <> 0) Then
                g.ParentId = gid
            End If
            g.GroupName = groupName
            g.CreateBy = addUser
            g.CreateDate = Date.Now
            ctx.GroupTypes.Add(g)
            ctx.SaveChanges()
        End Using
    End Function

    Public Shared Function GetGroup(aId As Integer) As GroupType
        Using ctx As New ShortSaleEntities
            Return ctx.GroupTypes.Where(Function(g) g.Id = aId).FirstOrDefault
        End Using

    End Function
    Public Shared Function GetAllGroupType(isAll As Boolean) As List(Of GroupType)
        Using ctx As New ShortSaleEntities
            If isAll Then
                Return ctx.GroupTypes.ToList()
            End If
            Return ctx.GroupTypes.Where(Function(g) g.ParentId Is Nothing).ToList()
        End Using
    End Function
   
End Class
