<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LeadTaxSearchRequest.aspx.vb" Inherits="IntranetPortal.LeadTaxSearchRequest" %>

<%@ Register Src="~/PopupControl/SearchRecodingPopupCtrl.ascx" TagPrefix="uc1" TagName="SearchRecodingPopupCtrl" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <div style="max-width: 665px">

        <div style="align-content: center; height: 100%">
            <!-- Nav tabs -->

            <div class="legal-menu row" style="margin-left: 0px; margin-right: 0px">
                <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                    <li class="active short_sale_head_tab">
                        <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                            <i class="fa fa-search head_tab_icon_padding"></i>
                            <div class="font_size_bold" id="LegalTabHead">Searches</div>
                        </a>
                    </li>

                </ul>
            </div>
        </div>
        <div class="tab-content">
            <div class="tab-pane active" id="LegalTab">
                <div id="LeadTaxSearchCtrl" ng-controller="LeadTaxSearchCtrl" style="overflow: auto; height: 830px; padding: 0 20px">

                    <div class="ss_form">
                        <h4 class="ss_form_title ">Request Info</h4>
                        <div class="ss_border">
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
                                    <label class="ss_form_input_title">Property Addressed</label><input class="ss_form_input" ng-model="LeadsInfo.PropertyAddress" readonly="readonly" /></li>

                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Owner Name</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerName" />

                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Owner Address</label>
                                    <input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerAddress" />

                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form">
                        <h4 class="ss_form_title ">DOB/ECB</h4>
                        <div class="ss_border">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Property Taxes</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.propertyTaxes" money-mask /></li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Water Charges</label>
                                    <input class="ss_form_input" ng-model="DocSearch.LeadResearch.waterCharges" money-mask />
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">C/O</label>
                                    <pt-radio name="liens_info_fannie" model="DocSearch.LeadResearch.hasCO"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.hasCO">
                                    <label class="ss_form_input_title">C/O Date</label>
                                    <input class="ss_form_input" ng-model="DocSearch.LeadResearch.CODate" ss-date />
                                </li>

                                <li class="ss_form_item " ng-show="DocSearch.LeadResearch.hasCO">
                                    <label class="ss_form_input_title">C/O Class</label>
                                    <input class="ss_form_input" ng-model="DocSearch.LeadResearch.COClass" />
                                </li>




                            </ul>
                            <h5 class="ss_form_title ">ECB Violation  </h5>
                            <div class="ss_border">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Dob Websites</label>
                                        <input class="ss_form_input" ng-model="DocSearch.LeadResearch.dobWebsites" money-mask />

                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Judgement Search</label>
                                        <input class="ss_form_input" ng-model="DocSearch.LeadResearch.judgementSearch" money-mask />
                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Judgement Doc</label>
                                        <pt-file file-bble="DocSearch.BBLE" file-id="DocSearch.LeadResearch.judgementSearchDocId" file-model="DocSearch.LeadResearch.judgementSearchDoc"></pt-file>
                                    </li>
                                </ul>

                            </div>
                        </div>
                        <div class="ss_form">
                            <h4 class="ss_form_title ">Liens Info</h4>
                            <div class="ss_border">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Judgments</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.judgments" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Irs Tax Lien</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.irsTaxLien" money-mask/></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">NYS Tax Lien</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.nysTaxLien" money-mask/></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Fannie</label>
                                        <pt-radio name="liens_info_fannie1" model="DocSearch.LeadResearch.fannie">

                                        </pt-radio>

                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">FHA</label>
                                        <pt-radio name="liens_info_fha" model="DocSearch.LeadResearch.fha">
                                                                                      </pt-radio>
                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Mortgage Amount</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.mortgageAmount" money-mask /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">2nd Mortgage Amount</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.secondMortgageAmount" money-mask /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Servicer</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.servicer" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Wells Fargo</label>
                                         <pt-radio name="liens_info_fha" model="DocSearch.LeadResearch.wellsFargo">
                                         </pt-radio>

                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Court Date</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.courtDate" ss-date /></li>
                                    <li class="clear-fix" style="list-style: none"></li>
                                    <li class="ss_form_item_line" style="list-style: none">
                                        <label class="ss_form_input_title">Notes:</label>
                                        <textarea class="edit_text_area text_area_ss_form" model="DocSearch.LeadResearch.notes" style="height: 100px"></textarea>
                                    <li class="clear-fix" style="list-style: none"></li>
                                </ul>
                            </div>
                        </div>
                        <div class="ss_form">
                            <h4 class="ss_form_title ">Completed Info </h4>
                            <div class="ss_border">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Searches Completed On</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.searchesCompletedOn" ss-date /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Corporation/LLC Requested</label><pt-radio name="completed_info_corporation_llc_requested" model="DocSearch.LeadResearch.corporationLlcRequested"></pt-radio></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Corporation/LLC Requested On</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.corporationLlcRequestedOn" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Corporation/LLC Assigned</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.corporationLlcAssigned" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Deed</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.deed" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Memo</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.memo" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Address of Corporation/LLC</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.addressOfCorporationLlc" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Signor of Corporation/LLC</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.signorOfCorporationLlc" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Signor Social Security</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.signorSocialSecurity" /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Contract Price</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.contractPrice" money-mask /></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Listing Price</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.listingPrice" money-mask /></li>
                                </ul>
                            </div>
                        </div>
                        <uc1:SearchRecodingPopupCtrl runat="server" ID="SearchRecodingPopupCtrl1" />
                        <div class="ss_form">
                            <h4 class="ss_form_title ">Research Completed <i class="fa fa-pencil-square color_blue_edit collapse_btn tooltip-examples" title="Record Research" onclick="SearchRecodingPopupClient.Show()" ng-show="DocSearch.LeadResearch.documentsReceived"></i></h4>
                            <div class="ss_border">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Documents Received</label><pt-radio name="research_completed_documents_received" model="DocSearch.LeadResearch.documentsReceived"></pt-radio></li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">Documents Received On</label>
                                        <input class="ss_form_input" ng-model="DocSearch.LeadResearch.DocumentsReceivedOn" ss-date />
                                    </li>
                                    <li class="ss_form_item ">
                                        <label class="ss_form_input_title">&nbsp;</label>
                                        <input type="button" value="Complete" class="rand-button rand-button-blue rand-button-pad" ng-click="SearchComplete()">
                                    </li>

                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>



        <script>
            var portalApp = angular.module('PortalApp');

            portalApp.controller('LeadTaxSearchCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
                $scope.ptContactServices = ptContactServices;
                leadsInfoBBLE = $('#BBLE').val();
                if (!leadsInfoBBLE) {
                    alert("Can not load page without BBLE !")
                    return;
                }

                $http.get("/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + leadsInfoBBLE).
                success(function (data, status, headers, config) {
                    $scope.LeadsInfo = data;

                }).error(function (data, status, headers, config) {
                    alert("Get Leads Info failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
                });

                $http.get("/api/LeadInfoDocumentSearches/" + leadsInfoBBLE).
                success(function (data, status, headers, config) {
                    $scope.DocSearch = data;
                    $http.get('/Services/TeamService.svc/GetTeam?userName=' + $scope.DocSearch.CreateBy).success(function (data) {
                        $scope.DocSearch.team = data;
                    });
                }).error(function (data, status, headers, config) {
                    alert("Get Leads Info failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
                });
                $scope.SearchComplete = function () {
                    $scope.DocSearch.Status = 1;
                    $.ajax({
                        type: "PUT",
                        url: '/api/LeadInfoDocumentSearches/' + $scope.DocSearch.BBLE,
                        data: JSON.stringify($scope.DocSearch),
                        dataType: 'json',
                        contentType: 'application/json',
                        success: function (data) {

                            alert('Lead info search completed !');
                        },
                        error: function (data) {
                            alert('Some error Occurred url api/LeadInfoDocumentSearches ! Detail: ' + JSON.stringify(data));
                        }

                    });
                }
            });
        </script>
</asp:Content>
