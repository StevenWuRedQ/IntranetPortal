<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PortalError.aspx.vb" Inherits="IntranetPortal.PortalError" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container" style="width:700px">
        <div style="text-align:center;margin-bottom:30px">
            <img src="images/MyIdealProptery.png" style="width: 100px; text-align: center" />
        </div>        
        <h2 class="dx-error-message">Error</h2>
        <p></p>
        <asp:Label ID="FriendlyErrorMsg" runat="server" Text="Label" Font-Size="Large" Style="color: red"></asp:Label>
        <asp:Panel ID="DetailedErrorPanel" runat="server" Visible="false">
            <p>&nbsp;</p>
            <h4>Detailed Error:</h4>
            <p>
                <asp:Label ID="ErrorDetailedMsg" runat="server" Font-Size="Small" /><br />
            </p>
            <h4>Error Handler:</h4>
            <p>
                <asp:Label ID="ErrorHandler" runat="server" Font-Size="Small" /><br />
            </p>
            <h4>Detailed Error Message:</h4>
            <p>
                <asp:Label ID="InnerMessage" runat="server" Font-Size="Small" /><br />
            </p>
            <p>
                <asp:Label ID="InnerTrace" runat="server" />
            </p>
        </asp:Panel>
    </div>
</asp:Content>