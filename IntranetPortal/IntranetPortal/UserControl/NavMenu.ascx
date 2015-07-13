<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NavMenu.ascx.vb" Inherits="IntranetPortal.NavMenu" %>

<ul class="mip-nav mip-navbar-nav">
    <% Dim setCurrent = True%>
    <% For Each item In PortalMenuItems
            If item.IsVisible() Then
                If setCurrent Then
                    item.Expanded = True
                    setCurrent = False
                End If
    %>
    <%= item.ToHtml %>
    <% End If%>
    <% Next%>
</ul>
