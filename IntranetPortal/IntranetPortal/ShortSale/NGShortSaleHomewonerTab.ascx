<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleHomewonerTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleHomewonerTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<%@ Import Namespace="IntranetPortal" %>
<tabset class="tab-switch">
    <tab ng-repeat="owner in SsCase.PropertyInfo.Owners" active="owner.active" disable="owner.disabled">
                <tab-heading>Seller {{$index+1}} </tab-heading>
    <div class="collapse_div">
               <div class="text-right"><i class="fa fa-times btn tooltip-examples" ng-show="SsCase.PropertyInfo.Owners.length>=2" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.Owners, $index)" title="Delete" style="border:1px solid; border-radius:3px; margin:2px"></i></div>

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
                    <input class="ss_form_input ss_email" mask="(999) 999-9999" clean="true" ng-model="owner.AdlPhone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email Address</label>
                    <input class="ss_form_input ss_email" ng-model="owner.Email">
                </li>

            </ul>
        </div>

        <div class="ss_form">

            <h4 class="ss_form_title">Contacts <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(owner.Contacts,'SsCase.PropertyInfo.Owners['+$index+'].Contacts')" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,contact) in owner.Contacts">
                <li style="list-style-type: none">
                    <h4>Contact {{index + 1}} </h4>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">name</label>
                    <input class="ss_form_input ss_not_empty" ng-model="contact.Name">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_empty" ng-model="contact.Phone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input" ng-model="contact.Email">
                </li>
            </ul>
        </div>
        <div class="ss_form">

            <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(owner.Notes,'SsCase.PropertyInfo.Owners['+$index+'].Notes')" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,note) in owner.Notes">
                
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

                    <input type="radio" id="checkYes_Bankruptcy{{$index}}" data-test="1" name="44{{$index}}" ng-model="owner.Bankruptcy" value="true" class="ss_form_input">
                    <label for="checkYes_Bankruptcy{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="checkYes_BankruptcyNo{{$index}}" name="44{{$index}}" data-test="1" ng-model="owner.Bankruptcy" value="false" class="ss_form_input">
                    <label for="checkYes_BankruptcyNo{{$index}}" class="input_with_check"><span class="box_text">No</span></label>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">employed</label>
                    <select class="ss_form_input" ng-model="owner.Employed">
                        <option>Employed</option>
                        <option>Self-Employed</option>
                        <option>Unemployed</option>
                        <option>Retired</option>
                        <option>SSI / Disability</option>
                    </select>
                </li>
                <%--<li class="ss_form_item">
                      <input type="button" onclick="testClick()" value="Test">
                 </li>--%>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">bank account</label>

                    <input type="radio" id="checkYes_Bankaccount{{$index}}" ng-model="owner.Bankaccount" data-radio="Y" name="Bankaccount{{$index}}" value="YES" class="ss_form_input">
                    <label for="checkYes_Bankaccount{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="checkNOBankaccount{{$index}}" ng-model="owner.Bankaccount" name="Bankaccount{{$index}}" value="NO" class="ss_form_input">
                    <label for="checkNOBankaccount{{$index}}" class="input_with_check"><span class="box_text">No</span></label>

                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tax Returns</label>

                    <input type="radio" id="checkYes_TaxReturn{{$index}}" name="TaxReturn{{$index}}" ng-model="owner.TaxReturn" data-radio="Y" value="YES" class="ss_form_input">
                    <label for="checkYes_TaxReturn{{$index}}" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="TaxReturnNo{{$index}}" name="TaxReturn{{$index}}" ng-model="owner.TaxReturn" value="NO" class="ss_form_input">
                    <label for="TaxReturnNo{{$index}}" class="input_with_check"><span class="box_text">No</span></label>

                </li>
                
            </ul>
        </div>
      <%--  <div class="ss_form">
            <h4 class="ss_form_title">Estate Attorney
                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('PropertyInfo.Owners[__index__].EstateAttorneyContact', function(party){ShortSaleCaseData.PropertyInfo.Owners[__index__].EstateAttorneyId =party.ContactId; })"></i>

            </h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_edit" ng-model="owner.EstateAttorneyContact.Name">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Office #</label>
                    <input class="ss_form_input ss_not_edit" ng-model="owner.EstateAttorneyContact.OfficeNO">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input ss_not_edit" ng-model="owner.EstateAttorneyContact.Email">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">also acting as seller attorney</label>

                    <input type="radio" id="checkYes_ActingAsSellerAttorney__index__" ng-model="owner.ActingAsSellerAttorney" data-radio="Y" name="48__index__" value="YES">
                    <label for="checkYes_ActingAsSellerAttorney__index__" class="input_with_check"><span class="box_text">Yes</span></label>

                    <input type="radio" id="none_check_no48__index__" ng-model="owner.ActingAsSellerAttorney" name="48__index__" value="NO">
                    <label for="none_check_no48__index__" class="input_with_check"><span class="box_text">No</span></label>

                </li>
            </ul>
        </div>--%>
    </div>
        </tab>
       <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.PropertyInfo.Owners)" ng-show="SsCase.PropertyInfo.Owners.length<=2" title="Add"></i>
</tabset>
