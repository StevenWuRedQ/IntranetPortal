Partial Public Class ShortSaleCaseComment
    Public Shared Function GetCaseComments(caseId As Integer) As List(Of ShortSaleCaseComment)
        Using Context As New ShortSaleEntities
            Return Context.ShortSaleCaseComments.Where(Function(comm) comm.CaseId = caseId).ToList
        End Using
    End Function

    Public Sub Save()
        Using context As New ShortSaleEntities
            Dim obj = context.ShortSaleCaseComments.Find(CommentId)

            If obj Is Nothing Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using
    End Sub

    Public Sub Delete()
        DeleteComment(CommentId)
    End Sub

    Public Shared Sub DeleteComment(commentId As Integer)
        Using context As New ShortSaleEntities
            Dim obj = context.ShortSaleCaseComments.Find(commentId)

            If obj IsNot Nothing Then
                context.ShortSaleCaseComments.Remove(obj)
                context.SaveChanges()
            End If
        End Using
    End Sub
End Class
