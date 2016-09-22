angular.module("PortalApp").config(function ($stateProvider) {

    var underwriter = {
        name: 'underwriter',
        url: '/underwriter',
        controller: 'UnderwriterController'
    }

    var dataInput = {
        name: 'underwriter.datainput',
        url: '/datainput',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/datainput.tpl.html'
    }
    var flipsheets = {
        name: 'underwriter.flipsheets',
        url: '/flipsheets',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/flipsheets.tpl.html'
    }
    var rentalmodels = {
        name: 'underwriter.rentalmodels',
        url: '/rentalmodels',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/rentalmodels.tpl.html'
    }
    var tables = {
        name: 'underwriter.tables',
        url: '/tables',
        //controller: 'UnderwriterController',
        templateUrl: '/js/Views/Underwriter/tables.tpl.html'
    }

    $stateProvider.state(underwriter)
                    .state(dataInput)
                    .state(flipsheets)
                    .state(rentalmodels)
                    .state(tables);

});

angular.module("PortalApp").controller("UnderwriterController", ['$scope', 'ptCom', 'ptUnderwriter', function ($scope, ptCom, ptUnderwriter) {

    $scope.data = {};
    $scope.uw = ptUnderwriter;

    $scope.init = function (bble, isImport) {
        //ptCom.startLoading()
        $scope.data = ptUnderwriter.load(bble, isImport);
        if ($scope.data.$promise) {
            $scope.data.$promise.then(function () {
                $scope.applyRule();
            }).finally(function () {
                //ptCom.stopLoading()

            })
        } else {
            $scope.applyRule();
        }
        $scope.feedData();
    }


    $scope.feedData = function () {

        $scope.data.PropertyInfo.TaxClass = 'A0',
        $scope.data.PropertyInfo.ActualNumOfUnits = 1
        $scope.data.PropertyInfo.SellerOccupied = true;
        $scope.data.PropertyInfo.PropertyTaxYear = 4297.0;
        $scope.data.DealCosts.HOI = 20000.0;
        $scope.data.DealCosts.AgentCommission = 2500;
        $scope.data.RehabInfo.AverageLowValue = 205166;
        $scope.data.RehabInfo.RenovatedValue = 510000;
        $scope.data.RehabInfo.RepairBid = 75000;
        $scope.data.RehabInfo.DealTimeMonths = 6;

        $scope.data.LienInfo.FirstMortgage = 340000;
        $scope.data.LienInfo.SecondMortgage = 284000;
        $scope.data.LienCosts.PropertyTaxes = 9113.32;
        $scope.data.LienCosts.WaterCharges = 1101.33;
        $scope.data.LienCosts.PersonalJudgements = 14892.09;

    }
    $scope.save = function () {
    }

    $scope.update = function () {
        $scope.applyRule();
    }

    $scope.applyFixedRules = function () {
        var d = $scope.data;

        if (!$scope.fixedRulesApplied) {
            $scope.fixedRulesApplied = 1;

            d.RehabInfo.SalesCommission = 0.05;
            d.RehabInfo.DealROICash = 0.3
            // Insurance Premium
            d.InsurancePremium.From = [35001, 50001, 100001, 500001, 1000001, 5000001, 10000001, 15000001];
            d.InsurancePremium.To = [50000, 100000, 500000, 1000000, 5000000, 10000000, 15000000];
            d.InsurancePremium.OwnersPolicyRate = [.00667, .00543, .00436, .00398, .00366, .00325, .00307, .00276];
            d.InsurancePremium.LoanPolicyRate = [0.00555, 0.00454, 0.00364, 0.00331, 0.00305, 0.00271, 0.00255, 0.00231];
            d.InsurancePremium.CostOwnersPolicy = _.zip(d.InsurancePremium.From, d.InsurancePremium.To, d.InsurancePremium.OwnersPolicyRate)
                                                    .reduce(function (cum, v) {
                                                        var l = cum.length;
                                                        cum[l - 1] = (v[1] - v[0]) * v[2] + cum[l - 1];
                                                        cum[l] = cum[l - 1];
                                                        return cum;
                                                    }, [402])

            d.InsurancePremium.CostLoanPolicy = _.zip(d.InsurancePremium.From, d.InsurancePremium.To, d.InsurancePremium.LoanPolicyRate)
                                                    .reduce(function (cum, v) {
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
            d.Liens.TaxLienSettlement = 0.09 / 12;
            d.Liens.PropertyTaxesSettlement = 1.0;
            d.Liens.WaterChargesSettlement = 1.0;
            d.Liens.HPDChargesSettlement = 1.0;
            d.Liens.ECBDOBViolationsSettlement = 0.35;
            d.Liens.DOBCivilPenaltiesSettlement = 1.0;
            d.Liens.PersonalJudgementsSettlement = 0.4;
            d.Liens.HPDJudgementsSettlement = 0.15;
            d.Liens.RelocationLienSettlement = .09 / 365;
            // Deal Expenses
            d.DealExpenses.HOILienSettlement = 0.75;
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
            d.RentalModel.Insurance = 85;

        }
    };

    $scope.applyRule = function () {
        //debugger;
        var d = $scope.data;
        var float = parseFloat;
        var int = parseInt;

        $scope.applyFixedRules();

        // PropertyInfo
        d.PropertyInfo.PropertyType = (function () { return /.*(A|B|C0|21|R).*/.exec(d.PropertyInfo.TaxClass) ? "Residential" : "Not Residential" })();

        // Liens
        d.Liens.TaxLien = float(d.LienCosts.TaxLienCertificate) * (1.0 + d.Liens.TaxLienSettlement * float(d.RehabInfo.DealTimeMonths));
        d.Liens.PropertyTaxes = float(d.LienCosts.PropertyTaxes) * d.Liens.PropertyTaxesSettlement;
        d.Liens.WaterCharges = float(d.LienCosts.WaterCharges) * d.Liens.WaterChargesSettlement;
        d.Liens.HPDCharges = float(d.LienCosts.HPDCharges) * d.Liens.HPDChargesSettlement;
        d.Liens.ECBDOBViolations = float(d.LienCosts.ECBDOBViolations) * (1.0 + 0.0075 * float(d.RehabInfo.DealTimeMonths)) * d.Liens.ECBDOBViolationsSettlement;
        d.Liens.DOBCivilPenalties = float(d.LienCosts.DOBCivilPenalty) * d.Liens.DOBCivilPenaltiesSettlement;
        d.Liens.PersonalJudgements = float(d.LienCosts.PersonalJudgements) * d.Liens.PersonalJudgementsSettlement;
        d.Liens.HPDJudgements = float(d.LienCosts.HPDJudgements) * d.Liens.HPDJudgementsSettlement;
        d.Liens.IRSNYSTaxLienSettlement = (function () {
            return float(d.LienCosts.IRSNYSTaxLiens) < 12500 ? 1.0 : 0.0
        })();
        d.Liens.IRSNYSTaxLien = float(d.LienCosts.IRSNYSTaxLiens) * d.Liens.IRSNYSTaxLienSettlement;
        d.Liens.RelocationLien = (function () {

            function getTodayDate() {
                return new Date(new Date().toJSON().slice(0, 10));
            }
            if (!d.LienCosts.RelocationLienDate)
                return 0.0;
            else {
                return float(d.LienCosts.RelocationLien) * (1.0 + (getTodayDate().getTime() + 180 * 24 * 60 * 60 * 1000 - new Date(d.LienCosts.RelocationLienDate).getTime()) * d.Liens.RelocationLienSettlement)
            }
        })();
        // DealExpense
        d.DealExpenses.MoneySpent = float(d.DealCosts.MoneySpent);

        d.DealExpenses.HOILien = (function () {
            var c1 = d.PropertyInfo.SellerOccupied;
            var c2 = int(d.PropertyInfo.NumOfTenants) > 0;
            var c3 = !d.LienInfo.FHA;
            var c4 = !d.LienInfo.FannieMae;
            var c5 = !d.LienInfo.FreddieMac;
            var c6 = float(d.DealCosts.HOI) > 0.0;
            debugger;
            return (c1 | c2) & c3 & c4 & c5 & c6 ? float(d.DealCosts.HOI) * d.DealExpenses.HOILienSettlement - 10000.00 : float(d.DealCosts.HOI) * d.DealExpenses.HOILienSettlement;

        })();
        d.DealExpenses.COSTermination = float(d.DealCosts.COSTermination);
        d.DealExpenses.Tenants = float(d.PropertyInfo.NumOfTenants) * 5000.00;
        d.DealExpenses.Agent = float(d.DealCosts.AgentCommission);
        // Construction(Improvement)
        d.Construction.Construction = float(d.RehabInfo.RepairBid);
        d.Construction.Architect = d.Liens.ECBDOBViolations > 4000 ? 10000.0 : 0;
        // CarryingCosts
        d.CarryingCosts.RETaxs = float(d.PropertyInfo.PropertyTaxYear) / 12 * float(d.RehabInfo.DealTimeMonths);
        d.CarryingCosts.Utilities = 150 * Math.pow(float(d.PropertyInfo.ActualNumOfUnits), 2) + 400 * float(d.PropertyInfo.ActualNumOfUnits);

        // Resale
        d.Resale.ProbableResale = float(d.RehabInfo.RenovatedValue);
        d.Resale.Commissions = float(d.Resale.ProbableResale) * float(d.RehabInfo.SalesCommission);
        d.Resale.TransferTax = (function () {
            var pr = parseFloat($scope.data.Resale.ProbableResale);
            var rate;
            if ($scope.data.PropertyInfo.PropertyType == 'Residential') {
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
        d.LoanTerms.LoanAmount = float(d.Resale.ProbableResale) * float(d.LoanTerms.LTV);
        d.CarryingCosts.Insurance = d.LoanTerms.LoanAmount / 100.0 * 0.45 / 12 * float(d.RehabInfo.DealTimeMonths);
        // LoanCosts
        d.LoanCosts.LoanClosingCost = (function () {
            var la = $scope.data.LoanTerms.LoanAmount;
            var rate;
            if ($scope.data.PropertyInfo.PropertyType == 'Residential') {
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
        d.Liens.Sums = d.Liens.TaxLien + d.Liens.PropertyTaxes + d.Liens.WaterCharges + d.Liens.HPDCharges + d.Liens.ECBDOBViolations + d.Liens.DOBCivilPenalties + d.Liens.PersonalJudgements + d.Liens.HPDJudgements + d.Liens.IRSNYSTaxLien + d.Liens.RelocationLien;
        d.Liens.AdditonalCostsSums = d.Liens.WaterCharges + d.Liens.HPDCharges + d.Liens.ECBDOBViolations + d.Liens.DOBCivilPenalties + d.Liens.PersonalJudgements + d.Liens.HPDJudgements + d.Liens.IRSNYSTaxLien + d.Liens.RelocationLien;
        d.DealExpenses.Sums = d.DealExpenses.MoneySpent + d.DealExpenses.HOILien + d.DealExpenses.COSTermination + d.DealExpenses.Tenants + d.DealExpenses.Agent;
        d.ClosingCost.PartialSums = d.ClosingCost.TitleBill + d.ClosingCost.BuyerAttorney
        d.Construction.Sums = d.Construction.Construction + d.Construction.Architect;
        d.CarryingCosts.Sums = d.CarryingCosts.Insurance + d.CarryingCosts.RETaxs + d.CarryingCosts.Utilities;
        d.Resale.Sums = d.Resale.Commissions + d.Resale.TransferTax + d.Resale.Concession + d.Resale.Attorney + d.Resale.NDC;
        d.Liens.LienPayoffs = (d.Resale.ProbableResale - (d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.PartialSums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums) - (d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.PartialSums + d.Construction.Sums + d.CarryingCosts.Sums) * float(d.RehabInfo.DealROICash)) / (float(d.RehabInfo.DealROICash) * 1.0058 + 1.0058);


        // InsurancePremium
        d.InsurancePremium.PurchasePrice = d.Liens.LienPayoffs;
        d.InsurancePremium.LoanAmountDiscounted = d.LoanTerms.LoanAmount >= d.Liens.LienPayoffs ? d.Liens.LienPayoffs : d.LoanTerms.LoanAmount;
        d.InsurancePremium.LoanAmountFullPremium = d.LoanTerms.LoanAmount - d.InsurancePremium.LoanAmountDiscounted;
        d.InsurancePremium.OwnersPolicy = ptUnderwriter.insurancePolicyCalculation(d.InsurancePremium.PurchasePrice, d.InsurancePremium.OwnersPolicyRate, d.InsurancePremium.CostOwnersPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
        d.InsurancePremium.OwnersLoanPolicyDiscounted = ptUnderwriter.insurancePolicyCalculation(d.InsurancePremium.LoanAmountDiscounted, d.InsurancePremium.LoanPolicyRate, d.InsurancePremium.CostLoanPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
        d.InsurancePremium.OwnersLoanPolicyFullPremium = ptUnderwriter.insurancePolicyCalculation(d.InsurancePremium.LoanAmountFullPremium, d.InsurancePremium.LoanPolicyRate, d.InsurancePremium.CostLoanPolicy, d.InsurancePremium.From, d.InsurancePremium.To)
        d.InsurancePremium.TitleInsurance = d.InsurancePremium.OwnersLoanPolicyDiscounted * 1.3 + d.InsurancePremium.OwnersLoanPolicyFullPremium;
        d.ClosingCost.OwnersPolicy = d.InsurancePremium.OwnersPolicy;
        d.ClosingCost.Sums = d.ClosingCost.TitleBill + d.ClosingCost.BuyerAttorney + d.ClosingCost.OwnersPolicy;
        d.LoanCosts.LoanPolicy = d.InsurancePremium.TitleInsurance - d.InsurancePremium.OwnersPolicy;
        d.FlipCalculation.FlipPrice = (d.Resale.ProbableResale - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums) - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums) * d.FlipCalculation.FlipROI) / (d.FlipCalculation.FlipROI * 1 + 1)

        // HOI
        d.LoanCosts.Sums = d.LoanCosts.LoanPolicy + d.LoanCosts.LoanClosingCost + d.LoanCosts.Points + d.LoanCosts.LoanInterest;
        d.HOI.PurchasePriceAllIn = (d.Resale.ProbableResale - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.Resale.Sums + d.LoanCosts.Sums) - (d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums) * d.HOI.Value) / (d.HOI.Value * 1 + 1);
        d.HOI.TotalInvestment = d.HOI.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
        d.HOI.CashRequirement = d.HOI.TotalInvestment - d.LoanTerms.LoanAmount;
        d.HOI.NetProfit = d.Resale.ProbableResale - d.Resale.Sums - d.HOI.TotalInvestment;
        d.HOI.ROILoan = d.HOI.NetProfit / d.HOI.TotalInvestment;

        // Best Case For HOI
        d.HOIBestCase.PurchasePriceAllIn = d.RehabInfo.AverageLowValue + d.Liens.AdditonalCostsSums + d.DealExpenses.Sums - d.DealExpenses.HOILien;
        d.HOIBestCase.TotalInvestment = d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
        d.HOIBestCase.CashRequirement = d.HOIBestCase.TotalInvestment - d.LoanTerms.LoanAmount;
        d.HOIBestCase.NetProfit = d.Resale.ProbableResale - d.Resale.Sums - d.HOIBestCase.TotalInvestment;
        d.HOIBestCase.ROILoan = d.HOIBestCase.NetProfit / d.HOIBestCase.TotalInvestment;

        // Cash Scenario
        d.CashScenario.Purchase_LienPayoffs = d.Liens.LienPayoffs + d.Liens.TaxLien + d.Liens.PropertyTaxes;
        d.CashScenario.Purchase_OffHUDCosts = d.Liens.AdditonalCostsSums;
        d.CashScenario.Purchase_DealCosts = d.DealExpenses.Sums;
        d.CashScenario.Purchase_ClosingCost = d.ClosingCost.Sums;
        d.CashScenario.Purchase_Construction = d.Construction.Sums;
        d.CashScenario.Purchase_CarryingCosts = d.CarryingCosts.Sums;
        d.CashScenario.Purchase_TotalInvestment = d.Liens.Sums + d.DealExpenses.Sums + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums;
        d.CashScenario.Resale_SalePrice = d.Resale.ProbableResale;
        d.CashScenario.Resale_Concession = d.Resale.Concession;
        d.CashScenario.Resale_Commissions = d.Resale.Commissions;
        d.CashScenario.Resale_ClosingCost = d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
        d.CashScenario.Resale_NetProfit = d.CashScenario.Resale_SalePrice - (d.CashScenario.Resale_Concession + d.CashScenario.Resale_Commissions + d.CashScenario.Resale_ClosingCost) - d.CashScenario.Purchase_TotalInvestment;
        d.CashScenario.Time = float(d.RehabInfo.DealTimeMonths);
        d.CashScenario.AllCash = d.CashScenario.Purchase_TotalInvestment;
        d.CashScenario.ROI = d.CashScenario.Resale_NetProfit / d.CashScenario.Purchase_TotalInvestment;
        d.CashScenario.ROIAnnual = d.CashScenario.ROI / d.RehabInfo.DealTimeMonths * 12;
        // Loan Scenario
        d.LoanScenario.Purchase_PurchasePrice = d.Liens.LienPayoffs + d.Liens.TaxLien + d.Liens.PropertyTaxes;
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
        d.LoanScenario.LTV = d.LoanScenario.Purchase_AdditonalCosts / d.LoanScenario.Resale_SalePrice;
        d.LoanScenario.CashRequirement = d.LoanScenario.Resale_SalePrice - d.LoanScenario.LoanAmount;
        d.LoanScenario.ROI = d.LoanScenario.Resale_NetProfit / d.LoanScenario.Purchase_TotalInvestment;
        d.LoanScenario.ROIAnnual = d.LoanScenario.ROI / d.RehabInfo.DealTimeMonths * 12;
        d.LoanScenario.CashROI = d.LoanScenario.NetProfit / d.LoanScenario.CashRequirement;
        d.LoanScenario.CashROIAnnual = d.LoanScenario.CashROI / d.RehabInfo.DealTimeMonths * 12;
        // FlipScenario
        d.FlipScenario.FlipPrice_SalePrice = d.FlipCalculation.FlipPrice;
        d.FlipScenario.Purchase_TotalCost = d.Liens.ProbableResale + d.Liens.Sums + d.DealExpenses.Sums;
        d.FlipScenario.Purchase_PurchasePrice = d.FlipScenario.FlipPrice_SalePrice;
        d.FlipScenario.Purchase_ClosingCost = d.ClosingCost.Sums;
        d.FlipScenario.Purchase_Construction = d.Construction.Sums;
        d.FlipScenario.Purchase_CarryingCosts = d.CarryingCosts.Sums;
        d.FlipScenario.Purchase_TotalInvestment = d.FlipScenario.Purchase_PurchasePrice + d.FlipScenario.Purchase_ClosingCost + d.FlipScenario.Purchase_Construction + d.FlipScenario.Purchase_CarryingCosts;
        d.FlipScenario.Resale_SalePrice = d.Resale.ProbableResale;
        d.FlipScenario.Resale_Concession = d.Resale.Concession;
        d.FlipScenario.Resale_Commissions = d.Resale.Commissions;
        d.FlipScenario.Resale_ClosingCost = d.Resale.TransferTax + d.Resale.Attorney + d.Resale.NDC;
        d.FlipScenario.Resale_NetProfit = d.FlipScenario.Resale_SalePrice - (d.FlipScenario.Purchase_Construction + d.FlipScenario.Purchase_CarryingCosts) - d.FlipScenario.Purchase_TotalInvestment;
        d.FlipScenario.FlipProfit = d.FlipScenario.FlipPrice_SalePrice - d.FlipScenario.Purchase_TotalCost;
        d.FlipScenario.CashRequirement = d.FlipScenario.Purchase_TotalInvestment
        d.FlipScenario.ROI = d.FlipScenario.Resale_NetProfit / d.FlipScenario.Purchase_TotalInvestment;
        // Others 
        d.Others.MaximumLienPayoff = d.Liens.LienPayoffs + d.Liens.TaxLien + d.Liens.PropertyTaxes;
        d.Others.MaximumSSPrice = d.Liens.LienPayoffs + d.Liens.Sums;
        d.Others.MaxHOI = d.HOIBestCase.NetProfit - d.HOI.NetProfit;
        // Minimum Baseline (=Loan)
        d.MinimumBaselineScenario.PurchasePriceAllIn = d.Liens.LienPayoffs + d.Liens.Sums + d.DealExpenses.Sums;
        d.MinimumBaselineScenario.TotalInvestment = d.LoanScenario.Purchase_TotalInvestment;
        d.MinimumBaselineScenario.CashRequirement = d.LoanScenario.CashRequirement;
        d.MinimumBaselineScenario.NetProfit = d.LoanScenario.Resale_NetProfit;
        d.MinimumBaselineScenario.ROI = d.LoanScenario.ROI;
        // Best Case Scenario
        d.BestCaseScenario.PurchasePriceAllIn = float(d.RehabInfo.AverageLowValue) + d.Liens.AdditonalCostsSums + d.DealExpenses.Sums;
        d.BestCaseScenario.TotalInvestment = d.BestCaseScenario.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums;
        d.BestCaseScenario.CashRequirement = d.BestCaseScenario.TotalInvestment - d.LoanTerms.LoanAmount;
        d.BestCaseScenario.NetProfit = d.FlipScenario.Purchase_Purchase - (d.Liens.AdditonalCostsSums + d.DealExpenses.Sums + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums) - (d.BestCaseScenario.PurchasePriceAllIn + d.ClosingCost.Sums + d.Construction.Sums + d.CarryingCosts.Sums + d.LoanCosts.Sums);
        d.BestCaseScenario.ROI = d.BestCaseScenario.NetProfit / d.BestCaseScenario.TotalInvestment
        // Rental Model
        d.RentalModel.DeedPurchase = float(d.RentalInfo.DeedPurchase);
        d.RentalModel.TotalRepairs = float(d.RentalInfo.RepairBidTotal);
        d.RentalModel.AgentCommission = float(d.DealCosts.AgentCommission);
        d.RentalModel.TotalUpfront = d.RentalModel.DeedPurchase + d.RentalModel.TotalRepairs + d.RentalModel.AgentCommission;
        d.RentalModel.Rent = float(d.RentalInfo.MarketRentTotal);
        d.RentalModel.ManagementFee = d.RentalModel.Rent * 0.1;
        d.RentalModel.Maintenance = 50 + (int(d.RentalInfo.NumOfUnits) - 1) * 25;
        d.RentalModel.MiscRepairs = 75 * int(d.RentalInfo.NumOfUnits);
        d.RentalModel.NetMontlyRent = d.RentalModel.Rent - d.RentalModel.ManagementFee - d.RentalModel.Maintenance - d.RentalModel.Insurance - d.RentalModel.MiscRepairs;
        $scope.RentalHelper = new ptUnderwriter.RentalHelper(d.RentalInfo.CurrentlyRented, d.RentalInfo.RentalTime, d.RentalModel);
        d.RentalModel.TotalMonth = $scope.RentalHelper.totalMonth;
        d.RentalModel.CostOfMoney = $scope.RentalHelper.costOfMoney;
        d.RentalModel.TotalCost = $scope.RentalHelper.totalCost;
        d.RentalModel.Breakeven = $scope.RentalHelper.breakeven;
        d.RentalModel.TargetTime = d.RentalModel.TotalMonth;
        d.RentalModel.TargetProfit = $scope.RentalHelper.targetProfit;
        d.RentalModel.ROIYear = $scope.RentalHelper.ROIYear;
        d.RentalModel.ROITotal = $scope.RentalHelper.ROITotal;
    }

}]);
