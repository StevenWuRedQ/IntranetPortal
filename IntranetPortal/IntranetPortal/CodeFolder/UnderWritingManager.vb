Imports IntranetPortal.Data
Public Class UnderwritingManager

    Public Shared Function getInstance(bble As String) As Underwriting
        Using ctx As New CodeFirstEntity
            Dim uws = From c In ctx.Underwritings
                      Where c.BBLE = bble
            Dim uw = uws.FirstOrDefault

            If Nothing IsNot uw Then
                For Each p In Core.EntityHelper(Of Underwriting).GetNavigationProperties(ctx)
                    ctx.Entry(uw).Reference(p.ToString).Load()
                Next
            End If

            Return uw
        End Using

    End Function

    Public Shared Function getArchived(id As String) As UnderwritingArchived
        Using ctx As New CodeFirstEntity
            Dim archiveds = From a In ctx.UnderwritingArchived
                            Where a.Id = id
                            Select a
            Dim archived = archiveds.FirstOrDefault

            If archived IsNot Nothing Then
                For Each p In Core.EntityHelper(Of UnderwritingArchived).GetNavigationProperties(ctx)
                    ctx.Entry(archived).Reference(p.ToString).Load()
                Next
            End If
            Return archived
        End Using
    End Function
    Public Shared Function save(uw As Underwriting, saveby As String) As Underwriting

        Using ctx As New CodeFirstEntity

            Dim u = ctx.Underwritings.SingleOrDefault(Function(t) t.BBLE = uw.BBLE)

            If u IsNot Nothing Then

                uw.UpdateBy = saveby
                uw.UpdateDate = DateTime.Now
                ctx.Entry(u).CurrentValues.SetValues(uw)
                Core.EntityHelper(Of Underwriting).ReferenceUpdate(ctx, u, uw)
            Else
                uw.CreateBy = saveby
                uw.CreateDate = DateTime.Now
                ctx.Underwritings.Add(uw)

            End If
            ctx.SaveChanges(saveby)
            Return u
        End Using

    End Function

    Public Shared Function archive(bble As String, saveBy As String, note As String) As Boolean
        Using ctx As New CodeFirstEntity

            Dim uw = getInstance(bble)

            If uw IsNot Nothing Then
                Dim uwa = New UnderwritingArchived

                uwa.BBLE = uw.BBLE
                uwa.ArchivedBy = saveBy
                uwa.ArchivedDate = DateTime.Now
                uwa.ArchivedNote = note

                uwa.PropertyInfo = uw.PropertyInfo
                uwa.PropertyInfo.Id = Nothing
                uwa.DealCosts = uw.DealCosts
                uwa.DealCosts.Id = Nothing
                uwa.RehabInfo = uw.RehabInfo
                uwa.RehabInfo.Id = Nothing
                uwa.RentalInfo = uw.RentalInfo
                uwa.RentalInfo.Id = Nothing
                uwa.LienInfo = uw.LienInfo
                uwa.LienInfo.Id = Nothing
                uwa.LienCosts = uw.LienCosts
                uwa.LienCosts.Id = Nothing

                ctx.UnderwritingArchived.Add(uwa)
                ctx.SaveChanges()
                Return True
            End If
            Return False
        End Using

    End Function

    Public Shared Function create(BBLE As String, createby As String) As Underwriting
        Using ctx As New CodeFirstEntity
            Dim u = New Underwriting
            u.PropertyInfo = New UnderwritingPropertyInfo
            u.DealCosts = New UnderwritingDealCosts
            u.RehabInfo = New UnderwritingRehabInfo
            u.RentalInfo = New UnderwritingRentalInfo
            u.LienInfo = New UnderwritingLienInfo
            u.LienCosts = New UnderwritingLienCosts

            u.CreateBy = createby
            u.CreateDate = DateTime.Now
            u.Status = Underwriting.UnderwritingStatusEnum.NewCreated
            ctx.Underwritings.Add(u)
            Return u
        End Using
    End Function

    Public Shared Function loadArchivedList(BBLE As String) As UnderwritingArchived()
        Using ctx As New CodeFirstEntity
            Dim list = From archived In ctx.UnderwritingArchived
                       Where archived.BBLE = BBLE
                       Select archived
            Return list.ToArray
        End Using
    End Function
End Class