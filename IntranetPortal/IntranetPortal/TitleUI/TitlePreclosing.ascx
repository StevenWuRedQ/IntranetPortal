<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitlePreclosing.ascx.vb" Inherits="IntranetPortal.TitlePreclosing" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">POA</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-bble="BBLE" upload-type="title" file-id="POA_Upload" file-model="Form.FormData.preclosing.POA_Upload"></pt-file>
            </li>
        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.preclosing.POA_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">WILLS</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="WILLS_Upload" file-model="Form.FormData.preclosing.WILLS_Upload"></pt-file>
            </li>

        </ul>

        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.preclosing.WILLS_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Short Sale Documents</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">HUD</label>
                <pt-radio name="ShortSaleDocuments_HUD0" model="Form.FormData.preclosing.HUD"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="HUD_Upload" file-model="Form.FormData.preclosing.HUD_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Approval</label>
                <pt-radio name="ShortSaleDocuments_Approval0" model="Form.FormData.preclosing.Approval"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Approval_Upload" file-model="Form.FormData.preclosing.Approval_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Servicing Agrement/POA</label>
                <pt-radio name="ShortSaleDocuments_ServicingAgrement/POA0" model="Form.FormData.preclosing.Servicing_Agrement_POA"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Servicing_Agrement_POA_Upload" file-model="Form.FormData.preclosing.Servicing_Agrement_POA_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Contract of Sale</label>
                <pt-radio name="ShortSaleDocuments_ContractofSale0" model="Form.FormData.preclosing.Contract_of_Sale"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Contract_of_Sale_Upload" file-model="Form.FormData.preclosing.Contract_of_Sale_Upload"></pt-file>
            </li>

        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="Form.FormData.preclosing.Short_Sale_Documents_Notes"></textarea>
        </div>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">CORP/LLC DOCUMENTS</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Filing Receipts</label>
                <pt-radio name="Filing_Receipts" model="Form.FormData.preclosing.Filing_Receipts"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Filing_Receipts_Upload" file-model="Form.FormData.preclosing.Filing_Receipts_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Proof of Publication</label>
                <pt-radio name="Proof_of_Publication" model="Form.FormData.preclosing.Proof_of_Publication"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Proof_of_Publication_Upload" file-model="Form.FormData.preclosing.Proof_of_Publication_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Operating Agreeements</label>
                <pt-radio name="Operating_Agreeements" model="Form.FormData.preclosing.Operating_Agreeements"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Operating_Agreeements_Upload" file-model="Form.FormData.preclosing.Operating_Agreeements_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">By Laws of Corp</label>
                <pt-radio name="By_Laws_of_Corp" model="Form.FormData.preclosing.By_Laws_of_Corp"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="By_Laws_of_Corp_Upload" file-model="Form.FormData.preclosing.By_Laws_of_Corp_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Certificate of Good Standing</label>
                <pt-radio name="Certificate_of_Good_Standing" model="Form.FormData.preclosing.Certificate_of_Good_Standing"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Certificate_of_Good_Standing_Upload" file-model="Form.FormData.preclosing.Certificate_of_Good_Standing_Upload"></pt-file>
            </li>
        </ul>
    </div>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Closing Requirements</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Deed reverting title</label>
                <pt-radio name="Deed_reverting_title" model="Form.FormData.preclosing.Deed_reverting_title"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Deed_reverting_title_Upload" file-model="Form.FormData.preclosing.Deed_reverting_title_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Correction deed</label>
                <pt-radio name="Correction_deed" model="Form.FormData.preclosing.Correction_deed"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Correction_deed_Upload" file-model="Form.FormData.Correction_deed_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Closing Deed and Acris</label>
                <pt-radio name="Closing_Deed_and_Acris" model="Form.FormData.preclosing.Closing_Deed_and_Acris"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Closing_Deed_and_Acris_Upload" file-model="Form.FormData.Closing_Deed_and_Acris_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">no consideration affidavit</label>
                <pt-radio name="no_consideration_affidavit" model="Form.FormData.preclosing.no_consideration_affidavit"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="no_consideration_affidavit_Upload" file-model="Form.FormData.no_consideration_affidavit_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">no demand affidavit</label>
                <pt-radio name="no_demand_affidavit" model="Form.FormData.preclosing.no_demand_affidavit"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="no_demand_affidavit_Upload" file-model="Form.FormData.no_demand_affidavit_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">original marriage/death certificates</label>
                <pt-radio name="original_marriage_death_certificates" model="Form.FormData.preclosing.original_marriage_death_certificates"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="original_marriage_death_certificates_Upload" file-model="Form.FormData.original_marriage_death_certificates_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Original letter of Administration</label>
                <pt-radio name="Original_letter_of_Administration" model="Form.FormData.preclosing.Original_letter_of_Administration"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Original_letter_of_Administration_Upload" file-model="Form.FormData.Original_letter_of_Administration_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Original POA</label>
                <pt-radio name="Original_POA" model="Form.FormData.preclosing.Original_POA"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Original_POA_Upload" file-model="Form.FormData.Original_POA_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Affidavit of full force and effect if closing by POA</label>
                <pt-radio name="Affidavit_of_full_force" model="Form.FormData.preclosing.Affidavit_of_full_force"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Affidavit_of_full_force_Upload" file-model="Form.FormData.Affidavit_of_full_force_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Termination of Contract</label>
                <pt-radio name="Termination_of_Contract" model="Form.FormData.preclosing.Termination_of_Contract"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Termination_of_Contract_Upload" file-model="Form.FormData.Termination_of_Contract_Upload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">LLC Resignation and Assignment of LLC</label>
                <pt-radio name="LLC_Resignation_and_Assignment_LLC" model="Form.FormData.preclosing.LLC_Resignation_and_Assignment_LLC"></pt-radio>
            </li>
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="LLC_Resignation_and_Assignment_LLC_Upload" file-model="Form.FormData.LLC_Resignation_and_Assignment_LLC_Upload"></pt-file>
            </li>
        </ul>
    </div>
</div>
