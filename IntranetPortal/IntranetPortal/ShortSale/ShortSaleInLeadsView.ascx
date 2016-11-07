<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleInLeadsView.ascx.vb" Inherits="IntranetPortal.ShortSaleInLeadsView" %>

<asp:HiddenField ID="hfBble" runat="server" />
<asp:HiddenField ID="hfCaseId" runat="server" />

<div class="form_head" style="margin-top: 40px;">Home Breakdown  <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" title="add" onclick=""></i></div>

<table class="table table-striped table-bordered table-responsive">
    <tr>
        <th>Unit</th>
        <th>Room</th>
        <th>Occupancy</th>
        <th>Access</th>
        <th></th>
    </tr>
    <% For Each floor In propertyInfo.PropFloors%>
    <tr class="icon_btn" ondblclick="SSHomeBreakdown.Edit('<%= floor.BBLE%>', '<%=floor.FloorId%>')">
        <td><%= floor.FloorId %></td>
        <td class="col-sm-3">
            <div class="content">
                <div class="row" style="margin: 0px">
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Description:</b> <%=floor.Description%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Bedroom:</b> <%=floor.Bedroom%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Bathroom:</b> <%=floor.Bathroom%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Living Room:</b> <%=floor.Livingroom%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Kitchen:</b> <%=floor.Kitchen%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Dining Room:</b> <%=floor.Diningroom%></span>
                    </div>
                </div>
            </div>
        </td>
        <td class="col-sm-4">
            <div class="content">
                <div class="row" style="margin: 0px">
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Occupancy:</b> <%=floor.Occupied%></span>
                    </div>
                    <%If (floor.Occupied = "Seller" OrElse floor.Occupied = "Tenants (Coop)" OrElse floor.Occupied = "Tenants (Non-Coop)") Then%>
                    <% For Each occupant In floor.Occupants%>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Name:</b> <%=occupant.Name%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Phone:</b> <%=occupant.Phone%></span>
                    </div>
                    <hr />
                    <% Next%>

                    <% End If%>
                </div>
            </div>

        </td>
        <td class="col-sm-4">
            <div class="content">
                <div class="row" style="margin: 0px">
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Access:</b> <%=floor.Access%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>Lockbox:</b> <%=floor.LockBox%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>LockupDate:</b> <%= String.Format("{0:g}", floor.LockupDate)%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>LockedBy:</b> <%=floor.LockedBy%></span>
                    </div>
                    <div class="col-sm-12" style="padding: 0px">
                        <span><b>LastChecked:</b> <%= String.Format("{0:g}", floor.LastChecked)%></span>
                    </div>
                </div>
            </div>
        </td>
        <td>
            <i class="fa fa-times icon_btn tooltip-examples text-danger" onclick="" title="Delete"></i>
        </td>
    </tr>
    <% Next%>
</table>

<dx:ASPxPopupControl ClientInstanceName="popupEditor" Width="550px" Height="440px" ID="ASPxPopupControl2"
    HeaderText="Edit Home Breakdown" AutoUpdatePosition="true" Modal="true" CloseAction="CloseButton" OnWindowCallback="ASPxPopupControl2_OnWindowCallback"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
            <asp:HiddenField runat="server" ID="hfFloorId" />
            <asp:HiddenField runat="server" ID="hfFloorBBLE" />
            <div>
                <div>
                    <div style="height: 88%; padding: 0px 5px; overflow-y: auto; overflow-x: hidden">
                        <div class="row">
                            <div class="col-sm-6">
                                <label>Description</label>
                                <input class="form-control" type="text" runat="server" id="txtDescription" />
                            </div>
                            <div class="col-sm-6">
                                <label>Bedroom</label>
                                <input class="form-control" type="text" runat="server" id="txtBedroom" />
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
                                <label>Occupancy&nbsp<i class="fa fa-plus-circle icon_btn tooltip-examples text-primary" ng-show="floor.Occupied  == 'Seller' || floor.Occupied  == 'Tenants (Coop)' || floor.Occupied == 'Tenants (Non-Coop)'" ng-click="NGAddArraryItem(SsCase.PropertyInfo.PropFloors[$index].Occupants,'SsCase.PropertyInfo.PropFloors['+$index+'].Occupants')" title="Add"></i></label>
                                <select class="form-control" ng-model="floor.Occupied">
                                    <option>Vacant</option>
                                    <option>Seller</option>
                                    <option>Tenants (Coop)</option>
                                    <option>Tenants (Non-Coop)</option>
                                </select>
                            </div>

                            <div ng-repeat="occupant in floor.Occupants" ng-show="floor.Occupied  == 'Seller' || floor.Occupied  == 'Tenants (Coop)' || floor.Occupied == 'Tenants (Non-Coop)'">
                                
                                <dx:ASPxGridView ID="gridOccupants" runat="server" KeyFieldName="OccupantId" Visible="True">
                                    <Columns>
                                        <dx:GridViewDataColumn FieldName="Name" VisibleIndex="1" />
                                        <dx:GridViewDataColumn FieldName="Phone" VisibleIndex="2" />
                                        <dx:GridViewCommandColumn ShowNewButton="True" ShowEditButton="True" ShowDeleteButton="True"></dx:GridViewCommandColumn>
                                    </Columns>
                                    <SettingsEditing Mode="Inline"></SettingsEditing>
                                </dx:ASPxGridView>

                             <%--   <div class="col-sm-6">
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
                                        <i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.PropFloors[$parent.$index].Occupants, $index)" title="Delete"></i>
                                    </div>
                                </div>--%>
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
                                <input class="form-control" pt-date ng-model="floor.LockupDate" />
                            </div>
                            <div class="col-sm-6">
                                <label>LockedBy</label>
                                <input class="form-control" ng-model="floor.LockedBy" />
                            </div>
                            <div class="col-sm-6">
                                <label>LastChecked</label>
                                <input class="form-control" pt-date ng-model="floor.LastChecked" />
                            </div>
                        </div>
                    </div>
                    <hr />
                    <button class="btn btn-primary pull-right" ng-click="setVisiblePopup(SsCase.PropertyInfo.PropFloors[$index], false)">Save</button>
                </div>
            </div>
        </dx:PopupControlContentControl>
    </ContentCollection>
    <ClientSideEvents CloseUp="function(s,e){}" />
</dx:ASPxPopupControl>

<dx:ASPxGridView ID="home_breakdown_gridview" runat="server" KeyFieldName="BBLE;FloorId" SettingsBehavior-AllowDragDrop="false" SettingsBehavior-AllowSort="false" OnRowInserting="home_breakdown_gridview_RowInserting" OnRowDeleting="home_breakdown_gridview_RowDeleting" OnRowUpdating="home_breakdown_gridview_RowUpdating" Visible="false">
    <Columns>
        <dx:GridViewCommandColumn ShowEditButton="true" ShowNewButtonInHeader="true" ShowDeleteButton="True" />
        <dx:GridViewDataColumn FieldName="FloorId" VisibleIndex="1" Caption="Floor" ReadOnly="true">
            <EditItemTemplate>
                <span>
                    <%# GetFloorId(Eval("FloorId"))%>
                </span>
            </EditItemTemplate>
        </dx:GridViewDataColumn>
        <dx:GridViewDataColumn FieldName="Bedroom" VisibleIndex="1" />
        <dx:GridViewDataColumn FieldName="Bathroom" VisibleIndex="2" />
        <dx:GridViewDataColumn FieldName="Livingroom" VisibleIndex="3" />
        <dx:GridViewDataColumn FieldName="Kitchen" VisibleIndex="4" />
        <dx:GridViewDataColumn FieldName="Diningroom" VisibleIndex="5" />
        <dx:GridViewDataColumn FieldName="Occupied" VisibleIndex="5" />
        <%--<dx:GridViewDataColumn FieldName="Lease" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Type" VisibleIndex="5" />
                <dx:GridViewDataColumn FieldName="Rent" VisibleIndex="5" />

                <dx:GridViewDataColumn FieldName="BoilerRoom" VisibleIndex="5" />--%>
    </Columns>
    <SettingsEditing Mode="PopupEditForm" />
</dx:ASPxGridView>
