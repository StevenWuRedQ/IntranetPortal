Public Class MapDataSet
    Public ReadOnly Property PercentWDBStr
        Get
            If (PercentWDB.HasValue) Then
                Dim d = CDec(Me.PercentWDB)
                Return d.ToString("p")
            End If
            Return Nothing
        End Get
    End Property
End Class
