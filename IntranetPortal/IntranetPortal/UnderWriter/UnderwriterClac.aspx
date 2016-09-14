<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwriterClac.aspx.vb" Inherits="IntranetPortal.UnderwriterClac" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <style>
        body {
            font-size: 14px !important;
        }

        div table {
            width: 98%;
            table-layout: fixed;
        }

        td {
            border-bottom: 1px solid grey;
            border-top: 1px solid grey;
        }

        td.td-label {
            padding-right: 10px;
            border-right: 1px solid grey;
            width: 160px;
            height: 100%;
            font-weight: bold;
        }
        
        td input {
            border: none;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        div textarea {
            width: 100%;
            min-height: 300px;
            resize: vertical;
        }

        .excel-green{
            background:green;
        }
        .excel-yellow{
            background:yellow;
        }
        .excel-blue{
            background:#00b0f0;
        }
        .excel-oragne{
            background:orange;
        }
    </style>
    <div id="underwrite_clac" ng-controller="UnderwriterController">
        <ui-view></ui-view>
        <nav class="navbar navbar-default navbar-fixed-bottom">
            <div class="container-fluid">
                <ul class=" nav navbar-nav">
                    <li ng-class="{ active: isActive('/datainput')}"><a ui-sref="datainput" ui-sref-active="active">Data Input</a></li>
                    <li ng-class="{ active: isActive('/flipsheets')}"><a ui-sref="flipsheets" ui-sref-active="active">FlipSheets</a></li>
                    <li ng-class="{ active: isActive('/rentalmodels')}"><a ui-sref="rentalmodels" ui-sref-active="active">Rental Model</a></li>
                    <li ng-class="{ active: isActive('/tables')}"><a ui-sref="tables" ui-sref-active="active">Tables</a></li>
                </ul>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>
    </div>

</asp:Content>
