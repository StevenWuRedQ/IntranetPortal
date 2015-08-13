<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUtilitiesTab.ascx.vb" Inherits="IntranetPortal.ConstructionUtilitiesTab" %>

<div class="ss_form">
    <h4 class="ss_form_title">Utility Company</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item3">
            <div dx-tag-box="{
                dataSource: [{name: 'ConED'},
                            {name: 'Energy Service'},
                            {name: 'National Grid'},
                            {name: 'DEP'},
                            {name: 'MISSING Water Meter'},
                            {name: 'Taxes'},
                            {name: 'ADT'},
                            {name: 'Insurance'}],
                valueExpr: 'name',
                displayExpr: 'name',
                bindingOptions: {values: 'CSCase.CSCase.Utilities.Company'}}">
            </div>
        </li>
    </ul>
</div>

<%-- ConED --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.ConED.Shown=false" ng-show="CSCase.CSCase.Utilities.ConED.Shown">
    <h4 class="ss_form_title">ConED<pt-collapse model="CSCase.CSCase.Utilities.ConED.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.ConED.Collapsed" ng-init="CSCase.CSCase.Utilities.ConED.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DATE</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ConED.Date" ss-date />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.RepName" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio name="CSCase-Utilities-ConED-AccountOpen" model="CSCase.CSCase.Utilities.ConED.AccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy service required</label>
                <pt-radio name="CSCase-Utilities-ConED-EnergyServiceRequired" model="CSCase.CSCase.Utilities.ConED.EnergyServiceRequired"></pt-radio>
            </li>

        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-ConED-Service" model="CSCase.CSCase.Utilities.ConED.Service" true-value="on" false-value="off"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.MeterNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Missing/Damaged Meter</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.MissingMeter">
                    <option value="PLP">PLP</option>
                    <option value="bsmt">bsmt</option>
                    <option value="1st_Fillable">1st Fillable</option>
                    <option value="2nd_Fillable">2nd Fillable</option>
                    <option value="3rd_Fillable">3rd Fillable</option>
                </select>
            </li>
        </ul>
        <div class="cssSlideUp" ng-show="!CSCase.CSCase.Utilities.ConED.Service">
            <div class="arrow_box" style="width: 40%">
                <label class="ss_form_input_title">Service Off Reason</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.ServiceOffReason">
                    <option value="Service_Cut_From_Street">Service Cut From Street</option>
                    <option value="Meter_Locked">Meter Locked</option>
                    <option value="Meter_Mising">Meter Mising</option>
                    <option value="Meter_Damaged">Meter Damaged</option>
                </select>
            </div>
        </div>

        <div class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ConED.Appointments" ss-date>
        </div>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Upload</label>
            <pt-file file-id="CSCase-Utilities-EnergyService-Upload" file-model="CSCase.CSCase.Utilities.ConED.Upload"></pt-file>
        </div>
        <div>
            <label class="ss_form_input_title">Note</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.CSCase.Utilities.ConED.Note"></textarea>
        </div>
    </div>
</div>

<%-- EnergyService --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.EnergyService.Shown=false" ng-show="CSCase.CSCase.Utilities.EnergyService.Shown">
    <h4 class="ss_form_title">Energy Service<pt-collapse model="CSCase.CSCase.Utilities.EnergyService.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.EnergyService.Collapsed" ng-init="CSCase.CSCase.Utilities.EnergyService.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.EnergyService.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Case Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.CaseNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lic Electrician</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.LicElectrician" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Electric permit pulled Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.EnergyService.ElecPermPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City permit pulled date</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.CityPermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Check List Submitted Date</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.DateCheckListSubmitted" ss-date>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy Service</label>
                <pt-radio name="CSCase-Utilities-EnergyService-EnergyServiceCheck" model="CSCase.CSCase.Utilities.EnergyService.EnergyServiceCheck" true-value="on" false-value="off"></pt-radio>
            </li>
        </ul>
        <div class="cssSlideUp" ng-show="!CSCase.CSCase.Utilities.EnergyService.EnergyServiceCheck">
            <div class="arrow_box" style="width: 40%">
                <label class="ss_form_input_title">Service Off Reason</label>
                <select class="ss_form_input">
                    <option value="Street_Turn_On">Street turn on</option>
                    <option value="Upgrade_Service">Upgrade Service</option>
                    <option value="New_Meter">New meter</option>
                </select>
            </div>
        </div>

        <div class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.EnergyService.Appointments" ss-date>
        </div>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Upload</label>
            <pt-file file-id="CSCase-Utilities-EnergyService-Upload" file-model="CSCase.CSCase.Utilities.EnergyService.Upload"></pt-file>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.EnergyService.Notes"></textarea>
        </div>


    </div>
</div>

<%-- NationalGrid --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.NationalGrid.Shown=false" ng-show="CSCase.CSCase.Utilities.NationalGrid.Shown">
    <h4 class="ss_form_title">National Grid<pt-collapse model="CSCase.CSCase.Utilities.NationalGrid.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.NationalGrid.Collapsed" ng-init="CSCase.CSCase.Utilities.NationalGrid.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.NationalGrid.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.RepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio name="CSCase-Utilities-NationalGrid-AccountOpen" model="CSCase.CSCase.Utilities.NationalGrid.AccountOpen"></pt-radio>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-NationalGrid-Service" model="CSCase.CSCase.Utilities.NationalGrid.Service" true-value="on" false-value="off"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.MeterNumber">
            </li>
        </ul>
        <div class="cssSlideUp" ng-show="!CSCase.CSCase.Utilities.NationalGrid.Service">
            <div class="arrow_box" style="width: 40%">
                <label class="ss_form_input_title">Service Off Reason</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.ServiceOffReason">
                    <option value="Service_Cut_From_Street">Service Cut From Street</option>
                    <option value="Meter_Locked">Meter Locked</option>
                    <option value="Meter_Mising">Meter Mising</option>
                    <option value="Meter_Damaged">Meter Damaged</option>
                </select>
            </div>
        </div>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.NationalGrid.Appointments" ss-date>
        </div>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Upload</label>
            <pt-file file-id="CSCase-Utilities-EnergyServiceUpload" file-model="CSCase.CSCase.Utilities.NationalGridUpload"></pt-file>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.NationalGrid.Notes"></textarea>
        </div>

    </div>
</div>

<%-- DEP --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.DEP.Shown=false" ng-show="CSCase.CSCase.Utilities.DEP.Shown">
    <h4 class="ss_form_title">DEP<pt-collapse model="CSCase.CSCase.Utilities.DEP.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.DEP.Collapsed" ng-init="CSCase.CSCase.Utilities.DEP.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.AccountName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.CancellationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-DEP-Service" model="CSCase.CSCase.Utilities.DEP.Service" true-value="on" false-value="off"></pt-radio>
            </li>

        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.MeterNumber">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Lien</label>
                <pt-radio name="CSCase-Utilities-DEP-WaterLien" model="CSCase.CSCase.Utilities.DEP.WaterLien"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="!CSCase.CSCase.Utilities.DEP.WaterLien">
                <label class="ss_form_input_title">Upload Payment Agreement</label>
                <pt-file file-id="CSCase-Utilities-DEP-PaymentAgreement" file-model="CSCase.CSCase.Utilities.DEP.PaymentAgreement"></pt-file>
            </li>
        </ul>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.Appointments" ss-date>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.DEP.Notes"></textarea>
        </div>
    </div>
</div>

<%-- Missing Water Metor--%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.MissingMeter.Shown=false" ng-show="CSCase.CSCase.Utilities.MissingMeter.Shown">
    <h4 class="ss_form_title">Missing Water Meter<pt-collapse model="CSCase.CSCase.Utilities.MissingMeter.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.MissingMeter.Collapsed" ng-init="CSCase.CSCase.Utilities.MissingMeter.Collapsed=true;">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plumber</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter.Plumber" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Permit pulled date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.MissingMeter.PermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Registered Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.MissingMeter.MeterRegisteredDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter.MeterSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tap Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter.TapSize">
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload Letter To DEP</label>
            <pt-file class="ss_form_input" file-id="CSCase-Utilities-MissingMeter-Upload" file-model="CSCase.CSCase.Utilities.MissingMeter.Upload"></pt-file>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.MissingMeter.Notes"></textarea>
        </div>
    </div>
</div>

<%-- Taxes --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.Taxes.Shown=false" ng-show="CSCase.CSCase.Utilities.Taxes.Shown">
    <h4 class="ss_form_title">Taxes<pt-collapse model="CSCase.CSCase.Utilities.Taxes.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.Taxes.Collapsed" ng-init="CSCase.CSCase.Utilities.Taxes.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Type</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.AccountType">
                    <option value="ERP">ERP</option>
                    <option value="Registration">Registration</option>
                    <option value="Tax">Tax</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.NameAccountIsUnder" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.OpenCharges">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien</label>
                <pt-radio name="CSCase-Utilities-Taxes-TaxLien" model="CSCase.CSCase.Utilities.Taxes.TaxLien"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="!CSCase.CSCase.Utilities.Taxes.TaxLien">
                <label class="ss_form_input_title">Upload Payment Agreement</label>
                <pt-file file-id="CSCase-Utilities-Taxes-PaymentAgreement" file-model="CSCase.CSCase.Utilities.Taxes.PaymentAgreement"></pt-file>
            </li>
        </ul>
    </div>
</div>

<%-- ADT --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.ADT.Shown=false" ng-show="CSCase.CSCase.Utilities.ADT.Shown">
    <h4 class="ss_form_title">ADT<pt-collapse model="CSCase.CSCase.Utilities.ADT.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.ADT.Collapsed" ng-init="CSCase.CSCase.Utilities.ADT.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ADT.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT.DateRequest" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Installation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT.InstallationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT.CancellatonDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ADT">
            </li>
        </ul>
    </div>
</div>

<%-- Insurance --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.Insurance.Shown=false" ng-show="CSCase.CSCase.Utilities.Insurance.Shown">
    <h4 class="ss_form_title">Insuracne<pt-collapse model="CSCase.CSCase.Utilities.Insurance.Collapsed" /></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.Insurance.Collapsed" ng-init="CSCase.CSCase.Utilities.Insurance.Collapsed=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Insurance.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Policy Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Insurance.PolicyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Expiration Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance.ExpirationDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance.CancellationDate" ss-date>
            </li>
        </ul>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Renewal Remind</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance.CalenderOption" ss-date>
        </div>
    </div>

</div>
