<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionSignoffsTab.ascx.vb" Inherits="IntranetPortal.ConstructionSignoffsTab" %>
<div>
    <div class="ss_form">

        <h4 class="ss_form_title">Plumbing</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Permit is Issued</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.PlumbingDatePremitIssued">
                </li>
                <li class="ss_form_item2">
                    <div style="float: left">
                        <label class="ss_form_input_title">Schedule B</label>
                        <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Plumbing_ScheduleB" file-model="CSCase.CSCase.Signoffs.Plumbing_ScheduleB"></pt-file>
                    </div>
                    <div style="float: left; margin-left: 50px">
                        <label class="ss_form_input_title">PW2</label>
                        <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Plumbing_ScheduleB" file-model="CSCase.CSCase.Signoffs.Plumbing_PW2"></pt-file>
                    </div>
                    <div style="float: left; margin-left: 50px">
                        <label class="ss_form_input_title">Permit</label>
                        <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Plumbing_ScheduleB" file-model="CSCase.CSCase.Signoffs.Plumbing_Permit"></pt-file>
                    </div>
                </li>


                <li class="ss_form_item3" style="font-size: 12px; height: auto">
                    <label class="ss_form_input_title">Inspection</label>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Inspection</th>
                                <th>Date</th>
                                <th>Re-inspection Date</th>
                                <th>Remider me</th>
                                <th>Passed Inspection</th>
                            </tr>
                        </thead>
                        <tr>
                            <td>Roughing</td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Roughing_InspectionDate" ss_date></td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Roughing_Reinspection" ss_date></td>
                            <td>
                                <button class="btn" type="button">Remider me</button></td>
                            <td>
                                <select class="form-control" ng-model="CSCase.CSCase.Signoffs.Roughing_Passed">
                                    <option>Yes</option>
                                    <option>No</option>
                                </select>
                            </td>
                        </tr>
                        <tr ng-show="CSCase.CSCase.Signoffs.Roughing_Passed=='No'">
                            <td></td>
                            <td colspan="4">
                                <label class="ss_form_input_title">Upload Objections</label>
                                <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Roughing_Objection" file-model="CSCase.CSCase.Signoffs.Roughing_Objection"></pt-files>
                            </td>
                        </tr>
                        <tr>
                            <td>Gas Test</td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Gas_InspectionDate" ss_date></td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Gas_Reinspection" ss_date></td>
                            <td>
                                <button class="btn" type="button">Remider me</button></td>
                            <td>
                                <select class="form-control" ng-model="CSCase.CSCase.Signoffs.Gas_Passed">
                                    <option>Yes</option>
                                    <option>No</option>
                                </select>
                            </td>
                        </tr>
                        <tr ng-show="CSCase.CSCase.Signoffs.Gas_Passed=='No'">
                            <td></td>
                            <td colspan="4">
                                <label class="ss_form_input_title">Upload Objections</label>
                                <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Gas_Objection" file-model="CSCase.CSCase.Signoffs.Gas_Objection"></pt-files>
                            </td>
                        </tr>
                        <tr>
                            <td>Hydrant Flow test</td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Hydrant_InspectionDate" ss_date></td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.Hydrant_Reinspection" ss_date></td>
                            <td>
                                <button class="btn" type="button">Remider me</button></td>
                            <td>
                                <select class="form-control" ng-model="CSCase.CSCase.Signoffs.Hydrant_Passed">
                                    <option>Yes</option>
                                    <option>No</option>
                                </select>
                            </td>
                        </tr>
                        <tr ng-show="CSCase.CSCase.Signoffs.Hydrant_Passed=='No'">
                            <td></td>
                            <td colspan="4">
                                <label class="ss_form_input_title">Upload Objections</label>
                                <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Hydrant_Objection" file-model="CSCase.CSCase.Signoffs.Hydrant_Objection"></pt-files>
                            </td>
                        </tr>
                        <tr>
                            <td>RPZ test</td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.RPZ_InspectionDate" ss_date></td>
                            <td>
                                <input class="form-control" ng-model="CSCase.CSCase.Signoffs.RPZ_Reinspection" ss_date></td>
                            <td>
                                <button class="btn" type="button">Remider me</button></td>
                            <td>
                                <select class="form-control" ng-model="CSCase.CSCase.Signoffs.RPZ_Passed">
                                    <option>Yes</option>
                                    <option>No</option>
                                </select>
                            </td>
                        </tr>
                        <tr ng-show="CSCase.CSCase.Signoffs.RPZ_Passed=='No'">
                            <td></td>
                            <td colspan="4">
                                <label class="ss_form_input_title">Upload Objections</label>
                                <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_PAA_File" file-model="CSCase.CSCase.Signoffs.PAA_File"></pt-file>
                            </td>
                        </tr>
                    </table>
                </li>
            </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">OP98</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_OP98" file-model="CSCase.CSCase.Signoffs.OP98">Upload</pt-file>
                </li>
            </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">PAA&nbsp;<pt-collapse model="Signoffs_PAAcollapse" /></label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_PAA_File" file-model="CSCase.CSCase.Signoffs.PAA_File"></pt-file>
                </li>
            </ul>
            <div class="cssSlideUp" collapse="Signoffs_PAAcollapse">
                <div class="arrow_box">
                    <div class="ss_form">
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item">
                                <label class="ss_form_input_title">date fee paid</label>
                                <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.PAA_PayFeeDate" ss-date>
                            </li>
                            <li class="ss_form_item">
                                <label class="ss_form_input_title">Date Approval</label>
                                <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.PAA_DateApproval" ss-date>
                            </li>
                        </ul>
                    </div>

                </div>
            </div>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">LAA</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_LAA_File" file-model="CSCase.CSCase.Signoffs.LAA_File"></pt-file>
                </li>
            </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Plumbing job signed off date</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.Plumbing_SignedOffDate">
                </li>
            </ul>

            <div>
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.CSCase.Signoffs.PlumbingNotes"></textarea>
            </div>


        </div>
    </div>


    <div class="ss_form">
        <h4 class="ss_form_title title_after_notes">Electrical</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Permit was pulled</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_PermitPulled" ss-date>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">PW2</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Electrical_PW2" file-model="CSCase.CSCase.Signoffs.Electrical_PW2"></pt-file>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Permit</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Electrical_Permit" file-model="CSCase.CSCase.Signoffs.Electrical_Permit"></pt-file>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Inspection date requested</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.Electrical_InspectionRequestedDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">date of inspection</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_InspectionDate">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">completion fee</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_CompletedFee">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Amount due</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_AmountDue">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date paid</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.ElectricalDatePaid">
                </li>
            </ul>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">results</label>
                    <select class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_InspectionResults">
                        <option></option>
                        <option>Passed</option>
                        <option>Failed</option>
                    </select>
                </li>
            </ul>

            <div class="cssSlideUp" ng-show="CSCase.CSCase.Signoffs.Electrical_InspectionResults=='Failed'">
                <div class="arrow_box">

                    <div>
                        <label class="ss_form_input_title">Objections Upload</label>
                        <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Electrical_Objections_Upload" file-model="CSCase.CSCase.Signoffs.Electrical_Objections_Upload"></pt-files>
                    </div>

                    <span class="ss_form_item">
                        <label class="ss_form_input_title">Objection Resolved Date</label>
                        <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_Objection_Resolved_Date" ss-date>
                    </span>
                    <span class="ss_form_item">
                        <label class="ss_form_input_title">Reinspection Date</label>
                        <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Electrical_Reinspection_Date" ss-date>
                    </span>

                </div>
            </div>

            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">date electric signed off</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.Electrical_SignedOffDate">
                </li>
            </ul>

            <div>
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.CSCase.Signoffs.Electrical_Note"></textarea>
            </div>

        </div>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title title_after_notes">Construction</h4>
        <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Permit was pulled</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Construction_PermitPulledDate" ss-date>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">PW2</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Construction_PW2" file-model="CSCase.CSCase.Signoffs.Construction_PW2"></pt-file>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Permit</label>
                    <pt-file file-bble="CSCase.BBLE" file-id="Signoffs_Construction_Permit" file-model="CSCase.CSCase.Signoffs.Construction_Permit"></pt-file>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date inspection was requested</label>
                    <input class="ss_form_input" ss-date ng-model="CSCase.CSCase.Signoffs.Construction_InspectionRequestedDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Inspection date</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Construction_InspectionDate">
                </li>
            </ul>
            <div>
                <label class="ss_form_input_title">Construction Report</label>
                <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Construction_Report" file-model="CSCase.CSCase.Signoffs.Construction_Report"></pt-files>
            </div>


            <div>
                <label class="ss_form_input_title">Objections</label>
                <pt-files file-bble="CSCase.BBLE" file-id="Signoffs_Construction_Objecteions" file-model="CSCase.CSCase.Signoffs.Construction_Objecteions"></pt-files>
            </div>

            <div>
                <label class="ss_form_input_title">Construction job Signed off date</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Signoffs.Construction_SignedOffDate" ss-date>
            </div>

            <div>
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="CSCase.CSCase.Signoffs.Construction_Notes"></textarea>
            </div>
        </div>
    </div>
</div>
