Partial Public Class LawReference

    Public Shared Function GetReference(RefId As Integer) As LawReference
        Using ctx As New LegalModelContainer
            Return ctx.LawReferences.Find(RefId)
        End Using
    End Function

    Public Shared Function GetAllReference() As List(Of LawReference)
        Using ctx As New LegalModelContainer
            Return ctx.LawReferences.ToList
        End Using
    End Function

    Public Sub Save()
        Using ctx As New LegalModelContainer
            If RefId = 0 Then
                Me.CreateTime = DateTime.Now
                ctx.LawReferences.Add(Me)
            Else
                Dim lRef = ctx.LawReferences.Find(RefId)

                If lRef IsNot Nothing Then
                    lRef = Core.Utility.SaveChangesObj(lRef, Me)
                End If
            End If

            ctx.SaveChanges()
        End Using

    End Sub


End Class
