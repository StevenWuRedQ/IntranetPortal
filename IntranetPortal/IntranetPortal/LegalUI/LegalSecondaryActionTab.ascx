<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActionTab.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActionTab" %>
<%@ Import Namespace="IntranetPortal.Data" %>
<%@ Import Namespace="IntranetPortal" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>
<div class="legalui short_sale_content">


    <div class="clearfix">
        <div style="float: right">
            <%--     <input type="button" id="btnComplete" class="rand-button short_sale_edit" value="Completed" runat="server" onserverclick="btnComplete_ServerClick" />
            <input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />--%>
        </div>
    </div>
    <div>
        <h4 class="ss_form_title">Tag Types
        </h4>
       
        <div dx-tag-box="{
            dataSource: [ <% For Each v In Utility.Enum2Dictinary(GetType(IntranetPortal.Data.LegalSencdaryType))%> {'id': <%=v.Key %>, 'text':'<%=v.Value%>'}, <% Next%> ],
            displayExpr: 'text',
            valueExpr: 'id',
             bindingOptions: {
           
            values: {
                deep: true,
                dataPath: 'LegalCase.SecondaryTypes'
            }
            }
        }
             ">
        </div>
    </div>
    <%-- Can't use cssSlideUp  class for animation becuase typeahead will get error  --%>
    <div class="ss_form clearfix" ng-show="CheckSecondaryTags(1)">

        <h4 class="ss_form_title">Order to show case <span style="transform: none; font-size: 12px;">(Mark as * need to fill other read only here)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download OSC Document" ng-click="DocGenerator('OSCTemplate.docx')"></i>

        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plantiff</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.Plantiff" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plantiff Attorney</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlantiffAttorney" readonly="readonly">
            </li>

            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">Plantiff Attorney Address *</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlantiffAttorneyAddress">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">FC filed Date:</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.FCFiledDate" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">FC Index #</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.FCIndexNum" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">County</label>
                <input class="ss_form_input" ng-model="LeadsInfo.BoroughName" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" ng-value="LeadsInfo.Block+'/'+ LeadsInfo.Lot" readonly="readonly">
            </li>
            <li class="ss_form_item " style="width: 97%">
                <label class="ss_form_input_title">Court Address </label>
                <input class="ss_form_input" ng-value="GetCourtAddress(LeadsInfo.Borough)" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant *</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Defendant">
            </li>
            <li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney *</label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.DefendantAttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DefendantAttorneyId">
            </li>
             <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant *</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Defendant">
            </li>
        </ul>
    </div>

    <div class="ss_form clearfix" ng-show="CheckSecondaryTags()">
        <h4 class="ss_form_title">OSC Other Defendants * <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.Defendants')" title="Add" style="font-size: 18px"></i></h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.Defendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.Defendants,$index)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
    </div>

    <%-- Deed Reversion doc  --%>
     <div class="ss_form clearfix" ng-show="CheckSecondaryTags(4)">

        <h4 class="ss_form_title">Deed Reversions <span style="transform: none; font-size: 12px;">(Mark as * need to fill other read only here)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download Deed Reversions Document" ng-click="DocGenerator('DeedReversionTemplate.docx')"></i>

        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plantiff</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionPlantiff" >
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plantiff Attorney</label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney" ng-change="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId">
            </li>
            
            <li class="ss_form_item">
                <label class="ss_form_input_title">Index #</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionIndexNum">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">County</label>
                <input class="ss_form_input" ng-model="LeadsInfo.BoroughName" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" ng-value="LeadsInfo.Block+'/'+ LeadsInfo.Lot" readonly="readonly">
            </li>
            <li class="ss_form_item " style="width: 97%">
                <label class="ss_form_input_title">Court Address </label>
                <input class="ss_form_input" ng-value="GetCourtAddress(LeadsInfo.Borough)" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant *</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionDefendant">
            </li>
            <%--<li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney *</label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.DefendantAttorneyId=null" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DefendantAttorneyId">
            </li>--%>
           
        </ul>
    </div>

    <div class="ss_form clearfix" ng-show="CheckSecondaryTags(4)">
        <h4 class="ss_form_title">Deed Reversions Other Defendants <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.DeedReversionDefendants')" title="Add" style="font-size: 18px"></i></h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.Defendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.DeedReversionDefendants,$index)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
    </div>
<%-- End deed reversion doc  --%>
     <div class="ss_formc ssSlideUp" ng-show="CheckSecondaryTags(2)">

        <h4 class="ss_form_title"> 
            Partitions
        </h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                Partitions test
            </li>
        </ul>


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
                            <option value="1">Partition            </option>
                            <option value="2">Breach of Contract   </option>
                            <option value="3">Quiet Title          </option>
                            <option value="4">Estate               </option>
                            <option value="5">Article 78           </option>
                            <option value="6">Declaratory Relief   </option>
                            <option value="7">Fraud                </option>
                            <option value="8">Deed Reversion       </option>
                            <option value="9">Other                </option>

                        </select>
                    </li>
                    <li class="ss_form_item">
                        <label class="ss_form_input_title">Index #</label>
                        <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.IndexNumber">
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
                        <input type="checkbox" id="pdf_check_yes106" name="131" class="ss_form_input" value="true" ng-model="LegalCase.SecondaryInfo.Servicecompleted">
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
                        <input type="checkbox" id="pdf_check_yes107" name="134" class="ss_form_input" value="true" ng-model="LegalCase.SecondaryInfo.ActionAnswered">
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



        </div>
        <uc1:legalsecondaryactions runat="server" ID="LegalSecondaryActions" />
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
