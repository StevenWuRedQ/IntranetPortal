<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionUI.aspx.vb" EnableEventValidation="false" Inherits="IntranetPortal.ConstructionUI" MasterPageFile="~/Content.Master" %>


<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/Construction/ConstructionCaseList.ascx" TagPrefix="uc1" TagName="ConstructionCaseList" %>


<%@ Register Src="~/Construction/ConstructionUICtrl.ascx" TagPrefix="uc1" TagName="ConstructionUICtrl" %>



<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">

    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
        <Panes>
            <%-- list panel  --%>
            <dx:SplitterPane Name="listPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="0" >
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
            <dx:SplitterPane  ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" ScrollBars="None" PaneStyle-Paddings-Padding="0px" Name="dataPane" >
                <PaneStyle>
                    <Paddings Padding="0px"></Paddings>
                </PaneStyle>
                <ContentCollection>
                    <dx:SplitterContentControl>
                        <uc1:ConstructionUICtrl runat="server" ID="ConstructionUICtrl" />
                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <%-- log panel --%>
            <dx:SplitterPane ShowCollapseBackwardButton="True" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" PaneStyle-Paddings-Padding="0px" Name="LogPanel">
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
                                    <i class="fa fa-chevron-circle-left sale_head_button sale_head_button_left tooltip-examples" title="Intake" onclick="ChangeStatus(0)" data-original-title="Intake"></i>
                                    <i class="fa fa-chevron-circle-right sale_head_button sale_head_button_left tooltip-examples" title="Construction" onclick="popupSelectOwner.PerformCallback('Show|1');popupSelectOwner.ShowAtElement(this);" data-original-title="Construction"></i>
                                    <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Completed" onclick="ChangeStatus(2)" data-original-title="Completed"></i>
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

                                function ChangeStatus(status) {
                                    angular.element(document.getElementById('ConstructionCtrl')).scope().ChangeStatus(
                                        function () {
                                            alert("Success");
                                            if (typeof gridTrackingClient != "undefined") {
                                                gridTrackingClient.Refresh();
                                            }

                                            if (typeof gridCase != "undefined") {
                                                gridCase.Refresh();
                                            }
                                        }, status);
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
                                                <td style="color: #666666; font-size: 10px; -ms-align-content: center; -webkit-align-content: center; align-content: center; text-align: center; padding-top: 2px;">
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



</asp:Content>
