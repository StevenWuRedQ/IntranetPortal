<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleMortgageTab.ascx.vb" Inherits="IntranetPortal.ShortSaleMortgageTab" %>
<%@ Import Namespace="IntranetPortal.ShortSale" %>
<script src="/scripts/stevenjs.js"></script>
<div class="clearfix">
    <div style="float: right">
        <dx:ASPxButton runat="server" Text="Edit" AutoPostBack="false" CssClass="rand-button short_sale_edit" HoverStyle-BackColor="#3993c1" BackColor="#99bdcf">
            <ClientSideEvents Click="swich_edit_model" />
        </dx:ASPxButton>
    </div>
</div>

<% For Each mortgageData As PropertyMortgage In mortgagesData%>

<div class="ss_form">
    <h4 class="ss_form_title">1st Mortgage<i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'mortgage1')"></i> &nbsp;<i class="fa fa-plus-circle icon_btn color_blue"></i></h4>
    <ul class="ss_form_box clearfix" id="mortgage1">

        <li class="ss_form_item">
            <label class="ss_form_input_title">LENDER</label>
            <input class="ss_form_input" id="Lender" value="<%=mortgageData.Lender %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan #</label>
            <input class="ss_form_input" id="Loan" value="<%=mortgageData.Loan %>">">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Loan Amount</label>
            <input class="ss_form_input currency_input" id="LoanAmount" onblur="$(this).formatCurrency();" value="<%=mortgageData.LoanAmount %>">">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Authorization Sent</label>
           <input class="ss_form_input" id="AuthorizationSent" value="<%= mortgageData.AuthorizationSent %>">" />
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Lien Postion</label>
            <select class="ss_form_input">
                <option value="volvo">1 st</option>
                <option value="saab">2 nd</option>
                <option value="mercedes">3 rd</option>
                <option value="audi">4 th</option>
            </select>
            <script>
                initSelect("select_BuildingType", '<%=mortgageData.LienPosition%>');
            </script>
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Short sale dept <i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'short_sale_dept')"></i></h4>
    <ul class="ss_form_box clearfix" id="short_sale_dept">

        <li class="ss_form_item">
            <label class="ss_form_input_title">phone #</label>
            <input class="ss_form_input" id="ShortSaleContact" value="<%=mortgageData.ShortSaleContact%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input" value="123">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">customer service</label>
            <input class="ss_form_input" value="346-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input" value="12">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Fax #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Email</label>
            <input class="ss_form_input" value="example@email.com">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Processor<i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'processor_list')"></i></h4>
    <ul class="ss_form_box clearfix" id="processor_list">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" id="Processor" value="<%= mortgageData.Processor%>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Date Assigned to Processor</label>
            <input class="ss_form_input " value="Jun 23 ,2014">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input " value="416">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Fax #</label>
            <input class="ss_form_input " value="347-123-416">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input" value="">
        </li>
    </ul>

</div>

<div class="ss_form">
    <h4 class="ss_form_title">Negotiator<i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'negotiator_list')"></i></h4>
    <ul class="ss_form_box clearfix" id="negotiator_list">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" id="" value="<%=mortgageData.Negotiator %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input " value="616">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Fax #</label>
            <input class="ss_form_input " value="347-123-416">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input " value="">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Supervisor<i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'supervisor_list')"></i></h4>
    <ul class="ss_form_box clearfix" id="supervisor_list">
        <li class="ss_form_item">
            <label class="ss_form_input_title">Name</label>
            <input class="ss_form_input" id="" value="<%=mortgageData.Supervisor %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">extension</label>
            <input class="ss_form_input " value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input " value="616">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Fax #</label>
            <input class="ss_form_input " value="347-123-416">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input " value="supervisor@email.com">
        </li>
    </ul>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Closer
        <i class="fa fa-minus-square-o color_blue collapse_btn" onclick="clickCollapse(this, 'closer_list')"></i>

    </h4>
    <ul class="ss_form_box clearfix" id="closer_list">
        <li class="ss_form_item">
            <label class="ss_form_input_title">closer</label>
            <input class="ss_form_input" id="Closer" value="<%=mortgageData.Closer %>">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">extension</label>
            <input class="ss_form_input " value="56">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>

        <li class="ss_form_item">
            <label class="ss_form_input_title">Phone #</label>
            <input class="ss_form_input" value="347-123-456">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Extension</label>
            <input class="ss_form_input " value="616">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">Fax #</label>
            <input class="ss_form_input " value="347-123-416">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">&nbsp;</label>
            <input class="ss_form_input ss_form_hidden" value="">
        </li>
        <li class="ss_form_item">
            <label class="ss_form_input_title">email</label>
            <input class="ss_form_input " value="closer@email.com">
        </li>
    </ul>
</div>
<%Next %>
