<%@ Page Language="VB" AutoEventWireup="true" Inherits="IntranetPortal.Login" %>

<!DOCTYPE html>
<script runat="server">

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body style="min-height: 100%;">
    <form id="form1" runat="server">
        <div style="height: 100%; left: 0; position: fixed; top: 0; width: 100%;background-color:#f9f9f9;">
            <div style="top: 22%; left: 40%; position: absolute; z-index: 10; background-color:#efefef;">
                <dx:ASPxRoundPanel runat="server" HeaderText="Log In" HorizontalAlign="Center">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="accountHeader">
                                <img src="http://portal.myidealprop.com/images/MyIdealProptery.png" style="height: 152px; width: 137px" />
                                <p>
                                    Please enter your username and password. 	
                                </p>
                            </div>
                            <table style="width: 100%; padding: 2px;text-align:left;">
                                <tr>
                                    <td style="padding:2px;">
                                        <dx:ASPxLabel ID="lblUserName" runat="server" AssociatedControlID="tbUserName" Text="User Name:" />
                                    </td>
                                    <td style="padding:2px;">
                                        <dx:ASPxTextBox ID="tbUserName" runat="server" Width="200px">
                                            <ValidationSettings ValidationGroup="LoginUserValidationGroup" Display="Dynamic" ErrorTextPosition="Bottom">
                                                <RequiredField ErrorText="User Name is required." IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding:2px;">
                                        <dx:ASPxLabel ID="lblPassword" runat="server" AssociatedControlID="tbPassword" Text="Password:" />
                                    </td>
                                    <td style="padding:2px;">
                                        <dx:ASPxTextBox ID="tbPassword" runat="server" Password="true" Width="200px">
                                            <ValidationSettings ValidationGroup="LoginUserValidationGroup" Display="Dynamic" ErrorTextPosition="Bottom">
                                                <RequiredField ErrorText="Password is required." IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align:center;padding:2px;"">
                                        <dx:ASPxButton ID="btnLogin" runat="server" Text="Log In" ValidationGroup="LoginUserValidationGroup"
                                            OnClick="btnLogin_Click">
                                        </dx:ASPxButton>
                                        &nbsp;
                                        <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Clear" AutoPostBack="false">
                                            <ClientSideEvents Click="function(){ASPxClientEdit.ClearEditorsInContainer(form1);}" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <span style="color:transparent"><%= HttpContext.Current.Server.MachineName %></span>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </div>
        </div>
    </form>
</body>
</html>
