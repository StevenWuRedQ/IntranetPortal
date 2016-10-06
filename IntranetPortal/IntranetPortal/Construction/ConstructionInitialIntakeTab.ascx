<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="ConstructionInitialIntakeeTab.ascx.vb" Inherits="IntranetPortal.ConstructionInitialIntakeTab" %>
<div>
    <h4 class="ss_form_title">Intake&nbsp;<pt-collapse model="ReloadedData.IntakeCollapse" /></h4>
    <div class="ss_border" uib-collapse="ReloadedData.IntakeCollapse">
        <ul class="ss_form_box clearfix">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Form</label>
                <button type="button" class="btn btn-primary" ng-click="openInitialForm()">Initial Form</button>
                &nbsp
                <button type="button" class="btn btn-info btn-circle icon_btn" popover-placement="right" uib-popover-template="'intake'" ng-style="CSCase.CSCase.InitialIntake.InitialFormAssign?{'background-color': '#5cb85c'}:{}"><i class="fa fa-share"></i ></button>
                <script type="text/ng-template" id="intake">
                <div>
                    <h3 class="label label-info">Assign to</h3>

                    <hr>
                    <span  ng-repeat="x in RUNNER_LIST" >
                        <input type="radio" style="display: inline-block" ng-model="CSCase.CSCase.InitialIntake.InitialFormAssign" ng-value="x" >&nbsp;{{x}}
                        <br>
                    </span>
                    <br>
                    
                </div>
                </script>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Budget</label>
                <button type="button" class="btn btn-primary" ng-click="openBudgetForm()">Initial Budget</button>
            </li>
        </ul>
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
        <div uib-collapse="!ReloadedData.PropertyAddress_Collapse">
            <ul class="ss_form_box clearfix">
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Assigned</label>
                    <input class="ss_form_input intakeCheck" type="text" ng-model="CSCase.CSCase.InitialIntake.DateAssigned" pt-date>
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Date Purchased</label>
                    <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DatePurchased" pt-date>
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
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AssetManager" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
                </li>
                <li class="ss_form_item">
                    <label class="ss_form_input_title">Project Manager</label>
                    <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ProjectManager" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
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
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Address" pt-init-model="LeadsInfo.PropertyAddress">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Date Assigned</label>
                <input class="ss_form_input intakeCheck" type="text" ng-model="CSCase.CSCase.InitialIntake.DateAssigned" pt-date>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Date Purchased</label>
                <input class="ss_form_input" type="text" ng-model="CSCase.CSCase.InitialIntake.DatePurchased" pt-date>
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
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.AssetManager" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Project Manager</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.ProjectManager" ng-change="" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="">
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
            <li class="ss_form_item" style="width: 66.6%">
                <label class="ss_form_input_title">Corporation Address</label>
                <input class="ss_form_input " style="width: 93.3%" ng-model="CSCase.CSCase.InitialIntake.Addr" pt-init-model="EntityInfo.Address">
            </li>
        </ul>


        <ul class="ss_form_box clearfix" uib-collapse="!ReloadedData.Owner_Collapse">
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
            <div class="col-sm-8">
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
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CompsMin" pt-number-mask maskformat='money'>
            </li>
            <li class="ss_form_item">
                <label class="ss_form_input_title">Resale Range Max</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Comps" pt-number-mask maskformat='money'>
            </li>
        </ul>
        <ul class="ss_form_box clearfix" uib-collapse="!ReloadedData.CompsCollapse">
            <li class="ss_form_item">
                <label class="ss_form_input_title">Remind AM</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CompsRemind" ng-change="ONCHANGE" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
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
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.CompsMin" pt-number-mask maskformat='money'>
            </div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Resale Range Max</label>
                <input class="ss_form_input intakeCheck" ng-model="CSCase.CSCase.InitialIntake.Comps" pt-number-mask maskformat='money'>
            </div>
            <div class="clearfix"></div>
            <div class="col-sm-4">
                <label class="ss_form_input_title">Remind AM</label>
                <input type="text" class="ss_form_input" ng-model="CSCase.CSCase.InitialIntake.CompsRemind" ng-change="ONCHANGE" uib-typeahead="contact.Name for contact in ptContactServices.getContacts($viewValue)" typeahead-on-select="sendNotice($item.ContactId, $item.Name)">
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