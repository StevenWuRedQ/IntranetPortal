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

        function SearchComplains() {
            var filterCondition = "";
            var key = document.getElementById("gdComplainKey").value;

            if (key.trim() == "") {
                gdComplainsResult.ClearFilter();
                return;
            }

            filterCondition = "[Address] LIKE '%" + key + "%'";
            gdComplainsResult.ApplyFilter(filterCondition);
            return false;
        }

        function SetView() {
            var value = rbBBLE.GetChecked();
            txtBBLE.SetEnabled(value);
            txtNumber.SetEnabled(!value);
            txtStreet.SetEnabled(!value);
            txtCity.SetEnabled(!value);
        }
        var needRefreshResult = false;
        function RefreshProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Refresh|" + bble)

        }

        function RemoveProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Delete|" + bble)
        }

        function RefreshResult() {
            gdComplainsResult.Refresh();
            needRefreshResult = false;
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style type="text/css">
        .Header {
            background-color:#efefef;
        }
    </style>
    <div class="container" style="margin-top: 20px">
        <h3 style="text-align:center">DOB Complaints</h3>
        <div class="row header">
            <div class="col-md-8  form-inline">
                Add Property to Watch
            </div>
            <div class="col-md-4  form-inline">
                </div>
        </div>
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
            <div class="col-md-8  form-inline">
                Properties Watch List                
            </div>
            <div class="col-md-4  form-inline">
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
                    <dx:GridViewDataColumn Width="80px">
                        <DataItemTemplate>
                            <i class="fa fa-refresh icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RefreshProperty('<%# Eval("BBLE")%>')" title="Refresh"></i>&nbsp;
                            <i class="fa fa-close icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RemoveProperty('<%# Eval("BBLE")%>')" title="Remove"></i>
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                </Columns>
                <Settings ShowHeaderFilterButton="true" />
                <SettingsBehavior ConfirmDelete="true" />
                <SettingsText ConfirmDelete="The follow up date will be cleared. Continue?" />
                <ClientSideEvents EndCallback="function(s,e){ if(needRefreshResult){ RefreshResult();}}" />
            </dx:ASPxGridView>
        </div>
        <div class="row">
            <div class="col-md-8  form-inline">
                DOB Active Complaints&nbsp;
            </div>
            <div class="col-md-4 form-inline">
                <i class="fa fa-refresh icon_btn tooltip-examples  grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RefreshResult()" title="Refresh"></i>
                <i class="fa fa-wrench icon_btn tooltip-examples  grid_buttons" style="margin-left: 10px; font-size: 19px" title="Customized" onclick="gdComplainsResult.ShowCustomizationWindow(this)"></i>

                <input type="text" style="margin-right: 20px" id="gdComplainKey" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchComplains()" title="search"></i>
            </div>
        </div>
        <div class="row" style="margin-top: 10px; overflow-x: scroll">
            <dx:ASPxGridView ID="gdComplainsResult" ClientInstanceName="gdComplainsResult" AutoGenerateColumns="true" runat="server" Theme="Moderno" CssClass="table"
                KeyFieldName="ComplainNumber" OnDataBinding="gdComplainsResult_DataBinding" OnCustomCallback="gdComplainsResult_CustomCallback">
                <%--<Columns>
                     <dx:GridViewDataColumn FieldName="BBLE">
                    </dx:GridViewDataColumn>
                      <dx:GridViewDataColumn FieldName="Address">
                    </dx:GridViewDataColumn>
                      <dx:GridViewDataColumn FieldName="AssignedTo">
                    </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="CategoryCode">
                    </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="AssignedTo">
                    </dx:GridViewDataColumn> 
                        <dx:GridViewDataColumn FieldName="Comments">
                    </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ComplainNumber">
                    </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Reference311Number" Caption="Ref311Num">
                    </dx:GridViewDataColumn>
                </Columns>--%>
                <Settings ShowHeaderFilterButton="true" />
                <SettingsBehavior ConfirmDelete="true" EnableCustomizationWindow="true" />
                <SettingsText ConfirmDelete="The follow up date will be cleared. Continue?" EmptyDataRow="Data Service is not avaiable." />
            </dx:ASPxGridView>
        </div>
        <br />
    </div>
    <script>
        $(function () { SetView() });
        $(function () {
            setTimeout(RefreshResult(), 1000);
        });
    </script>
</asp:Content>
