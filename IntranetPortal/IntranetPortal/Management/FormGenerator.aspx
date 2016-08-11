<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FormGenerator.aspx.vb" Inherits="IntranetPortal.FormGenerator" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
      <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js"></script>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="FormCtrl" ng-controller="FormCtrl">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6">
                    <div id="template">

                        <div class="ss_form " ng-repeat="form in FormItems">

                            <h4 class="ss_form_title">{{form.head}}
                                <tp-pt-collapse model="{{GenerateModel(form.head)}}" />
                            </h4>
                            <div class="ss_border" tp-collapse="{{GenerateModel(form.head)}}">

                                <%-- has sub items --%>
                                <div class="ss_form " ng-repeat="item in form.items|filter:{head:'!!'}">

                                    <h5 class="ss_form_title ">{{item.head}}
                                        <tp-pt-collapse model="{{GenerateModel(item.label,form.head)}}"> </tp-pt-collapse>
                                    </h5>
                                    <div class="ss_border" tp-collapse="{{GenerateModel(item.label,form.head)}}">
                                        <ul class="ss_form_box clearfix">
                                            <li class="ss_form_item" tp-show="{{sitem.type == 'radio' ? true: GenerateModel(item.ngShow,item.label)}}" ng-repeat="sitem in item.items" ng-class="NeedChangeElement(sitem.type,'notes')?'ss_form_item_line':''" >
                                                <label class="ss_form_input_title">{{sitem.label}}</label>
                                                <%-- only enable the tp-ng-show when need have ng-show in the radio otherwise disable it --%>
                                                <input class="ss_form_input" tempt-type="{{GetType(sitem.type)}}{{'Quotation'}}" tempt-ng-model="{{GenerateModel(sitem.label,item.label)}}"  ng-if="((!sitem.type)||(!NeedChangeElement(sitem.type))&&!sitem.head)" >
                                                <select class="ss_form_input" tempt-ng-model="{{GenerateModel(sitem.label,item.label)}}" ng-if="NeedChangeElement(sitem.type,'select')">
                                                    <option></option>
                                                    <option ng-repeat="option in sitem.options">{{option}} </option>
                                                </select>
                                                <tempt-pt-file file-bble="{{BBLEModel}}" file-id="{{GetUniqueId(form.head,sitem.label)}}" file-model="{{GenerateModel(sitem.label,item.label)}}" ng-if="NeedChangeElement(sitem.type,'file')"></tempt-pt-file>
                                                <textarea class="edit_text_area text_area_ss_form" model="{{GenerateModel(sitem.label,item.label)}}" ng-if="NeedChangeElement(sitem.type,'notes')"></textarea>
                                                <input type="text" class="ss_form_input" tempt-ng-model="{{GenerateModel(sitem.label,item.label)}}" tempt-ng-change="{{GenerateModel(sitem.label,item.label)}}Id=null" tempt-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" tempt-typeahead-on-select="{{GenerateModel(sitem.label,item.label)}}Id=$sitem.ContactId" tempt-bind-id="{{GenerateModel(sitem.label,item.label)}}Id" ng-if="NeedChangeElement(sitem.type,'contact')">
                                                <tempt-pt-radio name="{{GetUniqueId(form.head,sitem.label)}}" tempt-model="{{GenerateModel(sitem.label,item.label)}}" ng-if="NeedChangeElement(sitem.type,'radio')"></tempt-pt-radio>

                                            </li>

                                        </ul>
                                    </div>

                                </div>

                                <%-- do not has sub items --%>
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item" ng-repeat="item in form.items|filter:filter:{head:'!'}" ng-class="NeedChangeElement(item.type,'notes')?'ss_form_item_line':''">
                                        <label class="ss_form_input_title">{{item.label}}</label>
                                        <input class="ss_form_input" tempt-type="{{GetType(item.type)}}{{'Quotation'}}" tempt-ng-model="{{GenerateModel(item.label)}}" ng-if="(!item.type)||(!NeedChangeElement(item.type))">
                                        <select class="ss_form_input" tempt-ng-model="{{GenerateModel(item.label)}}" ng-if="NeedChangeElement(item.type,'select')">
                                            <option></option>
                                            <option ng-repeat="option in item.options">{{option}} </option>
                                        </select>
                                        <tempt-pt-file file-bble="{{BBLEModel}}" file-id="{{GetUniqueId(form.head,item.label)}}" file-model="{{GenerateModel(item.label)}}" ng-if="NeedChangeElement(item.type,'file')"></tempt-pt-file>
                                        <textarea class="edit_text_area text_area_ss_form" model="{{GenerateModel(item.label)}}" ng-if="NeedChangeElement(item.type,'notes')"></textarea>
                                        <input type="text" class="ss_form_input" tempt-ng-model="{{GenerateModel(item.label)}}" tempt-ng-change="{{GenerateModel(item.label)}}Id=null" tempt-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" tempt-typeahead-on-select="{{GenerateModel(item.label)}}Id=$item.ContactId" tempt-bind-id="{{GenerateModel(item.label)}}Id" ng-if="NeedChangeElement(item.type,'contact')">
                                        <tempt-pt-radio name="{{GetUniqueId(form.head,item.label)}}" tempt-model="{{GenerateModel(item.label)}}" ng-if="NeedChangeElement(item.type,'radio')"></tempt-pt-radio>

                                    </li>
                                </ul>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <p>
                    BBLE model:
                    <input type="text" class="form-control" ng-model="BBLEModel" />
                </p>
                <p>
                    Page model:
                    <input type="text" class="form-control" ng-model="pageModel" />
                </p>
                <button type="button" ng-click="GetReslut()">GetReslut</button><br />
                <textarea ng-model="Resluts"></textarea>
            </div>

        </div>
    </div>



    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('FormCtrl', function ($scope, $http, $element, $timeout, ptContactServices, ptCom) {
            $scope.qniueId = 0;
            $scope.ptContactServices = ptContactServices;
            $scope.RecordDocuments = {};
            $scope.pageModel = 'DocSearch.LeadResearch';
            $scope.FormItems = [
               {
                   head: 'Ownership Mortgage Info',
                   items: [
                       {
                           label: 'Purchase Deed', head: 'Purchase Deed', ngShow: 'Has Deed',
                           items: [
                               { label: 'Has Deed', type: 'radio' },
                               { label: 'Date of Deed', type: 'date' },
                               { label: 'Party 1' },
                               { label: 'Party 2' },
                           ]
                       },
                       //{ label: 'Has Deed', type: 'radio' },
                       //{ label: 'Date of Deed', type: 'date' },

                       {
                           label: 'c 1st Mortgage',
                           head: 'c 1st Mortgage', ngShow: 'Has c 1st Mortgage',
                           items: [
                               {
                                   label: 'Has c 1st Mortgage', type: 'radio'
                               },
                               {
                                   label: 'Amount',
                               }
                           ]
                       },
                       {
                           label: 'c 2nd Mortgage',
                           head: 'c 2nd Mortgage', ngShow: 'Has c 2nd Mortgage',
                           items: [
                               {
                                   label: 'Has c 2nd Mortgage', type: 'radio'
                               },
                               {
                                   label: 'Amount',
                               }
                           ]
                       },
                       //{ label: 'Has c 1st Mortgage', type: 'radio' },
                       //{ label: 'c 1st Mortgage Amount', type: 'money' },
                       //{ label: 'Has c 2nd Mortgage Amount', type: 'radio' },

                       //{ label: 'c 2nd Mortgage Amount', type: 'money' },
                       {
                           label: 'Last Assignment',
                           head: 'Last Assignment', ngShow: 'has Last Assignment',
                           items: [
                               { label: 'has Last Assignment', type: 'radio' },
                               { label: 'Assignment date', type: 'date' },
                               { label: 'Assigned To' },

                           ]
                       },
                       {
                           label: 'LP Index __Num',
                           head: 'LP Index __Num',
                           items: [
                               { label: 'LP Index __Num', },
                               { label: 'notes', type: 'notes' },
                           ]
                       },
                       //{ label: 'has Last Assignment', type: 'radio' },
                       //{ label: 'Last Assignment date', type: 'date' },
                       //{ label: 'Last Assignment Assigned To' },
                       //{ label: 'LP Index number' },
                       //{ label: 'LP Index notes', type: 'notes' },
                       { label: 'Servicer' },
                       { label: 'Servicer notes', type: 'notes' },
                       { label: 'Fannie', type: 'radio' },
                       { label: 'Freddie Mac ', type: 'radio' },
                       { label: 'FHA ', type: 'radio' },
                       //Last Assignment
                   ]
               },
               {
                   head: 'Property Dues Violations',
                   items: [
                       {
                           label: 'Property Taxes Due',
                           head: 'Property Taxes', ngShow: 'Has Due',
                           items: [
                               { label: 'Property Taxes per YR' },
                               { label: 'Has Due', type: 'radio' },
                               { label: 'Due', type: 'money' },
                           ]
                       },

                       {
                           label: 'Water Charges Due',
                           head: 'Water Charges Due', ngShow: 'Has Water Due',
                           items: [
                                { label: 'Has Water Due', type: 'radio' },
                                { label: 'Due', type: 'money' },
                           ]
                       },

                       {
                           label: 'ECB Violoations',
                           head: 'ECB Violoations', ngShow: 'Has Open',
                           items: [
                                { label: 'Has Open', type: 'radio' },
                                { label: 'Count' },
                                { label: 'Amount', type: 'money' },
                           ]
                       },
                       {
                           label: 'DOB Violoations',
                           head: 'DOB Violoations', ngShow: 'Has DOB Open',
                           items: [
                                { label: 'Has DOB Open', type: 'radio' },
                                { label: 'Count' },
                                { label: 'Amount', type: 'money' },
                           ]
                       },



                       { label: 'Tax Classification' },

                       {
                           label: 'C O', head: 'C O', ngShow: 'Has CO',
                           items: [
                               { label: 'Has CO' ,type:'radio' },
                               { label: ' __Num of Units' },
                           ]
                       },


                       { label: 'HPD Number of Units' },

                       {
                           label: 'HPD Violations',
                           head: 'HPD Violations',
                           ngShow: 'Has Violations',
                           items: [
                               {
                                   label: 'Has Violations',
                                   type: 'radio'
                               },
                           { label: 'A Class' },
                           { label: 'B Class' },
                           { label: 'C Class' },
                           { label: 'I Class' },
                           ]
                       },

                       {
                           label: 'HPD Charges Not Paid Transferred',
                           head: 'HPD Charges Not Paid Transferred',
                           ngShow: 'Is Open',
                           items: [
                               { label: 'Is Open', type: 'radio' },
                               { label: 'Open Amount', type: 'money' },
                           ]
                       },

                   ]
               },
               {
                   head: 'Judgements Liens',
                   items: [
                        {
                            label: 'Personal Judgments',
                            head: 'Personal Judgments',
                            ngShow: 'has Judgments',
                            items: [
                                {
                                    label: 'has Judgments', type: 'radio'
                                },
                                 {
                                     label: 'Count', 
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'HPD Judgments',
                            head: 'HPD Judgments',
                            ngShow: 'has HPD Judgments',
                            items: [
                                {
                                    label: 'has HPD Judgments', type: 'radio'
                                },
                                 {
                                     label: 'Count',
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'IRS Tax Lien',
                            head: 'IRS Tax Lien',
                            ngShow: 'has IRS Tax Lien',
                            items: [
                                {
                                    label: 'has IRS Tax Lien', type: 'radio'
                                },
                                 {
                                     label: 'Count', 
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'NYS Tax Lien',
                            head: 'NYS Tax Lien',
                            ngShow: 'has NYS Tax Lien',
                            items: [
                                {
                                    label: 'has NYS Tax Lien', type: 'radio'
                                },
                                 {
                                     label: 'Count',
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'Sidewalk Liens',
                            head: 'Sidewalk Liens',
                            ngShow: 'has Sidewalk Liens',
                            items: [
                                {
                                    label: 'has Sidewalk Liens', type: 'radio'
                                },
                                 {
                                     label: 'Count', 
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'Vacate Order',
                            head: 'Vacate Order',
                            ngShow: 'has Vacate Order',
                            items: [
                                {
                                    label: 'has Vacate Order', type: 'radio'
                                },
                                 {
                                     label: 'Count', 
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'ECB Tickets',
                            head: 'ECB Tickets',
                            ngShow: 'has ECB Tickets',
                            items: [
                                {
                                    label: 'has ECB Tickets', type: 'radio'
                                },
                                 {
                                     label: 'Count', 
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },
                        {
                            label: 'ECB on Name other known address',
                            head: 'ECB on Name other known address',
                            ngShow: 'has ECB on Name',
                            items: [
                                {
                                    label: 'has ECB on Name', type: 'radio'
                                },
                                 {
                                     label: 'Count',
                                 },
                                  {
                                      label: 'Amount',
                                  },
                            ]
                        },

                   ]
               },

            ];
            $scope.GenerateModel = function () {
                var model = $scope.pageModel + '.' + Array.prototype.slice.call(arguments).filter(function (o) { return o }).join("_").replace(/[-\/\\\.\s]/gi, "_")
                return model
            }
            $scope.GetType = function (type) {
                var types = [{ type: 'date', model: 'ss-date' }, { type: 'money', model: 'money-mask' }, { type: 'phone', model: 'mask="(999) 999-9999"' }]
                var mType = types.filter(function (o) { return o.type == type })[0];
                return mType ? mType.model : '';
            }

            $scope.GetUniqueId = function () {
                var id = Array.prototype.slice.call(arguments).filter(function (o) { return o }).join("_").replace(/ /gi, "")
                id += $scope.qniueId;
                return id;
            }
            $scope.NeedChangeElement = function (type, ElemType) {
                var NeedChangeS = ["select", "contact", 'file', 'notes', 'radio'];
                var iType = NeedChangeS.filter(function (o) { return o == type })[0];
                return ElemType ? iType == ElemType : iType
            }

           
            $scope.GetReslut = function () {
                var t = $('#template').clone();
                t.not(':visible').remove();
                t.wrap("<div></div>");
                var html = t.html();
                html = html.replace(/-->/g, '-->\n');
                html = html.replace(/<!--*.*-->/g, '');
                html = html.replace(/ng-scope/g, '')
                html = html.replace(/ng-if=.*\"/g, '')
                html = html.replace(/ng-repeat.*\"/g, '')
                html = html.replace(/ng-binding/g, '')

                html = html.replace(/tempt-type=\"/g, '')
                html = html.replace(/Quotation\"/g, '')

                html = html.replace(/tt-file/g, 'pt-file')
                html = html.replace(/file-ng-model/g, 'file-model');
                html = html.replace(/tp-pt-collapse/g, 'pt-collapse');
                html = html.replace(/tp-collapse/g, 'collapse');
                html = html.replace(/\n/g, '');
                html = html.replace(/ __Num/g, ' #');
                html = html.replace(/c 1st/g, '1st');
                html = html.replace(/c 2nd/g, '2nd');
                html = html.replace(/tempt-/g, '');
                html = html.replace(/tp-show/g, 'ng-show');
                
                $scope.Resluts = html;
            }
        });

    </script>



</asp:Content>
