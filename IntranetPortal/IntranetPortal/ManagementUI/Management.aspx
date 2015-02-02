<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Management.aspx.vb" Inherits="IntranetPortal.Management1" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container-fluid">
        <div style="padding-top: 30px">
            <div style="font-size: 48px; color: #234b60">

                <div class="row">
                    <div class="col-md-4">
                        <span class="border_right" style="padding-right: 30px; font-weight: 300;">Management Summary</span>
                    </div>
                    <div class="col-md-2">
                        <span style="font-size: 30px" class="icon_btn">Queens Team</span>
                        <i class="fa fa-caret-down" style="color: #2e2f31; font-size: 18px;"></i>
                    </div>
                    <div class="col-md-6">
                        <div >
                            <div style="display:inline-block">
                                <span class="magement_font">Total agents</span>
                                <span class="magement_font magement_number">23</span>
                            </div>
                            <div style="display:inline-block;margin-left:20px">
                                <span class="magement_font">total deals within last 30 days</span>
                                <span class="magement_font magement_number">241</span>
                            </div>
                            <div style="display:inline-block">
                                <span class="magement_number"> 87/100 </span>
                            </div>
                        </div>
                    </div>
                   
                </div>
            </div>
        </div>
    </div>
</asp:Content>

