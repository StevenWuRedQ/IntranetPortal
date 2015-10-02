<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSummaryTab.ascx.vb" Inherits="IntranetPortal.LegalSummaryTab" %>

<div class="legalui short_sale_content">
    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Current Servicer</label>
                <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.CurrentServicer" pt-init-model="ShortSaleCase.Mortgages[0].Lender">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vacant / Occupied?</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Condition</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block / Lot</label>
                <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.BlockLot" pt-init-model="LeadsInfo.Block+'/'+ LeadsInfo.Lot">
            </li>
            <li class="ss_form_item" style="display: none">
                <label class="ss_form_input_title">BBLE</label>
                <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.BBLE" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Client Name</label>
                <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.ClientName" pt-init-model="ShortSaleCase.PropertyInfo.Owners[0].FullName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Client Contact #</label>
                <input class="ss_form_input" mask="(999) 999-9999" ng-model="LegalCase.PropertyInfo.ClientContactNum" pt-init-model="ShortSaleCase.PropertyInfo.Owners[0].Phone">
            </li>
        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Mortgage</h4>
        <ul class="ss_form_box clearfix">
            <li class="" style="width: 97%; width: auto;list-style:none">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Lender</th>
                            <th>Loan #</th>
                            <th>Amount</th>
                            <th>Authorization Sent</th>
                            <th>LastPayment Date</th>
                            <th>Type</th>
                            <th>Cancelation Sent</th>
                        </tr>
                    </thead>
                    <tr ng-repeat="mortgage in ShortSaleCase.Mortgages">
                        <td>{{$index +1}}</td>
                        <td>{{mortgage.Lender}} </td>
                        <td>{{mortgage.Loan}}</td>
                        <td>{{mortgage.LoanAmount |currency}}</td>
                        <td>{{mortgage.AuthorizationSent|date:'shortDate'}}</td>
                        <td>{{mortgage.LastPaymentDate|date:'shortDate'}}</td>
                        <td>{{mortgage.Type}}</td>
                        <td>{{mortgage.CancelationSent|date:'shortDate'}}</td>
                    </tr>

                </table>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Original Loan Amt</label>
                <input class="ss_form_input" money-mask ng-model="LegalCase.MortgageOriginalLoanAmt">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Executed Date</label>
                <input class="ss_form_input" ng-model="LegalCase.MortgageExecutedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Recording Date</label>
                <input class="ss_form_input" ng-model="LegalCase.MortgageRecordingDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">CRFN #</label>
                <input class="ss_form_input" ng-model="LegalCase.MortageCRFNNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Last Payment Date </label>
                <input class="ss_form_input" ng-model="LegalCaseLastPaymentDate" ss-date>
            </li>
        </ul>
    </div>

    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Is there a current / active foreclosure?</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.IsCurrentFC">
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                    <option value="N/A">N/A</option>
                </select>
            </li>
        </ul>
    </div>
    <div class="cssSlideUp" ng-show="LegalCase.PropertyInfo.IsCurrentFC=='Yes'">
        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Index #</label>
                    <input class="ss_form_input" ng-model="LegalCase.CurrentFCIndexNum">
                </li>
            </ul>
        </div>
    </div>

    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Is there a prior foreclosure action?</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.IsPriorFC">
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                    <option value="N/A">N/A</option>
                </select>
            </li>

        </ul>
    </div>
    <div class="cssSlideUp" ng-show="LegalCase.PropertyInfo.IsPriorFC=='Yes'">
        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Index #</label>
                    <input class="ss_form_input" ng-model="LegalCase.PriorFcIndexNumb">
                </li>
            </ul>
        </div>
    </div>

    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Are there any Tax liens?</label>

                <select class="ss_form_input" ng-model="TaxLiensShow">
                    <option value="">N/A</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>

                </select>
            </li>
        </ul>
    </div>
    <div class="ss_form" ng-show="ModelArray('TaxLiens')=='Yes'">
        <h4 class="ss_form_title">Tax Lien</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Owner</th>
                    <th>Amount</th>
                    <th>Year</th>
                </tr>

            </thead>
            <tr ng-repeat="s in TaxLiens">
                <td>{{s.Owner}}</td>
                <td>{{s.LienTotal}}</td>
                <td>{{s.Year}}</td>
            </tr>
        </table>
    </div>
    <div class="cssSlideUp" ng-show="ModelArray('TaxLiens')=='Yes'">
        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item" style="width: 66.6%">
                    <label class="ss_form_input_title">Is there an active FC on the tax lien?</label>
                    <select class="ss_form_input">
                        <option value="Yes">Yes</option>
                        <option value="No">No</option>
                        <option value="N/A">N/A</option>
                    </select>
                </li>
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Tax lien comments / review:</label>
                    <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.TaxLienReview"></textarea>
                </li>
            </ul>

        </div>
    </div>

    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Are there any other judgment liens?</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.AreJudgmentLiens">
                    <option value=""></option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                    <option value="N/A">N/A</option>
                </select>
            </li>
        </ul>
    </div>
    <div class="cssSlideUp" ng-show="LegalCase.PropertyInfo.AreJudgmentLiens=='Yes'">
        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Judgment liens Review</label>
                    <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.JudgemntLiensReview"></textarea>
                </li>
            </ul>
        </div>
    </div>

    <div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Are there Mortage liens?</label>
                <select class="ss_form_input" ng-model="LPShow">
                    <option value="">N/A</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>

                </select>
            </li>
        </ul>
    </div>


    <div class="cssSlideUp ss_form" ng-show="ModelArray('LeadsInfo.LisPens')=='Yes'">
        <h4 class="ss_form_title">Mortage Lien</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <td>Type</td>
                    <td>Effective</td>
                    <td>Docket Number</td>
                    <td>Defendant</td>
                    <td>Plaintiff</td>
                    <td>Attorney</td>
                </tr>

            </thead>
            <tr ng-repeat="t in LeadsInfo.LisPens">
                <td>{{t.Type}}</td>
                <td>{{t.Effective |date:'shortDate'}}</td>
                <td>{{t.Docket_Number}}</td>
                <td>{{t.Defendant}}</td>
                <td>{{t.Plaintiff}}</td>
                <td>{{t.Attorney}}</td>
            </tr>
        </table>
        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Mortage liens Review:</label>
                    <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.MortageLinesReview"></textarea>
                </li>
            </ul>
        </div>
    </div>


    <div class="ss_form">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Are there any other misc liens?</label>
                <select class="ss_form_input" ng-model="LegalCase.HasOtherMiscLiens">
                    <option value="">N/A</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>

                </select>
            </li>
        </ul>
    </div>
    <div class="cssSlideUp" ng-show="LegalCase.HasOtherMiscLiens=='Yes'">

        <div class="arrow_box">
            <ul class="ss_form_box clearfix ">
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Other misc liens Review:</label>
                    <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.OtherMiscLiensReview"></textarea>
                </li>
            </ul>
        </div>
    </div>


    <%-- 
    <div>
        <div>
            <h4 class="ss_form_title">Property</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">address</label>

                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.PropertyAddress" style="width: 93.5%;" name="lender">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Block</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.Block">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">lot</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.Lot">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">BBLE</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.BBLE">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Class</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.TaxClass">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Condition</label>
                    <select class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.Condition">
                        <option></option>
                        <option value="Great">Great</option>
                        <option value="Good">Good</option>
                        <option value="Bad">Bad</option>
                    </select>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vacant/Occupied </label>
                    <select class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.VacantOrOccupied">
                        <option></option>
                        <option value="Vacant">Vacant</option>
                        <option value="Occupied">Occupied</option>

                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Stage</label>
                    <select class="ss_form_input" disabled="disabled">
                        <option>Eviction</option>
                        <option>Short Sale</option>
                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title ss_ssn">Agent </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.PropertyInfo.AgentId')">
                    </div>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Use</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.PropertyInfo.Use">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Owner of Record </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.PropertyInfo.OwnerOfRecordId')">
                    </div>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Case Contact person/owner </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.PropertyInfo.CaseContactId')">
                    </div>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone number </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Cell">
                </li>


                <li class="ss_form_item">
                    <label class="ss_form_input_title">email  </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Email">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input" disabled="disabled" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Address">
                </li>

            </ul>
        </div>

        <div data-array-index="0" class="ss_array" style="display: inline;">

            <div class="ss_form">
                <h4 class="ss_form_title"><span class="title_index ">Foreclosure </span></h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Plaintif</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PlaintiffId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Servicer</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.ServicerId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Defendant</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.DefendantId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Attorney of record </label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.DefendantId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">last court date</label>
                        <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.LastCourtDate">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">next court date </label>
                        <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.NextCourtDate">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Sale date  </label>
                        <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.SaleDate">
                    </li>

                    <li class="ss_form_item">
                        <span class="ss_form_input_title">HAMP </span>

                        <input type="checkbox" id="pdf_check_yes30" name="1" class="ss_form_input" disabled="disabled" ng-model="LegalCase.ForeclosureInfo.HAMP">
                        <label for="pdf_check_yes30" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>

                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Last Update </label>
                        <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.LastUpdate">
                    </li>
                </ul>
            </div>

        </div>


        <div class="ss_form">
            <h4 class="ss_form_title">Secondary</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Client </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.PropertyInfo.OwnerOfRecordId')">
                    </div>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney of record </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.AttorneyId')">
                    </div>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Opposing party  </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.OpposingPartyId')">
                    </div>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.SecondaryInfo.Status">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tasks </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.SecondaryInfo.Tasks">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney working file  </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.SecondaryInfo.AttorneyWorkingFile">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Update </label>
                    <input class="ss_form_input" disabled="disabled" ng-model="LegalCase.ForeclosureInfo.LastUpdate">
                </li>


            </ul>
        </div>

    </div>
    --%>
</div>
