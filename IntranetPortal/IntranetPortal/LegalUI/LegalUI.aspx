﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActions.ascx" TagPrefix="uc1" TagName="LegalSecondaryActions" %>
<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>

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
                        <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />
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
                        <div ng-controller="PortalCtrl">
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
                               <%-- <p >{{selectBoxData}}</p>--%>
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

                                    <li style="margin-right: 30px; color: #ffa484; float: right">

                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);" data-original-title="Re-Assign"></i>
                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                    </li>
                                </ul>

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
                                        <div class="dxpc-contentWrapper">
                                            <div class="dxpc-content" id="ctl00_MainContentPH_ASPxSplitter1_ASPxCallbackPanel2_contentSplitter_SendMail_PopupSendMail_PWC-1">
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="tab-content">

                                    <div class="tab-pane active" id="LegalTab">
                                        <uc1:LegalTab runat="server" id="LegalTab1" />
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
                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" DispalyMode="ShortSale" />
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
    <script>
        var portalApp = angular.module('PortalApp', ['dx']);
        var AllContact = $.parseJSON('<%= GetAllContact()%>');
        portalApp.controller('PortalCtrl', function ($scope, $http, $element) {
            $scope.SelectContactId = 128;
            $scope.selectBoxData = AllContact;
            $.getJSON('/WCFDataServices/ContactService.svc/GetAllContacts', function (data) {
              
                $scope.selectBoxData = data;
            });
           
        });
    </script>
    <script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>
    <%--  <script>
         $(document).ready(function () {
                 format_input();
             }
         )
    </script>--%>
    <script src="/Scripts/bootstrap.min.js"></script>
</asp:Content>
