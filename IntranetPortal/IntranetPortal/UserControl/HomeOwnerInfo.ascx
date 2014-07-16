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
<div style="vertical-align: top; margin: 0">
    <h4>Owner Name: <%= OwnerName %></h4>
    <% If TLOLocateReport IsNot Nothing Then%>
    <table style="list-style: none; margin-left: 5px; padding-left: 0px;">
        <tr>
            <td style="width: 100px;">Age:</td>
            <td><% If TLOLocateReport.dateOfBirthField IsNot Nothing Then%>
                <% = TLOLocateReport.dateOfBirthField.currentAgeField%>
                <% Else%>
                <%= "Unknow" %>
                <%  End If%> 
            </td>
        </tr>
        <tr>
            <td>Death Indicator:</td>
            <td><%= IIf(TLOLocateReport.dateOfDeathField Is Nothing, "Alive", "Death")%></td>
        </tr>
        <tr>
            <td>Bankruptcy:</td>
            <td><%= TLOLocateReport.numberOfBankruptciesField > 0%>               
            </td>
        </tr>
    </table>

    <!-- Employer info -->
    <% If TLOLocateReport.employersField.Length > 0 Then%>
    <h5>Possible Employer Info</h5>
    <ul>
        <% For Each item In TLOLocateReport.employersField%>
        <%If Not String.IsNullOrEmpty(item.businessNameField) Then%>
        <li><%= item.businessNameField%></li>
        <%End If%>
        <% Next%>
    </ul>
    <%End If%>

    <!-- Email info -->
    <% If TLOLocateReport.emailAddressesField.Length > 0 Then%>
    <h5>Best Emails</h5>
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
        <% For Each email In TLOLocateReport.emailAddressesField%>
        <% If Not String.IsNullOrEmpty(email) Then%>
        <li><%= email %></li>
        <%End If%>
        <% Next%>
    </ul>
    <%End If%>

    <!--Best Phone info -->
    <% If TLOLocateReport.phonesField.Length > 0 Then%>
    <h5 style="clear: both;">Best Phone Numbers <a href="#" onclick="<%= String.Format("AddBestPhoneNum('{0}','{1}','{2}', this)", BBLE, OwnerName, ulBestPhones.ClientID)%>">
        <img src="/images/add-button-hi.png" width="16" height="16" /></a></h5>
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;" runat="server" id="ulBestPhones">
        <% For Each phone In BestNums%>
        <% If phone IsNot Nothing Then%>
        <li><a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.Phone)%>")' <%= CssStyle(FormatPhoneNumber(phone.Phone))%>><%=FormatPhoneNumber(phone.Phone)%></a></li>
        <% End If%>
        <% Next%>

        <% For Each phone In TLOLocateReport.phonesField%>
        <% If phone IsNot Nothing Then%>
        <li><a href='#' onclick='return OnTelphoneLinkClick(this, "<%=FormatPhoneNumber(phone.phoneField)%>")' <%= CssStyle(FormatPhoneNumber(phone.phoneField))%>><%= BuilderPhone(phone)%></a></li>
        <% End If%>
        <% Next%>
    </ul>
    <%End If%>

    <!--Best Mail Address info -->
    <% If TLOLocateReport.addressesField.Length > 0 Then%>
    <h5>Best Address</h5>
    <ul style="list-style: none; margin-left: 5px; padding-left: 0px; margin-top: 0px;">
        <% For Each add In TLOLocateReport.addressesField%>
        <% If add.addressField IsNot Nothing Then
                Dim address = BuilderAddress(add)
        %>
        <li><a href="#" onclick="OnAddressLinkClick(this, '<%= FormatAddress(add.addressField)%>')" <%= CssStyle(FormatAddress(add.addressField))%>><%= address%></a></li>
        <% End If%>
        <% Next%>
    </ul>
    <%End If%>

    <% If TLOLocateReport.numberOfRelatives1stDegreeField > 0 Then%>
    <h5>First Degree Relatives</h5>
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
    </ul>
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
