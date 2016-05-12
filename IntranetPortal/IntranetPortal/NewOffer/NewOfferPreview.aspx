<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="NewOfferPreview.aspx.vb" Inherits="IntranetPortal.NewOfferPreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <script type="text/javascript">
        function NewOfferBusinessForm() {

        }

        NewOfferBusinessForm.prototype.init = function () {
            //Init property over there
            //this.xxx
        }

        //def function here
        //NewOfferBusinessForm.prototype.func =
        var BBLE = '<%= Request.QueryString("BBLE")%>';
        var angularApp = angular.module('PortalApp')
                 .controller('NewOfferPreviewController', ['$scope', '$http', 'ptCom', function ($scope, $http, ptCom) {
                     me = this;
                     $scope.formatName = ptCom.formatName;

                     $http.get('/api/businessform/PropertyOffer/Tag/' + BBLE).success(function (data) {
                         if (data.FormData) {
                             me.BusinessForm = data;
                         }
                     });
                     me.Eidt = true;
                 }]);

        // the main form directive
        angularApp.directive("offerBusinessForm", function () {

            return {
                restrict: 'E',
                scope: {
                    formData: '=',
                },
                templateUrl: '/NewOffer/Templates/offer-business-form.html'
            }
        });
    </script>

    <script type="text/ng-template" id="/templates/short-sale-seller.html">
        <div class="ss_form">
            <h4 class="ss_form_title">Owner {{index}}</h4>
            <div class="ss_border" style="">
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title ">Name</label>
                        <input class="ss_form_input ss_not_empty" ng-value="formatName(owner.FirstName,owner.MiddleName,owner.LastName)" readonly>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">DOB</label>
                        <input class="ss_form_input" ng-model="owner.DOB" mask="99/99/9999" readonly>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">SSN</label>
                        <input class="ss_form_input" ng-model="owner.SSN" mask="999-99-9999" clean="true" readonly>
                    </li>
                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Mail Address</label>
                        <input class="ss_form_input" ng-value="formatAddr(owner.MailNumber, owner.MailStreetName, owner.MailApt, owner.MailCity, owner.MailState, owner.MailZip)" style="width: 96.66%" readonly>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Cell #</label>
                        <input class="ss_form_input" ng-model="owner.Phone" mask="(999) 999-9999" clean="true" readonly>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Additional #</label>
                        <input class="ss_form_input" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true" readonly>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Email Address</label>
                        <input class="ss_form_input" ng-model="owner.Email" type="email" readonly>
                    </li>
                </ul>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Bankruptcy</label>
                        <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{index}}"></pt-radio>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Bank account</label>
                        <pt-radio model="owner.Bankaccount" name="Bankaccount{{index}}"></pt-radio>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Tax Returns</label>
                        <pt-radio model="owner.TaxReturn" name="TaxReturn{{index}}"></pt-radio>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Employed</label>
                        {{owner.Employed}}                            
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Paystubs</label>
                        <pt-radio model="owner.Paystubs" name="Paystubs{{index}}"></pt-radio>
                    </li>
                </ul>
            </div>
        </div>
    </script>

    <script type="text/javascript">
        // templates/short-sale-seller.html
        angularApp.directive("ptSeller", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    owner: '=',
                    index: '='
                },
                templateUrl: '/templates/short-sale-seller.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });
    </script>

    <script type="text/ng-template" id="/templates/shortsale-mortgages.html">
        <div class="ss_form">
            <h4 class="ss_form_title">Mortgages</h4>
            <div class="ss_border">
                <div ng-repeat="mortgage in mortgages|filter:{DataStatus:'!3'}">
                    <h4 class="ss_form_title" style="display: inline"><span style="text-transform: lowercase">{{$index+1|ordered}}</span> Mortgage </h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Company</label>                            
                            <input type="text" class="ss_form_input " ng-model="mortgage.LenderName" readonly="readonly">
                        </li>
                        <li class="ss_form_item" ng-show="mortgage.LenderName!='N/A'">
                            <label class="ss_form_input_title">Loan #</label>
                            <input type="text" class="ss_form_input" ng-model="mortgage.Loan" readonly="readonly">
                        </li>

                        <li class="ss_form_item" ng-show="mortgage.LenderName!='N/A'">
                            <label class="ss_form_input_title">Loan Amount</label>
                            <input type="text" class="ss_form_input" ng-model="mortgage.LoanAmount" money-mask readonly="readonly">
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </script>

    <script type="text/javascript">
        // assign corp form
        angularApp.directive("shortsaleMortgage", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    mortgages: '=',
                },
                templateUrl: '/templates/shortsale-mortgages.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });

    </script>

    <script type="text/ng-template" id="/templates/assign-corp.html">
        <div class="ss_form">
            <h4 class="ss_form_title">Assigned Corp</h4>
            <div class="ss_border" id="assignBtnForm">
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Team Name</label>
                        {{assignCrop.Name}}                       
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Is wells fargo</label>
                        {{assignCrop.isWellsFargo}}                        
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">signer </label>
                        {{assignCrop.Signer}}                        
                    </li>
                </ul>
                <div class="alert alert-success" role="alert">
                    Corp: <strong>{{assignCrop.Crop}}</strong> is assigned to property.
                    <span>The signer for the corp is: <strong>{{assignCrop.CropData.Signer}} </strong></span>
                    <br />
                </div>
            </div>
        </div>
    </script>

    <script type="text/javascript">
        // assign corp form
        angularApp.directive("assignCorpForm", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    assignCrop: '=',
                },
                templateUrl: '/templates/assign-corp.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });

    </script>

    <script type="text/ng-template" id="/templates/contract-memo.html">
        <div class="ss_form">
            <h4 class="ss_form_title">contract or Memo</h4>
            <div class="ss_border" style="">
                <div ng-repeat="d in contract.Sellers">
                    <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Seller {{$index+1}} Name</label><input class="ss_form_input" ng-model="d.Name" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Seller {{$index+1}} Attorney</label>                            
                            <input type="text" class="ss_form_input" ng-model="d.sellerAttorney">
                        </li>
                        <li class="ss_form_item ss_form_item_line">
                            <label class="ss_form_input_title">Seller {{$index+1}} Address</label>
                            <input class="ss_form_input" ng-model="d.Address" />
                        </li>
                    </ul>
                </div>
                <h4 class="ss_form_title">Buyer </h4>
                <div>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Buyer Name</label>
                            <input class="ss_form_input" ng-model="contract.Buyer.CorpName" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Buyer Attorney</label>
                            <input class="ss_form_input" ng-model="contract.Buyer.buyerAttorney" />
                        </li>
                        <li class="ss_form_item " style="width: 96%">
                            <label class="ss_form_input_title">Buyer Address</label>
                            <input class="ss_form_input" ng-model="contract.Buyer.Address" />
                        </li>
                    </ul>
                </div>
                <h4 class="ss_form_title ">Bill Info </h4>
                <div >
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Contract Price</label>
                            <input class="ss_form_input" ng-model="contract.contractPrice" money-mask />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Down Payment</label>
                            <input class="ss_form_input" ng-model="contract.downPayment" money-mask />
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </script>

    <script>
        // contract and memo
        angularApp.directive("docContractMemo", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    contract: '=',
                },
                templateUrl: '/templates/contract-memo.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });
    </script>

    <script type="text/ng-template" id="/templates/doc-deed.html">
        <div class="ss_form">
            <h4 class="ss_form_title">{{title}}</h4>
            <div class="ss_border" style="">
                <div ng-repeat="d in deed.Sellers">
                    <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Seller {{$index+1}} Name</label>
                            <input class="ss_form_input" ng-model="d.Name" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Seller {{$index+1}} SSN</label>
                            <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999" /></li>
                    </ul>
                </div>
                <h4 class="ss_form_title ">Buyer</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Buyer Name</label>
                        <input class="ss_form_input" ng-model="deed.Buyer.CorpName" /></li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Buyer SSN/EIN</label>
                        <input class="ss_form_input" ng-model="deed.Buyer.EIN" />
                    </li>
                    <li class="ss_form_item ss_form_item_line">
                        <label class="ss_form_input_title">Buyer Address</label>
                        <input class="ss_form_input " ng-model="deed.Buyer.Address" style="width: 96%" />
                    </li>
                </ul>                
                <h4 class="ss_form_title ">Property Address </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item  oneline">
                        <input class="ss_form_input" ng-model="deed.PropertyAddress" />
                    </li>
                </ul>
            </div>
        </div>
    </script>

    <script>
        // Doc Deed
        angularApp.directive("docDeed", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    deed: '=',
                    title: '@title'
                },
                templateUrl: '/templates/doc-deed.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });
    </script>

    <script type="text/ng-template" id="/templates/doc-correction-deed.html">
        <div class="ss_form">
            <h4 class="ss_form_title">{{title}}</h4>
            <div class="ss_border" style="">
                <div ng-repeat="d in deed.Sellers">
                    <h4 class="ss_form_title">Seller {{$index+1}} </h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Seller {{$index+1}} Name</label>
                            <input class="ss_form_input" ng-model="d.Name" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Seller {{$index+1}} SSN</label>
                            <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999" /></li>
                    </ul>
                </div>
                <div ng-repeat="d in deed.Buyers">
                    <h4 class="ss_form_title">Buyer {{$index+1}} </h4>
                    <div>
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item">
                                <label class="ss_form_input_title">Buyer {{$index+1}} Name</label>
                                <input class="ss_form_input" ng-model="d.Name" /></li>
                            <li class="ss_form_item ">
                                <label class="ss_form_input_title">Buyer {{$index+1}} SSN</label>
                                <input class="ss_form_input" ng-model="d.SSN" mask="999-99-9999" /></li>
                            <li class="ss_form_item ss_form_item_line">
                                <label class="ss_form_input_title">Buyer {{$index+1}} Address</label>
                                <input class="ss_form_input" ng-model="d.Address" style="width: 96%" />
                            </li>
                        </ul>
                    </div>
                </div>
                <h4 class="ss_form_title ">Property Address </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item  oneline">
                        <input class="ss_form_input" ng-model="deed.PropertyAddress" />
                    </li>
                </ul>
            </div>
        </div>
    </script>

    <script>
        // Correction Deed
        angularApp.directive("docCorrectionDeed", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    deed: '=',
                    title: '@title'
                },
                templateUrl: '/templates/doc-correction-deed.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });
    </script>

    <script type="text/ng-template" id="/templates/doc-poa.html">
        <div class="ss_form">
            <h4 class="ss_form_title ">POA</h4>
            <div class="ss_border">
                <h4 class="ss_form_title ">Giving POA</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input" ng-model="givingPOA.Name" /></li>
                    <li class="ss_form_item ss_form_item2">
                        <label class="ss_form_input_title">Address</label>
                        <input class="ss_form_input" ng-model="givingPOA.Address" /></li>
                </ul>
                <h4 class="ss_form_title ">Receiving POA</h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input" ng-model="receivingPOA.name" /></li>
                    <li class="ss_form_item ss_form_item2">
                        <label class="ss_form_input_title">Address</label>
                        <input class="ss_form_input" ng-model="receivingPOA.address" /></li>
                </ul>
            </div>
        </div>
    </script>

    <script>
        // POA
        angularApp.directive("docPoa", function (ptCom) {
            return {
                restrict: 'E',
                scope: {
                    givingPOA: '=',
                    receivingPOA: '='
                },
                templateUrl: '/templates/doc-poa.html',
                link: function (scope) {
                    _.extend(scope, ptCom);
                }
            }
        });
    </script>

    <div ng-controller="NewOfferPreviewController as offer">
        <div class="container">
            <offer-business-form form-data="offer.BusinessForm.FormData"></offer-business-form>
        </div>
    </div>

</asp:Content>
