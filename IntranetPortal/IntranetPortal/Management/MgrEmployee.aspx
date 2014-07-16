<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MgrEmployee.aspx.vb" Inherits="IntranetPortal.MgrEmployee" %>

<%@ Register Src="~/UserControl/CompanyTree.ascx" TagPrefix="uc1" TagName="CompanyTree" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" FullscreenMode="true" Height="100%" Width="100%">
            <Panes>
                <dx:SplitterPane ScrollBars="Auto" Size="990px">
                    <PaneStyle Border-BorderStyle="None">
                        <Border BorderStyle="None"></Border>
                    </PaneStyle>
                    <Separator SeparatorStyle-Border-BorderStyle="None" SeparatorStyle-BackColor="White">
                        <SeparatorStyle BackColor="White">
                            <Border BorderStyle="None"></Border>
                        </SeparatorStyle>
                    </Separator>
                    <ContentCollection>
                        <dx:SplitterContentControl runat="server">
                            <dx:ASPxRoundPanel ID="ASPxRoundPanel1" runat="server" Width="100%" HeaderText="Employee Tree" Height="100%">
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxTreeList ID="treeList" runat="server" SettingsEditing-Mode="EditForm" Width="100%" Height="100%" ParentFieldName="ReportTo" KeyFieldName="EmployeeID">
                                            <Columns>
                                                <dx:TreeListTextColumn FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="0">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings>
                                                            <RequiredField IsRequired="True"></RequiredField>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Position" ShowInCustomizationForm="True" VisibleIndex="1">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Department" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Password" VisibleIndex="3" Visible="false" EditFormSettings-Visible="True">
                                                    <PropertiesTextEdit Password="True" ClientInstanceName="psweditor">
                                                    </PropertiesTextEdit>
                                                    <EditFormSettings Visible="True"></EditFormSettings>
                                                    <EditCellTemplate>
                                                        <dx:ASPxTextBox ID="pswtextbox" runat="server" Text='<%#Bind("Password")%>'
                                                            Visible='<%#treeList.IsNewNodeEditing%>' Password="True">
                                                            <ClientSideEvents Validation="function(s,e){e.isValid = s.GetText()>5;}" />
                                                        </dx:ASPxTextBox>
                                                        <asp:LinkButton ID="LinkButton1" runat="server" OnClientClick="popup.ShowAtElement(this); return false;" Visible='<%#Not treeList.IsNewNodeEditing%>'>Edit password</asp:LinkButton>
                                                    </EditCellTemplate>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Extension" ShowInCustomizationForm="True" VisibleIndex="3">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListTextColumn FieldName="Email" ShowInCustomizationForm="True" VisibleIndex="4" PropertiesTextEdit-ValidationSettings-RequiredField-IsRequired="true">
                                                    <PropertiesTextEdit>
                                                        <ValidationSettings>
                                                            <RequiredField IsRequired="True"></RequiredField>
                                                        </ValidationSettings>
                                                    </PropertiesTextEdit>
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListComboBoxColumn FieldName="ReportTo" PropertiesComboBox-ValueField="EmployeeID" PropertiesComboBox-TextField="Name" VisibleIndex="5">
                                                    <PropertiesComboBox TextField="Name" ValueField="EmployeeID" ValueType="System.Int32">
                                                    </PropertiesComboBox>                                              
                                                </dx:TreeListComboBoxColumn>
                                                <dx:TreeListTextColumn FieldName="Description" ShowInCustomizationForm="True" VisibleIndex="9">
                                                </dx:TreeListTextColumn>
                                                <dx:TreeListCheckColumn FieldName="Active" ShowInCustomizationForm="True" VisibleIndex="10">
                                                </dx:TreeListCheckColumn>
                                                <dx:TreeListCommandColumn ShowInCustomizationForm="True" VisibleIndex="11" ShowNewButtonInHeader="true">
                                                    <EditButton Visible="True">
                                                    </EditButton>
                                                    <NewButton Visible="True">
                                                    </NewButton>
                                                </dx:TreeListCommandColumn>
                                            </Columns>
                                            <SettingsBehavior ExpandCollapseAction="NodeDblClick" />
                                            <SettingsEditing Mode="EditForm"></SettingsEditing>
                                        </dx:ASPxTreeList>
                                        <dx:ASPxPopupControl ID="ASPxPopupControl1" runat="server" HeaderText="Edit password" Width="307px" ClientInstanceName="popup">
                                            <ContentCollection>
                                                <dx:PopupControlContentControl ID="Popupcontrolcontentcontrol1" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>Enter new password:</td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="npsw" runat="server" Password="True" ClientInstanceName="npsw">
                                                                    <ClientSideEvents Validation="function(s, e) {e.isValid = (s.GetText().length>5)}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="The password lengt should be more that 6 symbols">
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Confirm new password:</td>
                                                            <td>
                                                                <dx:ASPxTextBox ID="cnpsw" runat="server" Password="True" ClientInstanceName="cnpsw">
                                                                    <ClientSideEvents Validation="function(s, e) {e.isValid = (s.GetText() == npsw.GetText());}" />
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ErrorText="The password is incorrect">
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <dx:ASPxButton ID="confirmButton" runat="server" Text="Ok" AutoPostBack="False">
                                                    </dx:ASPxButton>
                                                </dx:PopupControlContentControl>
                                            </ContentCollection>
                                        </dx:ASPxPopupControl>
                                        <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=CHRISPC;Initial Catalog=IntranetPortal;Integrated Security=True;MultipleActiveResultSets=True;Application Name=EntityFramework" ProviderName="System.Data.SqlClient" SelectCommand="SELECT EmployeeID, EmployeeNo, Name, Position, Department, Extension, Email, Password, ReportTo, Description, CreateDate, CreateBy, Active FROM Employees ORDER BY Name"></asp:SqlDataSource>--%>
                                    </dx:PanelContent>
                                </PanelCollection>
                            </dx:ASPxRoundPanel>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <PaneStyle Border-BorderStyle="None">
                        <Border BorderStyle="None"></Border>
                    </PaneStyle>
                    <ContentCollection>
                        <dx:SplitterContentControl runat="server">
                            <div></div>
                        </dx:SplitterContentControl>
                    </ContentCollection>
                </dx:SplitterPane>
            </Panes>
        </dx:ASPxSplitter>
    </form>
</body>
</html>
