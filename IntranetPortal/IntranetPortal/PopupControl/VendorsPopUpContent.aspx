<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VendorsPopUpContent.aspx.vb" Inherits="IntranetPortal.VendorsPopUpContent" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="PortalApp">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />

    <link href="/css/font-awesome.min.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>   

    
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
    <script src="/scripts/bootstrap-datepicker.js"></script>
    <link rel="stylesheet" href="/Content/bootstrap-datepicker3.css" />
    <script src="/scripts/angular.js"></script>
</head>
<body ng-controller="PortalCtrl">
    <form id="form1" runat="server">
        <link href="/styles/stevencss.css?v=<%=DateTime.Now.Millisecond.ToString %>>" rel="stylesheet" type="text/css" />
        <div style="color: #b1b2b7" class="clearfix">
            <div class="row" style="margin:0px;">
                <div class="col-md-3">
                    <div style="font-size: 16px; color: #3993c1; font-weight: 700">
                        <ul class="list-group" style="box-shadow: none">

                            <li class="list-group-item popup_menu_list_item"  ng-class="query.Type===''?'popup_menu_list_item_active':''" ng-click="query.Type=''">All Vendors</li>
                            <li class="list-group-item popup_menu_list_item"  >Employees</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===0?'popup_menu_list_item_active':''" ng-click="query.Type=0">Title Companies</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===2?'popup_menu_list_item_active':''" ng-click="query.Type=2">Attorneys</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===1?'popup_menu_list_item_active':''" ng-click="query.Type=1">Sellers</li>
                            
                        </ul>
                    </div>
                </div>
                <div class="col-md-4" style="border-left: 1px solid #eee; border-right: 1px solid #eee">
                    <div style="padding: 0 10px">
                        <div>

                            <div class="clearfix" style="color: #234b60; font-size: 20px">
                                Employees
                                <div style="float: right">
                                    <i class="fa fa-sort-amount-desc icon_btn"  ng-class="predicate=='Name'?'fa-sort-amount-desc':'fa-sort-amount-asc'" ng-click="group_text_order = group_text_order=='group_text'?'-group_text':'group_text'; "  style="color: #999ca1"></i>
                                </div>
                            </div>
                            <input style="margin-top: 20px;" type="text" class="form-control" placeholder="Type employee's name" ng-model="query.Name">
                            <div style="margin-top: 10px; height: 350px; overflow: auto" id="employee_list">
                                <div>
                                    <ul class="list-group" style="box-shadow: none" ng-repeat="groupedcontact in showingContacts|orderBy:group_text_order">                                        
                                        <li class="list-group-item popup_menu_list_item" style="font-size: 18px; width: 80px; cursor: default; font-weight: 900">{{groupedcontact.group_text}}
                                            <span class="badge" style="font-size: 18px; border-radius: 18px;">{{groupedcontact.data.length}}</span>
                                        </li>
                                        <li class="list-group-item popup_menu_list_item popup_employee_list_item" ng-class="contact.Name==currentContact.Name? 'popup_employee_list_item_active':''" ng-repeat="contact in groupedcontact.data| filter:query |orderBy:predicate">
                                            <div>
                                                <div style="font-weight: 900; font-size: 16px">
                                                    <span class="icon_btn" ng-click="selectCurrent(contact)">{{contact.Name}}</span>                                                    
                                                    <i class="fa fa-list-alt icon_btn" style="float: right; margin-right: 20px; margin-top: 0px; font-size: 18px;"></i>
                                                </div>
                                                <%--<div style="font-size: 14px">Eviction</div>--%>
                                            </div>
                                        </li>
                                    </ul>                                    
                                </div>
                            </div>
                            <div style="margin-top: 20px">
                                <%--Press ‘Ctrl’ or ‘Command’ for multiple selections.--%>
                                    Check to muliple selections.
                            </div>
                            <div style="margin-top: 20px">
                                <i class="fa fa-plus-circle tooltip-examples icon_btn" title="Add" style="color: #3993c1; font-size: 24px" onclick=""></i>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="col-md-5">
                    <div style="padding: 10px; border-bottom: 1px solid #eee">
                        <div style="padding-bottom: 20px;">
                            <table>
                                <tr>
                                    <td>
                                        <img src="/images/agent_pic_defined.png" class="img-circle" style="width: 100px; height: 100px" />
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <div style="font-size: 30px; color: #234b60">{{currentContact.Name}}</div>
                                           <%-- <div style="font-size: 16px; color: #234b60; font-weight: 900">Sales Agent</div>--%>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <input style="margin-left: 40px;" type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveCurrent()">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="height: 45px">
                                            &nbsp;
                                        </div>
                                    </td>
                                </tr>
                               <%-- <tr class="vendor_info">
                                    <td class="vendor_info_left">Manager
                                    </td>
                                    <td>
                                        <div class="detail_right">Ron Borovinsky</div>
                                    </td>
                                </tr>--%>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Office
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input  class="form-control contact_info_eidt" ng-model="currentContact.Office"  placeholder="Click to input">
                                           </div>
                                    </td>
                                </tr>
                                <%--<tr class="vendor_info">
                                    <td class="vendor_info_left">Employee Since
                                    </td>
                                    <td>
                                        <div class="detail_right">{{currentContact.Office}}</div>
                                    </td>
                                </tr>--%>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Cell
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input  class="form-control contact_info_eidt" ng-model="currentContact.Cell"  placeholder="Click to input">
                                            </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Email
                                    </td>
                                    <td>
                                        <div class="detail_right"><span style="color: #3993c1">
                                             <input  class="form-control contact_info_eidt" style="color: #3993c1" ng-model="currentContact.Email"  placeholder="Click to input">
                                            </span>

                                        </div>
                                    </td>
                                </tr>
                               <%-- <tr class="vendor_info">
                                    <td class="vendor_info_left">Closed deals
                                    </td>
                                    <td>
                                        <div class="detail_right">21</div>
                                    </td>
                                </tr>--%>
                            </table>
                        </div>
                        <div>
                            <div style="margin-top: 20px; margin-left: 5px">
                                Notes 
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </form>
    <script src="/scripts/PortalApp.js?v=<%=DateTime.Now.Millisecond.ToString %>>"></script>
</body>
</html>
