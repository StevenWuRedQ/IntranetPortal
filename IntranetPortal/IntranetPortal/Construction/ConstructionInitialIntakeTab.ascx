<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialIntakeeTab.ascx.vb" Inherits="IntranetPortal.ConstructionInitialIntakeTab" %>

<div>
    <h4 class="ss_form_title">Property Address</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.BlockLot" pt-init-model="LeadsInfo.Block + '/ ' + LeadsInfo.Lot">
            </li>
            <li class="ss_form_item" style="display: none">
                <label class="ss_form_input_title">BBLE</label>
                <input class="ss_form_input" ng-model="LeadsInfo.BBLE" >
            </li>
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" style="width: 93.3%" ng-model="CSCase.CSCase.InitialIntake.Address" pt-init-model="LeadsInfo.PropertyAddress">
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
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DateAssigned" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DatePurchased" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ADT Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ADT">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.Access">
                    <option value="NA">N/A</option>
                    <option value="lockbox">lockbox</option>
                    <option value="master_key">master key</option>
                    <option value="pad_lock">pad lock</option>
                </select>
            </li>
            <li class="ss_form_item" ng-show="CSCase.CSCase.InitialIntake.Access=='lockbox'">
                <label class="ss_form_input_title">Lock Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.LockCode">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Asset Manager</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AssetManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Manager</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ProjectManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
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
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CorpName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.Addr">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.TaxIdNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.Signor">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadDeed" file-model="CSCase.CSCase.InitialIntake.UploadDeed"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadEIN" file-model="CSCase.CSCase.InitialIntake.UploadEIN"></pt-file>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadFilingReceipt" file-model="CSCase.CSCase.InitialIntake.UploadFilingReceipt"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadArticleOfOperation" file-model="CSCase.CSCase.InitialIntake.UploadArticleOfOperation"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadOperationAgreement" file-model="CSCase.CSCase.InitialIntake.UploadOperationAgreement"></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Building Info<pt-collapse model="CSCase.CSCase.InitialIntake.BuildingInfoCollapsed" /></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">C/O</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CO" pt-init-model="SsCase.PropertyInfo.COClass">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" collapse="CSCase.CSCase.InitialIntake.BuildingInfoCollapsed" ng-init="CSCase.CSCase.InitialIntake.BuildingInfoCollapsed=true">
            <li class="ss_form_item">
                <label class="ss_form_input_title"># of Family</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.FamilyNum" pt-init-model="SsCase.PropertyInfo.NumOfFamilies">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Class</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.BuildingClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.TaxClass" pt-init-model="LeadsInfo.PropertyClass">>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Units</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.TotalUnits" pt-init-model="LeadsInfo.UnitNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Year Built</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.YearBuilt" pt-init-model="LeadsInfo.YearBuilt">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lot Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.LotSize" pt-init-model="LeadsInfo.LotDem">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.BuildingSize" pt-init-model="LeadsInfo.BuildingDem">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.BuildingStories" pt-init-model="LeadsInfo.NumFloors">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CalculatedSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.NycSqft" pt-init-model="LeadsInfo.NYCSqft">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual # Of Unit</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ActualUnitNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ZoningCode" pt-init-model="LeadsInfo.Zoning">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.MaxFAR" pt-init-model="LeadsInfo.MaxFar">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual Far</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ActualFAR" pt-init-model="LeadsInfo.ActualFar">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Landmark</label>
                <pt-radio name="CSCase-InitialIntake-Landmark" model="CSCase.CSCase.InitialIntake.Landmark"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Flood Zone</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.FloodZone">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload GeoData Report</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadGeoDataReport" file-model="CSCase.CSCase.InitialIntake.UploadGeoDataReport"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload C/O</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadCO" file-model="CSCase.CSCase.InitialIntake.UploadCO"></pt-file>
            </li>
        </ul>

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Comps</h4>
    <div class="ss_border">

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Resale Range</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.Comps">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind AM</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CompsRemind" ng-change="ONCHANGE" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Comps</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadComps" file-model="CSCase.CSCase.InitialIntake.UploadComps"></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Search</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.WaterSearch">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Search Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-WaterSearchUpload" file-model="CSCase.CSCase.InitialIntake.WaterSearchUpload"></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <div class="ss_border">
        <span style="color: red">Press Enter To Send Notification!</spa>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind Intake Sheet</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.IntakeSheetRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Intake Sheet</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadIntakeSheet" file-model="CSCase.CSCase.InitialIntake.UploadIntakeSheet"></pt-file>
            </li>
        </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Remind Sketch Layout</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.SketchLayoutRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Upload Sketch Layout</label>
                    <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadSketchLayout" file-model="CSCase.CSCase.InitialIntake.UploadSketchLayout"></pt-file>
                </li>
            </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Remind Initial Budget</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.InitialBudgetRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Upload Initial Budget</label>
                    <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-UploadInitialBudget" file-model="CSCase.CSCase.InitialIntake.UploadInitialBudget"></pt-file>
                </li>
            </ul>
    </div>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Job Type
        <select ng-model="CSCase.CSCase.InitialIntake.JobType1">
            <option value="NA">N/A</option>
            <option value="ALT1">ALT1</option>
            <option value="ALT2">ALT2</option>
            <option value="ALT2_EXT">ALT2 Extension</option>
            <option value="Complated_Demo">Complated Demo</option>
        </select>
        <select ng-model="CSCase.CSCase.InitialIntake.JobType2" ng-show="CSCase.CSCase.InitialIntake.JobType1=='Complated_Demo'">
            <option value="NA">N/A</option>
            <option value="ALT1">ALT1</option>
            <option value="ALT2">ALT2</option>
        </select>
    </h4>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Reports
    <select ng-model="CSCase.CSCase.InitialIntake.ReportsDropDown">
        <option value="NA">N/A</option>
        <option value="Asbestos">Asbestos Report</option>
        <option value="Survey">Survey</option>
        <option value="Exhibit">Exhibit 1 & 3</option>
        <option value="TRs">TR's</option>
    </select></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Asbestos'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.AsbestosRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.AsbestosReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AsbestosVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-AsbestosUpload" file-model="CSCase.CSCase.InitialIntake.AsbestosUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Survey'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.SurveyRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.SurveyReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.SurveyVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-SurveyUpload" file-model="CSCase.CSCase.InitialIntake.SurveyUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Exhibit'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.ExhibitRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.ExhibitReceivedDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ExhibitVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-ExhibitUpload" file-model="CSCase.CSCase.InitialIntake.ExhibitUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='TRs'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.TRsRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.TRsReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.TRsVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-TRsUpload" file-model="CSCase.CSCase.InitialIntake.TRsUpload"></pt-file>
            </li>
        </ul>
    </div>
</div>

