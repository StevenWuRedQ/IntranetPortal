Partial Public Class Application

    Public Shared Function Instance(appId As Integer) As Application

        Using ctx As New CoreEntities
            Return ctx.Applications.Find(appId)
        End Using

    End Function


End Class
