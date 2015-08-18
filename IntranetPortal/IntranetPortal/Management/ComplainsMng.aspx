<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ComplainsMng.aspx.vb" Inherits="IntranetPortal.ComplainsMng" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <script type="text/javascript">
        function SearchGrid() {

            var filterCondition = "";
            var key = document.getElementById("QuickSearch").value;

            if (key.trim() == "") {
                gdComplains.ClearFilter();
                return;
            }

            filterCondition = "[Address] LIKE '%" + key + "%'";        
            gdComplains.ApplyFilter(filterCondition);
            return false;
        }

        function SetView() {
            var value = rbBBLE.GetChecked();
            txtBBLE.SetEnabled(value);
            txtNumber.SetEnabled(!value);
            txtStreet.SetEnabled(!value);
            txtCity.SetEnabled(!value);
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <div class="container" style="margin-top: 20px">
        <h3>Complains Monitor</h3>
        <div class="row">
            <table>
                <tr>
                    <td>
                        <dx:ASPxRadioButton runat="server" ID="rbBBLE" GroupName="Test" ClientInstanceName="rbBBLE" Checked="true">
                            <ClientSideEvents CheckedChanged="function(s,e){
                                SetView();
                                }" />
                        </dx:ASPxRadioButton>
                        <%--<input type="radio" value="BBLE" name="rdBBLE" id="rdBBLE" runat="server" /><label for="rdBBLE">&nbsp;</label>--%></td>
                    <td style="width: 100px">BBLE</td>
                    <td style="width: 170px">
                        <dx:ASPxTextBox runat="server" ID="txtBBLE" ClientInstanceName="txtBBLE" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>
                    <td rowspan="4">
                        <input type="button" value="Check" runat="server" id="btnCheck" onserverclick="btnCheck_ServerClick" /><br />
                        <input type="button" value="Add to Watch" id="btnAdd" onclick="gdComplains.PerformCallback('Add')" style="margin-top: 10px;" runat="server" visible="false" />
                    </td>
                </tr>
                <tr>
                    <td rowspan="3">
                        <dx:ASPxRadioButton runat="server" ID="rbAddress" GroupName="Test"></dx:ASPxRadioButton>
                        <%--<input type="radio" value="BBLE" name="rdBBLE" id="rdAddress" runat="server" /><label for="rdAddress">&nbsp;</label>--%>
                    </td>
                    <td>Number:
                    </td>
                    <td>
                        <dx:ASPxTextBox runat="server" ID="txtNumber" ClientInstanceName="txtNumber" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>
                </tr>
                <tr>                    
                    <td>Street:
                    </td>
                    <td>
                        <dx:ASPxTextBox runat="server" ID="txtStreet" ClientInstanceName="txtStreet" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>

                </tr>
                <tr>                   
                    <td>City:
                    </td>
                    <td>                        
                        <dx:ASPxTextBox runat="server" ID="txtCity" ClientInstanceName="txtCity" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                    </td>

                </tr>
            </table>
        </div>
        <dx:ASPxLabel runat="server" ID="lblAddress"></dx:ASPxLabel>
        <div class="row">
            <div class="col-md-4 col-md-offset-8 form-inline">
                <input type="text" style="margin-right: 20px" id="QuickSearch" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchGrid()" title="search"></i>
            </div>
        </div>
        <div class="row" style="margin-top: 10px">
            <dx:ASPxGridView ID="gdComplains" ClientInstanceName="gdComplains" runat="server" KeyFieldName="BBLE" Theme="Moderno" CssClass="table" OnDataBinding="gdCases_DataBinding" OnCustomCallback="gdComplains_CustomCallback">
                <Columns>
                    <dx:GridViewDataColumn FieldName="BBLE">
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
    <script>
        $(function () { SetView() });
    </script>
</asp:Content>
