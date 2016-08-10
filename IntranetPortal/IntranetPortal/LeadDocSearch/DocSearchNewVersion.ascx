<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="DocSearchNewVersion.ascx.vb" Inherits="IntranetPortal.DocSearchNewVersion" %>
<div class="tab-content">
    <div class="tab-pane active" id="LegalTab">

        <div style="overflow: auto; height: 830px; padding: 0 20px">

            <div class="alert alert-warning" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status != 1">
                <i class="fa fa-warning"></i><strong>Warning!</strong> Document search didn't completed yet!
            </div>
            <div class="alert alert-success" style="margin-top: 20px; font-size: 16px" ng-show="DocSearch.Status == 1 && DocSearch.CompletedOn">
                Document search completed on {{DocSearch.CompletedOn|date:'shortDate'}} by {{DocSearch.CompletedBy}}!
            </div>



            <%----------------------------Request Info----------------------------------------%>
            <div class="ss_form">
                <h4 class="ss_form_title ">Request Info
                    <pt-collapse model="CollapseRequestInfo" />
                </h4>
                <div class="ss_border" collapse="CollapseRequestInfo">
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested On</label><input class="ss_form_input" ng-model="DocSearch.CreateDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Team</label>
                            <input class="ss_form_input" ng-model="DocSearch.team" readonly="readonly" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Requested By</label><input class="ss_form_input" ng-model="DocSearch.CreateBy" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Block</label><input class="ss_form_input" ng-model="LeadsInfo.Block" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Lot</label><input class="ss_form_input" ng-model="LeadsInfo.Lot" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Expected Signing Date</label><input class="ss_form_input" ng-model="DocSearch.ExpectedSigningDate" ss-date disabled="disabled" /></li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Property Addressed</label><input class="ss_form_input" ng-model="LeadsInfo.PropertyAddress" readonly="readonly" /></li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner Name</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerName" />
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title">Owner SSN</label><input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerSSN" />
                        </li>
                        <li class="ss_form_item " style="width: 97%">
                            <label class="ss_form_input_title">Owner Address</label>
                            <input class="ss_form_input" ng-model="DocSearch.LeadResearch.ownerAddress" />
                        </li>
                    </ul>
                </div>
            </div>
            <%-----------------------End Request Info----------------------------------------%>

            <%--- new version should have sub title so need deleted all ---%>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Geodata</label>
                    <button class="btn btn-secondary" type="button">
                        <a href="http://www.geodataplus.com/" target="_blank">Go to Geodata</a>

                    </button>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title ">Acris</label>
                    <button class="btn btn-secondary" type="button">
                        <a href="https://a836-acris.nyc.gov/DS/DocumentSearch/BBL" target="_blank">Go to Acris</a>
                    </button>
                </li>

            </ul>
            <div class="ss_form  ">
                <h4 class="ss_form_title ">Ownership Mortgage Info
                    <pt-collapse model="DocSearch.LeadResearch.Ownership_Mortgage_Info"> </pt-collapse>
                </h4>
                <div class="ss_border" collapse="DocSearch.LeadResearch.Ownership_Mortgage_Info">
                    

                    <div class="ss_form ">

                        <h5 class="ss_form_title ">Purchase Deed
                            <pt-collapse model="DocSearch.LeadResearch.PurchaseDeed"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.PurchaseDeed">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Purchase Deed</label>
                                    <pt-radio name="OwnershipMortgageInfo_HasDeed0" model="DocSearch.LeadResearch.Has_Deed"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Date of Deed</label>
                                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Date_of_Deed">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Party 1</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_1">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Party 2</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_2">
                                </li>

                            </ul>
                        </div>

                    </div>
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Has 1st Mortgage</label>
                            <pt-radio name="OwnershipMortgageInfo_Hasc1stMortgage0" model="DocSearch.LeadResearch.Has_c_1st_Mortgage"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">1st Mortgage Amount</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.c_1st_Mortgage_Amount">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">FHA</label>
                            <pt-radio name="DocSearchFHA0" model="DocSearch.LeadResearch.HasFHA"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Has 2nd Mortgage Amount</label>
                            <pt-radio name="OwnershipMortgageInfo_Hasc2ndMortgageAmount0" model="DocSearch.LeadResearch.Has_c_2nd_Mortgage_Amount"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">2nd Mortgage Amount</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.c_2nd_Mortgage_Amount">
                        </li>


                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">has Last Assignment</label>
                            <pt-radio name="OwnershipMortgageInfo_hasLastAssignment0" model="DocSearch.LeadResearch.has_Last_Assignment"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Last Assignment date</label>
                            <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Last_Assignment_date">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Last Assignment Assigned To</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Last_Assignment_Assigned_To">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">LP Index number</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.LP_Index_number">
                        </li>
                        <li class="ss_form_item  ss_form_item_line">
                            <label class="ss_form_input_title ">LP Index notes</label>
                            <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.LP_Index_notes"></textarea>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Servicer</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Servicer">
                        </li>
                        <li class="ss_form_item  ss_form_item_line">
                            <label class="ss_form_input_title ">Servicer notes</label>
                            <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.Servicer_notes"></textarea>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Fannie</label>
                            <pt-radio name="OwnershipMortgageInfo_Fannie0" model="DocSearch.LeadResearch.Fannie"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Freddie Mac </label>
                            <pt-radio name="OwnershipMortgageInfo_FreddieMac0" model="DocSearch.LeadResearch.Freddie_Mac_"></pt-radio>
                        </li>
                    </ul>

                </div>
            </div>


            <div class="ss_form  ">
                <h4 class="ss_form_title ">Property Dues Violations
                    <pt-collapse model="DocSearch.LeadResearch.Property_Dues_Violations"> </pt-collapse>
                </h4>
                <div class="ss_border" collapse="DocSearch.LeadResearch.Property_Dues_Violations">
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Property Taxes per YR</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Property_Taxes_per_YR">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Has Property Taxes Due</label>
                            <pt-radio name="PropertyDuesViolations_HasPropertyTaxesDue0" model="DocSearch.LeadResearch.Has_Property_Taxes_Due"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Property Taxes Due</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Property_Taxes_Due">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Has Water Charges Due</label>
                            <pt-radio name="PropertyDuesViolations_HasWaterChargesDue0" model="DocSearch.LeadResearch.Has_Water_Charges_Due"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Water Charges Due</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Water_Charges_Due">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Violoations Open</label>
                            <pt-radio name="PropertyDuesViolations_ECBVioloationsOpen0" model="DocSearch.LeadResearch.ECB_Violoations_Open"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Violoations Count</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.ECB_Violoations_Count">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Violoations Amount</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.ECB_Violoations_Amount">
                        </li>

                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">DOB Violoations Open</label>
                            <pt-radio name="PropertyDuesViolations_DOBVioloationsOpen0" model="DocSearch.LeadResearch.DOB_Violoations_Open"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">DOB Violoations Count</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.DOB_Violoations_Count">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">DOB Violoations Amount</label>
                            <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.DOB_Violoations_Amount">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Tax Classification</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Tax_Classification">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">C/O</label>
                            <pt-radio name="PropertyDuesViolations_CO0" model="DocSearch.LeadResearch.C_O"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">number of Units</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.number_of_Units">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Number of Units</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Number_of_Units">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Has HPD Violations</label>
                            <pt-radio name="PropertyDuesViolations_HasHPDViolations0" model="DocSearch.LeadResearch.Has_HPD_Violations"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations A Class</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations_A_Class">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations B Class</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations_B_Class">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations C Class</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations_C_Class">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations I Class</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations_I_Class">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Charges Not Paid Transferred</label>
                            <pt-radio name="PropertyDuesViolations_HPDChargesNotPaidTransferred0" model="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred"></pt-radio>
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Charges Amount</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Charges_Amount" money-mask>
                        </li>
                    </ul>
                </div>
            </div>

        </div>

    </div>
</div>
