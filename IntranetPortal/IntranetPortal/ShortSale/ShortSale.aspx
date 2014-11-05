<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSale.aspx.vb" Inherits="IntranetPortal.ShortSalePage" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/ShortSale/ShortSaleOverVew.ascx" TagPrefix="uc1" TagName="ShortSaleOverVew" %>
<%@ Register Src="~/ShortSale/TitleControl.ascx" TagPrefix="uc1" TagName="Title" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/ShortSale/SelectPartyUC.ascx" TagPrefix="uc1" TagName="SelectPartyUC" %>
<%@ Register Src="~/PopupControl/SendMail.ascx" TagPrefix="uc1" TagName="SendMail" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script src="/scripts/stevenjs.js"></script>

    <div style="background: url(/images/MyIdealProptery.png) no-repeat center fixed; background-size: 260px, 280px; background-color: #dddddd; width: 100%; height: 100%;">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="100%" Width="100%" ClientInstanceName="splitter" Orientation="Horizontal" FullscreenMode="true">
            <Panes>
                <dx:SplitterPane Name="leadPanel" ShowCollapseBackwardButton="True" MinSize="100px" MaxSize="400px" Size="280px" PaneStyle-Paddings-Padding="2px">
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl1" runat="server">
                            <%--<uc1:LeadsList runat="server" ID="LeadsList" />--%>
                            <uc1:ShortSaleCaseList runat="server" ID="ShortSaleCaseList" />                         
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane Name="contentPanel" ShowCollapseForwardButton="True" PaneStyle-BackColor="#f9f9f9" ScrollBars="Auto" PaneStyle-Paddings-Padding="0px">
                    <PaneStyle BackColor="#F9F9F9">
                    </PaneStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl ID="SplitterContentControl2" runat="server">
                            <dx:ASPxCallbackPanel runat="server" ID="ASPxCallbackPanel2" Height="100%" ClientInstanceName="ContentCallbackPanel"  OnCallback="ASPxCallbackPanel2_Callback" EnableCallbackAnimation="true" CssClass="LeadsContentPanel">
                                <PanelCollection>
                                    <dx:PanelContent ID="PanelContent1" runat="server">
                                        <dx:ASPxSplitter ID="contentSplitter" PaneStyle-BackColor="#f9f9f9" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter" ClientVisible="false">
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
                                                                </dx:ASPxPopupMenu>
                                                                <asp:HiddenField ID="hfBBLE" runat="server" />

                                                                <!-- Nav tabs -->
                                                                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                                                                    <li class="active short_sale_head_tab">
                                                                        <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                                                                            <i class="fa fa-info-circle head_tab_icon_padding"></i>
                                                                            <div class="font_size_bold">Overview</div>
                                                                        </a>
                                                                    </li>
                                                                    <li class="short_sale_head_tab">
                                                                        <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                                                                            <i class="fa fa-key head_tab_icon_padding"></i>
                                                                            <div class="font_size_bold">&nbsp;&nbsp;&nbsp;&nbsp;Title&nbsp;&nbsp;&nbsp;&nbsp;</div>
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
                                                                        <%--<i class="fa fa-comments sale_head_button tooltip-examples" title="Chat"></i>
                                                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Email"></i>--%>
                                                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Re-Assign" onclick="tmpBBLE=leadsInfoBBLE; popupCtrReassignEmployeeListCtr.PerformCallback();popupCtrReassignEmployeeListCtr.ShowAtElement(this);"></i>
                                                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Mail" onclick="ShowEmailPopup()"></i>                                                                        
                                                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick=""></i>
                                                                    </li>
                                                                </ul>
                                                                <uc1:SendMail runat="server" ID="SendMail" />
                                                                <div class="tab-content">
                                                                    <%--<uc1:PropertyInfo runat="server" ID="PropertyInfo" />--%>
                                                                    <div class="tab-pane active" id="property_info">
                                                                        <uc1:ShortSaleOverVew runat="server" ID="ShortSaleOverVew" />
                                                                    </div>
                                                                    <div class="tab-pane" id="home_owner">
                                                                        <uc1:Title runat="server" ID="ucTitle" />
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

                                                                    <%--<ClientSideEvents ItemClick="OnPhoneNumberClick" />--%>
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

                                                                    <%-- <ClientSideEvents ItemClick="OnAddressPopupMenuClick" />--%>
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
                                                                                <i class="fa fa-repeat sale_head_button tooltip-examples" title="Follow Up" onclick="LogClick('FollowUp')"></i>
                                                                               <%-- <i class="fa fa-file sale_head_button sale_head_button_left tooltip-examples" title="New File" onclick="LogClick('NewFile')"></i>
                                                                                <i class="fa fa-folder-open sale_head_button sale_head_button_left tooltip-examples" title="Active Cases" onclick="LogClick('Active')"></i>
                                                                                <i class="fa fa-sign-out  sale_head_button sale_head_button_left tooltip-examples" title="Eviction" onclick="LogClick('Eviction')"></i>--%>
                                                                                <i class="fa fa-pause sale_head_button sale_head_button_left tooltip-examples" title="On Hold" onclick="LogClick('OnHold')"></i>
                                                                                <i class="fa fa-check-circle sale_head_button sale_head_button_left tooltip-examples" title="Closed" onclick="LogClick('Closed')"></i>
                                                                                <i class="fa fa-print  sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                                                            </li>
                                                                        </ul>
                                                                        <uc1:ActivityLogs runat="server" ID="ActivityLogs" DispalyMode="ShortSale" />
                                                                    </div>
                                                                    
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
                                                                        <%--<ClientSideEvents ItemClick="OnCallbackMenuClick" />--%>
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
                                    </dx:PanelContent>
                                </PanelCollection>
                                <ClientSideEvents EndCallback="function(s,e){ GetShortSaleData(caseId);}" />
                            </dx:ASPxCallbackPanel>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </div>
    <uc1:SelectPartyUC runat="server" id="SelectPartyUC" />  
</asp:Content>


