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
                <input class="ss_form_input" type="text" ng-model="Construction.DateAssigned" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="Construction.DatePurchased" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access</label>
                <select class="ss_form_input" ng-model="Construction.Access">
                    <option value="value">lockbox</option>
                    <option value="value">master key</option>
                    <option value="value">pad lock</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ADT Code</label>
                <input class="ss_form_input" ng-model="Construction.ADT">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Asset Manager</label>
                <input class="ss_form_input" ng-model="Construction.AssetManager">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Manager</label>
                <input class="ss_form_input" ng-model="Construction.ProjectManager">
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
                <input class="ss_form_input" ng-model="Construction.CorpName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input" ng-model="Construction.Addr">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input" ng-model="Construction.TaxIdNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input" ng-model="Construction.Signor">
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
                <input class="ss_form_input" ng-model="Construction.CO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title"># of Family</label>
                <input class="ss_form_input" ng-model="Construction.FamilyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Class</label>
                <input class="ss_form_input" ng-model="Construction.BuildingClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input" ng-model="Construction.TaxClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input" ng-model="Construction.BuildingSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input" ng-model="Construction.BuildingStories">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input" ng-model="Construction.CalculatedSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input" ng-model="Construction.NycSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual # Of Unit</label>
                <input class="ss_form_input" ng-model="Construction.ActualUnitNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input" ng-model="Construction.ZoningCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input" ng-model="Construction.MaxFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual Far</label>
                <input class="ss_form_input" ng-model="Construction.ActualFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Landmark</label>
                <pt-radio model="Construction.Landmark" name="Construction.Landmark"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Flood Zone</label>
                <input class="ss_form_input" ng-model="Construction.FloodZone">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-file ng-model="Construction.UploadDeed"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-file ng-model="Construction.UploadEIN"></pt-file>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-file ng-model="Construction.UploadFilingReceipt"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-file ng-model="Construction.UploadArticleOfOperation"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-file ng-model="Construction.UploadOperationAgreement"></pt-file>
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
                <input class="ss_form_input" ng-model="Construction.Comps">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Comps</label>
                <select class="ss_from_input" ng-model="Construction.UploadComps">
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
                <input class="ss_form_input" ng-model="Construction.WaterSearch">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Intake Sheet</label>
                <select class="ss_from_input" ng-model="Construction.IntakeSheet">
                    <option value="value">text</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Sketch Layout</label>
                <pt-file class="ss_form_input" ng-model="Construction.Sketch" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Initial Budget</label>
                <select class="ss_from_input" ng-model="Construction.InitialBudget">
                    <option value="value">text</option>
                </select>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Reports</h4>
    <select ng-model="Construction.ReportsDropDown">
        <option value="Asbestos">Asbestos Report</option>
        <option value="Survey">Survey</option>
        <option value="Exhibit">Exhibit 1 & 3</option>
        <option value="TRs">TR's</option>
    </select>
    <div class="ss_border">
        <ul class="ss_form_box clearfix" ng-show="Construction.ReportsDropDown=='Asbestos'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.AsbestosRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.AsbestosReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.AsbestosVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.ReportsDropDown=='Survey'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.SurveyRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.SurveyReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.SurveyVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.ReportsDropDown=='Exhibit'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.ExhibitRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.ExhibitReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.ExhibitVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="Construction.ReportsDropDown=='TRs'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="Construction.TRsRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="Construction.TRsReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="Construction.TRsVendor">
            </li>
        </ul>

    </div>
</div>