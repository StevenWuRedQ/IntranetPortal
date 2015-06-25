Partial Public Class PropertyOwner

    Public Property DataStatus As ModelStatus

    Public ReadOnly Property FullName As String
        Get
            Return String.Format("{0} {1}", FirstName, LastName).Trim
        End Get
    End Property

    Public ReadOnly Property MailingAddress As String
        Get
            Return ShortSaleUtility.BuildPropertyAddress2(MailNumber, MailStreetName, MailCity, MailState, MailZip)
        End Get
    End Property

    Private _estateAttoeneyContact As PartyContact
    Public ReadOnly Property EstateAttorneyContact As PartyContact
        Get
            If _estateAttoeneyContact Is Nothing Then

                If EstateAttorneyId.HasValue Then

                    _estateAttoeneyContact = PartyContact.GetContact(EstateAttorneyId)
                End If
            End If

            Return _estateAttoeneyContact
        End Get
    End Property

    'Public Function GetOwner(bble As String, firstName As String, lastName As String)
    '    Using ctx As New ShortSaleEntities
    '        Dim owner = ctx.PropertyOwners.Where(Function(po) po.BBLE = bble And po.FirstName = firstName And po.LastName = lastName).SingleOrDefault

    '        If owner Is Nothing Then
    '            owner = New PropertyOwner
    '        End If

    '        Return owner
    '    End Using
    'End Function

    Public Sub Save()
        Using context As New ShortSaleEntities

            If OwnerId = 0 Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.PropertyOwners.Find(OwnerId)

                If obj IsNot Nothing Then
                    If DataStatus = ModelStatus.Deleted Then
                        context.PropertyOwners.Remove(obj)
                    Else
                        obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                    End If
                End If
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class
