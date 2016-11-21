<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NewOfferNotification.aspx.vb" Inherits="IntranetPortal.NewOfferNotification" %>
<%@ Register Src="~/EmailTemplate/NewOfferNotification.ascx" TagPrefix="uc1" TagName="NewOfferNotification" %>
<%@ Register Src="~/EmailTemplate/NewOfferCompletedDue.ascx" TagPrefix="uc1" TagName="NewOfferCompletedDue" %>
<%@ Register Src="~/EmailTemplate/NewOfferInProcessDue.ascx" TagPrefix="uc1" TagName="NewOfferInProcessDue" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>   
</head>
<body>
    <form id="form1" runat="server">
        <uc1:NewOfferInProcessDue runat="server" ID="NewOfferInProcessDue" />
    </form>
</body>
</html>
