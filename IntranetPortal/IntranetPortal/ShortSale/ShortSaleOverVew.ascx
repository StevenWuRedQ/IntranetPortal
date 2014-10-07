<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ShortSaleOverVew.ascx.vb" Inherits="IntranetPortal.ShortSaleOverVew" %>
<%@ Register Src="~/ShortSale/ShortSaleSummaryTab.ascx" TagPrefix="uc1" TagName="ShortSaleSummaryTab" %>
<%@ Register Src="~/ShortSale/ShortSalePropertyTab.ascx" TagPrefix="uc1" TagName="ShortSalePropertyTab" %>
<%@ Register Src="~/ShortSale/ShortSalePartiesTab.ascx" TagPrefix="uc1" TagName="ShortSalePartiesTab" %>
<%@ Register Src="~/ShortSale/ShortSaleEvictionTab.ascx" TagPrefix="uc1" TagName="ShortSaleEvictionTab" %>
<%@ Register Src="~/ShortSale/ShortSaleHomewonerTab.ascx" TagPrefix="uc1" TagName="ShortSaleHomewonerTab" %>
<%@ Register Src="~/ShortSale/ShortSaleMortgageTab.ascx" TagPrefix="uc1" TagName="ShortSaleMortgageTab" %>



<script src="/scripts/jquery.formatCurrency-1.1.0.js"></script>
<script type="text/javascript">
    function init_currency() {
        $('.input_currency').formatCurrency();
    }
    $(document).ready(function () {
        // Handler for .ready() called.
        init_currency();
    });
    var short_sale_case_data = null;

    function getShortSaleInstanceComplete(s, e) {
        short_sale_case_data = ShortSaleCaseData;//$.parseJSON(e.result);
        //ShortSaleCaseData = short_sale_case_data;
        short_sale_case_data.PropertyInfo.UpdateBy = "<%=Page.User.Identity.Name%>";

        ShortSaleDataBand(1);
        
        var strJson = JSON.stringify(ShortSaleCaseData);
        
        //d_alert(strJson);

        SaveClicklCallbackCallbackClinet.PerformCallback(strJson);

    }
    function saveComplete(s, e) {
        //RefreshContent();
        ShortSaleDataBand(2);
    }

    function ShowAcrisMap(propBBLE) {
        //var url = "http://www.oasisnyc.net/map.aspx?zoomto=lot:" + propBBLE;
        ShowPopupMap("https://a836-acris.nyc.gov/DS/DocumentSearch/BBL", "Acris");
    }

    function ShowDOBWindow(boro, houseNo, street) {
        var url = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + boro + "&houseno=" + encodeURIComponent(houseNo) + "&street=" + encodeURIComponent(street);
        ShowPopupMap(url, "DOB");
    }

    function ShowPopupMap(url, header) {
        aspxAcrisControl.SetContentHtml("Loading...");
        aspxAcrisControl.SetContentUrl(url);
        aspxAcrisControl.SetHeaderText(header);
        $('#pop_up_header_text').html(header)
        aspxAcrisControl.Show();
    }

    function SaveLeadsComments(s, e) {
        var comments = txtLeadsComments.GetText();
        leadsCommentsCallbackPanel.PerformCallback("Add|" + comments);
        txtLeadsComments.SetText("");
        aspxAddLeadsComments.Hide();
    }

    function DeleteComments(commentId) {
        leadsCommentsCallbackPanel.PerformCallback("Delete|" + commentId);
    }

</script>
<dx:ASPxCallback ID="SaveClicklCallback" ClientInstanceName="SaveClicklCallbackCallbackClinet" runat="server" OnCallback="SaveClicklCallback_Callback">
    <ClientSideEvents CallbackComplete="saveComplete" />
</dx:ASPxCallback>
<dx:ASPxCallback ID="getShortSaleInstance" ClientInstanceName="getShortSaleInstanceClient" runat="server" OnCallback="getShortSaleInstance_Callback">
    <ClientSideEvents CallbackComplete="getShortSaleInstanceComplete" />
</dx:ASPxCallback>

<dx:ASPxCallbackPanel ID="ShortSaleCaseSavePanel" ClientInstanceName="ShortSaleCaseSavePanelClient" runat="server" Width="100%">
    <PanelCollection>
        <dx:PanelContent>
            <input hidden id="short_sale_case_id" value="<%=shortSaleCaseData.CaseId %>" />
            <div style="padding-top: 5px">
                <div style="height: 850px; overflow: auto;" id="prioity_content">
                    <%--time label--%>

                    <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
                        <div style="font-size: 30px">
                            <span style='<%=If(shortSaleCaseData.UpdateDate.HasValue, "visibility:visible", "visibility:hidden")%>'>
                                <i class="fa fa-refresh"></i>
                                <span style="margin-left: 19px;"><%= shortSaleCaseData.UpdateDate.ToString%></span>
                            </span>
                            <% If shortSaleCaseData.PropertyInfo IsNot Nothing Then%>
                            <span class="time_buttons" style="margin-right: 30px" onclick="ShowPopupMap('https://iapps.courts.state.ny.us/webcivil/ecourtsMain', 'eCourts')">eCourts</span>
                            <span class="time_buttons" onclick='ShowDOBWindow("<%= shortSaleCaseData.PropertyInfo.Borough%>","<%= shortSaleCaseData.PropertyInfo.Number%>", "<%= shortSaleCaseData.PropertyInfo.StreetName%>")'>DOB</span>
                            <span class="time_buttons" onclick='ShowAcrisMap("<%= shortSaleCaseData.BBLE %>")'>Acris</span>
                            <span class="time_buttons" onclick='ShowPropertyMap("<%= shortSaleCaseData.BBLE %>")'>Maps</span>

                            <dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
                                ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
                                runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
                                <HeaderTemplate>
                                    <div class="clearfix">
                                        <div class="pop_up_header_margin">
                                            <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                                            <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"><%= shortSaleCaseData.PropertyInfo.PropertyAddress%> </span>
                                        </div>
                                        <div class="pop_up_buttons_div">
                                            <i class="fa fa-times icon_btn" onclick="aspxAcrisControl.Hide()"></i>
                                        </div>
                                    </div>
                                </HeaderTemplate>
                                <ContentCollection>
                                    <dx:PopupControlContentControl runat="server">
                                    </dx:PopupControlContentControl>
                                </ContentCollection>
                            </dx:ASPxPopupControl>

                            <% End If%>
                        </div>
                        <%--data format June 2, 2014 6:37 PM--%>
                        <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px; <%= If(shortSaleCaseData.CreateDate.HasValue,"visibility:visible","visibility:hidden")%>">Started on <%= shortSaleCaseData.CreateDate.ToString%></span>
                    </div>

                    <%--note list--%>
                    <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">
                        <dx:ASPxCallbackPanel runat="server" ID="leadsCommentsCallbackPanel" ClientInstanceName="leadsCommentsCallbackPanel" OnCallback="leadsCommentsCallbackPanel_Callback">
                            <PanelCollection>
                                <dx:PanelContent>
                                    <% Dim i = 0%>
                                    <asp:HiddenField ID="hfCaseId" runat="server" />

                                    <% For Each comment In shortSaleCaseData.Comments%>
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


                    <%--detial tabs--%>
                    <div>
                        <!--detial Nav tabs -->
                        <ul class="nav nav-tabs overview_tabs" role="tablist">
                            <li class="active short_sale_tab">
                                <a class="shot_sale_tab_a" href="#home" role="tab" data-toggle="tab">Summary</a></li>
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Property" role="tab" data-toggle="tab">Property Info</a></li>
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Mortgages" role="tab" data-toggle="tab">Mortgages</a></li>
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Homewoner" role="tab" data-toggle="tab">Homeowner</a></li>
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Eviction" role="tab" data-toggle="tab">Eviction</a></li>
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Parties" role="tab" data-toggle="tab">Parties</a></li>
                        </ul>
                        <%--<dx:ASPxCallbackPanel ID="overviewCallbackPanel" runat="server" ClientInstanceName="overviewCallbackPanelClinet" OnCallback="overviewCallbackPanel_Callback">--%>
                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div class="tab-pane active" id="home">
                                <div class="short_sale_content">

                                    <uc1:ShortSaleSummaryTab runat="server" ID="ShortSaleSummaryTab" />
                                </div>
                            </div>
                            <div class="tab-pane" id="Property">
                                <div class="short_sale_content">
                                    <uc1:ShortSalePropertyTab runat="server" ID="ShortSalePropertyTab" />
                                </div>
                            </div>
                            <div class="tab-pane" id="Mortgages">
                                <div class="short_sale_content">
                                    <uc1:ShortSaleMortgageTab runat="server" ID="ShortSaleMortgageTab" />
                                </div>
                            </div>
                            <div class="tab-pane" id="Homewoner">
                                <div class="short_sale_content">
                                    <uc1:ShortSaleHomewonerTab runat="server" ID="ShortSaleHomewonerTab" />
                                </div>
                            </div>
                            <div class="tab-pane" id="Eviction">
                                <div class="short_sale_content">
                                    <uc1:ShortSaleEvictionTab runat="server" ID="ShortSaleEvictionTab" />
                                </div>
                            </div>
                            <div class="tab-pane" id="Parties">
                                <div class="short_sale_content">
                                    <uc1:ShortSalePartiesTab runat="server" ID="ShortSalePartiesTab" />
                                </div>

                            </div>
                        </div>
                        <%--</dx:ASPxCallbackPanel>--%>
                    </div>
                </div>
            </div>
        </dx:PanelContent>
    </PanelCollection>

</dx:ASPxCallbackPanel>

