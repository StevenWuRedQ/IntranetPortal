<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialIntakeeTab.ascx.vb" Inherits="IntranetPortal.ConstructionInitialIntakeTab" %>
<div>
    <h4 class="ss_form_title">Intake&nbsp;<pt-collapse model="ReloadedData.IntakeCollapse" /></h4>
    <div class="ss_border" collapse="ReloadedData.IntakeCollapse">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Form</label>
                <button type="button" class="btn btn-primary" ng-click="openInitialForm()">Initial Form</button>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Budget</label>
                <button type="button" class="btn btn-primary" ng-click="openBudgetForm()">Initial Budget</button>
            </li>
        </ul>
        <%-- 
        <span style="color: red">Press Enter To Send Notification!</span>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind Intake Sheet</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.IntakeSheetRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Intake Sheet</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadIntakeSheet" file-model="CSCase.CSCase.InitialIntake.UploadIntakeSheet"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Is Intake Sheet Finished?</label>
                <pt-finished-mark class="intakeCheck" ss-model="CSCase.CSCase.InitialIntake.IsIntakeSheetFinished"></pt-finished-mark>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind Sketch Layout</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.SketchLayoutRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Sketch Layout</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadSketchLayout" file-model="CSCase.CSCase.InitialIntake.UploadSketchLayout"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Is Sketch Task Finished?</label>
                <pt-finished-mark class="intakeCheck" ss-model="CSCase.CSCase.InitialIntake.IsSketchFinished"></pt-finished-mark>
            </li>
        </ul>
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind Initial Budget</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.InitialBudgetRemind" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Initial Budget</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadInitialBudget" file-model="CSCase.CSCase.InitialIntake.UploadInitialBudget"></pt-file>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Is Intial Budget Task Finished?</label>
                <pt-finished-mark class="intakeCheck" ss-model="CSCase.CSCase.InitialIntake.IsInitialBudgetFinished"></pt-finished-mark>
            </li>
        </ul>
        --%>
    </div>
</div>

<div id="PropertyAddress_Div" class="ss_form">
    <h4 class="ss_form_title">Property Info&nbsp;<pt-collapse model="ReloadedData.PropertyAddress_Collapse"></pt-collapse></h4>
    <div class="ss_border" ng-click="ReloadedData.PropertyAddress_Popup = true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Block/Lot</label>
                <input class="ss_form_input intakeCheck" ng-value="CSCase.CSCase.InitialIntake.Block + '/' + CSCase.CSCase.InitialIntake.Lot">
            </li>
            <li class="ss_form_item" style="display: none">
                <label class="ss_form_input_title">BBLE</label>
                <input class="ss_form_input" ng-model="LeadsInfo.BBLE">
            </li>
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input intakeCheck" style="width: 93.3%" ng-model="CSCase.CSCase.InitialIntake.Address" pt-init-model="LeadsInfo.PropertyAddress">
            </li>
        </ul>
        <div collapse="!ReloadedData.PropertyAddress_Collapse">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Assigned</label>
                    <input class="ss_form_input intakeCheck" type="text" ng-model="CSCase.CSCase.InitialIntake.DateAssigned" ss-date>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Purchased</label>
                    <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DatePurchased" ss-date>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">ADT Code</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ADT">
                </li>

                <li class="clear-fix" style="list-style: none"></li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Access</label>
                    <select class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Access">
                        <option value="NA">N/A</option>
                        <option value="lockbox">lockbox</option>
                        <option value="master_key">master key</option>
                        <option value="pad_lock">pad lock</option>
                    </select>
                </li>
                <li class="ss_form_item nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.Access=='lockbox'">
                    <label class="ss_form_input_title">Lock Code</label>
                    <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.LockCode">
                </li>
                <li class="clear-fix" style="list-style: none"></li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Asset Manager</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AssetManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Project Manager</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ProjectManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                </li>
            </ul>
            <hr />
            <h5 class="ss_form_title">Building Info</h5>
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Total Units</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.TotalUnits" pt-init-model="SsCase.PropertyInfo.NumOfFamilies">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Building Class</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingClass" pt-init-model="LeadsInfo.PropertyClass">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Tax Class</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.TaxClass" pt-init-model="LeadsInfo.TaxClass">
                </li>

                <li class="ss_form_item">
                    <label class="ss_form_input_title">Year Built</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.YearBuilt" pt-init-model="LeadsInfo.YearBuilt">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Lot Size</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.LotSize" pt-init-model="LeadsInfo.LotDem">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Building Size</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingSize" pt-init-model="LeadsInfo.BuildingDem">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Building Stories</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingStories" pt-init-model="LeadsInfo.NumFloors">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Calculated Sqft</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CalculatedSqft">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">NYC Sqft</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.NycSqft" pt-init-model="LeadsInfo.NYCSqft">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Actual # Of Unit</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ActualUnitNum">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Zoning Code</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ZoningCode" pt-init-model="LeadsInfo.Zoning">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Max FAR</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.MaxFAR" pt-init-model="LeadsInfo.MaxFar">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Actual Far</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ActualFAR" pt-init-model="LeadsInfo.ActualFar">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Landmark</label>
                    <pt-radio class="intakeCheck" name="CSCase-InitialIntake-Landmark" model="CSCase.CSCase.InitialIntake.Landmark"></pt-radio>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Flood Zone</label>
                    <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.FloodZone">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Upload GeoData Report</label>
                    <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadGeoDataReport"></pt-link>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Upload C/O</label>
                    <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadCO"></pt-link>
                </li>
            </ul>
        </div>
    </div>
</div>
<div id="PropertyAddress_Popup" dx-popup="{  
                    width: 900,
                    height: 920,
                    title: 'Property Info',
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'ReloadedData.PropertyAddress_Popup' }
        }">
    <div data-options="dxTemplate:{ name: 'content' }">
        <div class="row">
            <div class="col-sm-4">
                <label class="ss_form_input_title">Block</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Block" pt-init-model="LeadsInfo.Block">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Lot</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Lot" pt-init-model="LeadsInfo.Lot">
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-10">
                <label class="ss_form_input_title">Address</label>
                <input class="ss_form_input intakeCheck" style="width: 93.3%" ng-model="CSCase.CSCase.InitialIntake.Address" pt-init-model="LeadsInfo.PropertyAddress">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Date Assigned</label>
                <input class="ss_form_input intakeCheck" type="text" ng-model="CSCase.CSCase.InitialIntake.DateAssigned" ss-date>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DatePurchased" ss-date>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">ADT Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ADT">
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Access</label>
                <select class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Access">
                    <option value="NA">N/A</option>
                    <option value="lockbox">lockbox</option>
                    <option value="master_key">master key</option>
                    <option value="pad_lock">pad lock</option>
                </select>
            </div>
            <div class="col-sm-4 nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.Access=='lockbox'">
                <label class="ss_form_input_title">Lock Code</label>
                <input class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.LockCode">
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Asset Manager</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AssetManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Project Manager</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ProjectManager" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </div>
        </div>
        <hr />
        <h4 class="clearfix ss_form_title">Building Info</h4>
        <div class="row">
            <div class="col-sm-4">
                <label class="ss_form_input_title">Total Units</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.TotalUnits" pt-init-model="SsCase.PropertyInfo.NumOfFamilies">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Building Class</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingClass" pt-init-model="LeadsInfo.PropertyClass">
            </div>

            <div class="col-sm-4">
                <label class="ss_form_input_title">Tax Class</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.TaxClass" pt-init-model="LeadsInfo.TaxClass">
            </div>

            <div class="col-sm-4">
                <label class="ss_form_input_title">Year Built</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.YearBuilt" pt-init-model="LeadsInfo.YearBuilt">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Lot Size</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.LotSize" pt-init-model="LeadsInfo.LotDem">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Building Size</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingSize" pt-init-model="LeadsInfo.BuildingDem">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Building Stories</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.BuildingStories" pt-init-model="LeadsInfo.NumFloors">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Calculated Sqft</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CalculatedSqft">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">NYC Sqft</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.NycSqft" pt-init-model="LeadsInfo.NYCSqft">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Actual # Of Unit</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ActualUnitNum">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Zoning Code</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ZoningCode" pt-init-model="LeadsInfo.Zoning">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Max FAR</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.MaxFAR" pt-init-model="LeadsInfo.MaxFar">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Actual Far</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.ActualFAR" pt-init-model="LeadsInfo.ActualFar">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Landmark</label>
                <pt-radio class="intakeCheck" name="CSCase-InitialIntake-Landmark" model="CSCase.CSCase.InitialIntake.Landmark"></pt-radio>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Flood Zone</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.FloodZone">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload GeoData Report</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadGeoDataReport" file-model="CSCase.CSCase.InitialIntake.UploadGeoDataReport"></pt-file>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload C/O</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadCO" file-model="CSCase.CSCase.InitialIntake.UploadCO"></pt-file>
            </div>
        </div>
    </div>
</div>


<div id="InitialTake_Owner_Div" class="ss_form">
    <h4 class="ss_form_title">Owner&nbsp;<pt-collapse model="ReloadedData.Owner_Collapse"></pt-collapse></h4>
    <div class="ss_border" ng-click="ReloadedData.InitialTake_Owner_Popup=true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Name</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.CorpName" pt-init-model="EntityInfo.CorpName">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.Addr" pt-init-model="EntityInfo.Address">
            </li>
        </ul>


        <ul class="ss_form_box clearfix" collapse="!ReloadedData.Owner_Collapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.TaxIdNum" pt-init-model="EntityInfo.EIN">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.Signor" pt-init-model="EntityInfo.Signor">
            </li>
            <li class="ss_form_item clearfix"></li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadDeed"></pt-link>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadEIN"></pt-link>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadFilingReceipt"></pt-link>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadArticleOfOperation"></pt-link>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadOperationAgreement"></pt-link>
            </li>
        </ul>
    </div>
</div>
<div id="InitialTake_Owner_Popup" dx-popup="{  
                    width: 900,
                    height: 450,
                    title: 'Owner',
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'ReloadedData.InitialTake_Owner_Popup' }
        }">
    <div data-options="dxTemplate:{ name: 'content' }">
        <div class="row">

            <div class="col-sm-4">
                <label class="ss_form_input_title">Corporation Name</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.CorpName" pt-init-model="EntityInfo.CorpName">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.Addr" pt-init-model="EntityInfo.Address">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Tax Id #</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.TaxIdNum" pt-init-model="EntityInfo.EIN">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Signor</label>
                <input class="ss_form_input " ng-model="CSCase.CSCase.InitialIntake.Signor" pt-init-model="EntityInfo.Signor">
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload Deed</label>
                <pt-file class="" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadDeed" file-model="CSCase.CSCase.InitialIntake.UploadDeed"></pt-file>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload EIN</label>
                <pt-file class="" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadEIN" file-model="CSCase.CSCase.InitialIntake.UploadEIN"></pt-file>
            </div>

            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload Filing Receipt</label>
                <pt-file class="" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadFilingReceipt" file-model="CSCase.CSCase.InitialIntake.UploadFilingReceipt"></pt-file>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload Article of Operation</label>
                <pt-file class="" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadArticleOfOperation" file-model="CSCase.CSCase.InitialIntake.UploadArticleOfOperation"></pt-file>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload Operation Agreement</label>
                <pt-file class="" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadOperationAgreement" file-model="CSCase.CSCase.InitialIntake.UploadOperationAgreement"></pt-file>
            </div>

        </div>
    </div>
</div>

<div id="InitialTake_Comps_Div" class="ss_form">
    <h4 class="ss_form_title">Comps&nbsp;<pt-collapse model="ReloadedData.CompsCollapse" /></h4>
    <div class="ss_border" ng-click="ReloadedData.InitialTake_Comps_Popup = true">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Resale Range Min</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CompsMin" money-mask>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Resale Range Max</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Comps" money-mask>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" collapse="!ReloadedData.CompsCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind AM</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CompsRemind" ng-change="ONCHANGE" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload Comps</label>
                <pt-link pt-model="CSCase.CSCase.InitialIntake.UploadComps"></pt-link>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Is Comps Task Finished?</label>
                <pt-finished-mark class="intakeCheck" ss-model="CSCase.CSCase.InitialIntake.IsCompsFinished"></pt-finished-mark>
            </li>
        </ul>
    </div>
</div>
<div id="InitialTake_Comps_Popup" dx-popup="{  
                    width: 900,
                    height: 450,
                    title: 'Comps',
                    dragEnabled: true,
                    showCloseButton: true,
                    shading: false,
                    bindingOptions:{ visible: 'ReloadedData.InitialTake_Comps_Popup' }
        }">
    <div data-options="dxTemplate:{ name: 'content' }">
        <div class="row">
            <div class="col-sm-4">
                <label class="ss_form_input_title">Resale Range Min</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CompsMin" money-mask>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Resale Range Max</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Comps" money-mask>
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Remind AM</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CompsRemind" ng-change="ONCHANGE" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Upload Comps</label>
                <pt-file class="intakeCheck" file-bble='CSCase.BBLE' file-id="InitialIntake-UploadComps" file-model="CSCase.CSCase.InitialIntake.UploadComps"></pt-file>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Is Comps Task Finished?</label>
                <pt-finished-mark class="intakeCheck" ss-model="CSCase.CSCase.InitialIntake.IsCompsFinished"></pt-finished-mark>
            </div>
        </div>
    </div>
</div>



<%-- 
<div class="ss_form">
    <h4 class="ss_form_title">Job Type
        <select ng-model="CSCase.CSCase.InitialIntake.JobType1">
            <option value="NA">N/A</option>
            <option value="ALT1">ALT1</option>
            <option value="ALT2">ALT2</option>
            <option value="ALT2_EXT">ALT2 Extension</option>
            <option value="Complated_Demo">Complated Demo</option>
        </select>
        <select ng-model="CSCase.CSCase.InitialIntake.JobType2" ng-show="CSCase.CSCase.InitialIntake.JobType1=='Complated_Demo'">
            <option value="NA">N/A</option>
            <option value="ALT1">ALT1</option>
            <option value="ALT2">ALT2</option>
        </select>
    </h4>
</div>
<div class="ss_form">
    <h4 class="ss_form_title">Reports
    <select ng-model="CSCase.CSCase.InitialIntake.ReportsDropDown">
        <option value="NA">N/A</option>
        <option value="Asbestos">Asbestos Report</option>
        <option value="Survey">Survey</option>
        <option value="Exhibit">Exhibit 1 & 3</option>
        <option value="TRs">TR's</option>
    </select></h4>
    <div class="ss_border" style="padding-bottom: 20px">
        <ul class="ss_form_box clearfix nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Asbestos'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.AsbestosRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.AsbestosReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AsbestosVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-AsbestosUpload" file-model="CSCase.CSCase.InitialIntake.AsbestosUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Survey'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.SurveyRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.SurveyReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.SurveyVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-SurveyUpload" file-model="CSCase.CSCase.InitialIntake.SurveyUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='Exhibit'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.ExhibitRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.ExhibitReceivedDate" ss-date>
            </li>

            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ExhibitVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-ExhibitUpload" file-model="CSCase.CSCase.InitialIntake.ExhibitUpload"></pt-file>
            </li>
        </ul>
        <ul class="ss_form_box clearfix nga-fast nga-slide-left" ng-show="CSCase.CSCase.InitialIntake.ReportsDropDown=='TRs'">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Requested</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.TRsRequestDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Date Received</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.TRsReceivedDate" ss-date>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Vendor</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.TRsVendor" ng-change="" typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Upload</label>
                <pt-file file-bble='CSCase.BBLE' file-id="InitialIntake-TRsUpload" file-model="CSCase.CSCase.InitialIntake.TRsUpload"></pt-file>
            </li>
        </ul>
    </div>
</div>
--%>
