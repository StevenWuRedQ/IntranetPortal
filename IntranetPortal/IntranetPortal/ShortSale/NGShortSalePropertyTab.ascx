<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.NGShortSalePropertyTab" %>
<%@ Import Namespace="IntranetPortal" %>

<div>
    <h4 class="ss_form_title">Property Address</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" readonly="readonly" ng-value="SsCase.LeadsInfo.Block ?SsCase.LeadsInfo.Block +'/'+SsCase.LeadsInfo.Lot:''">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">BBLE</label>
                <input class="ss_form_input" readonly="readonly" ng-model="SsCase.LeadsInfo.BBLE">
            </li>
            <li class="ss_form_item" style="visibility: hidden">
                <label class="ss_form_input_title">BBLE</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.BBLE">
            </li>
            <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input" readonly="readonly" ng-model="SsCase.LeadsInfo.PropertyAddress" style="width: 93.5%;">
            </li>
            <%--<li class="ss_form_item">
                <label class="ss_form_input_title">Street Number</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.Number" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Street Name</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.StreetName" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Apt #</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.AptNo" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.NeighName" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">State</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.State" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zip</label>
                <input class="ss_form_input" mask="99999" clean='true' ng-model="SsCase.LeadsInfo.ZipCode" readonly="readonly">
        </li>--%>
        </ul>
    </div>
</div>

<%-- 
<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Occupancy</label>
                <select class="ss_form_input" ng-model="SsCase.OccupiedBy">
                    <option></option>
                    <option>Vacant            </option>
                    <option>Seller            </option>
                    <option>Tenants (Coop)    </option>
                    <option>Tenants (Non-Coop)</option>
                    <option>Seller + Tenant   </option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Access</label>
                <input class="ss_form_input" ng-model="SsCase.LockBoxCode">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Lockbox</label>
                <input class="ss_form_input" ng-model="SsCase.Lockbox">
            </li>
        </ul>
    </div>
</div>
--%>

<div class="ss_form">
    <h4 class="ss_form_title">Building Info</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">C/O Class</label>
                <input class="ss_form_input" ng-model="SsCase.PropertyInfo.COClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Units</label>
                <input class="ss_form_input" ng-model="SsCase.PropertyInfo.NumOfUnit">
            </li>
            <li class="ss_form_item">&nbsp;
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input" readonly="readonly" ng-model="SsCase.LeadsInfo.PropertyClass">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Units</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.UnitNum" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Year Built</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.YearBuilt" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lot Size</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.LotDem" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.BuildingDem" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.NumFloors" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.CalculatedSqft" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.NYCSqft" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Unbuilt Sqft</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.UnbuiltSqft" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.Zoning" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.MaxFar" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Actual FAR</label>
                <input class="ss_form_input" ng-model="SsCase.LeadsInfo.ActualFar" readonly="readonly">
            </li>

        </ul>
    </div>
</div>

<%-- 
<div class="ss_form" id="home_breakdown_table">

    <h4 class="ss_form_title">Home Breakdown <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.PropertyInfo.PropFloors,'SsCase.PropertyInfo.PropFloors')" title="Add"></i>
    </h4>
    <div class="ss_border" ng-show="SsCase.PropertyInfo.PropFloors.length>0">
        <div class="ss_form_box clearfix ss_form_small_font">
            <div dx-data-grid="homeBreakdownBindingOptions()"></div>
        </div>
    </div>
</div>
--%>

<div class="ss_form" id="home_breakdown_table_new">
    <h4 class="ss_form_title">Home Breakdown <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.PropertyInfo.PropFloors,'SsCase.PropertyInfo.PropFloors')" title="Add"></i>
    </h4>
    <table class="table table-striped table-bordered table-responsive">
        <tr>
            <th>Floor</th>
            <th>Room Details</th>
            <th>Occupied Details</th>
            <th></th>
        </tr>
        <tr class="icon_btn" ng-repeat="floor in SsCase.PropertyInfo.PropFloors" id="floor{{$index}}" ng-click="setVisiblePopup(SsCase.PropertyInfo.PropFloors[$index], true)">
            <td>{{$index}}</td>
            <td>
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-6" style="padding: 0px">
                            <span>bedroom:{{floor.Bedroom}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Bathroom:{{floor.Bathroom}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Livingroom:{{floor.Livingroom}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Kitchen:{{floor.Kitchen}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Diningroom:{{floor.Diningroom}}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Occupancy:{{floor.Occupied}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Access:{{floor.Access}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>Lockbox:{{floor.Lockbox}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>LockupDate:{{floor.LockupDate}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>LockedBy:{{floor.LockedBy}}</span>
                        </div>
                        <div class="col-sm-6" style="padding: 0px">
                            <span>LastChecked:{{floor.LastChecked}}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td><i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.PropFloors, $index)" title="Delete"></i>
                <div dx-popup="{    
                                height: 850,
                                width: 600, 
                                title: 'Floor '+$index,
                                dragEnabled: false,
                                showCloseButton: true,
                                bindingOptions:{ visible: 'SsCase.PropertyInfo.PropFloors['+$index+'].visiblePopup' }
                            }">
                    <div data-options="dxTemplate:{ name: 'content' }">

                        <form>
                            <div>
                                <label>bedroom</label>
                                <input class="form-control" ng-model="floor.Bedroom" />
                            </div>
                            <div>
                                <label>Bathroom</label>
                                <input class="form-control" ng-model="floor.Bathroom" />
    </div>
                            <div>
                                <label>Livingroom</label>
                                <input class="form-control" ng-model="floor.Livingroom" />
                            </div>
                            <div>
                                <label>Kitchen</label>
                                <input class="form-control" ng-model="floor.Kitchen" />
                            </div>
                            <div>
                                <label>Diningroom</label>
                                <input class="form-control" ng-model="floor.Diningroom" />
                            </div>
                            <hr />
                            <div>
                                <label>Occupancy</label><br />
                                <select ng-model="floor.OccupiedBy">
                                    <option></option>
                                    <option>Vacant            </option>
                                    <option>Seller            </option>
                                    <option>Tenants (Coop)    </option>
                                    <option>Tenants (Non-Coop)</option>
                                    <option>Seller + Tenant   </option>
                                </select>
                            </div>
                            <div>
                                <label>Access</label>
                                <input class="form-control" ng-model="floor.Access" />
                            </div>
                            <div>
                                <label>Lockbox</label>
                                <input class="form-control" ng-model="floor.Lockbox" />
                            </div>
                            <div>
                                <label>LockupDate</label>
                                <input class="form-control" ss-date ng-model="floor.LockupDate" />
                            </div>
                            <div>
                                <label>LockedBy</label>
                                <input class="form-control" ng-model="floor.LockedBy" />
                            </div>
                            <div>
                                <label>LastChecked</label>
                                <input class="form-control" ss-date ng-model="floor.LastChecked" />
                            </div>                       
                        </form>
                        <br />
                            <button class="btn btn-primary pull-right" ng-click="setVisiblePopup(SsCase.PropertyInfo.PropFloors[$index], false)">Save</button>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</div>

<script src="/Scripts/mindmup-editabletable.js"></script>
<script>
    function onRefreashDone() {
        //$("#home_breakdown_table").editableTableWidget();
        $(".ss_form_input, .input_with_check").not(".ss_allow_eidt").prop("disabled", true);
        initToolTips();
        format_input();
    }
</script>
