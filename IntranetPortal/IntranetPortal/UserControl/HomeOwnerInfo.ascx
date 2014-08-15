<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HomeOwnerInfo.ascx.vb" Inherits="IntranetPortal.HomeOwnerInfo" %>
<script type="text/javascript">
 
</script>
<style type="text/css">
    h4 {
        font: 16px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
        padding: 3px;
        margin-bottom: 0px;
        margin-top: 5px;
    }

    h5 {
        font: 14px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
        padding: 3px;
        margin-bottom: 0px;
        margin-top: 10px;
    }
</style>
<div style="vertical-align: top; margin: 0; font-size: 18px;">
    <div style="font-size: 30px; color: #2e2f31">
        <i class="fa fa-file">&nbsp;</i>
        <span class="homeowner_name">&nbsp;<%= OwnerName %></span>
    </div>

    <% If TLOLocateReport IsNot Nothing Then%>
    <table style="list-style: none; margin-left: 5px; padding-left: 0px;">
        <tr>
            <td>
                <div class="form_div_node form_div_no_float" style="width: 100%">
                    <span class="form_input_title">age</span>

                    <input class="text_input" value="<% If TLOLocateReport.dateOfBirthField IsNot Nothing Then%>
                    <% = TLOLocateReport.dateOfBirthField.currentAgeField%>
                    <% Else%>
                    <%= "Unknow" %>
                    <%  End If%>">
                </div>
            </td>

            <%--<td style="width: 100px;">Age:</td>
            <td>
                <% If TLOLocateReport.dateOfBirthField IsNot Nothing Then%>
                <% = TLOLocateReport.dateOfBirthField.currentAgeField%>
                <% Else%>
                <%= "Unknow" %>
                <%  End If%> 
            </td>--%>
        </tr>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float" style="width: 100%">
                    <span class="form_input_title">Death Indicator</span>

                    <input class="text_input" value="<%= IIf(TLOLocateReport.dateOfDeathField Is Nothing, "Alive", "Death")%>">
                </div>
            </td>

            <%--<td>Death Indicator:</td>
            <td><%= IIf(TLOLocateReport.dateOfDeathField Is Nothing, "Alive", "Death")%></td>--%>
        </tr>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                    <span class="form_input_title">bankruptcy</span>
                    <div class="clearfix">
                        <span><%= TLOLocateReport.numberOfBankruptciesField > 0%> </span>
                        <i class="fa fa-minus-square-o" style="float: right; color: #b1b2b7"></i>
                    </div>
                </div>
            </td>
            <%--<td>Bankruptcy:</td>
            <td><%= TLOLocateReport.numberOfBankruptciesField > 0%>               
            </td>--%>
        </tr>
    </table>

    <!-- Employer info -->
    <% If TLOLocateReport.employersField.Length > 0 Then%>
    <div class="form_head homeowner_section_margin">
        <span>Possible Employer Info </span>
    </div>
    <div>
        <div class="clearfix homeowner_info_label">
            <div>
                <% For Each item In TLOLocateReport.employersField%>
                <%If Not String.IsNullOrEmpty(item.businessNameField) Then%>
                <div class="color_gray clearfix">
                    <i class="fa fa-envelope homeowner_info_icon" style="display: none"></i>
                    <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                        <div class="color_blue">
                            <%= item.businessNameField%>
                        </div>
                    </div>
                </div>
                <%End If%>
                <% Next%>
            </div>
        </div>
    </div>
    <%-- <h5>Possible Employer Info</h5>
    <ul>
        <% For Each item In TLOLocateReport.employersField%>
        <%If Not String.IsNullOrEmpty(item.businessNameField) Then%>
        <li><%= item.businessNameField%></li>
        <%End If%>
        <% Next%>
    </ul>--%>
    <%End If%>

    <!-- Email info -->
    <% If TLOLocateReport.emailAddressesField.Length > 0 Then%>
    <div class="form_head homeowner_section_margin">
        <span>Best Emails </span>
    </div>
    <div>
        <div class="clearfix homeowner_info_label">
            <div>
                <% For Each email In TLOLocateReport.emailAddressesField%>
                <% If Not String.IsNullOrEmpty(email) Then%>
                <div class="color_gray clearfix">
                    <i class="fa fa-envelope homeowner_info_icon"></i>
                    <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                        <div class="color_blue">
                            <%= email %>
                        </div>
                    </div>
                </div>
                <%End If%>
                <% Next%>
            </div>
        </div>
    </div>
    <%--<h5>Best Emails</h5>
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
        <% For Each email In TLOLocateReport.emailAddressesField%>
        <% If Not String.IsNullOrEmpty(email) Then%>
        <li><%= email %></li>
        <%End If%>
        <% Next%>
    </ul>--%>
    <%End If%>

    <!--Best Phone info -->
    <% If TLOLocateReport.phonesField.Length > 0 Then%>
    <div>
        <div class="form_head homeowner_section_margin">
            <span runat="server" id="ulBestPhones">Best Phone Numbers &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color" style="cursor: pointer" onclick="<%= String.Format("AddBestPhoneNum('{0}','{1}','{2}', this)", BBLE, OwnerName, ulBestPhones.ClientID)%>"></i>
        </div>
        <div>
            <div class="clearfix homeowner_info_label">
                <div>
                    <% For Each phone In BestNums%>
                    <% If phone IsNot Nothing Then%>

                    <div class="color_gray filed_margin_top clearfix">
                        <i class="fa fa-phone homeowner_info_icon"></i>

                        <div class="form_div_node homeowner_info_text">
                            <div class="color_blue">
                                <a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.Phone)%>")' <%= CssStyle(FormatPhoneNumber(phone.Phone))%>><%=FormatPhoneNumber(phone.Phone).ToString.Split("(ET)")(0)%></a>
                            </div>
                            <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                (ET) <%=FormatPhoneNumber(phone.Phone).ToString.Split("(ET)")(1)%>
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>
                    <% For Each phone In TLOLocateReport.phonesField%>
                    <% If phone IsNot Nothing Then%>
                    <div class="form_div_node homeowner_info_text">
                        <div class="color_blue">
                            <a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                <%= BuilderPhone(phone).ToString.Split("(ET)")(0)%>

                            </a>
                        </div>
                        <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                            (ET)  <%= BuilderPhone(phone).ToString.Split("(ET)")(1)%>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>
                </div>

            </div>

        </div>

    </div>

    <%--<h5 style="clear: both;">Best Phone Numbers <a href="#" onclick="<%= String.Format("AddBestPhoneNum('{0}','{1}','{2}', this)", BBLE, OwnerName, ulBestPhones.ClientID)%>">
        <img src="/images/add-button-hi.png" width="16" height="16" /></a></h5>--%>
    <%-- <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;" runat="server" id="ulBestPhones">
        <% For Each phone In BestNums%>
        <% If phone IsNot Nothing Then%>
        <li>
        <a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.Phone)%>")' <%= CssStyle(FormatPhoneNumber(phone.Phone))%>><%=FormatPhoneNumber(phone.Phone)%></a>
        </li>
        <% End If%>
        <% Next%>

        <% For Each phone In TLOLocateReport.phonesField%>
        <% If phone IsNot Nothing Then%>
        <li>
        <a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
        <%= BuilderPhone(phone)%></a>
        </li>
        <% End If%>
        <% Next%>
    </ul>--%>
    <%End If%>

    <!--Best Mail Address info -->
    <% If TLOLocateReport.addressesField.Length > 0 Then%>
    <%-----best address section info--%>
    <div>
        <div class="form_head homeowner_section_margin">
            <span>Best Addresses &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color" style="display: none"></i>
        </div>
        <div>
            <div class="clearfix homeowner_info_label">
                <div>
                    <% For Each add In TLOLocateReport.addressesField%>
                    <% If add.addressField IsNot Nothing Then
                            Dim address = BuilderAddress(add)
                    %>
                    <div class="color_gray clearfix">
                        <i class="fa fa-map-marker homeowner_info_icon"></i>
                        <div class="form_div_node homeowner_info_text">
                            <div class="color_blue">
                                <%= FormatAddress(add.addressField)%>
                            </div>
                            <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                <%=BuilderDate(add.dateFirstSeenField) %> to  <%=BuilderDate(add.dateLastSeenField) %>
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>
                </div>

            </div>

        </div>

    </div>
    <%----end-----%>
    <%-- <h5>Best Address</h5>
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
        <% For Each add In TLOLocateReport.addressesField%>
        <% If add.addressField IsNot Nothing Then
                Dim address = BuilderAddress(add)
        %>
        <li><a href="#" onclick="OnAddressLinkClick(this, '<%= FormatAddress(add.addressField)%>')" <%= CssStyle(FormatAddress(add.addressField))%>><%= address%></a></li>
        <% End If%>
        <% Next%>
    </ul>--%>
    <%End If%>

    <% If TLOLocateReport.numberOfRelatives1stDegreeField > 0 Then%>
    <div>
        <div class="form_head homeowner_section_margin">
            <span>First Degree Relatives &nbsp;</span>
        </div>
        <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
            <i class="fa fa-chain color_gray homeowner_info_icon"></i>
            <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                <span class="font_black color_balck font_black upcase_text">Kang, Boon Chang</span><br />
                <span style="font-size: 14px">Age <span class="color_balck">74</span></span>
            </div>

        </div>
        <div class="homeowner_expanll_border" style="margin-left: 20px">
            <div>
                <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                    <div>
                        <% For Each relative In TLOLocateReport.relatives1stDegreeField%>
                        <%= BuilderRelativeName(relative) %>
                        <% If relative.phonesField.Length > 0 Then%>
                        <% For Each phone In relative.phonesField%>
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon"></i>
                            <div class="form_div_node homeowner_info_text ">

                                <div class="color_blue">
                                    <%= BuilderPhone(phone) %>
                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    (ET) ActiveLandLine (100%)
                                </div>
                            </div>
                        </div>
                        <% Next%>
                        <% End If%>
                        <% Next%>
                      

                        <div>
                            <span class="time_buttons more_buttom"><a href="#" style="color:white" onclick="document.getElementById('<%= divRelatives.ClientID%>').style.display='block';">Load More Info</a>
                            </span>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    </div>
    <%-- <h5>First Degree Relatives</h5>
    (<a href="#" onclick="document.getElementById('<%= divRelatives.ClientID%>').style.display='block';">More Info</a>)  
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
        <% For Each relative In TLOLocateReport.relatives1stDegreeField%>
        <li><%= BuilderRelativeName(relative) %>
            <% If relative.phonesField.Length > 0 Then%>
            <ul>
                <% For Each phone In relative.phonesField%>
                <li><a href='#' onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= BuilderPhone(phone) %></a></li>
                <%Next%>
            </ul>
            <% End If%>
        </li>
        <% Next%>
    </ul>--%>

    <div id="divRelatives" runat="server" style="display: none;">
        <% If TLOLocateReport.numberOfRelatives3rdDegreeField = 0 AndAlso TLOLocateReport.numberOfRelatives2ndDegreeField = 0 Then%>
            No more info to display.
        <%  End If%>

        <% If TLOLocateReport.numberOfRelatives2ndDegreeField > 0 Then%>
        <h5>Second Degree Relatives</h5>
        <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
            <% For Each relative In TLOLocateReport.relatives2ndDegreeField%>
            <li><%=BuilderRelativeName(relative)%>
                <% If relative.phonesField.Length > 0 Then%>
                <ul>
                    <% For Each phone In relative.phonesField%>
                    <li><a href='#' onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= BuilderPhone(phone) %></a></li>
                    <%Next%>
                </ul>
                <% End If%>
            </li>
            <% Next%>
        </ul>
        <% End If%>

        <% If TLOLocateReport.numberOfRelatives3rdDegreeField > 0 Then%>
        <h5>Third Degree Relatives</h5>
        <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
            <% For Each relative In TLOLocateReport.relatives3rdDegreeField%>
            <li><%= BuilderRelativeName(relative)%>
                <% If relative.phonesField.Length > 0 Then%>
                <ul>
                    <% For Each phone In relative.phonesField%>
                    <li><a href='#' onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= BuilderPhone(phone) %></a></li>
                    <%Next%>
                </ul>
                <% End If%>
            </li>
            <% Next%>
        </ul>
        <% End If%>
    </div>

    <% End If%>

    <%End If%>
</div>
