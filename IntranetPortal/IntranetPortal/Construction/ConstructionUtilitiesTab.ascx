<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUtilitiesTab.ascx.vb" Inherits="IntranetPortal.ConstructionUtilitiesTab" %>

<div class="ss_form" ng-init="">
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

<div class="ss_form" ng-init="CSCase.CSCase.Utilities.ConED_Shown=false" ng-show="CSCase.CSCase.Utilities.ConED_Shown">
    <h4 class="ss_form_title">ConED&nbsp;<pt-collapse model="ReloadedData.ConED_Collapsed" /></h4>
    <div class="ss_border">
        <tabset class="tab-switch">
        <tab ng-repeat="floor in CSCase.CSCase.Utilities.Floors" active="floor.active" disable="floor.disabled" >
        <tab-heading>Floor {{floor.FloorNum}}</tab-heading>       
<div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="arrayRemove(CSCase.CSCase.Utilities.Floors, $index, true)" title="Delete"></i></div>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Floor #</label>
            <input class="ss_form_input intakeCheck" ng-model="floor.FloorNum">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Account Number</label>
            <input class="ss_form_input" ng-model="floor.ConED.AccountNum">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">DATE</label>
            <input class="ss_form_input intakeCheck" type="text" ng-model="floor.ConED.Date" ss-date />
        </li>
    </ul>
    <ul class="ss_form_box clearfix" collapse="ReloadedData.ConED_Collapsed">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Rep Name</label>
            <input class="ss_form_input intakeCheck" ng-model="floor.ConED.RepName" />
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Account Open</label>
            <pt-radio name="ConED-AccountOpen{{$index}}" model="floor.ConED.AccountOpen"></pt-radio>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Energy service required</label>
            <pt-radio class="intakeCheck" name="ConED-EnergyServiceRequired{{$index}}" model="CSCase.CSCase.Utilities.ConED_EnergyServiceRequired"></pt-radio>
        </li>
        <li class="clearfix" style="list-style: none"></li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Service</label>
            <pt-radio class="intakeCheck" name="ConED-Service{{$index}}" model="floor.ConED.Service" true-value="on" false-value="off"></pt-radio>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Meter Number</label>
            <input class="ss_form_input intakeCheck" ng-model="floor.ConED.MeterNum">
        </li>
        <li class="ss_form_item" ng-show="CSCase.CSCase.Utilities.ConED_EnergyServiceRequired">
            <label class="ss_form_input_title">Missing/Damaged Meter</label>
            <select class="ss_form_input" ng-model="floor.ConED.MissingMeter">
                <option value="NA">N/A</option>
                <option value="PLP">PLP</option>
                <option value="bsmt">bsmt</option>
                <option value="1st_Fillable">1st Fillable</option>
                <option value="2nd_Fillable">2nd Fillable</option>
                <option value="3rd_Fillable">3rd Fillable</option>
            </select>
        </li>
        <li class="clearfix" style="list-style: none"></li>
        <li class="ss_form_item_line">
        <div class="cssSlideUp" ng-show="!floor.ConED.Service">
            <div class="arrow_box" style="width: 40%">
                <label class="ss_form_input_title">Service Off Reason</label>
                <select class="ss_form_input" ng-model="floor.ConED.ServiceOffReason">
                    <option value="NA">N/A</option>
                    <option value="Service_Cut_From_Street">Service Cut From Street</option>
                    <option value="Meter_Locked">Meter Locked</option>
                    <option value="Meter_Mising">Meter Mising</option>
                    <option value="Meter_Damaged">Meter Damaged</option>
                </select>
            </div>
        </div>
        </li>
        <li class="clearfix" style="list-style: none"></li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="floor.ConED.Appointments" ss-date>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Appointments Time</label>
            <timepicker show-spinners="false" ng-model="floor.ConED.AppointmentsTime"></timepicker>
        </li>
        <li class="clearfix" style="list-style: none"></li>
        <li class="ss_form_item_line">
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="EnergyService-Upload{{$index}}" base-folder="EnergyService-Upload{{$index}}" file-model="floor.ConED.Upload"></pt-files>
        </li>
        <li class="clearfix" style="list-style: none"></li>
        <li class="ss_form_item_line">
            <label class="ss_form_input_title">Note</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="floor.ConED.Note"></textarea>
        </li>
        <li class="clearfix" style="list-style: none"></li>
    </ul>
    </tab>
    <pt-add ng-click="ensurePush('CSCase.CSCase.Utilities.Floors', {FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {}})" style="font-size: 18px"></pt-add>
    </tabset>
    </div>
</div>


<%-- EnergyService --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.EnergyService_Shown=false" ng-show="CSCase.CSCase.Utilities.EnergyService_Shown">
    <h4 class="ss_form_title">Energy Service&nbsp;<pt-collapse model="ReloadedData.EnergyService_Collapsed" /></h4>
    <div class="ss_border">
        <tabset class="tab-switch">
        <tab ng-repeat="floor in CSCase.CSCase.Utilities.Floors" active="floor.active" disable="floor.disabled" >
        <tab-heading>Floor {{floor.FloorNum}}</tab-heading>
        <div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="arrayRemove(CSCase.CSCase.Utilities.Floors, $index, true)" title="Delete"></i></div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="floor.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="floor.EnergyService.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="floor.EnergyService.Date" ss-date>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" collapse="ReloadedData.EnergyService_Collapsed">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Case Number</label>
                <input class="ss_form_input" ng-model="floor.EnergyService.CaseNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lic Electrician</label>
                <input type="text" class="ss_form_input" ng-model="floor.EnergyService.LicElectrician" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Electric permit pulled Date</label>
                <input class="ss_form_input" type="text" ng-model="floor.EnergyService.ElecPermPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City permit pulled date</label>
                <input class="ss_form_input" ng-model="floor.EnergyService.CityPermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Check List Submitted Date</label>
                <input class="ss_form_input" ng-model="floor.EnergyService.DateCheckListSubmitted" ss-date>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy Service</label>
                <pt-radio name="EnergyService-EnergyServiceCheck{{$index}}" model="floor.EnergyService.Service" true-value="on" false-value="off"></pt-radio>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <div class="cssSlideUp" ng-show="!floor.EnergyService.Service">
                    <div class="arrow_box" style="width: 40%">
                        <label class="ss_form_input_title">Service Off Reason</label>
                        <select class="ss_form_input" ng-model="floor.EnergyService.ServiceOffReason">
                            <option value="NA">N/A</option>
                            <option value="Street_Turn_On">Street turn on</option>
                            <option value="Upgrade_Service">Upgrade Service</option>
                            <option value="New_Meter">New meter</option>
                        </select>
                    </div>
                </div>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="floor.EnergyService.Appointments" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments Time</label>
                <timepicker show-spinners="false" ng-model="floor.EnergyService.AppointmentsTime"></timepicker>
            </li>
            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <label class="ss_form_input_title">Upload</label>
                <pt-files file-bble="CSCase.BBLE" file-id="EnergyService-Upload{{$index}}" base-folder="EnergyService-Upload{{$index}}" file-model="floor.EnergyService.Upload"></pt-files>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="floor.EnergyService.Notes"></textarea>
            </li>
            <li class="clearfix" style="list-style: none"></li>
        </ul>

        </tab>
        <pt-add ng-click="ensurePush('CSCase.CSCase.Utilities.Floors', {FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {}})" style="font-size: 18px"></pt-add>
        </tabset>
    </div>
</div>

<%-- NationalGrid --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.NationalGrid_Shown=false" ng-show="CSCase.CSCase.Utilities.NationalGrid_Shown">
    <h4 class="ss_form_title">National Grid&nbsp;<pt-collapse model="ReloadedData.NationalGrid_Collapsed" /></h4>
    <div class="ss_border">
        <tabset class="tab-switch">
        <tab ng-repeat="floor in CSCase.CSCase.Utilities.Floors" active="floor.active" disable="floor.disabled" >
        <tab-heading>Floor {{floor.FloorNum}}</tab-heading>
        <div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="arrayRemove(CSCase.CSCase.Utilities.Floors, $index, true)" title="Delete"></i></div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="floor.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="floor.NationalGrid.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input intakeCheck" type="text" ng-model="floor.NationalGrid.Date" ss-date>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" collapse="ReloadedData.NationalGrid_Collapsed">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input intakeCheck" ng-model="floor.NationalGrid.RepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio class="intakeCheck" name="NationalGrid-AccountOpen{{$index}}" model="floor.NationalGrid.AccountOpen"></pt-radio>
            </li>
            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio class="intakeCheck" name="NationalGrid-Service{{$index}}" model="floor.NationalGrid.Service" true-value="on" false-value="off"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input intakeCheck" ng-model="floor.NationalGrid.MeterNumber">
            </li>
            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <div class="cssSlideUp" ng-show="!floor.NationalGrid.Service">
                    <div class="arrow_box" style="width: 40%">
                        <label class="ss_form_input_title">Service Off Reason</label>
                        <select class="ss_form_input" ng-model="floor.NationalGrid.ServiceOffReason">
                            <option value="NA">N/A</option>
                            <option value="Service_Cut_From_Street">Service Cut From Street</option>
                            <option value="Meter_Locked">Meter Locked</option>
                            <option value="Meter_Mising">Meter Mising</option>
                            <option value="Meter_Damaged">Meter Damaged</option>
                        </select>
                    </div>
                </div>
            </li>


            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="floor.NationalGrid.Appointments" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments Time</label>
                <timepicker show-spinners="false" ng-model="floor.NationalGrid.AppointmentsTime"></timepicker>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <label class="ss_form_input_title">Upload</label>
                <pt-files file-bble="CSCase.BBLE" file-id="EnergyService_Upload{{$index}}" base-folder="EnergyService_Upload{{$index}}" file-model="floor.NationalGrid.Upload"></pt-files>
            </li>

            <li class="clearfix" style="list-style: none"></li>
            <li class="ss_form_item_line">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="floor.NationalGrid.Notes"></textarea>
            </li>
            <li class="clearfix" style="list-style: none"></li>
        </ul>
        </tab>
        <pt-add ng-click="ensurePush('CSCase.CSCase.Utilities.Floors', {FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {}})" style="font-size: 18px"></pt-add>
        </tabset>
    </div>
</div>

<%-- DEP --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.DEP_Shown=false" ng-show="CSCase.CSCase.Utilities.DEP_Shown">
    <h4 class="ss_form_title">DEP&nbsp;<pt-collapse model="ReloadedData.DEP_Collapsed" /></h4>
    <div class="ss_border" collapse="ReloadedData.DEP_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP_AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP_Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP_AccountName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP_OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP_CancellationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-DEP-Service" model="CSCase.CSCase.Utilities.DEP_Service" true-value="on" false-value="off"></pt-radio>
            </li>

        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP_MeterNumber">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Lien</label>
                <pt-radio name="CSCase-Utilities-DEP-WaterLien" model="CSCase.CSCase.Utilities.DEP_WaterLien"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="CSCase.CSCase.Utilities.DEP_WaterLien">
                <label class="ss_form_input_title">Upload Payment Agreement</label>
                <pt-file file-bble="CSCase.BBLE" file-id="CSCase-Utilities-DEP-PaymentAgreement" file-model="CSCase.CSCase.Utilities.DEP_PaymentAgreement"></pt-file>
            </li>
        </ul>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Appointments</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP_Appointments" ss-date>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.DEP_Notes"></textarea>
        </div>
    </div>
</div>

<%-- Missing Water Metor--%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.MissingMeter_Shown=false" ng-show="CSCase.CSCase.Utilities.MissingMeter_Shown">
    <h4 class="ss_form_title">Missing Water Meter&nbsp;<pt-collapse model="ReloadedData.MissingMeter_Collapsed" /></h4>
    <div class="ss_border" collapse="ReloadedData.MissingMeter_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter_AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plumber</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter_Plumber" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Permit pulled date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.MissingMeter_PermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Registered Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.MissingMeter_MeterRegisteredDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter_MeterSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tap Size</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.MissingMeter_TapSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload plumbers invoice</label>
                <pt-file file-bble='CSCase.BBLE' file-id="CSCase_Utilities_MissingMeter_UploadPlumbersInvoice" file-model="CSCase.CSCase.Utilities.MissingMeter_PlumbersInvoice"></pt-file>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload Letter To DEP</label>
            <pt-files file-bble="CSCase.BBLE" file-id="CSCase-Utilities-MissingMeter-Upload" base-folder="CSCase-Utilities-MissingMeter-Upload" file-model="CSCase.CSCase.Utilities.MissingMeter_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.MissingMeter_Notes"></textarea>
        </div>
    </div>
</div>

<%-- Taxes --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.Taxes_Shown=false" ng-show="CSCase.CSCase.Utilities.Taxes_Shown">
    <h4 class="ss_form_title">Taxes&nbsp;<pt-collapse model="ReloadedData.Taxes_Collapsed" /></h4>
    <div class="ss_border" collapse="ReloadedData.Taxes_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes_AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Type</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes_AccountType">
                    <option value="NA">N/A</option>
                    <option value="ERP">ERP</option>
                    <option value="Registration">Registration</option>
                    <option value="Tax">Tax</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes_NameAccountIsUnder" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes_OpenCharges">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien</label>
                <pt-radio name="CSCase-Utilities-Taxes-TaxLien" model="CSCase.CSCase.Utilities.Taxes_TaxLien"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="CSCase.CSCase.Utilities.Taxes_TaxLien">
                <label class="ss_form_input_title">Upload Payment Agreement</label>
                <pt-file file-bble="CSCase.BBLE" file-id="CSCase-Utilities-Taxes_PaymentAgreement" file-model="CSCase.CSCase.Utilities.Taxes_PaymentAgreement"></pt-file>
            </li>
        </ul>
    </div>
</div>

<%-- ADT --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.ADT_Shown=false" ng-show="CSCase.CSCase.Utilities.ADT_Shown">
    <h4 class="ss_form_title">ADT&nbsp;<pt-collapse model="ReloadedData.ADT_Collapsed" /></h4>
    <div class="ss_border" collapse="ReloadedData.ADT_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ADT_AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT_DateRequest" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Installation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT_InstallationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT_CancellatonDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ADT">
            </li>
        </ul>
    </div>
</div>

<%-- Insurance --%>
<div class="ss_form" ng-init="CSCase.CSCase.Utilities.Insurance_Shown=false" ng-show="CSCase.CSCase.Utilities.Insurance_Shown">
    <h4 class="ss_form_title">Insurance&nbsp;<pt-collapse model="ReloadedData.Insurance_Collapsed" /></h4>
    <div class="ss_border" collapse="ReloadedData.Insurance_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Insurance Type</label>
                <div class="ss_form_input" dx-tag-box="{
                dataSource: [{name: 'Property'},
                            {name: 'Contract'}],
                valueExpr: 'name',
                displayExpr: 'name',
                bindingOptions: {values: 'CSCase.CSCase.Utilities.Insurance_Type'}}">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Policy Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Insurance_PolicyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Expiration Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance_ExpirationDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance_CancellationDate" ss-date>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="CSCase-Utilities-InsuranceUpload" base-folder="CSCase-Utilities-InsuranceUpload" file-model="CSCase.CSCase.Utilities.Insurance_Upload"></pt-files>
        </div>
        <div class="ss_form_item">
            <label class="ss_form_input_title">Renewal Remind</label>
            <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance_CalenderOption" ss-date>
        </div>
    </div>

</div>
