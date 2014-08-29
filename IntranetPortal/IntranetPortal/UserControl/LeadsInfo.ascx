<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsInfo.ascx.vb" Inherits="IntranetPortal.LeadsInfo1" %>
<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/HomeOwnerInfo.ascx" TagPrefix="uc1" TagName="HomeOwnerInfo" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/PropertyInfo.ascx" TagPrefix="uc1" TagName="PropertyInfo" %>


<script type="text/javascript">
    // <![CDATA[
    function OnClick(s, e) {
        ASPxPopupMenuPhone.ShowAtElement(s.GetMainElement());
    }

    var tmpPhoneNo = null;
    function OnTelphoneLinkClick(tellink, phoneNo) {
        tmpPhoneNo = phoneNo;
        ASPxPopupMenuPhone.ShowAtElement(tellink);
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
            }

            if (e.item.index == 2) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("RightPhone|" + tmpPhoneNo);
            }


            if (e.item.index == 3) {
                //telphoneLine.style.color = "green";
                //telphoneLine.style.textDecoration = "none";
                OnCallPhoneCallback("UndoPhone|" + tmpPhoneNo);
            }
        }

        e.item.SetChecked(false);
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
            ownerInfoCallbackPanel.PerformCallback("");
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
            window.showModalDialog(url, 'Show Report', 'dialogWidth:800px;dialogHeight:800px');
        }
    }

    function PrintLogInfo() {
        if (leadsInfoBBLE != null) {
            var url = '/ShowReport.aspx?id=' + leadsInfoBBLE + "&t=log";
            window.showModalDialog(url, 'Show Report', 'dialogWidth:800px;dialogHeight:800px');
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
            }

            if (e.item.index == 2) {
                OnCallPhoneCallback("RightAddress|" + tmpAddress);
            }

            if (e.item.index == 3) {
                OnCallPhoneCallback("UndoAddress|" + tmpAddress);
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

    function SaveBestPhoneNo(s, e) {
        var phoneNo = txtPhoneNoClient.GetText();
        ownerInfoCallbackPanel.PerformCallback(phoneNo + "|" + currOwner);
        aspxPopupAddPhoneNum.Hide();
        txtPhoneNoClient.SetText("");
    }
    function initToolTips() {
        if ($(".tooltip-examples").tooltip) {
            $(".tooltip-examples").tooltip({
                placement: 'bottom'
            });
        } else {
            alert('tooltip function can not found' + $(".tooltip-examples").tooltip);
        }
    }
    //initToolTips();
    // ]]> 
</script>
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
            <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter">
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
                                            <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-file head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Documents</div>
                                            </a>

                                        </li>

                                        <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                        <li style="margin-right: 30px; color: #ffa484;float:right">
                                            <i class="fa fa-refresh sale_head_button tooltip-examples" title="Refresh" onclick="popupMenuRefreshClient.ShowAtElement(this)"></i>
                                            <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" style="display: none"></i>
                                            <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Share Leads" onclick="var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;AspxPopupShareleadClient.SetContentUrl(url);AspxPopupShareleadClient.Show();"></i>
                                            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLeadInfo()"></i>
                                        </li>
                                    </ul>
                                    <div class="tab-content">
                                        <uc1:PropertyInfo runat="server" ID="PropertyInfo" />
                                        <div class="tab-pane clearfix" id="home_owner">
                                            <dx:ASPxCallbackPanel runat="server" ID="ownerInfoCallbackPanel" ClientInstanceName="ownerInfoCallbackPanel" OnCallback="ownerInfoCallbackPanel_Callback" Height="850px" ScrollBars="Auto" Paddings-Padding="0px">
                                                <PanelCollection>
                                                    <dx:PanelContent>
                                                        <div style="padding: 20px 20px 0px 20px">
                                                            <table style="width: 100%; margin: 0px; padding: 0px;">
                                                                <tr>
                                                                    <td style="width: 50%; vertical-align: top">
                                                                        <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo2" />
                                                                    </td>
                                                                    <td style="vertical-align: top">
                                                                        <uc1:HomeOwnerInfo runat="server" ID="HomeOwnerInfo3" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </dx:PanelContent>
                                                </PanelCollection>
                                            </dx:ASPxCallbackPanel>
                                        </div>
                                        <div class="tab-pane " id="documents">
                                            <uc1:DocumentsUI runat="server" ID="DocumentsUI" />
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
                                        </Items>
                                        <%--<ItemTemplate>
                                            <div style="width:200px">
                                                <i class="fa <%# Container.Item.ItemStyle.CssClass %>"></i> <%# Container.Item.Text %>
                                            </div>
                                        </ItemTemplate>--%>
                                        <%--disable the width by steven--%>
                                        <%--<ItemStyle Width="143px"></ItemStyle>--%>
                                        <%------end------%>
                                        <ClientSideEvents ItemClick="OnPhoneNumberClick" />
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
                    <dx:SplitterPane ShowCollapseForwardButton="True" Name="LogPanel" MinSize="645px">
                        <Panes>
                            <dx:SplitterPane ShowCollapseBackwardButton="True" PaneStyle-BackColor="#f9f9f9">
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
                                                    <i class="fa fa-calendar-o sale_head_button tooltip-examples" title="Schedule" onclick="ASPxPopupScheduleClient.ShowAtElement(this);"></i>
                                                    <i class="fa fa-phone sale_head_button sale_head_button_left tooltip-examples" title="Call Back" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                                    <i class="fa fa-sign-in  sale_head_button sale_head_button_left tooltip-examples" title="Door Knock" onclick="SetLeadStatus(4)"></i>
                                                    <i class="fa fa-list-ol sale_head_button sale_head_button_left tooltip-examples" title="Hot Leads" onclick="SetLeadStatus(5)"></i>
                                                    <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                                </li>
                                            </ul>
                                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" />
                                        </div>

                                        <%--  <div id="divLeftContent" style="width: 100%; height: 100%; float: left">
                                            <div style="text-align: right; float: right; margin-bottom: -21px; z-index: 100; margin-right: 15px; position: relative;">
                                                <dx:ASPxButton Text="Schedule" UseSubmitBehavior="false" FocusRectPaddings-PaddingLeft="0" FocusRectPaddings-PaddingRight="0" Paddings-PaddingLeft="0" Paddings-PaddingRight="0" ID="ASPxButton2" Image-Url="/images/upcomming.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/upcomming.jpg"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(s,e){ASPxPopupScheduleClient.ShowAtElement(s.GetMainElement());}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Follow Up" UseSubmitBehavior="false" ID="btnCallBack" Image-Url="/images/callback.png" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/callback.png"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="OnCallBackButtonClick" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Door Knock" UseSubmitBehavior="false" Image-Url="/images/door_knocks.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />

                                                    <Image Height="16px" Width="16px" Url="/images/door_knocks.jpg"></Image>

                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){SetLeadStatus(4);}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Priority" UseSubmitBehavior="false" Image-Url="/images/priority.jpg" AutoPostBack="false" Image-Width="16px" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />

                                                    <Image Height="16px" Width="16px" Url="/images/priority.jpg"></Image>

                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){SetLeadStatus(5);}" />
                                                </dx:ASPxButton>
                                                <dx:ASPxButton Text="Print" UseSubmitBehavior="false" Image-Url="/images/imprimir.png" Image-Width="16px" AutoPostBack="false" Image-Height="16px" runat="server">
                                                    <FocusRectPaddings PaddingLeft="2" PaddingRight="2" />
                                                    <Image Height="16px" Width="16px" Url="/images/imprimir.png"></Image>
                                                    <Paddings PaddingLeft="2" PaddingRight="2" />
                                                    <ClientSideEvents Click="function(){PrintLogInfo(formlayoutActivityLogClient);}" />
                                                </dx:ASPxButton>
                                            </div>

                                        </div>--%>
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
                                            MaxWidth="800px" MaxHeight="800px" MinHeight="150px" MinWidth="150px" ID="pcMain"
                                            HeaderText="Select Date" Modal="true"
                                            runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl runat="server">
                                                    <asp:Panel ID="Panel1" runat="server">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <dx:ASPxCalendar ID="ASPxCalendar1" runat="server" ClientInstanceName="callbackCalendar" ShowClearButton="False" ShowTodayButton="False"></dx:ASPxCalendar>
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
                                                    <dx:ASPxCallbackPanel runat="server" ID="appointmentCallpanel" ClientInstanceName="appointmentCallpanel" OnCallback="appointmentCallpanel_Callback">
                                                        <PanelCollection>
                                                            <dx:PanelContent>
                                                                <dx:ASPxHiddenField runat="server" ID="HiddenFieldLogId" ClientInstanceName="hfLogIDClient"></dx:ASPxHiddenField>
                                                                <dx:ASPxFormLayout ID="formLayout" runat="server" Width="100%">
                                                                    <Items>
                                                                        <dx:LayoutItem Caption="Type">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxComboBox runat="server" Width="100%" DropDownStyle="DropDown" ID="cbScheduleType">
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
                                                                                    <dx:ASPxDateEdit runat="server" EditFormatString="g" Width="100%" ID="dateEditSchedule" ClientInstanceName="ScheduleDateClientCtr" TimeSectionProperties-Visible="True">
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
                                                                                    <dx:ASPxTextBox ID="txtLocation" runat="server" Width="100%" Text="In Office"></dx:ASPxTextBox>
                                                                                </dx:LayoutItemNestedControlContainer>
                                                                            </LayoutItemNestedControlCollection>
                                                                        </dx:LayoutItem>
                                                                        <dx:LayoutItem Caption="Manager">
                                                                            <LayoutItemNestedControlCollection>
                                                                                <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                                                    <dx:ASPxComboBox runat="server" Width="100%" ID="cbMgr">
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
                                                                                    <dx:ASPxMemo runat="server" ID="txtScheduleDescription" Width="100%" Height="180px" ClientInstanceName="ScheduleCommentsClientCtr"></dx:ASPxMemo>
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
                                        </dx:ASPxPopupControl>
                                    </dx:SplitterContentControl>
                                </ContentCollection>
                            </dx:SplitterPane>
                        </Panes>
                    </dx:SplitterPane>
                </Panes>
            </dx:ASPxSplitter>
            <dx:ASPxPopupControl ClientInstanceName="AspxPopupShareleadClient" Width="356px" Height="450px" ID="aspxPopupShareleads"
                HeaderText="Share Lead" Modal="true" ContentUrl="~/PopupControl/ShareLeads.aspx"
                runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
                <HeaderTemplate>
                    <div class="clearfix">
                        <div class="pop_up_header_margin">
                            <i class="fa fa-mail-forward with_circle pop_up_header_icon"></i>
                            <span class="pop_up_header_text">Share Lead</span>
                        </div>
                        <div class="pop_up_buttons_div">
                            <i class="fa fa-times icon_btn" onclick="AspxPopupShareleadClient.Hide()"></i>
                        </div>
                    </div>

                </HeaderTemplate>
            </dx:ASPxPopupControl>

            <dx:ASPxPopupControl ClientInstanceName="aspxPopupAddPhoneNum" Width="200px" Height="80px" ID="ASPxPopupControl2"
                HeaderText="Add Phone Number" ShowHeader="false"
                runat="server" EnableViewState="false" PopupHorizontalAlign="LeftSides" PopupVerticalAlign="Below" EnableHierarchyRecreation="True">

                <ContentCollection>
                    <dx:PopupControlContentControl>
                        <table>
                            <tr>
                                <td>Phone No.:</td>
                            </tr>
                            <tr style="padding-top: 3px;">
                                <td>
                                    <dx:ASPxTextBox runat="server" ID="txtPhoneNo" ClientInstanceName="txtPhoneNoClient"></dx:ASPxTextBox>
                                </td>
                            </tr>
                            <tr style="margin-top: 3px; line-height: 30px; margin-top: 10px">
                                <td>
                                    <div style="margin-top:10px">
                                        <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button rand-button-blue">
                                            <ClientSideEvents Click="SaveBestPhoneNo" />
                                        </dx:ASPxButton>
                                        &nbsp;
                                        <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false" CssClass="rand-button rand-button-gray">
                                            <ClientSideEvents Click="function(s,e){aspxPopupAddPhoneNum.Hide();}" />
                                        </dx:ASPxButton>
                                    </div>

                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>

        </dx:PanelContent>
    </PanelCollection>
    <ClientSideEvents EndCallback="OnEndCallback"></ClientSideEvents>
    <Border BorderStyle="None"></Border>

</dx:ASPxCallbackPanel>
