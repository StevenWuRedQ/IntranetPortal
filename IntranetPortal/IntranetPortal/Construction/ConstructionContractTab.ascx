<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionContractTab.ascx.vb" Inherits="IntranetPortal.ConstructionContractTab" %>
<div>

    <div class="">
        <h4 class="ss_form_title">Electrical</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.ElectricalName" ng-change="SCCase.ElectricalId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.ElectricalId=$item.ContactId" bind-id="CSCase.CSCase.ElectricalId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>

                <select class="ss_form_input" ng-model="CSCase.CSCase.ElectricalScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <button class="btn" type="button">Upload</button>
            </li>
        </ul>

    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Construction</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.ConstructionName" ng-change="SCCase.ConstructionId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.ConstructionId=$item.ContactId" bind-id="CSCase.CSCase.ConstructionId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>

                <select class="ss_form_input" ng-model="CSCase.CSCase.ConstructionScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <button class="btn" type="button">Upload</button>
            </li>
        </ul>

    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Plumbing</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Contact</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.PlumbingName" ng-change="SCCase.PlumbingId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.CSCase.PlumbingId=$item.ContactId" bind-id="CSCase.CSCase.PlumbingId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Scope Of work</label>

                <select class="ss_form_input" ng-model="CSCase.CSCase.PlumbingScopeOfwork">
                    <option>Alt1</option>
                    <option>Alt2</option>
                    <option>Alt3</option>
                    <option>W/extension</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract</label>
                <button class="btn" type="button">Upload</button>
            </li>
        </ul>

    </div>
</div>
