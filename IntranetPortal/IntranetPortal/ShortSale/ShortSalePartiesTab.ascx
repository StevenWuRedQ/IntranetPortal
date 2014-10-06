<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSalePartiesTab.ascx.vb" Inherits="IntranetPortal.ShortSalePartiesTab" %>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
    </div>
</div>
<div>   
    <h4 class="ss_form_title">Assigned Processor<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('AssignedProcessor', function(party){ShortSaleCaseData.Processor=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" data-field="AssignedProcessor.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" data-field="AssignedProcessor.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" data-field="AssignedProcessor.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Referral<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('ReferralContact', function(party){ShortSaleCaseData.Referral=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="ReferralContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">manager</label>
            <input class="ss_form_input" value="Manager ?">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" data-field="ReferralContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" data-field="ReferralContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="ReferralContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="ReferralContact.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Listing agent<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('ListingAgentContact', function(party){ShortSaleCaseData.ListingAgent=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="ListingAgentContact.Name">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" data-field="ListingAgentContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" data-field="ListingAgentContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="ListingAgentContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="ListingAgentContact.Email">
        </li>
    </ul>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Buyer<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('BuyerContact', function(party){ShortSaleCaseData.Buyer=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="BuyerContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">corp name</label>
            <input class="ss_form_input" data-field="BuyerContact.CorpName">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" data-field="BuyerContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" data-field="BuyerContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="BuyerContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="BuyerContact.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">seller attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('SellerAttorneyContact', function(party){ShortSaleCaseData.SellerAttorney=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.Office">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="SellerAttorneyContact.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">buyer attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('BuyerAttorneyContact', function(party){ShortSaleCaseData.BuyerAttorney=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.Office">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">address</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.Address">
        </li> 
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="BuyerAttorneyContact.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">title company<i class="fa fa-plus-circle  color_blue_edit collapse_btn" onclick="ShowSelectParty('TitleCompanyContact', function(party){ShortSaleCaseData.TitleCompany=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.Name">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">address</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" data-field="TitleCompanyContact.Email">
        </li>
    </ul>
</div>
