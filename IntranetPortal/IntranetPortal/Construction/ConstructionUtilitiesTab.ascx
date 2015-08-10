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
                bindingOptions: {
                    values: 'CSCase.Utilities.Company'
                }
                }">
            </div>
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ConED</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">DATE</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ConED.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConED.RepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.ConED.Service" name="CSCase.Utilities.ConED.Service"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConED.MeterNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Missing/Damaged Meter</label>
                <select class="ss_form_input" ng-model="CSCase.Utilities.ConED..MissingMeter">
                    <option value="PLP">PLP</option>
                    <option value="bsmt">bsmt</option>
                    <option value="1st_Fillable">1st Fillable</option>
                    <option value="2nd_Fillable">2nd Fillable</option>
                    <option value="3rd_Fillable">3rd Fillable</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio model="CSCase.Utilities.ConED.AccountOpen" name="CSCase.Utilities.ConED.AccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy service required</label>
                <pt-radio model="CSCase.Utilities.ConED.EnergyServiceRequired" name="CSCase.Utilities.ConED.EnergyServiceRequired"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConED.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConED.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ConED.Appointments" ss-date>
            </li>
            <li class="ss_form_item3">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.Utilities.ConED.Note"></textarea>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">autopopulate</label>

            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Energy Service</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyService.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Case Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyService.CaseNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lic Electrician</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.Utilities.EnergyService..LicElectrician" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Eletric permit pulled Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyService.ElecPermPulledDate" ss-date>
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
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyService.CityPermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy Service Check</label>
                <input class="ss_form_input" model="CSCase.Utilities.EnergyService.EnergyServiceCheck">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Check List Submitted</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyService.DateCheckListSubmitted">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyService.Appointments" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.EnergyService.Notes"></textarea>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">National Grid</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.NationalGrid.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGrid.RepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGrid.FloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.NationalGrid.Service" name="CSCase.Utilities.NationalGrid.Service"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGrid.MeterNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio model="CSCase.Utilities.NationalGrid.AccountOpen" name="CSCase.Utilities.NationalGrid.AccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Num</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGrid.AccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.NationalGrid.Appointments" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.NationalGrid.Notes"></textarea>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">autopopulate</label>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">DEP</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.DEP.Date" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEP.OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEP.AccountName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.DEP.Service" name="CSCase.Utilities.DEP.Service"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Lien</label>
                <pt-radio model="CSCase.Utilities.DEP.WaterLien" name="CSCase.Utilities.DEP.WaterLien"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Payment Agreement inplace</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.DEP.PaymentAgreementImplace" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEP.MeterNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEP.AccountNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.DEP.Appointments" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.DEP.Notes"></textarea>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.DEP.CancellationDate" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Missing Water Meter</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plumber</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.Utilities.MissingMeter.Plumber" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Permit pulled date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.MissingMeter.PermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Registered Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.MissingMeter.MeterRegisteredDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Size</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.MissingMeter.MeterSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tap Size</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.MissingMeter.TapSize">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.MissingMeter.Notes"></textarea>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file class="ss_form_input"></pt-file>
            </li>
        </ul>
    </div>
</div>
 

<div class="ss_form">
    <h4 class="ss_form_title">Taxes</h4>
    <div class="ss_border">		
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Type</label>
                <select class="ss_form_input" ng-model="CSCase.Utilities.Taxes.AccountType">
                    <option value="ERP">ERP</option>
                    <option value="Registration">Registration</option>
                    <option value="Tax">Tax</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.Taxes.OpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name Account is Under</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.Utilities.Taxes.NameAccountIsUnder" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien</label>
                <pt-radio model="CSCase.Utilities.Taxes.TaxLien" name="CSCase.Utilities.Taxes.TaxLien"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Payment Agreement Inplace</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.Taxes.PaymentAgreementInplace" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ADT</h4>
    <div class="ss_border">		
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ADT.DateRequest" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Installation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ADT.InstallationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access Code</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ADT.AccesCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ADT.CancellatonDate" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Insuracne</h4>
    <div class="ss_border">		
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Policy Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.Insurance.PolicyNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Expiration Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.Insurance.ExpirationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calender Option</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.Insurance.CalenderOption" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cancellation Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.Insurance.CancellationDate" ss-date>
            </li>
        </ul>
    </div>
</div>