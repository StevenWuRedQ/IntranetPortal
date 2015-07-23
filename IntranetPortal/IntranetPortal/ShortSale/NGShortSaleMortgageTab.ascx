<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleMortgageTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleMortgageTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>

<tabset class="tab-switch">
    <tab ng-repeat="mortgage in SsCase.Mortgages" active="mortgage.active" disable="mortage.disabled">
        <tab-heading>Mortgage {{$index+1}} </tab-heading>
    <div class="collapse_div">
       <div class="text-right"><i class="fa fa-times btn tooltip-examples btn-close" ng-show="SsCase.Mortgages.length>=2" ng-click="NGremoveArrayItem(SsCase.Mortgages, $index)" title="Delete"></i></div>
        <div style="margin-top: 20px">
            <h4 class="ss_form_title">Sale Date / Payoff Info</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Auction Date</label>
                    <input class="ss_form_input " ss_date ng-model="mortgage.AuctionDate">
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
                    <input class="ss_form_input " ng-model="mortgage.PayoffRequested">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Expires</label>
                    <input class="ss_form_input " ng-model="mortgage.PayoffExpired">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Amount</label>
                    <input class="ss_form_input" mask-money ng-model="mortgage.PayoffAmount">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title" style="display: inline">Mortgage Company&nbsp</h4>
            <select class="class="ss_form_item" ng-model="mortgage.Lender" >
                <option ng-repeat="bank in bankNameOptions" value="{{bank}}">{{bank}}</option>
            </select>
            <i class="fa fa-compress btn  text-primary" ng-click="mortgageCompanyCollapse = !mortgageCompanyCollapse"></i>
                
            <ul class="ss_form_box clearfix">
                <div collapse="mortgageCompanyCollapse">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Category</label>
                    <input class="ss_form_input " ng-model="mortgage.Category">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status</label>
                    <input class="ss_form_input " ng-model="mortgage.Status">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan #</label>

                    <input class="ss_form_input " ng-model="mortgage.Loan">
                </li>
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
                 </div>
            </ul>
           
            </div>

        <div class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Short Sale Dept</label>
                <div class="contact_box" dx-select-box="InitContact('SsCase.Mortgages['+$index+'].ShortSaleDept')"></div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Customer Service #</label>
                <input class="ss_form_input" ng-model="GetContactById(mortgage.ShortSaleDept).OfficeNO" mask="(999) 999-9999" clean="true" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Short Sale Fax #</label>
                <input class="ss_form_input" ng-model="GetContactById(mortgage.ShortSaleDept).FAX" readonly="readonly">
            </li>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Title Contacts&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortgage.Contacts,'SsCase.Mortgages['+$index+'].Contacts')" title="Add"></i></h4>

            <div ng-show="mortgage.Contacts.length>0" class="ss_form_box clearfix">
                <div dx-data-grid="{
                    columns: [
                        { dataField: 'Description', caption: 'Description' },
                        { dataField: 'Title', caption: 'Title' },
                        { dataField: 'Name', caption: 'Name' },
                        { dataField: 'Phone',caption: 'Phone #' },
                        { dataField: 'Fax', caption: 'Fax #' },
                        { dataField: 'Email', caption: 'Email' }],
                    bindingOptions: { dataSource: 'SsCase.Mortgages['+$index+'].Contacts' },
                    editing: {
                        editMode: 'row',
                        editEnabled: true,
                        removeEnabled: true,
                } }">
                </div>
            </div>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortgage.Notes,'SsCase.Mortgages['+$index+'].Notes')" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,note) in mortgage.Notes track by index">
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Note {{index + 1}}&nbsp;<i class="fa fa-minus-circle text-warning" ng-click="NGremoveArrayItem(mortgage.Notes, index)"></i></label>                    
                    <textarea class="edit_text_area text_area_ss_form" ng-model="note.Content"></textarea>
                </li>
            </ul>
        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">Foreclosure</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Foreclosure Attorney </label>
                    <div class="contact_box" dx-select-box="InitContact('mortgage.ForeclosureAttorney')">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ForeclosureAttorney).Address" readonly="readonly">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Office #</label>
                    <input class="ss_form_input" ng-model="GetContactById(mortgage.ForeclosureAttorney).OfficeNO" mask="999-99-9999" clean="true" readonly="readonly">
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
    <i class="fa fa-plus-circle btn color_blue tooltip-examples" ng-click="NGAddArraryItem(SsCase.Mortgages, 'SsCase.Mortgages')" ng-show="SsCase.Mortgages.length<=2" title="Add"></i>
</tabset>


<div class="ss_form">
    <h4 class="ss_form_title">Lien</h4>
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
