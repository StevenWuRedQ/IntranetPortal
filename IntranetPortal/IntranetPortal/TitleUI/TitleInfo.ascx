<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleInfo.ascx.vb" Inherits="IntranetPortal.TitleInfo" %>

<div class="ss_form ">
    <h4 class="ss_form_title ">SCHEDULE A</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_from_item3">
                <label class="ss_form_input_title ">PROPERTY ADDRESS</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.PROPERTY_ADDRESS" pt-init-model="LeadsInfo.PropertyAddress">
            </li>
            <li class="ss_from_item" hidden>
                <label class="ss_form_input_title ">Block</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Block" pt-init-model="LeadsInfo.Block">
            </li>
            <li class="ss_from_item" hidden>
                <label class="ss_form_input_title ">Lot</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Lot" pt-init-model="LeadsInfo.Lot">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">Title Report</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Company</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Company" pt-init-model="SsCase.BuyerTitle.CompanyName">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Title Num</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Title_Num" pt-init-model="SsCase.BuyerTitle.OrderNumber">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Order Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Order_Date" pt-init-model="SsCase.BuyerTitle.ReportOrderDate">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Confirmation Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Confirmation_Date" pt-init-model="SsCase.BuyerTitle.ConfirmationDate">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Received Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Received_Date" pt-init-model="SsCase.BuyerTitle.ReceivedDate">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Initial Reivew Date</label>
                <input class="ss_form_input " ss-date ng-model="Form.FormData.info.Initial_Reivew_Date">
            </li>
        </ul>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">Building Description</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Lot Size</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Lot_Size" pt-init-model="LeadsInfo.LotDem">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Tax Class</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Tax_Class" pt-init-model="LeadsInfo.PropertyClass">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Total Units</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Total_Units" pt-init-model="PropertyInfo.NumOfUnit">
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Certificate</label>
                <pt-radio name="BUILDINGDescription_Certificate0" model="Form.FormData.info.Certificate"></pt-radio>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">Chain Of Tile - Status</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item3">
                <label class="ss_form_input_title ">Title Vested</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Title_Vested" />
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line">
                <label class="ss_form_input_title">Deed Chain</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.info.DeedChain"></textarea>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Consideration</label>
                <pt-radio name="CHAINOFTITLE-Status_Consideration0" model="Form.FormData.info.Consideration"></pt-radio>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.info.Consideration">
                <label class="ss_form_input_title">Consideration Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.info.Consideration_Note"></textarea>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Life Estate</label>
                <pt-radio name="CHAINOFTITLE-Status_LifeEstate0" model="Form.FormData.info.Life_Estate"></pt-radio>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.info.Life_Estate">
                <label class="ss_form_input_title">Life Estate Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.info.Life_Estate_Note"></textarea>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Devolution of Title</label>
                <pt-radio name="CHAINOFTITLE-Status_DevolutionofTitle0" model="Form.FormData.info.Devolution_of_Title"></pt-radio>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.info.Devolution_of_Title">
                <label class="ss_form_input_title">Devolution of Title Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.info.Devolution_of_Title_Note"></textarea>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">Schedule A Description</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title ">fillable</label>
                <pt-file upload-type="title" file-bble="BBLE" file-id="info_fillable" file-model="Form.FormData.info.fillable"></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">Covenants and Restrictions</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item3">
                <label class="ss_form_input_title ">Covenants/Agremeents/Restriction</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Covenants_Agremeents_Restriction" />
            </li>
            <li class="ss_form_item3">
                <label class="ss_form_input_title ">Contract of Sale</label>
                <input class="ss_form_input " ng-model="Form.FormData.info.Contract_of_Sale" />
            </li>
        </ul>
    </div>
</div>
