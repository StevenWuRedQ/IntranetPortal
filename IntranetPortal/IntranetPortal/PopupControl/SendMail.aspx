<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SendMail.aspx.vb" Inherits="IntranetPortal.SendMailPage" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server" ID="contentMain">
    <%--onclick="popupSendEmailClient.ShowAtElement(this)"--%>

    <%--   <HeaderTemplate>
            <div class="clearfix">
                <div class="pop_up_header_margin">
                    <i class="fa fa-envelope with_circle pop_up_header_icon"></i>
                    <span class="pop_up_header_text">Email</span>
                </div>
                <div class="pop_up_buttons_div">
                    <i class="fa fa-times icon_btn" onclick="popupSendEmailClient.Hide()"></i>
                </div>
            </div>
        </HeaderTemplate>--%>
    <table>
        <tr>
            <td align="right">
                <span class="font_12 color_gray upcase_text">TO</span>
            </td>
            <td>
                <dx:ASPxTextBox ID="EmailToIDs" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
            </td>


        </tr>
        <tr>
            <td align="right">
                <span class="font_12 color_gray upcase_text">TO</span>
            </td>
            <td>
                <dx:ASPxTextBox ID="EmailCCIDs" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
            </td>
        </tr>

        <tr>
            <td align="right">
                <span class="font_12 color_gray upcase_text">TO</span>
            </td>
            <td>
                <dx:ASPxTextBox ID="EmailSuject" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
            </td>
        </tr>
        <tr>
            <td align="right">
                <span class="font_12 color_gray upcase_text">TO</span>
            </td>
            <td>
                <dx:ASPxTextBox ID="EmailAttachments" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
            </td>
        </tr>
    </table>

</asp:Content>
