<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="HomeOwnerInfo.ascx.vb" Inherits="IntranetPortal.HomeOwnerInfo" %>
<%@ Import Namespace="IntranetPortal" %>

<style type="text/css">
    h4 {
        font: 16px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
        padding: 3px;
        margin-bottom: 0;
        margin-top: 5px;
    }

    h5 {
        font: 14px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif;
        color: #0072C6;
        vertical-align: top;
        padding: 3px;
        margin-bottom: 0;
        margin-top: 10px;
    }

    .fa-phone.homeowner_info_icon {
        cursor: pointer;
        color: green;
    }
</style>
<script type="text/javascript">
    function ConfrimReport() {
        if (confirm("Did you just refersh homeowner info ? If still can not get homeowner info press Ok to continue submit report ! \nIf we don't contact you in 24 hours that's mean this leads can't get homeowner info, please try edit homeowner input unique ID to load homeowner info.") == true) {
            ReportNoHomeCallBackClinet.PerformCallback(leadsInfoBBLE);
        }
    };

    $(document).ready(function () {
        if (sortPhones) { sortPhones(); }
    });
</script>

<% If (IsNeedAddHomeOwner()) Then%>
<i class="fa  fa-plus-circle icon_btn color_blue tooltip-examples" title="Add home owner" onclick="popupEditHomeOwner.PerformCallback('<%= String.Format("{0}|{1}|{2}", "Show", BBLE, OwnerName)%>');popupEditHomeOwner.Show();" style="font-size: 32px"></i>
<% End If%>
<div style='vertical-align: top; margin: 0; font-size: 18px; <%= if(IsNeedAddHomeOwner(),"visibility:hidden","") %>'>
    <div style="font-size: 30px; color: #2e2f31">
        <i class="fa fa-edit tooltip-examples" title="Edit Homeowner" onclick="popupEditHomeOwner.PerformCallback('<%= String.Format("{0}|{1}|{2}","Show", BBLE, OwnerName)%>');popupEditHomeOwner.Show();" style="cursor: pointer">&nbsp;</i>
        <% Dim needreport = IsEmptyReport AndAlso Not Utility.IsCompany(OwnerName)%>
        <% If needreport Then%>
        <i class='fa fa-wrench icon_btn tooltip-examples' title='Report no info after refresh homeowner info' onclick="ConfrimReport()">&nbsp;</i>
        <% End If%>

        <span class="homeowner_name">
            <%= OwnerName %>
        </span>
    </div>
    <% If TLOLocateReport IsNot Nothing Then%>
    <table style="list-style: none; margin-left: 5px; padding-left: 0px;">
        <%If HomeOwnerInfo.LastUpdate.HasValue Then%>
        <tr>
            <td>
                <span class="form_input_title">Data Update on &nbsp;<%= HomeOwnerInfo.LastUpdate.Value.ToString("g") %></span>
            </td>
        </tr>
        <%End If%>
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
                        <% If TLOLocateReport.bankruptciesField IsNot Nothing AndAlso TLOLocateReport.bankruptciesField.Length > 0 Then
                                Dim info = TLOLocateReport.bankruptciesField(0)%>
                        <% If info IsNot Nothing Then%>
                        <%=info.attorneyAddressField.countyField & " " & info.attorneyAddressField.zipField & "<Br />" & info.attorneyNameField & "<Br />" & info.attorneyPhoneField & "<Br />" & info.claimDateField.ToString & "<Br />" & info.dischargeDateField.ToString & "<Br />" & info.lawFirmField & "<Br />" & info.nphIdField%>
                        <% End If
                            End If
                        %>

                        <% End If%>
                    </div>
                </div>
            </td>
        </tr>

        <% If Employee.IsManager(Page.User.Identity.Name) Then%>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                    <span class="form_input_title">SSN</span>
                    <div class="clearfix">
                        <%=If(TLOLocateReport.sSNField IsNot Nothing, TLOLocateReport.sSNField.sSNField, "") %>&nbsp;
                    </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                    <span class="form_input_title">Date of Birth</span>
                    <div class="clearfix">
                        <%=If(TLOLocateReport.dateOfBirthField IsNot Nothing AndAlso TLOLocateReport.dateOfBirthField.dateOfBirthField IsNot Nothing, BuilderDate(TLOLocateReport.dateOfBirthField.dateOfBirthField), "") %>&nbsp;
                    </div>
                </div>
            </td>
        </tr>

        <% End If %>

        <% If Not String.IsNullOrEmpty(HomeOwnerInfo.Description) Then%>
        <tr>
            <td>
                <div class="form_div_node form_div_no_float form_div_node_no_under_line" style="width: 100%">
                    <span class="form_input_title">Description</span>
                    <div class="clearfix">
                        <%= HomeOwnerInfo.Description %>&nbsp;
                    </div>
                </div>
            </td>
        </tr>
        <% End If%>
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

    <div class="form_head homeowner_section_margin">
        <span>Best Emails </span>&nbsp;<i class="fa fa-plus-circle homeowner_plus_color" style="cursor: pointer" onclick="<%= String.Format("AddBestEmail('{0}','{1}','{2}', this)", BBLE, OwnerName, ulBestPhones.ClientID)%>"></i>
    </div>
    <div>
        <% If Utility.IsAny(BestEmail) Or Utility.IsAny(TLOLocateReport.emailAddressesField) Then%>
        <div class="clearfix homeowner_info_label">
            <div>
                <% Dim emails2 = BestEmail.Select(Function(e) e.Email).ToList%>
                <% Dim emails = BestEmail.Select(Function(e) e.Email).ToList%>
                <%If (Utility.IsAny(emails) And Utility.IsAny(TLOLocateReport.emailAddressesField)) Then%>
                <% emails.AddRange(TLOLocateReport.emailAddressesField)%>
                <%End If%>


                <% For Each email In emails%>
                <% If Not String.IsNullOrEmpty(email) Then%>
                <div class="color_gray clearfix">
                    <i class="fa fa-envelope homeowner_info_icon"></i>
                    <div class="form_div_node homeowner_info_text homeowner_info_bottom">
                        <div class="color_blue">
                            <%--  --%>

                            <a href="#" style="text-decoration: none"
                                <% If (Utility.IsAny(emails2) AndAlso emails2.Contains(email)) Then%>
                                onclick="OnEmailLinkClick('<%= email %>','<%= BBLE%>','<%= OwnerName%>',this)"
                                <% End If%>><%= email %></a>
                        </div>
                    </div>
                </div>
                <%End If%>
                <% Next%>
            </div>
        </div>

        <%End If%>
    </div>


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
                    <div class="color_gray <%= If(index = 1, "textMargin", "")%> clearfix">
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.Phone)%>')"></i>
                            <div class="form_div_node homeowner_info_text ">
                                <div>
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this, "<%= FormatPhoneNumber(phone.Phone)%>")' <%= CssStyle(FormatPhoneNumber(phone.Phone))%>>
                                        <%=FormatPhoneNumber(phone.Phone)%>
                                        <span class="phone_comment"><%=GetPhoneComment(phone.Phone)%></span>
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

                    <!-- Business phones -->
                    <% If TLOLocateReport.businessPhonesField IsNot Nothing AndAlso TLOLocateReport.businessPhonesField.Length > 0 Then%>
                    <% For Each phone In TLOLocateReport.businessPhonesField%>
                    <% If phone IsNot Nothing Then%>
                    <div class="color_gray clearfix">
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.phoneField)%>')"></i>
                            <div class="form_div_node homeowner_info_text ">
                                <div>
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                        <%=FormatPhoneNumber(phone.phoneField)%>
                                        <span class="phone_comment"><%=GetPhoneComment(phone.phoneField)%></span>

                                    </a>

                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>%)
                                </div>
                            </div>
                        </div>
                    </div>

                    <% End If%>
                    <% Next%>
                    <% End If%>

                    <!-- personal phones -->
                    <% If TLOLocateReport.phonesField IsNot Nothing AndAlso TLOLocateReport.phonesField.Length > 0 Then%>
                    <% For Each phone In TLOLocateReport.phonesField%>
                    <% If phone IsNot Nothing Then%>
                    <div class="color_gray clearfix">
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.phoneField)%>')"></i>
                            <div class="form_div_node homeowner_info_text ">
                                <div>
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                        <%=FormatPhoneNumber(phone.phoneField)%>
                                        <span class="phone_comment"><%=GetPhoneComment(phone.phoneField)%></span>

                                    </a>

                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>%)
                                </div>
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
                                <a href="#" class="AddressLink" onclick="OnAddressLinkClick(this, '<%= FormatAddress(add.addressField)%>')" <%= CssStyle(FormatAddress(add.addressField))%>>
                                    <%= FormatAddress(add.addressField)%> </a>
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

    <% If True Then%>
    <% If TLOLocateReport.numberOfRelatives1stDegreeField > 0 Then%>
    <div>
        <div class="form_head homeowner_section_margin">
            <span>First Degree Relatives &nbsp;</span>
        </div>
        <% For Each relative In TLOLocateReport.relatives1stDegreeField%>
        <div class="color_gray clearfix textMargin homeowner_title_margin">
            <i class="fa fa-chain color_gray homeowner_info_icon"></i>
            <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                <span class="font_black color_balck font_black upcase_text " style="white-space: nowrap"><%=relative.nameField.firstNameField & If(relative.nameField.middleNameField IsNot Nothing, " " & relative.nameField.middleNameField, " ") & " " & relative.nameField.lastNameField%></span><br />
                <span style="font-size: 14px">Age <span class="color_balck"><%= If(relative.dateOfBirthField  is Nothing , " ", relative.dateOfBirthField.currentAgeField) %></span></span>
            </div>
        </div>

        <div class="homeowner_expanll_border" style="margin-left: 20px">
            <div>
                <div class="clearfix homeowner_info_label" style="margin-left: 17px;">
                    <div>
                        <% If relative.phonesField.Length > 0 Then%>
                        <% For Each phone In relative.phonesField%>
                        <% If phone.phoneField IsNot Nothing Then%>
                        <div class="color_gray clearfix">
                            <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.phoneField)%>')"></i>
                            <div class="form_div_node homeowner_info_text ">

                                <div class="color_blue">
                                    <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                        <%= FormatPhoneNumber(phone.phoneField) %>
                                        <span class="phone_comment"><%=GetPhoneComment(phone.phoneField) %></span>
                                    </a>

                                </div>
                                <div class="homeowner_info_sm_font homeowner_info_bottom homeowner_info_sm_font color_balck">
                                    (<%= phone.timeZoneField%>) <%= phone.phoneTypeField.ToString %> (<%= phone.scoreField%>)
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
            <div class="color_gray clearfix textMargin homeowner_title_margin">
                <i class="fa fa-chain color_gray homeowner_info_icon"></i>
                <div class="form_div_node form_div_node_no_under_line homeowner_title_text">
                    <span class="font_black color_balck font_black upcase_text " style="white-space: nowrap"><%=relative.nameField.firstNameField & If(relative.nameField.middleNameField isnot Nothing," " & relative.nameField.middleNameField, " ") &" "& relative.nameField.lastNameField %></span><br />
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
                            <%If phone.phoneField IsNot Nothing Then%>
                            <div class="color_gray clearfix">
                                <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.phoneField)%>')"></i>
                                <div class="form_div_node homeowner_info_text ">

                                    <div class="color_blue">
                                        <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                            <%= FormatPhoneNumber(phone.phoneField) %>
                                            <span class="phone_comment"><%=GetPhoneComment(phone.phoneField) %></span>
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
            <% Next%>
        </div>

        <% If TLOLocateReport.numberOfRelatives3rdDegreeField > 0 Then%>

        <div>
            <div class="form_head homeowner_section_margin">
                <span>Third Degree Relatives &nbsp;</span>
            </div>
            <% For Each relative In TLOLocateReport.relatives3rdDegreeField%>
            <div class="color_gray clearfix textMargin homeowner_title_margin">
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
                            <% If phone.phoneField IsNot Nothing Then%>
                            <div class="color_gray clearfix">
                                <i class="fa fa-phone homeowner_info_icon" onclick="CallPhone('<%=FormatPhoneNumber(phone.phoneField)%>')"></i>
                                <div class="form_div_node homeowner_info_text ">

                                    <div class="color_blue">
                                        <a href='#' class="PhoneLink" onclick='return OnTelphoneLinkClick(this,"<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>>
                                            <%= FormatPhoneNumber(phone.phoneField) %>
                                            <span class="phone_comment"><%=GetPhoneComment(phone.phoneField) %></span>
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
            <% Next%>
        </div>

        <% End If%>
    </div>

    <% End If%>
    <% End If%>
    <%End If%>
</div>


