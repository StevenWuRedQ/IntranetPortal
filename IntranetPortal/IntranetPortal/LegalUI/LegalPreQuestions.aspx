<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LegalPreQuestions.aspx.vb" Inherits="IntranetPortal.LegalPreQuestions1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">

    <div ng-controller="LegalPreQuesCtrl">
        <div class="container ss_border">
            <h4 class="text-center text-uppercase text-warning">Note: All the infomation must be filled out before send to Legal Department.</h4>
            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title text-danger" ng-class="PreQuestions.WhoLivesInHome?'':'ss_warning'">Who Lives in the home now?</h4>
                <input class="ss_form_input" name="WhoLivesInHome" ng-model="PreQuestions.WhoLivesInHome" required="this is required"/>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingParty?'':'ss_warning'">Who is refusing to participate in the sale?</h4>
                <input class="ss_form_input" no-model="PreQuestions.RefusingParty" />
            </div>

            <div class="ss_form col-md-12">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingReason?'':'ss_warning'">Why are they refusing</h4>
                <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.RefusingReason"></textarea>
            </div>

            <div class="ss_form col-md-12">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.InterestInProperty?'':'ss_warning'">What is their interest in the property?</h4>
                <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.InterestInProperty"></textarea>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.HomeCondition?'':'ss_warning'">What is the condition of the home?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.HomeCondition" />
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title" ng-class="PreQuestions.RefusingMaintenanceOnHome?'':'ss_warning'">The party who is refusing to participate in the sale of the home, do they perform any maintenance on the home?</h4>
                <pt-radio name="IsTenents" model="PreQuestions.IsTenents"></pt-radio>
            </div>


            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Are there tenents?</h4>
                <pt-radio name="IsTenents" model="PreQuestions.IsTenents"></pt-radio>
            </div>


            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title" ng-show="PreQuestions.IsTenents" >Do tenents pay rent currently?</h4>
                <pt-radio name="TenentsPayRent" model="PreQuestions.IsTenentsPayRent"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title" ng-show="PreQuestions.IsTenents" >Who tenents pay to?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.TenentsPayTo" />
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, where do they live?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.WhereRefusingLive" />
            </div>
            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, where do they live?</h4>
                <input class="ss_form_input" ng-model="PreQuestions.WhereRefusingLive" />
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, what is their relationship to our client</h4>
                <select ng-model="PreQuestions.RefusingAndClientRelationship">
                    <option>spouse</option>
                    <option>exspouse</option>
                    <option>straw-buyer</option>
                    <option>others, please specific</option>
                </select>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Was the home originally purchased during or prior to their marriage?</h4>
                <pt-radio name="IsDuringOrPriorMarriage" model="PreQuestions.IsDuringOrPriorMarriage" truevalue="prior" false="during"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Is there a divorce decree we can see</h4>
                <pt-radio name="IsDivorceDecree" model="PreQuestions.IsDivorceDecree"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Is there a contract?</h4>
                <pt-radio name="IsContract" model="PreQuestions.IsContract"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Is contract for our viewing?</h4>
                <pt-radio name="IsContractViewable" model="PreQuestions.IsContractViewable"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Have we tried to offer that person money to agree to participate?</h4>
                <pt-radio name="IsOfferMoney" model="PreQuestions.IsOfferMoney"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Is there a current foreclose on the property?</h4>
                <pt-radio name="IsFC" model="PreQuestions.IsFC"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Is there refusing party trying to work out with the bank?</h4>
                <pt-radio name="IsRefusingWorkout" model="PreQuestions.IsRefusingWorkout"></pt-radio>
            </div>

            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">How Many units of living space are there?</h4>
            </div>


            <div class="ss_form col-md-6">
                <h4 class="ss_form_input_title">Who is paying the utilities currently?</h4>
                <input class="ss_form_input" model="PreQuestions.WhoPayUtilities" />
            </div>
            <div class="col-md-12">
                <hr />
            </div>
            <div class="col-md-12 text-center">
                <button type="button" class="btn btn-primary" ng-class="validate()?'':'disabled'">Assign To Legal</button>
            </div>
        </div>
    </div>

    <script>
        angular.module('PortalApp').controller('LegalPreQuesCtrl', function ($scope) {
            $scope.PreQuestions = {};
            $scope.save = function () {

            }
            $scope.validate = function () {
                return false;
            }
            $scope.Validated = true;

        })
    </script>
</asp:Content>
