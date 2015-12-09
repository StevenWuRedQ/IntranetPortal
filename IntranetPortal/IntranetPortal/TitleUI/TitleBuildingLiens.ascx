<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitleBuildingLiens.ascx.vb" Inherits="IntranetPortal.TitleBuildingLiens" %>
<div class="ss_form ">
    <h4 class="ss_form_title ">Municipal Schedule</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title">Housing and Building Search</label>
                <pt-radio name="HousingandBuildingSearch0" model="Form.FormData.buildingLiens.Housing_and_Building_Search"></pt-radio>
            </li>
            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Housing_and_Building_Search">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Housing_and_Building_Search_Upload" file-model="Form.FormData.buildingLiens.Housing_and_Building_Search_Upload"></pt-file>
            </li>
            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Housing_and_Building_Search">
                <label class="ss_form_input_title">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.buildingLiens.Housing_and_Building_Search_Date" ss-date></input>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Housing_and_Building_Search">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.buildingLiens.Housing_and_Building_Search_Note"></textarea>
                <hr class='ss-form-hr' />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title">Emergency Repairs search</label>
                <pt-radio name="Emergency_Repairs_search" model="Form.FormData.buildingLiens.Emergency_Repairs_search"></pt-radio>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Emergency_Repairs_search">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Emergency_Repairs_search_Upload" file-model="Form.FormData.buildingLiens.Emergency_Repairs_search_Upload"></pt-file>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Emergency_Repairs_search">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.buildingLiens.Emergency_Repairs_search_Date" ss-date></input>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Emergency_Repairs_search">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.buildingLiens.Emergency_Repairs_search_Note"></textarea>
                <hr class='ss-form-hr' />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title">Fire Search</label>
                <pt-radio name="FireSearch0" model="Form.FormData.buildingLiens.Fire_Search"></pt-radio>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Fire_Search">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Fire_Search_Upload" file-model="Form.FormData.buildingLiens.Fire_Search_Upload"></pt-file>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Fire_Search">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.buildingLiens.Fire_Search_Date" ss-date></input>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Fire_Search">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.buildingLiens.Fire_Search_Note"></textarea>
                <hr class='ss-form-hr' />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item ">
                <label class="ss_form_input_title">Street Report</label>
                <pt-radio name="StreetReport0" model="Form.FormData.buildingLiens.Street_Report"></pt-radio>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Street_Report">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Street_Report_Upload" file-model="Form.FormData.buildingLiens.Street_Report_Upload"></pt-file>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Street_Report">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.buildingLiens.Street_Report_Date" ss-date></input>
            </li>

            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Street_Report">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.buildingLiens.Street_Report_Note"></textarea>
                <hr class='ss-form-hr' />
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Taxes and Water</label>
                <pt-radio name="TaxesandWater0" model="Form.FormData.buildingLiens.Taxes_and_Water"></pt-radio>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Taxes_and_Water">
                <label class="ss_form_input_title ">Upload</label>
                <pt-file file-bble="BBLE" upload-type="title" file-id="Taxes_and_Water_Upload" file-model="Form.FormData.buildingLiens.Taxes_and_Water_Upload"></pt-file>
            </li>

            <li class="ss_form_item nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Taxes_and_Water">
                <label class="ss_form_input_title ">Date Last Modified</label>
                <input class="ss_form_input" type="text" ng-model="Form.FormData.buildingLiens.Taxes_and_Water_Date" ss-date></input>
            </li>
            <li class="clearfix"></li>
            <li class="ss_form_item_line nga-fast nga-fade" ng-show="Form.FormData.buildingLiens.Taxes_and_Water">
                <label class="ss_form_input_title">Note</label>
                <textarea class="edit_text_area text_area_ss_form " ng-model="Form.FormData.buildingLiens.Taxes_and_Water_Note"></textarea>
                <hr class='ss-form-hr' />
            </li>
        </ul>
        <div class="ss_form_item_line">
            <label class="ss_form_input_title ">Addtional Notes</label>
            <textarea class="edit_text_area text_area_ss_form" ng-model="Form.FormData.buildingLiens.TitleBuildingLiens_Notes"></textarea>
        </div>
    </div>
</div>
