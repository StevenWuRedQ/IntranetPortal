<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TroubleShooting.aspx.vb" Inherits="IntranetPortal.TroubleShooting" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>        
    BBLE: <dx:ASPxTextBox runat="server" ID="txtBble"></dx:ASPxTextBox>
        <dx:ASPxButton runat="server" ID="btnLoad" Text="Load"></dx:ASPxButton>
        <dx:ASPxHyperLink runat="server" ID="linkInfo" Text="View Lead"></dx:ASPxHyperLink><br />
        <dx:ASPxButton runat="server" ID="btnGetphone" Text="Initial Phones"></dx:ASPxButton>
        <asp:Button ID="Button1" runat="server" Text="Button" />
        <table>
            <tr>
                <td>
                    User Name:
                </td>
                <td>
                    <dx:ASPxTextBox runat="server" ID="txtName"></dx:ASPxTextBox>
                </td>
            </tr>
            <tr>
                <td>

                </td>
                <td>            
                     <dx:ASPxButton runat="server" ID="btnTestIsManager" Text="Is Manager"></dx:ASPxButton>
                </td>
            </tr>
        </table>
        <dx:ASPxLabel runat="server" ID="lblMsg"></dx:ASPxLabel>
        <dx:ASPxButton runat="server" ID="btnTestDataService" Text="Test Data Service"></dx:ASPxButton>
                <dx:ASPxButton runat="server" ID="ASPxButton1" Text="Test HomeOwner Service"></dx:ASPxButton>

        <br />
    </div>
    </form>
</body>
</html>
