<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WhileAwayMsgs.aspx.vb" Inherits="IntranetPortal.WhileAwayMsgs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function ClearMsg(msgId) {
            gridMsgs.PerformCallback(msgId);
        }

        function PopupViewLead(popupBBLE) {
            if (popupBBLE != null) {
                var url = '/ViewLeadsInfo.aspx?id=' + popupBBLE;
                window.showModalDialog(url, 'View Leads Info', 'dialogWidth:1350px;dialogHeight:810px');
            }
        }
    </script>
    <style type="text/css">

    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxGridView runat="server" ID="gridMsgs" ClientInstanceName="gridMsgs" KeyFieldName="MsgID" Width="100%" OnCustomCallback="gridMsgs_CustomCallback" SettingsBehavior-AllowSort="false">
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="BBLE" Caption="ADDRESS" Width="200px">
                        <DataItemTemplate>
                            <%# GetPropertyAddress(Eval("BBLE"))%>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Createby" Caption="FROM" Width="100px"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Message" Caption="MESSAGE" PropertiesTextEdit-EncodeHtml="false"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Caption="" Width="50px" CellStyle-HorizontalAlign="Center" Visible="false">
                        <DataItemTemplate>
                            <a href="#" onclick='(<%# String.Format("ClearMsg({0})", Eval("MsgID")) %>)'>Clear</a>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn Width="50px" CellStyle-HorizontalAlign="Center" Visible="false">
                        <DataItemTemplate>
                            <a href="#" onclick='(<%# String.Format("PopupViewLead({0})", Eval("BBLE"))%>)'>View</a>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                </Columns>
                <SettingsBehavior AllowFocusedRow="true" AllowClientEventsOnLoad="true"
                    EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
                <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                <Styles>                   
                    <Row Cursor="pointer" />
                    <AlternatingRow BackColor="#efefef"></AlternatingRow>
                </Styles>
            </dx:ASPxGridView>
        </div>
    </form>
</body>
</html>
