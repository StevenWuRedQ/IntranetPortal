<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PortalStatus.aspx.vb" Inherits="IntranetPortal.PortalStatus" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
                <tr>
                    <td style="vertical-align: top; max-height: 300px;">
                        <dx:ASPxRoundPanel HeaderText="User Status" runat="server">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td style="width: 150px;">TLO Call Count:</td>
                                            <td style="text-align: left">
                                                <strong><%= TLoCallCount%></strong>
                                            </td>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 150px;">Online Users Count:</td>
                                            <td style="text-align: left">
                                                <strong><%= OnlineUsers.Count%></strong>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <dx:ASPxGridView runat="server" ID="gridOnlineUsers" KeyFieldName="UserName" OnDataBinding="gridOnlineUsers_DataBinding">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="UserName"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="IPAddress"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="LoginTime" PropertiesTextEdit-DisplayFormatString="g"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="RefreshTime" PropertiesTextEdit-DisplayFormatString="g"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="SessionID"></dx:GridViewDataTextColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                    <table style="width: 100%; margin-top: 5px">
                                        <tr>
                                            <td colspan="2" style="font-size: 14px; text-align: center; line-height: 20px; background-color: #efefef;">Send Message
                                            </td>
                                        </tr>
                                        <tr style="margin-top: 3px; height: 25px">
                                            <td>To:</td>
                                            <td>
                                                <dx:ASPxComboBox runat="server" ID="cbUsers"></dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr style="margin-top: 3px;">
                                            <td>Comments:</td>
                                            <td>
                                                <dx:ASPxMemo runat="server" ID="txtComments" Width="100%" Height="100px"></dx:ASPxMemo>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px;">
                                            <td></td>
                                            <td style="padding-top: 3px;">
                                                <dx:ASPxButton Text="Send" runat="server" ID="btnSend"></dx:ASPxButton>
                                            </td>

                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </td>
                    <td style="vertical-align: top">
                        <dx:ASPxRoundPanel HeaderText="Settings" runat="server">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxGridView runat="server" ID="gridSettings" KeyFieldName="SettingId" OnDataBinding="gridSettings_DataBinding" OnRowUpdating="gridSettings_RowUpdating" Theme="Moderno">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="Name" ReadOnly="true" Width="100px"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="Value" Width="400px"></dx:GridViewDataTextColumn>
                                        </Columns>
                                        <SettingsEditing Mode="Batch"></SettingsEditing>
                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </td>
                </tr>
                <tr>
                    <td>
                        <dx:ASPxRoundPanel HeaderText="Common Data" runat="server">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <dx:ASPxButton Text="Refresh Common Data" runat="server" ID="btnCommonData" OnClick="btnCommonData_Click"></dx:ASPxButton>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                        <dx:ASPxRoundPanel HeaderText="Login Logs" runat="server">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table>
                                        <tr>
                                            <td style="width: 150px;">Date:</td>
                                            <td style="text-align: left">
                                                <dx:ASPxDateEdit runat="server" ID="dtLog"></dx:ASPxDateEdit>
                                            </td>
                                            <td>
                                                <dx:ASPxButton runat="server" ID="btnLoad" Text="Load"></dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                    <dx:ASPxGridView runat="server" ID="gridLogs" KeyFieldName="LogID">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="Employee"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="IPAddress"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="LogInTime" PropertiesTextEdit-DisplayFormatString="g"></dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="LogoutTime" PropertiesTextEdit-DisplayFormatString="g"></dx:GridViewDataTextColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </td>
                    <td style="vertical-align: top">
                        <dx:ASPxRoundPanel HeaderText="Send Email" runat="server" Width="100%">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <table style="width: 500px">
                                        <tr style="margin-top: 3px; height: 25px">
                                            <td>To:</td>
                                            <td>
                                                <dx:ASPxComboBox runat="server" ID="cbEmployee"></dx:ASPxComboBox>
                                            </td>
                                        </tr>
                                        <tr style="margin-top: 3px; height: 25px">
                                            <td>Subject:</td>
                                            <td>
                                                <dx:ASPxTextBox runat="server" ID="txtSubject"></dx:ASPxTextBox>
                                            </td>
                                        </tr>
                                        <tr style="margin-top: 3px;">
                                            <td>EmailBody:</td>
                                            <td>
                                                <dx:ASPxMemo runat="server" ID="ASPxMemo1" Width="100%" Height="100px"></dx:ASPxMemo>
                                            </td>
                                        </tr>
                                        <tr style="height: 30px;">
                                            <td></td>
                                            <td style="padding-top: 3px;">
                                                <dx:ASPxButton Text="Send Email" runat="server" ID="ASPxButton1" OnClick="ASPxButton1_Click"></dx:ASPxButton>
                                                <dx:ASPxButton Text="Send All Email" runat="server" ID="ASPxButton2" OnClick="ASPxButton2_Click"></dx:ASPxButton>

                                                <dx:ASPxLabel runat="server" ID="lblResult"></dx:ASPxLabel>
                                            </td>
                                        </tr>
                                    </table>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxRoundPanel>
                    </td>
                </tr>
            </table>


        </div>
    </form>
</body>
</html>
