<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleSummaryTab.ascx.vb" Inherits="IntranetPortal.ShortSaleSummaryTab" %>


<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
        </dx:ASPxButton>
    </div>
</div>
<div>
    <h4 class="ss_form_title">Propety</h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item" style="width: 100%">
            <label class="ss_form_input_title">address</label>
            <input class="ss_form_input" style="width: 93.5%;" name="lender" value="151-04 Main St, Flushing,NY 11367">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Block</label>
            <input class="ss_form_input" value="3341">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">lot</label>
            <input class="ss_form_input" value="1795548554">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Accessibility</label>
            <select class="ss_form_input">
                <option value="volvo">Lockbox - LOC</option>
                <option value="saab">Master Key</option>
                <option value="mercedes">Homeowner's key</option>
                
            </select>
        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">c/o(<span class="link_pdf">pdf</span>)</span>

            <input type="radio" id="pdf_check_yes" name="1" value="YES">
            <label for="pdf_check_yes" class="input_with_check">Yes</label>

            <input type="radio" id="pdf_check_no" name="1" value="NO">
            <label for="pdf_check_no" class="input_with_check">No</label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax class</label>
            <input class="ss_form_input" value="1">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title"># of families</label>
            <input class="ss_form_input" value="Choose number">
        </li>



    </ul>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Seller 1</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">name</label>
            <input class="ss_form_input" value="John Smith">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">SSn</label>
            <input class="ss_form_input" value="XXX-XX-7713">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Tax class</label>
            <input class="ss_form_input" value="1">
        </li>
        <li class="ss_form_item" style="width: 100%">
            <label class="ss_form_input_title">Mailing address</label>
            <input class="ss_form_input" style="width: 93.5%;" name="lender" value="147-06 Eldert Rd, Flushing, NY 11367">
        </li>




    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">1st Mortgage</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Lender</label>
            <input class="ss_form_input" value="Bank of America">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan #</label>
            <input class="ss_form_input" value="1795548554">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan Amount</label>
            <input class="ss_form_input input_currency" onblur="$(this).formatCurrency();" value="$482,000.00">
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
            <label for="pdf_check_no2" class="input_with_check">FHA</label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">&nbsp;</span>

            <input type="checkbox" id="pdf_check_yes2" name="1" value="YES">
            <label for="pdf_check_yes2" class="input_with_check">Freddie Mac</label>

        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">1st Mortgage</h4>
    <ul class="ss_form_box clearfix">

        <li class="ss_form_item">
            <label class="ss_form_input_title">Lender</label>
            <input class="ss_form_input" value="Bank of America">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan #</label>
            <input class="ss_form_input" value="1795548554">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan Amount</label>
            <input class="ss_form_input input_currency" onblur="$(this).formatCurrency();" value="$482,000.00">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Short Sale Dept</label>
            <input class="ss_form_input" value="866-880-1232">
        </li>

        <li class="ss_form_item">
            <span class="ss_form_input_title">&nbsp;</span>

            <input type="checkbox" id="pdf_check_yes3" name="1" value="YES">
            <label for="pdf_check_yes3" class="input_with_check">Fannie</label>

            <input type="checkbox" id="pdf_check_no3" name="1" value="NO">
            <label for="pdf_check_no3" class="input_with_check">FHA</label>

        </li>
        <li class="ss_form_item">
            <span class="ss_form_input_title">&nbsp;</span>

            <input type="checkbox" id="pdf_check_yes4" name="1" value="YES">
            <label for="pdf_check_yes4" class="input_with_check">Freddie Mac</label>

        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Status</label>
            <select class="ss_form_input">
                <option value="volvo">Counter offer</option>
                <option value="saab">Approved</option>
                <option value="mercedes">Negotiator Assigned</option>
            </select>
        </li>
    </ul>
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
