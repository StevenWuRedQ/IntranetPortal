<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPhotosTab.ascx.vb" Inherits="IntranetPortal.ConstructionPhotosTab" %>

<div class="ss_form">
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">AM Photos</h5>
            <pt-files file-bble="CSCase.BBLE" file-id="CSCase-Photos-AMPhoto"  file-Name="" file-model="CSCase.CSCase.Photos.AMPhotos"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">PM Photos</h5>
            <pt-file file-id="CSCase-Photos-PMPhotos" file-model="CSCase.CSCase.Photos.PMPhotos"></pt-file>
        </div>
    </div>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Meter Photos</h4>
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">Electric Meter</h5>
            <pt-files file-id="CSCase-Photos-ElectricMeter" file-model="CSCase.CSCase.Photos.ElectricMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Gas Meter</h5>
            <pt-files file-id="CSCase-Photos-GasMeter" file-model="CSCase.CSCase.Photos.GasMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Water Meter</h5>
            <pt-files file-id="CSCase-Photos-WaterMeter" file-model="CSCase.CSCase.Photos.WaterMeter"></pt-files>
        </div>
    </div>
</div>


<div class="ss_form">

    <div class="ss_border">

        <div>
            <h5 class="ss_form_title">Progress</h5>
            <pt-file file-id="CSCase-Photos-Progress" file-model="CSCase.CSCase.Photos.WaterMeterProgress"></pt-file>
        </div>
        <div>
            <h5 class="ss_form_title">Appliances</h5>
            <pt-file file-id="CSCase-Photos-Appliances" file-model="CSCase.CSCase.Photos.Appliances"></pt-file>
        </div>

    </div>
</div>
