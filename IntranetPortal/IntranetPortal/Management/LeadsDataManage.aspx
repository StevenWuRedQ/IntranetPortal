<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsDataManage.aspx.vb" Inherits="IntranetPortal.LeadsDataManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        // <![CDATA[
        var fileName = null;
        function Uploader_OnUploadStart() {
            btnUpload.SetEnabled(false);
        }
        function Uploader_OnFileUploadComplete(args) {
            if (args.isValid) {
                //gridFilesClient.PerformCallback(args.callbackData + "|" + hfBBLEClient.Get("BBLE"));
                var date = new Date();
                fileName = args.callbackData;
                lblDataFileName.SetText(fileName);
            }
        }

        function UpdateUploadButton() {
            btnUpload.SetEnabled(uploader.GetText(0) != "");
        }
        function getPreviewImageElement() {
            return document.getElementById("previewImage");
        }

        function UpdateCategory(logId, sender) {
            var newCategory = sender.GetValue();
            gridFilesClient.PerformCallback("UpdateCategory|" + logId + "|" + newCategory + "|" + hfBBLEClient.Get("BBLE"));
        }

        function ImportFile() {
            if (fileName) {
                gridLeadsData.PerformCallback(fileName)
            }
        }

        function RunService(command) {
            callBackService.PerformCallback(command);
        }

        function RefreshProgress(result) {
            //alert(result);
            var leadsDataService = eval("(" + result + ")");
            if (leadsDataService) {
                lblServiceStatus.SetText("Leads Data Service Status: " + leadsDataService.StatusString);

                if (leadsDataService.Status == 1) {
                    var percent = parseInt((leadsDataService.CurrentIndex + 1) / leadsDataService.TotalCount)
                    ProgressBar.SetValue(percent);
                    callbackLogs.PerformCallback();
                }
            }
            //alert(leadsDataService.Status);

            window.setTimeout(function () { CheckProgress.PerformCallback(); }, 1000);
        }

        function BindLogs(result) {
            var logs = eval("(" + result + ")");

            var table = document.getElementById("tblServiceLogs");

            for (var i = 0; i < logs.length; i++) {
                var log = logs[i];
                // Create an empty <tr> element and add it to the 1st position of the table:
                var row = table.insertRow(1);

                // Insert new cells (<td> elements) at the 1st and 2nd position of the "new" <tr> element:
                var cell0 = row.insertCell(0);
                cell0.innerHTML = log.MsgID;

                var cell1 = row.insertCell(1);
                cell1.innerHTML = log.BBLE;

                var cell2 = row.insertCell(2);
                cell2.innerHTML = log.Title;

                var cell3 = row.insertCell(3);
                cell3.innerHTML = log.Message;

                var cell4 = row.insertCell(4);
                cell4.innerHTML = ToJavaScriptDate(log.CreateTime).toLocaleString();
            }
        }

        function ToJavaScriptDate(value) {
            var pattern = /Date\(([^)]+)\)/;
            var results = pattern.exec(value);
            var dt = new Date(parseFloat(results[1]));
            return dt;
        }

        // ]]> 
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <dx:ASPxSplitter ID="contentSplitter" runat="server" Height="100%" Width="100%" ClientInstanceName="contentSplitter" FullscreenMode="true">
            <Styles>
                <Pane Paddings-Padding="0">
                    <Paddings Padding="0px"></Paddings>
                </Pane>
            </Styles>
            <Panes>
                <dx:SplitterPane ScrollBars="Auto" PaneStyle-Paddings-Padding="5px">
                    <ContentCollection>
                        <dx:SplitterContentControl>
                            <h3>Leads Data</h3>
                            <table style="width: 720px; text-align: left; margin: 10px 10px 0 0;">
                                <tr>
                                    <td class="caption" style="width: 100px;">
                                        <dx:ASPxLabel ID="lblSelectImage" runat="server" Text="Select File:">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxUploadControl ID="uplImage" runat="server" ClientInstanceName="uploader" ShowProgressPanel="True" ShowAddRemoveButtons="false" AddUploadButtonsHorizontalPosition="Left"
                                            NullText="Click here to browse files..." Size="35" Width="100%">
                                            <ClientSideEvents FileUploadComplete="function(s, e) { Uploader_OnFileUploadComplete(e); }"
                                                FileUploadStart="function(s, e) { Uploader_OnUploadStart(); }"
                                                TextChanged="function(s, e) { UpdateUploadButton(); }"></ClientSideEvents>
                                            <ValidationSettings MaxFileSize="4194304">
                                            </ValidationSettings>
                                        </dx:ASPxUploadControl>
                                    </td>
                                    <td style="padding-left: 5px; width: 180px">
                                        <dx:ASPxButton ID="btnUpload" runat="server" AutoPostBack="False" Text="Upload" ClientInstanceName="btnUpload" Width="100px" ClientEnabled="False" Style="margin: 0 auto;">
                                            <ClientSideEvents Click="function(s, e) { uploader.Upload(); }" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td class="note">
                                        <dx:ASPxLabel ID="lblAllowebMimeType" runat="server" Text="Allowed types: xlst;"
                                            Font-Size="8pt">
                                        </dx:ASPxLabel>
                                        <dx:ASPxLabel ID="lblMaxFileSize" runat="server" Text="Maximum file size: 4Mb" Font-Size="8pt">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr style="height: 40px;">
                                    <td></td>
                                    <td class="buttonCell" style="margin-bottom: 5px; text-align: right">
                                        <dx:ASPxLabel ID="lblDataFileName" runat="server" ClientInstanceName="lblDataFileName"></dx:ASPxLabel>
                                    </td>
                                    <td style="padding-left: 5px;">
                                        <dx:ASPxButton Text="Preview" RenderMode="Link" runat="server" ID="btnPreview" AutoPostBack="false"></dx:ASPxButton>
                                        <dx:ASPxButton Text="Remove" RenderMode="Link" runat="server" ID="ASPxButton1" AutoPostBack="false"></dx:ASPxButton>
                                        <dx:ASPxButton Text="Import" RenderMode="Link" runat="server" ID="ASPxButton2" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s,e){ImportFile();}" />
                                        </dx:ASPxButton>
                                        <dx:ASPxButton Text="Refresh" RenderMode="Link" runat="server" ID="btnRefresh" AutoPostBack="false">
                                            <ClientSideEvents Click="function(s,e){ gridLeadsData.Refresh();}" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <dx:ASPxGridView runat="server" ID="gridLeadsData" Width="100%" ClientInstanceName="gridLeadsData" OnCustomCallback="gridLeadsData_CustomCallback" KeyFieldName="ID" OnDataBinding="gridLeadsData_DataBinding" OnRowUpdating="gridLeadsData_RowUpdating">
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="BBLE"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Type"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Agent_Name"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataDateColumn FieldName="ScheduleDate">
                                    </dx:GridViewDataDateColumn>
                                </Columns>
                                <SettingsEditing Mode="Batch"></SettingsEditing>
                            </dx:ASPxGridView>
                        </dx:SplitterContentControl>

                    </ContentCollection>
                </dx:SplitterPane>
                <dx:SplitterPane>
                    <Panes>
                        <dx:SplitterPane PaneStyle-Paddings-Padding="5px">
                            <ContentCollection>
                                <dx:SplitterContentControl>
                                    <table style="width: 100%">
                                        <tr>
                                            <td>
                                                <h3>Data Loop Service Status</h3>
                                                <div style="float: left">
                                                    <dx:ASPxButton runat="server" ID="btnStart" Text="Start" AutoPostBack="false">
                                                        <ClientSideEvents Click="function(s,e){ RunService('Start'); }" />
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton runat="server" ID="ASPxButton3" Text="Suspend" AutoPostBack="false">
                                                        <ClientSideEvents Click="function(s,e){ RunService('Suspend'); }" />
                                                    </dx:ASPxButton>
                                                    <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Stop" AutoPostBack="false">
                                                        <ClientSideEvents Click="function(s,e){ RunService('Stop'); }" />
                                                    </dx:ASPxButton>
                                                </div>
                                                <div style="clear: both">
                                                    <dx:ASPxLabel runat="server" Text="Service Status: " ClientInstanceName="lblServiceStatus"></dx:ASPxLabel>
                                                </div>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </table>
                                    <table>
                                        <tr>
                                            <td style="width: 80px">
                                                <dx:ASPxLabel runat="server" Text="Leads Type:"></dx:ASPxLabel>
                                            </td>
                                            <td style="width: 150px;">
                                                <dx:ASPxComboBox runat="server" ID="cbLeadsType" ClientInstanceName="cbLeadsType">
                                                    <Items>
                                                        <dx:ListEditItem Text="All" Value="" />
                                                        <dx:ListEditItem Text="Unassign" Value="Unassign" />
                                                        <dx:ListEditItem Text="New" Value="New" />
                                                        <dx:ListEditItem Text="HomeOwner" Value="HomeOwner" />
                                                        <dx:ListEditItem Text="MotgrAmt" Value="MotgrAmt" />
                                                        <dx:ListEditItem Text="Existed" Value="Existed" />
                                                        <dx:ListEditItem Text="Employee" Value="Employee" />
                                                    </Items>
                                                </dx:ASPxComboBox>
                                                <dx:ASPxComboBox runat="server" ID="cbEmployee" ClientInstanceName="CbEmployee">
                                                </dx:ASPxComboBox>
                                            </td>
                                            <td style="padding-left: 10px;">
                                                <dx:ASPxButton runat="server" Text="Load" ID="btnLoadData" AutoPostBack="false">
                                                    <ClientSideEvents Click="function(s,e){ gridNewLeads.PerformCallback(); }" />
                                                </dx:ASPxButton>
                                            </td>
                                        </tr>
                                    </table>
                                    <dx:ASPxGridView runat="server" ID="gridNewLeads" ClientInstanceName="gridNewLeads" KeyFieldName="BBLE" Settings-ShowGroupPanel="false" AutoGenerateColumns="false" OnCustomCallback="gridNewLeads_CustomCallback">
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="BBLE">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="PropertyAddress">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn FieldName="CreateDate">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                    </dx:ASPxGridView>
                                    <dx:ASPxButton runat="server" ID="ASPxButton6" Text="Run All Data Loop" AutoPostBack="false">
                                        <ClientSideEvents Click="function(s,e){
                                            if(cbLeadsType.GetText() == 'Employee')
                                              {  RunService('Loop|' + CbEmployee.GetText()); }
                                            else
                                              {  RunService('Loop|' + cbLeadsType.GetText()); }
                                            }" />
                                    </dx:ASPxButton>
                                    &nbsp;
                                    <dx:ASPxButton runat="server" ID="ASPxButton5" Text="Run General Info Loop" AutoPostBack="false">
                                        <ClientSideEvents Click="function(s,e){
                                            if(cbLeadsType.GetText() == 'Employee')
                                              {  RunService('GeneralInfoLoop|' + CbEmployee.GetText()); }
                                            else {
                                                RunService('GeneralInfoLoop|' + cbLeadsType.GetText()); }                                          
                                             }" />
                                    </dx:ASPxButton>
                                    <dx:ASPxButton runat="server" ID="ASPxButton7" Text="Run Servicer Info Loop" AutoPostBack="false">
                                        <ClientSideEvents Click="function(s,e){
                                            if(cbLeadsType.GetText() == 'Employee')
                                              {  RunService('ServicerLoop|' + CbEmployee.GetText()); }
                                            else {
                                                RunService('ServicerLoop|' + cbLeadsType.GetText()); }                                          
                                             }" />
                                    </dx:ASPxButton>
                                    <dx:ASPxLabel runat="server" ID="ASPxLabel1"></dx:ASPxLabel>
                                    <dx:ASPxProgressBar runat="server" ClientInstanceName="ProgressBar" ID="RefreshBar" Maximum="1" Width="300px" Caption="Progress" Position="0.5">
                                    </dx:ASPxProgressBar>
                                    <dx:ASPxCallback runat="server" ID="checkProgress" ClientInstanceName="CheckProgress" OnCallback="checkProgress_Callback">
                                        <ClientSideEvents CallbackComplete="function(s,e){ RefreshProgress(e.result); }" />
                                    </dx:ASPxCallback>
                                </dx:SplitterContentControl>
                            </ContentCollection>
                        </dx:SplitterPane>
                        <dx:SplitterPane ScrollBars="Auto" PaneStyle-Paddings-Padding="5px">
                            <ContentCollection>
                                <dx:SplitterContentControl>
                                    <h3>Service Logs</h3>
                                    <table style="width: 100%; overflow: scroll;" id="tblServiceLogs">
                                        <thead style="background-color: #efefef;">
                                            <tr style="height: 30px">
                                                <td style="width: 50px">#Id</td>
                                                <td style="width: 120px">BBLE</td>
                                                <td style="width: 200px">Title</td>
                                                <td>Message</td>
                                                <td style="width: 150px">Date Time</td>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                            </tr>
                                        </tbody>
                                    </table>
                                </dx:SplitterContentControl>
                            </ContentCollection>
                        </dx:SplitterPane>
                         <dx:SplitterPane ScrollBars="Auto" PaneStyle-Paddings-Padding="5px">
                    <Panes>
                        <dx:SplitterPane PaneStyle-Paddings-Padding="5px">
                            <ContentCollection>
                                <dx:SplitterContentControl>
                                    <h3>Legal Data Report Sync</h3>
                                    <asp:Button ID="LoadLeagl" runat="server" Text="Load" OnClick="LoadLeagl_Click"/>
                                    <asp:Button ID="Button1" runat="server" Text="Sync Report" OnClick="Button1_Click"/>
                                    <dx:ASPxGridView ID="gridLegalCase" runat="server" KeyFieldName="BBLE">
                                        <Columns>
                                           <dx:GridViewDataColumn FieldName="BBLE"></dx:GridViewDataColumn>
                                             <dx:GridViewDataColumn FieldName="CaseName"></dx:GridViewDataColumn>
                                            
                                            <dx:GridViewDataColumn FieldName="FCIndexNum"></dx:GridViewDataColumn>
                                           <dx:GridViewDataColumn FieldName="SaleDate"></dx:GridViewDataColumn>
                                           <dx:GridViewDataColumn FieldName="LegalStatus"></dx:GridViewDataColumn>
                                            
                                        </Columns>
                                    </dx:ASPxGridView>
                                </dx:SplitterContentControl>
                            </ContentCollection>
                        </dx:SplitterPane>

                    </Panes>
                </dx:SplitterPane>
                    </Panes>
                </dx:SplitterPane>
               
            </Panes>

        </dx:ASPxSplitter>

        <dx:ASPxCallback runat="server" ID="callBackService" ClientInstanceName="callBackService" OnCallback="callBackService_Callback">
        </dx:ASPxCallback>
        <dx:ASPxCallback runat="server" ID="ASPxCallback1" ClientInstanceName="CheckProgress" OnCallback="checkProgress_Callback">
            <ClientSideEvents CallbackComplete="function(s,e){ RefreshProgress(e.result); }" />
        </dx:ASPxCallback>
        <dx:ASPxCallback runat="server" ID="callbackLogs" ClientInstanceName="callbackLogs">
            <ClientSideEvents CallbackComplete="function(s,e){ BindLogs(e.result); }" />
        </dx:ASPxCallback>
        <script type="text/javascript">
            RefreshProgress(0);
        </script>
    </form>
</body>
</html>
