<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <pt-selectable-input optionss="test1|test2|other" ng-model="hey"></pt-selectable-input>
</asp:Content>

