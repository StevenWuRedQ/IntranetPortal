<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetTab.ascx.vb" Inherits="IntranetPortal.ConstructionBudgetTab" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpreadsheet.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpreadsheet" TagPrefix="dx" %>
<div>
    <dx:ASPxSpreadsheet ID="Spreadsheet" Height="700px" runat="server" ActiveTabIndex="0"></dx:ASPxSpreadsheet>
    <div id="budgetTable" style="overflow: auto"></div>
</div>

