<%@ Page Language="VB" AutoEventWireup="true" MasterPageFile="~/Content.Master" CodeBehind="Calendar.aspx.vb" Inherits="IntranetPortal.Calendar" %>

<%@ Register Src="UserControl/Devexpress/CustomVerticalAppointmentTemplate.ascx" TagName="CustomVerticalAppointmentTemplate" TagPrefix="uc1" %>

<%--<asp:Content ID="Content1" ContentPlaceHolderID="Left" runat="server">
    <div class="navcontainer">
        <%-- DXCOMMENT: Configure DateNavigator for Scheduler
        <dx:ASPxDateNavigator runat="server" ID="DateNavigator" MasterControlID="Scheduler" CssClass="datenavigator">
            <Properties Rows="2" DayNameFormat="FirstLetter">
                <Style Border-BorderWidth="0"></Style>
            </Properties>
        </dx:ASPxDateNavigator>
    </div>
</asp:Content>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <dx:ASPxPageControl Width="100%" EnableViewState="false" ID="calendarPages"
        runat="server" ActiveTabIndex="0" TabSpacing="3px" EnableHierarchyRecreation="True">
        <TabPages>
            <dx:TabPage Text="Agent Calendar" Name="tabAgent">
                <ContentCollection>
                    <dx:ContentControl runat="server">
                        <dx:ASPxScheduler runat="server" ID="Scheduler" ActiveViewType="WorkWeek" Width="100%" ClientIDMode="AutoID" Theme="MetropolisBlue" Views-WorkWeekView-WorkWeekViewStyles-ScrollAreaHeight="720px">
                            <Views>
                                <DayView TimeScale="00:15:00">
                                    <VisibleTime Start="8:00" End="20:00" />
                                    <TimeRulers>
                                        <dx:TimeRuler></dx:TimeRuler>
                                    </TimeRulers>
                                    <DayViewStyles ScrollAreaHeight="720px"></DayViewStyles>
                                    <Templates>
                                        <VerticalAppointmentTemplate>
                                            <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate1" runat="server" />
                                        </VerticalAppointmentTemplate>
                                    </Templates>
                                </DayView>
                                <WorkWeekView ShowFullWeek="True" TimeScale="00:15:00">
                                    <WorkWeekViewStyles>
                                    </WorkWeekViewStyles>
                                    <VisibleTime Start="8:00" End="20:00" />
                                    <TimeRulers>
                                        <dx:TimeRuler></dx:TimeRuler>
                                    </TimeRulers>
                                    <Templates>
                                        <VerticalAppointmentTemplate>

                                            <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate2" runat="server" />

                                        </VerticalAppointmentTemplate>
                                    </Templates>
                                </WorkWeekView>
                                <WeekView Enabled="False" />
                                <MonthView CompressWeekend="false" />
                                <TimelineView Enabled="False" />
                            </Views>
                            <Storage EnableReminders="False" Appointments-ResourceSharing="true">
                                <Appointments>
                                    <%-- DXCOMMENT: Configure appointment mappings --%>
                                    <Mappings AppointmentId="AppointmentId" Start="Start" End="End" Location="Location"
                                        Subject="Subject" Description="Description" Status="Status" Label="Label" Type="Type" />
                                    <CustomFieldMappings>
                                        <dx:ASPxAppointmentCustomFieldMapping Name="Agent" ValueType="String" Member="Agent" />
                                        <dx:ASPxAppointmentCustomFieldMapping Name="Manager" ValueType="String" Member="Manager" />
                                        <dx:ASPxAppointmentCustomFieldMapping Name="AppointType" ValueType="String" Member="AppointType" />
                                    </CustomFieldMappings>
                                </Appointments>
                            </Storage>
                            <OptionsCustomization AllowAppointmentDelete="None" AllowAppointmentDrag="None" AllowAppointmentDragBetweenResources="None" AllowAppointmentMultiSelect="False" AllowAppointmentResize="None" AllowAppointmentCreate="None" />
                            <OptionsBehavior RecurrentAppointmentEditAction="Ask" />
                            <OptionsForms AppointmentFormVisibility="PopupWindow" AppointmentFormTemplateUrl="~/UserControl/Devexpress/CustomAppointmentForm.ascx" GotoDateFormVisibility="None" RecurrentAppointmentDeleteFormVisibility="None" RecurrentAppointmentEditFormVisibility="None" AppointmentInplaceEditorFormTemplateUrl="~/UserControl/Devexpress/CustomInplaceEditor.ascx" GotoDateFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/GotoDateForm.ascx" RecurrentAppointmentDeleteFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentDeleteForm.ascx" RecurrentAppointmentEditFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentEditForm.ascx" RemindersFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/ReminderForm.ascx" />
                            <OptionsToolTips AppointmentDragToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentDragToolTip.ascx" AppointmentToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentToolTip.ascx" SelectionToolTipUrl="~/DevExpress/ASPxSchedulerForms/SelectionToolTip.ascx" />
                            <BorderLeft BorderWidth="0" />
                        </dx:ASPxScheduler>
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
            <dx:TabPage Text="Office Calendar" Name="tabOffice">
                <ContentCollection>
                    <dx:ContentControl runat="server">
                          <dx:ASPxScheduler runat="server" ID="officeScheduler" ActiveViewType="WorkWeek" Width="100%" ClientIDMode="AutoID" Theme="MetropolisBlue" Views-WorkWeekView-WorkWeekViewStyles-ScrollAreaHeight="720px">
                            <Views>
                                <DayView TimeScale="00:15:00">
                                    <VisibleTime Start="8:00" End="20:00" />
                                    <TimeRulers>
                                        <dx:TimeRuler></dx:TimeRuler>
                                    </TimeRulers>
                                    <DayViewStyles ScrollAreaHeight="720px"></DayViewStyles>
                                    <Templates>
                                        <VerticalAppointmentTemplate>
                                            <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate1" runat="server" />
                                        </VerticalAppointmentTemplate>
                                    </Templates>
                                </DayView>
                                <WorkWeekView ShowFullWeek="True" TimeScale="00:15:00">
                                    <WorkWeekViewStyles>
                                    </WorkWeekViewStyles>
                                    <VisibleTime Start="8:00" End="20:00" />
                                    <TimeRulers>
                                        <dx:TimeRuler></dx:TimeRuler>
                                    </TimeRulers>
                                    <Templates>
                                        <VerticalAppointmentTemplate>

                                            <uc1:CustomVerticalAppointmentTemplate ID="CustomVerticalAppointmentTemplate2" runat="server" />

                                        </VerticalAppointmentTemplate>
                                    </Templates>
                                </WorkWeekView>
                                <WeekView Enabled="False" />
                                <MonthView CompressWeekend="false" />
                                <TimelineView Enabled="False" />
                            </Views>
                            <Storage EnableReminders="False" Appointments-ResourceSharing="true">
                                <Appointments>
                                    <%-- DXCOMMENT: Configure appointment mappings --%>
                                    <Mappings AppointmentId="AppointmentId" Start="Start" End="End" Location="Location"
                                        Subject="Subject" Description="Description" Status="Status" Label="Label" Type="Type" />
                                    <CustomFieldMappings>
                                        <dx:ASPxAppointmentCustomFieldMapping Name="Agent" ValueType="String" Member="Agent" />
                                        <dx:ASPxAppointmentCustomFieldMapping Name="Manager" ValueType="String" Member="Manager" />
                                        <dx:ASPxAppointmentCustomFieldMapping Name="AppointType" ValueType="String" Member="AppointType" />
                                    </CustomFieldMappings>
                                </Appointments>
                            </Storage>
                            <OptionsCustomization AllowAppointmentDelete="None" AllowAppointmentDrag="None" AllowAppointmentDragBetweenResources="None" AllowAppointmentMultiSelect="False" AllowAppointmentResize="None" AllowAppointmentCreate="None" />
                            <OptionsBehavior RecurrentAppointmentEditAction="Ask" />
                            <OptionsForms AppointmentFormVisibility="PopupWindow" AppointmentFormTemplateUrl="~/UserControl/Devexpress/CustomAppointmentForm.ascx" GotoDateFormVisibility="None" RecurrentAppointmentDeleteFormVisibility="None" RecurrentAppointmentEditFormVisibility="None" AppointmentInplaceEditorFormTemplateUrl="~/UserControl/Devexpress/CustomInplaceEditor.ascx" GotoDateFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/GotoDateForm.ascx" RecurrentAppointmentDeleteFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentDeleteForm.ascx" RecurrentAppointmentEditFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/RecurrentAppointmentEditForm.ascx" RemindersFormTemplateUrl="~/DevExpress/ASPxSchedulerForms/ReminderForm.ascx" />
                            <OptionsToolTips AppointmentDragToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentDragToolTip.ascx" AppointmentToolTipUrl="~/DevExpress/ASPxSchedulerForms/AppointmentToolTip.ascx" SelectionToolTipUrl="~/DevExpress/ASPxSchedulerForms/SelectionToolTip.ascx" />
                            <BorderLeft BorderWidth="0" />
                        </dx:ASPxScheduler>
                    </dx:ContentControl>
                </ContentCollection>
            </dx:TabPage>
        </TabPages>
    </dx:ASPxPageControl>


</asp:Content>
