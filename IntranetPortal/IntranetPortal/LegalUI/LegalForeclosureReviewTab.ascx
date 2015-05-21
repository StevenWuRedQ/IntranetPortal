<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalForeclosureReviewTab.ascx.vb" Inherits="IntranetPortal.LegalForeclosureReviewTab" %>
<div class="short_sale_content">
    <div class="clearfix">
        <div style="float: right">
            <input type="button" class="rand-button short_sale_edit" value="Completed Research" runat="server" onserverclick="btnCompleteResearch_ServerClick" id="btnCompleteResearch" visible="false" />
            <select class="ss_form_input" id="lbEmployee" runat="server" style="width: 150px" visible="false">
                <option value=""></option>
                <option value="Chris Yan">Chris Yan</option>
                <option value="Steven Wu">Steven Wu</option>
            </select>
            <input type="button" class="rand-button short_sale_edit" visible="false" value="Assign" runat="server" onserverclick="btnAssign_ServerClick" id="btnAssign" />
        </div>
    </div>

    <div>
        <h4 class="ss_form_title">Property</h4>

        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Street Number</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Number" value="2930">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Street Name</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.StreetName" value="TENBROECK AVE">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">City</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.City" value="BRONXDALE">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">State</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.State" value="NY">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Zip</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Zipcode" value="10469">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden color_blue_edit" value=" ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">BLOCK</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Block" value="4561">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Lot</label>
                <input class="ss_form_input color_blue_edit" data-field="PropertyInfo.Lot" value="22">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Building type</label>
                <select class="ss_form_input" data-field="PropertyInfo.BuildingType">
                    <option value="House">House</option>
                    <option value="Apartment">Apartment</option>
                    <option value="Condo">Condo</option>
                    <option value="Cottage/cabin">Cottage/cabin</option>
                    <option value="Duplex">Duplex</option>
                    <option value="Flat">Flat</option>
                    <option value="In-Law">In-Law</option>
                    <option value="Loft">Loft</option>
                    <option value="Townhouse">Townhouse</option>
                    <option value="Manufactured">Manufactured</option>
                    <option value="Assisted living">Assisted living</option>
                    <option value="Land">Land</option>
                </select>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Borrower</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Co-Borrower</label>
                <input class="ss_form_input">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Language</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Mental Capacity </label>
                <input class="ss_form_input">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Divorce</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Borrowers Relationship </label>
                <input class="ss_form_input">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">&nbsp;</label>
                <input class="ss_form_input ss_form_hidden" value=" ">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Estate</label>
                <input class="ss_form_input" type="number" data-field="PropertyInfo.NumOfStories">
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">c/o(<span class="linkey_pdf">pdf</span>)</span>

                <input type="radio" class="ss_form_input" data-field="PropertyInfo.CO" data-radio="Y" id="key_PropertyInfo_checkYes_CO" name="pdf" value="YES">
                <label for="key_PropertyInfo_checkYes_CO" class="input_with_check">
                    <span class="box_text">Yes</span>
                </label>

                <input type="radio" class="ss_form_input" data-field="PropertyInfo.CO" id="none_pdf_checkey_no21" name="pdf" value="NO">
                <label for="none_pdf_checkey_no21" class="input_with_check">
                    <span class="box_text"><span class="box_text">No</span></span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff <i class="fa fa-user popup"></i></label>
                <div dx-select-box="{ dataSource: selectBoxData,valueExpr: 'ContactId',displayExpr: 'Name',searchEnabled:true,bindingOptions: { value: 'selectValue' }}">
                </div>
                <%--<input class="ss_form_input" type="number" data-field="PropertyInfo.NumOfStories">--%>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff # <i class="fa fa-user popup"></i></label>
                <div dx-select-box="{ dataSource: selectBoxData,valueExpr: 'ContactId',displayExpr: 'OfficeNO',searchEnabled:true,value:selectValue,bindingOptions: { value: 'selectValue' }}">
                </div>

            </li>
        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Plaintiff <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name" value="Michael Simcha ">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.OfficeNO" value="7186765222">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.Cell" value="7186765222">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit ss_phone" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Plaintiff Attorney<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Servicer <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Defendant 1 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Defendant 2 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Attorney of record 1 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Attorney of record 2 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <%--background--%>
    <div class="ss_form">
        <h4 class="ss_form_title">Background</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Deed Xfer </label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Lien  </label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number" value="30000">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">UCC  </label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HPD </label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title">Questionable Satisfactions </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Title Issues </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>


        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Originator  <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">2nd Mortgage<i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="VendorsPopupClient.Show()" style="display: inline !important;"></i></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Name">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">manager</label>
                <input class="ss_form_input ss_not_edit" data-field="Manager" value="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Office</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Office">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">office #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.OfficeNO">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Cell #</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Cell">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">email</label>
                <input class="ss_form_input ss_not_edit" data-field="ReferralContact.Email">
            </li>
        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Mortgage</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Active/Dissolved Date </label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number" value="04/08/2015">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">1st Loan Amount</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">2nd Loan Amount</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Type of Loan</label>
                <select class="ss_form_input" data-field="PropertyInfo.Number">
                    <option>FHA</option>
                    <option>FANNIE MAE</option>
                    <option>FREDDIE</option>
                    <option>ARM</option>
                    <option>FIXED</option>
                    <option>80/20</option>
                    <option>COMMERCIAL</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">First Mortgage Payment</label>
                <input class="ss_form_input currency_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Maturity</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">last payment date</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Eviction status</span>

                <input type="radio" id="checy_41" name="1" value="YES" class="ss_form_input">
                <label for="checy_41" class="input_with_check">
                    <span class="box_text">Vacant </span>

                </label>

                <input type="radio" id="checy_42" name="1" value="NO" class="ss_form_input">
                <label for="checy_42" class="input_with_check">
                    <span class="box_text">Tenant</span>
                </label>

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">HAMP eligible</span>

                <input type="radio" id="checy_45" name="1" value="YES" class="ss_form_input">
                <label for="checy_45" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_46" name="1" value="NO" class="ss_form_input">
                <label for="checy_46" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>

        </ul>
    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Note</h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Count Of signed</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">note  endorsed</span>

                <input type="radio" id="checy_47" name="1" value="YES" class="ss_form_input">
                <label for="checy_47" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_48" name="1" value="NO" class="ss_form_input">
                <label for="checy_48" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">endorsed By Lender</span>

                <input type="radio" id="checy_49" name="1" value="YES" class="ss_form_input">
                <label for="checy_49" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_50" name="1" value="NO" class="ss_form_input">
                <label for="checy_50" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">endorsed Dept</span>

                <input type="radio" id="checy_51" name="1" value="YES" class="ss_form_input">
                <label for="checy_51" class="input_with_check ">
                    <span class="box_text">entity </span>

                </label>

                <input type="radio" id="checy_52" name="1" value="NO" class="ss_form_input">
                <label for="checy_52" class="input_with_check">
                    <span class="box_text">Blank</span>
                </label>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">endorsed signed date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>



        </ul>


    </div>
    <div class="ss_form">
        <h4 class="ss_form_title">Note Alonge</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <span class="ss_form_input_title">note  Alonge</span>

                <input type="radio" id="checy_61" name="1" value="YES" class="ss_form_input">
                <label for="checy_61" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_62" name="1" value="NO" class="ss_form_input">
                <label for="checy_62" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Alonge By Lender</span>

                <input type="radio" id="checy_63" name="1" value="YES" class="ss_form_input">
                <label for="checy_63" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_64" name="1" value="NO" class="ss_form_input">
                <label for="checy_64" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Alonge Dept</span>

                <input type="radio" id="checy_65" name="1" value="YES" class="ss_form_input">
                <label for="checy_65" class="input_with_check ">
                    <span class="box_text">entity </span>

                </label>

                <input type="radio" id="checy_66" name="1" value="NO" class="ss_form_input">
                <label for="checy_66" class="input_with_check">
                    <span class="box_text">Blank</span>
                </label>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">signed</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Alonge signed date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>



        </ul>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Court Activity</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Renewed Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Affidavit Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Affidavit Company</label>
                <input class="ss_form_input">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index disposition </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Index Opposing </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Conferences Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">

                <span class="ss_form_input_title">Conferences Attended</span>

                <input type="radio" id="checy_69" name="1" value="YES" class="ss_form_input">
                <label for="checy_69" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_70" name="1" value="NO" class="ss_form_input">
                <label for="checy_70" class="input_with_check">
                    <span class="box_text">No</span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Conferences Referee </label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Status</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Status Answered</span>

                <input type="radio" id="checy_71" name="1" value="YES" class="ss_form_input">
                <label for="checy_71" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_72" name="1" value="NO" class="ss_form_input">
                <label for="checy_72" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Order of Reference</span>

                <input type="radio" id="checy_73" name="1" value="YES" class="ss_form_input">
                <label for="checy_73" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="checy_74" name="1" value="NO" class="ss_form_input">
                <label for="checy_74" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">Order of Reference</span>

                <input type="radio" id="check_76" name="1" value="YES" class="ss_form_input">
                <label for="check_76" class="input_with_check ">
                    <span class="box_text">Yes </span>

                </label>

                <input type="radio" id="check_77" name="1" value="NO" class="ss_form_input">
                <label for="check_77" class="input_with_check">
                    <span class="box_text">No</span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Stauts Date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Sign off date</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted Date</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted TYPE</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP submitted Resubmission</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>

        </ul>
    </div>
    <div data-array-index="0" class="ss_array" style="display: inline;">

        <h4 class="ss_form_title title_with_line">
            <span class="title_index title_span">Assignments 1</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>
        <div class="collapse_div" style="">

            <div class="ss_form">
                <h4 class="ss_form_title">Assignor 
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                    </li>



                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>

            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Assignee 
                                                                                 <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn"></i>
                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                    </li>


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>
            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Signed by 
                                                                                <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn"></i>
                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                    </li>


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>
            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Assignment
                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Date</label>
                        <input class="ss_form_input ss_not_edit ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Document prepared</span>

                        <input type="radio" id="checy_81" name="1" value="YES" class="ss_form_input">
                        <label for="checy_81" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="checy_82" name="1" value="NO" class="ss_form_input">
                        <label for="checy_82" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>

                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Assigned before the S&C </span>

                        <input type="radio" id="checy_83" name="1" value="YES" class="ss_form_input">
                        <label for="checy_81" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="checy_84" name="1" value="NO" class="ss_form_input">
                        <label for="checy_82" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Signed Place</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                </ul>
            </div>

        </div>
    </div>


    <div data-array-index="0" class="ss_array" style="display: inline;">

        <h4 class="ss_form_title title_with_line">
            <span class="title_index title_span">Loan Pool Trust</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>
        <div class="collapse_div" style="">

            <div class="ss_form">
                <h4 class="ss_form_title">Trust Info
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                    </li>



                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>

            </div>

            <div class="ss_form">
                <h4 class="ss_form_title">Trust 
                                                            
                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Depositor Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Name" data-item-type="1" disabled="">
                    </li>


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Trustee Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Cutoff Date</label>
                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Closing date</label>
                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Trust documentation been located</span>

                        <input type="radio" id="check_90" name="1" value="YES" class="ss_form_input">
                        <label for="check_90" class="input_with_check ">
                            <span class="box_text">Yes </span>

                        </label>

                        <input type="radio" id="check_91" name="1" value="NO" class="ss_form_input">
                        <label for="check_91" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Assignment date</label>
                        <input class="ss_form_input ss_date" data-item="NegotiatorContact.Email" data-item-type="1" disabled="">
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Default date after close</span>

                        <input type="radio" id="check_93" name="1" value="YES" class="ss_form_input">
                        <label for="check_93" class="input_with_check ">
                            <span class="box_text">Yes </span>
                        </label>

                        <input type="radio" id="check_94" name="1" value="NO" class="ss_form_input">
                        <label for="check_94" class="input_with_check">
                            <span class="box_text">No</span>
                        </label>
                    </li>
                </ul>
            </div>



        </div>
    </div>

    <div class="ss_form">
        <h4 class="ss_form_title">Bankruptcy</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior</label>
                <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">chapter</label>
                <input class="ss_form_input" data-field="PropertyInfo.Number">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Disposition</label>
                <input class="ss_form_input">
            </li>

        </ul>
    </div>

    <div data-array-index="0" class="ss_array" style="display: inline;">

        <h4 class="ss_form_title title_with_line">
            <span class="title_index title_span">Statute of Limitation</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>
        <div class="collapse_div" style="">

            <div class="ss_form">
                <h4 class="ss_form_title">Prior Plaintiff
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                    </li>



                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>

            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Prior Plaintiff
                                                            <i class="fa fa-plus-circle  color_blue_edit collapse_btn ss_control_btn" onclick="ShowSelectParty()" style="display: inline !important;"></i>

                </h4>
                <ul class="ss_form_box clearfix">
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Name</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Name" data-item-type="1" disabled="">
                    </li>



                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Phone #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Cell" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Fax #</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.OfficeNO" data-item-type="1" disabled="">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">email</label>
                        <input class="ss_form_input ss_not_edit" data-item="ProcessorContact.Email" data-item-type="1" disabled="">
                    </li>
                </ul>

            </div>
            <div class="ss_form">
                <h4 class="ss_form_title">Statute of Limitations</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">LP Date</label>
                        <input class="ss_form_input ss_date" data-field="PropertyInfo.Number">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Default Date</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">In foreclosure </span>

                        <input type="checkbox" id="pdf_check_yes39" name="1" class="ss_form_input" value="YES">
                        <label for="pdf_check_yes39" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>

                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Disposition</label>
                        <select class="ss_form_input" data-field="PropertyInfo.Number">
                            <option>Dismissed</option>
                            <option>Discontinued</option>
                            <option>abandoned</option>
                            <option>other</option>

                        </select>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Prior Plaintiff</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Prior attorney</label>
                        <input class="ss_form_input" data-field="PropertyInfo.Number">
                    </li>
                </ul>
            </div>

        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">Estate</h4>
            <ul class="ss_form_box clearfix">


                <li class="ss_form_item">
                    <label class="ss_form_input_title">hold Reason</label>
                    <select class="ss_form_input" data-field="PropertyInfo.Number">
                        <option>Tenants in common</option>
                        <option>Joint Tenants w/right of survivorship</option>
                        <option>Tenancy by the entirety</option>

                    </select>
                </li>

                <li class="ss_form_item">
                    <span class="ss_form_input_title">Estate set up</span>

                    <select class="ss_form_input">
                        <option>Unknown</option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                    <%--<input type="checkbox" id="pdf_check_yes103" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check_yes40" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>--%>
                </li>
                <li class="ss_form_item">

                    <span class="ss_form_input_title">borrower Died</span>

                    <select class="ss_form_input">
                        <option>Unknown</option>
                        <option>Yes</option>
                        <option>No</option>
                    </select>
                    <%-- <input type="radio" id="pdf_check100" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>
                                                                                    <input type="radio" id="pdf_check101" name="1" class="ss_form_input" value="YES">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Tenancy by the entirety </span>
                                                                                    </label>--%>

                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">prior action</label>


                    <input class="ss_form_input" data-field="PropertyInfo.Number">
                </li>

            </ul>
        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">Defenses/Conclusion</h4>
            <ul class="ss_form_box clearfix">

                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">Defenses/Conclusion</label>
                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                </li>

            </ul>
        </div>

        <div class="ss_form">
            <h4 class="ss_form_title">Action Plan</h4>
            <ul class="ss_form_box clearfix">


                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">Action Plan</label>
                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                </li>

            </ul>
        </div>
        <div class="ss_form">
            <h4 class="ss_form_title">Etrack</h4>
            <ul class="ss_form_box clearfix">


                <li class="ss_form_item" style="width: 100%">
                    <label class="ss_form_input_title">Etrack</label>
                    <input class="ss_form_input" data-field="PropertyInfo.Number" style="width: 93%">
                </li>



            </ul>
        </div>
    </div>
</div>
