<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleDocTab.ascx.vb" Inherits="IntranetPortal.TitleDocTab" %>
<div ng-controller="TitleDocCtrl">
    <div id="get_form_div" class="ss_form">
        <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item2">
                    <label class="ss_form_input_title ">ENTITY</label>
                    <input class="ss_form_input" ng-model="data.entity" />
                </li>
                <li class="ss_form_item2">
                    <label class="ss_form_input_title ">D/B/A</label>
                    <input class="ss_form_input" ng-model="data.dba" />
                </li>
                <li class="ss_form_item2">
                    <label class="ss_form_input_title">TRANSFEROR</label>
                    <select class="ss_form_input" ng-model="data.transferor" ng-options="t.name as t.name for t in transferors"></select>
                </li>
                <li class="ss_form_item2">
                    <label class="ss_form_input_title ">TRANSFEREE</label>
                    <input class="ss_form_input" ng-model="data.transferee" />
                </li>
                <li class="ss_form_item2">
                    <label class="ss_form_input_title ">DATE</label>
                    <input class="ss_form_input" ng-model="data.signdate" ss-date />
                </li>
            </ul>

            <div>
                <button type="button" class="btn btn-primary" ng-click="generatePackage()" id="generatePackageBtn">Generate Doc</button>
                <a style="cursor: pointer" id="generatedDocsLink" ng-href="/TempDataFile/title_doc_package.zip" target="_blank" hidden>Download</a>
                <span class="text-danger" id="generatedDocWarning" hidden>fail to generate files</span>
            </div>

        </div>
    </div>

    <div id="signed_doc_div" class="ss_form">
        <h4 class="ss_form_title ">Signed Documents</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item3">
                    <label class="ss_form_input_title">BILL OF SALE</label>
                    <pt-file file-bble="BBLE" upload-type="title" file-id="willOfSale" file-model="data.willOfSale"></pt-file>
                </li>
                <li class="ss_form_item3">
                    <label class="ss_form_input_title">CANCELLING PRIOR MEMBERSHIP AGREEMENT AND RESIGNATION</label>
                    <pt-file file-bble="BBLE" upload-type="title" file-id="cancellingMembership" file-model="data.cancellingMembership"></pt-file>
                </li>
                <li class="ss_form_item3">
                    <label class="ss_form_input_title">HOLD HARMLESS AGREEMENT</label>
                    <pt-file file-bble="BBLE" upload-type="title" file-id="holdHarmless" file-model="data.holdHarmless"></pt-file>
                </li>
                <li class="ss_form_item3">
                    <label class="ss_form_input_title">MANAGING MEMBER TRANSFER AGREEMENT</label>
                    <pt-file file-bble="BBLE" upload-type="title" file-id="managingMember" file-model="data.managingMember"></pt-file>
                </li>
                <li class="ss_form_item3">
                    <label class="ss_form_input_title">SALE AND GENERAL ASSIGNMENT OF SHARES IN</label>
                    <pt-file file-bble="BBLE" upload-type="title" file-id="saleAndGeneral" file-model="data.saleAndGeneral"></pt-file>
                </li>
            </ul>
        </div>
    </div>

    <script>
        angular.module("PortalApp")
        .controller("TitleDocCtrl", function ($scope, $http, ptCom) {
            $scope.transferors = [
                {
                    name: 'Ron Borovinsky'
                }, {
                    name: 'Jay Gottlieb'
                }, {
                    name: 'Princess Simeon'
                }, {
                    name: 'Eliezer Herts'
                }, {
                    name: 'Magda Brillite'
                }, {
                    name: 'Tomer Aronov'
                }, {
                    name: 'Moisey Iskhakov'
                }, {
                    name: 'Albert Gavriyelov'
                }, {
                    name: 'Yvette Guizie'
                }, {
                    name: 'Michael Gendin'
                }

            ]
            $scope.data = $scope.$parent.Form.FormData.docs;
            $scope.ReloadedData = {};

            $scope.generatePackage = function () {
                $("#generatedDocsLink").hide()
                $("#generatedDocWarning").hide()
                ptCom.startLoading();
                
                $http({
                    url: "/api/Title/GeneratePakcage",
                    method: "POST",
                    data: $scope.data
                }).then(function (res) {
                    ptCom.stopLoading();
                    if (res.data.length > 0) {
                        $("#generatedDocsLink").show();
                    } else {
                        $("#generatedDocWarning").show();
                    }
                }, function () {
                    ptCom.stopLoading();
                    $("#generatedDocWarning").show();
                })
            }

            $scope.$on('titledoc-reload', function (e, args) {
                $scope.data = $scope.$parent.Form.FormData.docs;
                $scope.ReloadedData = {};
            })


        })
    </script>
</div>
