using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using RedQ.UnderwritingService.Models.NewYork;

namespace RedQ.UnderwritingService.Services
{
    public class UnderwritingService
    {
        private static UnderwritingService _service;

        public static UnderwritingService GetService()
        {
            if (_service == null)
            {
                _service = new UnderwritingService();
            }
            return _service;
        }

        public static UnderwritingOutput ApplyRule(UnderwritingInput input)
        {
            var ctx = Context.InitContext(input);
            UnderwritingService service = GetService();
            service.CalculateValues(ctx).CalculateSums(ctx).CalculateInsurancePremium(ctx)
                                        .CalculateHOI(ctx).CalculateCashScenario(ctx)
                                        .CalculateLoanScenario(ctx).CalculateFlipScenario(ctx)
                                        .CalculateSummary(ctx).CalculateMinimumBaselineScenario(ctx)
                                        .CalculateBestCaseScenario(ctx).CalculateRentalModel(ctx);
            return ctx.ToOutput();
        }

        public static Context DebugRule(UnderwritingInput input)
        {
            var ctx = Context.InitContext(input);
            UnderwritingService service = GetService();
            service.CalculateValues(ctx).CalculateSums(ctx).CalculateInsurancePremium(ctx)
                                        .CalculateHOI(ctx).CalculateCashScenario(ctx)
                                        .CalculateLoanScenario(ctx).CalculateFlipScenario(ctx)
                                        .CalculateSummary(ctx).CalculateMinimumBaselineScenario(ctx)
                                        .CalculateBestCaseScenario(ctx).CalculateRentalModel(ctx);
            return ctx;
        }

        public UnderwritingService CalculateValues(Context ctx)
        {
            ctx.PropertyInfo.PropertyType = new Regex(".*(A|B|C0|21|R).*").IsMatch(ctx.PropertyInfo.TaxClass)
                                  ? UnderwritingPropertyInfo.PropertyTypeEnum.Residential
                                  : UnderwritingPropertyInfo.PropertyTypeEnum.NotResidential;
            ctx.Liens.TaxLienCertificate = ctx.LienCosts.TaxLienCertificate
                                         * (1.0 + ctx.Settlement.TaxLienCertificateSettlement
                                         * ctx.RehabInfo.DealTimeMonths);
            ctx.Liens.PropertyTaxes = ctx.LienCosts.PropertyTaxes * ctx.Settlement.PropertyTaxesSettlement;
            ctx.Liens.WaterCharges = ctx.LienCosts.WaterCharges * ctx.Settlement.WaterChargesSettlement;
            ctx.Liens.ECBCityPay = ctx.LienCosts.ECBCityPay * ctx.Settlement.ECBCityPaySettlement;
            ctx.Liens.DOBCivilPenalties = ctx.LienCosts.DOBCivilPenalty * ctx.Settlement.DOBCivilPenaltiesSettlement;
            ctx.Liens.HPDCharges = ctx.LienCosts.HPDCharges * ctx.Settlement.HPDChargesSettlement;
            ctx.Liens.HPDJudgements = ctx.LienCosts.HPDJudgements * ctx.Settlement.HPDJudgementsSettlement;
            ctx.Liens.PersonalJudgements = ctx.LienCosts.PersonalJudgements * ctx.Settlement.PersonalJudgementsSettlement;
            ctx.Settlement.NYSTaxWarrantsSettlement = ctx.LienCosts.NYSTaxWarrants < 12500 ? 1.0 : 0.0;
            ctx.Liens.NYSTaxWarrants = ctx.LienCosts.NYSTaxWarrants * ctx.Settlement.NYSTaxWarrantsSettlement;
            ctx.Settlement.FederalTaxLienSettlement = ctx.LienCosts.FederalTaxLien < 12500 ? 1.0 : 0.0;
            ctx.Liens.FederalTaxLien = ctx.LienCosts.FederalTaxLien * ctx.Settlement.FederalTaxLienSettlement;
            ctx.Liens.ParkingViolation = ctx.LienCosts.ParkingViolation * ctx.Settlement.ParkingViolationSettlement;
            ctx.Liens.TransitAuthority = ctx.LienCosts.TransitAuthority * ctx.Settlement.TransitAuthoritySettlement;
            ctx.Liens.RelocationLien = ctx.LienCosts.RelocationLienDate == DateTime.MinValue
                                     ? 0.0
                                     : new Func<Context, double>((ctxx) =>
                {
                    var days = ctxx.LienCosts.RelocationLienDate.GetValueOrDefault().Subtract(DateTime.Now).TotalDays;
                    return ctx.LienCosts.RelocationLien * (1 + days + 180) * ctx.Settlement.RelocationLienSettlement;
                })(ctx);
            ctx.DealCosts.HAFA = (ctx.PropertyInfo.SellerOccupied || ctx.PropertyInfo.NumOfTenants > 0)
                               && !ctx.LienInfo.FHA
                               && !ctx.LienInfo.FannieMae
                               && !ctx.LienInfo.FreddieMac
                               && ctx.DealCosts.HOI > 0.0;

            ctx.DealExpenses.MoneySpent = ctx.DealCosts.MoneySpent;
            ctx.DealExpenses.HOILienSettlement = ctx.DealCosts.HOIRatio;
            ctx.DealExpenses.HOILien = ctx.DealCosts.HAFA
                ? ctx.DealCosts.HOI * ctx.DealExpenses.HOILienSettlement - 10000.00
                : ctx.DealCosts.HOI * ctx.DealExpenses.HOILienSettlement;
            ctx.DealExpenses.COSTermination = ctx.DealCosts.COSTermination;
            ctx.DealExpenses.Tenants = ctx.PropertyInfo.NumOfTenants * 7000.00;
            ctx.DealExpenses.Agent = ctx.DealCosts.AgentCommission;

            // Construction(Improvement)
            ctx.Construction.Construction = ctx.RehabInfo.RepairBid;
            ctx.Construction.Architect = ctx.RehabInfo.NeedsPlans ? 8500 : 0;

            // CarryingCosts
            ctx.CarryingCost.RETaxs = ctx.PropertyInfo.PropertyTaxYear / 12 * ctx.RehabInfo.DealTimeMonths;
            ctx.CarryingCost.Utilities = 150 * Math.Pow(ctx.PropertyInfo.NumOfTenants, 2) + 400 * ctx.PropertyInfo.NumOfTenants;

            // Resale
            ctx.Resale.ProbableResale = ctx.RehabInfo.RenovatedValue;
            ctx.Resale.Commissions = ctx.Resale.ProbableResale * ctx.RehabInfo.SalesCommission;
            ctx.Resale.TransferTax = new Func<Context, double>((c) =>
            {
                double pr = c.Resale.ProbableResale;
                double rate = 0.0;
                if (c.PropertyInfo.PropertyType == UnderwritingPropertyInfo.PropertyTypeEnum.Residential)
                {
                    rate = pr <= 500000 ? 0.01 : 0.01425;
                }
                else
                {
                    rate = pr <= 500000 ? 0.01425 : 0.02625;
                }

                return (rate + 0.004) * pr;
            })(ctx);
            // LoanTerms
            ctx.LoanTerms.LoanAmount = ctx.Resale.ProbableResale * ctx.LoanTerms.LTV;
            ctx.CarryingCost.Insurance = ctx.LoanTerms.LoanAmount / 100.0 * 0.45 / 12 * ctx.RehabInfo.DealTimeMonths;
            // LoanCosts
            ctx.LoanCosts.LoanClosingCost = new Func<Context, double>((ctxx) =>
            {
                var la = ctxx.LoanTerms.LoanAmount;
                var rate = 0.0;
                if (ctxx.PropertyInfo.PropertyType == UnderwritingPropertyInfo.PropertyTypeEnum.Residential)
                {
                    rate = la <= 500000 ? 0.02 : 0.02125;
                }
                else
                {
                    rate = la <= 500000 ? 0.02 : 0.0275;
                }
                return la * rate + 275 + 1500;
            })(ctx);
            ctx.LoanCosts.Points = ctx.LoanTerms.LoanAmount * ctx.LoanTerms.LoanPoints / 100.0;
            ctx.LoanCosts.LoanInterest = ctx.LoanTerms.LoanAmount * ctx.LoanTerms.LoanRate / 12.0 * ctx.RehabInfo.DealTimeMonths;
            return this;
        }

        public UnderwritingService CalculateSums(Context ctx)
        {
            ctx.Liens.Sums = ctx.Liens.TaxLienCertificate + ctx.Liens.PropertyTaxes + ctx.Liens.WaterCharges
                           + ctx.Liens.ECBCityPay + ctx.Liens.DOBCivilPenalties + ctx.Liens.HPDCharges
                           + ctx.Liens.HPDJudgements + ctx.Liens.PersonalJudgements + ctx.Liens.NYSTaxWarrants
                           + ctx.Liens.FederalTaxLien + ctx.Liens.ParkingViolation + ctx.Liens.TransitAuthority
                           + ctx.Liens.RelocationLien;
            ctx.DealExpenses.Sums = ctx.DealExpenses.MoneySpent + ctx.DealExpenses.HOILien
                                  + ctx.DealExpenses.COSTermination + ctx.DealExpenses.Tenants
                                  + ctx.DealExpenses.Agent;
            ctx.ClosingCost.PartialSums = ctx.ClosingCost.TitleBill + ctx.ClosingCost.BuyerAttorney;
            ctx.Construction.Sums = ctx.Construction.Construction + ctx.Construction.Architect;
            ctx.CarryingCost.Sums = ctx.CarryingCost.Insurance + ctx.CarryingCost.RETaxs
                                  + ctx.CarryingCost.Utilities;
            ctx.Resale.Sums = ctx.Resale.Concession + ctx.Resale.Commissions + ctx.Resale.TransferTax
                            + ctx.Resale.Attorney + ctx.Resale.NDC;
            ctx.Liens.LienPayoffs = (ctx.Resale.ProbableResale -
                                               (ctx.Liens.Sums + ctx.DealExpenses.Sums + ctx.ClosingCost.PartialSums
                                                + ctx.Construction.Sums + ctx.CarryingCost.Sums + ctx.Resale.Sums)
                                               - (ctx.Liens.Sums + ctx.DealExpenses.Sums + ctx.ClosingCost.PartialSums
                                                  + ctx.Construction.Sums + ctx.CarryingCost.Sums)
                                               * ctx.RehabInfo.DealROICash) / (ctx.RehabInfo.DealROICash * 1.0058 + 1.0058);
            ctx.Liens.AdditonalCostsSums = ctx.Liens.WaterCharges + ctx.Liens.ECBCityPay
                                                       + ctx.Liens.DOBCivilPenalties + ctx.Liens.HPDCharges
                                                       + ctx.Liens.HPDJudgements + ctx.Liens.PersonalJudgements
                                                       + ctx.Liens.NYSTaxWarrants + ctx.Liens.FederalTaxLien
                                                       + ctx.Liens.ParkingViolation + ctx.Liens.TransitAuthority
                                                       + ctx.Liens.RelocationLien;
            return this;
        }

        public UnderwritingService CalculateInsurancePremium(Context ctx)
        {
            ctx.InsurancePremium.PurchasePrice = ctx.Liens.LienPayoffs;
            ctx.InsurancePremium.LoanAmountDiscounted = ctx.LoanTerms.LoanAmount >= ctx.Liens.LienPayoffs
                ? ctx.Liens.LienPayoffs
                : ctx.LoanTerms.LoanAmount;
            ctx.InsurancePremium.LoanAmountFullPremium = ctx.LoanTerms.LoanAmount
                                                       - ctx.InsurancePremium.LoanAmountDiscounted;
            ctx.InsurancePremium.OwnersPolicy =
                InsurancePolicyCalculation(ctx.InsurancePremium.PurchasePrice,
                    ctx.InsurancePremium.OwnersPolicyRate,
                    ctx.InsurancePremium.CostOwnersPolicy,
                    ctx.InsurancePremium._From,
                    ctx.InsurancePremium._To);
            ctx.InsurancePremium
                .OwnersLoanPolicyDiscounted =
                InsurancePolicyCalculation(ctx.InsurancePremium.LoanAmountDiscounted,
                    ctx.InsurancePremium.LoanPolicyRate,
                    ctx.InsurancePremium.CostLoanPolicy,
                    ctx.InsurancePremium._From,
                    ctx.InsurancePremium._To);
            ctx.InsurancePremium
                .OwnersLoanPolicyFullPremium =
                InsurancePolicyCalculation(ctx.InsurancePremium.LoanAmountFullPremium,
                    ctx.InsurancePremium.LoanPolicyRate,
                    ctx.InsurancePremium.CostLoanPolicy,
                    ctx.InsurancePremium._From,
                    ctx.InsurancePremium._To);
            ctx.InsurancePremium.TitleInsurance = ctx.InsurancePremium.OwnersLoanPolicyDiscounted * 1.3 +
                ctx.InsurancePremium.OwnersLoanPolicyFullPremium;
            ctx.ClosingCost.OwnersPolicy = ctx.InsurancePremium.OwnersPolicy;
            ctx.ClosingCost.Sums = ctx.ClosingCost.OwnersPolicy +
                ctx.ClosingCost.TitleBill +
                ctx.ClosingCost.BuyerAttorney;
            ctx.LoanCosts.LoanPolicy = ctx.InsurancePremium.TitleInsurance - ctx.InsurancePremium.OwnersPolicy;
            ctx.FlipCalculation.FlipPrice = (ctx.Resale.ProbableResale -
                    (ctx.ClosingCost.Sums + ctx.Construction.Sums + ctx.CarryingCost.Sums + ctx.Resale.Sums) -
                    (ctx.ClosingCost.Sums + ctx.Construction.Sums + ctx.CarryingCost.Sums) *
                    ctx.FlipCalculation.FlipROI) /
                ((ctx.FlipCalculation.FlipROI + 1) * 1.0);
            return this;
        }

        public UnderwritingService CalculateHOI(Context ctx)
        {
            ctx.LoanCosts.Sums = ctx.LoanCosts.LoanPolicy + ctx.LoanCosts.LoanClosingCost + ctx.LoanCosts.Points
                               + ctx.LoanCosts.LoanInterest;
            ctx.HOI.PurchasePriceAllIn = (ctx.Resale.ProbableResale -
                                            (ctx.ClosingCost.Sums + ctx.Construction.Sums + ctx.CarryingCost.Sums
                                            + ctx.Resale.Sums + ctx.LoanCosts.Sums)
                                            - (ctx.ClosingCost.Sums + ctx.Construction.Sums + ctx.CarryingCost.Sums
                                              + ctx.LoanCosts.Sums)
                                         * ctx.HOI.Value) / ((ctx.HOI.Value + 1) * 1.0);
            ctx.HOI.TotalInvestment = ctx.HOI.PurchasePriceAllIn + ctx.ClosingCost.Sums + ctx.Construction.Sums
                                    + ctx.CarryingCost.Sums + ctx.LoanCosts.Sums;
            ctx.HOI.CashRequirement = ctx.HOI.TotalInvestment - ctx.LoanTerms.LoanAmount;
            ctx.HOI.NetProfit = ctx.Resale.ProbableResale - ctx.Resale.Sums - ctx.HOI.TotalInvestment;
            ctx.HOI.ROILoan = ctx.HOI.NetProfit / ctx.HOI.TotalInvestment;

            // Best Case For HOI
            ctx.HOIBestCase.PurchasePriceAllIn = ctx.RehabInfo.AverageLowValue + ctx.Liens.AdditonalCostsSums
                                               + ctx.DealExpenses.Sums - ctx.DealExpenses.HOILien;
            ctx.HOIBestCase.TotalInvestment = ctx.HOIBestCase.PurchasePriceAllIn + ctx.ClosingCost.Sums
                                            + ctx.Construction.Sums + ctx.CarryingCost.Sums + ctx.LoanCosts.Sums;
            ctx.HOIBestCase.CashRequirement = ctx.HOIBestCase.TotalInvestment - ctx.LoanTerms.LoanAmount;
            ctx.HOIBestCase.NetProfit = ctx.Resale.ProbableResale - ctx.Resale.Sums - ctx.HOIBestCase.TotalInvestment;
            ctx.HOIBestCase.ROILoan = ctx.HOIBestCase.NetProfit / ctx.HOIBestCase.TotalInvestment;
            return this;
        }

        public UnderwritingService CalculateCashScenario(Context ctx)
        {
            ctx.CashScenario.PurchaseLienPayoffs = ctx.Liens.LienPayoffs + ctx.Liens.TaxLienCertificate
                                                 + ctx.Liens.PropertyTaxes;
            ctx.CashScenario.PurchaseOffHUDCosts = ctx.Liens.AdditonalCostsSums;
            ctx.CashScenario.PurchaseDealCosts = ctx.DealExpenses.Sums;
            ctx.CashScenario.PurchaseClosingCost = ctx.ClosingCost.Sums;
            ctx.CashScenario.PurchaseConstruction = ctx.Construction.Sums;
            ctx.CashScenario.PurchaseCarryingCosts = ctx.CarryingCost.Sums;
            ctx.CashScenario.PurchaseTotalInvestment = ctx.CashScenario.PurchaseLienPayoffs
                                                     + ctx.CashScenario.PurchaseOffHUDCosts
                                                     + ctx.CashScenario.PurchaseDealCosts
                                                     + ctx.CashScenario.PurchaseClosingCost
                                                     + ctx.CashScenario.PurchaseConstruction
                                                     + ctx.CashScenario.PurchaseCarryingCosts;
            ctx.CashScenario.ResaleSalePrice = ctx.Resale.ProbableResale;
            ctx.CashScenario.ResaleConcession = ctx.Resale.Concession;
            ctx.CashScenario.ResaleCommissions = ctx.Resale.Commissions;
            ctx.CashScenario.ResaleClosingCost = ctx.Resale.TransferTax + ctx.Resale.Attorney + ctx.Resale.NDC;
            ctx.CashScenario.ResaleNetProfit = ctx.CashScenario.ResaleSalePrice -
                                               (ctx.CashScenario.ResaleConcession + ctx.CashScenario.ResaleCommissions
                                               + ctx.CashScenario.ResaleClosingCost)
                                               - ctx.CashScenario.PurchaseTotalInvestment;
            ctx.CashScenario.Time = ctx.RehabInfo.DealTimeMonths;
            ctx.CashScenario.CashRequired = ctx.CashScenario.PurchaseTotalInvestment;
            ctx.CashScenario.ROI = ctx.CashScenario.ResaleNetProfit / ctx.CashScenario.PurchaseTotalInvestment;
            ctx.CashScenario.ROIAnnual = ctx.CashScenario.ROI / ctx.RehabInfo.DealTimeMonths * 12;
            return this;
        }

        public UnderwritingService CalculateLoanScenario(Context ctx)
        {
            ctx.LoanScenario.PurchasePurchasePrice = ctx.Liens.LienPayoffs + ctx.Liens.TaxLienCertificate
                                                   + ctx.Liens.PropertyTaxes;
            ctx.LoanScenario.PurchaseAdditonalCosts = ctx.Liens.AdditonalCostsSums;
            ctx.LoanScenario.PurchaseDealCosts = ctx.DealExpenses.Sums;
            ctx.LoanScenario.PurchaseClosingCost = ctx.ClosingCost.Sums;
            ctx.LoanScenario.PurchaseConstruction = ctx.Construction.Sums;
            ctx.LoanScenario.PurchaseCarryingCosts = ctx.CarryingCost.Sums;
            ctx.LoanScenario.PurchaseLoanClosingCost = ctx.LoanCosts.LoanPolicy + ctx.LoanCosts.LoanClosingCost
                                                     + ctx.LoanCosts.Points;
            ctx.LoanScenario.PurchaseLoanInterest = ctx.LoanCosts.LoanInterest;
            ctx.LoanScenario.PurchaseTotalInvestment = ctx.Liens.LienPayoffs + ctx.Liens.Sums
                                                     + ctx.DealExpenses.Sums + ctx.ClosingCost.Sums
                                                     + ctx.Construction.Sums + ctx.CarryingCost.Sums
                                                     + ctx.LoanCosts.Sums;
            ctx.LoanScenario.ResaleSalePrice = ctx.Resale.ProbableResale;
            ctx.LoanScenario.ResaleConcession = ctx.Resale.Concession;
            ctx.LoanScenario.ResaleCommissions = ctx.Resale.Commissions;
            ctx.LoanScenario.ResaleClosingCost = ctx.Resale.TransferTax + ctx.Resale.Attorney + ctx.Resale.NDC;
            ctx.LoanScenario.ResaleNetProfit = ctx.LoanScenario.ResaleSalePrice
                                             - (ctx.LoanScenario.ResaleConcession
                                               + ctx.LoanScenario.ResaleCommissions
                                               + ctx.LoanScenario.ResaleClosingCost)
                                             - ctx.LoanScenario.PurchaseTotalInvestment;
            ctx.LoanScenario.Time = ctx.RehabInfo.DealTimeMonths;
            ctx.LoanScenario.LoanAmount = ctx.LoanTerms.LoanAmount;
            ctx.LoanScenario.LTV = ctx.LoanScenario.LoanAmount / ctx.LoanScenario.ResaleSalePrice;
            ctx.LoanScenario.CashRequirement = ctx.LoanScenario.PurchaseTotalInvestment
                                             - ctx.LoanScenario.LoanAmount;
            ctx.LoanScenario.ROI = ctx.LoanScenario.ResaleNetProfit / ctx.LoanScenario.PurchaseTotalInvestment;
            ctx.LoanScenario.ROIAnnual = ctx.LoanScenario.ROI / ctx.RehabInfo.DealTimeMonths * 12;
            ctx.LoanScenario.CashROI = ctx.LoanScenario.ResaleNetProfit / ctx.LoanScenario.CashRequirement;
            ctx.LoanScenario.CashROIAnnual = ctx.LoanScenario.CashROI / ctx.RehabInfo.DealTimeMonths * 12;
            return this;
        }

        public UnderwritingService CalculateFlipScenario(Context ctx)
        {
            ctx.FlipScenario.PurchaseTotalCost = ctx.Liens.LienPayoffs + ctx.Liens.Sums + ctx.DealExpenses.Sums;
            ctx.FlipScenario.FlipPriceSalePrice = ctx.FlipCalculation.FlipPrice;
            ctx.FlipScenario.PurchasePurchasePrice = ctx.FlipScenario.FlipPriceSalePrice;
            ctx.FlipScenario.PurchaseClosingCost = ctx.ClosingCost.Sums;
            ctx.FlipScenario.PurchaseConstruction = ctx.Construction.Sums;
            ctx.FlipScenario.PurchaseCarryingCosts = ctx.CarryingCost.Sums;
            ctx.FlipScenario.PurchaseTotalInvestment = ctx.FlipScenario.PurchasePurchasePrice
                                                     + ctx.FlipScenario.PurchaseClosingCost
                                                     + ctx.FlipScenario.PurchaseConstruction
                                                     + ctx.FlipScenario.PurchaseCarryingCosts;
            ctx.FlipScenario.ResaleSalePrice = ctx.Resale.ProbableResale;
            ctx.FlipScenario.ResaleConcession = ctx.Resale.Concession;
            ctx.FlipScenario.ResaleCommissions = ctx.Resale.Commissions;
            ctx.FlipScenario.ResaleClosingCost = ctx.Resale.TransferTax + ctx.Resale.Attorney + ctx.Resale.NDC;
            ctx.FlipScenario.ResaleNetProfit = ctx.FlipScenario.ResaleSalePrice
                                             - (ctx.FlipScenario.ResaleCommissions
                                               + ctx.FlipScenario.ResaleClosingCost)
                                             - ctx.FlipScenario.PurchaseTotalInvestment;
            ctx.FlipScenario.FlipProfit = ctx.FlipScenario.FlipPriceSalePrice - ctx.FlipScenario.PurchaseTotalCost;
            ctx.FlipScenario.CashRequirement = ctx.FlipScenario.PurchaseTotalInvestment;
            ctx.FlipScenario.ROI = ctx.FlipScenario.ResaleNetProfit / ctx.FlipScenario.PurchaseTotalInvestment;
            return this;
        }

        public UnderwritingService CalculateSummary(Context ctx)
        {
            ctx.Summary.MaximumLienPayoff = ctx.Liens.LienPayoffs + ctx.Liens.TaxLienCertificate
                                          + ctx.Liens.PropertyTaxes;
            ctx.Summary.MaximumSSPrice = ctx.Liens.LienPayoffs + ctx.Liens.Sums;
            ctx.Summary.MaxHOI = ctx.HOIBestCase.NetProfit - ctx.HOI.NetProfit;
            return this;
        }

        public UnderwritingService CalculateMinimumBaselineScenario(Context ctx)
        {
            ctx.MinimumBaselineScenario.PurchasePriceAllIn = ctx.Liens.LienPayoffs + ctx.Liens.Sums
                                                           + ctx.DealExpenses.Sums;
            ctx.MinimumBaselineScenario.TotalInvestment = ctx.LoanScenario.PurchaseTotalInvestment;
            ctx.MinimumBaselineScenario.CashRequirement = ctx.LoanScenario.CashRequirement;
            ctx.MinimumBaselineScenario.NetProfit = ctx.LoanScenario.ResaleNetProfit;
            ctx.MinimumBaselineScenario.ROI = ctx.LoanScenario.ROI;
            return this;
        }

        public UnderwritingService CalculateBestCaseScenario(Context ctx)
        {
            ctx.BestCaseScenario.PurchasePriceAllIn = ctx.RehabInfo.AverageLowValue
                                                    + ctx.Liens.AdditonalCostsSums
                                                    + ctx.DealExpenses.Sums;
            ctx.BestCaseScenario.TotalInvestment = ctx.BestCaseScenario.PurchasePriceAllIn
                                                 + ctx.ClosingCost.Sums + ctx.Construction.Sums
                                                 + ctx.CarryingCost.Sums + ctx.LoanCosts.Sums;
            ctx.BestCaseScenario.CashRequirement = ctx.BestCaseScenario.TotalInvestment - ctx.LoanTerms.LoanAmount;
            ctx.BestCaseScenario.NetProfit = ctx.LoanScenario.ResaleSalePrice
                                           - (ctx.LoanScenario.ResaleConcession
                                             + ctx.LoanScenario.ResaleCommissions
                                             + ctx.LoanScenario.ResaleClosingCost)
                                           - (ctx.BestCaseScenario.PurchasePriceAllIn
                                             + ctx.ClosingCost.Sums + ctx.Construction.Sums
                                             + ctx.CarryingCost.Sums + ctx.LoanCosts.Sums);
            ctx.BestCaseScenario.ROI = ctx.BestCaseScenario.NetProfit / ctx.BestCaseScenario.TotalInvestment;
            return this;
        }

        public UnderwritingService CalculateRentalModel(Context ctx)
        {
            ctx.RentalModel.NumOfUnits = ctx.RentalInfo.NumOfUnits;
            ctx.RentalModel.DeedPurchase = ctx.RentalInfo.DeedPurchase;
            ctx.RentalModel.TotalRepairs = ctx.RentalInfo.RepairBidTotal;
            ctx.RentalModel.AgentCommission = ctx.DealCosts.AgentCommission;
            ctx.RentalModel.TotalUpfront = ctx.RentalModel.DeedPurchase +
                ctx.RentalModel.TotalRepairs +
                ctx.RentalModel.AgentCommission;
            ctx.RentalModel.Rent = ctx.RentalInfo.MarketRentTotal;
            ctx.RentalModel.ManagementFee = ctx.RentalModel.Rent * 0.1;
            ctx.RentalModel.Maintenance = 50 + (ctx.RentalModel.NumOfUnits - 1) * 25;
            ctx.RentalModel.MiscRepairs = 75 * ctx.RentalModel.NumOfUnits;
            ctx.RentalModel.NetMontlyRent = ctx.RentalModel.Rent -
                ctx.RentalModel.ManagementFee -
                ctx.RentalModel.Maintenance -
                ctx.RentalModel.Insurance -
                ctx.RentalModel.MiscRepairs;
            var helper = new RentalHelper(ctx.RentalInfo.CurrentlyRented, ctx.RentalInfo.RentalTime, ctx.RentalModel);
            ctx.RentalModel.TotalMonth = helper.totalMonths;
            ctx.RentalModel.CostOfMoney = helper.costOfMoney;
            ctx.RentalModel.TotalCost = helper.totalCost;
            ctx.RentalModel.Breakeven = helper.breakeven;
            ctx.RentalModel.TargetTime = ctx.RentalModel.TotalMonth;
            ctx.RentalModel.TargetProfit = helper.targetProfit;
            ctx.RentalModel.ROIYear = helper.ROIYear;
            ctx.RentalModel.ROITotal = helper.ROITotal;
            return this;
        }

        private double InsurancePolicyCalculation(double value, double[] policy, double[] cost, int[] from, int[] to)
        {
            if (value < from[0])
            {
                return 402;
            }
            else if (value <= to[0])
            {
                return (value - from[0]) * policy[0];
            }
            else
            {
                for (var i = 1; i < 7; i++)
                {
                    if (value <= to[i])
                    {
                        return (value - from[i]) * policy[i] + cost[i - 1];
                    }

                }
            }
            throw new Exception("Insurance value is too big to handle.");
        }
    }

    public class Context
    {
        public UnderwritingBestCaseScenario BestCaseScenario = new UnderwritingBestCaseScenario();
        public UnderwritingCarryingCost CarryingCost = new UnderwritingCarryingCost();
        public UnderwritingCashScenario CashScenario = new UnderwritingCashScenario();
        public UnderwritingClosingCost ClosingCost = new UnderwritingClosingCost();
        public UnderwritingConstruction Construction = new UnderwritingConstruction();
        public UnderwritingDealCosts DealCosts = new UnderwritingDealCosts();
        public UnderwritingDealExpenses DealExpenses = new UnderwritingDealExpenses();
        public UnderwritingFlipCalculation FlipCalculation = new UnderwritingFlipCalculation();
        public UnderwritingFlipScenario FlipScenario = new UnderwritingFlipScenario();
        public UnderwritingHOI HOI = new UnderwritingHOI();
        public UnderwritingHOIBestCase HOIBestCase = new UnderwritingHOIBestCase();
        public UnderwritingInsurancePremium InsurancePremium = new UnderwritingInsurancePremium();
        public UnderwritingLienCosts LienCosts = new UnderwritingLienCosts();
        public UnderwritingLienInfo LienInfo = new UnderwritingLienInfo();
        public UnderwritingLiens Liens = new UnderwritingLiens();
        public UnderwritingLoanCosts LoanCosts = new UnderwritingLoanCosts();
        public UnderwritingLoanScenario LoanScenario = new UnderwritingLoanScenario();
        public UnderwritingLoanTerms LoanTerms = new UnderwritingLoanTerms();
        public UnderwritingMinimumBaselineScenario MinimumBaselineScenario = new UnderwritingMinimumBaselineScenario();
        public UnderwritingMoneyFactor MoneyFactor = new UnderwritingMoneyFactor();
        public UnderwritingPropertyInfo PropertyInfo = new UnderwritingPropertyInfo();
        public UnderwritingRehabInfo RehabInfo = new UnderwritingRehabInfo();
        public UnderwritingRentalInfo RentalInfo = new UnderwritingRentalInfo();
        public UnderwritingRentalModel RentalModel = new UnderwritingRentalModel();
        public UnderwritingResale Resale = new UnderwritingResale();
        public UnderwritingSettlement Settlement = new UnderwritingSettlement();
        public UnderwritingSummary Summary = new UnderwritingSummary();

        public static Context InitContext(UnderwritingInput input)
        {
            Context ctx = new Context();
            if (input.PropertyInfo != null) ctx.PropertyInfo = input.PropertyInfo;
            if (input.DealCosts != null) ctx.DealCosts = input.DealCosts;
            if (input.LienInfo != null) ctx.LienInfo = input.LienInfo;
            if (input.RehabInfo != null) ctx.RehabInfo = input.RehabInfo;
            if (input.RentalInfo != null) ctx.RentalInfo = input.RentalInfo;
            if (input.LienCosts != null) ctx.LienCosts = input.LienCosts;
            return ctx;
        }

        public UnderwritingOutput ToOutput()
        {
            UnderwritingOutput output = new UnderwritingOutput();
            output.CashScenario = this.CashScenario;
            output.LoanScenario = this.LoanScenario;
            output.FlipScenario = this.FlipScenario;
            output.MinimumBaselineScenario = this.MinimumBaselineScenario;
            output.BestCaseScenario = this.BestCaseScenario;
            output.RentalModel = this.RentalModel;
            output.Summary = this.Summary;
            return output;
        }
    }

    class MonthlyRentalModel
    {
        public int Month { get; set; }
        public double Rent { get; set; }
        public double Interest { get; set; }
        public double Total { get; set; }
        public double ROI { get; set; }
    }

    public class RentalHelper
    {
        public int totalMonths;
        public int breakeven; // (month)
        public double costOfMoney;
        public double totalCost;
        public double targetProfit;
        public double ROIYear;
        public double ROITotal;
        private MonthlyRentalModel[] _model;


        public RentalHelper(bool isRented, int rentalTime, UnderwritingRentalModel model)
        {
            var m = 0;
            var temp = model.NetMontlyRent;

            // initial
            this._model = new MonthlyRentalModel[87];
            this._model[m] = new MonthlyRentalModel();
            this._model[m].Month = m + 1;
            this._model[m].Rent = 0;
            this._model[m].Interest = -(model.TotalUpfront * model.CostOfMoneyRate / 12.0);
            this._model[m].Total = -(model.TotalUpfront - this._model[m].Interest);
            m++;

            for (; m < 3; m++)
            {
                this._model[m] = new MonthlyRentalModel();
                this._model[m].Month = m + 1;
                this._model[m].Rent = isRented ? 0 : model.NetMontlyRent;
                this._model[m].Interest = this._model[m - 1].Total * model.CostOfMoneyRate / 12.0;
                this._model[m].Total = this._model[m - 1].Total + this._model[m].Interest + this._model[m].Rent;
            }

            for (var i = 0; i < 7; i++, temp = temp * 1.02)
            {
                for (var j = 0; j < 12; j++, m++)
                {
                    this._model[m] = new MonthlyRentalModel();
                    this._model[m].Month = m + 1;
                    this._model[m].Rent = temp;
                    if (m < 28)
                    {
                        this._model[m].Interest = this._model[m - 1].Total < 0
                            ? this._model[m - 1].Total * model.CostOfMoneyRate / 12
                            : 0.0;
                    }
                    else
                    {
                        this._model[m].Interest = this._model[m - 1].Total < 0
                            ? this._model[m - 1].Total * 0.18 / 12
                            : 0.0;
                    }
                    this._model[m].Total = this._model[m - 1].Total < 0
                        ? this._model[m - 1].Total + this._model[m].Interest + this._model[m].Rent
                        : this._model[m - 1].Total + this._model[m].Rent;
                }

            }


            for (var i = 0; i < 60; i++)
            {
                this.costOfMoney += this._model[i].Interest;
            }
            this.costOfMoney = -this.costOfMoney;
            this.totalCost = model.TotalUpfront + this.costOfMoney;

            for (var n = 1; n < this._model.Length; n++)
            {
                this._model[n].ROI = (this._model[n].Total / this.totalCost / this._model[n].Month * 12);
            }


            for (var n = 1; n < this._model.Length; n++)
            {
                if (this._model[n].ROI > (double)model.MinROI)
                {
                    this.totalMonths = this._model[n].Month;
                    this.targetProfit = (double)this._model[n].Total;
                    break;
                }
            }
            this.totalMonths = rentalTime > 0 ? rentalTime : this.totalMonths;
            for (var i = 0; i < 60; i++)
            {
                if (this._model[i].Total > 0)
                {
                    this.breakeven = this._model[i].Month;
                    break;
                }
            }
            this.ROIYear = this.targetProfit / this.totalCost / this.totalMonths * 12;
            this.ROITotal = this.targetProfit / this.totalCost;
        }

    }
}