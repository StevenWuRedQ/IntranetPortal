Partial Public Class GPAOffer

    Private _generateBy As String
    Public Property GenerateBy As String
        Get
            If Not String.IsNullOrEmpty(_generateBy) Then
                Return _generateBy
            End If

            If Not String.IsNullOrEmpty(UpdateBy) Then
                Return UpdateBy
            End If

            If Not String.IsNullOrEmpty(CreateBy) Then
                Return CreateBy
            End If

            Return Nothing
        End Get
        Set(value As String)
            _generateBy = value
        End Set
    End Property

    Public ReadOnly Property StatusStr As String
        Get
            If Status.HasValue Then
                Return CType(Status, OfferStatus).ToString
            End If

            Return Nothing
        End Get
    End Property

    Public Property CurrentTeam As String
    Public Property CurrentAgent As String
    Public Property Address As String

    Public Shared Function GetOffers(status As OfferStatus) As List(Of GPAOffer)
        Using ctx As New PortalEntities
            Dim result = From offer In ctx.GPAOffers.Where(Function(a) a.Status = status Or status = -1)
                         Join li In ctx.ShortSaleLeadsInfoes On offer.BBLE Equals li.BBLE
                         From ld In ctx.SSLeads.Where(Function(l) l.BBLE = offer.BBLE).DefaultIfEmpty
                         Select offer, li.PropertyAddress, ld

            Return result.AsEnumerable.Select(Function(a)
                                                  a.offer.CurrentTeam = ""
                                                  a.offer.CurrentAgent = a.ld.EmployeeName
                                                  a.offer.Address = a.PropertyAddress
                                                  Return a.offer
                                              End Function).ToList
        End Using
    End Function

    Public Shared Function GetOffer(bble As String) As GPAOffer
        Using ctx As New PortalEntities
            Dim result = From offer In ctx.GPAOffers.Where(Function(o) o.BBLE = bble)
                         Join li In ctx.ShortSaleLeadsInfoes On offer.BBLE Equals li.BBLE
                         From ld In ctx.SSLeads.Where(Function(l) l.BBLE = offer.BBLE).DefaultIfEmpty
                         Select offer, li.PropertyAddress, ld

            Return result.AsEnumerable.Select(Function(a)
                                                  a.offer.CurrentTeam = Nothing
                                                  a.offer.CurrentAgent = a.ld?.EmployeeName
                                                  a.offer.Address = a?.PropertyAddress
                                                  Return a.offer
                                              End Function).FirstOrDefault
        End Using
    End Function

    Public Sub UpdateStatus(status As OfferStatus)
        Using ctx As New PortalEntities
            Dim offer = ctx.GPAOffers.Find(BBLE)
            offer.Status = status
            ctx.SaveChanges()
        End Using
    End Sub

    Public Sub Save()
        Using ctx As New PortalEntities
            Dim offer = ctx.GPAOffers.Find(BBLE)

            If offer IsNot Nothing Then
                offer.UpdateBy = GenerateBy
                offer.LastUpdate = DateTime.UtcNow
                offer.OfferPrice = OfferPrice
            Else
                Me.CreateBy = GenerateBy
                Me.CreateDate = DateTime.UtcNow
                Me.Status = OfferStatus.Active
                ctx.GPAOffers.Add(Me)
            End If

            ctx.SaveChanges()
        End Using
    End Sub

    Public Enum OfferStatus
        All = -1
        Active = 0
        InTitle = 1
        Closed = 2
    End Enum
End Class


