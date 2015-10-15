<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialForm.aspx.vb" Inherits="IntranetPortal.ConstructionInitialForm" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">


    <div id="initialForm" ng-controller="InitialformController">
        <br />
        <div class="container">
            <h3 class="ss_form_title text-center">Initial Form</h3>
            <button type="button" class="btn btn-primary pull-right"><i class="fa fa-floppy-o"></i>&nbsp;Save</button>
            <span class="pull-right">&nbsp;&nbsp;</span>
            <button type="button" class="btn btn-primary pull-right"><i class="fa fa-print"></i>&nbsp;Print</button>
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
                            <input class="ss_form_input" ng-model="form.date" ss-date />
                        </td>
                        <td>
                            <h5 class="ss_form_title">Clean Up</h5>
                        </td>
                        <td>
                            <pt-radio name="cleanUp" model="form.xx"></pt-radio>
                        </td>
                        <td>
                            <h5 class="ss_form_title">Tax class</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" /></td>
                    </tr>
                    <tr>
                        <td>
                            <h5 class="ss_form_title">Asset Manager</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" />
                        </td>
                        <td>
                            <h5 class="ss_form_title">No. Of Family</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" />
                        </td>
                        <td>
                            <h5 class="ss_form_title">Resale Value</h5>
                        </td>
                        <td>
                            <input class="ss_form_input" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <h5 class="ss_form_title">Property Address</h5>
                        </td>
                        <td colspan="4">
                            <input class="ss_form_input" />
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
                        <th style="border-top: none"># of BathRooms</th>
                        <th style="border-top: none"># of Bedrooms</th>
                        <th style="border-top: none">Condition/Description</th>
                    </tr>
                    <tr ng-repeat="floor in ['Cellar','Basement' ,'1st', '2nd', '3rd']">
                        <td>{{floor}}</td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>
                    </tr>
                </table>
            </div>
            <br />
            <div class="clearfix"></div>
            <div>
                <label class="ss_form_title col-sm-2">Exterior</label>
                <textarea class="col-sm-10"></textarea>
            </div>
            <div class="clearfix"></div>
            <hr />
            <div>
                <label class="ss_form_title ss_form_title col-sm-2">Backyard</label>
                <textarea class="col-sm-10"></textarea>
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
                        <td></td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>
                        <td>
                            <input class="ss_form_input" /></td>

                    </tr>
                </table>
            </div>
            <br />
            <div>
                <label class="ss_form_title col-sm-2">Comments</label>
                <textarea class="col-sm-10"></textarea>
            </div>
            <div class="clearfix"></div>
            <br />
            <div>
                <h4 class="ss_form_title">Sketch</h4>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>
                    <textarea></textarea>
                </div>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>
                    <textarea></textarea>
                </div>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>
                    <textarea></textarea>
                </div>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>
                    <textarea></textarea>
                </div>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>

                    <textarea></textarea>
                </div>
                <div class="col-md-6" style="border:1px solid black">
                    <h5>Floors:&nbsp;<input style="border: none" /></h5>

                    <textarea></textarea>
                </div>
            </div>
        </div>
    </div>
    <script>
        angular.module("PortalApp").controller("InitialformController", function ($scope) {

            $scope.form = {}
        });
    </script>
</asp:Content>
