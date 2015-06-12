<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="Common.ascx.vb" Inherits="IntranetPortal.Common" %>
<script type="text/javascript">

    var commonTmpBBLE = null;
    function ShowPopupLeadsMenu(s, bble) {
        commonTmpBBLE = bble;
        popupMenuLeads.ShowAtElement(s);
    }

    function OnPopupMenuLeadsClick(s, e) {
        if (e.item.name == "Leads") {
            OpenLeadsWindow("/ViewLeadsInfo.aspx?id=" + commonTmpBBLE, "Leads Info");
            //ShowSearchLeadsInfo(tmpBBLE);
        }

        if (e.item.name == "ShortSale") {
            OpenLeadsWindow("/ShortSale/ShortSale.aspx?bble=" + commonTmpBBLE, "ShortSale Info");
        }

        if (e.item.name == "Eviction") {
            OpenLeadsWindow("/ShortSale/ShortSale.aspx?isEviction=true&bble=" + commonTmpBBLE, "Eviction Info");
        }

        if (e.item.name == "Legal") {
            OpenLeadsWindow("/LegalUI/LegalUI.aspx?bble=" + commonTmpBBLE, "Legal Info");
        }
    }
    function OpenTabLink(tabText,bble)
    {
        commonTmpBBLE = bble;
        OnPopupMenuLeadsClick(null, { item: { name: tabText } });
    }
    function OpenLeadsWindow(url, title) {
        var left = (screen.width / 2) - (1350 / 2);
        var top = (screen.height / 2) - (930 / 2);
        window.open(url, title, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
    }

</script>


<dx:ASPxPopupMenu ID="ASPxPopupMenu2" runat="server" ClientInstanceName="popupMenuLeads"
    AutoPostBack="false" PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick" ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <ItemStyle Paddings-PaddingLeft="20px" />
    <Items>
        <dx:MenuItem Text="Leads" Name="Leads"></dx:MenuItem>
        <dx:MenuItem Text="Short Sale" Name="ShortSale"></dx:MenuItem>
        <dx:MenuItem Text="Eviction" Name="Eviction"></dx:MenuItem>
        <dx:MenuItem Text="Legal" Name="Legal"></dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="OnPopupMenuLeadsClick" />
</dx:ASPxPopupMenu>
