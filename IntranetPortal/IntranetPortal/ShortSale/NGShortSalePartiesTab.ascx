<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSalePartiesTab.ascx.vb" Inherits="IntranetPortal.NGShortSalePartiesTab" %>
<div class="clearfix">
</div>

<div>
    <h4 class="ss_form_title">Assigned Processor<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('AssignedProcessor', function(party){ShortSaleCaseData.Processor=party.ContactId})"></i></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">

            <label class="ss_form_input_title">Name</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.Processor')">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" type="phone" ng-model="GetContactById(SsCase.Processor).OfficeNO" mask="(999) 999-9999" clean="true">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" type="email" ng-model="GetContactById(SsCase.Processor).Email">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Referral&nbsp<i class="fa fa-compress btn  text-primary" ng-click="referralCollapse = !referralCollapse"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
           
            <label class="ss_form_input_title">Agent</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.Referral')"></div>
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.Referral).Cell" mask="(999) 999-9999" clean="true">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" type="email" ng-model="GetContactById(SsCase.Referral).Email">
        </li>
        <div collapse="!referralCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Team</label>
                <select class="ss_form_input" ng-model="SsCase.ReferralTeam">
                    <option></option>
                    <%For Each t In IntranetPortal.Team.GetAllTeams%>
                        <option><%= t.Name %></option>
                    <%Next %>
                 </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="SsCase.Parties.ReferralContact.Address">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="SsCase.Parties.ReferralContact.OfficeNO" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Manager</label>
                <input class="ss_form_input" ng-model="GetTeamByName(SsCase.ReferralTeam).Manager">
            </li>
             <li class="ss_form_item" style="display:none">
                <label class="ss_form_input_title">ContactId</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Manager).ContactId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Manager).Cell" mask="(999) 999-9999" clean="true">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Manager).Email">
            </li>

             <li class="ss_form_item">
                <label class="ss_form_input_title">Assistant</label>
                <input class="ss_form_input" ng-model="GetTeamByName(SsCase.ReferralTeam).Assistant">
            </li>
             <li class="ss_form_item" style="display:none">
                <label class="ss_form_input_title">ContactId</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Assistant).ContactId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Assistant).Cell" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="GetContactByName(GetTeamByName(SsCase.ReferralTeam).Assistant).Email">
            </li>
           
        </div>



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
    <h4 class="ss_form_title">Listing Agent&nbsp<i class="fa fa-compress btn text-primary" ng-click="listingAgentCollapse = !listingAgentCollapse"></i></h4>

    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.ListingAgent')"></div>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.ListingAgent).Cell" mask="(999) 999-9999" clean="true">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.ListingAgent).Email">
        </li>
        <div collapse="!listingAgentCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Broker</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.ListingAgent).Broker">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.ListingAgent).Address">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.ListingAgent).OfficeNO" mask="(999) 999-9999" clean="true">
            </li>
        </div>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Seller Attorney&nbsp<i class="fa fa-compress btn  text-primary" ng-click="sellerAttorneyCollapse = !sellerAttorneyCollapse"></i></h4>

    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.SellerAttorney')"></div>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.SellerAttorney).Cell" mask="(999) 999-9999" clean="true">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.SellerAttorney).Email">
        </li>
        <div collapse="!sellerAttorneyCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.SellerAttorney).Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.SellerAttorney).Address">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.SellerAttorney).OfficeNO" mask="(999) 999-9999" clean="true">
            </li>
        </div>

    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Buyer&nbsp<i class="fa fa-compress btn  text-primary" ng-click="buyerCollapse = !buyerCollapse"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
           
            <label class="ss_form_input_title">Entity</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerEntity.Entity">
        </li>


        <li class="ss_form_item">
            <label class="ss_form_input_title">Entity Address</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerEntity.EntityAddress">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Signor</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.BuyerEntity.SignorId')"></div>
        </li>
        <div collapse="!buyerCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Opened</label>
                <input class="ss_form_input" ss-date ng-model="SsCase.BuyerEntity.DateOpened">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerEntity.SignorId).OfficeNO" mask="(999) 999-9999" clean="true">
                
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerEntity.TaxId">
            </li>
        </div>

    </ul>
</div>



<div class="ss_form">
    <h4 class="ss_form_title">Buyer Attorney&nbsp<i class="fa fa-compress btn  text-primary" ng-click="buyerAttorneryCollapse = !buyerAttorneryCollapse"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <div class="contact_box" dx-select-box="InitContact('SsCase.BuyerAttorney')"></div>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell #</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerAttorney).Cell" mask="(999) 999-9999" clean="true">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerAttorney).Email">
        </li>
        <div collapse="!buyerAttorneryCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerAttorney).Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office Address</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerAttorney).Address">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office #</label>
                <input class="ss_form_input" ng-model="GetContactById(SsCase.BuyerAttorney).OfficeNO" mask="(999) 999-9999" clean="true">
            </li>
        </div>

    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Title Company&nbsp<i class="fa fa-compress btn  text-primary" ng-click="titleCompanyCollapse = !titleCompanyCollapse"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Company</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerTitle.CompanyName">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Address</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerTitle.Address">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">office #</label>
            <input class="ss_form_input" ng-model="SsCase.BuyerTitle.OfficeNO" mask="(999) 999-9999" clean="true">
        </li>
        <div collapse="!titleCompanyCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep</label>
                <input class="ss_form_input"  ng-model="SsCase.BuyerTitle.Rep">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Rep #</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.RepNo" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" ng-model="SsCase.BuyerTitle.Email">
            </li>

        </div>
                
    </ul>
</div>
