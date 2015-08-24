<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGShortSaleTab.ascx.vb" Inherits="IntranetPortal.NGShortSaleTab" %>
<%@ Import Namespace="IntranetPortal" %>
<%@ Register Src="~/ShortSale/NGShortSaleDealInfoTab.ascx" TagPrefix="uc1" TagName="NGShortSaleDealInfoTab" %>
<%@ Register Src="~/ShortSale/NGShortSaleHomewonerTab.ascx" TagPrefix="uc1" TagName="NGShortSaleHomewonerTab" %>
<%@ Register Src="~/ShortSale/NGShortSaleMortgageTab.ascx" TagPrefix="uc1" TagName="NGShortSaleMortgageTab" %>
<%@ Register Src="~/ShortSale/NGShortSalePartiesTab.ascx" TagPrefix="uc1" TagName="NGShortSalePartiesTab" %>
<%@ Register Src="~/ShortSale/NGShortSalePropertyTab.ascx" TagPrefix="uc1" TagName="NGShortSalePropertyTab" %>
<%@ Register Src="~/PopupControl/VendorsPopup.ascx" TagPrefix="uc1" TagName="VendorsPopup" %>
<%@ Register Src="~/ShortSale/NGShortSaleCheckListTab.ascx" TagPrefix="uc1" TagName="NGShortSaleCheckListTab" %>


<script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>

<dx:ASPxCallbackPanel ID="ShortSaleCaseSavePanel" ClientInstanceName="ShortSaleCaseSavePanelClient" runat="server" Width="100%">
    <PanelCollection>
        <dx:PanelContent>
            <input hidden id="short_sale_case_id" value="" />
            <div style="padding-top: 5px">
                <div style="height: 850px; overflow: auto;" id="prioity_content">
                    <%--time label--%>

                    <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
                        <div style="font-size: 30px">
                            <i class="fa fa-home" ng-dblclick="toggleValuationPopup()"></i>
                            <span style="margin-left: 19px;">{{GetCaseInfo().Address}}&nbsp;</span>

                            <span class="time_buttons" style="margin-right: 30px" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=3&bble='+leadsInfoBBLE, 'eCourts')">eCourts</span>
                            <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=2&bble='+leadsInfoBBLE, 'DOB')">DOB</span>
                            <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=1&bble='+leadsInfoBBLE, 'Acris')">Acris</span>
                            <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+leadsInfoBBLE, 'Maps')">Maps</span>
                            <span class="time_buttons" onclick="OpenLeadsWindow('http://nycserv.nyc.gov/NYCServWeb/NYCSERVMain', 'eCourts')">Water&Taxes</span>
                        </div>
                        <%--data format June 2, 2014 6:37 PM--%>
                        <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">{{GetCaseInfo().Name}}</span>
                    </div>

                    <%--note list--%>
                    <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">

                        <div class="note_item" ng-repeat="comment in SsCase.Comments" ng-style="$index%2?{'background':'#e8e8e8'}:{}">
                            <i class="fa fa-exclamation-circle note_img"></i>
                            <span class="note_text">{{comment.Comments}}</span>
                            <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7; display: none"></i>
                            <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7; cursor: pointer" ng-click="DeleteComments($index)"></i>
                        </div>

                        <div class="note_item" style="background: white">
                            <%--<button class="btn" data-container="body" type="button" data-toggle="popover" data-placement="right" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">--%>
                            <i class="fa fa-plus-circle note_img tooltip-examples" title="Add Notes" style="color: #3993c1; cursor: pointer" ng-click="ShowAddPopUp($event)"></i>

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
                                            <input type="text" ng-model="addCommentTxt" class="form-control" />
                                        </td>
                                        <td style="text-align: right">
                                            <div style="margin-left: 20px">
                                                <input type="button" value="Add" ng-click="AddComments()" class="rand-button" style="background-color: #3993c1" />
                                                <input type="button" value="Close" onclick="aspxAddLeadsComments.Hide()" class="rand-button" style="background-color: #3993c1" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>

                    <div class="detail_tabs">
                        <ul class="nav nav-tabs overview_tabs" role="tablist">
                            <li class="short_sale_tab active">
                                <a class="shot_sale_tab_a " href="#SSHomeowner" role="tab" data-toggle="tab">Homeowner Info</a></li>
                            <li class="short_sale_tab">
                                <a class="shot_sale_tab_a " href="#SSProperty" role="tab" data-toggle="tab">Property Info</a></li>
                            <li class="short_sale_tab "><a class="shot_sale_tab_a " href="#SSMortgage" role="tab" data-toggle="tab">Mortgages</a></li>
                            <li class="short_sale_tab "><a class="shot_sale_tab_a " href="#SSDeal" role="tab" data-toggle="tab">Deal Info</a></li>
                            <li class="short_sale_tab "><a class="shot_sale_tab_a " href="#SSParties" role="tab" data-toggle="tab">Parties</a></li>
                            <li class="short_sale_tab "><a class="shot_sale_tab_a " href="#CheckList" role="tab" data-toggle="tab">Checklist</a></li>
                            <%--  <% End If%>--%>
                        </ul>

                        <!-- Tab panes -->
                        <div class="short_sale_content">
                            <div class="tab-content">
                                <div class="tab-pane active" id="SSHomeowner">
                                    <uc1:NGShortSaleHomewonerTab runat="server" ID="NGShortSaleHomewonerTab1" />
                                </div>
                                <div class="tab-pane " id="SSProperty">
                                    <uc1:NGShortSalePropertyTab runat="server" ID="NGShortSalePropertyTab" />
                                </div>
                                <div class="tab-pane" id="SSMortgage">
                                    <uc1:NGShortSaleMortgageTab runat="server" ID="NGShortSaleMortgageTab" />
                                </div>

                                <div class="tab-pane" id="SSDeal">
                                    <uc1:NGShortSaleDealInfoTab runat="server" ID="NGShortSaleDealInfoTab" />
                                </div>
                                <div class="tab-pane" id="SSParties">
                                    <uc1:NGShortSalePartiesTab runat="server" ID="NGShortSalePartiesTab" />
                                </div>
                                <div class="tab-pane" id="CheckList">
                                    <uc1:NGShortSaleCheckListTab runat="server" ID="NGShortSaleCheckListTab" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </dx:PanelContent>
    </PanelCollection>
</dx:ASPxCallbackPanel>

<dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
    ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"><%--= shortSaleCaseData.PropertyInfo.PropertyAddress--%></span>
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
