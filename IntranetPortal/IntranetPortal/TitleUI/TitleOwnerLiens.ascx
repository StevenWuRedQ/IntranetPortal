<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleOwnerLiens.ascx.vb" Inherits="IntranetPortal.TitleOwnerLiens" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">Mortage +</h4>
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
<div class="ss_form ">
    <h4 class="ss_form_title ">Lis Pendens </h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Index Num</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.Index_Num">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date filed</label>
            <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Date_filed">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">County</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.County">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Servicer</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Servicer" ng-change="PriorOwnerLiens.ServicerId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.ServicerId=$item.ContactId">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Attorney</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Attorney" ng-change="PriorOwnerLiens.AttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.AttorneyId=$item.ContactId">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Judgement</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Index Num</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.Index_Num">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Plaintiff</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Plaintiff" ng-change="PriorOwnerLiens.PlaintiffId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.PlaintiffId=$item.ContactId">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Defendant </label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Defendant_" ng-change="PriorOwnerLiens.Defendant_Id=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.Defendant_Id=$item.ContactId">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Attorney</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Attorney" ng-change="PriorOwnerLiens.AttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.AttorneyId=$item.ContactId">
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Note +</label>
            <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.Note"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">ECB </h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.Notes"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">PVB</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="PriorOwnerLiens.Notes"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">UCC</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Debtor </label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.Debtor">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Secured party </label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.Secured_party">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date filed</label>
            <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Date_filed">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">CRFN Num</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.CRFN_Num">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Attorney</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Attorney" ng-change="PriorOwnerLiens.AttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.AttorneyId=$item.ContactId">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Federal Tax Liens</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">CRFN Num</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.CRFN_Num">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date filed</label>
            <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Date_filed">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Amount</label>
            <input class="ss_form_input " money-mask ng-model="PriorOwnerLiens.Amount">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Mechanics Lien</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Lienor</label>
            <input class="ss_form_input " ng-model="PriorOwnerLiens.Lienor">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Date filed</label>
            <input class="ss_form_input " ss-date ng-model="PriorOwnerLiens.Date_filed">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Amount</label>
            <input class="ss_form_input " money-mask ng-model="PriorOwnerLiens.Amount">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Attorney</label>
            <input type="text" class="ss_form_input " ng-model="PriorOwnerLiens.Attorney" ng-change="PriorOwnerLiens.AttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="PriorOwnerLiens.AttorneyId=$item.ContactId">
        </li>
    </ul>
</div>
