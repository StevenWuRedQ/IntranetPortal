<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LegalSecondaryActionTab.ascx.vb" Inherits="IntranetPortal.LegalSecondaryActionTab" %>
<%@ Import Namespace="IntranetPortal.Data" %>
<%@ Import Namespace="IntranetPortal" %>
<%@ Register TagPrefix="uc1" TagName="legalsecondaryactions" Src="~/LegalUI/LegalSecondaryActions.ascx" %>

<style>
    hr {
        border-color:#ff400d;
    }

    .title_with_color {
        color: #0D47A1;
    }

    .mandatory_star {
        color: red;
    }

    .mandatory_title {
        transform: none;
        font-size: 12px;
        font-style: italic;
        text-transform: none;
    }
    .ss_form_has_hr
    {
        margin-top:0px;
    }
</style>
<div class="legalui short_sale_content">

    <div class="clearfix">
        <div style="float: right">
            <%--     
            <input type="button" id="btnComplete" class="rand-button short_sale_edit" value="Completed" runat="server" onserverclick="btnComplete_ServerClick" />
			<input type="button" class="rand-button short_sale_edit" value="Save" ng-click="SaveLegal()"  />
            --%>
        </div>
    </div>
    <div>
        <h4 class="ss_form_title">Labels</h4>
        <%Dim Tags = DataStatu.LoadDataStatus(LegalCase.SecondaryTypeStatusCategory).ToArray %>
        <div dx-tag-box="{
			                dataSource: [ <% For Each v In Tags %> {'id': <%=v.Status %>, 'text':'<%=v.Name%>'} <%=IIf(v Is Tags.Last, "", ",") %> <% Next%> ],
			                displayExpr: 'text',
			                valueExpr: 'id',
			                bindingOptions: {
			                    values: {
				                    deep: true,
				                    dataPath: 'LegalCase.SecondaryTypes'
			                    }
			                }
		                }">
        </div>
    </div>
    <%-- Can't use cssSlideUp  class for animation becuase typeahead will get error  --%>

    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(1)">
        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(1) %> <span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download OSC Document" ng-click="DocGenerator('OSCTemplate.docx')"></i></h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.Plantiff" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff Attorney</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.PlantiffAttorney" readonly="readonly">
            </li>

            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">Plaintiff Attorney Address <span class="mandatory_star">*</span></label>
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
                <label class="ss_form_input_title">Defendant <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.Defendant">
            </li>
            <li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney <span class="mandatory_star">*</span></label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.DefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DefendantAttorneyId">
            </li>

        </ul>

        <h5 class="ss_form_title">OSC Other Defendants <span class="mandatory_star">*</span> <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.OSC_Defendants')" title="Add" style="font-size: 18px"></i></h5>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.OSC_Defendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.OSC_Defendants,$index, true)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
        <hr />
    </div>
    <%--FC defense/OSC--%>
    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(7)">
        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(7) %> <span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">FC Defense Attorney </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.FCDOSCDefenseAttorney" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.FCDOSCDefenseAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.FCDOSCDefenseAttorneyId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Index #</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.FCDOSCIndex" mask="999999/9999">
            </li>
            <li class="ss_form_item" style="width: 96%">
                <label class="ss_form_input_title">notes</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.FCDOSNotes"></textarea>
            </li>
        </ul>
        <hr />
    </div>
    <%--end FC defense/OSC--%>
    <%-- Partitions --%>
    <div class="ss_form ss_form_has_hr clearfix " ng-show="CheckSecondaryTags(2)">
        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(2) %>
            <span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download Partitions Document" ng-click="DocGenerator('Partition_Temp.docx')"></i>
        </h4>
        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">County</label>
                <input class="ss_form_input" ng-model="LeadsInfo.BoroughName" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsPlantiff">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant1 <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsDefendant1">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsDefendant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant Attorney</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsDefendantAttorney" ng-change="LegalCase.SecondaryInfo.PartitionsDefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.PartitionsDefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.PartitionsDefendantAttorneyId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Index # <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsIndexNum" mask="999999/9999">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Mortgage  Date <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsMortgageDate" pt-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Mortgage Amount <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsMortgageAmount" pt-number-mask maskformat='money'>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date of recording  <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsDateOfRecording " pt-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">CRFN # <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsCRFN">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input" ng-value="LeadsInfo.Block+'/'+ LeadsInfo.Lot" readonly="readonly">
            </li>
            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">Property Address</label>
                <input class="ss_form_input" ng-model="LeadsInfo.PropertyAddress" readonly>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff Attorney <span class="mandatory_star">*</span></label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsPlantiffAttorney" ng-change="LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff # </label>
                <input class="ss_form_input" ng-value="ptContactServices.getContact(LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).OfficeNO" readonly>
            </li>
            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">Plaintiff Attorney Address </label>
                <input class="ss_form_input" ng-value="ptContactServices.getContact(LegalCase.SecondaryInfo.PartitionsPlantiffAttorneyId, LegalCase.SecondaryInfo.PartitionsPlantiffAttorney).Address" readonly>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Original Lender <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.PartitionsOriginalLender" />
            </li>


        </ul>
        <hr />
    </div>

    <%------ end Partitions-------%>

    <%-- Deed Reversion doc  --%>
    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(4)">

        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(4) %> <span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download Deed Reversions Document" ng-click="DocGenerator('DeedReversionTemplate.docx')"></i>

        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionPlantiff">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff Attorney <span class="mandatory_star">*</span></label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorney" ng-change="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DeedReversionPlantiffAttorneyId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Index #(optional)</label>
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
            <li class="ss_form_item" style="width: 97%">
                <label class="ss_form_input_title">Plaintiff Attorney Address </label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionDefendantAttorney" ng-change="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionDefendant">
            </li>
            <li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney </label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.DeedReversionDefendantAttorneyId">
            </li>
        </ul>
        <h5 class="ss_form_title">Deed Reversions Other Defendants <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.DeedReversionDefendants')" title="Add" style="font-size: 18px"></i></h5>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.DeedReversionDefendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.DeedReversionDefendants,$index, true)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
        <hr />
    </div>

    <%-- End deed reversion doc  --%>

    <%--  SP doc --%>
    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(5)">

        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(5) %><span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download Specific Performance Complaint Document" ng-click="DocGenerator('SpecificPerformanceComplaintTemplate.docx')"></i>
        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.SPComplaint_Plantiff">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff Attorney <span class="mandatory_star">*</span></label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorney" ng-change="LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.SPComplaint_PlantiffAttorneyId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Index # (optional)</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.SPComplaint_IndexNum" mask="999999/9999">
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
                <label class="ss_form_input_title">Defendant <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.SPComplaint_Defendant">
            </li>
            <li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney </label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.SPComplaintnDefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.SPComplaintnDefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.SPComplaintnDefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.SPComplaintnDefendantAttorneyId">
            </li>
        </ul>

        <h5 class="ss_form_title">Specific Performance Complaint Other Defendants <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.SPComplaint_Defendants')" title="Add" style="font-size: 18px"></i></h5>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.SPComplaint_Defendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.SPComplaint_Defendants,$index, true)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
        <hr />
    </div>

    <%--  END SP doc --%>

    <%--Quiet Title doc--%>
    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(3)">

        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(3) %><span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
            <i class="fa fa-download icon_btn color_blue tooltip-examples" title="Download Quiet Title Complaint Document" ng-click="DocGenerator('QuietTitleComplantTemplate.docx')"></i>
        </h4>

        <ul class="ss_form_box  clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_Plantiff">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff Attorney <span class="mandatory_star">*</span></label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_PlantiffAttorney" ng-change="LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.QTA_PlantiffAttorneyId">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Index # (optional)</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_IndexNum" mask="999999/9999">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DATE OF DEED TO PLAINTIFF <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_DeedToPlaintiffDate" pt-date>
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
                <label class="ss_form_input_title">Defendant <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_Defendant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant lender 2 <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_Defendant2">
            </li>
            <li class="ss_form_item clearfix">
                <label class="ss_form_input_title">Defendant's Attorney </label>
                <input type="text" class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_DefendantAttorneyName" ng-change="LegalCase.SecondaryInfo.QTA_DefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.QTA_DefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.QTA_DefendantAttorneyId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Mortgagee <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_Mortgagee">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">ORIGINAL MORTGAGE LENDER	 <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.QTA_OrgMorgLender">
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">DATE OF LP </label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.FCFiledDate" disabled="disabled" pt-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">FC Index #</label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.FCIndexNum" readonly="readonly">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">DEFAULT DATE <span class="mandatory_star">*</span></label>
                <input class="ss_form_input" ng-model="LegalCase.ForeclosureInfo.QTA_DefaultDate" pt-date>
            </li>

        </ul>

        <h5 class="ss_form_title">Quiet Title Other Defendants <i class="fa fa-plus-circle icon_btn color_blue tooltip-examples" onclick="NGAddArrayitemScope('LegalCtrl','LegalCase.SecondaryInfo.QTA_Defendants')" title="Add" style="font-size: 18px"></i></h5>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item" ng-repeat="d in LegalCase.SecondaryInfo.QTA_Defendants track by $index">
                <label class="ss_form_input_title">Defendant {{$index +1}} <i class="fa fa-times icon_btn  tooltip-examples" ng-click="ptCom.arrayRemove(LegalCase.SecondaryInfo.QTA_Defendants,$index, true)" title="Delete" style="font-size: 18px"></i></label>
                <input type="text" class="ss_form_input" ng-model="d.Name">
            </li>
        </ul>
        <hr />
    </div>


    <%--End Quiet Tile Doc --%>
    <%--Misc. action doc--%>
    <div class="ss_form ss_form_has_hr clearfix" ng-show="CheckSecondaryTags(6)">

        <h4 class="ss_form_title title_with_color"><%=GetTypeByTag(6) %><span class="mandatory_title">(<span class="mandatory_star">*</span>Indicates required field)</span>
        </h4>

        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_Defendant">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Defendant's Attorney</label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_DefendantAttorney" ng-change="LegalCase.SecondaryInfo.MiscAction_DefendantAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.MiscAction_DefendantAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.MiscAction_DefendantAttorneyId">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Index # </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_IndexNum">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_Plaintiff">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Plaintiff's Attorney </label>
                <input class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_PlaintiffAttorney" ng-change="LegalCase.SecondaryInfo.MiscAction_PlaintiffAttorneyId=null" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue,3)" typeahead-on-select="LegalCase.SecondaryInfo.MiscAction_PlaintiffAttorneyId=$item.ContactId" bind-id="LegalCase.SecondaryInfo.MiscAction_PlaintiffAttorneyId">
            </li>
            <li class="ss_form_item" style="width: 96%">
                <label class="ss_form_input_title">Note</label>
                <textarea class="ss_form_input" ng-model="LegalCase.SecondaryInfo.MiscAction_Notes"></textarea>
            </li>
        </ul>
        <hr />
    </div>
    <%--end mis Action Doc--%>
    <div class="ss_form ss_form_has_hr" style="padding-bottom: 20px;">
        <h4 class="ss_form_title">Legal  Notes </h4>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ss_form_item_line">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form" ng-model="LegalCase.SecondaryInfo.LegalNotes"></textarea>
            </li>
        </ul>
    </div>

</div>
