<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleOwnerLiens.ascx.vb" Inherits="IntranetPortal.TitleOwnerLiens" %>

<uib-tabset class="tab-switch">
<uib-tab ng-repeat="owner in Form.FormData.Owners track by owner.name" active="owner.active" disable="owner.disabled">
<tab-heading>
    <i class="fa fa-arrow-circle-left" ng-show="$index>0" ng-click="swapOwnerPos($index)"></i>
    {{owner.name}}
</tab-heading>

<div class="ss_border" style="border-top: 0">
    <div class="ss_form">
        <h4 class="ss_form_title ">
            <input type="checkbox" style="display: inline-block" ng-model="owner.Mortgages_Show" />
            Mortgages&nbsp;
            <select ng-model="owner.Mortgages_Status" ng-show="owner.Mortgages_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Mortgages')" ng-show="owner.Mortgages_Show"></pt-add>
        </h4>
        <div class="ss_border" ng-show="owner.Mortgages_Show">
            <div ng-repeat="mortgage in owner.Mortgages" class="clearfix">
                <span class="label label-primary">Mortage&nbsp;{{$index + 1}}:</span>
                &nbsp;
                <pt-del class="pull-right" ng-click="arrayRemove(owner.Mortgages, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title ">Name of the Mortgagor</label>
                        <input type="text" class="ss_form_input " ng-model="mortgage.Name_of_the_Mortgagor" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Date of mortgage</label>
                        <input class="ss_form_input " ss-date ng-model="mortgage.Date_of_mortgage">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title ">Amount</label>
                        <input class="ss_form_input " money-mask ng-model="mortgage.Amount">
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">
            <input type="checkbox" style="display: inline-block" ng-model="owner.Lis_Pendens_Show" />
            Lis Pendens&nbsp;
            <select ng-model="owner.Lis_Pendens_Status" ng-show="owner.Lis_Pendens_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Lis_Pendens')" ng-show="owner.Lis_Pendens_Show"></pt-add>
        </h4>
        <div class="ss_border" ng-show="owner.Lis_Pendens_Show">
            <div ng-repeat="lis_penden in owner.Lis_Pendens" class="clearfix">
                <span class="label label-primary">Lis Penden&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.Lis_Pendens, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Index Num</label>
                        <input class="ss_form_input " ng-model="lis_penden.Lis_Pendens_Index_Num">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Date filed</label>
                        <input class="ss_form_input " ss-date ng-model="lis_penden.Lis_Pendens_Date_filed">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">County</label>
                        <input class="ss_form_input " ng-model="lis_penden.Lis_Pendens_County">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Servicer</label>
                        <input type="text" class="ss_form_input " ng-model="lis_penden.Lis_Pendens_Servicer" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Attorney</label>
                        <input type="text" class="ss_form_input " ng-model="lis_penden.Lis_Pendens_Attorney" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title ">
            <input type="checkbox" style="display: inline-block" ng-model="owner.Judgements_Show" />
            Judgements&nbsp;
            <select ng-model="owner.Judgements_Status" ng-show="owner.Judgements_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Judgements')" ng-show="owner.Judgements_Show"></pt-add>
        </h4>
        <div class="ss_border" ng-show="owner.Judgements_Show">
            <div ng-repeat="judgement in owner.Judgements" class="clearfix">
                <span class="label label-primary">Judgement&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.Judgements, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Index Num</label>
                        <input class="ss_form_input " ng-model="judgement.Judgement_Index_Num">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Plaintiff</label>
                        <input type="text" class="ss_form_input " ng-model="judgement.Judgement_Plaintiff" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Defendant</label>
                        <input type="text" class="ss_form_input " ng-model="judgement.Judgement_Defendant" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Attorney</label>
                        <input type="text" class="ss_form_input " ng-model="judgement.Judgement_Attorney" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                    <li class="clear-fix" style="list-style: none"></li>
                    <li class="ss_form_item_line" style="list-style: none">
                        <label class="ss_form_input_title ">Note +</label>
                        <textarea class="edit_text_area text_area_ss_form " model="judgement.Judgement_Note"></textarea>
                    </li>
                    <li class="clear-fix" style="list-style: none"></li>

                </ul>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title">
            <input type="checkbox" style="display: inline-block" ng-model="owner.ECB_Notes_Show" />
            ECB&nbsp;
            <select ng-model="owner.ECB_Notes_Status" ng-show="owner.ECB_Notes_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].ECB_Notes')" ng-show="owner.ECB_Notes_Show"></pt-add>
        </h4>
        <div class="ss_border" ng-show="owner.ECB_Notes_Show">
            <div ng-repeat="n in owner.ECB_Notes" class="clearfix">
                <div class="ss_form_item_line">
                    <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.ECB_Notes, $index, true)"></pt-del></label>
                    <textarea class="edit_text_area text_area_ss_form " ng-model="n.content"></textarea>
                </div>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title ">
            <input type="checkbox" style="display: inline-block" ng-model="owner.PVB_Notes_Show" />
            PVB&nbsp;
            <select ng-model="owner.PVB_Notes_Status" ng-show="owner.PVB_Notes_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].PVB_Notes')" ng-show="owner.PVB_Notes_Show"></pt-add>

        </h4>
        <div class="ss_border" ng-show="owner.PVB_Notes_Show">
            <div ng-repeat="n in owner.PVB_Notes" class="clearfix">
                <div class="ss_form_item_line">
                    <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.PVB_Notes, $index, true)"></pt-del></label>
                    <textarea class="edit_text_area text_area_ss_form " ng-model="n.content"></textarea>
                </div>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title ">
            <input type="checkbox" style="display: inline-block" ng-model="owner.Bankruptcy_Show" />
            Bankruptcy and Patriot&nbsp;
            <select ng-model="owner.Bankruptcy_Status" ng-show="owner.Bankruptcy_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Bankruptcy_Notes')" ng-show="owner.Bankruptcy_Show"></pt-add>

        </h4>
        <div class="ss_border" ng-show="owner.Bankruptcy_Show">
            <div ng-repeat="n in owner.Bankruptcy_Notes" class="clearfix">
                <div class="ss_form_item_line">
                    <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.Bankruptcy_Notes, $index, true)"></pt-del></label>
                    <textarea class="edit_text_area text_area_ss_form " ng-model="n.content"></textarea>
                </div>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title">
            <input type="checkbox" style="display: inline-block" ng-model="owner.UCCs_Show" />
            UCC&nbsp;
            <select ng-model="owner.UCCs_Status" ng-show="owner.UCCs_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].UCCs')" ng-show="owner.UCCs_Show"></pt-add>

        </h4>
        <div class="ss_border" ng-show="owner.UCCs_Show">
            <div ng-repeat="ucc in owner.UCCs" class="clearfix">
                <span class="label label-primary">UCC&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.UCCs, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Debtor </label>
                        <input class="ss_form_input " ng-model="ucc.UCC_Debtor">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Secured party </label>
                        <input class="ss_form_input " ng-model="ucc.UCC_Secured_Party">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Date filed</label>
                        <input class="ss_form_input " ss-date ng-model="ucc.UCC_Date_filed">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">CRFN Num</label>
                        <input class="ss_form_input " ng-model="ucc.UCC_CRFN_Num">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Attorney</label>
                        <input type="text" class="ss_form_input " ng-model="ucc.UCC_Attorney" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title">
            <input type="checkbox" style="display: inline-block" ng-model="owner.FederalTaxLiens_Show" />
            Federal Tax Liens&nbsp;
            <select ng-model="owner.FederalTaxLiens_Status" ng-show="owner.FederalTaxLiens_Show">
                <option>Pending</option>
                <option>Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].FederalTaxLiens')" ng-show="owner.FederalTaxLiens_Show"></pt-add>

        </h4>
        <div class="ss_border" ng-show="owner.FederalTaxLiens_Show">
            <div ng-repeat="federalTaxLien in owner.FederalTaxLiens" class="clearfix">
                <span class="label label-primary">Federal Tax Lien&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.FederalTaxLiens, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">CRFN Num</label>
                        <input class="ss_form_input " ng-model="federalTaxLien.Federal_Tax_Liens_CRFN_Num">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Date filed</label>
                        <input class="ss_form_input " ss-date ng-model="federalTaxLien.Federal_Tax_Liens_Date_filed">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Amount</label>
                        <input class="ss_form_input " money-mask ng-model="federalTaxLien.Federal_Tax_Liens_Amount">
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="ss_form ">
        <h4 class="ss_form_title">
            <input type="checkbox" style="display: inline-block" ng-model="owner.MechanicsLiens_Show" />
            Mechanics Lien&nbsp;
            <select ng-model="owner.MechanicsLiens_Status" ng-show="owner.MechanicsLiens_Show">
                <option></option>
                <option class="text-warning">Pending</option>
                <option class="text-success">Clear</option>
            </select>
            <pt-add class="pull-right" style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].MechanicsLiens')" ng-show="owner.MechanicsLiens_Show"></pt-add>
        </h4>
        <div class="ss_border" ng-show="owner.MechanicsLiens_Show">
            <div ng-repeat="mechanicsLien in owner.MechanicsLiens" class="clearfix">
                <span class="label label-primary">Mechanics Lien&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.MechanicsLiens, $index, true)"></pt-del>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Lienor</label>
                        <input class="ss_form_input " ng-model="mechanicsLien.Mechanics_Lien_Lienor">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Date filed</label>
                        <input class="ss_form_input " ss-date ng-model="mechanicsLien.Mechanics_Lien_Date_filed">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Amount</label>
                        <input class="ss_form_input " money-mask ng-model="mechanicsLien.Mechanics_Lien_Amount">
                    </li>
                    <li class="ss_form_item ">
                        <label class="ss_form_input_title ">Attorney</label>
                        <input type="text" class="ss_form_input " ng-model="mechanicsLien.Mechanics_Lien_Attorney" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

</uib-tab>
</uib-tabset>
