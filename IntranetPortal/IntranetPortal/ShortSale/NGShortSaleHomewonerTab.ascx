<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.Data" %>
<%@ Import Namespace="IntranetPortal" %>


<uib-tabset class="tab-switch">
    <uib-tab ng-repeat="owner in SsCase.PropertyInfo.Owners" active="owner.active" disable="owner.disabled">
        <tab-heading>Seller {{$index+1}} </tab-heading>

<div class="text-right" ng-show="SsCase.PropertyInfo.Owners.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.PropertyInfo.Owners.length>1" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.Owners, $index)" title="Delete"></i></div>

<div ng-click="setVisiblePopup(SsCase.PropertyInfo.Owners[$index], true)">
    <div class="ss_border" style="border-top-color: transparent">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Name</label>
                <input class="ss_form_input ss_not_empty" ng-value="formatName(owner.FirstName,owner.MiddleName,owner.LastName)" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DOB</label>
                <input class="ss_form_input" ng-model="owner.DOB" ss-date readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">SSN</label>
                <input class="ss_form_input" ng-model="owner.SSN" mask="999-99-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title">Mail Address</label>
                <input class="ss_form_input" ng-value="formatAddr(owner.MailNumber, owner.MailStreetName, owner.MailApt, owner.MailCity, owner.MailState, owner.MailZip)" style="width: 96.66%" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input" ng-model="owner.Phone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Additional #</label>
                <input class="ss_form_input" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email Address</label>
                <input class="ss_form_input" ng-model="owner.Email" type="email" readonly>
            </li>

        </ul>
    </div>
</div>

<div dx-popup="{  
                    width: 900,
                    title: 'Seller '+ ($index+1),
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'SsCase.PropertyInfo.Owners['+$index+'].visiblePopup' }
        }">
    <div data-options="dxTemplate:{ name: 'content' }">
        <div>
            <div class="row form-group">
                <div class="col-sm-4">
                    <label>First Name</label>
                    <input class="form-control" ng-model="owner.FirstName">
                </div>
                <div class="col-sm-4">
                    <label>Middle Name</label>
                    <input class="form-control" ng-model="owner.MiddleName">
                </div>
                <div class="col-sm-4">
                    <label>LastName</label>
                    <input class="form-control" ng-model="owner.LastName">
                </div>
                <div class="col-sm-4">
                    <label>DOB</label>
                    <input class="form-control" ng-model="owner.DOB" ss-date>
                </div>
                <div class="col-sm-4">
                    <label>SSN</label>
                    <input class="form-control" ng-model="owner.SSN" mask="999-99-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label>Cell #</label>
                    <input class="form-control" ng-model="owner.Phone" mask="(999) 999-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label>Additional #</label>
                    <input class="form-control" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label>Email Address</label>
                    <input class="form-control" ng-model="owner.Email" type="email">
                </div>
            </div>
            <hr>
            <div class="row form-group">
                <div class="col-sm-4">
                    <label>Street nummber</label>
                    <input class="form-control" ng-model="owner.MailNumber">
                </div>
                <div class="col-sm-4">
                    <label>Street name</label>
                    <input class="form-control" ng-model="owner.MailStreetName">
                </div>
                <div class="col-sm-4">
                    <label>Apt #</label>
                    <input class="form-control" ng-model="owner.MailApt">
                </div>
                <div class="col-sm-4">
                    <label>City</label>
                    <input class="form-control" ng-model="owner.MailCity">
                </div>
                <div class="col-sm-4">
                    <label>State</label>
                    <input class="form-control" ng-model="owner.MailState">
                </div>
                <div class="col-sm-4">
                    <label>Zip</label>
                    <input class="form-control" ng-model="owner.MailZip" mask="99999" clean='true'>
                </div>
            </div>
            <hr>
            <div class="row form-group">
                <div class="col-sm-4">
                    <label>Bankruptcy</label><br />
                    <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label>Bank account</label><br />
                    <pt-radio model="owner.Bankaccount" name="Bankaccount{{$index}}"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label>Tax Returns</label><br />
                    <pt-radio model="owner.TaxReturn" name="TaxReturn{{$index}}"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label>Employed</label><br />
                    <select ng-model="owner.Employed">
                        <option></option>
                        <option>Employed</option>
                        <option>Self-Employed</option>
                        <option>Unemployed</option>
                        <option>Retired</option>
                        <option>SSI / Disability</option>
                    </select>
                </div>
                <div class="col-sm-4">
                    <label>Paystubs</label><br />
                    <pt-radio model="owner.Paystubs" name="Paystubs{{$index}}"></pt-radio>
                </div>
            </div>

        </div>
        <br />
        <button class="btn btn-primary pull-right" ng-click="setVisiblePopup(SsCase.PropertyInfo.Owners[$index], false)">Save</button>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Financials</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Bankruptcy</label>
                <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Bank account</label>
                <pt-radio model="owner.Bankaccount" name="Bankaccount{{$index}}"></pt-radio>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Returns</label>
                <pt-radio model="owner.TaxReturn" name="TaxReturn{{$index}}"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Employed</label>
                <select class="ss_form_input" ng-model="owner.Employed">
                    <option></option>
                    <option>Employed</option>
                    <option>Self-Employed</option>
                    <option>Unemployed</option>
                    <option>Retired</option>
                    <option>SSI / Disability</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Paystubs</label>
                <pt-radio model="owner.Paystubs" name="Paystubs{{$index}}"></pt-radio>
            </li>

        </ul>
    </div>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Contacts
        <pt-add ng-click="NGAddArraryItem(owner.Contacts,'SsCase.PropertyInfo.Owners['+$index+'].Contacts')" />
        &nbsp;<pt-collapse model="homeownerCollapse"></pt-collapse></h4>
    <div class="ss_border" uib-collapse="homeownerCollapse" ng-show="owner.Contacts.length>0">
        <div class="ss_form_box clearfix">
            <div dx-data-grid="{
                columns: [
                    {
                    dataField: 'Description',
                    caption: 'Description',
                    width: 100,
                },
                {
                    dataField: 'Name',
                    caption: 'Name',
                    width: 100,
                },{
                    dataField: 'Phone',
                    caption: 'Phone #',
                    width: 180,
                },{
                    dataField: 'Email',
                    caption: 'Email',
                }],
                bindingOptions: {
                    dataSource: 'SsCase.PropertyInfo.Owners['+$index+'].Contacts' },
                editing: {
                    editMode: 'row',
                    editEnabled: true,
                    removeEnabled: true
                } }">
            </div>
        </div>
    </div>
</div>
<div class="ss_form" uib-collapse="homeownerCollapse">
    <h4 class="ss_form_title">Notes<pt-add ng-click="NGAddArraryItem(owner.Notes,'SsCase.PropertyInfo.Owners['+$index+'].Notes')" /></h4>

    <ul class="ss_form_box textAreaDiv clearfix" ng-repeat="(index,note) in owner.Notes track by index">
        <li class="ss_form_item ss_form_item_line">
            <label class="ss_form_input_title">Note {{index + 1}}&nbsp;<i class="fa fa-minus-circle text-warning" ng-click="NGremoveArrayItem(owner.Notes, index)"></i></label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="note.Content"></textarea>
        </li>
    </ul>
</div>

    </uib-tab>
    <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.PropertyInfo.Owners, false)" ng-show="SsCase.PropertyInfo.Owners.length<=2" title="Add" style="font-size: 18px"></i>
</uib-tabset>
