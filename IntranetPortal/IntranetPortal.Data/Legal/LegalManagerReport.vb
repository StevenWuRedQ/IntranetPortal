Public Class LegalManagerReport
    Public Shared Function GetAllCase() As List(Of LegalManagerReport)
        Using ctx As New LegalModelContainer
            Return ctx.LegalManagerReports.ToList
        End Using
    End Function

    Public ReadOnly Property LegalStatusString As String
        Get
            If LegalStatus.HasValue Then
                Dim ls As DataStatus = LegalStatus
                Return Core.Utility.GetEnumDescription(ls)
            End If

            Return Nothing
        End Get
    End Property
    Private _stuatsStr As String
    Public ReadOnly Property StuatsStr As String
        Get
            If _stuatsStr Is Nothing Then
                If (Status.HasValue) Then
                    _stuatsStr = CType(Status, LegalCaseStatus).ToString
                End If

            End If
            Return _stuatsStr
        End Get
    End Property
End Class
