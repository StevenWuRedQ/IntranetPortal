<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionViolationTab.ascx.vb" Inherits="IntranetPortal.ConstructionViolationTab" %>

<div class="ss_form">
    <h4 class="ss_form_title">DOB Violation</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Auto population From DOB Site</label>
                <input class="ss_form_input" type="checkbox" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total DOB Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.TotalDOBViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.TotalOpenViolations">
            </li>
        </ul>
        <ul class="ss_form_box clearfix ss_border">
            <li style="list-style-type: none"><span>Civil Penalty</span></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Owed</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.PenaltyAmountOwed">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Paid</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.DOB.PenaltyDatePaid" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Paid</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.PenaltyAmountPaid">
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">DOB Violaton Num</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.ViolationNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ECB Violation Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.ECBViolationNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Filed Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.DOB.FiledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Violation Status</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.ViolationStatus">
                    <option value="Dismissed">Dismissed</option>
                    <option value="Active">Active</option>
                    <option value="Resolved">Resolved</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Type of Violation</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.TypeOfViolations">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Description</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB.Description">
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.DOB.Notes"></textarea>
        </div>

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">ECB Violation</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Autopopulation From ECB Site</label>
                <input class="ss_form_input" type="checkbox" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total ECB Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.TotalDOBViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.TotalOpenViolations">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DOB Violation Status</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.DOBViolationStatus">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Respondent</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.Respondent">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Hearing Status</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.HearingStatus">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Filed Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.ECB.FiledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Severity</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.Severity">
            </li>
        </ul>
        <ul class="ss_form_box clearfix ss_border">
            <li style="list-style-type: none"><span>ECB Penalty</span></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Due</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.PenaltyDue">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Owed</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.PenaltyAmountOwed">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Paid</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.ECB.PenaltyDatePaid" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Paid</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECB.PenaltyAmountPaid">
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.ECB.Notes"></textarea>
        </div>

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Expeditor</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Assigned Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.Expeditor.AssignedDate" ss-date>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">HPD Violation</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open HPD Violation</label>
                <pt-radio model="CSCase.CSCase.Violations.HPD.OpenHPDViolation" name="CSCase-Violations-HPD-OpenHPDViolation"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Violation Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD.OpenViolationNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Registrant</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD.Registrant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Dismissal Request</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD.DismissalRequest">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Owed</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD.AmountOwed">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Dwelling Classification Fee</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD.DwellingClassificationFee">
                    <option value="250">Private Dwelling (1-2 units)............................................. $ 250</option>
                    <option value="300">Multiple Dwelling (3+ residential units) with 1 - 300 open violations.... $ 300</option>
                    <option value="400">Multiple Dwelling with 301 – 500 open violations......................... $ 400</option>
                    <option value="500">Multiple Dwelling with 501 or more open violations....................... $ 500</option>
                    <option value="1000">Multiple Dwelling Active in the Alternative Enforcement Program (AEP) ... $ 1000</option>
                </select>
            </li>
            </ul>
            <div>
                <label class="ss_form_input_title">Notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.HPD.Notes"></textarea>
            </div>
        
    </div>
</div>


