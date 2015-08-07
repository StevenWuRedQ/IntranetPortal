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
        <%--
        <li class="ss_form_item3">
            <div class="ss_form_item" tagoptions="['Coned', 'Energy Service', 'National Grid']" tagmodel="CSCase.Utilities.Company" pt-tags></div>
        </li>
        --%>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ConED</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">DATE</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ConEDDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConEDRepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.ConEDService" name="CSCase.Utilities.ConEDService"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConEDMeterNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Missing/Damaged Meter</label>
                <select class="ss_form_input" ng-model="CSCase.Utilities.ConED.MissingMeter">
                    <option value="PLP">PLP</option>
                    <option value="bsmt">bsmt</option>
                    <option value="1st_Fillable">1st Fillable</option>
                    <option value="2nd_Fillable">2nd Fillable</option>
                    <option value="3rd_Fillable">3rd Fillable</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio model="CSCase.Utilities.ConEDAccountOpen" name="CSCase.Utilities.ConEDAccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy service required</label>
                <pt-radio model="CSCase.Utilities.ConEDEnergyServiceRequired" name="CSCase.Utilities.ConEDEnergyServiceRequired"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConEDFloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.ConEDAccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.ConEDAppointments" ss-date>
            </li>
            <li class="ss_form_item3">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.Utilities.ConEDNote"></textarea>
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
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyServiceDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Case Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyServiceCaseNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lic Electrician</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.Utilities.EnergyService.LicElectrician" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Eletric permit pulled Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyServiceElecPermPulledDate" ss-date>
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
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyServiceCityPermitPulledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Energy Service Check</label>
                <input class="ss_form_input" model="CSCase.Utilities.EnergyServiceEnergyServiceCheck">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Check List Submitted</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.EnergyServiceDateCheckListSubmitted">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.EnergyServiceAppointments" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.EnergyServiceNotes"></textarea>
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
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.NationalGridDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGridRepName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor #</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGridFloorNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.NationalGridService" name="CSCase.Utilities.NationalGridService"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Meter Number</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGridMeterNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Open</label>
                <pt-radio model="CSCase.Utilities.NationalGridAccountOpen" name="CSCase.Utilities.NationalGridAccountOpen"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Num</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.NationalGridAccountNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appointments</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.NationalGridAppointments" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.Utilities.NationalGridNotes"></textarea>
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
                <input class="ss_form_input" type="text" ng-model="CSCase.Utilities.DEPDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Charges</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEPOpenCharges">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Account Name</label>
                <input class="ss_form_input" ng-model="CSCase.Utilities.DEPAccountName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Service</label>
                <pt-radio model="CSCase.Utilities.DEPService" name="CSCase.Utilities.DEPService"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Lien</label>
                <pt-radio model="CSCase.UtilitiesWaterLien" name="CSCase.UtilitiesWaterLien"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Payment</label>
                <input class="ss_form_input" type="text" ng-model="MODEL" ss-date>
            </li>

        </ul>
    </div>
</div>
