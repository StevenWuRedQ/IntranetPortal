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
                <option value="Vacant">Vacant</option>
                <option value="Homeowner">Homeowner</option>
                <option value="Tenant (Coop)">Tenant (Coop)</option>
                <option value="Tenant (Non Coop)">Tenant (Non Coop)</option>
            </select>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Eviction</label>
            <input class="ss_form_input" data-field="Evivtion">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date started</label>
            <input class="ss_form_input ss_date" id="Date_started" data-field="DateStarted">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lock box code</label>
            <input class="ss_form_input" data-field="LockBoxCode">
        </li>

    </ul>
</div>
<div style="margin-top: 30px">&nbsp;</div>
<div data-array-index="0" data-field="Occupants" class="ss_array" style="display: none">
    <%--<h3 class="title_with_line"><span class="title_index title_span">Mortgages </span></h3>--%>
    <h4 class="ss_form_title title_with_line">
        <span class="title_index title_span">Occupant __index__1</span> &nbsp;
        <i class="fa fa-expand expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>
        <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="AddArraryItem(event,this)" title="Add"></i>
        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples" onclick="delete_array_item(this)" title="Delete"></i>
    </h4>

    <div class="collapse_div">
        <div>

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
                    <input class="ss_form_input" data-item="Floor" data-item-type="1">
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

                    <input type="radio" id="key_Military_yes___index__" data-item="Military" data-radio="Y" class="ss_form_input" name="Military___index__" value="YES">
                    <label for="key_Military_yes___index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_pdf_checkey_no___index__" data-item="Military" class="ss_form_input" name="Military___index__" value="NO">
                    <label for="none_pdf_checkey_no___index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <li class="ss_form_item">
                    <span class="ss_form_input_title">30 Day Notice</span>

                    <input type="radio" id="key_Notice30Day_yes__index__" data-item="Notice30Day" data-radio="Y" class="ss_form_input" name="Notice30Day__index__" value="YES">
                    <label for="key_Notice30Day_yes__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_Notice30Day_no__index__" data-item="Notice30Day" name="Notice30Day__index__" value="NO" class="ss_form_input">
                    <label for="none_Notice30Day_no__index__" class="input_with_check"><span class="box_text">No</span></label>

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

                    <input type="radio" id="key_Completed_yes__index__" data-item="Completed" data-radio="Y" class="ss_form_input" name="Completed__index__" value="YES">
                    <label for="key_Completed_yes__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_Completed_no__index__" data-item="Completed" class="ss_form_input" name="Completed__index__" value="NO">
                    <label for="none_Completed_no__index__" class="input_with_check"><span class="box_text">No</span></label>
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
                    <input class="ss_form_input ss_date" data-item="DateServed" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Court Date</label>
                    <input class="ss_form_input ss_date" data-item="CourtDate" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Stip Date</label>
                    <input class="ss_form_input ss_date" data-item="StipDate" type="date" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Amount</label>
                    <input class="ss_form_input " data-item="Amount" data-item-type="1">
                </li>

            </ul>
        </div>
    </div>

</div>
