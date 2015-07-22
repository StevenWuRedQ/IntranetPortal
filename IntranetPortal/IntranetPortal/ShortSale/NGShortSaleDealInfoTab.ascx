﻿<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleDealInfoTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleDealInfoTab" %>
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
    <!-- Open Document Detail -->
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Title</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Company</label>
            <input class="ss_form_input disabled" ng-model="SsCase.DealInfo.TitleCompany">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Title #</label>
            <input class="ss_form_input disabled" ng-model="SsCase.DealInfo.TitleNO">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Reviewed</label>
            <input class="ss_form_input disabled" ss-date ng-model="SsCase.DealInfo.ReviewedDate">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Order Date</label>
            <input class="ss_form_input disabled" ss-date ng-model="SsCase.DealInfo.OrderDate">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Confirmation Date</label>
            <input class="ss_form_input disabled" ss-date ng-model="SsCase.DealInfo.ConfirmationDate">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Received Date</label>
            <input class="ss_form_input disabled" ss-date ng-model="SsCase.DealInfo.ReceivedDate">
        </li>


    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Listing Info</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">MLS</label>
            <input class="ss_form_input " ng-model="SsCase.DealInfo.ListMLS">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">MLS #</label>
            <input class="ss_form_input " ng-model="SsCase.DealInfo.ListMLSNO">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">List Price</label>
            <input class="ss_form_input currency_input" ng-model="SsCase.DealInfo.ListPrice">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Listing Date</label>
            <input class="ss_form_input" ss-date="" ng-model="SsCase.DealInfo.ListingDate">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Listing Expiry Date</label>
            <input class="ss_form_input " ss-date="" ng-model="SsCase.DealInfo.ListingExpireDate">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Valuation</h4>
    <div class="ss_form_box clearfix ss_form_small_font">
        <div dx-data-grid="{
             dataSource: SsCase.DealInfo.Valuations,
            columns: [
                {dataField: 'Method',
                 caption: 'Type',
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
                    valueExpr: 'value'
                }},
                {dataField: 'DateOfValue',
                caption: 'Date Completed',
                dataType: 'date'},
                {dataField: 'ExpiredOn',
                caption: 'Date Expires',
                dataType: 'date'},
                {dataField: 'BankValue',
                caption: 'Value'},
                {dataField: 'MNSP',
                caption: 'Min Net'},
                
            ],
             editing: {
                editMode: 'row',
                editEnabled: true,
                removeEnabled: true,
                insertEnabled: true
            }, 
             }">
        </div>
    </div>

</div>

<div class="ss_form ">
    <h4 class="ss_form_title">Offer</h4>
    <div class="ss_form_box clearfix ss_form_small_font">
        <div dx-data-grid="{
            dataSource: SsCase.DealInfo.Offers,
            columns: [
            { 
                dataField: 'Type',
                caption: 'Type',
                lookup: {
                    dataSource:[

                    {
                        name: 'Initial Offer',
                        value: 'Initial Offer'
                    },
                     {
                         name: 'Bank Counter',
                         value: 'Bank Counter'
                     },
                     {
                         name: 'Buyer Counter',
                         value: 'Buyer Counter'
                     },
                    {
                        name: 'New Buyer Offer',
                        value: 'New Buyer Offer'
                    }
                    ],
                    displayExpr: 'name' ,
                    valueExpr: 'value'
                }
                
            },
            {
                dataField: 'BuyingEntity',
                allowEditing: false,
            },
            {
                dataField: 'Signor',
                allowEditing: false
            },
            {
                dataField: 'DateCorpFormed',
                allowEditing: false,
            },
            {   
                dataField: 'DateOfContract',
                dataType: 'date'
            },
            {
                dataField: 'OfferAmount',
            },
            {
                dataField: 'DateSubmitted',
                dataType: 'date'
            }],
            editing: {
                editMode: 'row',
                editEnabled: true,
                removeEnabled: true,
                insertEnabled: true
            }, 
        }">
        </div>
    </div>
</div>
