<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FormGenerator.aspx.vb" Inherits="IntranetPortal.FormGenerator" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="FormCtrl" ng-controller="FormCtrl">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-6">
                    <div id="template">

                        <div class="ss_form " ng-repeat="form in FormItems">

                            <h4 class="ss_form_title">{{form.head}} <tp-pt-collapse model="{{GenerateModel(form.head)}}" /> </h4>
                            <div class="ss_border" tp-collapse="{{GenerateModel(form.head)}}">
                                <ul class="ss_form_box clearfix">
                                    <li class="ss_form_item" ng-repeat="item in form.items" ng-class="NeedChangeElement(item.type,'notes')?'ss_form_item_line':''">
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
            $scope.qniueId = 0
            $scope.ptContactServices = ptContactServices;
            $scope.RecordDocuments = {}
            $scope.FormItems = [
               {
                   head: 'Ownership Mortgage Info',
                   items: [
                       { label: 'Purchase Deed' },
                       {label: 'Has Deed', type: 'radio'},
                       { label: 'Date of Deed', type:'date' },
                       { label: 'Party 1' },
                       { label: 'Party 2' },
                       { label: 'c 1st Mortgage' },
                       { label: 'Has c 1st Mortgage', type: 'radio' },
                       { label: 'c 1st Mortgage Amount', type: 'money' },
                       { label: 'Has c 2nd Mortgage Amount', type: 'radio' },

                       { label: 'c 2nd Mortgage Amount', type: 'money' },

                       { label: 'Check is in Office', type: 'radio' },
                       { label: 'Name On Check', },
                       { label: 'Need do search', type: 'radio' },
                       { label: 'has Last Assignment', type: 'radio' },
                       { label: 'Last Assignment date', type: 'date' },
                       { label: 'Last Assignment Assigned To' },
                       { label: 'LP Index number' },
                       { label: 'LP Index notes', type: 'notes' },
                       { label: 'Servicer' },
                       { label: 'Servicer notes', type: 'notes' },
                       { label: 'Fannie', type: 'radio' },
                       { label: 'Freddie Mac ', type: 'radio' },
                       //Last Assignment
                   ]
               },
               {
                   head: 'Property Dues Violations',
                   items: [
                       { label: 'Property Taxes per YR' },
                       { label: 'Has Property Taxes Due', type: 'radio' },
                       { label: 'Property Taxes Due', type: 'money' },

                       { label: 'Has Water Charges Due', type: 'radio' },
                       { label: 'Water Charges Due', type: 'money' },

                       { label: 'ECB Violoations Open', type: 'radio' },
                       { label: 'ECB Violoations Count' },
                       { label: 'ECB Violoations Amount', type: 'money' },
                       { label: 'DOB Violoations Open', type: 'radio' },
                       { label: 'DOB Violoations Count' },
                       { label: 'DOB Violoations Amount', type: 'money' },

                       { label: 'Tax Classification' },

                       { label: 'C O', type: 'radio' },
                       { label: 'number of Units' },

                       { label: 'HPD Number of Units' },
                       { label: 'HPD Violations' },
                       { label: 'Has HPD Violations', type: 'radio' },
                       { label: 'HPD Violations A Class' },
                       { label: 'HPD Violations B Class' },
                       { label: 'HPD Violations C Class' },
                       { label: 'HPD Violations I Class' },

                       { label: 'HPD Charges Not Paid Transferred', type: 'radio' },
                       { label: 'HPD Charges Amount', type: 'Amount:' },
                   ]
               },
               //{
               //    head: 'Property Dues Violations',
               //    items: [
               //        { label: 'Property Taxes per YR' },
               //        { label: 'Has Property Taxes Due', type: 'radio' },
               //        { label: 'Property Taxes Due', type: 'money' },

               //        { label: 'Has Water Charges Due', type: 'radio' },
               //        { label: 'Water Charges Due', type: 'money' },

               //        { label: 'ECB Violoations Open', type: 'radio' },
               //        { label: 'ECB Violoations Count' },
               //        { label: 'ECB Violoations Amount', type: 'money' },
               //        { label: 'DOB Violoations Open', type: 'radio' },
               //        { label: 'DOB Violoations Count' },
               //        { label: 'DOB Violoations Amount', type: 'money' },

               //        { label: 'Tax Classification' },

               //        { label: 'C O', type: 'radio' },
               //        { label: 'number of Units' },

               //        { label: 'HPD Number of Units' },
               //        { label: 'HPD Violations' },
               //        { label: 'Has HPD Violations', type: 'radio' },
               //        { label: 'HPD Violations A Class' },
               //        { label: 'HPD Violations B Class' },
               //        { label: 'HPD Violations C Class' },
               //        { label: 'HPD Violations I Class' },

               //        { label: 'HPD Charges Not Paid Transferred', type: 'radio' },
               //        { label: 'HPD Charges Amount', type: 'Amount:' },
               //    ]
               //},
              
            ];
            $scope.GenerateModel = function () {
                var model = $scope.pageModel + '.' + arguments[0].replace(/[-\/\\\.\s]/gi, "_")
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
                html = html.replace(/tempt-/g, '');

                $scope.Resluts = html;
            }
        });

    </script>



</asp:Content>
