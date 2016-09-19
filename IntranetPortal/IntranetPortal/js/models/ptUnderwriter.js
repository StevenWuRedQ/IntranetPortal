angular.module('PortalApp').factory('ptUnderwriter', function ($http) {

    var Model = function() {
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

    }

    return {
        createNew: function() {
            return new Model();
        }

    }

});

