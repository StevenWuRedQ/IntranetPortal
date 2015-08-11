<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionPhotosTab.ascx.vb" Inherits="IntranetPortal.ConstructionPhotosTab" %>

<div class="ss_form">
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">AM Photos</h5>
            <pt-files file-id="CSCase-Photos-AMPhotos" file-model="CSCase.Photos.AMPhotos"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">PM Photos</h5>
            <pt-file file-id="CSCase-Photos-PMPhotos" file-model="CSCase.Photos.PMPhotos"></pt-file>
        </div>
    </div>
</div>


<div class="ss_form">
    <h4 class="ss_form_title">Metor Photos</h4>
    <div class="ss_border">
        <div>
            <h5 class="ss_form_title">Electric Meter</h5>
            <pt-files file-id="CSCase-Photos-ElectricMeter" file-model="CSCase.Photos.ElectricMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Gas Meter</h5>
            <pt-files file-id="CSCase-Photos-GasMeter" file-model="CSCase.Photos.GasMeter"></pt-files>
        </div>
        <hr />
        <div>
            <h5 class="ss_form_title">Water Meter</h5>
            <pt-files file-id="CSCase-Photos-WaterMeter" file-model="CSCase.Photos.WaterMeter"></pt-files>
        </div>
    </div>
</div>


<div class="ss_form">

    <div class="ss_border">

        <div>
            <h5 class="ss_form_title">Process</h5>
            <pt-file file-id="CSCase-Photos-Process" file-model="CSCase.Photos.WaterMeterProcess"></pt-file>
        </div>
        <div>
            <h5 class="ss_form_title">Appliances</h5>
            <pt-file file-id="CSCase-Photos-Appliances" file-model="CSCase.Photos.Appliances"></pt-file>
        </div>

    </div>
</div>
