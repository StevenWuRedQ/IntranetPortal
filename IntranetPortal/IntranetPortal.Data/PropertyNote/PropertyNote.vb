
Public Class PropertyNote

    Public Property PropertyAddress As String

    Public ReadOnly Property TotalDue As Decimal?
        Get
            Return DelinquentInterest + CurrentUPB + ForbearanceAmount + EscrowAdvanceBalance
        End Get
    End Property


    Public Shared Function GetNotes(Optional bble As String = Nothing, Optional status As String = Nothing) As List(Of PropertyNote)
        Using ctx As New PortalEntities
            Dim result = From note In ctx.PropertyNotes.Where(Function(n) (n.BBLE = bble OrElse bble Is Nothing) AndAlso (n.FCStatus = status OrElse status Is Nothing))
                         Join li In ctx.ShortSaleLeadsInfoes On note.BBLE Equals li.BBLE
                         Select note, li.PropertyAddress

            Return result.AsEnumerable.Select(Function(a)
                                                  a.note.PropertyAddress = a.PropertyAddress
                                                  Return a.note
                                              End Function).ToList
        End Using
    End Function

End Class
