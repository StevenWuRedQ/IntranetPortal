<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSalePartiesTab.ascx.vb" Inherits="IntranetPortal.NGShortSalePartiesTab" %>
<div class="clearfix">
</div>

<div>
    <h4 class="ss_form_title">Assigned Processor<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('AssignedProcessor', function(party){ShortSaleCaseData.Processor=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" ng-model="SsCase.AssignedProcessor.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" type="phone" ng-model="SsCase.AssignedProcessor.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" type="email" ng-model="SsCase.AssignedProcessor.Email">
        </li>
    </ul>
</div>

<div class="ss_form">
   <h4 class="ss_form_title">Referral<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('ReferralContact', function(party){ShortSaleCaseData.Referral=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Agent</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Agent">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Cell">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" type="email" ng-model="SsCase.ReferralContact.Email">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Team</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Team">
        </li>

                <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Address">
        </li>

                   <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.OfficeNO">
        </li>
                       <li class="ss_form_item">
            <label class="ss_form_input_title">Manager</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Manager">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.ManagerCellNO">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.ManagerEmail">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Assistant</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.Assistant">
        </li>


         <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.AssistantCellNO">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.ReferralContact.AssistantEmail">
        </li>




        <%-- 
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">manager</label>
            <input class="ss_form_input ss_not_edit" data-field="Manager">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
        </li> 
            --%>
    </ul>
</div>

<div class="ss_form">
      <h4 class="ss_form_title">Listing Agent<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('ListingAgentContact', function(party){ShortSaleCaseData.ListingAgent=party.ContactId})"></i></h4>

    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.Email">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Broker</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.Broker">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" ng-model="SsCase.ListingAgentContact.OfficeNO">
        </li>

        <%-- 
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="ListingAgentContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input ss_not_edit" data-field="ListingAgentContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input ss_not_edit" data-field="ListingAgentContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="ListingAgentContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input ss_not_edit" data-field="ListingAgentContact.Email">
        </li>
            --%>
    </ul>
</div>

<div class="ss_form">
     <h4 class="ss_form_title">Seller Attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('SellerAttorneyContact', function(party){ShortSaleCaseData.SellerAttorney=party.ContactId})"></i></h4>

    <ul class="ss_form_box clearfix">

         <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.Name">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.Cell">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.Email">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.Office">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.Address">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" ng-model="SsCase.SellerAttorneyContact.OfficeNO">
        </li>


        <%--
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.Office">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input ss_not_edit" data-field="SellerAttorneyContact.Email">
        </li>
             --%>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Buyer<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('BuyerContact', function(party){ShortSaleCaseData.Buyer=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">

              <li class="ss_form_item">
            <label class="ss_form_input_title">Entity</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerContact.Entity">
        </li>


              <li class="ss_form_item">
            <label class="ss_form_input_title">Entity Address</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerContact.EntityAddr">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Signor</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerContact.Signor">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Date Opened</label>
            <input class="ss_form_input" ss-date="" ng-model="SsCase.BuyerContact.DateOpened">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerContact.Office">
        </li>

         <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Id</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerContact.TaxID">
        </li>


        <%--
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">corp name</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.CorpName">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerContact.Email">
        </li>
             --%>
    </ul>
</div>



<div class="ss_form">
    <h4 class="ss_form_title">Buyer Attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('BuyerAttorneyContact', function(party){ShortSaleCaseData.BuyerAttorney=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">

         <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.Email">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office Address</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerAttorneyContact.OfficeNO">
        </li>
        <%-- 
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.Name">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">address</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office #</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input ss_not_edit" data-field="BuyerAttorneyContact.Email">
        </li>
            --%>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Title Company<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('TitleCompanyContact', function(party){ShortSaleCaseData.TitleCompany=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
            <label class="ss_form_input_title">Company</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.Company">
        </li

                     <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.Address">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.OfficeNO">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Rep</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.Rep">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Rep #</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.RepNO">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="SsCase.TitleCompanyContact.Email">
        </li>



        <%-- 
        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.Name">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.Office">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">address</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.OfficeNO">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.Cell">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input ss_not_edit" data-field="TitleCompanyContact.Email">
        </li>
            --%>
    </ul>
</div>
