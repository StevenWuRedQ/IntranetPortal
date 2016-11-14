/***
 *  Author: Shaopeng Zhang
 *  Date: 2016/11/01
 *  Description:
 *  Updates:
 ***/
angular.module('PortalApp')
    .factory('ptUnderwriter', ['$http', 'ptBaseResource', 'DocSearch', 'LeadsInfo', function ($http, ptBaseResource, DocSearch, LeadsInfo) {

        var underwriter = ptBaseResource('underwriter', 'BBLE', null, {});

        /* Factory for empty model */
        var underwritingFactory = {
            UnderwritingModel: function () {
                this.PropertyInfo = {
                    PropertyAddress: '',
                    CurrentOwner: '',
                    TaxClass: '',
                    LotSize: '',
                    BuildingDimension: '',
                    Zoning: '',
                    PropertyTaxYear: 0.0,
                    ActualNumOfUnits: 0,
                    OccupancyStatus: undefined,
                    SellerOccupied: false,
                    NumOfTenants: 0,
                }
                this.DealCosts = {
                    MoneySpent: 0.0,
                    HAFA: false,
                    HOI: 0.0,
                    HOIRatio: 0.0,
                    COSTermination: 0.0,
                    AgentCommission: 0.0
                }
                this.RehabInfo = {
                    AverageLowValue: 0.0,
                    RenovatedValue: 0.0,
                    RepairBid: 0.0,
                    NeedsPlans: false,
                    DealTimeMonths: 0,
                    SalesCommission: 0.0,
                    DealROICash: 0.0
                }
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
                    Servicer: '',
                    ForeclosureIndexNum: '',
                    ForeclosureStatus: undefined,
                    ForeclosureNote: '',
                    AuctionDate: undefined,
                    DefaultDate: undefined,
                    CurrentPayoff: 0.0,
                    PayoffDate: undefined,
                    CurrentSSValue: 0.0
                }
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
                }
                this.MinimumBaselineScenario = {};
                this.BestCaseScenario = {
                };
                // this.FlipScenario = {};
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
                }
                this.RentalModel = {};


                this.Liens = {};
                this.DealExpenses = {};
                this.ClosingCost = {};
                this.Construction = {}; //Improvements
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
            build: function () {
                var data = new this.UnderwritingModel();
                return data;
            }
        }

        underwriter.calculator = (function () {

            var insurancePolicyCalculation = function (v1, policyCol, cosCol, fromCol, toCol) {
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

            /**
             * helper function to calculate rental model
             */
            var RentalHelper = function (isRented, rentalTime, model) {
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

            /**
             * map portal existing data onto new created underwriting model
             */
            var importData = function (d) {
                // map to docsearch if we have data
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
                    d.LienCosts.NYSTaxWarrants = r.Amount_NYS_Tax_Lien || 0.0; // added: 2016/11/1
                    d.LienCosts.FederalTaxLien = r.irsTaxLien || 0.0; // added: 2016/11/1
                    d.LienCosts.VacateOrder = r.has_Vacate_Order_Vacate_Order || false;
                    d.LienCosts.RelocationLien = (function () {
                        if (r.has_Vacate_Order_Vacate_Order)
                            return parseFloat(r.Amount_Vacate_Order) || 0.0;
                    })()
                    // removed : 2016/11/01
                    // d.LienCosts.IRSNYSTaxLiens = (function () {
                    //    var total = 0.0;
                    //    if (r.irsTaxLien)
                    //        total += parseFloat(r.irsTaxLien);
                    //    if (r.Amount_NYS_Tax_Lien)
                    //        total += parseFloat(r.Amount_NYS_Tax_Lien);
                    //    return total;
                    // })();

                }
                // map to Leads Info if we have data
                if (d.leadsInfo) {
                    // debugger;
                    d.PropertyInfo.PropertyAddress = d.leadsInfo.PropertyAddress;
                    d.PropertyInfo.CurrentOwner = d.leadsInfo.Owner;
                    d.PropertyInfo.TaxClass = d.leadsInfo.TaxClass;
                    d.PropertyInfo.LotSize = d.leadsInfo.LotDem;
                    d.PropertyInfo.BuildingDimension = d.leadsInfo.BuildingDem;
                    d.PropertyInfo.Zoning = d.leadsInfo.Zoning;
                    d.PropertyInfo.FARActual = d.leadsInfo.ActualFar;
                    d.PropertyInfo.FARMax = d.leadsInfo.MaxFar;
                }
            }

            /**
             * initialized fixed parameter in underwriting model
             */
            var applyFixedRules = function (d) {

                d.RehabInfo.SalesCommission = 0.05;
                d.RehabInfo.DealROICash = 0.35;
                // Insurance Premium
                d.InsurancePremium.From = [35001, 50001, 100001, 500001, 1000001, 5000001, 10000001, 15000001];
                d.InsurancePremium.To = [50000, 100000, 500000, 1000000, 5000000, 10000000, 15000000];
                d.InsurancePremium.OwnersPolicyRate = [.00667, .00543, .00436, .00398, .00366, .00325, .00307, .00276];
                d.InsurancePremium.LoanPolicyRate = [0.00555, 0.00454, 0.00364, 0.00331, 0.00305, 0.00271, 0.00255, 0.00231];
                d.InsurancePremium.CostOwnersPolicy = _.zip(d.InsurancePremium.From,
                                                            d.InsurancePremium.To,
                                                            d.InsurancePremium.OwnersPolicyRate).reduce(function (cum, v) {
                                                                var l = cum.length;
                                                                cum[l - 1] = (v[1] - v[0]) * v[2] + cum[l - 1];
                                                                cum[l] = cum[l - 1];
                                                                return cum;
                                                            }, [402])

                d.InsurancePremium.CostLoanPolicy = _.zip(d.InsurancePremium.From,
                                                          d.InsurancePremium.To,
                                                          d.InsurancePremium.LoanPolicyRate).reduce(function (cum, v) {
                                                              var l = cum.length;
                                                              cum[l - 1] = (v[1] - v[0]) * v[2] + cum[l - 1];
                                                              cum[l] = cum[l - 1];
                                                              return cum;
                                                          }, [344])
                // Flip Calculation
                d.FlipCalculation.FlipROI = 0.15;
                // Money Factor
                d.MoneyFactor.CostOfMoney = 0.0;
                d.MoneyFactor.InterestOnMoney = 0.18;
                // Liens
                d.Liens.LienPayoffsSettlement = 1.0
                d.Liens.TaxLienCertificateSettlement = 0.09 / 12;
                d.Liens.WaterChargesSettlement = 1.0;
                d.Liens.PropertyTaxesSettlement = 1.0;
                d.Liens.ECBCityPaySettlement = 1.0;
                d.Liens.DOBCivilPenaltiesSettlement = 1.0;
                d.Liens.HPDChargesSettlement = 1.0;

                d.Liens.HPDJudgementsSettlement = 0.15;
                d.Liens.PersonalJudgementsSettlement = 0.40;
                d.Liens.ParkingViolationSettlement = 1.0;
                d.Liens.TransitAuthoritySettlement = 1.0;
                d.Liens.RelocationLienSettlement = .09 / 365;

                // d.Liens.ECBDOBViolationsSettlement = 0.35; removed: 2016/10/31

                // Closing Costs
                d.ClosingCost.TitleBill = 1200.00;
                d.ClosingCost.BuyerAttorney = 1250.00;
                // Resale
                d.Resale.Concession = 0.0;
                d.Resale.Attorney = 1250.0;
                d.Resale.NDC = 500;
                // LoanTerms
                d.LoanTerms.LoanRate = 0.12;
                d.LoanTerms.LoanPoints = 2;
                d.LoanTerms.LoanTermMonths = 12;
                d.LoanTerms.LTV = 0.6;
                // HOI
                d.HOI.Value = 0.25;
                //Rental Model
                d.RentalModel.CostOfMoneyRate = 0.16;
                d.RentalModel.MinROI = 0.18;
                d.RentalModel.Insurance = 85.0;

            };

            /**
            * pre-defined rules to rebuild underwrting model
            * @param d: data represent underwriting model
            */
            var applyRule = function (d) {
                //debugger;
                var float = function (data) {
                    if (data)
                        return parseFloat(data);
                    else
                        return 0.0;
                }
                var int = function (data) {
                    if (data)
                        return parseInt(data);
                    else
                        return 0;
                }

                /**
                 * PropertyInfo 
                 * 1:residential
                 * 2: nonresidential
                 */
                d.PropertyInfo.PropertyType = (function () { return /.*(A|B|C0|21|R).*/.exec(d.PropertyInfo.TaxClass) ? 1 : 2 })();

                // Liens
                d.Liens.TaxLienCertificate = float(d.LienCosts.TaxLienCertificate) * (1.0 + d.Liens.TaxLienCertificateSettlement * float(d.RehabInfo.DealTimeMonths));
                d.Liens.PropertyTaxes = float(d.LienCosts.PropertyTaxes) * d.Liens.PropertyTaxesSettlement;
                d.Liens.WaterCharges = float(d.LienCosts.WaterCharges) * d.Liens.WaterChargesSettlement;
                d.Liens.ECBCityPay = float(d.LienCosts.ECBCityPay) * d.Liens.ECBCityPaySettlement;
                d.Liens.DOBCivilPenalties = float(d.LienCosts.DOBCivilPenalty) * d.Liens.DOBCivilPenaltiesSettlement;
                d.Liens.HPDCharges = float(d.LienCosts.HPDCharges) * d.Liens.HPDChargesSettlement;
                d.Liens.HPDJudgements = float(d.LienCosts.HPDJudgements) * d.Liens.HPDJudgementsSettlement;
                d.Liens.PersonalJudgements = float(d.LienCosts.PersonalJudgements) * d.Liens.PersonalJudgementsSettlement;
                d.Liens.NYSTaxWarrantsSettlement = (function () {
                    return float(d.LienCosts.NYSTaxWarrantsSettlement) < 12500 ? 1.0 : 0.0
                })();
                d.Liens.NYSTaxWarrants = float(d.LienCosts.NYSTaxWarrants) * d.Liens.NYSTaxWarrantsSettlement;
                d.Liens.FederalTaxLienSettlement = (function () {
                    return float(d.LienCosts.FederalTaxLien) < 12500 ? 1.0 : 0.0
                })();
                d.Liens.FederalTaxLien = float(d.LienCosts.FederalTaxLien) * d.Liens.FederalTaxLienSettlement;
                d.Liens.ParkingViolation = float(d.LienCosts.ParkingViolation) * d.Liens.ParkingViolationSettlement;
                d.Liens.TransitAuthority = float(d.LienCosts.TransitAuthority) * d.Liens.TransitAuthoritySettlement;
                d.Liens.RelocationLien = (function () {
                    if (!d.LienCosts.RelocationLienDate)
                        return 0.0;
                    else {
                        return float(d.LienCosts.RelocationLien) * (1.0 + (moment().diff(moment(d.LienCosts.RelocationLienDate), 'days') + 180) * d.Liens.RelocationLienSettlement)
                    }
                })();
                // DealCost added: 2016/10/31
                d.DealCosts.HAFA = (d.PropertyInfo.SellerOccupied || int(d.PropertyInfo.NumOfTenants) > 0) &&
                                    !d.LienInfo.FHA &&
                                    !d.LienInfo.FannieMae &&
                                    !d.LienInfo.FreddieMac &&
                                    float(d.DealCosts.HOI) > 0.0;

                // DealExpense
                d.DealExpenses.MoneySpent = float(d.DealCosts.MoneySpent);
                d.DealExpenses.HOILienSettlement = float(d.DealCosts.HOIRatio);
                d.DealExpenses.HOILien = d.DealCosts.HAFA ? float(d.DealCosts.HOI) * d.DealExpenses.HOILienSettlement - 10000.00 : float(d.DealCosts.HOI) * d.DealExpenses.HOILienSettlement;
                d.DealExpenses.COSTermination = float(d.DealCosts.COSTermination);
                d.DealExpenses.Tenants = float(d.PropertyInfo.NumOfTenants) * 7000.00;
                d.DealExpenses.Agent = float(d.DealCosts.AgentCommission);

                // Construction(Improvement)
                d.Construction.Construction = float(d.RehabInfo.RepairBid);
                d.Construction.Architect = d.RehabInfo.NeedsPlans ? 8500 : 0;

                // CarryingCosts
                d.CarryingCosts.RETaxs = float(d.PropertyInfo.PropertyTaxYear) / 12 * float(d.RehabInfo.DealTimeMonths);
                d.CarryingCosts.Utilities = 150 * Math.pow(float(d.PropertyInfo.NumOfTenants), 2) + 400 * float(d.PropertyInfo.NumOfTenants);

                // Resale
                d.Resale.ProbableResale = float(d.RehabInfo.RenovatedValue);
                d.Resale.Commissions = d.Resale.ProbableResale * float(d.RehabInfo.SalesCommission);
                d.Resale.TransferTax = (function () {
                    var pr = parseFloat(d.Resale.ProbableResale);
                    var rate;
                    if (d.PropertyInfo.PropertyType == 1) {
                        if (pr <= 500000) {
                            rate = 0.01;
                        } else if (pr > 500000) {
                            rate = 0.01425;
                        }
                    } else {
                        if (pr <= 500000) {
                            rate = 0.01425;
                        } else if (pr > 500000) {
                            rate = 0.02625;
                        }
                    }

                    return (rate + 0.004) * pr;
                })();
                // LoanTerms
                d.LoanTerms.LoanAmount = d.Resale.ProbableResale * d.LoanTerms.LTV;
                d.CarryingCosts.Insurance = d.LoanTerms.LoanAmount / 100.0 * 0.45 / 12 * float(d.RehabInfo.DealTimeMonths);
                // LoanCosts
                d.LoanCosts.LoanClosingCost = (function () {
                    var la = d.LoanTerms.LoanAmount;
                    var rate;
                    if (d.PropertyInfo.PropertyType == 1) {
                        if (la <= 500000) {
                            rate = 0.02;

                        } else if (la > 500000) {
                            rate = 0.02125
                        }
                    } else {
                        if (la <= 500000) {
                            rate = 0.02;

                        } else if (la > 500000) {
                            rate = 0.0275;
                        }
                    }
                    return la * rate + 275 + 1500;
                })();
                d.LoanCosts.Points = d.LoanTerms.LoanAmount * d.LoanTerms.LoanPoints / 100.0;
                d.LoanCosts.LoanInterest = d.LoanTerms.LoanAmount * d.LoanTerms.LoanRate / 12.0 * float(d.RehabInfo.DealTimeMonths);

                // Sums
                d.Liens.Sums = d.Liens.TaxLienCertificate + d.Liens.PropertyTaxes + d.Liens.WaterCharges + d.Liens.ECBCityPay + d.Liens.DOBCivilPenalties + d.Liens.HPDCharges + d.Liens.HPDJudgements + d.Liens.PersonalJudgements + d.Liens.NYSTaxWarrants + d.Liens.FederalTaxLien + d.Liens.ParkingViolation + d.Liens.TransitAuthority + d.Liens.RelocationLien;
                d.DealExpenses.Sums = d.DealExpenses.MoneySpent + d.DealExpenses.HOILien + d.DealExpenses.COSTermination + d.DealExpenses.Tenants + d.DealExpenses.Agent;
                d.ClosingCost.PartialSums = d.ClosingCost.TitleBill + d.ClosingCost.BuyerAttorney;
                d.Construction.Sums = d.Construction.Construction + d.Construction.Architect;
                d.CarryingCosts.Sums = d.CarryingCosts.Insurance + d.CarryingCosts.RETaxs + d.CarryingCosts.Utilities;
                d.Resale.Sums = d.Resale.Concession + d.Resale.Commissions + d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
                d.Liens.LienPayoffs = (d.Resale.ProbableResale - (d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.PartialSums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums) - (d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.PartialSums + d.Construction.Sums + d.CarryingCosts.Sums) * float(d.RehabInfo.DealROICash)) / ((float(d.RehabInfo.DealROICash) + 1) * 1.0058);
                d.Liens.AdditonalCostsSums = d.Liens.WaterCharges + d.Liens.ECBCityPay + d.Liens.DOBCivilPenalties + d.Liens.HPDCharges + d.Liens.HPDJudgements + d.Liens.PersonalJudgements + d.Liens.NYSTaxWarrants + d.Liens.FederalTaxLien + d.Liens.ParkingViolation + d.Liens.TransitAuthority + d.Liens.RelocationLien;

                // InsurancePremium
                d.InsurancePremium.PurchasePrice = d.Liens.LienPayoffs;
                d.InsurancePremium.LoanAmountDiscounted = d.LoanTerms.LoanAmount >= d.Liens.LienPayoffs ? d.Liens.LienPayoffs : d.LoanTerms.LoanAmount;
                d.InsurancePremium.LoanAmountFullPremium = d.LoanTerms.LoanAmount - d.InsurancePremium.LoanAmountDiscounted;
                d.InsurancePremium.OwnersPolicy = insurancePolicyCalculation(d.InsurancePremium.PurchasePrice, d.InsurancePremium.OwnersPolicyRate, d.InsurancePremium.CostOwnersPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
                d.InsurancePremium.OwnersLoanPolicyDiscounted = insurancePolicyCalculation(d.InsurancePremium.LoanAmountDiscounted, d.InsurancePremium.LoanPolicyRate, d.InsurancePremium.CostLoanPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
                d.InsurancePremium.OwnersLoanPolicyFullPremium = insurancePolicyCalculation(d.InsurancePremium.LoanAmountFullPremium, d.InsurancePremium.LoanPolicyRate, d.InsurancePremium.CostLoanPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
                d.InsurancePremium.TitleInsurance = d.InsurancePremium.OwnersLoanPolicyDiscounted * 1.3 + d.InsurancePremium.OwnersLoanPolicyFullPremium;
                d.ClosingCost.OwnersPolicy = d.InsurancePremium.OwnersPolicy;
                d.ClosingCost.Sums = d.ClosingCost.OwnersPolicy + d.ClosingCost.TitleBill + d.ClosingCost.BuyerAttorney;
                d.LoanCosts.LoanPolicy = d.InsurancePremium.TitleInsurance - d.InsurancePremium.OwnersPolicy;
                d.FlipCalculation.FlipPrice = (d.Resale.ProbableResale - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums) - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums) * d.FlipCalculation.FlipROI) / ((d.FlipCalculation.FlipROI + 1) * 1.0);

                // HOI
                d.LoanCosts.Sums = d.LoanCosts.LoanPolicy + d.LoanCosts.LoanClosingCost + d.LoanCosts.Points + d.LoanCosts.LoanInterest;
                d.HOI.PurchasePriceAllIn = (d.Resale.ProbableResale - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums + d.LoanCosts.Sums) - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums) * d.HOI.Value) / ((d.HOI.Value + 1) * 1.0);
                d.HOI.TotalInvestment = d.HOI.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
                d.HOI.CashRequirement = d.HOI.TotalInvestment - d.LoanTerms.LoanAmount;
                d.HOI.NetProfit = d.Resale.ProbableResale - d.Resale.Sums - d.HOI.TotalInvestment;
                d.HOI.ROILoan = d.HOI.NetProfit / d.HOI.TotalInvestment;

                // Best Case For HOI
                d.HOIBestCase.PurchasePriceAllIn = float(d.RehabInfo.AverageLowValue) + d.Liens.AdditonalCostsSums + d.DealExpenses.Sums - d.DealExpenses.HOILien;
                d.HOIBestCase.TotalInvestment = d.HOIBestCase.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
                d.HOIBestCase.CashRequirement = d.HOIBestCase.TotalInvestment - d.LoanTerms.LoanAmount;
                d.HOIBestCase.NetProfit = d.Resale.ProbableResale - d.Resale.Sums - d.HOIBestCase.TotalInvestment;
                d.HOIBestCase.ROILoan = d.HOIBestCase.NetProfit / d.HOIBestCase.TotalInvestment;

                // Cash Scenario
                d.CashScenario.Purchase_LienPayoffs = d.Liens.LienPayoffs + d.Liens.TaxLienCertificate + d.Liens.PropertyTaxes;
                d.CashScenario.Purchase_OffHUDCosts = d.Liens.AdditonalCostsSums;
                d.CashScenario.Purchase_DealCosts = d.DealExpenses.Sums;
                d.CashScenario.Purchase_ClosingCost = d.ClosingCost.Sums;
                d.CashScenario.Purchase_Construction = d.Construction.Sums;
                d.CashScenario.Purchase_CarryingCosts = d.CarryingCosts.Sums;
                d.CashScenario.Purchase_TotalInvestment = d.CashScenario.Purchase_LienPayoffs + d.CashScenario.Purchase_OffHUDCosts + d.CashScenario.Purchase_DealCosts + d.CashScenario.Purchase_ClosingCost + d.CashScenario.Purchase_Construction + d.CashScenario.Purchase_CarryingCosts;
                d.CashScenario.Resale_SalePrice = d.Resale.ProbableResale;
                d.CashScenario.Resale_Concession = d.Resale.Concession;
                d.CashScenario.Resale_Commissions = d.Resale.Commissions;
                d.CashScenario.Resale_ClosingCost = d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
                d.CashScenario.Resale_NetProfit = d.CashScenario.Resale_SalePrice - (d.CashScenario.Resale_Concession + d.CashScenario.Resale_Commissions + d.CashScenario.Resale_ClosingCost) - d.CashScenario.Purchase_TotalInvestment;
                d.CashScenario.Time = float(d.RehabInfo.DealTimeMonths);
                d.CashScenario.CashRequired = d.CashScenario.Purchase_TotalInvestment;
                d.CashScenario.ROI = d.CashScenario.Resale_NetProfit / d.CashScenario.Purchase_TotalInvestment;
                d.CashScenario.ROIAnnual = d.CashScenario.ROI / d.RehabInfo.DealTimeMonths * 12;
                // Loan Scenario
                d.LoanScenario.Purchase_PurchasePrice = d.Liens.LienPayoffs + d.Liens.TaxLienCertificate + d.Liens.PropertyTaxes;
                d.LoanScenario.Purchase_AdditonalCosts = d.Liens.AdditonalCostsSums;
                d.LoanScenario.Purchase_DealCosts = d.DealExpenses.Sums;
                d.LoanScenario.Purchase_ClosingCost = d.ClosingCost.Sums;
                d.LoanScenario.Purchase_Construction = d.Construction.Sums;
                d.LoanScenario.Purchase_CarryingCosts = d.CarryingCosts.Sums;
                d.LoanScenario.Purchase_LoanClosingCost = d.LoanCosts.LoanPolicy + d.LoanCosts.LoanClosingCost + d.LoanCosts.Points;
                d.LoanScenario.Purchase_LoanInterest = d.LoanCosts.LoanInterest;
                d.LoanScenario.Purchase_TotalInvestment = d.Liens.LienPayoffs + d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
                d.LoanScenario.Resale_SalePrice = d.Resale.ProbableResale;
                d.LoanScenario.Resale_Concession = d.Resale.Concession;
                d.LoanScenario.Resale_Commissions = d.Resale.Commissions;
                d.LoanScenario.Resale_ClosingCost = d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
                d.LoanScenario.Resale_NetProfit = d.LoanScenario.Resale_SalePrice - (d.LoanScenario.Resale_Concession + d.LoanScenario.Resale_Commissions + d.LoanScenario.Resale_ClosingCost) - d.LoanScenario.Purchase_TotalInvestment;
                d.LoanScenario.Time = float(d.RehabInfo.DealTimeMonths);
                d.LoanScenario.LoanAmount = d.LoanTerms.LoanAmount;
                d.LoanScenario.LTV = d.LoanScenario.LoanAmount / d.LoanScenario.Resale_SalePrice;
                d.LoanScenario.CashRequirement = d.LoanScenario.Purchase_TotalInvestment - d.LoanScenario.LoanAmount;
                d.LoanScenario.ROI = d.LoanScenario.Resale_NetProfit / d.LoanScenario.Purchase_TotalInvestment;
                d.LoanScenario.ROIAnnual = d.LoanScenario.ROI / d.RehabInfo.DealTimeMonths * 12;
                d.LoanScenario.CashROI = d.LoanScenario.Resale_NetProfit / d.LoanScenario.CashRequirement;
                d.LoanScenario.CashROIAnnual = d.LoanScenario.CashROI / d.RehabInfo.DealTimeMonths * 12;
                // FlipScenario
                d.FlipScenario.Purchase_TotalCost = d.Liens.LienPayoffs + d.Liens.Sums + d.DealExpenses.Sums;
                d.FlipScenario.FlipPrice_SalePrice = d.FlipCalculation.FlipPrice;

                d.FlipScenario.Purchase_PurchasePrice = d.FlipScenario.FlipPrice_SalePrice;
                d.FlipScenario.Purchase_ClosingCost = d.ClosingCost.Sums;
                d.FlipScenario.Purchase_Construction = d.Construction.Sums;
                d.FlipScenario.Purchase_CarryingCosts = d.CarryingCosts.Sums;
                d.FlipScenario.Purchase_TotalInvestment = d.FlipScenario.Purchase_PurchasePrice + d.FlipScenario.Purchase_ClosingCost + d.FlipScenario.Purchase_Construction + d.FlipScenario.Purchase_CarryingCosts;
                d.FlipScenario.Resale_SalePrice = d.Resale.ProbableResale;
                d.FlipScenario.Resale_Concession = d.Resale.Concession;
                d.FlipScenario.Resale_Commissions = d.Resale.Commissions;
                d.FlipScenario.Resale_ClosingCost = d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
                d.FlipScenario.Resale_NetProfit = d.FlipScenario.Resale_SalePrice - (d.FlipScenario.Resale_Commissions + d.FlipScenario.Resale_ClosingCost) - d.FlipScenario.Purchase_TotalInvestment;
                d.FlipScenario.FlipProfit = d.FlipScenario.FlipPrice_SalePrice - d.FlipScenario.Purchase_TotalCost;
                d.FlipScenario.CashRequirement = d.FlipScenario.Purchase_TotalInvestment
                d.FlipScenario.ROI = d.FlipScenario.Resale_NetProfit / d.FlipScenario.Purchase_TotalInvestment;
                // Others 
                d.Others.MaximumLienPayoff = d.Liens.LienPayoffs + d.Liens.TaxLienCertificate + d.Liens.PropertyTaxes;
                d.Others.MaximumSSPrice = d.Liens.LienPayoffs + d.Liens.Sums;
                d.Others.MaxHOI = d.HOIBestCase.NetProfit - d.HOI.NetProfit;
                // Minimum Baseline (~=Loan)
                d.MinimumBaselineScenario.PurchasePriceAllIn = d.Liens.LienPayoffs + d.Liens.Sums + d.DealExpenses.Sums;
                d.MinimumBaselineScenario.TotalInvestment = d.LoanScenario.Purchase_TotalInvestment;
                d.MinimumBaselineScenario.CashRequirement = d.LoanScenario.CashRequirement;
                d.MinimumBaselineScenario.NetProfit = d.LoanScenario.Resale_NetProfit;
                d.MinimumBaselineScenario.ROI = d.LoanScenario.ROI;
                // Best Case Scenario
                d.BestCaseScenario.PurchasePriceAllIn = float(d.RehabInfo.AverageLowValue) + d.Liens.AdditonalCostsSums + d.DealExpenses.Sums;
                d.BestCaseScenario.TotalInvestment = d.BestCaseScenario.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
                d.BestCaseScenario.CashRequirement = d.BestCaseScenario.TotalInvestment - d.LoanTerms.LoanAmount;
                d.BestCaseScenario.NetProfit = d.LoanScenario.Resale_SalePrice - (d.LoanScenario.Resale_Concession + d.LoanScenario.Resale_Commissions + d.LoanScenario.Resale_ClosingCost) - (d.BestCaseScenario.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums);
                d.BestCaseScenario.ROI = d.BestCaseScenario.NetProfit / d.BestCaseScenario.TotalInvestment
                // Rental Model
                d.RentalModel.NumOfUnits = int(d.RentalInfo.NumOfUnits);
                d.RentalModel.DeedPurchase = float(d.RentalInfo.DeedPurchase);
                d.RentalModel.TotalRepairs = float(d.RentalInfo.RepairBidTotal);
                d.RentalModel.AgentCommission = float(d.DealCosts.AgentCommission);
                d.RentalModel.TotalUpfront = d.RentalModel.DeedPurchase + d.RentalModel.TotalRepairs + d.RentalModel.AgentCommission;
                d.RentalModel.Rent = float(d.RentalInfo.MarketRentTotal);
                d.RentalModel.ManagementFee = d.RentalModel.Rent * 0.1;
                d.RentalModel.Maintenance = 50 + (d.RentalModel.NumOfUnits - 1) * 25;
                d.RentalModel.MiscRepairs = 75 * d.RentalModel.NumOfUnits;
                d.RentalModel.NetMontlyRent = d.RentalModel.Rent - d.RentalModel.ManagementFee - d.RentalModel.Maintenance - d.RentalModel.Insurance - d.RentalModel.MiscRepairs;
                var helper = new RentalHelper(d.RentalInfo.CurrentlyRented, d.RentalInfo.RentalTime, d.RentalModel);
                d.RentalModel.TotalMonth = helper.totalMonths;
                d.RentalModel.CostOfMoney = helper.costOfMoney;
                d.RentalModel.TotalCost = helper.totalCost;
                d.RentalModel.Breakeven = helper.breakeven;
                d.RentalModel.TargetTime = d.RentalModel.TotalMonth;
                d.RentalModel.TargetProfit = helper.targetProfit;
                d.RentalModel.ROIYear = helper.ROIYear;
                d.RentalModel.ROITotal = helper.ROITotal;
            }

            return {
                calculate: applyRule,
                applyFixedRules: applyFixedRules,
                importData: importData,
            }
        })();

        /**
         * load underwriting from database, if not loaded, use factory new one and import infomation from portal
         * @param: bble // if no present, only create new model from factory
         * 
         **/
        underwriter.load = function (/* optional */ bble) {
            //debugger;
            var data = underwritingFactory.build();
            underwriter.calculator.applyFixedRules(data);

            if (bble) {
                var _data = underwriter.get({ BBLE: bble.trim() }, function (d) {
                    _data.BBLE = bble;
                    _.defaults(_data, data);
                    //debugger;
                    if (!_data.Id) {  // data is not load from database, load data from portal
                        data.docSearch = DocSearch.get({ BBLE: bble.trim() }, function () {
                            data.leadsInfo = LeadsInfo.get({ BBLE: bble.trim() }, function () {
                                underwriter.calculator.importData(data);
                            })

                        });
                    }

                })
                return _data;
            }
            return data;
        }

        underwriter.save = function (data) {
            return $http({
                method: 'POST',
                url: '/api/underwriter',
                data: data,
                headers: {
                    'Content-Type': 'application/json'
                }

            })

        }

        underwriter.archive = function (data, msg) {

            return $http({
                method: 'POST',
                url: '/api/underwriter/archive',
                data: [data, msg]
            })
        }

        underwriter.loadArchivedList = function (bble) {
            return $http({
                method: 'GET',
                url: '/api/underwriter/archived/' + bble
            })
        }

        underwriter.loadArchived = function (id) {

            return $http({
                method: 'GET',
                url: '/api/underwriter/archived/id/' + id
            })
        }

        return underwriter;

    }]);