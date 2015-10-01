Imports System.ComponentModel.DataAnnotations

Partial Public Class CustomReport

    Public Shared Function Instance(reportId As Integer) As CustomReport

        Using ctx As New Core.CoreEntities
            Return ctx.CustomReports.Find(reportId)
        End Using
    End Function

    Public Shared Function GetReports(owner As String) As CustomReport()
        Using ctx As New Core.CoreEntities
            Return ctx.CustomReports.Where(Function(c) c.Owner = owner).ToArray
        End Using
    End Function

    Public Shared Function Exists(reportId As Integer) As Boolean
        Using ctx As New Core.CoreEntities
            Return ctx.CustomReports.Any(Function(c) c.ReportId = reportId)
        End Using
    End Function

    Public Sub Delete()
        Using ctx As New Core.CoreEntities
            ctx.Entry(Me).State = Entity.EntityState.Deleted
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Save(saveBy As String)

        Using ctx As New CoreEntities

            If Not ctx.CustomReports.Any(Function(c) c.ReportId = ReportId) Then
                If String.IsNullOrEmpty(Me.Owner) Then
                    Me.Owner = saveBy
                End If

                Me.CreateBy = saveBy
                Me.CreateTime = DateTime.Now

                ctx.CustomReports.Add(Me)
            Else
                ctx.Entry(Me).State = Entity.EntityState.Modified
                Me.UpdateBy = saveBy
                Me.UpdateTime = DateTime.Now
            End If

            Me.SqlText = New QueryBuilder().BuildSelectQuery(Me.Query, Me.BaseTable)

            ctx.SaveChanges()
        End Using
    End Sub
End Class
