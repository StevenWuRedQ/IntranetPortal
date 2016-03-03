<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ReportWizard.aspx.vb" Inherits="IntranetPortal.ReportWizard" MasterPageFile="~/Content.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="head"></asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="MainContentPH">
    <link rel="stylesheet" href="/css/right-pane.css" />
    <script src="/Scripts/js/right_pane.js?v=1.01" type="text/javascript"></script>
    <input type="hidden" value="<%=ReportId%>" id="txtReportID"/>
    <div id="ReportWizardCtrl" ng-controller="ReportWizardCtrl" class="wx_scorll_list" data-bottom="90">
        <div class="container" style="padding-top: 30px; font-size: small">
            <div class="nga-fast nga-fade" ng-show="step==1" style="margin-left: -50px">
                <div ng-repeat="c in Fields track by c.category" class="col-sm-6 col-md-6">
                    <table class="table table-condensed">
                        <tr>
                            <th class="text-primary">{{c.category}} &nbsp
                            <pt-collapse model="collpsed[c.category]"></pt-collapse>
                            </th>
                        </tr>
                        <tr ng-repeat="f in c.fields track by f.name" uib-collapse="!collpsed[c.category]">
                            <td>
                                <label for="{{camel(f.name)}}" ng-class="" ng-style="isBindColumn(f)?{}:{'color': '#e0e0e0'}">{{f.name}}</label></td>
                            <td>
                                <input type="checkbox" id="{{camel(f.name)}}" style="display: block" ng-model="f.checked" ng-disabled="!isBindColumn(f)" /></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="nga-fast nga-fade" ng-show="step==2" style="margin-left: -50px">
                <div ng-show="someCheck(c)" ng-repeat="c in Fields" class="col-sm-12 col-md-12">
                    <h4 class="text-primary">{{c.category}}</h4>
                    <div>
                        <table class="table table-condensed">
                            <tr ng-repeat="f in c.fields|filter:{checked: true}">
                                <td class="col-sm-3 col-md-3">
                                    <label for="{{camel(f.name)}}">{{f.name}}</label></td>
                                <td>

                                    <span ng-show="f.filters">
                                        <span ng-repeat="x in f.filters">
                                            <span ng-if="f.type=='string'">
                                                <select ng-model="x.criteria" ng-change="updateStringFilter(x)">
                                                    <option value="1">is start with</option>
                                                    <option value="2">is end with</option>
                                                    <option value="3">contains</option>
                                                </select>
                                                <input type="text" ng-model="x.input1" ng-change="updateStringFilter(x)" />
                                            </span>
                                            <span ng-if="f.type=='date'">
                                                <select ng-model="x.criteria" ng-change="updateDateFilter(x)">
                                                    <option value="1">is before</option>
                                                    <option value="2">is after</option>
                                                    <option value="3">equals</option>
                                                </select>
                                                <input type="text" ng-model="x.input1" ng-change="updateDateFilter(x)" type="text" ss-date />
                                            </span>
                                            <span ng-if="f.type=='number'">
                                                <select ng-model="x.criteria" ng-change="updateNumberFilter(x)">
                                                    <option value="0">=</option>
                                                    <option value="1"><</option>
                                                    <option value="2"><=</option>
                                                    <option value="3">></option>
                                                    <option value="4">>=</option>
                                                    <option value="5">between</option>
                                                </select>
                                                <input type="text" ng-model="x.input1" ng-change="updateNumberFilter(x)" />
                                                <span ng-show="x.criteria=='5'">AND
                                                <input type="text" ng-model="x.input2" ng-change="updateNumberFilter(x)" /></span>
                                            </span>
                                            <span ng-if="f.type=='list'" style="width: 300px; display: inline-block">
                                                <span>
                                                    <ui-select multiple ng-model="x.input1" ng-change="updateListFilter(x)">
                                                    <ui-select-match placeholder="Choose items">{{$item}}</ui-select-match>
                                                    <ui-select-choices repeat="o in f.options | filter: $search.search">
                                                   
                                                </ui-select-choices>
                                            </ui-select>
                                                </span>
                                            </span>
                                            <span ng-if="f.type=='boolean'">
                                                <select ng-model="x.input1" ng-change="updateBooleanFilter(x)">
                                                    <option value="1">Yes</option>
                                                    <option value="0">No</option>
                                                </select>
                                            </span>
                                            <pt-del ng-click="removeFilter(f, $index)"></pt-del>
                                            <br />
                                        </span>
                                    </span>
                                    <span class="btn btn-sm btn-primary" ng-show="true" hide-ng-show="!f.filters||f.filters.length==0" ng-click="addFilter(f)">add filter</span>
                                </td>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="nga-fast nga-face" ng-show="step==3" style="margin-left: -50px">
                <h3>Report <span style="font-weight: bold; color: blue">{{CurrentQuery?CurrentQuery.Name:""}}</span></h3>
                <div id="queryReport" dx-data-grid="{
                                    width: 1200,
                                    height: 750,
                                    allowColumnReordering: true,
                                    allowColumnResizing: true,
                                    columnAutoWidth: true,
                                    columnChooser: {
                                        enabled: true
                                    },
                                    columnFixing: { 
                                        enabled: true
                                    },
                                    stateStoring : {
                                        enabled: true
                                    },
                                    export: {
                                        enabled: true,
                                        fileName: 'Report'
                                    },
                                    bindingOptions: {
                                        dataSource: 'reportData',
                                        stateStoring: 'stateStoring'
                                    },
                                    editing: {
                                        editEnabled: false
                                    }                                        
                                }">
                </div>
            </div>
            <hr />
            <div class="col-md-12 col-sm-12 clearfix" style="padding-top: 20px">
                <button ng-show="step>1" type="button" class="btn-primary pull-left" ng-click="prev()">Prev</button>
                <button ng-show="step<2" type="button" class="btn-primary pull-right" ng-click="next()">Next</button>
                <button ng-show="step==2" type="button" class="btn-primary pull-right" ng-click="generate()">Generate</button>
                <%-- update --%>
                <button ng-show="CurrentQuery && step==3" type="button" class="btn-primary pull-right" ng-click="update()">Save Query</button>
                <%-- save new --%>
                <button ng-show="!CurrentQuery && step==3" type="button" class="btn-primary pull-right" ng-click="SaveQueryPop=true">Save Query</button>
            </div>
        </div>

        <div id="right-pane-container" class="clearfix" style="right: 0" ng-show="!LoadByID">
            <div id="right-pane-button" class="right-pane_custom_reports"></div>
            <div id="right-pane">
                <div style="height: 100%; background: #EFF2F5;">
                    <div style="width: 310px; background: #f5f5f5" class="agent_layout_float">
                        <div style="margin: 50px 20px; font-size: 24px; float: none;">
                            <h3>Save Reports</h3>
                            <hr />
                            <div>
                                <ul style="margin-right: 20px; font-size: 18px; list-style: none">
                                    <li class="icon_btn" ng-repeat="q in SavedReports track by q.ReportId">
                                        <i class="fa fa-file-o" ng-click="load(q)"></i>&nbsp;<span ng-click="load(q)">{{q.Name}}</span>&nbsp
                                        <pt-del ng-click="deleteSavedReport(q)" class="pull-right"></pt-del>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div dx-popup="{
            height: 200,
            width: 600,
            showTitle: false,
            dragEnabled: true,
            shading: true,
            bindingOptions:{ visible: 'SaveQueryPop' },
        }">
            <div data-options="dxTemplate:{ name: 'content' }">
                <h5>New Query Name</h5>
                <input class="form-control" ng-model="NewQueryName" />
                <hr>
                <div class="pull-right">
                    <button class="btn btn-danger" ng-click="onSaveQueryPopCancel()">Cancel</button>
                    <button class="btn btn-success" ng-click="onSaveQueryPopSave()">Save</button>
                </div>
            </div>
        </div>

    </div>
    <script>
        var CUSTOM_REPORT_TEMPLATE = "<%= Template %>.js";
    </script>

</asp:Content>
