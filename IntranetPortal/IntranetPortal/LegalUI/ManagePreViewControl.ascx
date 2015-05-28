<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ManagePreViewControl.ascx.vb" Inherits="IntranetPortal.ManagePreViewControl" %>
<%@ Register TagPrefix="uc1" TagName="LegalSecondaryActions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
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
                
                    <div style="width:600px">
                        
                        <div>

                            <h4 class="ss_form_title">Description</h4>
                            <textarea class="edit_text_area" ng-model="LegalCase.Description" style="height: 100px; width: 100%"></textarea>
                        </div>
                        <uc1:LegalSecondaryActions runat="server" ID="LegalSecondaryActions" />
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
                <dx:ASPxListBox ID="lbLegalUser" runat="server" SelectionMode="Single" Width="250" Height="80" CssClass="table table-striped">
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
