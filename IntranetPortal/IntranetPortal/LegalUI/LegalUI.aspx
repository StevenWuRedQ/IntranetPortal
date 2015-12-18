<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" EnableEventValidation="false" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/ShortSale/ShortSaleFileOverview.ascx" TagPrefix="uc1" TagName="ShortSaleFileOverview" %>
<%@ Register Src="~/WorkingLog/WorkingLogControl.ascx" TagPrefix="uc1" TagName="WorkingLogControl" %>

<%@ Register Src="~/LegalUI/LegalCaseList.ascx" TagPrefix="uc1" TagName="LegalCaseList" %>
<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>
<%@ Register Src="~/LegalUI/LegalSecondaryActions.ascx" TagPrefix="uc1" TagName="LegalSecondaryActions" %>
<%@ Register Src="~/LegalUI/ManagePreViewControl.ascx" TagPrefix="uc1" TagName="ManagePreViewControl" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <style type="text/css">
        #ctl00_MainContentPH_ASPxSplitter1_1, #ctl00_MainContentPH_ASPxSplitter1_2 {
            visibility: hidden;
        }

        .md-contact-suggestion img {
            margin-top: -35px;
        }
    </style>

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
                <asp:Panel ID="datapanel" runat="server" Height="100%">
                    <div id="legalPanelContent" style="height: 100%">
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
                            <div class="legal-menu row" style="position: relative; top: 0; margin: 0; z-index: 1; width: 100%">
                                <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white">
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
                                                <li><i class="fa fa-users sale_head_button sale_head_button_left tooltip-examples" title="" data-original-title="Contacts" onclick="VendorsPopupClient.Show()"></i></li>
                                                <li><i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" data-original-title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i></li>
                                                <li><i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" data-original-title="Print" onclick=""></i></li>
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
                                                }"></ClientSideEvents>
                                        </dx:ASPxButton>
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                                <ClientSideEvents Closing="function(s,e){
                                              if (typeof gridTrackingClient != 'undefined')
                                                    gridTrackingClient.Refresh();
                                        }"></ClientSideEvents>
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


                            <div class="tab-content" style="height: 100%">
                                <div class="tab-pane active" id="LegalTab" style="height: 100%">
                                    <uc1:LegalTab runat="server" ID="LegalTab1" />
                                    <script>
                                        LegalShowAll = true;
                                    </script>
                                </div>
                                <div class="tab-pane" id="DocumentTab" style="height: 100%">
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
                        <!-- modal -->
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

            var AllJudges = function () {
                return <%= GetAllJudge()%>
            }();
            var AllContact = function () {
                return <%= GetAllContact()%>
            }();
            var AllRoboSignor = function () {
                return <%= GetAllRoboSingor() %>
            }();
            var taskSN = function () {
                return '<%= Request.QueryString("sn")%>'
            }();

        </script>
        <script>


            $(function () {
                var scope = angular.element('#LegalCtrl').scope();
                ScopeAutoSave(GetLegalData, scope.SaveLegal, '#LegalTabHead');

                $('body').tooltip({
                    selector: '.tooltip-examples',
                    placement: 'bottom'
                });

                if (leadsInfoBBLE && leadsInfoBBLE != null) {
                    if (WorkingLogControl)
                        WorkingLogControl.openFile(leadsInfoBBLE, "Legal");
                }
            });
        </script>

        <uc1:VendorsPopup runat="server" ID="VendorsPopup" />
        <uc1:WorkingLogControl runat="server" ID="WorkingLogControl" />
    </div>
</asp:Content>
