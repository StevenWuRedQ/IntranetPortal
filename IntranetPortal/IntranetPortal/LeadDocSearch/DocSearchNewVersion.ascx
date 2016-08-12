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
                    <pt-collapse model="DocSearch.LeadResearch.Ownership_Mortgage_Info">                            </pt-collapse>
                </h4>
                <div class="ss_border" collapse="DocSearch.LeadResearch.Ownership_Mortgage_Info">
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Purchase Deed                                       
                            <pt-collapse model="DocSearch.LeadResearch.Purchase_Deed_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Purchase_Deed_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Deed</label>
                                    <pt-radio name="OwnershipMortgageInfo_HasDeed0" model="DocSearch.LeadResearch.Has_Deed_Purchase_Deed"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Date of Deed</label>
                                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Date_of_Deed_Purchase_Deed">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Party 1</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_1_Purchase_Deed">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Party 2</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Party_2_Purchase_Deed">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">1st Mortgage                                       
                            <pt-collapse model="DocSearch.LeadResearch.c_1st_Mortgage_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.c_1st_Mortgage_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has 1st Mortgage</label>
                                    <pt-radio name="OwnershipMortgageInfo_Hasc1stMortgage0" model="DocSearch.LeadResearch.Has_c_1st_Mortgage_c_1st_Mortgage"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_c_1st_Mortgage">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">2nd Mortgage                                       
                            <pt-collapse model="DocSearch.LeadResearch.c_2nd_Mortgage_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.c_2nd_Mortgage_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has 2nd Mortgage</label>
                                    <pt-radio name="OwnershipMortgageInfo_Hasc2ndMortgage0" model="DocSearch.LeadResearch.Has_c_2nd_Mortgage_c_2nd_Mortgage"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_c_2nd_Mortgage">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Last Assignment                                       
                            <pt-collapse model="DocSearch.LeadResearch.Last_Assignment_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Last_Assignment_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has Last Assignment</label>
                                    <pt-radio name="OwnershipMortgageInfo_hasLastAssignment0" model="DocSearch.LeadResearch.has_Last_Assignment_Last_Assignment"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Assignment date</label>
                                    <input class="ss_form_input " ss-date ng-model="DocSearch.LeadResearch.Assignment_date_Last_Assignment">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Assigned To</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Assigned_To_Last_Assignment">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">LP Index #                                       
                            <pt-collapse model="DocSearch.LeadResearch.LP_Index___Num_Ownership_Mortgage_Info"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.LP_Index___Num_Ownership_Mortgage_Info">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">LP Index #</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.LP_Index___Num_LP_Index___Num">
                                </li>
                                <li class="ss_form_item  ss_form_item_line">
                                    <label class="ss_form_input_title ">notes</label>
                                    <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.notes_LP_Index___Num"></textarea>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <ul class="ss_form_box clearfix">
                       <%-- <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Purchase Deed</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Purchase_Deed">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">1st Mortgage</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.c_1st_Mortgage">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">2st Mortgage</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.c_2nd_Mortgage">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Last Assignment</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Last_Assignment">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">LP Index#</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.LP_Index___Num">
                        </li>--%>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Servicer</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Servicer">
                        </li>
                        <li class="ss_form_item  ss_form_item_line">
                            <label class="ss_form_input_title ">Servicer notes</label>
                            <textarea class="edit_text_area text_area_ss_form " model="DocSearch.LeadResearch.Servicer_notes"></textarea>
                        </li>
                         <li class="ss_form_item ">
                            <label class="ss_form_input_title ">FHA</label>
                            <pt-radio name="OwnershipMortgageInfo_FHA0" model="DocSearch.LeadResearch.FHA"></pt-radio>
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
                    <pt-collapse model="DocSearch.LeadResearch.Property_Dues_Violations">                            </pt-collapse>
                </h4>
                <div class="ss_border" collapse="DocSearch.LeadResearch.Property_Dues_Violations">
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Property Taxes                                       
                            <pt-collapse model="DocSearch.LeadResearch.Property_Taxes_Due_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Property_Taxes_Due_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Property Taxes per YR</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Property_Taxes_per_YR_Property_Taxes_Due">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Due</label>
                                    <pt-radio name="PropertyDuesViolations_HasDue0" model="DocSearch.LeadResearch.Has_Due_Property_Taxes_Due"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Due Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Due_Property_Taxes_Due">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Water Charges Due                                       
                            <pt-collapse model="DocSearch.LeadResearch.Water_Charges_Due_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Water_Charges_Due_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Due</label>
                                    <pt-radio name="PropertyDuesViolations_HasDue0" model="DocSearch.LeadResearch.Has_Due_Water_Charges_Due"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Due Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Due_Water_Charges_Due">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB Violoations                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_Violoations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.ECB_Violoations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Open</label>
                                    <pt-radio name="PropertyDuesViolations_HasOpen0" model="DocSearch.LeadResearch.Has_Open_ECB_Violoations"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_Violoations">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Amount_ECB_Violoations">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">DOB Violoations                                       
                            <pt-collapse model="DocSearch.LeadResearch.DOB_Violoations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.DOB_Violoations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Open</label>
                                    <pt-radio name="PropertyDuesViolations_HasOpen0" model="DocSearch.LeadResearch.Has_Open_DOB_Violoations"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_DOB_Violoations">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Amount_DOB_Violoations">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">C O                                       
                            <pt-collapse model="DocSearch.LeadResearch.C_O_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.C_O_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has CO</label>
                                    <pt-radio name="PropertyDuesViolations_Has CO0" model="DocSearch.LeadResearch.Has_C_O_Property_Dues_Violations"></pt-radio>
                                    
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title "># of Units</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.___Num_of_Units_C_O">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Violations                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Violations_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.HPD_Violations_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Has Violations</label>
                                    <pt-radio name="PropertyDuesViolations_HasViolations0" model="DocSearch.LeadResearch.Has_Violations_HPD_Violations"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">A Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.A_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">B Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.B_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">C Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.C_Class_HPD_Violations">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">I Class</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.I_Class_HPD_Violations">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Charges Not Paid Transferred                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred_Property_Dues_Violations"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred_Property_Dues_Violations">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Open Amount</label>
                                    <pt-radio name="PropertyDuesViolations_OpenAmount0" model="DocSearch.LeadResearch.Open_Amount_HPD_Charges_Not_Paid_Transferred"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Open Amount</label>
                                    <input class="ss_form_input " money-mask ng-model="DocSearch.LeadResearch.Open_Amount_HPD_Charges_Not_Paid_Transferred">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <ul class="ss_form_box clearfix">
                       <%-- <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Property Taxes Due</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Property_Taxes_Due">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Water Charges Due</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Water_Charges_Due">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Violoations</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.ECB_Violoations">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">DOB Violoations</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.DOB_Violoations">
                        </li>--%>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Tax Classification</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Tax_Classification">
                        </li>
                       <%-- <li class="ss_form_item ">
                            <label class="ss_form_input_title ">C O</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.C_O">
                        </li>--%>
                       <%-- <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Number of Units</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Number_of_Units">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Violations</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Violations">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Charges Not Paid Transferred</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Charges_Not_Paid_Transferred">
                        </li>--%>
                    </ul>
                </div>
            </div>
            <div class="ss_form  ">
                <h4 class="ss_form_title ">Judgements Liens                               
                    <pt-collapse model="DocSearch.LeadResearch.Judgements_Liens">                            </pt-collapse>
                </h4>
                <div class="ss_border" collapse="DocSearch.LeadResearch.Judgements_Liens">
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Personal Judgments                                       
                            <pt-collapse model="DocSearch.LeadResearch.Personal_Judgments_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Personal_Judgments_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has Judgments</label>
                                    <pt-radio name="JudgementsLiens_hasJudgments0" model="DocSearch.LeadResearch.has_Judgments_Personal_Judgments"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Personal_Judgments">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Personal_Judgments">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">HPD Judgments                                       
                            <pt-collapse model="DocSearch.LeadResearch.HPD_Judgments_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.HPD_Judgments_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has Judgments</label>
                                    <pt-radio name="JudgementsLiens_hasJudgments0" model="DocSearch.LeadResearch.has_Judgments_HPD_Judgments"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_HPD_Judgments">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_HPD_Judgments">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">IRS Tax Lien                                       
                            <pt-collapse model="DocSearch.LeadResearch.IRS_Tax_Lien_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.IRS_Tax_Lien_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has IRS Tax Lien</label>
                                    <pt-radio name="JudgementsLiens_hasIRSTaxLien0" model="DocSearch.LeadResearch.has_IRS_Tax_Lien_IRS_Tax_Lien"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_IRS_Tax_Lien">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_IRS_Tax_Lien">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">NYS Tax Lien                                       
                            <pt-collapse model="DocSearch.LeadResearch.NYS_Tax_Lien_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.NYS_Tax_Lien_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has NYS Tax Lien</label>
                                    <pt-radio name="JudgementsLiens_hasNYSTaxLien0" model="DocSearch.LeadResearch.has_NYS_Tax_Lien_NYS_Tax_Lien"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_NYS_Tax_Lien">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_NYS_Tax_Lien">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Sidewalk Liens                                       
                            <pt-collapse model="DocSearch.LeadResearch.Sidewalk_Liens_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Sidewalk_Liens_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has Sidewalk Liens</label>
                                    <pt-radio name="JudgementsLiens_hasSidewalkLiens0" model="DocSearch.LeadResearch.has_Sidewalk_Liens_Sidewalk_Liens"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Sidewalk_Liens">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Sidewalk_Liens">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">Vacate Order                                       
                            <pt-collapse model="DocSearch.LeadResearch.Vacate_Order_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.Vacate_Order_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has Vacate Order</label>
                                    <pt-radio name="JudgementsLiens_hasVacateOrder0" model="DocSearch.LeadResearch.has_Vacate_Order_Vacate_Order"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_Vacate_Order">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_Vacate_Order">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB Tickets                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_Tickets_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.ECB_Tickets_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has ECB Tickets</label>
                                    <pt-radio name="JudgementsLiens_hasECBTickets0" model="DocSearch.LeadResearch.has_ECB_Tickets_ECB_Tickets"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_Tickets">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_ECB_Tickets">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="ss_form  ">
                        <h5 class="ss_form_title  ">ECB on Name other known address                                       
                            <pt-collapse model="DocSearch.LeadResearch.ECB_on_Name_other_known_address_Judgements_Liens"> </pt-collapse>
                        </h5>
                        <div class="ss_border" collapse="DocSearch.LeadResearch.ECB_on_Name_other_known_address_Judgements_Liens">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">has ECB on Name</label>
                                    <pt-radio name="JudgementsLiens_hasECBonName0" model="DocSearch.LeadResearch.has_ECB_on_Name_ECB_on_Name_other_known_address"></pt-radio>
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Count</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Count_ECB_on_Name_other_known_address">
                                </li>
                                <li class="ss_form_item ">
                                    <label class="ss_form_input_title ">Amount</label>
                                    <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Amount_ECB_on_Name_other_known_address">
                                </li>
                            </ul>
                        </div>
                    </div>
                    <%--<ul class="ss_form_box clearfix">
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Personal Judgments</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Personal_Judgments">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">HPD Judgments</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.HPD_Judgments">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">IRS Tax Lien</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.IRS_Tax_Lien">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">NYS Tax Lien</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.NYS_Tax_Lien">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Sidewalk Liens</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Sidewalk_Liens">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">Vacate Order</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.Vacate_Order">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB Tickets</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.ECB_Tickets">
                        </li>
                        <li class="ss_form_item ">
                            <label class="ss_form_input_title ">ECB on Name other known address</label>
                            <input class="ss_form_input " ng-model="DocSearch.LeadResearch.ECB_on_Name_other_known_address">
                        </li>
                    </ul>--%>
                </div>
            </div>

        </div>

    </div>
</div>
