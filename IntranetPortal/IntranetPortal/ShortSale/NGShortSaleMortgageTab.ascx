<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleMortgageTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleMortgageTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>

<tabset class="tab-switch">
    <tab ng-repeat="mortgage in SsCase.Mortgages" active="mortgage.active" disable="mortage.disabled">
        <tab-heading>Mortgage {{$index+1}} </tab-heading>
            <div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.Mortgages.length>1" ng-click="NGremoveArrayItem(SsCase.Mortgages, $index)" title="Delete" style="border:1px solid; border-radius:3px; margin:2px"></i></div>
        <div style="margin-top: 20px">
            <h4 class="ss_form_title">Sale Date / Payoff Info</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Auction Date</label>
                    <pt-radio model="mortgage.AuctionDate" name="mortgageAuctionDate"></pt-radio>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date of Sale</label>
                    <input class="ss_form_input " ss_date ng-model="mortgage.DateOfSale">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Verified</label>
                    <input class="ss_form_input " ss_date ng-model="mortgage.DateVerified">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Requested</label>
                    <input class="ss_form_input " ss_date ng-model="mortgage.PayoffRequested">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Expires</label>
                    <input class="ss_form_input " ss_date ng-model="mortgage.PayoffExpired">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Amount</label>
                    <input class="ss_form_input" mask-money ng-model="mortgage.PayoffAmount">
                </li>
            </ul>
        </div>
        <div class="ss_form">
            <h4 class="ss_form_title" style="display: inline">Mortgage Company&nbsp
            <select class="class="ss_form_item" ng-model="mortgage.ShortSaleDept" ng-options="bank.ContactId as bank.Name for bank in bankNameOptions"></select>&nbsp;
            <i class="fa fa-compress text-primary" ng-show="mortgageCompanyCollapse" ng-click="mortgageCompanyCollapse = !mortgageCompanyCollapse"></i>
            <i class="fa fa-expand text-primary" ng-show="!mortgageCompanyCollapse" ng-click="mortgageCompanyCollapse = !mortgageCompanyCollapse"></i></h4>
            <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Category</label>
                    <input class="ss_form_input " ng-model="mortgage.Category" readonly="readonly">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status</label>
                    <input class="ss_form_input " ng-model="mortgage.Status" readonly="readonly">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan #</label>

                    <input class="ss_form_input " ng-model="mortgage.Loan">
                </li>
                <div collapse="mortgageCompanyCollapse">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan Amount</label>
                    <input class="ss_form_input" mask-money ng-model="mortgage.LoanAmount">

                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Payment Date</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.LastPaymentDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Mortgage Type</label>
                    <select class="ss_form_input" ng-model="mortgage.Type">
                        <option value=""></option>
                        <option value="Fannie">Fannie</option>
                        <option value="FHA">FHA</option>
                        <option value="Freddie Mac">Freddie Mac</option>
                        <option value="Ginnie Mae">Ginnie Mae</option>
                        <option value="Conventional">Conventional</option>
                        <option value="Private">Private</option>
                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Authorization Sent</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.AuthorizationSent">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Cancelation Sent</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.CancelationSent">
                </li>
            </ul>
            <ul  class="ss_form_box clearfix" collapse="mortgageCompanyCollapse">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Short Sale Dept</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ShortSaleDept).OfficeNO" readonly="readonly">

                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Customer Service #</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ShortSaleDept).CustomerService" mask="(999) 999-9999" clean="true" readonly="readonly">
                </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Short Sale Fax #</label>
                <input class="ss_form_input" ng-model="GetContactById(mortgage.ShortSaleDept).FAX" readonly="readonly">
            </li>
            </ul>
        </div>
        </div>

        <div class="ss_form" collapse="mortgageCompanyCollapse">
            <h4 class="ss_form_title">Mortgage Contacts&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortgage.Contacts,'SsCase.Mortgages['+$index+'].Contacts')" title="Add"></i></h4>

            <div class="ss_border" ng-show="mortgage.Contacts.length>0">
            <div  class="ss_form_box clearfix">
                <div dx-data-grid="{
                    columns: [
                        { dataField: 'Title', caption: 'Title',width: 50, },
                        { dataField: 'Name', caption: 'Name', width: 100 },
                        { dataField: 'Phone',caption: 'Phone #', width: 150 },
                        { dataField: 'Fax', caption: 'Fax #',width: 150 },
                        { dataField: 'Email', caption: 'Email',width: 150 }],
                    bindingOptions: { dataSource: 'SsCase.Mortgages['+$index+'].Contacts' },
                    editing: {
                        editMode: 'row',
                        editEnabled: true,
                        removeEnabled: true,
                } }">
                </div>
            </div>
        </div>
        </div>

        <div class="ss_form" collapse="mortgageCompanyCollapse">
            <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortgage.Notes,'SsCase.Mortgages['+$index+'].Notes')" title="Add"></i></h4>
            <ul class="ss_form_box clearfix textAreaDiv" ng-repeat="(index,note) in mortgage.Notes track by index">
                <li class="ss_form_item ss_form_item_line ">
                    <label class="ss_form_input_title">Note {{index + 1}}&nbsp;<i class="fa fa-minus-circle text-warning" ng-click="NGremoveArrayItem(mortgage.Notes, index)"></i></label>                    
                    <textarea class="edit_text_area text_area_ss_form" ng-model="note.Content"></textarea>
                </li>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Foreclosure</h4>
            <div class="ss_border">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Foreclosure Attorney </label>
                    <div class="contact_box" dx-select-box="InitContact('SsCase.Mortgages['+$index+'].ForeclosureAttorneyId')"></div>
                  
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ForeclosureAttorneyId).Address" readonly="readonly">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Office #</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ForeclosureAttorneyId).OfficeNO" mask="999-99-9999" clean="true" readonly="readonly">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Assigned Attorney</label>
                    <input class="ss_form_input" ng-model="mortgage.AssignedAttorney">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney Direct #</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyDirectNo" mask="999-99-9999" clean="true">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney Email</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyEmail" type="email">
                </li>
            </ul>
        </div>
    </div>
    </tab>
    <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.Mortgages, 'SsCase.Mortgages')" ng-show="SsCase.Mortgages.length<=2" title="Add" style="font-size: 18px"></i>
</tabset>


<div class="ss_form">
    <h4 class="ss_form_title">Lien</h4>
    <div class="ss_border">
        <div class="ss_form_box clearfix">
            <div id="lienGrid" dx-data-grid="{
                    columns: [
                    { dataField: 'Type',caption: 'Type'},
                    { dataField: 'Effective', caption: 'Effective', dataType: 'date' },
                    { dataField: 'Expiration', caption: 'Expiration', dataType: 'date' },
                    { dataField: 'Plaintiff',caption: 'Plaintiff'},
                    { dataField: 'Defendant', caption: 'Defendant' },
                    { dataField: 'Index', caption: 'Index' } ],
                    bindingOptions: { dataSource: 'SsCase.LeadsInfo.LisPens' }
                }">
            </div>
        </div>
    </div>
</div>
