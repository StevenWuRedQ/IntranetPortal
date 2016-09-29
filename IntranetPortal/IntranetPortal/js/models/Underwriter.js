angular.module('PortalApp')
    .factory('ptUnderwriter', ['$http', 'ptBaseResource', 'DocSearch', 'LeadsInfo', function ($http, ptBaseResource, DocSearch, LeadsInfo) {

        var Underwriter = ptBaseResource('underwriter', 'BBLE', null, {});

        /* constructor for empty model */
        var _Model = function () {

            this.BestCaseScenario = {};
            this.CarryingCosts = {};
            this.CarryingCosts = {};
            this.CashScenario = {};
            this.ClosingCost = {};
            this.Construction = {};
            this.DealCosts = {
                MoneySpent: 0.0,
                HOI: 0.0,
                COSTermination: 0.0,
                AgentCommission: 0.0
            }
            this.DealExpenses = {};
            this.FlipCalculation = {};
            this.FlipScenario = {};
            this.HOI = {};
            this.HOIBestCase = {};
            this.InsurancePremium = {};
            this.Liens = {};
            this.LienCosts = {
                TaxLienCertificate: 0.0,
                PropertyTaxes: 0.0,
                WaterCharges: 0.0,
                HPDCharges: 0.0,
                ECBDOBViolations: 0.0,
                DOBCivilPenalty: 0.0,
                PersonalJudgements: 0.0,
                HPDJudgements: 0.0,
                IRSNYSTaxLiens: 0.0,
                VacateOrder: undefined,
                RelocationLien: 0.0,
                RelocationLienDate: undefined
            }
            this.LienInfo = {
                FirstMortgage: 0.0,
                SecondMortgage: 0.0,
                COSRecorded: false,
                DeedRecorded: false,
                OtherLiens: undefined,
                FHA: false,
                FannieMae: false,
                FreddieMac: false,
                Servicer: undefined,
                ForeclosureIndexNum: undefined,
                ForeclosureStatus: undefined,
                ForeclosureNote: undefined,
                AuctionDate: undefined,
                DefaultDate: undefined,
                CurrentPayoff: undefined,
                PayoffDate: undefined,
                CurrentSSValue: 0.0
            }
            this.LoanCosts = {};
            this.LoanScenario = {};
            this.LoanTerms = {};
            this.MinimumBaselineScenario = {};
            this.MoneyFactor = {};
            this.Others = {};
            this.PropertyInfo = {
                PropertyAddress: undefined,
                TaxClass: undefined,
                BuildingDimension: undefined,
                LotSize: undefined,
                Zoning: undefined,
                ActualNumOfUnits: 0,
                PropertyTaxYear: 0.0,
                OccupancyStatus: undefined,
                SellerOccupied: false,
                NumOfTenants: 0,
            }
            this.RehabInfo = {
                AverageLowValue: 0.0,
                RenovatedValue: 0.0,
                RepairBid: 0.0,
                DealTimeMonths: 0,
                SalesCommission: undefined,
                DealROICash: undefined
            }
            this.RentalInfo = {
                DeedPurchase: 0.0,
                CurrentlyRented: undefined,
                RepairBidTotal: 0.0,
                NumOfUnits: 0,
                MarketRentTotal: 0.0,
                RentalTime: 0
            }
            this.RentalModel = {};
            this.Resale = {};

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
            var data = this.create();
            if (bble) {
                var _data = Underwriter.get({ BBLE: bble.trim() }, function () {
                    _.default(_data, data);
                    if (isImport) {
                        data.docSearch = DocSearch.get({ BBLE: bble.trim() }, function () {
                            data.leadsInfo = LeadsInfo.get({ BBLE: bble.trim() }, function () {
                                mapData(data);
                            })

                        });
                    }

                })
                return _data;
            }
            return data;
        }

        /* map rule from docsearch and leadsinfo to underwriting */
        function mapData(d) {
            // map to docsearch if we have data
            if (d.docSearch && d.docSearch.LeadResearch) {

                var r = d.docSearch.LeadResearch;

                d.PropertyInfo.PropertyTaxYear = r.leadsProperty_Taxes_per_YR_Property_Taxes_Due;
                d.LienInfo.FirstMortgage = r.mortgageAmount;
                d.LienInfo.SecondMortgage = r.secondMortgageAmount;
                d.LienInfo.COSRecorded = r.Has_COS_Recorded;
                d.LienInfo.DeedRecorded = r.Has_Deed_Recorded;
                d.LienInfo.FHA = r.fha;
                d.LienInfo.FannieMae = r.fannie;
                d.LienInfo.FreddieMac = r.Freddie_Mac_;
                d.LienInfo.Servicer = r.servicer;
                d.LienInfo.ForeclosureIndexNum = r.LP_Index___Num_LP_Index___Num;
                d.LienInfo.ForeclosureNote = r.notes_LP_Index___Num;
                d.LienCosts.TaxLienCertificate = (function () {
                    var total = 0.0;
                    if (r.TaxLienCertificate) {
                        for (var i = 0; i < r.TaxLienCertificate.length; i++) {
                            total += Number.parseFloat(r.TaxLienCertificate[i].Amount);
                        }
                    }
                    return total;
                })();
                d.LienCosts.PropertyTaxes = r.propertyTaxes;
                d.LienCosts.WaterCharges = r.waterCharges;
                d.LienCosts.HPDCharges = r.Open_Amount_HPD_Charges_Not_Paid_Transferred;
                d.LienCosts.ECBDOBViolations = r.Amount_ECB_Tickets;
                d.LienCosts.DOBCivilPenalty = r.dobWebsites;
                d.LienCosts.PersonalJudgements = r.Amount_Personal_Judgments;
                d.LienCosts.HPDJudgements = r.HPDjudgementAmount;
                d.LienCosts.IRSNYSTaxLiens = (function () {
                    var total = 0.0;

                    if (r.irsTaxLien)
                        total += Number.parseFloat(r.irsTaxLien);
                    if (r.Amount_NYS_Tax_Lien)
                        total += Number.parseFloat(r.Amount_NYS_Tax_Lien);

                    return total;

                })();
                d.LienCosts.VacateOrder = r.has_Vacate_Order_Vacate_Order;
                d.LienCosts.RelocationLien = (function () {
                    if (r.has_Vacate_Order_Vacate_Order)
                        return r.Amount_Vacate_Order;
                })()

            }
            // map to Leads Info if we have data
            if (d.leadsInfo) {
                d.PropertyInfo.PropertyAddress = d.leadsInfo.PropertyAddress.trim();
                d.PropertyInfo.TaxClass = d.leadsInfo.TaxClass.trim();
                d.PropertyInfo.BuildingDimension = d.leadsInfo.BuildingDem.trim();
                d.PropertyInfo.LotSize = d.leadsInfo.Lot;
                d.PropertyInfo.Zoning = d.leadsInfo.Zoning.trim();
            }
        }

        // helper Functions
        Underwriter.insurancePolicyCalculation = function (v1, policyCol, cosCol, fromCol, toCol) {
            if (v1 < fromCol[0]) {
                return 402;
            } else {
                if (v1 <= toCol[0])
                    return (v1 - fromCol[0]) * policyCol[0];
                else {
                    if (v1 <= toCol[1])
                        return (v1 - fromCol[1]) * policyCol[1] + cosCol[1];
                    else {
                        if (v1 <= toCol[2])
                            return (v1 - fromCol[2]) * policyCol[2] + cosCol[1];
                        else {
                            if (v1 <= toCol[3])
                                return (v1 - fromCol[3]) * policyCol[3] + cosCol[2];
                            else {
                                if (v1 <= toCol[4])
                                    return (v1 - fromCol[4]) * policyCol[4] + cosCol[3];
                                else {
                                    if (v1 <= toCol[5])
                                        return (v1 - fromCol[5]) * policyCol[5] + cosCol[4];
                                    else {
                                        if (v1 <= toCol[6])
                                            return (v1 - fromCol[6]) * policyCol[6] + cosCol[5];
                                        else {
                                            if (v1 <= toCol[7])
                                                return (v1 - fromCol[7]) * policyCol[7] + cosCol[6];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Constructor!!! for RentalModel
        Underwriter.RentalHelper = function (isRented, rentalTime, model) {
            var i, j, k = 0, temp = model.NetMontlyRent;
            this._model = [];
            this._model[k] = {
                Month: k + 1,
                Rent: 0,
                Interest: -(model.TotalUpfront * model.CostOfMoneyRate / 12.0)
            };
            this._model[k].Total = -(model.TotalUpfront - this._model[k].Interest);
            k++;

            for (; k < 3; k++) {
                this._model[k] = {
                    Month: k + 1,
                    Rent: isRented ? 0 : model.NetMontlyRent,
                    Interest: this._model[k - 1].Total * model.CostOfMoneyRate / 12.0
                }
                this._model[k].Total = this._model[k - 1].Total + this._model[k].Interest + this._model[k].Rent;
            }

            for (i = 0; i < 7; i++, temp = temp * 1.02) {
                for (j = 0; j < 12; j++, k++) {
                    this._model[k] = {
                        Month: k + 1,
                        Rent: temp,
                    }
                    if (k < 28) {
                        this._model[k].Interest = this._model[k - 1].Total < 0 ? this._model[k - 1].Total * model.CostOfMoneyRate / 12 : 0.0;
                    } else {
                        this._model[k].Interest = this._model[k - 1].Total < 0 ? this._model[k - 1].Total * 0.18 / 12 : 0.0;
                    }
                    this._model[k].Total = this._model[k - 1].Total < 0 ? this._model[k - 1].Total + this._model[k].Interest + this._model[k].Rent : this._model[k - 1].Total + this._model[k].Rent;
                }

            }

            this.costOfMoney = 0.0;

            for (i = 0; i < 60; i++) {
                this.costOfMoney += this._model[i].Interest;
            }
            this.costOfMoney = -this.costOfMoney;

            this.totalCost = model.TotalUpfront + this.costOfMoney;
            for (var m = 1 ; m < this._model.length; m++) {
                this._model[m].ROI = this._model[m].Total / this.totalCost / this._model[m].Month * 12;
            }

            this.totalMonths = 0;
            this.targetProfit = 0.0;
            for (m = 1; m < this._model.length; m++) {
                if (this._model[m].ROI > model.MinROI) {
                    this.totalMonths = this._model[m].Month;
                    this.targetProfit = this._model[m].Total;
                    break;
                }
            }
            this.totalMonths = rentalTime ? rentalTime : this.totalMonths;

            this.breakeven = 0;
            for (i = 0; i < 60; i++) {
                if (this._model[i].Total > 0) {
                    this.breakeven = this._model[i].Month;
                    break;
                }
            }

            this.ROIYear = this.targetProfit / this.totalCost / this.totalMonths * 12;
            this.ROITotal = this.targetProfit / this.totalCost;


        }

        return Underwriter;

   
    }]);