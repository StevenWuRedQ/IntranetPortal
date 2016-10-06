<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitlePreclosing.ascx.vb" Inherits="IntranetPortal.TitlePreclosing" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">POA</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-bble="BBLE" upload-type="title" file-id="POA_Upload" file-model="Form.FormData.preclosing.POA_Upload"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.POA_Date" pt-date></input>
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
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="WILLS_Upload" file-model="Form.FormData.preclosing.WILLS_Upload"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Last Modified</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.WILLS_Date" pt-date></input>
            </li>
        </ul>

        <div class="ss_form_item_line">
            <label class="ss_form_input_title">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.preclosing.WILLS_Notes"></textarea>
        </div>
    </div>
</div>

<div class="ss_form ">
    <h4 class="ss_form_title ">ShortSale Documents</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">HUD</label>
                <pt-radio name="ShortSaleDocuments_HUD0" model="Form.FormData.preclosing.HUD"></pt-radio>
            </li>
            <li class="ss_form_item2 nga">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.HUD_Note"></input>
            </li>
        </ul>
        <hr class="ss-form-hr" />
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">
                    Approvals&nbsp;
                    <pt-add ng-click="ensurePush('Form.FormData.preclosing.ApprovalData')" ng-show="Form.FormData.preclosing.ApprovalData && Form.FormData.preclosing.ApprovalData.length<3"></pt-add>
                </label>
                <pt-radio name="ShortSaleDocuments_Approval0" model="Form.FormData.preclosing.Approval"></pt-radio>
            </li>
            <li class="clearfix"></li>
            <li class="ss_form_item" ng-repeat-start="d in Form.FormData.preclosing.ApprovalData">
                <label class="ss_form_input_title ">Approval {{$index + 1}} Expired</label>
                <input type="text" class="ss_form_input" ng-model="d.Expired_Date" pt-date></input>
            </li>            
            <li class="ss_form_item2" ng-repeat-end>
                <label class="ss_form_input_title ">Approval {{$index + 1}} Notes</label>
                <input type="text" class="ss_form_input" ng-model="d.Note"></input>
                <pt-del class="pull-right" ng-click="arrayRemove(Form.FormData.preclosing.ApprovalData, $index, true)"></pt-del>
            </li>
        </ul>
        <hr class="ss-form-hr" />
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Servicing Agrement/POA</label>
                <pt-radio name="ShortSaleDocuments_ServicingAgrement/POA0" model="Form.FormData.preclosing.Servicing_Agrement_POA"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Servicing_Agrement_POA_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Contract of Sale</label>
                <pt-radio name="ShortSaleDocuments_ContractofSale0" model="Form.FormData.preclosing.Contract_of_Sale"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Contract_of_Sale_Note"></input>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.Filing_Receipts_Date" pt-date></input>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.Proof_of_Publication_Date" pt-date></input>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.Operating_Agreeements_Date" pt-date></input>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.By_Laws_of_Corp_Date" pt-date></input>
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
            <li class="ss_form_item">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.preclosing.Certificate_of_Good_Standing_Date" pt-date></input>
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
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Deed_reverting_title_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Correction deed</label>
                <pt-radio name="Correction_deed" model="Form.FormData.preclosing.Correction_deed"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Correction_deed_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Closing Deed and Acris</label>
                <pt-radio name="Closing_Deed_and_Acris" model="Form.FormData.preclosing.Closing_Deed_and_Acris"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Closing_Deed_and_Acris_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">no consideration affidavit</label>
                <pt-radio name="no_consideration_affidavit" model="Form.FormData.preclosing.no_consideration_affidavit"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.no_consideration_affidavit_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">no demand affidavit</label>
                <pt-radio name="no_demand_affidavit" model="Form.FormData.preclosing.no_demand_affidavit"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.no_demand_affidavit_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">original marriage/death certificates</label>
                <pt-radio name="original_marriage_death_certificates" model="Form.FormData.preclosing.original_marriage_death_certificates"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.original_marriage_death_certificates_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Original letter of Administration</label>
                <pt-radio name="Original_letter_of_Administration" model="Form.FormData.preclosing.Original_letter_of_Administration"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Original_letter_of_Administration_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Original POA</label>
                <pt-radio name="Original_POA" model="Form.FormData.preclosing.Original_POA"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Original_POA_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Affidavit of full force and effect if closing by POA</label>
                <pt-radio name="Affidavit_of_full_force" model="Form.FormData.preclosing.Affidavit_of_full_force"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Affidavit_of_full_force_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">Termination of Contract</label>
                <pt-radio name="Termination_of_Contract" model="Form.FormData.preclosing.Termination_of_Contract"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.Termination_of_Contract_Note"></input>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title ">LLC Resignation and Assignment of LLC</label>
                <pt-radio name="LLC_Resignation_and_Assignment_LLC" model="Form.FormData.preclosing.LLC_Resignation_and_Assignment_LLC"></pt-radio>
            </li>
            <li class="ss_form_item2">
                <label class="ss_form_input_title ">Note</label>
                <input type="text" class="ss_form_input" ng-model="Form.FormData.preclosing.LLC_Resignation_and_Assignment_LLC_Note"></input>
            </li>
        </ul>
    </div>
</div>
