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

<div class="ss_form">
    <h4 class="ss_form_title" ng-style="!CSCase.CSCase.Utilities.ConED.Collapsed?'{color: \'red\'}':''">ConED<pt-collapse model="CSCase.CSCase.Utilities.ConED.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.ConED.Collapsed">
        <ul class="ss_form_box clearfix">
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
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-ConED-Service" model="CSCase.CSCase.Utilities.ConED.Service"></pt-radio>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio name="CSCase-Utilities-ConED-AccountOpen" model="CSCase.CSCase.Utilities.ConED.AccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy service required</label>
                <pt-radio name="CSCase-Utilities-ConED-EnergyServiceRequired" model="CSCase.CSCase.Utilities.ConED.EnergyServiceRequired"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ConED.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ConED.Appointments" ss-date>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Auto Populate</label>
        </div>
        <div>
            <label class="ss_form_input_title">Note</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.CSCase.Utilities.ConED.Note"></textarea>
        </div>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Energy Service<pt-collapse model="CSCase.CSCase.Utilities.EnergyService.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.EnergyService.Collapsed">
        <ul class="ss_form_box clearfix">
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
                <label class="ss_form_input_title">??</label>
                <select class="ss_form_input">
                    <option value="Street_Turn_On">Street turn on</option>
                    <option value="Upgrade_Service">Upgrade Service</option>
                    <option value="New_Meter">New meter</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City permit pulled date</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.CityPermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy Service Check</label>
                <input class="ss_form_input" model="CSCase.CSCase.Utilities.EnergyService.EnergyServiceCheck">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Check List Submitted</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.EnergyService.DateCheckListSubmitted">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.EnergyService.Appointments" ss-date>
            </li>
        </ul>
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

<div class="ss_form">
    <h4 class="ss_form_title">National Grid<pt-collapse model="CSCase.CSCase.Utilities.NationalGrid.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.NationalGrid.Collapsed">
        <ul class="ss_form_box clearfix">
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
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-NationalGrid-Service" model="CSCase.CSCase.Utilities.NationalGrid.Service"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.MeterNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio name="CSCase-Utilities-NationalGrid-AccountOpen" model="CSCase.CSCase.Utilities.NationalGrid.AccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Num</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.NationalGrid.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.NationalGrid.Appointments" ss-date>
            </li>
        </ul>

        <div>
            <label class="ss_form_input_title">Auto Populate</label>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.NationalGrid.Notes"></textarea>
        </div>

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">DEP<pt-collapse model="CSCase.CSCase.Utilities.DEP.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.DEP.Collapsed">
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
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.AccountName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio name="CSCase-Utilities-DEP-Service" model="CSCase.CSCase.Utilities.DEP.Service"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Lien</label>
                <pt-radio name="CSCase-Utilities-DEP-WaterLien" model="CSCase.CSCase.Utilities.DEP.WaterLien"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Payment Agreement inplace</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.PaymentAgreementImplace" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.MeterNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.DEP.AccountNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.Appointments" ss-date>
            </li>


            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.DEP.CancellationDate" ss-date>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.DEP.Notes"></textarea>
        </div>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Missing Water Meter<pt-collapse model="CSCase.CSCase.Utilities.MissingMeter.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.MissingMeter.Collapsed">
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
            <label class="ss_form_input_title">Upload</label>
            <pt-file class="ss_form_input" file-id="CSCase-Utilities-MissingMeter-Upload" file-model="CSCase.CSCase.Utilities.MissingMeter.Upload"></pt-file>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Utilities.MissingMeter.Notes"></textarea>
        </div>
    </div>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Taxes<pt-collapse model="CSCase.CSCase.Utilities.Taxes.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.Taxes.Collapsed">
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
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name Account is Under</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Utilities.Taxes.NameAccountIsUnder" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien</label>
                <pt-radio name="CSCase-Utilities-Taxes-TaxLien" model="CSCase.CSCase.Utilities.Taxes.TaxLien"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Payment Agreement Inplace</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Taxes.PaymentAgreementInplace" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ADT<pt-collapse model="CSCase.CSCase.Utilities.ADT.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.ADT.Collapsed">
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
                <label class="ss_form_input_title">Access Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Utilities.ADT.AccesCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.ADT.CancellatonDate" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Insuracne<pt-collapse model="CSCase.CSCase.Utilities.Insurance.Collapsed"/></h4>
    <div class="ss_border" collapse="CSCase.CSCase.Utilities.Insurance.Collapsed">
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
                <label class="ss_form_input_title">Calender Option</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance.CalenderOption" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Utilities.Insurance.CancellationDate" ss-date>
            </li>
        </ul>
    </div>
</div>
