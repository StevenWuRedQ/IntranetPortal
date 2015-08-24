<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleCheckListTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleCheckListTab" %>
<div class="ss_form">
    <h4 class="ss_form_title">Approval Check List</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Approval Issued</label>
                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.DateIssued" ss-date />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Approval Expires</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.DateExpired" ss-date />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Buyers Name</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.BuyerName" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)"/>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Contract Price</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.ContractPrice" money-mask />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Does Net Match - 1st Lien</label>


                <select class="ss_form_input" ng-model="SsCase.ApprovalChecklist.IsFirstLienMatch">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Approved Net - 1st Lien</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.FirstLien" money-mask />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Does Net Match - 2nd Lien</label>


                <select class="ss_form_input" ng-model="SsCase.ApprovalChecklist.IsSecondLienMatch">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Approved Net - 2nd Lien</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.SecondLien" money-mask />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Commission %</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.CommissionPercentage" percent-mask />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Commission Amount</label>


                <input class="ss_form_input" type="text" ng-model="SsCase.ApprovalChecklist.CommissionAmount" money-mask />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Transfer Tax Amount Correct</label>


                <select class="ss_form_input" ng-model="SsCase.ApprovalChecklist.IsTransferTaxAmount">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Approval Letter Saved</label>


                <select class="ss_form_input" ng-model="SsCase.ApprovalChecklist.IsApprovalLetterSaved">
                    <option value="Y">Yes</option>
                    <option value="N">No</option>
                </select>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Confirm Occupancy</label>
                <select class="ss_form_input" ng-model="SsCase.ApprovalChecklist.ConfirmOccupancy">
                    <option value="Vacant">Vacant</option>
                    <option value="Seller">Seller Occupied</option>
                    <option value="Tenant">Tenant Occupied</option>
                    <option value="Seller_Tenant">Seller + Tenant Occupied</option>
                </select>
            </li>
        </ul>
    </div>
</div>
