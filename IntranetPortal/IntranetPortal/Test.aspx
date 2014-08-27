<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Test.aspx.vb" Inherits="IntranetPortal.Test" %>

<%@ Register Src="~/UserControl/DocumentsUI.ascx" TagPrefix="uc1" TagName="DocumentsUI" %>
<%@ Register Src="~/UserControl/NavMenu.ascx" TagPrefix="uc1" TagName="NavMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="/css/font-awesome.css" type="text/css" rel="stylesheet" />

    <script src="/scripts/jquery.collapse.js"></script>
    <script src="/scripts/jquery.collapse_storage.js"></script>
    <script src="/scripts/jquery.collapse_cookie_storage.js"></script>
    <link rel="stylesheet" href="css/normalize.min.css" />
    <link rel="stylesheet" href="/scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="css/main.css" />

    <script src="/scripts/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">

        <%--       <uc1:DocumentsUI runat="server" id="DocumentsUI" />--%>
        <div id="global-nav-container">
            <nav id="global-nav" class="navbar" role="navigation">
                <div class="navbar-header">
                    <a href="#" class="clearfix">
                        <img id="logo" src="images/logo.png" alt="My Ideal Property" class="go-retina" />
                        <span>Portal</span>
                    </a>
                </div>
                <div id="main-nav" class="main-nav-panel">
                    <uc1:NavMenu runat="server" ID="NavMenu" />

                    <ul class="nav navbar-nav">
                        <li><a href="/SummaryPage.aspx" class="category " target="contentUrlPane">Agent</a>
                            <div class="nav-level-2-container">
                                <ul class="nav-level-2">
                                    <li class=""><a href="/SummaryPage.aspx" target="contentUrlPane"><i class="fa fa-bar-chart-o"></i>Summary</a></li>
                                    <li class="has-add-button"><a href="/LeadAgent.aspx?c=Create" class="add-button" target="contentUrlPane"><i class="fa fa-plus-circle"></i></a><a href="/LeadAgent.aspx?c=New Leads" target="contentUrlPane" class=""><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_AgentNewLeads"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Priority" target="contentUrlPane" class=""><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_AgentHotLeads"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Call Back" target="contentUrlPane" class=""><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_AgentFollowUp"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Door Knock" target="contentUrlPane" class=""><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_AgentDoorKnock"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Shared" target="contentUrlPane"><i class="fa fa-share"></i>Shared</a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=In Process" target="contentUrlPane" class=""><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_AgentInProcess"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Dead Lead" target="contentUrlPane" class=""><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_AgentDeadLead"></span></a></li>
                                    <li class=""><a href="/LeadAgent.aspx?c=Closed" target="contentUrlPane" class=""><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_AgentClosed"></span></a></li>
                                </ul>
                            </div>
                        </li>
                    </ul>


                </div>
            </nav>
            <footer id="global-footer">
                <p>Application Version: 2.0 Beta</p>
                <p>&copy; 2014 My Ideal Property</p>
            </footer>
        </div>

        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="/Scripts/js/vendor/jquery-1.11.0.min.js"><\/script>')</script>
        <script src="/Scripts/js/jquery.easing.1.3.js"></script>
        <script src="/Scripts/js/jquery.debouncedresize.js"></script>
        <script src="/Scripts/js/jquery.throttledresize.js"></script>
        <script src="/Scripts/js/jquery.mousewheel.js"></script>
        <script src="/Scripts/js/jquery.mCustomScrollbar/jquery.mCustomScrollbar.min.js"></script>
        <script src="/Scripts/js/main.js"></script>
    </form>
</body>
</html>
