<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionTab.ascx.vb" Inherits="IntranetPortal.ConstructionTab" %>
<%@ Register Src="~/Construction/ConstructionInitialIntakeTab.ascx" TagPrefix="uc1" TagName="ConstructionInitialIntakeTab" %>
<%@ Register Src="~/Construction/ConstructionPhotosTab.ascx" TagPrefix="uc1" TagName="ConstructionPhotosTab" %>
<%@ Register Src="~/Construction/ConstructionUtilitiesTab.ascx" TagPrefix="uc1" TagName="ConstructionUtilitiesTab" %>
<%@ Register Src="~/Construction/ConstructionViolationTab.ascx" TagPrefix="uc1" TagName="ConstructionViolationTab" %>
<%@ Register Src="~/Construction/ConstructionProposalBidTab.ascx" TagPrefix="uc1" TagName="ConstructionProposalBidTab" %>
<%@ Register Src="~/Construction/ConstructionPlansTab.ascx" TagPrefix="uc1" TagName="ConstructionPlansTab" %>
<%@ Register Src="~/Construction/ConstructionContractTab.ascx" TagPrefix="uc1" TagName="ConstructionContractTab" %>
<%@ Register Src="~/Construction/ConstructionSignoffsTab.ascx" TagPrefix="uc1" TagName="ConstructionSignoffsTab" %>


<script src="/Scripts/jquery.formatCurrency-1.1.0.js"></script>

<div id="constructionTabContent">
    <input hidden id="short_sale_case_id" value="" />
    <div style="padding-top: 5px">
        <div style="height: auto; max-height: 400px; overflow: auto;" id="prioity_content">
            <div style="height: 80px; font-size: 30px; margin-left: 30px; margin-top: 20px;" class="font_gray">
                <div style="font-size: 30px">
                    <i class="fa fa-home"></i>
                    <span style="margin-left: 19px;">{{GetCaseInfo().Address}}&nbsp;</span>
                    <span class="time_buttons" style="margin-right: 30px" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=3&bble='+leadsInfoBBLE, 'eCourts')">eCourts</span>
                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=2&bble='+leadsInfoBBLE, 'DOB')">DOB</span>
                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=1&bble='+leadsInfoBBLE, 'Acris')">Acris</span>
                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+leadsInfoBBLE, 'Maps')">Maps</span>
                    <span class="time_buttons" onclick="OpenLeadsWindow('http://nycserv.nyc.gov/NYCServWeb/NYCSERVMain', 'eCourts')">Water&Taxes</span>
                </div>

                <span style="font-size: 14px; margin-top: -5px; float: left; margin-left: 53px;">{{GetCaseInfo().Name}}</span>
            </div>

            <div class="font_deep_gray" style="border-top: 1px solid #dde0e7; font-size: 20px">

                <div class="note_item" ng-repeat="comment in SsCase.Comments" ng-style="$index%2?{'background':'#e8e8e8'}:{}">
                    <i class="fa fa-exclamation-circle note_img"></i>
                    <span class="note_text">{{comment.Comments}}</span>
                    <i class="fa fa-arrows-v" style="float: right; line-height: 40px; padding-right: 20px; font-size: 18px; color: #b1b2b7; display: none"></i>
                    <i class="fa fa-times" style="float: right; padding-right: 25px; line-height: 40px; font-size: 18px; color: #b1b2b7; cursor: pointer" ng-click="DeleteComments($index)"></i>
                </div>

                <div class="note_item" style="background: white">
                    <i class="fa fa-plus-circle note_img tooltip-examples" title="Add Notes" style="color: #3993c1; cursor: pointer" ng-click="ShowAddPopUp($event)"></i>
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
        </div>


        <div class="shortSaleUI detail_tabs">
            <style>
                #CSTab .short_sale_tab {
                    font-size: 12px;
                }
            </style>
            <ul id="CSTab" class="nav nav-tabs overview_tabs" role="tablist">
                <li class="short_sale_tab active"><a class="shot_sale_tab_a" href="#CSInitialIntake" role="tab" data-toggle="tab">Initial Intake</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSPhotos" role="tab" data-toggle="tab">Photos</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSUtilities" role="tab" data-toggle="tab">Utilities</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSViolations" role="tab" data-toggle="tab">Violation</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSProposal" role="tab" data-toggle="tab">ProposalBids</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSPlans" role="tab" data-toggle="tab">Plans</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSContract" role="tab" data-toggle="tab">Contract</a></li>
                <li class="short_sale_tab"><a class="shot_sale_tab_a" href="#CSSignoff" role="tab" data-toggle="tab">Signoffs</a></li>
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
