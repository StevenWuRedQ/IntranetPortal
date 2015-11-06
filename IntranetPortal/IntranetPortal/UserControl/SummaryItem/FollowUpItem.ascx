<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FollowUpItem.ascx.vb" Inherits="IntranetPortal.FollowUpItem" %>
<script type="text/javascript">
    function ShowWorklistItem(itemData, processName) {
        window.location.href = "/Task/MyTask.aspx?page=" + encodeURIComponent(itemData);
    }
</script>

<h4>
    <img src="../images/grid_task_icon.png" class="vertical-img" /><span class="heading_text">Follow Up</span></h4>

<dx:ASPxGridView runat="server" Width="100%" ID="gridFollowUp" ClientInstanceName="gridCallbackClient" KeyFieldName="BBLE" AutoGenerateColumns="false" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1" CellStyle-CssClass="cell_hover">
            <DataItemTemplate>
                <div class="group_lable" onclick='<%# Eval("BBLE")%>'><% Eval("CaseName")%></div>
            </DataItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="CallbackDate" VisibleIndex="2" Visible="false" Settings-SortMode="Custom">
            <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
            <%--change group template UI by steven--%>
            <GroupRowTemplate>
                <div>
                    <table>
                        <tr>
                            <td>
                                <img src="../images/grid_call_backs_canlender.png" /></td>
                            <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                            <td style="padding-left: 10px">
                                <div class="raund-label">
                                    <%#  Container.SummaryText.Replace("Count=", "").Replace("(", "").Replace(")", "") %>
                                </div>
                            </td>
                            <%--the round div--%>
                        </tr>
                    </table>
                </div>
            </GroupRowTemplate>
            <%-------end---------%>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataColumn Width="40px" VisibleIndex="5" EditCellStyle-BorderLeft-BorderStyle="Solid">
            <DataItemTemplate>
                <%--change the image and the size by steven--%>
                <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
            </DataItemTemplate>
        </dx:GridViewDataColumn>
    </Columns>
    <SettingsBehavior AutoExpandAllGroups="true"
        EnableRowHotTrack="True" ColumnResizeMode="NextColumn" />
    <SettingsPager ShowNumericButtons="false"></SettingsPager>
    <Styles>
        <AlternatingRow BackColor="#eff2f5"></AlternatingRow>
        <RowHotTrack BackColor="#ff400d"></RowHotTrack>

    </Styles>
    <GroupSummary>
        <dx:ASPxSummaryItem FieldName="CallbackDate" SummaryType="Count" />
    </GroupSummary>
</dx:ASPxGridView>
