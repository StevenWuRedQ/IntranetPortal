<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleInfo.ascx.vb" Inherits="IntranetPortal.TitleInfo" %>

<div class="ss_form ">
    <h4 class="ss_form_title ">SCHEDULE A</h4>
    <div class="ss_border">

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">PROPERTY ADDRESS</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.PROPERTY_ADDRESS">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">TITLE REPORT</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Company</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Company">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Title Num</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Title_Num">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Order Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Order_Date">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Confirmation Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Confirmation_Date">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Received Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Received_Date">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Initial Reivew Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Initial_Reivew_Date">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">BUILDING Description</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Lot Size</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Lot_Size">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Tax Class</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Tax_Class">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Total Units</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Total_Units">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Certificate</label>
                <pt-radio name="BUILDINGDescription_Certificate0" model="Form.FormData.info.Certificate"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Total Units</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Total_Units">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">CHAIN OF TITLE - Status</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Title Vested</label>
                <pt-file file-bble="Form.FormData.BBLE" upload-type="uploadType" file-id="CHAINOFTITLE-Status_TitleVested0" file-model="Form.FormData.info.Title_Vested"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Consideration</label>
                <pt-radio name="CHAINOFTITLE-Status_Consideration0" model="Form.FormData.info.Consideration"></pt-radio>
            </li>
        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Consideration Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="Form.FormData.info.Consideration_Note"></textarea>
        </div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Life Estate</label>
                <pt-radio name="CHAINOFTITLE-Status_LifeEstate0" model="Form.FormData.info.Life_Estate"></pt-radio>
            </li>
        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Life Estate Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="Form.FormData.info.Life_Estate_Note"></textarea>
        </div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Devolution of Title</label>
                <pt-radio name="CHAINOFTITLE-Status_DevolutionofTitle0" model="Form.FormData.info.Devolution_of_Title"></pt-radio>
            </li>

        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Devolution of Title Note</label>
            <textarea class="edit_text_area text_area_ss_form " model="Form.FormData.info.Devolution_of_Title_Note"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">SCHEDULE A DESCRIPTION</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">fillable</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.fillable">
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Covenants and Restrictions</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Covenants/Agremeents/Restriction</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Covenants_Agremeents_Restriction">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Contract of Sale</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Contract_of_Sale">
            </li>
        </ul>
    </div>
</div>
