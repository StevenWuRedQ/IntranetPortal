<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="EditHomeOwner.ascx.vb" Inherits="IntranetPortal.EditHomeOwner" %>
<script type="text/javascript">
    function SaveOwner()
    {
        var newOwner = cbHomeOwners.GetText();

        if(newOwner != "")
        {
            popupEditHomeOwner.PerformCallback('Change|' + newOwner);
        }
        else
        {
            popupEditHomeOwner.PerformCallback('Save');        
        }

        popupEditHomeOwner.Hide();
        if (typeof ownerInfoCallbackPanel != undefined) { ownerInfoCallbackPanel.PerformCallback(); }
    }
</script>

<dx:ASPxPopupControl ID="popupEditHomeOwner" runat="server" ClientInstanceName="popupEditHomeOwner"
    Width="600px" Height="400px" CloseAction="CloseButton" OnWindowCallback="popupEditHomeOwner_WindowCallback"
    Modal="true" ShowFooter="true" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-file with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Home Owner</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="popupEditHomeOwner.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="PopupContentHomeOwner" Visible="false">
            <asp:HiddenField ID="hfBBLE" runat="server" />
            <asp:HiddenField ID="hfOwnerName" runat="server" />
            <asp:HiddenField ID="hfOwnerData" runat="server" />
            <div class="popup_padding">
                <div class="clearence_list_text">
                    <table style="width:90%">
                        <tr>
                            <td style="width:50%">
                                <div class="clearence_list_title">
                                    Unique ID
                                </div>
                                <div class="clearence_list_text18  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtUniqueTLOID" style="width: 50%;">
                                    <input type="button" class="rand-button short_sale_edit bg_color_blue" style="margin-left: 25px" value="Load" onclick="popupEditHomeOwner.PerformCallback('Load');" id="btnLoad">
                                </div>
                            </td>
                            <td>
                                <div class="clearence_list_title">
                                    Pre-loaded Owners
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <dx:ASPxComboBox runat="server" ID="cbHoweOwners" Width="100%" Height="40px" Native="true" ClientInstanceName="cbHomeOwners" CssClass="ss_form_input"></dx:ASPxComboBox>
                                </div>
                            </td>
                        </tr>
                    </table>

                </div>
                <div class="clearence_list_text">
                    <div class="clearence_list_title">
                        OwnerName
                    </div>
                    <div class="clearence_list_text18  color_blue_edit">

                        <input class="ss_form_input" value="" runat="server" id="txtOwnerName" style="width: 90%">
                    </div>
                </div>
                <div class="clearence_list_text">
                    <table>
                        <tr>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Age
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <input class="ss_form_input" value="" runat="server" id="txtAge">
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Death Indicator
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <asp:RadioButtonList runat="server" ID="rblDeathIndicator" RepeatDirection="Horizontal" Width="90%">
                                        <asp:ListItem Text="Alive"></asp:ListItem>
                                        <asp:ListItem Text="Death"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </td>
                            <td class="clearence_table_td">
                                <div class="clearence_list_title">
                                    Bankruptcy
                                </div>
                                <div class="clearence_list_text14  color_blue_edit">
                                    <asp:RadioButtonList runat="server" ID="rblBankruptcy" RepeatDirection="Horizontal" Width="90%">
                                        <asp:ListItem Text="Yes"></asp:ListItem>
                                        <asp:ListItem Text="No"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="clearence_list_text">
                    <div class="clearence_list_title">
                        Description
                    </div>
                    <div class="clearence_list_text18  color_blue_edit">
                        <textarea class="ss_form_input" value="" runat="server" style="width: 90%; resize: none;" id="txtDescription" />
                    </div>
                </div>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <FooterContentTemplate>
        <div style="height: 40px; vertical-align: central; float: right; margin-right: 30px;">
            <input type="button" class="rand-button short_sale_edit bg_color_blue" value="Save" onclick="SaveOwner()" id="btnSend">
            <input type="button" class="rand-button short_sale_edit" style="background: #77787b" value="Cancel" onclick="popupEditHomeOwner.Hide()">
        </div>
    </FooterContentTemplate>
</dx:ASPxPopupControl>
