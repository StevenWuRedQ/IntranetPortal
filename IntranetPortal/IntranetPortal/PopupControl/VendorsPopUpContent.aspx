<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VendorsPopUpContent.aspx.vb" Inherits="IntranetPortal.VendorsPopUpContent" %>

<%@ Import Namespace="IntranetPortal.ShortSale" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" ng-app="PortalApp" xmlns:ng="http://angularjs.org">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
    <script src="/Scripts/bootstrap-datepicker.js"></script>
    <link rel="stylesheet" href="/Content/bootstrap-datepicker3.css" />
    
  
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/0.9.0/jquery.mask.min.js"></script>
    <script>
        //$(document).ready(function () {
        //    $(".ss_phone").mask("(000) 000-0000");

        //});

    </script>
    <script>
        $.fn.accordion = function (options) {
            var settings = $.extend({
                autoCollapse: false
            }, options);

            var
              $accordion = $(this),
              blockName = $accordion.attr('data-block'),
              $items = $('.' + blockName + '__item', $accordion);

            $accordion.delegate('.' + blockName + '__title', 'click', triggerAccordion);

            function triggerAccordion() {
                var
                  $that = $(this),
                  $parent = $that.parent(),
                  $content = $parent.children('.' + blockName + '__content'),
                  isOpen = $that.hasClass('js-accordion--open'),
                  autoCollapse = true,
                  contentHeight = $content.prop('scrollHeight');

                if (isOpen) {
                    $that.removeClass('js-accordion--open');
                    $parent.removeClass('js-accordion--open');
                    $content.css('height', contentHeight);
                    setTimeout(function () {
                        $content.removeClass('js-accordion--open').css('height', '');
                    }, 4);
                } else {
                    if (settings.autoCollapse) {
                        //auto collapse open accordions
                    }
                    $that.addClass('js-accordion--open');
                    $parent.addClass('js-accordion--open');
                    $content.addClass('js-accordion--open').css('height', contentHeight).one('webkitTransitionEnd', event, function () {
                        if (event.propertyName === 'height') {
                            $(this).css('height', '');
                        }
                    });
                }
            }
        };

        $(document).ready(function () {
            $('.js-sidebar').accordion();

        });
    </script>

    <style>
        @charset "UTF-8";



        .barebone, .sidebar {
            max-width: 464px;
            width: 86%;
            margin: 20px auto;
        }

        .barebone__title {
            cursor: pointer;
            
            user-select: none;
        }

        .barebone__content {
            height: 0;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            overflow: hidden;
            -webkit-transition: height linear .1s;
            transition: height linear .1s;
        }

            .barebone__content.js-accordion--open {
                height: auto;
            }

        .sidebar {
            font-family: Arial, sans-serif;
            font-size: 16px;
            background-color: white;
        }

        .sidebar__title {
            cursor: pointer;
          
            user-select: none;
        }

        .sidebar__content {
            height: 0;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            overflow: hidden;
            -webkit-transition: height linear .1s;
            transition: height linear .1s;
        }

            .sidebar__content.js-accordion--open {
                height: auto;
            }

        .sidebar__item {
            border: 1px solid #ddd;
            border-top: 0;
        }

            .sidebar__item:first-child {
                border-top: 1px solid #ddd;
            }

        .sidebar__title {
            position: relative;
            padding: 10px 20px;
            -webkit-transition: all ease-out .25s;
            transition: all ease-out .25s;
            font-weight: bold;
            padding-right: 40px;
        }

            .sidebar__title::after, .sidebar__title:after {
                position: absolute;
                content: '+';
                right: 14px;
                top: 50%;
                -webkit-transform: translate(0%, -50%);
                -ms-transform: translate(0%, -50%);
                transform: translate(0%, -50%);
                width: 22px;
                height: 22px;
                text-align: center;
                background-color: white;
                color: #666;
                border-radius: 100%;
                line-height: 23px;
            }

            .sidebar__title.js-accordion--open {
                /*background-color: #eee;*/
            }

                .sidebar__title.js-accordion--open::after, .sidebar__title.js-accordion--open:after {
                    content: '–';
                    line-height: 20px;
                }

        .sidebar__content {
            padding-left: 20px;
            padding-right: 20px;
            font-size: 14px;
            padding-top: 0;
            padding-bottom: 0;
            -webkit-transition: height ease-out .25s;
            transition: height ease-out .25s;
        }

        .inner {
            font-family: Arial, sans-serif;
            font-size: 16px;
            background-color: white;
            margin-bottom: 20px;
        }

        .inner__title {
            cursor: pointer;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .inner__content {
            height: 0;
            padding-top: 0 !important;
            padding-bottom: 0 !important;
            overflow: hidden;
            -webkit-transition: height linear .1s;
            transition: height linear .1s;
        }

            .inner__content.js-accordion--open {
                height: auto;
            }

        .inner__item {
            border: 1px solid #ddd;
            border-top: 0;
        }

            .inner__item:first-child {
                border-top: 1px solid #ddd;
            }

        .inner__title {
            position: relative;
            padding: 10px 20px;
            -webkit-transition: all ease-out .25s;
            transition: all ease-out .25s;
            font-weight: bold;
            padding-right: 60px;
        }

            /*.inner__title::after, .inner__title:after {
                position: absolute;
                content: '+';
                right: 14px;
                top: 50%;
                -webkit-transform: translate(0%, -50%);
                -ms-transform: translate(0%, -50%);
                transform: translate(0%, -50%);
                width: 22px;
                height: 22px;
                text-align: center;
                background-color: white;
                color: #666;
                border-radius: 100%;
                line-height: 23px;
            }*/

            .inner__title.js-accordion--open {
                background-color: #eee;
            }

                .inner__title.js-accordion--open::after, .inner__title.js-accordion--open:after {
                    content: '–';
                    line-height: 20px;
                }

        .inner__content {
            padding-left: 20px;
            padding-right: 20px;
            font-size: 14px;
            padding-top: 0;
            padding-bottom: 0;
            -webkit-transition: height ease-out .25s;
            transition: height ease-out .25s;
        }

        .sidebar p, .inner p {
            margin-bottom: 20px;
            color: #777;
            line-height: 20px;
        }

            .sidebar p:first-child, .inner p:first-child {
                margin-top: 20px;
            }

            .sidebar p strong, .inner p strong {
                font-weight: bold;
                color: #444;
            }

        .notafter:after {
            content: none !important;
        }

        .nodisplay {
            display: none;
        }
    </style>

    <%--<script src="/Scripts/angular.js"></script>--%>
</head>
<body ng-controller="PortalCtrl" id="PortalCtrl">
    <form id="form1" runat="server">
        <link href="/css/stevencss.css?v=1.02" rel="stylesheet" type="text/css" />
        <div style="color: #b1b2b7" class="clearfix">
            <div class="row" style="margin: 0px">
               
                <input type="hidden" id="CurrentUser" value="<%= Page.User.Identity.Name%>" />
                <div class="col-md-3">

                    <div class="modal fade" id="AddGroupPopup" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                    <h4 class="modal-title">Add Group</h4>
                                </div>
                                <div class="modal-body">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item">
                                            <label class="ss_form_input_title">Group Name</label>
                                            <input class="ss_form_input" ng-model="addGroupName" />
                                        </li>

                                    </ul>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" ng-click="AddGroups()" data-dismiss="modal">Add</button>
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div style="height: 590px;overflow: auto">

                        <div data-block="sidebar" class="sidebar js-sidebar">
                            <div class="sidebar__item">

                                <div class="sidebar__title notafter" ng-click="ChangeGroups({})">
                                    <div class="clear-fix">All Vendors  <i class="fa fa-user-plus icon_btn layout_float_right" title="Add group" ng-click="popAddgroup(0)"></i></div>

                                </div>
                                <div class="sidebar__content nodisplay">
                                </div>

                            </div>
                            <div class="sidebar__item" ng-repeat="group in Groups">

                                <div class="sidebar__title" ng-class="group.SubGroups==null||group.SubGroups.length==0?'notafter':''" ng-click="ChangeGroups(group)">
                                    <div>{{group.GroupName}} <i class="fa fa-user-plus icon_btn layout_float_right" title="Add group" ng-click="popAddgroup(group.Id)"></i></div>
                                </div>
                                <div class="sidebar__content" ng-class="group.SubGroups==null||group.SubGroups.length==0?'nodisplay':''">
                                    <div data-block="inner" class="inner js-sidebar">
                                        <div class="inner__item" ng-repeat="sbgroup in group.SubGroups">
                                            <div class="inner__title" ng-click="ChangeGroups(sbgroup)">
                                                <div>{{sbgroup.GroupName}}</div>
                                            </div>

                                        </div>

                                    </div>
                                </div>
                            </div>

                        </div>


                    </div>
                    <div style="font-size: 16px; color: #3993c1; font-weight: 700; display: none">

                        <ul class="list-group" style="box-shadow: none">

                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===''?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,'')">All Vendors</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===3?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,3)">Employees</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===0?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,0)">Title Companies</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===2?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,2)">Attorneys</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===1?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,1)">Sellers</li>
                            <li class="list-group-item popup_menu_list_item" ng-class="query.Type===4?'popup_menu_list_item_active':''" ng-click="filterContactFunc($event,4)">Lenders</li>

                        </ul>
                        <ul class="list-group" style="box-shadow: none; margin-left: 20px; margin-top: -18px;">
                            <li class="list-group-item popup_menu_list_item" ng-repeat="cropName in lenderList" ng-click="filterContactFunc($event,4)">{{ cropName }}</li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-4" style="border-left: 1px solid #eee; border-right: 1px solid #eee">
                    <div style="padding: 0 10px">
                        <div>

                            <div class="clearfix" style="color: #234b60; font-size: 20px">
                                {{selectType}}
                                <div style="float: right">
                                    <div style="display: inline-block">
                                        <i class="fa fa-plus-circle tooltip-examples icon_btn" title="Add" style="color: #3993c1; font-size: 24px" data-toggle="modal" data-target="#myModal"></i>
                                        <!-- Modal -->
                                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                                        <h4 class="modal-title" id="myModalLabel">New Vendors</h4>
                                                    </div>
                                                    <div class="modal-body">
                                                        <ul class="ss_form_box clearfix">
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">name</label>
                                                                <%--<input class="ss_form_input" value='<%# Bind("Name")%>' runat="server" id="txtContact">--%>
                                                                <dx:ASPxTextBox runat="server" ID="txtContact" ng-model="addContact.Name" CssClass="ss_form_input" Native="true">
                                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Company Name</label>

                                                                <dx:ASPxTextBox runat="server" ID="txtCompanyName" ng-model="addContact.CorpName" CssClass="ss_form_input" Native="true">
                                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">address</label>
                                                                <input class="ss_form_input" ng-model="addContact.Address" runat="server" id="txtAddress" />
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">office #</label>
                                                                <input class="ss_form_input ss_phone" input-mask="(000) 000-0000" ng-model="addContact.OfficeNO" />

                                                                <%--  <dx:ASPxTextBox runat="server" ID="txtOffice" ng-model="addContact.OfficeNO" CssClass="ss_form_input ss_phone" Native="true">
                                                                    <MaskSettings Mask="(999) 000-0000" IncludeLiterals="None" />
                                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                                                </dx:ASPxTextBox>--%>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Extension </label>
                                                                <%--<input class="ss_form_input"  ng-model="addContact.OfficeNO" />--%>
                                                                <input class="ss_form_input" ng-model="addContact.Extension" runat="server" />
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Fax </label>
                                                                <%--<input class="ss_form_input"  ng-model="addContact.OfficeNO" />--%>
                                                                <input class="ss_form_input" input-mask="(000) 000-0000" ng-model="addContact.Fax" />
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Cell #</label>
                                                                <input class="ss_form_input ss_phone" input-mask="(000) 000-0000" ng-model="addContact.Cell" />
                                                                <%--<dx:ASPxTextBox runat="server" ID="txtCell" ng-model="addContact.Cell" CssClass="ss_form_input ss_phone" Native="true">
                                                                    <MaskSettings Mask="(999) 000-0000" IncludeLiterals="None" />
                                                                    <ValidationSettings CausesValidation="false" RequiredField-IsRequired="false" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                                                </dx:ASPxTextBox>--%>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">email</label>
                                                                <%-- <input ng-model="addContact.Email" class="ss_form_input" />--%>
                                                                <dx:ASPxTextBox runat="server" ID="txtEmail" ng-model="addContact.Email" CssClass="ss_form_input" Native="true">
                                                                    <ValidationSettings ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact">
                                                                        <RegularExpression ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ErrorText="Email isnot valid." />
                                                                    </ValidationSettings>
                                                                </dx:ASPxTextBox>
                                                            </li>
                                                            <li class="ss_form_item" style="display: none">
                                                                <label class="ss_form_input_title">Type</label>

                                                                <select class="ss_form_input" ng-model="addContact.Type">
                                                                    <option value=""></option>
                                                                    <% For Each v In getVenderTypes()%>
                                                                    <option value="<%= v.key %>"><%= v.value %> </option>
                                                                    <% Next%>
                                                                </select>
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Group</label>

                                                                <select class="ss_form_input" ng-model="addContact.GroupId">
                                                                    <option value=""></option>
                                                                    <% For Each v In GroupType.GetAllGroupType(True)%>
                                                                    <option value="<%= v.Id%>"><%= v.GroupName %> </option>
                                                                    <% Next%>
                                                                </select>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-primary" ng-click="addContactFunc()" data-dismiss="modal">Add</button>
                                                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <i class="fa fa-sort-amount-desc tooltip-examples icon_btn" title="Sort" ng-class="predicate=='Name'?'fa-sort-amount-desc':'fa-sort-amount-asc'" ng-click="group_text_order = group_text_order=='group_text'?'-group_text':'group_text'; " style="color: #999ca1"></i>
                                </div>
                            </div>
                            <input style="margin-top: 20px;" type="text" class="form-control" placeholder="Type employee's name" ng-model="query.Name">
                            <div style="margin-top: 10px; height: 350px; overflow: auto" id="employee_list">
                                <div>
                                    <ul class="list-group" style="box-shadow: none" ng-repeat="groupedcontact in showingContacts|orderBy:group_text_order">
                                        <%--<li class="list-group-item popup_menu_list_item" style="font-size: 18px; width: 80px; cursor: default; font-weight: 900">{{groupedcontact.group_text}}
                                            <span class="badge" style="font-size: 18px; border-radius: 18px;">{{groupedcontact.data.length}}</span>
                                        </li>--%>
                                        <li class="list-group-item popup_menu_list_item popup_employee_list_item" ng-class="contact.ContactId==currentContact.ContactId? 'popup_employee_list_item_active':''" ng-repeat="contact in groupedcontact.data|orderBy:predicate| filter:query.Name| ByContact:query ">
                                            <div>
                                                <div style="font-weight: 900; font-size: 16px">
                                                    <label style="width: 100%" class="icon_btn" ng-click="selectCurrent(contact)">{{contact.Name}} </label>
                                                    <%--<i class="fa fa-list-alt icon_btn" style="float: right; margin-right: 20px; margin-top: 0px; font-size: 18px;"></i>--%>
                                                </div>
                                                <%--<div style="font-size: 14px">Eviction</div>--%>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div style="margin-top: 20px; display: none">
                                <%--Press ‘Ctrl’ or ‘Command’ for multiple selections.--%>
                                    Check to muliple selections.
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
                                        <img src="/images/User-Empty-icon.png" class="img-circle" style="width: 100px; height: 100px" />
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
                                    <td class="vendor_info_left">Name
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" ng-model="currentContact.Name" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Company Name
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" ng-model="currentContact.CorpName" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>

                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Office address
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" ng-model="currentContact.Office" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Office #
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" input-mask="(000) 000-0000" ng-model="currentContact.OfficeNO" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Extension
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" ng-model="currentContact.Extension" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Fax
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <input class="form-control contact_info_eidt" input-mask="(000) 000-0000" ng-model="currentContact.Fax" placeholder="Click to input">
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
                                            <input class="form-control contact_info_eidt" input-mask="(000) 000-0000" ng-model="currentContact.Cell" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Email
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <span style="color: #3993c1">
                                                <input class="form-control contact_info_eidt" style="color: #3993c1" ng-model="currentContact.Email" placeholder="Click to input">
                                            </span>

                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info" style="display: none">
                                    <td class="vendor_info_left">Type
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <select class="form-control contact_info_eidt" ng-model="currentContact.Type">
                                                <option value=""></option>
                                                <% For Each v In getVenderTypes()%>
                                                <option value="<%= v.key %>"><%= v.value %> </option>
                                                <% Next%>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Group
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <select class="form-control contact_info_eidt" ng-model="currentContact.GroupId">
                                                <option value=""></option>
                                                <% For Each v In GroupType.GetAllGroupType(True)%>
                                                <option value="<%= v.Id%>"><%= v.GroupName %> </option>
                                                <% Next%>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Address
                                    </td>
                                    <td>
                                        <div class="detail_right">
                                            <span >
                                                <input class="form-control contact_info_eidt" ng-model="currentContact.Address" placeholder="Click to input">
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
    <!-- Angular Material Dependencies -->
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular-animate.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular-aria.js"></script>

    
   
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script src="/Scripts/stevenjs.js"></script>
    <script src="/Scripts/PortalApp.js?v=1.6"></script>
    <script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>
    <%--  <script>
         $(document).ready(function () {
                 format_input();
             }
         )
    </script>--%>
    <script>
        function saveContact()
        {
            angular.element(document.getElementById("PortalCtrl")).scope().SaveCurrent();
        }
        
    </script>
    <script src="/Scripts/bootstrap.min.js"></script>
</body>
</html>
