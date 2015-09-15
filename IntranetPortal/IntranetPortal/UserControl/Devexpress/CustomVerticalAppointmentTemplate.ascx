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
{              <VerticalAppointmentTemplate>                                         }
{                  < ShortNameOfTemplate: NameOfTemplate runat="server"/>            }
{              </VerticalAppointmentTemplate>                                        }
{          </Templates>                                                              }
{          where ShortNameOfTemplate, NameOfTemplate are the names of the            }
{          registered templates, defined in step 2.                                  }
{************************************************************************************}
--%>
<%@ Control Language="vb" AutoEventWireup="true" Inherits="IntranetPortal.CustomVerticalAppointmentTemplate" Codebehind="CustomVerticalAppointmentTemplate.ascx.vb" %>
<%@ Register Assembly="DevExpress.Web.ASPxScheduler.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxScheduler" TagPrefix="dxwschs" %>
<%@ Register Assembly="DevExpress.Web.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dxe" %>
   <div id="appointmentDiv" runat="server" class='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.AppointmentStyle.CssClass%>' style="background-color: #A8D5FF">
                            <table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 0, 0)%> style="width: 100%;background-color: #A8D5FF">
                                <tr <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, Nothing, "top")%> style="vertical-align: top">
                                    <td runat="server" id="statusContainer"></td>
                                    <td style="width: 100%">
                                        <table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 1, 0)%> style="width: 100%;">
                                            <tr <%= DevExpress.Web.Internal.RenderUtils.GetAlignAttributes(Me, Nothing, "top")%> style="vertical-align: top">
                                                <td class="dxscCellWithPadding">
                                                    <table id="imageContainer" runat="server" style="text-align: center">
                                                        <tr>
                                                            <td class="dxscCellWithPadding"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td class="dxscCellWithPadding" style="width: 100%;">
                                                    <table <%= DevExpress.Web.Internal.RenderUtils.GetTableSpacings(Me, 1, 0)%> style="width: 100%; font-size:11px;">
                                                        <tr>
                                                            <td class="dxscCellWithPadding" colspan="2">
                                                                <dx:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="true" ID="lblStartTime" Text='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.StartTimeText.Text%>' Visible='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.StartTimeText.Visible%>'></dx:ASPxLabel>
                                                                <dx:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="true" Style="margin-left: -4px;" ID="lblEndTime" Text='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.EndTimeText.Text%>' Visible='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.EndTimeText.Visible%>'></dx:ASPxLabel>
                                                                <dx:ASPxLabel runat="server" EnableViewState="false" EncodeHtml="false" ID="lblTitle" Text='<%#(CType(Container, VerticalAppointmentTemplateContainer)).AppointmentViewInfo.Appointment.CustomFields("TitleLink").ToString() %>'></dx:ASPxLabel>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="dxscCellWithPadding" colspan="2">
                                                                <div runat="server" id="horizontalSeparator" class='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.HorizontalSeparator.Style.CssClass%>' visible='<%#(CType(Container, VerticalAppointmentTemplateContainer)).Items.HorizontalSeparator.Visible%>'></div>
                                                            </td>
                                                        </tr>                                                     
                                                        <tr>
                                                            <td style="width:75px;">Agent:
                                                            </td>
                                                            <td>
                                                                <%# CType(Container, VerticalAppointmentTemplateContainer).AppointmentViewInfo.Appointment.CustomFields("Agent").ToString%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Manager:
                                                            </td>
                                                            <td>
                                                                <%# CType(Container, VerticalAppointmentTemplateContainer).AppointmentViewInfo.Appointment.CustomFields("Manager").ToString%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Type:
                                                            </td>
                                                            <td>
                                                                <%# CType(Container, VerticalAppointmentTemplateContainer).AppointmentViewInfo.Appointment.CustomFields("AppointType").ToString%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>Description:
                                                            </td>
                                                            <td>
                                                                <%# CType(Container, VerticalAppointmentTemplateContainer).Items.Description.Text%>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
