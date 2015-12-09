<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadsStatisticSummary.ascx.vb" Inherits="IntranetPortal.LeadsStatisticSummary" %>
<div style="background: #f1f2f6 url(/images/toolbarBg.png) repeat-x left top; border: 1px solid #9da0aa; margin: 0px; margin-left: -1px; padding-left: 10px;">
                                    <dx:ASPxLabel ID="lblStatus" runat="server" Text="Total Leads:" Font-Bold="true" EncodeHtml="false"></dx:ASPxLabel>                                    
                                    <span class="dxeBase_MetropolisBlue" id="ASPxSplitter1_lblTotalLeads" style="color:Red;font-weight:bold;"><%= IntranetPortal.Utility.TotalLeadsCount.ToString %></span>
                                    &nbsp;&nbsp;&nbsp;
                                    <dx:ASPxLabel ID="lbldeal" runat="server" Text="Total Deals: " Font-Bold="true"></dx:ASPxLabel>
                                    <span class="dxeBase_MetropolisBlue" style="color:Red;font-weight:bold;"><%= IntranetPortal.Utility.TotalDealsCount.ToString%></span>
 </div>