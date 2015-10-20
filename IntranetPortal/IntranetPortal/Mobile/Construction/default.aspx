<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="default.aspx.vb" Inherits="IntranetPortal._default2" MasterPageFile="~/Mobile.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="mobile_content">
    <div>
        <div class="item item-divider">
            <h2 class="text-center">Construction</h2>
        </div>

        <div class="card">
            <div class="item item-divider item-light">
                I want to report:
            </div>
            <div class="row">
                <a class="button button-stable col" href="/mobile/construction/spotcheck.aspx">Spot Check</a>

            </div>
            <div class="row">
                <a class="button button-stable col" href="/mobile/construction/initialform.aspx">Initial Form</a>
            </div>
        </div>
    </div>
</asp:Content>
