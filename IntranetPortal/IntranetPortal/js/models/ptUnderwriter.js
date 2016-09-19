angular.module('PortalApp').factory('ptUnderwriter', ['$http', 'ptBaseResource', 'DocSearch', 'LeadsInfo', function ($http, ptBaseResource, DocSearch, LeadsInfo) {

    var Underwriter = ptBaseResource('underwriter', 'BBLE', null, {});

    /* constructor for empty model */
    var _Model = function () {
        this.PropertyAddress = undefined;
        this.TaxClass = undefined;
        this.BuildingDimension = undefined;
        this.LotSize = undefined;
        this.Zoning = undefined;
        this.ActualNumOfUnits = undefined;
        this.PropertyTaxYear = undefined;
        this.OccupancyStatus = undefined;
        this.SellerOccupied = undefined;
        this.NumOfTenants = undefined;

        this.MoneySpent = undefined;
        this.HOI = undefined;
        this.COSTermination = undefined;
        this.AgentCommission = undefined;

        this.AverageLowValue = undefined;
        this.RenovatedValue = undefined;
        this.RepairBid = undefined;
        this.DealTimeMonths = undefined;
        this.SalesCommission = undefined;
        this.DealROICash = undefined;

        this.DeedPurchase = undefined;
        this.CurrentlyRented = undefined;
        this.RepairBidTotal = undefined;
        this.NumOfUnits = undefined;
        this.MarketRentTotal = undefined;
        this.RentalTime = undefined;

        this.FirstMortgage = undefined;
        this.SecondMortgage = undefined;
        this.COSRecorded = undefined;
        this.DeedRecorded = undefined;
        this.OtherLiens = undefined;
        this.FHA = undefined;
        this.FannieMae = undefined;
        this.FreddieMac = undefined;
        this.Servicer = undefined;
        this.ForeclosureIndexNum = undefined;
        this.ForeclosureStatus = undefined;
        this.ForeclosureNote = undefined;
        this.AuctionDate = undefined;
        this.DefaultDate = undefined;
        this.CurrentPayoff = undefined;
        this.PayoffDate = undefined;
        this.CurrentSSValue = undefined;

        this.TaxLienCertificate = undefined;
        this.PropertyTaxes = undefined;
        this.WaterCharges = undefined;
        this.HPDCharges = undefined;
        this.ECBDOBViolations = undefined;
        this.DOBCivilPenalty = undefined;
        this.PersonalJudgements = undefined;
        this.HPDJudgements = undefined;
        this.IRSNYSTaxLiens = undefined;
        this.VacateOrder = undefined;
        this.RelocationLien = undefined;
        this.RelocationLienDate = undefined;

        this.Tables = {
            Liens: {}
        };
        this.FlipSheets = {};
        this.RentalModel = {}

    }

    Underwriter.create = function () {
        return new _Model();
    }

    /**
     *
     * if no bble present only recreate data with empty model
     * if isImport present also load data from Doc Search and Leads Info
     * 
     **/
    Underwriter.load = function (/* optional */ bble, /* optional */ isImport) {
        var _data = this.create();
        var data = Underwriter.get({ BBLE: bble.trim() }, function () {
            angular.extend(data, _data)
            if (isImport) {
                data.docSearch = DocSearch.get({ BBLE: bble.trim() }, function () {
                    data.leadsInfo = LeadsInfo.get({ BBLE: bble.trim() }, function () {
                        mapData(data);
                    })

                });
            }

        })
        return data;
    }

    /* map rule from docsearch and leadsinfo to underwriting */
    function mapData(d) {
        if (d.docSearch && d.docSearch.LeadResearch) {
            
            var r = d.docSearch.LeadResearch;
            d.PropertyTaxes = r.leadsProperty_Taxes_per_YR_Property_Taxes_Due;
            d.FirstMortgage = r.mortgageAmount;
            d.SecondMortgage = r.secondMortgageAmount;
            d.COSRecorded = r.Has_COS_Recorded;
            d.DeedRecorded = r.Has_Deed_Recorded;
            d.FHA = r.fha;
            d.FannieMae = r.fannie;
            d.FreddieMac = r.Freddie_Mac_;
            d.Servicer = r.servicer;
            d.ForeclosureIndexNum = r.LP_Index___Num_LP_Index___Num;
            d.ForeclosureNote = r.notes_LP_Index___Num;
            d.TaxLienCertificate = (function () {
                var total = 0.0;
                if (r.TaxLienCertificate) {
                    for (var i = 0; i < r.TaxLienCertificate.length; i++) {
                        total += Number.parseFloat(r.TaxLienCertificate[i].Amount);
                    }
                }
                return total;
            })();
            d.PropertyTaxes = r.propertyTaxes;
            d.WaterCharges = r.waterCharges;
            d.HPDCharges = r.Open_Amount_HPD_Charges_Not_Paid_Transferred;
            d.ECBDOBViolations = r.Amount_ECB_Tickets;
            d.DOBCivilPenalty = r.dobWebsites;
            d.PersonalJudgements = r.Amount_Personal_Judgments;
            d.HPDJudgements = r.HPDjudgementAmount;
            d.IRSNYSTaxLiens = (function () {
                var total = 0.0;

                if (r.irsTaxLien)
                    total += Number.parseFloat(r.irsTaxLien);
                if (r.Amount_NYS_Tax_Lien)
                    total += Number.parseFloat(r.Amount_NYS_Tax_Lien);

                return total;

            })();
            d.VacateOrder = r.has_Vacate_Order_Vacate_Order;
            d.RelocationLien = (function () {
                if (r.has_Vacate_Order_Vacate_Order)
                    return r.Amount_Vacate_Order;
            })()

        }



        if (d.leadsInfo) {
            d.PropertyAddress = d.leadsInfo.PropertyAddress.trim();
            d.TaxClass = d.leadsInfo.TaxClass.trim();
            d.BuildingDimension = d.leadsInfo.BuildingDem.trim();
            d.LotSize = d.leadsInfo.Lot;
            d.Zoning = d.leadsInfo.Zoning.trim();
        }
    }


    return Underwriter;

}]);