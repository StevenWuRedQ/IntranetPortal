<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ShareLeads.aspx.vb" Inherits="IntranetPortal.ShareLeads" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <link href="/css/stevencss.css?v=1.02" rel='stylesheet' type='text/css' />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:HiddenField runat="server" ID="hfbble" />
            <dx:ASPxListBox runat="server" ID="lbEmployees" Width="100%" Height="240px" ></dx:ASPxListBox>
            <br />
            <dx:ASPxComboBox runat="server" Width="100%" ID="cbEmps" CssClass="edit_drop" DropDownStyle="DropDownList" IncrementalFilteringMode="StartsWith">
                <ValidationSettings RequiredField-IsRequired="true"></ValidationSettings>
            </dx:ASPxComboBox>
            <div style="margin-top:10px">
                <dx:ASPxButton runat="server" Text="Add" ID="btnAddEmp" CssClass="rand-button rand-button-blue" ></dx:ASPxButton>
                <dx:ASPxButton runat="server" Text="Remove" ID="btnRemoveEmp" CssClass="rand-button rand-button-gray"></dx:ASPxButton>
            </div>
        </div>
    </form>
</body>
</html>
