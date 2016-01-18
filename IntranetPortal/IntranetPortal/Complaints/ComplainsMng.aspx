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
            filterCondition += " OR [BBLE] LIKE '%" + key + "%'";
            gdComplains.ApplyFilter(filterCondition);
            return false;
        }

        function SearchComplains() {
            var key = document.getElementById("gdComplainKey").value;
            key = key.trim();
            if (key == "") {
                Complaints.Filter("");
                //gdComplainsResult.ClearFilter();
                return;
            }

            FilterComplaints(key);
        }

        function FilterComplaints(key) {
            Complaints.Filter(key.trim());

            //var filterCondition = "";

            //filterCondition = "[Address] LIKE '%" + key + "%'";
            //filterCondition += " OR [BBLE] LIKE '%" + key + "%'";
            //gdComplainsResult.ApplyFilter(filterCondition);
            return false;
        }

        var verifyButtonId = "<%= btnCheck.ClientID%>";

        function SetView() {
            var value = rbBBLE.GetChecked();
            txtBBLE.SetEnabled(value);
            txtNumber.SetEnabled(!value);
            txtStreet.SetEnabled(!value);
            txtCity.SetEnabled(!value);

            if (value)
                $('#' + verifyButtonId).val("Verify BBLE");
            else
                $('#' + verifyButtonId).val("Verify Address");
        }

        var needRefreshResult = false;
        function RefreshProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Refresh|" + bble);
        }

        function RemoveProperty(bble) {
            needRefreshResult = true;
            gdComplains.PerformCallback("Delete|" + bble);
        }

        function RefreshResult() {
            //gdComplainsResult.Refresh();

            //refresh data grid
            Complaints.Refresh();
            needRefreshResult = false;
        }

        function expandAllClick(s, content) {
            if (content.is(':visible')) {
                content.hide();
                $(s).attr("class", 'fa fa-expand icon_btn tooltip-examples grid_buttons');
            }
            else {
                content.show();
                $(s).attr("class", 'fa fa-compress icon_btn tooltip-examples grid_buttons');
            }
        }

        function ShowComplaintsHistory(bble) {
            popupComplaintHistory.PerformCallback(bble);
            $('#spanPopupTitle').text('Complaints History - ' + bble);
            popupComplaintHistory.Show();
        }

        var editDiv = null;
        function EditNotifyUsers(bble, div) {
            editDiv = div;
            popupNotifyUsers.SetHeaderText("Edit Notify User - " + bble);
            popupNotifyUsers.PerformCallback('Show|' + bble);
            popupNotifyUsers.Show();
        }

        function SaveNotifyUsers(users) {
            popupNotifyUsers.PerformCallback('Save');
            popupNotifyUsers.Hide();
            $(editDiv).html(users);
        }

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style type="text/css">
        .form_header {
            background-color: #efefef;
            line-height: 40px;
            padding-left: 15px;
            font-weight: 600;
        }

        a:hover {
            background-color: #045cad;
            font-weight: 600;
        }

        table tr td {
            padding-left: 5px;
        }

        .important {
            color: red;
        }

        .form_border {
            border: 1px solid #808080;
            padding: 0px;
            margin-top: 10px;
        }

        .notification {
            background: #428bca;
            -moz-border-radius: 50px;
            -webkit-border-radius: 50px;
            border-radius: 50px;
            color: #fff;
            display: inline-block;
            font-size: 16px;
            font-weight: 900;
            line-height: 30px;
            margin-right: 10px;
            min-width: 16px;
            padding-left: 7px;
            padding-right: 7px;
            text-align: center;
        }

        .maininfo {
            font-family: arial;
            font-size: 9pt;
            color: black;
            font-weight: bold;
            background-color: #9BCDFF;
        }

        .content {
            font-family: arial;
            font-size: 9pt;
            color: black;
            font-weight: normal;
        }

        .mainhdg {
            font-family: Arial;
            font-size: 11pt;
            font-weight: bold;
            color: #000080;
            text-align: center;
        }

        .rightcontent {
            font-family: Arial;
            font-size: 9pt;
            color: black;
            text-align: right;
            font-weight: normal;
        }
    </style>
    <div class="container">
        <h3 style="text-align: center; line-height: 50px">DOB Complaints <% If Not DetailView Then%> Watch List <% Else %> for <%= Complaint.Address  %> <% End If%> </h3>
        <% If Not DetailView Then%>

        <div class="row form_border">
            <div class="form_header">
                Add Property to Watch &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#tblAddProp'))"></i>
            </div>
            <dx:ASPxCallbackPanel runat="server" ID="cpAddProperty" ClientInstanceName="cpAddProperty" OnCallback="cpAddProperty_Callback">
                <PanelCollection>
                    <dx:PanelContent>
                        <table style="width: 550px; margin: 10px;" id="tblAddProp">
                            <tr>
                                <th style="width: 200px">
                                    <dx:ASPxRadioButton runat="server" ID="rbBBLE" GroupName="Test" ClientInstanceName="rbBBLE" Checked="true">
                                        <ClientSideEvents CheckedChanged="function(s,e){
                                SetView();
                                }" />
                                    </dx:ASPxRadioButton>
                                    &nbsp;By BBLE
                                </th>
                                <th style="width: 240px">
                                    <dx:ASPxRadioButton runat="server" ID="rbAddress" GroupName="Test"></dx:ASPxRadioButton>
                                    &nbsp;By Address
                                </th>
                                <th></th>
                            </tr>
                            <tr>
                                <td style="vertical-align: top">
                                    <dx:ASPxTextBox runat="server" ID="txtBBLE" ClientInstanceName="txtBBLE" Native="true" CssClass="form-control" Width="150px"></dx:ASPxTextBox>
                                </td>
                                <td>
                                    <table style="line-height: 35px">
                                        <tr>
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
                                </td>
                                <td>
                                    <input type="button" class="btn btn-primary" value="Verify" runat="server" id="btnCheck" onclick="cpAddProperty.PerformCallback('Add')" /><br />
                                    <input type="button" class="btn btn-primary" value="Add to Watch List" id="btnAdd" onclick="gdComplains.PerformCallback('Add'); alert('Success.')" style="margin-top: 10px;" runat="server" disabled="disabled" />

                                    <dx:ASPxLabel runat="server" ID="lblAddress" Visible="false"></dx:ASPxLabel>
                                </td>
                            </tr>
                        </table>
                    </dx:PanelContent>
                </PanelCollection>
                <ClientSideEvents EndCallback="function(s,e){SetView()}" />
            </dx:ASPxCallbackPanel>
        </div>
        <div class="row form_border" style="">
            <div class="form_header">
                Owned Properties Currently Being Watch for You&nbsp;<span class="notification"><%= ComplaintsAmount %></span>&nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divComplains'))"></i>
                <div class="form-inline" style="float: right; font-weight: normal">
                    <small>(**Click on BBLE to view active complaints**)</small>
                    <input type="text" style="margin-right: 10px" id="QuickSearch" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchGrid(); return false;}" />
                    <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="margin-right: 20px; font-size: 19px" onclick="SearchGrid()" title="search"></i>
                </div>
            </div>
            <div id="divComplains">
                <dx:ASPxGridView ID="gdComplains" Width="100%" ClientInstanceName="gdComplains" runat="server" KeyFieldName="BBLE" Theme="Moderno" CssClass="table" OnDataBinding="gdCases_DataBinding" OnCustomCallback="gdComplains_CustomCallback">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="BBLE" Width="120px">
                            <DataItemTemplate>
                                <a href="#" class="tooltip-examples" title="View complaints details" onclick="FilterComplaints('<%# Eval("BBLE")%>')"><%# Eval("BBLE")%></a>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Address">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="TotalComplaints" Caption="Total" Width="80px">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ActiveComplaints" Caption="Active" Width="80px">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="NotifyUsers">
                            <DataItemTemplate>
                                <div style="display: inline-block" onclick="EditNotifyUsers('<%# Eval("BBLE")%>', this);"><%# Eval("NotifyUsers")%></div>
                                <i class="fa fa-edit icon_btn tooltip-examples  grid_buttons" style="font-size: 19px;" onclick="EditNotifyUsers('<%# Eval("BBLE")%>', $(this).prev());" title="Edit"></i>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataDateColumn FieldName="LastExecute" Width="150px" PropertiesDateEdit-DisplayFormatString="g">
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataColumn FieldName="CreateBy" Caption="CreateBy" Width="120px">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="StatusString" Caption="Status" Width="80px">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn Width="80px">
                            <HeaderTemplate>
                                <i class="fa fa-refresh icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RefreshProperty('All')" title="Refresh All"></i>&nbsp;
                            </HeaderTemplate>
                            <DataItemTemplate>
                                <i class="fa fa-refresh icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RefreshProperty('<%# Eval("BBLE")%>')" title="Refresh"></i>&nbsp;
                                <i class="fa fa-close icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" onclick="RemoveProperty('<%# Eval("BBLE")%>')" title="Remove"></i>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="300" />
                    <SettingsBehavior ConfirmDelete="true" />
                    <SettingsText ConfirmDelete="The follow up date will be cleared. Continue?" />
                    <ClientSideEvents EndCallback="function(s,e){ if(needRefreshResult){ RefreshResult();}}" />
                </dx:ASPxGridView>
            </div>
        </div>

        <script type="text/javascript">
            $(function () { SetView() });
            $(function () {
                setTimeout(RefreshResult(), 1000);
            });
        </script>

        <% End If%>

        <div class="row form_border">
            <div class="form_header">
                DOB Complaints Details &nbsp;<i class="fa fa-compress icon_btn tooltip-examples grid_buttons" style="font-size: 18px;" title="Collapse" onclick="expandAllClick(this, $('#divComplainResult'))"></i>
                <div class="form-inline" style="float: right; font-weight: normal">
                    <small style="color: green">(**Complaints records are set to refresh automatically at 7am, 1pm and 8pm daily.**)
                    </small>
                    <i class="fa fa-refresh icon_btn tooltip-examples  grid_buttons" style="margin-left: 10px; margin-right: 10px; font-size: 19px" onclick="RefreshResult()" title="Refresh"></i>
                    <input type="text" style="margin-right: 10px" id="gdComplainKey" class="form-control" placeholder="Quick Search" onkeydown="javascript:if(event.keyCode == 13){ SearchComplains(); return false;}" />
                    <i class="fa fa-search icon_btn tooltip-examples  grid_buttons" style="font-size: 19px; margin-right: 20px;" onclick="SearchComplains()" title="search"></i>
                </div>
            </div>
            <div id="divComplainResult">
                <div id="dgComplaintsResult"></div>

                <script id="gridCellHistory" type="text/html">
                    <i class="fa fa-history icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" title="View History Details" onclick='ShowComplaintsHistory("{%= value %}")'></i>
                </script>
                <script id="gridComplaitsDetail2" type="text/html">
                    <div style="align-content: center">
                        <h3 class="mainhdg">Overview for Complaint #:{%= data.ComplaintNumber%} = {%= data.Status%}</h3>
                        <table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td class="maininfo" align="left" width="300" colspan="2">Complaint at:&nbsp;&nbsp;{%=data.Address%}</td>
                                    <td class="maininfo" align="right">BIN: {%=data.BIN%}</td>
                                    <td class="maininfo" width="10">&nbsp;&nbsp;</td>
                                    <td class="maininfo" align="right">Borough:&nbsp;{%=data.Borough%}</td>
                                    <td class="maininfo" width="10">&nbsp;&nbsp;</td>
                                    <td class="maininfo" align="right">ZIP:&nbsp;{%=data.Zip%}</td>
                                </tr>
                                <tr valign="top">
                                    <td class="content" colspan="6">Re:&nbsp;&nbsp;{%=data.RE%}</td>
                                </tr>
                            </tbody>
                        </table>
                        <br />
                        <table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td class="content" colspan="2"></td>
                                    <td class="content"></td>
                                </tr>
                                <tr>
                                    <td class="content" width="150"><b>Category Code:</b></td>
                                    <td class="content" colspan="2" width="600">{%=data.CategoryCode%}</td>
                                </tr>
                                <tr>
                                    <td class="content" width="150" colspan="3">
                                        <br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content" width="150" colspan="3">
                                        <br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="content" width="150"><b>Assigned To:</b></td>
                                    <td class="content" width="450">{%=data.AssignedTo%}</td>
                                    <td class="content" width="150"><b>Priority:</b>&nbsp;&nbsp;{%=data.Priority%}&nbsp;
			&nbsp;&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="rightcontent" colspan="3"><b>311 Reference Number:</b>&nbsp;&nbsp;{%=data.Reference311Number%}
			&nbsp;&nbsp;</td>
                                </tr>
                            </tbody>
                        </table>
                        <table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td>
                                        <hr>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td class="content"><b>Received:</b></td>
                                    <td class="content">&nbsp;&nbsp;{%=_.template.formatdatevalue(data.DateEntered)%}</td>
                                    <td class="content" width="10">&nbsp;</td>
                                    <td class="content"><b>BBLE:</b>&nbsp;&nbsp;{%=data.BBLE%}</td>
                                    <td class="content"><b></b>&nbsp;&nbsp;</td>
                                    <td class="content" width="25">&nbsp;</td>
                                    <td class="content" align="right"><b>Community Board:</b>&nbsp;&nbsp;</td>
                                </tr>
                                <tr>
                                    <td class="content"><b>Owner:</b></td>
                                    <td class="content">&nbsp;&nbsp;{%=data.Owner%}</td>
                                    <!--- Value for Owner --->
                                    <td colspan="5">&nbsp;</td>
                                </tr>

                            </tbody>
                        </table>
                        <br />
                        <table border="0" cellpadding="0" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td class="content" width="30%" align="right" valign="top"><b>Last Inspection:</b>&nbsp;&nbsp;</td>

                                    <td class="content" width="70%">{%=data.LastInspection%} </td>

                                </tr>
                                <tr>
                                    <td class="content" width="30%" align="right" valign="top"><b>Disposition:</b>&nbsp;&nbsp;</td>
                                    <td class="content" width="70%">{%=data.DispositionDetails%} </td>
                                </tr>
                                <tr>
                                    <td class="content" width="30%" valign="top" align="right"><b>Comments:</b>&nbsp;&nbsp;</td>
                                    <td class="content" width="70%">{%=data.Comments%}</td>
                                </tr>
                            </tbody>
                        </table>
                        <table border="0" cellpadding="1" cellspacing="0" width="750" style="margin: 0 auto;">
                            <tbody>
                                <tr>
                                    <td>
                                        <hr>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </script>

                <script id="gridComplaitsDetail" type="text/html">
                    <table class="table" style="width: 100%; border: 1px solid #808080; line-height: 25px; white-space: normal; color: black">
                        <tr>
                            <td colspan="4" class="form_header">Complaints - {%= data.ComplaintNumber%} - Detail
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 150px;">Address:
                            </td>
                            <td style="width: 35%">{%=data.Address%}
                            </td>
                            <td>Acquisition Date:
                            </td>
                            <td>{%=_.template.formatdatevalue(data.AcquisitionDate)%}
                            </td>
                        </tr>
                        <tr>
                            <td>Owner:
                            </td>
                            <td>{%=data.Owner%}
                            </td>
                            <td style="width: 150px">DateEntered:
                            </td>
                            <td style="width: 35%">{%=_.template.formatdatevalue(data.DateEntered)%}
                            </td>
                        </tr>
                        <tr>
                            <td style="color: red; vertical-align: top">Red Notes:
                            </td>
                            <td style="color: red">{%=data.RedNotes%}
                            </td>
                            <td>AssignedTo:
                            </td>
                            <td>{%=data.AssignedTo%}
                            </td>
                        </tr>
                        <tr>
                            <td>Subject:
                            </td>
                            <td>{%=data.Subject%}
                            </td>
                            <td>Zip:
                            </td>
                            <td>{%=data.Zip%}
                            </td>
                        </tr>
                        <tr>
                            <td>RE:
                            </td>
                            <td>{%=data.RE%}
                            </td>
                            <td>Reference311Number:
                            </td>
                            <td>{%=data.Reference311Number%}
                            </td>
                        </tr>
                        <tr>
                            <td>LastInspection:
                            </td>
                            <td style="background-color: lightyellow">{%=data.LastInspection%}
                            </td>
                            <td style="width: 150px">Category:
                            </td>
                            <td>{%=data.CategoryCode%}
                            </td>

                        </tr>
                        <tr>
                            <td style="width: 150px">Comments:
                            </td>
                            <td style="background-color: lightyellow">{%=data.Comments%}
                            </td>
                            <td>DispositionDetails:
                            </td>
                            <td>{%=data.DispositionDetails%}
                            </td>
                        </tr>
                        <tr>
                            <td>Disposition:
                            </td>
                            <td>{%=data.Disposition%}
                            </td>
                            <td>LastUpdated:
                            </td>
                            <td>{%=_.template.formatdatevalue(data.LastUpdated)%}
                            </td>
                        </tr>
                        <tr>
                            <td>Priority:
                            </td>
                            <td>{%=data.Priority%}
                            </td>
                            <td>BIN:
                            </td>
                            <td>{%=data.BIN%}
                            </td>
                        </tr>
                        <tr>
                            <td>DOB Violation:
                            </td>
                            <td>{%=data.DOBViolation%}
                            </td>
                            <td>ECB Violation:
                            </td>
                            <td>{%=data.ECBViolation%}
                            </td>
                        </tr>
                    </table>
                </script>

                <script type="text/javascript">
                    DevExpress.ui.setTemplateEngine("underscore");
                    _.templateSettings = {
                        interpolate: /\{%=(.+?)%\}/g,
                        escape: /\{%-(.+?)%\}/g,
                        evaluate: /\{%(.+?)%\}/g
                    };
                    _.template.formatdatevalue = function (newDate) {
                        var tempDate = Date.parse(newDate);
                        var myDate = new Date(tempDate);

                        if (myDate.getFullYear() >= 1900) {
                            var month = myDate.getUTCMonth() + 1;
                            return month + "/" + myDate.getUTCDate() + "/" + myDate.getUTCFullYear();
                        }
                        return "";
                    };

                    var Complaints = {
                        BBLE: null,
                        Result: null,
                        DataGrid: null,
                        LoadResult: function () {
                            var view = this;
                            var customStore = new DevExpress.data.CustomStore({
                                load: function (loadOptions) {
                                    if (view.Result != null)
                                        return view.Result

                                    var d = $.Deferred();

                                    var url = "/api/Complaints/" + (view.BBLE == null ? "" : view.BBLE);

                                    $.getJSON(url).done(function (data) {
                                        d.resolve(data, { totalCount: data.length });
                                        view.Result = data;
                                    });
                                    return d.promise();
                                }
                            });
                            return customStore;
                        },
                        LoadGrid: function () {
                            var gridOptions = {
                                dataSource: this.LoadResult(),
                                showColumnLines: false,
                                showRowLines: true,
                                rowAlternationEnabled: true,
                                wordWrapEnabled: true,
                                remoteOperations: {
                                    sorting: false
                                },
                                selection: {
                                    mode: 'single'
                                },
                                onSelectionChanged: function (e) {
                                    e.component.collapseAll(-1);
                                    e.component.expandRow(e.currentSelectedRowKeys[0]);
                                },
                                onContentReady: function (e) {
                                    //if (!e.component.getSelectedRowKeys().length)
                                    //    e.component.selectRowsByIndexes(0);
                                },
                                scrolling: {
                                    mode: 'infinite'
                                },
                                columns: [{
                                    dataField: "Address",
                                    caption: "Address"
                                }, {
                                    dataField: "ComplaintNumber",
                                    caption: "Complaint Number",
                                    width: 150
                                }, {
                                    dataField: "LastInspection",
                                    caption: "Last Inspection",
                                    dataType: 'date'
                                },
                                {
                                    dataField: "LastUpdated",
                                    caption: "Last Updated",
                                    dataType: 'date',
                                    width: 150,
                                    format: 'M/dd/yyyy h:mm tt'
                                }, {
                                    dataField: "Status",
                                    caption: "Status",
                                    width: '80px',
                                    filter: '',
                                    dataType: "string"
                                }, {
                                    dataField: 'BBLE',
                                    caption: '',
                                    width: '60px',
                                    allowFiltering: false,
                                    allowSorting: false,
                                    cellTemplate: $("#gridCellHistory")
                                }],
                                masterDetail: {
                                    enabled: true,
                                    template: "#gridComplaitsDetail"
                                },
                                onRowPrepared: function (info) {
                                    if (info.data && info.data.RedNotes && info.data.RedNotes != "")
                                        info.rowElement.addClass("important");
                                }
                            }

                            this.DataGrid = $("#dgComplaintsResult").dxDataGrid(gridOptions).dxDataGrid("instance");
                        },
                        Refresh: function () {
                            if (this.DataGrid == null)
                                this.LoadGrid();
                            else {
                                this.Result = null;
                                this.DataGrid.refresh();
                            }
                        },
                        Filter: function (key) {
                            this.DataGrid.clearFilter('dataSource');

                            if (key && key != "") {
                                this.DataGrid.filter([
                                ["Address", "contains", key],
                                "or",
                                ["BBLE", "contains", key],
                                "or",
                                ["Status", "contains", key],
                                ]);
                            }
                        }
                    }

                </script>

                <dx:ASPxGridView ID="gdComplainsResult" ClientInstanceName="gdComplainsResult" runat="server" Theme="Moderno" CssClass="table" Width="100%" ViewStateMode="Disabled" Visible="false"
                    KeyFieldName="BBLE;ComplaintNumber" OnDataBinding="gdComplainsResult_DataBinding" OnCustomCallback="gdComplainsResult_CustomCallback" OnHtmlRowPrepared="gdComplainsResult_HtmlRowPrepared">
                    <Columns>
                        <dx:GridViewDataColumn FieldName="Address">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ComplaintNumber">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataDateColumn FieldName="LastInspection" PropertiesDateEdit-DisplayFormatString="g">
                        </dx:GridViewDataDateColumn>
                        <dx:GridViewDataDateColumn FieldName="LastUpdated" PropertiesDateEdit-DisplayFormatString="g">
                        </dx:GridViewDataDateColumn>

                        <dx:GridViewDataColumn FieldName="DateEntered" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Owner" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="AssignedTo" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Subject" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Zip" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="RE" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Reference311Number" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Category" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Disposition" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="DispositionDetails" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Comments" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="Priority" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="BIN" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="DOBViolation" Visible="false">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn FieldName="ECBViolation" Visible="false">
                        </dx:GridViewDataColumn>

                        <dx:GridViewDataColumn FieldName="Status">
                        </dx:GridViewDataColumn>
                        <dx:GridViewDataColumn Width="50px" CellStyle-VerticalAlign="Middle">
                            <DataItemTemplate>
                                <i class="fa fa-history icon_btn tooltip-examples grid_buttons" style="margin-left: 10px; font-size: 19px" title="View History Details" onclick='ShowComplaintsHistory("<%#Eval("BBLE")%>")'></i>
                            </DataItemTemplate>
                        </dx:GridViewDataColumn>
                    </Columns>
                    <Templates>
                        <DetailRow>
                            <table class="" style="width: 100%; border: 1px solid #808080; line-height: 25px">
                                <tr>
                                    <td colspan="4" class="form_header">Complaints - <%# Eval("ComplaintNumber")%> - Detail
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px;">Address
                                    </td>
                                    <td style="width: 35%">
                                        <%#Eval("Address")%>
                                    </td>
                                    <td>DateEntered
                                    </td>
                                    <td>
                                        <%#Eval("DateEntered")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Owner
                                    </td>
                                    <td>
                                        <%#Eval("Owner")%>
                                    </td>
                                    <td>AssignedTo
                                    </td>
                                    <td>
                                        <%#Eval("AssignedTo")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Subject
                                    </td>
                                    <td>
                                        <%#Eval("Subject")%>
                                    </td>
                                    <td>Zip
                                    </td>
                                    <td>
                                        <%#Eval("Zip")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>RE
                                    </td>
                                    <td>
                                        <%#Eval("RE")%>
                                    </td>

                                    <td>Reference311Number
                                    </td>
                                    <td>
                                        <%#Eval("Reference311Number")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>LastInspection
                                    </td>
                                    <td>
                                        <%#Eval("LastInspection")%>
                                    </td>
                                    <td style="width: 150px">Category
                                    </td>
                                    <td>
                                        <%#Eval("CategoryCode")%>
                                    </td>

                                </tr>
                                <tr>
                                    <td>Disposition
                                    </td>
                                    <td>
                                        <%#Eval("Disposition")%>
                                    </td>
                                    <td>DispositionDetails
                                    </td>
                                    <td>
                                        <%#Eval("DispositionDetails")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 150px">Comments
                                    </td>
                                    <td>
                                        <%#Eval("Comments")%>
                                    </td>
                                    <td>LastUpdated
                                    </td>
                                    <td>
                                        <%#Eval("LastUpdated")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Priority
                                    </td>
                                    <td>
                                        <%#Eval("Priority")%>
                                    </td>
                                    <td>BIN
                                    </td>
                                    <td>
                                        <%#Eval("BIN")%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>DOB Violation
                                    </td>
                                    <td>
                                        <%#Eval("DOBViolation")%>
                                    </td>
                                    <td>ECB Violation
                                    </td>
                                    <td>
                                        <%#Eval("ECBViolation")%>
                                    </td>
                                </tr>
                            </table>
                        </DetailRow>
                    </Templates>
                    <SettingsPager Mode="ShowAllRecords"></SettingsPager>
                    <SettingsDetail ShowDetailRow="true" />
                    <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="400" />
                </dx:ASPxGridView>
            </div>
        </div>

        <dx:ASPxPopupControl ClientInstanceName="popupNotifyUsers" Width="300px" Height="300px"
            ID="ASPxPopupControl1" OnWindowCallback="ASPxPopupControl1_WindowCallback" AllowDragging="true"
            HeaderText="Notify Users" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <asp:HiddenField runat="server" ID="hfBBLE2" />
                    <dx:ASPxTokenBox runat="server" ID="tbUsers" TextSeparator=";" Theme="Moderno" Width="280px" ClientInstanceName="tbUsers">
                    </dx:ASPxTokenBox>
                    <input type="button" class="btn btn-primary" value="Save" id="Button1" onclick="SaveNotifyUsers(tbUsers.GetText());" style="margin-top: 15px" />
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ClientInstanceName="popupComplaintHistory" Width="800px" Height="480px"
            ID="popupComplaintHistory" OnWindowCallback="popupComplaintHistory_WindowCallback" AllowDragging="true"
            HeaderText="Previous Notes" Modal="true"
            runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
            <HeaderTemplate>
                <div class="clearfix">
                    <div class="pop_up_header_margin">
                        <i class="fa fa-history with_circle pop_up_header_icon"></i>
                        <span class="pop_up_header_text" id="spanPopupTitle">Complaints History</span>
                    </div>
                    <div class="pop_up_buttons_div">
                        <i class="fa fa-times icon_btn" onclick="popupComplaintHistory.Hide()"></i>
                    </div>
                </div>
            </HeaderTemplate>
            <ContentCollection>
                <dx:PopupControlContentControl runat="server" Visible="false" ID="popCtrHistory">
                    <asp:HiddenField ID="hfBBLE" runat="server" />
                    <dx:ASPxGridView ID="gdComplainsHistory" ClientInstanceName="gdComplainsHistory" runat="server" Theme="Moderno" CssClass="table" Width="100%" OnDataBinding="gdComplainsHistory_DataBinding"
                        KeyFieldName="ResultId">
                        <Columns>
                            <dx:GridViewDataColumn FieldName="Address">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="ComplaintNumber">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataDateColumn FieldName="LastInspection" PropertiesDateEdit-DisplayFormatString="g">
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataDateColumn FieldName="LastUpdated" PropertiesDateEdit-DisplayFormatString="g">
                            </dx:GridViewDataDateColumn>
                            <dx:GridViewDataColumn FieldName="DateEntered" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Owner" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="AssignedTo" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Subject" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Zip" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="RE" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Reference311Number" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Category" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Disposition" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="DispositionDetails" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Comments" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Priority" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="BIN" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="DOBViolation" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="ECBViolation" Visible="false">
                            </dx:GridViewDataColumn>
                            <dx:GridViewDataColumn FieldName="Status">
                            </dx:GridViewDataColumn>
                        </Columns>
                        <Templates>
                            <DetailRow>
                                <table class="" style="width: 100%; border: 1px solid #808080; line-height: 25px">
                                    <tr>
                                        <td colspan="4" class="form_header">Complaints - <%# Eval("ComplaintNumber")%> - Detail
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px;">Address
                                        </td>
                                        <td style="width: 35%">
                                            <%#Eval("Address")%>
                                        </td>
                                        <td>DateEntered
                                        </td>
                                        <td>
                                            <%#Eval("DateEntered")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Owner
                                        </td>
                                        <td>
                                            <%#Eval("Owner")%>
                                        </td>
                                        <td>AssignedTo
                                        </td>
                                        <td>
                                            <%#Eval("AssignedTo")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Subject
                                        </td>
                                        <td>
                                            <%#Eval("Subject")%>
                                        </td>
                                        <td>Zip
                                        </td>
                                        <td>
                                            <%#Eval("Zip")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>RE
                                        </td>
                                        <td>
                                            <%#Eval("RE")%>
                                        </td>

                                        <td>Reference311Number
                                        </td>
                                        <td>
                                            <%#Eval("Reference311Number")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>LastInspection
                                        </td>
                                        <td>
                                            <%#Eval("LastInspection")%>
                                        </td>
                                        <td style="width: 150px">Category
                                        </td>
                                        <td>
                                            <%#Eval("CategoryCode")%>
                                        </td>

                                    </tr>
                                    <tr>
                                        <td>Disposition
                                        </td>
                                        <td>
                                            <%#Eval("Disposition")%>
                                        </td>
                                        <td>DispositionDetails
                                        </td>
                                        <td>
                                            <%#Eval("DispositionDetails")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 150px">Comments
                                        </td>
                                        <td>
                                            <%#Eval("Comments")%>
                                        </td>
                                        <td>LastUpdated
                                        </td>
                                        <td>
                                            <%#Eval("LastUpdated")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Priority
                                        </td>
                                        <td>
                                            <%#Eval("Priority")%>
                                        </td>
                                        <td>BIN
                                        </td>
                                        <td>
                                            <%#Eval("BIN")%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>DOB Violation
                                        </td>
                                        <td>
                                            <%#Eval("DOBViolation")%>
                                        </td>
                                        <td>ECB Violation
                                        </td>
                                        <td>
                                            <%#Eval("ECBViolation")%>
                                        </td>
                                    </tr>
                                </table>
                            </DetailRow>
                        </Templates>
                        <SettingsPager Mode="EndlessPaging" PageSize="20"></SettingsPager>
                        <SettingsDetail ShowDetailRow="true" />
                        <Settings ShowHeaderFilterButton="true" VerticalScrollableHeight="400" />
                    </dx:ASPxGridView>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <br />
    </div>

    <% If DetailView Then%>
    <script type="text/javascript">
        $(function () {
            Complaints.BBLE = '<%= Request.QueryString("BBLE").ToString%>';
            Complaints.Refresh();
        });
    </script>
    <% End If%>
</asp:Content>
