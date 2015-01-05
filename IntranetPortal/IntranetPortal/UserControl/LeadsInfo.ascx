<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsInfo.ascx.vb" Inherits="IntranetPortal.LeadsInfo1" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/HomeOwnerInfo.ascx" TagPrefix="uc1" TagName="HomeOwnerInfo" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/PropertyInfo.ascx" TagPrefix="uc1" TagName="PropertyInfo" %>
<%@ Register Src="~/OneDrive/LeadsDocumentOneDrive.ascx" TagPrefix="uc1" TagName="LeadsDocumentOneDrive" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>
<%@ Register Src="~/PopupControl/EditHomeOwner.ascx" TagPrefix="uc1" TagName="EditHomeOwner" %>

<script type="text/javascript">
    // <![CDATA[
    function OnClick(s, e) {
        ASPxPopupMenuPhone.ShowAtElement(s.GetMainElement());
    }

    var tmpPhoneNo = null;
    var temTelLink = null;
    var temCommentSpan = null;
    function onSavePhoneComment() {

        var comment = $("#phone_comment").val();
        var temCommentSpan = $(temTelLink).children("span:first")
        if (temCommentSpan != null) {
            //$(".phone_comment").text("-" + comment);
            temCommentSpan.text("-" + comment);
        } else {
            debugger
        }
        OnCallPhoneCallback("SaveComment|" + tmpPhoneNo + "|" + comment);
        debugger;
    }

    function OnTelphoneLinkClick(tellink, phoneNo) {
        tmpPhoneNo = phoneNo;
        temTelLink = tellink;
        ASPxPopupMenuPhone.ShowAtElement(tellink);

    }
    var tmpEmail = null;
    var tempEmailLink = null;
    function OnEmailLinkClick(EmailId, bble, ownerName, emailink) {
        tmpEmail = EmailId;
        tempEmailLink = emailink;
        currOwner = ownerName;
        EmailPopupClient.ShowAtElement(emailink);
    }
    function OnPhoneNumberClick(s, e) {
        if (tmpPhoneNo != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("CallPhone|" + tmpPhoneNo);
            }

            if (e.item.index == 1) {
                //telphoneLine.style.textDecoration = "line-through";
                //telphoneLine.style.color = "red";

                OnCallPhoneCallback("BadPhone|" + tmpPhoneNo);
                SetSameStyle("PhoneLink", "color:red;text-decoration:line-through;", tmpPhoneNo);
            }

            if (e.item.index == 2) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";                
                OnCallPhoneCallback("RightPhone|" + tmpPhoneNo);
                SetSameStyle("PhoneLink", "color:green;text-decoration:none;", tmpPhoneNo);
            }

            if (e.item.index == 3) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("UndoPhone|" + tmpPhoneNo);
                SetSameStyle("PhoneLink", "", tmpPhoneNo);
            }
            if (e.item.index == 4) {
                $("#phone_comment").val("")
                $('#exampleModal').modal();
                //PhoneCommentPopUpClient.Show();

            }
        }
        e.item.SetChecked(false);

        if (sortPhones && e.item.index != 4) {
            sortPhones();
        }
    }

    function SetSameStyle(className, style, value) {
        var list = document.getElementsByClassName(className)

        for (var i = 0; i < list.length; i++) {
            var item = list[i];

            if (item.innerText.indexOf(value) == 0) {
                item.setAttribute("style", style);
            }
        }
    }

    function OnCallPhoneCallback(e) {
        if (callPhoneCallbackClient.InCallback()) {
            alert("Server is busy! Please wait!")
        } else {
            callPhoneCallbackClient.PerformCallback(e);
        }
    }

    function OnCallPhoneCallbackComplete(s, e) {

        if (e.result == "True") {
            if (typeof gridTrackingClient != "undefined") {
                gridTrackingClient.Refresh();
            }
        }
        else {
            //disable call back, use client script to format same phone num or address
            //ownerInfoCallbackPanel.PerformCallback("");
        }
    }

    function OnCallBackButtonClick(s, e) {
        ASPxPopupMenuClientControl.ShowAtElement(s.GetMainElement());
    }

    function OnCallbackMenuClick(s, e) {

        if (e.item.name == "Custom") {
            ASPxPopupSelectDateControl.ShowAtElement(s.GetMainElement());
            e.processOnServer = false;
            return;
        }

        SetLeadStatus(e.item.name);
        e.processOnServer = false;
    }

    function SetLeadStatus(status) {
        if (leadStatusCallbackClient.InCallback()) {
            alert("Server is busy! Please wait!")
        } else {
            leadStatusCallbackClient.PerformCallback(status);
        }
    }

    function OnSetStatusComplete(s, e) {
        if (typeof gridLeads == "undefined") {
            //alert("undefined");
        }
        else
            gridLeads.Refresh();

        if (typeof gridTrackingClient != "undefined")
            gridTrackingClient.Refresh();

        if (typeof window.parent.agentTreeCallbackPanel == "undefined")
            return;
        else
            window.parent.agentTreeCallbackPanel.PerformCallback("");
    }

    function PrintLeadInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE;
            window.open(url, 'Show Report', 'Width=800px,Height=800px');
        }
    }

    function PrintLogInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE + "&t=log";
            window.open(url, 'Show Report', 'Width=800px,Height=800px');
        }
    }

    function detectivePhoneNumber(panel) {

        var regexObj = /\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})/g;

        var subjectString = panel.GetContentHtml();
        if (regexObj.test(subjectString)) {
            subjectString = subjectString.replace(regexObj, "<a href='#' onclick='return OnTelphoneLinkClick(this)'>($1) $2-$3</a>");
            panel.SetContentHtml(subjectString);
        }
    }

    function detectiveAddress(panel) {

        var regexObj = /\s+([0-9]{1,6}){0,1}(court|ct|street|st|drive|dr|lane|ln|road|rd|blvd)([\s|\,|.|\;]+)?(([a-zA-Z|\s+]{1,30}){1,2})([\s|\,|.]+)?\b(AK|AL|AR|AZ|CA|CO|CT|DC|DE|FL|GA|GU|HI|IA|ID|IL|IN|KS|KY|LA|MA|MD|ME|MI|MN|MO|MS|MT|NC|ND|NE|NH|NJ|NM|NV|NY|OH|OK|OR|PA|RI|SC|SD|TN|TX|UT|VA|VI|VT|WA|WI|WV|WY)([\s|\,|.]+)?(\s+\d{5})?([\s|\,|.]+)/i

        var subjectString = panel.GetContentHtml();
        //alert(subjectString);
        //alert(regexObj.test(subjectString));
        if (regexObj.test(subjectString)) {
            subjectString = subjectString.replace(regexObj, "<a href='#' onclick='return OnTelphoneLinkClick(this)'>$1 $2 $3</a>");
            panel.SetContentHtml(subjectString);
        }
    }

    var tmpAddress = null;
    function OnAddressLinkClick(s, address) {
        tmpAddress = address;
        AspxPopupMenuAddress.ShowAtElement(s);
    }

    function OnAddressPopupMenuClick(s, e) {

        if (tmpAddress != null) {
            if (e.item.index == 0) {
                OnCallPhoneCallback("DoorKnock|" + tmpAddress);
                SetLeadStatus(4);
            }

            if (e.item.index == 1) {
                OnCallPhoneCallback("BadAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "color:red;text-decoration:line-through;", tmpAddress);
            }

            if (e.item.index == 2) {
                OnCallPhoneCallback("RightAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "color:green;text-decoration:none;", tmpAddress);
            }

            if (e.item.index == 3) {
                OnCallPhoneCallback("UndoAddress|" + tmpAddress);
                SetSameStyle("AddressLink", "", tmpAddress);
            }

            e.item.SetChecked(false);
        }
    }

    function OnRefreshPage() {
        if (typeof ContentCallbackPanel != "undefined") {
            var parms = "Refresh|" + leadsInfoBBLE;
            ContentCallbackPanel.PerformCallback(parms);
        }
        else {
            __doPostBack('', '');
        }
    }

    function OnRefreshMenuClick(s, e) {
        if (typeof ContentCallbackPanel != "undefined") {
            var parms = "Refresh|" + leadsInfoBBLE + "|" + e.item.name;
            ContentCallbackPanel.PerformCallback(parms);
        }
        else {
            __doPostBack(s.name, '');
        }
    }

    function OnSaveAppointment(s, e) {
        ASPxPopupScheduleClient.Hide();
        var logId = hfLogIDClient.Get('logId');
        if (logId != null && logId > 0) {
            ReScheduledAppointment(logId);
            SetLeadStatus(9);
            appointmentCallpanel.PerformCallback("Clear");
        }
        else {
            SetLeadStatus(9);
        }
        gridTrackingClient.Refresh();
    }

    var currOwner = "";
    function AddBestPhoneNum(bble, ownerName, ulClient, addButton) {
        //var ul = document.getElementById(ulClient);
        //var li = document.createElement("li");
        //li.innerHTML = "<input type='text' id='' /><input type='button' value='Update'><input type='button' value='Delete'>";

        //if (ul.hasChildNodes())
        //    ul.insertBefore(li, ul.childNodes[0]);
        currOwner = ownerName;
        aspxPopupAddPhoneNum.ShowAtElement(addButton);
    }
    function OnEmailPopupClick(s, e) {
        ownerInfoCallbackPanel.PerformCallback("DeleteEmail|" + tmpEmail + "|" + currOwner);
    }
    function AddBestEmail(bble, ownerName, ulClient, addButton) {
        currOwner = ownerName;
        aspxPopupAddEmail.ShowAtElement(addButton);
    }
    var isSave = false;
    function AddBestAddress(bble, ownerName, addButton) {
        isSave = false;
        currOwner = ownerName;

        aspxPopupAddAddress.PerformCallback(addButton);
    }

    function SaveBestPhoneNo(s, e) {
        var phoneNo = txtPhoneNoClient.GetText();
        ownerInfoCallbackPanel.PerformCallback(phoneNo + "|" + currOwner);
        aspxPopupAddPhoneNum.Hide();
        txtPhoneNoClient.SetText("");
    }

    function SaveBestEmail(s, e) {
        var email = txtEmailClient.GetText();
        ownerInfoCallbackPanel.PerformCallback("SaveEmail|" + email + "|" + currOwner);
        aspxPopupAddEmail.Hide();
        txtEmailClient.SetText("");
    }

    function ShowLogPanel() {
        var paneInfo = contentSplitter.GetPaneByName("paneInfo");
        var paneLog = contentSplitter.GetPaneByName("LogPanel");

        if (paneInfo.IsCollapsed()) {
            paneInfo.Expand();
            paneLog.Collapse(paneInfo);
        }
        else {
            paneLog.Expand();
            paneInfo.Collapse(paneLog);

            if (typeof EmailBody != undefined) {
                EmailBody.SetHeight(148);
            }
        }

        contentSplitter.AdjustControl();
    }
    function addHomeOwnerClick(e) {
        var btn = $(e).parent().find('.fa fa-edit tooltip-examples:first')

        btn.onclick();
    }
</script>
<script src="/scripts/stevenjs.js?v=1.02"></script>
<style type="text/css">
    .UpdateInfoAlign {
        text-align: right;
    }

    .LeadsContentPanel {
        min-height: 800px;
        /*min-width:1100px;*/
    }
</style>

<dx:ASPxCallbackPanel runat="server" OnCallback="ASPxCallbackPanel2_Callback" ID="ASPxCallbackPanel2" Height="100%" ClientInstanceName="ContentCallbackPanel" EnableCallbackAnimation="true" CssClass="LeadsContentPanel">
    <PanelCollection>
        <dx:PanelContent ID="PanelContent1" runat="server">
            <dx:ASPxPanel runat="server" ID="doorKnockMapPanel" Visible="false" Width="100%" Height="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <iframe id="MapContent" width="100%" height="100%" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="/WebForm2.aspx"></iframe>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxPanel>
            <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="800px" Width="100%" ClientInstanceName="contentSplitter">
                <Styles>
                    <Pane Paddings-Padding="0">
                        <Paddings Padding="0px"></Paddings>
                    </Pane>
                </Styles>
                <Panes>
                    <dx:SplitterPane ShowCollapseBackwardButton="True" MinSize="665px" AutoHeight="true" Name="paneInfo">
                        <PaneStyle Paddings-Padding="0">
                            <Paddings Padding="0px"></Paddings>
                        </PaneStyle>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl3" runat="server">
                                <div style="width: 100%; align-content: center; height: 100%">
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu3" runat="server" ClientInstanceName="popupMenuRefreshClient"
                                        AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="All" Name="All"></dx:MenuItem>
                                            <dx:MenuItem Text="General Property Info" Name="Assessment"></dx:MenuItem>
                                            <dx:MenuItem Text="Mortgage and Violations" Name="PropData"></dx:MenuItem>
                                            <dx:MenuItem Text="Home Owner" Name="TLO">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="ZEstimate" Name="ZEstimate">
                                            </dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnRefreshMenuClick" />
                                        <%--<ItemStyle Width="143px"></ItemStyle>--%>
                                    </dx:ASPxPopupMenu>
                                    <asp:HiddenField ID="hfBBLE" runat="server" />
                                    <!-- Nav tabs -->
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                                        <li class="active short_sale_head_tab">
                                            <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Property Info</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab">
                                            <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-home head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Homeowner</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab">
                                            <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                                                <i class="fa fa-file head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Documents</div>
                                            </a>
                                        </li>
                                        <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                        <li style="margin-right: 30px; color: #ffa484; float: right">
                                            <% If Not ShowLogPanel Then%>
                                            <i class="fa fa-history sale_head_button tooltip-examples" id="btnShowlogPanel" style="background-color: #295268; color: white;" title="Show Logs" onclick="ShowLogPanel()"></i>
                                            <div class="tooltip fade bottom in" style="top: 54px; left: -17px; display: block;">
                                                <div class="tooltip-arrow"></div>
                                                <div class="tooltip-inner">Show Logs</div>
                                            </div>
                                            <% End If%>
                                            <i class="fa fa-refresh sale_head_button sale_head_button_left tooltip-examples" title="Refresh" onclick="popupMenuRefreshClient.ShowAtElement(this)"></i>
                                            <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup(leadsInfoBBLE)"></i>
                                            <i class="fa fa-share-alt  sale_head_button sale_head_button_left tooltip-examples" title="Share Leads" onclick="var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;AspxPopupShareleadClient.SetContentUrl(url);AspxPopupShareleadClient.Show();"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLeadInfo()"></i>
                                        </li>
                                    </ul>
                                    <div class="tab-content">
                                        <uc1:PropertyInfo runat="server" ID="PropertyInfo" />
                                        <div class="tab-pane clearfix" id="home_owner">
                                            <div style="height: 850px; overflow: auto" id="scrollbar_homeowner">
                                                <dx:ASPxCallbackPanel runat="server" ID="ownerInfoCallbackPanel" ClientInstanceName="ownerInfoCallbackPanel" OnCallback="ownerInfoCallbackPanel_Callback" Paddings-Padding="0px">
                                                    <PanelCollection>
                                                        <dx:PanelContent>
                                                            <div style="padding: 20px 20px 0px 20px">
                                                                <table style="width: 100%; margin: 0px; padding: 0px;">
                                                                    <tr>
                                                                        <td style="width: 50%; vertical-align: top">
                                                                            <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo2" />
                                                                        </td>
                                                                        <td style="border-left: 1px solid #b1b2b7; width: 8px;">&nbsp;
                                                                        </td>
                                                                        <td style="vertical-align: top">

                                                                            <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo3" />
                                                                            <% If (Not HomeOwnerInfo3.Visible) Then%>

                                                                            <% End If%>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </dx:PanelContent>
                                                    </PanelCollection>
                                                </dx:ASPxCallbackPanel>
                                            </div>

                                        </div>
                                        <div class="tab-pane" id="documents">
                                            <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
                                            <%--<uc1:LeadsDocumentOneDrive runat="server" ID="LeadsDocumentOneDrive" />--%>
                                        </div>
                                    </div>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu1" runat="server" ClientInstanceName="ASPxPopupMenuPhone"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Call Phone" Name="Call">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="# doesn't work" Name="nonWork">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Working Phone number" Name="Work">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Comment" Name="Comment">
                                            </dx:MenuItem>
                                        </Items>
                                        <ClientSideEvents ItemClick="OnPhoneNumberClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="EmailPopup" runat="server" ClientInstanceName="EmailPopupClient"
                                        PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Delete" Name="Delete">
                                            </dx:MenuItem>

                                        </Items>
                                        <ClientSideEvents ItemClick="OnEmailPopupClick" />
                                    </dx:ASPxPopupMenu>
                                    <dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="AspxPopupMenuAddress"
                                        ShowPopOutImages="false" AutoPostBack="false"
                                        ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px"
                                        PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick">
                                        <ItemStyle Paddings-PaddingLeft="20px" />
                                        <Items>
                                            <dx:MenuItem Text="Door knock" Name="doorKnock">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Wrong Property" Name="wrongProperty">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Correct Property" Name="correctProperty">
                                            </dx:MenuItem>
                                            <dx:MenuItem Text="Undo" Name="Undo">
                                            </dx:MenuItem>
                                        </Items>
                                        <%--disable the width by steven--%>
                                        <%--<ItemStyle Width="143px"></ItemStyle>--%>
                                        <%------end------%>
                                        <ClientSideEvents ItemClick="OnAddressPopupMenuClick" />
                                    </dx:ASPxPopupMenu>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                    <dx:SplitterPane ShowCollapseBackwardButton="True" Name="LogPanel" MinSize="665px">
                        <PaneStyle BackColor="#F9F9F9"></PaneStyle>
                        <ContentCollection>
                            <dx:SplitterContentControl ID="SplitterContentControl4" runat="server">
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
                                            <% If Not ShowLogPanel Then%>
                                            <i class="fa fa-info-circle sale_head_button tooltip-examples" style="background-color: #ff400d; color: white;" title="Show Property Info" onclick="ShowLogPanel()"></i>
                                            <div class="tooltip fade bottom in" style="top: 54px; left: -38px; display: block;">
                                                <div class="tooltip-arrow" style="border-bottom-color: #ff400d;"></div>
                                                <div class="tooltip-inner" style="background-color: #ff400d;">Show Property Info</div>
                                            </div>
                                            <% End If%>
                                            <i class="fa fa-calendar-o sale_head_button sale_head_button_left tooltip-examples" title="Schedule" onclick="ASPxPopupScheduleClient.PerformCallback();"></i>
                                            <i class="fa fa-sun-o sale_head_button sale_head_button_left tooltip-examples" title="Hot Leads" onclick="SetLeadStatus(5);"></i>
                                            <i class="fa fa-rotate-right sale_head_button sale_head_button_left tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                            <i class="fa fa-sign-in  sale_head_button sale_head_button_left tooltip-examples" title="Door Knock" onclick="SetLeadStatus(4);"></i>
                                            <i class="fa fa-refresh sale_head_button sale_head_button_left tooltip-examples" title="In Process" onclick="ShowInProcessPopup(leadsInfoBBLE);"></i>
                                            <i class="fa fa-times-circle sale_head_button sale_head_button_left tooltip-examples" title="Dead Lead" onclick="ShowDeadLeadsPopup(leadsInfoBBLE);"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                        </li>
                                    </ul>
                                    <uc1:ActivityLogs runat="server" ID="ActivityLogs" />
                                </div>
                                <dx:ASPxCallback ID="leadStatusCallback" runat="server" ClientInstanceName="leadStatusCallbackClient" OnCallback="leadStatusCallback_Callback">
                                    <ClientSideEvents CallbackComplete="OnSetStatusComplete" />
                                </dx:ASPxCallback>
                                <dx:ASPxCallback ID="callPhoneCallback" runat="server" ClientInstanceName="callPhoneCallbackClient" OnCallback="callPhoneCallback_Callback">
                                    <ClientSideEvents CallbackComplete="OnCallPhoneCallbackComplete" />
                                </dx:ASPxCallback>
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
                                                            <dx:ASPxButton ID="ASPxButton1" runat="server" Text="OK" AutoPostBack="false" ClientSideEvents-Click="function(){ASPxPopupSelectDateControl.Hide();}" CssClass="rand-button rand-button-blue">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupSelectDateControl.Hide();                                                                                                                       
                                                                                                                        SetLeadStatus('customDays');
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
                                            </asp:Panel>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                </dx:ASPxPopupControl>
                                <dx:ASPxPopupControl ClientInstanceName="ASPxPopupScheduleClient" Width="400px" Height="280px"
                                    MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="aspxPopupSchedule"
                                    HeaderText="Appointment" Modal="true" OnWindowCallback="aspxPopupSchedule_WindowCallback"
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
                                        <dx:PopupControlContentControl runat="server" Visible="false" ID="popupContentSchedule">
                                            <dx:ASPxCallbackPanel runat="server" ID="appointmentCallpanel" ClientInstanceName="appointmentCallpanel" OnCallback="appointmentCallpanel_Callback">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <dx:ASPxHiddenField runat="server" ID="HiddenFieldLogId" ClientInstanceName="hfLogIDClient"></dx:ASPxHiddenField>
                                                        <dx:ASPxFormLayout ID="formLayout" runat="server" Width="100%" SettingsItemCaptions-Location="Top">
                                                            <Items>
                                                                <dx:LayoutItem Caption="Type">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                            <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbScheduleType" CssClass="edit_drop">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Consultation" Value="Consultation" />
                                                                                    <dx:ListEditItem Text="Signing" Value="Signing" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Date">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                            <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="dateEditSchedule" ClientInstanceName="ScheduleDateClientCtr" TimeSectionProperties-Visible="True" CssClass="edit_drop">
                                                                                <TimeSectionProperties Visible="True"></TimeSectionProperties>
                                                                                <ClientSideEvents DropDown="function(s,e){ 
                                                                    var d = new Date('May 1 2014 12:00:00');                                                                    
                                                                    s.GetTimeEdit().SetValue(d);
                                                                    }" />
                                                                            </dx:ASPxDateEdit>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Location">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                            <dx:ASPxTextBox ID="txtLocation" runat="server" Width="100%" Text="In Office" CssClass="edit_drop"></dx:ASPxTextBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Manager">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                            <dx:ASPxComboBox runat="server" Width="100%" ID="cbMgr" CssClass="edit_drop">
                                                                                <Items>
                                                                                    <dx:ListEditItem Text="Any Manager" Value="*" />
                                                                                    <dx:ListEditItem Text="Ron Borovinsky" Value="Ron Borovinsky" />
                                                                                    <dx:ListEditItem Text="Michael Gendin" Value="Michael Gendin" />
                                                                                    <dx:ListEditItem Text="Allen Glover" Value="Allen Glover" />
                                                                                    <dx:ListEditItem Text="No Manager Needed" Value="" />
                                                                                </Items>
                                                                            </dx:ASPxComboBox>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                                <dx:LayoutItem Caption="Comments">
                                                                    <LayoutItemNestedControlCollection>
                                                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                            <dx:ASPxMemo runat="server" ID="txtScheduleDescription" Width="100%" Height="180px" ClientInstanceName="ScheduleCommentsClientCtr" CssClass="edit_text_area"></dx:ASPxMemo>
                                                                        </dx:LayoutItemNestedControlContainer>
                                                                    </LayoutItemNestedControlCollection>
                                                                </dx:LayoutItem>
                                                            </Items>
                                                        </dx:ASPxFormLayout>
                                                        <table style="width: 100%">
                                                            <tr>
                                                                <td style="color: #666666; font-family: Tahoma; font-size: 10px; align-content: center; text-align: center; padding-top: 2px;">
                                                                    <dx:ASPxButton ID="ASPxButton3" runat="server" Text="OK" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1">
                                                                        <ClientSideEvents Click="OnSaveAppointment"></ClientSideEvents>
                                                                    </dx:ASPxButton>
                                                                    &nbsp;
                                                            <dx:ASPxButton runat="server" Text="Cancel" AutoPostBack="false" CssClass="rand-button" BackColor="#77787b">
                                                                <ClientSideEvents Click="function(){
                                                                                                                        ASPxPopupScheduleClient.Hide();                                                                                                                                                                                                                                               
                                                                                                                        }"></ClientSideEvents>
                                                            </dx:ASPxButton>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </dx:PopupControlContentControl>
                                    </ContentCollection>
                                    <ClientSideEvents EndCallback="function(s,e){s.Show();}" />
                                </dx:ASPxPopupControl>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>
                </Panes>
                <ClientSideEvents PaneCollapsed="function(s,e){}" />
            </dx:ASPxSplitter>


            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddPhoneNum" Width="320px" Height="80px" ID="ASPxPopupControl2"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">

                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtPhoneNo" ClientInstanceName="txtPhoneNoClient" CssClass="edit_drop"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <div style="margin: 0px 10px; padding-top: 13px;">
                                        <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="SaveBestPhoneNo" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                       
                                    </div>
                                </td>
                                <td>
                                    <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                        <ClientSideEvents Click="function(s,e){aspxPopupAddPhoneNum.Hide();}" />
                                    </dx:ASPxButton>
                                </td>
                            </tr>


                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddEmail" Width="320px" Height="80px" ID="PopupAddEmail"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">

                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtEmail" ClientInstanceName="txtEmailClient" CssClass="edit_drop"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <div style="margin: 0px 10px; padding-top: 13px;">
                                        <dx:ASPxButton runat="server" ID="BtnAddEmail" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="SaveBestEmail" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                       
                                    </div>
                                </td>
                                <td>
                                    <dx:ASPxButton runat="server" ID="ASPxButton7" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                        <ClientSideEvents Click="function(s,e){aspxPopupAddEmail.Hide();}" />
                                    </dx:ASPxButton>
                                </td>
                            </tr>


                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddAddress" Width="400px" Height="80px" ID="ASPxPopupControl1"
                HeaderText="Add Address" OnWindowCallback="ASPxPopupControl1_WindowCallback" Modal="true"
                runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter">
                <ContentCollection>
                    <dx:PopupControlContentControl Visible="false" ID="popupContentAddAddress">
                        <table class="mail_edits">
                            <tr style="padding-top: 3px;">
                                <td><span class="font_12 color_gray upcase_text">Address:</span></td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtUserAddress" CssClass="email_input"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="padding-top: 3px;">
                                <td><span class="font_12 color_gray upcase_text">Description:</span></td>
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtAdrDes" CssClass="email_input"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="margin-top: 3px; line-height: 30px; margin-top: 10px">
                                <td></td>
                                <td>
                                    <div style="margin-top: 10px">
                                        <dx:ASPxButton runat="server" ID="ASPxButton2" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="function(s,e){
                                                isSave = true;
                                                aspxPopupAddAddress.PerformCallback('Save|' + currOwner);
                                                }" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                        <dx:ASPxButton runat="server" ID="ASPxButton5" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                            <ClientSideEvents Click="function(s,e){aspxPopupAddAddress.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents EndCallback="function(s,e){if(!isSave){s.Show();}else{s.Hide();ownerInfoCallbackPanel.PerformCallback();}}" />
            </dx:ASPxPopupControl>
            <uc1:SendMail runat="server" ID="SendMail" />
            <uc1:EditHomeOwner runat="server" ID="EditHomeOwner" />
        </dx:PanelContent>
    </PanelCollection>
    <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
    <Border BorderStyle="None"></Border>
</dx:ASPxCallbackPanel>
<%--<dx:ASPxPopupControl runat="server" ID="PhoneCommentPopup" ClientInstanceName="PhoneCommentPopUpClient"
    PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" HeaderText="Phone Comments">
    <ContentCollection>
        <dx:PopupControlContentControl>

            <div class="form-group">
                <label for="phone_comment" class="control-label">Comments:</label>
                <input type="text"  id="phone_comment">
            </div>

            <button type="button" onclick="onSavePhoneComment();">Save</button>
            <button type="button" onclick="PhoneCommentPopUpClient.Hide();">Close</button>
            <button type="button" onclick="onBtn()">Chagne Text</button>
            
        </dx:PopupControlContentControl>
    </ContentCollection>

</dx:ASPxPopupControl>--%>
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="exampleModalLabel">Phone Comments</h4>
            </div>
            <div class="modal-body">

                <div class="form-group">
                    <label for="phone_comment" class="control-label">Comments:</label>
                    <input type="text" class="form-control" id="phone_comment">
                </div>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="onSavePhoneComment();">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>

            </div>
        </div>
    </div>
</div>
