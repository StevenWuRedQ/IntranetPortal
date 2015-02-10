<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DoorknockChart.aspx.vb" Inherits="IntranetPortal.DoorknockChart" MasterPageFile="~/Content.Master" %>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    <style>
        body {
            height: 100%;
        }

        @media print {
            .logo {
                right: 0px;
                float: right;
            }

            img {
                margin-left: 10px;
                color: red;
            }

            P {
                font-size: 48px;
                color: red;
            }
        }
    </style>
    <div style="color: #231f20">
        <div class="bs-docs-grid">
            <div class="row">
                <div class="col-md-1" style="width: 40px">
                    <div style="background: #158ccd; height: 60px; width: 40px;">
                        &nbsp;
                    </div>
                </div>
                <div class="col-md-11">
                    <div style="margin-left: 40px;">
                        <div style="font-size: 48px; font-weight: 200">
                            <span class="upcase_text">Door Knock chart</span>
                        </div>
                        <div style="font-size: 14px;">
                            <i class="fa fa-map-marker" style="border: 2px solid; padding: 4px 6px; border-radius: 14px;"></i>&nbsp;&nbsp; Homes to visit: <span style="font-weight: 900"><%= BBLEs.Count %></span>
                        </div>
                    </div>
                    <table class="table table-striped" style="font-size: 10px; margin-top: 25px;">
                        <thead class="upcase_text">
                            <tr>
                                <th><i class="fa fa-check" /></th>
                                <th>Address</th>
                                <th>Home owner (age)</th>
                                <th>Best Phone #</th>
                                <th>Other Addresses</th>
                                <th>Mortgage(s)</th>
                                <th>ECB/DOB</th>
                                <th>Taxes</th>
                                <th>Commets</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% For i = 0 To BBLEs.Length - 1%>
                            <% Dim li = IntranetPortal.LeadsInfo.GetInstance(BBLEs(i))
                                If li IsNot Nothing Then
                            %>
                            <tr>
                                <td>
                                    <input type="checkbox" />
                                    <label>&nbsp;</label>
                                </td>

                                <td>
                                    <% 
                                        Dim strName = ""
                                        Dim restAdd = ""
                                        If Addresses.Length > i Then
                                            Dim adds = Addresses(i)
                                            strName = adds.Split(",")(0)
                                            restAdd = adds.Replace(strName & ",", "")
                                    %>
                                    <span class="font_black"><%= strName %></span><br />
                                    <%= restAdd %>
                                    <% End If%>
                                </td>
                                <td>
                                    <%= String.Format("{0}({1})", li.Owner, li.GetOwnerAge(li.Owner))%>
                                    <% If Not String.IsNullOrEmpty(li.CoOwner) Then%>
                                    <br />
                                    <%= String.Format("{0}({1})", li.CoOwner, li.GetOwnerAge(li.CoOwner))%>
                                    <% End If%>
                                </td>
                                <td>
                                    <%                                            
                                        If Not String.IsNullOrEmpty(li.OwnerPhoneNo) Then
                                    %>
                                    <% For Each phone In li.OwnerPhoneNo.Split(",")%>
                                    <% If phone IsNot Nothing Then%>
                                    <span class="font_black"><%= IntranetPortal.Utility.FormatPhoneNumber(phone) %></span><br />
                                    <% End If%>
                                    <% Next%>
                                    <%  End If%>                                 
                                </td>
                                <td>&nbsp;
                                        <%                                            
                                            If li.OwnerAddress IsNot Nothing Then
                                        %>
                                    <% For Each add In li.OwnerAddress%>
                                    <% If add IsNot Nothing Then%>
                                    <%                                          
                                        strName = add.Split(",")(0)
                                        restAdd = add.Replace(strName & ",", "")
                                    %>
                                    <span class="font_black"><%= strName %></span><br />
                                    <%= restAdd %><br />
                                    <% End If%>
                                    <% Next%>
                                    <%  End If%>  
                                </td>
                                <td>
                                    <%=String.Format("{0:C}", li.C1stMotgrAmt)%>
                                </td>
                                <td>
                                    <%=String.Format("{0:C}", li.ViolationAmount)%>
                                </td>
                                <td>
                                    <%= String.Format("{0:C}", li.TaxesAmt)%>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <% End If%>
                            <% Next%>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="col-md-10"></div>
                <div class="col-md-2">
                    <input type="button" class="rand-button rand-button-blue" value="Print" onclick="cpPrint.PerformCallback()" />
                </div>
            </div>
        </div>
    </div>
    <dx:ASPxCallback runat="server" ID="cpPrint" ClientInstanceName="cpPrint" OnCallback="cpPrint_Callback">
        <ClientSideEvents EndCallback="function(s,e){window.print();}" />
    </dx:ASPxCallback>
    <div style="position: fixed; height: 90px; width: 170px; bottom: 0; right: 0;" class="logo">
        <img src="/images/logo_black.jpg" class="logo" />
    </div>
</asp:Content>

<%--<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />
    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
    <link href="/styles/stevencss.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
   
    </form>
</body>
</html>--%>
