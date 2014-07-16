<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImportAgentData.aspx.vb" Inherits="IntranetPortal.ImportAgentData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <dx:ASPxRoundPanel runat="server" HeaderText="Import Data" Width="100%">
            <PanelCollection>
                <dx:PanelContent>
  <table>
                <tr>
                    <td style="width:80px"><dx:ASPxLabel runat="server" Text="Agents:"></dx:ASPxLabel></td>
                    <td style="width:150px;">
                        <dx:ASPxComboBox runat="server" ID="cbAgents"></dx:ASPxComboBox>
                    </td>
                    <td style="padding-left:10px;">
                        <dx:ASPxButton runat="server" Text="Load" ID="btnLoad" OnClick="btnLoad_Click"></dx:ASPxButton>
                    </td>
                </tr>
                <tr>
                </tr>
            </table>

            <dx:ASPxGridView runat="server" ID="gridLead" KeyFieldName="ID" Settings-ShowGroupPanel="false" AutoGenerateColumns="false">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="BBLE">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Agent_Name">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Property_Address">
                    </dx:GridViewDataTextColumn>
                </Columns>
            </dx:ASPxGridView>
             Select Agent to Import: <dx:ASPxComboBox runat="server" ID="cbImportAgent" TextField="Name" ValueField="EmployeeID"></dx:ASPxComboBox>
            <dx:ASPxButton runat="server" ID="btnImport" Text="Import" OnClick="btnImport_Click"></dx:ASPxButton>
            <dx:ASPxLabel runat="server" ID="lblMsg"></dx:ASPxLabel>
                    </dx:PanelContent>
                </PanelCollection>
                  </dx:ASPxRoundPanel>
          
        </div>
    </form>
</body>
</html>
