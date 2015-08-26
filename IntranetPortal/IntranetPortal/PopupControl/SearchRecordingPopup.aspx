<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SearchRecordingPopup.aspx.vb" Inherits="IntranetPortal.SearchRecordingPopup" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="SearchRecordinCtrl" ng-controller="SearchRecordinCtrl">
        <div class="">
            <h4 class="ss_form_title ">Documents Received On</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Documents Received</label>
                    <input class="ss_form_input " ng-model="DocumentsReceivedOn.DocumentsReceived">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date Recorded select</label>
                    <select class="ss_form_input " ng-model="DocumentsReceivedOn.DateRecordedselect">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Deed</label>
                    <pt-file file-bble="" file-id="DocumentsReceivedOn_Deed0" file-model="DocumentsReceivedOn.Deed"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Deed Acris Document</label>
                    <pt-file file-bble="" file-id="DocumentsReceivedOn_DeedAcrisDocument0" file-model="DocumentsReceivedOn.DeedAcrisDocument"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memorandum of Contract</label>
                    <pt-file file-bble="" file-id="DocumentsReceivedOn_MemorandumofContract0" file-model="DocumentsReceivedOn.MemorandumofContract"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memorandum of Contract Acris Docs</label>
                    <pt-file file-bble="" file-id="DocumentsReceivedOn_MemorandumofContractAcrisDocs0" file-model="DocumentsReceivedOn.MemorandumofContractAcrisDocs"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Contract of Sales</label>
                    <pt-file file-bble="" file-id="DocumentsReceivedOn_ContractofSales0" file-model="DocumentsReceivedOn.ContractofSales"></pt-file>
                </li>
                <li class="ss_form_item  ss_form_item_line">
                    <label class="ss_form_input_title ">Notes</label>
                    <textarea class="edit_text_area text_area_ss_form " model="DocumentsReceivedOn.Notes"></textarea>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Are Documents Notarized</label>
                    <select class="ss_form_input " ng-model="DocumentsReceivedOn.AreDocumentsNotarized">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
            </ul>
        </div>
        <div class="ss_form ">
            <h4 class="ss_form_title ">Record Documents</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Deed</label>
                    <select class="ss_form_input " ng-model="RecordDocuments.Deed">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memo</label>
                    <select class="ss_form_input " ng-model="RecordDocuments.Memo">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Requested On</label>
                    <input class="ss_form_input " ss-date ng-model="RecordDocuments.RequestedOn">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Requested By</label>
                    <input type="text" class="ss_form_input " ng-model="RecordDocuments.RequestedBy" ng-change="RecordDocuments.RequestedById=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="RecordDocuments.RequestedById=$item.ContactId" bind-id="RecordDocuments.RequestedById">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date of Submission</label>
                    <input class="ss_form_input " ss-date ng-model="RecordDocuments.DateofSubmission">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Transaction ID</label>
                    <input class="ss_form_input " ng-model="RecordDocuments.TransactionID">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Rejected</label>
                    <select class="ss_form_input " ng-model="RecordDocuments.Rejected">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item  ss_form_item_line">
                    <label class="ss_form_input_title ">Rejected notes</label>
                    <textarea class="edit_text_area text_area_ss_form " model="RecordDocuments.Rejectednotes"></textarea>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Recorded</label>
                    <select class="ss_form_input " ng-model="RecordDocuments.Recorded">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date Recorded </label>
                    <input class="ss_form_input " ss-date ng-model="RecordDocuments.DateRecorded">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Recorded File</label>
                    <pt-file file-bble="" file-id="RecordDocuments_RecordedFile0" file-model="RecordDocuments.RecordedFile"></pt-file>
                </li>
            </ul>
        </div>
    </div>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('SearchRecordinCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
            $scope.ptContactServices = ptContactServices;
        });
    </script>
</asp:Content>
