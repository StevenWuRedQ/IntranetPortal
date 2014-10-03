<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.ShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<div class="clearfix">
    <div style="float: right">
       <input type="button" class="rand-button short_sale_edit" value="Edit" onclick='swich_edit_model(this, short_sale_case_data)' />
    </div>
</div>
<div data-array-index="0" data-field="PropertyInfo.Owners" class="ss_array">
    <div class="ss_form">
        <h4 class="ss_form_title">Seller &nbsp;<i class="fa fa-plus-circle icon_btn color_blue"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">First name</label>
                <input class="ss_form_input"  data-item="FirstName" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Last name</label>
                <input class="ss_form_input"  data-item="LastName" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ssn</label>
                <input class="ss_form_input" data-item="SSN" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">dob</label>
                <input class="ss_form_input" data-item="DOB" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Phone #1</label>
                <input class="ss_form_input" data-item="Phone" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email</label>
                <input class="ss_form_input" data-item="Email" data-item-type="1" >
            </li>


        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">mailing address</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">street nummber</label>
                <input class="ss_form_input" data-item="MailNumber" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">street name</label>
                <input class="ss_form_input" data-item="MailStreetName" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City</label>
                <input class="ss_form_input" data-item="MailCity" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">State</label>
                <input class="ss_form_input" data-item="MailState" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">zip</label>
                <input class="ss_form_input" data-item="MailZip" data-item-type="1">
            </li>

        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">ohter info</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">bankruptcy</label>

                <input type="radio" id="checkYes_Bankruptcy" name="44" data-radio="Y" data-item="Bankruptcy" data-item-type="1" value="YES">
                <label for="checkYes_Bankruptcy" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_check_no44" name="44" data-item="Bankruptcy" data-item-type="1" value="NO">
                <label for="none_check_no44" class="input_with_check"><span class="box_text">No</span></label>

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">employed</label>
                <input class="ss_form_input" id="Employed" data-item="Employed" data-item-type="1" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">bank account</label>

                <input type="radio" id="checkYes_Bankaccount" data-item="Bankaccount" data-radio="Y" data-item-type="1" name="45" value="YES">
                <label for="checkYes_Bankaccount" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_check_no452" data-item="Bankaccount" data-item-type="1"   name="45" value="NO">
                <label for="none_check_no452" class="input_with_check"><span class="box_text">No</span></label>

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Returns</label>

                <input type="radio" id="checkYes_TaxReturn" name="47" data-item="TaxReturn" data-item-type="1"  value="YES">
                <label for="checkYes_TaxReturn" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_check_no472" name="47" data-item="TaxReturn" data-item-type="1" value="NO">
                <label for="none_check_no472" class="input_with_check"><span class="box_text">No</span></label>

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

                <input type="radio" id="checkYes_EstateDocument" name="49" data-item="EstateDocument" data-radio="Y" data-item-type="1"  value="YES">
                <label for="checkYes_EstateDocument" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_check_no47" name="49" data-item="EstateDocument" data-item-type="1" value="NO">
                <label for="none_check_no47" class="input_with_check"><span class="box_text">No</span></label>

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
                <input class="ss_form_input"  data-item="Phone" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email address</label>
                <input class="ss_form_input"  data-item="Email" data-item-type="1" >
            </li>


            <li class="ss_form_item">
                <label class="ss_form_input_title">also acting as seller attorney</label>

                <input type="radio" id="checkYes_ActingAsSellerAttorney" data-item="ActingAsSellerAttorney" data-item-type="1" data-radio="Y"  name="48" value="YES">
                <label for="checkYes_ActingAsSellerAttorney" class="input_with_check"><span class="box_text">Yes</span></label>

                <input type="radio" id="none_check_no48" data-item="ActingAsSellerAttorney" data-item-type="1"  name="48" value="NO">
                <label for="none_check_no48" class="input_with_check"><span class="box_text">No</span></label>

            </li>
        </ul>
    </div>
</div>
