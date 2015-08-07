<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUtilitiesTab.ascx.vb" Inherits="IntranetPortal.ConstructionUtilitiesTab" %>

<div class="ss_form">
    <h4 class="ss_form_title">Coned</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">DATE</label>
            <input class="ss_form_input" type="text" ng-model="Construction.Utilities.Date" ss-date>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Rep Name</label>
            <input class="ss_form_input">
        </li>
    </ul>
</div>