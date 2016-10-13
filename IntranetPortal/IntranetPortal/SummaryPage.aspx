<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="SummaryPage.aspx.vb" Inherits="IntranetPortal.SummaryPage" MasterPageFile="~/Content.Master" %>
<%@ Register Src="~/UserControl/UserSummary.ascx" TagPrefix="uc1" TagName="UserSummary" %>

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
    <uc1:UserSummary runat="server" ID="UserSummary" />
</asp:Content>
