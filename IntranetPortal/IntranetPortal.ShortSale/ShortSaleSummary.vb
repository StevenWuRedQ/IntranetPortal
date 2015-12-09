Public Class ShortSaleSummary
    Public Shared Function GetUrgentCases() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Where(Function(ss) ss.IsUrgent = True).ToList
        End Using
    End Function

    Public Shared Function GetCaseByMortStatus(status As String) As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim result = (From ssCase In ctx.ShortSaleCases
                         Join mort In ctx.PropertyMortgages On mort.CaseId Equals ssCase.CaseId
                         Where mort.Status = status
                         Select ssCase).Distinct.ToList
            Return result
        End Using
    End Function

    Public Shared Function GetUpcomingClosings() As List(Of ShortSaleCase)
        Using ctx As New ShortSaleEntities
            Dim upComingDate = DateTime.Today.AddDays(14)
            Dim result = (From ssCase In ctx.ShortSaleCases
                         Join mort In ctx.PropertyMortgages On mort.CaseId Equals ssCase.CaseId
                         Where mort.UpcomingBPODate < upComingDate
                         Select ssCase, mort.UpcomingBPODate).Distinct.ToList


            Return result.Select(Function(ru)
                                     ru.ssCase.UpComingBPODate = ru.UpcomingBPODate
                                     Return ru.ssCase
                                 End Function).ToList
        End Using
    End Function

    Public Shared Function GetFollowUpCases() As List(Of ShortSaleCase)
        Using context As New ShortSaleEntities
            Return context.ShortSaleCases.Where(Function(ss) ss.Status = CaseStatus.FollowUp).ToList
        End Using
    End Function

    Public Shared Function GetAllCase() As List(Of ShortSaleCase)
        'Using ctx As New ShortSaleEntities
        '    Dim result = From ssCase In ctx.ShortSaleCases
        '                 Join prop In ctx.PropertyBaseInfoes On prop.BBLE Equals ssCase.BBLE
        '                 Join processor In ctx.PartyContacts On ssCase.Processor Equals processor.ContactId
        '                 Join referral In ctx.PartyContacts On referral.ContactId Equals ssCase.Referral
        '                 Join listingAgent In ctx.PartyContacts On listingAgent.ContactId Equals ssCase.ListingAgent
        '                 Join buyer In ctx.PartyContacts On buyer.ContactId Equals ssCase.Buyer
        '                 Join sellerAtt In ctx.PartyContacts On sellerAtt.ContactId Equals ssCase.SellerAttorney
        '                 Join buyerAtt In ctx.PartyContacts On buyerAtt.ContactId Equals ssCase.BuyerAttorney
        '                 Select New With {
        '                     .CaseId = ssCase.CaseId,
        '                     .CaseName = ssCase.CaseName,
        '                     .BBLE = ssCase.BBLE,
        '                     .Processor = processor.Name,
        '                     .Referral = referral.Name,
        '                     .ListingAgent = listingAgent.Name,
        '                     .Buyer = buyer.Name,
        '                     .SellerAttorney = sellerAtt.Name,
        '                     .BuyerAttorney = buyerAtt.Name,
        '                     .StreetName = prop.StreetName,
        '                     .City = prop.City,
        '                     .State = prop.State
        '                     }
        '    Return result.ToList
        'End Using

        Using ctx As New ShortSaleEntities
            Return ctx.ShortSaleCases.OrderByDescending(Function(ss) ss.UpdateDate).ToList
        End Using
    End Function
End Class
