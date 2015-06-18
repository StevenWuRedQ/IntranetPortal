<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSummaryTab.ascx.vb" Inherits="IntranetPortal.LegalSummaryTab" %>
<div class="short_sale_content">


    <div>

        <div>

            <h4 class="ss_form_title">Property</h4>

            <ul class="ss_form_box clearfix">
                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">address</label>

                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.PropertyAddress" style="width: 93.5%;" name="lender">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Block</label>
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.Block">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">lot</label>
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.Lot">
                </li>
                 <li class="ss_form_item">
                    <label class="ss_form_input_title">BBLE</label>
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.BBLE">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Class</label>
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.TaxClass">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Condition</label>
                    <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.Condition">
                        <option></option>
                        <option value="Great">Great</option>
                        <option value="Good">Good</option>
                        <option value="Bad">Bad</option>
                    </select>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vacant/Occupied </label>
                    <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.VacantOrOccupied">
                        <option></option>
                        <option value="Vacant">Vacant</option>
                        <option value="Occupied">Occupied</option>

                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Stage</label>
                    <select class="ss_form_input">
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
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.Use">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Owner of Record </label>
                    <input class="ss_form_input" ng-model="LegalCase.PropertyInfo.Use">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Case Contact person/owner </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.PropertyInfo.CaseContactId')">
                    </div>
                    <%--<input class="ss_form_input" ng-model="LegalCase.PropertyInfo.CaseContactId">--%>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone number </label>
                    <input class="ss_form_input" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Cell">
                </li>


                <li class="ss_form_item">
                    <label class="ss_form_input_title">email  </label>
                    <input class="ss_form_input" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Email">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input" ng-model="GetContactById(LegalCase.PropertyInfo.CaseContactId).Address">
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

                        <input type="checkbox" id="pdf_check_yes30" name="1" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMP">
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
                    <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Status">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tasks </label>
                    <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Tasks">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney working file  </label>
                    <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.AttorneyWorkingFile">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Update </label>
                    <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.LastUpdate">
                </li>


            </ul>
        </div>

    </div>

</div>
