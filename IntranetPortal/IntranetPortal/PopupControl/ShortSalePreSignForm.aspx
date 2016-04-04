<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSalePreSignForm.aspx.vb" Inherits="IntranetPortal.ShortSalePreSignForm" %>

<%@ Register Src="~/ShortSale/NGShortSaleHomewonerTab.ascx" TagPrefix="uc1" TagName="NGShortSaleHomewonerTab" %>
<%@ Register Src="~/ShortSale/NGShortSaleMortgageTab.ascx" TagPrefix="uc1" TagName="NGShortSaleMortgageTab" %>
<%@ Register Src="~/PopupControl/LeadSearchSummery.ascx" TagPrefix="uc1" TagName="LeadSearchSummery" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fix-add-btn i {
            margin-top: 10px;
            margin-left: 10px;
        }

        .sub-form-title {
            margin-top: 20px;
            margin-bottom: -20px;
        }

        .wizard-title {
            text-align: center;
        }

        .wizard-content {
            min-height: 400px;
        }

        .oneline {
            width: 100% !important;
        }

        /*Theming options - change and everything updates*/
        /*don't use more decimals, as it makes browser round errors more likely, make heights unmatching
-also watch using decimals at all at low wizardSize font sizes!*/
        .wizardbar {
            font-size: 18px;
            line-height: 1;
            display: inline-block;
            margin: 20px 0;
        }
        /*base item styles*/
        .wizardbar-item {
            display: inline-block;
            padding: 0.5em 0.8em;
            padding-left: 1.8em;
            text-decoration: none;
            transition: all .15s;
            /*default styles*/
            background-color: #76a9dd;
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            text-shadow: 1px 1px rgba(0, 0, 0, 0.2);
            position: relative;
            margin-right: 2px;
        }
            /*arrow styles*/
            .wizardbar-item:before,
            .wizardbar-item:after {
                content: "";
                height: 0;
                width: 0;
                border-width: 1em 0 1em 1em;
                border-style: solid;
                transition: all .15s;
                position: absolute;
                left: 100%;
                top: 0;
            }
            /*arrow overlapping left side of item*/
            .wizardbar-item:before {
                border-color: transparent transparent transparent white;
                left: 0;
            }
            /*arrow pointing out from right side of items*/
            .wizardbar-item:after {
                border-color: transparent transparent transparent #76a9dd;
                z-index: 1;
            }
        /*current item styles*/
        .current.wizardbar-item {
            background-color: #205081;
            color: white;
            cursor: default;
        }

            .current.wizardbar-item:after {
                border-color: transparent transparent transparent #205081;
            }
        /*hover styles*/
        .wizardbar-item:not(.current):hover {
            background-color: #3983ce;
            cursor: default;
            text-decoration: none;
        }

            .wizardbar-item:not(.current):hover:after {
                border-color: transparent transparent transparent #3983ce;
            }
        /*remove arrows from beginning and end*/
        .wizardbar-item:first-of-type:before,
        .wizardbar-item:last-of-type:after {
            border-color: transparent !important;
        }
        /*no inset arrow for first item*/
        .wizardbar-item:first-of-type {
            border-radius: 0.25em 0 0 0.25em;
            padding-left: 1.3em;
        }
        /*no protruding arrow for last item*/
        .wizardbar-item:last-of-type {
            border-radius: 0 0.25em 0.25em 0;
            padding-right: 1.3em;
        }

        .view-animate {
            min-height: 500px;
        }

        #todo-list {
            width: 500px;
            margin: 0 auto 30px auto;
            padding: 50px;
            background: white;
            position: relative;
            /*box-shadow*/
            -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
            -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
            /*border-radius*/
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <input type="hidden" id="BBLE" value="<%= Request.QueryString("BBLE")%>" />
    <div style="padding: 20px" ng-controller="shortSalePreSignCtrl">
        <div class="container">
            <div>
                <div class="wizardbar">
                    <a class="wizardbar-item {{step==$index+1?'current':'' }}" href="#" ng-repeat="s in (filteredSteps = (steps|wizardFilter:DeadType))">{{s.caption?s.caption:s.title}} 
                    </a>
                </div>
            </div>
            <div style="text-align: center">
                <h2>Property Address : {{SSpreSign.PropertyAddress}}</h2>
            </div>
            <div style="max-width: 720px; margin: 0 auto">
                <div ng-show="currentStep().title=='New Offer'" class="view-animate">
                    <h3 class="wizard-title">New Offer</h3>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="input-group">
                                <label>Select Offer type</label>
                                <select class="form-control">
                                    <option></option>
                                    <option selected>Short Sale</option>
                                    <option>Straight Sale</option>
                                    <option>Other</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div ng-show="currentStep().title=='Search Info'" class="view-animate">
                    <h3 class="wizard-title">Check Search Information</h2>

                    <div>
                        <div style="padding: 10px" ng-controller="LeadTaxSearchCtrl">
                            <uc1:LeadSearchSummery runat="server" ID="LeadSearchSummery" />
                        </div>
                    </div>
                </div>
                <%--Pre Sign or short sale information--%>
                <div ng-show="currentStep().title=='Pre Sign'" class="view-animate">
                    <h3 class="wizard-title">Short Sale Information</h3>
                    <div ng-controller="ShortSaleCtrl" id="ShortSaleCtrl">
                        <div>
                            <h4 class="ss_form_title ">Borrowers</h4>
                            <uc1:NGShortSaleHomewonerTab runat="server" ID="NGShortSaleHomewonerTab" />
                        </div>

                        <div>
                            <h4 class="ss_form_title">Mortgage info</h4>
                            <uc1:NGShortSaleMortgageTab runat="server" ID="NGShortSaleMortgageTab" />
                        </div>
                    </div>

                    <%--<div>
                        <h4 class="ss_form_title ">Borrowers</h4>
                        <div id="borrwerGrid" dx-data-grid="borrwerGrid"></div>
                    </div>
                    <div class="ss_form">
                        <div id=""></div>
                    </div>--%>
                </div>
                <%--select team and assign crops--%>
                <div class="view-animate" ng-show="currentStep().title=='Assign Crops'">
                    <h3 class="wizard-title">Select team and Assgin crops</h3>
                    <div class="ss_form">
                        <h4 class="ss_form_title ">Assign </h4>
                        <div class="ss_border">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Team Name</label>
                                    <select class="ss_form_input" ng-model="SSpreSign.assignCrop.Name" >
                                        <option></option>
                                        <option ng-repeat="n in CorpTeam"></option>
                                   </select>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Is wells fargo</label>
                                    <pt-radio name="AssignCropWellFrago" model="SSpreSign.assignCrop.isWellsFargo"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">&nbsp;</label>
                                    <input type="button" value="Assign Crop" class="rand-button rand-button-blue rand-button-pad" ng-click="assginCropClick()">
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div ng-show="currentStep().title=='Documents Required'" class="view-animate">
                    <h3 class="wizard-title">{{currentStep().title}}</h3>
                    <div id="todo-list">
                        <div class="dx-fieldset">
                            <div class="dx-field">
                                <div class="dx-field-label">Contract</div>
                                <div class="dx-field-value">
                                    <div dx-check-box="{ bindingOptions: { value: 'DeadType.Contract' }}"></div>
                                </div>
                            </div>
                            <div class="dx-field">
                                <div class="dx-field-label">Memo</div>
                                <div class="dx-field-value">
                                    <div dx-check-box="{ bindingOptions: { value: 'DeadType.Memo' }}"></div>
                                </div>
                            </div>
                            <div class="dx-field">
                                <div class="dx-field-label">Deed</div>
                                <div class="dx-field-value">
                                    <div dx-check-box="{ bindingOptions: { value: 'DeadType.Deed' }}"></div>
                                </div>
                            </div>
                            <div class="dx-field">
                                <div class="dx-field-label">Correction Deed</div>
                                <div class="dx-field-value">
                                    <div dx-check-box="{ bindingOptions: { value: 'DeadType.CorrectionDeed' }}"></div>
                                </div>
                            </div>
                            <div class="dx-field">
                                <div class="dx-field-label">POA</div>
                                <div class="dx-field-value">
                                    <div dx-check-box="{ bindingOptions: { value: 'DeadType.POA' }}"></div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <%--Deal Sheet--%>
                <div ng-show="currentStep().title=='Deal Sheet'" class="view-animate">
                    <h3 class="wizard-title">{{currentStep().title}}</h3>
                    <div>
                    </div>
                </div>
                <%--Contract || Memo--%>
                <div ng-show="currentStep().title=='Contract'" class="view-animate">
                    <div>
                        <div>

                            <%-- <div class="sub-form-title">
                                <h3 class="wizard-title"><span ng-if="DeadType.Contract">Contract </span> <span ng-if="DeadType.Contract&&DeadType.Memo">&</span> <span ng-if="DeadType.Memo">Memo</span>  </h3>
                            </div>--%>
                            <uib-tabset class="tab-switch">
                                <uib-tab ng-repeat="d in SSpreSign.DealSheet.ContractOrMemo.Sellers" active="d.active" disable="d.disabled">
                                    <tab-heading>Seller {{$index+1}} </tab-heading>  
                                    <div class="text-right" ng-show="SSpreSign.DealSheet.ContractOrMemo.Sellers.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close"  ng-click="arrayRemove(SSpreSign.DealSheet.ContractOrMemo.Sellers, $index)" title="Delete"></i></div>
                                     <div class="ss_border" style="border-top-color: transparent">
                                         <div >
                                            <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                                            <div >
                                                <ul class="ss_form_box clearfix">
                                                    <li class="ss_form_item">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Address</label><input class="ss_form_input" ng-model="d.Address" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Attorney</label><input class="ss_form_input" ng-model="d.sellerAttorney" /></li>
                                                </ul>
                                            </div>
                                        </div>
                                     </div>
                                </uib-tab>
                                <span class="fix-add-btn">
                                    <pt-add ng-click="ensurePush('SSpreSign.DealSheet.ContractOrMemo.Sellers')" style="font-size:18px"></pt-add>
                                </span>
                                
                            </uib-tabset>

                            <div class="ss_form">
                                <h4 class="ss_form_title">Buyer </h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer  Name</label>
                                            <input class="ss_form_input" ng-model="default.buyerName" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer  Address</label><input class="ss_form_input" ng-model="default.buyerAddress" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer Attorney</label><input class="ss_form_input" ng-model="default.buyerAttorney" /></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="ss_form">
                                <uib-tabset class="tab-switch">
                                <uib-tab ng-repeat="buyer in SSpreSign.DealSheet.ContractOrMemo.Buyers" active="buyer.active" disable="buyer.disabled">
                                    <tab-heading>Buyer {{$index+1}} </tab-heading>  
                                    <div class="text-right" ng-show="SSpreSign.DealSheet.ContractOrMemo.Buyers.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close"  ng-click="arrayRemove(SSpreSign.DealSheet.ContractOrMemo.Buyers, $index)" title="Delete"></i></div>
                                     <div class="ss_border" style="border-top-color: transparent">
                                         <div >
                                            <h4 class="ss_form_title">Buyer {{$index+1}} </h4>
                                            <div>
                                                <ul class="ss_form_box clearfix">
                                                    <li class="ss_form_item">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} Name</label><input class="ss_form_input" ng-model="buyer.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} Address</label><input class="ss_form_input" ng-model="buyer.Address" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} Attorney</label><input class="ss_form_input" ng-model="buyer.Attorney" /></li>
                                                </ul>
                                            </div>
                                        </div>
                                     </div>
                                </uib-tab>
                                <span class="fix-add-btn">
                                    <pt-add ng-click="ensurePush('SSpreSign.DealSheet.ContractOrMemo.Buyers')" style="font-size:18px"></pt-add>
                                </span>
                            </uib-tabset>

                                <div class="ss_form">
                                    <h4 class="ss_form_title ">Bill Info </h4>
                                    <div class="ss_border">
                                        <ul class="ss_form_box clearfix">
                                            <li class="ss_form_item ">
                                                <label class="ss_form_input_title">Contract Price</label><input class="ss_form_input" ng-model="default.contractPrice" money-mask /></li>
                                            <li class="ss_form_item ">
                                                <label class="ss_form_input_title">Down Payment</label><input class="ss_form_input" ng-model="default.downPayment" money-mask /></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <%--Deed--%>
                <div ng-show="currentStep().title=='Deed'" class="view-animate">
                    <div>
                        <%--Deed--%>
                        <div>
                            <%--<div class="sub-form-title">
                                <h3 class="wizard-title">Deed </h3>
                            </div>--%>
                            <uib-tabset class="tab-switch">
                                <uib-tab ng-repeat="d in SSpreSign.DealSheet.Deed.Sellers" active="d.active" disable="d.disabled">
                                    <tab-heading>Seller {{$index+1}} </tab-heading>  
                                    <div class="text-right" ng-show="SSpreSign.DealSheet.Deed.Sellers.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close"  ng-click="arrayRemove(SSpreSign.DealSheet.Deed.Sellers, $index)" title="Delete"></i></div>
                                     <div class="ss_border" style="border-top-color: transparent">
                                         <div >
                                            <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                                            <div >
                                                <ul class="ss_form_box clearfix">
                                                    <li class="ss_form_item">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} SSN</label><input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999" /></li>
                                                    
                                                </ul>
                                            </div>
                                        </div>
                                     </div>
                                </uib-tab>
                                <span class="fix-add-btn">
                                    <pt-add ng-click="ensurePush('SSpreSign.DealSheet.Deed.Sellers')" style="font-size:18px"></pt-add>
                                </span>
                                
                            </uib-tabset>

                            <%-- <div class="ss_form">
                                <h4 class="ss_form_title ">Seller 1</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Seller Name</label><input class="ss_form_input" ng-model="default.Name" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Seller SSN</label><input class="ss_form_input" ng-model="default.sellerSsn" mask="999-99-9999"/></li>
                                    </ul>
                                </div>
                            </div>--%>

                            <div class="ss_form">
                                <h4 class="ss_form_title ">Buyer</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer Name</label><input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.Buyer.Name" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer SSN</label><input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.Buyer.SSN" mask="999-99-9999" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Buyer Address</label><input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.Buyer.Addr" /></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title ">Property Address </h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item  oneline">
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.PropertyAddress" /></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- CorrectionDeed --%>
                <div ng-show="currentStep().title=='CorrectionDeed'" class="view-animate">
                    <div>
                        <%-- CorrectionDeed --%>
                        <div>
                            <%-- <div class="sub-form-title">
                                <h3 class="wizard-title"><span ng-if="DeadType.Contract">Correction Deed  </h3>
                            </div>--%>
                            <div class="ss_form">
                                <uib-tabset class="tab-switch">
                                <uib-tab ng-repeat="d in SSpreSign.DealSheet.CorrectionDeed.Sellers" active="d.active" disable="d.disabled">
                                    <tab-heading>Seller {{$index+1}} </tab-heading>  
                                    <div class="text-right" ng-show="SSpreSign.DealSheet.CorrectionDeed.Sellers.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close"  ng-click="arrayRemove(SSpreSign.DealSheet.CorrectionDeed.Sellers, $index)" title="Delete"></i></div>
                                     <div class="ss_border" style="border-top-color: transparent">
                                         <div >
                                            <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                                            <div >
                                                <ul class="ss_form_box clearfix">
                                                    <li class="ss_form_item">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} SSN</label><input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999"/></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Seller {{$index+1}} Address</label><input class="ss_form_input" ng-model="d.Address" /></li>
                                                </ul>
                                            </div>
                                        </div>
                                     </div>
                                </uib-tab>
                                <span class="fix-add-btn">
                                    <pt-add ng-click="ensurePush('SSpreSign.DealSheet.CorrectionDeed.Sellers')" style="font-size:18px"></pt-add>
                                </span>
                                
                            </uib-tabset>
                            </div>
                            <div class="ss_form">

                                <uib-tabset class="tab-switch">
                                <uib-tab ng-repeat="d in SSpreSign.DealSheet.CorrectionDeed.Buyers" active="d.active" disable="d.disabled">
                                    <tab-heading>Buyer {{$index+1}} </tab-heading>  
                                    <div class="text-right" ng-show="SSpreSign.DealSheet.CorrectionDeed.Buyers.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close"  ng-click="arrayRemove(SSpreSign.DealSheet.CorrectionDeed.Buyers, $index)" title="Delete"></i></div>
                                     <div class="ss_border" style="border-top-color: transparent">
                                         <div >
                                            <h4 class="ss_form_title">Buyer {{$index+1}} </h4>
                                            <div >
                                                <ul class="ss_form_box clearfix">
                                                    <li class="ss_form_item">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} SSN</label><input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999"/></li>
                                                     <li class="ss_form_item ">
                                                        <label class="ss_form_input_title">Buyer {{$index+1}} Address</label><input class="ss_form_input" ng-model="d.Address" /></li>
                                                </ul>
                                            </div>
                                        </div>
                                     </div>
                                </uib-tab>
                                <span class="fix-add-btn">
                                    <pt-add ng-click="ensurePush('SSpreSign.DealSheet.CorrectionDeed.Buyers')" style="font-size:18px"></pt-add>
                                </span>
                                
                            </uib-tabset>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title ">Property Address </h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item  oneline">
                                            <input class="ss_form_input" ng-model="SSpreSign.PropertyAddress " />
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--POA--%>
                <div ng-show="currentStep().title=='POA'" class="view-animate">
                    <div>
                        <div>
                            <%--<div class="sub-form-title">
                                <h3 class="wizard-title">POA  </h3>
                            </div>--%>

                            <div class="ss_form">
                                <h4 class="ss_form_title ">Giving POA</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Name</label><input class="ss_form_input" ng-model="default.GivingPOA.name" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Address</label><input class="ss_form_input" ng-model="default.GivingPOA.address" /></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title ">Receiving POA</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Name</label><input class="ss_form_input" ng-model="default.ReceivingPOA.name" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title">Address</label><input class="ss_form_input" ng-model="default.ReceivingPOA.address" /></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-show="currentStep().title=='Finish'" class="view-animate">
                    <h3 class="wizard-title">Finish</h2>
                    <div>
                        <div class="well">
                            Congratulation! you are in the last step please click button to download document! 
                        </div>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" ng-show="step>1" ng-click="PrevStep()">< Prev</button>
                <button type="button" class="btn btn-default" ng-click="RequestPreSign()" ng-show="step==MaxStep()">Generate document</button>
                <button type="button" class="btn btn-default" ng-show="step<MaxStep()" ng-click="NextStep()">Next ></button>
            </div>
        </div>

    </div>
    <%--help scrpt for this page--%>
    <script>
        ScopeHeler =
            {
                getShortSaleScope: function () {

                    return angular.element(document.getElementById('ShortSaleCtrl')).scope();
                }

            }
    </script>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('shortSalePreSignCtrl', function ($scope, ptCom, $http) {
            $scope.SSpreSign = {
                DealSheet: {
                    ContractOrMemo: { Sellers: [{}], Buyers: [{}] },
                    Deed: { Sellers: [{}] },
                    CorrectionDeed: { Sellers: [] }
                }
            };
            $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); };
            $scope.arrayRemove = ptCom.arrayRemove;
            $scope.NGAddArraryItem = ptCom.AddArraryItem;
            $scope.shortSaleInfoNext = function () {
                var self = this;
                var ss = ScopeHeler.getShortSaleScope();
                var _sellers = ss.SsCase.PropertyInfo.Owners;
                var _sellers = _.map(_sellers, function (o) {
                    o.Name = ss.formatName(o.FirstName, o.MiddleName, o.LastName);
                    o.Address = ss.formatAddr(o.MailNumber, o.MailStreetName, o.MailApt, o.MailCity, o.MailState, o.MailZip);
                    o.PropertyAddress = $scope.SSpreSign.PropertyAddress;
                    return o
                });
                var _dealSheet = $scope.SSpreSign.DealSheet;
                _dealSheet.ContractOrMemo.Sellers = $.extend(true, [], _sellers);
                _dealSheet.Deed.Sellers = $.extend(true, [], _sellers);
                _dealSheet.CorrectionDeed.Sellers = $.extend(true, {}, _sellers);
                var ssCtrl = $scope.SSCtrl;
                return true;
            }
            $scope.assginCropClick = function()
            {
                //$scope.SSpreSign.
            }
            $http.get('/api/CorporationEntities/Teams').success(function(data){
                $scope.CorpTeam = data;
            })
            $scope.steps = [
              { title: "New Offer" },
              { title: "Search Info" },
              { title: "Pre Sign", caption: 'SS Info', next: $scope.shortSaleInfoNext },
              { title: "Assign Crops", next: $scope.shortSaleInfoNext },
              { title: "Documents Required", caption: 'Doc Required', },
              //{ title: "Deal Sheet" },
              { title: 'Contract', caption: 'Contract Or Memo', sheet: 'Contract', },
              { title: 'Deed', sheet: 'Deed' },
              { title: 'CorrectionDeed', caption: 'Correction Deed', sheet: 'CorrectionDeed' },
              { title: 'POA', sheet: 'POA' },
              { title: "Finish" },
            ];

            $scope.DeadType = {
                Contract: true,
            };
            var BBLE = $("#BBLE").val();
            if (BBLE) {
                $http.get('/api/Leads/LeadsInfo/' + BBLE).success(function (data) {
                    $scope.SSpreSign.PropertyAddress = data.PropertyAddress;
                })
            }

            $scope.step = 1
            $scope.filteredSteps = [];
            $scope.MaxStep = function () {
                return $scope.filteredSteps.length;
            }
            $scope.currentStep = function () {
                return $scope.steps[$scope.step - 1];
            }
            $scope.NextStep = function () {
                var cStep = $scope.currentStep();
                if (cStep.next) {
                    if (cStep.next()) {
                        $scope.step++;
                    }
                } else {
                    $scope.step++;
                }


            }
            $scope.PrevStep = function () {
                $scope.step--;
            }
            $scope.borrwerGrid = {
                dataSource: [{ Name: "Borrower 1", "Address": "123 Main ST, New York NY 10001", "SSN": "123456789", "Phone": "212 123456", "Email": "email@gmail.com", "MailAddress": "123 Main ST, New York NY 10001" }],
                columns: ['Name', 'Address', 'SSN', 'Email', 'Phone', {
                    dataField: "Type",
                    lookup: {
                        dataSource: ["Borrower", "Co-Borrower"],
                    }
                }, 'MailAddress'],
                editing: {
                    editEnabled: true,
                    insertEnabled: true,
                    removeEnabled: true
                }
            }
        })
        portalApp.filter('wizardFilter', function () {
            return function (items, sheetFilter) {
                var filtered = [];
                angular.forEach(items, function (item) {
                    if (typeof item.sheet != 'undefined') {
                        if (!sheetFilter) {
                            console.error("there are no filter please check filter")
                        }
                        for (key in sheetFilter) {
                            if (sheetFilter[key] && item.sheet == key) {
                                filtered.push(item)
                            }
                        }
                    } else {
                        filtered.push(item);
                    }

                });
                return filtered;
            };
        });
    </script>
</asp:Content>
