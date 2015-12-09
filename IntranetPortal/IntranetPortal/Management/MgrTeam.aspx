<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MgrTeam.aspx.vb" Inherits="IntranetPortal.MgrTeamPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div style="float: left; width: 300px; margin-right: 10px;">
                <dx:ASPxRoundPanel runat="server" HeaderText="Teams" Width="100%">
                    <PanelCollection>
                        <dx:PanelContent>
                            <dx:ASPxListBox runat="server" ID="lbRoles" Width="100%" Height="350px" AutoPostBack="true"></dx:ASPxListBox>
                            <br />
                            <dx:ASPxTextBox runat="server" Width="100%" ID="txtRoles"></dx:ASPxTextBox>
                            <dx:ASPxButton runat="server" Text="Add" ID="btnAddRole"></dx:ASPxButton>
                            <dx:ASPxButton runat="server" Text="Remove" ID="btnRemoveRole"></dx:ASPxButton>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </div>
            <dx:ASPxRoundPanel runat="server" HeaderText="Employees" Width="300px">
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxListBox runat="server" ID="lbEmployees" Width="100%" Height="350px"></dx:ASPxListBox>
                        <br />
                        <dx:ASPxTokenBox runat="server" Width="100%" ID="cbEmps" TextSeparator=";"></dx:ASPxTokenBox>
                        <dx:ASPxButton runat="server" Text="Add" ID="btnAddEmp"></dx:ASPxButton>
                        <dx:ASPxButton runat="server" Text="Remove" ID="btnRemoveEmp"></dx:ASPxButton>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <dx:ASPxLabel ID="lblError" Text="" runat="server" ForeColor="Red"></dx:ASPxLabel>
        </div>
    </form>
</body>
</html>
