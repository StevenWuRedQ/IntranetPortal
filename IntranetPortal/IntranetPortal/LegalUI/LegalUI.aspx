<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" EnableEventValidation="false" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/LegalUI/LegalCaseList.ascx" TagPrefix="uc1" TagName="LegalCaseList" %>
<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register TagPrefix="uc1" TagName="LegalSecondaryActions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<%@ Register Src="~/LegalUI/ManagePreViewControl.ascx" TagPrefix="uc1" TagName="ManagePreViewControl" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/ShortSale/ShortSaleFileOverview.ascx" TagPrefix="uc1" TagName="ShortSaleFileOverview" %>
<%@ Register Src="~/WorkingLog/WorkingLogControl.ascx" TagPrefix="uc1" TagName="WorkingLogControl" %>


<asp:Content runat="server" ContentPlaceHolderID="head">

    <link href="/Scripts/jquery.webui-popover.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/jquery.webui-popover.js"></script>
    <style type="text/css">
        .chipsdemoContactChips md-content.autocomplete {
            min-height: 250px;
        }

        .chipsdemoContactChips .md-item-text.compact {
            padding-top: 8px;
            padding-bottom: 8px;
        }

        #ctl00_MainContentPH_ASPxSplitter1_1, #ctl00_MainContentPH_ASPxSplitter1_2 {
            visibility: hidden;
        }

        .chipsdemoContactChips .contact-item {
            box-sizing: border-box;
        }

            .chipsdemoContactChips .contact-item.selected {
                opacity: 0.5;
            }

                .chipsdemoContactChips .contact-item.selected h3 {
                    opacity: 0.5;
                }

            .chipsdemoContactChips .contact-item .md-list-item-text {
                padding: 14px 0;
            }

                .chipsdemoContactChips .contact-item .md-list-item-text h3 {
                    margin: 0 !important;
                    padding: 0;
                    line-height: 1.2em !important;
                }

                .chipsdemoContactChips .contact-item .md-list-item-text h3,
                .chipsdemoContactChips .contact-item .md-list-item-text p {
                    text-overflow: ellipsis;
                    white-space: nowrap;
                    overflow: hidden;
                }

        @media (min-width: 900px) {
            .chipsdemoContactChips .contact-item {
                float: left;
                width: 33%;
            }
        }

        .chipsdemoContactChips md-contact-chips {
            margin-bottom: 10px;
        }

        .chipsdemoContactChips .md-chips {
            padding: 5px 0 8px;
        }

        .chipsdemoContactChips .fixedRows {
            height: 250px;
            overflow: hidden;
        }

        .md-contact-suggestion img {
            margin-top: -35px;
        }
    </style>
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
    <input type="hidden" id="CaseData" />
    <input type="hidden" id="Viewable" value="<%= IntranetPortal.LegalCaseManage.IsViewable(Page.User.Identity.Name)  %>" />

    <%--leagal Ui--%>
    <div id="LegalCtrl" ng-controller="LegalCtrl">
        <div ui-layout="{flow: 'column'}" id="listPanelDiv">

            <div ui-layout-container hideafter size="280px" max-size="320px" runat="server" id="listdiv">
                <asp:Panel ID="listpanel" runat="server">
                    <uc1:LegalCaseList runat="server" ID="LegalCaseList" />
                </asp:Panel>
            </div>


            <div ui-layout-container id="dataPanelDiv">
                <asp:Panel ID="datapanel" runat="server">
                    <div id="legalPanelContent">
                        <script>
                            window.onbeforeunload = function () {
                                if (CaseDataChanged())
                                    return "You have pending changes, would you save it?";
                            }

                            setInterval(function () {
                                if (typeof GetDataReadOnly != 'undefined' && !GetDataReadOnly()) {
                                    return;
                                }
                                if (typeof CaseNeedComment != 'undefined' && !$('#NeedAddCommentPopUp').is(':visible')) {
                                    $('#NeedAddCommentPopUp').modal({ backdrop: 'static' })
                                }

                            }, 120000);
                        </script>

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

                        <div style="align-content: center; height: 100%">
                            <!-- Nav tabs -->

                            <% If Not HiddenTab Then%>
                            <div class="legal-menu row" style="margin-left: 0px; margin-right: 0px">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                    <li class="active short_sale_head_tab">
                                        <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                                            <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                            <div class="font_size_bold" id="LegalTabHead">Legal</div>
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
                                            <ul class="nav  clearfix" role="tablist">
                                                <li class="short_sale_head_tab">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_leads" data-url="/ViewLeadsInfo.aspx?HiddenTab=true&id=BBLE" data-href="#more_leads" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-folder head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Leads</div>

                                                    </a>
                                                </li>
                                                <li class="short_sale_head_tab" ng-show="ShortSaleCase!=null">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_short_sale" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&bble=BBLE" data-href="#more_short_sale" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Short Sale</div>
                                                    </a>
                                                </li>
                                                <li class="short_sale_head_tab" ng-show="ShortSaleCase!=null">
                                                    <a role="tab" class="tab_button_a" data-toggle="tab" href="#more_evction" data-url="/ShortSale/ShortSale.aspx?HiddenTab=true&isEviction=true&bble=BBLE" data-href="#more_evction" onclick="LoadMoreFrame(this)">
                                                        <i class="fa fa-sign-out head_tab_icon_padding"></i>
                                                        <div class="font_size_bold">Eviction</div>
                                                    </a>
                                                </li>

                                            </ul>
                                        </div>


                                    </li>
                                    <li class="pull-right" style="margin-right: 30px; color: #ffa484">
                                        <i class="fa fa-clock-o sale_head_button sale_head_button_left tooltip-examples" ng-click="CheckWorkHours()" data-original-title="Work hours"></i>
                                        <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="SaveLegal()" data-original-title="Save"></i>

                                        <% If DisplayView = IntranetPortal.Data.LegalCaseStatus.ManagerPreview Then%>
                                        <i class="fa fa-lightbulb-o sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Research');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to Research"></i>
                                        <% End If%>

                                        <% If DisplayView = IntranetPortal.Data.LegalCaseStatus.LegalResearch Then%>
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="CompleteResearch()" data-original-title="Complete Research"></i>
                                        <% End If%>

                                        <% If DisplayView = IntranetPortal.Data.LegalCaseStatus.ManagerAssign Or (ShowReassginBtn()) Then%>
                                        <i class="fa fa-mail-reply sale_head_button sale_head_button_left tooltip-examples" title="" onclick="PopupComments.Show(this, angular.element(document.getElementById('LegalCtrl')).scope().BackToResearch);" data-original-title="Back to Research"></i>
                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Attorney');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to paralegal / Attorney"></i>
                                        <% End If%>

                                        <%If DisplayView = IntranetPortal.Data.LegalCaseStatus.AttorneyHandle AndAlso User.IsInRole("Legal-Manager") Then%>
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="AttorneyComplete()" data-original-title="Complete"></i>
                                        <% End If%>
                                        <span class="dropdown">
                                            <i class="fa fa-caret-down sale_head_button sale_head_button_left tooltip-examples" title="" data-original-title="More" data-toggle="dropdown"></i>
                                            <ul class="dropdown-menu" style="background-color: transparent; border: none; margin-top: 10px; box-shadow: none">
                                                <li><i class="fa fa-users sale_head_button sale_head_button_left tooltip-examples" style="color: #ff400d" title="" data-original-title="Contacts" onclick="VendorsPopupClient.Show()"></i></li>
                                                <li><i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" style="color: #ff400d" title="" data-original-title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i></li>
                                                <li><i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" style="color: #ff400d" title="" data-original-title="Print" onclick=""></i></li>
                                            </ul>
                                        </span>
                                    </li>
                                </ul>
                            </div>
                            <% End If%>
                            <% If DisplayView = IntranetPortal.Data.LegalCaseStatus.ManagerAssign Or DisplayView = IntranetPortal.Data.LegalCaseStatus.ManagerPreview Or ShowReassginBtn() OrElse IntranetPortal.LegalCaseManage.IsManager(Page.User.Identity.Name) Then%>
                            <dx:ASPxPopupControl ClientInstanceName="popupSelectAttorneyCtr" Width="300px" Height="300px"
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
                                             alert('Please select attorney.');
                                             return;
                                         }
                                        popupSelectAttorneyCtr.PerformCallback('Save|' + leadsInfoBBLE + '|' + item.text);
                                        popupSelectAttorneyCtr.Hide();
                                        }" />
                                        </dx:ASPxButton>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                                <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                        }" />
                            </dx:ASPxPopupControl>
                            <% End If%>

                            <dx:ASPxPopupControl ClientInstanceName="popupBackToResearch" Width="300px" Height="300px"
                                MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="ASPxPopupControl1"
                                HeaderText="Comments" AutoUpdatePosition="true" Modal="true" runat="server" EnableViewState="false" EnableHierarchyRecreation="True">
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                        <dx:ASPxMemo runat="server" ID="txtBackComments" ClientInstanceName="txtBackComments" Height="270" Width="100%"></dx:ASPxMemo>
                                        <dx:ASPxButton Text="Submit" runat="server" ID="ASPxButton2" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s,e){
                                            PopupComments.ButtonClick();
                                        }" />
                                        </dx:ASPxButton>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                                <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                        }" />
                            </dx:ASPxPopupControl>

                            <script type="text/javascript">
                                //angular.element(document.getElementById('LegalCtrl')).scope().BackToResearch(comments);
                                var PopupComments = {
                                    Action: null,
                                    Show: function (element, action) {
                                        this.Action = action;
                                        popupBackToResearch.ShowAtElement(element);
                                    },
                                    ButtonClick: function () {
                                        var comments = txtBackComments.GetText();
                                        if (comments == null || comments == '') {
                                            alert('Please input comments.');
                                            return;
                                        }

                                        if (typeof this.Action == 'function')
                                            this.Action(comments);

                                        popupBackToResearch.Hide();
                                        txtBackComments.SetText('');
                                    }
                                }

                            </script>


                            <style>
                                .AttachmentSpan {
                                    margin-left: 10px;
                                    border: 1px solid #efefef;
                                    padding: 3px 20px 3px 10px;
                                    background-color: #ededed;
                                }
                            </style>

                            <div class="dxpcLite_MetropolisBlue1 dxpclW" style="height: 700px; width: 630px; cursor: default; z-index: 10000; display: none;">
                                <div class="dxpc-mainDiv dxpc-shadow">
                                    <div class="dxpc-header dxpc-withBtn">
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
                                    <script>
                                        LegalShowAll = true;
                                    </script>
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
                        <div class="modal fade" id="WorkPopUp">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title">Working Total : {{TotleHours.Total}} hours</h4>
                                    </div>
                                    <div class="modal-body">
                                        <div style="overflow: auto; max-height: 300px">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <td>User</td>
                                                        <td>StartTime</td>

                                                        <td>EndTime</td>
                                                        <td>Duration</td>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr ng-repeat="l in TotleHours.LogData">
                                                        <td class="">{{l.UserName }}
                                                        </td>
                                                        <td>{{l.StartTime |date:'MM/dd/yyyy HH:mm:ss'}}
                                                        </td>
                                                        <td>{{l.EndTime |date:'MM/dd/yyyy HH:mm:ss'}}
                                                        </td>
                                                        <td>{{l.Duration |date:'HH:mm:ss'}}
                                                        </td>

                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                    </div>

                                </div>
                                <!-- /.modal-content -->
                            </div>
                            <!-- /.modal-dialog -->
                        </div>
                        <!-- /.modal -->
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
                        <div runat="server" id="SencnedAction" visible="False" style="padding: 0 10px">
                            <div>
                                <script type="text/javascript">
                                    var PropertyInfo = $.parseJSON('<%= propertyData%>');

                                    function LeagalInfoSelectChange(s, e) {
                                        var selected = cbLegalTypeClient.GetSelectedValues();
                                        $('.legal_action_div').css("display", 'none');
                                        $(selected).each(function (i, se) {

                                            $("#" + se).css("display", '');
                                        });
                                    }
                                </script>
                                <div>

                                    <h4 class="ss_form_title">Description</h4>
                                    <textarea class="edit_text_area" ng-model="LegalCase.Description" style="height: 100px; width: 100%"></textarea>
                                </div>


                                <dx:ASPxCheckBoxList runat="server" ID="cbLegalType" ClientInstanceName="cbLegalTypeClient">
                                    <Items>
                                        <dx:ListEditItem Text="Urgent Foreclosure review needed" Value="Urgent_Foreclosure_review_needed" />
                                        <dx:ListEditItem Text="Partition" Value="Partition" />
                                        <dx:ListEditItem Text="Deed Reversal" Value="Deed_Reversal" />
                                        <dx:ListEditItem Text="Breach of Contract" Value="Breach_of_Contract" />
                                        <dx:ListEditItem Text="Quiet Title" Value="Quiet_Title" />
                                        <dx:ListEditItem Text="Estate" Value="Estate" />

                                    </Items>
                                    <ClientSideEvents SelectedIndexChanged="LeagalInfoSelectChange" />
                                </dx:ASPxCheckBoxList>

                                <uc1:LegalSecondaryActions runat="server" ID="LegalSecondaryActions" />

                                <script>
                                    $('.legal_action_div').css("display", 'none');
                                </script>
                            </div>
                        </div>
                        <div runat="server" id="MangePreview" visible="False">
                            <uc1:ManagePreViewControl runat="server" ID="ManagePreViewControl" />
                        </div>
                        <uc1:Common runat="server" ID="Common" />
                    </div>
                </asp:Panel>
            </div>

            <div ui-layout-container>
                <asp:Panel ID="logpanel" runat="server">
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
                                    <div class="font_size_bold">Game Plan</div>
                                </a>
                            </li>
                            <li style="margin-right: 30px; color: #7396a9; float: right">
                                <% If IntranetPortal.LegalCaseManage.IsManager(Page.User.Identity.Name) Then%>
                                <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Attorney');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to paralegal / Attorney"></i>
                                <i class="fa fa-lightbulb-o sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Research');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to Research"></i>

                                <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="PopupComments.Show(this, angular.element(document.getElementById('LegalCtrl')).scope().CloseCase)"></i>
                                <% End If%>
                                <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                            </li>
                        </ul>
                        <dx:ASPxCallbackPanel runat="server" ID="cbpLogs" ClientInstanceName="cbpLogs" OnCallback="cbpLogs_Callback">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="activity_log">
                                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" DisplayMode="Legal" />
                                        </div>
                                        <div class="tab-pane" id="file_overview">
                                            <uc1:ShortSaleFileOverview runat="server" ID="fileGamePlan" Category="Legal" />
                                        </div>
                                    </div>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </div>
                </asp:Panel>
            </div>
        </div>
        <uc1:SendMail runat="server" ID="SendMail" />

        <div class="modal fade" id="NeedAddCommentPopUp">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">You didn't add a comment please input open files reason to continue!</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="message-text" class="control-label">Comment:</label>
                            <textarea class="form-control" ng-model="MustAddedComment"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal" ng-disabled="!MustAddedComment" ng-click="AddActivityLog()">Add Comment</button>
                    </div>
                </div>
            </div>           
        </div>


        <!-- Follow up function  -->
        <script type="text/javascript">

            function OnCallbackMenuClick(s, e) {

                if (e.item.name == "Custom") {
                    ASPxPopupSelectDateControl.PerformCallback("Show");
                    ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
                    e.processOnServer = false;
                    return;
                }

                //SetLeadStatus(e.item.name + "|" + leadsInfoBBLE);
                SetLegalFollowUp(e.item.name)
                e.processOnServer = false;
            }

            function CloseCase(comments) {
                angular.element(document.getElementById('LegalCtrl')).scope().CloseCase(comments);
            }

            function SetLegalFollowUp(type, dateSelected) {
                if (typeof dateSelected == 'undefined')
                    dateSelected = new Date();

                var fileData = {
                    "bble": leadsInfoBBLE,
                    "type": type,
                    "dtSelected": dateSelected
                };

                $.ajax({
                    url: '/LegalUI/LegalServices.svc/SetLegalFollowUp',
                    type: 'POST',
                    data: JSON.stringify(fileData),
                    cache: false,
                    dataType: 'json',
                    processData: false, // Don't process the files
                    contentType: 'application/json',
                    success: function (data) {
                        alert('successful..');

                        if (typeof gridTrackingClient != "undefined")
                            gridTrackingClient.Refresh();
                    },
                    error: function (data) {
                        alert('Some error Occurred! Detail: ' + JSON.stringify(data));
                    }
                });
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
                            </td>
                        </tr>
                        <tr>
                            <td style="color: #666666; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                    <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();SetLegalFollowUp('customDays',callbackCalendar.GetSelectedDate());}"></ClientSideEvents>
                                </dx:ASPxButton>
                                &nbsp;<dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                    <ClientSideEvents Click="function(){ASPxPopupSelectDateControl.Hide();}"></ClientSideEvents>
                                </dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>
        <!-- end follow up function -->

        <script type="text/javascript">
            LegalCaseBBLE = null;
            function GetDataReadOnly() {
                return $('#Viewable').val() == 'True'
            }
            function VendorsClosing(s) {
                GetContactCallBack();
            }
            function GetContactCallBack(contact) {
                $.getJSON('/Services/ContactService.svc/LoadContacts').done(function (data) {
                    AllContact = data;
                });

            }

            function GetLegalData() {

                return angular.element(document.getElementById('LegalCtrl')).scope().LegalCase;

            }
            function setLegalData(BBLE) {
                $(document).ready(function () {
                    // Handler for .ready() called.
                    angular.element(document.getElementById('LegalCtrl')).scope().LoadLeadsCase(BBLE);

                });

            }
            /*chris use this show alert when leave page*/
            function CaseDataChanged() {
                return ScopeCaseDataChanged(GetLegalData);
            }
            function GetCassNeedComment() {
                return CaseNeedComment;
            }
            function ResetCaseDataChange() {
                ScopeResetCaseDataChange(GetLegalData)
            }

            var AllContact = <%= GetAllContact()%>
            {}
            var AllRoboSignor = <%= GetAllRoboSingor() %>
            {}
            var taskSN = '<%= Request.QueryString("sn")%>';

            var portalApp = angular.module('PortalApp');

            portalApp.controller('LegalCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
                $scope.LegalCase = { PropertyInfo: {}, ForeclosureInfo: {}, SecondaryInfo: {}, PreQuestions: {} };
                $scope.ptContactServices = ptContactServices;

                $scope.ptCom = ptCom;

                var self = $scope;
                function querySearch(query) {
                    var results = query ?
                        self.allContacts.filter(createFilterFor(query)) : [];
                    return results;
                }

                /**
                 * Create filter function for a query string
                 */
                function createFilterFor(query) {
                    var lowercaseQuery = angular.lowercase(query);

                    return function filterFn(contact) {
                        return contact.Name && (contact.Name.toLowerCase().indexOf(lowercaseQuery) !== -1);
                    };

                }

                function loadContacts() {
                    var contacts = AllContact;
                    return contacts.map(function (c, index) {
                        c.image = 'https://storage.googleapis.com/material-icons/external-assets/v1/icons/svg/ic_account_circle_black_48px.svg';
                        if (c.Name) {
                            c._lowername = c.Name.toLowerCase();
                        }
                        return c;
                    });
                }
                self.querySearch = querySearch;
                self.allContacts = loadContacts();
                self.contacts = [self.allContacts[0]];
                self.filterSelected = true;

                /**
                 * Search for contacts.
                 */
                $scope.SecondaryTypeSource = ["Statute Of Limitations", "Estate", "Miscellaneous", "Deed Reversal", "Partition", "Breach of Contract", "Quiet Title", ""];

                if (typeof LegalShowAll == 'undefined' || LegalShowAll == null) {
                    $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.SecondaryTypeSource;
                }
                $scope.TestRepeatData = [];
                $scope.addTest = function () {
                    $scope.TestRepeatData[$scope.TestRepeatData.length] = $scope.TestRepeatData.length;
                }


                var ForeclosureInfo = $scope.LegalCase.ForeclosureInfo;
                ForeclosureInfo.PlaintiffId = 638;


                $scope.ContactDataSource = new DevExpress.data.DataSource({
                    store: new DevExpress.data.CustomStore({
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
                    })
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
                $scope.AllJudges = <%= GetAllJudge()%>
                $scope.PickedContactId = null;

                $scope.TestContactId = function (c) {
                    $scope.$eval(c + '=' + '192');
                }
                $scope.GetContactById = function (id) {
                    return AllContact.filter(function (o) { return o.ContactId == id })[0];
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
                $scope.CheckPlace = function (p) {
                    if (p) {
                        return p === 'NY';
                    }
                    return false;
                }

                $scope.SaveLegal = function (scuessfunc) {
                    //$scope.loadPanelVisible = true;
                    if (!LegalCaseBBLE || LegalCaseBBLE !== leadsInfoBBLE) {
                        alert("Case not load completed please wait!");
                        return;
                    }
                    var json = JSON.stringify($scope.LegalCase);

                    var data = { bble: LegalCaseBBLE, caseData: json };
                    $http.post('LegalUI.aspx/SaveCaseData', data).
                        success(function () {
                            if (scuessfunc) {
                                scuessfunc()
                            } else {
                                alert("Save Successed !");
                            }
                            ResetCaseDataChange();
                            //$scope.loadPanelVisible = false;
                        }).
                        error(function (data, status) {
                            alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                        });
                }

                ScopeAutoSave(GetLegalData, $scope.SaveLegal, '#LegalTabHead');

                $scope.CompleteResearch = function () {
                    var json = JSON.stringify($scope.LegalCase);

                    var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
                    $http.post('LegalUI.aspx/CompleteResearch', data).
                        success(function () {
                            alert("Submit Success!");
                            if (typeof gridTrackingClient != 'undefined')
                                gridTrackingClient.Refresh();

                        }).error(function (data) {
                            alert("Fail to save data :" + JSON.stringify(data));
                            console.log(data);
                        });
                }

                $scope.BackToResearch = function (comments) {
                    var json = JSON.stringify($scope.LegalCase);

                    var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN, comments: comments };
                    $http.post('LegalUI.aspx/BackToResearch', data).
                        success(function () {
                            alert("Submit Success!");
                            if (typeof gridTrackingClient != 'undefined')
                                gridTrackingClient.Refresh();

                        }).error(function (data1) {
                            alert("Fail to save data :" + JSON.stringify(data1));
                            console.log(data1);
                        });
                }

                $scope.CloseCase = function (comments) {
                    var data = { bble: leadsInfoBBLE, comments: comments };
                    $http.post('LegalUI.aspx/CloseCase', data).
                        success(function () {
                            alert("Submit Success!");
                            if (typeof gridTrackingClient != 'undefined')
                                gridTrackingClient.Refresh();

                        }).error(function (data) {
                            alert("Fail to save data :" + JSON.stringify(data));
                            console.log(data);
                        });
                }

                $scope.AttorneyComplete = function () {
                    var json = JSON.stringify($scope.LegalCase);

                    var data = { bble: leadsInfoBBLE, caseData: json, sn: taskSN };
                    $http.post('LegalUI.aspx/AttorneyComplete', data).
                        success(function () {
                            alert("Submit Success!");
                            if (typeof gridTrackingClient != 'undefined')
                                gridTrackingClient.Refresh();

                        }).
                        error(function () {
                            alert("Fail to save data.");
                        });

                }

                $scope.LegalCase.SecondaryInfo.StatuteOfLimitations = [];
                $scope.LegalCase.SecondaryTypes = []

                $scope.LoadLeadsCase = function (BBLE) {
                    ptCom.startLoading();
                    $("#ctl00_MainContentPH_ASPxSplitter1_1,#ctl00_MainContentPH_ASPxSplitter1_2").css('visibility', 'visible');
                    var data = { bble: BBLE };

                    $http.post('LegalUI.aspx/GetCaseData', data).
                        success(function (data, status, headers, config) {

                            $scope.LegalCase = $.parseJSON(data.d);
                            $scope.LegalCase.BBLE = BBLE
                            $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                            $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};

                            var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                            for (a in arrays) {
                                var porp = arrays[a]
                                var array = $scope.LegalCase.ForeclosureInfo[porp];
                                if (!array || array.length == 0) {
                                    $scope.LegalCase.ForeclosureInfo[porp] = [];
                                    $scope.LegalCase.ForeclosureInfo[porp].push({});
                                }
                            }
                            $scope.LegalCase.SecondaryTypes = $scope.LegalCase.SecondaryTypes || []
                            $scope.showSAndCFrom();

                            LegalCaseBBLE = BBLE;
                            ptCom.stopLoading();

                            ResetCaseDataChange();
                            CaseNeedComment = true;
                        }).
                        error(function () {
                            ptCom.stopLoading();
                            alert("Fail to load data : " + BBLE);
                        });

                    /******************* get short sale case ***********************/

                    $http.get('/ShortSale/ShortSaleServices.svc/GetCaseByBBLE?bble=' + BBLE)
                        .success(function (data) {
                            $scope.ShortSaleCase = data;
                        }).error(function () {
                            alert("Fail to Short sale case  data : " + BBLE);
                        });
                    /*************** get leads info**************/

                    var leadsInfoUrl = "/ShortSale/ShortSaleServices.svc/GetLeadsInfo?bble=" + BBLE;
                    $http.get(leadsInfoUrl)
                        .success(function (data) {
                            $scope.LeadsInfo = data;
                            $scope.LPShow = $scope.ModelArray('LeadsInfo.LisPens');
                        }).error(function (data) {
                            alert("Get Short Sale Leads failed BBLE =" + BBLE + " error : " + JSON.stringify(data));
                        });

                    $http.get('/api/TaxLiens/' + BBLE)
                        .success(function (data) {
                            $scope.TaxLiens = data;
                            $scope.TaxLiensShow = $scope.ModelArray('TaxLiens');
                        }).error(function (data) {
                            alert("Get Tax Liens failed BBLE = " + BBLE + " error : " + JSON.stringify(data));
                        });

                    /************ get LegalECourt info*************/
                    $http.get("/api/LegalECourtByBBLE/" + BBLE)
                        .success(function (data) {
                            $scope.LegalECourt = data;
                        }).error(function () {
                            $scope.LegalECourt = null;
                        });;
                }

                $scope.ModelArray = function (model) {
                    var array = $scope.$eval(model);
                    return (array && array.length > 0) ? 'Yes' : '';
                }
                /*return true it hight light check date  */
                $scope.HighLightFunc = function (funcStr) {
                    var args = funcStr.split(",");

                }
                $scope.AddSecondaryArray = function () {

                    var selectType = $scope.LegalCase.SecondaryInfo.SelectedType;
                    if (selectType) {
                        var name = selectType.replace(/\s/g, '');

                        var arr = $scope.LegalCase.SecondaryInfo[name];
                        if (name == 'StatuteOfLimitations') {
                            alert('match');
                        }
                        if (!arr || !Array.isArray($scope.LegalCase.SecondaryInfo[name])) {
                            $scope.LegalCase.SecondaryInfo[name] = [];
                            //arr = $scope.LegalCase.SecondaryInfo[name];
                        }
                        $scope.LegalCase.SecondaryInfo[name].push({});
                        //$scope.LegalCase.SecondaryInfo.StatuteOfLimitations.push({});
                    }
                }
                $scope.LegalCase.SecondaryInfo.SelectedType = $scope.SecondaryTypeSource[0];
                $scope.SecondarySelectType = function () {
                    $scope.LegalCase.SecondaryInfo.SelectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes || [];
                    var selectTypes = $scope.LegalCase.SecondaryInfo.SelectTypes;
                    if (!_.contains(selectTypes, $scope.LegalCase.SecondaryInfo.SelectedType)) {
                        selectTypes.push($scope.LegalCase.SecondaryInfo.SelectedType);
                    }

                }
                $scope.CheckShow = function (filed) {
                    if (typeof LegalShowAll == 'undefined' || LegalShowAll == null) {
                        return true;
                    }
                    if ($scope.LegalCase.SecondaryInfo) {
                        return $scope.LegalCase.SecondaryInfo.SelectedType == filed;
                    }

                    return false;
                }
                $scope.SaveLegalJson = function () {
                    $scope.LegalCaseJson = JSON.stringify($scope.LegalCase)
                }
                $scope.ShowContorl = function (m) {
                    var t = typeof m;

                    if (t == "string") {
                        return m == 'true'
                    }
                    return m;

                }
                $scope.DocGenerator = function (tplName) {
                    if (!$scope.LegalCase.SecondaryInfo) {
                        $scope.LegalCase.SecondaryInfo = {}
                    }
                    var Tpls = [{
                        "tplName": 'OSCTemplate.docx',
                        data: {
                            "Plantiff": $scope.LegalCase.ForeclosureInfo.Plantiff,
                            "PlantiffAttorney": $scope.LegalCase.ForeclosureInfo.PlantiffAttorney,
                            "PlantiffAttorneyAddress": $scope.LegalCase.ForeclosureInfo.PlantiffAttorneyAddress,//ptContactServices.getContact($scope.LegalCase.ForeclosureInfo.PlantiffAttorneyId, $scope.LegalCase.ForeclosureInfo.PlantiffAttorney).Address,
                            "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                            "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                            "BoroughName": $scope.LeadsInfo.BoroughName,
                            "Block": $scope.LeadsInfo.Block,
                            "Lot": $scope.LeadsInfo.Lot,
                            "Defendant": $scope.LegalCase.SecondaryInfo.Defendant,

                            "Defendants": $scope.LegalCase.SecondaryInfo.OSC_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.OSC_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                            "DefendantAttorneyName": $scope.LegalCase.SecondaryInfo.DefendantAttorneyName,
                            "DefendantAttorneyPhone": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).OfficeNO,
                            "DefendantAttorneyAddress": ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DefendantAttorneyId, $scope.LegalCase.SecondaryInfo.DefendantAttorneyName).Address,
                            "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                            "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

                        }
                    },
                    {
                        "tplName": 'DeedReversionTemplate.docx',
                        data: {
                            "Plantiff": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiff,
                            "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney,
                            "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).Address,
                            "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney).OfficeNO,
                            "IndexNum": $scope.LegalCase.SecondaryInfo.DeedReversionIndexNum || ' ',
                            "BoroughName": $scope.LeadsInfo.BoroughName,
                            "Block": $scope.LeadsInfo.Block,
                            "Lot": $scope.LeadsInfo.Lot,
                            "Defendant": $scope.LegalCase.SecondaryInfo.DeedReversionDefendant,
                            "Defendants": $scope.LegalCase.SecondaryInfo.DeedReversionDefendants ? ',' + $scope.LegalCase.SecondaryInfo.DeedReversionDefendants.map(function (o) { return o.Name }).join(",") : ' ',
                            "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                            "PropertyAddress": $scope.LeadsInfo.PropertyAddress,

                        },


                    },
                    {
                        "tplName": 'SpecificPerformanceComplaintTemplate.docx',
                        data: {
                            "Plantiff": $scope.LegalCase.SecondaryInfo.SPComplaint_Plantiff,
                            "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney,
                            "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).Address,
                            "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney).OfficeNO,
                            "IndexNum": $scope.LegalCase.SecondaryInfo.SPComplaint_IndexNum || ' ',
                            "BoroughName": $scope.LeadsInfo.BoroughName,
                            "Block": $scope.LeadsInfo.Block,
                            "Lot": $scope.LeadsInfo.Lot,
                            "Defendant": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendant,
                            "Defendants": $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.SPComplaint_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                            "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                            "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                        },

                    },
                    {
                        "tplName": 'QuietTitleComplantTemplate.docx',
                        data: {
                            "Plantiff": $scope.LegalCase.SecondaryInfo.QTA_Plantiff,
                            "PlantiffAttorney": $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney,
                            "PlantiffAttorneyAddress": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).Address,
                            "PlantiffAttorneyPhone": $scope.ptContactServices.getContact($scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId, $scope.LegalCase.SecondaryInfo.QTA_PlantiffAttorney).OfficeNO,
                            "OriginalMortgageLender": $scope.LegalCase.SecondaryInfo.QTA_OrgMorgLender,
                            "Mortgagee": $scope.LegalCase.SecondaryInfo.QTA_Mortgagee,
                            "IndexNum": $scope.LegalCase.SecondaryInfo.QTA_IndexNum || ' ',
                            "BoroughName": $scope.LeadsInfo.BoroughName,
                            "Block": $scope.LeadsInfo.Block,
                            "Lot": $scope.LeadsInfo.Lot,
                            "Defendant": $scope.LegalCase.SecondaryInfo.QTA_Defendant,
                            "Defendant2": $scope.LegalCase.SecondaryInfo.QTA_Defendant2,
                            "Defendants": $scope.LegalCase.SecondaryInfo.QTA_Defendants ? ',' + $scope.LegalCase.SecondaryInfo.QTA_Defendants.map(function (o) { return o.Name }).join(",") : ' ',
                            "CourtAddress": $scope.GetCourtAddress($scope.LeadsInfo.Borough),
                            "PropertyAddress": $scope.LeadsInfo.PropertyAddress,
                            "FCFiledDate": $scope.LegalCase.ForeclosureInfo.FCFiledDate,
                            "FCIndexNum": $scope.LegalCase.ForeclosureInfo.FCIndexNum,
                            "DefaultDate": $scope.LegalCase.ForeclosureInfo.QTA_DefaultDate,
                            "DeedToPlaintiffDate": $scope.LegalCase.SecondaryInfo.QTA_DeedToPlaintiffDate,
                        },

                    }

                    ];
                    var tpl = Tpls.filter(function (o) { return o.tplName == tplName })[0]

                    if (tpl) {
                        for (var v in tpl.data) {
                            var filed = tpl.data[v];
                            if (!filed) {

                                alert("Some data missing please check " + v + "Please check!")
                                return;

                            }
                        }
                        ptCom.DocGenerator(tpl.tplName, tpl.data, function (url) {
                            //window.open(url,'blank');
                            STDownloadFile(url, tpl.tplName.replace("Template", ""));
                        });
                    } else {
                        alert("can find tlp " + tplName)
                    }
                }
                $scope.CheckSecondaryTags = function (tag) {
                    return $scope.LegalCase.SecondaryTypes.filter(function (t) { return t == tag })[0];
                }
                $scope.GetCourtAddress = function (boro) {
                    var address = ['', '851 Grand Concourse Bronx, NY 10451', '360 Adams St. Brooklyn, NY 11201', '8811 Sutphin Boulevard, Jamaica, NY 11435'];
                    return address[boro - 1];
                }
                var hSummery = [{ "Name": "CaseStauts", "CallFunc": "HighLightStauts(LegalCase.CaseStauts,4)", "Value": "", "Description": "Last milestone document recorded on Clerk Minutes after O/REF. ", "ArrayName": "" },
                                { "Name": "EveryOneIn", "CallFunc": "HighlightCompare('LegalCase.ForeclosureInfo.WasEstateFormed!=null')", "Value": "false", "Description": "There is an estate.", "ArrayName": "" },
                                { "Name": "BankruptcyFiled", "CallFunc": "HighlightCompare('LegalCase.ForeclosureInfo.BankruptcyFiled')", "Value": "false", "Description": "Bankruptcy filed", "ArrayName": "" },

                                { "Name": "Efile", "CallFunc": "HighlightCompare('LegalCase.ForeclosureInfo.Efile==true')", "Value": "false", "Description": "Has E-filed", "ArrayName": "" },
                                { "Name": "EfileN", "CallFunc": "HighlightCompare('LegalCase.ForeclosureInfo.Efile==false')", "Value": "false", "Description": "No E-filed", "ArrayName": "" },
                                { "Name": "ClientPersonallyServed", "CallFunc": "", "Value": "false", "Description": "Client personally is not served. ", "ArrayName": "AffidavitOfServices" },
                                { "Name": "NailAndMail", "CallFunc": "", "Value": "true", "Description": "Nail and Mail.", "ArrayName": "AffidavitOfServices" },
                                { "Name": "BorrowerLiveInAddrAtTimeServ", "CallFunc": "", "Value": "false", "Description": "Borrower didn\'t live in service Address at time of Serv.", "ArrayName": "AffidavitOfServices" },
                                { "Name": "BorrowerEverLiveHere", "CallFunc": "", "Value": "false", "Description": "Borrower didn\'t ever live in service address.", "ArrayName": "AffidavitOfServices" },
                                { "Name": "ServerInSererList", "CallFunc": "", "Value": "true", "Description": "process server is in server list.", "ArrayName": "AffidavitOfServices" },
                                { "Name": "isServerHasNegativeInfo", "CallFunc": "", "Value": "true", "Description": "Web search provide any negative information on process server. ", "ArrayName": "AffidavitOfServices" },
                                { "Name": "AffidavitServiceFiledIn20Day", "CallFunc": "", "Value": "false", "Description": "Affidavit of service wasn\'t file within 20 days of service.", "ArrayName": "AffidavitOfServices" },
                                { "Name": "AnswerClientFiledBefore", "CallFunc": "", "Value": "false", "Description": "Client hasn\'t ever filed an answer before.", "ArrayName": "" },
                                { "Name": "NoteIsPossess", "CallFunc": "", "Value": "false", "Description": "We Don't possess a copy of the note.", "ArrayName": "" },
                                { "Name": "NoteEndoresed", "CallFunc": "", "Value": "false", "Description": "Note wasn\'t endores.", "ArrayName": "" },
                                { "Name": "NoteEndorserIsSignors", "CallFunc": "", "Value": "true", "Description": "The endorser is in signors list.", "ArrayName": "" },
                                { "Name": "HasDocDraftedByDOCXLLC", "CallFunc": "", "Value": "true", "Description": "There are documents drafted by DOCX LLC .", "ArrayName": "Assignments" },
                                { "Name": "LisPendesRegDate", "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.LisPendesDate, LegalCase.ForeclosureInfo.LisPendesRegDate, 5)", "Value": "", "Description": "Date of registration 5 days after Lis Pendens letter", "ArrayName": "" },
                                { "Name": "AccelerationLetterMailedDate", "CallFunc": "isPassOrEqualByMonths(LegalCase.ForeclosureInfo.DefaultDate,LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,12 )", "Value": " ", "Description": "Acceleration letter mailed to borrower after 12 months of Default Date. ", "ArrayName": "" },
                                { "Name": "AccelerationLetterRegDate", "CallFunc": "isPassOrEqualByDays(LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,LegalCase.ForeclosureInfo.AccelerationLetterRegDate,3 )", "Value": " ", "Description": "Date of registration for Acceleration letter filed  3 days after acceleration letter mailed date", "ArrayName": "" },

                                { "Name": "AffirmationFiledDate", "CallFunc": "isPassByDays(LegalCase.ForeclosureInfo.JudgementDate,LegalCase.ForeclosureInfo.AffirmationFiledDate,0)", "Value": "", "Description": "Affirmation filed after Judgement. ", "ArrayName": "" },
                                { "Name": "AffirmationReviewerByCompany", "CallFunc": "", "Value": "false", "Description": "The affirmation reviewer wasn\'t employe by the servicing company. ", "ArrayName": "" },
                                { "Name": "MortNoteAssInCert", "CallFunc": "", "Value": "false", "Description": "In the Certificate of Merit, the Mortgage, Note and Assignment aren\'t included. ", "ArrayName": "" },
                                { "Name": "MissInCert", "CallFunc": "checkMissInCertValue()", "Value": "", "Description": "Mortgage Note or Assignment are missing. ", "ArrayName": "" },
                                { "Name": "CertificateReviewerByCompany", "CallFunc": "", "Value": "false", "Description": "The certificate  reviewer wasn\'t employe by the servicing company. ", "ArrayName": "" },
                                { "Name": "ItemsRedacted", "CallFunc": "", "Value": "false", "Description": "Are items of personal information Redacted.", "ArrayName": "" },
                                { "Name": "RJIDate", "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.SAndCFiledDate, LegalCase.ForeclosureInfo.RJIDate, 12)", "Value": "", "Description": "RJI filed after 12 months of S&C.", "ArrayName": "" },
                                { "Name": "ConferenceDate", "CallFunc": "isLessOrEqualByDays(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.ConferenceDate, 60)", "Value": "", "Description": "Conference date scheduled 60 days before RJI", "ArrayName": "" },
                                { "Name": "OREFDate", "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)", "Value": "", "Description": "O/REF filed after 12 months after RJI.", "ArrayName": "" },
                                { "Name": "JudgementDate", "CallFunc": "isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)", "Value": "", "Description": "Judgement submitted 12 months after O/REF. ", "ArrayName": "" }];
                $scope.HightSummery = function () {
                    var highLight = hSummery
                    //hSummery.splice();

                    for (i = 0; i < highLight.length; i++) {
                        var h = highLight[i];
                        $scope.ExceptVisable(h, $scope.LegalCase.ForeclosureInfo);
                        if (h.ArrayName && h.ArrayName.length > 0) {
                            var arrayItem = $scope.LegalCase.ForeclosureInfo[h.ArrayName];
                            if (arrayItem) {
                                var shouldVisible = false;
                                for (var j = 0; j < arrayItem.length; j++) {

                                    if ($scope.ExceptVisable(h, arrayItem[j], j)) {
                                        shouldVisible = true;
                                    }
                                }

                                h.Visable = shouldVisible;

                            }

                        }
                    }

                    return hSummery;
                };
                $scope.ExceptVisable = function (h, CompareValue, arrayIndex) {
                    var visbale = false;
                    if (h.Value == 'true' || h.Value == 'false') {
                        h.Value = h.Value == 'true';
                    }

                    if (h.CallFunc) {
                        var func = h.CallFunc;
                        if (func.indexOf("__index__") > 0) {
                            func = func.replace("__index__", arrayIndex);
                        }
                        visbale = $scope.HighlightCompare(func);
                    } else {
                        if (CompareValue[h.Name] == h.Value) {
                            //hSummery.push(h);
                            visbale = true;
                        } else {
                            visbale = false;
                        }

                        if (CompareValue[h.Name] == null && h.Value == false) {
                            visbale = true;
                        }
                    }
                    h.Visable = visbale;
                    return visbale
                }
                $scope.HighlightCompare = function (compareExpresstion) {

                    var reslut = $scope.$eval(compareExpresstion);
                    return reslut;
                }
                var CaseInfo = { Name: '', Address: '' }
                $scope.GetCaseInfo = function () {
                    var caseName = $scope.LegalCase.CaseName
                    if (caseName) {
                        CaseInfo.Address = caseName.replace(/-(?!.*-).*$/, '');
                        var matched = caseName.match(/-(?!.*-).*$/);
                        CaseInfo.Name = matched[0].replace('-', '')
                    }
                    return CaseInfo;
                }

                $scope.isPassByDays = function (start, end, count) {
                    var start_date = new Date(start);
                    var end_date = new Date(end);

                    // Do the math.
                    var millisecondsPerDay = 1000 * 60 * 60 * 24;
                    var millisBetween = end_date.getTime() - start_date.getTime();
                    var days = millisBetween / millisecondsPerDay;

                    if (days > count) {
                        return true;
                    }

                    return false;
                }
                $scope.isPassOrEqualByDays = function (start, end, count) {
                    var start_date = new Date(start);
                    var end_date = new Date(end);

                    // Do the math.
                    var millisecondsPerDay = 1000 * 60 * 60 * 24;
                    var millisBetween = end_date.getTime() - start_date.getTime();
                    var days = millisBetween / millisecondsPerDay;

                    if (days >= count) {
                        return true;
                    }

                    return false;
                }
                $scope.isLessOrEqualByDays = function (start, end, count) {
                    var start_date = new Date(start);
                    var end_date = new Date(end);

                    // Do the math.
                    var millisecondsPerDay = 1000 * 60 * 60 * 24;
                    var millisBetween = end_date.getTime() - start_date.getTime();
                    var days = millisBetween / millisecondsPerDay;

                    if (days >= 0 && days <= count) {
                        return true;
                    }

                    return false;
                }
                $scope.isPassByMonths = function (start, end, count) {
                    var start_date = new Date(start);
                    var end_date = new Date(end);
                    var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

                    if (months > count) return true;
                    else return false;
                }
                $scope.isPassOrEqualByMonths = function (start, end, count) {
                    var start_date = new Date(start);
                    var end_date = new Date(end);
                    var months = (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth();

                    if (months >= count) return true;
                    else return false;
                }

                $scope.AddArrayItem = function (model) {
                    model = model || [];
                    model.push({});
                }
                $scope.DeleteItem = function (model, index) {
                    model.splice(index, 1);
                }

                $scope.isLess08292013 = false;
                $scope.isBigger08302013 = false;
                $scope.isBigger03012015 = false;
                $scope.showSAndCFormFlag = false;

                $scope.showSAndCFrom = function () {
                    var date = new Date($scope.LegalCase.ForeclosureInfo.SAndCFiledDate);
                    if (date - new Date("08/29/2013") > 0) {
                        $scope.isLess08292013 = false;
                    } else {
                        $scope.isLess08292013 = true;
                    }
                    if ($scope.isLess08292013) {
                        $scope.isBigger08302013 = false;
                    } else {
                        $scope.isBigger08302013 = true;
                    } if (date - new Date("03/01/2015") > 0) {
                        $scope.isBigger03012015 = true;
                    } else {
                        $scope.isBigger03012015 = false;
                    }
                    $scope.showSAndCFormFlag = $scope.isLess08292013 | $scope.isBigger08302013 | $scope.isBigger03012015;
                };

                $scope.HighLightStauts = function (model, index) {
                    return parseInt(model) > index ? true : false;
                };
                $scope.addToEstateMembers = function (index) {
                    $scope.LegalCase.ForeclosureInfo.MembersOfEstate.push({ "id": index, "name": $scope.LegalCase.membersText });
                    $scope.LegalCase.membersText = '';
                }
                $scope.delEstateMembers = function (index) {
                    $scope.LegalCase.ForeclosureInfo.MembersOfEstate.splice(index, 1);
                }
                $scope.ShowECourts = function (borough) {
                    $http.post('/CallBackServices.asmx/GetBroughName', { bro: $scope.LegalCase.PropertyInfo.Borough }).success(function (data) {
                        var urls = ['http://bronxcountyclerkinfo.com/law/UI/User/lne.aspx', ' http://iapps.courts.state.ny.us/kcco/', ' https://iapps.courts.state.ny.us/qcco/'];
                        var url = urls[borough - 2];
                        var title = $scope.LegalCase.CaseName;
                        var subTitle = ' (' + 'Brough: ' + data.d + ' Block: ' + $scope.LegalCase.PropertyInfo.Block + ' Lot: ' + $scope.LegalCase.PropertyInfo.Lot + ')';
                        ShowPopupMap(url, title, subTitle);
                    })

                }

                $scope.missingItems = [
                    { id: 1, label: "Mortgage" },
                    { id: 2, label: "Note" },
                    { id: 3, label: "Assignment" },
                ];

                $scope.updateMissInCertValue = function (value) {
                    $scope.LegalCase.ForeclosureInfo.MissInCert = value;
                }

                $scope.checkMissInCertValue = function () {
                    if ($scope.LegalCase.ForeclosureInfo.MortNoteAssInCert) return false;
                    if (!$scope.LegalCase.ForeclosureInfo.MissInCert || $scope.LegalCase.ForeclosureInfo.MissInCert.length == 0)
                        return true;
                    else return false;
                }

                $scope.initMissInCert = function () {
                    return {
                        dataSource: $scope.missingItems,
                        valueExpr: 'id',
                        displayExpr: 'label',
                        onValueChanged: function (e) {
                            e.model.updateMissInCertValue(e.values);
                        }
                    };
                }
                //-- end Steven code part--

                $scope.ShowAddPopUp = function (event) {
                    $scope.addCommentTxt = "";
                    aspxAddLeadsComments.ShowAtElement(event.target);
                }

                $scope.SaveLegalComments = function () {

                    $scope.LegalCase.LegalComments.push({ id: $scope.LegalCase.LegalComments.length + 1, Comment: $scope.addCommentTxt });
                    $scope.SaveLegal(function() {
                        console.log("ADD comments" + $scope.addCommentTxt);
                        aspxAddLeadsComments.Hide();
                    });
                }

                $scope.DeleteComments = function (index) {
                    $scope.LegalCase.LegalComments.splice(index, 1);
                    $scope.SaveLegal(function() {
                        console.log("Deleted comments");
                    });
                }


                $scope.AddActivityLog = function () {
                    if (typeof AddActivityLog == "function") {
                        AddActivityLog($scope.MustAddedComment);
                    }
                }

                /* end loading panel */
                $scope.CheckWorkHours = function () {
                    $http.get("/api/WorkingLogs/Legal/" + $scope.LegalCase.BBLE).success(function (data) {
                        $scope.TotleHours = data;
                        $("#WorkPopUp").modal();
                    });

                }
            });

        </script>
        <script>
            $(document).ready(function () {
                $('body').tooltip({
                    selector: '.tooltip-examples',
                    placement: 'bottom'
                });
            })
        </script>

        <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
        <uc1:WorkingLogControl runat="server" ID="WorkingLogControl" />

        <script type="text/javascript">
            $(function () {
                if (leadsInfoBBLE && leadsInfoBBLE != null) {
                    if (WorkingLogControl)
                        WorkingLogControl.openFile(leadsInfoBBLE, "Legal");
                }
            });
        </script>
    </div>
</asp:Content>
