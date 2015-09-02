<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsInfoDoucmentSearch.aspx.vb" Inherits="IntranetPortal.LeadsInfoDoucmentSearch" MasterPageFile="~/Content.Master" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">

    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="ss_form ">
                    <div class="row">
                        <div class="col-md-10">
                            <h4 class="ss_form_title ">Property Request Info  </h4>
                        </div>
                        <div class="col-md-2">
                            
                        </div>
                         
                    </div>
                   
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Requested On</label>
                            <input class="ss_form_input " ss-date ng-model="PropertyRequestInfo.RequestedOn">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Team</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.Team">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Request By</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.RequestBy">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Property Address</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.PropertyAddress">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Block</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.Block">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Lot</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.Lot">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Owner Name</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.OwnerName">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Owner Address</label>
                            <input class="ss_form_input " ng-model="PropertyRequestInfo.OwnerAddress">
                        </li>
                    </ul>
                </div>
                <div class="ss_form ">
                    <h4 class="ss_form_title ">Research Info</h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Property Taxes</label>
                            <input class="ss_form_input " ng-model="ResearchInfo.PropertyTaxes">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Water Charges </label>
                            <input class="ss_form_input " ng-model="ResearchInfo.WaterCharges">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Violation </label>
                            <input class="ss_form_input " ng-model="ResearchInfo.ECBViolation">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Dob</label>
                            <input class="ss_form_input " ng-model="ResearchInfo.Dob">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Judgement Search</label>
                            <input class="ss_form_input " ng-model="ResearchInfo.JudgementSearch">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Judgments</label>
                            <input class="ss_form_input " ng-model="ResearchInfo.Judgments">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Irs Tax Lien </label>
                            <input class="ss_form_input " ng-model="ResearchInfo.IrsTaxLien">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">NYS Tax Lien</label>
                            <input class="ss_form_input " ng-model="ResearchInfo.NYSTaxLien">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Fannie</label>
                            <select class="ss_form_input " ng-model="ResearchInfo.Fannie">
                                <option value=""></option>
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">FHA</label>
                            <select class="ss_form_input " ng-model="ResearchInfo.FHA">
                                <option value=""></option>
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Mortgage Amount </label>
                            <input class="ss_form_input " money-mask ng-model="ResearchInfo.MortgageAmount">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">2nd Mortgage Amount</label>
                            <input class="ss_form_input " money-mask ng-model="ResearchInfo.MortgageAmount2nd">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Servicer </label>
                            <input class="ss_form_input " ng-model="ResearchInfo.Servicer">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Wells Fargo </label>
                            <select class="ss_form_input " ng-model="ResearchInfo.WellsFargo">
                                <option value=""></option>
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Court Date </label>
                            <input class="ss_form_input " ss-date ng-model="ResearchInfo.CourtDate">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Completed On</label>
                            <input class="ss_form_input " ss-date ng-model="ResearchInfo.CompletedOn">
                        </li>
                        <li class="ss_form_item  ss_form_item_line">
                            <label class="ss_form_input_title ">Notes</label>
                            <textarea class="edit_text_area text_area_ss_form " model="ResearchInfo.Notes"></textarea>
                        </li>
                    </ul>
                </div>
                <div class="ss_form ">
                    <h4 class="ss_form_title ">Corporation Info</h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Corporation Requested</label>
                            <select class="ss_form_input " ng-model="CorporationInfo.CorporationRequested">
                                <option value=""></option>
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Requested On</label>
                            <input class="ss_form_input " ss-date ng-model="CorporationInfo.RequestedOn">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Deed</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.Deed">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Memo</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.Memo">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Corp Address</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.CorpAddress">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Corp Signor</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.CorpSignor">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Corp Signor SSN</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.CorpSignorSSN">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Contract Price</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.ContractPrice">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Listing Price</label>
                            <input class="ss_form_input " ng-model="CorporationInfo.ListingPrice">
                        </li>
                    </ul>
                </div>
                <div class="ss_form ">
                    <h4 class="ss_form_title ">Research Completed</h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Deed</label>
                            <select class="ss_form_input " ng-model="ResearchCompleted.Deed">
                                <option value=""></option>
                                <option>Yes</option>
                                <option>No</option>
                            </select>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Documents Received On</label>
                            <input class="ss_form_input " ss-date ng-model="ResearchCompleted.DocumentsReceivedOn">
                        </li>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">

            </div>
        </div>
    </div>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('LegalCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
            $scope.ptContactServices = ptContactServices

        });
    </script>
</asp:Content>
