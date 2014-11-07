<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="VendorsPopup.ascx.vb" Inherits="IntranetPortal.VendorsPopup" %>

<dx:ASPxPopupControl ID="VendorsPopup" runat="server"
    ClientInstanceName="VendorsPopupClient"
    Width="1000" Height="730px" CloseAction="CloseButton"
    MaxWidth="1300" MinWidth="500"
    HeaderText="Email" Modal="true" AllowResize="true"
    EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
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
        <div style="float: right; margin-right: 20px; margin-top: 40px;">
            <input style="margin-left: 20px;" type="button" class="rand-button short_sale_edit bg_color_blue" value="Ok" onclick="">
            <input type="button" class="rand-button short_sale_edit bg_color_gray" value="Cancel" onclick="">
        </div>
    </FooterContentTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="VendorsPopupContent">
          

        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>
<script>
    VendorsPopupClient.SetContentUrl("/PopupControl/VendorsPopUpContent.aspx");
</script>