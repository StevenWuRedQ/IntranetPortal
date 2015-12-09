<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WorkflowMng.aspx.vb" Inherits="IntranetPortal.WorkflowMng" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>
            Create Request Update Process
        </h3>
        <table>
            <tr>
                <td>TaskId:</td>
                <td><asp:TextBox runat="server" ID="txtTaskId"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button Text="Create Task" runat="server" OnClick="Unnamed1_Click" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label runat="server" ID="lblResult"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
