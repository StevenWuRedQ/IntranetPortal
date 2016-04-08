<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SearchRecordingPopup.aspx.vb" Inherits="IntranetPortal.SearchRecordingPopup" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE") %>" />
    <div id="SearchRecordinCtrl" ng-controller="SearchRecordinCtrl">
        <div class="">
            <h4 class="ss_form_title ">Documents Received On</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Documents Received</label>
                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.DocumentsReceived" ss-date>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date Recorded select</label>
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.DateRecordedselect">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Deed</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="DocumentsReceivedOn_Deed0" file-model="DocSearch.LeadResearch.Deed"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Deed Acris Document</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="DocumentsReceivedOn_DeedAcrisDocument0" file-model="DocSearch.LeadResearch.DeedAcrisDocument"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memorandum of Contract</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="DocumentsReceivedOn_MemorandumofContract0" file-model="DocSearch.LeadResearch.MemorandumofContract"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memorandum of Contract Acris Docs</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="DocumentsReceivedOn_MemorandumofContractAcrisDocs0" file-model="DocSearch.LeadResearch.MemorandumofContractAcrisDocs"></pt-file>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Contract of Sales</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="DocumentsReceivedOn_ContractofSales0" file-model="DocSearch.LeadResearch.ContractofSales"></pt-file>
                </li>
                <li class="ss_form_item  ss_form_item_line">
                    <label class="ss_form_input_title ">Notes</label>
                    <textarea class="edit_text_area text_area_ss_form " ng-model="DocSearch.LeadResearch.RecordNotes"></textarea>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Are Documents Notarized</label>
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.AreDocumentsNotarized">
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
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.Deed">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Memo</label>
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.Memo">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Requested On</label>
                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.RequestedOn">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Requested By</label>
                    <input type="text" class="ss_form_input " ng-model="DocSearch.LeadResearch.RequestedBy" ng-change="DocSearch.LeadResearch.RequestedById=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="DocSearch.LeadResearch.RequestedById=$item.ContactId" bind-id="DocSearch.LeadResearch.RequestedById">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date of Submission</label>
                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.DateofSubmission">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Transaction ID</label>
                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.TransactionID">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Rejected</label>
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.Rejected">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item  ss_form_item_line">
                    <label class="ss_form_input_title ">Rejected notes</label>
                    <textarea class="edit_text_area text_area_ss_form " ng-model="DocSearch.LeadResearch.Rejectednotes"></textarea>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Recorded</label>
                    <select class="ss_form_input " ng-model="DocSearch.LeadResearch.Recorded">
                        <option value=""></option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Date Recorded </label>
                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.DateRecorded">
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Recorded File</label>
                    <pt-file file-bble="DocSearch.BBLE" file-id="RecordDocuments_RecordedFile0" file-model="DocSearch.LeadResearch.RecordedFile"></pt-file>
                </li>
            </ul>
        </div>
    </div>
    <script>
        function  SearchRecordComplete()
        {
            angular.element(document.getElementById("SearchRecordinCtrl")).scope().SearchRecordComplete();
        }

        var portalApp = angular.module('PortalApp');
        
        portalApp.controller('SearchRecordinCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
            $scope.ptContactServices = ptContactServices;
            leadsInfoBBLE = $('#BBLE').val();
            $http.get("/api/LeadInfoDocumentSearches/" + leadsInfoBBLE).
            success(function (data, status, headers, config) {
                $scope.DocSearch = data;
            });
            $scope.SearchRecordComplete = function () {
              
                $.ajax({
                    type: "PUT",
                    url: '/api/LeadInfoDocumentSearches/' + $scope.DocSearch.BBLE,
                    data: JSON.stringify($scope.DocSearch),
                    dataType: 'json',
                    contentType: 'application/json',
                    success: function (data) {

                        alert('Lead info search record completed !');
                    },
                    error: function (data) {
                        alert('Some error Occurred url api/LeadInfoDocumentSearches ! Detail: ' + JSON.stringify(data));
                    }

                });
            }
        });
    </script>
</asp:Content>
