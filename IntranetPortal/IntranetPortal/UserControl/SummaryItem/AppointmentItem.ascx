<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="AppointmentItem.ascx.vb" Inherits="IntranetPortal.AppointmentItem" %>

<script type="text/javascript">
    function NavigateURL(type, bble) {
        window.location.href = "/Construction/ConstructionUI.aspx?bble=" + bble;
    }
</script>
<h4>
    <img src="../images/grid_upcoming_icon.png" class="vertical-img"><span class="heading_text">Upcoming Appointments</span></h4>

<dx:ASPxGridView runat="server" Width="100%" ID="gridAppointment" ClientInstanceName="gridAppointmentClient" KeyFieldName="BBLE" Settings-ShowColumnHeaders="false" Settings-GridLines="None" Border-BorderStyle="None" SettingsPager-PageSize="5" OnDataBinding="gridAppointment_DataBinding">
    <Columns>
        <dx:GridViewDataTextColumn FieldName="LeadsName" Settings-AllowHeaderFilter="False" VisibleIndex="1">
            <DataItemTemplate>
                <div class="group_lable" onclick='<%# String.Format("NavigateURL(""{0}"",""{1}"")", "Task", Eval("BBLE"))%>'><%# HtmlBlackInfo(Eval("LeadsName")) %>  </div>
            </DataItemTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataTextColumn FieldName="ScheduleDate" PropertiesTextEdit-DisplayFormatString="d" VisibleIndex="2" GroupIndex="0" Settings-SortMode="Custom">
            <PropertiesTextEdit DisplayFormatString="d"></PropertiesTextEdit>
            <Settings AllowHeaderFilter="False" GroupInterval="Date"></Settings>
            <GroupRowTemplate>
                <%--Date: <%# Container.GroupText & Container.SummaryText.Replace("Count=", "")%>--%>
                <%--change group template UI by steven--%>
                <div style="height: 30px">
                    <table style="height: 30px">
                        <tr>
                            <td>
                                <img src="../images/grid_call_backs_canlender.png" /></td>
                            <td style="font-weight: 900; width: 80px; text-align: center;">Date: <%# Container.GroupText%></td>
                            <td style="padding-left: 10px">
                                <div class="raund-label">
                                    <%#  Container.SummaryText.Replace("Count=", "").Replace("(","").Replace(")","") %>
                                </div>
                            </td>
                            <%--the round div--%>
                        </tr>
                    </table>
                </div>
                <%-------end---------%>
            </GroupRowTemplate>
        </dx:GridViewDataTextColumn>
        <dx:GridViewDataColumn Width="40px" VisibleIndex="5" Visible="false">
            <DataItemTemplate>
                <%--change the image and the size by steven--%>
                <img src="/images/menu_flag.png" style="/*width: 16px; height: 16px; */vertical-align: bottom; cursor: pointer;" onclick='<%#String.Format("ShowCateMenu(this,{0})", Eval("BBLE")) %>' />
            </DataItemTemplate>
        </dx:GridViewDataColumn>
    </Columns>
    <GroupSummary>
        <dx:ASPxSummaryItem SummaryType="Count" />
    </GroupSummary>
    <SettingsBehavior EnableRowHotTrack="True" ColumnResizeMode="NextColumn" AutoExpandAllGroups="true" />
    <Styles>
        <AlternatingRow CssClass="gridAlternatingRow"></AlternatingRow>
    </Styles>
</dx:ASPxGridView>
