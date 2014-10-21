﻿<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SendMail.ascx.vb" Inherits="IntranetPortal.SendMailControl" %>
<script type="text/javascript">
    var loaded = false;
    function ShowEmailPopup() {
        if (!loaded) {
            popupSendEmailClient.PerformCallback("Show");
            //loaded = true;
        }
        else {
            popupSendEmailClient.Show();
        }
    }

    function InitAttachments() {
        var attachmentHoder = document.getElementById("divAttachment");

        attachmentHoder.innerHTML = "";
        if (typeof GetSelectedAttachment != undefined) {
            attachments = GetSelectedAttachment();
            var docIds = [];

            for (var i = 0; i < attachments.length; i++) {
                var att = attachments[i];
                attachmentHoder.appendChild(GetAttachmentElement(att.Name));
                docIds.push(att.UniqueId);
            }

            txtAttachments.SetText(docIds.toString());
        }
    }

    function GetAttachmentElement(fileName) {
        var span = document.createElement("span");
        span.className = "dxeTextBox_MetropolisBlue1 AttachmentSpan"
        span.innerHTML = fileName;

        return span;
    }

    var sendingMail = false;
    function SendMail()
    {
        if (!popupSendEmailClient.InCallback())
        {
            sendingMail = true;
            popupSendEmailClient.PerformCallback('SendMail');           
        }            
        else
        {
            alert("Server is busy. Please try later.");
        }
    }

    function SendMailEndCallback(s,e)
    {
        s.Show();

        if(sendingMail)
        {
            alert("Your mail is sent.");
            sendingMail = false;
        }
    }

</script>

<style>
    .AttachmentSpan {
        margin-left: 10px;
        border: 1px solid #efefef;
        padding: 3px 20px 3px 10px;
        background-color: #ededed;
    }
</style>

<dx:ASPxPopupControl ID="PopupSendMail" runat="server" ClientInstanceName="popupSendEmailClient"
    Width="560px" Height="700px" CloseAction="CloseButton"
    MaxWidth="800px" MinWidth="150px" OnWindowCallback="PopupSendMail_WindowCallback"
    HeaderText="Email" Modal="true" AllowResize="true"
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
        <dx:PopupControlContentControl runat="server" ID="PopupContentSendMail" Visible="false">          
            <div class="clearfix">
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
                            <dx:ASPxTextBox ID="EmailAttachments" ClientInstanceName="txtAttachments" runat="server" CssClass="email_input" ClientVisible="false"></dx:ASPxTextBox>
                            <div id="divAttachment" style="margin-left: 15px"></div>
                        </td>
                    </tr>
                </table>
                <div style="margin-top: 10px">
                    <dx:ASPxHtmlEditor ID="EmailBody" runat="server" Height="300px" Width="100%"></dx:ASPxHtmlEditor>
                </div>

                <div class="popup_btns">                  
                    <input type="button" class="rand-button short_sale_edit bg_color_blue" value="Send" onclick="popupSendEmailClient.PerformCallback('SendMail')">
                    <input type="button" class="rand-button short_sale_edit" style="background: #77787b" value="Cancel" onclick="popupSendEmailClient.Hide()">
                </div>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents Shown="function(s,e){}" EndCallback="SendMailEndCallback" PopUp="function(s,e){InitAttachments();}" />
</dx:ASPxPopupControl>

