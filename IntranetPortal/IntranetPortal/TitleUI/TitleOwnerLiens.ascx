<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleOwnerLiens.ascx.vb" Inherits="IntranetPortal.TitleOwnerLiens" %>
<div id="TitleLienCtrl" ng-controller="TitleLienCtrl">

        <uib-tabset class="tab-switch">
<uib-tab ng-repeat="owner in Form.FormData.Owners track by owner.name" active="owner.active" disable="owner.disabled">
<tab-heading>
    <i class="fa fa-arrow-circle-left" ng-show="$index>0" ng-click="swapOwnerPos($index)"></i>
    {{owner.name}}
</tab-heading>

    <div id="liens{{$index}}_content" class="ss_border" style="border-top: 0; min-height: 300px; position: relative">

        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[0]" ng-click="setPopVisible(owner, 1)">
            <div class="panel-heading">Mortgages: {{owner.Mortgages_Status}}</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="mortgage in owner.Mortgages">
                    <li><span class="label label-primary">Mortgage &nbsp; {{$index + 1}}</span></li>
                    <li>Status: {{mortgage.status}}</li>
                    <li>Name of the Mortgagor:  {{mortgage.Name_of_the_Mortgagor}}</li>
                    <li>Date of mortgage:   {{mortgage.Date_of_mortgage}}</li>
                    <li>Amount: {{mortgage.Amount}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[1]" ng-click="setPopVisible(owner, 2)">
            <div class="panel-heading">Lis Pendens:</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="lis_penden in owner.Lis_Pendens">
                    <li><span class="label label-primary">Lis Penden&nbsp;{{$index + 1}}:</span></li>
                    <li>Status: {{lis_penden.status}} </li>
                    <li>Index Num: {{lis_penden.Lis_Pendens_Index_Num}}</li>
                    <li>Date filed: {{lis_penden.Lis_Pendens_Date_filed}}</li>
                    <li>County: {{lis_penden.Lis_Pendens_County}}</li>
                    <li>Servicer: {{lis_penden.Lis_Pendens_Servicer}}</li>
                    <li>Attorney: {{lis_penden.Lis_Pendens_Attorney}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[2]" ng-click="setPopVisible(owner, 3)">
            <div class="panel-heading">Judgement:</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="judgement in owner.Judgements">
                    <li><span class="label label-primary">Judgement&nbsp;{{$index + 1}}:</span></li>
                    <li>Status: {{judgement.status}}</li>
                    <li>Index Num: {{judgement.Judgement_Index_Num}}</li>
                    <li>Plaintiff: {{judgement.Judgement_Plaintiff}}</li>
                    <li>Defendant: {{judgement.Judgement_Defendant}}</li>
                    <li>Attorney: {{judgement.Judgement_Attorney}}</li>
                    <li>Note: {{judgement.Judgement_Note}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[3]" ng-click="setPopVisible(owner, 4)">
            <div class="panel-heading">ECB:</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="n in owner.ECB_Notes">
                    <li><span class="label label-primary">Note {{$index + 1}}</span></li>
                    <li>Status: {{n.status}}</li>
                    <li>Note Content: {{n.content}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[4]" ng-click="setPopVisible(owner, 5)">
            <div class="panel-heading">PVB:</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="n in owner.PVB_Notes">
                    <li><span class="label label-primary">Note {{$index + 1}}</span></li>
                    <li>Status: {{n.status}}</li>
                    <li>Note Content: {{n.content}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[5]" ng-click="setPopVisible(owner, 6)">
            <div class="panel-heading">Bankruptcy:</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="n in owner.Bankruptcy_Notes">
                    <li><span class="label label-primary">Note {{$index + 1}}</span></li>
                    <li>Status: {{n.status}}</li>
                    <li>Note Content: {{n.content}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[6]" ng-click="setPopVisible(owner, 7)">
            <div class="panel-heading">UCC: </div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="ucc in owner.UCCs">
                    <li><span class="label label-primary">UCC {{$index + 1}}: </span></li>
                    <li>Status: {{ucc.status}}</li>
                    <li>Debtor :{{ucc.UCC_Debtor}}</li>
                    <li>Secured party :{{ucc.UCC_Secured_Party}}</li>
                    <li>Date filed :{{ucc.UCC_Date_filed}}</li>
                    <li>CRFN Num :{{ucc.UCC_CRFN_Num}}</li>
                    <li>Attorney: {{ucc.UCC_Attorney}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[7]" ng-click="setPopVisible(owner, 8)">
            <div class="panel-heading">Federal Tax: </div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="federalTaxLien in owner.FederalTaxLiens">
                    <li><span class="label label-primary">Federal Tax {{$index + 1}}: </span></li>
                    <li>Status: {{federalTaxLien.status}}</li>
                    <li>CRFN Num: {{federalTaxLien.Federal_Tax_Liens_CRFN_Num}}</li>
                    <li>Date filed: {{federalTaxLien.Federal_Tax_Liens_Date_filed}}</li>
                    <li>Amount: {{federalTaxLien.Federal_Tax_Liens_Amount}}</li>
                </ul>
            </div>
        </div>

        <div class="clearfix"></div>
        <div class="panel panel-default panel-condensed" ng-show="owner.shownlist[8]" ng-click="setPopVisible(owner, 9)">
            <div class="panel-heading">Mechanics Lien: {{owner.MechanicsLiens_Status}}</div>
            <div class="panel-body">
                <ul class="col-md-6" ng-repeat="mechanicsLien in owner.MechanicsLiens">
                    <li><span class="label label-primary">Mechanics Lien {{$index + 1}}: </span></li>
                    <li>Status: {{mechanicsLien.status}}</li>
                    <li>Lienor: {{mechanicsLien.Mechanics_Lien_Lienor}}</li>
                    <li>Date filed: {{mechanicsLien.Mechanics_Lien_Date_filed}}</li>
                    <li>Amount: {{mechanicsLien.Mechanics_Lien_Amount}}</li>
                    <li>Attorney: {{mechanicsLien.Mechanics_Lien_Attorney}}</li>
                </ul>
            </div>
        </div>

        <button type="button" class="btn btn-primary text-center" ng-show="!showWatermark(owner.shownlist)" ng-click="setPopVisible(owner)"><i class="fa fa-eye"></i>Modify Showing</button>
        <span class="watermark" style="position: relative; top: 140px; left: 280px" ng-show="showWatermark(owner.shownlist)" ng-click="setPopVisible(owner)">Show Form</span>

        <div dx-popup="{
                        height: 768,
                        width: 1024,
                        showTitle: false,
                        dragEnabled: true,
                        shading: true,
                        bindingOptions: { visible: 'Form.FormData.Owners[' + $index + '].popVisible' }
        }">
            <div data-options="dxTemplate:{ name: 'content' }">

                <div ng-show="owner.popVisible && owner.popStep==0">
                    <h4><b>Please select the content you want to show.</b></h4>
                    <br />
                    <table class="table table-condensed">
                        <tr>
                            <td>Mortgages</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[0]" /></td>
                        </tr>
                        <tr>
                            <td>Lis Pendens</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[1]" /></td>
                        </tr>
                        <tr>
                            <td>Judgements</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[2]" /></td>
                        </tr>
                        <tr>
                            <td>ECB</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[3]" /></td>
                        </tr>
                        <tr>
                            <td>PVB</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[4]" /></td>
                        </tr>
                        <tr>
                            <td>Bankruptcy and Patriot</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[5]" /></td>
                        </tr>
                        <tr>
                            <td>UCC</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[6]" /></td>
                        </tr>
                        <tr>
                            <td>Federal Tax Lien</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[7]" /></td>
                        </tr>
                        <tr>
                            <td>Mechanics Lien</td>
                            <td>
                                <input type="checkbox" style="display: inline-block" ng-model="owner.shownlist[8]" /></td>
                        </tr>
                    </table>
                </div>

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==1">
                    <h4 class="ss_form_title ">Mortgages&nbsp;
                    <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Mortgages')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="mortgage in owner.Mortgages" class="clearfix">
                            <span class="label label-primary">Mortage&nbsp;{{$index + 1}}:</span>
                            &nbsp;
                        <pt-del class="pull-right" ng-click="arrayRemove(owner.Mortgages, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="mortgage.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==2">
                    <h4 class="ss_form_title">Lis Pendens&nbsp;
                    <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Lis_Pendens')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="lis_penden in owner.Lis_Pendens" class="clearfix">
                            <span class="label label-primary">Lis Penden&nbsp;{{$index + 1}}:</span>&nbsp;
                            <pt-del class="pull-right" ng-click="arrayRemove(owner.Lis_Pendens, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="lis_penden.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==3">
                    <h4 class="ss_form_title ">Judgements&nbsp;
                        <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Judgements')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="judgement in owner.Judgements" class="clearfix">
                            <span class="label label-primary">Judgement&nbsp;{{$index + 1}}:</span>&nbsp;
                            <pt-del class="pull-right" ng-click="arrayRemove(owner.Judgements, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="judgement.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==4">
                    <h4 class="ss_form_title">ECB&nbsp;
                        <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].ECB_Notes')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="n in owner.ECB_Notes" class="clearfix">
                            <div><span class="label label-primary">Note {{$index + 1}}</span></div>
                            <div class="input-group" style="margin-top:10px">
                                <span class="input-group-addon">Status</span>
                                <select class="form-control" ng-model="n.status">
                                    <option>Pending</option>
                                    <option>Clear</option>
                                </select>
                            </div>
                            <div class="ss_form_item_line">
                                <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.ECB_Notes, $index, true)"></pt-del></label>
                                <textarea rows="3" class="edit_text_area" ng-model="n.content"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==5">
                    <h4 class="ss_form_title ">PVB&nbsp;
                    <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].PVB_Notes')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">

                        <div ng-repeat="n in owner.PVB_Notes" class="clearfix">
                            <div><span class="label label-primary">Note {{$index + 1}}</span></div>
                            <div class="input-group" style="margin-top:10px">
                                <span class="input-group-addon">Status</span>
                                <select class="form-control" ng-model="n.status">
                                    <option>Pending</option>
                                    <option>Clear</option>
                                </select>
                            </div>
                            <div class="ss_form_item_line">
                                <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.PVB_Notes, $index, true)"></pt-del></label>
                                <textarea rows="3" class="edit_text_area" ng-model="n.content"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==6">
                    <h4 class="ss_form_title ">Bankruptcy and Patriot&nbsp;
                        <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].Bankruptcy_Notes')" ng-show="owner.Bankruptcy_Show"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="n in owner.Bankruptcy_Notes" class="clearfix">
                            <div><span class="label label-primary">Note {{$index + 1}}</span></div>
                            <div class="input-group" style="margin-top:10px">
                                <span class="input-group-addon">Status</span>
                                <select class="form-control" ng-model="n.Bankruptcy_Status">
                                    <option>Pending</option>
                                    <option>Clear</option>
                                </select>
                            </div>
                            <div class="ss_form_item_line">
                                <label class="ss_form_input_title ">Notes&nbsp;{{$index + 1}}&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.Bankruptcy_Notes, $index, true)"></pt-del></label>
                                <textarea rows="3" class="edit_text_area" ng-model="n.content"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==7">
                    <h4 class="ss_form_title">UCC&nbsp;
                        <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].UCCs')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="ucc in owner.UCCs" class="clearfix">
                            <span class="label label-primary">UCC&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.UCCs, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="ucc.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==8">
                    <h4 class="ss_form_title">Federal Tax Liens&nbsp;
                    <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].FederalTaxLiens')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">
                        <div ng-repeat="federalTaxLien in owner.FederalTaxLiens" class="clearfix">
                            <span class="label label-primary">Federal Tax Lien&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.FederalTaxLiens, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="federalTaxLien.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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

                <div class="ss_form" ng-show="owner.popVisible && owner.popStep==9">
                    <h4 class="ss_form_title">Mechanics Lien&nbsp;
                    <pt-add style="padding-top: 8px" ng-click="ensurePush('Form.FormData.Owners['+$index+'].MechanicsLiens')"></pt-add>
                    </h4>
                    <div class="ss_border" style="max-height: 600px; overflow-y: scroll">

                        <div ng-repeat="mechanicsLien in owner.MechanicsLiens" class="clearfix">
                            <span class="label label-primary">Mechanics Lien&nbsp;{{$index + 1}}:</span>&nbsp;<pt-del class="pull-right" ng-click="arrayRemove(owner.MechanicsLiens, $index, true)"></pt-del>
                            <ul class="ss_form_box clearfix">
                                <li class="input-group" style="margin-top:10px">
                                    <span class="input-group-addon">Status</span>
                                    <select class="form-control" ng-model="mechanicsLien.status">
                                        <option>Pending</option>
                                        <option>Clear</option>
                                    </select>
                                </li>
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


                <div style="position: absolute; bottom: 10px; width: 95%">
                    <hr />
                    <button type="button" class="btn btn-primary" ng-click="previous(owner)" ng-disabled="!showPrevious(owner)">Previous</button>
                    <button type="button" class="btn btn-primary" ng-click="next(owner)" ng-disabled="!showNext(owner)">Next</button>
                    <button type="button" class="btn btn-danger pull-right" ng-click="setPopHide(owner)">Close</button>
                </div>
            </div>
        </div>
    </div>

        </uib-tab>
</uib-tabset>
</div>

<script>
    angular.module("PortalApp").controller('TitleLienCtrl', function ($scope, ptCom) {
        $scope.Form = $scope.$parent.Form;

        $scope.reload = function () {
            $scope.Form = $scope.$parent.Form;
        }

        $scope.setPopVisible = function (model, step) {

            model.popVisible = true;
            model.popStep = step ? step : 0;

        }

        $scope.setPopHide = function (model) {
            model.popVisible = false;
            model.popStep = 0;
        }

        $scope.showWatermark = function (model) {
            var result = true;
            _.each(model, function (n) {
                result &= !n
            })
            return result;
        }

        $scope.showNext = function (model) {
            var step = model.popStep;
            return ptCom.next(model.shownlist, true, step) >= 0;
        }
        $scope.next = function (model) {
            var step = model.popStep;
            if ($scope.showNext(model)) {
                model.popStep = ptCom.next(model.shownlist, true, step) + 1;
            } else {
                $scope.setPopHide(model);
            }

        }
        $scope.showPrevious = function (model) {
            var step = model.popStep;
            return ptCom.previous(model.shownlist, true, step) >= 0;
        }

        $scope.previous = function (model) {
            var step = model.popStep;
            if ($scope.showPrevious(model)) {
                model.popStep = ptCom.previous(model.shownlist, true, step - 1) + 1;
            } else {
                $scope.setPopHide(model);
            }
        }

        $scope.$on('ownerliens-reload', function (e, args) {
            $scope.reload();
        })
    })
</script>
