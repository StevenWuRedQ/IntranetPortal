Partial Public Class TitleClearence

    Public Enum ClearenceStatus
        Process = 0
        Cleared = 1
        Delete = 2
    End Enum

    Private _contact As New PartyContact
    Public ReadOnly Property Contact As PartyContact
        Get
            If ContactId.HasValue Then
                _contact = PartyContact.GetContact(ContactId)
            End If

            If _contact Is Nothing Then
                _contact = New PartyContact
            End If

            Return _contact
        End Get
    End Property

    Private _notes As List(Of CleareneceNote)
    Public ReadOnly Property Notes As List(Of CleareneceNote)
        Get
            Using context As New PortalEntities
                Return context.CleareneceNotes.Where(Function(nt) nt.ClearenceId = ClearenceId).OrderByDescending(Function(nt) nt.CreateDate).ToList
            End Using
        End Get
    End Property

    Public Sub Save()
        Using context As New PortalEntities
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
        Using context As New PortalEntities
            Dim clearence = context.TitleClearences.Where(Function(tc) tc.CaseId = CaseId).OrderByDescending(Function(tc) tc.SeqNum).FirstOrDefault
            If clearence Is Nothing Then
                Return 1
            Else
                Return clearence.SeqNum + 1
            End If
        End Using
    End Function

    Public Shared Sub Delete(clearenceId As Integer)
        Using Context As New PortalEntities
            Dim clearence = Context.TitleClearences.Find(clearenceId)

            If clearence IsNot Nothing Then
                Context.TitleClearences.Remove(clearence)
                Context.SaveChanges()
            End If
        End Using
    End Sub

    Public Shared Sub Cleared(clearenceId As Integer)
        Using Context As New PortalEntities
            Dim clearence = Context.TitleClearences.Find(clearenceId)

            If clearence IsNot Nothing Then
                clearence.Status = ClearenceStatus.Cleared
                Context.SaveChanges()
            End If
        End Using
    End Sub

    Public Shared Function GetCaseClearences(caseId As Integer) As List(Of TitleClearence)
        Using context As New PortalEntities
            Return context.TitleClearences.Where(Function(tc) tc.CaseId = caseId).OrderBy(Function(tc) tc.SeqNum).ToList
        End Using
    End Function

End Class
