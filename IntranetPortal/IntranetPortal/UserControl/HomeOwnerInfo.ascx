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
        <i class="fa fa-edit" onclick="popupEditHomeOwner.PerformCallback('<%= String.Format("{0}|{1}", BBLE, OwnerName)%>');popupEditHomeOwner.Show();" style="cursor: pointer">&nbsp;</i>
        <span class="homeowner_name">
            <input type="text" style="border-color: transparent; background-color: transparent; width: 245px" value="<%= OwnerName %>" />
        </span>
    </div>

    <% If TLOLocateReport IsNot Nothing Then%>
    <table style="list-style: none; margin-left: 5px; padding-left: 0px;">
        <tr>
            <td class="border_under_line">
                <div class="form_div_node form_div_no_float" style="width: 100%">
                    <span class="form_input_title">age</span>
                    <input class="text_input" value="<% If TLOLocateReport.dateOfBirthField IsNot Nothing Then%>
                    <% = TLOLocateReport.dateOfBirthField.currentAgeField%>
                    <% Else%>
                    <%= "Unknow" %>
                    <%  End If%>">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float" style="width: 100%">
                    <span class="form_input_title">Death Indicator</span>
                    <input class="text_input" value="<%= IIf(TLOLocateReport.dateOfDeathField Is Nothing, "Alive", "Death")%>">
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                    <span class="form_input_title">bankruptcy</span>
                    <div class="clearfix">
                        <span><%= TLOLocateReport.numberOfBankruptciesField > 0%> </span>
                        <% If TLOLocateReport.numberOfBankruptciesField > 0 Then%>
                        <i class="fa fa-minus-square-o" style="float: right; color: #b1b2b7"></i>
                        <% End If%>
                    </div>
                </div>
            </td>

        </tr>
    </table>

    <!-- Employer info -->
    <% If TLOLocateReport.employersField IsNot Nothing AndAlso TLOLocateReport.employersField.Length > 0 Then%>
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

    <%End If%>

    <!-- Email info -->
    <% If TLOLocateReport.emailAddressesField IsNot Nothing AndAlso TLOLocateReport.emailAddressesField.Length > 0 Then%>
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

    <%End If%>

    <!--Best Phone info -->

    <div>
        <div class="form_head homeowner_section_margin">
            <span runat="server" id="ulBestPhones">Best Phone Numbers &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color" style="cursor: pointer" onclick="<%= String.Format("AddBestPhoneNum('{0}','{1}','{2}', this)", BBLE, OwnerName, ulBestPhones.ClientID)%>"></i>
        </div>
        <div>
            <div class="clearfix homeowner_info_label">
                <div>
                    <%Dim index = 0%>
                    <% For Each phone In BestNums%>
                    <% If phone IsNot Nothing Then%>
                    <%index = index + 1%>
                    <div class="color_gray <%= If(index = 1, "filed_margin_top", "")%> clearfix">
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon"></i>
                            <div class="form_div_node homeowner_info_text ">
                                <div>
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.Phone)%>")' <%= CssStyle(FormatPhoneNumber(phone.Phone))%>>
                                        <%=FormatPhoneNumber(phone.Phone)%>
                                    </a>
                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    &nbsp;
                                </div>
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>

                    <% If TLOLocateReport.phonesField IsNot Nothing AndAlso TLOLocateReport.phonesField.Length > 0 Then%>
                    <% For Each phone In TLOLocateReport.phonesField%>
                    <% If phone IsNot Nothing Then%>
                    <div class="color_gray clearfix">
                        <i class="fa fa-phone homeowner_info_icon"></i>
                        <div class="form_div_node homeowner_info_text ">
                            <div>
                                <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                    <%= FormatPhoneNumber(phone.phoneField)%>
                                </a>
                            </div>
                            <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>%)
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>
                    <% End If%>
                </div>
            </div>
        </div>
    </div>
    <div>
        <div class="form_head homeowner_section_margin">
            <span>Best Addresses &nbsp;</span> <i class="fa fa-plus-circle homeowner_plus_color" style="cursor: pointer" onclick="<%= String.Format("AddBestAddress('{0}','{1}', this)", BBLE, OwnerName)%>"></i>
        </div>
        <div>
            <div class="clearfix homeowner_info_label">
                <div>
                    <!--Best Mail Address info -->
                    <%index = 0%>
                    <% For Each add In BestAddress%>
                    <% If add IsNot Nothing Then%>
                    <%index = index + 1%>
                    <div class="color_gray clearfix">
                        <i class="fa fa-map-marker homeowner_info_icon"></i>
                        <div class="form_div_node homeowner_info_text">
                            <div class="color_blue">
                                <a href="#" class="AddressLink" onclick="OnAddressLinkClick(this, '<%= add.Address%>')" <%= CssStyle(add.Address)%>><%= add.Address%> </a>
                            </div>
                            <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                <%= add.Description%>
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>

                    <% If TLOLocateReport.addressesField IsNot Nothing AndAlso TLOLocateReport.addressesField.Length > 0 Then%>
                    <% For Each add In TLOLocateReport.addressesField%>
                    <% If add.addressField IsNot Nothing Then
                            Dim address = BuilderAddress(add)
                    %>
                    <div class="color_gray clearfix">
                        <i class="fa fa-map-marker homeowner_info_icon"></i>
                        <div class="form_div_node homeowner_info_text">
                            <div class="color_blue">
                                <a href="#" class="AddressLink" onclick="OnAddressLinkClick(this, '<%= FormatAddress(add.addressField)%>')" <%= CssStyle(FormatAddress(add.addressField))%>><%= FormatAddress(add.addressField)%> </a>
                            </div>
                            <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                <%=BuilderDate(add.dateFirstSeenField) %> to  <%=BuilderDate(add.dateLastSeenField) %>
                            </div>
                        </div>
                    </div>
                    <% End If%>
                    <% Next%>
                    <%End If%>
                </div>
            </div>
        </div>
    </div>


    <% If TLOLocateReport.numberOfRelatives1stDegreeField > 0 Then%>
    <div>
        <div class="form_head homeowner_section_margin">
            <span>First Degree Relatives &nbsp;</span>
        </div>
        <% For Each relative In TLOLocateReport.relatives1stDegreeField%>
        <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
            <i class="fa fa-chain color_gray homeowner_info_icon"></i>
            <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                <span class="font_black color_balck font_black upcase_text " style="white-space: nowrap"><%=relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing,relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField %></span><br />
                <span style="font-size: 14px">Age <span class="color_balck"><%= If(relative.dateOfBirthField  is Nothing , " ", relative.dateOfBirthField.currentAgeField) %></span></span>
            </div>

        </div>


        <div class="homeowner_expanll_border" style="margin-left: 20px">
            <div>
                <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                    <div>
                        <% If relative.phonesField.Length > 0 Then%>
                        <% For Each phone In relative.phonesField%>
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon"></i>
                            <div class="form_div_node homeowner_info_text ">

                                <div class="color_blue">
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= FormatPhoneNumber(phone.phoneField) %></a>

                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>)
                                </div>
                            </div>
                        </div>
                        <% Next%>
                        <% End If%>
                    </div>

                </div>

            </div>
        </div>
        <% Next%>
        <div>
            <span class="time_buttons more_buttom"><a href="#" style="color: white" onclick="document.getElementById('<%= divRelatives.ClientID %>').style.display='block';">More Info</a>
            </span>
        </div>
    </div>

    <div id="divRelatives" runat="server" style="display: none;">
        <div>
            <div class="form_head homeowner_section_margin">
                <span>Second Degree Relatives &nbsp;</span>
            </div>
            <% For Each relative In TLOLocateReport.relatives2ndDegreeField%>
            <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
                <i class="fa fa-chain color_gray homeowner_info_icon"></i>
                <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                    <span class="font_black color_balck font_black upcase_text " style="white-space: nowrap"><%=relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing,relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField %></span><br />
                    <br />
                    <span style="font-size: 14px">Age <span class="color_balck"><%= If(relative.dateOfBirthField Is Nothing, ";", relative.dateOfBirthField.currentAgeField)%></span></span>
                </div>
                &nbsp;
            </div>


            <div class="homeowner_expanll_border" style="margin-left: 20px">
                <div>
                    <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                        <div>
                            <% If relative.phonesField.Length > 0 Then%>
                            <% For Each phone In relative.phonesField%>
                            <div class="color_gray clearfix">
                                <i class="fa fa-phone homeowner_info_icon"></i>
                                <div class="form_div_node homeowner_info_text ">

                                    <div class="color_blue">
                                        <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= FormatPhoneNumber(phone.phoneField) %></a>
                                    </div>
                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                        (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>%)
                                    </div>
                                </div>
                            </div>
                            <% Next%>
                            <% End If%>
                        </div>

                    </div>

                </div>
            </div>
            <% Next%>
        </div>


        <% If TLOLocateReport.numberOfRelatives3rdDegreeField > 0 Then%>

        <div>
            <div class="form_head homeowner_section_margin">
                <span>Third Degree Relatives &nbsp;</span>
            </div>
            <% For Each relative In TLOLocateReport.relatives3rdDegreeField%>
            <div class="color_gray clearfix filed_margin_top homeowner_title_margin">
                <i class="fa fa-chain color_gray homeowner_info_icon"></i>
                <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                    <span class="font_black color_balck font_black upcase_text " style="white-space: nowrap"><%=relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing,relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField %></span><br />
                    <span style="font-size: 14px">Age <span class="color_balck"><%= If(relative.dateOfBirthField  is Nothing , " ", relative.dateOfBirthField.currentAgeField) %></span></span>
                </div>

            </div>


            <div class="homeowner_expanll_border" style="margin-left: 20px">
                <div>
                    <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                        <div>
                            <% If relative.phonesField.Length > 0 Then%>
                            <% For Each phone In relative.phonesField%>
                            <div class="color_gray clearfix">
                                <i class="fa fa-phone homeowner_info_icon"></i>
                                <div class="form_div_node homeowner_info_text ">

                                    <div class="color_blue">
                                        <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= FormatPhoneNumber(phone.phoneField) %></a>
                                    </div>
                                    <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                        (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>%)
                                    </div>
                                </div>
                            </div>
                            <% Next%>
                            <% End If%>
                        </div>

                    </div>

                </div>
            </div>
            <% Next%>
        </div>

        <% End If%>
    </div>

    <% End If%>

    <%End If%>
</div>
