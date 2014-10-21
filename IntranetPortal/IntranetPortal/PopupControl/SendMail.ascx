<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SendMail.ascx.vb" Inherits="IntranetPortal.SendMailControl" %>

<dx:ASPxPopupControl ID="PopupSendMail" runat="server" ClientInstanceName="popupSendEmailClient"
    Width="540px" Height="700px"
    MaxWidth="800px" MinWidth="150px"
    HeaderText="Set as Task" Modal="true"
    EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-envelope with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Email</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupSendEmailClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server"  ID="PopupContentSendMail">
            <table class="mail_edits">
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
                        <span class="font_12 color_gray upcase_text">CC</span>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="EmailCCIDs" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                        <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
                    </td>
                </tr>

                <tr>
                    <td align="right">
                        <span class="font_12 color_gray upcase_text">Subject</span>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="EmailSuject" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                        <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <span class="font_12 color_gray upcase_text">Attachment(s)</span>
                    </td>
                    <td>
                        <dx:ASPxTextBox ID="EmailAttachments" runat="server" CssClass="email_input"></dx:ASPxTextBox>
                        <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
                    </td>
                </tr>
            </table>
            <div style="margin-top:10px">
                <dx:ASPxHtmlEditor ID="EamilBody" runat="server" Height="25px" Width="100%"></dx:ASPxHtmlEditor>
            </div>
           
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

