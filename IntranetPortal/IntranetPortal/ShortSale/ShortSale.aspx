<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShortSale.aspx.vb" Inherits="IntranetPortal.ShortSalePage" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/LeadsList.ascx" TagPrefix="uc1" TagName="LeadsList" %>
<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/ShortSale/ShortSaleOverVew.ascx" TagPrefix="uc1" TagName="ShortSaleOverVew" %>
<%@ Register Src="~/ShortSale/TitleControl.ascx" TagPrefix="uc1" TagName="Title" %>
<%@ Register Src="~/ShortSale/ShortSaleCaseList.ascx" TagPrefix="uc1" TagName="ShortSaleCaseList" %>
<%@ Register Src="~/ShortSale/SelectPartyUC.ascx" TagPrefix="uc1" TagName="SelectPartyUC" %>


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
                                                                    <%-- <ClientSideEvents ItemClick="OnRefreshMenuClick" />--%>
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
                                                                        <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a">
                                                                            <i class="fa fa-file head_tab_icon_padding"></i>
                                                                            <div class="font_size_bold">Documents</div>
                                                                        </a>

                                                                    </li>

                                                                    <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
                                                                    <li style="margin-right: 30px; color: #ffa484; float: right">
                                                                        <i class="fa fa-comments sale_head_button tooltip-examples" title="Chat"></i>
                                                                        <i class="fa fa-envelope sale_head_button sale_head_button_left tooltip-examples" title="Email"></i>
                                                                        <i class="fa fa-mail-forward  sale_head_button sale_head_button_left tooltip-examples" title="Report" onclick="var url = '/PopupControl/ShareLeads.aspx?bble=' + leadsInfoBBLE;AspxPopupShareleadClient.SetContentUrl(url);AspxPopupShareleadClient.Show();"></i>
                                                                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLeadInfo()"></i>
                                                                    </li>
                                                                </ul>
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
                                                                <uc1:SelectPartyUC runat="server" id="SelectPartyUC" />
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
                                                                                <i class="fa fa-sun-o sale_head_button sale_head_button_left tooltip-examples" title="Hot Leads" onclick="SetLeadStatus(1)"></i>
                                                                                <i class="fa fa-rotate-right sale_head_button sale_head_button_left tooltip-examples" title="Follow Up" onclick="ASPxPopupMenuClientControl.ShowAtElement(this);"></i>
                                                                                <i class="fa fa-sign-in  sale_head_button sale_head_button_left tooltip-examples" title="Door Knock" onclick="SetLeadStatus(4)"></i>
                                                                                <i class="fa fa-refresh sale_head_button sale_head_button_left tooltip-examples" title="In Process" onclick="SetLeadStatus(5)"></i>
                                                                                <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLogInfo()"></i>
                                                                            </li>
                                                                        </ul>
                                                                        <uc1:ActivityLogs runat="server" ID="ActivityLogs" />
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
    <div class="clearfix" style="width: 980px; height: 980px; display: none">
        <%--left div--%>
        <div style="width: 310px; color: #999ca1; position: relative" class="agent_layout_float">
            <%--top block--%>
            <div>
                <div style="margin: 30px 20px 30px 30px">
                    <div style="font-size: 24px;" class="clearfix">
                        <i class="fa fa-folder-open with_circle" style="width: 48px; height: 48px; line-height: 48px;"></i>&nbsp;&nbsp;<span style="color: #234b60; font-size: 30px;">Cases</span>
                        <i class="fa fa-sort-amount-desc icon_right_s"></i>
                    </div>

                    <div style="margin-top: 27px; height: 290px; /*background: blue*/">
                        <ul style="margin-left: -40px; margin-top: 10px;">
                            <li class="employee_list_item employee_list_item_no_broder">
                                <div class="employee_list_item_div">
                                    <span class="font_black">1072 DE KALB AVE </span>
                                    - 1072 DEKALB AVENUE LLC
                                </div>
                                <i class="fa fa-list-alt employee_list_item_icon"></i>
                            </li>
                            <li class="employee_list_item employee_list_item_no_broder">
                                <div class="employee_list_item_div">
                                    <span class="font_black">1089 DE KALB AVE </span>
                                    - 1089 DEKALB AVE TRUST
                                </div>
                                <i class="fa fa-list-alt employee_list_item_icon"></i>
                            </li>
                            <li class="employee_list_item employee_list_item_no_broder">
                                <div class="employee_list_item_div">
                                    <span class="font_black">123 ST  </span>
                                    - 1072 DEKALB AVENUE LLC
                                </div>
                                <i class="fa fa-list-alt employee_list_item_icon"></i>
                            </li>
                            <li class="employee_list_item employee_list_item_no_broder">

                                <div class="employee_list_item_div">
                                    <span class="font_black">3023 BELL  </span>
                                    - 1089 DEKALB AVE TRUST
                                </div>
                                <i class="fa fa-list-alt employee_list_item_icon"></i>
                            </li>
                        </ul>

                    </div>
                </div>
            </div>
            <%----end top block----%>

            <%-----buttom infos--%>
            <div style="position: absolute; bottom: 0; padding-left: 32px; margin-bottom: 100px">
                <%-- margin-bottom:30px--%>
                <div style="position: relative; float: left">
                    <table>
                        <tr>
                            <td>
                                <div class="priority_info_label priority_info_lable_org">
                                    <span class="font_black">1,796 </span><span class="font_extra_light">Leads</span>
                                </div>
                            </td>
                            <td>
                                <div class="priority_info_label priority_info_label_blue" style="float: left; margin-left: 5px;">
                                    <span class="font_black">0 </span><span class="font_extra_light">Deals</span>
                                </div>
                            </td>
                        </tr>
                    </table>

                </div>
            </div>
            <%-----end-----%>
        </div>
        <%--splite bar--%>
        <div class="agent_layout_float" style="background: #e7e9ee; width: 10px;"></div>
        <%--short sale content--%>
        <div style="width: 660px;" class="agent_layout_float">
            <div style="width: 660px; font-family: 'Source Sans Pro'">
                <%--head tabs and buttoms--%>
                <div style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                    <div class="short_sale_head_tab">
                        <i class="fa fa-info-circle head_tab_icon_padding"></i>
                        <div class="font_size_bold">Overview</div>
                    </div>
                    <div class="short_sale_head_tab">
                        <i class="fa fa-key head_tab_icon_padding"></i>
                        <div class="font_size_bold">Title</div>

                    </div>
                    <div class="short_sale_head_tab">
                        <i class="fa fa-file head_tab_icon_padding"></i>
                        <div class="font_size_bold">Documents</div>
                    </div>
                    <div class="short_sale_head_tab " style="width: 200px; margin-left: 55px; text-align: left; color: #ffa484">
                        <i class="fa fa-refresh sale_head_button"></i>
                        <i class="fa fa-envelope sale_head_button sale_head_button_left"></i>
                        <i class="fa fa-share sale_head_button sale_head_button_left"></i>
                        <i class="fa fa-print sale_head_button sale_head_button_left"></i>
                    </div>
                </div>
                <%--refresh label--%>
                <div style="margin: 30px 20px; height: 30px; background: #ffefe4; color: #ff400d; border-radius: 15px; font-size: 14px; line-height: 30px;">
                    <i class="fa fa-spinner fa-spin" style="margin-left: 30px"></i>
                    <span style="padding-left: 22px">Lead is being updated, it will take a few minutes to complete.</span>
                </div>
                <%--time label--%>
                <div style="height: 80px; font-size: 30px; margin-left: 30px;" class="font_gray">
                    <div style="font-size: 30px">
                        <i class="fa fa-refresh"></i>
                        <span style="margin-left: 19px;">Jun 9, 2014 1:12 PM</span>
                    </div>
                    <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">Started on June 2, 2014 6:37 PM</span>
                </div>

                <%--note list--%>
                <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
                    <div class="note_item">
                        <i class="fa fa-exclamation-circle note_img"></i>
                        <span class="note_text">Water Lien is High - Possible Tenant Issues</span>
                    </div>
                    <div class="note_item" style="background: #e8e8e8">
                        <i class="fa fa-exclamation-circle note_img"></i>
                        <span class="note_text">Property Has Approx $150,000 Equity</span>
                    </div>
                    <div class="note_item" style="border-left: 5px solid #ff400d">

                        <i class="fa fa-exclamation-circle note_img" style="margin-left: 25px;"></i>
                        <span class="note_text">Property Has Approx 3,124 Unbuilt Sqft</span>
                        <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7"></i>
                        <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7"></i>

                    </div>
                    <div class="note_item" style="background: white">
                        <i class="fa fa-plus-circle note_img" style="color: #3993c1"></i>
                    </div>
                </div>

                <%--tabs--%>
                <div style="height: 40px; font-weight: 600; margin-top: 17px; font-size: 16px">
                    <div class="short_sale_buttom_tab">Summary</div>
                    <div class="short_sale_buttom_tab" style="border-color: #ff400d">Property Info</div>
                    <div class="short_sale_buttom_tab">Mortgages</div>
                    <div class="short_sale_buttom_tab">Homewoner</div>
                    <div class="short_sale_buttom_tab">Eviction</div>
                    <div class="short_sale_buttom_tab">Parties</div>
                </div>
                <%--edit buttom--%>
                <div style="height: 40px">
                    <div style="width: 50px; height: 32px; border-radius: 16px; font-size: 12px; cursor: pointer; text-align: center; line-height: 32px; float: right; margin-right: 20px; margin-top: 10px; background: #99bdcf; color: white">Edit</div>
                </div>

                <%--property form--%>
                <div style="margin: 20px">
                    <div class="form_head">Property</div>


                    <div class="form_div_node">
                        <span class="form_input_title">Street Number</span>

                        <input class="text_input" value="151-04" />
                    </div>
                    <div class="form_div_node form_div_node_margin">
                        <span class="form_input_title">Street name</span>

                        <input class="text_input" value="Main St" />
                    </div>
                    <div class="form_div_node form_div_node_margin">
                        <span class="form_input_title">City</span>

                        <input class="text_input" value="Flushing" />
                    </div>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title">STATE</span>

                        <input class="text_input" value="NY" />
                    </div>
                    <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                        <span class="form_input_title">Zip</span>

                        <input class="text_input" value="11367" />
                    </div>
                    <div style="width: 255px; float: left"></div>
                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title">BLOCK</span>

                        <input class="text_input" value="3341" />
                    </div>
                    <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                        <span class="form_input_title">lot</span>
                        <asp:TextBox ID="TextBox1" CssClass="text_input" runat="server"></asp:TextBox>
                        <%--<input class="text_input" value="72"/>--%>
                    </div>

                    <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                        <span class="form_input_title">buiding type</span>

                        <%--<input class="text_input" type="reset" />--%>
                        <select class="text_input">
                            <option value="volvo" class="text_input">House</option>
                            <option value="saab" class="text_input">APT</option>
                            <option value="opel" class="text_input">Type3</option>
                            <option value="audi" class="text_input">Type4</option>
                        </select>
                    </div>

                    <div class="form_div_node form_div_node_line_margin">
                        <span class="form_input_title"># of stories</span>

                        <input class="text_input" value="1" />
                    </div>
                    <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                        <span class="form_input_title"># of unit</span>

                        <input class="text_input" value="2" />
                    </div>

                    <div class="form_div_node form_div_node_line_margin form_div_node_margin">
                        <span class="form_input_title" style="font-weight: 900">accessibitlity</span>
                        <select class="text_input">
                            <option value="volvo" class="text_input">Lockbox-LOC</option>
                            <option value="saab" class="text_input">Type2</option>
                            <option value="opel" class="text_input">Type3</option>
                            <option value="audi" class="text_input">Type4</option>
                        </select>
                    </div>
                    <div class="form_div_node form_div_node_line_margin form_div_radio_grup">
                        <span class="form_input_title">c/o (<span style="color: #0e9ee9">PDF</span>)</span><br />
                        <%--class="circle-radio-boxes"--%>

                        <input type="radio" id="sex" name="sex" value="Fannie" />
                        <label for="sex" class=" form_div_radio_group" style="padding-top: 4px;">
                            <span class="form_span_group_text">Yes</span>
                        </label>
                        <input type="radio" id="sexf" name="sex" value="FHA" style="margin-left: 66px" />
                        <label for="sexf" class=" form_div_radio_group form_div_node_margin">
                            <span class="form_span_group_text">No</span>
                        </label>
                        <%--<input type="radio" id="sex" name="sex" value="male" /><label for="sex" class="form_span_group_text form_div_radio_group">Yes</label>
                                <input type="radio" id="sexf" name="sex" value="female" style="margin-left: 66px" /><label for="sexf" class=" form_div_node_margin">No</label>--%>
                    </div>

                </div>
            </div>
        </div>
        <%--------end---------%>
    </div>
</asp:Content>


