<%--
{************************************************************************************}
{                                                                                    }
{   DO NOT MODIFY THIS FILE!                                                         }
{                                                                                    }
{   It will be overwritten without prompting when a new version becomes              }
{   available. All your changes will be lost.                                        }
{                                                                                    }
{   This file contains the default template and is required for the appointment      }
{   rendering. Improper modifications may result in incorrect appearance of the      }
{   appointment.                                                                     }
{                                                                                    }
{   In order to create and use your own custom template, perform the following       }
{   steps:                                                                           }
{       1. Save a copy of this file with a different name in another location.       }
{       2. Add a Register tag in the .aspx page header for each template you use,    }
{          as follows: <%@ Register Src="PathToTemplateFile" TagName="NameOfTemplate"}
{          TagPrefix="ShortNameOfTemplate" %>                                        }
{       3. In the .aspx page find the tags for different scheduler views within      }
{          the ASPxScheduler control tag. Insert template tags into the tags         }
{          for the views which should be customized.                                 }
{          The template tag should satisfy the following pattern:                    }
{          <Templates>                                                               }
{              <HorizontalSameDayAppointmentTemplate>                                }
{                  <ShortNameOfTemplate: NameOfTemplate runat="server"/>             }
{              </HorizontalSameDayAppointmentTemplate>                               }
{          </Templates>                                                              }
{          where ShortNameOfTemplate, NameOfTemplate are the names of the            }
{          registered templates, defined in step 2.                                  }
{************************************************************************************}
--%>
<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.HorizontalSameDayAppointmentTemplate" Codebehind="HorizontalSameDayAppointmentTemplate.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dxe" %>
<div id="appointmentDiv" runat="server" class='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.AppointmentStyle.CssClass%>'>
	<table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0)%> style="width: 100%">
		<tr>
			<td runat="server" id="statusContainer" style="vertical-align: top">    
			</td>
		</tr>
		<tr>
			<td>
				<table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 1, 0)%> style="width: 100%">
					<tr class="dx-al" <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, "left", "middle") %> style="vertical-align: middle;">
						<td runat="server" id="startTimeClockContainer" class="dxscCellWithPadding"> 
						</td>
						<td>
							<dxe:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="true" ID="lblStartTime" Text='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.StartTimeText.Text%>' Visible='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.StartTimeText.Visible%>'></dxe:ASPxLabel>            
						</td>
						<td runat="server" id="endTimeClockContainer" class="dxscCellWithPadding">
						</td>
						<td class="dxscCellWithPadding">
							<dxe:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="true" ID="lblEndTime" Text='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.EndTimeText.Text%>' Visible='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.EndTimeText.Visible%>'></dxe:ASPxLabel>
						</td>
						<td class="dxscCellWithPadding">
							<table id="imageContainer" runat="server" style="vertical-align: middle;">                            
							</table>
						</td>
						<td class="dxscCellWithPadding" style="width: 100%">
							<dxe:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="true" ID="lblTitle" Text='<%#(CType(Container, HorizontalAppointmentTemplateContainer)).Items.Title.Text%>'> </dxe:ASPxLabel>            
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>