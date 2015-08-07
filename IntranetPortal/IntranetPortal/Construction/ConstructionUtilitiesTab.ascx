<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUtilitiesTab.ascx.vb" Inherits="IntranetPortal.ConstructionUtilitiesTab" %>

<div class="ss_form">
    <h4 class="ss_form_title">Utility Company</h4>
    <ul class="ss_form_box clearfix">
        <%--li class="ss_form_item3">
            <div dx-tag-box="{
                dataSource: [{name: 'Coned'},
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
                    values: 'Construction.Utilities.Company'
                }
                }">
            </div>
        </li--%>
        <li class="ss_form_item3">
            <div class="ss_form_item" tagoptions="['Coned', 'Energy Service', 'National Grid']" tagmodel="Construction.Utilities.Company" pt-tags></div>
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ConED</h4>
    <div class="ss_border">
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
</div>
