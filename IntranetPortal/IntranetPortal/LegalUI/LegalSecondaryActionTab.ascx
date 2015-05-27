<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActionTab.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActionTab" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<div class="short_sale_content">


    <div class="clearfix">
        <div style="float: right">
       <%--     <input type="button" id="btnComplete" class="rand-button short_sale_edit" value="Completed" runat="server" onserverclick="btnComplete_ServerClick" />
            <input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />--%>
        </div>
    </div>
    <div data-array-index="0" class="ss_array" style="display: inline;">

        <h4 class="ss_form_title title_with_line">
            <span class="title_index title_span">Statute of Limitation</span>&nbsp;
                                                        <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" style="display: none" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>
        <div class="collapse_div" style="">
            <div class="ss_form">
                <h4 class="ss_form_title">Action</h4>
                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Case Type</label>
                        <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.CaseType">
                            <option>Partition</option>
                            <option>Breach of Contract</option>
                            <option>Quiet Title</option>
                            <option>Estate</option>
                            <option>Article 78           </option>
                            <option>Declaratory Relief   </option>
                            <option>Fraud                </option>
                            <option>Deed Reversion       </option>
                            <option>Other</option>

                        </select>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Index #</label>
                        <input class="ss_form_input" type="number" ng-model="LegalCase.SecondaryInfo.IndexNumber">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Relief requested</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.ReliefRequested">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Goal</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Goal">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">represent Person </label>
                        <div class="contact_box" dx-select-box="InitContact('LegalCase.SecondaryInfo.RepresentPersonId')">
                        </div>
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">against</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Against">
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Has Deed</span>
                        <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.HasDeed">
                            <option>Unknown</option>
                            <option>Yes</option>
                            <option>No</option>
                        </select>
                    </li>


                    <li class="ss_form_item">
                        <span class="ss_form_input_title">service completed</span>
                        <input type="checkbox" id="pdf_check_yes106" name="1" class="ss_form_input" value="true" ng-model="LegalCase.SecondaryInfo.Servicecompleted">
                        <label for="pdf_check_yes106" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Action commenced</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.ActionCommenced">
                    </li>


                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Action answered</span>
                        <input type="checkbox" id="pdf_check_yes107" name="1" class="ss_form_input" value="true" ng-model="LegalCase.SecondaryInfo.ActionAnswered">
                        <label for="pdf_check_yes107" class="input_with_check">
                            <span class="box_text">Yes </span>
                        </label>
                    </li>
                    <li class="ss_form_item">
                        <span class="ss_form_input_title">Action answered Date</span>
                        <input class="ss_form_input" ss-date="" ng-model="LegalCase.SecondaryInfo.ActionAnsweredDate">
                    </li>
                    <li class="ss_form_item">

                        <label class="ss_form_input_title">Upcoming court Motions</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.UpcomingCourtMotions">
                    </li>
                    <li class="ss_form_item">

                        <label class="ss_form_input_title">Upcoming court Orders</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.UpcomingCourtOrders">
                    </li>
                    <li class="ss_form_item">

                        <label class="ss_form_input_title">Upcoming court Date</label>
                        <input class="ss_form_input " ss-date="" ng-model="LegalCase.SecondaryInfo.UpcomingCourtDate">
                    </li>


                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Partition</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.CaseType">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Breach of Contract</label>
                        <input class="ss_form_input">
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Quiet Title</label>
                        <input class="ss_form_input">
                    </li>

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Other </label>
                        <input class="ss_form_input">
                    </li>
                </ul>
            </div>


            <uc1:legalsecondaryactions runat="server" ID="LegalSecondaryActions" />

        </div>
    </div>



    <div class="ss_form" style="padding-bottom: 20px;">
        <h4 class="ss_form_title">Legal  Notes <i class="fa fa-plus-circle  color_blue_edit collapse_btn tooltip-examples" title="" onclick="addOccupantNoteClick( 0  ,this);" data-original-title="Add"></i></h4>



        <div class="note_output">


            <div class="clearence_list_item">
                <div class="clearence_list_content clearfix" style="margin-bottom: 10px">
                    <div class="clearence_list_text" style="margin-top: 0px;">
                        <div class="clearence_list_text14">
                            <i class="fa fa-caret-right clearence_caret_right_icon"></i>
                            <i class="fa fa-times color_blue_edit icon_btn tooltip-examples" title="" style="float: right" onclick="deleteAccoupantNote(0,0)" data-original-title="Delete"></i>
                            <span class="clearence_list_text14">Note for test
                                                                        <br>

                                <span class="clearence_list_text12">4/6/2015 9:57:43 AM by 123
                                </span>
                            </span>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>
