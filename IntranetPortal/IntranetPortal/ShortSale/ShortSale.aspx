<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSale.aspx.vb" Inherits="IntranetPortal.NGShortSale" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/ShortSale/TitleControl.ascx" TagPrefix="uc1" TagName="Title" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/ShortSale/SelectPartyUC.ascx" TagPrefix="uc1" TagName="SelectPartyUC" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>
<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/ShortSale/ShortSaleFileOverview.ascx" TagPrefix="uc1" TagName="ShortSaleFileOverview" %>
<%@ Register Src="~/ShortSale/NGShortSaleTab.ascx" TagPrefix="uc1" TagName="NGShortSaleTab" %>
<%@ Register Src="~/BusinessForm/BusinessFormControl.ascx" TagPrefix="uc1" TagName="BusinessFormControl" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <link href="/bower_components/webui-popover/dist/jquery.webui-popover.min.css" rel="stylesheet" />
    <script src="/bower_components/webui-popover/dist/jquery.webui-popover.min.js"></script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script>
        /* immediately call to show the loading panel*/
        (function () {
            var loadingCover = document.getElementById("LodingCover");
            loadingCover.style.display = "block";
        })();

    </script>

    <style>
        .dxgvControl_MetropolisBlue1 {
            width: auto !important;
        }

        .dxgvHSDC div, .dxgvCSD {
            width: auto !important;
        }
    </style>

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
        };
    </script>
    <asp:HiddenField runat="server" ID="hfIsEvction" Value="false" />

    <div ui-layout="{flow: 'column'}" id="uiLayoutDiv">
        <div ui-layout-container hideafter size="280px" max-size="320px" runat="server" id="listdiv">
            <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />
        </div>
        <div ui-layout-container id="dataPanelDiv">
            <asp:Panel runat="server" ID="dataPanel">
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
                            <%-- Only MyIdeal property is show those title --%>
                            <% If IntranetPortal.Employee.CurrentAppId = 1 Then  %>
                            <li class="short_sale_head_tab">
                                <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a" onclick="BusinessFormControl.LoadData(leadsInfoBBLE)">
                                    <i class="fa fa-key head_tab_icon_padding"></i>
                                    <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;Title&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                </a>
                            </li>
                            <% End if %>
                            <li class="short_sale_head_tab">
                                <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                                    <i class="fa fa-file head_tab_icon_padding"></i>
                                    <div class="font_size_bold">Documents</div>
                                </a>
                            </li>
                            <%-- Only MyIdeal property is show those title --%>
                            <% If IntranetPortal.Employee.CurrentAppId = 1 Then  %>
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
                                            <a role="tab" data-toggle="tab" class="tab_button_a" href="#more_legal" data-url="/LegalUI/LegalUI.aspx?HiddenTab=true&isEviction=true&bble={{SsCase.BBLE}}" data-href="#more_legal" onclick="LoadMoreFrame(this)">
                                                <i class="fa fa-university head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Legal</div>
                                            </a>
                                        </li>

                                    </ul>
                                </div>
                            </li>
                            <% End If   %>
                            <li class="pull-right" style="margin-right: 10px; color: #ffa484">
                                <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" onclick="SaveShortSaleCase()" data-original-title="Save"></i>
                                <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Re-Assign" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);"></i>
                                <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i>
                                <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick=""></i>
                            </li>
                        </ul>
                    </div>
                    <% End If%>

                    <div class="tab-content">
                        <div class="tab-pane active" id="property_info">
                            <uc1:NGShortSaleTab runat="server" ID="NGShortSaleTab" />
                        </div>
                        <div class="tab-pane " id="home_owner">
                            <uc1:Title runat="server" ID="ucTitle" Visible="false" />
                            <uc1:BusinessFormControl runat="server" ID="BusinessFormControl" ControlName="Title" />
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
                            <div>
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
                                        <input class="form-control" type="text" ng-model="SsCase.ApprovalChecklist.BuyerName" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" />
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
                            </div>
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
                                        <input type="text" class="form-control" ng-model="valuation.DateOfCall" ss-date />
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6">BPO Agent</div>
                                    <div class="col-sm-5">
                                        <input type="text" class="form-control" ng-model="valuation.AgentName" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" />
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
                                        <uib-timepicker show-spinners="false" ng-model="valuation.TimeOfValue"></uib-timepicker>
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
            </asp:Panel>
        </div>
        <div ui-layout-container>
            <asp:Panel runat="server" ID="logPanel">
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
                            <i class="fa fa-key sale_head_button sale_head_button_left tooltip-examples" title="Enable Title" onclick="tmpBBLE=leadsInfoBBLE; popupTitleUsers.PerformCallback();popupTitleUsers.ShowAtElement(this);"></i>
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
            </asp:Panel>
        </div>
    </div>

    <uc1:SendMail runat="server" ID="SendMail" LogCategory="ShortSale" />

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
                                <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False" Visible="true"></dx:ASPxCalendar>
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                <dx:ASPxButton ID="ASPxButton1" runat="server" UseSubmitBehavior="false" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                    <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();LogClick('FollowUp', callbackCalendar.GetSelectedDate().toLocaleString());}"></ClientSideEvents>
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

    <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
    <uc1:SelectPartyUC runat="server" ID="SelectPartyUC" />
    <uc1:ShortSaleSubMenu runat="server" ID="ShortSaleSubMenu" />
    <input type="hidden" id="CaseData" />
    <input type="hidden" id="LastUpdateTime" />
    <uc1:Common runat="server" ID="Common" />

    <script type="text/javascript">
        function OnSuccess(response) {
            ShortSaleCaseData = response;  //JSON.parse(response.d);
            leadsInfoBBLE = ShortSaleCaseData.BBLE;
        }

        function GetLasTUpDateURL() {
            return window.caseId ? 'ShortSaleServices.svc/GetCaseLastUpDateTime?caseId=' + window.caseId : '';
        }

        function NGGetShortSale(caseId) {
            $(document).ready(function () {
                angular.element(document.getElementById('ShortSaleCtrl')).scope().GetShortSaleCase(caseId, function () {
                    ScopeSetLastUpdateTime(GetLasTUpDateURL());
                });
            });
        }

        function GetShortSaleData(caseId) {
            NGGetShortSale(caseId);
            if (cbpLogs) {
                cbpLogs.PerformCallback(caseId);
            }
        }

        function CaseDataChanged() {
            return ScopeCaseDataChanged(GetShortSaleCase);
        }
        function ResetCaseDataChange() {
            ScopeResetCaseDataChange(GetShortSaleCase);
        }
        function GetShortSaleCase() {
            return angular.element(document.getElementById('ShortSaleCtrl')).scope().SsCase;
        }


        function MoveToConstruction() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().MoveToConstruction(
                function () {
                    if (typeof gridTrackingClient != "undefined") {
                        AngularRoot.alert("Success");
                        gridTrackingClient.Refresh();
                    }
                });
        }

        function UpDateFollowUpDate(date) {
            var UtcDate = new Date(date);
            var utcdate = UtcDate.getMonth() + '/' + UtcDate.getDay() + '/' + UtcDate.getFullYear();
            GetShortSaleCase().CallbackDate = utcdate;
        }

        function UpdateMortgageStatus(selType1, selStatusUpdate, selCategory) {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().UpdateMortgageStatus(selType1, selStatusUpdate, selCategory);
        }

        function MoveToTitle() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().MoveToTitle(
                function () {
                    if (typeof gridTrackingClient != "undefined") {
                        AngularRoot.alert("Success");
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

        function SaveShortSaleCase() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().SaveShortSale(
                function () {
                    ScopeSetLastUpdateTime(GetLasTUpDateURL());
                    ResetCaseDataChange();
                });
        }

        function AutoSaveShortSale() {
            angular.element(document.getElementById('ShortSaleCtrl')).scope().AutoSaveShortSale(function () { ScopeSetLastUpdateTime(GetLasTUpDateURL()); ResetCaseDataChange(); });
        }

        $(document).ready(function () {
            var $scope = angular.element(document.getElementById('ShortSaleCtrl')).scope();
            ScopeDateChangedByOther(GetLasTUpDateURL, $scope.GetShortSaleCase, $scope.GetLoadId, $scope.GetModifyUserUrl);
            ScopeAutoSave(GetShortSaleCase, AutoSaveShortSale, '#ShortSaleTabHead');
        });              

    </script>

</asp:Content>


