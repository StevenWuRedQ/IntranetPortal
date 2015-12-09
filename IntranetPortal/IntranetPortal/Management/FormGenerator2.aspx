<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FormGenerator2.aspx.vb" Inherits="IntranetPortal.FormGenerator2" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head">
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <div id="FormCtrl" ng-controller="FormCtrl">
        <div class="container">
            <div class="col-lg-offset-1 col-lg-10">
                <div id="configuration">
                    <table class="table table-responsive">
                        <tr>
                            <td class="col-sm-6">Page model:</td>
                            <td class="col-sm-6 "><input class="form-control" type="text" ng-model="pageModel" /></td>
                        </tr>
                        <tr>
                            <td class="col-sm-6">
                                <input type="file" id="uploadcsv" />
                            </td>
                            <td class="col-sm-6">                                
                                <button type="button" class="btn btn-default" onclick="formCtrl.uploadFile()">Get Result</button>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <textarea ng-model="Result" style="resize: none; width: 100%; height: 200px"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                <hr />
                <div id="template"></div>
            </div>
        </div>


        <script type="text/ng-template" id="label">
        <label class="ss_form_input_title">{{compilingItem.label}}</label>
        </script>

        <script type="text/ng-template" id="input">
        <input class="ss_form_input" ng-model="{{getModel(compilingItem.label)}}" {{compilingItem.args[0]}} />
        </script>

        <script type="text/ng-template" id="select">
        <select class="ss_form_input" ng-model="{{getModel(compilingItem.label)}}">
            <option></option>
        </select>
        </script>

        <script type="text/ng-template" id="ptFile">
        <pt-file file-id="{{getId(compilingFormTitle, compilingItem.label)}}" file-model="{{getModel(compilingItem.label)}}" file-bble=""  file-type="{{compilingItem.args[0]}}" ></pt-file>
        </script>

        <script type="text/ng-template" id="textarea">
        <textarea class="edit_text_area text_area_ss_form" model="{{getModel(compilingItem.label)}}" style="height:100px"></textarea>
        </script>

        <script type="text/ng-template" id="contact">
        <input type="text" class="ss_form_input" ng-model="{{getModel(compilingItem.label)}}" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" ng-change="" typeahead-on-select="">
        </script>

        <script type="text/ng-template" id="ptRadio">
        <pt-radio name="{{getId(compilingFormTitle, compilingItem.label)}}" model="{{getModel(compilingItem.label)}}"></pt-radio>
        </script>
    </div>

    <script>

        var formCtrl = {
            uploadFile: function () {
                var fileElm = $('#uploadcsv')[0];
                var data = new FormData();
                data.append("file", fileElm.files[0]);
                $.ajax({
                    url: '/api/Management/ConvertCSV',
                    type: 'POST',
                    data: data,
                    cache: false,
                    processData: false,
                    contentType: false,
                    success: function (data1) {
                        var scope = angular.element($("#FormCtrl")[0]).scope();
                        scope.process(data1);
                        fileElm.value = "";
                    },
                    error: function () {
                        alert("convert file error!")
                        fileElm.value = "";
                    }

                })
            }
        }
        var portalApp = angular.module('PortalApp');
        portalApp.controller('FormCtrl', function ($scope, $interpolate, $compile, $templateCache, ptContactServices, ptCom) {
            $scope.ptContactServices = ptContactServices;
            $scope.pageModel = 'default';
            $scope.FormItems = [];

            $scope.getModel = function (model) {
                var result = '';
                result += $scope.pageModel.toLowerCase();
                result += ".";
                result += _.camelCase(model)
                return result;
            }

            $scope.getId = function (title, model) {
                var result = '';
                result += title,
                result += "_",
                result += model
                return _.snakeCase(result);

            }

            $scope.compileElement = function (el) {
                $scope.compilingItem = el;
                var result = '';
                if (el.type != 'textarea') {
                    result += '<li class="ss_form_item ">';
                    result += $interpolate($templateCache.get("label").trim())($scope);
                    var templeate = $templateCache.get($scope.compilingItem.type).trim();
                    result += $interpolate(templeate)($scope);
                    result += '</li>';
                } else {
                    result += '<li class="clear-fix" style="list-style:none"></li>';
                    result += '<li class="ss_form_item_line" style="list-style:none">';
                    result += $interpolate($templateCache.get("label").trim())($scope);
                    var templeate = $templateCache.get($scope.compilingItem.type).trim();
                    result += $interpolate(templeate)($scope);
                    result += '<li class="clear-fix" style="list-style:none"></li>';
                }
                return result;
            }

            $scope.getResult = function () {
                var result = '';

                _.each($scope.FormItems, function (el) {
                    $scope.compilingFormTitle = el.title;

                    result += '<div class="ss_form"><h4 class="ss_form_title ">';
                    result += $scope.compilingFormTitle;
                    result += '</h4><div class="ss_border"><ul class="ss_form_box clearfix">';
                    _.each(el.items, function (el1) {
                        result += $scope.compileElement(el1);
                    })
                    result += '</ul></div></div>';

                })
                $scope.Result = result;
                var compiled = $compile(result)($scope);
                angular.element($("#template")[0]).html(compiled);
            }

            $scope.process = function (data) {
                $scope.FormItems = JSON.parse(data);
                $scope.getResult();
                $scope.$apply();
            }
        });
    </script>

</asp:Content>
