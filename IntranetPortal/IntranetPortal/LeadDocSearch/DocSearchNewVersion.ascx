<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocSearchNewVersion.ascx.vb" Inherits="IntranetPortal.DocSearchNewVersion" %>
<div class="tab-content">
    <div class="tab-pane active" id="LegalTab">

        <div style="overflow: auto; height: 830px; padding: 0 20px">

            <div class="alert alert-warning" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status != 1">
                <i class="fa fa-warning"></i><strong>Warning!</strong> Document search didn't completed yet!
            </div>
            <div class="alert alert-success" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status == 1 && DocSearch.CompletedOn">
                Document search completed on {{DocSearch.CompletedOn|date:'shortDate'}} by {{DocSearch.CompletedBy}}!
            </div>
            <div class="ss_form">
                <h4 class="ss_form_title ">Request Info
                    <pt-collapse model="CollapseRequestInfo" />
                </h4>
                <div class="ss_border" collapse="CollapseRequestInfo">
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested On</label><input class="ss_form_input" ng-model="DocSearch.CreateDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Team</label>
                            <input class="ss_form_input" ng-model="DocSearch.team" readonly="readonly" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested By</label><input class="ss_form_input" ng-model="DocSearch.CreateBy" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Block</label><input class="ss_form_input" ng-model="LeadsInfo.Block" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Lot</label><input class="ss_form_input" ng-model="LeadsInfo.Lot" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Expected Signing Date</label><input class="ss_form_input" ng-model="DocSearch.ExpectedSigningDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Property Addressed</label><input class="ss_form_input" ng-model="LeadsInfo.PropertyAddress" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner Name</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerName" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner SSN</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerSSN" />
                        </li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Owner Address</label>
                            <input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerAddress" />
                        </li>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</div>
