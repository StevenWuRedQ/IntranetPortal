<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleInLeadsView.ascx.vb" Inherits="IntranetPortal.NGShortSaleInLeadsView" %>
<div id="homeBreakDownCtrl" ng-controller="homeBreakDownCtrl" class="ss_form" style="margin: 20px">
    <h4 class="ss_form_title">Home Breakdown&nbsp;
        <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="addNewUnit()" title="Add"></i>&nbsp;
        <i class="fa fa-save color_blue_edit collapse_btn" title="Save Home Breakdown" ng-click="saveHomeBreakDown()"></i>
    </h4>
    <table class="table table-striped table-bordered table-responsive">
        <tr>
            <th>Unit</th>
            <th>Room</th>
            <th>Occupancy</th>
            <th>Access</th>
            <th></th>
        </tr>
        <tr class="icon_btn" ng-repeat="floor in PropFloors" id="floor{{$index}}">
            <td ng-click="setPopupVisible(PropFloors[$index], true)">{{$index+1}}</td>
            <td class="col-sm-3" ng-click="setPopupVisible(PropFloors[$index], true)">
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Description:</b> {{floor.Description}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Bedroom:</b> {{floor.Bedroom}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Bathroom:</b> {{floor.Bathroom}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Living Room:</b> {{floor.Livingroom}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Kitchen:</b> {{floor.Kitchen}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Dining Room:</b> {{floor.Diningroom}}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td class="col-sm-4" ng-click="setPopupVisible(PropFloors[$index], true)">
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Occupancy:</b> {{floor.Occupied}}</span>
                        </div>
                        <div ng-repeat="occupant in floor.Occupants" ng-show="floor.Occupied  == 'Seller' || floor.Occupied  == 'Tenants (Coop)' || floor.Occupied == 'Tenants (Non-Coop)'">
                            <div class="col-sm-12" style="padding: 0px">
                                <span><b>Name:</b> {{occupant.Name}}</span>
                            </div>
                            <div class="col-sm-12" style="padding: 0px">
                                <span><b>Phone:</b> {{occupant.Phone}}</span>
                            </div>
                            <hr />
                        </div>
                    </div>
                </div>
            </td>
            <td class="col-sm-4" ng-click="setPopupVisible(PropFloors[$index], true)">
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Access:</b> {{floor.Access}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>Lockbox:</b> {{floor.LockBox}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>LockupDate:</b> {{floor.LockupDate |date: 'M/d/yyyy'}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>LockedBy:</b> {{floor.LockedBy}}</span>
                        </div>
                        <div class="col-sm-12" style="padding: 0px">
                            <span><b>LastChecked:</b> {{floor.LastChecked |date: 'M/d/yyyy'}}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td><i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="arrayRemove(PropFloors, $index, true)" title="Delete"></i>
                <div dx-popup="{    
                                height: 750,
                                width: 600, 
                                title: 'Unit '+ ($index+1),
                                dragEnabled: true,
                                showCloseButton: true,
                                shading: false,
                                bindingOptions:{ visible: 'PropFloors['+$index+'].popupVisible' },
                                scrolling: {mode: 'virtual' },
                            }">
                    <div data-options="dxTemplate:{ name: 'content' }">

                        <form style="height: 88%; padding: 0px 5px; overflow-y: auto; overflow-x: hidden">
                            <div class="row">
                                <div class="col-sm-6">
                                    <label>Description</label>
                                    <input class="form-control" ng-model="floor.Description" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Bedroom</label>
                                    <input class="form-control" ng-model="floor.Bedroom" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Bathroom</label>
                                    <input class="form-control" ng-model="floor.Bathroom" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Livingroom</label>
                                    <input class="form-control" ng-model="floor.Livingroom" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Kitchen</label>
                                    <input class="form-control" ng-model="floor.Kitchen" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Diningroom</label>
                                    <input class="form-control" ng-model="floor.Diningroom" />
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-sm-12">
                                    <label>Occupancy&nbsp<i class="fa fa-plus-circle icon_btn tooltip-examples text-primary" ng-show="floor.Occupied  == 'Seller' || floor.Occupied  == 'Tenants (Coop)' || floor.Occupied == 'Tenants (Non-Coop)'" ng-click="ensurePush('PropFloors['+$index+'].Occupants')" title="Add"></i></label>
                                    <select class="form-control" ng-model="floor.Occupied">
                                        <option>Vacant</option>
                                        <option>Seller</option>
                                        <option>Tenants (Coop)</option>
                                        <option>Tenants (Non-Coop)</option>
                                    </select>
                                </div>
                                <div ng-repeat="occupant in floor.Occupants" ng-show="floor.Occupied  == 'Seller' || floor.Occupied  == 'Tenants (Coop)' || floor.Occupied == 'Tenants (Non-Coop)'">
                                    <div class="col-sm-6">
                                        <label>Name</label>
                                        <input class="form-control" ng-model="occupant.Name" />
                                    </div>
                                    <div class="col-sm-5">
                                        <label>Phone</label>
                                        <input class="form-control" ng-model="occupant.Phone" />
                                    </div>
                                    <div class="col-sm-1">
                                        <label>&nbsp</label>
                                        <div class="text-right">
                                            <i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="arrayRemove(PropFloors[$parent.$index].Occupants, $index, true)" title="Delete"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-sm-6">
                                    <label>Access</label>
                                    <input class="form-control" ng-model="floor.Access" />
                                </div>
                                <div class="col-sm-6">
                                    <label>Lockbox</label>
                                    <input class="form-control" ng-model="floor.LockBox" />
                                </div>
                                <div class="col-sm-6">
                                    <label>LockupDate</label>
                                    <input class="form-control" ss-date ng-model="floor.LockupDate" />
                                </div>
                                <div class="col-sm-6">
                                    <label>LockedBy</label>
                                    <input class="form-control" ng-model="floor.LockedBy" />
                                </div>
                                <div class="col-sm-6">
                                    <label>LastChecked</label>
                                    <input class="form-control" ss-date ng-model="floor.LastChecked" />
                                </div>
                            </div>
                        </form>
                        <hr />
                        <button class="btn btn-primary pull-right" ng-click="setPopupVisible(PropFloors[$index], false)">Close</button>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</div>
