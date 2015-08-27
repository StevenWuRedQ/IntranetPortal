<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionTab.ascx.vb" Inherits="IntranetPortal.ConstructionTab" %>
<%@ Register Src="~/Construction/ConstructionInitialIntakeTab.ascx" TagPrefix="uc1" TagName="ConstructionInitialIntakeTab" %>
<%@ Register Src="~/Construction/ConstructionPhotosTab.ascx" TagPrefix="uc1" TagName="ConstructionPhotosTab" %>
<%@ Register Src="~/Construction/ConstructionUtilitiesTab.ascx" TagPrefix="uc1" TagName="ConstructionUtilitiesTab" %>
<%@ Register Src="~/Construction/ConstructionViolationTab.ascx" TagPrefix="uc1" TagName="ConstructionViolationTab" %>
<%@ Register Src="~/Construction/ConstructionProposalBidTab.ascx" TagPrefix="uc1" TagName="ConstructionProposalBidTab" %>
<%@ Register Src="~/Construction/ConstructionPlansTab.ascx" TagPrefix="uc1" TagName="ConstructionPlansTab" %>
<%@ Register Src="~/Construction/ConstructionContractTab.ascx" TagPrefix="uc1" TagName="ConstructionContractTab" %>
<%@ Register Src="~/Construction/ConstructionSignoffsTab.ascx" TagPrefix="uc1" TagName="ConstructionSignoffsTab" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>



<script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>
<uc1:Common runat="server" ID="Common" />
<div id="constructionTabContent" style="max-height: 850px; overflow: auto">
    <input hidden id="short_sale_case_id" value="" />
    <div style="padding-top: 5px">
        <div id="prioity_content">
            <div style="font-size: 30px; margin-left: 30px; height: 80px" class="font_gray">
                <div style="font-size: 30px; margin-top: 20px;">
                    <i class="fa fa-home"></i>
                    <span style="margin-left: 19px;"><span ng-bind="CSCase.CSCase.Header" pt-init-bind="CSCase.CaseName" ng-dblclick="toggleHeaderEditing()" ng-show="!HeaderEditing"></span>&nbsp;</span>
                    <input ng-show="HeaderEditing" ng-Blur="toggleHeaderEditing()" ng-model="CSCase.CSCase.Header"/>
                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+leadsInfoBBLE, 'Maps')">Map</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('http://nycserv.nyc.gov/NYCServWeb/NYCSERVMain', 'eCourts')" ng-show="activeTab=='CSUtilities'">Water&Taxes</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('http://a820-ecbticketfinder.nyc.gov/searchHome.action ', 'ECB')" ng-show="activeTab=='CSViolations'">ECB</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=2&bble='+leadsInfoBBLE, 'DOB')" ng-show="activeTab=='CSViolations'">DOB</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('http://www1.nyc.gov/site/hpd/index.page', 'HPD')" ng-show="activeTab=='CSViolations'">HPD</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('http://www1.nyc.gov/site/finance/index.page', 'Department of Finance')" ng-show="">Department of Finance</span>

                    <span class="time_buttons" onclick="OpenLeadsWindow('http://www1.nyc.gov/assets/hpd/downloads/pdf/Dismissal-Request-Form-2013.pdf', 'Dismissal Request form')" ng-show="activeTab=='CSViolations'">Dismissal Request form</span>


                </div>

                <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">{{GetCaseInfo().Name}}</span>
            </div>

            <div class="comment-panel" style="margin: 10px; border-top: 1px solid #c8c8c8">
                <%--note list--%>
                <div style="width: 100%; overflow: auto; max-height: 160px;">
                    <table class="table table-striped" style="font-size: 14px; margin: 0px; padding: 5px">
                        <tr ng-repeat="highlight in highlights" ng-show="isHighlight(highlight.criteria)">
                            <td>
                                <i class="fa fa-exclamation-circle text-success" style="font-size: 18px"></i>
                                <span class="text-success" style="margin-left: 10px">{{highlightMsg(highlight.message)}}</span>
                            </td>
                        </tr>
                        <tr ng-repeat="comment in CSCase.CSCase.Comments">
                            <td>
                                <i class="fa fa-exclamation-circle" style="font-size: 18px"></i>
                                <span style="margin-left: 10px">{{comment.comment}}</span>
                                <span class="pull-right">
                                    <i class="fa fa-times icon_btn text-danger" style="font-size: 18px" ng-click="arrayRemove(CSCase.CSCase.Comments, $index, true)"></i>
                                </span>
                            </td>
                        </tr>
                    </table>
                </div>

                <div>
                    <i class="fa fa-plus-circle text-primary icon_btn tooltip-examples" style="font-size: 19px; margin: 8px" title="Add Notes" ng-click="showPopover($event)"></i>
                    <dx:ASPxPopupControl ClientInstanceName="aspxConstructionCommentsPopover" Width="550px" Height="50px" ID="ASPxPopupControl2"
                        ShowHeader="false" runat="server" EnableViewState="false" PopupHorizontalAlign="OutsideRight" PopupVerticalAlign="Middle" EnableHierarchyRecreation="True">
                        <ContentCollection>
                            <dx:PopupControlContentControl>
                                <table>
                                    <tr style="padding-top: 3px;">
                                        <td style="width: 380px; vertical-align: central">
                                            <input type="text" ng-model="addCommentTxt" class="form-control" />
                                        </td>
                                        <td style="text-align: right">
                                            <div style="margin-left: 20px">
                                                <input type="button" value="Add" ng-click="addCommentFromPopup()" class="rand-button" style="background-color: #3993c1" />
                                                <input type="button" value="Close" onclick="aspxConstructionCommentsPopover.Hide()" class="rand-button" style="background-color: #3993c1" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </dx:PopupControlContentControl>
                        </ContentCollection>
                    </dx:ASPxPopupControl>
                </div>

            </div>
        </div>

        <div class="shortSaleUI">
            <style>
                #CSTab .short_sale_tab {
                    font-size: 12px;
                }
            </style>
            <ul id="CSTab" class="nav nav-tabs overview_tabs" role="tablist">
                <li class="short_sale_tab active"><a class="shot_sale_tab_a" href="#CSInitialIntake" role="tab" data-toggle="tab" ng-click="updateActive('CSInitialIntake')">Initial Intake</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSPhotos" role="tab" data-toggle="tab" ng-click="updateActive('CSPhotos')">Photos</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSUtilities" role="tab" data-toggle="tab" ng-click="updateActive('CSUtilities')">Utilities</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSViolations" role="tab" data-toggle="tab" ng-click="updateActive('CSViolations')">Violation</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSProposal" role="tab" data-toggle="tab" ng-click="updateActive('CSProposal')">ProposalBids</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSPlans" role="tab" data-toggle="tab" ng-click="updateActive('CSPlans')">Plans</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSContract" role="tab" data-toggle="tab" ng-click="updateActive('CSContract')">Contract</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSSignoff" role="tab" data-toggle="tab" ng-click="updateActive('CSSignoff')">Signoffs</a></li>
                <%--  <% End If%>--%>
            </ul>

            <!-- Tab panes -->
            <div class="short_sale_content">
                <div class="tab-content">
                    <div class="tab-pane active" id="CSInitialIntake">
                        <uc1:ConstructionInitialIntakeTab runat="server" ID="ConstructionInitialIntakeTab" />
                    </div>
                    <div class="tab-pane" id="CSPhotos">
                        <uc1:ConstructionPhotosTab runat="server" ID="ConstructionPhotosTab" />
                    </div>
                    <div class="tab-pane" id="CSUtilities">
                        <uc1:ConstructionUtilitiesTab runat="server" ID="ConstructionUtilitiesTab" />
                    </div>
                    <div class="tab-pane" id="CSViolations">
                        <uc1:ConstructionViolationTab runat="server" ID="ConstructionViolationTab" />
                    </div>
                    <div class="tab-pane" id="CSProposal">
                        <uc1:ConstructionProposalBidTab runat="server" ID="ConstructionProposalBidTab" />
                    </div>
                    <div class="tab-pane" id="CSPlans">
                        <uc1:ConstructionPlansTab runat="server" ID="ConstructionPlansTab" />
                    </div>
                    <div class="tab-pane" id="CSContract">
                        <uc1:ConstructionContractTab runat="server" ID="ConstructionContractTab" />
                    </div>
                    <div class="tab-pane" id="CSSignoff">
                        <uc1:ConstructionSignoffsTab runat="server" ID="ConstructionSignoffsTab" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<dx:ASPxPopupControl ClientInstanceName="aspxAcrisControl" Width="1000px" Height="800px"
    ID="ASPxPopupControl1" HeaderText="Acris" Modal="true" CloseAction="CloseButton" ShowMaximizeButton="true"
    runat="server" EnableViewState="false" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" EnableHierarchyRecreation="True">
    <HeaderTemplate>
        <div class="clearfix">
            <div class="pop_up_header_margin">
                <i class="fa fa-tasks with_circle pop_up_header_icon"></i>
                <span class="pop_up_header_text" id="pop_up_header_text">Acris</span> <span class="pop_up_header_text"></span>
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
