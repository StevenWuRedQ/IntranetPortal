<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleEvictionTab.ascx.vb" Inherits="IntranetPortal.ShortSaleEvictionTab" %>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='swich_edit_model(this, short_sale_case_data)' />
       
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupied by </label>
            <select class="ss_form_input" data-field="OccupiedBy">
                <option value="volvo">Vacant</option>
                <option value="volvo">Homeowner</option>
                <option value="saab">Tenant (Coop)</option>
                <option value="mercedes">Tenant (Non Coop)</option>

            </select>
            
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" data-field="Evivtion"  >
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input" data-field="DateStarted">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" data-field="LockBoxCode">
        </li>

    </ul>
</div>
