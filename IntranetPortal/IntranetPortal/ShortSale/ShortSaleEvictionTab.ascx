<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleEvictionTab.ascx.vb" Inherits="IntranetPortal.ShortSaleEvictionTab" %>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
        </dx:ASPxButton>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupied by </label>
            <select class="ss_form_input">
                <option value="volvo">Vacant</option>
                <option value="volvo">Homeowner</option>
                <option value="saab">Tenant (Coop)</option>
                <option value="mercedes">Tenant (Non Coop)</option>
                <option value="audi">4</option>
            </select>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" value="Strted">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input" value="June 1,2014">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" value="14321">
        </li>

    </ul>
</div>
