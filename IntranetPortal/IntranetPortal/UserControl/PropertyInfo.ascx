﻿<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PropertyInfo.ascx.vb" Inherits="IntranetPortal.PropertyInfo" %>
<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>

<script src="/scripts/jquery.formatCurrency-1.1.0.js"></script>
<script type="text/javascript">
    function ShowAcrisMap(propBBLE) {
        //var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + propBBLE;
        ShowPopupMap("https://a836-acris.nyc.gov/DS/DocumentSearch/BBL", "Acris");
        $("#addition_info").html($("#borugh_block_lot_data").val());
    }

    function ShowDOBWindow(boro, block, lot) {
        if (block == null || block == "" || lot == null || lot == "" || boro == null || boro == "")
        {
            alert("The property info isn't complete. Please try to refresh data.");
            return;
        }

        var url = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + boro + "&block=" + encodeURIComponent(block) + "&lot=" + encodeURIComponent(lot);
        ShowPopupMap(url, "DOB");
        $("#addition_info").html(' ');
    }

    function ShowPopupMap(url, header) {
        if (header == "eCourts") {
            $("#addition_info").html($('#LinesDefendantAndIndex').val());
        }

        aspxAcrisControl.SetContentHtml("Loading...");
        aspxAcrisControl.SetContentUrl(url);
        aspxAcrisControl.SetHeaderText(header);
        $('#pop_up_header_text').html(header);
        aspxAcrisControl.Show();
    }

    function ViewLeads(propBBLE) {
        var url = '/ViewLeadsInfo.aspx?id=' + propBBLE;
        window.open(url, 'View Leads Info', 'Width=1350px,Height=930px');
    }

    function init_currency() {
        if(typeof $('.input_currency').formatCurrency != "undefined")
        {
            $('.input_currency').formatCurrency();
        }
    }

    function SaveLeadsComments(s, e) {
        var comments = txtLeadsComments.GetText();
        leadsCommentsCallbackPanel.PerformCallback("Add|" + comments);
        txtLeadsComments.SetText("");
        aspxAddLeadsComments.Hide();
    }

    function ShowDiv() {
        var display = document.getElementById("divOtherProperties").style.display;

        if (display == "block") {
            document.getElementById("divOtherProperties").style.display = "none";
        }
        else
            document.getElementById("divOtherProperties").style.display = "block";
    }

    function DeleteComments(commentId) {
        leadsCommentsCallbackPanel.PerformCallback("Delete|" + commentId);
    }
    $(document).ready(function () {
        // Handler for .ready() called.
        init_currency();
    });
    //init_currency();
</script>

<input type="hidden" id="borugh_block_lot_data" value='(Borough:<%=LeadsInfoData.Borough %> , Block:<%=LeadsInfoData.Block %> ,Lot:<%=LeadsInfoData.Lot %>)' />
<input type="hidden" id="LinesDefendantAndIndex" value='<%= LinesDefendantAndIndex()%>' />
<div class="tab-pane active" id="property_info" style="padding-top: 5px">
    <%--witch scroll bar--%>
    <%--/*display:none need delete when realse--%>
    <div style="height: 850px; overflow: auto;" id="prioity_content">
        <%--refresh label--%>

        <dx:ASPxPanel ID="UpatingPanel" runat="server">
            <PanelCollection>
                <dx:PanelContent runat="server">
                    <div style="margin: 30px 20px; margin-bottom: 0px; height: 30px; background: #ffefe4; color: #ff400d; border-radius: 15px; font-size: 14px; line-height: 30px;">
                        <i class="fa fa-spinner fa-spin" style="margin-left: 30px"></i>
                        <span style="padding-left: 22px">Lead is being updated, it will take a few minutes to complete.</span>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
        </dx:ASPxPanel>
        <%--time label--%>
        <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
            <div style="font-size: 30px">
                <span style='<%= If(LeadsInfoData.LastUpdate.HasValue, "visibility:visible", "visibility:hidden")%>'>
                    <i class="fa fa-refresh"></i>
                    <span style="margin-left: 19px;"><%= LeadsInfoData.LastUpdate.ToString%></span>
                </span>
                <span class="time_buttons" style="margin-right: 30px" onclick="ShowPopupMap('https://iapps.courts.state.ny.us/webcivil/ecourtsMain', 'eCourts')">eCourts</span>
                <span class="time_buttons" onclick='ShowDOBWindow("<%= LeadsInfoData.Borough%>","<%= LeadsInfoData.Block%>", "<%= LeadsInfoData.Lot%>")'>DOB</span>
                <span class="time_buttons" onclick='ShowAcrisMap("<%= LeadsInfoData.BBLE %>")'>Acris</span>
                <span class="time_buttons" onclick='ShowPropertyMap("<%= LeadsInfoData.BBLE %>")'>Maps</span>

            </div>
            <%--data format June 2, 2014 6:37 PM--%>
            <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px; <%= If( LeadsInfoData.CreateDate.HasValue,"visibility:visible","visibility:hidden")%>">Started on <%= LeadsInfoData.CreateDate.ToString%></span>
        </div>

        <%--note list--%>
        <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
            <dx:ASPxCallbackPanel runat="server" ID="leadsCommentsCallbackPanel" ClientInstanceName="leadsCommentsCallbackPanel" OnCallback="leadsCommentsCallbackPanel_Callback">
                <PanelCollection>
                    <dx:PanelContent>
                        <% Dim i = 0%>
                        <%-- <% If LeadsInfoData.IsHighLiens Then%>
                        <div class="note_item" style='<%= If((i mod 2)=0,"background: #e8e8e8","")%>'>
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">Liens higher than Value</span>
                        </div>
                        <% i += 1%>
                        <% End If%>

                        <% If Not String.IsNullOrEmpty(LeadsInfoData.IndicatorOfWater) Then%>
                        <div class="note_item" style='<%= If((i mod 2)=0,"background: #e8e8e8","")%>'>
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">Water Lien is High - Possible Tenant Issues</span>
                        </div>
                        <% i += 1%>
                        <% End If%>--%>

                        <% If LeadsInfoData.OtherProperties IsNot Nothing AndAlso LeadsInfoData.OtherProperties.Count > 0 Then%>
                        <div class="note_item" style='<%= If((i mod 2)=0,"background: #e8e8e8;height:inherit","height:inherit")%>'>
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text" style="cursor: pointer" onclick="ShowDiv()">Other properties of current owner: </span>
                            <div id="divOtherProperties" style="display: block">
                                <% For Each li In LeadsInfoData.OtherProperties%>
                                <i class="note_img"></i><a href="#" style="font-size: 14px" onclick="ViewLeads(<%= li.BBLE %>);"><%= li.LeadsName %></a><br />
                                <%Next%>
                            </div>
                        </div>
                        <% i += 1%>
                        <% End If%>

                        <% If LeadsInfoData.Type.HasValue Then%>
                        <div class="note_item" style='<%= If((i mod 2)=0,"background: #e8e8e8","")%>'>
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">Leads type: <b><%= CType(LeadsInfoData.Type, IntranetPortal.LeadsInfo.LeadsType).ToString %></b></span>
                        </div>
                        <% i += 1%>
                        <% End If%>

                        <asp:HiddenField ID="hfBBLE" runat="server" />

                        <% For Each comment In LeadsInfoData.UserComments%>
                        <div class="note_item" style='<%= If((i mod 2)=0,"background: #e8e8e8","")%>'>
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text"><%= comment.Comments%></span>
                            <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7; display: none"></i>
                            <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7; cursor: pointer" onclick="DeleteComments(<%= comment.CommentId %>)"></i>
                        </div>
                        <% i += 1%>
                        <% Next%>
                    </dx:PanelContent>
                </PanelCollection>
            </dx:ASPxCallbackPanel>

            <div class="note_item" style="background: white">
                <%--<button class="btn" data-container="body" type="button" data-toggle="popover" data-placement="right" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">--%>
                <i class="fa fa-plus-circle note_img tooltip-examples" title="Add Notes" style="color: #3993c1; cursor: pointer" onclick="aspxAddLeadsComments.ShowAtElement(this)"></i>

                <%--</button>--%>
            </div>
        </div>

        <dx:ASPxPopupControl ClientInstanceName="aspxAddLeadsComments" Width="550px" Height="50px" ID="ASPxPopupControl2"
            HeaderText="Add Comments" ShowHeader="false"
            runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <table>
                        <tr style="padding-top: 3px;">
                            <td style="width: 380px; vertical-align: central">
                                <dx:ASPxTextBox runat="server" ID="txtLeadsComments" ClientInstanceName="txtLeadsComments" Width="360px"></dx:ASPxTextBox>
                            </td>
                            <td style="text-align: right">
                                <div>
                                    <dx:ASPxButton runat="server" ID="btnAdd" Text="Add" AutoPostBack="false" CssClass="rand-button" BackColor="#3993c1">
                                        <ClientSideEvents Click="SaveLeadsComments" />
                                    </dx:ASPxButton>
                                    &nbsp;
                                    <dx:ASPxButton runat="server" ID="ASPxButton4" Text="Close" AutoPostBack="false" CssClass="rand-button" BackColor="#77787b">
                                        <ClientSideEvents Click="function(s,e){aspxAddLeadsComments.Hide();}" />
                                    </dx:ASPxButton>
                                </div>

                            </td>
                        </tr>
                    </table>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <%--------%>
        <%--property form--%>
        <div style="margin: 20px" class="clearfix">
            <div class="form_head">General</div>

            <%--line 1--%>
            <div class="form_div_node" style="width: 63%">
                <span class="form_input_title">address</span>
                <input class="text_input" value="<%= LeadsInfoData.PropertyAddress%>" />
            </div>

            <div class="form_div_node form_div_node_margin">
                <span class="form_input_title">bble</span>
                <input class="text_input font_black" value="<%= LeadsInfoData.BBLE%>" />
            </div>

            <%--end line 1--%>
            <%--line 2--%>
            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Neighborhood</span>
                <input class="text_input" value="<%=LeadsInfoData.Neighborhood%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Borough</span>

                <input class="text_input" value="<%=LeadsInfoData.Borough%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Block</span>

                <input class="text_input" value="<%=LeadsInfoData.Block%>" />
            </div>
            <%--end line 2--%>
            <%--line 3--%>

            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Lot</span>
                <input class="text_input" value="<%= LeadsInfoData.Lot%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">NYC SQFT</span>

                <input class="text_input" value="<%=LeadsInfoData.NYCSqft%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Year Built</span>

                <input class="text_input" value="<%=LeadsInfoData.YearBuilt%>" />
            </div>

            <%----end line 3----%>

            <%--line 4--%>

            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Building dem</span>
                <input class="text_input" value="<%=LeadsInfoData.BuildingDem%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Lot Dem</span>

                <input class="text_input" value="<%=LeadsInfoData.LotDem%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">stories</span>

                <input class="text_input" value="<%= LeadsInfoData.NumFloors %>" />
            </div>

            <%----end line 4----%>

            <%-----line 5-----%>

            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Property Class</span>
                <input class="text_input" value="<%=LeadsInfoData.PropertyClassCode%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Zoning (<span style="color: #0e9ee9; cursor: pointer">PDF</span>)</span>

                <input class="text_input" value="<%=LeadsInfoData.Zoning%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Unbuilt sqft</span>

                <input class="text_input" value="<%=LeadsInfoData.UnbuiltSqft%>" />
            </div>
            <%----end line 5--%>

            <%-----line 6-----%>
            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Max Far</span>
                <input class="text_input" value="<%=LeadsInfoData.MaxFar%>" />
            </div>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">actual far</span>

                <input class="text_input" value="<%= LeadsInfoData.ActualFar%>" />
            </div>
            <%--remove tax class--%>
            <%-- <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Property Class</span>

                <input class="text_input" value="<%=LeadsInfoData.TaxClass %>" />
            </div>--%>
            <%-----end line -----%>

            <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Sale Date</span>
                <input class="text_input" value="<%=LeadsInfoData.SaleDate%>" />
            </div>
            <%--<div class="form_div_node form_div_node_margin form_div_node_line_margin">
                <span class="form_input_title">Zestimate</span>
                <input class="text_input" value="$<%=LeadsInfoData.EstValue %>" />
            </div>--%>
            <%----end line --%>
        </div>

        <%-------end-----%>
        <dx:ASPxCallbackPanel runat="server" ID="callPanelReferrel" ClientInstanceName="callPanelClientReferrel" OnCallback="callPanelReferrel_Callback">
            <PanelCollection>
                <dx:PanelContent>
                    <div style="margin: 20px;" class="clearfix">
                        <div class="form_head" style="margin-top: 40px;">REFERRAL <i class="fa fa-save  color_blue_edit collapse_btn" title="Save Referral" onclick="callPanelClientReferrel.PerformCallback('Save')"></i></div>

                        <%--line 1--%>
                        <div class="form_div_node form_div_node_line_margin">
                            <span class="form_input_title">Name</span>
                            <input class="text_input" value="<%# LeadsInfoData.Referrel.ReferrelName %>" runat="server" id="txtReferrelName" />
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                            <span class="form_input_title">Phone No.</span>
                            <input class="text_input" value="<%# LeadsInfoData.Referrel.PhoneNo %>" runat="server" id="txtReferrelPhone" />
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                            <span class="form_input_title">Email</span>
                            <input class="text_input" value="<%# LeadsInfoData.Referrel.Email %>" runat="server" id="txtReferrelEmail" />
                        </div>
                        <%----end line ----%>
                    </div>
                </dx:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="function(s,e){alert('Saved.');}" />
        </dx:ASPxCallbackPanel>

        <%--zestimat form--%>
        <div style="margin: 20px;" class="clearfix">
            <div class="form_head" style="margin-top: 40px;">Value</div>
            <%--line 1--%>
            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Zestimate</span>
                <input class="text_input input_currency" onblur="$(this).formatCurrency();" type="text" value="$<%=LeadsInfoData.EstValue %>" />
            </div>
            <%----end line ----%>
        </div>
        <%--Estimated Mortgage--%>
        <% If (LeadsInfoData.LisPens IsNot Nothing AndAlso LeadsInfoData.LisPens.Count > 0) Then%>
         <div style="margin: 20px;" class="clearfix">
            <div class="form_head" style="margin-top: 40px;">Estimated Mortgage Default</div>
            <%--line 1--%>
            <div class="form_div_node form_div_node_line_margin">
                <span class="form_input_title">Default</span>
                <input class="text_input input_currency" onblur="$(this).formatCurrency();" type="text" value="$<%=LeadsInfoData.EstimatedMortageDefault %>" />
            </div>
            <%----end line ----%>
        </div>
          <%End If%>
       
        <dx:ASPxCallbackPanel runat="server" ID="cbpMortgageData" ClientInstanceName="callbackPanelMortgage" OnCallback="cbpMortgageData_Callback">
            <PanelCollection>
                <dx:PanelContent>
                    <%--Mortgage form--%>
                    <div style="margin: 20px;" class="clearfix">
                        <div class="form_head" style="margin-top: 40px;">MORTGAGE AND VIOLATIONS <i class="fa fa-save  color_blue_edit collapse_btn" title="Save Mortgage" onclick="callbackPanelMortgage.PerformCallback('Save')"></i></div>

                        <%--line 1--%>
                        <div class="form_div_node form_div_node_line_margin">
                            <span class="form_input_title">1st Mortgage</span>
                            <dx:ASPxTextBox runat="server" ID="txtC1stMotgr" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.C1stMotgrAmt  %>'></dx:ASPxTextBox>
                            <%--<input class="text_input input_currency" onblur="$(this).formatCurrency();" value="$<%= LeadsInfoData.C1stMotgrAmt%>" style="display: none" />--%>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                            <span class="form_input_title"></span>
                            <br />

                            <%--class="circle-radio-boxes"--%>
                            <input type="checkbox" id="cb1stFannie" value="Fannie" runat="server" checked='<%# LeadsInfoData.MortgageData.C1stFannie.HasValue andalso LeadsInfoData.MortgageData.C1stFannie %>' />
                            <label for="<%= cb1stFannie.ClientID %>" class=" form_div_radio_group">
                                <span class="form_span_group_text">Fannie</span>
                            </label>
                            <input type="checkbox" id="cb1stFHA" style="margin-left: 66px" runat="server" checked='<%# LeadsInfoData.MortgageData.C1stFHA.HasValue andalso LeadsInfoData.MortgageData.C1stFHA %>' />
                            <label for="<%= cb1stFHA.ClientID %>" class=" form_div_radio_group form_div_node_margin">
                                <span class="form_span_group_text">FHA</span>
                            </label>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                            <span class="form_input_title">Servicer</span>
                            <input class="text_input" value='<%# LeadsInfoData.MortgageData.C1stServicer %>' id="txt1stServicer" runat="server" />
                        </div>
                        <%--end line --%>
                        <%--line 2--%>

                        <div class="form_div_node form_div_node_line_margin">
                            <span class="form_input_title">2nd Mortgage</span>
                            <dx:ASPxTextBox runat="server" ID="txtC2ndMotgr" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.C2ndMotgrAmt  %>'></dx:ASPxTextBox>
                            <%--                            <input class="text_input input_currency" onblur="$(this).formatCurrency();" value="$<%=LeadsInfoData.C2ndMotgrAmt%>" />--%>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                            <span class="form_input_title"></span>
                            <br />

                            <%--class="circle-radio-boxes"--%>
                            <input type="checkbox" id="cb2ndFannie" name="cb2ndFannie" value="Fannie" runat="server" checked='<%# LeadsInfoData.MortgageData.C2ndFannie.HasValue andalso LeadsInfoData.MortgageData.C2ndFannie %>' />
                            <label for="<%= cb2ndFannie.ClientID %>" class=" form_div_radio_group">
                                <span class="form_span_group_text">Fannie</span>
                            </label>
                            <input type="checkbox" id="cb2ndFHA" name="cb2ndFHA" value="FHA" style="margin-left: 66px" runat="server" checked='<%# LeadsInfoData.MortgageData.C2ndFHA.HasValue andalso LeadsInfoData.MortgageData.C2ndFHA %>' />
                            <label for="<%= cb2ndFHA.ClientID %>" class=" form_div_radio_group form_div_node_margin">
                                <span class="form_span_group_text">FHA</span>
                            </label>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                            <span class="form_input_title">Servicer</span>
                            <input class="text_input" value="<%# LeadsInfoData.MortgageData.C2ndServicer %>" id="txt2ndServicer" runat="server" />
                        </div>

                        <%----end line ----%>

                        <%--line 3--%>

                        <div class="form_div_node form_div_node_line_margin">
                            <span class="form_input_title">3nd Mortgage</span>
                            <dx:ASPxTextBox runat="server" ID="txtC3rdMotgr" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.C3rdMortgrAmt  %>'></dx:ASPxTextBox>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin form_div_node_no_under_line clearfix">
                            <span class="form_input_title"></span>
                            <br />

                            <%--class="circle-radio-boxes"--%>
                            <input type="checkbox" id="cb3rdFannie" name="cb3rdFannie" value="Fannie" runat="server" checked='<%# LeadsInfoData.MortgageData.C3rdFannie.HasValue andalso LeadsInfoData.MortgageData.C3rdFannie %>' />
                            <label for="<%= cb3rdFannie.ClientID %>" class=" form_div_radio_group">
                                <span class="form_span_group_text">Fannie</span>
                            </label>
                            <input type="checkbox" id="cb3rdFHA" name="cb3rdFHA" value="" style="margin-left: 66px" runat="server" checked='<%# LeadsInfoData.MortgageData.C3rdFHA.HasValue AndAlso LeadsInfoData.MortgageData.C3rdFHA%>' />
                            <label for="<%= cb3rdFHA.ClientID %>" class=" form_div_radio_group form_div_node_margin">
                                <span class="form_span_group_text">FHA</span>
                            </label>
                        </div>

                        <div class="form_div_node form_div_node_margin form_div_node_line_margin">
                            <span class="form_input_title">Servicer</span>
                            <input class="text_input" value="<%# LeadsInfoData.MortgageData.C3rdServicer%>" id="txt3rdServicer" runat="server" />
                        </div>

                        <%----end line ----%>
                        <div style="width: 230px" class="clearfix">
                            <%--line 4--%>

                            <div class="form_div_node form_div_node_line_margin form_div_node_small">
                                <span class="form_input_title">Taxes</span>
                                <dx:ASPxTextBox runat="server" ID="txtTaxesAmt" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.TaxesAmt  %>'></dx:ASPxTextBox>
                                <%--<input class="text_input input_currency" onblur="$(this).formatCurrency();" value="$<%=LeadsInfoData.TaxesAmt%>" />--%>
                            </div>

                            <%----end line ----%>
                            <%--line 5--%>

                            <div class="form_div_node form_div_node_line_margin form_div_node_small">
                                <span class="form_input_title">water</span>
                                <dx:ASPxTextBox runat="server" ID="txtWaterAmt" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.WaterAmt  %>'></dx:ASPxTextBox>
                                <%--<input class="text_input input_currency" onblur="$(this).formatCurrency();" value="$<%= LeadsInfoData.WaterAmt%>" />--%>
                            </div>
                            <%----end line ----%>
                            <%--line 6--%>

                            <div class="form_div_node form_div_node_line_margin form_div_node_small">
                                <span class="form_input_title">ecb/dob</span>
                                <dx:ASPxTextBox runat="server" ID="txtViolationAmt" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.ViolationAmount  %>'></dx:ASPxTextBox>
                                <%--<input class="text_input" value="<%= LeadsInfoData.ViolationAmount %>" />--%>
                            </div>
                            <%--line 7--%>

                            <div class="form_div_node form_div_node_line_margin form_div_node_small">
                                <span class="form_input_title" style="color: #ff400d">Total debt</span>
                                <dx:ASPxTextBox runat="server" ID="ASPxTextBox1" DisplayFormatString="C" Native="true" CssClass="text_input input_currency" Text='<%#LeadsInfoData.TotalDebt  %>'></dx:ASPxTextBox>
                            </div>
                            <%----end line ----%>
                        </div>
                        <%----end line ----%>

                        <div style="width: 66.5%; float: right; margin-top: -211px;margin-right:5px">
                            <div style="width: 40%;float:left; margin-top:10px" class="form_head">
                                Tax Liens:
                            </div>
                            <div style="float: right;width: 53%;">
                                <div class="form_div_node form_div_node_margin form_div_node_line_margin" style="width:87%">
                                    <span class="form_input_title">Tax Liens Date</span>
                                    <input class="text_input" value="<%= LeadsInfoData.TaxLiensDateText %>" id="Text1"/>
                                </div>
                                <div class="form_div_node form_div_node_margin form_div_node_line_margin" style="width:87%">
                                    <span class="form_input_title">Tax Liens Amount</span>
                                    <input class="text_input" value="<%= LeadsInfoData.TaxLiensAmount %>" id="Text2" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <%-------end-----%>
                </dx:PanelContent>
            </PanelCollection>
            <ClientSideEvents EndCallback="function(s,e){alert('Saved.');}" />
        </dx:ASPxCallbackPanel>

        <%--Liens table--%>
        <div style="margin: 20px;" class="clearfix">
            <div class="form_head" style="margin-top: 40px;">Liens</div>
            <dx:ASPxGridView runat="server" ID="gridLiens" KeyFieldName="LisPenID" Width="100%">
                <SettingsBehavior AllowDragDrop="false" AllowSort="false" AllowGroup="false" />
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="Type" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Effective" Settings-AllowSort="False">
                        <DataItemTemplate>
                            <%# DateTime.Parse(Eval("Effective")).ToShortDateString %>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Expiration" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Plaintiff" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Defendant" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Index" Settings-AllowSort="False"></dx:GridViewDataTextColumn>
                </Columns>
            </dx:ASPxGridView>
            <table class="table table-condensed" style="width: 100%; display: none">
                <thead>
                    <tr>
                        <th class="report_head">Effective</th>
                        <th class="report_head">Expiration</th>
                        <th class="report_head">Type</th>
                        <th class="report_head">PlainTiff</th>
                        <th class="report_head">Defendant</th>
                        <th class="report_head">Index</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="report_content">8/23/2013</td>
                        <td class="report_content">8/23/2014</td>
                        <td class="report_content">H.P.D.ORDER TO CORRECT</td>
                        <td class="report_content">DEPT OF HOUSING PRESERVATION 100 GOLD ST 6TH FL NEW YORK NY 10038</td>
                        <td class="report_content">OWNER OF BLOCK & LOT</td>
                        <td class="report_content">HP 170/13</td>
                    </tr>
                    <tr style="color: #b1b2b7">
                        <td class="report_content">5/16/2013</td>
                        <td class="report_content">5/16/2016
                                            <span class="color_balck">SATISFIED: 11/15/2013</span>
                        </td>
                        <td class="report_content">JUDGEMENT</td>
                        <td class="report_content">DEPT OF HOUSING PRESERVATION 100 GOLD ST 6TH FL NEW YORK NY 10038</td>
                        <td class="report_content">BRIGG ESTRELLA</td>
                        <td class="report_content">HP 170/13</td>
                    </tr>
                </tbody>

            </table>
        </div>
        <%--end--%>
    </div>
</div>
<!-- custom scrollbar plugin -->

<dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
    ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"><%= LeadsInfoData.PropertyAddress%> </span>
            </div>
            <div class="pop_up_buttons_div">
                <i class="fa fa-times icon_btn" onclick="aspxAcrisControl.Hide()"></i>
            </div>
        </div>
        <div style="text-align: center" id="addition_info"></div>
    </HeaderTemplate>
    <ContentCollection>
        <dx:PopupControlContentControl runat="server">
        </dx:PopupControlContentControl>
    </ContentCollection>
</dx:ASPxPopupControl>

<script src="../scrollbar/jquery.mCustomScrollbar.concat.min.js"></script>

<script type="text/javascript">
    init_currency();
</script>
