<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FollowUpItem.ascx.vb" Inherits="IntranetPortal.FollowUpItem" %>
<script type="text/javascript">
    function ShowWorklistItem(itemData, processName) {
        window.location.href = "/Task/MyTask.aspx?page=" + encodeURIComponent(itemData);
    }

    var fileWindows = {};
    function ShowCaseInfo(url, CaseId) {
        for (var win in fileWindows) {
            if (fileWindows.hasOwnProperty(win) && win == CaseId) {
                var caseWin = fileWindows[win];
                if (!caseWin.closed) {
                    caseWin.focus();
                    return;
                }
            }
        }
        
        var left = (screen.width / 2) - (1350 / 2);
        var top = (screen.height / 2) - (930 / 2);        
        var win = window.open(url, 'View Case Info ' + CaseId, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
        fileWindows[CaseId] = win;
    }

    function ClearFollowUp(followUpId)
    {
        AngularRoot.confirm("Are you sure to clear?").then(function (r) {
            if (r) {
                gridFollowUp.PerformCallback("Clear|" + followUpId);
            }
        });
    }
</script>

<h4 style="padding-top:5px">
    <img src="../images/grid_task_icon.png" class="vertical-img" /><span class="heading_text">Follow Up</span></h4>

<dx:ASPxGridView runat="server" Width="100%" ID="gridFollowUp" ClientInstanceName="gridFollowUp" KeyFieldName="BBLE" AutoGenerateColumns="false" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" Paddings-PaddingTop="10px" SettingsPager-PageSize="6" OnCustomCallback="gridFollowUp_CustomCallback">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="CaseName" Settings-AllowHeaderFilter="False" VisibleIndex="1" CellStyle-CssClass="cell_hover">
            <DataItemTemplate>
                <div class="group_lable" onclick='<%# String.Format("ShowCaseInfo(""{0}"", ""{1}"")", Eval("URL"), Eval("BBLE"))%>'><%# Eval("CaseName")%></div>
            </DataItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="FollowUpDate" VisibleIndex="2" Visible="false" Settings-SortMode="Custom">
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
                <i class="fa fa-check" style="cursor:pointer" title="Clear" onclick="ClearFollowUp(<%# Eval("FollowUpId") %>)"></i>
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
        <dx:ASPxSummaryItem FieldName="FollowUpDate" SummaryType="Count" />
    </GroupSummary>
</dx:ASPxGridView>
