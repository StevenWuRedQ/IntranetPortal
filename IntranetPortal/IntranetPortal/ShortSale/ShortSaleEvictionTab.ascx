<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleEvictionTab.ascx.vb" Inherits="IntranetPortal.ShortSaleEvictionTab" %>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
            <ClientSideEvents Click="swich_edit_model" />
        </dx:ASPxButton>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupied by </label>
            <select class="ss_form_input" id="select_OccupiedBy">
                <option value="volvo">Vacant</option>
                <option value="volvo">Homeowner</option>
                <option value="saab">Tenant (Coop)</option>
                <option value="mercedes">Tenant (Non Coop)</option>
               
            </select>
            <script>
                initSelect("OccupiedBy", '<%= evictionData.OccupiedBy%>');
            </script>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" id="Evivtion" value="<%=evictionData.Evivtion %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input" value="<%=evictionData.DateStarted %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" value="<%= evictionData.LockBoxCode %>">
        </li>

    </ul>
</div>
