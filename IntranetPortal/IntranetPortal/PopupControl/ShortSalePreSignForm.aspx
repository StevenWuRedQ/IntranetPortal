<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="ShortSalePreSignForm.aspx.vb" Inherits="IntranetPortal.ShortSalePreSignForm" %>

<%@ Register Src="~/ShortSale/NGShortSaleHomewonerTab.ascx" TagPrefix="uc1" TagName="NGShortSaleHomewonerTab" %>
<%@ Register Src="~/ShortSale/NGShortSaleMortgageTab.ascx" TagPrefix="uc1" TagName="NGShortSaleMortgageTab" %>
<%@ Register Src="~/PopupControl/LeadSearchSummery.ascx" TagPrefix="uc1" TagName="LeadSearchSummery" %>
<%@ Register Src="~/ShortSale/ShortPreSignControl.ascx" TagPrefix="uc1" TagName="ShortPreSignControl" %>

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
        <div class="container" ng-hide="QueryUrl.model!='List'">
            <div>
                <h2>New Offer Request List</h2>
                <div dx-data-grid="newOfferGridOpt"></div>
            </div>            
        </div>
        <div class="container" ng-hide="QueryUrl.model=='List'">
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
                                <label ng-class="{ss_warning:!SSpreSign.Type}" data-message="Please Select Offer type">Select Offer type</label>
                                <select class="form-control" ng-model="SSpreSign.Type">
                                    <option selected>Short Sale</option>
                                    <option>Straight Sale</option>
                                    <option>Other</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div ng-show="currentStep().title=='Search Info'" class="view-animate" id="preSignSearchInfo">
                    <h3 class="wizard-title">Check Search Information</h3>

                    <div>
                        <div style="padding: 10px" ng-controller="LeadTaxSearchCtrl" id="LeadTaxSearchCtrl">
                            <h4 ng-show="!DocSearch||DocSearch.Status!=1" ng-class="{ss_warning:!DocSearch||DocSearch.Status!=1}"
                                data-message="Document search not completed yet please contact document search agent completed search">Document search not completed yet please contact document search agent completed search</h4>
                            <uc1:LeadSearchSummery runat="server" ID="LeadSearchSummery" />
                        </div>
                    </div>
                </div>
                <%--Pre Sign or short sale information--%>
                <div ng-show="currentStep().title=='Pre Sign'" class="view-animate">
                    <h3 class="wizard-title">Short Sale Information</h3>
                    <div ng-controller="ShortSaleCtrl" id="ShortSaleCtrl">

                        <uc1:ShortPreSignControl runat="server" ID="ShortPreSignControl" />

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
                <div class="view-animate" ng-show="currentStep().title=='Assign Crops'" id="preSignAssignCrops">
                    <h3 class="wizard-title">Select team and Assign corp</h3>
                    <div class="ss_form">
                        <h4 class="ss_form_title ">Assign </h4>
                        <div class="ss_border" id="assignBtnForm">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.assignCrop.Name}" data-message="Please select team!">Team Name</label>
                                    <select class="ss_form_input" ng-model="SSpreSign.assignCrop.Name">

                                        <option ng-repeat="n in CorpTeam track by $index">{{n}}</option>
                                    </select>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">Is wells fargo</label>
                                    <pt-radio name="AssignCropWellFrago" model="SSpreSign.assignCrop.isWellsFargo"></pt-radio>
                                </li>
                                <li class="ss_form_item " ng-show="SSpreSign.assignCrop.isWellsFargo">
                                    <label class="ss_form_input_title " ng-class="{ss_warning:SSpreSign.assignCrop.isWellsFargo && !SSpreSign.assignCrop.Signer}" data-message="If Servicer is Wells Fargo Please select signer">signer </label>
                                    <select class="ss_form_input" ng-model="SSpreSign.assignCrop.Signer">
                                        <option ng-repeat="s in  SSpreSign.assignCrop.signers track by $index">{{s}}</option>
                                    </select>
                                </li>


                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title">&nbsp;</label>
                                    <input type="button" value="Assign Crop" class="rand-button rand-button-blue rand-button-pad" ng-click="assginCropClick()" ng-show="!SSpreSign.assignCrop.Crop">
                                </li>

                            </ul>
                        </div>
                        <div class="ss_form" ng-show="SSpreSign.assignCrop.Crop" ng-class="{ss_warning:!SSpreSign.assignCrop.Crop}" data-message="Please assign Crop to continue!">
                            <div class="alert alert-success" role="alert"><strong>Well done!</strong> You successfully assign <strong>{{SSpreSign.assignCrop.Crop}}</strong> to <strong>{{SSpreSign.PropertyAddress}}</strong> . </div>
                        </div>
                    </div>
                </div>
                <%--documents required--%>

                <div ng-show="currentStep().title=='Documents Required'" class="view-animate">
                    <h3 class="wizard-title" ng-class="{ss_warning:!DocRequiredNext(true)}">{{currentStep().title}}</h3>
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
                <%--Contract or Memo--%>
                <div ng-show="currentStep().title=='Contract'" class="view-animate" id="preSignContract">
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
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Name}" data-message="Please fill Seller {{$index+1}} Name">Seller {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                                                    
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.sellerAttorney}" data-message="Please fill Seller {{$index+1}} Attorney">Seller {{$index+1}} Attorney</label>
                                                        <%--<input class="ss_form_input" ng-model="d.sellerAttorney" />--%>
                                                        <input type="text" class="ss_form_input" ng-model="d.sellerAttorney" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="d.sellerAttorneyObj=$item">
                                                    </li>
                                                    <li class="ss_form_item ss_form_item_line" >
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Address}" data-message="Please fill Seller {{$index+1}} Address">Seller {{$index+1}} Address</label>
                                                        <input class="ss_form_input" ng-model="d.Address" />
                                                    </li>
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
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ContractOrMemo.Buyer.CorpName}" data-message="Please fill Buyer Name">Buyer Name</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ContractOrMemo.Buyer.CorpName" /></li>

                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ContractOrMemo.Buyer.buyerAttorney}" data-message="Please fill Buyer Attorney">Buyer Attorney</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ContractOrMemo.Buyer.buyerAttorney" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="SSpreSign.DealSheet.ContractOrMemo.Buyer.buyerAttorneyObj=$item" />

                                        </li>
                                        <li class="ss_form_item " style="width: 96%">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ContractOrMemo.Buyer.Address}" data-message="Please fill Buyer Address">Buyer Address</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ContractOrMemo.Buyer.Address" />
                                        </li>
                                    </ul>
                                </div>
                            </div>

                            <%--<div class="ss_form">
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

                               
                            </div>--%>
                            <div class="ss_form">
                                <h4 class="ss_form_title ">Bill Info </h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ContractOrMemo.contractPrice}" data-message="Please fill Contract Price">Contract Price</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ContractOrMemo.contractPrice" money-mask />
                                        </li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ContractOrMemo.downPayment}" data-message="Please fill Down Payment">Down Payment</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ContractOrMemo.downPayment" money-mask />
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--Deed--%>
                <div ng-show="currentStep().title=='Deed'" class="view-animate" id="preAssignDeed">
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
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Name}" data-message="Please fill Seller {{$index+1}} Name!" >Seller {{$index+1}} Name</label>
                                                            <input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title"  ng-class="{ss_warning:!d.SSN}" data-message="Please fill Seller {{$index+1}} SSN!">Seller {{$index+1}} SSN</label>
                                                        <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999" /></li>
                                                    
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
                                <h4 class="ss_form_title " <%--ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.EntityId}"--%> ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.Buyer.CorpName}" data-message="Can not get DEED Crop this time!">Buyer</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.Buyer.CorpName}" data-message="Please fill Buyer Name!">Buyer Name</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.Buyer.CorpName" /></li>
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.Buyer.EIN}" data-message="Please fill Buyer SSN/EIN!">Buyer SSN/EIN</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.Buyer.EIN" />
                                        </li>
                                        <li class="ss_form_item ss_form_item_line">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.Buyer.Address}" data-message="Please fill Buyer Address!">Buyer Address</label>
                                            <input class="ss_form_input " ng-model="SSpreSign.DealSheet.Deed.Buyer.Address" style="width: 96%" />
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title " ng-class="{ss_warning:!SSpreSign.DealSheet.Deed.PropertyAddress}" data-message="Please fill Property Address!">Property Address </h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item  oneline">
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.Deed.PropertyAddress" />
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- CorrectionDeed --%>
                <div ng-show="currentStep().title=='CorrectionDeed'" class="view-animate" id="preAssignCorrectionDeed">
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
                                                    <li class="ss_form_item" ng-class="{ss_warning:!d.Name}" data-message="Please fill Seller {{$index+1}} Name!">
                                                        <label class="ss_form_input_title" >Seller {{$index+1}} Name</label>
                                                        <input class="ss_form_input" ng-model="d.Name" />
                                                    </li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.SSN}" data-message="Please fill Seller {{$index+1}} SSN!">Seller {{$index+1}} SSN</label>
                                                        <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999"/>
                                                    </li>
                                                    <li class="ss_form_item ss_form_item_line">
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Address}" data-message="Please fill Seller {{$index+1}} Address!">Seller {{$index+1}} Address</label>
                                                        <input class="ss_form_input" ng-model="d.Address" style="width:96%"/>
                                                    </li>
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
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Name}" data-message="Please fill Buyer {{$index+1}} Address!">Buyer {{$index+1}} Name</label>
                                                        <input class="ss_form_input" ng-model="d.Name" /></li>
                                                    <li class="ss_form_item ">
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.SSN}" data-message="Please fill Buyer {{$index+1}} SSN!">Buyer {{$index+1}} SSN</label>
                                                        <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999"/></li>
                                                     <li class="ss_form_item ss_form_item_line">
                                                        <label class="ss_form_input_title" ng-class="{ss_warning:!d.Address}" data-message="Please fill Buyer {{$index+1}} Address!">Buyer {{$index+1}} Address</label>
                                                        <input class="ss_form_input" ng-model="d.Address"  style="width:96%"/>
                                                     </li>
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
                                        <li class="ss_form_item  oneline" ng-class="{ss_warning:!SSpreSign.DealSheet.CorrectionDeed.PropertyAddress}" data-message="Please fill {{$index+1}} Property Address!">
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.CorrectionDeed.PropertyAddress" />
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%--POA--%>
                <div ng-show="currentStep().title=='POA'" class="view-animate" id="preSignPOA">
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
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.GivingPOA.Name}" data-message="Please fill {{$index+1}} Giving POA Name!">Name</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.GivingPOA.Name" /></li>
                                        <li class="ss_form_item ss_form_item2">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.GivingPOA.Address}" data-message="Please fill {{$index+1}} Giving POA Address!">Address</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.GivingPOA.Address" /></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="ss_form">
                                <h4 class="ss_form_title ">Receiving POA</h4>
                                <div class="ss_border">
                                    <ul class="ss_form_box clearfix">
                                        <li class="ss_form_item ">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ReceivingPOA.name}" data-message="Please fill {{$index+1}} Receiving POA Name!">Name</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ReceivingPOA.name" /></li>
                                        <li class="ss_form_item ss_form_item2">
                                            <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.DealSheet.ReceivingPOA.address}" data-message="Please fill {{$index+1}} Receiving POA Address!">Address</label>
                                            <input class="ss_form_input" ng-model="SSpreSign.DealSheet.ReceivingPOA.address" /></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div ng-show="currentStep().title=='Finish'" class="view-animate">
                    <h3 class="wizard-title">Finish</h3>
                    <div>
                        <div class="well">
                            Congratulation! you are in the last step please click Generate document button to download document(s).
                        </div>
                    </div>
                </div>

            </div>
            <div class="modal-footer" style="margin-top: 30px;">
                <button type="button" class="btn btn-default" ng-show="step>1" ng-click="PrevStep()">< Prev</button>
                <button type="button" class="btn btn-default" ng-click="GenerateDocument()" ng-show="step==MaxStep()">Generate document</button>
                <button type="button" class="btn btn-default" ng-show="step<MaxStep()" ng-click="NextStep()">Next ></button>
            </div>
        </div>
    </div>
    <%--help script for this page--%>
    <script>

        ScopeHelper =
            {
                getShortSaleScope: function () {

                    //return angular.element(document.getElementById('ShortSaleCtrl')).scope();
                    return ScopeHelper.getScope('ShortSaleCtrl');
                },
                getLeadsSearchScope: function () {
                    return ScopeHelper.getScope('LeadTaxSearchCtrl');
                }, getScope: function (id) {
                    return angular.element(document.getElementById(id)).scope();
                }
            }
    </script>
    <script>
        var portalApp = angular.module('PortalApp');

        portalApp.controller('shortSalePreSignCtrl', function ($scope, ptCom, $http, ptContactServices,$q) {
            $scope.ptContactServices = ptContactServices;
            $scope.QueryUrl = PortalUtility.QueryUrl();

            if ($scope.QueryUrl.model == 'List')
            {
                $http.get('/api/PropertyOffer').success(function (data) {
                    $scope.newOfferGridOpt = {
                        dataSource: data,
                        headerFilter: {
                            visible: true
                        },
                        searchPanel: {
                            visible: true,
                            width: 250
                        },
                        paging: {
                            pageSize: 10
                        },
                        columnAutoWidth: true,
                        wordWrapEnabled: true,
                        columns: [{ dataField: 'Title', caption: 'Address' }, 'OfferType',
                            { dataField: 'CreateBy', caption: 'Submit By' },
                            {
                                dataField: 'CreateDate', caption: 'Contract Date', dataType: 'date',
                                sortOrder: 'desc',
                                format: 'shortDate'
                            },
                        ]
                    }
                });
                
            }
           
            $scope.SSpreSign = {
                Type: 'Short Sale',
                FormName: 'PropertyOffer',
                DealSheet: {
                    ContractOrMemo: { Sellers: [{}], Buyers: [{}] },
                    Deed: { Sellers: [{}] },
                    CorrectionDeed: { Sellers: [{}], Buyers: [{}] }
                }
            };
            $scope.DeadType = {
                Contract: true,
                Memo: false,
                Deed: false, CorrectionDeed: false, POA: false
            };
            $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); };
            $scope.arrayRemove = ptCom.arrayRemove;
            $scope.NGAddArraryItem = ptCom.AddArraryItem;
            $scope.GenerateDocument = function () {
                $http.post('/api/PropertyOffer/GeneratePackage/' + $scope.SSpreSign.BBLE, JSON.stringify($scope.SSpreSign)).success(function (url) {
                    STDownloadFile('/TempDataFile/OfferDoc/' + $scope.SSpreSign.BBLE.trim() + '.zip', $scope.SSpreSign.BBLE.trim() + '.zip');
                })
            }
            $scope.shortSaleInfoNext = function () {

                var ss = ScopeHelper.getShortSaleScope();
                var _sellers = ss.SsCase.PropertyInfo.Owners;

                var _dealSheet = $scope.SSpreSign.DealSheet;
                var eMessages = $scope.getErrorMessage('ShortSaleCtrl');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                _dealSheet.CorrectionDeed.PropertyAddress = $scope.SSpreSign.PropertyAddress;
                var _sellers = _.map(_sellers, function (o) {
                    o.Name = ss.formatName(o.FirstName, o.MiddleName, o.LastName);
                    o.Address = $scope.SSpreSign.PropertyAddress;//ss.formatAddr(o.MailNumber, o.MailStreetName, o.MailApt, o.MailCity, o.MailState, o.MailZip);
                    o.PropertyAddress = $scope.SSpreSign.PropertyAddress;
                    return o
                });


                _dealSheet.ContractOrMemo.Sellers = $.extend(true, [], _sellers);
                _dealSheet.Deed.Sellers = $.extend(true, [], _sellers);
                _dealSheet.CorrectionDeed.Sellers = $.extend(true, [], _sellers);
                _dealSheet.Deed.PropertyAddress = $scope.SSpreSign.PropertyAddress;
                return true;
            }
            $scope.$watch('SSpreSign.assignCrop.Name', function (newValue, oldValue) {
                if (newValue) {
                    var team = newValue;
                    $http.get('/api/CorporationEntities/CorpSigners?team=' + team).success(function (signers) {
                        $scope.SSpreSign.assignCrop.signers = signers
                    });
                }

            });
            $scope.constractFromData = function () {
                var ss = ScopeHelper.getShortSaleScope();
                var _sellers = ss.SsCase.PropertyInfo.Owners;
                $scope.SSpreSign.DeadType = $scope.DeadType

                $scope.SSpreSign.SsCase = ss.SsCase;


                $scope.SSpreSign.FormData = JSON.stringify($scope.SSpreSign);
            }
            $scope.searchInfoNext = function () {
                var eMessages = $scope.getErrorMessage('preSignSearchInfo');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                var leadSearch = ScopeHelper.getLeadsSearchScope();
                $.extend($scope.SSpreSign.assignCrop, { isWellsFargo: leadSearch.DocSearch.LeadResearch.wellsFargo })
                return true;
            }
            $scope.getErrorMessage = function (id) {
                var eMessages = [];
                $.for
                $('#' + id + ' .ss_warning').each(function () {
                    eMessages.push($(this).attr('data-message'));
                })
                return eMessages
            }
            $scope.ContractNext = function () {
                var eMessages = $scope.getErrorMessage('preSignContract');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                return true;
            }
            
           
            $scope.DeedNext = function () {
                var deedCrop = $scope.SSpreSign.DealSheet.Deed;
                /*use like synchronously call*/
              
                if (!deedCrop.EntityId)
                {

                    var response = $.ajax({
                        type: "POST",
                        dataType: 'application/json',
                        data: $scope.SSpreSign.DealSheet.Deed.Buyer,
                        url: '/api/CorporationEntities/AssignDeedCorp?bble=' + $scope.SSpreSign.BBLE,
                        async: false
                    });

                    var errorMsg = PortalHttp.BuildAjaxErrorMessage(response);
                    if (!errorMsg)
                    {
                        $scope.SSpreSign.DealSheet.Deed.EntityId = $scope.SSpreSign.DealSheet.Deed.Buyer.EntityId;
                        return true;
                    }else
                    {
                        AngularRoot.alert(errorMsg);
                        deedCrop.EntityId = null;
                        return false;
                    }


                    //$http.post(,JSON.stringify($scope.SSpreSign.DealSheet.Deed.Buyer)).success(function()
                    //{

                    //}).error(function(){
                   
                       
                    //});
                }
               
                var eMessages = $scope.getErrorMessage('preAssignDeed');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                return true;
            }
            $scope.preAssignCorrectionDeed = function () {
                var eMessages = $scope.getErrorMessage('preAssignCorrectionDeed');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }

                return true;
            }

            $scope.preAssignCorrectionPOA = function () {
                var eMessages = $scope.getErrorMessage('preSignPOA');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                return true;
            }

            $scope.assginCropClick = function () {
                var _assignCrop = $scope.SSpreSign.assignCrop;
                var eMessages = $scope.getErrorMessage('assignBtnForm');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                var assignApi = '/api/CorporationEntities/AvailableCorp?team=' + _assignCrop.Name + '&wellsfargo=' + _assignCrop.isWellsFargo;


                if (_assignCrop.isWellsFargo) {
                    assignApi = "/api/CorporationEntities/AvailableCorpBySigner?team=" + _assignCrop.Name + "&signer=" + _assignCrop.Signer;
                }

                $http.get(assignApi).success(function (data) {

                    AngularRoot.confirm('We are going to assign ' + data.CorpName + ' to ' + $scope.SSpreSign.PropertyAddress).then(function (r) {
                        if (r) {
                            $http.post('/api/CorporationEntities/Assign?bble=' + $scope.SSpreSign.BBLE, JSON.stringify(data)).success(function () {
                                _assignCrop.Crop = data.CorpName;
                                _assignCrop.CropData = data;
                            });
                        }
                    });

                });

            }
            $http.get('/api/CorporationEntities/Teams').success(function (data) {
                $scope.CorpTeam = data;

            })
            $scope.AssignCropsNext = function () {

                var eMessages = $scope.getErrorMessage('preSignAssignCrops');
                if (_.any(eMessages)) {
                    AngularRoot.alert(eMessages.join(' <br />'));
                    return false;
                }
                var _dealSheet = $scope.SSpreSign.DealSheet;

                var _cropData = $scope.SSpreSign.assignCrop.CropData;
                _dealSheet.ContractOrMemo.Buyer = _cropData;
                //_dealSheet.Deed.Buyer = _cropData;
                return true;
            }


            $scope.DocRequiredNext = function (noAlert) {

                if (!_.any($scope.DeadType)) {
                    if (!noAlert) {
                        AngularRoot.alert("Please select at least one type to continue!")
                    }
                    return false;
                }
                return true;
            }
            $scope.DeedWizardInit = function () {

                $http.get('/api/CorporationEntities/DeedCorpsByTeam?team=' + $scope.SSpreSign.assignCrop.Name).success(function (data) {
                    $scope.SSpreSign.DealSheet.Deed.Buyer = data;
                    
                });

            }
            $scope.steps = [
              { title: "New Offer", next: function () { return true; } },
              { title: "Search Info", next: $scope.searchInfoNext },
              { title: "Pre Sign", caption: 'SS Info', next: $scope.shortSaleInfoNext, },
              { title: "Assign Crops", caption: 'Assign Corp', next: $scope.AssignCropsNext },
              {
                  title: "Documents Required", caption: 'Doc Required', next: $scope.DocRequiredNext
              },

              //{ title: "Deal Sheet" },
              { title: 'Contract', caption: 'Contract Or Memo', sheet: 'Contract', next: $scope.ContractNext },
              { title: 'Deed', sheet: 'Deed', next: $scope.DeedNext, init: $scope.DeedWizardInit },
              { title: 'CorrectionDeed', caption: 'Correction Deed', sheet: 'CorrectionDeed', next: $scope.preAssignCorrectionDeed },
              { title: 'POA', sheet: 'POA', next: $scope.preAssignCorrectionPOA },
              { title: "Finish" },
            ];


            var BBLE = $("#BBLE").val();
            if (BBLE) {
                $http.get('/api/Leads/LeadsInfo/' + BBLE).success(function (data) {
                    $scope.SSpreSign.PropertyAddress = data.PropertyAddress;
                    $scope.SSpreSign.BBLE = BBLE
                })
            }

            $scope.step = 1
            $scope.filteredSteps = [];
            $scope.MaxStep = function () {
                return $scope.filteredSteps.length;
            }
            $scope.currentStep = function () {
                return $scope.filteredSteps[$scope.step - 1];
            }
            
            $scope.NextStep = function () {
                var cStep = $scope.currentStep();
                if (cStep.next) {
                    if (cStep.next()) {
                        $scope.constractFromData();
                        $http.post('/api/businessform/', JSON.stringify($scope.SSpreSign)).success(function (formdata) {
                            $scope.SSpreSign.DataId = formdata.DataId;
                            $scope.step++;
                            cStep = $scope.currentStep();
                            if (cStep.init) {
                                cStep.init();
                            }
                        })
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
        portalApp.filter('ordered', function () {
            return function (item) {

                var orderDic = { "1": '1st', "2": "2nd", "3": "3rd" };

                return orderDic[item];
            };
        });
    </script>
    <script type="text/javascript" src="/js/PortalHttpFactory.js"></script>
</asp:Content>
