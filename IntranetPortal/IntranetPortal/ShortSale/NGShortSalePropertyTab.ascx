<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSalePropertyTab.ascx.vb" Inherits="IntranetPortal.NGShortSalePropertyTab" %>
<%@ Import Namespace="IntranetPortal" %>
<script>
    
</script>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
    </div>
</div>

<div>
    <h4 class="ss_form_title">Property Address</h4>
    <ul class="ss_form_box clearfix">
        
        <li class="ss_form_item">
            <label class="ss_form_input_title">Block/Lot</label>
            <input class="ss_form_input" ng-value="SsCase.PropertyInfo.Block ?SsCase.PropertyInfo.Block +'/'+SsCase.PropertyInfo.Lot:''">
        </li>
        <li class="ss_form_item" style="visibility: hidden">
            <label class="ss_form_input_title">BBLE</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.BBLE">
        </li>
         <li class="ss_form_item" style="visibility: hidden">
            <label class="ss_form_input_title">BBLE</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.BBLE">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Number</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.Number" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Street Name</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.StreetName" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Apt #</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.AptNo" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.City" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.State" readonly="readonly">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zip</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.Zipcode" readonly="readonly">
        </li>



    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupancy</label>
            <select class="ss_form_input" ng-model="SsCase.Occupancy">
                <option>Seller            </option>
                <option>Tenants (Coop)    </option>
                <option>Tenants (Non-Coop)</option>
                <option>Seller + Tenant   </option>

            </select>
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Access</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.TTT">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">TTTT</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.Fillable">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lockbox</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.Lockbox">
        </li>
    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Building Info</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">C/O Class</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.COClass">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Total Units</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.TotalUnits">
        </li>
        <li class="ss_form_item">&nbsp;
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Class</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.TaxClass">
        </li>
        
        <li class="ss_form_item">
            <label class="ss_form_input_title">Total Units</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.PropertyAddress">
        </li>

      
        <li class="ss_form_item">
            <label class="ss_form_input_title">Year Built</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.YearBuilt">
        </li>


        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot Size</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.LotDem">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building Size</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.BuildingDem">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building Stories</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.NumFloors">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Calculated Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.CalculatedSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">NYC Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.NYCSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Unbuilt Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.UnbuiltSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zoning Code</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.Zoning">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Max FAR</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.MaxFar">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Actual FAR</label>
            <input class="ss_form_input" ng-model="SsCase.PropertyInfo.ActualFar">
        </li>

    </ul>

</div>
<div class="ss_form" id="home_breakdown_table">
    <h4 class="ss_form_title">Home Breakdown   <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.PropertyInfo.PropFloors)" title="Add"></i>
        </h4>
    <%-- log tables--%>
    <table class="table table-striped">
        <thead>
            <tr>
                <th>Floor</th>
                <th>Bedrooms</th>
                <th>Bathrooms</th>
                <th>Living Room</th>
                <th>Kitchen</th>
                <th>Dinning Room</th>
                <th>Occupied</th>
                <th>Deleted</th>
            </tr>
        </thead>
        <tr ng-repeat="floor in SsCase.PropertyInfo.PropFloors">
            <td>
                {{$index+1}}
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Bedroom">
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Bathroom">
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Livingroom">
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Kitchen">
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Diningroom">
            </td>
            <td>
                <input class="ss_form_input" ng-model="floor.Occupied">
            </td>
             <td>
                <i class="fa fa-times-circle icon_btn color_blue tooltip-examples" ng-click="NGDeleteItem(SsCase.PropertyInfo.PropFloors,$index)" title="Delete"></i>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hfBble" runat="server" />
    <asp:HiddenField ID="hfCaseId" runat="server" />
    <div style="display: none">
        <dx:ASPxGridView ID="home_breakdown_gridview" runat="server" KeyFieldName="BBLE;FloorId" SettingsBehavior-AllowDragDrop="false" SettingsBehavior-AllowSort="false" OnRowInserting="home_breakdown_gridview_RowInserting" OnRowDeleting="home_breakdown_gridview_RowDeleting" OnRowUpdating="home_breakdown_gridview_RowUpdating">

            <Columns>

                <dx:GridViewCommandColumn ShowEditButton="true" ShowNewButtonInHeader="true" ShowDeleteButton="True" />
                <%--<dx:GridViewDataColumn FieldName="FloorId" VisibleIndex="1" Caption="Floor" 
                    
                    />--%>


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

        <%--   <table class="table">
            <thead>
                <tr>
                    <th>Bedrooms</th>
                    <th>Bathrooms</th>
                    <th>Living Room</th>
                    <th>Kitcken</th>
                    <th>Dining Room</th>
                    <th>Whatever</th>
                    <th>Effective</th>
                    <th>Basement</th>
                    <th>1st floor</th>
                    <th>2nd floor</th>
                    <th>3rd floor</th>
                    <th>4th floor</th>
                </tr>
            </thead>
            <tbody>
                <tr class="font_14">
                    <td>Bedrooms</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                    <td>1</td>
                </tr>
                <tr class="font_14">
                    <td>Bathrooms</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                    <td>2</td>
                </tr>
                <tr class="font_14">
                    <td>Living Room</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                    <td>3</td>
                </tr>
                <tr class="font_14">
                    <td>Kitcken</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                    <td>4</td>
                </tr>
                <tr class="font_14">
                    <td>Dining Room</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                    <td>6</td>
                </tr>
                <tr class="font_14">
                    <td>Occupied</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                    <td>Homeowner</td>
                </tr>
                <tr class="font_14">
                    <td>Lease</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                </tr>
                <tr class="font_14">
                    <td>Rent</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                    <td>N/A</td>
                </tr>
                <tr class="font_14">
                    <td>Type</td>
                    <td>Whatever</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr class="font_14">
                    <td>Boiler Room</td>
                    <td>1</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </tbody>
        </table>--%>
    </div>
    <%------end-------%>
</div>

<script src="/Scripts/mindmup-editabletable.js"></script>
<script>
    function onRefreashDone() {
        //$("#home_breakdown_table").editableTableWidget();
        $(".ss_form_input, .input_with_check").not(".ss_allow_eidt").prop("disabled", true);
        initToolTips();

        format_input();
        //$("#prioity_content").mCustomScrollbar(
        //      {
        //          theme: "minimal-dark"
        //      }
        //      );
        //$("#home_owner_content").mCustomScrollbar(
        //    {
        //        theme: "minimal-dark"
        //    }
        // );

        //$(".dxgvCSD").mCustomScrollbar(
        //    {
        //        theme: "minimal-dark",

        //    }
        // );
    }
    //$(document).ready(function () {
    //    // Handler for .ready() called.
    //    d_alert("rund edit ");
    //    $("#home_breakdown_table").editableTableWidget();
    //});

</script>
