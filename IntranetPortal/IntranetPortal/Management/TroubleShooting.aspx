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

        <br />
    </div>
    </form>
</body>
</html>
