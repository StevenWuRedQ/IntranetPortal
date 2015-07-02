<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalForeclosureReviewTab.ascx.vb" Inherits="IntranetPortal.LegalForeclosureReviewTab" %>
<div class="short_sale_content">
    <div class="clearfix">
        <div style="float: right">
            <input type="button" class="rand-button short_sale_edit" value="Completed Research" runat="server" onserverclick="btnCompleteResearch_ServerClick" id="btnCompleteResearch" visible="false" />
            <select class="ss_form_input" id="lbEmployee" runat="server" style="width: 150px" visible="false">
                <option value=""></option>
                <option value="Chris Yan">Chris Yan</option>
                <option value="Steven Wu">Steven Wu</option>
            </select>
            <%--   <input type="button" class="rand-button short_sale_edit" visible="false" value="Assign" runat="server" onserverclick="btnAssign_ServerClick" id="btnAssign" />
            <input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />--%>
        </div>
    </div>

    <!-- Estate Pending -->
    <div>

        <h4 class="ss_form_title">Estate Pending</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="LegalCase.ForeclosureInfo.WasEstateFormed?'ss_warning':''">Was Estate formed? </label>
                <input type="radio" id="WasEstateFormedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.WasEstateFormed" ng-value="true" radio-init defaultvalue="true">
                <label for="WasEstateFormedY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="WasEstateFormedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.WasEstateFormed" ng-value="false">
                <label for="WasEstateFormedN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
        </ul>
        <div ng-show="LegalCase.ForeclosureInfo.WasEstateFormed">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Estate Index #</label>
                    <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EstateIndexNum">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Attorney who Filed </label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.PendingAttorney')">
                    </div>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Filed </label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.PendingDateFiled">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Members of Estate</label>
                    <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.MembersofEstate">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Administrator Name</label>
                    <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AdministratorName">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.EveryOneIn?'ss_warning':''">Was everyone who is a part of the estate served</label>
                    <input type="radio" id="EveryOneInY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EveryOneIn" ng-value="true" radio-init defaultvalue="true">
                    <label for="EveryOneInY" class="input_with_check ">
                        <span class="box_text">Yes </span>
                    </label>
                    <input type="radio" id="EveryOneInN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EveryOneIn" ng-value="false">
                    <label for="EveryOneInN" class="input_with_check ">
                        <span class="box_text">No </span>
                    </label>
                </li>
                <li class="ss_form_item ss_form_text" ng-show="!LegalCase.ForeclosureInfo.EveryOneIn">
                    <label class="ss_form_input_title">Who was not served </label>
                    <input class="ss_form_input " ng-model="LegalCase.ForeclosureInfo.EveryOneInDetail">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">How was Deed Held? </label>
                    <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.HowWasDeedHeld">
                        <option value="Tenants in Common">Tenants in Common</option>
                        <option value="Joint Tenancy">Joint Tenancy</option>
                        <option value="Tenancy by the entirety">Tenancy by the entirety</option>
                    </select>
                </li>
            </ul>
        </div>
    </div>

    <!-- Bankruptcy -->
    <div class="ss_form">
        <h4 class="ss_form_title">Bankruptcy</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Who Filed</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.BankruptcyWhoFiled">
                    <option value="Borrower">Borrower</option>
                    <option value="Co-Borrower">Co-Borrower</option>
                    <option value="Both">Both</option>
                </select>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Filed </label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.BankruptcyDateFiled">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Chapter filed</label>
                <select class="ss_form_input" ng-model="LegalCase.PropertyInfo.BankruptcyChapterFiled">
                    <option value="7">7</option>
                    <option value="11">11</option>
                    <option value="13">13</option>
                </select>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Discharged</label>
                <input type="radio" id="BankruptcyDischargedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.BankruptcyDischarged" ng-value="true" radio-init defaultvalue="true">
                <label for="BankruptcyDischargedY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="BankruptcyDischargedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.BankruptcyDischarged" ng-value="false">
                <label for="BankruptcyDischargedN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Discharged </label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.BankruptcyDischargedDate">
            </li>
        </ul>
    </div>

    <!-- Affidavit of Service  -->

    <div class="ss_array">

        <h4 class="ss_form_title title_with_line  title_after_notes ">
            <span class="title_index title_span">Affidavit of Services </span>
            <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="AddArrayItem(LegalCase.ForeclosureInfo.AffidavitOfServices)" title="" data-original-title="Add"></i>
            &nbsp;<span style="text-transform: none"><i class="fa fa-question-circle tooltip-examples icon-btn color_blue" title="If there is alreaedy a judgement of foreclosure and sale submitted to the court, signed, or entereed, we need to first come up with a reson as to why there was not a n answer put in earlie"></i></span>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>

        <div class="collapse_div">
            <div ng-repeat="service in LegalCase.ForeclosureInfo.AffidavitOfServices">
                <div class="ss_form">
                    <h4 class="ss_form_title">Affidavit of Service {{$index + 1}} <i class="fa fa-times-circle icon_btn tooltip-examples" title="Delete" ng-click="DeleteItem(LegalCase.ForeclosureInfo.AffidavitOfServices,$index)"></i> </h4>
                    <ul class="ss_form_box clearfix">

                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="!service.ClientPersonallyServed?'ss_warning':''">Client Personally Served</label>
                            <input type="radio" id="NailAndMailY{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="true" radio-init="true">
                            <label for="NailAndMailY{{$index}}" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="NailAndMailN{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="false">
                            <label for="NailAndMailN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>
                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="service.NailAndMail?'ss_warning':''">
                                Nail and Mail <span style="text-transform: none"><i class="fa fa-question-circle tooltip-examples icon-btn" title="Nial and Mail is when the S&C is literally taped to the front door of the address for service. 
The courts no longer consider this proper service. "></i></span>
                            </label>
                            <input type="radio" id="ClientPersonallyServedY{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="true" radio-init="true">
                            <label for="ClientPersonallyServedY{{$index}}" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="ClientPersonallyServedN{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="false">
                            <label for="ClientPersonallyServedN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>

                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="!service.BorrowerLiveInAddrAtTimeServ?'ss_warning':''">Did Borrower live in service Address at time of Serv</label>
                            <input type="radio" id="BorrowerLiveInAddrAtTimeServY{{$index}}" class="ss_form_input" ng-model="service.BorrowerLiveInAddrAtTimeServ" ng-value="true" radio-init="true">
                            <label for="BorrowerLiveInAddrAtTimeServY{{$index}}" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="BorrowerLiveInAddrAtTimeServN{{$index}}" class="ss_form_input" ng-model="service.BorrowerLiveInAddrAtTimeServ" ng-value="false">
                            <label for="BorrowerLiveInAddrAtTimeServN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>
                        <li class="ss_form_item" ng-show="!service.BorrowerLiveInAddrAtTimeServ">
                            <label class="ss_form_input_title" ng-class="!service.BorrowerEverLiveHere?'ss_warning':''">If No, did borrower ever live in service address</label>
                            <input type="radio" id="BorrowerEverLiveHereY{{$index}}" class="ss_form_input" ng-model="service.BorrowerEverLiveHere" ng-value="true" radio-init="true">
                            <label for="BorrowerEverLiveHereY{{$index}}" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="BorrowerEverLiveHereN{{$index}}" class="ss_form_input" ng-model="service.BorrowerEverLiveHere" ng-value="false">
                            <label for="BorrowerEverLiveHereN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>

                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="service.ServerInSererList?'ss_warning':''">Is the process server one of these servers</label>
                            <select class="ss_form_input" ng-model="service.ServerInSererList" ng-options="o as o for o in ['Alan Feldman','John Medina','Robert Winckelmann']"></select>
                        </li>

                    </ul>

                </div>
                <div ng-class="service.IsServerHasNegativeInfo?'edit_text_area ss_show_from':''">
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="service.IsServerHasNegativeInfo?'ss_warning':''">If not on list, did web search provide any negative information on process server</label>
                            <input type="radio" id="IsServerHasNegativeInfoY{{$index}}" class="ss_form_input" ng-model="service.IsServerHasNegativeInfo" ng-value="true" radio-init="true">
                            <label for="IsServerHasNegativeInfoY{{$index}}" class="input_with_check">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="IsServerHasNegativeInfoN{{$index}}" class="ss_form_input" ng-model="service.IsServerHasNegativeInfo" ng-value="false">
                            <label for="IsServerHasNegativeInfoN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>

                        <li class="ss_form_item ss_form_item_line" ng-show="service.isServerHasNegativeInfo">
                            <label class="ss_form_input_title">Negative information on process server</label>
                            <textarea class="edit_text_area text_area_ss_form" ng-model="service.ServerHasNegativeInfo"></textarea>
                        </li>
                    </ul>
                </div>
                <div>
                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title" ng-class="service.AffidavitServiceFiledIn20Day?'ss_warning':''">Affidavit of service filed within 20 days of service <i class="f"></i></label>
                            <input type="radio" id="AffidavitServiceFiledIn20DayY{{$index}}" class="ss_form_input" ng-model="service.AffidavitServiceFiledIn20Day" ng-value="true" radio-init="true">
                            <label for="AffidavitServiceFiledIn20DayY{{$index}}" class="input_with_check">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="AffidavitServiceFiledIn20DayN{{$index}}" class="ss_form_input" ng-model="service.AffidavitServiceFiledIn20Day" ng-value="false">
                            <label for="AffidavitServiceFiledIn20DayN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>
                        <li class="ss_form_item ss_form_item_line">
                            <label class="ss_form_input_title">Additional Affidavit Comments</label>
                            <textarea class="edit_text_area text_area_ss_form" ng-model="service.AdditionalAffidavitComments"></textarea>
                        </li>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    <%--Assignments--%>
    <div class="ss_array">

        <h4 class="ss_form_title title_with_line  title_after_notes ">
            <span class="title_index title_span">Assignments </span>
            <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="AddArrayItem(LegalCase.ForeclosureInfo.Assignments)" title="" data-original-title="Add"></i>
           
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>

        <div class="collapse_div">
            <div ng-repeat="assignment in LegalCase.ForeclosureInfo.Assignments">
                <div class="ss_form" ng-class="assignment.IsMortageHasAssignment?'edit_text_area ss_show_from':''">
                    <h4 class="ss_form_title">Assignment {{$index + 1}} <i class="fa fa-times-circle icon_btn tooltip-examples" title="Delete" ng-click="DeleteItem(LegalCase.ForeclosureInfo.Assignments,$index)"></i></h4>

                    <ul class="ss_form_box clearfix">
                        <li class="ss_form_item">
                            <label class="ss_form_input_title">Are there any assignments of mortgage?</label>
                            <input type="radio" id="IsMortageHasAssignmentY{{$index}}" class="ss_form_input" ng-model="assignment.IsMortageHasAssignment" ng-value="true" radio-init="true">
                            <label for="IsMortageHasAssignmentY{{$index}}" class="input_with_check ">
                                <span class="box_text">Yes </span>
                            </label>
                            <input type="radio" id="IsMortageHasAssignmentN{{$index}}" class="ss_form_input" ng-model="assignment.IsMortageHasAssignment" ng-value="false">
                            <label for="IsMortageHasAssignmentN{{$index}}" class="input_with_check ">
                                <span class="box_text">No </span>
                            </label>
                        </li>
                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">AssigneeName</label>
                            <input class="ss_form_input " ng-model="assignment.AssigneeName" />
                        </li>
                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">Assignor Name</label>
                            <input class="ss_form_input" ng-model="assignment.AssignorName" />
                        </li>
                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">Notary name</label>
                            <select class="ss_form_input" ng-model="assignment.NotaryName" ng-options="o as o for o in ['Alan Feldman','John Medina','Robert Winckelmann']"></select>
                        </li>
                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">Who Executed Document</label>
                            <select class="ss_form_input" ng-model="assignment.ExecutedDocPerson" ng-options="o as o for o in ['Alan Feldman','John Medina','Robert Winckelmann']"></select>
                        </li>

                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">Date</label>
                            <input class="ss_form_input" ss-date="" ng-model="assignment.AssignmentDate" />
                        </li>
                        <li class="ss_form_item" ng-show="assignment.IsMortageHasAssignment">
                            <label class="ss_form_input_title">CRFN number</label>
                            <input class="ss_form_input" ng-model="CRFNNum" />
                        </li>
        </ul>
                    <div>
                        <ul class="ss_form_box clearfix">
                            <li class="ss_form_item">
                                <label class="ss_form_input_title">Are there any documents drafted by DOCX LLC ?</label>
                                <input type="radio" id="HasDocDraftedByDOCXLLCY{{$index}}" class="ss_form_input" ng-model="assignment.HasDocDraftedByDOCXLLC" ng-value="true" radio-init="true">
                                <label for="HasDocDraftedByDOCXLLCY{{$index}}" class="input_with_check ">
                                    <span class="box_text">Yes </span>
                                </label>
                                <input type="radio" id="HasDocDraftedByDOCXLLCN{{$index}}" class="ss_form_input" ng-model="assignment.HasDocDraftedByDOCXLLC" ng-value="false">
                                <label for="HasDocDraftedByDOCXLLCN{{$index}}" class="input_with_check ">
                                    <span class="box_text">No </span>
                                </label>
                            </li>
                            <li class="ss_form_item ss_form_item_line">
                                <label class="ss_form_input_title">Additional Assignment Comments</label>
                                <textarea class="edit_text_area text_area_ss_form" ng-model="service.AdditionalAssignmentComments"></textarea>
                            </li>
                        </ul>

                    </div>

                </div>
            </div>
        </div>
    </div>

    <!--Answer -->

    <div class="ss_form">
        <h4 class="ss_form_title">Answer</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.AnswerClientFiledBefore?'ss_warning':''">Has the client ever filed an answer before</label>
                <input type="radio" id="AnswerClientFiledBeforeY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AnswerClientFiledBefore" ng-value="true" radio-init defaultvalue="true">
                <label for="AnswerClientFiledBeforeY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="AnswerClientFiledBeforeN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AnswerClientFiledBefore" ng-value="false">
                <label for="AnswerClientFiledBeforeN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item ss_form_item_line" ng-show="!LegalCase.ForeclosureInfo.AnswerClientFiledBefore">
                <label class="ss_form_input_title">Why did borrower not file a timely answer</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AnswerClientFiledBeforeDetail"></textarea>
            </li>
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Additional Answer Comments</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AdditionalAnswerComments "></textarea>
            </li>

        </ul>


    </div>

    <!-- Note -->
    <div class="ss_form">
        <h4 class="ss_form_title">Note</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.NoteIsPossess?'ss_warning':''">Do we possess a copy of the note</label>
                <input type="radio" id="NoteIsPossessY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteIsPossess" ng-value="true" radio-init defaultvalue="true">
                <label for="NoteIsPossessY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="NoteIsPossessN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteIsPossess" ng-value="false">
                <label for="NoteIsPossessN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
        </ul>
        <div ng-show="LegalCase.ForeclosureInfo.NoteIsPossess">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Obligor 1</label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.NoteObligor1">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Obligor 2</label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.NoteObligor2">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Obligor 3</label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.NoteObligor3">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Is the current Plaintiff the same as the original lender</label>
                    <input type="radio" id="PlainTiffSameAsOriginalY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlainTiffSameAsOriginal" ng-value="true" radio-init defaultvalue="true">
                    <label for="PlainTiffSameAsOriginalY" class="input_with_check ">
                        <span class="box_text">Yes </span>
                    </label>
                    <input type="radio" id="PlainTiffSameAsOriginalN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlainTiffSameAsOriginal" ng-value="false">
                    <label for="PlainTiffSameAsOriginalN" class="input_with_check ">
                        <span class="box_text">No </span>
                    </label>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title" ng-class="LegalCase.ForeclosureInfo.NoteEndoresed?'ss_warning':''">Note Endoresed</label>
                    <input type="radio" id="NoteEndoresedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndoresed" ng-value="true" radio-init defaultvalue="true">
                    <label for="NoteEndoresedY" class="input_with_check ">
                        <span class="box_text">Yes </span>
                    </label>
                    <input type="radio" id="NoteEndoresedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteEndoresed" ng-value="false">
                    <label for="NoteEndoresedN" class="input_with_check ">
                        <span class="box_text">No </span>
                    </label>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title" ng-class="LegalCase.ForeclosureInfo.NoteEndorserIsSignors?'ss_warning':''">Is the endorser one of these signors?</label>
                    <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.NoteEndorserIsSignors')"></div>
                </li>
            </ul>
        </div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Additional Note Comments</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AdditionalNoteComments"></textarea>
            </li>
        </ul>
    </div>

    <!-- default letter -->
    <div class="ss_form">

        <h4 class="ss_form_title">Default Letters</h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">What is the Default date</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.DefaultDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date of Lis Pendes</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LisPendesDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date of Dismissal</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.DismissalDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="isPassOrEqualByDays(LegalCase.ForeclosureInfo.LisPendesRegDate,LegalCase.ForeclosureInfo.LisPendesDate,5)?'ss_warning':''">Date of registration for Lis Pendens letter</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LisPendesRegDate">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Do we have the acceleration letter to review?</label>
                <input type="radio" id="AccelerationLetterReviewY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterReview" ng-value="true" radio-init defaultvalue="true">
                <label for="AccelerationLetterReviewY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="AccelerationLetterReviewN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterReview" ng-value="false">
                <label for="AccelerationLetterReviewN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
                </li>
        </ul>

        <div ng-show="LegalCase.ForeclosureInfo.AccelerationLetterReview">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">When was Acceleration letter mailed to borrower?  </label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterMailedDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date of Acceleration letterDefault date </label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterDate">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date of registration for Acceleration letter </label>
                    <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterRegDate">
                </li>

            </ul>
        </div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Additional Default Comments</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AdditionalDefaultComment"></textarea>
            </li>
        </ul>
    </div>

    <!-- Procedural -->
    <div class="ss_form">

        <h4 class="ss_form_title">Procedural</h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Was Steven J. Baum the previous plaintiff's Attny</label>
                <input type="radio" id="StevenJAttnyY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.StevenJAttny" ng-value="true" radio-init defaultvalue="true">
                <label for="StevenJAttnyY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="StevenJAttnyN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.StevenJAttny" ng-value="false">
                <label for="StevenJAttnyN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.PlaintiffHaveAtCommencement?'ss_warning':''">Did current plaintiff have, in possession, the note and mortgage at time of commencement?</label>
                <input type="radio" id="PlaintiffHaveAtCommencementY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlaintiffHaveAtCommencement" ng-value="true" radio-init defaultvalue="true">
                <label for="PlaintiffHaveAtCommencementY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="PlaintiffHaveAtCommencementN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlaintiffHaveAtCommencement" ng-value="false">
                <label for="PlaintiffHaveAtCommencementN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">When was S&C filed?</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.SAndCFiledDate">
            </li>
        </ul>
        <div ng-show="">
        </div>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.ItemsRedacted?'ss_warning':''">Are items of personal information Redacted?</label>
                <input type="radio" id="ItemsRedactedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.ItemsRedacted" ng-value="true" radio-init defaultvalue="true">
                <label for="ItemsRedactedY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="ItemsRedactedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.ItemsRedacted" ng-value="false">
                <label for="ItemsRedactedN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">When was RJI filed?</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.RJIDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Conference was scheduled</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.ConferenceDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">When was O/REF filed?</label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.OREFDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">When was Judgement submitted? </label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.JudgementDate">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Judge Name </label>
                <div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.ProceduralJudgeName')">
                </div>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">HAMP Submitted</label>
                <input type="radio" id="HAMPSubmittedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted" ng-value="true" radio-init defaultvalue="true">
                <label for="HAMPSubmittedY" class="input_with_check ">
                    <span class="box_text">Yes </span>
                </label>
                <input type="radio" id="HAMPSubmittedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted" ng-value="false">
                <label for="HAMPSubmittedN" class="input_with_check ">
                    <span class="box_text">No </span>
                </label>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date HAMP Submitted </label>
                <input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.HAMPSubmittedDate">
            </li>
        </ul>
    </div>

   </div>
