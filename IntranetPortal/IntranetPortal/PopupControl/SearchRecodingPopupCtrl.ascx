<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="SearchRecodingPopupCtrl.ascx.vb" Inherits="IntranetPortal.SearchRecodingPopupCtrl" %>
<dx:ASPxPopupControl ID="SearchRecodingPopup" runat="server"
    ClientInstanceName="SearchRecodingPopupClient"
    Width="640" Height="780" 
    ContentUrl="/popupControl/SearchRecordingPopup.aspx"
    HeaderText="Email" Modal="true"  ShowFooter="true" 
    EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True" ContentStyle-Paddings-Padding="0" >
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-users with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Search Recoding</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="SearchRecodingPopupClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>

    <FooterContentTemplate>
        <div style="float: right; margin-right: 20px; margin-bottom: 10px;">
            <input style="margin-left: 20px;" type="button" class="rand-button rand-button-padding bg_color_blue" value="Ok" onclick="NGSelectPartry()">
            <input type="button" class="rand-button rand-button-padding bg_color_gray" value="Cancel" onclick="SearchRecodingPopupClient.Hide()">
        </div>
    </FooterContentTemplate>
</dx:ASPxPopupControl>