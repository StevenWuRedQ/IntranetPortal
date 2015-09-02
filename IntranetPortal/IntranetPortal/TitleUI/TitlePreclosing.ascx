<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitlePreclosing.ascx.vb" Inherits="IntranetPortal.TitlePreclosing" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">POA</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="POA_Upload0" file-model="preclosing.Upload"></pt-file>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " model="preclosing.Notes"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">WILLS</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="WILLS_Upload0" file-model="preclosing.Upload"></pt-file>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " model="preclosing.Notes"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Short Sale Documents</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">HUD</label>
            <pt-radio name="ShortSaleDocuments_HUD0" model="preclosing.HUD"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="ShortSaleDocuments_Upload0" file-model="preclosing.Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Approval</label>
            <pt-radio name="ShortSaleDocuments_Approval0" model="preclosing.Approval"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="ShortSaleDocuments_Upload0" file-model="preclosing.Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Servicing Agrement/POA</label>
            <pt-radio name="ShortSaleDocuments_ServicingAgrement/POA0" model="preclosing.Servicing_Agrement_POA"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="ShortSaleDocuments_Upload0" file-model="preclosing.Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Contract of Sale</label>
            <pt-radio name="ShortSaleDocuments_ContractofSale0" model="preclosing.Contract_of_Sale"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload PDF</label>
            <pt-file file-bble="" file-id="ShortSaleDocuments_uploadPDF0" file-model="preclosing.upload_PDF"></pt-file>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " model="preclosing.Notes"></textarea>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">CORP/LLC DOCUMENTS</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Filing Receipts</label>
            <pt-radio name="CORP/LLCDOCUMENTS_FilingReceipts0" model="preclosing.Filing_Receipts"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload</label>
            <pt-file file-bble="" file-id="CORP/LLCDOCUMENTS_upload0" file-model="preclosing.upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Proof of Publication</label>
            <pt-radio name="CORP/LLCDOCUMENTS_ProofofPublication0" model="preclosing.Proof_of_Publication"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload</label>
            <pt-file file-bble="" file-id="CORP/LLCDOCUMENTS_upload0" file-model="preclosing.upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Operating Agreeements</label>
            <pt-radio name="CORP/LLCDOCUMENTS_OperatingAgreeements0" model="preclosing.Operating_Agreeements"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload</label>
            <pt-file file-bble="" file-id="CORP/LLCDOCUMENTS_upload0" file-model="preclosing.upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">By Laws of Corp</label>
            <pt-radio name="CORP/LLCDOCUMENTS_ByLawsofCorp0" model="preclosing.By_Laws_of_Corp"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload</label>
            <pt-file file-bble="" file-id="CORP/LLCDOCUMENTS_upload0" file-model="preclosing.upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Certificate of Good Standing</label>
            <pt-radio name="CORP/LLCDOCUMENTS_CertificateofGoodStanding0" model="preclosing.Certificate_of_Good_Standing"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">upload</label>
            <pt-file file-bble="" file-id="CORP/LLCDOCUMENTS_upload0" file-model="preclosing.upload"></pt-file>
        </li>
    </ul>
</div>
<div class="ss_form ">
    <h4 class="ss_form_title ">Closing Requirements</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Deed reverting title</label>
            <pt-radio name="ClosingRequirements_Deedrevertingtitle0" model="preclosing.Deed_reverting_title"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Correction deed</label>
            <pt-radio name="ClosingRequirements_Correctiondeed0" model="preclosing.Correction_deed"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Closing Deed and Acris</label>
            <pt-radio name="ClosingRequirements_ClosingDeedandAcris0" model="preclosing.Closing_Deed_and_Acris"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">no consideration affidavit</label>
            <pt-radio name="ClosingRequirements_noconsiderationaffidavit0" model="preclosing.no_consideration_affidavit"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">no demand affidavit</label>
            <pt-radio name="ClosingRequirements_nodemandaffidavit0" model="preclosing.no_demand_affidavit"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">original marriage/death certificates</label>
            <pt-radio name="ClosingRequirements_originalmarriage/deathcertificates0" model="preclosing.original_marriage_death_certificates"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Original letter of Administration</label>
            <pt-radio name="ClosingRequirements_OriginalletterofAdministration0" model="preclosing.Original_letter_of_Administration"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Original POA</label>
            <pt-radio name="ClosingRequirements_OriginalPOA0" model="preclosing.Original_POA"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Affidavit of full force and effect if closing by POA</label>
            <pt-radio name="ClosingRequirements_AffidavitoffullforceandeffectifclosingbyPOA0" model="preclosing.Affidavit_of_full_force_and_effect_if_closing_by_POA"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Termination of Contract</label>
            <pt-radio name="ClosingRequirements_TerminationofContract0" model="preclosing.Termination_of_Contract"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">for LLC-Resignation and Assignment of LLC</label>
            <pt-radio name="ClosingRequirements_forLLC-ResignationandAssignmentofLLC0" model="preclosing.for_LLC_Resignation_and_Assignment_of_LLC"></pt-radio>
        </li>
    </ul>
</div>
