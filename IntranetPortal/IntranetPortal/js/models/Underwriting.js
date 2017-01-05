/***
 *  Author: Shaopeng Zhang
 *  Date: 2016/11/01
 *  Description:
 *  Updates:
 ***/
angular.module("PortalApp")
    .factory("ptUnderwriting",
    [
        "$http", "ptBaseResource", "DocSearch", "LeadsInfo", function($http, ptBaseResource, DocSearch, LeadsInfo) {

            var underwriting = ptBaseResource("underwriter", "BBLE", null, {});
            /* Factory for empty model */
            var underwritingFactory = {
                UnderwritingModel: function() {
                    this.PropertyInfo = {
                        PropertyAddress: "",
                        CurrentOwner: "",
                        TaxClass: "",
                        LotSize: "",
                        BuildingDimension: "",
                        Zoning: "",
                        PropertyTaxYear: 0.0,
                        ActualNumOfUnits: 0,
                        OccupancyStatus: undefined,
                        SellerOccupied: false,
                        NumOfTenants: 0,
                    };
                    this.DealCosts = {
                        MoneySpent: 0.0,
                        HAFA: false,
                        HOI: 0.0,
                        HOIRatio: 0.0,
                        COSTermination: 0.0,
                        AgentCommission: 0.0
                    };
                    this.RehabInfo = {
                        AverageLowValue: 0.0,
                        RenovatedValue: 0.0,
                        RepairBid: 0.0,
                        NeedsPlans: false,
                        DealTimeMonths: 0,
                        SalesCommission: 0.0,
                        DealROICash: 0.0
                    };
                    this.LienInfo = {
                        FirstMortgage: 0.0,
                        SecondMortgage: 0.0,
                        COSRecorded: false,
                        DeedRecorded: false,
                        OtherLiens: undefined,
                        LisPendens: false,
                        FHA: false,
                        FannieMae: false,
                        FreddieMac: false,
                        Servicer: "",
                        ForeclosureIndexNum: "",
                        ForeclosureStatus: undefined,
                        ForeclosureNote: "",
                        AuctionDate: undefined,
                        DefaultDate: undefined,
                        CurrentPayoff: 0.0,
                        PayoffDate: undefined,
                        CurrentSSValue: 0.0
                    };
                    this.LienCosts = {
                        TaxLienCertificate: 0.0,
                        PropertyTaxes: 0.0,
                        WaterCharges: 0.0,
                        ECBCityPay: 0.0,
                        DOBCivilPenalty: 0.0,
                        HPDCharges: 0.0,
                        HPDJudgements: 0.0,
                        PersonalJudgements: 0.0,
                        NYSTaxWarrants: 0.0,
                        FederalTaxLien: 0.0,
                        SidewalkLiens: false,
                        ParkingViolation: 0.0,
                        TransitAuthority: 0.0,
                        VacateOrder: false,
                        RelocationLien: 0.0,
                        RelocationLienDate: undefined
                    };
                    this.MinimumBaselineScenario = {};
                    this.BestCaseScenario = {};
                    this.Others = {};
                    this.CashScenario = {};
                    this.LoanScenario = {};
                    this.FlipScenario = {};
                    this.RentalInfo = {
                        DeedPurchase: 0.0,
                        CurrentlyRented: false,
                        RepairBidTotal: 0.0,
                        NumOfUnits: 0,
                        MarketRentTotal: 0.0,
                        RentalTime: 0
                    };
                    this.RentalModel = {};
                    this.Liens = {};
                    this.DealExpenses = {};
                    this.ClosingCost = {};
                    this.Construction = {};
                    this.CarryingCosts = {
                        RETaxs: 0.0,
                        Utilities: 0,
                        Insurance: 0,
                        Sums: 0
                    };
                    this.Resale = {};
                    this.LoanTerms = {};
                    this.LoanCosts = {};
                    this.FlipCalculation = {};
                    this.MoneyFactor = {};
                    this.HOI = {};
                    this.HOIBestCase = {};
                    this.InsurancePremium = {};

                },
                build: function() {
                    var data = new this.UnderwritingModel();
                    return data;
                }
            };

            /**
             * load underwriting from database, if not loaded, use factory new one and import infomation from portal
             * @param: bble // if no present, only create new model from factory
             **/
            underwriting.load = function(/* optional */ bble) {
                //debugger;
                var data = underwritingFactory.build();
                underwriting.calculator.applyFixedRules(data);

                if (bble) {
                    var _data = underwriting.get({ BBLE: bble.trim() },
                        function(d) {
                            _data.BBLE = bble;
                            _.defaults(_data, data);
                            //debugger;
                            if (!_data.Id) { // data is not load from database, load data from portal
                                data.docSearch = DocSearch.get({ BBLE: bble.trim() },
                                    function() {
                                        data.leadsInfo = LeadsInfo.get({ BBLE: bble.trim() },
                                            function() {
                                                underwriting.calculator.importData(data);
                                            });
                                    });
                            }

                        });
                    return _data;
                }
                return data;
            };
            underwriting.save = function(data) {
                return $http({
                    method: "POST",
                    url: "/api/underwriter",
                    data: data,
                    headers: {
                        'Content-Type': "application/json"
                    }

                });
            };
            underwriting.archive = function(data, msg) {
                return $http({
                    method: "POST",
                    url: "/api/underwriter/archive",
                    data: [data, msg]
                });
            };
            underwriting.loadArchivedList = function(bble) {
                return $http({
                    method: "GET",
                    url: "/api/underwriter/archived/" + bble
                });
            };
            underwriting.loadArchived = function(id) {
                return $http({
                    method: "GET",
                    url: "/api/underwriter/archived/id/" + id
                });
            };
            return underwriting;
        }
    ]);