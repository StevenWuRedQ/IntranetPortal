<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleTab.ascx.vb" Inherits="IntranetPortal.TitleTab" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/TitleUI/TitleInfo.ascx" TagPrefix="uc1" TagName="TitleInfo" %>
<%@ Register Src="~/TitleUI/TitleOwnerLiens.ascx" TagPrefix="uc1" TagName="TitleOwnerLiens" %>
<%@ Register Src="~/TitleUI/TitleBuildingLiens.ascx" TagPrefix="uc1" TagName="TitleBuildingLiens" %>
<%@ Register Src="~/TitleUI/TitleSurveyAndContin.ascx" TagPrefix="uc1" TagName="TitleSurveyAndContin" %>
<%@ Register Src="~/TitleUI/TitlePreclosing.ascx" TagPrefix="uc1" TagName="TitlePreclosing" %>
<%@ Register Src="~/TitleUI/TitleFeeClearance.ascx" TagPrefix="uc1" TagName="TitleFeeClearance" %>
<%@ Register Src="~/TitleUI/TitleDocTab.ascx" TagPrefix="uc1" TagName="TitleDocTab" %>

<uc1:Common runat="server" ID="Common" Visible="false" />
<div id="titleui_and_activity">
    <div id="TitleController" ng-controller="TitleController">
        <div id="TitleUIContent" style="padding-top: 5px">
            <div id="title_prioity_content">
                <div style="height: 80px" class="font_gray">
                    <div class="col-md-1" style="margin: 10px 0; font-size: 30px">
                         <i class="fa fa-home"></i>
                    </div>
                    <div class="col-md-9" style="margin: 0px 0; font-size: 30px">                       
                        <div>
                            <div ng-bind="Form.FormData.CaseName" style="white-space: nowrap; overflow: hidden"></div>
                            <span ng-show="Form.BusinessData.TitleCategory" style="color: red; font-weight:600; font-size:20px">({{Form.BusinessData.TitleCategory}} in ShortSale)</span>
                        </div>
                    </div>
                    <div class="col-md-2 pull-right" style="margin: 10px 0">
                        <div>
                            <span class="btn btn-default btn-round" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+ leadsInfoBBLE, 'Maps')">Map</span>
                        </div>
                        <div style="margin-top: 5px">
                            <%-- now using ascx control instead --%>
                            <span class="btn btn-default btn-circle icon_btn" popover-placement="left" uib-popover-template="'titlechangestatus'" uib-tooltip="Update Case Status" popover-is-open="ChangeStatusIsOpen"><i class="fa fa-exchange"></i></span>
                            <span class="btn btn-default btn-circle icon_btn" ng-click="generateXML()" uib-tooltip="Generate XML"><i class="fa fa-download"></i></span>
                        </div>
                    </div>
                </div>
            </div>

            <script type="text/ng-template" id="titlechangestatus">
                    <div style="width: 240px">
                        <h5><b>Change Case Status To:</b></h5>
                        <hr style="margin: 0">
                        <span ng-repeat="x in StatusList">
                            <input type="radio" style="display: inline-block" name="titlestatus" ng-model="$parent.$parent.CaseStatus" ng-value="x.num"></input>&nbsp;<h5 style="display:inline-block">{{x.desc}}</h5>
                        </span>
                        <br>
                        <button type="button" class="btn btn-primary btn-sm" ng-click="updateCaseStatus()">Change</button>
                    </div>
            </script>

            <div class="comment-panel" ng-controller="TitleCommentCtrl" style="margin: 10px; border-top: 1px solid #c8c8c8">
                <%--note list--%>
                <div style="width: 100%; overflow: auto; max-height: 160px;">
                    <table class="table table-striped" style="font-size: 14px; margin: 0; padding: 5px">
                        <tr ng-repeat="comment in Form.FormData.Comments">
                            <td>
                                <i class="fa fa-exclamation-circle" style="font-size: 18px"></i>
                                <span style="margin-left: 10px">{{comment.comment}}</span>
                                <span class="pull-right">
                                    <i class="fa fa-times icon_btn text-danger" style="font-size: 18px" ng-click="arrayRemove(Form.FormData.Comments, $index, true);"></i>
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
                                                <input type="button" value="Add" ng-click="addCommentFromPopup('<%= HttpContext.Current.User.Identity.Name %>')" class="rand-button" style="background-color: #3993c1" />
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

            <div class="shortSaleUI">
                <ul class="nav nav-tabs overview_tabs" role="tablist">

                    <li style="font-size: 12px" class="short_sale_tab active">
                        <a class="shot_sale_tab_a" href="#TitleInfoTab" role="tab" data-toggle="tab">Info</a>
                    </li>
                    <li style="font-size: 12px" class="short_sale_tab">
                        <a class="shot_sale_tab_a" href="#TitleOwnerLiensTab" role="tab" data-toggle="tab">Owner Liens</a>
                    </li>
                    <li style="font-size: 12px" class="short_sale_tab">
                        <a class="shot_sale_tab_a" href="#TitleBuildingLiensTab" role="tab" data-toggle="tab">Building Liens</a>
                    </li>
                    <li style="font-size: 12px" class="short_sale_tab">
                        <a class="shot_sale_tab_a" href="#TitleSurveyAndContinTab" role="tab" data-toggle="tab">Surveys And Contins</a>
                    </li>
                    <li style="font-size: 12px" class="short_sale_tab ">
                        <a class="shot_sale_tab_a" href="#TitleFeeClearanceTab" role="tab" data-toggle="tab">Fee Breakdown</a>
                    </li>
                    <li role="presentation" style="font-size: 12px" class="short_sale_tab dropdown">
                        <a class="dropdown-toggle shot_sale_tab_a" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">More <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li class=""><a class="" href="#TitlePreclosingTab" role="tab" data-toggle="tab">Preclosing Docs</a></li>
                            <li class=""><a class="" href="#TitleDocsTab" role="tab" data-toggle="tab">Title Docs</a></li>
                        </ul>
                    </li>
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
                            <uc1:TitleSurveyAndContin runat="server" ID="TitleSurveyAndContin" />
                        </div>
                        <div class="tab-pane" id="TitleFeeClearanceTab">
                            <uc1:TitleFeeClearance runat="server" ID="TitleFeeClearance" />
                        </div>
                        <div class="tab-pane" id="TitlePreclosingTab">
                            <uc1:TitlePreclosing runat="server" ID="TitlePreclosing" />
                        </div>
                        <div class="tab-pane" id="TitleDocsTab">
                            <uc1:TitleDocTab runat="server" ID="TitleDocTab" />
                        </div>
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

    var TitleControlReadOnly = <%= ControlReadonly %>;
</script>
