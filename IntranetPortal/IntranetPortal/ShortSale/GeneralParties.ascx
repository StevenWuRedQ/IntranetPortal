<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="GeneralParties.ascx.vb" Inherits="IntranetPortal.GeneralParties" %>
<div class="clearfix"></div>
<div>
    <h4 class="ss_form_title">Assigned Processor</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.ProcessorName" readonly="readonly" ng-change="SsCase.Processor=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.Processor=$item.ContactId" bind-id="SsCase.Processor" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Phone #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.Processor, SsCase.ProcessorName).OfficeNO" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.Processor, SsCase.ProcessorName).Email" type="email" readonly="readonly">
            </li>
        </ul>
    </div>
</div>
<div>
    <h4 class="ss_form_title">InHouse Title</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.InHouseTitle" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Phone #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(SsCase.InHouseTitle).OfficeNO" mask="(999) 999-9999" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(SsCase.InHouseTitle).Email" type="email" readonly="readonly">
            </li>
        </ul>
    </div>
</div>
<div>
    <h4 class="ss_form_title">InHouse Legal</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.InHouseLegal" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Phone #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(SsCase.InHouseLegal).OfficeNO" mask="(999) 999-9999" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(SsCase.InHouseLegal).Email" type="email" readonly="readonly">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Referral&nbsp<pt-collapse model="referralCollapse"/></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Agent</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.ReferralUserName" ng-change="SsCase.Referral=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.Referral=$item.ContactId" bind-id="SsCase.Referral">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.Referral, SsCase.ReferralUserName).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.Referral, SsCase.ReferralUserName).Email" type="email" readonly="readonly">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!referralCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Team</label>
                <select class="ss_form_input" ng-model="SsCase.ReferralTeam">
                    <option></option>
                    <%For Each t In IntranetPortal.Team.GetAllTeams%>
                    <option><%= t.Name %></option>
                    <%Next%>
                </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="ptContactServices.getTeamByName(SsCase.ReferralTeam).Address">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getTeamByName(SsCase.ReferralTeam).OfficeNo" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Manager</label>
                <input class="ss_form_input" ng-model="ptContactServices.getTeamByName(SsCase.ReferralTeam).Manager">
            </li>
            <li class="ss_form_item" style="display: none">
                <label class="ss_form_input_title">ContactId</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Manager).ContactId" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Manager).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Manager).Email" type="email" readonly="readonly">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Assistant</label>
                <input class="ss_form_input" ng-model="ptContactServices.getTeamByName(SsCase.ReferralTeam).Assistant" readonly="readonly">
            </li>
            <li class="ss_form_item" style="display: none">
                <label class="ss_form_input_title">ContactId</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Assistant).ContactId" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Assistant).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContactByName(ptContactServices.getTeamByName(SsCase.ReferralTeam).Assistant).Email" type="email" readonly="readonly">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Listing Agent&nbsp;<pt-collapse model="listingAgentCollapse"/></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.ListingAgentName" ng-change="SsCase.ListingAgent=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.ListingAgent=$item.ContactId" bind-id="SsCase.ListingAgent">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.ListingAgent, SsCase.ListingAgentName).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.ListingAgent, SsCase.ListingAgentName).Email" type="email" readonly="readonly">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!listingAgentCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Broker</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.ListingAgent, SsCase.ListingAgentName).Broker" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.ListingAgent, SsCase.ListingAgentName).Address" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.ListingAgent, SsCase.ListingAgentName).OfficeNO" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Seller Attorney&nbsp;<pt-collapse model="sellerAttorneyCollapse" /></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.SellerAttorneyName" ng-change="SsCase.SellerAttorney=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.SellerAttorney=$item.ContactId" bind-id="SsCase.SellerAttorney">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.SellerAttorney, SsCase.SellerAttorneyName).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.SellerAttorney, SsCase.SellerAttorneyName).Email" type="email" readonly="readonly">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!sellerAttorneyCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.SellerAttorney, SsCase.SellerAttorneyName).Office" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.SellerAttorney, SsCase.SellerAttorneyName).Address" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.SellerAttorney, SsCase.SellerAttorneyName).OfficeNO" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
        </ul>
    </div>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Buyer&nbsp;<pt-collapse model="buyerCollapse"/></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Entity</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.BuyerEntity.Entity" ng-change="SsCase.BuyerEntity.EntityAddress=null" uib-typeahead="entity.CorpName for entity in ptContactServices.getEntities($viewValue)" typeahead-on-select="SsCase.BuyerEntity.EntityAddress=$item.Address">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Entity Address</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerEntity.EntityAddress">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.BuyerEntity.Signor" ng-change="SsCase.BuyerEntity.SignorId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.BuyerEntity.SignorId=$item.ContactId" bind-id="SsCase.BuyerEntity.SignorId">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!buyerCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Opened</label>
                <input class="ss_form_input" ss-date ng-model="SsCase.BuyerEntity.DateOpened">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerEntity.SignorId, SsCase.BuyerEntity.Signor).OfficeNO" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerEntity.TaxId">
            </li>
        </ul>
    </div>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Buyer Attorney&nbsp;<pt-collapse model="buyerAttorneryCollapse"/></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input type="text" class="ss_form_input" ng-model="SsCase.BuyerAttorneyName" ng-change="SsCase.BuyerAttorney=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="SsCase.BuyerAttorney=$item.ContactId" bind-id="SsCase.BuyerAttorney">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerAttorney, SsCase.BuyerAttorneyName).Cell" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerAttorney, SsCase.BuyerAttorneyName).Email" type="email" readonly="readonly">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!buyerAttorneryCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerAttorney, SsCase.BuyerAttorneyName).Office" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office Address</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerAttorney, SsCase.BuyerAttorneyName).Address" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerAttorney, SsCase.BuyerAttorneyName).OfficeNO" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
        </ul>
    </div>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Title Company&nbsp<i class="fa fa-compress icon_btn text-primary" ng-show="!titleCompanyCollapse" ng-click="titleCompanyCollapse = !titleCompanyCollapse"></i><i class="fa fa-expand icon_btn text-primary" ng-show="titleCompanyCollapse" ng-click="titleCompanyCollapse = !titleCompanyCollapse"></i></h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Company</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.CompanyName" ng-change="SsCase.BuyerTitle.ContactId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,1)" typeahead-on-select="SsCase.BuyerTitle.ContactId=$item.ContactId" bind-id="SsCase.BuyerTitle.ContactId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerTitle.ContactId, SsCase.BuyerTitle.CompanyName).Address">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input" ng-model="ptContactServices.getContact(SsCase.BuyerTitle.ContactId, SsCase.BuyerTitle.CompanyName).OfficeNO"" mask="(999) 999-9999" clean="true">
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!titleCompanyCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.Rep">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep #</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.RepNo" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.Email" type="email">
            </li>

        </ul>

    </div>
</div>
