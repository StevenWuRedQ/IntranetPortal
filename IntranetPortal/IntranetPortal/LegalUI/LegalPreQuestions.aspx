<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LegalPreQuestions.aspx.vb" Inherits="IntranetPortal.LegalPreQuestions1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <asp:HiddenField runat="server" ID="hfInProcessBBLE" />
    <div ng-controller="LegalPreQuesCtrl">
        <div class="container ss_border">
            <h4 class="text-center text-uppercase text-warning">Note: All the infomation must be filled out before send to Legal Department.</h4>
            <div class="col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.WhoLivesInHome?'':'ss_warning'">Who Lives in the home now?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.WhoLivesInHome"/>
            </div>

            <div class="col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingParty?'':'ss_warning'">Who is refusing to participate in the sale?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.RefusingParty" />
            </div>

            <div class="col-md-12">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingReason?'':'ss_warning'">Why are they refusing</h4>
                <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.RefusingReason"></textarea>
            </div>

            <div class="col-md-12">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.InterestInProperty?'':'ss_warning'">What is their interest in the property?</h4>
                <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.InterestInProperty"></textarea>
            </div>

            <div class="col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.HomeCondition?'':'ss_warning'">What is the condition of the home?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.HomeCondition" />
            </div>

            <%-- place holder --%>
            <div class="col-md-6" style="visibility: hidden">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.HomeCondition?'':'ss_warning'">What is the condition of the home?</h4>
                <input class="ss_form_input" />
            </div>

            <div class="col-md-6">
                <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, do they perform any maintenance on the home?</h4>
                <pt-radio name="PreQuestions_RefusingMaintenHome" model="PreQuestions.RefusingMaintenHome"></pt-radio>
            </div>

            <div class="clearfix"></div>

            <div class="col-md-6">
                <h4 class="ss_form_input_title">Are there tenents?</h4>
                <pt-radio name="IsTenentsPreQuestions_IsTenents" model="PreQuestions.IsTenents"></pt-radio>
            </div>

            <div class="clearfix"></div>
            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.IsTenents">
                <h4 class="ss_form_input_title">Do tenents pay rent currently?</h4>
                <pt-radio name="PreQuestions_IsTenentsPayRent" model="PreQuestions.IsTenentsPayRent"></pt-radio>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.IsTenents&&PreQuestions.IsTenentsPayRent">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.TenentsPayTo?'':'ss_warning'">Who tenents pay to?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.TenentsPayTo" />
            </div>

            <div class="col-md-8">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.WhereRefusingLive?'':'ss_warning'">The party who is refusing to participate in the sale of the home, where do they live?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.WhereRefusingLive" />
            </div>
            <div class="col-md-4">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.HowLongInPremises?'':'ss_warning'">If they live in the subject premises, for how long?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.HowLongInPremises" />
            </div>

            <div class="col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingAndClientRelationship?'':'ss_warning'">The party who is refusing to participate in the sale of the home, what is their relationship to our client</h4>
                <select class="ss_form_input" ng-model="PreQuestions.RefusingAndClientRelationship">
                    <option>spouse</option>
                    <option>ex-spouse</option>
                    <option>straw-buyer</option>
                    <option>others</option>
                </select>
            </div>

            <%-- place holder --%>
            <div class="col-md-6" style="visibility: hidden">
                <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, what is their relationship to our client</h4>
                <select class="ss_form_input">
                </select>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.RefusingAndClientRelationship=='spouse'||PreQuestions.RefusingAndClientRelationship=='ex-spouse'">
                <h4 class="ss_form_input_title">Was the home originally purchased during or prior to their marriage?</h4>
                <pt-radio name="PreQuestions_IsDuringOrPriorMarriage" model="PreQuestions.IsDuringOrPriorMarriage" true-value="prior" false-value="during"></pt-radio>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.RefusingAndClientRelationship=='ex-spouse'">
                <h4 class="ss_form_input_title">Is there a divorce decree we can see</h4>
                <pt-radio name="PreQuestions_IsDivorceDecree" model="PreQuestions.IsDivorceDecree"></pt-radio>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.RefusingAndClientRelationship=='straw-buyer'">
                <h4 class="ss_form_input_title">Is there a contract?</h4>
                <pt-radio name="PreQuestions_IsContract" model="PreQuestions.IsContract"></pt-radio>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.RefusingAndClientRelationship=='straw-buyer'">
                <h4 class="ss_form_input_title">Is contract for our viewing?</h4>
                <pt-radio name="PreQuestions_IsContractViewable" model="PreQuestions.IsContractViewable"></pt-radio>
            </div>
            <div class="clearfix"></div>
            <div class="col-md-6">
                <h4 class="ss_form_input_title">Have we tried to offer refusing party money to agree to participate?</h4>
                <pt-radio name="PreQuestions_IsOfferMoney" model="PreQuestions.IsOfferMoney"></pt-radio>
            </div>
            <div class="clearfix"></div>
            <div class="col-md-6">
                <h4 class="ss_form_input_title">Is there a current foreclose on the property?</h4>
                <pt-radio name="PreQuestions_IsFC" model="PreQuestions.IsFC"></pt-radio>
            </div>

            <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.IsFC">
                <h4 class="ss_form_input_title">Is there refusing party trying to work out with the bank?</h4>
                <pt-radio name="PreQuestions_IsRefusingWorkout" model="PreQuestions.IsRefusingWorkout"></pt-radio>
            </div>

            <div class="clearfix"></div>
            <div class="col-md-4">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.NumOfUnits?'':'ss_warning'">How Many units of living space are there?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.NumOfUnits" />
            </div>
            <div class="col-md-4">
                <h4 class="ss_form_input_title">Are they legal or illegal rental spaces</h4>
                <pt-radio name="PreQuestions_IsLegal" model="PreQuestions.IsLegal"></pt-radio>
            </div>
            <div class="col-md-4">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.Occupied?'':'ss_warning'">Which are occupied?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.Occupied" />
            </div>

            <div class="clearfix"></div>
            <div class="col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.WhoPayUtilities?'':'ss_warning'">Who is paying the utilities currently?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.WhoPayUtilities" />
            </div>
            <div class="col-md-12">
                <hr />
            </div>
            <div class="clearfix"></div>
            <div class="col-md-12 text-center">
                <button type="button" class="btn btn-primary" ng-class="validate()?'':'disabled'" ng-click="save()">Assign To Legal</button>
            </div>
        </div>
    </div>

    <script>
        angular.module('PortalApp').controller('LegalPreQuesCtrl', function ($scope) {
            $scope.PreQuestions = {}
            $scope.save = function () {
                if ($scope.validate()) {
                    var url = '/LegalUI/LegalServices.svc/StartNewLegalCase';
                    var data = {
                            bble: <%= BBLE %>, 
                            casedata: JSON.stringify({PreQuestions: $scope.PreQuestions}),
                            createBy: "<%= Page.User.Identity.Name %>",
                        }
                    $.ajax({
                        type: "POST",
                        url: url,
                        data: JSON.stringify(data),
                        dataType: 'json',
                        contentType: "application/json",
                        success: function (data) {
                            alert("Assign to Legal Success!");
                            window.close();
                        },
                        error: function (data) {
                            alert("Assign to Legal failed, BBLE is " + "<%= BBLE%>");
                        }
                    });
                }
            }
            $scope.validate = function () {
                return $scope.PreQuestions.WhoLivesInHome 
                    && $scope.PreQuestions.RefusingParty
                    && $scope.PreQuestions.RefusingReason
                    && $scope.PreQuestions.InterestInProperty
                    && $scope.PreQuestions.HomeCondition
                    && (!$scope.PreQuestions.IsTenents || ($scope.PreQuestions.IsTenents && !$scope.PreQuestions.IsTenentsPayRent) || ($scope.PreQuestions.IsTenents && $scope.PreQuestions.IsTenentsPayRent && $scope.PreQuestions.TenentsPayTo))
                    && $scope.PreQuestions.WhereRefusingLive
                    && $scope.PreQuestions.RefusingAndClientRelationship
                    && $scope.PreQuestions.NumOfUnits
                    && $scope.PreQuestions.Occupied
                    && $scope.PreQuestions.WhoPayUtilities

            }

        })
    </script>
</asp:Content>
