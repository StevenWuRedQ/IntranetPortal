<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionViolationTab.ascx.vb" Inherits="IntranetPortal.ConstructionViolationTab" %>

<div class="ss_form" ng-init="CSCase.CSCase.Violations.OrdersPanelVisible=false" style="margin-bottom: 30px">
    <h4 class="ss_form_title">Orders<input type="checkbox" ng-model="CSCase.CSCase.Violations.Orders" id="orders" /><label for="orders"></label></h4>
    <div style="text-align: center">
        <span style="padding: 1px 40px; background: red; font-size: 18px; color: white; text-decoration: underline; font-family: arial; font-weight: bold" ng-click="CSCase.CSCase.Violations.OrdersPanelVisible=true">Orders Exists On This Property   </span>
    </div>
    <%--<div dx-popup="{
                                height: auto,
                                width: 900,
                                title: 'Exsiting Orders'
                                dragEnabled: true,
                                showCloseButton: true,
                                shading: false,
                                bindingOptions:{ visible: 'CSCase.CSCase.Violations.OrdersPanelVisible' }
                            }"></div>
        <div data-options="dxTemplate:{ name: 'content' }">
        </div>
    --%>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Expeditor</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Assigned Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.Expeditor_AssignedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Violations.Expeditor_Vendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
        </ul>
    </div>
</div>

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
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_TotalDOBViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_TotalOpenViolations">
            </li>
        </ul>
        <ul class="ss_form_box clearfix ss_border">
            <li style="list-style-type: none; padding: 5px;">
                <h5 class="ss_form_title" style="margin: 3px;">Civil Penalty&nbsp;<pt-add ng-click="ensurePush('CSCase.CSCase.Violations.DOB_Penalty')" /></h5>
                <table class="table table-striped">
                    <tr>
                        <th></th>
                        <th>Due Date</th>
                        <th>Amount Owed</th>
                        <th>Paid Date</th>
                        <th>Amount Paid</th>
                        <th></th>
                    </tr>
                    <tr ng-repeat="penalty in CSCase.CSCase.Violations.DOB_Penalty">
                        <td>{{$index+1}}</td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.DueDate" ss-date></td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.AmountOwed" money-mask></td>
                        <td>
                            <input class="ss_form_input" type="text" ng-model="penalty.PaidDate" ss-date></td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.AmountPaid" money-mask></td>
                        <td>
                            <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.DOB_Penalty, $index, true)"></pt-del>
                        </td>
                    </tr>
                </table>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">DOB Violaton Num</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_ViolationNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ECB Violation Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_ECBViolationNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Filed Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.DOB_FiledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Violation Status</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_ViolationStatus">
                    <option value="Dismissed">Dismissed</option>
                    <option value="Active">Active</option>
                    <option value="Resolved">Resolved</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Type of Violation</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_TypeOfViolations">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Description</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.DOB_Description">
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-DOB_Upload" file-model="CSCase.CSCase.Violations.DOB_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.DOB_Notes"></textarea>
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
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_TotalDOBViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_TotalOpenViolations">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DOB Violation Status</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_DOBViolationStatus">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Respondent</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_Respondent">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Hearing Status</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_HearingStatus">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Filed Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.ECP_FiledDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Severity</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.ECP_Severity">
            </li>
        </ul>


        <ul class="ss_form_box clearfix ss_border">
            <li style="list-style-type: none; padding: 5px;">
                <h5 class="ss_form_title" style="margin: 3px;">ECB Penalty&nbsp;<pt-add ng-click="ensurePush('CSCase.CSCase.Violations.ECB_Penalty')" /></h5>
                <table class="table table-striped">
                    <tr>
                        <th></th>
                        <th>Due Date</th>
                        <th>Amount Owed</th>
                        <th>Paid Date</th>
                        <th>Amount Paid</th>
                        <th></th>
                    </tr>
                    <tr ng-repeat="penalty in CSCase.CSCase.Violations.ECB_Penalty">
                        <td>{{$index+1}}</td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.DueDate" ss-date></td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.AmountOwed" money-mask></td>
                        <td>
                            <input class="ss_form_input" type="text" ng-model="penalty.PaidDate" ss-date></td>
                        <td>
                            <input class="ss_form_input" ng-model="penalty.AmountPaid" money-mask></td>
                        <td>
                            <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.ECB_Penalty, $index, true)"></pt-del>
                        </td>
                    </tr>
                </table>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-ECP_Upload" file-model="CSCase.CSCase.Violations.ECP_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.ECP_Notes"></textarea>
        </div>

    </div>
</div>



<div class="ss_form">
    <h4 class="ss_form_title">HPD Violation</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open HPD Violation</label>
                <pt-radio model="CSCase.CSCase.Violations.HPD_OpenHPDViolation" name="CSCase-Violations-HPD-OpenHPDViolation"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open Violation Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_OpenViolationNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Registrant</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_Registrant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Dismissal Request</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_DismissalRequest">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Owed</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_AmountOwed">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Dwelling Classification Fee</label>
                <select class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_DwellingClassificationFee" ng-change="CSCase.CSCase.Violations.HPD_AmountOwed=CSCase.CSCase.Violations.HPD_DwellingClassificationFee">
                    <option value="250">Private Dwelling (1-2 units)............................................. $ 250</option>
                    <option value="300">Multiple Dwelling (3+ residential units) with 1 - 300 open violations.... $ 300</option>
                    <option value="400">Multiple Dwelling with 301 – 500 open violations......................... $ 400</option>
                    <option value="500">Multiple Dwelling with 501 or more open violations....................... $ 500</option>
                    <option value="1000">Multiple Dwelling Active in the Alternative Enforcement Program (AEP) ... $ 1000</option>
                </select>
            </li>
        </ul>
        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-HPD_Upload" file-model="CSCase.CSCase.Violations.HPD_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.HPD_Notes"></textarea>
        </div>

    </div>
</div>
