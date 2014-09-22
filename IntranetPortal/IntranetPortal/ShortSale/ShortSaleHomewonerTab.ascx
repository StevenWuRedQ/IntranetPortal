<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.ShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
            <ClientSideEvents Click="swich_edit_model" />
        </dx:ASPxButton>
    </div>
</div>
<% For Each homeOwnerData As PropertyOwner In homeOwners %>
<div class="ss_form">
    <h4 class="ss_form_title">Seller &nbsp;<i class="fa fa-plus-circle icon_btn color_blue"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">First name</label>
            <input class="ss_form_input" id="FirstName" value="<%=homeOwnerData.FirstName %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Last name</label>
            <input class="ss_form_input" id="LastName" value="<%=homeOwnerData.LastName %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">ssn</label>
            <input class="ss_form_input" id="SSN" value="<%=homeOwnerData.SSN %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">dob</label>
            <input class="ss_form_input" id="DOB" value="<%=homeOwnerData.DOB %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #1</label>
            <input class="ss_form_input" value="<%=homeOwnerData.Phone %> ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" id="Email" value="<%=homeOwnerData.Email %> ">
        </li>
       
        
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">mailing address</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">street nummber</label>
            <input class="ss_form_input" id="MailNumber" value="<%=homeOwnerData.MailNumber%>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">street name</label>
            <input class="ss_form_input" id="MailStreetName" value="<%=homeOwnerData.MailStreetName %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" id="MailCity" value="<%=homeOwnerData.MailCity %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" id="MailState" value="<%=homeOwnerData.MailState %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">zip</label>
            <input class="ss_form_input" id="MailZip" value="<%=homeOwnerData.MailZip %>">
        </li>

    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">ohter info</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">bankruptcy</label>

            <input type="radio"  id="checkYes_Bankruptcy" name="44" <%= ShortSalePage.CheckBox(homeOwnerData.Bankruptcy) %> value="YES" >
            <label for="checkYes_Bankruptcy" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio"  id="none_check_no44" name="44" <%= ShortSalePage.CheckBox(Not homeOwnerData.Bankruptcy) %>  value="NO">
            <label for="none_check_no44" class="input_with_check"><span class="box_text">No</span></label>

        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">employed</label>
            <input class="ss_form_input" id="Employed" value="<%=homeOwnerData.Employed %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">bank account</label>

            <input type="radio" id="checkYes_Bankaccount" <%= ShortSalePage.CheckBox(homeOwnerData.Bankaccount) %> name="45"  value="YES">
            <label for="checkYes_Bankaccount" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="none_check_no452" <%= ShortSalePage.CheckBox(Not homeOwnerData.Bankaccount) %> name="45" value="NO">
            <label for="none_check_no452" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        
         <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Returns</label>

            <input type="radio" id="checkYes_TaxReturn" name="47" <%= ShortSalePage.CheckBox(homeOwnerData.TaxReturn) %>  value="YES">
            <label for="checkYes_TaxReturn" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="none_check_no472"  name="47" <%= ShortSalePage.CheckBox(Not homeOwnerData.TaxReturn) %> value="NO">
            <label for="none_check_no472" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">estate documents</label>

            <input type="radio" id="checkYes_EstateDocument" name="49" <%= ShortSalePage.CheckBox(homeOwnerData.EstateDocument) %> value="YES">
            <label for="checkYes_EstateDocument" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="none_check_no47" name="49" <%= ShortSalePage.CheckBox(Not homeOwnerData.EstateDocument)%> value="NO">
            <label for="none_check_no47" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">estate attorney</label>
            <input class="ss_form_input" id="EstateAttorney" value="<%=homeOwnerData.EstateAttorney %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">phone #</label>
            <input class="ss_form_input" id="Phone" value="<%=homeOwnerData.Phone %>">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">email address</label>
            <input class="ss_form_input" id="emailAddress" value="<%=homeOwnerData.Email %>">
        </li>
        
     
        <li class="ss_form_item">
            <label class="ss_form_input_title">also acting as seller attorney</label>

            <input type="radio" id="checkYes_ActingAsSellerAttorney"  <%= ShortSalePage.CheckBox(homeOwnerData.ActingAsSellerAttorney) %>  name="48"  value="YES">
            <label for="checkYes_ActingAsSellerAttorney" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="none_check_no48"  <%= ShortSalePage.CheckBox( Not homeOwnerData.ActingAsSellerAttorney) %>  name="48" value="NO">
            <label for="none_check_no48" class="input_with_check"><span class="box_text">No</span></label>

        </li>
    </ul>
</div>

<% Next%>