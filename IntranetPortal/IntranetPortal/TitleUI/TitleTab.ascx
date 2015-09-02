<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleTab.ascx.vb" Inherits="IntranetPortal.TitleTab" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/TitleUI/TitleInfo.ascx" TagPrefix="uc1" TagName="TitleInfo" %>
<%@ Register Src="~/TitleUI/TitleOwnerLiens.ascx" TagPrefix="uc1" TagName="TitleOwnerLiens" %>
<%@ Register Src="~/TitleUI/TitleBuildingLiens.ascx" TagPrefix="uc1" TagName="TitleBuildingLiens" %>
<%@ Register Src="~/TitleUI/TitleSurveyAndContin.ascx" TagPrefix="uc1" TagName="TitleSurveyAndContin" %>
<%@ Register Src="~/TitleUI/TitlePreclosing.ascx" TagPrefix="uc1" TagName="TitlePreclosing" %>

<uc1:Common runat="server" ID="Common" />
<div id="TitleController" ng-controller="TitleController" style="max-height: 850px; overflow: auto">
    <div style="padding-top: 5px">
        <div id="prioity_content">
            <div style="font-size: 30px; margin-left: 30px; height: 80px" class="font_gray">
                <div style="font-size: 30px; margin-top: 20px;">
                    <i class="fa fa-home"></i>
                    <span style="margin-left: 19px;"><span ng-bind="TitleUI.CaseName"></span>&nbsp;</span>
                    <span class="time_buttons" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+leadsInfoBBLE, 'Maps')">Map</span>
                </div>
            </div>

            <div class="comment-panel" ng-controller="CommentCtrl" style="margin: 10px; border-top: 1px solid #c8c8c8">
                <%--note list--%>
                <div style="width: 100%; overflow: auto; max-height: 160px;">
                    <table class="table table-striped" style="font-size: 14px; margin: 0; padding: 5px">
                        <tr ng-repeat="comment in CaseData.Comments">
                            <td>
                                <i class="fa fa-exclamation-circle" style="font-size: 18px"></i>
                                <span style="margin-left: 10px">{{comment.comment}}</span>
                                <span class="pull-right">
                                    <i class="fa fa-times icon_btn text-danger" style="font-size: 18px" ng-click="arrayRemove(CaseData.Comments, $index, true);"></i>
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
            <ul class="nav nav-tabs overview_tabs" role="tablist">
                <li class="short_sale_tab active"><a class="shot_sale_tab_a" href="#TitleInfoTab" role="tab" data-toggle="tab">Info</a></li>
                <li class="short_sale_tab "><a class="shot_sale_tab_a" href="#TitleOwnerLiensTab" role="tab" data-toggle="tab">Owner Liens</a></li>
                <li class="short_sale_tab "><a class="shot_sale_tab_a" href="#TitleBuildingLiensTab" role="tab" data-toggle="tab">Building Liens</a></li>
                <li class="short_sale_tab "><a class="shot_sale_tab_a" href="#TitleSurveyAndContinTab" role="tab" data-toggle="tab">Surveys And Contins</a></li>
                <li class="short_sale_tab "><a class="shot_sale_tab_a" href="#TitlePreclosingTab" role="tab" data-toggle="tab">Preclosing Documents</a></li>
            </ul>

            <!-- Tab panes -->
            <div class="short_sale_content">
                <div class="tab-content">
                    <div class="tab-pane active" id="TitleInfoTab">
                        <uc1:TitleInfo runat="server" ID="TitleInfo" />
                    </div>
                    <div class="tab-pane" id="TitleOwnerLiensTab">
                        <uc1:TitleOwnerLiens runat="server" ID="TitleOwnerLiens" />
                    </div>

                    <div class="tab-pane" id="TitleBuildingLiensTab">
                        <uc1:TitleBuildingLiens runat="server" ID="TitleBuildingLiens" />
                    </div>
                    <div class="tab-pane" id="TitleSurveyAndContinTab">
                        <uc1:TitleSurveyAndContin runat="server" id="TitleSurveyAndContin" />
                    </div>
                    <div class="tab-pane" id="TitlePreclosingTab">
                        <uc1:TitlePreclosing runat="server" id="TitlePreclosing" />
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
<script>
    function ShowPopupMap(url, header, subHeader) {
        aspxAcrisControl.SetContentHtml("Loading...");
        aspxAcrisControl.SetContentUrl(url);
        aspxAcrisControl.SetHeaderText(header);

        $('#pop_up_header_text').html(header);
        $('#addition_info').html(subHeader ? subHeader : '');

        aspxAcrisControl.Show();
    }

    function ShowAcrisMap(propBBLE) {
        ShowPopupMap("https://a836-acris.nyc.gov/DS/DocumentSearch/BBL", "Acris");
    }

    function ShowDOBWindow(boro, block, lot) {
        if (block == null || block == "" || lot == null || lot == "" || boro == null || boro == "") {
            alert("The property info isn't complete. Please try to refresh data.");
            return;
        }
        var url = "http://a810-bisweb.nyc.gov/bisweb/PropertyProfileOverviewServlet?boro=" + boro + "&block=" + encodeURIComponent(block) + "&lot=" + encodeURIComponent(lot);
        ShowPopupMap(url, "DOB");
        $("#addition_info").html(' ');
    }
</script>
<script>
    angular.module("PortalApp").controller("CommentCtrl", function ($scope) {
        /* comments */
        $scope.showPopover = function (e) {
            aspxConstructionCommentsPopover.ShowAtElement(e.target);
        }
        $scope.addComment = function (comment) {
            var newComments = {}
            newComments.comment = comment;
            newComments.caseId = $scope.CaseId;
            newComments.createBy = Current_User;
            newComments.createDate = new Date();
            $scope.CaseData.Comments.push(newComments);
        }
        $scope.addCommentFromPopup = function () {
            var comment = $scope.addCommentTxt;
            $scope.addComment(comment);
            $scope.addCommentTxt = '';
        }
        /* end comments */
    })
</script>
<script>
    var app = angular.module("PortalApp")
    app.controller("TitleController", function ($scope, ptCom) {
        $scope.FromData = {}
        $scope.ReloadedData = {}
        $scope.Load = function (data) {
            $scope.FromData = data;
            $scope.ReloadedData = {};
        }
        $scope.Get = function () {
            return $scope.FromData;
        }
    })
</script>
