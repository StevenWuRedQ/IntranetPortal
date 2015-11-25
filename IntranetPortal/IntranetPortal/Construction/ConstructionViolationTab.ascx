<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionViolationTab.ascx.vb" Inherits="IntranetPortal.ConstructionViolationTab" %>

<%-- orders --%>
<div class="ss_form" ng-init="Violations_OrdersPanelVisible=false">
    <h4 class="ss_form_title">Orders&nbsp;
        <span class="badge">{{getOrdersLength()}}</span>
        <i class="fa fa-pencil icon_btn text-primary" uib-tooltip="edit orders" ng-click="Violations_OrdersPanelVisible=true"></i>
    </h4>
    <div style="text-align: center">
        <div style="text-align: left" ng-show="false" hide-ng-show="(!CSCase.CSCase.Violations.stopWorkOrders || CSCase.CSCase.Violations.stopWorkOrders.length<=0) && (!CSCase.CSCase.Violations.fullVacateOrders || CSCase.CSCase.Violations.fullVacateOrders.length<=0) && (!CSCase.CSCase.Violations.partialVacateOrders || CSCase.CSCase.Violations.partialVacateOrders.length<=0)">
            <button type="button" class="btn btn-danger btn-sm ">Fetch From DOB</button>
            <br />
        </div>
        <span class="barner-danger text-link" ng-click="Violations_OrdersPanelVisible=true" ng-show="CSCase.CSCase.Violations.stopWorkOrders && CSCase.CSCase.Violations.stopWorkOrders.length>0">STOP WORK ORDER EXISTS ON THIS PROPERTY
        <br />
        </span>
        <span class="barner-warning text-link" ng-click="Violations_OrdersPanelVisible=true" ng-show="CSCase.CSCase.Violations.fullVacateOrders && CSCase.CSCase.Violations.fullVacateOrders.length>0">FULL VACATE EXISTS ON THIS PROPERTY
        <br />
        </span>
        <span class="barner-warning text-link" ng-click="Violations_OrdersPanelVisible=true" ng-show="CSCase.CSCase.Violations.partialVacateOrders && CSCase.CSCase.Violations.partialVacateOrders.length>0">PARTIAL VACATE EXISTS ON THIS PROPERTY</span>
    </div>
    <div dx-popup="{
                    height: 800,
                    width: 800,
                    title: 'Exsiting Orders',
                    contentTemplate: 'ordersContent',
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'Violations_OrdersPanelVisible' }
     }">
        <div data-options="dxTemplate:{ name: 'ordersContent' }">
            <div id="Stop_Work_Orders">
                <h4>Stop Work Orders&nbsp;<pt-add ng-click="ensurePush('CSCase.CSCase.Violations.stopWorkOrders')" /></h4>
                <table class="table table-striped" style="font-size: 9pt; width: 750px; margin: 10px; table-layout: fixed;">
                    <tr>
                        <th>Complaint Number</th>
                        <th style="width: 200px">Address</th>
                        <th>Date Entered</th>
                        <th>Category</th>
                        <th>Inspection Date</th>
                        <th>Disposition</th>
                        <th>Status</th>
                        <th style="width: 15px"></th>
                    </tr>
                    <tr ng-repeat="stopWorkOrder in CSCase.CSCase.Violations.stopWorkOrders">
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.CompliantNum" /></td>
                        <td style="width: 200px">
                            <input class="table-input" type="text" ng-model="stopWorkOrder.Address" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.DateEntered" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.Category" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.InspectionDate" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.CompliantNumDisposition" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrder.Status" /></td>
                        <td style="width: 15px">
                            <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.stopWorkOrders, $index, true)" />
                        </td>
                    </tr>
                </table>
            </div>
            <hr />
            <div id="FULL_VACATE_Orders">
                <h4>Full VACATE Orders&nbsp;<pt-add ng-click="ensurePush('CSCase.CSCase.Violations.fullVacateOrders')" /></h4>
                <table class="table table-striped" style="font-size: 9pt; width: 750px; margin: 10px; table-layout: fixed;">
                    <tr>
                        <th>Complaint Number</th>
                        <th style="width: 200px">Address</th>
                        <th>Date Entered</th>
                        <th>Category</th>
                        <th>Inspection Date</th>
                        <th>Disposition</th>
                        <th>Status</th>
                        <th style="width: 15px"></th>
                    </tr>
                    <tr ng-repeat="order in CSCase.CSCase.Violations.fullVacateOrders">
                        <td>
                            <input class="table-input" type="text" ng-model="order.CompliantNum" /></td>
                        <td style="width: 200px">
                            <input class="table-input" type="text" ng-model="order.Address" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.DateEntered" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.Category" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.InspectionDate" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.CompliantNumDisposition" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrderorder.Status" /></td>
                        <td style="width: 15px">
                            <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.fullVacateOrders, $index, true)" />
                        </td>
                    </tr>
                </table>
            </div>
            <hr />
            <div id="Partial_VACATE_Orders">
                <h4>Partial VACATE Orders&nbsp;<pt-add ng-click="ensurePush('CSCase.CSCase.Violations.partialVacateOrders')" /></h4>
                <table class="table table-striped" style="font-size: 9pt; width: 750px; margin: 10px; table-layout: fixed;">
                    <tr>
                        <th>Complaint Number</th>
                        <th style="width: 200px">Address</th>
                        <th>Date Entered</th>
                        <th>Category</th>
                        <th>Inspection Date</th>
                        <th>Disposition</th>
                        <th>Status</th>
                        <th style="width: 15px"></th>
                    </tr>
                    <tr ng-repeat="order in CSCase.CSCase.Violations.partialVacateOrders">
                        <td>
                            <input class="table-input" type="text" ng-model="order.CompliantNum" /></td>
                        <td style="width: 200px">
                            <input class="table-input" type="text" ng-model="order.Address" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.DateEntered" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.Category" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.InspectionDate" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="order.CompliantNumDisposition" /></td>
                        <td>
                            <input class="table-input" type="text" ng-model="stopWorkOrderorder.Status" /></td>
                        <td style="width: 15px">
                            <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.partialVacateOrders, $index, true)" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Expeditor&nbsp;<pt-collapse model="ReloadedData.Expeditor_Collapsed" /></h4>
    <div class="ss_border" uib-collapse="!ReloadedData.Expeditor_Collapsed">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Project Assigned Date</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.Violations.Expeditor_AssignedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor Company</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Violations.Expeditor_VendorCompany">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor Person</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Violations.Expeditor_Vendor" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor Phone</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Violations.Expeditor_VendorPhone" mask="(999) 999-9999" clean="true">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor Email</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.Violations.Expeditor_VendorEmail">
            </li>

        </ul>
    </div>
</div>

<%--DOBViolations --%>
<div class="ss_form">
    <h4 class="ss_form_title">DOB Violations&nbsp;<pt-collapse model="ReloadedData.DOBViolation_Collapse"></pt-collapse></h4>
    <div class="ss_border" uib-collapse="ReloadedData.DOBViolation_Collapse">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Auto population From DOB Site</label>
                <button type="button" class="btn btn-danger btn-sm " ng-click="fetchDOBViolations()">Fetch From DOB</button>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total DOB Violations</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.DOB_TotalDOBViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.DOB_TotalOpenViolations">
            </li>
        </ul>

        <ul id="civil_penalty" class="ss_form_box clearfix ss_border">
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

        <ul id="dob_violation" class="ss_form_box clearfix ss_border">
            <h5 class="ss_form_title" style="margin: 3px;">DOB Violations&nbsp;<pt-add ng-click="addNewDOBViolation()" /></h5>
            <table class="table table-striped">
                <tr ng-repeat="violation in CSCase.CSCase.Violations.DOBViolations">
                    <td class="col-sm-1" ng-click="setPopupVisible('DOBViolations_PopupVisible_'+$index, true)">{{$index+1}}</td>
                    <td class="col-sm-5" ng-click="setPopupVisible('DOBViolations_PopupVisible_'+$index, true)">
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>DOB Violaton #</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.DOBViolationNum}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Filed Date</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.FiledDate}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Type of Violation</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.TypeOfViolations}}</div>
                        </div>

                    </td>
                    <td class="col-sm-5" ng-click="setPopupVisible('DOBViolations_PopupVisible_'+$index, true)">
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>ECB Violation #</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.ECBViolationNumber}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Violation Status</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.ViolationStatus}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Description</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.Description}}</div>
                        </div>

                    </td>
                    <td class="col-sm-1">
                        <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.DOBViolations, $index, true)"></pt-del>
                        <div dx-popup="{    
                                height: 600,
                                width: 600, 
                                title: 'Violation '+ ($index+1),
                                dragEnabled: true,
                                showCloseButton: true,
                                shading: false,
                                bindingOptions:{ visible: 'DOBViolations_PopupVisible_'+$index },
                                scrolling: {mode: 'virtual' },
                            }">
                            <div data-options="dxTemplate:{ name: 'content' }">
                                <div style="height: 88%; padding: 0 5px; overflow-y: auto; overflow-x: hidden">

                                    <div class="col-sm-6">
                                        <label>DOB Violaton Num</label>
                                        <input class="form-control" ng-model="violation.DOBViolationNum" />
                                    </div>


                                    <div class="col-sm-6">
                                        <label>ECB Violation Number</label>
                                        <input class="form-control" ng-model="violation.ECBViolationNumber" />
                                    </div>


                                    <div class="col-sm-6">
                                        <label>Filed Date</label>
                                        <input class="form-control" ng-model="violation.FiledDate" ss-date />
                                    </div>

                                    <div class="col-sm-6">
                                        <label>Violation Status</label>
                                        <input class="form-control" ng-model="violation.ViolationStatus" />
                                    </div>

                                    <div class="col-sm-6">
                                        <label>Type of Violation</label>
                                        <input class="form-control" ng-model="violation.TypeOfViolations" />
                                    </div>

                                    <div class="clearfix"></div>
                                    <div class="col-sm-12">
                                        <label>Description</label>
                                        <textarea class="form-control" ng-model="violation.Description" style="resize: none; height: 100"></textarea>
                                    </div>
                                    <div class="clearfix"></div>
                                    <hr />
                                    <button class="btn btn-primary pull-right" ng-click="setPopupVisible('DOBViolations_PopupVisible_'+$index, false)">Close</button>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ul>


        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-DOB_Upload" file-model="CSCase.CSCase.Violations.DOB_Upload" folder-enable="true" base-folder="Violations-DOB_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.DOB_Notes"></textarea>
        </div>
    </div>
</div>

<%--ECBViolations --%>
<div class="ss_form">
    <h4 class="ss_form_title">ECB Violations&nbsp;<pt-collapse model="ReloadedData.ECBViolations_Collapse"></pt-collapse></h4>
    <div class="ss_border" uib-collapse="ReloadedData.ECBViolations_Collapse">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Autopopulation From ECB Site</label>
                <button type="button" class="btn btn-danger btn-sm" ng-click="fetchECBViolations()">Fetch From DOB</button>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total ECB Violations</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.ECP_TotalViolation">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Total Open Violations</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.ECP_TotalOpenViolations">
            </li>
        </ul>

        <ul id="ecb_penalty" class="ss_form_box clearfix ss_border">
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

        <ul id="ecb_violations" class="ss_form_box clearfix ss_border">
            <h5 class="ss_form_title" style="margin: 3px;">ECB Violations&nbsp;<pt-add ng-click="addNewECBViolation()" /></h5>
            <table class="table table-striped">
                <tr ng-repeat="violation in CSCase.CSCase.Violations.ECBViolations">
                    <td class="col-sm-1" ng-click="setPopupVisible('ECBViolations_PopupVisible_'+$index, true)">{{$index+1}}</td>
                    <td class="col-sm-5" ng-click="setPopupVisible('ECBViolations_PopupVisible_'+$index, true)">
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>ECB Violaton #</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.ECBViolationNum}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Respondent</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.Respondent}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Filed Date</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.FiledDate}}</div>
                        </div>

                    </td>
                    <td class="col-sm-5" ng-click="setPopupVisible('ECBViolations_PopupVisible_'+$index, true)">
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>DOB Violation Status</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.DOBViolationStatus}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Hearing Status</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.HearingStatus}}</div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5" style="padding: 0"><b>Severity</b></div>
                            <div class="col-sm-7" style="padding: 0">{{violation.Severity}}</div>
                        </div>

                    </td>
                    <td class="col-sm-1">
                        <pt-del ng-click="arrayRemove(CSCase.CSCase.Violations.ECBViolations, $index, true)"></pt-del>
                        <div dx-popup="{    
                                height: 450,
                                width: 600, 
                                title: 'Violation '+ ($index+1),
                                dragEnabled: true,
                                showCloseButton: true,
                                shading: false,
                                bindingOptions:{ visible: 'ECBViolations_PopupVisible_'+$index },
                                scrolling: {mode: 'virtual' },
                            }">
                            <div data-options="dxTemplate:{ name: 'content' }">
                                <div style="height: 88%; padding: 0 5px; overflow-y: auto; overflow-x: hidden">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <label>ECB Violaton #</label>
                                            <input class="form-control" ng-model="violation.ECBViolationNum" />
                                        </div>


                                        <div class="col-sm-6">
                                            <label>DOB Violation Status</label>
                                            <input class="form-control" ng-model="violation.DOBViolationStatus" />
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <label>Respondent</label>
                                            <input class="form-control" ng-model="violation.Respondent" />
                                        </div>

                                        <div class="col-sm-6">
                                            <label>Hearing Status</label>
                                            <input class="form-control" ng-model="violation.HearingStatus" />
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <label>Filed Date</label>
                                            <input class="form-control" ng-model="violation.FiledDate" ss-date />
                                        </div>

                                        <div class="col-sm-6">
                                            <label>Severity</label>
                                            <input class="form-control" ng-model="violation.Severity" />
                                        </div>
                                    </div>
                                    <hr />
                                    <button class="btn btn-primary pull-right" ng-click="setPopupVisible('ECBViolations_PopupVisible_'+$index, false)">Close</button>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </ul>

        <div>
            <label class="ss_form_input_title">Upload</label>
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-ECP_Upload" file-model="CSCase.CSCase.Violations.ECP_Upload" folder-enable="true" base-folder="Violations-ECP_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.ECP_Notes"></textarea>
        </div>

    </div>
</div>
<%--HPDViolations --%>
<div class="ss_form">
    <h4 class="ss_form_title">HPD Violation&nbsp;<pt-collapse model="ReloadedData.HPDViolations_Collapse"></pt-collapse></h4>
    <div class="ss_border" uib-collapse="ReloadedData.HPDViolations_Collapse">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Open HPD Violation</label>
                <pt-radio model="CSCase.CSCase.Violations.HPD_OpenHPDViolation" name="CSCase-Violations-HPD-OpenHPDViolation"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">number of open violations</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.HPD_OpenViolationNumber">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Registration Number</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_RegNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Registrant</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_Registrant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Registration Expiration Date</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.HPD_RegExpireDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Dismissal Request</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.Violations.HPD_DismissalRequest" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount Owed</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.HPD_AmountOwed" money-mask>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Dwelling Classification Fee</label>
                <select class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.Violations.HPD_DwellingClassificationFee" ng-change="CSCase.CSCase.Violations.HPD_AmountOwed=CSCase.CSCase.Violations.HPD_DwellingClassificationFee">
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
            <pt-files file-bble="CSCase.BBLE" file-id="Violations-HPD_Upload" file-model="CSCase.CSCase.Violations.HPD_Upload" folder-enable="true" base-folder="Violations-HPD_Upload"></pt-files>
        </div>
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.HPD_Notes"></textarea>
        </div>

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Cure</h4>
    <div class="ss_border">
        <div>
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="CSCase.CSCase.Violations.Cure_Notes"></textarea>
        </div>
    </div>
</div>
