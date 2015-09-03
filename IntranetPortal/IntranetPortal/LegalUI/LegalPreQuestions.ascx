<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalPreQuestions.ascx.vb" Inherits="IntranetPortal.LegalPreQuestions" %>

<form>
    <div class="row">
        <h4>Who Lives in the home now?</h4>
        <input ng-model="LegalCase.PreQuestions.WhoLivesInHome"/>

        <h4>Who is refusing to participate in the sale?</h4>
        <input no-model="LegalCase.PreQuestions.RefusingParty" />

        <h4>Why are they refusing</h4>
        <textarea ng-model="LegalCase.PreQuestions.RefusingReason" ></textarea>

        <h4>What is their interest in the property?</h4>
        <input ng-model="LegalCase.PreQuestions.InterestInProperty" />

        <h4>What is the condition of the home?</h4>
        <input ng-model="LegalCase.PreQuestions.HomeCondition" />

        <h4>The party who is refusing to participate in the sale of the home, do they perform any maintenance on the home?</h4>
        <textarea ng-model="LegalCase.PreQuestions.RefusingMaintenanceOnHome"></textarea>

        <h4>Are there tenent?</h4>
        <pt-radio name="IsTenents" model="LegalCase.PreQuestions.IsTenents"></pt-radio>

        <h4>Do tenents pay rent currently?</h4>
        <pt-radio name="TenentsPayRent" model="LegalCase.PreQuestions.IsTenentsPayRent"></pt-radio>

        <h4>Who tenents pay to?</h4>
        <input ng-model="LegalCase.PreQuestions.TenentsPayTo" />

        <h4>The party who is refusing to participate in the sale of the home, where do they live?</h4>
        <input ng-model="LegalCase.PreQuestions.WhereRefusingLive" />

        <h4>The party who is refusing to participate in the sale of the home, what is their relationship to our client</h4>
        <input ng-model="LegalCase.PreQuestions.RefusingAndClientRelationship" />
        <select>
            <option>spouse</option>
            <option>exspouse</option>
            <option>straw-buyer</option>
            <option>others, please specific</option>
        </select>

        <h4>Was the home originally purchased during or prior to their marriage?</h4>
        <pt-radio name="IsDuringOrPriorMarriage" model="LegalCase.PreQuestions.IsDuringOrPriorMarriage" trueValue="prior" false="during"></pt-radio>

        <h4>Is there a divorce decree we can see</h4>
        <pt-radio name="IsDivorceDecree" model="LegalCase.PreQuestions.IsDivorceDecree"></pt-radio>

        <h4>Is there a contract?</h4>
        <pt-radio name="IsContract" model="LegalCase.PreQuestions.IsContract"></pt-radio>

        <h4>Is contract for our viewing?</h4>
        <pt-radio name="IsContractViewable" model="LegalCase.PreQuestions.IsContractViewable"></pt-radio>

        <h4>Have we tried to offer that person money to agree to participate?</h4>
        <pt-radio name="IsOfferMoney" model="LegalCase.PreQuestions.IsOfferMoney"></pt-radio>

        <h4>Is there a current foreclose on the property?</h4>
        <pt-radio name="IsFC" model="LegalCase.PreQuestions.IsFC"></pt-radio>

        <h4>Is there refusing party trying to work out with the bank?</h4>
        <pt-radio name="IsRefusingWorkout" model="LegalCase.PreQuestions.IsRefusingWorkout"></pt-radio>

        <h4>How Many units of living space are there?</h4>


        <h4>Who is paying the utilities currently?</h4>
        <input model="LegalCase.PreQuestions.WhoPayUtilities" />
    </div>
</form>