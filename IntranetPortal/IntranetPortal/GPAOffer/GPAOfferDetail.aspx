<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div ng-controller="GPAOfferDetailController">
        <div id="pre-under-container" class="pre-under-container scrollspy">
            <div class="container pre-under-summary affix-top" data-spy="affix" data-offset-top="148">
                <div style="height: 34px">
                    <span style="height: 34px; font-size: 32px; line-height: 34px">
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'A'">Grade A</span>
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'B'">Grade B</span>
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'C+'">Grade C+</span>
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'C'">Grade C</span>
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'D'">Grade D</span>
                        <span class="grade-font gpa-flip" ng-hide="data.Grade != 'F'">Grade F</span>
                    </span>
                    <div class="btn-group pull-right">
                        <button type="button" class="btn btn-sm btn-red" ng-click="showUserGradeDataList()">Opnion List</button>
                    </div>
                    <div style="display: inline-block; position: absolute; margin: auto;">
                        {{LoadedUserGradeData.title}}
                    </div>
                </div>

                <div id="pre-under-summary-detail" class="pre-under-summary-detail">
                    <div class="indicator-group scrollable" data-href="#bestcase-model-section">
                        <div class="indicator-data">
                            <h3>{{data.BestCaseScenario.ROI | percentage}}</h3>
                            <h6>Best Case ROI</h6>
                        </div>
                    </div>
                    <div class="indicator-group scrollable" data-href="#baseline-model-section">
                        <div class="indicator-data">
                            <h3>{{data.MinimumBaselineScenario.ROI |percentage}} </h3>
                            <h6>Min. Baseline ROI</h6>
                        </div>
                    </div>
                    <div class="indicator-group scrollable" data-href="#flip-model-section">
                        <div class="indicator-data">
                            <h3>{{data.FlipScenario.FlipProfit | currency:"$":0}}</h3>
                            <h6>Flip Profit </h6>
                        </div>
                    </div>
                    <div class="indicator-group scrollable" data-href="#cash-model-section">
                        <div class="indicator-data">
                            <h3>{{data.CashScenario.ROI | percentage}}</h3>
                            <h6>All Cash ROI </h6>
                        </div>
                    </div>
                    <div class="indicator-group">
                        <div class="indicator-data">
                            <h3>{{data.Summary.MaxHOI | currency:"$":0}}</h3>
                            <h6>Max HOI</h6>
                        </div>
                    </div>
                    <div class="indicator-group">
                        <div class="indicator-data">
                            <h3>{{data.Summary.MaximumLienPayoff | currency:"$":0}}</h3>
                            <h6>Max. Lien Payoff</h6>
                        </div>
                    </div>
                    <div class="indicator-group last-child">
                        <div class="indicator-data">
                            <h3>{{data.Summary.MaximumSSPrice |currency:"$":0}} </h3>
                            <h6>Max. SS Price</h6>
                        </div>
                    </div>
                </div>
            </div>
            <div class="container" style="padding-bottom: 50px;">
                <div class="pre-input-section clearfix">
                    <div class="redq-list-nav-panel">
                        <div class="panel-select">
                            <span class="link-red" ng-class="{active:panelState == 0}" ng-click="switchPanel(0)">
                                <i aria-hidden="true" class="fa fa-home item-icon"></i>Property Info
                            </span>
                            <span class="link-red" ng-class="{active:panelState == 1}" ng-click="switchPanel(1)">
                                <i aria-hidden="true" class="fa fa-building item-icon"></i>Rehab Info
                            </span>
                            <span class="link-red " ng-class="{active:panelState == 2}" ng-click="switchPanel(2)">
                                <i aria-hidden="true" class="fa fa-gavel item-icon"></i>Lien Info
                            </span>
                            <span class="link-red" ng-class="{active:panelState == 3}" ng-click="switchPanel(3)">
                                <i aria-hidden="true" class="fa fa-credit-card item-icon"></i>Lien Costs
                            </span>
                            <span class="link-red" ng-class="{active:panelState == 4}" ng-click="switchPanel(4)">
                                <i aria-hidden="true" class="fa fa-retweet item-icon"></i>Rental Info
                            </span>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header"></div>
                        <div class="card-body">
                            <div class="tab-content" ng-if="panelState == 0">
                                <div class="form-group-compact" style="width: 100%">
                                    <label>Property Address</label>
                                    <span class="form-control-compact-content" style="width: calc(99% - 140px)">{{data.PropertyInfo.PropertyAddress}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Property Type</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.PropertyType == 0?'Residential':'Not Residential'}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>CurrentOwner</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.CurrentOwner}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Tax Class</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.TaxClass}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Lot Size</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.LotSize}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Building Dimension</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.BuildingDimension}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Zoning</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.Zoning}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>FAR Actual</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.FARActual | number:2}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>FAR Max</label>
                                    <span class="form-control-compact-content">{{data.PropertyInfo.FARMax | number:2}}
                                    </span>
                                </div>
                                <div class="form-group-compact">
                                    <label>Property Tax (Year)</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content" ng-model="data.PropertyInfo.PropertyTaxYear"
                                        ng-model-options="{debounce: 1000}" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>Actual # of Units</label>
                                    <input class="form-control-compact-content" ng-model="data.PropertyInfo.ActualNumOfUnits"
                                        ng-model-options="{debounce: 1000}" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Occupancy Status
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.PropertyInfo.OccupancyStatus"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{l:'Unknown',v:0},
                                                    {l:'Vacant',v:1},
                                                    {l:'Seller',v:2},
                                                    {l:'Seller + Tenant',v:3},
                                                    {l:'Tenant',v:4},
                                                    {l:'MultipleTenant',v:5}]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Seller Occupied
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.PropertyInfo.SellerOccupied"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        # of Tenants
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.PropertyInfo.NumOfTenants" ng-model-options="{debounce: 1000}" />

                                </div>
                                <div class="form-group-compact">
                                    <label>Landmark</label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.PropertyInfo.Landmark"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>SRO</label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.PropertyInfo.SRO"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                            </div>
                            <div class="tab-content" ng-if="panelState == 1">

                                <div class="form-group-compact">
                                    <label>
                                        Average Low Value
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RehabInfo.AverageLowValue" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Renovated Value
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RehabInfo.RenovatedValue" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Repair Bid
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RehabInfo.RepairBid" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Needs Plans
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.RehabInfo.NeedsPlans"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>
                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Deal Time (Months)
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.RehabInfo.DealTimeMonths" ng-model-options="{debounce: 1000}" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Sales Commission
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">%
                                    </span>
                                    <input class="form-control-compact-content" maskformat="percentage" ng-model="data.RehabInfo.SalesCommission" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Deal ROI (Cash)
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">%
                                    </span>
                                    <input class="form-control-compact-content" maskformat="percentage" ng-model="data.RehabInfo.DealROICash" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>

                            </div>
                            <div class="tab-content" ng-if="panelState == 2">
                                <div class="form-group-compact">
                                    <label>
                                        1st Mortgage
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienInfo.FirstMortgage" ng-model-options="{debounce: 1000}" pt-number-mask="" stpe="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        2nd Mortgage
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienInfo.SecondMortgage" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />
                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        COS Recorded
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.COSRecorded"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Deed Recorded
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.DeedRecorded"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Other Liens
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.OtherLiens"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{l:'No' ,v:0},
                                                                                {l:'Court Order' ,v:1},
                                                                                {l:'Mechanics Lien' ,v:2},
                                                                                {l:'Specific Performance' ,v:3},
                                                                                {l:'Specific Sundry Agreement' ,v:4},
                                                                                {l:'UCC' ,v:6}]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Lis Pendens
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.LisPendens"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        FHA
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.FHA"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Fannie Mae
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.FannieMae"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Freddie Mac
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.FreddieMac"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Servicer
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.LienInfo.Servicer" ng-model-options="{debounce: 1000}" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Foreclosure Index #
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.LienInfo.ForeclosureIndexNum" ng-model-options="{debounce: 1000}" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Foreclosure Status
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienInfo.ForeclosureStatus"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{l:'Not Sure',v:0},
                                                {l:'No Action / Dismissed',v:1},
                                                {l:'Summons &amp; Complaint',v:2},
                                                {l:'Settlement Conference',v:3},
                                                {l:'RJI',v:4},
                                                {l:'Order Of Reference',v:5},
                                                {l:'Judgment Of Foreclosure And Sale',v:6}]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Foreclosure Note
                                    </label>
                                    <input class="form-control-compact-content"
                                        ng-model="data.LienInfo.ForeclosureNote"
                                        ng-model-options="{debounce: 1000}" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Auction Date
                                    </label>
                                    <input class="form-control-compact-content"
                                        ng-model="data.LienInfo.AuctionDate"
                                        ng-model-options="{debounce: 1000}" pt-date="" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Default Date
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.LienInfo.DefaultDate" ng-model-options="{debounce: 1000}" pt-date="" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Current Payoff
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienInfo.CurrentPayoff" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Payoff Date
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.LienInfo.PayoffDate" ng-model-options="{debounce: 1000}" pt-date="" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Current SS Value
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienInfo.CurrentSSValue" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                            </div>
                            <div class="tab-content" ng-if="panelState == 3">
                                <div class="form-group-compact">
                                    <label>
                                        Tax Lien Certificate
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.TaxLienCertificate" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>Property Taxes</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.PropertyTaxes" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>Water Charges</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content"
                                        isvalidate="" maskformat="money"
                                        ng-model="data.LienCosts.WaterCharges"
                                        ng-model-options="{debounce: 1000}"
                                        pt-number-mask="" step="0.01" type="number" />
                                </div>
                                <div class="form-group-compact">
                                    <label>ECB City Pay</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content"
                                        isvalidate="" maskformat="money"
                                        ng-model="data.LienCosts.ECBCityPay"
                                        ng-model-options="{debounce: 1000}"
                                        pt-number-mask="" step="0.01" type="number" />
                                </div>
                                <div class="form-group-compact">
                                    <label>DOB Civil Penalty</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content"
                                        isvalidate="" maskformat="money"
                                        ng-model="data.LienCosts.DOBCivilPenalty"
                                        ng-model-options="{debounce: 1000}"
                                        pt-number-mask="" step="0.01" type="number" />
                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        HPD Charges
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.HPDCharges" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        HPD Judgements
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.HPDJudgements" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Personal Judgements
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.PersonalJudgements" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        NYS Tax Warrants
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.NYSTaxWarrants" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Federal Tax Liens
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.FederalTaxLien" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Sidewalk Liens
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienCosts.SidewalkLiens"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Parking Violations
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.ParkingViolation" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Transit Authority
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.TransitAuthority" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Vacate Order
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienCosts.VacateOrder"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Relocation Lien
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.LienCosts.IsRelocationLien"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>
                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Relocation Lien Amount
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.LienCosts.RelocationLien" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />
                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Relocation Lien Date
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.LienCosts.RelocationLienDate" ng-model-options="{debounce: 1000}" pt-date="" />

                                </div>
                            </div>
                            <div class="tab-content" ng-if="panelState == 4">
                                <div class="form-group-compact">
                                    <label>
                                        Deed Purchase
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RentalInfo.DeedPurchase" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Currently Rented
                                    </label>
                                    <select class="form-control-compact-content"
                                        ng-model="data.RentalInfo.CurrentlyRented"
                                        ng-model-options="{debounce: 1000}"
                                        ng-options="o.v as o.l for o in [{ l: 'No', v: false }, { l: 'Yes', v: true }]">
                                    </select>

                                </div>
                                <div class="form-group-compact">
                                    <label>Repair Bid Total</label>
                                    <span class="input-group-addon" id="basic-addon1">$</span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RentalInfo.RepairBidTotal" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        # of Units
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.RentalInfo.NumOfUnits" ng-model-options="{debounce: 1000}" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Market Rent Total
                                    </label>
                                    <span class="input-group-addon" id="basic-addon1">$
                                    </span>
                                    <input class="form-control-compact-content" isvalidate="" maskformat="money" ng-model="data.RentalInfo.MarketRentTotal" ng-model-options="{debounce: 1000}" pt-number-mask="" step="0.01" type="number" />

                                </div>
                                <div class="form-group-compact">
                                    <label>
                                        Rental Time
                                    </label>
                                    <input class="form-control-compact-content" ng-model="data.RentalInfo.RentalTime" ng-model-options="{debounce: 1000}" type="number" />

                                </div>
                            </div>
                        </div>
                        <div class="card-footer"></div>
                    </div>
                </div>
                <div class="pre-under-detail">
                    <div id="bestcase-model-section" class="card">
                        <div class="card-header">
                            <h4>BEST CASE SCENARIO</h4>
                            <span class="pre-under-detail-collaspe-button" data-rmd-action="collapse">Collapse&nbsp;<i class="fa fa-chevron-up" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="card-body collapse in">
                            <ul class="compact striped">
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI (Loan)</span>
                                    <span class="pre-under-detail-content">{{data.BestCaseScenario.ROI | percentage}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Purchase Price (All In)</span>
                                    <span class="pre-under-detail-content">{{data.BestCaseScenario.PurchasePriceAllIn |currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Investment</span>
                                    <span class="pre-under-detail-content">{{data.BestCaseScenario.TotalInvestment | currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cash Requirement</span>
                                    <span class="pre-under-detail-content">{{data.BestCaseScenario.CashRequirement | currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Net Profit</span>
                                    <span class="pre-under-detail-content">{{data.BestCaseScenario.NetProfit | currency}}</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div id="baseline-model-section" class="card">
                        <div class="card-header">
                            <h4>MINIMUM BASELINE SCENARIO</h4>
                            <span class="pre-under-detail-collaspe-button" data-rmd-action="collapse">Collapse&nbsp;<i class="fa fa-chevron-up" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="card-body collapse in">
                            <ul class="compact striped">
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI (Loan)</span>
                                    <span class="pre-under-detail-content">{{data.MinimumBaselineScenario.ROI |percentage}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Purchase Price (All In)</span>
                                    <span class="pre-under-detail-content">{{data.MinimumBaselineScenario.PurchasePriceAllIn | currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Investment</span>
                                    <span class="pre-under-detail-content">{{data.MinimumBaselineScenario.TotalInvestment | currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cash Requirement</span>
                                    <span class="pre-under-detail-content">{{data.MinimumBaselineScenario.CashRequirement |currency}}</span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Net Profit</span>
                                    <span class="pre-under-detail-content">{{data.MinimumBaselineScenario.NetProfit| currency}}</span>
                                </li>
                            </ul>

                            <div class="pt-panel collapse" id="loan-information">
                                <h4>Loan Information</h4>
                                <ul class="compact striped">
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Resale Price(s) </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.ResaleSalePrice | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Time (Months) </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.Time}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Loan Amount </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.LoanAmount | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">LTV </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.LTV | percentage}} </span>
                                    </li>

                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Additonal Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseAdditonalCosts | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Deal Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseDealCosts | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Purchase Closing Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseClosingCost | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Construction </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseConstruction | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Carrying Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseCarryingCosts | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Loan Closing Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseLoanClosingCost | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Loan Interest </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.PurchaseLoanInterest | currency}} </span>
                                    </li>

                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Concession </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.ResaleConcession | currency}} </span>
                                    </li>
                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Commissions </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.ResaleCommissions | currency}} </span>
                                    </li>

                                    <li class="pre-under-detail-item">
                                        <span class="pre-under-detail-label">Resale Closing Costs </span>
                                        <span class="pre-under-detail-content">{{data.LoanScenario.ResaleClosingCost | currency}} </span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="card-footer">
                            <span class="btn btn-noboder pull-right text-strong" style="font-weight: 500"
                                data-rmd-action="collapse" data-rmd-target="#loan-information">View More <i class="fa fa-chevron-up view-more-arrow"></i>
                            </span>
                        </div>
                    </div>
                    <div id="flip-model-section" class="card">
                        <div class="card-header">
                            <h4>FLIP SCENARIO</h4>
                            <span class="pre-under-detail-collaspe-button" data-rmd-action="collapse">Collapse&nbsp;<i class="fa fa-chevron-up" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="card-body collapse in">
                            <ul class="compact striped">
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Flip Profit </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.FlipProfit | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Flip Price </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.FlipPriceSalePrice | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Cost </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchaseTotalCost | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Investment: </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchaseTotalInvestment | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Net Profit: </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ResaleNetProfit | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Purchase Price </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchasePurchasePrice | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Resale Price </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ResaleSalePrice | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Closing Costs </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchaseClosingCost | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Construction </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchaseConstruction | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Carrying Costs </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.PurchaseCarryingCosts | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Concession </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ResaleConcession | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Commissions </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ResaleCommissions | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Closing Costs </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ResaleClosingCost | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cash Required </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.CashRequirement | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI </span>
                                    <span class="pre-under-detail-content">{{data.FlipScenario.ROI | percentage}} </span>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div id="cash-model-section" class="card">
                        <div class="card-header">
                            <h4>ALL CASH SCENARIO</h4>
                            <span class="pre-under-detail-collaspe-button" data-rmd-action="collapse">Collapse&nbsp;<i class="fa fa-chevron-up" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="card-body collapse in">
                            <ul class="compact striped">
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ROI| percentage}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Investment: </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseTotalInvestment| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cash Required </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.CashRequired| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Net Profit: </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ResaleNetProfit| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Time (Months) </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.Time}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Lien Payoff(s) </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseLienPayoffs| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Off HUD Costs </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseOffHUDCosts| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Deal Costs </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseDealCosts| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Purchase Closing Costs </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseClosingCost| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Construction </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseConstruction| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Carrying Costs </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.PurchaseCarryingCosts| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Concession </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ResaleConcession| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Commissions </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ResaleCommissions| currency}} </span>
                                </li>

                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Resale Price </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ResaleSalePrice| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Resale Closing Costs </span>
                                    <span class="pre-under-detail-content">{{data.CashScenario.ResaleClosingCost| currency}} </span>
                                </li>
                            </ul>

                        </div>
                    </div>
                    <div id="rental-model-section" class="card">
                        <div class="card-header">
                            <h4>RENTAL SCENARIO</h4>
                            <span class="pre-under-detail-collaspe-button" data-rmd-action="collapse">Collapse&nbsp;<i class="fa fa-chevron-up" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="card-body collapse in">
                            <ul class="compact striped">
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI (Total) </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.ROITotal | percentage}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">ROI (Year) </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.ROIYear | percentage}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Breakeven (Month) </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.Breakeven}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Target Time </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TargetTime}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Target Profit </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TargetProfit| currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Cost </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TotalCost | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cost of Money : </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.CostOfMoneyRate | percentage}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Min ROI: </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.MinROI | percentage}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Months: </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TotalMonth}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Upfront Cost</span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TotalUpfront | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Net Monthly Rent</span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.NetMontlyRent | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Deed Purchase </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.DeedPurchase | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Rent </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.Rent | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Total Repairs </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.TotalRepairs | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Mgt Fee (10%) </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.ManagementFee | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Agent Commission </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.AgentCommission | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Insurance </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.Insurance | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Maintenance </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.Maintenance | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Cost of Money </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.CostOfMoney | currency}} </span>
                                </li>
                                <li class="pre-under-detail-item">
                                    <span class="pre-under-detail-label">Misc Repairs </span>
                                    <span class="pre-under-detail-content">{{data.RentalModel.MiscRepairs | currency}} </span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="grading-modal" class="modal fade modal-nopadding">
            <div class="modal-dialog modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 style="display: inline-block">{{modalTitle}}</h3>
                        <i class="fa fa-times modal-close-btn" data-dismiss="modal"></i>
                    </div>
                    <div class="modal-body">
                        <div ng-show="modalMode == 0">
                            <div class="form-control">
                                <label class="col-sm-3" for="form-comments">Title: </label>
                                <input class="col-sm-8" id="form-comments" type="text" ng-model="form.title" />
                            </div>
                            <div class="form-control">
                                <label class="col-sm-3" for="form-comments">Offer: </label>
                                <input class="col-sm-8" id="form-comments" type="number" ng-model="form.offer" />
                            </div>
                            <div class="form-control">
                                <label class="col-sm-3" for="form-comments">Comments: </label>
                                <input class="col-sm-8" id="form-comments" type="text" ng-model="form.comments" />
                            </div>
                        </div>
                        <div ng-show="modalMode == 1">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Created Date</th>
                                        <th>Offer Price</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr ng-repeat="l in userGradeDataList">
                                        <td><span>{{l.title}}</span></td>
                                        <td>{{l.createdDate|date:'medium'}}</td>
                                        <td>{{l.offerPrice|currency}}</td>
                                        <td>
                                            <button class="btn btn-red btn-gpa pull-right" ng-click="loadUserGradeData(l.id)">Load</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-red btn-gpa pull-right"
                            ng-show="modalMode == 0" ng-click="saveOrUpdateUserGradeData()">
                            {{form.title && loadedUserGradeData.title == form.title? 'Update': 'Save'}} Opinion</button>
                        <button type="button" class="btn btn-red btn-gpa pull-right"
                            ng-show="modalMode == 0" ng-click="makeOffer()" uib-tooltip="Save offer to Portal.">
                            Make Offer</button>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
