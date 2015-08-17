<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionContractTab.ascx.vb" Inherits="IntranetPortal.ConstructionContractTab" %>
<div>

    <div class="">
        <h4 class="ss_form_title">Electrical</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.ElectricalName" ng-change="CSCase.CSCase.Contract.ElectricalId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.Contract.ElectricalId=$item.ContactId" bind-id="CSCase.CSCase.Contract.ElectricalId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>

                <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.ElectricalScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <pt-file file-bble="CSCase.BBLE" file-id="Contract_Electrical_Contract" file-model="CSCase.CSCase.Contract.Electrical_Contract"></pt-file>
            </li>
        </ul>

    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Construction</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.ConstructionName" ng-change="CSCase.CSCase.Contract.ConstructionId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.Contract.ConstructionId=$item.ContactId" bind-id="CSCase.CSCase.Contract.ConstructionId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.Construction_ScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <pt-file file-bble="CSCase.BBLE" file-id="Contract_Electrical_Contract" file-model="CSCase.CSCase.Contract.Electrical_Contract"></pt-file>
            </li>
        </ul>

    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Plumbing</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Contract.PlumbingName" ng-change="CSCase.CSCase.Contract.PlumbingId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.Contract.PlumbingId=$item.ContactId" bind-id="CSCase.CSCase.Contract.PlumbingId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>

                <select class="ss_form_input" ng-model="CSCase.CSCase.Contract.PlumbingScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <pt-file file-bble="CSCase.BBLE" file-id="Contract_Plumbing_Contract" file-model="CSCase.CSCase.Contract.Plumbing_Contract"></pt-file>
            </li>
        </ul>

    </div>
</div>
