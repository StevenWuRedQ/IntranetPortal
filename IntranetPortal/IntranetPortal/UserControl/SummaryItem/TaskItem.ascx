<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TaskItem.ascx.vb" Inherits="IntranetPortal.TaskItem" %>
<script type="text/javascript">
    function ShowWorklistItem(itemData, processName) {
        window.location.href = "/Task/MyTask.aspx?page=" + encodeURIComponent(itemData);
    }
</script>

<h4>
    <img src="../images/grid_task_icon.png" class="vertical-img" /><span class="heading_text">Task</span></h4>

<dx:ASPxGridView runat="server" Width="100%" ID="gridTask" KeyFieldName="ProcInstId;ActInstId" ClientInstanceName="gridTaskClient"
    OnDataBinding="gridTask_DataBinding" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="DisplayName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
            <Settings AutoFilterCondition="Contains" />
            <DataItemTemplate>
                <div style="cursor: pointer; height: 30px; padding-left: 20px; line-height: 30px;" onclick='ShowWorklistItem("<%# Eval("ItemData")%>", "<%# Eval("ProcessName")%>")'><%# Eval("DisplayName")%></div>
            </DataItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="StartDate" Visible="false" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" Caption="Date">
            <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
            <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataColumn FieldName="ActivityName" Visible="false" VisibleIndex="3">
        </dx:GridViewDataColumn>
        <dx:GridViewDataColumn FieldName="ProcSchemeDisplayName" Visible="false" VisibleIndex="5">
            <GroupRowTemplate>
                <div>
                    <table style="height: 45px">
                        <tr onclick="ExpandOrCollapseGroupRow(<%# Container.VisibleIndex%>)" style="cursor: pointer">
                            <td style="width: 80px;">
                                <span class="font_black">
                                    <i class="fa fa-user font_16"></i><span class="group_text_margin"><%#  Container.GroupText  %> &nbsp;</span>
                                </span>
                            </td>
                            <td style="padding-left: 10px">
                                <span class="employee_lest_head_number_label"><%# Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "")%></span>
                            </td>
                        </tr>
                    </table>
                </div>
            </GroupRowTemplate>
        </dx:GridViewDataColumn>
        <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
            <DataItemTemplate>
                <%--change the image and the size by steven--%>
                <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer; visibility: hidden;" />
            </DataItemTemplate>
        </dx:GridViewDataColumn>
    </Columns>
    <GroupSummary>
        <dx:ASPxSummaryItem SummaryType="Count" />
    </GroupSummary>    
    <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
    <SettingsPager ShowNumericButtons="false"></SettingsPager>
    <Styles>
        <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
        <RowHotTrack BackColor="#ff400d" ForeColor="White"></RowHotTrack>
    </Styles>
</dx:ASPxGridView>
