<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSummaryTab.ascx.vb" Inherits="IntranetPortal.LegalSummaryTab" %>
<div class="short_sale_content">


    <div>

        <div>

            <h4 class="ss_form_title">Property</h4>

            <ul class="ss_form_box clearfix">
                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">address</label>

                    <input class="ss_form_input" style="width: 93.5%;" name="lender" value="421 HART ST, BEDFORD STUYVESANT,NY 11221">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Block</label>
                    <input class="ss_form_input" data-field="PropertyInfo.Block">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">lot</label>
                    <input class="ss_form_input" data-field="PropertyInfo.Lot">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Class</label>
                    <input class="ss_form_input" value="A0">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Condition</label>
                    <input class="ss_form_input" value="Good">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Vacant/Occupied </label>
                    <input class="ss_form_input">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status</label>
                    <select class="ss_form_input">
                        <option>Eviction</option>
                        <option>Short Sale</option>
                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title ss_ssn">Agent </label>
                    <input class="ss_form_input">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Use</label>
                    <input class="ss_form_input" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Owner of Record </label>
                    <input class="ss_form_input">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Case Contact person/owner </label>
                    <input class="ss_form_input">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone number </label>
                    <input class="ss_form_input">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Case Contact person/owner </label>
                    <input class="ss_form_input">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email  </label>
                    <input class="ss_form_input">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input">
                </li>



            </ul>
        </div>

        <div data-array-index="0" class="ss_array" style="display: inline;">

            <div class="ss_form">
                <h4 class="ss_form_title"><span class="title_index ">Foreclosure </span></h4>
                <ul class="ss_form_box clearfix">


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Servicer</label>
                        <input class="ss_form_input" data-item="Lender" data-item-type="1">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Defendant</label>
                        <input class="ss_form_input" data-item="Loan" data-item-type="1">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Attorney of record </label>
                        <input class="ss_form_input input_currency" data-item="LoanAmount" data-item-type="1">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">last court date</label>
                        <input class="ss_form_input ss_date">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">next court date </label>
                        <input class="ss_form_input ss_date">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Sale date  </label>
                        <input class="ss_form_input ss_date">
                    </li>

                    <li class="ss_form_item">
                        <span class="ss_form_input_title">HAMP </span>

                        <input type="checkbox" id="pdf_check_yes30" name="1" class="ss_form_input" value="YES">
                        <label for="pdf_check_yes30" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>

                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Last Update </label>
                        <input class="ss_form_input ss_date">
                    </li>
                </ul>
            </div>

        </div>


        <div class="ss_form">
            <h4 class="ss_form_title">Secondary</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Client </label>
                    <input class="ss_form_input" value="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney of record </label>
                    <input class="ss_form_input" value="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Opposing party  </label>
                    <input class="ss_form_input" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status </label>
                    <input class="ss_form_input" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tasks </label>
                    <input class="ss_form_input" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney working file  </label>
                    <input class="ss_form_input" value="">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Update </label>
                    <input class="ss_form_input" value="">
                </li>


            </ul>
        </div>

    </div>

</div>
