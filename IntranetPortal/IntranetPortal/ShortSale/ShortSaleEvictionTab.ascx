<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleEvictionTab.ascx.vb" Inherits="IntranetPortal.ShortSaleEvictionTab" %>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />

    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Occupancy</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Occupied by </label>
            <select class="ss_form_input" data-field="OccupiedBy">
                <option value="volvo">Vacant</option>
                <option value="volvo">Homeowner</option>
                <option value="saab">Tenant (Coop)</option>
                <option value="mercedes">Tenant (Non Coop)</option>

            </select>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" data-field="Evivtion">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input" type="date" id="Date_started" data-field="DateStarted">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" data-field="LockBoxCode">
        </li>

    </ul>
</div>

<div data-array-index="0" data-field="Occupants" class="ss_array">
    <%--<h3 class="title_with_line"><span class="title_index title_span">Mortgages </span></h3>--%>
    <div class="ss_form">
        <h4 class="ss_form_title title_with_line"><span class="title_index title_span">Occupant 1</span> &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="AddArraryItem(this)" title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples" onclick="delete_array_item(this)" title="Delete"></i>
        </h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Occupant Name</label>
                <input class="ss_form_input" data-item="Name" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Occupant #</label>
                <input class="ss_form_input" data-item="Phone" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Floor</label>
                <input class="ss_form_input currency_input" data-item="Floor" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Apt #</label>
                <input class="ss_form_input" data-item="AptNo" data-item-type="1">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Lease</label>
                <input class="ss_form_input " data-item="Lease" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Program</label>
                <input class="ss_form_input " data-item="Program" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Last Rent</label>
                <input class="ss_form_input " data-item="LastRent" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Military</span>

                <input type="radio" id="key_Military_yes" data-item="Military" data-radio="Y" class="ss_form_input" name="Military" value="YES">
                <label for="key_Military_yes" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_pdf_checkey_no" data-item="Military" name="Military" value="NO">
                <label for="none_pdf_checkey_no" class="input_with_check"><span class="box_text">No</span></label>

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">30 Day Notice</span>

                <input type="radio" id="key_Notice30Day_yes" data-item="Notice30Day" data-radio="Y" class="ss_form_input" name="Notice30Day" value="YES">
                <label for="key_Military_yes" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_Notice30Day_no" data-item="Notice30Day" name="Notice30Day" value="NO">
                <label for="none_pdf_checkey_no" class="input_with_check"><span class="box_text">No</span></label>

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">CFK</label>
                <input class="ss_form_input " data-item="CFK" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Type of Payment</label>
                <input class="ss_form_input " data-item="TypeOfPayment" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date to Vacate</label>
                <input class="ss_form_input " data-item="DateToVacate" data-item-type="1">
            </li>
            <li class="ss_form_item">

                <span class="ss_form_input_title">Completed</span>

                <input type="radio" id="key_Completed_yes" data-item="Completed" data-radio="Y" class="ss_form_input" name="Completed" value="YES">
                <label for="key_Military_yes" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_Completed_no" data-item="Completed" name="Completed" value="NO">
                <label for="none_pdf_checkey_no" class="input_with_check"><span class="box_text">No</span></label>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value="">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Attorney</label>
                <input class="ss_form_input " data-item="Attorney" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Attorney #</label>
                <input class="ss_form_input " data-item="AttorneyPhone" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Served</label>
                <input class="ss_form_input " data-item="DateServed" type="date" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Court Date</label>
                <input class="ss_form_input " data-item="CourtDate" type="date" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Stip Date</label>
                <input class="ss_form_input " data-item="StipDate" type="date" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Amount</label>
                <input class="ss_form_input " data-item="Amount" data-item-type="1">
            </li>

        </ul>
    </div>

</div>
