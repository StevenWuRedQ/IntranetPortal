<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="UnderwriterClac.aspx.vb" Inherits="IntranetPortal.UnderwriterClac" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <div id="underwrite_clac" ng-controller="UnderwriterController" data-spy="scroll">
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed affix" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="#">Brand</a>
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="#">Action</a></li>
                                <li><a href="#">Another action</a></li>
                                <li><a href="#">Something else here</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="#">Separated link</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                <!-- /.navbar-collapse -->
            </div>
            <!-- /.container-fluid -->
        </nav>

        <div class="container" style="width: 80%">
            <div class="row">
                <div class="col-md-8 col-lg-8" style="border: 1px dotted black; height: 1800px">
                </div>
                <div id="calc_summary affix" class="col-md-3 col-lg-3 col-lg-offset-1 col-md-offset-1" style="border: 1px dotted black; height: 800px;">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h5 class="panel-title">panel1</h5>
                        </div>
                        <div class="panel-body">
                            <div style="height: 200px">
                            </div>
                        </div>

                    </div>
                    <button type="button" class="btn btn-primary" style="position: absolute; bottom: 10px; width: 50%; float: none; margin: 0 auto !important">calculate</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
