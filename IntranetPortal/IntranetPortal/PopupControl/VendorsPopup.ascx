<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VendorsPopup.ascx.vb" Inherits="IntranetPortal.VendorsPopup" %>

<dx:ASPxPopupControl ID="VendorsPopup" runat="server"
    ClientInstanceName="VendorsPopupClient"
    Width="1050" Height="730px" 
    ContentUrl="/PopupControl/VendorsPopUpContent.aspx"
    HeaderText="Email" Modal="true"  ShowFooter="true" 
    EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True" ContentStyle-Paddings-Padding="0">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-users with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Vendors</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="VendorsPopupClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>

    <FooterContentTemplate>
        <div style="float: right; margin-right: 20px; margin-bottom: 10px;">
            <input style="margin-left: 20px;" type="button" class="rand-button rand-button-padding bg_color_blue" value="Ok" onclick="NGSelectPartry()">
            <input type="button" class="rand-button rand-button-padding bg_color_gray" value="Cancel" onclick="VendorsPopupClient.Hide()">
        </div>
    </FooterContentTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="VendorsPopupContent">
          

        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
