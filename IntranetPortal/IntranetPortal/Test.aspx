<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<asp:Content ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div ng-controller="BarCtrl">
        <canvas id="bar" class="chart chart-bar"
            chart-data="data" chart-labels="labels">chart-series="series" chart-options="options"
        </canvas>
    </div>
    <script>
        angular.module("PortalApp").controller("BarCtrl", function ($scope) {
            $scope.labels = ['2006', '2007', '2008', '2009', '2010', '2011', '2012'];
            $scope.series = ['Series A', 'Series B'];

            $scope.data = [
              [65, 59, 80, 81, 56, 55, 40],
              [28, 48, 40, 19, 86, 27, 90]
            ];
            $scope.options = {
            }
        });
    </script>
</asp:Content>

