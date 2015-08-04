<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuyerEntityPopUpContent.aspx.vb" Inherits="IntranetPortal.BuyerEntityPopUpContent" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>


<asp:Content runat="server" ContentPlaceHolderID="head">
    <link href="/css/Contacts.css" rel="stylesheet" type="text/css" />
    <script src="/Scripts/ContactJs.js"></script>
    <style>
        .datepicker {
            z-index: 10000 !important;
        }
    </style>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">


    <div id="BuyerEntityCtrl" ng-controller="BuyerEntityCtrl">
        <div dx-load-panel="{
                 message: 'Loading...',
                 showIndicator: true,
                 shading:true,
                 position:{of:'#BuyerEntityCtrl'},
                 bindingOptions: {
                    visible: 'loadPanelVisible'
            }}">
        </div>
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
                        <uc1:ShortSaleSubMenu runat="server" ID="ShortSaleSubMenu" />
                        <div>

                            <!-- Nav tabs -->
                            <style>
                                li.active
                                {
                                    background:none !important;
                                }
                            </style>
                            <ul class="nav nav-tabs" role="tablist">
                                <li role="presentation" class="active" ><a href="#StatusTab" aria-controls="home" role="tab" data-toggle="tab">Entity Status</a></li>
                                <li role="presentation"  ><a href="#OfficeTab" aria-controls="profile" role="tab" data-toggle="tab">Office</a></li>
                               
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div role="tabpanel" class="tab-pane active" id="StatusTab">
                                    <div data-block="sidebar" class="sidebar js-sidebar">

                                        <div class="sidebar__item" ng-class="group.GroupName==selectType?'title_selected':''" ng-repeat="group in Groups">

                                            <div class="sidebar__title" ng-class="group.SubGroups==null||group.SubGroups.length==0?'notafter':''" ng-click="ChangeGroups(group.GroupName)">
                                                {{group.GroupName}} <span class=" badge pull-right" ng-show="GroupCount(group)>0">{{GroupCount(group)}} </span>
                                            </div>
                                            <div class="sidebar__content" ng-class="group.SubGroups==null||group.SubGroups.length==0?'nodisplay':''">
                                                <div data-block="inner" class="inner js-sidebar">
                                                    <div class="inner__item" ng-class="sbgroup.GroupName==selectType?'title_selected':''" ng-repeat="sbgroup in group.SubGroups">
                                                        <div class="inner__title" ng-click="ChangeGroups(sbgroup.GroupName)">
                                                            <div>{{sbgroup.GroupName}} <span class="badge pull-right" ng-show="GroupCount(sbgroup)>0">{{GroupCount(sbgroup)}} </span></div>
                                                        </div>

                                                    </div>

                                                </div>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <div role="tabpanel" class="tab-pane" id="OfficeTab">
                                    
                                    <div data-block="sidebar" class="sidebar js-sidebar">
                                        <div class="sidebar__item" ng-class="SelectedTeam==''?'title_selected':''">

                                            <div class="sidebar__title" ng-class="group.SubGroups==null||group.SubGroups.length==0?'notafter':''" ng-click="ChangeTeam('')">
                                                All Team <span class=" badge pull-right" ng-show="TeamCount('')>0">{{TeamCount('')}} </span>
                                            </div>
                                          
                                        </div>
                                        <div class="sidebar__item" ng-class="SelectedTeam==team.Name?'title_selected':''" ng-repeat="team in AllTeam">

                                            <div class="sidebar__title" ng-class="group.SubGroups==null||group.SubGroups.length==0?'notafter':''" ng-click="ChangeTeam(team.Name)">
                                                {{team.Name}} <span class=" badge pull-right" ng-show="TeamCount(team.Name)>0">{{TeamCount(team.Name)}} </span>
                                            </div>
                                          
                                        </div>

                                    </div>
                                </div>
                               
                            </div>

                        </div>
                      



                    </div>

                </div>
                <div class="col-md-4" style="border-left: 1px solid #eee; border-right: 1px solid #eee">
                    <div style="padding: 0 10px">
                        <div>

                            <div class="clearfix" style="color: #234b60; font-size: 20px">
                               {{GetTitle()}} 
                                <div style="float: right">
                                    <div style="display: inline-block">
                                        <i class="fa fa-plus-circle tooltip-examples icon_btn" title="Add" style="color: #3993c1; font-size: 24px;" data-toggle="modal" data-target="#myModal"></i>
                                        <!-- Modal -->
                                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                                        <h4 class="modal-title" id="myModalLabel">New Entities</h4>
                                                    </div>
                                                    <div class="modal-body">

                                                        <ul class="ss_form_box clearfix">
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Status
                                                                </label>
                                                                <select class="ss_form_input " ng-model="addContact.Status" ng-options="o.GroupName as o.GroupName for o  in AllGroups()">
                                                                </select>
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Company Name
                                                                </label>
                                                                <input class="ss_form_input " ng-model="addContact.CorpName">
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Address
                                                                </label>
                                                                <input class="ss_form_input " ng-model="addContact.Address">
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Property Assigned
                                                                </label>
                                                                <input class="ss_form_input " ng-model="addContact.PropertyAssigned">
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Filling Date
                                                                </label>
                                                                <input class="ss_form_input " ss-date ng-model="addContact.FillingDate">
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Signer
                                                                </label>
                                                                <input class="ss_form_input " ng-model="addContact.Signer">
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Office
                                                                </label>
                                                                <select class="ss_form_input " ng-model="addContact.Office" ng-options="o.Name as o.Name for o in AllTeam"></select>
                                                            </li>

                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    EIN #
                                                                </label>
                                                                <input class="ss_form_input " ng-model="addContact.EIN">
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Assign On
                                                                </label>

                                                                <input class="ss_form_input " ss-date ng-model="addContact.AssignOn">
                                                            </li>
                                                            <li class="ss_form_item">
                                                                <label class="ss_form_input_title">
                                                                    Received On
                                                                </label>
                                                                <input class="ss_form_input " ss-date ng-model="addContact.ReceivedOn">
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
                                    &nbsp;
                                    <i class="fa fa-file-excel-o tooltip-examples icon_btn" title="Excel" style="color: #3993c1; font-size: 24px;" data-toggle="modal" ng-click="ExportExcel()"></i>
                                    &nbsp;
                                    <a href="https://appext20.dos.ny.gov/ecorp_public/f?p=2020:1:13820438194474" target="_blank">Corporation </a>&nbsp;
                                    <a href="http://www.irs.gov/Businesses/Small-Businesses-&-Self-Employed/Apply-for-an-Employer-Identification-Number-(EIN)-Online" target="_blank">EIN </a>
                                    <i class="fa fa-sort-amount-desc tooltip-examples icon_btn" title="Sort" ng-class="predicate=='Name'?'fa-sort-amount-desc':'fa-sort-amount-asc'" ng-click="group_text_order = group_text_order=='group_text'?'-group_text':'group_text'; " style="color: #999ca1; display: none"></i>
                                </div>
                            </div>
                            <input style="margin-top: 20px;" type="text" class="form-control" placeholder="Type to search" ng-model="query.Name">
                            <div style="margin-top: 10px; height: 450px; overflow: auto" id="employee_list">
                                <div>
                                    <ul class="list-group" style="box-shadow: none">
                                        <%--<li class="list-group-item popup_menu_list_item" style="font-size: 18px; width: 80px; cursor: default; font-weight: 900">{{groupedcontact.group_text}}
                                            <span class="badge" style="font-size: 18px; border-radius: 18px;">{{groupedcontact.data.length}}</span>
                                        </li>--%>
                                        <li class="list-group-item popup_menu_list_item popup_employee_list_item" ng-class="contact.EntityId==currentContact.EntityId? 'popup_employee_list_item_active':''" ng-repeat="contact in (filteredCorps = (CorpEntites| filter:EntitiesFilter|filter:query.Name|filter:SelectedTeam))">
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
                                        <i class="fa fa-building" style="font-size: 50px"></i>
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
                                            <select class="form-control " ng-model="currentContact.Status" ng-options="o.GroupName as o.GroupName for o  in AllGroups()">
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
                                            <select class="form-control " ng-model="currentContact.Office" placeholder="Click to input" ng-options="o.Name as o.Name for o in AllTeam"></select>
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
                                    <td class="vendor_info_left">EIN File
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table" ng-show="!(currentContact.EINFile == null || currentContact.EINFile == '')">
                                            <a href="{{'/pdfViewer/web/viewer.html?file='+encodeURIComponent('/downloadfile.aspx?pdfUrl=' + currentContact.EINFile)}}" target="_blank">View File</a>
                                            <i class="fa fa-remove tooltip-examples icon_btn" title="Remove" ng-click="currentContact.EINFile=null" style="color: #3993c1; font-size: 14px;"></i>
                                        </div>
                                        <div class="detail_right input_info_table" ng-show="(currentContact.EINFile == null || currentContact.EINFile == '')">
                                            <input type="file" id="fileEIN" style="width: 75%; display: inline-block" />
                                            <i class="fa fa-upload tooltip-examples icon_btn" title="Upload" ng-click="UploadFile('fileEIN', 'EIN', 'EINFile')" style="color: #3993c1; font-size: 16px;"></i>
                                            <%--<input type="button" value="Upload" ng-click="UploadFile('fileEIN', 'EIN', 'EINFile')" />--%>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Corporation File
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table" ng-show="!(currentContact.File2 == null || currentContact.File2 == '')">
                                            <a href="{{'/pdfViewer/web/viewer.html?file='+encodeURIComponent('/downloadfile.aspx?pdfUrl=' + currentContact.File2)}}" target="_blank">View File</a>
                                            <i class="fa fa-remove tooltip-examples icon_btn" title="Remove" ng-click="currentContact.File2=null" style="color: #3993c1; font-size: 14px;"></i>
                                        </div>
                                        <div class="detail_right input_info_table" ng-show="(currentContact.File2 == null || currentContact.File2 == '')">
                                            <input type="file" id="File2" style="width: 75%; display: inline-block" />
                                            <i class="fa fa-upload tooltip-examples icon_btn" title="Upload" ng-click="UploadFile('File2', 'Corporation','File2')" style="color: #3993c1; font-size: 16px;"></i>
                                            <%--<input type="button" value="Upload" ng-click="UploadFile('File2', 'Corporation','File2')" />--%>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Other File
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table" ng-show="!(currentContact.File3 == null || currentContact.File3 == '')">
                                            <a href="{{'/pdfViewer/web/viewer.html?file='+encodeURIComponent('/downloadfile.aspx?pdfUrl=' + currentContact.File3)}}" target="_blank">View File</a>
                                            <i class="fa fa-remove tooltip-examples icon_btn" title="Remove" ng-click="currentContact.File3=null" style="color: #3993c1; font-size: 14px;"></i>
                                        </div>
                                        <div class="detail_right input_info_table" ng-show="(currentContact.File3 == null || currentContact.File3 == '')">
                                            <input type="file" id="File3" style="width: 75%; display: inline-block" />
                                            <i class="fa fa-upload tooltip-examples icon_btn" title="Upload" ng-click="UploadFile('File3', 'Corporation2', 'File3')" style="color: #3993c1; font-size: 16px;"></i>
                                            <%--<input type="button" value="Upload" ng-click="UploadFile('File3', 'Corporation2', 'File3')" />--%>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
                                    <td class="vendor_info_left">Assign On
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <span>
                                                <input class="form-control " ss-date ng-model="currentContact.AssignOn" placeholder="Click to input">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info">
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
                            <textarea class="edit_drop" ng-model="currentContact.Notes" style="width: 100%"></textarea>
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
            $scope.Groups = [{ GroupName: 'All Entities' }, { GroupName: 'Available' }, { GroupName: 'Assigned Out' },
                {
                    GroupName: 'Current Offer',
                    SubGroups:
                        [{ GroupName: 'NHA Current Offer' }, { GroupName: 'Isabel Current Offer' },
                        { GroupName: 'Quiet Title Action' }, { GroupName: 'Deed Purchase' },
                        { GroupName: 'Straight Sale' }, { GroupName: 'Jay Current Offer' }
                        ]
                },

                {
                    GroupName: 'Sold',
                    SubGroups: [{ GroupName: 'Purchased' }, { GroupName: 'Partnered' },
                        { GroupName: 'Sold (Final Sale)/Recyclable' }]
                },
                { GroupName: 'In House' }, { GroupName: 'Agent Corps' }]
            $scope.ChangeGroups = function (name) {
                $scope.selectType = name;
            }
            $scope.GetTitle = function()
            {
                return ($scope.SelectedTeam ? ($scope.SelectedTeam == '' ? 'All Team\'s ' : $scope.SelectedTeam + '\'s ') : '') + $scope.selectType;
            }
            $scope.ExportExcel = function()
            {
                JSONToCSVConvertor($scope.filteredCorps, true, $scope.GetTitle());
                
            }
            $http.get('/Services/ContactService.svc/GetAllBuyerEntities').success(function (data, status, headers, config) {
                $scope.CorpEntites = data;
                $scope.currentContact = $scope.CorpEntites[0];
            }).error(function (data, status, headers, config) {
                alert('Get All buyers Entities error : ' + JSON.stringify(data))
            });

            $http.get('/Services/TeamService.svc/GetAllTeam').success(function (data, status, headers, config) {
                $scope.AllTeam = data;

            }).error(function (data, status, headers, config) {
                alert('Get All Team name  error : ' + JSON.stringify(data))
            });

            $scope.GroupCount = function (g) {
                if (!$scope.CorpEntites) {
                    return 0;
                }
                if (g.GroupName == 'All Entities') {
                    if ($scope.SelectedTeam)
                    {
                        return $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() }).length;
                    }
                    return $scope.CorpEntites.length;
                }
                var count = 0
                if (g.SubGroups) {
                    for (var i = 0; i < g.SubGroups.length; i++) {
                        count += $scope.GroupCount(g.SubGroups[i]);
                    }
                    return count
                }
                var corps = $scope.CorpEntites.filter(function (o) { return (o.Status && o.Status.toLowerCase().trim() == g.GroupName.toLowerCase().trim()) });
                if ($scope.SelectedTeam)
                {
                    corps = corps.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == $scope.SelectedTeam.toLowerCase().trim() });
                }
                return corps.length;
            }
            
            $scope.TeamCount =function(teamName)
            {
                if (!$scope.CorpEntites)
                {
                    return 0;
                }
                var crops=[];
                crops = teamName ? $scope.CorpEntites.filter(function (o) { return o.Office && o.Office.toLowerCase().trim() == teamName.toLowerCase().trim() }) : $scope.CorpEntites;
                

                if ($scope.selectType&&$scope.selectType != $scope.Groups[0].GroupName)
               {
                    crops= crops.filter(function (o) { return o.Status && o.Status.toLowerCase().trim() == $scope.selectType.toLowerCase().trim() })
               }

               return crops.length;
            }

            $scope.EntitiesFilter = function (entity) {
                if ($scope.selectType == 'All Entities' || (entity.Status && $scope.selectType.toLowerCase().trim() == entity.Status.toLowerCase().trim()))
                    return true;
                var subs = $scope.Groups.filter(function (o) { return o.GroupName == $scope.selectType })[0];
                if (subs && subs.SubGroups) {
                    for (var i = 0; i < subs.SubGroups.length; i++) {
                        var sg = subs.SubGroups[i];
                        if (entity.Status && sg.GroupName.toLowerCase().trim() == entity.Status.toLowerCase().trim()) {
                            return true;
                        }
                    }
                }

                return false;
            }
            $scope.selectCurrent = function (contact) {
                $scope.currentContact = contact
            }
            $scope.SaveCurrent = function () {
                $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.currentContact) }).success(function (data, status, headers, config) {
                    alert("Save succeed!")
                }).error(function (data, status, headers, config) {
                    alert("Get error save corp entitiy : " + JSON.stringify(data))
                });
            }
            $scope.AllGroups = function () {
                var HasSub = $scope.Groups.filter(function (o) { return o.SubGroups != null });
                var groups = [];
                for (var i = 0; i < HasSub.length; i++) {
                    groups = groups.concat(HasSub[i].SubGroups);
                }
                var HasNotSub = $scope.Groups.filter(function (o) { return o.SubGroups == null && o.GroupName != 'All Entities' });
                groups = groups.concat(HasNotSub);
                return groups;
            }
            $scope.addContactFunc = function () {
                $http.post('/Services/ContactService.svc/SaveCorpEntitiy', { c: JSON.stringify($scope.addContact) }).success(function (data, status, headers, config) {
                    if (!data) {
                        alert("Already have a entitity named " + $scope.addContact.CorpName + "! please pick other name");
                        return;
                    }
                    $scope.currentContact = data;
                    $scope.CorpEntites.push($scope.addContact);
                    alert("Add entity succeed !")
                }).error(function (data, status, headers, config) {
                    alert('Add buyer Entities error : ' + JSON.stringify(data))
                });
            }
            $scope.ChangeTeam = function(team)
            {
                $scope.SelectedTeam = team;
            }
            //for view and upload document -- add by chris
            $scope.encodeURIComponent = window.encodeURIComponent;

            $scope.UploadFile = function (fileUploadId, type, field) {
                $scope.loadPanelVisible = true;

                var contact = $scope.currentContact;
                var entityId = contact.EntityId;

                // grab file object from a file input
                var fileData = document.getElementById(fileUploadId).files[0];

                //$http.post('/services/ContactService.svc/UploadFile?id=' + entityId + '&type=' + type, fileData).success(function (data, status, headers, config) {
                //    $scope.currentContact.EINFile = data;
                //    //$scope = data;
                //    alert('successful..');                   
                //}).error(function (data, status, headers, config) {
                //    alert('error : ' + JSON.stringify(data))
                //});


                $.ajax({
                    url: '/services/ContactService.svc/UploadFile?id=' + entityId + '&type=' + type,
                    type: 'POST',
                    data: fileData,
                    cache: false,
                    dataType: 'json',
                    processData: false, // Don't process the files
                    contentType: "application/octet-stream", // Set content type to false as jQuery will tell the server its a query string request
                    success: function (data) {
                        alert('successful..');
                        $scope.currentContact[field] = data;
                        $scope.loadPanelVisible = false;
                        $scope.$apply();
                    },
                    error: function (data) {
                        alert('Some error Occurred!');
                        $scope.loadPanelVisible = false;
                        $scope.$apply();
                    }
                });
            }

            //end - view and upload document
        });

    </script>


</asp:Content>
