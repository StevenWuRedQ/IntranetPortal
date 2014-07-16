<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="CompanyTree.ascx.vb" Inherits="IntranetPortal.CompanyTree" %>
<%@ Register assembly="DevExpress.Web.v14.1, Version=14.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Data.Linq" tagprefix="dx" %>

    <dx:ASPxTreeView ID="TreeViewEmp" runat="server" NameField="Name" AllowSelectNode="true">
       <Nodes>
           <dx:TreeViewNode Text="Company" Name="nodeCompany" Expanded="true" ></dx:TreeViewNode>
       </Nodes>
    </dx:ASPxTreeView>

