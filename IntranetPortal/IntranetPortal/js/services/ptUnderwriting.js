/***
 *  Author: Shaopeng Zhang
 *  Date: 2016/11/01
 *  Description:
 *  Updates: 
 ***/
angular.module("PortalApp").factory("ptUnderwriting", ["$http", "ptCom", '$q', 'DocSearch', 'LeadsInfo',
    function ($http, ptCom, $q, DocSearch, LeadsInfo) {
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

        var underwriting = {
            proxy: undefined,
            serviceURL: undefined,
            inited: false,
            getServiceURL: function () {
                var that = this;
                if (this.serviceURL) return this.serviceURL;
                $http({
                    url: "/Webconfig.txt",
                    method: "GET"
                }).then(function (d) {
                    that.serviceURL = d.data["UnderwritingServiceServerClient"] + "/signalr";
                })
            },
            init: function () {
                var that = this;
                if (!$.connection.logging) {
                    $.connection.logging = true;
                    $.connection.hub.disconnected(function () {
                        setTimeout(this.init, 5000); // Restart connection after 5 seconds.
                    });
                };
                this.getServiceURL();
                if (!this.serviceURL) return;
                $.connection.hub.url = this.serviceURL;
                if (this.proxy) return;
                $.connection.hub.start().done(function () {
                    that.proxy = $.connection.underwritingServiceHub;
                })
            },
            // try to a proxy incase signalr is reconnecting.        
            tryGetProxy: function () {
                debugger;
                var that = this;
                if (!this.inited) this.tryInit();
                return $q(function (resolve, reject) {
                    if (that.proxy) {
                        resolve(that.proxy);
                    } else {
                        var proxyInterval = setInterval(function () {
                            if (that.proxy) {
                                resolve(that.proxy);
                                clearInterval(proxyInterval);
                            }
                        }, 500);
                        setTimeout(function () {
                            clearInterval(proxyInterval);
                            reject("Cannot get proxy.");
                        }, 2000);
                    }
                });
            },
            tryInit: function () {
                if (!$.connection) return;
                var that = this;
                that.inited = true;
                var proxyInterval = setInterval(function () {
                    if (that.proxy) {
                        console.log("Init proxy successfully");
                        clearInterval(proxyInterval);
                    } else {
                        that.init();
                    }
                }, 100);
                setTimeout(function () {
                    if (!that.proxy) console.log("Fail to init proxy");
                    clearInterval(proxyInterval);
                }, 2000);
            }
        }

        underwriting.tryInit();

        // Load underwriting from database, if not loaded, use factory new one and import infomation from portal
        // @param bble: if no present, only create new model from factory
        underwriting.new = function () {
            var newData = underwritingFactory.build();
            return newData;
        }
        underwriting.load = function (bble) {
            if (bble) {
                return this.tryGetProxy().then(function (proxy) {
                    return proxy.server.getUnderwritingByBBLE(bble);
                })
            }
        }
        underwriting.save = function (data) {
            var username = ptCom.getCurrentUser();
            return this.tryGetProxy().then(function (proxy) {
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
            return this.tryGetProxy().then(function (proxy) {
                return proxy.server.postArchive(data, msg, username);
            });
        }
        underwriting.loadArchivedList = function (bble) {
            return this.tryGetProxy().then(function (proxy) {
                return proxy.server.getArchivedListByBBLE(bble);
            });
        }
        underwriting.loadArchived = function (id) {
            return this.tryGetProxy().then(function (proxy) {
                return proxy.server.getArchivedByID(id);
            });
        }
        // remote calculate underwriting throught signalr websocket.
        underwriting.calculate = function (data, isDebug) {
            if (isDebug) return this.tryGetProxy().then(function (proxy) { return proxy.server.debugRule(data) });
            return this.tryGetProxy().then(function (proxy) { return proxy.server.postSingleJob(data) });
        };
        // change underwrting status. @param statusNote is must 
        underwriting.changeStatus = function (bble, status, statusNote) {
            var username = ptCom.getCurrentUser();
            return this.tryGetProxy().then(function (proxy) {
                return proxy.server.changeStatus(bble, status, statusNote, username);
            })
        }
        underwriting.tryCreate = function (bble) {
            var that = this;
            return $q(function (resolve, reject) {
                if (!bble) reject("BBLE cannot be blank.");
                //var username = ptCom.getCurrentUser();
                var newData = underwriting.new();
                newData.BBLE = bble;
                newData.Status = 1;
                DocSearch.get({ BBLE: bble }).$promise.then(function (search) {
                    newData.docSearch = search;
                    LeadsInfo.get({ BBLE: bble.trim() }).$promise.then(function (leadsInfo) {
                        newData.leadsInfo = leadsInfo;
                        underwriting.importData(newData);
                        that.tryGetProxy().then(function (proxy) {
                            proxy.server.tryCreate(newData).then(function (data) {
                                resolve(data);
                            });
                        }, function (e) {
                            reject(e);
                        })
                    }).catch(function (e) {
                        reject(e);
                    });
                });
            });
        }

        var _UnderwritingModel = function () {
            this.Grade = "0",
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
                    NumOfTenants: 0,
                    Landmark: false,
                    SRO: false
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
                DealTimeMonths: 6,
                SalesCommission: 0.05,
                DealROICash: 0.35
            };
            this.LienInfo = {
                FirstMortgage: 0.0,
                SecondMortgage: 0.0,
                COSRecorded: false,
                DeedRecorded: false,
                OtherLiens: 1,
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
                IsRelocationLien: false,
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
            this.Summary = {
                MaximumLienPayoff: 0.0,
                MaximumSSPrice: 0.0,
                MaxHOI: 0.0
            };
            this.CashScenario = {};
            this.LoanScenario = {};
            this.FlipScenario = {
                FlipProfit: 0.0
            };
            this.RentalModel = {};
        };
        underwriting.create = function () {
            var data = new _UnderwritingModel();
            return data;
        };
        return underwriting;
    }]);