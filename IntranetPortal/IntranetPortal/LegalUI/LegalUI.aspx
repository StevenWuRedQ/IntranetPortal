<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActions.ascx" TagPrefix="uc1" TagName="LegalSecondaryActions" %>
<%@ Register Src="~/LegalUI/LegalCaseList.ascx" TagPrefix="uc1" TagName="LegalCaseList" %>

<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>


<asp:Content runat="server" ContentPlaceHolderID="head">

    <link href="/Scripts/jquery.webui-popover.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery.webui-popover.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.js"></script>

    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/globalize/0.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="http://cdn3.devexpress.com/jslib/14.2.7/js/angular-sanitize.js"></script>
    <script src="http://cdn3.devexpress.com/jslib/14.2.7/js/dx.all.js"></script>
    <!-- Angular Material Javascript using RawGit to load directly from `bower-material/master` -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/14.2.7/css/dx.common.css" type="text/css">
   <%-- <link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/14.2.7/css/dx.spa.css" type="text/css">--%>    
    <link rel="stylesheet" href="http://cdn3.devexpress.com/jslib/14.2.7/css/dx.light.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/0.9.0/jquery.mask.min.js"></script>
     <script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <%--leagal Ui--%>
    <style>
        .dxsplControl_MetropolisBlue1 .dxsplLCC {
            padding: 0;
        }
    </style>
    <div>
    </div>
    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
        <Panes>
            <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                <ContentCollection>
                    <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                        <uc1:LegalCaseList runat="server" ID="LegalCaseList" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px">
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <script>
                            $(document).ready(function () {

                                $('.popup').webuiPopover({ title: 'Contact ' + $("#vendor_btn").html(), content: $('#contact_popup').html(), width: 400 });

                            });
                        </script>
                        <div id="PortalCtrl" ng-controller="PortalCtrl">
                            <div id="vendor_btn" style="display: none">
                                <i class="fa fa-users icon_btn" title="Vendors" onclick="VendorsPopupClient.Show()"></i>
                            </div>
                            <div id="contact_popup" style="display: none;">

                                <div>
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item">

                                            <label class="ss_form_input_title">Name</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Office #</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Extension</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Company Name</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Fax</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Cell #</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">email</label>
                                            <input class="ss_form_input ss_disable" disabled="disabled">
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div>                               
                                <%--<select class="ss_contact" ss-select="" ng-model="SelectContactId" style="width: 100%">
                                </select>
                                <select class="ss_contact" ss-select="" ng-model="SelectContactId" style="width: 100%">
                                </select>--%>
                               
                            </div>

                            <div style="align-content: center; height: 100%">
                                <!-- Nav tabs -->
                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white;">
                                    <li class="active short_sale_head_tab">
                                        <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Legal</div>
                                        </a>


                                    </li>
                                    <li class="short_sale_head_tab">
                                        <a href="#DocumentTab" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-file head_tab_icon_padding"></i>
                                            <div class="font_size_bold">Documents</div>
                                        </a>
                                    </li>
                                    <li style="margin-right: 30px; color: #ffa484; float: right">
                                        <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="SaveLegal()" data-original-title="Save"></i>

                                        <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.LegalResearch Then%>
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="CompleteResearch()" data-original-title="Complete Search"></i>
                                        <% End If%>

                                        <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerAssign Then%>
                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);" data-original-title="Assign to Attorney"></i>
                                        <% End If%>

                                        <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.AttorneyHandle Then%>
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="AttorneyComplete()" data-original-title="Complete"></i>
                                        <% End If%>

                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                    </li>

                                </ul>

                                <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerAssign Then%>
                                <dx:ASPxPopupControl ClientInstanceName="popupCtrReassignEmployeeListCtr" Width="300px" Height="300px"
                                    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl3"
                                    HeaderText="Select Employee" AutoUpdatePosition="true" Modal="true" OnWindowCallback="ASPxPopupControl3_WindowCallback"
                                    runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
                                    <ContentCollection>
                                        <dx:PopupControlContentControl runat="server" Visible="false" ID="PopupContentReAssign">
                                            <dx:ASPxListBox runat="server" ID="listboxEmployee" ClientInstanceName="listboxEmployeeClient" Height="270" SelectedIndex="0" Width="100%">
                                            </dx:ASPxListBox>
                                            <dx:ASPxButton Text="Assign" runat="server" ID="btnAssign" AutoPostBack="false">
                                                <ClientSideEvents Click="function(s,e){
                                        var item = listboxEmployeeClient.GetSelectedItem();
                                        if(item == null)
                                        {
                                             alert('Please select attorney.');
                                             return;
                                         }
                                        reassignCallback.PerformCallback(leadsInfoBBLE + '|' + item.text);
                                        popupCtrReassignEmployeeListCtr.Hide();                                       
                                        }" />
                                            </dx:ASPxButton>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>
                                <% End If%>

                                <style>
                                    .AttachmentSpan {
                                        margin-left: 10px;
                                        border: 1px solid #efefef;
                                        padding: 3px 20px 3px 10px;
                                        background-color: #ededed;
                                    }
                                </style>

                                <div id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PW-1" class="dxpcLite_MetropolisBlue1 dxpclW" style="height: 700px; width: 630px; cursor: default; z-index: 10000; display: none;">
                                    <div class="dxpc-mainDiv dxpc-shadow">
                                        <div class="dxpc-header dxpc-withBtn" id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PWH-1">
                                            <div class="clearfix">
                                                <div class="pop_up_header_margin">
                                                    <i class="fa fa-envelope with_circle pop_up_header_icon"></i>
                                                    <span class="pop_up_header_text ">Email</span>
                                                </div>
                                                <div class="pop_up_buttons_div">
                                                    <i class="fa fa-times icon_btn" onclick="popupSendEmailClient.Hide()"></i>
                                                </div>
                                            </div>

                                        </div>
                                       
                                    </div>
                                </div>


                                <div class="tab-content">

                                    <div class="tab-pane active" id="LegalTab">
                                        <uc1:LegalTab runat="server" ID="LegalTab1" />
                                    </div>
                                    <div class="tab-pane active" id="DocumentTab">
                                        <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                </div>
                            </div>
                            </div>
                            <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9">
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
                                <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                <li style="margin-right: 30px; color: #7396a9; float: right">
                                    <div style="display: inline-block">
                                        <a href="/LegalUI/LegalUI.aspx?SecondaryAction=true"><i class="fa fa-arrow-right sale_head_button sale_head_button_left tooltip-examples" style="margin-right: 10px; color: #7396A9" title="Secondary" onclick=""></i></a>
                                    </div>
                                    <i class="fa fa-repeat sale_head_button tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                    <%-- <i class="fa fa-file sale_head_button sale_head_button_left tooltip-examples" title="New File" onclick="LogClick('NewFile')"></i>--%>
                                    <i class="fa fa-folder-open sale_head_button sale_head_button_left tooltip-examples" title="Active" onclick="LogClick('Active')"></i>
                                    <i class="fa fa-sign-out  sale_head_button sale_head_button_left tooltip-examples" title="Eviction" onclick="tmpBBLE=leadsInfoBBLE;popupEvictionUsers.PerformCallback();popupEvictionUsers.ShowAtElement(this);"></i>
                                    <i class="fa fa-pause sale_head_button sale_head_button_left tooltip-examples" title="On Hold" onclick="LogClick('OnHold')"></i>
                                    <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="LogClick('Closed')"></i>
                                    <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                </li>
                            </ul>
                            <dx:ASPxCallbackPanel runat="server" ID="cbpLogs" ClientInstanceName="cbpLogs" OnCallback="cbpLogs_Callback">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <uc1:ActivityLogs runat="server" ID="ActivityLogs" DisplayMode="Legal" />
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxCallbackPanel>                            
                        </div>
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
        </Panes>
    </dx:ASPxSplitter>

   <%-- <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.js"></script>
     <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular-animate.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular-aria.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/globalize/0.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="http://cdn3.devexpress.com/jslib/14.2.7/js/angular-sanitize.js"></script>
    <script src="http://cdn3.devexpress.com/jslib/14.2.7/js/dx.all.js"></script>
   
    <script src="https://rawgit.com/angular/bower-material/master/angular-material.js"></script>--%>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script src="/Scripts/stevenjs.js"></script>
    <style>
        .contact_box {
            margin-top: 5px;
            width: 80%;
        }
    </style>
    <script>
        /*
        function(case) */
        function GetLegalData() {
            return CaseData;
        }
        
       <%-- var AllContact = $.parseJSON('<%= GetAllContact()%>');--%>
        var taskSN = '<%= Request.QueryString("sn")%>';
        <%--var LegalCase = $.parseJSON('<%= LegalCase%>');--%>
        var portalApp = angular.module('PortalApp', ['dx']);
        portalApp.directive('ssDate', function () {
            return {
                restrict: 'A',
                link: function (scope, el, attrs) {
                    $(el).datepicker({});
                    $(el).on('change', function () {
                        scope.$eval(attrs.ngModel + "='" + el.val() + "'");
                        //scope[attrs.ngModel] = el.val(); //if your expression doesn't contain dot.
                    });
                }
            };
        });
        portalApp.directive('inputMask', function () {
            return {
                restrict: 'A',
                link: function (scope, el, attrs) {

                    $(el).mask(attrs.inputMask);
                    $(el).on('change', function () {
                        scope.$eval(attrs.ngModel + "='" + el.val() + "'");
                        //scope[attrs.ngModel] = el.val(); //if your expression doesn't contain dot.
                    });
                }
            };
        });
        portalApp.directive('maskMoney', function () {
            return {
                restrict: 'A',
                link: function (scope, el, attrs) {

                    $(el).formatCurrency();
                    $(el).on("blur", function () { $(this).formatCurrency() });
                   
                    $(el).on('change', function () {
                        scope.$eval(attrs.ngModel + "='" + el.val() + "'");
                        //scope[attrs.ngModel] = el.val(); //if your expression doesn't contain dot.
                    });
                }
            };
        });
        portalApp.controller('PortalCtrl', function ($scope, $http, $element) {
            $scope.LegalCase = { PropertyInfo: {}, ForeclosureInfo: {}, SecondaryInfo: {} };
            var PropertyInfo = $scope.LegalCase.PropertyInfo;
            CaseData = $scope.LegalCase;
            PropertyInfo.PropertyAddress = "421 HART ST, BEDFORD STUYVESANT,NY 11221";
            PropertyInfo.StreetName = 'HART ST';
            PropertyInfo.Number = "421";
            PropertyInfo.City = "BEDFORD STUYVESANT";
            PropertyInfo.State = "NY";
            PropertyInfo.Zipcode = "11221";
            PropertyInfo.Number = "421";
           

            PropertyInfo.Block = 1234;
            

            PropertyInfo.Lot = 123;
            PropertyInfo.BuildingType = "Apartment";
            PropertyInfo.Class = 'A0';
            PropertyInfo.Condition = 'Good';
            PropertyInfo.VacantOrOccupied = "Vacant";
            PropertyInfo.AgentId = 164;
            PropertyInfo.Use = '';
            PropertyInfo.OwnerOfRecordId = 164;
            PropertyInfo.CaseContactId = 164;
            PropertyInfo.Class = 'A0';

            var ForeclosureInfo = $scope.LegalCase.ForeclosureInfo;
            ForeclosureInfo.PlaintiffId = 638;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.DefendantId = 646;
            ForeclosureInfo.AttorneyId = 646;
            ForeclosureInfo.LastCourtDate = '05 / 05 / 2015';
            ForeclosureInfo.NextCourtDate = '05 / 06 / 2015';
            ForeclosureInfo.SaleDate = '05 / 06 / 2015';
            ForeclosureInfo.HAMP = true;
            ForeclosureInfo.LastUpdate = '05 / 08 / 2015';
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;
            ForeclosureInfo.ServicerId = 646;

            var SecondaryInfo = $scope.LegalCase.PropertyInfo;

            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.Status = "Status 1";
            SecondaryInfo.Tasks = "Task 1";
            SecondaryInfo.AttorneyWorkingFile = "Working File 1";
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.BorrowerId = 638;
            SecondaryInfo.CoBorrowerId = 639;
            SecondaryInfo.Language = "Chinese";
            SecondaryInfo.MentalCapacity = "Capacity 1";
            SecondaryInfo.Divorce = false;
            SecondaryInfo.OpposingPartyId = 638;  
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;  
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;  
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;
            SecondaryInfo.OpposingPartyId = 638;

            $scope.SelectContactId = 128;

            //$scope.selectBoxData = AllContact;
            $scope.InitContact = function (id) {

                var store = new DevExpress.data.DataSource({
                    load: function (loadOptions) {
                        var d = $.Deferred();
                        if (loadOptions.searchValue) {
                            $.getJSON('/WCFDataServices/ContactService.svc/GetContacts?args=' + loadOptions.searchValue).done(function (data) {
                                d.resolve(data);

                            });
                        } else {
                            $.getJSON('/WCFDataServices/ContactService.svc/LoadContacts').done(function (data) {
                                d.resolve(data);

                            });
                        }

                        return d.promise();
                    },
                    byKey: function (key) {
                        var d = new $.Deferred();
                        $.get('/WCFDataServices/ContactService.svc/GetAllContacts?id=' + key)
                            .done(function (result) {
                                d.resolve(result);
                            });
                        return d.promise();
                    },
                    searchExpr: ["Name"]
                });
                //new DevExpress.data.ODataStore({
                //    url: "/WCFDataServices/ContactService.svc/GetAllContacts",
                //    key: "ContactId",
                //    keyType: "Int32"
                //});
                return {
                    dataSource: store,
                    valueExpr: 'ContactId',
                    displayExpr: 'Name',
                    searchEnabled: true,
                    bindingOptions: { value: id }
                };
            }
            $scope.CheckPlace = function (p) {
                if (p) {
                    return p == 'NY';
                }
                return false;
            }

            $scope.SaveLegal = function () {
                var json = JSON.stringify($scope.LegalCase);

                var data = { bble: leadsInfoBBLE, caseData: json };
                $http.post('LegalUI.aspx/SaveCaseData', data).
                    success(function () {
                        alert("Save Success!");
                    }).
                    error(function () {
                        alert("Fail to save data.");
                    });

                //$.getJSON('/LegalUI/LegalUI.aspx/SaveCaseData', data, function (data) {                    
                //});
            }

            $scope.CompleteResearch = function () {
                var json = JSON.stringify($scope.LegalCase);

                var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
                $http.post('LegalUI.aspx/CompleteResearch', data).
                    success(function () {
                        alert("Submit Success!");
                    }).
                    error(function () {
                        alert("Fail to save data.");
                    });

                //$.getJSON('/LegalUI/LegalUI.aspx/SaveCaseData', data, function (data) {                    
                //});
                }

            $scope.AttorneyComplete = function () {
                var json = JSON.stringify($scope.LegalCase);

                var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
                $http.post('LegalUI.aspx/AttorneyComplete', data).
                    success(function () {
                        alert("Submit Success!");
                    }).
                    error(function () {
                        alert("Fail to save data.");
                    });

                //$.getJSON('/LegalUI/LegalUI.aspx/SaveCaseData', data, function (data) {                    
                //});
            }

            $scope.LoadLeadsCase = function (BBLE) {
                var data = { bble: BBLE };
                $http.post('LegalUI.aspx/GetCaseData', data).
                     success(function (data, status, headers, config) {
                         $scope.LegalCase = $.parseJSON(data.d);
                     }).
                     error(function () {
                         alert("Fail to load data.")
                     });
            }
            //$.getJSON('/WCFDataServices/ContactService.svc/GetAllContacts', function (data) {
              
            //    $scope.selectBoxData = data;
            //});
           

        });
    </script>
   

    <script src="/Scripts/bootstrap.min.js"></script>
</asp:Content>
