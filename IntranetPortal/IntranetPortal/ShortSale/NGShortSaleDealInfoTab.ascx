<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleDealInfoTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleDealInfoTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
</div>

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
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.ReviewedDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Order Date</label>
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.ReportOrderDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Confirmation Date</label>
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.ConfirmationDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Received Date</label>
                <input class="ss_form_input disabled" ng-model="SsCase.BuyerTitle.ReceivedDate" ss-date>
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

<%-- 
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
--%>

<div class="ss_form" id="valuation_table_new">
    <h4 class="ss_form_title">Valuations <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.ValueInfoes,'SsCase.ValueInfoes', true)" title="Add"></i>
    </h4>
    <table class="table table-striped table-bordered table-responsive">
        <tr>
            <th>Details</th>
            <th></th>
        </tr>
        <tr class="icon_btn" ng-repeat="value in SsCase.ValueInfoes" id="value{{$index}}" ng-click="setVisiblePopup(SsCase.ValueInfoes[$index], true)">
            <td>
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Type</b>: {{value.Method}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Date Completed</b>: {{value.DateOfValue | date: 'M/d/yyyy'}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Value</b>: {{value.BankValue}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Date Expires</b>: {{value.ExpiredOn | date: 'M/d/yyyy'}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Agent Name</b>: {{value.AgentName}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Agent Phone</b>: {{value.AgentPhone}}</span>
                        </div>

                        
                    </div>
                </div>
            </td>
            <td>
                <i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="NGremoveArrayItem(SsCase.ValueInfoes, $index)" title="Delete"></i>
                <div dx-popup="{    
                                height: 550,
                                width: 600, 
                                title: 'Valuation '+($index+1),
                                dragEnabled: true,
                                showCloseButton: true,
                                bindingOptions:{ visible: 'SsCase.ValueInfoes['+$index+'].visiblePopup' }
                            }">
                    <div data-options="dxTemplate:{ name: 'content' }">
                        <form>
                            <div>
                                <label>Type</label>
                                <select class="form-control" ng-model="value.Method">
                                    <option></option>
                                    <option>AVM</option>
                                    <option>Exterior Appraisal</option>
                                    <option>Exterior BPO</option>
                                    <option>Interior Appraisal</option>
                                    <option>Interior BPO</option>
                                </select>
                            </div>
                            <div>
                                <label>Date Completed</label>
                                <input class="form-control" ng-model="value.DateOfValue" ss-date/>
                            </div>
                            <div>
                                <label>Value</label>
                                <input class="form-control" ng-model="value.BankValue" />
                            </div>
                            <div>
                                <label>Date Expires</label>
                                <input class="form-control" ng-model="value.ExpiredOn" ss-date/>
                            </div>
                            <div>
                                <label>Agent Name</label>
                                <input class="form-control" ng-model="value.AgentName" />
                            </div>
                            <div>
                                <label>Agent Phone</label>
                                <input class="form-control" ng-model="value.AgentPhone" />
                            </div>
                            
                        </form>
                        <br />
                        <button class="btn btn-primary pull-right" ng-click="setVisiblePopup(SsCase.ValueInfoes[$index], false)">Save</button>
                    </div>
                </div>
            </td>
    </table>
</div>

<%-- 
<div class="ss_form ">
    <h4 class="ss_form_title">Offer&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.ShortSaleOffers,'SsCase.ShortSaleOffers')" title="Add"></i></h4>
    <div class="ss_brder" ng-show="SsCase.ShortSaleOffers.length>0">
        <div class="ss_form_box clearfix ss_form_small_font">
            <div dx-data-grid="offerBindingOptions()">
            </div>
        </div>
    </div>
</div>
--%>

<div class="ss_form" id="offer_table_new">
    <h4 class="ss_form_title">Offers <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.ShortSaleOffers,'SsCase.ShortSaleOffers', true)" title="Add"></i>
    </h4>
    <table class="table table-striped table-bordered table-responsive">
        <tr>
            <th>Details</th>
            <th></th>
        </tr>
        <tr class="icon_btn" ng-repeat="offer in SsCase.ShortSaleOffers" id="offer{{$index}}" ng-click="setVisiblePopup(SsCase.ShortSaleOffers[$index], true)">
            <td>
                <div class="content">
                    <div class="row" style="margin: 0px">
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Type</b>: {{offer.OfferType}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Buying Entity</b>: {{SsCase.BuyerEntity.Entity}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Signor</b>: {{SsCase.BuyerEntity.Signor}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Date Corp Formed</b>: {{SsCase.BuyerEntity.DateOpened| date: 'M/d/yyyy'}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Date Of Contract</b>: {{offer.DateOfContract| date: 'M/d/yyyy'}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Offer Amount</b>: {{offer.OfferAmount| currency}}</span>
                        </div>
                        <div class="col-sm-4" style="padding: 0px">
                            <span><b>Date Submited</b>: {{offer.DateSubmited| date: 'M/d/yyyy'}}</span>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <i class="fa fa-times icon_btn tooltip-examples text-danger" ng-click="NGremoveArrayItem(SsCase.ShortSaleOffers, $index)" title="Delete"></i>
                <div dx-popup="{    
                                height: 600,
                                width: 600, 
                                title: 'Offers '+($index+1),
                                dragEnabled: false,
                                showCloseButton: true,
                                bindingOptions:{ visible: 'SsCase.ShortSaleOffers['+$index+'].visiblePopup' }
                            }">
                    <div data-options="dxTemplate:{ name: 'content' }">
                        <form>
                            <div>
                                <label>Type</label>
                                <select ng-model="offer.OfferType" class="form-control">
                                    <option></option>
                                    <option>Initial Offer</option>
                                    <option>Bank Counter</option>
                                    <option>Buyer Counter</option>
                                    <option>New Buyer Offer</option>
                                </select>
                            </div>
                            <div>
                                <label>Buying Entity</label>
                                <input class="form-control" ng-model="SsCase.BuyerEntity.Entity" disabled />
                            </div>
                            <div>
                                <label>Signor</label>
                                <input class="form-control" ng-model="SsCase.BuyerEntity.Signor" disabled ss-date />
                            </div>
                            <div>
                                <label>Date Corp Formed</label>
                                <input class="form-control" ng-model="SsCase.BuyerEntity.DateOpened" disabled />
                            </div>
                            <div>
                                <label>Date Of Contract</label>
                                <input class="form-control" ss-date ng-model="offer.DateOfContract" />
                            </div>
                            <div>
                                <label>Offer Amount</label>
                                <input class="form-control" ng-model="offer.OfferAmount" mask-money />
                            </div>
                            <div>
                                <label>Date Submited</label>
                                <input class="form-control" ss-date ng-model="offer.DateSubmited" />
                            </div>
                        </form>
                        <br />
                        <button class="btn btn-primary pull-right" ng-click="setVisiblePopup(SsCase.ShortSaleOffers[$index], false)">Save</button>
                    </div>
                </div>
            </td>
    </table>
</div>
