<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.ShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
    <div style="float: right">
        <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='switch_edit_model(this, short_sale_case_data)' />
    </div>
</div>
<div data-array-index="0" data-field="PropertyInfo.Owners" class="ss_array" style="display: none">
    <h3 class="ss_form_title title_with_line" style="cursor: pointer" onclick="expand_array_item(this)">
        <label class="title_index title_span">Seller __index__1</label>
        <%--<i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'mortgage1')"></i>--%> &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="AddArraryItem(event,this)" title="Add"></i>
        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples" onclick="delete_array_item(this)" title="Delete"></i>
    </h3>
    <div class="collapse_div">
        <div>

            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">First name</label>
                    <input class="ss_form_input" data-item="FirstName" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last name</label>
                    <input class="ss_form_input" data-item="LastName" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">ssn</label>
                    <input class="ss_form_input" data-item="SSN" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">dob</label>
                    <input class="ss_form_input" type="date" data-item="DOB" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #1</label>
                    <input class="ss_form_input" id="home_owner_phone" data-item="Phone" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input" data-item="Email" data-item-type="1">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">mailing address</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">street nummber</label>
                    <input class="ss_form_input" data-item="MailNumber" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">street name</label>
                    <input class="ss_form_input" data-item="MailStreetName" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">City</label>
                    <input class="ss_form_input" data-item="MailCity" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">State</label>
                    <input class="ss_form_input" data-item="MailState" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">zip</label>
                    <input class="ss_form_input" data-item="MailZip" data-item-type="1">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">other info</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">bankruptcy</label>

                    <input type="radio" id="checkYes_Bankruptcy__index__" data-test="1" name="44__index__" data-radio="Y" data-item="Bankruptcy" data-item-type="1" value="YES" class="ss_form_input">
                    <label for="checkYes_Bankruptcy__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no__index__" name="44__index__" data-test="1" data-item="Bankruptcy" data-item-type="1" value="NO" class="ss_form_input">
                    <label for="none_check_no__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">employed</label>
                    <input class="ss_form_input" id="Employed" data-item="Employed" data-item-type="1">
                </li>
                <%--<li class="ss_form_item">
                      <input type="button" onclick="testClick()" value="Test">
                 </li>--%>
              
                <li class="ss_form_item">
                    <label class="ss_form_input_title">bank account</label>
                    
                    <input type="radio" id="checkYes_Bankaccount__index__" data-item="Bankaccount" data-radio="Y" data-item-type="1" name="45__index__" value="YES" class="ss_form_input">
                    <label for="checkYes_Bankaccount__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no452__index__" data-item="Bankaccount" data-item-type="1" name="45__index__" value="NO" class="ss_form_input">
                    <label for="none_check_no452__index__" class="input_with_check"><span class="box_text">No</span></label>
                    
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tax Returns</label>

                    <input type="radio" id="checkYes_TaxReturn__index__" name="47__index__" data-item="TaxReturn" data-item-type="1" data-radio="Y" value="YES" class="ss_form_input">
                    <label for="checkYes_TaxReturn__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no472__index__" name="47__index__" data-item="TaxReturn" data-item-type="1" value="NO" class="ss_form_input">
                    <label for="none_check_no472__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value=" ">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value=" ">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">estate documents</label>

                    <input type="radio" id="checkYes_EstateDocument__index__" name="49__index__" data-item="EstateDocument" data-radio="Y" data-item-type="1" value="YES">
                    <label for="checkYes_EstateDocument__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no47__index__" name="49__index__" data-item="EstateDocument" data-item-type="1" value="NO">
                    <label for="none_check_no47__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value=" ">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input class="ss_form_input ss_form_hidden" value=" ">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">estate attorney</label>
                    <input class="ss_form_input" data-item="EstateAttorney" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">phone #</label>
                    <input class="ss_form_input" data-item="Phone" data-item-type="1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">email address</label>
                    <input class="ss_form_input" data-item="Email" data-item-type="1">
                </li>


                <li class="ss_form_item">
                    <label class="ss_form_input_title">also acting as seller attorney</label>

                    <input type="radio" id="checkYes_ActingAsSellerAttorney__index__" data-item="ActingAsSellerAttorney" data-item-type="1" data-radio="Y" name="48__index__" value="YES">
                    <label for="checkYes_ActingAsSellerAttorney__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no48__index__" data-item="ActingAsSellerAttorney" data-item-type="1" name="48__index__" value="NO">
                    <label for="none_check_no48__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
            </ul>
        </div>
    </div>
</div>
