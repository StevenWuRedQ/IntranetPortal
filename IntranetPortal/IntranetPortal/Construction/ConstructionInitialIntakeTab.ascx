<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialIntakeeTab.ascx.vb" Inherits="IntranetPortal.ConstructionInitialIntakeTab" %>

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
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.DateAssigned" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.DatePurchased" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access</label>
                <select class="ss_form_input" ng-model="CSCase.InitialIntake.Access">
                    <option value=""></option>
                    <option value="lockbox">lockbox</option>
                    <option value="master_key">master key</option>
                    <option value="pad_lock">pad lock</option>
                </select>
            </li>
            <li class="ss_form_item" ng-show="CSCase.InitialIntake.Access=='lockbox'">
                <label class="ss_form_input_title">ADT Code</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ADT">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Asset Manager</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.AssetManager">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Manager</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ProjectManager">
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
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.CorpName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.Addr">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.TaxIdNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.Signor">
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
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.CO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title"># of Family</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.FamilyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Class</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.BuildingClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.TaxClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.BuildingSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.BuildingStories">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.CalculatedSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.NycSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual # Of Unit</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ActualUnitNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ZoningCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.MaxFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual Far</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ActualFAR">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Landmark</label>
                <pt-radio model="CSCase.InitialIntake.Landmark" name="CSCase.InitialIntake.Landmark"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Flood Zone</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.FloodZone">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-file ng-model="CSCase.InitialIntake.UploadDeed"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-file ng-model="CSCase.InitialIntake.UploadEIN"></pt-file>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-file ng-model="CSCase.InitialIntake.UploadFilingReceipt"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-file ng-model="CSCase.InitialIntake.UploadArticleOfOperation"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-file ng-model="CSCase.InitialIntake.UploadOperationAgreement"></pt-file>
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
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.Comps">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Comps</label>
                <select class="ss_from_input" ng-model="CSCase.InitialIntake.UploadComps">
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
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.WaterSearch">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Intake Sheet</label>
                <select class="ss_from_input" ng-model="CSCase.InitialIntake.IntakeSheet">
                    <option value="value">text</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Sketch Layout</label>
                <pt-file class="ss_form_input" ng-model="CSCase.InitialIntake.Sketch" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Initial Budget</label>
                <select class="ss_from_input" ng-model="CSCase.InitialIntake.InitialBudget">
                    <option value="value">text</option>
                </select>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Reports</h4>
    <select ng-model="CSCase.InitialIntake.ReportsDropDown">
        <option value="Asbestos">Asbestos Report</option>
        <option value="Survey">Survey</option>
        <option value="Exhibit">Exhibit 1 & 3</option>
        <option value="TRs">TR's</option>
    </select>
    <div class="ss_border">
        <ul class="ss_form_box clearfix" ng-show="CSCase.InitialIntake.ReportsDropDown=='Asbestos'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.AsbestosRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.AsbestosReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.AsbestosVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.InitialIntake.ReportsDropDown=='Survey'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.SurveyRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.SurveyReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.SurveyVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.InitialIntake.ReportsDropDown=='Exhibit'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.ExhibitRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.ExhibitReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.ExhibitVendor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.InitialIntake.ReportsDropDown=='TRs'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.TRsRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.InitialIntake.TRsReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input class="ss_form_input" ng-model="CSCase.InitialIntake.TRsVendor">
            </li>
        </ul>

    </div>
</div>