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

	<!-- case -->
	<div>
		<h4 class="ss_form_title">Case Status</h4>
		<ul class="ss_form_box clearfix">
			<li class="ss_form_item">
				<label class="ss_form_input_title {{HighLightStauts(LegalCase.CaseStauts,4)?'ss_warning':''}}">
					What was the last milestone document recorded on Clerk Minutes? 
				</label>
				<select class="ss_form_input" ng-model="LegalCase.CaseStauts">
					<option value="2">S&C / LP</option>
					<option value="3">RJI</option>
					<option value="4">Settlement Conf</option>
					<option value="5">O/REF</option>
					<option value="6">Judgement</option>
					<option value="7">Sale Date</option>
				</select>
			</li>
		</ul>
	</div>

	<!-- Estate Pending -->
	<div class="ss_form">
		<h4 class="ss_form_title">Estate Pending</h4>
		<div class="ss_form">
			<ul class="ss_form_box clearfix">
				<li class="ss_form_item">
					<label class="ss_form_input_title">Was Estate formed? </label>
					<input type="radio" id="WasEstateFormedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.WasEstateFormed" ng-value="true" radio-init defaultvalue="true">
					<label for="WasEstateFormedY" class="input_with_check ">
						<span class="box_text">Yes </span>
					</label>
					<input type="radio" id="WasEstateFormedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.WasEstateFormed" ng-value="false" radio-init defaultvalue="false">
					<label for="WasEstateFormedN" class="input_with_check ">
						<span class="box_text">No </span>
					</label>
				</li>
			</ul>

			<div class="cssSlideUp" ng-show="LegalCase.ForeclosureInfo.WasEstateFormed">
				<div class="arrow_box">
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
					</ul>
					<div class=" clearfix edit_text_area">
						<label class="ss_form_input_title" style="margin: 0px">Members of Estate(Up To 6)</label>
						<ul class="ss_form_box">

							<li class="ss_form_item " ng-repeat="member in LegalCase.ForeclosureInfo.MembersOfEstate" ng-show="$index>0">
								<input class="ss_form_input" ng-model="member.name"><i class="fa fa-minus-circle icon_btn" ng-click="delEstateMembers($index)"></i>

							</li>
							<li class="ss_form_item" ng-show="LegalCase.ForeclosureInfo.MembersOfEstate.length<=6">
								<input class="ss_form_input" ng-model="LegalCase.membersText">
								<i class="fa fa-plus-circle fa-lg icon_btn" ng-click="addToEstateMembers(LegalCase.ForeclosureInfo.MembersOfEstate.length)"></i>
							</li>
						</ul>
					</div>

					<ul class=" ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title">Administrator Name <br />&nbsp</label>
							<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AdministratorName">
						</li>

						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.EveryOneIn?'ss_warning':''">Was everyone who is a part of the estate served</label>
							<input type="radio" id="EveryOneInY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.EveryOneIn" ng-value="true" radio-init defaultvalue="false">
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
							<label class="ss_form_input_title">How was Deed Held? <br />&nbsp</label>
							<select class="ss_form_input" ng-model="LegalCase.PropertyInfo.HowWasDeedHeld">
								<option value="Tenants in Common">Tenants in Common</option>
								<option value="Joint Tenancy">Joint Tenancy</option>
								<option value="Tenancy by the entirety">Tenancy by the entirety</option>
							</select>
						</li>
					</ul>

				</div>
			</div>
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
					<h4 class="ss_form_title">Affidavit of Service {{$index + 1}} <i class="fa fa-times-circle icon_btn tooltip-examples" title="Delete" ng-click="DeleteItem(LegalCase.ForeclosureInfo.AffidavitOfServices,$index)"></i></h4>
					<ul class="ss_form_box clearfix">

						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!service.ClientPersonallyServed?'ss_warning':''">Client Personally Serve<br />&nbsp</label>
							<input type="radio" id="ClientPersonallyServedY{{$index}}" class="ss_form_input" ng-model="service.ClientPersonallyServed" ng-value="true" radio-init defaultvalue="true">
							<label for="ClientPersonallyServedY{{$index}}" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="ClientPersonallyServedN{{$index}}" class="ss_form_input" ng-model="service.ClientPersonallyServed" ng-value="false">
							<label for="ClientPersonallyServedN{{$index}}" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="service.NailAndMail?'ss_warning':''">
								Nail and Mail <span style="text-transform: none"><i class="fa fa-question-circle tooltip-examples icon-btn" title="Nial and Mail is when the S&C is literally taped to the front door of the address for service. 
The courts no longer consider this proper service. "></i></span><br />&nbsp
							</label>
							<input type="radio" id="NailAndMailY{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="true" defaultvalue="true" radio-init defaultvalue="false">
							<label for="NailAndMailY{{$index}}" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="NailAndMaiN{{$index}}" class="ss_form_input" ng-model="service.NailAndMail" ng-value="false">
							<label for="NailAndMaiN{{$index}}" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>

						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!service.BorrowerLiveInAddrAtTimeServ?'ss_warning':''">Did Borrower live in service Address at time of Serv</label>
							<input type="radio" id="BorrowerLiveInAddrAtTimeServY{{$index}}" class="ss_form_input" ng-model="service.BorrowerLiveInAddrAtTimeServ" ng-value="true" radio-init defaultvalue="true">
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
							<input type="radio" id="BorrowerEverLiveHereY{{$index}}" class="ss_form_input" ng-model="service.BorrowerEverLiveHere" ng-value="true" radio-init defaultvalue="false">
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
				<div>
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="service.IsServerHasNegativeInfo?'ss_warning':''">If not on list, did web search provide any negative information on process server</label>
							<input type="radio" id="IsServerHasNegativeInfoY{{$index}}" class="ss_form_input" ng-model="service.IsServerHasNegativeInfo" ng-value="true" radio-init defaultvalue="false">
							<label for="IsServerHasNegativeInfoY{{$index}}" class="input_with_check">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="IsServerHasNegativeInfoN{{$index}}" class="ss_form_input" ng-model="service.IsServerHasNegativeInfo" ng-value="false">
							<label for="IsServerHasNegativeInfoN{{$index}}" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
					</ul>
				</div>
				<div ng-class="service.IsServerHasNegativeInfo?'arrow_box ss_show_from':''">
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item ss_form_item_line" ng-show="service.isServerHasNegativeInfo">
							<label class="ss_form_input_title">Negative information on process server</label>
							<textarea class="edit_text_area text_area_ss_form" ng-model="service.ServerHasNegativeInfo"></textarea>
						</li>
					</ul>
				</div>
				<div>
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!service.AffidavitServiceFiledIn20Day?'ss_warning':''">Affidavit of service filed within 20 days of service <i class="f"></i></label>
							<input type="radio" id="AffidavitServiceFiledIn20DayY{{$index}}" class="ss_form_input" ng-model="service.AffidavitServiceFiledIn20Day" ng-value="true" radio-init defaultvalue="true">
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

	<!-- Assignments -->
	<div class="ss_array">

		<h4 class="ss_form_title title_with_line  title_after_notes ">
			<span class="title_index title_span">Assignments </span>
			<i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
			&nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" ng-click="AddArrayItem(LegalCase.ForeclosureInfo.Assignments)" title="" data-original-title="Add"></i>

			<i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
		</h4>

		<div class="collapse_div">
			<div ng-repeat="assignment in LegalCase.ForeclosureInfo.Assignments">


				<div class="ss_form">
					<h4 class="ss_form_title">Assignment {{$index + 1}} <i class="fa fa-times-circle icon_btn tooltip-examples" title="Delete" ng-click="DeleteItem(LegalCase.ForeclosureInfo.Assignments,$index)"></i></h4>

					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title">Are there any assignments of mortgage?</label>
							<input type="radio" id="IsMortageHasAssignmentY{{$index}}" class="ss_form_input" ng-model="assignment.IsMortageHasAssignment" ng-value="true" defaultvalue="true">
							<label for="IsMortageHasAssignmentY{{$index}}" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="IsMortageHasAssignmentN{{$index}}" class="ss_form_input" ng-model="assignment.IsMortageHasAssignment" ng-value="false" radio-init defaultvalue="false">
							<label for="IsMortageHasAssignmentN{{$index}}" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
					</ul>
					<div class="cssSlideUp" ng-show="assignment.IsMortageHasAssignment">
						<div class="arrow_box">
							<ul class="ss_form_box clearfix ">

								<li class="ss_form_item">
									<label class="ss_form_input_title">AssigneeName</label>
									<input class="ss_form_input " ng-model="assignment.AssigneeName" />
								</li>
								<li class="ss_form_item">
									<label class="ss_form_input_title">Assignor Name</label>
									<input class="ss_form_input" ng-model="assignment.AssignorName" />
								</li>
								<li class="ss_form_item">
									<label class="ss_form_input_title">Notary name</label>
									<select class="ss_form_input" ng-model="assignment.NotaryName" ng-options="o as o for o in ['Alan Feldman','John Medina','Robert Winckelmann']"></select>
								</li>
								<li class="ss_form_item">
									<label class="ss_form_input_title">Who Executed Document</label>
									<select class="ss_form_input" ng-model="assignment.ExecutedDocPerson" ng-options="o as o for o in ['Alan Feldman','John Medina','Robert Winckelmann']"></select>
								</li>

								<li class="ss_form_item">
									<label class="ss_form_input_title">Date</label>
									<input class="ss_form_input" ss-date="" ng-model="assignment.AssignmentDate" />
								</li>
								<li class="ss_form_item">
									<label class="ss_form_input_title">CRFN number</label>
									<input class="ss_form_input" ng-model="CRFNNum" />
								</li>
							</ul>
						</div>

					</div>

					<div>
						<ul class="ss_form_box clearfix">
							<li class="ss_form_item">
								<label class="ss_form_input_title">Are there any documents drafted by DOCX LLC ?</label>
								<input type="radio" id="HasDocDraftedByDOCXLLCY{{$index}}" class="ss_form_input" ng-model="assignment.HasDocDraftedByDOCXLLC" ng-value="true" radio-init defaultvalue="false">
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
		</ul>
		<div class="arrow_box" ng-show="!LegalCase.ForeclosureInfo.AnswerClientFiledBefore">
			<ul class="ss_form_box clearfix">
				<li class="ss_form_item ss_form_item_line">
					<label class="ss_form_input_title">Why did borrower not file a timely answer</label>
					<textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.ForeclosureInfo.AnswerClientFiledBeforeDetail"></textarea>
				</li>
			</ul>
		</div>
		<ul class="ss_form_box clearfix">
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
		<div class="cssSlideUp" ng-show="LegalCase.ForeclosureInfo.NoteIsPossess">
			<div class="arrow_box">
				<ul class="ss_form_box clearfix">
					<li class="ss_form_item">
						<label class="ss_form_input_title">Obligor 1</label>
						<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteObligor1">
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title">Obligor 2</label>
						<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteObligor2">
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title">Obligor 3</label>
						<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.NoteObligor3">
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title">Is the current Plaintiff the same as the original lender</label>
						<input type="radio" id="PlainTiffSameAsOriginalY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlainTiffSameAsOriginal" ng-value="true" radio-init defaultvalue="true">
						<label for="PlainTiffSameAsOriginalY" class="input_with_check ">
							<span class="box_text">Yes </span>
						</label>
						<input type="radio" id="PlainTiffSameAsOriginalN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlainTiffSameAsOriginal" ng-value="false" radio-init defaultvalue="false">
						<label for="PlainTiffSameAsOriginalN" class="input_with_check ">
							<span class="box_text">No </span>
						</label>
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.NoteEndoresed?'ss_warning':''">
							Note Endoresed
						<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn' title='If a note does not have the proper allonge, or a note endorsement, then there is no proof of proper transfer. '></i></span>
							<br />&nbsp
						</label>
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
						<label class="ss_form_input_title" ng-class="LegalCase.ForeclosureInfo.NoteEndorserIsSignors?'ss_warning':''">Is the endorser one of these signors?<br />&nbsp</label>
						<div class="contact_box" dx-select-box="InitContact('LegalCase.ForeclosureInfo.NoteEndorserIsSignors')"></div>
					</li>
				</ul>
			</div>
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
				<label class="ss_form_input_title {{isPassOrEqualByDays(LegalCase.ForeclosureInfo.LisPendesDate, LegalCase.ForeclosureInfo.LisPendesRegDate, 5)?'ss_warning':''}}">
					Date of registration for Lis Pendens letter
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn' title='Lender must register Commencement letter within 5 days of the Lis Pendens'></i></span>
				</label>
				<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.LisPendesRegDate">
			</li>
		</ul>


		<ul class="ss_form_box clearfix">
			<li class="ss_form_item">
				<label class="ss_form_input_title">Do we have the acceleration letter to review?</label>
				<input type="radio" id="AccelerationLetterReviewY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterReview" ng-value="true" radio-init defaultvalue="true">
				<label for="AccelerationLetterReviewY" class="input_with_check ">
					<span class="box_text">Yes </span>
				</label>
				<input type="radio" id="AccelerationLetterReviewN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterReview" ng-value="false" radio-init defaultvalue="false">
				<label for="AccelerationLetterReviewN" class="input_with_check ">
					<span class="box_text">No </span>
				</label>
			</li>
		</ul>
		<div class="cssSlideUp" ng-show="LegalCase.ForeclosureInfo.AccelerationLetterReview">
			<div class="arrow_box">
				<ul class="ss_form_box clearfix">
					<li class="ss_form_item">
						<label class="ss_form_input_title {{isPassOrEqualByMonths(LegalCase.ForeclosureInfo.DefaultDate,LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,12 )?'ss_warning':''}}">
							When was Acceleration letter mailed to borrower?  
					<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='If Lender did not inform borrower within 12 months of original default, this is an issue'></i></span>
						</label>
						<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterMailedDate">
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title">Date of Acceleration letterDefault date <br />&nbsp</label>
						<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterDate">
					</li>
					<li class="ss_form_item">
						<label class="ss_form_input_title {{isPassOrEqualByDays(LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,LegalCase.ForeclosureInfo.AccelerationLetterRegDate,3 )?'ss_warning':''}}">
							Date of registration for Acceleration letter 
					<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='Lender must register Acceleration letter within 3 days of the date of said letter'></i></span>
						</label>
						<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AccelerationLetterRegDate">
					</li>

				</ul>

			</div>
		</div>
		<ul class="ss_form_box clearfix">
			<li class="ss_form_item ss_form_item_line {{isPassOrEqualByMonths(LegalCase.ForeclosureInfo.DefaultDate,LegalCase.ForeclosureInfo.AccelerationLetterMailedDate,2 )?'ss_warning':''}}">
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
				<label class="ss_form_input_title">Was Steven J. Baum the previous plaintiff's Attny<br />&nbsp</label>
				<input type="radio" id="StevenJAttnyY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.StevenJAttny" ng-value="true" radio-init defaultvalue="true">
				<label for="StevenJAttnyY" class="input_with_check ">
					<span class="box_text">Yes </span>
				</label>
				<input type="radio" id="StevenJAttnyN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.StevenJAttny" ng-value="false" radio-init defaultvalue="false">
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

		</ul>
		<ul class="ss_form_box clearfix">
			<li class="ss_form_item">
				<label class="ss_form_input_title">When was S&C filed?</label>
				<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.SAndCFiledDate" ng-change="showSAndCFrom()">
			</li>
		</ul>
		<div class="cssSlideUp" ng-show="showSAndCFormFlag">
			<div class="arrow_box">
				<div ng-show="isLess08292013">
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title {{isPassByDays(LegalCase.ForeclosureInfo.JudgementDate,LegalCase.ForeclosureInfo.AffirmationFiledDate,0)?'ss_warning':''}}">
								When was Affirmation filed? 
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn' title='Affirmations before 8/30/2013 must be filed prior to judgement. '></i></span><br />&nbsp
								<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.AffirmationFiledDate">
							</label>
						</li>

						<li class="ss_form_item">
							<label class="ss_form_input_title">In the Affirmation, what is the name of the Reviewer?</label>
							<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AffirmationReviewer">
						</li>
						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.AffirmationReviewerByCompany?'ss_warning':''">Was the reviewer employed by the servicing company? </label>
							<input type="radio" id="AffirmationReviewerByCompanyY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AffirmationReviewerByCompany" ng-value="true" radio-init defaultvalue="true">
							<label for="AffirmationReviewerByCompanyY" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="AffirmationReviewerByCompanyN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.AffirmationReviewerByCompany" ng-value="false">
							<label for="AffirmationReviewerByCompanyN" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
					</ul>
				</div>
				<div ng-show="isBigger08302013">
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<span class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.MortNoteAssInCert?'ss_warning':''">In the Certificate of Merit, is the Mortgage, Note and Assignment included?</span>
							<input type="radio" id="MortNoteAssInCertY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.MortNoteAssInCert" ng-value="true" radio-init defaultvalue="true">
							<label for="MortNoteAssInCertY" class="input_with_check ">
								<span class="box_text">Yes</span>
							</label>
							<input type="radio" id="MortNoteAssInCertN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.MortNoteAssInCert" ng-value="false">
							<label for="MortNoteAssInCertN" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>

						<li ng-show="!LegalCase.ForeclosureInfo.MortNoteAssInCert" class="ss_form_item" style="width: 66.6%">
							<label class="ss_form_input_title" ng-class="checkMissInCertValue()?'ss_warning':''">Which of the above items are missing</label>
							<div id="MissInCert" dx-tag-box="initMissInCert()"></div>
						</li>


						<li class="ss_form_item">
							<label class="ss_form_input_title">
								In the Certificate of Merit, what is the name of the Reviewer
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='A Certificate of Merit has two requirement. First, it must have a Mortgage, Note, and Assignment included. Second, it must have a name of a party of the servicer who reviewed the name of the documents AND that person needs to have been employed by the servicer.'></i></span>
							</label>
							<input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CertificateReviewer">
						</li>
						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.CertificateReviewerByCompany?'ss_warning':''">Was the reviewer employed by the servicing company</label>
							<input type="radio" id="CertificateReviewerByCompanyY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CertificateReviewerByCompany" ng-value="true" radio-init defaultvalue="true">
							<label for="CertificateReviewerByCompanyY" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="CertificateReviewerByCompanyN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.CertificateReviewerByCompany" ng-value="false">
							<label for="CertificateReviewerByCompanyN" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
					</ul>
				</div>
				<div ng-show="isBigger03012015">
					<ul class="ss_form_box clearfix">
						<li class="ss_form_item">
							<label class="ss_form_input_title">Are the documents submitted to court properly redacted? </label>
							<input type="radio" id="DocumentsRedactedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.DocumentsRedacted" ng-value="true" radio-init defaultvalue="true">
							<label for="DocumentsRedactedY" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="DocumentsRedactedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.DocumentsRedacted" ng-value="false">
							<label for="DocumentsRedactedN" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>



						<li class="ss_form_item">
							<label class="ss_form_input_title" ng-class="!LegalCase.ForeclosureInfo.ItemsRedacted?'ss_warning':''">
								Are items of personal information Redacted?
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='All cases started after 3/1/2015 require that items of personal information (social secuirty numbers, bank accounts, loan numbers, etc.) be Redacted (blocked out) from filing documents.   '></i></span>
							</label>
							<input type="radio" id="ItemsRedactedY" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.ItemsRedacted" ng-value="true" radio-init defaultvalue="true">
							<label for="ItemsRedactedY" class="input_with_check ">
								<span class="box_text">Yes </span>
							</label>
							<input type="radio" id="ItemsRedactedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.ItemsRedacted" ng-value="false" radio-init defaultvalue="false">
							<label for="ItemsRedactedN" class="input_with_check ">
								<span class="box_text">No </span>
							</label>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<ul class="ss_form_box clearfix">
			<li class="ss_form_item">
				<label class="ss_form_input_title {{isPassByMonths(LegalCase.ForeclosureInfo.SAndCFiledDate, LegalCase.ForeclosureInfo.RJIDate, 12)?'ss_warning':''}}">
					When was RJI filed?
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='RJI Should have been filed within 12 months of the S&C. '></i></span>
				</label>
				<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.RJIDate">
			</li>
			<li class="ss_form_item">
				<label class="ss_form_input_title {{isLessOrEqualByDays(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.ConferenceDate, 60)?'ss_warning':''}}">
					Date Conference was scheduled
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='Conference date should be scheduled within 60 days of RJI. '></i></span>
				</label>
				<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.ConferenceDate">
			</li>
			<li class="ss_form_item">
				<label class="ss_form_input_title {{isPassByMonths(LegalCase.ForeclosureInfo.RJIDate, LegalCase.ForeclosureInfo.OREFDate, 12)?'ss_warning':''}}">
					When was O/REF filed?
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn' title='O/REF Should have been filed within 12 months of the RJI. '></i></span>
				</label>
				<input class="ss_form_input" ss-date="" ng-model="LegalCase.ForeclosureInfo.OREFDate">
			</li>
			<li class="ss_form_item">
				<label class="ss_form_input_title {{isPassByMonths(LegalCase.ForeclosureInfo.OREFDate, LegalCase.ForeclosureInfo.JudgementDate, 12)?'ss_warning':''}}">
					When was Judgement submitted?
				<span style='text-transform: none'><i class='fa fa-question-circle tooltip-examples icon-btn ' title='Judgement should have been submitted within 12 months of the O/REF. '></i></span>
				</label>
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
				<input type="radio" id="HAMPSubmittedN" class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.HAMPSubmitted" ng-value="false" radio-init defaultvalue="false">
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
