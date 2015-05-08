<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="IntranetPortal._Default1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="background: url(/images/Background2.png) no-repeat center fixed; background-size: auto, auto; background-color: #dddddd; width: 100%; height: 100%;">
            <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
            <dx:ASPxGridView runat="server" Settings-ShowColumnHeaders="false"
                ID="gridHomeOwner" ClientInstanceName="gridLeads" Width="100%" KeyFieldName="BBLE"
                EnableViewState="true">
                <Columns>
                    <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="Page" VisibleIndex="0" Name="colSelect" Visible="true" Width="25px">
                    </dx:GridViewCommandColumn>
                    <dx:GridViewDataColumn FieldName="BBLE" Caption="BBLE" Width="1px" ExportWidth="100">
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="FirstName" Settings-AllowHeaderFilter="False" Visible="false">                       
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="LastName" Settings-AllowHeaderFilter="False" Visible="false">                       
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Name" Settings-AllowHeaderFilter="False">                       
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Address1" Settings-AllowHeaderFilter="False">                       
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="City" Settings-AllowHeaderFilter="False">                       
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Zip" Settings-AllowHeaderFilter="False">                       
                    </dx:GridViewDataTextColumn>                                        
                    <dx:GridViewDataTextColumn FieldName="FullAddress" Visible="false"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Alive"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Age"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Bankruptcy"></dx:GridViewDataTextColumn>
                     <dx:GridViewDataTextColumn FieldName="PhoneCount"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PhoneNumbers" PropertiesTextEdit-EncodeHtml="false"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="AddressHistory" PropertiesTextEdit-EncodeHtml="false"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Relatives1stNamePhone" PropertiesTextEdit-EncodeHtml="true"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Relatives2ndNamePhone" PropertiesTextEdit-EncodeHtml="true"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Relatives3rdNamePhone" PropertiesTextEdit-EncodeHtml="true"></dx:GridViewDataTextColumn>                   
                </Columns>
                <SettingsBehavior AllowClientEventsOnLoad="true" AllowFocusedRow="true"
                    EnableRowHotTrack="True" />
                <Settings ShowColumnHeaders="true" VerticalScrollableHeight="1000" GridLines="Both"></Settings>
                <SettingsPager Mode="EndlessPaging" PageSize="100"></SettingsPager>
                <Styles>
                    <Header HorizontalAlign="Center"></Header>
                    <Row Cursor="pointer" />
                    <AlternatingRow BackColor="#F5F5F5"></AlternatingRow>
                    <RowHotTrack BackColor="#FF400D"></RowHotTrack>
                </Styles>
                <Border BorderStyle="None"></Border>
                <ClientSideEvents FocusedRowChanged="OnGridFocusedRowChanged" SelectionChanged="OnSelectionChanged" />
            </dx:ASPxGridView>
            <dx:ASPxGridViewExporter ID="gridExport" runat="server" GridViewID="gridHomeOwner" OnRenderBrick="gridExport_RenderBrick">
            </dx:ASPxGridViewExporter>
        </div>
    </form>
</body>
</html>
