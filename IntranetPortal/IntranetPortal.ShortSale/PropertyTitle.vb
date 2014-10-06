Public Class PropertyTitle
    Public Enum TitleType
        Seller = 0
        Buyer = 1
    End Enum

    Public Shared Function GetTitle(caseId As Integer, type As TitleType) As PropertyTitle
        Using context As New ShortSaleEntities
            Dim title = context.PropertyTitles.Where(Function(pt) pt.CaseId = caseId And pt.Type = type).FirstOrDefault
            If title Is Nothing Then
                title = New PropertyTitle
            End If

            Return title
        End Using
    End Function

    Public Sub Save()
        Using context As New ShortSaleEntities
            'context.ShortSaleCases.Attach(Me)
            If TitleId = 0 Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.PropertyTitles.Find(TitleId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using

    End Sub
End Class
