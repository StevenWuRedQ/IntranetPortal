<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PreAssignPopup.ascx.vb" Inherits="IntranetPortal.PerAssignPopup" %>
<dx:ASPxPopupControl ID="preAssignPopop" runat="server"
    ClientInstanceName="preAssignPopopClient"
    Width="600px" Height="600px" ContentUrl="~/NewOffer/HomeownerIncentive.aspx?popup=true"
    Modal="true"  EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa  fa-hand-o-right with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text">Pre Sign</span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="preAssignPopopClient.Hide()"></i>
            </div>
        </div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server" ID="perAssginPopUp">

        </dx:PopupControlContentControl>
    </ContentCollection>

</dx:ASPxPopupControl>
