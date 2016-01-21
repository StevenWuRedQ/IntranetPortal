<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewLeadsInfo.aspx.vb" Inherits="IntranetPortal.ViewLeadsInfo" EnableEventValidation="false" MasterPageFile="~/Content.Master" Trace="false" %>

<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
      <style>
        #__asptrace {
            position: absolute;
            height: 500px;
            width: 1000px;
            top: 10px;
            right:10px;
            overflow: scroll;
            background-color: white;
        }
    </style>
    <div style="height: 100%">
        <uc1:LeadsInfo runat="server" ID="LeadsInfo" />
    </div>
    <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />
  
</asp:Content>