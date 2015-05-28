<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalForeclosureReviewTab.ascx.vb" Inherits="IntranetPortal.LegalForeclosureReviewTab" %>
<div class="short_sale_content">
    <div class="clearfix">
        <div style="float: right">
            <input type="button" class="rand-button short_sale_edit" value="Completed Research" runat="server" onserverclick="btnCompleteResearch_ServerClick" id="btnCompleteResearch" visible="false" />
            <select class="ss_form_input" id="lbEmployee" runat="server" style="width: 150px" visible="false">
                <option value=""></option>
                <option value="Chris Yan">Chris Yan</option>
                <option value="Steven Wu">Steven Wu</option>
            </select>
            <%--   <input type="button" class="rand-button short_sale_edit" visible="false" value="Assign" runat="server" onserverclick="btnAssign_ServerClick" id="btnAssign" />
            <input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />--%>
        </div>
    </div>

    <div>
        <h4 class="ss_form_title">Property</h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Street Number</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.StreetName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Street Name</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.NeighName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">State</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.State">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zip</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.ZipCode">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">BLOCK</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.Block">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lot</label>
                <input class="ss_form_input color_blue_edit" ng-model="LegalCase.PropertyInfo.Lot">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building type</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.BuildingType">
                    <option value="House">House</option>
                    <option value="Apartment">Apartment</option>
                    <option value="Condo">Condo</option>
                    <option value="Cottage/cabin">Cottage/cabin</option>
                    <option value="Duplex">Duplex</option>
                    <option value="Flat">Flat</option>
                    <option value="In-Law">In-Law</option>
                    <option value="Loft">Loft</option>
                    <option value="Townhouse">Townhouse</option>
                    <option value="Manufactured">Manufactured</option>
                    <option value="Assisted living">Assisted living</option>
                    <option value="Land">Land</option>
                </select>

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Borrower</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.BorrowerId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Co-Borrower</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.CoBorrowerId')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Language</label>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.Language">

                    <option value="English">English</option>
                    <option value="Spanish">Spanish</option>
                    <option value="Chinese">Chinese</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Mental Capacity </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.MentalCapacity">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Divorce</label>
                <input type="checkbox" class="ss_form_input" data-field="PropertyInfo.CO" data-radio="Y" id="DivorceCheck" ng-model="LegalCase.ForeclosureInfo.Divorce">
                <label for="key_PropertyInfo_checkYes_CO" class="input_with_check">
                    <span class="box_text">Yes</span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Borrowers Relationship </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.BorrowersRelationship">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Estate</label>
                <input class="ss_form_input" ss-money="" ng-model="LegalCase.ForeclosureInfo.Estate">
            </li>


            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintif</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PlaintiffId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Servicer</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PlaintiffId')">
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

        </ul>
    </div>

    <%--background--%>
    <div class="ss_form">
        <h4 class="ss_form_title">Background</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Originator  </label>
                <input class="ss_form_input" mask-money="" ng-model="LegalCase.ForeclosureInfo.OriginatorId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">2nd Mortgage </label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.Mortgage2Id')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Deed Xfer </label>
                <input type="checkbox" id="pdf_check_Deed1" name="1" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.DeedXfer">
                <label for="pdf_check_Deed1" class="input_with_check">
                    <span class="box_text">Yes </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien  </label>
                <input class="ss_form_input" mask-money="" ng-model="LegalCase.ForeclosureInfo.TaxLien">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">UCC  </label>
                <input class="ss_form_input currency_input" ng-model="LegalCase.ForeclosureInfo.UCC">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">UCC  </label>
                <input class="ss_form_input currency_input" mask-money="" ng-model="LegalCase.ForeclosureInfo.UCCAmount">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HPD </label>
                <input class="ss_form_input currency_input" mask-money="" ng-model="LegalCase.ForeclosureInfo.HPD">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Questionable Satisfactions CRFN # </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.QuestionableCRFN">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Title Issues </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.QuestionableCRFN">
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.BackgroundNotes"></textarea>
            </li>

        </ul>

    </div>


    <div class="ss_form">
        <h4 class="ss_form_title">Mortgage</h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Original Lender </label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.OriginalLenderId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Active/Dissolved Date </label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.ActiveOrDissolvedDate">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">1st Loan Amount</label>
                <input class="ss_form_input" ss-money="" ng-model="LegalCase.ForeclosureInfo.Loan1Amount">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">2nd Loan Amount</label>
                <input class="ss_form_input" ss-money="" ng-model="LegalCase.ForeclosureInfo.Loan2Amount">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Type of Loan</label>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.LoanType">
                    <option value="FHA">FHA         </option>
                    <option value="FANNIE MAE">FANNIE MAE  </option>
                    <option value="FREDDIE">FREDDIE     </option>
                    <option value="ARM">ARM         </option>
                    <option value="FIXED">FIXED       </option>
                    <option value="80/20">80/20       </option>
                    <option value="COMMERCIAL">COMMERCIAL  </option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">First Mortgage Payment</label>
                <input class="ss_form_input currency_input" ng-model="LegalCase.ForeclosureInfo.LoanType">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Maturity</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LoanType">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.SignedId')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">last payment date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LastPaymentDate"/>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Eviction status</span>
                <select class="ss_form_input">
                    <option value="occupied">occupied</option>
                    <option value="vacate">vacate</option>
                    <option value="tenant">tenant</option>
                </select>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">HAMP eligible</span>

                <input type="checkbox" id="checy_45" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMP">
                <label for="checy_45" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.MortgageNotes"></textarea>
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Note</h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Count Of Borrowers signed</label>
                <input class="ss_form_input" input-mask="0000" ng-model="LegalCase.ForeclosureInfo.HAMP">
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">note  endorsed</span>

                <input type="radio" id="checy_47" name="1" class="ss_form_input" value="ture" ng-model="LegalCase.ForeclosureInfo.NoteEndorsed">
                <label for="checy_47" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_48" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndorsed">
                <label for="checy_48" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">endorsed By Lender</span>

                <input type="radio" id="checy_49" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndorsed">
                <label for="checy_49" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_50" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndorsed">
                <label for="checy_50" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">endorsed Dept</span>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndorsedDept">
                    <option value="Entity1">Entity1</option>
                    <option value="Entity2">Entity2</option>
                    <option value="Bank1">Bank1</option>
                    <option value="Bank2">Bank2</option>
                </select>

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.NoteEndoresdSignedId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">endorsed signed date</label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.NoteEndorsedSingedDate">
            </li>

        </ul>


    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Note Alonge</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <span class="ss_form_input_title">note  Alonge</span>

                <input type="radio" id="checy_61" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteIsAlonge">
                <label for="checy_61" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>
                <input type="radio" id="checy_62" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteIsAlonge">
                <label for="checy_62" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Alonge By Lender</span>

                <input type="radio" id="checy_63" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteAlongeByLender">
                <label for="checy_63" class="input_with_check">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_64" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteAlongeByLender">
                <label for="checy_64" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Alonge Dept</span>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteAlongeDept">
                    <option value="Entity1">Entity1</option>
                    <option value="Entity2">Entity2</option>
                    <option value="Bank1">Bank1</option>
                    <option value="Bank2">Bank2</option>
                </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>

                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.NoteAlongeSignedId')">
                </div>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Alonge signed date</label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.NoteAlongeSingedDate">
            </li>

        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Court Activity</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.CourtDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Renewed Date</label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.CourtRenewed">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Affidavit Served Date</label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.CourtAffidavitServedDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Affidavit Company</label>

                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.CourtAffidavitdId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index #</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtPriorIndexNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index Date</label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.ForeclosureInfo.CourtPriorDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior disposition </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtPriordisposition">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index Opposing </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtPriorOpposing">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Conferences Date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.CourtConferencesDate">
            </li>
            <li class="ss_form_item">

                <span class="ss_form_input_title">Conferences Attended</span>

                <input type="radio" id="checy_69" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtConferencesAttended">
                <label for="checy_69" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_70" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtConferencesAttended">
                <label for="checy_70" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Conferences Referee </label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.CourtConferencesRefereeId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Status</label>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtStatus">
                    <option value="Court Status 1">Court Status 1</option>
                    <option value="Court Status 2">Court Status 2</option>
                </select>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Status Answered</span>

                <input type="radio" id="checy_71" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtStatusAnswered">
                <label for="checy_71" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_72" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtStatusAnswered">
                <label for="checy_72" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Order of Reference</span>

                <input type="radio" id="checy_73" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtOrderOfReference">
                <label for="checy_73" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_74" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtOrderOfReference">
                <label for="checy_74" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Judgment of Foreclosure and Sale</span>

                <input type="radio" id="check_76" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentOfForeclosureAndSale">
                <label for="check_76" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="check_77" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentOfForeclosureAndSale">
                <label for="check_77" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Judgment Date</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Judgment Sign off Date</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Judge</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.CourtJudgmentDate')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Judgment Stay</label>
                <input type="radio" id="check_761" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentStay">
                <label for="check_761" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="check_72" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CourtJudgmentStay">
                <label for="check_72" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted</label>
                <input type="radio" id="check_768" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted">
                <label for="check_768" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="check_762" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted">
                <label for="check_762" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>


            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted Date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted TYPE</label>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmittedType">
                    <option value="Type 1">Type 1</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted Resubmission</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmittedResubmission">
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.CourtActivityNotes"></textarea>
            </li>
        </ul>
    </div>
    <div  class="ss_array" style="display: inline;">

        <h4 class="ss_form_title title_with_line  title_after_notes ">
            <span class="title_index title_span">Assignments </span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples"  onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>
        <div class="collapse_div">

            <div class="ss_form">
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Assignor</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.AssignorId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Assignor</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.AssigneeId')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Document prepared</label>
                        <input type="radio" id="check_891" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignorDocumentPrepared">
                        <label for="check_891" class="input_with_check ">
                            <span class="box_text">Yes </span>
                        </label>

                        <input type="radio" id="check_8912" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignorDocumentPrepared">
                        <label for="check_891" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Document prepared By</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.AssignorPreparedById')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Date</label>
                        <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AssignmentDate" />
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Assigned before the S&C </span>

                        <input type="radio" id="checy_819" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedbeforeSAndC">
                        <label for="checy_819" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="checy_889" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedbeforeSAndC">
                        <label for="checy_889" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Signed by</label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.AssignSignedById')">
                        </div>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Signed Known robo-signor</label>
                        <input type="radio" id="checy_8191" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedSignedKnownRS">
                        <label for="checy_8191" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="checy_8892" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedSignedKnownRS">
                        <label for="checy_8892" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Signed Place</label>
                        <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssigSignedPlace" />
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Signed Patry located</label>
                        <div class="ss_form_input">{{LegalCase.ForeclosureInfo.AssigSignedPlace=='NY'}}</div>
                        <%--<input type="checkbox" id="checy_8193" name="1" value="true" class="ss_form_input" ng-value="LegalCase.ForeclosureInfo.AssigSignedPlace=='NY'">
                        <label for="checy_8193" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>--%>

                        <%--  <input type="radio" id="checy_8194" name="1" value="false" class="ss_form_input">
                        <label for="checy_8194" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>--%>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Third party address Matched</label>
                        <input type="radio" id="checy_8194" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedSignedKnownRS">
                        <label for="checy_8194" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="checy_8195" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AssignedSignedKnownRS">
                        <label for="checy_8195" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>
                    <li class="ss_form_item ss_form_item_line">
                        <label class="ss_form_input_title">note</label>
                        <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AssignmentsNotes"></textarea>
                    </li>
                </ul>

            </div>
        </div>


        <div class="ss_array" style="display: inline;">

            <h4 class="ss_form_title title_with_line  title_after_notes ">
                <span class="title_index title_span">Loan Pool Trust</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples"  onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
            </h4>
            <div class="collapse_div" style="">


                <div class="ss_form">
                    <h4 class="ss_form_title">Trust 
                                                            
                    </h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Trust</label>
                            <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.TrustId')">
                            </div>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Depositor Name</label>
                            <input class="ss_form_input " dx-select-box="InitContact('LegalCase.ForeclosureInfo.DepositorId')">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Trustee</label>
                            <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.TrusteeId')">
                            </div>
                        </li>

                        <li class="ss_form_item">
                            <span class="ss_form_input_title">Trust documentation been located</span>

                            <input type="checkbox" id="check_90" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.TrustDocLocated">
                            <label for="check_90" class="input_with_check ">
                                <span class="box_text">Yes </span>

                            </label>
                        </li>

                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Assignment date</label>
                            <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.TrustDocAssignmentDate">
                        </li>
                        <li class="ss_form_item">
                            <span class="ss_form_input_title">Default date after close</span>

                            <input type="radio" id="check_93" name="1" value="true" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.TrustDefaultDateAfterClose">
                            <label for="check_93" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>

                            <input type="radio" id="check_94" name="1" value="false" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.TrustDefaultDateAfterClose">
                            <label for="check_94" class="input_with_check">
                                <span class="box_text">No</span>
                            </label>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Cutoff Date</label>
                            <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.TrustCutoffDate">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Closing Date</label>
                            <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.TrustClosingDate">
                        </li>
                        <li class="ss_form_item ss_form_item_line">
                            <label class="ss_form_input_title">note</label>
                            <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.LoanPoolTrustNotes"></textarea>
                        </li>
                    </ul>
                </div>



            </div>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Bankruptcy</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">PriorDate</label>
                    <input class="ss_form_input" ss-date="" data-field="LegalCase.ForeclosureInfo.BankruptcyPriorDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">chapter</label>
                    <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.Bankruptcychapter">
                        <option value="7">7</option>
                        <option value="13">13</option>
                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Disposition</label>
                    <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.BankruptcyDisposition">
                </li>
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">note</label>
                    <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.BankruptcyNotes"></textarea>
                </li>
            </ul>
        </div>

        <div class="ss_array" style="display: inline;">

            <h4 class="ss_form_title title_with_line  title_after_notes ">
                <span class="title_index title_span">Statute of Limitation</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples"  onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
                &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
                <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
            </h4>
            <div class="collapse_div" style="">



                <div class="ss_form">
                    <h4 class="ss_form_title">Statute of Limitations</h4>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Prior Plaintiff</label>
                            <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PriorPlaintiffId')">
                            </div>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Prior Plaintiff(Bank) gone out of business</label>
                            <input type="checkbox" id="pdf_check_yes391" name="1" class="ss_form_input" value="true" ng-model="LegalCase.ForeclosureInfo.PriorPlaintiffOutOfBusiness">
                            <label for="pdf_check_yes391" class="input_with_check">
                                <span class="box_text">Yes </span>
                            </label>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Prior Attorney</label>
                            <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PriorPlaintiffId')">
                            </div>
                        </li>


                        <li class="ss_form_item">
                            <label class="ss_form_input_title">LP Date</label>
                            <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LPDate">
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Default Date</label>
                            <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.DefaultDate">
                        </li>
                        <li class="ss_form_item">
                            <span class="ss_form_input_title">In foreclosure </span>

                            <input type="checkbox" id="pdf_check_yes39" name="1" class="ss_form_input" value="true" ng-model="LegalCase.ForeclosureInfo.InForeclosure">
                            <label for="pdf_check_yes39" class="input_with_check">
                                <span class="box_text">Yes </span>
                            </label>

                        </li>

                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Disposition</label>
                            <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.StatuteDisposition">
                                <option>Dismissed</option>
                                <option>Discontinued</option>
                                <option>Abandoned</option>
                                <option>Other</option>

                            </select>
                        </li>
                        <li class="ss_form_item ss_form_item_line">
                            <label class="ss_form_input_title">note</label>
                            <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.StatuteOfLimitationNotes"></textarea>
                        </li>
                    </ul>
                </div>

            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Estate</h4>
                <ul class="ss_form_box clearfix">


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">hold Reason</label>
                        <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateHoldReason">
                            <option>Tenants in common</option>
                            <option>Joint Tenants w/right of survivorship</option>
                            <option>Tenancy by the entirety</option>

                        </select>
                    </li>

                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Estate set up</span>

                        <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateSetUp">
                            <option>Unknown</option>
                            <option>Yes</option>
                            <option>No</option>
                        </select>
                        <%--<input type="checkbox" id="pdf_check_yes103" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check_yes40" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>--%>
                    </li>
                    <li class="ss_form_item">

                        <span class="ss_form_input_title">borrower Died</span>

                        <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateBorrowerDied">
                            <option>Unknown</option>
                            <option>Yes</option>
                            <option>No</option>
                        </select>
                        <%-- <input type="radio" id="pdf_check100" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>
                                                                                    <input type="radio" id="pdf_check101" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Tenancy by the entirety </span>
                                                                                    </label>--%>

                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">prior action</label>

                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                    </li>
                    <li class="ss_form_item ss_form_item_line">
                        <label class="ss_form_input_title">note</label>
                        <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.EstateNotes"></textarea>
                    </li>
                </ul>
            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Defenses/Conclusion</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Defenses/Conclusion</label>
                        <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.DefensesOrConclusion" style="width: 93%">
                    </li>

                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Action Plan</h4>
                <ul class="ss_form_box clearfix">


                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Action Plan</label>
                        <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.ActionPlan" style="width: 93%">
                    </li>

                </ul>
            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Etrack</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item" style="width: 100%">
                        <label class="ss_form_input_title">Etrack</label>
                        <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.Etrack" style="width: 93%">
                    </li>

                </ul>
            </div>
        </div>
    </div>
</div>
