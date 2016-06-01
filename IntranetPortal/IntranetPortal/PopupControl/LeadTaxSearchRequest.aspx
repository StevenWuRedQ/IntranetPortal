<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LeadTaxSearchRequest.aspx.vb" Inherits="IntranetPortal.LeadTaxSearchRequest" %>

<%@ Register Src="~/PopupControl/SearchRecodingPopupCtrl.ascx" TagPrefix="uc1" TagName="SearchRecodingPopupCtrl" %>
<%@ Register Src="~/LeadDocSearch/LeadDocSearchList.ascx" TagPrefix="uc1" TagName="LeadDocSearchList" %>
<%@ Register Src="~/PopupControl/LeadSearchSummery.ascx" TagPrefix="uc1" TagName="LeadSearchSummery" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="/js/PortalHttpFactory.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <div id="LeadTaxSearchCtrl" ng-controller="LeadTaxSearchCtrl">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <uc1:LeadDocSearchList runat="server" ID="LeadDocSearchList" />
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <%-- search panel --%>
                <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div>
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
                                            <li style="margin-right: 30px; color: #ffa484; float: right">

                                                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="Save" ng-click="SearchComplete(true)"></i>

                                            </li>

                                        </ul>
                                    </div>
                                </div>

                                <div class="tab-content">
                                    <div class="tab-pane active" id="LegalTab">
                                       
                                        <div style="overflow: auto; height: 830px; padding: 0 20px">

                                            <div class="alert alert-warning" style="margin-top:20px;font-size:16px" ng-show="DocSearch.Status != 1"> 
                                                <i class="fa fa-warning"></i> <strong>Warning!</strong> Document search didn't completed yet!
                                            </div>
                                            <div class="alert alert-success" style="margin-top:20px;font-size:16px" ng-show="DocSearch.Status == 1 && DocSearch.CompletedOn"> 
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
                                            <div class="ss_form">
                                                <h4 class="ss_form_title ">DOB/ECB
                            <pt-collapse model="CollapseECBDOB" />
                                                </h4>
                                                <div class="ss_border" collapse="CollapseECBDOB">
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
                                                    <h5 class="ss_form_title ">ECB Violation 
                                                        <pt-collapse model="ECBViolation" />
                                                    </h5>
                                                    <div class="ss_border" collapse="ECBViolation">
                                                        <ul class="ss_form_box clearfix">

                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">ECB Violation</label>
                                                                <input class="ss_form_input" ng-model="DocSearch.LeadResearch.ecbViolation" money-mask />

                                                            </li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Dob Violation</label>
                                                                <input class="ss_form_input" ng-model="DocSearch.LeadResearch.dobWebsites" money-mask />

                                                            </li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">ECB On JdmtSearch</label>
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
                                                    <h4 class="ss_form_title ">Liens Info
                                                        <pt-collapse model="LiensInfoCollapse" />
                                                    </h4>
                                                    <div class="ss_border">
                                                        <ul class="ss_form_box clearfix" collapse="LiensInfoCollapse">
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Judgments</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.judgments" money-mask /></li>

                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Irs Tax Lien</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.irsTaxLien" money-mask /></li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">NYS Tax Lien</label>
                                                                <pt-radio name="has_NysTaxLien" model="DocSearch.LeadResearch.hasNysTaxLien"></pt-radio>

                                                            </li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Fannie</label>
                                                                <pt-radio name="liens_info_fannie1" model="DocSearch.LeadResearch.fannie"></pt-radio>

                                                            </li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">FHA</label>
                                                                <pt-radio name="liens_info_fha" model="DocSearch.LeadResearch.fha"></pt-radio>
                                                            </li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Mortgage Amount</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.mortgageAmount" money-mask /></li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">2nd Mortgage Amount</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.secondMortgageAmount" money-mask /></li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Servicer</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.servicer" /></li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Wells Fargo</label>
                                                                <pt-radio name="liens_info_wellsFargo" model="DocSearch.LeadResearch.wellsFargo"></pt-radio>

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
                                                    <h4 class="ss_form_title ">Completed Info
                                                        <pt-collapse model="CompletedInfo" />
                                                    </h4>
                                                    <div class="ss_border" collapse="CompletedInfo">
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
                                                    <h4 class="ss_form_title ">Research Completed <i class="fa fa-pencil-square color_blue_edit collapse_btn tooltip-examples" title="Record Research" onclick="SearchRecodingPopupClient.Show()" ng-show="DocSearch.LeadResearch.documentsReceived"></i>
                                                        <pt-collapse model="ResearchCompleted" />
                                                    </h4>
                                                    <div class="ss_border" collapse="ResearchCompleted">
                                                        <ul class="ss_form_box clearfix">
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Documents Received</label><pt-radio name="research_completed_documents_received" model="DocSearch.LeadResearch.documentsReceived"></pt-radio></li>
                                                            <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">Documents Received On</label>
                                                                <input class="ss_form_input" ng-model="DocSearch.LeadResearch.DocumentsReceivedOn" ss-date />
                                                            </li>
                                                            <%-- <li class="ss_form_item ">
                                                                <label class="ss_form_input_title">&nbsp;</label>
                                                                <input type="button" value="Complete" class="rand-button rand-button-blue rand-button-pad" ng-click="SearchComplete()">
                                                            </li>--%>
                                                            <li class="ss_form_item " ng-show="DocSearch.Status!=1">
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


                            </div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <%-- log panel --%>
                <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9" PaneStyle-Paddings-Padding="0px" Name="LogPanel">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <div style="font-size: 12px; color: #9fa1a8;">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                                    <li class="short_sale_head_tab activity_light_blue">
                                        <a href="#activity_log" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-history head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Summary</div>
                                        </a>
                                    </li>
                                </ul>

                                <div style="padding: 20px" id="searchReslut">
                                    <ds-summary summary="DocSearch.LeadResearch"></ds-summary>
                                   <%-- <uc1:LeadSearchSummery runat="server" ID="LeadSearchSummery" />--%>
                                </div>
                            </div>

                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>
    <script>
        //java script code for outer call


        function LoadSearch(bble) {
            angular.element(document.getElementById('LeadTaxSearchCtrl')).scope().init(bble);
        }
      
    </script>

</asp:Content>
