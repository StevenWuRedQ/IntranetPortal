<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CalendarItem.ascx.vb" Inherits="IntranetPortal.CalendarItem" %>
<%@ Register Src="~/UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>

<h4>
    <img src="../images/grid_calendar.png" class="vertical-img" /><span class="heading_text">Today's Calendar</span>
</h4>
<div style="margin-top: 60px">
    <dx:ASPxScheduler ID="todayScheduler" runat="server" Width="100%" ActiveViewType="Day" OnPopupMenuShowing="todayScheduler_PopupMenuShowing"
        ClientInstanceName="ASPxClientScheduler1">
        <Views>
            <DayView ShowAllDayArea="False" ShowWorkTimeOnly="True" NavigationButtonVisibility="Never">
                <WorkTime End="23:00:00" Start="08:00:00" />
                <TimeRulers>
                    <dx:TimeRuler />
                </TimeRulers>
                <Templates>
                    <VerticalAppointmentTemplate>
                        <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate1" runat="server" />
                    </VerticalAppointmentTemplate>
                </Templates>
            </DayView>
            <WorkWeekView Enabled="False">
                <TimeRulers>
                    <dx:TimeRuler />
                </TimeRulers>
            </WorkWeekView>
            <WeekView Enabled="False" />
            <MonthView Enabled="False" />
            <TimelineView Enabled="False">
            </TimelineView>
        </Views>
        <OptionsBehavior ShowViewSelector="False" ShowViewNavigator="False" ShowViewNavigatorGotoDateButton="False" ShowViewVisibleInterval="False" />
        <OptionsCustomization AllowAppointmentDelete="None" AllowAppointmentDrag="None" AllowAppointmentDragBetweenResources="None" AllowAppointmentMultiSelect="False" AllowAppointmentResize="None" AllowAppointmentCreate="None" />
        <OptionsForms AppointmentFormVisibility="PopupWindow" AppointmentFormTemplateUrl="~/UserControl/Devexpress/CustomAppointmentForm.ascx" GotoDateFormVisibility="None" RecurrentAppointmentDeleteFormVisibility="None" RecurrentAppointmentEditFormVisibility="None" AppointmentInplaceEditorFormTemplateUrl="~/UserControl/Devexpress/CustomInplaceEditor.ascx" GotoDateFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/GotoDateForm.ascx" RecurrentAppointmentDeleteFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentDeleteForm.ascx" RecurrentAppointmentEditFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentEditForm.ascx" RemindersFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/ReminderForm.ascx" />
        <OptionsToolTips AppointmentDragToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentDragToolTip.ascx" AppointmentToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentToolTip.ascx" SelectionToolTipUrl="~/DevExpress/ASPxSchedulerForms/SelectionToolTip.ascx" />
        <Storage EnableReminders="False" Appointments-ResourceSharing="true">
            <Appointments>
                <%-- DXCOMMENT: Configure appointment mappings --%>
                <Mappings AppointmentId="AppointmentId" Start="Start" End="End" Location="Location"
                    Subject="Subject" Description="Description" Status="Status" Label="Label" Type="Type" />
                <CustomFieldMappings>
                    <dx:ASPxAppointmentCustomFieldMapping Name="Agent" ValueType="String" Member="Agent" />
                    <dx:ASPxAppointmentCustomFieldMapping Name="Manager" ValueType="String" Member="Manager" />
                    <dx:ASPxAppointmentCustomFieldMapping Name="AppointType" ValueType="String" Member="AppointType" />
                    <dx:ASPxAppointmentCustomFieldMapping Name="TitleLink" ValueType="String" Member="TitleLink" />
                </CustomFieldMappings>
            </Appointments>
        </Storage>
    </dx:ASPxScheduler>
</div>
