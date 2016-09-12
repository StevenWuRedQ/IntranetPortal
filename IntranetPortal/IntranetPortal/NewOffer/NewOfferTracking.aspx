<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="NewOfferTracking.aspx.vb" Inherits="IntranetPortal.NewOfferTracking" EnableEventValidation="false" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/UserControl/ActivityLogs.ascx" TagPrefix="uc1" TagName="ActivityLogs" %>
<%@ Register Src="~/UserControl/PropertyInfo.ascx" TagPrefix="uc1" TagName="PropertyInfo" %>


<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <script>
        /* immediately call to show the loading panel*/
        (function () {
            var loadingCover = document.getElementById("LodingCover");
            loadingCover.style.display = "block";
        })();

    </script>
    <style>
        .dxgvControl_MetropolisBlue1 {
            width: auto !important;
        }

        .dxgvHSDC div, .dxgvCSD {
            width: auto !important;
        }
    </style>
    <div ui-layout="{flow: 'column'}">
        <%-- data panel     --%>
        <div ui-layout-container id="dataPanelDiv">
            <div style="width: 100%; align-content: center; height: 100%">
                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 16px; color: white">
                    <li class="active short_sale_head_tab">
                        <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                            <i class="fa fa-info-circle head_tab_icon_padding"></i>
                            <div class="font_size_bold" style="font-weight: 900;">Property</div>
                        </a>
                    </li>
                    <li class="short_sale_head_tab">
                        <a href="#home_owner" role="tab" data-toggle="tab" class="tab_button_a">
                            <i class="fa fa-home head_tab_icon_padding"></i>
                            <div class="font_size_bold" style="font-weight: 900;">Homeowner</div>
                        </a>
                    </li>
                    <li class="short_sale_head_tab">
                        <a href="#documents" role="tab" data-toggle="tab" class="tab_button_a" onclick="BindDocuments(false)">
                            <i class="fa fa-file head_tab_icon_padding"></i>
                            <div class="font_size_bold" style="font-weight: 900;">Documents</div>
                        </a>
                    </li>
                    <li style="margin-right: 30px; color: #ffa484; float: right">
                        <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick="PrintLeadInfo()"></i>
                    </li>
                </ul>
                <uc1:PropertyInfo runat="server" ID="PropertyInfo" />
            </div>
        </div>
        <%-- log panel --%>
        <div ui-layout-container id="logPanelDiv">
            <div style="font-size: 12px; color: #9fa1a8;">
                <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #295268; font-size: 18px; color: white">
                    <li class="short_sale_head_tab activity_light_blue">
                        <a href="#property_info" role="tab" data-toggle="tab" class="tab_button_a">
                            <i class="fa fa-history head_tab_icon_padding"></i>
                            <div class="font_size_bold">Activity Log</div>
                        </a>
                    </li>
                </ul>
                <dx:ASPxCallbackPanel runat="server" ID="cbpLogs" ClientInstanceName="cbpLogs">
                    <PanelCollection>
                        <dx:PanelContent>
                            <uc1:ActivityLogs runat="server" ID="ActivityLogs" DisplayMode="Construction" />
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxCallbackPanel>
            </div>
        </div>
    </div>

</asp:Content>
