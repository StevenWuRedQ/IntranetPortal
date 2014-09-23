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
        short_sale_case_data = $.parseJSON(e.result);
        short_sale_case_data.PropertyInfo.UpdateBy = "<%=Page.User.Identity.Name%>";
        var strJson = JSON.stringify(collectDate(short_sale_case_data));
        alert(strJson);
        SaveClicklCallbackCallbackClinet.PerformCallback(strJson);
    }
    function saveComplete(s,e)
    {
        RefreshContent();
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
                    <%--refresh label--%>

                    <dx:ASPxPanel ID="UpatingPanel" runat="server">
                        <PanelCollection>
                            <dx:PanelContent runat="server">
                                <div class="update_panel">
                                    <i class="fa fa-spinner fa-spin" style="margin-left: 30px"></i>
                                    <span style="padding-left: 22px">Lead is being updated, it will take a few minutes to complete.</span>
                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxPanel>
                    <%--time label--%>
                    <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
                        <div style="font-size: 30px">
                            <span>
                                <i class="fa fa-refresh"></i>
                                <span style="margin-left: 19px;">Jun 9,2014 1:12PM</span>
                            </span>
                            <span class="time_buttons" style="margin-right: 30px; font-weight: 300;" onclick="ShowPopupMap('https://iapps.courts.state.ny.us/webcivil/ecourtsMain', 'eCourts')">eCourts</span>
                            <span class="time_buttons">DOB</span>
                            <span class="time_buttons">Acris</span>
                            <span class="time_buttons">Maps</span>
                        </div>
                        <%--data format June 2, 2014 6:37 PM--%>
                        <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">Started on June 2,1014</span>
                    </div>

                    <%--note list--%>
                    <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">


                        <div class="note_item">
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">Liens higher than Value</span>
                        </div>

                        <div class="note_item" style="background: #e8e8e8">
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">Water Lien is High - Possible Tenant Issues</span>
                        </div>

                        <asp:HiddenField ID="hfBBLE" runat="server" />


                        <div class="note_item">
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">133</span>
                            <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7; display: none"></i>
                            <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7; cursor: pointer" onclick="DeleteComments"></i>
                        </div>


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
                                                    <%--<ClientSideEvents Click="SaveLeadsComments" />--%>
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
                            <li class="short_sale_tab"><a class="shot_sale_tab_a " href="#Homewoner" role="tab" data-toggle="tab">Homewoner</a></li>
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

