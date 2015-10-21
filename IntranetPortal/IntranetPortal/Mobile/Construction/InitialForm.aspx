<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="InitialForm.aspx.vb" Inherits="IntranetPortal.InitialForm" MasterPageFile="~/Mobile.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="mobile_header">
    <link href="/Scripts/literallycanvas/css/literallycanvas.css" rel="stylesheet">
    <script src="//cdnjs.cloudflare.com/ajax/libs/react/0.13.3/react-with-addons.js"></script>
    <script src="/Scripts/literallycanvas/js/literallycanvas.js"></script>
</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="mobile_content">

    <div class="item item-divider">
        <h2 class="text-center">Initial Form</h2>
    </div>
    <div id="initialFormCtrl" ng-controller="InitialFormController">
        <div class="card">
            <div class="list">
                <label class="item item-input item-select">
                    <span class="input-label">Property Address</span>
                    <select ng-options="a[0] as a[1] for a in addressList" ng-model="data.BBLE" ng-change="load()"></select>
                </label>

                <label class="item item-input">
                    <span class="input-label">Date</span>
                    <input type="text" ng-model="data.Form.date" />
                </label>

                <span class="item item-toggle">Clean Up
                    <label class="toggle toggle-assertive">
                        <input type="checkbox" ng-model="data.Form.isCleanUp" />
                        <div class="track">
                            <div class="handle"></div>
                        </div>
                    </label>
                </span>
                <label class="item item-input">
                    <span class="input-label">Tax class</span>
                    <input type="text" ng-model="data.Form.TaxClass" />
                </label>
                <label class="item item-input">
                    <span class="input-label">Asset Manager</span>
                    <input type="text" ng-model="data.Form.AssetManager" />
                </label>
                <label class="item item-input">
                    <span class="input-label">No. Of Family</span>
                    <input type="text" ng-model="data.From.NumOfFamily" />
                </label>
                <label class="item item-input">
                    <span class="input-label">Resale Value</span>
                    <input type="text" ng-model="data.Form.ResaleValue" />
                </label>

            </div>
        </div>

        <div class="card">
            <div class="item item-divider">
                Property Layout/Description
            </div>

            <label class="item item-input item-select">
                <span class="input-label">Floor</span>
                <select ng-model="data.currentFloor" ng-options="floor for floor in ['Cellar','Basement' ,'1st', '2nd', '3rd']"></select>
            </label>

            <div class="list" ng-repeat="floor in ['Cellar','Basement' ,'1st', '2nd', '3rd']" ng-show="data.currentFloor==floor">
                <div class="item item-input">
                    <span class="input-label">Number Of Floors</span>
                    <input type="text" ng-model="data.Form.Layout[floor + '_NumOfRoom']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Number Of Bathrooms</span>
                    <input type="text" ng-model="data.Form.Layout[floor + '_NumOfBathroom']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Number Of Bedrooms</span>
                    <input type="text" ng-model="data.Form.Layout[floor + '_NumOfBed']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Condition/Description</span>
                    <input type="text" ng-model="data.Form.Layout[floor + '_Desc']" />
                </div>
            </div>
        </div>

        <div class="card">
            <div class="list">
                <div class="item item-input item-stacked-label">
                    <span class="input-label">Exterior</span>
                    <textarea rows="5" ng-model="data.Form.Exterior"></textarea>
                </div>
                <div class="item item-input item-stacked-label">
                    <span class="input-label">Backyard</span>
                    <textarea rows="5" ng-model="data.Form.Backyard"></textarea>
                </div>
            </div>
        </div>

        <div class="card">
            <label class="item item-input item-select">
                <span class="input-label">Utility</span>
                <select ng-model="data.currentUtility" ng-options="u for u in ['GAS','Electric' ,'Water']"></select>
            </label>
            <div class="list" ng-repeat="u in ['GAS', 'Electric', 'Water']" ng-show="data.currentUtility==u">
                <span class="item item-toggle">Service On/Off
                    <label class="toggle toggle-assertive">
                        <input type="checkbox" ng-model="data.Form.Utility[u + '_isService']" />
                        <div class="track">
                            <div class="handle"></div>
                        </div>
                    </label>
                </span>

                <div class="item item-input">
                    <span class="input-label"># of Meters</span>
                    <input type="text" ng-model="data.Form.Utility[u + '_NumOfMeters']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Missing Meters</span>
                    <input type="text" ng-model="data.Form.Utility[u + '_MissingMeters']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Location</span>
                    <input type="text" ng-model="data.Form.Utility[u + '_Location']" />
                </div>

                <div class="item item-input">
                    <span class="input-label">Meter Number/Readings</span>
                    <input type="text" ng-model="data.Form.Utility[u + '_MeterReading']" />
                </div>
            </div>
        </div>

        <div class="card">
            <div class="item item-input item-stacked-label">
                <label class="input-label">Comments</label>
                <textarea rows="5" ng-model="data.Form.Comments"></textarea>
            </div>
        </div>

        <div class="card">
            <label class="item item-input item-select">
                <span class="input-label">Sketch</span>
                <select ng-options="x for x in [1,2,3,4,5,6]" ng-model="data.currentSketch" ng-change="updateSketch()"></select>
            </label>

            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[0].floorName" />
                </label>
                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(0)">clear</button>
            </div>
            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[1].floorName" />
                </label>
                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(1)">clear</button>
            </div>
            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[2].floorName" />
                </label>
                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(2)">clear</button>

            </div>
            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[3].floorName" />
                </label>

                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(3)">clear</button>

            </div>
            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[4].floorName" />
                </label>

                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(4)">clear</button>

            </div>
            <div class="sketchDiv">
                <label class="item item-input">
                    <span class="input-label">Floors</span>
                    <input type="text" ng-model="data.From.Sketch[5].floorName" />
                </label>

                <div class="LiterallyCanvas"></div>
                <button class="button button-calm button-full button-small" ng-click="canvasClear(5)">clear</button>
            </div>

        </div>

        <div class="row">
            <div class="col"></div>
            <div class="col"></div>
            <button class="button button-balanced col" ng-click="save()">Save</button>
        </div>
    </div>
    <script>
        angular.module("PortalMapp")
            .controller("InitialFormController", function ($scope, $http) {
                $scope.data = {
                    Form: {
                        Layout: {},
                        Utility: {},
                        Sketch: [
                            { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }
                        ]
                    }
                }
                $scope.canvasEls = [];

                $scope.init = function () {
                    var url = "/api/ConstructionCases/GetInitialForm";
                    $http.get(url)
                    .then(function success(res) {
                        if (res.data) {
                            $scope.addressList = res.data;
                        }
                    }, function error() {
                        alert("fail to load address")
                    })
                    $scope.canvasInit();
                    $scope.updateSketch();
                }


                $scope.load = function () {
                    var url = "/api/ConstructionCases/GetInitialForm?bble=" + $scope.data.BBLE;
                    $http.get(url)
                    .then(function success(res) {
                        if (res.data) {
                            $scope.data = res.data;
                            $scope.data.Form.Address = $scope.getAddressLocal($scope.data.BBLE);
                            if (!$scope.data.Form.Sketch) {
                                $scope.data.Form.Sketch = [{ floorName: "" },
                                                            { floorName: "" },
                                                            { floorName: "" },
                                                            { floorName: "" },
                                                            { floorName: "" },
                                                            { floorName: "" }];
                            }
                            $scope.canvasRedraw();
                            $scope.updateSketch();
                        }
                    }, function error(res) {
                        alert("fail to get form");
                    })
                }

                $scope.save = function () {
                    $scope.canvasSave();
                    var url = "/api/ConstructionCases/InitialForm";
                    $http({
                        method: 'POST',
                        url: url,
                        data: JSON.stringify($scope.data)
                    }).then(function () {
                        alert("Save Successful");
                    }, function error() {
                        alert("Fails to Save.")
                    })
                }

                $scope.print = function () {
                    window.print()
                }

                $scope.getAddressLocal = function (bble) {
                    var result = ""
                    _.each($scope.addressList, function (el) {
                        if (el[0] == bble) {
                            result = el[1]
                        }
                    })
                    return result;
                }

                $scope.canvasInit = function () {
                    _.each($(".LiterallyCanvas"), function (el, idx) {
                        var lc = LC.init(el, {
                            keyboardShortcuts: false,
                            imageSize: { width: 470, height: 320 },
                            toolbarPosition: 'hidden',
                            backgroundColor: '#fff',
                            defaultStrokeWidth: 2,
                            imageURLPrefix: "/Scripts/literallycanvas/img/",
                        });
                        $scope.canvasEls.push(lc);
                    })
                }

                $scope.canvasRedraw = function () {
                    _.each($scope.canvasEls, function (el, idx) {
                        el.clear()
                        if ($scope.data.Form.Sketch && $scope.data.Form.Sketch[idx].snapshot) {
                            el.loadSnapshot($scope.data.Form.Sketch[idx].snapshot);
                        }
                    })
                }

                $scope.canvasSave = function () {
                    _.each($scope.canvasEls, function (el, idx) {
                        var snapshot = el.getSnapshot();
                        $scope.data.Form.Sketch[idx].snapshot = snapshot;
                    });
                }

                $scope.canvasClear = function (index) {
                    $scope.canvasEls[index].clear();
                }


                $scope.updateSketch = function () {
                    _.each($(".sketchDiv"), function (el, idx) {
                        $(el).hide();
                        if (idx == $scope.data.currentSketch - 1) {
                            $(el).show();
                        }
                    })
                }

                $scope.init();
            });

    </script>
</asp:Content>
