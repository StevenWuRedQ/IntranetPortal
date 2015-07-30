<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuyerEntityPopUpContent.aspx.vb" Inherits="IntranetPortal.BuyerEntityPopUpContent" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
    <link href="/css/Contacts.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/ContactJs.js"></script>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="BuyerEntityCtrl" ng-controller="BuyerEntityCtrl">
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
                    <div style="overflow: auto">

                        <div data-block="sidebar" class="sidebar js-sidebar">

                            <div class="sidebar__item" ng-class="group.GroupName==selectType?'title_selected':''" ng-repeat="group in Groups">

                                <div class="sidebar__title" ng-class="group.SubGroups==null||group.SubGroups.length==0?'notafter':''" ng-click="ChangeGroups(group.GroupName)">
                                    {{group.GroupName}}
                                </div>
                                <div class="sidebar__content" ng-class="group.SubGroups==null||group.SubGroups.length==0?'nodisplay':''">
                                    <div data-block="inner" class="inner js-sidebar">
                                        <div class="inner__item" ng-class="sbgroup.GroupName==selectType?'title_selected':''" ng-repeat="sbgroup in group.SubGroups">
                                            <div class="inner__title" ng-click="ChangeGroups(sbgroup.GroupName)">
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
                                        <i class="fa fa-plus-circle tooltip-examples icon_btn" title="Add" style="color: #3993c1; font-size: 24px;display:none" data-toggle="modal" data-target="#myModal"></i>
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
                                                                <input class="ss_form_input ss_phone" ng-model="addContact.OfficeNO" />

                                                                <%--  <dx:ASPxTextBox runat="server" ID="txtOffice" ng-model="addContact.OfficeNO" CssClass="ss_form_input ss_phone" Native="true">
                                                                    <MaskSettings Mask="(999) 000-0000" IncludeLiterals="None" />
                                                                    <ValidationSettings RequiredField-IsRequired="true" ErrorDisplayMode="ImageWithTooltip" ValidationGroup="Contact"></ValidationSettings>
                                                                </dx:ASPxTextBox>--%>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Customer Service</label>
                                                                <input class="ss_form_input ss_phone" ng-model="addContact.CustomerService" />

                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Extension </label>
                                                                <%--<input class="ss_form_input"  ng-model="addContact.OfficeNO" />--%>
                                                                <input class="ss_form_input" ng-model="addContact.Extension" runat="server" />
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Fax </label>
                                                                <%--<input class="ss_form_input"  ng-model="addContact.OfficeNO" />--%>
                                                                <input class="ss_form_input" ng-model="addContact.Fax" />
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Cell #</label>
                                                                <input class="ss_form_input ss_phone" ng-model="addContact.Cell" />
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
                                                                </select>
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">Group</label>

                                                                <select class="ss_form_input" ng-model="addContact.GroupId">
                                                                    <option value=""></option>

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
                                    <i class="fa fa-sort-amount-desc tooltip-examples icon_btn"  title="Sort" ng-class="predicate=='Name'?'fa-sort-amount-desc':'fa-sort-amount-asc'" ng-click="group_text_order = group_text_order=='group_text'?'-group_text':'group_text'; " style="color: #999ca1;display:none"></i>
                                </div>
                            </div>
                            <input style="margin-top: 20px;" type="text" class="form-control" placeholder="Type entity's name" ng-model="query.Name">
                            <div style="margin-top: 10px; height: 450px; overflow: auto" id="employee_list">
                                <div>
                                    <ul class="list-group" style="box-shadow: none">
                                        <%--<li class="list-group-item popup_menu_list_item" style="font-size: 18px; width: 80px; cursor: default; font-weight: 900">{{groupedcontact.group_text}}
                                            <span class="badge" style="font-size: 18px; border-radius: 18px;">{{groupedcontact.data.length}}</span>
                                        </li>--%>
                                        <li class="list-group-item popup_menu_list_item popup_employee_list_item" ng-class="contact.EntityId==currentContact.EntityId? 'popup_employee_list_item_active':''" ng-repeat="contact in CorpEntites| filter:EntitiesFilter|filter:query.Name">
                                            <div>
                                                <div style="font-weight: 900; font-size: 16px">
                                                    <label style="width: 100%" class="icon_btn" ng-click="selectCurrent(contact)">{{contact.CorpName}} </label>

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
                                    <td align="center">
                                        <i class="fa fa-building" style="font-size:50px"></i>
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <div style="font-size: 30px; color: #234b60">{{currentContact.CorpName}}</div>

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
                                 <tr class="vendor_info">
                                    <td class="vendor_info_left">Status
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <select class="form-control " ng-model="currentContact.Status"  ng-options="o.GroupName as o.GroupName for o  in AllGroups()">
                                             </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Company Name
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.CorpName" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>

                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Address
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.Address" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Property Assigned
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.PropertyAssigned" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>

                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Filling Date
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ss-date ng-model="currentContact.FillingDate" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>

                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Signer
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.Signer" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Office
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.Office" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>

                                <tr class="vendor_info">
                                    <td class="vendor_info_left">EIN #
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ng-model="currentContact.EIN" placeholder="Click to input">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Assign On
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <span >
                                                <input class="form-control " ss-date ng-model="currentContact.AssignOn" placeholder="Click to input">
                                            </span>

                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info" >
                                    <td class="vendor_info_left">Received On
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ss-date ng-model="currentContact.ReceivedOn">
                                            
                                        </div>
                                    </td>
                                </tr>
                               
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
    </div>
    <script>
        var portalApp = angular.module('PortalApp');
     
        portalApp.controller('BuyerEntityCtrl', function ($scope, $http, $element, $parse) {

            $scope.selectType = 'All Entities'
            $scope.Groups = [{ GroupName: 'All Entities' }, { GroupName: 'Available' }, { GroupName: 'Assigned Out' }, { GroupName: 'Current Offer', SubGroups: [{ GroupName: 'NHA Current Offer' }, { GroupName: 'Isabel Current Offer' }] },
                { GroupName: 'Quiet Title Action' }, { GroupName: 'Deed Purchase' },
                { GroupName: 'Straight Sale' }, { GroupName: 'Sold', SubGroups: [{ GroupName: 'Purchased' }, { GroupName: 'Partnered' }, { GroupName: 'Sold (Final Sale)/Recyclable' }] }, { GroupName: 'In House' }, { GroupName: 'Agent Corps' }]
            $scope.ChangeGroups = function (name) {
                $scope.selectType = name;
            }


            $http.get('/Services/ContactService.svc/GetAllBuyerEntities').success(function (data, status, headers, config) {
                $scope.CorpEntites = data;
                $scope.currentContact = $scope.CorpEntites[0];
            }).error(function (data, status, headers, config) {
                 alert('Get All byer Entities error : '+ JSON.stringify(data))
            });
          
            $scope.EntitiesFilter = function(entity)
            {
                if ($scope.selectType == 'All Entities' || $scope.selectType == entity.Status)
                    return true;
                var subs = $scope.Groups.filter(function (o) { return o.GroupName == $scope.selectType })[0];
                if (subs && subs.SubGroups)
                {
                    for(var i = 0;i<subs.SubGroups.length;i++)
                    {
                        var sg = subs.SubGroups[i];
                        if(sg.GroupName==entity.Status)
                        {
                            return true;
                        }
                    }
                }

                return false;
            }
            $scope.selectCurrent =function(contact)
            {
                $scope.currentContact = contact
            }
            $scope.SaveCurrent = function()
            {
                $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify( $scope.currentContact) }).success(function (data, status, headers, config) {
                  alert("Save succeed!")
                }).error(function (data, status, headers, config) {
                    alert("Get error save corp entitiy : "+JSON.stringify(data))
                });
            }
            $scope.AllGroups = function()
            {
                var HasSub = $scope.Groups.filter(function (o) { return o.SubGroups != null });
                var groups = [];
                for(var i ;i<HasSub.length;i++)
                {
                    groups = groups.concat(HasSub[i].SubGroups);
                }
                var HasNotSub = $scope.Groups.filter(function (o) { return o.SubGroups == null &&o.GroupName!='All Entities' });
                groups = groups.concat(HasNotSub);
                return groups;
            }
        });

    </script>
</asp:Content>
