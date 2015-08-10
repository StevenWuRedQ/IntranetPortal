<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPhotosTab.ascx.vb" Inherits="IntranetPortal.ConstructionPhotosTab" %>

<div class="ss_form">
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">AM Photos</label>
                <pt-file file-id="CSCase-Photos-AMPhotos" file-model="CSCase.Photos.AMPhotos" ></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">PM Photos</label>
                <pt-file file-id="CSCase-Photos-PMPhotos" file-model="CSCase.Photos.PMPhotos"></pt-file>
            </li>
        </ul>
    </div>
</div>

<div class="ss_form">
    <h4 class="ss_form_title">Metor Photos</h4>
    <div class="ss_border">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Electric Meter</label>
                <pt-file file-id="CSCase-Photos-ElectricMeter" file-model="CSCase.Photos.ElectricMeter"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Gas Meter</label>
                <pt-file file-id="CSCase-Photos-GasMeter" file-model="CSCase.Photos.GasMeter"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Water Meter</label>
                <pt-file file-id="CSCase-Photos-WaterMeter" file-model="CSCase.Photos.WaterMeter"></pt-file>
            </li>
        </ul>
    </div>
</div>


<div class="ss_form">

    <div class="ss_border">
        <ul class="ss_form_box clearfix">

            <li class="ss_form_item">
                <label class="ss_form_input_title">Process</label>
                <pt-file file-id="CSCase-Photos-Process" file-model="CSCase.Photos.WaterMeterProcess"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Appliances</label>
                <pt-file file-id="CSCase-Photos-Appliances" file-model="CSCase.Photos.Appliances"></pt-file>
            </li>
        </ul>
    </div>
</div>
