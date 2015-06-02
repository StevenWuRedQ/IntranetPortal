<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActionTab.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActionTab" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<div class="short_sale_content">


    <div class="clearfix">
        <div style="float: right">
            <%--     <input type="button" id="btnComplete" class="rand-button short_sale_edit" value="Completed" runat="server" onserverclick="btnComplete_ServerClick" />
            <input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />--%>
        </div>
    </div>

    <div class="form-inline">
        <h4 class="ss_form_title" style="margin-bottom: 12px;">Select Types</h4>
        <select class="form-control" ng-model="LegalCase.SecondaryInfo.SelectedType" ng-change="SecondarySelectType()" ng-options='o as o for o  in SecondaryTypeSource' style="width: 94%; margin-top: -8px">
            <option value=""></option>
        </select>&nbsp; &nbsp; &nbsp; 
        <i class="fa  fa-plus-circle color_blue tooltip-examples icon_btn" style="display: none" ng-click="AddSecondaryArray()" title="Add" data-original-title="Add" style="font-size: 28px;"></i>
    </div>


    <div class="ss_array ">

        <h4 class="ss_form_title title_with_line  title_after_notes animate-show" ng-show="CheckShow('Statute Of Limitations')">
            <span class="title_index title_span">Statute of Limitation</span>&nbsp;
            <i class="fa fa-compress expand_btn color_blue icon_btn color_blue tooltip-examples" onclick="expand_array_item(this)" title="" data-original-title="Expand or Collapse"></i>
            &nbsp;<i class="fa fa-plus-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="AddArraryItem(event,this)" title="" data-original-title="Add"></i>
            <i class="fa fa-times-circle icon_btn color_blue tooltip-examples ss_control_btn" onclick="delete_array_item(this)" title="" data-original-title="Delete"></i>
        </h4>

        <div class="collapse_div" style="">

            <div class="ss_form animate-show" <%--ng-repeat="n in LegalCase.SecondaryInfo.StatuteOfLimitations track by $index" --%> ng-show="CheckShow('Statute Of Limitations')">
                <h4 class="ss_form_title">Action</h4>

                <ul class="ss_form_box clearfix">

                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Case Type</label>
                        <select class="ss_form_input" ng-model="LegalCase.SecondaryInfo.CaseType">
                            <option value="Partition">Partition            </option>
                            <option value="Breach of Contract">Breach of Contract   </option>
                            <option value="Quiet Title">Quiet Title          </option>
                            <option value="Estate">Estate               </option>
                            <option value="Article 78">Article 78           </option>
                            <option value="Declaratory Relief">Declaratory Relief   </option>
                            <option value="Fraud">Fraud                </option>
                            <option value="Deed Reversion">Deed Reversion       </option>
                            <option value="Other">Other                </option>

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
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Partition">
                    </li>
                
                    <li class="ss_form_item ss_form_item_line">
                        <label class="ss_form_input_title">note</label>
                        <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.ActionNotes"></textarea>
                    </li>
                </ul>

            </div>


            <uc1:legalsecondaryactions runat="server" ID="LegalSecondaryActions" />

        </div>
    </div>



    <div class="ss_form" style="padding-bottom: 20px;">
        <h4 class="ss_form_title">Legal  Notes </h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.LegalNotes"></textarea>
            </li>
        </ul>

    </div>


</div>
