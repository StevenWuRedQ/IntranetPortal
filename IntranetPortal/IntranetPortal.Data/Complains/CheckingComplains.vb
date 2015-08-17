Partial Public Class CheckingComplain

    Public Shared Function GetAllComplains() As List(Of CheckingComplain)

        Using ctx As New ConstructionEntities
            Return ctx.CheckingComplains.ToList
        End Using
    End Function

    Public Sub Save(saveBy As String)
        Using ctx As New ConstructionEntities

            Dim cc = ctx.CheckingComplains.Find(BBLE)

            If cc Is Nothing Then
                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now
                ctx.CheckingComplains.Add(Me)
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
            End If

            ctx.SaveChanges()
        End Using

    End Sub
End Class
