<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialForm.aspx.vb" Inherits="IntranetPortal.ConstructionInitialForm" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server">

    <link href="/bower_components/literallycanvas/css/literallycanvas.css" rel="stylesheet" />
    <script src="//cdnjs.cloudflare.com/ajax/libs/react/0.13.3/react-with-addons.js"></script>
    <script src="/bower_components/literallycanvas/js/literallycanvas.js"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

    <div id="initialForm" ng-controller="InitialFormController">
        <div class="container">
            <h3 class="ss_form_title text-center">Initial Form</h3>
            <button type="button" class="btn btn-primary pull-right" ng-click="save()"><i class="fa fa-floppy-o"></i>&nbsp;Save</button>
            <span class="pull-right">&nbsp;&nbsp;</span>
            <button type="button" class="btn btn-success pull-right" ng-click="print()"><i class="fa fa-print"></i>&nbsp;Print</button>
        </div>
        <div class="clearfix"></div>
        <br />
        <div class="container ss_border">
            <div>
                <table class="table table-condensed">
                    <tr>
                        <td>
                            <h5 class="ss_form_title">Date</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.date" ss-date />
                        </td>
                        <td>
                            <h5 class="ss_form_title">Clean Up</h5>
                        </td>
                        <td>
                            <pt-radio name="cleanUp" model="data.Form.isCleanUp"></pt-radio>
                        </td>
                        <td>
                            <h5 class="ss_form_title">Tax class</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.TaxClass" /></td>
                    </tr>
                    <tr>
                        <td>
                            <h5 class="ss_form_title">Asset Manager</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.AssetManager" />
                        </td>
                        <td>
                            <h5 class="ss_form_title">No. Of Family</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.From.NumOfFamily" />
                        </td>
                        <td>
                            <h5 class="ss_form_title">Resale Value</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.ResaleValue" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <h5 class="ss_form_title">Property Address</h5>
                        </td>
                        <td colspan="4">
                            <input class="ss_form_input" ng-model="data.Form.Address" />
                        </td>
                    </tr>

                </table>
            </div>
            <br />
            <div>
                <h4 class="ss_form_title">Property Layout/Description</h4>
                <table class="table">
                    <tr>
                        <th style="border-top: none">Floor</th>
                        <th style="border-top: none"># of Rooms</th>
                        <th style="border-top: none"># of Bathrooms</th>
                        <th style="border-top: none"># of Bedrooms</th>
                        <th style="border-top: none">Condition/Description</th>
                    </tr>
                    <tr ng-repeat="floor in ['Cellar','Basement' ,'1st', '2nd', '3rd']">
                        <td>{{floor}}</td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Layout[floor + '_NumOfRoom']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Layout[floor + '_NumOfBathroom']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Layout[floor + '_NumOfBed']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Layout[floor + '_Desc']" /></td>
                    </tr>
                </table>
            </div>
            <br />
            <div class="clearfix"></div>
            <div>
                <label class="ss_form_title col-sm-2">Exterior</label>
                <textarea class="col-sm-10" ng-model="data.Form.Exterior"></textarea>
            </div>
            <div class="clearfix"></div>
            <hr />
            <div>
                <label class="ss_form_title ss_form_title col-sm-2">Backyard</label>
                <textarea class="col-sm-10" ng-model="data.Form.Backyard"></textarea>
            </div>
            <div class="clearfix"></div>
            <br />
            <div>
                <h4 class="ss_form_title">Utility</h4>
                <table class="table">
                    <tr>
                        <th style="border-top: none"></th>
                        <th style="border-top: none">Service On/Off</th>
                        <th style="border-top: none"># of Meters</th>
                        <th style="border-top: none">Missing Meters</th>
                        <th style="border-top: none">Location</th>
                        <th style="border-top: none">Meter Number/Readings</th>
                    </tr>
                    <tr ng-repeat="u in ['GAS', 'Electric', 'Water']">
                        <td>{{u}}</td>
                        <td>
                            <pt-radio name="{{u}}Service" model="data.Form.Utility[u + '_isService']"></pt-radio>
                        </td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Utility[u + '_NumOfMeters']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Utility[u + '_MissingMeters']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Utility[u + '_Location']" /></td>
                        <td>
                            <input class="ss_form_input" ng-model="data.Form.Utility[u + '_MeterReading']" /></td>

                    </tr>
                </table>
            </div>
            <br />
            <div>
                <label class="ss_form_title col-sm-2">Comments</label>
                <textarea class="col-sm-10" ng-model="data.Form.Comments"></textarea>
            </div>
            <div class="clearfix"></div>
            <br />
            <div>
                <h4 class="ss_form_title">Sketch</h4>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[1].floorName" /></h5>
                    <div id="InitialForm_Canvas1" class="LiterallyCanvas"></div>
                </div>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[2].floorName" /></h5>
                    <div id="InitialForm_Canvas2" class="LiterallyCanvas"></div>

                </div>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[3].floorName" /></h5>
                    <div id="InitialForm_Canvas3" class="LiterallyCanvas"></div>

                </div>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[4].floorName" /></h5>
                    <div id="InitialForm_Canvas4" class="LiterallyCanvas"></div>

                </div>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[5].floorName" /></h5>
                    <div id="InitialForm_Canvas5" class="LiterallyCanvas"></div>
                </div>
                <div class="col-md-6" style="border: 1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" ng-model="data.Form.Sketch[6].floorName" /></h5>
                    <div id="InitialForm_Canvas6" class="LiterallyCanvas"></div>

                </div>
            </div>
        </div>
    </div>
    <script>
        angular.module("PortalApp")
            .controller("InitialFormController", function ($scope, $http) {
                $scope.data = {
                    BBLE: '<%= BBLE %>',
                    Form: {
                        Layout: {},
                        Utility: {},
                        Sketch: [
                            { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }
                        ]
                    }
                }
                $scope.canvasEls = [];
                $scope.load = function () {
                    var url = "/api/ConstructionCases/GetInitialForm?bble=" + $scope.data.BBLE;
                    $http.get(url)
                    .then(function success(res) {
                        if (res.data) {
                            $scope.data = res.data;
                            if (!$scope.data.Form.Sketch) {
                                $scope.data.Form.Sketch = [{ floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }, { floorName: "" }];
                            }
                        }
                        $scope.canvasInit();
                    }, function error(res) {
                        alert("Get form fails");
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

                $scope.canvasInit = function () {
                    $(".LiterallyCanvas").each(function (idx, el) {
                        var lc = LC.init(el, {
                            imageSize: { width: 470, height: 320 },
                            keyboardShortcuts: false,
                            backgroundColor: '#fff',
                            defaultStrokeWidth: 2,
                            imageURLPrefix: "/Scripts/literallycanvas/img/",
                        });
                        $scope.canvasEls.push(lc);
                        if ($scope.data.Form.Sketch && $scope.data.Form.Sketch[idx].snapshot) {
                            lc.loadSnapshot($scope.data.Form.Sketch[idx].snapshot);
                        }
                    })

                }

                $scope.canvasSave = function () {
                    _.each($scope.canvasEls, function (el, idx) {
                        var snapshot = el.getSnapshot(["shapes", "colors"]);
                        $scope.data.Form.Sketch[idx].snapshot = snapshot;
                    });
                }
                $scope.load();
            });
    </script>
</asp:Content>
