<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortPreSignControl.ascx.vb" Inherits="IntranetPortal.ShortPreSignControl" %>
<uib-tabset class="tab-switch">
    <uib-tab ng-repeat="owner in SsCase.PropertyInfo.Owners" active="owner.active" disable="owner.disabled">
        <tab-heading>Seller {{$index+1}} </tab-heading>

<div class="text-right" ng-show="SsCase.PropertyInfo.Owners.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.PropertyInfo.Owners.length>1" ng-click="NGremoveArrayItem(SsCase.PropertyInfo.Owners, $index)" title="Delete"></i></div>

<div ng-click="$eval('ViewStatus.Owner_'+$index+'=true')">
    
    <div class="ss_border" style="border-top-color: transparent">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title " ng-class="{ss_warning:!owner.FirstName||!owner.LastName}" data-message="Please fill seller {{$index+1}} name">Name</label>
                <input class="ss_form_input ss_not_empty" ng-value="formatName(owner.FirstName,owner.MiddleName,owner.LastName)" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title"  ng-class="{ss_warning:!owner.DOB}" data-message="Please fill seller {{$index+1}} DOB">DOB</label>
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

            <li class="ss_form_item">
                <label class="ss_form_input_title">Bankruptcy</label>
                <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="owner.Bankruptcy">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.Bankruptcy&&!owner.BankruptcyChapter}" data-message="If seller {{$index+1}} filed Bankruptcy please fill which chapter">Bankruptcy Chapter</label>
                <select class="ss_form_input" ng-model="owner.BankruptcyChapter" >
                    <option>Chapter 7</option>
                    <option>Chapter 13</option>
                </select>
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
           
        </ul>
        <div class="alert alert-warning" role="alert" ng-show="owner.Employed">
             45 days of paystubs required Profit and Loss required Award Letter required
        </div>
         <div class="alert alert-warning" role="alert" ng-show="owner.Bankaccount">
             3 months of bank statements
        </div>
         <div class="alert alert-warning" role="alert" ng-show="owner.TaxReturn">
             Last 2 Years of Tax Returns
        </div>
        
    </div>
</div>

<div dx-popup="{  
                    width: 900,
                    title: 'Seller '+ ($index+1),
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'ViewStatus.Owner_'+$index }
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
                    <label>Bankruptcy Chapter</label><br />
                    <select class="form-control" ng-model="owner.BankruptcyChapter" >
                        <option>Chapter 7</option>
                        <option>Chapter 13</option>
                    </select>
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
                    <select ng-model="owner.Employed" class="form-control">
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
        <button class="btn btn-primary pull-right" ng-click="$eval('ViewStatus.Owner_'+$index+'=false')">Save</button>
    </div>
</div>

<div style="margin:20px 0;">

    <uib-tabset class="tab-switch">
    <uib-tab ng-repeat="mortgage in SsCase.Mortgages|filter:{DataStatus:'!3'}" active="MortgageTabs[$index]" disable="mortage.disabled" >
        <tab-heading>Mortgage {{$index+1}} </tab-heading>
            <div class="text-right" style="margin-bottom:-25px" ng-show="$index>0"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="NGremoveArrayItem(SsCase.Mortgages, $index,true)" title="Delete"></i></div>
            <div>
            <div class="ss_border" style="border-top-color: transparent">
          <div class="ss_form">
            <h4 class="ss_form_title" style="display: inline" ng-class="{ss_warning:!mortgage.LenderId }" data-message="Please fill Mortgage {{$index+1}} Company">Mortgage {{$index+1}} Company&nbsp
                <select ng-model="mortgage.LenderId" ng-options="bank.ContactId as bank.Name for bank in bankNameOptions"></select>&nbsp;<pt-collapse model="mortgageCompanyCollapse" /></h4>
            <div class="ss_border">
            <ul class="ss_form_box clearfix">
               
                <li class="ss_form_item">
                    <label class="ss_form_input_title" ng-class="{ss_warning:!mortgage.Loan }" data-message="Please fill Mortgage {{$index+1}} Loan Number">Mortgage {{$index+1}} Loan #</label>
                    <input class="ss_form_input " ng-model="mortgage.Loan">
                </li>
               
                <li class="ss_form_item">
                    <label class="ss_form_input_title" ng-class="{ss_warning:!mortgage.LoanAmount }" data-message="Please fill Mortgage {{$index+1}} Loan Amount">Mortgage {{$index+1}} Loan Amount</label>
                    <input class="ss_form_input" ng-model="mortgage.LoanAmount" money-mask>

                </li>
               
            </ul>
        </div>
        </div>
        </div>
        </div>


    </uib-tab>
    <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.Mortgages, 'SsCase.Mortgages')" ng-show="SsCase.Mortgages.length<=2" title="Add" style="font-size: 18px"></i>
</uib-tabset>

    </div>
