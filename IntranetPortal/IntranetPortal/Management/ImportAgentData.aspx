<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ImportAgentData.aspx.vb" Inherits="IntranetPortal.ImportAgentData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function RefreshProgress(result) {
            //alert(result);
            ProgressBar.SetValue(result);
            window.setTimeout(function () { CheckProgress.PerformCallback(); }, 1000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxRoundPanel runat="server" HeaderText="Import Data" Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <table>
                            <tr>
                                <td style="width: 80px">
                                    <dx:ASPxLabel runat="server" Text="Agents:"></dx:ASPxLabel>
                                </td>
                                <td style="width: 150px;">
                                    <dx:ASPxComboBox runat="server" ID="cbAgents"></dx:ASPxComboBox>
                                </td>
                                <td style="padding-left: 10px;">
                                    <dx:ASPxButton runat="server" Text="Load" ID="btnLoad" OnClick="btnLoad_Click"></dx:ASPxButton>
                                </td>
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
                                <dx:GridViewDataTextColumn FieldName="Type">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                        Select Agent to Import:
                        <dx:ASPxComboBox runat="server" ID="cbImportAgent" TextField="Name" ValueField="EmployeeID"></dx:ASPxComboBox>
                        <dx:ASPxButton runat="server" ID="btnImport" Text="Import" OnClick="btnImport_Click"></dx:ASPxButton>
                        <dx:ASPxCheckBox runat="server" ID="chkReplace" Text="Replace Exsited"></dx:ASPxCheckBox>
                        <dx:ASPxLabel runat="server" ID="lblMsg"></dx:ASPxLabel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <dx:ASPxRoundPanel runat="server" HeaderText="Transfer Leads" Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <table>
                            <tr>
                                <td style="width: 80px">
                                    <dx:ASPxLabel runat="server" Text="Agents:"></dx:ASPxLabel>
                                </td>
                                <td style="width: 150px;">
                                    <dx:ASPxComboBox runat="server" ID="cbEmpFrom" TextField="Name" ValueField="EmployeeId"></dx:ASPxComboBox>
                                </td>
                                <td style="padding-left: 10px;">
                                    <dx:ASPxButton runat="server" Text="Load" ID="btnLoad2" OnClick="btnLoad2_Click"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                        <dx:ASPxGridView runat="server" ID="gridAgentLeads" KeyFieldName="ID" Settings-ShowGroupPanel="false" AutoGenerateColumns="false">
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="BBLE">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="EmployeeName">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="LeadsName">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Status">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                        Select Agent to Import:
                        <dx:ASPxComboBox runat="server" ID="cbEmpTo" TextField="Name" ValueField="EmployeeID"></dx:ASPxComboBox>
                        <dx:ASPxButton runat="server" ID="btnTransfer" Text="Transfer" OnClick="btnTransfer_Click"></dx:ASPxButton>                        
                        <dx:ASPxLabel runat="server" ID="ASPxLabel2"></dx:ASPxLabel>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
            <dx:ASPxRoundPanel runat="server" HeaderText="Initial Data" Width="100%">
                <PanelCollection>
                    <dx:PanelContent>
                        <table>
                            <tr>
                                <td style="width: 80px">
                                    <dx:ASPxLabel runat="server" Text="Leads:"></dx:ASPxLabel>
                                </td>
                                <td style="width: 150px;">
                                    <dx:ASPxComboBox runat="server" ID="cbLeadsType">
                                        <Items>
                                            <dx:ListEditItem Text="All" Value="" />
                                            <dx:ListEditItem Text="Unassign" Value="Unassign" />
                                            <dx:ListEditItem Text="New" Value="New" />
                                            <dx:ListEditItem Text="HomeOwner" Value="HomeOwner" />
                                            <dx:ListEditItem Text="MotgrAmt" Value="MotgrAmt" />
                                            <dx:ListEditItem Text="Existed" Value="Existed" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </td>
                                <td style="padding-left: 10px;">
                                    <dx:ASPxButton runat="server" Text="Load" ID="ASPxButton1"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>

                        <dx:ASPxGridView runat="server" ID="gridNewLeads" KeyFieldName="BBLE" Settings-ShowGroupPanel="false" AutoGenerateColumns="false" OnDataBinding="gridNewLeads_DataBinding">
                            <Columns>
                                <dx:GridViewDataTextColumn FieldName="BBLE">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PropertyAddress">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="CreateDate">
                                </dx:GridViewDataTextColumn>
                            </Columns>
                        </dx:ASPxGridView>
                        <dx:ASPxButton runat="server" ID="ASPxButton2" Text="Refresh" OnClick="ASPxButton2_Click">
                        </dx:ASPxButton>
                        <dx:ASPxLabel runat="server" ID="ASPxLabel1"></dx:ASPxLabel>
                        <dx:ASPxProgressBar runat="server" ClientInstanceName="ProgressBar" ID="RefreshBar" Maximum="1" Width="300px" Caption="Progress" Position="0.5">
                        </dx:ASPxProgressBar>
                        <dx:ASPxCallback runat="server" ID="checkProgress" ClientInstanceName="CheckProgress" OnCallback="checkProgress_Callback">
                            <ClientSideEvents CallbackComplete="function(s,e){ RefreshProgress(e.result); }" />
                        </dx:ASPxCallback>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
    </form>
</body>
</html>
