<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.ShortSaleHomewonerTab" %>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
            <ClientSideEvents Click="swich_edit_model" />
        </dx:ASPxButton>
    </div>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Seller &nbsp;<i class="fa fa-plus-circle icon_btn color_blue"></i></h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">First name</label>
            <input class="ss_form_input" value="John">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Last name</label>
            <input class="ss_form_input" value="Smith">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">ssn</label>
            <input class="ss_form_input" value="xxx-xx-123">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">dob</label>
            <input class="ss_form_input" value="Jan 1,1981 ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #1</label>
            <input class="ss_form_input" value="347-123-456 ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" value="email@example.com ">
        </li>
       
        
    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">mailing address</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">street nummber</label>
            <input class="ss_form_input" value="151-04">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">street name</label>
            <input class="ss_form_input" value="Main st">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">City</label>
            <input class="ss_form_input" value="Flusing">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">State</label>
            <input class="ss_form_input" value="NY">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">zip</label>
            <input class="ss_form_input" value="11367">
        </li>

    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">ohter info</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">bankruptcy</label>

            <input type="radio"  id="check_yes44" name="44" value="YES">
            <label for="check_yes44" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio"  id="check_no44" name="44" value="NO">
            <label for="check_no44" class="input_with_check"><span class="box_text">No</span></label>

        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">employed</label>
            <input class="ss_form_input" value="Self Employeed">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">bank account</label>

            <input type="radio" id="check_yes451" name="45"  value="YES">
            <label for="check_yes451" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="check_no452" name="45" value="NO">
            <label for="check_no452" class="input_with_check"><span class="box_text">No</span></label>

        </li>
        
         <li class="ss_form_item">
            <label class="ss_form_input_title">Tax Returns</label>

            <input type="radio" id="check_yes471" name="47"  value="YES">
            <label for="check_yes471" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="check_no472"  name="47" value="NO">
            <label for="check_no472" class="input_with_check"><span class="box_text">No</span></label>

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

            <input type="radio" id="check_yes47" name="49" value="YES">
            <label for="check_yes47" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="check_no47" name="49" value="NO">
            <label for="check_no47" class="input_with_check"><span class="box_text">No</span></label>

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
            <input class="ss_form_input" value="John Smith">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">phone #</label>
            <input class="ss_form_input" value="718-123-456">
        </li>
         <li class="ss_form_item">
            <label class="ss_form_input_title">email address</label>
            <input class="ss_form_input" value="email@examile.com">
        </li>
        
     
        <li class="ss_form_item">
            <label class="ss_form_input_title">also acting as seller attorney</label>

            <input type="radio" id="check_yes48" name="48"  value="YES">
            <label for="check_yes48" class="input_with_check"> <span class="box_text">Yes</span></label>

            <input type="radio" id="check_no48" name="48" value="NO">
            <label for="check_no48" class="input_with_check"><span class="box_text">No</span></label>

        </li>
    </ul>
</div>
