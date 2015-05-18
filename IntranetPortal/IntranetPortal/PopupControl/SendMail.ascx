<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SendMail.ascx.vb" Inherits="IntranetPortal.SendMailControl" %>
<script type="text/javascript">
    var loaded = false;
    var emailBBLE = null;
    var ShowEmail = false;

    function ShowEmailPopup(bble) {
        emailBBLE = bble;

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

        if (ShowEmail) {
            var attachFiles = txtAttachments.GetText();
            if (attachFiles != "") {
                var attachments = JSON.parse(attachFiles);
                var docIds = [];
                for (var key in attachments) {
                    attachmentHoder.appendChild(GetAttachmentElement(attachments[key]));
                    docIds.push(key);
                }

                txtAttachments.SetText(docIds.toString());
            }

            return;
        }

        if (typeof GetSelectedAttachment != undefined) {
            var attachments = GetSelectedAttachment();
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
    function SendMail() {
        if (!popupSendEmailClient.InCallback()) {

            if (emailBBLE != null) {
                var container = popupSendEmailClient.GetMainElement();
                if (ASPxClientEdit.ValidateEditorsInContainer(container)) {
                    sendingMail = true;
                    popupSendEmailClient.PerformCallback('SendMail|' + emailBBLE);
                }
            }
            else
                alert("Can't send mail without related property.")
        }
        else {
            alert("Server is busy. Please try later.");
        }
    }

    function SendMailEndCallback(s, e) {
        s.Show();
        if (ShowEmail) {
            document.getElementById("btnSend").style.display = "none";
            ShowEmail = false;
        }

        if (sendingMail) {
            alert("Your mail is sent.");
            sendingMail = false;
            s.Hide();

            if (typeof gridTrackingClient != 'undefined')
                gridTrackingClient.Refresh();

        }
    }

    function BindAttachments() {

    }

    function ShowMailmessage(mailId) {
        ShowEmail = true;
        popupSendEmailClient.PerformCallback("ShowMail|" + mailId);
    }

    function OnEmailSearch(key) {
        var firstIndex = 0;
        var listBox = emailListBox;
        for (var i = 0; i < listBox.GetItemCount() ; i++) {
            var text = listBox.GetItem(i).text;

            if (text.toLowerCase().search(key.toLowerCase()) == 0) {
                firstIndex = i;
                break;
            }
        }
        //alert(firstIndex);
        listBox.MakeItemVisible(firstIndex);
    }

    function OnEmailComboBoxSelectionChanged(listBox, args) {
        UpdateEmailText();
    }
    function UpdateEmailText() {
        var selectedItems = emailListBox.GetSelectedItems();
        emailCheckComboBox.SetText(GetSelectedItemsText(selectedItems));
    }

    function OnEmailCCSearch(key) {
        var firstIndex = 0;
        var listBox = emailCCListBox;
        for (var i = 0; i < listBox.GetItemCount() ; i++) {
            var text = listBox.GetItem(i).text;

            if (text.toLowerCase().search(key.toLowerCase()) == 0) {
                firstIndex = i;
                break;
            }
        }
        //alert(firstIndex);
        listBox.MakeItemVisible(firstIndex);
    }

    function OnEmailCCComboBoxSelectionChanged(listBox, args) {
        UpdateEmailCCText();
    }
    function UpdateEmailCCText() {
        var selectedItems = emailCCListBox.GetSelectedItems();
        EmailCCCheckComboBox.SetText(GetSelectedItemsText(selectedItems));
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
    Width="630px" Height="700px" CloseAction="CloseButton"
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
                            <%--<dx:ASPxTextBox ID="EmailToIDs" runat="server" CssClass="email_input">
                                <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="None"></ValidationSettings>
                            </dx:ASPxTextBox>--%>
                            <div style="margin-left: 15px;">
                                <dx:ASPxDropDownEdit ClientInstanceName="emailCheckComboBox" ID="EmailToIDs" Width="83%" runat="server" CssClass="edit_drop" AnimationType="None">
                                    <DropDownWindowStyle BackColor="#EDEDED" />
                                    <DropDownWindowTemplate>
                                        <dx:ASPxPageControl runat="server" TabPosition="Bottom" ID="tabPageEmailSelect" ActiveTabIndex="1" TabStyle-Height="35px" TabStyle-VerticalAlign="Middle">

                                            <TabPages>

                                                <dx:TabPage Text="Employees" Name="tabRecent">
                                                    <ContentCollection>
                                                        <dx:ContentControl runat="server">
                                                            <table style="width: 100%">
                                                                <tr>
                                                                    <td>
                                                                        <dx:ASPxTextBox runat="server" ID="txtTaskEmpSearch" CssClass="edit_drop" Width="100%" ClientInstanceName="txtTaskEmpSearchClient" NullText="Type Employees Name">
                                                                            <ClientSideEvents KeyDown="function(s,e){                                                                                                                                     
                                                                                                                                       OnEmailSearch(s.GetText());                                                                                                                                    
                                                                                                                                    }" />

                                                                        </dx:ASPxTextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <dx:ASPxListBox Width="100%" ID="lbEmails" Height="220px" ClientInstanceName="emailListBox" SelectionMode="CheckColumn"
                                                                runat="server">
                                                                <Border BorderStyle="None" />
                                                                <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                                                <ClientSideEvents SelectedIndexChanged="OnEmailComboBoxSelectionChanged" />
                                                            </dx:ASPxListBox>
                                                        </dx:ContentControl>
                                                    </ContentCollection>
                                                </dx:TabPage>
                                            </TabPages>
                                        </dx:ASPxPageControl>
                                        <div style="float: right; margin-top: -37px; display: block; margin-right: 3px;">
                                            <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" CausesValidation="false" Text="Close" Style="float: right" CssClass="rand-button rand-button-gray">
                                                <ClientSideEvents Click="function(s, e){ emailCheckComboBox.HideDropDown(); }" />
                                            </dx:ASPxButton>
                                        </div>
                                    </DropDownWindowTemplate>
                                    <ValidationSettings ErrorDisplayMode="None">
                                        <RequiredField IsRequired="true" />
                                    </ValidationSettings>
                                    <%-- <ClientSideEvents TextChanged="SynchronizeEmpListBoxValues" DropDown="SynchronizeEmpListBoxValues" />--%>
                                </dx:ASPxDropDownEdit>
                            </div>

                            <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <span class="font_12 color_gray upcase_text">CC</span>
                        </td>
                        <td>
                            <%--<dx:ASPxTextBox ID="EmailCCIDs" runat="server" CssClass="email_input"></dx:ASPxTextBox>--%>
                            <div style="margin-left: 15px;">
                                <dx:ASPxDropDownEdit ClientInstanceName="EmailCCCheckComboBox" ID="EmailCCIDs" Width="83%" runat="server" CssClass="edit_drop" AnimationType="None">
                                    <DropDownWindowStyle BackColor="#EDEDED" />
                                    <DropDownWindowTemplate>
                                        <dx:ASPxPageControl runat="server" TabPosition="Bottom" ID="tabPageEmailCCSelect" ActiveTabIndex="1" TabStyle-Height="35px" TabStyle-VerticalAlign="Middle">

                                            <TabPages>

                                                <dx:TabPage Text="Employees" Name="tabRecent">
                                                    <ContentCollection>
                                                        <dx:ContentControl runat="server">
                                                            <table style="width: 100%">
                                                                <tr>
                                                                    <td>
                                                                        <dx:ASPxTextBox runat="server" ID="txtCCEmpSearch" CssClass="edit_drop" Width="100%" ClientInstanceName="txtemailCCSearchClient" NullText="Type Employees Name">
                                                                            <ClientSideEvents KeyDown="function(s,e){                                                                                                                                     
                                                                                                                                       OnEmailCCSearch(s.GetText());                                                                                                                                    
                                                                                                                                    }" />

                                                                        </dx:ASPxTextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <dx:ASPxListBox Width="100%" ID="lbEmailCCs" Height="220px" ClientInstanceName="emailCCListBox" SelectionMode="CheckColumn"
                                                                runat="server">
                                                                <Border BorderStyle="None" />
                                                                <BorderBottom BorderStyle="Solid" BorderWidth="1px" BorderColor="#DCDCDC" />
                                                                <ClientSideEvents SelectedIndexChanged="OnEmailCCComboBoxSelectionChanged" />
                                                            </dx:ASPxListBox>
                                                        </dx:ContentControl>
                                                    </ContentCollection>
                                                </dx:TabPage>
                                            </TabPages>
                                        </dx:ASPxPageControl>
                                        <div style="float: right; margin-top: -37px; display: block; margin-right: 3px;">
                                            <dx:ASPxButton ID="ASPxButton1" AutoPostBack="False" runat="server" CausesValidation="false" Text="Close" Style="float: right" CssClass="rand-button rand-button-gray">
                                                <ClientSideEvents Click="function(s, e){ EmailCCCheckComboBox.HideDropDown(); }" />
                                            </dx:ASPxButton>
                                        </div>
                                    </DropDownWindowTemplate>
                                    <ValidationSettings ErrorDisplayMode="None">
                                        <RequiredField IsRequired="false" />
                                    </ValidationSettings>
                                    <%--<ClientSideEvents TextChanged="SynchronizeEmpListBoxValues" DropDown="SynchronizeEmpListBoxValues" />--%>
                                </dx:ASPxDropDownEdit>
                            </div>
                            <%--<asp:TextBox ID="ToTextBox" runat="server" CssClass="form-control"></asp:TextBox>--%>
                        </td>
                    </tr>

                    <tr>
                        <td align="right">
                            <span class="font_12 color_gray upcase_text">Subject</span>
                        </td>
                        <td>
                            <dx:ASPxTextBox ID="EmailSuject" runat="server" CssClass="email_input">
                                <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="None"></ValidationSettings>
                            </dx:ASPxTextBox>
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
                <div style="margin-top: 10px" class="html_edit_div">
                    <dx:ASPxHtmlEditor ID="EmailBody" runat="server" Height="300px" Width="100%">
                        <Settings AllowHtmlView="false" AllowPreview="false" AllowContextMenu="False" AllowInsertDirectImageUrls="false" />
                    </dx:ASPxHtmlEditor>
                </div>

                <div class="popup_btns">
                    <input type="button" class="rand-button short_sale_edit bg_color_blue" value="Send" onclick="SendMail()" id="btnSend">
                    <input type="button" class="rand-button short_sale_edit" style="background: #77787b" value="Cancel" onclick="popupSendEmailClient.Hide()">
                </div>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents EndCallback="SendMailEndCallback" PopUp="function(s,e){InitAttachments();}" />
</dx:ASPxPopupControl>

