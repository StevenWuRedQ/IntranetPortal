<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm3.aspx.vb" Inherits="IntranetPortal.WebForm3" %>

<%@ Register Src="~/EmailTemplate/ComplaintsNotify.ascx" TagPrefix="uc1" TagName="ComplaintsNotify" %>
<%@ Register Src="~/EmailTemplate/DeadleadsReport.ascx" TagPrefix="uc1" TagName="DeadleadsReport" %>
<%@ Register Src="~/EmailTemplate/AuctionDailyReport.ascx" TagPrefix="uc1" TagName="AuctionDailyReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <uc1:ComplaintsNotify runat="server" ID="ComplaintsNotify" Visible="false" />
            <uc1:DeadleadsReport runat="server" ID="DeadleadsReport"  Visible="false"/>
            <uc1:AuctionDailyReport runat="server" ID="AuctionDailyReport" Visible="false" />
            <br />
            <asp:Button ID="Button1" runat="server" Text="Send Email" OnClick="Button1_Click" />
            <asp:Button ID="Button2" runat="server" Text="Send Complaints Detail" OnClick="Button2_Click" />
            <asp:Button ID="Button3" runat="server" Text="Send Deadleads Report" OnClick="Button3_Click" />
            <asp:Button ID="Button4" runat="server" Text="Send Auction Daily Report" OnClick="Button4_Click" />
        </div>
    </form>
</body>
</html>
