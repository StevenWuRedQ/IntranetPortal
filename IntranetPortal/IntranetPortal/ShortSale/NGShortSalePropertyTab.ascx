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
            <input class="ss_form_input" ng-value="SsCase.LeadsInfo.Block ?SsCase.LeadsInfo.Block +'/'+SsCase.LeadsInfo.Lot:''">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">BBLE</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.BBLE">
        </li>
        <li class="ss_form_item" style="visibility: hidden">
            <label class="ss_form_input_title">BBLE</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.BBLE">
        </li>
        <li class="ss_form_item">
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
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.ZipCode" readonly="readonly">
        </li>



    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupancy</label>
            <select class="ss_form_input" ng-model="SsCase.OccupiedBy">
                <option></option>
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
<div class="ss_form">
    <h4 class="ss_form_title">Building Info</h4>
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
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.TaxClass">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Total Units</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.UnitNum">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Year Built</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.YearBuilt">
        </li>


        <li class="ss_form_item">
            <label class="ss_form_input_title">Lot Size</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.LotDem">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building Size</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.BuildingDem">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Building Stories</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.NumFloors">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Calculated Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.CalculatedSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">NYC Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.NYCSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Unbuilt Sqft</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.UnbuiltSqft">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Zoning Code</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.Zoning">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Max FAR</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.MaxFar">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Actual FAR</label>
            <input class="ss_form_input" ng-model="SsCase.LeadsInfo.ActualFar">
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
            <td>{{$index+1}}
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
