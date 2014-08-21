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

                    <li><a href="/SummaryPage.aspx" class="category current" target="contentUrlPane">Manager - 123</a>
                        <div class="nav-level-2-container">
                            <ul class="nav-level-2">
                                <li><a href="/SummaryPage.aspx" target="contentUrlPane"><i class="fa fa-bar-chart-o"></i>Summary</a></li>
                                <li><a href="#" class="has-level-3-menu" target="contentUrlPane"><i class="fa fa-caret-right"></i><i class="fa fa-suitcase"></i>My Leads</a><ul class="nav-level-3">
                                    <li><a href="/LeadAgent.aspx?c=New Leads" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_AgentNewLeads"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Priority" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_AgentHotLeads"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Call Back" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_AgentFollowUp"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Door Knock" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_AgentDoorKnock"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Shared" target="contentUrlPane"><i class="fa fa-share"></i>Shared</a></li>
                                    <li><a href="/LeadAgent.aspx?c=In Process" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_AgentInProcess"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Dead Lead" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_AgentDeadLead"></span></a></li>
                                    <li><a href="/LeadAgent.aspx?c=Closed" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_AgentClosed"></span></a></li>
                                </ul>
                                </li>
                                <li><a href="/Management/LeadsManagement.aspx" target="contentUrlPane"><i class="fa fa-check-square-o"></i>Assign Leads<span class="notification" id="SpanAmount_AssignLeads"></span></a></li>
                                <li><a href="/LeadAgent.aspx?c=Task" target="contentUrlPane"><i class="fa fa-tasks"></i>Task<span class="notification" id="SpanAmount_Task"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=New Leads" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_MgrNewLeads"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=Priority" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_MgrHotLeads"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=Call Back" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_MgrFollowUp"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=Door Knock" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_MgrDoorKnock"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=In Process" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_MgrInProcess"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=Dead Lead" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_MgrDeadLead"></span></a></li>
                                <li><a href="/MgrViewLeads.aspx?c=Closed" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_MgrClosed"></span></a></li>
                            </ul>
                        </div>
                    </li>


                    <li><a href="#" class="category " target="contentUrlPane">Offices</a>
                        <div class="nav-level-2-container">
                            <ul class="nav-level-2">
                                <li><a href="#" target="contentUrlPane">Bronx Offices<span class="notification" id="SpanAmount_Office-Bronx-Management"></span></a><ul class="nav-level-3">
                                    <li><a href="/Management/LeadsManagement.aspx?office=Bronx" target="contentUrlPane"><i class="fa fa-check-square-o"></i>Assign Leads<span class="notification" id="SpanAmount_Office-Bronx-AssignLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=New Leads&o=Bronx" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_Office-Bronx-NewLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Priority&o=Bronx" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_Office-Bronx-HotLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Call Back&o=Bronx" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_Office-Bronx-FollowUp"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Door Knock&o=Bronx" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_Office-Bronx-DoorKnock"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=In Process&o=Bronx" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_Office-Bronx-InProcess"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Dead Lead&o=Bronx" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_Office-Bronx-DeadLead"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Closed&o=Bronx" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_Office-Bronx-Closed"></span></a></li>
                                </ul>
                                </li>
                                <li><a href="#" target="contentUrlPane">Queens Offices<span class="notification" id="SpanAmount_Office-Queens-Management"></span></a><ul class="nav-level-3">
                                    <li><a href="/Management/LeadsManagement.aspx?office=Queens" target="contentUrlPane"><i class="fa fa-check-square-o"></i>Assign Leads<span class="notification" id="SpanAmount_Office-Queens-AssignLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=New Leads&o=Queens" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_Office-Queens-NewLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Priority&o=Queens" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_Office-Queens-HotLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Call Back&o=Queens" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_Office-Queens-FollowUp"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Door Knock&o=Queens" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_Office-Queens-DoorKnock"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=In Process&o=Queens" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_Office-Queens-InProcess"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Dead Lead&o=Queens" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_Office-Queens-DeadLead"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Closed&o=Queens" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_Office-Queens-Closed"></span></a></li>
                                </ul>
                                </li>
                                <li><a href="#" target="contentUrlPane">Patchen Offices<span class="notification" id="SpanAmount_Office-Patchen-Management"></span></a><ul class="nav-level-3">
                                    <li><a href="/Management/LeadsManagement.aspx?office=Patchen" target="contentUrlPane"><i class="fa fa-check-square-o"></i>Assign Leads<span class="notification" id="SpanAmount_Office-Patchen-AssignLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=New Leads&o=Patchen" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_Office-Patchen-NewLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Priority&o=Patchen" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_Office-Patchen-HotLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Call Back&o=Patchen" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_Office-Patchen-FollowUp"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Door Knock&o=Patchen" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_Office-Patchen-DoorKnock"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=In Process&o=Patchen" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_Office-Patchen-InProcess"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Dead Lead&o=Patchen" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_Office-Patchen-DeadLead"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Closed&o=Patchen" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_Office-Patchen-Closed"></span></a></li>
                                </ul>
                                </li>
                                <li><a href="#" target="contentUrlPane">Rockaway Offices<span class="notification" id="SpanAmount_Office-Rockaway-Management"></span></a><ul class="nav-level-3">
                                    <li><a href="/Management/LeadsManagement.aspx?office=Rockaway" target="contentUrlPane"><i class="fa fa-check-square-o"></i>Assign Leads<span class="notification" id="SpanAmount_Office-Rockaway-AssignLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=New Leads&o=Rockaway" target="contentUrlPane"><i class="fa fa-star"></i>New Leads<span class="notification" id="SpanAmount_Office-Rockaway-NewLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Priority&o=Rockaway" target="contentUrlPane"><i class="fa fa-sun-o"></i>Hot Leads<span class="notification" id="SpanAmount_Office-Rockaway-HotLeads"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Call Back&o=Rockaway" target="contentUrlPane"><i class="fa fa-rotate-right"></i>Follow Up<span class="notification" id="SpanAmount_Office-Rockaway-FollowUp"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Door Knock&o=Rockaway" target="contentUrlPane"><i class="fa fa-sign-in"></i>Door Knock<span class="notification" id="SpanAmount_Office-Rockaway-DoorKnock"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=In Process&o=Rockaway" target="contentUrlPane"><i class="fa fa-refresh"></i>In Process<span class="notification" id="SpanAmount_Office-Rockaway-InProcess"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Dead Lead&o=Rockaway" target="contentUrlPane"><i class="fa fa-times-circle"></i>Dead Lead<span class="notification" id="SpanAmount_Office-Rockaway-DeadLead"></span></a></li>
                                    <li><a href="/MgrViewLeads.aspx?c=Closed&o=Rockaway" target="contentUrlPane"><i class="fa fa-check-circle"></i>Closed<span class="notification" id="SpanAmount_Office-Rockaway-Closed"></span></a></li>
                                </ul>
                                </li>
                            </ul>
                        </div>
                    </li>


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
