<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Content.Master" CodeBehind="LegalPreQuestions.aspx.vb" Inherits="IntranetPortal.LegalPreQuestions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPH" runat="server">
    <asp:HiddenField runat="server" ID="hfInProcessBBLE" />
    <div id="LegalPreQuesCtrl" ng-controller="LegalPreQuesCtrl" style="margin: 20px">
        <div class="container ss_border">
            <h4 class="text-center text-uppercase text-warning">Note: All the infomation must be filled out before send to Legal Department.</h4>
            <div class="col-md-12" style="margin: 20px 2px">
                <h4 class="ss_form_input_title" ng-class="reviewChecked()?'':'ss_warning'">Please check the Legal review(s) you need:</h4>

                <input type="checkbox" id="FCReview" ng-model="PreQuestions.IsFCReview" class="ss_form_input">
                <label for="FCReview" class="input_with_check"><span class="box_text">FC Review&nbsp</span></label>

                <input type="checkbox" id="PartitionReview" ng-model="PreQuestions.IsPartitionReview" class="ss_form_input">
                <label for="PartitionReview" class="input_with_check"><span class="box_text">Partition Review&nbsp</span></label>


                <input type="checkbox" id="DeedReversionReview" ng-model="PreQuestions.IsDeedReversionReview" class="ss_form_input">
                <label for="DeedReversionReview" class="input_with_check"><span class="box_text">Deed Reversion Review&nbsp</span></label>


                <input type="checkbox" id="QuietTitleReview" ng-model="PreQuestions.IsQuietTitleReview" class="ss_form_input">
                <label for="QuietTitleReview" class="input_with_check"><span class="box_text">Quiet Title Review&nbsp</span></label>


                <input type="checkbox" id="SpecificPerformanceReview" ng-model="PreQuestions.IsSpecificReview" class="ss_form_input">
                <label for="SpecificPerformanceReview" class="input_with_check"><span class="box_text">Specific Performance Review&nbsp</span></label>

            </div>
            <br />
            <%--  partition --%>
            <div class="nga-fast nga-fade" ng-show="PreQuestions.IsPartitionReview" style="margin: 20px">
                <h4 class="ss_form_title ">Partition Review</h4>
                <div class="ss_border">
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.WhoLivesInHome?'':'ss_warning'">Who Lives in the home now?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.WhoLivesInHome" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.RefusingParty?'':'ss_warning'">Who is refusing to participate in the sale?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.RefusingParty" />
                    </div>
                    <div class="col-md-12">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.RefusingReason?'':'ss_warning'">Why are they refusing</h4>
                        <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.PartitionReview.RefusingReason"></textarea>
                    </div>
                    <div class="col-md-12">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.InterestInProperty?'':'ss_warning'">What is their interest in the property?</h4>
                        <textarea style="margin-top: 10px; resize: none; width: 80%; height: 120px" ng-model="PreQuestions.PartitionReview.InterestInProperty"></textarea>
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.HomeCondition?'':'ss_warning'">What is the condition of the home?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.HomeCondition" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">The party who is refusing to participate in the sale of the home, do they perform any maintenance on the home?</h4>
                        <pt-radio name="PartitionReview_RefusingMaintenHome" model="PreQuestions.PartitionReview.RefusingMaintenHome"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Are there tenents?</h4>
                        <pt-radio name="PreQuestions_IsTenents" model="PreQuestions.IsTenents"></pt-radio>
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
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.WhereRefusingLive?'':'ss_warning'">The party who is refusing to participate in the sale of the home, where do they live?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.WhereRefusingLive" />
                    </div>
                    <div class="col-md-4">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.HowLongInPremises?'':'ss_warning'">If they live in the subject premises, for how long?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.HowLongInPremises" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.RefusingAndClientRelationship?'':'ss_warning'">The party who is refusing to participate in the sale of the home, what is their relationship to our client</h4>
                        <select class="ss_form_input" ng-model="PreQuestions.PartitionReview.RefusingAndClientRelationship">
                            <option>spouse</option>
                            <option>ex-spouse</option>
                            <option>straw-buyer</option>
                            <option>others</option>
                        </select>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.PartitionReview.RefusingAndClientRelationship=='spouse'||PreQuestions.PartitionReview.RefusingAndClientRelationship=='ex-spouse'">
                        <h4 class="ss_form_input_title">Was the home originally purchased during or prior to their marriage?</h4>
                        <pt-radio name="PartitionReview_IsDuringOrPriorMarriage" model="PreQuestions.PartitionReview.IsDuringOrPriorMarriage" true-value="prior" false-value="during"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.PartitionReview.RefusingAndClientRelationship=='ex-spouse'">
                        <h4 class="ss_form_input_title">Is there a divorce decree we can see</h4>
                        <pt-radio name="PartitionReview_IsDivorceDecree" model="PreQuestions.PartitionReview.IsDivorceDecree"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.PartitionReview.RefusingAndClientRelationship=='straw-buyer'">
                        <h4 class="ss_form_input_title">Is there a contract?</h4>
                        <pt-radio name="PartitionReview_IsContract" model="PreQuestions.PartitionReview.IsContract"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.PartitionReview.RefusingAndClientRelationship=='straw-buyer'">
                        <h4 class="ss_form_input_title">Is contract for our viewing?</h4>
                        <pt-radio name="PartitionReview_IsContractViewable" model="PreQuestions.PartitionReview.IsContractViewable"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Have we tried to offer refusing party money to agree to participate?</h4>
                        <pt-radio name="PartitionReview_IsOfferMoney" model="PreQuestions.PartitionReview.IsOfferMoney"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Is there a current foreclose on the property?</h4>
                        <pt-radio name="PartitionReview_IsFC" model="PreQuestions.PartitionReview.IsFC"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.PartitionReview.IsFC">
                        <h4 class="ss_form_input_title">Is there refusing party trying to work out with the bank?</h4>
                        <pt-radio name="PartitionReview_IsRefusingWorkout" model="PreQuestions.PartitionReview.IsRefusingWorkout"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-4">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.NumOfUnits?'':'ss_warning'">How Many units of living space are there?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.NumOfUnits" />
                    </div>
                    <div class="col-md-4">
                        <h4 class="ss_form_input_title">Are they legal or illegal rental spaces</h4>
                        <pt-radio name="PartitionReview_IsLegal" model="PreQuestions.PartitionReview.IsLegal"></pt-radio>
                    </div>
                    <div class="col-md-4">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.Occupied?'':'ss_warning'">Which are occupied?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.Occupied" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.PartitionReview.WhoPayUtilities?'':'ss_warning'">Who is paying the utilities currently?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.PartitionReview.WhoPayUtilities" />
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
            <%--  deed --%>
            <div class="nga-fast nga-fade" ng-show="PreQuestions.IsDeedReversionReview" style="margin: 20px">
                <h4 class="ss_form_title">Deed Reversion Review</h4>
                <div class="ss_border">
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.DeedReversionReview.CooperationWeHave?'':'ss_warning'">Whose cooperation do we have?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.CooperationWeHave" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Was the deed transferred knowingly?</h4>
                        <pt-radio name="DeedReversionReview_WasDeedTransferred" model="PreQuestions.DeedReversionReview.WasDeedTransferred"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.DeedReversionReview.RelationshipClientAndHolder?'':'ss_warning'">What is the relationship between our client and the current deed holder?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.RelationshipClientAndHolder" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.WhoLivesIn?'':'ss_warning'">Who currently lives in the home?
                        </h4>
                        <input class="ss_form_input" ng-model="PreQuestions.WhoLivesIn" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Are there tenents?</h4>
                        <pt-radio name="PreQuestions_IsTenents" model="PreQuestions.IsTenents"></pt-radio>
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
                    <div class="clearfix"></div>

                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.DeedReversionReview.WhoMaintainProperty?'':'ss_warning'">Who is maintaining the property?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.WhoMaintainProperty" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Has the current deed holder made any improvements?</h4>
                        <pt-radio name="DeedReversionReview_HasHolderMadeImprovment" model="PreQuestions.DeedReversionReview.HasHolderMadeImprovment"></pt-radio>
                    </div>
                    <div class="clear-fix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.DeedReversionReview.DeedHolderPay?'':'ss_warning'">How much did the current deed holder pay for the deed?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.DeedHolderPay" money-mask />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Was there an attorney present at the signing of the deed?</h4>
                        <pt-radio name="DeedReversionReview_WasAttorneyPresent" model="PreQuestions.DeedReversionReview.WasAttorneyPresent"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.DeedReversionReview.WasAttorneyPresent">
                        <h4 class="ss_form_input_title " ng-class="PreQuestions.DeedReversionReview.AttorneyPresent?'':'ss_warning'">Who was the attorney?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.AttorneyPresent" />
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.DeedReversionReview.WasAttorneyPresent">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.DeedReversionReview.RelationshipAttorneyAndHolder?'':'ss_warning'">What is this attorney’s relationship with the current deed holder?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.DeedReversionReview.RelationshipAttorneyAndHolder" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Was there an attorney present at the signing off the deed?</h4>
                        <pt-radio name="DeedReversionReview_WasAttorneySignOffDeed" model="PreQuestions.DeedReversionReview.WasAttorneySignOffDeed"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                </div>
            </div>
            .
            <%-- quiet --%>
            <div class="nga-fast nga-fade" ng-show="PreQuestions.IsQuietTitleReview" style="margin: 20px">
                <h4 class="ss_form_title ">Quiet Title Review</h4>
                <div class="ss_border">
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.QuietTitleReview.LastPaymentMade?'':'ss_warning'">When was the last payment made</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.QuietTitleReview.LastPaymentMade" ss-date />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.QuietTitleReview.AnotherMortgage?'':'ss_warning'">If there is another mortgage that is delinquent or being paid? (specify)</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.QuietTitleReview.AnotherMortgage" />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.QuietTitleReview.ConditionOfProperty?'':'ss_warning'">What is the condition of the property?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.QuietTitleReview.ConditionOfProperty" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Do we have a signed deed into one of our corps? </h4>
                        <pt-radio name="QuietTitleReview_IsSignedDeed" model="PreQuestions.QuietTitleReview.IsSignedDeed"></pt-radio>
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Can we record said deed?</h4>
                        <pt-radio name="QuietTitleReview_RecordSaidDeed" model="PreQuestions.QuietTitleReview.RecordSaidDeed"></pt-radio>
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Is the client willing to sign a quiet title agreement?</h4>
                        <pt-radio name="QuietTitleReview_SignQuietTitle" model="PreQuestions.QuietTitleReview.SignQuietTitle"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.WhoLivesInHome?'':'ss_warning'">Who Lives in the home now?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.WhoLivesInHome" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Are there tenents?</h4>
                        <pt-radio name="PreQuestions_IsTenents" model="PreQuestions.IsTenents"></pt-radio>
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

                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Has our client applied for a loan modification before?</h4>
                        <pt-radio name="QuietTitleReview_ClientAppliedLoanBefore" model="PreQuestions.QuietTitleReview.ClientAppliedLoanBefore"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Has our client received correspondence in the mail from the servicer?</h4>
                        <pt-radio name="QuietTitleReview_ClientRecievedCorrespondence" model="PreQuestions.QuietTitleReview.ClientRecievedCorrespondence"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.QuietTitleReview.ClientRecievedCorrespondence">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.QuietTitleReview.ClientRecievedCorrespondenceDetail?'':'ss_warning'">Details</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.QuietTitleReview.ClientRecievedCorrespondenceDetail" />
                    </div>
                    <div class="clearfix"></div>
                </div>

            </div>
            <%-- specific --%>
            <div class="nga-fast nga-fade" ng-show="PreQuestions.IsSpecificReview" style="margin: 20px">
                <h4 class="ss_form_title">Specific Performance Review</h4>
                <div class="ss_border">
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Did we get shortsale approval?</h4>
                        <pt-radio name="SpecificReview_ShortSaleApproval" model="PreQuestions.SpecificReview.ShortSaleApproval"></pt-radio>
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.SpecificReview.HowWeAwareBreached?'':'ss_warning'">How did we become aware that our client breached contract?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.SpecificReview.HowWeAwareBreached" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.SpecificReview.PayInAdvance?'':'ss_warning'">How much money did we pay in advance?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.SpecificReview.PayInAdvance" money-mask />
                    </div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Do we have a copy of said check?</h4>
                        <pt-radio name="SpecificReview_haveSaidCheck" model="PreQuestions.SpecificReview.haveSaidCheck"></pt-radio>
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.SpecificReview.CorpPaidCheckout?'':'ss_warning'">Which corp paid the check out?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.SpecificReview.CorpPaidCheckout" />
                    </div>
                    <div class="clearfix"></div>
                    <div class="col-md-6">
                        <h4 class="ss_form_input_title">Did we make any efforts to get the client back on board</h4>
                        <pt-radio name="SpecificReview_EffortGetClientBack" model="PreQuestions.SpecificReview.EffortGetClientBack"></pt-radio>
                    </div>
                    <div class="col-md-6 nga-fast nga-slide-left" ng-show="PreQuestions.SpecificReview.EffortGetClientBack">
                        <h4 class="ss_form_input_title" ng-class="PreQuestions.SpecificReview.EffortDetail?'':'ss_warning'">What is the effort?</h4>
                        <input class="ss_form_input" ng-model="PreQuestions.SpecificReview.EffortDetail" />
                    </div>


                    <div class="clearfix"></div>
                </div>
            </div>
            <% If Not IsReview Then %>
            <div class="col-md-12 text-center" style="margin: 10px 2px">
                <hr />
                <button type="button" class="btn btn-primary" ng-class="validate()?'':'disabled'" ng-click="save()">Assign To Legal</button>
            </div>
            <% Else %>
            <div class="col-md-12 text-center" style="margin: 10px 2px">
                <hr />
                <button type="button" class="btn btn-primary" onclick="window.close()">Close</button>
            </div>
            <% End If %>
        </div>
    </div>
    <script>
        $(document).ready(function () {
            var isReview = '<%= IsReview %>' === 'True'? true: false;
            var scope = angular.element($('#LegalPreQuesCtrl')[0]).scope();
            if(isReview) scope.load();
        })
        angular.module('PortalApp').controller('LegalPreQuesCtrl', function ($scope, ptLegalService) {
            $scope.PreQuestions = {
                PartitionReview: {},
                DeedReversionReview: {},
                QuietTitleReview: {},
                SpecificReview: {}            
            }
            
            $scope.save = function (){
                ptLegalService.savePreQuestions(<%= BBLE %> , '<%= Page.User.Identity.Name %>', $scope.PreQuestions, function(error, data){
                    if(error) console.log("Assign to Legal failed, BBLE is <%= BBLE %>");
                    else{
                        alert("Assign to Legal Success!");
                        window.close();
                    }
                })
            }
            
            $scope.load = function (){
                ptLegalService.load(<%= BBLE %>, function(error, data){
                    if(error) console.log(error)
                    else{
                        var data = data.d;
                        $scope.$apply(function(){
                            _.extend($scope.PreQuestions, JSON.parse(data).PreQuestions)                        
                        })
                        
                    }
                })
            }

            $scope.validate = function(){
                return $scope.reviewChecked()
                    && (!$scope.PreQuestions.IsTenents || ($scope.PreQuestions.IsTenents && !$scope.PreQuestions.IsTenentsPayRent) || ($scope.PreQuestions.IsTenents && $scope.PreQuestions.IsTenentsPayRent && $scope.PreQuestions.TenentsPayTo))
                    && (!$scope.PreQuestions.IsPartitionReview || ($scope.PreQuestions.IsPartitionReview && $scope.validatePartitionReview()))
                    && (!$scope.PreQuestions.IsDeedReversionReview || ($scope.PreQuestions.IsDeedReversionReview && $scope.validateDeed()))
                    && (!$scope.PreQuestions.IsQuietTitleReview || ($scope.PreQuestions.IsQuietTitleReview && $scope.validateQuietTitle()))
                    && (!$scope.PreQuestions.IsSpecificReview || ($scope.PreQuestions.IsSpecificReview && $scope.validateSpecific()))
            }

            $scope.validatePartitionReview = function () {
                return $scope.PreQuestions.WhoLivesInHome 
                    && $scope.PreQuestions.PartitionReview.RefusingParty
                    && $scope.PreQuestions.PartitionReview.RefusingReason
                    && $scope.PreQuestions.PartitionReview.InterestInProperty
                    && $scope.PreQuestions.PartitionReview.HomeCondition
                    && $scope.PreQuestions.PartitionReview.WhereRefusingLive
                    && $scope.PreQuestions.PartitionReview.RefusingAndClientRelationship
                    && $scope.PreQuestions.PartitionReview.NumOfUnits
                    && $scope.PreQuestions.PartitionReview.Occupied
                    && $scope.PreQuestions.PartitionReview.WhoPayUtilities;
            }
            $scope.validateDeed = function(){
                return $scope.PreQuestions.DeedReversionReview.CooperationWeHave
                && $scope.PreQuestions.DeedReversionReview.RelationshipClientAndHolder
                && $scope.PreQuestions.WhoLivesIn
                && $scope.PreQuestions.DeedReversionReview.WhoMaintainProperty
                && $scope.PreQuestions.DeedReversionReview.DeedHolderPay
                && (!$scope.PreQuestions.DeedReversionReview.WasAttorneyPresent || ($scope.PreQuestions.DeedReversionReview.WasAttorneyPresent && $scope.PreQuestions.DeedReversionReview.AttorneyPresent && $scope.PreQuestions.DeedReversionReview.RelationshipAttorneyAndHolder))

            }
            $scope.validateQuietTitle = function (){
                return $scope.PreQuestions.QuietTitleReview.LastPaymentMade
                && $scope.PreQuestions.QuietTitleReview.AnotherMortgage
                && $scope.PreQuestions.QuietTitleReview.ConditionOfProperty
                && $scope.PreQuestions.WhoLivesInHome
                && $scope.PreQuestions.QuietTitleReview.ClientRecievedCorrespondenceDetail            
            }
            $scope.validateSpecific = function(){
                return $scope.PreQuestions.SpecificReview.HowWeAwareBreached
                && $scope.PreQuestions.SpecificReview.PayInAdvance
                && $scope.PreQuestions.SpecificReview.CorpPaidCheckout
                && (!$scope.PreQuestions.SpecificReview.EffortGetClientBack || ($scope.PreQuestions.SpecificReview.EffortGetClientBack && $scope.PreQuestions.SpecificReview.EffortDetail))
            
            }

            $scope.reviewChecked = function(){
                return $scope.PreQuestions.IsFCReview||$scope.PreQuestions.IsPartitionReview|| $scope.PreQuestions.IsDeedReversionReview|| $scope.PreQuestions.IsQuietTitleReview|| $scope.PreQuestions.IsSpecificReview;
            }
        })
    </script>
</asp:Content>
