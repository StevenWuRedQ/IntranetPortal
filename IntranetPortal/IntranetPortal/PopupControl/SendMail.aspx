<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SendMail.aspx.vb" Inherits="IntranetPortal.SendMailPage" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server" ID="contentMain">
    

   
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
