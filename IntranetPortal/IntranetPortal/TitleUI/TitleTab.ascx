<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleTab.ascx.vb" Inherits="IntranetPortal.TitleTab" %>
<%@ Register Src="~/UserControl/Common.ascx" TagPrefix="uc1" TagName="Common" %>
<%@ Register Src="~/TitleUI/TitleInfo.ascx" TagPrefix="uc1" TagName="TitleInfo" %>
<%@ Register Src="~/TitleUI/TitleOwnerLiens.ascx" TagPrefix="uc1" TagName="TitleOwnerLiens" %>
<%@ Register Src="~/TitleUI/TitleBuildingLiens.ascx" TagPrefix="uc1" TagName="TitleBuildingLiens" %>
<%@ Register Src="~/TitleUI/TitleSurveyAndContin.ascx" TagPrefix="uc1" TagName="TitleSurveyAndContin" %>
<%@ Register Src="~/TitleUI/TitlePreclosing.ascx" TagPrefix="uc1" TagName="TitlePreclosing" %>
<%@ Register Src="~/TitleUI/TitleFeeClearance.ascx" TagPrefix="uc1" TagName="TitleFeeClearance" %>

<uc1:Common runat="server" ID="Common" Visible="false" />
<div id="titleui_and_activity">
    <div id="TitleController" ng-controller="TitleController" style="max-height: 850px; overflow: auto">
        <div id="TitleUIContent" style="padding-top: 5px">
            <div id="title_prioity_content">
                <div style="margin-left: 30px; height: 80px" class="font_gray">
                    <div class="col-md-10" style="margin: 10px 0; font-size: 30px">
                        <i class="fa fa-home"></i>&nbsp;  
                        <span ng-bind="Form.FormData.CaseName"></span>
                    </div>
                    <div class="col-md-2 pull-right" style="margin: 10px 0">
                        <div>
                            <span class="btn btn-default btn-round" onclick="OpenLeadsWindow('/PopupControl/PropertyMap.aspx?v=0&bble='+ leadsInfoBBLE, 'Maps')">Map</span>
                        </div>
                        <div style="margin-top: 5px">
                            <%-- now using ascx control instead --%>
                            <span class="btn btn-default btn-circle icon_btn" popover-placement="right" uib-popover-template="'titlechangestatus'" uib-tooltip="Update Case Status" popover-is-open="ChangeStatusIsOpen"><i class="fa fa-exchange"></i></span>
                            <span class="btn btn-default btn-circle icon_btn" ng-click="generateXML()" uib-tooltip="Generate XML"><i class="fa fa-download"></i></span>
                        </div>
                    </div>
                </div>
            </div>
            <script type="text/ng-template" id="titlechangestatus">
                    <div style="width: 240px">
                        <h4 class="Text-Info">Change Case Status To:</h3>
                        <hr>
                        <span ng-repeat="x in StatusList">
                            <input type="radio" style="display: inline-block" name="titlestatus" ng-model="$parent.$parent.CaseStatus" ng-value="x.num"></input>&nbsp;{{x.desc}}
                            <br>
                        </span>
                        <br>
                        <button type="button" class="btn btn-primary" ng-click="updateCaseStatus()">Change</button>
                    </div>
            </script>
            <div class="comment-panel" ng-controller="CommentCtrl" style="margin: 10px; border-top: 1px solid #c8c8c8">
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
                    <li style="font-size: 12px" class="short_sale_tab ">
                        <a class="shot_sale_tab_a" href="#TitlePreclosingTab" role="tab" data-toggle="tab">Preclosing Docs</a>
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
    angular.module("PortalApp").controller("CommentCtrl", function ($scope, $timeout) {
        $scope.showPopover = function (e) {
            aspxConstructionCommentsPopover.ShowAtElement(e.target);
        };
        $scope.addComment = function (comment) {
            var newComments = {};
            newComments.comment = comment;
            newComments.caseId = $scope.CaseId;
            newComments.createBy = '<%= Page.User.Identity.ToString %>';
            newComments.createDate = new Date();
            $scope.Form.FormData.Comments.push(newComments);
        };
        $scope.addCommentFromPopup = function () {
            var comment = $scope.addCommentTxt;
            $scope.addComment(comment);
            $scope.addCommentTxt = '';
        };
        $scope.$on('titleComment', function(e, args){
            $scope.addComment(args.message);
        }); /* end comments */
    })
</script>
<script>
    angular.module("PortalApp").controller("TitleController", function ($scope, $timeout,$http, ptCom, ptContactServices, ptLeadsService, ptShortsSaleService) {
        /* model define*/
        $scope.OwnerModel = function (name){
            this.name=name;
            this.Mortgages= [{}];                   
            this.Lis_Pendens= [{}];
            this.Judgements= [{}];
            this.ECB_Notes= [{}];
            this.PVB_Notes= [{}];
            this.Bankruptcy_Notes= [{}];
            this.UCCs= [{}];
            this.FederalTaxLiens= [{}];
            this.MechanicsLiens= [{}];
            this.TaxLiensSaleCerts = [{}];
            this.VacateRelocationLiens = [{}];
            this.shownlist = [false,false,false,false,false,false,false,false,false,false,false];
        };
        $scope.FormModel = function(){
            this.FormData =  {
                Comments: [],
                Owners: [new $scope.OwnerModel("Prior Owner Liens"), new $scope.OwnerModel("Current Owner Liens")],
                preclosing: {
                    ApprovalData: [{}]
                }
            };
        }; 
        $scope.ReloadDataModel = function() {

        }


        $scope.StatusList = [
            {
                num: 0,
                desc: 'Initial Review'
            },{
                num: 1,
                desc: 'Clearance'
            }
        ];
        $scope.arrayRemove = ptCom.arrayRemove;
        $scope.ptCom = ptCom;
        $scope.ptContactServices = ptContactServices;
        $scope.ensurePush = function (modelName, data) { ptCom.ensurePush($scope, modelName, data); };
        $scope.Form = new $scope.FormModel();
        $scope.ReloadedData = new $scope.ReloadDataModel();

        $scope.Load = function (data) {
            $scope.Form = new $scope.FormModel();
            $scope.ReloadedData = new $scope.ReloadDataModel();
            ptCom.nullToUndefined(data);
            $.extend(true, $scope.Form, data);
            if(!$scope.Form.FormData.Owners[0].shownlist){
                $scope.Form.FormData.Owners[0].shownlist = [false,false,false,false,false,false,false,false,false, false, false];
                $scope.Form.FormData.Owners[1].shownlist = [false,false,false,false,false,false,false,false,false, false, false];
            }
            $scope.BBLE = data.Tag;
            if($scope.BBLE){
                ptLeadsService.getLeadsByBBLE($scope.BBLE, function (res) {
                    $scope.LeadsInfo = res;
                });
                ptShortsSaleService.getBuyerTitle($scope.BBLE, function (error, res) {
                    if(error) console.log(error);
                    if(res) $scope.BuyerTitle = res.data;
                });
                $scope.getStatus($scope.BBLE);
            }
            $scope.$broadcast('ownerliens-reload');
            $scope.$broadcast('clearance-reload');

            $scope.checkReadOnly();
            $scope.$apply();
        };
        $scope.Get = function (isSave) {
            if(isSave){
                $scope.updateBuyerTitle();
            }            
            return $scope.Form;
        }; /* end convention function */

        $scope.checkReadOnly = function () {
            var ro = <%= ControlReadonly %>;
            if (ro) {
                $("#TitleUIContent input").attr("disabled", true);
                if ($("#TitleROBanner").length == 0) {
                    $("#title_prioity_content").before("<div class='barner-warning text-center' id='TitleROBanner' >Readonly</div>");
                }
                
            }
        };
        $scope.completeCase = function(){
            if($scope.CaseStatus!=1 && $scope.BBLE){
                ptCom.confirm("You are going to complated the case?", "")
                    .then(function(r){
                        if (r){                        
                            $http({
                                method: 'POST',
                                url: '/api/Title/Completed',                    
                                data: JSON.stringify($scope.BBLE)
                            }).then(function success(){
                                $scope.CaseStatus = 1;
                                $scope.Form.FormData.CompletedDate = new Date();
                                ptCom.alert("The case have moved to Completed");
                            }, function error(){});
                        }
                    });
            }else if($scope.BBLE) {
                ptCom.confirm("You are going to uncomplated the case?", "")
                    .then(function(r){
                        if (r){                        
                            $http({
                                method: 'POST',
                                url: '/api/Title/UnCompleted',                    
                                data: JSON.stringify($scope.BBLE)
                            }).then(function success(){
                                $scope.CaseStatus = -1;
                                ptCom.alert("Uncomplete case successful");
                            }, function error(){});
                        }
                    });
            }
        };
        $scope.updateCaseStatus = function(){
            if($scope.CaseStatus && $scope.BBLE){
                $scope.ChangeStatusIsOpen = false;
                ptCom.confirm("You are going to change case status?", "")
                   .then(function(r){
                       if (r){                        
                           $http({
                               method: 'POST',
                               url: '/api/Title/UpdateStatus?bble=' + $scope.BBLE,                    
                               data: JSON.stringify($scope.CaseStatus)
                           }).then(function success(){
                               ptCom.alert("The case status has changed!");
                           }, function error(){});
                       }
                   });
            }
        };
        $scope.getStatus = function(bble){
            $http.get('/api/Title/GetCaseStatus?bble='+ bble)
            .then(function succ(res){
                $scope.CaseStatus = res.data;
                },function error(){
                $scope.CaseStatus = -1;
                console.log("get status error");
                });
        };
        $scope.generateXML = function(){
            $http({
                url: "/api/Title/GenerateExcel",
                method: "POST",
                data: JSON.stringify($scope.Form)
            }).then(function(res){
                STDownloadFile("/api/ConstructionCases/GetGeneratedExcel", "titlereport.xlsx");
            });
        };
        $scope.updateBuyerTitle = function(){
            var updateFlag = false;
            var data = $scope.BuyerTitle;
            var newdata = $scope.Form.FormData.info;
            if(data && newdata){        

                if(newdata.Company != data.CompanyName){
                    data.CompanyName = newdata.Company;
                    updateFlag = true;
                }

                if(newdata.Title_Num != data.OrderNumber){
                    data.OrderNumber = newdata.Title_Num;
                    updateFlag = true;
                }

                if(ptCom.toUTCLocaleDateString(newdata.Order_Date) != ptCom.toUTCLocaleDateString(data.ReportOrderDate)){
                    updateFlag = true;
                }
                data.ReportOrderDate = newdata.Order_Date;

                if(ptCom.toUTCLocaleDateString(newdata.Confirmation_Date) != ptCom.toUTCLocaleDateString(data.ConfirmationDate)){
                    updateFlag = true;
                }
                data.ConfirmationDate = newdata.Confirmation_Date;
        
                if(ptCom.toUTCLocaleDateString(newdata.Received_Date) != ptCom.toUTCLocaleDateString(data.ReceivedDate)){
                    updateFlag = true;
                }
                data.ReceivedDate = newdata.Received_Date;

                if(ptCom.toUTCLocaleDateString(newdata.Initial_Reivew_Date) != ptCom.toUTCLocaleDateString(data.ReviewedDate)){
                    updateFlag = true;
                }
                data.ReviewedDate = newdata.Initial_Reivew_Date;

                if(updateFlag){
                    $http({
                        url: "/api/ShortSale/UpdateBuyerTitle",
                        method: 'POST',
                        data: JSON.stringify(data)
                    }).then(function succ(res){
                        if(!res)console.log("fail to update buyertitle");
                    }
                    ,function error(){
                        console.log("fail to update buyertitle");
                        });
                }
            }
        };
    })
</script>
