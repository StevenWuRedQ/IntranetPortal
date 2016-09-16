<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="NewOfferAccepted.aspx.vb" Inherits="IntranetPortal.NewOfferAccepted" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <div id="divMsg" runat="server" class="alert alert-success" style="width: 700px; height: 280px; margin: auto; margin-top: 10%; text-align: center; font-weight:600">
        <br />
        <% If String.IsNullOrEmpty(Address) Then %>
        The property is not found in shortsale.
        <% else %>
        The offer (<%= Address %>) was accepted by <% If Not String.IsNullOrEmpty(AcceptedBy) Then %> <%= AcceptedBy %> from ShortSale Departent on <%= string.Format("{0:d}", AcceptedDate) %><% else %> ShortSale<% End if %>.
        <% End If %>
        <br /><br />
        <a href="/viewleadsinfo.aspx?id=<%= BBLE %>">View Lead</a>
    </div>
</asp:Content>
