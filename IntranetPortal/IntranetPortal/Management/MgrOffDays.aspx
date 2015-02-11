<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MgrOffDays.aspx.vb" Inherits="IntranetPortal.MgrOffDays" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="float: left; width: 500px; margin-right: 10px;">
            <dx:ASPxRoundPanel runat="server" HeaderText="Personal Off" Width="100%" Theme="Moderno">               
                <PanelCollection>
                    <dx:PanelContent>
                        <dx:ASPxGridView ID="gridOffDays" ClientInstanceName="grid" runat="server" KeyFieldName="DayId" Width="100%" Theme="Moderno" OnDataBinding="gridOffDays_DataBinding">
                            <Columns>
                                <dx:GridViewDataColumn FieldName="DayId" VisibleIndex="0" Visible="false" />
                                <dx:GridViewDataColumn FieldName="SpecialDate" VisibleIndex="1" />
                                <dx:GridViewDataColumn FieldName="Description" VisibleIndex="2" />
                                <dx:GridViewDataColumn FieldName="CreateBy" VisibleIndex="3" Visible="false" />
                                <dx:GridViewDataColumn FieldName="Employee" VisibleIndex="4" Settings-AllowGroup="True" GroupIndex="1" />
                            </Columns>
                            <Settings ShowGroupPanel="false" />
                            <GroupSummary>
                                <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
                            </GroupSummary>
                        </dx:ASPxGridView>
                        <dx:ASPxFormLayout runat="server" ID="FormLayoutOffDays" RequiredMarkDisplayMode="RequiredOnly" EnableViewState="false" EncodeHtml="false" Theme="Moderno" Width="100%">
                            <Items>
                                <dx:LayoutGroup Caption="Add Off Days" SettingsItemHelpTexts-Position="Bottom" GroupBoxDecoration="HeadingLine">
                                    <Items>
                                        <dx:LayoutItem Caption="Name" HelpText="Please, select agent name">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cbAgents" Theme="Moderno"></dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Start Date" HelpText="Please, enter start date">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxDateEdit runat="server" Theme="Moderno" ID="sDate"></dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="End Date" HelpText="Please, enter end date">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxDateEdit runat="server" Theme="Moderno" ID="endDate"></dx:ASPxDateEdit>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem Caption="Reason" HelpText="Please, select reason of off">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxComboBox runat="server" ID="cbReason" Theme="Moderno">
                                                        <Items>
                                                            <dx:ListEditItem Text="Sick" />
                                                            <dx:ListEditItem Text="Vacation" />
                                                            <dx:ListEditItem Text="Personal" />
                                                        </Items>
                                                    </dx:ASPxComboBox>
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                        <dx:LayoutItem ShowCaption="false" RequiredMarkDisplayMode="Hidden" HorizontalAlign="Right" Width="100">
                                            <LayoutItemNestedControlCollection>
                                                <dx:LayoutItemNestedControlContainer>
                                                    <dx:ASPxButton runat="server" ID="submitButton" Text="Submit" Width="100" Theme="Moderno" OnClick="submitButton_Click" />
                                                </dx:LayoutItemNestedControlContainer>
                                            </LayoutItemNestedControlCollection>
                                        </dx:LayoutItem>
                                    </Items>
                                </dx:LayoutGroup>
                            </Items>
                        </dx:ASPxFormLayout>

                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxRoundPanel>
        </div>
        <dx:ASPxRoundPanel runat="server" HeaderText="Public Holiday" Width="500px" Theme="Moderno">
            <PanelCollection>
                <dx:PanelContent>
                    <dx:ASPxGridView ID="gridPublicHoliday" ClientInstanceName="grid" runat="server" KeyFieldName="DayId" Width="100%" Theme="Moderno" OnDataBinding="gridOffDays_DataBinding">
                        <Columns>
                            <dx:GridViewDataColumn FieldName="DayId" VisibleIndex="0" Visible="false" />
                            <dx:GridViewDataColumn FieldName="SpecialDate" VisibleIndex="1" />
                            <dx:GridViewDataColumn FieldName="Description" VisibleIndex="2" />
                            <dx:GridViewDataColumn FieldName="CreateBy" VisibleIndex="3"  Visible="false"/>
                            <dx:GridViewDataColumn FieldName="Employee" VisibleIndex="4" Visible="false" />
                        </Columns>
                        <Settings ShowGroupPanel="false" ShowColumnHeaders="false" />
                        <GroupSummary>
                            <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
                        </GroupSummary>
                    </dx:ASPxGridView>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxRoundPanel>
        <dx:ASPxLabel ID="lblError" Text="" runat="server" ForeColor="Red"></dx:ASPxLabel>

    </form>
</body>
</html>
