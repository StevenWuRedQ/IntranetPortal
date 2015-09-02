<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleInfo.ascx.vb" Inherits="IntranetPortal.TitleInfo" %>

<div class="ss_form ">
    <h4 class="ss_form_title ">SCHEDULE A</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">PROPERTY ADDRESS</label>
            <input class="ss_form_input " ng-model="info.PROPERTY_ADDRESS">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">TITLE REPORT</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Company</label>
            <input class="ss_form_input " ng-model="info.Company">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Title Num</label>
            <input class="ss_form_input " ng-model="info.Title_Num">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Order Date</label>
            <input class="ss_form_input " ss-date ng-model="info.Order_Date">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Confirmation Date</label>
            <input class="ss_form_input " ss-date ng-model="info.Confirmation_Date">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Received Date</label>
            <input class="ss_form_input " ss-date ng-model="info.Received_Date">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Initial Reivew Date</label>
            <input class="ss_form_input " ss-date ng-model="info.Initial_Reivew_Date">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">BUILDING Description</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Lot Size</label>
            <input class="ss_form_input " ng-model="info.Lot_Size">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Tax Class</label>
            <input class="ss_form_input " ng-model="info.Tax_Class">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Total Units</label>
            <input class="ss_form_input " ng-model="info.Total_Units">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Certificate</label>
            <pt-radio name="BUILDINGDescription_Certificate0" model="info.Certificate"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Total Units</label>
            <input class="ss_form_input " ng-model="info.Total_Units">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">CHAIN OF TITLE - Status</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Title Vested</label>
            <pt-file file-bble="" file-id="CHAINOFTITLE-Status_TitleVested0" file-model="info.Title_Vested"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Consideration</label>
            <pt-radio name="CHAINOFTITLE-Status_Consideration0" model="info.Consideration"></pt-radio>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Consideration Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="info.Consideration_Note"></textarea>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Life Estate</label>
            <pt-radio name="CHAINOFTITLE-Status_LifeEstate0" model="info.Life_Estate"></pt-radio>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Life Estate Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="info.Life_Estate_Note"></textarea>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Devolution of Title</label>
            <pt-radio name="CHAINOFTITLE-Status_DevolutionofTitle0" model="info.Devolution_of_Title"></pt-radio>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Devolution of Title Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="info.Devolution_of_Title_Note"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">SCHEDULE A DESCRIPTION</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">fillable</label>
            <input class="ss_form_input " ng-model="info.fillable">
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Covenants and Restrictions</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Covenants/Agremeents/Restriction</label>
            <input class="ss_form_input " ng-model="info.Covenants_Agremeents_Restriction">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Contract of Sale</label>
            <input class="ss_form_input " ng-model="info.Contract_of_Sale">
        </li>
    </ul>
</div>
