<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="BuyerEntityPopUpContent.aspx.vb" Inherits="IntranetPortal.BuyerEntityPopUpContent" MasterPageFile="~/Content.Master" %>

<%@ Register Src="~/ShortSale/ShortSaleSubMenu.ascx" TagPrefix="uc1" TagName="ShortSaleSubMenu" %>
<%@ Register Src="~/PopupControl/SendMailWithAttach.ascx" TagPrefix="uc1" TagName="SendMailWithAttach" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>

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

    <uc1:Common runat="server" ID="Common" />
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
                <uc1:SendMailWithAttach runat="server" ID="SendMailWithAttach" />
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
                                li.active {
                                    background: none !important;
                                }
                            </style>
                            <ul class="nav nav-tabs" role="tablist">
                                <li role="presentation" class="active"><a href="#StatusTab" aria-controls="home" role="tab" data-toggle="tab">Entity Status</a></li>
                                <li role="presentation"><a href="#OfficeTab" aria-controls="profile" role="tab" data-toggle="tab">Office</a></li>

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
                                    <a href="https://myidealpropertyinc.sharepoint.com/_layouts/15/WopiFrame.aspx?guestaccesstoken=ke3i7wLDOmlMkG281EWWCMtumnI%2bacwzPS4SWC3Gbd0%3d&docid=0ad194ec84c4c41c6a338976b08c26b4d&action=view" target="_blank">Corporation </a>&nbsp;
                                    <a href="https://myidealpropertyinc.sharepoint.com/_layouts/15/guestaccess.aspx?guestaccesstoken=oiGCRiJzAe7L5iy2EZPfhD9ONl04TTV8nod3VaVm1Dg%3d&docid=03571c7a8c6824d9787e6efb0a6696067" target="_blank">EIN </a>
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

                <div dx-popup="{
                        width:'50%',
                        height:'auto',
                        title:'Email',
                        closeOnOutsideClick: true,
                        bindingOptions: {
                            visible:'ShowEmailPopUp'
                        }
                    }">

                    <div data-options="dxTemplate:{ name: 'content' }">
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
                                        <input style="margin-left: 40px;" type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveCurrent()"><br />
                                        <input style="margin-left: 40px; margin-top: 5px" type="button" class="rand-button short_sale_edit" value="Mail" onclick="popupSendEmailAttachClient.Show(); popupSendEmailAttachClient.PerformCallback('Show');">
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <div style="height: 30px">
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
                                    <td class="vendor_info_left">Property Assigned <span class="link_pdf" ng-click="OpenLeadsView()" ng-show="currentContact.BBLE">(view)</span>
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table ">
                                            <input class="form-control" ng-model="currentContact.PropertyAssigned" placeholder="Click to input">
                                        </div>
                                    </td>
                                    <td>
                                        <button class="btn btn-primary" type="button" ng-click="AssginEntity()" style=" margin-left:10px">Assign</button>
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
                                    <td class="vendor_info_left">Received On
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <input class="form-control " ss-date ng-model="currentContact.ReceivedOn">
                                        </div>
                                    </td>
                                </tr>
                                <tr class="vendor_info" ng-if="currentContact && currentContact.AssignOn">
                                    <td class="vendor_info_left">Days Assigned Out
                                    </td>
                                    <td>
                                        <div class="detail_right input_info_table">
                                            <span>
                                                <%-- |date:'m Months d day' --%>                                                 
                                               <%-- {{currentContact.assignDateNow() |date:'MM'}} Months--%>
                                                {{currentContact.assignDateNow()}} 
                                                <%--<input class="form-control " ss-date ng-model="currentContact.AssignOn" placeholder="Click to input">--%>
                                            </span>
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
        function GetAttachments() {

            var currentCorp = angular.element(document.getElementById("BuyerEntityCtrl")).scope().currentContact;
            var files = [currentCorp.EINFile, currentCorp.File2, currentCorp.File3];
            files = files.filter(function (o) { return o })
            return files.join(",")
        }
    </script>


</asp:Content>
