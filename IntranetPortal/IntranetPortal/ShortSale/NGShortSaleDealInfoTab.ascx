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

        <%--  

                <li class="ss_form_item">
            <label class="ss_form_input_title">MLS Status</label>
            <select class="ss_form_input" data-field="MLSStatus">
                <option>NYS MLS</option>
                <option>MLS LI </option>
                <option>Brooklyn MLS</option>
            </select>
        </li>

                
 
        <li class="ss_form_item">
            <label class="ss_form_input_title">LockBox</label>
            <input class="ss_form_input" data-field="Lockbox">
        </li>

             <li class="ss_form_item">
            <label class="ss_form_input_title">Document Missing</label>
            <input type="checkbox" id="pdf_check120" name="DocumentMissing" value="YES" class="ss_form_input ss_visable" data-field="DocumentMissing">
            <label for="pdf_check120" class="input_with_check">
                <span class="box_text">Yes </span>
            </label>
        </li>
        <li class="ss_form_item" data-visiable="DocumentMissing">
            <label class="ss_form_input_title">Missed Document</label>
            <input class="ss_form_input " data-field="MissingDocDescription">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Start Intake</label>
            <input type="radio" id="pdf_check119" name="1" value="YES" class="ss_form_input" data-field="StartIntake">
            <label for="pdf_check119" class="input_with_check">
                <span class="box_text">Yes </span>
            </label>
            <input type="radio" id="pdf_check1191" name="1" value="NO" class="ss_form_input">
            <label for="pdf_check1191" class="input_with_check">
                <span class="box_text">No </span>
            </label>
        </li>
        --%>
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
            <th><i class="fa fa-plus-circle"></i></th>
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
                <i class="fa fa-check text-success"></i>
                <i class="fa fa-minus-circle text-warning"></i>
            </td>
        </tr>
    </table>


    <%-- 
    <asp:HiddenField ID="hfBBLE" runat="server" />
    <dx:ASPxGridView ID="gvPropertyValueInfo" runat="server" KeyFieldName="ValueId" Width="100%" Theme="Moderno" OnDataBinding="gvPropertyValueInfo_DataBinding"
        OnRowInserting="gvPropertyValueInfo_RowInserting" OnRowUpdating="gvPropertyValueInfo_RowUpdating" OnRowDeleting="gvPropertyValueInfo_RowDeleting">
        <Columns>
            <dx:GridViewDataComboBoxColumn FieldName="Method" Width="150px">
                <PropertiesComboBox Native="true" Style-CssClass="form-control">
                    <Items>
                        <dx:ListEditItem Value="Exterior Appraisal" Text="Exterior Appraisal" />
                        <dx:ListEditItem Value="Interior Appraisal" Text="Interior Appraisal" />
                        <dx:ListEditItem Value="Exterior BPO" Text="Exterior BPO" />
                        <dx:ListEditItem Value="Interior BPO" Text="Interior BPO" />

                    </Items>
                </PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="BankValue" PropertiesTextEdit-DisplayFormatString="C2">
                <PropertiesTextEdit Native="true" Style-CssClass="form-control">
                </PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="MNSP" PropertiesTextEdit-DisplayFormatString="C2">
                <PropertiesTextEdit Native="true" Style-CssClass="form-control">
                </PropertiesTextEdit>
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn FieldName="DateOfValue" Width="120px">
            </dx:GridViewDataDateColumn>
            <dx:GridViewDataDateColumn FieldName="ExpiredOn" Width="120px"></dx:GridViewDataDateColumn>
            <dx:GridViewCommandColumn ShowEditButton="true" ShowDeleteButton="true" ShowNewButtonInHeader="true"></dx:GridViewCommandColumn>
        </Columns>
        <SettingsEditing Mode="Inline"></SettingsEditing>
    </dx:ASPxGridView>

    --%>
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
            <th><i class="fa fa-plus-circle"></i></th>
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
                <input class="ss_form_input disabled" ss-date="" ng-model="valuation.BuyingEntity">
            </td>
            <td>
                <input class="ss_form_input disabled" ss-date="" ng-model="valuation.Signor">
            </td>
            <td>
                <input class="ss_form_input disabled" ss-date="" ng-model="valuation.DateCorpFormed">
            </td>
            <td>
                <input class="ss_form_input " ss-date="" ng-model="valuation.DateOfContract">
            </td>
            <td>
                <input class="ss_form_input " ss-date="" ng-model="valuation.OfferAmount">
            </td>
            <td>
                <input class="ss_form_input " ss-date="" ng-model="valuation.DateSubmitted">
            </td>
            <td>
                <i class="fa fa-check text-success"></i>
                <i class="fa fa-minus-circle text-warning"></i>
            </td>
        </tr>
    </table>


    <%-- 
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Offer Submited </label>

            <input type="checkbox" id="pdf_check9995" name="HasOfferSubmit" value="true" class="ss_form_input ss_visable" data-field="HasOfferSubmit">
            <label for="pdf_check9995" class="input_with_check">
                <span class="box_text">Yes </span>
            </label>
            <%-- <input type="radio" id="pdf_check9993" name="HasOfferSubmit" value="false" class="ss_form_input ss_visable" data-field="HasOfferSubmit">
                                                <label for="pdf_check9993" class="input_with_check">
                                                    <span class="box_text">Yes </span>
                                                </label>
                                                <input type="radio" id="pdf_check9994" name="HasOfferSubmit" value="true" class="ss_form_input">
                                                <label for="pdf_check9994" class="input_with_check">
                                                    <span class="box_text">No </span>
                                                </label>
                                               
        </li>

        <li class="ss_form_item" data-visiable="HasOfferSubmit">
            <label class="ss_form_input_title">Offer Submitted Amount</label>
            <input class="ss_form_input currency_input" data-field="OfferSubmited">
        </li>
    <li class="ss_form_item" data-visiable="HasOfferSubmit">
        <label class="ss_form_input_title">Offer Submitted Date </label>
        <input class="ss_form_input ss_date" data-field="OfferDate">
    </li>

    <li class="ss_form_item">
        <label class="ss_form_input_title">Lender Counter </label>
        <input class="ss_form_input" data-field="LenderCounter">
    </li>
    <li class="ss_form_item">
        <label class="ss_form_input_title">Date Counter Submitted </label>
        <input class="ss_form_input ss_date" data-field="CounterSubmited">
    </li>
    <li class="ss_form_item">
        <label class="ss_form_input_title">Counter Offer</label>
        <input class="ss_form_input" data-field="CounterOffer">
    </li>
    </ul>
    --%>
</div>
