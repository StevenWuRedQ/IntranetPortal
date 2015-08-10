<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionContractTab.ascx.vb" Inherits="IntranetPortal.ConstructionContractTab" %>
<div>

    <div class="">
        <h4 class="ss_form_title">Electrical</h4>
        <ul class="ss_form_box clearfix">
            
<li class="ss_form_item">
      <label class="ss_form_input_title">Contact</label>
<input type="text" class="ss_form_input" ng-model="CSCase.ElectricalName" ng-change="SCCase.ElectricalId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="CSCase.ElectricalId=$item.ContactId" bind-id="SsCase.ElectricalId" >
</li>
        </ul>
    
<li class="ss_form_item">
      <label class="ss_form_input_title">Scope Of work</label>

      <select class="ss_form_input" >
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
    </div>
</div>
