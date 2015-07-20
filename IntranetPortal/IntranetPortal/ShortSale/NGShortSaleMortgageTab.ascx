<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleMortgageTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleMortgageTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>

<div ng-repeat="mortgage in SsCase.Mortgages" class="ss_array" style="margin-top:30px">
    <h4 class="ss_form_title title_with_line">
        <span class="title_index title_span">Mortgage {{$index+1}}</span>&nbsp;
        <i class="fa fa-expand expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="Expand or Collapse"></i>&nbsp;
        <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples " ng-click="NGAddArraryItem(SsCase.Mortgages)" title="Add"></i>
        <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="Delete"></i>
    </h4>

    <div class="collapse_div">
        <div>
            <h4 class="ss_form_title">Sale Date / Payoff Info</h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Auction Date</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.AuctionDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date of Sale</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.SaleDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Verified</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.VerifiedDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Requested</label>
                    <input class="ss_form_input " ng-model="mortgage.PayoffRequested">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Expires</label>
                    <input class="ss_form_input " ng-model="mortgage.PayoffExpires">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Payoff Amount</label>
                    <input class="ss_form_input " ng-model="mortgage.PayoffAmount">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Mortgage Company<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty('AssignedProcessor', function(party){ShortSaleCaseData.Processor=party.ContactId})"></i></h4>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Bank Name</label>
                    <select class="ss_form_input" ng-model="mortgage.BankName">
                        <option>A</option>
                        <option>B</option>
                        <option>C</option>
                    </select>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Category</label>
                    <input class="ss_form_input " ng-model="mortgage.CompanyCategory">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Status</label>
                    <input class="ss_form_input " ng-model="mortgage.CompanyStatus">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan #</label>
                    <input class="ss_form_input " ng-model="mortgage.Loan">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Loan Amount</label>
                    <input class="ss_form_input " ng-model="mortgage.LoanAmount">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Last Payment Date</label>
                    <input class="ss_form_input " ss_date="" ng-model="mortgage.LastPayDate">
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
        </div>

        <div class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Short Sale Dept #</label>
                <input class="ss_form_input " ng-model="mortgage.ShortSaleDeptNo">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Customer Service #</label>
                <input class="ss_form_input " ng-model="mortgage.CustomerServiceNo">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Customer Service #</label>
                <input class="ss_form_input " ng-model="mortgage.CustomerServiceNo">
            </li>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Contacts <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortage.Contacts)" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,contact) in mortage.Contacts">
                <li style="list-style-type: none">
                    <h4>Contact {{index + 1}} </h4>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Title</label>
                    <input class="ss_form_input ss_not_empty" ng-model="contact.Title">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Name</label>
                    <input class="ss_form_input ss_not_empty" ng-model="contact.Name">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Phone #</label>
                    <input class="ss_form_input ss_not_empty" ng-model="contact.Phone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Fax #</label>
                    <input class="ss_form_input" ng-model="contact.Email">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Email</label>
                    <input class="ss_form_input" ng-model="contact.Email">
                </li>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Notes <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="NGAddArraryItem(mortgage.Notes)" title="Add"></i></h4>
            <ul class="ss_form_box clearfix" ng-repeat="(index,note) in mortgage.Notes">
                <li style="list-style-type: none">
                    <h4>Note {{index + 1}} </h4>
                </li>
                <li class="ss_form_item ss_form_item_line">
                    <label class="ss_form_input_title">Note</label>
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
                    </div>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Address</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyAddr">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Office #</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyOfficeNo">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Assigned Attorney</label>
                    <input class="ss_form_input" ng-model="mortgage.AssignedAttorney">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney Direct #</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyDirectNO">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney Email</label>
                    <input class="ss_form_input" ng-model="mortgage.AttorneyEmail">
                </li>
            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Lien</h4>

            <table class="ss_form_table">
                <tr>
                    <th>Type</th>
                    <th>Effective</th>
                    <th>Expiration</th>
                    <th>Plaintiff</th>
                    <th>Defendant</th>
                    <th>Index</th>
                </tr>

                <tr ng-repeat="offer in SsCase.DealInfo.Offers">
                    <td>
                        <input class="ss_form_input " ng-model="mortgage.LienType">
                    </td>
                    <td>
                        <input class="ss_form_input " ss-date="" ng-model="mortgage.LienEffectiveDate">
                    </td>
                    <td>
                        <input class="ss_form_input " ss-date="" ng-model="mortgage.LienExpirationDate">
                    </td>
                    <td>
                        <input class="ss_form_input " ss-date="" ng-model="mortgage.LienPlaintiff">
                    </td>
                    <td>
                        <input class="ss_form_input " ss-date="" ng-model="mortage.LienDefendant">
                    </td>
                    <td>
                        <input class="ss_form_input " ss-date="" ng-model="mortage.LienIndex">
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>

