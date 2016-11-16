<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="IntranetDashboard.Dashboard" %>

<%@ Register Assembly="DevExpress.Dashboard.v15.1.Web, Version=15.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.DashboardWeb" TagPrefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.0/lodash.min.js"></script>
    <script>
        
        function itemClick(s, args) {
            //console.log(JSON.stringify(s));
            //console.log(JSON.stringify(e));
            var underlyingData = [];
            args.RequestUnderlyingData(function (data) {
                dataMembers = data.GetDataMembers();
                dataMembers = _.filter(dataMembers, function (o) {
                    return ['MoveOutHot', 'MoveInHot','MovInHot'].indexOf(o) < 0
                });
              
                for (var i = 0; i < data.GetRowCount() ; i++) {
                    var dataTableRow = {};
                    $.each(dataMembers, function (__, dataMember) {
                        dataTableRow[dataMember] = data.GetRowValue(i, dataMember);
                    });
                    underlyingData.push(dataTableRow);
                }
                var $grid = $('<div/>');
                $grid.dxDataGrid({
                    height: 500,
                    scrolling: {
                        mode: 'virtual'
                    },
                    headerFilter: {
                        visible: true
                    },
                    dataSource: underlyingData
                });

                var popup = $("#myPopup").data("dxPopup");
                $popupContent = popup.content();
                $popupContent.empty();
                $popupContent.append($grid);
                popup.show();

            });
        }
        function initPopup() {
            $("#myPopup").dxPopup({
                width: 800, height: 600,
                title: "Underlying data",
                showCloseButton: true
            });
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div id="myPopup"></div>
            <dx:ASPxDashboardViewer ID="ASPxDashboardViewer1" runat="server"
                FullscreenMode="True" DashboardSource="~/App_Data/LeadDashboard.xml" Height="100%" Width="100%"
                RedrawOnResize="True" DashboardTheme="Dark">
                <ClientSideEvents ItemClick="itemClick"
                    Init="initPopup" />
            </dx:ASPxDashboardViewer>
        </div>
    </form>

</body>
</html>
