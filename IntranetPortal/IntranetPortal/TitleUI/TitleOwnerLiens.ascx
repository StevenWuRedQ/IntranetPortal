<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleOwnerLiens.ascx.vb" Inherits="IntranetPortal.TitleOwnerLiens" %>

<tabset class="tab-switch">
    <tab ng-repeat="mortgage in Form.FormData.Owners" active="mortgage.active" disable="mortgage.disabled">
         <tab-heading>{{mortgage.name}}</tab-heading>
        <%-- <div class="text-right" ng-show="SsCase.PropertyInfo.Owners.length>1" style="margin-bottom:-25px"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.PropertyInfo.Owners.length>1" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.Owners, $index)" title="Delete"></i></div>--%>
        <div class="ss_border" style="border-top: 0">
    <div class="ss_form ">
    <h4 class="ss_form_title ">Mortgage</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Name of the Mortgagor</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Name_of_the_Mortgagor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date of mortgage</label>
                <input class="ss_form_input " ss-date ng-model="mortgage.Date_of_mortgage">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="mortgage.Amount">
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
                <input class="ss_form_input " ng-model="mortgage.Lis_Pendens_Index_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="mortgage.Lis_Pendens_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">County</label>
                <input class="ss_form_input " ng-model="mortgage.Lis_Pendens_County">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Servicer</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Lis_Pendens_Servicer" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Lis_Pendens_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
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
                <input class="ss_form_input " ng-model="PriorOwnerLiensmortgage.Judgement_Index_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Plaintiff</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Judgement_Plaintiff" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Defendant</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Judgement_Defendant" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Judgement_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>

        </ul>
    </div>
    <div class="ss_form_item_line">
        <label class="ss_form_input_title ">Note +</label>
        <textarea class="edit_text_area text_area_ss_form " model="mortgage.Judgement_Note"></textarea>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">ECB</h4>
    <div class="ss_border">
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="mortgage.ECB_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">PVB</h4>
    <div class="ss_border">
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes +</label>
            <textarea class="edit_text_area text_area_ss_form " model="mortgage.PVB_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">UCC</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Debtor </label>
                <input class="ss_form_input " ng-model="mortgage.UCC_Debtor">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Secured party </label>
                <input class="ss_form_input " ng-model="mortgage.UCC_Secured_Party">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="mortgage.UCC_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">CRFN Num</label>
                <input class="ss_form_input " ng-model="mortgage.UCC_CRFN_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.UCC_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
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
                <input class="ss_form_input " ng-model="mortgage.Federal_Tax_Liens_CRFN_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="mortgage.Federal_Tax_Liens_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="mortgage.Federal_Tax_Liens_Amount">
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
                <input class="ss_form_input " ng-model="mortgage.Mechanics_Lien_Lienor">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Date filed</label>
                <input class="ss_form_input " ss-date ng-model="mortgage.Mechanics_Lien_Date_filed">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Amount</label>
                <input class="ss_form_input " money-mask ng-model="mortgage.Mechanics_Lien_Amount">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Attorney</label>
                <input type="text" class="ss_form_input " ng-model="mortgage.Mechanics_Lien_Attorney" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
        </ul>
    </div>
</div></div>
        </tab>
    <%--i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.PropertyInfo.Owners,false,true)" ng-show="SsCase.PropertyInfo.Owners.length<=2" title="Add" style="font-size: 18px"></i>  --%>
        </tabset>
