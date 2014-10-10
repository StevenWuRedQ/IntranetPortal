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

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.PropertyOwners.Find(BBLE, FirstName, LastName)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                If DataStatus = ModelStatus.Deleted Then
                    context.PropertyOwners.Remove(obj)
                Else
                    obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                End If
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class
