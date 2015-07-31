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
                return "You have pending changes, did you save it?";
        }
    </script>
    <asp:HiddenField runat="server" ID="hfIsEvction" Value="false" />
    <div style="background: url(/images/MyIdealProptery.png) no-repeat center fixed; background-size: 260px, 280px; background-color: #dddddd; width: 100%; height: 100%;">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="2px">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px">
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
                                                <dx:SplitterPane ShowCollapseBackwardButton="True" MinSize="665px" AutoHeight="true">
                                                    <PaneStyle Paddings-Padding="0">
                                                        <Paddings Padding="0px"></Paddings>
                                                    </PaneStyle>
                                                    <ContentCollection>
                                                        <dx:SplitterContentControl ID="SplitterContentControl3" runat="server">
                                                            <div class="shortSaleUI" style="width: 100%; align-content: center; height: 100%" id="ShortSaleCtrl" ng-controller="ShortSaleCtrl">
                                                               
                                                                <asp:HiddenField ID="hfBBLE" runat="server" />
                                                                <!-- Nav tabs -->

                                                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white;">
                                                                    <li class="active short_sale_head_tab">
                                                                        <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                                            <i class="fa fa-sign-out fa-info-circle head_tab_icon_padding"></i>
                                                                            <div class="font_size_bold">ShortSale</div>
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
                                                                    <li class="short_sale_head_tab">
                                                                        <a class="tab_button_a">
                                                                            <i class="fa fa-list-ul head_tab_icon_padding"></i>
                                                                            <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;More&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                                        </a>
                                                                        <div class="shot_sale_sub">
                                                                            <ul class="nav  clearfix" role="tablist">
                                                                                <li class="short_sale_head_tab">
                                                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_leads" data-url="" data-href="#more_leads" onclick="LoadMoreFrame(this)">
                                                                                        <i class="fa fa-folder head_tab_icon_padding"></i>
                                                                                        <div class="font_size_bold">Leads</div>
                                                                                    </a>
                                                                                </li>
                                                                                <li class="short_sale_head_tab">
                                                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_evction" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&isEviction=true&bble=<%= hfBBLE.Value %>" data-href="#more_evction" onclick="LoadMoreFrame(this)">
                                                                                        <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                                                        <div class="font_size_bold">Eviction</div>
                                                                                    </a>
                                                                                </li>
                                                                                <%If IntranetPortal.Legal.LegalCase.InLegal(hfBBLE.Value) Then%>
                                                                                <li class="short_sale_head_tab">
                                                                                    <a role="tab" data-toggle="tab" class="tab_button_a" href="#more_legal" data-url="/LegalUI/LegalUI.aspx?HiddenTab=true&isEviction=true&bble=<%= hfBBLE.Value %>" data-href="#more_legal" onclick="LoadMoreFrame(this)">
                                                                                        <i class="fa fa-university head_tab_icon_padding"></i>
                                                                                        <div class="font_size_bold">Legal</div>
                                                                                    </a>
                                                                                </li>
                                                                                <% End If%>
                                                                            </ul>
                                                                        </div>
                                                                    </li>
                                                                    <li style="margin-right: 30px; color: #ffa484; float: right">
                                                                        <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="SaveShortSale()" data-original-title="Save"></i>
                                                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Re-Assign" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);"></i>
                                                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i>
                                                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick=""></i>
                                                                    </li>
                                                                </ul>
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
                                                            </div>
                                                        </dx:SplitterContentControl>
                                                    </ContentCollection>
                                                </dx:SplitterPane>
                                                <dx:SplitterPane ShowCollapseForwardButton="True" Name="LogPanel" MinSize="645px">
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
                                                                                <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="LogClick('Closed')" style="display: none"></i>
                                                                                <%--                                                                                <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>--%>
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
                                                                                            <uc1:ShortSaleFileOverview runat="server" ID="ShortSaleFileOverview" />
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
                                                                                                    <ClientSideEvents DropDown="function(s,e){ 
                                                                    var d = new Date('May 1 2014 12:00:00');                                                                    
                                                                    s.GetTimeEdit().SetValue(d);
                                                                    }" />
                                                                                                </dx:ASPxDateEdit>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                                                                <dx:ASPxButton ID="ASPxButton1" runat="server" UseSubmitBehavior="false" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                                                                                    <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                       
                                                                                                                        LogClick('FollowUp', ScheduleDateClientFllowUp!=null?ScheduleDateClientFllowUp.GetDate().toLocaleString():callbackCalendar.GetSelectedDate().toLocaleString());
                                                                                                                        }"></ClientSideEvents>
                                                                                                </dx:ASPxButton>
                                                                                                &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" UseSubmitBehavior="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>
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
    <input type="hidden" id="CaseData"/>
    <uc1:Common runat="server" ID="Common" />
    <script type="text/javascript">
        AllContact = <%= GetAllContact()%>
            function t() {

            }
        ALLTeam = <%=GetAllTeam() %>
        function GetShortSaleData(caseId) {

            //debugger;
            //$.ajax({
            //    type: "Get",
            //    url: "ShortSaleServices.svc/GetCase?caseId=" + caseId,                
            //    contentType: "application/json; charset=utf-8",
            //    dataType: "json",
            //    success: OnSuccess,
            //    failure: function (response) {
            //        alert("Get ShortSaleData failed" + response);
            //    },
            //    error: function (response) {
            //        alert("Get ShortSaleData error" + response);
            //    }
            //});
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
       
        function NGGetShortSale(caseId) {
            $(document).ready(function () {
                angular.element(document.getElementById('ShortSaleCtrl')).scope().GetShortSaleCase(caseId);
            });
        }
        function CaseDataChanged()
        {
            return $('#CaseData').val() != "" && $('#CaseData').val() != JSON.stringify(GetShortSaleCase())
        }
        function ResetCaseDataChange()
        {
            $('#CaseData').val(JSON.stringify(GetShortSaleCase()));
        }
        function GetShortSaleCase() {
            return angular.element(document.getElementById('ShortSaleCtrl')).scope().SsCase;
        }
        portalApp = angular.module('PortalApp');

        portalApp.controller('ShortSaleCtrl', function ($scope, $http, $element, $parse, ptContactServices) {

            $scope.ptContactServices = ptContactServices;
            /////test contact ///////////////
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

            /////////////////////////end test contact
            //Init Steven /////////

            $scope.SsCase = {
                PropertyInfo: { Owners: [{}] }

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
                        // this callback will be called asynchronously
                        // when the response is available
                        $scope.SsCase = data;
                        leadsInfoBBLE = $scope.SsCase.BBLE
                        var leadsInfoUrl = "ShortSaleServices.svc/GetLeadsInfo?bble=" + $scope.SsCase.BBLE;
                        $http.get(leadsInfoUrl).
                            success(function (data, status, headers, config) {
                                $scope.SsCase.LeadsInfo = data;
                                $('#CaseData').val(JSON.stringify($scope.SsCase))
                            }).error(function (data, status, headers, config) {

                                // called asynchronously if an error occurs
                                // or server returns response with an error status.
                                alert("Get Short sale Leads failed BBLE =" + $scope.SsCase.BBLE + " error : " + JSON.stringify(data));
                            });

                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                        alert("Get Short sale failed CaseId= " + caseId + ", error : " + JSON.stringify(data));
                    });
            }
            $scope.NGAddArraryItem = function (item, model, popup) {
                if (model) {
                    var array = $scope.$eval(model);
                    if (!array) {

                        $scope.$eval(model + '=[{}]');
                    } else {

                        $scope.$eval(model + '.push({})');


                    }
                } else {
                    item.push({});
                }

                if (popup) {
                    $scope.setVisiblePopup(item[item.length - 1], true);
                }

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
            var CaseInfo = { Name: '', Address: '' }
            $scope.GetCaseInfo = function () {
                var caseName = $scope.SsCase.CaseName
                if (caseName) {
                    CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
                    var matched = caseName.match(/-(?!.*-).*$/);
                    CaseInfo.Name = matched[0].replace('-', '')
                }
                return CaseInfo;
            }
            /////////////////Code Scope Steph ////////////////
            $scope.NGremoveArrayItem = function (item, index, disable) {
                if (disable) {
                    item[index].DataStatus = 3;
                } else {
                    item.splice(index, 1);
                }

            };

            $scope.SsCase.Mortgages = [{}];

            $http.get('/Services/ContactService.svc/getbanklist')
                .success(function (data) {
                    $scope.bankNameOptions = data;
                })
                .error(function (data) {
                    $scope.bankNameOptions = [];
                });


            $scope.setVisiblePopup = function (model, value) {
                if(model) model.visiblePopup = value;
            }

            function capitalizeFirstLetter(string) {
                return string.charAt(0).toUpperCase() + string.slice(1);
            }

            $scope.formatName = function (firstName, middleName, lastName) {
                var result = '';
                if (firstName) result += capitalizeFirstLetter(firstName) + ' ';
                if (middleName) result += capitalizeFirstLetter(middleName) + ' ';
                if (lastName) result += capitalizeFirstLetter(lastName);
                return result;

            }

            $scope.formatAddr = function(strNO, strName, aptNO, city, state, zip){
                var result = '';
                if(strNO) result += strNO + ' ';
                if(strName) result += strName + ', ';
                if (aptNO) result += 'Apt ' + aptNO + ', ';
                if (city) result += city + ', ';
                if (state) result += state + ', ';
                if (zip) result += zip;
                return result;
            }
        });

    </script>

</asp:Content>


