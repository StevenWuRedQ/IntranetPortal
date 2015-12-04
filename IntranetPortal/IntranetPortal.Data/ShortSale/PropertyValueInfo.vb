Partial Public Class PropertyValueInfo

    Public Shared Function GetValueInfos(bble As String) As List(Of PropertyValueInfo)
        Using ctx As New PortalEntities
            Return ctx.PropertyValueInfoes.Where(Function(vi) vi.BBLE = bble).OrderByDescending(Function(vi) vi.DateOfValue).ToList
        End Using
    End Function

    Public Shared Function GetValueInfo(valueId As Integer) As PropertyValueInfo
        Using ctx As New PortalEntities
            Return ctx.PropertyValueInfoes.Find(valueId)
        End Using
    End Function

    Public Shared Sub DeleteValueInfo(valueId As Integer)
        Using ctx As New PortalEntities
            Dim info = ctx.PropertyValueInfoes.Find(valueId)
            If info IsNot Nothing Then
                ctx.PropertyValueInfoes.Remove(info)
                ctx.SaveChanges()
            End If
        End Using
    End Sub

    Public Sub Save()
        Using context As New PortalEntities
            'context.ShortSaleCases.Attach(Me)
            If ValueId = 0 Then
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.PropertyValueInfoes.Find(ValueId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub
End Class
