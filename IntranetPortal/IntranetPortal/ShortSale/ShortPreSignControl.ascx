<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortPreSignControl.ascx.vb" Inherits="IntranetPortal.ShortPreSignControl" %>
<style>
    .ss_warning2 {
        color: red;
    }

    .form_ignore {
    }
</style>

<uib-tabset class="tab-switch">
    <uib-tab ng-repeat="owner in SsCase.PropertyInfo.Owners" active="owner.active" disable="owner.disabled">
        <tab-heading>Seller {{$index+1}} </tab-heading>

        <div class="text-right" ng-show="SsCase.PropertyInfo.Owners.length>1" style="margin-bottom: -25px"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.PropertyInfo.Owners.length>1" ng-click="ptCom.arrayRemove(SsCase.PropertyInfo.Owners, $index)" title="Delete"></i></div>

        <div ng-click="$eval('ViewStatus.Owner_'+$index+'=true')">
    
    <div class="ss_border" style="border-top-color: transparent" >
        <%--owner person corp form--%>
        
        <ul class="ss_form_box clearfix" ng-class="{form_ignore: owner.isCorp}" ng-show="!owner.isCorp">
            <li class="ss_form_item">

               <label class="ss_form_input_title">Is Corp</label>
               <pt-radio model="owner.isCorp"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title " ng-class="{ss_warning:!owner.FirstName||!owner.LastName}" data-message="Please fill seller {{$index+1}} name">Name *</label>
                <input class="ss_form_input ss_not_empty" ng-value="formatName(owner.FirstName,owner.MiddleName,owner.LastName)" readonly>
            </li>
            
            <li class="ss_form_item">
                <label class="ss_form_input_title"  ng-class="{ss_warning:!owner.DOB}" data-message="Please fill seller {{$index+1}} DOB">DOB *</label>
                <input class="ss_form_input" ng-model="owner.DOB" mask="99/99/9999" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.SSN}" data-message="Please fill seller {{$index+1}} SSN">SSN *</label>
                <input class="ss_form_input" ng-model="owner.SSN" mask="999-99-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.MailNumber|| !owner.MailStreetName || !owner.MailCity|| !owner.MailState|| !owner.MailZip}" data-message="Please complete seller {{$index+1}} Mail Address">Mail Address *</label>
                <input class="ss_form_input" ng-value="formatAddr(owner.MailNumber, owner.MailStreetName, owner.MailApt, owner.MailCity, owner.MailState, owner.MailZip)" style="width: 96.66%" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.Phone}" data-message="Please fill seller {{$index+1}} Phone Number">Phone Number *</label>
                <input class="ss_form_input" ng-model="owner.Phone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Additional #</label>
                <input class="ss_form_input" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email Address</label>
                <input class="ss_form_input" ng-model="owner.Email" type="email" readonly >
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.Bankruptcy===null||owner.Bankruptcy===undefined}" data-message="Please check seller {{$index+1}} Bankruptcy">Bankruptcy</label>
                <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}" ng-disabled="true"></pt-radio>
            </li>
            <li class="ss_form_item" ng-show="owner.Bankruptcy">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.Bankruptcy&&!owner.BankruptcyChapter}" data-message="If Seller {{$index+1}} Bankruptcy has been filled, please provide bankruptcy chapter">Bankruptcy Chapter</label>
                <select class="ss_form_input" ng-model="owner.BankruptcyChapter" ng-disabled="true">
                    <option>Chapter 7</option>
                    <option>Chapter 13</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.Bankaccount===null||owner.Bankaccount===undefined}" data-message="Please check seller {{$index+1}} has bank account">Bank account</label>
                <pt-radio model="owner.Bankaccount" name="Bankaccount{{$index}}" ng-disabled="true"></pt-radio>
            </li>
             <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.ActiveMilitar===null||owner.ActiveMilitar===undefined}" data-message="Please check seller {{$index+1}} Active Military">Active Military</label>
                <pt-radio model="owner.ActiveMilitar" name="ActiveMilitar{{$index}}" ng-disabled="true"></pt-radio>
             </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:owner.TaxReturn===null||owner.TaxReturn===undefined}" data-message="Please check seller {{$index+1}} Tax Returns">Tax Returns</label>
                <pt-radio model="owner.TaxReturn" name="TaxReturn{{$index}}" ng-disabled="true"></pt-radio>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title"  ng-class="{ss_warning:!owner.Employed}" data-message="Please select seller {{$index+1}} Employe status">Employed</label>
                <select class="ss_form_input" ng-model="owner.Employed" readonly>
                    <option></option>
                    <option>Employed</option>
                    <option>Self-Employed</option>
                    <option>Unemployed</option>
                    <option>Retired</option>
                    <option>SSI / Disability</option>
                </select>
            </li>
           
        </ul>
        <%--end person type form--%>
        <%--corp type form--%>
        <ul class="ss_form_box clearfix"  ng-class="{ form_ignore:!owner.isCorp}" ng-show="owner.isCorp">
            <li class="ss_form_item">
               <label class="ss_form_input_title">Is Corp</label>
               <pt-radio model="owner.isCorp" ng-disabled="true"></pt-radio>
            </li>
             <li class="ss_form_item">
                <label class="ss_form_input_title " ng-class="{ss_warning:!owner.FirstName}" data-message="Please fill seller {{$index+1}} name">Name *</label>
                <input class="ss_form_input ss_not_empty" ng-value="owner.FirstName" readonly>
            </li>
            
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.SSN}" data-message="Please fill seller {{$index+1}} EIN">EIN *</label>
                <input class="ss_form_input" ng-model="owner.SSN" readonly>
            </li>
              <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.MailNumber|| !owner.MailStreetName || !owner.MailCity|| !owner.MailState|| !owner.MailZip}" data-message="Please complete seller {{$index+1}} Mail Address">Mail Address *</label>
                <input class="ss_form_input" ng-value="formatAddr(owner.MailNumber, owner.MailStreetName, owner.MailApt, owner.MailCity, owner.MailState, owner.MailZip)" style="width: 96.66%" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="{ss_warning:!owner.Phone}" data-message="Please fill seller {{$index+1}} Phone Number">Phone Number *</label>
                <input class="ss_form_input" ng-model="owner.Phone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Additional #</label>
                <input class="ss_form_input" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Email Address</label>
                <input class="ss_form_input" ng-model="owner.Email" type="email" readonly >
            </li>
         </ul>
        <%-- end corp type form --%>
        <div class="alert alert-warning" role="alert" ng-show="owner.Employed">
           
            <p ng-show="owner.Employed=='Employed'">  <i class="fa fa-warning"></i> 45 days of paystubs required</p>
            <p ng-show="owner.Employed=='Self-Employed'">  <i class="fa fa-warning"></i> Profit and Loss required</p>
            <p ng-show="owner.Employed=='Retired'||owner.Employed=='SSI / Disability'"> <i class="fa fa-warning"></i> Award Letter required</p>
            <p ng-show="owner.Employed=='Unemployed'"> <i class="fa fa-warning"></i> Letter of explanation required</p>
        </div>
         <div class="alert alert-warning" role="alert" ng-show="owner.Bankaccount">
            <i class="fa fa-warning"></i> 3 months of bank statements
        </div>
         <div class="alert alert-warning" role="alert" ng-show="owner.TaxReturn">
             <i class="fa fa-warning"></i> Last 2 Years of Tax Returns
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
            <div class="row form-group" ng-show="!owner.isCorp">
               <div class="col-sm-4">
                   <label ng-class="{ss_warning2:!owner.isCorp===null||owner.isCorp===undefined}">Is Corp *</label> <br />
                   <pt-radio model="owner.isCorp" name="owner{{$index}}1"></pt-radio>
               </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.FirstName}">First Name *</label>
                    <input class="form-control" ng-model="owner.FirstName">
                </div>
                <div class="col-sm-4">
                    <label>Middle Name</label>
                    <input class="form-control" ng-model="owner.MiddleName">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.LastName}">Last Name *</label>
                    <input class="form-control" ng-model="owner.LastName">
                </div>
               
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.DOB}">DOB *</label>
                    <input class="form-control" ng-model="owner.DOB" placeholder="mm/dd/yyyy" clean="true" mask="19/39/9999">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.SSN}">SSN *</label>
                    <input class="form-control" ng-model="owner.SSN" mask="999-99-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.Phone}">Phone Number *</label>
                    <input class="form-control" ng-model="owner.Phone" mask="(999) 999-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label >Additional Number</label>
                    <input class="form-control" ng-model="owner.AdlPhone" mask="(999) 999-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label>Email Address</label>
                    <input class="form-control" ng-model="owner.Email" type="email">
                </div>
            </div>
            <%--corp owner form--%>
            <div class="row form-group" ng-show="owner.isCorp">
               <div class="col-sm-4">
                   <label ng-class="{ss_warning2:!owner.isCorp===null||owner.isCorp===undefined}">Is Corp *</label> <br />
                   <pt-radio model="owner.isCorp" name="owner{{$index}}1"></pt-radio>
               </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.FirstName}">Name *</label>
                    <input class="form-control" ng-model="owner.FirstName">
                </div>
              

               
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.SSN}">EIN *</label>
                    <input class="form-control" ng-model="owner.SSN" mask="999-99-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.Phone}">Phone Number *</label>
                    <input class="form-control" ng-model="owner.Phone" mask="(999) 999-9999" clean="true">
                </div>
                <div class="col-sm-4">
                    <label >Additional Number</label>
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
                    <label ng-class="{ss_warning2:!owner.MailNumber}">Street number *</label>
                    <input class="form-control" ng-model="owner.MailNumber">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.MailStreetName}">Street name *</label>
                    <input class="form-control" ng-model="owner.MailStreetName">
                </div>
                <div class="col-sm-4">
                    <label>Apt #</label>
                    <input class="form-control" ng-model="owner.MailApt">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.MailCity}">City *</label>
                    <input class="form-control" ng-model="owner.MailCity">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.MailState}">State *</label>
                    <input class="form-control" ng-model="owner.MailState">
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.MailZip}">Zip *</label>
                    <input class="form-control" ng-model="owner.MailZip" mask="99999" clean='true'>
                </div>
            </div>
            <hr>
            <div class="row form-group" ng-show="!owner.isCorp">
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:owner.Bankruptcy===null||owner.Bankruptcy===undefined}">Bankruptcy *</label><br />
                    <pt-radio model="owner.Bankruptcy" name="ownerBankruptcy{{$index}}2"></pt-radio>
                </div>
                <div class="col-sm-4" ng-show="owner.Bankruptcy">
                    <label ng-class="{ss_warning2:!owner.BankruptcyChapter}">Bankruptcy Chapter *</label><br />
                    <select class="form-control" ng-model="owner.BankruptcyChapter">
                        <option>Chapter 7</option>
                        <option>Chapter 13</option>
                    </select>
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:owner.Bankaccount===null||owner.Bankaccount===undefined}">Bank account</label><br />
                    <pt-radio model="owner.Bankaccount" name="Bankaccount{{$index}}2"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:owner.ActiveMilitar===null||owner.ActiveMilitar===undefined}">Active Military *</label><br />
                    <pt-radio model="owner.ActiveMilitar" name="ActiveMilitar{{$index}}2"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:owner.TaxReturn===null||owner.TaxReturn===undefined}">Tax Returns *</label><br />
                    <pt-radio model="owner.TaxReturn" name="TaxReturn{{$index}}2"></pt-radio>
                </div>
                <div class="col-sm-4">
                    <label ng-class="{ss_warning2:!owner.Employed}">Employed *</label><br />
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
                    <label >Paystubs </label><br />
                    <pt-radio model="owner.Paystubs" name="Paystubs{{$index}}2"></pt-radio>
                </div>
            </div>
            
        </div>
        <br />
        <button class="btn btn-primary pull-right" type="button" ng-click="$eval('ViewStatus.Owner_'+$index+'=false')">Save</button>
    </div>
</div>
        </uib-tab>
    <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="ensurePush('SsCase.PropertyInfo.Owners',{isCorp:false})"  title="Add" style="font-size: 18px"></i>
    </uib-tabset>


<div style="margin: 20px 0;">
    <uib-tabset class="tab-switch">
        <uib-tab ng-repeat="mortgage in SsCase.Mortgages|filter:{DataStatus:'!3'}" active="MortgageTabs[$index]" disable="mortage.disabled" >
            <tab-heading> Mortgage {{$index+1}} </tab-heading>
                <div class="text-right" style="margin-bottom:-25px" ng-show="$index>0"><i class="fa fa-times btn tooltip-examples btn-close" ng-click="ptCom.arrayRemove(SsCase.Mortgages, $index,true)" title="Delete"></i></div>
                <div>
                <div class="ss_border" style="border-top-color: transparent">
                    <div class="ss_form">
                        <h4 class="ss_form_title" style="display: inline"> <span style="text-transform:lowercase">{{$index+1|ordered}}</span>  Mortgage 
                            <%--<select ng-model="mortgage.LenderId" ng-options="bank.ContactId as bank.Name for bank in bankNameOptions"></select>--%>&nbsp;<pt-collapse model="mortgageCompanyCollapse" /></h4>
                        <div class="ss_border">
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title" ng-class="{ss_warning:!mortgage.LenderName }" data-message="Please fill {{$index+1|ordered}} Mortgage Company">Company</label>
                                    <input class="ss_form_input " ng-model="mortgage.LenderName" typeahead="bank.Name for bank in bankNameOptions|filter:$viewValue" typeahead-on-select="mortgage.Lender=$item;mortgage.LenderId=$item.ContactId">
                                </li>                               
                                <li class="ss_form_item"  ng-show="mortgage.LenderName!='N/A'">
                                    <label class="ss_form_input_title" ng-class="{ss_warning:mortgage.LenderName!='N/A' && !mortgage.Loan }" data-message="Please fill {{$index+1|ordered}} Mortgage Loan Number">Loan #</label>
                                    <input class="ss_form_input " ng-model="mortgage.Loan">
                                </li>

                                <li class="ss_form_item"  ng-show="mortgage.LenderName!='N/A'">
                                    <label class="ss_form_input_title" ng-class="{ss_warning:mortgage.LenderName!='N/A'&& !mortgage.LoanAmount }" data-message="Please fill {{$index+1|ordered}} Mortgage Loan Amount"> Loan Amount</label>
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
