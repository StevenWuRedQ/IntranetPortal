<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleDealInfoTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleDealInfoTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
</div>

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
            <input class="ss_form_input disabled" ss-date="" ng-model="SsCase.DealInfo.ReviewedDate">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Order Date</label>
            <input class="ss_form_input disabled" ss-date="" ng-model="SsCase.DealInfo.OrderDate">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Confirmation Date</label>
            <input class="ss_form_input disabled" ss-date="" ng-model="SsCase.DealInfo.ConfirmationDate">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Received Date</label>
            <input class="ss_form_input disabled" ss-date="" ng-model="SsCase.DealInfo.ReceivedDate">
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
    <table class="ss_form_table">
        <tr>
            <th>Type</th>
            <th>Date Completed</th>
            <th>Date Expires</th>
            <th>Value</th>
            <th>Min Net</th>
            <th><i class="fa fa-plus-circle" ng-click="NGAddArraryItem(SsCase.DealInfo.Valuations)"></i></th>
        </tr>
        <tr ng-repeat="valuation in SsCase.DealInfo.Valuations">
            <td>
                <select class="ss_form_input" ng-model="valuation.Method">
                    <option value="AVM">AVM</option>
                    <option value="Exterior Appraisal">Exterior Appraisal</option>
                    <option value="Exterior BPO">Exterior BPO</option>
                    <option value="Interior Appraisal">Interior Appraisal</option>
                    <option value="Interior BPO">Interior BPO</option>
                </select>
            </td>
            <td>
                <input class="ss_form_input" ss-date="" ng-model="valuation.DateOfValue">
            </td>
            <td>
                <input class="ss_form_input" ss-date="" ng-model="valuation.ExpiredOn">
            </td>

            <td>
                <input class="ss_form_input " ng-model="valuation.BankValue">
            </td>

            <td>
                <input class="ss_form_input " ng-model="valuation.MNSP">
            </td>

            <td>
                <i class="fa fa-minus-circle text-warning" ng-click="NGremoveArrayItem(SsCase.DealInfo.Valuations, index)"></i>
            </td>
        </tr>
    </table>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Offer</h4>

    <table class="ss_form_table">
        <tr>
            <th>Type</th>
            <th>Buying Entity</th>
            <th>Signor</th>
            <th>Date Corp Formed</th>
            <th>Date of Contract</th>
            <th>Offer Amount</th>
            <th>Date Submitted</th>
            <th><i class="fa fa-plus-circle" ng-click="NGAddArraryItem(SsCase.DealInfo.Offers)"></i></th>
        </tr>

        <tr ng-repeat="offer in SsCase.DealInfo.Offers">
            <td>
                <select class="ss_form_input" ng-model="offer.Type">
                    <option value="Initial Offer">Initial Offer</option>
                    <option value="Bank Counter">Bank Counter</option>
                    <option value="Buyer Counter">Buyer Counter</option>
                    <option value="New Buyer Offer">New Buyer Offer</option>
                </select>
            </td>
            <td>
                <input class="ss_form_input disabled" ng-model="valuation.BuyingEntity">
            </td>
            <td>
                <input class="ss_form_input disabled" ng-model="valuation.Signor">
            </td>
            <td>
                <input class="ss_form_input disabled" ss-date ng-model="valuation.DateCorpFormed">
            </td>
            <td>
                <input class="ss_form_input " ss-date ng-model="valuation.DateOfContract">
            </td>
            <td>
                <input class="ss_form_input " ng-model="valuation.OfferAmount">
            </td>
            <td>
                <input class="ss_form_input " ss-date ng-model="valuation.DateSubmitted">
            </td>
            <td>
                <i class="fa fa-minus-circle text-warning"  ng-click="NGRemoveArrayItem(SsCase.DealInfo.Offers, index)"></i>
            </td>
        </tr>
    </table>

</div>
