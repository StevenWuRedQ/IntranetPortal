Imports IntranetPortal.Data
Public Class UnderWritingManager

    Public Shared Function getInstance(id As Integer) As Underwriting
        Using ctx As New CodeFirstEntity
            Dim uw = From c In ctx.Underwritings
                     Where c.Id = id
            Return uw.FirstOrDefault
        End Using

    End Function

    Public Shared Function getInstanceByBBLE(bble As String) As List(Of Underwriting)

        Using ctx As New CodeFirstEntity
            Dim uws = From c In ctx.Underwritings
                      Where c.BBLE = bble
            Return uws.ToList
        End Using
    End Function


    Public Shared Function save(uw As Underwriting, saveby As String) As Boolean

        Using ctx As New CodeFirstEntity

            Dim u = getInstance(uw.Id)

            If u IsNot Nothing Then

                uw.UpdateBy = saveby
                uw.UpdateDate = DateTime.Now
                ctx.Entry(u).CurrentValues.SetValues(uw)
            Else
                uw.CreateBy = saveby
                uw.CreateDate = DateTime.Now
                ctx.Underwritings.Add(uw)

            End If
            ctx.SaveChanges()
        End Using

    End Function


End Class