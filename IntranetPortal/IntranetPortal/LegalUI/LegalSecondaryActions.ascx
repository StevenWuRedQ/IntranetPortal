<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActions.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActions" %>
<%-- Legal Secondary actions in Legal and need check in Leads UI--%>

<style>
    .legal_action_div {
        /*display:none;*/
    }
</style>
<div id="Estate" class="legal_action_div  animate-show" ng-show="CheckShow('Estate')">
    <div class="ss_form">
        <h4 class="ss_form_title">Estate</h4>
        <ul class="ss_form_box clearfix">


            <li class="ss_form_item">
                <label class="ss_form_input_title">hold Reason</label>
                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateHoldReason">
                    <option>Tenants in common</option>
                    <option>Joint Tenants w/right of survivorship</option>
                    <option>Tenancy by the entirety</option>

                </select>
            </li>

            <li class="ss_form_item">
                <span class="ss_form_input_title">Estate set up</span>

                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateSetUp">
                    <option value="Unknown">Unknown</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
                <%--<input type="checkbox" id="pdf_check_yes103" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check_yes40" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>--%>
            </li>
            <li class="ss_form_item">

                <span class="ss_form_input_title">borrower Died</span>

                <select class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateBorrowerDied">
                    <option value="">Unknown</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
                <%-- <input type="radio" id="pdf_check100" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Yes </span>
                                                                                    </label>
                                                                                    <input type="radio" id="pdf_check101" name="1" class="ss_form_input" value="true">
                                                                                    <label for="pdf_check50" class="input_with_check">
                                                                                        <span class="box_text">Tenancy by the entirety </span>
                                                                                    </label>--%>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">prior action</label>

                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstatePriorAction">
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.EstateNotes"></textarea>
            </li>
        </ul>
    </div>
</div>

<div id="Partition" class="legal_action_div  animate-show" ng-show="CheckShow('Partition')">
    <div class="ss_form">
        <h4 class="ss_form_title">Partition</h4>
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Owner</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Owner">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Parties</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PartitionPartiesId')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Action</label>
                <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionAction">
                    <option value="Action1">Action1 </option>
                    <option value="Action1">Action2 </option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">held reason</label>
                <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionHeldReason">
                    <option value="Tenants in common ">Tenants in common                     </option>
                    <option value="Joint Tenants w/right of survivorship">Joint Tenants w/right of survivorship </option>
                    <option value="Tenancy by the entirety">Tenancy by the entirety               </option>
                </select>
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.PartitionNotes"></textarea>
            </li>
        </ul>
    </div>
</div>


<div id="Breach_of_Contract" class="legal_action_div animate-show" ng-show="CheckShow('Breach of Contract')">
    <div class="ss_form">
        <h4 class="ss_form_title">Breach of Contract</h4>
        <ul class="ss_form_box clearfix">


            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 1</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.BreachOfContractParties1Id')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">parties 2</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.BreachOfContractParties2Id')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Breach type</label>
                <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.BreachOfContractBreachType">
                    <option>Breach  type 1 </option>
                    <option>Breach  type 2 </option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Breach date </label>
                <input class="ss_form_input " ss-date="" ng-model="LegalCase.SecondaryInfo.BreachOfContractDate" />
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">breach learned </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.BreachOfContractBreachLearned" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Money damages amount</label>
                <input class="ss_form_input" ss-money="" ng-model="LegalCase.SecondaryInfo.BreachOfContractBreachMoneyDamagesAmount" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">money damages for</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.BreachOfContractBreachMoneyDamagesAmountFor" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">money damages check Id</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MoneyDamagesCheckId" />
            </li>

            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.BreachOfContractNotes"></textarea>
            </li>
        </ul>
    </div>
    <style>
        .checktoggle {
        }
    </style>

    <%--    <div class="ss_form">
        <h4 class="ss_form_title" style="width: 59%; display: inline-block">Breach of Contract money damages </h4>
        <div style="display: inline-block">
            <input type="checkbox" id="checkshow" name="1" class="ss_form_input checktoggle" value="YES">
            <label for="checkshow" class="input_with_check">
                <span class="box_text">Yes </span>
            </label>
        </div>
        <ul class="ss_form_box clearfix" style="display: none">
            <li class="ss_form_item">
                <label class="ss_form_input_title">amount</label>
                <input class="ss_form_input currency_input" ng-model="LegalCase.SecondaryInfo.Against" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Reason</label>
                <input class="ss_form_input " ng-model="LegalCase.SecondaryInfo.Against" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">check Id</label>
                <input class="ss_form_input " ng-model="LegalCase.SecondaryInfo.Against" />
            </li>
        </ul>
    </div>--%>
</div>

<script>

    $(".checktoggle").click(function () {
        var box = $(this).parents(".ss_form").children(".ss_form_box");
        if (this.checked) {
            box.slideDown();
        } else {
            box.slideUp();
        }
    })
</script>
<div></div>

<div id="Quiet_Title" class="legal_action_div animate-show" ng-show="CheckShow('Quiet Title')">
    <div class="ss_form">
        <h4 class="ss_form_title">Quiet Title</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">LP date</label>
                <input class="ss_form_input ss_date" ng-model="LegalCase.ForeclosureInfo.LPDate" />
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Default date</label>
                <input class="ss_form_input ss_date" ng-model="LegalCase.ForeclosureInfo.DefaultDate" />

            </li>
            <li class="ss_form_item">
                <span class="ss_form_input_title">foreclosure active</span>
                <input type="checkbox" id="pdf_check_yes121" name="121" class="ss_form_input" value="YES" ng-model="LegalCase.ForeclosureInfo.InForeclosure"/>
                <label for="pdf_check_yes121" class="input_with_check">
                    <span class="box_text">Yes </span>
                </label>

            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">foreclosure Action</label>
                <input class="ss_form_input ss_date" ng-model="LegalCase.ForeclosureInfo.StatuteDisposition" />

            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Plaintiff</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PriorPlaintiffId')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Plaintiff(Bank) gone out of business</label>
                <input type="checkbox" id="pdf_check_yes399" name="122" class="ss_form_input" value="true" ng-model="LegalCase.ForeclosureInfo.PriorPlaintiffOutOfBusiness">
                <label for="pdf_check_yes399" class="input_with_check">
                    <span class="box_text">Yes </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Prior Attorney</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PriorPlaintiffId')">
                </div>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">last payment date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LastPaymentDate"/>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Credit Report</label>
                <input class="ss_form_input " ng-model="LegalCase.SecondaryInfo.QuietTitleCreditReport" />
            </li>
            <li class="ss_form_item">
                <%--Who owns mortgage?--%>
                <li class="ss_form_item">
                <label class="ss_form_input_title">Lender </label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.OriginalLenderId')">
                </div>
            </li>
            </li>
            <li class="ss_form_item">
                <%--Do we know who owns the Note--%>
                <label class="ss_form_input_title">Mortage Owner</label>
                <input class="ss_form_input " ng-model="LegalCase.SecondaryInfo.QuietTitleMortageOwner" />
            </li>
            <li class="ss_form_item">
                <%--Do we have the Deed--%>
                <span class="ss_form_input_title">Deed</span>
                <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.HasDeed">
                    <option value="Unknown">Unknown</option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                </select>
                <%-- <input type="checkbox" id="pdf_check_yes122" name="1" class="ss_form_input" value="YES">
                                                                                        <label for="pdf_check_yes122" class="input_with_check">
                                                                                            <span class="box_text">Yes </span>
                                                                                        </label>--%>
            </li>
            <li class="ss_form_item">
                <%--Who is bringing the action--%>
                <label class="ss_form_input_title">Action User</label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.ActionUserId')">
                </div>
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.QuietTitleNotes"></textarea>
            </li>
        </ul>
    </div>
</div>


<%-- --------------------------------------------------------------%>