Imports System.Net
Imports System.Web.Http
Imports IntranetPortal.Data

Namespace Controllers
    Public Class CasePartiesController
        Inherits ApiController

        Function GetCaseParties(bble As String) As Object

            Dim ssCase = ShortSaleCase.GetCaseByBBLE(bble)
            ssCase = ShortSaleManage.LoadExeternalParties(ssCase)
            Dim titleOwner = TitleManage.GetTitleOwner(bble)
            Dim lCase = LegalCase.GetCase(bble)

            Return New With {
                    .ShortSale = ssCase,
                    .Legal = New With {
                        .Plantiff = lCase.GetFieldValue(Of String)("ForeclosureInfo.Plantiff"),
                        .PlantiffAttorney = lCase.GetFieldValue(Of String)("ForeclosureInfo.PlantiffAttorney"),
                        .Defendant = lCase.GetFieldValue(Of String)("SecondaryInfo.Defendant"),
                        .DefendantAttorney = lCase.GetFieldValue(Of String)("SecondaryInfo.DefendantAttorneyName")
                    }
                }


            'Return New With {
            '        .Processor = New With {
            '            .Id = ssCase.Processor,
            '            .Name = ssCase.ProcessorName
            '        },
            '        .InHouseTitle = titleOwner,
            '        .InHouseLegal = LegalCaseManage.GetCaseOwner(bble),
            '        .Referral = New With {
            '            .Id = ssCase.Referral,
            '            .Name = ssCase.ReferralUserName,
            '            .Manager = ssCase.ReferralManager,
            '            .Team = ssCase.ReferralTeam
            '        },
            '        .ListingAgent = New With {
            '            .Id = ssCase.ListingAgent,
            '            .Name = ssCase.ListingAgentName
            '        },
            '        .SellerAttorney = New With {
            '            .Id = ssCase.SellerAttorney,
            '            .Name = ssCase.SellerAttorneyName
            '        },
            '        .Buyer = ssCase.BuyerEntity,
            '        .TitleCompany = ssCase.BuyerTitle,
            '        .Legal = New With {
            '            .Plantiff = lCase.GetFieldValue(Of String)("ForeclosureInfo.Plantiff"),
            '            .PlantiffAttorney = lCase.GetFieldValue(Of String)("ForeclosureInfo.PlantiffAttorney"),
            '            .Defendant = lCase.GetFieldValue(Of String)("SecondaryInfo.Defendant"),
            '            .DefendantAttorney = lCase.GetFieldValue(Of String)("SecondaryInfo.DefendantAttorneyName")
            '        }
            '}
        End Function



    End Class
End Namespace