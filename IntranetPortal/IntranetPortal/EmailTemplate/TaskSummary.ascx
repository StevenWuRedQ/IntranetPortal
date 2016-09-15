<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TaskSummary.ascx.vb" Inherits="IntranetPortal.TaskSummary" %>

<style type="text/css">
    .dark_bule_back {
        /*background: #234b60;*/
    }

    .orange_back {
        /*background: #ef7655;*/
        font-weight: 600;
    }

    body {
        font-family: Calibri 'Source Sans Pro';
    }

    /*.clearfix:before,
    .clearfix:after {
        display: table;
        content: " ";
    }

    .clearfix:after {
        clear: both;
    }*/

    .body_content {
        /*padding: 60px 70px;*/
    }

    .email_title {
        color: #234b60;
        font-size: 24px;
        font-family: Calibri;
        /*padding-bottom: 5px;*/
    }


    .body_margin {
        margin-top: 25px;
    }

    .email_list {
        /*list-style-type: none;
        padding: 0px;*/
    }

    .email_item {
        /*margin-top: 25px;*/
        font-family: Calibri;
        padding: 15px 10px 5px 10px;
        border: 1px solid #eee;
        border-radius: 5px;
        box-shadow: 2px 5px 9px 0px rgba(50, 50, 50, 0.4);
    }

    .email_link {
        cursor: pointer;
        color: #3993c1;
        font-size: 14px;
        font-family: Calibri;
    }

        .email_link:visited {
            color: gray;
        }

    .lead_message {
        font-size: 14px;
        color: #77787b;
        font-family: Calibri;
    }

    .lead_alert {
        font-size: 12px;
        color: #ef7655;
        font-family: Calibri;
    }

    .lead_text_margin {
        margin-top: 10px;
    }

    .lead_user_sign {
        text-align: right;
        color: #b2b5b9;
        font-size: 12px;
        font-family: Calibri;
    }

    .font_black {
        font-weight: 900;
        color: #2e2f31;
        font-family: Calibri;
    }

    .email_content {
        /*padding: 0px 30px;*/
        border-bottom: 2px solid #eee;
        /*padding-bottom: 30px;*/
    }

    .index_bullet {
        color: black;
        font-size: 18px;
        font-family: Calibri;
        /*padding: 8px 14px;
        border-radius: 52px;*/
    }

    .alert_margin {
        /*margin-left: 5px;*/
    }
</style>

<table width="800" bgcolor="#f5f5f5" style="font-family: Calibri">
    <tr>
        <td style="padding: 50px 100px">
            <table width="100%" bgcolor="#234b60">
                <tr>
                    <td style="padding-top: 20px; padding-left: 40px; height: 115px;">
                        <img alt="logo" src="http://portal.myidealprop.com/Images/logo@2x.png" />
                    </td>
                    <td width="220" style="padding-right: 20px; padding-top: 34px">
                        <table width="100%">
                            <tr>
                                <td>
                                    <img src="http://portal.myidealprop.com/images/reminder.png" alt="Reminder" />
                                </td>
                                <td>
                                    <span style="font-weight: 200; margin-left: 5px; color: white; font-size: 30px;">Reminders</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

            <table width="100%" bgcolor="white">
                <tr>
                    <td style="padding: 80px 70px 60px 70px">
                        <div>
                            <span style="color: #999999">You have <span style="color: #ef7655; font-size: 28px; font-weight: 300"><%# TaskCount%></span> outstanding reminders or tasks.</span>
                        </div>
                    </td>
                </tr>
            </table>
            <table width="100%" bgcolor="#f8f8f8" style="border: 2px solid #eeeeee; border-left-width: 0px; border-right-width: 0px">
                <tr>
                    <td style="padding: 60px 70px">
                        <div style="font-style: italic; color: #2b586f">
                            <div>Dear  <%# DestinationUser%>,</div>
                            <div class="body_margin">
                                Below are the outstanding reminders or tasks that are in your queue. Please review and complete them.
                            </div>
                            <div class="body_margin">
                                Regards,<br />
                                The Portal Team
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 60px 40px;" bgcolor="white">
                        <table width="100%">
                            <!-- appointment -->
                            <tr>
                                <td style="padding: 0px 30px; border-bottom: 2px solid #eee; padding-bottom: 30px;">
                                    <span class="email_title">Today's Appointment</span>
                                    <asp:Repeater runat="server" ID="rptAppointments" OnItemDataBound="rptAppointments_ItemDataBound">
                                        <HeaderTemplate>
                                            <br />
                                            <table width="100%">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td class="email_item">
                                                    <table style="width: 100%; font-family: Calibri">
                                                        <tr>
                                                            <td>
                                                                <span class="email_link"><a href='http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%# Eval("BBLE") %>'><%# Eval("Subject")%></a></span>
                                                            </td>
                                                            <td valign="top" style="width: 50px; padding-right: 10px" align="right" rowspan="3">
                                                                <span class="index_bullet" style="color: black; width: 50px"><%# container.ItemIndex +1 %>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="lead_message lead_text_margin" style="padding-top: 10px">
                                                                <%# Eval("Description")%>                                                                
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="padding-top: 10px" class="lead_alert">
                                                                <table style="font-family: Calibri">
                                                                    <tr>
                                                                        <td valign="top">
                                                                            <img alt="Time:" src="http://portal.myidealprop.com/images/EmailAlertMsg.png" />
                                                                        </td>
                                                                        <td class="lead_alert" style="padding-left: 5px;">
                                                                            <%# Eval("ScheduleDate", "{0:hh:mmtt}")%> - <%# Eval("EndDate","{0:hh:mmtt}")%>                                                                           
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" class="lead_user_sign lead_text_margin">
                                                                <span>Created by <span class="font_black"><%# Eval("Agent")%></span> on <%# Eval("CreateDate") %></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        <asp:Label ID="lblErrorMsg" runat="server" CssClass="lead_message" Text="No appointment today." Visible="false"></asp:Label>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </td>
                            </tr>
                            <!-- follow up -->
                            <tr>
                                <td style="padding: 10px 30px; border-bottom: 2px solid #eee; padding-bottom: 30px;">
                                    <span class="email_title">Today's FollowUp</span>&nbsp&nbsp;<span class="index_bullet" style='<%= if(followUpCount = 0, "display:none", "") %>'>(<%# followUpCount %>)</span>
                                    <asp:Repeater runat="server" ID="rptFollowUp" OnItemDataBound="rptFollowUp_ItemDataBound">
                                        <HeaderTemplate>
                                            <br />
                                            <br />
                                            <table width="100%">
                                                <tr>
                                                    <td class="email_item">
                                                        <table style="width: 100%">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <span class="email_link"><a href='http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%# Eval("BBLE") %>'><%# Eval("LeadsName")%></a></span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                </td>
                                                </tr>
                                            </table>                       
                                            <a class="email_link" href="http://portal.myidealprop.com">More...</a>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    <div>
                                        <asp:Label ID="lblNoFollowUp" runat="server" CssClass="lead_message" Text="No follow up today." Visible="false"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                            <!-- hot leads -->
                            <tr runat="server" visible="<%# hotCount > 0 %>">
                                <td style="padding: 10px 30px; border-bottom: 2px solid #eee; padding-bottom: 30px;">
                                    <span class="email_title">Hot Leads:</span>&nbsp&nbsp;
                                    <span class="index_bullet"> (<%# hotCount %>)</span>
                                    <asp:Repeater runat="server" ID="HotLeadsReapter">
                                        <HeaderTemplate>
                                            <br />
                                            <br />
                                            <table style="width: 100%">
                                                <tr>
                                                    <td class="email_item">
                                                        <table style="width: 100%">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <span class="email_link">
                                                        <a href='http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%# Eval("BBLE") %>'><%# Eval("LeadsName")%></a>
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>                       
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </td>
                            </tr>
                            <!-- loan mod -->
                            <tr runat="server" visible="<%# loanModCount > 0 %>">
                                <td style="padding: 10px 30px; border-bottom: 2px solid #eee; padding-bottom: 30px;">
                                    <span class="email_title">LoadMod Leads:</span>&nbsp&nbsp;
                                    <span class="index_bullet"> (<%# loanModCount %>)</span>
                                    <asp:Repeater runat="server" ID="LoanModReapter">
                                        <HeaderTemplate>
                                            <br />
                                            <br />
                                            <table style="width: 100%">
                                                <tr>
                                                    <td class="email_item">
                                                        <table style="width: 100%">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <span class="email_link">
                                                        <a href='http://portal.myidealprop.com/viewleadsinfo.aspx?id=<%# Eval("BBLE") %>'><%# Eval("LeadsName")%></a>
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>                       
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </td>
                            </tr>
                            <asp:Repeater runat="server" ID="rptWorklist" OnItemDataBound="rptWorklist_ItemDataBound">
                                <ItemTemplate>
                                    <tr>
                                        <td style="padding: 10px 30px; border-bottom: 2px solid #eee; padding-bottom: 30px;">
                                            <span class="email_title"><%# Eval("ProcSchemeDisplayName")%></span> &nbsp;&nbsp;<span class="index_bullet">(<%# Eval("Count")%>)</span>
                                            <asp:Repeater runat="server" ID="rptWorklistItem">
                                                <HeaderTemplate>
                                                    <br />
                                                    <br />
                                                    <table style="width: 100%">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td class="email_item">
                                                            <table style="width: 100%">
                                                                <tr>
                                                                    <td>
                                                                        <span class="email_link"><a href='http://portal.myidealprop.com<%# Eval("ItemData") %>'><%# Eval("DisplayName")%></a></span>
                                                                    </td>
                                                                    <td valign="top" style="width: 50px; padding-right: 10px" align="right" rowspan="2">
                                                                        <span class="dark_bule_back index_bullet"><%# container.ItemIndex +1 %>
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="lead_message lead_text_margin" style="padding-top: 10px">
                                                                        <%# Eval("Description")%>                                                           
                                                                    </td>
                                                                </tr>
                                                                <tr visible='<%# Eval("ShowPortalMsg")%>' runat="server">
                                                                    <td style="padding-top: 10px" class="lead_alert">
                                                                        <table>
                                                                            <tr>
                                                                                <td valign="top">
                                                                                    <img alt="Time:" src="http://portal.myidealprop.com/images/EmailAlertMsg.png" />
                                                                                </td>
                                                                                <td class="lead_alert" style="padding-left: 5px">
                                                                                    <%# Eval("PortalMsg")%>                                                                           
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="lead_user_sign lead_text_margin">
                                                                        <span>Created by <span class="font_black"><%# Eval("Originator")%></span>&nbsp;on&nbsp;<%# Eval("StartDate", "{0:g}") %></span>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="10"></td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                    </table>
                                                    <a class="email_link" href="http://portal.myidealprop.com">More...</a>
                                                </FooterTemplate>
                                            </asp:Repeater>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                </FooterTemplate>
                            </asp:Repeater>
                        </table>
                        <table style="width: 100%">
                            <tr>
                                <td style="text-align: center; color: #b2b5b9; font-size: 12px; font-family: Calibri; padding-top: 43px">This is an automatic email. Please do not reply.
                                </td>
                            </tr>
                        </table>
                        <div>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>


