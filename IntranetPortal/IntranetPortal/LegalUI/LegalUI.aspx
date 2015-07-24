<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LegalUI.aspx.vb" Inherits="IntranetPortal.LegalUI" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/LegalUI/LegalCaseList.ascx" TagPrefix="uc1" TagName="LegalCaseList" %>
<%@ Register Src="~/LegalUI/LegalTab.ascx" TagPrefix="uc1" TagName="LegalTab" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register TagPrefix="uc1" TagName="LegalSecondaryActions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<%@ Register Src="~/LegalUI/ManagePreViewControl.ascx" TagPrefix="uc1" TagName="ManagePreViewControl" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>

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
        .legalui .ss_form_input_title{
            color: rgb(50, 50, 50)
        }
    </style>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

    <%--leagal Ui--%>

    <div id="LegalCtrl" ng-controller="LegalCtrl">

        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <uc1:LegalCaseList runat="server" ID="LegalCaseList" />
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane ShowCollapseBackwardButton="True" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px" Name="dataPane">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <script>
                                $(document).ready(function () {

                                    $('.popup').webuiPopover({ title: 'Contact ' + $("#vendor_btn").html(), content: $('#contact_popup').html(), width: 400 });

                                });
                            </script>

                            <%-- <div>{{contacts}}</div>
                            <md-content class="md-padding autocomplete" layout="column">
                                <md-contact-chips ng-model="contacts" md-contacts="querySearch($query)" md-contact-name="Name" md-contact-image="image" md-contact-email="Email" md-require-match="" filter-selected="filterSelected" placeholder="Contacts">
                                </md-contact-chips>
                            </md-content>--%>
                            <%--
                             <md-content layout-padding>
                                  <md-input-container style="width:80%">
                                    <label>Company (Disabled)</label>
                                    <input ng-model="user.company">
                                 </md-input-container>
                                <div layout layout-sm="column">
                                    <md-input-container flex>
                                        <label>First name</label>
                                        <input ng-model="user.firstName">
                                    </md-input-container>
                                    <md-input-container flex>
                                        <label>Last Name</label>
                                        <input ng-model="theMax">
                                    </md-input-container>
                                </div>
                            </md-content>
                             <section layout="row" layout-sm="column" layout-align="center center">
                              <md-button type="button" class="md-raised">Button</md-button>
                              <md-button type="button" class="md-raised md-primary">Primary</md-button>
                              <md-button type="button" ng-disabled="true" class="md-raised md-primary">Disabled</md-button>
                              <md-button type="button" class="md-raised md-warn">Warn</md-button>
                              <div class="label">Raised</div>
                            </section>--%>
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

                                <% If Not HiddenTab Then%>
                                <div class="legal-menu row" style="margin-left: 0px; margin-right: 0px">
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="background: #ff400d; font-size: 18px; color: white; height: 70px">
                                        <li class="active short_sale_head_tab">
                                            <a href="#LegalTab" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-info-circle  head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Legal</div>
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
                                            <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="SaveLegal()" data-original-title="Save"></i>

                                            <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerPreview Then%>
                                            <i class="fa fa-lightbulb-o sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Research');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to Research"></i>
                                            <% End If%>

                                            <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.LegalResearch Then%>
                                            <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="CompleteResearch()" data-original-title="Complete Research"></i>
                                            <% End If%>

                                            <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerAssign Then%>
                                            <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback('type|Attorney');popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Assign to Attorney"></i>
                                            <% End If%>

                                            <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.AttorneyHandle Then%>
                                            <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="AttorneyComplete()" data-original-title="Complete"></i>
                                            <% End If%>

                                            <i class="fa fa-users sale_head_button sale_head_button_left tooltip-examples" title="" onclick="VendorsPopupClient.Show()" data-original-title="Contacts"></i>
                                            <%--<i class="fa fa-external-link-square sale_head_button sale_head_button_left tooltip-examples" data-toggle="tooltip" data-original-title="Go To" onclick='ShowPopupLeadsMenu(this,leadsInfoBBLE)'></i>--%>

                                            <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="" onclick="ShowEmailPopup(leadsInfoBBLE)" data-original-title="Mail"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="" onclick="" data-original-title="Print"></i>
                                        </li>
                                    </ul>
                                </div>
                                <% End If%>
                                <% If DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerAssign Or DisplayView = IntranetPortal.Legal.LegalCaseStatus.ManagerPreview Then%>
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

                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
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
                                    <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                    <li style="margin-right: 30px; color: #7396a9; float: right">
                                        <%--<div style="display: inline-block">
                                            <a href="/LegalUI/LegalUI.aspx?SecondaryAction=true"><i class="fa fa-arrow-right sale_head_button sale_head_button_left tooltip-examples" style="margin-right: 10px; color: #7396A9" title="Secondary" onclick=""></i></a>
                                        </div>--%>

                                        <%--                                        <i class="fa fa-codepen  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback();popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Research"></i>
                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="" onclick="popupSelectAttorneyCtr.PerformCallback();popupSelectAttorneyCtr.ShowAtElement(this);" data-original-title="Attorney"></i>
                                        <i class="fa fa-check sale_head_button sale_head_button_left tooltip-examples" title="" ng-click="AttorneyComplete()" data-original-title="Close"></i>--%>

                                        <%--<i class="fa fa-repeat sale_head_button tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>--%>
                                        <%-- <i class="fa fa-file sale_head_button sale_head_button_left tooltip-examples" title="New File" onclick="LogClick('NewFile')"></i>--%>
                                        <%--<i class="fa fa-folder-open sale_head_button sale_head_button_left tooltip-examples" title="Active" onclick="LogClick('Active')"></i>--%>
                                        <%--<i class="fa fa-sign-out  sale_head_button sale_head_button_left tooltip-examples" title="Eviction" onclick="tmpBBLE=leadsInfoBBLE;popupEvictionUsers.PerformCallback();popupEvictionUsers.ShowAtElement(this);"></i>--%>
                                        <%-- <i class="fa fa-pause sale_head_button sale_head_button_left tooltip-examples" title="On Hold" onclick="LogClick('OnHold')"></i>--%>
                                        <%--<i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="LogClick('Closed')"></i>--%>
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
        <uc1:Common runat="server" ID="Common" />
        <div runat="server" id="SencnedAction" visible="False" style="padding: 0 10px">

            <%--<div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="clearfix">
                            <div class="pop_up_header_margin">
                                <i class="fa fa-university  with_circle pop_up_header_icon"></i>
                                <span class="pop_up_header_text">Legal</span>
                            </div>
                            <div class="pop_up_buttons_div">
                                <i class="fa fa-times icon_btn" data-dismiss="modal" style="font-size: 23px;"></i>
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">--%>
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
        <%--<div class="modal-footer">
            <button type="button" class="btn btn-primary">Confirm</button>
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        </div>--%>

        <div runat="server" id="MangePreview" visible="False">
            <uc1:ManagePreViewControl runat="server" ID="ManagePreViewControl" />
        </div>
    </div>
    <!-- /.modal-content -->
    <%--  </div>
        </div>
    </div>--%>
    <uc1:SendMail runat="server" ID="SendMail" />
    <script type="text/javascript">

        function VendorsClosing(s) {
            GetContactCallBack();
        }
        GetContactCallBack = function (contact) {
            $.getJSON('/LegalUI/ContactService.svc/LoadContacts').done(function (data) {

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

        var AllContact = <%= GetAllContact()%>
            function t() {

            }
        var AllRoboSignor = <%= GetAllRoboSingor() %>
            function s() {

            }
        var taskSN = '<%= Request.QueryString("sn")%>';
        <%--var LegalCase = $.parseJSON('<%= LegalCase%>');--%>

        var portalApp = angular.module('PortalApp');

        portalApp.controller('LegalCtrl', function ($scope, $http, $element, $parse) {
            $scope.LegalCase = { PropertyInfo: {}, ForeclosureInfo: {}, SecondaryInfo: {} };
            $http.post('/LegalUI/ContactService.svc/CheckInShortSale', { bble: leadsInfoBBLE }).success(function (data) {

                $scope.LegalCase.InShortSale = data;

            });

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
                    return contact.Name && (contact.Name.toLowerCase().indexOf(lowercaseQuery) != -1);
                };

            }

            function loadContacts() {
                var contacts = AllContact;
                return contacts.map(function (c, index) {

                    c.image = 'https://storage.googleapis.com/material-icons/external-assets/v1/icons/svg/ic_account_circle_black_48px.svg'
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
            //var PropertyInfo = $scope.LegalCase.PropertyInfo;
            //CaseData = $scope.LegalCase;
            //PropertyInfo.PropertyAddress = "421 HART ST, BEDFORD STUYVESANT,NY 11221";
            //PropertyInfo.StreetName = 'HART ST';
            //PropertyInfo.Number = "421";
            //PropertyInfo.City = "BEDFORD STUYVESANT";
            //PropertyInfo.State = "NY";
            //PropertyInfo.Zipcode = "11221";
            //PropertyInfo.Number = "421";


            //PropertyInfo.Block = 1234;


            //PropertyInfo.Lot = 123;
            //PropertyInfo.BuildingType = "Apartment";
            //PropertyInfo.Class = 'A0';
            //PropertyInfo.Condition = 'Good';
            //PropertyInfo.VacantOrOccupied = "Vacant";
            //PropertyInfo.AgentId = 164;
            //PropertyInfo.Use = '';
            //PropertyInfo.OwnerOfRecordId = 164;
            //PropertyInfo.CaseContactId = 164;
            //PropertyInfo.Class = 'A0';

            var ForeclosureInfo = $scope.LegalCase.ForeclosureInfo;
            ForeclosureInfo.PlaintiffId = 638;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.DefendantId = 646;
            //ForeclosureInfo.AttorneyId = 646;
            //ForeclosureInfo.LastCourtDate = '05/05/2015';
            //ForeclosureInfo.NextCourtDate = '05/06/2015';
            //ForeclosureInfo.SaleDate = '05/06/2015';
            //ForeclosureInfo.HAMP = true;
            //ForeclosureInfo.LastUpdate = '05/08/2015';
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;
            //ForeclosureInfo.ServicerId = 646;

            //var SecondaryInfo = $scope.LegalCase.PropertyInfo;

            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.Status = "Status 1";
            //SecondaryInfo.Tasks = "Task 1";
            //SecondaryInfo.AttorneyWorkingFile = "Working File 1";
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.BorrowerId = 638;
            //SecondaryInfo.CoBorrowerId = 639;
            //SecondaryInfo.Language = "Chinese";
            //SecondaryInfo.MentalCapacity = "Capacity 1";
            //SecondaryInfo.Divorce = false;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;
            //SecondaryInfo.OpposingPartyId = 638;

            //$scope.SelectContactId = 128;

            //$scope.selectBoxData = AllContact;
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
                        $.getJSON('/LegalUI/ContactService.svc/GetContacts?args=' + loadOptions.searchValue).done(function (data) {
                            d.resolve(data);
                        });
                    } else {

                        $.getJSON('/LegalUI/ContactService.svc/LoadContacts').done(function (data) {
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
                    $.get('/LegalUI/ContactService.svc/GetAllContacts?id=' + key)
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
            $scope.AllJudges = <%= GetAllJudge()%>
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
            $scope.CheckPlace = function (p) {
                if (p) {
                    return p == 'NY';
                }
                return false;
            }

            $scope.SaveLegal = function (scuessfunc) {
                var json = JSON.stringify($scope.LegalCase);

                var data = { bble: leadsInfoBBLE, caseData: json };
                $http.post('LegalUI.aspx/SaveCaseData', data).
                    success(function () {
                        if (scuessfunc) {
                            scuessfunc()
                        } else {
                            alert("Save Successed !");
                        }

                    }).
                    error(function (data, status) {
                        alert("Fail to save data. status " + status + "Error : " + JSON.stringify(data));
                    });

            }



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

            $scope.LoadLeadsCase = function (BBLE) {
                $("#ctl00_MainContentPH_ASPxSplitter1_1,#ctl00_MainContentPH_ASPxSplitter1_2").css('visibility', 'visible');
                var data = { bble: BBLE };

                $http.post('LegalUI.aspx/GetCaseData', data).
                    success(function (data, status, headers, config) {

                        $scope.LegalCase = $.parseJSON(data.d);
                        
                        $scope.LegalCase.LegalComments = $scope.LegalCase.LegalComments || [];
                        $scope.LegalCase.ForeclosureInfo = $scope.LegalCase.ForeclosureInfo || {};
                        var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate"];
                        var arrays = ["AffidavitOfServices", "Assignments", "MembersOfEstate", ];
                        for (a in arrays) {
                            var porp = arrays[a]
                            var array = $scope.LegalCase.ForeclosureInfo[porp];
                            if (!array || array.length == 0) {
                                $scope.LegalCase.ForeclosureInfo[porp] = [];
                                $scope.LegalCase.ForeclosureInfo[porp].push({});
                            }

                        }
                        $scope.showSAndCFrom();

                    }).
                    error(function () {
                        alert("Fail to load data : " + BBLE);
                    });
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
                return $scope.LegalCase.SecondaryInfo.SelectedType == filed;

            }
            $scope.ShowContorl = function (m) {
                var t = typeof m;

                if (t == "string") {
                    return m == 'true'
                }
                return m;

            }
            var hSummery = [{ "Name": "CaseStauts", "CallFunc": "HighLightStauts(LegalCase.CaseStauts,4)", "Value": "", "Description": "Last milestone document recorded on Clerk Minutes after O/REF. ", "ArrayName": "" },
                            { "Name": "EveryOneIn", "CallFunc": "", "Value": "false", "Description": "Nobody is part of the estate served .", "ArrayName": "" },
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
                            { "Name": "PlaintiffHaveAtCommencement", "CallFunc": "", "Value": "false", "Description": "Current plaintiff didn\'t have  in possession, the note and mortgage at time of commencement. ", "ArrayName": "" },
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
            $scope.HighLightStauts = function (stauts, Count) {
                return stauts > Count;
            }
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
            //$.getJSON('/LegalUI/ContactService.svc/GetAllContacts', function (data) {

            //    $scope.selectBoxData = data;
            //});

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
                if (parseInt(model) > index) return true;
                else return false;
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
            //--Steven code part--

            $scope.ShowAddPopUp = function (event) {
                $scope.addCommentTxt = "";
                aspxAddLeadsComments.ShowAtElement(event.target);
            }

            $scope.SaveLegalComments = function () {

                $scope.LegalCase.LegalComments.push({ id: $scope.LegalCase.LegalComments.length + 1, Comment: $scope.addCommentTxt });
                $scope.SaveLegal(function () {
                    console.log("ADD comments" + $scope.addCommentTxt);
                    aspxAddLeadsComments.Hide();
                })
            }

            $scope.DeleteComments = function (index) {
                $scope.LegalCase.LegalComments.splice(index, 1);
                $scope.SaveLegal(function () {
                    console.log("Deleted comments");
                })
            }
            //------------------------------


            //stephen code part ---------




            //----------------------------

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
    <script src="/Scripts/bootstrap.min.js"></script>
</asp:Content>
