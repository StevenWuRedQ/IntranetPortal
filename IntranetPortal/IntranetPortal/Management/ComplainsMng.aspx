<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComplainsMng.aspx.vb" Inherits="IntranetPortal.ComplainsMng" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript">
        function SearchGrid() {

            var filterCondition = "";
            var key = document.getElementById("QuickSearch").value;

            if (key.trim() == "") {
                AllLeadsGridClient.ClearFilter();
                return;
            }

            filterCondition = "[CaseName] LIKE '%" + key + "%' OR [CaseName] LIKE '%" + key + "%'";
            filterCondition += " OR [ResearchBy] LIKE '%" + key + "%'";
            filterCondition += " OR [Attorney] LIKE '%" + key + "%'";
            filterCondition += " OR [BBLE] LIKE '%" + key + "%'";
            AllLeadsGridClient.ApplyFilter(filterCondition);
            return false;
        }
        function ShowCaseInfo(BBLE) {
            var url = '/LegalUI/LegalUI.aspx?bble=' + BBLE;
            OpenLeadsWindow(url, 'Legal')
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container" style="margin-top: 20px">
        <h3>Complains Monitor</h3>
        <div class="row">
            <table>
                <tr>
                    <td style="width:100px">BBLE:</td>
                    <td style="width:170px">
                        <dx:ASPxTextBox runat="server" ID="txtBBLE" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>
                    <td>
                        <input type="button" value="Check" runat="server" id="btnCheck" onserverclick="btnCheck_ServerClick" />
                    </td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td colspan="2">
                        <dx:ASPxLabel runat="server" ID="lblAddress"></dx:ASPxLabel>
                    </td>                    
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" value="Add to Watch" id="btnAdd" onclick="gdComplains.PerformCallback('Add')" />
                    </td>
                    <td></td>
                </tr>
            </table>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-8 form-inline">
                <input type="text" style="margin-right: 20px" id="QuickSearch" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchGrid()" title="search"></i>
            </div>
        </div>
        <div class="row" style="margin-top: 10px">
            <dx:ASPxGridView ID="gdComplains" ClientInstanceName="gdComplains" runat="server" KeyFieldName="BBLE" Theme="Moderno" CssClass="table" OnDataBinding="gdCases_DataBinding" OnCustomCallback="gdComplains_CustomCallback">
                <Columns>
                    <dx:GridViewDataColumn FieldName="BBLE" Visible="false">
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataColumn FieldName="Address">                        
                    </dx:GridViewDataColumn>                    
                    <dx:GridViewDataDateColumn FieldName="LastExecute"></dx:GridViewDataDateColumn>
                    <dx:GridViewDataColumn FieldName="CreateBy" Caption="CreateBy">                        
                    </dx:GridViewDataColumn>
                    <dx:GridViewCommandColumn ShowDeleteButton="true" ButtonType="Button">
                        <DeleteButton Text="Remove"></DeleteButton>
                    </dx:GridViewCommandColumn>
                </Columns>
                <Settings ShowHeaderFilterButton="true" />
                <SettingsBehavior ConfirmDelete="true" />
                <SettingsText ConfirmDelete="The follow up date will be cleared. Continue?" />
            </dx:ASPxGridView>            
        </div>
    </div>
</asp:Content>
