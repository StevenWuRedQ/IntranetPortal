<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="MyFollowup.aspx.vb" Inherits="IntranetPortal.MyFollowup" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">

    

</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style type="text/css">
        label.xlink {
            color: black;
        }

        label.xlink:hover {
            color: blue;
        }

        .round-button {
            width: 25%;
        }

        .round-button-circle {
            width: 100%;
            height: 0;
            padding-bottom: 100%;
            border-radius: 50%;
            overflow: hidden;
            background: #4679BD;
            text-align: center;
            vertical-align: baseline;
            color: white;
        }

        .round-button-circle:hover {
            background: #30588e;
        }

        a.dx-link-MyIdealProp:hover {
            font-weight: 500;
            cursor: pointer;
        }

        .myRow:hover {
            background-color: #efefef;
        }

        .apply-filter-option {
            margin-top: 10px;
            margin-left: 10px;
            position: absolute;
            z-index: 1;
            top: 0;
            line-height: 38px;
            font-size: 20px;
            font-weight: 600;
        }

        .apply-filter-option > div:last-child {
            display: inline-block;
            vertical-align: top;
            margin-left: 20px;
            line-height: normal;
        }
    </style>

    <input type="text" style="display: none" />
    <div class="apply-filter-option">
        Folow Up
    <%--<div id="useFilterApplyButton"></div>--%>
    </div>
    <div id="gridContainer" style="" runat="server"></div>
    <script>
        var FollowUp_<%= Me.ClientID%> = {
            url: "/api/Followup",
            dxGridName: "#<%= gridContainer.ClientID%>",
            headName: "FollowUp_<%= ClientID%>",
            loadData: function () {
                var tab = this;
                $.getJSON(tab.url).done(function (data) {
                    var dataGrid = $(tab.dxGridName).dxDataGrid({
                        dataSource: data.data,
                        searchPanel: {
                            visible: true,
                            width: 240,
                            placeholder: "Search..."
                        },
                        rowAlternationEnabled: true,
                        pager: {
                            showInfo: true
                        },
                        paging: {
                            enabled: true,
                        },
                        onRowPrepared: function (rowInfo) {
                            if (rowInfo.rowType != 'data')
                                return;
                            rowInfo.rowElement
                            .addClass('myRow');                           
                        },
                        onContentReady: function (e) {
                            var spanTotal = $('#' + tab.headName).find('.employee_lest_head_number_label')[0];
                            if (spanTotal) {
                                $(spanTotal).html(data.count);
                            }
                        },
                        showColumnLines: false,
                        columns: [{
                            dataField: "CaseName",
                            caption: "Case Name",
                            cellTemplate: function (container, options) {
                                $('<a/>').addClass('dx-link-MyIdealProp')
                                    .text(options.value)
                                    .on('dxclick', function () {
                                        var url = options.data.URL;
                                        PortalUtility.ShowPopWindow("View FollowUp Case - " + options.data.BBLE, url);
                                    })
                                    .appendTo(container);
                            },
                        }, {
                            dataField: "FollowUpDate",
                            caption: "Follow Up Date",
                            dataType: "date",
                            customizeText: function (cellInfo) {
                                //return moment(cellInfo.value).tz('America/New_York').format('MM/dd/yyyy hh:mm tt')
                                if (!cellInfo.value)
                                    return ""

                                var dt = PortalUtility.FormatLocalDateTime(cellInfo.value);
                                if (dt)
                                    return moment(dt).format('MM/DD/YYYY hh:mm a');

                                return ""
                            }
                        }, {
                           dataField: "UserName"
                        },
                        {
                            caption: '',
                            width: 80,
                            cellTemplate: function (container, options) {
                                var div = $('<input />')
                                           .attr('type', 'button')
                                           .attr('title', 'Clear')
                                           .attr('value', 'Clear')
                                           .on('dxclick', function () {
                                               tab.clearFollowUp(options.data.FollowUpId);
                                           })
                                           .appendTo(container);
                                   
                            }
                        }],
                    }).dxDataGrid('instance');
                });
            },
            clearFollowUp: function (followUpId) {
                var tab = this;
                AngularRoot.confirm("Are you sure to clear?").then(function (r) {
                    if (r) {
                        $.ajax({
                            url: '/api/Followup/',
                            type: 'DELETE',
                            data: JSON.stringify(followUpId),
                            cache: false,
                            contentType: 'application/json',
                            success: function (data) {
                                AngularRoot.alert('Successful.');
                                tab.loadData();
                            },
                            error: function (data) {

                                AngularRoot.alert('Some error Occurred!');
                            }
                        });
                    }
                });
            }
        }

        $(function () {
            FollowUp_<%= Me.ClientID%>.loadData();
        });

    </script>
    
</asp:Content>
