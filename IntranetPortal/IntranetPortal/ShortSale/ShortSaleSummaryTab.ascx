<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSummaryTab.ascx.vb" Inherits="IntranetPortal.ShortSaleSummaryTab" %>
<%@ Import Namespace="IntranetPortal" %>
<script>
   
</script>


<div>
    <h4 class="ss_form_title">Property</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item" style="width: 100%">
            <label class="ss_form_input_title">address</label>

            <input class="ss_form_input" style="width: 93.5%;" name="lender"
                value="<%= summaryCase.PropertyInfo.PropertyAddress%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Block</label>
            <input class="ss_form_input" data-field="PropertyInfo.Block">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">lot</label>
            <input class="ss_form_input" data-field="PropertyInfo.Lot">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Accessibility</label>
            <select class="ss_form_input" data-field="PropertyInfo.Accessibility">
                <option value="volvo">Lockbox - LOC</option>
                <option value="saab">Master Key</option>
                <option value="mercedes">Homeowner's key</option>
            </select>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">c/o(<span class="link_pdf">pdf</span>)</span>

            <input type="radio" id="pdf_check_yes" name="1" <%= ShortSalePage.CheckBox(summaryCase.PropertyInfo.CO)%> value="YES">
            <label for="pdf_check_yes" class="input_with_check">
                <span class="box_text">Yes </span>

            </label>

            <input type="radio" id="pdf_check_no" name="1" <%= ShortSalePage.CheckBox( Not summaryCase.PropertyInfo.CO)%> value="NO">
            <label for="pdf_check_no" class="input_with_check">
                <span class="box_text">No </span>
            </label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax class</label>
            <input class="ss_form_input" value="<%= summaryCase.PropertyInfo.TaxClass%>">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title"># of families</label>
            <input class="ss_form_input" value="<%= summaryCase.PropertyInfo.NumOfFamilies%>">
        </li>

    </ul>
</div>

<div data-array-index="0" data-field="PropertyInfo.Owners" class="ss_array" style="display: none">
    <div class="ss_form">
        <h4 class="ss_form_title">Seller __index__</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">name</label>
                <input class="ss_form_input" data-item="FirstName" value="John Smith">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">SSn</label>
                <input class="ss_form_input" data-item="SSN" value="XXX-XX-7713">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax class</label>
                <input class="ss_form_input"  value="No Tax class">
            </li>
            <li class="ss_form_item" style="width: 100%">
                <label class="ss_form_input_title">Mailing address</label>
                <input class="ss_form_input" data-item="MailCity" style="width: 93.5%;" name="lender" value="147-06 Eldert Rd, Flushing, NY 11367">
            </li>

        </ul>
    </div>
</div>

<div data-array-index="0" data-field="Mortgages" class="ss_array" style="display: none">

    <div class="ss_form">
        <h4 class="ss_form_title"><span class="title_index ">Mortgage __index__ </span></h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Lender</label>
                <input class="ss_form_input" data-item="Lender" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Loan #</label>
                <input class="ss_form_input" data-item="Loan" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Loan Amount</label>
                <input class="ss_form_input input_currency" onblur="$(this).formatCurrency();" data-item="LoanAmount" data-item-type="1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Short Sale Dept</label>
                <input class="ss_form_input" value="866-880-1232">
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">&nbsp;</span>

                <input type="checkbox" id="pdf_check_yes1" name="1" value="YES">
                <label for="pdf_check_yes1" class="input_with_check">
                    <span class="box_text">Fannie</span>
                </label>

                <input type="checkbox" id="pdf_check_no2" name="1" value="NO">
                <label for="pdf_check_no2" class="input_with_check">
                    <span class="box_text">FHA</span>
                </label>

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">&nbsp;</span>

                <input type="checkbox" id="pdf_check_yes2" name="1" value="YES">
                <label for="pdf_check_yes2" class="input_with_check">
                    <span class="box_text">Freddie Mac </span>
                </label>

            </li>
        </ul>
    </div>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Assigned Processor</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" value="Angela Meade">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="718-205-0200 Ext. 235">
        </li>


    </ul>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Referral</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" value="Mo Isaacs">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell phone #</label>
            <input class="ss_form_input" value="718-600-2961">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title ">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Manager</label>
            <input class="ss_form_input" value="Some One">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Cell phone #</label>
            <input class="ss_form_input" value="718-600-2961">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value=" ">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Office</label>
            <input class="ss_form_input" value="Office Information">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Offie phone #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>

    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Seller attorney</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" value="Yariv Katz">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="347-723-4458">
        </li>

    </ul>
</div>
