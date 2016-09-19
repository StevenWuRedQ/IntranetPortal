﻿<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwriterClac.aspx.vb" Inherits="IntranetPortal.UnderwriterClac" %>

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

        th {
            border: 1px solid #ddd;
            padding-left: 2px;
        }

        td {
            border: 1px solid #ddd;
            padding-left: 2px;
        }

            td.td-label {
                padding-right: 10px;
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

        th input {
            border: 1px solid #ddd;
            padding: 0;
            text-align: right;
            width: 100%;
        }

        div textarea {
            width: 100%;
            min-height: 300px;
            resize: vertical;
        }

        div .pt-panel {
            margin: 10px 2px;
        }

        .excel-green {
            background: #D4FFD4;
        }

        .excel-yellow {
            background: yellow;
        }

        .excel-blue {
            background: #00b0f0;
        }

        .excel-orange {
            background: orange;
        }

        .excel-default {
            background: black;
            color: white;
        }
    </style>
    <div id="underwrite_clac" ng-controller="UnderwriterController">
        <ui-view>
            <ui-view></ui-view>
        </ui-view>
        <nav class="navbar navbar-default navbar-fixed-bottom">
            <div class="container-fluid">
                <ul class=" nav navbar-nav">
                    <li ui-sref-active="active"><a ui-sref="underwriter.datainput" >Data Input</a></li>
                    <li ui-sref-active="active"><a ui-sref="underwriter.flipsheets" >FlipSheets</a></li>
                    <li ui-sref-active="active"><a ui-sref="underwriter.rentalmodels" >Rental Model</a></li>
                    <li ui-sref-active="active"><a ui-sref="underwriter.tables">Tables</a></li>
                </ul>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>
    </div>

</asp:Content>
