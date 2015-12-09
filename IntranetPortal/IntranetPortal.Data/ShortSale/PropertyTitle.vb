Public Class PropertyTitle
    Public Enum TitleType
        Seller = 0
        Buyer = 1
    End Enum

    Private _titleContact As PartyContact
    Public ReadOnly Property TitleContact As PartyContact
        Get
            If ContactId.HasValue Then
                _titleContact = PartyContact.GetContact(ContactId)
            End If

            If _titleContact Is Nothing Then
                _titleContact = New PartyContact
            End If

            Return _titleContact
        End Get
    End Property

    Public Shared Function GetBuyerTitle(BBLE As String) As PropertyTitle
        Using ctx As New PortalEntities
            Dim title = (From t In ctx.PropertyTitles
                         Join s In ctx.ShortSaleCases On s.CaseId Equals t.CaseId
                         Where s.BBLE = BBLE And t.Type = 1
                         Select t).FirstOrDefault
            Return title
        End Using
    End Function

    Public Shared Function UpdateBuyerTitle(title As PropertyTitle, userName As String) As Boolean
        If title.CaseId > 0 Then
            Using ctx As New PortalEntities
                Dim saved = ctx.PropertyTitles.Where(Function(t) t.CaseId = title.CaseId And t.Type = 1).FirstOrDefault
                Dim sscase = ctx.ShortSaleCases.Where(Function(t) t.CaseId = title.CaseId).FirstOrDefault

                If saved IsNot Nothing And sscase IsNot Nothing Then
                    Try
                        saved.OrderNumber = title.OrderNumber
                        saved.CompanyName = title.CompanyName
                        saved.ReviewedDate = title.ReviewedDate
                        saved.ReportOrderDate = title.ReportOrderDate
                        saved.ConfirmationDate = title.ConfirmationDate
                        saved.ReceivedDate = title.ReceivedDate
                        sscase.UpdateDate = DateTime.Now
                        sscase.UpdateBy = userName
                        ctx.SaveChanges()
                        Return True
                    Catch ex As Exception
                        Return False
                    End Try
                Else
                    Return False
                End If

            End Using
        Else
            Return False
        End If
    End Function

    Public Shared Function GetTitle(caseId As Integer, type As TitleType) As PropertyTitle
        Using context As New PortalEntities
            Dim title = context.PropertyTitles.Where(Function(pt) pt.CaseId = caseId And pt.Type = type).FirstOrDefault
            If title Is Nothing Then
                title = New PropertyTitle
            End If

            Return title
        End Using
    End Function

    Public Sub Save()
        Using context As New PortalEntities
            'context.ShortSaleCases.Attach(Me)
            If TitleId = 0 AndAlso Not context.PropertyTitles.Any(Function(t) t.CaseId = CaseId AndAlso t.Type = Type) Then
                CreateDate = DateTime.Now
                context.Entry(Me).State = Entity.EntityState.Added
            Else
                Dim obj = context.PropertyTitles.Where(Function(t) t.CaseId = CaseId AndAlso t.Type = Type).FirstOrDefault
                obj = ShortSaleUtility.SaveChangesObj(obj, Me)
            End If

            context.SaveChanges()
        End Using

    End Sub
End Class
