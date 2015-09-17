<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionBudgetTab.ascx.vb" Inherits="IntranetPortal.ConstructionBudgetTab" %>
<%@ Register Assembly="DevExpress.Web.ASPxSpreadsheet.v15.1, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxSpreadsheet" TagPrefix="dx" %>
<div id="ContructionBudgetTab">
    <div class="ss_form">
        <div class="ss_border">
            <div>
                <h5 class="ss_form_title">Budget</h5>
                <pt-files file-bble="CSCase.BBLE" file-id="Construction_Budget" base-folder="Construction_Budget" file-model="CSCase.CSCase.Budget.Files"></pt-files>
            </div>
        </div>
    </div>
</div>
<div>
    <dx:ASPxSpreadsheet runat="server" ID="ASPxSpreadsheet1" RibbonMode="None">
    </dx:ASPxSpreadsheet>
</div>

