<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleDealInfoTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleDealInfoTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
</div>

<style>
    .ss_form_small_font {
        font-size: 10px !important;
    }

        .ss_form_small_font .dx-widget {
            font-size: 10px;
        }
</style>

<div>
    <div ng-show="SsCase.DocumentMissing.length>0" class="well">
        <label class="ss_form_input_title">Open Document Request</label>
        <p>{{SsCase.DocumentMissing}}</p>
    </div>
</div>

<div>
    <h4 class="ss_form_title">Title</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Company</label>
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.CompanyName">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Title #</label>
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.OrderNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Reviewed</label>
                <input class="ss_form_input disabled" ss-date ng-model="SsCase.BuyerTitle.ReviewedDate">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Order Date</label>
                <input class="ss_form_input disabled" ss-date ng-model="SsCase.BuyerTitle.ReportOrderDate">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Confirmation Date</label>
                <input class="ss_form_input disabled" ss-date ng-model="SsCase.BuyerTitle.ConfirmationDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Received Date</label>
                <input class="ss_form_input disabled" ss-date ng-model="SsCase.BuyerTitle.ReceivedDate">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Listing Info</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">MLS</label>
                <select class="ss_form_input" ng-model="SsCase.MLSStatus">
                    <option>NYS MLS</option>
                    <option>MLS LI</option>
                    <option>Brooklyn MLS</option>
                </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">MLS #</label>
                <input class="ss_form_input " ng-model="SsCase.ListMLS">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">List Price</label>

                <input class="ss_form_input currency_input" mask-money ng-model="SsCase.ListPrice">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Listing Date</label>
                <input class="ss_form_input" ss-date="" ng-model="SsCase.ListingDate">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Listing Expiry Date</label>
                <input class="ss_form_input " ss-date="" ng-model="SsCase.ListingExpireDate">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Valuation&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.ValueInfoes,'SsCase.ValueInfoes')" title="Add"></i></h4>
    <div class="ss_brder" ng-show="SsCase.ValueInfoes.length>0">
        <div class="ss_form_box clearfix ss_form_small_font">
            <div dx-data-grid="{
            columns: [
                {dataField: 'Method', caption: 'Type',
                 lookup: {
                    dataSource:[
                     {
                        name: 'AVM',
                        value: 'AVM'
                    },
                     {
                         name: 'Exterior Appraisal',
                         value: 'Exterior Appraisal'
                     },
                     {
                         name: 'Exterior BPO',
                         value: 'Exterior BPO'
                     },
                    {
                        name: 'Interior Appraisal',
                        value: 'Interior Appraisal'
                    },
                    {
                        name: 'Interior BPO',
                        value: 'Interior BPO'
                    }
                    ],
                    displayExpr: 'name' ,
                    valueExpr: 'value'}
                },
                {dataField: 'DateOfValue', caption: 'Date Completed', dataType: 'date'},
                {dataField: 'ExpiredOn', caption: 'Date Expires', dataType: 'date'},
                {dataField: 'BankValue', caption: 'Value'},
                {dataField: 'MNSP', caption: 'Min Net',format: 'currency'} 
            ],
            bindingOptions: { dataSource: 'SsCase.ValueInfoes' },
            editing: {
                editMode: 'row',
                editEnabled: true,
                removeEnabled: true
            
            
            
            }}">
            </div>
        </div>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title">Offer&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.ShortSaleOffers,'SsCase.ShortSaleOffers')" title="Add"></i></h4>
    <div class="ss_brder" ng-show="SsCase.ShortSaleOffers.length>0">
        <div class="ss_form_box clearfix ss_form_small_font">
            <div dx-data-grid="offerBindingOptions()">
            </div>
        </div>
    </div>
</div>

