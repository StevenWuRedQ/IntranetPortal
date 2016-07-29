<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NewOfferAssignCorp.ascx.vb" Inherits="IntranetPortal.NewOfferAssignCorp" %>
<div class="view-animate" ng-show="currentStep().title=='Assign Crops'" id="preSignAssignCrops">
    <h3 class="wizard-title">Select team and Assign corp</h3>
    <div class="ss_form">
        <h4 class="ss_form_title " ng-class="{ss_warning:!SSpreSign.assignCrop.Crop}">Assign </h4>
        <div class="ss_border" id="assignBtnForm">
            {{SSpreSign.assignCrop.newOfferId}}
            <input  type="button" ng-click="SSpreSign.assignCrop.test()" value="Test"/>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item ">
                    <label class="ss_form_input_title" ng-class="{ss_warning:!SSpreSign.assignCrop.Name}" data-message="Please select team!">Team Name</label>
                    <select class="ss_form_input" ng-model="SSpreSign.assignCrop.Name" ng-disabled="SSpreSign.assignCrop.Crop" ng-change="SSpreSign.assignCrop.selectTeamChange()">
                        <option ng-repeat="n in CorpTeam track by $index">{{n}}</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title">Is wells fargo</label>
                    <pt-radio name="AssignCropWellFrago" model="SSpreSign.assignCrop.isWellsFargo" ng-disabled="SSpreSign.assignCrop.Crop"></pt-radio>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title " ng-class="{ss_warning: !SSpreSign.assignCrop.Signer}" data-message="Please select signer">signer </label>
                    <select class="ss_form_input" ng-model="SSpreSign.assignCrop.Signer" ng-disabled="SSpreSign.assignCrop.Crop">
                        <option ng-repeat="s in  SSpreSign.assignCrop.signers track by $index">{{s}}</option>
                    </select>
                </li>
                <li class="ss_form_item ">
                    <label class="ss_form_input_title">&nbsp;</label>
                    <input type="button" value="Assign Corp" class="rand-button rand-button-blue rand-button-pad" ng-click="SSpreSign.assignCrop.assginCorpClick()" ng-show="!SSpreSign.assignCrop.Crop">
                </li>
            </ul>
        </div>
        <div class="ss_form" style="display: none">
            <ul>
                <li class="ss_form_item " ng-class="{ss_warning:!SSpreSign.assignCrop.Crop}" data-message="Please assign Corp to continue!"></li>
            </ul>
        </div>
        <div class="ss_form" ng-show="SSpreSign.assignCrop.Crop">
            <div class="alert alert-success" role="alert">
                Corp: <strong>{{SSpreSign.assignCrop.Crop}}</strong> is assigned to property at, <strong>{{SSpreSign.PropertyAddress}}</strong> . <%--corp--%>
                <span ng-show="SSpreSign.assignCrop.CropData.Signer">The signer for the corp is: <strong>{{SSpreSign.assignCrop.CropData.Signer}} </strong></span>
                <br />
                <%--signer--%>
            </div>
        </div>
    </div>
</div>
