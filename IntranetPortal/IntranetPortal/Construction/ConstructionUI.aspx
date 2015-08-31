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
                <PaneStyle>
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                        <uc1:ConstructionCaseList runat="server" ID="ConstructionCaseList" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>

            <%-- data panel     --%>
            <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                <PaneStyle>
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
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
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="Intake Complete" ng-click="intakeComplete()" data-original-title="Intake Completed"></i>
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
                <PaneStyle BackColor="#F9F9F9">
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
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
                                <ItemStyle Paddings-PaddingLeft="20px">
                                    <Paddings PaddingLeft="20px"></Paddings>
                                </ItemStyle>

                                <Paddings PaddingTop="15px" PaddingBottom="18px"></Paddings>
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
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                    <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                                        <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();SetFollowUp('customDays',callbackCalendar.GetSelectedDate());}"></ClientSideEvents>
                                                    </dx:ASPxButton>
                                                    &nbsp;
                                                    <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                                        <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();}"></ClientSideEvents>
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
        var Current_User = '<%= HttpContext.Current.User.Identity.Name%>';
        function LoadCaseData(bble) {
            $(document).ready(function () {
                //put construction data loading logic here
                var scope = angular.element('#ConstructionCtrl').scope();
                scope.init(bble);
            });
        }

        portalApp = angular.module('PortalApp');
        portalApp.controller('ConstructionCtrl', ['$scope', '$http', '$timeout', '$interpolate', 'ptCom', 'ptShortsSaleService', 'ptLeadsService', 'ptContactServices', 'ptConstructionService', function ($scope, $http, $timeout, $interpolate, ptCom, ptShortsSaleService, ptLeadsService, ptContactServices, ptConstructionService) {
            $scope.arrayRemove = ptCom.arrayRemove;
            $scope.ptContactServices = ptContactServices;
            $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); }
            $scope.CSCase = {}
            $scope.
                edData = {}
            $scope.CSCase.CSCase = {
                InitialIntake: {},
                Photos: {},
                Utilities: {},
                Violations: {},
                ProposalBids: {},
                Plans: {},
                Contract: {},
                Signoffs: {},
                Comments: []
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
                $scope.ReloadedData = {}
                $scope.CSCase.CSCase = {
                    InitialIntake: {},
                    Photos: {},
                    Utilities: {},
                    Violations: {},
                    ProposalBids: {},
                    Plans: {},
                    Contract: {},
                    Signoffs: {},
                    Comments: []
                };
                $scope.CSCase.CSCase.Utilities.Company = [];
                $scope.ensurePush('CSCase.CSCase.Utilities.Floors', { FloorNum: '?', ConED: {}, EnergyService: {}, NationalGrid: {} })
            }

            $scope.init = function (bble) {

                bble = bble.trim();

                $scope.reload();
                ptConstructionService.getConstructionCases(bble, function (res) {
                    ptCom.nullToUndefined(res);
                    $.extend(true, $scope.CSCase, res);
                    $scope.initWatchedModel()
                });

                ptShortsSaleService.getShortSaleCaseByBBLE(bble, function (res) {
                    $scope.SsCase = res;
                });

                ptLeadsService.getLeadsByBBLE(bble, function (res) {
                    $scope.LeadsInfo = res;
                });



            }

            $scope.saveCSCase = function () {
                var data = JSON.stringify($scope.CSCase);
                ptConstructionService.saveConstructionCases($scope.CSCase.BBLE, data);
                $scope.checkWatchedModel();
            }

            /***spliter***/

            /* multiple company selection */
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
            $scope.$watch('CSCase.CSCase.Utilities.ConED_EnergyServiceRequired', function (newVal) {

                if (newVal) {
                    if ($scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service') < 0) {
                        $scope.CSCase.CSCase.Utilities.Company.push('Energy Service');
                        $scope.CSCase.CSCase.Utilities.EnergyService_Collapsed = false;
                    }
                } else {
                    var index;
                    if ((index = $scope.CSCase.CSCase.Utilities.Company.indexOf('Energy Service')) != -1) $scope.CSCase.CSCase.Utilities.Company.splice(index, 1);
                }


            });
            /* multiple company selection */

            /* reminder */
            $scope.sendNotice = function (id, name) {
                // TODO
                var confirmed = confirm("Send Intake Sheet To " + name + " ?");
            }
            /* end reminder */

            /* comments */
            $scope.showPopover = function (e) {
                aspxConstructionCommentsPopover.ShowAtElement(e.target);
            }
            $scope.addComment = function (comment) {
                var newComments = {}
                newComments.comment = comment;
                newComments.caseId = $scope.CaseId;
                newComments.createBy = Current_User;
                newComments.createDate = new Date();
                $scope.CSCase.CSCase.Comments.push(newComments);
            }
            $scope.addCommentFromPopup = function () {
                var comment = $scope.addCommentTxt;
                $scope.addComment(comment);
                $scope.addCommentTxt = '';
            }
            /* end comments */

            /* active tab */
            $scope.activeTab = 'CSInitialIntake';
            $scope.updateActive = function (id) {
                $scope.activeTab = id;
            }
            /* end active tab */

            /* highlight */
            $scope.highlights = [
                { message: 'Plumbing signed off at {{CSCase.CSCase.Signoffs.Plumbing_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate' },
                { message: 'Electrical signed off at {{CSCase.CSCase.Signoffs.Electrical_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate' },
                { message: 'Construction signed off at {{CSCase.CSCase.Signoffs.Construction_SignedOffDate}}', criteria: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate' },
                { message: 'HPD Violations has all finished', criteria: 'CSCase.CSCase.Violations.HPD_OpenHPDViolation === false' }
            ];
            $scope.isHighlight = function (criteria) {
                return $scope.$eval(criteria);
            }
            $scope.highlightMsg = function (msg) {
                var msgstr = $interpolate(msg)($scope);
                return msgstr;
            }
            $scope.intakeComplete = function () {
                AddActivityLog("Intake Process have finished!");
            }
            $scope.WatchedModel = [
                {
                    model: 'CSCase.CSCase.Signoffs.Plumbing_SignedOffDate',
                    backedModel: 'ReloadedData.Backed_Plumbing_SignedOffDate',
                    info: 'Plumbing Sign Off Date'
                },
                {
                    model: 'CSCase.CSCase.Signoffs.Construction_SignedOffDate',
                    backedModel: 'ReloadedData.Backed_Construction_SignedOffDate',
                    info: 'Construction Sign Off Date'
                },
                {
                    model: 'CSCase.CSCase.Signoffs.Electrical_SignedOffDate',
                    backedModel: 'ReloadedData.Electrical_SignedOffDate',
                    info: 'Electrical Sign Off Date'
                }];

            $scope.initWatchedModel = function () {
                _.each($scope.WatchedModel, function (el, i) {
                    $scope.$eval(el.backedModel + '=' + el.model);
                })
            }
            $scope.checkWatchedModel = function () {
                var res = ''
                _.each($scope.WatchedModel, function (el, i) {
                    if ($scope.$eval(el.backedModel + '!=' + el.model)) {
                        $scope.$eval(el.backedModel + '=' + el.model);
                        res += (el.info + ' changes to ' + $scope.$eval(el.model) + '.<br>')
                    }
                })
                if (res) AddActivityLog(res);
            }

            /* end highlight */


            /* Popup */
            $scope.CSCase.CSCase.Violations.DOBViolations = [{}];
            $scope.CSCase.CSCase.Violations.ECBViolations = [{}];
            $scope.setPopupVisible = function (modelName, bVal) {
                $scope.$eval(modelName + '=' + bVal)
            }

            $scope.addNewDOBViolation = function () {
                $scope.ensurePush('CSCase.CSCase.Violations.DOBViolations');
                $scope.setPopupVisible('DOBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.DOBViolations.length - 1), true);
            }
            $scope.addNewECBViolation = function () {
                $scope.ensurePush('CSCase.CSCase.Violations.ECBViolations');
                $scope.setPopupVisible('ECBViolations_PopupVisible_' + ($scope.CSCase.CSCase.Violations.ECBViolations.length - 1), true);
            }
            /* end Popup*/

            /* header editing */
            $scope.HeaderEditing = false;
            $scope.toggleHeaderEditing = function () {
                $scope.HeaderEditing = !$scope.HeaderEditing;
            }
            /* end header editing */

            /* dob fetch */
            $scope.fetchDOBViolations = function () {
                var dialog = DevExpress.ui.dialog.confirm("Get the information from DOB will take a while\n and REPLACE your current Data, are you sure to continue?", "Warning");
                dialog.done(function (confirmed) {
                    if (confirmed) {
                        ptConstructionService.getDOBViolations($scope.CSCase.BBLE, function (error, res) {
                            if (error) {
                                alert(error);
                                console.log(error)
                            } else {
                                var dialog = DevExpress.ui.dialog.confirm("Your current DOB Violation data will be replaced?", "Warning");
                                dialog.done(function (confirmed) {
                                    if (confirmed) {
                                        var data = JSON.parse(res.d)
                                        $scope.$apply(function () {
                                            if (data.DOB_TotalDOBViolation) $scope.CSCase.CSCase.Violations.DOB_TotalDOBViolation = data.DOB_TotalDOBViolation;
                                            if (data.DOB_TotalOpenViolations) $scope.CSCase.CSCase.Violations.DOB_TotalOpenViolations = data.DOB_TotalOpenViolations;
                                            if (data.violations) $scope.CSCase.CSCase.Violations.DOBViolations = data.violations;
                                        })
                                    }
                                })

                            }
                        })
                    }

                })

            }
            $scope.fetchECBViolations = function () {
                var dialog = DevExpress.ui.dialog.confirm("Get the information from DOB will REPLACE your current data, yes to continue?", "Warning");
                dialog.done(function (confirmed) {
                    if (confirmed) {
                        ptConstructionService.getECBViolations($scope.CSCase.BBLE, function (error, res) {
                            if (error) {
                                alert(error);
                                console.log(error)
                            } else {
                                var dialog = DevExpress.ui.dialog.confirm("Your current ECB Violation data will be replaced?", "Warning");
                                dialog.done(function (confirmed) {
                                    if (confirmed) {
                                        var data = JSON.parse(res.d)
                                        $scope.$apply(function () {
                                            if (data.ECP_TotalViolation) $scope.CSCase.CSCase.Violations.ECP_TotalViolation = data.ECP_TotalViolation;
                                            if (data.ECP_TotalOpenViolations) $scope.CSCase.CSCase.Violations.ECP_TotalOpenViolations = data.ECP_TotalOpenViolations;
                                            if (data.violations) {
                                                $scope.CSCase.CSCase.Violations.ECBViolations = _.filter(data.violations, function (el, i) { return el.DOBViolationStatus.startsWith("OPEN") });
                                            }
                                        })
                                    }
                                })

                            }
                        })
                    }

                })
            }

            /* end dob fetch */
        }]);
    </script>

</asp:Content>
