<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ProcessReport.aspx.vb" Inherits="IntranetPortal.ProcessReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h3>Process Instances</h3>
            <dx:ASPxGridView ID="gridProcInst" ClientInstanceName="grid" runat="server" KeyFieldName="Id" Width="100%" Theme="Moderno" OnHtmlRowPrepared="gridProcInst_HtmlRowPrepared">
                <Columns>
                    <dx:GridViewDataColumn FieldName="Id" VisibleIndex="0" />
                    <dx:GridViewDataColumn FieldName="DisplayName" VisibleIndex="1" />
                    <dx:GridViewDataColumn FieldName="Priority" VisibleIndex="2" />
                    <dx:GridViewDataColumn FieldName="Originator" VisibleIndex="3" />
                    <dx:GridViewDataTextColumn FieldName="StartDate" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="G">                       
                        </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="G"/>
                    <dx:GridViewDataColumn FieldName="StatusText"></dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="Duration">
                       <PropertiesTextEdit DisplayFormatString="dd\.hh\:mm\:ss"></PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataColumn FieldName="ProcessName"></dx:GridViewDataColumn>
                </Columns>
                <Templates>
                    <DetailRow>
                        <dx:ASPxGridView ID="gridActInst" runat="server" KeyFieldName="Id" Width="100%" Theme="Moderno">
                            <Columns>
                                <dx:GridViewDataColumn FieldName="Id" VisibleIndex="0" />
                                <dx:GridViewDataColumn FieldName="ActivityName" VisibleIndex="1" />
                                <dx:GridViewDataColumn FieldName="DestinationUser" VisibleIndex="2" />
                                <dx:GridViewDataTextColumn FieldName="StartDate" VisibleIndex="3" PropertiesTextEdit-DisplayFormatString="G"/>
                                <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="G"/>                                
                                <dx:GridViewDataTextColumn FieldName="StatusText" VisibleIndex="5">                                  
                                </dx:GridViewDataTextColumn>
                            </Columns>                            
                        </dx:ASPxGridView>
                    </DetailRow>
                </Templates>
                <SettingsDetail ShowDetailRow="true" />
                <GroupSummary>
                    <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
                    <dx:ASPxSummaryItem FieldName="Duration" SummaryType="Average" DisplayFormat="Avg Duration: {0:dd\.hh\:mm\:ss}" />
                </GroupSummary>
            </dx:ASPxGridView>
            <h3>User Worklist</h3>
            <dx:ASPxGridView ID="GridWorklist" ClientInstanceName="gridWorklist" runat="server" KeyFieldName="Id" Width="100%" Theme="Moderno" OnHtmlRowPrepared="gridProcInst_HtmlRowPrepared">
                <Columns>
                    <dx:GridViewDataColumn FieldName="Id" VisibleIndex="0" />
                    <dx:GridViewDataColumn FieldName="ProcessName" VisibleIndex="1" />
                    <dx:GridViewDataColumn FieldName="ActivityName" VisibleIndex="2" />
                    <dx:GridViewDataColumn FieldName="DestinationUser" VisibleIndex="3" />
                    <dx:GridViewDataTextColumn FieldName="CreateDate" VisibleIndex="4" PropertiesTextEdit-DisplayFormatString="G">                       
                        </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="5" PropertiesTextEdit-DisplayFormatString="G"/>
                    <dx:GridViewDataColumn FieldName="Status"></dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="Duration">
                       <PropertiesTextEdit DisplayFormatString="dd\.hh\:mm\:ss"></PropertiesTextEdit>
                    </dx:GridViewDataTextColumn>                    
                </Columns>
                <GroupSummary>
                    <dx:ASPxSummaryItem FieldName="Id" SummaryType="Count" DisplayFormat="Count: {0}" />
                    <dx:ASPxSummaryItem FieldName="Duration" SummaryType="Average" DisplayFormat="Avg Duration: {0:dd\.hh\:mm\:ss}" />
                </GroupSummary>
            </dx:ASPxGridView>
        </div>
    </form>
</body>
</html>
