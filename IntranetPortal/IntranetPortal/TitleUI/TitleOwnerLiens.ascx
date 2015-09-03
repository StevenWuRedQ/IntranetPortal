<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleOwnerLiens.ascx.vb" Inherits="IntranetPortal.TitleOwnerLiens" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">Mortage +</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Name of the Mortgagor</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Name_of_the_Mortgagor" ng-change="PriorOwnerLiens.Name_of_the_MortgagorId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.Name_of_the_MortgagorId=$item.ContactId">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date of mortgage</label>
                <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Date_of_mortgage">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="PriorOwnerLiens.Amount">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Lis Pendens</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Index Num</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.Lis_Pendens_Index_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Lis_Pendens_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">County</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.Lis_Pendens_County">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Servicer</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Lis_Pendens_Servicer" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Judgement</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Index Num</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.Judgement_Index_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Plaintiff</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Judgement_Plaintiff" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Defendant</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Judgement_Defendant" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Judgement_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>

        </ul>
    </div>
    <div class="ss_form_item_line">
        <label class="ss_form_input_title ">Note +</label>
        <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.Judgement_Note"></textarea>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">ECB</h4>
    <div class="ss_border">
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.ECB_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">PVB</h4>
    <div class="ss_border">
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.PVB_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">UCC</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Debtor </label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.UCC_Debtor">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Secured party </label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.UCC_Secured_Party">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.UCC_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">CRFN Num</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.UCC_CRFN_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.UCC_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Federal Tax Liens</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">CRFN Num</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.Federal_Tax_Liens_CRFN_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Federal_Tax_Liens_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="PriorOwnerLiens.Federal_Tax_Liens_Amount">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Mechanics Lien</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Lienor</label>
                <input class="ss_form_input " ng-model="PriorOwnerLiens.Mechanics_Lien_Lienor">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Mechanics_Lien_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="PriorOwnerLiens.Mechanics_Lien_Amount">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Mechanics_Lien_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
        </ul>
    </div>
</div>
