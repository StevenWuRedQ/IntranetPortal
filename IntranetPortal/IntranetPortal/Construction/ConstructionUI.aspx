<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUI.aspx.vb" Inherits="IntranetPortal.ConstructionUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/Construction/ConstructionCaseList.ascx" TagPrefix="uc1" TagName="ConstructionCaseList" %>
<%@ Register Src="~/Construction/ConstructionTab.ascx" TagPrefix="uc1" TagName="ConstructionTab" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>


<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">

    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
        <Panes>

            <%-- list panel  --%>
            <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                        <uc1:ConstructionCaseList runat="server" ID="ConstructionCaseList" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>

            <%-- data panel     --%>
            <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <div id="ConstructionCtrl" ng-controller="ConstructionCtrl" style="align-content: center;">
                            <!-- Nav tabs -->
                            <div class="legal-menu row" style="margin: 0px;">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                    <li class="active short_sale_head_tab">
                                        <a href="#ConstructionTab" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Construction</div>
                                        </a>
                                    </li>
                                    <li class="short_sale_head_tab">
                                        <a href="#DocumentTab" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
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
                                            <ul class="nav clearfix" role="tablist">
                                                <li class="short_sale_head_tab">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_leads" data-url="/ViewLeadsInfo.aspx?HiddenTab=true&id=BBLE" data-href="#more_leads" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-folder head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Leads</div>

                                                    </a>
                                                </li>
                                                <li class="short_sale_head_tab" ng-show="LegalCase.InShortSale">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_short_sale" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&bble=BBLE" data-href="#more_short_sale" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Short Sale</div>
                                                    </a>
                                                </li>
                                                <li class="short_sale_head_tab" ng-show="LegalCase.InShortSale">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_evction" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&isEviction=true&bble=BBLE" data-href="#more_evction" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Eviction</div>
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </li>
                                    <li class="pull-right" style="margin-right: 30px; color: #ffa484">
                                        <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="saveCSCase()" data-original-title="Save"></i>
                                        <i class="fa fa-mail-reply sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectOwner.PerformCallback('Show');popupSelectOwner.ShowAtElement(this);" data-original-title="Reassign"></i>
                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                    </li>
                                </ul>
                            </div>

                            <dx:ASPxPopupControl ClientInstanceName="popupSelectOwner" Width="300px" Height="300px"
                                MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
                                HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
                                runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
                                        <asp:HiddenField runat="server" ID="hfUserType" />
                                        <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" SelectedIndex="0" Width="100%">
                                        </dx:ASPxListBox>
                                        <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s,e){
                                        var item = listboxEmployeeClient.GetSelectedItem();
                                        if(item == null)
                                        {
                                             alert('Please select user.');
                                             return;
                                         }
                                        popupSelectOwner.PerformCallback('Save|' + leadsInfoBBLE + '|' + item.text);
                                        popupSelectOwner.Hide();
                                        }" />
                                        </dx:ASPxButton>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                                <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                              if (typeof gridCase != 'undefined')
                                                    gridCase.Refresh();    
                                        }" />
                            </dx:ASPxPopupControl>

                            <div class="tab-content">
                                <div class="tab-pane active" id="ConstructionTab">
                                    <uc1:ConstructionTab runat="server" ID="ConstructionTab1" />
                                </div>
                                <div class="tab-pane" id="DocumentTab">
                                    <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                </div>

                                <div class="tab-pane load_bg" id="more_leads">
                                    <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                </div>
                                <div class="tab-pane load_bg" id="more_evction">
                                    <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                </div>
                                <div class="tab-pane load_bg" id="more_short_sale">
                                    <iframe width="100%" height="100%" class="more_frame" frameborder="0"></iframe>
                                </div>
                            </div>

                        </div>

                        <dx:ASPxPopupControl ClientInstanceName="popupCtrUploadFiles" Width="950px" Height="840px" ID="ASPxPopupControl2"
                            HeaderText="Upload Files" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton"
                            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
                            <HeaderTemplate>
                                <div class="clearfix">
                                    <div class="pop_up_header_margin">
                                        <i class="fa fa-cloud-upload with_circle pop_up_header_icon"></i>
                                        <span class="pop_up_header_text">Upload Files</span>
                                    </div>
                                    <div class="pop_up_buttons_div">
                                        <i class="fa fa-times icon_btn" onclick="popupCtrUploadFiles.Hide()"></i>
                                    </div>
                                </div>
                            </HeaderTemplate>
                            <ContentCollection>
                                <dx:PopupControlContentControl runat="server">
                                </dx:PopupControlContentControl>
                            </ContentCollection>
                            <ClientSideEvents CloseUp="function(s,e){}" />
                        </dx:ASPxPopupControl>
                        <uc1:SendMail runat="server" ID="SendMail" />
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
                                    <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                        <i class="fa fa-history head_tab_icon_padding"></i>
                                        <div class="font_size_bold">Activity Log</div>
                                    </a>
                                </li>
                                <li style="margin-right: 30px; color: #7396a9; float: right">
                                    <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                </li>
                            </ul>
                            <dx:ASPxCallbackPanel runat="server" ID="cbpLogs" ClientInstanceName="cbpLogs" OnCallback="cbpLogs_Callback">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <uc1:ActivityLogs runat="server" ID="ActivityLogs" DisplayMode="Construction" />
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>

                            <!-- Follow up function  -->
                            <script type="text/javascript">

                                function OnCallbackMenuClick(s, e) {

                                    if (e.item.name == "Custom") {
                                        ASPxPopupSelectDateControl.PerformCallback("Show");
                                        ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
                                        e.processOnServer = false;
                                        return;
                                    }

                                    SetFollowUp(e.item.name)
                                    e.processOnServer = false;
                                }

                                function SetFollowUp(type, dateSelected) {
                                    if (typeof dateSelected == 'undefined')
                                        dateSelected = new Date();

                                    var fileData = {
                                        "bble": leadsInfoBBLE,
                                        "type": type,
                                        "dtSelected": dateSelected
                                    };
                                }

                            </script>
                            
                            <dx:ASPxPopupMenu ID="ASPxPopupCallBackMenu2" runat="server" ClientInstanceName="ASPxPopupMenuClientControl"
                                AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                <ItemStyle Paddings-PaddingLeft="20px" />
                                <Items>
                                    <dx:MenuItem Text="Tomorrow" Name="Tomorrow"></dx:MenuItem>
                                    <dx:MenuItem Text="Next Week" Name="nextWeek"></dx:MenuItem>
                                    <dx:MenuItem Text="30 Days" Name="thirtyDays">
                                    </dx:MenuItem>
                                    <dx:MenuItem Text="60 Days" Name="sixtyDays">
                                    </dx:MenuItem>
                                    <dx:MenuItem Text="Custom" Name="Custom">
                                    </dx:MenuItem>
                                </Items>
                                <ClientSideEvents ItemClick="OnCallbackMenuClick" />
                            </dx:ASPxPopupMenu>
                            <dx:ASPxPopupControl ClientInstanceName="ASPxPopupSelectDateControl" Width="360px" Height="250px"
                                MaxWidth="800px" MaxHeight="150px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                                HeaderText="Select Date" Modal="false"
                                runat="server" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server" ID="pcMainPopupControl">
                                        <table>
                                            <tr>
                                                <td>
                                                    <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False" Visible="true"></dx:ASPxCalendar>
                                                    <%--     <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="ASPxDateEdit1" ClientInstanceName="ScheduleDateClientFllowUp" 
                                                            TimeSectionProperties-Visible="True" CssClass="edit_drop">
                                                            <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                            <ClientSideEvents Init="function(s,e){ s.SetDate(new Date());}" />
                                                        </dx:ASPxDateEdit>--%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                                        <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();   
                                                                                                                        SetFollowUp('customDays',callbackCalendar.GetSelectedDate());                                                                                                                        
                                                                                                                        }"></ClientSideEvents>
                                                    </dx:ASPxButton>
                                                    &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>

                                                            </dx:ASPxButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>

    <script type="text/javascript">

        function LoadCaseData(bble) {
            $(document).ready(function () {
                //put construction data loading logic here
                var _scope = angular.element('#ConstructionCtrl').scope()
                _scope.init(bble);
            });
        }

        portalApp = angular.module('PortalApp');
        portalApp.controller('ConstructionCtrl', ['$scope', '$http', '$timeout', 'ptCom', 'ptShortsSaleService', 'ptContactServices', 'ptConstructionService', function ($scope, $http, $timeout, ptCom, ptShortsSaleService, ptContactServices, ptConstructionService) {
            $scope.arrayRemove = ptCom.arrayRemove;
            $scope.ptContactServices = ptContactServices;
            $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }
            $scope.CSCase = {}
            $scope.CSCase.CSCase = {
                InitialIntake: {},
                Photos: {},
                Utilities: {},
                Violations: {},
                ProposalBids: {},
                Plans: {},
                Contract: {},
                Signoffs: {}
            };
            $scope.CSCase.CSCase.Utilities.Company = [];
            $scope.DataSource = {};
            $scope.DataSource.Shown = {
                'ConED': 'CSCase.CSCase.Utilities.ConED_Shown',
                'Energy Service': 'CSCase.CSCase.Utilities.EnergyService_Shown',
                'National Grid': 'CSCase.CSCase.Utilities.NationalGrid_Shown',
                'DEP': 'CSCase.CSCase.Utilities.DEP_Shown',
                'MISSING Water Meter': 'CSCase.CSCase.Utilities.MissingMeter_Shown',
                'Taxes': 'CSCase.CSCase.Utilities.Taxes_Shown',
                'ADT': 'CSCase.CSCase.Utilities.ADT_Shown',
                'Insurance': 'CSCase.CSCase.Utilities.Insurance_Shown',
            };
            $scope.reload = function () {
                $scope.CSCase = {}
                $scope.CSCase.CSCase = {
                    InitialIntake: {},
                    Photos: {},
                    Utilities: {},
                    Violations: {},
                    ProposalBids: {},
                    Plans: {},
                    Contract: {},
                    Signoffs: {}
                };
                $scope.CSCase.CSCase.Utilities.Company = [];
            }

            $scope.init = function (bble) {

                bble = bble.trim();
                $timeout(function () {
                    $scope.reload();
                    ptConstructionService.getConstructionCases(bble, function (res) {
                        ptCom.nullToUndefined(res);
                        $.extend(true, $scope.CSCase, res);
                    });

                    ptShortsSaleService.getShortSaleCaseByBBLE(bble, function (res1) {
                        $scope.SsCase = res1;
                    });

                });

            }

            $scope.saveCSCase = function () {
                var data = JSON.stringify($scope.CSCase);
                ptConstructionService.saveConstructionCases($scope.CSCase.BBLE, data);
            }

            /***spliter***/

            $scope.resetCompany = function (obj) {
                for (var key in obj) {
                    var value = obj[key];
                    $scope.$eval(value + '=false');
                }
            };


            $scope.$watch('CSCase.CSCase.Utilities.Company', function (newValue) {
                if (newValue) {
                    var ds = $scope.DataSource.Shown;
                    var target = $scope.CSCase.CSCase.Utilities.Company;
                    $scope.resetCompany(ds);
                    for (var i in target) {
                        $scope.$eval(ds[target[i]] + '=true');
                    }
                }
            }, true);
            $scope.sendNotice = function (id, name) {
                // TODO
                var confirmed = confirm("Send Intake Sheet To " + name + " ?");
            }
            /*
            $scope.$watch('CSCase.CSCase.Utilities.ConED_EnergyServiceRequired', function(newVal) {
                if (newVal) {
                    if ($scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service') < 0) $scope.CSCase.CSCase.Utilities.Company.push('Energy Service');
                    $scope.CSCase.CSCase.Utilities.EnergyService_Collapsed = false;
                } else {
                    var index;
                    if ((index = $scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service')) != -1) $scope.CSCase.CSCase.Utilities.Company.splice(index, 1);
                }
            });
            */
        }]);
    </script>

</asp:Content>
