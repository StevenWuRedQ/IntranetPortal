<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPhotosTab.ascx.vb" Inherits="IntranetPortal.ConstructionPhotosTab" %>

<div class="ss_form">
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">AM Photos</h5>
            <pt-files class="intakeCheck" file-bble="CSCase.BBLE" file-id="Photos_AMPhoto" file-model="CSCase.CSCase.Photos.AMPhotos" folder-enable="true" base-folder="Photos_AMPhoto"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">PM Photos</h5>
            <pt-files file-bble="CSCase.BBLE" file-id="Photos_PMPhotos" file-model="CSCase.CSCase.Photos.PMPhotos" folder-enable="true" base-folder="Photos_PMPhotos"></pt-files>
        </div>
    </div>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Meter Photos</h4>
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">Electric Meter</h5>
            <pt-files class="intakeCheck" file-bble="CSCase.BBLE" file-id="Photos_ElectricMeter" file-model="CSCase.CSCase.Photos.ElectricMeter" folder-enable="true" base-folder="Photos_ElectricMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Gas Meter</h5>
            <pt-files class="intakeCheck" file-bble="CSCase.BBLE" file-id="Photos_GasMeter" file-model="CSCase.CSCase.Photos.GasMeter" folder-enable="true" base-folder="Photos_GasMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Water Meter</h5>
            <pt-files class="intakeCheck" file-bble="CSCase.BBLE" file-id="Photos_WaterMeter" file-model="CSCase.CSCase.Photos.WaterMeter" folder-enable="true" base-folder="Photos_WaterMeter"></pt-files>
        </div>
    </div>
</div>


<div class="ss_form">
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">Progress</h5>
            <pt-files file-bble="CSCase.BBLE" file-id="Photos_Progress" file-model="CSCase.CSCase.Photos.WaterMeterProgress" folder-enable="true" base-folder="Photos_Progress"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Appliances</h5>
            <pt-files file-bble="CSCase.BBLE" file-id="Photos_Appliances" file-model="CSCase.CSCase.Photos.Appliances" file-columns="Model#|Serial#" folder-enable="true" base-folder="Photos_Appliances"></pt-files>
        </div>

    </div>
</div>
