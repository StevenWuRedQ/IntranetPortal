<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleBuildingLiens.ascx.vb" Inherits="IntranetPortal.TitleBuildingLiens" %>
<div class="ss_form ">
    <h4 class="ss_form_title "></h4>
    <ul class="ss_form_box clearfix">
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Municipal Schedule</label>
            <input class="ss_form_input " ng-model="FormData.buildingLiens.Municipal_Schedule">
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Housing and Building Search</label>
            <pt-radio name="HousingandBuildingSearch0" model="FormData.buildingLiens.Housing_and_Building_Search"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="Housing_and_Building_Search_Upload" file-model="FormData.buildingLiens.Housing_and_Building_Search_Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Emergency Repairs search</label>
            <pt-radio name="EmergencyRepairssearch0" model="FormData.buildingLiens.Emergency_Repairs_search"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="Emergency_Repairs_search_Upload" file-model="FormData.buildingLiens.Emergency_Repairs_search_Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Fire Search</label>
            <pt-radio name="FireSearch0" model="FormData.buildingLiens.Fire_Search"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="Fire_Search_Upload" file-model="FormData.buildingLiens.Fire_Search_Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Street Report</label>
            <pt-radio name="StreetReport0" model="FormData.buildingLiens.Street_Report"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="Street_Report_Upload" file-model="FormData.buildingLiens.Street_Report_Upload"></pt-file>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Taxes and Water</label>
            <pt-radio name="TaxesandWater0" model="FormData.buildingLiens.Taxes_and_Water"></pt-radio>
        </li>
        <li class="ss_form_item ">
            <label class="ss_form_input_title ">Upload</label>
            <pt-file file-bble="" file-id="Taxes_and_Water_Upload" file-model="FormData.buildingLiens.Taxes_and_Water_Upload"></pt-file>
        </li>
        <li class="ss_form_item  ss_form_item_line">
            <label class="ss_form_input_title ">Notes</label>
            <textarea class="edit_text_area text_area_ss_form " model="FormData.buildingLiens.TitleBuildingLiens_Notes"></textarea>
        </li>
    </ul>
</div>
