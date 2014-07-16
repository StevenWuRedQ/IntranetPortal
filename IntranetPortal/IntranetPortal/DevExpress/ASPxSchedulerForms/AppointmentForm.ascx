<%--
{************************************************************************************}
{                                                                                    }
{   DO NOT MODIFY THIS FILE!                                                         }
{                                                                                    }
{   It will be overwritten without prompting when a new version becomes              }
{   available. All your changes will be lost.                                        }
{                                                                                    }
{   This file contains the default template and is required for the form             }
{   rendering. Improper modifications may result in incorrect behavior of            }
{   the appointment form.                                                            }
{                                                                                    }
{   In order to create and use your own custom template, perform the following       }
{   steps:                                                                           }
{       1. Save a copy of this file with a different name in another location.       }
{       2. Specify the file location as the 'OptionsForms.AppointmentFormTemplateUrl'}
{          property of the ASPxScheduler control.                                    }
{       3. If you need custom fields to be displayed and processed, you should       }
{          accomplish steps 4-9; otherwise, go to step 10.                           }
{       4. Create a class, derived from the AppointmentFormTemplateContainer,        }
{          containing custom properties. This class definition can be located        }
{          within a class file in the App_Code folder.                               }
{       5. Replace AppointmentFormTemplateContainer references in the template       }
{          page with the name of the class you've created in step 4.                 }
{       6. Handle the AppointmentFormShowing event to create an instance of the      }
{          template container class, defined in step 4, and specify it as the        }
{          destination container instead of the default one.                         }
{       7. Define a class, which inherits from the                                   }
{          DevExpress.Web.ASPxScheduler.Internal.AppointmentFormController.          }
{          This class provides data exchange between the form and the appointment.   }
{          You should override ApplyCustomFieldsValues() method of the base class.   }
{       8. Define a class, which inherits from the                                   }
{          DevExpress.Web.ASPxScheduler.Internal.AppointmentFormSaveCallbackCommand. }
{          This class creates an instance of the AppointmentFormController inheritor }
{          (defined in step 7) via the CreateAppointmentFormController method and    }
{          overrides the AssignControllerValues method  of the base class to collect }
{          user data from the form's editors.                                        }
{       9. Handle the BeforeExecuteCallbackCommand event. The event handler code     }
{          should create an instance of the class defined in step 8, and specify it  }
{          as the destination command instead of the default one.                    }
{      10. Modify the overall appearance of the page and its layout.                 }
{                                                                                    }
{************************************************************************************}
--%>

<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.AppointmentForm" Codebehind="AppointmentForm.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v14.1, Version=14.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler.Controls" TagPrefix="dxsc" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v14.1, Version=14.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>

<div runat="server" id="ValidationContainer">
	<table class="dxscAppointmentForm" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%; height: 230px;">
	<tr>
		<td class="dxscDoubleCell" colspan="2">
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
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
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
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
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell" style="padding-left: 25px;">
						<dxe:ASPxLabel ID="lblLabel" runat="server" AssociatedControlID="edtLabel">
						</dxe:ASPxLabel>
					</td>
					<td class="dxscControlCell">
						<dxe:ASPxComboBox ClientInstanceName="_dx" ID="edtLabel" runat="server" Width="100%" ValueType="System.Int32" DataSource='<%#(CType(Container, AppointmentFormTemplateContainer)).LabelDataSource%>' />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="dxscSingleCell">
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell">
						<dxe:ASPxLabel ID="lblStartDate" runat="server" AssociatedControlID="edtStartDate" Wrap="false">
						</dxe:ASPxLabel>
					</td>
					<td class="dxscControlCell">
						<dxe:ASPxDateEdit ID="edtStartDate" runat="server" Width="100%" Date='<%#(CType(Container, AppointmentFormTemplateContainer)).Start%>' EditFormat="DateTime" DateOnError="Undo" AllowNull="false" EnableClientSideAPI="true" >
							<ValidationSettings ErrorDisplayMode="ImageWithTooltip" EnableCustomValidation="True" Display="Dynamic"
								ValidationGroup="DateValidatoinGroup">
							</ValidationSettings>
						</dxe:ASPxDateEdit>
					</td>
				</tr>
			</table>
		</td>
		<td class="dxscSingleCell">
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell" style="padding-left: 25px;">
						<dxe:ASPxLabel runat="server" ID="lblEndDate" Wrap="false" AssociatedControlID="edtEndDate"/>
					</td>
					<td class="dxscControlCell">
						<dxe:ASPxDateEdit id="edtEndDate" runat="server" Date='<%#(CType(Container, AppointmentFormTemplateContainer)).End%>' EditFormat="DateTime" Width="100%" DateOnError="Undo" AllowNull="false" EnableClientSideAPI="true">
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
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell">
						<dxe:ASPxLabel ID="lblStatus" runat="server" AssociatedControlID="edtStatus" Wrap="false">
						</dxe:ASPxLabel>
					</td>
					<td class="dxscControlCell">
						<dxe:ASPxComboBox ClientInstanceName="_dx" ID="edtStatus" runat="server" Width="100%" ValueType="System.Int32" DataSource='<%#(CType(Container, AppointmentFormTemplateContainer)).StatusDataSource%>' />
					</td>
				</tr>
			</table>
		</td>
		<td class="dxscSingleCell" style="padding-left: 22px;">
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td style="width: 20px; height: 20px;">
						<dxe:ASPxCheckBox ClientInstanceName="_dx" ID="chkAllDay" runat="server" Checked='<%#(CType(Container, AppointmentFormTemplateContainer)).Appointment.AllDay%>'>
						</dxe:ASPxCheckBox>
					</td>
					<td style="padding-left: 2px;">
						<dxe:ASPxLabel ID="lblAllDay" runat="server" AssociatedControlID="chkAllDay" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
<%
   If CanShowReminders Then
%>
		<td class="dxscSingleCell">
<%
   Else
%>
		<td class="dxscDoubleCell" colspan="2">
<%
   End If
%>
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell">
						<dxe:ASPxLabel ID="lblResource" runat="server" AssociatedControlID="edtResource">
						</dxe:ASPxLabel>
					</td>
					<td class="dxscControlCell">
<%
   If ResourceSharing Then
%>
						<dxe:ASPxDropDownEdit id="ddResource" runat="server" Width="100%" ClientInstanceName="ddResource" Enabled='<%#(CType(Container, AppointmentFormTemplateContainer)).CanEditResource%>' AllowUserInput="false">
							<DropDownWindowTemplate>
								<dxe:ASPxListBox id="edtMultiResource" runat="server" width="100%" SelectionMode="CheckColumn" DataSource='<%#ResourceDataSource%>' Border-BorderWidth="0"/>
							</DropDownWindowTemplate>
						</dxe:ASPxDropDownEdit>                        
<%
   Else
%>
						<dxe:ASPxComboBox ClientInstanceName="_dx" ID="edtResource" runat="server" Width="100%" DataSource='<%#ResourceDataSource%> ' Enabled='<%#(CType(Container, AppointmentFormTemplateContainer)).CanEditResource%>' />
<%
   End If
%>
					</td>

				</tr>
			</table>
		</td>
<%
   If CanShowReminders Then
%>
		<td class="dxscSingleCell">
			<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
				<tr>
					<td class="dxscLabelCell" style="padding-left: 22px;">
						<table class="dxscLabelControlPair" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %>>
							<tr>
								<td style="width: 20px; height: 20px;">
									<dxe:ASPxCheckBox ID="chkReminder" runat="server"> 
									</dxe:ASPxCheckBox>
								</td>
								<td style="padding-left: 2px;">
									<dxe:ASPxLabel ID="lblReminder" runat="server" AssociatedControlID="chkReminder" />
								</td>
							</tr>
						</table>
					</td>
					<td class="dxscControlCell" style="padding-left: 3px">
						<dxe:ASPxComboBox  ID="cbReminder" runat="server" Width="100%" DataSource='<%#(CType(Container, AppointmentFormTemplateContainer)).ReminderDataSource%>' />
					</td>
				</tr>
			</table>
		</td>
<%
   End If
%>
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
	IsFormRecreated='<%#(CType(Container, AppointmentFormTemplateContainer)).IsFormRecreated%>' >
</dxsc:AppointmentRecurrenceForm>

<table <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%; height: 35px;">
	<tr>
		<td class="dx-ac" style="width: 100%; height: 100%;" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetAlignAttributes(Me, "center", Nothing)%>>
			<table class="dxscButtonTable" style="height: 100%">
				<tr>
					<td class="dxscCellWithPadding">
						<dxe:ASPxButton runat="server" ID="btnOk" UseSubmitBehavior="false" AutoPostBack="false" 
							EnableViewState="false" Width="91px" EnableClientSideAPI="true"/>
					</td>
					<td class="dxscCellWithPadding">
						<dxe:ASPxButton runat="server" ID="btnCancel" UseSubmitBehavior="false" AutoPostBack="false" EnableViewState="false" 
							Width="91px" CausesValidation="False" EnableClientSideAPI="true" />
					</td>
					<td class="dxscCellWithPadding">
						<dxe:ASPxButton runat="server" ID="btnDelete" UseSubmitBehavior="false"
							AutoPostBack="false" EnableViewState="false" Width="91px"
							Enabled='<%#(CType(Container, AppointmentFormTemplateContainer)).CanDeleteAppointment%>'
							CausesValidation="False" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetTableSpacings(Me, 0, 0) %> style="width: 100%;">
	<tr>
		<td class="dx-al" style="width: 100%;" <%= DevExpress.Web.ASPxClasses.Internal.RenderUtils.GetAlignAttributes(Me, "left", Nothing)%>>
			<dxsc:ASPxSchedulerStatusInfo runat="server" ID="schedulerStatusInfo" Priority="1" MasterControlId='<%#(CType(Container, DevExpress.Web.ASPxScheduler.AppointmentFormTemplateContainer)).ControlId%>' />
		</td>
	</tr>
</table>
<script id="dxss_ASPxSchedulerAppoinmentForm" type="text/javascript">
	ASPxAppointmentForm = _aspxCreateClass(ASPxClientFormBase, {
		Initialize: function () {
			this.controls.edtStartDate.Validation.AddHandler(_aspxCreateDelegate(this.OnEdtStartDateValidate, this));
			this.controls.edtEndDate.Validation.AddHandler(_aspxCreateDelegate(this.OnEdtEndDateValidate, this));
			this.controls.edtStartDate.ValueChanged.AddHandler(_aspxCreateDelegate(this.OnUpdateStartEndValue, this));
			this.controls.edtEndDate.ValueChanged.AddHandler(_aspxCreateDelegate(this.OnUpdateStartEndValue, this));
			if (this.controls.chkReminder)
				this.controls.chkReminder.CheckedChanged.AddHandler(_aspxCreateDelegate(this.OnChkReminderCheckedChanged, this));
			if (this.controls.edtMultiResource)
				this.controls.edtMultiResource.SelectedIndexChanged.AddHandler(_aspxCreateDelegate(this.OnEdtMultiResourceSelectedIndexChanged, this));
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