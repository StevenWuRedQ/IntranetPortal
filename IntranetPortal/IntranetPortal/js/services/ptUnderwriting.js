/***
 *  Author: Shaopeng Zhang
 *  Date: 2016/11/01
 *  Description:
 *  Updates:
 ***/
angular.module("PortalApp").factory("ptUnderwriting",
    ["$http", "ptCom", function ($http, ptCom) {
        var underwriting = {};
        var underwritingFactory = {
            UnderwritingModel: function () {
                this.PropertyInfo = {
                    PropertyType: undefined,
                    PropertyAddress: "",
                    CurrentOwner: "",
                    TaxClass: "",
                    LotSize: "",
                    BuildingDimension: "",
                    Zoning: "",
                    FARActual: 0.0,
                    FARMax: 0.0,
                    PropertyTaxYear: 0.0,
                    ActualNumOfUnits: 0,
                    OccupancyStatus: undefined,
                    SellerOccupied: false,
                    NumOfTenants: 0
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
                    SalesCommission: 0.05,
                    DealROICash: 0.35
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
                this.RentalInfo = {
                    DeedPurchase: 0.0,
                    CurrentlyRented: false,
                    RepairBidTotal: 0.0,
                    NumOfUnits: 0,
                    MarketRentTotal: 0.0,
                    RentalTime: 0
                };

                this.MinimumBaselineScenario = {};
                this.BestCaseScenario = {};
                this.Summary = {};
                this.CashScenario = {};
                this.LoanScenario = {};
                this.FlipScenario = {};
                this.RentalModel = {};
            },
            build: function () {
                var data = new this.UnderwritingModel();
                return data;
            }
        };
        var proxy;
        $.connection.hub.url = "http://localhost:8887/signalr";
        $.connection.logging = true;
        var init = function () {
            $.connection.hub.start().done(function() {
                proxy = $.connection.underwritingServiceHub;
            })
        };
        init();
        $.connection.hub.disconnected(function () {
            setTimeout(init, 5000); // Restart connection after 5 seconds.
        });
        var tryGetProxy = function () {
            var dfd = $.Deferred();
            if (proxy) {
                dfd.resolve(proxy);
            } else {
                var proxyInterval = setInterval(function () {
                    if (proxy) {
                        dfd.resolve(proxy);
                        clearInterval(proxyInterval);
                    }
                }, 500);
                setTimeout(function () {
                    clearInterval(proxyInterval);
                    dfd.reject();
                },
                    2000);
            }
            return dfd.promise();
        }
        /**
         * load underwriting from database, if not loaded, use factory new one and import infomation from portal
         * @param: bble // if no present, only create new model from factory
         **/
        underwriting.new = function () {
            var newData = underwritingFactory.build();
            return newData;
        }
        underwriting.load = function (bble) {
            if (bble) {
                return tryGetProxy().then(function (proxy) {
                    return proxy.server.getUnderwritingByBBLE(bble);
                })
            }
        }
        underwriting.save = function (data) {
            var username = ptCom.getCurrentUser();
            return tryGetProxy().then(function (proxy) {
                return proxy.server.postUnderwriting(data, username);
            });
        }
        underwriting.importData = function (d) {
            if (d.docSearch && d.docSearch.LeadResearch) {
                var r = d.docSearch.LeadResearch;
                d.PropertyInfo.PropertyTaxYear = r.leadsProperty_Taxes_per_YR_Property_Taxes_Due || 0.0;
                d.LienInfo.FirstMortgage = r.mortgageAmount || 0.0;
                d.LienInfo.SecondMortgage = r.secondMortgageAmount || 0.0;
                d.LienInfo.COSRecorded = r.Has_COS_Recorded || false;
                d.LienInfo.DeedRecorded = r.Has_Deed_Recorded || false;
                d.LienInfo.FHA = r.fha || false;
                d.LienInfo.FannieMae = r.fannie || false;
                d.LienInfo.FreddieMac = r.Freddie_Mac_ || false;
                d.LienInfo.Servicer = r.servicer;
                d.LienInfo.ForeclosureIndexNum = r.LP_Index___Num_LP_Index___Num;
                d.LienInfo.ForeclosureNote = r.notes_LP_Index___Num;
                d.LienCosts.TaxLienCertificate = (function () {
                    var total = 0.0;
                    if (r.TaxLienCertificate) {
                        for (var i = 0; i < r.TaxLienCertificate.length; i++) {
                            total += parseFloat(r.TaxLienCertificate[i].Amount);
                        }
                    }
                    return total;
                })();
                d.LienCosts.PropertyTaxes = r.propertyTaxes || 0.0;
                d.LienCosts.WaterCharges = r.waterCharges || 0.0;
                d.LienCosts.HPDCharges = r.Open_Amount_HPD_Charges_Not_Paid_Transferred || 0.0;
                d.LienCosts.ECBCityPay = r.Amount_ECB_Tickets || 0.0;
                d.LienCosts.DOBCivilPenalty = r.dobWebsites || 0.0;
                d.LienCosts.PersonalJudgements = r.Amount_Personal_Judgments || 0.0;
                d.LienCosts.HPDJudgements = r.HPDjudgementAmount || 0.0;
                d.LienCosts.NYSTaxWarrants = r.Amount_NYS_Tax_Lien || 0.0;
                d.LienCosts.FederalTaxLien = r.irsTaxLien || 0.0;
                d.LienCosts.VacateOrder = r.has_Vacate_Order_Vacate_Order || false;
                d.LienCosts.RelocationLien = (function () {
                    if (r.has_Vacate_Order_Vacate_Order)
                        return parseFloat(r.Amount_Vacate_Order) || 0.0;
                })();
            }
            if (d.leadsInfo) {
                d.PropertyInfo.PropertyAddress = d.leadsInfo.PropertyAddress.trim();
                d.PropertyInfo.CurrentOwner = d.leadsInfo.Owner.trim();
                d.PropertyInfo.TaxClass = d.leadsInfo.TaxClass.trim();
                d.PropertyInfo.LotSize = d.leadsInfo.LotDem.trim();
                d.PropertyInfo.BuildingDimension = d.leadsInfo.BuildingDem.trim();
                d.PropertyInfo.Zoning = d.leadsInfo.Zoning.trim();
                d.PropertyInfo.FARActual = d.leadsInfo.ActualFar;
                d.PropertyInfo.FARMax = d.leadsInfo.MaxFar;
            }
        };
        underwriting.archive = function (data, msg) {
            var username = ptCom.getCurrentUser();
            return tryGetProxy().then(function(proxy) {
                return proxy.server.postArchive(data, msg, username);
            });
        }
        underwriting.loadArchivedList = function (bble) {
            return tryGetProxy().then(function (proxy) {
                return proxy.server.getArchivedListByBBLE(bble);
            });
        }
        underwriting.loadArchived = function (id) {
            return tryGetProxy().then(function(proxy) {
                return proxy.server.getArchivedByID(id);
            });
        }
        underwriting.calculate = function (data) {
            tryGetProxy().then(function(proxy) {
                proxy.server.postSingleJob(data).done(function(output) {
                    data.MinimumBaselineScenario = output.MinimumBaselineScenario;
                    data.BestCaseScenario = output.BestCaseScenario;
                    data.Summary = output.Summary;
                    data.CashScenario = output.CashScenario;
                    data.LoanScenario = output.LoanScenario;
                    data.FlipScenario = output.FlipScenario;
                    data.RentalModel = output.RentalModel;
                });
            });
        }
        return underwriting;
    }]);