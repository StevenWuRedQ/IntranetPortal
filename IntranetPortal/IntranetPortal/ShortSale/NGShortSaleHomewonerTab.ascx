<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<tabset class="tab-switch">
    <tab ng-repeat="owner in SsCase.PropertyInfo.Owners" active="owner.active" disable="owner.disabled">
              <tab-heading>Seller {{$index+1}} </tab-heading>
              <div class="collapse_div nga-default nga-fade">
              <div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="$index>0" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.Owners, $index)" title="Delete" style="border:1px solid; border-radius:3px; margin:2px"></i></div>

        <div>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">First name</label>
                    <input class="ss_form_input ss_not_empty" ng-model="owner.FirstName">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Middle name</label>
                    <input class="ss_form_input ss_not_empty" ng-model="owner.MiddleName">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last name</label>
                    <input class="ss_form_input ss_not_empty" ng-model="owner.LastName">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">ssn</label>
                    <input class="ss_form_input" mask="999-99-9999" clean="true" ng-model="owner.SSN">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">dob</label>
                    <input class="ss_form_input" ss-date ng-model="owner.DOB">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Cell #</label>
                    <input class="ss_form_input" mask="(999) 999-9999" clean="true" ng-model="owner.Phone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Additional #</label>
                    <input class="ss_form_input" mask="(999) 999-9999" clean="true" ng-model="owner.AdlPhone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email Address</label>
                    <input class="ss_form_input" ng-model="owner.Email" type="email">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Contacts <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(owner.Contacts,'SsCase.PropertyInfo.Owners['+$index+'].Contacts')" title="Add"></i></h4>

            <div ng-show="owner.Contacts.length>0" class="ss_form_box clearfix">
                <div dx-data-grid="{
                columns: [
                    { 
                    dataField: 'Description',
                    caption: 'Description',
                },
                { 
                    dataField: 'Name',
                    caption: 'Name',
                },{ 
                    dataField: 'Phone',
                    caption: 'Phone #'
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

        <div class="ss_form">

             <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(owner.Notes,'SsCase.PropertyInfo.Owners['+$index+'].Notes')" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,note) in owner.Notes track by index">
                
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Note {{index + 1}}&nbsp;<i class="fa fa-minus-circle text-warning" ng-click="NGremoveArrayItem(owner.Notes, index)"></i></label>                    
                    <textarea class="edit_text_area text_area_ss_form" ng-model="note.Content"></textarea>
                </li>

            </ul>


        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">mailing address</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">street nummber</label>
                    <input class="ss_form_input" ng-model="owner.MailNumber">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">street name</label>
                    <input class="ss_form_input" ng-model="owner.MailStreetName">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Apt #</label>
                    <input class="ss_form_input" ng-model="owner.MailApt">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">City</label>
                    <input class="ss_form_input" ng-model="owner.MailCity">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">State</label>
                    <input class="ss_form_input" ng-model="owner.MailState">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">zip</label>
                    <input class="ss_form_input ss_zip" mask="99999" clean='true' ng-model="owner.MailZip">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Financials</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item">
                    <label class="ss_form_input_title">bankruptcy</label>
                    <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}"></pt-radio>
                    <%-- 
                    <input type="radio" id="checkYes_Bankruptcy{{$index}}" data-test="1" name="44{{$index}}" ng-model="owner.Bankruptcy" ng-value="true" class="ss_form_input" radio-init="false">
                    <label for="checkYes_Bankruptcy{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="checkYes_BankruptcyNo{{$index}}" name="44{{$index}}" data-test="1" ng-model="owner.Bankruptcy" value="false" class="ss_form_input">
                    <label for="checkYes_BankruptcyNo{{$index}}" class="input_with_check"><span class="box_text">No</span></label>
                    --%>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">employed</label>
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
                    <label class="ss_form_input_title">bank account</label>
                    <pt-radio model="owner.Bankaccount" name="Bankaccount{{$index}}"></pt-radio>
                    <%--
                    <input type="radio" id="checkYes_Bankaccount{{$index}}" ng-model="owner.Bankaccount" data-radio="Y" name="Bankaccount{{$index}}" ng-value="true" class="ss_form_input" radio-init="false">
                    <label for="checkYes_Bankaccount{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="checkNOBankaccount{{$index}}" ng-model="owner.Bankaccount" name="Bankaccount{{$index}}" ng-value="false" class="ss_form_input">
                    <label for="checkNOBankaccount{{$index}}" class="input_with_check"><span class="box_text">No</span></label>
                        --%>
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tax Returns</label>
                    <pt-radio model="owner.TaxReturn" name="TaxReturn{{$index}}"></pt-radio>
                    <%-- 
                    <input type="radio" id="checkYes_TaxReturn{{$index}}" name="TaxReturn{{$index}}" ng-model="owner.TaxReturn" data-radio="Y" ng-value="true" class="ss_form_input" radio-init="false">
                    <label for="checkYes_TaxReturn{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="TaxReturnNo{{$index}}" name="TaxReturn{{$index}}" ng-model="owner.TaxReturn" ng-value="false" class="ss_form_input">
                    <label for="TaxReturnNo{{$index}}" class="input_with_check"><span class="box_text">No</span></label>
                    --%>
                </li>
                
            </ul>
        </div>
    </div>
        </tab>
       <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.PropertyInfo.Owners)" ng-show="SsCase.PropertyInfo.Owners.length<=2" title="Add"></i>
</tabset>
