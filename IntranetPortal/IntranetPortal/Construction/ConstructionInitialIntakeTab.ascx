<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialIntakeTab.ascx.vb" Inherits="IntranetPortal.ConstructionInitialIntakeTab" %>

<div>
    <h4 class="ss_form_title">Property Address</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" readonly ng-value="SsCase.LeadsInfo.Block?SsCase.LeadsInfo.Block +'/'+SsCase.LeadsInfo.Lot:''">
            </li>
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" readonly ng-value="SsCase.LeadsInfo.PropertyAddress" style="width: 93.5%;">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title"></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Assigned</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.DateAssigned" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.DatePurchased" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access</label>
                <select class="ss_form_input" ng-model="Construction.InitialIntak.Access">
                    <option value=""></option>
                    <option value="lockbox">lockbox</option>
                    <option value="master_key">master key</option>
                    <option value="pad_lock">pad lock</option>
                </select>
            </li>
            <li class="ss_form_item" ng-show="Construction.InitialIntak.Access=='lockbox'">
                <label class="ss_form_input_title">ADT Code</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ADT">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Asset Manager</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.AssetManager">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Manager</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ProjectManager">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Owner</h4>
    <div class="ss_border">

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Name</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.CorpName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.Addr">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.TaxIdNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.Signor">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Building Info</h4>
    <div class="ss_border">

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">C/O</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.CO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title"># of Family</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.FamilyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Class</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.BuildingClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.TaxClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.BuildingSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.BuildingStories">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.CalculatedSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.NycSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual # Of Unit</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ActualUnitNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ZoningCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.MaxFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual Far</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ActualFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Landmark</label>
                <pt-radio model="Construction.InitialIntak.Landmark" name="Construction.InitialIntak.Landmark"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Flood Zone</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.FloodZone">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-file ng-model="Construction.InitialIntak.UploadDeed"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-file ng-model="Construction.InitialIntak.UploadEIN"></pt-file>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-file ng-model="Construction.InitialIntak.UploadFilingReceipt"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-file ng-model="Construction.InitialIntak.UploadArticleOfOperation"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-file ng-model="Construction.InitialIntak.UploadOperationAgreement"></pt-file>
            </li>


        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Comps</h4>
    <div class="ss_border">

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Comps</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.Comps">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Comps</label>
                <select class="ss_from_input" ng-model="Construction.InitialIntak.UploadComps">
                    <option value="value">text</option>
                </select>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Search</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.WaterSearch">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Intake Sheet</label>
                <select class="ss_from_input" ng-model="Construction.InitialIntak.IntakeSheet">
                    <option value="value">text</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Sketch Layout</label>
                <pt-file class="ss_form_input" ng-model="Construction.InitialIntak.Sketch" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Initial Budget</label>
                <select class="ss_from_input" ng-model="Construction.InitialIntak.InitialBudget">
                    <option value="value">text</option>
                </select>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Reports</h4>
    <select ng-model="Construction.InitialIntak.ReportsDropDown">
        <option value="Asbestos">Asbestos Report</option>
        <option value="Survey">Survey</option>
        <option value="Exhibit">Exhibit 1 & 3</option>
        <option value="TRs">TR's</option>
    </select>
    <div class="ss_border">
        <ul class="ss_form_box clearfix" ng-show="Construction.InitialIntak.ReportsDropDown=='Asbestos'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.AsbestosRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.AsbestosReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.AsbestosVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.InitialIntak.ReportsDropDown=='Survey'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.SurveyRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.SurveyReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.SurveyVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.InitialIntak.ReportsDropDown=='Exhibit'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.ExhibitRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.ExhibitReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.ExhibitVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.InitialIntak.ReportsDropDown=='TRs'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.TRsRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.InitialIntak.TRsReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.InitialIntak.TRsVendor">
            </li>
        </ul>

    </div>
</div>