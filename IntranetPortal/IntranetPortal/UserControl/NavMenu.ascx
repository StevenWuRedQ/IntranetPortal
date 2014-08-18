<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NavMenu.ascx.vb" Inherits="IntranetPortal.NavMenu" %>
<ul class="nav navbar-nav">
    <% For Each item In PortalMenuItems%>
    <%= item.ToHtml %>
    <% Next%>

  <%--  <li class="category current"><a href="#">Manager</a>
        <ul class="nav-level-2" runat="server" id="ulNav">
            <li><a href="#"><i class="fa fa-plus-circle"></i>Summary</a></li>
            <li><a href="#"><i class="fa fa-suitcase"></i>My Leads</a>
                <ul class="nav-level-3">
                    <li>
                        <a href="#"><i class="fa fa-plus-circle"></i></a>
                        <a href="#"><i class="fa fa-star"></i>New Leads</a>
                    </li>
                    <li><a href="#"><i class="fa fa-sun-o"></i>Hot Leads</a> <span class="notification">2</span></li>
                    <li><a href="#"><i class="fa fa-rotate-right"></i>Follow Up</a> <span class="notification">4</span></li>
                    <li><a href="#"><i class="fa fa-sign-in"></i>Door Knock</a> <span class="notification">15</span></li>
                    <li><a href="#"><i class="fa fa-share"></i>Shared</a></li>
                    <li><a href="#"><i class="fa fa-refresh"></i>In Process</a></li>
                    <li><a href="#"><i class="fa fa-times-circle"></i>Dead Lead</a> <span class="notification">6</span></li>
                    <li><a href="#"><i class="fa fa-check-circle"></i>Closed</a></li>
                </ul>
            </li>
            <li><a href="#"><i class="fa fa-check-square-o"></i>Assign Leads</a> <span class="notification">463</span></li>
            <li><a href="#"><i class="fa fa-tasks"></i>Task</a> <span class="notification">1</span></li>
            <li><a href="#"><i class="fa fa-star"></i>New Leads </a><span class="notification">1</span></li>
            <li><a href="#"><i class="fa fa-sun-o"></i>Hot Leads</a> <span class="notification">17</span></li>
            <li><a href="#"><i class="fa fa-users"></i>Agent Reports</a></li>
            <li><a href="#"><i class="fa fa-list-ol"></i>Priority</a></li>
            <li><a href="#"><i class="fa fa-rotate-right"></i>Follow Up</a></li>
            <li><a href="#"><i class="fa fa-sign-in"></i>Door Knock</a> <span class="notification">5</span></li>
            <li><a href="#"><i class="fa fa-refresh"></i>In Process</a></li>
            <li><a href="#"><i class="fa fa-times-circle"></i>Dead Lead</a> <span class="notification">7</span></li>
            <li><a href="#"><i class="fa fa-check-circle"></i>Closed</a></li>
            <li><a href="#"><i class="fa fa-search"></i>Search</a></li>
        </ul>
    </li>
    <li class="category"><a href="#">Control Center</a>
        <ul class="nav-level-2">
            <li><a href="#">Test Control Center Item</a></li>
        </ul>
    </li>
    <li class="category"><a href="#">Calendar</a>
        <ul class="nav-level-2">
            <li><a href="#">Test Calendar Item</a></li>
        </ul>
    </li>--%>
</ul>
