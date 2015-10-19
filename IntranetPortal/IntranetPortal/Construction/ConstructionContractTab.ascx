<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionContractTab.ascx.vb" Inherits="IntranetPortal.ConstructionContractTab" %>
<div id="ContructionContractTab">
    <div class="ss_form">
        <h4 class="ss_form_title">Electrical</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Contact</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.Electrical_Name" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="" typeahead-on-select="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Scope Of work</label>
                    <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.Electrical_ScopeOfwork">
                        <option>N/A</option>
                        <option>Alt1</option>
                        <option>Alt2</option>
                        <option>Alt3</option>
                        <option>W/extension</option>
                    </select>
                </li>
                <li class="clearfix" style="list-style: none"></li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vender</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.Electrical_Vender" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="CSCase.CSCase.Contract.Electrical_VenderId=null"  typeahead-on-select="CSCase.CSCase.Contract.Electrical_VenderId=$item.ContactId">
                </li>
                <li class="clearfix" style="list-style: none"></li>
            </ul>
            <div>
                <label class="ss_form_title">Contracts Upload</label>
                <pt-files file-bble="CSCase.BBLE" file-id="Contract_Electrical_Contract" file-model="CSCase.CSCase.Contract.Electrical_Contract" folder-enable="true" base-folder="Contract_Electrical_Contract"></pt-files>
            </div>
        </div>

    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Construction</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Contact</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.ConstructionName" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="" typeahead-on-select="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Scope Of work</label>
                    <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.Construction_ScopeOfwork">
                        <option>N/A</option>
                        <option>Alt1</option>
                        <option>Alt2</option>
                        <option>Alt3</option>
                        <option>W/extension</option>
                    </select>
                </li>

                <li class="clearfix" style="list-style: none"></li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vender</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.Construction_Vender" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="CSCase.CSCase.Contract.Construction_VenderId=null"  typeahead-on-select="CSCase.CSCase.Contract.Construction_VenderId=$item.ContactId">
                </li>
                <li class="clearfix" style="list-style: none"></li>
            </ul>
            <div>
                <label class="ss_form_title">Contracts Upload</label>
                <pt-files file-bble="CSCase.BBLE" file-id="Contract_Electrical_Contract" file-model="CSCase.CSCase.Contract.Electrical_Contract" folder-enable="true" base-folder="Contract_Electrical_Contract"></pt-files>
            </div>
        </div>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Plumbing</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Contact</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.PlumbingName" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="" typeahead-on-select="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Scope Of work</label>
                    <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.PlumbingScopeOfwork">
                        <option>N/A</option>
                        <option>Alt1</option>
                        <option>Alt2</option>
                        <option>Alt3</option>
                        <option>W/extension</option>
                    </select>
                </li>

                <li class="clearfix" style="list-style: none"></li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vender</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.Construction_Vender" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="CSCase.CSCase.Contract.Construction_VenderId=null" typeahead-on-select="CSCase.CSCase.Contract.Construction_VenderId=$item.ContactId">
                </li>
                <li class="clearfix" style="list-style: none"></li>
            </ul>
            <div>
                <label class="ss_form_title">Contracts Upload</label>
                <pt-files file-bble="CSCase.BBLE" file-id="Contract_Plumbing_Contract" file-model="CSCase.CSCase.Contract.Plumbing_Contract" folder-enable="true" base-folder="Contract_Plumbing_Contract"></pt-files>
            </div>
        </div>
    </div>
</div>
