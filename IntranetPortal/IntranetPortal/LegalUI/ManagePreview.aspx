<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ManagePreview.aspx.vb" Inherits="IntranetPortal.ManagePreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div style="padding: 30px; color: #2e2f31; height: 100%">
        <div style="margin-bottom: 30px;">
            <i class="fa fa-search-plus title_icon color_gray"></i>
            <span class="title_text">Legal Preview</span>
        </div>
        <table>
            <tr>
                <td style="width: 120px">
                    <div class="form_head">Date</div>
                </td>
                <td><%= If(Me.SubmitedDate = DateTime.MinValue, "", Me.SubmitedDate.ToString("g"))%></td>
            </tr>
            <tr>
                <td>
                    <div class="form_head">Agent</div>
                </td>
                <td><%= Me.Applicant%></td>
            </tr>
            <tr>
                <td>
                    <div class="form_head">Case Name</div>
                </td>
                <td><%= Me.CaseName%></td>
            </tr>
            <tr>
                <td>
                    <div class="form_head">BBLE</div>
                </td>
                <td><%= Me.BBLE%></td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td></td>
            </tr>
            <tr>
                <td style="vertical-align: top">
                    <div class="form_head">Legal User</div>
                </td>
                <td>
                    <dx:ASPxListBox ID="lbLegalUser" runat="server" SelectionMode="Single" Width="250" Height="80">
                        <ValidationSettings RequiredField-IsRequired="true"></ValidationSettings>
                        <Columns>
                            <dx:ListBoxColumn Caption="Name" FieldName="Name" />
                            <dx:ListBoxColumn Caption="Total Cases" FieldName="Amount" />
                        </Columns>
                    </dx:ASPxListBox>
                    <%--<dx:ASPxRadioButtonList runat="server" ID="rblResearchUser"></dx:ASPxRadioButtonList>--%>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td></td>
            </tr>

            <tr>
                <td></td>
                <td>
                    <button type="submit" class="rand-button rand-button-pad bg_orange button_margin" runat="server" id="btnSubmit" onserverclick="btnSubmit_ServerClick">Submit</button>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
