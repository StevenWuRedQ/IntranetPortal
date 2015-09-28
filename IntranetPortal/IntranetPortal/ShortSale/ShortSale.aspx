<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSale.aspx.vb" Inherits="IntranetPortal.NGShortSale" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/ShortSale/ShortSaleOverVew.ascx" TagPrefix="uc1" TagName="ShortSaleOverVew" %>
<%@ Register Src="~/ShortSale/TitleControl.ascx" TagPrefix="uc1" TagName="Title" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/ShortSale/SelectPartyUC.ascx" TagPrefix="uc1" TagName="SelectPartyUC" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>
<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/ShortSale/ShortSaleFileOverview.ascx" TagPrefix="uc1" TagName="ShortSaleFileOverview" %>
<%@ Register Src="~/ShortSale/NGShortSaleTab.ascx" TagPrefix="uc1" TagName="NGShortSaleTab" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <link href="/Scripts/jquery.webui-popover.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery.webui-popover.js"></script>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script type="text/javascript">
        var caseId = null;
        var leadsInfoBBLE = null;

        function OnCallbackMenuClick(s, e) {
            if (e.item.name == "Custom") {
                ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
                e.processOnServer = false;
                return;
            }

            LogClick("FollowUp", e.item.name);
            e.processOnServer = false;
        }

        window.onbeforeunload = function () {
            if (CaseDataChanged())
                return "You have pending changes, would you save it?";
        }
    </script>
    <asp:HiddenField runat="server" ID="hfIsEvction" Value="false" />
    
    <div style="background: url(/images/MyIdealProptery.png) no-repeat center fixed; background-size: 260px, 280px; background-color: #dddddd; width: 100%; height: 100%;">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <%-- ShortSale List --%>
                <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="2px">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="None" PaneStyle-Paddings-Padding="0px">
                    <PaneStyle BackColor="#F9F9F9">
                    </PaneStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <dx:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel2">
                                <PanelCollection>
                                    <dx:PanelContent ID="PanelContent1" runat="server">
                                        <dx:ASPxSplitter ID="contentSplitter" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter" ClientVisible="true">
                                            <Styles>
                                                <Pane Paddings-Padding="0">
                                                    <Paddings Padding="0px"></Paddings>
                                                </Pane>
                                            </Styles>
                                            <Panes>
                                                <%-- ShortSale Panel--%>
                                                <dx:SplitterPane ShowCollapseBackwardButton="True" Name="ContentPanel" AutoHeight="true">
                                                    <PaneStyle Paddings-Padding="0">
                                                        <Paddings Padding="0px"></Paddings>
                                                    </PaneStyle>
                                                    <ContentCollection>
                                                        <dx:SplitterContentControl ID="SplitterContentControl3" runat="server">
                                                            <div class="shortSaleUI" style="align-content: center; height: 100%" id="ShortSaleCtrl" ng-controller="ShortSaleCtrl">
                                                                <asp:HiddenField ID="hfBBLE" runat="server" />
                                                                <!-- Nav tabs -->
                                                                <% If Not HiddenTab Then%>
                                                                <div class="legal-menu row" style="margin-left: 0; margin-right: 0">
                                                                    <ul class="nav-bar nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white;">
                                                                        <li class="active short_sale_head_tab">
                                                                            <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                                                <i class="fa fa-sign-out fa-info-circle head_tab_icon_padding"></i>
                                                                                <div class="font_size_bold" id="ShortSaleTabHead">ShortSale</div>
                                                                            </a>
                                                                        </li>
                                                                        <li class="short_sale_head_tab">
                                                                            <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                                                                                <i class="fa fa-key head_tab_icon_padding"></i>
                                                                                <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;Title&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                                            </a>
                                                                        </li>
                                                                        <li class="short_sale_head_tab">
                                                                            <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                                                                                <i class="fa fa-file head_tab_icon_padding"></i>
                                                                                <div class="font_size_bold">Documents</div>
                                                                            </a>
                                                                        </li>
                                                                        <li class="short_sale_head_tab" ng-show="SsCase&&SsCase.BBLE">
                                                                            <a class="tab_button_a">
                                                                                <i class="fa fa-list-ul head_tab_icon_padding"></i>
                                                                                <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;More&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                                            </a>
                                                                            <div class="shot_sale_sub">
                                                                                <ul class="nav  clearfix" role="tablist">
                                                                                    <li class="short_sale_head_tab">
                                                                                        <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_leads" data-url="/ViewLeadsInfo.aspx?HiddenTab=true&id={{SsCase.BBLE}}" data-href="#more_leads" onclick="LoadMoreFrame(this)">
                                                                                            <i class="fa fa-folder head_tab_icon_padding"></i>
                                                                                            <div class="font_size_bold">Leads</div>
                                                                                        </a>
                                                                                    </li>
                                                                                    <li class="short_sale_head_tab">
                                                                                        <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_evction" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&isEviction=true&bble={{SsCase.BBLE}}" data-href="#more_evction" onclick="LoadMoreFrame(this)">
                                                                                            <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                                                            <div class="font_size_bold">Eviction</div>
                                                                                        </a>
                                                                                    </li>

                                                                                    <li class="short_sale_head_tab">
                                                                                        <a role="tab" data-toggle="tab" class="tab_button_a" href="#more_legal"  data-url="/LegalUI/LegalUI.aspx?HiddenTab=true&isEviction=true&bble={{SsCase.BBLE}}" data-href="#more_legal" onclick="LoadMoreFrame(this)">
                                                                                            <i class="fa fa-university head_tab_icon_padding"></i>
                                                                                            <div class="font_size_bold">Legal</div>
                                                                                        </a>
                                                                                    </li>

                                                                                </ul>
                                                                            </div>
                                                                        </li>
                                                                        <li class="pull-right" style="margin-right: 10px; color: #ffa484">
                                                                            <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="SaveShortSale()" data-original-title="Save"></i>
                                                                            <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Re-Assign" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);"></i>
                                                                            <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i>
                                                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick=""></i>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                                <% End If%>
                                                                <uc1:SendMail runat="server" ID="SendMail" LogCategory="ShortSale" />

                                                                <div class="tab-content">
                                                                    <div class="tab-pane active" id="property_info">
                                                                        <uc1:NGShortSaleTab runat="server" ID="NGShortSaleTab" />
                                                                    </div>
                                                                    <div class="tab-pane " id="home_owner">
                                                                        <uc1:Title runat="server" ID="ucTitle" />
                                                                    </div>
                                                                    <div class="tab-pane " id="documents">
                                                                        <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                                                    </div>
                                                                    <div class="tab-pane load_bg" id="more_leads">
                                                                        <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                                                    </div>
                                                                    <div class="tab-pane load_bg" id="more_evction">
                                                                        <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                                                    </div>
                                                                    <div class="tab-pane load_bg" id="more_legal">
                                                                        <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                                                    </div>
                                                                </div>

                                                                <%-- Approval Popup --%>
                                                                <div dx-popup="{  
                                                                        height: 650,
                                                                        width: 600, 
                                                                        showTitle: true,
                                                                        titleTemplate: 'myTitle',
                                                                        closeOnEscape: false,
                                                                        dragEnabled: true,
                                                                        shading: true,
                                                                        bindingOptions:{ visible: 'Approval_popupVisible' }
                                                                }">
                                                                    <div data-options="dxTemplate: { name:'myTitle' }">
                                                                        <h4>Approval Checklist</h4>
                                                                    </div>
                                                                    <div data-options="dxTemplate:{ name: 'content' }">
                                                                        <form>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Date Approval Issued</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.DateIssued" ss-date />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Date Approval Expires</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.DateExpired" ss-date />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Buyers Name</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.BuyerName" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Contract Price</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.ContractPrice" money-mask />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Does Net Match - 1st Lien</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="SsCase.ApprovalChecklist.IsFirstLienMatch">
                                                                                        <option value="Y">Yes</option>
                                                                                        <option value="N">No</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Approved Net - 1st Lien</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.FirstLien" money-mask />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Does Net Match - 2nd Lien</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="SsCase.ApprovalChecklist.IsSecondLienMatch">
                                                                                        <option value="Y">Yes</option>
                                                                                        <option value="N">No</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>2nd Mortgage</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.SecondMortgage" money-mask />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Approved Net - 2nd Lien</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.SecondLien" money-mask />
                                                                                </div>
                                                                            </div>

                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Commission %</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.CommissionPercentage" percent-mask />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Commission Amount</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.CommissionAmount" money-mask />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Transfer Tax Amount Correct</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="SsCase.ApprovalChecklist.IsTransferTaxAmount">
                                                                                        <option value="Y">Yes</option>
                                                                                        <option value="N">No</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Approval Letter Saved</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="SsCase.ApprovalChecklist.IsApprovalLetterSaved">
                                                                                        <option value="Y">Yes</option>
                                                                                        <option value="N">No</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">
                                                                                    <h5>Confirm Occupancy</h5>
                                                                                </div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="SsCase.ApprovalChecklist.ConfirmOccupancy">
                                                                                        <option value="Vacant">Vacant</option>
                                                                                        <option value="Seller">Seller Occupied</option>
                                                                                        <option value="Tenant">Tenant Occupied</option>
                                                                                        <option value="Seller_Tenant">Seller + Tenant Occupied</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>

                                                                            <hr />
                                                                            <div class="pull-right">
                                                                                <button type="button" class="btn btn-danger" ng-click="approvalCancl()">Cancel </button>
                                                                                &nbsp;
                                                                            <button type="button" class="btn btn-primary" ng-click="approvalSave()">Save </button>

                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>

                                                                <%-- Valuation Popup --%>
                                                                <div dx-popup="{  
                                                                        height: 650,
                                                                        width: 600, 
                                                                        showTitle: true,
                                                                        titleTemplate: 'myTitle',
                                                                        closeOnEscape: false,
                                                                        dragEnabled: true,
                                                                        shading: true,
                                                                        bindingOptions:{ visible: 'Valuation_popupVisible' }
                                                                }">
                                                                    <div data-options="dxTemplate: { name:'myTitle' }">
                                                                        <h4>Valuations&nbsp;<pt-add ng-click="addPendingValue()"></pt-add></h4>
                                                                    </div>
                                                                    <div data-options="dxTemplate:{ name: 'content' }">
                                                                        <tabset class="tab-switch">
                                                                            <tab ng-repeat="valuation in SsCase.ValueInfoes|filter: {Pending: true} " heading={{$index+1}}>
                                                                                <div class="text-right" ng-show="$index>-1"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="removePendingValue(valuation)" title="Delete"></i></div>
                                                                                <div ng-show="Valuation_Show_Option==1||Valuation_Show_Option==2||Valuation_Show_Option==3">
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Type of Valuation</div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="valuation.Method">
                                                                                        <option></option>
                                                                                        <option>AVM</option>
                                                                                        <option>Exterior Appraisal</option>
                                                                                        <option>Exterior BPO</option>
                                                                                        <option>Interior Appraisal</option>
                                                                                        <option>Interior BPO</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Date of Call</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.DateOfCall" ss-date/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">BPO Agent</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.AgentName" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Agent Phone #</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.AgentPhone" />
                                                                                </div>
                                                                            </div>
                                                                            <hr />
                                                                        </div>
                                                                                <div ng-show="Valuation_Show_Option==2||Valuation_Show_Option==3">
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Date of Valuation</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.DateOfValue" ss-date />
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Time of Valuation</div>
                                                                                <div class="col-sm-5">
                                                                                    <timepicker show-spinners="false" ng-model="valuation.TimeOfValuation"></timepicker>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Access</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.Access">
                                                                                </div>
                                                                            </div>
                                                                            <hr />
                                                                        </div>
                                                                                <div ng-show="Valuation_Show_Option==3">
                                                                            <div class="row">
                                                                                <div class="col-sm-6">Valuation Completed</div>
                                                                                <div class="col-sm-5">
                                                                                    <select class="form-control" ng-model="valuation.IsValuationComplete">
                                                                                        <option value="y">Yes</option>
                                                                                        <option value="n">No</option>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row" ng-show="valuation.IsValuationComplete=='y'">
                                                                                <div class="col-sm-6">Complete Date</div>
                                                                                <div class="col-sm-5">
                                                                                    <input type="text" class="form-control" ng-model="valuation.DateComplate">
                                                                                </div>
                                                                            </div>
                                                                            <hr />
                                                                        </div>

                                                                        <div class="pull-right">
                                                                            <button type="button" class="btn btn-warning" ng-click="valuationCanl()">Cancel</button>
                                                                            &nbsp;
                                                                            <button type="button" class="btn btn-primary" ng-click="valuationSave()">Save</button>
                                                                            &nbsp;
                                                                            <button ng-show="Valuation_Show_Option==3" type="button" class="btn btn-success" ng-click="valuationCompl(valuation)">Complete</button>
                                                                        </div>
                                                                            </tab>
                                                                        </tabset>
                                                                    </div>

                                                                </div>


                                                            </div>
                                                        </dx:SplitterContentControl>
                                                    </ContentCollection>
                                                </dx:SplitterPane>

                                                <%-- Log Panel--%>
                                                <dx:SplitterPane ShowCollapseForwardButton="True" Name="LogPanel" AutoHeight="true">
                                                    <Panes>
                                                        <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9">
                                                            <PaneStyle BackColor="#F9F9F9"></PaneStyle>
                                                            <ContentCollection>
                                                                <dx:SplitterContentControl ID="SplitterContentControl4" runat="server">
                                                                    <div style="font-size: 12px; color: #9fa1a8;">
                                                                        <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                                                                            <li class="short_sale_head_tab activity_light_blue">
                                                                                <a href="#activity_log" role="tab" data-toggle="tab" class="tab_button_a">
                                                                                    <i class="fa fa-history head_tab_icon_padding"></i>
                                                                                    <div class="font_size_bold">Activity Log</div>
                                                                                </a>
                                                                            </li>
                                                                            <li class="short_sale_head_tab">
                                                                                <a href="#file_overview" role="tab" data-toggle="tab" class="tab_button_a" onclick="">
                                                                                    <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                                                                    <div class="font_size_bold">File View</div>
                                                                                </a>
                                                                            </li>
                                                                            <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                                                            <li style="margin-right: 30px; color: #7396a9; float: right">
                                                                                <i class="fa fa-repeat sale_head_button tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);" style="display: none"></i>
                                                                                <i class="fa fa-folder-open sale_head_button sale_head_button_left tooltip-examples" title="Active" onclick="LogClick('Active')"></i>
                                                                                <i class="fa fa-rotate-right sale_head_button sale_head_button_left tooltip-examples" title="Archived" onclick="LogClick('Archived')"></i>
                                                                                <i class="fa fa-sign-out  sale_head_button sale_head_button_left tooltip-examples" title="Eviction" style="display: none" onclick="tmpBBLE=leadsInfoBBLE;popupEvictionUsers.PerformCallback();popupEvictionUsers.ShowAtElement(this);"></i>
                                                                                <i class="fa fa-pause sale_head_button sale_head_button_left tooltip-examples" title="On Hold" onclick="LogClick('OnHold')" style="display: none"></i>
                                                                                <i class="fa fa-key sale_head_button sale_head_button_left tooltip-examples" title="Enable Title" onclick="MoveToTitle()"></i>
                                                                                <i class="fa fa-wrench sale_head_button sale_head_button_left tooltip-examples" title="Move to Construction" onclick="MoveToConstruction()"></i>
                                                                               
                                                                            </li>
                                                                        </ul>
                                                                        <dx:ASPxCallbackPanel runat="server" ID="cbpLogs" ClientInstanceName="cbpLogs" OnCallback="cbpLogs_Callback">
                                                                            <PanelCollection>
                                                                                <dx:PanelContent>
                                                                                    <div class="tab-content">
                                                                                        <div class="tab-pane active" id="activity_log">
                                                                                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" DisplayMode="ShortSale" />
                                                                                        </div>
                                                                                        <div class="tab-pane" id="file_overview">
                                                                                            <uc1:ShortSaleFileOverview runat="server" ID="ShortSaleFileOverview" Category="ShortSale" />
                                                                                        </div>
                                                                                    </div>
                                                                                </dx:PanelContent>
                                                                            </PanelCollection>
                                                                            <ClientSideEvents EndCallback="" />
                                                                        </dx:ASPxCallbackPanel>

                                                                    </div>
                                                                    <dx:ASPxPopupMenu ID="ASPxPopupCallBackMenu2" runat="server" ClientInstanceName="ASPxPopupMenuClientControl"
                                                                        AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                                                        <Items>
                                                                            <dx:MenuItem Text="Tomorrow" Name="Tomorrow"></dx:MenuItem>
                                                                            <dx:MenuItem Text="Next Week" Name="NextWeek"></dx:MenuItem>
                                                                            <dx:MenuItem Text="30 Days" Name="ThirtyDays">
                                                                            </dx:MenuItem>
                                                                            <dx:MenuItem Text="60 Days" Name="SixtyDays">
                                                                            </dx:MenuItem>
                                                                            <dx:MenuItem Text="Custom" Name="Custom">
                                                                            </dx:MenuItem>
                                                                        </Items>
                                                                        <ClientSideEvents ItemClick="OnCallbackMenuClick" />
                                                                    </dx:ASPxPopupMenu>
                                                                    <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectDateControl" Width="260px" Height="250px"
                                                                        MaxWidth="800px" MaxHeight="150px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                                                                        HeaderText="Select Date" Modal="true"
                                                                        runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                                                        <ContentCollection>
                                                                            <dx:PopupControlContentControl runat="server">
                                                                                <asp:Panel ID="Panel1" runat="server">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False" Visible="false"></dx:ASPxCalendar>
                                                                                                <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="ASPxDateEdit1" ClientInstanceName="ScheduleDateClientFllowUp" TimeSectionProperties-Visible="True" CssClass="edit_drop">
                                                                                                    <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                                                                    <ClientSideEvents DropDown="function(s,e){var d = new Date('May 1 2014 12:00:00');s.GetTimeEdit().SetValue(d);}" />
                                                                                                </dx:ASPxDateEdit>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                                                                <dx:ASPxButton ID="ASPxButton1" runat="server" UseSubmitBehavior="false" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                                                                                    <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();LogClick('FollowUp', ScheduleDateClientFllowUp!=null?ScheduleDateClientFllowUp.GetDate().toLocaleString():callbackCalendar.GetSelectedDate().toLocaleString());}"></ClientSideEvents>
                                                                                                </dx:ASPxButton>
                                                                                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();}"></ClientSideEvents>
                                                            </dx:ASPxButton>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </asp:Panel>
                                                                            </dx:PopupControlContentControl>
                                                                        </ContentCollection>
                                                                    </dx:ASPxPopupControl>
                                                                    <dx:ASPxPopupControl ClientInstanceName="ASPxPopupScheduleClient" Width="400px" Height="280px"
                                                                        MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl1"
                                                                        HeaderText="Appointment" Modal="true"
                                                                        runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
                                                                        <HeaderTemplate>
                                                                            <div class="clearfix">
                                                                                <div class="pop_up_header_margin">
                                                                                    <i class="fa fa-clock-o with_circle pop_up_header_icon"></i>
                                                                                    <span class="pop_up_header_text">Appointment</span>
                                                                                </div>
                                                                                <div class="pop_up_buttons_div">
                                                                                    <i class="fa fa-times icon_btn" onclick="ASPxPopupScheduleClient.Hide()"></i>
                                                                                </div>
                                                                            </div>
                                                                        </HeaderTemplate>
                                                                        <ContentCollection>
                                                                            <dx:PopupControlContentControl runat="server">
                                                                            </dx:PopupControlContentControl>
                                                                        </ContentCollection>
                                                                    </dx:ASPxPopupControl>
                                                                </dx:SplitterContentControl>
                                                            </ContentCollection>
                                                        </dx:SplitterPane>
                                                    </Panes>
                                                </dx:SplitterPane>
                                            </Panes>
                                        </dx:ASPxSplitter>
                                    </dx:PanelContent>
                                </PanelCollection>

                            </dx:ASPxCallbackPanel>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>
    <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
    <uc1:SelectPartyUC runat="server" ID="SelectPartyUC" />
    <uc1:ShortSaleSubMenu runat="server" ID="ShortSaleSubMenu" />
    <input type="hidden" id="CaseData" />
    <input type="hidden" id="LastUpdateTime" />
    <uc1:Common runat="server" ID="Common" />
    <script type="text/javascript">
        AllContact = <%= GetAllContact()%>
            function t() {

            }
        ALLTeam = <%= GetAllTeam()%>
        function GetShortSaleData(caseId) {
            NGGetShortSale(caseId);

            if (cbpLogs)
                cbpLogs.PerformCallback(caseId);
        }

        function OnSuccess(response) {

            ShortSaleCaseData = response;  //JSON.parse(response.d);
            leadsInfoBBLE = ShortSaleCaseData.BBLE;
            //ShortSaleDataBand(0);

        }
    </script>
    <script type="text/javascript">

        function GetLasTUpDateURL()
        {
            return 'ShortSaleServices.svc/GetCaseLastUpDateTime?caseId=' + window.caseId
        }
        function NGGetShortSale(caseId) {
            $(document).ready(function () {
                angular.element(document.getElementById('ShortSaleCtrl')).scope().GetShortSaleCase(caseId);
            });
        }
        function CaseDataChanged() {
            return ScopeCaseDataChanged(GetShortSaleCase)
        }
        function ResetCaseDataChange() {
            ScopeResetCaseDataChange(GetShortSaleCase)
        }
        function GetShortSaleCase() {
            return angular.element(document.getElementById('ShortSaleCtrl')).scope().SsCase;
        }

        function MoveToConstruction() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().MoveToConstruction(
                function () {
                    if (typeof gridTrackingClient != "undefined") {
                        alert("Success");
                        gridTrackingClient.Refresh();
                    }
                });
        }

        function UpdateMortgageStatus(selType1, selStatusUpdate, selCategory) {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().UpdateMortgageStatus(selType1, selStatusUpdate, selCategory)
        }

        function MoveToTitle() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().MoveToTitle(
                function () {
                    if (typeof gridTrackingClient != "undefined") {
                        alert("Success");
                        gridTrackingClient.Refresh();
                    }
                });
        }


        function ssToggleApprovalPopup(succ, cancl) {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().regApproval(succ, cancl);
            angular.element(document.getElementById('ShortSaleCtrl')).scope().toggleApprovalPopup();
        }

        function ssToggleValuationPopup(status, succ, cancl) {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().regValuation(succ, cancl);
            angular.element(document.getElementById('ShortSaleCtrl')).scope().toggleValuationPopup(status);
        }

        function SaveShortSaleCase()
        {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().SaveShortSale();
        }

        $(document).ready(function () {
            ScopeAutoSave(GetShortSaleCase, angular.element(document.getElementById('ShortSaleCtrl')).scope().SaveShortSale, '#ShortSaleTabHead')
        })

        portalApp = angular.module('PortalApp');

        portalApp.controller('ShortSaleCtrl', function ($scope, $http, $timeout, ptContactServices, ptCom) {

            $scope.ptContactServices = ptContactServices;
            $scope.capitalizeFirstLetter = ptCom.capitalizeFirstLetter;
            $scope.formatName = ptCom.formatName;
            $scope.formatAddr = ptCom.formatAddr;

            //move to construction - add by chris
            $scope.MoveToConstruction = function (scuessfunc) {
                var json = $scope.SsCase;
                var data = { bble: leadsInfoBBLE };

                $http.post('ShortSaleServices.svc/MoveToConstruction', JSON.stringify(data)).
                        success(function () {
                            if (scuessfunc) {
                                scuessfunc();
                            } else {
                                alert("Successed !");
                            }
                        }).
                        error(function (data, status) {
                            alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                        });
            }

            $scope.MoveToTitle = function (scuessfunc) {
                var json = $scope.SsCase;
                var data = { bble: leadsInfoBBLE };

                $http.post('ShortSaleServices.svc/MoveToTitle', JSON.stringify(data)).
                        success(function () {
                            if (scuessfunc) {
                                scuessfunc();
                            } else {
                                alert("Successed !");
                            }
                        }).
                        error(function (data, status) {
                            alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                        });
            }
            // -- end --

            var cStore = new DevExpress.data.CustomStore({
                load: function (loadOptions) {

                    if (AllContact) {
                        if (loadOptions.searchValue) {
                            return AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
                        }
                        return [];
                    }
                    var d = $.Deferred();
                    if (loadOptions.searchValue) {
                        $.getJSON('/Services/ContactService.svc/GetContacts?args=' + loadOptions.searchValue).done(function (data) {
                            d.resolve(data);
                        });
                    } else {

                        $.getJSON('/Services/ContactService.svc/LoadContacts').done(function (data) {
                            d.resolve(data);
                            AllContact = data;
                        });
                    }

                    return d.promise();
                },
                byKey: function (key) {
                    if (AllContact) {
                        return AllContact.filter(function (o) { return o.ContactId == key })[0];
                    }
                    var d = new $.Deferred();
                    $.get('/Services/ContactService.svc/GetAllContacts?id=' + key)
                        .done(function (result) {
                            d.resolve(result);
                        });
                    return d.promise();
                },
                searchExpr: ["Name"]
            });
            $scope.ContactDataSource = new DevExpress.data.DataSource({
                store: cStore
            });
            $scope.RoboSingerDataSource = new DevExpress.data.DataSource({
                store: new DevExpress.data.CustomStore({
                    load: function (loadOptions) {

                        if (AllRoboSignor) {
                            if (loadOptions.searchValue) {
                                return AllRoboSignor.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(loadOptions.searchValue.toLowerCase()) >= 0 } return false });
                            }
                            return [];
                        }
                    },
                    byKey: function (key) {
                        if (AllRoboSignor) {
                            return AllRoboSignor.filter(function (o) { return o.ContactId == key })[0];
                        }

                    },
                    searchExpr: ["Name"]
                })
            });

            $scope.onChange = function (newModel, newValue) {
                if (newValue && newModel) {
                    $scope.$eval(newModel + '=' + newValue);
                }
            }

            $scope.PickedContactId = null;

            $scope.TestContactId = function (c) {
                $scope.$eval(c + '=' + '192');
            }
            $scope.GetContactById = function (id) {
                return AllContact.filter(function (o) { return o.ContactId == id })[0];
            }

            $scope.SelectBoxChange = function (e) {
                alert(JSON.stringify(e));
            }


            $scope.InitContact = function (id, dataSourceName) {
                return {
                    dataSource: dataSourceName ? $scope[dataSourceName] : $scope.ContactDataSource,
                    valueExpr: 'ContactId',
                    displayExpr: 'Name',
                    searchEnabled: true,
                    minSearchLength: 2,
                    noDataText: "Please input to search",
                    bindingOptions: { value: id }
                };
            }

            /* steven code */

            var CaseInfo = { Name: '', Address: '' }

            $scope.SsCase = {
                PropertyInfo: { Owners: [{}] },
                CaseData: {}
            };
            $scope.GetTeamByName = function (teamName) {
                if (teamName) {
                    return ALLTeam.filter(function (o) { return o.Name == teamName })[0];
                }

            }
            $scope.GetContactByName = function (teamName) {
                if (AllContact && teamName) {
                    var ctax = AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
                    return AllContact.filter(function (o) { if (o.Name) { return o.Name.toLowerCase().indexOf(teamName.toLowerCase()) >= 0 } return false })[0];
                }
                return {}
            }
            $scope.GetShortSaleCase = function (caseId) {
                var url = "ShortSaleServices.svc/GetCase?caseId=" + caseId;
                $http.get(url).
                    success(function (data, status, headers, config) {
                        $scope.SsCase = data;
                        leadsInfoBBLE = $scope.SsCase.BBLE;
                        window.caseId = caseId;
                        var leadsInfoUrl = "ShortSaleServices.svc/GetLeadsInfo?bble=" + $scope.SsCase.BBLE;
                        $http.get(leadsInfoUrl).
                            success(function (data, status, headers, config) {
                                $scope.ReloadedData = {};
                                $scope.SsCase.LeadsInfo = data;
                                $('#CaseData').val(JSON.stringify($scope.SsCase))
                                ScopeSetLastUpdateTime(GetLasTUpDateURL())
                                
                            }).error(function (data, status, headers, config) {
                                alert("Get Short sale Leads failed BBLE =" + $scope.SsCase.BBLE + " error : " + JSON.stringify(data));
                            });

                    }).
                    error(function (data, status, headers, config) {
                        alert("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
                    });
            }
            $scope.GetLoadId = function ()
            {
                return window.caseId;
            }
            ScopeDateChangedByOther(GetLasTUpDateURL, $scope.GetShortSaleCase, $scope.GetLoadId);
            $scope.NGAddArraryItem = function (item, model, popup) {

                if (model) {
                    var array = $scope.$eval(model);
                    if (!array) { $scope.$eval(model + '=[{}]'); }
                    else { $scope.$eval(model + '.push({})'); }
                } else { item.push({}); }
                if (popup) { $scope.setVisiblePopup(item[item.length - 1], true); }

                }

            $scope.SaveShortSale = function (scuessfunc) {
                var json = $scope.SsCase;
                var data = { caseData: JSON.stringify(json) };

                $http.post('ShortSaleServices.svc/SaveCase', JSON.stringify(data)).
                        success(function () {
                            if (scuessfunc) {
                                scuessfunc();
                            } else {
                                alert("Save Successed !");
                            }
                            
                            ScopeSetLastUpdateTime(GetLasTUpDateURL());
                            ResetCaseDataChange();
                        }).
                        error(function (data, status) {
                            alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                        });
            }
            $scope.ShowAddPopUp = function (event) {
                $scope.addCommentTxt = "";
                aspxAddLeadsComments.ShowAtElement(event.target);
            }
            $scope.AddComments = function () {

                $http.post('ShortSaleServices.svc/AddComments', { comment: $scope.addCommentTxt, caseId: $scope.SsCase.CaseId }).success(function (data) {
                    $scope.SsCase.Comments.push(data);
                }).error(function (data, status) {
                    alert("Fail to AddComments. status " + status + "Error : " + JSON.stringify(data));
                });

            }
            $scope.DeleteComments = function (index) {
                var comment = $scope.SsCase.Comments[index];
                $http.get('ShortSaleServices.svc/DeleteComment?commentId=' + comment.CommentId).success(function (data) {
                    $scope.SsCase.Comments.splice(index, 1);
                }).error(function (data, status) {
                    alert("Fail to delete comment. status " + status + "Error : " + JSON.stringify(data));
                });
            }
            $scope.GetCaseInfo = function () {
                var caseName = $scope.SsCase.CaseName
                if (caseName) {
                    CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
                    var matched = caseName.match(/-(?!.*-).*$/);
                    CaseInfo.Name = matched[0].replace('-', '')
                }
                return CaseInfo;
            }


            /* stephen code */
            $scope.SsCase.Mortgages = [{}];
            $scope.NGremoveArrayItem = function (item, index, disable) {
                var r = window.confirm("Deletion This?");
                if (r) {
                    if (disable) item[index].DataStatus = 3;
                    else item.splice(index, 1);
                }

            };
            $http.get('/Services/ContactService.svc/getbanklist')
                .success(function (data) {
                    $scope.bankNameOptions = data;
                })
                .error(function (data) {
                    $scope.bankNameOptions = [];
                });
            $scope.setVisiblePopup = function (model, value) {

                if (model) model.visiblePopup = value;
                _.defer(function () { $scope.$apply(); });

            }
            /* approval popup */
            $scope.SsCaseApprovalChecklist = {};
            $scope.Approval_popupVisible = false;

            $scope.approvalSave = function () {
                if ($scope.approvalSuccCallback) $scope.approvalSuccCallback();
                $scope.SaveShortSale();
                $scope.Approval_popupVisible = false;
            };
            $scope.approvalCancl = function () {
                if ($scope.approvalCanclCallback) $scope.approvalCanclCallback();
                $scope.Approval_popupVisible = false;
            };
            $scope.regApproval = function (succ, cancl) {
                if (!$scope.approvalSuccCallback) $scope.approvalSuccCallback = succ;
                if (!$scope.approvalCanclCallback) $scope.approvalCanclCallback = cancl;
            }
            $scope.toggleApprovalPopup = function () {
                $scope.$apply(function () {
                    $scope.Approval_popupVisible = !$scope.Approval_popupVisible;
                });
            }
            /* end approval popup */

            /* valuation popup */
            $scope.ValuationWatchField = {
                Method: 'Type of Valuation',
                DateOfCall: 'Date of Call',
                AgentName: 'BPO Agent',
                AgentPhone: 'Agent Phone #',
                DateOfValue: 'Date of Valuation',
                TimeOfValuation: 'Time of Valuation',
                Access: 'Access',
                IsValuationComplete: 'Valuation Completed',
                DateComplate: 'Complete Date'
            }
            $scope.Valuation_popupVisible = false;
            $scope.Valuation_Show_Option = 1;
            $scope.addPendingValue = function () {
                $scope.SsCase.ValueInfoes.push({ Pending: true });
            }
            $scope.removePendingValue = function (el) {
                var index = $scope.SsCase.ValueInfoes.indexOf(el);
                $scope.NGremoveArrayItem($scope.SsCase.ValueInfoes, index)

            }
            $scope.ensurePendingValue = function () {
                var existPending = false;
                angular.forEach($scope.SsCase.ValueInfoes, function (el, index) {
                    if (el.Pending) existPending = true;
                })
                if (!existPending) $scope.addPendingValue();
            }
            $scope.setPendingModified = function () {
                $scope.oldPendingValues = []
                _.each($scope.SsCase.ValueInfoes, function (el, index) {
                    if (el.Pending) {
                        var newEl = {}
                        for (var property in el) {
                            if (el.hasOwnProperty(property)) {
                                newEl[property] = el[property]
                            }
                        }
                        $scope.oldPendingValues.push(newEl)
                    }
                })
            }
            $scope.checkPendingModified = function () {
                var updates = '';
                _.each($scope.SsCase.ValueInfoes, function (el, index) {
                    if (el.Pending) {
                        var oldEl = $scope.oldPendingValues.filter(function (e, i) { return e.$$hashKey == el.$$hashKey })[0];
                        if (!oldEl) {
                            for (var property in el) {
                                if ($scope.ValuationWatchField.hasOwnProperty(property)) {
                                    updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                                }
                            }
                        } else {
                            for (var property in el) {
                                if ($scope.ValuationWatchField[property] && el[property] !== oldEl[property]) {
                                    updates += 'Valuation' + index + ' <b>' + $scope.ValuationWatchField[property] + '</b> changes to <b>' + el[property] + '</b><br/>';
                                }
                            }
                        }

                    }
                })
                //console.log(updates)
                return updates;
            }

            $scope.restorePendingModified = function () {
                _.remove($scope.SsCase.ValueInfoes, function (el, index) {
                    return el.Pending;
                })
                _.each($scope.oldPendingValues, function (el, index) {
                    $scope.SsCase.ValueInfoes.push(el)
                })
            }

            $scope.valuationCanl = function () {
                $scope.restorePendingModified();
                if ($scope.valuationCanclCallback) $scope.valuationCanclCallback();
                $scope.Valuation_popupVisible = false;
            }

            $scope.valuationSave = function () {
                var updates = $scope.checkPendingModified();
                if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates); 
                $scope.Valuation_popupVisible = false;

            };
            $scope.valuationCompl = function (el) {
                var updates = $scope.checkPendingModified();
                if ($scope.valuationSuccCallback) $scope.valuationSuccCallback(updates);
                el.Pending = false;
                $scope.Valuation_popupVisible = false;
            }
            $scope.regValuation = function (succ, cancl) {
                if (!$scope.valuationSuccCallback) $scope.valuationSuccCallback = succ;
                if (!$scope.valuationCanclCallback) $scope.valuationCanclCallback = cancl;
            }
            $scope.toggleValuationPopup = function (status) {
                $scope.$apply(function () {
                    $scope.Valuation_Show_Option = status
                    $scope.setPendingModified()
                    $scope.ensurePendingValue()
                    $scope.Valuation_popupVisible = !$scope.Valuation_popupVisible;
                });
            }

            /* end valuation popup */

            /* update mortage status */
            $scope.UpdateMortgageStatus = function (selType1, selStatusUpdate, selCategory) {
                var index = 0;
                switch (selType1) {
                    case '2nd Lien':
                        index = 1;
                        break;
                    case '3d Lien':
                        index = 2;
                        break;
                    default:
                        index = 0;
                }

                $timeout(function () {

                    if ($scope.SsCase.Mortgages[index]) {
                        $scope.SsCase.Mortgages[index].Category = selCategory;
                        $scope.SsCase.Mortgages[index].Status = selStatusUpdate;
                    }

                })

            }
            /* end update mortage status*/
        });

    </script>

</asp:Content>


