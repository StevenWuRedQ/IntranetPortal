<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.CustomAppointmentForm" CodeBehind="CustomAppointmentForm.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler.Controls" TagPrefix="dxsc" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>

<div runat="server" id="ValidationContainer">
    <table class="dxscAppointmentForm" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%; height: 230px;">
        <tr>
            <td class="dxscDoubleCell" colspan="2">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell">
                            <dxe:ASPxLabel ID="lblSubject" runat="server" AssociatedControlID="tbSubject">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxTextBox ClientInstanceName="_dx" ID="tbSubject" runat="server" Width="100%" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Subject%>' />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="dxscSingleCell">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell">
                            <dxe:ASPxLabel ID="lblLocation" runat="server" AssociatedControlID="tbLocation">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxTextBox ClientInstanceName="_dx" ID="tbLocation" runat="server" Width="100%" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.Location%>' />
                        </td>
                    </tr>
                </table>
            </td>
            <td class="dxscSingleCell">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell" style="padding-left: 25px;">
                            <dxe:ASPxLabel ID="lblType" runat="server" AssociatedControlID="edtLabel" Text="Type">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxTextBox ClientInstanceName="_dx" ID="txtType" runat="server" Width="100%" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.CustomFields("AppointType").ToString %>' />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="dxscSingleCell">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell">
                            <dxe:ASPxLabel ID="lblStartDate" runat="server" AssociatedControlID="edtStartDate" Wrap="false">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxDateEdit ID="edtStartDate" runat="server" Width="100%" Date='<%#(CType(Container, AppointmentFormTemplateContainer)).Start%>' EditFormat="DateTime" DateOnError="Undo" AllowNull="false" EnableClientSideAPI="true">
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" EnableCustomValidation="True" Display="Dynamic"
                                    ValidationGroup="DateValidatoinGroup">
                                </ValidationSettings>
                            </dxe:ASPxDateEdit>
                        </td>
                    </tr>
                </table>
            </td>
            <td class="dxscSingleCell">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell" style="padding-left: 25px;">
                            <dxe:ASPxLabel runat="server" ID="lblEndDate" Wrap="false" AssociatedControlID="edtEndDate" />
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxDateEdit ID="edtEndDate" runat="server" Date='<%#(CType(Container, AppointmentFormTemplateContainer)).End%>' EditFormat="DateTime" Width="100%" DateOnError="Undo" AllowNull="false" EnableClientSideAPI="true">
                                <ValidationSettings ErrorDisplayMode="ImageWithTooltip" EnableCustomValidation="True" Display="Dynamic"
                                    ValidationGroup="DateValidatoinGroup">
                                </ValidationSettings>
                            </dxe:ASPxDateEdit>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="dxscSingleCell">
                <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell">
                            <dxe:ASPxLabel ID="lblAgent" runat="server" AssociatedControlID="edtStatus" Wrap="false" Text="Agent">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxTextBox ClientInstanceName="_dx" ID="txtAgent" runat="server" Width="100%" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.CustomFields("Agent").ToString %>' />

                        </td>
                    </tr>
                </table>
            </td>
            <td class="dxscSingleCell" style="padding-left: 22px;">
                 <table class="dxscLabelControlPair" <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
                    <tr>
                        <td class="dxscLabelCell">
                            <dxe:ASPxLabel ID="lblManger" runat="server" AssociatedControlID="edtStatus" Wrap="false" Text="Manager">
                            </dxe:ASPxLabel>
                        </td>
                        <td class="dxscControlCell">
                            <dxe:ASPxTextBox ClientInstanceName="_dx" ID="ASPxTextBox1" runat="server" Width="100%" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.CustomFields("Manager").ToString %>' />

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="dxscDoubleCell" colspan="2" style="height: 90px;">
                <dxe:ASPxMemo ClientInstanceName="_dx" ID="tbDescription" runat="server" Width="100%" Rows="6" Text='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.Description%>' />
            </td>
        </tr>
    </table>
</div>

<dxsc:AppointmentRecurrenceForm ID="AppointmentRecurrenceForm1" runat="server"
    IsRecurring='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.IsRecurring%>'
    DayNumber='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceDayNumber%>'
    End='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceEnd%>'
    Month='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceMonth%>'
    OccurrenceCount='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceOccurrenceCount%>'
    Periodicity='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrencePeriodicity%>'
    RecurrenceRange='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceRange%>'
    Start='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceStart%>'
    WeekDays='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceWeekDays%>'
    WeekOfMonth='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceWeekOfMonth%>'
    RecurrenceType='<%#(CType(Container, AppointmentFormTemplateContainer)).RecurrenceType%>'
    IsFormRecreated='<%#(CType(Container, AppointmentFormTemplateContainer)).IsFormRecreated%>'>
</dxsc:AppointmentRecurrenceForm>

<table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%; height: 35px;">
    <tr>
        <td class="dx-ac" style="width: 100%; height: 100%;" <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, "center", Nothing)%>>
            <table class="dxscButtonTable" style="height: 100%">
                <tr>
                    <td class="dxscCellWithPadding">
                        <dxe:ASPxButton runat="server" ID="btnOk" UseSubmitBehavior="false" AutoPostBack="false" Visible="false"
                            EnableViewState="false" Width="91px" EnableClientSideAPI="true" />
                    </td>
                    <td class="dxscCellWithPadding">
                        <dxe:ASPxButton runat="server" ID="btnCancel" UseSubmitBehavior="false" AutoPostBack="false" EnableViewState="false"
                            Width="91px" CausesValidation="False" EnableClientSideAPI="true" Text="Close" />
                    </td>
                    <td class="dxscCellWithPadding">
                        <dxe:ASPxButton runat="server" ID="btnDelete" UseSubmitBehavior="false" Visible="false"
                            AutoPostBack="false" EnableViewState="false" Width="91px"
                            Enabled='<%#(CType(Container, AppointmentFormTemplateContainer)).CanDeleteAppointment%>'
                            CausesValidation="False" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%;">
    <tr>
        <td class="dx-al" style="width: 100%;" <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, "left", Nothing)%>>
            <dxsc:ASPxSchedulerStatusInfo runat="server" ID="schedulerStatusInfo" Priority="1" MasterControlID='<%#(CType(Container, DevExpress.Web.ASPxScheduler.AppointmentFormTemplateContainer)).ControlId%>' />
        </td>
    </tr>
</table>
<script id="dxss_ASPxSchedulerAppoinmentForm" type="text/javascript">
    ASPxAppointmentForm = ASPx.CreateClass(ASPxClientFormBase, {
        Initialize: function () {
            this.controls.edtStartDate.Validation.AddHandler(ASPx.CreateDelegate(this.OnEdtStartDateValidate, this));
            this.controls.edtEndDate.Validation.AddHandler(ASPx.CreateDelegate(this.OnEdtEndDateValidate, this));
            this.controls.edtStartDate.ValueChanged.AddHandler(ASPx.CreateDelegate(this.OnUpdateStartEndValue, this));
            this.controls.edtEndDate.ValueChanged.AddHandler(ASPx.CreateDelegate(this.OnUpdateStartEndValue, this));
            if (this.controls.chkReminder)
                this.controls.chkReminder.CheckedChanged.AddHandler(ASPx.CreateDelegate(this.OnChkReminderCheckedChanged, this));
            if (this.controls.edtMultiResource)
                this.controls.edtMultiResource.SelectedIndexChanged.AddHandler(ASPx.CreateDelegate(this.OnEdtMultiResourceSelectedIndexChanged, this));
        },
        OnEdtMultiResourceSelectedIndexChanged: function (s, e) {
            var resourceNames = new Array();
            var items = s.GetSelectedItems();
            var count = items.length;
            if (count > 0) {
                for (var i = 0; i < count; i++)
                    resourceNames.push(items[i].text);
            }
            else
                resourceNames.push(ddResource.cp_Caption_ResourceNone);
            ddResource.SetValue(resourceNames.join(', '));
        },
        OnEdtStartDateValidate: function (s, e) {
            if (!e.isValid)
                return;
            var startDate = this.controls.edtStartDate.GetDate();
            var endDate = this.controls.edtEndDate.GetDate();
            e.isValid = startDate == null || endDate == null || startDate <= endDate;
            e.errorText = "The Start Date must precede the End Date.";
        },
        OnEdtEndDateValidate: function (s, e) {
            if (!e.isValid)
                return;
            var startDate = this.controls.edtStartDate.GetDate();
            var endDate = this.controls.edtEndDate.GetDate();
            e.isValid = startDate == null || endDate == null || startDate <= endDate;
            e.errorText = "The Start Date must precede the End Date.";
        },
        OnUpdateStartEndValue: function (s, e) {
            var isValid = ASPxClientEdit.ValidateEditorsInContainer(null);
            this.controls.btnOk.SetEnabled(isValid);
        },
        OnChkReminderCheckedChanged: function (s, e) {
            var isReminderEnabled = this.controls.chkReminder.GetValue();
            if (isReminderEnabled)
                this.controls.cbReminder.SetSelectedIndex(3);
            else
                this.controls.cbReminder.SetSelectedIndex(-1);
            this.controls.cbReminder.SetEnabled(isReminderEnabled);
        }
    });
</script>
