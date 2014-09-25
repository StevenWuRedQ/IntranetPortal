Partial Public Class TitleClearence

    Private _contact As New PartyContact
    Public ReadOnly Property Contact As PartyContact
        Get
            If ContactId.HasValue Then
                _contact = PartyContact.GetContact(ContactId)
            End If

            Return _contact
        End Get
    End Property

    Private _notes As List(Of CleareneceNote)
    Public ReadOnly Property Notes As List(Of CleareneceNote)
        Get
            Using context As New ShortSaleEntities
                Return context.CleareneceNotes.Where(Function(nt) nt.ClearenceId = ClearenceId).ToList
            End Using
        End Get
    End Property

    Public Sub Save()
        Using context As New ShortSaleEntities
            If ClearenceId = 0 Then
                If SeqNum = 0 Then
                    SeqNum = GetSeqNum()
                End If

                context.Entry(Me).State = Entity.EntityState.Added
                context.SaveChanges()
            Else
                Dim obj = context.TitleClearences.Find(CaseId)
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
                context.SaveChanges()
            End If
        End Using
    End Sub

    Public Function GetSeqNum() As Integer
        Using context As New ShortSaleEntities
            Dim clearence = context.TitleClearences.Where(Function(tc) tc.CaseId = CaseId).OrderByDescending(Function(tc) tc.SeqNum).FirstOrDefault
            If clearence Is Nothing Then
                Return 1
            Else
                Return clearence.SeqNum + 1
            End If
        End Using
    End Function

    Public Shared Function GetCaseClearences(caseId As Integer) As List(Of TitleClearence)
        Using context As New ShortSaleEntities
            Return context.TitleClearences.Where(Function(tc) tc.CaseId = caseId).OrderBy(Function(tc) tc.SeqNum).ToList
        End Using
    End Function

End Class
