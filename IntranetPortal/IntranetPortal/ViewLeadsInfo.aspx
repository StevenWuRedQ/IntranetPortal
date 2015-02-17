<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ViewLeadsInfo.aspx.vb" Inherits="IntranetPortal.ViewLeadsInfo" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/LeadsInfo.ascx" TagPrefix="uc1" TagName="LeadsInfo" %>
<%@ Register Src="~/UserControl/LeadsSubMenu.ascx" TagPrefix="uc1" TagName="LeadsSubMenu" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div style="height: 100%">
        <uc1:LeadsInfo runat="server" ID="LeadsInfo" />
    </div>
    <uc1:LeadsSubMenu runat="server" ID="LeadsSubMenu" />
    <script type="text/javascript">

        function AttachScrollbar() {
            return;
            $("#prioity_content").mCustomScrollbar(
              {
                  theme: "minimal-dark"
              }
              );
            $("#home_owner_content").mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
             );

            $(".dxgvCSD").mCustomScrollbar(
                {
                    theme: "minimal-dark"
                }
             );
           
        }
    </script>
</asp:Content>