<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionCheckList.ascx.vb" Inherits="IntranetPortal.ConstructionCheckList" %>

<div class="ss_form">
    <div class="ss_border">
        <table>

            <tr>
                <td class="col-sm-10">
                    <h5>
                        <label for="Checklist_isUploadDropBox">1. Upload closing packages to DROPBOX></label></h5>
                </td>
                <td>
                    <input type="checkbox" id="Checklist_isUploadDropBox" ng-model="CSCase.CSCase.Checklist.isUploadDropBox" style="display: block" /></td>
            </tr>
            <tr>

                <td class="col-sm-10">
                    <h5>
                        <label for="Checklist_isForwardEscrow">2 .Forward any necessary Escrow documents to the appropriate individual to follow up</label></h5>
                </td>
                <td>
                    <input type="checkbox" id="Checklist_isForwardEscrow" ng-model="CSCase.CSCase.Checklist.isForwardEscrow" style="display: block" /></td>
            </tr>
            <tr>

                <td class="col-sm-10">
                    <h5>
                        <label for="Checklist_isMoveToSold">3. Moved file to SOLD Properties</label></h5>
                </td>
                <td>
                    <input type="checkbox" id="Checklist_isMoveToSold" ng-model="CSCase.CSCase.Checklist.isMoveToSold" style="display: block" /></td>
            </tr>
            <tr>

                <td class="col-sm-10">
                    <h5>
                        <label for="Checklist_isFinalWalk">4. A FINAL Walk through may be requested to make sure that agreed upon repairs are completed (PUNCHLIST if Any)</label></h5>
                </td>
                <td>
                    <input type="checkbox" id="Checklist_isFinalWalk" ng-model="CSCase.CSCase.Checklist.isFinalWalk" style="display: block" /></td>
            </tr>
            <tr>

                <td class="col-sm-10">
                    <h5>
                        <label for="Checklist_ifNotify">5. Notify the utility companies, Homeowners insurance, Alarm Security Services of final service date and request refund to the appropriate entity name</label></h5>
                </td>
                <td>
                    <input type="checkbox" id="Checklist_ifNotify" ng-model="CSCase.CSCase.Checklist.ifNotify" style="display: block" /></td>
            </tr>


        </table>
    </div>
</div>

